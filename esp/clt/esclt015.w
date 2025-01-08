&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*------------------------------------------------------------------------------
  Purpose:    Lista informaá‰es por Embarque no coletor
  Parameters:  <none>
  Notes:      Nicolas - 08/06/2021
------------------------------------------------------------------------------*/
{include/i-prgvrs.i ESCLT015 2.00.00.000}
{esp/es0018.i}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT015
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-embarque fi-local bt-imprimir bt-apagar bt-sair fi-nota
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-etiquetas
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-volume         LIKE volume-nf.nr-volume
    FIELD it-codigo         LIKE volume-nf.it-codigo
    FIELD qtde              LIKE volume-nf.qtde
    INDEX id cod-estabel serie nr-nota-fis nr-volume it-codigo.

DEFINE BUFFER b-tt-etiquetas FOR tt-etiquetas.

DEF VAR c-anterior      AS CHAR.
DEF VAR c-caixa-atu     AS CHAR.
DEF VAR c-caixa         AS CHAR.
DEF VAR i-quant-cx      AS INT.
DEF VAR i-quant-pt      AS INT.
DEF VAR i-cont          AS INT.
DEF VAR i-contEtiq      AS INT.
DEF VAR l-erro          AS LOG.
DEF VAR c-acao          AS CHAR.
DEF VAR l-ok            AS LOG.
DEF VAR l-reincorpora   AS LOG.

DEFINE VARIABLE v-it-codigo LIKE item.it-codigo NO-UNDO.

DEF BUFFER b-ns-volume FOR ns-volume.

DEFINE VARIABLE c-cod-estabel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-volume        AS INTEGER     NO-UNDO.

DEFINE VARIABLE cTempFile       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrev           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrinter        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout         AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-nr-volumes    AS INTEGER     NO-UNDO.

DEFINE VARIABLE AppWord         AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE i-linha         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-regs          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-celula        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pagina        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-lado          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-lins-por-pagina AS INTEGER    INIT 21 NO-UNDO.

DEFINE VARIABLE c-arquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bcapi016      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-bc-ean        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nf-item       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-tot-ite       AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiquetas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-etiquetas

