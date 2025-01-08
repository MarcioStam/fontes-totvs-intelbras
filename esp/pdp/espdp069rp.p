/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp069rp.p
**  Autor.....: Anderson Cenci
**  Data......: Outubro/2012
**  Descricao.: cancelamento Automatico de Pedidos
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp069 2.06.00.000}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE h-bodi159cal AS HANDLE      NO-UNDO.
DEFINE VARIABLE bo-ped-venda-can AS HANDLE      NO-UNDO.
DEFINE VARIABLE bo-ped-item-can AS HANDLE      NO-UNDO.
DEF BUFFER b-ped-venda FOR ped-venda.
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.
DEFINE VARIABLE c-situacao AS CHARACTER  FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-clientes AS CHARACTER   NO-UNDO.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "cancelamento Automatico de Pedidos"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP069"
       c-versao       = "2.06"
       c-revisao      = "000".

{esp/pdp/espdp069tt.i}

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN piImprimeRelat.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

PROCEDURE piImprimeRelat:


   IF tt-param.it-codigo <> "" THEN DO:
      PUT "Pedido;Cod.Cliente;Nome Cliente;Atendente;Prev.Fatur;Dt. Implantacao;Situacao Ped.;Item;Qt.Pedida" SKIP.
   END.
   ELSE
       PUT "Pedido;Cod.Cliente;Nome Cliente;Atendente;Prev.Fatur;Dt. Implantacao;Situacao Ped." SKIP.
   
   
   IF  CAN-FIND (FIRST tt-digita WHERE tt-digita.nr-pedido <> "") THEN DO:
       RUN pi-cancela-por-digitacao.
   END.
   ELSE
       RUN pi-cancela-por-selecao.

END.

PROCEDURE pi-cancela-por-selecao:

    FOR EACH ped-venda NO-LOCK
        WHERE  ped-venda.cod-estabel >= tt-param.cod-estabel-ini
          AND  ped-venda.cod-estabel <= tt-param.cod-estabel-fim
          AND  ped-venda.tp-pedido   >= tt-param.tp-pedido-ini
          AND  ped-venda.tp-pedido   <= tt-param.tp-pedido-fim
          AND  ped-venda.dt-entrega  >= tt-param.dt-entrega-ini
          AND  ped-venda.dt-entrega  <= tt-param.dt-entrega-fim
          AND  ped-venda.cod-sit-ped <> 3
          AND  ped-venda.cod-sit-ped <> 6
          AND  ped-venda.dt-implant  <= tt-param.dt-cancelamento,
        FIRST emitente NO-LOCK
           WHERE emitente.nome-abrev    = ped-venda.nome-abrev:
        
         /*NÆo cancela pedidos implantados pela extranet*/
         FIND FIRST int-emitente NO-LOCK
               WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

         RUN pi-acompanhar IN h-acomp (INPUT "Selecionando pedido: " + STRING(ped-venda.nr-pedido)).

         IF tt-param.cod-emitente <> 0 THEN
           IF tt-param.cod-emitente <> ped-venda.cod-emitente THEN NEXT.

             IF ped-venda.cod-sit-ped = 1 THEN
                ASSIGN c-situacao = "Aberto".
             ELSE
                 IF ped-venda.cod-sit-ped = 2 THEN 
                     ASSIGN c-situacao = "Atendido Parcial".
                 ELSE
                     IF ped-venda.cod-sit-ped = 3 THEN
                        ASSIGN c-situacao = "Atendido Total".
                     ELSE
                         IF ped-venda.cod-sit-ped = 4 THEN 
                             ASSIGN c-situacao = "Pendente".
                         ELSE
                             IF ped-venda.cod-sit-ped = 5 THEN
                                ASSIGN c-situacao = "Suspenso".
                             ELSE
                                 IF ped-venda.cod-sit-ped = 6 THEN 
                                     ASSIGN c-situacao = "cancelado".
                                 ELSE
                                     ASSIGN c-situacao = "".

       /* Chamado 41684 - se for participante de programa de canais podera somente cancelar item informando o motivo. */

         IF tt-param.it-codigo <> "" THEN DO:
             FOR EACH ped-item OF ped-venda NO-LOCK
                 WHERE ped-item.it-codigo = tt-param.it-codigo:
                  PUT ped-venda.nr-pedcli 
                         ";"
                         ped-venda.cod-emitente
                         ";"
                         emitente.nome-emit
                         ";"
                         ped-venda.tp-pedido
                         ";"
                         ped-venda.dt-entrega
                         ";"
                         ped-venda.dt-implant
                         ";"
                         c-situacao 
                         ";" ped-item.it-codigo 
                         ";" ped-item.qt-pedida SKIP.
             END.
         END.
         ELSE DO:
              IF AVAIL int-emitente
                   AND int-emitente.ind-participa-canais = 993520001
                   AND ped-venda.origem = 12 THEN NEXT.

             PUT ped-venda.nr-pedcli 
                 ";"
                 ped-venda.cod-emitente
                 ";"
                 emitente.nome-emit
                 ";"
                 ped-venda.tp-pedido
                 ";"
                 ped-venda.dt-entrega
                 ";"
                 ped-venda.dt-implant
                 ";"
                 c-situacao SKIP.
         END.

         IF tt-param.lista = 2 THEN DO:
             RUN cancela_pedido.
         END.
         ELSE IF tt-param.lista = 3 THEN DO:
             RUN cancela_item_pedido.
         END.
    END.
