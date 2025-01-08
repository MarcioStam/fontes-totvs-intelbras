/********************************************************************************
 ** UPC........: wdi135.p - UPC WRITE nota-fiscal
 ** Data.......: Dezembro/2015
 ********************************************************************************/
DEF PARAM BUFFER b-nota-fiscal      FOR nota-fiscal.
DEF PARAM BUFFER b-old-nota-fiscal  FOR nota-fiscal.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.

DEF BUFFER b-nota-fiscal-2  FOR nota-fiscal.
DEF BUFFER b_bem_pat        FOR bem_pat.
DEF BUFFER b_movto_bem_pat  FOR movto_bem_pat.
DEF BUFFER b_int_bem_pat_nf FOR int_bem_pat_nf.

DEFINE VARIABLE c-action         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-msg            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-erro           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vl-FCP           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vl-IcmsUFDest    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-cod-estab      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-controladoria  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-remetente      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi018       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.

DEFINE VARIABLE c-email-destino  AS CHAR        NO-UNDO.

DEF VAR i-cod-bem    AS INTEGER NO-UNDO.
DEF VAR i-seq-bem    AS INTEGER NO-UNDO.
DEF VAR c-chave-bem  AS CHAR    NO-UNDO.

define temp-table tt-param-esftp124 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estab-ini    AS CHAR
    FIELD cod-estab-fim    AS CHAR
    FIELD serie-ini        AS CHAR
    FIELD serie-fim        AS CHAR
    FIELD nr-nota-ini      AS CHAR
    FIELD nr-nota-fim      AS CHAR
    FIELD dt-emiss-ini     AS DATE
    FIELD dt-emiss-fim     AS DATE
    FIELD dia-atual        AS LOG.

define temp-table tt-ped-venda no-undo like ped-venda.
define temp-table tt-ped-item  no-undo like ped-item.

