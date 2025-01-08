&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*
{include/i-prgvrs.i XX9999 9.99.99.999}
  */
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{utp/ut-glob.i}

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
/* Local Variable Definitions ---                                       */
DEF VAR hproc       AS HANDLE.

DEF VAR hbrowse1    AS HANDLE.
DEF VAR wh-browse   AS WIDGET-HANDLE.
DEF VAR hvalor_real AS HANDLE.

DEFINE VARIABLE hbtb        AS HANDLE.
DEFINE VARIABLE h_frame     AS WIDGET     NO-UNDO.
DEFINE VARIABLE p-wgh-frame AS WIDGET     NO-UNDO.

DEF VAR hbrowsecc   AS HANDLE.
DEF VAR hbrowsetot  AS HANDLE.
DEF VAR hQuerytot   AS HANDLE.
DEF VAR hBuffertot  AS HANDLE.
DEF STREAM s.
DEF VAR X AS LOG.

def var h-acomp     as handle no-undo.

DEFINE VARIABLE h-serv    AS HANDLE                    NO-UNDO.


DEFINE VARIABLE vhCurColHdl  AS HANDLE    NO-UNDO.
DEFINE VARIABLE vhCurColtot  AS HANDLE    NO-UNDO.

DEFINE VARIABLE vcColHandles AS CHAR NO-UNDO.
DEFINE VARIABLE vcColHtotais AS CHAR NO-UNDO.

DEF VAR r-consulta AS RECID.

DEF VAR c-cod-un  LIKE movto_real_orcto.cod_unid_negoc.

DEF VAR i-coluna AS INT INIT 1.
def var i        as integer   no-undo.
def var hColumn  as handle    no-undo.
def var hBf      as handle    no-undo.

DEF VAR hBuffer     AS HANDLE.

DEF VAR hQuery1      AS HANDLE.

DEF VAR c-label1    AS CHAR.
DEF VAR i-tot-reg   AS INT.
def var i-cont      as int.
def var c-label     as char extent 120.
def var c-linha     as char.
def var i-comp      as int.
DEF VAR l-ok        AS LOG EXTENT 12.
DEF VAR i-mes       AS INT EXTENT 12.
DEF VAR i-ano       AS INT EXTENT 12.
DEF VAR i-periodo   AS INT.
DEF VAR c-mes-ant   AS CHAR.
DEF VAR c-ano-ant   AS CHAR.
DEF VAR de-cotacao  AS DEC FORMAT ">>>9.999999".
DEF VAR c-usuario AS CHAR NO-UNDO.
DEF VAR i-ano-x AS INT.
DEF VAR c-cc-codigo AS CHAR.
DEF VAR c-segur AS CHAR.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEF VAR l-teste AS LOGICAL NO-UNDO.
DEF VAR c-connect LIKE servid_rpc.des_carg_rpc NO-UNDO.

DEF VAR vColumnHandles AS HANDLE EXTENT 36 NO-UNDO.

DEF VAR vColumnhtot    AS HANDLE EXTENT 36 NO-UNDO.

DEF NEW GLOBAL SHARED VAR c_lista_estabel AS CHAR NO-UNDO.
def new global shared var c_lista_cc      as character format "x(80)":U 
    no-undo. 


def var v_log_method
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.

DEF TEMP-TABLE tt-usuar-cc
    FIELD l-selec         AS LOGICAL FORMAT "+/-" INIT NO
    FIELD cod_estabel     AS CHAR COLUMN-LABEL "Est"
    FIELD cod_ccusto      AS CHAR COLUMN-LABEL "Centro Custos"
    FIELD cod_unid_negoc  AS CHAR COLUMN-LABEL "UN"
    FIELD des_ccusto      AS CHAR COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)"
    INDEX cc IS PRIMARY  cod_estabel
                         cod_ccusto.

DEF TEMP-TABLE tt-usuar-disp
    FIELD l-selec         AS LOGICAL FORMAT "+/-" INIT NO
    FIELD cod_ccusto      AS CHAR COLUMN-LABEL "Centro Custos"
    FIELD des_ccusto      AS CHAR COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)"
    INDEX cc IS PRIMARY cod_ccusto.

{esp/es0018.i}


DEF TEMP-TABLE tt-param
    FIELD c-cod-unid-orcta  LIKE sdo_orcto_ctbl_bgc.cod_unid_orctaria 
    FIELD num-seq-orcto-ctb LIKE sdo_orcto_ctbl.num_seq_orcto_ctbl   
    FIELD cod-versao-orcto  LIKE sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl 
    FIELD c-cod-ini         LIKE cta_ctbl.cod_cta_ctbl
    FIELD c-cod-fim         LIKE cta_ctbl.cod_cta_ctbl.

DEF TEMP-TABLE tt-consulta-res
    field cod_empresa         LIKE movto_real_orcto.cod_empresa       COLUMN-LABEL "Emp"
    field cod_estab           LIKE movto_real_orcto.cod_estab         COLUMN-LABEL "Est"
    field cod_cenar_ctbl      LIKE movto_real_orcto.cod_cenar_ctbl    COLUMN-LABEL "Cen rio"
    field cod_plano_cta_ctbl  like movto_real_orcto.cod_plano_cta_ctb COLUMN-LABEL "Plano Cta"
    field cod_plano_ccusto    like movto_real_orcto.cod_plano_ccusto  COLUMN-LABEL "Plano CC"
    field cod_cta_ctbl        like movto_real_orcto.cod_cta_ctbl      COLUMN-LABEL "Cta"
    FIELD des_cta_ctbl        LIKE cta_ctbl.des_tit_ctbl         COLUMN-LABEL "Descri‡Æo Cta"
    field cod_ccusto          like movto_real_orcto.cod_ccusto        COLUMN-LABEL "C.Custo"
    field cod_unid_negoc      like movto_real_orcto.cod_unid_negoc    COLUMN-LABEL "Un"
    field cod_proj_financ     like movto_real_orcto.cod_proj_financ   COLUMN-LABEL "Proj"
    field c-per-ano-1         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 1"
    field valor_rea-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 1"
    field valor_orc-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 1"
    field de-var-1            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-2         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 2"
    field valor_rea-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 2"
    field valor_orc-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 2"
    field de-var-2            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-3         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 3"
    field valor_rea-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 3"
    field valor_orc-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 3"
    field de-var-3            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-4         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 4"
    field valor_rea-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 4"
    field valor_orc-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 4"
    field de-var-4            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-5         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 5"
    field valor_rea-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 5"   
    field valor_orc-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 5"
    field de-var-5            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-6         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 6"
    field valor_rea-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 6"
    field valor_orc-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 6"
    field de-var-6            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-7         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 7"
    field valor_rea-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 7"
    field valor_orc-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 7"
    field de-var-7            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-8         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 8"
    field valor_rea-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 8"
    field valor_orc-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 8"
    field de-var-8            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-9         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 9"
    field valor_rea-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 9"
    field valor_orc-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 9"
    field de-var-9            AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-10        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 10"
    field valor_rea-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 10"
    field valor_orc-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 10"
    field de-var-10           AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-11        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 11"
    field valor_rea-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 11"
    field valor_orc-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 11"
    field de-var-11           AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    field c-per-ano-12        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 12"
    field valor_rea-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 12"   
    field valor_orc-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 12"
    field de-var-12           AS DECIMAL FORMAT "->>>>>>9.99"         COLUMN-LABEL "%"
    INDEX idx_codigo is PRIMARY 
            cod_cta_ctbl
    INDEX id-estab
            cod_estab
    INDEX idx_resumo
            cod_empresa           
            cod_estab             
            cod_cenar_ctbl        
            cod_plano_cta_ctbl    
            cod_plano_ccusto      
            cod_cta_ctbl          
            cod_ccusto            
            cod_unid_negoc        
            cod_proj_financ.

def temp-table tt-display
    FIELD acao          AS CHAR FORMAT "x(3)" LABEL ""
    FIELD ind_espec_cta_ctbl  AS CHAR LABEL ""
    FIELD cod_cta_ctbl  AS CHAR FORMAT "x(8)" LABEL "Conta"
    FIELD descricao     AS CHAR FORMAT "x(1000)"
    FIELD tot-mes       AS DEC FORMAT "->>>,>>>,>>9" EXTENT 12 LABEL ""
    FIELD real-mes      AS DEC FORMAT "->>>,>>>,>>9" EXTENT 12 LABEL ""
    FIELD var-mes       AS DEC FORMAT "->>9.9"       EXTENT 12 LABEL ""
    FIELD tot-acum      AS DEC FORMAT "->>>,>>>,>>9" LABEL "Or‡ado Acum"
    FIELD real-acum     AS DEC FORMAT "->>>,>>>,>>9" LABEL "Real Acum"
    FIELD var-acum      AS DEC FORMAT "->>>9.9"           LABEL "% Acum"
    INDEX codigo is PRIMARY cod_cta_ctbl.


