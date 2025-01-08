&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_int_solicitacao_alatur NO-UNDO LIKE int_solicitacao_alatur
       field r_rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ala0002 2.00.00.000}

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

DEFINE STREAM s-1.
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-vencimento AS CHARACTER FORMAT "X(12)"  NO-UNDO.

DEFINE VARIABLE v_request_company_name_ini  LIKE int_solicitacao_alatur.request_company_name. 
DEFINE VARIABLE v_request_company_name_fim  LIKE int_solicitacao_alatur.request_company_name. 
DEFINE VARIABLE v_request_number_arb_ini    LIKE int_solicitacao_alatur.request_number_arb.       
DEFINE VARIABLE v_request_number_arb_fim    LIKE int_solicitacao_alatur.request_number_arb.       
DEFINE VARIABLE v_advance_include_date_ini  LIKE int_solicitacao_alatur.advance_include_date. 
DEFINE VARIABLE v_advance_include_date_fim  LIKE int_solicitacao_alatur.advance_include_date. 
DEFINE VARIABLE v_vencimento_ini            LIKE int_solicitacao_alatur.advance_final_date.   
DEFINE VARIABLE v_vencimento_fim            LIKE int_solicitacao_alatur.advance_final_date.   
DEFINE VARIABLE v_dat_pay_ad_ini            LIKE int_solicitacao_alatur.dat_pay_ad.           
DEFINE VARIABLE v_dat_pay_ad_fim            LIKE int_solicitacao_alatur.dat_pay_ad.           
DEFINE VARIABLE v_dat_pay_pc_ini            LIKE int_solicitacao_alatur.dat_pay_pc.           
DEFINE VARIABLE v_dat_pay_pc_fim            LIKE int_solicitacao_alatur.dat_pay_pc.           
DEFINE VARIABLE v_request_passenger_CPF_ini LIKE int_solicitacao_alatur.request_passenger_CPF.
DEFINE VARIABLE v_request_passenger_CPF_fim LIKE int_solicitacao_alatur.request_passenger_CPF.
DEFINE VARIABLE v_viagem_nacional           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_cartao_credito            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_prestacao_contas          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nom-fornec AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-fornec AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_antecip_pef_pend
    AS RECID
    FORMAT ">>>>>>9":U
    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_ap  
    AS RECID 
    FORMAT ">>>>>>>9" 
    INITIAL ? 
    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-solicitacao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_int_solicitacao_alatur

