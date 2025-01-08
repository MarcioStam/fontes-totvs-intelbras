/* NÆo foi feita a replica‡Æo da l¢gica, pois, tanto no layout 1.10 como no      */
/* layout novo 2.00, a l¢gica da include abaixo ‚ a mesma. Caso seja necess rio  */ 
/* alterar a l¢gica da mesma apenas para o layout 2.00 da NF-e, solicitamos que  */
/* o c¢digo da include seja copiado para esse fonte, e a altera‡Æo seja feita    */
/* somente nele.                                                                 */
 
{adapters/xml/ep2/axsep017extradeclarations.i}

/* NOVAS DEFINICOES PARA O LAYOUT 4.0 DA NF-E */

DEFINE VARIABLE d-vl-desc-icms                  LIKE it-nota-fisc.val-desconto-total     NO-UNDO.
DEFINE VARIABLE d-total-vl-desc-icms            AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-descto-zfm-pis                AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-descto-zfm-cofins             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vl-iss-ret              AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-omite-val-totais-sn-icms      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-omite-val-totais-sn-icms-st   AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE d-total-vFCPUFDest              AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vICMSUFDest             AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vICMSUFRemet            AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE c-extensao-arq                  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE l-prod-rural                    AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE d-desconto-total                AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vFCP                    AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vFCPST                  AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vFCPSTRet               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-tot-vFCPSTRet-NS              AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-tot-vFCPSTRet-S               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIPIDevol               AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE d-total-vIPIDevol-vOutro        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-ciashop                       AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE l-soma-icms-st-antecip          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-substituido-st-ant            AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE de-tot-FCPSTA                   AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE l-Majora-FCP                    AS LOGICAL INITIAL NO                    NO-UNDO.

DEFINE BUFFER bf-nota-fisc-adc-nfe FOR nota-fisc-adc.
DEFINE BUFFER bf-it-nota-fisc-dev  FOR it-nota-fisc.

DEF VAR l-NT2018005 AS LOGICAL INITIAL NO NO-UNDO.

ASSIGN l-NT2018005 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2018005":U
                                AND funcao.ativo ).
                                
DEF VAR l-NT2019001 AS LOGICAL INITIAL NO NO-UNDO.

ASSIGN l-NT2019001 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2019001":U
                                AND funcao.ativo ).

FUNCTION fn-ajusta-campo-IE RETURNS CHAR (INPUT cCampo AS CHAR).

    /*Campos de Inscri‡Æo Estadual n£meros - Ocorrencia 2-14*/

    DEFINE VARIABLE cCampoAjustado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iCont          AS INTEGER     NO-UNDO.

    DO  iCont = 1 TO LENGTH(cCampo):
        IF  CAN-DO("0,1,2,3,4,5,6,7,8,9":U,SUBSTRING(cCampo,iCont,1)) THEN
            ASSIGN cCampoAjustado = cCampoAjustado + SUBSTRING(cCampo,iCont,1) NO-ERROR.
    END.
    /*IF  cCampoAjustado <> "":U THEN
        ASSIGN cCampoAjustado = TRIM(STRING(DEC(cCampoAjustado),">>>>>>>>>>>>99")) NO-ERROR. /*tamanho 14 - retirar zeros nao significativos*/*/

    IF  (cCampo = "ISENTO":U OR cCampo = "ISENTA":U) THEN
        ASSIGN cCampoAjustado = cCampo.

    RETURN TRIM(cCampoAjustado).

END FUNCTION.

FUNCTION fn-UN-busca-sigla RETURNS CHAR (INPUT cUN AS CHAR).

    DEFINE VARIABLE cUNSigla AS CHARACTER   NO-UNDO.

    ASSIGN cUNSigla = cUN.

    FOR FIRST tab-unidade NO-LOCK
        WHERE tab-unidade.un = cUN:

        IF  TRIM(SUBSTRING(tab-unidade.char-2,1,10)) <> "":U THEN
            ASSIGN cUNSigla = TRIM(SUBSTRING(tab-unidade.char-2,1,10)).

    END.

    RETURN TRIM(cUNSigla).

END FUNCTION.

DEFINE TEMP-TABLE tt-nve NO-UNDO
    FIELD cod-nve AS CHAR.
