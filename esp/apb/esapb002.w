&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{esinc\es0000.i}
{esp/es0018.i}
{upc/btb910za-upc.i}

/*
v_cod_usuar_corren
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.*/
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_ap          AS RECID        NO-UNDO.

DEFINE TEMP-TABLE tt-frete
    FIELD cod_estab     LIKE tit_ap.cod_estab
    field cod-esp       like tit_ap.cod_espec_docto
    field cdn_fornec    like fornec_financ.cdn_fornec
    field ep-codigo     like tit_ap.cod_empresa
    field cod-estabel   like tit_ap.cod_estab
    field nome-abrev    like emsuni.fornecedor.nom_abrev
    field nr-docto      like tit_ap.cod_tit_ap
    field parcela       like tit_ap.cod_parcela
    field dt-transacao  like tit_ap.dat_transacao
    field dt-vencimen   like tit_ap.dat_vencto_tit_ap
    field valor-saldo   like tit_ap.val_sdo_tit_ap
    field serie         like tit_ap.cod_ser_docto
    FIELD grp_fornec    LIKE tit_ap.cod_grp_fornec
    FIELD num_id_tit_ap LIKE tit_ap.num_id_tit_ap
    FIELD selecionado   AS LOGICAL LABEL 'Selec' FORMAT ' * /'
    INDEX id-frete IS PRIMARY UNIQUE cod_estab num_id_tit_ap.


DEFINE VARIABLE vcdn_fornecedor_ini    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE VARIABLE vcdn_fornecedor_fim    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE VARIABLE vdat_vencto_tit_ap_ini LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE VARIABLE vdat_vencto_tit_ap_fim LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE VARIABLE vcod_tit_ap_ini        LIKE tit_ap.cod_tit_ap         NO-UNDO.
DEFINE VARIABLE vcod_tit_ap_fim        LIKE tit_ap.cod_tit_ap         NO-UNDO.
DEFINE VARIABLE vcod_grp_fornec_ini    LIKE tit_ap.cod_grp_fornec     NO-UNDO.
DEFINE VARIABLE vcod_grp_fornec_fim    LIKE tit_ap.cod_grp_fornec     NO-UNDO.
DEFINE VARIABLE vcod_espec_docto       LIKE tit_ap.cod_espec_docto    NO-UNDO.

DEF VAR v_num_aux_2          AS   INT.
DEF VAR v_num_aux            AS   INT.
DEF VAR v_num_cont           AS   INT.
DEF VAR v_cod_refer_alt      LIKE movto_tit_ap.cod_refer.
def var c-arq-log as char format "x(40)".
DEF VAR l-teste AS LOGICAL NO-UNDO.
DEF VAR c-connect LIKE servid_rpc.des_carg_rpc NO-UNDO.

{esp\cms\apb767zc.i}

DEFINE TEMP-TABLE tt-erros LIKE tt_log_erros_tit_ap_alteracao.

DEF VAR hproc           AS HANDLE   NO-UNDO.
DEF VAR l-connect       AS LOGICAL  NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ambiente":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-teste = NO.
ELSE
    ASSIGN l-teste = YES.

IF  l-teste THEN DO:
    FIND FIRST servid_rpc NO-LOCK
        WHERE  servid_rpc.des_servid_rpc MATCHES "*teste*"
        AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
    IF  AVAIL  servid_rpc 
    THEN ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
END.
ELSE DO:
    /* a definir com o Braun, quando producao tiver dois servidores RPC */

    FIND FIRST servid_rpc NO-LOCK
        WHERE  servid_rpc.des_servid_rpc MATCHES "*produ*"
        AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
    IF  AVAIL  servid_rpc 
    THEN ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
END.

IF  c-connect = "" THEN DO:
    MESSAGE 'NÆo existe servidor RPC cadastrado. Processo interrompido.' VIEW-AS ALERT-BOX ERROR TITLE 'Erro RPC'.
    RETURN 'NOK'.
END.

