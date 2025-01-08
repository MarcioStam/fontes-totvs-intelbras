&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-rateio NO-UNDO LIKE int-rateio
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-rateio-fatur NO-UNDO LIKE int-rateio-fatur
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-rateio-plan NO-UNDO LIKE int-rateio-plan
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
{include/i-prgvrs.i esfgl005 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          esfgl005
&GLOBAL-DEFINE Version          2.0

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Fatura, Rateio

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         ttint-rateio
&GLOBAL-DEFINE hDBOParent       hdboes908
&GLOBAL-DEFINE DBOParentTable   int-rateio
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttint-rateio-fatur
&GLOBAL-DEFINE hDBOSon1         hdboes909
&GLOBAL-DEFINE DBOSon1Table     int-rateio-fatur
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttint-rateio-plan
&GLOBAL-DEFINE hDBOSon2         hdboes910             
&GLOBAL-DEFINE DBOSon2Table     int-rateio-plan
&GLOBAL-DEFINE DBOSon2Destroy   YES                   

&GLOBAL-DEFINE page0Fields       btDescontabiliza tg-Contabilizado btHistorico bt-liberar bt-bloquear ttint-rateio.tipo-rateio fi-competencia ttint-rateio.cod-estabel 
&GLOBAL-DEFINE page2Fields       bt-eliminar-todos bt-importar

&GLOBAL-DEFINE page1Browse      brSon1 
&GLOBAL-DEFINE page2Browse      brSon2

/* Parameters Definitions ---                                           */

/* mgesp Variable Definitions ---                                       */

/* mgesp Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}    AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}      AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}      AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-ct-transitoria AS CHARACTER NO-UNDO.

DEF NEW GLOBAL SHARED VAR g-tipo-faixa AS INTEGER NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-inclusao   AS LOGICAL NO-UNDO.

{utp/ut-glob.i}

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Resultado" column-label "Apuraá∆o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo DB" column-label "Apuraá∆o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo CR" column-label "Apuraá∆o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito Sint" column-label "Movto DÇbito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito Sint" column-label "Movto CrÇdito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo SintÇtico" column-label "Saldo SintÇtico"
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
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttint-rateio-fatur ttint-rateio-plan

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttint-rateio-fatur.nr-fatura ~
ttint-rateio-fatur.vl-origem ttint-rateio-fatur.vl-deducao ~
ttint-rateio-fatur.vl-base-rateio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttint-rateio-fatur NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttint-rateio-fatur NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttint-rateio-fatur
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttint-rateio-fatur


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttint-rateio-plan.cod-estabel-rat ~
ttint-rateio-plan.cod-centro-custo ttint-rateio-plan.cod-unid-neg ~
ttint-rateio-plan.vl-perc-rateio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttint-rateio-plan NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttint-rateio-plan NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 ttint-rateio-plan
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttint-rateio-plan


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-rateio.tipo-rateio ~
ttint-rateio.cod-estabel 
&Scoped-define ENABLED-TABLES ttint-rateio
&Scoped-define FIRST-ENABLED-TABLE ttint-rateio
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent RECT-1 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btDelete btDescontabiliza btQueryJoins ~
btReportsJoins btExit btHelp btHistorico cb-status fi-desc fi-competencia ~
tg-contabilizado bt-liberar bt-bloquear fi-desc-estab 
&Scoped-Define DISPLAYED-FIELDS ttint-rateio.tipo-rateio ~
ttint-rateio.cod-estabel 
&Scoped-define DISPLAYED-TABLES ttint-rateio
&Scoped-define FIRST-DISPLAYED-TABLE ttint-rateio
&Scoped-Define DISPLAYED-OBJECTS cb-status fi-desc fi-competencia ~
tg-contabilizado fi-desc-estab 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
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
DEFINE BUTTON bt-bloquear 
     LABEL "Reabrir" 
     SIZE 7 BY 1.13 TOOLTIP "Bloquear o rateio".

DEFINE BUTTON bt-liberar 
     LABEL "Liberar" 
     SIZE 7 BY 1.13 TOOLTIP "Libera o Rateio".

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDescontabiliza 
     IMAGE-UP FILE "adeicon/export-u.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Descontabilizar Rateio" 
     SIZE 4 BY 1.25 TOOLTIP "Descontabilizar Rateio"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHistorico 
     IMAGE-UP FILE "adeicon/rpt-u.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Hist¢rico" 
     SIZE 4 BY 1.25 TOOLTIP "Hist¢rico de Bloqueios e Liberaá‰es"
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE cb-status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Status" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Em Digitaá∆o","Liberado" 
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE fi-competencia AS CHARACTER FORMAT "99/9999":U 
     LABEL "Competància" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 2.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.13.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-contabilizado AS LOGICAL INITIAL no 
     LABEL "Contabilizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-total AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE BUTTON bt-eliminar-todos 
     LABEL "Eliminar Todos" 
     SIZE 12.43 BY 1 TOOLTIP "Eliminar todos os Rateios".

DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 12.43 BY 1 TOOLTIP "Importar Dados Rateio".

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttint-rateio-fatur SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttint-rateio-plan SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttint-rateio-fatur.nr-fatura FORMAT "x(16)":U WIDTH 10
      ttint-rateio-fatur.vl-origem FORMAT ">>>,>>>,>>9.99":U WIDTH 15
      ttint-rateio-fatur.vl-deducao FORMAT "->>,>>9.99":U WIDTH 15
      ttint-rateio-fatur.vl-base-rateio FORMAT "->>,>>9.99":U WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.04
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttint-rateio-plan.cod-estabel-rat FORMAT "x(5)":U WIDTH 10
      ttint-rateio-plan.cod-centro-custo FORMAT "x(11)":U WIDTH 16
      ttint-rateio-plan.cod-unid-neg COLUMN-LABEL "Unid. Neg¢cio" FORMAT "x(4)":U
            WIDTH 15
      ttint-rateio-plan.vl-perc-rateio FORMAT ">>9.99":U WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.08
         FONT 2 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btDelete AT ROW 1.13 COL 35.14 HELP
          "Elimina ocorrància corrente"
     btDescontabiliza AT ROW 1.13 COL 65.29 HELP
          "Descontabilizaá∆o de Rateio" WIDGET-ID 28
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btHistorico AT ROW 1.17 COL 57 HELP
          "Hist¢rico de Bloqueios e Liberaá‰es" WIDGET-ID 22
     cb-status AT ROW 3.08 COL 74 COLON-ALIGNED WIDGET-ID 12
     ttint-rateio.tipo-rateio AT ROW 3.25 COL 14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-desc AT ROW 3.25 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-competencia AT ROW 4.25 COL 14 COLON-ALIGNED WIDGET-ID 24
     tg-contabilizado AT ROW 4.25 COL 26 WIDGET-ID 26
     bt-liberar AT ROW 4.75 COL 74.14 HELP
          "Libera o Rateio" WIDGET-ID 16
     bt-bloquear AT ROW 4.75 COL 81.86 HELP
          "Bloquear o rateio" WIDGET-ID 18
     ttint-rateio.cod-estabel AT ROW 5.25 COL 14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-desc-estab AT ROW 5.25 COL 23.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.63 COL 2
     RECT-1 AT ROW 4.29 COL 73 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 17.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
     fi-total AT ROW 10.54 COL 64 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.88
         SIZE 84.43 BY 10.63
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon2 AT ROW 10.33 COL 2
     btUpdateSon2 AT ROW 10.33 COL 12
     btDeleteSon2 AT ROW 10.33 COL 22
     bt-importar AT ROW 10.33 COL 29 HELP
          "Importaá∆o de Dados de Rateio" WIDGET-ID 2
     bt-eliminar-todos AT ROW 10.33 COL 41.57 HELP
          "Eliminar todos os Rateios" WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.88
         SIZE 84.43 BY 10.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-rateio T "?" NO-UNDO mgesp int-rateio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-rateio-fatur T "?" NO-UNDO mgesp int-rateio-fatur
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-rateio-plan T "?" NO-UNDO mgesp int-rateio-plan
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.63
         WIDTH              = 90.86
         MAX-HEIGHT         = 17.67
         MAX-WIDTH          = 92.14
         VIRTUAL-HEIGHT     = 17.67
         VIRTUAL-WIDTH      = 92.14
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
ASSIGN 
       fi-desc-estab:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       btAddSon2:HIDDEN IN FRAME fPage2           = TRUE.

ASSIGN 
       btDeleteSon2:HIDDEN IN FRAME fPage2           = TRUE.

ASSIGN 
       btUpdateSon2:HIDDEN IN FRAME fPage2           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttint-rateio-fatur"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttint-rateio-fatur.nr-fatura
"ttint-rateio-fatur.nr-fatura" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttint-rateio-fatur.vl-origem
"ttint-rateio-fatur.vl-origem" ? ? "decimal" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttint-rateio-fatur.vl-deducao
"ttint-rateio-fatur.vl-deducao" ? ? "decimal" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttint-rateio-fatur.vl-base-rateio
"ttint-rateio-fatur.vl-base-rateio" ? ? "decimal" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttint-rateio-plan"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttint-rateio-plan.cod-estabel-rat
"ttint-rateio-plan.cod-estabel-rat" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttint-rateio-plan.cod-centro-custo
"ttint-rateio-plan.cod-centro-custo" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttint-rateio-plan.cod-unid-neg
"ttint-rateio-plan.cod-unid-neg" "Unid. Neg¢cio" ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttint-rateio-plan.vl-perc-rateio
"ttint-rateio-plan.vl-perc-rateio" ? ? "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage2 wMasterDetail
ON ENTRY OF FRAME fPage2
DO:
      IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN
        RUN pi-habilita (INPUT YES).
    else
        RUN pi-habilita (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brSon2 IN FRAME fPage2
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-bloquear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bloquear wMasterDetail
ON CHOOSE OF bt-bloquear IN FRAME fPage0 /* Reabrir */
DO:
  
    DEF VAR c-erro AS CHAR FORMAT "X(200)" NO-UNDO.

    DO TRANS:

        FIND int-rateio EXCLUSIVE-LOCK
            WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
              AND int-rateio.competencia = ttint-rateio.competencia
              AND int-rateio.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.

        IF  AVAIL int-rateio THEN DO:

            RUN esp/fgl/esfglapi001.p (INPUT ROWID(int-rateio),
                                       INPUT c-seg-usuario,
                                       INPUT "L",
                                       OUTPUT c-erro).
            IF  RETURN-VALUE <> "OK" THEN DO:
                run utp/ut-msgs.p (input "show", INPUT 17006, input c-erro). 
                RETURN NO-APPLY.
            END.

            /* Pede confirmaá∆o */
            run utp/ut-msgs.p (input "show", INPUT 27100, input "Confirma Reabertura do Rateio?"). 

            IF  RETURN-VALUE <> "YES" THEN
                RETURN NO-APPLY.

            IF  int-rateio.id-contabilizado THEN do: /* Contabilizado */
                run utp/ut-msgs.p (input "show", input 15825 , input "Rateio j† contabilizado" + "~~" + 
                                   "Para reabrir o Rateio, Ç necess†rio primeiramente descontabiliz†-lo"). 
                RETURN NO-APPLY.
            END.


            ASSIGN int-rateio.id-status = 1. /* Em digitaá∆o */
            
            RUN pi-grava-historico(INPUT "B").
            run utp/ut-msgs.p (input "show", input 15825 , input "Status do Rateio alterado para 'Em Digitaá∆o'"). 

        END.
        ELSE DO:
            run utp/ut-msgs.p (input "show", input 15825 , input "Sem permiss∆o para alterar o status do Rateio. "). 

        END.
        FIND CURRENT int-rateio NO-LOCK.
        RELEASE int-rateio.

    END.

    DEF VAR r-row AS ROWID NO-UNDO.
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN hdboes908 (OUTPUT r-row).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-row).

    RUN "DisplayFields" IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-eliminar-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-todos wMasterDetail
