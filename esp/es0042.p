define variable ped as integer   no-undo.
define variable rpw as character no-undo.

assign rpw = entry(2,session:parameter)
       ped = integer(entry(3,session:parameter)).

find ped_exec exclusive-lock
   where ped_exec.num_ped_exec = ped no-error.
if available ped_exec then
   delete ped_exec.

quit.
