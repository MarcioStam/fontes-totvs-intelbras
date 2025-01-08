&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcontenedor NO-UNDO LIKE contenedor
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escpp017 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp017
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Principal,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp btAtualiza btEtiquetao btEtiquetinha btImprime ~
                              btQuadro
&GLOBAL-DEFINE page1Widgets   fi-desc-item fi-descricao-1 fi-descricao-2 ~
                              fi-it-codigo fi-local fi-peso fi-quantidade ~
                              btConfirma
&GLOBAL-DEFINE page2Widgets   btconfigimpr
&GLOBAL-DEFINE page3Widgets   fi-it-codigo fi-desc-item fi-cont-fim fi-cont-ini fi-quantidade ~
                              btImpr
&GLOBAL-DEFINE page4Widgets   fi-cont-fim fi-cont-ini fi-descricao-1 fi-descricao-2 ~
                              fi-it-codigo fi-local fi-quantidade cseqi cseqf btImpr-2
&GLOBAL-DEFINE page5Widgets   fi-linha-1 fi-linha-2 fi-linha-3 fi-linha-4 fi-linha-5 fi-qtd ~
                              btImpr-3
&GLOBAL-DEFINE ttTable        ttcontenedor
&GLOBAL-DEFINE hDBOTable      dbocontenedor
&GLOBAL-DEFINE DBOTable       boes041

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR i-campo AS INT NO-UNDO.
DEFINE VARIABLE h-label-pg      AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-cont-ant AS INT NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
def var c-col1 as INT NO-UNDO.
def var c-col2 as INT NO-UNDO.
DEF VAR l-etiquetao AS LOGICAL NO-UNDO.
DEF VAR vqtd AS INT.
DEF VAR i AS INT.

DEFINE VARIABLE i-nr-contenedor AS INTEGER     NO-UNDO.

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btExit btHelp ~
btAtualiza btImprime btEtiquetao btEtiquetinha btQuadro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-it-codigo fi-it-codigo fi-it-codigo fi-quantidade ~
fi-quantidade fi-cont-ini fi-cont-fim fi-quantidade fi-cont-ini fi-cont-fim 
&Scoped-define List-2 btAtualiza btImprime btEtiquetao btEtiquetinha ~
btQuadro 
&Scoped-define List-3 fpage4 fpage5 fPage1 fPage3 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-change-folder wWindow 
FUNCTION fn-change-folder RETURNS LOGICAL PRIVATE
  ( theButton AS WIDGET-HANDLE )  FORWARD.

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
DEFINE BUTTON btAtualiza 
     LABEL "&Atualiza" 
     SIZE 10 BY 1.

DEFINE BUTTON btEtiquetao 
     LABEL "&Etiquet∆o" 
     SIZE 10 BY 1.

DEFINE BUTTON btEtiquetinha 
     LABEL "Etiquetinha" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btImprime 
     LABEL "&Imprime" 
     SIZE 10 BY 1.

DEFINE BUTTON btQuadro 
     LABEL "&Quadro" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btConfirma 
     LABEL "&Confirma" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-1 AS CHARACTER FORMAT "x(18)" 
     LABEL "Descriá∆o 1a. Linha" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-2 AS CHARACTER FORMAT "x(18)" 
     LABEL "Descriá∆o 2a. Linha" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "999.999-9" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "x(7)" 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-peso AS DECIMAL FORMAT ">,>>9.9999" INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Qtd Itens" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.25.

DEFINE BUTTON btImpr 
     LABEL "&Imprime Etiquetas" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-cont-fim AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Contenedor Final" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cont-ini AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Contenedor Inicial" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE BUTTON btImpr-2 
     LABEL "&Imprime Etiquetas" 
     SIZE 15 BY 1.

