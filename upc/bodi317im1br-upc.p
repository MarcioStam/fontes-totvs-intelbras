/* ----------------------------------------------------------------------------
   Programa..: upc/boin317im1br-upc.p
   Data......: agosto/2009
   Autor.....: Anderson Cenci
   Objetivo..: Alterar o valor de substitui‡Æo tributaria
---------------------------------------------------------------------------- */


/* Include i-epc200.i: Defini‡Æo Temp-Table tt-epc */
{include/i-epc200.i1}
/* {utp/utapi019.i} */
{utp/ut-glob.i}                
{esp\es0018.i}

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.

DEFINE VARIABLE h-bodi538                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-aliq-icms-resol13      LIKE natur-oper.aliquota-icm NO-UNDO.
DEFINE VARIABLE de-total                  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-base-st                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-icms-st                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-icms-destacado      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-icmsub-it           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-cred-interno      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-sub-tri            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-bsubs-it            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE r-unid-feder              AS ROWID       NO-UNDO.
DEFINE VARIABLE r-natur-oper              AS ROWID       NO-UNDO.
DEFINE VARIABLE l-contrib-icms            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-simples                 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-natureza-emit           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-aliq-icms-nc            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-estado-dest             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-it-codigo               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-aliquota-icms-excessao AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-de-aliquota             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total-sub              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-aliq-interestadual     AS DEC NO-UNDO.    
DEFINE VARIABLE i                         AS INTEGER NO-UNDO.
DEFINE VARIABLE i-mensagem-ft0312         AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-per-des-icms-excessao  AS DECIMAL     NO-UNDO.


