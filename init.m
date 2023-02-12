clear all;

schema_names = {'firefly'};

for i = 1 : numel(schema_names)

    virtual_module = initialize_schema(schema_names{i});
    eval(['dj_', schema_names{i}, ' = (virtual_module);']);
    
end    

clear virtual_module i

function virtual_module = initialize_schema(schema_name)

    % Load configuration
    dj.config();
    dj.config.load('.\dj_local_conf.json');
    
    global databasePrefix
    
    databasePrefix = dj.config().custom.databasePrefix;
    
    % Bring the schema name into the namespace as a struct format 
    % Tables defined under the schema can be acessed with e.g.,
    % dj_{schema_name}.{table_name} (dj_firefly.Session)
            
    clear schema
    
    % First create the schema if it does not exist
    try 
        query(dj.conn, sprintf('CREATE SCHEMA `%s`', [databasePrefix, schema_name]));
        fprintf("`%s` schema has been created\n", [databasePrefix, schema_name]);
    catch
    end

    eval(['import ', schema_name, '.getSchema;']);
    eval(['schema = ', schema_name, '.getSchema();']);

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

    for j = 1:numel(schema.classNames)
        tbl_name = split(schema.classNames{j}, '.');
        tbl_name = join(tbl_name{2:end}, '.');
        eval(['virtual_module.(tbl_name) = schema.v.(tbl_name);']);
    end 
   
    eval(['virtual_module.schema = schema;']);
    
    
end


