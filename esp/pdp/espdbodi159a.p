&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p 
    Purpose    : O DBO (Datasul   Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
/* MESSAGE 'esbodi159a 1'                 */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName esbodi159a
&GLOBAL-DEFINE DBOVersion 1.00.00.000 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  tt-ped-venda
&GLOBAL-DEFINE TableLabel Pedido
&GLOBAL-DEFINE QueryName  qr{&TableName} 

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
DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.      
DEFINE TEMP-TABLE RowObject NO-UNDO LIKE ped-venda
       field r-rowid as rowid
       FIELD r-ped-venda AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
       field r-rowid as rowid
       FIELD r-ped-venda AS ROWID.

DEFINE TEMP-TABLE tt-estab-depos NO-UNDO                                  
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD cod-depos   LIKE deposito.cod-depos.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---
{method/dboqry.i}*/
DEFINE QUERY {&QueryName} FOR {&TableName} SCROLLING.

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
         HEIGHT             = 12.92
         WIDTH              = 40.
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
        WHEN "aprov-forcado":U THEN ASSIGN pFieldValue = RowObject.aprov-forcado.
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "caixa-postal":U THEN ASSIGN pFieldValue = RowObject.caixa-postal.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cidade-cif":U THEN ASSIGN pFieldValue = RowObject.cidade-cif.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-entrega-tri":U THEN ASSIGN pFieldValue = RowObject.cod-entrega-tri.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "cod-usu-alt-sit":U THEN ASSIGN pFieldValue = RowObject.cod-usu-alt-sit.
        WHEN "cod-usu-lib-desconto":U THEN ASSIGN pFieldValue = RowObject.cod-usu-lib-desconto.
        WHEN "cond-espec":U THEN ASSIGN pFieldValue = RowObject.cond-espec.
        WHEN "cond-redespa":U THEN ASSIGN pFieldValue = RowObject.cond-redespa.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "des-pct-desconto-inform":U THEN ASSIGN pFieldValue = RowObject.des-pct-desconto-inform.
        WHEN "desc-bloq-cr":U THEN ASSIGN pFieldValue = RowObject.desc-bloq-cr.
        WHEN "desc-cancela":U THEN ASSIGN pFieldValue = RowObject.desc-cancela.
        WHEN "desc-forc-cr":U THEN ASSIGN pFieldValue = RowObject.desc-forc-cr.
        WHEN "desc-lib-desconto":U THEN ASSIGN pFieldValue = RowObject.desc-lib-desconto.
        WHEN "desc-lib-preco":U THEN ASSIGN pFieldValue = RowObject.desc-lib-preco.
        WHEN "desc-reativa":U THEN ASSIGN pFieldValue = RowObject.desc-reativa.
        WHEN "desc-suspend":U THEN ASSIGN pFieldValue = RowObject.desc-suspend.
        WHEN "desc-txt":U THEN ASSIGN pFieldValue = RowObject.desc-txt.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "estab-atend":U THEN ASSIGN pFieldValue = RowObject.estab-atend.
        WHEN "estab-central":U THEN ASSIGN pFieldValue = RowObject.estab-central.
        WHEN "estab-destino":U THEN ASSIGN pFieldValue = RowObject.estab-destino.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "invoice-id":U THEN ASSIGN pFieldValue = RowObject.invoice-id.
        WHEN "local-entreg":U THEN ASSIGN pFieldValue = RowObject.local-entreg.
        WHEN "motivo-alt-sit-quota":U THEN ASSIGN pFieldValue = RowObject.motivo-alt-sit-quota.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "no-ab-reppri":U THEN ASSIGN pFieldValue = RowObject.no-ab-reppri.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-abrev-tri":U THEN ASSIGN pFieldValue = RowObject.nome-abrev-tri.
        WHEN "nome-prog":U THEN ASSIGN pFieldValue = RowObject.nome-prog.
        WHEN "nome-tr-red":U THEN ASSIGN pFieldValue = RowObject.nome-tr-red.
        WHEN "nome-transp":U THEN ASSIGN pFieldValue = RowObject.nome-transp.
        WHEN "nr-invoice":U THEN ASSIGN pFieldValue = RowObject.nr-invoice.
        WHEN "nr-ped-cot-orig":U THEN ASSIGN pFieldValue = RowObject.nr-ped-cot-orig.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-pedrep":U THEN ASSIGN pFieldValue = RowObject.nr-pedrep.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "nr-proforma":U THEN ASSIGN pFieldValue = RowObject.nr-proforma.
        WHEN "nr-tabpre":U THEN ASSIGN pFieldValue = RowObject.nr-tabpre.
        WHEN "nr-versao":U THEN ASSIGN pFieldValue = RowObject.nr-versao.
        WHEN "num-pedido-bonif":U THEN ASSIGN pFieldValue = RowObject.num-pedido-bonif.
        WHEN "num-pedido-origem":U THEN ASSIGN pFieldValue = RowObject.num-pedido-origem.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "permissao":U THEN ASSIGN pFieldValue = RowObject.permissao.
        WHEN "placa":U THEN ASSIGN pFieldValue = RowObject.placa.
        WHEN "quem-aprovou":U THEN ASSIGN pFieldValue = RowObject.quem-aprovou.
        WHEN "tp-pedido":U THEN ASSIGN pFieldValue = RowObject.tp-pedido.
        WHEN "uf-placa":U THEN ASSIGN pFieldValue = RowObject.uf-placa.
        WHEN "user-alte":U THEN ASSIGN pFieldValue = RowObject.user-alte.
        WHEN "user-aprov":U THEN ASSIGN pFieldValue = RowObject.user-aprov.
        WHEN "user-aprov-cot":U THEN ASSIGN pFieldValue = RowObject.user-aprov-cot.
        WHEN "user-canc":U THEN ASSIGN pFieldValue = RowObject.user-canc.
        WHEN "user-impl":U THEN ASSIGN pFieldValue = RowObject.user-impl.
        WHEN "user-preco":U THEN ASSIGN pFieldValue = RowObject.user-preco.
        WHEN "user-reat":U THEN ASSIGN pFieldValue = RowObject.user-reat.
        WHEN "user-suspen":U THEN ASSIGN pFieldValue = RowObject.user-suspen.
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
        WHEN "dat-alter-sit":U THEN ASSIGN pFieldValue = RowObject.dat-alter-sit.
        WHEN "dat-aprov-preco":U THEN ASSIGN pFieldValue = RowObject.dat-aprov-preco.
        WHEN "dat-sit-desconto":U THEN ASSIGN pFieldValue = RowObject.dat-sit-desconto.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-apr-cred":U THEN ASSIGN pFieldValue = RowObject.dt-apr-cred.
        WHEN "dt-aprov-cot":U THEN ASSIGN pFieldValue = RowObject.dt-aprov-cot.
        WHEN "dt-base-ft":U THEN ASSIGN pFieldValue = RowObject.dt-base-ft.
        WHEN "dt-cancela":U THEN ASSIGN pFieldValue = RowObject.dt-cancela.
        WHEN "dt-devolucao":U THEN ASSIGN pFieldValue = RowObject.dt-devolucao.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-entorig":U THEN ASSIGN pFieldValue = RowObject.dt-entorig.
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
        WHEN "dt-entrega-prim":U THEN ASSIGN pFieldValue = RowObject.dt-entrega-prim.
        WHEN "dt-fimvig":U THEN ASSIGN pFieldValue = RowObject.dt-fimvig.
        WHEN "dt-implant":U THEN ASSIGN pFieldValue = RowObject.dt-implant.
        WHEN "dt-inivig":U THEN ASSIGN pFieldValue = RowObject.dt-inivig.
        WHEN "dt-lim-fat":U THEN ASSIGN pFieldValue = RowObject.dt-lim-fat.
        WHEN "dt-mensagem":U THEN ASSIGN pFieldValue = RowObject.dt-mensagem.
        WHEN "dt-minfat":U THEN ASSIGN pFieldValue = RowObject.dt-minfat.
        WHEN "dt-prev-vend":U THEN ASSIGN pFieldValue = RowObject.dt-prev-vend.
        WHEN "dt-reativ":U THEN ASSIGN pFieldValue = RowObject.dt-reativ.
        WHEN "dt-suspensao":U THEN ASSIGN pFieldValue = RowObject.dt-suspensao.
        WHEN "dt-useralt":U THEN ASSIGN pFieldValue = RowObject.dt-useralt.
        WHEN "dt-usercan":U THEN ASSIGN pFieldValue = RowObject.dt-usercan.
        WHEN "dt-userimp":U THEN ASSIGN pFieldValue = RowObject.dt-userimp.
        WHEN "dt-userrea":U THEN ASSIGN pFieldValue = RowObject.dt-userrea.
        WHEN "dt-usersusp":U THEN ASSIGN pFieldValue = RowObject.dt-usersusp.
        WHEN "dt-validade-cot":U THEN ASSIGN pFieldValue = RowObject.dt-validade-cot.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "distancia":U THEN ASSIGN pFieldValue = RowObject.distancia.
        WHEN "pct-min-rentab":U THEN ASSIGN pFieldValue = RowObject.pct-min-rentab.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "per-max-canc":U THEN ASSIGN pFieldValue = RowObject.per-max-canc.
        WHEN "perc-desco1":U THEN ASSIGN pFieldValue = RowObject.perc-desco1.
        WHEN "perc-desco2":U THEN ASSIGN pFieldValue = RowObject.perc-desco2.
        WHEN "tab-ind-fin":U THEN ASSIGN pFieldValue = RowObject.tab-ind-fin.
        WHEN "taxa-orig":U THEN ASSIGN pFieldValue = RowObject.taxa-orig.
        WHEN "taxa-real":U THEN ASSIGN pFieldValue = RowObject.taxa-real.
        WHEN "val-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-desconto-total.
        WHEN "val-pct-desconto-tab-preco":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-tab-preco.
        WHEN "val-pct-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-total.
        WHEN "val-pct-desconto-valor":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-valor.
        WHEN "vl-cred-lib":U THEN ASSIGN pFieldValue = RowObject.vl-cred-lib.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-liq-abe":U THEN ASSIGN pFieldValue = RowObject.vl-liq-abe.
        WHEN "vl-liq-ped":U THEN ASSIGN pFieldValue = RowObject.vl-liq-ped.
        WHEN "vl-mer-abe":U THEN ASSIGN pFieldValue = RowObject.vl-mer-abe.
        WHEN "vl-tot-ped":U THEN ASSIGN pFieldValue = RowObject.vl-tot-ped.
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
        WHEN "cd-cancela":U THEN ASSIGN pFieldValue = RowObject.cd-cancela.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-des-merc":U THEN ASSIGN pFieldValue = RowObject.cod-des-merc.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-message-alerta":U THEN ASSIGN pFieldValue = RowObject.cod-message-alerta.
        WHEN "cod-mot-canc-cot":U THEN ASSIGN pFieldValue = RowObject.cod-mot-canc-cot.
        WHEN "cod-portador":U THEN ASSIGN pFieldValue = RowObject.cod-portador.
        WHEN "cod-priori":U THEN ASSIGN pFieldValue = RowObject.cod-priori.
        WHEN "cod-sit-aval":U THEN ASSIGN pFieldValue = RowObject.cod-sit-aval.
        WHEN "cod-sit-com":U THEN ASSIGN pFieldValue = RowObject.cod-sit-com.
        WHEN "cod-sit-ped":U THEN ASSIGN pFieldValue = RowObject.cod-sit-ped.
        WHEN "cod-sit-pre":U THEN ASSIGN pFieldValue = RowObject.cod-sit-pre.
        WHEN "cod-sit-preco":U THEN ASSIGN pFieldValue = RowObject.cod-sit-preco.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "esp-ped":U THEN ASSIGN pFieldValue = RowObject.esp-ped.
        WHEN "ind-imp-ped":U THEN ASSIGN pFieldValue = RowObject.ind-imp-ped.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-sit-desconto":U THEN ASSIGN pFieldValue = RowObject.ind-sit-desconto.
        WHEN "ind-tp-frete":U THEN ASSIGN pFieldValue = RowObject.ind-tp-frete.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "mo-fatur":U THEN ASSIGN pFieldValue = RowObject.mo-fatur.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "nr-cotacao":U THEN ASSIGN pFieldValue = RowObject.nr-cotacao.
        WHEN "nr-ind-finan":U THEN ASSIGN pFieldValue = RowObject.nr-ind-finan.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "nr-tab-finan":U THEN ASSIGN pFieldValue = RowObject.nr-tab-finan.
        WHEN "nro-proc-alteracao":U THEN ASSIGN pFieldValue = RowObject.nro-proc-alteracao.
        WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "proc-edi":U THEN ASSIGN pFieldValue = RowObject.proc-edi.
        WHEN "tip-cob-desp":U THEN ASSIGN pFieldValue = RowObject.tip-cob-desp.
        WHEN "tp-faturam":U THEN ASSIGN pFieldValue = RowObject.tp-faturam.
        WHEN "tp-preco":U THEN ASSIGN pFieldValue = RowObject.tp-preco.
        WHEN "tp-receita":U THEN ASSIGN pFieldValue = RowObject.tp-receita.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-pedido
  Parameters:  
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE tt-ped-venda.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE tt-ped-venda.nr-pedcli NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli.

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
        WHEN "atendido":U THEN ASSIGN pFieldValue = RowObject.atendido.
        WHEN "completo":U THEN ASSIGN pFieldValue = RowObject.completo.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "dsp-pre-fat":U THEN ASSIGN pFieldValue = RowObject.dsp-pre-fat.
        WHEN "inc-desc-txt":U THEN ASSIGN pFieldValue = RowObject.inc-desc-txt.
        WHEN "ind-antecip":U THEN ASSIGN pFieldValue = RowObject.ind-antecip.
        WHEN "ind-aprov":U THEN ASSIGN pFieldValue = RowObject.ind-aprov.
        WHEN "ind-ent-completa":U THEN ASSIGN pFieldValue = RowObject.ind-ent-completa.
        WHEN "ind-fat-par":U THEN ASSIGN pFieldValue = RowObject.ind-fat-par.
        WHEN "ind-lib-nota":U THEN ASSIGN pFieldValue = RowObject.ind-lib-nota.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-cot-impressa":U THEN ASSIGN pFieldValue = RowObject.log-cot-impressa.
        WHEN "log-cotacao":U THEN ASSIGN pFieldValue = RowObject.log-cotacao.
        WHEN "log-ped-bonif-pendente":U THEN ASSIGN pFieldValue = RowObject.log-ped-bonif-pendente.
        WHEN "log-pedido-alterado":U THEN ASSIGN pFieldValue = RowObject.log-pedido-alterado.
        WHEN "log-pedido-mp":U THEN ASSIGN pFieldValue = RowObject.log-pedido-mp.
        WHEN "log-usa-tabela-desconto":U THEN ASSIGN pFieldValue = RowObject.log-usa-tabela-desconto.
        WHEN "replica-pd":U THEN ASSIGN pFieldValue = RowObject.replica-pd.
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
  Purpose:     Reposiciona registro com base no °ndice ch-pedido
  Parameters:  
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE tt-ped-venda.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE tt-ped-venda.nr-pedcli NO-UNDO.

    FIND FIRST bftt-ped-venda WHERE 
        bftt-ped-venda.nome-abrev = pnome-abrev AND 
        bftt-ped-venda.nr-pedcli = pnr-pedcli NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-ped-venda THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-ped-venda)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                              BY {&TableName}.dt-emissao
                              BY {&TableName}.cod-priori 
                              BY {&TableName}.nr-pedido.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNavega DBOProgram 
