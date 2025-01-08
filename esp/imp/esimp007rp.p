/***********************************************************************
**  Programa..: ESP\IMP\ESIMP007RP.P
**  Autor.....: Evandro Pezzi
**  Data......: AGOSTO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Detalhado de Despesas de Produtos Importados
**  VersÆo....: 001 22/08/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESIMP007 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/imp/esimp007tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-desp      no-undo
    field it-codigo         like item.it-codigo
    field dt-trans          as date
    field nro-docto         like docum-est.nro-docto
    field serie-docto       like docum-est.serie-docto
    field num-pedido        like pedido-compr.num-pedido
    field numero-ordem      like ordem-compra.numero-ordem
    field qt-solic          like ordem-compra.qt-solic
    field un                like item-doc-est.un
    field preco-unit        like ordem-compra.preco-unit
    field preco-total       like ordem-compra.preco-orig
    field peso-liq          like item.peso-liquido
    field val-desp-total    like item-doc-est-cex.val-desp
    field fator-internacao  like ordem-compra.preco-orig
    field preco-unit-oc     like ordem-compra.preco-unit.


form tt-desp.it-codigo          column-label "item"             format "x(7)"
     tt-desp.preco-unit         column-label "Preco Unit"       format ">>>,>>9.99"
     tt-desp.preco-total        column-label "Preco Total"      format ">,>>>,>>9.99"
     tt-desp.dt-trans           column-label "Data"
     tt-desp.peso-liq           column-label "Peso liq"         format ">,>>>,>>9.99"
     tt-desp.nro-docto          column-label "Nro NF"           format "x(7)"
     tt-desp.serie-docto        column-label "Serie"
     tt-desp.val-desp-total     column-label "Total Desp."      format ">>>,>>9.99"
     tt-desp.num-pedido         column-label "Pedido"
     tt-desp.numero-ordem       column-label "Nro OC"
     tt-desp.fator-internacao   column-label "FI"               format ">>>9.99"
     tt-desp.qt-solic           column-label "Qtd"              format ">>>,>>9.99"
     tt-desp.un                 column-label "UN"
     tt-desp.preco-unit-oc      column-label "P.U. OC"          format ">>>,>>9.99"
     with frame f-despesas no-box down width 132 stream-io.

/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Despesas de Produtos Importados"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESIMP007"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.


   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.




/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
   
    FOR FIRST tt-param:
        for each docum-est use-index est-origem  
           where docum-est.cod-estabel = tt-param.cod-estabel
             and docum-est.dt-trans   >= tt-param.data-ini
             and docum-est.dt-trans   <= tt-param.data-fim
            no-lock,
           each item-doc-est of docum-est
          where item-doc-est.it-codigo >= tt-param.it-codigo-ini
            and item-doc-est.it-codigo <= tt-param.it-codigo-fim
             no-lock,
            first ordem-compra 
            where ordem-compra.numero-ordem = item-doc-est.numero-ordem
             no-lock,
            first item
            where item.it-codigo = item-doc-est.it-codigo
             no-lock:

            RUN pi-acompanhar IN h-acomp ("NF: " + trim(docum-est.nro-docto)).

            create tt-desp.
            assign tt-desp.it-codigo        = item-doc-est.it-codigo
                   tt-desp.dt-trans         = docum-est.dt-trans
                   tt-desp.nro-docto        = docum-est.nro-docto
                   tt-desp.serie-docto      = docum-est.serie-docto
                   tt-desp.num-pedido       = ordem-compra.num-pedido
                   tt-desp.numero-ordem     = ordem-compra.numero-ordem
                   tt-desp.qt-solic         = item-doc-est.quantidade
                   tt-desp.un               = item-doc-est.un
                   tt-desp.preco-unit       = item-doc-est.preco-unit[1]
                   tt-desp.preco-total      = item-doc-est.preco-total[1]
                   tt-desp.peso-liq         = item-doc-est.peso-liquido
                   tt-desp.preco-unit-oc    = ordem-compra.preco-unit.
             
            for each item-doc-est-cex of item-doc-est no-lock:
                assign tt-desp.val-desp-total = tt-desp.val-desp-total + item-doc-est-cex.val-desp.
            end.
                   
            assign tt-desp.fator-internacao = ((tt-desp.preco-total + tt-desp.val-desp-total) / tt-desp.qt-solic) / tt-desp.preco-unit.
        end.
    end.       


    for each tt-desp
        break by tt-desp.it-codigo
              by tt-desp.dt-trans:

        disp tt-desp.it-codigo       
             tt-desp.preco-unit      
             tt-desp.preco-total     
             tt-desp.dt-trans        
             tt-desp.peso-liq        
             tt-desp.nro-docto       
             tt-desp.serie-docto     
             tt-desp.val-desp-total  
             tt-desp.num-pedido      
             tt-desp.numero-ordem    
             tt-desp.fator-internacao
             tt-desp.qt-solic        
             tt-desp.un      
             tt-desp.preco-unit-oc
             with frame f-despesas.
        down with frame f-despesas.

    end.

end procedure.


/**** Fim do programa ****/
