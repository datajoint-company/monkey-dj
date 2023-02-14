function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    global databasePrefix
    schemaObject = dj.Schema(dj.conn, 'firefly', [databasePrefix, 'firefly']);
end
obj = schemaObject;
end