/* Vari vel atribuida no programa UPC "bodi317pr-epc" */
DEFINE NEW GLOBAL SHARED VARIABLE g-row-wt-docto-bodi317pr AS ROWID NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux AS LOGICAL     NO-UNDO.
DEF BUFFER b-tt-epc FOR tt-epc.
DEF BUFFER b-unid-feder-origem FOR unid-feder.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT  "bodi317im1br":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).


    
IF p-ind-event = 'beforeCalculaBaseICMSSubstituto' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "Rowid_wt-it-docto",
        first wt-it-docto NO-LOCK 
              WHERE ROWID(wt-it-docto) = TO-ROWID(tt-epc.val-parameter),
        first wt-it-imposto NO-LOCK
              WHERE wt-it-imposto.seq-wt-docto = wt-it-docto.seq-wt-docto
                AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto :
    END.

    IF AVAIL tt-epc AND
       AVAIL wt-it-docto THEN DO:
        FIND wt-docto 
             WHERE wt-docto.seq-wt-docto = wt-it-docto.seq-wt-docto NO-LOCK NO-ERROR.

        IF AVAIL wt-docto THEN DO:
            FIND estabelec
                 WHERE estabelec.cod-estabel = wt-docto.cod-estabel
                 NO-LOCK NO-ERROR.
            FIND emitente
                 WHERE emitente.cod-emitente = wt-docto.cod-emitente
                 NO-LOCK NO-ERROR. 
            FIND int-emitente
                 WHERE int-emitente.cod-emitente = wt-docto.cod-emitente
                 NO-LOCK NO-ERROR.
            FIND natur-oper
                 WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao
                 NO-LOCK NO-ERROR.

            IF  wt-docto.esp-docto     = 20 /* Devolu‡Æo a fornecedor */
            AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                for first item-uf
                    where item-uf.it-codigo       = wt-it-docto.it-codigo
                    and   item-uf.cod-estado-orig = wt-docto.estado
                    and   item-uf.estado          = estabelec.estado  no-lock:
                end.
            else if wt-docto.ind-tip-nota = 8 then
                for first item-uf
                    where item-uf.it-codigo       = wt-it-docto.it-codigo
                    and   item-uf.cod-estado-orig = emitente.estado
                    and   item-uf.estado          = estabelec.estado no-lock:
                end.
            else
                for first item-uf
                    where item-uf.it-codigo       = wt-it-docto.it-codigo
                    and   item-uf.cod-estado-orig = estabelec.estado
                    and   item-uf.estado          = wt-docto.estado no-lock:
                end.
          /* Localiza o relacionamento Item X Cliente */
            for first item-cli
                fields (item-cli.vl-precon  
                        item-cli.dec-1)
                where item-cli.it-codigo  = wt-it-docto.it-codigo
                and   item-cli.nome-abrev = wt-docto.nome-abrev no-lock:
            end.

            /* Localizacao dos dados da relacao item X UF do item do documento */
            IF  wt-docto.esp-docto     = 20 /* Devolu‡Æo a fornecedor */
            AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                for first int-unid-feder
                    where int-unid-feder.pais         = estabelec.pais
                    and   int-unid-feder.estado       = estabelec.estado  no-lock:
                end.
            else 
                for first int-unid-feder
                    where int-unid-feder.pais         = wt-docto.pais
                    and   int-unid-feder.estado       = wt-docto.estado  no-lock:
                end.
                        
            IF AVAIL emitente AND
               AVAIL estabelec AND
               AVAIL int-emitente THEN DO:

                IF  emitente.estado = "GO" AND /* Chamado IR77588 */
                    int-emitente.ind-forma-tributo = 3 AND
                    (AVAIL item-uf AND
                     item-uf.perc-red-sub = 0) THEN DO:
   
                    CREATE b-tt-epc.
                    ASSIGN b-tt-epc.cod-event     = "beforeCalculaBaseICMSSubstituto" 
                           b-tt-epc.cod-parameter = "de-perc-red-subs-trib-upc"
                           b-tt-epc.val-parameter = STRING(29.411).
                END.
                ELSE DO:
                    IF  AVAIL int-unid-feder 
                    AND int-unid-feder.simples-nao-red-base  /* cd0904*/
                    AND int-emitente.ind-forma-tributo = 3   /* Optante do Simples */ 
                    AND item-uf.perc-red-sub > 0 THEN DO:
    
                        FOR FIRST int-item-uf
                            WHERE int-item-uf.it-codigo            = item-uf.it-codigo      
                            AND   int-item-uf.cod-estado-orig      = item-uf.cod-estado-orig
                            AND   int-item-uf.estado               = item-uf.estado NO-LOCK:
    /*                         AND   int-item-uf.perc-credito-interno > 0  NO-LOCK: */
    
                            assign de-aliq-interestadual = 0.
    
                            IF  wt-docto.esp-docto     = 20 /* Devolu‡Æo a fornecedor */
                            AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                                FOR FIRST b-unid-feder-origem
                                    WHERE b-unid-feder-origem.pais   = wt-docto.pais  
                                    AND   b-unid-feder-origem.estado = wt-docto.estado NO-LOCK:
                                END.
                            ELSE 
                                FOR FIRST b-unid-feder-origem
                                    WHERE b-unid-feder-origem.pais   = estabelec.pais  
                                    AND   b-unid-feder-origem.estado = estabelec.estado  NO-LOCK:
                                END.
    
                            /* Busca a al¡qutoa de ICMS Interestadual */
                            IF  AVAIL b-unid-feder-origem THEN DO:
                                DO  i = 1 to 12:
                                    IF  b-unid-feder-origem.est-exc[i] = int-unid-feder.estado then
                                        ASSIGN de-aliq-interestadual = b-unid-feder-origem.perc-exc[i].
    
                                end.
                                IF  de-aliq-interestadual = 0 THEN
                                    ASSIGN de-aliq-interestadual = b-unid-feder-origem.per-icms-ext.
                            END.
                            if  avail item-cli
                            and item-cli.dec-1 > 0 then 
                                ASSIGN de-per-sub-tri = item-cli.dec-1.
                            ELSE
                                ASSIGN de-per-sub-tri = item-uf.per-sub-tri.

                            /* Calcula % de substitui‡Æo tribut ria */
                            ASSIGN de-per-sub-tri = ((((100 + de-per-sub-tri) / 100) * (1 - (de-aliq-interestadual / 100))) / (1 - (item-uf.dec-1 / 100)) - 1) * 100
                                   de-per-sub-tri = TRUNC(de-per-sub-tri,2).
    
                            CREATE b-tt-epc.
                            ASSIGN b-tt-epc.cod-event     = "beforeCalculaBaseICMSSubstituto" 
                                   b-tt-epc.cod-parameter = "de-perc-subs-trib-upc"
                                   b-tt-epc.val-parameter = STRING(de-per-sub-tri).
    
                            CREATE b-tt-epc.
                            ASSIGN b-tt-epc.cod-event     = "beforeCalculaBaseICMSSubstituto" 
                                   b-tt-epc.cod-parameter = "de-perc-red-subs-trib-upc"
                                   b-tt-epc.val-parameter = STRING(0).
                        END.
                    END.
                    ELSE DO:
                        IF int-emitente.ind-forma-tributo = 3 OR
                           ( AVAIL natur-oper AND
                             natur-oper.consum-final = YES ) THEN DO:
        
                            IF AVAIL item-uf THEN DO:
                                for first int-item-uf
                                    where int-item-uf.it-codigo       = item-uf.it-codigo      
                                    and   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                                    and   int-item-uf.estado          = item-uf.estado          NO-LOCK:
                                end.
        
                                IF AVAIL natur-oper AND
                                   natur-oper.consum-final = YES AND
                                   emitente.contrib-icms   = YES AND
                                   AVAIL int-item-uf             AND 
                                   int-item-uf.perc-credito-interno > 0 THEN DO:
                                    /* NÆo Fazer nada */
                                END.
                                ELSE  
                                   IF AVAIL INT-unid-feder and
                                      int-unid-feder.perc-red-subst-simples > 0 AND
                                      item-uf.dec-1 >= 17 THEN DO: /* Chamado IR 68336 */ 

                                       if  avail item-cli
                                       and item-cli.dec-1 > 0 then 
                                           ASSIGN de-per-sub-tri = item-cli.dec-1.
                                       ELSE
                                           ASSIGN de-per-sub-tri = item-uf.per-sub-tri.

                                       ASSIGN de-per-sub-tri    = (de-per-sub-tri * int-unid-feder.perc-red-subst-simples / 100).
        
                                       CREATE b-tt-epc.
                                       ASSIGN b-tt-epc.cod-event     = "beforeCalculaBaseICMSSubstituto" 
                                              b-tt-epc.cod-parameter = "de-perc-subs-trib-upc"
                                              b-tt-epc.val-parameter = STRING(de-per-sub-tri).
                                   END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
 


