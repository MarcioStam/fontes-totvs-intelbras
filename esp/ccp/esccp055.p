USING Progress.Json.ObjectModel.*.
/***********************************************************************************************************************************
**
**  Programa..............: esccp055
**  Nome Externo..........: esp/ccp/esccp055.p
**  Descricao.............: Cockpit de Integra‡Æo dos Pedidos de Compra Espec¡fico
**  Criado por............: Henke - iDBA
**  Criado em.............: 03/11/2022
**
*************************************************************************************************************************************/

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

{method/dbotterr.i}
{esp/esapi505b.i} 

DEF BUFFER b-int-ped-compr FOR int-ped-compr.
DEF BUFFER bf-las-api-log FOR es-api-log.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE l-implanta                       AS LOG NO-UNDO.

function fcFormatJson returns longchar ( lcJson as longchar ) forwards.

def temp-table tt_maximizacao no-undo
    field hdl-widget             as widget-handle
    field tipo-widget            as character 
    field row-original           as decimal
    field col-original           as decimal
    field width-original         as decimal
    field height-original        as decimal
    field log-posiciona-row      as logical
    field log-posiciona-col      as logical
    field log-calcula-width      as logical
    field log-calcula-height     as logical
    field log-button-right       as logical
    field frame-width-original   as decimal
    field frame-height-original  as decimal
    field window-width-original  as decimal
    field window-height-original as decimal.

DEF VAR wh_w_program         as WIDGET-HANDLE NO-UNDO.
DEF VAR v_wgh_focus          as WIDGET-HANDLE NO-UNDO.
def var v_wgh_current_browse as WIDGET-HANDLE NO-UNDO.
DEF VAR l-conf               AS LOGICAL       FORMAT 'Sim/NÆo' NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_program             AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_empresa             AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_estabelecimento     AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v-rec-int-ped-compr       AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-pedido-compr           AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_usuar_mestre        AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar        LIKE emsuni.empresa.cod_empresa NO-UNDO.
def new global shared var v_cod_estab_usuar         AS CHAR format "x(3)" no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren        AS CHAR NO-UNDO.

def var v_cod_portador            as char no-undo.

DEF VAR v-rw-es-api-log-cock      AS ROWID NO-UNDO.

DEF VAR v_cod_estab_ini           LIKE tit_ap.cod_estab            NO-UNDO.
DEF VAR v_cod_estab_fim           LIKE tit_ap.cod_estab INIT "ZZZ" NO-UNDO.
DEF VAR v-num-pedido-ini          LIKE int-ped-compr.num-pedido FORMAT ">>>>,>>9" NO-UNDO.
DEF VAR v-num-pedido-fim          LIKE int-ped-compr.num-pedido FORMAT ">>>>,>>9" NO-UNDO.
DEF VAR v_cdn_fornec_ini          LIKE tit_ap.cdn_fornec FORMAT ">>>>>>>>9" NO-UNDO.
DEF VAR v_cdn_fornec_fim          LIKE tit_ap.cdn_fornec FORMAT ">>>>>>>>9" INIT 999999999 NO-UNDO.
DEF VAR v-dat-criac-ini           LIKE pedido-compr.dat-criac init today NO-UNDO.
DEF VAR v-dat-criac-fim           LIKE pedido-compr.dat-criac INIT TODAY NO-UNDO.
DEF VAR v-dat-integr-ini          LIKE pedido-compr.dat-criac init today NO-UNDO.
DEF VAR v-dat-integr-fim          LIKE pedido-compr.dat-criac INIT TODAY NO-UNDO.
DEF VAR v-cod-compr-ini           LIKE pedido-compr.responsavel NO-UNDO.
DEF VAR v-cod-compr-fim           LIKE pedido-compr.responsavel NO-UNDO.
DEF VAR v-num-ped-compr           LIKE pedido-compr.num-pedido NO-UNDO.

DEF VAR v-log-naointegr           AS LOG LABEL "NÆo Integrado"    INIT YES NO-UNDO.
DEF VAR v-log-integr              AS LOG LABEL "Integrado"        INIT YES NO-UNDO.
DEF VAR v-log-process             AS LOG LABEL "Em Processamento" INIT YES NO-UNDO.
DEF VAR v-log-excluido            AS LOG LABEL "Exclu¡do"         INIT NO NO-UNDO.
DEF VAR v-log-revisao             AS LOG LABEL "Em RevisÆo"       INIT YES NO-UNDO.
DEF VAR v-log-erro                AS LOG LABEL "Erro Integra‡Æo"  INIT YES NO-UNDO.
DEF VAR v-log-cancel              AS LOG LABEL "Pedido Cancelado" INIT YES NO-UNDO.

DEF VAR v-log-reenvio             AS LOG LABEL "Reenvio"          INIT NO NO-UNDO.

DEF VAR rs_transac                AS CHAR INITIAL "Todas"
                                  view-as radio-set Horizontal
                                  radio-buttons "Todas", "Todas", "Autoriza‡Æo", "Autoriza‡Æo", "Captura", "Captura", 
                                                "Cancelamento", "Cancelamento", "Estorno", "Estorno" bgcolor 8 NO-UNDO.

DEF VAR v_cod_opcao               AS CHAR NO-UNDO.
DEF VAR v_log_method              AS LOG NO-UNDO.

DEF VAR v_wgh_foc                 AS WIDGET-HANDLE FORMAT ">>>>>>9"    NO-UNDO.

DEF VAR v_log_repeat              as log init yes        no-undo.
DEF VAR v_log_pesq                as log init yes        no-undo.

/* Handle de acompanhamento */
DEF VAR h-acomp                   AS HANDLE NO-UNDO.

def rectangle rt_rgf
    size 129.72 by 1.29
    edge-pixels 2.
def rectangle rt_key
    size 155.72 by 1.29
    edge-pixels 2.
def rectangle rt_key_child
    size 65 by 1.29
    edge-pixels 2.
def rectangle rt_param
    size 66.5 by 6.80
    edge-pixels 2.
def rectangle rt_param_1
    size 155.72 by 21.00
    edge-pixels 2.
def rectangle rt_param_2
    size 65 by 3.70
    edge-pixels 2.
def rectangle rt_param_3
    size 60 by 4.70
    edge-pixels 2.
def rectangle rt_param_4
    size 60 by 2.70
    edge-pixels 2.

def rectangle rt_cxft 
    size 65 by 1.50 
    edge-pixels 2.

def rectangle rt_cxft_1
    size 40 by 1.50 
    edge-pixels 2.

def button bt_ok
    label "&OK"
    tooltip "OK"
    size 10 by 1
    auto-go.

def button bt_sav
    label "&Salva"
    tooltip "Salva"
    size 10 by 1
    auto-go.

def button bt_add1
    label "Add"
    tooltip "Inclui"
    image-up file "image/im-add"
    image-insensitive file "image/ii-add"
    size 4.00 by 1.13.
def button bt_del
    label "Del"
    tooltip "Elimina"
    image-up file "image/im-era1"
    image-insensitive file "image/ii-era1"
    size 4.00 by 1.13.
def button bt_det
    label "Det"
    tooltip "Detalhe"
    image-up file "image/im-det"
    image-insensitive file "image/ii-det"
    size 4.00 by 1.13.
def button bt_exi
    label "Sa¡da"
    tooltip "Sa¡da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 4.00 by 1.13
    auto-go.
def button bt_fil2
    label "Fil"
    tooltip "Filtro"
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
    size 4.00 by 1.13.
def button bt_fir
    label "<<"
    tooltip "Primeira Ocorrˆncia da Tabela"
    image-up file "image/im-fir"
    image-insensitive file "image/ii-fir"
    size 4.00 by 1.13.
def button bt_hel1
    label " ?"
    tooltip "Ajuda"
    image-up file "image/im-hel"
    image-insensitive file "image/ii-hel"
    size 4.00 by 1.13.
def button bt_las
    label ">>"
    tooltip "éltima Ocorrˆncia da Tabela"
    image-up file "image/im-las"
    image-insensitive file "image/ii-las"
    size 4.00 by 1.13.
def button bt_mod1
    label "Mod"
    tooltip "Modifica"
    image-up file "image/im-mod"
    image-insensitive file "image/ii-mod"
    size 4.00 by 1.13.
def button bt_nex1
    label ">"
    tooltip "Pr¢xima Ocorrˆncia da Tabela"
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
    size 4.00 by 1.13.
def button bt_pre1
    label "<"
    tooltip "Ocorrˆncia Anterior da Tabela"
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
    size 4.00 by 1.13.
def button bt_pri
    label "Imp"
    tooltip "Gera Planilha"
    image-up file "image/im-pri"
    image-insensitive file "image/ii-pri.bmp"
    size 4.00 by 1.13.
def button bt_ran2
    label "Faixa"
    tooltip "Faixa"
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
    size 4.00 by 1.13.
def button bt_sea
    label "Psq"
    tooltip "Pesquisa"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 4.00 by 1.13.
def button bt_zoo_lay
    label "Zoom" tooltip "Zoom"
    image-up file "image/toolbar/im-zoo"
    image-insensitive file "image/toolbar/ii-zoo"
    size 4 by 1.1.
def button bt_zoo_est
    label "Zoom" tooltip "Zoom"
    image-up file "image/toolbar/im-zoo"
    image-insensitive file "image/toolbar/ii-zoo"
    size 4 by 1.1.
def button bt_zoo_arq
    label "Pesq" tooltip "Pesquisa Planilha"
    image-up file "image/toolbar/im-zoo"
    image-insensitive file "image/toolbar/ii-zoo"
    size 4 by 1.1.

def button bt_all
    label "Todos"
    tooltip "Seleciona Todos"
    image file "image/toolbar/im-ran_a.bmp"
    size 4 by 1.13.
def button bt_nev
    label "Nenhum"
    tooltip "Nenhum"
    image file "image/toolbar/ii-ran_n.bmp"
    size 4 by 1.13.

DEF BUTTON bt_atz
    tooltip "Atualiza Pesquisa"
    IMAGE-UP FILE "image\toolbar\im-check"
    IMAGE-INSENSITIVE FILE "image\toolbar\ii-check"
    LABEL "&Atualiza" 
    SIZE 4 BY 1.13.
def button bt_env
    label "Envia" tooltip "Envia para o Ariba"
    image-up file "image/toolbar/im-exp"
    image-insensitive file "image/toolbar/ii-exp"
    size 4 by 1.13.
def button bt_fil
    LABEL "Fil"
    tooltip "Filtro"
    image-up file "image/im-fil"
    image-insensitive file "image/ii-fil"
    size 4.00 by 1.13.
def button bt_ran
    LABEL "Faixa"
    tooltip "Faixa"
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
    size 4.00 by 1.13.

def button bt_can
    label "&Cancela"
    tooltip "Cancela"
    size 10 by 1
    auto-endkey.

def button bt_exit
    label "&Fecha"
    tooltip "Fecha"
    size 10 by 1
    auto-go.

def image img_status 
    /*file "image/status_10.png" */
    size 5 by 1.4. 

def image im_fld_1 
    file "image/im-fldup72" 
    size 15.72 by 01.21. 
