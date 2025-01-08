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

{esp/aud/esaud001tt.i}

define input  parameter pDatabase as character no-undo.
define output parameter table for ttAuditEvent.
define output parameter table for ttBanco.
define output parameter table for ttTabela.
define output parameter table for ttTabelaCampo.
define output parameter table for ttEvento.
define output parameter table for ttUsuario.

define variable i as integer no-undo.
define variable j as integer no-undo.
define variable c as character no-undo.

define variable hDBDetail     as handle no-undo.
define variable hAudAuditData as handle no-undo.

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

create buffer hDBDetail     for table pDatabase + "._db-detail" no-error.
create buffer hAudAuditData for table pDatabase + "._aud-audit-data" no-error.

if not hAudAuditData:can-read then do:
   message "Sem permiss∆o de leitura da auditoria neste banco"
      view-as alert-box info buttons ok.
   return error.
end.

create query hQuery.

assign cQuery = "for each " + pDatabase + "._db-detail no-lock, each " + pDatabase + "._aud-audit-data of " + pDatabase + "._db-detail no-lock".

hQuery:set-buffers(hDBDetail, hAudAuditData).
hQuery:query-prepare(cQuery).
hQuery:query-open().

repeat:
   hQuery:get-next().
   if hQuery:query-off-end then
      leave.

   do i = 1 to num-entries(hAudAuditData:buffer-field('_event-detail'):buffer-value(), chr(7)):
      create ttAuditEvent.
      assign ttAuditEvent.banco  = hDBDetail:buffer-field('_db-description'):buffer-value()
             ttAuditEvent.tabela = entry(1, hAudAuditData:buffer-field('_event-context'):buffer-value(), chr(6)).
      do j = 2 to num-entries(hAudAuditData:buffer-field('_event-context'):buffer-value(), chr(6)):
         assign ttAuditEvent.pk = entry(j, hAudAuditData:buffer-field('_event-context'):buffer-value(), chr(6)).
      end.

      assign ttAuditEvent.usuario = hAudAuditData:buffer-field('_user-id'):buffer-value()
         ttAuditEvent.data = hAudAuditData:buffer-field('_audit-date-time'):buffer-value().
      if trim(ttAuditEvent.usuario) = '' then
         assign ttAuditEvent.usuario = '<?>'.

      case int(hAudAuditData:buffer-field('_event-id'):buffer-value()):
         when 5100 then
            assign ttAuditEvent.evento = 'create'.
         when 5101 then
            assign ttAuditEvent.evento = 'update'.
         when 5102 then
            assign ttAuditEvent.evento = 'delete'.
      end case.

      assign c = entry(i, hAudAuditData:buffer-field('_event-detail'):buffer-value(), chr(7))
             j = int(entry(2, c, chr(6))).

      case j:
         when 1 then
            assign ttAuditEvent.tipo = 'char'.
         when 2 then
            assign ttAuditEvent.tipo = 'date'.
         when 3 then
            assign ttAuditEvent.tipo = 'log'.
         when 4 then
            assign ttAuditEvent.tipo = 'int'.
         when 5 then
            assign ttAuditEvent.tipo = 'dec'.
         when 7 then
            assign ttAuditEvent.tipo = 'recid'.
         when 8 then
            assign ttAuditEvent.tipo = 'raw'.
         when 11 then
            assign ttAuditEvent.tipo = 'memptr'.
         when 13 then
            assign ttAuditEvent.tipo = 'rowid'.
         when 18 then
            assign ttAuditEvent.tipo = 'blob'.
         when 19 then
            assign ttAuditEvent.tipo = 'clob'.
         when 34 then
            assign ttAuditEvent.tipo = 'datetime'.
         when 39 then
            assign ttAuditEvent.tipo = 'longchar'.
         when 40 then
            assign ttAuditEvent.tipo = 'datetime-tz'.

      end case.

      assign ttAuditEvent.campo = entry(1, c, chr(6))
         ttAuditEvent.antigo = entry(3, c, chr(6))
         ttAuditEvent.novo = entry(4, c, chr(6)).

      if not can-find (first ttBanco
                       where ttBanco.banco = ttAuditEvent.banco) then do:
         create ttBanco.
         assign ttBanco.banco = ttAuditEvent.banco.
      end.
      
      if not can-find (first ttTabela
                       where ttTabela.banco  = ttAuditEvent.banco
                         and ttTabela.tabela = ttAuditEvent.tabela) then do:
         create ttTabela.
         assign ttTabela.banco  = ttAuditEvent.banco
                ttTabela.tabela = ttAuditEvent.tabela.
      end.
   
      if not can-find (first ttTabelaCampo
                       where ttTabelaCampo.banco  = ttAuditEvent.banco
                         and ttTabelaCampo.tabela = ttAuditEvent.tabela
                         and ttTabelaCampo.campo  = ttAuditEvent.campo) then do:
         create ttTabelaCampo.
         assign ttTabelaCampo.banco  = ttAuditEvent.banco
                ttTabelaCampo.tabela = ttAuditEvent.tabela
                ttTabelaCampo.campo  = ttAuditEvent.campo.
      end.
   
      if not can-find (first ttEvento
                       where ttEvento.evento = ttAuditEvent.evento) then do:
         create ttEvento.
         assign ttEvento.evento = ttAuditEvent.evento.
      end.
   
      if not can-find (first ttUsuario
                       where ttUsuario.usuario = ttAuditEvent.usuario) then do:
         create ttUsuario.
         assign ttUsuario.usuario = ttAuditEvent.usuario.
      end.
   end.
end.

hQuery:query-close().
delete object hQuery.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


