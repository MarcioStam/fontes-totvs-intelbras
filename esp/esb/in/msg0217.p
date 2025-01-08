CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{upc/btb910za-upc.i} 
DEFINE VARIABLE v-data AS DATE        NO-UNDO.

DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.
DEFINE BUFFER b2-ordem-compra FOR ordem-compra.
DEFINE BUFFER b-cotacao-item FOR cotacao-item.
DEFINE VARIABLE de-unit AS DECIMAL     NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>473394-104</NumeroOperacao>                                 */
/*     <CodigoMensagem>MSG0217</CodigoMensagem>                                    */
/*     <LoginUsuario>ci051245</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0217>                                                                   */
/*       <NumeroEmbarque>473394</NumeroEmbarque>                                   */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*     </MSG0217>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0217.i}

DEFINE VARIABLE h-bocx295 AS HANDLE      NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0217
   DATA-RELATION FOR conteudo, MSG0217           RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0217_R1, PrevisaoFatura, resultado
   DATA-RELATION FOR conteudor, MSG0217_R1      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0217_R1, PrevisaoFatura RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0217_R1, resultado      RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0217R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0217 NO-ERROR.

CREATE conteudor.
CREATE MSG0217_R1.
CREATE resultado.

RUN pi-previsao-fatura.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

RUN destroy IN h-bocx295 NO-ERROR.
IF  VALID-HANDLE(h-bocx295) THEN DO:
    DELETE PROCEDURE h-bocx295.
    ASSIGN h-bocx295 = ?.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-previsao-fatura:
    RUN cxbo/bocx295.p PERSISTENT SET h-bocx295.

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = MSG0217.CodigoEstabelecimento
           AND embarque-imp.embarque    = MSG0217.NumeroEmbarque NO-ERROR.

    IF NOT AVAIL embarque-imp THEN DO:
        RUN pi-erro (INPUT "Embarque nÆo encontrado " + STRING(MSG0217.NumeroEmbarque) + " estabelecimento " + MSG0217.CodigoEstabelecimento).
        RETURN "NOK".
    END.

    CREATE PrevisaoFatura.
    ASSIGN PrevisaoFatura.NumeroEmbarque         = MSG0217.NumeroEmbarque
           PrevisaoFatura.CodigoEstabelecimento  = MSG0217.CodigoEstabelecimento.

    RUN inicializarFaturaordem IN h-bocx295 (INPUT  MSG0217.CodigoEstabelecimento,
                                             INPUT  MSG0217.NumeroEmbarque,
                                             OUTPUT PrevisaoFatura.ValorCommercialInvoice,
                                             OUTPUT PrevisaoFatura.DataCommercialInvoice,
                                             OUTPUT PrevisaoFatura.CodigoMoedaEMS).

    /*Alterar DataCommercialInvoice para proximo dia util*/
    FIND FIRST estabelecimento NO-LOCK
         WHERE estabelecimento.cod_estab = v_cod_estab_usuar NO-ERROR.

    FIND FIRST calend_glob NO-LOCK
         WHERE calend_glob.cod_calend = estabelecimento.cod_calend_mater NO-ERROR.

    ASSIGN v-data = PrevisaoFatura.DataCommercialInvoice.

    acha_dia_util:
    REPEAT:
        FIND FIRST dia_calend_glob NO-LOCK
             WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
               AND dia_calend_glob.dat_calend = v-data NO-ERROR.

        IF NOT AVAIL dia_calend_glob THEN
            LEAVE.

        IF dia_calend_glob.log_dia_util = NO THEN
            ASSIGN v-data = v-data + 1.
        ELSE
            LEAVE.
    END.

    ASSIGN PrevisaoFatura.DataCommercialInvoice = v-data.

    IF ValorCommercialInvoice > 0 THEN DO:
        /*Desconta valor das parcelas FOC*/
        FOR EACH b-ordens-embarque OF embarque-imp NO-LOCK,
           FIRST b2-ordem-compra OF b-ordens-embarque 
           WHERE b2-ordem-compra.cod-cond-pag = 63 NO-LOCK:
            FIND FIRST b-cotacao-item
                 WHERE b-cotacao-item.numero-ordem = b2-ordem-compra.numero-ordem
                   AND b-cotacao-item.it-codigo    = b2-ordem-compra.it-codigo
                   AND b-cotacao-item.cod-emitente = b2-ordem-compra.cod-emitente
                   AND b-cotacao-item.cot-aprovada = yes no-lock no-error.
    
            ASSIGN de-unit = 0.
            IF AVAIL b-cotacao-item THEN
                ASSIGN de-unit = (b-cotacao-item.pre-unit-for * 100) / (100 + b-cotacao-item.aliquota-ipi).
    
            ASSIGN PrevisaoFatura.ValorCommercialInvoice = PrevisaoFatura.ValorCommercialInvoice - (b-ordens-embarque.qt-do-forn * de-unit).
        END.
    END.

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = PrevisaoFatura.CodigoMoedaEMS NO-ERROR.

    IF AVAIL moeda THEN
        ASSIGN PrevisaoFatura.NomeMoeda = moeda.descricao.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

