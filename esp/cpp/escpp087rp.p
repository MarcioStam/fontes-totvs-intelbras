{include/i-prgvrs.i ESCPP087RP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp\cpp\escpp087tt.i}

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
def var c-n-serie   as char    no-undo.
def var c-item      as char    no-undo.
DEF VAR v-num-pedido LIKE pedido-compr.num-pedido.

define temp-table tt-erro
    field i-linha as int
    field c-erro  as char format "x(40)"
    field l-erro  as log.
                                               
form
    tt-erro.i-linha at 10 column-label "Linha"
    tt-erro.c-erro        column-label "Descri‡Æo Erro"
    with frame f-erro no-box down no-attr-space width 132 stream-io. 

def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.

def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

find first param-global no-lock no-error. 

/* bloco principal do programa */
assign	c-programa 	= "ESCPP087RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Importa‡Æo de S‚ries".

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
	    assign c-item    = entry(1, c-linha, ";")
               c-n-serie = entry(2, c-linha, ";").

        ASSIGN v-num-pedido = 0.

        If NUM-ENTRIES(c-linha, ";") > 2 then 
            ASSIGN v-num-pedido = int(entry(3, c-linha, ";")).

        IF v-num-pedido <> 0 THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = v-num-pedido NO-ERROR.

            IF NOT AVAIL pedido-compr THEN DO:
                create tt-erro.
                assign tt-erro.i-linha = i-linha
                       tt-erro.c-erro  = "Pedido " + STRING(v-num-pedido) + " inexistente."
                       tt-erro.l-erro  = yes.
            END.
        END.


        /*** Valida‡äes importa‡Æo ***/
        find first num-serie 
             where num-serie.n-serie = c-n-serie no-error.
        if avail num-serie then do:
            create tt-erro.
            assign tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Serial " + c-n-serie + " j  existe."
                   tt-erro.l-erro  = yes.
        end.

        if not can-find(first ITEM no-lock
                        where ITEM.it-codigo = c-item) then do:
            create tt-erro.
            assign tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Item " + c-item + " inexistente."
                   tt-erro.l-erro  = yes.

        end.
        /*** Fim das valida‡äes ***/
        
        if not CAN-FIND(FIRST tt-erro WHERE
                              tt-erro.i-linha = i-linha) THEN DO:
            CREATE num-serie.
            ASSIGN num-serie.n-serie     = c-n-serie
                   num-serie.it-codigo   = c-item
                   num-serie.ano         = YEAR(TODAY)
                   num-serie.semana      = INTERVAL(TODAY, DATE(01, 01, YEAR(TODAY)), "weeks") + 1
                   num-serie.sequencia   = 0
                   num-serie.num-pedido  = v-num-pedido
                   num-serie.sigla       = ""
                   num-serie.cod-estabel = v_cod_estab_usuar  
                   num-serie.data        = NOW
                   num-serie.usuario     = c-seg-usuario
                   num-serie.re-impr     = 0
                   num-serie.dt-ult-re   = ?
                   num-serie.us-ult-re   = ?
                   num-serie.motiv-re    = ?
                   num-serie.ns-keycode  = "".

            create tt-erro.
            assign tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Registro importado com sucesso."
                   tt-erro.l-erro  = no.
        
        end.
    END.
end.

input stream s-imp close.

for each tt-erro
   where (if tt-param.todos = 2 then tt-erro.l-erro else tt-erro.i-linha > 0):
    DISP STREAM str-rp
        tt-erro.i-linha
        tt-erro.c-erro
        with frame f-erro.
        DOWN WITH FRAME f-erro.
end.

/* fechamento do output do log */
{include/i-rpclo.i &STREAM="stream str-rp"}

run pi-finalizar in h-acomp.

return "Ok":U.
