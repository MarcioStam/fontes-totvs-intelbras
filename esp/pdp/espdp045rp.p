/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp045rp.p
**  Autor.....: Rubia Ayabe de Oliveira
**  Data......: Outubro/2015 - Desenvolvimento
**  Descricao.: Integraá∆o WS Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp045 2.04.00.001}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find param-b2c no-lock.
find first param-global no-lock.
find first empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Integraá∆o Ikeda"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESPDP045"
       c-versao       = "2.04"
       c-revisao      = "001".

{esp/pdp/espdp044sh.i "new shared"}

define temp-table tt-param no-undo
    field destino        as integer
    field arquivo        as char format "x(35)":U
    field usuario        as char format "x(12)":U
    field data-exec      as date
    field hora-exec      as integer.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table ttPedido no-undo
   field PedidoCodigo   like int-ped-venda.PedidoCodigo
   field statusOk       as logical initial true
   index ch-Pedido      is primary unique PedidoCodigo.

define variable hWebService         as handle   no-undo.
define variable bo-ped-venda-can    as handle   no-undo.
define variable cMensagem           as character   no-undo.
define variable iStatus             as integer     no-undo.
define variable cStatus             as character   no-undo.
DEFINE VARIABLE c-licenca-softphone AS CHARACTER  FORMAT "x(2000)" NO-UNDO.
define variable lAtendidoTotal      as logical     no-undo.
define variable lCancelado          as logical     no-undo.
define variable lCancelado10        as logical     no-undo.
define variable lAberto             as logical     no-undo.
define variable lNaoAprovado        as logical     no-undo.
define variable cSedex              as character   no-undo.
define variable c-serie             as character   no-undo.
define variable c-nr-nota-fis       as character   no-undo.
DEFINE VARIABLE c-cod-estabel       AS CHARACTER   NO-UNDO. /* Licenáa Softphone - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Junho de 2012 */
DEFINE VARIABLE i-quant-licenca     AS INTEGER     NO-UNDO. /* Licenáa Softphone - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Junho de 2012 */


define temp-table RowErrors no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character format "x(150)"
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character format "x(150)"
    field ErrorSubtype     as character.

{include/i-freeac.i}
{utp/utapi019.i}

/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
/* ***************************  Main Block  *************************** */
do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i}
   view frame f-cabec.
   view frame f-rodape.
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Integrando...").
   run piIntegra.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   return "OK".
end.

procedure piIntegra:

    /** Atualizaá∆o de status de pedidos **/
    empty temp-table MsgErro.
    
    /*****************************************************/
    /* ***************************  Main Block  *************************** */
    do on stop undo, return error "NOK":
    
       run pi-acompanhar in h-acomp ('Atualizando status dos pedidos').
      /** Execuá∆o do WS para atualizar inforamá‰es na Ikeda **/
      run esp/pdp/espdp044rpb-ws.p persistent set hWebService.
      run conecta in hWebService (output iStatus, output cStatus).
    
      FOR EACH ped-venda
           WHERE (ped-venda.tp-pedido = "37" OR ped-venda.tp-pedido = "38" OR
                  ped-venda.tp-pedido = "80" OR ped-venda.tp-pedido = "18")
             AND (ped-venda.cod-priori = 01 OR ped-venda.cod-priori = 88)
             AND  ped-venda.cod-cond-pag = 75
             AND  (ped-venda.cod-sit-aval = 4 OR ped-venda.cod-sit-aval = 1)
             AND ped-venda.cod-sit-ped = 1
             AND  TODAY - ped-venda.dt-implant  > 10 NO-LOCK:
       FIND int-ped-venda
           WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
             AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
           EXCLUSIVE-LOCK NO-ERROR.
            /** Cancelado Automatico = 115 **/
       IF AVAIL int-ped-venda THEN DO:

            RUN pi-cancelaPedido.
            ASSIGN int-ped-venda.atualizaIkeda = NO.
        END.
        FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
        RELEASE int-ped-venda.

    END.
    

        /** Escolhe pedidos a atualizar **/
        for each ped-venda
            WHERE ped-venda.dt-useralt >= TODAY - 7 NO-LOCK,
            FIRST int-ped-venda NO-LOCK
                WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                  AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
              and not can-find (first ttPedido
                                where ttPedido.PedidoCodigo = int-ped-venda.PedidoCodigo):

            IF (ped-venda.cod-cond-pag < 74
            OR  ped-venda.cod-cond-pag > 76) THEN NEXT.

            create ttPedido.
            assign ttPedido.PedidoCodigo = int-ped-venda.PedidoCodigo.
        end.
    
       if can-find (first ttPedido) then do:
    
          if (iStatus <> 1) then
             run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda: ' + cStatus).
          else do:
              for each ttPedido:
                 run pi-acompanhar in h-acomp ('Atualizando status do pedido ' + string(ttPedido.PedidoCodigo)).
    
    
                 assign lAtendidoTotal = no
                        lCancelado     = no
                        lCancelado10   = no
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
                     if (ped-venda.cod-sit-ped = 4) or (ped-venda.cod-sit-ped = 5) or (ped-venda.cod-sit-ped = 6) THEN DO:
                         IF ped-venda.desc-cancela MATCHES("*Cancelamento Automatico - Pedido sem pagamento (Boleto) em atraso mais que 10 dias*")  THEN 
                             assign lCancelado10 = yes. 
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

