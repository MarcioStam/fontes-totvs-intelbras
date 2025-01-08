define {1} variable h-acomp   as handle   no-undo.

define {1} temp-table MsgErro no-undo
   field SeqErro  as integer     format '>>9'
   field DescErro as character   format 'x(120)'
   index idErro   is primary unique SeqErro.

