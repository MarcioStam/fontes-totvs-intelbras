
/* include de controle de vers∆o */
{include/i-prgvrs.i ESENP022 1.00.00.000}

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/enp/esenp022.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE TEMP-TABLE tt-mp-produto NO-UNDO
    FIELD mp        AS CHAR
    FIELD produto   AS CHAR
    FIELD qt-mp     AS DEC
    INDEX rel
        mp
        produto
    INDEX mp
        mp
    INDEX prod
        produto.

DEFINE TEMP-TABLE tt-linha NO-UNDO
    FIELD mp        AS CHAR
    INDEX mp
        mp.

DEFINE TEMP-TABLE tt-coluna NO-UNDO
    FIELD produto   AS CHAR
    INDEX prod
        produto.

/* recebimento de parÉmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE STREAM st-excel.
/*DEFINE STREAM st-log.*/

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/* definiá∆o de vari†veis  */
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-nr-nf     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-nr-nf     AS INTEGER      NO-UNDO.
DEFINE VARIABLE dt-reprog   AS DATE         NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dt-anterior AS DATE         NO-UNDO.
DEFINE VARIABLE c-mp-codigo AS CHARACTER   NO-UNDO.

/* definiá∆o de frames do relat¢rio */
FORM 
    c-nr-nf     FORMAT "x(16)"          COLUMN-LABEL "Nr Nota Fisc"     SPACE(3)
    dt-anterior FORMAT "99/99/9999"     COLUMN-LABEL "Data Anterior"    SPACE(3)
    dt-reprog   FORMAT "99/99/9999"     COLUMN-LABEL "Data Entrega"     SPACE(3)
    c-mensagem  FORMAT "X(60)"          COLUMN-LABEL "Mensagem"
    WITH FRAME f-notas WIDTH 132 DOWN stream-io.

DEFINE BUFFER b-estrut FOR estrutura.
DEFINE BUFFER b-linha  FOR tt-mp-produto.
DEFINE BUFFER b-coluna FOR tt-mp-produto.
DEFINE BUFFER b-item   FOR ITEM.

/* include padr∆o para output de relat¢rios */
{include/i-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}


/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESENP022"
	    c-versao	    = "1.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbr†s"
	    c-sistema	    = "ENP"
	    c-titulo-relat  = "MP x Produto".


/* para n∆o visualizar cabeáalho/rodapÇ em sa°da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilit†rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

/* corpo do relat¢rio */
RUN pi-inicializar IN h-acomp (INPUT "Processando").
RUN pi-processa.

RUN pi-inicializar IN h-acomp (INPUT "Gerando Excel").
RUN pi-gera-excel.


PUT UNFORMATTED
    "Arquivo gerado em: " SESSION:TEMP-DIR + "MP_X_Produto.csv".

PAGE.

DISP SKIP(3) 
    "Seleá∆o" AT 10 NO-LABEL SKIP
    "-------" AT 10 NO-LABEL SKIP(1)
    "Fam°lia: " AT 16 NO-LABEL tt-param.fm-codigo-ini NO-LABEL "|< >| " tt-param.fm-codigo-fim NO-LABEL SKIP(3)
    "ParÉmetros" AT 10 NO-LABEL SKIP
    "----------" AT 10 NO-LABEL SKIP(1)
    "         Impress∆o: " AT 5 NO-LABEL
    c-impressao FORMAT "x(50)" AT 25 NO-LABEL.





/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.



PROCEDURE pi-processa:

    EMPTY TEMP-TABLE tt-mp-produto.

    FOR EACH familia fields(fm-codigo) NO-LOCK
        WHERE familia.fm-codigo >= tt-param.fm-codigo-ini
        AND   familia.fm-codigo <= tt-param.fm-codigo-fim:

        FOR EACH ITEM FIELDS (compr-fabric fm-codigo it-codigo) NO-LOCK
            WHERE ITEM.compr-fabric = 1
            AND   ITEM.fm-codigo = familia.fm-codigo:

            RUN pi-acompanhar IN h-acomp (INPUT "Fam°lia: " + familia.fm-codigo + " - MP: " + ITEM.it-codigo).

            ASSIGN c-mp-codigo = ITEM.it-codigo.

            RUN pi-sobe-estrutura (INPUT ITEM.it-codigo,
                                   INPUT 1).

        END.

    END.

END PROCEDURE.



