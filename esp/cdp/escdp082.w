&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp082 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE VARIABLE c-desc-conta AS CHARACTER   NO-UNDO.
DEFINE BUFFER b-int-desp-cta-ctbl FOR int-desp-cta-ctbl.
DEFINE VARIABLE  h_api_cta_ctbl  AS HANDLE      NO-UNDO.

def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    .

{utp/ut-glob.i}

DEFINE INPUT PARAM p-tp-codigo LIKE tipo-rec-desp.tp-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-contas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-desp-cta-ctbl

/* Definitions for BROWSE br-contas                                     */
&Scoped-define FIELDS-IN-QUERY-br-contas int-desp-cta-ctbl.cod-cta-ctbl ~
fnDescConta(int-desp-cta-ctbl.cod-cta-ctbl) @ c-desc-conta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contas ~
int-desp-cta-ctbl.cod-cta-ctbl 
&Scoped-define ENABLED-TABLES-IN-QUERY-br-contas int-desp-cta-ctbl
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-contas int-desp-cta-ctbl
&Scoped-define QUERY-STRING-br-contas FOR EACH int-desp-cta-ctbl ~
      WHERE int-desp-cta-ctbl.tp-codigo = input frame f-cad i-tp-codigo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-contas OPEN QUERY br-contas FOR EACH int-desp-cta-ctbl ~
      WHERE int-desp-cta-ctbl.tp-codigo = input frame f-cad i-tp-codigo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-contas int-desp-cta-ctbl
