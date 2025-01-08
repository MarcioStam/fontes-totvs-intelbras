/********************************************************************************
 ** UPC........: des546.p - UPC Delete crm-categoria
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes Relacionamento Cliente p/ o CRM
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF crm-categoria.

{esp/esb/esesb000.i}


DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-crm-categoria LIKE crm-categoria
     FIELD situacao AS INTEGER.

CREATE tt-crm-categoria.
ASSIGN tt-crm-categoria.cd-categoria = crm-categoria.cd-categoria
       tt-crm-categoria.ds-categoria = crm-categoria.ds-categoria
       tt-crm-categoria.situacao     = 1 /* Elimina‡Æo */.

RAW-TRANSFER tt-crm-categoria TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0190", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.


IF AVAIL crm-relacionamento-cliente  THEN DO:
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = crm-relacionamento-cliente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
       RUN esp/wso/eswso0008.p (INPUT emitente.cod-emitente).
    
    END.
END.

RETURN "OK".

/*                                                               */
/* {esp/crm/escrm001.i}                                          */
/* {esp/crm/escrm001a.i1}                                        */
/*                                                               */
/*                                                               */
/* create tt-crm-categoria-atu.                                  */
/* buffer-copy crm-categoria to tt-crm-categoria-atu.            */
/* create tt-raw-transfer.                                       */
/*                                                               */
/* raw-transfer tt-crm-categoria-atu to tt-raw-transfer.record.  */
/*                                                               */
/* run esp/crm/escrm001a.p (input "crm-categoria",               */
/*                          input "D",                           */
/*                          input rowid(crm-categoria),          */
/*                          input table tt-raw-transfer).        */
/*                                                               */
