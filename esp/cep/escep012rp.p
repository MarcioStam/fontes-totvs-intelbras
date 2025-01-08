/***********************************************************************
**  Programa..: ESP\CEP\ESCEP012RP.P
**  Autor.....: Giovane Oliveira
**  Data......: OUTUBRO/2005 - Desenvolvimento
**  Descricao.: Listagem AE's com Saldo Baixado
**  Vers∆o....: 001 19/10/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP012 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cep/escep012tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

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

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Listagem AE's com Saldo Baixado"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP012"
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

   IF tt-param.imprime-param THEN DO:
       HIDE FRAME f-lin-cab.
       PAGE.

       PUT skip(1)
           "SELEÄ«O"         
           skip(1)
           "Item: "  TO 40 tt-param.it-codigo-ini FORMAT "x(16)" " < > " AT 58 tt-param.it-codigo-fim FORMAT "x(16)".

        PUT skip(1)
           "IMPRESS«O"
           skip(1)
           "Destino: "           TO 40 
           tt-param.arquivo    
           "Usu†rio: " TO 40 tt-param.usuario     
           skip(1).
   END.
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
        for each ae-baixa no-lock
            where ae-baixa.cod-estabel = tt-param.cod-estabel,
            first ae-item FIELDS (it-codigo nr-ae sequencia quantidade) no-lock where
                  ae-item.cod-estabel = ae-baixa.cod-estabel and
                  ae-item.nr-ae = ae-baixa.nr-ae and
                  ae-item.sequencia = ae-baixa.sequencia,
            first item FIELDS (descricao-1 descricao-2) no-lock where
                  item.it-codigo = ae-item.it-codigo and
                  item.it-codigo >= tt-param.it-codigo-ini and
                  item.it-codigo <= tt-param.it-codigo-fim
            break by ae-item.it-codigo
                  BY ae-item.nr-ae
                  BY ae-item.sequencia:

            RUN pi-acompanhar IN h-acomp (ae-item.it-codigo).
           
            disp ae-item.it-codigo format "X(07)" when first-of(ae-item.it-codigo)
                 item.descricao-1 + item.descricao-2 
                         format "X(36)" label "Descriá∆o" 
                         when first-of(ae-item.it-codigo)
                 ae-item.nr-ae
                 ae-item.sequencia
                 ae-baixa.localizacao
                 ae-item.quantidade
                 ae-baixa.char-1  WITH WIDTH 160 NO-BOX STREAM-IO.
        end.

    END.
END.


/**** Fim do programa ****/
