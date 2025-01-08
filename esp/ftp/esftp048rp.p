/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp048rp.p
**  Autor.....: Andreson Cenci
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Itens Faturados X Saldos Estoques
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
{include/i-prgvrs.i esftp048 2.04.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Itens Faturados X Saldos Estoques"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP048"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/ftp/esftp048tt.i}

DEFINE VARIABLE h-acomp         AS HANDLE                          NO-UNDO.
DEFINE VARIABLE de-saldo        AS DECIMAL  FORMAT ">>>,>>>,>>9"   NO-UNDO.
DEFINE VARIABLE de-qtde-total   AS DECIMAL  FORMAT ">>>,>>>,>>9"   NO-UNDO.


/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}    
   {include/i-rpout.i}

   VIEW FRAME f-cabec.
   VIEW FRAME f-rodape.

   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN piImprimeRelat.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.



PROCEDURE piImprimeRelat:
    FOR EACH nota-fiscal USE-INDEX ch-distancia
        WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-ini
          AND nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-fim
          AND nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
          AND nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim 
          AND nota-fiscal.dt-cancel     = ? 
          AND nota-fiscal.ind-tip-nota  < 5 NO-LOCK,
         EACH it-nota-fisc OF nota-fiscal 
        WHERE it-nota-fisc.it-codigo BEGINS "4" NO-LOCK,
         FIRST item NO-LOCK
        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
        BREAK BY it-nota-fisc.it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Nota: " + STRING(nota-fiscal.nr-nota-fis)).

        ASSIGN de-qtde-total = de-qtde-total + it-nota-fisc.qt-faturada[2].
        IF LAST-OF(it-nota-fisc.it-codigo) THEN DO:
            FOR EACH saldo-estoq 
                where saldo-estoq.it-codigo    = it-nota-fisc.it-codigo
                  AND saldo-estoq.cod-estabel  = nota-fiscal.cod-estabel
                  AND saldo-estoq.cod-refer    = it-nota-fisc.cod-refer
                  AND saldo-estoq.cod-depos   >= tt-param.cod-depos-ini
                  AND saldo-estoq.cod-depos   <= tt-param.cod-depos-fim
                  AND saldo-estoq.cod-localiz >= tt-param.localiza-ini
                  AND saldo-estoq.cod-localiz <= tt-param.localiza-fim
                 NO-LOCK:
                  ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
            END.
            disp it-nota-fisc.it-codigo
                 ITEM.desc-item
                 de-qtde-total  LABEL "Qtd.Faturada"
                 de-saldo       LABEL "Saldo Atual"
                WITH FRAME f-detalhe WIDTH 132 64 DOWN STREAM-IO .
                DOWN WITH FRAME f-detalhe.
            ASSIGN de-saldo      = 0
                   de-qtde-total = 0.
        END.
    END.
END.
