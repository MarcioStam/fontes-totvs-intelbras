&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgintelbras      PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-estabel-origem-ressup NO-UNDO LIKE int-estabel-origem-ressup
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-int-estabel-ressuprimento NO-UNDO LIKE int-estabel-ressuprimento
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           escep087a
&GLOBAL-DEFINE Version           3.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable        tt-int-estabel-origem-ressup
&GLOBAL-DEFINE hDBOTable      hesbo927
&GLOBAL-DEFINE DBOTable       int-estabel-origem-ressup

&GLOBAL-DEFINE ttParent       tt-int-estabel-ressuprimento
&GLOBAL-DEFINE DBOParentTable int-estabel-ressuprimento

&GLOBAL-DEFINE page0KeyFields tt-int-estabel-origem-ressup.cod-estabel-origem tt-int-estabel-origem-ressup.cod-depos-origem
&GLOBAL-DEFINE page0Fields    num-lead-time log-dia-util cod-depos-cdi

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOWm-estabel  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOWm-deposito AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ~
tt-int-estabel-origem-ressup.cod-estabel-ressup ~
tt-int-estabel-origem-ressup.cod-depos-ressup ~
tt-int-estabel-origem-ressup.cod-estabel-origem ~
tt-int-estabel-origem-ressup.cod-depos-origem ~
tt-int-estabel-origem-ressup.cod-depos-cdi ~
tt-int-estabel-origem-ressup.num-lead-time ~
tt-int-estabel-origem-ressup.log-dia-util 
&Scoped-define ENABLED-TABLES tt-int-estabel-origem-ressup
&Scoped-define FIRST-ENABLED-TABLE tt-int-estabel-origem-ressup
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-1 btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS ~
tt-int-estabel-origem-ressup.cod-estabel-ressup ~
tt-int-estabel-origem-ressup.cod-depos-ressup ~
tt-int-estabel-origem-ressup.cod-estabel-origem ~
tt-int-estabel-origem-ressup.cod-depos-origem ~
tt-int-estabel-origem-ressup.cod-depos-cdi ~
tt-int-estabel-origem-ressup.num-lead-time ~
tt-int-estabel-origem-ressup.log-dia-util 
&Scoped-define DISPLAYED-TABLES tt-int-estabel-origem-ressup
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-estabel-origem-ressup
&Scoped-Define DISPLAYED-OBJECTS c-des-estabel-ressup c-des-deposito-ressup ~
c-des-estabel-origem c-des-deposito-origem c-des-deposito-cdn 

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

DEFINE VARIABLE c-des-deposito-cdn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-deposito-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-deposito-ressup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-estabel-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-estabel-ressup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-int-estabel-origem-ressup.cod-estabel-ressup AT ROW 1.25 COL 25 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-estabel-ressup AT ROW 1.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-int-estabel-origem-ressup.cod-depos-ressup AT ROW 2.25 COL 25 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-deposito-ressup AT ROW 2.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-int-estabel-origem-ressup.cod-estabel-origem AT ROW 3.25 COL 25 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-estabel-origem AT ROW 3.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-int-estabel-origem-ressup.cod-depos-origem AT ROW 4.25 COL 25 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-deposito-origem AT ROW 4.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-int-estabel-origem-ressup.cod-depos-cdi AT ROW 5.75 COL 25 COLON-ALIGNED WIDGET-ID 32
          LABEL "Dep¢sito CDI"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-deposito-cdn AT ROW 5.75 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-int-estabel-origem-ressup.num-lead-time AT ROW 6.75 COL 25 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-int-estabel-origem-ressup.log-dia-util AT ROW 6.75 COL 64 WIDGET-ID 30
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     btOK AT ROW 8.25 COL 2
     btSave AT ROW 8.25 COL 13
     btCancel AT ROW 8.25 COL 24
     btHelp AT ROW 8.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 8 COL 1
     RECT-1 AT ROW 5.5 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 8.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-estabel-origem-ressup T "?" NO-UNDO mgintelbras int-estabel-origem-ressup
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-int-estabel-ressuprimento T "?" NO-UNDO mgintelbras int-estabel-ressuprimento
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 8.5
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 109.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 109.43
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
/* SETTINGS FOR FILL-IN c-des-deposito-cdn IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-deposito-origem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-deposito-ressup IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-estabel-origem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-estabel-ressup IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-estabel-origem-ressup.cod-depos-cdi IN FRAME fpage0
   EXP-LABEL                                                            */
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

    IF RETURN-VALUE = "OK":U THEN DO:
        //RUN atualizaBrowserFilho IN phCaller.   
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.    

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


