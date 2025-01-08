{include/i-prgvrs.i esftp210dRP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/ftp/esftp210dtt.i}

/* recebimento de parƒmetros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.

create tt-param.
RAW-TRANSFER raw-param to tt-param NO-ERROR.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}
{include/i-freeac.i}

/* defini‡Æo de vari veis e streams */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp           AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-linha           AS CHAR      NO-UNDO.
DEFINE VARIABLE i-linha           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-item-serie      AS CHAR      NO-UNDO.
DEFINE VARIABLE d-quantidade      AS DEC       NO-UNDO.
DEFINE VARIABLE v-qtd-devol       AS DEC       NO-UNDO.
DEFINE VARIABLE i-seq-item        AS INTEGER   NO-UNDO.
DEFINE VARIABLE de-saldo-it       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE qtde-comprometida AS DECIMAL   NO-UNDO.
DEFINE VARIABLE qt-acum           AS DECIMAL   NO-UNDO.

DEFINE BUFFER b-int-simula-dev-it FOR int-simula-dev-it.

DEFINE NEW GLOBAL SHARED VAR vg-row-int-simula-dev  AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-int-simula-dev-it-glob NO-UNDO LIKE int-simula-dev-it
   FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota.

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD i-linha   AS INT
    FIELD quantidade AS DEC.

define temp-table tt-erro
    field i-linha as int
    field c-erro  as char format "x(110)"
    field l-erro  as log.
                                               
form
    tt-erro.i-linha at 1  column-label "Linha"
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
assign	c-programa 	= "esftp210dRP"
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
REPEAT ON STOP UNDO, LEAVE:
    ASSIGN i-linha = i-linha + 1.
    IMPORT STREAM s-imp UNFORMATTED c-linha.
    
	RUN pi-acompanhar IN h-acomp (INPUT i-linha).

    IF i-linha <> 1 THEN DO:
	    ASSIGN c-item-serie = ENTRY(1, c-linha, ";")
               d-quantidade = DEC(ENTRY(2, c-linha, ";")).

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = c-item-serie NO-ERROR.

        IF NOT AVAIL ITEM THEN DO:
            FIND FIRST num-serie-rast NO-LOCK
                 WHERE num-serie-rast.n-serie = c-item-serie NO-ERROR.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = num-serie-rast.it-codigo NO-ERROR.
        END.
        
        IF NOT AVAIL ITEM THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Item nÆo encontrado com o c¢digo/s‚rie informado: " + c-item-serie + "."
                   tt-erro.l-erro  = YES.
        END.

        IF d-quantidade <= 0 THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Quantidade deve ser maior que 0, item:: " + c-item-serie + "."
                   tt-erro.l-erro  = YES.
        END.
        
        IF NOT CAN-FIND(FIRST tt-erro WHERE
                              tt-erro.i-linha = i-linha) THEN DO:
            
            IF NOT CAN-FIND (FIRST tt-itens
                             WHERE tt-itens.it-codigo = ITEM.it-codigo) THEN DO:

                CREATE tt-itens.
                ASSIGN tt-itens.it-codigo = ITEM.it-codigo
                       tt-itens.i-linha   = i-linha.
            END.

            ASSIGN tt-itens.quantidade = tt-itens.quantidade + d-quantidade.
        END.
    END.
END.

EMPTY TEMP-TABLE tt-int-simula-dev-it-glob.

FIND FIRST int-simula-dev NO-LOCK
     WHERE ROWID(int-simula-dev) = vg-row-int-simula-dev NO-ERROR.

FIND LAST int-simula-dev-it NO-LOCK
    WHERE int-simula-dev-it.cod-emitente = int-simula-dev.cod-emitente
      AND int-simula-dev-it.dt-simula    = int-simula-dev.dt-simula
      AND int-simula-dev-it.nr-sequencia = int-simula-dev.nr-sequencia NO-ERROR.

IF AVAIL int-simula-dev-it THEN
    ASSIGN i-seq-item = int-simula-dev-it.nr-seq-it.

