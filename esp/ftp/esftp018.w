&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{include/i-prgvrs.i ESFTP018 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP018
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Atualiza

&GLOBAL-DEFINE page0Widgets   browse-1 tgSeparaEmbarque fi-cod-estabel-ini fi-cod-estabel-fim  ~
                              fi-serie-ini fi-serie-fim fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim ~
                              btQueryJoins btReportsJoins btExit btHelp btOK btSave
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-int-nota-fiscal LIKE int-nota-fiscal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-nota-fiscal

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-int-nota-fiscal.cod-estabel tt-int-nota-fiscal.serie tt-int-nota-fiscal.nr-nota-fis tt-int-nota-fiscal.log-lib-despacho   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH tt-int-nota-fiscal NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-int-nota-fiscal NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-int-nota-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-int-nota-fiscal


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
fi-cod-estabel-ini fi-cod-estabel-fim fi-serie-ini fi-serie-fim ~
fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim btSave BROWSE-1 tgSeparaEmbarque ~
btOK IMAGE-1 IMAGE-11 IMAGE-12 IMAGE-15 IMAGE-16 IMAGE-2 RECT-15 rtToolBar ~
rtToolBar-2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-serie-ini fi-serie-fim fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim ~
tgSeparaEmbarque 

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

DEFINE BUTTON btOK 
     LABEL "Atualizar" 
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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1
     FONT 4.

DEFINE VARIABLE fi-cod-estabel-fim AS CHARACTER FORMAT "x(03)" INITIAL "101" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini AS CHARACTER FORMAT "x(03)" INITIAL "101" 
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fisc-fim AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fisc-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-fim AS CHARACTER FORMAT "x(03)" INITIAL "3" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-ini AS CHARACTER FORMAT "x(03)" INITIAL "3" 
     LABEL "S‚rie":R15 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 12.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tgSeparaEmbarque AS LOGICAL INITIAL yes 
     LABEL "Separa Notas Fiscais Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-int-nota-fiscal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wWindow _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      tt-int-nota-fiscal.cod-estabel FORMAT "X(3)":U
      tt-int-nota-fiscal.serie FORMAT "X(2)":U
      tt-int-nota-fiscal.nr-nota-fis FORMAT "X(12)":U
      tt-int-nota-fiscal.log-lib-despacho FORMAT "Sim/Nao":U COLUMN-LABEL "Separada"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84.14 BY 7.25
         FONT 1 EXPANDABLE.


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
     fi-cod-estabel-ini AT ROW 3 COL 22 COLON-ALIGNED HELP
          "C¢digo Estabelecimento"
     fi-cod-estabel-fim AT ROW 3 COL 48 COLON-ALIGNED HELP
          "C¢digo Estabelecimento" NO-LABEL
     fi-serie-ini AT ROW 4 COL 22 COLON-ALIGNED HELP
          "S‚rie Inicial"
     fi-serie-fim AT ROW 4 COL 48 COLON-ALIGNED HELP
          "S‚rie Inicial" NO-LABEL
     fi-nr-nota-fisc-ini AT ROW 5 COL 22 COLON-ALIGNED HELP
          "N£mero da nota fiscal"
     fi-nr-nota-fisc-fim AT ROW 5 COL 48 COLON-ALIGNED HELP
          "N£mero da nota fiscal" NO-LABEL
     btSave AT ROW 5 COL 65 HELP
          "Confirma altera‡äes"
     BROWSE-1 AT ROW 6.25 COL 3
     tgSeparaEmbarque AT ROW 13.75 COL 24
     btOK AT ROW 15.21 COL 2
     IMAGE-1 AT ROW 3 COL 40.29
     IMAGE-11 AT ROW 4 COL 40
     IMAGE-12 AT ROW 5 COL 40
     IMAGE-15 AT ROW 4 COL 47
     IMAGE-16 AT ROW 5 COL 47
     IMAGE-2 AT ROW 3 COL 47
     RECT-15 AT ROW 2.63 COL 1
     rtToolBar AT ROW 15 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.88
         FONT 1.


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
         HEIGHT             = 15.88
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

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 btSave fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-nota-fiscal NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Atualizar */
DO:
    FOR EACH tt-int-nota-fiscal:
        FOR FIRST int-nota-fiscal EXCLUSIVE-LOCK
            WHERE int-nota-fiscal.cod-estabel = tt-int-nota-fiscal.cod-estabel
            AND   int-nota-fiscal.serie       = tt-int-nota-fiscal.serie      
            AND   int-nota-fiscal.nr-nota-fis = tt-int-nota-fiscal.nr-nota-fis:
            ASSIGN int-nota-fiscal.log-lib-despacho = INPUT FRAME fpage0 tgSeparaEmbarque.
        END.
    END.

    APPLY "CHOOSE":U TO BtSave.
    IF CAN-FIND(FIRST tt-int-nota-fiscal) THEN
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 27979, 
                           INPUT "Notas Fiscais atualizadas com sucesso").
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
DO:
    SESSION:SET-WAIT-STATE("general":U).

    FOR EACH tt-int-nota-fiscal.
        DELETE tt-int-nota-fiscal.
    END.
    RUN piBuscaRegistros.
    {&OPEN-QUERY-browse-1}
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaTempTable wWindow 
PROCEDURE piAtualizaTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL int-nota-fiscal THEN
    DO:
        CREATE tt-int-nota-fiscal.
        BUFFER-COPY int-nota-fiscal TO tt-int-nota-fiscal.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaRegistros wWindow 
