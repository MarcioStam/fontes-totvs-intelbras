&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-rat-desp NO-UNDO LIKE int-rat-desp
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-rat-desp-lancto NO-UNDO LIKE int-rat-desp-lancto
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
{include/i-prgvrs.i esflg004c 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           esflg004c
&GLOBAL-DEFINE Version           2.0

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1



&GLOBAL-DEFINE ttTable           ttint-rat-desp-lancto
&GLOBAL-DEFINE hDBOTable         hDBOint-rat-desp-lancto
&GLOBAL-DEFINE DBOTable          int-rat-desp-lancto

&GLOBAL-DEFINE ttParent          ttint-rat-desp
&GLOBAL-DEFINE DBOParentTable    int-rat-desp

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       cb-lancto ttint-rat-desp-lancto.ct-codigo
&GLOBAL-DEFINE page0ParentFields ttint-rat-desp.tipo-rateio ttint-rat-desp.descricao

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

{upc/btb910za-upc.i}
IF NOT VALID-HANDLE (h_api_cta_ctbl) THEN
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
IF NOT VALID-HANDLE (h_api_ccusto) THEN
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-rat-desp-lancto.ct-codigo 
&Scoped-define ENABLED-TABLES ttint-rat-desp-lancto
&Scoped-define FIRST-ENABLED-TABLE ttint-rat-desp-lancto
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-3 cb-lancto ~
fi-desc-conta btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-rat-desp.tipo-rateio ~
ttint-rat-desp.descricao ttint-rat-desp-lancto.ct-codigo 
&Scoped-define DISPLAYED-TABLES ttint-rat-desp ttint-rat-desp-lancto
&Scoped-define FIRST-DISPLAYED-TABLE ttint-rat-desp
&Scoped-define SECOND-DISPLAYED-TABLE ttint-rat-desp-lancto
&Scoped-Define DISPLAYED-OBJECTS cb-lancto fi-desc-conta 

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

DEFINE VARIABLE cb-lancto AS CHARACTER FORMAT "X(25)":U INITIAL "Transit¢ria" 
     LABEL "Tipo de Lan‡amento" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Transit¢ria","Despesa","Transferˆncia Recurso" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-rat-desp.tipo-rateio AT ROW 1.5 COL 17 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ttint-rat-desp.descricao AT ROW 1.5 COL 24.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 55.57 BY .88
     cb-lancto AT ROW 2.75 COL 17.14 COLON-ALIGNED WIDGET-ID 28
     ttint-rat-desp-lancto.ct-codigo AT ROW 4.88 COL 17.14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     fi-desc-conta AT ROW 4.88 COL 33.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     btOK AT ROW 7.17 COL 2
     btSave AT ROW 7.17 COL 13
     btCancel AT ROW 7.17 COL 24
     btHelp AT ROW 7.17 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 6.92 COL 1
     rtKeys-3 AT ROW 4 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.5
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
      TABLE: ttint-rat-desp-lancto T "?" NO-UNDO mgesp int-rat-desp-lancto
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
         HEIGHT             = 7.58
         WIDTH              = 90
         MAX-HEIGHT         = 17.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.33
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttint-rat-desp.descricao IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       ttint-rat-desp.descricao:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       fi-desc-conta:READ-ONLY IN FRAME fpage0        = TRUE.

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


/*     RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT string(i-ep-codigo-usuario),                 /* EMPRESA EMS2 */                    */
/*                                                     INPUT  "",                 /* ESTABELECIMENTO EMS2 */                                    */
/*                                                     INPUT  "",                 /* UNIDADE NEG…CIO */                                         */
/*                                                     INPUT  "",                 /* PLANO CONTAS */                                            */
/*                                                     INPUT  ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0,        /* CONTA */  */
/*                                                     INPUT  "",                 /* PLANO CCUSTO */                                            */
/*                                                     INPUT  "",        /* CCUSTO */                                                           */
/*                                                     INPUT  TODAY,              /* DATA TRANSACAO */                                          */
/*                                                     OUTPUT TABLE tt_log_erro). /* ERROS */                                                   */
    FOR EACH tt_log_erro:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT  tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        RETURN NO-APPLY.
    END.



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
/*     RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  string(i-ep-codigo-usuario),                 /* EMPRESA EMS2 */                   */
/*                                                     INPUT  "",                 /* ESTABELECIMENTO EMS2 */                                    */
/*                                                     INPUT  "",                 /* UNIDADE NEG…CIO */                                         */
/*                                                     INPUT  "",                 /* PLANO CONTAS */                                            */
/*                                                     INPUT  ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0,        /* CONTA */  */
/*                                                     INPUT  "",                 /* PLANO CCUSTO */                                            */
/*                                                     INPUT  "",        /* CCUSTO */                                                           */
/*                                                     INPUT  TODAY,              /* DATA TRANSACAO */                                          */
/*                                                     OUTPUT TABLE tt_log_erro). /* ERROS */                                                   */
    FOR EACH tt_log_erro:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT  tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        RETURN NO-APPLY.
    END.




    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-lancto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-lancto wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-lancto IN FRAME fpage0 /* Tipo de Lan‡amento */
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


&Scoped-define SELF-NAME ttint-rat-desp-lancto.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-lancto.ct-codigo wMaintenanceNoNavigation
ON F5 OF ttint-rat-desp-lancto.ct-codigo IN FRAME fpage0 /* Conta Cont bil */
DO:
  
    assign v_ind_finalid_cta = "Conta Movimento".
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                   INPUT "APB",
                                                   INPUT "",
                                                   INPUT v_ind_finalid_cta,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).    

        IF v_cod_conta <> "" THEN
            ASSIGN ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0 = v_cod_conta
                   fi-desc-conta:SCREEN-VALUE IN FRAME fpage0 = v_des_titulo_conta.
        ELSE
            ASSIGN ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0 = ""
                   fi-desc-conta:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-lancto.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF ttint-rat-desp-lancto.ct-codigo IN FRAME fpage0 /* Conta Cont bil */
