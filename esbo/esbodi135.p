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
&GLOBAL-DEFINE DBOName BODI135
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName nota-fiscal
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
{esbo/esbodi135.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i} 
{cdp/cdcfgdis.i} 

{upc/btb910za-upc.i} /* v_cod_estab_usuar */

DEFINE VARIABLE v-serie-ini       LIKE nota-fiscal.serie        NO-UNDO.
DEFINE VARIABLE v-serie-fim       LIKE nota-fiscal.serie        NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis-ini LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis-fim LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
DEFINE VARIABLE v-dt-emis-ini     LIKE nota-fiscal.dt-emis-nota NO-UNDO.
DEFINE VARIABLE v-dt-emis-fim     LIKE nota-fiscal.dt-emis-nota NO-UNDO.

DEFINE VARIABLE inr-embarque      LIKE nota-fiscal.cdd-embarq   NO-UNDO.
DEFINE VARIABLE inr-embarqueQ     LIKE nota-fiscal.cdd-embarq   NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 16.29
         WIDTH              = 49.29.
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
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "caixa-postal":U THEN ASSIGN pFieldValue = RowObject.caixa-postal.
        WHEN "cd-vendedor":U THEN ASSIGN pFieldValue = RowObject.cd-vendedor.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cidade-cif":U THEN ASSIGN pFieldValue = RowObject.cidade-cif.
        WHEN "cn-codigo":U THEN ASSIGN pFieldValue = RowObject.cn-codigo.
        WHEN "cod-dep-ext":U THEN ASSIGN pFieldValue = RowObject.cod-dep-ext.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-estab-estoq":U THEN ASSIGN pFieldValue = RowObject.cod-estab-estoq.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "cond-redespa":U THEN ASSIGN pFieldValue = RowObject.cond-redespa.
        WHEN "des-pct-desconto-inform":U THEN ASSIGN pFieldValue = RowObject.des-pct-desconto-inform.
        WHEN "desc-cancela":U THEN ASSIGN pFieldValue = RowObject.desc-cancela.
        WHEN "docto-orig":U THEN ASSIGN pFieldValue = RowObject.docto-orig.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "endereco_text":U THEN ASSIGN pFieldValue = RowObject.endereco_text.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "hr-atualiza":U THEN ASSIGN pFieldValue = RowObject.hr-atualiza.
        WHEN "hr-confirma":U THEN ASSIGN pFieldValue = RowObject.hr-confirma.
        WHEN "hr-entr-cli":U THEN ASSIGN pFieldValue = RowObject.hr-entr-cli.
        WHEN "identific":U THEN ASSIGN pFieldValue = RowObject.identific.
        WHEN "ins-estadual":U THEN ASSIGN pFieldValue = RowObject.ins-estadual.
        WHEN "invoice-id":U THEN ASSIGN pFieldValue = RowObject.invoice-id.
        WHEN "marca-volume":U THEN ASSIGN pFieldValue = RowObject.marca-volume.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nivel-restituicao":U THEN ASSIGN pFieldValue = RowObject.nivel-restituicao.
        WHEN "no-ab-reppri":U THEN ASSIGN pFieldValue = RowObject.no-ab-reppri.
        WHEN "nome-ab-cli":U THEN ASSIGN pFieldValue = RowObject.nome-ab-cli.
        WHEN "nome-ab-reg":U THEN ASSIGN pFieldValue = RowObject.nome-ab-reg.
        WHEN "nome-abrev-tri":U THEN ASSIGN pFieldValue = RowObject.nome-abrev-tri.
        WHEN "nome-tr-red":U THEN ASSIGN pFieldValue = RowObject.nome-tr-red.
        WHEN "nome-transp":U THEN ASSIGN pFieldValue = RowObject.nome-transp.
        WHEN "nr-fat-retro":U THEN ASSIGN pFieldValue = RowObject.nr-fat-retro.
        WHEN "nr-fatura":U THEN ASSIGN pFieldValue = RowObject.nr-fatura.
        WHEN "nr-invoice":U THEN ASSIGN pFieldValue = RowObject.nr-invoice.
        WHEN "nr-nota-ant":U THEN ASSIGN pFieldValue = RowObject.nr-nota-ant.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "nr-siscomex":U THEN ASSIGN pFieldValue = RowObject.nr-siscomex.
        WHEN "nr-tabpre":U THEN ASSIGN pFieldValue = RowObject.nr-tabpre.
        WHEN "nr-volumes":U THEN ASSIGN pFieldValue = RowObject.nr-volumes.
        WHEN "nro-nota-orig":U THEN ASSIGN pFieldValue = RowObject.nro-nota-orig.
        WHEN "num-rma-orig":U THEN ASSIGN pFieldValue = RowObject.num-rma-orig.
        WHEN "obs-gerada":U THEN ASSIGN pFieldValue = RowObject.obs-gerada.
        WHEN "observ-nota":U THEN ASSIGN pFieldValue = RowObject.observ-nota.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "placa":U THEN ASSIGN pFieldValue = RowObject.placa.
        WHEN "refer-cr":U THEN ASSIGN pFieldValue = RowObject.refer-cr.
        WHEN "refer-ct":U THEN ASSIGN pFieldValue = RowObject.refer-ct.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "serie-ant":U THEN ASSIGN pFieldValue = RowObject.serie-ant.
        WHEN "serie-orig":U THEN ASSIGN pFieldValue = RowObject.serie-orig.
        WHEN "tp-pedido":U THEN ASSIGN pFieldValue = RowObject.tp-pedido.
        WHEN "uf-placa":U THEN ASSIGN pFieldValue = RowObject.uf-placa.
        WHEN "user-calc":U THEN ASSIGN pFieldValue = RowObject.user-calc.
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
        WHEN "dt-at-ct":U THEN ASSIGN pFieldValue = RowObject.dt-at-ct.
        WHEN "dt-at-est":U THEN ASSIGN pFieldValue = RowObject.dt-at-est.
        WHEN "dt-at-ofest":U THEN ASSIGN pFieldValue = RowObject.dt-at-ofest.
        WHEN "dt-atual-ap":U THEN ASSIGN pFieldValue = RowObject.dt-atual-ap.
        WHEN "dt-atual-cr":U THEN ASSIGN pFieldValue = RowObject.dt-atual-cr.
        WHEN "dt-cancela":U THEN ASSIGN pFieldValue = RowObject.dt-cancela.
        WHEN "dt-confirma":U THEN ASSIGN pFieldValue = RowObject.dt-confirma.
        WHEN "dt-embarque":U THEN ASSIGN pFieldValue = RowObject.dt-embarque.
        WHEN "dt-emis-nota":U THEN ASSIGN pFieldValue = RowObject.dt-emis-nota.
        WHEN "dt-entr-cli":U THEN ASSIGN pFieldValue = RowObject.dt-entr-cli.
        WHEN "dt-prvenc":U THEN ASSIGN pFieldValue = RowObject.dt-prvenc.
        WHEN "dt-saida":U THEN ASSIGN pFieldValue = RowObject.dt-saida.
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
        WHEN "desc-valor-nota":U THEN ASSIGN pFieldValue = RowObject.desc-valor-nota.
        WHEN "desc-valor-ped":U THEN ASSIGN pFieldValue = RowObject.desc-valor-ped.
        WHEN "descto1":U THEN ASSIGN pFieldValue = RowObject.descto1.
        WHEN "descto2":U THEN ASSIGN pFieldValue = RowObject.descto2.
        WHEN "distancia":U THEN ASSIGN pFieldValue = RowObject.distancia.
        WHEN "nr-praz-med":U THEN ASSIGN pFieldValue = RowObject.nr-praz-med.
        WHEN "pc-restituicao":U THEN ASSIGN pFieldValue = RowObject.pc-restituicao.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "perc-desco1":U THEN ASSIGN pFieldValue = RowObject.perc-desco1.
        WHEN "perc-desco2":U THEN ASSIGN pFieldValue = RowObject.perc-desco2.
        WHEN "perc-tax-div":U THEN ASSIGN pFieldValue = RowObject.perc-tax-div.
        WHEN "perc-tax-emb":U THEN ASSIGN pFieldValue = RowObject.perc-tax-emb.
        WHEN "perc-tax-fre":U THEN ASSIGN pFieldValue = RowObject.perc-tax-fre.
        WHEN "perc-tax-seg":U THEN ASSIGN pFieldValue = RowObject.perc-tax-seg.
        WHEN "peso-bru-tot":U THEN ASSIGN pFieldValue = RowObject.peso-bru-tot.
        WHEN "peso-liq-tot":U THEN ASSIGN pFieldValue = RowObject.peso-liq-tot.
        WHEN "tab-ind-fin":U THEN ASSIGN pFieldValue = RowObject.tab-ind-fin.
        WHEN "tax-desp":U THEN ASSIGN pFieldValue = RowObject.tax-desp.
        WHEN "tax-div-me":U THEN ASSIGN pFieldValue = RowObject.tax-div-me.
        WHEN "tax-emb":U THEN ASSIGN pFieldValue = RowObject.tax-emb.
        WHEN "tax-emb-me":U THEN ASSIGN pFieldValue = RowObject.tax-emb-me.
        WHEN "tax-fre-me":U THEN ASSIGN pFieldValue = RowObject.tax-fre-me.
        WHEN "tax-frete":U THEN ASSIGN pFieldValue = RowObject.tax-frete.
        WHEN "tax-seg":U THEN ASSIGN pFieldValue = RowObject.tax-seg.
        WHEN "tax-seg-me":U THEN ASSIGN pFieldValue = RowObject.tax-seg-me.
        WHEN "taxa-orig":U THEN ASSIGN pFieldValue = RowObject.taxa-orig.
        WHEN "taxa-real":U THEN ASSIGN pFieldValue = RowObject.taxa-real.
        WHEN "val-desc-cofins-zfm":U THEN ASSIGN pFieldValue = RowObject.val-desc-cofins-zfm.
        WHEN "val-desc-pis-zfm":U THEN ASSIGN pFieldValue = RowObject.val-desc-pis-zfm.
        WHEN "val-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-desconto-total.
        WHEN "val-desp-outros":U THEN ASSIGN pFieldValue = RowObject.val-desp-outros.
        WHEN "val-desp-outros-inf":U THEN ASSIGN pFieldValue = RowObject.val-desp-outros-inf.
        WHEN "val-pct-desconto-tab-preco":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-tab-preco.
        WHEN "val-pct-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-total.
        WHEN "val-pct-desconto-valor":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-valor.
        WHEN "vl-acum-dup":U THEN ASSIGN pFieldValue = RowObject.vl-acum-dup.
        WHEN "vl-acum-dup-me":U THEN ASSIGN pFieldValue = RowObject.vl-acum-dup-me.
        WHEN "vl-acumdup-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-acumdup-e[1].
        WHEN "vl-acumdup-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-acumdup-e[2].
        WHEN "vl-acumdup-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-acumdup-e[3].
        WHEN "vl-comis-nota":U THEN ASSIGN pFieldValue = RowObject.vl-comis-nota.
        WHEN "vl-comis-nota-me":U THEN ASSIGN pFieldValue = RowObject.vl-comis-nota-me.
        WHEN "vl-cotacao-fatur":U THEN ASSIGN pFieldValue = RowObject.vl-cotacao-fatur.
        WHEN "vl-cotacao-pedido":U THEN ASSIGN pFieldValue = RowObject.vl-cotacao-pedido.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-desconto-me":U THEN ASSIGN pFieldValue = RowObject.vl-desconto-me.
        WHEN "vl-embalagem":U THEN ASSIGN pFieldValue = RowObject.vl-embalagem.
        WHEN "vl-embalagem-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-embalagem-e[1].
        WHEN "vl-embalagem-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-embalagem-e[2].
        WHEN "vl-embalagem-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-embalagem-e[3].
        WHEN "vl-embalagem-me":U THEN ASSIGN pFieldValue = RowObject.vl-embalagem-me.
        WHEN "vl-fatura":U THEN ASSIGN pFieldValue = RowObject.vl-fatura.
        WHEN "vl-fatura-me":U THEN ASSIGN pFieldValue = RowObject.vl-fatura-me.
        WHEN "vl-frete":U THEN ASSIGN pFieldValue = RowObject.vl-frete.
        WHEN "vl-frete-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-frete-e[1].
        WHEN "vl-frete-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-frete-e[2].
        WHEN "vl-frete-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-frete-e[3].
        WHEN "vl-frete-me":U THEN ASSIGN pFieldValue = RowObject.vl-frete-me.
        WHEN "vl-merc-tot-fat":U THEN ASSIGN pFieldValue = RowObject.vl-merc-tot-fat.
        WHEN "vl-merc-tot-fat-me":U THEN ASSIGN pFieldValue = RowObject.vl-merc-tot-fat-me.
        WHEN "vl-mercad":U THEN ASSIGN pFieldValue = RowObject.vl-mercad.
        WHEN "vl-mercad-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mercad-e[1].
        WHEN "vl-mercad-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mercad-e[2].
        WHEN "vl-mercad-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mercad-e[3].
        WHEN "vl-mercad-me":U THEN ASSIGN pFieldValue = RowObject.vl-mercad-me.
        WHEN "vl-seguro":U THEN ASSIGN pFieldValue = RowObject.vl-seguro.
        WHEN "vl-seguro-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-seguro-e[1].
        WHEN "vl-seguro-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-seguro-e[2].
        WHEN "vl-seguro-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-seguro-e[3].
        WHEN "vl-seguro-me":U THEN ASSIGN pFieldValue = RowObject.vl-seguro-me.
        WHEN "vl-taxa-exp":U THEN ASSIGN pFieldValue = RowObject.vl-taxa-exp.
        WHEN "vl-taxaexp-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-taxaexp-e[1].
        WHEN "vl-taxaexp-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-taxaexp-e[2].
        WHEN "vl-taxaexp-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-taxaexp-e[3].
        WHEN "vl-tot-com":U THEN ASSIGN pFieldValue = RowObject.vl-tot-com.
        WHEN "vl-tot-com-me":U THEN ASSIGN pFieldValue = RowObject.vl-tot-com-me.
        WHEN "vl-tot-ipi":U THEN ASSIGN pFieldValue = RowObject.vl-tot-ipi.
        WHEN "vl-tot-itens-fat":U THEN ASSIGN pFieldValue = RowObject.vl-tot-itens-fat.
        WHEN "vl-tot-itens-fat-me":U THEN ASSIGN pFieldValue = RowObject.vl-tot-itens-fat-me.
        WHEN "vl-tot-iva":U THEN ASSIGN pFieldValue = RowObject.vl-tot-iva.
        WHEN "vl-tot-iva-me":U THEN ASSIGN pFieldValue = RowObject.vl-tot-iva-me.
        WHEN "vl-tot-nota":U THEN ASSIGN pFieldValue = RowObject.vl-tot-nota.
        WHEN "vl-tot-nota-me":U THEN ASSIGN pFieldValue = RowObject.vl-tot-nota-me.
        WHEN "vl-totnota-e[1]":U THEN ASSIGN pFieldValue = RowObject.vl-totnota-e[1].
        WHEN "vl-totnota-e[2]":U THEN ASSIGN pFieldValue = RowObject.vl-totnota-e[2].
        WHEN "vl-totnota-e[3]":U THEN ASSIGN pFieldValue = RowObject.vl-totnota-e[3].
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
        WHEN "cd-sit-desp":U THEN ASSIGN pFieldValue = RowObject.cd-sit-desp.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-des-merc":U THEN ASSIGN pFieldValue = RowObject.cod-des-merc.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-portador":U THEN ASSIGN pFieldValue = RowObject.cod-portador.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-div":U THEN ASSIGN pFieldValue = RowObject.cod-tax-div.
        WHEN "cod-tax-emb":U THEN ASSIGN pFieldValue = RowObject.cod-tax-emb.
        WHEN "cod-tax-fre":U THEN ASSIGN pFieldValue = RowObject.cod-tax-fre.
        WHEN "cod-tax-seg":U THEN ASSIGN pFieldValue = RowObject.cod-tax-seg.
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-sit-nota":U THEN ASSIGN pFieldValue = RowObject.ind-sit-nota.
        WHEN "ind-tip-nota":U THEN ASSIGN pFieldValue = RowObject.ind-tip-nota.
        WHEN "ind-tp-frete":U THEN ASSIGN pFieldValue = RowObject.ind-tp-frete.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "nr-embarque":U THEN ASSIGN pFieldValue = RowObject.nr-embarque.
        WHEN "nr-ind-finan":U THEN ASSIGN pFieldValue = RowObject.nr-ind-finan.
        WHEN "nr-parcelas":U THEN ASSIGN pFieldValue = RowObject.nr-parcelas.
        WHEN "nr-pedido-nf-orig":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-nf-orig.
        WHEN "nr-resumo":U THEN ASSIGN pFieldValue = RowObject.nr-resumo.
        WHEN "nr-tab-finan":U THEN ASSIGN pFieldValue = RowObject.nr-tab-finan.
        WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
        WHEN "tipo-fat":U THEN ASSIGN pFieldValue = RowObject.tipo-fat.
        WHEN "tp-preco":U THEN ASSIGN pFieldValue = RowObject.tp-preco.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-nota
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo serie
               retorna valor do campo nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE nota-fiscal.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pserie = RowObject.serie
           pnr-nota-fis = RowObject.nr-nota-fis.

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
        WHEN "emite-duplic":U THEN ASSIGN pFieldValue = RowObject.emite-duplic.
        WHEN "fat-retro":U THEN ASSIGN pFieldValue = RowObject.fat-retro.
        WHEN "ind-contabil":U THEN ASSIGN pFieldValue = RowObject.ind-contabil.
        WHEN "ind-lib-nota":U THEN ASSIGN pFieldValue = RowObject.ind-lib-nota.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-estorn-comis-repres":U THEN ASSIGN pFieldValue = RowObject.log-estorn-comis-repres.
        WHEN "log-juros-prorate":U THEN ASSIGN pFieldValue = RowObject.log-juros-prorate.
        WHEN "log-possui-retenc":U THEN ASSIGN pFieldValue = RowObject.log-possui-retenc.
        WHEN "log-usa-tabela-desconto":U THEN ASSIGN pFieldValue = RowObject.log-usa-tabela-desconto.
        WHEN "replica-nf":U THEN ASSIGN pFieldValue = RowObject.replica-nf.
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
  Purpose:     Reposiciona registro com base no °ndice ch-nota
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo serie
               recebe valor do campo nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE nota-fiscal.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.

    FIND FIRST bfnota-fiscal WHERE 
        bfnota-fiscal.cod-estabel = pcod-estabel AND 
        bfnota-fiscal.serie = pserie AND 
        bfnota-fiscal.nr-nota-fis = pnr-nota-fis NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnota-fiscal THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnota-fiscal)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToEmb_Quarentena DBOProgram 
