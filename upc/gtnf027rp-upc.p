/***************************************************************************
**  Programa..: gtnf027rp-upc.p                                           **
**  Autor.....: Lennon Climaco Ferreira                                   **
**  Data......: Agosto/2015 - Desenvolvimento                             **
**  Descricao.: Customizar o processo de geraá∆o do XML no envio da NF-E  **
**              para enviar as TAG's adicionais e especificaá‰es          **
**              para Intelbras                                            **
**  Vers∆o....: 001 - 22/07/2015                                          **
***************************************************************************/

{include/i-prgvrs.i gtnf027rp-upc 2.00.00.002 } /*** 010002 ***/ 

{include/i-epc200.i1}
{cdp/cdcfgdis.i}
{gtp/gati0005.i}
{include/i-freeac.i}

{gtp/gati0000.i}

DEFINE VARIABLE l-log-ativa AS LOGICAL     NO-UNDO.
ASSIGN l-log-ativa = NO.
IF l-log-ativa = YES THEN
    MESSAGE "gtnf027rp-upc.p inicio"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE h-ide             AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-emit            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-enderEmit       AS WIDGET-HANDLE NO-UNDO.
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
DEFINE VARIABLE c-xProd           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hQueryBuffer      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-query           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-campo           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hQueryBuffer2     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-query2          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-campo2          AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE de-pis    LIKE item-doc-est.valor-pis  NO-UNDO.
DEFINE VARIABLE de-cofins LIKE item-doc-est.val-cofins NO-UNDO.

DEFINE BUFFER b-natur FOR natur-oper.
DEFINE BUFFER b-emitente FOR emitente.
DEFINE VARIABLE c-emails AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont    AS INTEGER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER NO-UNDO.

DEFINE VARIABLE r-rowid-nota AS ROWID NO-UNDO.

DEFINE BUFFER bf-tt-epc FOR tt-epc.