DO:
  
/*     run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  "",                 /* EMPRESA EMS 2 */                                             */
/*                                                        input  "",                 /* ESTABELECIMENTO EMS2 */                                      */
/*                                                        input  "",                 /* PLANO CONTAS */                                              */
/*                                                        input  ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0,          /* CONTA */  */
/*                                                        input  today,              /* DT TRANSACAO */                                              */
/*                                                        output p_log_ccusto,    /* UTILIZA CCUSTO ? */                                             */
/*                                                        output table tt_log_erro). /* ERROS */                                                     */

    RUN piDescConta IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-rat-desp-lancto.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttint-rat-desp-lancto.ct-codigo IN FRAME fpage0 /* Conta Cont bil */
DO:
  APPLY "f5" TO SELF.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenanceNoNavigation 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT g-inclusao THEN
        ASSIGN cb-lancto:SENSITIVE IN FRAME fpage0 = NO.

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
        FIND FIRST cta_ctbl NO-LOCK
            WHERE cta_ctbl.cod_cta_ctbl = ttint-rat-desp-lancto.ct-codigo NO-ERROR.
        IF  AVAIL cta_ctbl THEN
            ASSIGN fi-desc-conta:SCREEN-VALUE IN FRAME fpage0 = cta_ctbl.des_tit_ctbl.
        ELSE
            ASSIGN fi-desc-conta:SCREEN-VALUE IN FRAME fpage0 = "".

        CASE ttint-rat-desp-lancto.tipo-lancto:
            WHEN 1 THEN ASSIGN cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Transit¢ria".
            WHEN 2 THEN ASSIGN cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Despesa".
            WHEN 3 THEN ASSIGN cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Transferˆncia Recurso".
            
        END CASE.
    END.
    ELSE
        ASSIGN cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Transit¢ria".
           
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

   ASSIGN ttint-rat-desp-lancto.tipo-lancto = IF cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Transit¢ria"
                                              THEN 1
                                              ELSE IF cb-lancto:SCREEN-VALUE IN FRAME fpage0 = "Despesa"
                                                   THEN 2
                                                   ELSE 3.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy wMaintenanceNoNavigation 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE VALID-HANDLE(h_api_cta_ctbl)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

IF  VALID-HANDLE(h_api_cta_ctbl) THEN
    DELETE PROCEDURE h_api_cta_ctbl.

IF  VALID-HANDLE(h_api_ccusto) THEN
    DELETE PROCEDURE h_api_ccusto.
                                   
MESSAGE VALID-HANDLE(h_api_cta_ctbl)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescConta wMaintenanceNoNavigation 
PROCEDURE piDescConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN v_cod_conta = ttint-rat-desp-lancto.ct-codigo:SCREEN-VALUE IN FRAME fpage0.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                                   input        "",                       /* PLANO DE CONTAS */
                                                   input-output v_cod_conta,              /* CONTA */
                                                   input        TODAY,                    /* DATA TRANSACAO */   
                                                   output       v_des_titulo_conta,       /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,       /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).             /* ERROS */

    ASSIGN fi-desc-conta:SCREEN-VALUE IN FRAME fpage0 = v_des_titulo_conta.

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
    
    ASSIGN ttint-rat-desp-lancto.tipo-rateio = ttint-rat-desp.tipo-rateio.    
            
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

