&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP106 2.00.00.000}
{include/i-license-manager.i ESCPP106 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP106
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btCancel btHelp2 c-it-codigo cb-modelo ~
                              c-sigla btConfigImpr btReimpressao c-qr-code i-nr-ord-produ btGerar btImpQr
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
 

{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER   NO-UNDO.

DEFINE VARIABLE i-cor         AS INTEGER   NO-UNDO.
DEFINE VARIABLE fc-qr-code    AS CHARACTER NO-UNDO.

DEFINE VARIABLE wh-pesquisa   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VAR c-n-serie          AS CHAR NO-UNDO.
DEFINE VAR c-mac              AS CHAR NO-UNDO EXTENT 10.
DEFINE VAR c-erro             AS CHAR NO-UNDO.
DEFINE VAR i-cont             AS INTE NO-UNDO.

DEFINE BUFFER b-mac-address   FOR mac-address.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-it-codigo c-sigla c-qr-code i-nr-ord-produ ~
btReimpressao btQueryJoins btReportsJoins btExit btHelp c-desc-item ~
c-desc-modelo c-desc-sigla c-cod-estabel c-desc-estabelec cb-modelo ~
btConfigImpr btCancel btHelp2 fiPrinter btGerar btImpQr rtToolBar-2 ~
rtToolBar RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-sigla c-qr-code ~
i-nr-ord-produ c-desc-item c-desc-modelo c-desc-sigla c-cod-estabel ~
c-desc-estabelec cb-modelo fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-carac-esp wWindow 
FUNCTION fn-carac-esp RETURNS CHAR ( INPUT p-palavra AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btGerar 
     LABEL "Gerar NS/MAC" 
     SIZE 12.29 BY 1 TOOLTIP "Gerar numero de serie e MAC".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btImpQr 
     LABEL "Imp QrCode" 
     SIZE 12.29 BY 1 TOOLTIP "Gerar numero de serie e MAC".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReimpressao 
     IMAGE-UP FILE "image/im-lay.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-lay.bmp":U
     LABEL "Reimpress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Reimpress∆o"
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cb-modelo AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Modelo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "         0",000
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 48 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab.Pad.Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sigla AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-qr-code AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qr Code" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .79 NO-UNDO.

DEFINE VARIABLE c-sigla AS CHARACTER FORMAT "X(2)":U 
     LABEL "CÇlula" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ord-produ AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ord.Prod" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 4.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-it-codigo AT ROW 3 COL 18.72 COLON-ALIGNED WIDGET-ID 4
     c-sigla AT ROW 4.83 COL 18.72 COLON-ALIGNED WIDGET-ID 8
     c-qr-code AT ROW 7.13 COL 18.72 COLON-ALIGNED WIDGET-ID 44
     i-nr-ord-produ AT ROW 7.13 COL 52.57 COLON-ALIGNED WIDGET-ID 48
     btReimpressao AT ROW 1.13 COL 47.72 HELP
          "Reimpress∆o" WIDGET-ID 30
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     c-desc-item AT ROW 3 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-desc-modelo AT ROW 3.92 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-desc-sigla AT ROW 4.83 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-cod-estabel AT ROW 5.75 COL 18.72 COLON-ALIGNED WIDGET-ID 42
     c-desc-estabelec AT ROW 5.75 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     cb-modelo AT ROW 3.92 COL 18.72 COLON-ALIGNED WIDGET-ID 32 NO-TAB-STOP 
     btConfigImpr AT ROW 7.96 COL 68.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     btCancel AT ROW 9.58 COL 1.72
     btHelp2 AT ROW 9.58 COL 88.43
     fiPrinter AT ROW 8.04 COL 20.72 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     btGerar AT ROW 9.58 COL 38.43 WIDGET-ID 120
     btImpQr AT ROW 9.58 COL 51.72 WIDGET-ID 122
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 8.13 COL 12.57 WIDGET-ID 26
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 9.38 COL 1
     RECT-1 AT ROW 2.75 COL 1 WIDGET-ID 2
     RECT-2 AT ROW 6.92 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 9.92
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 9.92
         WIDTH              = 98.72
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerar wWindow
ON CHOOSE OF btGerar IN FRAME fpage0 /* Gerar NS/MAC */
DO:
    RUN esp/cpp/escpp106b.w(INPUT INPUT FRAME fPage0 c-it-codigo,
                            INPUT INPUT FRAME fPage0 c-sigla).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpQr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpQr wWindow
ON CHOOSE OF btImpQr IN FRAME fpage0 /* Imp QrCode */
DO:
    RUN esp/cpp/escpp106c.w(INPUT INPUT FRAME fPage0 c-it-codigo,
                            INPUT INPUT FRAME fPage0 c-sigla).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReimpressao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimpressao wWindow
ON CHOOSE OF btReimpressao IN FRAME fpage0 /* Reimpress∆o */
DO:

    RUN esp/cpp/escpp066a.w (INPUT NO).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON F5 OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabelec
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF AVAIL estabelec THEN
        ASSIGN c-desc-estabelec:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
    ELSE
        ASSIGN c-desc-estabelec:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON RETURN OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    APPLY "LEAVE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/zoomfields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"        
                         &FieldScreen1="c-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"        
                         &FieldScreen2="c-desc-item"
                         &Frame2="fPage0"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Item */
DO:
    DO WITH FRAME fPage0:
        ASSIGN c-desc-item:SCREEN-VALUE = "".
    
        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-item:SCREEN-VALUE = item.desc-item.

        END.

        RUN piCarregaModelo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON RETURN OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    ASSIGN SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,7).

    IF SELF:SCREEN-VALUE BEGINS "8" THEN DO:
        FIND FIRST it-altern NO-LOCK
             WHERE it-altern.it-altern = SELF:SCREEN-VALUE NO-ERROR.
        IF AVAIL it-altern THEN
            ASSIGN SELF:SCREEN-VALUE = it-altern.it-codigo.
    END.

    APPLY "LEAVE" TO SELF.

    APPLY "ENTRY" TO c-sigla.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-qr-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-qr-code wWindow
ON RETURN OF c-qr-code IN FRAME fpage0 /* Qr Code */
DO:
    ASSIGN fc-qr-code = fn-carac-esp(INPUT FRAME fPage0 c-qr-code).

    assign input frame fPage0 c-qr-code:screen-value = "". 

    IF INPUT FRAME fPage0 c-it-codigo = ""
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Informe um item.'
                                 + '~~' + 'Informe um item.').
        RETURN "NOK":U.
    END.

    IF INPUT FRAME fPage0 cb-modelo = 000
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'M¢delo invalido.'
                                 + '~~' + 'Modelo informado n∆o cadastrado ou item sem m¢delo vinculado.').
        RETURN "NOK":U.
    END.

    //Limpa variaveis do retorno
    ASSIGN c-erro    = ""
           c-n-serie = "".

    DO i-cont = 1 TO 10: 
        ASSIGN c-mac[i-cont] = "".
    END.
    //Fim limpa variaveis

    RUN esp\cpp\escpp106a.p (INPUT INPUT FRAME fPage0 c-it-codigo,
                            INPUT fc-qr-code,
                            OUTPUT c-n-serie,
                            OUTPUT c-mac,
                            OUTPUT c-erro).

    IF c-erro <> "" 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT c-erro
                                 + '~~' + c-erro).
        RETURN "NOK":U.
    END.

    IF c-n-serie <> "" 
    THEN DO:
        FIND FIRST num-serie WHERE
                   num-serie.n-serie = c-n-serie
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL num-serie 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Numero de serie n∆o cadastrado'
                                     + '~~' +
                                     'Numero de serie ' + c-n-serie + ' n∆o encontrado').
            RETURN "NOK":U.
        END.
        ELSE DO:

           IF num-serie.it-codigo <> INPUT FRAME fPage0 c-it-codigo 
           THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show':U,
                                 INPUT 17006,
                                 INPUT 'Item do Numero de Serie (' + STRING(num-serie.it-codigo) + ') diferente do item selecionado'
                                       + '~~' + 'O Item selecionado Ç diferente do item do Numero de Serie').
              RETURN "NOK":U.
           END.

           RUN piImpressao.

        END.
    END.

    ASSIGN fc-qr-code = "".

