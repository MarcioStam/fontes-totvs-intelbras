DEFINE INPUT PARAM p-dir-import AS CHAR.

DEFINE TEMP-TABLE tt-erro
    FIELD descricao AS CHAR.

DEFINE VARIABLE c-cod-estabel             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-serie                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo               AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-sit-tributar-pis    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-sit-tributar-cofins AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-acomp             AS HANDLE    NO-UNDO.

DEFINE STREAM s-import.

INPUT STREAM s-import FROM VALUE(p-dir-import) NO-CONVERT.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Executando.").

REPEAT ON ERROR UNDO, LEAVE
       ON STOP UNDO, LEAVE TRANSACTION:
    ASSIGN c-cod-estabel             = "" 
           c-serie                   = ""
           c-nr-nota-fis             = ""
           c-it-codigo               = ""
           c-cod-sit-tributar-pis    = ""
           c-cod-sit-tributar-cofins = "" .

    IMPORT STREAM s-import DELIMITER ";"
        c-cod-estabel            
        c-serie                  
        c-nr-nota-fis            
        c-it-codigo              
        c-cod-sit-tributar-pis   
        c-cod-sit-tributar-cofins.

    IF LENGTH(c-nr-nota-fis) < 7 THEN
        ASSIGN c-nr-nota-fis = FILL("0", 7 - LENGTH(c-nr-nota-fis)) + c-nr-nota-fis.
    
    IF LENGTH(c-cod-sit-tributar-pis) = 1 THEN
        ASSIGN c-cod-sit-tributar-pis = "0" + c-cod-sit-tributar-pis.

    IF LENGTH(c-cod-sit-tributar-cofins) = 1 THEN
        ASSIGN c-cod-sit-tributar-cofins = "0" + c-cod-sit-tributar-cofins.

    IF c-cod-estabel BEGINS "Estab" THEN NEXT.

    IF c-it-codigo = "" THEN
        LEAVE.

    FIND FIRST it-nota-fisc EXCLUSIVE-LOCK
        WHERE it-nota-fisc.cod-estabel = c-cod-estabel 
          AND it-nota-fisc.serie       = c-serie
          AND it-nota-fisc.nr-nota-fis = c-nr-nota-fis 
          AND it-nota-fisc.it-codigo   = c-it-codigo NO-ERROR.

    IF NOT AVAIL it-nota-fisc THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "ITEM da nota: " + c-cod-estabel + "/" + c-serie + "/" + c-nr-nota-fis + "/" + c-it-codigo + " nÆo encontrada".
        NEXT.
    END.

    RUN pi-acompanhar IN h-acomp (INPUT c-cod-estabel + " " + c-nr-nota-fis + " " + c-it-codigo).

    ASSIGN it-nota-fisc.cod-sit-tributar-cofins = c-cod-sit-tributar-cofins
           it-nota-fisc.cod-sit-tributar-pis    = c-cod-sit-tributar-pis.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    OUTPUT TO VALUE (SESSION:TEMP-DIR + "erros_import.txt").
    FOR EACH tt-erro:
        PUT UNFORMATTED tt-erro.descricao SKIP.
    END.
    OUTPUT CLOSE.
    RUN WinExec (INPUT 'notepad.exe' + chr(32) + SESSION:TEMP-DIR + "erros_import.txt", 
                 INPUT 1). 

END.

RUN pi-finalizar IN h-acomp. 

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
