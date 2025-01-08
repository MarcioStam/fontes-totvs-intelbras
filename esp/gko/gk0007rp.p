/*****************************************************************************
**
**     Objetivo: Importa‡Æo contabiliza‡Æo GKO para SPED
**
**     Versao..: 2.00.00.000
**     Autor: hoepers - 27/04/2016
*****************************************************************************/
{include/i-prgvrs.i gk0007 2.00.00.000}

{utp/ut-glob.i}

define temp-table tt-param   no-undo
    field destino            as integer
    field arquivo            as char    format "x(35)"
    field usuario            as char    format "x(12)"
    field data-exec          as date
    field hora-exec          as integer.

define temp-table tt-digita no-undo
    field num-nota     like nota-fiscal.nr-nota-fis.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-importa-movto-gko NO-UNDO
    FIELD cgc-intelbras     LIKE emitente.cgc
    FIELD cgc-transp        LIKE emitente.cgc
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD cod-estabel       LIKE estabelec.cod-estabel
    FIELD cod-nota            AS CHAR
    FIELD cod-serie           AS CHAR
    FIELD cod-ctrc            AS CHAR
    FIELD cod-fatura          AS CHAR
    FIELD cod-conta           AS CHAR
    FIELD cod-ccusto          AS CHAR
    FIELD des-conta           AS CHAR
    FIELD des-movto           AS CHAR
    FIELD des-historico       AS CHAR
    FIELD cod-modul-dtsul     AS CHAR
    FIELD cod-lancto-ctbl     AS CHAR
    FIELD cod-lote-ctbl       AS CHAR
    FIELD val-credito         AS DEC
    FIELD val-debito          AS DEC
    FIELD dat-movto           AS DATE
    INDEX id-conta
            cod-conta
    INDEX id-lote
            cod-lote-ctbl.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF BUFFER b-dwf-sdo-ctbl FOR dwf-sdo-ctbl.

DEFINE VARIABLE c-arquivo-origem     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-linha-imp          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-ind-espec-cta-ctbl AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-nivel-conta        AS CHARACTER   EXTENT 4 NO-UNDO.
DEFINE VARIABLE i-seq-lancto         AS INTEGER              NO-UNDO.
DEFINE VARIABLE i-nivel-conta        AS INTEGER              NO-UNDO.
DEFINE VARIABLE de-val-tot-lancto-db AS DECIMAL              NO-UNDO.
DEFINE VARIABLE de-val-tot-lancto-cr AS DECIMAL              NO-UNDO.
DEFINE VARIABLE da-ini-mes           AS DATE                 NO-UNDO.
DEFINE VARIABLE da-fim-mes           AS DATE                 NO-UNDO.
DEFINE VARIABLE h-acomp              AS HANDLE               NO-UNDO.

/*******************************************************************/

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND LAST   param-global NO-LOCK NO-ERROR.
FIND FIRST  tt-param     NO-LOCK NO-ERROR.

IF  NOT VALID-HANDLE(h-acomp) 
THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF  VALID-HANDLE(h-acomp) 
THEN DO:
    RUN pi-inicializar IN h-acomp (INPUT "").
    RUN pi-seta-titulo IN h-acomp (INPUT "Dados GKO para SPED").
END.

/* Identificar arquivo origem do GKO para SPED */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0007"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOWIN32"
            THEN
                ASSIGN c-arquivo-origem = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOUNIX"
            THEN
                ASSIGN c-arquivo-origem = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.

EMPTY TEMP-TABLE tt-importa-movto-gko.

IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Importando Arquivo").

INPUT FROM VALUE(c-arquivo-origem) CONVERT SOURCE "iso8859-1".

