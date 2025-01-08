/**
 * Extrator para GESPLAN
 * Fato: Extrator do razÆo cont bil detalhado
 *
 * Autor: Anderson Hoepers - 04/02/2016
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/plan001tt.i}
{bi/esbi000.i}
{utp/ut-glob.i}

define input  parameter table for tt-param.
define output parameter table for ttRazaoDetalhado.
define output parameter table for tt-erro.

DEFINE VARIABLE da-data-ini       AS DATE        NO-UNDO.
DEFINE VARIABLE da-data-fim       AS DATE        NO-UNDO.
DEFINE VARIABLE da-tmp            AS DATE        NO-UNDO.
DEFINE VARIABLE c-periodo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-agrupa          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE id-lancto         AS INTEGER     NO-UNDO.
DEFINE VARIABLE id-seq-lancto     AS INTEGER     NO-UNDO.
DEFINE VARIABLE ds-lancto         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ccusto          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-val-consolidado AS DECIMAL     NO-UNDO.

/************************************************************************/

find first tt-param NO-ERROR.

/* assign da-data-ini = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial)) */
/*        da-data-fim = date(month(tt-param.dt-final),   1, year(tt-param.dt-final))   */
/*        da-data-ini = add-interval(da-data-ini, 1, 'months') - 1                     */
/*        da-data-fim = add-interval(da-data-fim, 1, 'months') - 1.                    */

ASSIGN da-data-ini = tt-param.dt-inicial
       da-data-fim = ADD-INTERVAL(tt-param.dt-final, 1, 'months') - 1.

EMPTY TEMP-TABLE ttRazaoDetalhado.