ON CHOOSE OF bt-eliminar-todos IN FRAME fPage2 /* Eliminar Todos */
DO:
  IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN DO:
      FIND FIRST int-rateio NO-LOCK
          WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
            AND int-rateio.competencia = ttint-rateio.competencia
            AND int-rateio.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.
   
      IF  NOT AVAIL int-rateio THEN
          RETURN NO-APPLY.
   
   
      run utp/ut-msgs.p (input "show",
                         input 27100 ,
                         input "Confirma a Eliminaá∆o dos Rateios deste registro?").   
   
      IF RETURN-VALUE = "YES" THEN
      DO TRANS:
      
          /* Eliminando Registros Anteriores */
          FOR EACH int-rateio-plan EXCLUSIVE-LOCK
              WHERE int-rateio-plan.tipo-rateio      = int-rateio.tipo-rateio
                AND int-rateio-plan.competencia      = int-rateio.competencia
                AND int-rateio-plan.cod-estabel      = int-rateio.cod-estabel:
                DELETE int-rateio-plan.
          END.
   
      END.
      
      {masterdetail/openqueriesson.i &Parent="int-rateio"
                                     &Query="int-rateio-plan"
                                     &PageNumber="2"}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar wMasterDetail
ON CHOOSE OF bt-importar IN FRAME fPage2 /* Importar */
DO:
  IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN DO:
        FIND FIRST int-rateio NO-LOCK
            WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
              AND int-rateio.competencia = ttint-rateio.competencia
              AND int-rateio.cod-estabel = ttint-rateio.cod-estabel:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.
    
        IF  NOT AVAIL int-rateio THEN
            RETURN NO-APPLY.
    
        RUN esp/fgl/esfgl005d.w (INPUT ROWID(int-rateio)).
    
        {masterdetail/openqueriesson.i &Parent="int-rateio"
                                       &Query="int-rateio-plan"
                                       &PageNumber="2"}
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-liberar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-liberar wMasterDetail
ON CHOOSE OF bt-liberar IN FRAME fPage0 /* Liberar */
DO:
  
    DEFINE VARIABLE c-erro           AS CHAR FORMAT "X(200)" NO-UNDO.
    DEFINE VARIABLE de_sdo_transit   AS DECIMAL              NO-UNDO.

    DO TRANS:
        FIND int-rateio EXCLUSIVE-LOCK
            WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
              AND int-rateio.competencia = ttint-rateio.competencia
              AND int-rateio.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.

        IF  AVAIL int-rateio THEN DO:

            RUN esp/fgl/esfglapi001.p (INPUT ROWID(int-rateio),
                                       INPUT c-seg-usuario,
                                       INPUT "L",
                                       OUTPUT c-erro).
            IF  RETURN-VALUE <> "OK" THEN DO:
                run utp/ut-msgs.p (input "show", INPUT 17006, input c-erro). 
                RETURN NO-APPLY.
            END.

            /* Buscar conta transit¢ria para validar saldo */
            ASSIGN c-ct-transitoria = "".
            FOR EACH int-rat-desp-lancto NO-LOCK
                WHERE int-rat-desp-lancto.tipo-rateio = ttint-rateio.tipo-rateio:
                CASE int-rat-desp-lancto.tipo-lancto:
                    WHEN 1 THEN c-ct-transitoria = int-rat-desp-lancto.ct-codigo.
                END.
            END.

            RUN pi-valida-sdo-transit.

            for each tt_retorna_sdo_ctbl
                WHERE tt_retorna_sdo_ctbl.tta_cod_estab = ttint-rateio.cod-estabel:

                ASSIGN de_sdo_transit = de_sdo_transit + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.

            IF  ABS(de_sdo_transit) < INPUT FRAME fpage1 fi-total
            THEN DO:
                run utp/ut-msgs.p (input "show", 
                                   input 17006, 
                                   input "Saldo da transit¢ria Ç inferior ao total para rateio.~~Saldo Transit¢ria: " + TRIM(STRING(ABS(de_sdo_transit),"->>>,>>>,>>9.99"))). 
                RETURN NO-APPLY.
            END.
                           
            /* Pede confirmaá∆o */
            run utp/ut-msgs.p (input "show", INPUT 27100, input "Confirma Liberaá∆o do Rateio?"). 

            IF  RETURN-VALUE <> "YES" THEN
                RETURN NO-APPLY.

            ASSIGN int-rateio.id-status = 2. /* Liberado */

            RUN pi-grava-historico(INPUT "L").
            
            run utp/ut-msgs.p (input "show", input 15825 , input "Status do Rateio alterado para 'Liberado"). 

        END.
        ELSE DO:
            run utp/ut-msgs.p (input "show", input 15825 , input "Sem permiss∆o para alterar o status do Rateio. "). 
        END.
        FIND CURRENT int-rateio NO-LOCK.
        RELEASE int-rateio.
    END.

    DEF VAR r-row AS ROWID NO-UNDO.
    RUN getRowid IN hdboes908 (OUTPUT r-row).

    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-row).

    RUN "DisplayFields" IN THIS-PROCEDURE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/fgl/esfgl005a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
       
    ASSIGN g-inclusao   = YES.

    IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN DO:
        {masterdetail/addson.i &ProgramSon="esp/fgl/esfgl005b.w"
                               &PageNumber="1"}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    ASSIGN g-inclusao   = YES.

    {masterdetail/addson.i &ProgramSon="esp/fgl/esfgl005c.w"
                           &PageNumber="2"}
                           
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN DO:
        {masterdetail/deleteson.i &PageNumber="1"}
    END.

    DEF VAR de-total AS DEC NO-UNDO.
    RUN pi-totaliza-base-rateio (OUTPUT de-total).
    ASSIGN fi-total:SCREEN-VALUE IN FRAME fpage1 = STRING(de-total).

    {&OPEN-QUERY-brSon1}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}

    {&OPEN-QUERY-brSon1}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDescontabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDescontabiliza wMasterDetail
