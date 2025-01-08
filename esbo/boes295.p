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
&GLOBAL-DEFINE DBOName BOES295
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName volume-nf
&GLOBAL-DEFINE TableLabel volume-nf
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE NewRecordOffQuery     YES


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
DEFINE TEMP-TABLE RowObject NO-UNDO LIKE volume-nf
    FIELD r-Rowid AS ROWID.

def temp-table tt-embalagem no-undo
    field seq as int
    field sigla-emb like volume-nf.sigla-emb    
    field qt-volumes like nota-embal.qt-volumes 
    index codigo seq.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf1{&TableName} FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-volume-nf    FOR volume-nf.

DEFINE VARIABLE cCod-estabel-ini    LIKE volume-nf.cod-estabel  NO-UNDO.
DEFINE VARIABLE cCod-estabel-end    LIKE volume-nf.cod-estabel  NO-UNDO.
DEFINE VARIABLE cSerie-ini          LIKE volume-nf.serie        NO-UNDO.
DEFINE VARIABLE cSerie-end          LIKE volume-nf.serie        NO-UNDO.
DEFINE VARIABLE cNr-nota-fis-ini    LIKE volume-nf.nr-nota-fis  NO-UNDO.
DEFINE VARIABLE cNr-nota-fis-end    LIKE volume-nf.nr-nota-fis  NO-UNDO.
DEFINE VARIABLE iNr-volume-ini      LIKE volume-nf.nr-volume    NO-UNDO.
DEFINE VARIABLE iNr-volume-end      LIKE volume-nf.nr-volume    NO-UNDO.
DEFINE VARIABLE cIt-codigo-ini      LIKE volume-nf.it-codigo    NO-UNDO.
DEFINE VARIABLE cIt-codigo-end      LIKE volume-nf.it-codigo    NO-UNDO.

DEFINE VARIABLE vQtItemVol      AS   INT                    NO-UNDO.
DEFINE VARIABLE vQtItemVolTotal AS INT NO-UNDO.
DEFINE VARIABLE it-codigo       AS CHARACTER NO-UNDO.


DEFINE VARIABLE i-qt-vol-total      AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-qt-total          AS INTEGER   NO-UNDO.


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
         HEIGHT             = 22.21
         WIDTH              = 58.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     disparado apos a criaá∆o do registro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    RUN atualizaVolumes IN THIS-PROCEDURE (RowObject.cod-estabel,
                                           RowObject.serie,
                                           RowObject.nr-nota-fis,
                                           RowObject.nr-volume).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN atualizaVolumes IN THIS-PROCEDURE (RowObject.cod-estabel,
                                           RowObject.serie,
                                           RowObject.nr-nota-fis,
                                           RowObject.nr-volume).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     Fazer a inicializaá∆o do novo registro a ser criado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN RowObject.cod-estabel    = '101'
           RowObject.serie          = '3'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN atualizaVolumes IN THIS-PROCEDURE (RowObject.cod-estabel,
                                           RowObject.serie,
                                           RowObject.nr-nota-fis,
                                           RowObject.nr-volume).
    RETURN "ok".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaVolumes DBOProgram 
