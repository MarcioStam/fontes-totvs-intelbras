&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-item-estab-depos NO-UNDO LIKE int-item-estab-depos
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-int-item-estab-depos-pv NO-UNDO LIKE int-item-estab-depos-pv
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

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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

&GLOBAL-DEFINE ttTable        tt-int-item-estab-depos-pv
&GLOBAL-DEFINE hDBOTable      hesbo929
&GLOBAL-DEFINE DBOTable       int-item-estab-depos-pv

&GLOBAL-DEFINE ttParent       tt-int-item-estab-depos
&GLOBAL-DEFINE DBOParentTable int-item-estab-depos

&GLOBAL-DEFINE page0KeyFields tt-int-item-estab-depos-pv.cod-estabel tt-int-item-estab-depos-pv.cod-depos tt-int-item-estab-depos-pv.it-codigo tt-int-item-estab-depos-pv.ano
&GLOBAL-DEFINE page0Fields    tt-int-item-estab-depos-pv.quant-previsao-venda[1]  tt-int-item-estab-depos-pv.quant-previsao-venda[2]  tt-int-item-estab-depos-pv.quant-previsao-venda[3]  tt-int-item-estab-depos-pv.quant-previsao-venda[4] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[5]  tt-int-item-estab-depos-pv.quant-previsao-venda[6]  tt-int-item-estab-depos-pv.quant-previsao-venda[7]  tt-int-item-estab-depos-pv.quant-previsao-venda[8] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[9]  tt-int-item-estab-depos-pv.quant-previsao-venda[10] tt-int-item-estab-depos-pv.quant-previsao-venda[11] tt-int-item-estab-depos-pv.quant-previsao-venda[12]

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
DEFINE VARIABLE h-bosc044       AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-item-estab-depos-pv.cod-estabel ~
tt-int-item-estab-depos-pv.cod-depos tt-int-item-estab-depos-pv.it-codigo ~
tt-int-item-estab-depos-pv.ano ~
tt-int-item-estab-depos-pv.quant-previsao-venda[1] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[2] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[3] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[4] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[5] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[6] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[7] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[8] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[9] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[10] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[11] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[12] 
&Scoped-define ENABLED-TABLES tt-int-item-estab-depos-pv
&Scoped-define FIRST-ENABLED-TABLE tt-int-item-estab-depos-pv
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-35 btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-int-item-estab-depos-pv.cod-estabel ~
tt-int-item-estab-depos-pv.cod-depos tt-int-item-estab-depos-pv.it-codigo ~
tt-int-item-estab-depos-pv.ano ~
tt-int-item-estab-depos-pv.quant-previsao-venda[1] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[2] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[3] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[4] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[5] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[6] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[7] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[8] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[9] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[10] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[11] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[12] 
&Scoped-define DISPLAYED-TABLES tt-int-item-estab-depos-pv
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-item-estab-depos-pv
&Scoped-Define DISPLAYED-OBJECTS c-des-estabel-ressup c-des-deposito-ressup ~
c-des-item 

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

