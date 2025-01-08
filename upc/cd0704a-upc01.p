/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upc.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: Gravacao dos dados adicionais do cliente.
               Grava: emitente.bonificacao
                      emitente.cod-suframa
               Com esta UPC, nao e necessario acessar os programas CD0705 e
               CD1510 apos o cadastro do cliente para que o mesmo possa ter
               notas faturadas.
               Utilizei o ponto UPC "criacao-Endereco-Padrao-Entrega" para 
               gravar o indicador de credito do cliente. Este evento so e
               chamado depois que o registro foi cridao (e so na criacao de 
               novo registro).
---------------------------------------------------------------------------- */

{include/i-epc200.i cd0704a}

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF VAR i-emitente          AS INTEGER NO-UNDO.
DEF VAR c-nome-abrev-antigo AS CHAR NO-UNDO.
DEF VAR c-nome-abrev-novo   AS CHAR NO-UNDO.

IF  p-ind-event = "alteraNomeAbrev" THEN DO:

    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "alteraNomeAbrev":

        IF  tt-epc.cod-parameter = "cod-emitente" THEN
            ASSIGN i-emitente = int(tt-epc.val-parameter).

        IF  tt-epc.cod-parameter = "nomevelho" THEN
            ASSIGN c-nome-abrev-antigo = tt-epc.val-parameter.

        IF  tt-epc.cod-parameter = "nomenovo" THEN
            ASSIGN c-nome-abrev-novo = tt-epc.val-parameter.
        
    END.
    
    IF  c-nome-abrev-antigo <> c-nome-abrev-novo
    AND c-nome-abrev-antigo <> ""
    AND c-nome-abrev-novo   <> ""   THEN 
        RUN pi-altera-tabelas.
    
END.

PROCEDURE pi-altera-tabelas:

    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR  UNDO bloco, LEAVE bloco:

        FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
            WHERE int-solicitacao-item.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-solicitacao-item.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH int-ped-aloc-supcard EXCLUSIVE-LOCK
            WHERE int-ped-aloc-supcard.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-ped-aloc-supcard.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH int-ped-item EXCLUSIVE-LOCK
            WHERE int-ped-item.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-ped-item.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH int-ped-item-pai EXCLUSIVE-LOCK
            WHERE int-ped-item-pai.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-ped-item-pai.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH int-ped-item-astec EXCLUSIVE-LOCK
            WHERE int-ped-item-astec.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-ped-item-astec.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH int-ped-item-rebate EXCLUSIVE-LOCK
            WHERE int-ped-item-rebate.nome-abrev = c-nome-abrev-antigo:
            ASSIGN int-ped-item-rebate.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH ped-item-segmentos EXCLUSIVE-LOCK
            WHERE ped-item-segmentos.nome-abrev = c-nome-abrev-antigo:
            ASSIGN ped-item-segmentos.nome-abrev = c-nome-abrev-novo.
        END.

        FOR EACH fabricante EXCLUSIVE-LOCK
            WHERE fabricante.nome-abrev = c-nome-abrev-antigo:
            ASSIGN fabricante.nome-abrev = c-nome-abrev-novo.
        END.            

        FOR EACH historico-credito EXCLUSIVE-LOCK
            WHERE historico-credito.nome-abrev    = c-nome-abrev-antigo:
            ASSIGN historico-credito.nome-abrev = c-nome-abrev-novo.
        END.            

    END.
END.


RETURN "OK".
