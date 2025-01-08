
/*

    Excel de Entrada
    Estrutura Automatiza
    c:\temp\Automatiza\ListaEstruturaAutomatiza.csv.
    Campos: Item Pai; Item Filho; Quantidade; Fantasma (Sim/NÆo)
    
    ------------------------------------------------------------
    
    Excel de Entrada
    De-Para Itens Automatiza / EMS
    c:\temp\Automatiza\de-para-automatiza.csv
    Campos: Item Automatiza; Item EMS
    
    ------------------------------------------------------------
    
    Arquivo de Sa¡da
    Layout para Importa‡Æo no EN0113
    c:\temp\Automatiza\layout-en0113-automatiza.lst
    
    ------------------------------------------------------------
    
    Arquivo de Sa¡da
    Erros
    c:\temp\Automatiza\automatiza-erros-importacao.txt.
    
*/

DEFINE VARIABLE c-arq-estrutura AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-de-para   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-erros     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-linha     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq AS INTEGER     INIT 10 NO-UNDO.
DEFINE VARIABLE d-qtd AS DEC   NO-UNDO.
DEFINE VARIABLE l-erro AS LOGICAL     INIT NO NO-UNDO.

DEFINE TEMP-TABLE tt-de-para
    FIELD it-automatiza  AS CHAR
    FIELD it-ems         AS CHAR.

DEFINE TEMP-TABLE tt-estrut-origem
    FIELD it-codigo AS CHAR FORMAT "X(16)"
    FIELD es-codigo AS CHAR FORMAT "X(16)"
    FIELD qtde      AS DECIMAL
    FIELD fantasma  AS CHAR FORMAT "X(01)"
    INDEX id
          it-codigo
          es-codigo.

DEFINE TEMP-TABLE tt-estrut
    FIELD tipo          AS CHAR FORMAT "X(01)"
    FIELD it-codigo     AS CHAR FORMAT "X(16)"
    FIELD sequencia     AS CHAR FORMAT "X(05)"
    FIELD seq-int       AS INT
    FIELD es-codigo     AS CHAR FORMAT "X(16)"
    FIELD revisao       AS CHAR FORMAT "X(08)"
    FIELD fantasma      AS CHAR FORMAT "X(01)"
    FIELD fat-perda     AS CHAR FORMAT "X(04)"
    FIELD proporc       AS CHAR FORMAT "X(05)"
    FIELD serie-ini     AS CHAR FORMAT "X(12)"
    FIELD serie-fim     AS CHAR FORMAT "X(12)"
    FIELD quant         AS CHAR FORMAT "X(16)"
    FIELD tempo-res     AS CHAR FORMAT "X(04)"
    FIELD data-ini      AS CHAR FORMAT "X(08)"
    FIELD data-fim      AS CHAR FORMAT "X(08)"
    FIELD cod-roteiro   AS CHAR FORMAT "X(16)"
    FIELD op-codigo     AS CHAR FORMAT "X(05)"
    FIELD local-montag  AS CHAR FORMAT "X(55)"
    FIELD observacao    AS CHAR FORMAT "X(40)"
    FIELD ref-pai       AS CHAR FORMAT "X(08)"
    FIELD ref-filho     AS CHAR FORMAT "X(08)"
    FIELD tipo-sobra    AS CHAR FORMAT "X(02)"
    FIELD qtd-pai       AS CHAR FORMAT "X(12)"
    FIELD veiculo       AS CHAR FORMAT "X(01)"
    FIELD perc-veiculo  AS CHAR FORMAT "X(07)"
    INDEX id 
        it-codigo
        seq-int.

DEFINE BUFFER b-estrut FOR tt-estrut.
DEFINE BUFFER b-de-para-pai FOR tt-de-para.
DEFINE BUFFER b-de-para-filho FOR tt-de-para.


/******************************************************************************/
/******************************************************************************/

ASSIGN c-arq-estrutura = "c:\temp\Automatiza\ListaEstruturaAutomatiza.csv"
       c-arq-de-para   = "c:\temp\Automatiza\de-para-automatiza.csv"
       c-arq-layout    = "c:\temp\Automatiza\layout-en0113-automatiza.lst"
       c-arq-erros     = "c:\temp\Automatiza\automatiza-erros-importacao.txt".

/******************************************************************************/
/******************************************************************************/

/** VALIDA DE/PARA DE ITENS **/
INPUT FROM VALUE(c-arq-de-para).
OUTPUT TO VALUE(c-arq-erros).

REPEAT:

    IMPORT c-linha.

    CREATE tt-de-para.
    ASSIGN tt-de-para.it-automatiza = ENTRY(1, c-linha, ";")
           tt-de-para.it-ems        = ENTRY(2, c-linha, ";").

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-de-para.it-ems:
    END.

    IF NOT AVAIL ITEM THEN DO:

        PUT UNFORMATTED
            "*** Item Automatiza " + tt-de-para.it-automatiza + " possui item EMS inv lido: " + tt-de-para.it-ems + "." SKIP.

        ASSIGN l-erro = TRUE.

    END.

END.

OUTPUT CLOSE.
INPUT CLOSE.

/** IMPORTA ESTRUTURA DE ORIGEM **/
     
INPUT FROM VALUE(c-arq-estrutura).
OUTPUT TO VALUE(c-arq-erros) APPEND.

