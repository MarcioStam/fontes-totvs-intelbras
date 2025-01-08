/*----------------------------------------------------------------------
**  Programa..: esp/cdp/escdp004rp-n.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integraªío WS Clientes - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

DEF VAR raw-param   AS RAW  NO-UNDO.

/*---------------------------  Variaveis    ---------------------------*/
{utp/ut-glob.i}

define variable hWebService   as handle   no-undo.
define variable h-cdapi704    as handle   no-undo.

DEFINE BUFFER b-emitente FOR emitente.

{esp/pdp/espdp044tt.i}
{esp/pdp/espdp044rpa-tt.i}
{esp/pdp/espdp044sh.i "shared"}
{include/i-freeac.i}

DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-emitente-raw NO-UNDO LIKE emitente.

/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param-rp as raw no-undo.

create tt-param-rpa.
raw-transfer raw-param-rp to tt-param-rpa.
/****************************  Main Block  ****************************/

 
do on stop undo, return error "NOK":
   define variable iStatus       as integer     no-undo.
   define variable cStatus       as character   no-undo.

   define variable c-endereco       as character   no-undo.
   define variable c-bairro         as character   no-undo.
   define variable c-cidade         as character   no-undo.
   define variable c-pais           as character   no-undo.
   define variable c-rua            as character   no-undo.
   define variable c-nro            as character   no-undo.
   define variable c-comp           as character   no-undo.
   define variable l-end-cobranca   as logical     no-undo.

   define variable c-cgc                  as character   no-undo.
   define variable c-nome-emit            as character   no-undo.
   define variable c-nome-abrev           as character   no-undo.
   define variable i-natureza             as integer     no-undo.
   define variable i-identific            as integer     no-undo.
   define variable i-ind-tipo-movto       as integer     no-undo.
   define variable i-ind-tipo-movto-entr  as integer     no-undo.
   define variable i-cod-emitente         as integer     no-undo.
   DEFINE VARIABLE l-log                  AS LOGICAL     NO-UNDO.

   run pi-acompanhar in h-acomp ('Obtendo novos clientes').

   /** Execuá∆o do WS para pegar inforamá‰es na Ikeda **/
   run esp/pdp/espdp044rpa-ws.p persistent set hWebService.
   run conecta in hWebService (output iStatus, output cStatus).


   IF l-log = YES THEN
       PUT "espdp044 1 " SKIP.

   if (iStatus <> 1) then
      run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda: ' + cStatus).
   else do:
      if (tt-param-rpa.Unico) and ((tt-param-rpa.CPF <> '') or (tt-param-rpa.CNPJ <> '')) then
         run listarCpfCnpj in hWebService (input tt-param-rpa.CPF, input tt-param-rpa.CNPJ,
                                           output iStatus, output cStatus,
                                           output table ttUsuario, output table ttConta, output table ttGrupos, output table ttEnderecos).
      else
         run listarNovos in hWebService (output iStatus, output cStatus,
                                         output table ttUsuario, output table ttConta, output table ttGrupos, output table ttEnderecos).

      if (iStatus <> 1) then
         run incluiMsgErro in this-procedure (cStatus).
   end.

   IF l-log = YES THEN
       PUT "espdp044 2 " SKIP.

   /** Se a execuá∆o da listagem foi ok **/
   if (iStatus = 1) then do:
      /** Cria c¢digo de vers∆o de integraá∆o da API **/
      create tt-versao-integr.
      assign tt-versao-integr.cod-versao-integracao = 001.

      run pi-acompanhar in h-acomp ('Implantando usu†rios importados no ERP').

      find param-global no-lock no-error.
      find mgcad.empresa no-lock
         where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
      find param-b2c no-lock no-error.

      usuarioblk:
      for each ttConta no-lock,
         each ttUsuario no-lock
            where ttUsuario.ContaCodigo = ttConta.ContaCodigo
         transaction on error undo usuarioblk, next usuarioblk:

         /** Limpa temp-tables de integraá∆o **/
         empty temp-table tt-emitente.
         empty temp-table tt-loc-entr.
         empty temp-table tt-loc-entr-aux.
         empty temp-table tt-int-loc-entr.
         empty temp-table tt-erros-geral.
         empty temp-table tt-dist-emitente.

         /** Trata se Ç PF ou PJ **/
         if (ttConta.Tipo begins 'PessoaF') then
            assign c-cgc       = replace(replace(ttConta.CPF, '.', ''), '-', '')
                   c-nome-emit = ttConta.Nome + ' ' + ttConta.Sobrenome
                   i-natureza  = 1.
         else if (ttConta.Tipo begins 'PessoaJ') then
            assign c-cgc       = replace(replace(replace(ttConta.CNPJ, '.', ''), '-', ''), '/', '')
                   c-nome-emit = ttConta.RazaoSocial
                   i-natureza  = 2.

         /** Inserá∆o ou Atualizaá∆o **/
         if can-find(first emitente
                     where emitente.cgc = c-cgc) then
            assign i-ind-tipo-movto = 2.
         else do:
            find last emitente no-lock no-error.
            assign i-cod-emitente   = emitente.cod-emitente + 1
                   i-ind-tipo-movto = 1
                   c-nome-abrev     = 'B2C' + ttConta.ContaCodigo
                   i-identific      = 1.
         end.

        IF l-log = YES THEN
             PUT "espdp044 3 " SKIP.

         /** Cria registro da temp-table para API **/
         create tt-emitente.
         /** Inserá∆o **/

         RUN esp/es0018p.p (INPUT  "ESPDP044":U,
                            INPUT  3,
                            INPUT  0,
                            INPUT  "":U,
                            OUTPUT TABLE tt-prog-ponto-tmp).

         FIND FIRST tt-prog-ponto-tmp
              WHERE INT(ENTRY(1,tt-prog-ponto-tmp.conteudo,";")) = int(ttConta.ParceiroCodigo) NO-ERROR.
         IF AVAIL tt-prog-ponto-tmp THEN DO:
             FIND FIRST gr-cli no-lock
                  WHERE gr-cli.cod-gr-cli = int(ENTRY(3,tt-prog-ponto-tmp.conteudo,";")) no-error.
         END.
         ELSE DO:
             FIND FIRST gr-cli no-lock
                  WHERE gr-cli.cod-gr-cli = param-b2c.cod-gr-cli no-error.
         END.
         
         if (i-ind-tipo-movto = 1) then do:
             
            assign tt-emitente.cod-emitente   = i-cod-emitente
                   tt-emitente.nome-abrev     = c-nome-abrev
                   tt-emitente.cgc            = c-cgc
                   tt-emitente.ins-estadual   = (if (ttConta.IE = '') or (ttConta.IE begins 'ISEN') or (i-natureza = 1) then 'ISENTO' else ttConta.IE)
                   tt-emitente.ins-municipal  = ttConta.IM
                   tt-emitente.ins-est-cob    = tt-emitente.ins-estadual              
                   tt-emitente.identific      = i-identific
                   tt-emitente.natureza       = i-natureza /** 1-Pessoa F°sica 2-Pessoa Jur°dica 3-Estrangeiro 4-Trading **/
                   tt-emitente.nome-emit      = fn-free-accent(upper(c-nome-emit))
                   tt-emitente.caixa-postal   = ''
                   tt-emitente.home-page      = ''
                   tt-emitente.cod-cond-pag   = gr-cli.cod-cond-pag
                   tt-emitente.taxa-financ    = 0
                   tt-emitente.cod-transp     = gr-cli.cod-transp
                   tt-emitente.linha-produt   = gr-cli.linha-produt
                   tt-emitente.atividade      = gr-cli.atividade
                   tt-emitente.contato[1]     = ''
                   tt-emitente.contato[2]     = ''
                   tt-emitente.telex          = ''
                   tt-emitente.data-implant   = today
                   tt-emitente.end-cobranca   = tt-emitente.cod-emitente
                   tt-emitente.cod-rep        = gr-cli.cod-rep 
                   tt-emitente.categoria      = gr-cli.categoria
                   tt-emitente.bonificacao    = gr-cli.bonificacao
                   tt-emitente.istr           = 0
                   tt-emitente.cod-gr-cli     = gr-cli.cod-gr-cli
                   tt-emitente.tp-rec-padrao  = 110
                   tt-emitente.ins-banc[1]    = 7
                   tt-emitente.ins-banc[2]    = 0
                   tt-emitente.tp-desp-padrao = 0
                   tt-emitente.cod-gr-forn    = 0    
                   tt-emitente.lim-credito    = gr-cli.lim-credito
                   tt-emitente.perc-fat-ped   = gr-cli.perc-fat-ped
                   tt-emitente.portador       = gr-cli.portador     
                   tt-emitente.modalidade     = gr-cli.modalidade     
                   tt-emitente.ind-fat-par    = gr-cli.ind-fat-par   
                   tt-emitente.contrib-icms   = (if (tt-emitente.ins-estadual = 'ISENTO') then no else yes)
                   tt-emitente.ind-cre-cli    = 1 /** 1-Normal 2-Autom†tico 3-S¢ Imp Ped 4-Suspenso 5-Pg a Vista **/
                   tt-emitente.ind-apr-cred   = gr-cli.ind-apr-cred
                   tt-emitente.nome-matriz    = tt-emitente.nome-abrev
                   tt-emitente.agencia        = '0000000'
                   tt-emitente.per-max-canc   = gr-cli.per-max-canc
                   tt-emitente.emite-etiq     = no /** Emite Etiqueta **/
                   tt-emitente.tr-ar-valor    = 1 /** NFE 1-Trunca 2-Arredonda **/
                   tt-emitente.gera-ad        = no /** Gera Aviso DÇbito **/