PROCEDURE openQueryNavega :
/*------------------------------------------------------------------------------
  Purpose:    Abrir a query conforme necessidade de navegaá∆o do ESPDP006
  Parameters: <none>
  Notes:      Abre a query conforme a necessidade de ordenaá∆o da navegaá∆o do ESPDP006
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                  BY {&TableName}.dt-emissao
                                  BY {&TableName}.nr-pedcli.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-pedidos DBOProgram 
PROCEDURE pi-carrega-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pEstabel-ini   LIKE tt-ped-venda.cod-estabel  NO-UNDO. 
    DEFINE INPUT PARAMETER pEstabel-fim   LIKE tt-ped-venda.cod-estabel  NO-UNDO. 
    DEFINE INPUT PARAMETER pAtendente-ini LIKE tt-ped-venda.tp-pedido    NO-UNDO. 
    DEFINE INPUT PARAMETER pAtendente-fim LIKE tt-ped-venda.tp-pedido    NO-UNDO. 
    DEFINE INPUT PARAMETER pRepres-ini    LIKE repres.cod-rep            NO-UNDO. 
    DEFINE INPUT PARAMETER pRepres-fim    LIKE repres.cod-rep            NO-UNDO. 
    DEFINE INPUT PARAMETER pEntrega-ini   LIKE tt-ped-venda.dt-entrega   NO-UNDO. 
    DEFINE INPUT PARAMETER pEntrega-fim   LIKE tt-ped-venda.dt-entrega   NO-UNDO. 
    DEFINE INPUT PARAMETER pPedido-ini    LIKE tt-ped-venda.nr-pedcli    NO-UNDO. 
    DEFINE INPUT PARAMETER pPedido-fim    LIKE tt-ped-venda.nr-pedcli    NO-UNDO. 
    DEFINE INPUT PARAMETER pImpPed-ini    LIKE tt-ped-venda.dt-implant   NO-UNDO. 
    DEFINE INPUT PARAMETER pImpPed-fim    LIKE tt-ped-venda.dt-implant   NO-UNDO. 
    DEFINE INPUT PARAMETER pCond-ini      LIKE tt-ped-venda.cod-cond-pag NO-UNDO. 
    DEFINE INPUT PARAMETER pCond-fim      LIKE tt-ped-venda.cod-cond-pag NO-UNDO. 
    DEFINE INPUT PARAMETER pPrior-ini     LIKE tt-ped-venda.cod-priori   NO-UNDO. 
    DEFINE INPUT PARAMETER pPrior-fim     LIKE tt-ped-venda.cod-priori   NO-UNDO.
    DEFINE INPUT PARAMETER pOperMestreIni AS INTEGER                     NO-UNDO.   
    DEFINE INPUT PARAMETER pOperMestrefim AS INTEGER                     NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmite-ini  LIKE tt-ped-venda.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmite-fim  LIKE tt-ped-venda.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pItCodigo      AS CHARACTER                   NO-UNDO. 
    DEFINE INPUT PARAMETER pUnidNeg       LIKE unid-negoc.cod-unid-negoc NO-UNDO. 
    DEFINE INPUT PARAMETER pSitCredito    AS CHARACTER                   NO-UNDO. 
    DEFINE INPUT PARAMETER pEntFutura     AS LOGICAL                     NO-UNDO. 
    DEFINE INPUT PARAMETER pestado-ini    LIKE ped-venda.estado          NO-UNDO.
    DEFINE INPUT PARAMETER pestado-fim    LIKE ped-venda.estado          NO-UNDO.
/*     DEFINE INPUT PARAMETER TABLE FOR tt-estab-depos. */

    DEFINE VARIABLE dt-aux      AS DATE             NO-UNDO.
    DEFINE VARIABLE l-entFutura AS LOGICAL  INIT NO NO-UNDO.
    
    FOR EACH tt-ped-venda:
        DELETE tt-ped-venda.
    END.

