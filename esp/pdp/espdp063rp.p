/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp063rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Integraá∆o Itens WS Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp063 2.04.00.001}

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
       c-programa     = "ESPDP063"
       c-versao       = "2.04"
       c-revisao      = "001".

define variable h-acomp as handle   no-undo.

{esp/pdp/espdp063tt.i}
{include/i-freeac.i}

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
   define variable hWSItem          as handle      no-undo.
   define variable hWSCategoria     as handle      no-undo.
   define variable hWSCategoriaItem as handle      no-undo.
   define variable iStatus          as integer     no-undo.
   define variable cStatus          as character   no-undo.
   define variable lSaldao          as logical     no-undo.
   define variable cCaracteristica  as character   no-undo.

   run esp/pdp/espdp063rpc-ws.p persistent set hWSCategoriaItem.

   /** Item **/
   if (tt-param.exec-item) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp063rpa-ws.p persistent set hWSItem.
      run conecta in hWSItem (output iStatus, output cStatus).

      if (iStatus <> 1) then
         run incluiMsgErro in this-procedure ('Erro conectando na Ikeda: ' + cStatus).
      else do:
         for each item-estab-b2c no-lock
            where item-estab-b2c.nome-produto <> ''
              and item-estab-b2c.it-codigo    >= tt-param.it-codigo-ini
              and item-estab-b2c.it-codigo    <= tt-param.it-codigo-fim:

            assign lSaldao = item-estab-b2c.ind-aceita-saldao.

            run pi-acompanhar in h-acomp ('Cadastrando item ' + item-estab-b2c.cod-estabel + '/' + item-estab-b2c.it-codigo + (if (lSaldao) then 'S' else '')).

            assign cCaracteristica = item-estab-b2c.caracteristica.
            if (lSaldao) then
               assign cCaracteristica = cCaracteristica + '<p>Item sald∆o</p>'. /** A DEFINIR COM WESLEY **/

            find item no-lock
               where item.it-codigo = item-estab-b2c.it-codigo no-error.

            if not available (item) then
               run incluiMsgErro in this-procedure ('Item ' + item-estab-b2c.it-codigo + ' n∆o encontrado no EMS!').
            else do:
               run salvarProdutoPai in hWSItem (input trim(item.it-codigo) + (if (lSaldao) then 'S' else ''), /** Adiciona S no c¢digo do item de sald∆o **/
                                                input 'Intelbras' /** CodigoInternoFabricante **/,
                                                input item-estab-b2c.nome-produto,
                                                input item-estab-b2c.nome-produto /** TituloProduto **/,
                                                input '' /** SubTituloProduto **/,
                                                input item-estab-b2c.descricao /** DescricaoProduto **/,
                                                input cCaracteristica /** CaracteristicaProduto **/,
                                                input '' /** CodigoInternoEnquadramento **/,
                                                input '' /** ModeloProduto **/,
                                                input item.peso-liq,
                                                input item.peso-bru,
                                                input 0 /** AlturaProduto **/,
                                                input item.altura /** AlturaEmbalagemProduto **/,
                                                input 0 /** LarguraProduto **/,
                                                input item.largura /** LarguraEmbalagemProduto **/,
                                                input 0 /** ProfundidadeProduto **/,
                                                input item.comprim /** ProfundidadeEmbalagemProduto **/,
                                                input 0 /** VoltagemProduto **/,
                                                input 0 /** EntregaProduto **/,
                                                input item-estab-b2c.qt-maxima-venda /** QuantidadeMaximaPorVenda **/,
                                                input 2 /** ProdutoStatus 1-Ativo, 2-Inativo **/,
                                                input 2 /** StatusIntegracao 1-Integrar, 2-Integrado **/,
                                                input '1' /** TipoProduto 1-Produto, 2-Brinde, 3-ProdutoGratis, 4-ValePresente **/,
                                                input (if item-estab-b2c.presente then 1 else 2) /** Presente 1-Sim, 2-N∆o **/,
                                                input item-estab-b2c.vl-cheio /** PrecoCheioProduto **/,
                                                input item-estab-b2c.vl-por /** PrecoPor **/,
                                                input 2 /** PersonalizacaoExtra 1-Sim, 2-N∆o **/,
                                                input '' /** PersonalizacaoLabel **/,
                                                output iStatus, output cStatus).

               if (iStatus <> 1) then
                  run incluiMsgErro in this-procedure ('Item ' + trim(item.it-codigo) + (if (lSaldao) then 'S' else '') + ': ' + cStatus).
            end.
         end.
      end.

      run desconecta in hWSItem.
      delete object hWSItem.

      put unformatted 'Integraá∆o de item ok? ' not can-find(first MsgErro) skip.

      for each MsgErro:
         display MsgErro.SeqErro
                 MsgErro.DescErro format 'x(100)'
            with width 132
            .
      end.
   end.

   if (tt-param.exec-categoria) then do:
      empty temp-table MsgErro.

      run pi-acompanhar in h-acomp ('Cadastrando categorias').

      run esp/pdp/espdp063rpb-ws.p persistent set hWSCategoria.
      run conecta in hWSCategoria (output iStatus, output cStatus).

      if (iStatus <> 1) then
         run incluiMsgErro in this-procedure ('Erro conectando na Ikeda: ' + cStatus).
      else do:
         run esp/pdp/espdp063rpc-ws.p persistent set hWSCategoriaItem.
         run conecta in hWSCategoriaItem (output iStatus, output cStatus).

         if (iStatus <> 1) then
            run incluiMsgErro in this-procedure ('Erro conectando na Ikeda: ' + cStatus).
         else do:
            for each categoria-b2c no-lock
               where categoria-b2c.cod-categoria >= tt-param.categoria-ini
                 and categoria-b2c.cod-categoria <= tt-param.categoria-fim:

               run pi-acompanhar in h-acomp ('Cadastrando categoria ' + categoria-b2c.nome).

               run incluir in hWSCategoria (input categoria-b2c.cod-categoria,
                                            input categoria-b2c.nome,
                                            input (if categoria-b2c.ativo then 1 else 2),
                                            input categoria-b2c.cod-categoria-pai,
                                            output iStatus, output cStatus).

               if (iStatus <> 1) then
                  run incluiMsgErro in this-procedure ('Erro incluindo categoria ' + categoria-b2c.nome + ': ' + cStatus).
               else do:
                  for each categoria-item-b2c no-lock
                     where categoria-item-b2c.cod-categoria = categoria-b2c.cod-categoria
                       and categoria-item-b2c.it-codigo    >= tt-param.categoria-item-ini
                       and categoria-item-b2c.it-codigo    <= tt-param.categoria-item-fim:

                     run pi-acompanhar in h-acomp ('Relacionando item ' + categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else '')
                                                   + ' na categoria ' + categoria-b2c.nome).

                     run incluirCodigoInterno in hWSCategoriaItem (input categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else ''),
                                                                   input categoria-b2c.cod-categoria,
                                                                   output iStatus, output cStatus).

                     if (iStatus <> 1) then
                        run incluiMsgErro in this-procedure ('Erro incluindo item ' + categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else '')
                                                             + ' na categoria ' + categoria-b2c.nome + ': ' + cStatus).
                  end.
               end.
            end.
         end.

         run desconecta in hWSCategoriaItem.
         delete object hWSCategoriaItem.
      end.

      run desconecta in hWSCategoria.
      delete object hWSCategoria.

      put unformatted 'Integraá∆o de categoria ok? ' not can-find(first MsgErro) skip.

      for each MsgErro:
         display MsgErro.SeqErro
                 MsgErro.DescErro format 'x(100)'
            with width 132.
      end.
   end.

   if (tt-param.exec-categoria-item) then do:
      empty temp-table MsgErro.

      run esp/pdp/espdp063rpc-ws.p persistent set hWSCategoriaItem.
      run conecta in hWSCategoriaItem (output iStatus, output cStatus).

      if (iStatus <> 1) then
         run incluiMsgErro in this-procedure ('Erro conectando na Ikeda: ' + cStatus).
      else do:
         for each categoria-item-b2c no-lock
            where categoria-item-b2c.it-codigo >= tt-param.categoria-item-ini
              and categoria-item-b2c.it-codigo <= tt-param.categoria-item-fim,
            first categoria-b2c no-lock
               where categoria-b2c.cod-categoria = categoria-item-b2c.cod-categoria:

            run pi-acompanhar in h-acomp ('Relacionando item ' + categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else '')
                                          + ' na categoria ' + categoria-b2c.nome).

            run incluirCodigoInterno in hWSCategoriaItem (input categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else ''),
                                                          input categoria-b2c.cod-categoria,
                                                          output iStatus, output cStatus).

            if (iStatus <> 1) then
               run incluiMsgErro in this-procedure ('Erro incluindo item ' + categoria-item-b2c.it-codigo + (if categoria-item-b2c.ind-aceita-saldao then 'S' else '')
                                                    + ' na categoria ' + categoria-b2c.nome + ': ' + cStatus).
         end.
      end.

      run desconecta in hWSCategoriaItem.
      delete object hWSCategoriaItem.

      put unformatted 'Integraá∆o de item x categoria ok? ' not can-find(first MsgErro) skip.

      for each MsgErro:
         display MsgErro.SeqErro
                 MsgErro.DescErro format 'x(100)'
            with width 132.
      end.
   end.
end procedure.


procedure incluiMsgErro:
   define input parameter pcDescErro as character  no-undo.

   define variable iNextMsg as integer no-undo.

   find last MsgErro no-error.
   if available MsgErro then
      assign iNextMsg = MsgErro.SeqErro + 1.
   else
      assign iNextMsg = 1.

   create MsgErro.
   assign MsgErro.SeqErro  = iNextMsg
          MsgErro.DescErro = pcDescErro.

end procedure.
