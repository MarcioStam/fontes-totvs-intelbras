/***********************************************************************
**  Programa..: ESP\CSP\eswmp020RP.P
**  Autor.....: Nicolas Martinez
**  Data......: 28/02/2020
************************************************************************/
{include/i-prgvrs.i eswmp020RP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/wmp/eswmp020tt.i}
{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

{include/i-rpvar.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

DEFINE VARIABLE c-arquivo-item AS CHAR NO-UNDO.
DEFINE VARIABLE c-arquivo-nota AS CHAR NO-UNDO.
DEFINE VARIABLE c-destino AS CHAR FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-tipo    AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE VARIABLE de-tot-nota LIKE item-doc-est.preco-total[1] NO-UNDO.
                                          
DEFINE STREAM s1.
DEFINE STREAM s2.

find mgcad.empresa
    where empresa.ep-codigo = "1" no-lock no-error.

find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio de Compras - Condi‡Æo de pagamento * }

assign c-titulo-relat = RETURN-VALUE.
assign c-empresa     = param-global.grupo
       c-programa    = "eswmp020":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

form
/*form-selecao-ini*/
    skip(1)
    "                                                    SELE€ÇO"         
    skip(1) 
    /*form-selecao-usuario*/
    tt-param.cod-estabel-ini COLON 44 label "Estab" 
    "<|   |>" at 53 tt-param.cod-estabel-fim no-label skip

    tt-param.cod-local-ini FORMAT "x(5)" colon 34 label "Local" 
    "<|   |>" at 53 tt-param.cod-local-fim FORMAT "x(5)" no-label skip

    tt-param.cod-picking-ini FORMAT "x(7)" colon 34 label "Area Picking" 
    "<|   |>" at 53 tt-param.cod-picking-fim FORMAT "x(7)" no-label skip

    tt-param.item-ini FORMAT "x(16)" colon 34 label "Item" 
    "<|   |>" at 53 tt-param.item-fim FORMAT "x(16)" no-label skip
    skip(1)
    "                                                    ARQUIVO"         
    skip(1)
    "Caminho arquivo Itens '.CSV' em: " at 26  c-arquivo-item NO-LABEL FORMAT "x(80)" SKIP
    skip(1) 
    "                                                   IMPRESSÇO"
    skip(1) 
    c-destino           label "Destino" colon 41 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu rio" colon 41
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 200 frame f-impressao.

/* ***************************  Main Block  *************************** */
{include/i-rpcab.i}
{include/i-rpout.i} 

view frame f-cabec.
view frame f-rodape.    
run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Imprimindo":U). 

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "/" + "eswmp020_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE                                                                                   
    ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "\" + "eswmp020_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

RUN piImprimeRelat.

disp tt-param.cod-estabel-ini
     tt-param.cod-estabel-fim
     tt-param.cod-local-ini
     tt-param.cod-local-fim
     tt-param.cod-picking-ini
     tt-param.cod-picking-fim
     tt-param.item-ini
     tt-param.item-fim 
     c-arquivo-item
     c-destino           
     tt-param.arquivo    
     tt-param.usuario 
         with frame f-impressao.   

run pi-finalizar in h-acomp.
{include/i-rpclo.i}

RETURN "OK".

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEF VAR c-status AS CHAR FORMAT "x(20)" NO-UNDO.

    OUTPUT STREAM s1 TO VALUE(c-arquivo-item) CONVERT TARGET "iso8859-1".

    PUT stream s1 "Item;Estab;Local;Cod Picking;Id Box Comp;Bloco;Rua;Nivel;Coluna;Lado;Cap Util UA;Cap Util Peso" SKIP.

    FOR EACH wm-item-picking WHERE
             wm-item-picking.cod-estabel >= tt-param.cod-estabel-ini AND
             wm-item-picking.cod-estabel <= tt-param.cod-estabel-fim AND
             wm-item-picking.cod-local   >= tt-param.cod-local-ini   AND
             wm-item-picking.cod-local   <= tt-param.cod-local-fim   AND
             wm-item-picking.cod-picking >= tt-param.cod-picking-ini AND
             wm-item-picking.cod-picking <= tt-param.cod-picking-fim AND
             wm-item-picking.cod-item    >= tt-param.item-ini        AND
             wm-item-picking.cod-item    <= tt-param.item-fim
             NO-LOCK,
        EACH Wm-box-picking WHERE
             Wm-box-picking.cod-estabel = wm-item-picking.cod-estabel AND
             wm-box-picking.cod-local   = wm-item-picking.cod-local   AND
             wm-box-picking.cod-picking = wm-item-picking.cod-picking
             NO-LOCK.
    
        run pi-acompanhar in h-acomp (input 'Est: '    + STRING(wm-item-picking.cod-estabel) 
                                          + ' Local: ' + STRING(wm-item-picking.cod-local)
                                          + ' Area: '  + STRING(wm-item-picking.cod-picking)
                                          + ' Item: '  + STRING(wm-item-picking.cod-item)).

        FIND FIRST wm-box WHERE
                   wm-box.cod-estabel = Wm-box-picking.cod-estabel AND
                   wm-box.cod-local   = Wm-box-picking.cod-local   AND
                   wm-box.id-box      = Wm-box-picking.id-box-comp 
                   NO-LOCK NO-ERROR.
    
        PUT stream s1 
             wm-item-picking.cod-item                     ";"
             Wm-box-picking.cod-estabel                   ";"
             Wm-box-picking.cod-local                     ";"
             Wm-box-picking.cod-picking                   ";"
             Wm-box-picking.id-box-comp                   ";"
             wm-box.cod-bloco                             ";"
             wm-box.cod-rua                               ";"
             wm-box.cod-nivel                             ";"
             wm-box.cod-coluna                            ";"
             {scinc/i02sc030.i 04 wm-box.ind-posicao-box} ";"
             wm-box.qtd-capacidade-ua-util                ";"
             wm-box.qtd-capacidade-peso-util              ";"        
             SKIP.

    END.

    OUTPUT STREAM s1 CLOSE.

END PROCEDURE.


