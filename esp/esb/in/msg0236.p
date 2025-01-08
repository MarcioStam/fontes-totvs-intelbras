CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.


/*DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.

ASSIGN iXML = "<?xml version='1.0' encoding='ISO-8859-1' ?>
<MENSAGEM xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
    <CABECALHO>
        <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor>
        <NumeroOperacao>MSG0236</NumeroOperacao>
        <CodigoMensagem>MSG0236</CodigoMensagem>
        <LoginUsuario />
    </CABECALHO>
    <CONTEUDO>
        <MSG0236>
            <NumeroPedidoCompra>263155</NumeroPedidoCompra>
            <ConsultarSerialNumbers>NO</ConsultarSerialNumbers>
            <ConsultarMacAddresses>YES</ConsultarMacAddresses>
            <ItensConsulta>
                <CodigoProduto>4005066</CodigoProduto>
            </ItensConsulta>
        </MSG0236>
    </CONTEUDO>
</MENSAGEM>".*/


{esp/esb/in/msg0236.i}
{esapi/esapi023.i}     /*ttItem*/
{cdp/cd0666.i}         /*tt-erro*/

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0236, ItensConsulta
    DATA-RELATION FOR conteudo, MSG0236       RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0236,  ItensConsulta RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0236R1, MSG_Mac_R1, MSG_SN_R1, resultado
   DATA-RELATION FOR conteudor, MSG0236R1  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0236R1, MSG_Mac_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0236R1, MSG_SN_R1  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0236R1, resultado  RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0236R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0236 NO-ERROR.

CREATE conteudor.
CREATE MSG0236R1.
CREATE resultado.

RUN piBuscaDados.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/*
DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
*/

RETURN.

PROCEDURE piBuscaDados:
    DEFINE VARIABLE h-api023 AS HANDLE NO-UNDO.
    DEFINE BUFFER bfItensConsulta FOR ItensConsulta.

    ASSIGN c-arquivo-log1 = '/mnt/spool/is055792/msg0236.txt'.

    //ASSIGN c-arquivo-log1 = 'C:/temp/msg0236.txt'.

    //RUN pi-gerar-dados-extrato ("passou 1").

    RUN esapi/esapi023.p PERSISTENT SET h-api023.

    RUN piCarrega_ttItem IN h-api023 (INPUT MSG0236.NumeroPedidoCompra,
                                      OUTPUT TABLE ttItem,
                                      OUTPUT TABLE tt-mac-address,
                                      OUTPUT TABLE ttArq).

    

    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.

    FIND FIRST ItensConsulta NO-ERROR.

    IF NOT AVAIL ItensConsulta THEN DO:
        IF MSG0236.ConsultarSerialNumbers THEN DO:
            FOR EACH ttArq:
                CREATE MSG_SN_R1.
                ASSIGN MSG_SN_R1.CodigoProduto = ttArq.it-codigo
                       MSG_SN_R1.SerialNumber  = ttArq.num-serie.
            END.
        END.
        
        IF MSG0236.ConsultarMacAddresses THEN DO:
            FOR EACH tt-mac-address BY sequencia:
                CREATE MSG_Mac_R1.
                ASSIGN MSG_Mac_R1.CodigoProduto = tt-mac-address.it-codigo
                       MSG_Mac_R1.MacAddress    = tt-mac-address.mac
                       MSG_Mac_R1.SenhaWifi     = tt-mac-address.senha-wifi
                       MSG_Mac_R1.SenhaAdm      = tt-mac-address.senha-adm. 

                RUN pi-gerar-dados-extrato (MSG_Mac_R1.SenhaWifi + ' - ' + MSG_Mac_R1.SenhaAdm). 
            END.
        END.
    END.
    ELSE DO:
        FOR EACH ItensConsulta:
            IF MSG0236.ConsultarSerialNumbers THEN DO:
                FOR EACH ttArq
                    WHERE ttArq.it-codigo = ItensConsulta.CodigoProduto:
                    CREATE MSG_SN_R1.
                    ASSIGN MSG_SN_R1.CodigoProduto = ttArq.it-codigo
                           MSG_SN_R1.SerialNumber  = ttArq.num-serie.
                END.
            END.
            
            IF MSG0236.ConsultarMacAddresses THEN DO:
                FOR EACH tt-mac-address
                    WHERE tt-mac-address.it-codigo = ItensConsulta.CodigoProduto BY sequencia:
                    CREATE MSG_Mac_R1.
                    ASSIGN MSG_Mac_R1.CodigoProduto = tt-mac-address.it-codigo
                           MSG_Mac_R1.MacAddress    = tt-mac-address.mac
                           MSG_Mac_R1.SenhaWifi     = tt-mac-address.senha-wifi
                           MSG_Mac_R1.SenhaAdm      = tt-mac-address.senha-adm.  

                    RUN pi-gerar-dados-extrato (MSG_Mac_R1.SenhaWifi + ' - ' + MSG_Mac_R1.SenhaAdm). 

                END.
            END.
        END.
    END.

    RUN pi-gerar-dados-extrato ('FINAL DE TUDO'). 

    ASSIGN MSG0236R1.NumeroPedidoCompra = MSG0236.NumeroPedidoCompra.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.






PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT  p-string  FORMAT "x(200)" SKIP.
       OUTPUT CLOSE. 
    
    end.
END PROCEDURE.
