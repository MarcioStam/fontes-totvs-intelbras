/************************************************************************************
** ENVIO DA CONTA (CLIENTE) PARA O SALESFORCE
**********************************************************************************/
{esp/esapi505.i} 

DEF INPUT PARAM pEmitente AS INT NO-UNDO.                                    

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER b01-emitente   FOR emitente. 
DEF VAR externalid        AS CHAR FORMAT "x(40)".

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objEmitNew              AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayEmit               AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-json-new  AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE c-json-old  AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE c-telefone  AS CHAR FORMAT "x(20)" EXTENT 2.
DEFINE VARIABLE c-email     LIKE emitente.e-mail.

// VERIFICA BASE LOGADA 
def var l-producao   AS LOG NO-UNDO.
DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

    EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0008' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:

    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0008'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0008'.
    
    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

END.


RUN pi-gerar-dados-extrato (CHR(13) + CHR(13) + ">> INICIO " ).

/***** Inicio *****/
FIND FIRST emitente WHERE emitente.cod-emitente = pEmitente NO-LOCK NO-ERROR.

IF AVAIL emitente THEN DO:
   


    FIND FIRST es-api-URI 
        WHERE es-api-URI.id-URI = 'integraEmitCRM' NO-LOCK NO-ERROR.

    RUN pi-gerar-dados-extrato (">> Passou 1 ").
    RUN pi-gerar-dados-extrato (">> Emitente " + STRING(emitente.cod-emitente) + " - " + STRING(emitente.nome-abrev)).
    RUN pi-gerar-dados-extrato (">> CGC " + STRING(emitente.cgc)).

   IF AVAIL es-api-URI THEN DO:
      IF l-producao
         THEN ASSIGN c-endereco       = es-api-URI.ent-PRD.
         ELSE ASSIGN c-endereco       = es-api-URI.end-TST.


     /* FIND FIRST unid-feder         
          WHERE  unid-feder.pais                 = emitente.pais
            AND  unid-feder.estado               = emitente.estado       NO-LOCK NO-ERROR. */

      FIND FIRST gr-cli             WHERE gr-cli.cod-gr-cli               = emitente.cod-gr-cli   NO-LOCK NO-ERROR.
      FIND FIRST int-emitente       WHERE int-emitente.cod-emitente       = emitente.cod-emitente NO-LOCK NO-ERROR.
      FIND FIRST int-emitente-canal WHERE int-emitente-canal.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
      FIND FIRST loc-entr           WHERE loc-entr.cod-entrega            = emitente.cod-entrega  NO-LOCK NO-ERROR.
      FIND FIRST int-loc-entr       WHERE loc-entr.cod-entrega            = emitente.cod-entrega  NO-LOCK NO-ERROR.

      RUN pi-gerar-dados-extrato (">> Antes de criar Objeto ").

      // Carrega JSON
      RUN piCriaObjetoEmit(INPUT objEmitNew, OUTPUT c-json-new).

      RUN pi-gerar-dados-extrato (">> Depois de criar Objeto ").

    
      FIND FIRST es-api-log    
           WHERE es-api-log.id-aplicacao = 'CRM'
             AND es-api-log.id-URI       = 'integraEmitCRM' 
             AND es-api-log.id-codigo    = STRING(emitente.cod-emitente)
      EXCLUSIVE-LOCK NO-ERROR.
       
      IF NOT AVAIL es-api-log THEN DO:

         RUN pi-gerar-dados-extrato (">> CRIACAO NOVO CLIENTE es-api-log ").

         FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0  NO-LOCK NO-ERROR.
          
         RUN pi-gerar-dados-extrato (">> AVAIL bf-las-api-log " + STRING( AVAIL bf-las-api-log)).

         CREATE es-api-log.
         ASSIGN es-api-log.seqexec        = IF AVAIL bf-las-api-log THEN bf-las-api-log.seqexec  +  10 ELSE 10  
                es-api-log.id-aplicacao   = 'CRM'
                es-api-log.id-codigo      = STRING(emitente.cod-emitente)
                es-api-log.id-URI         = 'integraEmitCRM'
                es-api-log.end-envio      = c-endereco
                es-api-log.flg-processado = NO
                es-api-log.Origem         = 'Totvs'
                es-api-log.aux            = STRING(emitente.cod-emitente)
                es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
                                
         RUN pi-gerar-dados-extrato (">> DEPOIS DO ASSIGN == AVAIL bf-las-api-log " + STRING( AVAIL bf-las-api-log)).
          
         RUN pi-gerar-dados-extrato (">> c-json " + STRING(c-json-new)).
         
         RUN piIntegraEmit.
      END.
      ELSE DO:
         RUN pi-gerar-dados-extrato (">> ALTERACAO CLIENTE EXISTENTE - es-api-log ").

         c-json-old = es-api-log.cJSON.
         c-json-old = CODEPAGE-CONVERT(c-json-old, "UTF-8":U).

         
         RUN pi-gerar-dados-extrato (">> MUDOU JSON ??? "  + STRING(c-json-old <> c-json-new)).
         RUN pi-gerar-dados-extrato (">> JSON ANTIGO " + STRING(c-json-old)).
    
         IF string(c-json-old) <> string(c-json-new) THEN DO:
            RUN piIntegraEmit.
         END. 
      END.
   END.

