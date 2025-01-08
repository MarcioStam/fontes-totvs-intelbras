/*****************************************************************************
** Programa: upc\ceapi001-upc.p
** Vers∆o..: 1.00
** Data....: 19/12/2013
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: UPC respons†vel por altera a Conta e Centro de Custo do movimento
**           de estoque.
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
{include/i-epc200.i1}
{utp/utapi019.i}

{esp/es0018.i}


DEF BUFFER b-movto-estoq FOR movto-estoq.

DEF TEMP-TABLE tt-transfere-item
    field cod-estabel as char
    field cod-item    as char
    field qtd-item    AS DEC.

PROCEDURE piInicio-pi-valida-lote:
    DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.
    
    /*--- Definiá∆o das Vari†velis Locais ---*/
    DEFINE VARIABLE h-handle         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-tt-movto       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hq-tt-movto      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-cod-estabel    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-cod-unid-negoc AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-nat-operacao   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-ct-codigo      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-sc-codigo      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-serie-docto    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-nro-docto      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-cod-emitente   AS HANDLE      NO-UNDO.

    /*--- Bloco Principal ---*/
    IF  p-ind-event = "Inicio-pi-valida-lote":U THEN DO:
        FIND FIRST tt-epc NO-LOCK
            WHERE  tt-epc.cod-event     = p-ind-event
            AND    tt-epc.cod-parameter = "tt-movto(handle)" NO-ERROR.
        IF  NOT AVAIL tt-epc THEN
            RETURN "NOK":U.
    
        ASSIGN h-handle   = WIDGET-HANDLE(tt-epc.val-parameter)
               h-tt-movto = h-handle:DEFAULT-BUFFER-HANDLE.
    
        ASSIGN h-cod-estabel    = h-tt-movto:BUFFER-FIELD("cod-estabel")
               h-cod-unid-negoc = h-tt-movto:BUFFER-FIELD("cod-unid-negoc")
               h-nat-operacao   = h-tt-movto:BUFFER-FIELD("nat-operacao")
               h-ct-codigo      = h-tt-movto:BUFFER-FIELD("ct-codigo")
               h-sc-codigo      = h-tt-movto:BUFFER-FIELD("sc-codigo")
               h-serie-docto    = h-tt-movto:BUFFER-FIELD("serie-docto")
               h-nro-docto      = h-tt-movto:BUFFER-FIELD("nro-docto")
               h-cod-emitente   = h-tt-movto:BUFFER-FIELD("cod-emitente").
    
        FIND FIRST int-unid-neg-natur NO-LOCK
            WHERE  int-unid-neg-natur.cod-estabel  = h-cod-estabel:BUFFER-VALUE
            AND    int-unid-neg-natur.cod-unid-neg = h-cod-unid-negoc:BUFFER-VALUE
            AND    int-unid-neg-natur.nat-operacao = h-nat-operacao:BUFFER-VALUE NO-ERROR.
        IF  AVAIL  int-unid-neg-natur THEN
            ASSIGN h-ct-codigo:BUFFER-VALUE = int-unid-neg-natur.ct-codigo
                   h-sc-codigo:BUFFER-VALUE = int-unid-neg-natur.sc-codigo.
        ELSE DO:
            /* pesquisa o ped-fiscal pela nota de origem no caso de ser uma devoluá∆o */ 
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = h-nat-operacao:BUFFER-VALUE NO-ERROR.

            IF  AVAIL natur-oper
            AND natur-oper.especie-doc = 'NFD' THEN DO:

                FIND FIRST nota-fisc-adc NO-LOCK 
                     WHERE nota-fisc-adc.cod-estab    = h-cod-estabel:BUFFER-VALUE 
                       AND nota-fisc-adc.cod-serie    = h-serie-docto:BUFFER-VALUE
                       AND nota-fisc-adc.cod-nota-fis = h-nro-docto:BUFFER-VALUE
                       AND nota-fisc-adc.cdn-emitente = h-cod-emitente:BUFFER-VALUE NO-ERROR.

                IF AVAIL nota-fisc-adc THEN DO:
                    FIND FIRST ped-fiscal NO-LOCK 
                         WHERE ped-fiscal.cod-estabel = nota-fisc-adc.cod-estab
                           AND ped-fiscal.serie       = nota-fisc-adc.cod-ser-docto-referado
                           AND ped-fiscal.nr-nota-fis = nota-fisc-adc.cod-docto-referado NO-ERROR.
                        
                    IF  AVAIL ped-fiscal /* Se for uma nota de solicitaá∆o de nota fiscal ent∆o considera o ccusto informado na solicitaá∆o */
                    AND SUBSTRING(h-ct-codigo:BUFFER-VALUE,1,1) = "4" THEN DO: /* somente troca a conta que iniciam com 4 */
                        ASSIGN h-sc-codigo:BUFFER-VALUE = ped-fiscal.sc-codigo.
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.