PROCEDURE piBuscaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:
        ASSIGN fi-cod-estabel-ini  = INPUT fi-cod-estabel-ini  
               fi-cod-estabel-fim  = INPUT fi-cod-estabel-fim  
               fi-serie-ini        = INPUT fi-serie-ini        
               fi-serie-fim        = INPUT fi-serie-fim        
               fi-nr-nota-fisc-ini = INPUT fi-nr-nota-fisc-ini 
               fi-nr-nota-fisc-fim = INPUT fi-nr-nota-fisc-fim.
    END.

    IF fi-cod-estabel-ini  = fi-cod-estabel-fim  AND 
       fi-serie-ini        = fi-serie-fim        AND 
       fi-nr-nota-fisc-ini = fi-nr-nota-fisc-fim THEN DO:
       FOR EACH  int-nota-fiscal NO-LOCK
           WHERE int-nota-fiscal.cod-estabel = fi-cod-estabel-ini 
           AND   int-nota-fiscal.serie       = fi-serie-ini       
           AND   int-nota-fiscal.nr-nota-fis = fi-nr-nota-fisc-ini:
           RUN piAtualizaTempTable.
        END.
    END.
    ELSE IF fi-cod-estabel-ini  = fi-cod-estabel-fim  AND 
            fi-serie-ini        = fi-serie-fim        THEN
    DO:
        FOR EACH  int-nota-fiscal NO-LOCK
            WHERE int-nota-fiscal.cod-estabel   = fi-cod-estabel-ini 
            AND   int-nota-fiscal.serie         = fi-serie-ini
            AND   int-nota-fiscal.nr-nota-fis >= fi-nr-nota-fisc-ini
            AND   int-nota-fiscal.nr-nota-fis <= fi-nr-nota-fisc-fim:
            RUN piAtualizaTempTable.
        END.
    END.
    ELSE DO:
        FOR EACH  int-nota-fiscal NO-LOCK
            WHERE int-nota-fiscal.cod-estabel  >= fi-cod-estabel-ini 
            AND   int-nota-fiscal.cod-estabel  <= fi-cod-estabel-fim 
            AND   int-nota-fiscal.serie        >= fi-serie-ini       
            AND   int-nota-fiscal.serie        <= fi-serie-fim       
            AND   int-nota-fiscal.nr-nota-fis >= fi-nr-nota-fisc-ini
            AND   int-nota-fiscal.nr-nota-fis <= fi-nr-nota-fisc-fim:
            RUN piAtualizaTempTable.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