/*                    tt-emitente.port-prefer    = gr-cli.portador         POR SOLICITACAO ANDRE ANDERSEN                                                                                                                  */
/*                    tt-emitente.mod-prefer     = gr-cli.modalidade /** Modalidade 1-Cb Simples 2-Desconto 3-Cauá∆o 4-Judicial 5-Repres 6-Carteira 7-Vendor 8-Cheque 9-Nota Promiss¢ria **/ */
                   tt-emitente.bx-acatada     = 0 
                   tt-emitente.conta-corren   = '000000000000'
                   tt-emitente.nr-copias-ped  = 1
                   tt-emitente.cod-suframa    = ''
                   tt-emitente.cod-cacex      = ''
                   tt-emitente.gera-difer     = 0
                   tt-emitente.nr-tabpre      = gr-cli.nr-tabpre
                   tt-emitente.ind-aval       = 3
                   tt-emitente.user-libcre    = '*'
                   tt-emitente.ven-domingo    = 1 /** Vencto Domingo 1-Prorroga 2-Antecipa 3-MantÇm **/
                   tt-emitente.ven-sabado     = 1 /** Vencto S†bado 1-Prorroga 2-Antecipa 3-MantÇm **/
                   tt-emitente.cx-post-cob    = ''
                   tt-emitente.cod-banco      = 0                        
                   tt-emitente.prox-ad        = 0
                   tt-emitente.nr-peratr      = gr-cli.nr-peratr
                   tt-emitente.nr-mesina      = gr-cli.nr-mesina
                   tt-emitente.cod-mensagem   = 0
                   tt-emitente.observacoes    = 'Cadastro inserido pelo B2C em ' + string(today,"99/99/9999") + '.~r' + tt-emitente.observacoes
                   tt-emitente.forn-exp       = no
                   tt-emitente.tp-qt-prg      = 1 /** Tp Qtde 1-L°quida 2-Acumulada **/
                   tt-emitente.ind-atraso     = 1 /** Atraso 1-N∆o Informa 2-Informa 3-Sumaria **/
                   tt-emitente.ind-div-atraso = 1 /** Atraso 1-N∆o Aceita 2-Ignora 3-Assume Situaá∆o Inferior 4-Assume Qtde Inferior **/
                   tt-emitente.ind-dif-atrs-1 = 1 /** Inf > Calc 1-N∆o Aceita 2-Ignora 3-Adiciona Atraso + Recente **/
                   tt-emitente.ind-dif-atrs-2 = 1 /** Inf < Calc 1-N∆o Aceita 2-Ignora 3-Adiciona Atraso + Antigo **/
                   tt-emitente.esp-pd-venda   = 1
                   tt-emitente.resumo-mp      = 2 /** Resumo Multiplanta 1-Calculado 2-∑ Calcular **/
                   tt-emitente.ind-tipo-movto = 1 /** 1-Inclus∆o 2-Alteraá∆o **/
                   tt-emitente.tip-cob-desp   = 2 /* Rateia despesas entre todas as duplicatas */
                   tt-emitente.cod-entrega    = "Padrao"
                   tt-emitente.ind-lib-estoque = YES.

            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.nome-abrev  = tt-emitente.nome-matriz
                   AND b-emitente.nome-abrev <> tt-emitente.nome-abrev NO-ERROR.

            IF AVAIL b-emitente THEN DO:
                ASSIGN tt-emitente.port-prefer = b-emitente.port-prefer
                       tt-emitente.mod-prefer  = b-emitente.mod-prefer.
            END.

           IF l-log = YES THEN
                PUT "espdp044 4 " SKIP.


            if (tt-emitente.natureza = 1) then
               assign tt-emitente.nat-operacao = '510102'
                      tt-emitente.nat-ope-ext  = '610101'.
            else if tt-emitente.natureza = 2 then
               assign tt-emitente.nat-operacao = '510102'
                      tt-emitente.nat-ope-ext  = (if (tt-emitente.ins-estadual = '') or (tt-emitente.ins-estadual = 'ISENTO') then '610700' else '610101').
         end.
         else do:
            /** Alteraá∆o **/
            find emitente exclusive-lock 
                 where emitente.cgc = c-cgc no-error.
            if avail emitente then     
                assign emitente.ind-lib-estoque = YES. /* N∆o gravou via api */
                
            find emitente no-lock
               where emitente.cgc = c-cgc no-error.
            
            buffer-copy emitente to tt-emitente.
            assign tt-emitente.identific       = (if (tt-emitente.identific = 2) then 3 else tt-emitente.identific)
                   tt-emitente.observacoes     = 'Cadastro modificado pelo B2C em ' + string(today,"99/99/9999") + '.~r' + tt-emitente.observacoes
                   tt-emitente.ind-tipo-movto  = 2
                   tt-emitente.ind-lib-estoque = YES.

            /** Se era fornecedor, tem campos novos para preencher quando cliente **/
            if (emitente.identific = 2) then do:

               assign tt-emitente.cod-cond-pag   = gr-cli.cod-cond-pag
                      tt-emitente.cod-transp     = gr-cli.cod-transp
                      tt-emitente.linha-produt   = gr-cli.linha-produt
                      tt-emitente.atividade      = gr-cli.atividade
                      tt-emitente.cod-rep        = gr-cli.cod-rep 
                      tt-emitente.categoria      = gr-cli.categoria
                      tt-emitente.bonificacao    = gr-cli.bonificacao
                      tt-emitente.cod-gr-cli     = gr-cli.cod-gr-cli
                      tt-emitente.tp-rec-padrao  = 110
                      tt-emitente.ins-banc[1]    = 7
                      tt-emitente.ins-banc[2]    = 0
                      tt-emitente.lim-credito    = gr-cli.lim-credito
                      tt-emitente.perc-fat-ped   = gr-cli.perc-fat-ped
                      tt-emitente.portador       = gr-cli.portador     
                      tt-emitente.modalidade     = gr-cli.modalidade     
                      tt-emitente.ind-fat-par    = gr-cli.ind-fat-par   
                      tt-emitente.contrib-icms   = (if (tt-emitente.ins-estadual = 'ISENTO') then no else yes)
                      tt-emitente.ind-cre-cli    = 1 /** 1-Normal 2-Autom†tico 3-S¢ Imp Ped 4-Suspenso 5-Pg a Vista **/
                      tt-emitente.ind-apr-cred   = gr-cli.ind-apr-cred
                      tt-emitente.per-max-canc   = gr-cli.per-max-canc