CREATE SERVER hproc.
l-connect = hproc:CONNECT(c-connect).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-frete tit_ap

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-frete.selecionado tit_ap.cod_espec_docto tit_ap.cod_ser_docto tit_ap.cod_tit_ap tit_ap.cod_parcela tit_ap.cdn_fornec tit_ap.dat_vencto_tit_ap tit_ap.val_sdo_tit_ap   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH tt-frete, ~
               FIRST tit_ap NO-LOCK OF tt-frete     INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME}     FOR EACH tt-frete, ~
               FIRST tit_ap NO-LOCK OF tt-frete     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-frete tit_ap
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-frete
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 tit_ap


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btDet btFiltro btExit btHelp BROWSE-1 ~
btMarca btDesmarca fiNovo-vencimen btAtualiza RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fiNovo-vencimen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAtualiza 
     LABEL "Atualiza vencimentos" 
     SIZE 16.57 BY 1.

DEFINE BUTTON btDesmarca 
     IMAGE-UP FILE "image/im-ran_n.bmp":U
     LABEL "Desmarca" 
     SIZE 4 BY 1.25 TOOLTIP "Desmarca todos os registros do browse".

DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btMarca 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     LABEL "Marca" 
     SIZE 4 BY 1.25 TOOLTIP "Marca todos os registros do browse".

DEFINE VARIABLE fiNovo-vencimen AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova data para Vencimento dos t¡tulos" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.72 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-frete, 
      tit_ap SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      tt-frete.selecionado
        tit_ap.cod_espec_docto
        tit_ap.cod_ser_docto
        tit_ap.cod_tit_ap WIDTH 12
        tit_ap.cod_parcela
        tit_ap.cdn_fornec
        tit_ap.dat_vencto_tit_ap
        tit_ap.val_sdo_tit_ap
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 13.17
         FONT 1
         TITLE "T¡tulos" EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btDet AT ROW 1.13 COL 2 HELP
          "Pesquisa"
     btFiltro AT ROW 1.13 COL 6 HELP
          "Pesquisa"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     BROWSE-1 AT ROW 2.75 COL 1
     btMarca AT ROW 5.25 COL 87 HELP
          "Marca todos os registros do browse"
     btDesmarca AT ROW 6.75 COL 87 HELP
          "Desmarca todos os registros do browse"
     fiNovo-vencimen AT ROW 16.33 COL 57.29 COLON-ALIGNED
     btAtualiza AT ROW 16.33 COL 70.72
     RECT-1 AT ROW 16.17 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Atualizacao de Vencimento T¡tulo APB - ESAPB002"
         HEIGHT             = 16.79
         WIDTH              = 90
         MAX-HEIGHT         = 32.13
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 32.13
         VIRTUAL-WIDTH      = 164.57
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-1 btHelp DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-frete,
        FIRST tit_ap NO-LOCK OF tt-frete
    INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "movto_tit_acr.cdn_cliente = INTEGER(cod-cliente)
 AND movto_tit_acr.dat_transacao >= fi_dat_transacao
 AND movto_tit_acr.dat_transacao <= i-movto_tit_acredfim"
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Atualizacao de Vencimento T¡tulo APB - ESAPB002 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Atualizacao de Vencimento T¡tulo APB - ESAPB002 */
DO:
  /* This event will close the window and terminate the procedure.  */
  hproc:DISCONNECT().
  DELETE OBJECT hproc.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME DEFAULT-FRAME /* T¡tulos */
OR RETURN OF {&BROWSE-NAME} IN FRAME {&FRAME-NAME} DO:
    RUN pi-seleciona IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza C-Win
ON CHOOSE OF btAtualiza IN FRAME DEFAULT-FRAME /* Atualiza vencimentos */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} fiNovo-vencimen.

    RUN pi-atualiza-venctos (INPUT fiNovo-vencimen).
    RUN pi-gera-tt IN THIS-PROCEDURE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarca C-Win
ON CHOOSE OF btDesmarca IN FRAME DEFAULT-FRAME /* Desmarca */
DO:
    FOR EACH tt-frete:
        ASSIGN tt-frete.selecionado = NO.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF btDet IN FRAME DEFAULT-FRAME /* Mail */
OR 'F5' OF {&BROWSE-NAME} IN FRAME {&FRAME-NAME} DO:
  RUN pi-detalhe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro C-Win
