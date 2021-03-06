function[] = mhmm_interference_fun(trace_struct_final,bin_groups,Tres,w,K,inference_times,t_window,n_bootstrap)
%% Script to Conduct Windowed HMM Inference 
% This script reads in interpolated time series data and conducts mhmmm
% inference for the memory (w), state count (K), and data groupings
% (bin_groups) specified
%%%---------------------------------------------------------------------%%%
% Key variables that must be present in data structure:
    % 1) time_interp: interpolated time vector
    % 2) fluo_interp: interpolated fluorescence vector (experimentally observed
    %    quanity)
    % 3) group_vec_interp: vector indicating trace group membership at each
    %    time point. For instance, in Drosophila, this is some quantity derived
    %    from the position a trace along the AP axis.
    % 4) alpha_frac: fractional length of MS2 loops relative to full
    %    transcript. For instance, if MS2 length is 1302 and transcript
    %    length is 6444, alpha_frac = 1302/6444
    % 5) ParticleID: unique trace (particle) identifier
    
%%%---------------------------------------------------------------------%%%


%-------------------------------System Vars-------------------------------%
%bin_groups = num2cell(1:1:length(Nicknames)); % cell array containing region grouping for inference
%bin_groups = {-1,1}; % cell array containing region grouping for inference
%Tres = TimeRes; % Time Resolution
%w = 2*60./Tres % Memory % elongation time / TimeRes
%K = 2; % State to use for inference
%inference_times = (7.5:2.5:40)*60;%
%inference_times = [35]*60;%
%t_window = 15*60; % determines width of sliding window
%t_window = 30*60; % determines width of sliding window

%------------------Define Inference Variables------------------------------%
n_localEM = 25; % set num local runs (default=25)
n_steps_max = 500; % set max steps per inference (default=500)
eps = 1e-4; % set convergence criteria (keep at 1e-4)
%MaxWorkers = 25; % maximum number of parpool workers that can be supported
MaxWorkers = 4; % maximum number of parpool workers that can be supported 

%----------------------------Bootstrap Vars-------------------------------%
%n_bootstrap = 10; % number of bootstraps 
%n_bootstrap = 1; % number of bootstraps 
sample_size = 8000; % N data points to use 
min_dp_per_inf = 1250; % inference will be aborted if fewer present  

%-------------------Load Data and Set Write Paths-------------------------%
%datapath = ['../../dat/' project '/']; %Path to inference data
%dataname = 'trace_struct_final.mat'; %name of inference set
% Load data for inference into struct named: trace_struct_final
%load([datapath dataname]);
alpha = trace_struct_final(1).alpha_frac*w; % Rise Time for MS2 Loops in time steps

% Set write path (inference results are now written to external directory)
id_string =  ['/w' num2str(w) '_t' num2str(Tres)...
    '_alpha' num2str(round(alpha*10)) '/K' num2str(K) '_tw' num2str(t_window/60) '/'];
out_dir = [FolderPath project '/' id_string '/out'];
mkdir(out_dir);



% get trace start and end times for each trace
first_time_vec = [];
last_time_vec = [];
for i = 1:length(trace_struct_final)
    % for windowed inference ignore first and alst w time steps
    trace_struct_final(i).time_interp = trace_struct_final(i).time_interp(w+1:end-w-1);    
    first_time_vec = [first_time_vec min(trace_struct_final(i).time_interp)];
    last_time_vec = [last_time_vec max(trace_struct_final(i).time_interp)];
end
%% Conduct Inference

