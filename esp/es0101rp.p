/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES0101RP 2.06.00.000}
/*------------------------------------------------------------------------
    File        : XX9999RP.P
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */

{esp/es0018.i}
{utp/utapi019.i}

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l½gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD tipo-data        AS INTEGER
    FIELD l-emails         AS LOG
    FIELD emails           AS CHAR
    FIELD estoque          AS INT 
    FIELD ordem            AS INT
    FIELD notas            AS INT.
{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE tt-registro NO-UNDO
    FIELD tipo         AS CHAR
    FIELD cod-estabel  LIKE movto-estoq.cod-estabel
    FIELD serie        LIKE movto-estoq.serie-docto
    FIELD nr-nota-fis  LIKE movto-estoq.nro-docto  
    FIELD dt-emis-nota LIKE movto-estoq.dt-trans   
    FIELD it-codigo    LIKE movto-estoq.it-codigo  
    FIELD nr-ord-produ LIKE ord-rep.nr-ord-produ
    FIELD data         LIKE rep-prod.data       
    FIELD hora         LIKE rep-prod.hora
    FIELD cStatus      AS CHAR.

DEF BUFFER b-movto-estoq FOR movto-estoq.
DEF BUFFER bintegr-totvs-colab FOR integr-totvs-colab.

DEF VAR i-dias-movto AS  INT NO-UNDO.
DEF VAR i-dias-ord   AS  INT NO-UNDO.
DEF VAR i-dias-nota  AS  INT NO-UNDO.
DEF VAR c-emails     AS CHAR NO-UNDO.
DEF VAR l-cancelada-sefaz AS LOG NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */
FORM tt-registro.cod-estabel  AT 1 COLUMN-LABEL "Estab"
     tt-registro.serie        AT 7 COLUMN-LABEL "Serie"
     tt-registro.nr-nota-fis  AT 13 COLUMN-LABEL "Nota Fiscal"
     tt-registro.dt-emis-nota AT 25 COLUMN-LABEL "Data"
     tt-registro.it-codigo    AT 36 COLUMN-LABEL "Item"
     tt-registro.cStatus      AT 47 COLUMN-LABEL "Situacao"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-report-movto.

FORM tt-registro.nr-ord-produ AT 1 COLUMN-LABEL "Ordem"
     tt-registro.data         AT 13 COLUMN-LABEL "Data"
     tt-registro.hora         AT 24 COLUMN-LABEL "Hor"
     tt-registro.cStatus      AT 34 COLUMN-LABEL "Situacao"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-report-ordem.

FORM tt-registro.cod-estabel  AT 1 COLUMN-LABEL "Estab"
     tt-registro.serie        AT 7 COLUMN-LABEL "Serie"
     tt-registro.nr-nota-fis  AT 13 COLUMN-LABEL "Nota Fiscal"
     tt-registro.dt-emis-nota AT 25 COLUMN-LABEL "Data"
     tt-registro.cStatus      AT 36 COLUMN-LABEL "Situacao"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 200 FRAME f-report-nota.
   
/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ************************  Function Prototypes ********************** */

FUNCTION fn-function RETURNS CHARACTER
  (  )  FORWARD.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

assign c-programa     = "ES0101"
       c-sistema      = "Monitor Estoque"
       c-titulo-relat = "Monitor Estoque"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

FIND FIRST tt-param NO-LOCK NO-ERROR.
ASSIGN c-emails     = tt-param.emails 
       i-dias-movto = tt-param.estoque
       i-dias-ord   = tt-param.ordem  
       i-dias-nota  = tt-param.notas.


ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i &STREAM="str-rp"}
    {include/i-rpout.i &STREAM="STREAM str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-lista-estoq.
    RUN pi-lista-aca-sem-req.
    RUN pi-lista-notas.
    RUN pi-lista-dep-bloq.
    RUN pi-lista-mvto-estoq-dup.
    RUN pi-lista-notas-entrada.

    IF tt-param.l-emails THEN
        RUN pi-envia-mail.

    RUN pi-imprime.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Relat¢rio...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Acompanhando...":U).

    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Movto":
    
    	DISPLAY STREAM str-rp
        	tt-registro.cod-estabel     
    		tt-registro.serie      
    		tt-registro.nr-nota-fis FORMAT "x(10)"
    		tt-registro.dt-emis-nota       
    		tt-registro.it-codigo   FORMAT "x(10)"       
    		tt-registro.cStatus     FORMAT "x(60)"
    		WITH FRAME f-report-movto.               
            DOWN STREAM str-rp WITH FRAME f-report-movto.
    
    END.

    PUT STREAM str-rp SKIP(1).

    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Ordem":

        DISPLAY STREAM str-rp
        	tt-registro.nr-ord-produ
    		tt-registro.data        
    		tt-registro.hora        
    		tt-registro.cStatus     FORMAT "x(60)"  
    		WITH FRAME f-report-ordem.               
            DOWN STREAM str-rp WITH FRAME f-report-ordem.

    END.

    PUT STREAM str-rp SKIP(1).

    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Nota":

        DISPLAY STREAM str-rp
        	tt-registro.cod-estabel
    		tt-registro.serie
    		tt-registro.nr-nota-fis FORMAT "x(10)"
    		tt-registro.dt-emis-nota
            tt-registro.cStatus     FORMAT "x(60)"
    		WITH FRAME f-report-nota.               
            DOWN STREAM str-rp WITH FRAME f-report-nota.

    END.

    PUT STREAM str-rp SKIP(1).

    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Nota2":

        DISPLAY STREAM str-rp
        	tt-registro.cod-estabel
    		tt-registro.serie
    		tt-registro.nr-nota-fis FORMAT "x(10)"
    		tt-registro.dt-emis-nota
            tt-registro.cStatus     FORMAT "x(60)"
    		WITH FRAME f-report-nota.               
            DOWN STREAM str-rp WITH FRAME f-report-nota.

    END.

    PUT STREAM str-rp SKIP(1).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota-entrada":

        DISPLAY STREAM str-rp
            tt-registro.cod-estabel
            tt-registro.serie
            tt-registro.nr-nota-fis FORMAT "x(10)"
            tt-registro.dt-emis-nota
            tt-registro.cStatus     FORMAT "x(60)"
            WITH FRAME f-report-nota.               
            DOWN STREAM str-rp WITH FRAME f-report-nota.
            
    END.

    PUT STREAM str-rp SKIP(1).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota-entrada-imposto":

        DISPLAY STREAM str-rp
            tt-registro.cod-estabel
            tt-registro.serie
            tt-registro.nr-nota-fis FORMAT "x(10)"
            tt-registro.dt-emis-nota
            tt-registro.cStatus     FORMAT "x(100)"
            WITH FRAME f-report-nota.               
            DOWN STREAM str-rp WITH FRAME f-report-nota.
            
    END.

 /*   FOR EACH tt-registro
       WHERE tt-registro.tipo = "Nota3":

        DISPLAY STREAM str-rp
        	tt-registro.cod-estabel
    		tt-registro.serie
    		tt-registro.nr-nota-fis FORMAT "x(10)"
    		tt-registro.dt-emis-nota
            tt-registro.cStatus     FORMAT "x(60)"
    		WITH FRAME f-report-nota.               
            DOWN STREAM str-rp WITH FRAME f-report-nota.
    END. */


    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-registro:

    DEF INPUT PARAM p-tipo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-cstatus AS CHAR NO-UNDO.

    CREATE tt-registro.
    ASSIGN tt-registro.tipo    = p-tipo
           tt-registro.cStatus = p-cstatus.

    IF tt-registro.tipo = "Movto" THEN DO:
        ASSIGN tt-registro.cod-estabel  = movto-estoq.cod-estabel 
               tt-registro.serie        = movto-estoq.serie-docto       
               tt-registro.nr-nota-fis  = movto-estoq.nro-docto 
               tt-registro.dt-emis-nota = movto-estoq.dt-trans
               tt-registro.it-codigo    = movto-estoq.it-codigo.
    END.

    IF tt-registro.tipo = "Ordem" THEN DO:
        ASSIGN tt-registro.nr-ord-produ = ord-rep.nr-ord-produ
               tt-registro.data         = rep-prod.data       
               tt-registro.hora         = rep-prod.hora.      
    END.

    IF tt-registro.tipo = "Nota" OR tt-registro.tipo = "Nota2" /*OR tt-registro.tipo = "Nota3"*/ THEN DO:
        ASSIGN tt-registro.cod-estabel  = nota-fiscal.cod-estabel 
               tt-registro.serie        = nota-fiscal.serie    
               tt-registro.nr-nota-fis  = nota-fiscal.nr-nota-fis
               tt-registro.dt-emis-nota = nota-fiscal.dt-emis-nota.
    END.

    IF tt-registro.tipo = "Nota-entrada" OR tt-registro.tipo = "Nota-entrada-imposto" THEN DO:
        ASSIGN tt-registro.cod-estabel  = docum-est.cod-estabel
               tt-registro.serie        = docum-est.serie-docto
               tt-registro.nr-nota-fis  = docum-est.nro-docto
               tt-registro.dt-emis-nota = docum-est.dt-emissao.
    END.
    
END PROCEDURE.

PROCEDURE pi-lista-estoq:

    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis-nota >= TODAY - i-dias-movto:
    
        IF NOT CAN-FIND (FIRST natur-oper
                         WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                           AND natur-oper.tipo = 2) THEN NEXT.
    
        run pi-acompanhar in h-acomp (input nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
      
        FOR EACH movto-estoq NO-LOCK USE-INDEX documento
           WHERE movto-estoq.serie-docto  = nota-fiscal.serie
             AND movto-estoq.nro-docto    = nota-fiscal.nr-nota-fis
             AND movto-estoq.cod-emitente = nota-fiscal.cod-emitente
             AND movto-estoq.nat-operacao = nota-fiscal.nat-operacao
             AND movto-estoq.cod-estabel  = nota-fiscal.cod-estabel:
    
            /* Cancelada com movimento estoque */
            IF nota-fiscal.dt-cancel <> ?
            OR nota-fiscal.idi-sit-nf-eletro <> 3 THEN
                RUN pi-cria-registro (INPUT "Movto",
                                      INPUT "NF com situa‡Æo diferente de Uso Autorizado e com movimento estoque").

            /* Duplicidade movimento estoque */
            IF CAN-FIND (FIRST b-movto-estoq NO-LOCK USE-INDEX documento
                         WHERE b-movto-estoq.serie-docto  = movto-estoq.serie-docto 
                           AND b-movto-estoq.nro-docto    = movto-estoq.nro-docto   
                           AND b-movto-estoq.cod-emitente = movto-estoq.cod-emitente
                           AND b-movto-estoq.nat-operacao = movto-estoq.nat-operacao
                           AND b-movto-estoq.it-codigo    = movto-estoq.it-codigo   
                           AND b-movto-estoq.cod-estabel  = movto-estoq.cod-estabel 
                           AND b-movto-estoq.tipo-trans   = movto-estoq.tipo-trans
                           AND b-movto-estoq.cod-depos    = movto-estoq.cod-depos
                           AND b-movto-estoq.quantidade   = movto-estoq.quantidade
                           AND b-movto-estoq.sequen-nf    = movto-estoq.sequen-nf
						   AND b-movto-estoq.lote         = movto-estoq.lote
                           AND b-movto-estoq.nr-trans    <> movto-estoq.nr-trans) THEN
                RUN pi-cria-registro (INPUT "Movto",
                                      INPUT "Duplicidade movimento").
    
        END.
    END.

END PROCEDURE.

PROCEDURE pi-lista-aca-sem-req:

    DEF VAR l-existe-aca    AS LOG NO-UNDO.
    DEF VAR l-existe-eac    AS LOG NO-UNDO.
    DEF VAR l-existe-req    AS LOG NO-UNDO.
    DEF VAR l-existe-dev    AS LOG NO-UNDO.
    DEF VAR l-req-s-rep     AS LOG NO-UNDO.
    DEF VAR l-aca-no-req    AS LOG NO-UNDO.
    DEF VAR de-quant-aca    AS DEC NO-UNDO.
    DEF VAR de-quant-eac    AS DEC NO-UNDO.
    DEF VAR de-quant-req    AS DEC NO-UNDO.
    DEF VAR de-quant-dev    AS DEC NO-UNDO.

    FOR EACH rep-prod USE-INDEX item-dat 
       WHERE rep-prod.data >= TODAY - i-dias-ord NO-LOCK,
        EACH ord-rep  OF rep-prod NO-LOCK,
        EACH ord-prod OF ord-rep  NO-LOCK
        BREAK BY ord-prod.nr-ord-produ:

        run pi-acompanhar in h-acomp (input ord-rep.nr-ord-produ).

        IF FIRST-OF (ord-prod.nr-ord-produ) THEN DO:
            ASSIGN l-existe-aca = NO
                   l-existe-eac = NO
                   l-existe-req = NO
                   l-existe-dev = NO
                   l-req-s-rep  = NO
                   l-aca-no-req = NO
                   de-quant-aca = 0
                   de-quant-eac = 0
                   de-quant-req = 0
                   de-quant-dev = 0.

            FOR EACH movto-estoq 
               WHERE movto-estoq.nr-ord-prod = ord-rep.nr-ord-produ NO-LOCK
                     BREAK BY movto-estoq.nr-reporte:

                IF FIRST-OF(movto-estoq.nr-reporte) 
                THEN DO:
                    ASSIGN l-existe-aca = NO
                           l-existe-eac = NO
                           l-existe-req = NO
                           l-existe-dev = NO
                           de-quant-aca = 0
                           de-quant-eac = 0
                           de-quant-req = 0
                           de-quant-dev = 0.
                END.

                /*ACA*/
                IF movto-estoq.esp-docto   = 1 THEN DO:
                    ASSIGN l-existe-aca    = YES
                           de-quant-aca    = de-quant-aca    + movto-estoq.quantidade.       
                END.
              
                /*EAC*/
                IF movto-estoq.esp-docto   = 8 THEN DO:
                    ASSIGN l-existe-eac = YES
                           de-quant-eac = de-quant-eac + movto-estoq.quantidade.
                END.
              
                /*REQ*/
                IF movto-estoq.esp-docto   = 28 THEN DO:
                    ASSIGN l-existe-req    = YES
                           de-quant-req    = de-quant-req + movto-estoq.quantidade.

                    IF movto-estoq.nr-reporte  = 0 THEN ASSIGN l-req-s-rep = YES.
                END.
              
                /*DEV*/
                IF movto-estoq.esp-docto   = 5 THEN DO:
                    ASSIGN l-existe-dev = YES
                           de-quant-dev = de-quant-dev + movto-estoq.quantidade.
                END.  

                IF LAST-OF(movto-estoq.nr-reporte) 
                THEN DO:
                    IF l-existe-aca = YES AND 
                       l-existe-req = NO  AND
                       l-existe-eac = NO  AND
                       l-req-s-rep  = NO  AND
                       SUBSTRING(ord-prod.it-codigo,1,3) <> "164"
                    THEN DO:
                        ASSIGN l-aca-no-req = YES.
                    END.
                END.
            END.

            IF l-aca-no-req = YES 
            THEN DO:
                RUN pi-cria-registro (INPUT "Ordem",
                                      INPUT "Movimento de ACA sem REQ").
            END.            
/*            IF  l-existe-aca = YES 
            AND l-existe-req = NO  
            AND SUBSTRING(ord-prod.it-codigo,1,3) <> "164" THEN DO:
                RUN pi-cria-registro (INPUT "Ordem",
                                      INPUT "Movimento de ACA sem REQ").
            END.*/
        END.
    END.

END PROCEDURE.

PROCEDURE pi-lista-notas:

    /* 3 - Uso Autorizado
       6 - Cancelado */
    
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis-nota >= TODAY - i-dias-nota
         AND nota-fiscal.idi-sit-nf-eletro = 3:
    
        run pi-acompanhar in h-acomp (input nota-fiscal.nr-nota-fis).
    
        FOR EACH integr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE integr-totvs-colab.cod-edi   = "171"
             AND integr-totvs-colab.cod-docto  = nota-fiscal.cod-chave-aces-nf-eletro
             AND integr-totvs-colab.cod-origem = 1,
           FIRST bintegr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE bintegr-totvs-colab.cod-edi   = "171"
             AND bintegr-totvs-colab.cod-docto  = integr-totvs-colab.cod-docto
             AND bintegr-totvs-colab.cod-origem = 2:
        
            IF TRIM(ENTRY(1,bintegr-totvs-colab.cod-msg,"=")) = "135" OR TRIM(ENTRY(1,bintegr-totvs-colab.cod-msg,"=")) = "109" THEN
                RUN pi-cria-registro (INPUT "Nota",
                                      INPUT "NF Autorizada no TOTVS mas cancelada no SEFAZ").
        END.
    
        FOR EACH integr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE integr-totvs-colab.cod-edi   = "172"
             AND integr-totvs-colab.cod-docto  = nota-fiscal.cod-chave-aces-nf-eletro
             AND integr-totvs-colab.cod-origem = 1,
           FIRST bintegr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE bintegr-totvs-colab.cod-edi   = "172"
             AND bintegr-totvs-colab.cod-docto  = integr-totvs-colab.cod-docto
             AND bintegr-totvs-colab.cod-origem = 2:
    
            IF TRIM(ENTRY(1,bintegr-totvs-colab.cod-msg,"=")) = "102" THEN
                RUN pi-cria-registro (INPUT "Nota",
                                      INPUT "NF Autorizada no TOTVS mas inutilizada no SEFAZ").
    
        END.

        FIND FIRST natur-oper OF nota-fiscal NO-LOCK NO-ERROR.

        IF AVAIL natur-oper AND
                 natur-oper.transf = YES 
        THEN DO:
           FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK.

              FIND FIRST item-doc-est WHERE
                         item-doc-est.serie-comp   = nota-fiscal.serie        AND
                         item-doc-est.nro-comp     = nota-fiscal.nr-nota-fis  AND
                         item-doc-est.nat-comp     = nota-fiscal.nat-operacao AND
                         item-doc-est.seq-comp     = it-nota-fisc.nr-seq-fat  AND
                         item-doc-est.it-codigo    = it-nota-fisc.it-codigo 
                         NO-LOCK NO-ERROR.

              IF AVAIL item-doc-est
              THEN DO:
                 IF (it-nota-fisc.qt-faturada[1] <> item-doc-est.quantidade OR
                     it-nota-fisc.vl-merc-liq    <> item-doc-est.preco-total[1]) 
                 THEN DO: 
                    RUN pi-cria-registro (INPUT "Nota",
                                          INPUT "NF de Transf. com Quantidade ou Valores diferentes da Entrada").
                 END.
              END.
           END.
        END.

        IF nota-fiscal.dt-confirma = ? THEN DO:
            RUN pi-cria-registro (INPUT "Nota",
                                  INPUT "Nota fiscal nao atualizada no estoque").

        END.

    END.

    /*Nota cancelada no totvs e autorizada na sefaz*/
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis-nota >= TODAY - i-dias-nota
         AND nota-fiscal.idi-sit-nf-eletro = 6: /*Cancelada*/
    
        run pi-acompanhar in h-acomp (input nota-fiscal.nr-nota-fis).

        ASSIGN l-cancelada-sefaz = YES.
        IF NOT CAN-FIND (FIRST integr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
                         WHERE integr-totvs-colab.cod-edi   = "171"
                           AND integr-totvs-colab.cod-docto  = nota-fiscal.cod-chave-aces-nf-eletro
                           AND integr-totvs-colab.cod-origem = 1) THEN DO:      

            ASSIGN l-cancelada-sefaz = NO.
        END.
        IF NOT CAN-FIND (FIRST bintegr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
                         WHERE bintegr-totvs-colab.cod-edi   = "171"
                           AND bintegr-totvs-colab.cod-docto  = nota-fiscal.cod-chave-aces-nf-eletro
                           AND bintegr-totvs-colab.cod-origem = 2) THEN DO:

            ASSIGN l-cancelada-sefaz = NO.
        END.
    
        IF l-cancelada-sefaz = NO THEN DO:
            RUN pi-cria-registro (INPUT "Nota",
                                  INPUT "NF Cancelada no TOTVS mas Autorizada na SEFAZ").

        END.
    END.

    /* Duplicidade de nota fiscal Totvs X Neogrid */
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis-nota >= TODAY - i-dias-nota
         AND nota-fiscal.idi-sit-nf-eletro = 5:
    
        run pi-acompanhar in h-acomp (input nota-fiscal.nr-nota-fis).
    
        FOR EACH integr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE integr-totvs-colab.cod-edi   = "170"
             AND integr-totvs-colab.cod-docto  = nota-fiscal.cod-chave-aces-nf-eletro
             AND integr-totvs-colab.cod-origem = 1,
           FIRST bintegr-totvs-colab NO-LOCK USE-INDEX intgrttv_ix2
           WHERE bintegr-totvs-colab.cod-edi   = "170"
             AND bintegr-totvs-colab.cod-docto  = integr-totvs-colab.cod-docto
             AND bintegr-totvs-colab.cod-origem = 2:
            
            IF TRIM(ENTRY(1,bintegr-totvs-colab.cod-msg,"=")) = "204" OR TRIM(ENTRY(1,bintegr-totvs-colab.cod-msg,"=")) = "216" THEN
                RUN pi-cria-registro (INPUT "Nota2",
                                      INPUT "NF com erro de duplicidade TOTVS e SEFAZ").
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-lista-mvto-estoq-dup:

   FOR EACH movto-estoq WHERE
            movto-estoq.tipo-trans    = 1  AND
            movto-estoq.nat-operacao <> "" AND
            movto-estoq.dt-trans     >= TODAY - i-dias-nota 
            NO-LOCK.

      run pi-acompanhar in h-acomp (input "Movto duplicado " + movto-estoq.it-codigo).
   
      IF movto-estoq.esp-docto = 18 THEN NEXT. /* NC  */
      IF movto-estoq.esp-docto = 22 THEN NEXT. /* NFS */
      IF movto-estoq.esp-docto = 08 THEN NEXT. /* EAC */
      IF movto-estoq.esp-docto = 01 THEN NEXT. /* ACA */
   
      FIND FIRST ITEM WHERE
                 ITEM.it-codigo = movto-estoq.it-codigo 
                 NO-LOCK NO-ERROR.
   
      IF ITEM.baixa-estoq = NO THEN NEXT.
                 
      FIND FIRST b-movto-estoq WHERE
                 b-movto-estoq.it-codigo    = movto-estoq.it-codigo    AND
                 b-movto-estoq.dt-trans     = movto-estoq.dt-trans     AND
                 b-movto-estoq.serie-docto  = movto-estoq.serie-docto  AND
                 b-movto-estoq.nro-docto    = movto-estoq.nro-docto    AND
                 b-movto-estoq.nat-operacao = movto-estoq.nat-operacao AND
                 b-movto-estoq.nr-trans    <> movto-estoq.nr-trans
                 NO-LOCK NO-ERROR.
   
      IF AVAIL b-movto-estoq AND
               b-movto-estoq.quantidade   = movto-estoq.quantidade AND
               b-movto-estoq.tipo-trans   = movto-estoq.tipo-trans AND
               b-movto-estoq.esp-docto    = movto-estoq.esp-docto  AND
               b-movto-estoq.cod-depos    = movto-estoq.cod-depos              
      THEN DO:
          FIND FIRST item-doc-est WHERE
                     item-doc-est.serie-docto  = movto-estoq.serie-docto  AND
                     item-doc-est.nro-docto    = movto-estoq.nro-docto    AND
                     item-doc-est.cod-emitente = movto-estoq.cod-emitente AND
                     item-doc-est.nat-operacao = movto-estoq.nat-operacao AND                   
                     item-doc-est.sequencia    = movto-estoq.sequen-nf    AND
                     item-doc-est.it-codigo    = movto-estoq.it-codigo    
                     NO-LOCK NO-ERROR.

          IF NOT AVAIL item-doc-est 
          THEN RUN pi-cria-registro (INPUT "Movto",
                                     INPUT "NF de entrada com movimento duplicado no estoque").
      END. 
   END.
END.

PROCEDURE pi-lista-dep-bloq:

    FOR EACH bloq-movto-item-depos no-lock:

        run pi-acompanhar in h-acomp (input bloq-movto-item-depos.cod-estabel + "/" + bloq-movto-item-depos.cod-depos).

        IF bloq-movto-item-depos.it-codigo = "#TODOS#" THEN
            FOR EACH movto-estoq NO-LOCK USE-INDEX estab-dep
               WHERE movto-estoq.cod-estabel = bloq-movto-item-depos.cod-estabel
                 AND movto-estoq.cod-depos   = bloq-movto-item-depos.cod-depos
                 AND movto-estoq.dt-trans  >= TODAY - i-dias-movto:
                RUN pi-cria-registro (INPUT "Movto",
                                      INPUT "Movimento de estoque em deposito/item bloqueado").
            END.
        ELSE
            FOR EACH movto-estoq NO-LOCK USE-INDEX dep-estab
               WHERE movto-estoq.cod-depos   = bloq-movto-item-depos.cod-depos
                 AND movto-estoq.cod-estabel = bloq-movto-item-depos.cod-estabel
                 AND movto-estoq.it-codigo   = bloq-movto-item-depos.it-codigo
                 AND movto-estoq.dt-trans   >= TODAY - i-dias-movto:
                RUN pi-cria-registro (INPUT "Movto",
                                      INPUT "Movimento de estoque em deposito/item bloqueado").
            END.
    END.    

END PROCEDURE.

PROCEDURE pi-lista-notas-entrada:

    DEFINE VAR d-icms        AS DEC NO-UNDO.
    DEFINE VAR d-vl-tot-fisc AS DEC NO-UNDO.

    FOR EACH docum-est NO-LOCK
       WHERE docum-est.dt-emissao >= TODAY - i-dias-nota
         AND docum-est.serie-docto = "890"
         AND docum-est.cod-chave-aces-nf-eletro = "":

        RUN pi-acompanhar in h-acomp (INPUT "NFE " + docum-est.nro-docto).

        RUN pi-cria-registro (INPUT "Nota-entrada",
                              INPUT "Avulsa eletronica lancada sem chave de acesso").
    END.
    
END PROCEDURE.


PROCEDURE pi-envia-mail:

    IF NOT CAN-FIND(FIRST tt-registro) THEN NEXT.

    run pi-acompanhar in h-acomp (input "Gerando e-mail.").

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.
    
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    IF tt-registro.tipo = "Nota2" THEN

        RUN esp/es0018p.p (INPUT "es0101rp", /* Nome do programa  */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

      FOR EACH tt-prog-ponto:
          ASSIGN c-emails = tt-prog-ponto.conteudo.
      END.

      IF tt-registro.tipo = "Nota-entrada" THEN

            RUN esp/es0018p.p (INPUT "es0101rp", /* Nome do programa  */
                               INPUT 2,          /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            FOR EACH tt-prog-ponto:
                ASSIGN c-emails = tt-prog-ponto.conteudo.
            END.

   /*    IF tt-registro.tipo = "Nota3" THEN

        RUN esp/es0018p.p (INPUT "es0101rp", /* Nome do programa  */
                           INPUT 3,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

      FOR EACH tt-prog-ponto:
          ASSIGN c-emails = c-emails + tt-prog-ponto.conteudo.
      END.*/


    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                             /* Destinat˜rio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
           tt-envio2.assunto           = "Monitor Estoque/Notas - IMPORTANTE" /* Assunto            */
           tt-envio2.formato           = "TEXTO".
   
   
    IF CAN-FIND(FIRST tt-registro
                WHERE tt-registro.tipo = "Movto") THEN
        ASSIGN c-corpo-email = "Estab|Serie|Nota|Data|Item|Situacao" + CHR(10).
   
    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Movto":
        ASSIGN c-corpo-email = c-corpo-email +
                               tt-registro.cod-estabel + "   " +
                               tt-registro.serie       + "   " +
                               tt-registro.nr-nota-fis  + "   " +
                               STRING(tt-registro.dt-emis-nota) + "   " +
                               tt-registro.it-codigo    + "   " +
                               tt-registro.cStatus + CHR(10).
    END.
   
    IF CAN-FIND(FIRST tt-registro
                WHERE tt-registro.tipo = "Ordem") THEN
        ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Ord Prod|Data|Hora|Situacao" + CHR(10).
   
    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Ordem":
   
        ASSIGN c-corpo-email = c-corpo-email +
                               STRING(tt-registro.nr-ord-produ) + "   " +
                               STRING(tt-registro.data)         + "   " +
                               STRING(tt-registro.hora)         + "   " +
                               tt-registro.cStatus      + CHR(10).
    END.
   
    IF CAN-FIND(FIRST tt-registro
                WHERE tt-registro.tipo = "Nota") THEN
        ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Estab|Serie|Nota|Data|Situacao" + CHR(10).
   
    FOR EACH tt-registro
       WHERE tt-registro.tipo = "Nota":
   
        ASSIGN c-corpo-email = c-corpo-email +
                               tt-registro.cod-estabel + "   " +
                               tt-registro.serie       + "   " +
                               tt-registro.nr-nota-fis  + "   " +
                               STRING(tt-registro.dt-emis-nota) + "   " +
                               tt-registro.cStatus + CHR(10).
    END.

    IF CAN-FIND(FIRST tt-registro
               WHERE tt-registro.tipo = "Nota2") THEN
       ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Estab|Serie|Nota|Data|Situacao" + CHR(10).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota2": 
    
         ASSIGN c-corpo-email = c-corpo-email +
                              tt-registro.cod-estabel + "   " +
                              tt-registro.serie       + "   " +
                              tt-registro.nr-nota-fis  + "   " +
                              STRING(tt-registro.dt-emis-nota) + "   " +
                              tt-registro.cStatus + CHR(10).
    END.

    IF CAN-FIND(FIRST tt-registro
              WHERE tt-registro.tipo = "Nota-entrada") THEN
      ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Estab|Serie|Nota|Data|Situacao" + CHR(10).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota-entrada": 
    
        ASSIGN c-corpo-email = c-corpo-email +
                              tt-registro.cod-estabel + "   " +
                              tt-registro.serie       + "   " +
                              tt-registro.nr-nota-fis  + "   " +
                              STRING(tt-registro.dt-emis-nota) + "   " +
                              tt-registro.cStatus + CHR(10).
    END.

    IF CAN-FIND(FIRST tt-registro
              WHERE tt-registro.tipo = "Nota-entrada-imposto") THEN
      ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Estab|Serie|Nota|Data|Situacao" + CHR(10).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota-entrada-imposto": 
    
       ASSIGN c-corpo-email = c-corpo-email +
                              tt-registro.cod-estabel + "   " +
                              tt-registro.serie       + "   " +
                              tt-registro.nr-nota-fis  + "   " +
                              STRING(tt-registro.dt-emis-nota) + "   " +
                              tt-registro.cStatus + CHR(10).
    END.

   /* IF CAN-FIND(FIRST tt-registro
               WHERE tt-registro.tipo = "Nota3") THEN
       ASSIGN c-corpo-email = c-corpo-email + CHR(10) + "Estab|Serie|Nota|Data|Situacao" + CHR(10).

    FOR EACH tt-registro
        WHERE tt-registro.tipo = "Nota3": 
    
         ASSIGN c-corpo-email = c-corpo-email +
                              tt-registro.cod-estabel + "   " +
                              tt-registro.serie       + "   " +
                              tt-registro.nr-nota-fis  + "   " +
                              STRING(tt-registro.dt-emis-nota) + "   " +
                              tt-registro.cStatus + CHR(10).
    END. */
   
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    /*FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).*/
END PROCEDURE.

/* ************************  Function Implementations ***************** */

FUNCTION fn-function RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  <none>
    Notes:  <none>
------------------------------------------------------------------------------*/
    RETURN "":U.

END FUNCTION.