/* Definitions for BROWSE br-etiquetas                                  */
&Scoped-define FIELDS-IN-QUERY-br-etiquetas tt-etiquetas.nr-nota-fis tt-etiquetas.serie tt-etiquetas.it-codigo tt-etiquetas.qtde tt-etiquetas.nr-volume //fn-volume(INPUT tt-etiquetas.cod-estabel, INPUT tt-etiquetas.serie, INPUT tt-etiquetas.nr-nota-fis)   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiquetas   
&Scoped-define SELF-NAME br-etiquetas
&Scoped-define QUERY-STRING-br-etiquetas FOR EACH tt-etiquetas
&Scoped-define OPEN-QUERY-br-etiquetas OPEN QUERY {&SELF-NAME} FOR EACH tt-etiquetas.
&Scoped-define TABLES-IN-QUERY-br-etiquetas tt-etiquetas
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiquetas tt-etiquetas


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiquetas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 fi-embarque fi-nota fi-local ~
br-etiquetas bt-imprimir bt-apagar bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-embarque fi-nota fi-local 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-volume wWindow 
FUNCTION fn-volume RETURNS INTEGER
  ( INPUT c-est AS CHAR, INPUT c-ser AS CHAR, INPUT c-nf AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-apagar 
     LABEL "Apagar" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE BUTTON bt-imprimir 
     LABEL "Imprimir" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-embarque AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 66 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(3)":U INITIAL "WEX" 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 37 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nota AS CHARACTER FORMAT "X(10)":U 
     LABEL "NF" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 66 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 36.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiquetas FOR 
      tt-etiquetas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiquetas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiquetas wWindow _FREEFORM
  QUERY br-etiquetas DISPLAY
      tt-etiquetas.nr-nota-fis
     tt-etiquetas.serie
     tt-etiquetas.it-codigo
     tt-etiquetas.qtde
     tt-etiquetas.nr-volume
     //fn-volume(INPUT tt-etiquetas.cod-estabel, INPUT tt-etiquetas.serie, INPUT tt-etiquetas.nr-nota-fis) COLUMN-LABEL "Volumes"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 9
          &ELSE SIZE-PIXELS 308 BY 210 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-embarque AT Y 12 X 52 COLON-ALIGNED WIDGET-ID 2
     fi-nota AT Y 12 X 144 COLON-ALIGNED WIDGET-ID 60
     fi-local AT Y 12 X 258 COLON-ALIGNED WIDGET-ID 56
     br-etiquetas AT Y 48 X 7 WIDGET-ID 200
     bt-imprimir AT Y 258 X 7 WIDGET-ID 50
     bt-apagar AT Y 258 X 188 WIDGET-ID 48
     bt-sair AT Y 258 X 252 WIDGET-ID 40
     RECT-17 AT Y 6 X 7 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 801
         MAX-WIDTH-P        = 1536
         VIRTUAL-HEIGHT-P   = 801
         VIRTUAL-WIDTH-P    = 1536
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB br-etiquetas fi-local fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiquetas
/* Query rebuild information for BROWSE br-etiquetas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-etiquetas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiquetas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiquetas
&Scoped-define SELF-NAME br-etiquetas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-etiquetas wWindow
ON MOUSE-SELECT-DBLCLICK OF br-etiquetas IN FRAME fpage0
DO:
/*
    IF AVAIL tt-etiquetas THEN DO:
        DELETE tt-etiquetas.
        ASSIGN i-nr-volumes = i-nr-volumes - 1.
        {&open-query-br-etiquetas}
    END.
*/

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-apagar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-apagar wWindow
ON CHOOSE OF bt-apagar IN FRAME fpage0 /* Apagar */
DO:

     ASSIGN i-nr-volumes = 0.

    FOR EACH tt-etiquetas:
        DELETE tt-etiquetas.
    END.

    {&open-query-br-etiquetas}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir wWindow
ON CHOOSE OF bt-imprimir IN FRAME fpage0 /* Imprimir */
DO:


    RUN piImprimirWord.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-embarque wWindow
ON RETURN OF fi-embarque IN FRAME fpage0 /* Embarque */
DO:

  /*  EMPTY TEMP-TABLE tt-etiquetas.

    FOR EACH nota-fiscal 
       WHERE nota-fiscal.cdd-embarq = INPUT FRAME fPage0 fi-embarque
         AND nota-fiscal.nr-nota-fis = INPUT FRAME fpageo fi-nota NO-LOCK,
        EACH volume-nf WHERE
             volume-nf.cod-estabel = nota-fiscal.cod-estabel
        AND  volume-nf.serie       = nota-fiscal.serie
        AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
             NO-LOCK:  

        CREATE tt-etiquetas.
        BUFFER-COPY volume-nf TO tt-etiquetas.

    END.

    {&open-query-br-etiquetas}

    ENABLE br-etiquetas
        WITH FRAME fPage0.

    ASSIGN SELF:SCREEN-VALUE = "".

    APPLY "ENTRY" TO SELF.
    RETURN NO-APPLY. */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nota wWindow
ON RETURN OF fi-nota IN FRAME fpage0 /* NF */
DO:

    EMPTY TEMP-TABLE tt-etiquetas.

    FOR EACH nota-fiscal 
       WHERE nota-fiscal.cdd-embarq = INPUT FRAME fPage0 fi-embarque
         AND nota-fiscal.nr-nota-fis = INPUT FRAME fpage0 fi-nota NO-LOCK,
        EACH volume-nf WHERE
             volume-nf.cod-estabel = nota-fiscal.cod-estabel
        AND  volume-nf.serie       = nota-fiscal.serie
        AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
             NO-LOCK:  

        CREATE tt-etiquetas.
        BUFFER-COPY volume-nf TO tt-etiquetas.

    END.

    {&open-query-br-etiquetas}

    ENABLE br-etiquetas
        WITH FRAME fPage0.

    ASSIGN SELF:SCREEN-VALUE = "".

    APPLY "ENTRY" TO SELF.
    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-nr-volumes = 0.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirWord wWindow 
PROCEDURE piImprimirWord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    session:set-wait-state ("general").

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Imprimindo").
    
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "ESCLT015":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST nota-fiscal WHERE
               nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
           AND nota-fiscal.serie       = tt-etiquetas.serie
           AND nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis
               NO-LOCK NO-ERROR.

    IF AVAIL nota-fiscal
    THEN DO:

       //Imprime se n∆o acha cliente dentro do parametro, impress∆o padr∆o como no ESCLT009
       IF NOT CAN-FIND (FIRST tt-prog-ponto WHERE
                              tt-prog-ponto.conteudo = string(nota-fiscal.cod-emitente)) 
       THEN DO:
          FOR EACH tt-etiquetas
              BREAK BY tt-etiquetas.nr-nota-fis:
          
              ASSIGN i-nr-volumes = i-nr-volumes + 1.

              IF FIRST-OF(tt-etiquetas.nr-nota-fis) THEN DO:
          
                  RUN pi-acompanhar IN h-acomp ("NF: " + tt-etiquetas.nr-nota-fis).
          
                  ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esclt015-" + STRING(TIME) + ".docx".
          
                  OS-COPY VALUE(SEARCH("esp/clt/esclt015.docx")) VALUE(c-arquivo).
                  
                  CREATE "Word.Application" AppWord.
                  AppWord:Documents:OPEN(c-arquivo).
                  AppWord:VISIBLE = FALSE.
          
                  ASSIGN i-pagina = 1.
          
                  /**/
          
                  FOR FIRST nota-fiscal NO-LOCK
                      WHERE nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
                      AND   nota-fiscal.serie       = tt-etiquetas.serie
                      AND   nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis:
                  END.
          
                  FOR FIRST emitente NO-LOCK
                      WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
                  END.
          
                  FOR FIRST filial-cliente NO-LOCK
                      WHERE filial-cliente.cnpj = emitente.cgc:
                  END.
                  
                  
                  /* In°cio Cabeáalho */
                  AppWord:ActiveWindow:ActivePane:View:SeekView = 9. /* wdSeekCurrentPageHeader */
                  
                  /* Emitente / Loja */
                  AppWord:Selection:MoveDown(5, 1).
                  AppWord:Selection:EndKey(5). /* wdLine */
                  AppWord:Selection:TypeText(emitente.nome-emit).
                  AppWord:Selection:MoveDown(5, 1).
                  AppWord:Selection:EndKey(5). /* wdLine */
                  AppWord:Selection:TypeText(IF AVAIL filial-cliente THEN filial-cliente.nr-filial + " - " + filial-cliente.nome-filial ELSE "").
                  
                  /* NF */
                  AppWord:Selection:MoveDown(5, 1).
                  AppWord:Selection:EndKey(5). /* wdLine */
                  AppWord:Selection:TypeText(string(nota-fiscal.nr-nota-fis)).
                  
                  /* Fim Cabecalho */
                  AppWord:ActiveWindow:ActivePane:View:SeekView = 0. /* wdSeekMainDocument */
          
                  /* Posiciona o Cursor no in°cio do documento */
                  AppWord:Selection:HomeKey(6).
          
                  /**/
          
                  RUN piWordNovaPagina.
          
                  ASSIGN i-linha = -1
                         i-regs = 0
                         c-lado = "".
          
              END.
          
              FOR EACH volume-nf NO-LOCK
                  WHERE volume-nf.cod-estabel = tt-etiquetas.cod-estabel
                  AND   volume-nf.serie       = tt-etiquetas.serie
                  AND   volume-nf.nr-nota-fis = tt-etiquetas.nr-nota-fis
                  AND   volume-nf.nr-volume   = tt-etiquetas.nr-volume
                  AND   volume-nf.it-codigo   = tt-etiquetas.it-codigo:
          
                  ASSIGN i-regs = i-regs + 1.
          
                  IF NOT i-regs MOD 2 = 0 THEN DO:
          
                      ASSIGN i-linha = i-linha + 2.
          
                      IF i-linha = i-lins-por-pagina THEN
                          ASSIGN i-pagina = i-pagina + 1.
          
                      IF NOT i-linha MOD 2 = 0 THEN
                          RUN piWordNovoQuadro.
          
                  END.
          
                  FOR FIRST ITEM NO-LOCK
                      WHERE ITEM.it-codigo = volume-nf.it-codigo:
                  END.
          
                  FOR FIRST item-mat NO-LOCK
                      WHERE item-mat.it-codigo = volume-nf.it-codigo:
                  END.
          
                  IF c-lado = "" OR c-lado = "D" THEN
                      ASSIGN c-lado = "E".
                  ELSE IF c-lado = "E" THEN
                      ASSIGN c-lado = "D".
          
                  RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
          
                  RUN generateEAN13 IN h-bcapi016 (INPUT SUBSTRING(item-mat.cod-ean,1,12),OUTPUT c-bc-ean).
          
                  DELETE PROCEDURE h-bcapi016.
                  ASSIGN h-bcapi016 = ?.
          
                  IF c-lado = "E" THEN
                      ASSIGN i-celula = 1.
                  ELSE
                      ASSIGN i-celula = 3.

                  AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha):Cells:Item(i-celula):Select.
                  AppWord:Selection:TypeText(substring(ITEM.desc-item,1,35)).
                  AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):Cells:Item(i-celula):Select.
                  AppWord:Selection:TypeText(c-bc-ean).
                  AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):Cells:Item(i-celula + 1):Select.
                  AppWord:Selection:TypeText(volume-nf.qtde).
          
              END.
          
          
              IF LAST-OF(tt-etiquetas.nr-nota-fis) THEN DO:
          
                  RUN piWordTotal.
          
                  AppWord:ActiveDocument:Save().
                  AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).
                  
                  AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
                  AppWord:QUIT().                                              /* Fechar o WORD */
                  RELEASE OBJECT AppWord. 
                  
          
                  /*OS-DELETE VALUE(c-arquivo). TEMPORARIO, S‡ PARA O EMERSON GERAR AS ETIQUETAS PARA MANAUS */
          
              END.
          END.
       END.
       ELSE DO:
          FOR EACH tt-etiquetas 
              BREAK BY tt-etiquetas.it-codigo:

              IF FIRST-OF(tt-etiquetas.it-codigo)  
              THEN DO:

                  ASSIGN c-nf-item = ""
                         d-tot-ite = 0.
                  
                  FOR EACH b-tt-etiquetas WHERE
                           b-tt-etiquetas.it-codigo = tt-etiquetas.it-codigo
                           NO-LOCK
                      BREAK BY b-tt-etiquetas.nr-nota-fis.
                  
                      IF FIRST-OF(b-tt-etiquetas.nr-nota-fis) THEN
                      ASSIGN c-nf-item = c-nf-item + string(b-tt-etiquetas.nr-nota-fis) + "/".
                            
                      ASSIGN d-tot-ite = d-tot-ite + b-tt-etiquetas.qtde.
                  END.

                  RUN piModeloB(INPUT d-tot-ite).

              END.
          END.
       END.
    END.

    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.

    session:set-wait-state ("").

    RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiModeloB wWindow 
