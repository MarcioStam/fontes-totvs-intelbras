&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-rateio NO-UNDO LIKE int-rateio
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-rateio-fatur NO-UNDO LIKE int-rateio-fatur
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
{include/i-prgvrs.i teste 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           teste
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttint-rateio-fatur
&GLOBAL-DEFINE hDBOTable         HDBOintrateio-fatur
&GLOBAL-DEFINE DBOTable          int-rateio-fatur

&GLOBAL-DEFINE ttParent          ttint-rateio
&GLOBAL-DEFINE DBOParentTable    HDBOntrat-desp

&GLOBAL-DEFINE page0KeyFields    ttint-rateio-fatur.nr-fatura
&GLOBAL-DEFINE page0Fields       ttint-rateio-fatur.vl-deducao ttint-rateio-fatur.vl-origem
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

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
ttint-rateio.cod-estabel ttint-rateio-fatur.nr-fatura ~
ttint-rateio-fatur.vl-origem ttint-rateio-fatur.vl-deducao 
&Scoped-define ENABLED-TABLES ttint-rateio ttint-rateio-fatur
&Scoped-define FIRST-ENABLED-TABLE ttint-rateio
&Scoped-define SECOND-ENABLED-TABLE ttint-rateio-fatur
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys-2 rtKeys-4 fi-competencia ~
btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-rateio.tipo-rateio ~
ttint-rateio.cod-estabel ttint-rateio-fatur.nr-fatura ~
ttint-rateio-fatur.vl-origem ttint-rateio-fatur.vl-deducao ~
ttint-rateio-fatur.vl-base-rateio 
&Scoped-define DISPLAYED-TABLES ttint-rateio ttint-rateio-fatur
&Scoped-define FIRST-DISPLAYED-TABLE ttint-rateio
&Scoped-define SECOND-DISPLAYED-TABLE ttint-rateio-fatur
&Scoped-Define DISPLAYED-OBJECTS fi-desc-rateio fi-competencia ~
fi-desc-estab 

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

DEFINE VARIABLE fi-competencia AS CHARACTER FORMAT "99/9999":U 
     LABEL "Competencia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 TOOLTIP "Competˆncia" NO-UNDO.

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-rateio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.

DEFINE RECTANGLE rtKeys-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-rateio.tipo-rateio AT ROW 1.5 COL 12 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-rateio AT ROW 1.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     fi-competencia AT ROW 2.5 COL 12 COLON-ALIGNED HELP
          "Competˆncia" WIDGET-ID 50
     ttint-rateio.cod-estabel AT ROW 3.5 COL 12 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fi-desc-estab AT ROW 3.5 COL 19.57 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     ttint-rateio-fatur.nr-fatura AT ROW 4.5 COL 12 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ttint-rateio-fatur.vl-origem AT ROW 6.5 COL 13 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-rateio-fatur.vl-deducao AT ROW 7.5 COL 13 COLON-ALIGNED WIDGET-ID 44 FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-rateio-fatur.vl-base-rateio AT ROW 8.5 COL 13 COLON-ALIGNED WIDGET-ID 42 FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     btOK AT ROW 10.17 COL 2
     btSave AT ROW 10.17 COL 13
     btCancel AT ROW 10.17 COL 24
     btHelp AT ROW 10.17 COL 80
     rtToolBar AT ROW 9.92 COL 1
     rtKeys-2 AT ROW 1 COL 1 WIDGET-ID 16
     rtKeys-4 AT ROW 5.75 COL 1 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.58
         FONT 1 WIDGET-ID 100.


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
      TABLE: ttint-rateio-fatur T "?" NO-UNDO mgesp int-rateio-fatur
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
         HEIGHT             = 10.71
         WIDTH              = 90.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 119.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 119.57
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
/* SETTINGS FOR FILL-IN fi-desc-estab IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-estab:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-rateio IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-rateio:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN ttint-rateio-fatur.vl-base-rateio IN FRAME fpage0
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttint-rateio-fatur.vl-deducao IN FRAME fpage0
   EXP-FORMAT                                                           */
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


&Scoped-define SELF-NAME ttint-rateio-fatur.vl-deducao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio-fatur.vl-deducao wMaintenanceNoNavigation
ON LEAVE OF ttint-rateio-fatur.vl-deducao IN FRAME fpage0 /* Dedu‡Æo */
DO:
    ASSIGN  ttint-rateio-fatur.vl-base-rateio = INPUT FRAME fpage0 ttint-rateio-fatur.vl-origem - INPUT FRAME fpage0 ttint-rateio-fatur.vl-deducao.
    DISPLAY ttint-rateio-fatur.vl-base-rateio WITH FRAME fpage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-rateio-fatur.vl-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rateio-fatur.vl-origem wMaintenanceNoNavigation
ON LEAVE OF ttint-rateio-fatur.vl-origem IN FRAME fpage0 /* Valor */
DO:
    ASSIGN  ttint-rateio-fatur.vl-base-rateio = INPUT FRAME fpage0 ttint-rateio-fatur.vl-origem - INPUT FRAME fpage0 ttint-rateio-fatur.vl-deducao.
    DISPLAY ttint-rateio-fatur.vl-base-rateio WITH FRAME fpage0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenanceNoNavigation 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN  ttint-rateio.tipo-rateio:SCREEN-VALUE IN FRAME fpage0     = string(ttint-rateio.tipo-rateio)
            fi-competencia:SCREEN-VALUE IN FRAME fpage0               = substr(ttint-rateio.competencia, 5,2) + "/" + substr(ttint-rateio.competencia, 1, 4)
            ttint-rateio.cod-estab:SCREEN-VALUE IN FRAME fpage0       = ttint-rateio.cod-estab
            ttint-rateio-fatur.nr-fatura:SCREEN-VALUE IN FRAME fpage0 = ttint-rateio-fatur.nr-fatura.

    FIND FIRST int-rat-desp NO-LOCK
        WHERE int-rat-desp.tipo-rateio = ttint-rateio.tipo-rateio NO-ERROR.
    IF  AVAIL int-rat-desp THEN
        ASSIGN fi-desc-rateio:SCREEN-VALUE IN FRAME fpage0 = int-rat-desp.descricao.

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.
    IF  AVAIL estabelec THEN
        ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fpage0 = estabelec.nome.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterenablefields wMaintenanceNoNavigation 
PROCEDURE afterenablefields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    ASSIGN ttint-rateio.tipo-rateio:SENSITIVE IN FRAME fpage0 = NO
           fi-competencia:SENSITIVE IN FRAME fpage0 = NO
           ttint-rateio.cod-estab:SENSITIVE IN FRAME fpage0   = NO.

    IF  NOT g-inclusao THEN
        ttint-rateio-fatur.nr-fatura:SENSITIVE IN FRAME fpage0 = NO.
    ELSE
        ttint-rateio-fatur.nr-fatura:SENSITIVE IN FRAME fpage0 = YES.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeSaveFields wMaintenanceNoNavigation 
PROCEDURE BeforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
    
    ASSIGN ttint-rateio-fatur.tipo-rateio  = ttint-rateio.tipo-rateio
           ttint-rateio-fatur.competencia  = ttint-rateio.competencia
           ttint-rateio-fatur.cod-estabel  = ttint-rateio.cod-estabel.


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
    
    
    ASSIGN ttint-rateio-fatur.tipo-rateio  = ttint-rateio.tipo-rateio
           ttint-rateio-fatur.competencia  = ttint-rateio.competencia
           ttint-rateio-fatur.cod-estabel  = ttint-rateio.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

