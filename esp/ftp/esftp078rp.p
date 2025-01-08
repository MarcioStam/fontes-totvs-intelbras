/*********************************************************************************
** Programa: esp/ftp/esftp078rp.p
** Vers∆o..: 1.00
** Data....: 28/10/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa de relat¢rio para listagem de Canhotos
*********************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP078RP 2.00.00.001}  /*** 010001 ***/

/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-canhoto       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-transportador AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cliente       AS CHARACTER   NO-UNDO.

DEFINE STREAM s-email.

{include/i-rpvar.i}
{utp/utapi019.i}



/*--- Definiá∆o de Temp-Tables e Buffers ---*/
{esp/ftp/esftp078.i}

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD nome-transp LIKE nota-fiscal.nome-transp
    FIELD cod-estabel LIKE canhoto-nf.cod-estabel
    FIELD serie       LIKE canhoto-nf.serie
    FIELD nr-nota-fis LIKE canhoto-nf.nr-nota-fis
    FIELD nm-dest     LIKE emitente.nome-emit
    FIELD dt-emissao  LIKE nota-fiscal.dt-emis-nota
    INDEX transp      nome-transp.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.




/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Definiá∆o das Frames ---*/
DEFINE FRAME fRecebidos
    c-transportador           COLUMN-LABEL "Transportador" FORMAT "x(22)"
    canhoto-nf.cod-caixa      COLUMN-LABEL "C¢d Caixa"
    canhoto-nf.cod-envelope   COLUMN-LABEL "C¢d Envelope"
    canhoto-nf.cod-estabel    COLUMN-LABEL "Estabelecimento"
    canhoto-nf.serie          COLUMN-LABEL "SÇrie"
    canhoto-nf.nr-nota-fis    COLUMN-LABEL "Nota Fiscal"
    nota-fiscal.dt-emis-nota  COLUMN-LABEL "Dt Emiss∆o"
    c-cliente                 COLUMN-LABEL "Cliente"       FORMAT "x(32)"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fRecebidos.

DEFINE FRAME fNaoRecebidos
    c-transportador           COLUMN-LABEL "Transportador" FORMAT "x(22)"
    nota-fiscal.cod-estabel   COLUMN-LABEL "Estabelecimento"
    nota-fiscal.serie         COLUMN-LABEL "SÇrie"
    nota-fiscal.nr-nota-fis   COLUMN-LABEL "Nota Fiscal"
    nota-fiscal.dt-emis-nota  COLUMN-LABEL "Dt Emiss∆o"
    c-cliente                 COLUMN-LABEL "Cliente"       FORMAT "x(56)"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fNaoRecebidos.

DEFINE FRAME fNaoRecebidosEmail
    tt-dados.cod-estabel      COLUMN-LABEL "Estabelecimento"
    tt-dados.serie            COLUMN-LABEL "Serie"
    tt-dados.nr-nota-fis      COLUMN-LABEL "Nota Fiscal"
    tt-dados.dt-emissao       COLUMN-LABEL "Data Emissao"
    tt-dados.nm-dest          COLUMN-LABEL "Cliente"  FORMAT "x(50)"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fNaoRecebidosEmail.

DEFINE FRAME fParametros
    "Seleá∆o"                 COLON 50 SKIP(1)
    tt-param.cod-transp-ini   COLON 39 LABEL "C¢d Transportador"
    "|< >|":U                 COLON 51
    tt-param.cod-transp-fim   NO-LABEL
    tt-param.cod-caixa-ini    COLON 39 LABEL "C¢d Caixa"
    "|< >|":U                 COLON 51
    tt-param.cod-caixa-fim    NO-LABEL
    tt-param.cod-envelope-ini COLON 39 LABEL "C¢d Envelope"
    "|< >|":U                 COLON 51
    tt-param.cod-envelope-fim NO-LABEL
    tt-param.cod-estabel-ini  COLON 39 LABEL "Estabelecimento"
    "|< >|":U                 COLON 51
    tt-param.cod-estabel-fim  NO-LABEL
    tt-param.serie-ini        COLON 39 LABEL "SÇrie"
    "|< >|":U                 COLON 51
    tt-param.serie-fim        NO-LABEL
    tt-param.nr-nota-fis-ini  COLON 39 LABEL "Nota Fiscal" FORMAT "x(07)"
    "|< >|":U                 COLON 51
    tt-param.nr-nota-fis-fim  NO-LABEL FORMAT "x(07)"
    c-canhoto                 COLON 39 LABEL "Tipo de Canhotos" FORMAT "x(30)"
    tt-param.email-transp     COLON 39 LABEL "Envia e-mail para Transportadoras?" FORMAT "Sim/N∆o"
    SKIP(1)
    "Impress∆o"               COLON 50 SKIP(1)
    c-destino                 COLON 39 LABEL "Destino"
    " - ":U
    tt-param.arquivo          FORMAT "x(40)":U NO-LABEL SKIP
    tt-param.usuario          COLON 39 LABEL "Usu†rio" SKIP(1)
    WITH WIDTH 132 SIDE-LABELS STREAM-IO.


FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa NO-LOCK
    WHERE  empresa.ep-codigo = param-global.empresa-prin NO-ERROR.

ASSIGN c-programa     = "ESFTP078RP":U
       c-versao       = "2.00":U
       c-revisao      = ".00.000":U
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ""
       c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Listagem de Canhotos".

/* Include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}




/*--- Inicializaá∆o das Informaá‰es ---*/
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.




/*--- Processamento Principal ---*/
CASE tt-param.tipo-canhoto:
    WHEN 1 /* Recebidos */ THEN DO:
        RUN pi-canhotos-recebidos IN THIS-PROCEDURE.

        ASSIGN c-canhoto = "Canhotos Recebidos".
    END.
    WHEN 2 /* N∆o Recebidos */ THEN DO:
        RUN pi-canhotos-nao-recebidos IN THIS-PROCEDURE.
        
        IF  tt-param.email-transp THEN
            RUN pi-envia-email IN THIS-PROCEDURE.

        ASSIGN c-canhoto = "Canhotos N∆o Recebidos".
    END.
    WHEN 3 /* Ambos */ THEN DO:
        RUN pi-canhotos-recebidos     IN THIS-PROCEDURE.
        RUN pi-canhotos-nao-recebidos IN THIS-PROCEDURE.

        ASSIGN c-canhoto = "Ambos".
    END.
END CASE.




/*--- Impress∆o da P†gina de ParÉmetros ---*/
IF  PAGE-NUMBER > 0 THEN
    PAGE.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DISPLAY SKIP(1)
        tt-param.cod-transp-ini
        tt-param.cod-transp-fim
        tt-param.cod-caixa-ini
        tt-param.cod-caixa-fim
        tt-param.cod-envelope-ini
        tt-param.cod-envelope-fim
        tt-param.cod-estabel-ini
        tt-param.cod-estabel-fim
        tt-param.serie-fim
        tt-param.nr-nota-fis-ini
        tt-param.nr-nota-fis-fim
        c-canhoto
        tt-param.email-transp
        c-destino
        tt-param.arquivo
        tt-param.usuario
    WITH FRAME fParametros.