PROCEDURE PiModeloB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER d-saldo AS INTEGER  NO-UNDO.

   DEFINE VAR i-rep AS INTEGER NO-UNDO.

   FIND FIRST Wm-item-embalagem-local WHERE
              Wm-item-embalagem-local.cod-estabel   = tt-etiquetas.cod-estabel
          AND Wm-item-embalagem-local.cod-local     = INPUT FRAME fPage0 fi-local
          AND Wm-item-embalagem-local.cod-item      = tt-etiquetas.it-codigo
          //AND Wm-item-embalagem-local.cod-embalagem = INPUT FRAME fPage0 fi-emb
          AND Wm-item-embalagem-local.log-padrao    = YES
              NO-LOCK NO-ERROR.

   ASSIGN i-rep = 0.
   REPEAT:

       ASSIGN i-rep = i-rep + 1.

       IF AVAIL Wm-item-embalagem-local 
       THEN DO:
           IF d-saldo <= Wm-item-embalagem-local.qtd-item-emb 
           THEN DO:
              RUN pi-acompanhar IN h-acomp ("Item: " + tt-etiquetas.it-codigo).

              ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esclt015b-" + tt-etiquetas.it-codigo + "-" + STRING(i-rep) + "-" +  STRING(TIME) + ".docx".

              OS-COPY VALUE(SEARCH("esp/clt/esclt015b.docx")) VALUE(c-arquivo).

              CREATE "Word.Application" AppWord.
              AppWord:Documents:OPEN(c-arquivo).
              AppWord:VISIBLE = FALSE.

              ASSIGN i-pagina = 1.

              /**/

              FOR FIRST nota-fiscal NO-LOCK
                  WHERE nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
                  AND   nota-fiscal.serie       = tt-etiquetas.serie
                  AND   nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis:
              END.

              FOR FIRST emitente NO-LOCK
                  WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
              END.

              FOR FIRST filial-cliente NO-LOCK
                  WHERE filial-cliente.cnpj = emitente.cgc:
              END.

              FIND FIRST ITEM WHERE
                         ITEM.it-codigo = tt-etiquetas.it-codigo
                         NO-LOCK NO-ERROR.

              FOR FIRST item-mat NO-LOCK
                  WHERE item-mat.it-codigo = tt-etiquetas.it-codigo:
              END.

              ASSIGN c-bc-ean = "".

              RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.

              RUN generateEAN13 IN h-bcapi016 (INPUT SUBSTRING(item-mat.cod-ean,1,12),OUTPUT c-bc-ean).

              DELETE PROCEDURE h-bcapi016.
              ASSIGN h-bcapi016 = ?.

              /* In°cio Cabeáalho */
              AppWord:ActiveWindow:ActivePane:View:SeekView = 9. /* wdSeekCurrentPageHeader */

              /* NF */
              AppWord:Selection:MoveDown(5, 1).
              AppWord:Selection:EndKey(5). /* wdLine */
              AppWord:Selection:TypeText(string(c-nf-item)).

              /* Fim Cabecalho */
              AppWord:ActiveWindow:ActivePane:View:SeekView = 0. /* wdSeekMainDocument */

              /* Posiciona o Cursor no in°cio do documento */
              AppWord:Selection:HomeKey(6).

              /**/

              RUN piWordNovaPaginaB.

              //Nova linha
              AppWord:Selection:InsertRowsBelow(1).

              AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(1):Select.
              AppWord:Selection:Font:Size = 18.
              AppWord:Selection:Font:Bold = 0.
              AppWord:Selection:TypeText(STRING(tt-etiquetas.it-codigo)).

              AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(2):Select.
              AppWord:Selection:Font:Size = 18.
              AppWord:Selection:Font:Bold = 0.
              AppWord:Selection:TypeText(SUBSTRING(ITEM.desc-item,1,50)).        

              AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(3):Select.
              AppWord:Selection:Font:Size = 18.
              AppWord:Selection:Font:Bold = 0.
              AppWord:Selection:TypeText(STRING(d-saldo)). 

              AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(4):Select.
              AppWord:Selection:Font:Size = 18.
              AppWord:Selection:Font:Bold = 0.
              AppWord:Selection:TypeText(SUBSTRING(item-mat.cod-ean,1,12)).

              ASSIGN i-linha = -1
                     i-regs = 0
                     c-lado = "".  

              AppWord:ActiveDocument:Save().
              AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).

              AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
              AppWord:QUIT().                                              /* Fechar o WORD */
              RELEASE OBJECT AppWord.

              LEAVE. //Sai da repetiá∆o
           END.
           ELSE DO:
               RUN pi-acompanhar IN h-acomp ("Item: " + tt-etiquetas.it-codigo).

               ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esclt015b-" + tt-etiquetas.it-codigo + "-" + STRING(i-rep) + "-" +  STRING(TIME) + ".docx".

               OS-COPY VALUE(SEARCH("esp/clt/esclt015b.docx")) VALUE(c-arquivo).

               CREATE "Word.Application" AppWord.
               AppWord:Documents:OPEN(c-arquivo).
               AppWord:VISIBLE = FALSE.

               ASSIGN i-pagina = 1.

               /**/

               FOR FIRST nota-fiscal NO-LOCK
                   WHERE nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
                   AND   nota-fiscal.serie       = tt-etiquetas.serie
                   AND   nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis:
               END.

               FOR FIRST emitente NO-LOCK
                   WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
               END.

               FOR FIRST filial-cliente NO-LOCK
                   WHERE filial-cliente.cnpj = emitente.cgc:
               END.

               FIND FIRST ITEM WHERE
                          ITEM.it-codigo = tt-etiquetas.it-codigo
                          NO-LOCK NO-ERROR.

               FOR FIRST item-mat NO-LOCK
                   WHERE item-mat.it-codigo = tt-etiquetas.it-codigo:
               END.

               ASSIGN c-bc-ean = "".

               RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.

               RUN generateEAN13 IN h-bcapi016 (INPUT SUBSTRING(item-mat.cod-ean,1,12),OUTPUT c-bc-ean).

               DELETE PROCEDURE h-bcapi016.
               ASSIGN h-bcapi016 = ?.

               /* In°cio Cabeáalho */
               AppWord:ActiveWindow:ActivePane:View:SeekView = 9. /* wdSeekCurrentPageHeader */

               /* NF */
               AppWord:Selection:MoveDown(5, 1).
               AppWord:Selection:EndKey(5). /* wdLine */
               AppWord:Selection:TypeText(string(c-nf-item)).

               /* Fim Cabecalho */
               AppWord:ActiveWindow:ActivePane:View:SeekView = 0. /* wdSeekMainDocument */

               /* Posiciona o Cursor no in°cio do documento */
               AppWord:Selection:HomeKey(6).

               /**/

               RUN piWordNovaPaginaB.

               //Nova linha
               AppWord:Selection:InsertRowsBelow(1).

               AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(1):Select.
               AppWord:Selection:Font:Size = 18.
               AppWord:Selection:Font:Bold = 0.
               AppWord:Selection:TypeText(STRING(tt-etiquetas.it-codigo)).

               AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(2):Select.
               AppWord:Selection:Font:Size = 18.
               AppWord:Selection:Font:Bold = 0.
               AppWord:Selection:TypeText(SUBSTRING(ITEM.desc-item,1,50)).        

               AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(3):Select.
               AppWord:Selection:Font:Size = 18.
               AppWord:Selection:Font:Bold = 0.
               AppWord:Selection:TypeText(STRING(Wm-item-embalagem-local.qtd-item-emb)). 

               AppWord:Selection:Tables:Item(1):Rows:ITEM(2):Cells:Item(4):Select.
               AppWord:Selection:Font:Size = 18.
               AppWord:Selection:Font:Bold = 0.
               AppWord:Selection:TypeText(SUBSTRING(item-mat.cod-ean,1,12)).

               ASSIGN i-linha = -1
                      i-regs = 0
                      c-lado = "".  

               AppWord:ActiveDocument:Save().
               AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).

               AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
               AppWord:QUIT().                                              /* Fechar o WORD */
               RELEASE OBJECT AppWord.

               ASSIGN d-saldo = d-saldo - Wm-item-embalagem-local.qtd-item-emb.
           END.
       END.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordNovaPagina wWindow 
