&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-zona-separa NO-UNDO LIKE zona-separa
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-zona-separa-box NO-UNDO LIKE zona-separa-box
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
{include/i-prgvrs.i ESWMP027B 2.00.00.001}
{include/i-license-manager.i ESWMP027 MCD,MCE,MEQ,MFT,MPD,MRE,MWM}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESMW0027B
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE ttTable           tt-zona-separa-box
&GLOBAL-DEFINE hDBOTable         h-boes029
&GLOBAL-DEFINE DBOTable          zona-separa-box

&GLOBAL-DEFINE ttParent          tt-zona-separa
&GLOBAL-DEFINE DBOParentTable    h-boes027

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-zona-separa.cod-estabel tt-zona-separa.cod-local tt-zona-separa.cod-zona tt-zona-separa.descricao
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

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
tt-zona-separa.cod-local tt-zona-separa.cod-zona tt-zona-separa.descricao 
&Scoped-define ENABLED-TABLES tt-zona-separa
&Scoped-define FIRST-ENABLED-TABLE tt-zona-separa
&Scoped-Define ENABLED-OBJECTS rtKeys IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 RECT-3 rtToolBar IMAGE-9 IMAGE-10 ~
c-desc-estabel c-desc-local i-id-box-ini i-id-box-fim c-cod-bloco-ini ~
c-cod-bloco-fim c-cod-rua-ini c-cod-rua-fim c-cod-nivel-ini c-cod-nivel-fim ~
c-cod-coluna-ini c-cod-coluna-fim btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-zona-separa.cod-estabel ~
tt-zona-separa.cod-local tt-zona-separa.cod-zona tt-zona-separa.descricao 
&Scoped-define DISPLAYED-TABLES tt-zona-separa
&Scoped-define FIRST-DISPLAYED-TABLE tt-zona-separa
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-local i-id-box-ini ~
i-id-box-fim c-cod-bloco-ini c-cod-bloco-fim c-cod-rua-ini c-cod-rua-fim ~
c-cod-nivel-ini c-cod-nivel-fim c-cod-coluna-ini c-cod-coluna-fim 

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

DEFINE VARIABLE c-cod-bloco-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-bloco-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Bloco" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-coluna-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-coluna-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Coluna" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-nivel-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-nivel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "N¡vel" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-rua-fim AS CHARACTER FORMAT "x(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-rua-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Rua" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE i-id-box-fim AS DECIMAL FORMAT ">>>>>>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-id-box-ini AS DECIMAL FORMAT ">>>>>>>>>9" INITIAL 0 
     LABEL "ID Endere‡o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.83.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-zona-separa.cod-estabel AT ROW 1.25 COL 22 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-estabel AT ROW 1.25 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     tt-zona-separa.cod-local AT ROW 2.25 COL 22 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-local AT ROW 2.25 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     tt-zona-separa.cod-zona AT ROW 3.25 COL 22 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-zona-separa.descricao AT ROW 3.25 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     i-id-box-ini AT ROW 6 COL 25 COLON-ALIGNED WIDGET-ID 68
     i-id-box-fim AT ROW 6 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     c-cod-bloco-ini AT ROW 7 COL 29 COLON-ALIGNED WIDGET-ID 12
     c-cod-bloco-fim AT ROW 7 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-cod-rua-ini AT ROW 8 COL 29 COLON-ALIGNED WIDGET-ID 24
     c-cod-rua-fim AT ROW 8 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-cod-nivel-ini AT ROW 9 COL 29 COLON-ALIGNED WIDGET-ID 20
     c-cod-nivel-fim AT ROW 9 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     c-cod-coluna-ini AT ROW 10 COL 29 COLON-ALIGNED WIDGET-ID 16
     c-cod-coluna-fim AT ROW 10 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     btOK AT ROW 12.21 COL 2
     btSave AT ROW 12.21 COL 13 WIDGET-ID 60
     btCancel AT ROW 12.21 COL 24 WIDGET-ID 58
     btHelp AT ROW 12.25 COL 80 WIDGET-ID 62
     "Faixa" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 5.25 COL 2.43 WIDGET-ID 44
     rtKeys AT ROW 1 COL 1
     IMAGE-1 AT ROW 7 COL 38.29 WIDGET-ID 26
     IMAGE-2 AT ROW 7 COL 48.29 WIDGET-ID 28
     IMAGE-3 AT ROW 8 COL 38.29 WIDGET-ID 30
     IMAGE-4 AT ROW 8 COL 48.29 WIDGET-ID 32
     IMAGE-5 AT ROW 9.04 COL 38.29 WIDGET-ID 34
     IMAGE-6 AT ROW 9.04 COL 48.29 WIDGET-ID 36
     IMAGE-7 AT ROW 10.04 COL 38.29 WIDGET-ID 38
     IMAGE-8 AT ROW 10.04 COL 48.29 WIDGET-ID 40
     RECT-3 AT ROW 5.42 COL 1 WIDGET-ID 42
     rtToolBar AT ROW 12 COL 1 WIDGET-ID 64
     IMAGE-9 AT ROW 6 COL 38.29 WIDGET-ID 70
     IMAGE-10 AT ROW 6 COL 48.29 WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.5
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
      TABLE: tt-zona-separa-box T "?" NO-UNDO intelbras zona-separa-box
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
         HEIGHT             = 12.5
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 121.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 121.14
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
    RUN geraRegistros.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN geraRegistros IN THIS-PROCEDURE.
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

