function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    global databasePrefix
    schemaObject = dj.Schema(dj.conn, 'firefly_prev', [databasePrefix, 'firefly_prev']);
end
obj = schemaObject;
end
