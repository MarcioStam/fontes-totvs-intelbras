/***********************************************************************
**  Programa..: upc\im0055a-upc.p
**  Autor.....: Raphael
**  Data......: Fevereiro/2010
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}
{esp/es0018.i}
{utp/utapi019.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-cod-estabel     AS HANDLE        NO-UNDO.
DEFINE VARIABLE wh-embarque        AS HANDLE        NO-UNDO.
define variable wh-cod-itiner      as handle        no-undo.
DEFINE VARIABLE wh-cod-pto-contr   AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-programa                    AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window                    AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-dt-ult-previsao-im0055a AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-ult-previsao-im0055a    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-previsao-im0055a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-efetiva-im0055a         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0055a        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0055a         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-itiner-im0055a         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-pto-contr-im0055a          AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE dt-efetiva-antes-im0055a      AS DATE          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE dt-previsao-antes-im0055a     AS DATE          NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEFINE VARIABLE c-char                 AS CHAR NO-UNDO.
DEFINE VARIABLE v-pto-contr-itiner     AS INT  NO-UNDO.
DEFINE VARIABLE l-encontrou-observacao AS LOG  NO-UNDO.

DEFINE VARIABLE l-despacho              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-embarque              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-eadi                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-nacionaliza           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-solicita-li           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-chegada               AS LOGICAL      NO-UNDO.



/*---[ Referente chamado nro. 10472 ]-------------------------------------*/
DEFINE VARIABLE h-bocx351    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE cOrdensSemLI AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-arquivo    AS CHARACTER FORMAT "X(30)" NO-UNDO.

DEFINE TEMP-TABLE tt-licenciam-import-oc  NO-UNDO 
    LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.
/*-------------------------------------[ Referente chamado nro. 10472 ]---*/

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

DEFINE VARIABLE dt-data-ult-prev AS DATE        NO-UNDO.

DEFINE BUFFER b-historico-embarque FOR historico-embarque.

/* output to c:\temp\eventos.txt APPEND no-convert. */
/* put unformatted                                  */
/*         "Evento " p-ind-event  SKIP              */
/*         "Objeto " p-ind-object SKIP              */
/*         "Nome   " c-char SKIP                    */
/*         "Tabela " p-cod-table  SKIP              */
/*         "Rowid  " STRING(p-row-table) skip       */
/*         "c-char " c-char                         */
/*         skip(1).                                 */
/* output close.                                    */

