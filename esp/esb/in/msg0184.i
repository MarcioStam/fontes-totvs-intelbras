DEFINE TEMP-TABLE MSG0184 NO-UNDO XML-NODE-NAME 'MSG0184'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD DescricaoGrupoCanais    AS CHARACTER.

DEFINE TEMP-TABLE MSG0184r1 NO-UNDO XML-NODE-NAME 'MSG0184R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE FaturamentoMensal NO-UNDO XML-NODE-NAME 'FaturamentoMensal'
    FIELD idm                             AS INT XML-NODE-TYPE 'hidden'
                                          
    FIELD DescricaoGrupoCanais                    AS CHARACTER 
    FIELD PeriodoAtual                            AS CHARACTER 
    FIELD PeriodoAnterior                         AS CHARACTER 
    FIELD ValorTotalFaturOrcadoAtual              AS DECIMAL
    FIELD ValorTotalFaturRealizadoAtual           AS DECIMAL
    FIELD ValorTotalCarteiraAtual                 AS DECIMAL
    FIELD ValorTotalFaturOrcadoAnterior           AS DECIMAL
    FIELD ValorTotalFaturRealizadoAnterior        AS DECIMAL.
    

DEFINE TEMP-TABLE UnidadeNegocioCanal NO-UNDO XML-NODE-NAME 'UnidadeNegocioCanal'
    FIELD idm                                     AS INT XML-NODE-TYPE 'hidden'
    FIELD chave                                   AS INT XML-NODE-TYPE 'hidden'
                                                  
    FIELD NomeUnidadeNegocio                      AS CHARACTER
    FIELD FaturamentoOrcadoAtual                  AS DECIMAL
    FIELD FaturamentoRealizadoAtual               AS DECIMAL
    FIELD FaturamentoOrcadoAnterior               AS DECIMAL
    FIELD FaturamentoRealizadoAnterior            AS DECIMAL
    FIELD ValorCarteiraAtual                      AS DECIMAL.

DEFINE TEMP-TABLE SegmentoUnidadeNegocio NO-UNDO XML-NODE-NAME 'SegmentoUnidadeNegocio'
    FIELD idm                                     AS INT XML-NODE-TYPE 'hidden'
    FIELD chave                                   AS INT XML-NODE-TYPE 'hidden'
                                                 
    FIELD NomeSegmento                            AS CHARACTER
    FIELD NomeUnidadeNegocio                      AS CHARACTER 
    FIELD FaturamentoOrcadoAtual                  AS DECIMAL
    FIELD FaturamentoOrcadoAnterior               AS DECIMAL     
    FIELD FaturamentoRealizadoAtual               AS DECIMAL
    FIELD FaturamentoRealizadoAnterior            AS DECIMAL
    FIELD ValorCarteiraAtual                      AS DECIMAL.
                                          
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