PROCEDURE atualizaVolumes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pCod-estabel    LIKE volume-nf.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie          LIKE volume-nf.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER pNr-nota-fis    LIKE volume-nf.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAMETER pNr-volume      LIKE volume-nf.nr-volume    NO-UNDO.
    
    DEFINE VARIABLE lVariosItens    AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE cIt-codigo      AS CHARACTER               NO-UNDO.
    DEF VAR i-seq                   AS INT                     NO-UNDO.
    DEF VAR i-qt-vol                LIKE nota-embal.qt-volumes NO-UNDO.
    DEF VAR r-nota-embal            AS ROWID                   NO-UNDO.
    DEFINE VARIABLE c-emb-escolhida LIKE embalag.sigla-emb     NO-UNDO.
    
    atu_vol:
    DO TRANSACTION ON ERROR UNDO atu_vol, RETURN 'NOK':

        /* Atualiza numero de volumes da nota fiscal */    
        FOR FIRST nota-fiscal USE-INDEX ch-nota 
            WHERE nota-fiscal.cod-estabel = pCod-estabel
              AND nota-fiscal.serie       = pSerie
              AND nota-fiscal.nr-nota-fis = pNr-nota-fis EXCLUSIVE-LOCK:
        END.
 
        IF AVAILABLE nota-fiscal THEN DO:
            FOR LAST  bf{&TableName}
                WHERE bf{&TableName}.cod-estabel = pCod-estabel
                  AND bf{&TableName}.serie       = pSerie
                  AND bf{&TableName}.nr-nota-fis = pNr-nota-fis NO-LOCK:
            END.
 
            IF AVAILABLE bf{&TableName} THEN
                ASSIGN nota-fiscal.nr-volumes = STRING(bf{&TableName}.nr-volume).
            ELSE
                ASSIGN nota-fiscal.nr-volumes = '0'.
 
            FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

            /** Trecho acrescentado ap¢s a implantaá∆o do TMS para manter a sincronizaá∆o dos 
                dados dos volumes entre o Datasul EMS e TMS
            **/     
 
            /*empty temp-table tt-embalagem.*/
            IF AVAIL bf{&TableName} THEN DO:
                /** Trecho comentado em 04.09.2007 **/
                /*
                for each volume-nf of nota-fiscal no-lock:
                    if volume-nf.sigla-emb = "" then do:
                        find first nota-embal of nota-fiscal no-lock no-error.
                        assign c-emb-escolhida = nota-embal.sigla-emb when avail nota-embal.
                    end.
                    else c-emb-escolhida = volume-nf.sigla-emb.
  
                    find first tt-embalagem 
                        where tt-embalagem.sigla-emb = c-emb-escolhida no-error.
 
                    if not avail tt-embalagem then do:
                        create tt-embalagem.
                        assign i-seq                  = i-seq + 1
                               tt-embalagem.seq       = i-seq
                               tt-embalagem.sigla-emb = c-emb-escolhida.
                    end.
                    assign tt-embalagem.qt-volumes = volume-nf.nr-volume.
                end.
                */
                
                FOR EACH nota-embal OF nota-fiscal EXCLUSIVE-LOCK:
                    DELETE nota-embal.
                END.

                FOR EACH  bf-volume-nf OF nota-fiscal
                    WHERE bf-volume-nf.sigla-emb  = "" EXCLUSIVE-LOCK:
                    ASSIGN bf-volume-nf.sigla-emb = "Cx".
                END.

                FOR EACH bf-volume-nf OF nota-fiscal NO-LOCK
                    BREAK BY bf-volume-nf.sigla-emb
                          BY bf-volume-nf.nr-volume:

                    IF FIRST-OF(bf-volume-nf.sigla-emb) THEN
                        ASSIGN i-qt-vol = 0.
                    IF FIRST-OF(bf-volume-nf.nr-volume) THEN
                        ASSIGN i-qt-vol = i-qt-vol + 1.

                    IF LAST-OF(bf-volume-nf.sigla-emb) THEN DO:
                        CREATE nota-embal.
                        ASSIGN nota-embal.cod-estabel = nota-fiscal.cod-estabel
                               nota-embal.serie       = nota-fiscal.serie
                               nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis
                               nota-embal.sigla-emb   = IF (bf-volume-nf.sigla-emb = "") THEN "Cx"
                                                        ELSE bf-volume-nf.sigla-emb
                               nota-embal.qt-volumes  = i-qt-vol.
                    END.
                END.

                /* TMS FOR FIRST nota-fiscal-tr 
                     WHERE nota-fiscal-tr.cod-estabel = nota-fiscal.cod-estabel
                       AND nota-fiscal-tr.cd-serie    = nota-fiscal.serie
                       AND nota-fiscal-tr.nr-nf       = INT(nota-fiscal.nr-nota-fis) EXCLUSIVE-LOCK:
                END.

                IF AVAIL nota-fiscal-tr THEN DO:
                    FOR EACH nota-fiscal-embal OF nota-fiscal-tr EXCLUSIVE-LOCK:
                        DELETE nota-fiscal-embal.
                    END.

                    FOR EACH nota-embal OF nota-fiscal NO-LOCK:
                        CREATE nota-fiscal-embal.
                        ASSIGN nota-fiscal-embal.cgc-rem     = nota-fiscal-tr.cgc-rem
                               nota-fiscal-embal.nr-nf       = nota-fiscal-tr.nr-nf 
                               nota-fiscal-embal.quantidade  = nota-embal.qt-volumes
                               nota-fiscal-embal.cd-serie    = nota-fiscal-tr.cd-serie
                               nota-fiscal-embal.cod-embal   = nota-embal.sigla-emb.
                    END.

                    ASSIGN nota-fiscal-tr.qt-volumes = bf{&TableName}.nr-volume.
                    RELEASE nota-fiscal-tr.
                END.*/
            END.
            ELSE DO:
                FOR EACH nota-embal OF nota-fiscal EXCLUSIVE-LOCK:
                    DELETE nota-embal.
                END.

                /* TMS FOR FIRST nota-fiscal-tr 
                    WHERE nota-fiscal-tr.cod-estabel = nota-fiscal.cod-estabel
                    AND   nota-fiscal-tr.cd-serie    = nota-fiscal.serie
                    AND   nota-fiscal-tr.nr-nf       = INT(nota-fiscal.nr-nota-fis) EXCLUSIVE-LOCK:
                END.

                IF AVAIL nota-fiscal-tr THEN DO:    
                    FOR EACH nota-fiscal-embal OF nota-fiscal-tr EXCLUSIVE-LOCK:
                        DELETE nota-fiscal-embal.
                    END.

                    ASSIGN nota-fiscal-tr.qt-volumes = 0.
                    RELEASE nota-fiscal-tr.
                END.*/
            END.
        END.

        /* Atualiza flag indigadora de mais de um item para o volume */
        FOR FIRST bf1{&TableName} 
            WHERE bf1{&TableName}.cod-estabel  = pCod-estabel
              AND bf1{&TableName}.serie        = pSerie
              AND bf1{&TableName}.nr-nota-fis  = pNr-nota-fis
              AND bf1{&TableName}.nr-volume    = pNr-volume NO-LOCK:
        END.

        IF AVAILABLE bf1{&TableName} THEN DO:
            ASSIGN cIt-codigo = bf1{&TableName}.it-codigo.

            ASSIGN lVariosItens = CAN-FIND(FIRST bf1{&TableName}
                                        WHERE bf1{&TableName}.cod-estabel  = pCod-estabel
                                          AND bf1{&TableName}.serie        = pSerie
                                          AND bf1{&TableName}.nr-nota-fis  = pNr-nota-fis
                                          AND bf1{&TableName}.nr-volume    = pNr-volume
                                          AND bf1{&TableName}.it-codigo   <> cIt-codigo).

            FOR EACH  bf1{&TableName} EXCLUSIVE-LOCK 
                WHERE bf1{&TableName}.cod-estabel    = pCod-estabel
                  AND bf1{&TableName}.serie          = pSerie
                  AND bf1{&TableName}.nr-nota-fis    = pNr-nota-fis
                  AND bf1{&TableName}.nr-volume      = pNr-volume
                ON ERROR UNDO atu_vol, RETURN 'NOK':

                ASSIGN bf1{&TableName}.varios-itens = lVariosItens.
            END.
        END.
    END.

    RETURN 'OK'.
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
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
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
        WHEN "nr-volume":U THEN ASSIGN pFieldValue = RowObject.nr-volume.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice volume-nf
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo serie
               retorna valor do campo nr-nota-fis
               retorna valor do campo nr-volume
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE volume-nf.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE volume-nf.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-nota-fis LIKE volume-nf.nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-volume LIKE volume-nf.nr-volume NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE volume-nf.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pserie = RowObject.serie
           pnr-nota-fis = RowObject.nr-nota-fis
           pnr-volume = RowObject.nr-volume
           pit-codigo = RowObject.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetLastVolume DBOProgram 
