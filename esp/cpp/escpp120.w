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
{include/i-prgvrs.i ESCPP120 2.00.00.000}
{include/i-license-manager.i ESCPP120 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP120
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btCancel btHelp2 c-it-codigo cb-modelo ~
                              c-sigla btConfigImpr  c-qr-code c-patri-claro btRel btReimpressao 
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

DEF NEW GLOBAL SHARED VAR c-qr-code-escpp120 AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.

DEFINE VARIABLE h-esapi038 AS HANDLE      NO-UNDO.

DEFINE VARIABLE l-imprime-item AS LOGICAL     NO-UNDO.

DEFINE VARIABLE i-pat AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-it-codigo c-sigla btConfigImpr c-qr-code ~
c-patri-claro btRel btReimpressao btQueryJoins btReportsJoins btExit btHelp ~
c-desc-item cb-modelo c-desc-modelo c-desc-sigla c-cod-estabel ~
c-desc-estabelec btCancel btHelp2 fiPrinter rtToolBar-2 rtToolBar RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-sigla c-qr-code ~
c-patri-claro c-desc-item cb-modelo c-desc-modelo c-desc-sigla ~
c-cod-estabel c-desc-estabelec fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-carac-esp wWindow 
FUNCTION fn-carac-esp RETURNS CHAR ( INPUT p-palavra AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnModeloEtiq5G wWindow 
FUNCTION FnModeloEtiq5G RETURNS LOGICAL
  ( i-modelo AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProdClaro wWindow 
FUNCTION fnProdClaro RETURNS LOGICAL
  ( c-produto AS CHARACTER )  FORWARD.

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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btRel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Relatorio" 
     SIZE 4 BY 1.25 TOOLTIP "Relatorio"
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
     SIZE 44 BY .88
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

DEFINE VARIABLE c-patri-claro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Patrimonio CLARO" 
     VIEW-AS FILL-IN 
     SIZE 64.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-qr-code AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qr Code" 
     VIEW-AS FILL-IN 
     SIZE 64.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla AS CHARACTER FORMAT "X(2)":U 
     LABEL "CÇlula" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE im-imagem
     FILENAME "adeicon/blank":U
     SIZE 97.43 BY 9.5.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 5.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 2.54.

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
     btConfigImpr AT ROW 6.71 COL 65.29 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     c-qr-code AT ROW 8.38 COL 18.72 COLON-ALIGNED WIDGET-ID 44
     c-patri-claro AT ROW 9.38 COL 18.72 COLON-ALIGNED WIDGET-ID 48
     btRel AT ROW 1.13 COL 43 HELP
          "Reimpress∆o" WIDGET-ID 46
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
     cb-modelo AT ROW 3.92 COL 18.72 COLON-ALIGNED WIDGET-ID 32 NO-TAB-STOP 
     c-desc-modelo AT ROW 3.92 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-desc-sigla AT ROW 4.83 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-cod-estabel AT ROW 5.75 COL 18.72 COLON-ALIGNED WIDGET-ID 42
     c-desc-estabelec AT ROW 5.75 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     btCancel AT ROW 20.96 COL 1.72
     btHelp2 AT ROW 20.96 COL 88.43
     fiPrinter AT ROW 6.75 COL 20.72 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 6.92 COL 12.57 WIDGET-ID 26
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1.14
     rtToolBar AT ROW 20.75 COL 1
     RECT-1 AT ROW 2.83 COL 1.29 WIDGET-ID 2
     RECT-2 AT ROW 8.08 COL 1.29 WIDGET-ID 18
     im-imagem AT ROW 10.83 COL 1.57 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 21.25
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
         HEIGHT             = 21.25
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

/* SETTINGS FOR IMAGE im-imagem IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       im-imagem:HIDDEN IN FRAME fpage0           = TRUE.

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

    RUN esp/cpp/escpp120b.w (INPUT fiPrinter:SCREEN-VALUE IN FRAME {&FRAME-NAME}).   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRel wWindow
ON CHOOSE OF btRel IN FRAME fpage0 /* Relatorio */
DO:
     
    RUN esp\cpp\escpp120a.w. 
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

    RUN piVerificaClaro.
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


&Scoped-define SELF-NAME c-patri-claro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-patri-claro wWindow
ON RETURN OF c-patri-claro IN FRAME fpage0 /* Patrimonio CLARO */
DO: 
    IF SELF:SCREEN-VALUE IN FRAME fpage0 = '' THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Patrimonio CLARO deve ser informado').

       APPLY 'entry' TO c-patri-claro IN FRAME fpage0.

       RETURN "NOK":U.
    END. 


    FIND FIRST int-etiqueta-5g
         WHERE int-etiqueta-5g.patrimonio = c-patri-claro:SCREEN-VALUE IN FRAME fpage0
    NO-LOCK NO-ERROR.

    IF AVAIL int-etiqueta-5g THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Patrimonio CLARO ja foi lido anteriormente~~SN: ' + 
                                int-etiqueta-5g.n-serie ).

       ASSIGN c-qr-code:SCREEN-VALUE IN FRAME fpage0     = ''
              c-patri-claro:SCREEN-VALUE IN FRAME fpage0 = ''.

       APPLY 'entry' TO c-patri-claro IN FRAME fpage0.

       RETURN "NOK":U.
    END.


    ASSIGN INPUT FRAME fpage0 c-it-codigo c-qr-code c-sigla fiPrinter c-patri-claro.

    RUN piImpressao.

    ASSIGN c-patri-claro:SCREEN-VALUE IN FRAME fpage0 = ""
           c-qr-code:SCREEN-VALUE IN FRAME fpage0     = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-qr-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-qr-code wWindow
ON RETURN OF c-qr-code IN FRAME fpage0 /* Qr Code */
DO: 
     
    ASSIGN INPUT FRAME fpage0 c-it-codigo c-qr-code c-sigla fiPrinter c-patri-claro cb-modelo.
    
    ASSIGN fc-qr-code = fn-carac-esp(INPUT FRAME fPage0 c-qr-code).      

    /* Valida */
    RUN piValidaQrcode.

    IF RETURN-VALUE = "NOK" THEN
       RETURN NO-APPLY.
       

    IF NOT fnProdClaro(c-it-codigo) THEN DO:
       RUN piImpressao.

       ASSIGN c-qr-code:SCREEN-VALUE IN FRAME fpage0 = "".
    END.
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

        ASSIGN im-imagem:VISIBLE = TRUE
               l-carregou = im-imagem:LOAD-IMAGE(modelo-etiq.imagem) NO-ERROR.
    
        IF NOT l-carregou THEN ASSIGN im-imagem:VISIBLE = FALSE.

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF c-sigla:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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

ASSIGN c-qr-code    :SENSITIVE IN FRAME fPage0 = NO
       c-patri-claro:SENSITIVE IN FRAME fPage0 = NO.

ASSIGN c-patri-claro:VISIBLE IN FRAME fPage0 = NO.

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

ASSIGN c-qr-code-escpp120 = ''.

//ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = NO.

APPLY "ENTRY" TO c-it-codigo IN FRAME fPage0.





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

        /* Modelos Etiqueta 5G */
        RUN esp/es0018p.p (INPUT "escpp120":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:

            FOR EACH item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                BY item-mod-etiq.padrao DESC:

                IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.

                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).

               LEAVE.
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

RUN esapi\esapi038.p PERSISTENT SET h-esapi038.

RUN piCriaTabelaImpressao IN h-esapi038 (INPUT c-it-codigo,
                                         INPUT c-sigla,
                                         INPUT c-qr-code,
                                         INPUT fiPrinter,
                                         INPUT c-patri-claro,
                                         INPUT cb-modelo,
                                         OUTPUT TABLE tt-erro).               

DELETE PROCEDURE h-esapi038.

RUN cdp/cd0666.w (INPUT TABLE tt-erro).


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

    IF fiPrinter:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN LEAVE.

    ASSIGN c-qr-code:SENSITIVE IN FRAME fPage0 = YES.

    APPLY 'entry' TO c-qr-code IN FRAME fPage0.

    RUN piVerificaClaro.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaImpressora wWindow 
PROCEDURE piSetaImpressora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-impressora  AS CHAR NO-UNDO.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:

    ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
           cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).    

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora    = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.
ELSE DO:
    IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
           cLayout  = ENTRY(2, p-impressora, ":":U).    

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.

    FIND FIRST layout_impres
         WHERE layout_impres.nom_impressora = cPrinter
           AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    IF NOT AVAILABLE layout_impres THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.


ASSIGN v_nom_disposit_so = "".

IF AVAIL imprsor_usuar THEN
    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

/*
MESSAGE 'Pi Seta Impressora' v_nom_disposit_so
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaQrcode wWindow 
PROCEDURE piValidaQrcode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE l-FiberHome AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mac-aux   AS CHARACTER   NO-UNDO.          
          
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

IF INPUT FRAME fPage0 fiPrinter = '' THEN DO:
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 17006,
                       INPUT 'Impressora invalida.'
                             + '~~' + 'Selecione uma impressora para impress∆o').

    ASSIGN c-qr-code:SCREEN-VALUE IN FRAME fPage0 = ''.

    RETURN "NOK":U.
END.


ASSIGN c-erro    = ""
       c-n-serie = "".

DO i-cont = 1 TO 10: 
    ASSIGN c-mac[i-cont] = "".
END.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "escpp120":U,
                   INPUT 4,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    IF INPUT FRAME fPage0 cb-modelo = INT(tt-prog-ponto.conteudo) THEN 
       ASSIGN l-FiberHome = YES
              c-n-serie   = c-qr-code:SCREEN-VALUE
              c-mac-aux   = c-qr-code:SCREEN-VALUE.
END.

IF NOT l-FiberHome THEN
   ASSIGN c-n-serie  = entry(1,c-qr-code:SCREEN-VALUE,';')
          c-mac-aux  = entry(2,c-qr-code:SCREEN-VALUE,';').

IF NOT l-FiberHome THEN DO:

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "escpp120":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN l-imprime-item = NO.

    FIND FIRST item-ean WHERE item-ean.it-codigo = c-it-codigo:SCREEN-VALUE NO-LOCK NO-ERROR.
  
    IF AVAIL item-ean THEN DO:
       FOR EACH tt-prog-ponto:
           IF INDEX(item-ean.nome-abrev,tt-prog-ponto.conteudo) <> 0 THEN
              ASSIGN l-imprime-item = YES.
       END.

       IF item-ean.modelo-mac-address <> 6 AND item-ean.modelo-mac-address <> 9 THEN 
          ASSIGN l-imprime-item = YES.
    END.
      
    IF NOT l-imprime-item THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Produto invalido.'
                                + '~~' + 'Modelo informado n∆o esta cadastrado como sendo da linha 5G.Procure pela Engenharia de produtos').
    
       APPLY 'entry' TO c-it-codigo IN FRAME fpage0.
       RETURN "NOK":U.
    END.
END.


FIND FIRST mac-address NO-LOCK 
     WHERE mac-address.mac = c-mac-aux 
NO-ERROR.

IF NOT AVAIL mac-address AND NOT l-FiberHome THEN DO:
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 17006,
                       INPUT 'Numero de MAC n∆o cadastrado').
    
       RETURN "NOK":U.
END.
  
FIND FIRST num-serie 
     WHERE num-serie.n-serie = c-n-serie
NO-LOCK NO-ERROR.

IF NOT AVAIL num-serie AND NOT l-FiberHome THEN DO:
    RUN utp/ut-msgs.p (INPUT 'show':U,
                       INPUT 17006,
                       INPUT 'Numero de serie n∆o cadastrado'
                             + '~~' +
                             'Numero de serie ' + c-n-serie + ' n∆o encontrado').
    RETURN "NOK":U.
END.

IF l-FiberHome THEN DO:
   IF NOT AVAIL mac-address THEN 
      FIND FIRST mac-address NO-LOCK 
            WHERE mac-address.n-serie = c-mac-aux 
       NO-ERROR.                     

      IF NOT AVAIL mac-address THEN DO:
         RUN utp/ut-msgs.p (INPUT 'show':U,
                            INPUT 17006,
                            INPUT 'SN / MAC nao cadastrado'
                                  + '~~' +
                                  c-n-serie + ' n∆o encontrado').
         RETURN "NOK":U.
      END.
END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaClaro wWindow 
PROCEDURE piVerificaClaro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN c-patri-claro:SCREEN-VALUE IN FRAME fPage0 = ''
       c-patri-claro:VISIBLE      IN FRAME fPage0 = NO
       c-patri-claro:SENSITIVE    IN FRAME fPage0 = NO.

IF fiPrinter:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
   IF fnProdClaro(c-it-codigo:SCREEN-VALUE IN FRAME fpage0) THEN
      ASSIGN c-patri-claro:VISIBLE   IN FRAME fPage0 = YES
             c-patri-claro:SENSITIVE IN FRAME fPage0 = YES.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnModeloEtiq5G wWindow 
FUNCTION FnModeloEtiq5G RETURNS LOGICAL
  ( i-modelo AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  FIND FIRST tt-prog-ponto
       WHERE tt-prog-ponto.conteudo = STRING(i-modelo)
  NO-ERROR.

  IF AVAIL tt-prog-ponto THEN
     RETURN YES.   
  ELSE
     RETURN NO.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProdClaro wWindow 
FUNCTION fnProdClaro RETURNS LOGICAL
  ( c-produto AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE l-claro AS LOGICAL INITIAL NO NO-UNDO.

   FIND FIRST item-ean WHERE item-ean.it-codigo = c-produto  NO-LOCK NO-ERROR.
   
   IF AVAIL item-ean THEN DO:
      IF item-ean.operadora = 1 THEN DO: /* CLARO */
         ASSIGN l-claro = YES.
      END.
   END.         

   RETURN l-claro.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