/*
MESSAGE "p-ind-object: " p-ind-object SKIP
        "p-ind-event: " p-ind-event SKIP
        "p-wgh-object:NAME: " p-wgh-object:NAME SKIP
        "p-cod-table: " p-cod-table SKIP
        "p-row-table: " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "dt-efetiva",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-dt-efetiva-im0055a). 

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "dt-previsao",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-dt-previsao-im0055a).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-estabel",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-estabel-im0055a).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "embarque",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-embarque-im0055a).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-itiner",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-itiner-im0055a).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-pto-contr",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-pto-contr-im0055a).

    CREATE TEXT wh-tx-dt-ult-previsao-im0055a
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(16)"   
           WIDTH        = 16
           SCREEN-VALUE = "Dt.Ult.Previs∆o:"
           ROW          = wh-dt-previsao-im0055a:ROW + 0.15
           COL          = wh-dt-previsao-im0055a:COL + 13
           VISIBLE      = YES.

    CREATE FILL-IN wh-dt-ult-previsao-im0055a
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           FORMAT            = wh-dt-previsao-im0055a:FORMAT
           WIDTH             = wh-dt-previsao-im0055a:WIDTH-CHARS
           HEIGHT            = wh-dt-previsao-im0055a:HEIGHT-CHARS
           ROW               = wh-dt-previsao-im0055a:ROW
           COL               = wh-dt-previsao-im0055a:COL + 24
           VISIBLE           = YES
           SENSITIVE         = NO.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" THEN DO:

    IF VALID-HANDLE(wh-dt-ult-previsao-im0055a) AND p-row-table <> ? AND p-cod-table = "historico-embarque" THEN DO:
        FIND FIRST historico-embarque NO-LOCK
             WHERE ROWID(historico-embarque) = p-row-table NO-ERROR.
        IF AVAIL historico-embarque AND historico-embarque.cod-pto-contr = 1 THEN DO:
            ASSIGN wh-dt-ult-previsao-im0055a:SENSITIVE = NOT CAN-FIND(FIRST b-historico-embarque NO-LOCK
                                                                       WHERE b-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                                                                         AND b-historico-embarque.embarque    = historico-embarque.embarque
                                                                         AND b-historico-embarque.dt-efetiva  <> ?).
        END.
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" THEN DO:

    IF VALID-HANDLE(wh-dt-ult-previsao-im0055a) AND 
       p-row-table <> ? AND 
       p-cod-table = "historico-embarque" THEN DO:

        FIND FIRST historico-embarque NO-LOCK
             WHERE ROWID(historico-embarque) = p-row-table NO-ERROR.
        IF AVAIL historico-embarque THEN DO:
            ASSIGN wh-dt-ult-previsao-im0055a:SCREEN-VALUE = STRING(historico-embarque.dt-ult-previsao,"99/99/9999").
        END.
    END.

    IF VALID-HANDLE(wh-dt-efetiva-im0055a) AND
        p-row-table <> ? AND
        p-cod-table = 'historico-embarque' THEN DO:

        ASSIGN dt-efetiva-antes-im0055a = DATE(wh-dt-efetiva-im0055a:SCREEN-VALUE)
               dt-previsao-antes-im0055a = date(wh-dt-previsao-im0055a:SCREEN-VALUE).

    END.

END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ASSIGN" THEN DO:

    IF VALID-HANDLE(wh-dt-ult-previsao-im0055a) AND 
       p-row-table <> ? AND 
       p-cod-table = "historico-embarque" THEN DO:

        ASSIGN dt-data-ult-prev = DATE(wh-dt-ult-previsao-im0055a:SCREEN-VALUE) NO-ERROR.
        IF dt-data-ult-prev <> ? THEN DO:
            FIND FIRST historico-embarque EXCLUSIVE-LOCK
                 WHERE ROWID(historico-embarque) = p-row-table NO-ERROR.
            IF AVAIL historico-embarque AND historico-embarque.cod-pto-contr = 1 THEN DO:
                ASSIGN historico-embarque.dt-ult-previsao = dt-data-ult-prev.
            END.
        END.
    END.



    IF VALID-HANDLE(wh-dt-efetiva-im0055a) AND
        p-row-table <> ? AND
        p-cod-table = 'historico-embarque' THEN DO:

        IF dt-efetiva-antes-im0055a <> DATE(wh-dt-efetiva-im0055a:SCREEN-VALUE) THEN DO:

            RUN pi-verifica-ponto-controle-chave(OUTPUT l-despacho,
                                                 OUTPUT l-embarque,   
                                                 OUTPUT l-eadi,
                                                 OUTPUT l-nacionaliza,
                                                 OUTPUT l-solicita-li,
                                                 OUTPUT l-chegada).

            IF l-embarque THEN
                RUN pi-envia-email-dt-efetiva.

        END.
        

    END.

END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-ASSIGN" THEN DO:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-estabel",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-estabel).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "embarque",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-embarque).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-itiner",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-itiner).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,                                                       
                  INPUT "fill-in",       /*** Type ***/
                  INPUT "cod-pto-contr",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-pto-contr).

    IF VALID-HANDLE(wh-cod-estabel) AND
       VALID-HANDLE(wh-embarque)    AND
       VALID-HANDLE(wh-cod-pto-contr) THEN DO:
        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = int(wh-cod-itiner:screen-value) NO-ERROR.
        IF AVAIL itinerario THEN
            ASSIGN v-pto-contr-itiner = itinerario.pto-embarque.

        if  int(wh-cod-pto-contr:screen-value) = 1 or
            int(wh-cod-pto-contr:screen-value) = 2 or
            int(wh-cod-pto-contr:screen-value) = v-pto-contr-itiner then do:

            IF  int(wh-cod-pto-contr:screen-value) = 1
            OR  int(wh-cod-pto-contr:screen-value) = 2 THEN DO:

                run cxbo/bocx351.p persistent set h-bocx351.

                if  valid-handle (h-bocx351) then do:
            
                    assign cOrdensSemLI = "":U.
                    run piRetornaLI in h-bocx351 (input 2,
                                                  input yes,
                                                  input ?,
                                                  input wh-cod-estabel:SCREEN-VALUE,
                                                  input wh-embarque:SCREEN-VALUE,
                                                  input ?,
                                                  input no,
                                                  input yes,
                                                  input 0,
                                                  input 99999999,
                                                  input " ":U,
                                                  input "ZZZZZZZZZZZZZZZZ":U,
                                                  input " ":U,
                                                  input "ZZZZZZZZ":U,
                                                  input " ":U,
                                                  input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                                  output table tt-licenciam-import-oc). 
                end. /* if  valid-handle (h-bocx351) then do: */
            
                bloco_LI:
                for each  tt-licenciam-import-oc
                    where tt-licenciam-import-oc.licenca-import = "":U
                    break by tt-licenciam-import-oc.numero-ordem
                          by tt-licenciam-import-oc.parcela:
            
                    if  first-of(tt-licenciam-import-oc.numero-ordem) then do:
                        if  cOrdensSemLI = "":U 
                        then assign cOrdensSemLI = string(tt-licenciam-import-oc.numero-ordem).
                        else assign cOrdensSemLI = cOrdensSemLI + ", ":U + string(tt-licenciam-import-oc.numero-ordem).

                        IF cOrdensSemLI <> "" THEN LEAVE bloco_LI.
                    end. /* if  first-of(tt-licenciam-import-oc.numero-ordem) */
                end. /* for each  tt-licenciam-import-oc */
            
                IF  int(wh-cod-pto-contr:screen-value) = 1 
              /*OR  int(wh-cod-pto-contr:screen-value) = 2 /* CONDIÄ«O QUE SERµ RETIRADA QUANDO O BLOQUEIO ABAIXO FOR LIBERADO */*/ THEN DO:
                    if  cOrdensSemLi <> "":U then do:
                        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "IM9056RP":U + ".tmp":U.
            
                        RUN imp/im9056rp.p (INPUT wh-cod-estabel:SCREEN-VALUE,
                                            INPUT wh-embarque:SCREEN-VALUE,   
                                            INPUT TABLE tt-licenciam-import-oc).
                    
                        run utp/ut-msgs.p (input "Show":U,
                                           INPUT 27979,
                                           input "Item precisa de LI anu°da.":U + "~~":U +
                                                 "O Embarque possui itens vinculados que necessitam de LI, porÇm n∆o possuem registro deste documento no sistema. Gentileza registrar LI anu°da no IM0041.":U
                                                 + CHR(10) + CHR(10) + "Consultar arquivo: " + c-arquivo).
                    end. /* if  cOrdensSemLi <> "":U */
                END. /* IF  int(wh-cod-pto-contr:screen-value) = 1 THEN DO: */

                IF  int(wh-cod-pto-contr:screen-value) = 2 THEN DO:
                    if  cOrdensSemLi <> "":U then do:
                        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "IM9056RP":U + ".tmp":U.

                        RUN imp/im9056rp.p (INPUT wh-cod-estabel:SCREEN-VALUE,
                                            INPUT wh-embarque:SCREEN-VALUE,
                                            INPUT TABLE tt-licenciam-import-oc).

                        run utp/ut-msgs.p (input "Show":U,
                                           input 17006,
                                           input "PROCESSO INTERROMPIDO: Item precisa de LI anu°da.":U + "~~":U +
                                                 "O Embarque possui itens vinculados que necessitam de LI, porÇm n∆o possuem registro deste documento no sistema. Gentileza registrar LI anu°da no IM0041.":U
                                                 + CHR(10) + CHR(10) + "Consultar arquivo: " + c-arquivo).
                        IF valid-handle(wh-dt-efetiva-im0055a) THEN APPLY "entry" TO wh-dt-efetiva-im0055a.
                        RETURN ERROR.
                    end. /* if  cOrdensSemLi <> "":U */
                END. /* IF  int(wh-cod-pto-contr:screen-value) = 2 THEN DO: */

            END. /* int(wh-cod-pto-contr:screen-value) ... */
            
            FOR EACH ordens-embarque NO-LOCK
               WHERE ordens-embarque.cod-estabel = wh-cod-estabel:SCREEN-VALUE
                 AND ordens-embarque.embarque    = wh-embarque:SCREEN-VALUE:
                FIND FIRST ordem-compra NO-LOCK
                     WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
                IF AVAIL ordem-compra THEN DO:
                    FIND FIRST int-item-uni-estab NO-LOCK
                         WHERE int-item-uni-estab.cod-estabel = ordens-embarque.cod-estabel
                           AND int-item-uni-estab.it-codigo   = ordem-compra.it-codigo NO-ERROR.
                    IF AVAIL int-item-uni-estab and
                             int-item-uni-estab.observacao <> "" THEN
                        ASSIGN l-encontrou-observacao = YES.
                END.
            END.
            
            IF l-encontrou-observacao THEN
                run upc/im0055a-upc-obs.w (input wh-cod-estabel:SCREEN-VALUE,
                                           input wh-embarque:SCREEN-VALUE).   

        end.
    END.        
