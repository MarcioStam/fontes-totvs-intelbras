 /*********************************************************************************
** Programa: esp/cep/escep090rp.p
** Vers∆o..: 1.00
** Data....: 02/02/2022
** Autor...: Graziely Lima -  iDBA
** Obs.....: POST Dados Movto Estoque para o APS
*********************************************************************************/
{include/i-prgvrs.i escep090rp 2.00.00.000}  

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    FIELD tp-execucao          AS INTEGER
    FIELD cod-estabel-de       AS CHARACTER
    FIELD cod-estabel-ate      AS CHARACTER
    FIELD it-codigo-de         AS CHARACTER
    FIELD it-codigo-ate        AS CHARACTER
    FIELD dt-de                AS DATE
    FIELD dt-ate               AS DATE 
    FIELD log-execucao-batch   AS LOGICAL.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE TEMP-TABLE tt-item-tot NO-UNDO
    FIELD it-codigo   AS CHARACTER
    FIELD cod-estabel AS INTEGER
    FIELD quantidade  AS DECIMAL FORMAT "->>>>,>>>,>>9.9999"
    FIELD qtd-saida   AS DECIMAL FORMAT "->>>>,>>>,>>9.9999"
    FIELD qtd-entrada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999".

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE h-acomp                AS HANDLE                             NO-UNDO.
DEFINE VARIABLE d-dt-trans             AS DATE                               NO-UNDO.
DEFINE VARIABLE d-dt-aux-de            AS DATE                               NO-UNDO.
DEFINE VARIABLE d-dt-aux-ate           AS DATE                               NO-UNDO.
DEFINE VARIABLE c-result               AS CHARACTER                          NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)"  NO-UNDO.

DEFINE BUFFER b-ped-item FOR ped-item.
DEFINE BUFFER b-int-nota-fiscal FOR int-nota-fiscal.
def stream s-imp.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
   
{utp/ut-glob.i}
{method/dbotterr.i}
{utp/utapi019.i}
    
/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Buscando Faturamento APS").

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa      NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

IF tt-param.destino = 3 THEN /* Terminal */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ESCEP090.tmp".

IF tt-param.tp-execucao = 2 THEN /* batch */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.

OUTPUT TO VALUE(tt-param.arquivo) NO-CONVERT.

PUT  SKIP 
    "PAR∂METROS DE SELEÄ«O" SKIP(2)
    "Estabelecimento Inicial: " tt-param.cod-estabel-de                          skip
    "Estabelecimento Final:   " tt-param.cod-estabel-ate                         skip
    "Item Inicial:            " tt-param.it-codigo-de                            skip
    "Item Final:              " tt-param.it-codigo-ate                           skip
    "Data Inicial:            " tt-param.dt-de                                   skip
    "Data Final:              " tt-param.dt-ate                                  skip
    SKIP(2).  

EMPTY TEMP-TABLE tt-item-tot.

ASSIGN d-dt-aux-de = DATE(MONTH(TODAY),01,YEAR(TODAY)).

/* Tratamento para selecionar o faturamento inteiro do mes */
IF MONTH(d-dt-aux-de) = 12 THEN
    ASSIGN d-dt-aux-ate = DATE(01,01,YEAR(d-dt-aux-de) + 1) - 1.
ELSE
    ASSIGN d-dt-aux-ate = DATE(MONTH(d-dt-aux-de) + 1,01,YEAR(d-dt-aux-de + 1)) - 1.

PUT "DATA DE FATURAMENTO CONSIDERADA -> : " d-dt-aux-de " ATê " d-dt-aux-ate   SKIP(2).

RUN pi-atualiza-notas.
     
PROCEDURE pi-atualiza-notas:

    FOR EACH mgcad.estabel
       WHERE estabel.cod-estabel >= tt-param.cod-estabel-de
         AND estabel.cod-estabel <= tt-param.cod-estabel-ate,
        EACH ITEM 
       WHERE ITEM.it-codigo >= tt-param.it-codigo-de  
         AND ITEM.it-codigo <= tt-param.it-codigo-ate:
    
        //DO d-dt-trans = d-dt-aux-de TO d-dt-aux-ate:  
        DO d-dt-trans = tt-param.dt-de TO tt-param.dt-ate:

            IF NOT CAN-FIND(FIRST  movto-estoq
                            WHERE  movto-estoq.dt-trans    = d-dt-trans
                              AND  movto-estoq.cod-estabel = estabel.cod-estabel
                              AND (movto-estoq.esp-docto   = 20 
                               OR  movto-estoq.esp-docto   = 22)
                              AND  movto-estoq.it-codigo   = ITEM.it-codigo) THEN NEXT.
            
            CREATE tt-item-tot.

            FOR EACH  movto-estoq FIELDS (it-codigo cod-estabel dt-trans esp-docto tipo-trans quantidade) NO-LOCK
               WHERE  movto-estoq.it-codigo   = ITEM.it-codigo
                 AND  movto-estoq.cod-estabel = estabel.cod-estabel
                 AND  movto-estoq.dt-trans    = d-dt-trans
                 AND (movto-estoq.esp-docto   = 20 
                  OR  movto-estoq.esp-docto   = 22): 
    
                ASSIGN tt-item-tot.it-codigo   = movto-estoq.it-codigo
                       tt-item-tot.cod-estabel = INT(movto-estoq.cod-estabel).
                
                IF movto-estoq.esp-docto = 22 AND movto-estoq.tipo-trans = 2 THEN
                    ASSIGN tt-item-tot.qtd-saida = tt-item-tot.qtd-saida 
                                                 + movto-estoq.quantidade.
                
                IF movto-estoq.esp-docto = 20 AND movto-estoq.tipo-trans = 1 THEN
                    ASSIGN tt-item-tot.qtd-entrada = tt-item-tot.qtd-entrada
                                                   + movto-estoq.quantidade.
    
                
            END.
            ASSIGN tt-item-tot.quantidade = tt-item-tot.qtd-saida 
                                          - tt-item-tot.qtd-entrada.
        END. 
    END.

    FOR EACH tt-item-tot.
       IF tt-item-tot.quantidade <> 0 THEN DO:
           RUN esapi\esapi033.p (INPUT tt-item-tot.quantidade,
                                 INPUT tt-item-tot.cod-estabel,
                                 INPUT tt-item-tot.it-codigo,
                                 OUTPUT c-result).
           IF SUBSTRING(c-result,1,2) = '20' THEN 
               PUT 'Integrado ao APS com Sucesso' SKIP(1).
       END.
       ELSE
           PUT "N∆o foram encontrados dados a serem enviados." SKIP(1).
    END.

END PROCEDURE.

IF NOT CAN-FIND(FIRST tt-item-tot) THEN
    PUT "N∆o foram encontrados dados a serem enviados." SKIP(1). 

OUTPUT CLOSE.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.



