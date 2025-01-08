/*----------------------------------------------------------------------
**  Programa..: esp/utp/esutp042rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2009 - Desenvolvimento
**  Descricao.: Relat¢rio de usu rios do Fidelidade
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
{include/i-prgvrs.i esutp042 2.04.00.002}
{include/i-rpvar.i}
{utp/ut-glob.i}

find first param-global no-lock.
find first mgcad.empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Usu rios Fidelidade"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESUTP042"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/utp/esutp042tt.i}

define variable h-acomp    as handle      no-undo.
define variable c-revenda  as character   no-undo format 'x(12)'.
define variable c-atuacao  as character   no-undo format 'x(50)'.
define variable i-qt-cpf   as integer     no-undo.
define variable i-qt-cnpj  as integer     no-undo.
DEFINE VARIABLE i-total-pontos  AS INTEGER     NO-UNDO.

/*---------------------------     Frames    ---------------------------*/

/*---------------------------  Parƒmetros   ---------------------------*/

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

   if tt-param.tg-csv then
      put unformatted 'CPF/CNPJ;Nome;Empresa;e-mail;Dealers;Endereco;Bairro;CEP;Cidade;UF;Telefone 1;Telefone 2;Data Cadastro;Data Ult. Modif;Ativo;Mailing;Tipo Revenda;Tipo Atuacao;Pontos' skip.

   for each usuario-fidelidade no-lock
      where  usuario-fidelidade.cpf-cnpj >= tt-param.cpf-cnpj-ini
        and  usuario-fidelidade.cpf-cnpj <= tt-param.cpf-cnpj-fim:
       IF tt-param.tg-ativo = 1 AND
            usuario-fidelidade.ativo = NO THEN NEXT.
       ELSE
           IF tt-param.tg-ativo = 2 AND
                usuario-fidelidade.ativo = YES THEN NEXT.

      case usuario-fidelidade.id-revenda:
         when 1 then do:
            if not tt-param.tg-ra then
               next.
            assign c-revenda = 'RA'.
         end.
         when 2 then do:
            if not tt-param.tg-rmc then
               next.
            assign c-revenda = 'RMC'.
         end.
      end case.
      ASSIGN i-total-pontos = 0.
      for each pontos-fidelidade no-lock
         where pontos-fidelidade.cpf-cnpj = usuario-fidelidade.cpf-cnpj:
         ASSIGN i-total-pontos = i-total-pontos + pontos-fidelidade.pontos.
      END.
      for each ponto-extra no-lock
         where ponto-extra.cpf-cnpj = usuario-fidelidade.cpf-cnpj:
          ASSIGN i-total-pontos = i-total-pontos + ponto-extra.pontos.
      END.


      IF NOT ((usuario-fidelidade.l-telecom AND tt-param.tg-telecom)      OR
              (usuario-fidelidade.l-seguran AND tt-param.tg-seguranca)    OR
              (usuario-fidelidade.l-inform  AND tt-param.tg-informatica)  OR 
              (NOT usuario-fidelidade.l-telecom AND NOT usuario-fidelidade.l-seguran AND NOT usuario-fidelidade.l-inform AND tt-param.tg-nenhum)) THEN 
          NEXT.


      ASSIGN c-atuacao = "".
      IF usuario-fidelidade.l-telecom THEN
          ASSIGN c-atuacao = 'Telecom'.

      IF usuario-fidelidade.l-seguran THEN
          IF c-atuacao <> "" THEN
               ASSIGN c-atuacao = c-atuacao + "/" + 'Seguran‡a'.
          ELSE 
              ASSIGN c-atuacao = 'Seguran‡a'.

      IF usuario-fidelidade.l-inform THEN
          IF c-atuacao <> "" THEN
               ASSIGN c-atuacao = c-atuacao + "/" + 'Inform tica'.
          ELSE 
              ASSIGN c-atuacao = 'Inform tica'.

      IF c-atuacao = "" THEN
          ASSIGN c-atuacao = "Nenhum".

      if not tt-param.tg-csv then do:
         display
            usuario-fidelidade.cpf-cnpj
            usuario-fidelidade.nome
            usuario-fidelidade.empresa
            usuario-fidelidade.e-mail
            usuario-fidelidade.dealers
            usuario-fidelidade.endereco
            usuario-fidelidade.bairro
            usuario-fidelidade.cep
            usuario-fidelidade.cidade
            usuario-fidelidade.uf
            usuario-fidelidade.telefone[1]
            usuario-fidelidade.telefone[2]
            usuario-fidelidade.dt-cadastro
            usuario-fidelidade.dt-ult-modif
            usuario-fidelidade.ativo   format 'Sim/NÆo'
            usuario-fidelidade.mailing format 'Sim/NÆo'
            c-revenda   label 'Tipo Revenda'
            c-atuacao   label 'Tipo Atua‡Æo'
            i-total-pontos LABEL "Total Pontos"
            skip(1)
            with width 132 stream-io down.
      end.
      else do:
         put unformatted
            '"' usuario-fidelidade.cpf-cnpj                 '";'
            '"' usuario-fidelidade.nome                     '";'
            '"' usuario-fidelidade.empresa                  '";'
            '"' usuario-fidelidade.e-mail                   '";'
            '"' usuario-fidelidade.dealers                  '";'
            '"' usuario-fidelidade.endereco                 '";'
            '"' usuario-fidelidade.bairro                   '";'
            '"' usuario-fidelidade.cep                      '";'
            '"' usuario-fidelidade.cidade                   '";'
            '"' usuario-fidelidade.uf                       '";'
            '"' usuario-fidelidade.telefone[1]              '";'
            '"' usuario-fidelidade.telefone[2]              '";'
            '"' usuario-fidelidade.dt-cadastro              '";'
            '"' usuario-fidelidade.dt-ult-modif             '";'
            '"' usuario-fidelidade.ativo   format 'Sim/NÆo' '";'
            '"' usuario-fidelidade.mailing format 'Sim/NÆo' '";'
            '"' c-revenda                                   '";'
            '"' c-atuacao                                   '";'
            '"' i-total-pontos                              '";'
            skip.
      end.

      if length(usuario-fidelidade.cpf-cnpj) = 11 then
         assign i-qt-cpf = i-qt-cpf + 1.
      else
         assign i-qt-cnpj = i-qt-cnpj + 1.
   end.

   if not tt-param.tg-csv then
      put skip(2)
          '---------------------------------------------'
          skip
          'Total de usu rios pessoa f¡sica:   ' i-qt-cpf
          skip
          'Total de usu rios pessoa jur¡dica: ' i-qt-cnpj.
end procedure.
