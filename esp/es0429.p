/*****************************************************************************
**
**   Programa: es0429.p
**
**   Funcao: Checar validade dos manuais e envia e-mail para documentacao
**           checar validade de outras familias e envia e-mail para almox.
**   Data: 01/06/2000
**
**   Autor: Flavio Schoenell - INTELBRAS S/A.
**   EXECUCAO SEMANAL
******************************************************************************/

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define variable de-total   as decimal format ">>,>>>,>>9" no-undo.

define variable de-quantidade like ae-item.quantidade format ">>>>,>>>,>>9" no-undo.

define variable c-remetente as character no-undo.
define variable c-destino   as character no-undo.
define variable c-assunto   as character no-undo.
define variable c-descemail as character no-undo.
define variable c-arquivo   as character no-undo.


/* checa validade de manuais */
/* assign c-arquivo = session:temp-directory + "manuais.txt". */
assign c-arquivo = c-dir-arquivo-session + "manuais.txt".

output to value(c-arquivo).

for each ae-item no-lock
   where ae-item.cod-estabel = '101'
     and (ae-item.it-codigo begins "112" 
      or  ae-item.it-codigo begins "164")
     and ae-item.situacao = no
     and ae-item.cod-depos = "alm"
    and (ae-item.data-validade < today or ae-item.data-validade = ?),
    each item no-lock
   where item.it-codigo = ae-item.it-codigo
     and (item.it-codigo begins "112" or 
         (item.it-codigo begins "164" and item.descricao-1 matches ("*kit manual*")))
/*     and item.descricao-1 begins "KIT MANUAL" **/
    /**** retirado por solicitacao de Alessandra(documentacao) ******/
   break by ae-item.it-codigo
         by ae-item.nr-ae
         by ae-item.sequencia:
     
   if first-of(ae-item.it-codigo) then
      disp ae-item.it-codigo format "x(7)"
           item.descricao-1 +
           item.descricao-2 format "x(30)" label "Descricao".
   
   if first-of(ae-item.nr-ae) then 
      disp ae-item.nr-ae.

   disp ae-item.sequencia
        ae-item.data
        ae-item.quantidade format ">>>,>>9" (total by ae-item.nr-ae by ae-item.it-codigo)
        with width 132.
end.

output close.

assign c-remetente = "ems@intelbras.com.br"
       c-destino   = "threise.abreu@intelbras.com.br"
       c-assunto   = "Obsolescencia de manuais"
       c-descemail = "Os Manuais listados no arquivo anexo estao na empresa a mais de 6 meses" + chr(10) + chr(13).

run piEnviaEmail (input c-remetente,
                  input c-destino,
                  input c-assunto,
                  input c-descemail,
                  input c-arquivo).


/*******************************************************************/


/* assign c-arquivo = session:temp-directory + "materiais.txt". */
assign c-arquivo = c-dir-arquivo-session + "materiais.txt".

output to value(c-arquivo).

assign de-total = 0.

for each familia no-lock,
   each int-familia of familia
      where int-familia.meses-validade > 0,
   each item no-lock
      where item.fm-codigo = familia.fm-codigo,
   each ae-item no-lock
      where ae-item.cod-estabel = '101'
        and ae-item.it-codigo = item.it-codigo
        and ae-item.situacao = no
        and (ae-item.cod-depos = "alm" or ae-item.cod-depos = "exp")
        and (ae-item.data-validade = ? or ae-item.data-validade < today + 30)
   break by ae-item.it-codigo
         by ae-item.nr-ae
         by ae-item.sequencia:

   if first-of (ae-item.nr-ae) then
      assign de-total = 0.

   assign de-total = de-total + ae-item.quantidade.
   
   if last-of (ae-item.nr-ae) then do:
      put ae-item.it-codigo format "x(7)" ";"
          item.descricao-1 + item.descricao-2 format "x(30)" ";"
          ae-item.nr-ae ";"
          ae-item.localizacao ";"
          ae-item.data ";"
          ae-item.data-validade ";"
          de-total ";"
          (today - ((int-familia.meses-validade - 1) * 30)) - ae-item.data ";" 
          (today + 30) - if ae-item.data-validade = ? then (today + 30) else ae-item.data-validade
          skip.
   end.
end.

output close.


assign c-remetente = "ems@intelbras.com.br"
       c-destino   = "almoxar@intelbras.com.br"
       c-assunto   = "Obsolescencia de materiais"
       c-descemail = "Os Materiais listados em anexo estao na empresa alem do prazo estipulado" + chr(10) + chr(13).

run piEnviaEmail (input c-remetente,
                  input c-destino,
                  input c-assunto,
                  input c-descemail,
                  input c-arquivo).

procedure piEnviaEmail:
   define input parameter premetente as character no-undo.
   define input parameter pDestino   as character no-undo.
   define input parameter pAssunto   as character no-undo.
   define input parameter pDescEmail as character no-undo.
   define input parameter pArquivo   as character no-undo.

   empty temp-table tt-mail.
   find first param-global no-lock no-error.

   create tt-mail.
   assign tt-mail.Remetente     = pRemetente
          tt-mail.Destinatario  = pdestino
          tt-mail.Assunto       = pAssunto
          tt-mail.Arquivo       = if pArquivo <> "" then search(pArquivo) else ""
          tt-mail.Mensagem      = pDescEmail.

   run utp/utapi019.p persistent set h-utapi019.

   for each tt-mail:
      empty temp-table tt-envio2.
      empty temp-table tt-mensagem.

      create tt-envio2.
      assign tt-envio2.versao-integracao = 1
             tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */
             tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */
             tt-envio2.destino           = tt-mail.Destinatario     /* Destinat rio       */
             tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */
             tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
             tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor rio */
             tt-envio2.formato           = "TEXTO".

      create tt-mensagem.
      assign tt-mensagem.seq-mensagem = 1
             tt-mensagem.mensagem     = tt-mail.Mensagem.
           
      run pi-execute2 in h-utapi019 (input  table tt-envio2,
                                     input  table tt-mensagem,
                                     output table tt-erros).
           
      if can-find (first tt-erros) then
         return "NOK".
   end.
end procedure.
