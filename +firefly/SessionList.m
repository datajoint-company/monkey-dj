%{
# List of sessions
monk_sess_id                : varchar(20)       # unique id 'monk_id-sess_id' as 'xx-yyy'
---
experiment_name             : varchar(20)       # name of the experiment
monk_name                   : varchar(20)       # name of the subject
monk_id                     : int               # monkey id
session_date                : date              # the date in YYYY-MM-DD
session_id                  : int               # session id
units                       : int               # Analyse all units? (sorted units=0; all units=1)
folder                      : varchar(256)      # location of raw datafiles
electrode_type              : blob              # choose from linearprobe16, linearprobe24, linearprobe32, utah96, utah2x48
electrode_coord             : tinyblob          # recording location on grid (row, col, depth)
brain_area                  : blob              # cell array of strings, choose from PPC, VIP, MST, PFC
eyechannels                 : tinyblob          # [lefteye righteye], 0 for none; 1 for eye-coil; 2 for eye-tracker
comments                    : blob              # session-specific remarks
%}
classdef SessionList < dj.Lookup
    properties
        contents = {
            '01-001' 'firefly' 'Dylan' 01 '2023-01-27' 01 0 'C:\Users\jaero\Desktop\Data\angelaki\sample_data\Dylan\Dylan_01272023' {'utah96'}  [0 0 0] {'PPC'} [0 1] {'four densities, no landmarks, no ptb, random DCI, random ITI'}
            '01-002' 'firefly' 'Dylan' 01 '2023-01-30' 02 0 'C:\Users\jaero\Desktop\Data\angelaki\sample_data\Dylan\Dylan_01302023_EMs' {'utah96'}  [0 0 0] {'PPC'} [0 1] {'four densities, no landmarks, no ptb, random DCI, random ITI'}
            }
    end
end