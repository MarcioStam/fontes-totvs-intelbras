/*------------------------------------------------------------------------------------------------------------------------------------------------------------ */
/* ESESBAPI010-SALDO - Retornar o Saldo Atualizado do Benef°cio, a partir do c¢digo da                                                                         */
/*                     solicitaá∆o ou rowid da conta corrente.Segue nomenclatura utilizada                                                                     */
/*                                                                                                                                                             */
/*  1) ................Verba Calculada.:  Verba calculada do benef°cio para o trimestre atual.                                                                 */
/*                                                                                                                                                             */
/*  2) Verba dos Trimestres Anteriores.:  Verba proveniente do empenho de solicitaá‰es pendentes de atendimento de trimestres anteriores                       */
/*                                                                                                                                                             */
/*  3) ....................Verba Total.:  Verba calculada + verba dos trimestres anteriores + (VERBA POR ACÎMULO DE TRIMESTRE - STOCK ROTATION)                */
/*                                                                                                                                                             */
/*  4) .......................Empenhos.:  Solicitaá‰es pendentes de pagamento inclu°das dentro do trimestre vigente e transferidas de trimestres anteriores    */
/*                                                                                                                                                             */
/*  5) ...............Verba Reembolsada:  Valor total de pagamentos efetuados no trimestre atual.                                                              */
/*                                                                                                                                                             */
/*  6) ................Verba Cancelada.:  Verba cancelada devido ao cancelamento de solicitaá‰es de benef°cio ou experiá∆o de verba.                           */
/*                                                                                                                                                             */
/*  7) .............Ajustes Realizados.:  Saldo adicionado ou subtra°do por solicitaá‰es de Ajuste                                                             */
/*                                                                                                                                                             */
/*  8) ...............Valor Dispon°vel.:  Verba Total - Empenhos - Verba Reembolsada  - Verba Cancelada + Ajustes Realizados.                                  */
/*                                                                                                                                                             */
/*                                                                                                                                                             */
/*  OBSERVAÄ«O: O valor do t°tulo no APB (Ö Pagar) Ç o resultado das seguintes operaá‰es:                                                                      */
/*                                                                                                                                                             */
/*                    Verba Total - Verba Reembolsada - Verba Cancelada + Ajustes Realizados                                                                   */
/*                                                                                                                                                             */
/*                                                                                                                                                             */
/*------------------------------------------------------------------------------------------------------------------------------------------------------------ */

{esp/esb/in/msg0152.i3}       /*tt-erro*/
{esp/esb/esesbapi010-saldo.i} /*funá‰es para retorno de verba reembolsada/emenhada */
{esp/esb/esesbapi010-saldo.i1} /*tt-saldo*/

/* OU ENVIA A CHAVE */
DEF INPUT  PARAM p-canal                 AS INTEGER    NO-UNDO.
DEF INPUT  PARAM p-beneficio             AS INTEGER    NO-UNDO.
DEF INPUT  PARAM p-unidade               AS CHAR       NO-UNDO.
DEF INPUT  PARAM p-per-ini               AS DATE       NO-UNDO.
DEF INPUT  PARAM p-per-fim               AS DATE       NO-UNDO.

/* OU ENVIA O ROWID DO REGISTRO DE CONTA CORRENTE */
DEF INPUT  PARAM r-int-cc-benef          AS ROWID      NO-UNDO.

/* OUT ENVIA A CHAVE DA SOLICITACAO*/
DEF INPUT  PARAM p-Cod-Solicitacao       AS CHAR       NO-UNDO.

DEF OUTPUT PARAM p-ok                    AS LOG   INIT NO NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-saldo.     
DEF OUTPUT PARAM TABLE FOR tt-erro.

/*-----------------------------------------------------------------------------------*/
/*                                   VALIDAÄÂES                                      */
/*-----------------------------------------------------------------------------------*/
IF  p-canal <> ? THEN DO:
    FIND int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
          AND int-cc-benef.canal          = p-canal
          AND int-cc-benef.unid-neg       = p-unidade
          AND int-cc-benef.tipo-beneficio = p-beneficio
          AND int-cc-benef.dt-periodo-ini = p-per-ini
          AND int-cc-benef.dt-periodo-fim = p-per-fim NO-ERROR.
END.
ELSE DO:
    IF  r-int-cc-benef <> ? THEN
        FIND int-cc-benef NO-LOCK
            WHERE rowid(int-cc-benef) = r-int-cc-benef NO-ERROR.
    IF  p-Cod-Solicitacao <> ? THEN
        FIND int-solicitacao NO-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-Cod-Solicitacao NO-ERROR.
        IF  AVAIL int-solicitacao THEN
            FIND int-cc-benef NO-LOCK
                WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
                  AND int-cc-benef.canal          = int-solicitacao.cod-emitente
                  AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
                  AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
                  AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
                  AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim NO-ERROR.
END.


IF  NOT AVAIL int-cc-benef THEN DO:
    RUN pi-cria-erro ("17006",
                      "Conta Corrente n∆o encontrada ou n∆o est† Ativa.",
                      "Saldo n∆o pode ser retornado visto que a conta corrente n∆o foi localizada").
    RETURN "NOK".
END.

/*-----------------------------------------------------------------------------------------*/
/*                                    BUSCAR SALDOS                                        */
/*-----------------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-saldo.

CREATE tt-saldo.
ASSIGN tt-saldo.CodigoBeneficioCanal = int-cc-benef.guid-beneficio-canal
       tt-saldo.VerbaCalculada       = int-cc-benef.VerbaCalculada
       tt-saldo.VerbaPeriodoAnterior = int-cc-benef.VerbaPeriodoAnterior
       
       tt-saldo.VerbaTotal           = tt-saldo.VerbaCalculada       + 
                                       tt-saldo.VerbaPeriodoAnterior + 
                                       int-cc-benef.VerbaAcumulada

       tt-saldo.VerbaCancelada       = int-cc-benef.VerbaCancelada.
       tt-saldo.VerbaAjustada        = int-cc-benef.VerbaAjustada.

/* Buscar movimentaá‰es das Solicitaá‰es Normais (n∆o ajustes) */
RUN pi-retorna-movimentos-saldo(INPUT int-cc-benef.guid-canal,
                                INPUT int-cc-benef.unid-neg,
                                INPUT int-cc-benef.tipo-beneficio,
                                INPUT int-cc-benef.dt-periodo-ini,
                                INPUT int-cc-benef.dt-periodo-fim,
                                OUTPUT tt-saldo.VerbaEmpenhadaAnalise,
                                OUTPUT tt-saldo.VerbaEmpenhadaAprovada,
                                OUTPUT tt-saldo.VerbaEmpenhadaTotal,
                                OUTPUT tt-saldo.VerbaReembolsada).

/*-----------------------------------------------------------------------------------------*/
/*                                      DISPON÷VEL                                         */
/*-----------------------------------------------------------------------------------------*/
ASSIGN tt-saldo.VerbaDisponivel      = tt-saldo.VerbaTotal          - 
                                       tt-saldo.VerbaCancelada      +
                                       tt-saldo.VerbaAjustada       - 
                                       tt-saldo.VerbaEmpenhadaTotal - 
                                       tt-saldo.VerbaReembolsada    -
                                       int-cc-benef.descarte-stock-rotation .


ASSIGN p-ok = YES.

RETURN "OK".
/** FIM **/


PROCEDURE pi-cria-erro:
    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.
END.




    





   
   
   
   
   
   
   



