/*------------------------------------------------------------------------------------
     Programa: WM0390-UPC
         Data: 11/03/2016
        Autor: Carlos da Costa Junior - SCM Concept
     Objetivo: Apresentar a Transportadora na Saida Manual
  Atualizaá∆o: 

------------------------------------------------------------------------------------*/

{include/i-prgvrs.i upc-wm0390 2.00.00.000}
{esp/es0018.i}
{method/dbotterr.i}

/*----- DEFINICAO DE PARAMETROS -----*/
def input parameter p-ind-event  as char          no-undo.
def input parameter p-ind-object as char          no-undo.
def input parameter p-wgh-object as handle        no-undo.
def input parameter p-wgh-frame  as widget-handle no-undo.
def input parameter p-cod-table  as char          no-undo.
def input parameter p-row-table  as rowid         no-undo.

DEF VAR wgh-grupo       AS WIDGET-HANDLE   NO-UNDO.
DEF VAR wgh-child       AS WIDGET-HANDLE   NO-UNDO.
DEF VAR wgh-frame       AS WIDGET-HANDLE   NO-UNDO.

DEF VAR wgh-fPage1                 AS WIDGET-HANDLE   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-epcwm0390-wmp         AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btIntegraWm0390      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btImprimeWm0390      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wgh-dt-implan-docto         AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-nome-transp             AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-lbl-nome-transp         AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-num-docto-wm0390        AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-reporte-antecip-wm0390  AS WIDGET-HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-label-reporte-wm0390    AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-id-doctowm0390  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-wm0390-fpage1        AS HANDLE NO-UNDO.

DEFINE VARIABLE i-campo AS INTEGER         NO-UNDO.
DEFINE VARIABLE l-erro  AS LOGICAL     NO-UNDO.
DEF VAR c-handle-obj    AS CHAR            NO-UNDO.
DEF VAR c-objeto        AS CHAR            NO-UNDO.
DEF VAR wh-objeto       AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE iNrVolume   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTipoImpres AS INTEGER     NO-UNDO.


IF p-ind-event = 'BEFORE-INITIALIZE' THEN DO:

   Run pi-busca-widget(Input 'num-docto',
                       Input  p-wgh-frame,
                       Output wh-objeto).

   wgh-num-docto-wm0390 = wh-objeto.
  
   IF NOT VALID-HANDLE(wgh-reporte-antecip-wm0390) AND 
          VALID-HANDLE(wgh-num-docto-wm0390)       THEN
   DO: 
       CREATE TEXT wgh-label-reporte-wm0390
       ASSIGN FRAME        = wgh-num-docto-wm0390:FRAME
              FORMAT       = "x(25)":U
              WIDTH        = 16
              SCREEN-VALUE = "Reporte Antecip. Solar":U
              ROW          = wgh-num-docto-wm0390:ROW + 0.2
              COL          = wgh-num-docto-wm0390:COL + wgh-num-docto-wm0390:WIDTH + 13.3
              VISIBLE      = YES
              FONT         = 1.
  
       CREATE TOGGLE-BOX wgh-reporte-antecip-wm0390
       ASSIGN FRAME     = wgh-num-docto-wm0390:FRAME
              WIDTH     = 2
              ROW       = wgh-num-docto-wm0390:ROW + 0.1
              COL       = wgh-num-docto-wm0390:COL + wgh-num-docto-wm0390:WIDTH + 11
              VISIBLE   = YES
              SENSITIVE = NO
              FONT      = 1.
   END.
END.


