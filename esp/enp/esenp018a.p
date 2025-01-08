/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP018A 2.00.00.000}
/*------------------------------------------------------------------------
    File        : ESENP018A.p
    Purpose     : Verificar a estrutura do item da estrutura atual.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Janeiro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER p-it-codigo    LIKE item.it-codigo    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-peso-liquido LIKE item.peso-liquido NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-peso-bruto   LIKE item.peso-bruto   NO-UNDO.
DEFINE INPUT        PARAMETER p-acomp        AS HANDLE              NO-UNDO.

/* Include Definitions ---                                              */
{cdp/cdcfgman.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE v-quant-usada  LIKE estrutura.quant-usada  NO-UNDO.
DEFINE VARIABLE v-quant-liquid LIKE estrutura.quant-liquid NO-UNDO.


/* ********************  Preprocessor Definitions  ******************** */
FIND FIRST estrutura
    WHERE estrutura.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE estrutura THEN
    RETURN "NOK":U.

FOR EACH estrutura USE-INDEX codigo NO-LOCK
    WHERE estrutura.it-codigo    =  p-it-codigo
      AND estrutura.data-inicio <= TODAY
      AND estrutura.data-termino > TODAY:

    IF VALID-HANDLE(p-acomp) THEN
        RUN pi-acompanhar IN p-acomp (INPUT "Item: ":U + estrutura.es-codigo).

    /* Verifica a ESTRUTURA do item atual da estrutura atual */
    RUN esp/enp/esenp018a.p (INPUT estrutura.es-codigo,
                             INPUT-OUTPUT p-peso-liquido,
                             INPUT-OUTPUT p-peso-bruto,
                             INPUT p-acomp).

    /* Caso n∆o encontre ESTRUTURA abaixo do item atual da estrutura atual, busca o peso e grava na vari†vel */
    IF RETURN-VALUE = "NOK":U THEN DO:
        FIND FIRST item
            WHERE item.it-codigo = estrutura.es-codigo NO-LOCK NO-ERROR.

        /* Verifica a quantidade usada na estrutura */
        &IF DEFINED (bf_man_sfc_lc) &THEN
        ASSIGN v-quant-usada  = (estrutura.qtd-compon / estrutura.qtd-item) * (estrutura.proporcao / 100)
               v-quant-liquid = v-quant-usada * (1 - (estrutura.fator-perda / 100)).
        &ELSE
        ASSIGN v-quant-usada  = estrutura.quant-usada * (estrutura.proporcao / 100)
               v-quant-liquid = estrutura.quant-usada * (estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).
        &ENDIF

        ASSIGN p-peso-liquido = p-peso-liquido + (IF AVAILABLE item THEN (item.peso-liquido * v-quant-liquid) ELSE 0)
               p-peso-bruto   = p-peso-bruto   + (IF AVAILABLE item THEN (item.peso-bruto   * v-quant-usada)  ELSE 0).
    END.
END.

RETURN "OK":U.