DO  da-tmp = da-data-ini TO da-data-fim:

    ASSIGN c-periodo = STRING(YEAR(da-tmp),"9999") + STRING(MONTH(da-tmp),"99").

    bloco-movtos:
    FOR EACH  movto_real_orcto NO-LOCK 
        WHERE movto_real_orcto.cod_cenar_ctbl  = "FISCAL"
          AND movto_real_orcto.cod_exerc_ctbl  = STRING(YEAR(da-tmp))
          AND movto_real_orcto.num_period_ctbl = STRING(MONTH(da-tmp),"99")
        BREAK BY movto_real_orcto.cod_cta_ctbl:

        IF  FIRST-OF(movto_real_orcto.cod_cta_ctbl)
        THEN DO:
            ASSIGN l-agrupa      = NO
                   id-lancto     = 0
                   id-seq-lancto = 0
                   ds-lancto     = "".

            IF  CAN-FIND (FIRST int_agrupa_movto_cta_gesplan NO-LOCK
                               WHERE int_agrupa_movto_cta_gesplan.cod_cta_ctbl = movto_real_orcto.cod_cta_ctbl)
            THEN
                ASSIGN l-agrupa = YES.
        END.

        IF  movto_real_orcto.cod_empresa <> i-ep-codigo-usuario
        THEN
            NEXT bloco-movtos.

        IF  l-agrupa = NO
        THEN
            ASSIGN id-seq-lancto = id-seq-lancto + 1
                   id-lancto     = id-seq-lancto
                   ds-lancto     = movto_real_orcto.des_historicao.
        ELSE
            ASSIGN id-lancto = 0
                   ds-lancto = "Agrupamento Conta " + movto_real_orcto.cod_cta_ctbl.

        ASSIGN c-ccusto  = movto_real_orcto.cod_estab + "_" + movto_real_orcto.cod_ccusto
               ds-lancto = REPLACE(ds-lancto,CHR(10)," ")
               ds-lancto = REPLACE(ds-lancto,CHR(11)," ")
               ds-lancto = REPLACE(ds-lancto,CHR(12)," ")
               ds-lancto = REPLACE(ds-lancto,CHR(13)," ").

        FIND FIRST ttRazaoDetalhado
            WHERE  ttRazaoDetalhado.CD_MasterExt    = STRING(INT(i-ep-codigo-usuario))   
              AND  ttRazaoDetalhado.CD_UnidNegExt   = YEAR(movto_real_orcto.dt_movto)
              AND  ttRazaoDetalhado.CD_Co           = movto_real_orcto.cod_cta_ctbl
              AND  ttRazaoDetalhado.CD_Cc           = c-ccusto
              AND  ttRazaoDetalhado.CD_Prj          = "9999999999"
              AND  ttRazaoDetalhado.DT_Lancamento   = movto_real_orcto.dt_movto
              AND  ttRazaoDetalhado.CD_Lancamento   = id-lancto NO-ERROR.
             
        IF  NOT AVAIL ttRazaoDetalhado 
        THEN DO:
            CREATE ttRazaoDetalhado.
            ASSIGN ttRazaoDetalhado.CD_MasterExt  = STRING(INT(i-ep-codigo-usuario))
                   ttRazaoDetalhado.CD_UnidNegExt = YEAR(movto_real_orcto.dt_movto)     
                   ttRazaoDetalhado.CD_Co         = movto_real_orcto.cod_cta_ctbl   
                   ttRazaoDetalhado.CD_Cc         = c-ccusto     
                   ttRazaoDetalhado.CD_Prj        = "9999999999"   
                   ttRazaoDetalhado.CD_Lancamento = id-lancto
                   ttRazaoDetalhado.CD_Classif    = 4
                   ttRazaoDetalhado.CD_Lote       = STRING(DAY(movto_real_orcto.dt_movto))
                   ttRazaoDetalhado.NM_Ano        = YEAR (movto_real_orcto.dt_movto)
                   ttRazaoDetalhado.NM_Mes        = MONTH(movto_real_orcto.dt_movto)
                   ttRazaoDetalhado.DT_Lancamento = movto_real_orcto.dt_movto       
                   ttRazaoDetalhado.TX_MoedaExt   = "R$"
                   ttRazaoDetalhado.TX_Prj        = "Projeto Geral"
                   ttRazaoDetalhado.TX_Lancamento = TRIM(fn-free-accent(ds-lancto)).

            FOR FIRST cta_ctbl NO-LOCK
                WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctbl
                  AND cta_ctbl.cod_cta_ctbl       = movto_real_orcto.cod_cta_ctbl:
                ASSIGN ttRazaoDetalhado.TX_Co = TRIM(fn-free-accent(SUBSTR(cta_ctbl.des_tit_ctbl,1,50))).
            END.

            FOR FIRST emscad.ccusto NO-LOCK
                WHERE emscad.ccusto.cod_empresa      = movto_real_orcto.cod_empresa
                  AND emscad.ccusto.cod_plano_ccusto = movto_real_orcto.cod_plano_ccusto
                  AND emscad.ccusto.cod_ccusto       = movto_real_orcto.cod_ccusto:
                ASSIGN ttRazaoDetalhado.TX_Cc = TRIM(fn-free-accent(SUBSTR(emscad.ccusto.des_tit_ctbl,1,50))).
            END.
        END. /* IF  NOT AVAIL ttRazaoDetalhado  */

        ASSIGN ttRazaoDetalhado.NM_ValorLancamento = ttRazaoDetalhado.NM_ValorLancamento + (IF movto_real_orcto.ind_natur_lancto_ctbl = "DB" THEN movto_real_orcto.val_realiz_per ELSE movto_real_orcto.val_realiz_per * -1)
               ttRazaoDetalhado.NM_ValorRealizado  = ttRazaoDetalhado.NM_ValorLancamento.
    END. /* FOR EACH  movto_real_orcto NO-LOCK */

    ASSIGN da-tmp = date(month(da-tmp),  1, year(da-tmp))
           da-tmp = add-interval(da-tmp, 1, 'months').

END. /* DO  da-tmp = da-data-ini TO da-data-fim: */

RETURN "ok".
