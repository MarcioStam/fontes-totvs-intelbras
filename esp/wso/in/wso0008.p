/*********************************************************************************************
 CRIA€ÇO DO CLIENTE NO TOTVS 
*********************************************************************************************/

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEFINE TEMP-TABLE tt-atualiza-int-emitente NO-UNDO
       FIELD cod-emitente          LIKE int-emitente.cod-emitente
       FIELD ind-forma-tributo     like int-emitente.ind-forma-tributo   
       field ind-vendas-alc        like int-emitente.ind-vendas-alc      
       field dt-vcto-concessao     like int-emitente.dt-vcto-concessao   
       field ind-participa-canais  like int-emitente.ind-participa-canais
       field id-ativo              like int-emitente.id-ativo            
       field cod-gr-cob            like int-emitente.cod-gr-cob          
       field logradouro            like int-emitente.logradouro          
       field numero                like int-emitente.numero              
       field complemento           like int-emitente.complemento         
       field logradouro-cob        like int-emitente.logradouro-cob      
       field numero-cob            like int-emitente.numero-cob          
       field complemento-cob       like int-emitente.complemento-cob 
       FIELD guid-subclass         LIKE int-emitente.guid-subclass
       FIELD dispositivo-legal     LIKE int-emitente.dispositivo-legal.
       

DEFINE TEMP-TABLE tt-int-emitente-canal NO-UNDO
       FIELD cod-emitente                LIKE int-emitente-canal.cod-emitente       
       FIELD cod-emitente-matriz         LIKE int-emitente-canal.cod-emitente-matriz
       FIELD guid-filial                 LIKE int-emitente-canal.guid-filial   
       field DescricaoConta              like int-emitente-canal.DescricaoConta             
       field TipoRelacao                 like int-emitente-canal.TipoRelacao                
       field DataConstituicao            like int-emitente-canal.DataConstituicao           
       field DistribuicaoUnicaFonteRecei like int-emitente-canal.DistribuicaoUnicaFonteRecei
       field NivelPosVenda               like int-emitente-canal.NivelPosVenda              
       field TipoConta                   like int-emitente-canal.TipoConta                  
       field TipoEndereco                like int-emitente-canal.TipoEndereco               
       field IntegraTrigger              like int-emitente-canal.IntegraTrigger             
       field AssistenciaTecnica          like int-emitente-canal.AssistenciaTecnica    
       FIELD TipoConstituicao            LIKE int-emitente-canal.TipoConstituicao
       FIELD OrigemConta                 LIKE int-emitente-canal.OrigemConta
       field PossuiEstruturaCompleta     like int-emitente-canal.PossuiEstruturaCompleta
       field PossuiFiliais               like int-emitente-canal.PossuiFiliais          
       field StatusIntegracaoSefaz       like int-emitente-canal.StatusIntegracaoSefaz  
       field LimiteCredito               like int-emitente-canal.LimiteCredito          
       field DataLimiteCredito           like int-emitente-canal.DataLimiteCredito      
       field CNAE                        like int-emitente-canal.CNAE                   
       field RegimeApuracao              like int-emitente-canal.RegimeApuracao  
       FIELD Categoria                   LIKE int-emitente-canal.Categoria   
       field Estado                      like int-emitente-canal.Estado  
       field Pais                        like int-emitente-canal.Pais    
       field Telefone                    like int-emitente-canal.Telefone
       field NomeEnderecoCob             like int-emitente-canal.NomeEnderecoCob
       field EstadoCob                   like int-emitente-canal.EstadoCob      
       field PaisCob                     like int-emitente-canal.PaisCob        
       field NomeContatoCob              like int-emitente-canal.NomeContatoCob .

/*DEFINE TEMP-TABLE tt-loc-entr NO-UNDO
       FIELD nome-abrev    like loc-entr.nome-abrev   
       FIELD cod-entrega   like loc-entr.cod-entrega  
       FIELD endereco      like loc-entr.endereco     
       field bairro        like loc-entr.bairro       
       field cidade        like loc-entr.cidade       
       field estado        like loc-entr.estado       
       field cep           like loc-entr.cep          
       field pais          like loc-entr.pais         
       field cgc           like loc-entr.cgc          
       field ins-estadual  like loc-entr.ins-estadual 
       field nom-cidad-cif like loc-entr.nom-cidad-cif. */

DEFINE TEMP-TABLE tt-loc-entr NO-UNDO LIKE loc-entr.

DEFINE TEMP-TABLE tt-int-loc-entr NO-UNDO
       FIELD nome-abrev         like int-loc-entr.nome-abrev       
       field cod-entrega        like int-loc-entr.cod-entrega      
       field endereco-completo  like int-loc-entr.endereco-completo
       field logradouro         like int-loc-entr.logradouro       
       field numero             like int-loc-entr.numero           
       field complemento        like int-loc-entr.complemento .


{esp/wso/IN/wso0008.i}

{include/i-freeac.i}  

DEFINE VARIABLE c-arquivo-log              AS CHAR FORMAT 'x(90)' NO-UNDO.

DEFINE INPUT-OUTPUT param externalId       AS CHARACTER   NO-UNDO.
DEFINE input param c-nome                  AS CHARACTER   NO-UNDO.
DEFINE input param c-nome-fantasia         AS CHARACTER   NO-UNDO.
DEFINE input param c-natureza              AS CHARACTER   NO-UNDO. 
DEFINE input param c-documento             AS CHAR        NO-UNDO.
DEFINE input param i-cod-emitente          AS INTEGER     NO-UNDO.
DEFINE input param c-nome-abrev            AS CHARACTER   NO-UNDO.
DEFINE input param c-email                 AS CHARACTER   NO-UNDO.
DEFINE input param idi-matriz-filial       AS CHARACTER   NO-UNDO.
DEFINE input param c-matriz                AS CHARACTER   NO-UNDO.
DEFINE input param c-registro-conta        AS CHARACTER   NO-UNDO.
DEFINE input param c-inscricao-municipal   AS CHARACTER   NO-UNDO.
DEFINE input param c-inscricao-estadual    AS CHARACTER   NO-UNDO.
DEFINE input param c-cnae                  AS CHARACTER   NO-UNDO. 
DEFINE input param data-constituicao       AS CHAR        NO-UNDO.
DEFINE input param c-key-account           AS CHARACTER   NO-UNDO.
DEFINE input param c-telefone              AS CHARACTER   NO-UNDO.
DEFINE input param c-telefone2             AS CHARACTER   NO-UNDO.
DEFINE input param c-grupo-cliente         AS CHARACTER   NO-UNDO.
DEFINE input param c-subgrupo              AS CHARACTER   NO-UNDO.
DEFINE input param c-categoria-pci         AS CHARACTER   NO-UNDO.
DEFINE input param idi-participa-pci       AS LOGICAL     NO-UNDO.
DEFINE input param c-codsuframa            AS CHARACTER   NO-UNDO.
DEFINE input param idi-contrib-icms        AS LOGICAL     NO-UNDO.
DEFINE input param data-concessao          AS CHAR        NO-UNDO.
DEFINE input param c-ins-aux-sub-trib      AS CHARACTER   NO-UNDO.
DEFINE input param c-forma-tributacao      AS CHARACTER   NO-UNDO.
DEFINE input param c-regime-apuracao       AS CHARACTER   NO-UNDO.
DEFINE input param idi-area-livre-com      AS LOGICAL     NO-UNDO.
DEFINE input param i-cod-grupo-cob         AS INTEGER     NO-UNDO.
DEFINE input param c-moeda                 AS CHARACTER   NO-UNDO.
DEFINE input param de-limite-credito       AS DECIMAL     NO-UNDO.
DEFINE input param c-bairro-cob            AS CHARACTER   NO-UNDO.
DEFINE input param c-cep-cob               AS CHARACTER   NO-UNDO.
DEFINE input param c-compl-cob             AS CHARACTER   NO-UNDO.
DEFINE input param c-endereco-cob          AS CHARACTER   NO-UNDO.
DEFINE input param c-cidade-cob            AS CHARACTER   NO-UNDO.
DEFINE input param c-numero-cob            AS CHARACTER   NO-UNDO.
DEFINE input param c-uf-cob                AS CHARACTER   NO-UNDO.
DEFINE input param c-pais-cob              AS CHARACTER   NO-UNDO.
DEFINE input param c-bairro-entr           AS CHARACTER   NO-UNDO.
DEFINE input param c-cep-entr              AS CHARACTER   NO-UNDO.
DEFINE input param c-compl-entr            AS CHARACTER   NO-UNDO.
DEFINE input param c-endereco-entr         AS CHARACTER   NO-UNDO.
DEFINE input param c-cidade-entr           AS CHARACTER   NO-UNDO.
DEFINE input param c-numero-entr           AS CHARACTER   NO-UNDO.
DEFINE input param c-uf-entr               AS CHARACTER   NO-UNDO.
DEFINE input param c-pais-entr             AS CHARACTER   NO-UNDO.
DEFINE input param idi-ativo               AS LOGICAL     NO-UNDO.
DEFINE input param c-produtor-rural        AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-observacao-cli        AS CHARACTER   NO-UNDO.
    
DEFINE OUTPUT PARAM customercode           AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAM shortname              AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.


DEFINE VARIABLE p-prox-emitente        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ind-tipo-movto       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-forma-tributo-antiga AS INTEGER     NO-UNDO.

DEFINE BUFFER b-emit-matriz           FOR emitente.
DEFINE BUFFER b-emitente              FOR emitente.
DEFINE BUFFER b-matriz                FOR int-emitente.

DEFINE VARIABLE h-cdapi704      AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-rua           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nro           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-comp          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_log_grupo_cob AS LOG        NO-UNDO.


// VERIFICA BASE LOGADA 
DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.
DEF VAR I-SEQ        AS INT    NO-UNDO.
def var l-producao   AS LOG    NO-UNDO.
DEF VAR v_return     AS CHAR   NO-UNDO.
DEF VAR v_cod_erro   AS CHAR   NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES
           i-seq      = 1.
ELSE
    ASSIGN l-producao = NO
           i-seq      = 2.

EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'wso0008' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:

    IF OPSYS = 'UNIX' THEN    
       ASSIGN c-arquivo-log = '/usr/wrk/totvs/UNIX_wso0008_NEWCLI_' + c-documento + "_".
    ELSE
       ASSIGN c-arquivo-log = '\\erpapp\spool\totvs\WIN_wso0008_NEWCLI_' + c-documento + "_".

    IF l-producao THEN
       ASSIGN c-arquivo-log = c-arquivo-log + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log = c-arquivo-log + 'HOMOL.txt'.