DEF TEMP-TABLE tt-totais
    FIELD cod-estabel         LIKE movto_real_orcto.cod_estab
    field valor_rea-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 1"
    field valor_orc-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 1"
    field de-var-1            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 2"
    field valor_orc-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 2"
    field de-var-2            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 3"
    field valor_orc-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 3"
    field de-var-3            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"          
    field valor_rea-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 4"
    field valor_orc-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 4"
    field de-var-4            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 5"   
    field valor_orc-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 5"
    field de-var-5            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"          
    field valor_rea-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 6"
    field valor_orc-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 6"
    field de-var-6            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 7"
    field valor_orc-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 7"
    field de-var-7            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 8"
    field valor_orc-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 8"
    field de-var-8            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 9"
    field valor_orc-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 9"
    field de-var-9            AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 10"
    field valor_orc-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 10"
    field de-var-10           AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 11"
    field valor_orc-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 11"
    field de-var-11           AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%"
    field valor_rea-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 12"   
    field valor_orc-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 12"
    field de-var-12           AS DECIMAL FORMAT "->>>>>>9.99"           COLUMN-LABEL "%".

DEF BUFFER b-tt-totais FOR tt-totais.

DEF TEMP-TABLE tt-totais-display LIKE tt-totais.

DEF TEMP-TABLE tt-dados-consulta LIKE movto_real_orcto
    FIELD r-resumo AS RECID
    FIELD des_cta AS CHAR FORMAT "X(40)"
    FIELD des_cc  AS CHAR FORMAT "X(40)"
    FIELD nome_forn AS CHAR FORMAT "X(40)".

DEF TEMP-TABLE tt-dados-consulta-aux
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".
  
DEF BUFFER btt-display FOR tt-display.

DEF TEMP-TABLE tt-uni
    FIELD unidade AS CHAR
    FIELD divisao AS CHAR
    FIELD cod_ccusto AS CHAR 
    INDEX codigo IS PRIMARY unidade divisao cod_ccusto.

    {utp\utapi001.i}
  
DEF TEMP-TABLE tt-conta
    FIELD cod_cta_ctbl AS CHAR
    FIELD mes AS INT
    FIELD ano AS INT
    FIELD valor-orcado AS DEC
    FIELD valor-real AS DEC
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.


DEF TEMP-TABLE tt-conta-tot
    FIELD cod_cta_ctbl AS CHAR
    FIELD valor-orcado AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-real AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

DEF TEMP-TABLE tt-estoque
    FIELD cod_cta_ctbl AS CHAR
    FIELD dia AS INT FORMAT "99"
    FIELD mes AS INT
    FIELD ano AS INT
    FIELD valor AS DEC FORMAT "->>>,>>>,>>9.999999" 
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

DEF TEMP-TABLE tt-estoque-tot
    FIELD cod_cta_ctbl AS CHAR
    FIELD dia AS INT FORMAT "99"
    FIELD valor AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

DEFINE TEMP-TABLE tt_Size NO-UNDO
    FIELD wg_Name AS CHARACTER
    FIELD wg_Width AS DECIMAL
    FIELD wg_Height AS DECIMAL
    FIELD wg_Xpos AS DECIMAL
    FIELD wg_Ypos AS DECIMAL
    INDEX wg_Name IS PRIMARY wg_Name.
    DEFINE BUFFER bf_Size FOR tt_Size.

def var iStyle                           as integer   no-undo init ?.
def var iOldMenu                         as integer   no-undo.
def var dColWin                          as decimal   no-undo.
def var dRowWin                          as decimal   no-undo.
def var dHeiWin                          as decimal   no-undo.
def var dWidWin                          as decimal   no-undo.

def new global shared var v_rec_centro-custo
    as recid 
    format ">>>>>>9":U 
    initial ? 
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-centro-custos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-usuar-disp tt-consulta-res ~
tt-totais-display

/* Definitions for BROWSE br-centro-custos                              */
&Scoped-define FIELDS-IN-QUERY-br-centro-custos tt-usuar-disp.l-selec tt-usuar-disp.cod_ccusto tt-usuar-disp.des_ccusto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-centro-custos   
&Scoped-define SELF-NAME br-centro-custos
&Scoped-define QUERY-STRING-br-centro-custos FOR EACH  tt-usuar-disp
&Scoped-define OPEN-QUERY-br-centro-custos OPEN QUERY br-centro-custos FOR EACH  tt-usuar-disp.
&Scoped-define TABLES-IN-QUERY-br-centro-custos tt-usuar-disp
&Scoped-define FIRST-TABLE-IN-QUERY-br-centro-custos tt-usuar-disp


/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-consulta-res.cod_estab tt-consulta-res.cod_cta_ctbl tt-consulta-res.des_cta_ctbl tt-consulta-res.cod_ccusto tt-consulta-res.cod_unid_negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos   
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH tt-consulta-res
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME} FOR EACH tt-consulta-res.
&Scoped-define TABLES-IN-QUERY-br-movimentos tt-consulta-res
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos tt-consulta-res


/* Definitions for BROWSE br-totais                                     */
&Scoped-define FIELDS-IN-QUERY-br-totais tt-totais-display.cod-estabel   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-totais   
&Scoped-define SELF-NAME br-totais
&Scoped-define QUERY-STRING-br-totais FOR EACH tt-totais-display
&Scoped-define OPEN-QUERY-br-totais OPEN QUERY {&SELF-NAME} FOR EACH tt-totais-display.
&Scoped-define TABLES-IN-QUERY-br-totais tt-totais-display
&Scoped-define FIRST-TABLE-IN-QUERY-br-totais tt-totais-display


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-centro-custos}~
    ~{&OPEN-QUERY-br-movimentos}~
    ~{&OPEN-QUERY-br-totais}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-totais bt-full-screen bt-print ~
bt-todos-cc l-dest-est bt-zoom bt_seg bt_faixa_ct br-centro-custos ~
l-ccusto-ativo l-ccusto-inativo l-orcado l-realizado l-variacao cb-mes[1] ~
cb-ano[1] cb-mes[7] cb-ano[7] cb-mes[8] cb-ano[8] bt-preenche cb-mes[9] ~
cb-ano[9] cb-mes[2] cb-ano[2] cb-mes[10] cb-ano[10] cb-mes[3] cb-ano[3] ~
cb-mes[11] cb-ano[11] cb-mes[4] cb-ano[4] cb-mes[12] cb-ano[12] cb-mes[5] ~
cb-ano[5] bt-importa cb-mes[6] cb-ano[6] br-movimentos c-nome-cc bt-go ~
bt-xl bt-nenhum-cc bt-limpar bt-go-2 RECT-5 RECT-6 RECT-7 
&Scoped-Define DISPLAYED-OBJECTS l-dest-est fi-estabelecimento ~
l-ccusto-ativo l-ccusto-inativo l-orcado l-realizado l-variacao cb-mes[1] ~
cb-ano[1] cb-mes[7] cb-ano[7] cb-mes[8] cb-ano[8] cb-mes[9] cb-ano[9] ~
cb-mes[2] cb-ano[2] cb-mes[10] cb-ano[10] cb-mes[3] cb-ano[3] cb-mes[11] ~
cb-ano[11] cb-mes[4] cb-ano[4] cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] ~
cb-mes[6] cb-ano[6] c-nome-cc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-full-screen 
     IMAGE-UP FILE "image/tela-inteira.bmp":U
     LABEL "Maximizar" 
     SIZE 4 BY 1 TOOLTIP "Tela Inteira".

DEFINE BUTTON bt-go 
     IMAGE-UP FILE "IMAGE/im-enter.bmp":U
     LABEL "Btn 1" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-go-2 
     IMAGE-UP FILE "adeicon/props.bmp":U
     LABEL "Btn 1" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-importa 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Importa Arquivos" 
     SIZE 4 BY 1 TOOLTIP "Pesquisar valores com os filtros informados"
     BGCOLOR 15 FGCOLOR 11 .

DEFINE BUTTON bt-limpar 
     LABEL "Limpar" 
     SIZE 7 BY .75.

DEFINE BUTTON bt-nenhum-cc 
     LABEL "Nenhum" 
     SIZE 6.29 BY 1.

DEFINE BUTTON bt-preenche 
     LABEL "Preenche" 
     SIZE 7 BY .75.

DEFINE BUTTON bt-print 
     IMAGE-UP FILE "image/im-pri.gif":U NO-CONVERT-3D-COLORS
     LABEL "Relat¢rio" 
     SIZE 4 BY 1 TOOLTIP "Relat¢rio Or‡amento".

DEFINE BUTTON bt-todos-cc 
     LABEL "Todos" 
     SIZE 5.72 BY 1.

DEFINE BUTTON bt-xl 
     IMAGE-UP FILE "image/excel.gif":U
     LABEL "XL" 
     SIZE 4 BY 1 TOOLTIP "Exporta Consulta Excel".

