&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-item NO-UNDO LIKE ae-item
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep023 2.00.04.000}

DEFINE NEW GLOBAL SHARED VARIABLE gr-ficha-cq AS ROWID NO-UNDO.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep023
&GLOBAL-DEFINE Version        2.00.04.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttae-item
&GLOBAL-DEFINE hDBOTable      hboae-item
&GLOBAL-DEFINE DBOTable       ae-item

&GLOBAL-DEFINE page0KeyFields ttae-item.nr-ae ttae-item.sequencia ttae-item.situacao  ttae-item.cod-depos ttae-item.roteiro ttae-item.data-fabricacao ttae-item.impresso ttae-item.it-codigo ttae-item.localizacao ttae-item.nf ttae-item.quantidade
&GLOBAL-DEFINE page0Fields    ttae-item.data-validade ttae-item.data tSequencia

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{upc\btb910za-upc.i}
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttae-item.nr-ae ttae-item.sequencia ~
ttae-item.cod-depos ttae-item.it-codigo ttae-item.localizacao ~
ttae-item.situacao ttae-item.quantidade ttae-item.nf ~
ttae-item.data-fabricacao ttae-item.roteiro ttae-item.impresso ~
ttae-item.data ttae-item.data-validade 
&Scoped-define ENABLED-TABLES ttae-item
&Scoped-define FIRST-ENABLED-TABLE ttae-item
&Scoped-Define ENABLED-OBJECTS RECT-35 rtKeys rtToolBar btGoTo btSearch ~
btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins btReportsJoins ~
btExit btHelp cDescDeposito tSequencia 
&Scoped-Define DISPLAYED-FIELDS ttae-item.nr-ae ttae-item.sequencia ~
ttae-item.cod-depos ttae-item.it-codigo ttae-item.localizacao ~
ttae-item.situacao ttae-item.quantidade ttae-item.nf ~
ttae-item.data-fabricacao ttae-item.roteiro ttae-item.impresso ~
ttae-item.data ttae-item.data-validade 
&Scoped-define DISPLAYED-TABLES ttae-item
&Scoped-define FIRST-DISPLAYED-TABLE ttae-item
&Scoped-Define DISPLAYED-OBJECTS cDescDeposito tSequencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "dd" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4.43 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U NO-FOCUS
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cDescDeposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tSequencia AS LOGICAL INITIAL yes 
     LABEL "Todas as sequˆncias" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 TOOLTIP "Alterar datas para todas as sequˆncias desta AE" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btNext AT ROW 1 COL 10 HELP
          "Pr¢xima ocorrˆncia"
     btFirst AT ROW 1 COL 2 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1 COL 6 HELP
          "Ocorrˆncia anterior"
     btLast AT ROW 1 COL 14 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttae-item.nr-ae AT ROW 2.75 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttae-item.sequencia AT ROW 3.75 COL 38 COLON-ALIGNED
          LABEL "Sequˆncia"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttae-item.cod-depos AT ROW 5.25 COL 17 COLON-ALIGNED
          LABEL "Dep¢sito"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     cDescDeposito AT ROW 5.25 COL 22 COLON-ALIGNED NO-LABEL
     ttae-item.it-codigo AT ROW 6.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttae-item.localizacao AT ROW 6.25 COL 43 COLON-ALIGNED
          LABEL "Localiza‡Æo"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     ttae-item.situacao AT ROW 6.25 COL 69 COLON-ALIGNED
          LABEL "Situa‡Æo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttae-item.quantidade AT ROW 7.25 COL 24 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttae-item.nf AT ROW 7.25 COL 51 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttae-item.data-fabricacao AT ROW 7.25 COL 69 COLON-ALIGNED
          LABEL "Fabrica‡Æo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttae-item.roteiro AT ROW 8.25 COL 26 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttae-item.impresso AT ROW 8.25 COL 43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttae-item.data AT ROW 9.25 COL 17 COLON-ALIGNED
          LABEL "Data entrada"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttae-item.data-validade AT ROW 9.25 COL 43 COLON-ALIGNED
          LABEL "Data validade"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tSequencia AT ROW 9.25 COL 64
     RECT-35 AT ROW 5 COL 1
     rtKeys AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-item T "?" NO-UNDO mgesp ae-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = "Atualiza‡Æo de Validade do AE"
         HEIGHT             = 9.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btAdd IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btFirst IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btLast IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btNext IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btPrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttae-item.cod-depos IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.data IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.data-fabricacao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.data-validade IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.localizacao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.nf IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN ttae-item.quantidade IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN ttae-item.roteiro IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN ttae-item.sequencia IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttae-item.situacao IN FRAME fpage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Atualiza‡Æo de Validade do AE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Atualiza‡Æo de Validade do AE */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.






