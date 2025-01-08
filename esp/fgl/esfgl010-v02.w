&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-demonst-ctbl NO-UNDO LIKE int-agrup-demonst-ctbl
       field c-estab     as char
       field c-periodo   as char
       field c-titulo    as char
       field de-sdo-ini  as dec
       field de-movto-cr as dec
       field de-movto-db as dec
       field de-sdo-fim  as dec
       field i-seq-reg   as int
       index id-seq as primary unique
       i-seq-reg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEFINE VARIABLE wh-imprime       AS HANDLE      NO-UNDO.

DEFINE VARIABLE da-tmp        AS DATE        NO-UNDO.
DEFINE VARIABLE da-saldo-ctbl AS DATE        NO-UNDO.
DEFINE VARIABLE da-exerc-ant  AS DATE        NO-UNDO.
DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.


def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cenÿrio Contÿbil" column-label "Cenÿrio Contÿbil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Contÿbil" column-label "Data Saldo Contÿbil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito" column-label "Movto D²bito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito" column-label "Movto Cr²dito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Contÿbil Final" column-label "Saldo Contÿbil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Resultado" column-label "Apura»’o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo DB" column-label "Apura»’o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo CR" column-label "Apura»’o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito Sint" column-label "Movto D²bito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito Sint" column-label "Movto Cr²dito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Sint²tico" column-label "Saldo Sint²tico"
    field tta_val_apurac_restdo_sint       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Resultado" column-label "Apuracao Resultado"
    field tta_val_apurac_restdo_sint_db    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint DB" column-label "Apur Restdo Sint DB"
    field tta_val_apurac_restdo_sint_cr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint CR" column-label "Apur Restdo Sint CR"
    field tta_val_apurac_restdo_sint_acum  as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Result Sint" column-label "Apur Result Sint"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    index tt_cta                          
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_seq                          
          tta_num_seq                      ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-demonstrativo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-demonst-ctbl

/* Definitions for BROWSE br-demonstrativo                              */
&Scoped-define FIELDS-IN-QUERY-br-demonstrativo ~
tt-demonst-ctbl.des-agrup-nivel-1 tt-demonst-ctbl.des-agrup-nivel-2 ~
tt-demonst-ctbl.des-agrup-nivel-3 tt-demonst-ctbl.des-agrup-nivel-4 ~
tt-demonst-ctbl.des-agrup-nivel-5 tt-demonst-ctbl.cod-cta-ctbl ~
tt-demonst-ctbl.c-titulo @ tt-demonst-ctbl.c-titulo ~
tt-demonst-ctbl.c-estab @ tt-demonst-ctbl.c-estab ~
tt-demonst-ctbl.c-periodo @ tt-demonst-ctbl.c-periodo ~
tt-demonst-ctbl.de-sdo-ini @ tt-demonst-ctbl.de-sdo-ini ~
tt-demonst-ctbl.de-movto-db @ tt-demonst-ctbl.de-movto-db ~
tt-demonst-ctbl.de-movto-cr @ tt-demonst-ctbl.de-movto-cr ~
tt-demonst-ctbl.de-sdo-fim @ tt-demonst-ctbl.de-sdo-fim 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-demonstrativo 
&Scoped-define QUERY-STRING-br-demonstrativo FOR EACH tt-demonst-ctbl NO-LOCK
&Scoped-define OPEN-QUERY-br-demonstrativo OPEN QUERY br-demonstrativo FOR EACH tt-demonst-ctbl NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-demonstrativo tt-demonst-ctbl
&Scoped-define FIRST-TABLE-IN-QUERY-br-demonstrativo tt-demonst-ctbl


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-demonstrativo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold br-demonstrativo c-empresa ~
c-periodo-ini bt-fil 
&Scoped-Define DISPLAYED-OBJECTS c-empresa c-periodo-ini 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar Itens Dispon¡veis" 
     SIZE 5 BY 1 TOOLTIP "Filtrar Itens Dispon¡veis".