REPEAT:
    IMPORT UNFORMATTED c-linha-imp.
    ASSIGN c-linha-imp  = REPLACE(c-linha-imp,'"',"")
           i-seq-lancto = i-seq-lancto + 1.

    IF  VALID-HANDLE(h-acomp) 
    THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Arquivo - Linha: " + STRING(i-seq-lancto)).

    IF  c-linha-imp BEGINS "Filial"
    THEN
        NEXT.

    CREATE tt-importa-movto-gko.
    ASSIGN tt-importa-movto-gko.cgc-intelbras   = ENTRY(1,c-linha-imp,";")
           tt-importa-movto-gko.cgc-transp      = ENTRY(2,c-linha-imp,";")
           tt-importa-movto-gko.cod-nota        = ENTRY(3,c-linha-imp,";")
           tt-importa-movto-gko.cod-serie       = ENTRY(4,c-linha-imp,";")
           tt-importa-movto-gko.cod-ctrc        = ENTRY(5,c-linha-imp,";")
           tt-importa-movto-gko.cod-fatura      = ENTRY(6,c-linha-imp,";")
           tt-importa-movto-gko.cod-conta       = ENTRY(7,c-linha-imp,";")
           tt-importa-movto-gko.cod-ccusto      = SUBSTR(ENTRY(8,c-linha-imp,";"),4,5)
           tt-importa-movto-gko.des-conta       = ENTRY(9,c-linha-imp,";")
           tt-importa-movto-gko.val-credito     = DEC(ENTRY(10,c-linha-imp,";"))
           tt-importa-movto-gko.val-debito      = DEC(ENTRY(11,c-linha-imp,";"))
           tt-importa-movto-gko.des-movto       = ENTRY(12,c-linha-imp,";")
           tt-importa-movto-gko.dat-movto       = DATE(ENTRY(13,c-linha-imp,";"))
           tt-importa-movto-gko.cod-lancto-ctbl = STRING(ROWID(tt-importa-movto-gko))
           tt-importa-movto-gko.cod-lote-ctbl   = STRING(MONTH(tt-importa-movto-gko.dat-movto),"99") + STRING(YEAR(tt-importa-movto-gko.dat-movto),"9999")
           tt-importa-movto-gko.cod-modul-dtsul = "GKO"
           tt-importa-movto-gko.des-historico   = tt-importa-movto-gko.des-movto                + " # " +
                                                  " Nota/Ser: " + tt-importa-movto-gko.cod-nota + "/"   + tt-importa-movto-gko.cod-serie + " # " + 
                                                  " CTRC: "     + tt-importa-movto-gko.cod-ctrc + " # " +
                                                  " Fatura: "   + tt-importa-movto-gko.cod-fatura.                                            

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cgc = tt-importa-movto-gko.cgc-intelbras NO-ERROR.

    IF  AVAIL estabelec
    THEN
        ASSIGN tt-importa-movto-gko.cod-estabel = estabelec.cod-estabel.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cgc = tt-importa-movto-gko.cgc-transp NO-ERROR.

    IF  AVAIL emitente
    THEN
         tt-importa-movto-gko.cod-emitente = emitente.cod-emitente.
END.

INPUT CLOSE.

IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Eliminando dados J  Existentes").

