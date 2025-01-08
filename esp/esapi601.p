block-level on error undo, throw.
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure
/*------------------------------------------------------------------------
    File        :
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{esp/esapi505.i}
{esp/esapi601.i}
{include/tt-edit.i} 
{include/pi-edit.i}
define input parameter h-acomp     as handle  no-undo.
define input parameter i-acao      as integer no-undo.
define input parameter rw-registro as rowid   no-undo.

/* [ ! ] Mover temp-tables para a include */
define temp-table tt-fornecedor    NO-UNDO like emitente.

define temp-table ttSupplier               no-undo      serialize-name "supplier"
    field externalId                       as character serialize-name "externalId"
    field supplierType                     as CHARACTER serialize-name "supplierType"
    field corporateName                    as character serialize-name "corporateName"
    field fantasyName                      as character serialize-name "fantasyName"
    field language                         as character serialize-name "language"
    field comercialContactName             as character serialize-name "comercialContactName"
    field comercialContactEmail            as character serialize-name "comercialContactEmail"
    field comercialContactPhone            as character serialize-name "comercialContactPhone"
   //field legalRepresentativeName          as character serialize-name "legalRepresentativeName"
   //field cpfLegalRepresentative           as character serialize-name "cpfLegalRepresentative"
   //field legalRepresentativeEmail         as character serialize-name "legalRepresentativeEmail"
    field nameContactLogistics             as character serialize-name "nameContactLogistics"
    field logisticsContactEmail            as character serialize-name "logisticsContactEmail"
    field logisticsContactPhone            as character serialize-name "logisticsContactPhone"
    field financialContactEmailName        as character serialize-name "financialContactEmailName"
    field financialContactEmail            as character serialize-name "financialContactEmail"
    field financialContactPhone            as character serialize-name "financialContactPhone"
    field addressCountry                   as character serialize-name "addressCountry"
    field addressStreet                    as character serialize-name "addressStreet"
    field addressNumber                    as character serialize-name "addressNumber"
    field addressComplement                as character serialize-name "addressComplement"
    field addressDistrict                  as character serialize-name "addressDistrict"
    field addressPostalCode                as character serialize-name "addressPostalCode"
    field addressState                     as character serialize-name "addressState"
    field addressCity                      as character serialize-name "addressCity"
    field website                          as character serialize-name "website"
    field bankCode                         as integer   serialize-name "bankCode"
    field bankName                         as character serialize-name "bankName"
    field agency                           as character serialize-name "agency"
    field agencyDigit                      as character serialize-name "agencyDigit"
    field currentAccount                   as character serialize-name "currentAccount"
    field currentAccountDigit              as character serialize-name "currentAccountDigit"
    field bankAddress                      as character serialize-name "bankAddress"
    field currency                         as CHARACTER serialize-name "currency"
    field pixKey                           as character serialize-name "pixKey"
    field keyType                          as character serialize-name "keyType"
    field cnpj                             as character serialize-name "cnpj"
    field municipalRegistration            as character serialize-name "municipalRegistration"
    field stateRegistration                as character serialize-name "stateRegistration"
    field serviceProvider                  as CHARACTER serialize-name "serviceProvider"
    field taxRegime                        as character serialize-name "taxRegime"
    field taxId                            as character serialize-name "taxId"
    field swift                            as character serialize-name "swift"
    field beneficiary	                   as character serialize-name "beneficiary"
    field formOfPayment                    as CHARACTER serialize-name "formOfPayment"
    field supplierGroup                    as CHARACTER serialize-name "supplierGroup"
    field erpSupplierCode                  as integer   SERIALIZE-HIDDEN
    FIELD shipper                          AS INTEGER   SERIALIZE-NAME "shipper"
    FIELD incoterm                         AS CHARACTER SERIALIZE-NAME "incoterm"
    FIELD itinerary                        AS INTEGER   SERIALIZE-NAME "itinerary"
    FIELD checkpoint                       AS INTEGER   SERIALIZE-NAME "checkpoint"
    FIELD acmid                            AS CHAR      SERIALIZE-NAME "acmId"
    FIELD anid                             AS CHAR      SERIALIZE-NAME "anId"
    FIELD paymentTerms                     AS INTEGER   SERIALIZE-NAME "paymentTerms"
    field supplierId                       as integer   SERIALIZE-NAME "supplierId".

define temp-table tt-cont-emit no-undo like cont-emit.
 
/*define temp-table tt-erro                  no-undo
    field codigo                           as integer
    field informacao                       as character
    field mensagem                         as character format "x(250)".*/

define new global shared var l-esapi556 as logical no-undo.

define variable i-cod-emitente      as integer   no-undo.
define variable i-cod-cond-pag      as integer   no-undo.
DEFINE VARIABLE i-cont-emit-seq     AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-file-name         AS CHARACTER NO-UNDO.
define variable cMetodo             as character no-undo.
define variable jsonObjectOutput    as JsonObject. 

define temp-table auxRowErrors no-undo
    like RowErrors.


/** testes */

def temp-table tt_emitente_integr_new no-undo
    field cod_versao_integracao     as integer   format "999"
    field cod_emitente              as integer   format ">>>>>>9"
    field identific                 as integer   format ">9"
    field nome_abrev                as character format "x(12)"
    field nome_matriz               as character format "x(12)"
    field natureza                  as integer   format ">9"
    field cgc                       as character format "x(19)"
    field cod_portador              as integer   format ">>>>9"
    field modalidade                as integer   format "9"
    field conta_corren              as character format "x(20)"
    field agencia                   as character format "x(08)"
    field cod_banco                 as integer   format "999"
    field forn_exp                  as logical   format "Sim/Nío"
    field data_implant              as date      format "99/99/9999"
    field cod_gr_cli                as integer   format ">9"
    field cod_gr_forn               as integer   format ">9"
    field ins_estadual              as character format "x(19)"
    field ins_municipal             as character format "x(19)" 
    field estado                    as character format "x(04)"
    field endereco                  as character format "x(40)"
    field endereco2                 as character format "x(40)"
    field bairro                    as character format "x(30)"
    field cep                       as character format "x(12)"
    field cod_pais                  as character format "x(20)"
    field nome_mic_reg              as character format "x(12)"
    field nom_cidade                as character format "x(25)"
    field caixa_postal              as character format "x(10)"
    field telefax                   as character format "x(15)"
    field ramal_fax                 as character format "x(05)"
    field telex                     as character format "x(15)"
    field telefone                  as character format "x(15)" extent 2
    field ramal                     as character format "x(05)" extent 2
    field telef_modem               as character format "x(15)"
    field ramal_modem               as character format "x(05)"
    field zip_code                  as character format "x(12)"
    field tp_pagto                  as integer   format "99"
    field emite_bloq                as logical   format "Sim/Nío"
    field ins_banc                  as integer   format ">>9"   extent 2
    field ven_sabado                as integer   format "9"
    field ven_domingo               as integer   format "9"
    field ven_feriado               as integer   format "9"
    field e_mail                    as character format "x(40)"
    field end_cobranca              as integer   format ">>>>>9"
    field cod_rep                   as integer   format ">>>>9"
    field observacoes               as character format "x(2000)"
    field nome_emit                 as character format "x(40)"
    field endereco_cob              as character format "x(40)"
    field bairro_cob                as character format "x(30)"
    field cidade_cob                as character format "x(25)"
    field estado_cob                as character format "x(04)"
    field cep_cob                   as character format "x(12)"
    field cgc_cob                   as character format "x(19)"
    field cx_post_cob               as character format "x(10)"
    field zip_cob_code              as character format "x(12)"
    field ins_est_cob               as character format "x(19)"
    field pais_cob                  as character format "x(20)"
    field gera_ad                   as logical   format "Sim/Nío"
    field port_prefer               as integer   format ">>>>9"
    field mod_prefer                as integer   format "9"
    field ep_codigo                 LIKE mgcad.empresa.ep-codigo
    field ep_codigo_principal       LIKE mgcad.empresa.ep-codigo
    field num_tip_operac            as integer   format "9"
    field agente_retencao           as logical   format "Sim/Nío"
    field ramo_atividade            as character format "x(08)"
    field recebe_inf_sci            as logical   format "Sim/Nío"
    field vencto_dia_nao_util       as logical   format "Sim/Nío"
    field tp_desp_padrao            as integer   format "99"
    field bonificacao               as decimal   format ">>9.99"
    field ind_rendiment             as logical   format "Sim/Nío"
    field dias_comp                 as integer   format ">>9"
    field rendto_tribut             as integer   format "999"
    field home_page                 as character format "x(40)"
    field utiliza_verba             as logical   format "Sim/Nío"	 
    field percent_verba             as decimal   format ">>>9.99"
    field valor_minimo              as decimal   format ">>,>>>,>>>,>>9.99"
    field dias_atraso               as integer   format "999" 
    field tp_rec_padrao             as integer   format ">>9"
    field calcula_multa             as logical   format "Sim/Nío"
    field flag_pag                  as logical   format "Sim/Nío"
    field ender_text                as char      format "x(2000)"
    field ender_cobr_text           as char      format "x(2000)"
    field log_cr_pis                as log       format "Sim/Nío" INITIAL NO
    field cod_id_munic_fisic        as char      format "x(20)"
    field cod_id_previd_social      as char      format "x(20)"
    field dat_vencto_id_munic       as date      format "99/99/9999"
    field log_control_inss          as logical   format "Sim/Nío" initial no
    field log_cr_cofins             as logical   format "Sim/Nío" initial no
    field log_retenc_impto_pagto    as logical   format "Sim/Nío" initial no
    field log_cooperativa           as logical   format "Sim/Nío" initial no
    field ind_tip_fornecto          as character format 'x(08)'
    field log_assoc_desportiva      as logical   format 'Sim/Nío' initial no
    index codigo                    is primary unique
          cod_emitente              ascending.

