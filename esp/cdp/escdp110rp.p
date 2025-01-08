/***********************************************************************
**  Programa..: esp/cdp/escdp110rp.p
**  Autor.....: Isac Abahao
**  Data......: Marco/2022 - Desenvolvimento
**  Descricao.: Envio de Email Itens Novos
**  Versao....: 001 17/03/2022
**                  Desenvolvimento Programa
************************************************************************/
{utp/utapi019.i}
{esp/es0018.i}

DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-item-csv AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp             AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-integracao-item   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cNom_from           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-email-destino     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-erro              AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG.

DEF TEMP-TABLE tt-email NO-UNDO
    FIELD cod-estabel AS CHAR 
    FIELD email       AS CHAR 
    INDEX idx cod-estabel.

DEF TEMP-TABLE tt-item 
    FIELD it-codigo AS CHAR
    FIELD cod-estabel AS CHAR
    INDEX idx cod-estabel it-codigo.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-item-csv = "escdp110_item_" + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.
    
    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-integracao-item = c-dir-saida + TRIM(c-arquivo-item-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-integracao-item = c-dir-saida + TRIM(c-arquivo-item-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    ASSIGN c-email-destino = ''.

    EMPTY TEMP-TABLE tt-prog-ponto.
    EMPTY TEMP-TABLE tt-email.
    EMPTY TEMP-TABLE tt-item.

    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 6,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   
    
    FOR EACH tt-prog-ponto:
        CREATE tt-email.
        ASSIGN tt-email.cod-estabel = ENTRY(1,tt-prog-ponto.conteudo,";")
               tt-email.email       = REPLACE(ENTRY(2, tt-prog-ponto.conteudo,";"),';','').
    END.


    FOR EACH ITEM NO-LOCK
        WHERE ITEM.data-implant = TODAY:

        RUN pi-acompanhar in h-acomp (INPUT "Novos Itens: " + STRING(ITEM.it-codigo)).

        CREATE tt-item.
        ASSIGN tt-item.it-codigo   = ITEM.it-codigo
               tt-item.cod-estabel = ITEM.cod-estabel.
    END.

    OUTPUT STREAM str-excel TO value(c-integracao-item) NO-CONVERT.
    PUT STREAM str-excel UNFORMATTED  "Estab;E-mail;Resultado" SKIP.

    FOR EACH tt-email:
        RUN pi-acompanhar in h-acomp (INPUT "Envia E-mail: " + STRING(tt-email.email)).
          
        RUN pi-email-item-novo (OUTPUT c-erro).

        IF c-erro = '' THEN
           ASSIGN c-erro = 'Enviado com Sucesso'.

        PUT STREAM str-excel UNFORMATTED tt-email.cod-estabel             ";" 
                                         tt-email.email  FORMAT 'x(100)'  ";"  
                                         c-erro          FORMAT 'x(200)' SKIP.
    END.

    OUTPUT STREAM str-excel CLOSE.

    RUN pi-finalizar IN h-acomp.  
    

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-integracao-item).
    END.

    RETURN "OK".   
END.



PROCEDURE pi-email-item-novo:

    DEF OUTPUT PARAM p-erro AS CHAR NO-UNDO.

    ASSIGN i-cont = 1.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     =  tt-email.email 
           tt-envio2.assunto     = "Novos Itens estabelecimento " + tt-email.cod-estabel
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".                  

    FOR EACH tt-item NO-LOCK 
        WHERE tt-item.cod-estabel = tt-email.cod-estabel,
        FIRST ITEM WHERE item.it-codigo = tt-item.it-codigo NO-LOCK :
    
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = i-cont 
               tt-mensagem.mensagem     = "*******************************************************************" + CHR(13) +
                                          "             Novo Item Cadastrado                                  " + CHR(13) +
                                          "*******************************************************************" + CHR(13) +
                                          "Item: " + item.it-codigo                                             + CHR(13) +
                                          "Descricao: " + item.desc-item                                        + CHR(13) +
                                          "Aliquota IPI: " + string(item.aliquota-ipi)                          + CHR(13) +
                                          "Class Fiscal: " + string(item.class-fiscal)                          + CHR(13) +
                                          "*******************************************************************" + CHR(10).

        ASSIGN i-cont = i-cont + 1.

    END.

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    
    IF AVAIL tt-erros THEN DO:
       FOR EACH tt-erros:
           IF p-erro <> '' THEN
              ASSIGN p-erro = p-erro + '/'.

          ASSIGN p-erro = p-erro + STRING(tt-erros.cod-erro) + ' , ' + tt-erros.desc-erro + tt-erros.desc-arq.
       END. 
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.
