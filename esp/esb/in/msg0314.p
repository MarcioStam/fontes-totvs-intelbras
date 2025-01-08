CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{cdp/cd0666.i}
{utp/ut-glob.i}
{esp/esb/in/msg0314.i}

DEF VAR da-alt-sit  AS DATE NO-UNDO.
DEF VAR i-dia       AS INT NO-UNDO.
DEF VAR i-mes       AS INT NO-UNDO.
DEF VAR i-ano       AS INT NO-UNDO.

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0314
   DATA-RELATION FOR conteudo, msg0314 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0314r, resultado
   DATA-RELATION FOR conteudor, msg0314r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0314r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0314.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0314R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE msg0314r.

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

    FIND FIRST ped-venda
        WHERE ped-venda.nr-pedido = INT(msg0314.NumeroPedido) EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL ped-venda THEN DO:
        RUN pi-erro (INPUT "NÆo encontrado o pedido " + STRING(msg0314.NumeroPedido) + " !").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        UNDO blk_principal, LEAVE blk_principal.

    ASSIGN i-dia = int(SUBSTR(msg0314.DataAlteracaoSituacao,9,2))
           i-mes = int(SUBSTR(msg0314.DataAlteracaoSituacao,6,2))
           i-ano = int(SUBSTR(msg0314.DataAlteracaoSituacao,1,4)).
    
    ASSIGN da-alt-sit = date(i-mes,i-dia,i-ano).

    IF  msg0314.NomeSituacao = "Aprovado" THEN DO:

        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
    
        ASSIGN ped-venda.cod-sit-aval = 3
               ped-venda.dt-apr-cred  = da-alt-sit
               ped-venda.quem-aprovou = c-seg-usuario
               ped-venda.desc-bloq-cr = IF  AVAIL int-ped-venda2 THEN "Saldo Aprovado: " + string(int-ped-venda2.dec-1) ELSE ""
               ped-venda.dsp-pre-fat  = YES.
    END.

    IF  msg0314.NomeSituacao = "Bloqueado - Sistema" 
    OR  msg0314.NomeSituacao = "Bloqueado - Analista" THEN DO:
        ASSIGN ped-venda.cod-sit-aval = 4
               ped-venda.dt-apr-cred  = ?
               ped-venda.quem-aprovou = ""
               ped-venda.desc-bloq-cr = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + msg0314.CodigoMotivo.
    END.
END.

IF  CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    
    FOR EACH tt-erro:
        IF  tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".

        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
