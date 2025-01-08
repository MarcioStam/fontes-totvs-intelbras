/***********************************************************************
**  Programa..: ESP\CEP\ESCEP002RP.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: SETEMBRO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 05/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP002 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cep/escep002tt.i}

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

form 
    "ITEM......:" 
    tt-valor.it-codigo 
    "-" 
    tt-valor.desc-item 
    "-" 
    tt-valor.un             SKIP  
    "COMPRADOR.: " 
    tt-valor.cod-comprado 
    "-"
    tt-valor.nome-comprado  SKIP
    "FORNECEDOR: " 
    tt-valor.nome-abrev     SKIP
    "SALDO.....: " 
    tt-valor.saldo-atu 
    WITH WIDTH 100 CENTERED FRAME f-item NO-LABELS NO-BOX STREAM-IO.

FORM 
    tt-valor.depos                       LABEL "Dep¢sito"
    tt-valor.local       format "x(52)"  LABEL "Localizaá∆o"
    tt-valor.quantidade                  LABEL "Quantidade"
    tt-valor.soma                        LABEL "Soma"
    WITH WIDTH 132 FRAME f-dados STREAM-IO DOWN.

FOR FIRST param-global NO-LOCK,
    FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Saldo por Item"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP002"
       c-versao       = "2.04"
       c-revisao      = "001".

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

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
    
    FOR EACH tt-valor
        BREAK BY tt-valor.it-codigo:

        IF FIRST-OF(tt-valor.it-codigo) THEN
            DISP tt-valor.it-codigo 
                 tt-valor.desc-item 
                 tt-valor.un            
                 tt-valor.cod-comprado 
                 tt-valor.nome-comprado 
                 tt-valor.nome-abrev    
                 tt-valor.saldo-atu 
                 WITH FRAME f-item.

        DISP tt-valor.depos
             tt-valor.local format "x(52)"
             tt-valor.quantidade
             tt-valor.soma
             WITH FRAME f-dados.
        DOWN WITH FRAME f-dados.
    END.

END PROCEDURE.