/*     MESSAGE 'pi-carrega-pedidos'           */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

    IF pPedido-ini <> "" THEN DO:
        FOR EACH ped-venda NO-LOCK  
           WHERE ped-venda.nr-pedcli >= pPedido-ini                
             AND ped-venda.nr-pedcli <= pPedido-fim:

             IF (ped-venda.tp-pedido < pAtendente-ini
             OR  ped-venda.tp-pedido > pAtendente-fim) THEN NEXT.
          
             IF (ped-venda.dt-entrega < pEntrega-ini             
             OR  ped-venda.dt-entrega > pEntrega-fim) THEN NEXT. 
          
             IF (ped-venda.cod-priori < pPrior-ini   
             OR  ped-venda.cod-priori > pPrior-fim) THEN NEXT. 
         
             IF (ped-venda.cod-cond-pag < pCond-ini                
             OR  ped-venda.cod-cond-pag > pCond-fim) THEN NEXT.
          
             IF (ped-venda.cod-estabel < pEstabel-ini 
             OR  ped-venda.cod-estabel > pEstabel-fim) THEN NEXT.
         
             IF  ped-venda.cod-emitente < pCodEmite-ini
             OR  ped-venda.cod-emitente > pCodEmite-fim THEN NEXT.

             IF ped-venda.estado < pestado-ini
             OR ped-venda.estado > pestado-fim THEN NEXT.

             /*******************************/
             IF ped-venda.cod-sit-ped   > 2   THEN NEXT. /*1 - aberto, 2 - atendido parcial*/
             IF ped-venda.completo     <> YES THEN NEXT.
             IF ped-venda.cod-priori    = 44  THEN NEXT. /*Pedidos com prioridade 44 n∆o devem aparecer para faturamento na ESPDP006*/            
             /*******************************/

          FOR FIRST int-cond-pagto NO-LOCK
              WHERE (int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag OR ped-venda.cod-cond-pag = 0),   
              FIRST emitente NO-LOCK 
              WHERE emitente.cod-emitente   = ped-venda.cod-emitente
                AND (emitente.ind-lib-estoq = YES 
                 OR  ped-venda.cod-sit-aval = 3   
                 OR  ped-venda.mo-codigo   <> 0     
                 OR  SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U): /* SupplierCard */

              FIND FIRST int-ped-venda NO-LOCK
                   WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            
