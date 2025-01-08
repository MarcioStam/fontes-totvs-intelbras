CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0171.i}
{esp/esb/esesb000fn2.i} /* fnConvDatetimeChar */

DEFINE VARIABLE d-saldo AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-data-entrada AS DATETIME        NO-UNDO.

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0171
   DATA-RELATION FOR conteudo, msg0171 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0171r, ItemCritico, resultado
   DATA-RELATION FOR conteudor, msg0171r   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0171r, ItemCritico RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0171r, resultado   RELATION-FIELDS (idm, idm) NESTED.

FIND FIRST msg0171.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor .
ASSIGN cabecalhor.CodigoMensagem = 'MSG0171R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0171r.

FOR EACH it-critico-cq NO-LOCK
    WHERE it-critico-cq.cod-estabel = msg0171.CodigoEstabelecimento
    AND   it-critico-cq.situacao    = 0 /* Aberto */:

    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = it-critico-cq.it-codigo:

        ASSIGN d-saldo = 0.

        FOR EACH saldo-estoq NO-LOCK
           WHERE saldo-estoq.it-codigo   = it-critico-cq.it-codigo
             AND saldo-estoq.cod-estabel = it-critico-cq.cod-estabel
             AND saldo-estoq.cod-depos   = "REC":
    
             IF  saldo-estoq.dt-vali-lote <> ? 
             AND saldo-estoq.dt-vali-lote <  TODAY THEN 
                 NEXT.
    
            ASSIGN d-saldo = d-saldo + saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod.
    
        END.

        IF d-saldo > 0  THEN DO:
            FOR LAST  movto-estoq NO-LOCK
                WHERE movto-estoq.cod-estabel   = it-critico-cq.cod-estabel
                  AND movto-estoq.cod-depos     = "REC"
                  AND movto-estoq.it-codigo     = it-critico-cq.it-codigo
                  AND movto-estoq.tipo-trans    = 1
                BY movto-estoq.nr-trans.

                ASSIGN d-data-entrada = DATETIME(MONTH(movto-estoq.dt-trans),
                                                 DAY(movto-estoq.dt-trans),
                                                 YEAR(movto-estoq.dt-trans),
                                                 int(SUBSTR(movto-estoq.hr-trans,1,2)),
                                                 int(SUBSTR(movto-estoq.hr-trans,4,2)),
                                                 int(SUBSTR(movto-estoq.hr-trans,7,2)) ) .
                IF d-data-entrada < it-critico-cq.dt-solic THEN
                   ASSIGN d-data-entrada = it-critico-cq.dt-solic.
                
            END.
               

            CREATE ItemCritico.
            ASSIGN resultado.Sucesso                 = YES
                   ItemCritico.CodigoProduto         = it-critico-cq.it-codigo
                   ItemCritico.NomeProduto           = substring(ITEM.desc-item, 1, 30)
                   ItemCritico.CodigoDeposito        = it-critico-cq.cod-depos-solic
                   ItemCritico.DataHoraSolicitacao   = IF AVAIL movto-estoq THEN fnConvDatetimeChar(d-data-entrada) ELSE fnConvDatetimeChar(it-critico-cq.dt-solic)
                   ItemCritico.EmAtendimento         = IF it-critico-cq.usuar-atend <> "" THEN "*" ELSE ""
                   ItemCritico.CodigoSolicitacaoItem = it-critico-cq.cod-solic
                   .
            
            FOR FIRST usuar_mestre FIELDS(nom_usuario)
                WHERE usuar_mestre.cod_usuario = it-critico-cq.solicitante NO-LOCK:
    
                ASSIGN ItemCritico.NomeSolicitante = ENTRY(1,SUBSTRING(usuar_mestre.nom_usuario,1,20)," ").
            END.
        END.
    END.

END.

/*
IF NOT resultado.Sucesso THEN DO:
   RUN pi-erro (INPUT "CEP n∆o cadastrato!").
   ASSIGN ItemCritico.CEP = msg0171.CEP.
END.
*/


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

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, TRUE, "UTF-8").

return.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.


