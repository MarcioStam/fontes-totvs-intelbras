/************************************************************************************************************
*      Programa .....: ESACR087RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Inativa itens nas listas de preáo                                                    *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
//123
{include/i-prgvrs.i espdp103rp 2.00.00.000} 

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
 
define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    FIELD tp-execucao            AS INTEGER
    FIELD c-arq-import           AS CHARACTER.


DEF TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nr-tabpre LIKE preco-item.nr-tabpre 
    FIELD it-codigo LIKE preco-item.it-codigo .

DEFINE TEMP-TABLE tt-inativados
    FIELD nr-tabpre LIKE preco-item.nr-tabpre 
    FIELD it-codigo LIKE preco-item.it-codigo 
    FIELD dt-inival LIKE preco-item.dt-inival .
                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE h-acomp         AS HANDLE           NO-UNDO.
DEFINE VARIABLE listCont        AS INT.
/********************************************************************************************/
/*************************** INCLUDES  *****************************************************/
/********************************************************************************************/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{btb/btb912zb.i}

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Inciando").

RUN pi-importa-arquivo.

FOR EACH tt-arquivo:

    ASSIGN listCont = 0 .

    FOR EACH preco-item WHERE preco-item.nr-tabpre = tt-arquivo.nr-tabpre
                          AND preco-item.it-codigo = tt-arquivo.it-codigo 
                          AND preco-item.situacao =  1 EXCLUSIVE-LOCK:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando itens duplicados " + string(preco-item.nr-tabpre) +  " ID:" + STRING(listCont)).
    
        ASSIGN listCont = listCont + 1 .


        ASSIGN preco-item.situacao =  2.
        CREATE tt-inativados.
        ASSIGN tt-inativados.nr-tabpre = preco-item.nr-tabpre
               tt-inativados.it-codigo = preco-item.it-codigo
               tt-inativados.dt-inival = preco-item.dt-inival.
    END.
END.

RUN pi-imprime-extrato.

RUN pi-finalizar in h-acomp.

RETURN "OK":U. //Return Final 

/*******************************************************************************************************************************************************/
/************************************************** PROCEDURES *****************************************************************************************/
/*******************************************************************************************************************************************************/
PROCEDURE pi-importa-arquivo:

    RUN pi-acompanhar IN h-acomp (INPUT "Importando o arquivo").

    DEFINE VARIABLE ncont  AS INT  NO-UNDO INITIAL 1.
    DEFINE VARIABLE xlinha AS CHAR NO-UNDO.
    
    INPUT FROM VALUE(tt-param.c-arq-import).
    IMPORT UNFORMATTED xlinha.
    REPEAT:
        CREATE tt-arquivo.        IMPORT delimiter ";" tt-arquivo.        assign ncont = ncont + 1.
    END.
    INPUT CLOSE.

END. //pi-importa-arquivo

PROCEDURE pi-imprime-extrato:

    PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
    PUT "ESPDP103 - Inativacao de Itens - Listas de Precos                                                                    " SKIP  .
    PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
    PUT "EXTRATO - ITENS INATIVADOS:" SKIP .
    PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
    PUT "ITEM" AT 1
        "DATA" AT 22 SKIP.
    FOR EACH tt-inativados BREAK BY tt-inativados.nr-tabpre BY tt-inativados.it-codigo :
    
        IF FIRST-OF(tt-inativados.nr-tabpre) THEN DO:
            PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
            PUT "LISTA: " tt-inativados.nr-tabpre SKIP.
            PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .

        END.
    
        PUT tt-inativados.it-codigo         FORMAT "X(20)"  AT 1 
            STRING(tt-inativados.dt-inival) FORMAT "X(20)"  AT 22 SKIP.
    END.

END.