/*                         PUT ' c-serie       ' c-serie              */
/*                             ' c-nr-nota-fis ' c-nr-nota-fis        */
/*                             ' c-cod-estabel ' c-cod-estabel        */
/*                             ' cSedex        ' cSedex         SKIP. */

                    END.

                 end.
    
/*                  PUT 'Alterando status  '                    */
/*                      ' lAtendidoTotal ' lAtendidoTotal       */
/*                      ' lCancelado     ' lCancelado           */
/*                      ' lAberto        ' lAberto              */
/*                      ' lNaoAprovado   ' lNaoAprovado   SKIP. */

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
                 else if (lCancelado10) then do:
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
                            end.
                            else do:
                               /** PagamentoConfirmado = 7 **/
    
                               run alterarStatus in hWebService (ttPedido.PedidoCodigo, 0, 7, '', cSedex, int(c-nr-nota-fis), c-serie, output iStatus, output cStatus).
    
                               if (iStatus <> 1) then do:
                                  run incluiMsgErro in this-procedure ('Erro ao atualizar status de Pagamento Confirmado para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                                  assign ttPedido.statusOk = no.
                               end.
                            end.
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

/*                  PUT ' iStatus ' iStatus ' - cstatus ' cstatus SKIP. */

                 IF iStatus = 1 THEN DO:
                     run incluiMsgErro in this-procedure ('Atualizacao status de Despachado com sucesso para o Pedido Ikeda ' + string(ttPedido.PedidoCodigo)  + CHR(10)  + '               ' + STRING(istatus) + ' ' + STRING(cstatus)).
                 END.
    
              end.
    
    
              run desconecta in hWebService.
              delete object hWebService.
    
          END.
    
       end.
    
/*        PUT 'Tira o flag para n∆o atualizar novamente na pr¢xima execuá∆o, j† que deu tudo certo' SKIP. */

          /** Tira o flag para n∆o atualizar novamente na pr¢xima execuá∆o, j† que deu tudo certo **/
          for each ttPedido
             where ttPedido.statusOk,
             each int-ped-venda exclusive-lock
                where int-ped-venda.PedidoCodigo = ttPedido.PedidoCodigo:
             assign int-ped-venda.atualizaIkeda = no.
          end.
          FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
          RELEASE int-ped-venda.

    end.
    /*****************************************************/

    assign cMensagem = cMensagem + '~nAtualizaá∆o de status: ' + return-value + '~n~n'.

/*     PUT cMensagem SKIP. */

    for each MsgErro:
        assign cMensagem = cMensagem + string(MsgErro.SeqErro) + ': ' + MsgErro.DescErro + '~n'.
/*         PUT ' cMensagem  ' cMensagem SKIP. */

    end.
    
    assign cMensagem = cMensagem + '========8<--------~n'.

    /** Joga conte£do da mensagem tambÇm no relat¢rio, para caso rode online **/
    put unformatted cMensagem skip.
 
    /** Manda e-mail **/
    if (cMensagem <> '') then
        run enviaMail (input 'ems@intelbras.com.br', input param-b2c.e-mail-log, input 'Integraá∆o B2C', input cMensagem).
end procedure.

procedure enviaMail:
   define input parameter pRemetente      as character no-undo.
   define input parameter pDestinatario   as character no-undo.
   define input parameter pAssunto        as character no-undo.
   define input parameter pMensagem       as character no-undo.

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
                                                  input "Cancelamento Automatico - Pedido sem pagamento (Boleto) em atraso mais que 10 dias",
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
          pAssunto      =  "Licenáa SoftPhone IP Intelbras"
          pMensagem     =  "ParabÇns, vocà acaba de adquirir um software com a qualidade e seguranáa Intelbras." + CHR(10) +
                           "Este software lhe permite fazer chamadas VoIP em qualquer parte do mundo, bastando se autenticar em um servidor SIP." + CHR(10) +
                           "Mais informaá‰es sobre este software acesse o manual do produto no link:" + CHR(10) +
                           "http://www.intelbras.com.br/softphone/manual_softphone_ip.pdf" + CHR(10) +
                            
                            
                           "O c¢digo de licenáa do software que vocà adquiriu Ç:  "  + CHR(10) +
                             c-licenca-softphone  + CHR(10) +
                            
                            
                            
                           "Para instalar o produto siga os seguintes passos:"  + CHR(10) +
                           "1-Atente-se ao requisito m°nimo requerido no manual. Se o seu sistema n∆o atender a esse requisito n∆o continue a instalaá∆o e entre em contato com a Intelbras." + CHR(10) +
                           "2-Faáa o download do software no link:" + CHR(10) +
                           "http://www.intelbras.com.br/softphone/instalador softphone_ip.exe" + CHR(10) +
                           "3-Execute o arquivo de instalaá∆o e vocà receber† orientaá∆o para proceder a instalaá∆o." + CHR(10)  + CHR(10) +
                            
                            
                           "D£vidas entre em contato com o suporte tÇcnico da Intelbras atravÇs do " + CHR(10) +
                           "telefone (48) 2106 0006 ou email suporte.icorp@intelbras.com.br" + CHR(10) +
                           "Para sugest‰es, reclamaá‰es e rede autorizada: 0800 7042767".



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