/*
    FIND FIRST mac-address WHERE
               mac-address.mac = fc-qr-code
               EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL mac-address
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Mac Address n∆o encontrado.'
                                 + '~~' + 'Verifique se o MAC digitado esta correto').
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF mac-address.n-serie <> "" 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Mac Address j† vinculado a um Numero de Serie.'
                                     + '~~' + 'O Mac ' + string(fc-qr-code) + ' j† vinculado ao NS ' 
                                     + STRING(mac-address.n-serie)).
            RETURN "NOK":U.
        END.

        IF mac-address.it-codigo <> INPUT FRAME fPage0 c-it-codigo 
        THEN DO:
           RUN utp/ut-msgs.p (INPUT 'show':U,
                              INPUT 17006,
                              INPUT 'Item do MAC (' + STRING(mac-address.it-codigo) + ') diferente do item selecionado'
                                    + '~~' + 'O Item selecionado Ç diferente do item do Mac Address').
           RETURN "NOK":U.
        END.

        RUN piImpressao.
    END.

    ASSIGN fc-qr-code = "".
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sigla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON F5 OF c-sigla IN FRAME fpage0 /* CÇlula */
DO: 

    {method/zoomfields.i &ProgramZoom="eszoom\z01es244.w"
                         &FieldZoom1="sigla"        
                         &FieldScreen1="c-sigla"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"        
                         &FieldScreen2="c-desc-sigla"
                         &Frame2="fPage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON LEAVE OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    DO WITH FRAME fPage0:

        ASSIGN c-desc-sigla:SCREEN-VALUE = "".
    
        FOR FIRST ns-sigla NO-LOCK
            WHERE ns-sigla.sigla = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-sigla:SCREEN-VALUE = ns-sigla.descricao.
    
        END.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON MOUSE-SELECT-DBLCLICK OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON VALUE-CHANGED OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    ASSIGN self:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).

    APPLY "END" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modelo wWindow
