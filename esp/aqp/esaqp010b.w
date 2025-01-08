&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-auditoria-geral NO-UNDO LIKE auditoria-geral
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-visual NO-UNDO LIKE auditoria-visual
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESAQP010B 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP010B
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-auditoria-visual
&GLOBAL-DEFINE hDBOTable         h-DBOes672
&GLOBAL-DEFINE DBOTable          auditoria-visual

&GLOBAL-DEFINE ttParent          tt-auditoria-geral
&GLOBAL-DEFINE DBOParentTable    auditoria-geral   

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-auditoria-visual.nr-seq-orig-prob ~
                                 tt-auditoria-visual.nr-seq-problema  ~
                                 tt-auditoria-visual.ind-problema     ~
                                 tt-auditoria-visual.des-serie        ~
                                 tt-auditoria-visual.qt-problema      ~
                                 tt-auditoria-visual.nr-seq-comp      ~
                                 tt-auditoria-visual.nr-seq-categoria ~
                                 tt-auditoria-visual.nr-cartao        ~
                                 tt-auditoria-visual.sigla        ~
                                 tt-auditoria-visual.log-revisao      ~
                                 tt-auditoria-visual.log-bloqueio     ~
                                 tt-auditoria-visual.obs-causa
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.

define new global shared variable l-cadteste-chamador as log            no-undo.
define new global shared variable h-prog-chamador     as handle         no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-auditoria-visual.nr-seq-problema ~
tt-auditoria-visual.nr-seq-orig-prob tt-auditoria-visual.ind-problema ~
tt-auditoria-visual.des-serie tt-auditoria-visual.qt-problema ~
tt-auditoria-visual.nr-seq-comp tt-auditoria-visual.nr-seq-categoria ~
tt-auditoria-visual.nr-cartao tt-auditoria-visual.sigla ~
tt-auditoria-visual.log-revisao tt-auditoria-visual.log-bloqueio ~
tt-auditoria-visual.obs-causa 
&Scoped-define ENABLED-TABLES tt-auditoria-visual
&Scoped-define FIRST-ENABLED-TABLE tt-auditoria-visual
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-16 btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-auditoria-visual.nr-seq-problema ~
tt-auditoria-visual.nr-seq-orig-prob tt-auditoria-visual.ind-problema ~
tt-auditoria-visual.des-serie tt-auditoria-visual.qt-problema ~
tt-auditoria-visual.nr-seq-comp tt-auditoria-visual.nr-seq-categoria ~
tt-auditoria-visual.nr-cartao tt-auditoria-visual.sigla ~
tt-auditoria-visual.log-revisao tt-auditoria-visual.log-bloqueio ~
tt-auditoria-visual.obs-causa 
&Scoped-define DISPLAYED-TABLES tt-auditoria-visual
&Scoped-define FIRST-DISPLAYED-TABLE tt-auditoria-visual
&Scoped-Define DISPLAYED-OBJECTS v_des_seq_problema v_des_orig_prob ~
v_des_seq_comp v_des_categ v_des_sigla 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE v_des_categ AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_orig_prob AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_seq_comp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_seq_problema AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_sigla AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-auditoria-visual.nr-seq-problema AT ROW 1.17 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_seq_problema AT ROW 1.17 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-auditoria-visual.nr-seq-orig-prob AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_orig_prob AT ROW 2.08 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-auditoria-visual.ind-problema AT ROW 3.04 COL 27 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", 1,
"NÆo", 2
          SIZE 12 BY .75
     tt-auditoria-visual.des-serie AT ROW 3.88 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-auditoria-visual.qt-problema AT ROW 5.46 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-auditoria-visual.nr-seq-comp AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_seq_comp AT ROW 6.38 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-auditoria-visual.nr-seq-categoria AT ROW 7.29 COL 19 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_categ AT ROW 7.29 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-auditoria-visual.nr-cartao AT ROW 8.21 COL 19 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     tt-auditoria-visual.sigla AT ROW 9.13 COL 19 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     v_des_sigla AT ROW 9.13 COL 24.14 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     tt-auditoria-visual.log-revisao AT ROW 10.21 COL 21 WIDGET-ID 34
          LABEL "Este problema ‚ motivo para RECUSA deste lote?"
          VIEW-AS TOGGLE-BOX
          SIZE 38 BY .79
     tt-auditoria-visual.log-bloqueio AT ROW 10.96 COL 21 WIDGET-ID 44
          LABEL "Este problema ‚ motivo para BLOQUEIO deste lote?"
          VIEW-AS TOGGLE-BOX
          SIZE 38 BY .79
     tt-auditoria-visual.obs-causa AT ROW 12.04 COL 2 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 88 BY 5
     btOK AT ROW 17.54 COL 2
     btSave AT ROW 17.54 COL 13
     btCancel AT ROW 17.54 COL 24
     btHelp AT ROW 17.54 COL 80
     "Causa:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 11.42 COL 2.29 WIDGET-ID 42
     "A linha detectaria o problema?" VIEW-AS TEXT
          SIZE 21 BY .54 AT ROW 3.13 COL 6 WIDGET-ID 14
     "(Tratamento nÆo conformidade)" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 8.46 COL 54 WIDGET-ID 40
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.29 COL 1
     RECT-16 AT ROW 5.25 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 18.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-auditoria-geral T "?" NO-UNDO mgesp auditoria-geral
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-visual T "?" NO-UNDO mgesp auditoria-visual
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.04
         WIDTH              = 90.72
         MAX-HEIGHT         = 18.04
         MAX-WIDTH          = 142
         VIRTUAL-HEIGHT     = 18.04
         VIRTUAL-WIDTH      = 142
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR TOGGLE-BOX tt-auditoria-visual.log-bloqueio IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-auditoria-visual.log-revisao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN v_des_categ IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_orig_prob IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_seq_comp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_seq_problema IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_sigla IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    if l-cadteste-chamador then
        run pi-atualiza-log-prob in h-prog-chamador (input no).

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.

    FIND FIRST auditoria-geral EXCLUSIVE-LOCK
        WHERE ROWID(auditoria-geral) = prParent NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        IF AVAIL tt-auditoria-geral AND AVAIL auditoria-geral THEN DO:
            ASSIGN tt-auditoria-geral.log-bloqueio = tt-auditoria-visual.log-bloqueio:CHECKED IN FRAME fPage0
                   auditoria-geral.log-bloqueio    = tt-auditoria-visual.log-bloqueio:CHECKED IN FRAME fPage0.

            IF tt-auditoria-visual.log-revisao:CHECKED IN FRAME fPage0 THEN
                ASSIGN tt-auditoria-geral.qtd-prod-revis = tt-auditoria-geral.qt-prod-lote
                       auditoria-geral.qtd-prod-revis    = tt-auditoria-geral.qt-prod-lote.
            ELSE
                ASSIGN tt-auditoria-geral.qtd-prod-revis = 0
                       auditoria-geral.qtd-prod-revis    = 0.

            IF tt-auditoria-visual.log-bloqueio:CHECKED IN FRAME fPage0 THEN
                ASSIGN tt-auditoria-geral.qtd-prod-bloq = tt-auditoria-geral.qt-prod-lote
                       auditoria-geral.qtd-prod-bloq    = tt-auditoria-geral.qt-prod-lote.
            ELSE
                ASSIGN tt-auditoria-geral.qtd-prod-bloq = 0
                       auditoria-geral.qtd-prod-bloq    = 0.

            IF CAN-FIND(FIRST auditoria-visual OF auditoria-geral
                        WHERE auditoria-visual.log-revisao = YES) THEN
               ASSIGN tt-auditoria-geral.log-revisado = YES
                      auditoria-geral.log-revisado    = YES.
            ELSE
               ASSIGN tt-auditoria-geral.log-revisado = NO
                      auditoria-geral.log-revisado    = NO.
        END.

        IF l-cadteste-chamador THEN
            RUN pi-atualiza-log-prob IN h-prog-chamador (INPUT YES).

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    FIND FIRST auditoria-geral EXCLUSIVE-LOCK
        WHERE ROWID(auditoria-geral) = prParent NO-ERROR.

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        IF AVAIL auditoria-geral THEN DO:
            ASSIGN auditoria-geral.log-revisado = tt-auditoria-visual.log-revisao:CHECKED IN FRAME fPage0
                   auditoria-geral.log-bloqueio = tt-auditoria-visual.log-bloqueio:CHECKED.
            IF tt-auditoria-visual.log-revisao:CHECKED IN FRAME fPage0 THEN
                ASSIGN auditoria-geral.qtd-prod-revis = auditoria-geral.qt-prod-lote.
            ELSE
                ASSIGN auditoria-geral.qtd-prod-revis = 0.

            IF tt-auditoria-visual.log-bloqueio:CHECKED IN FRAME fPage0 THEN
                ASSIGN auditoria-geral.qtd-prod-bloq = auditoria-geral.qt-prod-lote.
            ELSE
                ASSIGN auditoria-geral.qtd-prod-bloq = 0.
        END.

        IF l-cadteste-chamador THEN
            RUN pi-atualiza-log-prob IN h-prog-chamador (INPUT YES).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-visual.nr-seq-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-categoria wMaintenanceNoNavigation
