%{
# Subject Information
subject_name           : varchar(16)              # name as string
-----
# add additional attributes
subject_id             : int                   # unique subject ID
species                : varchar(16)           
sex                    : enum ("M", "F", "U")  
description='' : varchar(64)
%}

classdef Subject < dj.Manual
end