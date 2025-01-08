/********************************************************************************
 ** UPC........: ddi102.p - UPC DELETE loc-entr
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de locais de entrega para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-loc-entr      FOR loc-entr.

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-loc-entr LIKE loc-entr
     FIELD situacao AS INTEGER.

CREATE tt-loc-entr.
BUFFER-COPY b-loc-entr TO tt-loc-entr.
ASSIGN tt-loc-entr.situacao  = 1. /* Elimina‡Æo */

RAW-TRANSFER tt-loc-entr TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0191-out", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

/* {esp/crm/escrm001.i} /* Definicao de temp-table */                   */
/* {esp/crm/escrm001a.i1} /* Definicao de temp-table */                 */
/*                                                                      */
/*                                                                      */
/* IF  l-web-service = NO THEN DO:                                      */
/*     find first emitente no-lock                                      */
/*         where  emitente.nome-abrev = b-loc-entr.nome-abrev no-error. */
/*     if  avail  emitente and emitente.identific <> 2 then do:         */
/*         create tt-loc-entr-atu.                                      */
/*         buffer-copy b-loc-entr to tt-loc-entr-atu.                   */
/*         create tt-raw-transfer.                                      */
/*                                                                      */
/*         raw-transfer tt-loc-entr-atu to tt-raw-transfer.record.      */
/*                                                                      */
/*         run esp/crm/escrm001a.p (input "Loc-entr",                   */
/*                                  input "D",                          */
/*                                  input rowid(b-loc-entr),            */
/*                                  input table tt-raw-transfer).       */
/*     end.                                                             */
/* END.                                                                 */

find first int-loc-entr exclusive-lock
    where  int-loc-entr.cod-entrega = b-loc-entr.cod-entrega
    and    int-loc-entr.nome-abrev  = b-loc-entr.nome-abrev no-error.
if  avail  int-loc-entr then
    delete int-loc-entr.

RETURN "OK".
