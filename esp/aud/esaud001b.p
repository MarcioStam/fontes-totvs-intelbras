&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define input  parameter pDatabase   as character no-undo.
define input  parameter pTable      as character no-undo.
define input  parameter pPrimaryKey as character no-undo.
define output parameter cResult     as character no-undo.

define variable i as integer no-undo.

define variable hFile       as handle no-undo.
define variable hField      as handle no-undo.
define variable hIndex      as handle no-undo.
define variable hIndexField as handle no-undo.

define variable hQuery as handle no-undo.
define variable cQuery as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

create buffer hFile       for table pDatabase + "._file".
create buffer hField      for table pDatabase + "._field".
create buffer hIndex      for table pDatabase + "._index".
create buffer hIndexField for table pDatabase + "._index-field".

create query hQuery.
assign cResult = 'Chave prim ria:~r~n'
       i = 0.

assign cQuery = "for each " + pDatabase + "._file no-lock "
              + "   where _file._owner = '" + entry(1, pTable, '.') + "' "
              + "     and _file._file-name = '" + entry(2, pTable, '.') + "', "
              + "   each " + pDatabase + "._index of _file no-lock "
              + "   where _file._prime-index = recid(_index) "
              + "     and not _index._index-name eq 'default', "
              + "   each " + pDatabase + "._index-field of _index, "
              + "   first " + pDatabase + "._field of _index-field "
              + "         by _index-field._index-recid "
              + "         by _index-field._index-seq".

hQuery:set-buffers(hFile, hIndex, hIndexField, hField).

hQuery:query-prepare(cQuery).
hQuery:query-open().

repeat:
   hQuery:get-next().
   if hQuery:query-off-end then
      leave.
   assign i = i + 1
          cResult = cResult + '  - ' + hField:buffer-field('_field-name'):buffer-value() + ': ' + entry(i, pPrimaryKey, chr(7)) + '~r~n'.
end.

hQuery:query-close().
delete object hQuery.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


