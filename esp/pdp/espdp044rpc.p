/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpc.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Status Pedidos - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.
/*---------------------------  Variaveis    ---------------------------*/
{utp/ut-glob.i}
{utp/utapi019.i}
define variable hWebService   as handle   no-undo.
DEF VAR bo-ped-venda-can AS HANDLE NO-UNDO.

{esp/pdp/espdp044tt.i}
{esp/pdp/espdp044rpc-tt.i}
{esp/pdp/espdp044sh.i "shared"}
    define temp-table RowErrors no-undo
       field ErrorSequence    as integer
       field ErrorNumber      as integer
       field ErrorDescription as character format "x(150)"
       field ErrorParameters  as character
       field ErrorType        as character
       field ErrorHelp        as character format "x(150)"
       field ErrorSubtype     as character.

/*---------------------------  Parƒmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.

create tt-param-rpc.
raw-transfer raw-param to tt-param-rpc.
/* ***************************  Main Block  *************************** */
do on stop undo, return error "NOK":
   define variable iStatus       as integer     no-undo.
   define variable cStatus       as character   no-undo.
   DEFINE VARIABLE c-licenca-softphone AS CHARACTER  FORMAT "x(2000)" NO-UNDO.

   define variable lAtendidoTotal   as logical     no-undo.
   define variable lCancelado       as logical     no-undo.
   define variable lCancelado2     as logical     no-undo.
   define variable lAberto          as logical     no-undo.
   define variable lNaoAprovado     as logical     no-undo.
   define variable cSedex           as character   no-undo.
   define variable c-serie          as character   no-undo.
   define variable c-nr-nota-fis    as character   no-undo.
   DEFINE VARIABLE c-cod-estabel    AS CHARACTER   NO-UNDO. /* Licen‡a Softphone - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Junho de 2012 */
   DEFINE VARIABLE i-quant-licenca  AS INTEGER     NO-UNDO. /* Licen‡a Softphone - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Junho de 2012 */
   DEFINE VARIABLE da-quinto-dia-util AS DATE        NO-UNDO.

   run pi-acompanhar in h-acomp ('Atualizando status dos pedidos').
  /** Execu‡Æo do WS para atualizar inforam‡äes na Ikeda **/
  run esp/pdp/espdp044rpb-ws.p persistent set hWebService.
  run conecta in hWebService (output iStatus, output cStatus).

   FOR EACH ped-venda
           WHERE (ped-venda.tp-pedido = "37" OR ped-venda.tp-pedido = "38" OR ped-venda.tp-pedido = "39" OR
                  ped-venda.tp-pedido = "80" OR ped-venda.tp-pedido = "18")
             AND (ped-venda.cod-priori = 01 OR ped-venda.cod-priori = 88)
             AND  ped-venda.cod-cond-pag = 75
             AND  (ped-venda.cod-sit-aval = 4 OR ped-venda.cod-sit-aval = 1)
             AND ped-venda.cod-sit-ped = 1
             AND ped-venda.dt-implant >= TODAY - 10
             /*TODAY - ped-venda.dt-implant  > 2*/ NO-LOCK:

       da-quinto-dia-util = ?.
       RUN pi-retorna-quinto-dia-util (INPUT ped-venda.dt-implant,
                                       OUTPUT da-quinto-dia-util).

       IF TODAY < da-quinto-dia-util THEN
           NEXT.

       FIND int-ped-venda
           WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
             AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
           EXCLUSIVE-LOCK NO-ERROR.
            /** Cancelado Automatico = 115 **/
       IF AVAIL int-ped-venda THEN DO:

            RUN pi-cancelaPedido.
            ASSIGN int-ped-venda.atualizaIkeda = NO.
        END.
        RELEASE int-ped-venda.
    END.


   /** Escolhe pedidos a atualizar **/
   if (tt-param-rpc.Unico) and (tt-param-rpc.CodigoPedido > 0) then do:
      create ttPedido.
      assign ttPedido.PedidoCodigo = tt-param-rpc.CodigoPedido.
   end.
   else do:
      for each int-ped-venda no-lock
         where int-ped-venda.atualizaIkeda
           and int-ped-venda.PedidoCodigo > 0
           and not can-find (first ttPedido
                             where ttPedido.PedidoCodigo = int-ped-venda.PedidoCodigo):
         create ttPedido.
         assign ttPedido.PedidoCodigo = int-ped-venda.PedidoCodigo.
      end.
   end.

   if can-find (first ttPedido) then do:

      if (iStatus <> 1) then
         run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda: ' + cStatus).
      else do:
          for each ttPedido:
             run pi-acompanhar in h-acomp ('Atualizando status do pedido ' + string(ttPedido.PedidoCodigo)).


             assign lAtendidoTotal = no
                    lCancelado     = no
                    lCancelado2   = no
                    lAberto        = no
                    lNaoAprovado   = no
                    cSedex         = ''
                    c-serie        = '0'
                    c-nr-nota-fis  = '0'.

             for each int-ped-venda no-lock
                where int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo,
                each ped-venda no-lock
                   where ped-venda.nr-pedido = int-ped-venda.nr-pedido:

                /** Cancelado **/
                if /*(ped-venda.cod-sit-ped = 4) or (ped-venda.cod-sit-ped = 5) OR*/ (ped-venda.cod-sit-ped = 6) THEN DO:
                    IF ped-venda.desc-cancela MATCHES("*Cancelamento Automatico - Pedido sem pagamento (Boleto) em atraso mais que 2 dias*")  THEN 
                        assign lCancelado2 = yes. 
                    ELSE
                        assign lCancelado = yes.
                END.
                   
                /** Atendido Total **/
                else if (ped-venda.cod-sit-ped = 3) then do:
                   assign lAtendidoTotal = yes.
                   if (int-ped-venda.Sedex <> '') then
                      assign cSedex = cSedex + (if cSedex = '' then '' else ', ') + int-ped-venda.Sedex.
                end.
                /** Aberto ou Atendido Parcial **/
                else do:
                   assign lAberto = yes.
                   if (int-ped-venda.Sedex <> '') then
                      assign cSedex = cSedex + (if cSedex = '' then '' else ', ') + int-ped-venda.Sedex.
                   if (ped-venda.cod-sit-aval <> 3) then
                      assign lNaoAprovado = yes.
                end.
                FOR EACH nota-fiscal
                    WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
                      AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli
                      AND nota-fiscal.dt-cancel   = ? NO-LOCK:
                    ASSIGN c-serie       = nota-fiscal.serie
                           c-nr-nota-fis = nota-fiscal.nr-nota-fis
                           c-cod-estabel = nota-fiscal.cod-estabel.

                    IF nota-fiscal.nome-transp = "SEDEX" OR
                       nota-fiscal.nome-transp = "PAC" or
                       nota-fiscal.nome-transp = "E-SEDEX" THEN DO:
                       ASSIGN cSedex = "".
                            FOR EACH int-nota-conhec
                                  WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                                    AND int-nota-conhec.serie       = nota-fiscal.serie          
                                    AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:
                                  ASSIGN cSedex = cSedex +  int-nota-conhec.nr-conhec + " " .
                            END.
                            IF cSedex = "" THEN 
                                ASSIGN cSedex = nota-fiscal.nome-transp.
                    END.
                    ELSE DO:
                        IF nota-fiscal.nome-transp BEGINS "Retira" THEN
                           ASSIGN cSedex = nota-fiscal.nome-transp.
                        ELSE
                           ASSIGN cSedex = "".
                    END.
                END.
             end.

             if (lCancelado) then do:

                if (lAtendidoTotal) or (lAberto) then do:
                   run incluiMsgErro in this-procedure ('Pedido Ikeda ' + string(ttPedido.PedidoCodigo) + ' possui pedidos Abertos em um estabelecimento e Cancelados em outro. O status dever ser alterado manualmente.').
                   assign ttPedido.statusOk = no.
                end.
                else do:

                    /** Cancelado = 5 **/
                    run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 5, '', '', 0, '', output iStatus, output cStatus).
                    if (iStatus <> 1) then do:
                        run incluiMsgErro in this-procedure ('Erro ao atualizar status de cancelado para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo) + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                        assign ttPedido.statusOk = no.
                    end.

                end.

             end.
             else if (lCancelado2) then do:
                 /** Cancelado = 5 **/
                 run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 115, '', '', 0, '', output iStatus, output cStatus).
                 if (iStatus <> 1) then do:
                    run incluiMsgErro in this-procedure ('Erro ao atualizar status de cancelado Automatico para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo) + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                     assign ttPedido.statusOk = no.
                 end.
             end.
             else if (lAberto) then do:

                        if (lAtendidoTotal) then do:
                            IF cSedex BEGINS "RETIRA" THEN DO:
                            /** AtendidoParcialmente = ? **/
                                   FOR FIRST int-ped-venda NO-LOCK
                                       WHERE int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
                                   END.
                                   
                                   IF int-ped-venda.ParceiroCodigo = 34 OR 
                                      int-ped-venda.ParceiroCodigo = 37 OR 
                                      int-ped-venda.ParceiroCodigo = 45 THEN
                                      run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 120, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).
                                   ELSE
                                      run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 112, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                                   if (iStatus <> 1) then do:
                                      run incluiMsgErro in this-procedure ('Erro ao atualizar status de Atendido Parcialmente para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                                      assign ttPedido.statusOk = no.
                                   end.
                            END.
                            ELSE DO:

                                IF can-find(FIRST transporte WHERE transporte.nome-abrev = cSedex) THEN DO:
                                /** AtendidoParcialmente = ? **/
                                    FOR FIRST int-ped-venda NO-LOCK
                                        WHERE int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
                                    END.
                                      
                                       IF int-ped-venda.ParceiroCodigo = 34 OR 
                                          int-ped-venda.ParceiroCodigo = 37 or
                                          int-ped-venda.ParceiroCodigo = 45 THEN
                                          run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 120, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).
                                       ELSE
                                          run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 113, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                                       if (iStatus <> 1) then do:
                                          run incluiMsgErro in this-procedure ('Erro ao atualizar status de Atendido Parcialmente para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                                          assign ttPedido.statusOk = no.
                                       end.
                                END.
                                ELSE DO:
                                /** AtendidoParcialmente = ? **/

                                       run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 9999, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                                       if (iStatus <> 1) then do:
                                          run incluiMsgErro in this-procedure ('Erro ao atualizar status de Atendido Parcialmente para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                                          assign ttPedido.statusOk = no.
                                       end.
                                END.
                            END.
                        end.
                        else if (lNaoAprovado) then do:
/*                                                                                                                                                                                                                               */
/*                            /** AguardandoPagamento = 6 **/                                                                                                                                                                    */
/*                            run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 6, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).                                                           */
/*                                                                                                                                                                                                                               */
/*                            if (iStatus <> 1) then do:                                                                                                                                                                          */
/*                               run incluiMsgErro in this-procedure ('Erro ao atualizar status de Aguardando Pagamento para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + CHR(10)  + '               ' + STRING(istatus)). */
/*                               assign ttPedido.statusOk = no.                                                                                                                                                                  */
/*                            end.                                                                                                                                                                                               */
                        end.
/*                         else do:                                                                                                                                                                                                                         */
/*                            /** PagamentoConfirmado = 7 **/                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                          */
/*                             FIND FIRST int-ped-venda NO-LOCK                                                                                                                                                                                             */
/*                                 WHERE int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo                                                                                                                                                                 */
/*                                   AND int-ped-venda.FormaPgto    = 'Credito' NO-ERROR.                                                                                                                                                                   */
/*                             IF AVAIL int-ped-venda THEN DO:                                                                                                                                                                                              */
/*                                 IF int-ped-venda.cartid <> '' THEN                                                                                                                                                                                       */
/*                                     run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 7, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).                                                                             */
/*                             END. /* IF AVAIL int-ped-venda THEN DO: */                                                                                                                                                                                   */
/*                             ELSE                                                                                                                                                                                                                         */
/*                                 run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 7, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).                                                                                 */
/*                                                                                                                                                                                                                                                          */
/*                             if (iStatus <> 1) then do:                                                                                                                                                                                                   */
/*                                run incluiMsgErro in this-procedure ('Erro ao atualizar status de Pagamento Confirmado para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).  */
/*                                assign ttPedido.statusOk = no.                                                                                                                                                                                            */
/*                             end.                                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                          */
/*                         end.                                                                                                                                                                                                                             */
             end.
             else if (lAtendidoTotal) then do:
                 
                IF cSedex BEGINS "RETIRA" THEN DO:
                /** AtendidoParcialmente = ? **/
                        FOR FIRST int-ped-venda NO-LOCK
                            WHERE int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
                        END.
                        
                       IF int-ped-venda.ParceiroCodigo = 34 OR 
                          int-ped-venda.ParceiroCodigo = 37 or
                          int-ped-venda.ParceiroCodigo = 45 THEN
                          run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 120, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).
                       ELSE
                          run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 112, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                       if (iStatus <> 1) then do:
                          run incluiMsgErro in this-procedure ('Erro ao atualizar status de Atendido Parcialmente para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                          assign ttPedido.statusOk = no.
                       end.
                END.
                ELSE DO:
                    

                    IF can-find(FIRST transporte WHERE transporte.nome-abrev = cSedex) THEN DO:
                    /** AtendidoParcialmente = ? **/
                            FOR FIRST int-ped-venda NO-LOCK
                                WHERE int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
                            END.
                            
                           IF int-ped-venda.ParceiroCodigo = 34 OR 
                              int-ped-venda.ParceiroCodigo = 37 or
                              int-ped-venda.ParceiroCodigo = 45 THEN
                              run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 120, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).
                           ELSE
                              run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 109, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                           if (iStatus <> 1) then do:
                              run incluiMsgErro in this-procedure ('Erro ao atualizar status de Atendido Parcialmente para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                              assign ttPedido.statusOk = no.
                           end.

                    END.
                    ELSE DO:
                        
                        if (cSedex = '') then do:
                           /** Despachado por transportadora = 113 **/
                            
                           run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 113, '', "", int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                           if (iStatus <> 1) then do:
                              run incluiMsgErro in this-procedure ('Erro ao atualizar status de Faturado para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                              assign ttPedido.statusOk = no.
                           end.
                        end.
                        else do:
                           /** Despachado = 11 **/

                           run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 11, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).

                           if (iStatus <> 1) then do:
                              run incluiMsgErro in this-procedure ('Erro ao atualizar status de Despachado para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                              assign ttPedido.statusOk = no.
                           end.
                        end.

                    END.
                END.

             end.

          end.


          run desconecta in hWebService.
          delete object hWebService.

      END.

   end.

      /** Tira o flag para nÆo atualizar novamente na pr¢xima execu‡Æo, j  que deu tudo certo **/
      for each ttPedido
         where ttPedido.statusOk,
         each int-ped-venda exclusive-lock
            where int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
         assign int-ped-venda.atualizaIkeda = no.
      end.
      RELEASE int-ped-venda.
   return "OK".
end.

procedure incluiMsgErro:
   define input parameter pcDescErro as character no-undo.

   define variable iNextMsg as integer no-undo.

   find last MsgErro no-lock no-error.
   if available MsgErro then
      assign iNextMsg = MsgErro.SeqErro + 1.
   else
      assign iNextMsg = 1.

   create MsgErro.
   assign MsgErro.SeqErro  = iNextMsg
          MsgErro.DescErro = pcDescErro.

end procedure.


PROCEDURE pi-cancelaPedido:
    run dibo/bodi159can.p persistent set bo-ped-venda-can.

    run setUserLog in bo-ped-venda-can (input v_cod_usuar_corren ).      

    run validateCancelation in bo-ped-venda-can (input  ROWID(ped-venda),
                                                 output table Rowerrors).
    
    if  not can-find(first RowErrors
                     where RowErrors.ErrorSubType = "Error":U) then do:

        run updateCancelation in bo-ped-venda-can(input rowid(ped-venda),
                                                  input "Cancelamento Automatico - Pedido sem pagamento (Boleto) em atraso mais que 2 dias",
                                                  input TODAY,
                                                  input 8).
        run alterarStatus in hWebService (int-ped-venda.PedidoCodigo, 0, 115, '', '', 0, '', output iStatus, output cStatus).
                   
        
        if (iStatus <> 1) then do:
           run incluiMsgErro in this-procedure ('Erro ao atualizar status de cancelado Automatico para o Pedido Ikeda ' + string(int-ped-venda.PedidoCodigo) + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
      
           
        end.
        ELSE DO:
           
           run incluiMsgErro in this-procedure ('Cancelamento Automatico Efetuado para o Pedido Ikeda ' + string(int-ped-venda.PedidoCodigo) + ' Data de Implantacao: ' + STRING(ped-venda.dt-implant)).

           

        END.
    end.
    ELSE DO:
          run incluiMsgErro in this-procedure ('Erro ao tentar efetuar o cancelado Automatico para o Pedido Ikeda ' + string(int-ped-venda.PedidoCodigo) + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
      
        
    END.

    IF VALID-HANDLE(bo-ped-venda-can)  THEN DO:
      delete procedure bo-ped-venda-can.
      assign bo-ped-venda-can = ?.
    end.  
END PROCEDURE.


PROCEDURE pi-envia-email-softphone:

    
   DEFINE var pRemetente      as character no-undo.
   define VAR pDestinatario   as character no-undo.
   define VAR pAssunto        as character no-undo.
   define VAR pMensagem       as character no-undo.
   FIND FIRST param-global NO-LOCK NO-ERROR.

   FOR FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = c-cod-estabel
           AND nota-fiscal.serie       = c-serie
           AND nota-fiscal.nr-nota-fis = c-nr-nota-fis,
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
   END.

   ASSIGN pRemetente = "loja@intelbras.com.br"
          pDestinatario =  "anderson.cenci@intelbras.com.br,gisele.muhlmann@intelbras.com.br," + TRIM(emitente.e-mail)
          pAssunto      =  "Licen‡a SoftPhone IP Intelbras"
          pMensagem     =  "Parab‚ns, vocˆ acaba de adquirir um software com a qualidade e seguran‡a Intelbras." + CHR(10) +
                           "Este software lhe permite fazer chamadas VoIP em qualquer parte do mundo, bastando se autenticar em um servidor SIP." + CHR(10) +
                           "Mais informa‡äes sobre este software acesse o manual do produto no link:" + CHR(10) +
                           "http://www.intelbras.com.br/softphone/manual_softphone_ip.pdf" + CHR(10) +
                            
                            
                           "O c¢digo de licen‡a do software que vocˆ adquiriu ‚:  "  + CHR(10) +
                             c-licenca-softphone  + CHR(10) +
                            
                            
                            
                           "Para instalar o produto siga os seguintes passos:"  + CHR(10) +
                           "1-Atente-se ao requisito m¡nimo requerido no manual. Se o seu sistema nÆo atender a esse requisito nÆo continue a instala‡Æo e entre em contato com a Intelbras." + CHR(10) +
                           "2-Fa‡a o download do software no link:" + CHR(10) +
                           "http://www.intelbras.com.br/softphone/instalador softphone_ip.exe" + CHR(10) +
                           "3-Execute o arquivo de instala‡Æo e vocˆ receber  orienta‡Æo para proceder a instala‡Æo." + CHR(10)  + CHR(10) +
                            
                            
                           "D£vidas entre em contato com o suporte t‚cnico da Intelbras atrav‚s do " + CHR(10) +
                           "telefone (48) 2106 0006 ou email suporte.icorp@intelbras.com.br" + CHR(10) +
                           "Para sugestäes, reclama‡äes e rede autorizada: 0800 7042767".



   define variable h-utapi019 as handle      no-undo.

   create tt-envio2.
   assign tt-envio2.versao-integracao  = 1
          tt-envio2.servidor           = param-global.serv-mail
          tt-envio2.porta              = param-global.porta-mail
          tt-envio2.exchange           = param-global.log-1
          tt-envio2.remetente          = pRemetente
          tt-envio2.destino            = pDestinatario
          tt-envio2.assunto            = pAssunto
          tt-envio2.mensagem           = pMensagem
          tt-envio2.arq-anexo          = ''
          tt-envio2.importancia        = 1
          tt-envio2.log-enviada        = no
          tt-envio2.log-lida           = no
          tt-envio2.acomp              = no
          tt-envio2.formato            = 'TEXTO'.

   run utp/utapi019.p persistent set h-utapi019.
   run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).
   delete object h-utapi019.
end procedure.

PROCEDURE pi-retorna-quinto-dia-util:

    DEF INPUT PARAM p-dt-implant AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-quinto-dia AS DATE NO-UNDO.

    DEF VAR i-cont AS INT INIT 1 NO-UNDO.
    DEF VAR dia5   AS INT INIT 0 NO-UNDO.
    
    bloco:
    REPEAT:
        FIND FIRST dia_calend_glob NO-LOCK 
             WHERE dia_calend_glob.cod_calend = "FISCAL"
               AND dia_calend_glob.dat_calend = p-dt-implant + i-cont NO-ERROR.
        IF AVAIL dia_calend_glob THEN DO:
            IF dia_calend_glob.log_dia_util = YES THEN
                ASSIGN dia5 = dia5 + 1.
        END.
        IF dia5 = 5 THEN LEAVE bloco.
        ASSIGN i-cont = i-cont + 1.
    END.
    
    ASSIGN p-quinto-dia =  dia_calend_glob.dat_calend.

END.