/*--- Finalizaá∆o das Informaá‰es ---*/
{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.




/*--- Procedures Internas ---*/
PROCEDURE pi-canhotos-recebidos:
    RUN pi-inicializar IN h-acomp (INPUT "Canhotos Recebidos").

    PUT UNFORMATTED SKIP(1) "**** Canhotos Recebidos ****" SKIP.

    FOR EACH  canhoto-nf NO-LOCK
        WHERE canhoto-nf.cod-transp   >= tt-param.cod-transp-ini
        AND   canhoto-nf.cod-transp   <= tt-param.cod-transp-fim
        AND   canhoto-nf.cod-caixa    >= tt-param.cod-caixa-ini
        AND   canhoto-nf.cod-caixa    <= tt-param.cod-caixa-fim
        AND   canhoto-nf.cod-envelope >= tt-param.cod-envelope-ini
        AND   canhoto-nf.cod-envelope <= tt-param.cod-envelope-fim
        AND   canhoto-nf.cod-estabel  >= tt-param.cod-estabel-ini
        AND   canhoto-nf.cod-estabel  <= tt-param.cod-estabel-fim
        AND   canhoto-nf.serie        >= tt-param.serie-ini
        AND   canhoto-nf.serie        <= tt-param.serie-fim
        AND   canhoto-nf.nr-nota-fis  >= tt-param.nr-nota-fis-ini
        AND   canhoto-nf.nr-nota-fis  <= tt-param.nr-nota-fis-fim,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = canhoto-nf.cod-estabel
        AND   nota-fiscal.serie       = canhoto-nf.serie
        AND   nota-fiscal.nr-nota-fis = canhoto-nf.nr-nota-fis
        BREAK BY canhoto-nf.cod-transp
              BY canhoto-nf.cod-caixa
              BY canhoto-nf.cod-envelope:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(canhoto-nf.cod-transp) + "/" + canhoto-nf.cod-caixa + "/" + canhoto-nf.cod-envelope).

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
        ASSIGN c-cliente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

        IF  FIRST-OF(canhoto-nf.cod-transp)   OR
            FIRST-OF(canhoto-nf.cod-caixa)    OR
            FIRST-OF(canhoto-nf.cod-envelope) THEN DO:
            FIND FIRST transporte NO-LOCK
                WHERE  transporte.cod-transp = canhoto-nf.cod-transp NO-ERROR.
            
            ASSIGN c-transportador = STRING(canhoto-nf.cod-transp) + " - " + STRING(IF AVAIL transporte THEN transporte.nome-abrev ELSE "").

            DISPLAY c-transportador
                    canhoto-nf.cod-caixa
                    canhoto-nf.cod-envelope
                    canhoto-nf.cod-estabel
                    canhoto-nf.serie
                    canhoto-nf.nr-nota-fis
                    nota-fiscal.dt-emis-nota
                    c-cliente
                WITH FRAME fRecebidos.
            DOWN WITH FRAME fRecebidos.

            IF  LAST-OF(canhoto-nf.cod-transp)   OR
                LAST-OF(canhoto-nf.cod-caixa)    OR
                LAST-OF(canhoto-nf.cod-envelope) THEN
                PUT UNFORMATTED SKIP(1).

            NEXT.
        END.


        DISPLAY canhoto-nf.cod-estabel
                canhoto-nf.serie
                canhoto-nf.nr-nota-fis
                nota-fiscal.dt-emis-nota
                c-cliente
            WITH FRAME fRecebidos.
        DOWN WITH FRAME fRecebidos.

        IF  LAST-OF(canhoto-nf.cod-transp)   OR
            LAST-OF(canhoto-nf.cod-caixa)    OR
            LAST-OF(canhoto-nf.cod-envelope) THEN DO:
            PUT UNFORMATTED SKIP(1).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-canhotos-nao-recebidos:
    RUN pi-inicializar IN h-acomp (INPUT "Canhotos N∆o Recebidos").

    IF  PAGE-NUMBER >= 1 THEN
        PAGE.

    PUT UNFORMATTED SKIP(1) "**** Canhotos N∆o Recebidos ****" SKIP.

    FOR EACH  nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini
        AND   nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim
        AND   nota-fiscal.serie       >= tt-param.serie-ini
        AND   nota-fiscal.serie       <= tt-param.serie-fim
        AND   nota-fiscal.nr-nota-fis >= tt-param.nr-nota-fis-ini
        AND   nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fis-fim
        AND   NOT CAN-FIND(FIRST canhoto-nf NO-LOCK
                           WHERE canhoto-nf.cod-estabel = nota-fiscal.cod-estabel
                           AND   canhoto-nf.serie       = nota-fiscal.serie
                           AND   canhoto-nf.nr-nota-fis = nota-fiscal.nr-nota-fis)
        BREAK BY nota-fiscal.nome-transp:

        RUN pi-acompanhar IN h-acomp (INPUT nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
        ASSIGN c-cliente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

        IF  FIRST-OF(nota-fiscal.nome-transp) THEN DO:
            FIND FIRST transporte NO-LOCK
                WHERE  transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

            ASSIGN c-transportador = STRING(IF AVAIL transporte THEN transporte.cod-transp ELSE 0) + " - " + nota-fiscal.nome-transp.

            DISPLAY c-transportador
                    nota-fiscal.cod-estabel
                    nota-fiscal.serie
                    nota-fiscal.nr-nota-fis
                    nota-fiscal.dt-emis-nota
                    c-cliente
                WITH FRAME fNaoRecebidos.
            DOWN WITH FRAME fNaoRecebidos.

            CREATE tt-dados.
            ASSIGN tt-dados.nome-transp = nota-fiscal.nome-transp
                   tt-dados.cod-estabel = nota-fiscal.cod-estabel
                   tt-dados.serie       = nota-fiscal.serie
                   tt-dados.nr-nota-fis = nota-fiscal.nr-nota-fis
                   tt-dados.nm-dest     = c-cliente
                   tt-dados.dt-emissao  = nota-fiscal.dt-emis-nota.

            IF  LAST-OF(nota-fiscal.nome-transp) THEN
                PUT UNFORMATTED SKIP(1).

            NEXT.
        END.

        DISPLAY nota-fiscal.cod-estabel
                nota-fiscal.serie
                nota-fiscal.nr-nota-fis
                nota-fiscal.dt-emis-nota
                c-cliente
            WITH FRAME fNaoRecebidos.
        DOWN WITH FRAME fNaoRecebidos.

        CREATE tt-dados.
        ASSIGN tt-dados.nome-transp = nota-fiscal.nome-transp
               tt-dados.cod-estabel = nota-fiscal.cod-estabel
               tt-dados.serie       = nota-fiscal.serie
               tt-dados.nr-nota-fis = nota-fiscal.nr-nota-fis
               tt-dados.nm-dest     = c-cliente
               tt-dados.dt-emissao  = nota-fiscal.dt-emis-nota.

        IF  LAST-OF(nota-fiscal.nome-transp) THEN
            PUT UNFORMATTED SKIP(1).
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-envia-email:
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo  AS CHARACTER   NO-UNDO.

    RUN pi-inicializar IN h-acomp (INPUT "Enviando E-mail").

    IF  NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    
    FOR EACH tt-dados NO-LOCK
        BREAK BY tt-dados.nome-transp:

        RUN pi-acompanhar IN h-acomp (INPUT tt-dados.nome-transp + " - " + tt-dados.cod-estabel + "/" + tt-dados.serie + "/" + tt-dados.nr-nota-fis).

        /* Cria o arquivo que ser† anexado ao e-mail */
        IF  FIRST-OF(tt-dados.nome-transp) THEN DO:
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "canhotos.txt".
            OUTPUT STREAM s-email TO VALUE(c-arquivo).

            FIND FIRST transporte NO-LOCK
                WHERE  transporte.nome-abrev = tt-dados.nome-transp NO-ERROR.
            IF  NOT AVAIL transporte THEN
                NEXT.

            EMPTY TEMP-TABLE tt-envio2.
            EMPTY TEMP-TABLE tt-mensagem.

            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail
                   tt-envio2.porta             = param-global.porta-mail
                   tt-envio2.remetente         = "intelbras@intelbras.com.br"
                   tt-envio2.destino           = transporte.e-mail
                   tt-envio2.assunto           = "Canhotos N∆o Recebidos"
                   tt-envio2.arq-anexo         = c-arquivo
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Segue arquivo anexo contendo a listagem das Notas Fiscais que "      + 
                                              "ainda n∆o tiveram o canhoto recebido." + CHR(13) + CHR(13) + CHR(13) +
                                              "<E-mail autom†tico. N∆o responda>".
        END.


        DISPLAY STREAM s-email
                tt-dados.cod-estabel
                tt-dados.serie
                tt-dados.nr-nota-fis
                tt-dados.dt-emissao
                tt-dados.nm-dest
            WITH FRAME fNaoRecebidosEmail.
        DOWN WITH FRAME fNaoRecebidosEmail.


        /* Envia o e-mail para a transportadora */
        IF  LAST-OF(tt-dados.nome-transp) THEN DO:
            OUTPUT STREAM s-email CLOSE.

            IF  VALID-HANDLE(h-utapi019) THEN
                RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                               INPUT  TABLE tt-mensagem,
                                               OUTPUT TABLE tt-erros).
        END.
    END.


    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.


    IF  CAN-FIND(FIRST tt-dados) THEN DO:
        PUT UNFORMATTED SKIP(4) "-> Os e-mail foram enviados com sucesso para as transportadoras!".
    END.

    RETURN "OK":U.
END PROCEDURE.

