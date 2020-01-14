function[handles] = Table2Handles(Table,handles)
        for x = [1:length(Table.Properties.VariableNames)]
            Var = Table.Properties.VariableNames{x};
            Par = Table{1,x};
            if iscell(Par) == 1
                command = ['handles.',Var, ' = ''', Par{:},''''];
            end
            if isnumeric(Par) == 1
                command = ['handles.',Var, ' = ', num2str(Par)];
            end
            evalc(command);
        end
end