/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: esp/crm/escrm006.p
**  Objetivo: M‚todo de Acesso: Buscar_DadosClientes (somente consulta)
**  Autor...: Intelbras - USER    
**  Data....: setembro/2010
*******************************************************************************/
/*                         
Parƒmetro de Entrada:  CPF/CGC
Parƒmetros de Sa¡da:   tabela temporaria tt-cliente (mesma definicao enviada para o CRM pelo xml)
*/

DEFINE TEMP-TABLE tt-cliente NO-UNDO
    FIELD cod-emitente             LIKE emitente.cod-emitente
    FIELD nome-emit                LIKE emitente.nome-emit
    FIELD nome-abrev               LIKE emitente.nome-abrev
    FIELD nome-matriz              LIKE emitente.cod-emitente
    FIELD identific                LIKE emitente.identific
    FIELD portador                 LIKE emitente.portador
    FIELD cod-banco                LIKE emitente.cod-banco
    FIELD agencia                  LIKE emitente.agencia
    FIELD conta-corren             LIKE emitente.conta-corren
    FIELD tp-rec-padrao            LIKE emitente.tp-rec-padrao
    FIELD cod-cond-pag             AS CHARACTER
    FIELD emite-bloq               LIKE emitente.emite-bloq
    FIELD gera-ad                  LIKE emitente.gera-ad
    FIELD calcula-multa            LIKE emitente.calcula-multa
    FIELD recebe-inf-sci           LIKE emitente.recebe-inf-sci
    FIELD address1_addresstypecode AS INT
    FIELD address1_name            AS CHAR
    FIELD CEP                      LIKE emitente.CEP
    FIELD endereco                 LIKE emitente.endereco
    FIELD Bairro                   LIKE emitente.Bairro
    FIELD Cidade                   LIKE emitente.Cidade
    FIELD Estado                   LIKE emitente.Estado
    FIELD Pais                     LIKE emitente.Pais
    FIELD address2_addresstypecode AS INT
    FIELD address2_name            AS CHAR
    FIELD cep-cob                  LIKE emitente.cep-cob                   
    FIELD endereco-cob             LIKE emitente.endereco-cob
    FIELD bairro-cob               LIKE emitente.bairro-cob
    FIELD cidade-cob               LIKE emitente.cidade-cob
    FIELD estado-cob               LIKE emitente.estado-cob
    FIELD pais-cob                 LIKE emitente.pais-cob
    FIELD telephone                LIKE emitente.telefone[1]
    FIELD ramal                    LIKE emitente.ramal[1] 
    FIELD telephone2               LIKE emitente.telefone[2]
    FIELD ramal2                   LIKE emitente.ramal[2]
    FIELD fax                      LIKE emitente.telefax  
    FIELD ramalfax                 LIKE emitente.ramal-fax 
    FIELD email                    LIKE emitente.e-mail
    FIELD home-page                LIKE emitente.home-page
    FIELD cod-rep                  LIKE emitente.cod-rep
    FIELD natureza                 LIKE emitente.natureza
    FIELD cgc                      LIKE emitente.cgc
    FIELD ins-estadual             LIKE emitente.ins-estadual
    FIELD ins-municipal            LIKE emitente.ins-municipal
    FIELD cod-gr-cli               LIKE emitente.cod-gr-cli
    FIELD lim-credito              AS   CHAR
    FIELD dt-lim-credito           AS   CHAR
    FIELD modalidade               LIKE emitente.modalidade     
    FIELD contrib-icms             LIKE emitente.contrib-icms   
    FIELD cod-suframa              LIKE emitente.cod-suframa    
    FIELD cod-transp               LIKE emitente.cod-transp     
    FIELD cod-canal-venda          LIKE emitente.cod-canal-venda
    FIELD insc-subs-trib           LIKE emitente.insc-subs-trib
    FIELD i-susp-ipi               AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD agente-retencao          LIKE emitente.agente-retencao
    FIELD i-calc-pis-cofins-unid   AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD i-recebe-nfe             AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO
    FIELD ind-forma-tributo        LIKE int-emitente.ind-forma-tributo
    FIELD vl-desconto-cat          LIKE int-emitente.vl-desconto-cat
    FIELD tipo-embalagem           LIKE int-emitente.tipo-embalagem
    FIELD observacao-ped           LIKE int-emitente.observacao-ped
    FIELD dispositivo-legal        LIKE int-emitente.dispositivo-legal
    FIELD dt-vcto-concessao        AS   CHAR
    FIELD cod-incoterm-exp         LIKE emitente-cex.cod-incoterm-exp
    FIELD local-embarque           LIKE int-emitente-cex.local-embarque
    FIELD embarque-via             LIKE int-emitente-cex.embarque-via
    FIELD new_exporta_erp          AS CHARACTER
    FIELD new_mensagem             AS CHARACTER
    FIELD data-implant             AS CHAR
    FIELD new_status_integracao    AS CHARACTER
    FIELD new_status_cadastro      AS INTEGER
    FIELD id-ativo                 AS INTEGER 
    FIELD new_cpf                  AS CHARACTER
    FIELD new_rg                   AS CHARACTER
    FIELD ind-vendas-alc           AS LOGICAL INITIAL NO.

