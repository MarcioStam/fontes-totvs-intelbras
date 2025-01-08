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
{include/i-prgvrs.i ESFTP9002 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp9002
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
 
&GLOBAL-DEFINE FolderLabels   Faturamento,Recebimento
&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 
 
&GLOBAL-DEFINE page1Widgets   tb-bloqueia-1         tb-bloqueia-2         tb-bloqueia-3         tb-bloqueia-4 ~
                              dt-bloqueia-1         dt-bloqueia-2         dt-bloqueia-3         dt-bloqueia-4 ~
                              c-usuarios-1          c-usuarios-2          c-usuarios-3          c-usuarios-4  ~
                              c-estabelecimentos-1  c-estabelecimentos-2  c-estabelecimentos-3  c-estabelecimentos-4 c-estabelecimentos-5 

&GLOBAL-DEFINE page2Widgets  tb-bloqueia-6  dt-bloqueia-6  c-usuarios-6  c-estabelecimentos-6

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-estabelecimentos-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os estabelecimentos" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabelecimentos-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os estabelecimentos" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabelecimentos-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os estabelecimentos" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabelecimentos-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os estabelecimentos" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabelecimentos-5 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera estab - Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuarios-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os seguintes usu†rios" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuarios-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os seguintes usu†rios" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuarios-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os seguintes usu†rios" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuarios-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os seguintes usu†rios" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .79 NO-UNDO.

DEFINE VARIABLE dt-bloqueia-1 AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Bloquear Liberaá∆o para Faturamento a partir de" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE VARIABLE dt-bloqueia-2 AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Bloqueia FT4002 a partir de" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE VARIABLE dt-bloqueia-3 AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Bloqueia FT4001, FT4100 e FATCOM a partir de:" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE VARIABLE dt-bloqueia-4 AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Bloqueia FT4003 a partir de" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.13.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.13.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.13.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.13.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.17.

DEFINE VARIABLE tb-bloqueia-1 AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-bloqueia-2 AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-bloqueia-3 AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-bloqueia-4 AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE c-estabelecimentos-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os estabelecimentos" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuarios-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Libera para os seguintes usu†rios" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE dt-bloqueia-6 AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Bloquear Liberaá∆o para Recebimento a partir de" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 TOOLTIP "Bloqueia atualizaá∆o no RE1001 e RE1005 para Natur com param gera FAT" NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.13.

DEFINE VARIABLE tb-bloqueia-6 AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 TOOLTIP "Bloqueia atualizaá∆o no RE1001 e RE1005 para Natur com param gera FAT" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btOK AT ROW 20.25 COL 2
     btCancel AT ROW 20.25 COL 13
     btHelp2 AT ROW 20.25 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 20.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.54
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage2
     dt-bloqueia-6 AT ROW 2.25 COL 35.57 COLON-ALIGNED WIDGET-ID 4
     tb-bloqueia-6 AT ROW 2.25 COL 71.29 WIDGET-ID 8
     c-usuarios-6 AT ROW 3.17 COL 35.57 COLON-ALIGNED WIDGET-ID 14
     c-estabelecimentos-6 AT ROW 4.08 COL 35.57 COLON-ALIGNED WIDGET-ID 44
     RECT-9 AT ROW 2.04 COL 3.29 WIDGET-ID 34
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.88
         SIZE 84.43 BY 15.83
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     dt-bloqueia-1 AT ROW 2.25 COL 35.57 COLON-ALIGNED WIDGET-ID 4
     tb-bloqueia-1 AT ROW 2.25 COL 71.29 WIDGET-ID 8
     c-usuarios-1 AT ROW 3.17 COL 35.57 COLON-ALIGNED WIDGET-ID 14
     c-estabelecimentos-1 AT ROW 4.08 COL 35.57 COLON-ALIGNED WIDGET-ID 44
     dt-bloqueia-2 AT ROW 5.5 COL 35.57 COLON-ALIGNED WIDGET-ID 6
     tb-bloqueia-2 AT ROW 5.5 COL 71.29 WIDGET-ID 20
     c-usuarios-2 AT ROW 6.42 COL 35.57 COLON-ALIGNED WIDGET-ID 16
     c-estabelecimentos-2 AT ROW 7.33 COL 35.57 COLON-ALIGNED WIDGET-ID 46
     dt-bloqueia-3 AT ROW 8.75 COL 35.57 COLON-ALIGNED WIDGET-ID 10
     tb-bloqueia-3 AT ROW 8.75 COL 71.29 WIDGET-ID 22
     c-usuarios-3 AT ROW 9.67 COL 35.57 COLON-ALIGNED WIDGET-ID 18
     c-estabelecimentos-3 AT ROW 10.58 COL 35.57 COLON-ALIGNED WIDGET-ID 48
     dt-bloqueia-4 AT ROW 12 COL 35.57 COLON-ALIGNED WIDGET-ID 12
     tb-bloqueia-4 AT ROW 12 COL 71.29 WIDGET-ID 24
     c-usuarios-4 AT ROW 12.92 COL 35.57 COLON-ALIGNED WIDGET-ID 28
     c-estabelecimentos-4 AT ROW 13.88 COL 35.57 COLON-ALIGNED WIDGET-ID 50
     c-estabelecimentos-5 AT ROW 15.29 COL 35.57 COLON-ALIGNED WIDGET-ID 56
     RECT-1 AT ROW 5.29 COL 3.14 WIDGET-ID 26
     RECT-2 AT ROW 11.79 COL 3.14 WIDGET-ID 30
     RECT-3 AT ROW 8.54 COL 3.14 WIDGET-ID 32
     RECT-4 AT ROW 2.04 COL 3.29 WIDGET-ID 34
     RECT-5 AT ROW 15.08 COL 3.14 WIDGET-ID 60
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.88
         SIZE 84.43 BY 15.83
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
         HEIGHT             = 20.54
         WIDTH              = 90
         MAX-HEIGHT         = 40.5
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 40.5
         VIRTUAL-WIDTH      = 274.29
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fpage2
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Salvar */
DO:
    message 'Vocà realmente deseja salvar?' view-as alert-box question buttons yes-no
      update l-confirma as logical format 'Sim/Nao'.
         if l-confirma then do:
            RUN pi-gravar.
         end.
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


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tb-bloqueia-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-bloqueia-1 wWindow
ON MOUSE-SELECT-CLICK OF tb-bloqueia-1 IN FRAME fPage1 /* Bloqueado */
DO:
 IF tb-bloqueia-1:SCREEN-VALUE IN FRAME fpage1= "YES" THEN
      ASSIGN dt-bloqueia-1:SENSITIVE IN FRAME fpage1 = YES
             c-usuarios-1:SENSITIVE IN FRAME fpage1 = YES
             c-estabelecimentos-1:SENSITIVE IN FRAME fpage1 = YES.
 ELSE
      ASSIGN dt-bloqueia-1:SCREEN-VALUE IN FRAME fpage1 = ?
             c-usuarios-1:SCREEN-VALUE IN FRAME fpage1 = ""
             c-estabelecimentos-1:SCREEN-VALUE IN FRAME fpage1 = ""
                      
             dt-bloqueia-1:SENSITIVE IN FRAME fpage1 = NO
             c-usuarios-1:SENSITIVE IN FRAME fpage1 = NO
             c-estabelecimentos-1:SENSITIVE IN FRAME fpage1 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-bloqueia-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-bloqueia-2 wWindow
ON MOUSE-SELECT-CLICK OF tb-bloqueia-2 IN FRAME fPage1 /* Bloqueado */
DO:
 IF tb-bloqueia-2:SCREEN-VALUE IN FRAME fpage1= "YES" THEN
     ASSIGN dt-bloqueia-2:SENSITIVE IN FRAME fpage1 = YES
             c-usuarios-2:SENSITIVE IN FRAME fpage1 = YES
             c-estabelecimentos-2:SENSITIVE IN FRAME fpage1 = YES.
 ELSE
     ASSIGN dt-bloqueia-2:SCREEN-VALUE IN FRAME fpage1 = ?
             c-usuarios-2:SCREEN-VALUE IN FRAME fpage1 = ""
             c-estabelecimentos-2:SCREEN-VALUE IN FRAME fpage1 = ""
                      
             dt-bloqueia-2:SENSITIVE IN FRAME fpage1 = NO
             c-usuarios-2:SENSITIVE IN FRAME fpage1 = NO
             c-estabelecimentos-2:SENSITIVE IN FRAME fpage1 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-bloqueia-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-bloqueia-3 wWindow
ON MOUSE-SELECT-CLICK OF tb-bloqueia-3 IN FRAME fPage1 /* Bloqueado */
DO:
 IF tb-bloqueia-3:SCREEN-VALUE IN FRAME fpage1= "YES" THEN
    ASSIGN dt-bloqueia-3:SENSITIVE IN FRAME fpage1 = YES
           c-usuarios-3:SENSITIVE IN FRAME fpage1 = YES
           c-estabelecimentos-3:SENSITIVE IN FRAME fpage1 = YES.
 ELSE
    ASSIGN dt-bloqueia-3:SCREEN-VALUE IN FRAME fpage1 = ?
           c-usuarios-3:SCREEN-VALUE IN FRAME fpage1 = ""
           c-estabelecimentos-3:SCREEN-VALUE IN FRAME fpage1 = ""
                      
           dt-bloqueia-3:SENSITIVE IN FRAME fpage1 = NO
           c-usuarios-3:SENSITIVE IN FRAME fpage1 = NO
           c-estabelecimentos-3:SENSITIVE IN FRAME fpage1 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-bloqueia-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-bloqueia-4 wWindow
ON MOUSE-SELECT-CLICK OF tb-bloqueia-4 IN FRAME fPage1 /* Bloqueado */
DO:
 IF tb-bloqueia-4:SCREEN-VALUE IN FRAME fpage1= "YES" THEN
     ASSIGN dt-bloqueia-4:SENSITIVE IN FRAME fpage1 = YES
             c-usuarios-4:SENSITIVE IN FRAME fpage1 = YES
             c-estabelecimentos-4:SENSITIVE IN FRAME fpage1 = YES.
 ELSE
     ASSIGN dt-bloqueia-4:SCREEN-VALUE IN FRAME fpage1 = ?
             c-usuarios-4:SCREEN-VALUE IN FRAME fpage1 = ""
             c-estabelecimentos-4:SCREEN-VALUE IN FRAME fpage1 = ""
                      
             dt-bloqueia-4:SENSITIVE IN FRAME fpage1 = NO
             c-usuarios-4:SENSITIVE IN FRAME fpage1 = NO
             c-estabelecimentos-4:SENSITIVE IN FRAME fpage1 = NO.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME tb-bloqueia-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-bloqueia-6 wWindow
ON MOUSE-SELECT-CLICK OF tb-bloqueia-6 IN FRAME fpage2 /* Bloqueado */
DO:
 IF tb-bloqueia-6:SCREEN-VALUE IN FRAME fpage2= "YES" THEN
      ASSIGN dt-bloqueia-6:SENSITIVE IN FRAME fpage2 = YES
             c-usuarios-6:SENSITIVE IN FRAME fpage2 = YES
             c-estabelecimentos-6:SENSITIVE IN FRAME fpage2 = YES.
 ELSE
      ASSIGN dt-bloqueia-6:SCREEN-VALUE IN FRAME fpage2 = ?
             c-usuarios-6:SCREEN-VALUE IN FRAME fpage2 = ""
             c-estabelecimentos-6:SCREEN-VALUE IN FRAME fpage2 = ""
                      
             dt-bloqueia-6:SENSITIVE IN FRAME fpage2 = NO
             c-usuarios-6:SENSITIVE IN FRAME fpage2 = NO
             c-estabelecimentos-6:SENSITIVE IN FRAME fpage2 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

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

ASSIGN dt-bloqueia-1        :SENSITIVE IN FRAME fpage1    =  NO
       c-usuarios-1         :SENSITIVE IN FRAME fpage1    =  NO
       c-estabelecimentos-1 :SENSITIVE IN FRAME fpage1    =  NO
       tb-bloqueia-1        :SCREEN-VALUE IN FRAME fpage1 = "NO" 
       dt-bloqueia-2        :SENSITIVE IN FRAME fpage1    =  NO
       c-usuarios-2         :SENSITIVE IN FRAME fpage1    =  NO
       c-estabelecimentos-2 :SENSITIVE IN FRAME fpage1    =  NO
       tb-bloqueia-2        :SCREEN-VALUE IN FRAME fpage1 = "NO"
       dt-bloqueia-3        :SENSITIVE IN FRAME fpage1    =  NO
       c-usuarios-3         :SENSITIVE IN FRAME fpage1    =  NO
       c-estabelecimentos-3 :SENSITIVE IN FRAME fpage1    =  NO
       tb-bloqueia-3        :SCREEN-VALUE IN FRAME fpage1 = "NO"
       dt-bloqueia-4        :SENSITIVE IN FRAME fpage1    =  NO
       c-usuarios-4         :SENSITIVE IN FRAME fpage1    =  NO
       c-estabelecimentos-4 :SENSITIVE IN FRAME fpage1    =  NO
       tb-bloqueia-4        :SCREEN-VALUE IN FRAME fpage1 = "NO"
       dt-bloqueia-6        :SENSITIVE IN FRAME fpage2    =  NO
       c-usuarios-6         :SENSITIVE IN FRAME fpage2    =  NO
       c-estabelecimentos-6 :SENSITIVE IN FRAME fpage2    =  NO
       tb-bloqueia-6        :SCREEN-VALUE IN FRAME fpage2 = "NO".


FOR FIRST bloqueio-fat NO-LOCK:
    IF AVAIL bloqueio-fat THEN DO:
        
      IF bloqueio-fat.dt-bloq-espdp006 <> ? THEN DO:
          ASSIGN dt-bloqueia-1       :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.dt-bloq-espdp006)
                 dt-bloqueia-1       :SENSITIVE IN FRAME fpage1     =  YES
                 c-usuarios-1        :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.usua-espdp006)
                 c-usuarios-1        :SENSITIVE IN FRAME fpage1     =  YES
                 c-estabelecimentos-1:SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.estab-espdp006)
                 c-estabelecimentos-1:SENSITIVE IN FRAME fpage1     =  YES
                 tb-bloqueia-1       :SCREEN-VALUE IN FRAME fpage1  = "YES".
      END.
      IF bloqueio-fat.dt-bloq-ft4002 <> ? THEN DO:
          ASSIGN dt-bloqueia-2       :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.dt-bloq-ft4002)
                 dt-bloqueia-2       :SENSITIVE IN FRAME fpage1     =  YES
                 c-usuarios-2        :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.usua-ft4002)
                 c-usuarios-2        :SENSITIVE IN FRAME fpage1     =  YES
                 c-estabelecimentos-2:SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.estab-ft4002)
                 c-estabelecimentos-2:SENSITIVE IN FRAME fpage1     =  YES
                 tb-bloqueia-2       :SCREEN-VALUE IN FRAME fpage1  = "YES".
      END.
      IF bloqueio-fat.dt-bloq-ft4001-ft4100 <> ? THEN DO:
          ASSIGN dt-bloqueia-3       :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.dt-bloq-ft4001-ft4100)
                 dt-bloqueia-3       :SENSITIVE IN FRAME fpage1     =  YES
                 c-usuarios-3        :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.usua-ft4001-ft4100)
                 c-usuarios-3        :SENSITIVE IN FRAME fpage1     =  YES
                 c-estabelecimentos-3:SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.estab-ft4001-ft4100)
                 c-estabelecimentos-3:SENSITIVE IN FRAME fpage1     =  YES
                 tb-bloqueia-3       :SCREEN-VALUE IN FRAME fpage1  = "YES".
      END.
      IF bloqueio-fat.dt-bloq-ft4003 <> ? THEN DO:
          ASSIGN dt-bloqueia-4       :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.dt-bloq-ft4003)
                 dt-bloqueia-4       :SENSITIVE IN FRAME fpage1     =  YES
                 c-usuarios-4        :SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.usua-ft4003)
                 c-usuarios-4        :SENSITIVE IN FRAME fpage1     =  YES
                 c-estabelecimentos-4:SCREEN-VALUE IN FRAME fpage1  = string(bloqueio-fat.estab-ft4003)
                 c-estabelecimentos-4:SENSITIVE IN FRAME fpage1     =  YES
                 tb-bloqueia-4       :SCREEN-VALUE IN FRAME fpage1  = "YES" .
      END.
      IF bloqueio-fat.dt-bloq-re1001 <> ? THEN DO:
          ASSIGN dt-bloqueia-6       :SCREEN-VALUE IN FRAME fpage2  = string(bloqueio-fat.dt-bloq-re1001)
                 dt-bloqueia-6       :SENSITIVE IN FRAME fpage2     =  YES
                 c-usuarios-6        :SCREEN-VALUE IN FRAME fpage2  = string(bloqueio-fat.usua-re1001)
                 c-usuarios-6        :SENSITIVE IN FRAME fpage2     =  YES
                 c-estabelecimentos-6:SCREEN-VALUE IN FRAME fpage2  = string(bloqueio-fat.estab-re1001)
                 c-estabelecimentos-6:SENSITIVE IN FRAME fpage2     =  YES
                 tb-bloqueia-6       :SCREEN-VALUE IN FRAME fpage2  = "YES" .
      END.
      ASSIGN c-estabelecimentos-5:SCREEN-VALUE IN FRAME fpage1  = bloqueio-fat.estab-fatcom.

    END.