END.  
/***** Fim *****/


/************************* Procedures ***********************/
PROCEDURE piIntegraEmit:

    RUN pi-gerar-dados-extrato (">> passou piIntegraEmit ").


    RUN pi-gerar-dados-extrato (">> JSON NOVO " + c-json-new).

    ASSIGN lcEnvio =  c-json-new
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

    ASSIGN es-api-log.cJson = lcEnvio.

    RUN pi-gerar-dados-extrato (INPUT ">> Endereco " + c-endereco).

    RUN pi-gerar-dados-extrato (">> Antes da funcao fc-chamada-1 ").

    IF STRING(lcEnvio) > "" THEN RUN pi-chamada-1.

    RUN pi-gerar-dados-extrato (">> Depois da Funcao fc-chamada-1 ").

    RUN pi-gerar-dados-extrato (">> RETORNO INTEGRA --- " + string(es-api-log.cod-retorno)).
     
      /*
    RUN pi-gerar-dados-extrato (
       'es-api-log.cod-retorno  ' + string(es-api-log.cod-retorno)           + chr(13) +
       'es-api-log.retorno-headers      '  + es-api-log.retorno-headers       + chr(13) +
       'es-api-log.retorno-content-type  ' + es-api-log.retorno-content-type  + chr(13) ).
    */  
       
     //RUN pi-gerar-dados-extrato (">> " + string(es-api-log.cod-retorno)). 


    IF es-api-log.cod-retorno = '200' OR 
       es-api-log.cod-retorno = '201' THEN DO:
       ASSIGN es-api-log.cJson      = c-json-new
              es-api-log.dh-request = NOW.
    END.
    ELSE DO:
       ASSIGN es-api-log.cJson = c-json-new.
    END.

END PROCEDURE.     