DEFINE VARIABLE cseqf AS INTEGER FORMAT ">>>>9":U INITIAL 1 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cseqi AS INTEGER FORMAT ">>>>9":U INITIAL 1 
     LABEL "Sequància" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btImpr-3 
     LABEL "&Imprime Etiquetas" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-linha-1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Linha 1" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-linha-2 AS CHARACTER FORMAT "X(30)":U 
     LABEL "Linha 2" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-linha-3 AS CHARACTER FORMAT "X(30)":U 
     LABEL "Linha 3" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-linha-4 AS CHARACTER FORMAT "X(30)":U 
     LABEL "Linha 4" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-linha-5 AS CHARACTER FORMAT "X(30)":U 
     LABEL "Linha 5" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Quantidade Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     btAtualiza AT ROW 1.29 COL 2
     btImprime AT ROW 1.29 COL 12
     btEtiquetao AT ROW 1.29 COL 22
     btEtiquetinha AT ROW 1.29 COL 32
     btQuadro AT ROW 1.29 COL 42
     rtToolBar AT ROW 16.54 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     btConfigImpr AT ROW 5.58 COL 61.29 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     fiPrinter AT ROW 5.75 COL 17 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     "Impressora" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 4.75 COL 13
     RECT-4 AT ROW 5 COL 11
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fpage5
     fi-linha-1 AT ROW 1.17 COL 15 COLON-ALIGNED
     fi-linha-2 AT ROW 2.17 COL 15 COLON-ALIGNED
     fi-linha-3 AT ROW 3.17 COL 15 COLON-ALIGNED
     fi-linha-4 AT ROW 4.17 COL 15 COLON-ALIGNED
     fi-linha-5 AT ROW 5.17 COL 15 COLON-ALIGNED
     fi-qtd AT ROW 6.17 COL 15 COLON-ALIGNED
     btImpr-3 AT ROW 7.5 COL 17.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fpage4
     fi-it-codigo AT ROW 1.17 COL 14 COLON-ALIGNED HELP
          "C¢digo do Item"
          LABEL "Item":R5 FORMAT "999.999-9"
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     fi-desc-item AT ROW 1.17 COL 31 COLON-ALIGNED NO-LABEL FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 49.29 BY .88 NO-TAB-STOP 
     fi-descricao-1 AT ROW 2.17 COL 14 COLON-ALIGNED
          LABEL "Descriá∆o 1" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88 NO-TAB-STOP 
     fi-descricao-2 AT ROW 3.17 COL 14 COLON-ALIGNED
          LABEL "Descriá∆o 2" FORMAT "x(18)"
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88 NO-TAB-STOP 
     fi-local AT ROW 4.17 COL 14 COLON-ALIGNED
          LABEL "Local" FORMAT "x(7)"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88 NO-TAB-STOP 
     fi-quantidade AT ROW 5.17 COL 14 COLON-ALIGNED
          LABEL "Qtd Itens" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 12 BY .88 NO-TAB-STOP 
     fi-cont-ini AT ROW 6.17 COL 14 COLON-ALIGNED
          LABEL "Contenedor Inicial" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-cont-fim AT ROW 7.17 COL 14 COLON-ALIGNED
          LABEL "Contenedor Final" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cseqi AT ROW 8.25 COL 14 COLON-ALIGNED WIDGET-ID 2
     cseqf AT ROW 8.25 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btImpr-2 AT ROW 9.25 COL 16
     IMAGE-1 AT ROW 8.25 COL 23 WIDGET-ID 72
     IMAGE-2 AT ROW 8.25 COL 30 WIDGET-ID 74
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage3
     fi-it-codigo AT ROW 1.17 COL 14 COLON-ALIGNED HELP
          "C¢digo do Item"
          LABEL "Item":R5 FORMAT "999.999-9"
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     fi-desc-item AT ROW 1.17 COL 31 COLON-ALIGNED NO-LABEL FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 49.29 BY .88 NO-TAB-STOP 
     fi-quantidade AT ROW 2.17 COL 14 COLON-ALIGNED
          LABEL "Qtd Itens" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88 NO-TAB-STOP 
     fi-cont-ini AT ROW 3.17 COL 14 COLON-ALIGNED
     fi-cont-fim AT ROW 4.17 COL 14 COLON-ALIGNED
     btImpr AT ROW 5.5 COL 16.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage1
     fi-it-codigo AT ROW 1.17 COL 14 COLON-ALIGNED HELP
          "C¢digo do Item"
     fi-desc-item AT ROW 1.17 COL 31 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-quantidade AT ROW 2.17 COL 14 COLON-ALIGNED
     fi-descricao-1 AT ROW 3.25 COL 14 COLON-ALIGNED
     fi-descricao-2 AT ROW 4.25 COL 14 COLON-ALIGNED
     fi-local AT ROW 5.25 COL 14 COLON-ALIGNED
     fi-peso AT ROW 6.25 COL 14 COLON-ALIGNED
     btConfirma AT ROW 7.58 COL 16.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcontenedor T "?" NO-UNDO mgesp contenedor
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
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

