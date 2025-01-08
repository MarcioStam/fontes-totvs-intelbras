CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx295   AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                               */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                               */
/*                                                                                                    */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                              */
/*                <MENSAGEM>                                                                          */
/*                    <CABECALHO>                                                                     */
/*                        <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                        <NumeroOperacao>260953-ga046926</NumeroOperacao>                            */
/*                        <CodigoMensagem>MSG0226</CodigoMensagem>                                    */
/*                        <LoginUsuario>gi041250</LoginUsuario>                                       */
/*                    </CABECALHO>                                                                    */
/*                    <CONTEUDO>                                                                      */
/*                       <MSG0229>                                                                    */
/*                            <NumeroEmbarque>100048</NumeroEmbarque>                                 */
/*                            <CodigoEstabelecimento>101</CodigoEstabelecimento>                      */
/*                            <CommercialInvoice>                                                     */
/*                                <NumeroCommercialInvoice>123</NumeroCommercialInvoice>              */
/*                                <ParcelaCommercialInvoice>3</ParcelaCommercialInvoice>              */
/*                                <DataCommercialInvoice>2015-12-15</DataCommercialInvoice>           */
/*                                <ValorCommercialInvoice>270</ValorCommercialInvoice>                */
/*                                <CodigoMoedaEMS>0</CodigoMoedaEMS>                                  */
/*                            </CommercialInvoice>                                                    */
/*                        </MSG0229>                                                                  */
/*                    </CONTEUDO>                                                                     */
/*                </MENSAGEM>".                                                                       */

{esp/esb/in/msg0229.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0229, CommercialInvoice
   DATA-RELATION FOR conteudo, MSG0229 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0229, CommercialInvoice  RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0229R1, resultado
   DATA-RELATION FOR conteudor, MSG0229R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0229R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0229R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0229 NO-ERROR.

CREATE conteudor.
CREATE MSG0229R1.
CREATE resultado.

RUN pi-gera-fatura-embarque.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE pi-gera-fatura-embarque:

    blk_fatura-embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_fatura-embarque, LEAVE blk_fatura-embarque
    ON STOP  UNDO blk_fatura-embarque, LEAVE blk_fatura-embarque: 

        RUN cxbo/bocx295.p  PERSISTENT SET h-bocx295.
        RUN openQuery IN h-bocx295 (INPUT 1).
        
        FOR EACH CommercialInvoice:
            
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = MSG0229.CodigoEstabelecimento NO-ERROR.

            IF NOT AVAIL estabelec THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado estabelecimento: " + STRING(MSG0229.CodigoEstabelecimento)).
                RETURN "NOK".
            END.

            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.embarque    = MSG0229.NumeroEmbarque 
                   AND embarque-imp.cod-estabel = MSG0229.CodigoEstabelecimento NO-ERROR.

            IF NOT AVAIL embarque-imp THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado embarque n£mero: " + STRING(MSG0229.NumeroEmbarque) + " estabelecimento " + STRING(MSG0229.CodigoEstabelecimento)).
                RETURN "NOK".
            END.

            FIND FIRST moeda NO-LOCK
                 WHERE moeda.mo-codigo = CommercialInvoice.CodigoMoedaEMS NO-ERROR.

            IF NOT AVAIL moeda THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado moeda: " + STRING(CommercialInvoice.CodigoMoedaEMS)).
                RETURN "NOK".
            END.

            FIND FIRST invoice-emb-imp NO-LOCK
                 WHERE invoice-emb-imp.cod-estabel = MSG0229.CodigoEstabelecimento
                   AND invoice-emb-imp.embarque    = MSG0229.NumeroEmbarque       
                   AND invoice-emb-imp.nr-invoice  = CommercialInvoice.NumeroCommercialInvoice 
                   AND invoice-emb-imp.parcela     = CommercialInvoice.ParcelaCommercialInvoice NO-ERROR.

            /*Cria‡Æo*/
            IF NOT AVAIL invoice-emb-imp THEN DO:
                
                CREATE tt-invoice-emb-imp.                        
                ASSIGN tt-invoice-emb-imp.cod-estabel = MSG0229.CodigoEstabelecimento
                       tt-invoice-emb-imp.embarque    = MSG0229.NumeroEmbarque       
                       tt-invoice-emb-imp.nr-invoice  = CommercialInvoice.NumeroCommercialInvoice   
                       tt-invoice-emb-imp.parcela     = CommercialInvoice.ParcelaCommercialInvoice  
                       tt-invoice-emb-imp.dt-vencim   = CommercialInvoice.DataCommercialInvoice     
                       tt-invoice-emb-imp.vl-invoice  = CommercialInvoice.ValorCommercialInvoice    
                       tt-invoice-emb-imp.mo-codigo   = CommercialInvoice.CodigoMoedaEMS.

                RUN validateCreate IN h-bocx295 (INPUT  TABLE tt-invoice-emb-imp,
                                                 OUTPUT TABLE RowErrors,
                                                 OUTPUT r-rowid).        
        
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                        RETURN "NOK".
                    END. 
                END.    

            END.
            /*Altera‡Æo*/
            ELSE DO:
                CREATE tt-invoice-emb-imp.
                BUFFER-COPY invoice-emb-imp TO tt-invoice-emb-imp.

                ASSIGN tt-invoice-emb-imp.dt-vencim   = CommercialInvoice.DataCommercialInvoice     
                       tt-invoice-emb-imp.vl-invoice  = CommercialInvoice.ValorCommercialInvoice    
                       tt-invoice-emb-imp.mo-codigo   = CommercialInvoice.CodigoMoedaEMS.

                RUN validateUpdate IN h-bocx295 (INPUT  TABLE tt-invoice-emb-imp,
                                                 INPUT  ROWID(invoice-emb-imp),
                                                 OUTPUT TABLE RowErrors). 
    
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).                
                    END. 
                    RETURN "NOK".
                END.            
            END.
            
        END.    

        /*Elimina Handles*/
        IF VALID-HANDLE(h-bocx295) THEN DO:
            DELETE PROCEDURE h-bocx295 NO-ERROR.
            ASSIGN h-bocx295 = ?.
        END.
    END.
    
    IF NOT CAN-FIND (FIRST tt-erro) THEN
        RETURN "OK".
    ELSE 
        RETURN "NOK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
