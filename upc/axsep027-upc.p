/***************************************************************************
**  Programa..: axsep027-upc.p                                            **
**  Autor.....: Carlos Valentini                                          **
**  Data......: Janeiro/2017 - Desenvolvimento                            **
**  Descricao.: Customizar o processo de geraá∆o do XML no envio da NF-E  **
**              para enviar as TAG's adicionais e especificaá‰es          **
**              para Intelbras                                            **
**  Vers∆o....: 001 - 06/01/2016                                          **
***************************************************************************/

{include/i-prgvrs.i axsep027-upc 2.00.00.001 } /*** 010002  ***/ 

{include/i-epc200.i1}
{cdp/cdcfgdis.i}
{include/i-freeac.i}

.


DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE h-ide             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-emit            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-enderEmit       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-dup             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-campo-duplic    AS CHAR FORMAT "X(15)" NO-UNDO.
DEFINE VARIABLE h-dest            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-enderDest       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-prod            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-det             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-ICMS            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-ICMSTot         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-transporta      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-vol             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-infAdic         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-obsCont         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-compra          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-icms10          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-xProd           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hQueryBuffer      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-query           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-campo           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hQueryBuffer2     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-query2          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-campo2          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE DEC1              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE DEC2              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE DEC3              AS DECIMAL     NO-UNDO.
define variable vCodEstabelNF       AS CHARACTER   no-undo.
define variable vSerieNF            AS CHARACTER   no-undo.
define variable vNrNotaFisNF        AS CHARACTER   no-undo.
define variable vItCodigoNF         AS CHARACTER   no-undo.
define variable vNrSeqFatNF         AS INTEGER     no-undo.
DEFINE VARIABLE c-campo             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-xped              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cnae              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-vl-tot-item      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-endereco          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-narrativa-do-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-vl-tot-icms      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-total-icms        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-icms-outras-it    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-valor-frete      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-ii         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-campo-prod        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE de-pis    LIKE item-doc-est.valor-pis  NO-UNDO.
DEFINE VARIABLE de-cofins LIKE item-doc-est.val-cofins NO-UNDO.

DEFINE BUFFER b-natur FOR natur-oper.
DEFINE BUFFER b-emitente FOR emitente.
DEFINE VARIABLE c-emails AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont    AS INTEGER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER NO-UNDO.

DEF VAR h-cod-estabel  AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-serie        AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-nr-nota-fis  AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-seq          AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-item         AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-pICMSST      AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-vBCST        AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-vICMSST      AS WIDGET-HANDLE NO-UNDO.





define variable c-CodEstabelNF      as character no-undo.
define variable c-SerieNF           as character no-undo.
define variable c-NrNotaFisNF       as character no-undo.
DEFINE VARIABLE r-rowid-nota        AS ROWID     NO-UNDO.
DEFINE VARIABLE c-aux-obs           AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-tt-epc FOR tt-epc.

DEFINE BUFFER bf-nota-fiscal  FOR nota-fiscal .

DEF TEMP-TABLE tt-fat-duplic NO-UNDO LIKE fat-duplic.