{btb/btb912zb.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{esp/es0018.i}
{utp/utapi019.i}
{utp/ut-glob.i}

RUN prmtw/tw-nota-fiscal.p(BUFFER b-nota-fiscal, BUFFER b-old-nota-fiscal).

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nr-pedcli  = b-nota-fiscal.nr-pedcli
      AND ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli:

    /*Grava informaá‰es comiss‰es*/   
    FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK 
         WHERE int-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel
           AND int-nota-fiscal.serie       = b-nota-fiscal.serie
           AND int-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis NO-ERROR.
    
    IF NOT AVAIL int-nota-fiscal THEN DO:
       CREATE int-nota-fiscal.
       ASSIGN int-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel      
              int-nota-fiscal.serie       = b-nota-fiscal.serie            
              int-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST repres NO-LOCK
         WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.

    FIND FIRST int-exec-superv NO-LOCK
         WHERE int-exec-superv.cod-executivo = repres.cod-rep
           AND int-exec-superv.dt-termino    = ? NO-ERROR.

    ASSIGN int-nota-fiscal.cod-atendente  = ped-venda.tp-pedido
           int-nota-fiscal.cod-rep        = IF AVAIL repres THEN repres.cod-rep ELSE 0
           int-nota-fiscal.cod-supervisor = IF AVAIL int-exec-superv THEN int-exec-superv.cod-supervisor ELSE 0
           int-nota-fiscal.cod-canal      = ped-venda.cod-canal
           int-nota-fiscal.cod-gr-cli     = IF AVAIL emitente THEN emitente.cod-gr-cli ELSE 0.
    
     FIND FIRST cond-ped NO-LOCK
          WHERE cond-ped.nr-pedido    = ped-venda.nr-pedido
            AND cond-ped.nr-sequencia = 10 NO-ERROR.
     IF AVAIL cond-ped THEN
         IF cond-ped.observacoes BEGINS "Mibo" OR cond-ped.observacoes BEGINS "Marketplace:Mibo" THEN
             ASSIGN int-nota-fiscal.id-pagto-cartao = trim(ENTRY(2,ENTRY(4,cond-ped.observacoes,CHR(10)),":")).

    FOR EACH it-nota-fisc OF b-nota-fiscal NO-LOCK:

        FIND FIRST mgesp.int-ped-item-pci
             WHERE int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev
               AND int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
               AND int-ped-item-pci.it-codigo    = it-nota-fisc.it-codigo
               AND int-ped-item-pci.nr-sequencia = it-nota-fisc.nr-seq-ped NO-LOCK NO-ERROR.
        IF AVAIL int-ped-item-pci THEN DO:

            FIND FIRST int-it-nota-pci 
                 WHERE int-it-nota-pci.nome-abrev       = int-ped-item-pci.nome-abrev 
                   AND int-it-nota-pci.nr-pedcli        = int-ped-item-pci.nr-pedcli
                   AND int-it-nota-pci.nr-sequencia     = int-ped-item-pci.nr-sequencia
                   AND int-it-nota-pci.it-codigo        = int-ped-item-pci.it-codigo
                   AND int-it-nota-pci.cod-refer        = int-ped-item-pci.cod-refer NO-LOCK NO-ERROR.

            IF NOT AVAIL int-it-nota-pci THEN DO:
                CREATE int-it-nota-pci. 
                ASSIGN int-it-nota-pci.nr-tabpre        = int-ped-item-pci.nr-tabpre       
                       int-it-nota-pci.nr-sequencia     = int-ped-item-pci.nr-sequencia    
                       int-it-nota-pci.nr-pedcli        = int-ped-item-pci.nr-pedcli       
                       int-it-nota-pci.nome-abrev       = int-ped-item-pci.nome-abrev      
                       int-it-nota-pci.it-codigo        = int-ped-item-pci.it-codigo       
                       int-it-nota-pci.desc-widecloud   = int-ped-item-pci.desc-widecloud  
                       int-it-nota-pci.desc-topmilhao   = int-ped-item-pci.desc-topmilhao  
                       int-it-nota-pci.desc-quant       = int-ped-item-pci.desc-quant      
                       int-it-nota-pci.desc-maisverde   = int-ped-item-pci.desc-maisverde  
                       int-it-nota-pci.desc-kit         = int-ped-item-pci.desc-kit        
                       int-it-nota-pci.desc-focounidade = int-ped-item-pci.desc-focounidade
                       int-it-nota-pci.desc-distrib20   = int-ped-item-pci.desc-distrib20  
                       int-it-nota-pci.desc-comercial   = int-ped-item-pci.desc-comerical  
                       int-it-nota-pci.cod-segmento     = int-ped-item-pci.cod-segmento    
                       int-it-nota-pci.cod-repres       = int-ped-item-pci.cod-repres      
                       int-it-nota-pci.cod-refer        = int-ped-item-pci.cod-refer     .
            END.
        END.
    END.
    FIND CURRENT int-nota-fiscal NO-LOCK NO-ERROR.
END.

ASSIGN c-action = IF NEW b-nota-fiscal THEN "I":U ELSE "A":U.

IF AVAIL b-nota-fiscal AND  c-action = 'I' THEN DO:
    
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli
           AND ped-venda.nr-pedcli  = b-nota-fiscal.nr-pedcli NO-ERROR.

    IF AVAIL ped-venda THEN DO:
        FIND FIRST int-item NO-LOCK
             WHERE int-item.nr-ped-energia = ped-venda.nr-pedcli NO-ERROR.

        FIND FIRST int-ped-venda EXCLUSIVE-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

        IF AVAIL int-item THEN
            ASSIGN int-ped-venda.ind-status-solar = 5.

        FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    END.
    
    FIND FIRST int-ped-trans  
         WHERE int-ped-trans.cod-estabel = b-nota-fiscal.cod-estabel 
           AND int-ped-trans.nome-abrev  = b-nota-fiscal.nome-ab-cli
           AND int-ped-trans.nr-pedcli   = b-nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.

     IF AVAIL int-ped-trans  THEN DO:
        IF  int-ped-trans.lot-transp      = YES THEN DO:
            RUN envia-email (INPUT b-nota-fiscal.nome-ab-cli,
                             INPUT b-nota-fiscal.nome-transp ,
                             INPUT b-nota-fiscal.nr-nota-fis, 
                             INPUT b-nota-fiscal.cod-estabel,
                             INPUT b-nota-fiscal.estado).
        END.
    END.

    IF b-nota-fiscal.serie = "FT" THEN
        RUN pi-historico-recorrencia.

END.

IF  b-nota-fiscal.dt-saida     <> b-old-nota-fiscal.dt-saida AND
    b-old-nota-fiscal.dt-saida <> ? THEN DO:
       FIND int-nota-fiscal
             WHERE int-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel
               AND int-nota-fiscal.serie       = b-nota-fiscal.serie
               AND int-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAIL int-nota-fiscal THEN DO:
           CREATE int-nota-fiscal.
           ASSIGN int-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel      
                  int-nota-fiscal.serie       = b-nota-fiscal.serie            
                  int-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis      .
       END.
       ASSIGN OVERLAY(int-nota-fiscal.char-1,100,500) = trim(SUBSTRING(int-nota-fiscal.char-1,100,500)) + 
                                                        "Dt.Saida Anterior: " + STRING(b-old-nota-fiscal.dt-saida) + " Atual: " + STRING(b-nota-fiscal.dt-saida) + 
                                                        " Dt. Atualiz." + string(TODAY) + " " + STRING(TIME,"HH:MM:SS") + " Usuario " + c-seg-usuario + "|".

       FIND CURRENT int-nota-fiscal NO-LOCK NO-ERROR.
END. /* IF  b-nota-fiscal */

IF  AVAIL b-nota-fiscal 
AND AVAIL b-old-nota-fiscal    THEN DO:

   FIND FIRST natur-oper NO-LOCK 
        WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao
          and natur-oper.tipo         = 3
          AND natur-oper.especie-doc  = 'NFS' NO-ERROR.

   IF AVAIL natur-oper THEN DO:

       ASSIGN c-nr-nota-fis = IF LENGTH(TRIM(SUBSTR(b-nota-fiscal.char-1,128,15))) = 5 THEN "00" + TRIM(SUBSTR(b-nota-fiscal.char-1,128,15)) ELSE TRIM(SUBSTR(b-nota-fiscal.char-1,128,15)).

       IF INTEGER(SUBSTR(b-nota-fiscal.char-1,143,2)) = 3 
       AND b-nota-fiscal.nr-nota-fis <> c-nr-nota-fis THEN DO:
            ASSIGN c-erro = ''.

            RUN upc/espnfse2030-upc.p (INPUT b-nota-fiscal.cod-estabel,
                                       INPUT b-nota-fiscal.serie,
                                       INPUT b-nota-fiscal.nr-nota-fis,
                                       INPUT c-nr-nota-fis,
                                       INPUT b-nota-fiscal.serie,
                                       OUTPUT c-erro).

            IF c-erro = "" THEN
                RUN pi-historico-recorrencia.

            IF  c-erro <> '' THEN DO: 
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'erro-notafiscal-servicos.txt') APPEND.
                 IF RETURN-VALUE = "NOK" THEN DO:
                    PUT unformatted "Estab.: " + b-old-nota-fiscal.cod-estabel + " - " .
                    PUT unformatted "Serie : " + b-old-nota-fiscal.serie       + " - " .
                    PUT unformatted "Nots  : " + b-old-nota-fiscal.nr-nota-fis + " - " .
                    PUT unformatted c-erro + "-" + substring(string(NOW),1,16) SKIP.
                 END.
                 OUTPUT CLOSE.
            END.
            RUN pi-trata-ecommerce (INPUT b-nota-fiscal.cod-estabel,
                                    INPUT b-nota-fiscal.serie,
                                    INPUT c-nr-nota-fis).
       END.
   END.

    IF b-old-nota-fiscal.idi-sit-nf-eletro = 2 
        AND (b-nota-fiscal.idi-sit-nf-eletro > 3
        AND  b-nota-fiscal.idi-sit-nf-eletro < 8) THEN DO:

        CASE b-nota-fiscal.idi-sit-nf-eletro:
            WHEN 4 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Denegada pelo SEFAZ.  ".
            WHEN 5 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Rejeitada pelo SEFAZ. ".
            WHEN 6 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Cancelada.            ".
            WHEN 7 THEN assign c-msg = " Nota fiscal :" +  b-nota-fiscal.nr-nota-fis + "\ Serie: " + b-nota-fiscal.serie  + " referente pedido " +  b-nota-fiscal.nr-pedcli + "  , foi Inutilizada.          ".
        END CASE. 

        FOR EACH ret-nf-eletro NO-LOCK
           WHERE ret-nf-eletro.cod-estabel = b-old-nota-fiscal.cod-estabel
             AND ret-nf-eletro.nr-nota-fis = b-old-nota-fiscal.nr-nota-fis
             AND ret-nf-eletro.cod-serie   = b-old-nota-fiscal.serie
             AND ret-nf-eletro.cod-livre-2 <> "":
        
            ASSIGN c-msg = c-msg + chr(13) + "Motivo Rejeiá∆o " + ret-nf-eletro.cod-msg + " - " +  ret-nf-eletro.cod-livre-2.
        END.

        FIND FIRST ped-fiscal NO-LOCK
             WHERE ped-fiscal.cod-estabel   = b-nota-fiscal.cod-estabel         
               AND ped-fiscal.serie         = b-nota-fiscal.serie               
               AND ped-fiscal.nr-nota-fis   = b-nota-fiscal.nr-nota-fis  NO-ERROR.   
        IF AVAILABLE ped-fiscal THEN DO:
            ASSIGN c-email-destino = "".

            for first ponto-programa
                where ponto-programa.nome-programa = "wdi135"
                  AND ponto-programa.ponto         = 1:

               FIND FIRST conteudo-programa
                    WHERE conteudo-programa.cod-programa          = ponto-programa.cod-programa
                      AND entry(1,conteudo-programa.conteudo,";") = b-nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
                IF AVAIL conteudo-programa THEN DO:
                    ASSIGN c-email-destino = entry(2,conteudo-programa.conteudo,";").
                    ASSIGN c-email-destino = REPLACE(c-email-destino,",",";").
                END.
           end. 
           IF c-email-destino = "" THEN
               ASSIGN c-email-destino = "grupo.fiscal@intelbras.com.br".
           RUN piEMail (INPUT c-email-destino).
        END.
    END.