{esp/ShowMsg.i}
{window/window.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fpage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btAtualiza IN FRAME fpage0
   2                                                                    */
ASSIGN 
       btAtualiza:PRIVATE-DATA IN FRAME fpage0     = 
                "Atualiza".

/* SETTINGS FOR BUTTON btEtiquetao IN FRAME fpage0
   2                                                                    */
ASSIGN 
       btEtiquetao:PRIVATE-DATA IN FRAME fpage0     = 
                "Etiquet∆o".

/* SETTINGS FOR BUTTON btEtiquetinha IN FRAME fpage0
   2                                                                    */
ASSIGN 
       btEtiquetinha:PRIVATE-DATA IN FRAME fpage0     = 
                "Etiquetinha".

/* SETTINGS FOR BUTTON btImprime IN FRAME fpage0
   2                                                                    */
ASSIGN 
       btImprime:PRIVATE-DATA IN FRAME fpage0     = 
                "Imprime".

/* SETTINGS FOR BUTTON btQuadro IN FRAME fpage0
   2                                                                    */
ASSIGN 
       btQuadro:PRIVATE-DATA IN FRAME fpage0     = 
                "Quadro".

/* SETTINGS FOR FRAME fPage1
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FRAME fPage2
                                                                        */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fPage3
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-cont-fim IN FRAME fPage3
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-cont-ini IN FRAME fPage3
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage3
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fPage3        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fPage3
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fPage3
   NO-ENABLE 1                                                          */
ASSIGN 
       fi-quantidade:READ-ONLY IN FRAME fPage3        = TRUE.

/* SETTINGS FOR FRAME fpage4
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-cont-fim IN FRAME fpage4
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-cont-ini IN FRAME fpage4
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao-1 IN FRAME fpage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao-1:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao-2 IN FRAME fpage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao-2:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage4
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-local IN FRAME fpage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-local:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fpage4
   NO-ENABLE 1                                                          */
ASSIGN 
       fi-quantidade:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FRAME fpage5
   3                                                                    */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
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


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wWindow
ON GO OF FRAME fPage1
DO:

    ASSIGN i-nr-contenedor = 1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0 /* Atualiza */
DO:
    fn-change-folder(SELF).
    HIDE FRAME fpage3.
    HIDE FRAME fpage4.
    HIDE FRAME fpage5.
    VIEW FRAME fpage1.
    CLEAR FRAME fpage1 ALL.

    ASSIGN i-nr-contenedor = 1.

    APPLY "entry" TO fi-it-codigo IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage2 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fPage1 /* Confirma */
DO:
    DO WITH FRAME fpage1:

        IF NOT can-find(FIRST ITEM NO-LOCK 
                        WHERE ITEM.it-codigo = INPUT fi-it-codigo) THEN DO:

            RUN ShowMessage (1, "Item n∆o cadastrado", "")..
            APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
            RETURN NO-APPLY.

        END.

        DO i-cont = (i-nr-contenedor + 1) TO i-cont-ant:

            IF CAN-FIND(FIRST contenedor NO-LOCK                            
                        WHERE contenedor.it-codigo     = INPUT fi-it-codigo 
                        AND   contenedor.nr-contenedor = i-cont             
                        AND   contenedor.situacao      = no) THEN DO:

                RUN ShowMessage (1, "Contenedor cheio", 
                                 SUBSTITUTE("Contenedor &1 est† cheio. N∆o pode ser exclu°do", 
                                            TRIM(STRING(contenedor.nr-contenedor)))).

                APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
                RETURN NO-APPLY.

            END.

        END.

        DO i-cont = (i-nr-contenedor + 1) to i-cont-ant:

            FIND contenedor NO-LOCK                            
                WHERE contenedor.it-codigo     = INPUT fi-it-codigo 
                AND   contenedor.nr-contenedor = i-cont NO-ERROR.

            IF AVAIL contenedor THEN DO:

                RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
                RUN setConstraintIt-codigo IN {&hDBOTable} (INPUT contenedor.it-codigo,
                                                            INPUT contenedor.nr-contenedor) NO-ERROR.
                RUN openQueryStatic IN {&hDBOTable} (INPUT "It-codigo":U) NO-ERROR.
                RUN deleteRecord IN {&hDBOTable}.                        

                IF CAN-FIND(FIRST RowErrors 
                            WHERE RowErrors.errortype = "error") THEN DO:

                    {method/ShowMessage.i1}.
                    {method/ShowMessage.i2 &Modal="YES"}.
                    {method/ShowMessage.i3}.

                END.

            END.

        END.

        DO i-cont = 1 TO i-nr-contenedor:

            IF NOT CAN-FIND(FIRST contenedor NO-LOCK 
                            WHERE contenedor.it-codigo     = INPUT fi-it-codigo 
                            AND   contenedor.nr-contenedor = i-cont) THEN DO:

                EMPTY TEMP-TABLE ttcontenedor.

                CREATE ttcontenedor.
                ASSIGN ttcontenedor.it-codigo     = INPUT fi-it-codigo
                       ttcontenedor.nr-contenedor = i-cont
                       ttcontenedor.lote-multipl  = INPUT fi-quantidade
                       ttcontenedor.situacao      = yes
                       ttcontenedor.descricao-1   = INPUT fi-descricao-1
                       ttcontenedor.descricao-2   = INPUT fi-descricao-2
                       ttcontenedor.local         = INPUT fi-local
                       ttcontenedor.peso          = INPUT fi-peso.
    
                RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
                RUN setConstraintMain IN {&hDBOTable} ("Main") NO-ERROR.
                RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
                RUN setrecord IN {&hDBOTable} (INPUT TABLE ttcontenedor).  
                RUN createRecord IN {&hDBOTable}.                        
                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                    {method/ShowMessage.i1}.
                    {method/ShowMessage.i2 &Modal="YES"}.
                    {method/ShowMessage.i3}.
                END.

            END.

        END.

        FOR EACH contenedor NO-LOCK 
            WHERE contenedor.it-codigo   = INPUT fi-it-codigo:
            
            EMPTY TEMP-TABLE ttcontenedor.
            CREATE ttcontenedor.
            BUFFER-COPY contenedor TO ttcontenedor.
            ASSIGN ttcontenedor.r-rowid      = ROWID(contenedor)
                   ttcontenedor.descricao-1  = INPUT fi-descricao-1
                   ttcontenedor.descricao-2  = INPUT fi-descricao-2
                   ttcontenedor.local        = INPUT fi-local
                   ttcontenedor.peso         = INPUT fi-peso
                   ttcontenedor.lote-multipl = INPUT fi-quantidade.
    
            RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
            RUN setConstraintIt-codigo IN {&hDBOTable} (INPUT contenedor.it-codigo,
                                                        INPUT contenedor.nr-contenedor) NO-ERROR.
            RUN openQueryStatic IN {&hDBOTable} (INPUT "It-codigo":U) NO-ERROR.
            RUN setrecord IN {&hDBOTable} (INPUT TABLE ttcontenedor).  
            RUN updateRecord IN {&hDBOTable}.                        
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                {method/ShowMessage.i1}.
                {method/ShowMessage.i2 &Modal="YES"}.
                {method/ShowMessage.i3}.
            END.        

        END.

        CLEAR FRAME fpage1 ALL.

        APPLY "entry" TO fi-it-codigo IN FRAME fpage1.

    END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btEtiquetao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEtiquetao wWindow
ON CHOOSE OF btEtiquetao IN FRAME fpage0 /* Etiquet∆o */
DO:
    fn-change-folder(SELF).
    HIDE FRAME fpage1.
    HIDE FRAME fpage3.
    HIDE FRAME fpage5.
    VIEW FRAME fpage4.
    CLEAR FRAME fpage4 ALL.
    
    ASSIGN cseqi:SENSITIVE IN FRAME fpage4 = FALSE 
           cseqf:SENSITIVE IN FRAME fpage4 = FALSE.
    
    APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
    l-etiquetao = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEtiquetinha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEtiquetinha wWindow
ON CHOOSE OF btEtiquetinha IN FRAME fpage0 /* Etiquetinha */
DO:
    fn-change-folder(SELF).
    HIDE FRAME fpage1.
    HIDE FRAME fpage3.
    HIDE FRAME fpage5.
    VIEW FRAME fpage4.
    CLEAR FRAME fpage4 ALL.
    
    ASSIGN cseqi:SENSITIVE IN FRAME fpage4 = TRUE 
           cseqf:SENSITIVE IN FRAME fpage4 = TRUE.
    
    APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
    l-etiquetao = NO.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpr wWindow
ON CHOOSE OF btImpr IN FRAME fPage3 /* Imprime Etiquetas */
DO:
    DEF VAR i-it-digito AS INT NO-UNDO.
    DEF VAR c-linha AS CHAR NO-UNDO.

    DO WITH FRAME fpage3:
        FOR FIRST ITEM NO-LOCK WHERE
                  ITEM.it-codigo = INPUT fi-it-codigo:
        END.

        IF NOT AVAIL ITEM THEN DO:
           RUN ShowMessage (1, "Item n∆o cadastrado", "").
           APPLY "entry" TO fi-it-codigo IN FRAME fpage3.
           RETURN NO-APPLY.
        END.

        FOR first contenedor NO-LOCK WHERE
                  contenedor.it-codigo = INPUT fi-it-codigo:
            IF INPUT fi-cont-fim > contenedor.nr-contenedor THEN
               fi-cont-fim:SCREEN-VALUE = STRING(contenedor.nr-contenedor).
        END.

        IF NOT AVAIL contenedor THEN DO:
            RUN ShowMessage (1, "Item sem contenedor", "Item n∆o possui contenedor cadastrado").
            APPLY "entry" TO fi-it-codigo IN FRAME fpage3.
            RETURN NO-APPLY.
        END.

        FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) NO-LOCK  WHERE
                  imprsor_usuar.nom_impressora = ENTRY(1,fiPrinter:SCREEN-VALUE IN FRAME fPage2,":") AND
                  imprsor_usuar.cod_usuario    = c-seg-usuario    use-index imprsrsr_id,
            FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
            FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

            OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so)
                   PAGE-SIZE 0
                   CONVERT TARGET tip_imprsor.cod_pag_carac_conver . 

            DO i-cont = INPUT FRAME fpage3 fi-cont-ini to INPUT FRAME fpage3 fi-cont-fim:
               ASSIGN c-linha = substring(item.it-codigo,1,7) +
                                string(contenedor.lote-multipl,"99999") +
                                string(i-cont,"999").

               RUN esp/es0135(input c-linha,output i-it-digito).

               ASSIGN c-linha = c-linha + string(i-it-digito,"9").
                    DISP "^XA"                                           SKIP

                         "^PW832"      SKIP   /* Novo comando para zebra 600 */
                         "^JUS"        SKIP   /* Novo comando para zebra 600 */

                         "^FO60,40^A0N,49,37^FDITEM^FS"                  SKIP
                         "^FO300,40^A0N,49,37^FD"  +
                         substring(item.it-codigo,1,6) + "-" +
                         substring(item.it-codigo,7,1) +
                         "^FS" 
                         format "x(70)"                                  SKIP
        
                         "^FO60,84^A0N,49,37^FDQUANTIDADE^FS"            SKIP
                         "^FO340,84^A0N,49,37^FD" +
                         string(contenedor.lote-multipl,">>>>9") + "^FS"  
                         format "x(70)"                                  SKIP
                        
                         "^FO60,128^A0N,49,37^FDCONTENEDOR^FS"           SKIP
                         "^FO340,128^A0N,49,37^FD" +
                         string(i-cont,"999") + "^FS" 
                         format "x(70)"                                  SKIP
                        
                         "^FO44,172^A0N,25,22^FD" 
                         item.descricao-1 + item.descricao-2 format "x(36)"
                         "^FS"                                           SKIP
        
                         "^FO50,196^BAN,112,Y,N,N^BY2^FD" +
                         c-linha  +
                         "^FS" format "x(70)"                            SKIP     
                         "^XZ" with frame f-rel1 STREAM-IO.
                         down with frame f-rel1.
            END.

        END.


        CLEAR FRAME fpage3 ALL.
        APPLY "entry" TO fi-it-codigo IN FRAME fpage3.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME btImpr-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpr-2 wWindow
