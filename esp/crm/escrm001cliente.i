/******************************************************************************
**  Programa.: ESCRM001CLIENTE.I
**  Objetivo.: Execu‡Æo do processamento de integra‡Æo do cliente (Matriz ou
**             filial) do Datasul EMS 2 com o Microsoft CRM Dynamics.
**  Autor....: Fabiano Sakae Ribeiro    - Exponencial TI - 09.08.2010
*******************************************************************************/

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Emitente: ":U + STRING(emitente.nome-abrev)).
  
  
CREATE tt-cliente.

FIND FIRST int-emitente
    WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
FIND FIRST int-emitente-cex
    WHERE int-emitente-cex.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
  
/* IF AVAILABLE int-emitente       AND                         */
/*    int-emitente.vl-guid <> "":U AND                         */
/*    int-emitente.vl-guid <> ?    THEN DO:                    */
/*     CREATE tt-atributo.                                     */
/*     ASSIGN tt-atributo.r-temp-table = ROWID(tt-cliente)     */
/*            tt-atributo.nome-campo   = "cod-emitente":U      */
/*            tt-atributo.nome-atrib   = "crmid":U             */
/*            tt-atributo.vl-atrib     = int-emitente.vl-guid. */
/* END.                                                        */

FIND FIRST b-emitente
    WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.

IF AVAILABLE b-emitente THEN DO:
    FIND FIRST int-emitente
        WHERE int-emitente.cod-emitente = b-emitente.cod-emitente NO-LOCK NO-ERROR.

/*     IF AVAILABLE int-emitente       AND                         */
/*        int-emitente.vl-guid <> "":U AND                         */
/*        int-emitente.vl-guid <> ?    THEN DO:                    */
/*         CREATE tt-atributo.                                     */
/*         ASSIGN tt-atributo.r-temp-table = ROWID(tt-cliente)     */
/*                tt-atributo.nome-campo   = "nome-matriz":U       */
/*                tt-atributo.nome-atrib   = "crmid":U             */
/*                tt-atributo.vl-atrib     = int-emitente.vl-guid. */
/*     END.                                                        */
END.

FIND FIRST int-emitente
    WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

FIND FIRST emitente-cex
    WHERE emitente-cex.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

FIND FIRST int-emitente-b2c
    WHERE int-emitente-b2c.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    