IF p-ind-event = "afterDisplayFields" THEN DO:

    FIND FIRST wm-docto WHERE
         ROWID(wm-docto) = p-row-table NO-LOCK NO-ERROR.
    IF VALID-HANDLE(wgh-nome-transp) THEN DO:
        
        IF AVAIL wm-docto AND wm-docto.ind-origem-docto = 5 THEN DO:
            ASSIGN wgh-nome-transp:SCREEN-VALUE = ENTRY(2,wm-docto.num-docto-origem,"|") NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
                ASSIGN wgh-nome-transp:SCREEN-VALUE = "".
        END.
        ELSE DO:
            ASSIGN wgh-nome-transp:SCREEN-VALUE = "".
        END.
    END.

    IF NOT VALID-HANDLE(h-epcwm0390-wmp) THEN
        RUN upc/wm0390-upc.p PERSISTENT SET h-epcwm0390-wmp (INPUT "", 
                                                             INPUT "", 
                                                             INPUT ?, 
                                                             INPUT p-wgh-frame, 
                                                             INPUT "", 
                                                             INPUT ?). 

    IF wgh-lbl-nome-transp:SCREEN-VALUE = "" THEN
        ASSIGN wgh-lbl-nome-transp:SCREEN-VALUE = "Transportador:".


    IF VALID-HANDLE(wgh-reporte-antecip-wm0390) THEN DO:

       IF AVAIL wm-docto THEN
       DO:
          ASSIGN wgh-reporte-antecip-wm0390:CHECKED = NO.

          FIND int-wm-docto WHERE int-wm-docto.cod-estabel = wm-docto.cod-estabel
                              and int-wm-docto.cod-local   = wm-docto.cod-local  
                              and int-wm-docto.id-docto    = wm-docto.id-docto  
          NO-LOCK NO-ERROR.

          IF AVAIL int-wm-docto THEN
             ASSIGN wgh-reporte-antecip-wm0390:CHECKED = int-wm-docto.log-atualizado. 
       END.
    END.

    IF VALID-HANDLE(wgh-label-reporte-wm0390) THEN
       ASSIGN wgh-label-reporte-wm0390:SCREEN-VALUE = "Reporte Antecip. Solar".

END.

IF p-ind-event = "pi-btAddDocto" THEN DO:

    ASSIGN wgh-lbl-nome-transp:VISIBLE      = YES
           wgh-lbl-nome-transp:SCREEN-VALUE = "Transportador:"
           wgh-nome-transp:VISIBLE          = YES.
END.

IF p-ind-event = 'AFTER-DISPLAY' THEN DO:

  Run pi-busca-widget(Input  'fPage1',
                      Input  p-wgh-frame,
                      Output wh-objeto).
  wgh-fPage1 = wh-objeto.

 

  Run pi-busca-widget(Input 'dt-implan-docto',
                      Input  wgh-fPage1,
                      Output wh-objeto).
  wgh-dt-implan-docto = wh-objeto.

  
  IF NOT VALID-HANDLE(wgh-nome-transp) THEN DO:
        CREATE TEXT wgh-lbl-nome-transp
        ASSIGN FRAME        = wgh-fPage1
               FORMAT       = "x(14)":U
               WIDTH        = 10
               SCREEN-VALUE = "Transportador:":U
               ROW          = wgh-dt-implan-docto:ROW + 0.1
               COL          = 30
               VISIBLE      = YES
               FONT         = 1.
        CREATE FILL-IN wgh-nome-transp
        ASSIGN FRAME     = wgh-fPage1
               DATA-TYPE = "character":U
               FORMAT    = "x(16)":U
               NAME      = "wgh-nome-transp":U
               WIDTH     = 20
               HEIGHT    = 0.88
               ROW       = wgh-dt-implan-docto:ROW
               COL       = 40.00
               VISIBLE   = YES
               SENSITIVE = NO
               FONT      = 1.
  END.  
END.

