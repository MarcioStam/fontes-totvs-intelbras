/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES0103RP 2.06.00.000}
/*------------------------------------------------------------------------
    File        : XX9999RP.P
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */

{esp/es0018.i}
{utp/utapi019.i}

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l½gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD tipo-data        AS INTEGER
    FIELD l-emails         AS LOG
    FIELD emails           AS CHAR.

{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-propath AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-registro NO-UNDO
    FIELD c-handle  AS CHAR. 

DEF VAR c-emails     AS CHAR NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */
FORM tt-registro.c-handle   AT 1 COLUMN-LABEL "Handles"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 320 FRAME f-report-banco.

FORM c-propath AT 1 COLUMN-LABEL "Propath"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 320 FRAME f-report-propath.



/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ************************  Function Prototypes ********************** */

FUNCTION fn-function RETURNS CHARACTER
  (  )  FORWARD.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

assign c-programa     = "ES0103"
       c-sistema      = "Monitor Banco"
       c-titulo-relat = "Monitor Banco"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

FIND FIRST tt-param NO-LOCK NO-ERROR.
ASSIGN c-emails     = tt-param.emails.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    /*VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.*/

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN esp/es0103a.p.
    RUN pi-cria-registros.

    IF tt-param.l-emails THEN
        RUN pi-envia-mail.

    RUN pi-imprime.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-cria-registros:


    DEFINE VARIABLE hTemp   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObject AS HANDLE               NO-UNDO.
    DEFINE VARIABLE vTemp   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE oObject AS Progress.Lang.Object NO-UNDO.
    DEFINE VARIABLE oTemp   AS Progress.Lang.Object NO-UNDO.

    ASSIGN c-propath = REPLACE(PROPATH,",",CHR(10)).

    ASSIGN hObject = SESSION:FIRST-DATASET.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "ProDataSet, Handle=" + STRING(hTemp) + ", Name=" + STRING(hTemp:NAME) /*+ ", Dynamic=" + STRING(hTemp:DYNAMIC)*/.
    END.

    ASSIGN hObject = SESSION:FIRST-DATA-SOURCE.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING
               vTemp   = (IF hTemp:QUERY = ? THEN ? ELSE hTemp:QUERY:PREPARE-STRING).

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "DataSource, Handle=" + STRING(hTemp) + ", Name=" + STRING(hTemp:NAME) + ", Query=" + STRING(vTemp).
    END.

    ASSIGN hObject = SESSION:FIRST-BUFFER.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "Buffer, Handle=" + STRING(hTemp) + ", Name=" + STRING(hTemp:NAME) + ", Table=" + STRING(hTemp:TABLE) + ", Dynamic=" + STRING(hTemp:DYNAMIC) /*+ ", DataSet=" + STRING(hTemp:DATASET)*/.
    END.

    ASSIGN hObject = SESSION:FIRST-PROCEDURE.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "Procedure, Handle=" + STRING(hTemp) + ", Name=" + STRING(hTemp:NAME).
    END.

    ASSIGN hObject = SESSION:FIRST-QUERY.
    DO WHILE hObject <> ?:
        ASSIGN hTemp   = hObject
               hObject = hObject:NEXT-SIBLING.

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "Query, Handle=" + STRING(hTemp) + ", Name=" + STRING(hTemp:NAME) + ", Dynamic=" + STRING(hTemp:DYNAMIC) /*+ ", Query=" + STRING(hTemp:PREPARE-STRING)*/.
    END.

    ASSIGN oObject = SESSION:FIRST-OBJECT.
    DO WHILE oObject <> ?:
        ASSIGN oTemp   = oObject
               oObject = oObject:NEXT-SIBLING.

        CREATE tt-registro.
        ASSIGN tt-registro.c-handle = "Object, Name=" + STRING(oTemp:ToString()). 
    END.

END PROCEDURE.

PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Relat¢rio...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Acompanhando...":U).

    PUT UNFORMATTED "Propath" SKIP.
    PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP.
    PUT UNFORMATTED c-propath SKIP.

    PUT UNFORMATTED SKIP(2).
    PUT UNFORMATTED "Handle" SKIP.
    PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP.

    FOR EACH tt-registro:

        PUT UNFORMATTED tt-registro.c-handle SKIP.
    
    END.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-envia-mail:

    IF NOT CAN-FIND(FIRST tt-registro) THEN NEXT.

    run pi-acompanhar in h-acomp (input "Gerando e-mail.").

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                             /* Destinat˜rio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
           tt-envio2.assunto           = "Monitor Banco " + tt-param.arquivo  /* Assunto            */
           tt-envio2.formato           = "TEXTO".


    IF CAN-FIND(FIRST tt-registro) THEN
        ASSIGN c-corpo-email = "Propath: " + CHR(10) + c-propath + CHR(10) + CHR(10) +
                               "Handles: " + CHR(10).

    FOR EACH tt-registro:
        ASSIGN c-corpo-email = c-corpo-email +
                               tt-registro.c-handle + CHR(10) + CHR(10).
    END.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    /*FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).*/

END.

/* ************************  Function Implementations ***************** */

FUNCTION fn-function RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  <none>
    Notes:  <none>
------------------------------------------------------------------------------*/
    RETURN "":U.

END FUNCTION.