ON CHOOSE OF btImpr-2 IN FRAME fpage4 /* Imprime Etiquetas */
DO:
    DEF VAR i-it-digito AS INT NO-UNDO.
    DEF VAR c-linha AS CHAR NO-UNDO.
    def var i-peso like contenedor.peso NO-UNDO.

    DO WITH FRAME fpage4:
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = INPUT fi-it-codigo:
        END.
        IF NOT AVAIL ITEM THEN DO:
            RUN ShowMessage (1, "Item n∆o cadastrado", "").
            APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
            RETURN NO-APPLY.
        END.

        for first contenedor NO-LOCK
            WHERE contenedor.it-codigo = INPUT fi-it-codigo:
            IF INPUT fi-cont-fim > contenedor.nr-contenedor THEN
                fi-cont-fim:SCREEN-VALUE = STRING(contenedor.nr-contenedor).
            i-peso = contenedor.peso.
        END. 
        IF NOT AVAIL contenedor THEN DO:
            RUN ShowMessage (1, "Item sem contenedor", "Item n∆o possui contenedor cadastrado").
            APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
            RETURN NO-APPLY.
        END.

        FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
            where imprsor_usuar.nom_impressora = ENTRY(1,fiPrinter:SCREEN-VALUE IN FRAME fPage2,":")
            and   imprsor_usuar.cod_usuario    = c-seg-usuario
            use-index imprsrsr_id,
            FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
            FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

            output to value(imprsor_usuar.nom_disposit_so)
                   page-size 0
                   convert target tip_imprsor.cod_pag_carac_conver . 

            do i-cont = INPUT fi-cont-ini to INPUT fi-cont-fim:
                assign c-linha = substring(item.it-codigo,1,7) +
                                 string(contenedor.lote-multipl,"99999") +
                                 string(i-cont,"999").

                        /*Calcula digito verificador*/

                run esp/es0135(input c-linha,output i-it-digito).

                assign c-linha = c-linha + string(i-it-digito,"9").

                IF l-etiquetao THEN DO:
                    disp 
                    "^XA^CFD"                    skip
                    "^FWB"                       skip
                    "^FO50," + string(c-col1,"9999") +
                    "^A0B,150,50^FD"  + input fi-descricao-1 +
                    "^FS"  format "x(70)"       skip
                    "^FO200," + string(c-col2,"9999") +
                    "^A0B,150,50^FD" + input fi-descricao-2 +
                    "^FS" format "x(70)" skip

                    "^FO320,110^A0B,100,50^FD" + string(i-cont,"999") + 
                    "^FS" format "x(70)" skip


                    "^FO450,110^A0B,150,50^FD" + substring(input fi-local,1,5) + 
                    "^FS" format "x(70)" skip
                    "^FO430,80^GB160,380,10^FS" format "x(70)" skip

                    "^FO350,650^A0B,19,17^FD      ITEM: "  +
                    substring(item.it-codigo,1,6) + "-" +
                    substring(item.it-codigo,7,1) +
                    "^FS" 
                    format "x(70)"         skip

                    "^FO380,840^A0B,19,17^FDQUANTIDADE: ^FS"      skip
                    "^FO380,640^A0B,19,17^FD" +
                    string(contenedor.lote-multipl,">>>>9") + "^FS"  
                    format "x(70)"         skip

                    "^FO410,840^A0B,19,17^FDCONTENEDOR: ^FS"  skip
                    "^FO410,640^A0B,19,17^FD" +
                    string(i-cont,"999") + "^FS" 
                    format "x(70)"             skip

                    "^FO440,640^A0B,15,12^FD" 
                    item.descricao-1 + item.descricao-2 format "x(36)"
                    "^FS" skip


                    "^FO470,680^BAB,112,Y,N,N^BY2^FD" +
                    c-linha  +
                    "^FS" format "x(70)" skip     

                    "^FO335,610^GB280,530,05^FS" format "x(70)" skip


                    "^XZ" 
                    with frame f-xrel2 STREAM-IO.
                    down with frame f-xrel2.
                END.


                ELSE DO:
                    DO i = INPUT cseqi TO INPUT cseqf:

                        DISP "^XA"                    SKIP.
                        
                        /*
                        "^FO" + string(c-col1,"9999") +
                        ",30^A0N,100,100^FD"   + input fi-descricao-1 +
                        "^FS"  format "x(70)"       skip
                        
                        "^FO" + string(c-col2,"9999") + 
                        ",120^A0N,160,37^FD"  + input fi-descricao-2 + 
                        "^FS" format "x(70)" skip
                        */
    
    
                        /* Tratamento para impress∆o das descriá‰es */
                        IF INPUT fi-descricao-1 <> "" AND
                           INPUT fi-descricao-2 <> "" THEN DO:
                           DISP 
                                "^FO30,30^A0N,100,100^FD"  + INPUT fi-descricao-1 + "^FS" FORMAT "x(70)"        /* Descriá∆o 1 */
                                  SKIP
            
                                "^FO30,120^A0N,100,100^FD"  + INPUT fi-descricao-2 + "^FS" FORMAT "x(70)"       /* Descriá∆o 2 */
                                  SKIP.
                        END.
                        ELSE DO:
                            IF INPUT fi-descricao-1 <> "" THEN DO:
                                DISP 
                                     "^FO30,80^A0N,100,100^FD"  + INPUT fi-descricao-1 + "^FS" FORMAT "x(70)"   /* Descriá∆o 1 */
                                       SKIP.
                            END.
                            ELSE DO:
                                DISP 
                                     "^FO30,80^A0N,100,100^FD"  + INPUT fi-descricao-2 + "^FS" FORMAT "x(70)"   /* Descriá∆o 2 */
                                       SKIP.
                            END.
                        END.
                        /**********************************************/
    
    
                        DISP 
                            "^FO16,210^GB800,0,05^FS" FORMAT "x(70)"                                    /* Linha Horizontal 1 */
                              SKIP       
             
                            "^FO16,310^GB800,0,05^FS" FORMAT "x(70)"                                    /* Linha Horizontal 2 */
                              SKIP           
            
                            "^FO430,210^GB0,106,05^FS" FORMAT "x(70)"                                   /* Linha Vertical */
                              SKIP                              
        
                            "^FO30,220^A0N,30,30^FDITEM^FS"         
                              SKIP
        
                            "^FO100,250^A0N,70,70^FD" + SUBSTRING(item.it-codigo,1,6) + 
                                                        SUBSTRING(item.it-codigo,7,1) + "^FS" FORMAT "x(70)"  /* C¢digo do item */
                              SKIP
                            
                            "^FO445,220^A0N,30,30^FDQUANTIDADE^FS"      
                              SKIP
        
                            "^FO445,250^A0N,70,70^FD" + STRING(contenedor.lote-multipl,">>>>9") + "^FS" FORMAT "x(70)"   /* Valor da quantidade */        
                              SKIP
    
                            "^FO620,210^GB0,106,05^FS" FORMAT "x(70)"   /* linha vertical */                                /* Linha Vertical */
                              SKIP
                            
                            "^FO630,220^A0N,30,30^FDSEQUENCIA^FS"      
                              SKIP
                            
                            "^FO630,250^A0N,70,70^FD" + STRING(i,">>>>9") + "^FS" FORMAT "x(70)"   /* Valor da sequencia */        
                              SKIP
    
                            
                              WITH FRAME f-rel3 STREAM-IO.
                            
                            /*
                            "^FO16,300^A0N,19,17^FDCONTENEDOR^FS"  skip
                            "^FO280,300^A0N,19,17^FD" +
                            string(i-cont,"999") + "^FS" 
                            format "x(70)"             skip with frame f-rel3 STREAM-IO.
                            */
    
    
                        IF i-peso > 0 THEN 
                           DISP     
                               "^FO16,330^A0N,19,17^FDPESO^FS" 
                                 SKIP
                               "^FO170,330^A0N,19,17^FD" + STRING(i-peso,">>>9.9999") + "^FS" FORMAT "x(70)" 
                                 SKIP 
                                 WITH FRAME f-rel3 STREAM-IO.
    
                        
                        DISP            
                            /*
                            "^FO16,360^A0N,15,12^FD" 
                            item.descricao-1 + item.descricao-2 format "x(36)"
                            "^FS" skip
                            */      
        
                            /*
                            "^FO420,280^A0N,15,12^FDContenedor^FS" format "x(70)" skip
                            "^FO630,280^A0N,15,12^FDLocalizacao^FS" format "x(70)" skip
                            */          
                                      
                            /*
                            "^FO200,207^A0N,100,30^FD" + string(i-cont,"999") + 
                            "^FS" format "x(70)" skip
                            */ 
                        
    
                            "^FO650,217^A0N,100,30^FD" + SUBSTRING(INPUT fi-local,1,5) + "^FS" FORMAT "x(70)"   /* C¢digo de barra */
                              SKIP                                                                              
                                                 
                            "^FO200,330^BAN,50,Y,N,N^BY2^FD" + c-linha + "^FS" FORMAT "x(70)"                   /* Sequencia numÇrica do c¢digo de barra */
                              SKIP     
                            
                            "^XZ" WITH FRAME f-rel3 STREAM-IO.
                            DOWN WITH FRAME f-rel3.
                    END.
                END.
            END.
        END.

        CLEAR FRAME fpage4 ALL.
        APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btImpr-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpr-3 wWindow
