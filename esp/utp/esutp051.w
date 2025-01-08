&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-correios NO-UNDO LIKE correios
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
{include/i-prgvrs.i ESUTP051 1.00.00.000}


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESUTP051
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

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

&GLOBAL-DEFINE ttTable        tt-correios
&GLOBAL-DEFINE hDBOTable      h-boes563
&GLOBAL-DEFINE DBOTable       correios


&GLOBAL-DEFINE page0KeyFields tt-correios.cod-estabel tt-correios.mes-ref tt-correios.nr-contrato tt-correios.nr-fatura tt-correios.cod-cliente ~
                              tt-correios.nr-cartao tt-correios.servico tt-correios.dt-postagem tt-correios.nr-docto   
&GLOBAL-DEFINE page0Fields    tt-correios.peso tt-correios.qtde tt-correios.valor tt-correios.cc-codigo tt-correios.cod-destino tt-correios.un-postagem ~
                              tt-correios.servico-adicional tt-correios.origem-postagem 


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */

DEFINE VARIABLE i-seq-erros-api-ctb-cc AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-correios.cod-estabel tt-correios.mes-ref ~
tt-correios.nr-contrato tt-correios.nr-fatura tt-correios.cod-cliente ~
tt-correios.nr-cartao tt-correios.dt-postagem tt-correios.servico ~
tt-correios.nr-docto tt-correios.cc-codigo tt-correios.servico-adicional ~
tt-correios.cod-destino tt-correios.peso tt-correios.qtde tt-correios.valor ~
tt-correios.origem-postagem tt-correios.un-postagem 
&Scoped-define ENABLED-TABLES tt-correios
&Scoped-define FIRST-ENABLED-TABLE tt-correios
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp fi-desc-estabel fi-desc-custo rtToolBar ~
RECT-11 RECT-12 
&Scoped-Define DISPLAYED-FIELDS tt-correios.cod-estabel tt-correios.mes-ref ~
tt-correios.nr-contrato tt-correios.nr-fatura tt-correios.cod-cliente ~
tt-correios.nr-cartao tt-correios.dt-postagem tt-correios.servico ~
tt-correios.nr-docto tt-correios.cc-codigo tt-correios.servico-adicional ~
tt-correios.cod-destino tt-correios.peso tt-correios.qtde tt-correios.valor ~
tt-correios.origem-postagem tt-correios.un-postagem 
&Scoped-define DISPLAYED-TABLES tt-correios
&Scoped-define FIRST-DISPLAYED-TABLE tt-correios
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel fi-desc-custo 

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

DEFINE VARIABLE fi-desc-custo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 5.63.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 8.5.

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
     tt-correios.cod-estabel AT ROW 3.75 COL 16 COLON-ALIGNED WIDGET-ID 84
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-estabel AT ROW 3.75 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-correios.mes-ref AT ROW 4.75 COL 16 COLON-ALIGNED WIDGET-ID 88
          LABEL "Periodo" FORMAT "9999/99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-correios.nr-contrato AT ROW 5.75 COL 16 COLON-ALIGNED WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-correios.nr-fatura AT ROW 6.75 COL 16 COLON-ALIGNED WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-correios.cod-cliente AT ROW 7.75 COL 16 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-correios.nr-cartao AT ROW 4.75 COL 53 COLON-ALIGNED WIDGET-ID 90
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     tt-correios.dt-postagem AT ROW 5.75 COL 53 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-correios.servico AT ROW 6.75 COL 53 COLON-ALIGNED WIDGET-ID 104
          LABEL "Servico"
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-correios.nr-docto AT ROW 7.75 COL 53 COLON-ALIGNED WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-correios.cc-codigo AT ROW 9.5 COL 16 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-desc-custo AT ROW 9.5 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-correios.servico-adicional AT ROW 10.5 COL 16 COLON-ALIGNED WIDGET-ID 106
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     tt-correios.cod-destino AT ROW 11.5 COL 16 COLON-ALIGNED WIDGET-ID 82
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-correios.peso AT ROW 12.5 COL 16 COLON-ALIGNED WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     tt-correios.qtde AT ROW 13.46 COL 16 COLON-ALIGNED WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     tt-correios.valor AT ROW 14.5 COL 16 COLON-ALIGNED WIDGET-ID 110
          LABEL "Valor"
          VIEW-AS FILL-IN 
          SIZE 16.86 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.04
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     tt-correios.origem-postagem AT ROW 15.5 COL 16 COLON-ALIGNED WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     tt-correios.un-postagem AT ROW 16.5 COL 16 COLON-ALIGNED WIDGET-ID 108
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     rtToolBar AT ROW 1 COL 1
     RECT-11 AT ROW 3.38 COL 3 WIDGET-ID 112
     RECT-12 AT ROW 9.25 COL 3 WIDGET-ID 114
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-correios T "?" NO-UNDO mgesp correios
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
         HEIGHT             = 17.13
         WIDTH              = 90
         MAX-HEIGHT         = 28.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.54
         VIRTUAL-WIDTH      = 182.86
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-correios.mes-ref IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-correios.servico IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-correios.valor IN FRAME fpage0
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

    IF AVAIL tt-correios THEN
        ASSIGN tt-correios.mes-ref:SCREEN-VALUE IN FRAME fPage0 = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99").
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
    
    IF AVAIL tt-correios THEN DO:
        ASSIGN tt-correios.manual = YES.
    END.
   
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es563.w"}

        /* z01es413.w */
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


