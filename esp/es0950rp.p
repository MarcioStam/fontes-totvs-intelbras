/***********************************************************************
**  Programa..: esp/es0950rp.p
**  Autor.....: Fabiano Zarpe Henke
**  Data......: 26/10/2012
**  Descricao.: Extraá∆o dos movimentos
************************************************************************/

/****************************  Definitions  ****************************/
{esp/es0950tt.i}
{esp/es0018.i} 

/****************************  Variaveis    ****************************/
/********************* Temporary Table Definition Begin **********************/

DEF TEMP-TABLE tt-dados
    FIELD cod_empresa           AS CHAR FORMAT "x(3)"
    FIELD cod_estab             AS CHAR
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL, CMG, APL, FAS, FTP ou CEP ***/
    FIELD ind_natur_lancto_ctbl AS CHAR FORMAT "X(3)"   /**** DB ou CR ***/
    FIELD cod_emitente          AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente         AS CHAR FORMAT "X(40)"
    FIELD dt_transacao          AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto       AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto         AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap            AS CHAR FORMAT "x(10)"
    FIELD cod_parcela           AS CHAR FORMAT "x(2)"
    FIELD nat-operacao          LIKE movto-estoq.nat-operacao
    FIELD val_aprop_ctbl        AS DEC  FORMAT ">>>,>>>,>>9.99"
    FIELD cod_cta_ctbl          AS CHAR
    FIELD cod_ccusto            AS CHAR
    FIELD cod_cenar_ctbl        AS CHAR
    FIELD cod_unid_negoc        AS CHAR
    FIELD des_lancto            AS CHAR
    FIELD dat_vencto            AS DATE FORMAT "99/99/9999"
    FIELD dat_vencto_origin     AS DATE FORMAT "99/99/9999"
    FIELD dat_prev_pagto        AS DATE FORMAT "99/99/9999"
    FIELD cod_grp               AS CHAR FORMAT "x(4)"
    FIELD dat_emis_docto        AS DATE FORMAT "99/99/9999"
    FIELD cod_indic_econ        AS CHAR FORMAT "x(8)"
    FIELD ind_trans             AS CHAR FORMAT "x(29)"
    FIELD des_item              AS CHAR
    FIELD it_codigo             AS CHAR
    FIELD cod_depos             AS CHAR
    FIELD quantidade            AS DEC  FORMAT ">>>>,>>>,>>9.9999"
    FIELD cod_portador          AS CHAR FORMAT "x(5)"
    FIELD cod_carteira          AS CHAR FORMAT "x(3)"
    FIELD val_cotac_indic_econ  AS DEC  FORMAT ">>>>,>>9.9999999999" DECIMALS 10
    FIELD cod_usuar_ult_atualiz AS CHAR FORMAT "x(12)"
    FIELD dat_ult_atualiz       AS DATE
    FIELD hra_ult_atualiz       AS CHAR FORMAT "99:99:99"
    FIELD tta_cod_cta_pat       AS CHAR
    FIELD tta_num_bem_pat       AS INT
    FIELD tta_num_seq_bem_pat   AS INT
    FIELD vida_util             AS DEC
    FIELD fornecedor            AS INT
    FIELD cod_docto_entr        AS CHAR
    FIELD cod_ser_docto_entr    AS CHAR
    FIELD parcela               AS INT
    FIELD tot-parcela           AS INT
    FIELD saldo                 AS DEC
    FIELD IECFOAT               AS CHAR
    FIELD cod_tribut            AS INT
    FIELD nf-desp-aces          LIKE despesa-aces.nro-docto
    FIELD serie-desp            LIKE despesa-aces.serie-doc
    FIELD nat-oper-desp         LIKE despesa-aces.nat-operacao
    FIELD vlr-desp-aces         LIKE despesa-aces.valor
    FIELD uf_emitente           LIKE emitente.estado
    FIELD log_contabilizado     AS LOG
    FIELD tipo-acordo-descricao AS CHAR FORMAT "x(40)"
    FIELD requisitante          AS CHAR FORMAT "x(40)"
    FIELD dt-venc-icms          AS DATE FORMAT "99/99/9999" 
    FIELD num-sat               AS DEC FORMAT ">>>>>>>>>>>>>>>9"
    FIELD des_motiv_desmob      LIKE motiv_desmob.des_motiv_desmob
    FIELD num-pedido            LIKE item-doc-est.num-pedido
    FIELD num-lancto            AS INT64
    FIELD num-lote              AS CHAR
    FIELD NF-Item-Orig-Frete    AS CHAR 
    FIELD Orig-Frete-nota       AS CHAR
    FIELD Orig-Frete-serie      AS CHAR 
    FIELD Orig-Frete-emit       AS INT 
    FIELD Orig-Frete-cfop       AS CHAR 
    FIELD Orig-Frete-seq        AS INT 
    FIELD Val-Item-Orig-Frete   AS DEC
    FIELD Orig-Dt-Emis          LIKE nota-fiscal.dt-emis-nota
    FIELD Orig-UF-Dest          LIKE nota-fiscal.estado.

def temp-table tt_converter_finalid_econ_apl no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transaá∆o" column-label "Transaá∆o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Projeá∆o" column-label "G/P Projeá∆o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers∆o" column-label "Forma Convers∆o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros_apl_1              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm_apl                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".


/********************** Temporary Table Definition End **********************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_cta_ctbl_ini  AS CHARACTER   FORMAT "99999999"   NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl_fim  AS CHARACTER   FORMAT "99999999"   NO-UNDO.
DEFINE VARIABLE v_data_ini          AS DATE        FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE v_data_fim          AS DATE        FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE v_cod_arquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-data              AS DATE        NO-UNDO.
DEFINE VARIABLE v_val_aprop_ctbl    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_ccusto        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_unid_negoc    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_vencto        AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE v_dat_vencto_origin AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_prev_pagto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_emis_docto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_alter         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_venc_icms     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_hr_alter          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_val_cotac         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_nom_usuar         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-it-codigo-ini     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-it-codigo-fim     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-estoque           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_ccusto_ini        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_ccusto_fim        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_estab_ini         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_estab_fim         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ACR               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-APB               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-APL               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-CEP               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-CMG               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-FAS               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-FGL               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-FTP               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-of                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-33                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-desc-sit          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-requisitante      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_cenar_ctbl    AS CHARACTER   NO-UNDO.


DEF VAR i-cont-fedex AS INT INIT 0 NO-UNDO.
DEF VAR c-hist-aux   AS CHAR       NO-UNDO.
DEF VAR c-num-fedex  AS CHAR       NO-UNDO.
DEF VAR i-tamanho    AS INT        NO-UNDO.
DEF VAR l-cta-db     AS LOG        NO-UNDO.
DEF VAR l-cta-cr     AS LOG        NO-UNDO.
DEF VAR c-nota       AS CHAR       NO-UNDO.
DEF VAR c-serie      AS CHAR       NO-UNDO.
DEF VAR c-emit       AS CHAR       NO-UNDO.
DEF VAR c-cfop       AS CHAR       NO-UNDO.
DEF VAR c-seq        AS CHAR       NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE l-despesa AS LOGICAL INITIAL YES
     LABEL "Somente Contas de Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE l-previa AS LOGICAL INITIAL no 
     LABEL "PrÇvia" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

/************************** Variable Definition End *************************/

DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.
DEF BUFFER b_aprop_ctbl_ap    FOR aprop_ctbl_ap.
DEF BUFFER b_movto_tit_ap_aux FOR movto_tit_ap.

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

/* ***************************  Main Block  *************************** */
do on stop undo, leave:

   IF OPSYS = "unix" THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.

       RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).

       FOR FIRST tt-prog-ponto:

           ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).

       END.

       ASSIGN tt-param.arquivo = c-dir-saida + "/":U + tt-param.usuario + "/":U + tt-param.arquivo.

   END.

END.



run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").
output stream s_1 to value(tt-param.arquivo) convert target 'iso8859-1'.
RUN piImprimeRelat. 
output stream s_1 close.

/* ** Imprime p†gina de parÉmetros ***/
ASSIGN v_cod_arquivo = ENTRY(1, tt-param.arquivo, ".") + ".LOG".

output stream s_1 to value(v_cod_arquivo) convert target 'iso8859-1'.
PUT stream s_1 UNFORMATTED "Faixa Estab: " v_estab_ini " ATê " v_estab_fim SKIP     
                           "Faixa Datas: " v_data_ini  " ATê " v_data_fim  SKIP     
                           "Faixa Conta Contabil: " v_cod_cta_ctbl_ini " ATê " v_cod_cta_ctbl_fim SKIP
                           "Faixa CCusto:  " v_ccusto_ini " ATê " v_ccusto_fim    SKIP 
                           "Faixa ITEM: " v-it-codigo-ini " ATê " v-it-codigo-fim SKIP
                           "Somente Despesa: " l-despesa    SKIP     
                           "PrÇvia: " l-previa              SKIP
                           "Por ITEM: " l-estoque           SKIP
                           "ACR: " l-ACR                    SKIP
                           "APB: " l-APB                    SKIP
                           "APL: " l-APL                    SKIP
                           "CEP: " l-CEP                    SKIP
                           "OFP: " l-of                     SKIP
                           "CMG: " l-CMG                    SKIP
                           "FAS: " l-FAS                    SKIP
                           "FGL: " l-FGL                    SKIP
                           "FTP: " l-FTP                    SKIP
                           "EspÇcie 33: " l-33              SKIP
                           "Usu†rio: " tt-param.usuario     SKIP
                           "Data: " TODAY                   SKIP
                           "Hora: " STRING(TIME,"HH:MM:SS") SKIP
                           "Arquivo Gerado: " tt-param.arquivo.
output stream s_1 close.

run pi-finalizar in h-acomp.  

RETURN "OK".



/* **********************  Internal Procedures  *********************** */


PROCEDURE piImprimeRelat:
        DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
        ASSIGN v_cod_cta_ctbl_ini = tt-param.ini-conta
               v_cod_cta_ctbl_fim = tt-param.fim-conta
               v_data_ini         = tt-param.ini-data
               v_data_fim         = tt-param.fim-data
               l-despesa          = tt-param.l-despesa
               l-previa           = tt-param.l-previa
               v-it-codigo-ini    = tt-param.ini-item
               v-it-codigo-fim    = tt-param.fim-item
               l-estoque          = IF v-it-codigo-ini <> "" OR v-it-codigo-fim <> "ZZZZZZZZZZZZZZZZ" THEN YES ELSE NO
               v_ccusto_ini       = tt-param.ini-ccusto
               v_ccusto_fim       = tt-param.fim-ccusto
               v_estab_ini        = tt-param.ini-estab
               v_estab_fim        = tt-param.fim-estab
               l-ACR              = tt-param.l-ACR
               l-APB              = tt-param.l-APB
               l-APL              = tt-param.l-APL
               l-CEP              = tt-param.l-CEP
               l-of               = tt-param.l-of
               l-CMG              = tt-param.l-CMG
               l-FAS              = tt-param.l-FAS
               l-FGL              = tt-param.l-FGL
               l-FTP              = tt-param.l-FTP
               l-33               = tt-param.l-33
               v_cod_cenar_ctbl   = tt-param.cod_cenar_ctbl.

        for each tt-dados:
            delete tt-dados.
        end.

        run pi-acompanhar in h-acomp (input "Ler Lancto Conta").
        FOR EACH cta_ctbl NO-LOCK
           WHERE cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
             AND cta_ctbl.cod_cta_ctbl       >= v_cod_cta_ctbl_ini
             AND cta_ctbl.cod_cta_ctbl       <= v_cod_cta_ctbl_fim:

           run pi-acompanhar in h-acomp (input "Lendo Lancto Conta: " + cta_ctbl.cod_cta_ctbl).
        
           IF l-despesa = YES 
           THEN DO:
                IF cta_ctbl.cod_cta_ctbl < "40000000"
                OR cta_ctbl.cod_cta_ctbl > "41999999"
                   THEN NEXT.
           END.
        
           RUN pi_leitura_lancto (INPUT cta_ctbl.cod_cta_ctbl,
                                  INPUT-OUTPUT TABLE tt-dados).
        END.

        /** obrigaá‰es fiscais */

        IF  l-of = YES THEN DO:

            run pi-acompanhar in h-acomp (input "Ler OF").
            FOR EACH estabelec NO-LOCK
                 WHERE estabelec.cod-estabel >= v_estab_ini
                   AND estabelec.cod-estabel <= v_estab_fim:

                FIND FIRST estabelecimento
                    WHERE estabelecimento.cod_estab = estabelec.cod-estabel NO-LOCK NO-ERROR.

                IF  NOT AVAIL estabelecimento THEN
                    NEXT.

                DO i-data = v_data_ini TO v_data_fim:

                    run pi-acompanhar in h-acomp (input "Lendo OF Dia: " + STRING(i-data,"99/99/9999")).

                    FOR EACH doc-fiscal
                        WHERE doc-fiscal.cod-estab = estabelec.cod-estabel
                        AND   doc-fiscal.dt-docto  = i-data
                      //  AND doc-fiscal.nr-doc-fis = "0369802"
                        NO-LOCK:
                        
                        IF  doc-fiscal.ind-sit-doc <> 1 THEN 
                            NEXT.

                        FIND emitente
                            WHERE emitente.cod-emit = doc-fiscal.cod-emit
                            NO-LOCK NO-ERROR.

                        FOR EACH it-doc-fisc  OF doc-fiscal
                            WHERE it-doc-fisc.it-codigo >= v-it-codigo-ini
                              AND it-doc-fisc.it-codigo <= v-it-codigo-fim
                            NO-LOCK:

