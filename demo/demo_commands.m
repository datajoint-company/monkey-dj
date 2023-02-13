% Example matlab commands
% Install datajoint from Add-Ons first.

% dj.version  % print out the version
% dj.conn  % connect to the database
% dj.close  % close database connection

% % Create database schema
% query(dj.conn, sprintf('CREATE SCHEMA `%s`', 'databasePrefix_firefly')) %

% firefly.Behavior  % instantiate the table. 
% drop(firefly.Subject)  % drop the table.
% draw(dj.ERD(firefly.getSchema))  % draw ERD.
% firefly.getSchema().dropQuick  % drop the schema.