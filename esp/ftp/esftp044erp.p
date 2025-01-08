{include/i-prgvrs.i ESFTP044 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP044RP.P
**  Autor.....: Anderson Cenci
**  Data......: Mar‡o/2008 - Desenvolvimento
**  Descricao.: Relatorio do CAT - Controle de Assistˆncia T‚cnica
**  VersÆo....: 001 04/04/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp044e.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/

def var i-cont                as integer no-undo.
{utp/utapi019.i}
{upc\btb910za-upc.i}

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
{include/tt-edit.i}
{include/pi-edit.i}
def var c-status as char format "x(15)".
form cat.nr-cat             column-label "CAT"    format ">>>,>>9"
     cat.sequencia          column-label "Seq"    format ">>9"
     cat.cod-emitente       column-label "Clente"
     emitente.nome-emit
     cat.nro-docto          column-label "NF Entr."
     cat.serie              column-label "Serie" format "X(03)"
     cat.dt-cat             
     cat.dt-encerramento
     cat.dt-conserto
     c-status               column-label "Situacao"
with frame f-detalhe width 172 64 down stream-io.
def buffer b-emitente for emitente.
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Controle de Assistˆncia T‚cnica"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP044"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}
    
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
   find estabelec
        where estabelec.cod-estabel = v_cod_estab_usuar
        no-lock no-error.
   find b-emitente
        where b-emitente.cod-emitente = estabelec.cod-emitente
        no-lock no-error.
   for each cat no-lock
       where cat.nr-cat     >= tt-param.fi-cat-ini  
         and cat.nr-cat     <= tt-param.fi-cat-fim
         and cat.sequencia  >= tt-param.fi-sequencia-ini
         and cat.sequencia  <= tt-param.fi-sequencia-fim
         and cat.dt-cat >= tt-param.fi-dt-emissao-ini
         and cat.dt-cat <= tt-param.fi-dt-emissao-fim
         and cat.cod-emitente >= tt-param.fi-cliente-ini
         and cat.cod-emitente <= tt-param.fi-cliente-fim
         and cat.nro-docto    >= tt-param.fi-nfe-ini
         and cat.nro-docto    <= tt-param.fi-nfe-fim,
       first emitente no-lock
       where emitente.cod-emitente = cat.cod-emitente
         and emitente.nome-emit    >= tt-param.fi-nome-cli-ini
         and emitente.nome-emit    <= tt-param.fi-nome-cli-fim
       break by cat.nr-cat
             by cat.sequencia:
             
       if tt-param.rs-situacao = 2 and cat.ind-situacao <> 1 then next. 
       if tt-param.rs-situacao = 1 and cat.ind-situacao <> 2 then next.       
             
        RUN pi-acompanhar IN h-acomp (INPUT "Lendo CAT:" + string(cat.nr-cat)).
        if cat.ind-situacao = 1 then
           assign c-status = "NÆo Realizado".
        else
           assign c-status = "Realizado".

        disp cat.nr-cat 
             cat.sequencia
             cat.cod-emitente
             emitente.nome-emit
             cat.nro-docto
             cat.serie
             cat.dt-cat
             cat.dt-encerramento
             cat.dt-conserto
             c-status       
        with frame f-detalhe.
        down with frame f-detalhe. 

   end. 
   
END PROCEDURE.