DEFINE VARIABLE c-empresa AS CHARACTER FORMAT "x(02)":U 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE c-periodo-ini AS CHARACTER FORMAT "99/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY 1 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 19.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-demonstrativo FOR 
      tt-demonst-ctbl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-demonstrativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-demonstrativo V-table-Win _STRUCTURED
  QUERY br-demonstrativo NO-LOCK DISPLAY
      tt-demonst-ctbl.des-agrup-nivel-1 FORMAT "x(60)":U WIDTH 55
      tt-demonst-ctbl.des-agrup-nivel-2 FORMAT "x(60)":U WIDTH 55
      tt-demonst-ctbl.des-agrup-nivel-3 FORMAT "x(60)":U WIDTH 55
      tt-demonst-ctbl.des-agrup-nivel-4 FORMAT "x(60)":U WIDTH 55
      tt-demonst-ctbl.des-agrup-nivel-5 FORMAT "x(60)":U WIDTH 55
      tt-demonst-ctbl.cod-cta-ctbl FORMAT "x(8)":U WIDTH 8.43
      tt-demonst-ctbl.c-titulo @ tt-demonst-ctbl.c-titulo COLUMN-LABEL "T¡tulo" FORMAT "x(50)":U
            WIDTH 20
      tt-demonst-ctbl.c-estab @ tt-demonst-ctbl.c-estab COLUMN-LABEL "Est" FORMAT "x(03)":U
            WIDTH 3.43
      tt-demonst-ctbl.c-periodo @ tt-demonst-ctbl.c-periodo COLUMN-LABEL "Per¡odo" FORMAT "x(08)":U
            WIDTH 7
      tt-demonst-ctbl.de-sdo-ini @ tt-demonst-ctbl.de-sdo-ini COLUMN-LABEL "Sdo Ini" FORMAT "->>,>>>,>>>,>>9.99":U
            WIDTH 12
      tt-demonst-ctbl.de-movto-db @ tt-demonst-ctbl.de-movto-db COLUMN-LABEL "D‚bito" FORMAT "->>,>>>,>>>,>>9.99":U
            WIDTH 12
      tt-demonst-ctbl.de-movto-cr @ tt-demonst-ctbl.de-movto-cr COLUMN-LABEL "Cr‚dito" FORMAT "->>,>>>,>>>,>>9.99":U
            WIDTH 12
      tt-demonst-ctbl.de-sdo-fim @ tt-demonst-ctbl.de-sdo-fim COLUMN-LABEL "Sdo Fim" FORMAT "->>,>>>,>>>,>>9.99":U
            WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 102 BY 17.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     br-demonstrativo AT ROW 1.75 COL 3 WIDGET-ID 400
     c-empresa AT ROW 19.25 COL 11 COLON-ALIGNED WIDGET-ID 8
     c-periodo-ini AT ROW 19.25 COL 26 COLON-ALIGNED WIDGET-ID 2
     bt-fil AT ROW 19.25 COL 39 WIDGET-ID 6
     rt-mold AT ROW 1.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-demonst-ctbl T "?" NO-UNDO mgesp int-agrup-demonst-ctbl
      ADDITIONAL-FIELDS:
          field c-estab     as char
          field c-periodo   as char
          field c-titulo    as char
          field de-sdo-ini  as dec
          field de-movto-cr as dec
          field de-movto-db as dec
          field de-sdo-fim  as dec
          field i-seq-reg   as int
          index id-seq as primary unique
          i-seq-reg
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 19.5
         WIDTH              = 105.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-demonstrativo rt-mold f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-demonstrativo