/* Eliminar dados j  existentes */
FOR EACH tt-importa-movto-gko
    BREAK BY tt-importa-movto-gko.cod-lote-ctbl:

    IF  FIRST-OF(tt-importa-movto-gko.cod-lote-ctbl)
    THEN DO:
        IF  VALID-HANDLE(h-acomp) 
        THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Eliminando Lote: " + tt-importa-movto-gko.cod-lote-ctbl + " 1/3: dwf-item-lancto-ctbl").

        FOR EACH  dwf-item-lancto-ctbl EXCLUSIVE-LOCK
            WHERE dwf-item-lancto-ctbl.cdn-empresa     = "1"
              AND dwf-item-lancto-ctbl.cod-empresa     = "1"
              AND dwf-item-lancto-ctbl.cod-modul-dtsul = tt-importa-movto-gko.cod-modul-dtsul
              AND dwf-item-lancto-ctbl.cod-lote-ctbl   = tt-importa-movto-gko.cod-lote-ctbl:
            DELETE dwf-item-lancto-ctbl.
        END.
    
        IF  VALID-HANDLE(h-acomp) 
        THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Eliminando Lote: " + tt-importa-movto-gko.cod-lote-ctbl + " 2/3: dwf-lancto-ctbl").

        FOR EACH  dwf-lancto-ctbl EXCLUSIVE-LOCK
            WHERE dwf-lancto-ctbl.cod-empresa     = "1"
              AND dwf-lancto-ctbl.cdn-empresa     = "1"
              AND dwf-lancto-ctbl.cod-modul-dtsul = tt-importa-movto-gko.cod-modul-dtsul 
              AND dwf-lancto-ctbl.cod-lote-ctbl   = tt-importa-movto-gko.cod-lote-ctbl:
            DELETE dwf-lancto-ctbl.
        END.
    
        IF  VALID-HANDLE(h-acomp) 
        THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Eliminando Lote: " + tt-importa-movto-gko.cod-lote-ctbl + " 3/3: dwf-sdo-ctbl").

        FOR EACH  dwf-sdo-ctbl EXCLUSIVE-LOCK
            WHERE dwf-sdo-ctbl.cod-empresa     = "1"
              AND dwf-sdo-ctbl.cdn-empresa     = "1"
              AND dwf-sdo-ctbl.cod-modul-dtsul = tt-importa-movto-gko.cod-modul-dtsul
              AND dwf-sdo-ctbl.num-exerc-ctbl  = YEAR(tt-importa-movto-gko.dat-movto):
            DELETE dwf-sdo-ctbl.
        END.
    END. /* IF  FIRST-OF(tt-importa-movto-gko.cod-lote-ctbl) */
END. /* FOR FIRST tt-importa-movto-gko: */

IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Criando dados SPED").

ASSIGN i-seq-lancto = 0.