DEFINE VARIABLE c-des-deposito-ressup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-estabel-ressup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-int-item-estab-depos-pv.cod-estabel AT ROW 1.25 COL 25 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-estabel-ressup AT ROW 1.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-int-item-estab-depos-pv.cod-depos AT ROW 2.25 COL 25 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-deposito-ressup AT ROW 2.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-int-item-estab-depos-pv.it-codigo AT ROW 3.25 COL 25 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     c-des-item AT ROW 3.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-int-item-estab-depos-pv.ano AT ROW 4.25 COL 25 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[1] AT ROW 6.75 COL 17 COLON-ALIGNED WIDGET-ID 42
          LABEL "Janeiro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[2] AT ROW 6.75 COL 41 COLON-ALIGNED WIDGET-ID 44
          LABEL "Fevereiro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[3] AT ROW 6.75 COL 66 COLON-ALIGNED WIDGET-ID 46
          LABEL "Maráo"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[4] AT ROW 8 COL 17 COLON-ALIGNED WIDGET-ID 48
          LABEL "Abril"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[5] AT ROW 8 COL 41 COLON-ALIGNED WIDGET-ID 50
          LABEL "Maio"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[6] AT ROW 8 COL 66 COLON-ALIGNED WIDGET-ID 32
          LABEL "Junho"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[7] AT ROW 9.25 COL 17 COLON-ALIGNED WIDGET-ID 34
          LABEL "Julho"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[8] AT ROW 9.25 COL 41 COLON-ALIGNED WIDGET-ID 36
          LABEL "Agosto"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[9] AT ROW 9.25 COL 66 COLON-ALIGNED WIDGET-ID 38
          LABEL "Setembro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[10] AT ROW 10.5 COL 17 COLON-ALIGNED WIDGET-ID 16
          LABEL "Outubro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[11] AT ROW 10.5 COL 41 COLON-ALIGNED WIDGET-ID 18
          LABEL "Novembro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-int-item-estab-depos-pv.quant-previsao-venda[12] AT ROW 10.5 COL 66 COLON-ALIGNED WIDGET-ID 40
          LABEL "Dezembro"
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     btOK AT ROW 12.25 COL 2
     btSave AT ROW 12.25 COL 13
     btCancel AT ROW 12.25 COL 24
     btHelp AT ROW 12.25 COL 80
     "Quantidade Previs∆o Vendas" VIEW-AS TEXT
          SIZE 21 BY .88 AT ROW 5.5 COL 2 WIDGET-ID 54
     rtKeys AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 12.5
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     rtToolBar AT ROW 12 COL 1
     RECT-35 AT ROW 5.75 COL 1 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 12.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-item-estab-depos T "?" NO-UNDO mgintelbras int-item-estab-depos
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-int-item-estab-depos-pv T "?" NO-UNDO mgintelbras int-item-estab-depos-pv
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
         HEIGHT             = 12.67
         WIDTH              = 90.43
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
/* SETTINGS FOR FILL-IN c-des-deposito-ressup IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-estabel-ressup IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[10] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[11] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[12] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[1] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[2] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[3] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[4] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[5] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[6] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[7] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[8] IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos-pv.quant-previsao-venda[9] IN FRAME fpage0
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


&Scoped-define SELF-NAME tt-int-item-estab-depos-pv.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-depos wMaintenanceNoNavigation
ON F5 OF tt-int-item-estab-depos-pv.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc037.w"
                         &FieldZoom1="cod-deposito"
                         &FieldScreen1="tt-int-item-estab-depos-pv.cod-depos"
                         &Frame1="fpage0"
                         &FieldZoom2="des-deposito"
                         &FieldScreen2="c-des-deposito-ressup"
                         &Frame2="fpage0"
                         &RunMethod=" "
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-depos wMaintenanceNoNavigation
ON LEAVE OF tt-int-item-estab-depos-pv.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="hDBOWm-deposito"
      &KeyValue1="tt-int-item-estab-depos-pv.cod-depos:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="des-deposito"
      &FieldScreen1="c-des-deposito-ressup"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-depos wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-item-estab-depos-pv.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item-estab-depos-pv.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-int-item-estab-depos-pv.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-int-item-estab-depos-pv.cod-estabel"
                         &Frame1="fpage0"
                         &FieldZoom2="nom-estabel"
                         &FieldScreen2="c-des-estabel-ressup"
                         &Frame2="fpage0"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-estabel (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-int-item-estab-depos-pv.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    ASSIGN tt-int-item-estab-depos-pv.cod-estabel:SCREEN-VALUE IN FRAME fPage0 = UPPER(tt-int-item-estab-depos-pv.cod-estabel:SCREEN-VALUE IN FRAME fPage0).
    {method/referencefields.i &HandleDBOLeave="hDBOWm-estabel"
                              &KeyValue1="tt-int-item-estab-depos-pv.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="nom-estabel"
                              &FieldScreen1="c-des-estabel-ressup"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-item-estab-depos-pv.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item-estab-depos-pv.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.it-codigo wMaintenanceNoNavigation
ON F5 OF tt-int-item-estab-depos-pv.it-codigo IN FRAME fpage0 /* Item */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc044.w"
                         &FieldZoom1="cod-item"
                         &FieldScreen1="tt-int-item-estab-depos-pv.it-codigo"
                         &Frame1="fPage0"
                         &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos-pv.it-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-int-item-estab-depos-pv.it-codigo IN FRAME fpage0 /* Item */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bosc044"
                              &KeyValue1="tt-int-item-estab-depos-pv.it-codigo:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="des-item"
                              &FieldScreen1="c-des-item"
                              &Frame1="fPage0"} 
                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

      /*--- Verifica se o DBO jò estò inicializado ---*/
    IF NOT VALID-HANDLE(h-bosc044) OR
       h-bosc044:TYPE <> "PROCEDURE":U OR
       h-bosc044:FILE-NAME <> "scbo/bosc044.p":U THEN DO:
       {btb/btb008za.i1 scbo/bosc044.p YES}
       {btb/btb008za.i2 scbo/bosc044.p '' h-bosc044} 
    END.

    RUN openQueryStatic IN h-bosc044 (INPUT "MAIN":U) NO-ERROR.

    FIND FIRST int-item-estab-depos 
         WHERE ROWID(int-item-estab-depos) = prParent
        NO-LOCK NO-ERROR.

    ASSIGN  tt-int-item-estab-depos-pv.cod-estabel   :SCREEN-VALUE IN FRAME fPage0 = int-item-estab-depos.cod-estabel
            tt-int-item-estab-depos-pv.cod-depos     :SCREEN-VALUE IN FRAME fPage0 = int-item-estab-depos.cod-depos
            tt-int-item-estab-depos-pv.it-codigo     :SCREEN-VALUE IN FRAME fPage0 = int-item-estab-depos.it-codigo
            tt-int-item-estab-depos-pv.cod-estabel   :SENSITIVE IN FRAME fPage0 = NO
            tt-int-item-estab-depos-pv.cod-depos     :SENSITIVE IN FRAME fPage0 = NO
            tt-int-item-estab-depos-pv.it-codigo     :SENSITIVE IN FRAME fPage0 = NO.
            

    APPLY "leave":U TO tt-int-item-estab-depos-pv.cod-estabel IN FRAME fPage0.
    APPLY "leave":U TO tt-int-item-estab-depos-pv.cod-depos   IN FRAME fPage0.
    APPLY "leave":U TO tt-int-item-estab-depos-pv.it-codigo   IN FRAME fPage0.
    
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

    ASSIGN  tt-int-item-estab-depos-pv.cod-estabel = tt-int-item-estab-depos-pv.cod-estabel:SCREEN-VALUE IN FRAME fPage0
            tt-int-item-estab-depos-pv.cod-depos   = tt-int-item-estab-depos-pv.cod-depos:SCREEN-VALUE IN FRAME fPage0.
            tt-int-item-estab-depos-pv.it-codigo   = tt-int-item-estab-depos-pv.it-codigo:SCREEN-VALUE IN FRAME fPage0.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