def image im_fld_2 
    file "image/im-fldup72" 
    size 15.72 by 01.21. 
def image im_fld_3 
    file "image/im-fldup72" 
    size 15.72 by 01.21. 


DEF VAR v_label_1  AS CHAR FORMAT "x(11)" VIEW-AS TEXT INITIAL "Parƒmetros"  FONT 4 BGCOLOR 8.
DEF VAR v_label_2  AS CHAR FORMAT "x(08)" VIEW-AS TEXT INITIAL "Pedidos" FONT 4 BGCOLOR 8.
DEF VAR v_label_3  AS CHAR FORMAT "x(12)" VIEW-AS TEXT INITIAL "Integra‡äes" FONT 4 BGCOLOR 8.

def sub-menu  mi_child
    menu-item mi_ran               label "Faixa"
    menu-item mi_fil               label "Filtro".

def sub-menu  mi_table
    menu-item mi_param             label "Parƒmetros"  accelerator "ALT-P"
    RULE
    menu-item mi_det               label "Detalhe"     accelerator "ALT-D"
    RULE
    menu-item mi_print             label "Gera Planilha" 
    RULE
    menu-item mi_exi               label "Sa¡da".

def sub-menu  mi_hel
    menu-item mi_contents          label "Conte£do"
    RULE
    menu-item mi_about             label "Sobre".

def menu      m_main                menubar
    sub-menu  mi_table              label "Arquivo"
    sub-menu  mi_hel                label "Ajuda".


IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
         resize               = yes
         scroll-bars          = no
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.

{esp/ccp/esccp055r.i}

DEF TEMP-TABLE tt-int-ped-compr-aux NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

def query qr-int-ped-compr for tt-int-ped-compr.

def browse br-int-ped-compr query qr-int-ped-compr
    DISPLAY tt-int-ped-compr.log-select   COLUMN-LABEL "Sel" VIEW-AS TOGGLE-BOX             
            tt-int-ped-compr.id-ped-compr COLUMN-LABEL "ID Pedido" FORMAT ">>>,>>9"
            tt-int-ped-compr.num-pedido 
            tt-int-ped-compr.des-situacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(18)"
            tt-int-ped-compr.cod-emitente
            tt-int-ped-compr.nome-abrev   FORMAT "x(20)"
            tt-int-ped-compr.responsavel  COLUMN-LABEL "Comprador"
            // tt-int-ped-compr.des-i-situacao COLUMN-LABEL "Sit Pedido"
            tt-int-ped-compr.cod-estabel FORMAT "x(04)"
            tt-int-ped-compr.val-total COLUMN-LABEL "Valor Total" FORMAT ">>,>>>,>>>,>>9.99"
            tt-int-ped-compr.dat-criac COLUMN-LABEL "Dat Criac"
            tt-int-ped-compr.hra-criac COLUMN-LABEL "Hra Criac" FORMAT "99:99:99" 
            tt-int-ped-compr.dat-movto COLUMN-LABEL "Dat Alter" 
            tt-int-ped-compr.hra-movto COLUMN-LABEL "Hra Alter" FORMAT "99:99:99"
            tt-int-ped-compr.des-status FORMAT "x(20)" COLUMN-LABEL "Status Ariba"
    ENABLE tt-int-ped-compr.log-select
            with size 127.50 by 16.7 multiple separators
                 fgcolor ? bgcolor 15 font 2
                 TITLE "Pedidos de Compra".

DEF BUFFER btt-int-ped-compr FOR tt-int-ped-compr.

def temp-table tt-int-mov-ped-compr like int-mov-ped-compr.

def query qr-int-mov-ped-compr for tt-int-mov-ped-compr.

def browse br-int-mov-ped-compr query qr-int-mov-ped-compr
    display tt-int-mov-ped-compr.num-seq-movto
            tt-int-mov-ped-compr.ind-tip-movto COLUMN-LABEL "Status"
            tt-int-mov-ped-compr.dat-movto
            tt-int-mov-ped-compr.hra-movto 
            tt-int-mov-ped-compr.usr-movto 
            tt-int-mov-ped-compr.des-text-histor             
            with size 127.50 by 6.7 multiple separators
            fgcolor ? bgcolor 15 font 2
            TITLE "Movimentos".

DEFINE BUTTON bt-chamada 
     LABEL "Dados Chamada" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE BUTTON bt-envio 
     LABEL "Dados Envio" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-erros 
     LABEL "Erros" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-record 
     LABEL "LOG de Execu‡Æo" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-retorno 
     LABEL "Dados Retorno" 
     SIZE 15 BY 1.13.

DEF TEMP-TABLE ttRetorno NO-UNDO
    FIELD Retorno AS c FORMAT "x(38)"
    INDEX i Retorno.

DEF TEMP-TABLE tt-es-api-log
    FIELD rw-table       AS ROWID
    FIELD id-api-log     LIKE es-api-log.id-api-log
    FIELD num-pedido     LIKE int-mov-ped-compr.num-pedido
    FIELD rw-pedido      AS ROWID
    FIELD cod-retorno    LIKE es-api-log.cod-retorno
    FIELD aux            LIKE es-api-log.aux    
    FIELD dh-request     LIKE es-api-log.dh-request
    FIELD dh-envio       LIKE es-api-log.dh-envio
    FIELD dh-retorno     LIKE es-api-log.dh-retorno
    FIELD flg-processado LIKE es-api-log.flg-processado
    FIELD id-aplicacao   LIKE es-api-log.id-aplicacao
    FIELD id-URI         LIKE es-api-log.id-URI
    FIELD nome           LIKE es-api-uri.nome
    FIELD id-codigo      LIKE es-api-log.id-codigo
    INDEX es-api-log-01 IS UNIQUE PRIMARY  
          id-api-log
    INDEX es-api-log-02
          id-aplicacao
          id-codigo
          id-URI
          dh-envio
    INDEX es-api-log-03
          flg-processado
          dh-request.

DEFINE QUERY qr-es-api-log FOR tt-es-api-log, es-api-aplicacao, es-api-empresa, es-api-URI, ttRetorno SCROLLING.

DEFINE BROWSE br-es-api-log QUERY qr-es-api-log NO-LOCK
     DISPLAY tt-es-api-log.id-api-log     COLUMN-LABEL "ID"
             // es-api-aplicacao.nome     COLUMN-LABEL "Aplica‡Æo"  FORMAT "x(15)"
             // es-api-empresa.nome       COLUMN-LABEL "Empresa"
             tt-es-api-log.nome              COLUMN-LABEL "URI"
             tt-es-api-log.aux            COLUMN-LABEL " Pedido" FORMAT "x(10)"
             tt-es-api-log.dh-request     COLUMN-LABEL "Requisi‡Æo" FORMAT "99/99/9999 HH:MM:SS":U
             tt-es-api-log.dh-envio       COLUMN-LABEL "Envio"      FORMAT "99/99/9999 HH:MM:SS":U
             tt-es-api-log.dh-retorno     COLUMN-LABEL "Retorno"    FORMAT "99/99/9999 HH:MM:SS":U
             tt-es-api-log.flg-processado
             ttRetorno.Retorno         COLUMN-LABEL "C¢digo Retorno"
     WITH NO-ASSIGN SEPARATORS SIZE 127.50 BY 22 FONT 1.

def frame f_main
    rt_rgf
        at row 01.10 col 01.00 bgcolor 7 
    bt_atz
        at row 01.18 col 01.34 font ?
        help "Atualiza"
    bt_det
        at row 01.18 col 06.34 font ?
        help "Detalhe"
    bt_del
         at row 01.18 col 10.34 font ?
         help "Detalhe"
    bt_pri
         at row 01.18 col 14.34 font ?
         help "Imprime"
    bt_all
         at row 01.18 col 19.34 font ?
         help "Seleciona Todos"
    bt_nev
         at row 01.18 col 23.84 font ?
         help "Desmarca Todos"
    bt_env
         at row 01.18 col 28.84 font ?
         help "Envia Pedidos"
    bt_exi
         at row 01.18 col 122.57 font ?
         help "Sa¡da"
    bt_hel1
         at row 01.18 col 126.57 font ?
         help "Ajuda"
    im_fld_1
        at row 02.50 col 02.00 
    v_label_1 NO-LABEL
        AT ROW 02.75 COL 3.00 FONT 4
    im_fld_2
        at row 02.50 col 12.30 
    v_label_2 NO-LABEL
        AT ROW 02.75 COL 14.40
    im_fld_3
        at row 02.50 col 22.60 
    v_label_3 NO-LABEL
        AT ROW 02.75 COL 23.70
    br-int-ped-compr
        at row 03.40 col 2.00
        help "Pedidos de Compra" 
    br-int-mov-ped-compr
        at row 20.50 col 2.00
        help "Movimentos do Pedido de Compra"
    br-es-api-log
        at row 03.40 col 2.00
        help "Logs de Integra‡Æo" 
    bt-chamada AT ROW 25.80 COL 2 WIDGET-ID 38
    bt-envio   AT ROW 25.80 COL 17.14 WIDGET-ID 2
    bt-retorno AT ROW 25.80 COL 32.29 WIDGET-ID 4
    bt-erros   AT ROW 25.80 COL 47.57 WIDGET-ID 40
    bt-record  AT ROW 25.80 COL 62.77 WIDGET-ID 44
    with 1 down side-labels no-validate keep-tab-order three-d 
        size-char 130.20 by 27.30 
        at row 01.13 col 01.00
        font 1 fgcolor ? bgcolor 8 
        title "Cockpit Pedidos de Compra - ESCCP055 - 12.00.00.000".

{include/i_fclfrm.i f_main}

/* Faixa */
def rectangle rt_frame
    size 120 by 17.80
    edge-pixels 2.

def rectangle rt_faixa
    size 55 by 6.80
    edge-pixels 2.

def rectangle rt_cxftfx 
    size 55 by 1.50 
    edge-pixels 2.

def image im_inic1     file "image/im-ante.gif".
def image im_fim1      file "image/im-nex1.gif".
def image im_inic2     file "image/im-ante.gif".
def image im_fim2      file "image/im-nex1.gif".
def image im_inic3     file "image/im-ante.gif".
def image im_fim3      file "image/im-nex1.gif".
def image im_inic4     file "image/im-ante.gif".
def image im_fim4      file "image/im-nex1.gif".
def image im_inic5     file "image/im-ante.gif".
def image im_fim5      file "image/im-nex1.gif".
def image im_inic6     file "image/im-ante.gif".
def image im_fim6      file "image/im-nex1.gif".
def image im_inic7     file "image/im-ante.gif".
def image im_fim7      file "image/im-nex1.gif".