IF p-ind-event = 'afterCalculaICMSSubstituto' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
                  
    /* Rotina utilizada para calcular redu‡Æo icms substituto */
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "Rowid_wt-it-docto":

        FIND wt-it-docto NO-LOCK 
             WHERE ROWID(wt-it-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF AVAIL wt-it-docto THEN DO:
            FIND wt-it-imposto
                 WHERE wt-it-imposto.seq-wt-docto = wt-it-docto.seq-wt-docto
                   AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                 NO-LOCK NO-ERROR.
            FIND wt-docto
                 WHERE wt-docto.seq-wt-docto = wt-it-imposto.seq-wt-docto
                 NO-LOCK NO-ERROR.
            FIND estabelec
                 WHERE estabelec.cod-estabel = wt-docto.cod-estabel
                 NO-LOCK NO-ERROR.

            FIND emitente
                 WHERE emitente.cod-emitente = wt-docto.cod-emitente
                 NO-LOCK NO-ERROR. 
            FIND int-emitente
                 WHERE int-emitente.cod-emitente = wt-docto.cod-emitente
                 NO-LOCK NO-ERROR.
            FIND natur-oper
                 WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao
                 NO-LOCK NO-ERROR.
            FOR FIRST b-tt-epc
                WHERE b-tt-epc.cod-event     = p-ind-event
                  AND b-tt-epc.cod-parameter = "Rowid_item-uf":
            END.
            FIND item-uf NO-LOCK 
                 WHERE ROWID(item-uf) = TO-ROWID(b-tt-epc.val-parameter) NO-ERROR.

            for first int-item-uf
                where int-item-uf.it-codigo       = item-uf.it-codigo      
                and   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                and   int-item-uf.estado          = item-uf.estado          NO-LOCK:
            end.

            /* Localizacao dos dados da relacao item X UF do item do documento */
            IF  wt-docto.esp-docto     = 20 /* Devolu‡Æo a fornecedor */
            AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                for first int-unid-feder
                    where int-unid-feder.pais         = estabelec.pais
                    and   int-unid-feder.estado       = estabelec.estado  no-lock:
                end.
            else 
                for first int-unid-feder
                    where int-unid-feder.pais         = wt-docto.pais
                    and   int-unid-feder.estado       = wt-docto.estado  no-lock:
                end.
          /* Localiza o relacionamento Item X Cliente */
            for first item-cli
                fields (item-cli.vl-precon  
                        item-cli.dec-1)
                where item-cli.it-codigo  = wt-it-docto.it-codigo
                and   item-cli.nome-abrev = wt-docto.nome-abrev no-lock:
            end.
            If AVAIL item-uf and
               AVAIL natur-oper AND
               natur-oper.consum-final = YES  AND
               emitente.contrib-icms   = YES  AND
               AVAIL int-item-uf              AND
               int-item-uf.perc-credito-interno > 0 THEN DO:
                /* Nao fazer Nada */
            END.
            ELSE /* Reu‡Æo de base (dc0904) para optantes do Simples em SP */
            IF  AVAIL int-item-uf
            AND int-item-uf.perc-credito-interno > 0  
            AND AVAIL int-unid-feder AND int-unid-feder.simples-nao-red-base  /* cd0904*/
            AND int-emitente.ind-forma-tributo = 3 THEN DO:
                /* Nao fazer Nada */
            END.
            ELSE DO:
                IF AVAIL item-uf  THEN DO:
                    FIND int-item-uf NO-LOCK
                         WHERE int-item-uf.estado          = item-uf.estado
                           AND int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                           AND int-item-uf.it-codigo       = item-uf.it-codigo NO-ERROR.

                    IF AVAIL INT-item-uf AND
                       int-item-uf.perc-credito-interno > 0 THEN DO:

                        ASSIGN de-perc-cred-interno = int-item-uf.perc-credito-interno.

                        ASSIGN de-total             = wt-it-docto.vl-merc-liq + wt-it-imposto.vl-ipi-it.
                        /* Localizacao dos dados da relacao item X UF do item do documento */
                        IF  wt-docto.esp-docto     = 20 /* Devolu‡Æo a fornecedor */
                        AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                            for first int-unid-feder
                                where int-unid-feder.pais         = estabelec.pais
                                and   int-unid-feder.estado       = estabelec.estado  no-lock:
                            end.
                        else
                            for first int-unid-feder
                                where int-unid-feder.pais         = wt-docto.pais
                                and   int-unid-feder.estado       = wt-docto.estado  no-lock:
                            end.

                        if  avail item-cli
                        and item-cli.dec-1 > 0 then 
                            ASSIGN de-per-sub-tri = item-cli.dec-1.
                        ELSE
                            ASSIGN de-per-sub-tri = item-uf.per-sub-tri.

                        IF AVAIL int-unid-feder                      AND
                           int-unid-feder.perc-red-subst-simples > 0 and
                           AVAIL int-emitente                        AND
                           item-uf.dec-1 >= 17                       AND /* Chamado IR 68336 */ 
                           int-emitente.ind-forma-tributo = 3        THEN
                           ASSIGN de-per-sub-tri    = (de-per-sub-tri * int-unid-feder.perc-red-subst-simples / 100).
                        ELSE
                           ASSIGN de-per-sub-tri    = de-per-sub-tri.

                        IF item-uf.perc-red-sub > 0 THEN DO:
                            ASSIGN de-total-sub  =  de-total * (1 + de-per-sub-tri / 100 )
                                   de-base-st    =  de-total-sub - (de-total-sub * item-uf.perc-red-sub / 100).
                        END.
                        ELSE
                           ASSIGN de-base-st     = de-total * (1 + de-per-sub-tri / 100 ).

                        ASSIGN de-icms-st           = de-base-st * item-uf.dec-1 / 100
                               de-vl-icms-destacado = wt-it-docto.vl-merc-liq * de-perc-cred-interno / 100
                               de-vl-icmsub-it      = de-icms-st - de-vl-icms-destacado .

                        CREATE b-tt-epc.
                        ASSIGN b-tt-epc.cod-event     = "afterCalculaICMSSubstituto"
                               b-tt-epc.cod-parameter = "Value_vl-icmsub-it"
                               b-tt-epc.val-parameter = STRING(de-vl-icmsub-it).

                        CREATE b-tt-epc.
                        ASSIGN b-tt-epc.cod-event     = "afterCalculaICMSSubstituto"
                               b-tt-epc.cod-parameter = "Value_vl-bsubs-it"
                               b-tt-epc.val-parameter = STRING(de-base-st).
                    END.
                END.
            END.
        END.
    END.
END.



IF  p-ind-event = "Define-aliquota-ICMS" THEN DO:
    FOR EACH  tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event:
        CASE tt-epc.cod-parameter:
            WHEN "rowid-unid-feder" THEN DO:
                ASSIGN r-unid-feder = TO-ROWID(tt-epc.val-parameter).
            END.
            WHEN "rowid-natur" THEN DO:
                ASSIGN r-natur-oper = TO-ROWID(tt-epc.val-parameter).
            END.
            WHEN "var-l-contrib-icms" THEN DO:
                ASSIGN l-contrib-icms = LOGICAL(tt-epc.val-parameter).
            END.
            WHEN "var-i-natur-emit" THEN DO:
                ASSIGN i-natureza-emit = INT(tt-epc.val-parameter).
            END.
            WHEN "var-c-estado-dest" THEN DO:
                ASSIGN c-estado-dest = tt-epc.val-parameter.
            END.
            WHEN "var-de-aliq-icms-excessao" THEN DO:
                ASSIGN de-aliquota-icms-excessao = DECIMAL(tt-epc.val-parameter).
            END.
            WHEN "var-aliq-icms-nc" THEN DO:
                ASSIGN i-aliq-icms-nc = INTEGER(tt-epc.val-parameter).
            END.
            WHEN "it-codigo" THEN DO:
                ASSIGN c-it-codigo = tt-epc.val-parameter.
            END.
        END CASE.
    END.

    FIND FIRST unid-feder NO-LOCK
        WHERE ROWID(unid-feder) = r-unid-feder NO-ERROR.
    IF  NOT AVAIL unid-feder THEN
        RETURN "NOK":U.

    FIND FIRST natur-oper NO-LOCK
        WHERE ROWID(natur-oper) = r-natur-oper NO-ERROR.
    IF  NOT AVAIL natur-oper THEN
        RETURN "NOK":U.

    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = c-it-codigo NO-ERROR.
    IF  NOT AVAIL item THEN
        RETURN "NOK":U.

    ASSIGN l-simples = NO.

    FIND emitente NO-LOCK
         WHERE emitente.cod-emitente = g-cod-emitente-bodi317im1br NO-ERROR.
    IF AVAIL emitente THEN
       FIND FIRST int-emitente NO-LOCK
            WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF AVAIL INT-EMITENTE THEN
       ASSIGN l-simples = IF (AVAIL int-emitente AND int-emitente.ind-forma-tributo = 3) THEN YES ELSE NO.
    
    FOR FIRST para-fat NO-LOCK: END.

    ASSIGN p-de-aliquota = 0.
    IF  l-contrib-icms = YES THEN DO:   /* CONTRIBUINTE */

        IF  l-simples        = YES /** Simples, de SC para SC **/
        AND c-estado-dest    = 'SC'
        AND unid-feder.estad = 'SC' THEN DO:
        
            FIND FIRST item-uf 
                 WHERE item-uf.it-codigo       = item.it-codigo
                   AND item-uf.cod-estado-orig = "sc"
                   AND item-uf.estado          = "sc" NO-LOCK NO-ERROR.
           /** QUANDO POSSUI SUBST. TRIBUTARIA */
           IF AVAIL item-uf THEN DO:
                FIND FIRST int-icms-it-uf 
                     WHERE int-icms-it-uf.estado    = unid-feder.estado
                       AND int-icms-it-uf.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL INT-icms-it-uf THEN DO:

                    FIND FIRST tt-prog-ponto NO-LOCK
                         WHERE tt-prog-ponto.conteudo = string(int-icms-it-uf.cod-mensagem) NO-ERROR. //mensagem 79 e 829
                    /*  Chamado 14691 - SE ESTIVER COM MENSAGEM 79 */
                    IF AVAIL tt-prog-ponto AND natur-oper.consum-final = NO THEN DO: 
                        /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao   ft0312    */
                        FOR FIRST icms-it-uf
                            WHERE icms-it-uf.it-codigo    = item.it-codigo
                            AND   icms-it-uf.estado       = unid-feder.estado
                            AND   icms-it-uf.aliquota-icm > 0 NO-LOCK: END.
                        IF  AVAIL icms-it-uf THEN
                            ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
       
                    END. 
                END. /* IF AVAIL INT-icms-it-uf THEN DO: */
           END.
           ELSE DO:
                /* QUANDO NÇO POSSUI SUBST. TRIBUTµRIA */
                
                FIND FIRST int-icms-it-uf 
                     WHERE int-icms-it-uf.estado    = unid-feder.estado
                       AND int-icms-it-uf.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL INT-icms-it-uf /*AND int-icms-it-uf.cod-mensagem = 79*/  THEN DO: /* VERIFICA MSG 79 */

                    FIND FIRST tt-prog-ponto NO-LOCK
                         WHERE tt-prog-ponto.conteudo = string(int-icms-it-uf.cod-mensagem) NO-ERROR. //mensagem 79 e 829
                    IF AVAIL tt-prog-ponto THEN DO:
                       /*
                        /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao   ft0312    */ 
                       FOR FIRST icms-it-uf
                           WHERE icms-it-uf.it-codigo    = item.it-codigo
                           AND   icms-it-uf.estado       = unid-feder.estado
                           AND   icms-it-uf.aliquota-icm > 0 NO-LOCK: END.
                       IF  AVAIL icms-it-uf THEN
                           ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm. */
                    
                        IF  AVAIL natur-oper  THEN 
                            ASSIGN p-de-aliquota = natur-oper.aliquota-icm.
                    END.
                        
                END.
            
           END.

            IF natur-oper.consum-final = YES THEN DO:
               IF  AVAIL natur-oper  THEN DO:
                   ASSIGN p-de-aliquota = natur-oper.aliquota-icm.
               END.
      
            END.
        END. 



        IF  p-de-aliquota = 0 THEN DO:
            RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
            RUN pi-buscaAliquotaICMS-Resolucao13 IN h-bodi538 (INPUT  l-contrib-icms,  /*Contribuinte ICMS*/
                                                               INPUT  item.it-codigo,
                                                               INPUT  unid-feder.estado,
                                                               INPUT  c-estado-dest,
                                                               OUTPUT de-aliq-icms-resol13).
            IF  de-aliq-icms-resol13 > 0 THEN
                ASSIGN p-de-aliquota = de-aliq-icms-resol13.
                
            IF  VALID-HANDLE(h-bodi538) THEN DO:
                DELETE PROCEDURE h-bodi538.
                ASSIGN h-bodi538 = ?.
            END.


        END.
    END.
    
    IF  (    l-contrib-icms                      /* ((Emitente contribuinte  E    */
         AND NOT l-simples                        /* Se nao for do simples         */
         AND c-estado-dest = unid-feder.estado)   /*   Nota interna) OU            */
         THEN DO:          /*  Emitente nao contribuinte)   */

        IF  p-de-aliquota = 0 THEN DO:
            /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao       */
            FOR FIRST icms-it-uf
                WHERE icms-it-uf.it-codigo    = item.it-codigo
                AND   icms-it-uf.estado       = unid-feder.estado
                AND   icms-it-uf.aliquota-icm > 0 NO-LOCK: END.
            IF  AVAIL icms-it-uf THEN DO:
                IF  l-contrib-icms THEN DO:
                    ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
                END.
            END.
        END.
    END.
        
    IF (p-de-aliquota = 0 AND
        (l-simples                              AND
         (ITEM.codigo-orig                  = 1 OR
          ITEM.codigo-orig                  = 2 OR
          ITEM.codigo-orig                  = 3 OR
          ITEM.codigo-orig                  = 6   ) AND
         c-estado-dest            = "SC"            AND
         unid-feder.estado        = c-estado-dest)) /* RECALCULA NOVAMENTE AQUI PORQUE DEVERA DESCONSIDERAR QUANDO ORIGEM = 1 E SC */
                                                    /* RECALCULA NOVAMENTE AQUI PORQUE NO PONTO Define-aliquota-ICMS NAO TEMOS O CODIGO DE ORIGEM DO ITEM */
    THEN DO:
        IF  i-natureza-emit <> 3     /* Natureza do emitente diferente de Estrangeiro */
        AND l-contrib-icms  THEN DO: /* Emitente contribuinte de ICMS                 */
                IF  c-estado-dest = unid-feder.estado THEN DO:  /* Aliquota interna */
                    ASSIGN p-de-aliquota = unid-feder.per-icms-int.
                END.
                ELSE DO: /* Aliquota interestadual */
                    ASSIGN p-de-aliquota = IF  de-aliquota-icms-excessao > 0 /* Se houver al¡quota exce‡Æo */ THEN
                                               de-aliquota-icms-excessao     /* utiliza al¡quota exce‡Æo   */
                                           ELSE
                                               unid-feder.per-icms-ext. /* Al¡quota Externa */
                END.
        
        END.

/*         /* Caso for zero, utilizara a aliquota da natureza de operacao */            */
/*         IF  p-de-aliquota = 0 THEN DO:                                               */
/*             ASSIGN p-de-aliquota = IF AVAIL natur-oper THEN natur-oper.aliquota-icm. */
/*                                                                                      */
/*         END.                                                                         */
    END.

    /* Retorna para o BO o valor da aliquota encontrada */
    FIND FIRST tt-epc EXCLUSIVE-LOCK
        WHERE  tt-epc.cod-event     = p-ind-event
        AND    tt-epc.cod-parameter = "var-de-aliquota" NO-ERROR.
    IF  NOT AVAIL tt-epc THEN DO:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = p-ind-event
               tt-epc.cod-parameter = "var-de-aliquota".
    END.

    
    IF p-de-aliquota <> 0 THEN DO:
        ASSIGN tt-epc.val-parameter = STRING(p-de-aliquota).
    END.
    
END.



if p-ind-event = "beforecalculaImpostosBrasil" then do:
    /* VER BODI317im1br.m36 */
    
    for first tt-epc where
        tt-epc.cod-event = p-ind-event and
        tt-epc.cod-parameter = "Seq_WtDocto":
        find wt-docto where
            wt-docto.seq-wt-docto = int(tt-epc.val-parameter) no-lock no-error.
        if avail wt-docto then do:

            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-ERROR.
            FIND FIRST int-emitente NO-LOCK
                WHERE  int-emitente.cod-emitente = wt-docto.cod-emitente NO-ERROR.
            IF AVAIL INT-EMITENTE THEN
               ASSIGN l-simples = IF (AVAIL int-emitente AND int-emitente.ind-forma-tributo = 3) THEN YES ELSE NO.

            FIND estabelec
                 WHERE estabelec.cod-estabel = wt-docto.cod-estabel NO-LOCK NO-ERROR.

            run localizaUnidFederOrigem(input  estabelec.pais,
                                        input  estabelec.estado,
                                        input  wt-docto.estado,
                                        output l-proc-ok-aux).

            for first b-unid-feder-origem
                where b-unid-feder-origem.pais   = estabelec.pais
                and   b-unid-feder-origem.estado = estabelec.estado no-lock:
            end.

            FOR FIRST para-fat NO-LOCK: END.
            
            for each wt-it-docto where
                wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto no-lock:

                find wt-it-imposto where
                    wt-it-imposto.seq-wt-docto    = wt-it-docto.seq-wt-docto    and
                    wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto exclusive-lock no-error.
                if avail wt-it-imposto then do:
                    FIND ITEM
                        WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-LOCK NO-ERROR.

                    assign p-de-aliquota = 0.


                    IF  (    l-contrib-icms                      /* ((Emitente contribuinte  E    */
                         AND NOT l-simples                        /* Se nao for do simples         */
                         AND c-estado-dest = unid-feder.estado)   /*   Nota interna) OU            */
                         THEN DO:          /*  Emitente nao contribuinte)   */
                
                        IF  p-de-aliquota = 0 THEN DO:
                            /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao       */
                            FOR FIRST icms-it-uf
                                WHERE icms-it-uf.it-codigo    = item.it-codigo
                                AND   icms-it-uf.estado       = unid-feder.estado
                                AND   icms-it-uf.aliquota-icm > 0 NO-LOCK: END.
                            IF  AVAIL icms-it-uf THEN DO:
                                IF  l-contrib-icms THEN DO:
                                    ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
                                END.
                            END.
                        END.
                    END.


                    IF  emitente.contrib-icm = YES THEN DO:
                        RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
                        
                        IF  AVAIL wt-docto
                        AND AVAIL wt-it-docto THEN
                            RUN pi-enviaRowidWtItDocto       IN h-bodi538 (INPUT  ROWID(wt-docto),
                                                                           INPUT  ROWID(wt-it-docto)).
                
                        RUN pi-buscaAliquotaICMS-Resolucao13 IN h-bodi538 (INPUT  emitente.contrib-icm,  /*Contribuinte ICMS*/
                                                                           INPUT  wt-it-docto.it-codigo,
                                                                           INPUT  b-unid-feder-origem.estado,
                                                                           INPUT  wt-docto.estado,
                                                                           OUTPUT de-aliq-icms-resol13).
                
                        IF  de-aliq-icms-resol13 > 0 THEN
                            ASSIGN p-de-aliquota = de-aliq-icms-resol13.
                            
                        IF  VALID-HANDLE(h-bodi538) THEN DO:
                            DELETE PROCEDURE h-bodi538.
                            ASSIGN h-bodi538 = ?.
                        END.
                    END.
                    
                    IF (     emitente.contrib-icm                             /* Emitente contribuinte        */
                             and wt-docto.estado = b-unid-feder-origem.estado)  /* Nota interna                 */
                          then do:                     /* Emitente nao contribuinte    */
                
                        IF p-de-aliquota = 0 THEN DO:
                            FIND FIRST natur-oper NO-LOCK
                                 WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-ERROR.

                              FIND FIRST item-uf 
                                 WHERE item-uf.it-codigo = item.it-codigo
                                  AND item-uf.cod-estado-orig = "sc"
                                  AND item-uf.estado          = "sc" NO-LOCK NO-ERROR.
                            IF l-simples = NO OR 
                              (l-simples = YES AND AVAIL item-uf AND natur-oper.consum-final = NO) THEN DO:
                                /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao       */
                                for first icms-it-uf
                                    where icms-it-uf.it-codigo    = wt-it-docto.it-codigo
                                    and   icms-it-uf.estado       = b-unid-feder-origem.estado
                                    and   icms-it-uf.aliquota-icm > 0 no-lock:
                                end.
                                if avail icms-it-uf then do:
                                    if emitente.contrib-icm THEN DO:
                                        assign p-de-aliquota = icms-it-uf.aliquota-icm.
                                    END.
                                END.
                             END.
                             FIND FIRST int-icms-it-uf 
                                  WHERE int-icms-it-uf.estado    = b-unid-feder-origem.estado
                                    AND int-icms-it-uf.it-codigo = wt-it-docto.it-codigo NO-LOCK NO-ERROR.

                             IF NOT AVAIL item-uf THEN DO:
                                 IF  AVAIL int-icms-it-uf /*AND int-icms-it-uf.cod-mensagem = 79*/  THEN DO: 
                                    /* Verifica aliquota diferenciada de ICMS a nivel Item/Unidade Federacao       */

                                   FIND FIRST tt-prog-ponto NO-LOCK
                                        WHERE tt-prog-ponto.conteudo = string(int-icms-it-uf.cod-mensagem) NO-ERROR. //mensagem 79 e 829
                                   IF AVAIL tt-prog-ponto THEN DO:
                                       FIND FIRST icms-it-uf
                                            WHERE icms-it-uf.it-codigo    = wt-it-docto.it-codigo
                                              AND icms-it-uf.estado       = b-unid-feder-origem.estado NO-LOCK NO-ERROR.
                                            
                                        IF  AVAIL icms-it-uf THEN DO:
                                            ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
                                        END.
                                   END.
                                 END.
                             END.
                        END.  
                    END.
                    
                    IF AVAIL wt-docto            AND
                       (p-de-aliquota = 0 OR
                        (l-simples                                AND
                         (ITEM.codigo-orig                  = 1   OR
                          /*ITEM.codigo-orig                  = 2   OR
                          ITEM.codigo-orig                  = 3   OR */
                          ITEM.codigo-orig                  = 6)  AND
                         wt-docto.estado                   = "SC" AND
                         b-unid-feder-origem.estado        = wt-docto.estado)) /* ******************* RECALCULA NOVAMENTE AQUI PORQUE DEVERA DESCONSIDERAR QUANDO ORIGEM = 1 E SC */
                                                                               /* RECALCULA NOVAMENTE AQUI PORQUE NO PONTO Define-aliquota-ICMS NAO TEMOS O CODIGO DE ORIGEM DO ITEM */
                                                                               THEN DO:
                        IF  emitente.natureza       <> 3     /* Natureza do emitente diferente de Estrangeiro */
                        AND emitente.contrib-icms   THEN DO: /* Emitente contribuinte de ICMS                 */
                            IF  wt-docto.estado = b-unid-feder-origem.estado THEN DO: /* Aliquota interna           */

                                IF can-find(FIRST item-uf WHERE item-uf.it-codigo = item.it-codigo
                                                            AND item-uf.cod-estado-orig = b-unid-feder-origem.estado
                                                            AND item-uf.estado          = wt-docto.estado) THEN DO:

                                   IF ( AVAIL item-uf AND natur-oper.consum-final = NO) THEN DO:
                                     FOR FIRST icms-it-uf
                                         WHERE icms-it-uf.it-codigo    = item.it-codigo
                                         AND   icms-it-uf.estado       = b-unid-feder-origem.estado
                                         AND   icms-it-uf.aliquota-icm > 0 NO-LOCK: END.
                                     IF  AVAIL icms-it-uf THEN DO:
                                         ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
                                     END.                         
                                     ELSE
                                         ASSIGN p-de-aliquota                 = b-unid-feder-origem.per-icms-int.
                                   END.
                                 END.
                                 ELSE ASSIGN p-de-aliquota                 = b-unid-feder-origem.per-icms-int.
                            END.
                            ELSE DO: /* Aliquota interestadual */

                                FIND natur-oper
                                     WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-LOCK NO-ERROR.
                                IF AVAIL natur-oper THEN DO:
                                    IF natur-oper.especie-doc = 'NFD' THEN NEXT.
                                    ASSIGN  p-de-aliquota                = 
                                                                           IF  de-aliquota-icms-excessao > 0 /* Se houver al¡quota exce‡Æo */
                                                                           THEN de-aliquota-icms-excessao    /* utiliza al¡quota exce‡Æo   */
                                                                           ELSE b-unid-feder-origem.per-icms-ext.     /* Al¡quota Externa           */
                                END. /* IF AVAIL natur-oper THEN DO: */

                            END.
                        END.
                      
                
/*                         /* Caso for zero, utilizara a aliquota da natureza de operacao */ */
/*                         IF  p-de-aliquota = 0 THEN DO:                                    */
/*                             ASSIGN  p-de-aliquota = natur-oper.aliquota-icm.              */
/*                         END.                                                              */

                    END.
                    FIND natur-oper
                         WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-LOCK NO-ERROR.


                    IF (     emitente.contrib-icm                             /* Emitente contribuinte        */
                             and wt-docto.estado = b-unid-feder-origem.estado)  /* Nota interna                 */
                             AND NOT l-simples
                          then do:     /* Emitente nao contribuinte    */                       
                        /* NAO FAZ NDA */
                    END.
                    ELSE DO:
                        IF natur-oper.consum-final = YES THEN DO:
                           IF  AVAIL natur-oper THEN DO:
                             /* ASSIGN p-de-aliquota = natur-oper.aliquota-icm. */ /*COMENTADO DEVIDO A ATUALIZACAO DO TOTVS PARA A VERSAO 10.1.28.2*/
                      
                           END.
                        END.
                    END.
                    IF p-de-aliquota <> 0 THEN ASSIGN wt-it-imposto.aliquota-icm = p-de-aliquota.

                END.

                RELEASE wt-it-imposto.
            END.
        END.
    END.
END.


RETURN "OK".



PROCEDURE localizaUnidFederOrigem:
    /* Defini»’o dos par³metros de Entrada/Sa­da */
    def input  param p-c-pais            like unid-feder.pais   no-undo.
    def input  param p-c-estado          like unid-feder.estado no-undo.
    def input  param p-c-estado-destino  like unid-feder.estado no-undo.
    def output param p-l-procedimento-ok as log                 no-undo.

    /* Defini»’o de variÿveis locais */
    def var i-cont as int no-undo.

    /* Localiza unidade de federa»’o origem e disponibiliza somente os campos necessÿrios */
    for first b-unid-feder-origem
        fields (b-unid-feder-origem.possui-subst-trib 
                b-unid-feder-origem.int-2
                b-unid-feder-origem.estado
                b-unid-feder-origem.per-icms-int
                b-unid-feder-origem.est-exc
                b-unid-feder-origem.perc-exc
                b-unid-feder-origem.per-icms-ext
                b-unid-feder-origem.desc-icms
                b-unid-feder-origem.nr-tb-pauta
                b-unid-feder-origem.pais)
        where b-unid-feder-origem.pais   = p-c-pais
        and   b-unid-feder-origem.estado = p-c-estado no-lock:
    end.

    /*------------------------------------------------------------------------------------+
     | Buscar a aliquota de ICMS e desconto de ICMS nas  excess„es  agora  e  para evitar |
     | processamento desnecessÿrio quando serÿ determinada a aliquota o desconto de ICMS. |
     +------------------------------------------------------------------------------------+*/
    assign de-per-des-icms-excessao  = 0
           de-aliquota-icms-excessao = 0.

    if  avail b-unid-feder-origem then do  i-cont = 1 to 12:
        if  b-unid-feder-origem.est-exc[i-cont] = p-c-estado-destino then
            assign de-aliquota-icms-excessao = b-unid-feder-origem.perc-exc[i-cont]
                   de-per-des-icms-excessao  = b-unid-feder-origem.perc-exc[i-cont + 13].
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.    
