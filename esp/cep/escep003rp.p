/***********************************************************************
**  Programa..: ESP\CEP\ESCEP003RP.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: SETEMBRO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 05/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP003 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cep/escep003tt.i}

{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
     create tt-digita.
     raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

def var h-acomp      as handle no-undo.

FORM 
    "SELEÄ«O"                  AT 01 SKIP(1)                 
    tt-param.c-loc-ini         LABEL "Localizaá∆o.."   AT 01
    "<|>"                                              AT 35
    tt-param.c-loc-fim         NO-LABEL
    tt-param.i-ge-ini          LABEL "Grupo Estoque"   AT 01
    "<|>"                                              AT 35
    tt-param.i-ge-fim          NO-LABEL
    tt-param.c-fm-ini          LABEL "Familia......"   AT 01
    "<|>"                                              AT 35
    tt-param.c-fm-fim          NO-LABEL
    tt-param.c-it-ini          LABEL "Item........."   AT 01
    "<|>"                                              AT 35
    tt-param.c-it-fim          NO-LABEL
    tt-param.c-comprador-ini   LABEL "Comprador...."   AT 01
    "<|>"                                              AT 35
    tt-param.c-comprador-fim   NO-LABEL                      SKIP(2)
    "PARAMETROS"               AT 01 SKIP(1)                 
    tt-param.l-ativo           LABEL "Ativo..........................." AT 01 FORMAT "Sim/N∆o"
    tt-param.l-obsoleto-auto   LABEL "Obsoleto para Ordens Autom†ticas" AT 01 FORMAT "Sim/N∆o"
    tt-param.l-obsoleto        LABEL "Obsoleto para Todas as Ordens..." AT 01 FORMAT "Sim/N∆o"
    tt-param.l-total           LABEL "Totalmente Obsoleto............." AT 01 FORMAT "Sim/N∆o" SKIP(1)
    tt-param.i-mat             LABEL "1 - So Material / 2 - MOB + MAT " AT 01 SKIP(2)
    WITH WIDTH 140 FRAME f-param SIDE-LABELS NO-BOX STREAM-IO.

form 
    "Dep¢sito: " 
    tt-itens.cod-depos
    "-" 
    tt-itens.nome SKIP
    "Valor...: "
    tt-param.d-total-dep
    WITH WIDTH 100 CENTERED FRAME f-deposito NO-LABELS NO-BOX STREAM-IO.

FORM 
    tt-itens.it-codigo    COLUMN-LABEL "Item"
    tt-itens.descricao    COLUMN-LABEL "Descriá∆o"
    tt-itens.quantidade   COLUMN-LABEL "Quantidade"
    tt-itens.unit-mat     LABEL "Vl.Unit Mat Mensal"
    tt-itens.unit-mob     LABEL "Vl.Unit Mob Mensal"
    tt-itens.unit-ggf     LABEL "Vl.Unit GGF Mensal"
    tt-itens.valor        COLUMN-LABEL "Valor"
    WITH WIDTH 140 FRAME f-dados STREAM-IO DOWN.

FOR FIRST param-global NO-LOCK,
    FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Saldo Dep¢sito"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP003"
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

    DISP tt-param.c-loc-ini         
         tt-param.c-loc-fim       
         tt-param.i-ge-ini          
         tt-param.i-ge-fim        
         tt-param.c-fm-ini          
         tt-param.c-fm-fim        
         tt-param.c-it-ini          
         tt-param.c-it-fim        
         tt-param.c-comprador-ini   
         tt-param.c-comprador-fim   
         tt-param.l-ativo           
         tt-param.l-obsoleto-auto   
         tt-param.l-obsoleto        
         tt-param.l-total           
         tt-param.i-mat             
         WITH FRAME f-param.

    FOR EACH tt-itens
        BREAK BY tt-itens.cod-depos:

        IF FIRST-OF(tt-itens.cod-depos) THEN
            DISP tt-itens.cod-depos 
                 tt-itens.nome 
                 tt-param.d-total-dep
                 WITH FRAME f-deposito.

        DISP tt-itens.it-codigo
             tt-itens.descricao
             tt-itens.quantidade
             tt-itens.unit-mat
             tt-itens.unit-mob
             tt-itens.unit-ggf
             tt-itens.valor
             WITH FRAME f-dados.
        DOWN WITH FRAME f-dados.
    END.

END PROCEDURE.