/*************** L¢gica EPC ****************/
CASE p-ind-event:
    /*** Evento principal chamado pelo axsep027 ***/
    WHEN "AtualizaDadosNFe":U THEN DO:
        /*** Busca rowid da nota-fiscal para facilitar atualizaá∆o das outras tabelas ***/

                            /**** Atualizaá∆o da tabela Emitente Nota Fiscal ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttEmit":U:



             ASSIGN h-emit      = WIDGET-HANDLE(tt-epc.val-parameter)
                    hQueryBuffer = h-emit:DEFAULT-BUFFER-HANDLE.
             
             IF  VALID-HANDLE(hQueryBuffer) THEN DO:
             
                 CREATE QUERY h-query.
                              h-query:SET-BUFFERS(hQueryBuffer).
                              h-query:QUERY-PREPARE('for each ' + h-emit:NAME + ' NO-LOCK') .
                              h-query:QUERY-OPEN().
             
                 REPEAT ON ERROR UNDO, LEAVE:
                     h-query:GET-NEXT().
                     IF h-query:QUERY-OFF-END THEN LEAVE.
    
    
                     ASSIGN h-cod-estabel = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                     ASSIGN h-serie       = hQueryBuffer:BUFFER-FIELD('SerieNF')      NO-ERROR.
                     ASSIGN h-nr-nota-fis = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF')  NO-ERROR.
    
    
                     FIND FIRST nota-fiscal 
                          WHERE nota-fiscal.cod-estabel  = h-cod-estabel:BUFFER-VALUE
                            AND nota-fiscal.serie        = h-serie:BUFFER-VALUE
                            AND nota-fiscal.nr-nota-fis  = h-nr-nota-fis:BUFFER-VALUE  NO-LOCK NO-ERROR.
    
    
                     FOR FIRST estabelec no-lock
                        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel:
                     END.
                    
                     for first ponto-programa
                         where ponto-programa.nome-programa = "esft067"
                           AND ponto-programa.ponto         = 1,
                          EACH conteudo-programa NO-LOCK
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                           AND conteudo-programa.sequencia    = int(nota-fiscal.cod-estabel):
                         assign c-cnae = ENTRY(1,conteudo-programa.conteudo).
                     end.  

                     
                      ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xNome') NO-ERROR.
                      ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                      RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                      ASSIGN h-campo:BUFFER-VALUE = c-campo.
                     
                      ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xFant') NO-ERROR.
                      ASSIGN h-campo:BUFFER-VALUE = "INTELBRAS S/A".
                     
                     
                      ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('IM') NO-ERROR.
                      
                      IF c-cnae <> "" THEN
                         ASSIGN h-campo:BUFFER-VALUE = IF h-campo:BUFFER-VALUE = "" THEN estabelec.ins-municipal ELSE h-campo:BUFFER-VALUE
                                h-campo = hQueryBuffer:BUFFER-FIELD('cnae') NO-ERROR.
                                h-campo:BUFFER-VALUE     = c-cnae.
                     
                     
                      assign c-CodEstabelNF  = h-cod-estabel:BUFFER-VALUE
                             c-SerieNF       = h-serie:BUFFER-VALUE      
                             c-NrNotaFisNF   = h-nr-nota-fis:BUFFER-VALUE.
                     
    
                 END.
             END.
             ASSIGN h-emit       = ?
                    hQueryBuffer = ?
                    h-query      = ?
                    h-campo      = ?.
        END.
                /**** Fim emit ****/
    
                /**** Atualizaá∆o da tabela IDE ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttIDE":U:

        
            ASSIGN h-ide      = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-ide:DEFAULT-BUFFER-HANDLE.

            FIND FIRST nota-fiscal 
                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                   AND nota-fiscal.serie        = c-SerieNF     
                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.

            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-ide:NAME + ' NO-LOCK WHERE ' + h-ide:NAME + "." + STRING(hQueryBuffer:BUFFER-FIELD('nNF'):NAME) + ' = "' + STRING(INT(nota-fiscal.nr-nota-fis)) + '"').
                             h-query:QUERY-OPEN().

                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.
      
                   FIND FIRST natur-oper
                        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('natOp') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = fn-free-accent(natur-oper.denominacao).
                END.
            END.

            ASSIGN h-ide        = ?
                   hQueryBuffer = ?
                   h-query      = ?
                   h-campo      = ?.

        END.
             /**** Fim IDE ****/

        
        /**** Atualizaá∆o da tabela Endereáo Emitente Nota Fiscal ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttEmit":U:

            FIND FIRST nota-fiscal
                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                   AND nota-fiscal.serie        = c-SerieNF     
                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.


            ASSIGN h-enderEmit  = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-enderEmit:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-enderEmit:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xLgr') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xBairro') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('UF') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xPais') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.
                    
                END.
            END.
            ASSIGN h-enderEmit  = ?
                   hQueryBuffer = ?
                   h-query      = ?
                   h-campo      = ?.
        END.
        /**** Fim enderEmit ****/

        /**** Atualizaá∆o da tabela Dest Nota Fiscal ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttDest":U:

            ASSIGN h-dest       = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-dest:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-dest:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xNome') NO-ERROR.
                    ASSIGN c-campo = string(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                END.
            END.
            ASSIGN h-dest       = ?
                   hQueryBuffer = ?
                   h-query      = ?
                   h-campo      = ?.
        END.
        /**** Fim dest ****/
        
        /**** Atualizaá∆o da tabela Ender Dest Nota Fiscal ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttDest":U:

            FIND FIRST  nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                       AND nota-fiscal.serie        = c-SerieNF     
                       AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.


            ASSIGN h-enderDest  = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-enderDest:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-enderDest:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    FOR FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
                        ASSIGN de-vl-tot-item = 0.
                        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                            FIND FIRST b-natur
                                 WHERE b-natur.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.
                            if  b-natur.tipo = 3 and
                                it-nota-fisc.vl-iss-it > 0 then do:
                                 assign de-vl-tot-item = de-vl-tot-item + it-nota-fisc.vl-merc-liq.
                            END.
                            IF it-nota-fisc.nat-operacao BEGINS "3" THEN DO:
                                FIND ITEM
                                    WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                                IF AVAIL ITEM  THEN DO:
                                    FOR FIRST int-it-nota-fisc exclusive-lock
                                        where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                                          and int-it-nota-fisc.serie       = it-nota-fisc.serie
                                          and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                          and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                          AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo:
                                    end.
                                    IF NOT AVAIL int-it-nota-fisc THEN DO:
                                        CREATE int-it-nota-fisc.
                                        ASSIGN int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                                               int-it-nota-fisc.serie       = it-nota-fisc.serie
                                               int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                               int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                               int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo.
                                    END.
                                    ASSIGN int-it-nota-fisc.codigo-orig = ITEM.codigo-orig.
                                END.
                    
                            END.
                        END.
                    END.
                    FIND FIRST int-loc-entr
                        WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                          AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
                    FIND FIRST loc-entr
                         WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                           AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.                         
                    
                    IF AVAIL emitente and
                       avail loc-entr and                                              
                        (emitente.cgc          <> nota-fiscal.cgc          OR
                         emitente.ins-estadual <> nota-fiscal.ins-estadual OR
                         loc-entr.endereco     <> nota-fiscal.endereco     OR
                         loc-entr.bairro       <> nota-fiscal.bairro       OR
                         loc-entr.cidade       <> nota-fiscal.cidade       OR
                         loc-entr.estado       <> nota-fiscal.estado       OR
                         loc-entr.pais         <> nota-fiscal.pais         OR
                         loc-entr.cep          <> nota-fiscal.cep          OR
                         (AVAIL INT-loc-entr AND
                          int-loc-entr.endereco-completo <> ""))  THEN DO:
                        
                        IF AVAIL INT-loc-entr AND
                          int-loc-entr.endereco-completo <> "" THEN
                            ASSIGN c-endereco = int-loc-entr.endereco-completo.
                        ELSE
                            ASSIGN c-endereco = loc-entr.endereco.
                    
                        ASSIGN c-rua      = ""
                               c-nro      = ""
                               c-comp     = "".
                        IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
                            ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").
                    
                        RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                        RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                                             OUTPUT c-rua, 
                                                             OUTPUT c-nro, 
                                                             OUTPUT c-comp).
                    
                        ASSIGN c-nro = fn-free-accent(c-nro).
                    
                        DELETE PROCEDURE h-cdapi704.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xLgr') NO-ERROR.
                        ASSIGN c-campo = fn-free-accent(c-rua).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('nro') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE  = fill('0',2 - length(c-nro)) + c-nro.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCpl') NO-ERROR.
                        ASSIGN c-campo = trim(fn-free-accent( c-comp ) ).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xBairro') NO-ERROR.
                        ASSIGN c-campo = trim(fn-free-accent(loc-entr.bairro)).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                        ASSIGN c-campo = IF hQueryBuffer:BUFFER-FIELD('UF'):BUFFER-VALUE = "EX" THEN "Exterior" ELSE TRIM(loc-entr.cidade).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('UF') NO-ERROR.
                        ASSIGN c-campo = loc-entr.estado.
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CEP') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE  = string(int(REPLACE(loc-entr.cep,'-','')),'99999999').


                        FIND FIRST  bf-nota-fiscal 
                                 WHERE bf-nota-fiscal.cod-estabel  = c-CodEstabelNF
                                   AND bf-nota-fiscal.serie        = c-SerieNF     
                                   AND bf-nota-fiscal.nr-nota-fis  = c-NrNotaFisNF EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL bf-nota-fiscal THEN DO:
                            assign bf-nota-fiscal.endereco = loc-entr.endereco  
                                   bf-nota-fiscal.bairro   = loc-entr.bairro   
                                   bf-nota-fiscal.cidade   = loc-entr.cidade      
                                   bf-nota-fiscal.estado   = loc-entr.estado      
                                   bf-nota-fiscal.pais     = loc-entr.pais         
                                   bf-nota-fiscal.cep      = loc-entr.cep.          
                        END.

                        FIND FIRST  nota-fiscal 
                                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                                   AND nota-fiscal.serie        = c-SerieNF     
                                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF no-LOCK NO-ERROR.
                               
                       /* Colocar banco mgcad.cidade */
                         FIND FIRST mgcad.cidade NO-LOCK
                            WHERE mgcad.cidade.cidade = loc-entr.cidade
                              AND mgcad.cidade.estado = loc-entr.estado
                              AND mgcad.cidade.pais   = loc-entr.pais NO-ERROR.
                        IF AVAIL mgcad.cidade THEN DO:
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = string(fn-free-accent(mgcad.cidade.cidade)).
                        END.
                    
                    END.
                    ELSE DO:
                        FIND FIRST mgcad.cidade no-lock
                            WHERE mgcad.cidade.cidade = hQueryBuffer:BUFFER-FIELD('xMun'):BUFFER-VALUE
                              AND mgcad.cidade.estado = hQueryBuffer:BUFFER-FIELD('UF'):BUFFER-VALUE
                              AND mgcad.cidade.pais   = hQueryBuffer:BUFFER-FIELD('xPais'):BUFFER-VALUE NO-ERROR.
                        IF AVAIL mgcad.cidade THEN DO:
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = string(fn-free-accent(mgcad.cidade.cidade)).
                        END.
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCpl') NO-ERROR.
                        IF LENGTH(h-campo:BUFFER-VALUE) = 1 THEN DO:
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('nro') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = h-campo:BUFFER-VALUE + " " + trim(fn-free-accent(hQueryBuffer:BUFFER-FIELD('xCpl'):BUFFER-VALUE)).
                        END.
                        ELSE DO:
                            ASSIGN h-campo:BUFFER-VALUE = IF h-campo:BUFFER-VALUE <> "" THEN trim(fn-free-accent(h-campo:BUFFER-VALUE)) ELSE "".
                        END.
                    
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCpl') NO-ERROR.
                        ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xLgr') NO-ERROR.
                        ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xBairro') NO-ERROR.
                        ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                        ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('UF') NO-ERROR.
                        ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                        RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                        ASSIGN h-campo:BUFFER-VALUE = c-campo.
                    
                    END.
                END.
            END.
            ASSIGN h-enderDest  = ?
                   hQueryBuffer = ?
                   h-query      = ?
                   h-campo      = ?.

        END.
        /**** Fim enderDest ****/

        /**** Atualizaá∆o da tabela prod ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttDet":U:

            FIND FIRST nota-fiscal 
                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                   AND nota-fiscal.serie        = c-SerieNF     
                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.

            FOR FIRST estabelec no-lock
                WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel:
            END.

            FIND FIRST natur-oper
                 WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.



            ASSIGN h-prod       = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-prod:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-prod:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo      = hQueryBuffer:BUFFER-FIELD('xProd') 
                           c-campo-prod = h-campo:BUFFER-VALUE NO-ERROR.

                    FIND ITEM WHERE ITEM.it-codigo = hQueryBuffer:BUFFER-FIELD('cProd'):BUFFER-VALUE NO-LOCK NO-ERROR.
                    IF AVAIL item  THEN DO:
                        RUN pi-narrativa-item (INPUT nota-fiscal.cod-estabel,
                                               INPUT ITEM.it-codigo,
                                               INPUT INT(hQueryBuffer:BUFFER-FIELD('NrSeqFatNF'):BUFFER-VALUE),
                                               OUTPUT c-narrativa-do-item).
                        ASSIGN c-campo-prod = c-narrativa-do-item.
                    END.

                   ASSIGN h-campo2 = hQueryBuffer:BUFFER-FIELD('infAdProd') NO-ERROR.

                   IF AVAIL item AND ITEM.ind-imp-desc = 7 THEN DO:
                        assign c-campo-prod = c-campo-prod  + string(h-campo2:BUFFER-VALUE).    
                   END.


                   if c-campo-prod = '' THEN DO:
                       ASSIGN h-campo2 = hQueryBuffer:BUFFER-FIELD('NrSeqFatNF') NO-ERROR.
                       FOR EACH nar-it-nota FIELDS(narrativa) NO-LOCK
                          WHERE nar-it-nota.cod-estabel  = nota-fiscal.cod-estabel
                            AND nar-it-nota.serie        = nota-fiscal.serie      
                            AND nar-it-nota.nr-nota-fis  = nota-fiscal.nr-nota-fis
                            AND nar-it-nota.nr-sequencia = INT(h-campo2:BUFFER-VALUE).
                           ASSIGN c-campo-prod = c-campo-prod + nar-it-nota.narrativa.
                       END.
                   END.
                    
                   IF estabelec.cod-estabel = "102" THEN DO:
                       FIND FIRST item-mat
                             WHERE item-mat.it-codigo = hQueryBuffer:BUFFER-FIELD('cProd'):BUFFER-VALUE NO-LOCK NO-ERROR.
                        IF AVAIL Item-mat AND item-mat.cod-ean <> "" THEN
                           ASSIGN c-campo-prod = c-campo-prod + " EAN: " + string(item-mat.cod-ean).
                   END.

                   /*** ajuste final do campo xprod ***/
                   IF c-campo-prod = '' THEN
                      ASSIGN c-campo-prod = hQueryBuffer:BUFFER-FIELD('cProd'):BUFFER-VALUE.

                   ASSIGN c-xProd               = c-campo-prod.
                   RUN RetiraAcentos           (INPUT-OUTPUT c-xProd).
                   ASSIGN c-xProd               = fn-free-accent(LEFT-trim(c-xProd)).
                   ASSIGN c-campo-prod          = c-xProd.
                   ASSIGN h-campo:BUFFER-VALUE  = c-campo-prod.

                   IF  hQueryBuffer:BUFFER-FIELD('indTot'):BUFFER-VALUE = ". ." THEN DO:
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('indTot') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "1".
                   END.

                    
                   ASSIGN c-xped = "".
                    /* Pedido de Origem do Cliente - Informaá∆o solicitada no PD4000, campo "PO Cliente" */
                   FIND FIRST ped-venda NO-LOCK
                        WHERE  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                        AND    ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                   IF  AVAIL  ped-venda THEN DO:
                        FIND FIRST int-ped-venda NO-LOCK
                            WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                            AND    int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
                        IF  AVAIL  int-ped-venda THEN
                            ASSIGN c-xped = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                            RUN RetiraAcentos (INPUT-OUTPUT c-xped).
                            
                   END.

                   ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xPed') NO-ERROR.
                   ASSIGN c-xped  = fn-free-accent(c-xped)
                           h-campo:BUFFER-VALUE = c-xped.


                    /* Fim - Pedido de Origem do Cliente */

                   IF AVAIL nota-fiscal 
                        AND natur-oper.nat-operacao BEGINS "3" 
                        AND substring(natur-oper.nat-operacao,1,4) <> "3201" 
                        AND substring(natur-oper.nat-operacao,1,4) <> "3202" THEN DO:
                        FIND FIRST docum-est NO-LOCK
                             WHERE docum-est.serie        = nota-fiscal.serie
                               AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                               AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                               AND docum-est.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

                        IF AVAIL docum-est THEN DO:

                            FOR FIRST it-nota-fisc no-lock
                               where it-nota-fisc.cod-estabel = estabelec.cod-estabel
                                 and it-nota-fisc.serie       = nota-fiscal.serie
                                 and it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis 
                                 and it-nota-fisc.nr-seq-fat  = INT(hQueryBuffer:BUFFER-FIELD('NrSeqFatNF'):BUFFER-VALUE)
                                 AND it-nota-fisc.it-codigo   = ITEM.it-codigo:
                            END.

                            
                             FOR EACH item-doc-est NO-LOCK
                                WHERE item-doc-est.serie-docto   = it-nota-fisc.serie
                                  AND item-doc-est.nro-docto     = it-nota-fisc.nr-nota-fis
                                  AND item-doc-est.cod-emitente  = nota-fiscal.cod-emitente
                                  AND item-doc-est.nat-operacao  = it-nota-fisc.nat-operacao
                                  AND item-doc-est.sequencia     = it-nota-fisc.nr-seq-ped        
                                  AND item-doc-est.it-codigo     = it-nota-fisc.it-codigo:

                                 ASSIGN de-valor-frete = 0
                                        de-valor-ii    = 0.
                    
                                  FOR EACH item-doc-est-cex NO-LOCK
                                       WHERE item-doc-est-cex.serie-docto  = nota-fiscal.serie
                                         AND item-doc-est-cex.nro-docto    = nota-fiscal.nr-nota-fis
                                         AND item-doc-est-cex.cod-emitente = nota-fiscal.cod-emitente
                                         AND item-doc-est-cex.nat-operacao = nota-fiscal.nat-operacao
                                         AND item-doc-est-cex.sequencia    = item-doc-est.sequencia:

                                      
                                         IF item-doc-est-cex.cod-desp    = 3  OR /* Frete */
                                            item-doc-est-cex.cod-desp    = 93 OR /* Frete Prepaid */
                                            item-doc-est-cex.cod-desp    = 22 THEN  /* Seguro - Despesas que ja s∆o destacadas na nota portanto n∆o devera constar no valor outras - conforme Claudia 17/06/2015  */
                                             ASSIGN de-valor-frete = de-valor-frete + item-doc-est-cex.val-desp.

                                         IF item-doc-est-cex.cod-desp = 1 THEN
                                             ASSIGN de-valor-ii = de-valor-ii + item-doc-est-cex.val-desp.
                                  END.

                                  ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('vOutro') NO-ERROR.
                                  ASSIGN h-campo:BUFFER-VALUE = DEC(trim(replace(STRING((item-doc-est.despesas[1] - de-valor-frete) /*+ de-valor-ii*/,">>>>>>>>>>>>9.99"),",","."))) / 100.
                            END.
                        END.
                   END. 

                    /**** Busca ICMS para atualizar a Origem da Nota ****/
                   FOR FIRST bf-tt-epc
                        WHERE bf-tt-epc.cod-event = p-ind-event 
                          AND bf-tt-epc.cod-parameter = "ttICMS00":U:

                        FIND FIRST int-it-nota-fisc no-lock
                             where int-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel         
                               and int-it-nota-fisc.serie       = nota-fiscal.serie               
                               and int-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis         
                               and int-it-nota-fisc.nr-seq-fat  = INT(h-campo2:BUFFER-VALUE)  NO-ERROR.
                    
                        ASSIGN h-ICMS        = WIDGET-HANDLE(bf-tt-epc.val-parameter)
                               hQueryBuffer2 = h-ICMS:DEFAULT-BUFFER-HANDLE.
                        
                        IF  VALID-HANDLE(hQueryBuffer2) THEN DO:
                        
                            CREATE QUERY h-query2.
                                         h-query2:SET-BUFFERS(hQueryBuffer2).
                                         h-query2:QUERY-PREPARE('for each ' + h-ICMS:NAME + ' NO-LOCK' ).
                                         h-query2:QUERY-OPEN().
                        
                            REPEAT ON ERROR UNDO, LEAVE:
                                h-query2:GET-NEXT().
                                IF h-query2:QUERY-OFF-END THEN LEAVE.

                                ASSIGN h-campo2 = hQueryBuffer2:BUFFER-FIELD('orig') NO-ERROR.
                                ASSIGN h-campo2:BUFFER-VALUE = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE h-campo2:BUFFER-VALUE.

                            END.
                        END.
                    END.
                    /**** Fim ICMS ****/
                END.
            END.
            ASSIGN h-prod        = ?
                   h-det         = ?
                   h-ICMS        = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?
                   hQueryBuffer2 = ?
                   h-query2      = ?
                   h-campo2      = ?.
        END.
        /**** Fim prod ****/
        
        /**** Atualizaá∆o da tabela ICMS Total Nota Fiscal ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttICMSTot":U:

            FIND FIRST  nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                       AND nota-fiscal.serie        = c-SerieNF     
                       AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.


            ASSIGN h-ICMSTot    = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-ICMSTot:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-ICMSTot:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    FIND FIRST docum-est NO-LOCK
                         WHERE docum-est.serie        = nota-fiscal.serie
                           AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                           AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                           AND docum-est.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.                    
                    
                    IF AVAILABLE docum-est THEN DO:
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('vOutro') NO-ERROR. /*
                        ASSIGN h-campo:BUFFER-VALUE = REPLACE(TRIM(STRING(TRUNCATE(docum-est.valor-outras, 2),'>>>>>>>>>9.99')),',','.'). */
                        ASSIGN h-campo:BUFFER-VALUE = dec(trim(replace(STRING(docum-est.valor-outras,">>>>>>>>>>>>9.99"),",","."))) / 100.
                    END.
                END.
            END.
            ASSIGN h-ICMSTot     = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim ICMSTot ****/
        
        /**** Atualizaá∆o da tabela transporta ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttTransp":U:
            FIND FIRST  nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                       AND nota-fiscal.serie        = c-SerieNF     
                       AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.


            ASSIGN h-transporta = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-transporta:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-transporta:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xNome') NO-ERROR.
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xEnder') NO-ERROR.
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xMun') NO-ERROR.
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('UF') NO-ERROR.
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CNPJ') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = if h-campo:BUFFER-VALUE = '' then '99999999999999' else h-campo:BUFFER-VALUE.
                    FIND FIRST transporte
                         WHERE transporte.cgc = h-campo:BUFFER-VALUE NO-LOCK NO-ERROR.
                    IF AVAIL transporte THEN DO:
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('IE') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = replace(replace(transporte.ins-estadual,".",""),"/","").
                    END.
                END.
            END.
            ASSIGN h-transporta  = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim Transporte ****/
        
        /**** Atualizaá∆o da tabela vol ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttVol":U:

            FIND FIRST nota-fiscal 
                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                   AND nota-fiscal.serie        = c-SerieNF     
                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.

            ASSIGN h-vol = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-vol:DEFAULT-BUFFER-HANDLE.

            IF  VALID-HANDLE(hQueryBuffer) THEN DO:

                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-vol:NAME + ' NO-LOCK').
                             h-query:QUERY-OPEN().
            
                ASSIGN i-cont = 1.
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    IF i-cont = 1 THEN DO:
                    
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('qVol') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = IF nota-fiscal.nr-volumes = ? OR nota-fiscal.nr-volumes = '' THEN "00" ELSE nota-fiscal.nr-volumes.
        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('esp') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "VOLUME".
        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('marca') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "INTELBRAS".
        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('nVol') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "".
        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pesoL') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = dec(replace(trim(string(TRUNCATE(nota-fiscal.peso-liq-tot,3),'>>>>>>>>>>>9.999')),',','.')) / 1000.
        
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pesoB') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = dec(replace(trim(string(TRUNCATE(nota-fiscal.peso-bru-tot,3),'>>>>>>>>>>>9.999')),',','.')) / 1000.
                    END.
                    ELSE DO:
                        hQueryBuffer:BUFFER-DELETE().
                    END.
                    ASSIGN i-cont =  i-cont + 1.
                END.

            END.
            ASSIGN h-vol         = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim vol ****/

        /**** Atualizaá∆o da tabela infAdic ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttinfAdic":U:

            FIND FIRST  nota-fiscal 
                 WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                   AND nota-fiscal.serie        = c-SerieNF     
                   AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.



            ASSIGN h-infAdic = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-infAdic:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-infAdic:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:

                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('infAdFisco') NO-ERROR.
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.
                    
                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('infCpl') NO-ERROR.
                    
                    /*** Chamado 3490 ***/
                    IF nota-fiscal.nat-operacao begins "3" then do:
                        assign de-pis    = 0
                               de-cofins = 0.
                        FOR EACH item-doc-est NO-LOCK
                           WHERE item-doc-est.serie-docto  = nota-fiscal.serie
                             AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis
                             AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                             AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao:
                            ASSIGN de-pis    = de-pis + item-doc-est.valor-pis
                                   de-cofins = de-cofins + item-doc-est.val-cofins.

                        END.
                        IF de-pis > 0 OR de-cofins > 9 THEN DO:
                            ASSIGN c-aux-obs = "*" + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")) + "*".
                                   h-campo:BUFFER-VALUE = h-campo:BUFFER-VALUE + 
                                                          IF  NOT (h-campo:BUFFER-VALUE MATCHES c-aux-obs) THEN  
                                                              (" PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")))
                                                          ELSE
                                                              "".
                                   

                            IF AVAIL nota-fiscal AND NOT (nota-fiscal.observ-nota MATCHES c-aux-obs) THEN DO:
                                FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
                                IF  AVAIL nota-fiscal THEN
                                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")).
                                FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.
                            END.
                                   
                        END.
                    END.
                    /*** fim chamado 3490 ***/

                    
                    ASSIGN c-campo = STRING(h-campo:BUFFER-VALUE).
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.
                    
                END.
            END.
            ASSIGN h-infAdic     = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim infAdic ****/

        /**** Atualizaá∆o da tabela obsCont ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttobsCont":U:

            FIND FIRST nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                       AND nota-fiscal.serie        = c-SerieNF     
                       AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.



            ASSIGN h-obsCont = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-obsCont:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-obsCont:NAME + ' NO-LOCK WHERE ' + h-obsCont:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('xCampo'):NAME) + ' = "mailDest" OR '
                                                                                                    + h-obsCont:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('xCampo'):NAME) + ' = "mailTransp"').
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    hQueryBuffer:BUFFER-DELETE.

                END.

                FIND FIRST emitente NO-LOCK
                     WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
                IF AVAILABLE emitente THEN DO:
                
                    IF emitente.e-mail <> '' THEN
                    DO:
                        
                        RUN piEnviarEmail (OUTPUT c-emails).
                
                        DO i-cont = 1 TO NUM-ENTRIES(c-emails,';'):
                            hQueryBuffer:BUFFER-CREATE.

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = "mailDest".

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = fn-free-accent(ENTRY(i-cont,c-emails,';')).

                        END.
                    END.
                END.
                FIND FIRST fat-comercial
                     WHERE fat-comercial.cod-estabel  = nota-fiscal.cod-estabel  
                       AND fat-comercial.serie        = nota-fiscal.serie       
                       AND fat-comercial.nr-nota-fis  = nota-fiscal.nr-nota-fis 
                    NO-LOCK NO-ERROR.
                IF AVAIL fat-comercial THEN DO:
                    IF fat-comercial.nr-nota-fis <> '' THEN DO:
                        FIND FIRST ponto-programa
                             WHERE ponto-programa.nome-programa = "esft067"
                               AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
                        IF AVAIL ponto-programa THEN DO:
                            IF CAN-FIND(FIRST conteudo-programa NO-LOCK
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                              AND conteudo-programa.conteudo     = nota-fiscal.cod-estabel) THEN DO:
                                
                                hQueryBuffer:BUFFER-CREATE.
                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = "MODO_IMPRESSAO".

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = 'manual'.
                            END.
                            ELSE DO:
                                 hQueryBuffer:BUFFER-CREATE.

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = "MODO_IMPRESSAO".

                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE =  'auto'.

                            END.
                        END. /* IF AVAIL pronto-programa THEN DO: */
                        ELSE DO:
                            hQueryBuffer:BUFFER-CREATE.
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = "MODO_IMPRESSAO".

                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE =  'auto'.
                        END.
                    END. /* IF fat-comercial.nr-nota-fis = '' THEN DO: */
                    ELSE DO:
                        hQueryBuffer:BUFFER-CREATE.
                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "MODO_IMPRESSAO".

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE =  'auto'.
                    END. /* IF fat-comercial.nr-nota-fis <> '' THEN DO: */
                END. /* IF AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    hQueryBuffer:BUFFER-CREATE.
                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = "MODO_IMPRESSAO".

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE =  'auto'.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */

                /* Busca a impressora do usu†rio, ou a impressora padr∆o */
                FIND FIRST usuario-impressora NO-LOCK
                    WHERE  usuario-impressora.cod-estabel = nota-fiscal.cod-estabel
                    AND    usuario-impressora.serie       = nota-fiscal.serie
                    AND    usuario-impressora.cod-usuario = nota-fiscal.user-calc NO-ERROR.
                IF  AVAIL  usuario-impressora THEN DO:
                    hQueryBuffer:BUFFER-CREATE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE = "IMPRESSORA".

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                    ASSIGN h-campo:BUFFER-VALUE =  fn-free-accent(usuario-impressora.impressora).
                
                END. /* IF  AVAIL  usuario-impressora THEN DO: */
                ELSE DO:

                    FIND FIRST impressora-padrao NO-LOCK
                        WHERE  impressora-padrao.cod-estabel = nota-fiscal.cod-estabel
                        AND    impressora-padrao.serie       = nota-fiscal.serie NO-ERROR.
                    IF  AVAIL  impressora-padrao THEN DO:
                        hQueryBuffer:BUFFER-CREATE.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = c-CodEstabelNF.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('SerieNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = c-SerieNF .

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE =  c-NrNotaFisNF.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xCampo') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "IMPRESSORA".

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xTexto') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE =  fn-free-accent(impressora-padrao.impressora).
                
                    END. /* IF  AVAIL  usuario-impressora THEN DO: */
                
                END. /* IF  AVAIL  usuario-impressora THEN DO: */
            END.
            ASSIGN h-obsCont     = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim obsCont ****/

        /**** Atualizaá∆o da tabela compra ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttcompra":U:

            ASSIGN h-compra = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-compra:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                FIND FIRST nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = c-CodEstabelNF
                       AND nota-fiscal.serie        = c-SerieNF     
                       AND nota-fiscal.nr-nota-fis  = c-NrNotaFisNF NO-LOCK NO-ERROR.

            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-compra:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xPed') NO-ERROR.

                     ASSIGN c-xped = h-campo:BUFFER-VALUE.
                    /* Pedido de Origem do Cliente - Informaá∆o solicitada no PD4000, campo "PO Cliente" */
                   FIND FIRST ped-venda NO-LOCK
                        WHERE  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                        AND    ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                   IF  AVAIL  ped-venda THEN DO:
                        FIND FIRST int-ped-venda NO-LOCK
                            WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                            AND    int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
                        IF  AVAIL  int-ped-venda THEN
                            ASSIGN c-xped = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                        RUN RetiraAcentos (INPUT-OUTPUT c-xped).
                   END.

                           
                    ASSIGN c-xped  = fn-free-accent(c-xped)
                           c-campo = c-xped.
                    RUN RetiraAcentos( INPUT-OUTPUT c-campo).
                    ASSIGN h-campo:BUFFER-VALUE = c-campo.
                    
                END.
            END.
            ASSIGN h-compra      = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.
        /**** Fim compra ****/

        
        /**** Atualizaá∆o da tabela icms510 ****/
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttICMS10":U:

            ASSIGN  h-icms10 = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer =  h-icms10:DEFAULT-BUFFER-HANDLE.
            
            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
            
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' +  h-icms10:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                      ASSIGN h-cod-estabel = hQueryBuffer:BUFFER-FIELD('CodEstabelNF') NO-ERROR.   
                      ASSIGN h-serie       = hQueryBuffer:BUFFER-FIELD('SerieNF')      NO-ERROR.   
                      ASSIGN h-nr-nota-fis = hQueryBuffer:BUFFER-FIELD('NrNotaFisNF')  NO-ERROR.   
                      assign h-seq         = hQueryBuffer:BUFFER-FIELD('NrSeqFatNF')   NO-ERROR.
                      assign h-item        = hQueryBuffer:BUFFER-FIELD('ItCodigoNF')   NO-ERROR.
                      assign h-pICMSST     = hQueryBuffer:BUFFER-FIELD('pICMSSTF')     NO-ERROR.                                                                  
                      assign h-vBCST       = hQueryBuffer:BUFFER-FIELD('vBCST')        NO-ERROR.
                      assign h-vICMSST     = hQueryBuffer:BUFFER-FIELD('vICMSST')      NO-ERROR.



                    vCodEstabelNF  =  h-cod-estabel:BUFFER-VALUE  .
                    vSerieNF       =  h-serie:BUFFER-VALUE  .      
                    vNrNotaFisNF   =  h-nr-nota-fis:BUFFER-VALUE. 
                    vItCodigoNF    =  h-item:BUFFER-VALUE   .    
                    vNrSeqFatNF    =  h-seq:BUFFER-VALUE.
                    DEC1           = 0.
                    DEC2           = 0.
                    DEC3           = 0.
                    DEC1           = DEC(h-pICMSST:BUFFER-VALUE) NO-ERROR.
                    DEC2           = DEC(h-vBCST:BUFFER-VALUE  ) NO-ERROR.
                    DEC3           = DEC(h-vICMSST:BUFFER-VALUE) NO-ERROR.


                    FOR FIRST estabelec no-lock
                        WHERE estabelec.cod-estabel = vCodEstabelNF:
                    END.

                   IF DEC1 > 0 OR DEC2 > 0 OR DEC3 > 0 THEN DO:

                       FOR FIRST it-nota-fisc FIELDS(it-codigo) 
                            WHERE it-nota-fisc.cod-estabel = vCodEstabelNF 
                             and  it-nota-fisc.serie       = vSerieNF      
                             and  it-nota-fisc.nr-nota-fis = vNrNotaFisNF  
                             and  it-nota-fisc.nr-seq-fat  = vNrSeqFatNF
                             and  it-nota-fisc.it-codigo   = vItCodigoNF NO-LOCK:


                          FIND FIRST item-uf NO-LOCK
                              WHERE item-uf.it-codigo          = it-nota-fisc.it-codigo
                                AND item-uf.COD-ESTADO-ORIG    = estabelec.estado
                                AND item-uf.estado             = nota-fiscal.estado NO-ERROR.
                          IF AVAIL item-uf THEN DO:

                              ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pMVAST') NO-ERROR.
                              ASSIGN c-campo = STRING(item-uf.PER-SUB-TRI).
                              ASSIGN h-campo:BUFFER-VALUE = c-campo.


                              ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pREDBCST') NO-ERROR.
                              ASSIGN c-campo = STRING(item-uf.PERC-RED-SUB).
                              ASSIGN h-campo:BUFFER-VALUE = c-campo.
                          END.
                          else DO:

                              ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pMVAST') NO-ERROR.
                              ASSIGN c-campo = '0'.
                              ASSIGN h-campo:BUFFER-VALUE = c-campo.

                              ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pREDBCST') NO-ERROR.
                              ASSIGN c-campo = '0'.
                              ASSIGN h-campo:BUFFER-VALUE = c-campo.
                          END.
                      END.
                      IF not AVAIL it-nota-fisc THEN DO:
                          ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pMVAST') NO-ERROR.
                          ASSIGN c-campo = '0'.
                          ASSIGN h-campo:BUFFER-VALUE = c-campo.
                          ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pREDBCST') NO-ERROR.
                          ASSIGN c-campo = '0'.
                          ASSIGN h-campo:BUFFER-VALUE = c-campo.

                      END.
                   END.
                   ELSE DO:

                          ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pMVAST') NO-ERROR.
                          ASSIGN c-campo = '0'.
                          ASSIGN h-campo:BUFFER-VALUE = c-campo.
                          ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pREDBCST') NO-ERROR.
                          ASSIGN c-campo = '0'.
                          ASSIGN h-campo:BUFFER-VALUE = c-campo.
                   END.
                END.
            END.
            ASSIGN h-icms10      = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?.
        END.

/**** Atualizaá∆o da tabela Duplicadas ****/

        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ttDup":U:

            ASSIGN h-dup       = WIDGET-HANDLE(tt-epc.val-parameter)
                   hQueryBuffer = h-dup:DEFAULT-BUFFER-HANDLE.

            IF  VALID-HANDLE(hQueryBuffer) THEN DO:
             
                CREATE QUERY h-query.
                             h-query:SET-BUFFERS(hQueryBuffer).
                             h-query:QUERY-PREPARE('for each ' + h-dup:NAME + ' NO-LOCK' ).
                             h-query:QUERY-OPEN().
            
                REPEAT ON ERROR UNDO, LEAVE:
                    h-query:GET-NEXT().
                    IF h-query:QUERY-OFF-END THEN LEAVE.

                    ASSIGN h-campo      = hQueryBuffer:BUFFER-FIELD('nDup') 
                           c-campo-duplic = h-campo:BUFFER-VALUE NO-ERROR.

                    RUN pi-recalcula-parcelas.

                    FOR FIRST tt-fat-duplic NO-LOCK 
                        WHERE tt-fat-duplic.cod-estabel = c-CodEstabelNF
                          AND tt-fat-duplic.serie       = c-SerieNF
                          AND tt-fat-duplic.nr-fatura   = c-NrNotaFisNF
                          AND tt-fat-duplic.parcela     = ENTRY(2, c-campo-duplic, "/"):

                          ASSIGN h-campo2 = hQueryBuffer:BUFFER-FIELD('vDup') NO-ERROR.

                          ASSIGN h-campo2:BUFFER-VALUE = dec(trim(replace(STRING(tt-fat-duplic.vl-parcela,">>>>>>>>>>>>9.99"),",","."))) / 100.

                    END.
                END.
            END.

            ASSIGN h-dup         = ?
                   hQueryBuffer  = ?
                   h-query       = ?
                   h-campo       = ?
                   h-campo2      = ?.
        END.



    END.
    /*** Fim AtualizaDadosNFe ***/



END CASE.

RETURN "OK-intelbras":U.

/*INTELBRAS*/
PROCEDURE pi-narrativa-item:
    DEF INPUT PARAMETER  c-cod-estabel LIKE estabelec.cod-estabel.
    DEF INPUT PARAMETER  c-item        LIKE ITEM.it-codigo.
    DEF INPUT PARAMETER  i-sequencia   AS INTEGER NO-UNDO.
    DEF OUTPUT PARAMETER c-desc-prod  AS CHARACTER.

    DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.

    /*---------------------------------------------------------------------------------+
     | Valores poss≠veis para o campos item.ind-imp-desc - Forma de Descriªío do Item: |
     |  1 - Descriªío                                                                  |
     |  2 - Descriªío + Narrativa do Item                                              |
     |  3 - Descriªío + Narrativa do Item X Cliente                                    |
     |  4 - Descriªío + Narrativa Informada                                            |
     |  5 - Narrativa do Item                                                          |
     |  6 - Uma Linha da Narrativa do Item                                             |
     |  7 - Narrativa Informada                                                        |
     |  8 - Descriªío + 24 Caracteres da Narrativa do Item X Cliente                   |
     |  9 - Descriªío + 24 Caracteres da Narrativa Informada                           | 
     | 10 - Descriªío + 24 Caracteres da Narrativa do Item                             |
     +---------------------------------------------------------------------------------*/


    /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
              
    if item.ind-imp-desc = 1 then /* Descriªío */
        assign c-desc-prod = item.desc-item.
    
    if  item.ind-imp-desc = 2           /* Descriªío + Narrativa */
    or  item.ind-imp-desc = 5           /* Narrativa Item */
    or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
    or  item.ind-imp-desc = 10 then do: /* Descriªío + 24 Narrativa Item */
    
        if  item.ind-imp-desc = 2
        or  item.ind-imp-desc = 10 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find narrativa of item no-lock no-error.
    
        if avail narrativa then DO:
            IF INDEX(narrativa.descricao,"#MANAUS#") <> 0 THEN DO:
                RUN esp/es0204.p (INPUT c-cod-estabel,
                                  INPUT c-item,
                                  OUTPUT c-narrativa).
            END.
            ELSE
                ASSIGN c-narrativa = narrativa.descricao.

            assign c-desc-prod = c-desc-prod +
                                 if  item.ind-imp-desc = 6 then
                                     trim(entry(1,substring(c-narrativa,1,76),chr(10)))
                                 else if item.ind-imp-desc = 10 then
                                     trim(entry(1,substring(c-narrativa,1,24),chr(10)))
                                 else                        
                                     c-narrativa.

        END.
    end.
    
    if  item.ind-imp-desc = 3          /* Descriªío + Narrativa Item/Cliente */
    or  item.ind-imp-desc = 8 then do: /* Descriªío + 24 Narrativa Item/Cliente */

        find item-cli
             where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
             and   item-cli.it-codigo  = ITEM.it-codigo
             no-lock no-error.
        
        assign c-desc-prod = item.desc-item + " ".
    
        if  avail item-cli then     DO:
        
            assign c-desc-prod = c-desc-prod +
                                 if item.ind-imp-desc = 3 then          
                                    item-cli.narrativa
                                 else
                                    trim(entry(1,substring(item-cli.narrativa,1,24),chr(10))).

        END.
    end.
    
    if  item.ind-imp-desc = 4            /* Descriªío + Narrativa Informada */
    or  item.ind-imp-desc = 7            /* Narrativa Informada */
    or  item.ind-imp-desc = 9 then do:   /* Descriªío + 24 Narrativa Informada */
    
        if  item.ind-imp-desc = 4
        or  item.ind-imp-desc = 9 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find nar-it-nota
             where nar-it-nota.cod-estabel  = nota-fiscal.cod-estabel                                   
             and   nar-it-nota.serie        = nota-fiscal.serie                                                 
             and   nar-it-nota.nr-nota-fis  = nota-fiscal.nr-nota-fis
             and   nar-it-nota.nr-sequencia = i-sequencia
             and   nar-it-nota.it-codigo    = ITEM.it-codigo
             no-lock no-error.
    
        if avail nar-it-nota then 
           assign c-desc-prod = c-desc-prod +
                                if item.ind-imp-desc = 9 then
                                   trim(entry(1,substring(nar-it-nota.narrativa,1,24),chr(10)))
                                else
                                   nar-it-nota.narrativa.
    end.

END PROCEDURE.

PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER   NO-UNDO.
    

    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN next.
           when "b" THEN next.
           when "c" THEN ASSIGN OVERLAY(c-texto,i-cont,1) = "C".
           when "d" THEN next.
           when "e" THEN next.
           when "f" THEN next.
           when "g" THEN next.
           when "h" THEN next.
           when "i" THEN next.
           when "j" THEN next.
           when "k" THEN next.
           when "l" THEN next.
           when "m" THEN next.
           when "n" THEN next.
           when "o" THEN next.
           when "p" THEN next.
           when "q" THEN next.
           when "r" THEN next.
           when "s" THEN next.
           when "t" THEN next.
           when "u" THEN next.
           when "v" THEN next.
           when "w" THEN next.
           when "x" THEN next.
           when "y" THEN next.
           when "z" THEN next.
           when " " THEN next.
           when "0" THEN next.
           when "1" THEN next.
           when "2" THEN next.
           when "3" THEN next.
           when "4" THEN next.
           when "5" THEN next.
           when "6" THEN next.
           when "7" THEN next.
           when "8" THEN next.
           when '9' THEN next.
           when '"' THEN next.
           when "'" THEN next.
           when "!" THEN next.
           when "[" THEN next.
           when "]" THEN next.
           when "@" THEN next.
           when "#" THEN next.
           when "$" THEN next.
           when "%" THEN next.
           when "&" THEN next.
           when "*" THEN next.
           when "(" THEN next.
           when ")" THEN next.
           when "-" THEN next.
           when "_" THEN next.
           when "=" THEN next.
           when "+" THEN next.
           when "<" THEN next.
           when ">" THEN next.
           when "," THEN next.
           when "." THEN next.
           when ":" THEN next.
           when ";" THEN next.
           when "?" THEN next.
           when "/" THEN next.
           when "~\" THEN next.
           OTHERWISE ASSIGN OVERLAY(c-texto,i-cont,1) = "".
       END.
    END.



END PROCEDURE.

PROCEDURE piEnviarEmail:
    
   DEFINE OUTPUT PARAMETER c-email-destino AS CHARACTER   NO-UNDO.
   FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao 
        NO-LOCK NO-ERROR.
   IF AVAIL natur-oper AND
       natur-oper.tipo = 2 THEN DO:
        IF CAN-find(FIRST cont-emit no-lock
            where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
              and (cont-emit.nome        BEGINS 'NFE'
               or cont-emit.nome         BEGINS 'NF-e')) THEN DO:
           ASSIGN c-email-destino = "".
           FOR each cont-emit no-lock
                where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                  and (cont-emit.nome        BEGINS 'NFE'
                   or cont-emit.nome         BEGINS 'NF-e'):
               IF c-email-destino = "" THEN
                  ASSIGN c-email-destino = trim(cont-emit.e-mail).
               ELSE
                    IF NOT c-email-destino MATCHES trim(cont-emit.e-mail) THEN
                        ASSIGN c-email-destino = trim(c-email-destino) + ";" + trim(cont-emit.e-mail).
           END.
        END.
        ELSE DO:
            find first b-emitente no-lock
                 where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
            ASSIGN c-email-destino = b-emitente.e-mail.
            
        END.
   END.


END PROCEDURE.


PROCEDURE pi-recalcula-parcelas:

    DEFINE VARIABLE dt-venc-prim-parc     AS DATE        NO-UNDO.
    DEFINE VARIABLE i-num-parc-fat        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-parcelas-aux       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-comis-aux          AS DECIMAL     NO-UNDO.
    
    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = c-CodEstabelNF  
          AND nota-fiscal.serie       = c-SerieNF       
          AND nota-fiscal.nr-nota-fis = c-NrNotaFisNF NO-ERROR. 

    EMPTY TEMP-TABLE tt-fat-duplic.

    IF  AVAIL nota-fiscal THEN DO:
        /* ------------------------------------------------------------------------------------*/
        /*  Prop¢sito:  Rec†lcular as parcelas da nota fiscal para fazer o rateio corretamente */
        /*              Logica adaptada da bodi317ef-upc, para que se possa deixar o XML igual */
        /*              as fat-duplic que s∆o atualizadas num ponto posterior ao envio do XML  */
        /* ------------------------------------------------------------------------------------*/

        /* Copiar as fat-duplic atuais para uma tabela tempor†ria */
        FOR EACH fat-duplic
            WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabe
              AND fat-duplic.serie       = nota-fiscal.serie     
              AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK:
            CREATE tt-fat-duplic.
            BUFFER-COPY fat-duplic TO tt-fat-duplic.
        END.

        FIND FIRST int-cond-pagto
            WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.
        FIND FIRST cond-pagto
            WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
               AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

        IF  (AVAILABLE int-cond-pagto                       
        AND AVAILABLE cond-pagto   
        AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U) 
        OR (AVAIL int-ped-venda
        AND int-ped-venda.log-gpon) THEN DO:
            FIND FIRST tt-fat-duplic NO-LOCK
                WHERE  tt-fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND  tt-fat-duplic.serie       = nota-fiscal.serie
                  AND  tt-fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-ERROR.
            
            IF  AVAILABLE tt-fat-duplic THEN
                ASSIGN dt-venc-prim-parc = tt-fat-duplic.dt-venciment
                       i-num-parc-fat    = 0.

            FOR EACH  tt-fat-duplic EXCLUSIVE-LOCK
                WHERE tt-fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND tt-fat-duplic.serie       = nota-fiscal.serie
                  AND tt-fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

                IF  AVAIL int-cond-pagto
                AND SUBSTRING(int-cond-pagto.char-1,8,1) <> "S" /*Flex*/  THEN 
                    ASSIGN tt-fat-duplic.dt-venciment = ADD-INTERVAL(dt-venc-prim-parc, i-num-parc-fat, "MONTH":U).

                ASSIGN i-num-parc-fat = i-num-parc-fat + 1.
                
            END. /* FOR EACH fat-duplic EXCLUSIVE-LOCK */

            ASSIGN de-parcelas-aux = 0
                   de-comis-aux    = 0.

            FOR EACH  tt-fat-duplic EXCLUSIVE-LOCK
                WHERE tt-fat-duplic.cod-estabel    = nota-fiscal.cod-estabel
                  AND tt-fat-duplic.serie          = nota-fiscal.serie
                  AND tt-fat-duplic.nr-fatura      = nota-fiscal.nr-fatura:
                ASSIGN tt-fat-duplic.vl-parcela    = ROUND(nota-fiscal.vl-tot-nota / i-num-parc-fat, 2)
                       tt-fat-duplic.vl-comis      = ROUND(nota-fiscal.vl-mercad   / i-num-parc-fat, 2)
                       tt-fat-duplic.vl-parcela-me = tt-fat-duplic.vl-parcela
                       tt-fat-duplic.vl-comis-me   = tt-fat-duplic.vl-comis
                       de-parcelas-aux             = de-parcelas-aux + tt-fat-duplic.vl-parcela
                       de-comis-aux                = de-comis-aux    + tt-fat-duplic.vl-comis.
            END. /* FOR EACH fat-duplic EXCLUSIVE-LOCK */

            FOR LAST  tt-fat-duplic EXCLUSIVE-LOCK
                WHERE tt-fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND tt-fat-duplic.serie       = nota-fiscal.serie
                  AND tt-fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                ASSIGN de-parcelas-aux          = de-parcelas-aux - tt-fat-duplic.vl-parcela
                       de-comis-aux             = de-comis-aux    - tt-fat-duplic.vl-comis
                       tt-fat-duplic.vl-parcela    = ROUND((nota-fiscal.vl-tot-nota - de-parcelas-aux), 2)
                       tt-fat-duplic.vl-comis      = ROUND((nota-fiscal.vl-mercad   - de-comis-aux   ), 2)
                       tt-fat-duplic.vl-parcela-me = tt-fat-duplic.vl-parcela
                       tt-fat-duplic.vl-comis-me   = tt-fat-duplic.vl-comis.
            END. /* FOR LAST fat-duplic EXCLUSIVE-LOCK */
        END.
    END. /* IF  AVAIL nota-fiscal THEN DO: */

END PROCEDURE.