PROCEDURE piWordNovaPagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pagina <> 1 THEN DO:

        AppWord:Selection:EndKey(6).
        AppWord:Selection:TypeParagraph.
        AppWord:Selection:InsertBreak(7).
        
        ASSIGN i-linha = 1
               i-regs = 1
               c-lado = "".
    END.

    AppWord:Selection:Tables:Add(AppWord:Selection:Range, 2, 4, 1, 0).
    
    AppWord:Selection:Tables:Item(1):Columns:ITEM(1):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(1):PreferredWidth = 8 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):PreferredWidth = 1.49 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(3):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(3):PreferredWidth = 8 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):PreferredWidth = 1.49 *  28.35.
    
    AppWord:Selection:Tables:Item(1):Borders:Item(-5):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-6):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-7):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-8):LineStyle = 0.
    
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):LineStyle = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):LineWidth = 4.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):Color = -16777216.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):LineStyle = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):LineWidth = 4.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):Color = -16777216.

    AppWord:Selection:Tables:Item(1):Columns:Item(2):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.

    AppWord:Selection:Tables:Item(1):SELECT.
    AppWord:Selection:Cells:VerticalAlignment = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordNovaPaginaB wWindow 
PROCEDURE piWordNovaPaginaB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pagina <> 1 THEN DO:

        AppWord:Selection:EndKey(6).
        AppWord:Selection:TypeParagraph.
        AppWord:Selection:InsertBreak(7).
        
        ASSIGN i-linha = 1
               i-regs = 1
               c-lado = "".
    END.

    AppWord:Selection:Tables:Add(AppWord:Selection:Range, 1, 4, 1, 0).

    AppWord:Selection:Tables:Item(1):Columns:Item(1):PreferredWidth = 100.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):PreferredWidth = 400.
    AppWord:Selection:Tables:Item(1):Columns:Item(3):PreferredWidth = 100.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):PreferredWidth = 200.

    AppWord:Selection:Tables:Item(1):Rows:ITEM(1):Cells:Item(1):Select.
    AppWord:Selection:Font:Size = 20.
    AppWord:Selection:Font:Bold = 9999998.
    AppWord:Selection:TypeText("C¢digo Intelbras").

    AppWord:Selection:Tables:Item(1):Rows:ITEM(1):Cells:Item(2):Select.
    AppWord:Selection:Font:Size = 20.
    AppWord:Selection:Font:Bold = 9999998.
    AppWord:Selection:TypeText("Descriá∆o").

    AppWord:Selection:Tables:Item(1):Rows:ITEM(1):Cells:Item(3):Select.
    AppWord:Selection:Font:Size = 20.
    AppWord:Selection:Font:Bold = 9999998.
    AppWord:Selection:TypeText("Qtd").

    AppWord:Selection:Tables:Item(1):Rows:ITEM(1):Cells:Item(4):Select.
    AppWord:Selection:Font:Size = 20.
    AppWord:Selection:Font:Bold = 9999998.
    AppWord:Selection:TypeText("EAN 13").

    AppWord:Selection:Tables:Item(1):Columns:Item(2):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.

    AppWord:Selection:Tables:Item(1):SELECT.
    AppWord:Selection:Cells:VerticalAlignment = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordNovoQuadro wWindow 
