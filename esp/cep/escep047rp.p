/*--------------------------------------------------------------------------------
 Programa: escep047rp.p
 Autor   : Robinson Rafael Koprowski - SQLWorks
 Data    : 30/10/2008
--------------------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

/* Controle de versÆo */
{include/i-prgvrs.i escep047rp 1.00.00.000}

define buffer bf-int-ped for int-ped-venda.

define variable h-acomp          as handle      no-undo.
define variable iStatus          as integer     no-undo.
define variable cStatus          as character   no-undo.
define variable de-qt-saldo      as decimal     no-undo.
define variable lCancelado       as logical     no-undo.
define variable lAtendidoTotal   as logical     no-undo.
define variable cSedex           as character   no-undo.
define variable hWebService      as handle      no-undo.

{include/i-rpvar.i}
{utp/ut-glob.i}

{esp/pdp/espdp044rpe.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field it-codigo-ini    like item.it-codigo
    field it-codigo-end    like item.it-codigo.

define temp-table tt-raw-digita no-undo
   field raw-digita     as raw.

define temp-table ttSaldo no-undo
    field it-codigo     like item.it-codigo
    field qtde-dispon   as decimal
    field qtde-min      as decimal initial 1
   index idSaldo is primary unique it-codigo.

/* Parƒmetros do programa */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Extra‡Æo da temp-table tt-param da v ri vel raw-param recebida como parƒmetro */
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.



find first para-fat no-lock.
find first para-ped no-lock.
find first param-b2c no-lock.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-prin NO-ERROR.
IF AVAILABLE empresa THEN
ASSIGN c-empresa      = empresa.nome.
ASSIGN c-programa     = 'escep047rp':u
       c-versao       = '1.00':u
       c-revisao      = '.00.000':u
       c-sistema      = 'Espec¡fico':u
       c-titulo-relat = 'Atualiza‡Æo saldo itens B2C':u .

/* Defini‡Æo das frames do Relat¢rio */

{include/i-rpcab.i STREAM=str-rp}


/* In¡cio do programa*/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp ('Execu‡Æo de tarefas agendadas').

/*localiza os itens dos quais os saldos serao atualizados com base na flag de atualizacao dos pedidos*/
RUN pi-acompanhar IN h-acomp ('Contando estoque').


/* ABERTURA DO ARQUIVO DE SAIDA */ 
{include/i-rpout.i &STREAM="stream str-rp"}


/* Visualiza‡Æo das frames de cabe‡alho */

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.


/*
FOR EACH saldo-estoq NO-LOCK
    WHERE saldo-estoq.cod-depos   = param-b2c.cod-depos
      and saldo-estoq.it-codigo  >= tt-param.it-codigo-ini
      and saldo-estoq.it-codigo  <= tt-param.it-codigo-end
    /*AND   saldo-estoq.cod-localiz = tt-param.Localizacao*/
      AND (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)) > 0:
    if not can-find(first ttSaldo where ttSaldo.it-codigo = saldo-estoq.it-codigo) then do:
        create ttSaldo.
        assign ttSaldo.it-codigo   = saldo-estoq.it-codigo.
    end.
END.

/*seleciona os itens dos pedidos para atualizar o saldo*/
for each ttSaldo:

    FOR EACH saldo-estoq NO-LOCK
        WHERE saldo-estoq.it-codigo   = ttSaldo.it-codigo
          AND saldo-estoq.cod-depos   = param-b2c.cod-depos
        /*AND   saldo-estoq.cod-localiz = tt-param.Localizacao*/
          AND (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)) > 0:
        ASSIGN de-qt-saldo = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped).
    END.

    assign ttSaldo.qtde-dispon = (if de-qt-saldo > 0 then de-qt-saldo else 0).

end.
*/

/** Trechos acima comentados porque nÆo tem sentido! Duas leituras e soma errada. **/
for each saldo-estoq no-lock
   where saldo-estoq.cod-depos = param-b2c.cod-depos
     and saldo-estoq.it-codigo  >= tt-param.it-codigo-ini
     and saldo-estoq.it-codigo  <= tt-param.it-codigo-end,
   first item-estab-b2c no-lock
      where item-estab-b2c.it-codigo   = saldo-estoq.it-codigo
        and item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel,
   first item no-lock
      where item.it-codigo   = saldo-estoq.it-codigo
        and item.tipo-contr <> 4:

   find first ttSaldo
      where ttSaldo.it-codigo = saldo-estoq.it-codigo no-error.

   if not avail ttSaldo then do:
      create ttSaldo.
      assign ttSaldo.it-codigo = saldo-estoq.it-codigo
             ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
   end.

   assign ttSaldo.qtde-dispon = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped).
end.

for each saldo-estoq no-lock
   where saldo-estoq.cod-depos = param-b2c.cod-depos-saldao
     and saldo-estoq.it-codigo  >= tt-param.it-codigo-ini
     and saldo-estoq.it-codigo  <= tt-param.it-codigo-end,
   first item-estab-b2c no-lock
      where item-estab-b2c.it-codigo   = saldo-estoq.it-codigo
        and item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel
        AND item-estab-b2c.ind-aceita-saldao = YES,
   first item no-lock
      where item.it-codigo   = saldo-estoq.it-codigo
        and item.tipo-contr <> 4:

   find first ttSaldo
      where ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) + "S" no-error.

   if not avail ttSaldo then do:
      create ttSaldo.
      assign ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) + "S"
             ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
   end.

   assign ttSaldo.qtde-dispon = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped).
end.

RUN pi-acompanhar IN h-acomp ('Atualizando estoque no site').

run esp/cep/escep047rps.p persistent set hWebService.
run conecta in hWebService (output iStatus, output cStatus).

if iStatus > 1 then
   run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda').
else do:
   for each ttSaldo:
       RUN pi-acompanhar IN h-acomp ('Atualizado o Saldo do item ' + ttSaldo.it-codigo).
   
       run atualizaEstoque in hWebService (ttSaldo.it-codigo, ttSaldo.qtde-dispon, ttSaldo.qtde-min, output iStatus, output cStatus).
       if iStatus > 1 then
           run incluiMsgErro in this-procedure ('Erro ao atualizar o saldo do item ' + ttSaldo.it-codigo).
   end.
end.

run desconecta in hWebService.
delete object hWebService.

/* Fechamento do arquivo de saida */
{include/i-rpclo.i &STREAM="stream str-rp"}

RUN pi-acompanhar IN h-acomp ('Finalizado').

/* Finaliza tela de acompanhamento */
run pi-finalizar in h-acomp.

RETURN 'OK'.
/* fim do programa */



procedure incluiMsgErro:
    DEFINE INPUT  PARAMETER pcDescErro AS CHARACTER    NO-UNDO.

    define variable iNextMsg as integer      no-undo.

    find last MsgErro no-lock no-error.
    if available MsgErro then
        assign iNextMsg = MsgErro.SeqErro + 1.
    else
        assign iNextMsg = 1.

    create MsgErro.
    assign MsgErro.SeqErro = iNextMsg
           MsgErro.DescErro = pcDescErro.

end procedure.

