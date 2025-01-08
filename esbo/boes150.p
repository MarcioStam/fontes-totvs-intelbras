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
&GLOBAL-DEFINE DBOName BOES150
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-fiscal
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qrped-fiscal

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes150.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bfped-fiscal FOR ped-fiscal.

{utp/ut-glob.i}
{upc/btb910za-upc.i}
{cdp/cd0666.i}
/*fnEstoque*/
{esp/pdp/espdp006fn.i}
DEFINE VARIABLE cCod_usuario    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE iNr-pedido-ini      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNr-pedido-end      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCod-emitente-ini   AS INTEGER      NO-UNDO.
DEFINE VARIABLE iCod-emitente-end   AS INTEGER      NO-UNDO.

DEF NEW GLOBAL SHARED VARIABLE  p-tipo             AS CHAR NO-UNDO.
DEF VAR c-cod-estabel      AS CHAR NO-UNDO.
DEF VAR c-cod-depos        AS CHAR NO-UNDO.
DEF VAR i-pedido           LIKE ped-fiscal.nr-pedido.
DEF VAR l-resposta         AS LOG.
DEF VAR c-mensagem         AS CHAR NO-UNDO.
DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
DEF BUFFER b-it-ped-fiscal FOR it-ped-fiscal.

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
         HEIGHT             = 17.63
         WIDTH              = 38.72.
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
FIND FIRST param-global NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
IF p-tipo = "Copy" THEN DO:
    ASSIGN p-tipo = "".

    FIND LAST ped-fiscal NO-ERROR.
    IF  i-pedido < ped-fiscal.nr-pedido THEN DO:
        MESSAGE "Deseja copiar os itens do pedido?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-resposta.

        IF  l-resposta THEN DO:
            ASSIGN c-mensagem = "".
            FOR EACH  it-ped-fiscal NO-LOCK
                WHERE it-ped-fiscal.nr-pedido = i-pedido:


                /* Se foi informado dep¢sito em tela, aloca no dep¢sito informado */
                IF  SUBSTRING(ped-fiscal.char-1,7,3) <> "" THEN
                    ASSIGN c-cod-depos = SUBSTRING(ped-fiscal.char-1,7,3).
                ELSE
                    ASSIGN c-cod-depos = it-ped-fiscal.cod-depos.

                FIND item NO-LOCK 
                    WHERE item.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.
                
                IF AVAIL ITEM THEN DO:
                   IF ITEM.baixa-estoq THEN DO:
                       IF  AVAIL item AND item.tipo-contr <> 4 THEN DO:
                            /*Alocaá∆o por lote*/
                           IF item.tipo-con-est = 3 THEN DO:
                               RUN esp/ftp/esftp012f.p (INPUT YES,                          /*p-log-aloca  */
                                                        INPUT ped-fiscal.nr-pedido,         /*p-nr-pedido  */
                                                        INPUT it-ped-fiscal.it-codigo,      /*p-it-codigo  */
                                                        INPUT it-ped-fiscal.seq,            /*p-seq        */
                                                        INPUT c-cod-estabel,                /*p-cod-estabel*/
                                                        INPUT it-ped-fiscal.cod-localizacao,/*p-cod-localiz*/
                                                        INPUT c-cod-depos,                  /*p-cod-depos  */
                                                        INPUT it-ped-fiscal.qtde,           /*p-qtde-alocar*/
                                                        OUTPUT TABLE tt-erro-aloc).         

                               FIND FIRST tt-erro-aloc NO-ERROR.

                               IF AVAIL tt-erro-aloc THEN DO:
                                   ASSIGN c-mensagem = c-mensagem + tt-erro-aloc.mensagem + CHR(13).
                               END.
                               ELSE DO:
                                   CREATE b-it-ped-fiscal.
                                   ASSIGN b-it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                                          b-it-ped-fiscal.cod-depos = c-cod-depos.
                                   BUFFER-COPY it-ped-fiscal EXCEPT nr-pedido cod-depos TO b-it-ped-fiscal.
                                   ASSIGN b-it-ped-fiscal.aliquota-ipi = ITEM.aliquota-ipi
                                          overlay(b-it-ped-fiscal.char-1,11,8) = ITEM.class-fiscal. 
                               END.
                           END.
                           /*Alocaá∆o sem lote*/
                           ELSE DO:
                              FIND FIRST saldo-estoq EXCLUSIVE-LOCK
                                  WHERE  saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                                  AND    saldo-estoq.cod-estabel = c-cod-estabel
                                  AND    saldo-estoq.cod-depos   = c-cod-depos
                                  AND    saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao NO-ERROR.
                              
                              IF NOT  AVAIL  saldo-estoq or
                                 fnEstoque(c-cod-estabel, it-ped-fiscal.it-codigo, c-cod-depos, it-ped-fiscal.cod-localizacao, NO) < it-ped-fiscal.qtde THEN DO:
                                 ASSIGN c-mensagem = c-mensagem + it-ped-fiscal.it-codigo + CHR(13).
                              END.
                              ELSE DO:
                                  ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + it-ped-fiscal.qtde.

                                  RELEASE saldo-estoq.
                              
                                  CREATE b-it-ped-fiscal.
                                  ASSIGN b-it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                                         b-it-ped-fiscal.cod-depos = c-cod-depos.
                                  BUFFER-COPY it-ped-fiscal EXCEPT nr-pedido cod-depos TO b-it-ped-fiscal.
                                  ASSIGN b-it-ped-fiscal.aliquota-ipi = ITEM.aliquota-ipi
                                         overlay(b-it-ped-fiscal.char-1,11,8) = ITEM.class-fiscal.
                              END.
                           END.
                        END.
                        ELSE DO:
                           CREATE b-it-ped-fiscal.
                           ASSIGN b-it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                                  b-it-ped-fiscal.cod-depos = c-cod-depos.
                           BUFFER-COPY it-ped-fiscal EXCEPT nr-pedido cod-depos TO b-it-ped-fiscal.
                        END.
                   END.
                   ELSE DO:
                       CREATE b-it-ped-fiscal.
                       ASSIGN b-it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                              b-it-ped-fiscal.cod-depos = c-cod-depos.
                       BUFFER-COPY it-ped-fiscal EXCEPT nr-pedido cod-depos TO b-it-ped-fiscal.
                   END.
                END.
            END.

            IF  c-mensagem <> "" THEN DO:
                ASSIGN c-mensagem = "Saldo de Estoque n∆o foi localizado para os itens: " + CHR(13) + c-mensagem.

                MESSAGE c-mensagem
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST bfPed-fiscal NO-LOCK NO-ERROR.
    IF AVAILABLE bfPed-fiscal THEN
        ASSIGN RowObject.nr-pedido = bfPed-fiscal.nr-pedido + 1.
    ELSE
        ASSIGN RowObject.nr-pedido = 1.


    ASSIGN RowObject.usuario-magnus = v_cod_usuar_corren
           RowObject.dt-emissao     = TODAY.

    FIND FIRST usuar_univ NO-LOCK
         WHERE usuar_univ.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAIL usuar_univ AND usuar_univ.cod_estab = "" THEN
       FIND FIRST usuar_univ NO-LOCK
            WHERE usuar_univ.cod_usuario = v_cod_usuar_corren 
              AND usuar_univ.cod_estab  <> "" NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.

    IF AVAILABLE usuar_univ 
    THEN DO:
        IF trim(usuar_univ.cod_ccusto) <> "" 
        THEN DO:
            run prgint\utb\utb742za.py persistent set h_api_ccusto.
                
            EMPTY TEMP-TABLE tt_log_erro.
            run pi_busca_dados_ccusto in h_api_ccusto 
                                             (input  i-ep-codigo-usuario,   /* EMPRESA EMS2 */
                                              input  "",                    /* CODIGO DO PLANO CCUSTO */
                                              input  usuar_univ.cod_ccusto, /* CCUSTO */
                                              input  today,                 /* DATA DE TRANSACAO */
                                              output v_des_titulo_ccusto,   /* DESCRICAO DO CCUSTO */
                                              output table tt_log_erro).    /* ERROS */
            delete object h_api_ccusto.
            IF v_des_titulo_ccusto <> "" 
            THEN
                ASSIGN v_des_titulo_ccusto = " - CC: " + v_des_titulo_ccusto + "  ".
            ELSE
                ASSIGN v_des_titulo_ccusto = "".
            ASSIGN RowObject.observacao[1] = 'Usu†rio solicitante: ' + usuar_mestre.nom_usuario +
                                             v_des_titulo_ccusto.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iLastPedido AS INTEGER      NO-UNDO.

    IF CAN-FIND(bfPed-fiscal NO-LOCK WHERE bfPed-fiscal.nr-pedido = RowObject.nr-pedido) THEN DO:

        ASSIGN i-pedido      = RowObject.nr-pedido
               c-cod-estabel = RowObject.cod-estabel.

        FIND LAST bfPed-fiscal NO-LOCK NO-ERROR.
        IF AVAILABLE bfPed-fiscal THEN
            ASSIGN iLastPedido = bfPed-fiscal.nr-pedido + 1.
        ELSE
            ASSIGN iLastPedido = 1.

        IF NOT SESSION:BATCH-MODE THEN
            MESSAGE 'O Pedido ser† criado com o n£mero' iLastPedido
                    ' pois j† existe um pedido com o n£mero' RowObject.nr-pedido
                VIEW-AS ALERT-BOX INFORMATION TITLE 'Novo n£mero do Pedido'.

        ASSIGN RowObject.nr-pedido = iLastPedido
               RowObject.situacao  = 0. /* Digitado */
