/********************************************************************************************/
/* Programa...: esp/esb/in/MSG0088.p -                                                       */
/* Altor......: Anderson Cenci                                                              */
/* Data.......: 23/02/2015                                                                  */ 
/* Objetivo...: RECEBE ITEM E GRAVA PRE€O NA TABELA DE PRE€O                                */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.


{esp/esb/in/msg0088.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, MSG0088
   DATA-RELATION FOR conteudo, MSG0088 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0088R1, resultado
   DATA-RELATION FOR conteudor, MSG0088R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0088R1, resultado RELATION-FIELDS (idm, idm) NESTED.


CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0088R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0088 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE MSG0088R1.


RUN pi-atualizapreco.


IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).
OUTPUT CLOSE.
RETURN.

/* PROCEDURES */

PROCEDURE pi-atualizapreco:
   
    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST preco-item 
         WHERE preco-item.it-codigo = MSG0088.CodigoProduto
           AND preco-item.cod-refer = ""
           AND preco-item.nr-tabpre = "CRM2013" EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL preco-item THEN DO:
        CREATE preco-item.
        ASSIGN preco-item.it-codigo = MSG0088.CodigoProduto
               preco-item.cod-refer = ""
               preco-item.nr-tabpre = "CRM2013"
               preco-item.dt-inival = TODAY
               preco-item.quant-min = 0.
    END.

    ASSIGN preco-item.dt-useralt   = TODAY
           preco-item.preco-venda  = MSG0088.CustoPadrao
           preco-item.preco-fob    = MSG0088.CustoPadrao
           preco-item.quant-min    = 0
           preco-item.situacao     = 1
           preco-item.user-alter   = USERID("mgadm")
           preco-item.dt-useralt   = TODAY
           preco-item.cod-unid-med = "pc".

    FIND CURRENT preco-item NO-LOCK NO-ERROR.

    FIND FIRST int-preco-item EXCLUSIVE-LOCK
        WHERE  int-preco-item.it-codigo = preco-item.it-codigo
        AND    int-preco-item.cod-refer = preco-item.cod-refer
        AND    int-preco-item.nr-tabpre = preco-item.nr-tabpre
        AND    int-preco-item.dt-inival = preco-item.dt-inival
        AND    int-preco-item.quant-min = preco-item.quant-min NO-ERROR.
    IF  NOT AVAIL int-preco-item THEN DO:
        CREATE int-preco-item.
        ASSIGN int-preco-item.it-codigo = preco-item.it-codigo
               int-preco-item.cod-refer = preco-item.cod-refer
               int-preco-item.nr-tabpre = preco-item.nr-tabpre
               int-preco-item.dt-inival = preco-item.dt-inival
               int-preco-item.quant-min = preco-item.quant-min.
    END.

    ASSIGN int-preco-item.pma = preco-item.preco-venda
           int-preco-item.pmd = preco-item.preco-venda.

   
    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