PROCEDURE piWordNovoQuadro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-linha <> 1 THEN DO:

        IF i-linha <= i-lins-por-pagina THEN DO:
            AppWord:Selection:InsertRowsBelow(1).
            AppWord:Selection:InsertRowsBelow(1).
        END.
        ELSE DO:

            RUN piWordNovaPagina.

        END.    

    END.

    AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha):HeightRule = 1.
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Height = 0.5 * 28.35.
    AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):HeightRule = 1.
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Height = 1.22 * 28.35.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(2):Select.
    AppWord:Selection:TypeText("QTDE").
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(4):Select.
    AppWord:Selection:TypeText("QTDE").
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
    AppWord:Selection:Borders:ITEM(-1):LineStyle = AppWord:Options:DefaultBorderLineStyle.
    AppWord:Selection:Borders:ITEM(-1):LineWidth = AppWord:Options:DefaultBorderLineWidth.
    AppWord:Selection:Borders:ITEM(-1):Color     = AppWord:Options:DefaultBorderColor.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(1):SELECT.
    AppWord:Selection:Font:Name = "EAN-13 Half Height".
    AppWord:Selection:Font:Size = 36.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(2):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(3):SELECT.
    AppWord:Selection:Font:Name = "EAN-13 Half Height".
    AppWord:Selection:Font:Size = 36.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(4):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordTotal wWindow 