END.

PROCEDURE pi-cancela-por-digitacao:

    FOR EACH tt-digita BREAK BY tt-digita.nr-pedido:

        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = int(tt-digita.nr-pedido),
            EACH  ped-item OF ped-venda NO-LOCK
            WHERE ped-item.it-codigo = tt-digita.it-codigo,
            FIRST emitente NO-LOCK
            WHERE emitente.nome-abrev = ped-venda.nome-abrev:

            /*NÆo cancela pedidos implantados pela extranet*/
            FIND FIRST int-emitente NO-LOCK
                   WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
             
             /***********************************************/ 
             RUN pi-acompanhar IN h-acomp (INPUT "Selecionando pedido: " + STRING(ped-venda.nr-pedido)).
    
             IF ped-venda.cod-sit-ped = 1 THEN
                ASSIGN c-situacao = "Aberto".
             ELSE
                 IF ped-venda.cod-sit-ped = 2 THEN 
                     ASSIGN c-situacao = "Atendido Parcial".
                 ELSE
                     IF ped-venda.cod-sit-ped = 3 THEN
                        ASSIGN c-situacao = "Atendido Total".
                     ELSE
                         IF ped-venda.cod-sit-ped = 4 THEN 
                             ASSIGN c-situacao = "Pendente".
                         ELSE
                             IF ped-venda.cod-sit-ped = 5 THEN
                                ASSIGN c-situacao = "Suspenso".
                             ELSE
                                 IF ped-venda.cod-sit-ped = 6 THEN 
                                     ASSIGN c-situacao = "cancelado".
                                 ELSE
                                     ASSIGN c-situacao = "".
             
              PUT ped-venda.nr-pedcli 
                  ";"
                  ped-venda.cod-emitente
                  ";"
                  emitente.nome-emit
                  ";"
                  ped-venda.tp-pedido
                  ";"
                  ped-venda.dt-entrega
                  ";"
                  ped-venda.dt-implant
                  ";"
                  c-situacao 
                  ";" ped-item.it-codigo 
                  ";" ped-item.qt-pedida SKIP.
    
             
             RUN cancela_item_pedido.
    
             IF LAST-OF (tt-digita.nr-pedido) THEN
                 RUN pi-completa.
        END.
    END.
END.

PROCEDURE cancela_pedido:
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
    run dibo/bodi159can.p persistent set bo-ped-venda-can.
    FIND b-ped-venda
        WHERE rowid(b-ped-venda) = ROWID(ped-venda)
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-ped-venda THEN
        ASSIGN b-ped-venda.completo = YES.
    RELEASE b-ped-venda.

    run setUserLog in bo-ped-venda-can (input v_cod_usuar_corren ).      

    run validatecancelation in bo-ped-venda-can (input  ROWID(ped-venda),
                                                 output table RowErrors).
    
    if  not can-find(first RowErrors
                     where RowErrors.ErrorSubType = "Error":U) then do:

        ASSIGN c-mensagem = "cancelamento Automatico - " + CHR(13) + CHR(10) +  
                                                   tt-param.motivo + CHR(13) + CHR(10) +  
                                                   "Estabel." + 
                                                   tt-param.cod-estabel-ini  + "|><|" +
                                                   tt-param.cod-estabel-fim  + CHR(13) + CHR(10) +     
                                                   tt-param.tp-pedido-ini    + "|><|" +     
                                                   tt-param.tp-pedido-fim    + CHR(13) + CHR(10) +     
                                                   "cancelar at‚ : " + STRING(tt-param.dt-cancelamento) + CHR(13) + CHR(10) +     
                                                   "Somente Listar : cancelar" + CHR(13) + CHR(10) +   
                                                   "Cliente : " + IF tt-param.cod-emitente <> 0 THEN string(tt-param.cod-emitente) ELSE "Todos".

        run updatecancelation in bo-ped-venda-can(input rowid(ped-venda),
                                                  INPUT c-mensagem ,
                                                  input TODAY,
                                                  input 1).
           
       PUT  'cancelamento Automatico Efetuado para o Pedido  '  string(ped-venda.nr-pedcli)   SKIP.
    END.
    ELSE DO:
          PUT 'Erro ao tentar efetuar o cancelado Automatico para o Pedido Ikeda '  string(ped-venda.nr-pedcli) SKIP.
          FOR EACH RowErrors:
              PUT "Erro: "ErrorNumber " - " Errordescription SKIP.
          END.
      
        
    END.

    IF VALID-HANDLE(bo-ped-venda-can)  THEN DO:
      delete procedure bo-ped-venda-can.
      assign bo-ped-venda-can = ?.
    end.  
