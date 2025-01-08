&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-repres NO-UNDO LIKE int-repres
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-repres-un-ger NO-UNDO LIKE repres-un-ger
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
{include/i-prgvrs.i ESCDP039A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCDP039A
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO

&GLOBAL-DEFINE ttTable           tt-repres-un-ger
&GLOBAL-DEFINE hDBOTable         h-boes569
&GLOBAL-DEFINE DBOTable          repres-un-ger

&GLOBAL-DEFINE ttParent          tt-int-repres
&GLOBAL-DEFINE DBOParentTable    int-repres

&GLOBAL-DEFINE page0KeyFields    tt-repres-un-ger.cd-unid-negoc ~
                                 tt-repres-un-ger.cod-gerente
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-int-repres.cod-repres

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* Definicao da Temp-tables usadas no programa ESCRM001B.p */
{esp/crm/escrm001b.i}

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl   AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc AS CHARACTER   NO-UNDO.

DEFINE VARIABLE wh-pesquisa-un AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-repres.cod-repres ~
tt-repres-un-ger.cd-unid-negoc tt-repres-un-ger.cod-gerente 
&Scoped-define ENABLED-TABLES tt-int-repres tt-repres-un-ger
&Scoped-define FIRST-ENABLED-TABLE tt-int-repres
&Scoped-define SECOND-ENABLED-TABLE tt-repres-un-ger
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-nome-repres ~
c-ds-unid-negoc c-nome-gerente btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-int-repres.cod-repres ~
tt-repres-un-ger.cd-unid-negoc tt-repres-un-ger.cod-gerente 
&Scoped-define DISPLAYED-TABLES tt-int-repres tt-repres-un-ger
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-repres
&Scoped-define SECOND-DISPLAYED-TABLE tt-repres-un-ger
&Scoped-Define DISPLAYED-OBJECTS c-nome-repres c-ds-unid-negoc ~
c-nome-gerente 

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

DEFINE VARIABLE c-ds-unid-negoc AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 54.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-gerente AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 54.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-repres AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 52.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-int-repres.cod-repres AT ROW 1.29 COL 22 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-nome-repres AT ROW 1.29 COL 30.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     tt-repres-un-ger.cd-unid-negoc AT ROW 2.79 COL 22 COLON-ALIGNED WIDGET-ID 2
          LABEL "Unid Neg¢cio (Controladoria)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-ds-unid-negoc AT ROW 2.79 COL 28.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-repres-un-ger.cod-gerente AT ROW 3.79 COL 22 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-nome-gerente AT ROW 3.79 COL 28.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     btOK AT ROW 5.25 COL 2
     btSave AT ROW 5.25 COL 13
     btCancel AT ROW 5.25 COL 24
     btHelp AT ROW 5.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 5.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-repres T "?" NO-UNDO mgesp int-repres
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-repres-un-ger T "?" NO-UNDO mgesp repres-un-ger
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
         HEIGHT             = 5.5
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0
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


&Scoped-define SELF-NAME tt-repres-un-ger.cd-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cd-unid-negoc wMaintenanceNoNavigation
ON F5 OF tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0 /* Unid Neg¢cio (Controladoria) */
DO:
    IF SEARCH("prgint/utb/utb011ka.p") <> ? OR
       SEARCH("prgint/utb/utb011ka.r") <> ? THEN DO:

        RUN prgint/utb/utb011ka.p PERSISTENT SET wh-pesquisa-un.

        IF v_cod_unid_negoc <> " ":U THEN
            ASSIGN tt-repres-un-ger.cd-unid-negoc = v_cod_unid_negoc.

        DISPLAY tt-repres-un-ger.cd-unid-negoc
            WITH FRAME fPage0.

        APPLY "LEAVE":U TO tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cd-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0 /* Unid Neg¢cio (Controladoria) */
DO:
    ASSIGN INPUT FRAME fPage0 tt-repres-un-ger.cd-unid-negoc.

    FIND FIRST tt-unid-negoc NO-LOCK
        WHERE  tt-unid-negoc.cod-unid-negoc = tt-repres-un-ger.cd-unid-negoc NO-ERROR.

    ASSIGN c-ds-unid-negoc = IF AVAIL tt-unid-negoc THEN tt-unid-negoc.des-unid-negoc ELSE "".

    DISPLAY c-ds-unid-negoc WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cd-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0 /* Unid Neg¢cio (Controladoria) */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-repres-un-ger.cod-gerente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cod-gerente wMaintenanceNoNavigation
ON F5 OF tt-repres-un-ger.cod-gerente IN FRAME fPage0 /* Gerente */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es382.w"
                         &FieldZoom1="cod-gerente"
                         &FieldScreen1="tt-repres-un-ger.cod-gerente"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cod-gerente wMaintenanceNoNavigation
ON LEAVE OF tt-repres-un-ger.cod-gerente IN FRAME fPage0 /* Gerente */
DO:
    ASSIGN INPUT FRAME fPage0 tt-repres-un-ger.cod-gerente.

    FIND FIRST gerente NO-LOCK
        WHERE  gerente.cod-gerente = tt-repres-un-ger.cod-gerente NO-ERROR.

    ASSIGN c-nome-gerente = IF AVAIL gerente THEN gerente.nome ELSE "".

    DISPLAY c-nome-gerente WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-repres-un-ger.cod-gerente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-repres-un-ger.cod-gerente IN FRAME fPage0 /* Gerente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-repres.cod-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-repres.cod-repres wMaintenanceNoNavigation
ON LEAVE OF tt-int-repres.cod-repres IN FRAME fPage0 /* Cod.Repres */
DO:
    ASSIGN INPUT FRAME fPage0 tt-int-repres.cod-repres.

    FIND FIRST repres NO-LOCK
        WHERE  repres.cod-rep = tt-int-repres.cod-repres NO-ERROR.

    ASSIGN c-nome-repres = IF AVAIL repres THEN repres.nome-abrev ELSE "".

    DISPLAY c-nome-repres WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-repres-un-ger.cod-gerente:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.
tt-repres-un-ger.cd-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    APPLY "LEAVE":U TO tt-int-repres.cod-repres       IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-repres-un-ger.cd-unid-negoc IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-repres-un-ger.cod-gerente   IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Carrega a Tabela de Unidade de Neg¢cio do EMS 5 */
    RUN pi-carrega-tab-ems5 IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tab-ems5 wMaintenanceNoNavigation 
PROCEDURE pi-carrega-tab-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-unid-negoc.

    ASSIGN c-param-chave[1] = "".

    RUN esp/crm/escrm001b.p (INPUT  "unid_negoc",
                             INPUT  c-param-chave,
                             OUTPUT TABLE tt-raw-param).

    FOR EACH tt-raw-param NO-LOCK:
        CREATE tt-unid-negoc.
        RAW-TRANSFER tt-raw-param.raw-trans TO tt-unid-negoc.
    END.

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

    ASSIGN {&ttTable}.cod-rep = {&ttParent}.cod-repres.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

