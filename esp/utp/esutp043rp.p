/*----------------------------------------------------------------------
**  Programa..: esp/utp/esutp043rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2009 - Desenvolvimento
**  Descricao.: Relat¢rio de pontos do Fidelidade
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esutp043 2.04.00.003}
/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find first param-global no-lock.
find first empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Pontos Fidelidade"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESUTP043"
       c-versao       = "2.04"
       c-revisao      = "003".

{esp/utp/esutp043tt.i}

define variable h-acomp    as handle      no-undo.
define variable de-total   as decimal     no-undo format "->>>,>>>,>>9".
define variable c-dealer   like pontos-fidelidade.dealer no-undo.
define variable i-qtidade  as integer     no-undo.
define variable c-serial   as character   no-undo.

define temp-table tt-pontos no-undo
   field cpf-cnpj    like usuario-fidelidade.cpf-cnpj
   field nome        like usuario-fidelidade.nome
   field empresa     like usuario-fidelidade.empresa
   field cidade      like usuario-fidelidade.cidade
   field uf          like usuario-fidelidade.uf
   field data-movto  like pontos-fidelidade.data-movto
   field id-movto    like pontos-fidelidade.id-movto format "Ponto/Resgate"
   field it-codigo   like item.it-codigo
   field descricao   like item.desc-nacional
   field serial      as character format 'x(13)' column-label 'NS'
   field ns-keycode  like pontos-fidelidade.ns-keycode
   field pontos      like pontos-fidelidade.pontos   format "->>>,>>9"
   field dealer      like pontos-fidelidade.dealer
   field cnpj-dealer like pontos-fidelidade.cnpj-dealer
   index ch-pri is primary cpf-cnpj data-movto.

/*---------------------------     Frames    ---------------------------*/
form
   tt-pontos.cpf-cnpj
   tt-pontos.nome
   tt-pontos.empresa
   tt-pontos.cidade
   tt-pontos.uf
   with width 210 frame f-header side-labels stream-io.

/*---------------------------  ParÉmetros   ---------------------------*/

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
   if not tt-param.tg-csv then do:
      {include/i-rpcab.i}
      {include/i-rpout.i}
      view frame f-cabec.
      view frame f-rodape.
   end.
   else do:
      {include/i-rpout.i &pagesize="0"}
   end.
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   return "OK".
end.