/*                             FIND movto-estoq                                                   */
/*                                 where movto-estoq.cod-estabel  = it-doc-fisc.cod-estabel       */
/*                                 and   movto-estoq.serie-docto  = it-doc-fisc.serie             */
/*                                 and   movto-estoq.nro-docto    = it-doc-fisc.nr-doc-fis        */
/*                                 and   movto-estoq.cod-emitente = doc-fiscal.cod-emitente       */
/*                                 and   movto-estoq.nat-operacao = it-doc-fisc.nat-oper          */
/*                                 AND   movto-estoq.num-sequen   = it-doc-fisc.nr-seq-doc        */
/*                                 NO-LOCK NO-ERROR.                                              */
/*                                                                                                */
/*                             find item                                                          */
/*                                 WHERE item.it-codigo = movto-estoq.it-codigo no-lock no-error. */
                                
                            IF  it-doc-fisc.vl-icmsub-it > 0 THEN DO:

                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.origem                = "MOF"
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.vl-icmsub-it
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-icmsub-ft,1,8) ELSE substr(estabelec.conta-icms,1,8)        
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-icmsub-ft,9,8) ELSE substr(estabelec.conta-icms,9,8)        
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "ICMS ST"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */

                                RUN pi-desp-asc.
                                
                            END.
                            IF  it-doc-fisc.vl-ipi-it > 0 THEN DO:
                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.origem                = "MOF"
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.vl-ipi-it
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-ipi-fat,1,8) ELSE substr(estabelec.conta-ipi,1,8) 
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-ipi-fat,9,8) ELSE substr(estabelec.conta-ipi,9,8) 
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "IPI"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */
                                RUN pi-desp-asc.
                            END.
                            IF  it-doc-fisc.vl-icms-it > 0 THEN DO:
                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.origem                = "MOF"
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.vl-icms-it
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-icms-ft,1,8) ELSE substr(estabelec.conta-icms,1,8)     
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN substr(estabelec.conta-icms-ft,9,8) ELSE substr(estabelec.conta-icms,9,8)     
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "ICMS"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */
                                RUN pi-desp-asc.
                            END.
                            IF it-doc-fisc.val-pis > 0 THEN DO:
                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.origem                = "MOF"
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.val-pis
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.ct-pis ELSE estabelec.cod-cta-pis-recup     
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.sc-pis ELSE estabelec.cod-ccusto-pis-recup     
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "PIS"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */
                                RUN pi-desp-asc.

                                IF SUBSTRING(it-doc-fisc.nat-oper,1,4) = "8000" THEN DO:
                                    ASSIGN tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "DB" ELSE "CR".
                                END.

                            END.
                            IF it-doc-fisc.val-cofins > 0 THEN DO:
                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.origem                = "MOF"
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.val-cofins
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.ct-fins-pg ELSE estabelec.cod-cta-cofins-recup
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.sc-fins-pg ELSE estabelec.cod-ccusto-cofins-recup
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "COFINS"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */
                                RUN pi-desp-asc.

                                IF SUBSTRING(it-doc-fisc.nat-oper,1,4) = "8000" THEN DO:
                                    ASSIGN tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "DB" ELSE "CR".
                                END.

                            END.

                            IF it-doc-fisc.vl-iss-it > 0 THEN DO:
                                CREATE tt-dados.
                                ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                       tt-dados.cod_estab             = doc-fiscal.cod-estab
                                       tt-dados.cod_tribut            = it-doc-fisc.cd-trib-icm
                                       tt-dados.origem                = "MOF"
                                       tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "CR" ELSE "DB"
                                       tt-dados.dt_transacao          = doc-fiscal.dt-docto
                                       tt-dados.val_aprop_ctbl        = it-doc-fisc.vl-iss-it
                                       tt-dados.cod_cta_ctbl          = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.ct-iss ELSE "11410045"
                                       tt-dados.cod_ccusto            = IF doc-fiscal.ind-ori-doc = 1 THEN estabelec.sc-iss ELSE ""
                                       tt-dados.cod_unid_negoc        = ""
                                       tt-dados.des_lancto            = ""
                                       tt-dados.cod_emitente          = it-doc-fisc.cod-emitente
                                       tt-dados.nome_emitente         = emitente.nome-emit
                                       tt-dados.cod_espec_docto       = "ISS"
                                       tt-dados.cod_ser_docto         = doc-fiscal.serie
                                       tt-dados.cod_tit_ap            = doc-fiscal.nr-doc-fis
                                       tt-dados.nat-operacao          = it-doc-fisc.nat-oper
                                       tt-dados.cod_parcela           = ""
                                       tt-dados.val_cotac_indic_econ  = 0
                                       tt-dados.cod_usuar_ult_atualiz = ""
                                       tt-dados.dat_ult_atualiz       = ?
                                       tt-dados.hra_ult_atualiz       = ""
                                       tt-dados.uf_emitente           = emitente.estado
                                       tt-dados.num-lancto            = RECID(doc-fiscal)
                                       tt-dados.num-lote              = "0".

                                /*
                                RUN pi-verifica-nf-frete(INPUT doc-fiscal.cod-estabel,
                                                         INPUT it-doc-fisc.nr-doc-fis,   
                                                         INPUT it-doc-fisc.serie,        
                                                         INPUT it-doc-fisc.cod-emitente,
                                                         INPUT it-doc-fisc.it-codigo,    
                                                         INPUT it-doc-fisc.nr-seq-doc).
                                */
                                RUN pi-desp-asc.

                                IF SUBSTRING(it-doc-fisc.nat-oper,1,4) = "8000" THEN DO:
                                    ASSIGN tt-dados.ind_natur_lancto_ctbl = IF doc-fiscal.tipo-nat    = 2 THEN "DB" ELSE "CR".
                                END.

                            END.
                        END.
                    END.
                END.
            END.
        END.

        /* ** Movimentaá‰es do Estoque ***/
        IF l-CEP = YES THEN DO:

             run pi-acompanhar in h-acomp (input "Ler Movto Estoque").
             DEF VAR c-tipo-acordo-cep LIKE tipo-acordo.descricao NO-UNDO.
             DEF VAR c-des_lancto      AS CHAR NO-UNDO.

             FOR EACH estabelec NO-LOCK
                 WHERE estabelec.cod-estabel >= v_estab_ini
                   AND estabelec.cod-estabel <= v_estab_fim:
     
                 FIND FIRST estabelecimento
                     WHERE estabelecimento.cod_estab = estabelec.cod-estabel NO-LOCK NO-ERROR.

                 IF  NOT AVAIL estabelecimento THEN
                     NEXT.

                 DO i-data = v_data_ini TO v_data_fim:

                     run pi-acompanhar in h-acomp (input "Lendo Movto Estoque Dia: " + STRING(i-data,"99/99/9999")).

                     /* ** Movimento com base na movto-estoq.ct-codigo ***/
                     FOR EACH movto-estoq FIELDS (dt-trans esp-docto usuario serie-docto it-codigo quantidade nro-docto 
                                                  valor-mob-m valor-ggf-m cod-emitente tipo-trans ct-codigo ct-saldo valor-pis val-cofins valor-icm valor-ipi 
                                                  valor-mat-m cod-estabel descricao-db nat-operacao sequen-nf sc-codigo cod-depos usuario dt-criacao hr-trans 
                                                  valor-nota cod-unid-negoc valor-iss contabilizado sc-saldo) NO-LOCK
                        WHERE movto-estoq.cod-estabel  = estabelec.cod-estabel
                           /*
                           AND movto-estoq.serie-docto = "1"
                           AND movto-estoq.cod-emitente = 344511
                           AND movto-estoq.nro-docto  = "0015528":
                           */
                          AND movto-estoq.dt-trans     = i-data
                          AND movto-estoq.it-codigo   >= v-it-codigo-ini
                          AND movto-estoq.it-codigo   <= v-it-codigo-fim:

                          /* ** Execuá∆o oficial deve desconsiderar os movimentos n∆o contabilizados ***
                          IF  l-previa                   = NO
                          AND movto-estoq.contabilizado <> YES 
                              THEN NEXT. ***/

                          IF  movto-estoq.esp-docto = 33
                          AND l-33 = NO
                              THEN NEXT.

                          /*Buscar requisitante*/
                          ASSIGN c-requisitante = "".

                          IF movto-estoq.esp-docto = 28 OR movto-estoq.esp-docto = 30
                          THEN DO:
                              FIND requisicao NO-LOCK
                                    WHERE requisicao.nr-requisicao = INT(movto-estoq.nro-docto) NO-ERROR.
                              IF  AVAIL requisicao THEN DO:
                                  FIND usuar_mestre NO-LOCK
                                       WHERE usuar_mestre.cod_usuar = requisicao.nome-abrev NO-ERROR.
                                  IF  AVAIL usuar_mestre THEN
                                      ASSIGN  c-requisitante = usuar_mestre.nom_usuar.
                              END.
                          END.

                          /* Buscar o Tipo de Acordo quando espÇcie for Nota de Sa°da */
                          ASSIGN c-tipo-acordo-cep = ""
                                 c-des_lancto      = "".
                          IF  movto-estoq.esp-docto = 22 THEN DO:
                              FIND FIRST pagto-vpc NO-LOCK
                                  WHERE pagto-vpc.cod-estab-nf   = movto-estoq.cod-estabel
                                    AND pagto-vpc.nr-nota-fis    = movto-estoq.nro-docto
                                    AND pagto-vpc.serie          = movto-estoq.serie-docto NO-ERROR.
    
                              IF  AVAIL pagto-vpc THEN DO:
                                  FIND vpc NO-LOCK
                                      WHERE vpc.nr-vpc = pagto-vpc.nr-vpc NO-ERROR.
                                  IF  AVAIL vpc THEN DO:
                                      ASSIGN c-des_lancto = TRIM(vpc.observacoes).
                                      FIND tipo-acordo NO-LOCK
                                          WHERE tipo-acordo.codigo = vpc.tipo-acordo NO-ERROR.
                                      IF  AVAIL tipo-acordo THEN
                                          ASSIGN c-tipo-acordo-cep = tipo-acordo.descricao.
                                  END.
                              END.
                          END.

                          /* ** Movimento com base na movto-estoq.ct-codigo ***/
                          IF  movto-estoq.ct-codigo >= (v_cod_cta_ctbl_ini)
                          AND movto-estoq.ct-codigo <= (v_cod_cta_ctbl_fim)
                          THEN DO:
                               IF l-despesa = YES 
                               THEN DO:
                                    IF movto-estoq.ct-codigo < "40000000"
                                    OR movto-estoq.ct-codigo > "41999999"
                                       THEN NEXT.
                               END. 

                               CREATE tt-dados.
                               ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                      tt-dados.cod_estab             = movto-estoq.cod-estabel
                                      tt-dados.origem                = "CEP"
                                      tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"
                                      tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                      tt-dados.dt_transacao          = movto-estoq.dt-trans
                                      tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                      tt-dados.cod_ser_docto         = movto-estoq.serie
                                      tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                      tt-dados.cod_parcela           = "0"
                                      tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                      tt-dados.val_aprop_ctbl        = IF movto-estoq.valor-nota > 0
                                                                          THEN movto-estoq.valor-nota
                                                                          ELSE (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1])
                                      tt-dados.cod_cta_ctbl          = movto-estoq.ct-codigo
                                      tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                                      tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                      tt-dados.cod_depos             = movto-estoq.cod-depos
                                      tt-dados.quantidade            = movto-estoq.quantidade
                                      tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                      tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                      tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans
                                      tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                      tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                      tt-dados.requisitante          = c-requisitante
                                      tt-dados.num-lancto            = RECID(movto-estoq)
                                      tt-dados.num-lote              = "0".

                               /*
                               RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                        INPUT movto-estoq.nro-docto,   
                                                        INPUT movto-estoq.serie-docto,        
                                                        INPUT movto-estoq.cod-emitente,
                                                        INPUT movto-estoq.it-codigo,    
                                                        INPUT movto-estoq.sequen-nf).
                               */
    
                               /* ** Ajustes conforme natureza do lanáamento - INICIO ***/
                               IF movto-estoq.ct-codigo BEGINS "4" 
                               THEN DO:
                                    IF movto-estoq.valor-nota > 0 AND
                                      (movto-estoq.valor-ipi  > 0  OR movto-estoq.valor-icm  > 0 OR movto-estoq.valor-pis > 0 OR movto-estoq.val-cofins > 0) /* logica ce0421rp */
                                      THEN ASSIGN tt-dados.val_aprop_ctbl = movto-estoq.valor-nota.
                                      ELSE ASSIGN tt-dados.val_aprop_ctbl = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]).
                               END.
                               
                               IF movto-estoq.ct-codigo BEGINS "1" /* logica CE0403.i6 */
                                  THEN ASSIGN tt-dados.val_aprop_ctbl = movto-estoq.valor-ggf-m[1] + movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-icm + movto-estoq.valor-ipi + movto-estoq.valor-iss + movto-estoq.valor-pis + movto-estoq.val-cofins.
                               /* ** Ajustes conforme natureza do lanáamento - FIM ***/

                               IF tt-dados.cod_unid_negoc <> "" 
                               THEN DO:
                                    FIND unid_negoc NO-LOCK
                                       WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                    IF AVAIL unid_negoc 
                                       THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                               END.
    
                               IF  tt-dados.val_aprop_ctbl = 0
                               AND l-previa
                               THEN DO:
                                    find item-estab no-lock
                                         where item-estab.cod-estabel = movto-estoq.cod-estabel
                                           and item-estab.it-codigo   = movto-estoq.it-codigo no-error.
    
                                    if avail item-estab then
                                        assign tt-dados.val_aprop_ctbl = movto-estoq.quantidade * 
                                                                        (item-estab.val-unit-mat-m[1]
                                                                        + item-estab.val-unit-mob-m[1]
                                                                        + item-estab.val-unit-ggf-m[1] ).
                               END.
                
                               FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.
    
                               ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                      tt-dados.des_item  = ITEM.desc-item.
    
                               IF movto-estoq.cod-emitente <> 0 
                               THEN DO:
                                    FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.
    
                                    IF AVAIL emitente 
                                       THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                   tt-dados.uf_emitente = emitente.estado.
    
                               END.
                               ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.
    
                               find item-doc-est no-lock
                                    where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                    and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                    and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                    and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                    and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                                
                               if  avail item-doc-est then DO:
                                   assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                          tt-dados.des_lancto    = item-doc-est.narrativa
                                          tt-dados.nat-operacao  = item-doc-est.nat-of.

                                   /* Desmenbra Narrativa - 18/07/2023 */
                                   RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                   IF  item-doc-est.num-pedido <> 0 THEN DO:
    
                                       FIND FIRST ordem-compra 
                                           WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
    
                                       IF  AVAIL ordem-compra THEN DO:
                                           IF  tt-dados.requisitante = "" THEN DO:                                           
                                               FIND usuar_mestre NO-LOCK
                                                    WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.
                                               
                                               IF  AVAIL usuar_mestre THEN
                                                   ASSIGN  c-requisitante = usuar_mestre.nom_usuar.
        
                                               ASSIGN tt-dados.requisitante = c-requisitante.
                                           END.
                                       END.

                                       ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                   END.
                                   ELSE DO:
                                       FIND FIRST rat-ordem
                                          WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                          AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                          AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                          AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                          AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                       IF  AVAIL rat-ordem THEN DO:
                                           FIND FIRST ordem-compra 
                                               WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.
        
                                           IF  AVAIL ordem-compra THEN DO:
                                               IF  tt-dados.requisitante = "" THEN DO:
                                                   FIND usuar_mestre NO-LOCK
                                                        WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.
                                                   
                                                   IF  AVAIL usuar_mestre THEN
                                                       ASSIGN  c-requisitante = usuar_mestre.nom_usuar.
            
                                                   ASSIGN tt-dados.requisitante = c-requisitante.
                                               END.                                                      
                                           END.

                                           ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                       END.
                                   END.
                               END.

                               IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                        movto-estoq.esp-docto      = 6
                               THEN
                                   ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                               ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + c-des_lancto.
                          END.

                          /* ** Movimento com base na movto-estoq.ct-saldo ***/
                          IF  movto-estoq.ct-saldo >= v_cod_cta_ctbl_ini 
                          AND movto-estoq.ct-saldo <= v_cod_cta_ctbl_fim THEN DO:
                               IF l-despesa = YES 
                               THEN DO:
                                   IF movto-estoq.ct-saldo < "40000000"
                                   OR movto-estoq.ct-saldo > "41999999" THEN NEXT.
                               END. 

                               CREATE tt-dados.
                               ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                      tt-dados.cod_estab             = movto-estoq.cod-estabel
                                      tt-dados.origem                = "CEP"
                                      tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "DB" ELSE "CR"
                                      tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                      tt-dados.dt_transacao          = movto-estoq.dt-trans
                                      tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                      tt-dados.cod_ser_docto         = movto-estoq.serie
                                      tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                      tt-dados.cod_parcela           = "0"
                                      tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                      tt-dados.val_aprop_ctbl        = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1])
                                      tt-dados.cod_cta_ctbl          = movto-estoq.ct-saldo
                                      tt-dados.cod_ccusto            = movto-estoq.sc-saldo
                                      tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                      tt-dados.cod_depos             = movto-estoq.cod-depos
                                      tt-dados.quantidade            = movto-estoq.quantidade
                                      tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                      tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                      tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans
                                      tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                      tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                      tt-dados.requisitante          = c-requisitante
                                      tt-dados.num-lancto            = RECID(movto-estoq)
                                      tt-dados.num-lote              = "0".

                               /* 
                               RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                         INPUT movto-estoq.nro-docto,   
                                                         INPUT movto-estoq.serie-docto,        
                                                         INPUT movto-estoq.cod-emitente,
                                                         INPUT movto-estoq.it-codigo,    
                                                         INPUT movto-estoq.sequen-nf).
                               */

                               IF tt-dados.cod_unid_negoc <> "" 
                               THEN DO:
                                    FIND unid_negoc NO-LOCK
                                       WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                    IF AVAIL unid_negoc 
                                       THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                               END.

                               IF tt-dados.val_aprop_ctbl = 0 
                               AND l-previa
                               THEN DO:
                                    find item-estab no-lock
                                         where item-estab.cod-estabel = movto-estoq.cod-estabel
                                           and item-estab.it-codigo   = movto-estoq.it-codigo no-error.

                                    if avail item-estab then
                                        assign tt-dados.val_aprop_ctbl = movto-estoq.quantidade * 
                                                                        (item-estab.val-unit-mat-m[1]
                                                                        + item-estab.val-unit-mob-m[1]
                                                                        + item-estab.val-unit-ggf-m[1] ).
                               END.

                               FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.

                               ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                      tt-dados.des_item  = ITEM.desc-item.

                               IF movto-estoq.cod-emitente <> 0 
                               THEN DO:
                                    FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                                    IF AVAIL emitente 
                                       THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                   tt-dados.uf_emitente = emitente.estado.

                               END.
                               ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                               find item-doc-est no-lock
                                    where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                    and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                    and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                    and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                    and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                                
                               if  avail item-doc-est then DO:
                                   assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                          tt-dados.des_lancto    = item-doc-est.narrativa
                                          tt-dados.nat-operacao  = item-doc-est.nat-of.

                                   /* Desmenbra Narrativa - 18/07/2023 */
                                   RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                   IF  item-doc-est.num-pedido <> 0 THEN DO:    
                                       FIND FIRST ordem-compra 
                                           WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
    
                                       IF  AVAIL ordem-compra THEN DO:
                                           IF  tt-dados.requisitante = "" THEN DO:                                           
                                               FIND usuar_mestre NO-LOCK
                                                    WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.
                                               
                                               IF  AVAIL usuar_mestre THEN
                                                   ASSIGN  c-requisitante = usuar_mestre.nom_usuar.
        
                                               ASSIGN tt-dados.requisitante = c-requisitante.
                                           END.
                                       END.

                                       ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                   END.
                                   ELSE DO:
                                       FIND FIRST rat-ordem
                                          WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                          AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                          AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                          AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                          AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                       IF  AVAIL rat-ordem THEN DO:
                                           FIND FIRST ordem-compra 
                                               WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.
        
                                           IF  AVAIL ordem-compra THEN DO:
                                               IF  tt-dados.requisitante = "" THEN DO:
                                                   FIND usuar_mestre NO-LOCK
                                                        WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.
                                                   
                                                   IF  AVAIL usuar_mestre THEN
                                                       ASSIGN  c-requisitante = usuar_mestre.nom_usuar.
            
                                                   ASSIGN tt-dados.requisitante = c-requisitante.
                                               END.                                                      
                                           END.

                                           ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                       END.
                                   END.
                               END.

                                IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                         movto-estoq.esp-docto      = 6
                                THEN
                                    ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                                ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(c-des_lancto).
                         END.

                         /* ** Movimento com base na movto-estoq.valor-pis ***/
                         IF  movto-estoq.valor-pis       <> 0
                         AND estabelec.cod-cta-pis-recup >= (v_cod_cta_ctbl_ini) 
                         AND estabelec.cod-cta-pis-recup <= (v_cod_cta_ctbl_fim)
                         THEN DO:
                              IF l-despesa = YES 
                              THEN DO:
                                   IF estabelec.cod-cta-pis-recup < "40000000"
                                   OR estabelec.cod-cta-pis-recup > "41999999"
                                      THEN NEXT.
                              END.

                              CREATE tt-dados.
                              ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                     tt-dados.cod_estab             = movto-estoq.cod-estabel
                                     tt-dados.origem                = "CEP"
                                     tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "DB" ELSE "CR"
                                     tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                     tt-dados.dt_transacao          = movto-estoq.dt-trans
                                     tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                     tt-dados.cod_ser_docto         = movto-estoq.serie
                                     tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                     tt-dados.cod_parcela           = "0"
                                     tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                     tt-dados.val_aprop_ctbl        = movto-estoq.valor-pis
                                     tt-dados.cod_cta_ctbl          = estabelec.cod-cta-pis-recup
                                     tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                                     tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                     tt-dados.cod_depos             = movto-estoq.cod-depos
                                     tt-dados.quantidade            = movto-estoq.quantidade
                                     tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                     tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                     tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans
                                     tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                     tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                     tt-dados.requisitante          = c-requisitante
                                     tt-dados.num-lancto            = RECID(movto-estoq)
                                     tt-dados.num-lote              = "0".

                              /*
                              RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                       INPUT movto-estoq.nro-docto,   
                                                       INPUT movto-estoq.serie-docto,        
                                                       INPUT movto-estoq.cod-emitente,
                                                       INPUT movto-estoq.it-codigo,    
                                                       INPUT movto-estoq.sequen-nf).
                              */

                              IF tt-dados.cod_unid_negoc <> "" 
                              THEN DO:
                                   FIND unid_negoc NO-LOCK
                                      WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                   IF AVAIL unid_negoc 
                                      THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                              END.

                              FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.

                              ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                     tt-dados.des_item  = ITEM.desc-item.

                              IF movto-estoq.cod-emitente <> 0 
                              THEN DO:
                                   FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                                   IF AVAIL emitente 
                                      THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                  tt-dados.uf_emitente = emitente.estado.

                              END.
                              ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                              find item-doc-est no-lock
                                   where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                   and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                   and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                   and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                   and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                               
                              if  avail item-doc-est then DO:
                                  assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                         tt-dados.des_lancto    = item-doc-est.narrativa
                                         tt-dados.nat-operacao  = item-doc-est.nat-of.

                                  /* Desmenbra Narrativa - 18/07/2023 */
                                   RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                  IF  item-doc-est.num-pedido <> 0 THEN DO:

                                      FIND FIRST ordem-compra 
                                          WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.

                                      IF  AVAIL ordem-compra THEN DO:
                                          IF  tt-dados.requisitante = "" THEN DO:                                           
                                              FIND usuar_mestre NO-LOCK
                                                   WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                              IF  AVAIL usuar_mestre THEN
                                                  ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                              ASSIGN tt-dados.requisitante = c-requisitante.
                                          END.
                                      END.

                                      ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                  END.
                                  ELSE DO:
                                      FIND FIRST rat-ordem
                                         WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                         AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                         AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                         AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                         AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                      IF  AVAIL rat-ordem THEN DO:
                                          FIND FIRST ordem-compra 
                                              WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.

                                          IF  AVAIL ordem-compra THEN DO:
                                              IF  tt-dados.requisitante = "" THEN DO:
                                                  FIND usuar_mestre NO-LOCK
                                                       WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                                  IF  AVAIL usuar_mestre THEN
                                                      ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                                  ASSIGN tt-dados.requisitante = c-requisitante.
                                              END.                                                      
                                          END.

                                          ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                      END.
                                  END.
                              END.

                              IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                       movto-estoq.esp-docto      = 6
                              THEN
                                  ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                              ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + c-des_lancto.
                         END.

                         /* ** Movimento com base na movto-estoq.val-cofins ***/
                         IF  movto-estoq.val-cofins         <> 0
                         AND estabelec.cod-cta-cofins-recup >= (v_cod_cta_ctbl_ini) 
                         AND estabelec.cod-cta-cofins-recup <= (v_cod_cta_ctbl_fim)
                         THEN DO:
                              IF l-despesa = YES 
                              THEN DO:
                                   IF estabelec.cod-cta-cofins-recup < "40000000"
                                   OR estabelec.cod-cta-cofins-recup > "41999999"
                                      THEN NEXT.
                              END.

                              CREATE tt-dados.
                              ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                     tt-dados.cod_estab             = movto-estoq.cod-estabel
                                     tt-dados.origem                = "CEP"
                                     tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "DB" ELSE "CR"
                                     tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                     tt-dados.dt_transacao          = movto-estoq.dt-trans
                                     tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                     tt-dados.cod_ser_docto         = movto-estoq.serie
                                     tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                     tt-dados.cod_parcela           = "0"
                                     tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                     tt-dados.val_aprop_ctbl        = movto-estoq.val-cofins
                                     tt-dados.cod_cta_ctbl          = estabelec.cod-cta-cofins-recup
                                     tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                                     tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                     tt-dados.cod_depos             = movto-estoq.cod-depos
                                     tt-dados.quantidade            = movto-estoq.quantidade
                                     tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                     tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                     tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans
                                     tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                     tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                     tt-dados.requisitante          = c-requisitante
                                     tt-dados.num-lancto            = RECID(movto-estoq)
                                     tt-dados.num-lote              = "0".

                              /*
                              RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                       INPUT movto-estoq.nro-docto,   
                                                       INPUT movto-estoq.serie-docto,        
                                                       INPUT movto-estoq.cod-emitente,
                                                       INPUT movto-estoq.it-codigo,    
                                                       INPUT movto-estoq.sequen-nf).
                              */

                              IF tt-dados.cod_unid_negoc <> "" 
                              THEN DO:
                                   FIND unid_negoc NO-LOCK
                                      WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                   IF AVAIL unid_negoc 
                                      THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                              END.

                              FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.

                              ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                     tt-dados.des_item  = ITEM.desc-item.

                              IF movto-estoq.cod-emitente <> 0 
                              THEN DO:
                                   FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                                   IF AVAIL emitente 
                                      THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                  tt-dados.uf_emitente = emitente.estado.

                              END.
                              ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                              find item-doc-est no-lock
                                   where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                   and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                   and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                   and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                   and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                               
                              if  avail item-doc-est then DO:
                                  assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                         tt-dados.des_lancto    = item-doc-est.narrativa
                                         tt-dados.nat-operacao  = item-doc-est.nat-of.

                                  /* Desmenbra Narrativa - 18/07/2023 */
                                  RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                  IF  item-doc-est.num-pedido <> 0 THEN DO:

                                      FIND FIRST ordem-compra 
                                          WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.

                                      IF  AVAIL ordem-compra THEN DO:
                                          IF  tt-dados.requisitante = "" THEN DO:                                           
                                              FIND usuar_mestre NO-LOCK
                                                   WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                              IF  AVAIL usuar_mestre THEN
                                                  ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                              ASSIGN tt-dados.requisitante = c-requisitante.
                                          END.
                                      END.

                                      ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                  END.
                                  ELSE DO:
                                      FIND FIRST rat-ordem
                                         WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                         AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                         AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                         AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                         AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                      IF  AVAIL rat-ordem THEN DO:
                                          FIND FIRST ordem-compra 
                                              WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.

                                          IF  AVAIL ordem-compra THEN DO:
                                              IF  tt-dados.requisitante = "" THEN DO:
                                                  FIND usuar_mestre NO-LOCK
                                                       WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                                  IF  AVAIL usuar_mestre THEN
                                                      ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                                  ASSIGN tt-dados.requisitante = c-requisitante.
                                              END.                                                      
                                          END.

                                          ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                      END.
                                  END.
                              END.

                              IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                       movto-estoq.esp-docto      = 6
                              THEN
                                  ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                              ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + c-des_lancto.
                         END.

                         /* ** Movimento com base na movto-estoq.valor-icm ***/
                         IF  movto-estoq.valor-icm <> 0
                         AND estabelec.conta-icms  >= (v_cod_cta_ctbl_ini + "00000000") 
                         AND estabelec.conta-icms  <= (v_cod_cta_ctbl_fim + "99999999")
                         THEN DO:
                              IF l-despesa = YES 
                              THEN DO:
                                   IF estabelec.conta-icms < "4000000000000000"
                                   OR estabelec.conta-icms > "4199999999999999"
                                      THEN NEXT.
                              END.

                              CREATE tt-dados.
                              ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                     tt-dados.cod_estab             = movto-estoq.cod-estabel
                                     tt-dados.origem                = "CEP"
                                     tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "DB" ELSE "CR"
                                     tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                     tt-dados.dt_transacao          = movto-estoq.dt-trans
                                     tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                     tt-dados.cod_ser_docto         = movto-estoq.serie
                                     tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                     tt-dados.cod_parcela           = "0"
                                     tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                     tt-dados.val_aprop_ctbl        = movto-estoq.valor-icm
                                     tt-dados.cod_cta_ctbl          = SUBSTRING(estabelec.conta-icms, 1, 8)
                                     tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                                     tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                     tt-dados.cod_depos             = movto-estoq.cod-depos
                                     tt-dados.quantidade            = movto-estoq.quantidade
                                     tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                     tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                     tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans      
                                     tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                     tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                     tt-dados.requisitante          = c-requisitante
                                     tt-dados.num-lancto            = RECID(movto-estoq)
                                     tt-dados.num-lote              = "0".

                              /*
                              RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                       INPUT movto-estoq.nro-docto,   
                                                       INPUT movto-estoq.serie-docto,        
                                                       INPUT movto-estoq.cod-emitente,
                                                       INPUT movto-estoq.it-codigo,    
                                                       INPUT movto-estoq.sequen-nf).
                              */
                                
                              IF tt-dados.cod_unid_negoc <> "" 
                              THEN DO:
                                   FIND unid_negoc NO-LOCK
                                      WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                   IF AVAIL unid_negoc 
                                      THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                              END.

                              FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.

                              ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                     tt-dados.des_item  = ITEM.desc-item.

                              IF movto-estoq.cod-emitente <> 0 
                              THEN DO:
                                   FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                                   IF AVAIL emitente 
                                      THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                  tt-dados.uf_emitente = emitente.estado.

                              END.
                              ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                              find item-doc-est no-lock
                                   where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                   and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                   and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                   and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                   and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                               
                              if  avail item-doc-est then DO:
                                  assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                         tt-dados.des_lancto    = item-doc-est.narrativa
                                         tt-dados.nat-operacao  = item-doc-est.nat-of.

                                  /* Desmenbra Narrativa - 18/07/2023 */
                                  RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                  IF  item-doc-est.num-pedido <> 0 THEN DO:

                                      FIND FIRST ordem-compra 
                                          WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.

                                      IF  AVAIL ordem-compra THEN DO:
                                          IF  tt-dados.requisitante = "" THEN DO:                                           
                                              FIND usuar_mestre NO-LOCK
                                                   WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                              IF  AVAIL usuar_mestre THEN
                                                  ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                              ASSIGN tt-dados.requisitante = c-requisitante.
                                          END.
                                      END.

                                      ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                  END.
                                  ELSE DO:
                                      FIND FIRST rat-ordem
                                         WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                         AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                         AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                         AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                         AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                      IF  AVAIL rat-ordem THEN DO:
                                          FIND FIRST ordem-compra 
                                              WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.

                                          IF  AVAIL ordem-compra THEN DO:
                                              IF  tt-dados.requisitante = "" THEN DO:
                                                  FIND usuar_mestre NO-LOCK
                                                       WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                                  IF  AVAIL usuar_mestre THEN
                                                      ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                                  ASSIGN tt-dados.requisitante = c-requisitante.
                                              END.                                                      
                                          END.

                                          ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                      END.
                                  END.
                              END.

                              IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                       movto-estoq.esp-docto      = 6
                              THEN
                                  ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                              ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + c-des_lancto.
                         END.

                         /* ** Movimento com base na movto-estoq.valor-ipi ***/
                         IF  movto-estoq.valor-ipi <> 0
                         AND estabelec.conta-ipi   >= (v_cod_cta_ctbl_ini + "00000000") 
                         AND estabelec.conta-ipi   <= (v_cod_cta_ctbl_fim + "99999999")
                         THEN DO:
                              IF l-despesa = YES 
                              THEN DO:
                                   IF estabelec.conta-ipi < "4000000000000000"
                                   OR estabelec.conta-ipi > "4199999999999999"
                                      THEN NEXT.
                              END.

                              CREATE tt-dados.
                              ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                     tt-dados.cod_estab             = movto-estoq.cod-estabel
                                     tt-dados.origem                = "CEP"
                                     tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "DB" ELSE "CR"
                                     tt-dados.cod_emitente          = movto-estoq.cod-emitente
                                     tt-dados.dt_transacao          = movto-estoq.dt-trans
                                     tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                                     tt-dados.cod_ser_docto         = movto-estoq.serie
                                     tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                                     tt-dados.cod_parcela           = "0"
                                     tt-dados.nat-operacao          = movto-estoq.nat-operacao
                                     tt-dados.val_aprop_ctbl        = movto-estoq.valor-ipi
                                     tt-dados.cod_cta_ctbl          = SUBSTRING(estabelec.conta-ipi, 1, 8)
                                     tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                                     tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                                     tt-dados.cod_depos             = movto-estoq.cod-depos
                                     tt-dados.quantidade            = movto-estoq.quantidade
                                     tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario
                                     tt-dados.dat_ult_atualiz       = movto-estoq.dt-criacao
                                     tt-dados.hra_ult_atualiz       = movto-estoq.hr-trans
                                     tt-dados.log_contabilizado     = movto-estoq.contabilizado
                                     tt-dados.tipo-acordo           = c-tipo-acordo-cep
                                     tt-dados.requisitante          = c-requisitante
                                     tt-dados.num-lancto            = RECID(movto-estoq)
                                     tt-dados.num-lote              = "0".

                               /*
                               RUN pi-verifica-nf-frete(INPUT movto-estoq.cod-estabel,
                                                        INPUT movto-estoq.nro-docto,   
                                                        INPUT movto-estoq.serie-docto,        
                                                        INPUT movto-estoq.cod-emitente,
                                                        INPUT movto-estoq.it-codigo,    
                                                        INPUT movto-estoq.sequen-nf).
                              */

                              IF tt-dados.cod_unid_negoc <> "" 
                              THEN DO:
                                   FIND unid_negoc NO-LOCK
                                      WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                                   IF AVAIL unid_negoc 
                                      THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                              END.

                              FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.

                              ASSIGN tt-dados.it_codigo = ITEM.it-codigo
                                     tt-dados.des_item  = ITEM.desc-item.

                              IF movto-estoq.cod-emitente <> 0 
                              THEN DO:
                                   FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                                   IF AVAIL emitente 
                                      THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                                  tt-dados.uf_emitente = emitente.estado.

                              END.
                              ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                              find item-doc-est no-lock
                                   where item-doc-est.serie-docto  = movto-estoq.serie-docto
                                   and   item-doc-est.nro-docto    = movto-estoq.nro-docto
                                   and   item-doc-est.cod-emitente = movto-estoq.cod-emitente
                                   and   item-doc-est.nat-operacao = movto-estoq.nat-operacao
                                   and   item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                               
                              if  avail item-doc-est then DO:
                                  assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                         tt-dados.des_lancto    = item-doc-est.narrativa
                                         tt-dados.nat-operacao  = item-doc-est.nat-of.

                                  /* Desmenbra Narrativa - 18/07/2023 */
                                  RUN pi-desmembra-narrativa(INPUT item-doc-est.narrativa).

                                  IF  item-doc-est.num-pedido <> 0 THEN DO:
                                      FIND FIRST ordem-compra 
                                          WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.

                                      IF  AVAIL ordem-compra THEN DO:
                                          IF  tt-dados.requisitante = "" THEN DO:                                           
                                              FIND usuar_mestre NO-LOCK
                                                   WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                              IF  AVAIL usuar_mestre THEN
                                                  ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                              ASSIGN tt-dados.requisitante = c-requisitante.
                                          END.
                                      END.

                                      ASSIGN tt-dados.num-pedido = item-doc-est.num-pedido.
                                  END.
                                  ELSE DO:
                                      FIND FIRST rat-ordem
                                         WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                         AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
                                         AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
                                         AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
                                         AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                                      IF  AVAIL rat-ordem THEN DO:
                                          FIND FIRST ordem-compra 
                                              WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.

                                          IF  AVAIL ordem-compra THEN DO:
                                              IF  tt-dados.requisitante = "" THEN DO:
                                                  FIND usuar_mestre NO-LOCK
                                                       WHERE usuar_mestre.cod_usuar = ordem-compra.requisitante NO-ERROR.

                                                  IF  AVAIL usuar_mestre THEN
                                                      ASSIGN  c-requisitante = usuar_mestre.nom_usuar.

                                                  ASSIGN tt-dados.requisitante = c-requisitante.
                                              END.                                                      
                                          END.

                                          ASSIGN tt-dados.num-pedido = rat-ordem.num-pedido.
                                      END.
                                  END.
                              END.

                              IF  TRIM(movto-estoq.descricao-db) <> "" AND
                                       movto-estoq.esp-docto      = 6
                              THEN
                                  ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + TRIM(movto-estoq.descricao-db).
                              ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + " - " + c-des_lancto.
                         END.
                     END.
                END.
            END.
        END.

        IF  l-estoque = NO
        AND l-FAS     = YES THEN DO:
        
            run pi-acompanhar in h-acomp (input "Ler Ativo Fixo").
            /*** Movimentos Ativo Fixo - FAS ***/
            DEFINE VARIABLE v_cod_tip_calc AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    
            ASSIGN v_cod_tip_calc = ";Deprec;Seguro;Amortiz;CM".
    
            DO i-data = v_data_ini TO v_data_fim:

                run pi-acompanhar in h-acomp (input "Lendo Ativo Fixo Dia: " + STRING(i-data,"99/99/9999")).
            
                DO i = 1 TO NUM-ENTRIES(v_cod_tip_calc,";"):
        
                    FOR EACH reg_calc_bem_pat NO-LOCK
                        WHERE reg_calc_bem_pat.cod_tip_calc     = ENTRY(i,v_cod_tip_calc,";")
                          AND reg_calc_bem_pat.cod_cenar_ctbl   = v_cod_cenar_ctbl /* "Fiscal" - chamado 116563 */
                          AND reg_calc_bem_pat.cod_finalid_econ = "Corrente"
                          AND reg_calc_bem_pat.dat_calc_pat     = i-data:
        
                        FIND bem_pat NO-LOCK OF reg_calc_bem_pat.
        
                        FIND FIRST bem_pat_item_docto_entr OF bem_pat NO-LOCK NO-ERROR.
        
                        FIND param_calc_bem_pat NO-LOCK OF bem_pat
                            WHERE param_calc_bem_pat.cod_cenar_ctbl   = v_cod_cenar_ctbl /* "Fiscal" - chamado 116563 */
                              AND param_calc_bem_pat.cod_finalid_econ = "Corrente"
                              AND (param_calc_bem_pat.cod_tip_calc    = "Deprec" OR param_calc_bem_pat.cod_tip_calc = "Amortiz") NO-ERROR.
        
        
                        IF  reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa" THEN DO:
                            FIND FIRST movto_bem_pat
                                 WHERE movto_bem_pat.num_id_bem_pat         = reg_calc_bem_pat.num_id_bem_pat
                                 AND   movto_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                                 AND   movto_bem_pat.dat_movto_bem_pat      = reg_calc_bem_pat.dat_calc_pat NO-LOCK NO-ERROR.

                            IF  AVAIL movto_bem_pat THEN
                                FIND FIRST motiv_desmob
                                    WHERE motiv_desmob.cod_motiv_desmob = movto_bem_pat.cod_motiv_desmob NO-LOCK NO-ERROR.

                        END.

                        FOR EACH aprop_ctbl_pat NO-LOCK
                            WHERE aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat:
        
                            IF  aprop_ctbl_pat.cod_cta_ctbl_db >= v_cod_cta_ctbl_ini 
                            AND aprop_ctbl_pat.cod_cta_ctbl_db <= v_cod_cta_ctbl_fim THEN DO:
        
                                 ASSIGN l-cta-db = YES.

                                 IF  l-despesa = YES THEN DO:
                                     IF  aprop_ctbl_pat.cod_cta_ctbl_db < "40000000"
                                     OR  aprop_ctbl_pat.cod_cta_ctbl_db > "41999999" THEN
                                         ASSIGN l-cta-db = NO.
                                 END. 
    
                                 IF  l-cta-db = YES THEN DO:
                                     CREATE tt-dados.
                                     ASSIGN tt-dados.cod_empresa           = reg_calc_bem_pat.cod_empresa
                                            tt-dados.cod_estab             = aprop_ctbl_pat.cod_estab
                                            tt-dados.origem                = "FAS"
                                            tt-dados.ind_natur_lancto_ctbl = "DB"
                                            tt-dados.cod_emitente          = 0
                                            tt-dados.dt_transacao          = reg_calc_bem_pat.dat_calc_pat
                                            tt-dados.cod_espec_docto       = ""
                                            tt-dados.cod_ser_docto         = ""
                                            tt-dados.cod_tit_ap            = ""
                                            tt-dados.cod_parcela           = ""
                                            tt-dados.nat-operacao          = ""
                                            tt-dados.val_aprop_ctbl        = aprop_ctbl_pat.val_lancto_ctbl
                                            tt-dados.cod_cta_ctbl          = aprop_ctbl_pat.cod_cta_ctbl_db
                                            tt-dados.cod_ccusto            = aprop_ctbl_pat.cod_ccusto_db
                                            tt-dados.cod_unid_negoc        = aprop_ctbl_pat.cod_unid_negoc_db
                                            tt-dados.des_lancto            = "Descriá∆o: " + bem_pat.des_bem_pat + ". " + aprop_ctbl_pat.des_histor_lancto_ctbl
                                            tt-dados.cod_usuar_ult_atualiz = reg_calc_bem_pat.cod_usuar_ult_atualiz
                                            tt-dados.dat_ult_atualiz       = reg_calc_bem_pat.dat_ult_atualiz
                                            tt-dados.hra_ult_atualiz       = STRING(reg_calc_bem_pat.hra_ult_atualiz,"99:99:99")
                                            tt-dados.tta_cod_cta_pat       = bem_pat.cod_cta_pat   
                                            tt-dados.tta_num_bem_pat       = bem_pat.num_bem_pat  
                                            tt-dados.tta_num_seq_bem_pat   = bem_pat.num_seq_bem_pat
                                            tt-dados.vida_util             = IF AVAIL param_calc_bem_pat THEN param_calc_bem_pat.qtd_anos_vida_util ELSE 0
                                            tt-dados.fornecedor            = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cdn_fornecedor ELSE bem_pat.cdn_fornecedor
                                            tt-dados.cod_docto_entr        = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_docto_entr ELSE bem_pat.cod_docto_entr
                                            tt-dados.cod_ser_docto_entr    = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_ser_nota   ELSE bem_pat.cod_ser_nota
                                            tt-dados.log_contabilizado     = reg_calc_bem_pat.log_ctbz_bem_pat
                                            tt-dados.cod_cenar_ctbl        = reg_calc_bem_pat.cod_cenar_ctbl
                                            tt-dados.des_motiv_desmob      = motiv_desmob.des_motiv_desmob WHEN AVAIL motiv_desmob AND reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa"
                                            tt-dados.num-lancto            = RECID(reg_calc_bem_pat)
                                            tt-dados.num-lote              = "0".


                                 END.
        
                            END.
                            
                            IF  aprop_ctbl_pat.cod_cta_ctbl_cr >= v_cod_cta_ctbl_ini 
                            AND aprop_ctbl_pat.cod_cta_ctbl_cr <= v_cod_cta_ctbl_fim THEN DO:

                                ASSIGN l-cta-cr = YES.

                                 IF l-despesa = YES THEN DO:
                                      IF aprop_ctbl_pat.cod_cta_ctbl_cr < "40000000"
                                      OR aprop_ctbl_pat.cod_cta_ctbl_cr > "41999999" THEN
                                          ASSIGN l-cta-cr = NO.
                                 END. 
    
                                 IF  l-cta-cr = YES THEN DO:
                                     CREATE tt-dados.
                                     ASSIGN tt-dados.cod_empresa           = reg_calc_bem_pat.cod_empresa
                                            tt-dados.cod_estab             = aprop_ctbl_pat.cod_estab
                                            tt-dados.origem                = "FAS"
                                            tt-dados.ind_natur_lancto_ctbl = "CR"
                                            tt-dados.cod_emitente          = 0
                                            tt-dados.dt_transacao          = reg_calc_bem_pat.dat_calc_pat
                                            tt-dados.cod_espec_docto       = ""
                                            tt-dados.cod_ser_docto         = ""
                                            tt-dados.cod_tit_ap            = ""
                                            tt-dados.cod_parcela           = ""
                                            tt-dados.nat-operacao          = ""
                                            tt-dados.val_aprop_ctbl        = aprop_ctbl_pat.val_lancto_ctbl
                                            tt-dados.cod_cta_ctbl          = aprop_ctbl_pat.cod_cta_ctbl_cr
                                            tt-dados.cod_ccusto            = aprop_ctbl_pat.cod_ccusto_cr
                                            tt-dados.cod_unid_negoc        = aprop_ctbl_pat.cod_unid_negoc_cr
                                            tt-dados.des_lancto            = "Descriá∆o: " + bem_pat.des_bem_pat + ". " + aprop_ctbl_pat.des_histor_lancto_ctbl
                                            tt-dados.cod_usuar_ult_atualiz = reg_calc_bem_pat.cod_usuar_ult_atualiz
                                            tt-dados.dat_ult_atualiz       = reg_calc_bem_pat.dat_ult_atualiz
                                            tt-dados.hra_ult_atualiz       = STRING(reg_calc_bem_pat.hra_ult_atualiz,"99:99:99")
                                            tt-dados.tta_cod_cta_pat       = bem_pat.cod_cta_pat   
                                            tt-dados.tta_num_bem_pat       = bem_pat.num_bem_pat  
                                            tt-dados.tta_num_seq_bem_pat   = bem_pat.num_seq_bem_pat
                                            tt-dados.vida_util             = IF AVAIL param_calc_bem_pat THEN param_calc_bem_pat.qtd_anos_vida_util ELSE 0
                                            tt-dados.fornecedor            = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cdn_fornecedor ELSE bem_pat.cdn_fornecedor
                                            tt-dados.cod_docto_entr        = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_docto_entr ELSE bem_pat.cod_docto_entr
                                            tt-dados.cod_ser_docto_entr    = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_ser_nota   ELSE bem_pat.cod_ser_nota
                                            tt-dados.log_contabilizado     = reg_calc_bem_pat.log_ctbz_bem_pat
                                            tt-dados.cod_cenar_ctbl        = reg_calc_bem_pat.cod_cenar_ctbl
                                            tt-dados.des_motiv_desmob      = motiv_desmob.des_motiv_desmob WHEN AVAIL motiv_desmob AND reg_calc_bem_pat.ind_trans_calc_bem_pat = "Baixa"
                                            tt-dados.num-lancto            = RECID(reg_calc_bem_pat)
                                            tt-dados.num-lote              = "0".
                                 END.
                            END.    
        
                        END.
        
                    END.
        
                END.
    
                IF  MONTH(i-data) <> MONTH(i-data + 1) THEN DO:

                    FOR EACH calc_parc_pis_cofins USE-INDEX clcprcps_period NO-LOCK 
                        WHERE calc_parc_pis_cofins.cod_exerc_ctbl  = STRING(YEAR(i-data))
                          AND calc_parc_pis_cofins.num_period_ctbl = MONTH(i-data)
                          AND calc_parc_pis_cofins.cod_empresa     = v_cod_empres_usuar:
                    
                        FIND bem_pat OF calc_parc_pis_cofins NO-LOCK NO-ERROR.
        
                        FIND FIRST bem_pat_item_docto_entr OF bem_pat NO-LOCK NO-ERROR.
        
                        FIND param_calc_bem_pat NO-LOCK OF bem_pat
                            WHERE param_calc_bem_pat.cod_cenar_ctbl   = v_cod_cenar_ctbl /* "Fiscal" - chamado 116563 */
                              AND param_calc_bem_pat.cod_finalid_econ = "Corrente"
                              AND (param_calc_bem_pat.cod_tip_calc = "Deprec" OR param_calc_bem_pat.cod_tip_calc = "Amortiz") NO-ERROR.
        
                        FOR EACH aprop_parc_pis_cofins no-lock
                            WHERE aprop_parc_pis_cofins.num_id_calc_parc = calc_parc_pis_cofins.num_id_calc_parc
                              AND aprop_parc_pis_cofins.cod_cenar_ctbl   = v_cod_cenar_ctbl /* 'fiscal' - chamado 116563 */
                              AND aprop_parc_pis_cofins.cod_finalid_econ = 'corrente':
                    
                            IF  aprop_parc_pis_cofins.cod_cta_ctbl_db >= v_cod_cta_ctbl_ini 
                            AND aprop_parc_pis_cofins.cod_cta_ctbl_db <= v_cod_cta_ctbl_fim 
                            THEN DO:
        
                                 IF l-despesa = YES 
                                 THEN DO:
                                      IF aprop_parc_pis_cofins.cod_cta_ctbl_db < "40000000"
                                      OR aprop_parc_pis_cofins.cod_cta_ctbl_db > "41999999"
                                         THEN NEXT.
                                 END. 
    
                                 CREATE tt-dados.
                                 ASSIGN tt-dados.cod_empresa           = calc_parc_pis_cofins.cod_empresa
                                        tt-dados.cod_estab             = aprop_parc_pis_cofins.cod_estab
                                        tt-dados.origem                = "FAS"
                                        tt-dados.ind_natur_lancto_ctbl = "DB"
                                        tt-dados.cod_emitente          = 0
                                        tt-dados.dt_transacao          = i-data
                                        tt-dados.cod_espec_docto       = ""
                                        tt-dados.cod_ser_docto         = ""
                                        tt-dados.cod_tit_ap            = ""
                                        tt-dados.cod_parcela           = ""
                                        tt-dados.nat-operacao          = ""
                                        tt-dados.val_aprop_ctbl        = aprop_parc_pis_cofins.val_aprop_ctbl
                                        tt-dados.cod_cta_ctbl          = aprop_parc_pis_cofins.cod_cta_ctbl_db
                                        tt-dados.cod_ccusto            = aprop_parc_pis_cofins.cod_ccusto
                                        tt-dados.cod_unid_negoc        = aprop_parc_pis_cofins.cod_unid_negoc
                                        tt-dados.des_lancto            = "Descriá∆o: " + bem_pat.des_bem_pat + ". " + aprop_parc_pis_cofins.ind_finalid_ctbl
                                        tt-dados.cod_usuar_ult_atualiz = ""
                                        tt-dados.dat_ult_atualiz       = ?
                                        tt-dados.hra_ult_atualiz       = "00:00:00"
                                        tt-dados.tta_cod_cta_pat       = bem_pat.cod_cta_pat   
                                        tt-dados.tta_num_bem_pat       = bem_pat.num_bem_pat  
                                        tt-dados.tta_num_seq_bem_pat   = bem_pat.num_seq_bem_pat
                                        tt-dados.vida_util             = IF AVAIL param_calc_bem_pat THEN param_calc_bem_pat.qtd_anos_vida_util ELSE 0
                                        tt-dados.fornecedor            = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cdn_fornecedor ELSE bem_pat.cdn_fornecedor
                                        tt-dados.cod_docto_entr        = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_docto_entr ELSE bem_pat.cod_docto_entr
                                        tt-dados.cod_ser_docto_entr    = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_ser_nota   ELSE bem_pat.cod_ser_nota
                                        tt-dados.parcela               = calc_parc_pis_cofins.num_parcela_cr
                                        tt-dados.tot-parcela           = bem_pat.num_parc_pis_cofins
                                        tt-dados.saldo                 = (aprop_parc_pis_cofins.val_aprop_ctbl * ((IF calc_parc_pis_cofins.num_parcela_cr = 99 THEN calc_parc_pis_cofins.num_parcela_cr ELSE bem_pat.num_parc_pis_cofins) - calc_parc_pis_cofins.num_parcela_cr))
                                        tt-dados.log_contabilizado     = calc_parc_pis_cofins.log_ctbz_aprop_ctbl
                                        tt-dados.cod_cenar_ctbl        = aprop_parc_pis_cofins.cod_cenar_ctbl
                                        tt-dados.num-lancto            = RECID(calc_parc_pis_cofins)
                                        tt-dados.num-lote              = "0".
        
                            END.
                            IF  aprop_parc_pis_cofins.cod_cta_ctbl_cr >= v_cod_cta_ctbl_ini 
                            AND aprop_parc_pis_cofins.cod_cta_ctbl_cr <= v_cod_cta_ctbl_fim 
                            THEN DO:
        
                                 IF l-despesa = YES 
                                 THEN DO:
                                      IF aprop_parc_pis_cofins.cod_cta_ctbl_cr < "40000000"
                                      OR aprop_parc_pis_cofins.cod_cta_ctbl_cr > "41999999"
                                         THEN NEXT.
                                 END. 
    
                                 CREATE tt-dados.
                                 ASSIGN tt-dados.cod_empresa           = calc_parc_pis_cofins.cod_empresa
                                        tt-dados.cod_estab             = aprop_parc_pis_cofins.cod_estab
                                        tt-dados.origem                = "FAS"
                                        tt-dados.ind_natur_lancto_ctbl = "CR"
                                        tt-dados.cod_emitente          = 0
                                        tt-dados.dt_transacao          = i-data
                                        tt-dados.cod_espec_docto       = ""
                                        tt-dados.cod_ser_docto         = ""
                                        tt-dados.cod_tit_ap            = ""
                                        tt-dados.cod_parcela           = ""
                                        tt-dados.nat-operacao          = ""
                                        tt-dados.val_aprop_ctbl        = aprop_parc_pis_cofins.val_aprop_ctbl
                                        tt-dados.cod_cta_ctbl          = aprop_parc_pis_cofins.cod_cta_ctbl_cr
                                        tt-dados.cod_ccusto            = aprop_parc_pis_cofins.cod_ccusto
                                        tt-dados.cod_unid_negoc        = aprop_parc_pis_cofins.cod_unid_negoc
                                        tt-dados.des_lancto            = "Descriá∆o: " + bem_pat.des_bem_pat + ". " + aprop_parc_pis_cofins.ind_finalid_ctbl
                                        tt-dados.cod_usuar_ult_atualiz = ""
                                        tt-dados.dat_ult_atualiz       = ?
                                        tt-dados.hra_ult_atualiz       = "00:00:00"
                                        tt-dados.tta_cod_cta_pat       = bem_pat.cod_cta_pat   
                                        tt-dados.tta_num_bem_pat       = bem_pat.num_bem_pat  
                                        tt-dados.tta_num_seq_bem_pat   = bem_pat.num_seq_bem_pat
                                        tt-dados.vida_util             = IF AVAIL param_calc_bem_pat THEN param_calc_bem_pat.qtd_anos_vida_util ELSE 0
                                        tt-dados.fornecedor            = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cdn_fornecedor ELSE bem_pat.cdn_fornecedor
                                        tt-dados.cod_docto_entr        = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_docto_entr ELSE bem_pat.cod_docto_entr
                                        tt-dados.cod_ser_docto_entr    = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_ser_nota   ELSE bem_pat.cod_ser_nota
                                        tt-dados.parcela               = calc_parc_pis_cofins.num_parcela_cr
                                        tt-dados.tot-parcela           = bem_pat.num_parc_pis_cofins
                                        tt-dados.saldo                 = (aprop_parc_pis_cofins.val_aprop_ctbl * ((IF calc_parc_pis_cofins.num_parcela_cr = 99 THEN calc_parc_pis_cofins.num_parcela_cr ELSE bem_pat.num_parc_pis_cofins) - calc_parc_pis_cofins.num_parcela_cr))
                                        tt-dados.log_contabilizado     = calc_parc_pis_cofins.log_ctbz_aprop_ctbl
                                        tt-dados.cod_cenar_ctbl        = aprop_parc_pis_cofins.cod_cenar_ctbl
                                        tt-dados.num-lancto            = RECID(calc_parc_pis_cofins)
                                        tt-dados.num-lote              = "0".
                            END.
                        END.
                    END.
                END.
            END.
        END.
        
        /*OUTPUT STREAM s-detalhado TO VALUE(tt-param.diretorio + "detalhado" + string(MONTH(tt-param.dt-emissao-fim)) + string(YEAR(tt-param.dt-emissao-fim)) + ".csv").*/

        PUT stream s_1 UNFORMATTED "Estab;Origem;DB/CR;Emitente;NomeEmitente;Data;Especie;Serie;Titulo;Parcela;CFOP;Valor;Conta;DescricaoConta;CCusto;DescricaoCCusto;UN;DescricaoUN;Historico;Vencto;Vencto Orig;Prev Pagto;Grupo;Emissao;Moeda;Transacao;Item;DescricaoItem;Deposito;Quantidade;Portador;Carteira;Cotacao;Usuario;NomeUsuario;DataLog;Hora;Cta Patr;Num Bem;Seq Bem;Vida Util;Fornecedor;Docto Entr;Ser Docto Entr;ParcelaNF;Total;Saldo;IECFOAT;Cod;NF Orig;Serie Orig;Natureza Oritg;UF Emitente;Contabilizado;Tipo Acordo;Requisitante;Dt Venc ICMS;Nr SAT;Cenario;Motivo Baixa;Empresa;Num Pedido;Lote Ctbl;Lancto Ctbl;Sequencia;Item Origem Frete;Nota Fiscal;SÇrie;Emitente;CFOP;Valor Item Origem Frete;Dt Emiss∆o Origem;UF Destino" SKIP.
                                       
        run pi-acompanhar in h-acomp (input "Gerar Relat¢rio").

        FOR EACH tt-dados:

            run pi-acompanhar in h-acomp (input "Gerando Relat¢rio Dia: " + STRING(tt-dados.dt_transacao,"99/99/9999")).
        
            IF tt-dados.cod_cta_ctbl < v_cod_cta_ctbl_ini
            OR tt-dados.cod_cta_ctbl > v_cod_cta_ctbl_fim THEN
               NEXT.

            IF tt-dados.cod_ccusto < v_ccusto_ini
            OR tt-dados.cod_ccusto > v_ccusto_fim THEN 
               NEXT.

            IF tt-dados.cod_estab < v_estab_ini
            OR tt-dados.cod_estab > v_estab_fim THEN 
               NEXT.

            ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, ";":U, ",":U)
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(10), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(11), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(12), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(13), " ")
                   tt-dados.cod_tit_ap = REPLACE(tt-dados.cod_tit_ap, ";":U, ",":U)
                   tt-dados.des_item   = REPLACE(tt-dados.des_item, ";":U, ",":U).

            DO i-cont = 1 TO 31:
                ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(i-cont), CHR(32)).
            END.

            IF INDEX(tt-dados.des_lancto, CHR(32) + CHR(32)) <> 0 THEN DO:
                DO i-cont = 12 TO 2 BY -1:
                    ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, FILL(CHR(32), i-cont), CHR(32)).
                END.
            END.

            ASSIGN tt-dados.des_lancto = TRIM(tt-dados.des_lancto).
            
            DO i-cont = 1 TO 31:
                ASSIGN tt-dados.des_item = REPLACE(tt-dados.des_item, CHR(i-cont), CHR(32)).
            END.

            IF INDEX(tt-dados.des_item, CHR(32) + CHR(32)) <> 0 THEN DO:
                DO i-cont = 12 TO 2 BY -1:
                    ASSIGN tt-dados.des_item = REPLACE(tt-dados.des_item, FILL(CHR(32), i-cont), CHR(32)).
                END.
            END.

            ASSIGN tt-dados.des_item = TRIM(tt-dados.des_item).


            IF tt-dados.ind_natur_lancto_ctbl = "DB"
               THEN ASSIGN v_val_aprop_ctbl = tt-dados.val_aprop_ctbl.
               ELSE ASSIGN v_val_aprop_ctbl = tt-dados.val_aprop_ctbl * (-1).
        
            find cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
                  and cta_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl no-error.
            if avail cta_ctbl
               then assign v_des_cta_ctbl = cta_ctbl.des_tit_ctbl.
               else assign v_des_cta_ctbl = "Nao Localizada".

            find emscad.ccusto no-lock
                where emscad.ccusto.cod_empresa      = tt-dados.cod_empresa
                  AND emscad.ccusto.cod_plano_ccusto = "PADRAO"
                  and emscad.ccusto.cod_ccusto       = tt-dados.cod_ccusto no-error.
            if avail emscad.ccusto
               then assign v_des_ccusto = emscad.ccusto.des_tit_ctbl.
               else assign v_des_ccusto = "Nao Localizada".

            find unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = tt-dados.cod_unid_negoc no-error.
            if avail unid_negoc
               then assign v_des_unid_negoc = unid_negoc.des_unid_negoc.
               else assign v_des_unid_negoc = "Nao Localizada".

            FIND emsfnd.usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuar = tt-dados.cod_usuar_ult_atualiz NO-ERROR.

            ASSIGN v_dat_vencto        = IF tt-dados.dat_vencto           <> ? THEN STRING(tt-dados.dat_vencto)        ELSE ""
                   v_dat_vencto_origin = IF tt-dados.dat_vencto_origin    <> ? THEN STRING(tt-dados.dat_vencto_origin) ELSE ""
                   v_dat_prev_pagto    = IF tt-dados.dat_prev_pagto       <> ? THEN STRING(tt-dados.dat_prev_pagto)    ELSE ""
                   v_dat_emis_docto    = IF tt-dados.dat_emis_docto       <> ? THEN STRING(tt-dados.dat_emis_docto)    ELSE ""
                   v_dat_alter         = IF tt-dados.dat_ult_atualiz      <> ? THEN STRING(tt-dados.dat_ult_atualiz)   ELSE ""
                   v_dat_venc_icms     = IF tt-dados.dt-venc-icms         <> ? THEN STRING(tt-dados.dt-venc-icms)      ELSE ""
                   v_hr_alter          = IF tt-dados.hra_ult_atualiz      <> "00:00:00" THEN STRING(tt-dados.hra_ult_atualiz)      ELSE ""
                   v_val_cotac         = IF tt-dados.val_cotac_indic_econ <> ?          THEN STRING(tt-dados.val_cotac_indic_econ) ELSE ""
                   v_nom_usuar         = IF AVAIL emsfnd.usuar_mestre THEN emsfnd.usuar_mestre.nom_usuar ELSE "".

            PUT STREAM s_1 UNFORMATTED tt-dados.cod_estab                    + ";" +
                                       tt-dados.origem                       + ";" +
                                       tt-dados.ind_natur_lancto_ctbl        + ";" +
                                       STRING(tt-dados.cod_emitente)         + ";" +
                                       tt-dados.nome_emitente                + ";" +
                                       STRING(tt-dados.dt_transacao)         + ";" +
                                       tt-dados.cod_espec_docto              + ";" +
                                       tt-dados.cod_ser_docto                + ";" +
                                       tt-dados.cod_tit_ap                   + ";" +
                                       tt-dados.cod_parcela                  + ";" +
                                       tt-dados.nat-operacao                 + ";" +
                                       STRING(v_val_aprop_ctbl)              + ";" +
                                       tt-dados.cod_cta_ctbl                 + ";" +
                                       v_des_cta_ctbl                        + ";" +
                                       tt-dados.cod_ccusto                   + ";" +
                                       v_des_ccusto                          + ";" +
                                       tt-dados.cod_unid_negoc               + ";" +
                                       v_des_unid_negoc                      + ";" +
                                       tt-dados.des_lancto                   + ";" +
                                       v_dat_vencto                          + ";" +
                                       v_dat_vencto_origin                   + ";" +
                                       v_dat_prev_pagto                      + ";" +
                                       tt-dados.cod_grp                      + ";" +
                                       v_dat_emis_docto                      + ";" +
                                       tt-dados.cod_indic_econ               + ";" +
                                       tt-dados.ind_trans                    + ";" +
                                       tt-dados.it_codigo                    + ";" +
                                       tt-dados.des_item                     + ";" +
                                       tt-dados.cod_depos                    + ";" +
                                       STRING(tt-dados.quantidade)           + ";" +
                                       tt-dados.cod_portador                 + ";" +
                                       tt-dados.cod_carteira                 + ";" +
                                       v_val_cotac                           + ";" +
                                       tt-dados.cod_usuar_ult_atualiz        + ";" +
                                       v_nom_usuar                           + ";" +
                                       v_dat_alter                           + ";" +
                                       v_hr_alter                            + ";" +
                                       tt-dados.tta_cod_cta_pat              + ";" +
                                       STRING(tt-dados.tta_num_bem_pat)      + ";" +
                                       STRING(tt-dados.tta_num_seq_bem_pat)  + ";" +
                                       STRING(tt-dados.vida_util)            + ";" +
                                       STRING(tt-dados.fornecedor)           + ";" +
                                       tt-dados.cod_docto_entr               + ";" +
                                       tt-dados.cod_ser_docto_entr           + ";" +
                                       STRING(tt-dados.parcela)              + ";" +
                                       STRING(tt-dados.tot-parcela)          + ";" +
                                       STRING(tt-dados.saldo)                + ";" +
                                       tt-dados.IECFOAT                      + ";" +
                                       STRING(tt-dados.cod_tribut)           + ";" +
                                       tt-dados.nf-desp-aces                 + ";" +  
                                       tt-dados.serie-desp                   + ";" +
                                       tt-dados.nat-oper-desp                + ";" + 
                                       tt-dados.uf_emitente                  + ";" +
                                       STRING(tt-dados.log_contabilizado)    + ";" +
                                       tt-dados.tipo-acordo-descricao        + ";" +
                                       tt-dados.requisitante                 + ";" +
                                       v_dat_venc_icms                       + ";" +
                                       string(tt-dados.num-sat)              + ";" +
                                       tt-dados.cod_cenar_ctbl               + ";" +
                                       tt-dados.des_motiv_desmob             + ";" +
                                       tt-dados.cod_empresa                  + ";" +
                                       string(tt-dados.num-pedido)           + ";" +
                                       tt-dados.num-lote                     + ";" +
                                       STRING(tt-dados.num-lancto)           + ";" +
                                       STRING(tt-dados.Orig-Frete-seq)       + ";" +
                                       tt-dados.NF-Item-Orig-Frete           + ";" +
                                       STRING(tt-dados.Orig-Frete-nota)      + ";" +
                                       STRING(tt-dados.Orig-Frete-serie)     + ";" +
                                       STRING(tt-dados.Orig-Frete-emit)      + ";" +
                                       tt-dados.Orig-Frete-cfop              + ";" +
                                       STRING(tt-dados.Val-Item-Orig-Frete)  + ";" +
                                       STRING(tt-dados.Orig-Dt-Emis)         + ";" +
                                       tt-dados.Orig-UF-Dest
                                       SKIP.
        END.
        

