%{
# Recording sessions
-> firefly.Subject
session_date                 : date             # the date in mmddYYYY
---
# add additional attributes
experimenter=''              : varchar(32)      
session_dir                  : varchar(258)     # relative path to the data directory for a session
session_note=''              : varchar(258)     
%}

classdef Session < dj.Manual
end