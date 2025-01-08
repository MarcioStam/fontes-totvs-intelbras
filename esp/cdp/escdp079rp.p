
/***********************************************************************
**  Programa..: ESCDP078
**  Autor.....: Alexandre de Freitas.Campos.Gonáalves
**  Data......: Maio/2015 - Desenvolvimento
**  Descricao.: Relat¢rio Altera familia itens
**  Versao....: 003 07/05/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i escdp078rp 1.00.00.000}  

/****************************  Definitions  ****************************/

{esp/cdp/escdp079tt.i}

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{include/i-freeac.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp           AS HANDLE    NO-UNDO.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo-saida   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-ok              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-linha           AS CHARACTER FORMAT "X(200)" NO-UNDO.
DEFINE VARIABLE c-acao            AS CHARACTER NO-UNDO. 
DEFINE VARIABLE l-erro            AS LOGICAL NO-UNDO.
/****************************  Temp-Tables  ****************************/
{cdp/cdapi244.i}
{cdp/cdapi300.i1}

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-versao-integr.
EMPTY TEMP-TABLE tt-erros-geral.
EMPTY TEMP-TABLE tt-item.

CREATE tt-versao-integr.
ASSIGN tt-versao-integr.cod-versao-integracao = 1.
    
FOR FIRST param-global NO-LOCK.
END.

DEFINE TEMP-TABLE tt-erro
    FIELD it-codigo  LIKE ITEM.it-codigo
    FIELD fm-cod-com LIKE ITEM.fm-cod-com
    FIELD desc-erro  AS CHARACTER FORMAT "X(50)".

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/****************************** Frames ***********************************/

DEFINE STREAM str-excel.

FOR FIRST tt-param:
END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri:
 END.

ASSIGN c-programa     = "ESCDP079"
       c-sistema      = "Especificos Intelbras"
       c-titulo-relat = "Altera familia ITEM"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''.

FORM ITEM.it-codigo  COLUMN-LABEL "ITEM"
     ITEM.desc-item  COLUMN-LABEL "Descriá∆o"
     ITEM.fm-cod-com COLUMN-LABEL "Cod.Familia"
     WITH FRAME f-ns STREAM-IO DOWN WIDTH 132.

FORM tt-erro.it-codigo  COLUMN-LABEL "ITEM"
     tt-erro.fm-cod-com COLUMN-LABEL "Cod.Familia"
     tt-erro.desc-erro  COLUMN-LABEL "Descriá∆o de erro"
     WITH FRAME b-ns STREAM-IO DOWN WIDTH 132.


ASSIGN c-arquivo-entrada = tt-param.arq-entrada
       c-arquivo-saida   = c-arquivo-entrada + "_Reporte_erros.csv".

INPUT FROM VALUE(c-arquivo-entrada)CONVERT TARGET SESSION:CHARSET.

/*****************************  Main Block  *****************************/

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados...").

    {include/i-rpout.i}
    {include/i-rpcab.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    RUN piImporta.
    RUN pi-atualizaItem.

    /****
    FOR EACH tt-erros-geral NO-LOCK:
        PUT 'tt-erros-geral.des-erro ' tt-erros-geral.des-erro SKIP.
    END.
    ****/
    
    IF CAN-FIND(FIRST tt-erro) THEN DO:
        PUT "" SKIP(3).
        PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP.
        PUT UNFORMATTED "Intelbras S/A - Ind.Tel.Eletr.Brasileira         Demonstrativo de Erros" SKIP.                                 
        PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP(1).
        
        OUTPUT STREAM str-excel TO VALUE (c-arquivo-saida)CONVERT TARGET SESSION:CHARSET.
        PUT STREAM str-excel "ITEM;Cod.Familia;Descriá∆o de Erro" SKIP.
    
        FOR EACH tt-erro:
    
            DISP tt-erro.it-codigo  
                 tt-erro.fm-cod-com 
                 tt-erro.desc-erro
                WITH FRAME b-ns.
            DOWN WITH FRAME b-ns. 
    
            PUT STREAM str-excel UNFORMATTED
                    tt-erro.it-codigo  ";"
                    tt-erro.fm-cod-com ";"
                    tt-erro.desc-erro  SKIP.
        END.
        OUTPUT STREAM str-excel CLOSE.

        PUT "" SKIP(3).
        PUT UNFORMATTED "Relatorio de erros gerado em: " c-arquivo-saida.
    END. /* IF CAN-FIND(FIRST tt-erro) THEN DO: */


    OUTPUT CLOSE.
    RUN pi-finalizar IN h-acomp.


END.

PROCEDURE piImporta: 

    REPEAT:
        
        IMPORT UNFORMATTED c-linha.
        ASSIGN l-erro = NO.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando " + c-linha + ".").
        
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo  = ENTRY(1, c-linha, ";") NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:

            CREATE tt-erro.
            ASSIGN tt-erro.it-codigo  = entry(1, c-linha, ";")
                   tt-erro.fm-cod-com = entry(2, c-linha, ";")
                   tt-erro.desc-erro  = "ITEM n∆o encontrado, alteraá∆o n∆o realizada."
                   l-erro = YES. 
            NEXT.

        END. /* IF NOT AVAIL ITEM THEN DO: */
        ELSE DO:

            FIND FIRST fam-comerc NO-LOCK
                WHERE fam-comerc.fm-cod-com  = ENTRY(2, c-linha, ";") NO-ERROR.
            IF NOT AVAIL fam-comerc THEN DO:

                CREATE tt-erro.
                ASSIGN tt-erro.it-codigo  = entry(1, c-linha, ";")
                       tt-erro.fm-cod-com = entry(2, c-linha, ";")
                       tt-erro.desc-erro  = "Fam°lia comercial n∆o encontrada, alteraá∆o n∆o realizada."
                       l-erro = YES. 
                NEXT.

            END. /* IF NOT AVAIL ITEM THEN DO: */
            ELSE DO:
                RUN pi-acompanhar IN h-acomp (INPUT "Atualizando " + ITEM.it-codigo + ".").

                /****
                ASSIGN ITEM.fm-cod-com = entry(2, c-linha, ";").
                ****/
                DISP ITEM.it-codigo
                     ITEM.desc-item
                     ITEM.fm-cod-com
                    WITH FRAME f-ns.
                DOWN WITH FRAME f-ns. 

                CREATE tt-item.
                BUFFER-COPY item TO tt-item.
                ASSIGN tt-item.fm-cod-com     = entry(2, c-linha, ";")
                       tt-item.ind-tipo-movto = 2.
            END.

        END. /* IF AVAIL ITEM THEN DO: */

    END. /* REPEAT: */
    
END PROCEDURE.



PROCEDURE pi-atualizaItem:

    RUN cdp/cdapi344.p (INPUT TABLE tt-versao-integr,
                        OUTPUT TABLE tt-erros-geral,
                        INPUT-OUTPUT TABLE tt-item).

END PROCEDURE.