PROCEDURE piEND-CEAPI001:
    DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.
    DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-programa       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-depos-origem   AS CHARACTER   NO-UNDO.
     
    ASSIGN c-programa  = ''.

    /**/
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event = "ProgramaOrigemWMS" 
           AND tt-epc.cod-parameter = "cod-prog-orig" NO-ERROR.
    
    IF AVAIL tt-epc  THEN
       ASSIGN c-programa = tt-epc.val-parameter.
    
    /*
    IF c-programa = "wmprx281" THEN 
    DO: 
        RUN esp/es0018p.p (INPUT "esftp211":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        FOR EACH tt-prog-ponto:
            IF entry(1,tt-prog-ponto.conteudo,';') = movto-estoq.cod-estabel THEN
               ASSIGN c-depos-origem = entry(2,tt-prog-ponto.conteudo,';').
        END.             

        FIND FIRST wm-docto WHERE wm-docto.cod-estabel = movto-estoq.cod-estabel 
                              AND wm-docto.cod-local   = c-depos-origem
                              AND wm-docto.num-docto   = movto-estoq.nro-docto             
        NO-LOCK NO-ERROR.

        IF AVAIL wm-docto THEN
           MESSAGE wm-docto.cod-estabel skip
                   wm-docto.cod-local   skip
                   wm-docto.num-docto   skip
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

        CREATE TT-EPC.
        ASSIGN tt-epc.cod-event     = "END-CEAPI001" 
               tt-epc.cod-parameter = "Retorno Erro" 
               tt-epc.val-parameter = "Yes".

        RETURN 'NOK'.
    END.*/


    
    FOR FIRST tt-epc NO-LOCK
        WHERE  tt-epc.cod-event     = "end-ceapi001"
        AND    tt-epc.cod-parameter = "MOVTO-ESTOQ-ROWID":

        FOR FIRST movto-estoq NO-LOCK
            WHERE rowid(movto-estoq) = TO-ROWID(tt-epc.val-parameter):

            FOR EACH emails-movto NO-LOCK
                WHERE emails-movto.cod-estabel = movto-estoq.cod-estabel
                AND   emails-movto.cod-depos   = movto-estoq.cod-depos
                AND  (emails-movto.cod-localiz = movto-estoq.cod-localiz OR emails-movto.cod-localiz = "*")
                AND   emails-movto.tipo-trans  = movto-estoq.tipo-trans:

                RUN pi-envia-aviso-movto(INPUT emails-movto.emails).
                
            END.

            /* Baixa Item da TV do Edu */
            IF movto-estoq.tipo-trans = 2 /* Saida */ AND   
               movto-estoq.esp-docto  = 33 /* TRA */  AND   
               movto-estoq.cod-depos  = "REC" THEN DO:

               FIND FIRST b-movto-estoq NO-LOCK
                    WHERE b-movto-estoq.dt-trans      = movto-estoq.dt-trans
                      AND b-movto-estoq.nro-docto     = movto-estoq.nro-docto
                      AND b-movto-estoq.serie-docto   = movto-estoq.serie-docto
                      AND b-movto-estoq.cod-estabel   = movto-estoq.cod-estabel
                      AND b-movto-estoq.it-codigo     = movto-estoq.it-codigo
                      AND b-movto-estoq.cod-refer     = movto-estoq.cod-refer
                      AND b-movto-estoq.quantidade    = movto-estoq.quantidade
                      AND b-movto-estoq.un            = movto-estoq.un
                      AND b-movto-estoq.esp-docto     = 33
                      AND b-movto-estoq.tipo-trans    = 1
                      AND b-movto-estoq.cod-prog-orig = movto-estoq.cod-prog-orig
                      AND b-movto-estoq.cod-emitente  = movto-estoq.cod-emitente NO-ERROR.
               IF AVAIL b-movto-estoq THEN DO:
                  FOR FIRST it-critico-cq EXCLUSIVE-LOCK USE-INDEX it-sit-dt
                      WHERE it-critico-cq.cod-estabel = movto-estoq.cod-estabel
                      AND   it-critico-cq.it-codigo   = movto-estoq.it-codigo
                      AND   it-critico-cq.situacao    = 0  /* Aberto */:
                  
                      IF b-movto-estoq.cod-depos = "DEV" THEN
                          ASSIGN i-situacao = 2. /* Bloqueado */
                      ELSE
                          ASSIGN i-situacao = 1. /* Liberado */
                  
                      ASSIGN it-critico-cq.situacao = i-situacao
                             it-critico-cq.dt-atend = NOW.
                  
                      RUN pi-envia-aviso-cq (INPUT it-critico-cq.email,
                                             INPUT i-situacao).
                  
                  END.
                  RELEASE it-critico-cq.
               END.
            END.     

            IF c-programa = 'CP0318' /*Desmontagem*/ AND movto-estoq.esp-docto = 6 /*DIV*/ THEN
               RUN pi-transfere-doc-WMS.

            IF c-programa = 'cpapi011' /*Estorno*/  AND movto-estoq.esp-docto = 31 /*RRQ*/ THEN
               RUN pi-transfere-doc-WMS.

        END.

    END.

    