ON LEAVE OF cb-modelo IN FRAME fpage0 /* Modelo */
DO:

    DO  WITH FRAME fPage0:

        ASSIGN c-desc-modelo:SCREEN-VALUE = "".
    
        FOR FIRST modelo-etiq NO-LOCK
            WHERE modelo-etiq.cod-modelo = int(SELF:SCREEN-VALUE):
    
            ASSIGN c-desc-modelo:SCREEN-VALUE = modelo-etiq.descricao.
            
            ASSIGN i-cont-tot    = 0
                   i-qtd-embalag = 0.
            IF  modelo-etiq.tipo = 5 OR modelo-etiq.tipo = 7 /*DUN14 ou Caixa*/ THEN DO:
                ASSIGN INPUT FRAME fPage0 c-it-codigo.

                SELECT COUNT(*) INTO i-cont-tot FROM item-dun WHERE item-dun.it-codigo = c-it-codigo.

                IF  i-cont-tot > 1 THEN DO:
                    RUN esp\cpp\escpp066b.w (INPUT c-it-codigo, OUTPUT i-qtd-embalag).
                    APPLY "entry":U TO c-sigla IN FRAME fPage0.
                END. /* IF  i-cont-tot > 1 THEN DO: */
                ELSE do: 
                    IF i-cont-tot = 1 THEN DO:
                        FOR FIRST item-dun NO-LOCK WHERE item-dun.it-codigo = c-it-codigo:
                            ASSIGN i-qtd-embalag = item-dun.qtd-emb.
                        END. /* FOR FIRST item-dun NO-LOCK */
                        APPLY "entry":U TO c-sigla IN FRAME fPage0.
                     END.
                END.
            END. /* IF  modelo-etiq.tipo */

            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = INPUT FRAME fPage0 c-it-codigo
                AND   item-mod-etiq.cod-modelo = modelo-etiq.cod-modelo:

            END.

        END. /* FOR FIRST modelo-etiq NO-LOCK */
    END. /* DO  WITH FRAME fPage0: */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modelo wWindow