/*            p-tipo              = "Copy". */


    END.

    ASSIGN RowObject.canal-vendas   = 12.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DELETE_child:
    DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
        FOR EACH it-ped-fiscal EXCLUSIVE-LOCK
                WHERE it-ped-fiscal.nr-pedido = RowObject.nr-pedido
            ON ERROR UNDO DELETE_child, RETURN 'NOK':

            DELETE it-ped-fiscal.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "notas":U THEN ASSIGN pFieldValue = RowObject.notas.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "observacao[1]":U THEN ASSIGN pFieldValue = RowObject.observacao[1].
        WHEN "observacao[2]":U THEN ASSIGN pFieldValue = RowObject.observacao[2].
        WHEN "observacao[3]":U THEN ASSIGN pFieldValue = RowObject.observacao[3].
        WHEN "observacao[4]":U THEN ASSIGN pFieldValue = RowObject.observacao[4].
        WHEN "observacao[5]":U THEN ASSIGN pFieldValue = RowObject.observacao[5].
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "usuario-magnus":U THEN ASSIGN pFieldValue = RowObject.usuario-magnus.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = STRING(RowObject.ct-codigo). 
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = STRING(RowObject.sc-codigo).
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
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "nat-oper":U THEN ASSIGN pFieldValue = RowObject.nat-oper.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "nr-volumes":U THEN ASSIGN pFieldValue = RowObject.nr-volumes.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "seq-wt-docto":U THEN ASSIGN pFieldValue = RowObject.seq-wt-docto.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ped-fiscal
  Parameters:  
               retorna valor do campo nr-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-pedido LIKE ped-fiscal.nr-pedido NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-pedido = RowObject.nr-pedido.

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
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
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
  Purpose:     Reposiciona registro com base no °ndice ped-fiscal
  Parameters:  
               recebe valor do campo nr-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-pedido LIKE ped-fiscal.nr-pedido NO-UNDO.

    FIND FIRST bfped-fiscal WHERE 
        bfped-fiscal.nr-pedido = pnr-pedido NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-fiscal THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-fiscal)).
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

    OPEN QUERY qrped-fiscal FOR EACH ped-fiscal NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeEmitente DBOProgram 
