{include/i-prgvrs.i ESCDP069RP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/cdp/escdp069tt.i}

/* recebimento de parƒmetros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.

create tt-param.
RAW-TRANSFER raw-param to tt-param NO-ERROR.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}
{include/i-freeac.i}

/* defini‡Æo de vari veis e streams */
def stream s-imp.
def var h-acomp     as handle  no-undo.
def var c-linha     as char    no-undo.
DEF VAR i-linha     as integer no-undo.
def var c-aba       as char    no-undo.
def var i-emitente  as integer no-undo.
def var i-itiner    as integer no-undo.
def var i-pto-contr as integer no-undo.
def var c-incoterm  as char    no-undo.
def var c-idioma    as char    no-undo.

define temp-table tt-erro
    field i-linha    as int
    field i-emitente as int 
    field c-erro     as char format "x(40)"
    field l-erro     as log.
                                               
form
    tt-erro.i-emitente            at 15 column-label "Fornecedor"
    tt-erro.c-erro                      column-label "Motivo"
    with frame f-erro-fornec no-box down no-attr-space width 132 stream-io. 

form 
    tt-erro.i-emitente            at 15 column-label "Fornecedor"
    with frame f-importado no-box down no-attr-space width 132 stream-io.

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

find first param-global no-lock no-error. 

/* bloco principal do programa */
assign	c-programa 	= "ESCDP069RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Importa‡Æo de Fornecedores Internacionais".

view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando *}

run pi-inicializar in h-acomp (input RETURN-VALUE).

/* define o arquivo de entrada informando na p gina de parƒmetros */
input stream s-imp FROM value(tt-param.arq-entrada).

/* bloco principal do programa */
repeat on stop undo, leave:
    assign i-linha = i-linha + 1.
    import stream s-imp unformatted c-linha.
    
	run pi-acompanhar in h-acomp (input i-linha).

    IF i-linha <> 1 THEN DO:
	    assign i-emitente  = integer(entry(1, c-linha, ";"))
               c-aba       =         entry(2, c-linha, ";")
               i-itiner    = integer(entry(3, c-linha, ";"))
               i-pto-contr = integer(entry(4, c-linha, ";"))
               c-incoterm  =         entry(5, c-linha, ";")
               c-idioma    = fn-free-accent(entry(6, c-linha, ";")).

        /*** Valida‡äes importa‡Æo ***/
        find first emitente no-lock
             where emitente.cod-emitente = i-emitente no-error.
        if not avail emitente then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "Fornecedor inexistente no cadastro CD0401"
                   tt-erro.l-erro     = yes.

        end.
        else do:
            if emitente.natureza <> 3 then do:
                create tt-erro.
                assign tt-erro.i-linha    = i-linha
                       tt-erro.i-emitente = i-emitente
                       tt-erro.c-erro     = "Fornecedor Nacional no cadastro CD0401"
                       tt-erro.l-erro     = yes.

            end.
        end.
        
        if not can-find(first itinerario no-lock
                        where itinerario.cod-itiner = i-itiner) then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "Itiner rio inexistente no cadastro CD2567"
                   tt-erro.l-erro     = yes.
        
        end.

        if not can-find(first pto-contr no-lock
                        where pto-contr.cod-pto-contr = i-pto-contr) then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "Ponto de Controle Base inexistente no cadastro CD2566"
                   tt-erro.l-erro     = yes.
        
        end.

        if not can-find(first pto-itiner no-lock
                        where pto-itiner.cod-itiner    = i-itiner
                          and pto-itiner.cod-pto-contr = i-pto-contr) then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "Ponto de controle Base nÆo est  contido no itiner rio " + string(i-itiner)
                   tt-erro.l-erro     = yes.

        end.

        if not can-find(first inco-cx no-lock
                        where inco-cx.cod-incoterm = c-incoterm) then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "INCOTERM inexistente no cadastro CD2554"
                   tt-erro.l-erro     = yes.
        
        end.

        if not can-find(first idioma no-lock
                        where idioma.cod_idioma = c-idioma) then do:
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.c-erro     = "Idioma inexistente no programa Idioma EMS5"
                   tt-erro.l-erro     = yes.
        
        end.
        /*** Fim das valida‡äes ***/
        
        if not can-find(first tt-erro where
                              tt-erro.i-linha = i-linha) then do:
            FIND FIRST emitente-cex EXCLUSIVE-LOCK
                 WHERE emitente-cex.cod-emitente = i-emitente NO-ERROR.
            IF NOT AVAIL emitente-cex THEN DO:
                CREATE emitente-cex.
                ASSIGN emitente-cex.cod-emitente = i-emitente.
            END.

            assign emitente-cex.cod-aba          = c-aba      
                   emitente-cex.cod-itiner-imp   = i-itiner   
                   emitente-cex.cod-pto-contr    = i-pto-contr
                   emitente-cex.cod-incoterm-imp = c-incoterm 
                   emitente-cex.cod-idioma       = c-idioma.   
        
            create tt-erro.
            assign tt-erro.i-linha    = i-linha
                   tt-erro.i-emitente = i-emitente
                   tt-erro.l-erro     = no.
        
        end.
    END.
end.

input stream s-imp close.

for each tt-erro
   where (if tt-param.todos = 2 then tt-erro.l-erro else tt-erro.i-linha > 0)
break by tt-erro.l-erro:

    if tt-erro.l-erro then do:
        if first-of(tt-erro.l-erro) then
            put stream str-rp "Fornecedores nÆo Importados" at 10 skip.

        DISP STREAM str-rp
            tt-erro.i-emitente
            tt-erro.c-erro
            with frame f-erro-fornec.
            DOWN WITH FRAME f-erro-fornec.

        if last-of(tt-erro.l-erro) then
            put stream str-rp skip(1).

    end.
    else do:
        if first-of(tt-erro.l-erro) then
            put stream str-rp "Fornecedores Importados com sucesso" at 10 skip.

        DISP STREAM str-rp
            tt-erro.i-emitente
            with frame f-importado.
            DOWN WITH FRAME f-importado.

        if last-of(tt-erro.l-erro) then
            put stream str-rp skip(1).
    end.
end.

/* fechamento do output do log */
{include/i-rpclo.i &STREAM="stream str-rp"}

run pi-finalizar in h-acomp.

return "Ok":U.