ON VALUE-CHANGED OF cb-modelo IN FRAME fpage0 /* Modelo */
DO:

    APPLY "leave" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-ord-produ wWindow
ON F5 OF i-nr-ord-produ IN FRAME fpage0 /* Ord.Prod */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in271.w
                       &campo=i-nr-ord-produ IN FRAME fpage0
                       &campozoom=nr-ord-produ
                       &frame=fPage0 }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-ord-produ wWindow
ON MOUSE-SELECT-DBLCLICK OF i-nr-ord-produ IN FRAME fpage0 /* Ord.Prod */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-ord-produ wWindow
ON RETURN OF i-nr-ord-produ IN FRAME fpage0 /* Ord.Prod */
DO:
    APPLY "LEAVE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF c-sigla:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF i-nr-ord-produ:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
FOR FIRST imprsor_usuar NO-LOCK
    WHERE imprsor_usuar.cod_usuario = c-seg-usuario
    AND   imprsor_usuar.log_imprsor_princ:

    FOR FIRST layout_impres NO-LOCK
        WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
        AND   layout_impres.log_layout_impres_princ:

        ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = layout_impres.nom_impressora + ":" +
                                                        layout_impres.cod_layout_impres.
    END.
END.

ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = NO.

APPLY "ENTRY" TO c-it-codigo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCapacidade wWindow 
PROCEDURE piCapacidade :
/*------------------------------------------------------------------------------
  Purpose: Exibe dialog para informar capacidade do pallet
  Notes: Carlos Daniel - 28/01/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER i-capacidade AS INTEGER NO-UNDO.

DEFINE VARIABLE i-qtdCapacidade AS INTEGER FORMAT ">,>>>,>>9"
     LABEL "Cap. (pc)"
     VIEW-AS FILL-IN 
     SIZE 15 BY .75 NO-UNDO.

DEFINE BUTTON btCapacidadeCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btCapacidadeOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtCapacidadeButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fCapacidadeRecord
    i-qtdCapacidade        AT ROW 1.21 COL 8.00 COLON-ALIGNED VIEW-AS FILL-IN FORMAT ">,>>>,>>9"

    btCapacidadeOK      AT ROW 2.63 COL 2.14
    btCapacidadeCancel  AT ROW 2.63 COL 13
    rtCapacidadeButton  AT ROW 2.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Qtde.Capacidade" FONT 1
         DEFAULT-BUTTON btCapacidadeOK CANCEL-BUTTON btCapacidadeCancel.

ON "CHOOSE":U OF btCapacidadeOK IN FRAME fCapacidadeRecord DO:
    ASSIGN i-qtdCapacidade.

    IF i-qtdCapacidade = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Capacidade pallet n∆o informada~~Favor informar a capacidade do Pallet.").
        RETURN "NOK".
    END.

    ASSIGN i-capacidade = i-qtdCapacidade.

    APPLY "GO":U TO FRAME fCapacidadeRecord.
END.

ENABLE i-qtdCapacidade btCapacidadeCancel btCapacidadeOK
    WITH FRAME fCapacidadeRecord. 

WAIT-FOR "GO":U OF FRAME fCapacidadeRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaModelo wWindow 
PROCEDURE piCarregaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:

            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                AND   item-mod-etiq.padrao:
    
                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
    
            END.

        END.
        ELSE DO:

            ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0".

            ASSIGN cb-modelo:SCREEN-VALUE = "0".

        END.

        APPLY "LEAVE" TO cb-modelo.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao wWindow 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-acomp      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-capacidade AS INTEGER NO-UNDO.

    RUN piValidate.

    IF int(i-nr-ord-produ:SCREEN-VALUE IN FRAME fPage0)   <> 0 THEN DO:
       FIND FIRST ord-prod 
            WHERE ord-prod.nr-ord-prod = INPUT FRAME fPage0 i-nr-ord-produ 
       NO-LOCK NO-ERROR.
    
       IF NOT AVAIL ord-prod THEN DO:
          RUN utp/ut-msgs.p (INPUT 'show':U,
                             INPUT 17006,
                             INPUT 'OP invalida.' + '~~' + 'Ordem de producao informada nao encontrada').
          APPLY 'entry':U TO i-nr-ord-produ IN FRAME fpage0.
          RETURN "NOK":U.
       END.
       ELSE DO:
           IF ord-prod.it-codigo <> INPUT FRAME fPage0 c-it-codigo THEN DO:
              RUN utp/ut-msgs.p (INPUT 'show':U,
                                 INPUT 17006,
                                 INPUT 'Produto da OP invalido' + '~~' + 'Produto da OP Ç diferente do produto da etiqueta - ' + ord-prod.it-codigo).
              APPLY 'entry':U TO i-nr-ord-produ IN FRAME fpage0.
              RETURN "NOK":U.
           END.
       END.
    END.


    IF RETURN-VALUE <> "OK":U THEN
        RETURN "NOK":U.

    IF modelo-etiq.tipo = 8 THEN DO:
        RUN piCapacidade(OUTPUT i-capacidade).
        IF i-capacidade = 0 THEN DO:
            MESSAGE "Etiqueta n∆o gerada."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.
        ASSIGN i-qtd-embalag = i-capacidade.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

    EMPTY TEMP-TABLE tt-lista-ns.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = num-serie.n-serie.

    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

    Grava:
    DO TRANSACTION ON ERROR UNDO Grava, LEAVE Grava:

        DO i-cont = 1 TO 10:
            IF c-mac[i-cont] <> "" 
            THEN DO:
                FIND FIRST mac-address WHERE
                           mac-address.mac = c-mac[i-cont]
                           EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL mac-address 
                THEN DO:
                    RUN utp/ut-msgs.p (INPUT 'show':U,
                                       INPUT 17006,
                                       INPUT 'Mac Address n∆o cadastrado'
                                             + '~~' + 'Mac ' + c-mac[i-cont] + ' n∆o cadastrado no sistema').
                    UNDO Grava, LEAVE Grava.
                END.
                ELSE DO:

                    EMPTY TEMP-TABLE tt-prog-ponto.
                    RUN esp/es0018p.p (INPUT "ESCPP106":U, /* Nome do programa */
                                       INPUT 1,            /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "":U,
                                       OUTPUT TABLE tt-prog-ponto).
                    
                    IF NOT CAN-FIND(FIRST tt-prog-ponto WHERE
                                      tt-prog-ponto.conteudo = INPUT FRAME fPage0 c-it-codigo) 
                    THEN DO:
                        IF mac-address.n-serie <> "" 
                        THEN DO:
                            RUN utp/ut-msgs.p (INPUT 'show':U,
                                               INPUT 17006,
                                               INPUT 'Mac Address j† vinculado a outro NS'
                                                     + '~~' + 'Mac ' + STRING(mac-address.mac) + ' j† vinculado ao Numero de Serie ' + mac-address.n-serie).
                            UNDO Grava, LEAVE Grava.
                        END.
                    
                        ASSIGN mac-address.n-serie = c-n-serie.
                    
                        RELEASE mac-address.
                    END.
                END.                
            END. 
        END.

        RUN piImpressao IN h-esapi016 (INPUT INPUT FRAME fPage0 i-nr-ord-produ, /* Num OP */
                                       INPUT INPUT FRAME fPage0 c-it-codigo,
                                       INPUT INPUT FRAME fPage0 cb-modelo,
                                       INPUT INPUT FRAME fPage0 c-sigla,
                                       INPUT 1, // INPUT FRAME fPage0 i-qtd
                                       INPUT i-qtd-embalag,
                                       INPUT 0,  /* Motivo Reimpress∆o */
                                       INPUT 0,  /* Pedido de Compra */
                                       INPUT INPUT FRAME fPage0 fiPrinter,
                                       INPUT 4,  /* N∆o valida nada, pois j† foi validado na geraá∆o. */
                                       INPUT NO, //ASTEC
                                       INPUT i-capacidade,
                                       INPUT TABLE tt-lista-ns).
        
        IF RETURN-VALUE <> "OK":U THEN DO:
        
            EMPTY TEMP-TABLE tt-erro.
        
            RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
        
            RUN pi-finalizar IN h-acomp.
        
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        
            DELETE PROCEDURE h-esapi016.
        
            //RETURN "NOK":U.
            //RETURN ERROR.
            UNDO Grava, LEAVE grava.
        
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    DELETE PROCEDURE h-esapi016.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpTeste wWindow 
PROCEDURE piImpTeste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-cod-etiq-teste AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-capacidade     AS INTEGER     NO-UNDO.

