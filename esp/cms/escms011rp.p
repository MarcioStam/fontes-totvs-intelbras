{include/i-prgvrs.i ESCMS011RP 2.00.00.001}
/***********************************************************************
**  Programa..: escms011rp
**  Autor.....: Fabiano Zarpe Henke
**  Data......: Fevereiro/2009 - Desenvolvimento
**  Descricao.: Geraá∆o Inadimplància/Recuperaá∆o Comiss∆o
**  Vers∆o....: 001 18/02/2009
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
/* Parameters Definitions ---                                           */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field fi-periodo       as CHAR FORMAT "999999".

DEF TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/
/*     WITH FRAME fDetalhe NO-ATTR-SPACE STREAM-IO WIDTH 132 DOWN.-*/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Geraá∆o Inadimplància/Recuperaá∆o Comiss∆o"
       c-empresa      = 'INTELBRAS S/A'
       c-programa     = "ESCMS011RP"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Calculando Inadimplància").

    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN piImprimeRelat.

    {include/i-rpclo.i}

    RUN pi-finalizar IN h-acomp.

    RETURN "OK".
end.


/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:

    DEFINE VARIABLE h-cmsbo011 AS HANDLE NO-UNDO.

    FIND FIRST tt-param NO-ERROR.

    /* ** Leitura em tabelas do EMS5, necess†rio outro programa ***/
    RUN esp/cms/escms011bo.p PERSISTENT SET h-cmsbo011.
    RUN pi_calc_inad       IN h-cmsbo011 (INPUT tt-param.fi-periodo,
                                          INPUT YES, /* YES - Oficial, gera tabela comissao-fat / NO - PrÇvia, retorna temp-table */
                                          INPUT 0,
                                          INPUT-OUTPUT TABLE tt-comissao-fat).

    DELETE PROCEDURE h-cmsbo011. 

END.