FOR EACH tt-importa-movto-gko
    BREAK BY tt-importa-movto-gko.cod-conta:

    IF  VALID-HANDLE(h-acomp) 
    THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Criando dados SPED Conta: " + tt-importa-movto-gko.cod-conta).

    IF  FIRST-OF(tt-importa-movto-gko.cod-conta)
    THEN DO:
        ASSIGN c-ind-espec-cta-ctbl = "Anal¡tica".

        FOR FIRST cta_ctbl NO-LOCK
            WHERE cta_ctbl.cod_plano_cta_ctbl = "Padrao"
              AND cta_ctbl.cod_cta_ctbl       = tt-importa-movto-gko.cod-conta:
            ASSIGN c-ind-espec-cta-ctbl = cta_ctbl.ind_espec_cta_ctbl.
        END.
    END.

    ASSIGN i-seq-lancto = i-seq-lancto + 1
           da-ini-mes   = DATE(MONTH(tt-importa-movto-gko.dat-movto), 1, YEAR(tt-importa-movto-gko.dat-movto))
           da-fim-mes   = ADD-INTERVAL(da-ini-mes,1 ,"MONTH") - DAY(da-ini-mes).

    DO TRANS ON ERROR UNDO, LEAVE:
        CREATE dwf-item-lancto-ctbl.
        ASSIGN dwf-item-lancto-ctbl.cdn-empresa            = "1"
               dwf-item-lancto-ctbl.cod-empresa            = "1"
               dwf-item-lancto-ctbl.cod-estab              = tt-importa-movto-gko.cod-estabel
               dwf-item-lancto-ctbl.cod-lote-ctbl          = tt-importa-movto-gko.cod-lote-ctbl
               dwf-item-lancto-ctbl.cod-lancto-ctbl        = tt-importa-movto-gko.cod-lancto-ctbl
               dwf-item-lancto-ctbl.cod-modul-dtsul        = tt-importa-movto-gko.cod-modul-dtsul
               dwf-item-lancto-ctbl.cod-cta-ctbl           = tt-importa-movto-gko.cod-conta
               dwf-item-lancto-ctbl.cod-ccusto             = tt-importa-movto-gko.cod-ccusto
               dwf-item-lancto-ctbl.dat-inic-valid         = tt-importa-movto-gko.dat-movto
               dwf-item-lancto-ctbl.des-histor-lancto-ctbl = tt-importa-movto-gko.des-historico
               dwf-item-lancto-ctbl.num-seq-lancto-ctbl    = i-seq-lancto.
    
        FIND FIRST dwf-sdo-ctbl 
            WHERE  dwf-sdo-ctbl.cod-modul-dtsul = dwf-item-lancto-ctbl.cod-modul-dtsul
              AND  dwf-sdo-ctbl.cod-empresa     = dwf-item-lancto-ctbl.cod-empresa
              AND  dwf-sdo-ctbl.cdn-empresa     = dwf-item-lancto-ctbl.cdn-empresa
              AND  dwf-sdo-ctbl.cod-cta-ctbl    = dwf-item-lancto-ctbl.cod-cta-ctbl
              AND  dwf-sdo-ctbl.cod-ccusto      = ""
              AND  dwf-sdo-ctbl.cod-unid-negoc  = ""
              AND  dwf-sdo-ctbl.num-period-ctbl = MONTH(dwf-item-lancto-ctbl.dat-inic-valid)
              AND  dwf-sdo-ctbl.num-exerc-ctbl  = YEAR (dwf-item-lancto-ctbl.dat-inic-valid)
              AND  dwf-sdo-ctbl.cod-estab       = ""
              AND  dwf-sdo-ctbl.dat-inic-valid  = da-fim-mes NO-ERROR.
    
        IF  NOT AVAIL(dwf-sdo-ctbl)
        THEN DO:
            CREATE dwf-sdo-ctbl.
            ASSIGN dwf-sdo-ctbl.cod-modul-dtsul    = dwf-item-lancto-ctbl.cod-modul-dtsul      
                   dwf-sdo-ctbl.cod-empresa        = dwf-item-lancto-ctbl.cod-empresa          
                   dwf-sdo-ctbl.cdn-empresa        = dwf-item-lancto-ctbl.cdn-empresa          
                   dwf-sdo-ctbl.cod-cta-ctbl       = dwf-item-lancto-ctbl.cod-cta-ctbl         
                   dwf-sdo-ctbl.cod-ccusto         = ""                                        
                   dwf-sdo-ctbl.cod-unid-negoc     = ""                                        
                   dwf-sdo-ctbl.num-period-ctbl    = MONTH(dwf-item-lancto-ctbl.dat-inic-valid)
                   dwf-sdo-ctbl.num-exerc-ctbl     = YEAR (dwf-item-lancto-ctbl.dat-inic-valid)
                   dwf-sdo-ctbl.cod-estab          = ""          
                   dwf-sdo-ctbl.dat-inic-valid     = da-fim-mes
                   dwf-sdo-ctbl.ind-espec-cta-ctbl = c-ind-espec-cta-ctbl
                   dwf-sdo-ctbl.ind-sdo-ctbl-inic  = "D"
                   dwf-sdo-ctbl.ind-sdo-ctbl-fim   = "D".
        END.
    
        IF  tt-importa-movto-gko.val-credito <> 0
        THEN DO:
            ASSIGN dwf-item-lancto-ctbl.ind-natur-lancto-ctbl = "C"
                   dwf-item-lancto-ctbl.val-lancto-ctbl       = tt-importa-movto-gko.val-credito
                   dwf-sdo-ctbl.val-sdo-ctbl-cr               = dwf-sdo-ctbl.val-sdo-ctbl-cr + dwf-item-lancto-ctbl.val-lancto-ctbl
                   de-val-tot-lancto-cr                       = de-val-tot-lancto-cr         + dwf-item-lancto-ctbl.val-lancto-ctbl.
    
            CREATE dwf-lancto-ctbl.
            ASSIGN dwf-lancto-ctbl.cod-empresa                = dwf-item-lancto-ctbl.cod-empresa
                   dwf-lancto-ctbl.cdn-empresa                = dwf-item-lancto-ctbl.cdn-empresa
                   dwf-lancto-ctbl.cod-lote-ctbl              = dwf-item-lancto-ctbl.cod-lote-ctbl
                   dwf-lancto-ctbl.cod-lancto-ctbl            = dwf-item-lancto-ctbl.cod-lancto-ctbl
                   dwf-lancto-ctbl.cod-modul-dtsul            = dwf-item-lancto-ctbl.cod-modul-dtsul
                   dwf-lancto-ctbl.val-lancto-ctbl            = dwf-item-lancto-ctbl.val-lancto-ctbl
                   dwf-lancto-ctbl.dat-lancto-ctbl            = da-ini-mes
                   dwf-lancto-ctbl.dat-inic-valid             = da-fim-mes
                   dwf-lancto-ctbl.log-lancto-apurac-restdo   = NO
                   dwf-lancto-ctbl.ind-lancto-ctbl            = "N".
        END.
        ELSE
            ASSIGN dwf-item-lancto-ctbl.ind-natur-lancto-ctbl = "D"
                   dwf-item-lancto-ctbl.val-lancto-ctbl       = tt-importa-movto-gko.val-debito
                   dwf-sdo-ctbl.val-sdo-ctbl-db               = dwf-sdo-ctbl.val-sdo-ctbl-db + dwf-item-lancto-ctbl.val-lancto-ctbl
                   de-val-tot-lancto-db                       = de-val-tot-lancto-db         + dwf-item-lancto-ctbl.val-lancto-ctbl.
    END. /* DO TRANS ON ERROR UNDO, LEAVE: */