END PROCEDURE.

PROCEDURE pi-envia-aviso-cq:

    DEFINE INPUT PARAMETER p-email      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-lib-bloq   AS INT      NO-UNDO.


    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = it-critico-cq.it-codigo:
    END.

    FOR FIRST param-global NO-LOCK:
    END.

    run utp/utapi019.p persistent set h-utapi019.
    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.destino           = p-email
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.assunto           = "Liberaá∆o de Item Cr°tico" 
           tt-envio2.mensagem          = IF p-lib-bloq = 1 THEN "Material Liberado" ELSE "Material Bloqueado".
                                                                                                    
    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + CHR(13) + CHR(13) + CHR(13) + 
                                         "Estabelecimento: " + it-critico-cq.cod-estabel + CHR(13) +
                                         "Solicitaá∆o: " + string(it-critico-cq.cod-solic) + CHR(13) +
                                         "Item: " + it-critico-cq.it-codigo + " - " + ITEM.desc-item + CHR(13) + 
                                         "Data Solicitaá∆o: " + string(it-critico-cq.dt-solic, "99/99/9999 HH:MM:SS") + CHR(13).

    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + IF p-lib-bloq = 1 THEN "Data Liberaá∆o: " ELSE "Data Bloqueio: ".
                                                                                                                              
    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + STRING(it-critico-cq.dt-atend, "99/99/9999 HH:MM:SS").
       
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute in h-utapi019 (input  table tt-envio2, output table tt-erros).
    output close.
    delete procedure h-utapi019.

    if available tt-envio2 then
        delete tt-envio2.    


    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-envia-aviso-movto:

    DEFINE INPUT PARAMETER p-email      AS CHAR     NO-UNDO.


    FOR FIRST param-global NO-LOCK:
    END.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = movto-estoq.it-codigo:
    END.

    IF movto-estoq.usuario <> "" THEN DO:
        FOR FIRST usuar_mestre FIELDS(nom_usuario)
            WHERE usuar_mestre.cod_usuario = movto-estoq.usuario NO-LOCK: END.
    END.

    run utp/utapi019.p persistent set h-utapi019.
    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.destino           = p-email
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.assunto           = "Movimento de Estoque" 
           tt-envio2.mensagem          = "Seu e-mail est† parametrizado para receber aviso quando ocorrer uma movimentaá∆o de estoque conforme dados abaixo:"  + CHR(10) + CHR(10) + 
                                         "Estabelecimento: " + movto-estoq.cod-estabel + CHR(10) +
                                         "Dep¢sito: " + movto-estoq.cod-depos + CHR(10) +
                                         "Local: " + movto-estoq.cod-localiz + (IF emails-movto.cod-localiz = "*" THEN " (*)" ELSE "") + CHR(10) +
                                         "Tipo Trans: " + (IF movto-estoq.tipo-trans = 1 THEN "Entrada" ELSE "Sa°da") + CHR(10) +
                                         "Item: " + movto-estoq.it-codigo + " - " + ITEM.desc-item + CHR(10) + 
                                         "Quantidade: " + trim(string(movto-estoq.quantidade, ">>>,>>>,>>9.9999")) + CHR(10) + 
                                         "Usu†rio: " + TRIM(movto-estoq.usuario) + (IF AVAIL usuar_mestre THEN (" (" + usuar_mestre.nom_usuario + ")") ELSE "") + CHR(10) + CHR(10) +
                                         "Observaá∆o:" + CHR(10) +
                                         emails-movto.observacao + CHR(10) + CHR(10) + 
                                         "Atenciosamente," + CHR(10) + 
                                         "Equipe TI Sistemas"
                                         .
       
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute in h-utapi019 (input  table tt-envio2, output table tt-erros).
    output close.
    delete procedure h-utapi019.

    if available tt-envio2 then
        delete tt-envio2.    


    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piProgramaOrigemWMS:
    DEFINE INPUT        PARAM p-ind-event  AS CHAR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.  

    IF p-ind-event = "ProgramaOrigemWMS" THEN DO: 

       FIND FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event
              AND tt-epc.cod-parameter = "cod-prog-orig" NO-ERROR.

       IF tt-epc.val-parameter = "prog_especifico"      OR  
          tt-epc.val-parameter = "ESFTP211"             OR 
          tt-epc.val-parameter = "cpapi011" /*Estorno*/ OR 
          tt-epc.val-parameter = "CP0318"   /*Desmont*/ THEN DO:
          CREATE tt-epc.
          ASSIGN tt-epc.cod-event     = p-ind-event
                 tt-epc.cod-parameter = "RetornoEPC".
       END.
    END.
    RETURN 'ok'.