PROCEDURE GetLastVolume :
DEFINE INPUT  PARAM pCod-estabel   LIKE volume-nf.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAM pSerie         LIKE volume-nf.serie        NO-UNDO.
    DEFINE INPUT  PARAM pNr-nota-fis   LIKE volume-nf.nr-nota-fis  NO-UNDO.
    DEFINE OUTPUT PARAM pNrVolume      LIKE volume-nf.nr-volume    NO-UNDO.

    ASSIGN pNrVolume = 0.

    FOR LAST  bf1{&TableName} NO-LOCK
        WHERE bf1{&TableName}.cod-estabel = pcod-estabel
        AND   bf1{&TableName}.nr-nota-fis = pnr-nota-fis
        AND   bf1{&TableName}.serie       = pserie:
        ASSIGN pNrVolume = bf1{&TableName}.nr-volume.
    END.
    
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
        WHEN "varios-itens":U THEN ASSIGN pFieldValue = RowObject.varios-itens.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetQuantItemVol DBOProgram 
PROCEDURE GetQuantItemVol :
DEFINE INPUT  PARAM pCod-estabel   LIKE volume-nf.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAM pNr-nota-fis   LIKE volume-nf.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAM pSerie         LIKE volume-nf.serie        NO-UNDO.
    DEFINE INPUT  PARAM pNr-volume     LIKE volume-nf.nr-volume    NO-UNDO.
    DEFINE OUTPUT PARAM pQtItemVol     AS   INT                    NO-UNDO.
    
    FOR EACH  bf1{&TableName} NO-LOCK
        WHERE bf1{&TableName}.cod-estabel = pcod-estabel
        AND   bf1{&TableName}.nr-nota-fis = pnr-nota-fis
        AND   bf1{&TableName}.serie       = pserie      
        AND   bf1{&TableName}.nr-volume   = pnr-volume:
        ASSIGN pQtItemVol = pQtItemVol + 1.
    END.
    
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
  Purpose:     Reposiciona registro com base no °ndice volume-nf
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo serie
               recebe valor do campo nr-nota-fis
               recebe valor do campo nr-volume
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcod-estabel LIKE volume-nf.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pserie       LIKE volume-nf.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-nota-fis LIKE volume-nf.nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pnr-volume   LIKE volume-nf.nr-volume NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo   LIKE volume-nf.it-codigo NO-UNDO.   
        
    FIND FIRST bfvolume-nf USE-INDEX volume-nf          WHERE 
               bfvolume-nf.cod-estabel = pcod-estabel   AND 
               bfvolume-nf.serie       = pserie         AND 
               bfvolume-nf.nr-nota-fis = pnr-nota-fis   AND 
               bfvolume-nf.nr-volume   = pnr-volume     AND 
               bfvolume-nf.it-codigo   = pit-codigo     NO-LOCK NO-ERROR.
               
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfvolume-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfvolume-nf)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcedimento DBOProgram 
PROCEDURE linkToProcedimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    RUN getkey IN pHandle (OUTPUT cCod-estabel-ini,
                           OUTPUT cSerie-ini,
                           OUTPUT cNr-nota-fis-ini,
                           OUTPUT iNr-volume-ini,
                           OUTPUT cIt-codigo-ini).