RUN piValidate.

IF RETURN-VALUE <> "OK":U THEN
    RETURN "NOK":U.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

EMPTY TEMP-TABLE tt-lista-ns.

FOR FIRST modelo-etiq NO-LOCK
    WHERE modelo-etiq.cod-modelo = INPUT FRAME fPage0 cb-modelo:

    IF modelo-etiq.tipo = 1 THEN DO:

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando Etiquetas").

        ASSIGN c-cod-etiq-teste = "TESTE" + STRING(MTIME, "99999999").

        CREATE num-serie.
        ASSIGN num-serie.n-serie     = c-cod-etiq-teste                                    
               num-serie.it-codigo   = INPUT FRAME fPage0 c-it-codigo                           
               num-serie.ano         = YEAR(TODAY)                                 
               num-serie.semana      = 99                                 
               num-serie.sequencia   = TIME                                 
               num-serie.num-pedido  = 0
               num-serie.sigla       = CAPS(INPUT FRAME fPage0 c-sigla)
               num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
               num-serie.data        = NOW
               num-serie.usuario     = c-seg-usuario                           
               num-serie.re-impr     = 0
               num-serie.dt-ult-re   = ?                                     
               num-serie.us-ult-re   = ?                                     
               num-serie.motiv-re    = ?                                      
               num-serie.ns-keycode  = ""
            .

        CREATE tt-lista-ns.
        ASSIGN tt-lista-ns.num-serie = c-cod-etiq-teste.

        PAUSE(2).

    END.

