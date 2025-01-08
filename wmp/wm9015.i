/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/
/********************************************************************************
**  Programa: WM9015.I - Defini‡Æo da TT-LOTE
*********************************************************************************/

DEFINE TEMP-TABLE tt-lote NO-UNDO
    FIELD lote-refer      AS CHARACTER FORMAT "x(30)"
    FIELD qtde-lote       LIKE wm-docto-itens.qtd-item
    FIELD dias-venc       AS INTEGER
    FIELD id-atende       AS LOGICAL
    FIELD r-saldo-estoque AS ROWID
    FIELD dt-vali-lote    AS DATE
    INDEX idx-r-saldo     IS PRIMARY r-saldo-estoque
    INDEX idx-atende      id-atende lote-refer.
