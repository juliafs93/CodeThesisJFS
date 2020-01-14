function[handles] = Struct2Handles(Data, handles)
    Struct = Data.Data;
    for x = 1:length(fieldnames(Struct))
        Vars = fieldnames(Struct);
        %NewField = Struct(Vars{x});
        command = ['handles.',Vars{x}, ' = Struct.',Vars{x},''];
        evalc(command);
    end
end