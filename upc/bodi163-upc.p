/*****************************************************************************
** Programa: upc\bodi163-upc.p
** VersÆo..: 1.00
** Data....: 07/04/2021
** Autor...: Isac Abrahao
** Obs.....: UPC respons vel em permitir a inclusao de itens nao faturaveis 
             na tabelas de preco - Chamado C2102-1053 
*****************************************************************************/

/*--- Defini‡Æo dos Parƒmetros ---*/
{include/i-epc200.i1}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

/* definicao de temp-tables */
Def Temp-table RowErros no-undo
    Field errorSequence         As Int
    Field errorNumber           As Int
    Field errorDescription      As Char
    Field errorParameters       As Char
    Field errorType             As Char
    Field errorHelp             As Char
    Field errorsubtype          As Char.

Def Temp-table RowObject No-undo Like preco-item
    Field r-rowid               As Rowid.

DEFINE NEW GLOBAL SHARED VARIABLE h-bodi163 AS HANDLE NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

FOR EACH tt-epc WHERE tt-epc.cod-event = pIndEvent :

    /*
    MESSAGE tt-epc.cod-event   SKIP 
            tt-epc.cod-parameter
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

    If tt-epc.cod-event     = "AfterValidateRecord" And
       tt-epc.cod-parameter = "Object-Handle"       Then Do:
       Assign h-bodi163  = Widget-handle(tt-epc.val-parameter).
    End.

    If tt-epc.cod-event     = 'AfterValidateRecord' And 
       tt-epc.cod-parameter = 'Row-Object'          Then Do:   

        Run getRowErrors In h-bodi163 (OUTPUT TABLE RowErros).

        FIND FIRST RowErros WHERE RowErros.errorNumber = 5397 /*Item nao Faturavel*/ NO-ERROR.
        
        IF AVAIL RowErros THEN DO:
        
           ASSIGN i-cont = 0.

           FOR EACH RowErros:
               ASSIGN i-cont = i-cont + 1.
           END.    
        
           IF i-cont = 1 THEN
              Run EmptyRowErrors In h-bodi163.
        END.
    END.  

END. //FOR EACH tt-epc 


RETURN "OK":U.
