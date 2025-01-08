/*****************************************************************************
** Programa: esp/utp/esutp024rpa.p
** VersÆo..: 1.00
** Data....: 15/03/2012
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa para buscar as informa‡äes dos t¡tulos
*****************************************************************************/


/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
{esp/utp/esutp024tt.i}



/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-cod-estabel-ini AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estabel-fim AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-unid-negoc-ini  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-unid-negoc-fim  AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt_tit_acr.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt_tit_acr.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Analisando T¡tulos").


FOR EACH  estabelec NO-LOCK
    WHERE estabelec.cod-estabel  >= p-cod-estabel-ini
    AND   estabelec.cod-estabel  <= p-cod-estabel-fim,
    EACH  tit_acr NO-LOCK
    WHERE tit_acr.cod_estab       = estabelec.cod-estabel
    AND   tit_acr.log_sdo_tit_acr
    AND   tit_acr.cod_portador    = "9943"
    BY    tit_acr.cdn_cliente
    BY    tit_acr.dat_vencto_tit_acr:

    RUN pi-acompanhar IN h-acomp (INPUT "T¡tulo: " + tit_acr.cod_tit_acr).

    /* Somente t¡tulos com saldo, e nÆo estornados */
    IF  tit_acr.log_tit_acr_estordo THEN
        NEXT.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.

    FOR EACH  val_tit_acr NO-LOCK
        WHERE val_tit_acr.cod_estab      = tit_acr.cod_estab
        AND   val_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
        IF  val_tit_acr.cod_unid_negoc < p-unid-negoc-ini OR
            val_tit_acr.cod_unid_negoc > p-unid-negoc-fim THEN
            NEXT.

        CREATE tt_tit_acr.
        ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
               tt_tit_acr.cod_espec          = tit_acr.cod_espec
               tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
               tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
               tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
               tt_tit_acr.cod_unid_negoc     = val_tit_acr.cod_unid_negoc
               tt_tit_acr.val_origin_tit_acr = val_tit_acr.val_origin_tit_acr
               tt_tit_acr.val_sdo_tit_acr    = val_tit_acr.val_sdo_tit_acr
               tt_tit_acr.val_perc_rat       = val_tit_acr.val_perc_rat
               tt_tit_acr.nom_cliente        = IF AVAIL emitente THEN emitente.nome-emit   ELSE ""
               tt_tit_acr.nom_matriz         = IF AVAIL emitente THEN emitente.nome-matriz ELSE "".
    END.
END.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar in h-acomp.

RETURN "OK":U.
