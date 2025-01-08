/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp9007rp.p
**  Autor.....: Rubia Oliveira - Sensus 
**  Data......: Junho/2014
**  Descricao.: Integraá∆o Notas ASTEC x CRM
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.
DEFINE BUFFER b-emitente FOR emitente.
{include/i-prgvrs.i esftp9007rp 1.11.00.001}


/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
{include/tt-edit.i}
{utp/utapi019.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{esp/es0006a.i}
{esp/es0006.i}  
{esp/es0018.i}

{method/dbotterr.i}

DEFINE VARIABLE c-arquivo-astec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco-astec    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email-astec       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-assunto-astec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo-astec      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-escrm001api       AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-retorno-astec     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mail-nfe          AS CHARACTER   NO-UNDO.
/*---------------------------  Temp-Tables  ---------------------------*/

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer

    field serie-ini          like nota-fiscal.serie 
    field cod-estabel-ini    like nota-fiscal.cod-estabel 
    field dt-emis-nota-ini   like nota-fiscal.dt-emis-nota 
    field nr-nota-fis-ini    like nota-fiscal.nr-nota-fis   
    field nr-pedcli-ini      like nota-fiscal.nr-pedcli
    field serie-fim          like nota-fiscal.serie       
    field cod-estabel-fim    like nota-fiscal.cod-estabel 
    field dt-emis-nota-fim   like nota-fiscal.dt-emis-nota
    field nr-nota-fis-fim    like nota-fiscal.nr-nota-fis 
    field nr-pedcli-fim      like nota-fiscal.nr-pedcli       
    field i-execucao         as integer.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita         AS RAW.

DEF TEMP-TABLE  tt-nf-astec NO-UNDO
    FIELD cgc             LIKE nota-fiscal.cgc
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis
    FIELD serie           LIKE nota-fiscal.serie
    FIELD it-codigo       LIKE it-nota-fisc.it-codigo                  
    FIELD nr-os           LIKE int-ped-item-astec.nr-os
    FIELD guid-os         LIKE int-ped-item-astec.vl-guid-os
    FIELD qt-faturada     AS DEC
    FIELD vl-preuni       LIKE it-nota-fisc.vl-preuni      
    FIELD aliquota-ipi    LIKE it-nota-fisc.aliquota-ipi   
    FIELD vl-ipi-it       LIKE it-nota-fisc.vl-ipi-it      
    FIELD vl-icms-it      LIKE it-nota-fisc.vl-icms-it     
    FIELD vl-bicms-it     LIKE it-nota-fisc.vl-bicms-it    
    FIELD it-substituto   LIKE it-nota-fisc.it-codigo
    FIELD qtd-substituida AS DEC
    FIELD cod-estabel     LIKE it-nota-fisc.cod-estabel 
    FIELD dt-emis-nota    LIKE nota-fiscal.dt-emis-nota
    FIELD nr-conhec       LIKE int-nota-conhec.nr-conhec.
 
/* FORM tt-pedido-astec.nr-pedcli                                        */
/*      tt-pedido-astec.nr-nota-fis                                      */
/*      tt-pedido-astec.serie                                            */
/*      tt-pedido-astec.nr-volumes                                       */
/*      tt-pedido-astec.nome-transp                                      */
/* WITH FRAME f-detalhe-astec WIDTH 132 64 DOWN STREAM-IO NO-ATTR-SPACE. */

/*---------------------------  ParÉmetros   ---------------------------*/


/* Transfer Definitions */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.


/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Integraá∆o Notas ASTEC x CRM"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP9007"
       c-versao       = "1.11"
       c-revisao      = "00.001".

{include/i-rpcab.i}

/*---------------------------  Main Block   ---------------------------*/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo...").

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/**********************/
FIND FIRST tt-param NO-LOCK NO-ERROR.
IF AVAIL tt-param THEN DO:
    

    IF tt-param.i-execucao = 1 THEN DO:

        

        FOR EACH   nota-fiscal 
            WHERE (nota-fiscal.dt-emis-nota >= tt-param.dt-emis-nota-ini 
              AND  nota-fiscal.dt-emis-nota <= tt-param.dt-emis-nota-fim)  EXCLUSIVE-LOCK:



                run pi-acompanhar in h-acomp (input "Estab: " + nota-fiscal.cod-estabel + " Notas: " + nota-fiscal.nr-nota-fis).
    
                IF (nota-fiscal.cod-estabel < tt-param.cod-estabel-ini 
                OR  nota-fiscal.cod-estabel > tt-param.cod-estabel-fim) THEN NEXT.
    
                IF (nota-fiscal.serie       < tt-param.serie-ini       
                OR  nota-fiscal.serie       > tt-param.serie-fim      ) THEN NEXT.
    
                IF (nota-fiscal.nr-nota-fis < tt-param.nr-nota-fis-ini 
                OR  nota-fiscal.nr-nota-fis > tt-param.nr-nota-fis-fim) THEN NEXT.
    
                IF (nota-fiscal.nr-pedcli   < tt-param.nr-pedcli-ini
                OR  nota-fiscal.nr-pedcli   > tt-param.nr-pedcli-fim) THEN NEXT.
                
    
                RUN pi-gera-Email-ASTEC.


    
        END. /* FOR EACH   nota-fiscal  */

    END. /* IF tt-param.i-execucao = 1 THEN DO: */
    ELSE DO:

        FOR EACH  nota-fiscal 
            WHERE nota-fiscal.dt-emis-nota >= TODAY - 7 EXCLUSIVE-LOCK:


                run pi-acompanhar in h-acomp (input "Estab: " + nota-fiscal.cod-estabel + " Notas: " + nota-fiscal.nr-nota-fis).
    
                IF (nota-fiscal.cod-estabel < tt-param.cod-estabel-ini 
                OR  nota-fiscal.cod-estabel > tt-param.cod-estabel-fim) THEN NEXT.
    
                IF (nota-fiscal.serie       < tt-param.serie-ini       
                OR  nota-fiscal.serie       > tt-param.serie-fim      ) THEN NEXT.
    
                IF (nota-fiscal.nr-nota-fis < tt-param.nr-nota-fis-ini 
                OR  nota-fiscal.nr-nota-fis > tt-param.nr-nota-fis-fim) THEN NEXT.
    
                IF (nota-fiscal.nr-pedcli   < tt-param.nr-pedcli-ini
                OR  nota-fiscal.nr-pedcli   > tt-param.nr-pedcli-fim) THEN NEXT.
    
                RUN pi-gera-Email-ASTEC.

            
    
        END. /* FOR EACH   nota-fiscal  */

    END. /* IF tt-param.i-execucao = 2 THEN DO: */

END. /* IF AVAIL tt-param THEN DO: */

run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".

/*-----------------------  Internal Procedures  -----------------------*/
{include/pi-edit.i}

/**********************************/
PROCEDURE pi-gera-Email-ASTEC:
    DEFINE VARIABLE l-gera-mail     AS LOGICAL     NO-UNDO.

/*     PUT 'pi-gera-Email-ASTEC ' SKIP. */

    FIND ped-venda
        WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli 
          AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
        NO-LOCK NO-ERROR.

    IF AVAIL ped-venda AND
         (INDEX(ped-venda.observacoes,"Extrato:")         <> 0  OR
          INDEX(ped-venda.cond-espec,"Extrato:")          <> 0  OR
          INDEX(ped-venda.cond-espec,"pecas em garantia") <> 0) THEN DO:
        RUN atualizaPortalAstec.
    END.

    IF AVAIL ped-venda AND NOT ped-venda.nat-operacao BEGINS "7" THEN DO:
    
        RUN esp/es0018p.p (INPUT "ESFTP9007",
                           INPUT 1,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).
        IF NOT CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = ped-venda.tp-pedido) THEN NEXT.

        IF ped-venda.nr-pedcli <> nota-fiscal.nr-pedcli THEN NEXT.

        ASSIGN l-gera-mail = NO.
        assign c-arquivo-astec = session:temp-directory + "/esftp9007.html".
               c-titulo-astec = "Pedido: " + string(ped-venda.nr-pedido).

        output to value(c-arquivo-astec) CONVERT TARGET SESSION:CHARSET.
        RUN pi-gera-html.
        run html-ini-tab.
        FOR EACH ped-item OF ped-venda NO-LOCK,
            FIRST item WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK:
            FIND it-nota-fisc OF nota-fiscal 
                         WHERE it-nota-fisc.it-codigo  = ped-item.it-codigo
                           AND it-nota-fisc.nr-seq-ped = ped-item.nr-sequencia 
                         NO-LOCK NO-ERROR.

            IF ped-item.cod-sit-item = 6 THEN DO:
               ASSIGN l-gera-mail = YES.

               run html-ini-lin-tab.
               run html-con-tab (ped-item.it-codigo,"left").
               run html-con-tab (item.desc-item,"left").
               IF AVAIL it-nota-fisc  THEN DO:
                   run html-con-tab (string(it-nota-fisc.qt-faturada[1]),"left").
                   run html-con-tab (string(it-nota-fisc.vl-preuni,">>,>>9.99"),"left").

               END.
               ELSE DO:
                   run html-con-tab ("","left").
                   run html-con-tab ("","left").
               END.

               run html-con-tab (ped-item.desc-cancela,"left").
               run html-fim-lin-tab.

            END. /* IF ped-item.cod-sit-item = 6 THEN DO: */
            ELSE DO:

                IF ped-item.cod-sit-item = 2 OR 
                   ped-item.cod-sit-item = 1 THEN DO:
                    ASSIGN l-gera-mail = YES.

                    run html-ini-lin-tab.
                    run html-con-tab (ped-item.it-codigo,"left").
                    run html-con-tab (item.desc-item,"left").
                    IF AVAIL it-nota-fisc  THEN DO:
                        run html-con-tab (string(it-nota-fisc.qt-faturada[1]),"left").
                        run html-con-tab (string(it-nota-fisc.vl-preuni,">>,>>9.99"),"left").
                    END.
                    ELSE DO:
                        run html-con-tab ("","left").
                        run html-con-tab ("","left").
                    END.

                    run html-con-tab ("Item Atendido Parcialmente, motivo falta tempor†ria de estoque, ser† atendido posteriormente","left").
                    run html-fim-lin-tab.

                END. /* IF ped-item.cod-sit-item = 2 OR ped-item.cod-sit-item = 1 THEN DO: */
                ELSE DO:
                    IF ped-item.cod-sit-item = 3 THEN DO:
                        ASSIGN l-gera-mail = YES.
                        run html-ini-lin-tab.
                        run html-con-tab (ped-item.it-codigo,"left").
                        run html-con-tab (item.desc-item,"left").
                        IF AVAIL it-nota-fisc  THEN DO:
                           run html-con-tab (string(it-nota-fisc.qt-faturada[1]),"left").
                           run html-con-tab (string(it-nota-fisc.vl-preuni,">>,>>9.99"),"left").
                        END.
                        ELSE DO:
                            run html-con-tab ("","left").
                            run html-con-tab ("","left").
                        END.
                        run html-con-tab ("Item Atendido Total","left").
                        run html-fim-lin-tab.

                    END.

                END. /* IF ped-item.cod-sit-item <> 2 AND ped-item.cod-sit-item <> 1 THEN DO: */

            END. /* IF ped-item.cod-sit-item <> 6 THEN DO: */

        END. /* FOR EACH ped-item OF ped-venda NO-LOCK, */

        run html-fim-tab.
        run html-fim.
        OUTPUT CLOSE.

        IF l-gera-mail = YES THEN DO:
            FIND emitente
                 WHERE emitente.cod-emitente = ped-venda.cod-emitente
                NO-LOCK NO-ERROR.
            FIND atendente
                WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                NO-LOCK NO-ERROR.
            IF  AVAIL atendente 
            AND (    int(ped-venda.tp-pedido) <> 9
                 AND int(ped-venda.tp-pedido) <> 90
                 AND int(ped-venda.tp-pedido) <> 70
                 AND int(ped-venda.tp-pedido) <> 71
                 AND int(ped-venda.tp-pedido) <> 58
                 ) THEN
                ASSIGN c-email-astec = "," + atendente.email.
            ELSE
                ASSIGN c-email-astec = "".

            RUN pi-busca-contato-nfe (OUTPUT c-mail-nfe).

            RUN pi-envia-email-ASTEC (INPUT "ems@intelbras.com.br",
                                      INPUT c-mail-nfe + c-email-astec,
                                      INPUT "Ref. Pedido: " + ped-venda.nr-pedcli + " Atendido ",
                                      INPUT "",
                                      INPUT c-arquivo-astec).
        END. /* IF l-gera-mail = YES THEN DO: */

    END. /* IF AVAIL ped-venda AND */



    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-envia-email-ASTEC:
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-mail:

        FOR EACH tt-envio2.   DELETE tt-envio2.   END.
        FOR EACH tt-mensagem. DELETE tt-mensagem. END.

        ASSIGN c-lst-arq  = tt-mail.arquivo. 

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
               tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
               tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
               tt-envio2.arq-anexo         =  tt-mail.Arquivo         /* Arquivo Tempor†rio */
               tt-envio2.formato           = "TEXTO".
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */


        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN
           OUTPUT TO erros-comerc.LOG APPEND.
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END.
    DELETE PROCEDURE h-utapi019.