PROCEDURE LinkToEmb_Quarentena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param h-boembarque as handle no-undo.
    
    RUN getkey IN h-boembarque (output inr-embarqueQ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToNr-Embarque DBOProgram 
PROCEDURE LinkToNr-Embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param h-boembarque as handle no-undo.
    
    RUN getkey IN h-boembarque (output inr-embarque).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmbQtna_filtro DBOProgram 
PROCEDURE openQueryEmbQtna_filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-embarque
                               WHERE {&TableName}.cod-estabel  = v_cod_estab_usuar 
                               AND   {&TableName}.cdd-embarq   = inr-embarqueQ
                               AND   {&TableName}.dt-cancela   = ?
                               AND   {&TableName}.serie        >= v-serie-ini      
                               AND   {&TableName}.serie        <= v-serie-fim      
                               AND   {&TableName}.nr-nota-fis  >= v-nr-nota-fis-ini
                               AND   {&TableName}.nr-nota-fis  <= v-nr-nota-fis-fim
                               AND   {&TableName}.dt-emis-nota >= v-dt-emis-ini    
                               AND   {&TableName}.dt-emis-nota <= v-dt-emis-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmb_Quarentena DBOProgram 
PROCEDURE openQueryEmb_Quarentena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-embarque
                               WHERE {&TableName}.cod-estabel = v_cod_estab_usuar 
                               AND   {&TableName}.cdd-embarq  = inr-embarqueQ
                               AND   {&TableName}.dt-cancela  = ?.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNr-Embarque DBOProgram 
PROCEDURE openQueryNr-Embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-embarque
                           WHERE {&TableName}.cod-estabel   = v_cod_estab_usuar
                             AND {&TableName}.serie        >= v-serie-ini
                             AND {&TableName}.serie        <= v-serie-fim
                             AND {&TableName}.nr-nota-fis  >= v-nr-nota-fis-ini
                             AND {&TableName}.nr-nota-fis  <= v-nr-nota-fis-fim
                             AND {&TableName}.dt-emis-nota >= v-dt-emis-ini
                             AND {&TableName}.dt-emis-nota <= v-dt-emis-fim
                             AND {&TableName}.cdd-embarq  = inr-embarque
                             AND {&TableName}.dt-saida    = ?
                             AND {&TableName}.dt-cancela  = ?.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmbQtna_filtro DBOProgram 
PROCEDURE setConstraintEmbQtna_filtro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    define input parameter pEmbarque-quarentena LIKE nota-fiscal.cdd-embarq  NO-UNDO.
    define input parameter p-serie-ini          LIKE nota-fiscal.serie       NO-UNDO.
    define input parameter p-serie-fim          LIKE nota-fiscal.serie       NO-UNDO.
    define input parameter p-nr-nota-fis-ini    LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    define input parameter p-nr-nota-fis-fim    LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    define input parameter p-dt-emis-ini        LIKE nota-fiscal.dt-emis     NO-UNDO.
    define input parameter p-dt-emis-fim        LIKE nota-fiscal.dt-emis     NO-UNDO.   

    ASSIGN inr-embarqueQ     = pEmbarque-quarentena
           v-serie-ini       = p-serie-ini
           v-serie-fim       = p-serie-fim
           v-nr-nota-fis-ini = p-nr-nota-fis-ini
           v-nr-nota-fis-fim = p-nr-nota-fis-fim
           v-dt-emis-ini     = p-dt-emis-ini
           v-dt-emis-fim     = p-dt-emis-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmb_Quarentena DBOProgram 
PROCEDURE setConstraintEmb_Quarentena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM pnr-embarque LIKE nota-fiscal.cdd-embarq NO-UNDO.
    
    assign inr-embarqueQ = pnr-embarque.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNr-Embarque DBOProgram 
PROCEDURE setConstraintNr-Embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-serie-ini       LIKE nota-fiscal.serie        NO-UNDO.
DEFINE INPUT PARAMETER p-serie-fim       LIKE nota-fiscal.serie        NO-UNDO.
DEFINE INPUT PARAMETER p-nr-nota-fis-ini LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
DEFINE INPUT PARAMETER p-nr-nota-fis-fim LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
DEFINE INPUT PARAMETER p-dt-emissao-ini  LIKE nota-fiscal.dt-emis-nota NO-UNDO.
DEFINE INPUT PARAMETER p-dt-emissao-fim  LIKE nota-fiscal.dt-emis-nota NO-UNDO.
DEFINE INPUT PARAMETER pnr-embarque      LIKE nota-fiscal.cdd-embarq   NO-UNDO.

ASSIGN v-serie-ini       = p-serie-ini
       v-serie-fim       = p-serie-fim
       v-nr-nota-fis-ini = p-nr-nota-fis-ini
       v-nr-nota-fis-fim = p-nr-nota-fis-fim
       v-dt-emis-ini     = p-dt-emissao-ini
       v-dt-emis-fim     = p-dt-emissao-fim
       inr-embarque      = pnr-embarque.

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
    
    if  pType = "create" then do:
    
    end.
    
    if  pType = "create" or pType = "update" then do:
    
    end.
    
    if  pType = "delete" then do:
    
    end.
        
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