END PROCEDURE.


PROCEDURE pi-transfere-doc-WMS:

   DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

   DEFINE VARIABLE c-depos-origem  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-depos-destino AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-retorno       AS CHARACTER NO-UNDO.
   
   FOR EACH tt-transfere-item: DELETE tt-transfere-item. END.

   FIND ord-prod WHERE ord-prod.nr-ord-prod = int(movto-estoq.nro-docto) NO-LOCK NO-ERROR.

   IF AVAIL ord-prod THEN
   DO: 
       IF ord-prod.it-codigo = movto-estoq.it-codigo THEN LEAVE. //Nao transferir item Pai 

       CREATE tt-transfere-item.
       assign tt-transfere-item.cod-estabel = movto-estoq.cod-estabel
              tt-transfere-item.cod-item    = movto-estoq.it-codigo
              tt-transfere-item.qtd-item    = movto-estoq.quantidade. 
      
       RUN esp/es0018p.p (INPUT "esftp211":U,
                          INPUT 2,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
       
       FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nr-pedido = int(ord-prod.nr-pedido) NO-ERROR.
      
       IF AVAIL ped-venda THEN
       DO: 
           FOR EACH tt-prog-ponto:
               IF entry(1,tt-prog-ponto.conteudo,';') = ord-prod.cod-estabel THEN
                  ASSIGN c-depos-destino = entry(2,tt-prog-ponto.conteudo,';')
                         c-depos-origem  = entry(3,tt-prog-ponto.conteudo,';').
           END.
        
           FOR EACH wm-docto NO-LOCK 
               WHERE wm-docto.cod-estabel = ped-venda.cod-estabel 
                 AND wm-docto.cod-local   = c-depos-destino                 /*deposito de alocaá∆o da ordem CP0319 */
                 AND wm-docto.num-docto   = string(ord-prod.nr-ord-prod)  /*numero da Ordem de Produá∆o*/
                 AND wm-docto.ind-origem-docto = 19:   

               FIND FIRST int-wm-docto EXCLUSIVE-LOCK
                    where int-wm-docto.cod-estabel    = wm-docto.cod-estabel 
                      and int-wm-docto.cod-local      = wm-docto.cod-local   
                      and int-wm-docto.id-docto       = wm-docto.id-docto    
               NO-ERROR.
      
               IF AVAIL int-wm-docto THEN
               DO:
                   IF int-wm-docto.log-atualizado THEN
                   DO:
                      RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
      
                      RUN pi-inicializar IN h-acomp (INPUT "Transferindo").
                    
                      RUN pi-acompanhar IN h-acomp (INPUT "Fazendo Transferencia").
                    
                      RUN esp/ccp/esccp051.p (INPUT movto-estoq.nro-docto,
                                              INPUT c-depos-origem,  //'WFT',
                                              INPUT c-depos-destino, //'PRO',
                                              INPUT TABLE tt-transfere-item,
                                              OUTPUT c-retorno).

                     
                    
                      RUN pi-acompanhar IN h-acomp (INPUT "Finalizada Transferencia").
                    
                      RUN pi-finalizar in h-acomp. 
      
                      /*
                      IF INDEX(c-retorno,'ERRO') = 0 THEN 
                      DO:
                         MESSAGE 'Transferencia realizada com Sucesso'
                             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

                         //ASSIGN int-wm-docto.log-atualizado = NO.

                      END.*/
                   END.
               END.    
           END.
       end.
   END.

END PROCEDURE.




RETURN "OK":U.
