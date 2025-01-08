DEF BUFFER b-cc-saldo for int-cc-benef.
   
FUNCTION fnBuscarVerbaReembolsada RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE) FORWARD.

FUNCTION fnBuscarVerbaEmpenhadaAnalise RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE) FORWARD.

FUNCTION fnBuscarVerbaEmpenhadaAprovada RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE) FORWARD.

FUNCTION fnBuscarVerbaEmpenhadaTotal RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE) FORWARD.

/* --------------------------------------------------------------------- */
/* VERBA REEMBOLSADA - SOLICITA€åES Jµ PAGAS TOTAL OU PARCIAL NO PERÖODO */
/* --------------------------------------------------------------------- */
FUNCTION fnBuscarVerbaReembolsada RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE):

    DEF VAR de-reembolsadas AS DECIMAL NO-UNDO.
/*     DEF VAR de-abatido   AS DECIMAL NO-UNDO.                                */
/*                                                                             */
/*      FOR EACH int-solicitacao NO-LOCK                                       */
/*          WHERE int-solicitacao.CodigoConta                  = p-guid-canal  */
/*            AND int-solicitacao.CodigoUnidadeNegocio         = p-unidade     */
/*            AND int-solicitacao.tipo-beneficio               = p-beneficio   */
/*            AND int-solicitacao.dt-periodo-ini               = p-per-ini     */
/*            AND int-solicitacao.dt-periodo-fim               = p-per-fim     */
/*            AND int-solicitacao.SituacaoSolicitacaoBeneficio >= 993520003    */
/*            AND int-solicitacao.SituacaoSolicitacaoBeneficio <= 993520004    */
/*            AND NOT int-solicitacao.Ajuste:  /* Ajuste */                    */
/*                                                                             */
/*          ASSIGN de-abatido = int-solicitacao.vl-abatido-apb.                */
/*                                                                             */
/*          IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004        */
/*          AND de-abatido = 0 THEN                                            */
/*              ASSIGN de-abatido = int-solicitacao.ValorSolicitado.           */
/*                                                                             */
/*          ASSIGN de-reembolsadas = de-reembolsadas + de-abatido.             */
/*                                                                             */
/*      END.                                                                   */

  RETURN de-reembolsadas.   /* Function return value. */

END FUNCTION.

/* ----------------------------------------------------------------------- */
/* VERBA EMPENHADA - SOLICITA€åES EM ABERTO QUE NÇO ESTÇO PAGAS/CANCELADAS */
/* ----------------------------------------------------------------------- */
FUNCTION fnBuscarVerbaEmpenhadaAnalise RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE):

    DEF VAR de-empenhadas AS DECIMAL NO-UNDO.
    
/*      FOR EACH int-solicitacao NO-LOCK                                             */
/*          WHERE int-solicitacao.CodigoConta                   = p-guid-canal       */
/*            AND int-solicitacao.CodigoUnidadeNegocio          = p-unidade          */
/*            AND int-solicitacao.tipo-beneficio                = p-beneficio        */
/*            AND int-solicitacao.dt-periodo-ini                = p-per-ini          */
/*            AND int-solicitacao.dt-periodo-fim                = p-per-fim          */
/*            AND NOT int-solicitacao.Ajuste: /*Ajuste*/                             */
/*                                                                                   */
/*            /* Desconsidera CANCELADAS, PENDENTES OU PAGAS */                      */
/*            IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006            */
/*            OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004            */
/*            OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003            */
/*            THEN                                                                   */
/*                NEXT.                                                              */
/*                                                                                   */
/*          ASSIGN de-empenhadas = de-empenhadas + int-solicitacao.ValorSolicitado.  */
/*      END.                                                                         */

  RETURN de-empenhadas.   /* Function return value. */
END FUNCTION.

/* ------------------------------------------------------------------------------- */
/* VERBA EMPENHADA APROVADA - SOLICITA€åES EM ABERTO Jµ DISPONÖVEIS PARA PAGAMENTO */
/* ------------------------------------------------------------------------------- */
FUNCTION fnBuscarVerbaEmpenhadaAprovada RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE):

    DEF VAR de-empenhadas AS DECIMAL NO-UNDO.
    
/*      FOR EACH int-solicitacao NO-LOCK                                             */
/*          WHERE int-solicitacao.CodigoConta                   = p-guid-canal       */
/*            AND int-solicitacao.CodigoUnidadeNegocio          = p-unidade          */
/*            AND int-solicitacao.tipo-beneficio                = p-beneficio        */
/*            AND int-solicitacao.dt-periodo-ini                = p-per-ini          */
/*            AND int-solicitacao.dt-periodo-fim                = p-per-fim          */
/*            AND int-solicitacao.SituacaoSolicitacaoBeneficio  = 993520003          */
/*            AND NOT int-solicitacao.Ajuste: /*Ajuste*/                             */
/*                                                                                   */
/*          ASSIGN de-empenhadas = de-empenhadas + int-solicitacao.ValorSolicitado.  */
/*      END.                                                                         */

  RETURN de-empenhadas.   /* Function return value. */