/*                       tt-emitente.port-prefer    = gr-cli.portador           POR SOLICITACAO ANDRE ANDERSEN                                                                                                                 */
/*                       tt-emitente.mod-prefer     = gr-cli.modalidade /** Modalidade= 1-Cb Simples 2-Desconto 3-Cauá∆o 4-Judicial 5-Repres 6-Carteira 7-Vendor 8-Cheque 9-Nota Promiss¢ria **/ */
                      tt-emitente.nr-tabpre      = gr-cli.nr-tabpre
                      tt-emitente.ind-aval       = 3
                      tt-emitente.user-libcre    = '*'
                      tt-emitente.nr-peratr      = gr-cli.nr-peratr
                      tt-emitente.nr-mesina      = gr-cli.nr-mesina
                      tt-emitente.esp-pd-venda   = 1. /** 1-Inclus∆o 2-Alteraá∆o **/

                FIND FIRST b-emitente NO-LOCK
                     WHERE b-emitente.nome-abrev  = tt-emitente.nome-matriz
                       AND b-emitente.nome-abrev <> tt-emitente.nome-abrev NO-ERROR.
    
                IF AVAIL b-emitente THEN DO:
                    ASSIGN tt-emitente.port-prefer = b-emitente.port-prefer
                           tt-emitente.mod-prefer  = b-emitente.mod-prefer.
                END.

                IF l-log = YES THEN
                     PUT "espdp044 5 " SKIP.

            end.
         end.

         /** Tratamento dos endereáos **/
         assign l-end-cobranca = no.

         for each ttEnderecos no-lock
            where ttEnderecos.ContaCodigo = ttConta.ContaCodigo
              and ttEnderecos.Pais       <> ''
              and ttEnderecos.Estado     <> ''
              and ttEnderecos.Cidade     <> '':
             
            if (ttEnderecos.CEP = '88104800') then
               assign c-endereco = 'INTELBRAS SA - ROD. BR 101, KM 213'
                      c-bairro   = 'AREA INDUSTRIAL'
                      c-cidade   = 'SAO JOSE'.
            else
               assign c-endereco = (if ttEnderecos.TipoLogradouro = 'Nenhum' then '' else ttEnderecos.TipoLogradouro + ' ')
                                      + ttEnderecos.Logradouro + ', '
                                      + ttEnderecos.Numero + ' - '
                                      + ttEnderecos.Complemento
                      c-endereco = fn-free-accent(upper(trim(c-endereco)))
                      c-bairro   = fn-free-accent(upper(trim(string(ttEnderecos.Bairro, 'x(30)'))))
                      c-cidade   = fn-free-accent(upper(trim(string(ttEnderecos.Cidade, 'x(25)')))).

            /** A Ikeda manda pa°s como c¢digo, sei l† porquà **/
            find int-pais-b2c no-lock
               where int-pais-b2c.cod-pais = int(ttEnderecos.Pais) no-error.

            if not available (int-pais-b2c) then
               assign c-pais = ttEnderecos.Pais. 
            else
               assign c-pais = int-pais-b2c.nome-pais.

            /** Incidente 15789 **/
            if not can-find(first cep
                            where cep.cep = int(ttEnderecos.CEP)) then do:
               run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: CEP ' + ttEnderecos.CEP + ' informado n∆o existe no cadastro dos Correios').
               undo usuarioblk, next usuarioblk.
            end.

            /** Telefone2 alterado para Celular ap¢s conversa com Afonso, Elaine e Wesley em 27.09.2010 **/
            if (ttEnderecos.Finalidade = 'Contato') or (ttEnderecos.Finalidade = 'Nenhum') then do:
               assign tt-emitente.bairro         = c-bairro
                      tt-emitente.cidade         = c-cidade
                      tt-emitente.estado         = upper(trim(ttEnderecos.Estado))
                      tt-emitente.cep            = ttEnderecos.CEP
                      tt-emitente.pais           = c-pais
                      tt-emitente.endereco       = c-endereco
                      tt-emitente.e-mail         = fn-free-accent(lower(ttEnderecos.Email))
                      tt-emitente.telefone[1]    = (if (length(ttEnderecos.DDD1) > 0) then ttEnderecos.DDD1 else '') + ttEnderecos.Telefone1
                      tt-emitente.ramal[1]       = ttEnderecos.Ramal1
                      tt-emitente.telefone[2]    = (if (length(ttEnderecos.DDDCelular) > 0) then ttEnderecos.DDD2 else '') + ttEnderecos.Celular
                      tt-emitente.ramal[2]       = ttEnderecos.Ramal2
                      tt-emitente.telefax        = (if (length(ttEnderecos.DDDFax) > 0) then ttEnderecos.DDDFax else '') + ttEnderecos.Fax
                      tt-emitente.telefone[1]    = replace(replace(replace(replace(replace(tt-emitente.telefone[1],"/",""),"-",""),"(",""),")","")," ","")
                      tt-emitente.telefone[2]    = replace(replace(replace(replace(replace(tt-emitente.telefone[2],"/",""),"-",""),"(",""),")","")," ","")
                      tt-emitente.telefax        = replace(replace(replace(replace(replace(tt-emitente.telefax,"/",""),"-",""),"(",""),")","")," ","").


               /** Local de entrega padr∆o **/
               if not can-find(loc-entr where loc-entr.nome-abrev  = tt-emitente.nome-abrev
                                          and loc-entr.cod-entrega = 'Padr∆o') then
                  assign i-ind-tipo-movto-entr = 1.
               else
                  assign i-ind-tipo-movto-entr = 2.

               create tt-loc-entr.
               assign tt-loc-entr.nome-abrev     = tt-emitente.nome-abrev
                      tt-loc-entr.cod-entrega    = 'Padr∆o'
                      tt-loc-entr.endereco       = c-endereco
                      tt-loc-entr.bairro         = c-bairro
                      tt-loc-entr.cidade         = c-cidade
                      tt-loc-entr.estado         = upper(ttEnderecos.Estado)
                      tt-loc-entr.cep            = ttEnderecos.CEP
                      tt-loc-entr.caixa-postal   = ''
                      tt-loc-entr.pais           = c-pais
                      tt-loc-entr.cgc            = tt-emitente.cgc
                      tt-loc-entr.ins-estadual   = tt-emitente.ins-estadual
                      tt-loc-entr.e-mail         = fn-free-accent(lower(ttEnderecos.Email))
                      tt-loc-entr.ind-tipo-movto = i-ind-tipo-movto-entr. /** 1-Inclui 2-Modifica 3-Exclui **/
   
              find transporte no-lock
                 where transporte.cod-transp = gr-cli.cod-transp no-error.
   
              if NOT available (transporte) then
                  assign tt-loc-entr.nome-transp = "SEDEX"
                         tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)'). 
              ELSE IF transporte.nome-abrev = "" THEN
                      assign tt-loc-entr.nome-transp = "SEDEX"
                             tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)'). 

                  ELSE
                     assign tt-loc-entr.nome-transp = string(transporte.nome-abrev,'x(12)')
                            tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)'). 


                     IF l-log = YES THEN
                          PUT "espdp044 6 " SKIP.

   
              if (length(c-endereco) > 40) then do:
                 create tt-int-loc-entr.
                 assign tt-int-loc-entr.nome-abrev        = tt-emitente.nome-abrev
                        tt-int-loc-entr.cod-entrega       = tt-loc-entr.cod-entrega
                        tt-int-loc-entr.endereco-completo = c-endereco.
                 run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: local de entrega do cliente maior que 40 caracteres - Revise no CD0705, Emitente: ' + string(tt-emitente.cod-emitente)).
              end.
            end.
            else if (ttEnderecos.Finalidade begins 'Cobran') then
               assign l-end-cobranca           = yes
                      tt-emitente.cgc-cob      = (if (tt-emitente.natureza = 1) then '' else tt-emitente.cgc)
                      tt-emitente.estado-cob   = upper(ttEnderecos.Estado)
                      tt-emitente.cidade-cob   = c-cidade
                      tt-emitente.bairro-cob   = c-bairro
                      tt-emitente.endereco-cob = c-endereco
                      tt-emitente.pais-cob     = c-pais
                      tt-emitente.cep-cob      = ttEnderecos.CEP
                      tt-emitente.ins-est-cob  = tt-emitente.ins-estadual.
            else do:
               /** Endereáos de entrega quaisquer **/
               if not can-find(loc-entr where loc-entr.nome-abrev  = tt-emitente.nome-abrev
                                          and loc-entr.cod-entrega = ttEnderecos.EnderecoCodigo) then
                  assign i-ind-tipo-movto-entr = 1.
               else
                  assign i-ind-tipo-movto-entr = 2.

               create tt-loc-entr.
               assign tt-loc-entr.nome-abrev     = tt-emitente.nome-abrev
                      tt-loc-entr.cod-entrega    = ttEnderecos.EnderecoCodigo
                      tt-loc-entr.endereco       = c-endereco
                      tt-loc-entr.bairro         = c-bairro
                      tt-loc-entr.cidade         = c-cidade
                      tt-loc-entr.estado         = upper(ttEnderecos.Estado)
                      tt-loc-entr.cep            = ttEnderecos.CEP
                      tt-loc-entr.caixa-postal   = ''
                      tt-loc-entr.pais           = c-pais
                      tt-loc-entr.cgc            = tt-emitente.cgc
                      tt-loc-entr.ins-estadual   = tt-emitente.ins-estadual
                      tt-loc-entr.e-mail         = fn-free-accent(lower(ttEnderecos.Email))
                      tt-loc-entr.ind-tipo-movto = i-ind-tipo-movto-entr. /** 1-Inclui 2-Modifica 3-Exclui **/
   
              find transporte no-lock
                 where transporte.cod-transp = gr-cli.cod-transp no-error.
   
              if NOT available (transporte) then
                  assign tt-loc-entr.nome-transp = "SEDEX"
                         tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)'). 
              ELSE IF transporte.nome-abrev = "" THEN
                      assign tt-loc-entr.nome-transp = "SEDEX"
                             tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)'). 

                  ELSE
                     assign tt-loc-entr.nome-transp = string(transporte.nome-abrev,'x(12)')
                            tt-loc-entr.nom-cidad-cif  = string(tt-loc-entr.cidade,'x(25)').  
   
              if (length(c-endereco) > 40) then do:
                 create tt-int-loc-entr.
                 assign tt-int-loc-entr.nome-abrev        = tt-emitente.nome-abrev
                        tt-int-loc-entr.cod-entrega       = tt-loc-entr.cod-entrega
                        tt-int-loc-entr.endereco-completo = c-endereco.
                 run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: local de entrega do cliente maior que 40 caracteres - Revise no CD0705, Emitente: ' + string(tt-emitente.cod-emitente)).
              end.
            end.
         end. /** for each ttEnderecos **/
         IF l-log = YES THEN
              PUT "espdp044 7 " SKIP.


         /** Endereáo de cobranáa montado para caso de n∆o ter vindo na lista de endereáos **/
         /** Tarefa 18591: convers∆o de fornecedor para ambos estava incompleta, n∆o mudava os campos abaixo **/
         if ((l-end-cobranca = no) and (i-ind-tipo-movto = 1)) or (tt-emitente.cidade-cob = '') then
            assign tt-emitente.cgc-cob        = (if (tt-emitente.natureza = 1) then '' else tt-emitente.cgc)
                   tt-emitente.estado-cob     = tt-emitente.estado
                   tt-emitente.cidade-cob     = tt-emitente.cidade
                   tt-emitente.bairro-cob     = tt-emitente.bairro
                   tt-emitente.endereco-cob   = tt-emitente.endereco
                   tt-emitente.cep-cob        = tt-emitente.cep
                   tt-emitente.pais-cob       = tt-emitente.pais.

        
         /** Faz chamada Ö API de integraá∆o ***/
         /** Com gambiarra para o CRM **/
         /** Enviando uma temp-table de local de entrega vazia **/
         run cdp/cdapi329.p (input  table tt-versao-integr,
                             output table tt-erros-geral,
                             input  table tt-emitente,
                             input  table tt-loc-entr-aux,
                             input  table tt-dist-emitente).

         IF l-log = YES THEN
              PUT "espdp044 8 " SKIP.

         /** Trata erros da API **/
         if can-find(first tt-erros-geral) then do:
             IF l-log = YES THEN
                  PUT "espdp044 9 " SKIP.

            for each tt-erros-geral:
               run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc +  ', Erro ' + string(tt-erros-geral.cod-erro) + ': ' + tt-erros-geral.des-erro).
            end.
            undo usuarioblk, next usuarioblk.
         end.
         else do:
            if can-find (first tt-loc-entr) then do:
               /** Faz nova chamada Ö API de integraá∆o ***/
               /** Com gambiarra para o CRM **/
               /** A gambiarra Ç devido Ö trigger de loc-entr disparar antes da trigger de emitente, causando erro no CRM **/
               assign tt-emitente.ind-tipo-movto = 2. /** Modificaá∆o, independente de ter sido modificado ou inserido **/

               IF l-log = YES THEN
                    PUT "espdp044 10 " SKIP.

               run cdp/cdapi329.p (input  table tt-versao-integr,
                                   output table tt-erros-geral,
                                   input  table tt-emitente,
                                   input  table tt-loc-entr,
                                   input  table tt-dist-emitente).

               if can-find(first tt-erros-geral) then do:
                   IF l-log = YES THEN
                        PUT "espdp044 11 " SKIP.

                  for each tt-erros-geral:
                     run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc +  ', Erro ' + string(tt-erros-geral.cod-erro) + ': ' + tt-erros-geral.des-erro).
                  end.
                  undo usuarioblk, next usuarioblk.
               end.
            end.

            IF l-log = YES THEN
                 PUT "espdp044 12 " tt-emitente.cod-emitente SKIP.


            /** Cria a extens∆o de emitente B2C **/
            find int-emitente-b2c exclusive-lock
               where int-emitente-b2c.cod-emitente = tt-emitente.cod-emitente no-error.
            if not available (int-emitente-b2c) then do:
               create int-emitente-b2c.
               assign int-emitente-b2c.cod-emitente = tt-emitente.cod-emitente.
            end.

            /** Atualiza o endereáo completo, caso necess†rio **/
            for each tt-int-loc-entr no-lock:
               find int-loc-entr exclusive-lock
                  where int-loc-entr.nome-abrev  = tt-int-loc-entr.nome-abrev
                    and int-loc-entr.cod-entrega = tt-int-loc-entr.cod-entrega no-error.

               if not available (int-loc-entr) then do:
                  create int-loc-entr.
                  assign int-loc-entr.nome-abrev  = tt-int-loc-entr.nome-abrev
                         int-loc-entr.cod-entrega = tt-int-loc-entr.cod-entrega.
               end.

               assign int-loc-entr.endereco-completo = tt-int-loc-entr.endereco-completo.
            end.
            
            IF l-log = YES THEN
                 PUT "espdp044 13 " ttconta.contacodigo SKIP.

            /** aqui v∆o os demais dados da tabela int-emitente-b2c **/
            assign int-emitente-b2c.ContaCodigo      = ttConta.ContaCodigo
                   int-emitente-b2c.UsuarioCodigo    = ttUsuario.UsuarioCodigo
                   int-emitente-b2c.LogOn            = ttUsuario.LogOn
                   int-emitente-b2c.NewsLetter       = ttUsuario.NewsLetter
                   int-emitente-b2c.Sexo             = ttUsuario.Sexo
                   int-emitente-b2c.UsuarioStatus    = ttUsuario.UsuarioStatus
                   int-emitente-b2c.ParceiroCodigo   = int(ttConta.ParceiroCodigo)
                   int-emitente-b2c.ValorGasto1Ano   = decimal(replace(replace(ttConta.ValorGasto1Ano,",",""),".","")) / 100
                   int-emitente-b2c.ValorGasto90Dias = decimal(replace(replace(ttConta.ValorGasto90Dias,",",""),".","")) / 100
                   int-emitente-b2c.ValorGasto30Dias = decimal(replace(replace(ttConta.ValorGasto30Dias,",",""),".","")) / 100
                   int-emitente-b2c.Ranking          = int(ttConta.Ranking)
                   int-emitente-b2c.DataNascimento   = ttConta.DataNascimento
                   int-emitente-b2c.ContaStatus      = ttConta.ContaStatus
                   int-emitente-b2c.DataInclusao     = ttConta.DataInclusao
                   int-emitente-b2c.Desconto         = decimal(replace(replace(ttConta.Desconto,",",""),".","")) / 100
                   int-emitente-b2c.LimiteCredito    = decimal(replace(replace(ttConta.LimiteCredito,",",""),".","")) / 100.
            
            /** Valida emitente na IKEDA ***/
            run pi-acompanhar in h-acomp ('Confirmando recebimento do usu†rio').

                IF l-log = YES THEN
                     PUT "espdp044 13 a" ttconta.contacodigo SKIP.


            run validarBaixa in hWebService (input int(ttUsuario.UsuarioCodigo),
                                             input string(tt-emitente.cod-emitente),
                                             output iStatus,
                                             output cStatus).
       