ON CHOOSE OF btFiltro IN FRAME DEFAULT-FRAME /* Mail */
DO:

    RUN esp/apb/esapb002a.w(INPUT-OUTPUT vcdn_fornecedor_ini   , 
                            INPUT-OUTPUT vcdn_fornecedor_fim   , 
                            INPUT-OUTPUT vdat_vencto_tit_ap_ini, 
                            INPUT-OUTPUT vdat_vencto_tit_ap_fim, 
                            INPUT-OUTPUT vcod_tit_ap_ini       , 
                            INPUT-OUTPUT vcod_tit_ap_fim       ,
                            INPUT-OUTPUT vcod_grp_fornec_ini   ,
                            INPUT-OUTPUT vcod_grp_fornec_fim   , 
                            INPUT-OUTPUT vcod_espec_docto).
    RUN pi-gera-tt IN THIS-PROCEDURE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarca C-Win
ON CHOOSE OF btMarca IN FRAME DEFAULT-FRAME /* Marca */
DO:
    FOR EACH tt-frete:
        ASSIGN tt-frete.selecionado = YES.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
    RUN pi-detalhe IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ASSIGN /*fiData-fim   = DATE(MONTH(TODAY), 1, YEAR(TODAY)).*/
            fiNovo-vencimen        = ?
            vcdn_fornecedor_ini    = 0
            vcdn_fornecedor_fim    = 999999999
            vdat_vencto_tit_ap_ini = DATE(MONTH(TODAY), 1, YEAR(TODAY))
            vdat_vencto_tit_ap_fim = TODAY
            vcod_tit_ap_ini        = ""
            vcod_tit_ap_fim        = "999999999"
            vcod_grp_fornec_ini    = ""
            vcod_grp_fornec_fim    = "ZZZZZZ"
            vcod_espec_docto       = "".

    RUN enable_UI.
    APPLY "CHOOSE" TO btFiltro IN FRAME {&FRAME-NAME}.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fiNovo-vencimen 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btDet btFiltro btExit btHelp BROWSE-1 btMarca btDesmarca 
         fiNovo-vencimen btAtualiza RECT-1 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-Abre-Edit C-Win 
