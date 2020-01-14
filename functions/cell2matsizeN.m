function[st3_1mat] = cell2matsizeN(st3_1,N)
st3_1mat = zeros(size(st3_1,2),N);
for i = 1:size(st3_1,2)
    Trace = st3_1{i};
    st3_1mat(i,1:length(Trace)) = Trace;
    %plot(st3_1{i}); hold on
end