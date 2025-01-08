/********************************************************************************
 ** UPC........: win263.p - UPC WRITE operacao
 ** Data.......: junho / 2010
 ** Objetivo...: Caso houver alteracao na operacao sera enviado e-mail. 
 ********************************************************************************/

{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEF PARAM BUFFER b-operacao     FOR operacao.
DEF PARAM BUFFER b-old-operacao FOR operacao.

define variable v-un-med-tempo-depois as character FORMAT "x(30)" NO-UNDO.
define variable v-un-med-tempo-antes  as character FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE cNom_from      AS CHARACTER INITIAL ''     NO-UNDO.
DEFINE VARIABLE lErro          AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE c-desc-usuar   AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE l-tempo-prepar AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE l-tempo-maquin AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE l-tempo-homem  AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE l-nr-unidades  AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE l-gm-codigo    AS LOGICAL   INITIAL NO     NO-UNDO.
DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2. 
DEFINE VARIABLE plist AS CHARACTER NO-UNDO FORMAT "x(70)".
DEFINE VARIABLE l-teste AS LOGICAL     NO-UNDO.

DEFINE BUFFER b-item FOR ITEM.



IF  b-operacao.tempo-prepar <> b-old-operacao.tempo-prepar OR
    b-operacao.tempo-maquin <> b-old-operacao.tempo-maquin OR 
    b-operacao.tempo-homem  <> b-old-operacao.tempo-homem  OR
    b-operacao.nr-unidades  <> b-old-operacao.nr-unidades  OR
    b-operacao.gm-codigo    <> b-old-operacao.gm-codigo    OR
    (b-operacao.data-termino <> b-old-operacao.data-termino AND
     b-operacao.data-termino = TODAY) THEN DO:

    IF b-operacao.tempo-prepar <> b-old-operacao.tempo-prepar THEN
        ASSIGN l-tempo-prepar = YES.

    IF b-operacao.tempo-maquin <> b-old-operacao.tempo-maquin THEN
        ASSIGN l-tempo-maquin = YES.

    IF b-operacao.tempo-homem  <> b-old-operacao.tempo-homem THEN
        ASSIGN l-tempo-homem = YES.

    IF b-operacao.nr-unidades <> b-old-operacao.nr-unidades THEN
        ASSIGN l-nr-unidades = YES.

    IF b-operacao.gm-codigo   <> b-old-operacao.gm-codigo  THEN
        ASSIGN l-gm-codigo = YES.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
        RUN pi-envia-email.
    
END.

ASSIGN b-operacao.proporcao = 100. /* Fixar propor‡Æo a pedido da Controladoria e Engenharia */
      
PROCEDURE pi-envia-email.

    DEFINE VARIABLE i-horas    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-minutos  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-dir-orig AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dir-dest AS CHARACTER   NO-UNDO.


    ASSIGN i-horas = truncate(TIME / 3600, 0).
    ASSIGN i-minutos = TRUNCATE( (TIME - (i-horas * 3600)) / 60, 0).
    
    FIND FIRST usuar_mestre 
         WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre THEN 
        ASSIGN c-desc-usuar = usuar_mestre.nom_usuario.

    FIND FIRST ITEM WHERE
               ITEM.it-codigo = b-operacao.it-codigo NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "win263", /* Nome do programa */
                       INPUT 2,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-orig = tt-prog-ponto.conteudo + "operacao-alteracoes.csv"
               c-dir-dest = tt-prog-ponto.conteudo + "operacao-alteracoes-apagar.csv".
        OS-COPY VALUE(c-dir-orig) VALUE(c-dir-dest).
    END.

    IF OS-ERROR = 2 THEN DO:

        OUTPUT TO VALUE(c-dir-orig) NO-CONVERT.

        PUT UNFORMATTED
            "Item;Descri‡Æo;Opera‡Æo;Descri‡Æo;Usu rio;Nome;Data;Hora;Tp Prepar Depois;Tp Prepar Antes;Tp Maquin Depois;Tp Maquin Antes;Tp Homem Depois;Tp Homem Antes;UN Med Tempo Depois;UN Med Tempo Antes;Data T‚rmino Depois;Data T‚rmino Antes;Grupo M quina Atual;Grupo M quina Anterior" SKIP.

        OUTPUT CLOSE.


    END.
    ELSE DO:

        OS-DELETE VALUE(c-dir-dest).

    END.

    OUTPUT TO VALUE(c-dir-orig) NO-CONVERT APPEND.

    ASSIGN v-un-med-tempo-depois = {ininc/i02in261.i 04 b-operacao.un-med-tempo}
           v-un-med-tempo-antes  = {ininc/i02in261.i 04 b-old-operacao.un-med-tempo}.

    PUT UNFORMATTED
        b-operacao.it-codigo                                    + ";" +
        item.desc-item                                          + ";" +
        string(b-operacao.op-codigo)                            + ";" + 
        b-operacao.descricao                                    + ";" +
        v_cod_usuar_corren                                      + ";" +
        c-desc-usuar                                            + ";" +
        STRING(TODAY, "99/99/9999")                             + ";" +
        STRING(i-horas, "99") + ":" + STRING(i-minutos, "99")   + ";" +
        STRING(b-operacao.tempo-prepar,">>>9.999")              + ";" +
        STRING(b-old-operacao.tempo-prepar,">>>9.999")          + ";" +
        STRING(b-operacao.tempo-maquin,">>>9.999")              + ";" +
        STRING(b-old-operacao.tempo-maquin,">>>9.999")          + ";" +
        STRING(b-operacao.tempo-homem,">>>9.999")               + ";" +
        STRING(b-old-operacao.tempo-homem,">>>9.999")           + ";" +
        v-un-med-tempo-depois                                   + ";" +
        v-un-med-tempo-antes                                    + ";" +
        STRING(b-operacao.data-termino)                         + ";" +
        STRING(b-old-operacao.data-termino)                     + ";" +
        b-operacao.gm-codigo                                    + ";" +
        b-old-operacao.gm-codigo        
        SKIP.

    OUTPUT CLOSE.

    /**/

    IF l-tempo-prepar OR
       l-tempo-maquin OR
       l-tempo-homem  OR
       l-gm-codigo    OR
       l-nr-unidades THEN DO:

        FIND FIRST param-global NO-LOCK NO-ERROR.

         ASSIGN cNom_from = 'ems@intelbras.com.br'.

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
        FOR EACH tt-envio2:   DELETE tt-envio2.   END.
        FOR EACH tt-mensagem: DELETE tt-mensagem. END.
    
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.exchange    = param-global.log-1 
               tt-envio2.servidor    = param-global.serv-mail
               tt-envio2.porta       = param-global.porta-mail
               tt-envio2.remetente   = cNom_from
               tt-envio2.destino     = ""
               tt-envio2.assunto     = "URGENTE - ALTERA€ÇO DE TEMPO/GRUPO MµQUINA"
               tt-envio2.importancia = 2
               tt-envio2.log-enviada = YES
               tt-envio2.log-lida    = NO
               tt-envio2.acomp       = NO
               tt-envio2.arq-anexo   = ?
               tt-envio2.formato     = "text".

        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "win263", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   
    
        FOR EACH tt-prog-ponto:
           ASSIGN tt-envio2.destino = tt-envio2.destino + ENTRY(1, tt-prog-ponto.conteudo,";") + ";" .
        END.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = "**************************************************"                        + CHR(13) +
                                          "    ALTERA€ÇO DE TEMPO/GRUPO MµQUINA              "                        + CHR(13) +
                                          "**************************************************"                        + CHR(13) +
                                          "Item    :  " + b-operacao.it-codigo + " - " + ITEM.desc-item               + CHR(13) +
                                          "Operacao:  " + STRING(b-operacao.op-codigo) + " - " + b-operacao.descricao + CHR(13)
                                          +
                                          IF l-tempo-prepar THEN
                                          "Tempo Prepara‡Æo --------"                                           + CHR(13) +
                                          "Valor Atual     :"  + STRING(b-operacao.tempo-prepar,">>>9.999")     + CHR(13) +
                                          "Valor Anterior  :"  + STRING(b-old-operacao.tempo-prepar,">>>9.999") + CHR(13)
                                          ELSE "" 

               tt-mensagem.mensagem     = tt-mensagem.mensagem +
                                          IF l-tempo-maquin THEN
                                          "Tempo M quina -----------"                                           + CHR(13) +
                                          "Valor Atual     :"  + STRING(b-operacao.tempo-maquin,">>>9.999")     + CHR(13) +
                                          "Valor Anterior  :"  + STRING(b-old-operacao.tempo-maquin,">>>9.999") + CHR(13)
                                          ELSE "" 

               tt-mensagem.mensagem     = tt-mensagem.mensagem +
                                          IF l-tempo-homem THEN
                                          "Tempo Homem -------------"                                           + CHR(13) +
                                          "Valor Atual     :"  + STRING(b-operacao.tempo-homem,">>>9.999")      + CHR(13) +
                                          "Valor Anterior  :"  + STRING(b-old-operacao.tempo-homem,">>>9.999")  + CHR(13)
                                          ELSE "" 

               tt-mensagem.mensagem     = tt-mensagem.mensagem +
                                          IF l-gm-codigo THEN
                                          "Grupo M quina -------------"                                         + CHR(13) +
                                          "Valor Atual     :"  + " " + STRING(b-operacao.gm-codigo)             + CHR(13) +
                                          "Valor Anterior  :"  + " " + STRING(b-old-operacao.gm-codigo)         + CHR(13) 
                                          ELSE "" 

               tt-mensagem.mensagem     = tt-mensagem.mensagem +
                                          "Usuario: " + v_cod_usuar_corren + " - " + c-desc-usuar               + CHR(13) +
                                          "Data: " + STRING(TODAY, "99/99/9999")                                + CHR(13) +
                                          "Hora: " + STRING(i-horas, "99") + ":" + STRING(i-minutos, "99")      + CHR(13) + 
                                          "**************************************************"                  + CHR(10).
    
    
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2, 
                                       INPUT  TABLE tt-mensagem, 
                                       OUTPUT TABLE tt-erros).
        IF RETURN-VALUE = "NOK" THEN DO:
            IF CAN-FIND (FIRST tt-erros) THEN DO:            
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'ems-operacao.txt') APPEND.
                FOR EACH tt-erros:
                    DISPLAY tt-erros WITH 1 COLUMN WIDTH 300 STREAM-IO.
                END.
                ASSIGN lErro = YES.
                OUTPUT CLOSE.
            END.
        END.
    
        IF VALID-HANDLE(h-utapi019) THEN
           DELETE PROCEDURE h-utapi019.
    
        IF lErro AND NOT SESSION:BATCH-MODE AND i-num-ped-exec-rpw = 0 THEN
           MESSAGE 'Erro no envio de e-mail. Favor verificar o arquivo ' + SESSION:TEMP-DIRECTORY + 'ems-operacao.txt'
                   VIEW-AS ALERT-BOX WARNING TITLE 'Falha no envio de e-mail'.

    END.

END PROCEDURE.
  
