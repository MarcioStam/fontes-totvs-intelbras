/********************************************************************************
 ** UPC........: win172.p - UPC WRITE reservas
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es dos itens para a Base Oracle
 
compile \\tsclient\c\fontes\esp\trgw\win271.p save into c:\temp\esp\trgw.
 
 ********************************************************************************/

{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEF PARAM BUFFER b-ord-prod      FOR ord-prod.
DEF PARAM BUFFER b-old-ord-prod  FOR ord-prod.
/* Emerson - Log n∆o Ç mais necessario
DEF VAR v_cod_arq_erro AS CHAR NO-UNDO.
DEF VAR v_reserva AS CHAR NO-UNDO.
DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2. 
DEFINE VARIABLE plist AS CHARACTER NO-UNDO FORMAT "x(70)".
DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.


EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

ASSIGN v_cod_arq_erro = c-dir + "spool/em043280/ordprod/criaOP.txt":U.

IF NEW b-ord-prod THEN DO:

    IF CAN-FIND( FIRST reserva 
                 WHERE reserva.nr-ord-produ = b-ord-prod.nr-ord-produ) THEN
        ASSIGN v_reserva = "SIM".
    ELSE
        ASSIGN v_reserva = "NAO".
    
    
    OUTPUT TO VALUE(v_cod_arq_erro) APPEND.
    
    PUT "OP :" b-ord-prod.nr-ord-produ skip
        "Item :" b-ord-prod.it-codigo  SKIP
        "QtdOP :" b-ord-prod.qt-ordem  SKIP
        "Usuario :" v_cod_usuar_corren SKIP
        "Reserva? :" v_reserva SKIP.
    
    FORM plist  WITH FRAME what-prog OVERLAY ROW 10 CENTERED 5 DOWN NO-LABELS  TITLE " Program Trace ". 
    
    DO WHILE PROGRAM-NAME(ix) <> ?:  
        IF ix = 2 THEN     
        plist = "Currently in       : " + PROGRAM-NAME(ix).  
        ELSE     plist = "Which was called by: " + PROGRAM-NAME(ix).   
        ix = ix + 1.  
        PUT plist SKIP.
    END. 
    PUT SKIP(2).
    
    OUTPUT CLOSE.
END.
*/

RETURN "ok".

/*    
DEF PARAM BUFFER b-reservas      FOR reservas.
DEF PARAM BUFFER b-old-reservas  FOR reservas.
DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
DEFINE VARIABLE C-ALTERACAO AS char format "x(35)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-atu AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-ant AS char format "x(15)" no-undo initial ''.


if b-reservas.quant-orig <> 0 then do:
message v_cod_estab_usuar view-as alert-box.
end.




IF b-old-reservas.it-codigo = ""  and
   b-reservas.it-codigo <> "" THEN DO:
    RUN pi-manda-email-reservas-novo.
END.


IF b-old-reservas.quant-orig <> b-reservas.quant-orig THEN DO:
    message "reserva alterada" view-as alert-box.
END.
*/



/*
IF b-reservas.perm-saldo-neg <> 1 and v_cod_estab_usuar = "102" and
   b-reservas.desc-reservas <> ""


THEN DO:
     assign c-alteracao = "Permite Saldo Negativo liberado".
     run pi-manda-email-reservas-alterado.                   
 
end.

IF b-reservas.class-fiscal <> b-old-reservas.class-fiscal and v_cod_estab_usuar = "102" and
   b-reservas.desc-reservas <> ""

THEN DO:
     assign c-alteracao  = "Class Fiscal Alterada"
            c-fiscal-atu = b-reservas.class-fiscal
            c-fiscal-ant = b-old-reservas.class-fiscal.
     
     run pi-manda-email-reservas-alterado.                   
     
end.

*/
     
    
  