IF p-ind-event = "AFTER-INITIALIZE" THEN DO:

    IF NOT VALID-HANDLE(wh-btIntegraWm0390) THEN DO:
        CREATE BUTTON wh-btIntegraWm0390
        ASSIGN FRAME   = p-wgh-frame
               FLAT-BUTTON = YES
               ROW     = 1.13
               COLUMN  = 60
               WIDTH   = 4
               HEIGHT  = 1.25
               VISIBLE = YES
               SENSITIVE = YES.
        wh-btIntegraWm0390:LOAD-IMAGE-UP('image\toolbar\im-item.bmp').
        wh-btIntegraWm0390:TOOLTIP = 'Integra documento com o Protheus'.
        wh-btIntegraWm0390:MOVE-TO-TOP().
        ON 'CHOOSE' OF wh-btIntegraWm0390 PERSISTENT RUN pi-choose-bt-integra IN h-epcwm0390-wmp.
    END.

    IF NOT VALID-HANDLE(wh-btImprimeWm0390) THEN DO:
        CREATE BUTTON wh-btImprimeWm0390
        ASSIGN FRAME   = p-wgh-frame
               FLAT-BUTTON = YES
               ROW     = 1.13
               COLUMN  = 65
               WIDTH   = 4
               HEIGHT  = 1.25
               VISIBLE = YES
               SENSITIVE = YES.
        wh-btImprimeWm0390:LOAD-IMAGE-UP('image\ii-barras.bmp').
        wh-btImprimeWm0390:TOOLTIP = 'Imprime Etiquetas Renovigi'.
        wh-btImprimeWm0390:MOVE-TO-TOP().
        ON 'CHOOSE' OF wh-btImprimeWm0390 PERSISTENT RUN pi-choose-bt-imprime IN h-epcwm0390-wmp.
    END.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FRAME",
                  INPUT "fPage1",
                  INPUT NO,
                  OUTPUT wh-wm0390-fpage1).

    RUN tela-upc (INPUT wh-wm0390-fpage1,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",
                  INPUT "id-docto",
                  INPUT NO,
                  OUTPUT wgh-id-doctowm0390).

END.



IF p-ind-event = "AFTER-DESTROY-INTERFACE":U THEN DO:

    IF  VALID-HANDLE(wgh-lbl-nome-transp)  THEN DELETE OBJECT wgh-lbl-nome-transp.   
    IF  VALID-HANDLE(wgh-nome-transp)      THEN DELETE OBJECT wgh-nome-transp.

END.

PROCEDURE pi-choose-bt-integra:


    IF VALID-HANDLE(wgh-id-doctowm0390) THEN DO:
        FIND FIRST wm-docto  NO-LOCK
             WHERE wm-docto.id-docto = DEC(wgh-id-doctowm0390:SCREEN-VALUE) NO-ERROR.
    
        IF AVAIL wm-docto THEN DO:
            
            // Estabelecimento
            RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                                INPUT 1,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
            IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
                FIND FIRST tt-prog-ponto
                     WHERE ENTRY(2,tt-prog-ponto.conteudo,";") = wm-docto.cod-estabel NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                    IF substring(wm-docto.char-2,1,20) <> "" THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 17006, 
                                           INPUT "Documento j† integrado com o Protheus").
                        RETURN "NOK".
                    END.
    
                    RUN piInformaVolume.

                    IF iNrVolume = 0 THEN
                        RETURN "NOK".

                    RUN esp/wmp/returnDoctoSaida.p(INPUT ROWID(wm-docto),
                                                   INPUT iNrVolume,
                                                   OUTPUT l-erro,
                                                   OUTPUT TABLE rowErrors).
    
                    IF l-erro THEN DO:
                        IF CAN-FIND(FIRST rowErrors) THEN DO:
                            FOR EACH Rowerrors NO-LOCK:
                                RUN utp/ut-msgs.p (INPUT "SHOW",
                                                   INPUT Rowerrors.ErrorNum, 
                                                   INPUT Rowerrors.ErrorDescription).
                            END.
                            RETURN "NOK".
                        END.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 15825, 
                                           INPUT "Integraá∆o realizada com sucesso").
                        RETURN "NOK".
    
                    END.
                END.
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.

    RELEASE wm-docto NO-ERROR.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-choose-bt-imprime:

    RUN piTipoimpressao.

    IF iTipoImpres = 0 THEN
        RETURN "NOK".

    // Estrutura
    IF iTipoImpres = 1 THEN DO:
        IF VALID-HANDLE(wgh-id-doctowm0390) THEN DO:
            FIND FIRST wm-docto  NO-LOCK
                 WHERE wm-docto.id-docto = DEC(wgh-id-doctowm0390:SCREEN-VALUE) NO-ERROR.
            IF AVAIL wm-docto THEN DO:
                RUN esp/wmp/eswmapi007.p(INPUT  ROWID(wm-docto),
                                         OUTPUT TABLE rowerrors).
    
            END.
        END.
    END.

    // Item
    IF iTipoImpres = 2 THEN DO:
        IF VALID-HANDLE(wgh-id-doctowm0390) THEN DO:
            FIND FIRST wm-docto  NO-LOCK
                 WHERE wm-docto.id-docto = DEC(wgh-id-doctowm0390:SCREEN-VALUE) NO-ERROR.
            IF AVAIL wm-docto THEN DO:
                RUN esp/wmp/eswmapi008.p(INPUT SUBSTRING(wm-docto.char-2,21,6),
                                         INPUT  ROWID(wm-docto),
                                         OUTPUT TABLE rowerrors).
    
            END.
        END.
    END.


    RETURN "OK".

