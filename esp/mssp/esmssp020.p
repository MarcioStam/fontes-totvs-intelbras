/*------------------------------------------------------------------------
    File        : ESMSSP020.P
    Purpose     : Consulta Item - Procedure: consultaItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Definiá∆o das temp-tables "tt-item" e "tt-mensagem" */
{esp/mssp/esmssp020.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-item-fabric.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-item.
EMPTY TEMP-TABLE tt-mensagem.

FIND FIRST item
    WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE item THEN DO:
    RUN pi-cria-mensagem (INPUT 2,
                          INPUT "Item":U).

    RETURN "NOK":U.
END.

FIND FIRST int-item
    WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE int-item THEN DO:
    RUN pi-cria-mensagem (INPUT 2,
                          INPUT "Extens∆o de Item":U).

    RETURN "NOK":U.
END.

CREATE tt-item.

/* Informaá‰es da Tabela "Item" (item) */
ASSIGN tt-item.it-codigo        = item.it-codigo
       tt-item.un               = item.un
       tt-item.desc-item        = item.desc-item
       tt-item.desc-inter       = item.desc-inter
       tt-item.cod-estabel      = item.cod-estabel
       tt-item.fm-codigo        = item.fm-codigo
       tt-item.class-fiscal     = item.class-fiscal
       tt-item.responsavel      = item.responsavel
       tt-item.peso-liquido     = item.peso-liquido
       tt-item.peso-bruto       = item.peso-bruto
       tt-item.comprim          = item.comprim
       tt-item.largura          = item.largura
       tt-item.altura           = item.altura
       tt-item.cd-folh-item     = item.cd-folh-item
       tt-item.ind-serv-mat     = item.ind-serv-mat
       tt-item.tipo-contr       = item.tipo-contr
       tt-item.ge-codigo        = item.ge-codigo
       tt-item.contr-qualid     = item.contr-qualid
       tt-item.fraciona         = item.fraciona
       tt-item.criticidade      = item.criticidade
       tt-item.fm-cod-com       = item.fm-cod-com
       tt-item.perc-nqa         = item.perc-nqa
       tt-item.cd-planejado     = item.cd-planejado
       tt-item.reporte-ggf      = item.reporte-ggf
       tt-item.tipo-item        = SUBSTRING(item.char-2, 212, 1)
       tt-item.aliquota-ii      = dec(SUBSTRING(item.char-2, 22, 6))  /*ITEM.aliquota-ii*/
       tt-item.aliquota-ipi     = item.aliquota-ipi
       tt-item.aliquota-pis     = DECIMAL(TRIM(SUBSTRING(item.char-2, 31, 5)))
       tt-item.aliquota-cofins  = DECIMAL(TRIM(SUBSTRING(item.char-2, 36, 5)))
       tt-item.log-necessita-li = item.log-necessita-li
       tt-item.log-antidumping  = int-ITEM.log-antidumping
       tt-item.obs-antidumping  = int-item.obs-antidumping
    .

FIND FIRST classif-fisc
    WHERE classif-fisc.class-fiscal = item.class-fiscal NO-LOCK NO-ERROR.

ASSIGN des-class-fiscal = IF AVAILABLE classif-fisc THEN classif-fisc.descricao ELSE "":U.

IF INDEX(item.narrativa, "#MANAUS#":U) > 0 THEN
    ASSIGN tt-item.narrativa     = TRIM(SUBSTRING(item.narrativa, 1, INDEX(item.narrativa, "#MANAUS#":U) - 1))
           tt-item.narrat-manaus = TRIM(SUBSTRING(item.narrativa, INDEX(item.narrativa, "#MANAUS#":U) + 8, LENGTH(item.narrativa))).
ELSE
    ASSIGN tt-item.narrativa     = TRIM(item.narrativa)
           tt-item.narrat-manaus = "":U.

/* Buscando a Unidade Neg¢cio do Item */
FIND FIRST item-uni-estab
    WHERE item-uni-estab.it-codigo   = item.it-codigo
      AND item-uni-estab.cod-estabel = item.cod-estabel NO-LOCK NO-ERROR.

IF AVAILABLE item-uni-estab THEN DO:
    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = item-uni-estab.cod-unid-negoc NO-LOCK NO-ERROR.
        
    IF AVAILABLE unid-negoc THEN
        ASSIGN tt-item.un-neg = unid-negoc.des-unid-negoc.
END.

/* Buscando as descriá∆o*/
FIND FIRST familia
    WHERE familia.fm-codigo = tt-item.fm-codigo NO-LOCK NO-ERROR.

ASSIGN tt-item.desc-fam-mat = IF AVAILABLE familia THEN familia.descricao ELSE "":U.

FIND FIRST fam-comerc
    WHERE fam-comerc.fm-cod-com = tt-item.fm-cod-com NO-LOCK NO-ERROR.

ASSIGN tt-item.desc-fam-com = IF AVAILABLE fam-comerc THEN fam-comerc.descricao ELSE "":U.

/* Informaá‰es da Tabela "Extens∆o do Item" (int-item) */
ASSIGN tt-item.destaq-ncm   = int-item.destaque
       tt-item.perc-gatt    = int-item.perc-gatt
       tt-item.ex-tarifario = int-item.ex-tarifario
       tt-item.nve          = int-item.nve
       tt-item.seq-suframa  = int-item.seq-suframa.

/* Buscando as descriá∆o*/
FIND FIRST destaque-classif-fisc
    WHERE destaque-classif-fisc.class-fiscal = tt-item.class-fiscal
      AND destaque-classif-fisc.destaque     = tt-item.destaq-ncm NO-LOCK NO-ERROR.

ASSIGN tt-item.desc-dest-ncm = IF AVAILABLE destaque-classif-fisc THEN destaque-classif-fisc.descricao ELSE "":U.

/* Busca CTR */
RUN pi-ctr (INPUT  tt-item.it-codigo,
            OUTPUT tt-item.versao,
            OUTPUT tt-item.data-versao,
            OUTPUT tt-item.cod-acond,
            OUTPUT tt-item.des-acond,
            OUTPUT tt-item.cod-amost,
            OUTPUT tt-item.des-amost,
            OUTPUT tt-item.inf-adic).

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

/* Busca Fabricante do Item */
RUN pi-item-fabric (INPUT  tt-item.it-codigo,
                    OUTPUT TABLE tt-item-fabric).

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

/* Busca CEST */
/*
FOR LAST sit-tribut-relacto
    WHERE sit-tribut-relacto.cdn-tribut       = 11
    AND   sit-tribut-relacto.cod-estab        = "*"
    AND   sit-tribut-relacto.cod-natur-operac = "*"
    AND   sit-tribut-relacto.cod-ncm          = "*"
    AND   sit-tribut-relacto.cod-item         = item.it-codigo
    AND   sit-tribut-relacto.cdn-emitente     = 0 NO-LOCK:

    ASSIGN tt-item.cest = sit-tribut-relacto.cdn-sit-tribut.
END.
*/
DEFINE VARIABLE h-esmsspapi001 AS HANDLE      NO-UNDO.
DEF VAR c-mensagem AS CHAR.
DEF VAR i-cest AS INTEGER.

RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

RUN piBuscaCEST IN h-esmsspapi001 (INPUT 1,
                                   INPUT IF TODAY > 04/01/2016 THEN TODAY ELSE 04/01/2016,
                                   INPUT "",
                                   INPUT "",
                                   INPUT "",
                                   INPUT tt-item.class-fiscal,
                                   INPUT tt-item.it-codigo,
                                   INPUT 0,
                                   OUTPUT c-mensagem,
                                   OUTPUT i-cest).

ASSIGN tt-item.cest = i-cest.

DELETE PROCEDURE h-esmsspapi001.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-ctr :
/*------------------------------------------------------------------------------
  Purpose:     Buscar CTR.
  Parameters:  INPUT  p-item        LIKE item.it-codigo,
               OUTPUT p-versao      DECIMAL,
               OUTPUT p-data-versao DATE,
               OUTPUT p-cod-acond   CHARACTER,
               OUTPUT p-des-acond   CHARACTER,
               OUTPUT p-cod-amost   INTEGER,
               OUTPUT p-des-amost   CHARACTER,
               OUTPUT p-inf-adic    CHARACTER.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-item        LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER p-versao      AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-data-versao AS DATE             NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-acond   AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-acond   AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-amost   AS INTEGER          NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-amost   AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-inf-adic    AS CHARACTER        NO-UNDO.

    FOR EACH comp-folh NO-LOCK
        WHERE comp-folh.cd-folha = "1":U:

        FIND FIRST it-carac-tec
            WHERE it-carac-tec.it-codigo = p-item
              AND it-carac-tec.cd-folha  = comp-folh.cd-folha
              AND it-carac-tec.cd-comp   = comp-folh.cd-comp NO-LOCK NO-ERROR.

        IF NOT AVAILABLE it-carac-tec THEN NEXT.

        IF comp-folh.nr-tabela <> 0 THEN DO:
            /* Amostragem */
            IF comp-folh.nr-tabela = 3 THEN DO:
                FIND FIRST it-res-carac
                    WHERE it-res-carac.it-codigo = p-item
                      AND it-res-carac.cd-folha  = comp-folh.cd-folha
                      AND it-res-carac.cd-comp   = comp-folh.cd-comp
                      AND it-res-carac.nr-tabela = comp-folh.nr-tabela NO-LOCK NO-ERROR.

                IF AVAILABLE it-res-carac THEN
                    ASSIGN p-cod-amost = it-res-carac.sequencia
                           p-des-amost = it-carac-tec.observacao.
            END. /* IF comp-folh.nr-tabela = 3 THEN DO: */

            /* Acondicionamento */
            IF comp-folh.nr-tabela = 4 THEN DO:
                FIND FIRST it-res-carac
                    WHERE it-res-carac.it-codigo = p-item
                      AND it-res-carac.cd-folha  = comp-folh.cd-folha
                      AND it-res-carac.cd-comp   = comp-folh.cd-comp
                      AND it-res-carac.nr-tabela = comp-folh.nr-tabela NO-LOCK NO-ERROR.

                IF AVAILABLE it-res-carac THEN DO:
                    ASSIGN p-cod-acond = STRING(it-res-carac.sequencia)
                           p-des-acond = it-carac-tec.observacao.

                    FIND FIRST c-tab-res
                        WHERE c-tab-res.nr-tabela  = it-res-carac.nr-tabela
                          AND c-tab-res.nr-tabela <> 100
                          AND c-tab-res.nr-tabela <> 300
                          AND c-tab-res.nr-tabela <> 400
                          AND c-tab-res.sequencia  = it-res-carac.sequencia NO-LOCK NO-ERROR.

                    IF AVAILABLE c-tab-res THEN
                        ASSIGN p-des-acond = c-tab-res.descricao.

                END. /* IF AVAILABLE it-res-carac THEN DO: */
            END. /* IF comp-folh.nr-tabela = 4 THEN DO: */
        END. /* IF comp-folh.nr-tabela <> 0 THEN DO: */

        /* Vers∆o - tipo numerico = 1 */
        IF comp-folh.tipo-result = 1 THEN
            IF comp-folh.descricao = "versao":U THEN
                ASSIGN p-versao = it-carac-tec.vl-result.

        /* Informaá‰es adicionais - tipo texto = 3 */
        IF comp-folh.tipo-result = 3 THEN DO:
            FIND FIRST it-msg-carac
                WHERE it-msg-carac.it-codigo = p-item
                  AND it-msg-carac.cd-folha  = comp-folh.cd-folha
                  AND it-msg-carac.cd-comp   = comp-folh.cd-comp NO-LOCK NO-ERROR.

            IF AVAILABLE it-msg-carac THEN
                ASSIGN p-inf-adic = it-msg-carac.msg-ex.
        END. /* IF comp-folh.tipo-result = 3 THEN DO: */

        /* Data Vers∆o - tipo data = 6 */
        IF comp-folh.tipo-result = 6 THEN
            IF comp-folh.descricao = "Data da Versao":U THEN
                ASSIGN p-data-versao = it-carac-tec.dt-result.
    END. /* FOR EACH comp-folh NO-LOCK */

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-item-fabric :
    DEFINE INPUT  PARAMETER p-item LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-fabric.

    EMPTY TEMP-TABLE tt-item-fabric.

    FOR EACH item-fabric NO-LOCK
        WHERE item-fabric.it-codigo = p-item:

        FIND FIRST fabricante
            WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-LOCK NO-ERROR.

        CREATE tt-item-fabric.
        ASSIGN tt-item-fabric.cod-fabric = item-fabric.cod-fabric
               tt-item-fabric.nome-abrev = IF AVAILABLE fabricante THEN fabricante.nome-abrev ELSE "":U
               tt-item-fabric.it-codigo  = item-fabric.it-codigo
               tt-item-fabric.it-fabric  = item-fabric.it-fabric
               tt-item-fabric.referencia = item-fabric.referencia.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem baseado nas mensagens do Datasul EMS 2.
  Parameters:  INPUT p-codigo    AS INTEGER,
               INPUT p-parametro AS CHARACTER.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-codigo    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-parametro AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST tt-mensagem NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia = i-sequencia
           tt-mensagem.codigo    = p-codigo.

    /* Tipo da Mensagem (Erro, Advertància, Informaá∆o ou Quest∆o) */
    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.tipo = RETURN-VALUE.

    /* Mensagem */
    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

    /* Ajuda da Mensagem */
    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.complemento = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

