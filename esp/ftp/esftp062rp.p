/*****************************************************************************
**     Programa.........: esp/acr/ESFTP062rp.p
**     Descricao .......: Valida dias conforme legislacao
**     Versao...........: 1.00.000
**     Autor............: Rubia
**     Criado...........: 04/2016
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

{include/i-prgvrs.i ESFTP062 2.04.00.001}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "X(35)":U
    FIELD usuario          AS CHARACTER FORMAT "X(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHARACTER FORMAT "X(40)":U
    FIELD modelo           AS CHARACTER FORMAT "X(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf    AS LOGICAL
    FIELD dtDataIni        AS DATE
    FIELD dtDataFim        AS DATE.
    /*Fim alteracao 15/02/2005*/

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */
DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE dt-prazo               AS DATE                     NO-UNDO.
DEFINE VARIABLE h-acomp                AS HANDLE                   NO-UNDO.
DEFINE VARIABLE c-email                AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo      AS CHARACTER FORMAT "X(50)" NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo-acum AS CHARACTER FORMAT "X(50)" NO-UNDO.
DEFINE VARIABLE l-excecao              AS LOGICAL                  NO-UNDO.

DEFINE BUFFER bf_usuar_mestre FOR usuar_mestre.

DEFINE STREAM st-csv.
DEFINE STREAM st-csv-acum.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="0"}

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Valida dias conforme legislacao"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP062"
       c-versao       = "2.04"
       c-revisao      = "001".