ASSIGN tt-cliente.cod-emitente             = emitente.cod-emitente
       tt-cliente.nome-emit                = substring(TRIM(emitente.nome-emit),1,40)
       tt-cliente.nome-abrev               = TRIM(emitente.nome-abrev)
       tt-cliente.nome-matriz              = IF AVAILABLE b-emitente THEN b-emitente.cod-emitente ELSE -1
       tt-cliente.identific                = emitente.identific                    
       tt-cliente.address1_addresstypecode = 3
       tt-cliente.address1_name            = "Principal":U
       tt-cliente.cep                      = TRIM(emitente.cep)
       tt-cliente.endereco                 = IF AVAIL int-emitente AND int-emitente.logradouro <> "" THEN int-emitente.logradouro ELSE substring(TRIM(emitente.endereco),1,040)
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
       tt-cliente.i-susp-ipi               = trim(emitente.char-1) = "2":U
       tt-cliente.agente-retencao          = emitente.agente-retencao
       tt-cliente.i-calc-pis-cofins-unid   = emitente.log-calcula-pis-cofins-unid
       tt-cliente.i-recebe-nfe             = emitente.log-nf-eletro
       tt-cliente.ind-forma-tributo        = IF AVAILABLE int-emitente     THEN int-emitente.ind-forma-tributo  ELSE 4
       tt-cliente.vl-desconto-cat          = IF AVAILABLE int-emitente     THEN int-emitente.vl-desconto-cat    ELSE 0
       tt-cliente.tipo-embalagem           = IF AVAILABLE int-emitente     THEN int-emitente.tipo-embalagem     ELSE "":U
       tt-cliente.observacao-ped           = IF AVAILABLE int-emitente     THEN int-emitente.observacao-ped     ELSE "":U
       tt-cliente.dispositivo-legal        = IF AVAILABLE int-emitente     THEN int-emitente.dispositivo-legal  ELSE "":U
       tt-cliente.dt-vcto-concessao        = IF AVAILABLE int-emitente     THEN int-emitente.dt-vcto-concessao  ELSE ?
       tt-cliente.cod-incoterm-exp         = IF AVAILABLE emitente-cex     THEN emitente-cex.cod-incoterm-exp   ELSE "":U
       tt-cliente.local-embarque           = IF AVAILABLE int-emitente-cex THEN substring(int-emitente-cex.local-embarque,1,20) ELSE "":U
       tt-cliente.embarque-via             = IF AVAILABLE int-emitente-cex THEN int-emitente-cex.embarque-via   ELSE "":U
       tt-cliente.new_exporta_erp          = "":U
       tt-cliente.new_mensagem             = "":U
       tt-cliente.data-implant             = emitente.data-implant
       tt-cliente.new_status_integracao    = "Integrado com sucesso.":U
       tt-cliente.new_status_cadastro      = 2
       tt-cliente.donotsendmm              = IF AVAILABLE int-emitente-b2c AND int-emitente-b2c.Newsletter = "Sim":U THEN YES ELSE NO
       tt-cliente.donotbulkemail           = IF AVAILABLE int-emitente-b2c AND int-emitente-b2c.Newsletter = "Sim":U THEN YES ELSE NO
       tt-cliente.ind-participa-canais     = int-emitente.cod-guid                      /* ‚ enviado o guid para o crm4 saber que ‚ pertencente ao programa de canais */
       tt-cliente.nro-passaporte           = SUBSTRING(emitente.char-1,103,20).

ASSIGN tt-cliente.endereco = TRIM(ENTRY(1, emitente.endereco, ",":U)).

IF NUM-ENTRIES(emitente.endereco, ",":U) >= 2 THEN DO:
    IF AVAIL int-emitente AND int-emitente.logradouro <> "" THEN
        ASSIGN tt-cliente.new_numero_endereco_principal = int-emitente.numero.
    ELSE IF NUM-ENTRIES(TRIM(ENTRY(2, emitente.endereco, ",":U)), "-":U) >= 2 THEN
        ASSIGN tt-cliente.new_numero_endereco_principal = TRIM(ENTRY(1, TRIM(ENTRY(2, emitente.endereco, ",":U)), "-":U)).
    ELSE
        ASSIGN tt-cliente.new_numero_endereco_principal = TRIM(ENTRY(2, emitente.endereco, ",":U)).
END.

IF AVAIL int-emitente AND int-emitente.complemento <> "" THEN
    ASSIGN tt-cliente.address1_line2 = int-emitente.complemento.
ELSE IF NUM-ENTRIES(emitente.endereco, "-":U) >= 2 THEN
    ASSIGN tt-cliente.address1_line2 = TRIM(ENTRY(NUM-ENTRIES(emitente.endereco, "-":U), emitente.endereco, "-":U)).

ASSIGN tt-cliente.endereco-cob = TRIM(ENTRY(1, emitente.endereco-cob, ",":U)).

IF NUM-ENTRIES(emitente.endereco-cob, ",":U) >= 2 THEN DO:
    IF NUM-ENTRIES(TRIM(ENTRY(2, emitente.endereco-cob, ",":U)), "-":U) >= 2 THEN
        ASSIGN tt-cliente.new_numero_endereco_cobranca = TRIM(ENTRY(1, TRIM(ENTRY(2, emitente.endereco-cob, ",":U)), "-":U)).
    ELSE
        ASSIGN tt-cliente.new_numero_endereco_cobranca = TRIM(ENTRY(2, emitente.endereco-cob, ",":U)).
END.

IF NUM-ENTRIES(emitente.endereco-cob, "-":U) >= 2 THEN
    ASSIGN tt-cliente.address2_line2 = TRIM(ENTRY(NUM-ENTRIES(emitente.endereco-cob, "-":U), emitente.endereco-cob, "-":U)).

