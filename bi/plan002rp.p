/**
 * Extrator para GESPLAN
 * Fato: Extrator do razÆo cont bil consolidado
 *
 * Autor: Anderson Hoepers - 04/02/2016
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/plan002tt.i}
{bi/esbi000.i}
{utp/ut-glob.i}

define input  parameter table for tt-param.
define output parameter table for ttRazaoConsolidado.
define output parameter table for tt-erro.

DEFINE VARIABLE da-data-ini       AS DATE        NO-UNDO.
DEFINE VARIABLE da-data-fim       AS DATE        NO-UNDO.
DEFINE VARIABLE da-tmp            AS DATE        NO-UNDO.
DEFINE VARIABLE c-periodo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ccusto          AS CHARACTER   NO-UNDO.

/************************************************************************/

find first tt-param NO-ERROR.

/* assign da-data-ini = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial)) */
/*        da-data-fim = date(month(tt-param.dt-final),   1, year(tt-param.dt-final))   */
/*        da-data-ini = add-interval(da-data-ini, 1, 'months') - 1                     */
/*        da-data-fim = add-interval(da-data-fim, 1, 'months') - 1.                    */

ASSIGN da-data-ini = tt-param.dt-inicial
       da-data-fim = ADD-INTERVAL(tt-param.dt-final, 1, 'months') - 1.

EMPTY TEMP-TABLE ttRazaoConsolidado.

DO  da-tmp = da-data-ini TO da-data-fim:

    ASSIGN c-periodo = STRING(YEAR(da-tmp),"9999") + STRING(MONTH(da-tmp),"99").

    bloco-movtos:
    FOR EACH  movto_real_orcto NO-LOCK 
        WHERE movto_real_orcto.cod_cenar_ctbl  = "FISCAL"
          AND movto_real_orcto.cod_exerc_ctbl  = STRING(YEAR(da-tmp))
          AND movto_real_orcto.num_period_ctbl = STRING(MONTH(da-tmp),"99")
        BREAK BY movto_real_orcto.cod_cta_ctbl:

        IF  movto_real_orcto.cod_empresa <> i-ep-codigo-usuario
        THEN
            NEXT bloco-movtos.

        ASSIGN c-ccusto  = movto_real_orcto.cod_estab + "_" + movto_real_orcto.cod_ccusto.

        FIND FIRST ttRazaoConsolidado
            WHERE  ttRazaoConsolidado.CD_MasterExt    = STRING(INT(i-ep-codigo-usuario))   
              AND  ttRazaoConsolidado.CD_UnidNegExt   = YEAR(movto_real_orcto.dt_movto)
              AND  ttRazaoConsolidado.CD_Co           = movto_real_orcto.cod_cta_ctbl
              AND  ttRazaoConsolidado.CD_Cc           = c-ccusto
              AND  ttRazaoConsolidado.CD_Prj          = "9999999999"
              AND  ttRazaoConsolidado.NM_Ano          = YEAR (movto_real_orcto.dt_movto)
              AND  ttRazaoConsolidado.NM_Mes          = MONTH(movto_real_orcto.dt_movto) NO-ERROR.
             
        IF  NOT AVAIL ttRazaoConsolidado 
        THEN DO:
            CREATE ttRazaoConsolidado.
            ASSIGN ttRazaoConsolidado.CD_MasterExt  = STRING(INT(i-ep-codigo-usuario))
                   ttRazaoConsolidado.CD_UnidNegExt = YEAR(movto_real_orcto.dt_movto)     
                   ttRazaoConsolidado.CD_Co         = movto_real_orcto.cod_cta_ctbl   
                   ttRazaoConsolidado.CD_Cc         = c-ccusto     
                   ttRazaoConsolidado.CD_Prj        = "9999999999"   
                   ttRazaoConsolidado.CD_Classif    = 4
                   ttRazaoConsolidado.NM_Ano        = YEAR (movto_real_orcto.dt_movto)
                   ttRazaoConsolidado.NM_Mes        = MONTH(movto_real_orcto.dt_movto)
                   ttRazaoConsolidado.TX_MoedaExt   = "R$"
                   ttRazaoConsolidado.TX_Prj        = "Projeto Geral".

            FOR FIRST cta_ctbl NO-LOCK
                WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctbl
                  AND cta_ctbl.cod_cta_ctbl       = movto_real_orcto.cod_cta_ctbl:
                ASSIGN ttRazaoConsolidado.TX_Co = TRIM(fn-free-accent(SUBSTR(cta_ctbl.des_tit_ctbl,1,50))).
            END.

            FOR FIRST emscad.ccusto NO-LOCK
                WHERE emscad.ccusto.cod_empresa      = movto_real_orcto.cod_empresa
                  AND emscad.ccusto.cod_plano_ccusto = movto_real_orcto.cod_plano_ccusto
                  AND emscad.ccusto.cod_ccusto       = movto_real_orcto.cod_ccusto:
                ASSIGN ttRazaoConsolidado.TX_Cc = TRIM(fn-free-accent(SUBSTR(emscad.ccusto.des_tit_ctbl,1,50))).
            END.
        END. /* IF  NOT AVAIL ttRazaoConsolidado  */

        ASSIGN ttRazaoConsolidado.NM_ValorRealizado = ttRazaoConsolidado.NM_ValorRealizado + (IF movto_real_orcto.ind_natur_lancto_ctbl = "DB" THEN movto_real_orcto.val_realiz_per ELSE movto_real_orcto.val_realiz_per * -1).
    END. /* FOR EACH  movto_real_orcto NO-LOCK */

    ASSIGN da-tmp = date(month(da-tmp),  1, year(da-tmp))
           da-tmp = add-interval(da-tmp, 1, 'months').

END. /* DO  da-tmp = da-data-ini TO da-data-fim: */

RETURN "ok".
