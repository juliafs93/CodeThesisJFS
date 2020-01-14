function[trace_struct_final] = CleanTracesmHHM(info, Nicknames,Selection,NewTimeRes,Mode)
%%
trace_struct_final = struct;

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
for i = [1:length(Index)]
        x = Index(i);
        %
        Parameters = info(x,:);
        Table2Vars(Parameters);
        PathToSave = [Path,File,Name,File]; 
        load([PathToSave,'_Data.mat']);
        try 
            MaxF = Data.MaxF;
            MedFilt = Data.MedFilt;
            OnOff = double(Data.OnOff);
            Baseline = Data.Baseline;
            Properties = Data.Properties;
        catch
            MaxF = Data.Data.MaxF;
            MedFilt = Data.Data.MedFilt;
            OnOff = double(Data.Data.OnOff);
            Baseline = Data.Data.Baseline;
            Properties = Data.Data.Properties;
        end

            %Struct2Vars(Data);
            %Struct2Vars(Data);

        if ~strcmp(Selection,'')
        	if strcmp(Selection,'EarlyOnly')
                Selected = find([Properties.Type=='EarlyOnly']); 
            end
            if strcmp(Selection,'ME')==1
                Selected = find([Properties.Region=='ME']); 
            end
            if strcmp(Selection,'MSE')==1
                Selected = find([Properties.Region=='MSE']); 
            end
            if strcmp(Selection,'NE')==1
                Selected = find([Properties.Region=='NE']); 
            end
            if strcmp(Selection,'DE')==1
                Selected = find([Properties.Region=='DE']); 
            end
        else
            Selected = find([Properties.Type=='ShortMidline'|Properties.Type=='LongMidline']);
        end
        
        %TimeScale in seconds!
        TimeScale = ([1:Frames] - nc14+Delay).*TimeRes;
        NewTimeScale = [(1- nc14+Delay).*TimeRes:NewTimeRes:(Frames-nc14+Delay).*TimeRes];
        switch Mode
            case 1
                NormF = (MedFilt-Baseline').*OnOff.*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 2
                NormF = MedFilt.*OnOff.*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 3
                NormF = (MedFilt-Baseline').*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 4
                NormF = MedFilt.*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 5
                NormF = (MaxF-Baseline').*OnOff.*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 6
                NormF = MaxF.*OnOff.*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 7
                NormF = (MaxF-Baseline')*Baseline(1)./Baseline'.*2.^(12-Bits);
            case 8
                NormF = MaxF.*Baseline(1)./Baseline'.*2.^(12-Bits);
        end
        NormF(NormF < 0) = 0;
        NormF(isnan(NormF)) = 0;
        %NormF = imresize(NormF,[size(NormF,1)*TimeRes./NewTimeRes,size(NormF,2)]);
        for n = 1:length(Selected)
            trace = [NormF(:,Selected(n))]';
            % interpolate F values to new interpolated times
            trace_struct_final(end+1).fluo_interp = interp1(TimeScale,trace,NewTimeScale)
            trace_struct_final(end).time_interp = [NewTimeScale];
            trace_struct_final(end).alpha_frac = 1200/5200;
            % grouping vector, usually AP bin, but can be anything. here
            % experiment/genotype
            trace_struct_final(end).group_vec_interp = repmat(Exp,1,length(NormF(:,Selected(n))));
            trace_struct_final(end).group_label = [info.Nickname{Index(i)},' ',num2str(info.Rep(Index(i))),' ',Selection];
            trace_struct_final(end).ParticleID = size(trace_struct_final,2);
            trace_struct_final(end).Label = Properties.Label(Selected(n));
            trace_struct_final(end).Tres = NewTimeRes;
        end
        

end
end

trace_struct_final(1) = [];
end