END.

IF  b-nota-fiscal.idi-sit-nf-eletro      = 3 
AND b-old-nota-fiscal.idi-sit-nf-eletro <> 3 THEN DO:

    /*  --------------------------------------------------------------------------- */
    /*  Gravar int_bem_pat_nf com os dados do patrimìnio, a partir da it-ped-fiscal */
    /*  --------------------------------------------------------------------------- */
    IF  CAN-FIND(FIRST natur-oper 
                 WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao 
                 AND   natur-oper.tp-oper-terc = 1 /* Remessa Benef */) THEN DO:

        FIND FIRST ped-fiscal NO-LOCK
              WHERE ped-fiscal.cod-estabel   = b-nota-fiscal.cod-estabel         
              AND   ped-fiscal.serie         = b-nota-fiscal.serie               
              AND   ped-fiscal.nr-nota-fis   = b-nota-fiscal.nr-nota-fis  NO-ERROR.   
    
        IF  AVAIL ped-fiscal THEN DO:
    
            FOR EACH it-nota-fisc OF b-nota-fiscal NO-LOCK:  

                FIND FIRST nar-it-nota
				     WHERE nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
					   AND nar-it-nota.serie        = it-nota-fisc.serie
					   AND nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                       AND nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
                       AND nar-it-nota.it-codigo    = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.			
    
                FIND FIRST it-ped-fiscal NO-LOCK
                     WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                     AND   it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                     AND   it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni
                     AND   it-ped-fiscal.seq * 10  = it-nota-fisc.nr-seq-fat
                     AND   it-ped-fiscal.narrativa = (IF AVAIL nar-it-nota THEN nar-it-nota.narrativa ELSE it-ped-fiscal.narrativa) NO-ERROR.
                IF NOT AVAIL it-ped-fiscal THEN
                    FIND FIRST it-ped-fiscal NO-LOCK
                         WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                         AND   it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo 
                         AND   it-ped-fiscal.vl-unit   = it-nota-fisc.vl-preuni
                         AND   it-ped-fiscal.narrativa = (IF AVAIL nar-it-nota THEN nar-it-nota.narrativa ELSE it-ped-fiscal.narrativa) NO-ERROR.
    
                IF  AVAIL it-ped-fiscal THEN DO:
                    ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35). /*chave do bem (conta/bem/seq)*/
                    
                    IF  TRIM(c-chave-bem) <> "" AND NUM-ENTRIES(c-chave-bem,";") > 0 THEN DO:
                        i-cod-bem = INT(ENTRY(2,c-chave-bem,";")) NO-ERROR.
                        i-seq-bem = int(ENTRY(3,c-chave-bem,";")) NO-ERROR.
                        
                        FIND FIRST int_bem_pat_nf NO-LOCK
                            WHERE int_bem_pat_nf.cod-estabel = it-nota-fisc.cod-estabel
                            AND   int_bem_pat_nf.serie       = it-nota-fisc.serie      
                            AND   int_bem_pat_nf.nr-nota-fis = it-nota-fisc.nr-nota-fis
                            AND   int_bem_pat_nf.nr-seq-fat  = it-nota-fisc.nr-seq-fat 
                            AND   int_bem_pat_nf.it-codigo   = it-nota-fisc.it-codigo  NO-ERROR.
    
                        IF  NOT AVAIL int_bem_pat_nf 
                        AND it-nota-fisc.it-codigo <> '9930050' THEN DO:
                            CREATE int_bem_pat_nf.
                            ASSIGN int_bem_pat_nf.cod-estabel     = it-nota-fisc.cod-estabel
                                   int_bem_pat_nf.serie           = it-nota-fisc.serie      
                                   int_bem_pat_nf.nr-nota-fis     = it-nota-fisc.nr-nota-fis
                                   int_bem_pat_nf.nr-seq-fat      = it-nota-fisc.nr-seq-fat 
                                   int_bem_pat_nf.it-codigo       = it-nota-fisc.it-codigo  
                                   int_bem_pat_nf.cod_cta_pat     = ENTRY(1,c-chave-bem,";")
                                   int_bem_pat_nf.num_bem_pat     = i-cod-bem
                                   int_bem_pat_nf.num_seq_bem_pat = i-seq-bem
                                   int_bem_pat_nf.cod-emitente    = b-nota-fiscal.cod-emitente
                                   int_bem_pat_nf.dt-emis-nota    = b-nota-fiscal.dt-emis-nota
                                   int_bem_pat_nf.nat-operacao    = it-nota-fisc.nat-operacao
                                   int_bem_pat_nf.dt-vigencia     = it-ped-fiscal.data-1
                                   int_bem_pat_nf.int-1           = ped-fiscal.nat-oper
                                   int_bem_pat_nf.val-icms        = it-nota-fisc.vl-icms-it
                                   int_bem_pat_nf.class-fiscal    = it-nota-fisc.class-fiscal.
    
                            IF  int_bem_pat_nf.class-fiscal = "" THEN
                                ASSIGN int_bem_pat_nf.class-fiscal = '00000000'.
    
                            IF  ped-fiscal.nat-oper = 14 
                            OR  ped-fiscal.nat-oper = 15
                            OR  ped-fiscal.nat-oper = 36
                            OR  ped-fiscal.nat-oper = 37 THEN
                                ASSIGN int_bem_pat_nf.ind-terceiro = "Conserto".
    
                            IF  ped-fiscal.nat-oper = 34 THEN
                                ASSIGN int_bem_pat_nf.ind-terceiro = "Comodato".
    
                            IF  ped-fiscal.nat-oper = 17 
                            OR  ped-fiscal.nat-oper = 19 THEN
                                ASSIGN int_bem_pat_nf.ind-terceiro = "EmprÇstimo".
    
                            IF  ped-fiscal.nat-oper = 22 
                            OR  ped-fiscal.nat-oper = 24 THEN
                                ASSIGN int_bem_pat_nf.ind-terceiro = "Locaá∆o".
    
                            /* atualizar informacoes complementares bens gerados por reclassificacao */
                            FIND FIRST bem_pat
                                WHERE bem_pat.cod_cta_pat     = ENTRY(1,c-chave-bem,";")
                                AND   bem_pat.num_bem_pat     = i-cod-bem               
                                AND   bem_pat.num_seq_bem_pat = i-seq-bem NO-LOCK NO-ERROR.             
                                
                            IF  AVAIL bem_pat THEN DO:
                                
                                FIND FIRST movto_bem_pat
                                    where movto_bem_pat.num_id_bem_pat        = bem_pat.num_id_bem_pat
                                    and   movto_bem_pat.ind_orig_calc_bem_pat = "Reclassificaá∆o" NO-LOCK NO-ERROR.
                            
                                IF  AVAIL movto_bem_pat THEN DO:
                            
                                    FOR EACH b_movto_bem_pat NO-LOCK
                                        WHERE b_movto_bem_pat.num_id_bem_pat_orig         = movto_bem_pat.num_id_bem_pat
                                        AND   b_movto_bem_pat.num_seq_incorp_bem_pat_orig = movto_bem_pat.num_seq_incorp_bem_pat
                                        AND   b_movto_bem_pat.num_seq_movto_bem_pat_orig  = movto_bem_pat.num_seq_movto_bem_pat:
                            
                                        FIND FIRST b_bem_pat NO-LOCK
                                            WHERE b_bem_pat.num_id_bem_pat = b_movto_bem_pat.num_id_bem_pat NO-ERROR.
                            
                                        IF  AVAIL b_bem_pat THEN DO:
                                            CREATE b_int_bem_pat_nf.
                                            ASSIGN b_int_bem_pat_nf.cod-estabel     = it-nota-fisc.cod-estabel
                                                   b_int_bem_pat_nf.serie           = it-nota-fisc.serie      
                                                   b_int_bem_pat_nf.nr-nota-fis     = it-nota-fisc.nr-nota-fis
                                                   b_int_bem_pat_nf.nr-seq-fat      = it-nota-fisc.nr-seq-fat 
                                                   b_int_bem_pat_nf.it-codigo       = it-nota-fisc.it-codigo  
                                                   b_int_bem_pat_nf.cod_cta_pat     = b_bem_pat.cod_cta_pat    
                                                   b_int_bem_pat_nf.num_bem_pat     = b_bem_pat.num_bem_pat    
                                                   b_int_bem_pat_nf.num_seq_bem_pat = b_bem_pat.num_seq_bem_pat
                                                   b_int_bem_pat_nf.cod-emitente    = b-nota-fiscal.cod-emitente
                                                   b_int_bem_pat_nf.dt-emis-nota    = b-nota-fiscal.dt-emis-nota
                                                   b_int_bem_pat_nf.nat-operacao    = it-nota-fisc.nat-operacao
                                                   b_int_bem_pat_nf.dt-vigencia     = it-ped-fiscal.data-1
                                                   b_int_bem_pat_nf.int-1           = ped-fiscal.nat-oper
                                                   b_int_bem_pat_nf.val-icms        = it-nota-fisc.vl-icms-it
                                                   b_int_bem_pat_nf.class-fiscal    = it-nota-fisc.class-fiscal.

                                            IF  b_int_bem_pat_nf.class-fiscal = "" THEN
                                                ASSIGN b_int_bem_pat_nf.class-fiscal = '00000000'.

                                            IF  ped-fiscal.nat-oper = 14 
                                            OR  ped-fiscal.nat-oper = 15
                                            OR  ped-fiscal.nat-oper = 36
                                            OR  ped-fiscal.nat-oper = 37 THEN
                                                ASSIGN b_int_bem_pat_nf.ind-terceiro = "Conserto".

                                            IF  ped-fiscal.nat-oper = 34 THEN
                                                ASSIGN b_int_bem_pat_nf.ind-terceiro = "Comodato".

                                            IF  ped-fiscal.nat-oper = 17 
                                            OR  ped-fiscal.nat-oper = 19 THEN
                                                ASSIGN b_int_bem_pat_nf.ind-terceiro = "EmprÇstimo".

                                            IF  ped-fiscal.nat-oper = 22 
                                            OR  ped-fiscal.nat-oper = 24 THEN
                                                ASSIGN b_int_bem_pat_nf.ind-terceiro = "Locaá∆o".

                                        END.
                                    END.
                                END.
                            END.
                            /* atualizar informacoes complementares bens gerados por reclassificacao */
                        END.
                    END.
                END.
            END.
        END.
    END.
    ELSE DO:
        IF  CAN-FIND(FIRST natur-oper
                     WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao
                     AND   natur-oper.tp-oper-terc = 2 /* Retorno Benef */) THEN DO:

            FIND FIRST docum-est
                WHERE docum-est.serie-docto  = b-nota-fiscal.serie
                AND   docum-est.nro-docto    = b-nota-fiscal.nr-nota-fis
                AND   docum-est.cod-emitente = b-nota-fiscal.cod-emitente
                AND   docum-est.nat-operacao = b-nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

            IF  AVAIL docum-est THEN DO:
                FOR EACH item-doc-est OF docum-est NO-LOCK.
                    
                    FOR EACH int_bem_pat_nf
                        WHERE int_bem_pat_nf.cod-estabel = docum-est.cod-estabel
                        AND   int_bem_pat_nf.serie       = item-doc-est.serie-comp
                        AND   int_bem_pat_nf.nr-nota-fis = item-doc-est.nro-comp 
                        AND   int_bem_pat_nf.nr-seq-fat  = item-doc-est.seq-comp 
                        
                        AND   int_bem_pat_nf.it-codigo   = item-doc-est.it-codigo EXCLUSIVE-LOCK:
    
                        DELETE int_bem_pat_nf.
                    END.
                END.
            END.
        END.
    END.

    /*  --------------------------------------------- */
    /*  Regras para executar nos pedidos do ecommerce */
    /*  --------------------------------------------- */

    RUN pi-trata-ecommerce (INPUT b-nota-fiscal.cod-estabel,
                            INPUT b-nota-fiscal.serie,
                            INPUT b-nota-fiscal.nr-nota-fis).

    RUN pi-integra-salesforce.

