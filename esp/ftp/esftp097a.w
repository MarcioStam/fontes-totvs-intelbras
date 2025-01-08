&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-colab-deb-cred-base NO-UNDO LIKE colab-deb-cred-base
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-repres NO-UNDO LIKE repres
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*****************************************************************************
** Programa: esp/ftp/esftp097a.w
** Vers∆o..: 1.00
** Data....: 20/11/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Cadastro de Sal†rio Vari†vel do Colaborador
*****************************************************************************/
{include/i-prgvrs.i ESFTP097A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESFTP097A
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO

&GLOBAL-DEFINE ttTable           tt-colab-deb-cred-base
&GLOBAL-DEFINE hDBOTable         h-boes661
&GLOBAL-DEFINE DBOTable          boes661

&GLOBAL-DEFINE ttParent          tt-repres
&GLOBAL-DEFINE DBOParentTable    h-boad229

&GLOBAL-DEFINE page0KeyFields    tt-colab-deb-cred-base.fm-cod-com ~
                                 tt-colab-deb-cred-base.cod-mov    ~
                                 tt-colab-deb-cred-base.dt-movto
&GLOBAL-DEFINE page0Fields       tt-colab-deb-cred-base.deb-cred   ~
                                 tt-colab-deb-cred-base.valor      ~
                                 tt-colab-deb-cred-base.historico
&GLOBAL-DEFINE page0ParentFields tt-repres.cod-rep                 ~
                                 tt-repres.nome-abrev              ~
                                 tt-repres.nome

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-repres.cod-rep tt-repres.nome-abrev ~
tt-repres.nome tt-colab-deb-cred-base.fm-cod-com ~
tt-colab-deb-cred-base.cod-mov tt-colab-deb-cred-base.dt-movto ~
tt-colab-deb-cred-base.deb-cred tt-colab-deb-cred-base.valor ~
tt-colab-deb-cred-base.historico 
&Scoped-define ENABLED-TABLES tt-repres tt-colab-deb-cred-base
&Scoped-define FIRST-ENABLED-TABLE tt-repres
&Scoped-define SECOND-ENABLED-TABLE tt-colab-deb-cred-base
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-2 c-desc-fam ~
c-desc-mov btOK btSave btCancel btHelp text-1 
&Scoped-Define DISPLAYED-FIELDS tt-repres.cod-rep tt-repres.nome-abrev ~
tt-repres.nome tt-colab-deb-cred-base.fm-cod-com ~
tt-colab-deb-cred-base.cod-mov tt-colab-deb-cred-base.dt-movto ~
tt-colab-deb-cred-base.deb-cred tt-colab-deb-cred-base.valor ~
tt-colab-deb-cred-base.historico 
&Scoped-define DISPLAYED-TABLES tt-repres tt-colab-deb-cred-base
&Scoped-define FIRST-DISPLAYED-TABLE tt-repres
&Scoped-define SECOND-DISPLAYED-TABLE tt-colab-deb-cred-base
&Scoped-Define DISPLAYED-OBJECTS c-desc-fam c-desc-mov text-1 

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

DEFINE VARIABLE c-desc-fam AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 62.33 BY .87 NO-UNDO.

DEFINE VARIABLE c-desc-mov AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 66.33 BY .87 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(12)":U INITIAL "Hist¢rico:" 
      VIEW-AS TEXT 
     SIZE 6.56 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.47.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.27.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.43
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-repres.cod-rep AT ROW 1.2 COL 13.33 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .87
     tt-repres.nome-abrev AT ROW 1.2 COL 18.67 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10.45 BY .87
     tt-repres.nome AT ROW 1.2 COL 29.45 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 54.56 BY .87
     tt-colab-deb-cred-base.fm-cod-com AT ROW 2.2 COL 13.33 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8 BY .87
     c-desc-fam AT ROW 2.2 COL 21.67 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-colab-deb-cred-base.cod-mov AT ROW 3.2 COL 13.33 COLON-ALIGNED WIDGET-ID 8
          LABEL "Movimento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .87
     c-desc-mov AT ROW 3.2 COL 17.67 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-colab-deb-cred-base.dt-movto AT ROW 4.2 COL 13.33 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9 BY .87
     tt-colab-deb-cred-base.deb-cred AT ROW 5.8 COL 29.56 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", yes,
"CrÇdito", no
          SIZE 31.56 BY .8
     tt-colab-deb-cred-base.valor AT ROW 6.8 COL 13.33 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 9 BY .87
     tt-colab-deb-cred-base.historico AT ROW 7.8 COL 15.33 NO-LABEL WIDGET-ID 32
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 70.67 BY 4.93
     btOK AT ROW 13.27 COL 2
     btSave AT ROW 13.27 COL 13
     btCancel AT ROW 13.27 COL 24
     btHelp AT ROW 13.27 COL 80
     text-1 AT ROW 7.83 COL 6.78 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 13 COL 1
     RECT-2 AT ROW 5.43 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.57
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-colab-deb-cred-base T "?" NO-UNDO mgesp colab-deb-cred-base
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-repres T "?" NO-UNDO mgcad repres
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
         TITLE              = "Inclui/Modifica DÇbito/CrÇdito Base"
         HEIGHT             = 13.57
         WIDTH              = 90.22
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.56
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.56
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-colab-deb-cred-base.cod-mov IN FRAME fPage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation /* Inclui/Modifica DÇbito/CrÇdito Base */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Inclui/Modifica DÇbito/CrÇdito Base */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fPage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-deb-cred-base.cod-mov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.cod-mov wMaintenanceNoNavigation
ON F5 OF tt-colab-deb-cred-base.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    {include/zoomvar.i &prog-zoom="eszoom/z01es272"
                       &campo="tt-colab-deb-cred-base.cod-mov"
                       &campozoom="cod-mov"
                       &frame="fPage0"
                       &campo2="c-desc-mov"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.cod-mov wMaintenanceNoNavigation
ON LEAVE OF tt-colab-deb-cred-base.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    ASSIGN INPUT FRAME fPage0 tt-colab-deb-cred-base.cod-mov.

    FIND FIRST mov-comis NO-LOCK
        WHERE  mov-comis.cod-mov = tt-colab-deb-cred-base.cod-mov NO-ERROR.

    ASSIGN c-desc-mov = IF AVAIL mov-comis THEN mov-comis.descricao ELSE "".

    DISPLAY c-desc-mov
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.cod-mov wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-colab-deb-cred-base.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-deb-cred-base.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.fm-cod-com wMaintenanceNoNavigation
ON F5 OF tt-colab-deb-cred-base.fm-cod-com IN FRAME fPage0 /* Fam°lia Comercial */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z01di050.w"
                       &campo="tt-colab-deb-cred-base.fm-cod-com"
                       &campozoom="fm-cod-com"
                       &frame="fPage0"
                       &campo2="c-desc-fam"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.fm-cod-com wMaintenanceNoNavigation
ON LEAVE OF tt-colab-deb-cred-base.fm-cod-com IN FRAME fPage0 /* Fam°lia Comercial */
DO:
    ASSIGN INPUT FRAME fPage0 tt-colab-deb-cred-base.fm-cod-com.

    FIND FIRST fam-comerc NO-LOCK
        WHERE  fam-comerc.fm-cod-com = tt-colab-deb-cred-base.fm-cod-com NO-ERROR.

    ASSIGN c-desc-fam = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE "".

    DISPLAY c-desc-fam
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-base.fm-cod-com wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-colab-deb-cred-base.fm-cod-com IN FRAME fPage0 /* Fam°lia Comercial */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
tt-colab-deb-cred-base.fm-cod-com:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-colab-deb-cred-base.cod-mov:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0.

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  pcAction = "Add" THEN DO:
        ASSIGN tt-colab-deb-cred-base.dt-movto = TODAY.

        DISPLAY tt-colab-deb-cred-base.dt-movto
            WITH FRAME fPage0.
    END.

    DISPLAY text-1
        WITH FRAME fPage0.

    APPLY "LEAVE" TO tt-colab-deb-cred-base.fm-cod-com IN FRAME fPage0.
    APPLY "LEAVE" TO tt-colab-deb-cred-base.cod-mov    IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN {&ttTable}.cod-rep = {&ttParent}.cod-rep.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

