
/* IMPORTAÄ«O DE ITENS */


DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-import
    FIELD it-codigo     AS CHAR     FORMAT "X(16)"
    FIELD inform-compl  AS CHAR     FORMAT "X(16)"
    FIELD desc-item     AS CHAR     FORMAT "X(60)"
    FIELD ge-codigo     AS INT      FORMAT "99"
    FIELD un            AS CHAR     FORMAT "X(2)"
    FIELD cod-estabel   AS CHAR     FORMAT "X(5)"
    FIELD fm-codigo     AS CHAR     FORMAT "X(8)"
    FIELD fm-cod-com    AS CHAR     FORMAT "X(8)"
    FIELD tipo-trans    AS INT      FORMAT "9"
    FIELD situacao      AS INT      FORMAT "99"
    FIELD dt-implant    AS CHAR     FORMAT "X(8)"
    FIELD dt-liber      AS CHAR     FORMAT "X(8)"
    FIELD cd-folh-item  AS CHAR     FORMAT "X(8)"
    FIELD tipo-contr    AS INT      FORMAT "99"
    FIELD ind-serv-mat  AS INT      FORMAT "99"     /* Aplicaá∆o */
    FIELD lote-econom   AS DECIMAL  format "9999999999999"
    FIELD codigo-refer  AS CHAR     FORMAT "X(20)" /* C¢digo Complementar */ 
    FIELD imagem        AS CHAR     FORMAT "X(30)"
    FIELD narrativa     AS CHAR     FORMAT "X(2000)"
    FIELD erro          AS LOGICAL
    .

    
INPUT FROM c:\temp\ItensImportacao.csv.
OUTPUT TO c:\temp\ItensImportacao-ERROS.csv.

EMPTY TEMP-TABLE tt-import.

REPEAT:

    IMPORT UNFORMATTED c-linha.

    CREATE tt-import.
    ASSIGN tt-import.it-codigo      = ENTRY(1,c-linha,";")
           tt-import.inform-compl   = ENTRY(2,c-linha,";")
           tt-import.desc-item      = ENTRY(3,c-linha,";")
           tt-import.ge-codigo      = int(ENTRY(4,c-linha,";"))
           tt-import.un             = ENTRY(5,c-linha,";")
           tt-import.cod-estabel    = ENTRY(6,c-linha,";")
           tt-import.fm-codigo      = ENTRY(7,c-linha,";")
           tt-import.fm-cod-com     = ENTRY(8,c-linha,";").
    ASSIGN tt-import.tipo-trans     = 1
           tt-import.situacao       = 1
           tt-import.dt-implant     = string(month(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(YEAR(TODAY), "9999")
           tt-import.dt-liber       = string(month(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(YEAR(TODAY), "9999")
           tt-import.cd-folh-item   = ""
           tt-import.tipo-contr     = 2  
           tt-import.ind-serv-mat   = 2   
           tt-import.lote-econom    = 0    
           tt-import.codigo-refer   = ""    
           tt-import.imagem         = ""     
           tt-import.narrativa      = ""
           tt-import.erro           = FALSE.

    IF NOT CAN-FIND(FIRST grup-estoq 
                    WHERE grup-estoq.ge-codigo = tt-import.ge-codigo) THEN DO:

        PUT UNFORMATTED
            tt-import.it-codigo ";"
            "Grupo de Estoque n∆o encontrado."
            SKIP.

        ASSIGN tt-import.erro = TRUE.

    END.

    IF NOT CAN-FIND(FIRST tab-unidade
                    WHERE tab-unidade.un = tt-import.un) THEN DO:

        PUT UNFORMATTED
            tt-import.it-codigo ";"
            "Unidade de Medida n∆o encontrada."
            SKIP.

        ASSIGN tt-import.erro = TRUE.

    END.

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = tt-import.cod-estabel) THEN DO:

        PUT UNFORMATTED
            tt-import.it-codigo ";"
            "Estabelecimento n∆o encontrado."
            SKIP.

        ASSIGN tt-import.erro = TRUE.

    END.

    IF NOT CAN-FIND(FIRST familia
                    WHERE familia.fm-codigo = tt-import.fm-codigo) THEN DO:

        PUT UNFORMATTED
            tt-import.it-codigo ";"
            "Fam°lia n∆o encontrada."
            SKIP.

        ASSIGN tt-import.erro = TRUE.

    END.

    IF NOT CAN-FIND(FIRST fam-comerc
                    WHERE fam-comerc.fm-cod-com = tt-import.fm-cod-com) THEN DO:

        PUT UNFORMATTED
            tt-import.it-codigo ";"
            "Fam°lia Comercial n∆o encontrado."
            SKIP.

        ASSIGN tt-import.erro = TRUE.

    END.
    
END.

INPUT CLOSE.
OUTPUT CLOSE.


OUTPUT TO c:\temp\ItensImportacaoCD0209.lst.

FOR EACH tt-import
    WHERE tt-import.erro = FALSE:

    PUT tt-import.tipo-trans       AT 1  
        tt-import.it-codigo        AT 2  
        tt-import.desc-item        AT 18  
        tt-import.ge-codigo        AT 78  
        tt-import.fm-codigo        AT 80  
        tt-import.fm-cod-com       AT 88  
        tt-import.un               AT 96  
        tt-import.cod-estabel      AT 98  
        tt-import.situacao         AT 103  
        tt-import.dt-implant       AT 105  
        tt-import.dt-liber         AT 113  
        tt-import.cd-folh-item     AT 121  
        tt-import.tipo-contr       AT 129  
        tt-import.ind-serv-mat     AT 131  
        tt-import.lote-econom      AT 133  
        tt-import.codigo-refer     AT 146  
        tt-import.inform-compl     AT 166  
        tt-import.imagem           AT 182  
        tt-import.narrativa        AT 212
        SKIP.

END.

OUTPUT CLOSE.
