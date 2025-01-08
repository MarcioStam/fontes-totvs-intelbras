CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{cdp/cd0666.i}
{utp/ut-glob.i}
{esp/esb/in/msg0095.i}

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0095
   DATA-RELATION FOR conteudo, msg0095 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0095r, resultado, nota-fiscal-itens, nota-fiscal-item
   DATA-RELATION FOR conteudor, msg0095r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0095r, nota-fiscal-itens RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR nota-fiscal-itens, nota-fiscal-item RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0095r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0095.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor to cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0095R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE msg0095r.
CREATE nota-fiscal-itens.

DEF BUFFER b-nota-dev      FOR nota-fiscal.
DEF BUFFER b-nota-dev-item FOR it-nota-fisc.

log-manager:write-message("msg0095.NumeroPedido marcios -> "  + STRING(msg0095.NumeroPedido)).

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nr-pedido = int(msg0095.NumeroPedido):
    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
          AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli:

        FIND FIRST int-nota-fiscal NO-LOCK
             WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               AND int-nota-fiscal.serie       = nota-fiscal.serie
               AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR. 

        log-manager:write-message("avail int-nota-fiscal marcios -> "  + string(AVAIL int-nota-fiscal)).
        log-manager:write-message("data entrega marcios -> "  + SUBSTRING(int-nota-fiscal.char-1,50,10)).
       
        CREATE nota-fiscal-item.
        ASSIGN nota-fiscal-item.NumeroNotaFiscal             = string(nota-fiscal.nr-nota-fis) + "/" +  string(nota-fiscal.serie) + "/" + STRING(nota-fiscal.cod-estabel)
               nota-fiscal-item.NumeroSerie                  = nota-fiscal.serie
               nota-fiscal-item.Descricao                    = ?
               nota-fiscal-item.SituacaoNota                 = IF nota-fiscal.dt-cancel <> ? THEN 3 ELSE 0  
               nota-fiscal-item.SituacaoEntrega              = 1
               nota-fiscal-item.DataEmissao                  = nota-fiscal.dt-emis-nota
               nota-fiscal-item.DataPrevisaoEntrega          = IF AVAIL int-nota-fiscal THEN date(SUBSTRING(int-nota-fiscal.char-1,50,10)) ELSE ?
               nota-fiscal-item.ValorFrete                   = nota-fiscal.vl-frete
               nota-fiscal-item.Volume                       = STRING(nota-fiscal.nr-volume)
               nota-fiscal-item.ValorDesconto                = nota-fiscal.vl-desconto
               nota-fiscal-item.PercentualDesconto           = 0
               nota-fiscal-item.ValorTotal                   = ROUND(nota-fiscal.vl-tot-nota,4)
               nota-fiscal-item.ValorTotalSemImposto         = ROUND(nota-fiscal.vl-mercad,4)
               nota-fiscal-item.ValorTotalSemFrete           = ROUND(nota-fiscal.vl-tot-nota - nota-fiscal.vl-frete,4)
               nota-fiscal-item.ValorTotalDesconto           = nota-fiscal.vl-desconto 
               nota-fiscal-item.ValorTotalProdutos           = ROUND(nota-fiscal.vl-tot-nota,4) 
               nota-fiscal-item.ValorTotalProdutosSemImposto = ROUND(nota-fiscal.vl-mercad,4)
               nota-fiscal-item.NotaDevolucao                = (IF  nota-fiscal.esp-docto = 20 THEN YES ELSE NO).
               

        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
            ASSIGN nota-fiscal-item.ValorBaseICMS                   = ROUND(nota-fiscal-item.ValorBaseICMS                   + it-nota-fisc.vl-bicms-it,4) 
                   nota-fiscal-item.ValorICMS                       = ROUND(nota-fiscal-item.ValorICMS                       + it-nota-fisc.vl-icms-it,4)  
                   nota-fiscal-item.ValorIPI                        = ROUND(nota-fiscal-item.ValorIPI                        + it-nota-fisc.vl-ipi-it,4)   
                   nota-fiscal-item.ValorBaseSubstituicaoTributaria = ROUND(nota-fiscal-item.ValorBaseSubstituicaoTributaria + it-nota-fisc.vl-bsubs-it,4) 
                   nota-fiscal-item.ValorSubstituicaoTributaria     = ROUND(nota-fiscal-item.ValorSubstituicaoTributaria     + it-nota-fisc.vl-icmsub-it,4)
                   nota-fiscal-item.ValorTotalImpostos              = ROUND(nota-fiscal-item.ValorTotalImpostos              + it-nota-fisc.vl-ipi-it + it-nota-fisc.vl-icmsub-it,4).
        END.

        log-manager:write-message("nota-fiscal-item.dataprevisaoentrega marcios -> "  + STRING(nota-fiscal-item.DataPrevisaoEntrega)).

        RUN pi-carrega-devolucoes.

    END.