def frame f_faixa
    rt_faixa
        at row 01.40 col 1.00 colon-aligned 
        fgcolor ? bgcolor 17
    v_cod_estab_ini LABEL "Estab"
        at row 1.88 col 22.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    im_inic1
        at row 1.90 col 30.5
    im_fim1
        at row 1.90 col 33.5
    v_cod_estab_fim NO-LABEL
        at row 1.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v-num-pedido-ini LABEL "Pedido"
        at row 2.88 col 19.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    im_inic2
        at row 2.90 col 30.5
    im_fim2
        at row 2.90 col 33.5
    v-num-pedido-fim NO-LABEL
        at row 2.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v_cdn_fornec_ini LABEL "Fornec"
        at row 3.88 col 18.00 colon-aligned 
        view-as fill-in 
        TOOLTIP "F5 para Zoom"
        fgcolor ? bgcolor 15 font 2
    im_inic3
        at row 3.90 col 30.5
    im_fim3
        at row 3.90 col 33.5
    v_cdn_fornec_fim NO-LABEL
        at row 3.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v-cod-compr-ini LABEL "Comprador"
        at row 4.88 col 15.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    im_inic4
        at row 4.90 col 30.5
    im_fim4
        at row 4.90 col 33.5
    v-cod-compr-fim NO-LABEL
        at row 4.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v-dat-criac-ini LABEL "Dt Cria‡Æo"
        at row 5.88 col 17.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    im_inic5
        at row 5.90 col 30.5
    im_fim5
        at row 5.90 col 33.5
    v-dat-criac-fim NO-LABEL
        at row 5.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    v-dat-integr-ini LABEL "Dt Integra‡Æo"
        at row 6.88 col 17.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    im_inic6
        at row 6.90 col 30.5
    im_fim6
        at row 6.90 col 33.5
    v-dat-integr-fim NO-LABEL
        at row 6.88 col 35.00 colon-aligned 
        view-as fill-in 
        fgcolor ? bgcolor 15 font 2
    rt_param
        at row 01.40 col 58.00 colon-aligned 
        fgcolor ? bgcolor 17
    " Status Integra‡Æo " view-as text
        at row 01.17 col 67.00
    v-log-naointegr
        at row 2.8 col 66.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-integr
        at row 2.8 col 85.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-excluido
        at row 2.8 col 102.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-process
        at row 3.8 col 66.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-cancel
        at row 3.8 col 85.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-revisao
        at row 4.8 col 66.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    v-log-erro
        at row 4.8 col 85.00 COLON-ALIGNED
        VIEW-AS TOGGLE-BOX
    with 1 down side-LABELs no-validate keep-tab-order three-d 
         size-char 128.00 by 24
         at row 01.13 col 01.00 
         font 1 fgcolor ? bgcolor 17.

DEF VAR v_log_exec AS LOG NO-UNDO.

/*--- Triggers ---*/
DEFINE VARIABLE v_hdl_coluna AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_cod_campo  AS CHARACTER   NO-UNDO.

ON START-SEARCH OF br-int-ped-compr IN FRAME f_main DO:
    ASSIGN v_hdl_coluna = br-int-ped-compr:CURRENT-COLUMN
           v_cod_campo  = v_hdl_coluna:NAME.
    QUERY qr-int-ped-compr:QUERY-PREPARE('FOR EACH tt-int-ped-compr BY ':U + v_cod_campo).
    QUERY qr-int-ped-compr:QUERY-OPEN().
END.
ASSIGN br-int-ped-compr:ALLOW-COLUMN-SEARCHING in frame f_main = YES.

ON F5 OF v_cod_estab_ini IN FRAME f_faixa /* Estabelecimento */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                           &campo=v_cod_estab_ini
                           &campozoom=cod-estabel
                           &FRAME=f_faixa}   
END.
    
ON MOUSE-SELECT-DBLCLICK OF v_cod_estab_ini IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v_cod_estab_fim IN FRAME f_faixa /* Estabelecimento */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                          &campo=v_cod_estab_fim
                          &campozoom=cod-estabel
                          &FRAME=f_faixa}   
END.

ON F7 OF v_cod_estab_fim IN FRAME f_faixa /* Estabelecimento */ DO:

  ASSIGN v_cod_estab_fim:SCREEN-VALUE IN FRAME f_faixa = v_cod_estab_ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON MOUSE-SELECT-DBLCLICK OF v_cod_estab_fim IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v_cdn_fornec_ini IN FRAME f_faixa /* Fornecedor */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                           &campo=v_cdn_fornec_ini
                           &campozoom=cod-emitente
                           &FRAME=f_faixa}
END.

ON F7 OF v_cdn_fornec_fim IN FRAME f_faixa /* Fornecedor */ DO:

 ASSIGN v_cdn_fornec_fim:SCREEN-VALUE IN FRAME f_faixa = v_cdn_fornec_ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON MOUSE-SELECT-DBLCLICK OF v_cdn_fornec_ini IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v_cdn_fornec_fim IN FRAME f_faixa /* Fornecedor */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                          &campo=v_cdn_fornec_fim
                          &campozoom=cod-emitente
                          &FRAME=f_faixa}
END.

ON F7 OF v_cdn_fornec_fim IN FRAME f_faixa /* Fornecedor */ DO:

    ASSIGN v_cdn_fornec_fim:SCREEN-VALUE IN FRAME f_faixa = v_cdn_fornec_ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON MOUSE-SELECT-DBLCLICK OF v_cdn_fornec_fim IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v-num-pedido-ini IN FRAME f_faixa /* Pedido */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                       &campo="v-num-pedido-ini"
                       &campozoom="num-pedido"
                       &frame="f_faixa"}
  
END.

ON MOUSE-SELECT-DBLCLICK OF v-num-pedido-ini IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v-num-pedido-fim IN FRAME f_faixa /* Pedido */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                       &campo="v-num-pedido-fim"
                       &campozoom="num-pedido"
                       &frame="f_faixa"}
  
END.

ON F7 OF v-num-pedido-fim IN FRAME f_faixa /* Fornecedor */ DO:

    ASSIGN v-num-pedido-fim:SCREEN-VALUE IN FRAME f_faixa = v-num-pedido-ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON MOUSE-SELECT-DBLCLICK OF v-num-pedido-fim IN FRAME f_faixa /* Pedido */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v-cod-compr-ini IN FRAME f_faixa /* Comprador */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=v-cod-compr-ini
                       &campozoom=cod-comprado
                       &frame="f_faixa"} 
END.

ON MOUSE-SELECT-DBLCLICK OF v-cod-compr-ini IN FRAME f_faixa /* Comprador */ DO:
    APPLY "F5" TO SELF.
END.

ON F5 OF v-cod-compr-fim IN FRAME f_faixa /* Comprador */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=v-cod-compr-fim
                       &campozoom=cod-comprado
                       &frame="f_faixa"} 
END.

ON F7 OF v-cod-compr-fim IN FRAME f_faixa /* Comprador */ DO:

   ASSIGN v-cod-compr-fim:SCREEN-VALUE IN FRAME f_faixa = v-cod-compr-ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON MOUSE-SELECT-DBLCLICK OF v-cod-compr-fim IN FRAME f_faixa /* Comprador */ DO:
    APPLY "F5" TO SELF.
END.

ON F7 OF v-dat-criac-fim IN FRAME f_faixa /* Data Cria‡Æo */ DO:

   ASSIGN v-dat-criac-fim:SCREEN-VALUE IN FRAME f_faixa = v-dat-criac-ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON F7 OF v-dat-integr-fim IN FRAME f_faixa /* Data Integra‡Æo */ DO:

   ASSIGN v-dat-integr-fim:SCREEN-VALUE IN FRAME f_faixa = v-dat-integr-ini:SCREEN-VALUE IN FRAME f_faixa.

END.

ON CHOOSE OF bt_exi IN FRAME f_main DO:
   ASSIGN v_log_repeat = NO.
END.

ON CHOOSE OF bt_atz IN FRAME f_main do:

    IF v_log_pesq = YES THEN DO:

        CLOSE QUERY qr-int-ped-compr.

        RUN pi-gera-tt-ini-ped-compr.
        /*
        IF INPUT FRAME f_faixa v_cod_estab_ini  <> v_cod_estab_ini
        OR INPUT FRAME f_faixa v_cod_estab_fim  <> v_cod_estab_fim 
        OR INPUT FRAME f_faixa v_cdn_fornec_ini <> v_cdn_fornec_ini
        OR INPUT FRAME f_faixa v_cdn_fornec_fim <> v_cdn_fornec_fim
        OR INPUT FRAME f_faixa v-num-pedido-ini <> v-num-pedido-ini
        OR INPUT FRAME f_faixa v-num-pedido-fim <> v-num-pedido-fim
        OR INPUT FRAME f_faixa v-cod-compr-ini  <> v-cod-compr-ini
        OR INPUT FRAME f_faixa v-cod-compr-fim  <> v-cod-compr-fim
        OR INPUT FRAME f_faixa v-dat-criac-ini  <> v-dat-criac-ini            
        OR INPUT FRAME f_faixa v-dat-criac-fim  <> v-dat-criac-fim
        OR INPUT FRAME f_faixa v-dat-integr-ini <> v-dat-integr-ini
        OR INPUT FRAME f_faixa v-dat-integr-fim <> v-dat-integr-fim
        OR NOT CAN-FIND (FIRST tt-int-ped-compr) THEN DO:
            RUN pi-gera-tt-ini-ped-compr.
        END.
        */
        IF INPUT FRAME f_faixa v-log-naointegr  <> v-log-naointegr
        OR INPUT FRAME f_faixa v-log-integr     <> v-log-integr
        OR INPUT FRAME f_faixa v-log-process    <> v-log-process
        OR INPUT FRAME f_faixa v-log-excluido   <> v-log-excluido
        OR INPUT FRAME f_faixa v-log-revisao    <> v-log-revisao
        OR INPUT FRAME f_faixa v-log-erro       <> v-log-erro
        OR INPUT FRAME f_faixa v-log-cancel     <> v-log-cancel THEN DO:
            ASSIGN INPUT FRAME f_faixa v-log-naointegr
                   INPUT FRAME f_faixa v-log-integr
                   INPUT FRAME f_faixa v-log-process
                   INPUT FRAME f_faixa v-log-excluido
                   INPUT FRAME f_faixa v-log-revisao
                   INPUT FRAME f_faixa v-log-erro
                   INPUT FRAME f_faixa v-log-cancel.
        END.
        /*ASSIGN INPUT FRAME f_faixa v_cod_estab_ini
               INPUT FRAME f_faixa v_cod_estab_fim.*/

        bt_atz:LOAD-IMAGE("image\toolbar\im-chec.bmp").
        ENABLE bt_det bt_pri bt_del
               bt_all bt_nev bt_env
               im_fld_2 v_label_2
               im_fld_3 v_label_3               
               WITH FRAME f_main.
        ASSIGN v_log_pesq = NO.
        
        APPLY "MOUSE-SELECT-CLICK" TO im_fld_2 IN FRAME f_main.
        FOR EACH tt-int-ped-compr:
            ASSIGN tt-int-ped-compr.log-select = NO.
        END.
        RUN pi-open-tt-int-ped-compr.
        
        APPLY "home" TO br-int-ped-compr IN FRAME f_main.
        APPLY "entry" TO br-int-ped-compr IN FRAME f_main.

    END.        
    ELSE DO:
        bt_atz:LOAD-IMAGE("image\toolbar\im-check.bmp").
        ASSIGN v_log_pesq = YES.
    END.