PROCEDURE Pi-Abre-Edit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pArquivo AS CHAR FORM "x(40)" NO-UNDO.
    DEF VAR vCodKeyValue  AS CHAR FORM "x(08)" NO-UNDO.

    GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE vCodKeyValue.
    if vCodKeyValue = "" OR vCodKeyValue = ?  THEN 
    DO.
      ASSIGN vCodKeyValue = 'start'.
      PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE vCodKeyValue NO-ERROR.
    END. /* End do - if vCodKeyValue = "" OR vCodKeyValue = ? */

    OS-COMMAND SILENT VALUE(vCodKeyValue + CHR(32) + pArquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-venctos C-Win 
PROCEDURE pi-atualiza-venctos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pNovo-vencimen AS DATE NO-UNDO.

    DEFINE VARIABLE v_log AS CHARACTER FORMAT '!!!' NO-UNDO.
    DEFINE VARIABLE v_data_aux AS CHAR.

    FOR EACH tt_tit_ap_alteracao_base_1 EXCLUSIVE-LOCK:
       DELETE tt_tit_ap_alteracao_base_1.
    END.
        
    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK: 
       DELETE tt_log_erros_tit_ap_alteracao. 
    END.

    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK:
        DELETE tt_log_erros_tit_ap_alteracao. 
    END.
    FOR EACH tt-erros:
        DELETE tt-erros.
    END.
    IF pNovo-vencimen = ? OR pNovo-vencimen <= TODAY THEN DO:
        MESSAGE 'Deve ser informada uma data maior que a atual para o novo vencimento dos t¡tulos.'
            VIEW-AS ALERT-BOX ERROR TITLE 'Erro altera‡Æo t¡tulos'.
        RETURN 'NOK'.
    END.
    SESSION:SET-WAIT-STATE("general":U). 
    IF NOT CAN-FIND(FIRST tt-frete WHERE tt-frete.selecionado) THEN DO:
        MESSAGE 'Deve haver ao menos um t¡tulo selecionado para a altera‡Æo.'
            VIEW-AS ALERT-BOX ERROR TITLE 'Erro altera‡Æo t¡tulos'.
        RETURN 'NOK'.
    END.
    SESSION:SET-WAIT-STATE("general":U). 

    FOR EACH  tt-frete
        WHERE tt-frete.selecionado:

        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab = v_cod_estab_usuar
             AND   tit_ap.num_id_tit_ap = tt-frete.num_id_tit_ap NO-ERROR.
        
        IF NOT AVAIL tit_ap THEN NEXT.
        
        /*Calcula referencia automatica*/
        ASSIGN v_num_aux_2  = integer(this-procedure:handle).

        assign v_data_aux  = string(TODAY,"999999")
               v_cod_refer_alt = substring(v_data_aux,7,2)
                                 + substring(v_data_aux,3,2)
                                 + substring(v_data_aux,1,2)
                                 + "V".

        repeat:       
          do v_num_cont = 1 to 3:
              ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
                     v_cod_refer_alt = v_cod_refer_alt + chr(v_num_aux).
          end.

          find first movto_tit_ap 
               where movto_tit_ap.cod_estab = v_cod_estab_usuar
               and   movto_tit_ap.cod_refer = v_cod_refer_alt no-lock no-error.

          FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK
              WHERE  tt_tit_ap_alteracao_base_1.ttv_cod_refer =  v_cod_refer_alt NO-ERROR.

          IF AVAIL movto_tit_ap THEN NEXT.
          ELSE LEAVE.
        end.                                       

/*        MESSAGE tt-frete.selecionado SKIP
                tit_ap.cod_tit_ap
            VIEW-AS ALERT-BOX INFO BUTTONS OK. */
        /*Cria temp-table com as informa»„es dos t­tulos para altera»’o no APB. */       
        CREATE tt_tit_ap_alteracao_base_1.
        ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             =  v_cod_usuar_corren
               tt_tit_ap_alteracao_base_1.tta_cod_empresa                  =  tit_ap.cod_empresa
               tt_tit_ap_alteracao_base_1.tta_cod_estab                    =  tit_ap.cod_estab
               tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap                =  tit_ap.num_id_tit_ap
               tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                   =  RECID(tt_tit_ap_alteracao_base_1)
               tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor               =  tit_ap.cdn_fornecedor
               tt_tit_ap_alteracao_base_1.tta_cod_espec_docto              =  tit_ap.cod_espec_docto
               tt_tit_ap_alteracao_base_1.tta_cod_ser_docto                =  tit_ap.cod_ser_docto
               tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                   =  tit_ap.cod_tit_ap
               tt_tit_ap_alteracao_base_1.tta_cod_parcela                  =  tit_ap.cod_parcela
               tt_tit_ap_alteracao_base_1.ttv_dat_transacao                =  TODAY
               tt_tit_ap_alteracao_base_1.ttv_cod_refer                    =  v_cod_refer_alt
               tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap               =  ? 
               tt_tit_ap_alteracao_base_1.tta_dat_emis_docto               =  ?
               tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap            =  pNovo-vencimen
               tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto               =  pNovo-vencimen
               tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto                =  ?                  
               tt_tit_ap_alteracao_base_1.tta_num_dias_atraso              =  tit_ap.num_dias_atraso
               tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso        =  tit_ap.val_perc_multa_atraso
               tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso         =  tit_ap.val_juros_dia_atraso
               tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso    =  tit_ap.val_perc_juros_dia_atraso
               tt_tit_ap_alteracao_base_1.tta_dat_desconto                 =  ?
               tt_tit_ap_alteracao_base_1.tta_val_perc_desc                =  tit_ap.val_perc_desc      
               tt_tit_ap_alteracao_base_1.tta_val_desconto                 =  tit_ap.val_desconto   
               tt_tit_ap_alteracao_base_1.tta_cod_portador                 =  tit_ap.cod_portador     
               tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov             =  ""                 
               tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo             =  tit_ap.log_pagto_bloqdo
               tt_tit_ap_alteracao_base_1.tta_cod_seguradora               =  tit_ap.cod_seguradora  
               tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro              =  tit_ap.cod_apol_seguro
               tt_tit_ap_alteracao_base_1.tta_cod_arrendador               =  tit_ap.cod_arrendador   
               tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas             =  tit_ap.cod_contrat_leas  
               tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto          =  tit_ap.ind_tip_espec_docto 
               tt_tit_ap_alteracao_base_1.tta_cod_indic_econ               =  tit_ap.cod_indic_econ  
               tt_tit_ap_alteracao_base_1.tta_num_seq_refer                =  ?
               tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap   =  "Altera‡Æo"
               tt_tit_ap_alteracao_base_1.ttv_wgh_lista                    =  ?           
               tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores  =  NO                 
               tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor        =  ""
               tt_tit_ap_alteracao_base_1.tta_cod_histor_padr              =  ""
               tt_tit_ap_alteracao_base_1.tta_des_histor_padr              =  ""                 
               tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               =  tit_ap.ind_sit_tit_ap    
               tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              =  tit_ap.cod_forma_pagto   
               tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                =  "" .
        RELEASE tt_tit_ap_alteracao_base_1.
        
        /*
        IF l-connect THEN
            RUN prgfin/apb/apb767zc.py ON SERVER hproc (INPUT 1,
                                                        INPUT "APB",
                                                        INPUT "",        /*cod_matriz_trad_org_ext*/
                                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                                        INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                                        OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
        ELSE
        */
        
        RUN prgfin/apb/apb767zc.py (INPUT 1,
                                    INPUT "APB",
                                    INPUT "",        /*cod_matriz_trad_org_ext*/
                                    INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                    INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                    OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
          
        FOR EACH  tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK
            WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem = 6.788:
            DELETE tt_log_erros_tit_ap_alteracao.
        END.

        FOR EACH tt_log_erros_tit_ap_alteracao:
            CREATE tt-erros.
            BUFFER-COPY tt_log_erros_tit_ap_alteracao TO tt-erros.
            DELETE tt_log_erros_tit_ap_alteracao.
        END.

        FOR EACH tt_tit_ap_alteracao_base_1 EXCLUSIVE-LOCK:
           DELETE tt_tit_ap_alteracao_base_1.
        END.

        FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK: 
           DELETE tt_log_erros_tit_ap_alteracao. 
        END.

    END.
    
    FOR EACH tt-erros:
        CREATE tt_log_erros_tit_ap_alteracao.
        BUFFER-COPY tt-erros TO tt_log_erros_tit_ap_alteracao.
        DELETE tt-erros.
    END.

    SESSION:SET-WAIT-STATE("":U). 
    /*Valida se ocorreu erro durante o processamento*/
    FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
       /*
       MESSAGE "Ocorreu erro na atualiza‡Æo de alguns vencimentos. Consultar o arquivo de log: " SKIP 
               " c:\tmp\erro.txt" VIEW-AS ALERT-BOX.*/
       OUTPUT TO c:\tmp\erro.txt NO-CONVERT.
       FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK:
           DISP tt_log_erros_tit_ap_alteracao.tta_cod_estab
                tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor
                tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto
                tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto
                tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap
                tt_log_erros_tit_ap_alteracao.tta_cod_parcela
                tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  FORMAT "x(80)"
                tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda FORMAT "x(100)" 
               WITH WIDTH 450 STREAM-IO DOWN.
           /*
           PUT "Estab: "     tt_log_erros_tit_ap_alteracao.tta_cod_estab       " ; "       
               "Fornec: "    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  " ; "     
               "espec: "    tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto " ; "    
               "serie "     tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   " ; "    
               "t­tulo: "   tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      " ; "    
               "Parc: "     tt_log_erros_tit_ap_alteracao.tta_cod_parcela     " ; "    
               "Num Msg: "   tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  " ; "       
               "Desc Msg: "  tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  " ; "       
               "Ajuda Msg: " tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. */
       END.
       OUTPUT CLOSE.
       RUN pi-abre-edit (INPUT "c:\tmp\erro.txt").
    END.
    ELSE MESSAGE 'Altera‡Æo efetuada com sucesso.' 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RUN piPedeArquivo.
    IF c-arq-log = "" THEN
        MESSAGE "Arquivo nÆo foi informado. NÆo ser  impresso t¡tulos "
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    ELSE DO:
        output to value(c-arq-log).

        PUT SKIP 
            'Nova Data de Vencimento: ' pNovo-vencimen SKIP.

        FOR EACH  tt-frete
            WHERE tt-frete.selecionado:

            FIND FIRST tit_ap NO-LOCK
                 WHERE tit_ap.cod_estab = v_cod_estab_usuar
                 AND   tit_ap.num_id_tit_ap = tt-frete.num_id_tit_ap NO-ERROR.
            
            IF tt-frete.dt-vencimen <>  tit_ap.dat_vencto_tit_ap THEN
                 ASSIGN v_log = 'OK'.
            ELSE ASSIGN v_log = '*'.
            
            disp tit_ap.cod_estab      COLUMN-LABEL 'Est'
                 tt-frete.cdn_fornec   COLUMN-LABEL 'Forn'
                 tt-frete.nome-abrev  
                 tt-frete.cod-esp      FORMAT 'x(3)' COLUMN-LABEL 'Esp'
                 tt-frete.serie        COLUMN-LABEL 'Ser'
                 tt-frete.nr-docto     FORMAT 'x(10)'
                 tt-frete.parcela     
                 tt-frete.dt-transacao
                 tt-frete.valor-saldo 
                 tt-frete.grp_fornec 
                 tt-frete.dt-vencimen        COLUMN-LABEL 'VenctoAnt'
                 v_log
                 with width 180 STREAM-IO.
        end.
        output close.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe C-Win 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAILABLE tit_ap AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN DO:
        ASSIGN v_rec_tit_ap = RECID(tit_ap).
        RUN prgfin/apb/apb002ia.p.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt C-Win 
PROCEDURE pi-gera-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR d-data AS DATE FORMAT "99/99/9999" NO-UNDO.
        
    SESSION:SET-WAIT-STATE("general":U). 
    EMPTY TEMP-TABLE tt-frete.

    FOR EACH  tit_ap NO-LOCK
        WHERE tit_ap.cod_estab          = v_cod_estab_usuar
        AND   tit_ap.cod_espec_docto    = vcod_espec_docto
        and   tit_ap.log_sdo_tit_ap     = YES
        AND   tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini
        AND   tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim:
        /*
        AND   tit_ap.cod_tit_ap        >= vcod_tit_ap_ini
        AND   tit_ap.cod_tit_ap        <= vcod_tit_ap_fim
        AND   tit_ap.cdn_fornec        >= vcdn_fornecedor_ini 
        AND   tit_ap.cdn_fornec        <= vcdn_fornecedor_fim 
        AND   tit_ap.cod_grp_fornec    >= vcod_grp_fornec_ini 
        AND   tit_ap.cod_grp_fornec    <= vcod_grp_fornec_fim:
        */
        IF tit_ap.val_sdo_tit_ap = 0  THEN NEXT.

        IF tit_ap.cod_tit_ap        < vcod_tit_ap_ini
        OR tit_ap.cod_tit_ap        > vcod_tit_ap_fim THEN NEXT.
        IF tit_ap.cdn_fornec        < vcdn_fornecedor_ini 
        OR tit_ap.cdn_fornec        > vcdn_fornecedor_fim THEN NEXT.
        IF tit_ap.cod_grp_fornec    < vcod_grp_fornec_ini 
        OR tit_ap.cod_grp_fornec    > vcod_grp_fornec_fim THEN NEXT.

        FIND FIRST emsuni.fornecedor OF tit_ap NO-LOCK NO-ERROR.
        /*ASSIGN v_val_mont_alt_sel = v_val_mont_alt_sel + tit_ap.val_sdo_tit_ap.*/
        CREATE tt-frete.
        ASSIGN tt-frete.cod_estab = tit_ap.cod_estab
               tt-frete.num_id_tit_ap = tit_ap.num_id_tit_ap.
        ASSIGN tt-frete.dt-transacao    = tit_ap.dat_transacao
               tt-frete.cod-esp         = tit_ap.cod_espec_docto                   
               tt-frete.cdn_fornec      = fornecedor.cdn_fornec
               tt-frete.cod-estabel     = tit_ap.cod_estab                         
               tt-frete.ep-codigo       = tit_ap.cod_empresa                       
               tt-frete.serie           = tit_ap.cod_ser_docto                     
               tt-frete.nome-abrev      = emsuni.fornecedor.nom_abrev
               tt-frete.nr-docto        = tit_ap.cod_tit_ap                        
               tt-frete.parcela         = tit_ap.cod_parcela                       
               tt-frete.dt-vencimen     = tit_ap.dat_vencto_tit_ap                 
               tt-frete.dt-transacao    = tit_ap.dat_transacao                     
               tt-frete.valor-saldo     = tit_ap.val_sdo_tit_ap                    
               tt-frete.grp_fornec      = emsuni.fornecedor.cod_grp_fornec.
    END.

/*
        for each tit-ap no-lock
           where tit-ap.tp-codigo = 3  val_movto_ap.cod_tip_fluxo_financ
             and tit-ap.ep-codigo = 1 cod_estab
             and tit-ap.cod-estabel = "1" cod_empresa
             and tit-ap.dt-vencimen <= da-data-fim
             and tit-ap.valor-saldo > 0               val_sdo_tit_aP
             and not tit-ap.log-1:
            create tt-frete.
            assign tt-frete.reg = recid(tit-ap).
        end.
*/
    SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona C-Win 
PROCEDURE pi-seleciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAILABLE tt-frete AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN DO:
        ASSIGN tt-frete.selecionado = NOT tt-frete.selecionado.
        DISPLAY tt-frete.selecionado WITH BROWSE {&BROWSE-NAME}.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedeArquivo C-Win 
PROCEDURE piPedeArquivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       ASSIGN c-arq-log = "c:\tmp".
       DEFINE BUTTON btGoToOK     AUTO-GO      LABEL "&OK"       SIZE 10 BY 1 BGCOLOR 8.
       DEFINE BUTTON btGoToCancel AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1 BGCOLOR 8.
       DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 70 BY 1.3 BGCOLOR 8.
       DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 70 BY 1.5 BGCOLOR 7.
       DEFINE VARIABLE fiCodArq AS CHAR LABEL "Arquivo Log" VIEW-AS FILL-IN  SIZE 50 BY .88 NO-UNDO.

       DEFINE FRAME fTela
              fiCodArq          AT ROW 1.17 COL 10 COLON-ALIGN FORMAT "x(50)"
              rtGoToFields      AT ROW 1    COL 1
              btGoToOK          AT ROW 2.7  COL 2.14
              btGoToCancel      AT ROW 2.7  COL 13.14
              rtGoToButton      AT ROW 2.5  COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                THREE-D SCROLLABLE TITLE "Informe arquivo da rela‡Æo de Documentos" FONT 1
                DEFAULT-BUTTON btGoToOK.

       ON  "CHOOSE":U OF btGoToOK IN FRAME fTela DO:
           ASSIGN fiCodArq.
           ASSIGN c-arq-log = fiCodArq.
           APPLY "GO":U TO FRAME fTela.
           /*
           FILE-INFO:FILE-NAME = fiCodArq.
           IF FILE-INFO:FILE-TYPE = "FRW" THEN
           DO:
           END.
           ELSE DO:
               MESSAGE "Arquivo informado inv lido. Verifique diret¢rio"
                   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
               RETURN NO-APPLY.
           END.*/
       END.
       ON  "CHOOSE":U OF btGoToCancel IN FRAME fTela DO:
           ASSIGN c-arq-log = "".
           APPLY "GO":U TO FRAME fTela.
       END.
       DISP c-arq-log @ fiCodArq
            WITH FRAME fTela.

       ENABLE fiCodArq
              btGoToOK 
              btGoToCancel
              WITH FRAME fTela.

       WAIT-FOR "GO":U OF FRAME fTela.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