END.

   
RUN pi-gerar-dados-extrato (" INICIO " + CHR(13) + CHR(13)).

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

   EMPTY TEMP-TABLE tt-erro.
   EMPTY TEMP-TABLE TT-ERROS-GERAL.
   EMPTY TEMP-TABLE tt-atualiza-int-emitente.
   EMPTY TEMP-TABLE tt-int-emitente-canal.
   EMPTY TEMP-TABLE tt-loc-entr.
   EMPTY TEMP-TABLE tt-int-loc-entr.

   ASSIGN v_return   = ""
          v_cod_erro = "".
   
   ERROR-STATUS:ERROR = NO.

   RUN pi-gerar-dados-extrato (">> INICIO COD EMITENTE " + STRING(i-cod-emitente)).
   RUN pi-gerar-dados-extrato (">> INICIO CGC EMITENTE " + STRING(c-documento)).

   RUN pi-valida-campos. 

   RUN pi-gerar-dados-extrato (">> PASSOU A TROCA DE VALORES DOS CAMPOS TEXTOS").

   IF i-cod-emitente > 0 THEN
      find first emitente
           where emitente.cod-emitente = i-cod-emitente no-lock no-error.
   
  if NOT avail emitente then DO:
      RUN pi-gerar-dados-extrato (">> CLIENTE NAO DISPONIVEL EMITENTE ZERO -> " + string(i-cod-emitente)).
     //se ja existir fornecedor
      FIND FIRST emitente USE-INDEX cgc NO-LOCK  
           WHERE emitente.cgc       = c-documento 
             AND emitente.identific >= 2 NO-ERROR.
      IF AVAIL emitente THEN DO:

          RUN pi-gerar-dados-extrato (">> ENCONTROU FORNECEDOR COM O CGC: " + emitente.cgc + "CD EMIT:  " + STRING(EMITENTE.COD-EMITENTE) ).

          ASSIGN P-PROX-EMITENTE  = emitente.cod-emitente
                 i-ind-tipo-movto = 2. // Atualizacao
      END.
      ELSE DO:
         FIND LAST emitente NO-LOCK NO-ERROR.
         IF AVAILABLE emitente THEN DO:
            run cdp/cd9960.p (OUTPUT p-prox-emitente).
            ASSIGN i-ind-tipo-movto = 1. // Criacao.
         END.
      END.
  END.
  ELSE
     ASSIGN P-PROX-EMITENTE  = i-cod-emitente
            i-ind-tipo-movto = 2. // Atualizacao

  RUN pi-gerar-dados-extrato (">> CODIGO DO CLIENTE" + STRING(P-PROX-EMITENTE) + ' ' + STRING(I-IND-TIPO-MOVTO)). 

  
  IF i-ind-tipo-movto = 1 THEN DO:   // cria novo cliente 

      /* Procurar pela matriz da raiz do cnpj - M2212-185 */
      FIND FIRST b-emit-matriz USE-INDEX cgc NO-LOCK  
           WHERE b-emit-matriz.cgc BEGINS SUBSTRING(c-documento,1,8)
           AND   b-emit-matriz.natureza >= 2 NO-ERROR.

      IF  AVAIL b-emit-matriz THEN
          ASSIGN c-matriz = b-emit-matriz.nome-matriz.
      ELSE
          ASSIGN c-matriz = c-nome-abrev.


      FIND FIRST gr-cli 
           WHERE gr-cli.cod-gr-cli = INT(c-grupo-cliente) NO-LOCK NO-ERROR.

      IF NOT AVAIL gr-cli THEN DO:

         RUN pi-erro (INPUT 412,
                      INPUT "ATRIBUTO_REQUERIDO",
                      INPUT "Atributo requerido clientGroup: " + c-grupo-cliente ).
         //RUN pi-erro (INPUT "Erro: Grupo de Cliente " + c-grupo-cliente + " NÆo cadastrado.").
         //UNDO blk_principal, LEAVE blk_principal.
      END.

      
      FIND FIRST emitente WHERE emitente.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.

      IF AVAIL emitente THEN DO:

         RUN pi-erro (INPUT 412,
                      INPUT "ERRO_DE_VALIDACAO",
                      INPUT "Ja existe registro shortName: " + c-nome-abrev ).

         RUN pi-gerar-dados-extrato (INPUT "Ja existe registro shortName: " + c-nome-abrev).

         //RUN pi-erro (INPUT "Erro: Nome Abreviado " + c-nome-abrev + " ja cadastrado.").
         //UNDO blk_principal, LEAVE blk_principal.
      END.
      

      CREATE tt-cliente-valid.
      ASSIGN tt-cliente-valid.cod-emitente   = p-prox-emitente
             tt-cliente-valid.ind-tipo-movto = 1
             tt-cliente-valid.nome-abrev     = c-nome-abrev
             tt-cliente-valid.nome-emit      = c-nome
             tt-cliente-valid.nome-matriz    = c-matriz
             tt-cliente-valid.nom-fantasia   = c-nome-fantasia
             tt-cliente-valid.cgc            = c-documento
             tt-cliente-valid.ins-municipal  = c-inscricao-municipal
             tt-cliente-valid.ins-estadual   = c-inscricao-estadual 
             tt-cliente-valid.modalidade     = 6
             tt-cliente-valid.categoria      = gr-cli.categoria
             tt-cliente-valid.bonIFicacao    = gr-cli.bonIFicacao
             tt-cliente-valid.istr           = 0
             tt-cliente-valid.ins-banc[1]    = 7
             tt-cliente-valid.ins-banc[2]    = 0
             tt-cliente-valid.tp-desp-padrao = 0
             tt-cliente-valid.cod-gr-forn    = 0
             tt-cliente-valid.identific      = 3 /*Sempre tem que ser ambos por causa do pagamento a forn. no finaceiro*/
             tt-cliente-valid.perc-fat-ped   = gr-cli.perc-fat-ped
             tt-cliente-valid.portador       = gr-cli.portador
             tt-cliente-valid.modalidade     = gr-cli.modalidade
             tt-cliente-valid.ind-fat-par    = gr-cli.ind-fat-par
             tt-cliente-valid.ind-apr-cred   = gr-cli.ind-apr-cred
             tt-cliente-valid.agencia        = '0000000'
             tt-cliente-valid.per-max-canc   = gr-cli.per-max-canc
             tt-cliente-valid.emite-etiq     = no /** Emite Etiqueta **/
             tt-cliente-valid.tr-ar-valor    = 1 /** NFE 1-TRUNca 2-Arredonda **/
             tt-cliente-valid.gera-ad        = no /** Gera Aviso Debito **/
             tt-cliente-valid.bx-acatada     = 0
             tt-cliente-valid.conta-corren   = '000000000000'
             tt-cliente-valid.nr-copias-ped  = 1
             tt-cliente-valid.cod-cacex      = ''
             tt-cliente-valid.gera-dIFer     = 0
             tt-cliente-valid.nr-tabpre      = gr-cli.nr-tabpre
             tt-cliente-valid.ind-aval       = 3
             tt-cliente-valid.user-libcre    = '*'
             tt-cliente-valid.ven-domingo    = 1 /** Vencto Domingo 1-Prorroga 2-Antecipa 3-Mantem **/
             tt-cliente-valid.ven-sabado     = 1 /** Vencto Sabado 1-Prorroga 2-Antecipa 3-Mantem **/
             tt-cliente-valid.cx-post-cob    = ''
             tt-cliente-valid.cod-banco      = 0
             tt-cliente-valid.prox-ad        = 0
             tt-cliente-valid.nr-peratr      = gr-cli.nr-peratr
             tt-cliente-valid.nr-mesina      = gr-cli.nr-mesina
             tt-cliente-valid.cod-mensagem   = 0
             tt-cliente-valid.forn-exp       = no
             tt-cliente-valid.tp-qt-prg      = 1 /** Tp Qtde 1-Lðquida 2-Acumulada **/
             tt-cliente-valid.ind-atraso     = 1 /** Atraso 1-Nao Informa 2-Informa 3-Sumaria **/
             tt-cliente-valid.ind-div-atraso = 1 /** Atraso 1-Nao Aceita 2-Ignora 3-Assume Situacao Inferior 4-Assume Qtde Inferior **/
             tt-cliente-valid.ind-dIF-atrs-1 = 1 /** Inf > Calc 1-Nao Aceita 2-Ignora 3-Adiciona Atraso + Recente **/
             tt-cliente-valid.ind-dIF-atrs-2 = 1 /** Inf < Calc 1-Nao Aceita 2-Ignora 3-Adiciona Atraso + Antigo **/
             tt-cliente-valid.esp-pd-vENDa   = 1
             tt-cliente-valid.resumo-mp      = 2 /** Resumo Multiplanta 1-Calculado 2-£ Calcular **/
             tt-cliente-valid.ind-tipo-movto = 1 /** 1-Incluao 2-Alteracao **/
             tt-cliente-valid.tip-cob-desp   = 2 /* Rateia despesas entre todas as duplicatas */
             tt-cliente-valid.ind-lib-estoque = YES
             tt-cliente-valid.recebe-inf-sci  = YES
         
   // Dados fiscais
            tt-cliente-valid.contrib-icms                 = idi-contrib-icms  
            tt-cliente-valid.log-calcula-pis-cofins-unid  = NO
            tt-cliente-valid.log-nf-eletro                = YES                  
            tt-cliente-valid.cod-suframa                  = c-codsuframa              
            tt-cliente-valid.insc-subs-trib               = c-ins-aux-sub-trib.
       
      RUN pi-gerar-dados-extrato (">> NOMES ABREVIADOS  " +  tt-cliente-valid.nome-matri + '  ' +  tt-cliente-valid.nome-abrev).

      FIND FIRST b-emitente NO-LOCK
             WHERE b-emitente.nome-abrev  = tt-cliente-valid.nome-matriz
               AND b-emitente.nome-abrev <> tt-cliente-valid.nome-abrev NO-ERROR.

        IF AVAIL b-emitente THEN DO:
            ASSIGN tt-cliente-valid.port-prefer = b-emitente.port-prefer
                   tt-cliente-valid.mod-prefer  = b-emitente.mod-prefer.
        END.

        ASSIGN tt-cliente-valid.observacoes    = 'Cadastro inserido pela Plataforma Salesforce em ' + string(today,"99/99/9999") + '.~r' + tt-cliente-valid.observacoes.

  END.
  ELSE DO:  // atualiza cliente existente na base de dados 

        CREATE tt-cliente-valid.
        BUFFER-COPY emitente TO tt-cliente-valid.
        ASSIGN tt-cliente-valid.ind-tipo-movto = 2
               tt-cliente-valid.identific = 3. //marcar como ambos
  END.

   /*** CRIACAO OU ALTERACAO DO CLIENTE - CAMPOS COMUNS ***/

  RUN pi-gerar-dados-extrato (">> VALIDACAO CEP  " +  C-CEP-ENTR).

  RUN pi-gerar-dados-extrato (">> VALIDACAO CEP entrega - c-uf-entr:   " +  c-uf-entr).
  RUN pi-gerar-dados-extrato (">> VALIDACAO CEP cobranca  c-uf-cob:   " +  c-uf-cob).
  RUN pi-gerar-dados-extrato (">> VALIDACAO CEP pais  c-pais-entr:   " +  c-pais-entr).

 /* IF NOT CAN-FIND(first cep
                  WHERE cep.cep = int(c-cep-entr)) THEN do:

      RUN pi-erro (INPUT 412,
                   INPUT "ATRIBUTO_REQUERIDO",
                   INPUT "Atributo requerido deliveryCep: " + '"' + c-cep-entr + '"').
     CREATE tt-erro.
     ASSIGN tt-erro.mensagem = STRING('Cliente CNPJ/CPF ' + tt-cliente-valid.cgc +  ', Erro: CEP ' + c-cep-entr + ' informado nao existe no cadastro dos Correios').

     RETURN "NOK".
  END. 

  FIND FIRST cep 
       WHERE cep.cep = int(c-cep-entr) NO-LOCK NO-ERROR.
  IF AVAIL CEP THEN
     ASSIGN c-uf-entr = cep.uf.

  FIND FIRST cep 
       WHERE cep.cep = int(c-cep-cob) NO-LOCK NO-ERROR.
   IF AVAIL CEP THEN
      ASSIGN c-uf-cob = cep.uf. */

   FIND FIRST mgcad.pais
        WHERE mgcad.pais.nome-compl = c-pais-entr NO-LOCK NO-ERROR.

      
   FIND FIRST unid-feder 
        WHERE unid-feder.pais     = pais.nome-pais
          AND unid-feder.estado   = c-uf-cob NO-LOCK NO-ERROR.

   IF AVAIL unid-feder THEN
      ASSIGN c-pais-entr  = unid-feder.pais
             c-pais-cob   = unid-feder.pais.

   IF  tt-cliente-valid.identific = 2 THEN 
       ASSIGN tt-cliente-valid.cod-gr-forn    = 3 /* Acordado com o financeiro e Fabiano FIXAR grupo de cliente como 3 */ 
              tt-cliente-valid.tp-desp-padrao = 8. 

   /* caso seja "ambos" mas esteja com o grupo de fornecedor */
   IF  tt-cliente-valid.identific       = 3 THEN DO:
       IF  tt-cliente-valid.cod-gr-forn = 0 THEN
           ASSIGN tt-cliente-valid.cod-gr-forn    = 3.
   
       IF  tt-cliente-valid.tp-desp-padrao = 0 THEN
           ASSIGN tt-cliente-valid.tp-desp-padrao = 8.
   END.
   

   FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = p-prox-emitente NO-ERROR.
   IF NOT AVAIL int-emitente THEN DO:
      CREATE int-emitente.
      ASSIGN int-emitente.cod-emitente  = p-prox-emitente
             int-emitente.guid-subclass = c-subgrupo.

      RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO  " ).
   END.
   FIND CURRENT int-emitente NO-LOCK NO-ERROR.

    /*criar tabela temporaria para armazenar dados da int-emitente para atualizar uma unica vez*/
   IF i-ind-tipo-movto = 1 THEN DO:
      FIND FIRST tt-atualiza-int-emitente 
           WHERE tt-atualiza-int-emitente.cod-emitente = p-prox-emitente NO-ERROR.
      IF NOT AVAIL tt-atualiza-int-emitente THEN DO:
          CREATE tt-atualiza-int-emitente.
          ASSIGN tt-atualiza-int-emitente.cod-emitente  = p-prox-emitente
                 tt-atualiza-int-emitente.guid-subclass = c-subgrupo.
      END.
   END.
   ELSE DO:
        IF AVAIL int-emitente THEN DO:
           FIND FIRST tt-atualiza-int-emitente 
                WHERE tt-atualiza-int-emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
           IF NOT AVAIL tt-atualiza-int-emitente THEN DO:
               CREATE tt-atualiza-int-emitente.
               BUFFER-COPY int-emitente TO tt-atualiza-int-emitente.
           END.
        END.
   END.

   IF AVAIL int-emitente THEN
       ASSIGN i-forma-tributo-antiga = int-emitente.ind-forma-tributo.

   /*** FEITO ISTO PARA REMOVER ACENTUA€AO QUE VEM DO SF ***/
   IF c-forma-tributacao BEGINS 'n':U AND 
      c-forma-tributacao <> "Nenhum" THEN
      ASSIGN c-forma-tributacao = 'Nao Cumulativo'.

   RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO1 c-registro-conta - " + c-registro-conta ).
   RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO1 tt-atualiza-int-emitente.i-cod-grupo-cob - " + string(tt-atualiza-int-emitente.cod-gr-cob) ).
   RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO1 tt-atualiza-int-emitente.ind-forma-tributo - " + string(tt-atualiza-int-emitente.ind-forma-tributo) ).
   RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO1 participa pci - " + string(idi-participa-pci) ).
   RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO1 area livre comercio - " + string(idi-area-livre-com) ).

   IF  i-ind-tipo-movto = 1 OR c-registro-conta <> "Plataforma Solar" THEN DO: //marcios bloco pra nao alterar quando a origem for solar

       CASE c-forma-tributacao :
            WHEN 'Nao Cumulativo'               THEN ASSIGN tt-atualiza-int-emitente.ind-forma-tributo = 1. 
            WHEN 'Cumulativo todo ou em parte'  THEN ASSIGN tt-atualiza-int-emitente.ind-forma-tributo = 2. 
            WHEN 'Simples'                      THEN ASSIGN tt-atualiza-int-emitente.ind-forma-tributo = 3. 
            WHEN 'Nenhum'                       THEN ASSIGN tt-atualiza-int-emitente.ind-forma-tributo = 4. 
            WHEN 'Isento'                       THEN ASSIGN tt-atualiza-int-emitente.ind-forma-tributo = 5. 
       END CASE. 
       
       ASSIGN tt-atualiza-int-emitente.ind-vendas-alc = IF idi-area-livre-com = YES THEN 1 ELSE 0.

       ASSIGN tt-atualiza-int-emitente.ind-participa-canais = IF idi-participa-pci  = YES THEN 993520001 ELSE 993520000  .

       ASSIGN tt-atualiza-int-emitente.cod-gr-cob    = i-cod-grupo-cob.
       ASSIGN tt-atualiza-int-emitente.guid-subclass = c-subgrupo.

       ASSIGN tt-cliente-valid.cod-gr-cli = int(c-grupo-cliente).

       RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO c-registro-conta22 - " + c-registro-conta ).
       RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO tt-atualiza-int-emitente.ind-forma-tributo - " + string(tt-atualiza-int-emitente.ind-forma-tributo) ).
       RUN pi-gerar-dados-extrato (">> INT-EMITENTE CRIACAO tt-atualiza-int-emitente.i-cod-grupo-cob - " + string(tt-atualiza-int-emitente.cod-gr-cob) ).

   END.

   // valida se houve altera»Æo na forma de tributa»Æo.
   IF AVAILABLE int-emitente AND /*int-emitente.ind-forma-tributo*/ tt-atualiza-int-emitente.ind-forma-tributo <> i-forma-tributo-antiga THEN DO:
      FIND FIRST int-emitente-trib NO-LOCK
           WHERE int-emitente-trib.raiz-cnpj = SUBSTRING(tt-cliente-valid.cgc,1,8) NO-ERROR.
      IF AVAIL int-emitente-trib THEN DO:
         IF int-emitente-trib.ind-declaracao = YES THEN DO: 
            RUN pi-erro (INPUT 412,
                         INPUT "ERRO_DE_VALIDACAO",
                         INPUT "Cliente " + tt-cliente-valid.nome-abrev + " - Declara‡Æo j  entregue. Verificar com o grupo tributario.").
            //RUN pi-erro (INPUT "Erro: Cliente " + emitente.nome-abrev + " - Declara»Æo jÿ entregue. Verificar com o grupo tributario.").
            //UNDO blk_principal, LEAVE blk_principal.
         END. 
      END. 
   END. 


   ASSIGN /*int-emitente.ind-vendas-alc          = IF idi-area-livre-com = YES THEN 1 ELSE 0
          int-emitente.dt-vcto-concessao       = IF data-concessao <> '' THEN DATE ( string(substr(data-concessao,9,2)) + STRING(substr(data-concessao,6,2)) + string(substr(data-concessao,1,4))) ELSE ?
          int-emitente.ind-participa-canais    = IF idi-participa-pci  = YES THEN 993520001 ELSE 993520000  
          int-emitente.id-ativo                = idi-ativo */
         // tt-atualiza-int-emitente.ind-vendas-alc       = IF idi-area-livre-com = YES THEN 1 ELSE 0
          tt-atualiza-int-emitente.dt-vcto-concessao    = IF data-concessao <> '' THEN DATE ( string(substr(data-concessao,9,2)) + STRING(substr(data-concessao,6,2)) + string(substr(data-concessao,1,4))) ELSE ?
          //tt-atualiza-int-emitente.ind-participa-canais = IF idi-participa-pci  = YES THEN 993520001 ELSE 993520000  
          tt-atualiza-int-emitente.id-ativo             = idi-ativo
          tt-atualiza-int-emitente.dispositivo-legal    = c-observacao-cli
          tt-cliente-valid.moeda-libcre                 = INT(c-moeda)
          tt-cliente-valid.portador                     = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN 999      ELSE tt-cliente-valid.portador
          tt-cliente-valid.cod-entrega                  = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN 'PadrÆo' ELSE tt-cliente-valid.cod-entrega
          tt-cliente-valid.cgc-cob                      = c-documento
          tt-cliente-valid.end-cobranca                 = tt-cliente-valid.cod-emitente
          tt-cliente-valid.idi-tributac-pis             = IF tt-cliente-valid.contrib-icms = YES THEN 1 ELSE 2
          tt-cliente-valid.idi-tributac-cofins          = IF tt-cliente-valid.contrib-icms = YES THEN 1 ELSE 2
          tt-cliente-valid.data-implant                 = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN TODAY    ELSE tt-cliente-valid.data-implant
          tt-cliente-valid.telefone[1]                  = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone,"/",""),"-",""),"(",""),")","")," ","")                      
          tt-cliente-valid.telefone[2]                  = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone2,"/",""),"-",""),"(",""),")","")," ","")              
          tt-cliente-valid.e-mail                       = c-Email                       
          tt-cliente-valid.cod-rep                      = int(c-key-account) 
          //tt-cliente-valid.cod-gr-cli                   = int(c-grupo-cliente)   marcios
          tt-cliente-valid.modalidade-ap                = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN 6 ELSE tt-cliente-valid.modalidade-ap 
          tt-cliente-valid.portador-ap                  = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN 999 ELSE tt-cliente-valid.portador-ap  
          tt-cliente-valid.ind-abrange-aval             = 2
          tt-cliente-valid.tip-cob-desp                 = 2
          tt-cliente-valid.ind-aval                     = 3
          tt-cliente-valid.cod-transp                   = IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN 0 /*Retira*/ ELSE tt-cliente-valid.cod-transp
          tt-cliente-valid.ven-domingo                  = 1 /** Vencto Domingo 1-Prorroga 2-Antecipa 3-Mantým **/
          tt-cliente-valid.ven-sabado                   = 1 /** Vencto S˜bado 1-Prorroga 2-Antecipa 3-Mantým **/
          tt-cliente-valid.atividade                    = IF c-produtor-rural = "SIM" THEN "Rural" ELSE ""                    
          tt-cliente-valid.contrib-icms                 = IF c-produtor-rural = "SIM" THEN idi-contrib-icms ELSE idi-contrib-icms
          tt-cliente-valid.ins-estadual                 = IF c-produtor-rural = "SIM" THEN c-inscricao-estadual ELSE c-inscricao-estadual .
      //    tt-cliente-valid.identific                    = 3 /*Sempre tem que ser ambos por causa do pagamento a forn. no finaceiro*/.

    //campos que devem passar por alteracao
    ASSIGN tt-cliente-valid.cod-suframa                 = c-codsuframa              
           tt-cliente-valid.insc-subs-trib              = c-ins-aux-sub-trib
           tt-cliente-valid.nome-emit                   = c-nome
           tt-cliente-valid.nom-fantasia                = c-nome-fantasia
           tt-cliente-valid.ins-municipal               = c-inscricao-municipal.

   RUN pi-gerar-dados-extrato (">> atualiza produtor Rural: " + STRING(tt-cliente-valid.atividade) + " " + STRING(tt-cliente-valid.contrib-icms) + " " + STRING(tt-cliente-valid.ins-estadual)).            

   FIND FIRST grupo-canais-clientes
        WHERE grupo-canais-clientes.cod-gr-cli = tt-cliente-valid.cod-gr-cli NO-LOCK NO-ERROR.

   IF NOT AVAIL grupo-canais-clientes THEN DO:
      RUN pi-erro (INPUT 412,
                   INPUT "ERRO_DE_VALIDACAO",
                   INPUT "Grupo de Cliente " + string(tt-cliente-valid.cod-gr-cli) + " NÆo vinculado a grupo de canais.").

       //RUN pi-erro (INPUT "Grupo de Cliente " + string(tt-cliente-valid.cod-gr-cli) + " NÆo vinculado a grupo de canais.").
   END.
    
   IF tt-cliente-valid.cod-gr-cli = 26 THEN  // Grupo 26 - BNDES NÆo enviar a cart«rio.
      ASSIGN tt-cliente-valid.ins-banc = 7.
   
   // cria tabela extensÆo INT-EMITENTE-CANAL


   RUN pi-gerar-dados-extrato (">> CRIACAO DO CANAL " + string(p-prox-emitente)).

   IF NOT CAN-FIND(FIRST int-emitente-canal NO-LOCK
                   WHERE int-emitente-canal.cod-emitente = p-prox-emitente) THEN DO:
         CREATE int-emitente-canal.
         ASSIGN int-emitente-canal.cod-emitente        = p-prox-emitente 
                int-emitente-canal.cod-emitente-matriz = tt-cliente-valid.cod-emitente
                int-emitente-canal.guid-filial         = STRING(tt-cliente-valid.cod-emitente).
         RUN pi-gerar-dados-extrato (">> canal CRIADO" ). 
   END.

   FOR FIRST int-emitente-canal NO-LOCK
       WHERE int-emitente-canal.cod-emitente = P-PROX-EMITENTE:
       CREATE tt-int-emitente-canal.
       BUFFER-COPY int-emitente-canal TO tt-int-emitente-canal.
   END.

   IF TRIM(c-matriz) <> "" THEN DO:
       RUN pi-gerar-dados-extrato (">> entrou c-matriz:" + c-matriz).
       /*BUSCAR A CONTA MATRIZ*/
       FIND FIRST b-emit-matriz 
            WHERE b-emit-matriz.cgc    = substr(c-matriz,3,16) NO-LOCK NO-ERROR.
    
       /*Atualizacao da relacao Matriz/filial conforme CRM para efeitos de calculo de beneficios*/
       IF  AVAIL b-emit-matriz THEN DO:
            RUN pi-gerar-dados-extrato (">> grava matriz " + substr(c-matriz,3,16)). 
           ASSIGN tt-int-emitente-canal.cod-emitente-matriz = b-emit-matriz.cod-emitente .  
       END.
       ELSE 
           ASSIGN tt-int-emitente-canal.cod-emitente-matriz = P-PROX-EMITENTE.
   END.
   ELSE
       ASSIGN tt-int-emitente-canal.cod-emitente-matriz = P-PROX-EMITENTE.

   RUN pi-gerar-dados-extrato (">> gravou tt-int-emitente-canal.cod-emitente-matriz:" + STRING(tt-int-emitente-canal.cod-emitente-matriz)). 

   IF tt-cliente-valid.ind-tipo-movto = 1  THEN DO:  // SETA OS CAMPOS SOMENTE NA CRIA€ÇO DA CONTA
      ASSIGN tt-int-emitente-canal.DescricaoConta                = c-nome          
             tt-int-emitente-canal.TipoRelacao                   = 12               
             tt-int-emitente-canal.DataConstituicao              = IF data-constituicao <> '' THEN DATE( string(substr(data-constituicao,9,2)) + string(substr(data-constituicao,6,2)) + string(substr(data-constituicao,1,4)))   ELSE ?       
             tt-int-emitente-canal.DistribuicaoUnicaFonteRecei   = NO                            
             tt-int-emitente-canal.NivelPosVenda                 = '37E3A262-75ED-E311-9407-00155D013D38'            
             tt-int-emitente-canal.TipoConta                     = IF idi-matriz-filial = 'Matriz' THEN 993520000 ELSE 993520001        
             tt-int-emitente-canal.TipoEndereco                  = 3
             tt-int-emitente-canal.IntegraTrigger                = YES
             tt-int-emitente-canal.AssistenciaTecnica            = NO.

      CASE c-natureza:
          WHEN 'Pessoa Fisica'           THEN ASSIGN tt-int-emitente-canal.TipoConstituicao  = 993520003
                                                     tt-cliente-valid.natureza            = 1.
          WHEN 'Pessoa Juridica'         THEN ASSIGN tt-int-emitente-canal.TipoConstituicao  = 993520000
                                                     tt-cliente-valid.natureza            = 2.
          WHEN 'Estrangeiro'             THEN ASSIGN tt-int-emitente-canal.TipoConstituicao  = 993520001
                                                     tt-cliente-valid.natureza            = 3.      
      END CASE.

      IF tt-int-emitente-canal.OrigemConta = 0 THEN 
          ASSIGN tt-int-emitente-canal.OrigemConta = 993520005
	             tt-int-emitente-canal.tipoEndereco = 3.


      CASE c-registro-conta: //DEFINE A ORIGEM DA CONTA SOMENTE NA CRIACAO
              WHEN 'Itec'                                   THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520002.
              WHEN 'Call Center'                            THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520003.
              WHEN 'Indica‡Æo da Minutrade Banco do Brasil' THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520008.
              WHEN 'Indica‡Æo Minutrade Banco do Brasil'    THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520008.
              WHEN 'Plataforma Solar'                       THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520007.
      END CASE.

   END.
 /*  CASE c-registro-conta:
          WHEN 'Itec'                                   THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520002.
          WHEN 'Call Center'                            THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520003.
          WHEN 'Indica‡Æo da Minutrade Banco do Brasil' THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520008.
          WHEN 'Indica‡Æo Minutrade Banco do Brasil'    THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520008.
          WHEN 'Plataforma Solar'                       THEN ASSIGN tt-int-emitente-canal.OrigemConta = 993520007.
   END CASE. */

   RUN pi-gerar-dados-extrato (">> atualiza grupo cobranca").

   ASSIGN v_log_grupo_cob = NO.

   EMPTY TEMP-TABLE tt-prog-ponto.
   RUN esp/es0018p.p (INPUT "dps-canal-vd", /* grupos tratados para pedidos */
                      INPUT 1,              /* Ponto do programa */
                      INPUT 0,
                      INPUT "",
                      OUTPUT TABLE tt-prog-ponto) NO-ERROR.

   IF  CAN-FIND (FIRST tt-prog-ponto
                   WHERE tt-prog-ponto.conteudo = string(i-cod-grupo-cob)) THEN
       ASSIGN v_log_grupo_cob = YES.
   
   RUN pi-grupo-cobranca.
   
   IF tt-cliente-valid.ind-tipo-movto = 1 /*novo*/ THEN DO:
      IF tt-cliente-valid.cod-gr-cli = 30 THEN DO:  // cliente p½s-vendas
         ASSIGN tt-cliente-valid.ind-cre-cli = 1
                tt-cliente-valid.observacoes = "Liberado sem avalia‡Æo de cr‚dito para p¢s vendas":U
                tt-cliente-valid.lim-credito = 0 
                tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).
      END.
      ELSE IF tt-cliente-valid.cod-gr-cli = 95 THEN DO:
           ASSIGN tt-cliente-valid.ind-cre-cli = 1
                  tt-cliente-valid.observacoes = "Cliente faz parte do programa fidelidade e NÆo possui documenta‡Æo para fins de cr‚dito"
                  tt-cliente-valid.lim-credito = 0    
                  tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).
      END.
      ELSE DO:
          FIND FIRST ponto-programa
              WHERE ponto-programa.nome-programa = "escrm004":U
                AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
        
          IF AVAILABLE ponto-programa THEN DO:            /* conforme chamado 59312 */
             IF CAN-FIND(FIRST conteudo-programa NO-LOCK
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                           AND tt-cliente-valid.cgc BEGINS ENTRY(1,conteudo-programa.conteudo,",")) THEN DO:

                ASSIGN tt-cliente-valid.ind-cre-cli = 1
                       tt-cliente-valid.observacoes = "Cliente Banco - parametrizado para entrar com parametro de credito NORMAL"
                       tt-cliente-valid.lim-credito = 0    /* novos clientes Embratel entra com Automatico */
                       tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).

                IF AVAIL int-emitente THEN
                   //ASSIGN int-emitente.cod-gr-cob = 6.
                   ASSIGN tt-atualiza-int-emitente.cod-gr-cob = 6.
             END.
          END.
      END.
   END.
   
   ASSIGN tt-int-emitente-canal.PossuiEstruturaCompleta = 993520001
          tt-int-emitente-canal.PossuiFiliais           = 993520001
          tt-int-emitente-canal.StatusIntegracaoSefaz   = 993520001. 

   ASSIGN tt-int-emitente-canal.LimiteCredito           = de-limite-credito             
          tt-int-emitente-canal.DataLimiteCredito       = TODAY       
          tt-int-emitente-canal.CNAE                    = c-cnae                      
          tt-int-emitente-canal.RegimeApuracao          = c-regime-apuracao.             

   CASE c-categoria-pci:
       WHEN 'B sico'                     THEN ASSIGN tt-int-emitente-canal.Categoria  = "0F06766C-8C75-E911-80D7-0050568DB649".
       when 'Bronze'                     then assign tt-int-emitente-canal.Categoria  = "42DC7217-6EED-E311-9407-00155D013D38".
       when 'NÆo Participante do PCI'    then assign tt-int-emitente-canal.Categoria  = "5CCCA4F9-486D-E711-80C8-0050568DB649".
       when 'Ouro'                       then assign tt-int-emitente-canal.Categoria  = "D270322D-6EED-E311-9407-00155D013D38".
       when 'Prata'                      then assign tt-int-emitente-canal.Categoria  = "16712D22-6EED-E311-9407-00155D013D38".
       when 'Registrada'                 then assign tt-int-emitente-canal.Categoria  = "0802D40D-6EED-E311-9407-00155D013D38". 
       when 'Distribuidor'               then assign tt-int-emitente-canal.Categoria  = "68C05902-99EE-E311-940A-00155D013D3B".
       when 'Atacado'                    then assign tt-int-emitente-canal.Categoria  = "16136855-8C75-E911-80D7-0050568DB649".
       when 'Revenda Solu‡äes'           then assign tt-int-emitente-canal.Categoria  = "71242AB1-7312-E811-80CD-0050568DED44".
       when 'Parceiro Especializado'     then assign tt-int-emitente-canal.Categoria  = "9DD90A38-6890-EA11-80DA-0050568DED44".
       when 'Provedores'                 then assign tt-int-emitente-canal.Categoria  = "6C0E2FB7-7312-E811-80CD-0050568DED44".
       when 'Conta Nomeada'              then assign tt-int-emitente-canal.Categoria  = "76FD363B-6EED-E311-9407-00155D013D38".
       when 'Conta AdesÆo'               then assign tt-int-emitente-canal.Categoria  = "1F886648-6EED-E311-9407-00155D013D38".
       when 'Cliente Final'              then assign tt-int-emitente-canal.Categoria  = "E0AEB351-6EED-E311-9407-00155D013D38".
       when 'Colaborador'                then assign tt-int-emitente-canal.Categoria  = "848EFB66-6EED-E311-9407-00155D013D38".
       when 'Solu‡äes e Projetos'        then assign tt-int-emitente-canal.Categoria  = "70743A16-BA10-E711-80C5-0050568D81BB".
       when 'Mercado Externo'            then assign tt-int-emitente-canal.Categoria  = "71ED219F-2367-E711-80C8-0050568DB649".
       when 'Cliente EAD'                then assign tt-int-emitente-canal.Categoria  = "A32D4FFF-E175-E711-80C8-0050568DB649".
       when 'Venda Direta'               then assign tt-int-emitente-canal.Categoria  = "B842E3AD-D2CA-E711-80CC-0050568DED44".
       when 'Venda Indireta'             then assign tt-int-emitente-canal.Categoria  = "CE3EF2B4-D2CA-E711-80CC-0050568DED44".
       when 'Varejo'                     then assign tt-int-emitente-canal.Categoria  = "4AB937F9-6F0F-E911-80D8-0050568DED44".
   END CASE.

   // cria endere»os: Principal e de Cobran»a
   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
   FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = p-prox-emitente NO-ERROR.
   RUN pi-endereco-principal.
   RUN pi-endereco-cobranca.

   RUN pi-gerar-dados-extrato (">> complemento  " + int-emitente.complemento + STRING(int-emitente.cod-emitente)).
   RUN pi-gerar-dados-extrato (">> complemento-cob  " + int-emitente.complemento-cob).

   RUN pi-gerar-dados-extrato (">> ANTES DE ATUALIZAR REGISTROS 2").
   RUN pi-atualiza-registros.
   RUN pi-gerar-dados-extrato (">> DEPOIS DE ATUALIZAR REGISTROS 3").

   RELEASE int-emitente.
   RELEASE int-emitente-canal.

   DELETE PROCEDURE h-cdapi704.

   // cria demais tabelas relacionadas:
   FIND FIRST int-emitente-cex NO-LOCK
        WHERE int-emitente-cex.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.

   IF NOT AVAIL int-emitente-cex THEN DO:
      CREATE int-emitente-cex.
      ASSIGN int-emitente-cex.cod-emitente = tt-cliente-valid.cod-emitente .                    
   END.

   // INICIO DA API DE INTEGRA€ÇO DE CLIENTE 
   EMPTY TEMP-TABLE tt-versao-integr.
   CREATE tt-versao-integr.
   ASSIGN tt-versao-integr.cod-versao-integracao = 001.
 
   EMPTY TEMP-TABLE tt-dist-emit-valid.

   FIND FIRST dist-emitente NO-LOCK
        WHERE dist-emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.
   IF NOT AVAIL dist-emitente THEN DO:
    
      CREATE tt-dist-emit-valid.
      ASSIGN tt-dist-emit-valid.ind-tipo-movto              = 1 // Cria»Æo
             tt-dist-emit-valid.cod-emitente                = tt-cliente-valid.cod-emitente
             tt-dist-emit-valid.ind-atua-bonif-canc-saldo   = 1 /* nao cancela */
             tt-dist-emit-valid.log-libera-venda-sem-bonif  = yes
             tt-dist-emit-valid.ind-tp-frete                = 1 /*cif */
             tt-dist-emit-valid.idi-sit-fornec              = 1
             tt-dist-emit-valid.log-consid-ap-lim-cr        = no
             tt-dist-emit-valid.idi-confir-programac-entreg = 1 
             tt-dist-emit-valid.idi-agrup-item              = 1
             tt-dist-emit-valid.idi-niv-aces                = 1.
      
      // Verifica de o Modulo de descontos e Bonificacoes foi implantado no sistema*/
      FIND FIRST param-global NO-LOCK NO-ERROR.
      IF param-global.modulo-09 = YES THEN DO: /*modulo BN implantado*/     
        
         FIND FIRST para-ped NO-LOCK NO-ERROR.
        
         FIND FIRST param-bonif NO-LOCK 
              WHERE param-bonif.cod-estabel = para-ped.estab-padrao NO-ERROR.
        
         IF AVAIL param-bonif THEN
             ASSIGN tt-dist-emit-valid.ind-geracao-ped-bonif = param-bonif.ind-geracao-ped-bonif
                    tt-dist-emit-valid.log-bonif-junto-venda = param-bonif.log-bonif-junto-venda.                
        
      END.
   END.

   RUN pi-gerar-dados-extrato (">> ANTES DE PASSAR NA API").
   RUN pi-gerar-dados-extrato (">> CNPJ " + STRING(tt-cliente-valid.cgc)).
   RUN pi-gerar-dados-extrato (">> IDENTIFIC " + STRING(tt-cliente-valid.identific)). 
   RUN pi-gerar-dados-extrato (">> GRUPO FORNEC " + STRING(tt-cliente-valid.cod-gr-forn)).

   /* 
   FOR EACH TT-ERROS-GERAL:
       RUN pi-gerar-dados-extrato (">> ERRO:" + STRING(COD-ERRO) + ' - ' + DES-ERRO).

       RUN pi-erro (INPUT 412,
                    INPUT "ERRO_DE_VALIDACAO",
                    INPUT STRING(COD-ERRO) + ' - ' + DES-ERRO).

       //RUN pi-erro (INPUT ">> ERRO:" + STRING(COD-ERRO) + ' - ' + DES-ERRO).
   END.*/

   RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                       OUTPUT TABLE tt-erros-geral,
                       INPUT  TABLE tt-cliente-valid,
                       INPUT  TABLE tt-loc-entr-valid,
                       INPUT  TABLE tt-dist-emit-valid).

    
   RUN pi-gerar-dados-extrato (">> DEPOIS DE PASSAR NA API").

   FOR EACH TT-ERROS-GERAL:
       RUN pi-gerar-dados-extrato (">> ERRO:" + STRING(COD-ERRO) + ' - ' + DES-ERRO).

       RUN pi-erro (INPUT 412,
                    INPUT "ERRO_DE_VALIDACAO",
                    INPUT STRING(COD-ERRO) + ' - ' + DES-ERRO).

         //RUN pi-erro (INPUT ">> ERRO:" + STRING(COD-ERRO) + ' - ' + DES-ERRO).
   END.

   RUN pi-gerar-dados-extrato (">> ANTES DE ATUALIZAR REGISTROS 1").

   FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = p-prox-emitente NO-ERROR.

   IF  AVAIL tt-cliente-valid 
       AND AVAIL emitente THEN DO:

       //RUN pi-gerar-dados-extrato (">> ANTES DE ATUALIZAR REGISTROS 2").

       //RUN pi-atualiza-registros.

       //RUN pi-gerar-dados-extrato (">> DEPOIS DE ATUALIZAR REGISTROS 3").

        /*DISABLE TRIGGERS FOR LOAD OF emitente .*/

       FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
        
       ASSIGN emitente.ind-cre-cli     = tt-cliente-valid.ind-cre-cli
              emitente.observacoes     = tt-cliente-valid.observacoes
              emitente.lim-credito     = tt-cliente-valid.lim-credito
              emitente.dt-lim-cred     = tt-cliente-valid.dt-lim-cred
              emitente.user-libcre     = tt-cliente-valid.user-libcre
              emitente.ind-lib-estoque = tt-cliente-valid.ind-lib-estoque
              emitente.cod-suframa     = tt-cliente-valid.cod-suframa   
              emitente.insc-subs-trib  = tt-cliente-valid.insc-subs-trib.

       ASSIGN customercode             = emitente.cod-emitente
              shortname                = emitente.nome-abrev.

       FIND CURRENT emitente NO-LOCK NO-ERROR.
   END.

   RUN pi-gerar-dados-extrato (">> ANTES DO FIND CURRENT EMITENTE").
   

   RUN pi-gerar-dados-extrato (">> DEPOIS DO FIND CURRENT EMITENTE " + string(emitente.cod-emitente)).
   
   IF NOT AVAIL emitente THEN DO:

      RUN pi-erro (INPUT 404,
                   INPUT "REGISTRO_NAO_ENCONTRADO",
                   INPUT "Registro nao encontrado").

       //RUN pi-erro (INPUT "NÆo foi poss­vel criar o emitente, erro inesperado.").
   END.

   FOR EACH tt-erros-geral
      WHERE tt-erros-geral.cod-erro <> 18655:

      FIND FIRST estabelec NO-LOCK
           WHERE estabelec.cgc = emitente.cgc NO-ERROR.
      IF AVAIL estabelec AND tt-erros-geral.cod-erro = 973 THEN NEXT.

         RUN pi-erro (INPUT 412,
                      INPUT "ERRO_DE_VALIDACAO",
                      INPUT STRING(COD-ERRO) + ' - ' + DES-ERRO).

         //RUN pi-erro (INPUT tt-erros-geral.des-erro).
   END.

   IF CAN-FIND (FIRST tt-erro) THEN DO:
       UNDO blk_principal, LEAVE blk_principal.
   END.
   ELSE DO:
       
        IF ERROR-STATUS:ERROR THEN DO:
           DEFINE VARIABLE i AS INTEGER     NO-UNDO.

           DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
              IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE(STRING(ERROR-STATUS:GET-MESSAGE(i))).
           END.

           UNDO blk_principal, LEAVE blk_principal.
        END.
       /* ELSE DO: /* Envia cliente atualizado ao DEPS - M2212-185 */    

            RUN pi-gerar-dados-extrato (">> ANTES CHAMADA ESWSO021 4 " + string(emitente.cod-emitente)).
                                                                                                              
            IF  AVAIL emitente                                                                                
            AND emitente.natureza = 2                                                                         
            AND v_log_grupo_cob   = YES THEN DO:       

                RUN pi-gerar-dados-extrato (">> ANTES CHAMADA ESWSO021 5 " + string(emitente.cod-emitente)).

                RUN esp/wso/eswso0022.p (INPUT emitente.cod-emit). /* Envia cadastro atualizado ao DEPS */    

                RUN pi-gerar-dados-extrato (">> ANTES CHAMADA ESWSO021 6 " + string(emitente.cod-emitente)).
                                                                                                              
               /* RUN esp/wso/eswso0021.p (INPUT emitente.cod-emit, /* Envia nova requis‡Æo de limite ao DEPS */
                                         OUTPUT v_cod_erro,
                                         OUTPUT v_return).   

                RUN pi-gerar-dados-extrato (">> DEPOIS CHAMADA ESWSO021 1 " + string(emitente.cod-emitente) + " Retorno: " + v_return).
                                                                                                              
                IF  v_return = "NOK" THEN DO:   
                    RUN pi-erro (INPUT v_cod_erro,
                                 INPUT "ERRO_DE_INTEGRACAO_DEPS",
                                 INPUT v_cod_erro). */

                    //UNDO blk_principal, LEAVE blk_principal.                                                  
                END.                                                                                          
            END.

            //IF AVAIL emitente THEN
            //    RELEASE emitente.
        END. */
   END.

    //RUN pi-alteracao-matriz-economica.