END.

ON CHOOSE OF bt_pri IN FRAME f_main
OR CHOOSE OF menu-item mi_print IN MENU m_main DO:

   IF bt_pri:SENSITIVE IN FRAME f_main = YES THEN
       RUN btb/btb944za.p (INPUT br-int-ped-compr:HANDLE IN FRAME f_main).

END.

ON MOUSE-SELECT-CLICK OF im_fld_1 IN FRAME f_main
OR MOUSE-SELECT-CLICK OF v_label_1 IN FRAME f_main DO: 
    
    if im_fld_2:load-image('image/im-flddn72') then.
    if im_fld_3:load-image('image/im-flddn72') then.
    if im_fld_1:load-image('image/im-fldup72') then.    
    ASSIGN v_label_1:FGCOLOR IN FRAME f_main = 9
           v_label_1:BGCOLOR IN FRAME f_main = 8
           v_label_2:FGCOLOR IN FRAME f_main = 15
           v_label_2:BGCOLOR IN FRAME f_main = 8
           v_label_3:FGCOLOR IN FRAME f_main = 15
           v_label_3:BGCOLOR IN FRAME f_main = 8           
           v_cod_opcao = "Parƒmetros".    
    DISABLE bt_det  bt_del bt_pri
            bt_all bt_nev bt_env
            WITH FRAME f_main.    
    RUN pi_opcao.
END.

ON MOUSE-SELECT-CLICK OF im_fld_2 IN FRAME f_main
OR MOUSE-SELECT-CLICK OF v_label_2 IN FRAME f_main DO: 
    
    if im_fld_1:load-image('image/im-flddn72') then.
    if im_fld_3:load-image('image/im-flddn72') then.
    if im_fld_2:load-image('image/im-fldup72') then.    
    ASSIGN v_label_2:FGCOLOR IN FRAME f_main = 9
           v_label_2:BGCOLOR IN FRAME f_main = 8
           v_label_1:FGCOLOR IN FRAME f_main = 15
           v_label_1:BGCOLOR IN FRAME f_main = 8
           v_label_3:FGCOLOR IN FRAME f_main = 15
           v_label_3:BGCOLOR IN FRAME f_main = 8
           v_cod_opcao = "Pesquisa".
    DISABLE bt_atz WITH FRAME f_main.
    RUN pi_opcao.

END.

ON MOUSE-SELECT-CLICK OF im_fld_3 IN FRAME f_main
OR MOUSE-SELECT-CLICK OF v_label_3 IN FRAME f_main DO: 
    
    if im_fld_1:load-image('image/im-flddn72') then.
    if im_fld_2:load-image('image/im-flddn72') then.
    if im_fld_3:load-image('image/im-fldup72') then.    
    ASSIGN v_label_3:FGCOLOR IN FRAME f_main = 9
           v_label_3:BGCOLOR IN FRAME f_main = 8
           v_label_1:FGCOLOR IN FRAME f_main = 15
           v_label_1:BGCOLOR IN FRAME f_main = 8
           v_label_2:FGCOLOR IN FRAME f_main = 15
           v_label_2:BGCOLOR IN FRAME f_main = 8
           v_cod_opcao = "Integra‡Æo".
    DISABLE bt_atz WITH FRAME f_main.
    RUN pi_opcao.

END.

ON 'entry':U OF br-int-ped-compr IN FRAME f_main DO:

     APPLY "value-changed" TO br-int-ped-compr IN FRAME f_main.
    
END.

ON VALUE-CHANGED OF br-int-ped-compr IN FRAME f_main DO:
    
    IF AVAIL tt-int-ped-compr THEN DO:
        find int-ped-compr no-lock
            where int-ped-compr.id-ped-compr = tt-int-ped-compr.id-ped-compr
              and int-ped-compr.num-pedido  = tt-int-ped-compr.num-pedido no-error.
        if avail int-ped-compr then do:
            assign v-rec-int-ped-compr = recid (int-ped-compr)
                   gr-pedido-compr     = tt-int-ped-compr.row-table.
            run pi-cria-int-mov-ped-compr.
            run pi-open-int-mov-ped-compr.
        end.
        IF tt-int-ped-compr.des-situacao = "Em Processamento"
        OR (tt-int-ped-compr.des-situacao = "Integrado" AND v-log-reenvio = NO)
        OR tt-int-ped-compr.des-situacao = "Pedido Cancelado"
        OR tt-int-ped-compr.des-situacao = "Registro Exclu¡do"
        OR tt-int-ped-compr.des-situacao = "Exclu¡do" THEN 
            ASSIGN tt-int-ped-compr.log-select:COLUMN-READ-ONLY IN BROWSE br-int-ped-compr = YES.
        ELSE
            ASSIGN tt-int-ped-compr.log-select:COLUMN-READ-ONLY IN BROWSE br-int-ped-compr = NO.        
    END.
    ELSE
        ASSIGN v-rec-int-ped-compr = ?.

END.

ON LEAVE OF tt-int-ped-compr.log-select IN BROWSE br-int-ped-compr
OR VALUE-CHANGED OF tt-int-ped-compr.log-select IN BROWSE br-int-ped-compr DO:

    IF AVAIL tt-int-ped-compr THEN DO:
        IF tt-int-ped-compr.log-select:COLUMN-READ-ONLY IN BROWSE br-int-ped-compr = NO THEN DO:
            ASSIGN INPUT BROWSE br-int-ped-compr tt-int-ped-compr.log-select.
            IF tt-int-ped-compr.log-select = YES THEN
                ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr = 10.
            /*ELSE
                ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr = 15.*/
        END.
    END.

END.

ON ENTRY OF br-es-api-log IN FRAME f_main DO:

     APPLY "value-changed" TO br-es-api-log IN FRAME f_main.
    
END.

ON VALUE-CHANGED OF br-es-api-log IN FRAME f_main DO:
    
    IF AVAIL tt-es-api-log THEN DO:
        FIND es-api-log NO-LOCK
            WHERE es-api-log.id-api-log = tt-es-api-log.id-api-log NO-ERROR.         
        ASSIGN v-rw-es-api-log-cock = IF AVAIL es-api-log THEN ROWID (es-api-log) ELSE ?
               gr-pedido-compr      = tt-es-api-log.rw-pedido.
    END.
    ELSE
        ASSIGN v-rw-es-api-log-cock = ?
               gr-pedido-compr      = ?.

END.

ON CHOOSE OF bt_det IN FRAME f_main 
OR CHOOSE OF menu-item mi_det IN MENU m_main DO:

    IF v_cod_opcao <> "Parƒmetros" THEN DO:
        IF gr-pedido-compr <> ? THEN DO:
            RUN ccp/cc0509.w.
        END.
    END.

END.

ON MOUSE-SELECT-DBLCLICK OF br-int-ped-compr IN FRAME f_main DO:

    APPLY "Choose" TO bt_det IN FRAME f_main.

END.

ON CHOOSE OF bt_all IN FRAME f_main DO:       
        
    ASSIGN v_log_method = session:set-wait-state('general').
    FOR EACH tt-int-ped-compr:
        IF tt-int-ped-compr.des-situacao = "Em Processamento"
        OR (tt-int-ped-compr.des-situacao = "Integrado" AND v-log-reenvio = NO)
        OR tt-int-ped-compr.des-situacao = "Pedido Cancelado"
        OR tt-int-ped-compr.des-situacao = "Registro Exclu¡do"
        OR tt-int-ped-compr.des-situacao = "Exclu¡do" THEN
            NEXT.
        ASSIGN tt-int-ped-compr.log-select = YES.
    END.    
    ASSIGN v_log_method = session:set-wait-state('').
        
    OPEN QUERY qr-int-ped-compr
        FOR EACH tt-int-ped-compr
            BY tt-int-ped-compr.id-ped-compr DESCENDING.

    APPLY "home" to br-int-ped-compr in frame f_main.            
    APPLY "entry" TO br-int-ped-compr IN FRAME f_main.
    
END.

ON CHOOSE OF bt_nev IN FRAME f_main DO:       
        
    ASSIGN v_log_method = session:set-wait-state('general').
    FOR EACH tt-int-ped-compr:
        ASSIGN tt-int-ped-compr.log-select = NO.
    END.    
    ASSIGN v_log_method = session:set-wait-state('').
        
    OPEN QUERY qr-int-ped-compr
        FOR EACH tt-int-ped-compr
            BY tt-int-ped-compr.id-ped-compr DESCENDING.

    APPLY "home" to br-int-ped-compr in frame f_main.            
    APPLY "entry" TO br-int-ped-compr IN FRAME f_main.
    
END.

ON CHOOSE OF bt_env IN FRAME f_main DO:

    IF NOT CAN-FIND (FIRST tt-int-ped-compr
                     WHERE tt-int-ped-compr.log-select) THEN DO:
        MESSAGE "Selecione pelo menos um Pedido de Compra!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    FIND CURRENT tt-int-ped-compr NO-ERROR.
    RELEASE tt-int-ped-compr.

    EMPTY TEMP-TABLE tt-int-ped-compr-aux.

    FOR EACH btt-int-ped-compr
        WHERE btt-int-ped-compr.log-select = YES:
        IF  btt-int-ped-compr.des-situacao <> "NÆo Integrado"
        AND btt-int-ped-compr.des-situacao <> "Em Processamento"
        AND (btt-int-ped-compr.des-situacao = "Integrado" AND v-log-reenvio = NO)
        AND btt-int-ped-compr.des-situacao <> "Em RevisÆo"
        AND btt-int-ped-compr.des-situacao <> "Erro Integra‡Æo" THEN
            NEXT.

        IF CAN-FIND(FIRST tt-int-ped-compr-aux WHERE /* Evitar bug */
                          tt-int-ped-compr-aux.num-pedido = btt-int-ped-compr.num-pedido)
        THEN NEXT.

        CREATE tt-int-ped-compr-aux.
        ASSIGN tt-int-ped-compr-aux.num-pedido = btt-int-ped-compr.num-pedido.
        FIND CURRENT tt-int-ped-compr-aux NO-ERROR.
        RELEASE tt-int-ped-compr-aux.

        RUN esp/ccp/esccp055r.p (INPUT YES,           // Acompanhamento
                                 INPUT btt-int-ped-compr.num-pedido,
                                 INPUT "es-api-log",  // pi-cria-es-api-log
                                 INPUT v-log-reenvio, // Reenvio
                                 INPUT-OUTPUT TABLE tt-int-ped-compr).
    END.
    CLOSE QUERY qr-int-ped-compr.

    RUN pi-gera-tt-ini-ped-compr.
    RUN pi-open-tt-int-ped-compr.

    APPLY "home" TO br-int-ped-compr IN FRAME f_main.
    APPLY "entry" TO br-int-ped-compr IN FRAME f_main.

END.

