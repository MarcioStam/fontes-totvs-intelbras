/*****************************************************************************
**
**   Programa: es0429.p
**
**   Funcao: Checar validade dos manuais e envia e-mail para documentacao
**           checar validade de outras familias e envia e-mail para almox.
**   Data: 01/06/2000
**
**   Autor: Flavio Schoenell - INTELBRAS S/A.
**   EXECUCAO SEMANAL
******************************************************************************/
{esp/enp/esenp023.i}

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

{esp/es0018.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
/*{include/i-rpvar.i}*/
{upc/btb910za-upc.i}
{esp/eslib.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def var h-acomp      as handle no-undo.
define variable c-remetente as character no-undo.
define variable c-destino   as character no-undo.
define variable c-assunto   as character no-undo.
define variable c-descemail as character no-undo.
define variable c-arquivo   as character no-undo.

DEF TEMP-TABLE tt-oper-ord
    FIELD op-codigo LIKE oper-ord.op-codigo
    FIELD descricao LIKE oper-ord.descricao
    INDEX op op-codigo.

DEF TEMP-TABLE tt-operacao
    FIELD op-codigo LIKE oper-ord.op-codigo
    FIELD descricao LIKE oper-ord.descricao
    FIELD data-inicio LIKE operacao.data-inicio
    FIELD data-termino LIKE operacao.data-termino
    INDEX op op-codigo.

DEF VAR comp AS CHAR NO-UNDO.
DEF VAR l-diverg AS LOGICAL INITIAL NO NO-UNDO.


create tt-param.
raw-transfer raw-param to tt-param.

DEF STREAM s-ordens.

assign c-arquivo = c-dir-arquivo-session + "Ordens-" + string(TIME) + ".csv".
output stream s-ordens to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.

PUT STREAM s-ordens "OP;Data;ITEM;STATUS;Operacao;Descricao;Inicio;Termino" SKIP.
    
FOR EACH ord-prod WHERE ord-prod.dt-emissao = TODAY and
                        ord-prod.tipo = 1 NO-LOCK:

    IF ord-prod.nr-linha = 20 OR
       ord-prod.nr-linha = 15 THEN NEXT.

    IF ord-prod.it-codigo = "" THEN NEXT.
    
    FOR EACH tt-oper-ord:
        DELETE tt-oper-ord.
    END.

    FOR EACH tt-operacao:
        DELETE tt-operacao.
    END.
    
    FOR EACH oper-ord WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:
        CREATE tt-oper-ord.
        ASSIGN tt-oper-ord.op-codigo = oper-ord.op-codigo
               tt-oper-ord.descricao = oper-ord.descricao.
        
    END.
    
    RUN pi-operacao (INPUT ord-prod.it-codigo).
    run pi-est(input ord-prod.it-codigo).

    FOR EACH tt-operacao NO-LOCK:
        FIND FIRST tt-oper-ord 
             WHERE tt-oper-ord.op-codigo = tt-operacao.op-codigo AND
                   tt-oper-ord.descricao = tt-operacao.descricao NO-LOCK NO-ERROR.
        IF AVAIL tt-oper-ord THEN NEXT.
        ELSE DO:
            PUT STREAM s-ordens
                ord-prod.nr-ord-produ ";"
                ord-prod.dt-emissao   ";"
                ord-prod.it-codigo    ";"
                "Opera‡Æo da OP diferente cadastro" ";"
                tt-operacao.op-codigo ";"
                tt-operacao.descricao ";"
                tt-operacao.data-inicio ";"
                tt-operacao.data-termino SKIP.
            ASSIGN l-diverg = YES.
                
        END.
    END.
    FOR EACH tt-oper-ord NO-LOCK:
        FIND FIRST tt-operacao 
             WHERE tt-operacao.op-codigo = tt-oper-ord.op-codigo AND
                   tt-operacao.descricao = tt-oper-ord.descricao NO-LOCK NO-ERROR.
        IF AVAIL tt-operacao THEN NEXT.
        ELSE DO:
            PUT STREAM s-ordens
                ord-prod.nr-ord-produ ";"
                ord-prod.dt-emissao   ";"
                ord-prod.it-codigo    ";"
                "Cadastro diferente da Opera‡Æo OP" ";"
                tt-oper-ord.op-codigo ";"
                tt-oper-ord.descricao SKIP.
            ASSIGN l-diverg = YES.
                
        END.
    END.
END.

OUTPUT STREAM s-ordens close.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "esenp023":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    /* envio de e-mail */
    assign c-remetente = "ems@intelbras.com.br"
           c-destino   = tt-prog-ponto.conteudo
           c-assunto   = "Divergencia Ordens"
           c-descemail = "Divergencia com operacoes" + chr(10) + chr(13).

    /* envio de e-mail */
    IF l-diverg THEN DO:
        RUN enviaMail (INPUT c-remetente,
                       INPUT c-destino,
                       INPUT c-assunto,
                       INPUT c-descemail,
                       INPUT c-arquivo).
    END.
END. 


PROCEDURE pi-operacao:
    DEF INPUT PARAMETER p-it-codigo like item.it-codigo NO-UNDO.

    FOR EACH operacao 
        WHERE operacao.it-codigo = p-it-codigo AND
              operacao.data-inicio <= TODAY AND
              operacao.data-termino > TODAY NO-LOCK:

        CREATE tt-operacao.
        ASSIGN tt-operacao.op-codigo    = operacao.op-codigo
               tt-operacao.descricao    = operacao.descricao
               tt-operacao.data-inicio  = operacao.data-inicio
               tt-operacao.data-termino = operacao.data-termino.

    END.
END PROCEDURE.


PROCEDURE pi-est:
    def input parameter p-it-codigo like item.it-codigo NO-UNDO.
    
    FOR EACH estrutura NO-LOCK 
        WHERE estrutura.it-codigo = p-it-codigo AND
              estrutura.data-inicio <= TODAY AND
              estrutura.data-termino > today:
       
        IF estrutura.fantasma = YES THEN DO:
            RUN pi-operacao (INPUT estrutura.es-codigo).
            run pi-est(input estrutura.es-codigo).
        END.
        
    END.
END PROCEDURE.





RETURN "ok".