ON CHOOSE OF btDescontabiliza IN FRAME fPage0 /* Descontabilizar Rateio */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
  
    IF  AVAIL ttint-rateio AND NOT ttint-rateio.id-contabilizado THEN
        RETURN NO-APPLY.
    DEF VAR c-erro AS CHAR FORMAT "X(200)" NO-UNDO.

    DO TRANS:

        FIND int-rateio EXCLUSIVE-LOCK
            WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
              AND int-rateio.competencia = ttint-rateio.competencia
              AND int-rateio.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.

        IF  AVAIL int-rateio THEN DO:

            RUN esp/fgl/esfglapi001.p (INPUT ROWID(int-rateio),
                                       INPUT c-seg-usuario,
                                       INPUT "C",
                                       OUTPUT c-erro).
            IF  RETURN-VALUE <> "OK" THEN DO:
                run utp/ut-msgs.p (input "show", INPUT 17006, input c-erro). 
                RETURN NO-APPLY.
            END.

            /* Pede confirmaá∆o */
            run utp/ut-msgs.p (input "show", INPUT 27100, input "Confirma Descontabilizaá∆o do Rateio?" + "~~" +
                               "Ao Descontabilizar o Rateio, por favor eliminar o lote gerado anteriormente por ele na contabilidade."). 

            IF  RETURN-VALUE <> "YES" THEN
                RETURN NO-APPLY.

            ASSIGN int-rateio.id-contabilizado = NO. /* N∆o Contabilizado */
            
            RUN pi-grava-historico(INPUT "D" /* Descontabilizaá∆o */).
            run utp/ut-msgs.p (input "show", input 15825 , input "Rateio descontabilizado. Gentileza eliminar o lote remanssente na contabilidade." + "~~" +
                                "OBS: AtravÇs do Bot∆o <Hist¢rico>, Ç poss°vel consultar as Liberaá‰es, Reaberturas, bem como a contabilizaá∆o e descontabilizaá∆o do rateio." ). 

        END.
        ELSE DO:
            run utp/ut-msgs.p (input "show", input 15825 , input "Sem permiss∆o para alterar descontabilizar o rateio. "). 

        END.
        FIND CURRENT int-rateio NO-LOCK.
        RELEASE int-rateio.

    END.

    DEF VAR r-row AS ROWID NO-UNDO.
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN hdboes908 (OUTPUT r-row).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-row).

    RUN "DisplayFields" IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistorico wMasterDetail