END PROCEDURE.
/*****************************************************************************
**  Procedure Interna: pi_leitura_lancto
**  Descricao........: Leitura Movimentaá‰es
*****************************************************************************/
PROCEDURE pi_leitura_lancto:

   DEF INPUT PARAMETER p_cod_cta_ctbl AS CHAR FORMAT "x(8)" NO-UNDO.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-dados.

   DEF VAR i-data      AS DATE.
   DEF VAR c-ct-codigo LIKE movto-estoq.ct-codigo.

   DEFINE VARIABLE v_cod_return AS CHARACTER   NO-UNDO.

   IF l-estoque = NO 
   THEN DO:
       FOR EACH estabelecimento NO-LOCK
           WHERE estabelecimento.cod_estab  >= v_estab_ini
             AND estabelecimento.cod_estab  <= v_estab_fim:
           
           /* ** Movimentos Contabilidade - FGL ***/
           IF l-FGL = YES 
           THEN DO:
               FOR EACH item_lancto_ctbl NO-LOCK
                   WHERE item_lancto_ctbl.cod_empres       = estabelecimento.cod_empresa
                     AND item_lancto_ctbl.cod_plano_cta    = 'padrao'
                     AND item_lancto_ctbl.cod_cta_ctbl     = p_cod_cta_ctbl
                     AND item_lancto_ctbl.cod_estab        = estabelecimento.cod_estab
                     AND (item_lancto_ctbl.cod_cenar_ctbl   = v_cod_cenar_ctbl 
                     OR  item_lancto_ctbl.cod_cenar_ctbl   = "") /* <> "gerenc" */
                     AND item_lancto_ctbl.dat_lancto_ctbl >= v_data_ini
                     AND item_lancto_ctbl.dat_lancto_ctbl <= v_data_fim,
                   EACH lancto_ctbl OF item_lancto_ctbl NO-LOCK
                        WHERE lancto_ctbl.cod_modul_dtsul  <> "ACR"
                          AND lancto_ctbl.cod_modul_dtsul  <> "APB"
                          AND lancto_ctbl.cod_modul_dtsul  <> "CMG"
                          AND lancto_ctbl.cod_modul_dtsul  <> "CEP"
                          AND lancto_ctbl.cod_modul_dtsul  <> "APL"
                          AND lancto_ctbl.cod_modul_dtsul  <> "FTP"
                          AND lancto_ctbl.cod_modul_dtsul  <> "FAS":
            
                   IF  tt-param.l-resultado = NO
                   AND lancto_ctbl.log_lancto_apurac_restdo = YES THEN /* chamado: C2208-1555 */
                       NEXT.

                   FIND int_item_lancto_ctbl OF item_lancto_ctbl NO-LOCK NO-ERROR.
        
                   FIND FIRST aprop_lancto_ctbl OF lancto_ctbl
                       WHERE aprop_lancto_ctbl.cod_finalid_econ = "corrente" NO-LOCK NO-ERROR.

                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                          tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = lancto_ctbl.cod_modul_dtsul
                          tt-dados.ind_natur_lancto_ctbl = item_lancto_ctbl.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = item_lancto_ctbl.dat_lancto_ctbl
                          tt-dados.val_aprop_ctbl        = IF  item_lancto_ctbl.cod_indic_econ = "Real" THEN item_lancto_ctbl.val_lancto_ctbl ELSE aprop_lancto_ctbl.val_lancto_ctbl
                          tt-dados.cod_cta_ctbl          = item_lancto_ctbl.cod_cta_ctbl
                          tt-dados.cod_ccusto            = item_lancto_ctbl.cod_ccusto
                          tt-dados.cod_unid_negoc        = item_lancto_ctbl.cod_unid_negoc
                          tt-dados.des_lancto            = "Lote: " + string(item_lancto_ctbl.num_lote_ctbl) + " Seq: " + string(item_lancto_ctbl.num_seq_lancto_ctbl) + " Historico: " + item_lancto_ctbl.des_histor_lancto_ctbl
                          tt-dados.cod_emitente          = 0
                          tt-dados.nome_emitente         = ""
                          tt-dados.cod_espec_docto       = ""
                          tt-dados.cod_ser_docto         = ""
                          tt-dados.cod_tit_ap            = ""
                          tt-dados.cod_parcela           = ""
                          tt-dados.val_cotac_indic_econ  = 0
                          tt-dados.cod_usuar_ult_atualiz = IF AVAIL int_item_lancto_ctbl THEN int_item_lancto_ctbl.cod_usuar_ult_atualiz ELSE ""
                          tt-dados.dat_ult_atualiz       = IF AVAIL int_item_lancto_ctbl THEN int_item_lancto_ctbl.dat_ult_atualiz       ELSE ?
                          tt-dados.hra_ult_atualiz       = IF AVAIL int_item_lancto_ctbl THEN STRING(int_item_lancto_ctbl.hra_ult_atualiz,"99:99:99") ELSE STRING("000000","99:99:99")
                          tt-dados.log_contabilizado     = YES
                          tt-dados.cod_cenar_ctbl        = item_lancto_ctbl.cod_cenar_ctbl
                          tt-dados.num-lancto            = lancto_ctbl.num_lancto_ctbl
                          tt-dados.num-lote              = string(item_lancto_ctbl.num_lote_ctbl).
               END.
           END.
        
           /* ** Movimentos Contas a Pagar - APB ***/
           IF l-APB = YES 
           THEN DO:
               FOR EACH aprop_ctbl_ap NO-LOCK
                   WHERE aprop_ctbl_ap.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_ap.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_ap.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_ap.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_ap.dat_transacao      <= v_data_fim:
            
                   FIND FIRST movto_tit_ap NO-LOCK
                        WHERE movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
                          AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                          AND movto_tit_ap.log_ctbz_aprop_ctbl = YES NO-ERROR.
            
                   IF NOT AVAIL movto_tit_ap 
                      THEN NEXT.
        
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                          tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "APB"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_ap.dat_transacao
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_ap.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_ap.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_ap.cod_unid_negoc
                          tt-dados.ind_trans             = movto_tit_ap.ind_trans_ap_abrev
                          tt-dados.cod_portador          = movto_tit_ap.cod_portador
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_ap.cod_usuario
                          tt-dados.dat_ult_atualiz       = movto_tit_ap.dat_gerac_movto
                          tt-dados.hra_ult_atualiz       = STRING(movto_tit_ap.hra_gerac_movto,"99:99:99")
                          tt-dados.cod_indic_econ        = aprop_ctbl_ap.cod_indic_econ
                          tt-dados.log_contabilizado     = movto_tit_ap.log_aprop_ctbl_ctbzda
                          tt-dados.num-lancto            = movto_tit_ap.num_id_movto_tit_ap
                          tt-dados.num-lote              = "0".
            
                   /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                   if aprop_ctbl_ap.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_ap of aprop_ctbl_ap 
                            WHERE val_aprop_ctbl_ap.cod_finalid_econ = "Corrente" no-lock:
                            assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
                            IF val_aprop_ctbl_ap.val_cotac_indic_econ <> 0 
                               THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_ap.val_cotac_indic_econ.
                        end.
                        FIND val_movto_ap_correc_val OF movto_tit_ap NO-LOCK
                            WHERE val_movto_ap_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.
                        IF AVAIL val_movto_ap_correc_val 
                           THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_movto_ap_correc_val.val_cotac_indic_econ.
                        
                        /* ** Localiza cotaá∆o que est† no t°tulo origem***/
                        IF tt-dados.val_cotac_indic_econ = 0 
                        THEN DO:
                             FIND FIRST b_movto_tit_ap_aux NO-LOCK
                                 WHERE b_movto_tit_ap_aux.cod_estab     = movto_tit_ap.cod_estab
                                   AND b_movto_tit_ap_aux.num_id_tit_ap = movto_tit_ap.num_id_tit_ap NO-ERROR.
                             FOR EACH b_movto_tit_ap NO-LOCK
                                 WHERE b_movto_tit_ap.cod_estab           = b_movto_tit_ap_aux.cod_estab_tit_ap_pai
                                   AND b_movto_tit_ap.num_id_movto_tit_ap = b_movto_tit_ap_aux.num_id_movto_tit_ap_pai:
                                 FOR EACH b_aprop_ctbl_ap OF b_movto_tit_ap NO-LOCK:
                                     FOR EACH val_aprop_ctbl_ap OF b_aprop_ctbl_ap NO-LOCK:
                                         ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_ap.val_cotac_indic_econ.
                                     END.
                                 END.
                             END.
                        END.

                   END.
            
                   FIND FIRST emscad.fornecedor NO-LOCK
                        WHERE fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
                          AND fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.
                   IF AVAIL emscad.fornecedor THEN DO:
                       IF emscad.fornecedor.num_pessoa MODULO 2 = 0 THEN DO:
                           FIND emscad.pessoa_fisic NO-LOCK
                               WHERE emscad.pessoa_fisic.num_pessoa_fisic = emscad.fornecedor.num_pessoa NO-ERROR.
                           IF AVAIL emscad.pessoa_fisic THEN
                               ASSIGN tt-dados.uf_emitente = emscad.pessoa_fisic.cod_unid_federac.
                       END.
                       ELSE DO:
                           FIND emscad.pessoa_jurid NO-LOCK
                               WHERE emscad.pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa NO-ERROR.
                           IF AVAIL emscad.pessoa_jurid THEN
                               ASSIGN tt-dados.uf_emitente = emscad.pessoa_jurid.cod_unid_federac.
                       END.
                       
                       ASSIGN tt-dados.cod_emitente  = emscad.fornecedor.cdn_fornecedor
                              tt-dados.nome_emitente = emscad.fornecedor.nom_pessoa.
                   END.
            
                   ASSIGN c-num-fedex = "".

                   FOR EACH histor_tit_movto_ap NO-LOCK 
                       WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                         AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                         AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap 
                         AND histor_tit_movto_ap.ind_orig_histor_ap <> "Erro":
                       ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + histor_tit_movto_ap.des_text_histor + " ".

                       /* tratamento para busca informaá‰es fedex */
                       IF  histor_tit_movto_ap.des_text_histor BEGINS "FEDEX" THEN DO:
                           ASSIGN i-cont-fedex = 0
                                  c-hist-aux   = ""
                                  c-num-fedex  = ""
                                  i-tamanho    = 0.

                           ASSIGN i-tamanho = LENGTH(histor_tit_movto_ap.des_text_histor).

                           ASSIGN c-hist-aux = substr(histor_tit_movto_ap.des_text_histor,8,i-tamanho).

                           DO  i-cont-fedex = 1 TO LENGTH(c-hist-aux):
                               IF  SUBSTR(c-hist-aux,i-cont-fedex,1) = "" THEN 
                                   LEAVE.
                               ELSE DO:
                                   ASSIGN c-num-fedex = c-num-fedex + SUBSTR(c-hist-aux,i-cont-fedex,1).
                               END.
                           END.
                       END.

                       IF  NUM-ENTRIES(histor_tit_movto_ap.des_text_histor,"|") > 1 THEN DO:
                           FIND tipo-acordo NO-LOCK
                               WHERE tipo-acordo.codigo = int(ENTRY(2,histor_tit_movto_ap.des_text_histor,"|")) NO-ERROR.
                           
                           IF  AVAIL tipo-acordo THEN
                               ASSIGN tt-dados.tipo-acordo-descricao = tipo-acordo.descricao.
                       END.

                   END.
            
                   /* tratamento para busca informaá‰es fedex */
                   IF  c-num-fedex <> "" THEN DO:
                       FIND FIRST fedex
                           WHERE fedex.numero = int(c-num-fedex) NO-LOCK NO-ERROR.
                        
                       IF  AVAIL fedex THEN
                           ASSIGN tt-dados.dt-venc-icms = fedex.dt-venc-icms
                                  tt-dados.num-sat      = fedex.num-sat.
                   END.

                   FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
            
                   IF AVAIL tit_ap THEN do: 
                       ASSIGN tt-dados.cod_espec_docto   = tit_ap.cod_espec_docto
                              tt-dados.cod_ser_docto     = tit_ap.cod_ser_docto
                              tt-dados.cod_tit_ap        = tit_ap.cod_tit_ap
                              tt-dados.cod_parcela       = tit_ap.cod_parcela
                              tt-dados.dat_vencto        = tit_ap.dat_vencto_tit_ap
                              tt-dados.dat_prev_pagto    = tit_ap.dat_prev_pagto 
                              tt-dados.cod_grp           = tit_ap.cod_grp_fornec
                              tt-dados.dat_emis_docto    = tit_ap.dat_emis_docto
                              tt-dados.cod_indic_econ    = tit_ap.cod_indic_econ. 

                        FIND vpc NO-LOCK
                            WHERE vpc.cod-estabel  = tit_ap.cod_estab
                              AND vpc.cod-emitente = tit_ap.cdn_fornec
                              AND vpc.nro-docto    = tit_ap.cod_tit_ap
                              AND vpc.serie-docto  = tit_ap.cod_ser_docto
                              AND vpc.cod-esp      = tit_ap.cod_espec_docto NO-ERROR.
                        IF  AVAIL vpc THEN DO:
                            ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + TRIM(vpc.observacoes) + " ".
                            FIND tipo-acordo NO-LOCK
                                WHERE tipo-acordo.codigo = vpc.tipo-acordo NO-ERROR.
                            IF  AVAIL tipo-acordo THEN
                                ASSIGN tt-dados.tipo-acordo-descricao = tipo-acordo.descricao.
                        END.
                   END.
               END.
           END.
        
           /* ** Movimentos Contas a Receber - ACR ***/
           IF l-ACR = YES 
           THEN DO:
               FOR EACH aprop_ctbl_acr NO-LOCK
                   WHERE aprop_ctbl_acr.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_acr.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_acr.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_acr.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_acr.dat_transacao      <= v_data_fim:
            
                   FIND FIRST movto_tit_acr NO-LOCK
                        WHERE movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
                          AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
                          AND movto_tit_acr.log_ctbz_aprop_ctbl  = YES NO-ERROR.
            
                   IF NOT AVAIL movto_tit_acr 
                      THEN NEXT.
            
                   FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
            
                   IF NOT AVAIL tit_acr 
                      THEN NEXT.
            
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                          tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "ACR"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_acr.dat_transacao
                          tt-dados.cod_espec_docto       = tit_acr.cod_espec_docto
                          tt-dados.cod_ser_docto         = tit_acr.cod_ser_docto
                          tt-dados.cod_tit_ap            = tit_acr.cod_tit_acr
                          tt-dados.cod_parcela           = tit_acr.cod_parcela
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_acr.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_acr.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_acr.cod_unid_negoc
                          tt-dados.dat_vencto            = tit_acr.dat_vencto_tit_acr
                          tt-dados.dat_vencto_origin     = tit_acr.dat_vencto_origin_tit_acr
                          tt-dados.dat_prev_pagto        = tit_acr.dat_prev_liquidac
                          tt-dados.cod_grp               = tit_acr.cod_grp_clien
                          tt-dados.dat_emis_docto        = tit_acr.dat_emis_docto
                          tt-dados.cod_indic_econ        = tit_acr.cod_indic_econ
                          tt-dados.ind_trans             = movto_tit_acr.ind_trans_acr_abrev
                          tt-dados.cod_portador          = movto_tit_acr.cod_portador
                          tt-dados.cod_carteira          = movto_tit_acr.cod_cart_bcia
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_acr.cod_usuario
                          tt-dados.dat_ult_atualiz       = movto_tit_acr.dat_gerac_movto
                          tt-dados.hra_ult_atualiz       = STRING(movto_tit_acr.hra_gerac_movto,"99:99:99")
                          tt-dados.log_contabilizado     = movto_tit_acr.log_aprop_ctbl_ctbzda
                          tt-dados.num-lancto            = movto_tit_acr.num_id_movto_tit_acr
                          tt-dados.num-lote              = tit_acr.cod_tit_acr.
        
                   /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                   if aprop_ctbl_acr.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_acr of aprop_ctbl_acr  
                            WHERE val_aprop_ctbl_acr.cod_finalid_econ = "Corrente" no-lock:
                            assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_acr.val_aprop.
                            IF val_aprop_ctbl_acr.val_cotac_indic_econ <> 0 
                               THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_acr.val_cotac_indic_econ.
                        end.
        
                        FIND val_movto_acr_correc_val OF movto_tit_acr NO-LOCK
                            WHERE val_movto_acr_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.
                        IF AVAIL val_movto_acr_correc_val 
                           THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_movto_acr_correc_val.val_cotac_indic_econ.
        
                   end.
            
                   FIND FIRST emscad.cliente NO-LOCK
                        WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                          AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.
            
                   IF AVAIL emscad.cliente  
                      THEN ASSIGN tt-dados.cod_emitente  = emscad.cliente.cdn_cliente
                                  tt-dados.nome_emitente = emscad.cliente.nom_pessoa.
            
                   FOR EACH histor_movto_tit_acr NO-LOCK 
                       WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                       AND   histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                       AND   histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr 
                       AND   histor_movto_tit_acr.ind_orig_histor_acr <> "Erro":

                       IF  histor_movto_tit_acr.des_text_histor BEGINS "convem" THEN
                           NEXT.
                       ELSE
                           ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + histor_movto_tit_acr.des_text_histor + " ".
                   END.
                   
               END.
           END.
        
           /* ** Movimentos Caixa e Bancos - CMG ***/
           IF l-CMG = YES 
           THEN DO:
               FOR EACH aprop_ctbl_cmg NO-LOCK
                   WHERE aprop_ctbl_cmg.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_cmg.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_cmg.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_cmg.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_cmg.dat_transacao      <= v_data_fim:
        
                    FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.
        
                    IF NOT AVAIL movto_cta_corren
                       THEN NEXT.
        
                    CREATE tt-dados.
                    ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                           tt-dados.cod_estab             = estabelecimento.cod_estab
                           tt-dados.origem                = "CMG"
                           tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_cmg.ind_natur_lancto_ctbl
                           tt-dados.dt_transacao          = aprop_ctbl_cmg.dat_transacao
                           tt-dados.cod_espec_docto       = ""
                           tt-dados.cod_ser_docto         = ""
                           tt-dados.cod_tit_ap            = ""
                           tt-dados.cod_parcela           = ""
                           tt-dados.cod_emitente          = 0
                           tt-dados.nome_emitente         = ""
                           tt-dados.val_aprop_ctbl        = aprop_ctbl_cmg.val_movto_cta_corren
                           tt-dados.cod_cta_ctbl          = aprop_ctbl_cmg.cod_cta_ctbl
                           tt-dados.cod_ccusto            = aprop_ctbl_cmg.cod_ccusto
                           tt-dados.cod_unid_negoc        = aprop_ctbl_cmg.cod_unid_negoc
                           tt-dados.des_lancto            = movto_cta_corren.des_histor_movto_cta_corren
                           tt-dados.cod_usuar_ult_atualiz = movto_cta_corren.cod_usuar_ult_atualiz
                           tt-dados.dat_ult_atualiz       = movto_cta_corren.dat_ult_atualiz
                           tt-dados.hra_ult_atualiz       = STRING(movto_cta_corren.hra_ult_atualiz,"99:99:99")
                           tt-dados.cod_indic_econ        = movto_cta_corren.cod_indic_econ
                           tt-dados.log_contabilizado     = aprop_ctbl_cmg.log_ctbz_movto_cta_corren
                           tt-dados.num-lancto            = movto_cta_corren.num_id_movto_cta_corren
                           tt-dados.num-lote              = "0".
        
                    /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                    if aprop_ctbl_cmg.cod_indic_econ <> 'real'
                    then do:
                         assign tt-dados.val_aprop_ctbl = 0.
                         for each val_aprop_ctbl_cmg of aprop_ctbl_cmg  
                            WHERE val_aprop_ctbl_cmg.cod_finalid_econ = "Corrente" no-lock:
                             assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_cmg.val_movto_cta_corren
                                    tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_cmg.val_cotac_indic_econ.
                         end.
                    end.
        
               END.
           END.
    
           /* ** Movimentos Faturamento - FAT ***/
           IF l-FTP = YES 
           THEN DO:
               DO i-data = v_data_ini TO v_data_fim:
        
                    FOR EACH sumar-ft NO-LOCK
                        WHERE sumar-ft.cod-estabel   = estabelecimento.cod_estab
                          AND sumar-ft.dt-movto      = i-data
                          AND sumar-ft.ct-conta BEGINS p_cod_cta_ctbl:
        
                          FIND FIRST nota-fiscal NO-LOCK
                               WHERE nota-fiscal.cod-estabel = sumar-ft.cod-estabel
                                 AND nota-fiscal.serie       = sumar-ft.serie
                                 AND nota-fiscal.nr-nota-fis = sumar-ft.nr-nota-fis NO-ERROR.
        
                          ASSIGN c-desc-sit = IF nota-fiscal.ind-sit-nota > 1              THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.dt-confirm <> ?  THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.dt-cancela <> ?  THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.dt-atual-cr <> ? THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.dt-at-ofest <> ? THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.dt-at-est <> ?   THEN "S" ELSE "N"
                                 c-desc-sit = c-desc-sit + IF nota-fiscal.ind-contabil     THEN "S" ELSE "N". 
    
                          CREATE tt-dados.
                          ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                                 tt-dados.cod_estab             = sumar-ft.cod-estabel
                                 tt-dados.origem                = "FTP"
                                 tt-dados.ind_natur_lancto_ctbl = IF sumar-ft.vl-contab > 0 THEN "CR" ELSE "DB"
                                 tt-dados.cod_emitente          = nota-fiscal.cod-emitente
                                 tt-dados.dt_transacao          = sumar-ft.dt-movto
                                 tt-dados.cod_espec_docto       = string(nota-fiscal.esp-docto)
                                 tt-dados.cod_ser_docto         = nota-fiscal.serie
                                 tt-dados.cod_tit_ap            = string(nota-fiscal.nr-nota-fis)
                                 tt-dados.cod_parcela           = "0"
                                 tt-dados.nat-operacao          = nota-fiscal.nat-operacao
                                 tt-dados.val_aprop_ctbl        = IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN (sumar-ft.vl-contab * -1) ELSE sumar-ft.vl-contab
                                 tt-dados.cod_cta_ctbl          = p_cod_cta_ctbl
                                 tt-dados.cod_ccusto            = sumar-ft.sc-conta
                                 tt-dados.cod_unid_negoc        = sumar-ft.cod-unid-negoc
                                 tt-dados.cod_usuar_ult_atualiz = nota-fiscal.user-calc
                                 tt-dados.dat_ult_atualiz       = nota-fiscal.dt-emis-nota
                                 tt-dados.hra_ult_atualiz       = nota-fiscal.hr-atualiza
                                 tt-dados.IECFOAT               = c-desc-sit
                                 tt-dados.log_contabilizado     = nota-fiscal.ind-contabil
                                 tt-dados.num-lancto            = RECID(nota-fiscal)
                                 tt-dados.num-lote              = "0".
            
                          IF tt-dados.cod_unid_negoc <> "" 
                          THEN DO:
                               FIND unid_negoc NO-LOCK
                                  WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                               IF AVAIL unid_negoc 
                                  THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                          END.
                          
                          FIND emitente NO-LOCK 
                              WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                          IF AVAIL emitente 
                             THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit
                                         tt-dados.uf_emitente = emitente.estado.

                          FIND FIRST pagto-vpc NO-LOCK
                              WHERE pagto-vpc.cod-estab-nf   = nota-fiscal.cod-estabel
                                AND pagto-vpc.nr-nota-fis    = nota-fiscal.nr-nota-fis
                                AND pagto-vpc.serie          = nota-fiscal.serie NO-ERROR.

                          IF  AVAIL pagto-vpc THEN DO:
                              FIND vpc NO-LOCK
                                  WHERE vpc.nr-vpc = pagto-vpc.nr-vpc NO-ERROR.
                              IF  AVAIL vpc THEN DO:
                                  ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + TRIM(vpc.observacoes) + " ".
                                  FIND tipo-acordo NO-LOCK
                                      WHERE tipo-acordo.codigo = vpc.tipo-acordo NO-ERROR.
                                  IF  AVAIL tipo-acordo THEN
                                      ASSIGN tt-dados.tipo-acordo-descricao = tipo-acordo.descricao.
                              END.
                          END.

                    END.
               END.

           END.

       END.
   END.

   DO i-data = v_data_ini TO v_data_fim:

      IF  l-estoque = NO 
      AND l-APL = YES
      THEN DO:

          /*** Movimentos Aplicaá∆o e EmprÇstimos - APL ***/
          FOR EACH aprop_ctbl_apl NO-LOCK
              WHERE aprop_ctbl_apl.cod_empresa        = v_cod_empres_usuar
              AND   aprop_ctbl_apl.dat_transacao      = i-data
              AND   aprop_ctbl_apl.cod_plano_cta_ctbl = "PADRAO"
              AND   aprop_ctbl_apl.cod_cta_ctbl       = p_cod_cta_ctbl:
    
              IF  aprop_ctbl_apl.cod_cenar_ctbl <> v_cod_cenar_ctbl
              AND aprop_ctbl_apl.cod_cenar_ctbl <> "" THEN 
                  NEXT.

              FIND FIRST movto_operac_financ OF aprop_ctbl_apl NO-LOCK NO-ERROR.
    
              IF NOT AVAIL movto_operac_financ THEN NEXT.
    
              IF (movto_operac_financ.ind_tip_trans_apl = "Variaá∆o Cambial"
              OR  movto_operac_financ.ind_tip_trans_apl = "Transf Var Cambial"
              OR  movto_operac_financ.ind_tip_trans_apl = "Transf VC Juros"
              OR  movto_operac_financ.ind_tip_trans_apl = "Var Cambial Juros"
              OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Juros Compet"
              OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Competància")
              AND movto_operac_financ.cod_indic_econ   <>  "Real" 
                  THEN NEXT.
    
              FIND operac_financ OF movto_operac_financ NO-LOCK NO-ERROR.
    
              IF NOT AVAIL operac_financ 
                 THEN NEXT.
    
              CREATE tt-dados.
              ASSIGN tt-dados.cod_empresa           = aprop_ctbl_apl.cod_empresa
                     tt-dados.cod_estab             = aprop_ctbl_apl.cod_estab
                     tt-dados.origem                = "APL"
                     tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_apl.ind_natur_lancto_ctbl
                     tt-dados.dt_transacao          = aprop_ctbl_apl.dat_transacao
                     tt-dados.cod_espec_docto       = ""
                     tt-dados.cod_ser_docto         = ""
                     tt-dados.cod_tit_ap            = ""
                     tt-dados.cod_parcela           = ""
                     tt-dados.cod_emitente          = 0
                     tt-dados.nome_emitente         = ""
                     tt-dados.val_aprop_ctbl        = 0
                     tt-dados.cod_cta_ctbl          = aprop_ctbl_apl.cod_cta_ctbl
                     tt-dados.cod_ccusto            = ""
                     tt-dados.cod_unid_negoc        = aprop_ctbl_apl.cod_unid_negoc
                     tt-dados.des_lancto            = "Banco: " + operac_financ.cod_banco + ". Produto: " + operac_financ.cod_produt_financ + ". Operaá∆o: " + operac_financ.cod_operac_financ + ". Transaá∆o: " + movto_operac_financ.ind_tip_trans_apl + "."
                     tt-dados.cod_usuar_ult_atualiz = movto_operac_financ.cod_usuario
                     tt-dados.dat_ult_atualiz       = movto_operac_financ.dat_movto_apl
                     tt-dados.hra_ult_atualiz       = STRING(movto_operac_financ.hra_movto_apl,"99:99:99")
                     tt-dados.cod_indic_econ        = operac_financ.cod_indic_econ
                     tt-dados.log_contabilizado     = movto_operac_financ.log_aprop_ctbl_ctbzda
                     tt-dados.num-lancto            = movto_operac_financ.num_id_movto_operac_financ
                     tt-dados.num-lote              = "0".
    
              FIND val_aprop_ctbl_apl NO-LOCK 
                 WHERE val_aprop_ctbl_apl.num_id_movto_operac_financ = aprop_ctbl_apl.num_id_movto_operac_financ
                   AND val_aprop_ctbl_apl.num_seq_aprop_ctbl         = aprop_ctbl_apl.num_seq_aprop_ctbl
                   AND val_aprop_ctbl_apl.cod_finalid_econ           = "Corrente" NO-ERROR.
              IF AVAIL val_aprop_ctbl_apl 
                 THEN ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_apl.val_aprop_ctbl.
    
              IF tt-dados.val_aprop_ctbl = 0
              THEN DO:    
                   IF  movto_operac_financ.ind_tip_trans_apl <> "Variaá∆o Cambial"
                   AND movto_operac_financ.ind_tip_trans_apl <> "Transf Var Cambial"
                   AND movto_operac_financ.ind_tip_trans_apl <> "Transf VC Juros"
                   AND movto_operac_financ.ind_tip_trans_apl <> "Var Cambial Juros"
                   AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Juros Compet"
                   AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Competància"
                   AND movto_operac_financ.cod_indic_econ    <> "Real"   
                   THEN DO:
                        RUN pi_converter_indic_econ_finalid_apl (INPUT movto_operac_financ.cod_indic_econ,
                                                                 INPUT "1",
                                                                 INPUT movto_operac_financ.dat_transacao,
                                                                 INPUT aprop_ctbl_apl.val_aprop_indic_econ_movto,
                                                                 INPUT "Corrente",
                                                                 OUTPUT v_cod_return).
                        FIND FIRST tt_converter_finalid_econ_apl NO-LOCK NO-ERROR. 
                        IF AVAIL tt_converter_finalid_econ_apl 
                           THEN ASSIGN tt-dados.val_aprop_ctbl       = tt_converter_finalid_econ_apl.tta_val_transacao
                                       tt-dados.val_cotac_indic_econ = tt_converter_finalid_econ_apl.tta_val_cotac_indic_econ.
                   END.
              END. 
    
              IF tt-dados.val_aprop_ctbl = 0
                 THEN ASSIGN tt-dados.val_aprop_ctbl = aprop_ctbl_apl.val_aprop_indic_econ_movto.
    
              FIND FIRST tax_movto_operac_financ NO-LOCK 
                 WHERE tax_movto_operac_financ.num_id_movto_operac_financ = movto_operac_financ.num_id_movto_operac_financ NO-ERROR.
              IF AVAIL tax_movto_operac_financ 
                 THEN ASSIGN tt-dados.val_cotac_indic_econ = (1 / tax_movto_operac_financ.val_cotac_indic_econ_fim)
                             /*tt-dados.cod_indic_econ       = tax_movto_operac_financ.cod_indic_econ_tax_pos*/.
    
          END.
      END.
   END.
  
END.
/********************  End of rpt_motiv_movto_tit_acr_dem *******************/

/*apl301za*/
PROCEDURE pi_converter_indic_econ_finalid_apl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_erro_compos_armaz
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_erro_compos_organ
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cotaá∆o"
        column-label "Data Cotaá∆o"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cotaá∆o"
        column-label "Cotaá∆o"
        no-undo.
    def var v_log_existe_compos              as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    elimina:
    for each tt_converter_finalid_econ_apl exclusive-lock:
        delete tt_converter_finalid_econ_apl.
    end.

    find first compos_finalid no-lock 
         where compos_finalid.cod_indic_econ_base = p_cod_indic_econ 
           and compos_finalid.cod_finalid_econ    = p_cod_finalid_econ 
           and compos_finalid.dat_inic_valid     <= p_dat_transacao 
           and compos_finalid.dat_fim_valid      >  p_dat_transacao 
         use-index cmpsfnld_parid_indic_econ no-error. 
    if  not avail compos_finalid
    then do: 
        assign p_cod_return = "782". 
        return. 
    end.

    if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
    then do: 

        find first compos_finalid_cmcmm no-lock 
              where compos_finalid_cmcmm.cod_finalid_econ       = compos_finalid.cod_finalid_econ 
                and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid 
                and compos_finalid_cmcmm.cod_indic_econ_base    = compos_finalid.cod_indic_econ_base 
                and compos_finalid_cmcmm.cod_indic_econ_idx     = compos_finalid.cod_indic_econ_idx 
                and compos_finalid_cmcmm.dat_inic_valid_compos  = compos_finalid.dat_inic_valid 
                and compos_finalid_cmcmm.dat_inic_valid        <= p_dat_transacao 
                and compos_finalid_cmcmm.dat_fim_valid         >  p_dat_transacao no-error. 

         if  avail compos_finalid_cmcmm
         then do: 
              run pi_achar_cotac_indic_econ (Input compos_finalid.cod_indic_econ_base,
                                             Input compos_finalid.cod_indic_econ_idx,
                                             Input p_dat_transacao,
                                             Input "Real",
                                             output v_dat_cotac_indic_econ,
                                             output v_val_cotac_indic_econ,
                                             output v_cod_return). 
              if  entry(1,v_cod_return) = "358"
              then do: 
                  elimina:
                  for each tt_converter_finalid_econ_apl exclusive-lock: 
                      delete tt_converter_finalid_econ_apl. 
                  end. 
                  assign p_cod_return = v_cod_return. 
                  return. 
              end. 
              create tt_converter_finalid_econ_apl. 
              assign tt_converter_finalid_econ_apl.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ 
                     tt_converter_finalid_econ_apl.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_cotac_indic_econ = v_val_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ.

         end. 
    end. 

    assign p_cod_return = "OK".

END PROCEDURE.


PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id no-error.
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.

/*            
            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
*/            
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */

PROCEDURE pi-desp-asc:
    FOR FIRST despesa-aces
        WHERE despesa-aces.ser-docto-ac  = doc-fiscal.serie
          AND despesa-aces.nro-docto-ac  = doc-fiscal.nr-doc-fis
          AND despesa-aces.cod-forn-ac   = doc-fiscal.cod-emitente
          AND despesa-aces.nat-oper-ac   = doc-fiscal.nat-operacao no-LOCK:


          ASSIGN tt-dados.nf-desp-aces   = despesa-aces.nro-docto
                 tt-dados.serie-desp     = despesa-aces.serie-doc
                 tt-dados.nat-oper-desp  = despesa-aces.nat-operacao.

    END.
END.
  
PROCEDURE pi-desmembra-narrativa:
    DEF INPUT PARAMETER p-narrativa LIKE item-doc-est.narrativa NO-UNDO. 

    IF  (p-narrativa <> "")
    AND (p-narrativa MATCHES "*/*")
    AND (NUM-ENTRIES(p-narrativa, "/") > 7) THEN DO:

        ASSIGN tt-dados.NF-Item-Orig-Frete  = ENTRY(6, p-narrativa, "/")
               tt-dados.Orig-Frete-nota     = ENTRY(1, p-narrativa, "/")
               tt-dados.Orig-Frete-serie    = ENTRY(2, p-narrativa, "/")
               tt-dados.Orig-Frete-emit     = INT(ENTRY(3, p-narrativa, "/"))
               tt-dados.Orig-Frete-cfop     = ENTRY(4, p-narrativa, "/")
               tt-dados.Orig-Frete-seq      = INT(ENTRY(5, p-narrativa, "/"))  
               tt-dados.Val-Item-Orig-Frete = DEC(ENTRY(8, p-narrativa, "/")) NO-ERROR.        

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = ENTRY(7, p-narrativa, "/")
            AND   nota-fiscal.serie       = ENTRY(2, p-narrativa, "/")
            AND   nota-fiscal.nr-nota-fis = ENTRY(1, p-narrativa, "/"):

            ASSIGN tt-dados.Orig-Dt-Emis = nota-fiscal.dt-emis-nota
                   tt-dados.Orig-UF-Dest = nota-fiscal.estado NO-ERROR.
        END.
    END.      

END PROCEDURE.

PROCEDURE pi-verifica-nf-frete:
    DEF INPUT PARAMETER p-cod-estabel   LIKE doc-fiscal.cod-estabel   NO-UNDO.
    DEF INPUT PARAMETER p-nr-doc-fis    LIKE it-doc-fisc.nr-doc-fis   NO-UNDO. 
    DEF INPUT PARAMETER p-serie         LIKE it-doc-fisc.serie        NO-UNDO.
    DEF INPUT PARAMETER p-cod-emitente  LIKE it-doc-fisc.cod-emitente NO-UNDO.
    DEF INPUT PARAMETER p-it-codigo     LIKE it-doc-fisc.it-codigo    NO-UNDO.
    DEF INPUT PARAMETER p-nr-seq-doc    LIKE it-doc-fisc.nr-seq-doc   NO-UNDO. 

    DEF VAR c-estab        LIKE nota-fiscal.cod-estabel  NO-UNDO.
    DEF VAR c-valor        LIKE it-nota-fisc.vl-tot-item NO-UNDO.
    DEF VAR c-item         LIKE ITEM.it-codigo           NO-UNDO.

    DEF BUFFER item-doc-est FOR item-doc-est.
    DEF BUFFER it-nota-fisc FOR it-nota-fisc.


    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.nro-docto    = p-nr-doc-fis  
          AND item-doc-est.serie-docto  = p-serie         
          AND item-doc-est.cod-emitente = p-cod-emitente  
          AND item-doc-est.it-codigo    = p-it-codigo
          AND item-doc-est.sequencia    = p-nr-seq-doc:

    END.
    
    IF AVAIL item-doc-est AND item-doc-est.narrativa <> "" AND 
         item-doc-est.narrativa MATCHES "*/*" THEN DO:


       IF NUM-ENTRIES(item-doc-est.narrativa,"/") > 5 THEN DO:

          ASSIGN c-nota  = ENTRY(1,item-doc-est.narrativa,"/")
                 c-serie = ENTRY(2,item-doc-est.narrativa,"/")
                 c-emit  = ENTRY(3,item-doc-est.narrativa,"/")
                 c-cfop  = ENTRY(4,item-doc-est.narrativa,"/")
                 c-seq   = ENTRY(5,item-doc-est.narrativa,"/")
                 c-item  = ENTRY(6,item-doc-est.narrativa,"/").

          IF NUM-ENTRIES(item-doc-est.narrativa,"/") > 7 THEN
             ASSIGN c-estab = ENTRY(7,item-doc-est.narrativa,"/")
                    c-valor = DEC(ENTRY(8,item-doc-est.narrativa,"/")).
       END.
       ELSE DO:
           /*
           IF p-nr-doc-fis = "0015528" THEN DO:

               MESSAGE
                   item-doc-est.narrativa SKIP
                   ENTRY(1,item-doc-est.narrativa,"/") SKIP
                   NUM-ENTRIES(item-doc-est.narrativa,"/")
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           END.
           */
           ASSIGN c-nota = "".
       END.

       IF c-nota <> "" THEN DO:
           ASSIGN tt-dados.NF-Item-Orig-Frete  = c-item 
                  tt-dados.Orig-Frete-nota     = c-nota  
                  tt-dados.Orig-Frete-serie    = c-serie 
                  tt-dados.Orig-Frete-emit     = INT(c-emit)
                  tt-dados.Orig-Frete-cfop     = c-cfop  
                  tt-dados.Orig-Frete-seq      = INT(c-seq)  
                  tt-dados.Val-Item-Orig-Frete = c-valor.
       END.
    END.

       /*


          FIND FIRST it-nota-fisc NO-LOCK 
               WHERE it-nota-fisc.cod-estabel = p-cod-estabel
                 AND it-nota-fisc.serie       = c-serie
                 AND it-nota-fisc.nr-nota-fis = c-nota
                 AND it-nota-fisc.nr-seq-fat  = INT(c-seq) NO-ERROR.
          IF AVAIL it-nota-fisc THEN
             ASSIGN tt-dados.NF-Item-Orig-Frete  = TRIM(it-nota-fisc.it-codigo) 
                    tt-dados.Orig-Frete-nota     = c-nota  
                    tt-dados.Orig-Frete-serie    = c-serie 
                    tt-dados.Orig-Frete-emit     = INT(c-emit)
                    tt-dados.Orig-Frete-cfop     = c-cfop  
                    tt-dados.Orig-Frete-seq      = INT(c-seq)  
                    tt-dados.Val-Item-Orig-Frete = it-nota-fisc.vl-tot-item.
          ELSE DO:
              FIND FIRST item-doc-est NO-LOCK 
                   WHERE item-doc-est.cod-emitente = INT(c-emit)
                     AND item-doc-est.serie-docto  = c-serie
                     AND item-doc-est.nro-docto    = c-nota
                     AND item-doc-est.sequencia    = INT(c-seq) NO-ERROR.
              IF AVAIL item-doc-est THEN
                 ASSIGN tt-dados.NF-Item-Orig-Frete  = TRIM(item-doc-est.it-codigo)
                        tt-dados.Orig-Frete-nota     = c-nota  
                        tt-dados.Orig-Frete-serie    = c-serie 
                        tt-dados.Orig-Frete-emit     = INT(c-emit)
                        tt-dados.Orig-Frete-cfop     = c-cfop  
                        tt-dados.Orig-Frete-seq      = INT(c-seq)  
                        tt-dados.Val-Item-Orig-Frete = item-doc-est.preco-total[1].

          END.
       END.
       */


END PROCEDURE.
