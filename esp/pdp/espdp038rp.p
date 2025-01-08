/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp038rp.p
**  Autor.....: Anderson Cenci
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Atualiza‡Æo da tabela de pre‡os de TROCA
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
{include/i-prgvrs.i espdp038 2.04.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Atualiza‡Æo de Tabela de Pre‡os"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP038"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/pdp/espdp038tt.i}

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE d-cotacao       AS DECIMAL     NO-UNDO.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN piImprimeRelat.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.                     

PROCEDURE piImprimeRelat:
    FOR EACH preco-item
        WHERE preco-item.nr-tabpre = tt-param.tb-preco 
        EXCLUSIVE-LOCK:
        
        RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Item: " + STRING(preco-item.it-codigo)).

        FIND FIRST item-estab
            WHERE item-estab.cod-estabel = tt-param.cod-estabel
              AND item-estab.it-codigo   = preco-item.it-codigo
            NO-LOCK NO-ERROR.
        IF AVAIL item-estab THEN DO:
            ASSIGN preco-item.preco-venda = (item-estab.val-unit-mat-m[1] +
                                             item-estab.val-unit-mob-m[1] +
                                             item-estab.val-unit-ggf-m[1]) * tt-param.ind-acrescimo
                   preco-item.preco-fob   = preco-item.preco-venda.
            DISP preco-item.nr-tabpre 
                 preco-item.it-codigo
                 preco-item.preco-venda
                 preco-item.preco-fob WITH FRAME f-detalhe width 132 64 DOWN STREAM-IO.

        END.
    END.

END PROCEDURE.
