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
&GLOBAL-DEFINE DBOName BOES372
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-item
&GLOBAL-DEFINE TableLabel int-item
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes372.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{esp/es0018.i}
{utp/ut-glob.i}
{utp/utapi019.i}
DEFINE VARIABLE c-mail AS CHARACTER   NO-UNDO.


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var it-codigo-ini   like item.it-codigo     no-undo.
def var it-codigo-fim   like item.it-codigo     no-undo.

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
         HEIGHT             = 20.21
         WIDTH              = 42.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

IF NOT CAN-FIND (FIRST estrutura
                 WHERE estrutura.it-codigo = rowobject.it-codigo) THEN DO:

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli = rowobject.nr-ped-energia:
        FOR EACH ped-item OF ped-venda NO-LOCK:
    
            FIND LAST estrutura NO-LOCK
                WHERE estrutura.it-codigo = rowobject.it-codigo NO-ERROR.
            
            IF NOT AVAIL estrutura THEN
                ASSIGN i-seq = 10.
            ELSE
                ASSIGN i-seq = estrutura.sequencia + 10.
            
            CREATE estrutura.
            ASSIGN estrutura.it-codigo    = rowobject.it-codigo
                   estrutura.es-codigo    = ped-item.it-codigo
                   estrutura.qtd-item     = 1
                   estrutura.qtd-compon   = ped-item.qt-pedida
                   estrutura.quant-liquid = ped-item.qt-pedida
                   estrutura.quant-usada  = ped-item.qt-pedida
                   estrutura.data-inicio  = today
                   estrutura.data-termino = 12/31/9999
                   estrutura.observacao   = "Pedido: " + rowobject.nr-ped-energia + " - Seq: " + string(ped-item.nr-sequencia)
                   estrutura.sequencia    = i-seq.
        END.
    END.

    IF rowobject.nr-ped-energia <> "" THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "win111":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN c-mail = "".

        FOR EACH tt-prog-ponto:
            IF c-mail = "" THEN
                ASSIGN c-mail = tt-prog-ponto.conteudo.
            ELSE 
                ASSIGN c-mail = c-mail + ", " + tt-prog-ponto.conteudo.
        END.

        IF c-mail <> "" THEN DO:

            FOR FIRST param-global NO-LOCK:
            END.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
            
            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
      
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = c-mail                   /* Destinatˇrio       */ 
                   tt-envio2.remetente         = usuar_mestre.cod_e_mail_local  /* Remetente          */ 
                   tt-envio2.assunto           = "Gerador Fotovoltaico - Pedido " + int-item.nr-ped-energia /* Assunto */
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Prezado Colaborador(a)," + CHR(13) + CHR(13) + 
                                              "Foi cadastrado um novo Gerador Fotovoltaico, com o c¢digo " + int-item.it-codigo + "." + CHR(13) + 
                                              "Favor gerar o FCI para o item, para que o sistema conclua o processo de venda deste produto." + CHR(13) + CHR(13) + 
                                              "Atenciosamente," + CHR(13) +
                                              "Energia Solar.".

            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
           
            FIND FIRST tt-erros NO-LOCK NO-ERROR.