def temp-table tt_cont_emit_integr no-undo
    field cod_versao_integracao        as integer   format "999"
    field cod_emitente                 as integer   format ">>>>>>9"
    field sequencia                    as integer   format ">>9"
    field nome                         as character format "x(40)"
    field des_cargo                    as character format "x(20)"
    field area                         as character format "x(18)"
    field telefone                     as character format "x(15)"
    field ramal                        as character format "x(05)"
    field telefax                      as character format "x(15)"
    field ramal_fax                    as character format "x(05)"
    field e_mail                       as character format "x(25)"
    field observacao                   as character format "x(2000)"
    field ep_codigo_principal          LIKE mgcad.empresa.ep-codigo
    field num_tip_operac               as integer   format "9"
    index codigo                       is primary unique 
          cod_emitente                 ascending
          sequencia                    ascending.

DEF TEMP-TABLE tt_cont_emit_integr_new NO-UNDO LIKE tt_cont_emit_integr
    field num-pessoa-fisic AS INTEGER    FORMAT ">>>,>>>,>>9"
    field nome-abrev       AS CHARACTER  FORMAT "x(12)"
    field char-1           AS  CHAR FORMAT "x(255)"
    field char-2           AS  CHAR FORMAT "x(255)"
    field dec-1            AS  DEC  FORMAT "->>>>>>>>>>>9.99999999"
    field dec-2            AS  DEC  FORMAT "->>>>>>>>>>>9.99999999"
    field log-1            AS  LOGICAL FORMAT "Sim/Nao"
    field log-2            AS  LOGICAL FORMAT "Sim/Nao".

def temp-table tt_cta_emitente no-undo
    field cod_emitente     as      int  format ">>>>>>>>9"
    field cod_banco        as      int  format "999"
    field agencia          as      char format "x(8)"
    field conta_corrente   as      char format "x(20)"
    field descricao        as      char format "x(30)"
    field preferencial     as      log  format "Sim/Nío"
    field char-1           as      char format "x(100)"
    field char-2           as      char format "x(100)"
    field dec-1            as      dec  format "->>>>>>>>>>>9.9"
    field dec-2            as      dec  format "->>>>>>>>>>>9.9"
    field int-1            as      int  format "->>>>>>>>>9"
    field int-2            as      int  format "->>>>>>>>>9"
    field log-1            as      log  format "Sim/Nío"
    field log-2            as      log  format "Sim/Nío"
    field data-1           as      date format "99/99/9999"
    field data-2           as      date format "99/99/9999"
    field check_sum        as      char format "x(20)"
    index conta_corrente is primary unique
          cod_emitente
          cod_banco
          agencia
          conta_corrente.

DEFINE VARIABLE cAux            AS LONGCHAR.
DEFINE VARIABLE h-api           AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-saida AS CHARACTER   NO-UNDO.
define variable c-retorno-aux   as character  no-undo.
define variable iNumMessages    as integer           no-undo.

{esp/esapi505x.i &OPC="OPEN"}

{utp/ut-glob.i}

/*
IF i-acao = 0 THEN DO:
   l-esapi556 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.
*/
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure


/* ***************************  Main Block  *************************** */

DEF VAR lcInput    AS LONGCHAR         NO-UNDO.

DEF VAR jsonParser  AS ObjectModelParser NO-UNDO.
DEF VAR jsonInput   AS JsonObject        NO-UNDO.
DEF VAR jsonOutput  AS JsonObject        NO-UNDO.
DEF VAR longAux     AS LONGCHAR          NO-UNDO.
define variable oErros as JsonArray  no-undo.
define variable oErro  as JsonObject no-undo.

FOR FIRST es-api-log
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:
 
    ASSIGN es-api-log.dh-envio = NOW.

    COPY-LOB es-api-log.cl-envio TO lcInput.

   //assign lcInput = replace(lcInput,'Œ','-').
       
    PUT unformatted ">> " STRING(lcInput) SKIP.

    ASSIGN jsonParser = NEW ObjectModelParser()
           jsonInput  = CAST(jsonParser:Parse(lcInput), JsonObject).

    IF VALID-HANDLE(h-acomp) THEN 
       RUN pi-acompanhar IN h-acomp ("Fornecedor").

    RUN pi-input-api-headers (jsonInput).

    EMPTY TEMP-TABLE RowErrors.

    RUN piProcessa.

    ASSIGN
       es-api-log.retorno-content-type = "application/json".

    jsonOutput:WRITE(longAux).
    COPY-LOB longAux TO es-api-log.cl-retorno.

    IF TEMP-TABLE RowErrors:HAS-RECORDS = NO THEN 
       ASSIGN es-api-log.cod-retorno = "200"
              es-api-log.aux         = "Fornecedor " + string(i-cod-emitente) + " Integrado com sucesso".
    ELSE DO:
        ASSIGN es-api-log.cod-retorno = "500".  
    END. //else do
       
    RELEASE es-api-log.
END.

catch oStop AS Progress.Lang.StopError:
  do iNumMessages = 1 to oStop:nummessages:
    run pi-cria-erro(oStop:GetMessage(iNumMessages)).
  end.
  return "NOK".
end catch.
catch eAnyError AS Progress.Lang.Error:
  do iNumMessages = 1 to eAnyError:nummessages:
    run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
  end.
  return "NOK".
end catch.
finally:
  if temp-table RowErrors:has-records then do:

    assign oErros = new JsonArray().
    for each RowErrors:
      assign oErro = new JsonObject().
      oErro:add("errorCode",       rowErrors.ErrorNumber ). 
      oErro:add("errorInfo",       ""). 
      oErro:add("errorDescription",rowErrors.errorDescription ).
      oErros:add(oErro).
    end.
    assign jsonObjectOutput = new jsonObject().
    jsonObjectOutput:add("Erros", oErros).
    assign jsonOutput = new jsonObject().
    jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).

    for first es-api-log exclusive-lock
        where rowid(es-api-log) = rw-registro:
      assign es-api-log.cod-retorno = "500".
      jsonOutput:WRITE(longAux).
      copy-lob longAux to es-api-log.cl-retorno.
    end.
    release es-api-log.
  end.
  if search(cArquivoRec) <> ? then do:
    {esp/esapi505x.i &OPC="CLOSE"} 
  end.
end.

