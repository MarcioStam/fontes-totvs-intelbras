&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-rat-desp NO-UNDO LIKE int-rat-desp
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-rat-desp-segur NO-UNDO LIKE int-rat-desp-segur
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

&GLOBAL-DEFINE ttTable           ttint-rat-desp-segur
&GLOBAL-DEFINE hDBOTable         HDBOintrat-desp-segur
&GLOBAL-DEFINE DBOTable          int-rat-desp-segur

&GLOBAL-DEFINE ttParent          ttint-rat-desp
&GLOBAL-DEFINE DBOParentTable    HDBOntrat-desp

&GLOBAL-DEFINE page0KeyFields    ttint-rat-desp.descricao ttint-rat-desp.tipo-rateio
&GLOBAL-DEFINE page0Fields       rs-tipo ttint-rat-desp-segur.codigo cb-acesso
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

/* Local Variable Definitions (DBOs Handles) --- */
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
&Scoped-Define ENABLED-FIELDS ttint-rat-desp-segur.codigo 
&Scoped-define ENABLED-TABLES ttint-rat-desp-segur
&Scoped-define FIRST-ENABLED-TABLE ttint-rat-desp-segur
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 rtKeys-3 rs-tipo ~
cb-acesso btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-rat-desp.tipo-rateio ~
ttint-rat-desp.descricao ttint-rat-desp-segur.codigo 
&Scoped-define DISPLAYED-TABLES ttint-rat-desp ttint-rat-desp-segur
&Scoped-define FIRST-DISPLAYED-TABLE ttint-rat-desp
&Scoped-define SECOND-DISPLAYED-TABLE ttint-rat-desp-segur
&Scoped-Define DISPLAYED-OBJECTS rs-tipo fi-desc cb-acesso 

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

DEFINE VARIABLE cb-acesso AS CHARACTER FORMAT "X(20)":U INITIAL "Lan‡amento" 
     LABEL "Tipo Acesso Usu rio" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Lan‡amento","Contabiliza‡Æo" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Usu rio", 1,
"Grupo", 2
     SIZE 18 BY 1 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-rat-desp.tipo-rateio AT ROW 1.5 COL 24.72 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ttint-rat-desp.descricao AT ROW 1.5 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 55.57 BY .88
     rs-tipo AT ROW 3.5 COL 3 NO-LABEL WIDGET-ID 18
     ttint-rat-desp-segur.codigo AT ROW 3.5 COL 24.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc AT ROW 3.5 COL 35.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     cb-acesso AT ROW 5.67 COL 25 COLON-ALIGNED WIDGET-ID 28
     btOK AT ROW 8.25 COL 2
     btSave AT ROW 8.25 COL 13
     btCancel AT ROW 8.25 COL 24
     btHelp AT ROW 8.25 COL 80
     rtKeys AT ROW 3 COL 1
     rtToolBar AT ROW 8 COL 1
     rtKeys-2 AT ROW 1 COL 1 WIDGET-ID 16
     rtKeys-3 AT ROW 5 COL 1 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.71
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-rat-desp T "?" NO-UNDO mgesp int-rat-desp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-rat-desp-segur T "?" NO-UNDO mgesp int-rat-desp-segur
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
         HEIGHT             = 8.63
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
/* SETTINGS FOR FILL-IN ttint-rat-desp.descricao IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       ttint-rat-desp.descricao:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN ttint-rat-desp.tipo-rateio IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       ttint-rat-desp.tipo-rateio:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME cb-acesso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-acesso wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-acesso IN FRAME fpage0 /* Tipo Acesso Usu rio */
DO:
  
    /*
    if input frame fPage0 cb-acao = "Libera Altera‡Æo" then 
       assign ttint-rat-desp-segur.acao:SCREEN-VALUE = "1".
    else IF input frame fPage0 cb-acao = "Exige Justificativa" then 
       assign ttint-rat-desp-segur.acao:SCREEN-VALUE = "2".
    */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-rat-desp-segur.codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-segur.codigo wMaintenanceNoNavigation
