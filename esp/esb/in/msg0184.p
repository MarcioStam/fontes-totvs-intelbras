CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE  c-periodo-anterior AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-periodo-atual    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  da-data            AS DATE        NO-UNDO.
                 
{esp/esb/esesb000.i}
{esp/esb/in/msg0184.i}

DEFINE DATASET mensagem FOR cabecalho, conteudo, MSG0184
   DATA-RELATION FOR conteudo, MSG0184 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0184r1, FaturamentoMensal, UnidadeNegocioCanal, SegmentoUnidadeNegocio, resultado
   DATA-RELATION FOR conteudor, MSG0184r1                           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0184r1, FaturamentoMensal                   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR FaturamentoMensal, UnidadeNegocioCanal         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR UnidadeNegocioCanal, SegmentoUnidadeNegocio    RELATION-FIELDS (NomeUnidadeNegocio, NomeUnidadeNegocio) NESTED
   DATA-RELATION FOR MSG0184r1, resultado                           RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0184R1'
      cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0184R1.

FIND FIRST msg0184 NO-LOCK NO-ERROR.

FIND FIRST grupo-canais WHERE grupo-canais.descricao = msg0184.DescricaoGrupoCanais NO-LOCK NO-ERROR.
IF AVAIL grupo-canais THEN DO:

    log-manager:write-message("dentro msg0184 " + grupo-canais.descricao ).
    ASSIGN da-data            = DATE(MONTH(TODAY), 01, YEAR(TODAY)) - 1
           c-periodo-anterior = STRING(YEAR(da-data),'9999') + string(MONTH(da-data),'99')
           c-periodo-atual    = STRING(YEAR(TODAY),'9999') + string(MONTH(TODAY),'99'). 

    FOR EACH faturamento-segmento-ordem NO-LOCK
        BY faturamento-segmento-ordem.ordem:

        FOR EACH faturamento NO-LOCK
            WHERE faturamento.unid-neg      = faturamento-segmento-ordem.unid-neg  
              AND faturamento.segmento      = faturamento-segmento-ordem.segmento
              AND faturamento.periodo       = c-periodo-atual                       /* Faturamento do Periodo Atual */
              AND faturamento.cod-gr-canais = grupo-canais.cod-gr-canais:

                log-manager:write-message("MSG0184 Faturamento " + faturamento.unid-neg + ' - ' + faturamento.segmento ).

                FIND FIRST FaturamentoMensal
                    WHERE FaturamentoMensal.DescricaoGrupoCanais = grupo-canais.descricao
                      AND FaturamentoMensal.PeriodoAtual         = STRING(MONTH(TODAY),'99')   + "/" + STRING(YEAR(TODAY),'9999') 
                      AND FaturamentoMensal.PeriodoAnterior      = STRING(MONTH(da-data),'99') + "/" + STRING(YEAR(da-data),'9999') 
                      NO-LOCK NO-ERROR.

                IF NOT AVAIL FaturamentoMensal THEN DO:
                    CREATE FaturamentoMensal.
                    ASSIGN FaturamentoMensal.DescricaoGrupoCanais = grupo-canais.descricao   
                           FaturamentoMensal.PeriodoAtual         = STRING(MONTH(TODAY),'99')   + "/" + STRING(YEAR(TODAY),'9999')     
                           FaturamentoMensal.PeriodoAnterior      = STRING(MONTH(da-data),'99') + "/" + STRING(YEAR(da-data),'9999')        .
                END. /* IF NOT AVAIL FaturamentoMensal THEN DO: */

                ASSIGN FaturamentoMensal.ValorTotalFaturOrcadoAtual     = FaturamentoMensal.ValorTotalFaturOrcadoAtual      + faturamento.vl-fat-orc 
                       FaturamentoMensal.ValorTotalFaturRealizadoAtual  = FaturamentoMensal.ValorTotalFaturRealizadoAtual   + faturamento.vl-fat-real
                       FaturamentoMensal.ValorTotalCarteiraAtual        = FaturamentoMensal.ValorTotalCarteiraAtual         + faturamento.vl-cart    .


                FIND FIRST UnidadeNegocioCanal
                    WHERE UnidadeNegocioCanal.NomeUnidadeNegocio  = faturamento.unid-neg EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL UnidadeNegocioCanal THEN DO:
                    ASSIGN UnidadeNegocioCanal.FaturamentoOrcadoAtual    = UnidadeNegocioCanal.FaturamentoOrcadoAtual    + faturamento.vl-fat-orc 
                           UnidadeNegocioCanal.FaturamentoRealizadoAtual = UnidadeNegocioCanal.FaturamentoRealizadoAtual + faturamento.vl-fat-real
                           UnidadeNegocioCanal.ValorCarteiraAtual        = UnidadeNegocioCanal.ValorCarteiraAtual        + faturamento.vl-cart    .
                END. /* IF AVAIL UnidadeNegocioCanal THEN DO: */
                ELSE DO:
                    CREATE UnidadeNegocioCanal.
                    ASSIGN UnidadeNegocioCanal.NomeUnidadeNegocio   = faturamento.unid-neg
                           UnidadeNegocioCanal.FaturamentoOrcadoAtual    = faturamento.vl-fat-orc 
                           UnidadeNegocioCanal.FaturamentoRealizadoAtual = faturamento.vl-fat-real
                           UnidadeNegocioCanal.ValorCarteiraAtual        = faturamento.vl-cart    .
                END. /* IF NOT AVAIL UnidadeNegocioCanal THEN DO: */

                FIND FIRST SegmentoUnidadeNegocio
                    WHERE SegmentoUnidadeNegocio.NomeSegmento       = faturamento.segmento 
                      AND SegmentoUnidadeNegocio.NomeUnidadeNegocio = faturamento.unid-neg EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL SegmentoUnidadeNegocio THEN DO:
                    ASSIGN SegmentoUnidadeNegocio.FaturamentoOrcadoAtual    = SegmentoUnidadeNegocio.FaturamentoOrcadoAtual    + faturamento.vl-fat-orc 
                           SegmentoUnidadeNegocio.FaturamentoRealizadoAtual = SegmentoUnidadeNegocio.FaturamentoRealizadoAtual + faturamento.vl-fat-real
                           SegmentoUnidadeNegocio.ValorCarteiraAtual        = SegmentoUnidadeNegocio.ValorCarteiraAtual        + faturamento.vl-cart    .
                END. /* IF AVAIL SegmentoUnidadeNegocio THEN DO: */
                ELSE DO:
                    CREATE SegmentoUnidadeNegocio.
                    ASSIGN SegmentoUnidadeNegocio.NomeSegmento              = faturamento.segmento
                           SegmentoUnidadeNegocio.NomeUnidadeNegocio        = faturamento.unid-neg
                           SegmentoUnidadeNegocio.FaturamentoOrcadoAtual    = faturamento.vl-fat-orc 
                           SegmentoUnidadeNegocio.FaturamentoRealizadoAtual = faturamento.vl-fat-real
                           SegmentoUnidadeNegocio.ValorCarteiraAtual        = faturamento.vl-cart    .
                END. /* IF NOT AVAIL SegmentoUnidadeNegocio THEN DO: */

                log-manager:write-message("MSG0184 depois criou ttable msg0184 " + grupo-canais.descricao + faturamento.segmento + faturamento.unid-neg).

        END. /* FOR EACH faturamento */

        FOR EACH faturamento NO-LOCK
            WHERE faturamento.unid-neg      = faturamento-segmento-ordem.unid-neg  
              AND faturamento.segmento      = faturamento-segmento-ordem.segmento
              AND faturamento.periodo       = c-periodo-anterior                    /* Faturamento do Periodo Anterior */
              AND faturamento.cod-gr-canais = grupo-canais.cod-gr-canais:

                log-manager:write-message("MSG0184 Faturamento " + faturamento.unid-neg + ' - ' + faturamento.segmento ).

                FIND FIRST FaturamentoMensal
                    WHERE FaturamentoMensal.DescricaoGrupoCanais = grupo-canais.descricao
                      AND FaturamentoMensal.PeriodoAtual         = STRING(MONTH(TODAY),'99')   + "/" + STRING(YEAR(TODAY),'9999') 
                      AND FaturamentoMensal.PeriodoAnterior      = STRING(MONTH(da-data),'99') + "/" + STRING(YEAR(da-data),'9999') 
                      NO-LOCK NO-ERROR.

                IF NOT AVAIL FaturamentoMensal THEN DO:
                    CREATE FaturamentoMensal.
                    ASSIGN FaturamentoMensal.DescricaoGrupoCanais = grupo-canais.descricao   
                           FaturamentoMensal.PeriodoAtual         = STRING(MONTH(TODAY),'99')   + "/" + STRING(YEAR(TODAY),'9999')     
                           FaturamentoMensal.PeriodoAnterior      = STRING(MONTH(da-data),'99') + "/" + STRING(YEAR(da-data),'9999')        .
                END. /* IF NOT AVAIL FaturamentoMensal THEN DO: */

                ASSIGN FaturamentoMensal.ValorTotalFaturOrcadoAnterior     = FaturamentoMensal.ValorTotalFaturOrcadoAnterior     + faturamento.vl-fat-orc 
                       FaturamentoMensal.ValorTotalFaturRealizadoAnterior  = FaturamentoMensal.ValorTotalFaturRealizadoAnterior  + faturamento.vl-fat-real.
                       


                FIND FIRST UnidadeNegocioCanal
                    WHERE UnidadeNegocioCanal.NomeUnidadeNegocio  = faturamento.unid-neg EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL UnidadeNegocioCanal THEN DO:
                    ASSIGN UnidadeNegocioCanal.FaturamentoOrcadoAnterior    = UnidadeNegocioCanal.FaturamentoOrcadoAnterior    + faturamento.vl-fat-orc 
                           UnidadeNegocioCanal.FaturamentoRealizadoAnterior = UnidadeNegocioCanal.FaturamentoRealizadoAnterior + faturamento.vl-fat-real.
                           
                END. /* IF AVAIL UnidadeNegocioCanal THEN DO: */
                ELSE DO:
                    CREATE UnidadeNegocioCanal.
                    ASSIGN UnidadeNegocioCanal.NomeUnidadeNegocio           = faturamento.unid-neg
                           UnidadeNegocioCanal.FaturamentoOrcadoAnterior    = faturamento.vl-fat-orc 
                           UnidadeNegocioCanal.FaturamentoRealizadoAnterior = faturamento.vl-fat-real.
                           
                END. /* IF NOT AVAIL UnidadeNegocioCanal THEN DO: */

                FIND FIRST SegmentoUnidadeNegocio
                    WHERE SegmentoUnidadeNegocio.NomeSegmento       = faturamento.segmento 
                      AND SegmentoUnidadeNegocio.NomeUnidadeNegocio = faturamento.unid-neg EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL SegmentoUnidadeNegocio THEN DO:
                    ASSIGN SegmentoUnidadeNegocio.FaturamentoOrcadoAnterior    = SegmentoUnidadeNegocio.FaturamentoOrcadoAnterior    + faturamento.vl-fat-orc 
                           SegmentoUnidadeNegocio.FaturamentoRealizadoAnterior = SegmentoUnidadeNegocio.FaturamentoRealizadoAnterior + faturamento.vl-fat-real.
                           
                END. /* IF AVAIL SegmentoUnidadeNegocio THEN DO: */
                ELSE DO:
                    CREATE SegmentoUnidadeNegocio.
                    ASSIGN SegmentoUnidadeNegocio.NomeSegmento                 = faturamento.segmento
                           SegmentoUnidadeNegocio.NomeUnidadeNegocio           = faturamento.unid-neg
                           SegmentoUnidadeNegocio.FaturamentoOrcadoAnterior    = faturamento.vl-fat-orc 
                           SegmentoUnidadeNegocio.FaturamentoRealizadoAnterior = faturamento.vl-fat-real.
                           
                END. /* IF NOT AVAIL SegmentoUnidadeNegocio THEN DO: */

                log-manager:write-message("MSG0184 depois criou ttable msg0184 " + grupo-canais.descricao + faturamento.segmento + faturamento.unid-neg).

        END. /* FOR EACH faturamento */

    END. /* FOR EACH faturamento-segmento-ordem */
    
END. /* IF AVAIL grupo-canais THEN DO: */

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.
ELSE 
    ASSIGN resultado.Mensagem = "Integra‡Æo ocorrida com sucesso.".

    IF resultado.Mensagem = "" THEN
        ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.


