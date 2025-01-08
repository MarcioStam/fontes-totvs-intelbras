
/*

    Excel de Entrada
    Saldo Estoque Automatiza
    c:\temp\Automatiza\saldo-estoque.csv.
    Campos: Item Pai; Deposito; Conta; Unidade de Medida; Quantidade; Valor Mat‚ria Prima; Valor MÆo de obra; GGF; Estab
    
    ------------------------------------------------------------
    
    Excel de Entrada
    De-Para Itens Automatiza / EMS
    c:\temp\Automatiza\de-para-automatiza.csv
    Campos: Item Automatiza; Item EMS
    
    ------------------------------------------------------------
    
    Arquivo de Sa¡da
    Layout para Importa‡Æo no EN0113
    c:\temp\Automatiza\layout-ce0000-automatiza.lst
    
    ------------------------------------------------------------
    
    Arquivo de Sa¡da
    Erros
    c:\temp\Automatiza\automatiza-erros-importacao.txt.
    
*/

DEFINE VARIABLE c-arq-saldo-estoque AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-de-para       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-erros         AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-linha     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-qtd AS DEC   NO-UNDO.
DEFINE VARIABLE l-erro AS LOGICAL     INIT NO NO-UNDO.

DEFINE TEMP-TABLE tt-de-para
    FIELD it-automatiza  AS CHAR
    FIELD it-ems         AS CHAR.


DEFINE TEMP-TABLE tt-saldo-estoque
    FIELD it-codigo     AS CHAR FORMAT "X(16)"
    FIELD deposito      AS CHAR FORMAT "X(03)"
    FIELD conta         AS CHAR FORMAT "X(20)"
    FIELD unid-medid    AS CHAR FORMAT "X(02)"
    FIELD quantidade    AS CHAR FORMAT "X(14)"
    FIELD val-mat-prima AS CHAR FORMAT "X(14)"
    FIELD val-mao-obra  AS CHAR FORMAT "X(14)"
    FIELD val-ggf       AS CHAR FORMAT "X(14)"
    FIELD cod-esabel    AS CHAR FORMAT "X(05)"
    INDEX id 
        it-codigo.


/******************************************************************************/
/******************************************************************************/

ASSIGN c-arq-saldo-estoque = "c:\temp\Automatiza\saldo-estoque.csv"
       c-arq-de-para       = "c:\temp\Automatiza\de-para-automatiza.csv"
       c-arq-layout        = "c:\temp\Automatiza\layout-ce0000-automatiza.lst"
       c-arq-erros         = "c:\temp\Automatiza\automatiza-erros-import-saldo.txt".

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


/** IMPORTA SALDO ESTOQUE **/
     
INPUT FROM VALUE(c-arq-saldo-estoque).
OUTPUT TO VALUE(c-arq-erros) APPEND.


REPEAT :
   
    IMPORT c-linha.

    FOR FIRST tt-de-para
        WHERE tt-de-para.it-automatiza = ENTRY(1, c-linha, ";"):
    END.

    IF NOT AVAIL tt-de-para THEN DO:

        PUT UNFORMATTED
            "*** Item Automatiza " + ENTRY(1, c-linha, ";") + " nÆo encontrado na tabela de DE-PARA." SKIP.

        ASSIGN l-erro = TRUE.

    END.
    
    IF l-erro THEN
        NEXT.
    
    
    IF NOT CAN-FIND (FIRST tt-saldo-estoque
                     WHERE tt-saldo-estoque.it-codigo = tt-de-para.it-ems) THEN DO:
        
        CREATE tt-saldo-estoque.
        ASSIGN tt-saldo-estoque.it-codigo     = tt-de-para.it-ems
               tt-saldo-estoque.deposito      = entry(2, c-linha, ";")
               tt-saldo-estoque.conta         = entry(3, c-linha, ";")
               tt-saldo-estoque.unid-medid    = replace(entry(4, c-linha, ";"),"ç","c")
               tt-saldo-estoque.quantidade    = string(decimal(entry(5, c-linha, ";")) * 10000, "99999999999999")
               tt-saldo-estoque.val-mat-prima = string(decimal(entry(6, c-linha, ";")) * 100, "99999999999999")
               tt-saldo-estoque.val-mao-obra  = string(decimal(entry(7, c-linha, ";")) * 100, "99999999999999")
               tt-saldo-estoque.val-ggf       = string(decimal(entry(8, c-linha, ";")) * 100, "99999999999999")
               tt-saldo-estoque.cod-esabel    = entry(9, c-linha, ";").

    END.
END.
OUTPUT CLOSE.
INPUT CLOSE.    
 
/**/

IF l-erro THEN DO:

    MESSAGE "Erros encontrados. Importa‡Æo cancelada. Verifique arquivo de erros: " + c-arq-erros + "."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN "NOK":U.

END.

/**/

OUTPUT TO VALUE(c-arq-layout).

FOR EACH tt-saldo-estoque:

    PUT UNFORMATTED
        tt-saldo-estoque.it-codigo         FORMAT "X(16)"
        " "                                FORMAT "X(03)"
        tt-saldo-estoque.deposito          FORMAT "X(03)"
        " "                                FORMAT "X(30)"  
        tt-saldo-estoque.conta             FORMAT "X(20)"
        " "                                FORMAT "X(20)"
        tt-saldo-estoque.unid-medid        FORMAT "X(02)"
        tt-saldo-estoque.quantidade        FORMAT "X(14)"
        tt-saldo-estoque.val-mat-prima     FORMAT "X(14)"
        " "                                FORMAT "X(28)"
        tt-saldo-estoque.val-mao-obra      FORMAT "X(14)"
        " "                                FORMAT "X(28)"
        tt-saldo-estoque.val-ggf           FORMAT "X(14)"
        " "                                FORMAT "X(47)"
        tt-saldo-estoque.cod-esabel        FORMAT "X(05)" SKIP.

END.

OUTPUT CLOSE.

MESSAGE "Processo conclu¡do com sucesso."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