/*               FIND FIRST tt-estab-depos                                                                      */
/*                    WHERE tt-estab-depos.cod-estabel = ped-venda.cod-estabel                                  */
/*                      AND tt-estab-depos.cod-depos   = "TNF" NO-ERROR.                                        */
/*                                                                                                              */
/*               IF AVAILABLE int-ped-venda THEN DO:                                                            */
/*                   IF SUBSTRING(int-ped-venda.char-1, 11, 1)  = "S":U AND NOT AVAIL tt-estab-depos THEN NEXT. */
/*                   IF SUBSTRING(int-ped-venda.char-1, 11, 1) <> "S":U AND AVAIL tt-estab-depos     THEN NEXT. */
/*               END.                                                                                           */
/*               ELSE                                                                                           */
/*                   IF AVAIL tt-estab-depos THEN NEXT.                                                         */

              CASE pSitCredito:
                  WHEN "N∆o Avaliado"  THEN IF ped-venda.cod-sit-aval <> 1 THEN NEXT.
                  WHEN "Avaliado"      THEN IF ped-venda.cod-sit-aval <> 2 THEN NEXT.
                  WHEN "Aprovado"      THEN IF ped-venda.cod-sit-aval <> 3 THEN NEXT.
                  WHEN "N∆o Aprovado"  THEN IF ped-venda.cod-sit-aval <> 4 THEN NEXT.
                  WHEN "Pendente Inf"  THEN IF ped-venda.cod-sit-aval <> 5 THEN NEXT.
              END CASE. /* CASE pSitCredito: */
            
              IF pEntFutura = NO THEN DO:
                  ASSIGN l-entFutura = YES.
            
                  IF CAN-FIND(FIRST ped-item
                              WHERE  ped-item.nome-abrev    = ped-venda.nome-abrev  
                                AND  ped-item.nr-pedcli     = ped-venda.nr-pedcli   
                                AND (ped-item.cod-sit-item  = 1
                                 OR  ped-item.cod-sit-item  = 2)
                                AND  ped-item.dt-entrega   <= TODAY) THEN
                      ASSIGN l-entFutura = NO.
            
                  IF l-entFutura THEN NEXT.
              END. /* IF pEntFutura = NO THEN DO: */
            
              IF ped-venda.cod-priori = 09 THEN DO:
            
                  IF  pPrior-ini = 09 AND pPrior-fim = 09 THEN DO:
                      FIND FIRST int-ped-venda
                           WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                             AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
                      IF AVAIL int-ped-venda THEN DO:
                          IF SUBSTRING(int-ped-venda.char-1,250,15) <> c-seg-usuario THEN DO:
                              FIND FIRST ponto-programa NO-LOCK
                                   WHERE ponto-programa.nome-programa = "espdp006"
                                     AND ponto-programa.ponto         = 14 NO-ERROR.
                              IF AVAIL ponto-programa THEN DO:
                                  IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                                          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                            AND conteudo-programa.conteudo     = c-seg-usuario) THEN NEXT.
                              END.
                          END.
                      END. /* IF AVAIL int-ped-venda THEN DO: */
                  END.
                  ELSE NEXT.
              END.
            
              IF pItCodigo <> "" AND 
                 NOT CAN-FIND(FIRST ped-item OF ped-venda NO-LOCK 
                              WHERE ped-item.it-codigo     = pItCodigo 
                                AND ped-item.cod-sit-item <= 2) THEN NEXT.
            
              IF pUnidNeg <> "" AND NOT CAN-FIND(FIRST ped-item OF ped-venda NO-LOCK 
                                                 WHERE ped-item.cod-unid-neg = pUnidNeg) THEN NEXT.
            
              CREATE tt-ped-venda.
              BUFFER-COPY ped-venda TO tt-ped-venda.
              ASSIGN tt-ped-venda.r-rowid     = ROWID(ped-venda)
                     tt-ped-venda.r-ped-venda = ROWID(ped-venda).  
          END.
        END.
    END.
    ELSE DO:
        DO dt-aux = pImpPed-ini TO pImpPed-fim:
            FOR EACH ped-venda NO-LOCK  /*USE-INDEX ch-implant */
               WHERE ped-venda.dt-implant    = dt-aux
                 AND ped-venda.cod-sit-ped  <= 2 
                 AND ped-venda.nr-pedcli    >= pPedido-ini                
                 AND ped-venda.nr-pedcli    <= pPedido-fim 
                 AND ped-venda.completo      = YES
                 AND ped-venda.tp-pedido    >= pAtendente-ini
                 AND ped-venda.tp-pedido    <= pAtendente-fim
                 AND ped-venda.cod-estabel  >= pEstabel-ini
                 AND ped-venda.cod-estabel  <= pEstabel-fim
                 AND ped-venda.dt-entrega   >= pEntrega-ini
                 AND ped-venda.dt-entrega   <= pEntrega-fim
                 AND ped-venda.cod-priori   >= pPrior-ini 
                 AND ped-venda.cod-priori   <= pPrior-fim
                 AND ped-venda.cod-emitente >= pCodEmite-ini
                 AND ped-venda.cod-emitente <= pCodEmite-fim,
               FIRST int-cond-pagto NO-LOCK
               WHERE (int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag OR ped-venda.cod-cond-pag = 0),   
               FIRST emitente NO-LOCK 
               WHERE emitente.cod-emitente   = ped-venda.cod-emitente
                 AND (emitente.ind-lib-estoq = YES 
                  OR  ped-venda.cod-sit-aval = 3   
                  OR  ped-venda.mo-codigo    <> 0     
                  OR  SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U), /* SupplierCard */
                  FIRST repres NO-LOCK
                  WHERE repres.nome-abrev = ped-venda.no-ab-reppri 
                    AND repres.cod-rep >= pRepres-ini 
                    AND repres.cod-rep <= pRepres-fim,
                  first atendente NO-LOCK
                  WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                    AND atendente.oper-mestre >= pOperMestreIni
                    AND atendente.oper-mestre <= pOperMestrefim:
       
                /*******************************/
                IF (ped-venda.cod-cond-pag  < pCond-ini                
                OR  ped-venda.cod-cond-pag  > pCond-fim     ) THEN NEXT.
       
                /*IF (ped-venda.nr-pedcli < pPedido-ini 
                OR  ped-venda.nr-pedcli > pPedido-fim) THEN NEXT.
       
                IF (ped-venda.cod-estabel < pEstabel-ini 
                OR  ped-venda.cod-estabel > pEstabel-fim)     THEN NEXT.
       
                IF ped-venda.completo      <> YES             THEN NEXT.
       
                IF (ped-venda.tp-pedido     < pAtendente-ini
                OR  ped-venda.tp-pedido     > pAtendente-fim) THEN NEXT.
       
                IF (ped-venda.dt-entrega    < pEntrega-ini             
                OR  ped-venda.dt-entrega    > pEntrega-fim  ) THEN NEXT. 
       
                IF (ped-venda.cod-priori    < pPrior-ini   
                OR  ped-venda.cod-priori    > pPrior-fim    ) THEN NEXT. */
       
                IF ped-venda.cod-priori     = 44              THEN NEXT. /*Pedidos com prioridade 44 n∆o devem aparecer para faturamento na ESPDP006*/            
                /*******************************/
                
                IF ped-venda.estado < pestado-ini
                OR ped-venda.estado > pestado-fim THEN NEXT.

                FIND FIRST int-ped-venda NO-LOCK
                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
       
