&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttped-item NO-UNDO LIKE ped-item
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
{include/i-prgvrs.i espdp054 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp054
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttped-item
&GLOBAL-DEFINE hDBOTable      h-bodi154
&GLOBAL-DEFINE DBOTable       ped-item

&GLOBAL-DEFINE page0KeyFields ttped-item.nr-pedcli ttped-item.nome-abrev ttped-item.nr-sequencia ttped-item.it-codigo
&GLOBAL-DEFINE page0Fields    c-novo-item
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
DEFINE TEMP-TABLE tt-ped-item no-undo like ped-item
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-ent no-undo like ped-ent
    field r-rowid  as rowid.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE      NO-UNDO.
def var h-bodi154-bo          as HANDLE      NO-UNDO.
DEFINE VARIABLE l-erro        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cod-motivo  AS integer     NO-UNDO.
DEFINE VARIABLE c-desc-motivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE da-data       AS DATE        NO-UNDO.      
DEFINE VARIABLE l-resultado   AS LOGICAL     NO-UNDO. 
DEFINE VARIABLE bo-ped-item-can AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE c-nr-tabpre  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE bo-ped-venda-com AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-icms AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE BUFFER b-int-ped-item FOR int-ped-item.
DEF BUFFER b-int-ped-item-astec FOR int-ped-item-astec.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-item.nr-pedcli ttped-item.nome-abrev ~
ttped-item.nr-sequencia ttped-item.it-codigo 
&Scoped-define ENABLED-TABLES ttped-item
&Scoped-define FIRST-ENABLED-TABLE ttped-item
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-1 RECT-2 btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btCompleteOrder btQueryJoins btReportsJoins btExit btHelp ~
c-descricao-cliente c-descricao-item c-novo-item c-descricao-item-novo 
&Scoped-Define DISPLAYED-FIELDS ttped-item.nr-pedcli ttped-item.nome-abrev ~
ttped-item.nr-sequencia ttped-item.it-codigo 
&Scoped-define DISPLAYED-TABLES ttped-item
&Scoped-define FIRST-DISPLAYED-TABLE ttped-item
&Scoped-Define DISPLAYED-OBJECTS c-descricao-cliente c-descricao-item ~
c-novo-item c-descricao-item-novo 

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
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCompleteOrder 
     IMAGE-UP FILE "image/im-cq":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Efetivar Pedido".

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
     SIZE 4 BY 1.25.

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
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
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

DEFINE VARIABLE c-descricao-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .79 NO-UNDO.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .79 NO-UNDO.

DEFINE VARIABLE c-descricao-item-novo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .79 NO-UNDO.

DEFINE VARIABLE c-novo-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Novo Item" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 5.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 5.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
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
     btCompleteOrder AT ROW 1.13 COL 62.14
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttped-item.nr-pedcli AT ROW 3.75 COL 33 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     ttped-item.nome-abrev AT ROW 4.75 COL 33 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     c-descricao-cliente AT ROW 4.75 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     ttped-item.nr-sequencia AT ROW 5.75 COL 33 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttped-item.it-codigo AT ROW 6.75 COL 33 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     c-descricao-item AT ROW 6.75 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     c-novo-item AT ROW 11 COL 33 COLON-ALIGNED WIDGET-ID 2
     c-descricao-item-novo AT ROW 11 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-1 AT ROW 3 COL 3 WIDGET-ID 12
     RECT-2 AT ROW 8.5 COL 3 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.21
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttped-item T "?" NO-UNDO mgmov ped-item
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
         TITLE              = ""
         HEIGHT             = 14.54
         WIDTH              = 90
         MAX-HEIGHT         = 22.71
         MAX-WIDTH          = 140.86
         VIRTUAL-HEIGHT     = 22.71
         VIRTUAL-WIDTH      = 140.86
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
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btCompleteOrder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCompleteOrder wMaintenance
ON CHOOSE OF btCompleteOrder IN FRAME fpage0
DO:
    FIND FIRST ped-venda
         WHERE ped-venda.nr-pedcli  = ttped-item.nr-pedcli
           AND ped-venda.nome-abrev = ttped-item.nome-abrev NO-LOCK NO-ERROR.

    IF AVAIL ped-venda THEN DO:
        IF NOT VALID-HANDLE(bo-ped-venda-com)                   OR
            bo-ped-venda-com:TYPE      <> "PROCEDURE":U         OR
            bo-ped-venda-com:FILE-NAME <> "dibo/bodi159com.p":U THEN
            RUN dibo/bodi159com.p PERSISTENT SET bo-ped-venda-com.

        RUN setUserLog    IN bo-ped-venda-com (INPUT c-seg-usuario).

        RUN completeOrder IN bo-ped-venda-com (INPUT ROWID(ped-venda),
                                               OUTPUT TABLE Rowerrors).

        IF  CAN-FIND(FIRST RowErrors
                     WHERE Rowerrors.ErrorType <> "INTERNAL":U) THEN DO:
            RUN pi-ShowMessage.
        END.
    END.
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
    inicial:
    DO TRANS:
        IF ttped-item.qt-log-aloc <> 0 OR
           ttped-item.qt-alocada <> 0 OR
           ttped-item.cod-sit-item <> 1 THEN DO:
            MESSAGE "Item do Pedido com situa‡Æo invalida para executar esta fun‡Æo"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
        END.
        
        RUN pdp/pd4000a.w (INPUT  "Cancelamento",
                           OUTPUT i-cod-motivo,
                           OUTPUT c-desc-motivo,
                           OUTPUT da-data,
                           OUTPUT l-resultado).

        
        IF  l-resultado THEN DO:

            EMPTY TEMP-TABLE tt-ped-item.

            FIND LAST ped-item
                WHERE ped-item.nr-pedcli  = ttped-item.nr-pedcli
                  AND ped-item.nome-abrev = ttped-item.nome-abrev NO-LOCK NO-ERROR.

            FIND ITEM
                WHERE ITEM.it-codigo = c-novo-item:SCREEN-VALUE
                NO-LOCK NO-ERROR.

            CREATE tt-ped-item.
            BUFFER-COPY ttped-item TO tt-ped-item.
            ASSIGN tt-ped-item.nr-sequencia = ped-item.nr-sequencia + 10
                   tt-ped-item.it-codigo    = c-novo-item:SCREEN-VALUE
                   tt-ped-item.observacao   = "Espdp054 - Substituicao do Item: " + ttped-item.it-codigo + "," + STRING(ttped-item.qt-pedida - ttped-item.qt-atendida)
                   tt-ped-item.qt-pedida    = ttped-item.qt-pedida - ttped-item.qt-atendida
                   OVERLAY(tt-ped-item.char-2,01,08) = ITEM.class-fiscal
                   tt-ped-item.qt-alocada   = 0
                   tt-ped-item.qt-atendida  = 0
                   tt-ped-item.qt-devolvida = 0
                   tt-ped-item.qt-fatenf    = 0
                   tt-ped-item.qt-log-aloca = 0
                   tt-ped-item.qt-pendente  = 0
                   tt-ped-item.aliquota-ipi = IF AVAIL ITEM THEN item.aliquota-ipi ELSE 0    .
            FIND ped-venda
                WHERE ped-venda.nome-abrev = ttped-item.nome-abrev 
                  AND ped-venda.nr-pedcli  =  ttped-item.nr-pedcli   
                NO-LOCK NO-ERROR.
            FOR FIRST mgesp.ponto-programa
                WHERE ponto-programa.nome-programa = "escrm034",
                FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                AND conteudo-programa.sequencia      = int(ped-venda.cod-estabel):
               
                ASSIGN c-nr-tabpre              =  ENTRY(6,conteudo-programa.conteudo).
            END.


            FIND estabelec
                WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

            FIND natur-oper
                WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK NO-ERROR.
            FIND FIRST preco-item NO-LOCK
               WHERE preco-item.it-codigo  = c-novo-item:SCREEN-VALUE 
               AND   preco-item.cod-refer  = ""
               AND   preco-item.nr-tabpre  = c-nr-tabpre
               AND   preco-item.dt-inival <= TODAY
               AND   preco-item.situacao   = 1 NO-ERROR.
          
            IF NOT AVAIL preco-item THEN DO:
                CREATE rowerrors.
                ASSIGN rowerrors.errornumber = 7025
                       rowerrors.errordescription = "O item  nÆo possui pre‡o ativo cadastrado na tabela " + c-nr-tabpre .
                RUN pi-ShowMessage.
                UNDO, LEAVE.
            END.
            FIND FIRST unid-feder NO-LOCK
                     WHERE unid-feder.pais   = estabelec.pais
                       AND unid-feder.estado = estabelec.estado NO-ERROR.
                
            ASSIGN de-icms = 1
                l-ok = NO.
            
            IF unid-feder.estado = emitente.estado THEN
                ASSIGN de-icms = (100 - unid-feder.per-icms-int) / 100.
            ELSE DO:
                DO i = 1 TO 25:
                    IF unid-feder.est-exc[i] = emitente.estado AND NOT l-ok THEN
                        ASSIGN de-icms = (100 - unid-feder.perc-exc[i]) / 100
                               l-ok = YES.
                               
                END.
                IF NOT l-ok THEN
                    ASSIGN de-icms = (100 - unid-feder.per-icms-ext) / 100.
            END.

            ASSIGN tt-ped-item.vl-pretab        = preco-item.preco-venda / de-icms 
                   tt-ped-item.vl-preori        = preco-item.preco-venda / de-icms.
            if natur-oper.per-des-icm > 0 then 
                assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)).
            else 
                assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori.      
                
            assign tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                   tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.


            RUN dibo/bodi154.p PERSISTENT SET h-bodi154-bo.

            FOR FIRST tt-ped-item:
                
                RUN openQueryStatic IN h-bodi154-bo(INPUT "Default":U).
                RUN emptyRowErrors  IN h-bodi154-bo.
                RUN createMPLog     IN h-bodi154-bo(INPUT NO).
                
                IF CAN-FIND(FIRST ped-item OF tt-ped-item NO-LOCK) THEN DO:
                    RUN goToKey      IN h-bodi154-bo (INPUT tt-ped-item.nome-abrev,  
                                                      INPUT tt-ped-item.nr-pedcli,   
                                                      INPUT tt-ped-item.nr-sequencia,
                                                      INPUT tt-ped-item.it-codigo,   
                                                      INPUT tt-ped-item.cod-refer).   
                    RUN setRecord    IN h-bodi154-bo(INPUT TABLE tt-ped-item).
                    RUN updateRecord IN h-bodi154-bo.                
                END.
                ELSE DO:
                    RUN setRecord    IN h-bodi154-bo(INPUT TABLE tt-ped-item).
                    RUN createRecord IN h-bodi154-bo.
                END.

                RUN getRowErrors    IN h-bodi154-bo(OUTPUT TABLE RowErrors).

               FOR EACH rowerrors
                   WHERE rowerrors.errornumber = 7025:
                   DELETE rowerrors.
               END.

                IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
                    FIND FIRST b-int-ped-item
                        WHERE b-int-ped-item.nome-abrev   = ttped-item.nome-abrev
                          AND b-int-ped-item.nr-pedcli    = ttped-item.nr-pedcli
                          AND b-int-ped-item.nr-sequencia = ttped-item.nr-sequencia
                          AND b-int-ped-item.it-codigo    = ttped-item.it-codigo
                          AND b-int-ped-item.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.

                    IF AVAILABLE b-int-ped-item THEN DO:
                        CREATE int-ped-item.
                        BUFFER-COPY b-int-ped-item TO int-ped-item
                        ASSIGN int-ped-item.nr-sequencia = tt-ped-item.nr-sequencia
                               int-ped-item.it-codigo    = tt-ped-item.it-codigo.
                        
                        FIND CURRENT mgesp.int-ped-item NO-LOCK NO-ERROR.
                        RELEASE mgesp.int-ped-item.
                    END.
                    FOR each int-ped-item-astec
                        WHERE int-ped-item-astec.nome-abrev   = ttped-item.nome-abrev
                          AND int-ped-item-astec.nr-pedcli    = ttped-item.nr-pedcli
                          AND int-ped-item-astec.nr-sequencia = ttped-item.nr-sequencia
                          AND int-ped-item-astec.it-codigo    = ttped-item.it-codigo EXCLUSIVE-LOCK:
                        
                        CREATE b-int-ped-item-astec.
                        BUFFER-COPY int-ped-item-astec EXCEPT it-codigo nr-sequencia TO b-int-ped-item-astec.
                        ASSIGN b-int-ped-item-astec.nr-sequencia = tt-ped-item.nr-sequencia 
                               b-int-ped-item-astec.it-codigo    = tt-ped-item.it-codigo.    

                    END.

                END.
                ELSE DO:
                    
         
                    RUN pi-ShowMessage.
                    undo inicial, return.
                    
                END.

                DELETE tt-ped-item.
            END.

            RUN destroyBO IN h-bodi154-bo.
            DELETE PROCEDURE h-bodi154-bo.

            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType   <> "INTERNAL":U
                          AND RowErrors.ErrorNumber <> 7025 
                          AND RowErrors.ErrorNumber <> 28761) THEN DO:

                RUN pi-ShowMessage.
                UNDO, LEAVE.
            END.
            ELSE DO:
                IF NOT AVAIL ttped-item THEN
                    RETURN "OK":U.

                IF  SESSION:SET-WAIT-STATE("general") THEN.

                IF NOT VALID-HANDLE(bo-ped-item-can)                OR
                   bo-ped-item-can:TYPE <> "PROCEDURE":U            OR
                   bo-ped-item-can:FILE-NAME <> "dibo/bodi154can.p" THEN
                    RUN dibo/bodi154can.p PERSISTENT SET bo-ped-item-can.

                RUN setUserLog in bo-ped-item-can (INPUT c-seg-usuario).

                RUN validateCancelation in bo-ped-item-can (INPUT ttped-item.r-rowid,
                                                            INPUT c-desc-motivo,
                                                            INPUT-OUTPUT TABLE RowErrors).

                IF  SESSION:SET-WAIT-STATE("") THEN.

                IF  CAN-FIND(FIRST RowErrors) THEN DO:
                    DELETE PROCEDURE bo-ped-item-can.
                    ASSIGN bo-ped-item-can = ?.
                    RUN pi-ShowMessage.
                    UNDO, LEAVE.
                END.
                ELSE DO:
                    IF  ttped-item.ind-componen = 2 THEN
                        RUN updateCancelationComposto IN bo-ped-item-can (INPUT  ttped-item.r-rowid,
                                                                          INPUT  c-desc-motivo,
                                                                          INPUT  da-data,
                                                                          INPUT  i-cod-motivo).
                    ELSE
                        RUN updateCancelation IN bo-ped-item-can (INPUT  ttped-item.r-rowid,
                                                                  INPUT  c-desc-motivo,
                                                                  INPUT  da-data,
                                                                  INPUT  i-cod-motivo).

                        MESSAGE "Item Substituido" SKIP
                                ""
                                "Complete o pedido atraves do programa PD4000" SKIP
                                "ou no proprio ESPDP054"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.

                DELETE PROCEDURE bo-ped-item-can.
                ASSIGN bo-ped-item-can = ?.
            END.
            RUN cancelRecord IN THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
