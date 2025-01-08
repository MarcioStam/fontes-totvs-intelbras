TRIGGER PROCEDURE FOR DELETE OF cc_uni_estab.

/********************************************************************************
 ** UPC........: des487.p - UPC Delete cc_uni_estab    
 ** Data.......: 18/11/2015
 ** Objetivo...: Integrar centro de custo com sistema de viagens Alatur
 ********************************************************************************/

{utp/ut-glob.i}
{esp/es0018.i}

DEF TEMP-TABLE tt-integra-ccusto NO-UNDO
    FIELD c-cod-estab AS CHAR
    FIELD c-cod-ccusto AS CHAR
    FIELD c-nom-ccusto AS CHAR
    FIELD c-ind-movto  AS CHAR
    INDEX id-ccusto
            c-cod-ccusto
            c-cod-estab.

DEFINE VARIABLE c-estabelec AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cc-codigo AS CHARACTER   NO-UNDO.
    
EMPTY TEMP-TABLE tt-integra-ccusto.

RUN esp/es0018p.p (INPUT "msg0178", /* Nome do programa  */
                   INPUT 1,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FIND FIRST tt-prog-ponto
    WHERE entry(1,tt-prog-ponto.conteudo,";") = cc_uni_estab.cod_estab NO-LOCK NO-ERROR.

IF  AVAIL tt-prog-ponto THEN
    ASSIGN c-estabelec = entry(2,tt-prog-ponto.conteudo,";").
ELSE
    NEXT.

ASSIGN c-cc-codigo = CAPS(TRIM(cc_uni_estab.cod_unid_negoc)) + TRIM(cc_uni_estab.cod_ccusto).

FOR FIRST emscad.ccusto NO-LOCK
    WHERE emscad.ccusto.cod_empresa      = i-ep-codigo-usuario
      AND emscad.ccusto.cod_plano_ccusto = "padrao"
      AND emscad.ccusto.cod_ccusto       = cc_uni_estab.cod_ccusto:

    IF NOT CAN-FIND(FIRST tt-integra-ccusto
                    WHERE tt-integra-ccusto.c-cod-ccusto = c-cc-codigo
                      AND tt-integra-ccusto.c-cod-estab  = c-estabelec) 
    THEN DO:
        CREATE tt-integra-ccusto.
        ASSIGN tt-integra-ccusto.c-cod-estab  = c-estabelec
               tt-integra-ccusto.c-cod-ccusto = c-cc-codigo
               tt-integra-ccusto.c-nom-ccusto = TRIM(emscad.ccusto.des_tit_ctbl)
               tt-integra-ccusto.c-ind-movto  = "E". /* Elimina‡Æo */
    END.
END. /* FOR FIRST emscad.ccusto NO-LOCK */

FOR FIRST tt-integra-ccusto NO-LOCK:
    RUN esp/esb/out/msg0178.p (INPUT TABLE tt-integra-ccusto). /* Integrar com Barramento */
END.

