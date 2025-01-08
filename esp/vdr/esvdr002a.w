&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/vdr/esvdr002a
**     Descricao .......: Relat¢rio 
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 09/12/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.

{esp\vdr\esvdr002tt.i}

DEF INPUT PARAM p_cdn_cliente_ini          AS INT  FORMAT ">>>,>>>,>>9" NO-UNDO.
DEF INPUT PARAM p_cdn_cliente_fim          AS INT  FORMAT ">>>,>>>,>>9" NO-UNDO.
DEF INPUT PARAM p_cod_portador_ini         AS CHAR FORMAT "x(5)"        NO-UNDO.
DEF INPUT PARAM p_cod_portador_fim         AS CHAR FORMAT "x(5)"        NO-UNDO.
DEF INPUT PARAM p_dat_fechto_vendor_ini    AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF INPUT PARAM p_dat_fechto_vendor_fim    AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF INPUT PARAM p_num_planilha_vendor_ini  AS INT  FORMAT ">>>,>>>,>>9" NO-UNDO.
DEF INPUT PARAM p_num_planilha_vendor_fim  AS INT  FORMAT ">>>,>>>,>>9" NO-UNDO.
DEF INPUT PARAM p-selecao                  AS INT                       NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-plan.

DEF TEMP-TABLE tt-planilha
    FIELD num_planilha_vendor      LIKE planilha_vendor.num_planilha_vendor
    FIELD cdn_cliente              LIKE planilha_vendor.cdn_cliente
    FIELD cod_portador             LIKE planilha_vendor.cod_portador
    FIELD cod_estab                LIKE planilha_vendor.cod_estab
    FIELD l_ok                     AS CHAR FORMAT "x(1)" LABEL " ".

 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat
&Scoped-define BROWSE-NAME br-planilha

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-planilha

/* Definitions for BROWSE br-planilha                                   */
&Scoped-define FIELDS-IN-QUERY-br-planilha tt-planilha.l_ok tt-planilha.num_planilha_vendor tt-planilha.cdn_cliente tt-planilha.cod_portador   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-planilha   
&Scoped-define SELF-NAME br-planilha
&Scoped-define QUERY-STRING-br-planilha FOR EACH tt-planilha
&Scoped-define OPEN-QUERY-br-planilha OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha.
&Scoped-define TABLES-IN-QUERY-br-planilha tt-planilha
&Scoped-define FIRST-TABLE-IN-QUERY-br-planilha tt-planilha


/* Definitions for FRAME f-relat                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-relat ~
    ~{&OPEN-QUERY-br-planilha}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-todos bt-nenhum bt-ok bt-cancel ~
num-planilha br-planilha RECT-2 RECT-30 RECT-31 
&Scoped-Define DISPLAYED-OBJECTS num-planilha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancel 
     LABEL "Cancela" 
     SIZE 11.14 BY 1 TOOLTIP "Cancela"
     FONT 1.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 11.14 BY 1 TOOLTIP "Retirar a seleá∆o de todos os registros"
     FONT 1.

DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 11.14 BY 1 TOOLTIP "OK"
     FONT 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 11.14 BY 1 TOOLTIP "Selecionar todos os registros"
     FONT 1.

DEFINE VARIABLE num-planilha AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Planilha Vendor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 57 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.86 BY 8.75.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.86 BY 1.79.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-planilha FOR 
      tt-planilha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-planilha C-Win _FREEFORM
  QUERY br-planilha DISPLAY
      tt-planilha.l_ok
        tt-planilha.num_planilha_vendor 
        tt-planilha.cdn_cliente         
        tt-planilha.cod_portador
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54.43 BY 6.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-todos AT ROW 10.92 COL 34.14
     bt-nenhum AT ROW 10.92 COL 45.86
     bt-ok AT ROW 12.58 COL 2
     bt-cancel AT ROW 12.58 COL 13.72
     num-planilha AT ROW 1.75 COL 23.57 COLON-ALIGNED HELP
          "N£mero Planilha Vendor"
     br-planilha AT ROW 3.96 COL 2.57
     " Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.17 COL 3
          FONT 6
     " Inclus∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.13 COL 3
          FONT 6
     RECT-2 AT ROW 12.29 COL 1
     RECT-30 AT ROW 3.38 COL 1.29
     RECT-31 AT ROW 1.25 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57.43 BY 13.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Seleá∆o de Planilha Vendor - ESVDR002A"
         COLUMN             = 77.72
         ROW                = 9.63
         HEIGHT             = 13.25
         WIDTH              = 57.43
         MAX-HEIGHT         = 40.96
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 40.96
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   Custom                                                               */
/* BROWSE-TAB br-planilha num-planilha f-relat */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-planilha
/* Query rebuild information for BROWSE br-planilha
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-planilha */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Seleá∆o de Planilha Vendor - ESVDR002A */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Seleá∆o de Planilha Vendor - ESVDR002A */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-planilha
&Scoped-define SELF-NAME br-planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-planilha C-Win
ON MOUSE-SELECT-DBLCLICK OF br-planilha IN FRAME f-relat
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-planilha C-Win
ON RETURN OF br-planilha IN FRAME f-relat
DO:
    IF AVAIL tt-planilha THEN DO:
        if tt-planilha.l_ok = "*" then
            assign tt-planilha.l_ok = "" .
        else
            assign tt-planilha.l_ok = "*".

        self:refresh().    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancel C-Win
ON CHOOSE OF bt-cancel IN FRAME f-relat /* Cancela */
DO:
    APPLY "close" TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum C-Win
