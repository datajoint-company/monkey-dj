function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'firefly', 'jaeronga_firefly');
end
obj = schemaObject;
end