DEFINE BUTTON bt-zoom 
     IMAGE-UP FILE "adeicon/props.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.

DEFINE BUTTON bt_faixa_ct 
     IMAGE-UP FILE "image/im-ran_a.gif":U
     IMAGE-INSENSITIVE FILE "IMAGE/ii-ran.bmp":U
     LABEL "Sele‡Æo" 
     SIZE 4 BY 1 TOOLTIP "Faixa Contas".

DEFINE BUTTON bt_seg 
     IMAGE-UP FILE "image/im-segu2.gif":U
     IMAGE-INSENSITIVE FILE "image/ii-segur":U
     LABEL "Det" 
     SIZE 4 BY 1 TOOLTIP "Seguran‡a Or‡amento".

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U EXTENT 12
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEMS "2018","2019","2020","2021","2022","2023","2024","2025","2026" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

ASSIGN cb-ano = STRING(YEAR(TODAY)).

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U  EXTENT 12
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "","0",
                     "Janeiro","1",
                     "Fevereiro","2",
                     "Mar‡o","3",
                     "Abril","4",
                     "Maio","5",
                     "Junho","6",
                     "Julho","7",
                     "Agosto","8",
                     "Setembro","9",
                     "Outubro","10",
                     "Novembro","11",
                     "Dezembro","12",
                     "Nenhum","13"
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE c-nome-cc AS CHARACTER FORMAT "X(5)":U 
     LABEL "CC" 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY 1 NO-UNDO.

DEFINE VARIABLE fi-estabelecimento AS CHARACTER FORMAT "X(80)":U INITIAL "101" 
     LABEL "Estabel." 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 7.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 1.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 156.29 BY 1.75
     BGCOLOR 7 .

DEFINE VARIABLE l-ccusto-ativo AS LOGICAL INITIAL yes 
     LABEL "CCusto Ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ccusto-inativo AS LOGICAL INITIAL no 
     LABEL "CCusto Inativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-dest-est AS LOGICAL INITIAL NO
     LABEL "Destaca Estouro" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-orcado AS LOGICAL INITIAL yes 
     LABEL "Or‡ado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-realizado AS LOGICAL INITIAL yes 
     LABEL "Realizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-variacao AS LOGICAL INITIAL yes 
     LABEL "Varia‡Æo (R) X (O)" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-centro-custos FOR 
      tt-usuar-disp SCROLLING.

DEFINE QUERY br-movimentos FOR 
      tt-consulta-res SCROLLING.

DEFINE QUERY br-totais FOR 
      tt-totais-display SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-centro-custos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-centro-custos w-livre _FREEFORM
  QUERY br-centro-custos DISPLAY
      tt-usuar-disp.l-selec    COLUMN-LABEL "+/-"
tt-usuar-disp.cod_ccusto
tt-usuar-disp.des_ccusto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 10.75
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos w-livre _FREEFORM
  QUERY br-movimentos DISPLAY
      tt-consulta-res.cod_estab
tt-consulta-res.cod_cta_ctbl  FORMAT "9.9.9.99.999"
tt-consulta-res.des_cta_ctbl   
tt-consulta-res.cod_ccusto
tt-consulta-res.cod_unid_negoc FORMAT "X(3)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 111 BY 18.5
         FONT 1 ROW-HEIGHT-CHARS 3.5.

DEFINE BROWSE br-totais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-totais w-livre _FREEFORM
  QUERY br-totais DISPLAY
      tt-totais-display.cod-estabel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 111.29 BY 3.75
         FONT 1 ROW-HEIGHT-CHARS .29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-totais AT ROW 21.96 COL 47 WIDGET-ID 300
     bt-full-screen AT ROW 1.38 COL 136.29 WIDGET-ID 24
     bt-print AT ROW 1.38 COL 140.57 WIDGET-ID 20
     bt-todos-cc AT ROW 13.75 COL 29 WIDGET-ID 14
     l-dest-est AT ROW 3.38 COL 29.14 WIDGET-ID 18
     bt-zoom AT ROW 1.33 COL 47.14 WIDGET-ID 4
     fi-estabelecimento AT ROW 1.33 COL 2.71 WIDGET-ID 2
     bt_seg AT ROW 1.38 COL 149.14
     bt_faixa_ct AT ROW 1.38 COL 153.43 WIDGET-ID 6
     br-centro-custos AT ROW 15 COL 2 WIDGET-ID 100
     l-ccusto-ativo AT ROW 3.38 COL 2.72
     l-ccusto-inativo AT ROW 3.33 COL 15.14
     l-orcado AT ROW 4.58 COL 2.72
     l-realizado AT ROW 4.58 COL 13
     l-variacao AT ROW 4.58 COL 24
     cb-mes[1] AT ROW 6.04 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[1] AT ROW 6.04 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[7] AT ROW 6.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[7] AT ROW 6.04 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[8] AT ROW 7.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[8] AT ROW 7.04 COL 35 COLON-ALIGNED NO-LABEL
     bt-preenche AT ROW 7.25 COL 4
     cb-mes[9] AT ROW 8.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[9] AT ROW 8.04 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[2] AT ROW 8.29 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[2] AT ROW 8.29 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[10] AT ROW 9.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[10] AT ROW 9.04 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[3] AT ROW 9.29 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[3] AT ROW 9.29 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[11] AT ROW 10.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[11] AT ROW 10.04 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[4] AT ROW 10.29 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[4] AT ROW 10.29 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[12] AT ROW 11.04 COL 24 COLON-ALIGNED NO-LABEL
     cb-ano[12] AT ROW 11.04 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[5] AT ROW 11.29 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[5] AT ROW 11.29 COL 12 COLON-ALIGNED NO-LABEL
     bt-importa AT ROW 12.04 COL 41
     cb-mes[6] AT ROW 12.29 COL 1 COLON-ALIGNED NO-LABEL
     cb-ano[6] AT ROW 12.29 COL 12 COLON-ALIGNED NO-LABEL
     br-movimentos AT ROW 3.21 COL 46.72 HELP
          "Clique para detalhe" WIDGET-ID 200
     c-nome-cc AT ROW 13.75 COL 2.43 COLON-ALIGNED WIDGET-ID 8
     bt-go AT ROW 13.75 COL 25.14 WIDGET-ID 10
     bt-xl AT ROW 1.38 COL 144.86 WIDGET-ID 12
     bt-nenhum-cc AT ROW 13.75 COL 34.72 WIDGET-ID 16
     bt-limpar AT ROW 7.25 COL 11.57 WIDGET-ID 26
     bt-go-2 AT ROW 13.75 COL 41 WIDGET-ID 28
     RECT-5 AT ROW 3.13 COL 2
     RECT-6 AT ROW 5.79 COL 2
     RECT-7 AT ROW 1 COL 140 WIDGET-ID 22
     rt-button AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Controle Or‡ament rio"
         HEIGHT             = 25.46
         WIDTH              = 157.57
         MAX-HEIGHT         = 28.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.38
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = 18
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-totais 1 f-cad */
/* BROWSE-TAB br-centro-custos bt_faixa_ct f-cad */
/* BROWSE-TAB br-movimentos cb-ano[6] f-cad */
ASSIGN 
       FRAME f-cad:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-estabelecimento IN FRAME f-cad
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RECTANGLE rt-button IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-centro-custos
/* Query rebuild information for BROWSE br-centro-custos
     _START_FREEFORM
OPEN QUERY br-centro-custos FOR EACH  tt-usuar-disp.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-centro-custos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-movimentos
/* Query rebuild information for BROWSE br-movimentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-consulta-res.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-movimentos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-totais
/* Query rebuild information for BROWSE br-totais
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-totais-display.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-totais */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Controle Or‡ament rio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Controle Or‡ament rio */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  
/*   hproc:DISCONNECT(). */
/*   DELETE OBJECT hproc. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-RESIZED OF w-livre /* Controle Or‡ament rio */
DO:
   do with frame {&frame-name}:
      assign frame f-cad:height     = {&window-name}:height
             frame f-cad:width      = {&window-name}:width
             frame f-cad:scrollable = no no-error.

      assign rt-button   :width   = {&window-name}:width - 1.01.

      if valid-handle(hbrowse1) then
         assign hbrowse1:width  = {&window-name}:width  - 46.0
                hbrowse1:height = {&window-name}:height - 6.9.

      if valid-handle(hbrowsecc) THEN
         assign hbrowsecc:height  = {&window-name}:height - 14.58.

      if valid-handle(hbrowsetot) THEN
         assign hbrowsetot:width  = {&window-name}:width  - 46.0
                hbrowsetot:COL    = hbrowse1:COL
                hbrowsetot:ROW    = hbrowse1:ROW + hbrowse1:HEIGHT + 0.3.
/*                 hbrowsetot:height = {&window-name}:height - 25.5. */

