CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx220   AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.
{esp/esapi505b.i}  


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
/*                        <MSG0231>                                                                   */
/*                            <NumeroEmbarque>123abc</NumeroEmbarque>                                 */
/*                            <CodigoEstabelecimento>104</CodigoEstabelecimento>                      */
/*                            <CodigoViaTransporte>2</CodigoViaTransporte>                            */
/*                            <CodigoIncoterm>FOB</CodigoIncoterm>                                    */
/*                            <Narrativa></Narrativa>                                                 */
/*                            <DataNecessidadeFabrica></DataNecessidadeFabrica>                       */
/*                            <Master></Master>                                                       */
/*                            <House></House>                                                         */
/*                            <CodigoTransportadora></CodigoTransportadora>                           */
/*                            <CodigoCorretorCambio></CodigoCorretorCambio>                           */
/*                            <CodigoDespachante></CodigoDespachante>                                 */
/*                            <CodigoDespachanteExterior></CodigoDespachanteExterior>                 */
/*                            <CodigoSeguradora></CodigoSeguradora>                                   */
/*                            <CodigoCorretorSeguro></CodigoCorretorSeguro>                           */
/*                            <TipoContainer></TipoContainer>                                         */
/*                            <Quantidade1Container></Quantidade1Container>                           */
/*                            <Quantidade2Container></Quantidade2Container>                           */
/*                            <MatriculaResponsavel></MatriculaResponsavel>                           */
/*                            <FinanceiroFiscal>                                                      */
/*                                <ROF>ROF</ROF>                                                      */
/*                                <DISiscomex></DISiscomex>                                           */
/*                                <DIEMS></DIEMS>                                                     */
/*                                <DataDI></DataDI>                                                   */
/*                                <NaturezaCambial></NaturezaCambial>                                 */
/*                                <NumeroCartaCredito>123</NumeroCartaCredito>                        */
/*                                <CodigoBanco></CodigoBanco>                                         */
/*                                <DataSolicitacaoCartaCredito></DataSolicitacaoCartaCredito>         */
/*                                <DataAprovacaoCartaCredito></DataAprovacaoCartaCredito>             */
/*                                <DataValidadeCartaCredito></DataValidadeCartaCredito>               */
/*                                <DeadlineCartaCredito></DeadlineCartaCredito>                       */
/*                                <ValorCartaCredito></ValorCartaCredito>                             */
/*                                <CodigoMoedaEMS></CodigoMoedaEMS>                                   */
/*                            </FinanceiroFiscal>                                                     */
/*                      </MSG0231>                                                                    */
/*                    </CONTEUDO>                                                                     */
/*                </MENSAGEM>".                                                                       */