ON F5 OF ttint-rat-desp-segur.codigo IN FRAME fpage0 /* C¢digo */
DO:

    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1" THEN DO:
        
        assign l-implanta = NO.
        {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                           &campo=ttint-rat-desp-segur.codigo
                           &campozoom=cod_usuario}
    END.
    ELSE DO:
        RUN pi-zoom-grupo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-segur.codigo wMaintenanceNoNavigation
ON LEAVE OF ttint-rat-desp-segur.codigo IN FRAME fpage0 /* C¢digo */
DO:
  
    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1" THEN DO:

        FIND FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = INPUT FRAME fpage0 ttint-rat-desp-segur.codigo NO-ERROR.

        IF  AVAIL usuar_mestre THEN
            ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = usuar_mestre.nom_usuario.
        ELSE
            ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

    END.
    /*GRUPO*/
    ELSE DO:
        FIND FIRST grp_usuar NO-LOCK
            WHERE grp_usuar.cod_grp_usuar = INPUT FRAME fpage0 ttint-rat-desp-segur.codigo NO-ERROR.

        IF  AVAIL grp_usuar THEN 
            ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = grp_usuar.des_grp_usuar.
        ELSE
            ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-segur.codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttint-rat-desp-segur.codigo IN FRAME fpage0 /* C¢digo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wMaintenanceNoNavigation
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage0
DO:
  
    ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = ""
           ttint-rat-desp-segur.codigo:SCREEN-VALUE IN FRAME fpage0 = "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterenablefields wMaintenanceNoNavigation 
PROCEDURE afterenablefields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT g-inclusao THEN
        ASSIGN rs-tipo:SENSITIVE IN FRAME fpage0 = NO
               ttint-rat-desp-segur.codigo:SENSITIVE IN FRAME fpage0 = NO.
            
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

    IF  NOT g-inclusao THEN DO:
        IF  ttint-rat-desp-segur.usuar-grupo = 1 THEN DO:

            FIND FIRST usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuario = ttint-rat-desp-segur.codigo NO-ERROR.
            IF  AVAIL usuar_mestre THEN
                ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = usuar_mestre.nom_usuario.
            ELSE
                ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

             ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1".

        END.
        /*GRUPO*/
        ELSE DO:
            FIND FIRST grp_usuar NO-LOCK
                WHERE grp_usuar.cod_grp_usuar = ttint-rat-desp-segur.codigo NO-ERROR.

            IF  AVAIL grp_usuar THEN
                ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = grp_usuar.des_grp_usuar.
            ELSE
                ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".

            ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "2".
        END.
        
        
        IF  ttint-rat-desp-segur.tipo-seguranca = 1 THEN DO:
            ASSIGN cb-acesso:SCREEN-VALUE IN FRAME fpage0 = "Lan‡amento".
        END.
        ELSE
            ASSIGN cb-acesso:SCREEN-VALUE IN FRAME fpage0 = "Contabiliza‡Æo".


    END.
    ELSE
    ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1"
           cb-acesso:SCREEN-VALU IN FRAME fpage0 = "Lan‡amento".
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
    ASSIGN ttint-rat-desp-segur.tipo-seguranca = IF cb-acesso:SCREEN-VALUE IN FRAME fpage0 = "Lan‡amento"
                                                  THEN 1
                                                  ELSE 2.     
    ASSIGN ttint-rat-desp-segur.usuar-grupo   =  IF rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1"
                                                  THEN 1
                                                  ELSE 2.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-grupo wMaintenanceNoNavigation 
PROCEDURE pi-zoom-grupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        assign l-implanta = NO.
        {include/zoomvar.i &prog-zoom=unzoom/z02un075.w
                           &campo=ttint-rat-desp-segur.codigo
                           &campozoom=cod_grp_usuar}
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
    
    ASSIGN ttint-rat-desp-segur.tipo-rateio = ttint-rat-desp.tipo-rateio.



    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