END.

RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

RUN piImpressao IN h-esapi016 (INPUT 0, /* Num PO */
                               INPUT INPUT FRAME fPage0 c-it-codigo,
                               INPUT INPUT FRAME fPage0 cb-modelo,
                               INPUT INPUT FRAME fPage0 c-sigla,
                               INPUT 1, // INPUT FRAME fPage0 i-qtd
                               INPUT i-qtd-embalag,
                               INPUT 0,  /* Motivo Reimpress∆o */
                               INPUT 0,  /* Pedido de Compra */
                               INPUT INPUT FRAME fPage0 fiPrinter,
                               INPUT 4,  /* N∆o valida nada, pois j† foi validado na geraá∆o. */
                               INPUT NO, //ASTEC
                               INPUT i-capacidade,
                               INPUT TABLE tt-lista-ns).

IF RETURN-VALUE <> "OK":U THEN DO:

    EMPTY TEMP-TABLE tt-erro.

    RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).

    RUN pi-finalizar IN h-acomp.

    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

    DELETE PROCEDURE h-esapi016.

    FOR EACH tt-lista-ns:

        FOR FIRST num-serie EXCLUSIVE-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:

            DELETE num-serie.

        END.

    END.

    RETURN "NOK":U.

END.

RUN pi-finalizar IN h-acomp.

DELETE PROCEDURE h-esapi016.

FOR EACH tt-lista-ns:

    FOR FIRST num-serie EXCLUSIVE-LOCK
        WHERE num-serie.n-serie = tt-lista-ns.num-serie:

        DELETE num-serie.

    END.

END.

RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate wWindow 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-acesso      AS LOGICAL     NO-UNDO.
ASSIGN c-cod-estabel = v_cod_estab_usuar.

IF  c-cod-estabel = "" OR  c-cod-estabel = ? THEN
    ASSIGN c-cod-estabel = "101".