IF OPSYS = "UNIX" THEN
    ASSIGN c-caminho-arquivo      = c-dir-arquivo-session + c-seg-usuario
           c-caminho-arquivo      = c-caminho-arquivo + "/" + c-programa + ".csv"
           c-caminho-arquivo      = REPLACE(c-caminho-arquivo, "~\":U, "/":U)
           c-caminho-arquivo-acum = c-dir-arquivo-session + c-seg-usuario
           c-caminho-arquivo-acum = c-caminho-arquivo-acum + "/" + c-programa + "_itens_nota.csv"
           c-caminho-arquivo-acum = REPLACE(c-caminho-arquivo-acum, "~\":U, "/":U)
           tt-param.dtDataIni     = 01/01/2013
           tt-param.dtDataFim     = TODAY.
ELSE
    ASSIGN c-caminho-arquivo      = SESSION:TEMP-DIRECTORY + c-programa + ".csv"
           c-caminho-arquivo-acum = SESSION:TEMP-DIRECTORY + c-programa + "_itens_nota.csv".

/******** FAZ A CARGA DOS DADOS NA TABELA TEMPORARIA *******/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

FUNCTION fnRetornaNarrativa RETURNS CHARACTER():

    DEFINE VARIABLE c-desc-prod AS CHARACTER   NO-UNDO.

    IF item.ind-imp-desc = 1 THEN /* Descriá∆o */
        ASSIGN c-desc-prod = item.desc-item.

    IF  item.ind-imp-desc = 2 OR        /* Descriá∆o + Narrativa */
        item.ind-imp-desc = 5 OR        /* Narrativa Item */
        item.ind-imp-desc = 6 OR        /* Uma Linha Narrativa */
        item.ind-imp-desc = 10 THEN DO: /* Descriá∆o + 24 Narrativa Item */

        IF  item.ind-imp-desc = 2 OR  item.ind-imp-desc = 10 THEN
            ASSIGN c-desc-prod = item.desc-item.
        ELSE 
            ASSIGN c-desc-prod = "".

        FIND narrativa OF item NO-LOCK NO-ERROR.

        IF AVAILABLE narrativa THEN
            ASSIGN c-desc-prod = c-desc-prod + IF  item.ind-imp-desc = 6 THEN
                                                    TRIM(ENTRY(1,SUBSTRING(narrativa.descricao,1,76),CHR(10))) ELSE
                                               IF item.ind-imp-desc = 10 THEN
                                                    TRIM(ENTRY(1,SUBSTRING(narrativa.descricao,1,24),chr(10))) ELSE
                                                        narrativa.descricao.

        IF c-desc-prod = "" THEN
            ASSIGN c-desc-prod = item.desc-item.
    END.

    IF  item.ind-imp-desc = 3 OR       /* Descriá∆o + Narrativa Item/Cliente */
        item.ind-imp-desc = 8 THEN DO: /* Descriá∆o + 24 Narrativa Item/Cliente */

        FIND item-cli
            WHERE item-cli.nome-abrev = nota-fiscal.nome-abrev
            AND   item-cli.it-codigo  = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

        ASSIGN c-desc-prod = item.desc-item.

        IF AVAILABLE item-cli THEN
            ASSIGN c-desc-prod = c-desc-prod +
                               IF item.ind-imp-desc = 3 THEN
                                  item-cli.narrativa
                               ELSE
                                  TRIM(ENTRY(1,SUBSTRING(item-cli.narrativa,1,24),CHR(10))).
    END.

    IF  item.ind-imp-desc = 4 OR         /* Descriá∆o + Narrativa Informada */
        item.ind-imp-desc = 7 OR         /* Narrativa Informada */
        item.ind-imp-desc = 9 THEN DO:   /* Descriá∆o + 24 Narrativa Informada */

        IF  item.ind-imp-desc = 4 OR  item.ind-imp-desc = 9 THEN
            ASSIGN c-desc-prod = item.desc-item.
        ELSE 
            ASSIGN c-desc-prod = "".

        FIND nar-it-nota
           WHERE nar-it-nota.cod-estabel  = nota-fiscal.cod-estabel
           AND   nar-it-nota.serie        = nota-fiscal.serie
           AND   nar-it-nota.nr-nota-fis  = nota-fiscal.nr-nota-fis
           AND   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
           AND   nar-it-nota.it-codigo    = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

        IF AVAILABLE nar-it-nota THEN 
            ASSIGN c-desc-prod = c-desc-prod +
                              IF item.ind-imp-desc = 9 THEN
                                 TRIM(ENTRY(1,SUBSTRING(nar-it-nota.narrativa,1,24),CHR(10)))
                              ELSE
                                 nar-it-nota.narrativa.
    END.
            
    ASSIGN c-desc-prod = REPLACE(c-desc-prod,CHR(13),"")
           c-desc-prod = TRIM(REPLACE(c-desc-prod,CHR(10),"")).

    RETURN c-desc-prod.
END FUNCTION.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ESFTP062":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

OUTPUT STREAM st-csv-acum TO VALUE(c-caminho-arquivo-acum) CONVERT TARGET "iso8859-1".

PUT STREAM st-csv-acum "Estab.;Emitente;Nome;Nr.Documento;SÇrie Doc.;Nat.Operaá∆o;Dt.Emiss∆o;Prazo Retorno;Item;Descriá∆o;Narrativa;Quantidade;Solicitante" SKIP.

FOR EACH nota-fiscal NO-LOCK
    WHERE nota-fiscal.dt-emis-nota >= tt-param.dtDataIni
    AND   nota-fiscal.dt-emis-nota <= tt-param.dtDataFim
    BY nota-fiscal.dt-emis-nota:

    IF nota-fiscal.dt-cancel <> ? THEN NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "Analisando notas " + nota-fiscal.nr-nota-fis + " Data " + STRING(nota-fiscal.dt-emis-nota,'99/99/9999')).
    FIND FIRST int-natur-oper WHERE int-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL int-natur-oper THEN DO:

        IF (int-natur-oper.dias-legislacao  = 0
        OR  int-natur-oper.dias-advertencia = 0) THEN NEXT.

        FIND FIRST  saldo-terc NO-LOCK
            WHERE saldo-terc.cod-estabel = nota-fiscal.cod-estabel
              AND saldo-terc.serie       = nota-fiscal.serie      
              AND saldo-terc.nro-docto   = nota-fiscal.nr-nota-fis NO-ERROR. 
        IF AVAIL saldo-terc THEN DO:
    
            IF saldo-terc.quantidade = 0 THEN NEXT.

            /* Verifica se Ç um item que n∆o precisa enviar email */
            ASSIGN l-excecao = NO.
            FOR EACH tt-prog-ponto:
                IF CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                            WHERE it-nota-fisc.it-codigo = tt-prog-ponto.conteudo) THEN 
                   ASSIGN l-excecao = YES.
            END.
            IF l-excecao = YES THEN NEXT.
    
            FIND FIRST ped-fiscal NO-LOCK
                 WHERE ped-fiscal.cod-estabel = saldo-terc.cod-estabel
                   AND ped-fiscal.serie       = saldo-terc.serie
                   AND ped-fiscal.nr-nota-fis = saldo-terc.nro-docto NO-ERROR.
            IF AVAIL ped-fiscal THEN DO:
    
                RUN pi-acompanhar IN h-acomp (INPUT saldo-terc.cod-estabel + " - " + STRING(saldo-terc.cod-emitente) + " - " + saldo-terc.it-codigo + " - " + saldo-terc.serie + " - " + saldo-terc.nro-docto).
    
                ASSIGN dt-prazo = ?
                       dt-prazo = nota-fiscal.dt-emis-nota + (int-natur-oper.dias-legislacao - int-natur-oper.dias-advertencia)
                       c-email  = ''.

                IF dt-prazo <= TODAY THEN DO:

                    FIND FIRST int-centro-custo
                        WHERE int-centro-custo.cod-estabel = ped-fiscal.cod-estabel
                          AND int-centro-custo.cc-codigo   = ped-fiscal.sc-codigo NO-LOCK NO-ERROR.
                    IF AVAIL int-centro-custo THEN DO:
                        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-LOCK NO-ERROR.
                        IF AVAIL usuar_mestre THEN
                            ASSIGN c-email = usuar_mestre.cod_e_mail_local.
                    END.
                    ELSE DO:
                        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-LOCK NO-ERROR.
                        IF AVAIL usuar_mestre THEN
                            ASSIGN c-email = usuar_mestre.cod_e_mail_local.
                    END.

                    OUTPUT STREAM st-csv TO VALUE(c-caminho-arquivo) CONVERT TARGET "iso8859-1".
                    
                    PUT STREAM st-csv "Estab.;Emitente;Nome;Nr.Documento;SÇrie Doc.;Nat.Operaá∆o;Dt.Emiss∆o;Prazo Retorno;Item;Descriá∆o;Narrativa;Quantidade;Solicitante" SKIP.
    
                    FOR FIRST bf_usuar_mestre FIELDS(nom_usuario)
                        WHERE bf_usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-LOCK: END.

                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                        FOR FIRST item FIELDS(desc-item narrativa ind-imp-desc)
                            WHERE item.it-codigo = it-nota-fisc.it-codigo NO-LOCK: END.

                        PUT STREAM st-csv UNFORMATTED it-nota-fisc.cod-estabel ";"
                            it-nota-fisc.cd-emitente    ";"
                            it-nota-fisc.nome-ab-cli    ";"
                            it-nota-fisc.nr-nota-fis    ";"
                            it-nota-fisc.serie          ";"
                            it-nota-fisc.nat-operacao   ";"
                            it-nota-fisc.dt-emis-nota   ";"
                            (nota-fiscal.dt-emis-nota + int-natur-oper.dias-legislacao) ";"
                            it-nota-fisc.it-codigo      ";"
                            item.desc-item              ";"
                            REPLACE(REPLACE(REPLACE(REPLACE(fnRetornaNarrativa(),CHR(10)," "),CHR(11)," "),CHR(12)," "),CHR(13)," ") ";"
                            it-nota-fisc.qt-faturada[1] ";"
                            (IF AVAIL bf_usuar_mestre THEN bf_usuar_mestre.nom_usuario ELSE "") SKIP.

                        PUT STREAM st-csv-acum UNFORMATTED it-nota-fisc.cod-estabel ";"
                            it-nota-fisc.cd-emitente    ";"
                            it-nota-fisc.nome-ab-cli    ";"
                            it-nota-fisc.nr-nota-fis    ";"
                            it-nota-fisc.serie          ";"
                            it-nota-fisc.nat-operacao   ";"
                            it-nota-fisc.dt-emis-nota   ";"
                            (nota-fiscal.dt-emis-nota + int-natur-oper.dias-legislacao) ";"
                            it-nota-fisc.it-codigo      ";"
                            item.desc-item              ";"
                            REPLACE(REPLACE(REPLACE(REPLACE(fnRetornaNarrativa(),CHR(10)," "),CHR(11)," "),CHR(12)," "),CHR(13)," ") ";"
                            it-nota-fisc.qt-faturada[1] ";"
                            (IF AVAIL bf_usuar_mestre THEN bf_usuar_mestre.nom_usuario ELSE "") SKIP.
                    END.

                    OUTPUT STREAM st-csv      CLOSE.

                    RUN piEnviaEmail (INPUT "grupo.fiscal@intelbras.com.br",
                                      INPUT c-email,
                                      INPUT "Nota Fiscal Pendente " + nota-fiscal.nr-nota-fis,
                                      INPUT "Prezado (a) " + CHR(13) +
                                            "Foi identificado que a Nota Fiscal de N¯ " + nota-fiscal.nr-nota-fis  + 
                                            " SÇrie: " + nota-fiscal.serie + " Est: " + nota-fiscal.cod-estabel    +
                                            " est† pr¢xima de seu vencimento, desta forma solicitamos que vocà "   + 
                                            "procure o grupo.fiscal@ para atualizaá∆o do documento ou retorno da " +
                                            "operaá∆o. Salientamos que existem operaá‰es que geram tributaá∆o e "  +
                                            "caso n∆o sejam renovadas dentro do prazo legal estipulado, ir∆o "     +
                                            "gerar penalidades, impactando no centro de custo do solicitante da "  +
                                            "nota fiscal, desta forma Ç de suma importÉncia que esta situaá∆o "    +
                                            "seja regularizada no per°odo de 20 dias a partir de " + STRING(dt-prazo,'99/99/9999') + "." + CHR(13) +
                                            "Obs.: Para contrato de locaá∆o, considerar como vencimento o prazo de vigància do contrato.", 
                                     INPUT c-caminho-arquivo).

                END. /* IF dt-prazo <= TODAY THEN DO: */

            END. /* IF AVAIL ped-fiscal THEN DO: */
    
        END. /* IF AVAIL saldo-terc THEN DO: */

    END. /* IF AVAIL int-natur-oper THEN DO: */

END. /* FOR EACH nota-fiscal */

OUTPUT STREAM st-csv-acum CLOSE.

PUT UNFORMATTED "Arquivo gerado em " c-caminho-arquivo-acum ".".

RUN pi-finalizar IN h-acomp.

RETURN "OK".

PROCEDURE piEnviaEmail:

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
               tt-envio2.arq-anexo         = c-lst-arq               /* Arquivo Tempor†rio */
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

    IF VALID-HANDLE(h-utapi019) THEN
		DELETE PROCEDURE h-utapi019.
		
	ASSIGN h-utapi019 = ?.

END PROCEDURE.

