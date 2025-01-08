/*********************************************************************************
** Programa: esp/cep/esftp223rp.p
** Vers∆o..: 1.00
** Data....: 02/02/2022
** Autor...: Graziely Lima -  iDBA
** Obs.....: POST Dados Movto Estoque para o APS
*********************************************************************************/
{include/i-prgvrs.i esftp223rp 2.00.00.000} 

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
    FIELD dt-de                AS DATE
    FIELD dt-ate               AS DATE
    FIELD log-gera-txt         AS LOGICAL
    FIELD log-altera-data      AS LOGICAL
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
    FIELD qtd-entrada AS DECIMAL FORMAT "->>>>,>>>,>>9.9999"
    FIELD qtd-devol   AS DECIMAL FORMAT "->>>>,>>>,>>9.9999".

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE h-acomp                AS HANDLE                             NO-UNDO.
DEFINE VARIABLE d-dt-trans             AS DATE                               NO-UNDO.
DEFINE VARIABLE d-dt-aux-de            AS DATE                               NO-UNDO.
DEFINE VARIABLE d-dt-aux-ate           AS DATE                               NO-UNDO.
DEFINE VARIABLE c-result               AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE id                     AS CHARACTER                          NO-UNDO.
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

IF NOT tt-param.log-gera-txt THEN DO:
    //RUN esapi/esapi033a.p.
    FOR EACH int-aps-fatur EXCLUSIVE-LOCK.
        DELETE int-aps-fatur.
    END.
END.    
    

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Buscando Faturamento APS").

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa      NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

IF tt-param.destino = 3 THEN /* Terminal */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ESFTP223.tmp".

IF tt-param.tp-execucao = 2 THEN /* batch */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.

OUTPUT TO VALUE(tt-param.arquivo) NO-CONVERT.

EMPTY TEMP-TABLE tt-item-tot.

ASSIGN d-dt-aux-de = DATE(MONTH(TODAY),01,YEAR(TODAY)).

/* Tratamento para selecionar o faturamento inteiro do mes */
IF MONTH(d-dt-aux-de) = 12 THEN
    ASSIGN d-dt-aux-ate = DATE(01,01,YEAR(d-dt-aux-de) + 1) - 1.
ELSE
    ASSIGN d-dt-aux-ate = DATE(MONTH(d-dt-aux-de) + 1,01,YEAR(d-dt-aux-de + 1)) - 1.

IF tt-param.log-altera-data = NO THEN
    ASSIGN tt-param.dt-de  = d-dt-aux-de
           tt-param.dt-ate = d-dt-aux-ate.

PUT "DATA DE FATURAMENTO CONSIDERADA -> : " tt-param.dt-de /*d-dt-aux-de*/ " ATê " tt-param.dt-ate /*d-dt-aux-ate*/   SKIP(2).

RUN pi-atualiza-notas.
     