&Scoped-define SELF-NAME tt-int-estabel-origem-ressup.cod-depos-cdi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-cdi wMaintenanceNoNavigation
ON F5 OF tt-int-estabel-origem-ressup.cod-depos-cdi IN FRAME fpage0 /* Dep¢sito CDI */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc037.w"
                         &FieldZoom1="cod-deposito"
                         &FieldScreen1="tt-int-estabel-origem-ressup.cod-depos-cdi"
                         &Frame1="fpage0"
                         &FieldZoom2="des-deposito"
                         &FieldScreen2="c-des-deposito-cdn"
                         &Frame2="fpage0"
                         &RunMethod=" "
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-cdi wMaintenanceNoNavigation
ON LEAVE OF tt-int-estabel-origem-ressup.cod-depos-cdi IN FRAME fpage0 /* Dep¢sito CDI */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="hDBOWm-deposito"
      &KeyValue1="tt-int-estabel-origem-ressup.cod-depos-cdi:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="des-deposito"
      &FieldScreen1="c-des-deposito-cdn"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-cdi wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-estabel-origem-ressup.cod-depos-cdi IN FRAME fpage0 /* Dep¢sito CDI */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-estabel-origem-ressup.cod-depos-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-origem wMaintenanceNoNavigation
ON F5 OF tt-int-estabel-origem-ressup.cod-depos-origem IN FRAME fpage0 /* Dep¢sito Origem Ressuprimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc037.w"
                         &FieldZoom1="cod-deposito"
                         &FieldScreen1="tt-int-estabel-origem-ressup.cod-depos-origem"
                         &Frame1="fpage0"
                         &FieldZoom2="des-deposito"
                         &FieldScreen2="c-des-deposito-origem"
                         &Frame2="fpage0"
                         &RunMethod=" "
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-origem wMaintenanceNoNavigation
ON LEAVE OF tt-int-estabel-origem-ressup.cod-depos-origem IN FRAME fpage0 /* Dep¢sito Origem Ressuprimento */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="hDBOWm-deposito"
      &KeyValue1="tt-int-estabel-origem-ressup.cod-depos-origem:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="des-deposito"
      &FieldScreen1="c-des-deposito-origem"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-origem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-estabel-origem-ressup.cod-depos-origem IN FRAME fpage0 /* Dep¢sito Origem Ressuprimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-estabel-origem-ressup.cod-depos-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-ressup wMaintenanceNoNavigation
ON F5 OF tt-int-estabel-origem-ressup.cod-depos-ressup IN FRAME fpage0 /* Dep¢sito Ressuprimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc037.w"
                         &FieldZoom1="cod-deposito"
                         &FieldScreen1="tt-int-estabel-origem-ressup.cod-depos-ressup"
                         &Frame1="fpage0"
                         &FieldZoom2="des-deposito"
                         &FieldScreen2="c-des-deposito-ressup"
                         &Frame2="fpage0"
                         &RunMethod=" "
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-ressup wMaintenanceNoNavigation
ON LEAVE OF tt-int-estabel-origem-ressup.cod-depos-ressup IN FRAME fpage0 /* Dep¢sito Ressuprimento */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="hDBOWm-deposito"
      &KeyValue1="tt-int-estabel-origem-ressup.cod-depos-ressup:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="des-deposito"
      &FieldScreen1="c-des-deposito-ressup"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-depos-ressup wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-estabel-origem-ressup.cod-depos-ressup IN FRAME fpage0 /* Dep¢sito Ressuprimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-estabel-origem-ressup.cod-estabel-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-origem wMaintenanceNoNavigation
ON F5 OF tt-int-estabel-origem-ressup.cod-estabel-origem IN FRAME fpage0 /* Estabel Origem Ressuprimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-int-estabel-origem-ressup.cod-estabel-origem"
                         &Frame1="fpage0"
                         &FieldZoom2="nom-estabel"
                         &FieldScreen2="c-des-estabel-origem"
                         &Frame2="fpage0"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-estabel (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-origem wMaintenanceNoNavigation
ON LEAVE OF tt-int-estabel-origem-ressup.cod-estabel-origem IN FRAME fpage0 /* Estabel Origem Ressuprimento */
DO:
    ASSIGN tt-int-estabel-origem-ressup.cod-estabel-origem:SCREEN-VALUE IN FRAME fPage0 = UPPER(tt-int-estabel-origem-ressup.cod-estabel-origem:SCREEN-VALUE IN FRAME fPage0).
    {method/referencefields.i &HandleDBOLeave="hDBOWm-estabel"
                              &KeyValue1="tt-int-estabel-origem-ressup.cod-estabel-origem:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="nom-estabel"
                              &FieldScreen1="c-des-estabel-origem"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-origem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-estabel-origem-ressup.cod-estabel-origem IN FRAME fpage0 /* Estabel Origem Ressuprimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-estabel-origem-ressup.cod-estabel-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-ressup wMaintenanceNoNavigation
ON F5 OF tt-int-estabel-origem-ressup.cod-estabel-ressup IN FRAME fpage0 /* Estabel Ressuprimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-int-estabel-origem-ressup.cod-estabel-ressup"
                         &Frame1="fpage0"
                         &FieldZoom2="nom-estabel"
                         &FieldScreen2="c-des-estabel-ressup"
                         &Frame2="fpage0"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-estabel (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-ressup wMaintenanceNoNavigation
ON LEAVE OF tt-int-estabel-origem-ressup.cod-estabel-ressup IN FRAME fpage0 /* Estabel Ressuprimento */
DO:
    ASSIGN tt-int-estabel-origem-ressup.cod-estabel-ressup:SCREEN-VALUE IN FRAME fPage0 = UPPER(tt-int-estabel-origem-ressup.cod-estabel-ressup:SCREEN-VALUE IN FRAME fPage0).
    {method/referencefields.i &HandleDBOLeave="hDBOWm-estabel"
                              &KeyValue1="tt-int-estabel-origem-ressup.cod-estabel-ressup:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="nom-estabel"
                              &FieldScreen1="c-des-estabel-ressup"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-estabel-origem-ressup.cod-estabel-ressup wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-estabel-origem-ressup.cod-estabel-ressup IN FRAME fpage0 /* Estabel Ressuprimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}


tt-int-estabel-origem-ressup.cod-estabel-origem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-estabel-origem-ressup.cod-depos-origem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-estabel-origem-ressup.cod-depos-cdi:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    IF NOT VALID-HANDLE(hDBOWm-estabel) THEN DO:
        {btb/btb008za.i1 scbo/bosc041.p YES}
        {btb/btb008za.i2 scbo/bosc041.p '' hDBOWm-estabel}
    END.
    RUN openQueryStatic   IN hDBOWm-estabel (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hDBOWm-deposito) THEN DO:
        {btb/btb008za.i1 scbo/bosc037.p YES}
        {btb/btb008za.i2 scbo/bosc037.p '' hDBOWm-deposito}
    END.
    RUN openQueryStatic   IN hDBOWm-deposito (INPUT "Main":U) NO-ERROR.

    ASSIGN  tt-int-estabel-origem-ressup.cod-estabel-ressup:SCREEN-VALUE IN FRAME fPage0 = tt-int-estabel-ressuprimento.cod-estabel-ressup
            tt-int-estabel-origem-ressup.cod-depos-ressup:SCREEN-VALUE IN FRAME fPage0 = tt-int-estabel-ressuprimento.cod-depos-ressup.

    APPLY "leave":U TO tt-int-estabel-origem-ressup.cod-estabel-ressup IN FRAME fPage0.
    APPLY "leave":U TO tt-int-estabel-origem-ressup.cod-depos-ressup   IN FRAME fPage0.
    IF pcAction <> "Add" THEN DO:
        APPLY "leave":U TO tt-int-estabel-origem-ressup.cod-estabel-origem IN FRAME fPage0.
        APPLY "leave":U TO tt-int-estabel-origem-ressup.cod-depos-origem   IN FRAME fPage0.
        APPLY "leave":U TO tt-int-estabel-origem-ressup.cod-depos-cdi      IN FRAME fPage0.
    END.

  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN  tt-int-estabel-origem-ressup.cod-estabel-ressup = tt-int-estabel-origem-ressup.cod-estabel-ressup:SCREEN-VALUE IN FRAME fPage0
            tt-int-estabel-origem-ressup.cod-depos-ressup   = tt-int-estabel-origem-ressup.cod-depos-ressup:SCREEN-VALUE IN FRAME fPage0.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