/* nao necess†rio pois as proprias variaves que receberiam valor na constraint
   j† estao sendo atribuidas aqui
    RUN setConstraintKey IN THIS-PROCEDURE (INPUT cCod-estabel-ini,
                                            INPUT cSerie-ini,
                                            INPUT cNr-nota-fis-ini,
                                            INPUT iNr-volume-ini,
                                            INPUT cIt-codigo-ini).
*/
    RETURN "OK".
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

    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK
                                WHERE {&tablename}.cod-estabel = cCod-estabel-ini INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryFirst DBOProgram 
PROCEDURE OpenQueryFirst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE 
           {&tablename}.cod-estabel = "101" AND
           {&tablename}.serie = "1"         AND
           {&tablename}.nr-nota-fis = "1"   AND
           {&tablename}.nr-volume = 1       AND
           {&tablename}.it-codigo = "1".


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
     
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeVolume DBOProgram 
PROCEDURE openQueryRangeVolume :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK WHERE
               {&TableName}.Cod-estabel   = cCod-estabel-ini  AND
               {&TableName}.Serie         = cSerie-ini        AND
               {&TableName}.Nr-nota-fis   = cNr-nota-fis-ini  AND
               {&TableName}.Nr-volume    >= iNr-volume-ini    AND
               {&TableName}.Nr-volume    <= iNr-volume-end    AND
               {&TableName}.It-codigo    >= cIt-codigo-ini    AND
               {&TableName}.It-codigo    <= cIt-codigo-end INDEXED-REPOSITION.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVolume DBOProgram 