DEFINE BUFFER b-emitente FOR emitente.          

DEFINE INPUT  PARAMETER pccgc    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-cliente.

FIND FIRST emitente WHERE 
           emitente.cgc = pccgc NO-LOCK NO-ERROR.
CREATE tt-cliente.      /* Cria temp-table mesmo nao existindo o registro para nao dar erro no CRM */
IF NOT AVAIL emitente 
THEN DO:
   /* Se o cliente for novo e nao existe no ems , mas a matriz existe */

   FOR EACH b-emitente NO-LOCK WHERE
            b-emitente.cgc BEGINS SUBSTRING(pccgc,1,8)  :
          
       FIND FIRST emitente NO-LOCK WHERE
                  emitente.nome-abrev = b-emitente.nome-matriz NO-ERROR.
       IF AVAIL emitente 
       THEN DO:
          IF b-emitente.cod-emitente = emitente.cod-emitente 
          THEN DO:
            ASSIGN tt-cliente.nome-matriz = b-emitente.cod-emitente.
            LEAVE.
          END.
       END.

   END.

   RETURN "OK".
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST emitente-cex WHERE 
           emitente-cex.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

FIND FIRST int-emitente-cex WHERE 
           int-emitente-cex.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

FIND FIRST int-emitente WHERE 
           int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

FIND FIRST b-emitente WHERE 
           b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.

IF emitente.identific = 2 THEN  /* Fornecedor / Passa a ser ambos */
  ASSIGN tt-cliente.identific = 3. /* Ambos */
ELSE 
  ASSIGN tt-cliente.identific = emitente.identific.

ASSIGN tt-cliente.cod-emitente             = emitente.cod-emitente
       tt-cliente.nome-emit                = substring(TRIM(emitente.nome-emit),1,40)
       tt-cliente.nome-abrev               = TRIM(emitente.nome-abrev)
       tt-cliente.nome-matriz              = IF AVAILABLE b-emitente THEN b-emitente.cod-emitente ELSE -1
       tt-cliente.address1_addresstypecode = 3
       tt-cliente.address1_name            = "Principal":U
       tt-cliente.cep                      = TRIM(emitente.cep)
       tt-cliente.endereco                 = substring(TRIM(emitente.endereco),1,040)
       tt-cliente.bairro                   = substring(TRIM(emitente.bairro),1,030)
       tt-cliente.cidade                   = substring(TRIM(emitente.cidade),1,25)
       tt-cliente.estado                   = TRIM(emitente.estado)
       tt-cliente.pais                     = TRIM(emitente.pais)
       tt-cliente.address2_addresstypecode = 200000
       tt-cliente.address2_name            = "Cobran‡a":U
       tt-cliente.cep-cob                  = TRIM(emitente.cep-cob)
       tt-cliente.endereco-cob             = substring(TRIM(emitente.endereco-cob),1,40)
       tt-cliente.bairro-cob               = SUBSTRING(TRIM(emitente.bairro-cob),1,30)
       tt-cliente.cidade-cob               = substring(TRIM(emitente.cidade-cob),1,25)
       tt-cliente.estado-cob               = TRIM(emitente.estado-cob)
       tt-cliente.pais-cob                 = TRIM(emitente.pais-cob)
       tt-cliente.telephone                = TRIM(emitente.telefone[1])
       tt-cliente.ramal                    = substring(TRIM(emitente.ramal[1]),1,5)
       tt-cliente.telephone2               = TRIM(emitente.telefone[2])
       tt-cliente.ramal2                   = substring(TRIM(emitente.ramal[2]),1,5)
       tt-cliente.fax                      = TRIM(emitente.telefax)
       tt-cliente.ramalfax                 = substring(TRIM(emitente.ramal-fax),1,5)
       tt-cliente.email                    = substring(TRIM(emitente.e-mail),1,40)
       tt-cliente.home-page                = TRIM(emitente.home-page)
       tt-cliente.cod-rep                  = emitente.cod-rep
       tt-cliente.natureza                 = emitente.natureza
       tt-cliente.ins-municipal            = emitente.ins-municipal
       tt-cliente.cod-gr-cli               = emitente.cod-gr-cli       
       tt-cliente.contrib-icms             = emitente.contrib-icms
       tt-cliente.cod-suframa              = emitente.cod-suframa
       tt-cliente.cod-transp               = emitente.cod-transp
       tt-cliente.cod-canal-venda          = emitente.cod-canal-venda
       tt-cliente.insc-subs-trib           = emitente.insc-subs-trib
       tt-cliente.i-susp-ipi               = TRIM(emitente.char-1) = "2":U
       tt-cliente.agente-retencao          = emitente.agente-retencao
       tt-cliente.i-calc-pis-cofins-unid   = emitente.log-calcula-pis-cofins-unid
       tt-cliente.i-recebe-nfe             = emitente.log-nf-eletro
       tt-cliente.ind-forma-tributo        = IF AVAILABLE int-emitente     THEN int-emitente.ind-forma-tributo  ELSE 4
       tt-cliente.vl-desconto-cat          = IF AVAILABLE int-emitente     THEN int-emitente.vl-desconto-cat    ELSE 0
       tt-cliente.tipo-embalagem           = IF AVAILABLE int-emitente     THEN int-emitente.tipo-embalagem     ELSE "":U
       tt-cliente.observacao-ped           = IF AVAILABLE int-emitente     THEN int-emitente.observacao-ped     ELSE "":U
       tt-cliente.dispositivo-legal        = IF AVAILABLE int-emitente     THEN int-emitente.dispositivo-legal  ELSE "":U
       tt-cliente.dt-vcto-concessao        = IF AVAILABLE int-emitente     THEN string(int-emitente.dt-vcto-concessao)  ELSE ""
       tt-cliente.cod-incoterm-exp         = IF AVAILABLE emitente-cex     THEN emitente-cex.cod-incoterm-exp   ELSE "":U
       tt-cliente.local-embarque           = IF AVAILABLE int-emitente-cex THEN substring(int-emitente-cex.local-embarque,1,20) ELSE "":U
       tt-cliente.embarque-via             = IF AVAILABLE int-emitente-cex THEN int-emitente-cex.embarque-via   ELSE "":U
       tt-cliente.new_exporta_erp          = "":U
       tt-cliente.new_mensagem             = "":U
       tt-cliente.data-implant             = string(emitente.data-implant)
       tt-cliente.new_status_integracao    = "Integrado com sucesso.":U
       tt-cliente.new_status_cadastro      = 2.