PROCEDURE piCriaObjetoEmit:

  DEF INPUT PARAM pObjEmit AS JsonObject.
  DEF OUTPUT PARAM pJson   AS CHAR NO-UNDO.

  DEFINE VARIABLE cJson               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE nature              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE primaryAccount      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE headOrBranchOffice  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE accountOrigin       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dateOfEstablishment AS CHARACTER NO-UNDO.
  DEFINE VARIABLE clientGroup         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pciCategory         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnae                AS CHARACTER NO-UNDO.
  DEFINE VARIABLE deliveryCountry     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE billingCountry      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE deliveryStreet      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE billingStreet       AS CHARACTER NO-UNDO.


  DEFINE VARIABLE clientSubgroup       LIKE int-emitente.guid-subclass.       
  DEFINE VARIABLE isPciParticipant     AS LOGICAL FORMAT "true/false".
  DEFINE VARIABLE concessionExpiration AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE isAlcSales           AS LOGICAL FORMAT "true/false".      
  DEFINE VARIABLE deliveryComplement   LIKE int-emitente.complemento-cob.     
  DEFINE VARIABLE deliveryNumber       LIKE int-emitente.numero-cob.         
  DEFINE VARIABLE billingGroupCode     LIKE int-emitente.cod-gr-cob.

  DEFINE VARIABLE calculationRegime  LIKE int-emitente-canal.RegimeApuracao.  
  DEFINE VARIABLE creditLimitAdopted LIKE int-emitente-canal.LimiteCredito.  
   
  DEFINE VARIABLE billingComplement LIKE int-loc-entr.complemento.
  DEFINE VARIABLE billingNumber     LIKE int-loc-entr.numero.   

  DEFINE VARIABLE billingState  LIKE unid-feder.no-estado. 
  DEFINE VARIABLE deliveryState LIKE unid-feder.no-estado.

  DEFINE VARIABLE formOfTaxation AS CHARACTER   NO-UNDO.
  
  ASSIGN primaryAccount = ""
         clientGroup    = ""
         accountOrigin  = "Acao de Marketing"
         headOrBranchOffice = "Matriz".

  ASSIGN billingComplement = ""
         billingNumber     = "".

  ASSIGN billingState  = ""
         deliveryState = "".    

  ASSIGN clientSubgroup       = ""
         isPciParticipant     = FALSE
         concessionExpiration = ""
         isAlcSales           = FALSE
         deliveryComplement   = ""
         deliveryNumber       = "".

  ASSIGN pciCategory         = ""
         dateOfEstablishment = ""
         calculationRegime   = ""
         creditLimitAdopted  = 0
         cnae                = ""
         formOfTaxation      = "". 

  FIND FIRST mgcad.pais 
       WHERE mgcad.pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.
  ASSIGN deliveryCountry = IF emitente.pais = 'Brasil' THEN 'Brazil' ELSE mgcad.pais.nome-compl
         billingCountry  = IF emitente.pais = 'Brasil' THEN 'Brazil' ELSE mgcad.pais.nome-compl.

  ASSIGN billingGroupCode = 0.

  CASE emitente.natureza:
      WHEN 1 THEN ASSIGN nature = 'Pessoa Fisica'.
      WHEN 2 THEN ASSIGN nature = 'Pessoa Juridica'.
      WHEN 3 THEN ASSIGN nature = 'Estrangeiro'.
      WHEN 4 THEN ASSIGN nature = 'Trading'.
  END CASE.                       

  IF AVAIL int-emitente THEN DO:
     ASSIGN clientSubgroup       = int-emitente.guid-subclass //IF AVAIL int-emitente AND int-emitente.guid-subclass <> "" THEN int-emitente.guid-subclass  ELSE "C6E1494F-6BED-E311-9420-00155D013D39"
            isPciParticipant     = IF int-emitente.ind-participa-canais = 993520001 THEN YES ELSE NO
            //concessionExpiration = IF int-emitente.dt-vcto-concessao <> ? THEN STRING(int-emitente.dt-vcto-concessao) ELSE ""
            isAlcSales           = IF int-emitente.ind-vendas-alc = 1 THEN TRUE ELSE NO 
            deliveryComplement   = int-emitente.complemento
            deliveryNumber       = int-emitente.numero
            deliveryStreet       = int-emitente.logradouro
            billingComplement    = int-emitente.complemento-cob
            billingNumber        = int-emitente.numero-cob
            billingStreet        = int-emitente.logradouro-cob.   

     IF int-emitente.dt-vcto-concessao <> ? THEN 
         ASSIGN concessionExpiration = STRING(YEAR(int-emitente.dt-vcto-concessao),'9999') + '-' + 
                                       STRING(MONTH(int-emitente.dt-vcto-concessao),'99')  + '-' + 
                                       STRING(DAY(int-emitente.dt-vcto-concessao),'99').           
     ELSE 
        ASSIGN concessionExpiration = ''.

     CASE int-emitente.ind-forma-tributo:
        WHEN 1 THEN ASSIGN formOfTaxation = "Nao Cumulativo".
        WHEN 2 THEN ASSIGN formOfTaxation = "Cumulativo todo ou em parte".
        WHEN 3 THEN ASSIGN formOfTaxation = "Simples".
        WHEN 4 THEN ASSIGN formOfTaxation = "Nenhum".
        WHEN 5 THEN ASSIGN formOfTaxation = "Isento".
     END CASE.

     ASSIGN billingGroupCode = int-emitente.cod-gr-cob.
  END.                            

  IF AVAIL int-emitente-canal THEN DO:
     CASE int-emitente-canal.categoria:
           WHEN "0F06766C-8C75-E911-80D7-0050568DB649" THEN ASSIGN pciCategory  = 'B†sico'                    .
           when "42DC7217-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Bronze'                    .
           when "5CCCA4F9-486D-E711-80C8-0050568DB649" then assign pciCategory  = 'N∆o Participante do PCI'   .
           when "D270322D-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Ouro'                      .
           when "16712D22-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Prata'                     .
           when "0802D40D-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Registrada'                . 
           when "68C05902-99EE-E311-940A-00155D013D3B" then assign pciCategory  = 'Distribuidor'              .
           when "16136855-8C75-E911-80D7-0050568DB649" then assign pciCategory  = 'Atacado'                   .
           when "71242AB1-7312-E811-80CD-0050568DED44" then assign pciCategory  = 'Revenda Soluá‰es'          .
           when "9DD90A38-6890-EA11-80DA-0050568DED44" then assign pciCategory  = 'Parceiro Especializado'    .
           when "6C0E2FB7-7312-E811-80CD-0050568DED44" then assign pciCategory  = 'Provedores'                .
           when "76FD363B-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Conta Nomeada'             .
           when "1F886648-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Conta Ades∆o'              .
           when "E0AEB351-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Cliente Final'             .
           when "848EFB66-6EED-E311-9407-00155D013D38" then assign pciCategory  = 'Colaborador'               .
           when "70743A16-BA10-E711-80C5-0050568D81BB" then assign pciCategory  = 'Soluá‰es e Projetos'       .
           when "71ED219F-2367-E711-80C8-0050568DB649" then assign pciCategory  = 'Mercado Externo'           .
           when "A32D4FFF-E175-E711-80C8-0050568DB649" then assign pciCategory  = 'Cliente EAD'               .
           when "B842E3AD-D2CA-E711-80CC-0050568DED44" then assign pciCategory  = 'Venda Direta'              .
           when "CE3EF2B4-D2CA-E711-80CC-0050568DED44" then assign pciCategory  = 'Venda Indireta'            .
           when "4AB937F9-6F0F-E911-80D8-0050568DED44" then assign pciCategory  = 'Varejo'                    .
     END CASE.

     IF int-emitente-canal.DataConstituicao <> ? THEN
         ASSIGN dateOfEstablishment = STRING(YEAR(int-emitente-canal.DataConstituicao),'9999') + '-' + 
                                      STRING(MONTH(int-emitente-canal.DataConstituicao),'99')  + '-' + 
                                      STRING(DAY(int-emitente-canal.DataConstituicao),'99').  
     ELSE 
        ASSIGN dateOfEstablishment = "".

     ASSIGN calculationRegime  = int-emitente-canal.RegimeApuracao
            creditLimitAdopted = int-emitente-canal.LimiteCredito
            cnae               = int-emitente-canal.cnae.
    

     IF int-emitente-canal.cod-emitente = int-emitente-canal.cod-emitente-matriz
     OR int-emitente-canal.cod-emitente-matriz = 0 THEN 
         ASSIGN primaryAccount = ""
                headOrBranchOffice = "Matriz".
     ELSE DO:
         FIND FIRST b01-emitente 
              WHERE b01-emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-LOCK NO-ERROR.
         IF AVAIL b01-emitente THEN DO:
             ASSIGN headOrBranchOffice = "Filial".
            FIND FIRST mgcad.pais 
                 WHERE pais.nome-pais = b01-emitente.pais NO-LOCK NO-ERROR.
            IF AVAIL mgcad.pais 
               THEN ASSIGN primaryAccount = STRING(substr(pais.char-1,23,2),"!!") + b01-emitente.cgc.
               ELSE ASSIGN primaryAccount = "BR" + b01-emitente.cgc.
         END.
     END.
     
     EMPTY TEMP-TABLE tt-prog-ponto.

     RUN esp/es0018p.p (INPUT "eswso0008":U,
                        INPUT 1,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto
        WHERE INT(ENTRY(1,tt-prog-ponto.conteudo)) = int-emitente-canal.OrigemConta:

        ASSIGN accountOrigin = ENTRY(2,tt-prog-ponto.conteudo).
        
    END.
     
     
     RUN pi-gerar-dados-extrato (">> PrimaryAccount " + STRING(primaryAccount)).
  END.

  IF AVAIL gr-cli THEN
     ASSIGN clientGroup = STRING(gr-cli.cod-gr-cli).

  IF AVAIL int-emitente THEN DO:
     IF int-emitente.guid-subclass = '' THEN
        ASSIGN clientGroup = ''.
  END.
  
  /*
  IF AVAIL int-loc-entr THEN 
     ASSIGN billingComplement = int-loc-entr.complemento
            billingNumber     = int-loc-entr.numero.*/

  FIND FIRST unid-feder         
       WHERE unid-feder.pais   = emitente.pais
         AND unid-feder.estado = emitente.estado NO-LOCK NO-ERROR.
  IF AVAIL unid-feder THEN
     ASSIGN deliveryState = unid-feder.no-estado.    

  FIND FIRST unid-feder         
       WHERE unid-feder.pais   = emitente.pais
         AND unid-feder.estado = emitente.estado-cob NO-LOCK NO-ERROR.
  IF AVAIL unid-feder THEN
     ASSIGN billingState  = unid-feder.no-estado.
   
  FIND FIRST mgcad.pais 
       WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.
  IF AVAIL mgcad.pais AND substr(pais.char-1,23,2) <> ''
     THEN ASSIGN externalid = STRING(substr(pais.char-1,23,2),"!!") + emitente.cgc.
     ELSE ASSIGN externalid = "BR" + emitente.cgc.



  /* Cria JSON */
  arrayEmit  = NEW JsonArray().
  pObjEmit   = NEW JsonObject().

  RUN PI-ajusta-email-telefone.

  pObjEmit:ADD("externalId",                  TRIM(externalid)).             
  pObjEmit:ADD("corporateName",               emitente.nome-emit      ).             
  pObjEmit:ADD("fantasyName",                 IF emitente.nom-fantasia <> '' THEN emitente.nom-fantasia ELSE emitente.nome-emit   ).             
  pObjEmit:ADD("nature",                      nature                  ).
  pObjEmit:ADD("documentNumber",              emitente.cgc            ).
  pObjEmit:ADD("customerCode",                emitente.cod-emitente   ).
  pObjEmit:ADD("shortName",                   emitente.nome-abrev     ).
  pObjEmit:ADD("email",                       c-email         ).
  pObjEmit:ADD("headOrBranchOffice",          headOrBranchOffice      ).
  pObjEmit:ADD("primaryAccount",              primaryAccount          ).
  pObjEmit:ADD("accountOrigin",               accountOrigin           ).
  pObjEmit:ADD("municipalRegistration",       emitente.ins-municipal  ).
  pObjEmit:ADD("stateRegistration",           emitente.ins-estadual   ).
  /*pObjEmit:ADD("cnae",                        cnae ).*/

  pObjEmit:ADD("dateOfEstablishment",         dateOfEstablishment     ).

  FIND FIRST crm-relacionamento-cliente
       WHERE crm-relacionamento-cliente.cod-emitente = emitente.cod-emitente
         AND crm-relacionamento-cliente.dt-vigencia-ini <= TODAY
         AND crm-relacionamento-cliente.dt-vigencia-fim = ? NO-LOCK NO-ERROR.
  IF AVAIL crm-relacionamento-cliente THEN
     pObjEmit:ADD("agent",                       STRING(crm-relacionamento-cliente.cod-rep)).
  ELSE 
     pObjEmit:ADD("agent",                       STRING(emitente.cod-rep)).

  pObjEmit:ADD("mainPhone",                   c-telefone[1]           ).
  pObjEmit:ADD("otherPhone",                  c-telefone[2]           ).
  pObjEmit:ADD("clientGroup",                 clientGroup             ).
  pObjEmit:ADD("clientSubgroup",              clientSubgroup          ).
  pObjEmit:ADD("pciCategory",                 pciCategory             ).
  pObjEmit:ADD("isPciParticipant",            isPciParticipant        ).
  pObjEmit:ADD("suframaCode",                 emitente.cod-suframa    ).
  pObjEmit:ADD("icmsTxpayer",                 emitente.contrib-icms   ).
  pObjEmit:ADD("concessionExpiration",        concessionExpiration    ).
  pObjEmit:ADD("taxSubstitutionRegistration", emitente.insc-subs-trib ).
  pObjEmit:ADD("formOfTaxation",              formOfTaxation          ).
  pObjEmit:ADD("calculationRegime",           calculationRegime       ).
  pObjEmit:ADD("isAlcSales",                  isAlcSales              ).
  pObjEmit:ADD("currency",                    STRING(emitente.moeda-libcre)   ).
  pObjEmit:ADD("creditLimitAdopted",          creditLimitAdopted      ).
  pObjEmit:ADD("billingDistrict",             emitente.bairro-cob     ).
  pObjEmit:ADD("billingCep",                  emitente.cep-cob        ).
  pObjEmit:ADD("billingComplement",           billingComplement       ).
  pObjEmit:ADD("billingStreet",               billingStreet           ).
  pObjEmit:ADD("billingCity",                 emitente.cidade-cob     ).
  pObjEmit:ADD("billingNumber",               billingNumber           ).
  pObjEmit:ADD("billingState",                billingState            ).
  pObjEmit:ADD("billingCountry",              billingCountry          ).
  pObjEmit:ADD("deliveryDistrict",            emitente.bairro         ).
  pObjEmit:ADD("deliveryCep",                 emitente.cep            ).
  pObjEmit:ADD("deliveryComplement",          deliveryComplement      ).
  pObjEmit:ADD("deliveryStreet",              deliveryStreet          ).
  pObjEmit:ADD("deliveryCity",                emitente.cidade         ).
  pObjEmit:ADD("deliveryNumber",              deliveryNumber          ).
  pObjEmit:ADD("deliveryState",               deliveryState           ).
  pObjEmit:ADD("deliveryCountry",             deliveryCountry         ).
  pObjEmit:ADD("isActive",                    int-emitente.id-ativo   ).

  pObjEmit:ADD("financialStatus",{adinc/i10ad098.i 04 emitente.ind-cre-cli}).
  pObjEmit:ADD("billingGroupCode",            billingGroupCode        ).
  
  pObjEmit:ADD("availableLimit",            emitente.lim-credito    ).
  arrayEmit:ADD(pObjEmit).

  ASSIGN cJson = JsonAPIUtils:getJsonArrayChar(arrayEmit).

  ASSIGN pJson = cJson.
  
  /*
  MESSAGE cJson
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
END.

PROCEDURE pi-chamada-1.
    DEF VAR JsonString     AS LONGCHAR                      NO-UNDO.
    DEF VAR oRequest       as IHttpRequest                  NO-UNDO.
    DEF VAR oResponse      as IHttpResponse                 NO-UNDO.
    DEF VAR oJsonObject    AS JsonObject                    NO-UNDO.
    DEF VAR oJsonEntity    AS JsonArray                     NO-UNDO.
    DEF VAR oClient        AS IHttpClient                   NO-UNDO.
    DEF VAR myLongchar     AS LONGCHAR                      NO-UNDO.
    DEF VAR myParser       AS ObjectModelParser             NO-UNDO.
    DEF VAR Json           AS JsonObject                    NO-UNDO.
    DEF VAR cAux           AS LONGCHAR                      NO-UNDO.

    ASSIGN cAux = es-api-log.cJSON.

    IF cAux > "" THEN DO:

       CLIPBOARD:VALUE = cAux.

       myLongchar = es-api-log.cJSON.
       myLongchar = CODEPAGE-CONVERT(myLongchar, "UTF-8":U).

       ASSIGN es-api-log.cl-envio = myLongchar.

       myParser = NEW ObjectModelParser().

       Json = CAST(myParser:Parse(myLongchar), JsonObject).
    END.

    oRequest = RequestBuilder:Post(c-endereco, Json)
              :ContentType('application/json')
              :AcceptJson()
              :Request.
     
    oResponse = ClientBuilder:Build():Client:EXECUTE(oRequest) NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
           RUN piErro (ERROR-STATUS:GET-MESSAGE(i),"").
        END.
    END.

    CASE TRUE:
        WHEN TYPE-OF(oResponse:Entity, JsonObject) 
        THEN DO:
           oJsonObject = CAST(oResponse:Entity, JsonObject). 
           JsonString = STRING(oJsonObject:getJsonText()).
        END.
    END CASE.

    COPY-LOB JsonString TO es-api-log.cl-retorno.

    IF oResponse:StatusCode >= 300
    THEN DO:
       RUN piErro ("Ocorreram erros no envio - " + 
                   STRING(oResponse:statusCode)  + 
                   " - " + 
                   STRING(oResponse:StatusReason) + 
                   STRING(JsonString)
                   ,"").
    END.


    ASSIGN es-api-log.retorno-content-type = oResponse:ContentType 
           es-api-log.cod-retorno          = STRING(oResponse:StatusCode)
           es-api-log.dh-retorno           = NOW.

    RETURN es-api-log.cod-retorno.

END PROCEDURE.


PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put UNFORMATTED "     " + c-lbl-liter-ponto-executado + ": " p-string " - " + STRING(DATETIME(TODAY, MTIME)) skip.
        output close. 
    
    end.
END.

PROCEDURE PI-ajusta-email-telefone.
DEF VAR i-cont AS INT.
DEF VAR c-aux AS CHAR INIT '(,),-,*,_,/, ,.,],[,+,?,R'.
DEF VAR i AS INT.


      ASSIGN c-email = emitente.e-mail 
             c-telefone[1] = emitente.telefone[1]
             c-telefone[2] = emitente.telefone[2].

      IF e-mail = '' THEN ASSIGN e-mail = 'sem_email@intelbras.com.br'.


       IF c-telefone[1] BEGINS '0' THEN
          ASSIGN c-telefone[1] = SUBSTR(c-telefone[1],2,15).

       IF c-telefone[2] BEGINS '0' THEN
          ASSIGN c-telefone[2] = SUBSTR(c-telefone[2],2,15).

       IF c-telefone[1] = '' THEN do:
          IF c-telefone[2] <> '' THEN ASSIGN c-telefone[1] = c-telefone[2].
                               ELSE ASSIGN c-telefone[1] = '11900000000'.
       END.

       i = 0.
       DO i = 1 TO LENGTH(c-telefone[1]):
           IF LOOKUP(SUBSTR(c-telefone[1],i,1), c-aux) <> 0 THEN DO:
             c-telefone[1] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[1],"/",""),"-",""),"(",""),")","")," ","").
             c-telefone[1] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[1],"*",""),"_",""),".",""),",",""),"[","").
             c-telefone[1] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[1],"]",""),"+",""),"?",""),"R","")," ","").
           END.
       END.

       i = 0.
       DO i = 1 TO LENGTH(c-telefone[2]):
           IF LOOKUP(SUBSTR(c-telefone[2],i,1), c-aux) <> 0 THEN DO:
             c-telefone[2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[2],"/",""),"-",""),"(",""),")","")," ","").
             c-telefone[2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[2],"*",""),"_",""),".",""),",",""),"[","").
             c-telefone[2] = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c-telefone[2],"]",""),"+",""),"?",""),"R",""),"\","").
          END.
       END.


      IF c-telefone[1] <> '' AND length(c-telefone[1]) < 10 THEN DO:
         IF length(c-telefone[2]) >= 10 THEN
             ASSIGN c-telefone[1] = c-telefone[2].
         ELSE 
             ASSIGN c-telefone[1] = '11900000000'.
      END.

      IF c-telefone[2] <> '' AND length(c-telefone[2]) < 10 THEN
         ASSIGN c-telefone[2] = '' .

      IF length(c-telefone[2]) > 11 THEN
         ASSIGN c-telefone[2] = ''.

      IF length(c-telefone[1]) = 11 THEN 
         ASSIGN c-telefone[1] = SUBSTR(c-telefone[1],1,2) + '9' + substr(c-telefone[1],4,8).

      IF length(c-telefone[2]) = 11 THEN 
         ASSIGN c-telefone[2] = SUBSTR(c-telefone[2],1,2) + '9' + substr(c-telefone[2],4,8).

END PROCEDURE.