/*             IF AVAIL tt-erros THEN DO:       */
/*                 PUT tt-erros.desc-erro SKIP. */
/*             END.                             */
            
            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
        WHEN "ex-tarifario":U THEN ASSIGN pFieldValue = RowObject.ex-tarifario.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nve":U THEN ASSIGN pFieldValue = RowObject.nve.
        WHEN "seq-suframa":U THEN ASSIGN pFieldValue = RowObject.seq-suframa.
        WHEN "char1":U THEN ASSIGN pFieldValue = RowObject.char1.
        WHEN "char2":U THEN ASSIGN pFieldValue = RowObject.char2.
        WHEN "cod-cor":U THEN ASSIGN pFieldValue = RowObject.cod-cor.
        WHEN "cod-tipo-mp":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-mp.
        WHEN "cod-modelo-placa":U THEN ASSIGN pFieldValue = RowObject.cod-modelo-placa.
        WHEN "cod-tam-placa":U THEN ASSIGN pFieldValue = RowObject.cod-tam-placa.
        WHEN "cod-potencia":U THEN ASSIGN pFieldValue = RowObject.cod-potencia.
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
        WHEN "dt-venc-homologacao":U THEN ASSIGN pFieldValue = RowObject.dt-venc-homologacao.
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
        WHEN "qtd-pol":U THEN ASSIGN pFieldValue = RowObject.qtd-pol.
        WHEN "dec1":U THEN ASSIGN pFieldValue = RowObject.dec1.
        WHEN "dec2":U THEN ASSIGN pFieldValue = RowObject.dec2.
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
        WHEN "ind-tipo-venda":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-venda.
        WHEN "int1":U THEN ASSIGN pFieldValue = RowObject.int1.
        WHEN "int2":U THEN ASSIGN pFieldValue = RowObject.int2.
        /*WHEN "ind-tipo-venda":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-venda.*/
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
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE int-item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

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
        WHEN "log-beneficiado":U THEN ASSIGN pFieldValue = RowObject.log-beneficiado.
        WHEN "log-importado":U THEN ASSIGN pFieldValue = RowObject.log-importado.
        WHEN "corporativo":U THEN ASSIGN pFieldValue = RowObject.corporativo.
        WHEN "log1":U THEN ASSIGN pFieldValue = RowObject.log1.
        WHEN "log2":U THEN ASSIGN pFieldValue = RowObject.log2.
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
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE int-item.it-codigo NO-UNDO.

    FIND FIRST bfint-item WHERE 
        bfint-item.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeItem DBOProgram 
PROCEDURE openQueryRangeItem :
OPEN QUERY qr{&TableName} FOR EACH {&TableName}
                             WHERE {&TableName}.it-codigo >= it-codigo-ini
                             AND   {&TableName}.it-codigo <= it-codigo-fim NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeItem DBOProgram 
PROCEDURE setConstraintRangeItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo-ini     LIKE item.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo-fim     LIKE item.it-codigo   NO-UNDO.


    ASSIGN it-codigo-ini = pit-codigo-ini
           it-codigo-fim = pit-codigo-fim.
           
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

    DEFINE VARIABLE l-retorno AS LOGICAL     NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "Create" OR pType = "Update" THEN DO:

        IF RowObject.destaque <> 999 THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = RowObject.it-codigo NO-ERROR.
            IF AVAIL ITEM THEN DO:
                RUN esbo/boes372a.p(INPUT ITEM.class-fiscal, INPUT RowObject.destaque, OUTPUT l-retorno).
                IF NOT l-retorno THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="'Destaque n∆o cadastrado para essa NCM.~~~~Destaque n∆o cadastrado para essa NCM.'"}
                END.
            END.
        END.

        IF RowObject.nr-ped-energia <> "" THEN DO:
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli = RowObject.nr-ped-energia NO-ERROR.

            IF NOT AVAIL ped-venda THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Pedido informado n∆o est† cadastrado!'"}

            END.
            ELSE IF ped-venda.cod-sit-ped <> 1 AND ped-venda.cod-sit-ped <> 5 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Pedido informado n∆o est† com status de Aberto!'"}
            END.
        END.
        
        IF RowObject.log-gatt THEN DO:
            IF RowObject.perc-gatt <= 0 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Percentual GATT Ç obrigat¢rio quando marcado campo GATT.~~~~Percentual GATT Ç obrigat¢rio quando marcado campo GATT.'"}
            END.
            ELSE IF RowObject.perc-gatt > 100 THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Percentual GATT n∆o pode ultrapassar 100.~~~~Percentual GATT n∆o pode ultrapassar 100.'"}
            END.
        END.    
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

