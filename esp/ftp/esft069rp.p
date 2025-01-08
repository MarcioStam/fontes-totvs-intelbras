/******************************************************************************
** Programa: 
** Data....: 
** Autor...: 
** Objetivo: 
*******************************************************************************/
{include/i-prgvrs.i "ESFT069" 2.00.00.001} 

/*-------------------------- Defini‡Æo temp-table ----------------------------*/
    
DEF temp-table tt-raw-digita
    field raw-digita as raw.
      
/*----------------------- Recebimento de parametros --------------------------*/
def input parameter raw-param as raw no-undo. 
def input parameter table for tt-raw-digita.   

define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field codEstabel    as char
    field cSerie        as char
    field cNrNotaFis    as char.

create tt-param.
raw-transfer raw-param to tt-param.    


/*-------------- include padr’o para vari veis de relat½rio ------------------*/
{include/i-rpvar.i}

{include/tt-edit.i}
{include/i-freeac.i} /* Retira os acentos */

def var h-acomp         as handle no-undo. 

DEFINE VARIABLE i-cont            AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont2           AS INTEGER    NO-UNDO.

/*-------------------------- Definicao de variaveis --------------------------*/
{utp/ut-glob.i}


DEFINE VARIABLE entrou    AS LOGICAL INITIAL NO         NO-UNDO.

/*--------- include com a defini‡Æo da frame de cabe‡alho e rodap‚ -----------*/
{include/i-rpcab.i} 

/*---------------- include padr’o para output de relat½rios ------------------*/
{include/i-rpout.i}

/*------------------- bloco principal do programa ----------------------------*/
FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN c-empresa      = "INTELBRAS"
       c-programa     = "ESFT069"
       c-titulo-relat = "Gera‡Æo de XML - NFE"
       c-sistema      = "Faturamento"
       c-versao       = "2.04"
       c-revisao      = "00.001".

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input "Processando...").

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-acompanhar in h-acomp ("Carregando...").


for each nfe-param fields(cod-estabel) NO-LOCK
    where nfe-param.cod-estabel = tt-param.codEstabel.
    
    run pi-acompanhar in h-acomp (input 'Gera‡Æo de XML...').
    RUN esp/ftp/esft067rp.p (INPUT tt-param.codEstabel,
                             input 'nfe_' + tt-param.cNrNotaFis + '_' + trim(tt-param.codEstabel) + "_" +  trim(tt-param.cSerie) + "_" + replace(string(today,'99/99/9999'),'/','_') + '.txt').

    put unformatted 'Arquivo XML gerado com sucesso.' skip.
END.

/*****/

RUN pi-finalizar in h-acomp.

/*------------------------ fechamento do output do relat«rio -----------------------*/ 
{include/i-rpclo.i}         
return "OK":U.