procedure piImprimeRelat:
   EMPTY TEMP-TABLE tt-pontos.
   for each usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj >= tt-param.cpf-cnpj-ini
        and usuario-fidelidade.cpf-cnpj <= tt-param.cpf-cnpj-fim:

      run pi-acompanhar in h-acomp (input "CPF/CNPJ: " + usuario-fidelidade.cpf-cnpj).

      for each pontos-fidelidade no-lock
         where pontos-fidelidade.cpf-cnpj = usuario-fidelidade.cpf-cnpj
           AND pontos-fidelidade.data-movto >= tt-param.da-dt-ini 
           AND pontos-fidelidade.data-movto <= tt-param.da-dt-fim:


          if pontos-fidelidade.it-codigo <> '' then
              find first item no-lock
                   where item.it-codigo = pontos-fidelidade.it-codigo no-error.
          
          assign c-serial = pontos-fidelidade.n-serie.
          
          create tt-pontos.
          assign tt-pontos.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                 tt-pontos.nome        = usuario-fidelidade.nome
                 tt-pontos.empresa     = usuario-fidelidade.empresa
                 tt-pontos.cidade      = usuario-fidelidade.cidade
                 tt-pontos.uf          = usuario-fidelidade.uf
                 tt-pontos.data-movto  = pontos-fidelidade.data-movto
                 tt-pontos.id-movto    = yes
                 tt-pontos.it-codigo   = pontos-fidelidade.it-codigo
                 tt-pontos.descricao   = if available (item) then item.desc-nacional else ''
                 tt-pontos.serial      = c-serial
                 tt-pontos.ns-keycode  = pontos-fidelidade.ns-keycode
                 tt-pontos.pontos      = pontos-fidelidade.pontos
                 tt-pontos.dealer      = pontos-fidelidade.dealer
                 tt-pontos.cnpj-dealer = pontos-fidelidade.cnpj-dealer.

          IF (pontos-fidelidade.expirado = YES AND pontos-fidelidade.ptos-disp > 0)                                                                          OR
             (pontos-fidelidade.expirado = NO  AND pontos-fidelidade.ptos-disp > 0 AND (ADD-INTERVAL(pontos-fidelidade.data-movto, 1, 'years') < TODAY)) THEN DO:
              
              create tt-pontos.
              assign tt-pontos.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                     tt-pontos.nome        = usuario-fidelidade.nome
                     tt-pontos.empresa     = usuario-fidelidade.empresa
                     tt-pontos.cidade      = usuario-fidelidade.cidade
                     tt-pontos.uf          = usuario-fidelidade.uf
                     tt-pontos.it-codigo   = pontos-fidelidade.it-codigo
                     tt-pontos.data-movto  = ADD-INTERVAL(pontos-fidelidade.data-movto, 1, 'years')
                     tt-pontos.id-movto    = no
                     tt-pontos.descricao   = 'Ponto Expirado'
                     tt-pontos.pontos      = pontos-fidelidade.ptos-disp * -1.
          END.
      end.

      for each ponto-extra no-lock
         where ponto-extra.cpf-cnpj = usuario-fidelidade.cpf-cnpj
           AND ponto-extra.data-movto >= tt-param.da-dt-ini 
           AND ponto-extra.data-movto <= tt-param.da-dt-fim:

          create tt-pontos.
          assign tt-pontos.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                 tt-pontos.nome        = usuario-fidelidade.nome
                 tt-pontos.empresa     = usuario-fidelidade.empresa
                 tt-pontos.cidade      = usuario-fidelidade.cidade
                 tt-pontos.uf          = usuario-fidelidade.uf
                 tt-pontos.data-movto  = ponto-extra.data-movto
                 tt-pontos.id-movto    = yes
                 tt-pontos.it-codigo   = 'PONTO EXTRA'
                 tt-pontos.descricao   = ponto-extra.descricao
                 tt-pontos.pontos      = ponto-extra.pontos.

          IF (ponto-extra.expirado = YES AND ponto-extra.ptos-disp > 0)                                                                    OR
             (ponto-extra.expirado = NO  AND ponto-extra.ptos-disp > 0 AND (ADD-INTERVAL(ponto-extra.data-movto, 1, 'years') < TODAY)) THEN DO:
              
              create tt-pontos.
              assign tt-pontos.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                     tt-pontos.nome        = usuario-fidelidade.nome
                     tt-pontos.empresa     = usuario-fidelidade.empresa
                     tt-pontos.cidade      = usuario-fidelidade.cidade
                     tt-pontos.uf          = usuario-fidelidade.uf
                     tt-pontos.it-codigo   = 'PONTO EXTRA'
                     tt-pontos.data-movto  = ADD-INTERVAL(ponto-extra.data-movto, 1, 'years')
                     tt-pontos.id-movto    = NO
                     tt-pontos.descricao   = 'Ponto Expirado'
                     tt-pontos.pontos      = ponto-extra.ptos-disp * -1.
          END.
      end.

      for each resgate-premios no-lock
         where resgate-premios.cpf-cnpj = usuario-fidelidade.cpf-cnpj
           AND resgate-premios.data-movto >= tt-param.da-dt-ini 
           AND resgate-premios.data-movto <= tt-param.da-dt-fim:

         if tt-param.concluido and not resgate-premios.concluido then
            next.

         create tt-pontos.
         assign tt-pontos.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                tt-pontos.nome        = usuario-fidelidade.nome
                tt-pontos.empresa     = usuario-fidelidade.empresa
                tt-pontos.cidade      = usuario-fidelidade.cidade
                tt-pontos.uf          = usuario-fidelidade.uf
                tt-pontos.data-movto  = resgate-premios.data-movto
                tt-pontos.id-movto    = no
                tt-pontos.descricao   = 'Resgate de pontos'
                tt-pontos.pontos      = (resgate-premios.pontos * resgate-premios.quantidade) * -1.
      end.
   end.

   if tt-param.tg-csv then
      put unformatted 'CPF/CNPJ;Nome;Empresa;Cidade;UF;Data Movto;Item;Descricao;Serial;Keycode;Qt Pontos;Dealer;CNPJ Dealer;Emitente' skip.

   run pi-acompanhar in h-acomp (input "Imprimindo...").

   for each tt-pontos no-lock
      break by tt-pontos.cpf-cnpj:

      if not tt-param.tg-csv then do:
         if first-of (tt-pontos.cpf-cnpj) then do:
            assign de-total  = 0
                   i-qtidade = i-qtidade + 1.
   
            display
               tt-pontos.cpf-cnpj
               tt-pontos.nome
               tt-pontos.empresa
               tt-pontos.cidade
               tt-pontos.uf
               with frame f-header.            
         end.
      end.
      else do:
         put unformatted
            '"' tt-pontos.cpf-cnpj '";'
            '"' tt-pontos.nome     '";'
            '"' tt-pontos.empresa  '";'
            '"' tt-pontos.cidade   '";'
            '"' tt-pontos.uf       '";'.
      end.

      assign c-dealer = ''.

      if tt-pontos.cnpj-dealer <> '' then do:
         find first emitente no-lock
            where emitente.cgc = tt-pontos.cnpj-dealer no-error.
   
         if available emitente then
            assign c-dealer = emitente.nome-emit.
         else do:
            find first emitente no-lock
               where emitente.cgc begins substring(tt-pontos.cnpj-dealer,1,8) no-error.
   
            if available emitente then
               assign c-dealer = 'Filial n∆o cadastrada de ' + emitente.nome-emit.
            else
               assign c-dealer = 'Distribuidor n∆o cadastrado'.
         end.
      end.

      if tt-param.tg-csv then do:
         put unformatted
            '"' tt-pontos.data-movto  '";'
            '"' tt-pontos.it-codigo   '";'
            '"' tt-pontos.descricao   '";'
            '"' tt-pontos.serial      '";'
            '"' tt-pontos.ns-keycode  '";'
            '"' tt-pontos.pontos      '";'
            '"' tt-pontos.dealer      '";'
            '"' tt-pontos.cnpj-dealer '";'
            '"' c-dealer              '";'
            skip.
      end.
      else do:
         display
            tt-pontos.data-movto
            tt-pontos.it-codigo
            tt-pontos.descricao
            tt-pontos.serial
            tt-pontos.ns-keycode
            tt-pontos.pontos
            tt-pontos.dealer
            tt-pontos.cnpj-dealer
            c-dealer
            with width 210 stream-io down.

         assign de-total = de-total + tt-pontos.pontos.
   
         if last-of (tt-pontos.cpf-cnpj) then do:
            put
               de-total at 88
               " TOTAL".
         end.
      end.
   end.

   if not tt-param.tg-csv then
      put skip(2)
          '-----------------------------'
          skip
          'Total de usu†rios: ' i-qtidade.
end procedure.