END.

IF  b-nota-fiscal.dt-cancel    <> ?
AND b-old-nota-fiscal.dt-cancel = ? THEN DO:
    /* excluir informaá‰es complementares do bem, caso a NF seja cancelada */
    IF  CAN-FIND(FIRST natur-oper 
                 WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao 
                 AND   natur-oper.tp-oper-terc = 1 /* Remessa Benef */) THEN DO:

        FIND FIRST ped-fiscal NO-LOCK
              WHERE  ped-fiscal.cod-estabel   = b-nota-fiscal.cod-estabel         
                AND  ped-fiscal.serie         = b-nota-fiscal.serie               
                AND  ped-fiscal.nr-nota-fis   = b-nota-fiscal.nr-nota-fis  NO-ERROR.   
    
        IF  AVAIL ped-fiscal THEN DO:
    
            FOR EACH it-nota-fisc OF b-nota-fiscal NO-LOCK:    
    
                FOR EACH int_bem_pat_nf
                    WHERE int_bem_pat_nf.cod-estabel = it-nota-fisc.cod-estabel
                    AND   int_bem_pat_nf.serie       = it-nota-fisc.serie      
                    AND   int_bem_pat_nf.nr-nota-fis = it-nota-fisc.nr-nota-fis
                    AND   int_bem_pat_nf.nr-seq-fat  = it-nota-fisc.nr-seq-fat 
                    AND   int_bem_pat_nf.it-codigo   = it-nota-fisc.it-codigo EXCLUSIVE-LOCK:
    
                    DELETE int_bem_pat_nf.
                END.
            END.
        END.
    END. 
    /* FIM exclus∆o das informaá‰es complementares do bem, caso a NF seja cancelada */
    ELSE DO:
        /* Caso cancele a nota de retorno, recria o vinculo do bem com a NF de origem */
        IF  CAN-FIND(FIRST natur-oper 
                     WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao 
                     AND   natur-oper.tp-oper-terc = 2 /* Retorno Benef */) THEN DO:

            FIND FIRST docum-est 
                WHERE docum-est.serie-docto  = b-nota-fiscal.serie        
                AND   docum-est.nro-docto    = b-nota-fiscal.nr-nota-fis  
                AND   docum-est.cod-emitente = b-nota-fiscal.cod-emitente 
                AND   docum-est.nat-operacao = b-nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
        
            IF  AVAIL docum-est THEN DO:                
                FOR EACH item-doc-est OF docum-est NO-LOCK.
                    
                    FIND FIRST b-nota-fiscal-2
                        WHERE b-nota-fiscal-2.cod-estabel = docum-est.cod-estabel
                        AND   b-nota-fiscal-2.serie       = item-doc-est.serie-comp
                        AND   b-nota-fiscal-2.nr-nota-fis = item-doc-est.nro-comp NO-LOCK NO-ERROR.

                    IF  AVAIL b-nota-fiscal-2 THEN DO:
                        FIND FIRST ped-fiscal NO-LOCK
                              WHERE ped-fiscal.cod-estabel   = b-nota-fiscal-2.cod-estabel         
                              AND   ped-fiscal.serie         = b-nota-fiscal-2.serie               
                              AND   ped-fiscal.nr-nota-fis   = b-nota-fiscal-2.nr-nota-fis  NO-ERROR.   
            
                        IF  AVAIL ped-fiscal THEN DO:
            
                            FOR EACH it-nota-fisc OF b-nota-fiscal-2 NO-LOCK:    
            
                                FIND FIRST it-ped-fiscal NO-LOCK
                                    WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                                    AND   it-ped-fiscal.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
            
                                IF  AVAIL it-ped-fiscal THEN DO:
            
                                    ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35). /*chave do bem (conta/bem/seq)*/
            
                                    IF  TRIM(c-chave-bem) <> "" AND NUM-ENTRIES(c-chave-bem,";") > 0 THEN DO:
                                        i-cod-bem = INT(ENTRY(2,c-chave-bem,";")) NO-ERROR.
                                        i-seq-bem = int(ENTRY(3,c-chave-bem,";")) NO-ERROR.
            
                                        FIND FIRST int_bem_pat_nf NO-LOCK
                                            WHERE int_bem_pat_nf.cod-estabel = it-nota-fisc.cod-estabel
                                            AND   int_bem_pat_nf.serie       = it-nota-fisc.serie      
                                            AND   int_bem_pat_nf.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                            AND   int_bem_pat_nf.nr-seq-fat  = it-nota-fisc.nr-seq-fat 
                                            AND   int_bem_pat_nf.it-codigo   = it-nota-fisc.it-codigo  NO-ERROR.
            
                                        IF  NOT AVAIL int_bem_pat_nf THEN DO:
                                            CREATE int_bem_pat_nf.
                                            ASSIGN int_bem_pat_nf.cod-estabel     = it-nota-fisc.cod-estabel
                                                   int_bem_pat_nf.serie           = it-nota-fisc.serie      
                                                   int_bem_pat_nf.nr-nota-fis     = it-nota-fisc.nr-nota-fis
                                                   int_bem_pat_nf.nr-seq-fat      = it-nota-fisc.nr-seq-fat 
                                                   int_bem_pat_nf.it-codigo       = it-nota-fisc.it-codigo  
                                                   int_bem_pat_nf.cod_cta_pat     = ENTRY(1,c-chave-bem,";")
                                                   int_bem_pat_nf.num_bem_pat     = i-cod-bem
                                                   int_bem_pat_nf.num_seq_bem_pat = i-seq-bem
                                                   int_bem_pat_nf.cod-emitente    = b-nota-fiscal-2.cod-emitente
                                                   int_bem_pat_nf.dt-emis-nota    = b-nota-fiscal-2.dt-emis-nota
                                                   int_bem_pat_nf.nat-operacao    = it-nota-fisc.nat-operacao
                                                   int_bem_pat_nf.dt-vigencia     = it-ped-fiscal.data-1
                                                   int_bem_pat_nf.int-1           = ped-fiscal.nat-oper
                                                   int_bem_pat_nf.val-icms        = it-nota-fisc.vl-icms-it
                                                   int_bem_pat_nf.class-fiscal    = it-nota-fisc.class-fiscal.
            
                                            IF  int_bem_pat_nf.class-fiscal = "" THEN
                                                ASSIGN int_bem_pat_nf.class-fiscal = '00000000'.
            
                                            IF  ped-fiscal.nat-oper = 14 
                                            OR  ped-fiscal.nat-oper = 15
                                            OR  ped-fiscal.nat-oper = 36
                                            OR  ped-fiscal.nat-oper = 37 THEN
                                                ASSIGN int_bem_pat_nf.ind-terceiro = "Conserto".
            
                                            IF  ped-fiscal.nat-oper = 34 THEN
                                                ASSIGN int_bem_pat_nf.ind-terceiro = "Comodato".
            
                                            IF  ped-fiscal.nat-oper = 17 
                                            OR  ped-fiscal.nat-oper = 19 THEN
                                                ASSIGN int_bem_pat_nf.ind-terceiro = "EmprÇstimo".
            
                                            IF  ped-fiscal.nat-oper = 22 
                                            OR  ped-fiscal.nat-oper = 24 THEN
                                                ASSIGN int_bem_pat_nf.ind-terceiro = "Locaá∆o".
            
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
        /* FIM caso cancele a nota de retorno, recria o vinculo do bem com a NF de origem */
    END.
