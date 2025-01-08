&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{include/i-prgvrs.i espdp065 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp065
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btReportsJoins btExit btHelp ~
                              btFechar btHelp2 br-alternativo btIncluir btExcluir btPesquisar
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE BUFFER b-prod-substituto FOR prod-substituto.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.
DEF BUFFER b-item FOR item.
DEF BUFFER b2-item FOR ITEM.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-alternativo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES prod-substituto item b-item b2-item

/* Definitions for BROWSE br-alternativo                                */
&Scoped-define FIELDS-IN-QUERY-br-alternativo prod-substituto.it-prod-final b2-item.desc-item prod-substituto.it-codigo-pai item.desc-item prod-substituto.it-codigo-filho b-item.desc-item prod-substituto.data prod-substituto.cod-usuario prod-substituto.motivo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-alternativo   
&Scoped-define SELF-NAME br-alternativo
&Scoped-define QUERY-STRING-br-alternativo FOR EACH prod-substituto NO-LOCK, ~
             FIRST item NO-LOCK             WHERE item.it-codigo = prod-substituto.it-codigo-pai, ~
             FIRST b-item NO-LOCK             WHERE b-item.it-codigo = prod-substituto.it-codigo-filho, ~
             FIRST b2-item NO-LOCK             WHERE b2-item.it-codigo = prod-substituto.it-prod-final INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-alternativo OPEN QUERY {&SELF-NAME} FOR EACH prod-substituto NO-LOCK, ~
             FIRST item NO-LOCK             WHERE item.it-codigo = prod-substituto.it-codigo-pai, ~
             FIRST b-item NO-LOCK             WHERE b-item.it-codigo = prod-substituto.it-codigo-filho, ~
             FIRST b2-item NO-LOCK             WHERE b2-item.it-codigo = prod-substituto.it-prod-final INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-alternativo prod-substituto item b-item ~
b2-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-alternativo prod-substituto
&Scoped-define SECOND-TABLE-IN-QUERY-br-alternativo item
&Scoped-define THIRD-TABLE-IN-QUERY-br-alternativo b-item
&Scoped-define FOURTH-TABLE-IN-QUERY-br-alternativo b2-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-alternativo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-2 btReportsJoins ~
btExit btHelp br-alternativo btIncluir btExcluir btPesquisar btFechar ~
btHelp2 

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
DEFINE BUTTON btExcluir 
     LABEL "&Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btPesquisar 
     LABEL "Pesquisar" 
     SIZE 10 BY 1.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 15.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 143 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-alternativo FOR 
      prod-substituto, 
      item, 
      b-item, 
      b2-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-alternativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-alternativo wWindow _FREEFORM
  QUERY br-alternativo DISPLAY
      prod-substituto.it-prod-final FORMAT "x(16)":U
      b2-item.desc-item FORMAT "x(15)":U WIDTH 25.86
      prod-substituto.it-codigo-pai FORMAT "x(16)":U
      item.desc-item FORMAT "x(15)":U WIDTH 25.86
      prod-substituto.it-codigo-filho FORMAT "x(16)":U WIDTH 16.72
      b-item.desc-item FORMAT "x(15)":U WIDTH 23
      prod-substituto.data FORMAT "99/99/9999" COLUMN-LABEL "Dt. Inclus∆o"
      prod-substituto.cod-usuario FORMAT "x(12)" COLUMN-LABEL "Usu†rio" 
      prod-substituto.motivo FORMAT "X(200)" COLUMN-LABEL "Motivo" WIDTH 80
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 139.86 BY 13
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btReportsJoins AT ROW 1.17 COL 130.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 134.57 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 138.57 HELP
          "Ajuda"
     br-alternativo AT ROW 3.25 COL 2.72 WIDGET-ID 200
     btIncluir AT ROW 16.67 COL 3.29 WIDGET-ID 14
     btExcluir AT ROW 16.67 COL 13.29 WIDGET-ID 18
     btPesquisar AT ROW 16.67 COL 23.29 WIDGET-ID 20
     btFechar AT ROW 18.71 COL 2
     btHelp2 AT ROW 18.71 COL 132
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 18.5 COL 1
     RECT-2 AT ROW 3 COL 1.43 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.29 BY 18.92
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
         COLUMN             = 21.14
         ROW                = 5.79
         HEIGHT             = 18.92
         WIDTH              = 143.29
         MAX-HEIGHT         = 18.92
         MAX-WIDTH          = 143.29
         VIRTUAL-HEIGHT     = 18.92
         VIRTUAL-WIDTH      = 143.29
         MAX-BUTTON         = no
         RESIZE             = no
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
   FRAME-NAME                                                           */
/* BROWSE-TAB br-alternativo btHelp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-alternativo
/* Query rebuild information for BROWSE br-alternativo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH prod-substituto NO-LOCK,
      FIRST item NO-LOCK
            WHERE item.it-codigo = prod-substituto.it-codigo-pai,
      FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = prod-substituto.it-codigo-filho,
      FIRST b2-item NO-LOCK
            WHERE b2-item.it-codigo = prod-substituto.it-prod-final INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-alternativo */
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


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wWindow
ON CHOOSE OF btExcluir IN FRAME fpage0 /* Excluir */
DO:

        IF AVAIL prod-substituto THEN DO:
            MESSAGE "Deseja excluir registro? "
                VIEW-AS ALERT-BOX INFO BUTTONS YES-NO TITLE "Exclus∆o?" UPDATE l-excluir AS LOGICAL.

            IF l-excluir THEN DO:
                FIND FIRST b-prod-substituto OF prod-substituto EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL b-prod-substituto THEN
                    DELETE b-prod-substituto.

                {&open-query-br-alternativo}
                
            END.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
DO:
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


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
 
        ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
        RUN esp/pdp/espdp065a.w .
        ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
       {&open-query-br-alternativo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar wWindow
ON CHOOSE OF btPesquisar IN FRAME fpage0 /* Pesquisar */
DO:
  RUN GotoItem IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-alternativo
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

    
{&open-query-br-alternativo}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GotoItem wWindow 
PROCEDURE GotoItem :
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

    DEF VAR c-item LIKE ITEM.it-codigo VIEW-AS FILL-IN SIZE 19 BY .88.
    DEF VAR c-it-prod-final LIKE ITEM.it-codigo VIEW-AS FILL-IN SIZE 19 BY .88.
    DEFINE FRAME fGoToRecord
        c-it-prod-final LABEL "Produto Final " AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-item LABEL "Item Pai " AT ROW 2.21 COL 17.72 COLON-ALIGNED

        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "V† Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.



    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-prod-final c-item .
        IF c-it-prod-final <> "" THEN
            OPEN QUERY br-alternativo FOR EACH prod-substituto NO-LOCK
                   WHERE prod-substituto.it-prod-final >= c-it-prod-final,
                   FIRST item NO-LOCK
                         WHERE item.it-codigo = prod-substituto.it-codigo-pai,
                   FIRST b-item NO-LOCK
                         WHERE b-item.it-codigo = prod-substituto.it-codigo-filho ,
                   FIRST b2-item NO-LOCK
                         WHERE b2-item.it-codigo = prod-substituto.it-prod-final INDEXED-REPOSITION.
        ELSE
         OPEN QUERY br-alternativo FOR EACH prod-substituto NO-LOCK
                WHERE prod-substituto.it-codigo-pai >= c-item,
                FIRST item NO-LOCK
                      WHERE item.it-codigo = prod-substituto.it-codigo-pai,
                FIRST b-item NO-LOCK
                      WHERE b-item.it-codigo = prod-substituto.it-codigo-filho ,
                FIRST b2-item NO-LOCK
                      WHERE b2-item.it-codigo = prod-substituto.it-prod-final INDEXED-REPOSITION.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.



    ENABLE c-it-prod-final c-item btGoToOK btGoToCancel
        WITH FRAME fGoToRecord.


    WAIT-FOR "GO":U OF FRAME fGoToRecord.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