/*                 FIND FIRST tt-estab-depos                                                                      */
/*                      WHERE tt-estab-depos.cod-estabel = ped-venda.cod-estabel                                  */
/*                        AND tt-estab-depos.cod-depos   = "TNF" NO-ERROR.                                        */
/*                                                                                                                */
/*                 IF AVAILABLE int-ped-venda THEN DO:                                                            */
/*                     IF SUBSTRING(int-ped-venda.char-1, 11, 1)  = "S":U AND NOT AVAIL tt-estab-depos THEN NEXT. */
/*                     IF SUBSTRING(int-ped-venda.char-1, 11, 1) <> "S":U AND AVAIL tt-estab-depos     THEN NEXT. */
/*                 END.                                                                                           */
/*                 ELSE                                                                                           */
/*                     IF AVAIL tt-estab-depos THEN NEXT.                                                         */
       
                CASE pSitCredito:
                    WHEN "N∆o Avaliado"  THEN IF ped-venda.cod-sit-aval <> 1 THEN NEXT.
                    WHEN "Avaliado"      THEN IF ped-venda.cod-sit-aval <> 2 THEN NEXT.
                    WHEN "Aprovado"      THEN IF ped-venda.cod-sit-aval <> 3 THEN NEXT.
                    WHEN "N∆o Aprovado"  THEN IF ped-venda.cod-sit-aval <> 4 THEN NEXT.
                    WHEN "Pendente Inf"  THEN IF ped-venda.cod-sit-aval <> 5 THEN NEXT.
                END CASE. /* CASE pSitCredito: */
       
                IF pEntFutura = NO THEN DO:
                    ASSIGN l-entFutura = YES.
       
                    IF CAN-FIND(FIRST ped-item
                                WHERE  ped-item.nome-abrev    = ped-venda.nome-abrev  
                                  AND  ped-item.nr-pedcli     = ped-venda.nr-pedcli   
                                  AND (ped-item.cod-sit-item  = 1
                                   OR  ped-item.cod-sit-item  = 2)
                                  AND  ped-item.dt-entrega   <= TODAY) THEN
                        ASSIGN l-entFutura = NO.
       
                    IF l-entFutura THEN NEXT.
                END. /* IF pEntFutura = NO THEN DO: */
       
                IF ped-venda.cod-priori = 09 THEN DO:
       
                    IF  pPrior-ini = 09
                    AND pPrior-fim = 09 THEN DO:
                        FIND FIRST int-ped-venda
                            WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                              AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
                        IF AVAIL int-ped-venda THEN DO:
                            IF SUBSTRING(int-ped-venda.char-1,250,15) <> c-seg-usuario THEN DO:
                                FIND FIRST ponto-programa NO-LOCK
                                    WHERE ponto-programa.nome-programa = "espdp006"
                                      AND ponto-programa.ponto         = 14 NO-ERROR.
                                IF AVAIL ponto-programa THEN DO:
                                    IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK
                                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                              AND conteudo-programa.conteudo     = c-seg-usuario) THEN NEXT.
                                END.
                            END.
                        END. /* IF AVAIL int-ped-venda THEN DO: */
                    END.
                    ELSE NEXT.
       
                END.
       
                /*IF (ped-venda.cod-emitente < pCodEmite-ini
                OR  ped-venda.cod-emitente > pCodEmite-fim) THEN NEXT.
       
                IF  INT(ped-venda.tp-pedido) < INT(pAtendente-ini) OR
                    INT(ped-venda.tp-pedido) > INT(pAtendente-fim) THEN NEXT.
        
                IF  (ped-venda.cod-estabel < pEstabel-ini OR
                     ped-venda.cod-estabel > pEstabel-fim) THEN NEXT. */
        
                IF pItCodigo <> "" AND 
                   NOT CAN-FIND(FIRST ped-item OF ped-venda NO-LOCK 
                                WHERE ped-item.it-codigo = pItCodigo 
                                  AND ped-item.cod-sit-item <= 2) THEN NEXT.
        
                IF pUnidNeg <> "" AND 
                   NOT CAN-FIND(FIRST ped-item OF ped-venda NO-LOCK 
                                WHERE ped-item.cod-unid-neg = pUnidNeg) THEN NEXT.
       
                CREATE tt-ped-venda.
                BUFFER-COPY ped-venda TO tt-ped-venda.
                ASSIGN tt-ped-venda.r-rowid     = ROWID(ped-venda)
                       tt-ped-venda.r-ped-venda = ROWID(ped-venda).
            END.
        END.
    END.
    

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