IF  AVAIL int-emitente THEN
    ASSIGN tt-cliente.ind-vendas-alc = IF int-emitente.ind-vendas-alc = 1 THEN YES ELSE NO.
ELSE
    ASSIGN tt-cliente.ind-vendas-alc = NO.


IF emitente.nome-tr-red <> "" THEN DO:
    FIND transporte
        WHERE transporte.nome-abrev = emitente.nome-tr-red
        NO-LOCK NO-ERROR.
    IF AVAIL transporte THEN DO:
        ASSIGN tt-cliente.nome-tr-red = string(transporte.cod-transp).
    END.
END.
               
/* Campos que devem integrar EMS/CRM mas nao podem ser enviados do CRM/EMS */
      
assign tt-cliente.lim-credito              = emitente.lim-credito
       tt-cliente.dt-lim-credito           = emitente.dt-lim-cred         
       tt-cliente.portador                 = emitente.portador
       tt-cliente.cod-banco                = emitente.cod-banco
       tt-cliente.agencia                  = TRIM(emitente.agencia)
       tt-cliente.conta-corren             = emitente.conta-corren
       tt-cliente.tp-rec-padrao            = emitente.tp-rec-padrao
       tt-cliente.calcula-multa            = emitente.calcula-multa 
       tt-cliente.cod-cond-pag             = IF emitente.cod-cond-pag = 0 THEN "":U ELSE STRING(emitente.cod-cond-pag)
       tt-cliente.emite-bloq               = emitente.emite-bloq
       tt-cliente.gera-ad                  = emitente.gera-ad
       tt-cliente.recebe-inf-sci           = emitente.recebe-inf-sci.  
       
   if emitente.modalidade > 0 then 
      assign tt-cliente.modalidade = emitente.modalidade.
   else 
      assign tt-cliente.modalidade = 99.
         
   IF AVAILABLE int-emitente     THEN 
      IF int-emitente.id-ativo = YES THEN
          ASSIGN tt-cliente.id-ativo = 1.
       ELSE
          ASSIGN tt-cliente.id-ativo = 200000.
   ASSIGN
       pContaLinhasTrace                   = pContaLinhasTrace + 1.

IF tt-cliente.cod-emitente = tt-cliente.nome-matriz THEN DO:
    ASSIGN tt-cliente.nome-matriz = -1.

    FOR EACH tt-atributo
        WHERE tt-atributo.r-temp-table = ROWID(tt-cliente)
          AND tt-atributo.nome-campo = "nome-matriz":U:
        DELETE tt-atributo.
    END.
END.

CASE emitente.natureza:
    WHEN 1 THEN DO:
        ASSIGN tt-cliente.new_cpf = STRING(emitente.cgc, param-global.formato-id-pessoal)
               /* tt-cliente.new_rg  = emitente.ins-estadual      colacamos em comet rio / perguntar para o TETSUO */
               tt-cliente.ins-estadual = emitente.ins-estadual.
    END.
    WHEN 2 THEN DO:

        /* Retirado para nao enviar com mascara */

        ASSIGN tt-cliente.cgc          = STRING(emitente.cgc, param-global.formato-id-federal)
               tt-cliente.ins-estadual = emitente.ins-estadual.
    END.    
    WHEN 3 THEN DO:
       IF emitente.cgc = ""  THEN 
         ASSIGN tt-cliente.cgc = string(emitente.cod-emitente).
       else 
         ASSIGN tt-cliente.cgc          = emitente.cgc.
        
       ASSIGN tt-cliente.ins-estadual = emitente.ins-estadual.
    END.
    OTHERWISE DO:
        ASSIGN tt-cliente.cgc          = emitente.cgc
               tt-cliente.ins-estadual = emitente.ins-estadual.
    END.

    
END CASE.

/* Envia CNPJ ou CPF sem mascara */
ASSIGN tt-cliente.new_sem_masc_cnpj_cpf = emitente.cgc.