/* Definitions for BROWSE br-solicitacao                                */
&Scoped-define FIELDS-IN-QUERY-br-solicitacao ~
tt_int_solicitacao_alatur.request_number_arb ~
tt_int_solicitacao_alatur.request_company_name ~
tt_int_solicitacao_alatur.advance_expense ~
tt_int_solicitacao_alatur.advance_include_date ~
tt_int_solicitacao_alatur.advance_initial_date ~
fnVencimento(tt_int_solicitacao_alatur.cod_refer_antecip_pef_pend, tt_int_solicitacao_alatur.num_id_tit_ap, tt_int_solicitacao_alatur.advance_expense) @ c-vencimento ~
tt_int_solicitacao_alatur.dat_create_ad ~
tt_int_solicitacao_alatur.dat_pay_ad tt_int_solicitacao_alatur.val_total_ad ~
tt_int_solicitacao_alatur.dat_create_pc ~
tt_int_solicitacao_alatur.dat_pay_pc tt_int_solicitacao_alatur.val_total_pc ~
tt_int_solicitacao_alatur.val_total_reembolso_pc ~
tt_int_solicitacao_alatur.val_total_devolucao_pc ~
tt_int_solicitacao_alatur.request_passenger_CPF ~
tt_int_solicitacao_alatur.request_passenger_bank ~
tt_int_solicitacao_alatur.request_passenger_branch_number ~
tt_int_solicitacao_alatur.request_passenger_checking_acc ~
fnCodFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-cod-fornec ~
fnNomFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-nom-fornec 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-solicitacao 
&Scoped-define QUERY-STRING-br-solicitacao FOR EACH tt_int_solicitacao_alatur NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-solicitacao OPEN QUERY br-solicitacao FOR EACH tt_int_solicitacao_alatur NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-solicitacao tt_int_solicitacao_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-br-solicitacao tt_int_solicitacao_alatur


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-solicitacao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button br-solicitacao bt-ok bt-exportar ~
bt-detalhar bt-detalhar-antecip bt-detalhar-tit bt-filtro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCodFornec w-cadsim 
FUNCTION fnCodFornec RETURNS CHARACTER
  ( p-cpf AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomFornec w-cadsim 
FUNCTION fnNomFornec RETURNS CHARACTER
  ( p-cpf AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnVencimento w-cadsim 
FUNCTION fnVencimento RETURNS CHARACTER
  ( p_cod_refer_antecip_pef_pend AS CHAR,
    p_num_id_tit_ap              AS INT,
    p_advance_expense            AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-detalhar 
     LABEL "Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-detalhar-antecip 
     LABEL "Detalhar Antecip." 
     SIZE 12.72 BY 1.

DEFINE BUTTON bt-detalhar-tit 
     LABEL "Detalhar T¡tulo" 
     SIZE 12.72 BY 1.

DEFINE BUTTON bt-exportar 
     LABEL "Exportar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-filtro 
     LABEL "Filtrar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 171 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-solicitacao FOR 
      tt_int_solicitacao_alatur SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-solicitacao w-cadsim _STRUCTURED
  QUERY br-solicitacao NO-LOCK DISPLAY
      tt_int_solicitacao_alatur.request_number_arb FORMAT "x(64)":U
            WIDTH 11.43
      tt_int_solicitacao_alatur.request_company_name FORMAT "x(64)":U
            WIDTH 18.29
      tt_int_solicitacao_alatur.advance_expense FORMAT "x(32)":U
            WIDTH 13.43
      tt_int_solicitacao_alatur.advance_include_date FORMAT "99/99/9999":U
      tt_int_solicitacao_alatur.advance_initial_date FORMAT "99/99/9999":U
      fnVencimento(tt_int_solicitacao_alatur.cod_refer_antecip_pef_pend, tt_int_solicitacao_alatur.num_id_tit_ap, tt_int_solicitacao_alatur.advance_expense) @ c-vencimento COLUMN-LABEL "Vencimento"
      tt_int_solicitacao_alatur.dat_create_ad FORMAT "99/99/9999":U
      tt_int_solicitacao_alatur.dat_pay_ad FORMAT "99/99/9999":U
      tt_int_solicitacao_alatur.val_total_ad FORMAT ">>>,>>>,>>9.99":U
      tt_int_solicitacao_alatur.dat_create_pc FORMAT "99/99/9999":U
      tt_int_solicitacao_alatur.dat_pay_pc FORMAT "99/99/9999":U
      tt_int_solicitacao_alatur.val_total_pc FORMAT ">>>,>>>,>>9.99":U
      tt_int_solicitacao_alatur.val_total_reembolso_pc FORMAT ">>>,>>>,>>9.99":U
      tt_int_solicitacao_alatur.val_total_devolucao_pc FORMAT ">>>,>>>,>>9.99":U
      tt_int_solicitacao_alatur.request_passenger_CPF FORMAT "x(14)":U
      tt_int_solicitacao_alatur.request_passenger_bank FORMAT "x(10)":U
      tt_int_solicitacao_alatur.request_passenger_branch_number FORMAT "x(15)":U
      tt_int_solicitacao_alatur.request_passenger_checking_acc FORMAT "x(15)":U
      fnCodFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-cod-fornec COLUMN-LABEL "Cod. Fornec." FORMAT "x(20)":U
      fnNomFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-nom-fornec COLUMN-LABEL "Nome Abrev." FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 171 BY 24.25
         FONT 7
         TITLE "Solicita‡äes" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-solicitacao AT ROW 1.25 COL 2 WIDGET-ID 200
     bt-ok AT ROW 25.71 COL 3
     bt-cancela AT ROW 25.71 COL 14
     bt-exportar AT ROW 25.71 COL 36 WIDGET-ID 4
     bt-detalhar AT ROW 25.71 COL 47.14 WIDGET-ID 6
     bt-detalhar-antecip AT ROW 25.71 COL 58.29 WIDGET-ID 8
     bt-detalhar-tit AT ROW 25.71 COL 72 WIDGET-ID 10
     bt-filtro AT ROW 25.71 COL 162 WIDGET-ID 2
     rt-button AT ROW 25.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 172 BY 26
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt_int_solicitacao_alatur T "?" NO-UNDO mgesp int_solicitacao_alatur
      ADDITIONAL-FIELDS:
          field r_rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 26
         WIDTH              = 172.14
         MAX-HEIGHT         = 26
         MAX-WIDTH          = 172.14
         VIRTUAL-HEIGHT     = 26
         VIRTUAL-WIDTH      = 172.14
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
/* BROWSE-TAB br-solicitacao rt-button f-cad */
/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-solicitacao
/* Query rebuild information for BROWSE br-solicitacao
     _TblList          = "Temp-Tables.tt_int_solicitacao_alatur"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt_int_solicitacao_alatur.request_number_arb
"request_number_arb" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt_int_solicitacao_alatur.request_company_name
"request_company_name" ? ? "character" ? ? ? ? ? ? no ? no no "18.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt_int_solicitacao_alatur.advance_expense
"advance_expense" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt_int_solicitacao_alatur.advance_include_date
     _FldNameList[5]   = Temp-Tables.tt_int_solicitacao_alatur.advance_initial_date
     _FldNameList[6]   > "_<CALC>"
"fnVencimento(tt_int_solicitacao_alatur.cod_refer_antecip_pef_pend, tt_int_solicitacao_alatur.num_id_tit_ap, tt_int_solicitacao_alatur.advance_expense) @ c-vencimento" "Vencimento" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt_int_solicitacao_alatur.dat_create_ad
     _FldNameList[8]   = Temp-Tables.tt_int_solicitacao_alatur.dat_pay_ad
     _FldNameList[9]   = Temp-Tables.tt_int_solicitacao_alatur.val_total_ad
     _FldNameList[10]   = Temp-Tables.tt_int_solicitacao_alatur.dat_create_pc
     _FldNameList[11]   = Temp-Tables.tt_int_solicitacao_alatur.dat_pay_pc
     _FldNameList[12]   = Temp-Tables.tt_int_solicitacao_alatur.val_total_pc
     _FldNameList[13]   = Temp-Tables.tt_int_solicitacao_alatur.val_total_reembolso_pc
     _FldNameList[14]   = Temp-Tables.tt_int_solicitacao_alatur.val_total_devolucao_pc
     _FldNameList[15]   = Temp-Tables.tt_int_solicitacao_alatur.request_passenger_CPF
     _FldNameList[16]   = Temp-Tables.tt_int_solicitacao_alatur.request_passenger_bank
     _FldNameList[17]   = Temp-Tables.tt_int_solicitacao_alatur.request_passenger_branch_number
     _FldNameList[18]   = Temp-Tables.tt_int_solicitacao_alatur.request_passenger_checking_acc
     _FldNameList[19]   > "_<CALC>"
"fnCodFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-cod-fornec" "Cod. Fornec." "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"fnNomFornec(tt_int_solicitacao_alatur.request_passenger_CPF) @ c-nom-fornec" "Nome Abrev." "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-solicitacao */
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


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar w-cadsim
ON CHOOSE OF bt-detalhar IN FRAME f-cad /* Detalhar */
DO:
    IF AVAIL tt_int_solicitacao_alatur THEN
        RUN esp/ala/ala0002b.w (INPUT tt_int_solicitacao_alatur.r_rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar-antecip w-cadsim
ON CHOOSE OF bt-detalhar-antecip IN FRAME f-cad /* Detalhar Antecip. */
DO:
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

    IF AVAIL tt_int_solicitacao_alatur THEN DO:
        IF tt_int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_cr.
        ELSE IF tt_int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.
        ELSE IF tt_int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.

        FIND FIRST antecip_pef_pend NO-LOCK
             WHERE antecip_pef_pend.cod_estab = c-estab
               AND antecip_pef_pend.cod_refer = tt_int_solicitacao_alatur.cod_refer_antecip_pef_pend NO-ERROR.

        IF AVAIL antecip_pef_pend THEN DO:
            ASSIGN v_rec_antecip_pef_pend = RECID(antecip_pef_pend).
            RUN prgfin/apb/apb701aa.p.
        END.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar-tit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar-tit w-cadsim
ON CHOOSE OF bt-detalhar-tit IN FRAME f-cad /* Detalhar T¡tulo */
DO:
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

    IF AVAIL tt_int_solicitacao_alatur THEN DO:

        ASSIGN c-estab = entry(2,tt_int_solicitacao_alatur.request_company_name, " ").

        /*IF tt_int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_cr.
        ELSE IF tt_int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.
        ELSE IF tt_int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.*/

       FIND FIRST estabelecimento NO-LOCK
            WHERE estabelecimento.cod_estab = c-estab NO-ERROR.

       FIND FIRST fornecedor NO-LOCK
            WHERE fornecedor.cod_empresa  = estabelecimento.cod_empresa
              AND fornecedor.cod_pais     = "BRA"
              AND fornecedor.cod_id_feder = tt_int_solicitacao_alatur.request_passenger_CPF NO-ERROR.

       
       FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab     = c-estab
              AND tit_ap.num_id_tit_ap = tt_int_solicitacao_alatur.num_id_tit_ap NO-ERROR.

       IF AVAIL tit_ap THEN DO:
           ASSIGN v_rec_tit_ap = RECID(tit_ap).
           RUN prgfin/apb/apb222aa.p.
       END.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exportar w-cadsim
ON CHOOSE OF bt-exportar IN FRAME f-cad /* Exportar */
DO:
    DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Exportando').

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "ala0002" + REPLACE(REPLACE(REPLACE(REPLACE(STRING(NOW),"/","")," ",""),":",""),",","") + ".csv".

    OUTPUT STREAM s-1 TO VALUE(c-arquivo).
    PUT STREAM s-1 UNFORMATTED "Nr. Requis.;Requis. Ident.;Stat. Desp. Ad;Stat. AD;Dt. Cria. AD;Hr. Cria. AD;Usu. Cria. AD;Vl. Tot. AD;Dt. Pagto. AD;Hr. Pagto. AD;Usu. Pagto. AD;Stat. Desp. PC;Stat. PC;CPF Passag.;Banco Passag.;Agenc. Passag.;Cta. Corr. Passag.;Desp.;Dt. Fim;Dt. Inclu.;Dt. Ini.;Obs.;Pre‡o;Qtd.;Empresa Requis.;Nome Conta;Hist. Rat.;Hist. Reemb.;Dt. Cria. PC;hr. Cria. PC;Usuar. Cria. PC;Vl. Tot. PC;Vl. Tot. Reemb. PC;Vl. Tot. Devol. PC.;Dt. Pag. PC;Hr. Pag. PC;Usuar. Pag. PC;Cod. Refer. Antecip.;Num. Tit. AP;Cod. Fornec.; Nom Fornec.;" SKIP.
    FOR EACH tt_int_solicitacao_alatur:
        RUN pi-acompanhar IN h-acomp (INPUT 'Requisi‡Æo: ' + tt_int_solicitacao_alatur.request_number_arb).
        PUT STREAM s-1 tt_int_solicitacao_alatur.request_number_arb              ";" 
                       tt_int_solicitacao_alatur.request_arb_id                  ";" 
                       tt_int_solicitacao_alatur.request_expense_status_ad       ";" 
                       tt_int_solicitacao_alatur.request_status_ad               ";" 
                       tt_int_solicitacao_alatur.dat_create_ad                   ";" 
                       tt_int_solicitacao_alatur.hra_create_ad                   ";" 
                       tt_int_solicitacao_alatur.cod_usuar_create_ad             ";" 
                       tt_int_solicitacao_alatur.val_total_ad                    ";" 
                       tt_int_solicitacao_alatur.dat_pay_ad                      ";" 
                       tt_int_solicitacao_alatur.hra_pay_ad                      ";" 
                       tt_int_solicitacao_alatur.cod_usuar_pay_ad                ";" 
                       tt_int_solicitacao_alatur.request_expense_status_pc       ";" 
                       tt_int_solicitacao_alatur.request_status_pc               ";" 
                       tt_int_solicitacao_alatur.request_passenger_CPF           ";" 
                       tt_int_solicitacao_alatur.request_passenger_bank          ";" 
                       tt_int_solicitacao_alatur.request_passenger_branch_numbe  ";" 
                       tt_int_solicitacao_alatur.request_passenger_checking_acc  ";" 
                       tt_int_solicitacao_alatur.advance_expense                 ";" 
                       tt_int_solicitacao_alatur.advance_final_date              ";" 
                       tt_int_solicitacao_alatur.advance_include_date            ";" 
                       tt_int_solicitacao_alatur.advance_initial_date            ";" 
                       tt_int_solicitacao_alatur.advance_note                    ";" 
                       tt_int_solicitacao_alatur.advance_price                   ";" 
                       tt_int_solicitacao_alatur.advance_quantity                ";" 
                       tt_int_solicitacao_alatur.request_company_name            ";" 
                       tt_int_solicitacao_alatur.account_name                    ";" 
                       tt_int_solicitacao_alatur.advance_hitor_rateio            ";" 
                       tt_int_solicitacao_alatur.refund_histor_rateio            ";" 
                       tt_int_solicitacao_alatur.dat_create_pc                   ";" 
                       tt_int_solicitacao_alatur.hra_create_pc                   ";" 
                       tt_int_solicitacao_alatur.cod_usuar_create_pc             ";" 
                       tt_int_solicitacao_alatur.val_total_pc                    ";" 
                       tt_int_solicitacao_alatur.val_total_reembolso_pc          ";" 
                       tt_int_solicitacao_alatur.val_total_devolucao_pc          ";" 
                       tt_int_solicitacao_alatur.dat_pay_pc                      ";" 
                       tt_int_solicitacao_alatur.hra_pay_pc                      ";" 
                       tt_int_solicitacao_alatur.cod_usuar_pay_pc                ";" 
                       tt_int_solicitacao_alatur.cod_refer_antecip_pef_pend      ";" 
                       tt_int_solicitacao_alatur.num_id_tit_ap                   ";"
                       fnCodFornec(tt_int_solicitacao_alatur.request_passenger_CPF) ";"
                       fnNomFornec(tt_int_solicitacao_alatur.request_passenger_CPF) ";" SKIP.
    END.
    
    OUTPUT STREAM s-1 CLOSE.

    RUN pi-finalizar IN h-acomp.

    DOS SILENT START excel VALUE(c-arquivo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro w-cadsim
ON CHOOSE OF bt-filtro IN FRAME f-cad /* Filtrar */
DO:
    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    RUN esp/ala/ala0002a.w (INPUT-OUTPUT v_request_company_name_ini,
                            INPUT-OUTPUT v_request_company_name_fim,  
                            INPUT-OUTPUT v_request_number_arb_ini,        
                            INPUT-OUTPUT v_request_number_arb_fim,        
                            INPUT-OUTPUT v_advance_include_date_ini,  
                            INPUT-OUTPUT v_advance_include_date_fim,  
                            INPUT-OUTPUT v_vencimento_ini,    
                            INPUT-OUTPUT v_vencimento_fim,    
                            INPUT-OUTPUT v_dat_pay_ad_ini,            
                            INPUT-OUTPUT v_dat_pay_ad_fim,            
                            INPUT-OUTPUT v_dat_pay_pc_ini,            
                            INPUT-OUTPUT v_dat_pay_pc_fim,            
                            INPUT-OUTPUT v_request_passenger_CPF_ini, 
                            INPUT-OUTPUT v_request_passenger_CPF_fim,
                            INPUT-OUTPUT v_viagem_nacional, 
                            INPUT-OUTPUT v_cartao_credito,
                            INPUT-OUTPUT v_prestacao_contas,
                            OUTPUT l-ok).

    IF l-ok THEN
        RUN pi-carrega-tt.
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


&Scoped-define BROWSE-NAME br-solicitacao
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

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
  ENABLE rt-button br-solicitacao bt-ok bt-exportar bt-detalhar 
         bt-detalhar-antecip bt-detalhar-tit bt-filtro 
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

  {utp/ut9000.i "ala0002" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN dispatch  IN this-procedure ('enable-fields':U).

  ASSIGN v_request_company_name_ini  = "" 
         v_request_company_name_fim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
         v_request_number_arb_ini    = ""
         v_request_number_arb_fim    = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
         v_advance_include_date_ini  = 01/01/0001
         v_advance_include_date_fim  = 12/31/9999
         v_vencimento_ini            = 01/01/0001
         v_vencimento_fim            = 12/31/9999
         v_dat_pay_ad_ini            = 01/01/0001 
         v_dat_pay_ad_fim            = 12/31/9999 
         v_dat_pay_pc_ini            = 01/01/0001 
         v_dat_pay_pc_fim            = 12/31/9999
         v_request_passenger_CPF_ini = ""
         v_request_passenger_CPF_fim = "ZZZZZZZZZZZZZZ"
         v_viagem_nacional           = YES
         v_cartao_credito            = YES
         v_prestacao_contas          = YES.

  RUN pi-carrega-tt.

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt w-cadsim 
PROCEDURE pi-carrega-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Carregando Registros').

    EMPTY TEMP-TABLE tt_int_solicitacao_alatur.
    
    FOR EACH int_solicitacao_alatur NO-LOCK
       WHERE int_solicitacao_alatur.request_company_name  >= v_request_company_name_ini  
         AND int_solicitacao_alatur.request_company_name  <= v_request_company_name_fim  
         AND int_solicitacao_alatur.request_number_arb    >= v_request_number_arb_ini
         AND int_solicitacao_alatur.request_number_arb    <= v_request_number_arb_fim
         AND (int_solicitacao_alatur.advance_include_date  >= v_advance_include_date_ini OR int_solicitacao_alatur.advance_include_date = ?)
         AND (int_solicitacao_alatur.advance_include_date  <= v_advance_include_date_fim OR int_solicitacao_alatur.advance_include_date = ?)
         AND int_solicitacao_alatur.dat_pay_ad            >= v_dat_pay_ad_ini            
         AND int_solicitacao_alatur.dat_pay_ad            <= v_dat_pay_ad_fim            
         AND int_solicitacao_alatur.dat_pay_pc            >= v_dat_pay_pc_ini            
         AND int_solicitacao_alatur.dat_pay_pc            <= v_dat_pay_pc_fim            
         AND int_solicitacao_alatur.request_passenger_CPF >= v_request_passenger_CPF_ini 
         AND int_solicitacao_alatur.request_passenger_CPF <= v_request_passenger_CPF_fim:

        IF int_solicitacao_alatur.advance_expense = "CartÆo Saque" THEN
            NEXT.

        IF int_solicitacao_alatur.advance_expense = "" THEN
            NEXT.

        ASSIGN c-estab = "".

        IF  NOT v_viagem_nacional
        AND int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
            NEXT.

        IF  NOT v_cartao_credito
        AND int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
            NEXT.

        IF  NOT v_prestacao_contas
        AND int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
            NEXT.

        FIND LAST int_param_alatur NO-LOCK NO-ERROR.

        IF int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_cr.
        ELSE IF int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.
        ELSE IF int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
            ASSIGN c-estab = int_param_alatur.cod_estab_ad.

        FIND FIRST antecip_pef_pend NO-LOCK
             WHERE antecip_pef_pend.cod_estab = c-estab
               AND antecip_pef_pend.cod_refer = int_solicitacao_alatur.cod_refer_antecip_pef_pend NO-ERROR.

        IF  AVAIL antecip_pef_pend
        AND (antecip_pef_pend.dat_vencto_tit_ap < v_vencimento_ini OR antecip_pef_pend.dat_vencto_tit_ap > v_vencimento_fim) THEN
            NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT 'Requisi‡Æo: ' + int_solicitacao_alatur.request_number_arb).

        CREATE tt_int_solicitacao_alatur.
        BUFFER-COPY int_solicitacao_alatur TO tt_int_solicitacao_alatur.
        ASSIGN tt_int_solicitacao_alatur.r_rowid = ROWID(int_solicitacao_alatur).
    END.

    RUN pi-finalizar IN h-acomp.
    
    {&open-query-br-solicitacao}
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
  {src/adm/template/snd-list.i "tt_int_solicitacao_alatur"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCodFornec w-cadsim 
FUNCTION fnCodFornec RETURNS CHARACTER
  ( p-cpf AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

  IF tt_int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_cr.
  ELSE IF tt_int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_ad.
  ELSE IF tt_int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_ad.

  FIND FIRST estabelecimento NO-LOCK
       WHERE estabelecimento.cod_estab = c-estab NO-ERROR.


  FIND FIRST fornecedor NO-LOCK
       WHERE fornecedor.cod_empresa  = estabelecimento.cod_empresa
         AND fornecedor.cod_pais     = "BRA"
         AND fornecedor.cod_id_feder = p-cpf NO-ERROR.

  IF AVAIL fornecedor THEN
    RETURN string(fornecedor.cdn_fornecedor).   /* Function return value. */
  ELSE 
      RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomFornec w-cadsim 
FUNCTION fnNomFornec RETURNS CHARACTER
  ( p-cpf AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

  IF tt_int_solicitacao_alatur.advance_expense = "CartÆo de Cr‚dito" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_cr.
  ELSE IF tt_int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_ad.
  ELSE IF tt_int_solicitacao_alatur.advance_expense = "Presta‡Æo de Contas" THEN
      ASSIGN c-estab = int_param_alatur.cod_estab_ad.

  FIND FIRST estabelecimento NO-LOCK
       WHERE estabelecimento.cod_estab = c-estab NO-ERROR.


  FIND FIRST fornecedor NO-LOCK
       WHERE fornecedor.cod_empresa  = estabelecimento.cod_empresa
         AND fornecedor.cod_pais     = "BRA"
         AND fornecedor.cod_id_feder = p-cpf NO-ERROR.

  IF AVAIL fornecedor THEN
    RETURN fornecedor.nom_abrev.   /* Function return value. */
  ELSE 
      RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnVencimento w-cadsim 
FUNCTION fnVencimento RETURNS CHARACTER
  ( p_cod_refer_antecip_pef_pend AS CHAR,
    p_num_id_tit_ap              AS INT,
    p_advance_expense            AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

    FIND LAST int_param_alatur NO-LOCK NO-ERROR.

    IF p_advance_expense = "CartÆo de Cr‚dito" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_cr.
    ELSE IF p_advance_expense = "Viagem Nacional" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_ad.
    ELSE IF p_advance_expense = "Presta‡Æo de Contas" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_ad.

    IF p_advance_expense = "CartÆo de Cr‚dito" THEN DO:
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab     = c-estab
               AND tit_ap.num_id_tit_ap = p_num_id_tit_ap NO-ERROR.

        IF AVAIL tit_ap THEN
            RETURN STRING(tit_ap.dat_vencto_tit_ap,"99/99/9999").
        ELSE
            RETURN "".
    END.
    ELSE DO:
        FIND FIRST antecip_pef_pend NO-LOCK
             WHERE antecip_pef_pend.cod_estab = c-estab
               AND antecip_pef_pend.cod_refer = p_cod_refer_antecip_pef_pend NO-ERROR.
    
        IF AVAIL antecip_pef_pend THEN
            RETURN STRING(antecip_pef_pend.dat_vencto_tit_ap,"99/99/9999").
        ELSE
            RETURN "".   /* Function return value. */
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