PROCEDURE openQueryRangeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----
--------------------------------------------------------------------------*/
    
    DEFINE VARIABLE l-sim AS LOGICAL     NO-UNDO.
    FOR FIRST ponto-programa NO-LOCK
                where ponto-programa.nome-programa = 'esftp012'
                  AND ponto-programa.ponto = 3,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = cCod_usuario:
        ASSIGN l-sim = YES.
    END.
       
    
    IF l-sim THEN
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK
                WHERE  ped-fiscal.cod-emitente >= icod-emitente-ini
                  AND  ped-fiscal.cod-emitente <= icod-emitente-end.
    
    ELSE
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK
                WHERE  ped-fiscal.usuario-magnus = cCod_usuario
                  AND  ped-fiscal.cod-emitente >= icod-emitente-ini
                  AND  ped-fiscal.cod-emitente <= icod-emitente-end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePedido DBOProgram 
PROCEDURE openQueryRangePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-sim AS LOGICAL     NO-UNDO.
    
    FOR FIRST ponto-programa NO-LOCK
                where ponto-programa.nome-programa = 'esftp012'
                  AND ponto-programa.ponto = 3,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = cCod_usuario:
        ASSIGN l-sim = YES.
    END.
    
    IF l-sim THEN
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK
                WHERE  ped-fiscal.nr-pedido >= iNr-pedido-ini
                  AND  ped-fiscal.nr-pedido <= iNr-pedido-end.
    ELSE
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK
                WHERE  ped-fiscal.usuario-magnus = cCod_usuario
                  AND  ped-fiscal.nr-pedido >= iNr-pedido-ini
                  AND  ped-fiscal.nr-pedido <= iNr-pedido-end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryUsuario DBOProgram 
