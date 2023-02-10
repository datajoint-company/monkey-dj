function obj = getSchema
persistent schemaObject
global databasePrefix
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'firefly', sprintf('%s_firefly', databasePrefix));
end
obj = schemaObject;
end