END.

/***

/*BUSCAR A CONTA MATRIZ*/
FIND FIRST b-emitente NO-LOCK
    WHERE b-emitente.nome-matriz = c-matriz NO-ERROR.

/*Atualiza¯Êo da rela¯Êo Matriz/filial conforme CRM para efeitos de c˜lculo de beneficios*/
                                    IF  AVAIL b-emitente THEN
                                        ASSIGN int-emitente-canal.cod-emitente-matriz = b-emitente.cod-emitente 
                                               int-emitente-canal.guid-filial         = msg0072.CodigoConta          
                                               int-emitente-canal.guid-matriz         = b-int-emit-Matriz-crm.cod-guid.  
                                    ELSE 
                                        ASSIGN int-emitente-canal.cod-emitente-matriz = tt-cliente-valid.cod-emitente
                                               int-emitente-canal.guid-filial         = msg0072.CodigoConta
                                               int-emitente-canal.guid-matriz         = msg0072.CodigoConta.





****/


PROCEDURE pi-endereco-principal.

        RUN pi-gerar-dados-extrato (">> C-COMP " + C-COMPl-entr).
        RUN pi-trata-endereco IN h-cdapi704 (INPUT fn-free-accent(UPPER(TRIM(c-endereco-entr))),
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
   
        RUN pi-gerar-dados-extrato (">> ENDERECO PRINCIPAL ").
        IF trim(string(c-numero-entr)) = '' 
           AND c-nro <> '' THEN ASSIGN c-numero-entr = TRIM(c-nro).

        IF trim(string(c-compl-entr)) = '' 
           AND c-comp <> '' THEN ASSIGN c-compl-entr = TRIM(c-comp).

        RUN pi-gerar-dados-extrato (">> C-RUA " + C-RUA).
        RUN pi-gerar-dados-extrato (">> NRO " + C-NUMERO-ENTR).
        RUN pi-gerar-dados-extrato (">> C-COMP " + C-COMPl-entr).
       
        ASSIGN tt-cliente-valid.cep          = c-cep-entr
               tt-cliente-valid.endereco     = c-rua + ',' + c-numero-entr + " - " + C-COMPl-entr //teste complemnto ender principal
               tt-cliente-valid.bairro       = fn-free-accent(UPPER(TRIM(c-bairro-entr)))
               tt-cliente-valid.cidade       = fn-free-accent(UPPER(TRIM(c-cidade-entr))) 
               tt-cliente-valid.estado       = fn-free-accent(UPPER(TRIM(c-uf-entr))) 
               tt-cliente-valid.pais         = fn-free-accent(UPPER(TRIM(c-pais-entr))).

        
        FIND FIRST loc-entr NO-LOCK
             WHERE loc-entr.nome-abrev  = tt-cliente-valid.nome-abrev
               AND loc-entr.cod-entrega = "PadrÆo":U NO-ERROR. 
         
       /* IF NOT AVAILABLE loc-entr THEN DO:
            CREATE loc-entr.
            ASSIGN loc-entr.nome-abrev   = tt-cliente-valid.nome-abrev
                   loc-entr.cod-entrega  = "PadrÆo":U.
        END.
        */
        IF AVAIL loc-entr THEN DO:
            CREATE tt-loc-entr.
            BUFFER-COPY loc-entr TO tt-loc-entr.
        END.
        ELSE DO:
            CREATE tt-loc-entr.
            ASSIGN tt-loc-entr.nome-abrev  = tt-cliente-valid.nome-abrev
                   tt-loc-entr.cod-entrega = "PadrÆo":U.
        END.
        
        RUN pi-gerar-dados-extrato (">> CRIOU tt-loc-entr").

        //ASSIGN loc-entr.endereco = "":U.
        IF tt-cliente-valid.endereco <> "":U THEN DO:
            ASSIGN tt-loc-entr.endereco = tt-cliente-valid.endereco.
        END.
        
        ASSIGN tt-loc-entr.bairro         = tt-cliente-valid.bairro
               tt-loc-entr.cidade         = tt-cliente-valid.cidade
               tt-loc-entr.estado         = tt-cliente-valid.estado
               tt-loc-entr.cep            = REPLACE(tt-cliente-valid.cep, "-":U, "":U)
               tt-loc-entr.pais           = tt-cliente-valid.pais
               tt-loc-entr.cgc            = c-documento
               tt-loc-entr.ins-estadual   = tt-cliente-valid.ins-estadual
               tt-loc-entr.nom-cidad-cif  = tt-cliente-valid.cidade. 

        RUN pi-gerar-dados-extrato (">> tt-loc-entr.bairro " + tt-loc-entr.bairro).

       /* FIND FIRST int-loc-entr NO-LOCK 
             WHERE int-loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
               AND int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega NO-ERROR.

        IF NOT AVAILABLE int-loc-entr THEN DO:
            CREATE int-loc-entr.
            ASSIGN int-loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
                   int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega.
        END. */

        CREATE tt-int-loc-entr.
        ASSIGN tt-int-loc-entr.nome-abrev        = tt-loc-entr.nome-abrev 
               tt-int-loc-entr.cod-entrega       = tt-loc-entr.cod-entrega
               tt-int-loc-entr.endereco-completo = tt-loc-entr.endereco
               tt-int-loc-entr.logradouro        = c-rua
               tt-int-loc-entr.numero            = trim(string(c-numero-entr))
               tt-int-loc-entr.complemento       = trim(c-compl-entr).

        IF AVAIL tt-int-emitente-canal THEN DO:
            ASSIGN tt-int-emitente-canal.Estado       = tt-cliente-valid.Estado      
                   tt-int-emitente-canal.Pais         = tt-cliente-valid.Pais        
                   tt-int-emitente-canal.Telefone     = tt-cliente-valid.Telefone[1] .                                              
        END.

        /*IF AVAIL int-emitente THEN DO:
            RUN pi-gerar-dados-extrato (">> INT-EMITENTE.COMPLE" + c-compl-entr ).
            ASSIGN int-emitente.logradouro  = c-rua   
                   int-emitente.numero      = trim(string(c-numero-entr))                    
                   int-emitente.complemento = trim(c-compl-entr).                            
        END.*/
        IF AVAIL tt-atualiza-int-emitente THEN DO:
            RUN pi-gerar-dados-extrato (">> INT-EMITENTE.COMPLE" + c-compl-entr ).
            /*ASSIGN int-emitente.logradouro  = c-rua 
                   int-emitente.numero      = trim(string(c-numero-entr))                    
                   int-emitente.complemento = trim(c-compl-entr).                            */

            ASSIGN tt-atualiza-int-emitente.logradouro  = c-rua 
                   tt-atualiza-int-emitente.numero      = trim(string(c-numero-entr))                    
                   tt-atualiza-int-emitente.complemento = trim(c-compl-entr).  
        END.

        CREATE tt-loc-entr-valid.
        BUFFER-COPY tt-loc-entr TO tt-loc-entr-valid.
        //BUFFER-COPY tt-int-loc-entr TO tt-loc-entr-valid.
 
END PROCEDURE.

PROCEDURE pi-endereco-cobranca.
        
        RUN pi-trata-endereco IN h-cdapi704 (INPUT fn-free-accent(UPPER(TRIM(c-endereco-cob))),
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
        IF trim(string(c-numero-cob)) = '' 
           AND c-nro <> '' THEN ASSIGN c-numero-cob = TRIM(c-nro).

        IF trim(string(c-compl-cob)) = '' 
           AND c-comp <> '' THEN ASSIGN c-compl-cob = TRIM(c-comp).

      
        ASSIGN tt-cliente-valid.endereco-cob = c-rua + ',' + c-numero-cob + " - " + c-compl-cob
               tt-cliente-valid.bairro-cob   = fn-free-accent(UPPER(TRIM(c-bairro-cob)))                                                                                     
               tt-cliente-valid.cidade-cob   = fn-free-accent(UPPER(TRIM(c-cidade-cob)))                                                                                     
               tt-cliente-valid.estado-cob   = fn-free-accent(UPPER(TRIM(c-uf-cob)))                                                                                         
               tt-cliente-valid.pais-cob     = fn-free-accent(UPPER(TRIM(c-pais-cob)))                                                                                      
               tt-cliente-valid.cep-cob      = c-cep-cob    .

        IF AVAIL tt-int-emitente-canal THEN DO:
           ASSIGN tt-int-emitente-canal.NomeEnderecoCob = tt-cliente-valid.endereco-cob
                  tt-int-emitente-canal.EstadoCob       = fn-free-accent(UPPER(TRIM(c-uf-cob)))       
                  tt-int-emitente-canal.PaisCob         = fn-free-accent(UPPER(TRIM(c-pais-cob)))      
                  tt-int-emitente-canal.NomeContatoCob  = '' .                                            
        END.
        /*IF AVAIL int-emitente THEN DO:
            ASSIGN int-emitente.logradouro-cob  = c-rua         
                   int-emitente.numero-cob      = trim(string(c-numero-cob))                          
                   int-emitente.complemento-cob = trim(c-compl-cob).                                  
        END.*/
        IF AVAIL tt-atualiza-int-emitente THEN
           ASSIGN tt-atualiza-int-emitente.logradouro-cob  = c-rua 
                  tt-atualiza-int-emitente.numero-cob      = trim(string(c-numero-cob))                    
                  tt-atualiza-int-emitente.complemento-cob = trim(c-compl-cob).  
 
END PROCEDURE.

PROCEDURE pi-grupo-cobranca.
    DEF VAR i-ind AS INT.
    
    //ASSIGN tt-atualiza-int-emitente.cod-gr-cob  = i-cod-grupo-cob. marcios

    RUN pi-gerar-dados-extrato (">> 1 - credito - i-cod-grupo-cob " + string(i-cod-grupo-cob)).
    RUN pi-gerar-dados-extrato (">> 2 - credito - tt-atualiza-int-emitente.cod-gr-cob " + string(tt-atualiza-int-emitente.cod-gr-cob)).
    
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "dp3-canal-vd", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    IF  CAN-FIND (FIRST tt-prog-ponto
                  WHERE tt-prog-ponto.conteudo = string(tt-atualiza-int-emitente.cod-gr-cob)) /*string(int-emitente.cod-gr-cob))*/ THEN DO:

        RUN pi-gerar-dados-extrato (">> Ponto dp3-canal-vd").

        IF  v_log_grupo_cob = YES THEN DO:
            ASSIGN tt-cliente-valid.ind-lib-estoque   = YES
                   tt-cliente-valid.user-libcre       = "DEPS"
                   tt-cliente-valid.ind-aval          = 1
                   tt-cliente-valid.ind-aval-embarque = 2.
            
            /*
            IF  i-ind-tipo-movto = 1 THEN DO: /* cliente novo */
            */
                IF  de-limite-credito > 0 THEN DO:
                    RUN pi-gerar-dados-extrato (">> 3.1 - grava limite e status de credito normal").
        
                    ASSIGN tt-cliente-valid.ind-cre-cli = 1
                           tt-cliente-valid.lim-credito = de-limite-credito              
                           tt-cliente-valid.dt-lim-cred = tt-cliente-valid.dt-lim-cred.
                END.
                ELSE DO:
                    RUN pi-gerar-dados-extrato (">> 4.1 - ttt status de credito suspenso").
        
                    ASSIGN tt-cliente-valid.ind-cre-cli = 5
                           tt-cliente-valid.lim-credito = de-limite-credito.
                           tt-cliente-valid.dt-lim-cred = ?.
                END.
            /*
            END.
            */
        END.
        ELSE DO:
            IF  i-ind-tipo-movto = 1 THEN DO:
                IF  de-limite-credito > 0 THEN DO:
                    RUN pi-gerar-dados-extrato (">> 3.2 - grava limite e status de credito normal").
        
                    ASSIGN tt-cliente-valid.lim-credito = de-limite-credito              
                           tt-cliente-valid.dt-lim-cred = tt-cliente-valid.dt-lim-cred.
                END.
                ELSE DO:
                    RUN pi-gerar-dados-extrato (">> 4.2 - ttt status de credito suspenso").
        
                    ASSIGN tt-cliente-valid.lim-credito = de-limite-credito.
                           tt-cliente-valid.dt-lim-cred = ?.
                END.
            END.
        END.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "n-envia-bco", /* portadores de carteira sem envio ao banco - chamado: 147545 */
                           INPUT 1,              /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF  tt-cliente-valid.cod-gr-cli = 25 
        OR (CAN-FIND (FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = tt-cliente-valid.nome-matriz)) THEN DO:

            ASSIGN tt-cliente-valid.portador   = 999
                   tt-cliente-valid.modalidade = 1.
        END.
    END.
    ELSE DO:
        IF  tt-int-emitente-canal.OrigemConta = 993520007 THEN DO: /* Plataforma Solar - chamado 127506 */
            RUN pi-gerar-dados-extrato (">> 5 - Plataforma Solar").

            ASSIGN tt-cliente-valid.ind-cre-cli     = 2 /* automatico */
                   //int-emitente.cod-gr-cob          = 80
                   tt-atualiza-int-emitente.cod-gr-cob = 80
                   tt-cliente-valid.lim-credito     = 1
                   tt-cliente-valid.dt-lim-cred     = 01/01/2990
                   tt-cliente-valid.user-libcre     = "PltSolar"
                   tt-cliente-valid.ind-lib-estoque = YES.
        END.
        ELSE DO:

            IF  tt-int-emitente-canal.OrigemConta = 993520002 
            AND i-ind-tipo-movto = 1 /* Itec / konviva inclusao */ THEN DO:

                 RUN pi-gerar-dados-extrato (">> 5.1 - Konviva").

                 ASSIGN tt-atualiza-int-emitente.cod-gr-cob = 9
                        tt-cliente-valid.lim-credito     = 1
                        tt-cliente-valid.dt-lim-cred     = 01/01/2990
                        tt-cliente-valid.user-libcre     = "Especial"
                        tt-cliente-valid.ind-lib-estoque = YES.

            END.
            ELSE IF tt-int-emitente-canal.OrigemConta = 993520008 
                 OR tt-atualiza-int-emitente.cod-gr-cob = 98 THEN DO:

                 RUN pi-gerar-dados-extrato (">> 5.2 - Minutrade - " + string(tt-int-emitente-canal.OrigemConta)). 

                 RUN pi-gerar-dados-extrato (">> 5.3 - grupo 98 - " + string(tt-atualiza-int-emitente.cod-gr-cob)). 
               
                 ASSIGN tt-cliente-valid.ind-cre-cli     = 2 /* automatico */
                        //int-emitente.cod-gr-cob          = 98
                        tt-atualiza-int-emitente.cod-gr-cob = 98
                        tt-cliente-valid.lim-credito     = 1
                        tt-cliente-valid.dt-lim-cred     = 01/01/2990
                        tt-cliente-valid.user-libcre     = IF tt-int-emitente-canal.OrigemConta = 993520008 THEN "Minutrade" ELSE "Especial"
                        tt-cliente-valid.ind-lib-estoque = YES
                        tt-cliente-valid.observacoes     = IF tt-int-emitente-canal.OrigemConta = 993520008 THEN "Cadastro liberado para Minutrade" ELSE "".
            END.
            ELSE DO:
               
               EMPTY TEMP-TABLE tt-prog-ponto.
               RUN esp/es0018p.p (INPUT "MSG0072":U,
                                  INPUT 1,
                                  INPUT 0,
                                  INPUT "":U,
                                  OUTPUT TABLE tt-prog-ponto).
        
               FOR EACH tt-prog-ponto:
        
                   DO  i-ind = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo,";"):
        
                       IF string(tt-cliente-valid.cod-gr-cli) = ENTRY(i-ind, tt-prog-ponto.conteudo, ";") THEN DO:
                           RUN pi-gerar-dados-extrato (">> 6 - P«s venda e E-Commerce").
        
                           ASSIGN tt-cliente-valid.ind-cre-cli = 5 /* û vista */
                                  tt-cliente-valid.observacoes = "Liberado sem avaliacao de credito para pagamento a vista":U
                                  tt-cliente-valid.lim-credito = 1
                                  tt-cliente-valid.dt-lim-cred = DATE(01, 01, 2990).
        
                          /* IF AVAIL int-emitente THEN
                              ASSIGN int-emitente.cod-gr-cob = tt-prog-ponto.sequencia.
        
                           IF  int-emitente.cod-gr-cob = 17 THEN
                               ASSIGN tt-cliente-valid.user-libcre = "Posvenda".
        
                           IF  int-emitente.cod-gr-cob = 9 THEN
                               ASSIGN tt-cliente-valid.user-libcre = "E-commerce". */
    
                             IF AVAIL tt-atualiza-int-emitente THEN
                                //ASSIGN int-emitente.cod-gr-cob = tt-prog-ponto.sequencia.
                                ASSIGN tt-atualiza-int-emitente.cod-gr-cob = tt-prog-ponto.sequencia.
                          
                             IF  tt-atualiza-int-emitente.cod-gr-cob = 17 THEN
                                 ASSIGN tt-cliente-valid.user-libcre = "Posvenda".
                          
                             IF  tt-atualiza-int-emitente.cod-gr-cob = 9 THEN
                                 ASSIGN tt-cliente-valid.user-libcre = "E-commerce".
        
                           ASSIGN tt-cliente-valid.ind-lib-estoque = YES.
                       END.
                   END.
               END.
            END.
        END.
    END.

    
END PROCEDURE.

PROCEDURE pi-alteracao-matriz-economica.
  /*
        DEF VAR c-matriz-crm AS CHAR FORMAT "x(12)" NO-UNDO.
    IF  emitente.nome-matriz <> tt-cliente-valid.nome-matriz THEN DO:
        LOG-MANAGER:WRITE-MESSAGE("4 - tt-cliente-valid.nome-matriz: "         + STRING(tt-cliente-valid.nome-matriz)).
        ASSIGN c-matriz-crm = tt-cliente-valid.nome-matriz.
        FIND FIRST emitente EXCLUSIVE-LOCK
             WHERE emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.
        IF  AVAIL emitente THEN DO:
    
            EMPTY TEMP-TABLE tt-versao-integr.
            EMPTY TEMP-TABLE tt-erros-geral.   
            EMPTY TEMP-TABLE tt-cliente-valid. 
            EMPTY TEMP-TABLE tt-loc-entr-valid.
            EMPTY TEMP-TABLE tt-dist-emit-valid.
    
            CREATE tt-cliente-valid.
            BUFFER-COPY emitente TO tt-cliente-valid.
            ASSIGN emitente.nome-matriz            = c-matriz-crm
                   tt-cliente-valid.nome-matriz    = c-matriz-crm
                   tt-cliente-valid.ind-tipo-movto = 2.
            EMPTY TEMP-TABLE tt-versao-integr.
            CREATE tt-versao-integr.
            ASSIGN tt-versao-integr.cod-versao-integracao = 001.
    
            LOG-MANAGER:WRITE-MESSAGE("5 - emitente.nome-matriz: "         + STRING(emitente.nome-matriz)).

            RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                                OUTPUT TABLE tt-erros-geral,
                                INPUT  TABLE tt-cliente-valid,
                                INPUT  TABLE tt-loc-entr-valid,
                                INPUT  TABLE tt-dist-emit-valid).
            FOR EACH tt-erros-geral
                WHERE tt-erros-geral.cod-erro <> 18655:

                RUN pi-erro (INPUT tt-erros-geral.des-erro).
            END.
        
            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_principal, LEAVE blk_principal.
            END.
            ELSE DO:
                IF ERROR-STATUS:ERROR THEN DO:
                    DEFINE VARIABLE j AS INTEGER     NO-UNDO.
                    DO j = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE(STRING(ERROR-STATUS:GET-MESSAGE(j))).
                    END.
                    UNDO blk_principal, LEAVE blk_principal.
                END.
            END.
        END.
    END.

    LOG-MANAGER:WRITE-MESSAGE("6 - avail emitente: "  + string(AVAIL emitente)).
    IF AVAIL emitente THEN DO: 

        FIND FIRST wm-cliente NO-LOCK
             WHERE wm-cliente.cod-cliente = emitente.cod-emitente
               AND wm-cliente.nome-abrev  = emitente.nome-abrev NO-ERROR.
        IF NOT AVAIL wm-cliente THEN DO:
            EMPTY TEMP-TABLE RowErrors.
            IF NOT VALID-HANDLE(h-prx073) THEN
               RUN wmp/wmprx073.p PERSISTENT SET h-prx073.
           
            /*cria a tabela wm-cliente*/
            RUN replicaCliente IN h-prx073(INPUT emitente.cod-emitente,
                                           INPUT emitente.nome-abre,
                                           OUTPUT TABLE RowErrors).
           
            IF CAN-FIND (FIRST RowErrors) THEN DO:
               FOR EACH RowErrors:
                   RUN pi-erro (INPUT RowErrors.ErrorDescription).
               END.
               RUN destroy IN h-prx073.
               UNDO blk_principal, LEAVE blk_principal.
            END.
            RUN destroy IN h-prx073.
        END.
    END. 
*/
END PROCEDURE.

PROCEDURE pi-valida-campos:

     FIND FIRST mgcad.pais
             WHERE mgcad.pais.nome-compl     = c-pais-cob NO-LOCK NO-ERROR.

     ASSIGN c-nome                  = fn-free-accent(UPPER(c-nome))
            c-nome-fantasia         = fn-free-accent(UPPER(c-nome-fantasia))
            c-nome-abrev            = fn-free-accent(UPPER(c-nome-abrev))
            c-email                 = fn-free-accent(lower(c-email))
            c-bairro-cob            = fn-free-accent(UPPER(TRIM(c-bairro-cob)))
            c-compl-cob             = fn-free-accent(UPPER(TRIM(c-compl-cob)))
            c-endereco-cob          = fn-free-accent(UPPER(TRIM(c-endereco-cob)))
            c-cidade-cob            = fn-free-accent(UPPER(TRIM(c-cidade-cob)))
            c-pais-cob              = fn-free-accent(UPPER(TRIM(pais.nome-pais)))
            c-bairro-entr           = fn-free-accent(UPPER(TRIM(c-bairro-entr)))
            c-compl-entr            = fn-free-accent(UPPER(TRIM(c-compl-entr)))
            c-endereco-entr         = fn-free-accent(UPPER(TRIM(c-endereco-entr)))
            c-cidade-entr           = fn-free-accent(UPPER(TRIM(c-cidade-entr))).
            c-pais-entr             = fn-free-accent(UPPER(TRIM(pais.nome-pais))).
            
END PROCEDURE.

PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    
        output to value(c-arquivo-log) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string + " - " + STRING(DATETIME(TODAY, MTIME))  format "x(200)" skip.
        output close. 
    
    end.
END.



PROCEDURE pi-erro:
    DEFINE INPUT PARAM i-code AS INT.
    DEFINE INPUT PARAM c-info AS CHAR.
    DEFINE INPUT PARAM c-erro AS CHAR.

    FIND FIRST tt-erro WHERE tt-erro.mensagem = c-erro NO-ERROR.

    IF NOT AVAIL tt-erro THEN DO:
       CREATE tt-erro.
       ASSIGN tt-erro.codigo     = i-code
              tt-erro.informacao = c-info
              tt-erro.mensagem   = c-erro.
    END.

END PROCEDURE.


PROCEDURE pi-atualiza-registros:

    RUN pi-gerar-dados-extrato (">> procedure pi-atualiza-registros" + STRING(tt-cliente-valid.cod-emitente)).
    
    FIND FIRST tt-atualiza-int-emitente NO-ERROR.

    FIND FIRST int-emitente EXCLUSIVE-LOCK
         WHERE int-emitente.cod-emitente = tt-atualiza-int-emitente.cod-emitente NO-ERROR.
    IF AVAIL int-emitente THEN DO:
        RUN pi-gerar-dados-extrato (">> avail int-emitente"). 
        ASSIGN int-emitente.cod-emitente          = tt-atualiza-int-emitente.cod-emitente        
               int-emitente.ind-forma-tributo     = tt-atualiza-int-emitente.ind-forma-tributo   
               int-emitente.ind-vendas-alc        = tt-atualiza-int-emitente.ind-vendas-alc      
               int-emitente.dt-vcto-concessao     = tt-atualiza-int-emitente.dt-vcto-concessao   
               int-emitente.ind-participa-canais  = tt-atualiza-int-emitente.ind-participa-canais
               int-emitente.id-ativo              = tt-atualiza-int-emitente.id-ativo            
               int-emitente.cod-gr-cob            = tt-atualiza-int-emitente.cod-gr-cob          
               int-emitente.logradouro            = tt-atualiza-int-emitente.logradouro          
               int-emitente.numero                = tt-atualiza-int-emitente.numero              
               int-emitente.complemento           = tt-atualiza-int-emitente.complemento         
               int-emitente.logradouro-cob        = tt-atualiza-int-emitente.logradouro-cob      
               int-emitente.numero-cob            = tt-atualiza-int-emitente.numero-cob          
               int-emitente.complemento-cob       = tt-atualiza-int-emitente.complemento-cob 
               int-emitente.guid-subclass         = tt-atualiza-int-emitente.guid-subclass
               int-emitente.dispositivo-legal     = tt-atualiza-int-emitente.dispositivo-legal.
    END.
   /* ELSE DO:
        RUN pi-gerar-dados-extrato (">> CRIANDO int-emitente"). 
        CREATE int-emitente.
        BUFFER-COPY tt-atualiza-int-emitente TO int-emitente.
    END. */
    FIND CURRENT int-emitente NO-LOCK NO-ERROR.
    RELEASE int-emitente.

    RUN pi-gerar-dados-extrato (">> LIBERANDO int-emitente"). 
         

    FIND FIRST tt-int-emitente-canal NO-ERROR.
    IF AVAIL tt-int-emitente-canal THEN DO:
        RUN pi-gerar-dados-extrato (">> avail tt-int-emitente-canal").

        FIND FIRST int-emitente-canal EXCLUSIVE-LOCK
             WHERE int-emitente-canal.cod-emitente = tt-int-emitente-canal.cod-emitente NO-ERROR.
        IF AVAIL int-emitente-canal THEN DO:
            RUN pi-gerar-dados-extrato (">> atualizando tabela int-emitente-canal").
            ASSIGN int-emitente-canal.DescricaoConta              = tt-int-emitente-canal.DescricaoConta             
                   int-emitente-canal.TipoRelacao                 = tt-int-emitente-canal.TipoRelacao                
                   int-emitente-canal.DataConstituicao            = tt-int-emitente-canal.DataConstituicao           
                   int-emitente-canal.DistribuicaoUnicaFonteRecei = tt-int-emitente-canal.DistribuicaoUnicaFonteRecei
                   int-emitente-canal.NivelPosVenda               = tt-int-emitente-canal.NivelPosVenda              
                   int-emitente-canal.TipoConta                   = tt-int-emitente-canal.TipoConta                  
                   int-emitente-canal.TipoEndereco                = tt-int-emitente-canal.TipoEndereco               
                   int-emitente-canal.IntegraTrigger              = tt-int-emitente-canal.IntegraTrigger             
                   int-emitente-canal.AssistenciaTecnica          = tt-int-emitente-canal.AssistenciaTecnica         
                   int-emitente-canal.TipoConstituicao            = tt-int-emitente-canal.TipoConstituicao           
                   int-emitente-canal.OrigemConta                 = tt-int-emitente-canal.OrigemConta                
                   int-emitente-canal.PossuiEstruturaCompleta     = tt-int-emitente-canal.PossuiEstruturaCompleta    
                   int-emitente-canal.PossuiFiliais               = tt-int-emitente-canal.PossuiFiliais              
                   int-emitente-canal.StatusIntegracaoSefaz       = tt-int-emitente-canal.StatusIntegracaoSefaz      
                   int-emitente-canal.LimiteCredito               = tt-int-emitente-canal.LimiteCredito              
                   int-emitente-canal.DataLimiteCredito           = tt-int-emitente-canal.DataLimiteCredito          
                   int-emitente-canal.CNAE                        = tt-int-emitente-canal.CNAE                       
                   int-emitente-canal.RegimeApuracao              = tt-int-emitente-canal.RegimeApuracao             
                   int-emitente-canal.Categoria                   = tt-int-emitente-canal.Categoria                  
                   int-emitente-canal.Estado                      = tt-int-emitente-canal.Estado                     
                   int-emitente-canal.Pais                        = tt-int-emitente-canal.Pais                       
                   int-emitente-canal.Telefone                    = tt-int-emitente-canal.Telefone                   
                   int-emitente-canal.NomeEnderecoCob             = tt-int-emitente-canal.NomeEnderecoCob            
                   int-emitente-canal.EstadoCob                   = tt-int-emitente-canal.EstadoCob                  
                   int-emitente-canal.PaisCob                     = tt-int-emitente-canal.PaisCob                    
                   int-emitente-canal.NomeContatoCob              = tt-int-emitente-canal.NomeContatoCob 
		           int-emitente-canal.cod-emitente-matriz         = tt-int-emitente-canal.cod-emitente-matriz. 

            RUN pi-gerar-dados-extrato (">> atualizando cod-emitente-matriz:" + STRING(int-emitente-canal.cod-emitente-matriz)).
        END.
    END.
    FIND CURRENT int-emitente-canal NO-LOCK NO-ERROR.
    RELEASE int-emitente-canal.

    RUN pi-gerar-dados-extrato (">> ANTES CREATE loc-entr ").

    FIND FIRST tt-loc-entr NO-ERROR.
    IF AVAIL tt-loc-entr THEN DO:
        RUN pi-gerar-dados-extrato (">> ENTROU tt-loc-entr").
        FIND FIRST loc-entr NO-LOCK
             WHERE loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
               AND loc-entr.cod-entrega = tt-loc-entr.cod-entrega NO-ERROR.
        IF NOT AVAILABLE loc-entr THEN DO:
            RUN pi-gerar-dados-extrato (">> ENTROU CREATE loc-entr").
            CREATE loc-entr.
            ASSIGN loc-entr.nome-abrev    = tt-loc-entr.nome-abrev   
                   loc-entr.cod-entrega   = tt-loc-entr.cod-entrega
                   loc-entr.endereco      = tt-loc-entr.endereco     
                   loc-entr.bairro        = tt-loc-entr.bairro       
                   loc-entr.cidade        = tt-loc-entr.cidade       
                   loc-entr.estado        = tt-loc-entr.estado       
                   loc-entr.cep           = tt-loc-entr.cep          
                   loc-entr.pais          = tt-loc-entr.pais         
                   loc-entr.cgc           = tt-loc-entr.cgc          
                   loc-entr.ins-estadual  = tt-loc-entr.ins-estadual 
                   loc-entr.nom-cidad-cif = tt-loc-entr.nom-cidad-cif
                   loc-entr.nome-transp   = tt-loc-entr.nome-transp.

            RUN pi-gerar-dados-extrato (">> GRAVOU loc-entr.bairro" + loc-entr.bairro).
        END.
        ELSE DO:
            RUN pi-gerar-dados-extrato (">> ENTROU ASSIGN loc-entr").
            FIND CURRENT loc-entr EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN loc-entr.endereco      = tt-loc-entr.endereco     
                   loc-entr.bairro        = tt-loc-entr.bairro       
                   loc-entr.cidade        = tt-loc-entr.cidade       
                   loc-entr.estado        = tt-loc-entr.estado       
                   loc-entr.cep           = tt-loc-entr.cep          
                   loc-entr.pais          = tt-loc-entr.pais         
                   loc-entr.cgc           = tt-loc-entr.cgc          
                   loc-entr.ins-estadual  = tt-loc-entr.ins-estadual 
                   loc-entr.nom-cidad-cif = tt-loc-entr.nom-cidad-cif
                   loc-entr.nome-transp   = tt-loc-entr.nome-transp.
            RUN pi-gerar-dados-extrato (">> GRAVOU loc-entr.bairro" + loc-entr.bairro).
        END.
    END.
    FIND CURRENT loc-entr NO-LOCK NO-ERROR.
    RELEASE loc-entr.

    RUN pi-gerar-dados-extrato (">> SAIU LOC-ENTR").

    FIND FIRST int-loc-entr EXCLUSIVE-LOCK 
         WHERE int-loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
           AND int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega NO-ERROR.
    IF NOT AVAILABLE int-loc-entr THEN DO:
        CREATE int-loc-entr.
        BUFFER-COPY tt-int-loc-entr TO int-loc-entr.
    END.
    ELSE DO:
        ASSIGN int-loc-entr.nome-abrev        = tt-int-loc-entr.nome-abrev        
               int-loc-entr.cod-entrega       = tt-int-loc-entr.cod-entrega       
               int-loc-entr.endereco-completo = tt-int-loc-entr.endereco-completo 
               int-loc-entr.logradouro        = tt-int-loc-entr.logradouro        
               int-loc-entr.numero            = tt-int-loc-entr.numero            
               int-loc-entr.complemento       = tt-int-loc-entr.complemento .     
    END.
    FIND CURRENT int-loc-entr NO-LOCK NO-ERROR.
    RELEASE int-loc-entr.     

    RUN CriaHistorico(INPUT tt-atualiza-int-emitente.cod-emitente,
                      INPUT "Atualizacao cadastral via sales force",
                      INPUT idi-ativo).

END PROCEDURE.


PROCEDURE CriaHistorico:

    DEF INPUT PARAMETER i-emitente AS INT       NO-UNDO.
    DEF INPUT PARAMETER c-motivo   AS CHARACTER NO-UNDO.
    DEF INPUT PARAMETER l-ativo    AS LOGICAL   NO-UNDO.  

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST int-emitente-historico
        WHERE int-emitente-historico.cod-emitente = i-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL INT-emitente-historico THEN 
        ASSIGN i-sequencia = 1.
    ELSE
        ASSIGN i-sequencia = int-emitente-historico.sequencia + 1.

    CREATE int-emitente-historico.
    ASSIGN int-emitente-historico.cod-emitente = i-emitente
           int-emitente-historico.sequencia    = i-sequencia
           int-emitente-historico.dt-movto     = TODAY
           int-emitente-historico.hr-movto     = STRING(TIME,"HH:MM:SS")
           int-emitente-historico.id-ativo     = l-ativo
           int-emitente-historico.motivo       = c-motivo
           int-emitente-historico.usuario      = "Sistema"
           int-emitente-historico.tipo         = 1.

    FIND CURRENT int-emitente-historico NO-LOCK NO-ERROR.
    RELEASE int-emitente-historico.

END PROCEDURE.
