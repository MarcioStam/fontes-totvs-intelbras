&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName esBOad098
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName emitente
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/esboad098.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
         WIDTH              = 31.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "agencia":U THEN ASSIGN pFieldValue = RowObject.agencia.
        WHEN "atividade":U THEN ASSIGN pFieldValue = RowObject.atividade.
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "bairro-cob":U THEN ASSIGN pFieldValue = RowObject.bairro-cob.
        WHEN "caixa-postal":U THEN ASSIGN pFieldValue = RowObject.caixa-postal.
        WHEN "categoria":U THEN ASSIGN pFieldValue = RowObject.categoria.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cep-cob":U THEN ASSIGN pFieldValue = RowObject.cep-cob.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "cgc-cob":U THEN ASSIGN pFieldValue = RowObject.cgc-cob.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cidade-cob":U THEN ASSIGN pFieldValue = RowObject.cidade-cob.
        WHEN "cn-codigo":U THEN ASSIGN pFieldValue = RowObject.cn-codigo.
        WHEN "cod-cacex":U THEN ASSIGN pFieldValue = RowObject.cod-cacex.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-suframa":U THEN ASSIGN pFieldValue = RowObject.cod-suframa.
        WHEN "conta-corren":U THEN ASSIGN pFieldValue = RowObject.conta-corren.
        WHEN "contato[1]":U THEN ASSIGN pFieldValue = RowObject.contato[1].
        WHEN "contato[2]":U THEN ASSIGN pFieldValue = RowObject.contato[2].
        WHEN "cx-post-cob":U THEN ASSIGN pFieldValue = RowObject.cx-post-cob.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "endereco-cob":U THEN ASSIGN pFieldValue = RowObject.endereco-cob.
        WHEN "endereco2":U THEN ASSIGN pFieldValue = RowObject.endereco2.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "estado-cob":U THEN ASSIGN pFieldValue = RowObject.estado-cob.
        WHEN "home-page":U THEN ASSIGN pFieldValue = RowObject.home-page.
        WHEN "inf-complementar":U THEN ASSIGN pFieldValue = RowObject.inf-complementar.
        WHEN "ins-est-cob":U THEN ASSIGN pFieldValue = RowObject.ins-est-cob.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "ins-municipal":U THEN ASSIGN pFieldValue = RowObject.ins-municipal.
        WHEN "insc-subs-trib":U THEN ASSIGN pFieldValue = RowObject.insc-subs-trib.
        WHEN "linha-produt":U THEN ASSIGN pFieldValue = RowObject.linha-produt.
        WHEN "nat-ope-ext":U THEN ASSIGN pFieldValue = RowObject.nat-ope-ext.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-emit":U THEN ASSIGN pFieldValue = RowObject.nome-emit.
        WHEN "nome-matriz":U THEN ASSIGN pFieldValue = RowObject.nome-matriz.
        WHEN "nome-mic-reg":U THEN ASSIGN pFieldValue = RowObject.nome-mic-reg.
        WHEN "nome-tr-red":U THEN ASSIGN pFieldValue = RowObject.nome-tr-red.
        WHEN "nr-tabpre":U THEN ASSIGN pFieldValue = RowObject.nr-tabpre.
        WHEN "obs-entrega":U THEN ASSIGN pFieldValue = RowObject.obs-entrega.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "pais-cob":U THEN ASSIGN pFieldValue = RowObject.pais-cob.
        WHEN "ramal[1]":U THEN ASSIGN pFieldValue = RowObject.ramal[1].
        WHEN "ramal[2]":U THEN ASSIGN pFieldValue = RowObject.ramal[2].
        WHEN "ramal-fac":U THEN ASSIGN pFieldValue = RowObject.ramal-fac.
        WHEN "ramal-fax":U THEN ASSIGN pFieldValue = RowObject.ramal-fax.
        WHEN "ramal-modem":U THEN ASSIGN pFieldValue = RowObject.ramal-modem.
        WHEN "telef-fac":U THEN ASSIGN pFieldValue = RowObject.telef-fac.
        WHEN "telef-modem":U THEN ASSIGN pFieldValue = RowObject.telef-modem.
        WHEN "telefax":U THEN ASSIGN pFieldValue = RowObject.telefax.
        WHEN "telefone[1]":U THEN ASSIGN pFieldValue = RowObject.telefone[1].
        WHEN "telefone[2]":U THEN ASSIGN pFieldValue = RowObject.telefone[2].
        WHEN "telex":U THEN ASSIGN pFieldValue = RowObject.telex.
        WHEN "user-libcre":U THEN ASSIGN pFieldValue = RowObject.user-libcre.
        WHEN "zip-cob-code":U THEN ASSIGN pFieldValue = RowObject.zip-cob-code.
        WHEN "zip-code":U THEN ASSIGN pFieldValue = RowObject.zip-code.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-taxa":U THEN ASSIGN pFieldValue = RowObject.data-taxa.
        WHEN "dt-fim-cred":U THEN ASSIGN pFieldValue = RowObject.dt-fim-cred.
        WHEN "dt-lim-cred":U THEN ASSIGN pFieldValue = RowObject.dt-lim-cred.
        WHEN "dt-ult-venda":U THEN ASSIGN pFieldValue = RowObject.dt-ult-venda.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "bonificacao":U THEN ASSIGN pFieldValue = RowObject.bonificacao.
        WHEN "compr-period":U THEN ASSIGN pFieldValue = RowObject.compr-period.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "lim-adicional":U THEN ASSIGN pFieldValue = RowObject.lim-adicional.
        WHEN "lim-credito":U THEN ASSIGN pFieldValue = RowObject.lim-credito.
        WHEN "per-max-canc":U THEN ASSIGN pFieldValue = RowObject.per-max-canc.
        WHEN "per-minfat":U THEN ASSIGN pFieldValue = RowObject.per-minfat.
        WHEN "percent-verba":U THEN ASSIGN pFieldValue = RowObject.percent-verba.
        WHEN "rend-tribut":U THEN ASSIGN pFieldValue = RowObject.rend-tribut.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "val-quota-media":U THEN ASSIGN pFieldValue = RowObject.val-quota-media.
        WHEN "valor-minimo":U THEN ASSIGN pFieldValue = RowObject.valor-minimo.
        WHEN "vl-max-devol":U THEN ASSIGN pFieldValue = RowObject.vl-max-devol.
        WHEN "vl-min-ad":U THEN ASSIGN pFieldValue = RowObject.vl-min-ad.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "bx-acatada":U THEN ASSIGN pFieldValue = RowObject.bx-acatada.
        WHEN "cod-banco":U THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "cod-classif-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-classif-cliente.
        WHEN "cod-classif-fornec":U THEN ASSIGN pFieldValue = RowObject.cod-classif-fornec.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "cod-gr-forn":U THEN ASSIGN pFieldValue = RowObject.cod-gr-forn.
        WHEN "cod-isencao":U THEN ASSIGN pFieldValue = RowObject.cod-isencao.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-parceiro-edi":U THEN ASSIGN pFieldValue = RowObject.cod-parceiro-edi.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "cod-repres-imp":U THEN ASSIGN pFieldValue = RowObject.cod-repres-imp.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tip-ent":U THEN ASSIGN pFieldValue = RowObject.cod-tip-ent.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "dias-comp":U THEN ASSIGN pFieldValue = RowObject.dias-comp.
        WHEN "emissao-ped":U THEN ASSIGN pFieldValue = RowObject.emissao-ped.
        WHEN "end-cobranca":U THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "esp-pd-venda":U THEN ASSIGN pFieldValue = RowObject.esp-pd-venda.
        WHEN "estoque":U THEN ASSIGN pFieldValue = RowObject.estoque.
        WHEN "flag-pag":U THEN ASSIGN pFieldValue = RowObject.flag-pag.
        WHEN "gera-difer":U THEN ASSIGN pFieldValue = RowObject.gera-difer.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "identific":U THEN ASSIGN pFieldValue = RowObject.identific.
        WHEN "ind-abrange-aval":U THEN ASSIGN pFieldValue = RowObject.ind-abrange-aval.
        WHEN "ind-atraso":U THEN ASSIGN pFieldValue = RowObject.ind-atraso.
        WHEN "ind-aval":U THEN ASSIGN pFieldValue = RowObject.ind-aval.
        WHEN "ind-aval-embarque":U THEN ASSIGN pFieldValue = RowObject.ind-aval-embarque.
        WHEN "ind-cre-cli":U THEN ASSIGN pFieldValue = RowObject.ind-cre-cli.
        WHEN "ind-dif-atrs-1":U THEN ASSIGN pFieldValue = RowObject.ind-dif-atrs-1.
        WHEN "ind-dif-atrs-2":U THEN ASSIGN pFieldValue = RowObject.ind-dif-atrs-2.
        WHEN "ind-div-atraso":U THEN ASSIGN pFieldValue = RowObject.ind-div-atraso.
        WHEN "ind-emit-retencao":U THEN ASSIGN pFieldValue = RowObject.ind-emit-retencao.
        WHEN "ind-moeda-tit":U THEN ASSIGN pFieldValue = RowObject.ind-moeda-tit.
        WHEN "ind-sit-emitente":U THEN ASSIGN pFieldValue = RowObject.ind-sit-emitente.
        WHEN "ins-banc[1]":U THEN ASSIGN pFieldValue = RowObject.ins-banc[1].
        WHEN "ins-banc[2]":U THEN ASSIGN pFieldValue = RowObject.ins-banc[2].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "istr":U THEN ASSIGN pFieldValue = RowObject.istr.
        WHEN "mod-prefer":U THEN ASSIGN pFieldValue = RowObject.mod-prefer.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "moeda-libcre":U THEN ASSIGN pFieldValue = RowObject.moeda-libcre.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-cheque-devol":U THEN ASSIGN pFieldValue = RowObject.nr-cheque-devol.
        WHEN "nr-copias-ped":U THEN ASSIGN pFieldValue = RowObject.nr-copias-ped.
        WHEN "nr-dias":U THEN ASSIGN pFieldValue = RowObject.nr-dias.
        WHEN "nr-dias-atraso":U THEN ASSIGN pFieldValue = RowObject.nr-dias-atraso.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-mesina":U THEN ASSIGN pFieldValue = RowObject.nr-mesina.
        WHEN "nr-peratr":U THEN ASSIGN pFieldValue = RowObject.nr-peratr.
        WHEN "nr-tab-progr":U THEN ASSIGN pFieldValue = RowObject.nr-tab-progr.
        WHEN "nr-titulo":U THEN ASSIGN pFieldValue = RowObject.nr-titulo.
        WHEN "perc-fat-ped":U THEN ASSIGN pFieldValue = RowObject.perc-fat-ped.
        WHEN "periodo-devol":U THEN ASSIGN pFieldValue = RowObject.periodo-devol.
        WHEN "port-prefer":U THEN ASSIGN pFieldValue = RowObject.port-prefer.
        WHEN "portador":U THEN ASSIGN pFieldValue = RowObject.portador.
        WHEN "prox-ad":U THEN ASSIGN pFieldValue = RowObject.prox-ad.
        WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
        WHEN "tip-cob-desp":U THEN ASSIGN pFieldValue = RowObject.tip-cob-desp.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "tp-pagto":U THEN ASSIGN pFieldValue = RowObject.tp-pagto.
        WHEN "tp-qt-prg":U THEN ASSIGN pFieldValue = RowObject.tp-qt-prg.
        WHEN "tp-rec-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-rec-padrao.
        WHEN "tr-ar-valor":U THEN ASSIGN pFieldValue = RowObject.tr-ar-valor.
        WHEN "ven-domingo":U THEN ASSIGN pFieldValue = RowObject.ven-domingo.
        WHEN "ven-feriado":U THEN ASSIGN pFieldValue = RowObject.ven-feriado.
        WHEN "ven-sabado":U THEN ASSIGN pFieldValue = RowObject.ven-sabado.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "agente-retencao":U THEN ASSIGN pFieldValue = RowObject.agente-retencao.
        WHEN "calcula-multa":U THEN ASSIGN pFieldValue = RowObject.calcula-multa.
        WHEN "contrib-icms":U THEN ASSIGN pFieldValue = RowObject.contrib-icms.
        WHEN "emite-bloq":U THEN ASSIGN pFieldValue = RowObject.emite-bloq.
        WHEN "emite-etiq":U THEN ASSIGN pFieldValue = RowObject.emite-etiq.
        WHEN "forn-exp":U THEN ASSIGN pFieldValue = RowObject.forn-exp.
        WHEN "gera-ad":U THEN ASSIGN pFieldValue = RowObject.gera-ad.
        WHEN "ind-apr-cred":U THEN ASSIGN pFieldValue = RowObject.ind-apr-cred.
        WHEN "ind-cred-abat":U THEN ASSIGN pFieldValue = RowObject.ind-cred-abat.
        WHEN "ind-fat-par":U THEN ASSIGN pFieldValue = RowObject.ind-fat-par.
        WHEN "ind-lib-estoque":U THEN ASSIGN pFieldValue = RowObject.ind-lib-estoque.
        WHEN "ind-licenciador":U THEN ASSIGN pFieldValue = RowObject.ind-licenciador.
        WHEN "ind-rendiment":U THEN ASSIGN pFieldValue = RowObject.ind-rendiment.
        WHEN "item-cli":U THEN ASSIGN pFieldValue = RowObject.item-cli.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "percepcao":U THEN ASSIGN pFieldValue = RowObject.percepcao.
        WHEN "prog-emit":U THEN ASSIGN pFieldValue = RowObject.prog-emit.
        WHEN "recebe-inf-sci":U THEN ASSIGN pFieldValue = RowObject.recebe-inf-sci.
        WHEN "utiliza-verba":U THEN ASSIGN pFieldValue = RowObject.utiliza-verba.
        WHEN "vencto-dia-nao-util":U THEN ASSIGN pFieldValue = RowObject.vencto-dia-nao-util.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraitMain DBOProgram 
PROCEDURE setConstraitMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