END PROCEDURE.

PROCEDURE cancela_Item_pedido:
    DEFINE VARIABLE l-cancelou-item  AS LOGICAL     NO-UNDO.
    ASSIGN l-cancelou-item = NO.

    IF CAN-FIND (FIRST tt-digita) THEN DO:
        RUN pi-executa-cancela (OUTPUT l-cancelou-item).    
    END.
    ELSE DO:
        FOR EACH ped-item OF ped-venda
            WHERE ped-item.it-codigo = tt-param.it-codigo NO-LOCK:
        
            RUN pi-executa-cancela (OUTPUT l-cancelou-item).
        END.

        IF  l-cancelou-item = YES THEN DO:
            RUN pi-completa.
    END.

    
    END.
END PROCEDURE.

PROCEDURE pi-executa-cancela:
    DEFINE OUTPUT PARAM l-cancelou AS LOG INITIAL NO.

    IF NOT VALID-HANDLE(bo-ped-item-can)                
    OR bo-ped-item-can:TYPE <> "PROCEDURE":U            
    OR bo-ped-item-can:FILE-NAME <> "dibo/bodi154can.p" THEN
        RUN dibo/bodi154can.p PERSISTENT SET bo-ped-item-can.

    
    RUN setUserLog in bo-ped-item-can (INPUT c-seg-usuario).

    RUN validatecancelation in bo-ped-item-can (INPUT rowid(ped-item),
                                                INPUT "cancelado Automaticamente por ESPDP069 " + tt-param.motivo,
                                                INPUT-OUTPUT TABLE RowErrors).

    IF  SESSION:SET-WAIT-STATE("") THEN.

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        DELETE PROCEDURE bo-ped-item-can.
        ASSIGN bo-ped-item-can = ?.
        FOR EACH RowErrors:
            PUT "Pedido - " ped-venda.nr-pedcli " Item - " ped-item.it-codigo " Erro: "  RowErrors.Errordescription FORMAT "x(200)" SKIP.
        END.
        UNDO, LEAVE.
    END.
    ELSE DO:
        ASSIGN l-cancelou = YES.
        IF  ped-item.ind-componen = 2 THEN
            RUN updatecancelationComposto IN bo-ped-item-can (INPUT  rowid(ped-item),
                                                              INPUT  "cancelado Automaticamente por ESPDP069 " + tt-param.motivo,
                                                              INPUT  TODAY,
                                                              INPUT  1).
        ELSE
            RUN updatecancelation IN bo-ped-item-can (INPUT  rowid(ped-item),
                                                      INPUT "cancelado Automaticamente por ESPDP069 " + tt-param.motivo,
                                                      INPUT  TODAY,
                                                      INPUT  1).

        PUT  "Item cancelado "  ped-venda.nr-pedcli " Item - " ped-item.it-codigo SKIP.
    END.

    DELETE PROCEDURE bo-ped-item-can.
    ASSIGN bo-ped-item-can = ?.

END PROCEDURE.

PROCEDURE pi-completa:
    IF  NOT VALID-HANDLE(h-bodi159cal) THEN
        RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.

    FIND FIRST b-ped-venda EXCLUSIVE-LOCK 
         WHERE b-ped-venda.nome-abrev = ped-venda.nome-abrev
           AND b-ped-venda.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.

    IF AVAIL b-ped-venda THEN DO:
         ASSIGN b-ped-venda.completo = NO.
        run completeOrder in h-bodi159cal (INPUT ROWID(ped-venda),
                                           OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors
                     WHERE RowErrors.ErrorType   <> "INTERNAL":U
                       AND RowErrors.ErrorSubType = "Error") THEN DO:

            FOR EACH RowErrors:
                PUT 'Erro Completa Pedido ' + ped-venda.nr-pedcli + ' - ' + RowErrors.errordescription FORMAT "x(200)" SKIP.
            END. /* FOR EACH RowErrors: */
        END.

        EMPTY TEMP-TABLE RowErrors.
    END. /* IF AVAIL ped-venda THEN DO: */

    FIND CURRENT b-ped-venda NO-LOCK NO-ERROR.
    RELEASE b-ped-venda.
    IF  VALID-HANDLE(h-bodi159cal) THEN
        DELETE PROCEDURE h-bodi159cal.

    ASSIGN h-bodi159cal = ?.
END PROCEDURE.