END.


DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

OUTPUT CLOSE.

RETURN.


PROCEDURE pi-carrega-devolucoes:

    FOR EACH devol-cli NO-LOCK
        WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
          AND devol-cli.serie       = nota-fiscal.serie      
          AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis
        , EACH b-nota-dev no-lock
             WHERE b-nota-dev.cod-estabel = devol-cli.cod-estabel 
               AND b-nota-dev.serie       = devol-cli.serie-docto 
               AND b-nota-dev.nr-nota-fis = devol-cli.nro-docto
               AND b-nota-dev.esp-docto   = 20

               BREAK BY b-nota-dev.cod-estabel
                     BY b-nota-dev.serie      
                     BY b-nota-dev.nr-nota-fis:

        IF  FIRST-OF(b-nota-dev.nr-nota-fis) THEN DO:
            CREATE nota-fiscal-item.
            ASSIGN nota-fiscal-item.NumeroNotaFiscal             = string(devol-cli.nro-docto) + "/" +  string(devol-cli.serie-docto) + "/" + STRING(b-nota-dev.cod-estabel)
                   nota-fiscal-item.NumeroSerie                  = b-nota-dev.serie
                   nota-fiscal-item.Descricao                    = ?
                   nota-fiscal-item.SituacaoNota                 = IF b-nota-dev.dt-cancel <> ? THEN 3 ELSE 0  
                   nota-fiscal-item.SituacaoEntrega              = 1
                   nota-fiscal-item.DataEmissao                  = b-nota-dev.dt-emis-nota
                   nota-fiscal-item.ValorFrete                   = b-nota-dev.vl-frete
                   nota-fiscal-item.Volume                       = IF STRING(b-nota-dev.nr-volume) = "" THEN "Sem Inform" ELSE STRING(b-nota-dev.nr-volume)
                   nota-fiscal-item.ValorDesconto                = b-nota-dev.vl-desconto
                   nota-fiscal-item.PercentualDesconto           = 0
                   nota-fiscal-item.ValorTotal                   = ROUND(b-nota-dev.vl-tot-nota,4)
                   nota-fiscal-item.ValorTotalSemImposto         = ROUND(b-nota-dev.vl-mercad,4)
                   nota-fiscal-item.ValorTotalSemFrete           = ROUND(b-nota-dev.vl-tot-nota - b-nota-dev.vl-frete,4)
                   nota-fiscal-item.ValorTotalDesconto           = b-nota-dev.vl-desconto 
                   nota-fiscal-item.ValorTotalProdutos           = ROUND(b-nota-dev.vl-tot-nota,4) 
                   nota-fiscal-item.ValorTotalProdutosSemImposto = ROUND(b-nota-dev.vl-mercad,4)
                   nota-fiscal-item.NotaDevolucao                = (IF b-nota-dev.esp-docto = 20 THEN YES ELSE NO).    

            FOR EACH b-nota-dev-item OF b-nota-dev NO-LOCK:

                log-manager:WRITE-MESSAGE("b-nota-dev-item.vl-bicms-it,4) : " + string(b-nota-dev-item.vl-bicms-it)) .
                ASSIGN nota-fiscal-item.ValorBaseICMS                   = ROUND(nota-fiscal-item.ValorBaseICMS                   + b-nota-dev-item.vl-bicms-it,4) 
                       nota-fiscal-item.ValorICMS                       = ROUND(nota-fiscal-item.ValorICMS                       + b-nota-dev-item.vl-icms-it,4)  
                       nota-fiscal-item.ValorIPI                        = ROUND(nota-fiscal-item.ValorIPI                        + b-nota-dev-item.vl-ipi-it,4)   
                       nota-fiscal-item.ValorBaseSubstituicaoTributaria = ROUND(nota-fiscal-item.ValorBaseSubstituicaoTributaria + b-nota-dev-item.vl-bsubs-it,4) 
                       nota-fiscal-item.ValorSubstituicaoTributaria     = ROUND(nota-fiscal-item.ValorSubstituicaoTributaria     + b-nota-dev-item.vl-icmsub-it,4)
                       nota-fiscal-item.ValorTotalImpostos              = ROUND(nota-fiscal-item.ValorTotalImpostos              + b-nota-dev-item.vl-ipi-it + b-nota-dev-item.vl-icmsub-it,4).
            END.

           log-manager:write-message(" nota-fiscal-item.NumeroNotaFiscal                : " + string(nota-fiscal-item.NumeroNotaFiscal                ) ).
           log-manager:write-message(" nota-fiscal-item.NumeroSerie                     : " + string(nota-fiscal-item.NumeroSerie                     ) ).
           log-manager:write-message(" nota-fiscal-item.Descricao                       : " + string(nota-fiscal-item.Descricao                       ) ).
           log-manager:write-message(" nota-fiscal-item.SituacaoNota                    : " + string(nota-fiscal-item.SituacaoNota                    ) ).
           log-manager:write-message(" nota-fiscal-item.SituacaoEntrega                 : " + string(nota-fiscal-item.SituacaoEntrega                 ) ).
           log-manager:write-message(" nota-fiscal-item.DataEmissao                     : " + string(nota-fiscal-item.DataEmissao                     ) ).
           log-manager:write-message(" nota-fiscal-item.ValorFrete                      : " + string(nota-fiscal-item.ValorFrete                      ) ).
           log-manager:write-message(" nota-fiscal-item.Volume                          : " + string(nota-fiscal-item.Volume                          ) ).
           log-manager:write-message(" nota-fiscal-item.ValorDesconto                   : " + string(nota-fiscal-item.ValorDesconto                   ) ).
           log-manager:write-message(" nota-fiscal-item.PercentualDesconto              : " + string(nota-fiscal-item.PercentualDesconto              ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotal                      : " + string(nota-fiscal-item.ValorTotal                      ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalSemImposto            : " + string(nota-fiscal-item.ValorTotalSemImposto            ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalSemFrete              : " + string(nota-fiscal-item.ValorTotalSemFrete              ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalDesconto              : " + string(nota-fiscal-item.ValorTotalDesconto              ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalProdutos              : " + string(nota-fiscal-item.ValorTotalProdutos              ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalProdutosSemImpost     : " + string(nota-fiscal-item.ValorTotalProdutosSemImpost     ) ).
           log-manager:write-message(" nota-fiscal-item.NotaDevolucao                   : " + string(nota-fiscal-item.NotaDevolucao                   ) ).
           log-manager:write-message(" nota-fiscal-item.ValorBaseICMS                   : " + string(nota-fiscal-item.ValorBaseICMS                   ) ).
           log-manager:write-message(" nota-fiscal-item.ValorICMS                       : " + string(nota-fiscal-item.ValorICMS                       ) ).
           log-manager:write-message(" nota-fiscal-item.ValorIPI                        : " + string(nota-fiscal-item.ValorIPI                        ) ).
           log-manager:write-message(" nota-fiscal-item.ValorBaseSubstituicaoTributaria : " + string(nota-fiscal-item.ValorBaseSubstituicaoTributaria ) ).
           log-manager:write-message(" nota-fiscal-item.ValorSubstituicaoTributaria     : " + string(nota-fiscal-item.ValorSubstituicaoTributaria     ) ).
           log-manager:write-message(" nota-fiscal-item.ValorTotalImpostos              : " + string(nota-fiscal-item.ValorTotalImpostos              ) ).

        END.
    END.

END.