END. /* FOR EACH tt-importa-movto-gko */

IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Gerando Hist¢rico").

RUN pi-gera-historico. 

IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Gerando Saldo Contas Sint‚ticas").

/* Gera saldo contas sint‚ticas */
FOR EACH  dwf-sdo-ctbl NO-LOCK
    WHERE dwf-sdo-ctbl.cod-modul-dtsul    = "gko"
      AND dwf-sdo-ctbl.ind-espec-cta-ctbl = "Anal¡tica"
    BREAK BY dwf-sdo-ctbl.cod-modul-dtsul
          BY dwf-sdo-ctbl.cod-empresa    
          BY dwf-sdo-ctbl.cdn-empresa    
          BY dwf-sdo-ctbl.cod-cta-ctbl
          BY dwf-sdo-ctbl.cod-ccusto     
          BY dwf-sdo-ctbl.cod-unid-negoc 
          BY dwf-sdo-ctbl.num-period-ctbl
          BY dwf-sdo-ctbl.num-exerc-ctbl 
          BY dwf-sdo-ctbl.cod-estab      
          BY dwf-sdo-ctbl.dat-inic-valid:

    IF  VALID-HANDLE(h-acomp) 
    THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando Sint‚tica p/ Conta: " + dwf-sdo-ctbl.cod-cta-ctbl).

    IF  FIRST-OF(dwf-sdo-ctbl.dat-inic-valid)
    THEN DO:
        ASSIGN c-nivel-conta = "".

        RUN pi-conta-sintetica (INPUT dwf-sdo-ctbl.cod-cta-ctbl,
                                INPUT 4).

        DO i-nivel-conta = 1 TO 4:

            FIND FIRST b-dwf-sdo-ctbl 
                WHERE  b-dwf-sdo-ctbl.cod-modul-dtsul =  dwf-sdo-ctbl.cod-modul-dtsul
                  AND  b-dwf-sdo-ctbl.cod-empresa     =  dwf-sdo-ctbl.cod-empresa    
                  AND  b-dwf-sdo-ctbl.cdn-empresa     =  dwf-sdo-ctbl.cdn-empresa    
                  AND  b-dwf-sdo-ctbl.cod-cta-ctbl    =  c-nivel-conta[i-nivel-conta]
                  AND  b-dwf-sdo-ctbl.cod-ccusto      =  dwf-sdo-ctbl.cod-ccusto     
                  AND  b-dwf-sdo-ctbl.cod-unid-negoc  =  dwf-sdo-ctbl.cod-unid-negoc 
                  AND  b-dwf-sdo-ctbl.num-period-ctbl =  dwf-sdo-ctbl.num-period-ctbl
                  AND  b-dwf-sdo-ctbl.num-exerc-ctbl  =  dwf-sdo-ctbl.num-exerc-ctbl 
                  AND  b-dwf-sdo-ctbl.cod-estab       =  dwf-sdo-ctbl.cod-estab      
                  AND  b-dwf-sdo-ctbl.dat-inic-valid  =  dwf-sdo-ctbl.dat-inic-valid NO-ERROR.

            IF  NOT AVAIL(b-dwf-sdo-ctbl)
            THEN DO:
                CREATE b-dwf-sdo-ctbl.
                ASSIGN b-dwf-sdo-ctbl.cod-modul-dtsul    = dwf-sdo-ctbl.cod-modul-dtsul   
                       b-dwf-sdo-ctbl.cod-empresa        = dwf-sdo-ctbl.cod-empresa       
                       b-dwf-sdo-ctbl.cdn-empresa        = dwf-sdo-ctbl.cdn-empresa       
                       b-dwf-sdo-ctbl.cod-cta-ctbl       = c-nivel-conta[i-nivel-conta]      
                       b-dwf-sdo-ctbl.cod-ccusto         = dwf-sdo-ctbl.cod-ccusto        
                       b-dwf-sdo-ctbl.cod-unid-negoc     = dwf-sdo-ctbl.cod-unid-negoc    
                       b-dwf-sdo-ctbl.num-period-ctbl    = dwf-sdo-ctbl.num-period-ctbl   
                       b-dwf-sdo-ctbl.num-exerc-ctbl     = dwf-sdo-ctbl.num-exerc-ctbl    
                       b-dwf-sdo-ctbl.cod-estab          = dwf-sdo-ctbl.cod-estab         
                       b-dwf-sdo-ctbl.dat-inic-valid     = dwf-sdo-ctbl.dat-inic-valid    
                       b-dwf-sdo-ctbl.ind-espec-cta-ctbl = "Sint‚tica"
                       b-dwf-sdo-ctbl.ind-sdo-ctbl-inic  = dwf-sdo-ctbl.ind-sdo-ctbl-inic 
                       b-dwf-sdo-ctbl.ind-sdo-ctbl-fim   = dwf-sdo-ctbl.ind-sdo-ctbl-fim.  
            END.
        END.
    END. /* IF  FIRST-OF(dwf-sdo-ctbl.dat-inic-valid) */

    DO i-nivel-conta = 1 TO 4:
        FIND FIRST b-dwf-sdo-ctbl 
            WHERE  b-dwf-sdo-ctbl.cod-modul-dtsul =  dwf-sdo-ctbl.cod-modul-dtsul
              AND  b-dwf-sdo-ctbl.cod-empresa     =  dwf-sdo-ctbl.cod-empresa    
              AND  b-dwf-sdo-ctbl.cdn-empresa     =  dwf-sdo-ctbl.cdn-empresa    
              AND  b-dwf-sdo-ctbl.cod-cta-ctbl    =  c-nivel-conta[i-nivel-conta]
              AND  b-dwf-sdo-ctbl.cod-ccusto      =  dwf-sdo-ctbl.cod-ccusto     
              AND  b-dwf-sdo-ctbl.cod-unid-negoc  =  dwf-sdo-ctbl.cod-unid-negoc 
              AND  b-dwf-sdo-ctbl.num-period-ctbl =  dwf-sdo-ctbl.num-period-ctbl
              AND  b-dwf-sdo-ctbl.num-exerc-ctbl  =  dwf-sdo-ctbl.num-exerc-ctbl 
              AND  b-dwf-sdo-ctbl.cod-estab       =  dwf-sdo-ctbl.cod-estab      
              AND  b-dwf-sdo-ctbl.dat-inic-valid  =  dwf-sdo-ctbl.dat-inic-valid NO-ERROR.

        IF  SUBSTR(dwf-sdo-ctbl.cod-cta-ctbl,1,i-nivel-conta) = SUBSTR(c-nivel-conta[i-nivel-conta],1,i-nivel-conta)
        THEN
            ASSIGN b-dwf-sdo-ctbl.val-sdo-ctbl-cr = b-dwf-sdo-ctbl.val-sdo-ctbl-cr + dwf-sdo-ctbl.val-sdo-ctbl-cr
                   b-dwf-sdo-ctbl.val-sdo-ctbl-db = b-dwf-sdo-ctbl.val-sdo-ctbl-db + dwf-sdo-ctbl.val-sdo-ctbl-db.
    END.
