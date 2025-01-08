/* include de controle de vers∆o */
{include/i-prgvrs.i escep044rp 1.00.00.000}

{esp\cep\escep044tt.i}    

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.
    

/* recebimento de parÉmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita no-lock.
    create tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
end.

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/* definiá∆o de vari†veis  */
DEFINE VARIABLE h-acomp   AS HANDLE     NO-UNDO.


/* include padr∆o para output de relat¢rios */
{include/i-rpout.i &STREAM="stream str-rp"}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
/* {include/i-rpcab.i &STREAM="str-rp"} */


{method/dbotterr.i}
    
       
/* a instaciaá∆o da bo deve ser feita apenas uma vez */   


/* bloco principal do programa */
ASSIGN  c-programa 	    = "escep044"
	    c-versao	    = "1.00"
	    c-revisao	    = ".00.000"
	    c-empresa    = "INTELBRAS"
	    c-sistema	    = "Especificos"
	    c-titulo-relat  = "Relatorio de Clientes para arquivo".


/* para n∆o visualizar cabeáalho/rodapÇ em sa°da RTF */
/* IF tt-param.destino <> 4 THEN DO: */
/*     VIEW STREAM str-rp FRAME f-cabec. */
/*     VIEW STREAM str-rp FRAME f-rodape. */
/* END. */

/* executando de forma persistente o utilit†rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).


def var i-ind        as int.
def var i-cod-emit   like emitente.cod-emit.
def var c-nome-emit  AS CHAR FORMAT "x(40)".

/* corpo do relat¢rio */

do i-ind = 1 to tt-param.n-copias:
                        
    put stream str-rp chr(027) + chr(038) + chr(108) + "1" + chr(069).

    put stream str-rp  "     DEPARTAMENTO FINANCEIRO - CADASTROS "  
               today format "99/99/9999" skip.

    put stream str-rp chr(027) + chr(038) + chr(97) + "1" + chr(076).
    put stream str-rp chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    put stream str-rp " " skip.
        
    assign i-cod-emit = 0
           c-nome-emit = "".
    for each tt-digita by tt-digita.nome-emit.
        if i-cod-emit <> 0 then do:
            put stream str-rp i-cod-emit "-"
                c-nome-emit  " "
                tt-digita.cod-emitente "-"
                tt-digita.nome-emit format "X(38)" skip.
                assign i-cod-emit = 0
                       c-nome-emit = "".
        end.
        else do:
            assign i-cod-emit  = tt-digita.cod-emitente
                   c-nome-emit = tt-digita.nome-emit.
        end.
    end. 
        
    if i-cod-emit <> 0 then
        put stream str-rp i-cod-emit "-"
            c-nome-emit format "x(38)".
    page.
end.

output close.
        
for each tt-digita:
    find first his-emit where
         his-emit.cod-emitente = tt-digita.cod-emitente and
         his-emit.dt-his-emit  = today and
         his-emit.horario = substr(string(time,"hh:mm"),1,2) +
                                  substr(string(time,"hh:mm"),4,2) no-error.
    if not avail his-emit then do:
        create his-emit. 
        assign his-emit.cod-emitente = tt-digita.cod-emitente
               his-emit.dt-his-emit  = today
               his-emit.horario = substring(string(time,"HH:MM"),1,2) +
                                       substring(string(time,"HH:MM"),4,2).
    end.
    assign his-emit.historico = his-emit.historico + " " + 
                                "Cadastro arquivado na caixa " +
                                string(tt-param.n-caixa,">>9").
               
    
end.




/*fechamento do output do relat¢rio*/
{include/i-rpclo.i &STREAM="stream str-rp"}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.
