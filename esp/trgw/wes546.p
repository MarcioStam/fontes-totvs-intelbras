TRIGGER PROCEDURE FOR WRITE OF crm-categoria.

/********************************************************************************
** UPC........: wes546.p - UPC WRITE crm-categoria
** Data.......: Setembro / 2010
** Objetivo...: Repassa inclusäes e modifica‡äes da categoria para o CRM
********************************************************************************/

{esp/esb/esesb000.i}

DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-crm-categoria LIKE crm-categoria
     FIELD situacao AS INTEGER.

CREATE tt-crm-categoria.
ASSIGN tt-crm-categoria.cd-categoria = crm-categoria.cd-categoria
       tt-crm-categoria.ds-categoria = crm-categoria.ds-categoria
       tt-crm-categoria.situacao     = 0 /* Manuten‡Æo */.

RAW-TRANSFER tt-crm-categoria TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0190", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

RETURN "OK".



/* {esp/crm/escrm001.i}                                    */
/* {esp/crm/escrm001a.i1}                                  */
/*                                                         */
/*                                                         */
/* run esp/crm/escrm001a.p (input "Crm-categoria",         */
/*                          input "W",                     */
/*                          input rowid(crm-categoria),    */
/*                          input table tt-raw-transfer).  */
/*                                                         */
