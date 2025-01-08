/********************************************************************************
 ** UPC........: win356.p - UPC WRITE prazo-compra
 ** Data.......: Novembro / 2022
 ** Objetivo...:
 ** Vers∆o.....: 16/11/2022 - Henke/iDBA - Integraá∆o com o ARIBA; 
 ********************************************************************************/

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR v-rw-es-api-log AS ROWID NO-UNDO.

DEF PARAM BUFFER b-prazo-compra      FOR prazo-compra.
DEF PARAM BUFFER b-old-prazo-compra  FOR prazo-compra.

DEF VAR v-num-seq-movto AS INT NO-UNDO.
DEF VAR de-preco-unit AS DEC NO-UNDO.
DEF VAR de-total      AS DEC NO-UNDO.
def var i-hora-aux      as int no-undo.

DEF VAR l-msg     AS l NO-UNDO.
DEF VAR i         AS i NO-UNDO.

{esp/esapi505b.i}  

/* Status Processamento Ariba
1 -	N∆o Integrado: status inicial de todos os registros criados
2 -	Em processamento: status que ir† aguardar o retorno do processamento Ariba, pois n∆o Ç s°ncrono
3 -	Em Revis∆o: status para todos os pedidos que forem alterados (sugest∆o Ç usar a trigger de ediá∆o)
4 -	Integrado: status de todos os pedidos integrados com sucesso, seja criaá∆o ou alteraá∆o
5 -	Registro Exclu°do: registros que ser∆o exclu°dos desta tabela pois n∆o ser∆o executados
6 -	Erro Integraá∆o: status do pedido cujo retorno do Ariba foi algum erro
7 -	Pedido Cancelado: quanto o pedido for eliminado/exclu°do no Totvs
*/

IF can-find(FIRST ordem-compra WHERE
                  ordem-compra.numero-ordem = b-prazo-compra.numero-ordem
              AND ordem-compra.situacao    <> 4
                  NO-LOCK)
AND (NOT NEW b-prazo-compra OR 
     v-rw-es-api-log = ?) THEN DO:
    IF b-prazo-compra.data-alter <> b-old-prazo-compra.data-alter
    OR b-prazo-compra.quantidade <> b-old-prazo-compra.quantidade THEN DO: 
        FIND FIRST ordem-compra OF b-prazo-compra NO-LOCK NO-ERROR.
        FIND FIRST pedido-compr OF ordem-compra NO-LOCK NO-ERROR.
        FIND FIRST int-ped-compr EXCLUSIVE-LOCK
             WHERE int-ped-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.
        IF AVAIL int-ped-compr THEN DO:
            assign i-hora-aux = 0.
            FIND LAST int-mov-ped-compr EXCLUSIVE-LOCK
                 WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                   AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
            IF AVAIL int-mov-ped-compr THEN
                ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10
                       i-hora-aux      = inte(int-mov-ped-compr.hra-movto)
                       no-error.
            ELSE
                ASSIGN v-num-seq-movto = 20.

            /* Evitar repetiá∆o */
            if  avail int-mov-ped-compr
            and i-hora-aux                      > 0
            and absolute(i-hora-aux - inte(replace(string(TIME,"HH:MM:SS"),":",""))) < 3
            and int-ped-compr.ind-status        = 3
            and int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
            and int-mov-ped-compr.dat-movto     = today
            and int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
            then.
            else do:
                 CREATE int-mov-ped-compr.
                 ASSIGN int-ped-compr.ind-status        = 3 // "Em Revis∆o"
                        int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                        int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                        int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                        int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
                        int-mov-ped-compr.dat-movto     = TODAY
                        int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                        int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                        int-mov-ped-compr.des-text-histor = "Pedido de Compras Alterado: " + STRING (pedido-compr.num-pedido).        
                 find current int-mov-ped-compr no-lock no-error.
                 release int-mov-ped-compr.
            end.

            /*
            MESSAGE "Prazo Seq: " int-mov-ped-compr.num-seq-movto SKIP
                    "Movto: " int-mov-ped-compr.ind-tip-movto VIEW-AS ALERT-BOX.*/

        END.
    END.
END.

RETURN "ok".