END. /* FOR EACH  dwf-sdo-ctbl NO-LOCK */


IF  VALID-HANDLE(h-acomp) 
THEN
    RUN pi-finalizar IN h-acomp.

IF  VALID-HANDLE(h-acomp) 
THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "ok".

/**********************************************************************/

PROCEDURE  pi-gera-historico:
    CREATE dwf-histor-sped-ctbl.
    ASSIGN dwf-histor-sped-ctbl.cod-empresa       = i-ep-codigo-usuario
           dwf-histor-sped-ctbl.dat-inic-period   = da-ini-mes
           dwf-histor-sped-ctbl.dat-fim-period    = da-fim-mes
           dwf-histor-sped-ctbl.cod-produt-dtsul  = "EMS 5"
           dwf-histor-sped-ctbl.ind-diario        = "Auxiliar"
           dwf-histor-sped-ctbl.num-niv           = 999
           dwf-histor-sped-ctbl.cod-cenar-ctbl    = "FISCAL"
           dwf-histor-sped-ctbl.cod-modul-dtsul   = "GKO"
           dwf-histor-sped-ctbl.val-tot-lancto-db = de-val-tot-lancto-db
           dwf-histor-sped-ctbl.val-tot-lancto-cr = de-val-tot-lancto-cr
           dwf-histor-sped-ctbl.cod-usuario       = v_cod_usuar_corren
           dwf-histor-sped-ctbl.dat-gerac-extrac  = TODAY
           dwf-histor-sped-ctbl.hra-gerac-extrac  = STRING(TIME,"hh:mm:ss").
END PROCEDURE.


PROCEDURE pi-conta-sintetica:

    DEF INPUT PARAM p-cod-conta AS CHAR.
    DEF INPUT PARAM p-tam-conta AS INT.

    FOR FIRST cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = "Padrao"
          AND cta_ctbl.cod_cta_ctbl       BEGINS SUBSTR(p-cod-conta,1,p-tam-conta)
          AND cta_ctbl.ind_espec_cta_ctbl = "Sint‚tica":

        ASSIGN p-cod-conta                = cta_ctbl.cod_cta_ctbl
               c-nivel-conta[p-tam-conta] = cta_ctbl.cod_cta_ctbl
               p-tam-conta                = p-tam-conta - 1.
        IF  p-tam-conta > 0
        THEN DO:
            RUN pi-conta-sintetica (INPUT p-cod-conta,
                                    INPUT p-tam-conta).
        END.
    END.

END PROCEDURE.