END.

/* NOTA FISCAL DEVOLUÄ«O */
IF  AVAIL b-nota-fiscal THEN DO:

   FIND FIRST natur-oper NO-LOCK 
        WHERE natur-oper.nat-operacao = b-nota-fiscal.nat-operacao
          and natur-oper.tipo         = 1
          AND natur-oper.especie-doc  = 'NFD' NO-ERROR.
   IF AVAIL natur-oper THEN DO:

       FOR EACH devol-cli NO-LOCK
          WHERE devol-cli.cod-estabel  = b-nota-fiscal.cod-estabel 
            AND devol-cli.serie-docto  = b-nota-fiscal.serie       
            AND devol-cli.nro-docto    = b-nota-fiscal.nr-nota-fis:

           IF CAN-FIND(FIRST int-ped-item-astec
                       WHERE int-ped-item-astec.cod-estabel = devol-cli.cod-estabel
                         AND int-ped-item-astec.serie       = devol-cli.serie      
                         AND int-ped-item-astec.nr-nota-fis = devol-cli.nr-nota-fis) THEN DO:
        
               RUN esapi/esapi018.p PERSISTENT SET h-esapi018.
        
               RUN cancelarNotaFiscal IN h-esapi018 (INPUT devol-cli.cod-estabel,
                                                     INPUT devol-cli.serie,      
                                                     INPUT devol-cli.nr-nota-fis).
        
               DELETE PROCEDURE h-esapi018.
               ASSIGN h-esapi018 = ?.
           END.
       END.
   END.
