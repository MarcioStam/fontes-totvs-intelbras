DEF VAR c-sequencia AS CHAR NO-UNDO.
DEF VAR c-nome AS CHAR FORMAT "X(100)" NO-UNDO.
DEF VAR c-cgc LIKE emitente.cgc NO-UNDO.
DEF VAR c-ie LIKE emitente.ins-estadual NO-UNDO.
DEF VAR c-cep LIKE emitente.cep NO-UNDO.
DEF VAR c-cidade LIKE emitente.cidade NO-UNDO.
DEF VAR c-uf LIKE emitente.estado NO-UNDO.
DEF VAR c-identific AS CHAR FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mercado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cli-contribuinte AS CHARACTER   NO-UNDO.
DEF VAR c-ins-estadual AS CHAR no-undo.
DEFINE VARIABLE c-insc-municipal AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-suframa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco AS CHARACTER  FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE c-nro-end  AS CHARACTER FORMAT "X(100)"  NO-UNDO.
DEFINE VARIABLE c-fone-1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fone-2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comple-endereco AS CHARACTER FORMAT "X(100)"   NO-UNDO.
DEFINE VARIABLE c-bairro  AS CHARACTER  FORMAT "X(100)"  NO-UNDO.

DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pais AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ativo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
DEF STREAM s-import.
DEF STREAM s-export.
DEF STREAM s-export2.
function get_cgc returns char:
    def var i as int no-undo.
    def var c-aux as char no-undo.
    def var c-result as char no-undo.
    c-aux = c-cgc.
    do i = 1 to length(c-cgc):
        if substring(c-cgc, i, 1) >= "0" and substring(c-cgc, i, 1) <= "9" then
            c-result = c-result + substring(c-cgc, i, 1).
    end.

    return c-result.
end function.   
input stream s-import from value("C:\temp\cliente_automatiza.csv") CONVERT SOURCE SESSION:CHARSET.

OUTPUT STREAM s-export TO c:\temp\cliente_conta_nao_achou.lst. /*CONVERT TARGET "iso8859-1".*/
OUTPUT STREAM s-export2 TO c:\temp\cliente_conta_achou.lst. /*CONVERT TARGET "iso8859-1".*/

repeat on error undo, leave
       on stop undo, leave transaction:
    assign c-sequencia = "" 
           c-nome = ""
           c-cgc  = ""
           c-ie = ""
           c-cidade = ""
           c-uf = "".

    import stream s-import delimiter ";" 
        c-sequencia c-tipo c-nome c-cli-contribuinte c-ins-estadual c-insc-municipal c-cgc c-suframa c-endereco  c-fone-1 c-fone-2 
        c-comple-endereco c-cep c-bairro c-cidade c-uf c-pais c-email c-nro-end.
    ASSIGN c-cgc = get_cgc().
    FIND emitente
        WHERE emitente.cgc = substring(c-cgc,1,18) NO-LOCK NO-ERROR.
    IF NOT AVAIL emitente THEN DO:
        ASSIGN i-cont = i-cont + 1.
        PUT STREAM s-export "Nao encontrou " c-cgc " " c-sequencia " " c-nome " " c-cidade " " c-uf " " c-pais " " i-cont SKIP.
    END.
    ELSE
        PUT STREAM s-export2 "Encontrado " emitente.cod-emitente " "  emitente.cgc " " emitente.nome-emit " "  emitente.identific SKIP.

END.