END FUNCTION.
   
/* ----------------------------------------------------------------------- */
/* VERBA EMPENHADA - SOLICITA€åES EM ABERTO QUE NÇO ESTÇO PAGAS/CANCELADAS */
/* ----------------------------------------------------------------------- */
FUNCTION fnBuscarVerbaEmpenhadaTotal RETURNS DECIMAL
    (INPUT p-guid-canal AS CHAR,
     INPUT p-unidade    AS CHAR,
     INPUT p-beneficio  AS INT,
     INPUT p-per-ini    AS DATE,
     INPUT p-per-fim    AS DATE):

    DEF VAR de-empenhadas-tot AS DECIMAL NO-UNDO.
    
/*      FOR EACH int-solicitacao NO-LOCK                                                     */
/*          WHERE int-solicitacao.CodigoConta                   = p-guid-canal               */
/*            AND int-solicitacao.CodigoUnidadeNegocio          = p-unidade                  */
/*            AND int-solicitacao.tipo-beneficio                = p-beneficio                */
/*            AND int-solicitacao.dt-periodo-ini                = p-per-ini                  */
/*            AND int-solicitacao.dt-periodo-fim                = p-per-fim                  */
/*            AND NOT int-solicitacao.Ajuste: /*Ajuste*/                                     */
/*                                                                                           */
/*            /* Desconsidera CANCELADAS, PENDENTES OU PAGAS */                              */
/*            IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006                    */
/*            OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004                    */
/*            THEN                                                                           */
/*                NEXT.                                                                      */
/*                                                                                           */
/*          ASSIGN de-empenhadas-tot = de-empenhadas-tot + int-solicitacao.ValorSolicitado.  */
/*      END.                                                                                 */

  RETURN de-empenhadas-tot.   /* Function return value. */
END FUNCTION.
   
PROCEDURE pi-retorna-movimentos-saldo:
    DEF INPUT PARAM p-guid-canal AS CHAR NO-UNDO.
    DEF INPUT PARAM p-unidade    AS CHAR NO-UNDO.
    DEF INPUT PARAM p-beneficio  AS INT  NO-UNDO.
    DEF INPUT PARAM p-per-ini    AS DATE NO-UNDO.
    DEF INPUT PARAM p-per-fim    AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-verba-empenhada-analise  AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-verba-empenhada-aprovada AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-verba-empenhada-total    AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-verba-reembolsada        AS DEC NO-UNDO.

    DEF VAR de-abatido AS DEC NO-UNDO.
    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.CodigoConta                  = p-guid-canal
          AND int-solicitacao.CodigoUnidadeNegocio         = p-unidade
          AND int-solicitacao.tipo-beneficio               = p-beneficio
          AND int-solicitacao.dt-periodo-ini               = p-per-ini
          AND int-solicitacao.dt-periodo-fim               = p-per-fim
          AND NOT int-solicitacao.Ajuste:  /* Ajuste */
    
        /*----------------------------------------------------------------------*/
        /*                            REEMBOLSADAS                              */
        /*----------------------------------------------------------------------*/
        IF  int-solicitacao.SituacaoSolicitacaoBeneficio >= 993520003
        AND int-solicitacao.SituacaoSolicitacaoBeneficio <= 993520004 THEN DO:

            IF  int-solicitacao.desc-forma-pagto <> "Produto" THEN DO:
                ASSIGN de-abatido = int-solicitacao.vl-abatido-apb.
        
                IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 
                AND de-abatido = 0 THEN
                    ASSIGN de-abatido = int-solicitacao.ValorSolicitado.
        
                ASSIGN p-verba-reembolsada = p-verba-reembolsada + de-abatido .
            END.
            ELSE
                ASSIGN p-verba-reembolsada = p-verba-reembolsada + int-solicitacao.ValorPago.

        END.
        

        /*----------------------------------------------------------------------*/
        /* EMPENHADAS EM ANµLISE -> Desconsidera CANCELADAS, PENDENTES OU PAGAS */
        /*----------------------------------------------------------------------*/
        IF  int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006
        AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004
        AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520003
        THEN 
            ASSIGN p-verba-empenhada-analise = p-verba-empenhada-analise + int-solicitacao.ValorSolicitado. 

        /*----------------------------------------------------------------------*/
        /* EMPENHADAS APROVADAS  -> Considera apenas PENDENTES                  */
        /*----------------------------------------------------------------------*/
        IF  int-solicitacao.SituacaoSolicitacaoBeneficio  = 993520003 THEN
            ASSIGN p-verba-empenhada-aprovada = p-verba-empenhada-aprovada + 
                                                (int-solicitacao.ValorSolicitado - int-solicitacao.vl-abatido-apb - int-solicitacao.vl-empenho-pago).

        
    END.

    ASSIGN p-verba-empenhada-total = p-verba-empenhada-analise + p-verba-empenhada-aprovada.

    RETURN "OK".

END.


