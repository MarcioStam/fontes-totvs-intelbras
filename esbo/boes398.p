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
&GLOBAL-DEFINE DBOName BOES398
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName comissao-fat
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
{esbo/boes398.i RowObject}

DEFINE VARIABLE h-boes396 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boes464 AS HANDLE      NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat .
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "periodo":U THEN ASSIGN pFieldValue = RowObject.periodo.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "unid-neg":U THEN ASSIGN pFieldValue = RowObject.unid-neg.
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
        WHEN "dt-devolucao":U THEN ASSIGN pFieldValue = RowObject.dt-devolucao.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-implant-ped":U THEN ASSIGN pFieldValue = RowObject.dt-implant-ped.
        WHEN "dt-ref-vlp":U THEN ASSIGN pFieldValue = RowObject.dt-ref-vlp.
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
        WHEN "perc-acordo":U THEN ASSIGN pFieldValue = RowObject.perc-acordo.
        WHEN "perc-comissao":U THEN ASSIGN pFieldValue = RowObject.perc-comissao.
        WHEN "vl-a-vista":U THEN ASSIGN pFieldValue = RowObject.vl-a-vista.
        WHEN "vl-comissao":U THEN ASSIGN pFieldValue = RowObject.vl-comissao.
        WHEN "vl-merc-liq":U THEN ASSIGN pFieldValue = RowObject.vl-merc-liq.
        WHEN "vl-presente":U THEN ASSIGN pFieldValue = RowObject.vl-presente.
        WHEN "vl-s-acordo":U THEN ASSIGN pFieldValue = RowObject.vl-s-acordo.
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
        WHEN "cod-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pagto.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-praz-med":U THEN ASSIGN pFieldValue = RowObject.nr-praz-med.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-principal
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rep
               retorna valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE comissao-fat.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rep LIKE comissao-fat.cod-rep NO-UNDO.
    DEFINE OUTPUT PARAMETER pperiodo LIKE comissao-fat.periodo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rep = RowObject.cod-rep
           pperiodo = RowObject.periodo.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice ch-principal
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rep
               recebe valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE comissao-fat.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rep LIKE comissao-fat.cod-rep NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo LIKE comissao-fat.periodo NO-UNDO.

    FIND FIRST bfcomissao-fat WHERE 
        bfcomissao-fat.cod-estabel = pcod-estabel AND 
        bfcomissao-fat.cod-rep = pcod-rep AND 
        bfcomissao-fat.periodo = pperiodo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcomissao-fat THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcomissao-fat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