PROCEDURE openQueryUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-sim AS LOGICAL     NO-UNDO.
    
    FOR FIRST ponto-programa NO-LOCK
                where ponto-programa.nome-programa = 'esftp012'
                  AND ponto-programa.ponto = 3,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = cCod_usuario:
        ASSIGN l-sim = YES.
    END.
    
    IF l-sim THEN
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK.
    ELSE
        OPEN QUERY qrped-fiscal
            FOR EACH  ped-fiscal NO-LOCK
                WHERE  ped-fiscal.usuario-magnus = cCod_usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeEmitente DBOProgram 
PROCEDURE setConstraintRangeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER piCod-emitente-ini AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER piCod-emitente-end AS INTEGER      NO-UNDO.

    ASSIGN iCod-emitente-ini = piCod-emitente-ini
           iCod-emitente-end = piCod-emitente-end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePedido DBOProgram 
PROCEDURE setConstraintRangePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER piNr-pedido-ini AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER piNr-pedido-end AS INTEGER      NO-UNDO.

    ASSIGN iNr-pedido-ini = piNr-pedido-ini
           iNr-pedido-end = piNr-pedido-end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintUsuario DBOProgram 
PROCEDURE setConstraintUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pCod_usuario    AS CHARACTER    NO-UNDO.

    ASSIGN cCod_usuario = pCod_usuario.

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

    DEFINE INPUT PARAMETER pType    AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE c-msg-erro      AS CHARACTER   NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
/*
    IF pType = 'Create' THEN DO:
        IF CAN-FIND(ped-fiscal WHERE ped-fiscal.nr-pedido = RowObject.nr-pedido) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="1"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorParameters="'Pedido'"}
        END.
    END.
*/


    IF pType <> 'Delete' THEN DO:

      /*  IF RowObject.situacao <> 0 THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="17006"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorDescription="Pedido j† atendido e n∆o pode ser modificado."}
            RETURN 'NOK'.
        END.
        */
        IF NOT CAN-FIND(emitente WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorParameters="'Cliente'"}
        END.

        IF NOT CAN-FIND(transporte WHERE transporte.cod-transp = RowObject.cod-transp) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorParameters="'Transportadora'"}
        END.
