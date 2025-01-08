/********************************************************************************
 ** UPC........: wad187- UPC WRITE tab-finan
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/
DEF PARAM BUFFER b-tab-finan      FOR tab-finan.
DEF PARAM BUFFER b-old-tab-finan  FOR tab-finan.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-tab-finan TO raw-param.
{esp/esb/esesb006.i 'msg0044' 'wdi187' 'tab-finan'}

/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

DEF VAR i-cont AS INTEGER NO-UNDO.


/********************** Integracao do Ems para o CRM *****************/
IF  NEW b-tab-finan                                       OR
    b-old-tab-finan.dt-ini-val  <> b-tab-finan.dt-ini-val OR
    b-old-tab-finan.dt-fim-val  <> b-tab-finan.dt-fim-val THEN DO:
    RUN esp/crm/escrm001a.p (input "tab-finan",
                             input "W",
                             input rowid(b-tab-finan),
                             input table tt-raw-transfer).
END.

IF  NEW b-tab-finan THEN DO:
    RUN esp/crm/escrm001a.p (input "ind-tab-finan",
                             input "W",
                             input rowid(b-tab-finan),
                             input table tt-raw-transfer).
END.
ELSE DO:
    DO i-cont = 1 TO 12:
        IF  b-old-tab-finan.tab-dia-fin[i-cont] <> b-tab-finan.tab-dia-fin[i-cont]     OR
            b-old-tab-finan.tab-ind-fin[i-cont] <> b-old-tab-finan.tab-ind-fin[i-cont] THEN DO:
            RUN esp/crm/escrm001a.p (input "ind-tab-finan",
                                     input "W",
                                     input rowid(b-tab-finan),
                                     input table tt-raw-transfer).
        END.
    END.
END.
*/