END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gravar wWindow 
PROCEDURE pi-gravar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*DT-BLOQUEIA-1*/
    IF tb-bloqueia-1:SCREEN-VALUE IN FRAME fpage1= "YES" THEN DO:
        IF  datetime(dt-bloqueia-1:SCREEN-VALUE IN FRAME fpage1) = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT 'Informe Data e Hora para Bloqueio da funá∆o Liberaá∆o para Faturamento').
            RETURN.
        END.
        
        ELSE DO:
            FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAIL bloqueio-fat THEN DO:
                    CREATE bloqueio-fat.
               END.
               ASSIGN bloqueio-fat.dt-bloq-espdp006  = DATETIME(dt-bloqueia-1:SCREEN-VALUE IN FRAME fpage1)
                      bloqueio-fat.usua-espdp006     = c-usuarios-1:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.estab-espdp006    = c-estabelecimentos-1:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.bloq-espdp006     = YES.
        END.
    END.
    ELSE DO:
      FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bloqueio-fat THEN DO:
            ASSIGN bloqueio-fat.dt-bloq-espdp006  = ?
                   bloqueio-fat.usua-espdp006     = ""
                   bloqueio-fat.estab-espdp006    = ""
                   bloqueio-fat.bloq-espdp006     = NO.
        END.
    END.
        
    /*DT-BLOQUEIA-2*/
    IF tb-bloqueia-2:SCREEN-VALUE IN FRAME fpage1= "YES" THEN DO:
        IF datetime(dt-bloqueia-2:SCREEN-VALUE IN FRAME fpage1) = ? THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17006, 
                              INPUT 'Informe Data e Hora para Bloqueio do programa "FT4002"').
           RETURN.
        END.
        ELSE DO:
            FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAIL bloqueio-fat THEN DO:
                  CREATE bloqueio-fat.
               END.
               ASSIGN bloqueio-fat.dt-bloq-ft4002  = DATETIME(dt-bloqueia-2:SCREEN-VALUE IN FRAME fpage1)
                      bloqueio-fat.usua-ft4002     = c-usuarios-2:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.estab-ft4002    = c-estabelecimentos-2:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.bloq-ft4002     = YES. 
        END.
    END.
    ELSE DO:
      FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bloqueio-fat THEN DO:
            ASSIGN bloqueio-fat.dt-bloq-ft4002  = ?
                   bloqueio-fat.usua-ft4002     = ""
                   bloqueio-fat.estab-ft4002    = ""
                   bloqueio-fat.bloq-ft4002     = NO.
        END.
    END.
    
    /*DT-BLOQUEIA-3*/
    IF tb-bloqueia-3:SCREEN-VALUE IN FRAME fpage1= "YES" THEN DO:
       IF datetime(dt-bloqueia-3:SCREEN-VALUE IN FRAME fpage1) = ? THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U, 
                             INPUT 17006, 
                             INPUT 'Informe Data e Hora para Bloqueio dos programas "FT4001 e FT4100"').
          RETURN.
       END.
       
       ELSE DO:
           FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAIL bloqueio-fat THEN DO:
                 CREATE bloqueio-fat.
              END.
              ASSIGN bloqueio-fat.dt-bloq-ft4001-ft4100  = DATETIME(dt-bloqueia-3:SCREEN-VALUE IN FRAME fpage1)
                     bloqueio-fat.usua-ft4001-ft4100     = c-usuarios-3:SCREEN-VALUE IN FRAME fpage1
                     bloqueio-fat.estab-ft4001-ft4100    = c-estabelecimentos-3:SCREEN-VALUE IN FRAME fpage1
                     bloqueio-fat.bloq-ft4001-ft4100     = YES.
       END.
    END.
    ELSE DO:
      FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bloqueio-fat THEN DO:
            ASSIGN bloqueio-fat.dt-bloq-ft4001-ft4100  = ?
                   bloqueio-fat.usua-ft4001-ft4100     = ""
                   bloqueio-fat.estab-ft4001-ft4100    = ""
                   bloqueio-fat.bloq-ft4001-ft4100     = NO.
        END.
    END.
    
    /*DT-BLOQUEIA-4*/
    IF tb-bloqueia-4:SCREEN-VALUE IN FRAME fpage1= "YES" THEN DO:
       IF datetime(dt-bloqueia-4:SCREEN-VALUE IN FRAME fpage1) = ? THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U, 
                             INPUT 17006, 
                             INPUT 'Informe Data e Hora para Bloqueio do programa "FT4003"').
          RETURN.
       END.
       ELSE DO:
            FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAIL bloqueio-fat THEN DO:
                  CREATE bloqueio-fat.
               END.
               ASSIGN bloqueio-fat.dt-bloq-ft4003  = DATETIME(dt-bloqueia-4:SCREEN-VALUE IN FRAME fpage1)
                      bloqueio-fat.usua-ft4003     = c-usuarios-4:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.estab-ft4003    = c-estabelecimentos-4:SCREEN-VALUE IN FRAME fpage1
                      bloqueio-fat.bloq-ft4003     = YES.
       END.
    END.
    ELSE DO:
      FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bloqueio-fat THEN DO:
            ASSIGN bloqueio-fat.dt-bloq-ft4003  = ?
                   bloqueio-fat.usua-ft4003     = ""
                   bloqueio-fat.estab-ft4003    = ""
                   bloqueio-fat.bloq-ft4003     = NO.
        END.
    END.

    /*DT-BLOQUEIA-6*/
    IF tb-bloqueia-6:SCREEN-VALUE IN FRAME fpage2= "YES" THEN DO:
       IF datetime(dt-bloqueia-6:SCREEN-VALUE IN FRAME fpage2) = ? THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U, 
                             INPUT 17006, 
                             INPUT 'Informe Data e Hora para Bloqueio do programa "RE1001 e RE1005"').
          RETURN.
       END.
       ELSE DO:
            FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAIL bloqueio-fat THEN DO:
                  CREATE bloqueio-fat.
               END.
               ASSIGN bloqueio-fat.dt-bloq-re1001  = DATETIME(dt-bloqueia-6:SCREEN-VALUE IN FRAME fpage2)
                      bloqueio-fat.usua-re1001     = c-usuarios-6:SCREEN-VALUE IN FRAME fpage2
                      bloqueio-fat.estab-re1001    = c-estabelecimentos-6:SCREEN-VALUE IN FRAME fpage2
                      bloqueio-fat.bloq-re1001     = YES.
       END.
    END.
    ELSE DO:
      FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bloqueio-fat THEN DO:
            ASSIGN bloqueio-fat.dt-bloq-re1001  = ?
                   bloqueio-fat.usua-re1001     = ""
                   bloqueio-fat.estab-re1001    = ""
                   bloqueio-fat.bloq-re1001     = NO.
        END.
    END.

    FIND FIRST bloqueio-fat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bloqueio-fat THEN DO:
        ASSIGN bloqueio-fat.estab-fatcom = c-estabelecimentos-5:SCREEN-VALUE IN FRAME fpage1.
    END.

    MESSAGE "Informaá‰es salvas com sucesso"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