END.

PROCEDURE envia-email:
   def input param p-nome-cli    as char no-undo.
   def input param p-nome-trans  as char no-undo.
   def input param p-nota        as CHAR no-undo.
   def input param p-cod-estabel as CHAR no-undo.
   def input param p-estado      as CHAR no-undo.

   DEF BUFFER bfusuar_mestre FOR usuar_mestre.
   DEFINE VARIABLE lErro        AS LOGICAL     NO-UNDO.
   DEF VAR c-email              AS CHAR        NO-UNDO.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    assign c-msg = " FavorˇembarcarˇaˇnotaˇfiscalˇabaixoˇnoˇmodalˇAêREO."  + CHR(13) + CHR(10) +
                   " "  + CHR(13) + CHR(10) +
                   " Notaˇfiscalˇnß: " +  p-nota + CHR(13) + CHR(10) +
                   " Cliente: " +  p-nome-cli + CHR(13) + CHR(10) +
                   " Estado de entrega: " +  p-estado + CHR(13) + CHR(10) +
                   " Transportadora: " +  p-nome-trans + CHR(13) + CHR(10) +
                   " "  + CHR(13) + CHR(10) +
                   " Muitoˇobrigado" + CHR(13) + CHR(10).
        
    RUN esp/es0018p.p (INPUT "pd4000", /* Nome do programa */
                       INPUT 9,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   
    assign  c-email = ''.
    for each tt-prog-ponto:
        IF p-cod-estabel = ENTRY(1, tt-prog-ponto.conteudo,";") THEN
            assign  c-email =  ENTRY(2, tt-prog-ponto.conteudo,";").
    END.

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = b-nota-fiscal.nr-pedcli
          AND ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli:

        FIND FIRST atendente NO-LOCK 
             WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

        IF  AVAIL atendente 
        AND atendente.email <> "" THEN DO:
            IF c-email = "" THEN
                ASSIGN c-email = atendente.email.
            ELSE 
                ASSIGN c-email = c-email + ", " + atendente.email.
        END.
    END.

    IF  c-email <> '' THEN DO:
        FIND FIRST usuar_mestre
            WHERE  usuar_mestre.cod_usuario = c-seg-usuario  NO-LOCK NO-ERROR.
        
        IF AVAIL usuar_mestre THEN DO:
            CREATE tt-mail.
            ASSIGN tt-mail.Remetente     = usuar_mestre.cod_e_mail_local
                   tt-mail.Destinatario  = c-email
                   tt-mail.Assunto       = "Geraá∆o de nota - Transp. AÇreo"
                   tt-mail.Mensagem      = c-msg .
        END.
    
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
        FOR EACH tt-mail:
    
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                   tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                   tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                   tt-envio2.formato           = "TEXTO".
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */
    
            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
    
            ASSIGN lErro = NO.
            FIND FIRST tt-erros NO-LOCK NO-ERROR.
            IF AVAIL tt-erros THEN DO:
               OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'envemail-transpor-nota.txt') APPEND.
                IF RETURN-VALUE = "NOK" THEN DO:
                    FOR EACH tt-erros:
                        PUT "Erro no envio de email rejeiá∆o Nota (wdi135)- Nota =  " FORMAT "x(80)"
                            b-old-nota-fiscal.nr-nota-fis " / " b-old-nota-fiscal.serie " / " b-old-nota-fiscal.cod-estabel SKIP.
                        PUT tt-erros.desc-erro SKIP.
                    END.
                    ASSIGN lErro = YES.
                END.
                OUTPUT CLOSE.
    
                IF lErro AND NOT SESSION:BATCH-MODE AND i-num-ped-exec-rpw = 0 THEN DO:
                    PUT "Erro no envio de email rejeiá∆o Nota (wdi135)- Nota =  " FORMAT "x(80)"
                        b-old-nota-fiscal.nr-nota-fis " / " b-old-nota-fiscal.serie " / " b-old-nota-fiscal.cod-estabel SKIP.
                    PUT tt-erros.desc-erro SKIP.
                END.
    
            END.
        END.
    
        IF VALID-HANDLE(h-utapi019) THEN
            DELETE PROCEDURE h-utapi019.
    END.
    ELSE DO:

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'envemail-transpor-nota.txt') APPEND.
            PUT "Erro no envio de email rejeiá∆o Nota (wdi135)- Nota =  " FORMAT "x(80)"
             b-old-nota-fiscal.nr-nota-fis " / " b-old-nota-fiscal.serie " / " b-old-nota-fiscal.cod-estabel SKIP.
            PUT "N∆o localizado e-mail do destinat†rio no programa ES0018 para o programa PD4000 ponto 9." SKIP.
         OUTPUT CLOSE.

    END.

    RETURN "OK":U.


