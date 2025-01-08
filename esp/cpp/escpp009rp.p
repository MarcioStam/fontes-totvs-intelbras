/***********************************************************************
**  Programa..: ESP\CPP\ESCPP009RP.P
**  Autor.....: Giovane Oliveira
**  Data......: OUTUBRO/2005 - Desenvolvimento
**  Descricao.: Listagem dos itens da linha de producao
**  VersÆo....: 001 19/10/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP009 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cpp/escpp009tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-linha
    field it-codigo like item.it-codigo
    field nr-linha  like item.nr-linha
    field tipo as int 
    field Linha    as integer format ">>" extent 18 label "Li"
    field Minimo like linha-item.minimo
    field Maximo like linha-item.maximo
    field Saldo like saldo-estoq.qtidade-atu label "Saldo" format ">,>>>,>>9"
    index codigo is primary nr-linha it-codigo.

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
       c-titulo-relat = "Itens da Linha"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCPP009"
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
           "SELE€ÇO"         
           skip(1)
           "Estab: " TO 40 tt-param.cod-estabel FORMAT "x(3)"
           "Linha: " TO 40 tt-param.nr-linha-ini FORMAT ">>9" " < > " AT 58 tt-param.nr-linha-fim FORMAT ">>9"
           "Item: "  TO 40 tt-param.it-codigo-ini FORMAT "x(16)" " < > " AT 58 tt-param.it-codigo-fim FORMAT "x(16)"
           "M¡nimo: " TO 40 tt-param.minimo-ini FORMAT ">,>>>,>>9" " < > " AT 58 tt-param.minimo-fim FORMAT ">,>>>,>>9"
           "M ximo: " TO 40 tt-param.maximo-ini FORMAT ">,>>>,>>9" " < > " AT 58 tt-param.maximo-fim FORMAT ">,>>>,>>9"
           SKIP(1)
           "Lista abaixo do m¡nimo? " TO 40 tt-param.lista-min FORMAT "Sim/NÆo" SKIP
           "Lista acima do m ximo? " TO 40 tt-param.lista-max FORMAT "Sim/NÆo" SKIP
           "Lista com Saldo OK? " TO 40 tt-param.lista-ok FORMAT "Sim/NÆo".

        PUT skip(1)
           "IMPRESSÇO"
           skip(1)
           "Destino: "           TO 40 
           tt-param.arquivo    
           "Usu rio: " TO 40 tt-param.usuario     
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
    DEF BUFFER b-linha-item FOR linha-item.
    def var c-situacao as char format "x(8)" label "Situa‡Æo".
    def var c-tipo as char format "x(10)" extent 3 initial ["PadrÆo","énica","Adicional"].

    def var c-cod-depos like item.deposito-pad extent 16
        initial ["tel","cnt","plc","inj","smd","esp","isf","pci","psf","","","","pes","mes","sec","cob"].

    FOR FIRST tt-param:
        for each item no-lock
           where item.cod-obsoleto = 0
             and item.nr-linha >= tt-param.nr-linha-ini
             and item.nr-linha <= tt-param.nr-linha-fim
             and item.it-codigo >= tt-param.it-codigo-ini
             and item.it-codigo <= tt-param.it-codigo-fim:

             find linha-item 
                  where linha-item.cod-estabel = tt-param.cod-estabel
                    AND linha-item.it-codigo = item.it-codigo
                    and linha-item.nr-linha  = item.nr-linha no-error.
             if not avail linha-item then next.
             create tt-linha.
             assign tt-linha.it-codigo = item.it-codigo
                    tt-linha.nr-linha  = item.nr-linha
                    tt-linha.linha[item.nr-linha] = item.nr-linha WHEN item.nr-linha > 0 AND item.nr-linha < 21.
             find first linha-item 
                  where linha-item.cod-estabel = tt-param.cod-estabel
                    AND linha-item.it-codigo = item.it-codigo 
                    and linha-item.nr-linha <> item.nr-linha no-lock no-error.
             if avail linha-item then
                assign tt-linha.tipo = 1.
             else   
                assign tt-linha.tipo = 2.
             for each linha-item no-lock
                where linha-item.cod-estabel = tt-param.cod-estabel
                  AND linha-item.it-codigo = item.it-codigo:
                 assign tt-linha.linha[linha-item.nr-linha] = linha-item.nr-linha WHEN linha-item.nr-linha > 0 AND linha-item.nr-linha < 21.
             end.

        end.
        for each linha-item no-lock
           where linha-item.cod-estabel = tt-param.cod-estabel
             AND linha-item.nr-linha >= tt-param.nr-linha-ini
             and linha-item.nr-linha <= tt-param.nr-linha-fim
             and linha-item.it-codigo >= tt-param.it-codigo-ini
             and linha-item.it-codigo <= tt-param.it-codigo-fim:
            find tt-linha
                 where tt-linha.it-codigo = linha-item.it-codigo
                   and tt-linha.nr-linha  = linha-item.nr-linha no-error.
            if not avail tt-linha then do:
                create tt-linha.
                assign tt-linha.it-codigo = linha-item.it-codigo
                       tt-linha.nr-linha  = linha-item.nr-linha
                       tt-linha.linha[linha-item.nr-linha] = linha-item.nr-linha WHEN linha-item.nr-linha > 0 AND linha-item.nr-linha < 21
                       tt-linha.tipo      = 3.

                 for each b-linha-item no-lock
                    WHERE b-linha-item.cod-estabel = tt-param.cod-estabel 
                     AND b-linha-item.it-codigo = tt-linha.it-codigo:
                     assign tt-linha.linha[b-linha-item.nr-linha] = b-linha-item.nr-linha WHEN b-linha-item.nr-linha > 0 AND b-linha-item.nr-linha < 21.
                 end.
            end.
        end.        
        for each tt-linha:
            RUN pi-acompanhar IN h-acomp (tt-linha.it-codigo).
            find item 
                 where item.it-codigo = tt-linha.it-codigo no-lock no-error.
            if not avail item then do:
                delete tt-linha.
                next.
            end.
            find linha-item 
                 where linha-item.cod-estabel = tt-param.cod-estabel
                   AND linha-item.it-codigo = tt-linha.it-codigo
                   and linha-item.nr-linha  = tt-linha.nr-linha no-lock no-error.
            assign tt-linha.minimo = linha-item.minimo
                   tt-linha.maximo = linha-item.maximo.
                 
            for each saldo-estoq no-lock
               where saldo-estoq.cod-estabel = tt-param.cod-estabel
                 and saldo-estoq.it-codigo = tt-linha.it-codigo
                 and saldo-estoq.cod-depos = c-cod-depos[tt-linha.nr-linha]:
                assign tt-linha.saldo = tt-linha.saldo + saldo-estoq.qtidade-atu. 
            end.
        end.
        
        for each tt-linha
           break by tt-linha.nr-linha:
            RUN pi-acompanhar IN h-acomp (string(tt-linha.nr-linha)).
            
            if first-of(tt-linha.nr-linha) then do:
                find lin-prod 
                     where lin-prod.cod-estabel = tt-param.cod-estabel
                     and   lin-prod.nr-linha = tt-linha.nr-linha no-lock.
                disp lin-prod.nr-linha 
                     " - "
                     lin-prod.descricao 
                     " - " 
                     c-cod-depos[lin-prod.nr-linha]
                     with no-labels frame f-linha STREAM-IO.
            end.

            if tt-linha.saldo < tt-linha.minimo and not tt-param.lista-min then next.
            if tt-linha.saldo > tt-linha.maximo and not tt-param.lista-max then next.
            if tt-linha.saldo >= tt-linha.minimo and 
               tt-linha.saldo <= tt-linha.maximo and not tt-param.lista-ok then next.

            if tt-linha.saldo < tt-linha.minimo then 
                assign c-situacao = "< M¡nimo".
            if tt-linha.saldo > tt-linha.maximo then
                assign c-situacao = "> M ximo".
            if tt-linha.saldo >= tt-linha.minimo and
               tt-linha.saldo <= tt-linha.maximo then
                assign c-situacao = "Saldo OK".
                
            
            find item 
                 where item.it-codigo = tt-linha.it-codigo no-lock.
            disp item.it-codigo format "x(7)"
                 item.descricao-1 + item.descricao-2 format "x(36)"
                 label "Descri‡Æo"
                 c-tipo[tt-linha.tipo] label "Tipo" 
                 tt-linha.linha 
                 tt-linha.minimo
                 tt-linha.maximo
                 tt-linha.saldo
                 c-situacao
                 with width 255 STREAM-IO.
            if last-of(tt-linha.nr-linha) then page.
        end.
    END.
END.


/**** Fim do programa ****/