/* Se a CÇlula foi informada, deve ser v†lida. */
IF INPUT FRAME fPage0 c-sigla <> "" THEN DO:
    IF NOT CAN-FIND(FIRST ns-sigla
                    WHERE ns-sigla.sigla = INPUT FRAME fPage0 c-sigla) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 56,
                       INPUT "CÇlula").
        RETURN "NOK":U.
    END.
END.

FOR FIRST modelo-etiq NO-LOCK
        WHERE modelo-etiq.cod-modelo = INPUT FRAME fPage0 cb-modelo:

    IF  modelo-etiq.tipo = 1 /* N£mero de SÇrie */ THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo = INPUT FRAME fPage0 c-it-codigo
            AND   item-uni-estab.cod-estabel = c-cod-estabel:
    
            FOR FIRST tt-prog-ponto
                WHERE entry(1, tt-prog-ponto.conteudo, ";") = c-cod-estabel
                AND   int(ENTRY(2, tt-prog-ponto.conteudo, ";")) = item-uni-estab.nr-linha:
        
                IF INPUT FRAME fPage0 c-sigla = "" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "CÇlula deve ser informada.").
                    RETURN "NOK":U.
                END.
            END.
        END.

        /********************* Carlos Daniel 13/04/2016 - Chamado 68342 *********************/
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto NO-ERROR.

        FOR EACH usuar_grp_usuar
            WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-LOCK:
        
            IF LOOKUP(usuar_grp_usuar.cod_grp_usuar,tt-prog-ponto.conteudo) > 0 THEN DO:
                ASSIGN l-acesso = YES.
                LEAVE.
            END.
        END.

        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 3,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto NO-ERROR.
        /*
        IF LOOKUP(cb-modelo:SCREEN-VALUE,tt-prog-ponto.conteudo) = 0 THEN DO:
            FOR LAST num-serie
                WHERE num-serie.it-codigo = c-it-codigo:SCREEN-VALUE
                NO-LOCK BY num-serie.data:
            
                IF DATE(num-serie.data) < DATE("01/03/2016") THEN DO:
                    IF l-acesso THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 27100,
                                           INPUT "Revis∆o Item~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Deseja imprimir? " +
                                                 "Caso for impresso, o item ficar† automaticamente liberado para produá∆o." ).
                        IF RETURN-VALUE = "NO" THEN
                            RETURN "NOK":U.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 17006,
                                           INPUT "Item inv†lido~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Solicitar a Engenharia Industrial.").
                        RETURN "NOK":U.
                    END.
                END.
            END.

            IF NOT AVAIL num-serie THEN DO:
                IF l-acesso THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 27100,
                                       INPUT "Revis∆o Item~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Deseja imprimir? " +
                                             "Caso for impresso, o item ficar† automaticamente liberado para produá∆o." ).
                    IF RETURN-VALUE = "NO" THEN
                        RETURN "NOK":U.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 17006,
                                       INPUT "Item inv†lido~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Solicitar a Engenharia Industrial.").
                    RETURN "NOK":U.
                END.
            END.
        END. */
    END.

    IF  modelo-etiq.tipo = 5 OR modelo-etiq.tipo = 7 /* DUN14 */ THEN DO:
        IF  NOT CAN-FIND(FIRST item-dun
                         WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE) THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Item incorreto.' + '~~' + 'Item n∆o possui DUN14 cadastrado.').
            APPLY 'entry':U TO c-it-codigo IN FRAME fpage0.
            RETURN "NOK":U.
        END.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-carac-esp wWindow 
FUNCTION fn-carac-esp RETURNS CHAR ( INPUT p-palavra AS CHAR ):
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-palavra AS CHARACTER   NO-UNDO.

    ASSIGN c-palavra = p-palavra
           c-palavra =  replace(c-palavra, "~{", " ")
           c-palavra =  replace(c-palavra, "~}", " ").
    
    DO i-cont = 1 TO LENGTH(c-palavra):
        IF ASC(SUBSTRING(c-palavra, i-cont, 1)) < 32  OR
           ASC(SUBSTRING(c-palavra, i-cont, 1)) > 125 THEN
            ASSIGN OVERLAY(c-palavra, i-cont, 1) = "":U.
    END.

    RETURN c-palavra.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

