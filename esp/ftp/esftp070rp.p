/******************************************************************************
** Programa: 
** Data....: 
** Autor...: 
** Objetivo: 
*******************************************************************************/
{include/i-prgvrs.i "ESFTP070" 2.00.00.001} 

/*-------------------------- Defini‡Æo temp-table ----------------------------*/
    
DEF temp-table tt-raw-digita
    field raw-digita as raw.
      
/*----------------------- Recebimento de parametros --------------------------*/
def input parameter raw-param as raw no-undo. 
def input parameter table for tt-raw-digita.   
DEFINE VARIABLE h-esft066 AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cnpj        AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD codigo      AS CHAR
    FIELD indefinido1 AS CHAR FORMAT "x(100)"
    FIELD indefinido2 AS CHAR FORMAT "x(100)"
    FIELD indefinido3 AS CHAR FORMAT "x(100)"
    FIELD iLinha      AS INT
    FIELD FullPath    AS CHAR
    FIELD FILENAME    AS CHAR
    INDEX ch_principal cnpj serie nr-nota-fis.

define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field codEstabel    as char
    field cSerie        as char
    field cNrNotaFis-ini    as char
    field cNrNotaFis-fim    as CHAR
    FIELD da-dt-emis-ini    AS DATE
    FIELD da-dt-emis-fim    AS DATE.

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
       c-programa     = "ESFTP070"
       c-titulo-relat = "Atualiza Status NFe"
       c-sistema      = "Faturamento"
       c-versao       = "2.04"
       c-revisao      = "00.001".

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input "Processando...").

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-acompanhar in h-acomp ("Carregando...").
RUN esp/ftp/esft066rp.p PERSISTENT SET h-esft066.


for each nfe-param fields(cod-estabel) NO-LOCK
    where nfe-param.cod-estabel = tt-param.codEstabel,
    EACH nota-fiscal EXCLUSIVE-LOCK
        WHERE nota-fiscal.cod-estabel   = nfe-param.cod-estabel
          AND nota-fiscal.serie         = tt-param.cSerie
          AND nota-fiscal.nr-nota-fis  >= tt-param.cNrNotaFis-ini
          AND nota-fiscal.nr-nota-fis  <= tt-param.cNrNotaFis-fim
          AND nota-fiscal.dt-emis-nota >= tt-param.da-dt-emis-ini
          AND nota-fiscal.dt-emis-nota <= tt-param.da-dt-emis-fim: 



        run pi-acompanhar in h-acomp (input 'Atualizando NFe ' + nota-fiscal.nr-nota-fis).
        run pi-atualiza-status IN h-esft066 (input nota-fiscal.cod-estabel,
                                             input nota-fiscal.serie,
                                             input string(int(nota-fiscal.nr-nota-fis)),
                                             INPUT-OUTPUT TABLE tt-import).   
    
        FOR FIRST nfe FIELDS(acao ds-chave cod-msg) EXCLUSIVE-LOCK
            WHERE nfe.cod-estabel = nota-fiscal.cod-estabel
              AND nfe.serie       = nota-fiscal.serie
              AND nfe.nr-nota-fis = nota-fiscal.nr-nota-fis:
        END.
        IF nota-fiscal.idi-sit-nf-eletro = 6 THEN
            PUT "Documento esta cancelado, impossivel atualizar : "  nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.
        ELSE
            IF nota-fiscal.idi-sit-nf-eletro = 7 THEN
                PUT "Documento esta Inutilizado, impossivel atualizar : "  nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.
            ELSE
            IF nota-fiscal.idi-sit-nf-eletro = 4 THEN
                PUT "Documento esta com uso Denegado, impossivel atualizar : "  nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.
            ELSE DO:
                
                IF AVAIL nfe AND nfe.acao = 3 THEN DO:
                    assign nota-fiscal.ind-sit-nota = 2.
                    PUT "Nota atualizada " nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.
                END.
                ELSE DO:
                    assign nota-fiscal.ind-sit-nota = 2.
                    PUT "ATENCÇO *************** Nota NÆo Atualizada ********************* " nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP
                        "ATUALIZADO SOMENTE O STATUS PARA IMPRESSA " SKIP.


                END.
                    

            END.
                
           
END.
DELETE PROCEDURE h-esft066.

/*****/

RUN pi-finalizar in h-acomp.

/*------------------------ fechamento do output do relat«rio -----------------------*/ 
{include/i-rpclo.i}         
return "OK":U.