ON CHOOSE OF btImpr-3 IN FRAME fpage5 /* Imprime Etiquetas */
DO:
    DEF VAR i-it-digito      AS INT NO-UNDO.
    DEF VAR i-cont           AS INT.

    DO WITH FRAME fpage5: 

       FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) NO-LOCK  WHERE
                 imprsor_usuar.nom_impressora = ENTRY(1,fiPrinter:SCREEN-VALUE IN FRAME fPage2,":") AND  
                 imprsor_usuar.cod_usuario    = c-seg-usuario    USE-INDEX imprsrsr_id,
           FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
           FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:
           
           
           OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so) 
                  PAGE-SIZE 0
                  CONVERT TARGET tip_imprsor.cod_pag_carac_conver . 
           

           DO i-cont = 1 TO int(fi-qtd:SCREEN-VALUE IN FRAME fpage5):

              DISP "^XA"                         SKIP               
                   "^FO40,40^A0N,60,30^FD"   +
                   INPUT fi-linha-1 +
                   "^FS" 
                   FORMAT "x(70)"                SKIP
  
                   "^FO40,110^A0N,50,30^FD"  +
                   INPUT fi-linha-2 +
                   "^FS" 
                   FORMAT "x(70)"                SKIP
  
                   "^FO40,160^A0N,50,30^FD"  +
                   INPUT fi-linha-3 +
                   "^FS" 
                   FORMAT "x(70)"                SKIP
  
                   "^FO40,210^A0N,50,30^FD"  +
                   INPUT fi-linha-4 +
                   "^FS" 
                   FORMAT "x(70)"                SKIP
  
                   "^FO40,260^A0N,50,30^FD"  +
                   INPUT fi-linha-5 +
                   "^FS" 
                   FORMAT "x(70)"                SKIP
                   /* 
                   "^PQ" INPUT fi-qtd            SKIP
                   */
                   "^XZ" WITH FRAME f-rel4 STREAM-IO.
                   DOWN WITH FRAME f-rel4.

           END.

       END.

       CLEAR FRAME fpage5 ALL.
       APPLY "entry" TO fi-linha-1 IN FRAME fpage5.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btImprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprime wWindow
