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
&GLOBAL-DEFINE DBOName esbodi154
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-item
&GLOBAL-DEFINE TableLabel ped-item
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
{esbo/esbodi154.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VAR vnome-abrev LIKE ped-venda.nome-abrev NO-UNDO.
DEFINE VAR vnr-pedcli LIKE ped-venda.nr-pedcli NO-UNDO.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-usu-alt-sit":U THEN ASSIGN pFieldValue = RowObject.cod-usu-alt-sit.
        WHEN "des-pct-desconto-inform":U THEN ASSIGN pFieldValue = RowObject.des-pct-desconto-inform.
        WHEN "desc-cancela":U THEN ASSIGN pFieldValue = RowObject.desc-cancela.
        WHEN "desc-devol":U THEN ASSIGN pFieldValue = RowObject.desc-devol.
        WHEN "desc-lib-preco":U THEN ASSIGN pFieldValue = RowObject.desc-lib-preco.
        WHEN "desc-txt":U THEN ASSIGN pFieldValue = RowObject.desc-txt.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-alt-sit-quota":U THEN ASSIGN pFieldValue = RowObject.motivo-alt-sit-quota.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nr-progcli":U THEN ASSIGN pFieldValue = RowObject.nr-progcli.
        WHEN "nr-tabpre":U THEN ASSIGN pFieldValue = RowObject.nr-tabpre.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "user-alte":U THEN ASSIGN pFieldValue = RowObject.user-alte.
        WHEN "user-aprov-cot":U THEN ASSIGN pFieldValue = RowObject.user-aprov-cot.
        WHEN "user-canc":U THEN ASSIGN pFieldValue = RowObject.user-canc.
        WHEN "user-devol":U THEN ASSIGN pFieldValue = RowObject.user-devol.
        WHEN "user-impl":U THEN ASSIGN pFieldValue = RowObject.user-impl.
        WHEN "user-lib-cot":U THEN ASSIGN pFieldValue = RowObject.user-lib-cot.
        WHEN "user-preco":U THEN ASSIGN pFieldValue = RowObject.user-preco.
        WHEN "user-reat":U THEN ASSIGN pFieldValue = RowObject.user-reat.
        WHEN "user-susp":U THEN ASSIGN pFieldValue = RowObject.user-susp.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-aprov-cot":U THEN ASSIGN pFieldValue = RowObject.dt-aprov-cot.
        WHEN "dt-canseq":U THEN ASSIGN pFieldValue = RowObject.dt-canseq.
        WHEN "dt-devolucao":U THEN ASSIGN pFieldValue = RowObject.dt-devolucao.
        WHEN "dt-entorig":U THEN ASSIGN pFieldValue = RowObject.dt-entorig.
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
        WHEN "dt-lib-cot":U THEN ASSIGN pFieldValue = RowObject.dt-lib-cot.
        WHEN "dt-max-fat":U THEN ASSIGN pFieldValue = RowObject.dt-max-fat.
        WHEN "dt-min-fat":U THEN ASSIGN pFieldValue = RowObject.dt-min-fat.
        WHEN "dt-reativ":U THEN ASSIGN pFieldValue = RowObject.dt-reativ.
        WHEN "dt-suspensao":U THEN ASSIGN pFieldValue = RowObject.dt-suspensao.
        WHEN "dt-useralt":U THEN ASSIGN pFieldValue = RowObject.dt-useralt.
        WHEN "dt-usercan":U THEN ASSIGN pFieldValue = RowObject.dt-usercan.
        WHEN "dt-userdev":U THEN ASSIGN pFieldValue = RowObject.dt-userdev.
        WHEN "dt-userimp":U THEN ASSIGN pFieldValue = RowObject.dt-userimp.
        WHEN "dt-userrea":U THEN ASSIGN pFieldValue = RowObject.dt-userrea.
        WHEN "dt-usersusp":U THEN ASSIGN pFieldValue = RowObject.dt-usersusp.
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
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iva":U THEN ASSIGN pFieldValue = RowObject.aliquota-iva.
        WHEN "aliquota-tax":U THEN ASSIGN pFieldValue = RowObject.aliquota-tax.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "per-des-item":U THEN ASSIGN pFieldValue = RowObject.per-des-item.
        WHEN "per-minfat":U THEN ASSIGN pFieldValue = RowObject.per-minfat.
        WHEN "perc-fornec":U THEN ASSIGN pFieldValue = RowObject.perc-fornec.
        WHEN "qt-alocada":U THEN ASSIGN pFieldValue = RowObject.qt-alocada.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
        WHEN "qt-devolvida":U THEN ASSIGN pFieldValue = RowObject.qt-devolvida.
        WHEN "qt-fatenf":U THEN ASSIGN pFieldValue = RowObject.qt-fatenf.
        WHEN "qt-log-aloca":U THEN ASSIGN pFieldValue = RowObject.qt-log-aloca.
        WHEN "qt-lote-min":U THEN ASSIGN pFieldValue = RowObject.qt-lote-min.
        WHEN "qt-ordens":U THEN ASSIGN pFieldValue = RowObject.qt-ordens.
        WHEN "qt-pedida":U THEN ASSIGN pFieldValue = RowObject.qt-pedida.
        WHEN "qt-pendente":U THEN ASSIGN pFieldValue = RowObject.qt-pendente.
        WHEN "qt-trans-mp":U THEN ASSIGN pFieldValue = RowObject.qt-trans-mp.
        WHEN "qt-transfer":U THEN ASSIGN pFieldValue = RowObject.qt-transfer.
        WHEN "qt-un-fat":U THEN ASSIGN pFieldValue = RowObject.qt-un-fat.
        WHEN "val-desconto[1]":U THEN ASSIGN pFieldValue = RowObject.val-desconto[1].
        WHEN "val-desconto[2]":U THEN ASSIGN pFieldValue = RowObject.val-desconto[2].
        WHEN "val-desconto[3]":U THEN ASSIGN pFieldValue = RowObject.val-desconto[3].
        WHEN "val-desconto[4]":U THEN ASSIGN pFieldValue = RowObject.val-desconto[4].
        WHEN "val-desconto[5]":U THEN ASSIGN pFieldValue = RowObject.val-desconto[5].
        WHEN "val-desconto-bonif":U THEN ASSIGN pFieldValue = RowObject.val-desconto-bonif.
        WHEN "val-desconto-inform":U THEN ASSIGN pFieldValue = RowObject.val-desconto-inform.
        WHEN "val-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-desconto-total.
        WHEN "val-pct-bonif":U THEN ASSIGN pFieldValue = RowObject.val-pct-bonif.
        WHEN "val-pct-desconto-periodo":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-periodo.
        WHEN "val-pct-desconto-prazo":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-prazo.
        WHEN "val-pct-desconto-tab-preco":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-tab-preco.
        WHEN "val-pct-desconto-total":U THEN ASSIGN pFieldValue = RowObject.val-pct-desconto-total.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-liq-abe":U THEN ASSIGN pFieldValue = RowObject.vl-liq-abe.
        WHEN "vl-liq-it":U THEN ASSIGN pFieldValue = RowObject.vl-liq-it.
        WHEN "vl-merc-abe":U THEN ASSIGN pFieldValue = RowObject.vl-merc-abe.
        WHEN "vl-pauta":U THEN ASSIGN pFieldValue = RowObject.vl-pauta.
        WHEN "vl-preori":U THEN ASSIGN pFieldValue = RowObject.vl-preori.
        WHEN "vl-preori-un-fat":U THEN ASSIGN pFieldValue = RowObject.vl-preori-un-fat.
        WHEN "vl-pretab":U THEN ASSIGN pFieldValue = RowObject.vl-pretab.
        WHEN "vl-preuni":U THEN ASSIGN pFieldValue = RowObject.vl-preuni.
        WHEN "vl-tot-it":U THEN ASSIGN pFieldValue = RowObject.vl-tot-it.
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
        WHEN "cd-freq":U THEN ASSIGN pFieldValue = RowObject.cd-freq.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
        WHEN "cod-cond-esp":U THEN ASSIGN pFieldValue = RowObject.cod-cond-esp.
        WHEN "cod-isencao":U THEN ASSIGN pFieldValue = RowObject.cod-isencao.
        WHEN "cod-mot-canc-cot":U THEN ASSIGN pFieldValue = RowObject.cod-mot-canc-cot.
        WHEN "cod-sit-com":U THEN ASSIGN pFieldValue = RowObject.cod-sit-com.
        WHEN "cod-sit-item":U THEN ASSIGN pFieldValue = RowObject.cod-sit-item.
        WHEN "cod-sit-pre":U THEN ASSIGN pFieldValue = RowObject.cod-sit-pre.
        WHEN "cod-sit-preco":U THEN ASSIGN pFieldValue = RowObject.cod-sit-preco.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-vat":U THEN ASSIGN pFieldValue = RowObject.cod-vat.
        WHEN "esp-ped":U THEN ASSIGN pFieldValue = RowObject.esp-ped.
        WHEN "ind-componen":U THEN ASSIGN pFieldValue = RowObject.ind-componen.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-config":U THEN ASSIGN pFieldValue = RowObject.nr-config.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ordem":U THEN ASSIGN pFieldValue = RowObject.nr-ordem.
        WHEN "nr-programa":U THEN ASSIGN pFieldValue = RowObject.nr-programa.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "nr-versao":U THEN ASSIGN pFieldValue = RowObject.nr-versao.
        WHEN "num-sequencia-bonif":U THEN ASSIGN pFieldValue = RowObject.num-sequencia-bonif.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "tipo-atend":U THEN ASSIGN pFieldValue = RowObject.tipo-atend.
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
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
  Purpose:     Retorna valores dos campos do °ndice ch-item-ped
  Parameters:  
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE ped-item.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE ped-item.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE ped-item.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE ped-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE ped-item.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer.

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
        WHEN "aloca-canc-saldo":U THEN ASSIGN pFieldValue = RowObject.aloca-canc-saldo.
        WHEN "config-alter":U THEN ASSIGN pFieldValue = RowObject.config-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "ind-fat-qtfam":U THEN ASSIGN pFieldValue = RowObject.ind-fat-qtfam.
        WHEN "ind-icm-ret":U THEN ASSIGN pFieldValue = RowObject.ind-icm-ret.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-concede-bonif-qtd":U THEN ASSIGN pFieldValue = RowObject.log-concede-bonif-qtd.
        WHEN "log-ordens-emitidas":U THEN ASSIGN pFieldValue = RowObject.log-ordens-emitidas.
        WHEN "log-usa-tabela-desconto":U THEN ASSIGN pFieldValue = RowObject.log-usa-tabela-desconto.
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
  Purpose:     Reposiciona registro com base no °ndice ch-item-ped
  Parameters:  
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE ped-item.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE ped-item.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE ped-item.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE ped-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE ped-item.cod-refer NO-UNDO.

    FIND FIRST bfped-item WHERE 
        bfped-item.nome-abrev = pnome-abrev AND 
        bfped-item.nr-pedcli = pnr-pedcli AND 
        bfped-item.nr-sequencia = pnr-sequencia AND 
        bfped-item.it-codigo = pit-codigo AND 
        bfped-item.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido DBOProgram 
PROCEDURE linkToPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
DEFINE VARIABLE pnome-abrev LIKE ped-venda.nome-abrev NO-UNDO.
DEFINE VARIABLE pnr-pedcli LIKE ped-venda.nr-pedcli NO-UNDO.   

RUN getKey IN pHandle (OUTPUT pnome-abrev,
                       OUTPUT pnr-pedcli).

RUN setConstraintByPedido IN THIS-PROCEDURE (INPUT pnome-abrev,
                                             INPUT pnr-pedcli).
   
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido DBOProgram 
PROCEDURE openQueryByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
      WHERE ped-item.nome-abrev = vnome-abrev
      AND   ped-item.nr-pedcli  = vnr-pedcli
      AND   ped-item.cod-sit-item <= 2
      BY ped-item.it-codigo.

   RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPedido DBOProgram 
PROCEDURE setConstraintByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pnome-abrev LIKE ped-venda.nome-abrev NO-UNDO.
DEFINE INPUT PARAM pnr-pedcli LIKE ped-venda.nr-pedcli NO-UNDO.   

ASSIGN vnome-abrev = pnome-abrev
       vnr-pedcli = pnr-pedcli.

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