FOR EACH tt-itens:

    ASSIGN v-qtd-devol = tt-itens.quantidade
           qt-acum     = 0.

    FOR EACH it-nota-fisc USE-INDEX ch-item-nota NO-LOCK
       WHERE it-nota-fisc.it-codigo = tt-itens.it-codigo,
       FIRST nota-fiscal OF it-nota-fisc 
       WHERE nota-fiscal.cod-emit   = int-simula-dev.cod-emit
         AND nota-fiscal.cod-estabel = int-simula-dev.cod-estabel
         AND nota-fiscal.dt-cancela = ? 
         AND nota-fiscal.dt-entr-cli <> ?
          BY nota-fiscal.dt-emis-nota DESC
          BY it-nota-fisc.nr-seq-fat:

        RUN pi-acompanhar IN h-acomp (INPUT "Emitente:" + STRING(nota-fiscal.cod-emit) + " " + "Data: " + STRING(nota-fiscal.dt-emis-nota)).

        IF  nota-fiscal.emite-dup = YES 
        AND int-simula-dev.id-tipo-nota = 2 THEN 
            NEXT.

        IF  nota-fiscal.emite-dup = NO
        AND int-simula-dev.id-tipo-nota = 1 THEN 
            NEXT.

        ASSIGN de-saldo-it = it-nota-fisc.qt-faturada[1].

        FOR EACH devol-cli
           WHERE devol-cli.cod-estabel = it-nota-fisc.cod-estabel  
             AND devol-cli.serie       = it-nota-fisc.serie  
             AND devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis  
             AND devol-cli.it-codigo   = it-nota-fisc.it-codigo
             AND devol-cli.nr-seq      = it-nota-fisc.nr-seq-fat NO-LOCK:
           ASSIGN de-saldo-it = de-saldo-it - devol-cli.qt-devol.    
        END.

        ASSIGN qtde-comprometida = 0.    
        
        FOR EACH b-int-simula-dev-it
           WHERE b-int-simula-dev-it.cod-estabel-origem = it-nota-fisc.cod-estabel 
             AND b-int-simula-dev-it.serie-origem = it-nota-fisc.serie  
             AND b-int-simula-dev-it.nr-nota-origem = it-nota-fisc.nr-nota-fis  
             AND b-int-simula-dev-it.it-codigo = it-nota-fisc.it-codigo:

            ASSIGN qtde-comprometida = qtde-comprometida + b-int-simula-dev-it.qt-devolvida.
        END.

        ASSIGN de-saldo-it = de-saldo-it - qtde-comprometida.

        IF de-saldo-it <= 0 THEN
            NEXT.

        ASSIGN i-seq-item = i-seq-item + 1.
        
        CREATE tt-int-simula-dev-it-glob.
        ASSIGN tt-int-simula-dev-it-glob.cod-emitente = int-simula-dev.cod-emitente
               tt-int-simula-dev-it-glob.dt-simula    = int-simula-dev.dt-simula
               tt-int-simula-dev-it-glob.it-codigo    = tt-itens.it-codigo
               tt-int-simula-dev-it-glob.nr-seq-it    = i-seq-item
               tt-int-simula-dev-it-glob.nr-sequencia = int-simula-dev.nr-sequencia
               tt-int-simula-dev-it-glob.observacao   = nota-fiscal.observ-nota
               tt-int-simula-dev-it-glob.qt-devolvida = IF qt-acum + de-saldo-it >= v-qtd-devol THEN v-qtd-devol - qt-acum ELSE de-saldo-it
               tt-int-simula-dev-it-glob.vl-cofins    = (it-nota-fisc.vl-finsocial * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it-glob.vl-icms      = (it-nota-fisc.vl-icms-it   * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it-glob.vl-icmsdifal = 0 /*(it-nota-fisc.vl-finsocial * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]*/
               tt-int-simula-dev-it-glob.vl-icmsst    = (it-nota-fisc.vl-icmsub-it * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it-glob.vl-ipi       = (it-nota-fisc.vl-ipi-it * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it-glob.vl-pis       = (it-nota-fisc.vl-pis * tt-int-simula-dev-it-glob.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it-glob.vl-tot-it    = (it-nota-fisc.vl-tot-item / it-nota-fisc.qt-faturada[1]) * tt-int-simula-dev-it-glob.qt-devolvida
               tt-int-simula-dev-it-glob.vl-unitario  = it-nota-fisc.vl-preuni
               tt-int-simula-dev-it-glob.nr-nota-origem  = nota-fiscal.nr-nota-fis
               tt-int-simula-dev-it-glob.cod-estabel-origem  = nota-fiscal.cod-estabel
               tt-int-simula-dev-it-glob.serie-origem        = nota-fiscal.serie
               tt-int-simula-dev-it-glob.dt-emis-nota = nota-fiscal.dt-emis-nota.

        ASSIGN qt-acum = qt-acum + de-saldo-it.

        IF  v-qtd-devol <= qt-acum THEN 
            LEAVE.
    END.

    IF v-qtd-devol > qt-acum THEN DO:

        CREATE tt-erro.
        ASSIGN tt-erro.i-linha = tt-itens.i-linha
               tt-erro.c-erro  = "NÆo foram encontradas notas suficientes para devolver a quantia " + STRING(v-qtd-devol) + " Item: " + tt-itens.it-codigo + " Quantia encontrada: " + STRING(qt-acum)
               tt-erro.l-erro  = NO.
    END.
    ELSE DO:
        CREATE tt-erro.
        ASSIGN tt-erro.i-linha = tt-itens.i-linha
               tt-erro.c-erro  = "Quantidade " + STRING(v-qtd-devol) + " Item: " + tt-itens.it-codigo + " importada com sucesso.".
               tt-erro.l-erro  = NO.
    END.
END.

INPUT STREAM s-imp CLOSE.
  
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