{esp/esb/in/msg0231.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0231, FinanceiroFiscal
   DATA-RELATION FOR conteudo, MSG0231         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0231, FinanceiroFiscal RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0231R1, resultado
   DATA-RELATION FOR conteudor, MSG0231R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0231R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 
DEFINE BUFFER b-embarque-imp FOR embarque-imp.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0231R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0231 NO-ERROR.
FIND FIRST FinanceiroFiscal NO-ERROR.

CREATE conteudor.
CREATE MSG0231R1.
CREATE resultado.

blk: DO ON STOP UNDO, LEAVE TRANSACTION:

   RUN pi-gera-embarque.
   
   IF  RETURN-VALUE <> "OK" THEN DO:
       
       ASSIGN resultado.sucesso    = no
              resultado.CodigoErro = 17006
              resultado.Mensagem   = "".
   
       FOR EACH tt-erro
           BREAK BY tt-erro.Mensagem:
           ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
       END.

       ASSIGN
          lgRollback = YES.
       MESSAGE ">>> MSG0231 - STOP ".
       STOP.
   END.

END.
RUN pi-output-grava-rollback.


DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-embarque:

    blk_embarque:
    DO TRANSACTION
    ON ERROR UNDO blk_embarque, LEAVE blk_embarque
    ON STOP  UNDO blk_embarque, LEAVE blk_embarque: 

        RUN cxbo/bocx220.p  PERSISTENT SET h-bocx220.
        RUN openQuery IN h-bocx220 (INPUT 1).

        IF msg0231.NumeroEmbarque = "" THEN DO:
            RUN pi-erro (INPUT "N£mero do embarque est  vazio!").
            RETURN "NOK".
        END.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.cod-estabel = msg0231.CodigoEstabelecimento
               AND embarque-imp.embarque    = msg0231.NumeroEmbarque NO-ERROR.
        
        /*Cria‡Æo*/
        IF NOT AVAIL embarque-imp THEN DO:
            
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = msg0231.CodigoEstabelecimento NO-ERROR.

            IF NOT AVAIL estabelec THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado estabelecimento " + msg0231.CodigoEstabelecimento).
                RETURN "NOK".
            END.

            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-conhecto-house = msg0231.House NO-ERROR.

            IF AVAIL embarque-imp
            AND msg0231.House <> "" THEN DO:
                RUN pi-erro (INPUT "House j  existente no embarque: " + embarque-imp.embarque).
                RETURN "NOK".
            END.

            CREATE tt-embarque-imp.
            ASSIGN tt-embarque-imp.embarque                   = msg0231.NumeroEmbarque             
                   tt-embarque-imp.cod-estabel                = msg0231.CodigoEstabelecimento      
                   tt-embarque-imp.cod-via-transp             = msg0231.CodigoViaTransporte        
                   tt-embarque-imp.cod-incoterm               = msg0231.CodigoIncoterm             
                   tt-embarque-imp.narrativa                  = msg0231.Narrativa                  
                   tt-embarque-imp.cod-conhecto-master        = msg0231.Master                     
                   tt-embarque-imp.cod-conhecto-house         = msg0231.House                      
                   tt-embarque-imp.cod-transportador          = msg0231.CodigoTransportadora       
                   tt-embarque-imp.cdn-corretor-cambio-import = msg0231.CodigoCorretorCambio       
                   tt-embarque-imp.cod-despachante            = msg0231.CodigoDespachante          
                   tt-embarque-imp.cdn-despa-exter-import     = msg0231.CodigoDespachanteExterior  
                   tt-embarque-imp.cdn-segurad-import         = msg0231.CodigoSeguradora           
                   tt-embarque-imp.cdn-corretor-import        = msg0231.CodigoCorretorSeguro.

            IF tt-embarque-imp.cod-via-transp = 10
            THEN ASSIGN
               tt-embarque-imp.cod-via-transp = 8.

            IF AVAIL FinanceiroFiscal THEN DO:
                ASSIGN tt-embarque-imp.nr-rof             = FinanceiroFiscal.ROF                           
                       tt-embarque-imp.declaracao-import  = FinanceiroFiscal.DISiscomex                  
                       tt-embarque-imp.int-2              = FinanceiroFiscal.DIEMS                       
                       tt-embarque-imp.data-di            = FinanceiroFiscal.DataDI                      
                       tt-embarque-imp.int-1              = FinanceiroFiscal.NaturezaCambial             
                       tt-embarque-imp.carta-credito      = FinanceiroFiscal.NumeroCartaCredito          
                       tt-embarque-imp.cod-banco          = FinanceiroFiscal.CodigoBanco.                 
            END.

            RUN validateCreate IN h-bocx220 (INPUT  TABLE tt-embarque-imp,
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

            FIND FIRST b-embarque-imp NO-LOCK
                 WHERE b-embarque-imp.cod-conhecto-house = msg0231.House
                   AND ROWID(b-embarque-imp) <> ROWID(embarque-imp) NO-ERROR.

            IF AVAIL b-embarque-imp
            AND msg0231.House <> "" THEN DO:
                RUN pi-erro (INPUT "House j  existente no embarque: " + b-embarque-imp.embarque).
                RETURN "NOK".
            END.
            
            CREATE tt-embarque-imp.
            BUFFER-COPY embarque-imp TO tt-embarque-imp.

            ASSIGN tt-embarque-imp.embarque                   = msg0231.NumeroEmbarque             
                   tt-embarque-imp.cod-estabel                = msg0231.CodigoEstabelecimento      
                   tt-embarque-imp.cod-via-transp             = msg0231.CodigoViaTransporte        
                   tt-embarque-imp.cod-incoterm               = msg0231.CodigoIncoterm             
                   tt-embarque-imp.narrativa                  = msg0231.Narrativa
                   tt-embarque-imp.cod-conhecto-master        = msg0231.Master                     
                   tt-embarque-imp.cod-conhecto-house         = msg0231.House                      
                   tt-embarque-imp.cod-transportador          = msg0231.CodigoTransportadora       
                   tt-embarque-imp.cdn-corretor-cambio-import = msg0231.CodigoCorretorCambio       
                   tt-embarque-imp.cod-despachante            = msg0231.CodigoDespachante          
                   tt-embarque-imp.cdn-despa-exter-import     = msg0231.CodigoDespachanteExterior  
                   tt-embarque-imp.cdn-segurad-import         = msg0231.CodigoSeguradora           
                   tt-embarque-imp.cdn-corretor-import        = msg0231.CodigoCorretorSeguro.

            IF AVAIL FinanceiroFiscal THEN DO:
                ASSIGN tt-embarque-imp.nr-rof             = FinanceiroFiscal.ROF                           
                       tt-embarque-imp.declaracao-import  = FinanceiroFiscal.DISiscomex                  
                       tt-embarque-imp.int-2              = FinanceiroFiscal.DIEMS                       
                       tt-embarque-imp.data-di            = FinanceiroFiscal.DataDI                      
                       tt-embarque-imp.int-1              = FinanceiroFiscal.NaturezaCambial             
                       tt-embarque-imp.carta-credito      = FinanceiroFiscal.NumeroCartaCredito          
                       tt-embarque-imp.cod-banco          = FinanceiroFiscal.CodigoBanco.                 
            END.

            RUN validateUpdate IN h-bocx220 (INPUT  TABLE tt-embarque-imp,
                                             INPUT  ROWID(embarque-imp),
                                             OUTPUT TABLE RowErrors). 

            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                
                END. 
                RETURN "NOK".
            END.            
        END.

        /*Salva campos espec¡ficos*/
        FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
             WHERE ext-embarque-imp.cod-estabel = tt-embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = tt-embarque-imp.embarque NO-ERROR.
        
        IF NOT AVAIL ext-embarque-imp THEN DO:
            CREATE ext-embarque-imp.
            ASSIGN ext-embarque-imp.cod-estabel = tt-embarque-imp.cod-estabel 
                   ext-embarque-imp.embarque    = tt-embarque-imp.embarque.
        END.

        ASSIGN ext-embarque-imp.conteiner              = msg0231.TipoContainer              
               ext-embarque-imp.qtd-conteiner          = msg0231.Quantidade1Container       
               ext-embarque-imp.qtd2-conteiner         = msg0231.Quantidade2Container       
               ext-embarque-imp.MatriculaResponsavel   = msg0231.MatriculaResponsavel
               ext-embarque-imp.DataNecessidadeFabrica = msg0231.DataNecessidadeFabrica
               ext-embarque-imp.PossuiAnexo            = msg0231.PossuiAnexos
               ext-embarque-imp.log-envio-comex        = msg0231.LogEnvioComex
               ext-embarque-imp.log-libera-alteracao   = msg0231.LogLiberaAlteracaoComex
               ext-embarque-imp.log-libera-modal       = msg0231.LogLiberaModalComex
               ext-embarque-imp.finalidade-currier     = msg0231.FinalidadeCourier      
               .

        IF AVAIL FinanceiroFiscal THEN DO:
            ASSIGN ext-embarque-imp.DataSolicitacaoCartaCredito = FinanceiroFiscal.DataSolicitacaoCartaCredito
                   ext-embarque-imp.DataAprovacaoCartaCredito   = FinanceiroFiscal.DataAprovacaoCartaCredito  
                   ext-embarque-imp.DataValidadeCartaCredito    = FinanceiroFiscal.DataValidadeCartaCredito   
                   ext-embarque-imp.DeadlineCartaCredito        = FinanceiroFiscal.DeadlineCartaCredito       
                   ext-embarque-imp.ValorCartaCredito           = FinanceiroFiscal.ValorCartaCredito          
                   ext-embarque-imp.CodigoMoedaEMS              = FinanceiroFiscal.CodigoMoedaEMS.             
        END.

        
        IF  ext-embarque-imp.log-envio-comex   = YES
        AND ext-embarque-imp.log-enviado-comex = NO
        THEN DO:
           IF msg0231.CodigoViaTransporte = 8
           THEN RUN pi-output-api-request  ("CEX",
                                            "1",
                                            "ProcessoEX-CUR",
                                            "MSG231",
                                            ext-embarque-imp.cod-estabel + "," + ext-embarque-imp.embarque,
                                            lcRequest
                                           ).
           ELSE RUN pi-output-api-request  ("CEX",
                                            "1",
                                            "ProcessoEX-NEW",
                                            "MSG231",
                                            ext-embarque-imp.cod-estabel + "," + ext-embarque-imp.embarque,
                                            lcRequest
                                           ).
           FOR EACH apiRowErrors:
              RUN pi-erro ("DATI - " + apiRowErrors.ErrorDescription).
           END.
        END.
        RELEASE ext-embarque-imp.
    END.
    
    /*Elimina Handles*/
    IF VALID-HANDLE(h-bocx220) THEN DO:
        DELETE PROCEDURE h-bocx220 NO-ERROR.
        ASSIGN h-bocx220 = ?.
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

    
    
