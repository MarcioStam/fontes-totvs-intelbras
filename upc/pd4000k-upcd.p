/***********************************************************************
**  Programa..: UPC\PD4000K-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Cancela programa Alocaá∆o e desfaz reporte
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Variaveis    ****************************/
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtCancel        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalCancel   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR vOrdensGeradas    AS CHAR NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

IF  whBtLocalCancel:SENSITIVE THEN DO:
    DO iCont = 1 TO NUM-ENTRIES(vOrdensGeradas):
/*        MESSAGE ENTRY(iCont, vOrdensGeradas)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = int(ENTRY(iCont, vOrdensGeradas))
            AND   ord-prod.estado       = 7: /* Terminada */
            RUN esapi\esapi009.p (INPUT ord-prod.nr-ord-produ).
        END.
    END.
    APPLY "CHOOSE" TO whBtCancel.
END.
