/********************************************************************************
**  Programa: WM9121-UPC.P                                                     **
**  Data....: Marco de 2015                                                    **
**  Autor...: SCM Concept Tecnologia da Inf Ltda                               **
**  Objetivo: Tratamento Desassociacao DOCA                                    **
**                                                                             **
********************************************************************************/
{include/i-epc200.i} /* Definicao tt-epc            */
{METHOD/dbotterr.i}

/* Definicao de Parametros */
DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

IF p-ind-event = "Inicio" THEN DO:
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "Inicio"
           tt-epc.cod-parameter = "Return"
           tt-epc.val-parameter = "ReturnOK".

END.

RETURN "OK":U.
