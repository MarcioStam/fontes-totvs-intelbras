/******************************************************************************************
******* Programa: item-wms                                                          *******
******* Objetivo: Integrar item , embalagem e codigo de barras com protheus x totvs *******
******* Autor   : SCM Concept / Visus                                               *******
******* Data    : 17/10/2022                                                        *******
******************************************************************************************/

{method/dbotterr.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-erro  NO-UNDO
   FIELD codigo     AS INT
   FIELD informacao AS CHAR
   FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEFINE INPUT PARAM cCodEstabel            AS CHAR FORMAT "x(03)" NO-UNDO.
DEFINE INPUT PARAM cCodLocal              AS CHAR FORMAT "x(03)" NO-UNDO.
DEFINE INPUT PARAM codigoProduto          AS CHAR FORMAT "x(16)" NO-UNDO.
DEFINE INPUT PARAM descricaoProduto       AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE INPUT PARAM unidadeDeMedida        AS CHAR FORMAT "x(05)" NO-UNDO.
DEFINE INPUT PARAM codigoBarras           AS CHAR FORMAT "x(20)" NO-UNDO.
//DEFINE INPUT PARAM familia                AS CHAR FORMAT "x(20)" NO-UNDO.
DEFINE INPUT PARAM ativaControleDeLote    AS CHAR FORMAT "x(01)" NO-UNDO.
DEFINE INPUT PARAM lastro                 AS CHAR FORMAT "x(01)" NO-UNDO.
DEFINE INPUT PARAM EmbalagemUnidade       AS DEC                 NO-UNDO.
DEFINE INPUT PARAM EmbalagemQuantidade    AS DEC                 NO-UNDO.
DEFINE INPUT PARAM EmbalagemCodigoBarras  AS CHAR                NO-UNDO.
DEFINE INPUT PARAM EmbalagemVolume        AS CHAR                NO-UNDO.
DEFINE INPUT PARAM EmbalagemUnidadeVolume AS CHAR                NO-UNDO.
DEFINE INPUT PARAM EmbalagemAltura        AS DEC                 NO-UNDO.
DEFINE INPUT PARAM EmbalagemLargura       AS DEC                 NO-UNDO.
DEFINE INPUT PARAM EmbalagemComprimento   AS DEC                 NO-UNDO.
DEFINE INPUT PARAM EmbalagemPesoBruto     AS DEC                 NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-wm-local NO-UNDO
    FIELD cod-local AS CHAR
    FIELD cod-estabel AS CHAR.

DEF BUFFER bfwm-embalagem FOR wm-embalagem.
DEF BUFFER bfwm-item-embalagem-local FOR wm-item-embalagem-local.

def var i-seq-erro  as   integer    no-undo.

EMPTY TEMP-TABLE tt-erro.

IF codigoProduto = "" THEN DO:
    RUN piCreateError (INPUT 17006,                       /* ErrorNumber     */
                       INPUT "Item deve ser informado",   /* ErrorParameters */  
                       INPUT "ERROR").                    /* ErrorSubType    */
    RETURN 'NOK'.

END.

IF EmbalagemVolume = "" THEN DO:
    ASSIGN EmbalagemVolume = "PALLET".
END.

FIND FIRST wm-embalagem NO-LOCK
     WHERE wm-embalagem.cod-embalagem = EmbalagemVolume NO-ERROR.
IF NOT AVAIL wm-embalagem THEN DO:
    RUN piCreateError (INPUT 17006,                        /* ErrorNumber     */
                       INPUT "Embalagem n∆o cadastrada",   /* ErrorParameters */  
                       INPUT "ERROR").                     /* ErrorSubType    */
    RETURN 'NOK'.    
END.

IF EmbalagemUnidadeVolume = "" THEN
    ASSIGN EmbalagemUnidadeVolume = "CAIXA".

FIND FIRST bfwm-embalagem NO-LOCK
     WHERE bfwm-embalagem.cod-embalagem = EmbalagemUnidadeVolume NO-ERROR.
IF NOT AVAIL bfwm-embalagem THEN DO:
    RUN piCreateError (INPUT 17006,                             /* ErrorNumber     */
                       INPUT "Embalagem Item n∆o cadastrada",   /* ErrorParameters */  
                       INPUT "ERROR").                          /* ErrorSubType    */
    RETURN 'NOK'.    
END.

// Validaá∆o Estabelecimento e Local
/* WFT */
RUN esp/es0018p.p ( INPUT "item-wms":U,
                    INPUT 1, /* WFT */
                    INPUT 0,
                    INPUT "":U,
                    OUTPUT TABLE tt-prog-ponto).
IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:

    EMPTY TEMP-TABLE tt-wm-local.

    // Local
    FOR FIRST tt-prog-ponto
        WHERE tt-prog-ponto.sequencia = 0:
        ASSIGN cCodLocal = tt-prog-ponto.conteudo.
    END.

    // Estab
    FOR FIRST tt-prog-ponto
        WHERE tt-prog-ponto.sequencia = 1:
        ASSIGN cCodEstabel = tt-prog-ponto.conteudo.
    END.    

    DO i-cont = 1 TO NUM-ENTRIES(cCodEstabel,";"):
        
        FIND FIRST tt-wm-local
             WHERE tt-wm-local.cod-local   = cCodLocal
               AND tt-wm-local.cod-estabel = entry(i-cont,cCodEstabel,";") NO-ERROR.
        IF NOT AVAIL tt-wm-local THEN DO:
            CREATE tt-wm-local.
            ASSIGN tt-wm-local.cod-local   = cCodLocal                       
                   tt-wm-local.cod-estabel = entry(i-cont,cCodEstabel,";").
        END.
    END.    
END.

/* WPV */    
RUN esp/es0018p.p ( INPUT "item-wms":U,
                    INPUT 2, /* WPV */
                    INPUT 0,
                    INPUT "":U,
                    OUTPUT TABLE tt-prog-ponto).

IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:       
    // Local
    FOR FIRST tt-prog-ponto
        WHERE tt-prog-ponto.sequencia = 0:
        ASSIGN cCodLocal = tt-prog-ponto.conteudo.
    END.
    
    // Estab
    FOR FIRST tt-prog-ponto
        WHERE tt-prog-ponto.sequencia = 1:
        ASSIGN cCodEstabel = tt-prog-ponto.conteudo.
    END.            
    
    DO i-cont = 1 TO NUM-ENTRIES(cCodEstabel,";"):
        
        FIND FIRST tt-wm-local
             WHERE tt-wm-local.cod-local   = cCodLocal
               AND tt-wm-local.cod-estabel = entry(i-cont,cCodEstabel,";") NO-ERROR.
        IF NOT AVAIL tt-wm-local THEN DO:
            CREATE tt-wm-local.
            ASSIGN tt-wm-local.cod-local   = cCodLocal                       
                   tt-wm-local.cod-estabel = entry(i-cont,cCodEstabel,";").
        END.
    END.        
END.

IF CAN-FIND(FIRST tt-wm-local) THEN DO:
    
    FOR EACH tt-wm-local:
        FIND FIRST wm-local NO-LOCK
             WHERE wm-local.cod-estabel = tt-wm-local.cod-estabel
               AND wm-local.cod-local   = tt-wm-local.cod-local NO-ERROR.
        IF NOT AVAIL wm-local THEN DO:
        
            RUN piCreateError (INPUT 17006,                                                             /* ErrorNumber     */
                               INPUT "N∆o encontrado cadastro Item x Local. Verifique programa WM0240", /* ErrorParameters */  
                               INPUT "ERROR").     
            RETURN 'NOK'.            
        END.
    END.
END.

FIND FIRST wm-item EXCLUSIVE-LOCK
     WHERE wm-item.cod-item = codigoProduto NO-ERROR.
IF NOT AVAIL wm-item THEN DO:
    CREATE wm-item.
    ASSIGN wm-item.cod-item = codigoProduto.
END.

ASSIGN wm-item.cod-unid-med         = unidadeDeMedida
       wm-item.des-item             = descricaoProduto
       wm-item.ind-tipo-contr-est   = 1
       wm-item.cod-barras           = codigoBarras
       wm-item.qtd-altura           = EmbalagemAltura        
       wm-item.qtd-largura          = EmbalagemLargura       
       wm-item.qtd-comprimento      = EmbalagemComprimento
       wm-item.qtd-peso             = EmbalagemPesoBruto
       wm-item.log-consid-sdo-dest  = NO
       wm-item.log-armazena-prox-picking = YES
       wm-item.log-exclusivo-picking = YES
       OVERLAY(wm-item.char-2,1,20) = string(TODAY,"99/99/9999") + " " + string(TIME,"HH:MM:SS").

IF ativaControleDeLote = "S" THEN
    ASSIGN wm-item.log-2 = YES.
    //ASSIGN wm-item.ind-tipo-contr-est   = 2.
     

IF lastro = "S" THEN
    ASSIGN wm-item.ind-tipo-contr-est   = 3.

IF CAN-FIND(FIRST tt-wm-local) THEN DO:
    
    FOR EACH tt-wm-local.
   
        FIND FIRST wm-local NO-LOCK
             WHERE wm-local.cod-estabel = tt-wm-local.cod-estabel
               AND wm-local.cod-local   = tt-wm-local.cod-local NO-ERROR.
        IF AVAIL wm-local THEN DO:
        
            FIND FIRST wms-item-estab-local EXCLUSIVE-LOCK
                 WHERE wms-item-estab-local.cod-estab = wm-local.cod-estabel
                   AND wms-item-estab-local.cod-local = wm-local.cod-local
                   AND wms-item-estab-local.cod-item  = wm-item.cod-item NO-ERROR.
            IF NOT AVAIL wms-item-estab-local THEN DO:
                CREATE wms-item-estab-local.
                ASSIGN wms-item-estab-local.cod-estab = wm-local.cod-estabel
                       wms-item-estab-local.cod-local = wm-local.cod-local
                       wms-item-estab-local.cod-item  = wm-item.cod-item.
            END.
            
            ASSIGN wms-item-estab-local.cod-item                  = wm-item.cod-item                 
                   wms-item-estab-local.dat-ult-contag            = wm-item.dat-ult-contag           
                   wms-item-estab-local.idi-classif-abc           = wm-item.idi-classif-abc          
                   wms-item-estab-local.idi-leitura-invent        = wm-item.ind-leitura-invent       
                   wms-item-estab-local.idi-metod-armazto         = wm-item.idi-metod-armazto        
                   wms-item-estab-local.idi-tip-capac-armazto     = wm-item.idi-tip-capac-armazto    
                   wms-item-estab-local.ind-controle-saida        = wm-item.ind-controle-saida       
                   wms-item-estab-local.ind-seq-armazenamento     = wm-item.ind-seq-armazenamento    
                   wms-item-estab-local.ind-seq-retirada          = wm-item.ind-seq-retirada         
                   wms-item-estab-local.ind-unid-contr            = wm-item.ind-unid-contr           
                   wms-item-estab-local.log-armaz-estado-cq       = wm-item.log-1
                   wms-item-estab-local.log-armazena-prox-picking = wm-item.log-armazena-prox-picking
                   wms-item-estab-local.log-compart-box-item      = wm-item.log-compart-box-item     
                   wms-item-estab-local.log-compart-box-lote      = wm-item.log-compart-box-lote     
                   wms-item-estab-local.log-consid-sdo-dest       = wm-item.log-consid-sdo-dest
                   wms-item-estab-local.log-devol-area-picking    = wm-item.log-devol-area-picking   
                   wms-item-estab-local.log-efetua-packing        = wm-item.log-efetua-packing       
                   wms-item-estab-local.log-exclusivo-picking     = wm-item.log-exclusivo-picking    
                   wms-item-estab-local.log-invent-ciclico        = wm-item.log-invent-ciclico       
                   wms-item-estab-local.log-validade              = wm-item.log-validade             
                   wms-item-estab-local.num-ciclo-contag          = wm-item.num-ciclo-contag         
                   wms-item-estab-local.num-dias-reanalise        = wm-item.num-dias-reanalise       
                   wms-item-estab-local.num-dias-valid            = wm-item.num-dias-valid.
        
            FIND FIRST bfwm-item-embalagem-local NO-LOCK
                 WHERE bfwm-item-embalagem-local.cod-estabel      = wm-local.cod-estabel
                   AND bfwm-item-embalagem-local.cod-local        = wm-local.cod-local
                   AND bfwm-item-embalagem-local.cod-item         = wm-item.cod-item 
                   AND bfwm-item-embalagem-local.log-padr         = YES NO-ERROR.
            
            FIND FIRST wm-item-embalagem-local EXCLUSIVE-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel      = wm-local.cod-estabel
                   AND wm-item-embalagem-local.cod-local        = wm-local.cod-local
                   AND wm-item-embalagem-local.cod-item         = wm-item.cod-item
                   AND wm-item-embalagem-local.cod-embalagem    = wm-embalagem.cod-embalagem NO-ERROR.
            IF NOT AVAIL wm-item-embalagem-local THEN DO:
                CREATE wm-item-embalagem-local.
                ASSIGN wm-item-embalagem-local.cod-estabel      = wm-local.cod-estabel
                       wm-item-embalagem-local.cod-local        = wm-local.cod-local  
                       wm-item-embalagem-local.cod-item         = wm-item.cod-item
                       wm-item-embalagem-local.cod-embalagem    = wm-embalagem.cod-embalagem.
            END.
            
            ASSIGN wm-item-embalagem-local.cod-emb-item       = EmbalagemUnidadeVolume
                   wm-item-embalagem-local.qtd-item-emb       = EmbalagemQuantidade
                   wm-item-embalagem-local.log-abre-emb-item  = YES
                   wm-item-embalagem-local.log-abre-embalagem = YES
                   wm-item-embalagem-local.qtd-emb-item       = dec(EmbalagemUnidade)
                   wm-item-embalagem-local.qtd-peso           = wm-embalagem.qtd-peso
                   wm-item-embalagem-local.qtd-peso-item      = wm-item.qtd-peso
                   wm-item-embalagem-local.qtd-min-item-embal = 0
                   wm-item-embalagem-local.qtd-volume         = wm-embalagem.qtd-comprimento * wm-embalagem.qtd-largura * wm-embalagem.qtd-altura.

            FIND FIRST bfwm-embalagem NO-LOCK
                 WHERE bfwm-embalagem.cod-embalagem = EmbalagemUnidadeVolume NO-ERROR.
            IF AVAIL bfwm-embalagem THEN DO:
                ASSIGN wm-item-embalagem-local.qtd-volume-item    = bfwm-embalagem.qtd-comprimento * bfwm-embalagem.qtd-largura * bfwm-embalagem.qtd-altura.
            END.

            IF AVAIL bfwm-item-embalagem-local THEN DO:
                IF bfwm-item-embalagem-local.cod-embal <> EmbalagemVolume THEN
                    ASSIGN wm-item-embalagem-local.log-padr = NO.
            END.
            ELSE 
                ASSIGN wm-item-embalagem-local.log-padr = YES.
            
            FIND FIRST wm-item-embalagem-etiq EXCLUSIVE-LOCK
                 WHERE wm-item-embalagem-etiq.cod-embal = "PALLET"
                   AND wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item NO-ERROR.
            IF NOT AVAIL wm-item-embalagem-etiq THEN DO:
                CREATE wm-item-embalagem-etiq.
                ASSIGN wm-item-embalagem-etiq.cod-embal = "PALLET"
                       wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item.
            END.
                
            ASSIGN wm-item-embalagem-etiq.cod-barras        = EmbalagemCodigoBarras
                   wm-item-embalagem-etiq.log-controla-etiq = YES
                   wm-item-embalagem-etiq.cod-layout        = "0102".

            FIND FIRST wm-item-embalagem-etiq EXCLUSIVE-LOCK
                 WHERE wm-item-embalagem-etiq.cod-embal = "CAIXA"
                   AND wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item NO-ERROR.
            IF NOT AVAIL wm-item-embalagem-etiq THEN DO:
                CREATE wm-item-embalagem-etiq.
                ASSIGN wm-item-embalagem-etiq.cod-embal = "CAIXA"
                       wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item.
            END.
                
            ASSIGN wm-item-embalagem-etiq.cod-barras        = ""
                   wm-item-embalagem-etiq.log-controla-etiq = NO
                   wm-item-embalagem-etiq.cod-layout        = "0102".        
        END.
    END.
END.

RETURN "OK".

/************************************************************************************************************
**                                             PROCEDURE PICREATEERROR
************************************************************************************************************/
PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pCodigo          AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pMensagem        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pTipoErro        AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    /*
    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pCodigo,
                       INPUT pMensagem).  
    */

    FIND FIRST tt-erro 
         WHERE tt-erro.mensagem = pMensagem NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-erro THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.codigo      = pCodigo
               tt-erro.informacao  = pTipoErro
               tt-erro.mensagem    = pMensagem.
    END.

    RETURN "OK":U.    

END PROCEDURE.