REPEAT :

    IMPORT c-linha.

    FOR FIRST b-de-para-pai
        WHERE b-de-para-pai.it-automatiza = ENTRY(1, c-linha, ";"):
    END.

    IF NOT AVAIL b-de-para-pai THEN DO:

        PUT UNFORMATTED
            "*** Item Pai Automatiza " + ENTRY(1, c-linha, ";") + " nÆo encontrado na tabela de DE-PARA." SKIP.

        ASSIGN l-erro = TRUE.

    END.

    FOR FIRST b-de-para-filho
        WHERE b-de-para-filho.it-automatiza = ENTRY(2, c-linha, ";"):
    END.

    IF NOT AVAIL b-de-para-filho THEN DO:

        PUT UNFORMATTED
            "*** Item Filho Automatiza " + ENTRY(2, c-linha, ";") + " nÆo encontrado na tabela de DE-PARA." SKIP.

        /* ASSIGN l-erro = TRUE. */ NEXT.

    END.
    
    IF l-erro THEN
        NEXT.
    
    
    IF NOT CAN-FIND (FIRST tt-estrut-origem
                     WHERE tt-estrut-origem.it-codigo = b-de-para-pai.it-ems
                       AND tt-estrut-origem.es-codigo = b-de-para-filho.it-ems) THEN DO:

        CREATE tt-estrut-origem.
        ASSIGN tt-estrut-origem.it-codigo = b-de-para-pai.it-ems
               tt-estrut-origem.es-codigo = b-de-para-filho.it-ems
               tt-estrut-origem.qtde      = DEC(ENTRY(3, c-linha, ";"))
               tt-estrut-origem.fantasma  = ENTRY(4,c-linha,";").

    END.
END.
OUTPUT CLOSE.
INPUT CLOSE.    
    
FOR EACH tt-estrut-origem NO-LOCK:
    
    FOR LAST b-estrut USE-INDEX id
        WHERE b-estrut.it-codigo = tt-estrut-origem.it-codigo:

        ASSIGN i-seq = b-estrut.seq-int + 10.

    END.

    IF NOT AVAIL b-estrut THEN
        ASSIGN i-seq = 10.

    
    CREATE tt-estrut.
    ASSIGN tt-estrut.tipo         = "1"
           tt-estrut.it-codigo    = tt-estrut-origem.it-codigo
           tt-estrut.seq-int      = i-seq
           tt-estrut.sequencia    = STRING(i-seq, ">>>>9")
           tt-estrut.es-codigo    = tt-estrut-origem.es-codigo
           tt-estrut.revisao      = ""
           tt-estrut.fantasma     = tt-estrut-origem.fantasma
           tt-estrut.fat-perda    = "0000"
           tt-estrut.proporc      = "10000"
           tt-estrut.serie-ini    = ""
           tt-estrut.serie-fim    = ""
           tt-estrut.quant        = STRING(tt-estrut-origem.qtde * 10000000000, "9999999999999999")
           tt-estrut.tempo-res    = "?   "
           tt-estrut.data-ini     = string(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") + STRING(YEAR(TODAY), "9999") 
           tt-estrut.data-fim     = "31129999"
           tt-estrut.cod-roteiro  = ""
           tt-estrut.op-codigo    = "00000"
           tt-estrut.local-montag = ""
           tt-estrut.observacao   = ""
           tt-estrut.ref-pai      = ""
           tt-estrut.ref-filho    = ""
           tt-estrut.tipo-sobra   = " 4"
           tt-estrut.qtd-pai      = "000000010000"
           tt-estrut.veiculo      = "N"
           tt-estrut.perc-veiculo = "0000000".

END.



/**/

IF l-erro THEN DO:

    MESSAGE "Erros encontrados. Importa‡Æo cancelada. Verifique arquivo de erros: " + c-arq-erros + "."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN "NOK":U.

END.

/**/

OUTPUT TO VALUE(c-arq-layout).

FOR EACH tt-estrut:

    PUT UNFORMATTED
        tt-estrut.tipo              FORMAT "X(01)"
        tt-estrut.it-codigo         FORMAT "X(16)"
        tt-estrut.sequencia         FORMAT "X(05)"
        tt-estrut.es-codigo         FORMAT "X(16)"
        tt-estrut.revisao           FORMAT "X(08)"
        tt-estrut.fantasma          FORMAT "X(01)"
        tt-estrut.fat-perda         FORMAT "X(04)"
        tt-estrut.proporc           FORMAT "X(05)"
        tt-estrut.serie-ini         FORMAT "X(12)"
        tt-estrut.serie-fim         FORMAT "X(12)"
        tt-estrut.quant             FORMAT "X(16)"
        tt-estrut.tempo-res         FORMAT "X(04)"
        tt-estrut.data-ini          FORMAT "X(08)"
        tt-estrut.data-fim          FORMAT "X(08)"
        tt-estrut.cod-roteiro       FORMAT "X(16)"
        tt-estrut.op-codigo         FORMAT "X(05)"
        tt-estrut.local-montag      FORMAT "X(55)"
        tt-estrut.observacao        FORMAT "X(40)"
        tt-estrut.ref-pai           FORMAT "X(08)"
        tt-estrut.ref-filho         FORMAT "X(08)"
        tt-estrut.tipo-sobra        FORMAT "X(02)"
        tt-estrut.qtd-pai           FORMAT "X(12)"
        tt-estrut.veiculo           FORMAT "X(01)"
        tt-estrut.perc-veiculo      FORMAT "X(07)"  SKIP.

END.

OUTPUT CLOSE.

MESSAGE "Processo conclu¡do com sucesso."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
