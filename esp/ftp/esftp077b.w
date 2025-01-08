&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-canhoto NO-UNDO LIKE canhoto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-canhoto-nf NO-UNDO LIKE canhoto-nf
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP077B 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESFTP077B
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO

&GLOBAL-DEFINE ttTable           tt-canhoto-nf
&GLOBAL-DEFINE hDBOTable         h-esbo559
&GLOBAL-DEFINE DBOTable          canhoto-nf

&GLOBAL-DEFINE ttParent          tt-canhoto
&GLOBAL-DEFINE DBOParentTable    canhoto

&GLOBAL-DEFINE page0KeyFields    tt-canhoto-nf.cod-estabel  ~
                                 tt-canhoto-nf.serie        ~
                                 tt-canhoto-nf.nr-nota-fis
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-canhoto.cod-transp   ~
                                 tt-canhoto.cod-caixa    ~
                                 tt-canhoto.cod-envelope ~


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
&Scoped-Define ENABLED-FIELDS tt-canhoto.cod-transp tt-canhoto.cod-caixa ~
tt-canhoto.cod-envelope tt-canhoto-nf.cod-estabel tt-canhoto-nf.serie ~
tt-canhoto-nf.nr-nota-fis 
&Scoped-define ENABLED-TABLES tt-canhoto tt-canhoto-nf
&Scoped-define FIRST-ENABLED-TABLE tt-canhoto
&Scoped-define SECOND-ENABLED-TABLE tt-canhoto-nf
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtNotas c-nome-transp ~
c-cod-barra c-nome-estabel btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-canhoto.cod-transp tt-canhoto.cod-caixa ~
tt-canhoto.cod-envelope tt-canhoto-nf.cod-estabel tt-canhoto-nf.serie ~
tt-canhoto-nf.nr-nota-fis 
&Scoped-define DISPLAYED-TABLES tt-canhoto tt-canhoto-nf
&Scoped-define FIRST-DISPLAYED-TABLE tt-canhoto
&Scoped-define SECOND-DISPLAYED-TABLE tt-canhoto-nf
&Scoped-Define DISPLAYED-OBJECTS c-nome-transp c-cod-barra c-nome-estabel 

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

DEFINE VARIABLE c-cod-barra AS CHARACTER FORMAT "X(20)":U 
     LABEL "C¢digo de Barras" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 58.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 58.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtNotas
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-canhoto.cod-transp AT ROW 1.17 COL 19 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-nome-transp AT ROW 1.17 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-canhoto.cod-caixa AT ROW 2.17 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-canhoto.cod-envelope AT ROW 3.17 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-cod-barra AT ROW 4.63 COL 19 COLON-ALIGNED WIDGET-ID 14 AUTO-RETURN 
     c-nome-estabel AT ROW 5.58 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-canhoto-nf.cod-estabel AT ROW 5.63 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-canhoto-nf.serie AT ROW 6.63 COL 19 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-canhoto-nf.nr-nota-fis AT ROW 7.63 COL 19 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     btOK AT ROW 9.08 COL 2
     btSave AT ROW 9.08 COL 13
     btCancel AT ROW 9.08 COL 24
     btHelp AT ROW 9.08 COL 80 WIDGET-ID 18
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 8.83 COL 1
     rtNotas AT ROW 4.42 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-canhoto T "?" NO-UNDO mgesp canhoto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-canhoto-nf T "?" NO-UNDO mgesp canhoto-nf
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
         HEIGHT             = 9.21
         WIDTH              = 90
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.33
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


&Scoped-define SELF-NAME c-cod-barra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-barra wMaintenanceNoNavigation
ON RETURN OF c-cod-barra IN FRAME fpage0 /* C¢digo de Barras */
DO:
    ASSIGN INPUT FRAME fPage0 c-cod-barra.

    IF  c-cod-barra = "" THEN
        RETURN "NOK":U.

    ASSIGN tt-canhoto-nf.cod-estabel = SUBSTRING(c-cod-barra,1,3)
           tt-canhoto-nf.serie       = SUBSTRING(c-cod-barra,4,1)
           tt-canhoto-nf.nr-nota-fis = SUBSTRING(c-cod-barra,5,7).

    DISPLAY tt-canhoto-nf.cod-estabel
            tt-canhoto-nf.serie
            tt-canhoto-nf.nr-nota-fis
        WITH FRAME fPage0.

    APPLY "CHOOSE" TO btSave IN FRAME fPage0.

    ASSIGN c-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-canhoto-nf.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto-nf.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-canhoto-nf.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-canhoto-nf.cod-estabel"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="c-nome-estabel"
                         &Frame2="fPage0"
                         &enableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto-nf.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-canhoto-nf.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN INPUT FRAME fPage0 tt-canhoto-nf.cod-estabel.

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = tt-canhoto-nf.cod-estabel NO-ERROR.

    ASSIGN c-nome-estabel = IF AVAIL estabelec THEN estabelec.nome ELSE "".

    DISPLAY c-nome-estabel WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto-nf.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-canhoto-nf.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-canhoto.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto.cod-transp wMaintenanceNoNavigation
ON F5 OF tt-canhoto.cod-transp IN FRAME fpage0 /* Transportador */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z02ad268.w"
                         &FieldZoom1="cod-transp"
                         &FieldScreen1="tt-canhoto.cod-transp"
                         &Frame1="fPage0"
                         &FieldZoom2="nome-abrev"
                         &FieldScreen2="c-nome-transp"
                         &Frame2="fPage0"
                         &enableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto.cod-transp wMaintenanceNoNavigation
ON LEAVE OF tt-canhoto.cod-transp IN FRAME fpage0 /* Transportador */
DO:
    ASSIGN INPUT FRAME fPage0 tt-canhoto.cod-transp.

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = tt-canhoto.cod-transp NO-ERROR.

    ASSIGN c-nome-transp = IF AVAIL transporte THEN transporte.nome ELSE "".

    DISPLAY c-nome-transp WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-canhoto.cod-transp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-canhoto.cod-transp IN FRAME fpage0 /* Transportador */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


tt-canhoto.cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage0.
tt-canhoto-nf.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

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

    APPLY "LEAVE":U TO tt-canhoto.cod-transp     IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-canhoto-nf.cod-estabel IN FRAME fPage0.

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
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN {&ttTable}.cod-transp   = {&ttParent}.cod-transp
           {&ttTable}.cod-caixa    = {&ttParent}.cod-caixa
           {&ttTable}.cod-envelope = {&ttParent}.cod-envelope.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