/*       run set-position in h_p-exihel ( 1.17 , frame f-cad:width - 15.86) no-error. */
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-centro-custos
&Scoped-define SELF-NAME br-centro-custos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-centro-custos w-livre
ON MOUSE-SELECT-DBLCLICK OF br-centro-custos IN FRAME f-cad
DO:
  
  IF  tt-usuar-disp.l-selec = NO THEN DO:
      ASSIGN tt-usuar-disp.l-selec = YES.

      FOR EACH tt-usuar-cc 
          WHERE LOOKUP(tt-usuar-cc.cod_estabel,fi-estabelecimento:SCREEN-VALUE) > 0
            AND tt-usuar-cc.cod_ccusto = tt-usuar-disp.cod_ccusto:
          ASSIGN tt-usuar-cc.l-selec = YES.
      END.
  END.      
  ELSE DO:
      ASSIGN tt-usuar-disp.l-selec = NO. 

      FOR EACH tt-usuar-cc 
          WHERE tt-usuar-cc.cod_ccusto = tt-usuar-disp.cod_ccusto:
          ASSIGN tt-usuar-cc.l-selec = NO.
      END.      
  END.
       
  {&OPEN-QUERY-br-centro-custos}

 ASSIGN INPUT FRAME {&FRAME-NAME} cb-mes
        INPUT FRAME {&FRAME-NAME} cb-ano.

 /* RUN pi-cria-consulta.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-centro-custos w-livre
ON VALUE-CHANGED OF br-centro-custos IN FRAME f-cad
DO:
/*   RUN pi-cria-consulta (INPUT tt-usuar-cc.cod_ccusto, tt-usuar-cc.cod_unid_negoc). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-movimentos
&Scoped-define SELF-NAME br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos w-livre
ON MOUSE-SELECT-DBLCLICK OF br-movimentos IN FRAME f-cad
DO:
  RUN esp\es5500a.w (INPUT TABLE tt-dados-consulta,
                     INPUT tt-consulta-res.cod_empresa,
                     input tt-consulta-res.cod_estab,         
                     input tt-consulta-res.cod_cenar_ctbl,    
                     input tt-consulta-res.cod_plano_cta_ctbl,
                     input tt-consulta-res.cod_plano_ccusto,  
                     input tt-consulta-res.cod_cta_ctbl,      
                     input tt-consulta-res.cod_ccusto,        
                     input tt-consulta-res.cod_unid_negoc,    
                     input tt-consulta-res.cod_proj_financ).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos w-livre
ON ROW-DISPLAY OF br-movimentos IN FRAME f-cad
DO:  
    RUN pi-row-display.
    IF br-movimentos:load-mouse-pointer('image\detail.cur') THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-full-screen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-full-screen w-livre
ON CHOOSE OF bt-full-screen IN FRAME f-cad /* Maximizar */
DO:
  
    RUN pi-fullscreen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go w-livre
ON CHOOSE OF bt-go IN FRAME f-cad /* Btn 1 */
DO:

  RUN pi-carrega-cc.

  IF  c-nome-cc:SCREEN-VALUE <> "" 
  THEN DO:

       FOR EACH tt-usuar-disp
           WHERE tt-usuar-disp.cod_ccusto <> trim(c-nome-cc:SCREEN-VALUE):
    
           IF tt-usuar-disp.l-selec = YES 
              THEN NEXT.
    
          DELETE tt-usuar-disp.

       END.
  END.
  
  {&OPEN-QUERY-br-centro-custos}
  APPLY "VALUE-CHANGED" TO br-centro-custos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-go-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go-2 w-livre
ON CHOOSE OF bt-go-2 IN FRAME f-cad /* Btn 1 */
DO:
/*   RUN pi-carrega-cc. */
  RUN pi-carrega-cc. 

  ASSIGN v_rec_centro-custo = ?.

  ASSIGN c_lista_cc = "".

  RUN esp\es5500zg.p.

  IF c_lista_cc <> "" THEN DO:

     FOR EACH tt-usuar-disp:
        
         IF  tt-usuar-disp.l-selec    = YES THEN
             NEXT.
        
         IF  LOOKUP(tt-usuar-disp.cod_ccusto,c_lista_cc,",") = 0 THEN
             DELETE tt-usuar-disp.
     END.             
  END.
  
  
  {&OPEN-QUERY-br-centro-custos}
  APPLY "VALUE-CHANGED" TO br-centro-custos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importa w-livre
ON CHOOSE OF bt-importa IN FRAME f-cad /* Importa Arquivos */
DO:

    IF NOT CAN-FIND(FIRST tt-usuar-disp
                    WHERE tt-usuar-disp.l-selec) 
    THEN DO:
         MESSAGE "Selecionar o(s) centro de custo(s) desejados com um Duplo Click antes de atualizar a consulta!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    EMPTY TEMP-TABLE tt-consulta-res.
    EMPTY TEMP-TABLE tt-dados-consulta.
    EMPTY TEMP-TABLE tt-totais.
    EMPTY TEMP-TABLE tt-totais-display.
    
     ASSIGN INPUT FRAME {&FRAME-NAME} cb-mes
            INPUT FRAME {&FRAME-NAME} cb-ano.

     RUN pi-cria-consulta.
/*      RUN pi-cria-browse.        */
/*      RUN pi-cria-browse-totais. */

    {&OPEN-QUERY-br-movimentos}
    {&OPEN-QUERY-br-totais}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpar w-livre