ON CHOOSE OF bt_del IN FRAME f_main DO:

    IF NOT CAN-FIND (FIRST tt-int-ped-compr
                     WHERE tt-int-ped-compr.log-select) THEN DO:
        MESSAGE "Selecione pelo menos um Pedido de Compra!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    FOR EACH btt-int-ped-compr
        WHERE btt-int-ped-compr.log-select = YES:
        IF  btt-int-ped-compr.des-situacao <> "NÆo Integrado"
        AND btt-int-ped-compr.des-situacao <> "Em RevisÆo"
        AND btt-int-ped-compr.des-situacao <> "Erro Integra‡Æo" THEN
            NEXT.
        IF not can-find(first int-mov-ped-compr where
                              int-mov-ped-compr.id-ped-compr  = btt-int-ped-compr.id-ped-compr
                          and int-mov-ped-compr.ind-tip-movto = "Integrado"
                              no-lock)
        THEN DO:
            RUN pi-del-int-ped-compr (INPUT btt-int-ped-compr.num-pedido).
        END.
    END.
    
    APPLY "entry" TO br-int-ped-compr IN FRAME f_main.

END.

ON CHOOSE OF bt-chamada IN FRAME f_main /* Dados Chamada */ DO:

    IF v-rw-es-api-log-cock <> ? THEN DO:
        FIND es-api-log NO-LOCK
            WHERE ROWID (es-api-log) = v-rw-es-api-log-cock NO-ERROR.
        IF AVAIL es-api-log THEN 
            RUN esp/esapi504b.w (ROWID(es-api-log)).
    END.
    
END.

ON CHOOSE OF bt-envio IN FRAME f_main /* Dados Envio */ DO:

   DEF VAR lcEnvio AS LONGCHAR NO-UNDO.

   FIND es-api-log NO-LOCK
       WHERE ROWID (es-api-log) = v-rw-es-api-log-cock NO-ERROR.   
   IF AVAIL es-api-log THEN DO:
       COPY-LOB es-api-log.cl-envio TO lcEnvio.       
       IF es-api-log.id-uri BEGINS "AribaPedCompr" THEN DO:
          // MESSAGE es-api-log.id-uri VIEW-AS ALERT-BOX.
          lcEnvio = fcFormatJson(lcEnvio).
       END.
       RUN esp/esapi504a.w (lcEnvio).
   END.

END.

ON CHOOSE OF bt-retorno IN FRAME f_main /* Dados Retorno */ DO:

   DEF VAR lcEnvio AS LONGCHAR NO-UNDO.

   FIND es-api-log NO-LOCK
       WHERE ROWID (es-api-log) = v-rw-es-api-log-cock NO-ERROR.
   IF AVAIL es-api-log THEN DO:
       COPY-LOB es-api-log.cl-retorno TO lcEnvio.
       IF es-api-log.id-uri BEGINS "AribaPedCompr" THEN DO:          
          lcEnvio = fcFormatJson(lcEnvio).          
       END.       
       RUN esp/esapi504a.w (lcEnvio).
   END.

END.

ON CHOOSE OF bt-erros IN FRAME f_main /* Erros */ DO:

    DEF VAR hShowMsg AS HANDLE NO-UNDO.
   
    FIND es-api-log NO-LOCK
        WHERE ROWID (es-api-log) = v-rw-es-api-log-cock NO-ERROR.
    IF AVAIL es-api-log THEN DO:
       EMPTY TEMP-TABLE RowErrors.
       FOR EACH es-api-aux NO-LOCK
             OF es-api-log
          WHERE es-api-aux.tipo = "RowErrors":
           CREATE RowErrors.
           RAW-TRANSFER es-api-aux.raw-aux TO RowErrors NO-ERROR. 
       END.
         
       IF CAN-FIND(FIRST RowErrors) THEN DO:
         {method/showmessage.i1}
         {method/showmessage.i2}
         RETURN "NOK".
      END.
    END.

END.

ON CHOOSE OF bt-record IN FRAME f_main /* LOG de Execu‡Æo */ DO:

    DEF VAR cArquivo AS CHAR NO-UNDO.
    DEF VAR cAux     AS LONGCHAR NO-UNDO.

   IF AVAIL es-api-log THEN DO:
       FOR  EACH es-api-aux NO-LOCK
           WHERE es-api-aux.id-api-log =  es-api-log.id-api-log
             AND es-api-aux.Tipo       =  "Record"
              BY es-api-aux.id-api-log
              BY es-api-aux.Tipo      
              BY es-api-aux.seq:
          cAux = es-api-aux.cl-aux.
          cAux = REPLACE(cAux,CHR(10),CHR(13) + CHR(10)).
       END.
       IF cAux <> "" THEN DO:
           ASSIGN cArquivo = SESSION:TEMP-DIRECTORY + "RET" + STRING(TIME) + STRING(RANDOM(1,1000)) + ".lst".
           COPY-LOB cAux TO FILE cArquivo.
           RUN OpenDocument (cArquivo).
      END.

   END.
END.

ON ROW-DISPLAY OF br-int-ped-compr DO:

    IF AVAIL tt-int-ped-compr THEN DO:
        IF tt-int-ped-compr.des-situacao = "Em Processamento"
        OR (tt-int-ped-compr.des-situacao = "Integrado" AND v-log-reenvio = NO)
        OR tt-int-ped-compr.des-situacao = "Pedido Cancelado"
        OR tt-int-ped-compr.des-situacao = "Registro Exclu¡do"
        OR tt-int-ped-compr.des-situacao = "Exclu¡do" THEN DO:
            ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr   = 8                 
                   tt-int-ped-compr.id-ped-compr:BGCOLOR IN BROWSE br-int-ped-compr = 8
                   tt-int-ped-compr.num-pedido:BGCOLOR IN BROWSE br-int-ped-compr   = 8                
                   tt-int-ped-compr.des-situacao:BGCOLOR IN BROWSE br-int-ped-compr = 8
                   tt-int-ped-compr.cod-emitente:BGCOLOR IN BROWSE br-int-ped-compr = 8
                   tt-int-ped-compr.nome-abrev:BGCOLOR IN BROWSE br-int-ped-compr   = 8
                   tt-int-ped-compr.responsavel:BGCOLOR IN BROWSE br-int-ped-compr  = 8         
                   tt-int-ped-compr.cod-estabel:BGCOLOR IN BROWSE br-int-ped-compr  = 8
                   tt-int-ped-compr.val-total:BGCOLOR IN BROWSE br-int-ped-compr    = 8
                   tt-int-ped-compr.dat-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 8
                   tt-int-ped-compr.hra-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 8
                   tt-int-ped-compr.dat-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 8
                   tt-int-ped-compr.hra-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 8
                   tt-int-ped-compr.des-status:BGCOLOR IN BROWSE br-int-ped-compr   = 8.
        END.           
        ELSE DO:
            IF (tt-int-ped-compr.des-situacao = "Integrado" AND v-log-reenvio = YES) THEN DO:
                ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr   = 11                 
                       tt-int-ped-compr.id-ped-compr:BGCOLOR IN BROWSE br-int-ped-compr = 11
                       tt-int-ped-compr.num-pedido:BGCOLOR IN BROWSE br-int-ped-compr   = 11                
                       tt-int-ped-compr.des-situacao:BGCOLOR IN BROWSE br-int-ped-compr = 11
                       tt-int-ped-compr.cod-emitente:BGCOLOR IN BROWSE br-int-ped-compr = 11
                       tt-int-ped-compr.nome-abrev:BGCOLOR IN BROWSE br-int-ped-compr   = 11
                       tt-int-ped-compr.responsavel:BGCOLOR IN BROWSE br-int-ped-compr  = 11        
                       tt-int-ped-compr.cod-estabel:BGCOLOR IN BROWSE br-int-ped-compr  = 11
                       tt-int-ped-compr.val-total:BGCOLOR IN BROWSE br-int-ped-compr    = 11
                       tt-int-ped-compr.dat-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 11
                       tt-int-ped-compr.hra-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 11
                       tt-int-ped-compr.dat-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 11
                       tt-int-ped-compr.hra-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 11
                       tt-int-ped-compr.des-status:BGCOLOR IN BROWSE br-int-ped-compr   = 11.
                IF tt-int-ped-compr.log-select = YES THEN
                    ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr   = 10.
            END.
            ELSE DO:
                ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr   = 15                 
                       tt-int-ped-compr.id-ped-compr:BGCOLOR IN BROWSE br-int-ped-compr = 15
                       tt-int-ped-compr.num-pedido:BGCOLOR IN BROWSE br-int-ped-compr   = 15                
                       tt-int-ped-compr.des-situacao:BGCOLOR IN BROWSE br-int-ped-compr = 15
                       tt-int-ped-compr.cod-emitente:BGCOLOR IN BROWSE br-int-ped-compr = 15
                       tt-int-ped-compr.nome-abrev:BGCOLOR IN BROWSE br-int-ped-compr   = 15
                       tt-int-ped-compr.responsavel:BGCOLOR IN BROWSE br-int-ped-compr  = 15        
                       tt-int-ped-compr.cod-estabel:BGCOLOR IN BROWSE br-int-ped-compr  = 15
                       tt-int-ped-compr.val-total:BGCOLOR IN BROWSE br-int-ped-compr    = 15
                       tt-int-ped-compr.dat-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 15
                       tt-int-ped-compr.hra-criac:BGCOLOR IN BROWSE br-int-ped-compr    = 15
                       tt-int-ped-compr.dat-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 15
                       tt-int-ped-compr.hra-movto:BGCOLOR IN BROWSE br-int-ped-compr    = 15
                       tt-int-ped-compr.des-status:BGCOLOR IN BROWSE br-int-ped-compr   = 15.
                IF tt-int-ped-compr.log-select = YES THEN
                    ASSIGN tt-int-ped-compr.log-select:BGCOLOR IN BROWSE br-int-ped-compr   = 10.
            END.
        END.
    END.

END.

{include/i_fclwin.i wh_w_program}