END.

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.


PROCEDURE pi-envia-email-dt-efetiva:

    /*
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE VARIABLE icont          AS INTEGER NO-UNDO. 
    */

    DEFINE VARIABLE c-destinos      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019      AS HANDLE      NO-UNDO.

    DEFINE VARIABLE c-dt-previsao-antes   AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-dt-previsao-depois  AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-dt-efetiva-antes    AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-dt-efetiva-depois   AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-tipo-man AS CHARACTER   NO-UNDO.


    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT "im0055a",  /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    ASSIGN c-destinos = "".
 
    FOR EACH tt-prog-ponto
         where tt-prog-ponto.nome-programa = "im0055a"
           and tt-prog-ponto.ponto         = 1:

        ASSIGN c-destinos = c-destinos + tt-prog-ponto.conteudo + ';'.

    END.

    ASSIGN c-destinos = SUBSTRING(c-destinos, 1, LENGTH(c-destinos) - 1).

    /**/
    
    FOR FIRST param-global NO-LOCK: END.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

    ASSIGN c-dt-previsao-antes  = IF dt-previsao-antes-im0055a = ? THEN "" ELSE string(dt-previsao-antes-im0055a, "99/99/9999")
           c-dt-previsao-depois = IF wh-dt-previsao-im0055a:SCREEN-VALUE = ? THEN "" ELSE wh-dt-previsao-im0055a:SCREEN-VALUE
           c-dt-efetiva-antes   = IF dt-efetiva-antes-im0055a = ? THEN "" ELSE string(dt-efetiva-antes-im0055a, "99/99/9999")
           c-dt-efetiva-depois  = IF wh-dt-efetiva-im0055a:SCREEN-VALUE = ? THEN "" ELSE wh-dt-efetiva-im0055a:SCREEN-VALUE.

    IF c-dt-efetiva-antes  =  "" AND
       c-dt-efetiva-depois <> "" THEN
        ASSIGN c-tipo-man = "Inclus∆o".
    ELSE IF c-dt-efetiva-antes  <> "" AND
            c-dt-efetiva-depois =  "" THEN
        ASSIGN c-tipo-man = "Exclus∆o".
    ELSE IF c-dt-efetiva-antes <> "" AND
            c-dt-efetiva-depois <> "" AND
            c-dt-efetiva-antes <> c-dt-efetiva-depois THEN
        ASSIGN c-tipo-man = "Modificaá∆o".

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
           tt-envio2.destino           = c-destinos              /* Destinat†rio       */ 
           tt-envio2.remetente         = 'ems@intelbras.com.br'  /* Remetente          */ 
           tt-envio2.assunto           = 'IM0055 - ' + c-tipo-man + ' de Data Efetiva - Embarque: ' + wh-embarque-im0055a:SCREEN-VALUE + ' - Estab: ' + wh-cod-estabel-im0055a:SCREEN-VALUE        /* Assunto            */
           tt-envio2.arq-anexo         = ""                      /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TXT".

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE  usuar_mestre.cod_usuar = v_cod_usuar_corren:
    END.

    

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem = "Ocorreu uma " + c-tipo-man + " na Data Efetiva do ponto de Controle Embarque conforme dados abaixo:" + CHR(13) + CHR(13) +
                                  "N£mero do embarque: " + wh-embarque-im0055a:SCREEN-VALUE + CHR(13) +
                                  "Estabelecimento: " + wh-cod-estabel-im0055a:SCREEN-VALUE + CHR(13) +
                                  "C¢digo do usu†rio: " + v_cod_usuar_corren + CHR(13) +
                                  "Nome do usu†rio: " + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + CHR(13) + 
                                  "Data de modificaá∆o: " + STRING(TODAY, "99/99/9999") + CHR(13) +
                                  "Hora de modificaá∆o: " + STRING(TIME, "HH:MM:SS") + CHR(13) + 
                                  "Data da Ultima Previs∆o antes da alteraá∆o: " + c-dt-previsao-antes + CHR(13) + 
                                  "Data da Èltima Previs∆o depois da alteraá∆o: " + c-dt-previsao-depois + CHR(13) + 
                                  "Data Efetiva antes da alteraá∆o: " + c-dt-efetiva-antes + CHR(13) +
                                  "Data Efetiva depois da alteraá∆o: " + c-dt-efetiva-depois + CHR(13) + CHR(13) +
                                  "Atenciosamente," + CHR(13) +
                                  "Equipe TI Sistemas".
            
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF  AVAIL tt-erros THEN DO:
        OUTPUT TO erros-comerc.LOG APPEND.

        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END. /* IF  AVAIL tt-erros THEN DO: */
    
    DELETE PROCEDURE h-utapi019.

