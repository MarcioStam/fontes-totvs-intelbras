/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp044 2.04.00.001}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find param-b2c no-lock.
find first param-global no-lock.
find first empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Integra‡Æo Ikeda"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESPDP044"
       c-versao       = "2.04"
       c-revisao      = "001".

{esp/pdp/espdp044sh.i "new shared"}
{esp/pdp/espdp044tt.i}
{include/i-freeac.i}

{utp/utapi019.i}

/*---------------------------  Parƒmetros   ---------------------------*/
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
   define variable cMensagem  as character   no-undo.

   /** Importa‡Æo de clientes **/
   if (tt-param.exec-rpa) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp044rpa.p (input tt-param.param-rpa).

      assign cMensagem = cMensagem + '~nImporta‡Æo de clientes: ' + return-value + '~n~n'.

      for each MsgErro:
         assign cMensagem = cMensagem + string(MsgErro.SeqErro) + ': ' + MsgErro.DescErro + '~n'.
      end.

      assign cMensagem = cMensagem + '========8<--------~n'.
   end.

   /** Importa‡Æo de pedidos **/
   if (tt-param.exec-rpb) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp044rpb.p (input tt-param.param-rpb).

      assign cMensagem = cMensagem + '~nImporta‡Æo de pedidos: ' + return-value + '~n~n'.
      
      for each MsgErro:
         assign cMensagem = cMensagem + string(MsgErro.SeqErro) + ': ' + MsgErro.DescErro + '~n'.
      end.

      assign cMensagem = cMensagem + '========8<--------~n'.
   end.

   /** Atualiza‡Æo de status de pedidos **/
   if (tt-param.exec-rpc) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp044rpc.p (input tt-param.param-rpc).

      assign cMensagem = cMensagem + '~nAtualiza‡Æo de status: ' + return-value + '~n~n'.
      
      for each MsgErro:
         assign cMensagem = cMensagem + string(MsgErro.SeqErro) + ': ' + MsgErro.DescErro + '~n'.
      end.

      assign cMensagem = cMensagem + '========8<--------~n'.
   end.

   /** Atualiza‡Æo de estoque **/
   if (tt-param.exec-rpd) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp044rpd.p (input tt-param.param-rpd).

      assign cMensagem = cMensagem + '~nAtualiza‡Æo de estoque: ' + return-value + '~n~n'.
      
      for each MsgErro:
         assign cMensagem = cMensagem + string(MsgErro.SeqErro) + ': ' + MsgErro.DescErro + '~n'.
      end.

      assign cMensagem = cMensagem + '========8<--------~n'.
   end.

   /** Joga conte£do da mensagem tamb‚m no relat¢rio, para caso rode online **/
   put unformatted cMensagem skip.

   /** Manda e-mail **/
   if (cMensagem <> '') then
      run enviaMail (input 'ems@intelbras.com.br', input param-b2c.e-mail-log, input 'Integra‡Æo B2C', input cMensagem).
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