ON CHOOSE OF bt-limpar IN FRAME f-cad /* Limpar */
DO:

    ASSIGN cb-mes[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
           cb-mes[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum-cc w-livre
ON CHOOSE OF bt-nenhum-cc IN FRAME f-cad /* Nenhum */
DO:
    RUN utp\ut-msgs(INPUT 'show',
                    INPUT "701",
                    INPUT "DESMARCAR todos centros de custos").

    IF  RETURN-VALUE = 'NO' THEN
        RETURN NO-APPLY.

    FOR EACH tt-usuar-cc:
      ASSIGN tt-usuar-cc.l-selec = NO. 
    END.

    FOR EACH tt-usuar-disp:
        ASSIGN tt-usuar-disp.l-selec = NO.
    END.
    {&OPEN-QUERY-br-centro-custos}
    
    ASSIGN INPUT FRAME {&FRAME-NAME} cb-mes
           INPUT FRAME {&FRAME-NAME} cb-ano.

    EMPTY TEMP-TABLE tt-consulta-res.
    EMPTY TEMP-TABLE tt-dados-consulta.
    EMPTY TEMP-TABLE tt-totais.
    EMPTY TEMP-TABLE tt-totais-display.

    EMPTY TEMP-TABLE tt-prog-ponto.

    {&OPEN-QUERY-br-movimentos}
    {&OPEN-QUERY-br-totais}

    RUN pi-cria-browse.
    RUN pi-cria-browse-totais.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

  /*  RUN pi-cria-consulta. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-preenche
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-preenche w-livre
ON CHOOSE OF bt-preenche IN FRAME f-cad /* Preenche */
DO:
  ASSIGN cb-mes[1]
         cb-ano[1].

  IF cb-mes[1] = "" OR cb-ano[1] = "" THEN RETURN NO-APPLY.


  ASSIGN i-ano-x = int(cb-ano[1]).

  DO i-cont = 1 TO 11:

      ASSIGN cb-mes[i-cont + 1] = string(int(cb-mes[i-cont]) + 1).

      IF int(cb-mes[i-cont + 1]) = 13 THEN
          ASSIGN cb-mes[i-cont + 1] = "1"
                 i-ano-x = i-ano-x + 1.

      ASSIGN cb-ano[i-cont + 1] = string(i-ano-x,"9999").
        
  END.
  DISPLAY cb-mes 
          cb-ano
          WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-print w-livre
ON CHOOSE OF bt-print IN FRAME f-cad /* Relat¢rio */
DO:
  RUN esp\es5502.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos-cc w-livre
ON CHOOSE OF bt-todos-cc IN FRAME f-cad /* Todos */
DO:
    RUN utp\ut-msgs(INPUT 'show',
                INPUT "701",
                INPUT "MARCAR todos centros de custos").

    IF  RETURN-VALUE = 'NO' THEN
        RETURN NO-APPLY.

    RUN utp\ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Aguarde...").
    RUN pi-acompanhar IN h-acomp (INPUT "Montando Consulta").

    FOR EACH tt-usuar-cc
        WHERE LOOKUP(tt-usuar-cc.cod_estabel,fi-estabelecimento:SCREEN-VALUE) > 0:
        ASSIGN tt-usuar-cc.l-selec = YES.
    END.
    FOR EACH tt-usuar-disp:
        ASSIGN tt-usuar-disp.l-selec = YES.
    END.

    {&OPEN-QUERY-br-centro-custos}

    EMPTY TEMP-TABLE tt-consulta-res.
    EMPTY TEMP-TABLE tt-dados-consulta.
    EMPTY TEMP-TABLE tt-totais.
    EMPTY TEMP-TABLE tt-totais-display.

    EMPTY TEMP-TABLE tt-prog-ponto.

    {&OPEN-QUERY-br-movimentos}
    {&OPEN-QUERY-br-totais}

    RUN pi-cria-browse.
    RUN pi-cria-browse-totais.

/*         RUN pi-cria-consulta. */
    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-xl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-xl w-livre
ON CHOOSE OF bt-xl IN FRAME f-cad /* XL */
DO:
    DEF VAR i-linxl      AS INT.
    DEF VAR i-colxl      AS INT.
    DEF VAR i-contar     AS INT.
    
    def var chexcel      as com-handle.
    def var chworkbook   as com-handle.
    def var chworksheet  as com-handle.

    DEF VAR hbuffermov   AS HANDLE.
    DEF VAR hbrowsemov   AS HANDLE.
    DEF VAR hquerymov    AS HANDLE.

    DEF VAR v-qu         AS LOG.
    

    DEF VAR hcolumn      AS HANDLE.

    def var v-item  as char no-undo.
    def var v-alpha as char extent 78 no-undo init ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","x","y","Z",
                                                    "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","Ax","Ay","AZ",
                                                    "BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","Bx","By","BZ"].

    {&OPEN-QUERY-br-movimentos}
    ASSIGN hbrowsemov = br-movimentos:HANDLE
           hquerymov  = hBrowsemov:QUERY
           hbuffermov = hquerymov:GET-BUFFER-HANDLE(1).

    assign i-linxl = 1.

    apply 'mouse-select-click' to br-movimentos.

    DEF VAR c-titulo AS CHAR FORMAT "X(2000)" NO-UNDO.
    DEF VAR c-linha  AS CHAR FORMAT "X(2000)" NO-UNDO.
    do i = 1 to hbrowsemov:num-columns:
       ASSIGN hcolumn = hbrowsemov:get-browse-column(i).
       ASSIGN c-titulo = c-titulo + hcolumn:LABEL + ";".

    end.

    ASSIGN i-linxl = 1.
    
    DEF VAR c-arquivo AS CHAR.
    
    ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Or‡amento_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
    OUTPUT STREAM s TO value(c-arquivo) CONVERT TARGET "iso8859-1".
    PUT STREAM s c-titulo SKIP.    

    repeat:
        if i-linxl = 1 then 
           ASSIGN v-qu = hbrowsemov:select-row(1).
        else 
           ASSIGN v-qu = hbrowsemov:select-next-row().

        if v-qu = no then 
           leave.

        ASSIGN i-linxl = i-linxl + 1.

        c-linha = "".
        do i = 1 to hbrowsemov:num-columns:
           ASSIGN hcolumn = hbrowsemov:get-browse-column(i).
                  v-item = v-alpha[i] + string(i-linxl).
           /*ASSIGN chWorkSheet:cells(i-linxl,i):value = hcolumn:screen-value.       */

           ASSIGN c-linha = c-linha + hcolumn:SCREEN-VALUE + ";".
        end.

        PUT STREAM s c-linha SKIP.
    end.

    OUTPUT STREAM s CLOSE.
    DOS SILENT START excel VALUE(c-arquivo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-zoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-zoom w-livre
ON CHOOSE OF bt-zoom IN FRAME f-cad /* Button 1 */
DO:
  ASSIGN c-nome-cc:SCREEN-VALUE = "".
  RUN esp\es5500zf.p.
  ASSIGN fi-estabelecimento:SCREEN-VALUE = c_lista_estabel.
  RUN pi-carrega-cc.  
  /*APPLY 'CHOOSE' TO bt-importa.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_faixa_ct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_faixa_ct w-livre
ON CHOOSE OF bt_faixa_ct IN FRAME f-cad /* Sele‡Æo */
DO:
  RUN esp\es5500b.w (INPUT-OUTPUT TABLE tt-param).
  
  ASSIGN INPUT FRAME {&FRAME-NAME} cb-mes
         INPUT FRAME {&FRAME-NAME} cb-ano.

  /* RUN pi-cria-consulta. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_seg w-livre
ON CHOOSE OF bt_seg IN FRAME f-cad /* Det */
DO:
    RUN esp/es0512.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-cc w-livre
ON ANY-PRINTABLE OF c-nome-cc IN FRAME f-cad /* CC */
DO:
   DEFINE VARIABLE bcentrocc AS HANDLE     NO-UNDO.
   ASSIGN bcentrocc = BUFFER tt-usuar-disp:HANDLE.
   RUN autoComplete (bcentrocc,"cod_ccusto").
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[10] w-livre
ON VALUE-CHANGED OF cb-ano[10] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[10] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[10] <> "" THEN 
        RUN pi-tree.
    */    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[11] w-livre
ON VALUE-CHANGED OF cb-ano[11] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[11] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[11] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[12] w-livre
ON VALUE-CHANGED OF cb-ano[12] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[12] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[12] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[1] w-livre
ON VALUE-CHANGED OF cb-ano[1] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[1] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[1] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[2] w-livre
ON VALUE-CHANGED OF cb-ano[2] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[2] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[2] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[3] w-livre
ON VALUE-CHANGED OF cb-ano[3] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[3] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[4] w-livre
ON VALUE-CHANGED OF cb-ano[4] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[4] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[4] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[5] w-livre
ON VALUE-CHANGED OF cb-ano[5] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[5] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[5] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[6] w-livre
ON VALUE-CHANGED OF cb-ano[6] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[6] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[6] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[7] w-livre
ON VALUE-CHANGED OF cb-ano[7] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[7] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[7] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[8] w-livre
ON VALUE-CHANGED OF cb-ano[8] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[8] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[8] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[9] w-livre
ON VALUE-CHANGED OF cb-ano[9] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[9] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[9] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[10] w-livre
ON VALUE-CHANGED OF cb-mes[10] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[10] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[10] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[11] w-livre
ON VALUE-CHANGED OF cb-mes[11] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[11] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[11] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[12] w-livre
ON VALUE-CHANGED OF cb-mes[12] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[12] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[12] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[1] w-livre
ON VALUE-CHANGED OF cb-mes[1] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[1] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[1] <> "" THEN 
        RUN pi-tree.
        */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[2] w-livre
ON VALUE-CHANGED OF cb-mes[2] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[2] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[2] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[3] w-livre
ON VALUE-CHANGED OF cb-mes[3] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[4] w-livre
ON VALUE-CHANGED OF cb-mes[4] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[4] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[4] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[5] w-livre
ON VALUE-CHANGED OF cb-mes[5] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[5] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[5] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[6] w-livre
ON VALUE-CHANGED OF cb-mes[6] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[6] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[6] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[7] w-livre
ON VALUE-CHANGED OF cb-mes[7] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[7] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[7] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[8] w-livre
ON VALUE-CHANGED OF cb-mes[8] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[8] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[8] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[9] w-livre
ON VALUE-CHANGED OF cb-mes[9] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[9] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[9] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-centro-custos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


procedure LockWindowUpdate external {&user} :
   def input  parameter hWndLock as long.
end procedure.

procedure GetWindowLongA external "user32.dll":
   def input  parameter hwnd   as long.
   def input  parameter nIndex as long.
   def return parameter returnValue as long.
end procedure.

procedure SetWindowLongA external "user32.dll":
   def input  parameter hwnd        as long.
   def input  parameter nIndex      as long.
   def input  parameter dwNewlong   as long.
   def return parameter returnValue as long.
end procedure.

procedure Bit_Remove external "PROEXTRA.DLL" :
   def input-output parameter Flags   as long.
   def input        parameter OldFlag as long.
end procedure.

procedure GetMenu external "user32.dll":
   def input  parameter iHwnd as long.
   def return parameter hMenu as long.
end procedure.

procedure SetMenu external "user32.dll":
   def input parameter iHwnd as long.
   def input parameter hMenu as long.
end procedure.

IF c-seg-usuario <> "" THEN
    ASSIGN c-usuario = c-seg-usuario.

IF v_cod_usuar_corren <> "" THEN
    ASSIGN c-usuario = v_cod_usuar_corren.

/* Include custom  Main Block code for SmartWindows. */

RUN btb/btb901zo.p PERSISTENT SET hbtb.

ASSIGN p-wgh-frame = FRAME f-cad:HANDLE.

RUN pi_altera_componentes IN hbtb (p-wgh-frame).
RUN pi_alterar_window IN hbtb (w-livre:HANDLE).

ASSIGN h_Frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
ASSIGN h_Frame = h_Frame:FIRST-CHILD.       /* pegando o 1o. Campo */

DO WHILE h_Frame <> ? :
   if h_frame:type <> "field-group" then do:  
      RUN pi_altera_componentes IN hbtb (h_frame).

      ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
   end. 
   else do:
      assign h_frame = h_frame:first-child.
   end.    
END.

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autocomplete w-livre 
PROCEDURE autocomplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER tableHandle AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER fieldName   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE searchQuery  AS HANDLE     NO-UNDO. 
    DEFINE VARIABLE searchBuffer AS HANDLE     NO-UNDO.
    DEFINE VARIABLE searchField  AS HANDLE     NO-UNDO.
 
    DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
 
    IF tableHandle:TYPE = "TEMP-TABLE" THEN tableHandle = tableHandle:DEFAULT-BUFFER-HANDLE.
    CREATE BUFFER searchBuffer FOR TABLE tableHandle.
 
    searchField = searchBuffer:BUFFER-FIELD(fieldName).
    CREATE QUERY searchQuery.
 
    cValue = SELF:SELECTION-TEXT + LAST-EVENT:LABEL.
 
    searchQuery:SET-BUFFERS(searchBuffer).
    searchQuery:QUERY-PREPARE("FOR EACH " + tableHandle:NAME + " WHERE " +
                               tableHandle:NAME + "." + fieldName + " BEGINS '" + cValue + "'").
    searchQuery:QUERY-OPEN.
    searchQuery:GET-FIRST(NO-LOCK).
 
    IF searchBuffer:AVAILABLE AND
         LENGTH(STRING(searchField:BUFFER-VALUE)) >= LENGTH(cValue) THEN DO:
        searchField = searchBuffer:BUFFER-FIELD(fieldName).
        SELF:SCREEN-VALUE = searchField:STRING-VALUE.
    END.
    ELSE DO:
        SELF:SCREEN-VALUE = "".
        DO iCount = 1 TO LENGTH(cValue):
            APPLY SUBSTRING(cValue,iCount,1) TO SELF.
        END.
    END.
    SELF:SET-SELECTION(1,LENGTH(cValue) + 1).
 
/*     searchQuery:QUERY-CLOSE.    */
/*     DELETE OBJECT searchQuery.  */
/*     DELETE OBJECT searchBuffer. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY l-dest-est fi-estabelecimento l-ccusto-ativo l-ccusto-inativo l-orcado 
          l-realizado l-variacao cb-mes[1] cb-ano[1] cb-mes[7] cb-ano[7] 
          cb-mes[8] cb-ano[8] cb-mes[9] cb-ano[9] cb-mes[2] cb-ano[2] cb-mes[10] 
          cb-ano[10] cb-mes[3] cb-ano[3] cb-mes[11] cb-ano[11] cb-mes[4] 
          cb-ano[4] cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] cb-mes[6] 
          cb-ano[6] c-nome-cc 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE br-totais bt-full-screen bt-print bt-todos-cc l-dest-est bt-zoom 
         bt_seg bt_faixa_ct br-centro-custos l-ccusto-ativo l-ccusto-inativo 
         l-orcado l-realizado l-variacao cb-mes[1] cb-ano[1] cb-mes[7] 
         cb-ano[7] cb-mes[8] cb-ano[8] bt-preenche cb-mes[9] cb-ano[9] 
         cb-mes[2] cb-ano[2] cb-mes[10] cb-ano[10] cb-mes[3] cb-ano[3] 
         cb-mes[11] cb-ano[11] cb-mes[4] cb-ano[4] cb-mes[12] cb-ano[12] 
         cb-mes[5] cb-ano[5] bt-importa cb-mes[6] cb-ano[6] br-movimentos 
         c-nome-cc bt-go bt-xl bt-nenhum-cc bt-limpar bt-go-2 RECT-5 RECT-6 
         RECT-7 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  
 /* 
  {include/i-logfin.i}
   */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  
  ASSIGN cb-mes[1] = "1".  

  RUN dispatch IN THIS-PROCEDURE (INPUT 'initialize':U ) .

  ASSIGN hbrowsecc = br-centro-custos:HANDLE IN FRAME f-cad.


  RUN pi-cria-browse.
  RUN pi-cria-browse-totais.

  ASSIGN hbrowse1:NUM-LOCKED-COLUMNS = 5.
  ASSIGN hbrowsetot:NUM-LOCKED-COLUMNS = 1.

  CREATE tt-param.
  ASSIGN tt-param.c-cod-unid-orcta  = "Desp1"
         tt-param.num-seq-orcto-ctb = 1
         tt-param.cod-versao-orcto  = "3.00"
         tt-param.c-cod-ini         = "00000000"
         tt-param.c-cod-fim         = "99999999".

  RUN pi-carrega-cc.  
/*   APPLY 'CHOOSE' TO bt-importa. */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cc w-livre 
PROCEDURE pi-carrega-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-usuar-disp.
    EMPTY TEMP-TABLE tt-usuar-cc.
    EMPTY TEMP-TABLE tt-consulta-res.
    EMPTY TEMP-TABLE tt-dados-consulta.
    EMPTY TEMP-TABLE tt-totais.
    
    RUN utp\ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Aguarde...").
    RUN pi-acompanhar IN h-acomp (INPUT "Montando Consulta").
    
    DO  i-cont = 1 TO NUM-ENTRIES(fi-estabelecimento:SCREEN-VALUE IN FRAME f-cad,","):
    
        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE usu-cc-un-orc.cod-usuario = c-usuario
            AND   usu-cc-un-orc.cod-estab   = ENTRY(i-cont,fi-estabelecimento:SCREEN-VALUE IN FRAME f-cad,","):
        
            IF usu-cc-un-orc.cod-ccusto  = "*" THEN
               NEXT.
    
            IF usu-cc-un-orc.cod-unid-negoc  = "*" THEN
               NEXT.
    
            IF not can-find(first tt-usuar-cc
                            where tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                             AND  tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                             AND  tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg) then do:
        
                FIND emscad.ccusto
                    WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                    AND   ccusto.cod_plano_cc = "Padrao"
                    AND   ccusto.cod_ccusto   = usu-cc-un-orc.cod-ccusto
                    NO-LOCK NO-ERROR.
        
                IF  NOT AVAIL emscad.ccusto THEN
                    NEXT.
        
                IF  emscad.ccusto.dat_inic_valid < TODAY
                AND emscad.ccusto.dat_fim_valid  > TODAY THEN DO:
                    IF  l-ccusto-ativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
                ELSE DO:
                    IF  l-ccusto-inativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
    
                    
                CREATE tt-usuar-cc.
                ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                       tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                       tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg
                       tt-usuar-cc.des_ccusto     = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "".         
    
                FIND tt-usuar-disp
                    WHERE tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                    NO-LOCK NO-ERROR.
    
                IF  NOT AVAIL tt-usuar-disp THEN DO:
                    CREATE tt-usuar-disp.
                    ASSIGN tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                           tt-usuar-disp.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "". 
                END.
            END.
        END.
        
        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE  usu-cc-un-orc.cod-usuario = "*":
    
            IF  not can-find(first tt-usuar-cc
                            where tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                             AND  tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                             AND  tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg) then do:
            
                FIND emscad.ccusto
                    WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                    AND   ccusto.cod_plano_cc = "Padrao"
                    AND   ccusto.cod_ccusto   = usu-cc-un-orc.cod-ccusto
                    NO-LOCK NO-ERROR.
                
                IF  NOT AVAIL emscad.ccusto THEN
                    NEXT.
                
                IF  emscad.ccusto.dat_inic_valid < TODAY
                AND emscad.ccusto.dat_fim_valid  > TODAY THEN DO:
                    IF  l-ccusto-ativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
                ELSE DO:
                    IF  l-ccusto-inativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
                
                    
                CREATE tt-usuar-cc.
                ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                       tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                       tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg
                       tt-usuar-cc.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "".              
    
                FIND tt-usuar-disp
                    WHERE tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                    NO-LOCK NO-ERROR.
    
                IF  NOT AVAIL tt-usuar-disp THEN DO:
                    CREATE tt-usuar-disp.
                    ASSIGN tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                           tt-usuar-disp.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "". 
                END.
            END.
        END.
    
        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE  usu-cc-un-orc.cod-ccusto  = "*"
            AND    usu-cc-un-orc.cod-usuario = c-usuario:
    
            FOR EACH emscad.ccusto
                WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                AND   ccusto.cod_plano_cc = "Padrao"
                NO-LOCK:
    
                IF  emscad.ccusto.dat_inic_valid < TODAY
                AND emscad.ccusto.dat_fim_valid  > TODAY THEN DO:
                    IF  l-ccusto-ativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
                ELSE DO:
                    IF  l-ccusto-inativo:CHECKED IN FRAME f-cad = NO THEN
                        NEXT.
                END.
    
                IF  not can-find(first tt-usuar-cc
                            where tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                             AND  tt-usuar-cc.cod_ccusto     = emscad.ccusto.cod_ccusto
                             AND  tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg) then do:
            
                
                    CREATE tt-usuar-cc.
                    ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                           tt-usuar-cc.cod_ccusto     = emscad.ccusto.cod_ccusto
                           tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg
                           tt-usuar-cc.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "".            
    
                    FIND tt-usuar-disp
                        WHERE tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                        NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt-usuar-disp THEN DO:
                        CREATE tt-usuar-disp.
                        ASSIGN tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                               tt-usuar-disp.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "". 
                    END.
                END.
            END.
        END.
    
        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE  usu-cc-un-orc.cod-unid-negoc  = "*"
            AND    usu-cc-un-orc.cod-usuario     = c-usuario:
    
            FOR EACH unid_negoc NO-LOCK:
    
                IF  not can-find(first tt-usuar-cc
                            where tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                             AND  tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                             AND  tt-usuar-cc.cod_unid_negoc = unid_negoc.cod_unid_negoc) then do:
                                                                                        
                    FIND emscad.ccusto
                        WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                        AND   ccusto.cod_plano_cc = "Padrao"
                        AND   ccusto.cod_ccusto   = usu-cc-un-orc.cod-ccusto
                        NO-LOCK NO-ERROR.
                    
                    IF  NOT AVAIL emscad.ccusto THEN
                        NEXT.
                    
                    IF  emscad.ccusto.dat_inic_valid < TODAY
                    AND emscad.ccusto.dat_fim_valid  > TODAY THEN DO:
                        IF  l-ccusto-ativo:CHECKED IN FRAME f-cad = NO THEN
                            NEXT.
                    END.
                    ELSE DO:
                        IF  l-ccusto-inativo:CHECKED IN FRAME f-cad = NO THEN
                            NEXT.
                    END.

                    CREATE tt-usuar-cc.
                    ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                           tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                           tt-usuar-cc.cod_unid_negoc = unid_negoc.cod_unid_negoc
                           tt-usuar-cc.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "".              
    
                    FIND tt-usuar-disp
                        WHERE tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                        NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt-usuar-disp THEN DO:
                        CREATE tt-usuar-disp.
                        ASSIGN tt-usuar-disp.cod_ccusto = tt-usuar-cc.cod_ccusto
                               tt-usuar-disp.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "". 
                    END.
                END.
            END.
        END.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    
    {&OPEN-QUERY-br-centro-custos}
    {&OPEN-QUERY-br-movimentos}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-browse w-livre 
PROCEDURE pi-cria-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN hbrowse1 = br-movimentos:HANDLE IN FRAME f-cad.

    ASSIGN hQuery1 = br-movimentos:HANDLE.
    ASSIGN hBuffer = BUFFER tt-consulta-res:HANDLE.
    
/*     ASSIGN hColumn = BROWSE br-movimentos:GET-BROWSE-COLUMN(9). */
/*                                                                 */
/*     ASSIGN hColumn:WIDTH = 4.                                   */


    IF  i-coluna > 0 THEN DO:
        DO  i-cont = 1 TO i-coluna:
            IF  VALID-HANDLE(vColumnHandles[i-cont]) THEN DO:
                DELETE OBJECT vColumnHandles[i-cont].                
            END.
        END.
    END.

    ASSIGN i-coluna = 0.

    DO i-periodo = 1 TO 12:

        IF  cb-mes[i-periodo] = "" 
        OR  cb-mes[i-periodo] = "0" THEN
            NEXT.

        IF  cb-ano[i-periodo] = "" THEN
            NEXT.

        CASE I-PERIODO:
            WHEN 1 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-1", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-1", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-1", INPUT "% ").          
            END.                
            WHEN 2 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-2", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-2", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-2", INPUT "% ").


            END.                
            WHEN 3 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN                
                    RUN pi-cria-coluna (INPUT "valor_rea-3", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-3", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-3", INPUT "% ").
            END.                
            WHEN 4 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-4", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-4", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-4", INPUT "% ").

            END.
            WHEN 5 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-5", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).            

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-5", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-5", INPUT "% ").
            END.
            WHEN 6 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-6", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-6", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-6", INPUT "% ").
            END.                
            WHEN 7 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-7", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-7", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-7", INPUT "% ").
            END.                
            WHEN 8 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-8", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-8", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-8", INPUT "% ").

            END.                
            WHEN 9 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-9", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-9", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-9", INPUT "% ").

            END.
            WHEN 10 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-10", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-10", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-10", INPUT "% ").
            END.                
            WHEN 11 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-11", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-11", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-11", INPUT "% ").
            END.
            WHEN 12 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "valor_rea-12", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna (INPUT "valor_orc-12", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna (INPUT "de-var-12", INPUT "% ").

            END.                                                                                                                           
        END CASE.                                           
    END.
    ASSIGN vhCurColHdl  = hbrowse1:FIRST-COLUMN
           vcColHandles = "".
    
    DO WHILE VALID-HANDLE(vhCurColHdl):
       ASSIGN vcColHandles = IF vcColHandles <> "":U THEN
                                vcColHandles + ",":U + STRING(vhCurColHdl)
                            ELSE
                                STRING(vhCurColHdl)
              vhCurColHdl  = vhCurColHdl:NEXT-COLUMN.
    END.

    IF br-movimentos:load-mouse-pointer('image\detail.cur') THEN.

    {&OPEN-QUERY-br-movimentos}

    
/*     hQuery1:query-prepare("for each tt-consulta-res no-lock"). */
/*     hQuery1:QUERY-OPEN.                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-browse-totais w-livre 
PROCEDURE pi-cria-browse-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN hbrowsetot = br-totais:HANDLE IN FRAME f-cad.

    ASSIGN hQuerytot  = br-totais:HANDLE.
    ASSIGN hBuffertot = BUFFER tt-totais-display:HANDLE.

    IF  i-coluna > 0 THEN DO:
        DO  i-cont = 1 TO i-coluna:
            IF  VALID-HANDLE(vColumnhtot[i-cont]) THEN DO:
                DELETE OBJECT vColumnhtot[i-cont].                
            END.
        END.
    END.

    ASSIGN i-coluna = 0.

    DO i-periodo = 1 TO 12:

        IF  cb-mes[i-periodo] = "" 
        OR  cb-mes[i-periodo] = "0" THEN
            NEXT.

        IF  cb-ano[i-periodo] = "" THEN
            NEXT.

        CASE I-PERIODO:
            WHEN 1 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-1", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-1", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-1", INPUT "% ").          
            END.                
            WHEN 2 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-2", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-2", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-2", INPUT "% ").


            END.                
            WHEN 3 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN                
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-3", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-3", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-3", INPUT "% ").
            END.                
            WHEN 4 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-4", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-4", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-4", INPUT "% ").

            END.
            WHEN 5 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-5", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).            

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-5", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-5", INPUT "% ").
            END.
            WHEN 6 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-6", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-6", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-6", INPUT "% ").
            END.                
            WHEN 7 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-7", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-7", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-7", INPUT "% ").
            END.                
            WHEN 8 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-8", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-8", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-8", INPUT "% ").

            END.                
            WHEN 9 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-9", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-9", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-9", INPUT "% ").

            END.
            WHEN 10 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-10", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-10", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-10", INPUT "% ").
            END.                
            WHEN 11 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-11", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-11", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-11", INPUT "% ").
            END.
            WHEN 12 THEN DO:
                IF  l-realizado:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "valor_rea-12", INPUT "(R) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-orcado:CHECKED IN FRAME f-cad THEN 
                    RUN pi-cria-coluna-tot (INPUT "valor_orc-12", INPUT "(O) " + SUBSTR({varinc\var00035.i 04 int(cb-mes[i-periodo])},1,3) + "/" + CB-ANO[I-PERIODO]).

                IF  l-variacao:CHECKED IN FRAME f-cad THEN
                    RUN pi-cria-coluna-tot (INPUT "de-var-12", INPUT "% ").

            END.                                                                                                                           
        END CASE.                                           
    END.
    ASSIGN vhCurColtot  = hbrowsetot:FIRST-COLUMN
           vcColHtotais = "".
    
    DO WHILE VALID-HANDLE(vhCurColtot):
       ASSIGN vcColHtotais = IF vcColHtotais <> "":U THEN
                                vcColHtotais + ",":U + STRING(vhCurColtot)
                            ELSE
                                STRING(vhCurColtot)
              vhCurColtot  = vhCurColtot:NEXT-COLUMN.
    END.

    {&OPEN-QUERY-br-totais}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-coluna w-livre 
PROCEDURE pi-cria-coluna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-nome-campo AS CHAR.
    DEF INPUT PARAM c-label      AS CHAR.

    assign hBf = hBuffer:buffer-field(c-nome-campo).
    
    if NOT valid-handle(hBf) then
       next.
    
    hColumn = hBrowse1:add-like-column(hBf).         
    hcolumn:LABEL = c-label.
    hBrowse1:row-height = 0.5.        

    ASSIGN i-coluna = i-coluna + 1
           vColumnHandles[i-coluna] =  hColumn.    

    IF c-nome-campo BEGINS "valor_" THEN
       ASSIGN hcolumn:WIDTH = 14.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-coluna-tot w-livre 
PROCEDURE pi-cria-coluna-tot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-nome-campo AS CHAR.
    DEF INPUT PARAM c-label      AS CHAR.
                    
    assign hBf = hBuffertot:buffer-field(c-nome-campo).
    
    if NOT valid-handle(hBf) then
       next.
    
    hColumn = hbrowsetot:add-like-column(hBf).         
    hcolumn:LABEL = c-label.
    hbrowsetot:row-height = 0.5.        

    ASSIGN i-coluna = i-coluna + 1
           vColumnhtot[i-coluna] =  hColumn.    

    IF c-nome-campo BEGINS "valor_" THEN
       ASSIGN hcolumn:WIDTH = 14.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-consulta w-livre 
PROCEDURE pi-cria-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN utp\ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Aguarde...").
    RUN pi-acompanhar IN h-acomp (INPUT "Montando Consulta").

    EMPTY TEMP-TABLE tt-consulta-res.
    EMPTY TEMP-TABLE tt-dados-consulta.
    EMPTY TEMP-TABLE tt-totais.
    EMPTY TEMP-TABLE tt-totais-display.
    EMPTY TEMP-TABLE tt-prog-ponto.

/*     RUN esp/es0018p.p (INPUT "ambiente":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto). */
/*                                                                                                       */
/*     FIND FIRST tt-prog-ponto NO-ERROR.                                                                */
/*     IF  AVAILABLE tt-prog-ponto               AND                                                     */
/*         tt-prog-ponto.conteudo = "PRODUCAO":U THEN DO:                                                */
/*         FIND FIRST servid_rpc NO-LOCK                                                                 */
/*             WHERE  servid_rpc.des_servid_rpc MATCHES "*produ*"                                        */
/*             AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.                                  */
/*         IF  AVAIL  servid_rpc THEN                                                                    */
/*             ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).                                         */
/*     END.                                                                                              */
/*     ELSE DO:                                                                                          */
/*         FIND FIRST servid_rpc NO-LOCK                                                                 */
/*             WHERE  servid_rpc.des_servid_rpc MATCHES "*teste*"                                        */
/*             AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.                                  */
/*         IF  AVAIL  servid_rpc THEN                                                                    */
/*             ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).                                         */
/*     END.                                                                                              */
/*                                                                                                       */
/*     IF  c-connect = "" THEN DO:                                                                       */
/*         MESSAGE "N’o existe servidor RPC cadastrado. Processo interrompido."                          */
/*             VIEW-AS ALERT-BOX ERROR TITLE "Erro RPC".                                                 */
/*         RETURN "NOK":U.                                                                               */
/*     END.                                                                                              */
/*                                                                                                       */
/*     /* Faz a conex’o com o servidor RPC */                                                            */
/*     CREATE SERVER h-serv.                                                                             */
/*     h-serv:CONNECT(c-connect).                                                                        */
/*                                                                                                       */
/*     IF  NOT h-serv:CONNECTED() THEN DO:                                                               */
/*         MESSAGE "Servidor RPC n’o estÿ conectado. Processo interrompido."                             */
/*             VIEW-AS ALERT-BOX ERROR TITLE "Erro RPC".                                                 */
/*                                                                                                       */
/*         RETURN "NOK":U.                                                                               */
/*     END.                                                                                              */
/*                                                                                                       */
/*     RUN esp/es5500c.p ON SERVER h-serv (INPUT fi-estabelecimento:SCREEN-VALUE IN FRAME f-cad,         */
/*                                         INPUT cb-mes,                                                 */
/*                                         INPUT cb-ano,                                                 */
/*                                         INPUT TABLE tt-param,                                         */
/*                                         INPUT TABLE tt-usuar-cc,                                      */
/*                                         OUTPUT TABLE tt-consulta-res,                                 */
/*                                         OUTPUT TABLE tt-dados-consulta,                               */
/*                                         OUTPUT TABLE tt-totais).                                      */
/*                                                                                                       */
/*     h-serv:DISCONNECT().                                                                              */

    RUN esp/es5500c.p (INPUT fi-estabelecimento:SCREEN-VALUE IN FRAME f-cad,
                       INPUT cb-mes,
                       INPUT cb-ano,
                       INPUT TABLE tt-param,
                       INPUT TABLE tt-usuar-cc,
                       OUTPUT TABLE tt-consulta-res,
                       OUTPUT TABLE tt-dados-consulta,
                       OUTPUT TABLE tt-totais).

    FOR EACH tt-consulta-res
        BREAK BY  tt-consulta-res.cod_estab:
    
        FIND FIRST tt-totais
            WHERE tt-totais.cod-estabel = tt-consulta-res.cod_estab
            NO-ERROR.
    
        IF  NOT AVAIL tt-totais THEN DO:
            CREATE tt-totais.
            ASSIGN tt-totais.cod-estabel = tt-consulta-res.cod_estab .
        END.
    
        FIND FIRST b-tt-totais
            WHERE b-tt-totais.cod-estabel = "TOTAL"
            NO-ERROR.
    
        IF  NOT AVAIL b-tt-totais THEN DO:
            CREATE b-tt-totais.
            ASSIGN b-tt-totais.cod-estabel = "TOTAL".
        END.
        
        {esp\es5500.i2}
    END.
    
    FOR EACH tt-totais BREAK BY tt-totais.cod-estab:
        CREATE tt-totais-display.
        BUFFER-COPY tt-totais TO tt-totais-display.
    END.
    
    RUN pi-finalizar IN h-acomp.
    
    RUN pi-cria-browse.
    RUN pi-cria-browse-totais.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe w-livre 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


RUN esp\es5500a.w (INPUT TABLE tt-dados-consulta,
                   INPUT r-consulta).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fullscreen w-livre 
PROCEDURE pi-fullscreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var hWinParent as int no-undo.
   def var iCurStyle  as int no-undo.
   def var iOldStyle  as int no-undo.

   assign hWinParent = GetParent({&window-name}:hwnd).

   run LockWindowUpdate (input {&window-name}:hwnd).

   if iStyle = ? then do:
      run GetMenu (input  hWinParent,
                   output iOldMenu).
      run SetMenu (hWinParent,0).
      run GetWindowLongA (input  hWinParent,
                          input  -16,
                          output iCurStyle).
      run Bit_Remove     (input-output iCurStyle,
                          input        12582912).
      run Bit_Remove     (input-output iCurStyle,
                          input        262144).
      run SetWindowLongA (input  hWinParent,
                          input  -16,
                          input  iCurStyle,
                          output iOldStyle).
      assign dColWin               = {&window-name}:col
             dRowWin               = {&window-name}:row
             dHeiWin               = {&window-name}:height
             dWidWin               = {&window-name}:width
             {&window-name}:width  = session:width  - 4
             {&window-name}:height = session:height - 1
             {&window-name}:col    = 1
             {&window-name}:row    = 1
             iStyle                = iOldStyle.
   end.
   else do:
      run SetMenu (hWinParent,iOldMenu).
      run SetWindowLongA (hWinParent, -16, istyle, output iOldStyle).
      assign {&window-name}:col    = dColWin
             {&window-name}:row    = dRowWin
             {&window-name}:height = dHeiWin
             {&window-name}:width  = dWidWin
             iStyle                = ?.
   end.

   apply "window-resized" to {&window-name}.

   run LockWindowUpdate (input 0).
   return "ok".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-row-display w-livre 
PROCEDURE pi-row-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-colunas AS INT NO-UNDO.


    IF  l-dest-est:CHECKED IN FRAME f-cad THEN DO:
        DO  i-colunas = 1 TO NUM-ENTRIES(vcColHandles):

            ASSIGN hcolumn = WIDGET-HANDLE(ENTRY(i-colunas,vcColHandles)) NO-ERROR.
    
            IF  VALID-HANDLE(hcolumn) = NO THEN
                NEXT.
    
            IF  cb-mes[1] <> "" THEN
                IF  tt-consulta-res.de-var-1 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[2] <> "" THEN
                IF  tt-consulta-res.de-var-2 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[3] <> "" THEN
                IF  tt-consulta-res.de-var-3 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[4] <> "" THEN
                IF  tt-consulta-res.de-var-4 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[5] <> "" THEN
                IF  tt-consulta-res.de-var-5 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[6] <> "" THEN
                IF  tt-consulta-res.de-var-6 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[7] <> "" THEN
                IF  tt-consulta-res.de-var-7 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[8] <> "" THEN
                IF  tt-consulta-res.de-var-8 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[9] <> "" THEN
                IF  tt-consulta-res.de-var-9 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[10] <> "" THEN
                IF  tt-consulta-res.de-var-10 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[11] <> "" THEN
                IF  tt-consulta-res.de-var-11 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
    
            IF  cb-mes[12] <> "" THEN
                IF  tt-consulta-res.de-var-12 > 100 THEN
                    ASSIGN hColumn:BGCOLOR = 12.
        END.        
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
