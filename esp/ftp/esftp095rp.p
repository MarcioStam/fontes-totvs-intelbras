
/* include de controle de vers∆o */
{include/i-prgvrs.i ESFTP095 1.00.00.000}

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/ftp/esftp095.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parÉmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

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
DEFINE VARIABLE c-n-series-fornec AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo AS CHARACTER   NO-UNDO.
DEFINE STREAM st-excel.

/* definiá∆o de frames do relat¢rio */
FORM 
    c-nr-nf     FORMAT "x(16)"          COLUMN-LABEL "Nr Nota Fisc"     SPACE(3)
    dt-anterior FORMAT "99/99/9999"     COLUMN-LABEL "Data Anterior"    SPACE(3)
    dt-reprog   FORMAT "99/99/9999"     COLUMN-LABEL "Data Entrega"     SPACE(3)
    c-mensagem  FORMAT "X(60)"          COLUMN-LABEL "Mensagem"
    WITH FRAME f-notas WIDTH 132 DOWN stream-io.

/* include padr∆o para output de relat¢rios */
{include/i-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}


/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESFTP095"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "ESP"
	    c-titulo-relat  = "N£mero de SÇrie de Fornecedores".


VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/* executando de forma persistente o utilit†rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

IF OPSYS = "UNIX" THEN DO:
    ASSIGN c-caminho-arquivo = c-dir-arquivo-session + c-seg-usuario.

    OS-CREATE-DIR VALUE(c-caminho-arquivo).

    ASSIGN c-caminho-arquivo = c-caminho-arquivo + "/" + "ESFTP095.csv".
    ASSIGN c-caminho-arquivo = REPLACE(c-caminho-arquivo, "~\":U, "/":U).

    /* Elimina arquivo j† existente */
    OS-DELETE VALUE(c-caminho-arquivo) NO-ERROR.
END.
ELSE
    ASSIGN c-caminho-arquivo = tt-param.c-saida-csv.

/* corpo do relat¢rio */
OUTPUT STREAM st-excel TO VALUE(c-caminho-arquivo) NO-CONVERT.

PUT STREAM st-excel UNFORMATTED
    "Dt Emiss∆o;Estab;Nota Fiscal;SÇrie;Nome Cliente;Item;Descriá∆o;Num.SÇrie;Dt.Fabric;Num.SÇrie;Num.SÇrie" SKIP.

FOR EACH nota-fiscal USE-INDEX nfftrm-20 NO-LOCK
    WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-ini
    AND   nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-fim
    AND   nota-fiscal.cod-estabel  >= tt-param.estabel-ini
    AND   nota-fiscal.cod-estabel  <= tt-param.estabel-fim
    AND   nota-fiscal.serie        >= tt-param.serie-ini
    AND   nota-fiscal.serie        <= tt-param.serie-fim
    AND   nota-fiscal.nr-nota-fis  >= tt-param.nota-fiscal-ini
    AND   nota-fiscal.nr-nota-fis  <= tt-param.nota-fiscal-fim:

    RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal: " + STRING(nota-fiscal.nr-nota-fis)).

    FOR EACH num-serie-rast USE-INDEX unic NO-LOCK
        WHERE num-serie-rast.cod-estabel = nota-fiscal.cod-estabel
        AND   num-serie-rast.serie       = nota-fiscal.serie
        AND   num-serie-rast.nr-nota-fis = nota-fiscal.nr-nota-fis:

        IF num-serie-rast.it-codigo < tt-param.it-codigo-ini OR num-serie-rast.it-codigo > tt-param.it-codigo-fim THEN
            NEXT.
        
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = num-serie-rast.it-codigo:

            ASSIGN c-n-series-fornec = "".

            FOR EACH num-serie-fornec USE-INDEX ch-pr NO-LOCK
                WHERE num-serie-fornec.n-serie = num-serie-rast.n-serie:

                ASSIGN c-n-series-fornec = c-n-series-fornec + num-serie-fornec.n-serie-sec + ";".
            END.
            
            FIND FIRST num-serie NO-LOCK
                 WHERE num-serie.n-serie = num-serie-rast.n-serie NO-ERROR.
            
            /*Dt Emiss∆o; Estab; Nota Fiscal; Serie; Nome Cliente; Item; Descriá∆o; Num.SÇrie;Dt.Fabric; Num.SÇrie 2; Num.SÇrie 3*/

            PUT STREAM st-excel UNFORMATTED
                string(nota-fiscal.dt-emis-nota)    + ";" +
                nota-fiscal.cod-estabel             + ";" +
                nota-fiscal.nr-nota-fis             + ";" +
                nota-fiscal.serie                   + ";" +
                nota-fiscal.nome-ab-cli             + ";" +
                num-serie-rast.it-codigo            + ";" + 
                ITEM.desc-item                      + ";" +
                num-serie-rast.n-serie              + ";" +
                string(DATE(num-serie.data))        + ";" +         
                c-n-series-fornec 
                SKIP.
        
        END.

    END.

END.

OUTPUT STREAM st-excel CLOSE.


/*PAGE.*/

disp 
    skip(1)
    "SELEÄ«O" NO-LABEL
    SKIP(1)
    tt-param.dt-emissao-ini   AT 05 
     "|<  >|"                 AT 36
    tt-param.dt-emissao-fim   AT 43 NO-LABEL

    tt-param.estabel-ini      AT 12 
     "|<  >|"                 AT 36
    tt-param.estabel-fim      AT 43 NO-LABEL

    tt-param.serie-ini        AT 12 
     "|<  >|"                 AT 36
    tt-param.serie-fim        AT 43 NO-LABEL

    tt-param.nota-fiscal-ini  AT 06 
     "|<  >|"                 AT 36
    tt-param.nota-fiscal-fim  AT 43 NO-LABEL
                             
    WITH FRAME f-selecao WIDTH 132 STREAM-IO SIDE-LABELS.

DISP
    SKIP(3)
    "PARAMETROS"
    SKIP(1)
    tt-param.c-saida-csv    AT 05
    WITH FRAME f-parametros WIDTH 132 STREAM-IO SIDE-LABELS.
     
disp
    skip(3)
    "IMPRESS«O"
    SKIP(1)
    "Destino:" at 05
    tt-param.desc-destino 
    " - " tt-param.arquivo 
    skip
    "Usu†rio:" at 05
    tt-param.usuario 
    with frame f-impressao width 132 stream-io no-labels.



/*
DISP
    SKIP(3)
    "Seleá∆o"    AT 10 NO-LABEL SKIP
    "----------" AT 10 NO-LABEL SKIP(2)


    SKIP(3) 
    "ParÉmetros" AT 10 NO-LABEL SKIP
    "----------" AT 10 NO-LABEL SKIP(2)
    "Arquivo de Entrada: " AT 5 NO-LABEL
    tt-param.excel FORMAT "x(50)" AT 25 NO-LABEL SKIP
    "         Impress∆o: " AT 5 NO-LABEL
    c-impressao FORMAT "x(50)" AT 25 NO-LABEL.

               */



/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.


