/***********************************************************************
**  Programa..: ESP\CEP\ESCEP005RP.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: SETEMBRO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 05/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP005 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cep/escep005.i}

{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
     create tt-digita.
     raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

def var h-acomp      as handle no-undo.

find item where item.it-codigo = tt-param.it-codigo no-lock.

form header 
     "Item.:" item.it-codigo  "-"
              item.desc-item  skip
     "Local: " item.cod-localiz
    /* "Saldo: "  tt-param.de-saldo
     "QTD AE: " tt-param.de-quantidade  
     "REC:"     tt-param.de-saldo-rec */ skip
     fill("-",90) format "x(90)"      SKIP(2)
     WITH PAGE-TOP WIDTH 132 FRAME header-frame NO-LABELS STREAM-IO.

FOR FIRST param-global NO-LOCK,
    FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relacao de Etiquetas do Estoque"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP005"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
            
    FIND FIRST tt-param NO-LOCK NO-ERROR.

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:

    view frame header-frame.
    
    for each tt-ae
          by tt-ae.data
          by tt-ae.nr-ae
          by tt-ae.sequencia:
       if tt-param.l-imprime then DO:
           DISP tt-ae 
                WITH FRAME f-1 DOWN WIDTH 132 NO-BOX STREAM-IO.
           DOWN WITH FRAME f-1.
       END.
       ELSE DO:
           disp tt-ae EXCEPT tt-ae.quantidade 
                WITH FRAME f-1 DOWN WIDTH 132 NO-BOX STREAM-IO.
           DOWN WITH FRAME f-1.
       END.
           
    end.

    if tt-param.l-imprime then do:
        disp skip(3) "SALDOS" skip
                     "------" WITH STREAM-IO.

        for each saldo-estoq no-lock
           where saldo-estoq.cod-estabel = tt-param.cod-estabel
             AND saldo-estoq.it-codigo = tt-param.it-codigo
             and saldo-estoq.qtidade-atu <> 0
            break by saldo-estoq.cod-depos:

            disp saldo-estoq.cod-depos
                 saldo-estoq.cod-localiz
                 (saldo-estoq.qtidade-atu  - 
                  saldo-estoq.qt-aloc-prod - 
                  saldo-estoq.qt-aloc-ped  - 
                  saldo-estoq.qt-alocada) format "->>,>>>,>>9.99" 
                 (total by saldo-estoq.cod-depos)
                 with NO-LABELS STREAM-IO.
        end.
    end.   

END PROCEDURE.