/*         IF NOT CAN-FIND(canal-venda WHERE canal-venda.cod-canal-venda = RowObject.canal-vendas) THEN DO: */
/*             {method/svc/errors/inserr.i                                                                  */
/*                          &ErrorNumber="2"                                                                */
/*                          &ErrorType="Outros" &ErrorSubType="ERROR"                                       */
/*                          &ErrorParameters="'Canal de Vendas'"}                                           */
/*         END.                                                                                             */
        IF RowObject.nr-volumes <= 0 THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="17006"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorDescription="N£mero de volumes deve ser maior que 0 (Zero)."
                         &ErrorHelp="N£mero de volumes deve ser maior que 0 (Zero)."}
        END.

        IF NOT CAN-FIND(estabelec WHERE estabelec.cod-estabel = rowobject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="17006"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorDescription="Estabelecimento N∆o Encontrado"
                         &ErrorHelp="Informe um Estabelecimento Existente"}
        END.


        IF  rowobject.sc-codigo <> ""
        THEN DO:
            FIND FIRST cc_uni_estab NO-LOCK 
                WHERE  cc_uni_estab.cod_ccusto = rowobject.sc-codigo
                  AND  cc_uni_estab.cod_estab  = rowobject.cod-estabel NO-ERROR.

            IF  NOT AVAIL cc_uni_estab 
            THEN DO:
                ASSIGN c-msg-erro = "Unidade de Neg¢cio n∆o Relacionada~~" + "Verifique no cadasto do centro de custo "                                     + 
                                    rowobject.sc-codigo                    + " se o mesmo est† relacionado a alguma unidade de neg¢cio no estabelecimento " + 
                                    rowobject.cod-estabel                  + ". Entre em contato com o grupo cont†bil para revis∆o de cadastro.".

                {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="Outros" 
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-msg-erro}
            END. /* if  avail cc_uni_estab THEN DO: */
        END.


        IF NOT CAN-FIND(FIRST emscad.ccusto WHERE emscad.ccusto.cod_ccusto = RowObject.sc-codigo) THEN DO:
           {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="Outros" &ErrorSubType="ERROR"
                        &ErrorParameters="'Centro Custo'"}
        END.

        /**/

        RUN prgint/utb/utb742za.py persistent set h_api_ccusto.
    
        EMPTY TEMP-TABLE tt_log_erro.
        
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                                   input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                   input  RowObject.sc-codigo,      /* CCUSTO */
                                                   input TODAY,                     /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto,      /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).       /* ERROS */
    
        IF VALID-HANDLE(h_api_ccusto) THEN
            DELETE OBJECT h_api_ccusto.
    
        IF CAN-FIND(FIRST tt_log_erro) THEN DO:

            FOR EACH tt_log_erro:

                {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="Outros" 
                        &ErrorSubType="ERROR"
                        &ErrorParameters=tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda}


            END.
            
        END.




        /*
        IF RowObject.nat-oper = 1 OR RowObject.nat-oper = 5 OR
           RowObject.nat-oper = 6 OR RowObject.nat-oper = 7 OR
           RowObject.nat-oper = 8 OR RowObject.nat-oper = 9 OR
           RowObject.nat-oper = 16 THEN DO:

            IF NOT CAN-FIND(conta-contab WHERE
               conta-contab.ep-codigo = i-ep-codigo-usuario AND
               conta-contab.ct-codigo = STRING(RowObject.ct-codigo) AND
               conta-contab.sc-codigo = STRING(RowObject.sc-codigo)) THEN DO:
               MESSAGE 'Conta Cont†bil n∆o encontrada. No entanto, ser† permitida a atribuiá∆o atÇ que a base de dados seja alterada. Apenas verifique se a conta e subconta est∆o corretas.'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                /*
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorParameters="'Conta Cont†bil'"}
                */
            END.
        END.
        */
        



    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

