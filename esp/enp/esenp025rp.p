{include/i-prgvrs.i ESENP025RP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/enp/esenp025tt.i}

/* recebimento de parƒmetros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.

create tt-param.
RAW-TRANSFER raw-param to tt-param NO-ERROR.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}

/* defini‡Æo de vari veis e streams */
def stream s-imp.
def var h-acomp  as handle no-undo.
def var c-linha  as char no-undo.
DEF VAR i-linha  AS INT NO-UNDO.
def var i-item   LIKE ITEM.it-codigo no-undo.
def var c-fabric as int no-undo.

define temp-table tt-erro
    field i-linha  as int
    FIELD c-fabric AS INT
    FIELD i-item   AS CHAR
    field c-erro   as char format "x(40)"
    field coment   as char format "x(40)"
    field tp-erro  as INT.

form
    tt-erro.i-linha at 10 column-label "Linha Arquivo"
    tt-erro.c-fabric      column-label "Fabricante"
    tt-erro.c-erro        column-label "Descri‡Æo Erro"
    tt-erro.coment        column-label "Coment rio"
    with frame f-erro-fabric no-box down no-attr-space width 132 stream-io.

form
    tt-erro.i-linha at 10 column-label "Linha Arquivo"
    tt-erro.i-item        column-label "ITEM      "
    tt-erro.c-erro        column-label "Descri‡Æo Erro"
    tt-erro.coment        column-label "Coment rio"
    with frame f-erro-item no-box down no-attr-space width 132 stream-io. 

form
    tt-erro.c-fabric at 10 column-label "Fabricante"
    tt-erro.i-item         column-label "ITEM      "
    tt-erro.coment         column-label "Coment rio"
    with frame f-importado no-box down no-attr-space width 132 stream-io.

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

find first param-global no-lock no-error. 

/* bloco principal do programa */
assign	c-programa 	= "ESENP025RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Importa‡Æo de Fabricantes".

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
	    assign c-fabric = integer(entry(1, c-linha, ";"))
               i-item   = entry(2, c-linha, ";").

        IF INT(c-fabric) = 0 THEN DO:
            create tt-erro.
            assign tt-erro.i-linha  = i-linha
                   tt-erro.c-fabric = c-fabric
                   tt-erro.c-erro   = "NÆo ‚ permitido importar Fabricante 0."
                   tt-erro.coment   = "NÆo ocorreu a Importa‡Æo"
                   tt-erro.tp-erro  = 1.
        END.
        
        if not can-find(first fabricante no-lock
                        where fabricante.cod-fabric = c-fabric) then do:
            create tt-erro.
            assign tt-erro.i-linha  = i-linha
                   tt-erro.c-fabric = c-fabric
                   tt-erro.c-erro   = "Fabricante nÆo cadastrado."
                   tt-erro.coment   = "NÆo ocorreu a Importa‡Æo"
                   tt-erro.tp-erro  = 1.
        
        end.
        
        if not can-find(first item no-lock
                        where item.it-codigo = i-item) then do:
            create tt-erro.
            assign tt-erro.i-linha = i-linha
                   tt-erro.i-item  = i-item
                   tt-erro.c-erro  = "Item inexistente."
                   tt-erro.coment  = "NÆo ocorreu a Importa‡Æo"
                   tt-erro.tp-erro = 2.
        
        end.
        
        if not CAN-FIND(FIRST tt-erro WHERE
                              tt-erro.i-linha = i-linha) THEN DO:
            FIND FIRST item-fabric EXCLUSIVE-LOCK
                 WHERE item-fabric.cod-fabric = c-fabric
                   AND item-fabric.it-codigo  = i-item NO-ERROR.
            IF NOT AVAIL item-fabric THEN DO:
                CREATE item-fabric.
                ASSIGN item-fabric.cod-fabric = c-fabric
                       item-fabric.it-codigo  = i-item.
            END.

            assign item-fabric.it-fabric  = entry(3, c-linha, ";")
                   item-fabric.ref-inter  = entry(4, c-linha, ";")
                   item-fabric.referencia = entry(5, c-linha, ";")
                   item-fabric.validade   = int(entry(6, c-linha, ";"))
                   item-fabric.etiqueta   = entry(7, c-linha, ";").
        
            create tt-erro.
            assign tt-erro.i-linha  = i-linha
                   tt-erro.c-fabric = c-fabric
                   tt-erro.i-item   = i-item
                   tt-erro.coment   = "Registro importado com sucesso."
                   tt-erro.tp-erro  = 3.
        
        end.
    END.
end.

input stream s-imp close.

for each tt-erro
   where (if tt-param.todos = 2 then tt-erro.tp-erro <> 3 else tt-erro.i-linha > 0)
    BREAK BY tt-erro.tp-erro:

    CASE tt-erro.tp-erro:
        WHEN 1 THEN DO:
            DISP STREAM str-rp
                tt-erro.i-linha
                tt-erro.c-fabric
                tt-erro.c-erro  
                tt-erro.coment  
                with frame f-erro-fabric.
                DOWN WITH FRAME f-erro-fabric.
        END.
        WHEN 2 THEN DO:
            DISP STREAM str-rp
                tt-erro.i-linha 
                tt-erro.i-item
                tt-erro.c-erro  
                tt-erro.coment  
                with frame f-erro-item.
                DOWN WITH FRAME f-erro-item.
        END.
        WHEN 3 THEN DO:
            DISP STREAM str-rp
                tt-erro.c-fabric
                tt-erro.i-item  
                tt-erro.coment  
                with frame f-importado.
                DOWN WITH FRAME f-importado.
        END.
    END CASE.

    IF LAST-OF(tt-erro.tp-erro) THEN
        PUT STREAM str-rp SKIP(1).
end.

/* fechamento do output do log */
{include/i-rpclo.i &STREAM="stream str-rp"}

run pi-finalizar in h-acomp.

return "Ok":U.
