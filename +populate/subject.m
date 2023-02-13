function subject()
    % Populate the subject table.
    subjects = ReadYaml('./data/subject.yml');
    for i = 1 : numel(subjects)
        insert(firefly.Subject, subjects{i});
    end
end