&Scoped-define FIRST-TABLE-IN-QUERY-br-contas int-desp-cta-ctbl


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-contas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button br-contas bt-incluir bt-excluir ~
bt-ok 
&Scoped-Define DISPLAYED-OBJECTS i-tp-codigo c-desc-tp-codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescConta w-cadsim 
FUNCTION fnDescConta RETURNS CHARACTER
  ( p-cod-cta-ctbl AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-excluir 
     LABEL "Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-desc-tp-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-codigo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contas FOR 
      int-desp-cta-ctbl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contas w-cadsim _STRUCTURED
  QUERY br-contas NO-LOCK DISPLAY
      int-desp-cta-ctbl.cod-cta-ctbl COLUMN-LABEL "Conta Cont bil" FORMAT "x(20)":U
      fnDescConta(int-desp-cta-ctbl.cod-cta-ctbl) @ c-desc-conta COLUMN-LABEL "Descri‡Æo" FORMAT "x(80)":U
            WIDTH 54.14
  ENABLE
      int-desp-cta-ctbl.cod-cta-ctbl
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 7.25
         FONT 7
         TITLE "Contas" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     i-tp-codigo AT ROW 1.58 COL 7 COLON-ALIGNED WIDGET-ID 6
     c-desc-tp-codigo AT ROW 1.58 COL 12.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     br-contas AT ROW 3 COL 2 WIDGET-ID 200
     bt-incluir AT ROW 10.63 COL 2 WIDGET-ID 2
     bt-excluir AT ROW 10.63 COL 13 WIDGET-ID 4
     bt-ok AT ROW 12.21 COL 3
     bt-cancela AT ROW 12.21 COL 14
     bt-imprime AT ROW 12.21 COL 25
     bt-ajuda AT ROW 12.21 COL 69
     rt-button AT ROW 12 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 12.54
         WIDTH              = 80
         MAX-HEIGHT         = 29.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.71
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-contas c-desc-tp-codigo f-cad */
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME f-cad           = TRUE
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-tp-codigo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tp-codigo IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contas
/* Query rebuild information for BROWSE br-contas
     _TblList          = "mgesp.int-desp-cta-ctbl"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.int-desp-cta-ctbl.tp-codigo = input frame f-cad i-tp-codigo"
     _FldNameList[1]   > mgesp.int-desp-cta-ctbl.cod-cta-ctbl
"int-desp-cta-ctbl.cod-cta-ctbl" "Conta Cont bil" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescConta(int-desp-cta-ctbl.cod-cta-ctbl) @ c-desc-conta" "Descri‡Æo" "x(80)" ? ? ? ? ? ? ? no ? no no "54.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-contas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contas
&Scoped-define SELF-NAME br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas w-cadsim
ON ROW-LEAVE OF br-contas IN FRAME f-cad /* Contas */
DO:
    RUN pi-valida.

    IF RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    IF INPUT BROWSE br-contas int-desp-cta-ctbl.cod-cta-ctbl = "" THEN DO:
        APPLY "choose" TO bt-excluir.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas w-cadsim
ON VALUE-CHANGED OF br-contas IN FRAME f-cad /* Contas */
DO:
  br-contas:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir w-cadsim
ON CHOOSE OF bt-excluir IN FRAME f-cad /* Excluir */
DO:
  FIND FIRST b-int-desp-cta-ctbl OF int-desp-cta-ctbl EXCLUSIVE-LOCK NO-ERROR.

  IF AVAIL b-int-desp-cta-ctbl THEN DO:
      DELETE b-int-desp-cta-ctbl.
      {&open-query-br-contas}
      APPLY "entry":U TO int-desp-cta-ctbl.cod-cta-ctbl IN BROWSE br-contas. 
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime w-cadsim
ON CHOOSE OF bt-imprime IN FRAME f-cad /* Imprimir */
DO:
run utp/ut-relat.w persistent set wh-imprime (input c-programa-mg97).
if valid-handle(wh-imprime) then
  run dispatch in wh-imprime ('initialize':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-cadsim
ON CHOOSE OF bt-incluir IN FRAME f-cad /* Incluir */
DO:
  CREATE int-desp-cta-ctbl.
  ASSIGN int-desp-cta-ctbl.tp-codigo = INPUT FRAME f-cad i-tp-codigo.

  {&open-query-br-contas}

  APPLY "entry":U to int-desp-cta-ctbl.cod-cta-ctbl IN BROWSE br-contas. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tp-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-codigo w-cadsim
ON LEAVE OF i-tp-codigo IN FRAME f-cad /* Despesa */
DO:
  FIND FIRST tipo-rec-desp NO-LOCK
       WHERE tipo-rec-desp.tp-codigo = INT(i-tp-codigo:SCREEN-VALUE IN FRAME f-cad) NO-ERROR.

  IF AVAIL tipo-rec-desp THEN
      ASSIGN c-desc-tp-codigo:SCREEN-VALUE IN FRAME f-cad = tipo-rec-desp.descricao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.

ON 'f5':U OF int-desp-cta-ctbl.cod-cta-ctbl IN BROWSE br-contas DO:

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  v_cdn_empres_usuar,  /* EMPRESA EMS2 */
                                                   input  "CEP",              /* M…DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  TODAY, /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    IF v_cod_cta_ctbl <> "" THEN DO:
        ASSIGN int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas = v_cod_cta_ctbl.

        RUN pi-valida.
        IF RETURN-VALUE <> "OK" THEN
            RETURN NO-APPLY.

        FIND FIRST b-int-desp-cta-ctbl OF int-desp-cta-ctbl EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL b-int-desp-cta-ctbl THEN DO:
            ASSIGN b-int-desp-cta-ctbl.cod-cta-ctbl = v_cod_cta_ctbl.
            {&open-query-br-contas}
        END.
    END.

    RETURN "OK".
END.

ON 'leave':U OF int-desp-cta-ctbl.cod-cta-ctbl DO:
    IF AVAIL int-desp-cta-ctbl THEN
        DISPLAY fnDescConta(int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas) @ c-desc-conta WITH BROWSE br-contas.
    RETURN "OK".
END.
/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY i-tp-codigo c-desc-tp-codigo 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button br-contas bt-incluir bt-excluir bt-ok 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "escdp082" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

  ASSIGN i-tp-codigo = p-tp-codigo.

  DISPLAY i-tp-codigo @ i-tp-codigo WITH FRAME f-cad.

  {&open-query-br-contas}

  APPLY 'leave' TO i-tp-codigo IN FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida w-cadsim 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST cta_ctbl NO-LOCK
         WHERE cta_ctbl.cod_cta_ctbl = int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas  NO-ERROR.

    IF NOT AVAIL cta_ctbl
    AND int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas <> "" 
    AND int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas <> ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 2,
                           INPUT "Conta Cont bil").

        RETURN "NOK".
    END.

    FIND FIRST b-int-desp-cta-ctbl NO-LOCK
         WHERE b-int-desp-cta-ctbl.cod-cta-ctbl = int-desp-cta-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-contas
           AND ROWID(b-int-desp-cta-ctbl) <> ROWID(int-desp-cta-ctbl) NO-ERROR.

    IF AVAIL b-int-desp-cta-ctbl THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Conta j  cadastrada para despesa " + STRING(b-int-desp-cta-ctbl.tp-codigo)).

        RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "int-desp-cta-ctbl"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescConta w-cadsim 
FUNCTION fnDescConta RETURNS CHARACTER
  ( p-cod-cta-ctbl AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND FIRST cta_ctbl NO-LOCK
     WHERE cta_ctbl.cod_cta_ctbl = p-cod-cta-ctbl NO-ERROR.

IF AVAIL cta_ctbl THEN
    RETURN cta_ctbl.des_tit_ctbl.
ELSE
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