PROCEDURE pi-atualiza-notas:
    
    /* Seleciona as notas fiscais faturadas */
    FOR EACH  nota-fiscal NO-LOCK
       WHERE  nota-fiscal.dt-emis-nota >= tt-param.dt-de //d-dt-aux-de
         AND  nota-fiscal.dt-emis-nota <= tt-param.dt-ate //d-dt-aux-ate
         AND (nota-fiscal.esp-docto     = 22   // Saida
          OR  nota-fiscal.esp-docto     = 20)  // Entrada
         AND  nota-fiscal.dt-cancel     = ?
         AND  nota-fiscal.emite-duplic  = YES:  

        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
             AND it-nota-fisc.serie       = nota-fiscal.serie      
             AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:

            FIND FIRST tt-item-tot
                 WHERE tt-item-tot.it-codigo = it-nota-fisc.it-codigo
                   AND tt-item-tot.cod-estabel = INT(it-nota-fisc.cod-estabel) NO-ERROR.
    
            IF NOT AVAIL tt-item-tot THEN DO:            
                CREATE tt-item-tot.
                ASSIGN tt-item-tot.it-codigo   = it-nota-fisc.it-codigo
                       tt-item-tot.cod-estabel = INT(it-nota-fisc.cod-estabel).
            END.

            IF nota-fiscal.esp-docto = 22 THEN
                ASSIGN tt-item-tot.qtd-saida = tt-item-tot.qtd-saida + it-nota-fisc.qt-faturada[1].
            ELSE 
                ASSIGN tt-item-tot.qtd-entrada = tt-item-tot.qtd-entrada + it-nota-fisc.qt-faturada[1].

        END.
    END. /* FOR EACH nota-fiscal */
        
    FOR EACH devol-cli FIELDS(dt-devol nro-docto serie cod-emitente) NO-LOCK
       WHERE devol-cli.dt-devol >= tt-param.dt-de
         AND devol-cli.dt-devol <= tt-param.dt-ate,
       FIRST nota-fiscal FIELDS (cod-estabel serie nr-nota-fis no-ab-reppri emite-duplic nat-operacao cidade estado nome-transp nr-pedcli nr-praz-med 
                                 vl-taxa-exp nr-fatura cod-cond-pag cod-rep dt-emis-nota observ-nota nome-ab-cli dt-entr-cli cod-protoc) NO-LOCK
       WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
         AND nota-fiscal.serie       = devol-cli.serie
         AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis
         AND nota-fiscal.emite-duplic, 
       EACH item-doc-est FIELDS(item-doc-est.serie-docto item-doc-est.nro-docto item-doc-est.nat-operacao item-doc-est.cod-emitente item-doc-est.it-codigo item-doc-est.serie-comp item-doc-est.nro-comp item-doc-est.seq-comp item-doc-est.nat-operacao
                                item-doc-est.quantidade item-doc-est.preco-total[1] item-doc-est.desconto[1] ITEM-doc-est.aliquota-icm item-doc-est.valor-ipi[1]
                                item-doc-est.preco-unit[1]) of devol-cli NO-LOCK,
       FIRST ITEM FIELDS(it-codigo fm-cod-com desc-item cod-unid-neg) NO-LOCK 
             WHERE item.it-codigo  = item-doc-est.it-codigo:

        FIND FIRST tt-item-tot
             WHERE tt-item-tot.it-codigo   = item-doc-est.it-codigo
               AND tt-item-tot.cod-estabel = INT(nota-fiscal.cod-estabel) NO-LOCK NO-ERROR.
        IF AVAIL tt-item-tot THEN DO:
            ASSIGN tt-item-tot.qtd-devol = item-doc-est.quantidade.
        END.
    END.

    FOR EACH tt-item-tot.
        ASSIGN tt-item-tot.quantidade = (tt-item-tot.qtd-saida - tt-item-tot.qtd-entrada) - tt-item-tot.qtd-devol.
        IF tt-item-tot.quantidade > 0 THEN DO:
            RUN pi-inicializar IN h-acomp (INPUT "Integrando item " + tt-item-tot.it-codigo).
            IF tt-param.log-gera-txt THEN DO:
                EXPORT DELIMITER ";" tt-item-tot EXCEPT qtd-saida qtd-entrada qtd-devol.
            END.
            ELSE DO: 
                /*
                RUN esapi/esapi033.p (INPUT tt-item-tot.quantidade,
                                      INPUT tt-item-tot.cod-estabel,
                                      INPUT tt-item-tot.it-codigo,
                                      OUTPUT c-result).*/
                CREATE int-aps-fatur.
                ASSIGN int-aps-fatur.cod-estabel = string(tt-item-tot.cod-estabel)
                       int-aps-fatur.it-codigo   = tt-item-tot.it-codigo
                       int-aps-fatur.quantidade  = tt-item-tot.quantidade
                       int-aps-fatur.data        = NOW
                       int-aps-fatur.usuario     = c-seg-usuario.
        
                //IF LENGTH(c-result) > 1 AND SUBSTRING(c-result,1,2) = '20' THEN 
                    PUT 'O item ' tt-item-tot.it-codigo ' foi integrado ao APS com Sucesso.' SKIP(1).
                /*ELSE
                    PUT 'N∆o houve integraá∆o com APS.' SKIP(1). */
            END.
        END.
    END.

END PROCEDURE.

IF NOT CAN-FIND(FIRST tt-item-tot) THEN
    PUT "N∆o foram encontrados dados a serem enviados." SKIP(1). 

OUTPUT CLOSE.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.







