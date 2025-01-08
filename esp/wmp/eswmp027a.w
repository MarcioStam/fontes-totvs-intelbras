&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          intelbras        PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-zona-separa NO-UNDO LIKE zona-separa
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
{include/i-prgvrs.i ESWMP027A 2.00.00.001}
{include/i-license-manager.i ESWMP027 MCD,MCE,MEQ,MFT,MPD,MRE,MWM}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESWMP027A
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE ttTable           tt-zona-separa
&GLOBAL-DEFINE hDBOTable         h-boes027
&GLOBAL-DEFINE DBOTable          zona-separa

&GLOBAL-DEFINE page0KeyFields    tt-zona-separa.cod-estabel tt-zona-separa.cod-local tt-zona-separa.cod-zona
&GLOBAL-DEFINE page0Fields       tt-zona-separa.descricao tt-zona-separa.seq-separa

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-FIELDS tt-zona-separa.cod-estabel ~
tt-zona-separa.cod-local tt-zona-separa.cod-zona tt-zona-separa.descricao ~
tt-zona-separa.seq-separa 
&Scoped-define ENABLED-TABLES tt-zona-separa
&Scoped-define FIRST-ENABLED-TABLE tt-zona-separa
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-desc-estabel c-desc-local ~
btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-zona-separa.cod-estabel ~
tt-zona-separa.cod-local tt-zona-separa.cod-zona tt-zona-separa.descricao ~
tt-zona-separa.seq-separa 
&Scoped-define DISPLAYED-TABLES tt-zona-separa
&Scoped-define FIRST-DISPLAYED-TABLE tt-zona-separa
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-local 

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

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-zona-separa.cod-estabel AT ROW 1.25 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-estabel AT ROW 1.25 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     tt-zona-separa.cod-local AT ROW 2.25 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-local AT ROW 2.25 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tt-zona-separa.cod-zona AT ROW 3.25 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-zona-separa.descricao AT ROW 3.25 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     tt-zona-separa.seq-separa AT ROW 4.75 COL 19 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     btOK AT ROW 6.5 COL 2
     btSave AT ROW 6.5 COL 13
     btCancel AT ROW 6.5 COL 24
     btHelp AT ROW 6.5 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 6.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-zona-separa T "?" NO-UNDO intelbras zona-separa
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
         HEIGHT             = 6.67
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
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-zona-separa.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-zona-separa.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                         &FieldZoom1="cod-local"
                         &FieldScreen1="tt-zona-separa.cod-local"
                         &frame1="fPage0"
                         &FieldZoom2="nom-local"
                         &FieldScreen2="c-desc-local"
                         &frame2="fPage0"
                         &FieldZoom3="cod-estabel"
                         &FieldScreen3="tt-zona-separa.cod-estab"
                         &frame3="fPage0"
                         &FieldZoom4="nom-estabel"
                         &FieldScreen4="c-desc-estabel"
                         &frame4="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-zona-separa.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN c-desc-estabel = "".
    FOR FIRST wm-estabel NO-LOCK
        WHERE wm-estabel.cod-estabel = SELF:SCREEN-VALUE:
        ASSIGN c-desc-estabel = wm-estabel.nom-estabel.
    END.
    DISP c-desc-estabel WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-zona-separa.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-zona-separa.cod-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-local wMaintenanceNoNavigation
ON F5 OF tt-zona-separa.cod-local IN FRAME fpage0 /* Local */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                         &FieldZoom1="cod-local"
                         &FieldScreen1="tt-zona-separa.cod-local"
                         &frame1="fPage0"
                         &FieldZoom2="nom-local"
                         &FieldScreen2="c-desc-local"
                         &frame2="fPage0"
                         &FieldZoom3="cod-estabel"
                         &FieldScreen3="tt-zona-separa.cod-estab"
                         &frame3="fPage0"
                         &FieldZoom4="nom-estabel"
                         &FieldScreen4="c-desc-estabel"
                         &frame4="fPage0"
                         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-local wMaintenanceNoNavigation
ON LEAVE OF tt-zona-separa.cod-local IN FRAME fpage0 /* Local */
DO:
    ASSIGN c-desc-local = "".
    FOR FIRST wm-local NO-LOCK
        WHERE wm-local.cod-estabel = tt-zona-separa.cod-estabel:SCREEN-VALUE IN FRAME fPage0
          AND wm-local.cod-local   = SELF:SCREEN-VALUE:
        ASSIGN c-desc-local = wm-local.nom-local.
    END.
    DISP c-desc-local WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-zona-separa.cod-local wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-zona-separa.cod-local IN FRAME fpage0 /* Local */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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
    
    tt-zona-separa.cod-estabel:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.
    tt-zona-separa.cod-local:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.


    RETURN "OK".
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