PROCEDURE comissoes:
    DEF INPUT  PARAMETER p-tipo-movimento AS INTEGER.
    DEF INPUT  PARAMETER p-tipo-processo  AS LOGICAL. /* yes = grava em tabela , no = grava em temp-table */
    DEF INPUT  PARAMETER p-cod-estabel    like nota-fiscal.cod-estabel.      
    DEF INPUT  PARAMETER p-cod-emitente   like nota-fiscal.cod-emitente.     
    DEF INPUT  PARAMETER p-cod-repres     like nota-fiscal.cod-rep.          
    DEF INPUT  PARAMETER p-it-codigo      like it-nota-fisc.it-codigo.   
    DEF INPUT  PARAMETER p-sequencia      LIKE it-nota-fisc.nr-seq-fat.
    DEF INPUT  PARAMETER p-de-qtidade     LIKE it-nota-fisc.qt-faturada[1].
    DEF INPUT  PARAMETER p-dt-emissao-nf  like nota-fiscal.dt-emis-nota.     
    DEF INPUT  PARAMETER p-dt-implant-ped like ped-venda.dt-implant.         
    DEF INPUT  PARAMETER p-dt-devolucao   AS DATE.
    DEF INPUT  PARAMETER p-serie          like nota-fiscal.serie.            
    DEF INPUT  PARAMETER p-nr-docto       like nota-fiscal.nr-nota-fis.    
    DEF INPUT  PARAMETER p-nr-nota-devol  LIKE nota-fiscal.nr-nota-fis.
    DEF INPUT  PARAMETER p-parcela        LIKE comissao-fat.parcela.
    DEF INPUT  PARAMETER p-especie        AS CHARACTER.
    DEF INPUT  PARAMETER p-nr-praz-med    like nota-fiscal.nr-praz-med.      
    DEF INPUT  PARAMETER p-cod-cond-pag   like nota-fiscal.cod-cond-pag.     
    DEF INPUT  PARAMETER p-vl-merc-liq    like it-nota-fisc.vl-merc-liq.     
    DEF OUTPUT PARAMETER p-erro           AS logical.
    DEF INPUT-OUTPUT PARAM TABLE          FOR tt-comissao-fat.

    DEFINE VARIABLE da-dt-emissao           AS DATE        NO-UNDO.
    DEFINE VARIABLE c-periodo               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-perc-comissao        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-perc-acordo          AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-id-faturamento-acordo AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-id-base-calc-acordo   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-id-devolucoes         AS INTEGER NO-UNDO.
    DEFINE VARIABLE c-unid-neg              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE da-data-ref-vlp         AS DATE        NO-UNDO.
    DEFINE VARIABLE de-valor-presente       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-s-acordo       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-a-vista        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-comissao       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-perc-valor-presente   AS DECIMAL     NO-UNDO INITIAL 1.9.
    DEFINE VARIABLE c-nota                  AS CHARACTER   NO-UNDO.


    IF  p-tipo-movimento = 2 THEN DO:
        if month(p-dt-devolucao) = 12 then
           assign da-data-ref-vlp = date("01/01/" + string(year(p-dt-devolucao) + 1 )).
        else
           assign da-data-ref-vlp = date("01/" + string(month(p-dt-devolucao) + 1) + "/" + string(year(p-dt-devolucao))).
    END.
    ELSE DO:
        if month(p-dt-emissao-nf) = 12 then
           assign da-data-ref-vlp = date("01/01/" + string(year(p-dt-emissao-nf) + 1 )).
        else
           assign da-data-ref-vlp = date("01/" + string(month(p-dt-emissao-nf) + 1) + "/" + string(year(p-dt-emissao-nf))).
    END.

    FIND ITEM
         WHERE ITEM.it-codigo = p-it-codigo
         NO-LOCK NO-ERROR.
    
    assign de-perc-comissao = 0.

    IF  p-tipo-movimento = 2 AND
        p-dt-devolucao <> ? THEN DO:
        FIND FIRST comissoes-faixa
             WHERE comissoes-faixa.cod-rep = p-cod-repres
               AND comissoes-faixa.dt-inicial <=  p-dt-devolucao
               AND comissoes-faixa.dt-final   >=  p-dt-devolucao
            NO-LOCK NO-ERROR.
        if NOT AVAIL comissoes-faixa or
            comissoes-faixa.vl-percentual = 0 then return. /* Somente le com a data de devoluá∆o, se n∆o tiver comiss∆o nesta data desconsiderar
                                                se for devoluá∆o mesmo que deva pegar o percentual da nota origem se nao tiver no momento da devoluá∆o n∆o devera considerar */

    END.
    ELSE DO:
         FIND FIRST comissoes-faixa
               WHERE comissoes-faixa.cod-rep     = p-cod-repres
                 AND comissoes-faixa.dt-inicial <=  p-dt-emissao-nf
                 AND comissoes-faixa.dt-final   >=  p-dt-emissao-nf NO-LOCK NO-ERROR.
          IF NOT AVAIL comissoes-faixa 
          OR comissoes-faixa.vl-percentual = 0 
             THEN RETURN.
        
    END.
    ASSIGN de-perc-comissao = comissoes-faixa.vl-percentual.
   

    ASSIGN c-unid-neg = "".
    FIND FIRST it-nota-fisc NO-LOCK
         WHERE it-nota-fisc.cod-estabel = p-cod-estabel
           AND it-nota-fisc.serie       = p-serie
           AND it-nota-fisc.nr-nota-fis = p-nr-docto
           AND it-nota-fisc.nr-seq-fat  = p-sequencia
           AND it-nota-fisc.it-codigo   = p-it-codigo NO-ERROR.
    IF AVAIL it-nota-fisc THEN
        ASSIGN c-unid-neg = it-nota-fisc.cod-unid-negoc.
    ELSE DO:
       IF AVAIL ITEM THEN
          assign c-unid-neg = ITEM.cod-unid-negoc.
    END.
    
    IF NOT VALID-HANDLE(h-boes464) THEN
       RUN esbo/boes464.p PERSISTENT SET h-boes464.

    FIND emitente
         WHERE emitente.cod-emitente = p-cod-emitente
         NO-LOCK NO-ERROR.


    RUN getAcordoComercial IN h-boes464    (INPUT emitente.cgc,
                                            INPUT p-cod-estabel,
                                            INPUT c-unid-neg,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT p-dt-emissao-nf,
                                            OUTPUT i-id-faturamento-acordo,
                                            OUTPUT i-id-base-calc-acordo,  
                                            OUTPUT i-id-devolucoes,
                                            OUTPUT de-perc-acordo) NO-ERROR.

    IF p-nr-praz-med = ? THEN
       ASSIGN p-nr-praz-med = 0.

    assign de-valor-presente = if (p-nr-praz-med - (da-data-ref-vlp - p-dt-emissao-nf)) < 0 then 0 else (p-nr-praz-med - (da-data-ref-vlp - p-dt-emissao-nf))
           de-valor-s-acordo = round(p-vl-merc-liq * (1 - de-perc-acordo / 100),2)
           de-valor-a-vista  = round(de-valor-s-acordo / (exp((1 + d-perc-valor-presente / 100),(de-valor-presente / 30))),2)
           de-valor-comissao = round(de-valor-a-vista * (de-perc-comissao / 100),2).

    IF VALID-HANDLE(h-boes464) THEN
       DELETE PROCEDURE h-boes464.    
   ASSIGN c-nota = iF p-tipo-movimento = 2 THEN p-nr-nota-devol ELSE p-nr-docto.

   IF p-tipo-movimento = 2 THEN
      ASSIGN da-dt-emissao            = p-dt-devolucao
             c-periodo                = string(YEAR(p-dt-devolucao),"9999") + string(MONTH(p-dt-devolucao),"99").
   ELSE
      ASSIGN da-dt-emissao            = p-dt-emissao-nf
             c-periodo                = string(YEAR(p-dt-emissao-nf),"9999") + string(MONTH(p-dt-emissao-nf),"99").


   IF p-tipo-processo = YES THEN DO:
       FIND comissao-fat
            WHERE comissao-fat.cod-estabel       = p-cod-estabel
              AND comissao-fat.especie           = p-especie
              AND comissao-fat.serie             = p-serie
              AND comissao-fat.nr-nota-fis       = c-nota
              AND comissao-fat.parcela           = p-parcela
              AND comissao-fat.id-tipo-inform    = p-tipo-movimento
              AND comissao-fat.cod-rep           = p-cod-repres
              AND comissao-fat.it-codigo         = p-it-codigo
              AND comissao-fat.sequencia         = p-sequencia
              AND comissao-fat.periodo           = c-periodo
              NO-LOCK NO-ERROR.
    
       IF NOT AVAIL comissao-fat THEN DO:
           CREATE comissao-fat.
           ASSIGN comissao-fat.id-tipo-inform              = p-tipo-movimento
                  comissao-fat.cod-estabel                 = p-cod-estabel
                  comissao-fat.serie                       = p-serie
                  comissao-fat.nr-nota-fis                 = iF p-tipo-movimento = 2 THEN p-nr-nota-devol ELSE p-nr-docto 
                  comissao-fat.nr-nota-origem-devol        = iF p-tipo-movimento = 2 THEN p-nr-docto  ELSE ""
                  comissao-fat.cod-emitente                = p-cod-emitente
                  comissao-fat.cod-rep                     = p-cod-repres
                  comissao-fat.cod-cond-pagto              = p-cod-cond-pag
                  comissao-fat.unid-neg                    = c-unid-neg
                  comissao-fat.parcela                     = p-parcela
                  comissao-fat.dt-implant-ped              = p-dt-implant-ped
                  comissao-fat.it-codigo                   = p-it-codigo
                  comissao-fat.sequencia                   = p-sequencia
                  comissao-fat.qt-faturada                 = p-de-qtidade
                  comissao-fat.especie                     = p-especie
                  comissao-fat.dt-devolucao                = p-dt-devolucao
                  comissao-fat.dt-ref-vlp                  = da-data-ref-vlp
                  comissao-fat.nr-praz-med                 = p-nr-praz-med
                  comissao-fat.perc-acordo                 = de-perc-acordo
                  comissao-fat.perc-comissao               = de-perc-comissao
                  comissao-fat.vl-merc-liq                 = p-vl-merc-liq
                  comissao-fat.vl-presente                 = de-valor-presente
                  comissao-fat.vl-s-acordo                 = de-valor-s-acordo
                  comissao-fat.vl-a-vista                  = de-valor-a-vista
                  comissao-fat.vl-comissao                 = de-valor-comissao
                  comissao-fat.dt-emissao                  = da-dt-emissao
                  comissao-fat.periodo                     = c-periodo.
       END.
   END.
   ELSE DO:
       FIND tt-comissao-fat
            WHERE tt-comissao-fat.cod-estabel       = p-cod-estabel
              AND tt-comissao-fat.especie           = p-especie
              AND tt-comissao-fat.serie             = p-serie
              AND tt-comissao-fat.nr-nota-fis       = c-nota
              AND tt-comissao-fat.parcela           = p-parcela
              AND tt-comissao-fat.id-tipo-inform    = p-tipo-movimento
              AND tt-comissao-fat.cod-rep           = p-cod-repres
              AND tt-comissao-fat.it-codigo         = p-it-codigo
              AND tt-comissao-fat.sequencia         = p-sequencia
              AND tt-comissao-fat.periodo           = c-periodo
              NO-LOCK NO-ERROR.

       IF NOT AVAIL tt-comissao-fat THEN DO:
           CREATE tt-comissao-fat.
           ASSIGN tt-comissao-fat.id-tipo-inform              = p-tipo-movimento
                  tt-comissao-fat.cod-estabel                 = p-cod-estabel
                  tt-comissao-fat.serie                       = p-serie
                  tt-comissao-fat.nr-nota-fis                 = iF p-tipo-movimento = 2 THEN p-nr-nota-devol ELSE p-nr-docto 
                  tt-comissao-fat.nr-nota-origem-devol        = iF p-tipo-movimento = 2 THEN p-nr-docto  ELSE ""
                  tt-comissao-fat.cod-emitente                = p-cod-emitente
                  tt-comissao-fat.cod-rep                     = p-cod-repres
                  tt-comissao-fat.cod-cond-pagto              = p-cod-cond-pag
                  tt-comissao-fat.unid-neg                    = c-unid-neg
                  tt-comissao-fat.parcela                     = p-parcela
                  tt-comissao-fat.dt-implant-ped              = p-dt-implant-ped
                  tt-comissao-fat.it-codigo                   = p-it-codigo
                  tt-comissao-fat.sequencia                   = p-sequencia
                  tt-comissao-fat.qt-faturada                 = p-de-qtidade
                  tt-comissao-fat.especie                     = p-especie
                  tt-comissao-fat.dt-devolucao                = p-dt-devolucao
                  tt-comissao-fat.dt-ref-vlp                  = da-data-ref-vlp
                  tt-comissao-fat.nr-praz-med                 = p-nr-praz-med
                  tt-comissao-fat.perc-acordo                 = de-perc-acordo
                  tt-comissao-fat.perc-comissao               = de-perc-comissao
                  tt-comissao-fat.vl-merc-liq                 = p-vl-merc-liq
                  tt-comissao-fat.vl-presente                 = de-valor-presente
                  tt-comissao-fat.vl-s-acordo                 = de-valor-s-acordo
                  tt-comissao-fat.vl-a-vista                  = de-valor-a-vista
                  tt-comissao-fat.vl-comissao                 = de-valor-comissao
                  tt-comissao-fat.dt-emissao                  = da-dt-emissao
                  tt-comissao-fat.periodo                     = c-periodo.
       END.
   END.

   RETURN "OK":U.
   
END PROCEDURE.
