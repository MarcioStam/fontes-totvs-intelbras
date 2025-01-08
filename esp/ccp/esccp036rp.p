/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp036rp 1.00.00.000}
/*****************************************************************************
**
**       Programa: esp/ccp/esccp036rp.p
**
**       Data....: Janeiro/2014.
**
**       Autor...: SENSUS TECNOLOGIA[Heron Borba]
**
**       Objetivo: Listagem - Planta Edificio.
**
*******************************************************************************/

{include/i-rpvar.i}    

def var h-acomp as handle no-undo.
run utp/ut-acomp.p persistent set h-acomp.                            

def var c-titulo-s                    as char format "x(20)" no-undo.  
def var c-titulo-p                    as char format "x(20)" no-undo.    
def var c-titulo-classificacao        as char format "x(20)" no-undo.    
def var c-titulo-par                  as char format "x(20)" no-undo.    
def var v_titulo_pag                  as char format "x(30)" no-undo.

define temp-table tt-param no-undo
    field destino          as   integer
    field arquivo          as   char format "x(35)"
    field usuario          as   char format "x(12)"
    field data-exec        as   date
    field hora-exec        as   integer
    field nr-processo      like pedido-compr.nr-processo.

def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
{include/i-rpout.i}

PUT UNFORMATTED 
    "Pedido;Processo;Fornec;Nome Abrev;Numero Ordem;Parcela;Quantidade;Preco" SKIP.

FOR EACH  pedido-compr NO-LOCK
    WHERE pedido-compr.nr-processo = tt-param.nr-processo,
    FIRST emitente NO-LOCK 
    WHERE emitente.cod-emitente = pedido-compr.cod-emitente:

    FOR EACH  ordem-compra NO-LOCK
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
        EACH  prazo-compra OF ordem-compra NO-LOCK
        WHERE prazo-compra.situacao <> 4 :

        PUT UNFORMATTED
            pedido-compr.num-pedido   ';'
            pedido-compr.nr-processo  ';'
            pedido-compr.cod-emitente ';'
            emitente.nome-abrev       ';'
            prazo-compra.numero-ordem ';'
            prazo-compra.parcela      ';'
            prazo-compra.quantidade   ';'
            ordem-compra.preco-fornec SKIP. 
    END. /* FOR EACH  ordem-compra NO-LOCK */
END. /* FOR EACH  pedido-compr NO-LOCK */

{include/i-rpclo.i}

MESSAGE "Relat¢rio " TRIM(tt-param.arquivo) " Gerado com Sucesso!" VIEW-AS ALERT-BOX INFO BUTTONS OK.

return "OK".
