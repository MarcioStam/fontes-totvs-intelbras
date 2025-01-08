/*****************************************************************************
**
**     Objetivo: Importa‡Æo CTRCs GKO
**
**     Versao..: 2.00.00.000
**     Autor: hoepers - 09/04/2012
*****************************************************************************/
DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD nom-arquivo      AS CHAR
    FIELD nom-completo     AS CHAR
    FIELD ind-tipo-arquivo AS CHAR.

/* TPREGISTRO 700 */
DEFINE TEMP-TABLE tt-conhec NO-UNDO
    FIELD IdNC                   AS INT
    FIELD CdTipoNC               AS CHARACTER
    FIELD cdNc                   AS CHARACTER
    FIELD CdSerieNC              AS CHARACTER
    FIELD TpPessoaTransp         AS INT
    FIELD CNPJCPFTransp          AS CHARACTER
    FIELD DsIEDestTransp         AS CHARACTER
    FIELD CdParRespFrete         AS CHARACTER
    FIELD CNPJParRespFrete       AS CHARACTER
    FIELD DtRegistroNC           AS DATE
    FIELD DtEmissaoNC            AS DATE
    FIELD CdNaturezaOperacao     AS CHARACTER
    FIELD VrFreteAPagar          AS DEC
    FIELD VrDesconto             AS DEC
    FIELD StSubstTriburariaIcms  AS LOG
    FIELD DsUFOrigem             AS CHARACTER
    FIELD DsUFDestino            AS CHARACTER
    FIELD cdFatura               AS CHARACTER
    FIELD TotVrRatFreteCobradoNC AS DEC
    FIELD DesArquivoOrigem       AS CHARACTER
    FIELD DsChaveAcesso          AS CHARACTER
    FIELD tp-ct-e                AS CHAR 
    FIELD CdIbgeOrig             AS CHAR
    FIELD CdIbgeDest             AS CHAR
    INDEX id-conhec
            IdNC.

/* TPREGISTRO 720 */
DEFINE TEMP-TABLE tt-impostos NO-UNDO
    FIELD IdNC              AS INT
    FIELD CDIMPOSTO         AS INT
    FIELD VRBASECALIMPOSTO  AS DEC
    FIELD PCALIQUOTAIMPOSTO AS DEC
    FIELD VRIMPOSTO         AS DEC
    FIELD TPTRIBICMS        AS CHARACTER
    FIELD TPTRIBUTACAO      AS CHARACTER
    INDEX id-conhec
            IdNC.

/* TPREGISTRO 750 */
DEFINE TEMP-TABLE tt-conta-contab NO-UNDO
    FIELD IdNC               AS INT
    FIELD CdContaContabil    AS CHARACTER
    FIELD CdCentroCusto      AS CHARACTER
    FIELD VrRatAPagarCobrado AS DEC
    FIELD VrRatFreteCobrado  AS DEC
    INDEX id-conhec
            IdNC.

DEFINE TEMP-TABLE tt-doc-fiscal NO-UNDO LIKE doc-fiscal
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-it-doc-fisc NO-UNDO LIKE it-doc-fisc
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-nota-fisc-adc NO-UNDO LIKE nota-fisc-adc
    FIELD r-rowid AS ROWID.
