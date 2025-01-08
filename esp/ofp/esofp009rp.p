{include/i-prgvrs.i esofp009rp 2.00.00.001}

{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-situacao    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-trib-icm     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-trib-ipi     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-trib-iss     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-trib-pis     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-trib-confins AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ori-doc      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-nat     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aliquota-iss AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cst-icms     AS INT         NO-UNDO.
DEFINE VARIABLE l-sub          AS LOG         NO-UNDO.

DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
       FIELD nr-seq-of AS INT.
DEFINE VAR i-seq-of     AS INT NO-UNDO.
DEFINE VAR c-cst-icms   AS CHAR NO-UNDO.
DEFINE VAR c-cst-ipi    AS CHAR NO-UNDO.
DEFINE VAR c-cst-pis    AS CHAR NO-UNDO.
DEFINE VAR c-cst-cofins AS CHAR NO-UNDO.
DEFINE VAR d-vl-compl   AS DEC NO-UNDO.


DEFINE VARIABLE c-sit-nota     AS CHARACTER FORMAT "x(30)"   NO-UNDO.

DEFINE VARIABLE c-chave AS CHAR NO-UNDO.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR mgcad.empresa.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD dt-emis-doc-ini  LIKE doc-fiscal.dt-emis-doc
    FIELD dt-emis-doc-fim  LIKE doc-fiscal.dt-emis-doc
    FIELD cod-emitente-ini LIKE doc-fiscal.cod-emitente
    FIELD cod-emitente-fim LIKE doc-fiscal.cod-emitente
    FIELD cod-estabel-ini  LIKE doc-fiscal.cod-estabel
    FIELD cod-estabel-fim  LIKE doc-fiscal.cod-estabel
    FIELD serie-ini        LIKE doc-fiscal.serie
    FIELD serie-fim        LIKE doc-fiscal.serie
    FIELD nat-operacao-ini LIKE doc-fiscal.nat-operacao
    FIELD nat-operacao-fim LIKE doc-fiscal.nat-operacao
    FIELD nr-doc-fisc-ini  LIKE doc-fiscal.nr-doc-fis
    FIELD nr-doc-fisc-fim  LIKE doc-fiscal.nr-doc-fis
    FIELD tg-notas           AS LOG.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esofp009_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "Data Entrada;Data EmissÆo;Esp‚cie;S‚rie;N£mero;Est;C¢d. Emitente;CNPJ;UF orig;Valor Total NF;Natureza Opera‡Æo;CFOP resumido;Trib ICMS;% ICMS;Valor ICMS;Trib IPI;% IPI;Valor IPI;Trib Pis;% Pis;Valor PIS;Trib Cofins;% Cofins;Valor Cofins;Trib ISS;% ISS;Valor ISS;Origem Documento;Tipo Natureza Opera‡Æo;C¢digo Mensagem;Chave acesso;Item;Descri‡Æo Item;C¢d IBGE Origem;C¢d IBGE Destino;Valor Tot Merc;BC ICMS-ST;Valor ICMS-ST;Situacao NF;Difer Aliq;CST ICMS; CST IPI; CST PIS; CST COFINS" SKIP.

    
    FOR EACH doc-fiscal NO-LOCK
       WHERE doc-fiscal.dt-docto     >= tt-param.dt-emis-doc-ini
         AND doc-fiscal.dt-docto     <= tt-param.dt-emis-doc-fim
         AND doc-fiscal.cod-emitente >= tt-param.cod-emitente-ini
         AND doc-fiscal.cod-emitente <= tt-param.cod-emitente-fim
         AND doc-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
         AND doc-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
         AND doc-fiscal.serie        >= tt-param.serie-ini
         AND doc-fiscal.serie        <= tt-param.serie-fim
         AND doc-fiscal.nat-operacao >= tt-param.nat-operacao-ini
         AND doc-fiscal.nat-operacao <= tt-param.nat-operacao-fim
         AND doc-fiscal.nr-doc-fis   >= tt-param.nr-doc-fisc-ini
         AND doc-fiscal.nr-doc-fis   <= tt-param.nr-doc-fisc-fim,
        EACH it-doc-fisc OF doc-fiscal NO-LOCK:

        ASSIGN c-trib-icm = {diinc/i01di084.i 04 it-doc-fisc.cd-trib-icm}
               c-trib-ipi = {diinc/i01di084.i 04 it-doc-fisc.cd-trib-ipi}
               c-trib-iss = {diinc/i01di084.i 04 it-doc-fisc.cd-trib-iss}
               c-trib-pis = {diinc/i01di084.i 04 it-doc-fisc.cd-trib-pis}
               c-trib-confins = {diinc/i01di084.i 04 it-doc-fisc.cd-trib-cofins}
               c-ori-doc  = {diinc/i07di037.i 04 doc-fiscal.ind-ori-doc}
               c-tipo-nat = {diinc/i01di025.i 04 doc-fiscal.tipo-nat}
               c-aliquota-iss = IF STRING(it-doc-fisc.aliquota-iss) = ? THEN "" ELSE STRING(it-doc-fisc.aliquota-iss).

        ASSIGN c-sit-nota = "".
        IF (c-ori-doc = "Faturamento" AND c-tipo-nat = "saida") OR
           (c-ori-doc = "Faturamento" AND c-tipo-nat = "servi‡o") THEN DO:
           FIND FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.nr-nota-fis = doc-fiscal.nr-doc-fis
                  AND nota-fiscal.serie       = doc-fiscal.serie
                  AND nota-fiscal.cod-estabel = doc-fiscal.cod-estabel NO-ERROR.
           IF AVAIL nota-fiscal THEN DO:

               IF c-tipo-nat = "servi‡o" THEN DO:
                   IF SUBSTRING(nota-fiscal.char-1,143,2) = "1" THEN
                      ASSIGN c-sit-nota = "Nao enviada".
                   ELSE IF SUBSTRING(nota-fiscal.char-1,143,2) = "" THEN
                            ASSIGN c-sit-nota = "Enviada ".
                        ELSE IF SUBSTRING(nota-fiscal.char-1,143,2) = "3" THEN
                                ASSIGN c-sit-nota = "Convertida".
                             ELSE IF  SUBSTRING(nota-fiscal.char-1,143,2) = "4" THEN
                                      ASSIGN c-sit-nota = "Erro". 
                                  ELSE IF SUBSTRING(nota-fiscal.char-1,143,2) = "5" THEN
                                          ASSIGN c-sit-nota = "Cancelamento Enviado".
                                       ELSE
                                           ASSIGN c-sit-nota = "Cancelada/Substituida". 
               END.
               ELSE
                   ASSIGN c-sit-nota = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}.
           END.
        END.
        ELSE DO:
            IF doc-fiscal.esp-docto = "nfe" OR doc-fiscal.esp-docto = "nfd" THEN DO:

                IF c-ori-doc = "recebimento" AND c-tipo-nat = "entrada" THEN DO:

                    ASSIGN c-cst-icms   = ""
                           c-cst-ipi    = ""
                           c-cst-pis    = ""
                           c-cst-cofins = "".

                    FIND FIRST nota-fiscal
                         WHERE nota-fiscal.cod-estabel = doc-fiscal.cod-estabel  
                           AND nota-fiscal.serie       = doc-fiscal.serie
                           AND nota-fiscal.nr-nota-fis = doc-fiscal.nr-doc-fis NO-LOCK NO-ERROR.
                    IF AVAIL nota-fiscal THEN DO:
                         FIND FIRST natur-oper NO-LOCK
                              WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                                AND natur-oper.tipo = 1 /* entradas */  NO-ERROR.
                         IF AVAIL natur-oper THEN
                            ASSIGN c-sit-nota = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}.

                         FIND FIRST it-nota-fisc NO-LOCK
                              WHERE it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                                AND it-nota-fisc.serie       = nota-fiscal.serie
                                AND it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                AND it-nota-fisc.it-codigo   = it-doc-fisc.it-codigo
                                AND it-nota-fisc.nr-seq-fat   = it-doc-fisc.nr-seq-doc NO-ERROR.
                         IF AVAIL it-nota-fisc THEN DO:

                             RUN ftp/ft0515a.p (INPUT ROWID(it-nota-fisc), 
                                                output i-cst-icms, 
                                                output l-sub).

                             ASSIGN c-cst-icms = string(i-cst-icms,"999").

                             ASSIGN c-cst-ipi    = it-nota-fisc.cod-sit-tributar-ipi      
                                    c-cst-pis    = it-nota-fisc.cod-sit-tributar-pis      
                                    c-cst-cofins = it-nota-fisc.cod-sit-tributar-cofins.  
                         END.
                    END.

                     IF c-cst-ipi = "" OR c-cst-pis = "" OR c-cst-cofins = ""  THEN DO:
                       FIND FIRST docum-est NO-LOCK
                            WHERE docum-est.cod-estabel  = doc-fiscal.cod-estabel
                              AND docum-est.serie-docto  = doc-fiscal.serie
                              AND docum-est.nro-docto    = doc-fiscal.nr-doc-fis
                              AND docum-est.cod-emitente = doc-fiscal.cod-emitente 
                              AND docum-est.nat-operacao = doc-fiscal.nat-operacao NO-ERROR.
                       IF AVAIL docum-est THEN DO:
                      
                          EMPTY TEMP-TABLE tt-item-doc-est.
                          ASSIGN i-seq-of = 0.
                          FOR EACH item-doc-est OF docum-est NO-LOCK:
                              ASSIGN i-seq-of = i-seq-of + 10.
                              CREATE tt-item-doc-est.
                              BUFFER-COPY item-doc-est TO tt-item-doc-est.
                              ASSIGN tt-item-doc-est.nr-seq-of = i-seq-of.
                          END.
                      
                          FIND FIRST tt-item-doc-est NO-LOCK
                               WHERE tt-item-doc-est.nro-docto   = docum-est.nro-docto
                                 AND tt-item-doc-est.serie-docto = docum-est.serie-docto
                                 AND tt-item-doc-est.it-codigo   = it-doc-fisc.it-codigo
                                 AND tt-item-doc-est.nr-seq-of   = it-doc-fisc.nr-seq-doc NO-ERROR.
                          IF AVAIL tt-item-doc-est THEN DO:
                               FOR EACH item-doc-est-tribut EXCLUSIVE-LOCK
                                  WHERE item-doc-est-tribut.cod-serie-docto   = tt-item-doc-est.serie-docto 
                                    AND item-doc-est-tribut.cod-num-docto     = tt-item-doc-est.nro-docto   
                                    AND item-doc-est-tribut.cdn-emitente      = tt-item-doc-est.cod-emitente    
                                    AND item-doc-est-tribut.cod-natur-operac  = tt-item-doc-est.nat-of
                                    AND item-doc-est-tribut.num-seq           = tt-item-doc-est.sequencia:
                      
                                   IF item-doc-est-tribut.cod-campo = "CST" THEN DO:
                      
                                       IF item-doc-est-tribut.nom-trib = "ICMS" THEN
                                           ASSIGN c-cst-icms  = item-doc-est-tribut.cod-conteudo.
                      
                                       IF item-doc-est-tribut.nom-trib = "IPI" THEN
                                           ASSIGN c-cst-ipi  = item-doc-est-tribut.cod-conteudo.
                      
                                       IF item-doc-est-tribut.nom-trib = "PIS" THEN
                                           ASSIGN c-cst-pis  = item-doc-est-tribut.cod-conteudo.
                      
                                       IF item-doc-est-tribut.nom-trib = "COFINS" THEN
                                           ASSIGN c-cst-cofins  = item-doc-est-tribut.cod-conteudo.
                                   END.                                                            
                               END.
                          END.
                       END.
                     END.
                END. 
            END.     

        END.

        IF NOT tt-param.tg-notas THEN DO: //se nao estiver marcado, lista somente notas autorizadas
            IF AVAIL nota-fiscal THEN
                IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT.
        END.

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo documento: " + doc-fiscal.nr-doc-fis).

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = doc-fiscal.cod-emitente NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-doc-fisc.it-codigo NO-ERROR.