/*
ON WINDOW-MAXIMIZED OF wh_w_program DO:
    
    def var v_whd_widget as widget-handle no-undo.
    assign frame f_main:width-chars  = wh_w_program:width-chars
           frame f_main:height-chars = wh_w_program:height-chars no-error.
    
    IF v_cod_opcao = "Parƒmetros" THEN
        RETURN NO-APPLY.

    for each tt_maximizacao:
        assign v_whd_widget = tt_maximizacao.hdl-widget.
    
        if tt_maximizacao.log-posiciona-row = yes then do:
            assign v_whd_widget:row = wh_w_program:height - (tt_maximizacao.window-height-original - tt_maximizacao.row-original).
        end.
        if tt_maximizacao.log-calcula-width = yes then do:
            assign v_whd_widget:width = wh_w_program:width - ( tt_maximizacao.window-width-original - tt_maximizacao.width-original ).
        end.
        if tt_maximizacao.log-calcula-height = yes then do:
            assign v_whd_widget:height = wh_w_program:height - ( tt_maximizacao.window-height-original - tt_maximizacao.height-original ).
        end.
        if tt_maximizacao.log-posiciona-col = yes then do:
            assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
        end.
        if tt_maximizacao.tipo-widget = 'button'
        and tt_maximizacao.log-button-right = yes then do:
            assign v_whd_widget:col = wh_w_program:width - (tt_maximizacao.window-width-original - tt_maximizacao.col-original).
        end.
    end.    
end.

ON WINDOW-RESTORED OF wh_w_program DO:
    
    def var v_whd_widget as widget-handle no-undo.

    for each tt_maximizacao:
        assign v_whd_widget = tt_maximizacao.hdl-widget.
    
        if can-query(v_whd_widget,'row') then
            assign v_whd_widget:row    = tt_maximizacao.row-original    no-error.
    
        if can-query(v_whd_widget,'col') then
            assign v_whd_widget:col    = tt_maximizacao.col-original    no-error.
    
        if can-query(v_whd_widget,'width') then
            assign v_whd_widget:width  = tt_maximizacao.width-original  no-error.
    
        if can-query(v_whd_widget,'height') then
            assign v_whd_widget:height = tt_maximizacao.height-original no-error.
    end.

end.

ON ENTRY OF wh_w_program DO:

    def var v_whd_field_group   as widget-handle no-undo.
    def var v_whd_widget        as widget-handle no-undo.
    def buffer b_tt_maximizacao for tt_maximizacao.

    find first tt_maximizacao no-error.
    if not avail tt_maximizacao then do:        
        assign v_whd_field_group = frame f_main:first-child.
        repeat while valid-handle(v_whd_field_group):
            assign v_whd_widget = v_whd_field_group:first-child.
            repeat while valid-handle(v_whd_widget):
                create tt_maximizacao.
                if can-query(v_whd_widget,'handle') then
                    assign tt_maximizacao.hdl-widget         = v_whd_widget:handle no-error.
                if can-query(v_whd_widget,'type') then
                    assign tt_maximizacao.tipo-widget        = v_whd_widget:type no-error.
                if can-query(v_whd_widget,'row') then
                    assign tt_maximizacao.row-original       = v_whd_widget:row no-error.
                if can-query(v_whd_widget,'col') then
                    assign tt_maximizacao.col-original       = v_whd_widget:col no-error.
                if can-query(v_whd_widget,'width') then
                    assign tt_maximizacao.width-original     = v_whd_widget:width no-error.
                if can-query(v_whd_widget,'height') then
                    assign tt_maximizacao.height-original    = v_whd_widget:height no-error.
                assign tt_maximizacao.frame-width-original   = frame f_main:width.
                assign tt_maximizacao.frame-height-original  = frame f_main:height.
                assign tt_maximizacao.window-width-original  = wh_w_program:width.
                assign tt_maximizacao.window-height-original = wh_w_program:height.
                assign tt_maximizacao.log-posiciona-row  = no.
                assign tt_maximizacao.log-posiciona-col  = no.
                assign tt_maximizacao.log-calcula-width  = no.
                assign tt_maximizacao.log-calcula-height = no.
                assign tt_maximizacao.log-button-right   = no.
                if can-query(v_whd_widget,'flat-button') then do:
                    if v_whd_widget:flat-button = yes then do:
                        assign tt_maximizacao.log-posiciona-col  = no.
                        if v_whd_widget:name = 'bt_exi' or
                           v_whd_widget:name = 'bt_hel1' then do:
                            assign tt_maximizacao.log-button-right = yes.
                        end.
                    end.
                end.
                if can-query(v_whd_widget,'type') then do:
                    if v_whd_widget:type = 'browse' then 
                        assign tt_maximizacao.log-calcula-height = yes.
                end.
                assign v_whd_widget = v_whd_widget:next-sibling.
            end.
            assign v_whd_field_group = v_whd_field_group:next-sibling.
        end.
    end.
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'browse'
          by tt_maximizacao.row-original:
        find first b_tt_maximizacao
             where b_tt_maximizacao.tipo-widget = 'browse'
               and b_tt_maximizacao.hdl-widget = tt_maximizacao.hdl-widget no-error.
        if avail b_tt_maximizacao then do:
            leave.
        end.
    end.
    if avail b_tt_maximizacao then do:
        for each tt_maximizacao
            where tt_maximizacao.row-original >=  b_tt_maximizacao.row-original + 
                                                  b_tt_maximizacao.height-original - 1:
            assign tt_maximizacao.log-calcula-height = no.
            assign tt_maximizacao.log-posiciona-row  = yes.
            assign tt_maximizacao.log-posiciona-col  = no.
        end.
    end.
    for each b_tt_maximizacao
        where b_tt_maximizacao.tipo-widget = 'browse':
        assign b_tt_maximizacao.log-calcula-width = yes.
        for each tt_maximizacao
            where tt_maximizacao.row-original + tt_maximizacao.height-original >= 
                  b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original 
              and tt_maximizacao.tipo-widget = 'rectangle'
              and b_tt_maximizacao.log-calcula-height = yes:
            assign tt_maximizacao.log-calcula-height = yes.
        end.
        for each tt_maximizacao
           where tt_maximizacao.tipo-widget <> 'browse'
             and not (    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                      and tt_maximizacao.row-original + tt_maximizacao.height-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original
                      and tt_maximizacao.col-original >= b_tt_maximizacao.col-original
                      and tt_maximizacao.col-original + tt_maximizacao.width-original < b_tt_maximizacao.col-original + b_tt_maximizacao.width-original )
             and ((    tt_maximizacao.row-original >= b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original < b_tt_maximizacao.row-original + b_tt_maximizacao.height-original - 0.5 )
              or (     tt_maximizacao.row-original < b_tt_maximizacao.row-original
                   and tt_maximizacao.row-original + tt_maximizacao.height-original > b_tt_maximizacao.row-original )):
            assign tt_maximizacao.log-posiciona-col = yes.
        end.
    end. 
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'rectangle':
        if tt_maximizacao.frame-width-original - tt_maximizacao.width-original < 4 then do:
            assign tt_maximizacao.log-posiciona-col  = NO
                   tt_maximizacao.log-calcula-width  = yes.
        end.
    end.
    for each tt_maximizacao
       where tt_maximizacao.tipo-widget = 'image':
        assign tt_maximizacao.log-posiciona-col  = NO
               tt_maximizacao.log-calcula-width  = NO.
    end.
    assign wh_w_program:MAX-WIDTH-CHARS  = 300 
           wh_w_program:max-height-chars = 300.

    if  valid-handle (wh_w_program)
    then do:
        assign current-window = wh_w_program:handle.
    END.

END. 
*/

ON WINDOW-CLOSE OF wh_w_program DO:

    apply "choose" to bt_exi in frame f_main.

END.

ON CHOOSE OF MENU-ITEM mi_param IN MENU m_main DO:

    APPLY "MOUSE-SELECT-CLICK" TO im_fld_1 IN FRAME f_main.

END.

ON CHOOSE OF MENU-ITEM mi_exi IN MENU m_main DO:

    APPLY "choose" TO bt_exi IN FRAME f_main.

END.

ON CHOOSE OF bt_exi IN FRAME f_main DO:

    ASSIGN v_log_repeat = NO.
    run pi_close_program.

END.

ON END-ERROR OF FRAME f_main DO:

    run pi_close_program.
    
END.

/*--- Main Code ---*/

// VERIFICA BASE LOGADA 

DEF VAR l-producao AS LOG NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

assign wh_w_program:title         = frame f_main:title
       frame f_main:title       = ?
       wh_w_program:width-chars   = frame f_main:width-chars
       wh_w_program:height-chars  = frame f_main:height-chars - 0.85
       frame f_main:row           = 1
       frame f_main:col           = 1
       wh_w_program:menubar       = menu m_main:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program
       v_wgh_focus                = br-int-ped-compr:HANDLE IN FRAME f_main
       v_cod_program              = "esccp055".    

ASSIGN frame f_faixa:frame   = FRAME f_main:HANDLE
       frame f_faixa:row     = 03.50 
       frame f_faixa:col     = 2.

RUN pi-usuar-reenvio (OUTPUT v-log-reenvio).

RUN pi_dwb_set_list_param.
PAUSE 0 BEFORE-HIDE.
VIEW FRAME f_main.

main_block:
DO WHILE v_log_repeat on endkey undo main_block, leave main_block
   on stop undo main_block, retry main_block 
   on error undo main_block, retry main_block with frame f_main:
   ENABLE ALL WITH FRAME f_main.
   DISPLAY v_label_1
           v_label_2
           v_label_3
           WITH FRAME f_main.
   
   APPLY "MOUSE-SELECT-CLICK" TO im_fld_1 IN FRAME f_main.

   IF VALID-HANDLE (v_wgh_focus) THEN DO:
      WAIT-FOR GO OF FRAME f_main FOCUS v_wgh_focus.
   END.
   ELSE DO:
       WAIT-FOR GO OF FRAME f_main.
   END.
   ASSIGN INPUT FRAME f_faixa v_cod_estab_ini
          INPUT FRAME f_faixa v_cod_estab_fim
          INPUT FRAME f_faixa v_cdn_fornec_ini
          INPUT FRAME f_faixa v_cdn_fornec_fim
          INPUT FRAME f_faixa v-num-pedido-ini
          INPUT FRAME f_faixa v-num-pedido-fim
          INPUT FRAME f_faixa v-cod-compr-ini
          INPUT FRAME f_faixa v-cod-compr-fim
          INPUT FRAME f_faixa v-dat-criac-ini
          INPUT FRAME f_faixa v-dat-criac-fim
          INPUT FRAME f_faixa v-dat-integr-ini
          INPUT FRAME f_faixa v-dat-integr-fim.
END.
RUN pi_salva_param.

HIDE FRAME f_main NO-PAUSE.

IF VALID-HANDLE (wh_w_program) THEN
    RUN pi_close_program.
    
PROCEDURE pi-usuar-reenvio:

    DEF OUTPUT PARAM p-log-reenvio AS LOG INIT NO NO-UNDO.

    blk_reenvio:
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "esccp055":U
          AND ponto-programa.ponto         = 1,
        EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:        
        IF conteudo-programa.conteudo = v_cod_usuar_corren THEN DO:
            ASSIGN p-log-reenvio = YES.
            LEAVE blk_reenvio.
        END.
    END.

END.

PROCEDURE pi_salva_param.

    do transaction:
        find emsfnd.dwb_set_list_param exclusive-lock
            where emsfnd.dwb_set_list_param.cod_dwb_program = "esccp055"
              and emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren no-error.
        if not avail emsfnd.dwb_set_list_param then do:
           create emsfnd.dwb_set_list_param.
           assign emsfnd.dwb_set_list_param.cod_dwb_program = "esccp055"
                  emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren.
        end.
        assign emsfnd.dwb_set_list_param.cod_dwb_parameters = v_cod_estab_ini            + chr(10) /* 01 */
                                                            + v_cod_estab_fim            + chr(10) /* 02 */
                                                            + STRING (v-num-pedido-ini)  + chr(10) /* 03 */
                                                            + STRING (v-num-pedido-fim)  + chr(10) /* 04 */
                                                            + STRING (v_cdn_fornec_ini)  + chr(10) /* 05 */
                                                            + STRING (v_cdn_fornec_fim)  + chr(10) /* 06 */
                                                            + v-cod-compr-ini            + chr(10) /* 07 */
                                                            + v-cod-compr-fim            + chr(10) /* 08 */
                                                            + STRING (v-dat-criac-ini)   + chr(10) /* 09 */
                                                            + STRING (v-dat-criac-fim)   + chr(10) /* 10 */
                                                            + STRING (v-dat-integr-ini)  + chr(10) /* 11 */
                                                            + STRING (v-dat-integr-fim)  + chr(10) /* 12 */.
    end.