/*     {method/zoomreposition.i &ProgramZoom="dizoom/z03di154.w"} */
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="eszoom/z03es154.w"
                       &campo="ttped-item.nome-abrev"    
                       &campo2="ttped-item.nr-pedcli"
                       &campo3="ttped-item.nr-sequencia"
                       &campo4="ttped-item.it-codigo"
                       &campozoom="nome-abrev"
                       &campozoom2="nr-pedcli"
                       &campozoom3="nr-sequencia"
                       &campozoom4="it-codigo"
                       &frame="fpage0"
                       &frame2="fpage0"}

      
        IF VALID-HANDLE(wh-pesquisa) THEN
               WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOTable} (INPUT FRAME fPage0 ttped-item.nome-abrev, INPUT FRAME fPage0 ttped-item.nr-pedcli ,  INPUT FRAME fPage0 ttped-item.nr-sequencia, INPUT FRAME fPage0 ttped-item.it-codigo, INPUT "").
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item do Pedido":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).


    FIND FIRST ped-item NO-LOCK WHERE ROWID(ped-item) = rgoto NO-ERROR.
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
  
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


&Scoped-define SELF-NAME c-novo-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-novo-item wMaintenance
ON LEAVE OF c-novo-item IN FRAME fpage0 /* Novo Item */
DO:
    FIND ITEM
      WHERE ITEM.it-codigo = INPUT FRAME fpage0 c-novo-item NO-LOCK NO-ERROR.
  IF AVAIL ITEM THEN DO:
      ASSIGN c-descricao-item-novo:SCREEN-VALUE = ITEM.desc-item.
  END.
  ELSE DO:
      ASSIGN c-descricao-item-novo:SCREEN-VALUE = "".
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-novo-item wMaintenance
ON VALUE-CHANGED OF c-novo-item IN FRAME fpage0 /* Novo Item */
DO:
    FIND ITEM
      WHERE ITEM.it-codigo = INPUT FRAME fpage0 c-novo-item NO-LOCK NO-ERROR.
  IF AVAIL ITEM THEN DO:
      ASSIGN c-descricao-item-novo:SCREEN-VALUE = ITEM.desc-item.
  END.
  ELSE DO:
      ASSIGN c-descricao-item-novo:SCREEN-VALUE = "".
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    

    {method/showmessage.i3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND ITEM
    WHERE ITEM.it-codigo = ttped-item.it-codigo NO-LOCK NO-ERROR.
IF AVAIL ITEM THEN DO:
    ASSIGN c-descricao-item:SCREEN-VALUE IN FRAME fpage0 = ITEM.desc-item.
END.
ELSE DO:
    ASSIGN c-descricao-item:SCREEN-VALUE IN FRAME fpage0 = "".
END.

FIND emitente
    WHERE emitente.nome-abrev = ttped-item.nome-abrev NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:
    ASSIGN c-descricao-cliente:SCREEN-VALUE IN FRAME fpage0  = emitente.nome-emit.
END.
ELSE ASSIGN c-descricao-cliente:SCREEN-VALUE IN FRAME fpage0  = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN btCompleteOrder:SENSITIVE IN FRAME fPage0 = YES.
    
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
    
    DEFINE VARIABLE c-nr-pedcli    LIKE {&ttTable}.nr-pedcli    NO-UNDO.
    DEFINE VARIABLE c-nome-abrev   LIKE {&ttTable}.nome-abrev   NO-UNDO.
    DEFINE VARIABLE i-nr-sequencia LIKE {&ttTable}.nr-sequencia NO-UNDO.
    DEFINE VARIABLE c-it-codigo    LIKE {&ttTable}.it-codigo  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-nr-pedcli       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-nome-abrev      AT ROW 2.21 COL 17.72 COLON-ALIGNED
        i-nr-sequencia    AT ROW 3.21 COL 17.72 COLON-ALIGNED
        c-it-codigo       AT ROW 4.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 5.63 COL 2.14
        btGoToCancel      AT ROW 5.63 COL 13
        rtGoToButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Ped-item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_ped-item"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-nr-pedcli c-nome-abrev i-nr-sequencia c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-nome-abrev, INPUT c-nr-pedcli ,  INPUT i-nr-sequencia, INPUT c-it-codigo, INPUT "").
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "<Table>":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-nr-pedcli c-nome-abrev i-nr-sequencia c-it-codigo btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "bodi154.p":U THEN DO:
        {btb/btb008za.i1 dibo/bodi154.p YES}
        {btb/btb008za.i2 dibo/bodi154.p '' {&hDBOTable}}
    END.
    
    RUN setConstraint IN {&hDBOTable}  NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiona wMaintenance 
PROCEDURE pi-reposiona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-rowid-ped-item AS ROWID NO-UNDO.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT p-rowid-ped-item).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ShowMessage wMaintenance 
PROCEDURE pi-ShowMessage :
{method/showmessage.i1}
    {method/showmessage.i2 &Modal=YES} 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