END PROCEDURE.



PROCEDURE piEMail:

   DEFINE INPUT PARAM pEmailDestino AS CHAR NO-UNDO.

   DEF BUFFER bfusuar_mestre FOR usuar_mestre.
   DEFINE VARIABLE lErro AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE icont AS INT. 

    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    FOR FIRST param-global NO-LOCK:
    END.

    FIND FIRST usuar_mestre NO-LOCK 
         WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.

    IF AVAIL usuar_mestre THEN DO:
       FIND FIRST bfusuar_mestre NO-LOCK 
            WHERE bfusuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.

        IF AVAIL bfusuar_mestre THEN DO:
            CREATE tt-envio.
            ASSIGN tt-envio.Remetente = "grupo.tributario@intelbras.com.br" /*usuar_mestre.cod_e_mail_local*/
                   tt-envio.Destino   = bfusuar_mestre.cod_e_mail_local + ";" + pEmailDestino /*"grupo.fiscal@intelbras.com.br"*/
                   tt-envio.Assunto   = "Rejeiá∆o de nota Fiscal"
                   tt-envio.Mensagem  = c-msg .
        END.
    END.

    RUN pi-envia-email (INPUT tt-envio.Destino,
                        INPUT tt-envio.Remetente,
                        INPUT tt-envio.Assunto,
                        INPUT "TEXTO",
                        INPUT tt-envio.Mensagem).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-envia-email:
    DEFINE INPUT PARAM p-destino   AS CHAR.
    DEFINE INPUT PARAM p-remetente AS CHAR.
    DEFINE INPUT PARAM p-assutno   AS CHAR.
    DEFINE INPUT PARAM p-formato   AS CHAR.
    DEFINE INPUT PARAM p-mensagem  AS CHAR.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange          = param-global.log-1  
           tt-envio2.servidor          = param-global.serv-mail  
           tt-envio2.porta             = param-global.porta-mail 
           tt-envio2.destino           = p-destino        
           tt-envio2.remetente         = p-remetente      
           tt-envio2.assunto           = p-assutno
           tt-envio2.importancia       = 2
           tt-envio2.log-enviada       = YES
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.arq-anexo         = ?
           tt-envio2.formato           = p-formato. 

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = p-mensagem.

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF  AVAIL tt-erros THEN DO:
        OUTPUT TO erros-comerc.LOG APPEND.
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END. /* IF  AVAIL tt-erros THEN DO: */

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-trata-ecommerce:

    DEF INPUT PARAM pcod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM pserie       AS CHAR NO-UNDO.
    DEF INPUT PARAM pnr-nota-fis AS CHAR NO-UNDO.

    IF b-nota-fiscal.nr-pedcli <> "" THEN DO:
        FIND FIRST int-pedido-vtex NO-LOCK
             WHERE int-pedido-vtex.nr-pedcli = b-nota-fiscal.nr-pedcli NO-ERROR.
        IF AVAIL int-pedido-vtex THEN DO:
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "eswso0004", /* Nome do programa */
                               INPUT 1,        /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).   
            IF CAN-FIND(FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = int-pedido-vtex.marketplace) THEN
                RUN pi-integra-nf-ecommerce(INPUT pcod-estabel,
                                            INPUT pserie,
                                            INPUT pnr-nota-fis).
        END.
    END.

END PROCEDURE.

PROCEDURE pi-historico-recorrencia:
    FIND FIRST int-pedido-vtex NO-LOCK
         WHERE int-pedido-vtex.nr-pedcli = b-nota-fiscal.nr-pedcli NO-ERROR.
    IF AVAIL int-pedido-vtex THEN DO:
        IF int-pedido-vtex.marketplace = "GLX" THEN DO:
            RUN pi-grava-nf-glx.
        END.
    END.
END.