END PROCEDURE.

PROCEDURE atualizaPortalAstec :

    EMPTY TEMP-TABLE tt-nf-astec.
    IF CAN-FIND(FIRST int-ped-item-astec NO-LOCK
                WHERE int-ped-item-astec.cod-estabel  = nota-fiscal.cod-estabel
                  AND int-ped-item-astec.serie        = nota-fiscal.serie
                  AND int-ped-item-astec.nr-nota-fis  = nota-fiscal.nr-nota-fis) THEN DO:
    
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
    
    /*         PUT it-nota-fisc SKIP. */
    
            IF CAN-FIND(FIRST int-ped-item-astec NO-LOCK
                        WHERE int-ped-item-astec.cod-estabel  = nota-fiscal.cod-estabel
                          AND int-ped-item-astec.serie        = nota-fiscal.serie
                          AND int-ped-item-astec.nr-nota-fis  = nota-fiscal.nr-nota-fis
                          AND int-ped-item-astec.nr-sequencia = it-nota-fisc.nr-seq-ped
                          AND int-ped-item-astec.it-codigo    = it-nota-fisc.it-codigo) THEN DO:
    
                FOR EACH int-ped-item-astec NO-LOCK
                    WHERE int-ped-item-astec.cod-estabel  = nota-fiscal.cod-estabel
                      AND int-ped-item-astec.serie        = nota-fiscal.serie
                      AND int-ped-item-astec.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND int-ped-item-astec.nr-sequencia = it-nota-fisc.nr-seq-ped
                      AND int-ped-item-astec.it-codigo    = it-nota-fisc.it-codigo:
    
                    IF int-ped-item-astec.dat-livre-4 <> ? THEN NEXT.
    
    /*                 PUT int-ped-item-astec.cod-estabel  */
    /*                     int-ped-item-astec.serie        */
    /*                     int-ped-item-astec.nr-nota-fis  */
    /*                     int-ped-item-astec.nr-sequencia */
    /*                     int-ped-item-astec.it-codigo    */
    /*                     SKIP.                           */
    /*                                                     */
                    CREATE tt-nf-astec.
                    ASSIGN tt-nf-astec.cgc         = nota-fiscal.cgc
                           tt-nf-astec.nr-nota-fis = nota-fiscal.nr-nota-fis
                           tt-nf-astec.serie       = SUBSTRING(nota-fiscal.serie, 1, 1)
                           tt-nf-astec.it-codigo   = it-nota-fisc.it-codigo
                           tt-nf-astec.nr-os       = TRIM(int-ped-item-astec.nr-os)
                           tt-nf-astec.guid-os     = TRIM(int-ped-item-astec.vl-guid-os).
    
                    ASSIGN tt-nf-astec.qt-faturada  = int-ped-item-astec.qt-alocada
                           tt-nf-astec.vl-preuni    = it-nota-fisc.vl-preuni
                           tt-nf-astec.aliquota-ipi = it-nota-fisc.aliquota-ipi
                           tt-nf-astec.vl-ipi-it    = tt-nf-astec.qt-faturada * it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[2]
                           tt-nf-astec.vl-icms-it   = tt-nf-astec.qt-faturada * it-nota-fisc.vl-icms-it / it-nota-fisc.qt-faturada[2]
                           tt-nf-astec.vl-bicms-it  = tt-nf-astec.qt-faturada * it-nota-fisc.vl-bicms-it  / it-nota-fisc.qt-faturada[2].
    
                    FIND FIRST ped-item
                        WHERE ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli
                          AND ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli
                          AND ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped
                          AND ped-item.it-codigo    = it-nota-fisc.it-codigo
                          AND ped-item.cod-refer    = it-nota-fisc.cod-refer NO-LOCK NO-ERROR.
    
                    IF AVAILABLE ped-item                                                     AND
                       INDEX(ped-item.observacao, "Espdp054 - Substituicao do Item: ":U) <> 0 THEN
                        ASSIGN tt-nf-astec.it-substituto   =         ENTRY(1, TRIM(SUBSTRING(ped-item.observacao, INDEX(ped-item.observacao, "Espdp054 - Substituicao do Item: ":U) + 33, LENGTH(ped-item.observacao))), ",":U)
                               tt-nf-astec.qtd-substituida = DECIMAL(ENTRY(2, TRIM(SUBSTRING(ped-item.observacao, INDEX(ped-item.observacao, "Espdp054 - Substituicao do Item: ":U) + 33, LENGTH(ped-item.observacao))), ",":U)).
    
                    ASSIGN tt-nf-astec.cod-estabel  = it-nota-fisc.cod-estabel
                           tt-nf-astec.dt-emis-nota = nota-fiscal.dt-emis-nota.
    
                    FIND FIRST int-nota-conhec
                        WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel
                          AND int-nota-conhec.serie       = nota-fiscal.serie
                          AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
    
                    IF AVAILABLE int-nota-conhec THEN
                        ASSIGN tt-nf-astec.nr-conhec = int-nota-conhec.nr-conhec.
                END.
            END.
        END.
    END.

    RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.