END PROCEDURE.


PROCEDURE pi-verifica-ponto-controle-chave:

    DEFINE OUTPUT PARAMETER p-despacho      AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-embarque      AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-eadi          AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nacionaliza   AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-solicita-li   AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-chegada       AS LOGICAL  NO-UNDO.

    DEFINE VARIABLE h-bocx120   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cLocal AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-recebimento AS LOGICAL     NO-UNDO.


    FOR FIRST pto-itiner NO-LOCK
        WHERE pto-itiner.cod-itiner     = int(wh-cod-itiner-im0055a:SCREEN-VALUE)
        AND   pto-itiner.cod-pto-contr  = int(wh-cod-pto-contr-im0055a:SCREEN-VALUE):

        RUN cxbo/bocx120.p PERSISTENT SET h-bocx120.

        RUN setalocais in h-bocx120 (input ROWID(pto-itiner),
                                     output p-eadi,
                                     OUTPUT l-recebimento,
                                     output clocal).
    
        run getParameterLI in h-bocx120 (output p-solicita-li).
        
        if clocal = "embarque/despacho" then
            assign p-embarque    = yes
                   p-nacionaliza = no
                   p-despacho    = yes
                   p-chegada     = no.
        ELSE if clocal = "desembarque/chegada" then
            assign p-embarque    = no
                   p-nacionaliza = yes
                   p-despacho    = no
                   p-chegada     = yes.
        else if clocal = "desembarque" then
            assign p-embarque    = no
                   p-nacionaliza = yes
                   p-despacho    = no
                   p-chegada     = no.
        else if clocal = "despacho" then
            assign p-embarque    = no
                   p-nacionaliza = no
                   p-despacho    = yes
                   p-chegada     = no.
        else if clocal = "chegada" then
            assign p-embarque    = no
                   p-nacionaliza = no
                   p-despacho    = no
                   p-chegada     = yes.
        else if clocal = "embarque" then
            assign p-embarque    = yes
                   p-nacionaliza = no
                   p-despacho    = no
                   p-chegada     = no.


        DELETE PROCEDURE h-bocx120.

        ASSIGN h-bocx120 = ?.
        
    END.

    RETURN "OK":U.


END PROCEDURE.
