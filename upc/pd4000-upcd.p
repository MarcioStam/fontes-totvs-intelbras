
def var wh-pesquisa as widget-handle.
def new global shared var l-implanta     as logical init no. 
def new global shared var wh-window      as handle       no-undo.
def new global shared var adm-broker-hdl as handle       no-undo.
def new global shared var wh-window      as handle no-undo.
DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-supervisor-pd4000      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-abrev-pd4000      AS WIDGET-HANDLE NO-UNDO.
assign l-implanta = NO.

                   
/*{include/zoomvar.i &prog-zoom=eszoom/z01es382.w
                   &proghandle=wh-window
                   &campohandle=wh-supervisor-pd4000
                   &campozoom=matricula}*/
                   
    FIND FIRST emitente
        WHERE emitente.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:

            IF int-emitente.ind-participa-canais = 993520001 THEN
                RUN esp/pdp/espdp082.w.
            ELSE DO:
                {method/zoomFields.i &ProgramZoom="eszoom/z01es382.w"
                                     &FieldZoom1="matricula"
                                     &frame1="fPage4"
                                     &fieldHandle1=wh-supervisor-pd4000}
            END.

        END.

    END.

                         

/*
    MESSAGE wh-supervisor-pd4000:SCREEN-VALUE
            wh-supervisor-pd4000:VALUE 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

WAIT-FOR GO OF wh-pesquisa.
ASSIGN wh-supervisor-pd4000:SCREEN-VALUE = wh-supervisor-pd4000:SCREEN-VALUE.
*/    

