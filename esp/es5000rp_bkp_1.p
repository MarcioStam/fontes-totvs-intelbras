/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES5000RP 2.00.00.000}  /*** 010000 ***/
{include/i_fnctrad.i}
/*******************************************************************************
**
**  Programa: ES5000RP.P
**
**  Autor...: DATASUL S.A.
**
**  Objetivo: Contabiliza‡Æo do Contas a Pagar
**
*******************************************************************************/
/* y2kready */


{utp/ut-glob.i}
{include/i-rpvar.i}

/* MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}
{include/i_dbtype.i}

/******************************* Temp Table Definition ************************/

{esp/es5000.i}

DEF VAR da-data-ini LIKE tt-param.da-data-ini NO-UNDO.
DEF VAR da-data-fim LIKE tt-param.da-data-fim NO-UNDO.
 
DEF VAR da-data AS DATE NO-UNDO.
DEFINE VARIABLE v_cod_return AS CHARACTER   NO-UNDO.

/******************************* Parameter Definition *************************/

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

/********************************* Frame Definition ***************************/

def NEW SHARED var h-acomp     as handle no-undo.

run utp/ut-acomp.p persistent set h-acomp.

DEF VAR c-time-ini AS CHAR.
DEF VAR c-time-fim AS CHAR.

FORM
    c-time-ini LABEL "Hora Inicio"
    c-time-fim LABEL "Hora Fim"
    WITH DOWN NO-BOX NO-ATTR WIDTH 132 STREAM-IO FRAME f-time.

form
    movto_real_orcto.cod_empresa               COLUMN-LABEL "Emp"
    movto_real_orcto.cod_estab                 COLUMN-LABEL "Est"
    movto_real_orcto.cod_cta_ctbl              COLUMN-LABEL "Cta"
    movto_real_orcto.cod_ccusto                COLUMN-LABEL "C.Custo"
    movto_real_orcto.cod_origem                COLUMN-LABEL "Origem"
    movto_real_orcto.ind_natur_lancto_ctbl     COLUMN-LABEL "DB\CR"
    movto_real_orcto.num_period_ctbl           COLUMN-LABEL "Per¡odo"
    movto_real_orcto.cod_exerc_ctbl            COLUMN-LABEL "Exerc¡cio"
    movto_real_orcto.val_rea                   COLUMN-LABEL "Movimento"
    movto_real_orcto.val_orcado_per            COLUMN-LABEL "OR‡amento"
    with down no-box no-attr width 132 stream-io frame f-corpo.


def temp-table tt_converter_finalid_econ_apl no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota»’o" column-label "Data Cota»’o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»’o" column-label "Cota»’o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transa»’o" column-label "Transa»’o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje»’o" column-label "G/P Proje»’o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers’o" column-label "Forma Convers’o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros_apl_1              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm_apl                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Corre»’o Monetÿria" column-label "Corre»’o Monetÿria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".


create tt-param.
raw-transfer raw-param to tt-param.

CASE trim(tt-param.c-periodo):
    WHEN "1" THEN
        ASSIGN tt-param.da-data-ini = DATE(MONTH(TODAY),1,YEAR(TODAY))
               tt-param.da-data-fim = DATE(MONTH(TODAY) + 1,1,YEAR(TODAY)) - 1.
    WHEN "2" THEN
        ASSIGN tt-param.da-data-ini = DATE(MONTH(TODAY) - 1,1,YEAR(TODAY))        
               tt-param.da-data-fim = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1  .
END CASE.
 
ASSIGN da-data-ini = tt-param.da-data-ini
       da-data-fim = tt-param.da-data-fim.



find first param-global no-lock no-error.
find mgcad.empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

assign c-empresa  = empresa.razao-social
       c-programa = "ES/5000".

{utp/ut-liter.i OR€AMENTO * C}
assign c-sistema = trim(return-value).
{utp/ut-liter.i Contabilidade * C}
assign c-titulo-relat = trim(return-value).