PROCEDURE openQueryVolume :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.Cod-estabel  = cCod-estabel-ini
          AND {&TableName}.Serie        = cSerie-ini
          AND {&TableName}.Nr-nota-fis  = cNr-nota-fis-ini
          AND {&TableName}.Nr-volume    = iNr-volume-ini
          AND {&TableName}.It-codigo    = cIt-codigo-ini
        /*BY {&TableName}.Cod-estabel
        BY {&TableName}.Serie
        BY {&TableName}.Nr-nota-fis
        BY {&TableName}.Nr-volume
        BY {&TableName}.It-codigo*/ .
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintKey DBOProgram 
PROCEDURE setConstraintKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pCod-estabel LIKE volume-nf.Cod-estabel NO-UNDO.
    DEF INPUT PARAMETER pSerie       LIKE volume-nf.Serie       NO-UNDO.
    DEF INPUT PARAMETER pNr-nota-fis LIKE volume-nf.Nr-nota-fis NO-UNDO.
    DEF INPUT PARAMETER pNr-volume   LIKE volume-nf.Nr-volume   NO-UNDO.
    DEF INPUT PARAMETER pIt-codigo   LIKE volume-nf.It-codigo   NO-UNDO.

    ASSIGN cCod-estabel-ini = pCod-estabel 
           cSerie-ini       = pSerie       
           cNr-nota-fis-ini = pNr-nota-fis 
           iNr-volume-ini   = pNr-volume   
           cIt-codigo-ini   = pIt-codigo.

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
    def input param pCodEstabel as char no-undo.
    
    cCod-estabel-ini = pCodEstabel.
 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeVolume DBOProgram 
