/********************************************************************************
 ** UPC........: des543.p - UPC Delete Crm-relacionamento Cliente
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes Relacionamento Cliente p/ o CRM
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF crm-relacionamento-cliente.

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-crm-relacionamento-cliente LIKE crm-relacionamento-cliente
     FIELD situacao AS INTEGER.

CREATE tt-crm-relacionamento-cliente.
BUFFER-COPY crm-relacionamento-cliente TO tt-crm-relacionamento-cliente.
ASSIGN tt-crm-relacionamento-cliente.situacao     = 1 /* Elimina‡Æo */.

RAW-TRANSFER tt-crm-relacionamento-cliente TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0194", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

RETURN "OK".

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}


IF  l-web-service = NO THEN DO:
    create tt-relacionamento-cliente-atu.
    buffer-copy crm-relacionamento-cliente to tt-relacionamento-cliente-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-relacionamento-cliente-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "Crm-relacionamento-Cliente",
                             input "D",
                             input rowid(crm-relacionamento-cliente),
                             input table tt-raw-transfer).
END.
*/
