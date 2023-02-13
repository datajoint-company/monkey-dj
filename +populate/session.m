function session()    
    % Populate the session table.
    root_data_dir = dj.config().custom.raw_root_data_dir;
    subjects = fetch(firefly.Subject);
    
    for subject_ind = 1 : numel(subjects)
        
        subject_name = subjects(subject_ind).subject_name;
        subject_dir = [root_data_dir '/' subject_name];
        session_dirs = dir(subject_dir);
        session_dirs(1:2) = [];
        
        for session_ind = 1 : numel(session_dirs)
    
            % Store values in a struct for insertion
            session_str = split(session_dirs(session_ind).name, '_');
            session.subject_name = session_str{1};
            dt = datetime(session_str{2}, 'InputFormat', 'MMddyyyy');
            dt.Format = 'yyyy-MM-dd';
            session.session_date = string(dt);
            session.session_dir = session_dirs(session_ind).name;
            
            % Insert session
            insert(firefly.Session, session);
    
        end
    end
end