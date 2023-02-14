clear all;

schema_names = {'firefly'};

initialize_schema(schema_names);  

% % Bring the schema name into the namespace as a struct format 
% % Tables defined under the schema can be acessed with e.g.,
% % dj_{schema_name}.{table_name} (dj_firefly.Subject)
% 
% for i = 1 : numel(schema_names)
%     clear schema
%     schema_name = schema_names{i};
%     eval(['import ', schema_name, '.getSchema;']);
%     eval(['schema = ', schema_name, '.getSchema();']);
% 
%     for j = 1:numel(schema.classNames)
%         tbl_name = split(schema.classNames{j}, '.');
%         tbl_name = join(tbl_name{2:end}, '.');
%         eval(['dj_', schema_name, '.(tbl_name) = schema.v.(tbl_name);']);
%     end 
%    
%     eval(['dj_', schema_name, '.schema = schema;']);
% end
% clearvars -except dj*

function initialize_schema(schema_names)
    
    % Load configuration
    dj.config();
    dj.config.load('.\dj_local_conf.json');
    
    global databasePrefix
    databasePrefix = dj.config().custom.databasePrefix;

    for i = 1 : numel(schema_names)
        
        schema_name = schema_names{i};
       
        % First create the schema if it does not exist
        try 
            query(dj.conn, sprintf('CREATE SCHEMA `%s`', [databasePrefix, schema_name]));
            fprintf("`%s` schema has been created\n", [databasePrefix, schema_name]);
        catch
        end
    
        % Create tables under that schema.
        % Get all table definitions from .m files in the schema folder.
        dj_tables = dir(fullfile(sprintf("+%s", schema_name), "*.m"));
        
        for j = 1 : numel(dj_tables)
    
            tbl_name = split(dj_tables(j).name, '.');
            tbl_name = tbl_name{1};
            if tbl_name == "getSchema"; continue; end
            try
                eval([schema_name, '.(tbl_name)'])  % Create the table.
                fprintf("%s.%s table has been created\n\n", schema_name, tbl_name)
            catch err
                disp(err);
                warning("%s.%s table couldn't be created\n", schema_name, tbl_name)
                continue
            end
        end
    
    end
    
end