for g = 1:length(bin_groups) % loop through different AP groups
    disp(['bin ',num2str(g),'/',num2str(length(bin_groups))])
    bin_list = bin_groups{g}; % get groups for present iteration         
    for t = 1:length(inference_times)
        disp(['t ',num2str(t),'/',num2str(length(inference_times))])
        t_inf = inference_times(t); % identify current inference time
        t_start = t_inf - t_window/2;
        t_stop = t_inf + t_window/2;
        % generate time-resolved AP reference vector
        position_ref_vec = NaN(1,length(trace_struct_final));
        for i = 1:length(trace_struct_final)
            tt = trace_struct_final(i).time_interp;
            gp = trace_struct_final(i).group_vec_interp;            
            tr_ap = round(mean(gp(tt>=t_start&tt<t_stop))); % use average position         
            position_ref_vec(i) = tr_ap;
        end        
        for b = 1:n_bootstrap % iterate through bootstrap replicates
            disp(['bin',num2str(g),'/',num2str(length(bin_groups)),', t',num2str(t),'/',num2str(length(inference_times)),' boots',num2str(b),'/',num2str(n_bootstrap)])
            iter_start = now;
            % structures of store inference info
            local_struct = struct; % track results of each local run            
            output = struct; % final output structure saved to file
            
            % Use current time as unique inference identifier (kind of unwieldly)
            inference_id = num2str(round(10e5*now));
            
            % Generate filenames            
            fName_sub = [project '_w' num2str(w) '_K' num2str(K) ...
                '_bin' num2str(round(10*bin_list(1))) '_' num2str(round(10*bin_list(end))) ...
                '_time' num2str(round(t_inf/60)) '_t' inference_id];                
            out_file = [out_dir '/' fName_sub];            
            
            % Extract fluo_data for that position bin
            trace_filter = ismember(position_ref_vec,bin_list) & (last_time_vec-w*Tres) >= t_start ...
                    & (first_time_vec+w*Tres) < t_stop;            
            trace_ind = find(trace_filter);
            
            inference_set = []; % find eligible traces
            for m = 1:length(trace_ind)
                temp = trace_struct_final(trace_ind(m));
                tt = temp.time_interp;
                ft = temp.fluo_interp;
                temp.time_interp = tt(tt>=t_start & tt < t_stop);
                temp.fluo_interp = ft(tt>=t_start & tt < t_stop);
                if sum(temp.fluo_interp>0) > 1 % exclude strings of pure zeros
                    inference_set = [inference_set temp];
                end
            end
            skip_flag = 0;
            if ~isempty(inference_set)
                set_size = length([inference_set.fluo_interp]);                 
            end
            if isempty(inference_set)
                skip_flag = 1;
            elseif set_size < min_dp_per_inf                    
                skip_flag = 1;                    
            end
            if skip_flag
                warning('Too few data points. Skipping')                
            else % proceed with inference if there is sufficient data
                sample_index = 1:length(inference_set);
                % take bootstrap samples
                ndp = 0;    
                sample_ids = [];                    
                % reset bootstrap size to be on order of set size for small bins
                if set_size < sample_size
                    sample_size = ceil(set_size/1000)*1000;
                end
                while ndp < sample_size
                    tr_id = randsample(sample_index,1);
                    sample_ids = [sample_ids tr_id];
                    ndp = ndp + length(inference_set(tr_id).time_interp);
                end                
                fluo_data = cell([length(sample_ids), 1]); % traces used for inference
                sample_particles = [inference_set(sample_ids).ParticleID];
                for tr = 1:length(sample_ids)
                    fluo_data{tr} = inference_set(sample_ids(tr)).fluo_interp;                                        
                end 
                
                % random initialization of parameters for iid inference
                param_init = initialize_random (K, w, fluo_data);
                % approximate inference assuming iid data for param initialization     
                % iid results used as basis for full inference
                local_iid_out = local_em_iid_reduced_memory_truncated (fluo_data, param_init.v, ...
                                    param_init.noise, K, w, alpha, n_steps_max, eps);
                noise_iid = 1/sqrt(exp(local_iid_out.lambda_log));
                v_iid = exp(local_iid_out.v_logs);         
                
                % we can do local EM runs in parallel
                p = gcp('nocreate');
                if isempty(p)
                    parpool; 
                elseif p.NumWorkers > MaxWorkers
                    delete(gcp('nocreate')); % if pool with too many workers, delete and restart
                    parpool(MaxWorkers);
                end
                parfor i_local = 1:n_localEM % Parallel Local EM                
                    % random initialization of model parameters
                    param_init = initialize_random_with_priors(K, noise_iid, v_iid);
                    % get intial values
                    pi0_log_init = log(param_init.pi0);
                    A_log_init = log(param_init.A);
                    v_init = param_init.v;                        
                    noise_init = param_init.noise;                    
                    %--------------------LocalEM Call-------------------------%
                    local_out = local_em_MS2_reduced_memory_truncated(fluo_data, ...
                        v_init, noise_init, pi0_log_init', A_log_init, K, w, ...
                        alpha, n_steps_max, eps);                    
                    %---------------------------------------------------------%                
                    % Save Results 
                    local_struct(i_local).inference_id = inference_id;
                    local_struct(i_local).subset_id = i_local;
                    local_struct(i_local).logL = local_out.logL;                
                    local_struct(i_local).A = exp(local_out.A_log);
                    local_struct(i_local).v = exp(local_out.v_logs).*local_out.v_signs;
                    local_struct(i_local).r = exp(local_out.v_logs).*local_out.v_signs / Tres;                                
                    local_struct(i_local).noise = 1/exp(local_out.lambda_log);
                    local_struct(i_local).pi0 = exp(local_out.pi0_log);
                    local_struct(i_local).total_steps = local_out.n_iter;               
                    local_struct(i_local).soft_struct = local_out.soft_struct;               
                end 
                
                [logL, max_index] = max([local_struct.logL]); % Get index of best result                    
                % Save parameters from most likely local run
                output.pi0 =local_struct(max_index).pi0;                        
                output.r = local_struct(max_index).r(:);                
                output.noise = local_struct(max_index).noise;
                output.A = local_struct(max_index).A(:);
                output.A_mat = local_struct(max_index).A;                            
                % Info about run time
                output.total_steps = local_struct(max_index).total_steps;                                  
                output.total_time = 100000*(now - iter_start);                                                         
                % other inference characteristics
                output.group_vec = min(bin_list):max(bin_list); % inf group info
                output.t_window = t_window;
                output.t_inf = t_inf;                                                
                output.iter_id = b;                                                 
                output.particle_ids = sample_particles;
                output.N = ndp;                
                output.w = w;
                output.alpha = alpha;
                output.Tres = Tres;   
                % to use later
                output.soft_struct = local_struct(max_index).soft_struct;
                output.fluo_data = fluo_data;
            end
            output.skip_flag = skip_flag;
            save([out_file '.mat'], 'output');           
        end  
    end
end    
end