PROCEDURE setConstraintRangeVolume :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCod-estabel-ini LIKE volume-nf.Cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pSerie-ini       LIKE volume-nf.Serie       NO-UNDO.
    DEFINE INPUT PARAMETER pNr-nota-fis-ini LIKE volume-nf.Nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pNr-volume-ini   LIKE volume-nf.Nr-volume   NO-UNDO.
    DEFINE INPUT PARAMETER pNr-volume-end   LIKE volume-nf.Nr-volume   NO-UNDO.
    DEFINE INPUT PARAMETER pIt-codigo-ini   LIKE volume-nf.It-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pIt-codigo-end   LIKE volume-nf.It-codigo   NO-UNDO.

    ASSIGN cCod-estabel-ini = pCod-estabel-ini
           cSerie-ini       = pSerie-ini
           cNr-nota-fis-ini = pNr-nota-fis-ini
           iNr-volume-ini   = pNr-volume-ini
           cIt-codigo-ini   = pIt-codigo-ini
           iNr-volume-end   = pNr-volume-end
           cIt-codigo-end   = pIt-codigo-end.


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


    IF pType = "Create" THEN DO:
        IF CAN-FIND(bf{&TableName}
            WHERE bf{&TableName}.Cod-estabel = rowObject.Cod-estabel
              AND bf{&TableName}.Serie       = rowObject.Serie
              AND bf{&TableName}.Nr-nota-fis = rowObject.Nr-nota-fis
              AND bf{&TableName}.Nr-volume   = rowObject.Nr-volume
              AND bf{&TableName}.It-codigo   = rowObject.It-codigo)  THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="Nota Fiscal j† possui volume/item cadastrado"}
        END.
        IF rowObject.sigla-emb = "" THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="ê necess†rio informar a sigla da embalagem"}
        END.
        
        /*for each para contabilizar a quantidade de
        itens e volumes j† gerados.*/
        FOR EACH bf{&TableName}
           where bf{&TableName}.cod-estabel = rowObject.Cod-estabel
             and bf{&TableName}.serie       = rowObject.Serie
             and bf{&TableName}.nr-nota-fis = rowObject.Nr-nota-fis
             and bf{&TableName}.it-codigo   = rowObject.It-codigo no-lock:
          ASSIGN i-qt-vol-total             = i-qt-vol-total + volume-nf.qtde.
        END.
          
        ASSIGN i-qt-total = rowObject.qtde + i-qt-vol-total. /*Quantidade total novo + atual*/ 
          
        /*se a quantidade total(valores informados  + quantidade atual)
        for maior que a quantidade faturada na nota.*/

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = rowObject.it-codigo NO-ERROR.

        IF  AVAIL ITEM
        AND ITEM.cod-unid-negoc <> "ENS" THEN DO:
            
            FIND FIRST it-nota-fisc
                 WHERE it-nota-fisc.cod-estabel = rowObject.cod-estabel
                   AND it-nota-fisc.serie       = rowObject.serie
                   AND it-nota-fisc.nr-nota-fis = rowObject.nr-nota-fis
                   AND it-nota-fisc.it-codigo   = rowObject.it-codigo NO-LOCK NO-ERROR. 
            IF AVAIL it-nota-fisc THEN DO:
                IF i-qt-total > it-nota-fisc.qt-faturada[1] THEN DO:
                    {method/svc/errors/inserr.i
                            &ErrorNumber="17567"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="Volume X Quantidade Ç maior que faturado."}
                END. /*IF i-qt-total > it-nota-fisc.qt-faturada[1] THEN DO:*/
            END.
        END.
    END.
    
    IF pType = "update" THEN DO:
        IF rowObject.sigla-emb = "" THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="ê necess†rio informar a sigla da embalagem"}
        END.
    END.


    IF pType <> "Delete" THEN DO:
        IF NOT CAN-FIND(nota-fiscal
                WHERE nota-fiscal.cod-estabel   = rowObject.cod-estabel
                  AND nota-fiscal.serie         = rowObject.serie
                  AND nota-fiscal.nr-nota-fis   = rowObject.nr-nota-fis) THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="17567"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="Nota Fiscal informada n∆o cadastrada."}
        END.

        IF NOT CAN-FIND(FIRST it-nota-fisc
                WHERE it-nota-fisc.cod-estabel   = rowObject.cod-estabel
                  AND it-nota-fisc.serie         = rowObject.serie
                  AND it-nota-fisc.nr-nota-fis   = rowObject.nr-nota-fis
                  AND it-nota-fisc.it-codigo     = rowObject.it-codigo) THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="17567"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="Item n∆o cadastrado para a nota fiscal informada"}
        END.
        
        ASSIGN vQtItemVol = 0.

        FOR EACH  bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.Cod-estabel = rowObject.Cod-estabel
              AND bf{&TableName}.Serie       = rowObject.Serie      
              AND bf{&TableName}.Nr-nota-fis = rowObject.Nr-nota-fis
              AND bf{&TableName}.Nr-volume   = rowObject.Nr-volume:
            ASSIGN vQtItemVol = vQtItemVol + 1.
        END.

        IF vQtItemVol > 7 THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="17567"
                            &ErrorType="outros"
                            &ErrorSubType="ERROR"
                            &ErrorDescription="Cada volume pode ter no maximo 7 produtos."}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
