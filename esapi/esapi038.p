/* 
 
   API Impress∆o Etiqueta 5g escpp120
    
*/

{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE BUFFER b-tt-erro FOR tt-erro.    

DEFINE VARIABLE c-mac        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-num-ns     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha-adm  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha-wifi AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-imei       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sigla      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-wifi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-qr-code    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-item-atual AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-dest  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pat-claro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE r-etiqueta-5g  AS ROWID     NO-UNDO.

DEFINE VARIABLE l-FiberProd  AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-FiberCaixa AS LOGICAL NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario     AS CHAR NO-UNDO.

PROCEDURE piCriaTabelaImpressao:
    
    DEFINE INPUT PARAM p-item        AS CHAR NO-UNDO.    
    DEFINE INPUT PARAM p-sigla       AS CHAR NO-UNDO.    
    DEFINE INPUT PARAM p-qr-code     AS CHAR NO-UNDO. 
    DEFINE INPUT PARAM p-printer     AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-patri-claro AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-modelo      AS INT  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    RUN esp/es0018p.p (INPUT "escpp120":U,
                       INPUT 4,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        IF INT(tt-prog-ponto.conteudo) = p-modelo THEN 
           ASSIGN l-FiberProd = YES.
    END.    
    
    IF l-FiberProd THEN DO:
       ASSIGN c-qr-code = p-qr-code.

       FIND FIRST mac-address 
            WHERE mac-address.mac = c-qr-code
       NO-LOCK NO-ERROR.

       IF AVAIL mac-address THEN
          ASSIGN c-mac        = mac-address.mac
                 c-num-ns     = mac-address.n-serie 
                 c-senha-wifi = mac-address.char-1
                 c-senha-adm  = mac-address.char-2
                 c-sigla      = p-sigla
                 c-item-dest  = p-item.
       ELSE DO:
           FIND FIRST mac-address NO-LOCK 
                 WHERE mac-address.n-serie = c-qr-code
           NO-ERROR.                     
           
           IF AVAIL mac-address THEN DO:
              ASSIGN l-FiberCaixa = YES.

              FOR EACH mac-address NO-LOCK 
                 WHERE mac-address.n-serie = c-qr-code
                 BREAK BY mac-address.mac:
                 
                 ASSIGN c-mac        = mac-address.mac
                        c-num-ns     = mac-address.n-serie 
                        c-senha-wifi = mac-address.char-1
                        c-senha-adm  = mac-address.char-2
                        c-sigla      = p-sigla
                        c-item-dest  = p-item.

                 LEAVE.
              END.                            
           END.
       END.    
    END.
    ELSE DO:
    
        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = p-item NO-ERROR.  

        IF item-ean.modelo-mac-address = 6 OR item-ean.modelo-mac-address = 9 THEN 
            ASSIGN c-qr-code    = p-qr-code
                   c-mac        = ENTRY(1,p-qr-code,'\\')
                   c-num-ns     = ENTRY(1,c-mac,';')                   
                   c-senha-adm  = ENTRY(3,c-mac,';')
                   c-senha-wifi = ENTRY(4,c-mac,';')
                   c-mac        = ENTRY(2,c-mac,';')
                   c-sigla      = p-sigla
                   c-item-dest  = p-item. 
        ELSE DO: 

            ASSIGN l-FiberProd = YES.

           /* M2407-102 - Produto FiberHome */
            ASSIGN c-qr-code    = p-qr-code
                   c-mac        = c-qr-code  
                   c-num-ns     = ENTRY(1,c-mac,';')
                   c-mac        = ENTRY(2,c-qr-code ,';')
                   c-nome-wifi  = ENTRY(3,c-qr-code ,';')
                   c-senha-wifi = ENTRY(4,c-qr-code ,';')
                   c-senha-adm  = ENTRY(6,c-qr-code ,';')
                   c-sigla      = p-sigla
                   c-item-dest  = p-item.
        END.
    
        IF AVAIL item-ean THEN DO:
           IF item-ean.imei THEN DO:
              IF INDEX(p-qr-code,"\\") > 0 AND SUBSTRING(p-qr-code,INDEX(p-qr-code,"\\") + 1) <> '' THEN
                  ASSIGN c-imei = SUBSTRING(p-qr-code,INDEX(p-qr-code,"\\"))
                         c-imei = REPLACE(ENTRY(1,c-imei,';'),'\',''). 
           END.
        END.
    
        ASSIGN c-pat-claro = TRIM(p-patri-claro).

    END.

    RUN piValidate.
    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK". 


    FOR FIRST item-ean NO-LOCK
        WHERE item-ean.it-codigo = p-item: /*mac-address.it-codigo.*/

         FIND FIRST mac-address NO-LOCK 
              WHERE mac-address.mac = c-mac NO-ERROR.   

         IF AVAIL mac-address THEN DO: 
            IF item-ean.modelo-mac-address = 6 OR item-ean.modelo-mac-address = 9 THEN DO:
                IF item-ean.operadora = 1 THEN /* CLARO */
                   ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + UPPER(SUBSTRING(mac-address.mac,7,6)).
                ELSE
                   ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + LOWER(SUBSTRING(mac-address.mac,9,4)).
            END.
         END.
    END.

    DO TRANS:    
        CREATE int-etiqueta-5g.
        ASSIGN int-etiqueta-5g.it-codigo      = p-item
               int-etiqueta-5g.celula-nome    = c-sigla
               int-etiqueta-5g.cod-imei       = c-imei 
               int-etiqueta-5g.cod-operadora  = "01"
               int-etiqueta-5g.data           = NOW
               int-etiqueta-5g.mac            = c-mac
               int-etiqueta-5g.n-serie        = c-num-ns
               int-etiqueta-5g.qr-code        = p-qr-code
               int-etiqueta-5g.senha-admin    = c-senha-adm
               int-etiqueta-5g.senha-wifi     = c-senha-wifi
               int-etiqueta-5g.wifi-ssid      = c-nome-wifi
               int-etiqueta-5g.patrimonio     = p-patri-claro. 
        
        FOR FIRST mac-address EXCLUSIVE-LOCK
            WHERE mac-address.mac = c-mac.
        
            ASSIGN int-etiqueta-5g.num-pedido    = mac-address.num-pedido
                   int-etiqueta-5g.it-codigo-po  = mac-address.it-codigo. /*Cod.Item Original PO */

            ASSIGN mac-address.it-codigo = p-item.
        END.

        FOR FIRST num-serie EXCLUSIVE-LOCK 
            WHERE num-serie.n-serie = c-num-ns:
            ASSIGN num-serie.it-codigo = p-item.
        END.                                       
        
        IF l-FiberProd THEN
           ASSIGN int-etiqueta-5g.fiber-prod = YES.

        IF l-FiberCaixa THEN
           ASSIGN int-etiqueta-5g.fiber-caixa = YES.
    END.

    /* Caixa FiberHome */
    IF l-FiberCaixa THEN
       ASSIGN p-modelo = 665. 
   
    RUN piImpressao (INPUT p-printer,
                     INPUT ROWID(int-etiqueta-5g),
                     INPUT NO, /* Reimpress∆o */
                     INPUT 0, /* Motivo Reimpress∆o */
                     INPUT p-modelo,
                     OUTPUT TABLE tt-erro).

    RETURN "OK".

END PROCEDURE.

PROCEDURE piValidate:

    DEFINE VARIABLE l-imprime-item AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-modelo-atual AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-modelo-dest  AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-pat AS INTEGER     NO-UNDO.

    DEFINE VARIABLE l-senhaFiber AS LOG INITIAL NO NO-UNDO.

    /*
    IF c-sigla NE "" THEN DO:
        IF NOT CAN-FIND(FIRST ns-sigla
                        WHERE ns-sigla.sigla = c-sigla) THEN DO:
        
            RUN piGeraErro(INPUT 56,
                           INPUT "CÇlula").
        END.
    END.
    */
    FIND FIRST mac-address NO-LOCK 
         WHERE mac-address.mac = c-mac NO-ERROR.   
    IF NOT AVAIL mac-address THEN DO:
        RUN piGeraErro(INPUT 17006,
                       INPUT "Numero de MAC n∆o cadastrado").
    END.
    ELSE DO:
       /* M2407-102 - Senhas Fiber nao devem ser validadas */                       
       /* MAC + GPON codigo de barras/ QR CODE com senha ADMIN+ Senha WIFI */
       FIND FIRST item-ean NO-LOCK
            WHERE item-ean.it-codigo = mac-address.it-codigo NO-ERROR.  

       IF AVAIL item-ean THEN DO:
           IF item-ean.modelo-mac-address <> 6 AND item-ean.modelo-mac-address <> 9 THEN 
              ASSIGN l-senhaFiber = YES.            
       END.

       IF NOT l-senhaFiber THEN DO:
          IF mac-address.char-1 NE c-senha-wifi THEN DO:
              RUN piGeraErro(INPUT 17006,
                             INPUT "Senha Wifi diferente do cadastro do MAC").
          END.
    
          IF mac-address.char-2 NE c-senha-adm THEN DO:
              RUN piGeraErro(INPUT 17006,
                             INPUT "Senha Adm diferente do cadastro do MAC").               
          END.      
       END.

    END.

    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = c-num-ns NO-ERROR.
    IF NOT AVAIL num-serie THEN DO:
        RUN piGeraErro(INPUT 17006,
                       INPUT 'Numero de serie n∆o cadastrado'+ '~~' + 'Numero de serie ' + c-num-ns + ' n∆o encontrado').        
    END.


    IF NOT l-FiberProd THEN DO: 
       IF CAN-FIND(FIRST int-etiqueta-5g
                   WHERE int-etiqueta-5g.qr-code = c-qr-code) THEN DO:
           RUN piGeraErro(INPUT 17006,
                          INPUT 'QRCode j† impresso na etiqueta 5g').        
       END.
       
       IF CAN-FIND(FIRST int-etiqueta-5g
                   WHERE int-etiqueta-5g.mac = c-mac) THEN DO:
           RUN piGeraErro(INPUT 17006,
                          INPUT 'Mac Address j† impresso na etiqueta 5g').
       END.
       
       IF CAN-FIND(FIRST int-etiqueta-5g
                   WHERE int-etiqueta-5g.n-serie = c-num-ns) THEN DO:
           RUN piGeraErro(INPUT 17006,
                          INPUT 'Numero de serie j† impresso na etiqueta 5g').
       END.
    END.
    ELSE DO:
       FIND FIRST int-etiqueta-5g
            WHERE int-etiqueta-5g.qr-code = c-qr-code
       NO-LOCK NO-ERROR.

       IF AVAIL int-etiqueta-5g THEN DO:
          IF NOT l-FiberCaixa THEN DO:
             RUN piGeraErro(INPUT 17006,
                            INPUT 'Mac Address j† impresso na etiqueta FiberHome').
          END.
          ELSE DO:
              IF int-etiqueta-5g.fiber-caixa THEN DO:
                 RUN piGeraErro(INPUT 17006,
                                INPUT 'Caixa FiberHome ja impressa').
              END.
          END.                                                   
       END.
    END.
    

    IF AVAIL num-serie THEN DO:

        RUN esp/es0018p.p (INPUT "escpp120":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        ASSIGN l-imprime-item = NO.
        
        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = num-serie.it-codigo NO-ERROR.  

        IF AVAIL item-ean THEN DO:
           FOR EACH tt-prog-ponto:
        
               IF INDEX(item-ean.nome-abrev,tt-prog-ponto.conteudo) <> 0 THEN DO:
                   ASSIGN l-imprime-item = YES.
        
                   ASSIGN c-modelo-atual = entry(1,item-ean.nome-abrev,"").
               END.
           END.       
        END.
        
        IF NOT l-imprime-item AND NOT l-FiberProd THEN DO:
            RUN piGeraErro(INPUT 17006,       
                           INPUT 'Produto atual do n£mero de sÇrie inv†lido. Modelo informado n∆o esta cadastrado como sendo da linha 5G. Procure pela Engenharia de produtos').
        END.
        
        ASSIGN l-imprime-item = NO.
        
        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = c-item-dest NO-ERROR.  

        IF AVAIL item-ean THEN DO:
            IF item-ean.imei THEN DO:
               IF c-imei = "" THEN
                  RUN piGeraErro(INPUT 17006,     
                                  INPUT 'Produto exige que IMEI seja informado').
               ELSE DO:
                  IF LENGTH(c-imei) <> 15 THEN
                    RUN piGeraErro(INPUT 17006,     
                                   INPUT 'Imei invalido. IMEI deve conter 15 caracteres.' + '~~' + 'IMEI Lido: ' + c-imei ).
               END.
            END.

            FOR EACH tt-prog-ponto:
                IF INDEX(item-ean.nome-abrev,tt-prog-ponto.conteudo) <> 0 THEN DO:
                    ASSIGN l-imprime-item = YES.
            
                    ASSIGN c-modelo-dest = entry(1,item-ean.nome-abrev,"").
            
                    IF c-modelo-atual NE c-modelo-dest THEN DO:
                        RUN piGeraErro(INPUT 17006,
                                       INPUT 'Produto a ser transformado invalido.' + 
                                             ' Modelo do item atual difere do modelo do item a ser transformado. Modelo atual: ' + c-modelo-atual + 
                                             ' Modelo a ser transformado: ' + c-modelo-dest ).
                    END.
                END.
            END.       
        END.
    END.

    FIND FIRST item-ean NO-LOCK
         WHERE item-ean.it-codigo = c-item-dest NO-ERROR. 

    IF item-ean.operadora = 1 THEN DO: /* CLARO */
        
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "escpp120":U,
                           INPUT 3,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR EACH tt-prog-ponto:

            IF entry(1,tt-prog-ponto.conteudo,';') = 'Sim' THEN DO:
               DO i-pat = 1 TO LENGTH(c-pat-claro):
                  IF SUBSTRING(c-pat-claro,i-pat,1) < '0' OR
                     SUBSTRING(c-pat-claro,i-pat,1) > '9' THEN DO:
                     RUN piGeraErro (INPUT 17006,
                                     INPUT 'Patrimonio CLARO invalido~~Conteudo informado deve possuir apenas caracteres numericos').
                  END.              
               END.
    
               ASSIGN i-pat = i-pat - 1.
        
               IF i-pat <> INT(entry(2,tt-prog-ponto.conteudo,';')) THEN DO:
                   RUN piGeraErro (INPUT 17006,
                                   INPUT "Patrimonio CLARO invalido. Informado com "  + STRING(i-pat) + " caracteres" + 
                                         "~~Conteudo informado deve possuir " + ENTRY(2,tt-prog-ponto.conteudo,';') +  " caracteres").
               END.
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE piGeraErro :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num        AS INTEGER      NO-UNDO.
    DEFINE INPUT PARAMETER p-desc       AS CHAR         NO-UNDO.
    
    DEFINE VARIABLE c-msg AS CHARACTER   NO-UNDO.
    
    FOR LAST b-tt-erro
        BY tt-erro.i-sequen:
    END.
    
    /*RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT p-num,
                       INPUT p-desc).
    
    ASSIGN c-msg = RETURN-VALUE.*/
        
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = IF AVAIL b-tt-erro THEN b-tt-erro.i-sequen + 1 ELSE 1
           tt-erro.cd-erro  = p-num
           //tt-erro.mensagem = c-msg.
           tt-erro.mensagem  = p-desc.

END PROCEDURE.

PROCEDURE piRetornaErros :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piTransformacao:
    
    DEFINE INPUT PARAM p-ns           AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-item-atual   AS CHAR NO-UNDO.    
    DEFINE INPUT PARAM p-item-dest    AS CHAR NO-UNDO. 
    DEFINE INPUT PARAM p-celula       AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-printer      AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-patri-claro  AS CHAR NO-UNDO. 
    DEFINE INPUT PARAM p-modelo       AS INT  NO-UNDO. 
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    ASSIGN c-num-ns     = p-ns
           c-item-atual = p-item-atual
           c-item-dest  = p-item-dest
           c-pat-claro  = p-patri-claro.
    
    RUN piValidateTransf.
    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK". 

    FOR FIRST int-etiqueta-5g EXCLUSIVE-LOCK
        WHERE ROWID(int-etiqueta-5g) = r-etiqueta-5g.

        ASSIGN int-etiqueta-5g.it-codigo-transf  = p-item-atual
               int-etiqueta-5g.it-codigo         = p-item-dest
               int-etiqueta-5g.celula-nome       = p-celula.

        IF p-patri-claro NE "" THEN
            ASSIGN int-etiqueta-5g.patrimonio     = p-patri-claro.

        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = c-item-atual NO-ERROR.  
        IF AVAIL item-ean THEN DO:
            IF item-ean.operadora = 1 THEN DO: /* CLARO */
                FIND FIRST item-ean NO-LOCK
                     WHERE item-ean.it-codigo = c-item-dest NO-ERROR.  
                IF AVAIL item-ean THEN DO:
                    IF item-ean.operadora NE 1 THEN DO: /* DIFERENTE CLARO */
                        ASSIGN int-etiqueta-5g.patrimonio = "".
                    END.
                END.
            END.
        END.

        FIND CURRENT int-etiqueta-5g NO-LOCK NO-ERROR.

        FOR FIRST mac-address EXCLUSIVE-LOCK
            WHERE mac-address.mac = int-etiqueta-5g.mac.                  

            ASSIGN mac-address.it-codigo = p-item-dest.
        END.
        RELEASE mac-address NO-ERROR.

        FOR FIRST num-serie EXCLUSIVE-LOCK 
            WHERE num-serie.n-serie = c-num-ns:

            ASSIGN num-serie.it-codigo = p-item-dest.
        END.   
        RELEASE num-serie NO-ERROR.        

        RUN piImpressao (INPUT p-printer,
                         INPUT r-etiqueta-5g,
                         INPUT YES, /* Reimpress∆o */
                         INPUT 5, /* Motivo Reimpress∆o: Transformaá∆o Produto */
                         INPUT p-modelo,
                         OUTPUT TABLE tt-erro).
    END.            

    RETURN "OK".

END PROCEDURE.

PROCEDURE piValidateTransf:

    DEFINE VARIABLE l-imprime-item AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-modelo-atual AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-modelo-dest  AS CHARACTER   NO-UNDO.

    FIND FIRST int-etiqueta-5g NO-LOCK
         WHERE int-etiqueta-5g.n-serie = c-num-ns NO-ERROR.
    IF NOT AVAIL int-etiqueta-5g THEN DO:
        RUN piGeraErro(INPUT 17006,
                       INPUT 'Numero de serie n∆o cadastrado em Etiqueta 5g. Numero de serie ' + c-num-ns + ' n∆o encontrado').
    END.
    ELSE DO:
        ASSIGN r-etiqueta-5g = ROWID(int-etiqueta-5g).
    END.

    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = c-num-ns NO-ERROR.
    IF NOT AVAIL num-serie THEN DO:
        RUN piGeraErro(INPUT 17006,
                       INPUT 'Numero de serie n∆o cadastrado. Numero de serie ' + c-num-ns + ' n∆o encontrado').
    END.

    RUN esp/es0018p.p (INPUT "escpp120":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN l-imprime-item = NO.

    FIND FIRST item-ean NO-LOCK
         WHERE item-ean.it-codigo = c-item-atual NO-ERROR.  
    IF AVAIL item-ean THEN DO:
       FOR EACH tt-prog-ponto:

           IF INDEX(item-ean.nome-abrev,tt-prog-ponto.conteudo) <> 0 THEN DO:
               ASSIGN l-imprime-item = YES.

               ASSIGN c-modelo-atual = entry(1,item-ean.nome-abrev,"").
           END.
       END.       
    END.

    IF NOT l-imprime-item THEN DO:
        RUN piGeraErro(INPUT 17006,       
                       INPUT 'Produto atual invalido. Modelo informado n∆o esta cadastrado como sendo da linha 5G. Procure pela Engenharia de produtos').
    END.

    ASSIGN l-imprime-item = NO.

    FIND FIRST item-ean NO-LOCK
         WHERE item-ean.it-codigo = c-item-dest NO-ERROR.  
    IF AVAIL item-ean THEN DO:
        FOR EACH tt-prog-ponto:
            IF INDEX(item-ean.nome-abrev,tt-prog-ponto.conteudo) <> 0 THEN DO:
                ASSIGN l-imprime-item = YES.
        
                ASSIGN c-modelo-dest = entry(1,item-ean.nome-abrev,"").
        
                IF c-modelo-atual NE c-modelo-dest THEN DO:
                    RUN piGeraErro(INPUT 17006,
                                   INPUT 'Produto a ser transformado invalido.' + 
                                         ' Modelo do item atual difere do modelo do item a ser transformado. Modelo atual: ' + c-modelo-atual + 
                                         ' Modelo a ser transformado: ' + c-modelo-dest ).
                END.
        
                IF item-ean.operadora = 1 THEN DO: /* CLARO */
                    IF c-pat-claro = "" THEN
                        RUN piGeraErro(INPUT 17006,
                                       INPUT 'Patrimonio CLARO deve ser informado').                    
                    ELSE DO:
                        FIND FIRST int-etiqueta-5g NO-LOCK
                             WHERE int-etiqueta-5g.patrimonio = c-pat-claro NO-ERROR.
                        IF AVAIL int-etiqueta-5g THEN
                           RUN piGeraErro(INPUT 17006,
                                          INPUT 'Patrimonio CLARO ja foi lido anteriormente SN: ' + 
                                                 int-etiqueta-5g.n-serie ).
                    END.
                END.
            END.
        END.       
    END.

    IF NOT l-imprime-item THEN DO:
       RUN piGeraErro(INPUT 17006,
                      INPUT 'Produto a ser transformado invalido. ' + 
                            'Modelo informado n∆o esta cadastrado como sendo da linha 5G. ' + 
                            'Procure pela Engenharia de produtos'). 
    END.

END PROCEDURE.

PROCEDURE piImpressao:

    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-printer      AS CHAR    NO-UNDO.
    DEFINE INPUT PARAM p-rowid        AS ROWID   NO-UNDO.
    DEFINE INPUT PARAM p-reimp        AS LOG     NO-UNDO.
    DEFINE INPUT PARAM p-motivo-reimp AS INT     NO-UNDO.
    DEFINE INPUT PARAM p-modelo       AS INT     NO-UNDO. 
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
      
    DEFINE VARIABLE c-cgc            AS CHARACTER   NO-UNDO.    
    DEFINE VARIABLE c-monta-qr-code  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome-wifi-aux  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-senha-wifi     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-senha-adm      AS CHARACTER   NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro.
    
    
    FIND FIRST int-etiqueta-5g NO-LOCK
         WHERE ROWID(int-etiqueta-5g) = p-rowid NO-ERROR.
    IF NOT AVAIL int-etiqueta-5g THEN DO:
        RUN piGeraErro(INPUT 17006,
                       INPUT "N∆o foi encontrado a etiqueta 5g").
    END.
    ELSE DO:
        IF p-reimp THEN DO:
            IF p-motivo-reimp = 0 THEN DO:
                RUN piGeraErro(INPUT 17006,
                               INPUT "Motivo de reimpress∆o deve ser informado").        
            END.
            ELSE DO:
                RUN piAtualizaNumSerie (INPUT int-etiqueta-5g.n-serie,
                                        INPUT p-motivo-reimp).
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK".
    


    RUN piSetaImpressora(INPUT p-printer).

    //ASSIGN v_nom_disposit_so = 'c:/temp/5gggggggggggg-FIBER.txt'. /* #COMENTAR AP‡S TESTAR */
    OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".
    
    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW3500"     SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    PUT "^XZ"         SKIP.
    
    FOR FIRST item-mat NO-LOCK
        WHERE item-mat.it-codigo = int-etiqueta-5g.it-codigo:
    END.

    FOR FIRST item-ean NO-LOCK
        WHERE item-ean.it-codigo = int-etiqueta-5g.it-codigo:
    END.

    FIND FIRST mac-address NO-LOCK 
         WHERE mac-address.mac = int-etiqueta-5g.mac NO-ERROR.

    FIND FIRST num-serie NO-LOCK                                                                                                                                              
         WHERE num-serie.n-serie = int-etiqueta-5g.n-serie NO-ERROR.

    IF AVAIL mac-address THEN DO:
        
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = mac-address.cod-estabel NO-ERROR.
        IF AVAIL estabelec THEN
           ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").

        PUT "^XA" SKIP.        
     
        {esapi\esapi038a.i}

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
     END.
     
     OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE piSetaImpressora:
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-impressora  AS CHAR NO-UNDO.
    
    DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.
    
    IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:
    
        ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
               cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).
    
        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE imprsor_usuar THEN DO:
                
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 4306,
                               INPUT c-seg-usuario).   
        END.
    
        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora    = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE layout_impres THEN DO:
            
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 4306,
                               INPUT c-seg-usuario).
        END.
    END.
    ELSE DO:
        IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 4306,
                               INPUT c-seg-usuario).
        END.
    
        ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
               cLayout  = ENTRY(2, p-impressora, ":":U).
    
        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE imprsor_usuar THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 4306,
                               INPUT c-seg-usuario).
        END.
    
        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 4306,
                               INPUT c-seg-usuario).            
        END.
    END.   
    
    ASSIGN v_nom_disposit_so = "".
    
    IF AVAIL imprsor_usuar THEN
        ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

END PROCEDURE.

PROCEDURE piAtualizaNumSerie:
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-n-serie AS CHAR   NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo AS INT     NO-UNDO.
        
    FIND FIRST num-serie EXCLUSIVE-LOCK
         WHERE num-serie.n-serie = p-n-serie NO-ERROR.
    
    ASSIGN num-serie.re-impr = num-serie.re-impr + 1
           num-serie.dt-ult-re = NOW
           num-serie.us-ult-re = c-seg-usuario
           /*num-serie.motiv-re = p-motivo.*/
           num-serie.tipo-re = p-motivo.
    
    RELEASE num-serie.
    
    RETURN "OK".
    
END PROCEDURE.
