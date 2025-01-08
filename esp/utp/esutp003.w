&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-centro-custo NO-UNDO LIKE int-centro-custo
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
{include/i-prgvrs.i ESUTP003 2.06.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESUTP003
&GLOBAL-DEFINE Version        2.06.00.001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-int-centro-custo
&GLOBAL-DEFINE hDBOTable      h-boes409
&GLOBAL-DEFINE DBOTable       int-centro-custo

&GLOBAL-DEFINE page0KeyFields tt-int-centro-custo.cod-estabel ~
                              tt-int-centro-custo.cc-codigo ~
                              tt-int-centro-custo.cod-unid-negoc
&GLOBAL-DEFINE page0Fields    tt-int-centro-custo.cod_usuario tt-int-centro-custo.cod_usuario_aprov tt-int-centro-custo.segmento

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa-un AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc AS CHARACTER   NO-UNDO.

def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-centro-custo.cod-estabel ~
tt-int-centro-custo.cc-codigo tt-int-centro-custo.cod-unid-negoc ~
tt-int-centro-custo.cod_usuario tt-int-centro-custo.cod_usuario_aprov ~
tt-int-centro-custo.segmento 
&Scoped-define ENABLED-TABLES tt-int-centro-custo
&Scoped-define FIRST-ENABLED-TABLE tt-int-centro-custo
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtFields btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp fi-desc-estabel ~
fi-desc-centro-custo fi-desc-unid-negoc fi-desc-supervisor fi-desc-aprov 
&Scoped-Define DISPLAYED-FIELDS tt-int-centro-custo.cod-estabel ~
tt-int-centro-custo.cc-codigo tt-int-centro-custo.cod-unid-negoc ~
tt-int-centro-custo.cod_usuario tt-int-centro-custo.cod_usuario_aprov ~
tt-int-centro-custo.segmento 
&Scoped-define DISPLAYED-TABLES tt-int-centro-custo
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-centro-custo
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel fi-desc-centro-custo ~
fi-desc-unid-negoc fi-desc-supervisor fi-desc-aprov 

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

DEFINE VARIABLE fi-desc-aprov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-centro-custo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-supervisor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtFields
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.38.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.33.

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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-int-centro-custo.cod-estabel AT ROW 2.83 COL 23.14 COLON-ALIGNED
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     fi-desc-estabel AT ROW 2.83 COL 30.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     tt-int-centro-custo.cc-codigo AT ROW 3.83 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-desc-centro-custo AT ROW 3.83 COL 35.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     tt-int-centro-custo.cod-unid-negoc AT ROW 4.83 COL 23.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-desc-unid-negoc AT ROW 4.83 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-int-centro-custo.cod_usuario AT ROW 6.25 COL 23.14 COLON-ALIGNED WIDGET-ID 8
          LABEL "Aprovador Nota Extra"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-desc-supervisor AT ROW 6.25 COL 35.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     tt-int-centro-custo.cod_usuario_aprov AT ROW 7.25 COL 23.14 COLON-ALIGNED WIDGET-ID 10
          LABEL "Aprovador Despesa"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-desc-aprov AT ROW 7.25 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tt-int-centro-custo.segmento AT ROW 8.25 COL 17.28 WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtFields AT ROW 6.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-centro-custo T "?" NO-UNDO mgesp int-centro-custo
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
         HEIGHT             = 8.5
         WIDTH              = 90
         MAX-HEIGHT         = 8.92
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 8.92
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
/* SETTINGS FOR FILL-IN tt-int-centro-custo.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-centro-custo.cod_usuario IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-centro-custo.cod_usuario_aprov IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-centro-custo.segmento IN FRAME fpage0
   ALIGN-L                                                              */
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
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es409.w"}
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


&Scoped-define SELF-NAME tt-int-centro-custo.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cc-codigo wMaintenance
ON F5 OF tt-int-centro-custo.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in042.w
                        &campo=tt-int-centro-custo.cc-codigo
                        &campozoom=cc-codigo
                        &campo2=fi-desc-centro-custo
                        &campozoom2=descricao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cc-codigo wMaintenance
ON LEAVE OF tt-int-centro-custo.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:

    assign input frame fPage0 tt-int-centro-custo.cc-codigo.

    {include/leave.i &tabela=centro-custo
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-centro-custo
                    &where="centro-custo.cc-codigo = tt-int-centro-custo.cc-codigo"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cc-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-centro-custo.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-estabel wMaintenance
ON F5 OF tt-int-centro-custo.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-int-centro-custo.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
                        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-estabel wMaintenance
ON LEAVE OF tt-int-centro-custo.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    assign input frame fPage0 tt-int-centro-custo.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-int-centro-custo.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-centro-custo.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-unid-negoc wMaintenance
ON F5 OF tt-int-centro-custo.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  IF SEARCH("prgint/utb/utb011ka.p") <> ? OR
     SEARCH("prgint/utb/utb011ka.r") <> ? THEN DO:

      RUN prgint/utb/utb011ka.p PERSISTENT SET wh-pesquisa-un.

      IF v_cod_unid_negoc <> " ":U THEN
          ASSIGN tt-int-centro-custo.cod-unid-negoc = v_cod_unid_negoc.

      DISPLAY tt-int-centro-custo.cod-unid-negoc 
          WITH FRAME fPage0.

      APPLY "LEAVE":U TO tt-int-centro-custo.cod-unid-negoc  IN FRAME fPage0.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-unid-negoc wMaintenance
ON LEAVE OF tt-int-centro-custo.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  ASSIGN INPUT FRAME fPage0 tt-int-centro-custo.cod-unid-negoc.

  FIND FIRST unid_negoc NO-LOCK
      WHERE unid_negoc.cod_unid_negoc = tt-int-centro-custo.cod-unid-negoc NO-ERROR.

  IF AVAIL unid_negoc THEN
      ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = unid_negoc.des_unid_negoc.
  ELSE 
      ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod-unid-negoc wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-centro-custo.cod_usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario wMaintenance
ON F5 OF tt-int-centro-custo.cod_usuario IN FRAME fpage0 /* Aprovador Nota Extra */
DO:
    RUN sec/sec000ka.p /*prg_sea_usuar_mestre*/.
    IF  v_rec_usuar_mestre <> ? THEN DO:
        FIND usuar_mestre NO-LOCK
            WHERE RECID(usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
    
        DISP usuar_mestre.cod_usuar @ tt-int-centro-custo.cod_usuario WITH FRAME fpage0.
        APPLY "leave" TO tt-int-centro-custo.cod_usuario IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario wMaintenance
ON LEAVE OF tt-int-centro-custo.cod_usuario IN FRAME fpage0 /* Aprovador Nota Extra */
DO:
  ASSIGN INPUT FRAME fPage0 tt-int-centro-custo.cod_usuario.

  FIND FIRST usuar_mestre NO-LOCK
      WHERE usuar_mestre.cod_usuario = input frame fPage0 tt-int-centro-custo.cod_usuario NO-ERROR.

  IF AVAIL usuar_mestre THEN
      ASSIGN fi-desc-supervisor:SCREEN-VALUE IN FRAME fPage0 = usuar_mestre.nom_usuario.
  ELSE 
      ASSIGN fi-desc-supervisor:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.cod_usuario IN FRAME fpage0 /* Aprovador Nota Extra */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-centro-custo.cod_usuario_aprov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario_aprov wMaintenance
ON F5 OF tt-int-centro-custo.cod_usuario_aprov IN FRAME fpage0 /* Aprovador Despesa */
DO:
   RUN sec/sec000ka.p /*prg_sea_usuar_mestre*/.
    IF  v_rec_usuar_mestre <> ? THEN DO:
        FIND usuar_mestre NO-LOCK
            WHERE RECID(usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
    
        DISP usuar_mestre.cod_usuar @ tt-int-centro-custo.cod_usuario_aprov WITH FRAME fpage0.
        APPLY "leave" TO tt-int-centro-custo.cod_usuario_aprov IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario_aprov wMaintenance
ON LEAVE OF tt-int-centro-custo.cod_usuario_aprov IN FRAME fpage0 /* Aprovador Despesa */
DO:
   ASSIGN INPUT FRAME fPage0 tt-int-centro-custo.cod_usuario_aprov.

  FIND FIRST usuar_mestre NO-LOCK
      WHERE usuar_mestre.cod_usuario = input frame fPage0 tt-int-centro-custo.cod_usuario_aprov NO-ERROR.

  IF AVAIL usuar_mestre THEN
      ASSIGN fi-desc-aprov:SCREEN-VALUE IN FRAME fPage0 = usuar_mestre.nom_usuario.
  ELSE 
      ASSIGN fi-desc-aprov:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.cod_usuario_aprov wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.cod_usuario_aprov IN FRAME fpage0 /* Aprovador Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-centro-custo.segmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.segmento wMaintenance
ON F5 OF tt-int-centro-custo.segmento IN FRAME fpage0 /* Segmento */
DO:
    {include/zoomvar.i &prog-zoom=esp/utp/esutp003-z01.w
                       &campo=tt-int-centro-custo.segmento
                       &campozoom=conteudo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-centro-custo.segmento wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-centro-custo.segmento IN FRAME fpage0 /* Segmento */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
IF tt-int-centro-custo.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF tt-int-centro-custo.cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0 THEN.
IF tt-int-centro-custo.cod_usuario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF tt-int-centro-custo.cod_usuario_aprov:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF tt-int-centro-custo.segmento:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF tt-int-centro-custo.cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

{maintenance/mainblock.i}

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
    IF AVAIL tt-int-centro-custo THEN DO:
        APPLY "LEAVE":U TO tt-int-centro-custo.cod-estabel IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-int-centro-custo.cc-codigo   IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-int-centro-custo.cod_usuario IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-int-centro-custo.cod_usuario_aprov IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-int-centro-custo.cod-unid-negoc IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN fi-desc-estabel:SCREEN-VALUE      IN FRAME fPage0 = "":U
               fi-desc-centro-custo:SCREEN-VALUE IN FRAME fPage0 = "":U
               fi-desc-supervisor:SCREEN-VALUE   IN FRAME fPage0 = "":U
               fi-desc-aprov:SCREEN-VALUE        IN FRAME fPage0 = "":U
               fi-desc-unid-negoc:SCREEN-VALUE   IN FRAME fPage0 = "":U.
    END.

    RETURN "OK":U.

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
    
    DEFINE VARIABLE c-cod-estabel LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-cc-codigo   LIKE {&ttTable}.cc-codigo   NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel  AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE  6.72 BY 0.88
        c-cc-codigo    AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 11.72 BY 0.88
        btGoToOK       AT ROW 3.63 COL 2.14
        btGoToCancel   AT ROW 3.63 COL 13
        rtGoToButton   AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para C.C/Estab" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_C.C/Estab"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-cc-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , INPUT c-cc-codigo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "int-centro-custo":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-cc-codigo btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes409.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes409.p YES}
        {btb/btb008za.i2 esbo/boes409.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