ON CHOOSE OF btImprime IN FRAME fpage0 /* Imprime */
DO:
    fn-change-folder(SELF).
    HIDE FRAME fpage1.
    HIDE FRAME fpage4.
    HIDE FRAME fpage5.
    VIEW FRAME fpage3.
    CLEAR FRAME fpage3 ALL.
    APPLY "entry" TO fi-it-codigo IN FRAME fpage3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQuadro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQuadro wWindow
ON CHOOSE OF btQuadro IN FRAME fpage0 /* Quadro */
DO:
    fn-change-folder(SELF).
    HIDE FRAME fpage1.
    HIDE FRAME fpage4.
    HIDE FRAME fpage3.
    VIEW FRAME fpage5.
    CLEAR FRAME fpage5 ALL.
    APPLY "entry" TO fi-linha-1 IN FRAME fpage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON ENTRY OF fi-it-codigo IN FRAME fPage3 /* Item */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fPage3 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage3"
                       &campo2="fi-it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage3"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fPage3 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = input frame fpage3 fi-it-codigo"}
                     

    IF SELF:PRIVATE-DATA NE SELF:SCREEN-VALUE THEN DO:
        FOR first contenedor NO-LOCK 
            where contenedor.it-codigo = INPUT fi-it-codigo:
            ASSIGN fi-quantidade:SCREEN-VALUE  = STRING(contenedor.lote-multipl).
        /* END. */
