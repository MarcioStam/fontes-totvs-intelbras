&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-rateio NO-UNDO LIKE int-rateio
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
{include/i-prgvrs.i esfgl054a 2.00.00.000}  /*** 010000 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           esfgl005a
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttint-rateio
&GLOBAL-DEFINE hDBOTable         boes908
&GLOBAL-DEFINE DBOTable          int-rateio

&GLOBAL-DEFINE page0KeyFields    ttint-rateio.tipo-rateio ttint-rateio.cod-estabel 
                                     
&GLOBAL-DEFINE page0Fields       ttint-rateio.tipo-rateio fi-desc cb-mes cb-mes ttint-rateio.cod-estabel

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.


/* mgesp Variable Definitions ---                                       */

/* mgesp Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR g-inclusao   AS LOGICAL NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-rateio.tipo-rateio ~
ttint-rateio.cod-estabel 
&Scoped-define ENABLED-TABLES ttint-rateio
&Scoped-define FIRST-ENABLED-TABLE ttint-rateio
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fi-desc cb-mes cb-ano ~
fi-desc-estabel btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-rateio.tipo-rateio ~
ttint-rateio.cod-estabel 
&Scoped-define DISPLAYED-TABLES ttint-rateio
&Scoped-define FIRST-DISPLAYED-TABLE ttint-rateio
&Scoped-Define DISPLAYED-OBJECTS fi-desc cb-mes cb-ano fi-desc-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U INITIAL "01" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 5.57 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-rateio.tipo-rateio AT ROW 1.5 COL 16 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-desc AT ROW 1.5 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     cb-mes AT ROW 2.83 COL 16.14 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     cb-ano AT ROW 2.83 COL 22.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     ttint-rateio.cod-estabel AT ROW 4.21 COL 16.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .79
     fi-desc-estabel AT ROW 4.21 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     btOK AT ROW 6.38 COL 2
     btSave AT ROW 6.38 COL 13
     btCancel AT ROW 6.38 COL 24
     btHelp AT ROW 6.38 COL 80
     "Competˆncia:" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 2.96 COL 8.29 WIDGET-ID 60
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 6.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 6.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-rateio T "?" NO-UNDO mgesp int-rateio
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
         HEIGHT             = 6.71
         WIDTH              = 90.14
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
ASSIGN 
       fi-desc:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       fi-desc-estabel:READ-ONLY IN FRAME fpage0        = TRUE.

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

    ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-rateio.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.cod-estabel wMaintenanceNoNavigation
ON F5 OF ttint-rateio.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=ttint-rateio.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF ttint-rateio.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = ttint-rateio.cod-estabel:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.

    IF  AVAIL estabelec THEN
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fpage0 = estabelec.nome.
    ELSE
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttint-rateio.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-rateio.tipo-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.tipo-rateio wMaintenanceNoNavigation
ON F5 OF ttint-rateio.tipo-rateio IN FRAME fpage0 /* Tipo Rateio */
DO:
/*     assign l-implanta = NO.                              */
/*                                                          */
/*     /*                                                   */
/*     {include/zoomvar.i &prog-zoom=eszoom/z01esfgl004.w   */
/*                        &campo=ttint-rateio.tipo-rateio   */
/*                        &campozoom=tipo-rateio}           */
/*     */                                                   */
/*     {include/zoomvar.i &prog-zoom="eszoom/z01esfgl004.w" */
/*                      &campo="ttint-rateio.tipo-rateio"   */
/*                      &campozoom="tipo-rateio"            */
/*                      &frame="fpage0"}                    */
/*                                                          */
    
    RUN eszoom/z01esfgl004.w PERSISTENT SET hProgramZoom.

    {method/zoomfields.i &ProgramZoom="eszoom/z01esfgl004.w"
                         &FieldZoom1="tipo-rateio"
                         &FieldScreen1="ttint-rateio.tipo-rateio"
                         &Frame1="fPage0"
                         &enableImplant="NO"}
                     
    WAIT-FOR "CLOSE" OF hProgramZoom.

    IF  VALID-HANDLE(hProgramZoom) THEN
        DELETE PROCEDURE hProgramZoom.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.tipo-rateio wMaintenanceNoNavigation
ON LEAVE OF ttint-rateio.tipo-rateio IN FRAME fpage0 /* Tipo Rateio */
DO:
  
    FIND FIRST int-rat-desp NO-LOCK
        WHERE int-rat-desp.tipo-rateio = int(ttint-rateio.tipo-rateio:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.

    IF  AVAIL int-rat-desp THEN 
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = int-rat-desp.descricao.
    ELSE
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio.tipo-rateio wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttint-rateio.tipo-rateio IN FRAME fpage0 /* Tipo Rateio */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

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


    
    DO WITH FRAME fPage0:
        ttint-rateio.tipo-rateio:LOAD-MOUSE-POINTER('image/lupa.cur':U).
        ttint-rateio.cod-estabel:LOAD-MOUSE-POINTER('image/lupa.cur':U).
    END.

    ASSIGN ttint-rateio.tipo-rateio:SENSITIVE IN FRAME fPage0 = YES
           fi-desc:SENSITIVE IN FRAME fPage0                  = NO
           cb-mes:SENSITIVE IN FRAME fPage0                   = YES
           cb-ano:SENSITIVE IN FRAME fPage0                   = YES
           ttint-rateio.cod-estabel:SENSITIVE IN FRAME fPage0 = YES.


    ASSIGN cb-mes:SCREEN-VALUE IN FRAME fpage0 = STRING(MONTH(TODAY), "99")
           cb-ano:SCREEN-VALUE IN FRAME fpage0 = STRING(YEAR(TODAY), "9999").
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*      /*--- Verifica se o DBO ja esta inicializado ---*/       */
/*     IF NOT VALID-HANDLE(boes908) OR                           */
/*        boes908:TYPE <> "PROCEDURE":U OR                       */
/*        boes908:FILE-NAME <> "esbo/boes908.p":U THEN DO:       */
/*         {btb/btb008za.i1 esbo/boes908.p YES}                  */
/*         {btb/btb008za.i2 esbo/boes908.p '' boes908}           */
/*     END.                                                      */
/*     RUN openQueryStatic IN boes908 (INPUT "Main":U) NO-ERROR. */

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-tipo-rateio wMaintenanceNoNavigation 
PROCEDURE pi-leave-tipo-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST int-rat-desp NO-LOCK
        WHERE int-rat-desp.tipo-rateio = INPUT FRAME fpage0 ttint-rateio.tipo-rateio NO-ERROR.

    IF  AVAIL int-rat-desp THEN
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = int-rat-desp.descricao.
    ELSE
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    ASSIGN ttint-rateio.id-contabilizado = NO
           ttint-rateio.competencia = cb-ano:SCREEN-VALUE IN FRAME fpage0 + cb-mes:SCREEN-VALUE IN FRAME fpage0
           ttint-rateio.id-status   = 1.
            
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

