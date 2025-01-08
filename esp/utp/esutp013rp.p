/*{include/i-prgvrs.i ESUTP013 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP\UTP\ESUTP005RP.P
**  Autor.....: Raphael Paini
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Integra Contabilidade Telefonia
**  VersÆo....: 001 07/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{esp/utp/esutp013tt.i}
{utp/utapi009.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-lig
    FIELD r-reg       AS ROWID
    FIELD cod-usuario LIKE tarifador.cod_usuario
    FIELD valor       LIKE tarifador.valor COLUMN-LABEL "Acumulado".

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHARACTER FORM "x(12)" NO-UNDO.

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

DEFINE STREAM s-cobranca.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF var h-acomp      as handle no-undo.
DEF var h-utapi019      as handle no-undo.

define temp-table tt-envio2
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.



FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

DEFINE VARIABLE c-sistema      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo-relat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-empresa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-versao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-revisao      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-gerou        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-periodo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-periodo     AS DATE        FORMAT "99/99/9999"  NO-UNDO.
DEFINE VARIABLE c-dir-nome-arq AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuario      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.


ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Gera cobran‡a tarifador - Comunica‡äes"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP013"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    
    ASSIGN c-arquivo = "C:\temp\ESUTP013.txt".

    OUTPUT TO VALUE(c-arquivo).
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    ASSIGN l-gerou   = NO
           c-periodo = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99").

    RUN pi-carrega-dados.
    RUN pi-relatorio.
    OUTPUT CLOSE.
    
    IF tt-param.execucao = 1 THEN DO:
        MESSAGE "Simula‡Æo conclu¡da com sucesso!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        IF tt-param.execucao = 2 THEN DO:
            FOR EACH tarifador 
               WHERE tarifador.avaliado   
                 AND tarifador.finalidade = NO  /*Servico*/
                 AND tarifador.cobrado    = NO  /*NÆo cobradas*/
                 AND tarifador.cod_usuario <> "" : 
                ASSIGN tarifador.periodo-cobranca = c-periodo
                       tarifador.cobrado          = YES.
            END.
        END.

        /*Envia por email arquivo de integra‡Æo*/
        IF l-gerou = YES OR l-gerou = NO THEN DO:
            RUN pi-envia-email.    
        END.

        MESSAGE "Integra‡Æo gerada com sucesso, foi enviado email ao RH."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    RUN pi-finalizar in h-acomp.
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    DEFINE VARIABLE l-nao-atingiu AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-valor      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total      AS DECIMAL     NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    FOR EACH tt-lig:
        DELETE tt-lig.
    END.


    /*Caso tenha algum avaliado e particular com usuario zerado, volta ele para o tarifador*/
    FOR EACH tarifador 
       WHERE tarifador.finalidade
         AND tarifador.avaliado
         AND NOT tarifador.cobrado
         AND tarifador.cod_usuario = "":
        
        ASSIGN tarifador.finalidade = NOT tarifador.finalidade
               tarifador.avaliado   = NOT tarifador.avaliado.
    END.

    ASSIGN l-nao-atingiu = NO
           de-valor = 0
           de-total = 0.

    FOR EACH tarifador 
       WHERE tarifador.finalidade
         AND tarifador.avaliado
         AND NOT tarifador.cobrado
       BREAK BY tarifador.cod_usuario
             BY tarifador.data 
             BY tarifador.hora:
       IF FIRST-OF(tarifador.cod_usuario) THEN
           ASSIGN de-valor = 0.

       ASSIGN de-valor = de-valor + tarifador.valor.
       CREATE tt-lig.
       ASSIGN tt-lig.r-reg = ROWID(tarifador)
              tt-lig.cod-usuario = tarifador.cod_usuario
              tt-lig.valor = de-valor.

       IF LAST-OF(tarifador.cod_usuario) THEN DO:
           IF de-valor  < 7 THEN DO:
               ASSIGN de-total = de-total + de-valor.
               IF NOT l-nao-atingiu THEN DO:
                   ASSIGN l-nao-atingiu = YES.
                   PUT UNFORMATTED
                       "NAO ATINGIRAM: " SKIP(1)
                       "Usuario                           Valor" AT 01
                       "------------------------------ --------" AT 01 SKIP.
               END.

               FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = tarifador.cod_usuario NO-ERROR.
               IF AVAIL usuar_mestre THEN
                   ASSIGN c-usuario = TRIM(STRING(usuar_mestre.cod_usuario)) + " - " + TRIM(usuar_mestre.nom_usuario).
               ELSE
                   ASSIGN c-usuario = TRIM(STRING(tarifador.cod_usuario)).

               PUT UNFORMATTED
                   c-usuario FORMAT "x(30)" AT 01
                   de-valor  FORMAT "9.99"  TO 39 SKIP.

               FOR EACH tt-lig
                   WHERE tt-lig.cod-usuario = tarifador.cod_usuario:
                   DELETE tt-lig.
               END.
           END.
       END.
    END.

    IF l-nao-atingiu THEN
        PUT UNFORMATTED 
            "--------" TO 39
            "TOTAL"    TO 30
            de-total FORMAT ">,>>9.99" TO 39
            SKIP(2).

END PROCEDURE.

