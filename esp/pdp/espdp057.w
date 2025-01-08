&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
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
{include/i-prgvrs.i espdp057 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp057
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-redutor-carteira btExit btHelp 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
DEFINE VARIABLE de-vl-redutor AS DECIMAL     NO-UNDO.

/* Parameters Definitions ---                                           */



/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-redutor-carteira

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES faturamento redutor-carteira

/* Definitions for BROWSE br-redutor-carteira                           */
&Scoped-define FIELDS-IN-QUERY-br-redutor-carteira faturamento.periodo ~
faturamento.unid-neg faturamento.vl-cart redutor-carteira.da-data-validade ~
redutor-carteira.vlr-redutor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-redutor-carteira ~
redutor-carteira.vlr-redutor 
&Scoped-define ENABLED-TABLES-IN-QUERY-br-redutor-carteira redutor-carteira
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-redutor-carteira redutor-carteira
&Scoped-define QUERY-STRING-br-redutor-carteira FOR EACH faturamento ~
      WHERE  faturamento.periodo = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") ~
 ~
 NO-LOCK, ~
      EACH redutor-carteira WHERE redutor-carteira.unid-neg = faturamento.unid-neg ~
  AND redutor-carteira.da-data-validade = today OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-redutor-carteira OPEN QUERY br-redutor-carteira FOR EACH faturamento ~
      WHERE  faturamento.periodo = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") ~
 ~
 NO-LOCK, ~
      EACH redutor-carteira WHERE redutor-carteira.unid-neg = faturamento.unid-neg ~
  AND redutor-carteira.da-data-validade = today OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-redutor-carteira faturamento ~
redutor-carteira
&Scoped-define FIRST-TABLE-IN-QUERY-br-redutor-carteira faturamento
&Scoped-define SECOND-TABLE-IN-QUERY-br-redutor-carteira redutor-carteira


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-redutor-carteira}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-redutor-carteira btExit btHelp ~
rtToolBar-2 rtToolBar RECT-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 11.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-redutor-carteira FOR 
      faturamento, 
      redutor-carteira SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-redutor-carteira
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-redutor-carteira wWindow _STRUCTURED
  QUERY br-redutor-carteira NO-LOCK DISPLAY
      faturamento.periodo FORMAT "9999/99":U WIDTH 9.43
      faturamento.unid-neg FORMAT "X(5)":U
      faturamento.vl-cart FORMAT "->>>,>>>,>>9.99":U
      redutor-carteira.da-data-validade FORMAT "99/99/9999":U
      redutor-carteira.vlr-redutor FORMAT "->>>>,>>>,>>9.99":U
            WIDTH 10.29
  ENABLE
      redutor-carteira.vlr-redutor
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 10.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-redutor-carteira AT ROW 3.5 COL 12 WIDGET-ID 200
     btExit AT ROW 1.13 COL 72.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 76.57 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 14.96 COL 1
     RECT-2 AT ROW 3 COL 2.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 15.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.5
         WIDTH              = 80.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* BROWSE-TAB br-redutor-carteira 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-redutor-carteira
/* Query rebuild information for BROWSE br-redutor-carteira
     _TblList          = "mgesp.faturamento,mgesp.redutor-carteira WHERE mgesp.faturamento ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", OUTER"
     _Where[1]         = " faturamento.periodo = STRING(YEAR(TODAY), ""9999"") + STRING(MONTH(TODAY), ""99"")

"
     _JoinCode[2]      = "mgesp.redutor-carteira.unid-neg = mgesp.faturamento.unid-neg
  AND mgesp.redutor-carteira.da-data-validade = today"
     _FldNameList[1]   > mgesp.faturamento.periodo
"faturamento.periodo" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[2]   = mgesp.faturamento.unid-neg
     _FldNameList[3]   = mgesp.faturamento.vl-cart
     _FldNameList[4]   = mgesp.redutor-carteira.da-data-validade
     _FldNameList[5]   > mgesp.redutor-carteira.vlr-redutor
"redutor-carteira.vlr-redutor" ? ? "decimal" ? ? ? ? ? ? yes ? no no "16.86" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-redutor-carteira */
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
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */

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


&Scoped-define BROWSE-NAME br-redutor-carteira
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&open-query-br-redutor-carteira}
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH faturamento NO-LOCK
   WHERE faturamento.periodo = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99"):
        FIND redutor-carteira
             WHERE redutor-carteira.da-data-validade = TODAY
                AND redutor-carteira.unid-neg        = faturamento.unid-neg
              NO-LOCK NO-ERROR.
        IF NOT AVAIL redutor-carteira THEN DO:
            CREATE redutor-carteira.
            ASSIGN redutor-carteira.da-data-validade = TODAY
                   redutor-carteira.unid-neg         = faturamento.unid-neg.
        END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