IF tt-cliente.nome-matriz =  tt-cliente.cod-emitente THEN
   ASSIGN tt-cliente.nome-matriz = -1.

/* Campos que devem integrar EMS/CRM mas nao podem ser enviados do CRM/EMS */

assign tt-cliente.lim-credito              = string(emitente.lim-credito)
       tt-cliente.dt-lim-credito           = string(emitente.dt-lim-cred)         
       tt-cliente.portador                 = emitente.portador
       tt-cliente.cod-banco                = emitente.cod-banco
       tt-cliente.agencia                  = TRIM(emitente.agencia)
       tt-cliente.conta-corren             = emitente.conta-corren
       tt-cliente.tp-rec-padrao            = emitente.tp-rec-padrao
       tt-cliente.calcula-multa            = emitente.calcula-multa 
       tt-cliente.cod-cond-pag             = IF emitente.cod-cond-pag = 0 THEN "":U ELSE STRING(emitente.cod-cond-pag)
       tt-cliente.emite-bloq               = emitente.emite-bloq
       tt-cliente.gera-ad                  = emitente.gera-ad
       tt-cliente.recebe-inf-sci           = emitente.recebe-inf-sci
       tt-cliente.ind-vendas-alc           = IF int-emitente.ind-vendas-alc = 1 THEN YES ELSE NO.
       
   if emitente.modalidade > 0 then 
      assign tt-cliente.modalidade = emitente.modalidade.
   else 
      assign tt-cliente.modalidade = 99.
         
   IF AVAILABLE int-emitente     THEN 
      IF int-emitente.id-ativo = YES THEN
          ASSIGN tt-cliente.id-ativo = 1.
       ELSE
          ASSIGN tt-cliente.id-ativo = 200000.

   CASE emitente.natureza:
        WHEN 1 THEN DO:
            ASSIGN tt-cliente.new_cpf = STRING(emitente.cgc, param-global.formato-id-pessoal)
                   tt-cliente.new_rg  = emitente.ins-estadual.
        END.
        WHEN 2 THEN DO:
            ASSIGN tt-cliente.cgc          = STRING(emitente.cgc, param-global.formato-id-federal)
                   tt-cliente.ins-estadual = emitente.ins-estadual.
        END.
        OTHERWISE DO:
            ASSIGN tt-cliente.cgc          = emitente.cgc
                   tt-cliente.ins-estadual = emitente.ins-estadual.
        END.
   END CASE.

RETURN "OK".
