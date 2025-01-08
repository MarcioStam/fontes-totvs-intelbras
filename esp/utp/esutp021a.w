&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-tipo-verba NO-UNDO LIKE tipo-verba
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP021A 2.04.00.001}  /*** 010000 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgmat.i} /*Definiá∆o dos prÇ-processadores*/
{cdp/cdcfgcex.i}
{include/i_dbvers.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTP021A
&GLOBAL-DEFINE Version           2.04.00.001
&GLOBAL-DEFINE DBOVersion        2.0

&GLOBAL-DEFINE ttTable           tt-tipo-verba
&GLOBAL-DEFINE hDBOTable         h-boes454
&GLOBAL-DEFINE DBOTable          tipo-verba

&GLOBAL-DEFINE page0KeyFields    tt-tipo-verba.codigo
&GLOBAL-DEFINE page0Fields       tt-tipo-verba.descricao tt-tipo-verba.ct-codigo tt-tipo-verba.l-margem tt-tipo-verba.l-provisao tt-tipo-verba.tp-fluxo-financ tt-tipo-verba.cod-esp
                                 
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR v_des_cta     AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEF VAR v_num_tip_cta AS INTEGER FORMAT ">9"      NO-UNDO.
DEF VAR v_num_sit_cta AS INTEGER FORMAT ">9"      NO-UNDO.
{upc/btb910za-upc.i}



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-tipo-verba.codigo tt-tipo-verba.descricao ~
tt-tipo-verba.ct-codigo tt-tipo-verba.tp-fluxo-financ tt-tipo-verba.cod-esp ~
tt-tipo-verba.l-margem tt-tipo-verba.l-provisao 
&Scoped-define ENABLED-TABLES tt-tipo-verba
&Scoped-define FIRST-ENABLED-TABLE tt-tipo-verba
&Scoped-Define ENABLED-OBJECTS fi-desc-conta btOK btSave btCancel btHelp ~
RECT-2 RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-tipo-verba.codigo ~
tt-tipo-verba.descricao tt-tipo-verba.ct-codigo ~
tt-tipo-verba.tp-fluxo-financ tt-tipo-verba.cod-esp tt-tipo-verba.l-margem ~
tt-tipo-verba.l-provisao 
&Scoped-define DISPLAYED-TABLES tt-tipo-verba
&Scoped-define FIRST-DISPLAYED-TABLE tt-tipo-verba
&Scoped-Define DISPLAYED-OBJECTS fi-desc-conta 

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

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 1.83.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 5.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-tipo-verba.codigo AT ROW 1.75 COL 13 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-tipo-verba.descricao AT ROW 1.75 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 146
          VIEW-AS FILL-IN 
          SIZE 51.72 BY .88
     tt-tipo-verba.ct-codigo AT ROW 3.67 COL 13 COLON-ALIGNED WIDGET-ID 38
          LABEL "Conta Cont†bil"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     fi-desc-conta AT ROW 3.67 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-tipo-verba.tp-fluxo-financ AT ROW 4.67 COL 13 COLON-ALIGNED WIDGET-ID 152
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-tipo-verba.cod-esp AT ROW 5.67 COL 13 COLON-ALIGNED WIDGET-ID 154
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-tipo-verba.l-margem AT ROW 6.71 COL 15 WIDGET-ID 148
          LABEL "Calcula Margem"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     tt-tipo-verba.l-provisao AT ROW 7.67 COL 15 WIDGET-ID 150
          LABEL "Gera Provis∆o"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     btOK AT ROW 9.29 COL 2
     btSave AT ROW 9.29 COL 13
     btCancel AT ROW 9.29 COL 24
     btHelp AT ROW 9.29 COL 80
     RECT-2 AT ROW 3.33 COL 1.72
     RECT-1 AT ROW 1.25 COL 1.57
     rtToolBar AT ROW 9.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 9.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-tipo-verba T "?" NO-UNDO mgesp tipo-verba
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
         HEIGHT             = 9.96
         WIDTH              = 90.72
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-tipo-verba.ct-codigo IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-tipo-verba.l-margem IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-tipo-verba.l-provisao IN FRAME fpage0
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


&Scoped-define SELF-NAME tt-tipo-verba.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON F5 OF tt-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta Cont†bil */
DO:
    ASSIGN v_ind_finalid_cta = "(nenhum)".
    
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,
                                                   INPUT  "CEP",
                                                   INPUT  "",
                                                   INPUT  v_ind_finalid_cta,
                                                   INPUT  TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        IF  v_cod_conta <> "" THEN
            ASSIGN tt-tipo-verba.ct-codigo:SCREEN-VALUE IN FRAME fPage0 = v_cod_conta
                   fi-desc-conta:SCREEN-VALUE           IN FRAME fPage0 = v_des_titulo_conta.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta Cont†bil */
DO:
    ASSIGN INPUT FRAME fPage0 tt-tipo-verba.ct-codigo.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-ep-codigo-usuario,     /* EMPRESA EMS 2 */
                                                   INPUT        "",                      /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT tt-tipo-verba.ct-codigo, /* CONTA */
                                                   INPUT        TODAY,                   /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta,               /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta,           /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta,           /* SITUA∞ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).
    IF RETURN-VALUE <> "OK" THEN RETURN.

    ASSIGN fi-desc-conta:SCREEN-VALUE IN FRAME fPage0 = v_des_cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta Cont†bil */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializaá∆o do programam ---*/
 tt-tipo-verba.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 
 {maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-boes454) then
        delete procedure h-boes454.

    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-tipo-verba THEN DO:
        APPLY "LEAVE":U TO tt-tipo-verba.ct-codigo IN FRAME fPage0.
    END.
    ELSE
        ASSIGN fi-desc-conta:SCREEN-VALUE IN FRAME fPage0 = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF pcAction = "ADD" OR pcAction = "COPY" THEN DO:
        FIND LAST tipo-verba NO-LOCK NO-ERROR.
        IF NOT AVAIL tipo-verba THEN
            ASSIGN tt-tipo-verba.codigo = 1.
        ELSE
            ASSIGN tt-tipo-verba.codigo = tipo-verba.codigo + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo\boes454.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes454.p YES}
        {btb/btb008za.i2 esbo\boes454.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