ON CHOOSE OF btHistorico IN FRAME fPage0 /* Hist¢rico */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
  
    FIND int-rateio EXCLUSIVE-LOCK
        WHERE int-rateio.tipo-rateio = ttint-rateio.tipo-rateio
          AND int-rateio.competencia = ttint-rateio.competencia
          AND int-rateio.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.
    IF NOT AVAIL int-rateio THEN
        RETURN NO-APPLY.

    RUN esp/fgl/esfgl005e.w (INPUT ROWID(int-rateio)).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01esfgl005.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    g-inclusao   = NO.

    IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN DO:
        {masterdetail/updateson.i &ProgramSon="esp/fgl/esfgl005b.w"
                                  &PageNumber="1"}
    END.

    {&OPEN-QUERY-brSon1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    g-inclusao   = NO.
    {masterdetail/updateson.i &ProgramSon="esp/fgl/esfgl005c.w"
                              &PageNumber="2"}
                              
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMasterDetail 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN
        ASSIGN cb-status:SCREEN-VALUE IN FRAME fpage0 = "Em Digitaá∆o".
    ELSE
        ASSIGN cb-status:SCREEN-VALUE IN FRAME fpage0 = "Liberado".

    FIND FIRST int-rat-desp NO-LOCK
        WHERE int-rat-desp.tipo-rateio = ttint-rateio.tipo-rateio NO-ERROR.

    IF  AVAIL int-rat-desp THEN
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = int-rat-desp.descricao.
    ELSE
        ASSIGN fi-desc:SCREEN-VALUE IN FRAME fpage0 = "".


    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.
    IF  AVAIL estabelec THEN
        ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fpage0 = estabelec.nome.
    ELSE
        ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fpage0 = "".

    IF  AVAIL ttint-rateio THEN DO:
        IF  ttint-rateio.id-status = 1 THEN
            ASSIGN bt-bloquear:SENSITIVE IN FRAME fpage0 = NO
                   bt-liberar:SENSITIVE IN FRAME fpage0  = YES.
        ELSE
            ASSIGN bt-bloquear:SENSITIVE IN FRAME fpage0 = YES
                   bt-liberar:SENSITIVE IN FRAME fpage0  = NO.
    END.

    IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN
        RUN pi-habilita (INPUT YES).
    else
        RUN pi-habilita (INPUT NO).

    IF  AVAIL ttint-rateio THEN 
        ASSIGN fi-competencia:SCREEN-VALUE IN FRAME fpage0 = SUBSTR(ttint-rateio.competencia, 5, 2) + "/" + SUBSTR(ttint-rateio.competencia, 1, 4)
               tg-contabilizado:CHECKED IN FRAME fpage0 = ttint-rateio.id-contabilizado.
    ELSE
        ASSIGN fi-competencia:SCREEN-VALUE IN FRAME fpage0 = "00/0000".

    IF  AVAIL ttint-rateio AND ttint-rateio.id-contabilizado THEN
        ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = YES.
    ELSE
        ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = NO.


     RUN OpenQueriesSon IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMasterDetail 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  AVAIL ttint-rateio AND ttint-rateio.id-status = 1 THEN
        RUN pi-habilita (INPUT YES).
    else
        RUN pi-habilita (INPUT NO).

   IF  AVAIL ttint-rateio AND ttint-rateio.id-contabilizado THEN
       ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = YES.
   ELSE
       ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMasterDetail 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL ttint-rateio THEN DO:
        IF  ttint-rateio.id-status = 1 THEN
            ASSIGN bt-bloquear:SENSITIVE IN FRAME fpage0 = NO
                   bt-liberar:SENSITIVE IN FRAME fpage0  = YES.
        ELSE
            ASSIGN bt-bloquear:SENSITIVE IN FRAME fpage0 = YES
                   bt-liberar:SENSITIVE IN FRAME fpage0  = NO.
    END.

    ASSIGN bt-importar:SENSITIVE IN FRAME fpage2       = YES
           bt-eliminar-todos:SENSITIVE IN FRAME fpage2 = YES
           btHistorico:SENSITIVE IN FRAME fpage0       = YES
           tg-Contabilizado:SENSITIVE IN FRAME fpage0   = NO.

    IF  AVAIL ttint-rateio AND ttint-rateio.id-contabilizado THEN
        ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = YES.
    ELSE
        ASSIGN btDescontabiliza:SENSITIVE IN FRAME fpage0 = NO.

    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
DEFINE BUTTON btGoToCancel AUTO-END-KEY 
             LABEL "&Cancelar" 
             SIZE 10 BY 1
             BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cCd-tipo-rateio LIKE {&ttParent}.tipo-rateio VIEW-AS FILL-IN SIZE 10 BY 0.88  NO-UNDO.
    DEFINE VARIABLE cCd-competencia LIKE {&ttParent}.competencia VIEW-AS FILL-IN SIZE 10 BY 0.88  NO-UNDO.
    DEFINE VARIABLE cCd-estabel     LIKE {&ttParent}.cod-estabel VIEW-AS FILL-IN SIZE 10 BY 0.88  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cCd-tipo-rateio      AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cCd-competencia      AT ROW 2.21 COL 17.72 COLON-ALIGNED
        cCd-estabel      AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK        AT ROW 4.63 COL 2.14
        btGoToCancel    AT ROW 4.63 COL 13
        rtGoToButton    AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para tipo-rateio TMS" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCd-tipo-rateio
               cCd-competencia
               cCd-estabel.
        
        /* Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cCd-tipo-rateio,
                                      INPUT substr(cCd-competencia, 1,4) + substr(cCd-competencia, 5, 2),
                                      INPUT cCd-estabel ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Rateio").
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCd-tipo-rateio cCd-competencia cCd-estabel btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
        
    
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes908.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes908.p YES}
        {btb/btb008za.i2 esbo/boes908.p '' {&hDBOParent}} 
    END.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes909.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes909.p YES}
        {btb/btb008za.i2 esbo/boes909.p '' {&hDBOSon1}}
    END.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes910.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes910.p YES}
        {btb/btb008za.i2 esbo/boes910.p '' {&hDBOSon2}}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR de-total AS DEC NO-UNDO.
    RUN pi-totaliza-base-rateio (OUTPUT de-total).
    
    {masterdetail/openqueriesson.i &Parent="int-rateio"
                                   &Query="int-rateio-fatur"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="int-rateio"
                                   &Query="int-rateio-plan"
                                   &PageNumber="2"}
                                   
    ASSIGN fi-total:SCREEN-VALUE IN FRAME fpage1 = STRING(de-total).
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-historico wMasterDetail 
PROCEDURE pi-grava-historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-tipo AS CHAR NO-UNDO.
    DEF BUFFER b-int-rateio-hist FOR int-rateio-hist.
    DEF VAR i-seq AS INTEGER INIT 1 NO-UNDO.
    DEF VAR c-aux AS CHAR NO-UNDO.

    CASE p-tipo:
        WHEN "L" THEN c-aux = "Liberado".
        WHEN "R" THEN c-aux = "Reabertura".
        WHEN "D" THEN c-aux = "Rateio Descontabilizado".
    END CASE.

    FIND LAST b-int-rateio-hist NO-LOCK
        WHERE b-int-rateio-hist.tipo-rateio = ttint-rateio.tipo-rateio
          AND b-int-rateio-hist.competencia = ttint-rateio.competencia
          AND b-int-rateio-hist.cod-estabel = ttint-rateio.cod-estabel NO-ERROR.

    IF  AVAIL b-int-rateio-hist THEN
        ASSIGN i-seq = b-int-rateio-hist.sequencia + 1.

    CREATE int-rateio-his.
    ASSIGN int-rateio-hist.tipo-rateio = ttint-rateio.tipo-rateio
           int-rateio-hist.competencia = ttint-rateio.competencia
           int-rateio-hist.cod-estabel = ttint-rateio.cod-estabel
           int-rateio-hist.sequencia   = i-seq
           int-rateio-hist.cod-usuario =  c-seg-usuario
           int-rateio-hist.data-hora   = DATETIME(TODAY, MTIME)
           int-rateio-hist.tp-acao     = IF p-tipo = "L" THEN 2 /*Liberaá∆o*/ 
                                           ELSE IF p-tipo = "R" THEN 1 /*Reabertura*/
                                              ELSE 3 /*Descontab.*/
           int-rateio-hist.ds-motivo   = c-aux + " pelo usu†rio " + c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita wMasterDetail 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-acao AS LOG NO-UNDO.


    ASSIGN btAddSon1:SENSITIVE IN FRAME fpage1         = p-acao
           btUpdateSon1:SENSITIVE IN FRAME fpage1      = p-acao
           btDeleteSon1:SENSITIVE IN FRAME fpage1      = p-acao
           bt-Importar:SENSITIVE IN FRAME fpage2       = p-acao
           bt-Eliminar-todos:SENSITIVE IN FRAME fpage2 = p-acao
           btDelete:SENSITIVE IN FRAME fpage0          = p-acao.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza-base-rateio wMasterDetail 
PROCEDURE pi-totaliza-base-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-total AS DEC NO-UNDO.
    
    FOR EACH int-rateio-fatur NO-LOCK
        WHERE int-rateio-fatur.tipo-rateio = ttint-rateio.tipo-rateio
          AND int-rateio-fatur.competencia = ttint-rateio.competencia
          AND int-rateio-fatur.cod-estabel = ttint-rateio.cod-estabel:

        ASSIGN p-total = p-total + int-rateio-fatur.vl-base-rateio.
    END.
        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-sdo-transit wMasterDetail 
PROCEDURE pi-valida-sdo-transit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE da-data AS DATE        NO-UNDO.
    
    ASSIGN da-data = ADD-INTERVAL(TODAY,1 ,"MONTH") - DAY(TODAY).

    EMPTY TEMP-TABLE tt_input_leitura_sdo. 
    EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.  
    EMPTY TEMP-TABLE tt_log_erros.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
           tt_input_leitura_sdo.ttv_des_conteudo = "1"
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 1.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econìmica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = c-ct-transitoria
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = c-ct-transitoria
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 4.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(da-data, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.
    
    run prgfin/fgl/fgl905zb.py (Input 1,
                                Input table  tt_input_leitura_sdo,
                                output table tt_retorna_sdo_ctbl,
                                output table tt_log_erros).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

