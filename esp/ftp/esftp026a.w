&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcomis-deb-cred NO-UNDO LIKE comis-deb-cred
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttrepres NO-UNDO LIKE repres
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
{include/i-prgvrs.i ESFTP026A 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESFTP026A
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

/*&GLOBAL-DEFINE FolderLabels      <Folder1 ,Folder 2 ,... , Folder8>*/

&GLOBAL-DEFINE ttTable           ttcomis-deb-cred
&GLOBAL-DEFINE hDBOTable         boes270         
&GLOBAL-DEFINE DBOTable          ttcomis-deb-cred

&GLOBAL-DEFINE ttParent          ttrepres
&GLOBAL-DEFINE DBOParentTable    boad229 

&GLOBAL-DEFINE page0KeyFields    ttcomis-deb-cred.cod-mov ttcomis-deb-cred.dt-movto ~
                                 ttcomis-deb-cred.cod-rep ttcomis-deb-cred.cod-estabel ~
                                 ttcomis-deb-cred.unid-neg
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page0Fields       {&page0KeyFields} 
&GLOBAL-DEFINE page1Fields       fi-titulo ttcomis-deb-cred.base-final ~
                                 ttcomis-deb-cred.ct-codigo            ~
                                 ttcomis-deb-cred.deb-cred             ~
                                 ttcomis-deb-cred.historico            ~
                                 ttcomis-deb-cred.sc-codigo            ~
                                 ttcomis-deb-cred.valor
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
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

{upc/btb910za-upc.i} 

    
/* n∆o exclua a linha abaixo !! */
&scoped-define EXCLUDE-saveRecord

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcomis-deb-cred.cod-estabel ~
ttcomis-deb-cred.unid-neg ttcomis-deb-cred.cod-rep ttcomis-deb-cred.cod-mov ~
ttcomis-deb-cred.dt-movto 
&Scoped-define ENABLED-TABLES ttcomis-deb-cred
&Scoped-define FIRST-ENABLED-TABLE ttcomis-deb-cred
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fi-nome-estabel btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttcomis-deb-cred.cod-estabel ~
ttcomis-deb-cred.unid-neg ttcomis-deb-cred.cod-rep ttcomis-deb-cred.cod-mov ~
ttcomis-deb-cred.dt-movto 
&Scoped-define DISPLAYED-TABLES ttcomis-deb-cred
&Scoped-define FIRST-DISPLAYED-TABLE ttcomis-deb-cred
&Scoped-Define DISPLAYED-OBJECTS fi-nome-estabel fi-nome-abrev fi-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 ttcomis-deb-cred.cod-estabel ~
ttcomis-deb-cred.unid-neg ttcomis-deb-cred.cod-rep ttcomis-deb-cred.cod-mov 

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

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttcomis-deb-cred.cod-estabel AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     fi-nome-estabel AT ROW 1.25 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     ttcomis-deb-cred.unid-neg AT ROW 2.25 COL 17 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 9 BY .79
     ttcomis-deb-cred.cod-rep AT ROW 3.25 COL 17 COLON-ALIGNED
          LABEL "Representante"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nome-abrev AT ROW 3.25 COL 25.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     ttcomis-deb-cred.cod-mov AT ROW 4.25 COL 17 COLON-ALIGNED
          LABEL "Cod Movimento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-descricao AT ROW 4.25 COL 22.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     ttcomis-deb-cred.dt-movto AT ROW 5.25 COL 17 COLON-ALIGNED
          LABEL "Dt Transaá∆o"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1
         DEFAULT-BUTTON btSave CANCEL-BUTTON btCancel.

DEFINE FRAME fPage1
     ttcomis-deb-cred.base-final AT ROW 2 COL 11 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Base", yes,
"Final", no
          SIZE 22 BY .88
     ttcomis-deb-cred.deb-cred AT ROW 4.25 COL 11 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", yes,
"CrÇdito", no
          SIZE 22.57 BY .88
     ttcomis-deb-cred.valor AT ROW 6.17 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttcomis-deb-cred.ct-codigo AT ROW 7.17 COL 9 COLON-ALIGNED FORMAT ">>>>>>>>"
          LABEL "Conta-Sub"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttcomis-deb-cred.sc-codigo AT ROW 7.17 COL 19.72 COLON-ALIGNED NO-LABEL FORMAT ">>>>>"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-titulo AT ROW 7.17 COL 30.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     ttcomis-deb-cred.historico AT ROW 8.17 COL 9 COLON-ALIGNED
          LABEL "Hist¢rico"
          VIEW-AS FILL-IN 
          SIZE 72 BY .88
     "Aplicar" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.25 COL 4
     "Lanáamento" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 3.5 COL 4
     RECT-1 AT ROW 1.5 COL 2
     RECT-2 AT ROW 3.75 COL 2
     RECT-3 AT ROW 6 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.75
         SIZE 85.43 BY 9.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcomis-deb-cred T "?" NO-UNDO mgesp comis-deb-cred
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttrepres T "?" NO-UNDO mgcad repres
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
         HEIGHT             = 17
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.cod-estabel IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.cod-mov IN FRAME fpage0
   1 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.cod-rep IN FRAME fpage0
   1 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.dt-movto IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-abrev:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN ttcomis-deb-cred.unid-neg IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.ct-codigo IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-titulo:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN ttcomis-deb-cred.historico IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcomis-deb-cred.sc-codigo IN FRAME fPage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    RETURN NO-APPLY.
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


&Scoped-define SELF-NAME ttcomis-deb-cred.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF ttcomis-deb-cred.cod-estabel IN FRAME fpage0 /* Cod.Estabelecimento */
DO:
  DISP "" @ FI-NOME-ESTABEL WITH FRAME fpage0.
  FOR FIRST estabelec NO-LOCK
      WHERE estabelec.cod-estabel = INPUT ttcomis-deb-cred.cod-estabel:
      DISP estabelec.nome @ fi-nome-estabel WITH FRAME fpage0.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcomis-deb-cred.cod-mov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-mov wMaintenanceNoNavigation
ON F5 OF ttcomis-deb-cred.cod-mov IN FRAME fpage0 /* Cod Movimento */
DO:
    {include/zoomvar.i &prog-zoom="eszoom/z01es272"
                       &campo="fi-descricao"
                       &campozoom="descricao"
                       &frame="fPage0"
                       &campo2="ttcomis-deb-cred.cod-mov"
                       &campozoom2="cod-mov"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-mov wMaintenanceNoNavigation
ON LEAVE OF ttcomis-deb-cred.cod-mov IN FRAME fpage0 /* Cod Movimento */
DO:
    FIND FIRST mov-comis 
        WHERE mov-comis.cod-mov = INPUT ttcomis-deb-cred.cod-mov NO-LOCK NO-ERROR.  
    IF AVAIL mov-comis THEN
      DISP mov-comis.descricao @ fi-descricao WITH FRAME fpage0.

    IF INPUT ttcomis-deb-cred.cod-mov = 4 
    OR INPUT ttcomis-deb-cred.cod-mov = 10 THEN DO:
        DISABLE ttcomis-deb-cred.ct-codigo ttcomis-deb-cred.sc-codigo WITH FRAME fpage1.
        ASSIGN ttcomis-deb-cred.ct-codigo:PRIVATE-DATA IN FRAME fpage1 = 
               ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fpage1
               ttcomis-deb-cred.sc-codigo:PRIVATE-DATA IN FRAME fpage1 = 
               ttcomis-deb-cred.sc-codigo:SCREEN-VALUE IN FRAME fpage1
               fi-titulo:PRIVATE-DATA IN FRAME fpage1 = 
               fi-titulo:SCREEN-VALUE IN FRAME fpage1.
    END.
    ELSE DO:
        ENABLE ttcomis-deb-cred.ct-codigo ttcomis-deb-cred.sc-codigo WITH FRAME fpage1.
        ASSIGN ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fpage1 = 
               ttcomis-deb-cred.ct-codigo:PRIVATE-DATA IN FRAME fpage1
               ttcomis-deb-cred.sc-codigo:SCREEN-VALUE IN FRAME fpage1 = 
               ttcomis-deb-cred.sc-codigo:PRIVATE-DATA IN FRAME fpage1
               fi-titulo:SCREEN-VALUE IN FRAME fpage1 = 
               fi-titulo:PRIVATE-DATA IN FRAME fpage1.
    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-mov wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomis-deb-cred.cod-mov IN FRAME fpage0 /* Cod Movimento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcomis-deb-cred.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-rep wMaintenanceNoNavigation
ON F5 OF ttcomis-deb-cred.cod-rep IN FRAME fpage0 /* Representante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad229"
                       &campo="fi-nome-abrev"
                       &campozoom="nome-abrev"
                       &frame="fPage0"
                       &campo2="ttcomis-deb-cred.cod-rep"
                       &campozoom2="cod-rep"
                       &frame2="fPage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-rep wMaintenanceNoNavigation
ON LEAVE OF ttcomis-deb-cred.cod-rep IN FRAME fpage0 /* Representante */
DO:
  DISP "" @ fi-nome-abrev WITH FRAME fpage0.
  FOR FIRST repres FIELDS (nome-abrev) NO-LOCK
      WHERE repres.cod-rep = INPUT ttcomis-deb-cred.cod-rep:
      DISP repres.nome-abrev @ fi-nome-abrev WITH FRAME fpage0.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.cod-rep wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomis-deb-cred.cod-rep IN FRAME fpage0 /* Representante */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttcomis-deb-cred.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.ct-codigo wMaintenanceNoNavigation
ON F5 OF ttcomis-deb-cred.ct-codigo IN FRAME fPage1 /* Conta-Sub */
DO:
    ASSIGN v_ind_finalid_cta = "(nenhum)".
    
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,
                                                   INPUT  "CEP",
                                                   INPUT  "",
                                                   INPUT  v_ind_finalid_cta,
                                                   INPUT  TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).

    IF  NOT CAN-FIND(FIRST tt_log_erro) AND v_cod_conta <> "" THEN
        ASSIGN ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_conta
               fi-titulo:SCREEN-VALUE                  IN FRAME fPage1 = v_des_titulo_conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttcomis-deb-cred.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.sc-codigo wMaintenanceNoNavigation
ON F5 OF ttcomis-deb-cred.sc-codigo IN FRAME fPage1 /* Conta-Sub */
DO:
    ASSIGN ttcomis-deb-cred.sc-codigo:SCREEN-VALUE = "".

    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_zoom_ccusto IN h_api_ccusto (INPUT  "",
                                        INPUT  "",
                                        INPUT  "",
                                        INPUT  TODAY,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    IF  v_cod_ccusto <> "" THEN
        ASSIGN ttcomis-deb-cred.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF ttcomis-deb-cred.ct-codigo IN FRAME fPage1 /* Conta-Sub */
DO:
    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                 /* EMPRESA EMS 2 */
                                                       INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                 /* PLANO CONTAS */
                                                       INPUT  ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fPage1, /* CONTA */
                                                       INPUT  TODAY,              /* DT TRANSACAO */
                                                       OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                       OUTPUT table tt_log_erro). /* ERROS */

    IF  NOT p_log_ccusto THEN DO:
        ASSIGN ttcomis-deb-cred.sc-codigo:SCREEN-VALUE IN FRAME fPage1 = ""
               ttcomis-deb-cred.sc-codigo:SENSITIVE    IN FRAME fPage1 = NO.
    END.
    ELSE DO:
        ASSIGN ttcomis-deb-cred.sc-codigo:SENSITIVE IN FRAME fPage1 = YES.
    END.

    ASSIGN v_cod_conta = ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fPage1.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                                   INPUT        "",                       /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_conta,              /* CONTA */
                                                   INPUT        TODAY,                    /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_titulo_conta,       /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl,       /* SITUA∞ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).             /* ERROS */

    ASSIGN ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_conta
           fi-titulo:SCREEN-VALUE                  IN FRAME fPage1 = v_des_titulo_conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcomis-deb-cred.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.sc-codigo wMaintenanceNoNavigation
ON LEAVE OF ttcomis-deb-cred.sc-codigo IN FRAME fPage1 /* sc-codigo */
DO:
    APPLY "LEAVE" TO ttcomis-deb-cred.ct-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomis-deb-cred.ct-codigo IN FRAME fPage1 /* Conta-Sub */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomis-deb-cred.sc-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomis-deb-cred.sc-codigo IN FRAME fPage1 /* Conta-Sub */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


ttcomis-deb-cred.cod-rep:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttcomis-deb-cred.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttcomis-deb-cred.cod-mov:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/MainBlock.i}

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
    IF  VALID-HANDLE(adm-broker-hdl) THEN
        DELETE PROCEDURE adm-broker-hdl.
    adm-broker-hdl = ?.

    IF  VALID-HANDLE(h_api_cta_ctbl) THEN
        DELETE OBJECT h_api_cta_ctbl.

    IF  VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

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
  FIND FIRST repres NO-LOCK
      WHERE repres.cod-rep = ttcomis-deb-cred.cod-rep NO-ERROR.
  IF AVAIL repres THEN
      DISP repres.nome-abrev @ fi-nome-abrev WITH FRAME fpage0.
  FIND estabelec
      WHERE estabelec.cod-estabel = ttcomis-deb-cred.cod-estabel NO-LOCK NO-ERROR.
  IF AVAIL estabelec THEN
     DISP estabelec.nome @ fi-nome-estabel WITH FRAME fpage0.


  IF pcAction NE "UPDATE" THEN DO:
      CLEAR FRAME fpage0 ALL.
      DISP ttrepres.cod-rep @ ttcomis-deb-cred.cod-rep
           ttrepres.nome-abrev @ fi-nome-abrev
           WITH FRAME fpage0.
      IF pcAction = "COPY" THEN DO:
      
          DISP ttcomis-deb-cred.cod-mov ttcomis-deb-cred.dt-movto 
               ttcomis-deb-cred.cod-estabel ttcomis-deb-cred.unid-neg
          WITH FRAME fpage0.
          DISP estabelec.nome @ fi-nome-estabel WITH FRAME fpage0.
      END.
      APPLY "entry" TO ttcomis-deb-cred.cod-rep IN FRAME fpage0.   
      IF pcAction = "ADD" THEN DO:
          CLEAR FRAME fpage1 ALL.
          DISP TODAY @ ttcomis-deb-cred.dt-movto WITH FRAME fpage0.
      END.
  END.

  FIND FIRST mov-comis OF ttcomis-deb-cred NO-LOCK NO-ERROR.  
  IF AVAIL mov-comis THEN
    DISP mov-comis.descricao @ fi-descricao WITH FRAME fpage0.
    
  ASSIGN ttcomis-deb-cred.ct-codigo:PRIVATE-DATA IN FRAME fpage1 = 
         ttcomis-deb-cred.ct-codigo:SCREEN-VALUE IN FRAME fpage1
         ttcomis-deb-cred.sc-codigo:PRIVATE-DATA IN FRAME fpage1 = 
         ttcomis-deb-cred.sc-codigo:SCREEN-VALUE IN FRAME fpage1
         fi-titulo:PRIVATE-DATA IN FRAME fpage1 = 
         fi-titulo:SCREEN-VALUE IN FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF pcAction = "UPDATE" THEN DO:
        DISABLE {&List-1} WITH FRAME fpage0.
        APPLY "entry" TO ttcomis-deb-cred.base-final IN FRAME fpage1.        
    END.
    IF ttcomis-deb-cred.cod-mov = 4 
    OR ttcomis-deb-cred.cod-mov = 10 THEN
        DISABLE ttcomis-deb-cred.ct-codigo ttcomis-deb-cred.sc-codigo WITH FRAME fpage1.
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

    IF  adm-broker-hdl = ? THEN
        RUN adm/objects/broker.p PERSISTENT set adm-broker-hdl.

    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    APPLY "LEAVE":U TO ttcomis-deb-cred.ct-codigo IN FRAME fPage1.

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
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    ttcomis-deb-cred.cod-rep = INPUT FRAME fpage0 ttcomis-deb-cred.cod-rep.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord wMaintenanceNoNavigation 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose: Vers∆o simplificada da rotina saveRecord padr∆o da Datasul    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rCurrentAux AS ROWID NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF pcAction = "UPDATE":U
    AND {&ttTable}.dt-movto NE INPUT FRAME fpage0 ttcomis-deb-cred.dt-movto THEN
        rCurrentAux = {&ttTable}.r-rowid.

    RUN saveFields IN THIS-PROCEDURE.

    IF pcAction NE "UPDATE":U OR rCurrentAux NE ? THEN
        RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    ELSE
        RUN repositionRecord IN {&hDBOTable} (INPUT prTable) NO-ERROR.

    RUN setRecord IN {&hDBOTable} (INPUT TABLE {&ttTable}).
    RUN emptyRowErrors IN {&hDBOTable}.
    IF pcAction NE "UPDATE":U OR rCurrentAux NE ? THEN
        RUN createRecord IN {&hDBOTable}.
    ELSE
        RUN updateRecord IN {&hDBOTable}.

    SESSION:SET-WAIT-STATE("":U).

    IF pcAction NE "UPDATE":U THEN
        APPLY "entry" TO ttcomis-deb-cred.cod-rep IN FRAME fpage0.
    ELSE
        APPLY "entry" TO ttcomis-deb-cred.dt-movto IN FRAME fpage0.

    IF RETURN-VALUE NE "NOK":U THEN DO:
        RUN getRecord IN {&hDBOTable} (OUTPUT TABLE {&ttTable}).
        IF rCurrentAux NE ? THEN DO:
            RUN repositionRecord IN {&hDBOTable} (INPUT rCurrentAux).  
            RUN deleteRecord IN {&hDBOTable}.
        END.
        FIND FIRST {&ttTable} NO-ERROR.
        RUN updateCaller IN phCaller (INPUT {&ttTable}.cod-rep) NO-ERROR.
        RETURN "OK":U.
    END.
    ELSE DO:
        RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
        {method/ShowMessage.i1}.
        {method/ShowMessage.i2 &Modal="YES"}.
        {method/ShowMessage.i3}. 
        RETURN "NOK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