end.

procedure pi_dwb_set_list_param:
    
    find emsfnd.dwb_set_list_param no-lock
        where emsfnd.dwb_set_list_param.cod_dwb_program = "esccp055"
          and emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren
        use-index dwbstlsa_id no-error.
    IF avail emsfnd.dwb_set_list_param then do:
       assign v_cod_estab_ini       = entry (01, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))
              v_cod_estab_fim       = entry (02, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))
              v-num-pedido-ini      = INT (entry (03, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v-num-pedido-fim      = INT (entry (04, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v_cdn_fornec_ini      = INT (entry (05, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v_cdn_fornec_fim      = INT (entry (06, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v-cod-compr-ini       = entry (07, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))
              v-cod-compr-fim       = entry (08, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))
              v-dat-criac-ini       = DATE (entry (09, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v-dat-criac-fim       = DATE (entry (10, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v-dat-integr-ini      = DATE (entry (11, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10)))
              v-dat-integr-fim      = DATE (entry (12, emsfnd.dwb_set_list_param.cod_dwb_parameters, chr(10))).
   END.

END.

PROCEDURE pi_opcao:
        
    ASSIGN br-es-api-log:VISIBLE IN FRAME f_main          = NO
           br-es-api-log:SENSITIVE IN FRAME f_main        = NO
           br-int-ped-compr:VISIBLE IN FRAME f_main       = NO
           br-int-ped-compr:SENSITIVE IN FRAME f_main     = NO
           br-int-mov-ped-compr:VISIBLE IN FRAME f_main   = NO
           br-int-mov-ped-compr:SENSITIVE IN FRAME f_main = NO
           bt-chamada:VISIBLE IN FRAME f_main             = NO
           bt-chamada:SENSITIVE IN FRAME f_main           = NO
           bt-retorno:VISIBLE IN FRAME f_main             = NO
           bt-retorno:SENSITIVE IN FRAME f_main           = NO
           bt-erros:VISIBLE IN FRAME f_main               = NO
           bt-erros:SENSITIVE IN FRAME f_main             = NO
           bt-record:VISIBLE IN FRAME f_main              = NO
           bt-record:SENSITIVE IN FRAME f_main            = NO
           bt-envio:VISIBLE IN FRAME f_main               = NO
           bt-envio:SENSITIVE IN FRAME f_main             = NO.           

    CASE v_cod_opcao:
        WHEN "Parƒmetros" THEN DO:
            RUN pi_faixa.
            ASSIGN FRAME f_faixa:VISIBLE = YES
                   v_log_pesq = YES.
            bt_atz:LOAD-IMAGE("image\toolbar\im-check.bmp") IN FRAME f_main. 
            ENABLE bt_atz WITH FRAME f_main.
            DISABLE im_fld_2 v_label_2 
                    im_fld_3 v_label_3
                    WITH FRAME f_main.
        END.
        WHEN "Pesquisa" THEN DO:
            ASSIGN FRAME f_faixa:VISIBLE  = NO
                   br-int-ped-compr:VISIBLE IN FRAME f_main       = YES
                   br-int-ped-compr:SENSITIVE IN FRAME f_main     = YES
                   br-int-mov-ped-compr:VISIBLE IN FRAME f_main   = YES
                   br-int-mov-ped-compr:SENSITIVE IN FRAME f_main = YES.
            //RUN pi_open_int-ped-compr.
            //APPLY "VALUE-CHANGED" TO br-int-ped-compr IN FRAME f_main.
        END.
        WHEN "Integra‡Æo" THEN DO:
            ASSIGN FRAME f_faixa:VISIBLE  = NO
                   bt-chamada:VISIBLE IN FRAME f_main             = YES
                   bt-chamada:SENSITIVE IN FRAME f_main           = YES
                   bt-envio:VISIBLE IN FRAME f_main               = YES
                   bt-envio:SENSITIVE IN FRAME f_main             = YES
                   bt-erros:VISIBLE IN FRAME f_main               = YES
                   bt-erros:SENSITIVE IN FRAME f_main             = YES
                   bt-record:VISIBLE IN FRAME f_main              = YES
                   bt-record:SENSITIVE IN FRAME f_main            = YES
                   bt-retorno:VISIBLE IN FRAME f_main             = YES
                   bt-retorno:SENSITIVE IN FRAME f_main           = YES
                   br-es-api-log:VISIBLE IN FRAME f_main          = YES
                   br-es-api-log:SENSITIVE IN FRAME f_main        = YES
                   br-int-ped-compr:VISIBLE IN FRAME f_main       = NO
                   br-int-ped-compr:SENSITIVE IN FRAME f_main     = NO
                   br-int-mov-ped-compr:VISIBLE IN FRAME f_main   = NO
                   br-int-mov-ped-compr:SENSITIVE IN FRAME f_main = NO.
            RUN pi-open-es-api-log.
            APPLY "entry" TO br-es-api-log IN FRAME f_main.
        END.

    END.

END.

/*
PROCEDURE pi-ind-status:

    DEFINE OUTPUT PARAM p-des-status AS CHAR NO-UNDO.

    FIND int-ped-compr NO-LOCK
        WHERE RECID (int-ped-compr) = v-rec-int-ped-compr NO-ERROR.
    IF NOT AVAIL int-ped-compr THEN
        RETURN.
    FIND LAST int-mov-ped-compr NO-LOCK 
        WHERE int-mov-ped-compr.num-pedido = int-ped-compr.num-pedido NO-ERROR.
    IF AVAIL int-mov-ped-compr THEN DO:
        CASE int-mov-ped-compr.ind-tip-movto:
            WHEN "10" THEN DO:                
                ASSIGN p-des-status = "Importado".
            END.
            WHEN "20" THEN DO:                
                ASSIGN p-des-status = "Pendente".
            END.            
            WHEN "30" THEN DO:
                ASSIGN p-des-status = "Aberto".                
            END.
            WHEN "40" THEN DO:                
                ASSIGN p-des-status = "Atendido Parcial".
            END.
            WHEN "50" THEN DO:
                ASSIGN p-des-status = "Encerrado".
            END.
        END.
    END.

END.
*/

PROCEDURE pi_faixa:
    
    if v-num-pedido-fim = 0 then
        assign v-num-pedido-fim = 9999999.
    IF  v-cod-compr-ini = ""
    AND v-cod-compr-fim = "" THEN
        ASSIGN v-cod-compr-ini = v_cod_usuar_corren
               v-cod-compr-fim = v_cod_usuar_corren.
    
    display v_cod_estab_ini 
            v_cod_estab_fim
            v-num-pedido-ini 
            v-num-pedido-fim
            v_cdn_fornec_ini
            v_cdn_fornec_fim
            v-cod-compr-ini
            v-cod-compr-fim
            v-dat-criac-ini
            v-dat-criac-fim
            v-dat-integr-ini
            v-dat-integr-fim
            with frame f_faixa.
    
    display v-log-naointegr
            v-log-integr
            v-log-process
            v-log-excluido
            v-log-revisao
            v-log-erro
            v-log-cancel
            with frame f_faixa.
    
    enable all with frame f_faixa.
    apply "entry" to v_cod_estab_ini in frame f_faixa.
    
    //wait-for go of frame f_faixa.
    ASSIGN INPUT FRAME f_faixa v_cod_estab_ini
           INPUT FRAME f_faixa v_cod_estab_fim
           INPUT FRAME f_faixa v-num-pedido-ini
           INPUT FRAME f_faixa v-num-pedido-fim
           INPUT FRAME f_faixa v_cdn_fornec_ini
           INPUT FRAME f_faixa v_cdn_fornec_fim
           INPUT FRAME f_faixa v-cod-compr-ini
           INPUT FRAME f_faixa v-cod-compr-fim
           INPUT FRAME f_faixa v-dat-criac-ini
           INPUT FRAME f_faixa v-dat-criac-fim
           INPUT FRAME f_faixa v-dat-integr-ini
           INPUT FRAME f_faixa v-dat-integr-fim.

    ASSIGN INPUT FRAME f_faixa v-log-naointegr
           INPUT FRAME f_faixa v-log-integr
           INPUT FRAME f_faixa v-log-process
           INPUT FRAME f_faixa v-log-excluido
           INPUT FRAME f_faixa v-log-revisao
           INPUT FRAME f_faixa v-log-erro
           INPUT FRAME f_faixa v-log-cancel.

end.

PROCEDURE pi_filtro:

    def rectangle rt_param
        size 55 by 3.60
        edge-pixels 2.
    
    def rectangle rt_cxft 
        size 55 by 1.50 
        edge-pixels 2.
    
    def button bt_can
        LABEL "&Cancela"
        tooltip "Cancela"
        size 10 by 1
        auto-endkey.
    
    def button bt_ok
        LABEL "&OK"
        tooltip "OK"
        size 10 by 1
        auto-go.
    
    def frame f_filtro
        rt_param
            at row 01.33 col 1.00 colon-aligned 
            fgcolor ? bgcolor 17
        " Status Integra‡Æo " view-as text
            at row 01.10 col 7.00
        v-log-naointegr
            at row 1.8 col 6.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-integr
            at row 1.8 col 25.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-excluido
            at row 1.8 col 42.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-process
            at row 2.8 col 6.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-cancel
            at row 2.8 col 25.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-revisao
            at row 3.8 col 6.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        v-log-erro
            at row 3.8 col 25.00 COLON-ALIGNED
            VIEW-AS TOGGLE-BOX
        rt_cxft
            at row 5.10 col 1.00 colon-aligned 
            fgcolor ? BGCOLOR 18
        bt_ok   at row 5.38 col 04.00 bgcolor 8 help "Fecha" 
        bt_can  at row 5.38 col 14.50 bgcolor 8 help "Cancela"     
        with 1 down side-LABELs no-validate keep-tab-order three-d 
              size-char 60.00 by 7.00 
              at row 01.13 col 01.00           
              font 1 fgcolor ? bgcolor 17 
              VIEW-AS DIALOG-BOX 
              title "Filtro - 12.00.00.000".
    
    on choose of bt_can in frame f_filtro do:
       return "error".
    end.

    on choose of bt_ok in frame f_filtro do:
       return "".
    end.
    
    enable all with frame f_filtro.
    
    display v-log-naointegr
            v-log-integr
            v-log-process
            v-log-excluido
            v-log-revisao
            v-log-erro
            v-log-cancel
            with frame f_filtro.
    apply "entry" to v-log-naointegr in frame f_filtro.

    
    wait-for go of frame f_filtro.
    ASSIGN INPUT FRAME f_filtro v-log-naointegr
           INPUT FRAME f_filtro v-log-integr
           INPUT FRAME f_filtro v-log-process
           INPUT FRAME f_filtro v-log-excluido
           INPUT FRAME f_filtro v-log-revisao
           INPUT FRAME f_filtro v-log-erro
           INPUT FRAME f_filtro v-log-cancel.
   
end.

PROCEDURE pi-gera-tt-ini-ped-compr:

    DEF VAR v-dat-aux AS DATE NO-UNDO.

    ASSIGN INPUT FRAME f_faixa v_cod_estab_ini
           INPUT FRAME f_faixa v_cod_estab_fim
           INPUT FRAME f_faixa v_cdn_fornec_ini
           INPUT FRAME f_faixa v_cdn_fornec_fim
           INPUT FRAME f_faixa v-num-pedido-ini
           INPUT FRAME f_faixa v-num-pedido-fim
           INPUT FRAME f_faixa v-cod-compr-ini
           INPUT FRAME f_faixa v-cod-compr-fim
           INPUT FRAME f_faixa v-dat-criac-ini
           INPUT FRAME f_faixa v-dat-criac-fim
           INPUT FRAME f_faixa v-dat-integr-ini
           INPUT FRAME f_faixa v-dat-integr-fim.

    EMPTY TEMP-TABLE tt-int-ped-compr.
    EMPTY TEMP-TABLE tt-int-mov-ped-compr.

    DO v-dat-aux = v-dat-criac-ini TO v-dat-criac-fim:
        ped_blk:
        FOR EACH pedido-compr NO-LOCK
            WHERE pedido-compr.data-pedido = v-dat-aux
              AND pedido-compr.num-pedido >= v-num-pedido-ini
              AND pedido-compr.num-pedido <= v-num-pedido-fim:
            IF pedido-compr.cod-estabel < v_cod_estab_ini
            OR pedido-compr.cod-estabel > v_cod_estab_fim THEN
                NEXT ped_blk.
            IF pedido-compr.cod-emitente < v_cdn_fornec_ini
            OR pedido-compr.cod-emitente > v_cdn_fornec_fim THEN
                NEXT ped_blk.
            IF pedido-compr.responsavel < v-cod-compr-ini
            OR pedido-compr.responsavel > v-cod-compr-fim THEN
                NEXT ped_blk.            
            RUN esp/ccp/esccp055r.p (INPUT NO,                 // Acompanhamento
                                     INPUT pedido-compr.num-pedido,
                                     INPUT "tt-int-ped-compr", // pi-cria-tt-int-ped-compr
                                     INPUT v-log-reenvio,      // Reenvio
                                     INPUT-OUTPUT TABLE tt-int-ped-compr).            
        END.        
    END.

END.

PROCEDURE pi-open-tt-int-ped-compr:
    
    EMPTY TEMP-TABLE tt-es-api-log.

    FOR EACH tt-int-ped-compr:
        // MESSAGE tt-int-ped-compr.des-situacao VIEW-AS ALERT-BOX.
        CASE tt-int-ped-compr.des-situacao:
            WHEN "NÆo Integrado" THEN DO:
                IF v-log-naointegr = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.            
            WHEN "Integrado" THEN DO:
                IF v-log-integr = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.            
            WHEN "Em Processamento" THEN DO:
                IF v-log-process = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.
            WHEN "Em RevisÆo" THEN DO:
                IF v-log-revisao = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.
            WHEN "Pedido Cancelado" THEN DO:
                IF v-log-cancel = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.
            WHEN "Erro Integra‡Æo" THEN DO:
                IF v-log-erro = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.
            WHEN "Registro Exclu¡do" THEN DO:
                IF v-log-excluido = NO THEN DO:
                    DELETE tt-int-ped-compr.
                    NEXT.
                END.
            END.
            OTHERWISE DO:
                DELETE tt-int-ped-compr.
            END.
        END CASE.
        FOR EACH int-mov-ped-compr NO-LOCK
            WHERE int-mov-ped-compr.id-ped-compr = tt-int-ped-compr.id-ped-compr
              AND int-mov-ped-compr.num-pedido   = tt-int-ped-compr.num-pedido:
            IF int-mov-ped-compr.id-api-log > 0 THEN DO:
                FIND FIRST es-api-log NO-LOCK
                    WHERE es-api-log.id-api-log = int-mov-ped-compr.id-api-log NO-ERROR.
                IF AVAIL es-api-log THEN DO:
                    FIND FIRST tt-es-api-log OF es-api-log NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-es-api-log THEN DO:
                        CREATE tt-es-api-log.
                        BUFFER-COPY es-api-log TO tt-es-api-log.
                        ASSIGN tt-es-api-log.rw-table   = ROWID (es-api-log)
                               tt-es-api-log.num-pedido = int-mov-ped-compr.num-pedido
                               tt-es-api-log.aux        = STRING (int-mov-ped-compr.num-pedido)
                               tt-int-ped-compr.des-status = es-api-log.cod-retorno.                       
                        FIND es-api-uri OF es-api-log NO-LOCK NO-ERROR.
                        IF AVAIL es-api-uri THEN
                            ASSIGN tt-es-api-log.nome = TRIM (es-api-uri.nome).
                        FIND FIRST pedido-compr NO-LOCK
                            WHERE pedido-compr.num-pedido = tt-es-api-log.num-pedido NO-ERROR.
                        IF AVAIL pedido-compr THEN
                            ASSIGN tt-es-api-log.rw-pedido = ROWID (pedido-compr).
                    END.                    
                    ELSE DO:
                        ASSIGN tt-int-ped-compr.des-status = es-api-log.cod-retorno.
                    END.
                 END.
            END.
        END.
    END.
    
    OPEN QUERY qr-int-ped-compr
        FOR EACH tt-int-ped-compr
            BY tt-int-ped-compr.id-ped-compr DESCENDING.

   // REPOSITION qr-int-ped-compr TO RECID v-rec-tt-int-ped-compr NO-ERROR.

END.

PROCEDURE pi-cria-int-mov-ped-compr:

    empty temp-table tt-int-mov-ped-compr.

    for each int-mov-ped-compr 
        WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
          AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido no-lock:
        create tt-int-mov-ped-compr.
        buffer-copy int-mov-ped-compr
            to tt-int-mov-ped-compr.
    end.

end.

PROCEDURE pi-open-int-mov-ped-compr:

    OPEN QUERY qr-int-mov-ped-compr
        FOR EACH tt-int-mov-ped-compr NO-LOCK
            BY tt-int-mov-ped-compr.dat-movto DESCENDING.

END.

PROCEDURE pi-del-int-ped-compr:

    DEF INPUT PARAM p-num-pedido AS INT NO-UNDO.

    DEF VAR v-num-seq-movto AS INT NO-UNDO.

    FIND FIRST int-ped-compr EXCLUSIVE-LOCK
         WHERE int-ped-compr.num-pedido = p-num-pedido NO-ERROR.
    IF AVAIL int-ped-compr THEN DO:
        FIND LAST int-mov-ped-compr EXCLUSIVE-LOCK
             WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
               AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
        IF AVAIL int-mov-ped-compr THEN
            ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
        ELSE
            ASSIGN v-num-seq-movto = 20.
        CREATE int-mov-ped-compr.
        ASSIGN int-ped-compr.ind-status        = 5 // "Registro Exclu¡do"
               int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
               int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
               int-mov-ped-compr.num-seq-movto = v-num-seq-movto
               int-mov-ped-compr.ind-tip-movto = "Registro Exclu¡do"
               int-mov-ped-compr.dat-movto     = TODAY
               int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
               int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
               int-mov-ped-compr.des-text-histor = "Pedido de Compras Exclu¡do: " + STRING (p-num-pedido).
    END.

END.

PROCEDURE pi-open-es-api-log:
    
    RUN pi-cria-ttRetorno.

    OPEN QUERY qr-es-api-log
        FOR EACH tt-es-api-log NO-LOCK,
           FIRST es-api-aplicacao NO-LOCK
              OF es-api-log,
           FIRST es-api-empresa   NO-LOCK
              OF es-api-log,
           FIRST es-api-URI       NO-LOCK
              OF es-api-log,
           FIRST ttRetorno OUTER-JOIN
           WHERE SUBSTR (ttRetorno.Retorno,1,3) = tt-es-api-log.cod-retorno
              BY tt-es-api-log.id-api-log DESCENDING.

END.

PROCEDURE pi-cria-ttRetorno:
   
   DEF VAR i AS i NO-UNDO.
   DEF VAR r AS c NO-UNDO.

   EMPTY TEMP-TABLE ttRetorno.

   ASSIGN r = "    None                    ,"
            + "200 Ok                      ,"
            + "201 Created                 ,"
            + "202 Accepted                ,"
            + "204 No Content              ,"
            + "400 Bad Request             ,"
            + "401 Unauthorized            ,"
            + "403 Forbidden               ,"
            + "404 Not Found               ,"
            + "405 Method not Allowed      ,"
            + "413 Request Entity Too large,"
            + "422 Unprocessable Entity    ,"
            + "429 Too many requests       ,"
            + "500 Internal Server Error   ,"
            + "502 Bad Gateway             ,"
            + "504 Gateway Timeout         ,".
   DO i = 1 TO NUM-ENTRIES(r):
      CREATE ttRetorno.
      ASSIGN ttRetorno.Retorno = ENTRY(i,r).
   END.
  
END.

PROCEDURE OpenDocument:

    def input param c-doc as char  no-undo.
    def var c-exec as char  no-undo.
    def var h-Inst as int  no-undo.

    assign c-exec = fill("x",255).
    run FindExecutableA (input c-doc,
                         input "",
                         input-output c-exec,
                         output h-inst).

    if h-inst >= 0 and h-inst <=32 then
      run ShellExecuteA (input 0,
                         input "open",
                         input "rundll32.exe",
                         input "shell32.dll,OpenAs_RunDLL " + c-doc,
                         input "",
                         input 1,
                         output h-inst).

    run ShellExecuteA (input 0,
                       input "open",
                       input c-doc,
                       input "",
                       input "",
                       input 1,
                       output h-inst).

    if h-inst < 0 or h-inst > 32 then return "OK".
    else return "NOK".

END.

PROCEDURE FindExecutableA EXTERNAL "Shell32.dll" persistent:

    define input parameter lpFile as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input-output parameter lpResult as char  no-undo.
    define return parameter hInstance as long.

END.

PROCEDURE ShellExecuteA EXTERNAL "Shell32.dll" persistent:

    define input parameter hwnd as long.
    define input parameter lpOperation as char  no-undo.
    define input parameter lpFile as char  no-undo.
    define input parameter lpParameters as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input parameter nShowCmd as long.
    define return parameter hInstance as long.

END PROCEDURE.

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes then do:
        delete procedure this-procedure.
    end.

END PROCEDURE.

function fcFormatJson returns longchar ( lcJson as longchar ):

  define variable myParser as ObjectModelParser no-undo.
  define variable oJson    as JsonObject        no-undo.

  lcJson = CODEPAGE-CONVERT(lcJson, "UTF-8":U).
  myParser = NEW ObjectModelParser().
  oJson = cast(myParser:Parse(lcJson), JsonObject).
  oJson:write(input-output lcJson, true).  
  return lcJson.

end function.

