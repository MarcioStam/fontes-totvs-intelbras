/************************************************************************
* Programa.: upc\sf0104-upc.p
* Autor....: Graziely Lima - iDBA
* Data.....: MAR€O/2022 - Desenvolvimento
* Descricao: UPC para cria‡Æo da flag "Desativado - NÆo considera APS"
* Versäes..: 01 - 03/2022 - Graziely - iDBA
*          : 02 - 04/2023 - Mauricio - iDBA - Envio email conforme regras
*          : 03 - 06/2023 - Mauricio - iDBA - Limitar CTrab 8 caracteres
*************************************************************************/
{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{esp/es0018.i}
{utp/utapi019.i}
DEFINE VARIABLE h-frame          AS HANDLE  NO-UNDO.
DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.
DEFINE VARIABLE ProgramHandle    as handle  no-undo.
DEFINE VARIABLE ProgramHandle2   as handle  no-undo.
DEFINE VARIABLE i-aux            as integer no-undo.

DEFINE NEW GLOBAL SHARED VAR vRowEstrutura AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-folder    AS WIDGET-HANDLE NO-UNDO.

def new global shared var wh-ctrab-sf0104-upc  as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-tg-consid-aps     AS WIDGET-HANDLE NO-UNDO.
def new global shared var wgh-frame-sf0104-upc as widget-handle no-undo.

define new global shared temp-table tt-sf0104-upc no-undo
    field rw-ctrab  as rowid
    field gm-codigo like ctrab.gm-codigo
    field log-1     like ctrab.log-1.

DEFINE VARIABLE c-folder AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.

def buffer bctrab for ctrab.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

/* message "P-ind-event  = " p-ind-event    skip        */
/*           "P-ind-object = " p-ind-object skip        */
/*           "P-wgh-object = " p-wgh-object skip        */
/*           "P-wgh-frame  = " p-wgh-frame  skip        */
/*           "P-cod-table  = " p-cod-table  skip        */
/*           "p-row-table  = " string(p-row-table) skip */
/*           "c-objeto     = " c-objeto                 */
/*           view-as alert-box.                         */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
and c-objeto     = 'sf0104.w'
then do:
     assign ProgramHandle = session:first-procedure
            i-aux         = 0.

     /* Verifica quantas instƒncias do programa h  na mem¢ria */
     do while valid-handle(ProgramHandle):
         if ProgramHandle:file-name = "sfc/sf0104.w"
         or ProgramHandle:file-name = "sfc\sf0104.w"
         then assign i-aux          = i-aux + 1
                     ProgramHandle2 = ProgramHandle.

         assign ProgramHandle = ProgramHandle:next-sibling.
     end.

     if i-aux > 1
     then do:
          run utp\ut-msgs.p(input "show", input 19085, input "SF0104 j  est  aberto!").
          delete procedure ProgramHandle2.
          return "NOK".
     end.

     assign wh-ctrab-sf0104-upc  = ?
            wh-tg-consid-aps     = ?
            wgh-frame-sf0104-upc = p-wgh-frame.
end.

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "CONTAINER" 
and c-objeto     = "sf0104.w"
and not valid-handle(wh-tg-consid-aps)
THEN DO:
     CREATE TOGGLE-BOX wh-tg-consid-aps
     ASSIGN FRAME        = p-wgh-frame
            WIDTH        = 30
            HEIGHT       = 0.88
            ROW          = 3.3
            LABEL        = "Desativado - NÆo considera APS"
            COLUMN       = 40.5
            SENSITIVE    = NO
            VISIBLE      = YES.

     empty temp-table  tt-sf0104-upc.
END.

if  p-ind-event  = "INITIALIZE" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v01in513.w"
then run pi-recupera-campo (input p-wgh-frame,
                            input "fill-in",
                            input "cod-ctrab",
                            output wh-ctrab-sf0104-upc).

if  p-ind-event  = "VALIDATE" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v01in513.w"
and valid-handle(wh-ctrab-sf0104-upc)
and wh-ctrab-sf0104-upc:sensitive
and length(trim(wh-ctrab-sf0104-upc:screen-value)) > 8
then do:
     run utp/ut-msgs.p (input "show", input 17567, input "C¢digo Centro Trabalho " + trim(wh-ctrab-sf0104-upc:screen-value) + " excede o limite de 8 caracteres!").    
     return 'NOK'.
end.

IF p-ind-event   = "ASSIGN" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v03in513.w"
and valid-handle(wh-tg-consid-aps)
and can-find(first ctrab where
                   rowid(ctrab) = p-row-table
                   no-lock) 
THEN do: 
     for FIRST bctrab WHERE ROWID(bctrab) = p-row-table exclusive-lock: end.

     ASSIGN bctrab.log-1 = wh-tg-consid-aps:CHECKED.
  
     for first tt-sf0104-upc 
         where tt-sf0104-upc.rw-ctrab = p-row-table: end.

     if not avail tt-sf0104-upc
     then RUN pi-envia-email (input "Implanta‡Æo",
                              input ?,
                              input "").
     else do:
          if  tt-sf0104-upc.gm-codigo = bctrab.gm-codigo
          and tt-sf0104-upc.log-1     = bctrab.log-1
          then.
          else RUN pi-envia-email (input "Altera‡Æo",
                                   input tt-sf0104-upc.log-1,
                                   input tt-sf0104-upc.gm-codigo).

          assign tt-sf0104-upc.gm-codigo = bctrab.gm-codigo
                 tt-sf0104-upc.log-1     = bctrab.log-1.
          find current tt-sf0104-upc no-error.
          release tt-sf0104-upc.
     end. /* else do */

     find current bctrab no-lock no-error.
     release bctrab.
END.

if  p-ind-event          = "DISPLAY" 
and p-ind-object         = "VIEWER" 
and c-objeto             = "v01in513.w"
and wgh-frame-sf0104-upc = p-wgh-frame:parent:parent
THEN DO:
     empty temp-table tt-sf0104-upc.

     FIND FIRST bctrab
          WHERE ROWID(bctrab) = p-row-table NO-LOCK NO-ERROR.

     if valid-handle(wh-tg-consid-aps)
     then do:
         IF AVAIL bctrab THEN 
             ASSIGN wh-tg-consid-aps:CHECKED = bctrab.log-1.
    
         assign wh-tg-consid-aps:SENSITIVE = NO.
     end.

     create tt-sf0104-upc.
     assign tt-sf0104-upc.rw-ctrab  = p-row-table
            tt-sf0104-upc.gm-codigo = bctrab.gm-codigo when avail bctrab
            tt-sf0104-upc.log-1     = bctrab.log-1     when avail bctrab.
     find current tt-sf0104-upc no-error.
     release tt-sf0104-upc.
END.

IF p-ind-event   = "AFTER-ENABLE" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v01in513.w"
and valid-handle(wh-tg-consid-aps)
and can-find(first ctrab where
                   rowid(ctrab) = p-row-table
                   no-lock)
THEN ASSIGN wh-tg-consid-aps:SENSITIVE = YES.

IF p-ind-event   = "AFTER-DISABLE" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v01in513.w"
and valid-handle(wh-tg-consid-aps)
THEN ASSIGN wh-tg-consid-aps:SENSITIVE = no.

IF p-ind-event   = "DELETE" 
and p-ind-object = "VIEWER" 
and c-objeto     = "v01in513.w"
and can-find(first ctrab where
                   rowid(ctrab) = p-row-table
                   no-lock) 
THEN RUN pi-envia-email (input "Elimina‡Æo",
                         input ?,
                         input "").

if  p-ind-event  = 'destroy'
and p-ind-object = 'container'
and c-objeto     = 'sf0104.w'
then do:
     assign wh-tg-consid-aps     = ?
            wgh-frame-sf0104-upc = ?.
     empty temp-table tt-sf0104-upc.
end.

PROCEDURE pi-envia-email:
    define input parameter p-acao-aux      as character no-undo.
    define input parameter p-log-1-ant     as logical   no-undo.
    define input parameter p-gm-codigo-ant as character no-undo.

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.
    DEF VAR c-emails      AS CHAR                  NO-UNDO.

    for first bctrab
        where rowid(bctrab) = p-row-table
              no-lock: end.

    FOR FIRST param-global NO-LOCK: END.

    RUN esp/es0018p.p (INPUT  "SF0104":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN c-emails = "".

    FOR EACH tt-prog-ponto:
        ASSIGN c-emails = c-emails + tt-prog-ponto.conteudo + ",".
    END.

    IF c-emails = ""
    or c-emails = ?
    then return "OK".

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */
           tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */
           tt-envio2.destino           = c-emails                /* Destinat rio       */
           tt-envio2.assunto           = p-acao-aux
                                       + " Centro Trabalho: "
                                       + trim(bctrab.cod-ctrab)  /* Assunto */
           tt-envio2.remetente         = "ems@intelbras.com.br"  /* Remetente          */
           tt-envio2.formato           = "TEXTO".

    FIND usuar_mestre WHERE
         usuar_mestre.cod_usuario = c-seg-usuario
         NO-LOCK NO-ERROR.

    ASSIGN c-corpo-email = tt-envio2.assunto
                         + chr(13)
                         + "Desativado - NÆo considera APS: "
                         + string(bctrab.log-1,"Sim/NÆo")
                         + CHR(13)
                         + "Grupo M quina: "
                         + trim(bctrab.gm-codigo)
                         + CHR(13)
                         + "Usuario: "
                         + c-seg-usuario
                         + " - "
                         + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

    if p-acao-aux = "Altera‡Æo"
    then assign c-corpo-email = c-corpo-email
                              + CHR(13)
                              + " "
                              + CHR(13)
                              + "VALORES ANTERIORES:"
                              + CHR(13)
                              + "Desativado - NÆo considera APS (VALOR ANTERIOR): "
                              + string(p-log-1-ant,"Sim/NÆo")
                              + CHR(13)
                              + "Grupo M quina (VALOR ANTERIOR): "
                              + trim(p-gm-codigo-ant)
                              + CHR(13).

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK".
END PROCEDURE. /* PROCEDURE pi-envia-email */

procedure pi-recupera-campo:
    define input  parameter pWghFrame as widget-handle no-undo.
    define input  parameter pObjType  as character     no-undo.
    define input  parameter pObjName  as character     no-undo.
    define output parameter phObj     as handle        no-undo.

    define variable wgh-obj as widget-handle no-undo.

    assign wgh-obj = pWghFrame:first-child.

    do while valid-handle(wgh-obj):
        if  wgh-obj:type = pObjType 
        and wgh-obj:name = pObjName 
        then do:
             assign phObj = wgh-obj:handle.

             leave.
        end.

        if wgh-obj:type = "FIELD-GROUP":U 
        then assign wgh-obj = wgh-obj:first-child.
        else assign wgh-obj = wgh-obj:next-sibling.
    end.

    assign wgh-obj = ?.

    return "OK":U.
end procedure. /* procedure pi-recupera-campo */

