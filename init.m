% clear all

% Load configuration
dj.config();
dj.config.load('.\dj_local_conf.json')

global databasePrefix
databasePrefix = dj.config().custom.databasePrefix

schema_names = {'firefly'};

% Bring the schema name into the namespace as a struct format 
% Tables defined under the schema can be acessed with e.g.,
% dj_{schema_name}.{table_name} (dj_firefly.Session)
for k = 1: numel(schema_names)
    clear schema
    schema_name = schema_names{k};
    eval(['import ', schema_name, '.getSchema']);
    eval(['schema = ', schema_name, '.getSchema();'])
    
    for j = 1:numel(schema.classNames)
        tbl_name = split(schema.classNames{j}, '.');
        tbl_name = join(tbl_name{2:end}, '.');
        eval(['dj_', schema_name, '.(tbl_name) = schema.v.(tbl_name);']);
    end 
    
    eval(['dj_', schema_name, '.schema = schema;'])
end