DEFINE TEMP-TABLE RowerrorsAux NO-UNDO LIKE RowErrors.

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
    
    APPLY "LEAVE" TO tt-zona-separa.cod-estabel IN FRAME fPage0.
    APPLY "LEAVE" TO tt-zona-separa.cod-local IN FRAME fPage0.

    ASSIGN c-cod-bloco-fim  = "ZZZ"
           c-cod-rua-fim    = "ZZZ"
           c-cod-nivel-fim  = "ZZZ"
           c-cod-coluna-fim = "ZZZ"
           i-id-box-fim     = 9999999999.

    DISP i-id-box-fim
         c-cod-bloco-fim 
         c-cod-rua-fim   
         c-cod-nivel-fim 
         c-cod-coluna-fim
        WITH FRAME fPage0.

    ENABLE i-id-box-ini i-id-box-fim
        c-cod-bloco-ini c-cod-bloco-fim
        c-cod-rua-ini c-cod-rua-fim
        c-cod-nivel-ini c-cod-nivel-fim
        c-cod-coluna-ini c-cod-coluna-fim WITH FRAME fPage0.

    APPLY "ENTRY" TO i-id-box-ini IN FRAME fPage0.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraRegistros wMaintenanceNoNavigation 
PROCEDURE geraRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-desc-box AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 i-id-box-ini i-id-box-fim
        c-cod-bloco-ini c-cod-bloco-fim
        c-cod-rua-ini c-cod-rua-fim
        c-cod-nivel-ini c-cod-nivel-fim
        c-cod-coluna-ini c-cod-coluna-fim.

    EMPTY TEMP-TABLE RowErrors.

    SESSION:SET-WAIT-STATE('general').

    bloco:
    DO TRANS ON ERROR UNDO bloco, LEAVE bloco:

        FOR EACH wm-box NO-LOCK
            WHERE wm-box.cod-estabel = tt-zona-separa.cod-estabel
              AND wm-box.cod-local   = tt-zona-separa.cod-local
              AND wm-box.id-box     >= i-id-box-ini
              AND wm-box.id-box     <= i-id-box-fim
              AND wm-box.cod-bloco  >= c-cod-bloco-ini
              AND wm-box.cod-bloco  <= c-cod-bloco-fim
              AND wm-box.cod-rua    >= c-cod-rua-ini
              AND wm-box.cod-rua    <= c-cod-rua-fim
              AND wm-box.cod-nivel  >= c-cod-nivel-ini
              AND wm-box.cod-nivel  <= c-cod-nivel-fim
              AND wm-box.cod-coluna >= c-cod-coluna-ini
              AND wm-box.cod-coluna <= c-cod-coluna-fim,
            FIRST wm-tipo-box FIELDS()
                WHERE wm-tipo-box.cdn-tipo-box   = wm-box.cdn-tipo-box
                  AND wm-tipo-box.ind-status-box = 4 /*PICKING*/ NO-LOCK:

            IF CAN-FIND(FIRST zona-separa-box NO-LOCK
                        WHERE zona-separa-box.cod-estabel = tt-zona-separa.cod-estabel
                          AND zona-separa-box.cod-local   = tt-zona-separa.cod-local
                          AND zona-separa-box.cod-zona    = tt-zona-separa.cod-zona
                          AND zona-separa-box.id-box      = wm-box.id-box) THEN
                NEXT.

            EMPTY TEMP-TABLE RowErrorsAux.
            EMPTY TEMP-TABLE tt-zona-separa-box.

            ASSIGN c-desc-box = wm-box.cod-bloco + "/" + wm-box.cod-rua + "/" + wm-box.cod-nivel + "/" + wm-box.cod-coluna.
            CREATE tt-zona-separa-box.
            ASSIGN tt-zona-separa-box.cod-estabel = tt-zona-separa.cod-estabel
                   tt-zona-separa-box.cod-local   = tt-zona-separa.cod-local
                   tt-zona-separa-box.cod-zona    = tt-zona-separa.cod-zona
                   tt-zona-separa-box.id-box      = wm-box.id-box.

            RUN emptyRowErrors IN {&hDBOTable}.
            RUN setRecord IN {&hDBOTable} (INPUT TABLE tt-zona-separa-box).
            RUN createRecord IN {&hDBOTable}.
            RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrorsAux).
            IF CAN-FIND(FIRST RowErrorsAux
                        WHERE RowErrorsAux.errorSubType = "ERROR") THEN DO:
                FOR EACH RowErrorsAux:
                    CREATE RowErrors.
                    BUFFER-COPY RowErrorsAux TO RowErrors
                        ASSIGN RowErrors.errorDescription = c-desc-box + ":" + RowErrorsAux.errorDescription.
                END.
            END.
        END.

        IF CAN-FIND(FIRST RowErrors) THEN
            UNDO bloco, LEAVE bloco.
    END.

    SESSION:SET-WAIT-STATE('').

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="Yes"}
        RETURN "NOK".
    END.
    ELSE DO:
        RUN esp/wmp/eswmp027api.p (INPUT tt-zona-separa.cod-estabel,
                                   INPUT tt-zona-separa.cod-local,
                                   INPUT tt-zona-separa.cod-zona).
    END.

    RUN repositionRecord IN phCaller (INPUT prParent).

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