{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape. 

DEF VAR c-per-ini   AS CHAR.
DEF VAR c-per-fim   AS CHAR.
def var da-iniper-1 AS DATE.
def var da-fimper-1 AS DATE.
def var da-iniper-2 AS DATE.
def var da-fimper-2 AS DATE.
def var i-per-corrente AS INT.
def var i-ano-corrente AS INT.
def var da-iniper-fech AS DATE.
def var da-fimper-fech AS DATE.

DEF VAR c_cod_cenar_ctbl AS CHAR NO-UNDO.


ASSIGN c_cod_cenar_ctbl = tt-param.c-cod-cenar-ctbl.

{utp/ut-liter.i Relat½rio * r}
run pi-inicializar in h-acomp (input return-value).

EMPTY TEMP-TABLE tt-movto.

ASSIGN c-time-ini = string(TIME,"HH:MM:SS").

FIND emscad.empresa
    WHERE emscad.empresa.cod_empresa = tt-param.c-emp
    NO-LOCK NO-ERROR.

IF  AVAIL emscad.empresa THEN DO:    
    RUN pi-carrega-cta-cc (INPUT emscad.empresa.cod_empresa,
                           INPUT tt-param.c-est-ini,
                           INPUT tt-param.c-est-fim,
                           INPUT tt-param.c-cod-plano-cta,
                           INPUT tt-param.c-cod-plano-cta).

    RUN pi-elimina-movto (INPUT emscad.empresa.cod_empresa,
                          INPUT tt-param.c-est-ini,
                          INPUT tt-param.c-est-fim,
                          INPUT tt-param.c-cod-cenar-ctbl,
                          INPUT tt-param.da-data-ini,
                          INPUT tt-param.da-data-fim).

    RUN pi-carrega-tt-movto (INPUT emscad.empresa.cod_empresa,
                             INPUT tt-param.c-est-ini,
                             INPUT tt-param.c-est-fim,
                             INPUT tt-param.da-data-ini,
                             INPUT tt-param.da-data-fim).
  
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empres = emscad.empresa.cod_empresa:

        FOR EACH tt-cc  
            WHERE tt-cc.cod-estab = estabelecimento.cod_estab
            NO-LOCK:
        
            FOR EACH tt-conta NO-LOCK:
    
                RUN pi-cria-movimentos (INPUT estabelecimento.cod_estab,
                                        INPUT tt-param.c-cod-plano-cta,                 
                                        INPUT tt-conta.cod_cta_ctbl,    
                                        INPUT tt-cc.cc-codigo,       
                                        INPUT da-data-ini,    
                                        INPUT da-data-fim,          
                                        INPUT c_cod_cenar_ctbl).
        
                RUN pi-movimento-estoq (INPUT estabelecimento.cod_estab,   
                                        INPUT tt-param.c-cod-plano-cta,     
                                        INPUT tt-cc.cc-codigo, 
                                        INPUT tt-param.c-cod-plano-cta).                                                          
            END.        
        END.
    END.
END.
RUN pi-atualiza-real.

RUN pi-finalizar IN h-acomp.

ASSIGN c-time-fim = string(TIME,"HH:MM:SS").

DISP c-time-ini
     c-time-fim
    WITH FRAME f-time.
DOWN WITH FRAME f-time.

{include/i-rpclo.i}


PROCEDURE pi-atualiza-real:
    run pi-acompanhar in h-acomp (input  "Atualizando/Imprimindo...").     
    FOR EACH tt-dados NO-LOCK:

        FIND movto_real_orcto
            WHERE movto_real_orcto.cod_empresa           = tt-dados.cod_empresa
            AND   movto_real_orcto.cod_estab             = tt-dados.cod_estab   
            AND   movto_real_orcto.cod_cenar_ctbl        = tt-dados.cod_cenar_ctbl
            AND   movto_real_orcto.cod_plano_cta_ctbl    = tt-dados.cod_plano_cta_ctbl
            AND   movto_real_orcto.cod_plano_ccusto      = tt-dados.cod_plano_cc
            AND   movto_real_orcto.cod_cta_ctbl          = tt-dados.cod_cta_ctbl   
            AND   movto_real_orcto.cod_ccusto            = tt-dados.cod_ccusto 
            AND   movto_real_orcto.cod_unid_negoc        = tt-dados.cod_unid_negoc
            AND   movto_real_orcto.cod_proj_financ       = tt-dados.cod_proj
            AND   movto_real_orcto.cod_exerc_ctbl        = string(YEAR(tt-dados.dt_transacao)) 
            AND   movto_real_orcto.num_period_ctbl       = string(MONTH(tt-dados.dt_transacao),"99")
            AND   movto_real_orcto.cod_origem            = tt-dados.origem 
            AND   movto_real_orcto.ind_natur_lancto_ctbl = tt-dados.ind_natur_lancto_ctbl
            EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL  movto_real_orcto THEN DO:
        

            CREATE movto_real_orcto.
            ASSIGN movto_real_orcto.cod_ccusto            = tt-dados.cod_ccusto        
                   movto_real_orcto.cod_cenar_ctbl        = tt-dados.cod_cenar_ctbl    
                   movto_real_orcto.cod_cta_ctbl          = tt-dados.cod_cta_ctbl      
                   movto_real_orcto.cod_empresa           = tt-dados.cod_empresa
                   movto_real_orcto.ind_natur_lancto_ctbl = tt-dados.ind_natur_lancto_ctbl.
            ASSIGN movto_real_orcto.cod_estab             = tt-dados.cod_estab         
                   movto_real_orcto.cod_exerc_ctbl        = string(YEAR(tt-dados.dt_transacao))
                   movto_real_orcto.cod_origem            = tt-dados.origem        
                   movto_real_orcto.cod_plano_ccusto      = tt-dados.cod_plano_cc  
                   movto_real_orcto.cod_plano_cta_ctbl    = tt-dados.cod_plano_cta_ctbl.
            ASSIGN movto_real_orcto.cod_proj_financ       = tt-dados.cod_projeto
                   movto_real_orcto.cod_unid_negoc        = tt-dados.cod_unid_negoc    
                   movto_real_orcto.num_period_ctbl       = string(MONTH(tt-dados.dt_transacao),"99")
                   movto_real_orcto.val_realiz_per        = tt-dados.val_aprop_ctbl .

            CASE movto_real_orcto.cod_origem:
                WHEN "CEP" THEN
                    ASSIGN movto_real_orcto.des_historicao = tt-dados.des_histo +  " Movto.estoque data.: " + STRING(tt-dados.dt_transacao) + " Nr. Documento " + tt-dados.cod_tit_ap.
                WHEN "FGL" THEN
                    ASSIGN movto_real_orcto.des_historicao = tt-dados.des_histo +  " Movto.cont bil manual.: " + STRING(tt-dados.dt_transacao) + " Nr. Documento " + tt-dados.cod_tit_ap.
                WHEN "ACR" THEN
                    ASSIGN movto_real_orcto.des_historicao = tt-dados.des_histo +  " Movto.doctos a receber.: " + STRING(tt-dados.dt_transacao) + " Nr. Documento " + tt-dados.cod_tit_ap.
                WHEN "APB" THEN
                    ASSIGN movto_real_orcto.des_historicao = tt-dados.des_histo +  " Movto.doctos a pagar.: " + STRING(tt-dados.dt_transacao) + " Nr. Documento " + tt-dados.cod_tit_ap.
            END CASE.

            FIND PARAM_orcto
                WHERE PARAM_orcto.dt_inicio <= tt-dados.dt_transacao
                AND   PARAM_orcto.dt_final  >= tt-dados.dt_transacao
                NO-LOCK NO-ERROR.

            IF  AVAIL PARAM_orcto THEN DO:
                FIND sdo_orcto_ctbl_bgc 
                    WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario  = PARAM_orcto.cod_cenar_orcto
                      AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = PARAM_orcto.cod_unid_orcta
                      AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = movto_real_orcto.cod_cenar_ctbl
                      AND sdo_orcto_ctbl.num_seq_orcto_ctbl      = param_orcto.num_seq_orcto_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl  = movto_real_orcto.cod_plano_cta_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = movto_real_orcto.cod_plano_ccusto
                      AND sdo_orcto_ctbl_bgc.cod_estab           = movto_real_orcto.cod_estab 
                      AND sdo_orcto_ctbl_bgc.cod_empresa         = movto_real_orcto.cod_empresa
                      AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = movto_real_orcto.cod_exerc_ctbl
                      AND sdo_orcto_ctbl_bgc.num_period_ctbl     = int(movto_real_orcto.num_period_ctbl)
                      AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl = param_orcto.cod_vers_orcto_ctbl
                      AND sdo_orcto_ctbl.cod_cta_ctbl            = movto_real_orcto.cod_cta_ctbl
                      AND sdo_orcto_ctbl.cod_ccusto              = movto_real_orcto.cod_ccusto
                      AND sdo_orcto_ctbl.cod_unid_negoc          = movto_real_orcto.cod_unid_negoc
                      AND sdo_orcto_ctbl.cod_proj                = movto_real_orcto.cod_proj
                    NO-LOCK NO-ERROR.

                IF  AVAIL sdo_orcto_ctbl_bgc THEN DO:
                    ASSIGN movto_real_orcto.val_orcado_per = sdo_orcto_ctbl_bgc.val_orcado.
                END.

            END.
        END.
        ELSE DO:
            ASSIGN  movto_real_orcto.val_realiz_per  =  movto_real_orcto.val_realiz_per   +  tt-dados.val_aprop_ctbl.
        END.

        DISP movto_real_orcto.cod_empresa          
            movto_real_orcto.cod_estab      
            movto_real_orcto.cod_cta_ctbl   
            movto_real_orcto.cod_ccusto
            movto_real_orcto.cod_origem               
            movto_real_orcto.ind_natur_lancto_ctbl
            movto_real_orcto.num_period_ctbl 
            movto_real_orcto.cod_exerc_ctbl 
            movto_real_orcto.val_real   
            movto_real_orcto.val_orcado_per
            with frame f-corpo.
        DOWN WITH FRAME f-corpo.
    END.
END.

PROCEDURE pi-carrega-tt-movto:
    DEF INPUT PARAM c-ep-codigo   LIKE emscad.empresa.cod_empresa.
    DEF INPUT PARAM c-est-ini-m   LIKE movto-estoq.cod-estabel.
    DEF INPUT PARAM c-est-fim-m   LIKE movto-estoq.cod-estabel.
    DEF INPUT PARAM da-data-ini-m LIKE movto-estoq.dt-trans.
    DEF INPUT PARAM da-data-fim-m LIKE movto-estoq.dt-trans.

        
    FOR EACH estabelecimento NO-LOCK
        where estabelecimento.cod_emp    = c-ep-codigo
        AND   estabelecimento.cod_estab >= c-est-ini-m
        AND   estabelecimento.cod_estab <= c-est-fim-m:

        DO  da-data = da-data-ini-m TO  da-data-fim-m:

            run pi-acompanhar in h-acomp (input  "Carregando TT CEP.: " + string(da-data) + " Est.: " + estabelecimento.cod_estab).      
            
            
            FOR EACH movto-estoq NO-LOCK
                WHERE movto-estoq.cod-estabel = estabelecimento.cod_estab
                AND   movto-estoq.dt-trans    = da-data:

                CREATE tt-movto.
                BUFFER-COPY movto-estoq TO tt-movto.
            END.                    
        END.        
    END.    
END.

PROCEDURE pi-movimento-estoq:
    /* ** Movimentos Estoque - CEP ***/

    DEF INPUT PARAM c_cod_estab          LIKE tt-movto.cod-estabel.
    DEF INPUT PARAM c_cod_cta_ctbl       LIKE tt-movto.ct-codigo. 
    DEF INPUT PARAM c_cod_ccusto         LIKE tt-movto.sc-codigo.
    DEF INPUT PARAM c_cod_plano_cta_ctbl LIKE cta_ctbl.cod_plano_cta_ctbl .
                    
    DO  da-data = da-data-ini TO da-data-fim:
        FOR EACH tt-movto
            WHERE tt-movto.cod-estabel  = c_cod_estab
            AND   tt-movto.dt-trans     = da-data
            AND   tt-movto.ct-codigo    = c_cod_cta_ctbl 
            AND   tt-movto.sc-codigo    = c_cod_ccusto 
            NO-LOCK:
    
    
           CREATE tt-dados.
           ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                  tt-dados.cod_estabel           = tt-movto.cod-estabel
                  tt-dados.cod_cenar_ctbl        = tt-param.c-cod-cenar-ctb
                  tt-dados.cod_plano_cta_ctbl    = tt-movto.ct-codigo
                  tt-dados.cod_plano_cc          = "Padrao"
                  tt-dados.origem                = "CEP"
                  tt-dados.ind_natur_lancto_ctbl = IF tt-movto.tipo-trans = 1 THEN "CR" ELSE "DB"
                  tt-dados.cod_emitente          = tt-movto.cod-emitente
                  tt-dados.dt_transacao          = tt-movto.dt-trans
                  tt-dados.cod_espec_docto       = string(tt-movto.esp-docto)
                  tt-dados.cod_ser_docto         = tt-movto.serie
                  tt-dados.cod_tit_ap            = string(tt-movto.nro-docto)
                  tt-dados.cod_parcela           = "0"
                  tt-dados.cod_ccusto            = tt-movto.sc-codigo
                  tt-dados.val_aprop_ctbl        = tt-movto.valor-mat-m[1] +
                                                   tt-movto.valor-mob-m[1] +
                                                   tt-movto.valor-ggf-m[1].
    
           IF  tt-dados.val_aprop_ctbl = 0 THEN DO:
               find item-estab no-lock
                    where item-estab.cod-estabel = tt-movto.cod-estabel
                      and item-estab.it-codigo   = tt-movto.it-codigo no-error.
    
               if  avail item-estab then
                   assign tt-dados.val_aprop_ctbl = tt-movto.quantidade *
                                                    (item-estab.val-unit-mat-m[1]
                                                    + item-estab.val-unit-mob-m[1]
                                                    + item-estab.val-unit-ggf-m[1] ).
           END.
    
           FIND ITEM NO-LOCK WHERE ITEM.it-codigo = tt-movto.it-codigo.
    
           IF  tt-movto.cod-emitente <> 0  THEN DO:
               FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-movto.cod-emitente NO-ERROR.
    
               IF  AVAIL emitente THEN
                   ASSIGN tt-dados.nome_emitente = emitente.nome-emit.
    
           END.
           ELSE
               ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + tt-movto.usuario.
    
           run pi-acompanhar in h-acomp (input  "Atualizando.. CEP.: " + string(da-data)).      

           find item-doc-est no-lock
                where item-doc-est.serie-docto  = tt-movto.serie-docto
                  and item-doc-est.nro-docto    = tt-movto.nro-docto
                  and item-doc-est.cod-emitente = tt-movto.cod-emitente
                  and item-doc-est.nat-operacao = tt-movto.nat-operacao
                  and item-doc-est.sequencia    = tt-movto.sequen-nf no-error.
    
           IF  avail item-doc-est then
               assign tt-dados.nome_emitente = tt-dados.nome_emitente + " - Narrativa: " + item-doc-est.narrativa.
        END.
    END.
END.

PROCEDURE pi-elimina-movto:
    DEF INPUT PARAM c-cod-empres-del AS CHAR.
    DEF INPUT PARAM c-cod-est-i-del  AS CHAR.
    DEF INPUT PARAM c-cod-est-f-del  AS CHAR.
    DEF INPUT PARAM c-cod-cenar-ctbl AS CHAR.
    DEF INPUT PARAM da-data-inicial  AS DATE.
    DEF INPUT PARAM da-data-final    AS DATE.

    FOR EACH movto_real_orcto EXCLUSIVE-LOCK
        WHERE movto_real_orcto.cod_empres      = c-cod-empres-del
        AND   movto_real_orcto.cod_estab      >= c-cod-est-i-del
        AND   movto_real_orcto.cod_estab      <= c-cod-est-f-del
        AND   movto_real_orcto.cod_cenar_ctbl  = c-cod-cenar-ctbl
        AND   movto_real_orcto.cod_exerc_ctbl  = STRING(YEAR(da-data-inicial))
        AND   movto_real_orcto.num_period_ctbl = STRING(MONTH(da-data-inicial),"99"):

        DELETE movto_real_orcto.
    END.
END.   

PROCEDURE pi-cria-movimentos:
    DEF INPUT PARAMETER c_cod_estab            AS CHAR FORMAT "X(3)" NO-UNDO.
    DEF INPUT PARAMETER c_cod_plano_cta_ctbl   AS CHAR FORMAT "x(8)" NO-UNDO.
    DEF INPUT PARAMETER c_cod_cta_ctbl         AS CHAR FORMAT "x(8)" NO-UNDO.
    DEF INPUT PARAMETER c_cod_ccusto           AS CHAR FORMAT "X(8)" NO-UNDO.
    DEF INPUT PARAMETER d_dat_transacao_ini    AS DATE               NO-UNDO.
    DEF INPUT PARAMETER d_dat_transacao_fim    AS DATE               NO-UNDO.
    DEF INPUT PARAMETER c_cod_cenar_fiscal     AS CHAR               NO-UNDO.
    
    DEFINE VARIABLE v_cod_tip_calc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    ASSIGN v_cod_tip_calc = ";Deprec;Seguro;Amortiz;CM".
    
    /*--- Bloco Principal ---*/
    FIND FIRST estabelecimento NO-LOCK
        WHERE estabelecimento.cod_estab = c_cod_estab NO-ERROR.
    IF  NOT AVAIL estabelecimento THEN
        RETURN.
    
    /* apl */
/*                                                                                                                                                                                                                                                              */
/*     DO da-data = d_dat_transacao_ini TO d_dat_transacao_fim:                                                                                                                                                                                                 */
/*        FOR EACH aprop_ctbl_apl NO-LOCK                                                                                                                                                                                                                       */
/*            WHERE aprop_ctbl_apl.cod_estab          = estabelecimento.cod_estab                                                                                                                                                                               */
/*            AND   aprop_ctbl_apl.dat_transacao      = da-data                                                                                                                                                                                                 */
/*            AND   aprop_ctbl_apl.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl                                                                                                                                                                                    */
/*            AND   aprop_ctbl_apl.cod_cta_ctbl       = c_cod_cta_ctbl:                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                              */
/*            IF  aprop_ctbl_apl.cod_cta_ctbl < "40000000"                                                                                                                                                                                                      */
/*            AND aprop_ctbl_apl.cod_cta_ctbl > "41999999" THEN NEXT.                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                              */
/*            FIND FIRST movto_operac_financ OF aprop_ctbl_apl NO-LOCK NO-ERROR.                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                              */
/*            IF NOT AVAIL movto_operac_financ THEN                                                                                                                                                                                                             */
/*                NEXT.                                                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                              */
/*            IF (movto_operac_financ.ind_tip_trans_apl = "Varia‡Æoo Cambial"                                                                                                                                                                                   */
/*            OR  movto_operac_financ.ind_tip_trans_apl = "Transf Var Cambial"                                                                                                                                                                                  */
/*            OR  movto_operac_financ.ind_tip_trans_apl = "Transf VC Juros"                                                                                                                                                                                     */
/*            OR  movto_operac_financ.ind_tip_trans_apl = "Var Cambial Juros"                                                                                                                                                                                   */
/*            OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Juros Compet"                                                                                                                                                                                 */
/*            OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Competˆncia")                                                                                                                                                                                 */
/*            AND movto_operac_financ.cod_indic_econ   <>  "Real"  THEN NEXT.                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                              */
/*            FIND operac_financ OF movto_operac_financ NO-LOCK NO-ERROR.                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                              */
/*            IF NOT AVAIL operac_financ                                                                                                                                                                                                                        */
/*               THEN NEXT.                                                                                                                                                                                                                                     */
/*                                                                                                                                                                                                                                                              */
/*            CREATE tt-dados.                                                                                                                                                                                                                                  */
/*            ASSIGN tt-dados.cod_estab             = aprop_ctbl_apl.cod_estab                                                                                                                                                                                  */
/*                   tt-dados.origem                = "APL"                                                                                                                                                                                                     */
/*                   tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_apl.ind_natur_lancto_ctbl                                                                                                                                                                      */
/*                   tt-dados.dt_transacao          = aprop_ctbl_apl.dat_transacao                                                                                                                                                                              */
/*                   tt-dados.cod_espec_docto       = ""                                                                                                                                                                                                        */
/*                   tt-dados.cod_ser_docto         = ""                                                                                                                                                                                                        */
/*                   tt-dados.cod_tit_ap            = ""                                                                                                                                                                                                        */
/*                   tt-dados.cod_parcela           = ""                                                                                                                                                                                                        */
/*                   tt-dados.cod_emitente          = 0                                                                                                                                                                                                         */
/*                   tt-dados.nome_emitente         = ""                                                                                                                                                                                                        */
/*                   tt-dados.val_aprop_ctbl        = 0                                                                                                                                                                                                         */
/*                   tt-dados.cod_cta_ctbl          = aprop_ctbl_apl.cod_cta_ctbl                                                                                                                                                                               */
/*                   tt-dados.cod_ccusto            = ""                                                                                                                                                                                                        */
/*                   tt-dados.cod_unid_negoc        = aprop_ctbl_apl.cod_unid_negoc                                                                                                                                                                             */
/*                   tt-dados.des_historico         = "Banco: " + operac_financ.cod_banco + ". Produto: " + operac_financ.cod_produt_financ + ". Opera»’o: " + operac_financ.cod_operac_financ + ". Transa»’o: " + movto_operac_financ.ind_tip_trans_apl + ".". */
/*                                                                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                              */
/*            FIND val_aprop_ctbl_apl NO-LOCK                                                                                                                                                                                                                   */
/*               WHERE val_aprop_ctbl_apl.num_id_movto_operac_financ = aprop_ctbl_apl.num_id_movto_operac_financ                                                                                                                                                */
/*                 AND val_aprop_ctbl_apl.num_seq_aprop_ctbl         = aprop_ctbl_apl.num_seq_aprop_ctbl                                                                                                                                                        */
/*                 AND val_aprop_ctbl_apl.cod_finalid_econ           = "Corrente" NO-ERROR.                                                                                                                                                                     */
/*            IF AVAIL val_aprop_ctbl_apl                                                                                                                                                                                                                       */
/*               THEN ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_apl.val_aprop_ctbl.                                                                                                                                             */
/*                                                                                                                                                                                                                                                              */
/*            IF   tt-dados.val_aprop_ctbl = 0 THEN DO:                                                                                                                                                                                                         */
/*                 IF  movto_operac_financ.ind_tip_trans_apl <> "Varia»’o Cambial"                                                                                                                                                                              */
/*                 AND movto_operac_financ.ind_tip_trans_apl <> "Transf Var Cambial"                                                                                                                                                                            */
/*                 AND movto_operac_financ.ind_tip_trans_apl <> "Transf VC Juros"                                                                                                                                                                               */
/*                 AND movto_operac_financ.ind_tip_trans_apl <> "Var Cambial Juros"                                                                                                                                                                             */
/*                 AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Juros Compet"                                                                                                                                                                           */
/*                 AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Compet¼ncia"                                                                                                                                                                            */
/*                 AND movto_operac_financ.cod_indic_econ    <> "Real"   THEN DO:                                                                                                                                                                               */
/*                     RUN pi_converter_indic_econ_finalid_apl (INPUT movto_operac_financ.cod_indic_econ,                                                                                                                                                       */
/*                                                              INPUT "1",                                                                                                                                                                                      */
/*                                                              INPUT movto_operac_financ.dat_transacao,                                                                                                                                                        */
/*                                                              INPUT aprop_ctbl_apl.val_aprop_indic_econ_movto,                                                                                                                                                */
/*                                                              INPUT "Corrente",                                                                                                                                                                               */
/*                                                              OUTPUT v_cod_return).                                                                                                                                                                           */
/*                    FIND FIRST tt_converter_finalid_econ_apl NO-LOCK NO-ERROR.                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                              */
/*                    IF  AVAIL tt_converter_finalid_econ_apl THEN                                                                                                                                                                                              */
/*                        ASSIGN tt-dados.val_aprop_ctbl       = tt_converter_finalid_econ_apl.tta_val_transacao.                                                                                                                                               */
/*                 END.                                                                                                                                                                                                                                         */
/*            END.                                                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                              */
/*            IF  tt-dados.val_aprop_ctbl = 0 THEN                                                                                                                                                                                                              */
/*                ASSIGN tt-dados.val_aprop_ctbl = aprop_ctbl_apl.val_aprop_indic_econ_movto.                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                              */
/*         END.                                                                                                                                                                                                                                                 */
/*     END.                                                                                                                                                                                                                                                     */



    DO da-data = d_dat_transacao_ini TO d_dat_transacao_fim:

       RUN pi-acompanhar in h-acomp (input  "Data.:" + string(da-data) + "Est.: " + c_cod_estab + " Cta.: " + c_cod_cta_ctbl + " CC.: " +  c_cod_ccusto).     

/*        DO  i = 1 TO NUM-ENTRIES(v_cod_tip_calc,";"):                                                                                                                 */
/*             FOR EACH reg_calc_bem_pat NO-LOCK                                                                                                                        */
/*                 WHERE reg_calc_bem_pat.cod_tip_calc     = ENTRY(i,v_cod_tip_calc,";")                                                                                */
/*                   AND reg_calc_bem_pat.cod_cenar_ctbl   = "Fiscal"                                                                                                   */
/*                   AND reg_calc_bem_pat.cod_finalid_econ = "Corrente"                                                                                                 */
/*                   AND reg_calc_bem_pat.dat_calc_pat     = da-data:                                                                                                   */
/*                                                                                                                                                                      */
/*                 FIND bem_pat NO-LOCK OF reg_calc_bem_pat.                                                                                                            */
/*                                                                                                                                                                      */
/*                 FIND FIRST bem_pat_item_docto_entr OF bem_pat NO-LOCK NO-ERROR.                                                                                      */
/*                                                                                                                                                                      */
/*                 FIND param_calc_bem_pat NO-LOCK OF bem_pat                                                                                                           */
/*                     WHERE param_calc_bem_pat.cod_cenar_ctbl   = "Fiscal"                                                                                             */
/*                       AND param_calc_bem_pat.cod_finalid_econ = "Corrente"                                                                                           */
/*                       AND (param_calc_bem_pat.cod_tip_calc = "Deprec" OR param_calc_bem_pat.cod_tip_calc = "Amortiz") NO-ERROR.                                      */
/*                                                                                                                                                                      */
/*                                                                                                                                                                      */
/*                 FOR EACH aprop_ctbl_pat NO-LOCK                                                                                                                      */
/*                     WHERE aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat                                                        */
/*                     AND   aprop_ctbl_pat.cod_plano_cta_ctbl_db    = c_cod_plano_cta_ctbl                                                                             */
/*                     AND   aprop_ctbl_pat.cod_cta_ctbl_db          = c_cod_cta_ctbl                                                                                   */
/*                     AND   aprop_ctbl_pat.cod_plano_ccusto_db      = c_cod_plano_cta_ctbl                                                                             */
/*                     AND   aprop_ctbl_pat.cod_ccusto_db            = c_cod_ccusto:                                                                                    */
/*                                                                                                                                                                      */
/*                     CREATE tt-dados.                                                                                                                                 */
/*                     ASSIGN tt-dados.cod_estab             = aprop_ctbl_pat.cod_estab                                                                                 */
/*                            tt-dados.origem                = "FAS"                                                                                                    */
/*                            tt-dados.ind_natur_lancto_ctbl = "DB"                                                                                                     */
/*                            tt-dados.origem                = "FAS"                                                                                                    */
/*                            tt-dados.cod_cenar_ctbl        = c_cod_cenar_fiscal                                                                                       */
/*                            tt-dados.cod_emitente          = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cdn_fornecedor ELSE bem_pat.cdn_fornecedor */
/*                            tt-dados.dt_transacao          = reg_calc_bem_pat.dat_calc_pat                                                                            */
/*                            tt-dados.cod_espec_docto       = ""                                                                                                       */
/*                            tt-dados.cod_ser_docto         = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_ser_nota   ELSE bem_pat.cod_ser_nota   */
/*                            tt-dados.cod_tit_ap            = IF AVAIL bem_pat_item_docto_entr THEN bem_pat_item_docto_entr.cod_docto_entr ELSE bem_pat.cod_docto_entr */
/*                            tt-dados.cod_parcela           = ""                                                                                                       */
/*                            tt-dados.val_aprop_ctbl        = aprop_ctbl_pat.val_lancto_ctbl                                                                           */
/*                            tt-dados.cod_cta_ctbl          = aprop_ctbl_pat.cod_cta_ctbl_db                                                                           */
/*                            tt-dados.cod_ccusto            = aprop_ctbl_pat.cod_ccusto_db                                                                             */
/*                            tt-dados.cod_unid_negoc        = aprop_ctbl_pat.cod_unid_negoc_db                                                                         */
/*                            tt-dados.des_historico         = aprop_ctbl_pat.des_histor_lancto_ctbl                                                                    */
/*                            tt-dados.dt_transacao          = reg_calc_bem_pat.dat_ult_atualiz.                                                                        */
/*                                                                                                                                                                      */
/*                 END.                                                                                                                                                 */
/*             END.                                                                                                                                                     */
/*         END.                                                                                                                                                         */
   
        
        /* ** Movimentos Caixa e Bancos - CMG ***/      

        FOR EACH aprop_ctbl_cmg NO-LOCK
           WHERE aprop_ctbl_cmg.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_cmg.cod_plano_cta_ctbl  = c_cod_plano_cta_ctbl
             AND aprop_ctbl_cmg.cod_cta_ctbl        = c_cod_cta_ctbl
             AND aprop_ctbl_cmg.dat_transacao       = da-data
             AND aprop_ctbl_cmg.cod_ccusto          = c_cod_ccusto:
        
            FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.
        
            IF NOT AVAIL movto_cta_corren
               THEN NEXT.
        
            CREATE tt-dados.
            ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
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
                   tt-dados.des_histor            = movto_cta_corren.des_histor_movto_cta_corren               .
        
            /*Fabiano - Tratamento para t­tulos implantados em outra moeda*/
            if  aprop_ctbl_cmg.cod_indic_econ <> 'real'then do:
                assign tt-dados.val_aprop_ctbl = 0.
                for each val_aprop_ctbl_cmg of aprop_ctbl_cmg  
                    WHERE val_aprop_ctbl_cmg.cod_finalid_econ = "Corrente" no-lock:
                    assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_cmg.val_movto_cta_corren.
                end.
            end.   
        END.

        /* ** Movimentos Contabilidade - FGL ***/
        FOR EACH  item_lancto_ctbl NO-LOCK
            WHERE item_lancto_ctbl.cod_empres       = estabelecimento.cod_empresa
              AND item_lancto_ctbl.cod_plano_cta    = 'padrao'
              AND item_lancto_ctbl.cod_cta_ctbl     = c_cod_cta_ctbl
              AND item_lancto_ctbl.cod_plano_ccusto = 'padrao'
              AND item_lancto_ctbl.cod_ccusto       = c_cod_ccusto
              AND item_lancto_ctbl.cod_estab        = c_cod_estab
              AND item_lancto_ctbl.cod_cenar_ctbl   <> "Gerencial" /* <> "gerenc" */
              AND item_lancto_ctbl.dat_lancto_ctbl  = da-data,
            EACH  lancto_ctbl OF item_lancto_ctbl
                 WHERE lancto_ctbl.cod_modul_dtsul <> "apb"
                   AND lancto_ctbl.cod_modul_dtsul <> "cep"
                   AND lancto_ctbl.cod_modul_dtsul <> "acr"
            BREAK BY item_lancto_ctbl.dat_lancto_ctbl:
        
        
            CREATE tt-dados.
            ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa
                   tt-dados.cod_estabel           = estabelecimento.cod_estab
                   tt-dados.cod_plano_cta_ctbl    = item_lancto_ctbl.cod_plano_cta
                   tt-dados.cod_plano_cc          = item_lancto_ctbl.cod_plano_ccusto             
                   tt-dados.origem                = "FGL"
                   tt-dados.cod_cenar_ctbl        = c_cod_cenar_fiscal
                   tt-dados.ind_natur_lancto_ctbl = item_lancto_ctbl.ind_natur_lancto_ctbl
                   tt-dados.dt_transacao          = ITEM_lancto_ctbl.dat_lancto_ctbl
                   tt-dados.cod_tit_ap            = string(item_lancto_ctbl.num_lote_ctbl)
                   tt-dados.cod_parcela           = string(item_lancto_ctbl.num_seq_lancto_ctbl)              
                   tt-dados.val_aprop_ctbl        = item_lancto_ctbl.val_lancto_ctbl
                   tt-dados.cod_cta_ctbl          = ITEM_lancto_ctbl.cod_cta_ctbl
                   tt-dados.cod_ccusto            = ITEM_lancto_ctbl.cod_ccusto
                   tt-dados.cod_projeto           = ITEM_lancto_ctbl.cod_proj
                   tt-dados.cod_unid_negoc        = ITEM_lancto_ctbl.cod_unid_negoc.
        END.

        /* ** Movimentos Contas a Pagar - APB ***/
    
        FOR EACH aprop_ctbl_ap NO-LOCK
            WHERE aprop_ctbl_ap.cod_estab          = c_cod_estab
              AND aprop_ctbl_ap.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl
              AND aprop_ctbl_ap.cod_cta_ctbl       = c_cod_cta_ctbl
              AND aprop_ctbl_ap.cod_ccusto         = c_cod_ccusto
              AND aprop_ctbl_ap.dat_transacao      = da-data
            BREAK BY aprop_ctbl_ap.dat_transacao:
                                                
            FIND FIRST movto_tit_ap NO-LOCK
                 WHERE movto_tit_ap.cod_estab           = c_cod_estab
                   AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                   AND movto_tit_ap.log_movto_estordo   = NO NO-ERROR.
            IF  NOT AVAIL movto_tit_ap THEN
                NEXT.
            
            CREATE tt-dados.
            ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa              
                   tt-dados.cod_estabel           = estabelecimento.cod_estab                
                   tt-dados.cod_plano_cta_ctbl    = aprop_ctbl_ap.cod_plano_cta           
                   tt-dados.cod_plano_cc          = aprop_ctbl_ap.cod_plano_ccusto        
                   tt-dados.origem                = "APB"
                   tt-dados.cod_cenar_ctbl        = c_cod_cenar_fiscal
                   tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
                   tt-dados.dt_transacao          = aprop_ctbl_ap.dat_transacao
                   tt-dados.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl
                   tt-dados.cod_ccusto            = aprop_ctbl_ap.cod_ccusto
                   tt-dados.cod_cta_ctbl          = aprop_ctbl_ap.cod_cta_ctbl
                   tt-dados.cod_unid_negoc        = aprop_ctbl_ap.cod_unid_negoc.
                    
            /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
            IF aprop_ctbl_ap.cod_indic_econ <> 'real' THEN DO:
                 ASSIGN tt-dados.val_aprop_ctbl = 0.
                 FOR EACH val_aprop_ctbl_ap OF aprop_ctbl_ap NO-LOCK:
                     ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
                 END.
            END.
           
            FIND FIRST emscad.fornecedor NO-LOCK
                 WHERE emscad.fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
                   AND emscad.fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.
            IF  AVAIL  emscad.fornecedor THEN
                ASSIGN tt-dados.cod_emitente  = emscad.fornecedor.cdn_fornecedor
                       tt-dados.nome_emitente = emscad.fornecedor.nom_pessoa.
         
            IF tt-dados.nome_emitente = "" THEN DO:
                 FIND FIRST histor_tit_movto_ap NO-LOCK 
                      WHERE histor_tit_movto_ap.cod_estab           = c_cod_estab
                        AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                        AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap NO-ERROR.
                 IF AVAIL histor_tit_movto_ap 
                    THEN ASSIGN tt-dados.nome_emitente = histor_tit_movto_ap.des_text_histor.
        
            END.
        
            FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
            IF AVAIL tit_ap THEN
                ASSIGN tt-dados.cod_espec_docto = tit_ap.cod_espec_docto
                       tt-dados.cod_ser_docto   = tit_ap.cod_ser_docto
                       tt-dados.cod_tit_ap      = tit_ap.cod_tit_ap
                       tt-dados.cod_parcela     = tit_ap.cod_parcela.
        END.

        /* ** Movimentos Contas a Receber - ACR ***/

        FOR EACH aprop_ctbl_acr NO-LOCK
            WHERE aprop_ctbl_acr.cod_estab          = c_cod_estab
              AND aprop_ctbl_acr.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl
              AND aprop_ctbl_acr.cod_cta_ctbl       = c_cod_cta_ctbl
              AND aprop_ctbl_acr.dat_transacao      = da-data
              AND aprop_ctbl_acr.cod_ccusto         = c_cod_ccusto
            BREAK BY aprop_ctbl_acr.dat_transacao:
        
            FIND FIRST movto_tit_acr NO-LOCK
                 WHERE movto_tit_acr.cod_estab            = c_cod_estab
                   AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
                   AND movto_tit_acr.LOG_movto_estordo    = NO NO-ERROR.
            IF  NOT AVAIL movto_tit_acr THEN
                NEXT.
        
            FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
            IF  NOT AVAIL tit_acr THEN
                NEXT.
                
            CREATE tt-dados.
            ASSIGN tt-dados.cod_empresa           = estabelecimento.cod_empresa              
                   tt-dados.cod_estabel           = estabelecimento.cod_estab                
                   tt-dados.cod_plano_cta_ctbl    = aprop_ctbl_acr.cod_plano_cta           
                   tt-dados.cod_plano_cc          = aprop_ctbl_acr.cod_plano_ccusto        
                   tt-dados.cod_cenar_ctbl        = c_cod_cenar_fiscal
                   tt-dados.origem                = "ACR"
                   tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
                   tt-dados.dt_transacao          = aprop_ctbl_acr.dat_transacao
                   tt-dados.cod_espec_docto       = tit_acr.cod_espec_docto
                   tt-dados.cod_ser_docto         = tit_acr.cod_ser_docto
                   tt-dados.cod_tit_ap            = tit_acr.cod_tit_acr
                   tt-dados.cod_parcela           = tit_acr.cod_parcela
                   tt-dados.cod_cta_ctbl          = aprop_ctbl_acr.cod_cta_ctbl
                   tt-dados.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl
                   tt-dados.cod_ccusto            = aprop_ctbl_acr.cod_ccusto
                   tt-dados.cod_unid_negoc        = aprop_ctbl_acr.cod_unid_negoc.
        
            /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
            IF aprop_ctbl_acr.cod_indic_econ <> 'real' THEN DO:
                 ASSIGN tt-dados.val_aprop_ctbl = 0.
                 FOR EACH val_aprop_ctbl_acr OF aprop_ctbl_acr NO-LOCK:
                     ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_acr.val_aprop.
                 END.
            END.
        
            FIND FIRST emscad.cliente NO-LOCK
                 WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                   AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.
            IF  AVAIL  emscad.cliente THEN
                ASSIGN tt-dados.cod_emitente  = emscad.cliente.cdn_cliente
                       tt-dados.nome_emitente = emscad.cliente.nom_pessoa.
        END.
    END.    
END.
    
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
        label "Data Cota»’o"
        column-label "Data Cota»’o"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cota»’o"
        column-label "Cota»’o"
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


PROCEDURE pi-carrega-cta-cc:
    DEF INPUT PARAM c-cod-emp   AS CHAR.
    DEF INPUT PARAM c-cod-est-i AS CHAR.
    DEF INPUT PARAM c-cod-est-f AS CHAR.
    DEF INPUT PARAM c-plano-cta AS CHAR.
    DEF INPUT PARAM c-plano-cc  AS CHAR.

    DEF VAR i-qt-cta AS INT.
    DEF VAR i-qt-cc  AS INT.
    
    FOR EACH cta_ctbl FIELDS (cod_cta_ctbl ind_espec_cta_ctbl cod_grp_cta_ctbl) NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = c-plano-cta
          AND cta_ctbl.cod_cta_ctbl >= "40000000"
          AND cta_ctbl.cod_cta_ctbl <= "42000000": 

        IF  cta_ctbl.ind_espec_cta_ctbl <> "Analitica" THEN 
            NEXT.
    
        IF  cta_ctbl.cod_grp_cta_ctbl <> "4" THEN
            NEXT.
                                                       
    
        ASSIGN i-qt-cta = i-qt-cta + 1.

        CREATE tt-conta.
        ASSIGN tt-conta.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
               tt-conta.ind_espec_cta_ctbl = cta_ctbl.ind_espec_cta_ctbl.
        
    END.
    
    FOR EACH emscad.ccusto
        FIELDS (cod_ccusto dat_inic_valid dat_fim_valid) NO-LOCK
        WHERE ccusto.cod_empresa  = c-cod-emp
        AND   ccusto.cod_plano_cc = c-plano-cc:

        IF ccusto.dat_inic_valid > TODAY
        OR ccusto.dat_fim_valid < TODAY THEN
            NEXT.

        FOR EACH estabelecimento NO-LOCK
            WHERE estabelecimento.cod_empresa = c-cod-emp
            AND   estabelecimento.cod_estab  >= c-cod-est-i
            AND   estabelecimento.cod_estab  <= c-cod-est-f:

            FIND FIRST restric_ccusto
                WHERE restric_ccusto.cod_empresa      = c-cod-emp
                AND   restric_ccusto.cod_ccusto       = ccusto.cod_ccusto
                AND   restric_ccusto.cod_plano_ccusto = c-plano-cc
                AND   restric_ccusto.cod_estab        = estabelecimento.cod_estab
                NO-LOCK NO-ERROR.

            IF  AVAIL restric_ccusto THEN 
                NEXT.

            FIND tt-cc                                                                          
               WHERE tt-cc.cod-estab = estabelecimento.cod_estab
               AND   tt-cc.cc-codigo = ccusto.cod_ccusto 
               NO-ERROR.
            
            IF NOT AVAIL tt-cc THEN DO:             
               ASSIGN i-qt-cc = i-qt-cc + 1.
               CREATE tt-cc.
               ASSIGN tt-cc.cod-estab    = estabelecimento.cod_estab
                      tt-cc.cc-codigo    = ccusto.cod_ccusto.   
            END.   
        END.    
    END.   
END.