PROCEDURE pi-sobe-estrutura:

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-qtd       AS DEC  NO-UNDO.

    DEFINE VARIABLE de-qtd-um-pai AS DECIMAL     NO-UNDO.


    bl-estrut:
    FOR EACH estrutura FIELDS(it-codigo es-codigo qtd-item qtd-compon) USE-INDEX onde-se-usa NO-LOCK
        WHERE estrutura.es-codigo     = p-it-codigo
        AND   estrutura.data-inicio  <= TODAY
        AND   estrutura.data-termino >= TODAY:

        IF estrutura.qtd-item = 0 OR
           estrutura.qtd-compon = 0 THEN
            NEXT.

        ASSIGN de-qtd-um-pai = (estrutura.qtd-compon / estrutura.qtd-item) * p-qtd.

        /*OUTPUT STREAM st-log TO c:\temp\LOG-teste.txt APPEND.
                            
        PUT STREAM st-log unformatted
           "    it-codigo: " estrutura.it-codigo SKIP
           "    es-codigo: " estrutura.es-codigo SKIP
           "     qtd-item: " estrutura.qtd-item SKIP
           "   qtd-compon: " estrutura.qtd-compon SKIP
           "de-qtd-um-pai: " de-qtd-um-pai SKIP.

        OUTPUT STREAM st-log CLOSE.*/

        

        /* Verifica se o item PAI pertence a alguma estrutura como filho. Se n∆o pertencer, Ç n°vel zero. */
        IF NOT CAN-FIND(FIRST b-estrut
                        WHERE b-estrut.es-codigo = estrutura.it-codigo
                          AND b-estrut.data-inicio  <= TODAY
                          AND b-estrut.data-termino >= TODAY) THEN DO:

            FOR FIRST b-item fields (it-codigo ge-codigo cod-obsoleto) NO-LOCK
                WHERE b-item.it-codigo = estrutura.it-codigo:

                IF (tt-param.ativos AND b-item.cod-obsoleto <> 1) THEN
                    NEXT bl-estrut.

                /* Acabados */
                IF tt-param.acabados = 2 AND
                    (b-item.ge-codigo <> 40 AND
                     b-item.ge-codigo <> 42 AND
                     b-item.ge-codigo <> 45) THEN DO:
    
                    NEXT bl-estrut.

                END.

                /* Semi-Acabados */
                IF tt-param.acabados = 3 AND
                    (b-item.ge-codigo <> 20 AND
                     b-item.ge-codigo <> 25) THEN DO:
    
                    NEXT bl-estrut.
    

                END.

            END.

            FOR FIRST tt-mp-produto 
                WHERE tt-mp-produto.mp = c-mp-codigo
                AND   tt-mp-produto.produto = estrutura.it-codigo:
            END.

            IF NOT AVAIL tt-mp-produto THEN DO:

                /*OUTPUT STREAM st-log TO c:\temp\LOG-teste.txt APPEND.

                PUT STREAM st-log UNFORMATTED
                    "--> Criou tt" SKIP.

                OUTPUT STREAM st-log CLOSE.*/


                CREATE tt-mp-produto.
                ASSIGN tt-mp-produto.mp = c-mp-codigo
                       tt-mp-produto.produto = estrutura.it-codigo
                       tt-mp-produto.qt-mp = 0.

            END.
            
            ASSIGN tt-mp-produto.qt-mp = tt-mp-produto.qt-mp + de-qtd-um-pai.


            /*OUTPUT STREAM st-log TO c:\temp\LOG-teste.txt APPEND.

            PUT STREAM st-log UNFORMATTED
                "tt-mp-produto.qt-mp: " tt-mp-produto.qt-mp SKIP.

            OUTPUT STREAM st-log CLOSE.*/


        END.
        ELSE DO:

            /*OUTPUT STREAM st-log TO c:\temp\LOG-teste.txt APPEND.

            PUT STREAM st-log UNFORMATTED
                 "--> Subiu estrutura" SKIP.

            OUTPUT STREAM st-log CLOSE.*/

            RUN pi-sobe-estrutura (INPUT estrutura.it-codigo,
                                   INPUT de-qtd-um-pai).

        END.

        /*OUTPUT STREAM st-log TO c:\temp\LOG-teste.txt APPEND.

        PUT STREAM st-log UNFORMATTED
            SKIP(2).

        OUTPUT STREAM st-log CLOSE.*/

    END.

END PROCEDURE.



PROCEDURE pi-gera-excel:

    EMPTY TEMP-TABLE tt-linha.
    EMPTY TEMP-TABLE tt-coluna.


    FOR EACH tt-mp-produto:

        IF NOT CAN-FIND(FIRST tt-linha
                        WHERE tt-linha.mp = tt-mp-produto.mp) THEN DO:

            CREATE tt-linha.
            ASSIGN tt-linha.mp = tt-mp-produto.mp.

        END.

        IF NOT CAN-FIND(FIRST tt-coluna
                        WHERE tt-coluna.produto = tt-mp-produto.produto) THEN DO:

            CREATE tt-coluna.
            ASSIGN tt-coluna.produto = tt-mp-produto.produto.

        END.
        

    END.

    OUTPUT STREAM st-excel TO value(SESSION:TEMP-DIR + "MP_X_Produto.csv") NO-CONVERT.

    PUT STREAM st-excel UNFORMATTED
        "Item;Descriá∆o;".

    FOR EACH tt-coluna
        BY tt-coluna.produto:

        PUT STREAM st-excel UNFORMATTED
            tt-coluna.produto   ";".

    END.

    PUT STREAM st-excel UNFORMATTED
        SKIP.


    FOR EACH tt-linha:

        RUN pi-acompanhar IN h-acomp (INPUT "MP: " + tt-linha.mp).

        FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK
            WHERE ITEM.it-codigo = tt-linha.mp:
        END.

        PUT STREAM st-excel UNFORMATTED
            tt-linha.mp             ";"
            ITEM.desc-item          ";".

        FOR EACH tt-coluna
            BY tt-coluna.produto:

            FOR FIRST tt-mp-produto
                WHERE tt-mp-produto.mp = tt-linha.mp
                AND   tt-mp-produto.produto = tt-coluna.produto:
            END.

            IF AVAIL tt-mp-produto THEN DO:

                PUT STREAM st-excel UNFORMATTED
                    tt-mp-produto.qt-mp.

            END.
            
            PUT STREAM st-excel UNFORMATTED
                ";".

        END.

        PUT STREAM st-excel UNFORMATTED
            SKIP.

    END.

    OUTPUT CLOSE.

END PROCEDURE.