/*RETURN "OK".*/


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(piCriaAtualizaFornecedorERP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaAtualizaFornecedorERP procedure
procedure piCriaAtualizaFornecedorERP :
    define output param p-erro as logi no-undo.

    define variable v_hdl_utb765zl as handle no-undo.
    
    /*  **************************************************************************************
        * Regras extra°das do documento "Projeto Intelbras Descritivo Funcional SLP (1).doc" *
        **************************************************************************************



    ABA "FISCAL"
    ------------
    [ ] Quando fornecedor for "Estrangeiro", os campos de Inscriá∆o Municipal e Estadual dever∆o
        ser fixadas como ISENTO. O conte£do de TAX ID dever† ser preenchido no campo "Nr Passaporte"
        (para fornecedores Estrangeiros) e neste caso dever† preencher o campo de CGC com o c¢digo 
        do emitente criado pelo Totvs.
        
    [ ] Tributaá‰es:

        - Quando a Natureza = Estrangeiro (Fornecedor Internacional):
            [ ] Tributaá∆o PIS: ISENTO
            [ ] Tributaá∆o COFINS: ISENTO

        - Quando a Natureza = Pessoa Jur°dica (Fornecedor Nacional):
            [ ] Tributaá∆o PIS: Tributado
            [ ] Tributaá∆o COFINS: Tributado
            [ ] Retem Pagto: Flegado
            [ ] Fornecedor Emite Documento Eletrìnico: Flegado
            [ ] Contribuinte ICMS: Flegar somente quando o campo Inscriá∆o Estadual for diferente de ISENTO

    ABA "ENDER."
    ------------
    [ ] CEP: Para fornecedores Estrangeiros, fixar o valor como "11111111"
    [ ] UF: Para fornecedores Estrangeiros, fixar o valor como "EX"


    ABA "COMUN."
    ------------
    [ ] e-mail = Dever† conter o contato Financeiro (obs: este campo n∆o recebe notificaá∆o de PO)


    ABA "CONTATO"
    ------------
    Para os demais contatos da integraá∆o, dever∆o ser criados da seguinte forma:
    [ ] Nome: conforme campo direto da integraá∆o
    [ ] µrea Contato: para contato log°stico preencher com "LOG÷STICA" e para representante legal "REPRESENTANTE LEGAL"
    [ ] Telefone: conforme campo direto da integraá∆o
    [ ] E-mail: conforme campo direto da integraá∆o
    [ ] CPF: preencher somente com o campo do representante legal
    [ ] Recebe PO: somente para o contato da Log°stica dever† ter esse fleg = YES

    ABA "SITUAÄ«O"
    ------------
    [ ] Situaá∆o Fornecedor = todos dever∆o ser criados como Ativo e Participa do Portal de Fornecedor
    */
   
    DEF BUFFER b-emitente FOR emitente.
    
    /* Limpeza de tabelas tempor†rias ----------*/
    empty temp-table tt_cliente_integr.
    empty temp-table tt_fornecedor_integr.
    empty temp-table tt_clien_financ_integr.
    empty temp-table tt_fornec_financ_integr.
    empty temp-table tt_pessoa_jurid_integr.
    empty temp-table tt_pessoa_fisic_integr.
    empty temp-table tt_contato_integr.
    empty temp-table tt_contat_clas_integr.
    empty temp-table tt_estrut_clien_integr.
    empty temp-table tt_estrut_fornec_integr.
    empty temp-table tt_histor_clien_integr.
    empty temp-table tt_histor_fornec_integr.
    empty temp-table tt_ender_entreg_integr.
    empty temp-table tt_telef_integr.
    empty temp-table tt_telef_pessoa_integr.
    empty temp-table tt_pj_ativid_integr.
    empty temp-table tt_pj_ramo_negoc_integr.
    empty temp-table tt_porte_pj_integr.
    empty temp-table tt_idiom_pf_integr.
    empty temp-table tt_idiom_contat_integr.
    empty temp-table tt_retorno_clien_fornec.
    empty temp-table tt_clien_analis_cr_integr.
    empty temp-table tt_cta_corren_fornec_1.
    empty temp-table tt_params_generic_api_id.
    EMPTY TEMP-TABLE tt_chave_pix_fornec.

    empty temp-table tt-fornecedor.

    assign i-cod-cond-pag = 0.

    FOR FIRST ttSupplier:
        assign ttSupplier.fantasyName          = TRIM(ttSupplier.fantasyName)
               ttSupplier.supplierType         = trim(ttSupplier.supplierType)
               ttSupplier.cnpj                 = trim(ttSupplier.cnpj)
               ttSupplier.nameContactLogistics = trim(ttSupplier.nameContactLogistics).

        if ttSupplier.nameContactLogistics <> ""
        then assign ttSupplier.nameContactLogistics = "(LOG) " + ttSupplier.nameContactLogistics.

        case yes:
            /* Criaá∆o ------------------*/
            when  cMetodo = "POST" then do:
                /* Validaá∆o para n∆o incluir dois fornecedores com o mesmo Nome Fantasia - nome-abrev */
                FIND first emitente no-lock
                              where emitente.nome-abrev = ttSupplier.fantasyName NO-ERROR.
                IF AVAIL emitente then
                    case emitente.identific:
                        when 1 THEN DO:
                           run piErro ("Nome Fantasia " + emitente.nome-abrev + " ja esta sendo utilizado por um Cliente.","").
                           RETURN "NOK".
                        END.
                        when 2 THEN DO:
                           run piErro ("Nome Fantasia " + emitente.nome-abrev + " ja esta sendo utilizado por outro Fornecedor.","").
                           RETURN "NOK".
                        END.
                        otherwise do:
                           run piErro ("Nome Fantasia " + emitente.nome-abrev + " ja esta sendo utilizado por outro Fornecedor/Cliente.","").
                           RETURN "NOK".
                        end.
                    end case.

                /* Validaá∆o para n∆o incluir dois fornecedores com a mesma Raz∆o Social */
/*                 FIND first emitente no-lock                                                                      */
/*                               where emitente.nome-emit = ttSupplier.corporateName NO-ERROR.                      */
/*                 IF AVAIL emitente then                                                                           */
/*                     case emitente.identific:                                                                     */
/*                         when 1 THEN DO:                                                                          */
/*                            run piErro (ttSupplier.corporateName + " ja cadastrado para um Cliente.","").         */
/*                            RETURN "NOK".                                                                         */
/*                         END.                                                                                     */
/*                         when 2 THEN DO:                                                                          */
/*                            run piErro ("Fornecedor " + ttSupplier.corporateName + " ja cadastrado.","").         */
/*                            RETURN "NOK".                                                                         */
/*                         END.                                                                                     */
/*                         otherwise do:                                                                            */
/*                            run piErro ("Fornecedor/Cliente " + ttSupplier.corporateName + " ja cadastrado.",""). */
/*                            RETURN "NOK".                                                                         */
/*                         END.                                                                                     */
/*                     end case.                                                                                    */

                if length(ttSupplier.fantasyName) > 12
                then do:
                     run piErro ("Nome Fantasia " + ttSupplier.fantasyName + " deve se limitar a 12 caracteres.","").
                     RETURN "NOK".
                end.

                /* Validaá∆o para n∆o incluir dois fornecedores com o mesmo CNPJ */
                if ttSupplier.suppliertype = "Nacional"                
                THEN do:
                     if ttSupplier.cnpj = ""
                     then do:
                          run piErro ("CNPJ deve ser informado.","").
                          RETURN "NOK".
                     end.

                     FIND first emitente no-lock 
                          where emitente.cgc = ttSupplier.cnpj NO-ERROR.

                     IF AVAIL emitente then
                         case emitente.identific:
                             when 1 THEN DO:
                                run piErro ("CNPJ " + emitente.cgc + " ja cadastrado para um Cliente.","").
                                RETURN "NOK".
                             END.
                             when 2 THEN DO:
                                run piErro ("CNPJ " + emitente.cgc + " ja cadastrado para outro Fornecedor.","").
                                RETURN "NOK".
                             END.
                             otherwise do:
                                run piErro ("CNPJ " + emitente.cgc + " ja cadastrado para outro Fornecedor/Cliente.","").
                                RETURN "NOK". 
                             END.
                         end case.
                END. /* if ttSupplier.suppliertype = "Nacional" */
                
                /* Busca cod-fornecedor - Novo Emitente - Criar */
                run cdp/cd9960.p(output i-cod-emitente).
                              
                CREATE tt-fornecedor.                
            end. /* post */
            
            /* Alteraá∆o --------------- */
            when cMetodo = "PUT" then do:
                 if ttSupplier.supplierId > 0
                 then.
                 else do:
                      run piErro ("SupplierId deve ser informado","").
                      RETURN "NOK".
                 end.

                 for first b-emitente
                     where b-emitente.cod-emitente = ttSupplier.supplierId
                           no-lock: end.

                 if not avail b-emitente
                 then do:
                      run piErro ("Fornecedor com codigo " + string(ttSupplier.supplierId) + " nao encontrado.","").
                      RETURN "NOK".
                 end.

                 if  b-emitente.identific <> 2
                 and b-emitente.identific <> 3
                 then do:
                      run piErro ("SupplierId n∆o est† associado a um fornecedor","").
                      RETURN "NOK".
                 end.

                 if ttSupplier.supplierType = "Nacional"
                 then do:
                      if ttSupplier.cnpj = ""
                      then do:
                           run piErro ("CNPJ deve ser informado","").
                           RETURN "NOK".
                      end.

                      if ttSupplier.cnpj <> b-emitente.cgc
                      then do:
                           run piErro ("CNPJ n∆o pode ser alterado","").
                           RETURN "NOK".
                      end.
                 end.

/*                  if  ttSupplier.fantasyName <> ""                                                                            */
/*                  and can-find(first emitente use-index nome where                                                            */
/*                                     emitente.nome-abrev = ttSupplier.fantasyName                                             */
/*                                 and rowid(emitente)    <> rowid(b-emitente)                                                  */
/*                                     no-lock)                                                                                 */
/*                  then do:                                                                                                    */
/*                      run piErro ("Nome Fantasia " + ttSupplier.fantasyName + " j† utilizado para diferente fornecedor.",""). */
/*                      RETURN "NOK".                                                                                           */
/*                  end.                                                                                                        */

                 ASSIGN ttSupplier.fantasyName = b-emitente.nome-abrev
                        i-cod-emitente         = b-emitente.cod-emitente
                        i-cod-cond-pag         = b-emitente.cod-cond-pag.

                 CREATE tt-fornecedor.
            end.     

        end case.

        IF NOT CAN-FIND(FIRST transporte NO-LOCK WHERE transporte.cod-transp = ttSupplier.shipper) THEN DO:
            run piErro ("Transportadora n∆o encontrada.","").
            RETURN "NOK".
        END.

        if ttSupplier.paymentTerms <> 0
        then do:
             if not can-find(first cond-pagto where
                                   cond-pagto.cod-cond-pag = ttSupplier.paymentTerms
                                   no-lock)
             then do:
                  run piErro ("Condiá∆o de Pagamento n∆o encontrada.","").
                  RETURN "NOK".
             end.

             assign i-cod-cond-pag = ttSupplier.paymentTerms.
        end.
    
        /*  TDN TOTVS:
        ----------
        "O n£mero da pessoa f°sica ou jur°dica n∆o dever† ser informado quando estiver
        sendo inclu°da uma pessoa ou um cliente/fornecedor, informe apenas o pa°s e o
        cod_id_feder (cgc, cpf), pois o n£mero da pessoa Ç gravado ao criar o registro
        na tabela." */

        if  ttSupplier.suppliertype = "Nacional" THEN DO: /* Juridico Nacional */
            ASSIGN tt-fornecedor.natureza             = 2   /* Jur°dica nacional */
                   tt-fornecedor.cgc                   = ttSupplier.cnpj
                   tt-fornecedor.ins-municipal         = ttSupplier.municipalRegistration
                   tt-fornecedor.ins-estadual          = ttSupplier.stateRegistration
                   tt-fornecedor.idi-tributac-cofins   = 1  /* Tributado */
                   tt-fornecedor.idi-tributac-pis      = 1  /* Tributado */
                   tt-fornecedor.retem-pagto           = YES
                   tt-fornecedor.log-possui-nf-eletro  = YES
                   tt-fornecedor.contrib-icms          = IF tt-fornecedor.ins-estadual <> "ISENTO" THEN YES ELSE NO
                   tt-fornecedor.tp-desp-padrao        = 17
                  //tt-fornecedor.tp-desp-padrao        = IF ttSupplier.serviceProvider = "Sim" THEN 8 ELSE 1
                   tt-fornecedor.estado                = ttSupplier.addressState
                   tt-fornecedor.cep                   = ttSupplier.addressPostalCode
                   tt-fornecedor.modalidade            = 1  /* Portador e Modalidade (1: CB Simples)*/
                  //tt-fornecedor.portador              = 1
                   tt-fornecedor.portador              = 999.
            
            IF (tt-fornecedor.estado = "MG" AND tt-fornecedor.ins-estadual NE "ISENTO") THEN DO:
                IF length(tt-fornecedor.ins-estadual) < 13 THEN
                    ASSIGN tt-fornecedor.ins-estadual = fill("0",13 - length(tt-fornecedor.ins-estadual)) + tt-fornecedor.ins-estadual.
            END.

            case ttSupplier.formOfPayment: /* Forma de Pagamento */
                when "Boleto"   then assign tt-fornecedor.tp-pagto = 9. /* Boleto */
                when "Deposito" then assign tt-fornecedor.tp-pagto = 1. /* Dep¢sito -> DOC */
                when "PIX"      then assign tt-fornecedor.tp-pagto = 5. /* Pix -> Cheque Nominal */
                otherwise       assign tt-fornecedor.tp-pagto = 0.
            end case.

            case ttSupplier.taxRegime: /* Regime Tribut†rio */
                when "Simples Nacional"  then assign OVERLAY(tt-fornecedor.char-1,133,1) = "S".
                when "Lucro Real"        then assign OVERLAY(tt-fornecedor.char-1,133,1) = "N".
                when "Lucro Presumido"   then assign OVERLAY(tt-fornecedor.char-1,133,1) = "N".
                otherwise  assign OVERLAY(tt-fornecedor.char-1,133,1) = "S".
            end case.

        END.
        ELSE DO: /* Estrangeiro */
            ASSIGN tt-fornecedor.natureza               = 3 /* estrangeiro */
                   tt-fornecedor.cgc                    = STRING(i-cod-emitente)
                   tt-fornecedor.ins-municipal          = "ISENTO"
                   tt-fornecedor.ins-estadual           = "ISENTO"
                   tt-fornecedor.idi-tributac-cofins    = 2  /* Isento */
                   tt-fornecedor.idi-tributac-pis       = 2  /* Isento */
                   OVERLAY(tt-fornecedor.char-1,103,30) = ttSupplier.TaxId /* nr passaporte */
                   tt-fornecedor.retem-pagto            = NO
                   tt-fornecedor.log-possui-nf-eletro   = NO
                   tt-fornecedor.contrib-icms           = NO
                   tt-fornecedor.tp-pagto               = 1 /* DOC */
                   tt-fornecedor.tp-desp-padrao         = 2
                   tt-fornecedor.estado                 = "EX"
                   tt-fornecedor.cep                    = "11111111"
                   tt-fornecedor.modalidade             = 1.

            case ttSupplier.currency: /* CB Simples */
                when "Dolar" then assign tt-fornecedor.portador   = 9991. /* 1 - D¢lar */ 
                when "Euro"  then assign tt-fornecedor.portador   = 9993. /* 5 - Euro  */
                when "Renminbi"  then assign tt-fornecedor.portador   = 9994. /* 7 - Renminbi  */
                when "Yen"  then assign tt-fornecedor.portador   = 9995. /* 4 - Yen  */
                otherwise   assign tt-fornecedor.portador = 9991.
            end case.

            if  ttSupplier.incoterm <> ""
            and NOT CAN-FIND(FIRST inco-cx NO-LOCK WHERE inco-cx.cod-incoterm = ttSupplier.incoterm) THEN DO:
                run piErro ("Incoterm N∆o Cadastrado.","").
                RETURN "NOK".
            END.

        END. /* Estrangeiro */
        
        /*CD0401 - Aba Fornec ------------------------------------------------*/
        assign tt-fornecedor.cod-emitente = i-cod-emitente
               tt-fornecedor.nome-abrev   = trim(ttSupplier.fantasyName)
               tt-fornecedor.nome-matriz  = trim(ttSupplier.fantasyName)
               tt-fornecedor.nome-emit    = trim(ttSupplier.corporateName)
               tt-fornecedor.ven-sabado   = 3  /* Vencto S†bado : MantÇm     */
               tt-fornecedor.ven-domingo  = 3  /* Vencto Domingo: MantÇm     */
               tt-fornecedor.ven-feriado  = 3  /* Vencto Feriado: MantÇm     */
               tt-fornecedor.emissao-ped  = 1  /* Emiss∆o Pedido: Formul†rio */
               tt-fornecedor.cod-transp   = ttSupplier.shipper.

        CASE ttSupplier.supplierGroup: /* Grupo Fornecedor */
            WHEN "FORNECEDOR NACIONAL - MP"      THEN ASSIGN tt-fornecedor.cod-gr-forn  = 1.
            WHEN "FORNECEDOR NACIONAL - OEM"     THEN ASSIGN tt-fornecedor.cod-gr-forn  = 2.
            WHEN "FORNECEDOR NACIONAL - OUTROS"  THEN ASSIGN tt-fornecedor.cod-gr-forn  = 3.
            WHEN "TRANSPORTADORA NACIONAL"       THEN ASSIGN tt-fornecedor.cod-gr-forn  = 7.
            WHEN "AGENTE DE CARGA"               THEN ASSIGN tt-fornecedor.cod-gr-forn  = 50.
            WHEN "TRANSPORTADORA"                THEN ASSIGN tt-fornecedor.cod-gr-forn  = 54.
            WHEN "FORNECEDOR IMPORTADO - MP"     THEN ASSIGN tt-fornecedor.cod-gr-forn  = 90.
            WHEN "FORNECEDOR IMPORTADO - OEM"    THEN ASSIGN tt-fornecedor.cod-gr-forn  = 91.
            WHEN "FORNECEDOR IMPORTADO - OUTROS" THEN ASSIGN tt-fornecedor.cod-gr-forn  = 92.
            OTHERWISE ASSIGN tt-fornecedor.cod-gr-forn  = 99.
        END CASE.

        IF ttSupplier.serviceProvider = "true" 
        then assign tt-fornecedor.tp-desp-padrao = 8.
        else if  ttSupplier.suppliertype = "Nacional" 
             and tt-fornecedor.cod-gr-forn >= 1
             and tt-fornecedor.cod-gr-forn <= 2
             then assign tt-fornecedor.tp-desp-padrao = 1.         
               
        /*CD0401 - Aba Financ ----------------------------------------------- */
        assign tt-fornecedor.cod-cond-pag = i-cod-cond-pag.
        
        /* Aba Situac */
        ASSIGN tt-fornecedor.ind-sit-emitente = 1.

        ASSIGN tt-fornecedor.e-mail = ttSupplier.financialContactEmail.
        
        ASSIGN tt-fornecedor.cidade   = ttSupplier.addressCity
               tt-fornecedor.telefone = ttSupplier.financialContactPhone
               tt-fornecedor.endereco = ttSupplier.addressStreet + ", " + STRING(ttSupplier.addressNumber)
               tt-fornecedor.bairro   = ttSupplier.addressDistrict.

        /*Pesquisar o pais pela sigla*/
        FIND FIRST mgcad.pais NO-LOCK WHERE SUBSTRING(pais.char-1,23,2) = ttSupplier.addressCountry NO-ERROR.
        IF AVAIL pais THEN
            ASSIGN tt-fornecedor.pais = pais.nome-pais.

        /* Conta Corrente: Concatenar os campos de Conta e D°gito */
        CREATE tt_cta_emitente.
        ASSIGN tt_cta_emitente.cod_emitente   =  i-cod-emitente                                              
               tt_cta_emitente.cod_banco      =  ttSupplier.bankCode                                         
               tt_cta_emitente.agencia        =  string(integer(ttSupplier.agency),"999999") + STRING(ttSupplier.agencyDigit,"xx")
              //tt_cta_emitente.conta_corrente =  string(int64(ttSupplier.currentAccount),"9999999999") + STRING(ttSupplier.currentAccountDigit,"xx")
               tt_cta_emitente.conta_corrente =  ttSupplier.currentAccount + STRING(ttSupplier.currentAccountDigit,"xx").

        FOR FIRST tt-fornecedor NO-LOCK.

        /** cria tt_emitente_integr_new **/
        CREATE tt_emitente_integr_new.
        ASSIGN tt_emitente_integr_new.cod_versao_integracao  = 001
               tt_emitente_integr_new.ep_codigo              = v_cod_empres_usuar  
               tt_emitente_integr_new.ep_codigo_principal    = v_cod_empres_usuar
               tt_emitente_integr_new.cod_emitente           = tt-fornecedor.cod-emitente
               tt_emitente_integr_new.identific              = 2  
               tt_emitente_integr_new.nome_abrev             = tt-fornecedor.nome-abrev
               tt_emitente_integr_new.nome_matriz            = tt-fornecedor.nome-matriz
               tt_emitente_integr_new.nome_emit              = tt-fornecedor.nome-emit
               tt_emitente_integr_new.natureza               = tt-fornecedor.natureza
               tt_emitente_integr_new.cgc                    = tt-fornecedor.cgc
               tt_emitente_integr_new.cod_portador           = tt-fornecedor.portador
               tt_emitente_integr_new.modalidade             = tt-fornecedor.modalidade  
               tt_emitente_integr_new.cod_banco              = tt_cta_emitente.cod_banco                               
               tt_emitente_integr_new.agencia                = tt_cta_emitente.agencia
               tt_emitente_integr_new.conta_corren           = tt_cta_emitente.conta_corrente
               tt_emitente_integr_new.data_implant           = TODAY
               tt_emitente_integr_new.cod_gr_forn            = tt-fornecedor.cod-gr-forn  
               tt_emitente_integr_new.ins_estadual           = tt-fornecedor.ins-estadual  
               tt_emitente_integr_new.ins_municipal          = tt-fornecedor.ins-municipal
               tt_emitente_integr_new.estado                 = tt-fornecedor.estado
               tt_emitente_integr_new.endereco               = tt-fornecedor.endereco
               tt_emitente_integr_new.bairro                 = tt-fornecedor.bairro
               tt_emitente_integr_new.cep                    = tt-fornecedor.cep
               tt_emitente_integr_new.cod_pais               = tt-fornecedor.pais
               /*tt_emitente_integr_new.nome_mic_reg           =   */
               tt_emitente_integr_new.nom_cidade             = tt-fornecedor.cidade  
               tt_emitente_integr_new.telefone               = tt-fornecedor.telefone
               tt_emitente_integr_new.tp_pagto               = tt-fornecedor.tp-pagto
               /*tt_emitente_integr_new.emite_bloq    */           
               tt_emitente_integr_new.ven_sabado             = tt-fornecedor.ven-sabado     
               tt_emitente_integr_new.ven_domingo            = tt-fornecedor.ven-domingo   
               tt_emitente_integr_new.ven_feriado            = tt-fornecedor.ven-feriado   
               tt_emitente_integr_new.e_mail                 = tt-fornecedor.e-mail
              /* tt_emitente_integr_new.end_cobranca           = tt-fornecedor.endereco */
              /* tt_emitente_integr_new.cod_rep                = tt-fornecedor.*/
               tt_emitente_integr_new.endereco_cob           = tt-fornecedor.endereco
               tt_emitente_integr_new.bairro_cob             = tt-fornecedor.bairro
               tt_emitente_integr_new.cidade_cob             = tt-fornecedor.cidade
               tt_emitente_integr_new.estado_cob             = tt-fornecedor.estado
               tt_emitente_integr_new.cep_cob                = tt-fornecedor.cep
               tt_emitente_integr_new.cgc_cob                = tt-fornecedor.cgc
               tt_emitente_integr_new.ins_est_cob            = tt-fornecedor.ins-estadual
               tt_emitente_integr_new.pais_cob               = tt-fornecedor.pais 
              /*tt_emitente_integr_new.gera_ad                  */
               tt_emitente_integr_new.port_prefer            = tt-fornecedor.portador
               tt_emitente_integr_new.mod_prefer             = tt-fornecedor.modalidade
               tt_emitente_integr_new.tp_desp_padrao         = tt-fornecedor.tp-desp-padrao
               tt_emitente_integr_new.log_cr_pis             = IF tt-fornecedor.idi-tributac-pis = 1 THEN YES ELSE NO
               tt_emitente_integr_new.log_cr_cofins          = IF tt-fornecedor.idi-tributac-cofins = 1 THEN YES ELSE NO
               tt_emitente_integr_new.log_retenc_impto_pagto = tt-fornecedor.retem-pagto
               tt_emitente_integr_new.num_tip_operac         = 1. 
        
          /*** Cont-emit ***** Aba Contato */
          empty temp-table tt-cont-emit.
          find last cont-emit use-index codigo
              where cont-emit.cod-emitente = i-cod-emitente
                    no-lock no-error.

          if avail cont-emit
          then assign i-cont-emit-seq = cont-emit.sequencia + 10.
          else assign i-cont-emit-seq = 10.
          release cont-emit.

         //Comercial
         if  ttSupplier.comercialContactName  <> ""
         and ttSupplier.comercialContactEmail <> ""
         then do:      
              for FIRST cont-emit use-index codigo
                  where cont-emit.cod-emitente = tt_emitente_integr_new.cod_emitente
                    and cont-emit.area         = "COMERCIAL"
                        no-lock: end.

             CREATE tt_cont_emit_integr_new.
             ASSIGN tt_cont_emit_integr_new.cod_versao_integracao = tt_emitente_integr_new.cod_versao_integracao
                    tt_cont_emit_integr_new.cod_emitente          = tt_emitente_integr_new.cod_emitente
                    tt_cont_emit_integr_new.nome                  = ttSupplier.comercialContactName
                    OVERLAY(tt_cont_emit_integr_new.char-2,1,20)  = ""
                    tt_cont_emit_integr_new.des_cargo             = ""
                    tt_cont_emit_integr_new.area                  = "COMERCIAL"
                    tt_cont_emit_integr_new.sequencia             = cont-emit.sequencia when avail cont-emit
                    tt_cont_emit_integr_new.telefone              = ttSupplier.comercialContactPhone
                    tt_cont_emit_integr_new.ramal                 = ""
                    tt_cont_emit_integr_new.telefax               = ""
                    tt_cont_emit_integr_new.ramal_fax             = ""
                    tt_cont_emit_integr_new.e_mail                = ttSupplier.comercialContactEmail
                    tt_cont_emit_integr_new.observacao            = ""
                    tt_cont_emit_integr_new.ep_codigo_principal   = tt_emitente_integr_new.ep_codigo
                    tt_cont_emit_integr_new.num_tip_operac        = 1
                    tt_cont_emit_integr_new.num-pessoa-fisic      = 0
                    tt_cont_emit_integr_new.nome-abrev            = tt_emitente_integr_new.nome_abrev.
    
             if  avail cont-emit
             and cMetodo = "PUT"
             then if cont-emit.nome = tt_cont_emit_integr_new.nome
                  then.
                  else do:
                       assign tt_cont_emit_integr_new.num_tip_operac = 2
                              tt_cont_emit_integr_new.nome           = cont-emit.nome.

                       create tt-cont-emit.
                       assign tt-cont-emit.cod-emitente = tt_emitente_integr_new.cod_emitente
                              tt-cont-emit.nome         = ttSupplier.comercialContactName
                              tt-cont-emit.area         = cont-emit.area
                              tt-cont-emit.sequencia    = cont-emit.sequencia
                              tt-cont-emit.telefone     = ttSupplier.comercialContactPhone
                              tt-cont-emit.e-mail       = ttSupplier.comercialContactEmail
                              tt-cont-emit.identific    = tt_emitente_integr_new.identific.
                       find current tt-cont-emit no-error.
                       release tt-cont-emit.
                  end. /* else do */
             else assign tt_cont_emit_integr_new.sequencia = i-cont-emit-seq
                         i-cont-emit-seq                   = i-cont-emit-seq + 10.
         end.

         //Log°stica
         if  ttSupplier.nameContactLogistics  <> ""
         and ttSupplier.logisticsContactEmail <> ""
         then do:
              for FIRST cont-emit use-index codigo
                  where cont-emit.cod-emitente = tt_emitente_integr_new.cod_emitente
                    and cont-emit.area         = "LOG÷STICA"
                        no-lock: end.

             CREATE tt_cont_emit_integr_new. 
             ASSIGN tt_cont_emit_integr_new.cod_versao_integracao = tt_emitente_integr_new.cod_versao_integracao
                    tt_cont_emit_integr_new.cod_emitente          = tt_emitente_integr_new.cod_emitente
                    tt_cont_emit_integr_new.nome                  = ttSupplier.nameContactLogistics
                    OVERLAY(tt_cont_emit_integr_new.char-2,1,20)  = ""
                    tt_cont_emit_integr_new.des_cargo             = ""
                    tt_cont_emit_integr_new.area                  = "LOG÷STICA"
                    tt_cont_emit_integr_new.sequencia             = cont-emit.sequencia when avail cont-emit
                    tt_cont_emit_integr_new.telefone              = ttSupplier.logisticsContactPhone
                    tt_cont_emit_integr_new.ramal                 = ""
                    tt_cont_emit_integr_new.telefax               = ""
                    tt_cont_emit_integr_new.ramal_fax             = ""
                    tt_cont_emit_integr_new.e_mail                = ttSupplier.logisticsContactEmail
                    tt_cont_emit_integr_new.observacao            = ""
                    tt_cont_emit_integr_new.ep_codigo_principal   = tt_emitente_integr_new.ep_codigo
                    tt_cont_emit_integr_new.num_tip_operac        = 1
                    tt_cont_emit_integr_new.num-pessoa-fisic      = 0
                    tt_cont_emit_integr_new.nome-abrev            = tt_emitente_integr_new.nome_abrev.
    
             if avail cont-emit
             and cMetodo = "PUT"
             then if cont-emit.nome = tt_cont_emit_integr_new.nome
                  then.
                  else do:
                       assign tt_cont_emit_integr_new.num_tip_operac = 2
                              tt_cont_emit_integr_new.nome           = cont-emit.nome.

                       create tt-cont-emit.
                       assign tt-cont-emit.cod-emitente = tt_emitente_integr_new.cod_emitente
                              tt-cont-emit.nome         = ttSupplier.nameContactLogistics
                              tt-cont-emit.area         = cont-emit.area
                              tt-cont-emit.sequencia    = cont-emit.sequencia
                              tt-cont-emit.telefone     = ttSupplier.logisticsContactPhone
                              tt-cont-emit.e-mail       = ttSupplier.logisticsContactEmail
                              tt-cont-emit.identific    = tt_emitente_integr_new.identific.
                       find current tt-cont-emit no-error.
                       release tt-cont-emit.
                  end. /* else do */
             else assign tt_cont_emit_integr_new.sequencia = i-cont-emit-seq
                         i-cont-emit-seq                   = i-cont-emit-seq + 10.
         end.

        END.

        IF NOT VALID-HANDLE(h-api) THEN 
           RUN cdp/cdapi366b.p PERSISTENT SET h-api.
                                     
        run execute_evoluida_7 in h-api (input        table tt_emitente_integr_new,
                                         input        table tt_cont_emit_integr_new,
                                         input-output table tt_retorno_clien_fornec,
                                         input        v_cod_empres_usuar,
                                         input-output c-arquivo-saida,
                                         input        table tt_cta_emitente).

        IF VALID-HANDLE(h-api) THEN
           DELETE PROCEDURE h-api.

        IF temp-table tt_retorno_clien_fornec:has-records
        THEN do:
             FOR EACH tt_retorno_clien_fornec:
                 if tt_retorno_clien_fornec.ttv_num_mensagem <> 27815
                 then do:
                       RUN piErro (string(tt_retorno_clien_fornec.ttv_num_mensagem) + " - " + tt_retorno_clien_fornec.ttv_des_mensagem, "" ).
                       next.
                 end.

                 assign c-retorno-aux = "(" + cMetodo + ") ".

                 for first emitente 
                     where emitente.cod-emitente = tt-fornecedor.cod-emitente
                           no-lock: end.

                 if avail emitente
                 then assign c-retorno-aux = c-retorno-aux
                                           + "N∆o se pode alter Nome Ab "
                                           + emitente.nome-abrev
                                           + " forn "
                                           + string(tt-fornecedor.cod-emitente)
                                           + ", implantado a "
                                           + string(emitente.data-implant)
                                           + ". Nome Ab enviado: "
                                           + tt-fornecedor.nome-abrev.
                 else assign c-retorno-aux = c-retorno-aux
                                           + "Tentativa de incluir fornec "
                                           + string(tt-fornecedor.cod-emitente)
                                           + " - "
                                           + tt-fornecedor.nome-abrev
                                           + " falhou".

                 RUN piErro (string(tt_retorno_clien_fornec.ttv_num_mensagem) + " - " + c-retorno-aux, "" ).
             END.

             assign p-erro = yes.
             return "NOK".
        END.
              
        /*** Integra?ío dos emitentes com o EMS5 ***/
        find FIRST emitente
             WHERE emitente.nome-abrev = tt_emitente_integr_new.nome_abrev 
                   exclusive-lock no-error.
        IF not AVAILABLE emitente THEN DO:
            RUN piErro ("Emitente nao Criado, e nenhum erro retornado pela API","").
            RETURN "NOK".
        end.
        else do:
            IF NOT CAN-FIND(FIRST tt_retorno_clien_fornec) THEN DO:
               /** cria as tabelas espec°ficas **/

               ASSIGN emitente.cod-transp           = tt-fornecedor.cod-transp
                      emitente.log-possui-nf-eletro = tt-fornecedor.log-possui-nf-eletro.
               assign emitente.cod-cond-pag         = tt-fornecedor.cod-cond-pag when tt-fornecedor.cod-cond-pag > 0.

               ASSIGN emitente.dt-atualiza          = TODAY.

               IF emitente.natureza = 3 THEN DO:
                  FIND FIRST emitente-cex 
                       WHERE emitente-cex.cod-emitente = i-cod-emitente NO-ERROR.
                  IF NOT AVAIL emitente-cex THEN
                     CREATE emitente-cex.    
             
                  ASSIGN emitente-cex.cod-emitente = i-cod-emitente
                         emitente-cex.cod-idioma   = IF ttSupplier.LANGUAGE = "PT" OR ttSupplier.LANGUAGE = "Portuguàs"
                                                        THEN "POR" 
                                                        ELSE ttSupplier.LANGUAGE.

                      if ttSupplier.checkpoint > 0
                      then assign emitente-cex.cod-pto-contr    = ttSupplier.checkpoint.

                      if ttSupplier.itinerary > 0
                      then assign emitente-cex.cod-itiner-imp   = ttSupplier.itinerary.

                      if ttSupplier.incoterm <> ""
                      then assign emitente-cex.cod-incoterm-imp = ttSupplier.incoterm.

                  OVERLAY(emitente.char-1,103,30) = ttSupplier.TaxId. /* nr passaporte */

               END.
                   
               /* dist-emitente moeda */
               FIND FIRST dist-emitente 
                    WHERE dist-emitente.cod-emitente = i-cod-emitente NO-ERROR.
               IF NOT AVAIL dist-emitente THEN
                  CREATE dist-emitente.
             
               ASSIGN dist-emitente.cod-emitente = i-cod-emitente.
             
               CASE ttSupplier.currency: /* moeda */
                   when "Dolar" then assign dist-emitente.mo-fatur  = 1. /* 1 - D¢lar */ 
                   when "Euro"  then assign dist-emitente.mo-fatur  = 5. /* 5 - Euro  */
                   when "Renminbi"  then assign dist-emitente.mo-fatur  = 7. /* 7 - Renminbi  */
                   when "Yen"  then assign dist-emitente.mo-fatur  = 4. /* 4 - Yen  */
                   otherwise assign dist-emitente.mo-fatur = 0.
               
               END CASE.
               
               /** banco emitente **/
               FIND FIRST banco-emit 
                    WHERE banco-emit.cod-emitente = i-cod-emitente 
                          NO-ERROR.
                     
               IF NOT AVAIL banco-emit THEN
                  CREATE banco-emit.
               
               ASSIGN banco-emit.cod-emitente = i-cod-emitente
                      banco-emit.banco        = ttSupplier.bankName
                      banco-emit.conta        = ttSupplier.currentAccount
                      banco-emit.swift        = ttSupplier.swift
                      banco-emit.endereco-4   = ttSupplier.beneficiary.

               empty temp-table tt-editor.
               run pi-print-editor(ttSupplier.bankAddress, 50).

               find first tt-editor 
                    where tt-editor.conteudo <> "" 
                          no-error.

               if avail tt-editor
               then assign banco-emit.endereco-1 = trim(tt-editor.conteudo).

               find next tt-editor 
                   where tt-editor.conteudo <> "" 
                         no-error.

               if avail tt-editor
               then assign banco-emit.endereco-2 = trim(tt-editor.conteudo).             

               /* int-emitente */
               FIND FIRST int-emitente 
                    WHERE int-emitente.cod-emitente = i-cod-emitente NO-ERROR.

               IF NOT AVAIL int-emitente THEN
                  CREATE int-emitente.

               ASSIGN int-emitente.cod-emitente                 = i-cod-emitente
                      int-emitente.logradouro                   = ttSupplier.addressStreet 
                      int-emitente.numero                       = ttSupplier.addressNumber
                      int-emitente.complemento                  = ttSupplier.addressComplement
                      int-emitente.an-ariba                     = ttSupplier.anid
                      int-emitente.acm-ariba                    = ttSupplier.acmid
                      int-emitente.ind-participa-portal-fornec  = 1.

               for each int-cont-emit exclusive-lock
                  where int-cont-emit.cod-emitente = i-cod-emitente:
                   if can-find(first cont-emit where
                                     cont-emit.cod-emitente = int-cont-emit.cod-emitente
                                 and cont-emit.sequencia    = int-cont-emit.sequencia
                                     no-lock)
                   then next.

                   delete int-cont-emit.
               end. /* for each int-cont-emit */

               for each tt-cont-emit
                  where tt-cont-emit.cod-emitente = i-cod-emitente:
                   create cont-emit.
                   buffer-copy tt-cont-emit to cont-emit.                   
               end. /* for each tt-cont-emit */
               find current cont-emit no-lock no-error.
               release cont-emit.

               for each cont-emit exclusive-lock
                  where cont-emit.cod-emitente = i-cod-emitente:
                   if (ttSupplier.comercialContactName <> ""                              and
                       cont-emit.nome                   = ttSupplier.comercialContactName and 
                       cont-emit.area                   = "COMERCIAL")
                   or (ttSupplier.nameContactLogistics <> ""                              and
                       cont-emit.nome                   = ttSupplier.nameContactLogistics and
                       cont-emit.area                   = "LOG÷STICA") 
                   then.
                   else next.

                    find int-cont-emit exclusive-lock 
                   where int-cont-emit.cod-emitente = cont-emit.cod-emitente 
                     and int-cont-emit.sequencia    = cont-emit.sequencia no-error.
                    if not available int-cont-emit then do:
                        create int-cont-emit.
                        assign int-cont-emit.cod-emitente = cont-emit.cod-emitente
                               int-cont-emit.sequencia    = cont-emit.sequencia.
                    end.
                    assign int-cont-emit.log-recebe-po = true.
               end. /* for each cont-emit */
               find current int-cont-emit no-lock no-error.
               release int-cont-emit.
                           
               /*** Integra?ío com EMS5 ***/
               ASSIGN c-file-name = SESSION:TEMP-DIRECTOR + 'retorno' + STRING(TODAY,"99999999") + '_' + STRING(TIME,"999999") + '.txt'.

               RUN cdp/cd1608.p (input emitente.cod-emitente,
                                 input emitente.cod-emitente,
                                 input 4,
                                 input YES,
                                 input 1,
                                 input 0,
                                 input c-file-name,
                                 input 'Arquivo',
                                 input "") NO-ERROR.

                       /* Tipo Pagamento: PIX = Cheque Nominal */
                IF ttSupplier.formOfPayment = "PIX" THEN DO:
                   FIND FIRST chave_pix_fornec 
                        WHERE chave_pix_fornec.cod_empresa    = v_cod_empres_usuar 
                          AND chave_pix_fornec.cdn_fornecedor = i-cod-emitente    
                          AND chave_pix_fornec.cod_chave_pix  = ttSupplier.pixKey NO-ERROR.
                 
                   IF NOT AVAIL chave_pix_fornec THEN 
                      CREATE chave_pix_fornec.
                 
                   ASSIGN chave_pix_fornec.cod_empresa       = v_cod_empres_usuar                    
                          chave_pix_fornec.cdn_fornecedor    = i-cod-emitente                         
                          chave_pix_fornec.cod_chave_pix     = ttSupplier.pixKey                      
                          chave_pix_fornec.ind_tip_chave_pix = ttSupplier.keyType /* Tipo chave */   
                          chave_pix_fornec.log_chave_prefer  = YES.
             
                END.
               /* 
               IF SEARCH(c-file-name) <> ? THEN DO:
                   INPUT STREAM str-ems5 FROM value(c-file-name).
                   REPEAT:
                       IMPORT STREAM str-ems5 UNFORMATTED c-linha-aux.
                       ASSIGN ix = INDEX(c-linha-aux,"Mensagem:")
                              iy = INDEX(c-linha-aux,"Ajuda:")
                              iz = INDEX(c-linha-aux,"NumMsg: ").
               
                       IF ix <> 0 THEN DO:
                            RUN pi-cria-retorno ("Erro",
                                                 ttSupplier.fantasyName,"Erro Integ. EMS5: " + SUBSTRING(c-linha-aux, (ix + 10), (iy - (ix + 10)))).
                       END.
                   END.
                   INPUT STREAM str-ems5 CLOSE.
             
                   OS-DELETE SILENT value(c-file-name).
               END.
               */
            END. //if not can-find first(tt-retonro)
        END. //else do
       
    END. /* ttSuppier */

    RETURN "OK".
    
  catch oStop AS Progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
      run pi-cria-erro(oStop:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  catch eAnyError AS Progress.Lang.Error:
    do iNumMessages = 1 to eAnyError:nummessages:
      run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.

END PROCEDURE.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piProcessa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessa procedure
procedure piProcessa :

    define variable jsonObjectPayload   as JsonObject no-undo.
    define variable jsonArrayPathParams as JsonArray  no-undo.
    define variable lErr                as logical    no-undo.
    define variable lRetOK              as logical    no-undo.
    define variable httpInput           as handle     no-undo.
    define variable hQuery              as handle     no-undo.
    define variable hBuffer             as handle     no-undo.
    define variable iNumFields          as integer    no-undo.
    define variable iLoop               as integer    no-undo.
    DEFINE VARIABLE objFornecedor       AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayFornecedor     AS jsonArray    NO-UNDO.
    DEFINE VARIABLE oArrayAux           AS JsonArray    NO-UNDO.
    DEFINE VARIABLE objAux              AS JsonObject   NO-UNDO.

    define variable lg-err-aux as logical no-undo.

    assign jsonObjectPayload = jsonInput:GetJsonObject("payload")
           cMetodo           = jsonInput:GetCharacter("method").

    oArrayAux = NEW JsonArray().
    oArrayAux:ADD(jsonObjectPayload).

    jsonObjectPayload = NEW JsonObject().
    jsonObjectPayload:ADD("supplier",oArrayAux).

    blk:
    do  on stop undo, leave transaction:

        create temp-table httpInput.

        lRetOK = httpInput:READ-JSON("JsonObject", jsonObjectPayload, "empty").

        assign hBuffer    = httpInput:default-buffer-handle
               iNumFields = hBuffer:num-fields.

        create query hQuery.

        hQuery:set-buffers(httpInput:default-buffer-handle).
        hQuery:query-prepare("FOR EACH " + httpInput:name).
        hQuery:query-open().
        hQuery:get-first().

        empty temp-table ttSupplier.

        do while hQuery:query-off-end = false:

            create ttSupplier.
            
            repeat iLoop = 1 to iNumFields:

               /*MESSAGE "verif.. " hBuffer:buffer-field(iLoop):NAME skip
                    hBuffer:buffer-field(iLoop):buffer-value
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

                case hBuffer:buffer-field(iLoop):name:
                    when "externalId"                then assign ttSupplier.externalId                = hBuffer:buffer-field(iLoop):buffer-value. // ID EXTERNO
                    when "supplierType"              then assign ttSupplier.supplierType              = hBuffer:buffer-field(iLoop):buffer-value. // emitente.natureza
                    when "corporateName"             then assign ttSupplier.corporateName             = hBuffer:buffer-field(iLoop):buffer-value. // emitente.nome-emit
                    when "fantasyName"               then assign ttSupplier.fantasyName               = hBuffer:buffer-field(iLoop):buffer-value. // emitente.nome-abrev
                    when "language"                  then assign ttSupplier.language                  = hBuffer:buffer-field(iLoop):buffer-value. // emitente-cex.cod-idioma
                    when "comercialContactName"      then assign ttSupplier.comercialContactName      = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.nome
                    when "comercialContactEmail"     then assign ttSupplier.comercialContactEmail     = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.e-mail
                    when "comercialContactPhone"     then assign ttSupplier.comercialContactPhone     = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.telefone
/*                     when "legalRepresentativeName"   then assign ttSupplier.legalRepresentativeName   = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.nome                 */
/*                     when "cpfLegalRepresentative"    then assign ttSupplier.cpfLegalRepresentative    = hBuffer:buffer-field(iLoop):buffer-value. // overlay(cont-emit.char-2,1,20) */
/*                     when "legalRepresentativeEmail"  then assign ttSupplier.legalRepresentativeEmail  = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.e-mail               */
                    when "nameContactLogistics"      then assign ttSupplier.nameContactLogistics      = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.nome
                    when "logisticsContactEmail"     then assign ttSupplier.logisticsContactEmail     = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.e-mail
                    when "logisticsContactPhone"     then assign ttSupplier.logisticsContactPhone     = hBuffer:buffer-field(iLoop):buffer-value. // cont-emit.telefone
                    when "financialContactEmailName" then assign ttSupplier.financialContactEmailName = hBuffer:buffer-field(iLoop):buffer-value. // [ ? ] N∆o se aplica
                    when "financialContactEmail"     then assign ttSupplier.financialContactEmail     = hBuffer:buffer-field(iLoop):buffer-value. // emitente.e-mail
                    when "financialContactPhone"     then assign ttSupplier.financialContactPhone     = hBuffer:buffer-field(iLoop):buffer-value. // emitente.telefone
                    when "addressCountry"            then assign ttSupplier.addressCountry            = hBuffer:buffer-field(iLoop):buffer-value. // emitente.pais
                    when "addressStreet"             then assign ttSupplier.addressStreet             = hBuffer:buffer-field(iLoop):buffer-value. // int-emitente.logradouro
                    when "addressNumber"             then assign ttSupplier.addressNumber             = hBuffer:buffer-field(iLoop):buffer-value. // int-emitente.numero
                    when "addressComplement"         then assign ttSupplier.addressComplement         = hBuffer:buffer-field(iLoop):buffer-value. // int-emitente.complemento
                    when "addressDistrict"           then assign ttSupplier.addressDistrict           = hBuffer:buffer-field(iLoop):buffer-value. // emitente.bairro
                    when "addressPostalCode"         then assign ttSupplier.addressPostalCode         = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cep
                    when "addressState"              then assign ttSupplier.addressState              = hBuffer:buffer-field(iLoop):buffer-value. // emitente.estado
                    when "addressCity"               then assign ttSupplier.addressCity               = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cidade
                    when "website"                   then assign ttSupplier.website                   = hBuffer:buffer-field(iLoop):buffer-value. // emitente.home-page
                    when "bankCode"                  then assign ttSupplier.bankCode                  = hBuffer:buffer-field(iLoop):buffer-value. // cta-emitente.cod-banco
                    when "bankName"                  then assign ttSupplier.bankName                  = hBuffer:buffer-field(iLoop):buffer-value. // banco-emit.banco
                    when "agency"                    then assign ttSupplier.agency                    = hBuffer:buffer-field(iLoop):buffer-value. // overlay(cta-emitente.agencia,1,6)
                    when "agencyDigit"               then assign ttSupplier.agencyDigit               = hBuffer:buffer-field(iLoop):buffer-value. // overlay(cta-emitente.agencia,7,2)
                    when "currentAccount"            then assign ttSupplier.currentAccount            = trim(hBuffer:buffer-field(iLoop):buffer-value) // overlay(cta-emitente.conta-corren,1,10)
                                                                 ttSupplier.currentAccount            = IF ttSupplier.currentAccount = ""
                                                                                                        OR LENGTH(ttSupplier.currentAccount) >= 10
                                                                                                        THEN ttSupplier.currentAccount
                                                                                                        ELSE FILL("0",10 - LENGTH(ttSupplier.currentAccount)) + ttSupplier.currentAccount.
                    when "currentAccountDigit"       then assign ttSupplier.currentAccountDigit       = hBuffer:buffer-field(iLoop):buffer-value. // overlay(cta-emitente.conta-corren,11,2)
                    when "bankAddress"               then assign ttSupplier.bankAddress               = hBuffer:buffer-field(iLoop):buffer-value. // banco-emit.endereco-1
                    when "currency"                  then assign ttSupplier.currency                  = hBuffer:buffer-field(iLoop):buffer-value. // dist-emitente.mo-fatur
                    when "pixKey"                    then assign ttSupplier.pixKey                    = hBuffer:buffer-field(iLoop):buffer-value. // [ ? ] Verificar onde colocar
                    when "keyType"                   then assign ttSupplier.keyType                   = hBuffer:buffer-field(iLoop):buffer-value. // [ ? ] Verificar onde colocar
                    when "cnpj"                      then assign ttSupplier.cnpj                      = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cgc
                    when "municipalRegistration"     then assign ttSupplier.municipalRegistration     = hBuffer:buffer-field(iLoop):buffer-value. // emitente.ins-municipal
                    when "stateRegistration"         then assign ttSupplier.stateRegistration         = hBuffer:buffer-field(iLoop):buffer-value. // emitente.ins-estadual
                    when "serviceProvider"           then assign ttSupplier.serviceProvider           = hBuffer:buffer-field(iLoop):buffer-value. // emitente.tp-desp-padrao
                    when "taxRegime"                 then assign ttSupplier.taxRegime                 = hBuffer:buffer-field(iLoop):buffer-value. // overlay(emitente.char-1,133,1)
                    when "taxId"                     then assign ttSupplier.taxId                     = hBuffer:buffer-field(iLoop):buffer-value. // overlay(emitente.char-1,103,30)
                    when "swift"                     then assign ttSupplier.swift                     = hBuffer:buffer-field(iLoop):buffer-value. // banco-emit.swift
                    when "beneficiary"	             then assign ttSupplier.beneficiary	              = hBuffer:buffer-field(iLoop):buffer-value. // banco-emit.endereco-4
                    when "formOfPayment"             then assign ttSupplier.formOfPayment             = hBuffer:buffer-field(iLoop):buffer-value. // emitente.tp-pagto
                    when "supplierGroup"             then assign ttSupplier.supplierGroup             = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cod-gr-forn
                    when "paymentTerms"              then assign ttSupplier.paymentTerms              = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cod-cod-pag
                    when "supplierId"                then assign ttSupplier.supplierId                = hBuffer:buffer-field(iLoop):buffer-value. // emitente.cod-emitente

                    WHEN "shipper"                   THEN ASSIGN ttSupplier.shipper                   = hBuffer:buffer-field(iLoop):buffer-value.
                    WHEN "incoterm"                  THEN ASSIGN ttSupplier.incoterm                  = hBuffer:buffer-field(iLoop):buffer-value.
                    WHEN "itinerary"                 THEN ASSIGN ttSupplier.itinerary                 = hBuffer:buffer-field(iLoop):buffer-value.
                    WHEN "checkpoint"                THEN ASSIGN ttSupplier.checkpoint                = hBuffer:buffer-field(iLoop):buffer-value.

                    WHEN "acmId"                     THEN ASSIGN ttSupplier.acmid                     = hBuffer:buffer-field(iLoop):buffer-value.
                    WHEN "anId"                      THEN ASSIGN ttSupplier.anid                      = hBuffer:buffer-field(iLoop):buffer-value.
                end case.
            end.

            /* Processo de integraá∆o do fornecedor ao ERP (criaá∆o OU alteraá∆o) */
            RUN piCriaAtualizaFornecedorERP (output lg-err-aux).

            IF  return-value <> "OK"
            and lg-err-aux
            THEN undo blk, leave blk.

            hQuery:get-next().

        end.
    end.

    /* Tratamos o retorno */
    assign jsonObjectOutput = new jsonObject().

    if not can-find(first RowErrors) then do:
        jsonObjectOutput:add("externalId",   string(ttSupplier.externalid)). 
        jsonObjectOutput:add("fantasyName",  string(ttSupplier.fantasyName)). 
        jsonObjectOutput:add("supplierName", string(ttSupplier.corporateName)). 
        jsonObjectOutput:add("supplierId",   string(i-cod-emitente)). 

        assign jsonOutput = new jsonObject().
        
        jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 200).
    end.
    else do:
       
        assign arrayFornecedor = new JsonArray().
       
        for each RowErrors:
            assign objFornecedor = new JsonObject().
         
            objFornecedor:add("errorCode",       rowErrors.ErrorNumber ). 
            objFornecedor:add("errorInfo",       ""). 
            objFornecedor:add("errorDescription",rowErrors.errorDescription ).
         
            arrayFornecedor:add(objFornecedor).
        end.

        jsonObjectOutput:add("Erros", arrayFornecedor).
        
    
        assign jsonOutput = new jsonObject().
        
        jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 500).
    END.

   //EMPTY TEMP-TABLE RowErrors.

  catch oStop AS Progress.Lang.StopError:
    do iNumMessages = 1 to oStop:nummessages:
      run pi-cria-erro(oStop:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.
  catch eAnyError AS Progress.Lang.Error:
    do iNumMessages = 1 to eAnyError:nummessages:
      run pi-cria-erro(eAnyError:GetMessage(iNumMessages)).
    end.
    return "NOK".
  end catch.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

procedure pi-cria-erro:
  define input parameter p-des-erro as character no-undo.
  //log-manager:write-message(p-des-erro, "ARIBA").
  create RowErrors.
  assign RowErrors.errorNumber = 17006
         RowErrors.errorDescription = p-des-erro.
  return "OK".
end procedure.