ON F5 OF tt-auditoria-visual.nr-seq-categoria IN FRAME fpage0 /* Categoria */
DO:
  {method/ZoomFields.i &ProgramZoom="eszoom/z01es665.w"
                       &FieldZoom1="nr-seq-categoria"
                       &FieldScreen1="tt-auditoria-visual.nr-seq-categoria"
                       &Frame1="fPage0"
                       &FieldZoom2="des-categoria"
                       &FieldScreen2="v_des_categ"
                       &enableImplant="NO"
                       &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-categoria wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-visual.nr-seq-categoria IN FRAME fpage0 /* Categoria */
DO:
    FOR FIRST aq-categoria NO-LOCK
        WHERE aq-categoria.nr-seq-categoria = INPUT FRAME fpage0 tt-auditoria-visual.nr-seq-categoria:

        ASSIGN v_des_categ:SCREEN-VALUE IN FRAME fPage0 = aq-categoria.des-categoria.

    END.

    IF NOT AVAIL aq-categoria THEN
        ASSIGN v_des_categ:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-categoria wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-visual.nr-seq-categoria IN FRAME fpage0 /* Categoria */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-visual.nr-seq-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-comp wMaintenanceNoNavigation
ON F5 OF tt-auditoria-visual.nr-seq-comp IN FRAME fpage0 /* Componente */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es677.w"
                         &FieldZoom1="nr-seq-comp"
                         &FieldScreen1="tt-auditoria-visual.nr-seq-comp"
                         &Frame1="fPage0"
                         &FieldZoom2="des-componente"
                         &FieldScreen2="v_des_seq_comp"
                         &Frame2="fPage0"
                         &enableImplant="NO"
                         &RunMethod="run pi-somente-ativos in hProgramZoom."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-comp wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-visual.nr-seq-comp IN FRAME fpage0 /* Componente */
DO:
    find first aq-comp-prod no-lock
         where aq-comp-prod.nr-seq-comp = input frame fPage0 tt-auditoria-visual.nr-seq-comp no-error.
    if avail aq-comp-prod then
        assign v_des_seq_comp:screen-value in frame fPage0 = aq-comp-prod.des-componente.
    else
        assign v_des_seq_comp:screen-value in frame fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-visual.nr-seq-comp IN FRAME fpage0 /* Componente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-visual.nr-seq-orig-prob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-orig-prob wMaintenanceNoNavigation
ON F5 OF tt-auditoria-visual.nr-seq-orig-prob IN FRAME fpage0 /* Origem */
DO:
  {method/ZoomFields.i &ProgramZoom="eszoom/z01es679.w"
                       &FieldZoom1="nr-seq-orig-prob"
                       &FieldScreen1="tt-auditoria-visual.nr-seq-orig-prob"
                       &Frame1="fPage0"
                       &FieldZoom2="des-orig-prob"
                       &FieldScreen2="v_des_orig_prob"
                       &Frame2="fPage0"
                       &enableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-orig-prob wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-visual.nr-seq-orig-prob IN FRAME fpage0 /* Origem */
DO:
    FOR FIRST aq-origem-prob NO-LOCK
        WHERE aq-origem-prob.nr-seq-orig-prob = INPUT FRAME fpage0 tt-auditoria-visual.nr-seq-orig-prob:

        ASSIGN v_des_orig_prob:SCREEN-VALUE IN FRAME fPage0 = aq-origem-prob.des-orig-prob.

    END.

    IF NOT AVAIL aq-origem-prob THEN
        ASSIGN v_des_orig_prob:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-orig-prob wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-visual.nr-seq-orig-prob IN FRAME fpage0 /* Origem */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-visual.nr-seq-problema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-problema wMaintenanceNoNavigation
ON F5 OF tt-auditoria-visual.nr-seq-problema IN FRAME fpage0 /* Problema */
DO:
  {method/ZoomFields.i &ProgramZoom="eszoom/z01es664.w"
                       &FieldZoom1="nr-seq-problema"
                       &FieldScreen1="tt-auditoria-visual.nr-seq-problema"
                       &Frame1="fPage0"
                       &FieldZoom2="des-problema"
                       &FieldScreen2="v_des_seq_problema"
                       &Frame2="fPage0"
                       &enableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-problema wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-visual.nr-seq-problema IN FRAME fpage0 /* Problema */
DO:
    FOR FIRST aq-problema NO-LOCK
        WHERE aq-problema.nr-seq-problema = INPUT FRAME fpage0 tt-auditoria-visual.nr-seq-problema:

        ASSIGN v_des_seq_problema:SCREEN-VALUE IN FRAME fPage0                   = aq-problema.des-problema.

    END.

    IF NOT AVAIL aq-problema THEN DO:

        ASSIGN v_des_seq_problema:SCREEN-VALUE IN FRAME fPage0 = "".

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.nr-seq-problema wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-visual.nr-seq-problema IN FRAME fpage0 /* Problema */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-visual.sigla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.sigla wMaintenanceNoNavigation
ON F5 OF tt-auditoria-visual.sigla IN FRAME fpage0 /* C‚lula */
DO:
  
    {method/zoomfields.i &ProgramZoom="eszoom\z01es244.w"
                         &FieldZoom1="sigla"        
                         &FieldScreen1="tt-auditoria-visual.sigla"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"        
                         &FieldScreen2="v_des_sigla"
                         &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.sigla wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-visual.sigla IN FRAME fpage0 /* C‚lula */
DO:
  
    DO WITH FRAME fPage0:

        ASSIGN v_des_sigla:SCREEN-VALUE = "".
    
        FOR FIRST ns-sigla NO-LOCK
            WHERE ns-sigla.sigla = SELF:SCREEN-VALUE:
    
            ASSIGN v_des_sigla:SCREEN-VALUE = ns-sigla.descricao.
    
        END.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.sigla wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-visual.sigla IN FRAME fpage0 /* C‚lula */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-visual.sigla wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-auditoria-visual.sigla IN FRAME fpage0 /* C‚lula */
DO:
    ASSIGN self:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).

    APPLY "END" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-auditoria-visual.nr-seq-orig-prob:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
tt-auditoria-visual.nr-seq-problema:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
tt-auditoria-visual.nr-seq-comp:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
tt-auditoria-visual.nr-seq-categoria:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
tt-auditoria-visual.sigla:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    apply "leave" to tt-auditoria-visual.nr-seq-orig-prob in frame fPage0.
    apply "leave" to tt-auditoria-visual.nr-seq-problema  in frame fPage0.
    apply "leave" to tt-auditoria-visual.nr-seq-comp      in frame fPage0.
    apply "leave" to tt-auditoria-visual.nr-seq-categoria in frame fPage0.
    apply "leave" to tt-auditoria-visual.sigla            in frame fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prog-chamador wMaintenanceNoNavigation 
PROCEDURE pi-prog-chamador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-cadtest-chamador as log    no-undo.
define input param p-prog-chamador    as handle no-undo.

assign l-cadteste-chamador = p-cadtest-chamador
       h-prog-chamador     = p-prog-chamador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    assign tt-auditoria-visual.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

