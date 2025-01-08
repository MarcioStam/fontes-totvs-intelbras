/********************************************************************************
 ** UPC........: wdi102.p - UPC WRITE loc-entr
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de locais de entrega do cliente para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-loc-entr      FOR loc-entr.
DEF PARAM BUFFER b-old-loc-entr  FOR loc-entr.

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-loc-entr LIKE loc-entr
     FIELD situacao AS INTEGER.

CREATE tt-loc-entr.
BUFFER-COPY b-loc-entr TO tt-loc-entr.
ASSIGN tt-loc-entr.situacao  = 0. /* Manuten‡Æo */

RAW-TRANSFER tt-loc-entr TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0191-out", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
    
/*
{esp/crm/escrm001.i} /* Definicaode temp-table */
{esp/crm/escrm001a.i1} /* Definicaode temp-table */

/* 
 run esp/es0669.p (input "yes",
                  "loc-entr",
                  b-loc-entr.nome-abrev,
                  string(b-loc-entr.cod-entrega),
                  "","","", "", "", "", "").
*/


/********************** Integracao do Ems para o CRM *****************/
IF  index(program-name(3),"cd0704") = 0 AND l-web-service = NO THEN DO:
    find first emitente no-lock where
               emitente.nome-abrev = b-loc-entr.nome-abrev no-error.           
    if avail emitente and emitente.identific <> 2 then do:
        RUN esp/crm/escrm001a.p (input "Loc-entr",
                                 input "W",
                                 input rowid(b-loc-entr),
                                 input table tt-raw-transfer).                               
    end.
end.
*/
RETURN "OK".
