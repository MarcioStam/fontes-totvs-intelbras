/* ----------------------------------------------------------------------------
   Programa..: upc/cd0901-upc.p
   Data......: 12/04/2023
   Autor.....: Andrey M Oliveira
---------------------------------------------------------------------------- */

define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

DEF VAR c-objeto   AS CHAR     NO-UNDO.

/* Global Variable Definitions **********************************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
define new global shared var adm-broker-hdl as handle no-undo.
define new global shared var h-folder       as handle no-undo.
define new global shared var h-viewer-1     as handle no-undo.
define new global shared var h-viewer-2     as handle no-undo.

define new global shared var wgh-folder     as handle no-undo.

define new global shared var txt-label-seq     as widget-handle no-undo.
define new global shared var wh-convenio       as widget-handle no-undo.
define new global shared var h-programa        as handle        no-undo.
define new global shared var wgh-window        as widget-handle no-undo.

define new global shared var whInsEstadual     as widget-handle no-undo.
define new global shared var whInsEstadualCob  as widget-handle no-undo.
define new global shared var whContribIcms     as widget-handle no-undo.
define new global shared var whInsEstadualAnt  as widget-handle no-undo.
define new global shared var whContribIcmsAnt  as widget-handle no-undo.

define new global shared var wh-bt-socios-cd0704 as widget-handle no-undo.
define new global shared var whCodEmitente       as widget-handle no-undo.

define new global shared var whCodRota      as widget-handle no-undo.
define new global shared var whCidadeCif    as widget-handle no-undo.
define new global shared var whCodTransp    as widget-handle no-undo.
define new global shared var whDescTransp   as widget-handle no-undo.
define new global shared var whEstado       as widget-handle no-undo.
define new global shared var whEndereco     as widget-handle no-undo.
define new global shared var whEstadoLocal  as widget-handle no-undo.
define new global shared var whCidade       as widget-handle no-undo.
define new global shared var whPais         as widget-handle no-undo.
define new global shared var whTextEstado   as widget-handle no-undo.
define new global shared var whCep          as widget-handle no-undo.
define new global shared var whBairro       as widget-handle no-undo.
define new global shared var c-transp       as character no-undo.
define new global shared var c-rota         as character no-undo.
define new global shared var c-cidade-cif   as character no-undo.
define new global shared var l-assign       as logical   no-undo.
define new global shared var l-add          as logical   no-undo.

define new global shared var wh-objeto  as widget-handle no-undo.

define new global shared var wh-txt-ativo-cd0704   as widget-handle no-undo.
define new global shared var wh-ativo-cd0704       as widget-handle no-undo.
define new global shared var wh-txt-atualiz-cd0704 as widget-handle no-undo.
define new global shared var wh-seq-boleto  as widget-handle no-undo.
define new global shared var wh-bt-ativo-cd0704    as widget-handle no-undo.
define new global shared VAR wh-ins-banc1-cd0704   as widget-handle no-undo.
define new global shared VAR wh-ins-banc2-cd0704   as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR c-seg-usuario   AS   CHAR                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-motivo-cd0704 AS   CHAR                  NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-upc-cd0704           AS WIDGET-HANDLE NO-UNDO.

/* Variable Definitions *****************************************************/
define var c-folder         as character     no-undo.
define var c-objects        as character     no-undo.
define var h-object         as handle        no-undo.
define var i-objects        as integer       no-undo.
define var l-record-1       as logical       no-undo initial no.
define var l-group-assign-1 as logical       no-undo initial no.
define var l-state-1        as logical       no-undo initial no.
define var l-record-2       as logical       no-undo initial no.
define var l-group-assign-2 as logical       no-undo initial no.
define var l-state-2        as logical       no-undo initial no.
define var h-frame          as widget-handle no-undo. 
define var l-assign         as logical       no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/* MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK. */

{esp/es0018.i}

IF  p-ind-event = "destroy" THEN
    IF  VALID-HANDLE(h-upc-cd0704) THEN
        DELETE PROCEDURE h-upc-cd0704.

IF  p-ind-object = "VIEWER"
AND c-objeto     = "v05ad209.w" THEN DO:

    RUN piFindWidget(INPUT "fi-convenio", 
                     INPUT "fill-in", 
                     INPUT  p-wgh-frame, 
                     OUTPUT wh-convenio).

    IF  VALID-HANDLE(wh-convenio) THEN.

    CREATE TEXT txt-label-seq
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(13)"
           WIDTH        = 13
           SCREEN-VALUE = "Prox Boleto:"
           ROW          = 2.05
           COL          = 29
           VISIBLE      = YES
           FONT         = 1.

    CREATE FILL-IN wh-seq-boleto
    ASSIGN FRAME             = wh-convenio:FRAME
           SIDE-LABEL-HANDLE = txt-label-seq:HANDLE
           DATA-TYPE         = "INTEGER"
           FORMAT            = "99999" 
           WIDTH             = 8
           HEIGHT            = 0.88
           ROW               = 1.88
           COL               = 37.4
           LABEL             = "Prox Boleto:"
           VISIBLE           = YES
           SENSITIVE         = NO.

    IF  p-ind-event = "display" THEN DO:
    
        FIND FIRST mgcad.portador NO-LOCK 
             WHERE ROWID(mgcad.portador) = p-row-table NO-ERROR.

        IF  AVAIL mgcad.portador THEN DO:

            ASSIGN wh-seq-boleto:SCREEN-VALUE = string(mgcad.portador.int-4).
        END.
    END.
END.


PROCEDURE piFindWidget:
    define input  parameter c-widget-name  as char   no-undo.
    define input  parameter c-widget-type  as char   no-undo.
    define input  parameter h-start-widget as handle no-undo.
    define output parameter h-widget       as handle no-undo.

    do while valid-handle(h-start-widget):
        if  h-start-widget:name = c-widget-name 
        and h-start-widget:type = c-widget-type then do:
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if  h-start-widget:type = "field-group":u 
        or  h-start-widget:type = "frame":u 
        OR  h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if valid-handle(h-widget) then
                leave.
        end.
        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.