/*             if (iStatus <> 1) then do:                                                                                                                           */
/*                run incluiMsgErro ('CNPJ/CPF ' + tt-emitente.cgc + ', Erro na confirmaá∆o de importaá∆o do cliente ' + ttUsuario.UsuarioCodigo + ': ' + cStatus). */
/*                undo usuarioblk, next usuarioblk.                                                                                                                 */
/*             end.                                                                                                                                                 */

            /** Tarefa 5863: aviso de quando Ç cadastrado cliente PJ **/
            if (i-natureza = 2) and (i-ind-tipo-movto = 1) then
               run incluiMsgErro('Cliente pessoa jur°dica cadastrado: ' + tt-emitente.nome-emit + '(' + string(tt-emitente.cod-emitente) + ')').

            /** Validaá∆o do endereáo **/
            run cdp/cdapi704.p persistent set h-cdapi704.
            run pi-trata-endereco in h-cdapi704 (input tt-emitente.endereco, output c-rua, output c-nro, output c-comp).
            delete procedure h-cdapi704.

            if (c-nro = '') then
               run incluiMsgErro in this-procedure ('CNPJ/CPF ' + tt-emitente.cgc + ', Erro: cliente com endereáo sem n£mero, favor informar o n£mero no endereáo do cliente ' + string(tt-emitente.cod-emitente) + ' no CD0704').

                   IF l-log = YES THEN
                        PUT "espdp044 14 " ttconta.contacodigo SKIP.


            /** Tarefa 9087: ativar cliente quando PF **/
            if (i-natureza = 1) then do:
               find int-emitente exclusive-lock
                  where int-emitente.cod-emitente = tt-emitente.cod-emitente no-error.
               if available (int-emitente) then do:
                  assign int-emitente.id-ativo = yes.
                  release int-emitente.
               end.
            end.

            if (i-ind-tipo-movto = 1) then do:
               find int-emitente exclusive-lock
                  where int-emitente.cod-emitente = tt-emitente.cod-emitente no-error.
               if available (int-emitente) then do:
                  assign int-emitente.cod-gr-cob = 8.
                  release int-emitente.
               end.
            end.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = tt-emitente.cod-emitente:

                //apenas para n∆o dar erro de raw-transfer apos vers∆o 12.1.25
                empty temp-table tt-emitente-raw.
                CREATE tt-emitente-raw.
                BUFFER-COPY emitente TO tt-emitente-raw.
                //

                //RAW-TRANSFER emitente TO raw-param.
                RAW-TRANSFER tt-emitente-raw TO raw-param.
                {esp/esb/esesb006.i 'msg0072' 'espdp044rpa' 'emitente'}    
            END.

         end.
      end. /** for each ttConta **/
   end. /** if iStatus = 1 **/
   IF l-log = YES THEN
        PUT "espdp044 15 " ttconta.contacodigo SKIP.

   run desconecta in hWebService.
   delete object hWebService.

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