/*     PUT '1 integraNFASTEC' SKIP. */

    IF AVAIL tt-nf-astec THEN
        RUN integraNFASTEC IN h-escrm001api (INPUT  TABLE tt-nf-astec,
                                             OUTPUT TABLE rowErrors).
/*     PUT '2 integraNFASTEC' SKIP. */

    DELETE PROCEDURE h-escrm001api.

    IF CAN-FIND(FIRST rowErrors) THEN DO:
        FOR EACH rowErrors:
            PUT rowErrors.errorDescription FORMAT "x(500)":U SKIP.
        END.

        UNDO, LEAVE.
    END. /* IF CAN-FIND(FIRST rowErrors) THEN DO: */
    ELSE DO:

        FOR EACH tt-nf-astec NO-LOCK:
                
            IF  tt-nf-astec.cod-estabel = nota-fiscal.cod-estabel
            AND tt-nf-astec.serie       = nota-fiscal.serie        
            AND tt-nf-astec.nr-nota-fis = nota-fiscal.nr-nota-fis  THEN DO:

                FOR EACH int-ped-item-astec EXCLUSIVE-LOCK
                    WHERE int-ped-item-astec.cod-estabel  = nota-fiscal.cod-estabel
                      AND int-ped-item-astec.serie        = nota-fiscal.serie
                      AND int-ped-item-astec.nr-nota-fis  = nota-fiscal.nr-nota-fis:
                    ASSIGN int-ped-item-astec.dat-livre-4 = TODAY.
                END.

                PUT nota-fiscal.cod-estabel 
                    nota-fiscal.serie       
                    nota-fiscal.nr-nota-fis 
                    tt-nf-astec.it-codigo    SKIP.

            END. /* Integrado x Nota */

        END. /* FOR EACH tt-nf-astec NO-LOCK: */

    END. /* IF NOT CAN-FIND(FIRST rowErrors) THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gera-html:

    def var c-nr-pedido        as char format "x(1000)" no-undo.
    def var c-tit-ped          as char format "x(100)" no-undo.
    def var c-dados-empresa    as char format "x(300)" no-undo.
    def var c-dados-cliente    as char format "x(400)" no-undo.
    def var c-total            AS char format "x(400)" no-undo.
    def var c-imagem           as char format "x(120)" no-undo.    
    DEFINE VARIABLE c-data          AS CHARACTER   NO-UNDO.
    
    run html-inicio ("Situaá∆o do Pedido").

    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    find emitente where
         emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

    assign c-data      = string(day(ped-venda.dt-emissao),"99") 
                       + "/"
                       + string(month(ped-venda.dt-emissao),"99")
                       + "/"
                       + string(year(ped-venda.dt-emissao), "9999")
           c-nr-pedido = CHR(10) 
                       + "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(ped-venda.nr-pedido, ">>>>,>>9")
                       + " - "
                       + c-data
                       + trim(string("")) + "<BR>" 
                       + "<B> Nr.NF..: </B>" + nota-fiscal.nr-nota-fis
                       + trim(string("")) + "<BR>" 
                       + "<B> Emissao..: </B>" + STRING(nota-fiscal.dt-emis-nota)
                       + trim(string("")) + "<BR>" 
                       + "<B> Transportadora: </B>" + nota-fiscal.nome-transp
                       + "</FONT> </TH>"                       
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + "<B>Endereáo:</B> " + estabelec.endereco + " - " + estabelec.bairro + "<BR>"
                           + "<B>Cidade:</B> " + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"                          
                           + "<B>Fone:</B> "
                           + emitente.telefone[1]
                           + "<BR>"
                           + "<B>Home:</B> " + emitente.home-page
                           + "<BR>"                          
                           + "<B>CNPJ:</B> " + trim(string(estabelec.cgc)) + "<BR>"
                           + "<B>I.Estadual:</B> " + trim(string(estabelec.ins-estadual))
                           + "<BR>" .                             
   
   FIND emitente
        WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

   ASSIGN c-dados-cliente =  "<B>Cliente:</B> " + string(emitente.cod-emitente) + " - " + emitente.nome-abrev + "</B>"
                              + "<BR>"                              
                              + "<B>Raz∆o Social:</B> " + trim(emitente.nome-emit)  
                              + "<BR>"
                              + "<B>Endereáo:</B> " + emitente.endereco + " - " + emitente.bairro
                              + "<BR>"
                              + "<B>Cidade:</B> " + emitente.cidade + " - " + emitente.estado
                              + "<BR>"
                              + "<B>Fone:</B> " + emitente.telefone[1] + "  -  " + "<B>Fax:</B> " + emitente.telefax
                              + "<BR>"
                              + "<B>CNPJ:</B> " + emitente.cgc 
                              + "<BR>"                              
                              
           
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Itens de Pedido Atendidos"
                            + "</FONT>".
    if estabelec.cod-estabel = "301" OR
       estabelec.cod-estabel = "103" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Maxcom </FONT> </TH>". 
    if estabelec.cod-estabel = "101" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras - Matriz </FONT> </TH>". 
    if estabelec.cod-estabel = "102" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 
    if estabelec.cod-estabel = "104" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 
    


    run html-ini-tab.
    
    run html-ini-lin-tab.
    put c-imagem skip.

    run html-cab-tab(c-tit-ped).
    
    put c-nr-pedido skip . 
    
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.    
    
    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
    
    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"  trim(c-dados-cliente) format "x(400)" "</TD>" skip. 
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.    
        
    ASSIGN c-total = "<B>Total Nota Fiscal:</B> " + STRING(nota-fiscal.vl-tot-nota,">>>,>>>,>>9.99") .

    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"
         trim(c-total) FORMAT "x(40)"  "</TD>" skip. 

    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">" ped-venda.observacoes "</TD>" skip. 

    run html-fim-lin-tab.
    run html-fim-tab.

END PROCEDURE.



/**********************************/