END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON GO OF FRAME fpage0
DO:
    btAdd:SENSITIVE = FALSE.  
    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.

    RUN goToRecord IN THIS-PROCEDURE.




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* dd */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    /*RUN addRecord IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
/*    FIND FIRST ae-item WHERE 
               ae-item.nr-ae = ttae-item.nr-ae AND
               ae-item.sequencia = ttae-item.sequencia.

    IF AVAIL ae-item THEN DO:
        DELETE ae-item.         

    END.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.

    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.





    IF tSequencia:SCREEN-VALUE = "YES" THEN DO:
        INPUT FRAME fpage0 ttae-item.nr-ae:SCREEN-VALUE.
        INPUT FRAME fpage0 ttae-item.data:SCREEN-VALUE.
        INPUT FRAME fpage0 ttae-item.data-validade:SCREEN-VALUE.
        RUN Atualiza-Data IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                           INPUT ttae-item.nr-ae:SCREEN-VALUE         IN FRAME fpage0,
                                           INPUT ttae-item.data:SCREEN-VALUE          IN FRAME fpage0,
                                           INPUT ttae-item.data-validade:SCREEN-VALUE IN FRAME fpage0).
    END.
    ELSE DO:
        FIND FIRST ae-item                                                   WHERE 
                   ae-item.cod-estabel = v_cod_estab_usuar and
                   ae-item.nr-ae     = int(ttae-item.nr-ae:SCREEN-VALUE)     AND
                   ae-item.sequencia = int(ttae-item.sequencia:SCREEN-VALUE) NO-ERROR. 
        ASSIGN ae-item.data          = date(ttae-item.data:SCREEN-VALUE)
               ae-item.data-validade = date(ttae-item.data-validade:SCREEN-VALUE).
        MESSAGE "Atualiza‡Æo de validade efetuada com sucesso" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    
    btgoto:SENSITIVE = TRUE.
    btsearch:SENSITIVE = TRUE.
    btadd:SENSITIVE = TRUE.
    btcopy:SENSITIVE = TRUE.
    btupdate:SENSITIVE = TRUE.
    btdelete:SENSITIVE = TRUE.
    
    ttae-item.data:SENSITIVE = FALSE.
    ttae-item.data-validade:SENSITIVE = FALSE.

    IF v_cod_estab_usuar = "101" THEN DO:
        FIND FIRST ficha-cq NO-LOCK
             WHERE ficha-cq.nr-ficha = int(ttae-item.roteiro:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.
        IF AVAIL ficha-cq THEN DO:
            ASSIGN gr-ficha-cq = ROWID(ficha-cq).
            RUN esp/cqp/escqp002.w.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:


    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.


    {method/ZoomReposition.i &ProgramZoom="eszoom\z01es010.w"}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttae-item.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttae-item.cod-depos wMaintenance
ON LEAVE OF ttae-item.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:  
    FIND deposito NO-LOCK WHERE 
         deposito.cod-depos = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN cDescDeposito = IF AVAILABLE deposito THEN deposito.nome ELSE ''.
    DISPLAY cDescDeposito WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.


    btgoto:SENSITIVE = TRUE.
    btsearch:SENSITIVE = TRUE.
    btadd:SENSITIVE = TRUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY 'leave':U TO {&ttTable}.cod-depos IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
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
    
    DEFINE VARIABLE cnr-ae     LIKE {&ttTable}.nr-ae     NO-UNDO.
    /* DEFINE VARIABLE csequencia LIKE {&ttTable}.sequencia NO-UNDO.    */


    DEFINE FRAME fGoToRecord
        cnr-ae            AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10  BY .88
        /* csequencia        AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5  BY .88       */
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.


    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cnr-ae.
               /* csequencia. */


        RUN goToKey IN {&hDBOTable} (INPUT v_cod_estab_usuar, INPUT cnr-ae). /*  , INPUT csequencia). */


        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "ae-item":U).            
            RETURN NO-APPLY.
        END.
        

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        


        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).



        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    


    ENABLE cnr-ae
           /* csequencia */
           btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 
    


    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes010.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes010.p YES}
        {btb/btb008za.i2 esbo\boes010.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintPendentes IN {&hDBOTable} (INPUT v_cod_estab_usuar) NO-ERROR.
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "Pendentes":U) NO-ERROR.
    
    RETURN "OK":U.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