END PROCEDURE.

/*----------------------------- Procedure PI-BUSCA-WIDGET ---------------------------------*/

PROCEDURE pi-busca-widget:
    DEF INPUT  PARAM p-nome     AS CHAR.
    DEF INPUT  PARAM p-frame    AS WIDGET-HANDLE.
    DEF OUTPUT PARAM p-object   AS WIDGET-HANDLE.
    DEF VAR h-frame             AS WIDGET-HANDLE.
    DEF VAR wh-objeto           AS WIDGET-HANDLE.
    
    ASSIGN h-frame = p-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):

        IF h-frame:TYPE <> "field-group" THEN 
        DO:
            IF h-frame:Type = "frame" THEN 
            DO:
                RUN pi-busca-widget(INPUT  p-nome,
                                    INPUT  h-frame,
                                    OUTPUT wh-objeto).
                IF wh-objeto <> ? THEN  
                DO:
                    ASSIGN p-object = wh-objeto.
                    LEAVE.
                END.
            END.
           
            IF h-frame:NAME = p-nome THEN  
            DO:
                ASSIGN p-object = h-frame.
                LEAVE.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

END PROCEDURE.

PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):
        IF  pApresMsg = YES THEN
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP
                    "Type do Objeto" wgh-obj:TYPE SKIP
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE = pObjType AND
            wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            LEAVE.
        END.

        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.

PROCEDURE piInformaVolume:

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-num-volume      AS INT FORMAT ">>>9" LABEL "Qtd Volumes" NO-UNDO.
   
    DEFINE FRAME fGoToRecord
        i-num-volume      AT ROW 1.61 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9 BY 0.88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informe Quantidade de Volumes" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "Informe_Quantidade_de_Volumes"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-volume.
        
        ASSIGN iNrVolume = i-num-volume.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-volume btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

PROCEDURE piTipoimpressao:

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE rs-tipo-impressao AS INTEGER INITIAL 1 
             VIEW-AS RADIO-SET HORIZONTAL
             RADIO-BUTTONS 
                  "Estrutura", 1,
                  "Item", 2
             SIZE 27.72 BY 1.08 NO-UNDO.
   
    DEFINE FRAME fGoToRecord
        rs-tipo-impressao      AT ROW 1.61 COL 17.72 COLON-ALIGNED VIEW-AS RADIO-SET SIZE 9 BY 1.08 LABEL "Tipo Impress∆o"
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informe Quantidade de Volumes" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    /*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "Informe_Quantidade_de_Volumes"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    /*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN rs-tipo-impressao.
        
        ASSIGN iTipoImpres = rs-tipo-impressao.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE rs-tipo-impressao btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.
