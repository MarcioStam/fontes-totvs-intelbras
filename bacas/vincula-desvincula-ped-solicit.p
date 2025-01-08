/*PRODUÄ«O*/

DEF VAR i-cliente AS INTEGER NO-UNDO.
DEF VAR c-pedido  AS CHAR FORMAT "X(20)" NO-UNDO.
DEF VAR c-acao    AS CHAR NO-UNDO.
DEF VAR c-resultado AS CHAR FORMAT "X(30)" NO-UNDO.

UPDATE i-cliente LABEL "Cliente"
       c-pedido  LABEL "Pedido"
       c-acao    LABEL "D - Desvincular; V - Vincular".
    
IF   c-acao <> "D"
AND  c-acao <> "V" THEN  DO:
    MESSAGE "Deve ser informado D, para desvincular o pedido da solicitao, ou V para Vincul†-l.o"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.


FIND FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = i-cliente NO-ERROR.

IF  NOT AVAIL emitente THEN DO:
    MESSAGE "Emitente inexistente"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.


DO TRANS:

    FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
        WHERE int-solicitacao-item.nr-pedcli  = c-pedido
          AND int-solicitacao-item.nome-abrev = IF c-acao = "V" THEN "" ELSE emitente.nome-abrev
         ,FIRST int-solicitacao NO-LOCK
              WHERE int-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio
                AND int-solicitacao.cod-emitente = i-cliente
         BREAK BY int-solicitacao-item.nome-abrev
               BY int-solicitacao-item.nr-pedcli:
    
               FIND FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nome-abrev  = emitente.nome-abrev
                      AND ped-venda.nr-pedcli   = int-solicitacao-item.nr-pedcli
                      NO-ERROR.
    
                IF  ped-venda.cod-sit-ped > 2
                AND c-acao = "D" THEN DO:
                    MESSAGE "Pedido n∆o est† aberto " ped-venda.cod-sit-ped
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN .
                END.

                IF  c-acao = "D" THEN
                    ASSIGN int-solicitacao-item.nome-abrev = ""
                           c-resultado = "Desvinculado".
                ELSE
                    ASSIGN int-solicitacao-item.nome-abrev = emitente.nome-abrev
                           c-resultado = "Vinculado".

                DISP "Antes..: " emitente.nome-abrev
                     "Depois.: " int-solicitacao-item.nome-abrev 
                        WITH WIDTH 300 FRAME F2 DOWN.
    
    
    END.

    IF  c-resultado = "" THEN DO:
        MESSAGE  "N∆o foi poss°vel encontrar a solicitaá∆o para o pedido informado."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE IF  c-resultado = "Desvinculado" THEN DO:
          MESSAGE  "Pedido foi Desvinculado da solicitacao."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
         END.
         ELSE 
             MESSAGE  "Pedido foi Vinculado novamente Ö solicitacao."
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
END.