ON CHOOSE OF bt-nenhum IN FRAME f-relat /* Nenhum */
DO:
    FOR EACH tt-planilha:
        ASSIGN tt-planilha.l_ok = " ".
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    /*
    IF br-planilha:NUM-SELECTED-ROWS > 0 THEN
        br-planilha:DESELECT-ROWS().
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok C-Win
ON CHOOSE OF bt-ok IN FRAME f-relat /* OK */
DO:

  FOR EACH tt-plan:
      DELETE tt-plan.
  END.

  FOR EACH tt-planilha
      WHERE tt-planilha.l_ok = "*":

      CREATE tt-plan.
      ASSIGN tt-plan.num_planilha_vendor = tt-planilha.num_planilha_vendor
             tt-plan.cdn_cliente         = tt-planilha.cdn_cliente
             tt-plan.cod_portador        = tt-planilha.cod_portador
             tt-plan.cod_estab           = tt-planilha.cod_estab.
  END.

  APPLY "close" TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos C-Win
ON CHOOSE OF bt-todos IN FRAME f-relat /* Todos */
DO:

    FOR EACH tt-planilha:
        ASSIGN tt-planilha.l_ok = "*".
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

  /*
    IF br-planilha:NUM-ITERATIONS > 0 THEN
        br-planilha:SELECT-ALL().
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME num-planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL num-planilha C-Win
ON RETURN OF num-planilha IN FRAME f-relat /* Planilha Vendor */
DO:
  FIND FIRST tt-planilha NO-LOCK 
      WHERE tt-planilha.num_planilha_vendor = INPUT FRAME {&FRAME-NAME} num-planilha NO-ERROR.
  IF AVAIL tt-planilha THEN DO:
      MESSAGE "Planilha j† foi digitada"
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "entry" TO num-planilha.
  END.
  ELSE DO:
      FIND FIRST planilha_vendor NO-LOCK
         WHERE planilha_vendor.cod_estab                = v_cod_estab_usuar
         AND   planilha_vendor.num_planilha_vendor      = INPUT FRAME {&FRAME-NAME} num-planilha
         AND   planilha_vendor.cod_empresa              = v_cod_empres_usuar
         AND   planilha_vendor.ind_sit_planilha_vendor  <> "Cancelada" NO-ERROR.
      IF AVAIL planilha_vendor THEN DO:
          CREATE tt-planilha.
          ASSIGN tt-planilha.num_planilha_vendor = planilha_vendor.num_planilha_vendor
                 tt-planilha.cdn_cliente         = planilha_vendor.cdn_cliente
                 tt-planilha.cod_portador        = planilha_vendor.cod_portador
                 tt-planilha.l_ok                = "*".

          {&OPEN-QUERY-{&BROWSE-NAME}}
      END.
      ELSE DO:
          MESSAGE "Planilha informada n∆o est† cadastrada ou est† Cancelada"
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "entry" TO num-planilha.
      END.

  END.  
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

  RUN enable_UI.

  run pi-monta-browse.

  APPLY "entry" TO num-planilha.

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
  DISPLAY num-planilha 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE bt-todos bt-nenhum bt-ok bt-cancel num-planilha br-planilha RECT-2 
         RECT-30 RECT-31 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-browse C-Win 
PROCEDURE pi-monta-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF p-selecao = 1 THEN DO:
        FOR EACH planilha_vendor NO-LOCK
            WHERE planilha_vendor.cod_estab            = v_cod_estab_usuar
            AND   planilha_vendor.num_planilha_vendor >= p_num_planilha_vendor_ini
            AND   planilha_vendor.num_planilha_vendor <= p_num_planilha_vendor_fim
            AND   planilha_vendor.cod_empresa          = v_cod_empres_usuar
            AND   planilha_vendor.cdn_cliente         >= p_cdn_cliente_ini
            AND   planilha_vendor.cdn_cliente         <= p_cdn_cliente_fim
            AND   planilha_vendor.dat_fechto_vendor   >= p_dat_fechto_vendor_ini
            AND   planilha_vendor.dat_fechto_vendor   <= p_dat_fechto_vendor_fim
            AND   planilha_vendor.cod_portador        >= p_cod_portador_ini
            AND   planilha_vendor.cod_portador        <= p_cod_portador_fim
            AND   planilha_vendor.ind_sit_planilha_vendor <> "Cancelada"
            BREAK BY planilha_vendor.num_planilha_vendor.

            CREATE tt-planilha.
            ASSIGN tt-planilha.num_planilha_vendor = planilha_vendor.num_planilha_vendor
                   tt-planilha.cdn_cliente         = planilha_vendor.cdn_cliente
                   tt-planilha.cod_portador        = planilha_vendor.cod_portador
                   tt-planilha.cod_estab           = planilha_vendor.cod_estab
                   tt-planilha.l_ok                = "*".
        END.

        {&OPEN-QUERY-{&BROWSE-NAME}}

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* 
FIND emsbas.prog_dtsul NO-LOCK
    WHERE emsbas.prog_dtsul.cod_prog_dtsul = "esvdr002" NO-ERROR.

IF AVAIL emsbas.prog_dtsul THEN 
DO:
  FOR EACH emsbas.usuar_grp_usuar NO-LOCK
      WHERE emsbas.usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST emsbas.prog_dtsul_segur NO-LOCK
                    WHERE  emsbas.prog_dtsul_segur.cod_prog_dtsul = "esvdr002a"
                      AND (emsbas.prog_dtsul_segur.cod_grp_usuar  = emsbas.usuar_grp_usuar.cod_grp_usuar
                       OR  emsbas.prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