/*         MESSAGE "STRING(doc-fiscal.dt-docto)         " STRING(doc-fiscal.dt-docto)         SKIP */
/*                 "STRING(doc-fiscal.dt-emis-doc)      " STRING(doc-fiscal.dt-emis-doc)      SKIP */
/*                 "doc-fiscal.esp-docto                " doc-fiscal.esp-docto                SKIP */
/*                 "doc-fiscal.serie                    " doc-fiscal.serie                    SKIP */
/*                 "doc-fiscal.nr-doc-fis               " doc-fiscal.nr-doc-fis               SKIP */
/*                 "doc-fiscal.cod-estabel              " doc-fiscal.cod-estabel              SKIP */
/*                 "STRING(doc-fiscal.cod-emitente)     " STRING(doc-fiscal.cod-emitente)     SKIP */
/*                 "emitente.cgc                        " emitente.cgc                        SKIP */
/*                 "emitente.estado                     " emitente.estado                     SKIP */
/*                 "STRING(it-doc-fisc.vl-merc-liq)     " STRING(it-doc-fisc.vl-merc-liq)     SKIP */
/*                 "doc-fiscal.nat-operacao             " doc-fiscal.nat-operacao             SKIP */
/*                 "doc-fiscal.cod-cfop                 " doc-fiscal.cod-cfop                 SKIP */
/*                 "c-trib-icm                          " c-trib-icm                          SKIP */
/*                 "STRING(it-doc-fisc.aliquota-icm)    " STRING(it-doc-fisc.aliquota-icm)    SKIP */
/*                 "STRING(it-doc-fisc.vl-icms-it)      " STRING(it-doc-fisc.vl-icms-it)      SKIP */
/*                 "c-trib-ipi                          " c-trib-ipi                          SKIP */
/*                 "STRING(it-doc-fisc.aliquota-ipi)    " STRING(it-doc-fisc.aliquota-ipi)    SKIP */
/*                 "STRING(it-doc-fisc.vl-ipi-it)       " STRING(it-doc-fisc.vl-ipi-it)       SKIP */
/*                 "c-trib-pis                          " c-trib-pis                          SKIP */
/*                 "STRING(it-doc-fisc.aliq-pis)        " STRING(it-doc-fisc.aliq-pis)        SKIP */
/*                 "STRING(it-doc-fisc.val-pis)         " STRING(it-doc-fisc.val-pis)         SKIP */
/*                 "c-trib-confins                      " c-trib-confins                      SKIP */
/*                 "STRING(it-doc-fisc.aliq-cofins)     " STRING(it-doc-fisc.aliq-cofins)     SKIP */
/*                 "STRING(it-doc-fisc.val-cofins)      " STRING(it-doc-fisc.val-cofins)      SKIP */
/*                 "c-trib-iss                          " c-trib-iss                          SKIP */
/*                 "STRING(it-doc-fisc.aliquota-iss)    " STRING(it-doc-fisc.aliquota-iss)    SKIP */
/*                 "STRING(it-doc-fisc.vl-iss-it)       " STRING(it-doc-fisc.vl-iss-it)       SKIP */
/*                 "c-ori-doc                           " c-ori-doc                           SKIP */
/*                 "c-tipo-nat                          " c-tipo-nat                          SKIP */
/*                 "STRING(doc-fiscal.cod-mensagem)     " STRING(doc-fiscal.cod-mensagem)     SKIP */
/*                 "doc-fiscal.cod-chave-aces-nf-eletro " doc-fiscal.cod-chave-aces-nf-eletro SKIP */
/*                 "it-doc-fisc.it-codigo               " it-doc-fisc.it-codigo               SKIP */
/*                 "ITEM.desc-item SKIP.                " ITEM.desc-item                           */
/*                                                                                                 */
/*             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                                           */

        ASSIGN c-chave = SUBSTRING(doc-fiscal.char-2,155,60)
               c-chave = TRIM(c-chave)
               c-chave = c-chave + ''''.

        IF c-cst-icms = "" THEN DO:
            ASSIGN c-cst-icms = SUBSTRING(it-doc-fisc.char-2,228,3).
            IF LENGTH(c-cst-icms) = 2 THEN
               ASSIGN c-cst-icms =  FILL('0',3 - LENGTH(c-cst-icms)) + c-cst-icms.
        END.
        IF c-cst-ipi = "" THEN
            ASSIGN c-cst-ipi = SUBSTRING(it-doc-fisc.char-2,231,3).
        IF c-cst-pis = "" THEN
            ASSIGN c-cst-pis = SUBSTRING(it-doc-fisc.char-2,280,3).
        IF c-cst-cofins = "" THEN
            ASSIGN c-cst-cofins = SUBSTRING(it-doc-fisc.char-2,283,3).

        IF  AVAIL tt-item-doc-est THEN
            ASSIGN d-vl-compl = tt-item-doc-est.icm-complem[1].
        ELSE
            ASSIGN d-vl-compl = doc-fiscal.vl-icms-com.


        PUT STREAM str-excel UNFORMATTED STRING(doc-fiscal.dt-docto)         + ";" +  
                                         STRING(doc-fiscal.dt-emis-doc)      + ";" +  
                                         doc-fiscal.esp-docto                + ";" +  
                                         doc-fiscal.serie                    + ";" +  
                                         doc-fiscal.nr-doc-fis               + ";" +  
                                         doc-fiscal.cod-estabel              + ";" +  
                                         STRING(doc-fiscal.cod-emitente)     + ";" +  
                                         emitente.cgc                        + ";" + 
                                         emitente.estado                     + ";" + 
                                         STRING(it-doc-fisc.vl-tot-item)     + ";" + 
                                         doc-fiscal.nat-operacao             + ";" +  
                                         doc-fiscal.cod-cfop                 + ";" +  
                                         c-trib-icm                          + ";" +                     
                                         STRING(it-doc-fisc.aliquota-icm)    + ";" +  
                                         STRING(it-doc-fisc.vl-icms-it)      + ";" +  
                                         c-trib-ipi                          + ";" +  
                                         STRING(it-doc-fisc.aliquota-ipi)    + ";" +  
                                         STRING(it-doc-fisc.vl-ipi-it)       + ";" +  
                                         c-trib-pis                          + ";" +  
                                         SUBSTRIN(it-doc-fisc.char-2, 22, 8) + ";" +      
                                         STRING(it-doc-fisc.val-pis)         + ";" +  
                                         c-trib-confins                      + ";" +  
                                         SUBSTRIN(it-doc-fisc.char-2, 30, 8) + ";" +      
                                         STRING(it-doc-fisc.val-cofins)      + ";" +  
                                         c-trib-iss                          + ";" +  
                                         c-aliquota-iss                      + ";" +  
                                         STRING(it-doc-fisc.vl-iss-it)       + ";" +  
                                         c-ori-doc                           + ";" +  
                                         c-tipo-nat                          + ";" +  
                                         STRING(doc-fiscal.cod-mensagem)     + ";" +  
                                         string('''')+ c-chave               + ";" +
                                         it-doc-fisc.it-codigo               + ";" +  
                                         ITEM.desc-item                      + ";" +
                                         SUBSTRING(doc-fiscal.char-1,231,10) + ";" +  
                                         SUBSTRING(doc-fiscal.char-1,241,10) + ";" +
                                         STRING(it-doc-fisc.vl-merc-liq)     + ";" +
                                         STRING(it-doc-fisc.vl-bsubs-it)     + ";" +  
                                         STRING(it-doc-fisc.vl-icmsub-it)    + ";" +
                                         c-sit-nota                          + ";" + 
                                         STRING(d-vl-compl)                  + ";" + 
                                         "'" string(c-cst-icms)              + ";" +
                                         STRING(c-cst-ipi)                   + ";" +
                                         string(c-cst-pis)                   + ";" +
                                         string(c-cst-cofins)                + ";" SKIP.
    END.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
