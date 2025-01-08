define variable pid as integer   no-undo.
define variable i   as integer   no-undo.

assign pid = integer(session:parameter).

repeat i = 1 to num-dbs:
   create alias dictdb for database value (ldbname(i)) no-error.
   run esp/es0036b.p (input pid).
   delete alias dictdb.
end.

quit.