/* Query rebuild information for BROWSE br-demonstrativo
     _TblList          = "Temp-Tables.tt-demonst-ctbl"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-demonst-ctbl.des-agrup-nivel-1
"des-agrup-nivel-1" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-demonst-ctbl.des-agrup-nivel-2
"des-agrup-nivel-2" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-demonst-ctbl.des-agrup-nivel-3
"des-agrup-nivel-3" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-demonst-ctbl.des-agrup-nivel-4
"des-agrup-nivel-4" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-demonst-ctbl.des-agrup-nivel-5
"des-agrup-nivel-5" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-demonst-ctbl.cod-cta-ctbl
"cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-demonst-ctbl.c-titulo @ tt-demonst-ctbl.c-titulo" "T¡tulo" "x(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-demonst-ctbl.c-estab @ tt-demonst-ctbl.c-estab" "Est" "x(03)" ? ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-demonst-ctbl.c-periodo @ tt-demonst-ctbl.c-periodo" "Per¡odo" "x(08)" ? ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tt-demonst-ctbl.de-sdo-ini @ tt-demonst-ctbl.de-sdo-ini" "Sdo Ini" "->>,>>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-demonst-ctbl.de-movto-db @ tt-demonst-ctbl.de-movto-db" "D‚bito" "->>,>>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-demonst-ctbl.de-movto-cr @ tt-demonst-ctbl.de-movto-cr" "Cr‚dito" "->>,>>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-demonst-ctbl.de-sdo-fim @ tt-demonst-ctbl.de-sdo-fim" "Sdo Fim" "->>,>>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-demonstrativo */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil V-table-Win
ON CHOOSE OF bt-fil IN FRAME f-main /* Filtrar Itens Dispon¡veis */
DO:
    
     /*Verifica se a empresa possui apura‡Æo de resultado (es0018)*/
     DEF VAR l-empresa-apura-result AS LOG INIT NO NO-UNDO.

    ASSIGN c-periodo-ini = INPUT FRAME {&FRAME-NAME} c-periodo-ini
           c-periodo-ini = SUBSTR(c-periodo-ini,1,2) + "/" + SUBSTR(c-periodo-ini,3,4)
           da-saldo-ctbl = DATE("01/" + c-periodo-ini)
           da-saldo-ctbl = ADD-INTERVAL(da-saldo-ctbl,1 ,"MONTH") - DAY(da-saldo-ctbl)
           c-empresa     = TRIM(INPUT FRAME {&FRAME-NAME} c-empresa).

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "esfgl010"
          AND ponto-programa.ponto         = 1:
    
       FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    
            IF  conteudo-programa.conteudo = c-empresa THEN DO:
                ASSIGN l-empresa-apura-result = YES.
                LEAVE.
            END.
        END.
    END.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    EMPTY TEMP-TABLE tt-demonst-ctbl.

    {&OPEN-QUERY-br-demonstrativo}

    FOR FIRST plano_cta_ctbl NO-LOCK
        WHERE plano_cta_ctbl.cod_plano_cta_ctbl = "Padrao":
    END.

    FOR EACH  int-agrup-demonst-ctbl NO-LOCK,
        FIRST cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta = "Padrao"
          AND cta_ctbl.cod_cta_ctbl  = int-agrup-demonst-ctbl.cod-cta-ctbl:

        EMPTY TEMP-TABLE tt_input_leitura_sdo.
        EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.
        EMPTY TEMP-TABLE tt_log_erros.

        CREATE tt_input_leitura_sdo.
        ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
               tt_input_leitura_sdo.ttv_des_conteudo = c-empresa
               tt_input_leitura_sdo.ttv_num_seq_1    = 1
               tt_input_leitura_sdo.ttv_num_seq_2    = 1.

        CREATE tt_input_leitura_sdo.
        ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Economica"
               tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
               tt_input_leitura_sdo.ttv_num_seq_1    = 1
               tt_input_leitura_sdo.ttv_num_seq_2    = 2. 

        CREATE tt_input_leitura_sdo. 
        ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
               tt_input_leitura_sdo.ttv_des_conteudo = int-agrup-demonst-ctbl.cod-cta-ctbl
               tt_input_leitura_sdo.ttv_num_seq_1    = 1
               tt_input_leitura_sdo.ttv_num_seq_2    = 3.

        CREATE tt_input_leitura_sdo. 
        ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
               tt_input_leitura_sdo.ttv_des_conteudo = int-agrup-demonst-ctbl.cod-cta-ctbl
               tt_input_leitura_sdo.ttv_num_seq_1    = 1
               tt_input_leitura_sdo.ttv_num_seq_2    = 4.

        CREATE tt_input_leitura_sdo.
        ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
               tt_input_leitura_sdo.ttv_des_conteudo = STRING(da-saldo-ctbl, "99/99/9999")
               tt_input_leitura_sdo.ttv_num_seq_1    = 1
               tt_input_leitura_sdo.ttv_num_seq_2    = 5.            

         RUN prgfin/fgl/fgl905zb.py (INPUT 1,
                                     INPUT TABLE  tt_input_leitura_sdo,
                                     OUTPUT TABLE tt_retorna_sdo_ctbl,
                                     OUTPUT TABLE tt_log_erros).

         FOR EACH tt_retorna_sdo_ctbl
             BREAK BY tt_retorna_sdo_ctbl.tta_cod_estab:

             IF  FIRST-OF(tt_retorna_sdo_ctbl.tta_cod_estab)
             THEN DO:
                 CREATE tt-demonst-ctbl.
                 BUFFER-COPY int-agrup-demonst-ctbl TO tt-demonst-ctbl.
                 ASSIGN i-seq                     = i-seq + 1
                        tt-demonst-ctbl.i-seq-reg = i-seq
                        tt-demonst-ctbl.c-estab   = tt_retorna_sdo_ctbl.tta_cod_estab
                        tt-demonst-ctbl.c-periodo = c-periodo-ini
                        tt-demonst-ctbl.c-titulo  = cta_ctbl.des_tit_ctbl.
             END.

             ASSIGN tt-demonst-ctbl.de-sdo-fim  = tt-demonst-ctbl.de-sdo-fim  + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim
                    tt-demonst-ctbl.de-movto-cr = tt-demonst-ctbl.de-movto-cr + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_cr
                    tt-demonst-ctbl.de-movto-db = tt-demonst-ctbl.de-movto-db + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_db.

             IF  LAST-OF(tt_retorna_sdo_ctbl.tta_cod_estab)
             THEN DO:
                  IF  NOT l-empresa-apura-result THEN 
                      ASSIGN tt-demonst-ctbl.de-sdo-ini = tt-demonst-ctbl.de-sdo-fim - (tt-demonst-ctbl.de-movto-db - tt-demonst-ctbl.de-movto-cr).
                  ELSE IF plano_cta_ctbl.cod_cta_ctbl_apurac_restdo <> int-agrup-demonst-ctbl.cod-cta-ctbl THEN 
                        ASSIGN tt-demonst-ctbl.de-sdo-ini = tt-demonst-ctbl.de-sdo-fim - (tt-demonst-ctbl.de-movto-db - tt-demonst-ctbl.de-movto-cr).
             END.
         END.


         /* Zerar exerc¡cio anterior para contas de resultado */
         IF  plano_cta_ctbl.cod_cta_ctbl_apurac_restdo = int-agrup-demonst-ctbl.cod-cta-ctbl
         AND l-empresa-apura-result
         THEN DO:
            EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.
            EMPTY TEMP-TABLE tt_log_erros.

            FOR FIRST tt_input_leitura_sdo
                WHERE tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
                  AND tt_input_leitura_sdo.ttv_num_seq_1    = 1
                  AND tt_input_leitura_sdo.ttv_num_seq_2    = 5:

                ASSIGN da-exerc-ant = DATE("31/12/" + STRING((YEAR(da-saldo-ctbl) - 1)))
                       tt_input_leitura_sdo.ttv_des_conteudo = STRING(da-exerc-ant, "99/99/9999").

                 RUN prgfin/fgl/fgl905zb.py (INPUT 1,
                                             INPUT  TABLE tt_input_leitura_sdo,
                                             OUTPUT TABLE tt_retorna_sdo_ctbl,
                                             OUTPUT TABLE tt_log_erros).

                 FOR EACH  tt_retorna_sdo_ctbl,
                     EACH  tt-demonst-ctbl
                     WHERE tt-demonst-ctbl.cod-cta-ctbl = int-agrup-demonst-ctbl.cod-cta-ctbl
                       AND tt-demonst-ctbl.c-estab      = tt_retorna_sdo_ctbl.tta_cod_estab
                     BREAK BY tt_retorna_sdo_ctbl.tta_cod_estab:
        
                     ASSIGN tt-demonst-ctbl.de-sdo-fim  = tt-demonst-ctbl.de-sdo-fim  - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
        
                     IF  LAST-OF(tt_retorna_sdo_ctbl.tta_cod_estab)
                     THEN
                         ASSIGN tt-demonst-ctbl.de-sdo-ini = tt-demonst-ctbl.de-sdo-fim - (tt-demonst-ctbl.de-movto-db - tt-demonst-ctbl.de-movto-cr).
                 END.
            END.
         END.
    END.

    {&OPEN-QUERY-br-demonstrativo}

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-demonstrativo
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
    ASSIGN da-tmp        = ADD-INTERVAL(TODAY, -1, 'months')
           c-periodo-ini = STRING(MONTH(da-tmp),"99") + STRING(YEAR(da-tmp),"9999")
           c-empresa     = "1".

    DISP c-periodo-ini c-empresa WITH FRAME {&FRAME-NAME}.

    APPLY "entry" TO c-periodo-ini IN FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-demonst-ctbl"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