PROCEDURE piWordTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-linha = i-linha + 2.

    AppWord:Selection:InsertRowsBelow(1).
    AppWord:Selection:Cells:Merge.

    AppWord:Selection:Borders:ITEM(-1):LineStyle = AppWord:Options:DefaultBorderLineStyle.
    AppWord:Selection:Borders:ITEM(-1):LineWidth = AppWord:Options:DefaultBorderLineWidth.
    AppWord:Selection:Borders:ITEM(-1):Color     = AppWord:Options:DefaultBorderColor.

    AppWord:Selection:ParagraphFormat:Alignment = 0.
    AppWord:Selection:Font:Size = 14.
    AppWord:Selection:Font:Bold = 9999998.

    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(1):Select.
   // AppWord:Selection:TypeText("NRO. VOLUMES: " + STRING(i-nr-volumes)). 
    AppWord:Selection:TypeText("NRO. VOLUMES: " + STRING(tt-etiquetas.nr-volume)).

    ASSIGN i-nr-volumes = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-volume wWindow 
FUNCTION fn-volume RETURNS INTEGER
  ( INPUT c-est AS CHAR, INPUT c-ser AS CHAR, INPUT c-nf AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i-soma AS INTE NO-UNDO.

  ASSIGN i-soma = 0.

  FOR EACH volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = c-est
        AND   volume-nf.serie       = c-ser
        AND   volume-nf.nr-nota-fis = c-nf:
        //AND   volume-nf.nr-volume   = i-volume
      ASSIGN i-soma = i-soma + 1.
  END.

  RETURN i-soma.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