/*    */
/*         FOR LAST contenedor NO-LOCK */
/*             where contenedor.it-codigo = INPUT fi-it-codigo: */
            assign fi-cont-fim:SCREEN-VALUE = string(contenedor.nr-contenedor).
        END.
        DISP 1 @ fi-cont-ini WITH FRAME fpage3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fPage3 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON ENTRY OF fi-it-codigo IN FRAME fpage4 /* Item */
DO:
    SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fpage4 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage4"
                       &campo2="fi-it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage4"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage4 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = input frame fpage4 fi-it-codigo"}
                     
    IF SELF:PRIVATE-DATA NE SELF:SCREEN-VALUE THEN DO:
        FOR first contenedor NO-LOCK 
            where contenedor.it-codigo = INPUT fi-it-codigo:
            ASSIGN fi-quantidade:SCREEN-VALUE  = STRING(contenedor.lote-multipl).
        /* END. */
/*    */
/*         FOR LAST contenedor NO-LOCK */
/*             where contenedor.it-codigo = INPUT fi-it-codigo: */
            assign fi-cont-fim:SCREEN-VALUE = string(contenedor.nr-contenedor)
                   fi-descricao-1:SCREEN-VALUE = contenedor.descricao-1
                   fi-descricao-2:SCREEN-VALUE = contenedor.descricao-2
                   fi-local:SCREEN-VALUE = contenedor.local.
            IF btEtiquetao:SENSITIVE IN FRAME fpage0 THEN
                ASSIGN c-col1 = int((1090 - (length(trim(contenedor.descricao-1)) * 52.77)) / 2) + 50
                       c-col2 = int((1090 - (length(trim(contenedor.descricao-2)) * 52.77)) / 2) + 50.
            ELSE
                assign c-col1 = int((730 - (length(trim(contenedor.descricao-1)) * 39.66)) / 2) + 30
                       c-col2 = int((730 - (length(trim(contenedor.descricao-2)) * 39.66)) / 2) + 30.


        END.
        DISP 1 @ fi-cont-ini WITH FRAME fpage4.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fpage4 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage1"
                       &campo2="fi-it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = input frame fpage1 fi-it-codigo"}
                     

    FOR first contenedor NO-LOCK 
        where contenedor.it-codigo = INPUT fi-it-codigo:
        ASSIGN fi-descricao-1:SCREEN-VALUE = contenedor.descricao-1 
               fi-descricao-2:SCREEN-VALUE = contenedor.descricao-2
               fi-local:SCREEN-VALUE       = contenedor.local
               fi-quantidade:SCREEN-VALUE  = STRING(contenedor.lote-multipl)
               fi-peso:SCREEN-VALUE        = STRING(contenedor.peso).
    END.
    assign i-cont-ant   = 0.
    
    FOR LAST contenedor NO-LOCK 
        where contenedor.it-codigo = INPUT fi-it-codigo:
        assign i-nr-contenedor = contenedor.nr-contenedor
               i-cont-ant      = contenedor.nr-contenedor.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-label-pg) THEN
        CASE h-label-pg:SCREEN-VALUE:
            WHEN "Imprime" THEN do:
                HIDE FRAME fpage1.
                HIDE FRAME fpage4.
                HIDE FRAME fpage5.
                VIEW FRAME fpage3.
                APPLY "entry" TO fi-it-codigo IN FRAME fpage3.
            END.
            WHEN "Etiquet∆o" OR WHEN "Etiquetinha" THEN do:
                HIDE FRAME fpage1.
                HIDE FRAME fpage3.
                HIDE FRAME fpage5.
                VIEW FRAME fpage4.
                APPLY "entry" TO fi-it-codigo IN FRAME fpage4.
            END.
            WHEN "Quadro" THEN do:
                HIDE FRAME fpage1.
                HIDE FRAME fpage4.
                HIDE FRAME fpage3.
                VIEW FRAME fpage5.
                APPLY "entry" TO fi-linha-1 IN FRAME fpage5.
            END.
        END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
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

            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage2 = layout_impres.nom_impressora + ":" +
                                                            layout_impres.cod_layout_impres.

        END.

    END.
    
    
    
    
    DEF VAR h-object AS WIDGET-HANDLE NO-UNDO.
    FOR FIRST param-global NO-LOCK:
    END.
    ASSIGN h-object = FRAME fpage0:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:NAME = "Label1" THEN DO:
            h-label-pg = h-object.
            LEAVE.
        END.
        ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
    END.
    APPLY "choose" TO btAtualiza IN FRAME fpage0.
    fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
    fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
    
    RUN initializeDBOs.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        &IF "{&hDBOTable}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable}) THEN
                RUN destroy IN {&hDBOTable}.
        &ENDIF

        &IF "{&hDBOTable2}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable2}) THEN
                RUN destroy IN {&hDBOTable2}.
        &ENDIF

        &IF "{&hDBOTable3}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable3}) THEN
                RUN destroy IN {&hDBOTable3}.
        &ENDIF

        &IF "{&hDBOTable4}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable4}) THEN
                RUN destroy IN {&hDBOTable4}.
        &ENDIF

        &IF "{&hDBOTable5}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable5}) THEN
                RUN destroy IN {&hDBOTable5}.
        &ENDIF
        
        &IF "{&hDBOTable6}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable6}) THEN
                RUN destroy IN {&hDBOTable6}.
        &ENDIF

        &IF "{&hDBOTable7}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable7}) THEN
                RUN destroy IN {&hDBOTable7}.
        &ENDIF

        &IF "{&hDBOTable8}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable8}) THEN
                RUN destroy IN {&hDBOTable8}.
        &ENDIF

        &IF "{&hDBOTable9}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable9}) THEN
                RUN destroy IN {&hDBOTable9}.
        &ENDIF
        
        &IF "{&hDBOTable10}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable10}) THEN
                RUN destroy IN {&hDBOTable10}.
        &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes041.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes041.p YES}
        {btb/btb008za.i2 esbo/boes041.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

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

    ASSIGN INPUT FRAME fPage2 fiPrinter.

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
        WITH FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-change-folder wWindow 
FUNCTION fn-change-folder RETURNS LOGICAL PRIVATE
  ( theButton AS WIDGET-HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ENABLE {&List-2} WITH FRAME fpage0.
  theButton:SENSITIVE = NO.
  h-label-pg:SCREEN-VALUE = theButton:PRIVATE-DATA.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