PROCEDURE pi-grava-nf-glx:

    DEF VAR i-seq AS INT NO-UNDO.

    IF NOT AVAIL b-nota-fiscal THEN NEXT.

    FIND FIRST int-recorrencia-notas EXCLUSIVE-LOCK
         WHERE int-recorrencia-notas.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")
           AND int-recorrencia-notas.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999") 
           AND int-recorrencia-notas.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")
           AND int-recorrencia-notas.nr-transacao   = "1"
           AND int-recorrencia-notas.nr-pedido      = INT(b-nota-fiscal.nr-pedcli) NO-ERROR.
    IF NOT AVAIL int-recorrencia-notas THEN
        CREATE int-recorrencia-notas. 

    ASSIGN int-recorrencia-notas.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")                      
           int-recorrencia-notas.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999") 
           int-recorrencia-notas.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")
           int-recorrencia-notas.nr-transacao   = "1"
           int-recorrencia-notas.nr-pedido      = INT(b-nota-fiscal.nr-pedcli)                      
           int-recorrencia-notas.cod-estabel    = b-nota-fiscal.cod-estabel
           int-recorrencia-notas.serie          = b-nota-fiscal.serie
           int-recorrencia-notas.nr-nota-fis    = b-nota-fiscal.nr-nota-fis
           int-recorrencia-notas.valor          = b-nota-fiscal.vl-tot-nota
           int-recorrencia-notas.dt-emis-nota   = b-nota-fiscal.dt-emis-nota.
                             
    FIND LAST int-recorrencia-historico NO-LOCK
         WHERE int-recorrencia-historico.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")
           AND int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999") 
           AND int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")
           AND int-recorrencia-historico.nr-transacao   = "1" NO-ERROR.
    IF AVAIL int-recorrencia-historico THEN
        ASSIGN i-seq = int-recorrencia-historico.nr-sequencia + 1.

    CREATE int-recorrencia-historico.                                                                                                                               
    ASSIGN int-recorrencia-historico.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")                      
           int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999") 
           int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")     
           int-recorrencia-historico.nr-transacao   = "1"                             
           int-recorrencia-historico.nr-sequencia   = i-seq
           int-recorrencia-historico.dt-evento      = TODAY                                                                                                         
           int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                      
           int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                 
           int-recorrencia-historico.desc-evento    = "NF gerada: " + b-nota-fiscal.cod-estabel + "-" + b-nota-fiscal.serie + "-" + b-nota-fiscal.nr-nota-fis.

    FOR FIRST int-recorrencia-contratos EXCLUSIVE-LOCK
        WHERE int-recorrencia-contratos.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")                       
          AND int-recorrencia-contratos.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999")  
          AND int-recorrencia-contratos.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")      
          AND int-recorrencia-contratos.nr-transacao   = "1":
        ASSIGN int-recorrencia-contratos.cod-sit-trans = "NF gerada".  
    END.

END PROCEDURE.
    
PROCEDURE pi-integra-nf-ecommerce:

    DEF INPUT PARAM pcod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM pserie       AS CHAR NO-UNDO.
    DEF INPUT PARAM pnr-nota-fis AS CHAR NO-UNDO.

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.
    DEFINE VARIABLE raw-param                                   AS RAW.

    ASSIGN i-cont-aux = i-cont-aux + 1.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "wso0003"
          AND ponto-programa.ponto         = 7,  
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor = conteudo-programa.conteudo.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */
 
    FOR EACH tt-param-esftp124:
        DELETE tt-param-esftp124.
    END.
    FOR EACH tt_param_segur:
        DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
        DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
        DELETE tt_ped_exec_param.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.
    FOR EACH tt_ped_exec_sel:
        DELETE tt_ped_exec_sel.
    END.

    create tt-param-esftp124.
    assign tt-param-esftp124.usuario         = "integra"
           tt-param-esftp124.destino         = 2
           tt-param-esftp124.data-exec       = TODAY 
           tt-param-esftp124.hora-exec       = TIME
           tt-param-esftp124.cod-estab-ini   = pcod-estabel
           tt-param-esftp124.cod-estab-fim   = pcod-estabel
           tt-param-esftp124.serie-ini       = pserie    
           tt-param-esftp124.serie-fim       = pserie    
           tt-param-esftp124.nr-nota-ini     = pnr-nota-fis  
           tt-param-esftp124.nr-nota-fim     = pnr-nota-fis  
           tt-param-esftp124.dt-emiss-ini    = TODAY - 5
           tt-param-esftp124.dt-emiss-fim    = TODAY 
           tt-param-esftp124.dia-atual       = NO.

    ASSIGN tt-param-esftp124.arquivo = "esftp124_UNIX.tmp".

    RAW-TRANSFER tt-param-esftp124 TO raw-param.
    
    ASSIGN p_cod_prog_dtsul_w    = "esftp124"           
           p_cod_prog_dtsul_rp   = "esp/ftp/esftp124rp.p"
           p_cod_release         = '2.00.00.000'                    
           p_cdn_estil_dwb       = 97                   
           p_arquivo             = "esftp124.tmp" 
           p_destino             = 2                    
           p_raw_param           = raw-param.  

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    create tt_ped_exec.
    assign tt_ped_exec.tta_num_seq                = i-cont-aux
           tt_ped_exec.tta_cod_usuario            = tt-param-esftp124.usuario
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = today
           tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(TIME,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = c-servidor
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-cont-aux
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/ftp/esftp124rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

    raw-transfer tt-param-esftp124       to tt_ped_exec_param.tta_raw_param_ped_exec.

    run btb/btb912zb.p (input-output table tt_param_segur,
                        input-output table tt_ped_exec,
                        input table tt_ped_exec_param,
                        input table tt_ped_exec_param_aux,
                        input table tt_ped_exec_sel).

END PROCEDURE.

PROCEDURE pi-integra-salesforce.
    
   /* empty temp-table tt-ped-venda.
    empty temp-table tt-ped-item.
    
    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = b-nota-fiscal.nr-pedcli
          AND ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli:

        create tt-ped-venda.
        buffer-copy ped-venda to tt-ped-venda.
        for each ped-item of ped-venda no-lock:
            create tt-ped-item.
            buffer-copy ped-item to tt-ped-item.
        end.
        run esp/wso/eswso0011.p(input table tt-ped-venda,
                                input table tt-ped-item).
    END.
    */

    run esp/wso/eswso0019.p(input b-nota-fiscal.cod-estabel,
                            INPUT b-nota-fiscal.serie,
                            input b-nota-fiscal.nr-nota-fis).

END PROCEDURE.


RETURN "OK".