&Scoped-define SELF-NAME tt-correios.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-correios.cc-codigo wMaintenance
ON F5 OF tt-correios.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:

    /*
     {include/zoomvar.i &prog-zoom="adzoom/z01ad246"
                      &campo="tt-correios.cc-codigo"
                      &campozoom="sc-codigo"
                      &frame="fpage0"
                      &campo2="fi-desc-custo"
                      &campozoom2="descricao"
                      &frame2="fpage0"}*/
                      

    if not valid-handle(h_api_ccusto) then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    assign v_ind_finalid_cta = "(nenhum)".

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.     
        

    /** Instancia aplicativo **/
    {method/showmessage.i1}

    /** cria rowerrors **/
    FOR EACH tt_log_erro NO-LOCK:
            CREATE RowErrors.
            
            ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                       RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                       i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.

    END.

    IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
    END.
    /** Limpa temp-tables de erros **/
    {method/showmessage.i3}


    if v_cod_ccusto <> "" then
        ASSIGN tt-correios.cc-codigo:SCREEN-VALUE IN FRAME fPage0 = v_cod_ccusto
               fi-desc-custo:SCREEN-VALUE         IN FRAME fPage0 = v_des_titulo_ccusto.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-correios.cc-codigo wMaintenance
ON LEAVE OF tt-correios.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
   assign input frame fPage0 tt-correios.cc-codigo
          fi-desc-custo:SCREEN-VALUE IN FRAME fpage0 = "".
          
   /*
   {include/leave.i &tabela=sub-conta
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-custo
                    &where="sub-conta.sc-codigo = tt-correios.cc-codigo"}  
                    */


    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 tt-correios.cod-estabel:

        RUN prgint/utb/utb742za.py persistent set h_api_ccusto.
    
        ASSIGN v_cod_ccusto = INPUT FRAME fPage0 tt-correios.cc-codigo.
    
        EMPTY TEMP-TABLE tt_log_erro.
    
        run pi_busca_dados_ccusto in h_api_ccusto (input  estabelec.ep-codigo,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input TODAY,              /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
    
        IF VALID-HANDLE(h_api_ccusto) THEN
            DELETE OBJECT h_api_ccusto.
    
        IF CAN-FIND(FIRST tt_log_erro) THEN DO:
            EMPTY TEMP-TABLE tt_log_erro.
            RETURN.
        END.
    
        ASSIGN fi-desc-custo:SCREEN-VALUE IN FRAME fpage0 = v_des_titulo_ccusto.  

    END.
                   

      
                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-correios.cc-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-correios.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-correios.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-correios.cod-estabel wMaintenance
ON F5 OF tt-correios.cod-estabel IN FRAME fpage0 /* Estab */
DO:

   {include/zoomvar.i &prog-zoom="adzoom/z01Ad107.w"
                       &campo=tt-correios.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=fi-desc-estabel  
                       &campozoom2=nome
                       &Frame=fpage0}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-correios.cod-estabel wMaintenance
ON LEAVE OF tt-correios.cod-estabel IN FRAME fpage0 /* Estab */
DO:
    assign input frame fPage0 tt-correios.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-correios.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

tt-correios.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-correios.cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0. 

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
    IF AVAIL tt-correios THEN DO:
        APPLY "LEAVE":U TO tt-correios.cod-estabel IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-correios.cc-codigo   IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0  = ""
               fi-desc-custo:SCREEN-VALUE IN FRAME fPage0    = "".
    END.
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
    DEFINE VARIABLE c-mes-ref     LIKE {&ttTable}.mes-ref     NO-UNDO.
    DEFINE VARIABLE c-nr-contrato LIKE {&ttTable}.nr-contrato NO-UNDO.
    DEFINE VARIABLE c-nr-fatura   LIKE {&ttTable}.nr-fatura   NO-UNDO.
    DEFINE VARIABLE i-cod-cli     LIKE {&ttTable}.cod-cliente NO-UNDO.
    DEFINE VARIABLE c-nr-cartao   LIKE {&ttTable}.nr-cartao   NO-UNDO.
    DEFINE VARIABLE c-servico     LIKE {&ttTable}.servico     NO-UNDO.
    DEFINE VARIABLE dt-postagem   LIKE {&ttTable}.dt-postagem NO-UNDO.
    DEFINE VARIABLE c-nr-docto    LIKE {&ttTable}.nr-docto    NO-UNDO.
      
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel               AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4   BY .88
        c-mes-ref FORMAT "9999/99"  AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8   BY .88
        c-nr-contrato               AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20  BY .88
        c-nr-fatura                 AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20  BY .88
        i-cod-cli                   AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7   BY .88
        c-nr-cartao                 AT ROW 6.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10  BY .88
        c-servico                   AT ROW 7.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20  BY .88
        dt-postagem                 AT ROW 8.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10  BY .88
        c-nr-docto                  AT ROW 9.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10  BY .88

        btGoToOK          AT ROW 10.63 COL 2.14
        btGoToCancel      AT ROW 10.63 COL 13
        rtGoToButton      AT ROW 10.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Correios" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Correios"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN  c-cod-estabel c-mes-ref c-nr-contrato c-nr-fatura i-cod-cli c-nr-cartao   
                c-servico dt-postagem c-nr-docto.    
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel,
                                     input c-mes-ref    ,
                                     input c-nr-contrato,
                                     input c-nr-fatura  ,
                                     input i-cod-cli    ,
                                     input c-nr-cartao  ,
                                     input c-servico    ,
                                     input dt-postagem  ,
                                     input c-nr-docto).   

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Correios":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-mes-ref c-nr-contrato 
           c-nr-fatura i-cod-cli c-nr-cartao   
           c-servico dt-postagem c-nr-docto
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
       {&hDBOTable}:FILE-NAME <> "esbo\boes563.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes563.p YES}
        {btb/btb008za.i2 esbo\boes563.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