PROCEDURE pi-relatorio:
    DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-imprime-geral AS LOGICAL     NO-UNDO.
    
    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").
    ASSIGN dt-periodo     = DATE(MONTH(TODAY),01,YEAR(TODAY))
           c-dir-nome-arq = SESSION:TEMP-DIRECTORY + "cobranca" + c-periodo + ".txt".

    PUT UNFORMATTED
        "SERAO COBRADOS: " SKIP(1).

    ASSIGN de-valor = 0
           de-total = 0
           l-imprime-geral = NO.

    OUTPUT STREAM s-cobranca TO VALUE(c-dir-nome-arq).
    PUT UNFORMATTED
        SKIP
        "Usuario                                Valor" AT 01
        "------------------------------ -------------" AT 01 SKIP.

    FOR EACH tt-lig
        BREAK BY tt-lig.cod-usuario:
        IF FIRST-OF(tt-lig.cod-usuario) THEN DO:
            ASSIGN de-valor = 0.
            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = tt-lig.cod-usuario NO-ERROR.
            IF AVAIL usuar_mestre THEN
                ASSIGN c-usuario = TRIM(STRING(usuar_mestre.cod_usuario)) + " - " + TRIM(usuar_mestre.nom_usuario).
            ELSE
                ASSIGN c-usuario = TRIM(STRING(tt-lig.cod-usuario)).

            PUT UNFORMATTED 
                 c-usuario FORMAT "x(30)" AT 01.
        END.

        FIND FIRST tarifador EXCLUSIVE-LOCK
             WHERE ROWID(tarifador) = tt-lig.r-reg.
        IF AVAIL tarifador THEN DO:
            ASSIGN de-valor = de-valor + tarifador.valor.

            /*Atualiza valores para integra‡Æo*/
            IF tt-param.execucao = 2 THEN DO:
                ASSIGN tarifador.cobrado = yes
                       tarifador.periodo-cobranca = c-periodo
                       l-gerou = YES.
            END.
        END.

        IF LAST-OF(tt-lig.cod-usuario) THEN DO:
            ASSIGN de-total = de-total + de-valor.
            PUT UNFORMATTED
                 de-valor  FORMAT "->,>>>,>>9.99" TO 44 SKIP.  

            PUT STREAM s-cobranca UNFORMATTED
                tt-lig.cod-usuario ";"
                dt-periodo FORMAT "99/99/9999"   ";"
                TRIM(STRING(de-valor,">>>>>>>>9.99")) ";" SKIP.

            ASSIGN de-valor = 0
                   l-imprime-geral = YES.
        END.
    END.

    IF l-imprime-geral THEN
        PUT UNFORMATTED 
            "-------------" TO 44
            "TOTAL" AT 25
            de-total FORMAT "->,>>>,>>9.99" TO 44 SKIP(1).

    OUTPUT STREAM s-cobranca CLOSE.
END PROCEDURE.

PROCEDURE pi-envia-email:
    DEFINE VARIABLE c-email-destino AS CHARACTER   NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Enviando Email...").

    RUN esp/es0018p.p (INPUT "esutp013rp", /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    ASSIGN c-email-destino = "".
    FOR EACH tt-prog-ponto NO-LOCK
       WHERE tt-prog-ponto.nome-programa = "esutp013rp"   
         AND tt-prog-ponto.ponto         = 1
         AND tt-prog-ponto.conteudo     <> "":
        
        IF c-email-destino = "" THEN
            ASSIGN c-email-destino = TRIM(tt-prog-ponto.conteudo).
        ELSE
            ASSIGN c-email-destino = c-email-destino + ";" + TRIM(tt-prog-ponto.conteudo).

    END.
    
        
    IF c-email-destino <> "" THEN DO:
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
        FOR EACH tt-envio.
            DELETE tt-envio.
        END.
        FOR EACH tt-mensagem.
            DELETE tt-mensagem.
        END.
        
        create tt-envio2.
        assign tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */
               tt-envio2.destino           = c-email-destino
               tt-envio2.remetente         = "ems@intelbras.com.br"
               tt-envio2.assunto           = "Relat¢rio Tarifador - Per¡odo " + c-periodo
               tt-envio2.arq-anexo         = c-arquivo + "," + c-dir-nome-arq.
               tt-envio2.formato           = "TEXTO".
         
         CREATE tt-mensagem.
         ASSIGN tt-mensagem.seq-mensagem = 1
                tt-mensagem.mensagem     = "Segue anexo relat¢rio das cobran‡as do tarifador no per¡odo: " + c-periodo + " e o arquivo para importa‡Æo na folha de pagamento." + CHR(13).

         RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                        INPUT  TABLE tt-mensagem,
                                        OUTPUT TABLE tt-erros).
         
         FIND FIRST tt-erros NO-LOCK NO-ERROR.
         IF AVAIL tt-erros 
         THEN DO:
              OUTPUT TO erros-ava.LOG APPEND.

              FOR EACH tt-erros:
                  DISP tt-erros.cod-erro
                       tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
              END.
              OUTPUT CLOSE.
         END.

         IF VALID-HANDLE(h-utapi019) THEN 
             DELETE PROCEDURE h-utapi019.

       
        
    END. /*IF c-email-destino <> "" THEN DO:*/

END PROCEDURE.