PROCEDURE pi-busca-contato-nfe:
   DEFINE OUTPUT PARAMETER c-email-contato AS CHARACTER   NO-UNDO.

   FIND FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.

   IF  AVAIL natur-oper 
   AND natur-oper.tipo = 2 THEN DO:
        IF CAN-FIND(FIRST cont-emit NO-LOCK
                    WHERE cont-emit.cod-emitente = ped-venda.cod-emitente 
                     AND (cont-emit.nome BEGINS 'NFE' 
                       OR cont-emit.nome BEGINS 'NF-e')) THEN DO:

           ASSIGN c-email-contato = "".
           FOR EACH cont-emit NO-LOCK
              WHERE cont-emit.cod-emitente = ped-venda.cod-emitente 
                AND (cont-emit.nome BEGINS 'NFE'
                 OR cont-emit.nome  BEGINS 'NF-e'):

               IF c-email-contato = "" THEN
                   ASSIGN c-email-contato = trim(cont-emit.e-mail).
               ELSE
                   IF NOT c-email-contato MATCHES TRIM(cont-emit.e-mail) THEN
                        ASSIGN c-email-contato = TRIM(c-email-contato) + ";" + trim(cont-emit.e-mail).
           END.
        END.
        ELSE DO:
            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
            ASSIGN c-email-contato = b-emitente.e-mail.
        END.
   END.

END PROCEDURE.