/*************** L¢gica EPC ****************/
CASE p-ind-event:
    /*** Evento principal chamado pelo gtnf027rp ***/
    WHEN "AtualizaDadosNFe":U THEN DO:
        /*** Busca rowid da nota-fiscal para facilitar atualizaá∆o das outras tabelas ***/
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event = p-ind-event
               AND tt-epc.cod-parameter = "rowid-nota-fiscal":U NO-LOCK NO-ERROR.
        IF AVAIL tt-epc THEN DO:

            ASSIGN r-rowid-nota =  TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            FIND FIRST nota-fiscal EXCLUSIVE-LOCK
                 WHERE ROWID(nota-fiscal) = r-rowid-nota NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:

                /**** Atualizaá∆o da tabela IDE ****/
                FOR FIRST tt-epc
                    WHERE tt-epc.cod-event = p-ind-event 
                      AND tt-epc.cod-parameter = "ide":U:

                    FIND FIRST natur-oper OF nota-fiscal NO-LOCK.
                
                    ASSIGN h-ide      = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-ide:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-ide:NAME + ' NO-LOCK WHERE ' + h-ide:NAME + "." + STRING(hQueryBuffer:BUFFER-FIELD('nNF'):NAME) + ' = "' + STRING(INT(nota-fiscal.nr-nota-fis)) + '"').
                                     h-query:QUERY-OPEN().

                        REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.

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

                /**** Atualizaá∆o da tabela Emitente Nota Fiscal ****/
                FOR FIRST tt-epc
                    WHERE tt-epc.cod-event = p-ind-event 
                      AND tt-epc.cod-parameter = "emit":U:

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

                    ASSIGN h-emit      = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-emit:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-emit:NAME + ' NO-LOCK' /*WHERE ' + h-emit:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
                                     h-query:QUERY-OPEN().
                    
                        REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.

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

                        END.
                    END.
                    ASSIGN h-emit       = ?
                           hQueryBuffer = ?
                           h-query      = ?
                           h-campo      = ?.
                END.
                /**** Fim emit ****/
                
                /**** Atualizaá∆o da tabela Endereáo Emitente Nota Fiscal ****/
                FOR FIRST tt-epc
                    WHERE tt-epc.cod-event = p-ind-event 
                      AND tt-epc.cod-parameter = "enderEmit":U:

                    ASSIGN h-enderEmit  = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-enderEmit:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-enderEmit:NAME + ' NO-LOCK' /*WHERE ' + h-enderEmit:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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
                      AND tt-epc.cod-parameter = "dest":U:

                    ASSIGN h-dest       = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-dest:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-dest:NAME + ' NO-LOCK' /*WHERE ' + h-dest:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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
                      AND tt-epc.cod-parameter = "enderDest":U:

                    ASSIGN h-enderDest  = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-enderDest:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-enderDest:NAME + ' NO-LOCK' /*WHERE ' + h-enderDest:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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
                            FIND int-loc-entr
                                WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                                  AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
                            FIND loc-entr
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
                                
                                assign nota-fiscal.endereco = loc-entr.endereco  
                                       nota-fiscal.bairro   = loc-entr.bairro   
                                       nota-fiscal.cidade   = loc-entr.cidade      
                                       nota-fiscal.estado   = loc-entr.estado      
                                       nota-fiscal.pais     = loc-entr.pais         
                                       nota-fiscal.cep      = loc-entr.cep.          
                                       
                             
                                FIND FIRST mgcad.cidade NO-LOCK
                                    WHERE mgcad.cidade.cidade = loc-entr.cidade
                                      AND mgcad.cidade.estado = loc-entr.estado
                                      AND mgcad.cidade.pais   = loc-entr.pais NO-ERROR.
                                IF AVAIL mgcad.cidade THEN DO:
                                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('cMun') NO-ERROR.
                                    ASSIGN h-campo:BUFFER-VALUE = STRING(mgcad.cidade.cdn-munpio-ibge,'9999999').
                                END.
                            
                            END.
                            ELSE DO:
                                FIND FIRST mgcad.cidade no-lock
                                    WHERE mgcad.cidade.cidade = hQueryBuffer:BUFFER-FIELD('xMun'):BUFFER-VALUE
                                      AND mgcad.cidade.estado = hQueryBuffer:BUFFER-FIELD('UF'):BUFFER-VALUE
                                      AND mgcad.cidade.pais   = hQueryBuffer:BUFFER-FIELD('xPais'):BUFFER-VALUE NO-ERROR.
                                IF AVAIL mgcad.cidade THEN DO:
                                    ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('cMun') NO-ERROR.
                                    ASSIGN h-campo:BUFFER-VALUE = string(mgcad.cidade.cdn-munpio-ibge,'9999999').
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
                      AND tt-epc.cod-parameter = "prod":U:

                    ASSIGN h-prod       = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-prod:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-prod:NAME + ' NO-LOCK' /*WHERE ' + h-prod:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
                                     h-query:QUERY-OPEN().
                    
                        REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.

                            FIND ITEM WHERE ITEM.it-codigo = hQueryBuffer:BUFFER-FIELD('cProd'):BUFFER-VALUE NO-LOCK NO-ERROR.
                            IF AVAIL item  THEN DO:
                                RUN pi-narrativa-item (INPUT nota-fiscal.cod-estabel,
                                                       INPUT ITEM.it-codigo,
                                                       INPUT INT(hQueryBuffer:BUFFER-FIELD('nItem'):BUFFER-VALUE),
                                                       OUTPUT c-narrativa-do-item).
                            
                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xProd') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = c-narrativa-do-item.
                            END.
                            /**** Busca det para atualizar narrativa do item da Nota ****/
                            FOR FIRST bf-tt-epc
                                WHERE bf-tt-epc.cod-event = p-ind-event 
                                  AND bf-tt-epc.cod-parameter = "det":U:
                            
                                ASSIGN h-det        = WIDGET-HANDLE(bf-tt-epc.val-parameter)
                                       hQueryBuffer2 = h-det:DEFAULT-BUFFER-HANDLE.

                                IF  VALID-HANDLE(hQueryBuffer2) THEN DO:
                                
                                    CREATE QUERY h-query2.
                                                 h-query2:SET-BUFFERS(hQueryBuffer2).
                                                 h-query2:QUERY-PREPARE('for each ' + h-det:NAME + ' NO-LOCK WHERE nItem = ' + STRING(hQueryBuffer:BUFFER-FIELD('nItem'):BUFFER-VALUE)).
                                                 h-query2:QUERY-OPEN().
                                
                                    REPEAT ON ERROR UNDO, LEAVE:
                                        h-query2:GET-NEXT().
                                        IF h-query2:QUERY-OFF-END THEN LEAVE.

                                        ASSIGN h-campo2 = hQueryBuffer2:BUFFER-FIELD('infAdProd') NO-ERROR.

                                        IF AVAIL item AND
                                            ITEM.ind-imp-desc = 7 THEN DO:
                                             assign h-campo:BUFFER-VALUE = h-campo:BUFFER-VALUE  + string(h-campo2:BUFFER-VALUE).    
                                        END.

                                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xProd') NO-ERROR.
                                        if h-campo:BUFFER-VALUE = '' THEN DO:
                                            ASSIGN h-campo2 = hQueryBuffer2:BUFFER-FIELD('nItem') NO-ERROR.
                                            FOR EACH nar-it-nota FIELDS(narrativa) NO-LOCK
                                               WHERE nar-it-nota.cod-estabel = nota-fiscal.cod-estabel
                                                 AND nar-it-nota.serie       = nota-fiscal.serie      
                                                 AND nar-it-nota.nr-nota-fis = nota-fiscal.nr-nota-fis
                                                 AND nar-it-nota.nr-sequencia = INT(h-campo2:BUFFER-VALUE) * 10.
                                                ASSIGN h-campo:BUFFER-VALUE = h-campo:BUFFER-VALUE + nar-it-nota.narrativa.
                                            END.
                                        END.

                                        FOR FIRST int-it-nota-fisc no-lock
                                            where int-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                              and int-it-nota-fisc.serie       = nota-fiscal.serie      
                                              and int-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                                              and int-it-nota-fisc.nr-seq-fat  = INT(h-campo2:BUFFER-VALUE) * 10
                                              AND int-it-nota-fisc.it-codigo   = ITEM.it-codigo:
                                        
                                        END.
                                        
                                    END.
                                END.
                            END.
                            /**** Fim det ****/
                            
                            
                            IF estabelec.cod-estabel = "102" THEN DO:
                                FIND item-mat
                                     WHERE item-mat.it-codigo = hQueryBuffer:BUFFER-FIELD('cProd'):BUFFER-VALUE NO-LOCK NO-ERROR.
                                IF AVAIL Item-mat AND
                                   item-mat.cod-ean <> "" THEN
                                   ASSIGN h-campo:BUFFER-VALUE = trim(h-campo:BUFFER-VALUE) + " EAN: " + string(item-mat.cod-ean).
                            END.
                            ASSIGN c-xProd = h-campo:BUFFER-VALUE.
                            RUN RetiraAcentos (INPUT-OUTPUT c-xProd).
                            ASSIGN c-xProd              = fn-free-accent(LEFT-trim(c-xProd)).
                            ASSIGN h-campo:BUFFER-VALUE = c-xProd.
                            
                            
                            
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
                            /* Fim - Pedido de Origem do Cliente */

                            IF l-log-ativa = YES THEN
                            MESSAGE "antes nota de entrada"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            IF AVAIL nota-fiscal 
                                AND natur-oper.nat-operacao BEGINS "3" 
                                AND substring(natur-oper.nat-operacao,1,4) <> "3201" 
                                AND substring(natur-oper.nat-operacao,1,4) <> "3202" THEN DO:
                                IF l-log-ativa = YES THEN
                                MESSAGE "nota de entrada "
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
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
                                         and it-nota-fisc.nr-seq-fat  = INT(hQueryBuffer:BUFFER-FIELD('nItem'):BUFFER-VALUE) * 10
                                         AND it-nota-fisc.it-codigo   = ITEM.it-codigo:
                                    END.
                                    
                                    IF l-log-ativa = YES THEN
                                    MESSAGE "AVAIL it-nota-fisc " AVAIL it-nota-fisc SKIP
                                        estabelec.cod-estabel                        SKIP
                                        nota-fiscal.serie                            SKIP
                                        nota-fiscal.nr-nota-fis                      SKIP
                                        INT(hQueryBuffer:BUFFER-FIELD('nItem'):BUFFER-VALUE) * 10             SKIP
                                        ITEM.it-codigo
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                     FOR EACH item-doc-est NO-LOCK
                                        WHERE item-doc-est.serie-docto   = it-nota-fisc.serie
                                          AND item-doc-est.nro-docto     = it-nota-fisc.nr-nota-fis
                                          AND item-doc-est.cod-emitente  = nota-fiscal.cod-emitente
                                          AND item-doc-est.nat-operacao  = it-nota-fisc.nat-operacao
                                          AND  item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped        
                                          AND item-doc-est.it-codigo     = it-nota-fisc.it-codigo:
                            
                                         IF l-log-ativa = YES THEN
                                         MESSAGE "Dentro item-doc-est"
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                         ASSIGN de-valor-frete = 0.
                            
                                          FOR EACH item-doc-est-cex NO-LOCK
                                               WHERE item-doc-est-cex.serie-docto  = nota-fiscal.serie
                                                 AND item-doc-est-cex.nro-docto    = nota-fiscal.nr-nota-fis
                                                 AND item-doc-est-cex.cod-emitente = nota-fiscal.cod-emitente
                                                 AND item-doc-est-cex.nat-operacao = nota-fiscal.nat-operacao
                                                 AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
                                                 AND (item-doc-est-cex.cod-desp    = 3  OR /* Frete */
                                                      item-doc-est-cex.cod-desp    = 93 OR /* Frete Prepaid */
                                                      item-doc-est-cex.cod-desp    = 22):  /* Seguro - Despesas que ja s∆o destacadas na nota portanto n∆o devera constar no valor outras - conforme Claudia 17/06/2015  */
                                              ASSIGN de-valor-frete = de-valor-frete + item-doc-est-cex.val-desp.
                                          END.
                                          ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('vOutro') NO-ERROR.
                                          ASSIGN h-campo:BUFFER-VALUE = trim(replace(STRING(item-doc-est.despesas[1] - de-valor-frete,">>>>>>>>>>>>9.99"),",",".")).

                                          IF l-log-ativa = YES THEN
                                          MESSAGE "voutro" item-doc-est.despesas[1] - de-valor-frete
                                              VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            
                                    END.
                                END.
                             END. 
                            
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xPed') NO-ERROR.
                            ASSIGN h-campo:BUFFER-VALUE = fn-free-accent(c-xped) /* novo */.

                            /**** Busca ICMS para atualizar a Origem da Nota ****/
                            FOR FIRST bf-tt-epc
                                WHERE bf-tt-epc.cod-event = p-ind-event 
                                  AND bf-tt-epc.cod-parameter = "ICMS":U:

                                FIND FIRST int-it-nota-fisc no-lock
                                     where int-it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel         
                                       and int-it-nota-fisc.serie       = nota-fiscal.serie               
                                       and int-it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis         
                                       and int-it-nota-fisc.nr-seq-fat  = INT(h-campo2:BUFFER-VALUE) * 10 NO-ERROR.
                            
                                ASSIGN h-ICMS        = WIDGET-HANDLE(bf-tt-epc.val-parameter)
                                       hQueryBuffer2 = h-ICMS:DEFAULT-BUFFER-HANDLE.
                                
                                IF  VALID-HANDLE(hQueryBuffer2) THEN DO:
                                
                                    CREATE QUERY h-query2.
                                                 h-query2:SET-BUFFERS(hQueryBuffer2).
                                                 h-query2:QUERY-PREPARE('for each ' + h-ICMS:NAME + ' NO-LOCK' /* WHERE ' + h-ICMS:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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
                      AND tt-epc.cod-parameter = "ICMSTot":U:

                    ASSIGN h-ICMSTot    = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-ICMSTot:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-ICMSTot:NAME + ' NO-LOCK' /*WHERE ' + h-ICMSTot:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
                                     h-query:QUERY-OPEN().
                    
                        REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.

                            FIND docum-est NO-LOCK
                            WHERE docum-est.serie = nota-fiscal.serie
                              AND docum-est.nro-docto = nota-fiscal.nr-nota-fis
                              AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                              AND docum-est.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.                    
                            
                            IF AVAILABLE docum-est THEN DO:
                                ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('vOutro') NO-ERROR.
                                ASSIGN h-campo:BUFFER-VALUE = REPLACE(TRIM(STRING(TRUNCATE(docum-est.valor-outras, 2),'>>>>>>>>>9.99')),',','.').
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
                      AND tt-epc.cod-parameter = "transporta":U:

                    ASSIGN h-transporta = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-transporta:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-transporta:NAME + ' NO-LOCK' /*WHERE ' + h-transporta:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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
                            FIND transporte
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
                      AND tt-epc.cod-parameter = "vol":U:

                    ASSIGN h-vol = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-vol:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-vol:NAME + ' NO-LOCK').
                                     h-query:QUERY-OPEN().
                    
                        hQueryBuffer:EMPTY-TEMP-TABLE().
                        /*REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.*/

                        hQueryBuffer:BUFFER-CREATE().

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('qVol') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = IF nota-fiscal.nr-volumes = ? OR nota-fiscal.nr-volumes = '' THEN "00" ELSE nota-fiscal.nr-volumes.

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('esp') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "VOLUME".

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('marca') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "INTELBRAS".

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('nVol') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = "".

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pesoL') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = replace(trim(string(TRUNCATE(nota-fiscal.peso-liq-tot,3),'>>>>>>>>>>>9.999')),',','.').

                        ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('pesoB') NO-ERROR.
                        ASSIGN h-campo:BUFFER-VALUE = replace(trim(string(TRUNCATE(nota-fiscal.peso-bru-tot,3),'>>>>>>>>>>>9.999')),',','.').
                            
                       /* END.*/
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
                      AND tt-epc.cod-parameter = "infAdic":U:

                    IF l-log-ativa = YES THEN
                    MESSAGE "gtnf027rp-upc.p inicio " tt-epc.cod-parameter
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        

                    ASSIGN h-infAdic = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-infAdic:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-infAdic:NAME + ' NO-LOCK' /*WHERE ' + h-infAdic:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
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

                                IF l-log-ativa = YES THEN
                                MESSAGE "gtnf027rp-upc.p inicio " tt-epc.cod-parameter SKIP
                                    nota-fiscal.serie           
                                    nota-fiscal.nr-nota-fis     
                                    nota-fiscal.cod-emitente    
                                    nota-fiscal.nat-operacao
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                assign de-pis    = 0
                                       de-cofins = 0.
                                FOR EACH item-doc-est NO-LOCK
                                   WHERE item-doc-est.serie-docto  = nota-fiscal.serie
                                     AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis
                                     AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                                     AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao:
                                    ASSIGN de-pis    = de-pis + item-doc-est.valor-pis
                                           de-cofins = de-cofins + item-doc-est.val-cofins.

                                    IF l-log-ativa = YES THEN
                                    MESSAGE "pis " de-pis   SKIP
                                                 "de-cofins " de-cofins SKIP
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                END.
                            
                                IF de-pis > 0 OR
                                   de-cofins > 9 THEN
                                    ASSIGN h-campo:BUFFER-VALUE = h-campo:BUFFER-VALUE + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99"))
                                           nota-fiscal.observ-nota = nota-fiscal.observ-nota + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")).
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
                      AND tt-epc.cod-parameter = "obsCont":U:

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
                        
                                DO i-cont = 1 TO NUM-ENTRIES(c-emails,'/'):
                                    hQueryBuffer:BUFFER-CREATE.
                                    hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "mailDest".
                                    hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = fn-free-accent(ENTRY(i-cont,c-emails,'/')).
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
                                        hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "MODO_IMPRESSAO".
                                        hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = 'manual'.
                                    END.
                                    ELSE DO:
                                        hQueryBuffer:BUFFER-CREATE.
                                        hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "MODO_IMPRESSAO".
                                        hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = 'auto'.
                                    END.
                                END. /* IF AVAIL pronto-programa THEN DO: */
                                ELSE DO:
                                    hQueryBuffer:BUFFER-CREATE.
                                    hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "MODO_IMPRESSAO".
                                    hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = 'auto'.
                                END.
                            END. /* IF fat-comercial.nr-nota-fis = '' THEN DO: */
                            ELSE DO:
                                hQueryBuffer:BUFFER-CREATE.
                                hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "MODO_IMPRESSAO".
                                hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = 'auto'.
                            END. /* IF fat-comercial.nr-nota-fis <> '' THEN DO: */
                        END. /* IF AVAIL fat-comercial THEN DO: */
                        ELSE DO:
                            hQueryBuffer:BUFFER-CREATE.
                            hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "MODO_IMPRESSAO".
                            hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = 'auto'.
                        END. /* IF NOT AVAIL fat-comercial THEN DO: */

                        /* Busca a impressora do usu†rio, ou a impressora padr∆o */
                        FIND FIRST usuario-impressora NO-LOCK
                            WHERE  usuario-impressora.cod-estabel = nota-fiscal.cod-estabel
                            AND    usuario-impressora.serie       = nota-fiscal.serie
                            AND    usuario-impressora.cod-usuario = nota-fiscal.user-calc NO-ERROR.
                        IF  AVAIL  usuario-impressora THEN DO:
                        
                            hQueryBuffer:BUFFER-CREATE.
                            hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "IMPRESSORA".
                            hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = fn-free-accent(usuario-impressora.impressora).
                        
                        END. /* IF  AVAIL  usuario-impressora THEN DO: */
                        ELSE DO:
                            FIND FIRST impressora-padrao NO-LOCK
                                WHERE  impressora-padrao.cod-estabel = nota-fiscal.cod-estabel
                                AND    impressora-padrao.serie       = nota-fiscal.serie NO-ERROR.
                            IF  AVAIL  impressora-padrao THEN DO:
                        
                                hQueryBuffer:BUFFER-CREATE.
                                hQueryBuffer:BUFFER-FIELD('xCampo'):BUFFER-VALUE = "IMPRESSORA".
                                hQueryBuffer:BUFFER-FIELD('xTexto'):BUFFER-VALUE = fn-free-accent(impressora-padrao.impressora).
                        
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
                      AND tt-epc.cod-parameter = "compra":U:

                    ASSIGN h-compra = WIDGET-HANDLE(tt-epc.val-parameter)
                           hQueryBuffer = h-compra:DEFAULT-BUFFER-HANDLE.
                    
                    IF  VALID-HANDLE(hQueryBuffer) THEN DO:
                    
                        CREATE QUERY h-query.
                                     h-query:SET-BUFFERS(hQueryBuffer).
                                     h-query:QUERY-PREPARE('for each ' + h-compra:NAME + ' NO-LOCK' /*WHERE ' + h-compra:NAME + "." + string(hQueryBuffer:BUFFER-FIELD('cNF'):NAME) + ' = "' + STRING(nota-fiscal.nr-nota-fis) + '"'*/).
                                     h-query:QUERY-OPEN().
                    
                        REPEAT ON ERROR UNDO, LEAVE:
                            h-query:GET-NEXT().
                            IF h-query:QUERY-OFF-END THEN LEAVE.
                            
                            ASSIGN h-campo = hQueryBuffer:BUFFER-FIELD('xPed') NO-ERROR.
                            ASSIGN c-campo = c-xped.
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

            END.
        END.
    END.
    /*** Fim AtualizaDadosNFe ***/

    /* N∆o ser† necess†rio utilizaá∆o de chamada epc para tratar diret¢rio UNIX, ser† incorporado no produto.

    /*** Input especifico para a Intelbras ***/
    WHEN "InputFromIntelbras":U THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "input":U EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            FIND FIRST gati-nfe-param-ext
                 WHERE gati-nfe-param-ext.cod-estabel = tt-epc.val-parameter NO-LOCK.        
            IF opsys <> 'WIN32' AND AVAIL gati-nfe-param-ext THEN DO:
                ASSIGN tt-epc.val-parameter = gati-nfe-param-ext.end-imp-txt-unix.
                RETURN "OK-intelbras":U.
            END.
            ELSE DO:
                RETURN "NOK-intelbras":U.
            END.
        END.
        ELSE DO:
            RETURN "NOK-intelbras":U.
        END.
    END.
    /*** fim input ***/

    /*** Input especifico para a Intelbras ***/
    WHEN "OutputToIntelbras":U THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "output":U EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            FIND FIRST gati-nfe-param-ext
                 WHERE gati-nfe-param-ext.cod-estabel = tt-epc.val-parameter NO-LOCK.        
            IF opsys <> 'WIN32' AND AVAIL gati-nfe-param-ext THEN DO:
                ASSIGN tt-epc.val-parameter = gati-nfe-param-ext.end-imp-txt-unix + 'log_' + string(today,'99-99-9999') + '.txt'.
                RETURN "OK-intelbras":U.
            END.
            ELSE DO:
                RETURN "NOK-intelbras":U.
            END.
        END.
        ELSE DO:
            RETURN "NOK-intelbras":U.
        END.
    END.
    /*** fim input ***/*/


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
             and   nar-it-nota.nr-sequencia = i-sequencia * 10
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
   FIND natur-oper
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
                        ASSIGN c-email-destino = trim(c-email-destino) + "/" + trim(cont-emit.e-mail).
           END.
        END.
        ELSE DO:
            find first b-emitente no-lock
                 where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
            ASSIGN c-email-destino = b-emitente.e-mail.
            
        END.
   END.


END PROCEDURE.
