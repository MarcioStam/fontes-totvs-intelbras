/*********************************************************************************
** Programa: esp/inp/esin003.p
** Vers’o..: 1.00
** Data....: 21/02/2011
** Autor...: Estevan Kruger - Exponencial TI
** Obs.....: API para processar e gravar as informa‡äes do FISCOSoft
*********************************************************************************/

{esp/inp/esinp002.i} /* Defini»’o das temp-table do FISCOSoft */

/*--- Defini»’o das Variÿveis ---*/
DEFINE VARIABLE c-ncm               AS CHAR FORMA "x(8)" NO-UNDO.
DEFINE VARIABLE i-ponteiro          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont              AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-ncm-ini           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ncm-fim           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE dt-baixa            AS DATE        NO-UNDO.
DEFINE VARIABLE dt-limite-historico AS DATE        NO-UNDO.
DEFINE VARIABLE dt-vigencia-de-aux  AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE dt-vigencia-ate-aux AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE c-mensagem-html     AS CHAR        NO-UNDO.

DEFINE VARIABLE c-msg-ncm           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-ncm           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-acordos       AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-acordos       AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-acordos-ptr   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-acordos-ptr   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-defesa        AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-defesa        AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-ex-tarifario  AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-ex-tarifario  AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-icms-conv     AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-icms-conv     AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-tipi          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-tipi          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-lista-ex      AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-lista-ex      AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-lista-ex-bit  AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-lista-ex-bit  AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-naladi-1996   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-naladi-1996   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-naladi-2002   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-naladi-2002   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-naladi-2007   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-naladi-2007   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-notas-comp    AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-notas-comp    AS longchar NO-UNDO.
DEFINE VARIABLE c-msg-nve           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-nve           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-pis           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-pis           AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-red-import    AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-red-import    AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-sistemas      AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-sistemas      AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-msg-tra-siscomex  AS LONGCHAR NO-UNDO.
DEFINE VARIABLE c-lbl-tra-siscomex  AS LONGCHAR NO-UNDO.


DEF VAR j AS INTEGER.
DEF VAR l AS INTEGER.
DEFINE BUFFER bf-fiscosoft-ncm     FOR fiscosoft-ncm.
DEFINE BUFFER bf-fiscosoft-acordos FOR fiscosoft-acordos.
DEFINE BUFFER bf-fiscosoft-list-ex FOR fiscosoft-list-ex.


define temp-table tt-envio
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes.

define temp-table tt-envio2
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem1
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.

define temp-table tt-erros-1
    field cod-erro  as integer
    field desc-erro as character format "x(256)"
    field desc-arq  as character.

DEF VAR i-aux AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt-erros NO-UNDO
    FIELD mensagem             AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-ncm-email NO-UNDO
    FIELD codigo       AS CHAR FORMAT 'x(15)'
    FIELD tipo         AS CHAR 
    FIELD c-label      AS CHAR 
    FIELD c-informacao AS CHAR
    FIELD c-posicao    AS INT
    INDEX idx-1 codigo c-posicao.

DEF BUFFER b-tt-ncm-email FOR tt-ncm-email.

DEFINE TEMP-TABLE tt-ncm-aux NO-UNDO
    FIELD sequencia-ncm        AS INTEGER
    FIELD codigo               AS CHARACTER FORMAT 'x(15)'
    FIELD descricao            AS CHARACTER FORMAT 'x(80)'
    FIELD aliquota             AS CHARACTER
    FIELD indicadores          AS CHARACTER
    FIELD ipi                  AS CHARACTER
    FIELD pis                  AS CHARACTER
    FIELD cofins               AS CHARACTER
    FIELD icms                 AS CHARACTER
    FIELD ume                  AS CHARACTER
    FIELD vigencia-de          AS CHARACTER FORMAT 'x(10)'
    FIELD vigencia-ate         AS CHARACTER FORMAT 'x(10)'
    FIELD ver-excecao-tec      AS CHARACTER
    FIELD ver-excecao-tipi     AS CHARACTER
    FIELD ponteiro-atualizacao AS CHARACTER
    INDEX idx-ncm              IS PRIMARY UNIQUE codigo.

/* Tabela criada para armazenar as informa‡äes que serÆo impressas no arquivo de e-mail.
   Feito isso pois estava ocorrendo erro de vari vel "CHAR" muito grande, entÆo foi quabrada em "partes" na temp-table. */
DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD mensagem AS CHARACTER.

FIND FIRST param-fiscosoft NO-LOCK NO-ERROR.
IF  NOT AVAIL param-fiscosoft THEN DO:
    PUT skip(1) "Parƒmetros Fiscosoft (esinp001) n’o cadastrado." SKIP(1).
    RETURN "NOK":U.
END.


/*--- Bloco Principal ---*/
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Atualizando com FISCOSOFT":U).

ASSIGN dt-baixa            = TODAY
       i-ponteiro          = 0.

/* Elimina os registros da base de dados, com data inferior a data Limite de Hist½rico */
/*RUN pi-elimina-historico.*/

/* Busca o  œltimo ponteiro referente a œltima atualiza»’o                                 */
/* A partir deles, sÆo retornadas s½ as ALTERA€åES nas NCMS a partir da œltima atualiza‡Æo */
FIND LAST fiscosoft-ncm USE-INDEX idx-ponteiro_atualizacao NO-LOCK NO-ERROR.
IF  AVAIL fiscosoft-ncm THEN
    ASSIGN i-ponteiro = fiscosoft-ncm.ponteiro-atualizacao.
ELSE
    ASSIGN i-ponteiro = 0.




/* Independentemente, sempre busca a partir da ncm = 01. O Ponteiro ‚ quem vai determinar os registros novos   */
/* que vÆo retornar do webservise.                                                                             */
ASSIGN c-ncm = "01".

/*     ASSIGN i-ponteiro = 81591372    */
/*            c-ncm      = "03036800". */
REPEAT:
    ASSIGN i = i + 1.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT STRING(i) + " - Buscando informa‡äes no FiscoSoft...").

    EMPTY TEMP-TABLE tt-ncm.
    EMPTY TEMP-TABLE tt-acordos.
    EMPTY TEMP-TABLE tt-list-ex.
    EMPTY TEMP-TABLE tt-list-ex-bit.
    EMPTY TEMP-TABLE tt-ex-br-simples.
    EMPTY TEMP-TABLE tt-sistemas.
    EMPTY TEMP-TABLE tt-red-import.
    EMPTY TEMP-TABLE tt-nve.
    EMPTY TEMP-TABLE tt-naladi-1996.
    EMPTY TEMP-TABLE tt-naladi-2002.
    EMPTY TEMP-TABLE tt-naladi-2007.
    EMPTY TEMP-TABLE tt-defesa-comercial.
    EMPTY TEMP-TABLE tt-acordo-ptr04.
    EMPTY TEMP-TABLE tt-icms-convenio.
    EMPTY TEMP-TABLE tt-tra-siscomex.
    EMPTY TEMP-TABLE tt-pis-cofins.
    EMPTY TEMP-TABLE tt-notas-complementares.
    EMPTY TEMP-TABLE tt-ipi-det.

    RUN esp/inp/esinp002.p (INPUT  c-ncm,      /* NCM */
                            INPUT  i-ponteiro, /* Ponteiro Atualiza»’o */
                            OUTPUT TABLE tt-ncm,
                            OUTPUT TABLE tt-acordos,
                            OUTPUT TABLE tt-list-ex,
                            OUTPUT TABLE tt-list-ex-bit,
                            OUTPUT TABLE tt-ex-br-simples,
                            OUTPUT TABLE tt-sistemas,
                            OUTPUT TABLE tt-red-import,
                            OUTPUT TABLE tt-nve,
                            OUTPUT TABLE tt-naladi-1996,
                            OUTPUT TABLE tt-naladi-2002,
                            OUTPUT TABLE tt-naladi-2007,
                            OUTPUT TABLE tt-defesa-comercial,
                            OUTPUT TABLE tt-acordo-ptr04,
                            OUTPUT TABLE tt-icms-convenio,
                            OUTPUT TABLE tt-tra-siscomex,
                            OUTPUT TABLE tt-pis-cofins,
                            OUTPUT TABLE tt-notas-complementares,
                            OUTPUT TABLE tt-ipi-det).

    ASSIGN i-cont = 0.

    FOR EACH tt-ncm NO-LOCK:

        RUN pi-Zera-Labels-Mensagens.

        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Processando Registros. NCM: " + tt-ncm.codigo).

        /* Necessÿrio para saber a partir de qual NCM deve ser retornada a pr½xima pagina»’o */  
        ASSIGN c-ncm = tt-ncm.codigo.                                                       

        ASSIGN i-cont = i-cont + 1.

        RUN pi-atualiza-tabelas.

    END.

    /* Se retornou menos de 5 registros, as NCMs acabaram.  */
    /* A pagina‡Æo ‚ feita de 5 em 5 registros devido problemas em tamanho de arquivo retornado, quando colocado pagina‡Æo maior*/
    IF  i-cont < 5 THEN
        LEAVE.

END.

/******************************** ROTINA DE ENVIO DE EAMIL ********************************/
/* Sà COME€A A ENVIAR E-MAIL NA SEGUNDA ATUALIZA€ÇO, QUANDO O VOLUME DE DADOS Jµ  PONTUAL*/
 IF  i-ponteiro > 0 THEN DO:  
                                                                                 
    DEFINE VAR CArqEmail  AS CHAR FORMAT 'x(60)'   NO-UNDO.                      
    ASSIGN cArqEmail = session:temp-directory + "fiscosost.html".                
                                                                                 
    DEF STREAM s.                                                                
                                                                                 
    OUTPUT STREAM s TO value(cArqEmail) CONVERT TARGET "ibm850" SOURCE "ibm850". 
                                                                                 
    RUN pi-envia-email.                                                          
                                                                                 
    OS-DELETE value(cArqEmail) NO-ERROR.                                         
                                                                                 
 END. 
/*********************************************************************************/

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.


RETURN "OK":U.

PROCEDURE pi-zera-labels-mensagens:

    ASSIGN c-msg-ncm          = ""
           c-lbl-ncm          = ""
           c-msg-acordos      = ""
           c-lbl-acordos      = ""
           c-msg-acordos-ptr  = ""
           c-lbl-acordos-ptr  = ""
           c-msg-defesa       = ""
           c-lbl-defesa       = ""
           c-msg-ex-tarifario = ""
           c-lbl-ex-tarifario = ""
           c-msg-icms-conv    = ""
           c-lbl-icms-conv    = ""
           c-msg-tipi         = ""
           c-lbl-tipi         = ""
           c-msg-lista-ex     = ""
           c-lbl-lista-ex     = ""
           c-msg-lista-ex-bit = ""
           c-lbl-lista-ex-bit = ""
           c-msg-naladi-1996  = ""
           c-lbl-naladi-1996  = ""
           c-msg-naladi-2002  = ""
           c-lbl-naladi-2002  = ""
           c-msg-naladi-2007  = ""
           c-lbl-naladi-2007  = ""
           c-msg-notas-comp   = ""
           c-lbl-notas-comp   = ""
           c-msg-nve          = ""
           c-lbl-nve          = ""
           c-msg-pis          = ""
           c-lbl-pis          = ""
           c-msg-red-import   = ""
           c-lbl-red-import   = ""
           c-msg-sistemas     = ""
           c-lbl-sistemas     = ""
           c-msg-tra-siscomex = ""
           c-lbl-tra-siscomex = "".
END.

PROCEDURE pi-Atualiza-Tabelas:

    DO TRANS:
    
        /****************************************************************** NCM ****************************************************************************/
        /* Cria para ncm e data de baixa atual*/
       
        IF  CAN-FIND (FIRST fiscosoft-ncm NO-LOCK
                        WHERE  fiscosoft-ncm.codigo    = tt-ncm.codigo
                        AND    fiscosoft-ncm.dt-baixa  = dt-baixa ) THEN 
            RETURN "OK".

        CREATE fiscosoft-ncm.
        ASSIGN fiscosoft-ncm.codigo   = tt-ncm.codigo
               fiscosoft-ncm.dt-baixa = dt-baixa.
        
        /* Grava o ponteiro de atualiza‡Æo */
        ASSIGN fiscosoft-ncm.ponteiro-atualizacao = tt-ncm.ponteiro_atualizacao.
    
        ASSIGN c-msg-ncm = "<TR>"
               c-lbl-ncm = "<TR>". 
    
        IF  tt-ncm.vigencia_de <> "" THEN
            tt-ncm.vigencia_de  = string(DATE(INT(SUBSTRING(tt-ncm.vigencia_de,6,2)) ,INT(SUBSTRING(tt-ncm.vigencia_de,9,2)) ,INT(SUBSTRING(tt-ncm.vigencia_de,1,4)))).
        ELSE
            tt-ncm.vigencia_de  = "".

        IF  tt-ncm.vigencia_ate <> ""  THEN
            ASSIGN tt-ncm.vigencia_ate = string(DATE(INT(SUBSTRING(tt-ncm.vigencia_ate,6,2)),INT(SUBSTRING(tt-ncm.vigencia_ate,9,2)),INT(SUBSTRING(tt-ncm.vigencia_ate,1,4)))).
        ELSE
            ASSIGN tt-ncm.vigencia_ate = "".

        {esp/inp/esinp003.i "tt-ncm.descricao"          "fiscosoft-ncm.descricao"         "c-lbl-ncm"    "'Descri‡Æo'"      "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.aliquota"           "fiscosoft-ncm.aliquota"          "c-lbl-ncm"    "'Al¡quota'"       "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.indicadores"        "fiscosoft-ncm.indicadores"       "c-lbl-ncm"    "'Indicadores'"    "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.ipi"                "fiscosoft-ncm.ipi"               "c-lbl-ncm"    "'IPI'"            "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.pis"                "fiscosoft-ncm.pis"               "c-lbl-ncm"    "'PIS'"            "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.cofins"             "fiscosoft-ncm.cofins"            "c-lbl-ncm"    "'COFINS'"         "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.icms"               "fiscosoft-ncm.icms"              "c-lbl-ncm"    "'ICMS'"           "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.ume"                "fiscosoft-ncm.ume"               "c-lbl-ncm"    "'UN'"             "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.ver_excecao_tec"    "fiscosoft-ncm.ver-excecao-tec"   "c-lbl-ncm"    "'Ver Exec Tec'"   "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.ver_excecao_tipi"   "fiscosoft-ncm.ver-excecao-tipi"  "c-lbl-ncm"    "'Ver Exec Tip'"   "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.vigencia_de"        "fiscosoft-ncm.vigencia-de"       "c-lbl-ncm"    "'Vegˆncia De'"    "c-msg-ncm"}      
        {esp/inp/esinp003.i "tt-ncm.vigencia_ate"       "fiscosoft-ncm.vigencia-ate"      "c-lbl-ncm"    "'Vegˆncia At‚'"   "c-msg-ncm"}      
    
        /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
        {esp/inp/esinp003.i2 "'< NCM >'" "c-lbl-ncm" "c-msg-ncm" "01"}
    
    
        /***************************************************************************** TIPI *************************************************************************************/
        FOR EACH  tt-ipi-det NO-LOCK
            WHERE tt-ipi-det.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-ipi-det"}

            ASSIGN fiscosoft-ipi-det.seq-ipi-det = tt-ipi-det.sequencia.

            ASSIGN c-msg-tipi = "<TR>"
                   c-lbl-tipi = "<TR>".

            {esp/inp/esinp003.i "tt-ipi-det.descricao"      "fiscosoft-ipi-det.descricao"      "c-lbl-tipi"    "'Descri‡Æo'"      "c-msg-tipi"}
            {esp/inp/esinp003.i "tt-ipi-det.anotacoes"      "fiscosoft-ipi-det.anotacoes"      "c-lbl-tipi"    "'Anota‡äes'"      "c-msg-tipi"}
            {esp/inp/esinp003.i "tt-ipi-det.ex"             "fiscosoft-ipi-det.ex"             "c-lbl-tipi"    "'EX'"             "c-msg-tipi"}
            {esp/inp/esinp003.i "tt-ipi-det.aliquota"       "fiscosoft-ipi-det.aliquota"       "c-lbl-tipi"    "'Al¡quota'"       "c-msg-tipi"}
            {esp/inp/esinp003.i "tt-ipi-det.vigencia_de"    "fiscosoft-ipi-det.vigencia-de"    "c-lbl-tipi"    "'Vigˆncia De'"    "c-msg-tipi"}
            {esp/inp/esinp003.i "tt-ipi-det.vigencia_ate"   "fiscosoft-ipi-det.vigencia-ate"   "c-lbl-tipi"    "'Vigˆncia At‚'"   "c-msg-tipi"}
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< TIPI >  (Notas Complementares sÆo listadas no esinp004)'" "c-lbl-tipi" "c-msg-tipi" "02"}


            /*************************************************************************** NOTAS COMPLEMENTARES ***********************************************************************/
            FOR EACH  tt-notas-complementares NO-LOCK
                WHERE tt-notas-complementares.sequencia_ncm = tt-ncm.sequencia_ncm
                  AND tt-notas-complementares.seq_ipi_det   = tt-ipi-det.sequencia:

                /* Cria para ncm e data de baixa atual*/
                {esp/inp/esinp003.i1 "fiscosoft-notas-complementares"}
                ASSIGN fiscosoft-notas-complementares.seq-ipi-det  = tt-ipi-det.sequencia
                       fiscosoft-notas-complementares.nota         = tt-notas-complementares.nota
                       fiscosoft-notas-complementares.codigo       = tt-notas-complementares.codigo      
                       fiscosoft-notas-complementares.observacao   = tt-notas-complementares.observacao
                       fiscosoft-notas-complementares.vigencia-de  = tt-notas-complementares.vigencia_de
                       fiscosoft-notas-complementares.vigencia-ate = tt-notas-complementares.vigencia_ate.
            END.
        END.

        /***************************************************************************** LISTA EX **********************************************************************************/
        FOR EACH  tt-list-ex NO-LOCK
            WHERE tt-list-ex.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-list-ex"}

            ASSIGN c-msg-lista-ex = "<TR>"
                   c-lbl-lista-ex = "<TR>". 

            {esp/inp/esinp003.i "tt-list-ex.ex"             "fiscosoft-list-ex.ex"             "c-lbl-lista-ex"    "'EX'"             "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.descricao"      "fiscosoft-list-ex.descricao"      "c-lbl-lista-ex"    "'Descri‡Æo'"      "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.aliquota"       "fiscosoft-list-ex.aliquota"       "c-lbl-lista-ex"    "'Al¡quota'"       "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.observacoes"    "fiscosoft-list-ex.observacoes"    "c-lbl-lista-ex"    "'Observa‡Æo'"     "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.indicadores"    "fiscosoft-list-ex.indicadores"    "c-lbl-lista-ex"    "'Indicadores'"    "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.vigencia_de"    "fiscosoft-list-ex.vigencia-de"    "c-lbl-lista-ex"    "'Vigˆncia De'"    "c-msg-lista-ex"}      
            {esp/inp/esinp003.i "tt-list-ex.vigencia_ate"   "fiscosoft-list-ex.vigencia-ate"   "c-lbl-lista-ex"    "'Vigˆncia At‚'"   "c-msg-lista-ex"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< LISTA EX >'" "c-lbl-lista-ex" "c-msg-lista-ex" "04"}

        END.

        /***************************************************************************** LISTA EX BIT *****************************************************************************/
        FOR EACH  tt-list-ex-bit NO-LOCK
            WHERE tt-list-ex-bit.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-list-ex-bit"}

            ASSIGN c-msg-lista-ex-bit = "<TR>"
                   c-lbl-lista-ex-bit = "<TR>". 

            {esp/inp/esinp003.i "tt-list-ex-bit.descricao"      "fiscosoft-list-ex-bit.descricao"      "c-lbl-lista-ex-bit"    "'Descri‡Æo'"      "c-msg-lista-ex-bit"}      
            {esp/inp/esinp003.i "tt-list-ex-bit.aliquota"       "fiscosoft-list-ex-bit.aliquota"       "c-lbl-lista-ex-bit"    "'Al¡quota'"       "c-msg-lista-ex-bit"}      
            {esp/inp/esinp003.i "tt-list-ex-bit.observacoes"    "fiscosoft-list-ex-bit.observacoes"    "c-lbl-lista-ex-bit"    "'Observa‡Æo'"     "c-msg-lista-ex-bit"}      
            {esp/inp/esinp003.i "tt-list-ex-bit.indicadores"    "fiscosoft-list-ex-bit.indicadores"    "c-lbl-lista-ex-bit"    "'Indicadores'"    "c-msg-lista-ex-bit"}      
            {esp/inp/esinp003.i "tt-list-ex-bit.vigencia_de"    "fiscosoft-list-ex-bit.vigencia-de"    "c-lbl-lista-ex-bit"    "'Vigˆncia De'"    "c-msg-lista-ex-bit"}      
            {esp/inp/esinp003.i "tt-list-ex-bit.vigencia_ate"   "fiscosoft-list-ex-bit.vigencia-ate"   "c-lbl-lista-ex-bit"    "'Vigˆncia At‚'"   "c-msg-lista-ex-bit"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< LISTA EX BIT >'" "c-lbl-lista-ex-bit" "c-msg-lista-ex-bit" "05"}

        END.

        /*********************************************************************** EX Tarifÿrio ***********************************************************************************/
        FOR EACH  tt-ex-br-simples NO-LOCK
            WHERE tt-ex-br-simples.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-ex-br-simples"}

            ASSIGN c-msg-ex-tarifario = "<TR>"
                   c-lbl-ex-tarifario = "<TR>". 

            {esp/inp/esinp003.i "tt-ex-br-simples.ex"             "fiscosoft-ex-br-simples.ex"             "c-lbl-ex-tarifario"    "'EX'"             "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.descricao"      "fiscosoft-ex-br-simples.descricao"      "c-lbl-ex-tarifario"    "'Descri‡Æo'"      "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.aliquota"       "fiscosoft-ex-br-simples.aliquota"       "c-lbl-ex-tarifario"    "'Al¡quota'"       "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.bkbit"          "fiscosoft-ex-br-simples.bkbit"          "c-lbl-ex-tarifario"    "'BkBit'"          "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.vigencia_de"    "fiscosoft-ex-br-simples.vigencia-de"    "c-lbl-ex-tarifario"    "'Vigˆncia De'"    "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.vigencia_ate"   "fiscosoft-ex-br-simples.vigencia-ate"   "c-lbl-ex-tarifario"    "'Vigˆncia At‚'"   "c-msg-ex-tarifario"}      
            {esp/inp/esinp003.i "tt-ex-br-simples.observacoes"    "fiscosoft-ex-br-simples.observacoes"    "c-lbl-ex-tarifario"    "'Observa‡äes'"    "c-msg-ex-tarifario"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< EX TARIFµRIO >'" "c-lbl-ex-tarifario" "c-msg-ex-tarifario" "06"}

        END.
            
        /************************************************************************ SISTEMAS *****************************************************************************************/
        FOR EACH  tt-sistemas NO-LOCK
            WHERE tt-sistemas.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-sistemas"}

            ASSIGN c-msg-sistemas = "<TR>"
                   c-lbl-sistemas = "<TR>". 

            {esp/inp/esinp003.i "tt-sistemas.descricao"       "fiscosoft-sistemas.descricao"      "c-lbl-sistemas"    "'Descri‡Æo'"      "c-msg-sistemas"}      
            {esp/inp/esinp003.i "tt-sistemas.aliquota"        "fiscosoft-sistemas.aliquota"       "c-lbl-sistemas"    "'Al¡quota'"       "c-msg-sistemas"}      
            {esp/inp/esinp003.i "tt-sistemas.observacoes"     "fiscosoft-sistemas.observacoes"    "c-lbl-sistemas"    "'Observa‡äes'"    "c-msg-sistemas"}      
            {esp/inp/esinp003.i "tt-sistemas.vigencia_de"     "fiscosoft-sistemas.vigencia-de"    "c-lbl-sistemas"    "'Vigˆncia De'"    "c-msg-sistemas"}      
            {esp/inp/esinp003.i "tt-sistemas.vigencia_ate"    "fiscosoft-sistemas.vigencia-ate"   "c-lbl-sistemas"    "'Vigˆncia At‚'"   "c-msg-sistemas"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< SISTEMAS >'" "c-lbl-sistemas" "c-msg-sistemas" "07"}

        END.

        /************************************************************************ RED IMPORT ***************************************************************************************/
        FOR EACH  tt-red-import NO-LOCK
            WHERE tt-red-import.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-red-import"}

            ASSIGN c-msg-red-import = "<TR>"
                   c-lbl-red-import = "<TR>". 

            {esp/inp/esinp003.i "tt-red-import.ex"              "fiscosoft-red-import.ex"             "c-lbl-red-import"    "'EX'"             "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.descricao"       "fiscosoft-red-import.descricao"      "c-lbl-red-import"    "'Descri‡Æo'"      "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.aliquota"        "fiscosoft-red-import.aliquota"       "c-lbl-red-import"    "'Al¡quota'"       "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.quota"           "fiscosoft-red-import.quota"          "c-lbl-red-import"    "'Quota'"          "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.observacoes"     "fiscosoft-red-import.observacoes"    "c-lbl-red-import"    "'Observa‡äes'"    "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.indicadores"     "fiscosoft-red-import.indicadores"    "c-lbl-red-import"    "'indicadores'"    "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.vigencia_de"     "fiscosoft-red-import.vigencia-de"    "c-lbl-red-import"    "'Vigˆncia De'"    "c-msg-red-import"}      
            {esp/inp/esinp003.i "tt-red-import.vigencia_ate"    "fiscosoft-red-import.vigencia-ate"   "c-lbl-red-import"    "'Vigˆncia At‚'"   "c-msg-red-import"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< QUOTA TARIFµRIA >'" "c-lbl-red-import" "c-msg-red-import" "08"}

        END.

        /************************************************************************ NOMENCLATURA VALOR ADUANEIRO *********************************************************************/
        FOR EACH  tt-nve NO-LOCK
            WHERE tt-nve.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-nve"}

            ASSIGN c-msg-nve = "<TR>"
                   c-lbl-nve = "<TR>". 

            {esp/inp/esinp003.i "tt-nve.nivel"           "fiscosoft-nve.nivel"           "c-lbl-nve"    "'N¡vel'"           "c-msg-nve"}      
            {esp/inp/esinp003.i "tt-nve.atributo"        "fiscosoft-nve.atributo"        "c-lbl-nve"    "'Atributo'"        "c-msg-nve"}      
            {esp/inp/esinp003.i "tt-nve.especificacao"   "fiscosoft-nve.especificacao"   "c-lbl-nve"    "'Especifica‡Æo'"   "c-msg-nve"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< NOMENCLATURA VALOR ADUANEIRO >'" "c-lbl-nve" "c-msg-nve" "09"}

        END.

        /******************************************************************************* NALADI 1996 ****************************************************************************/
        FOR EACH  tt-naladi-1996 NO-LOCK
            WHERE tt-naladi-1996.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-naladi-1996"}

            ASSIGN c-msg-naladi-1996 = "<TR>"
                   c-lbl-naladi-1996 = "<TR>". 

            {esp/inp/esinp003.i "tt-naladi-1996.codigo"       "fiscosoft-naladi-1996.codigo"       "c-lbl-naladi-1996"    "'C¢digo'"        "c-msg-naladi-1996"}      
            {esp/inp/esinp003.i "tt-naladi-1996.descricao"    "fiscosoft-naladi-1996.descricao"    "c-lbl-naladi-1996"    "'Descri‡Æo'"     "c-msg-naladi-1996"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< NALADI 1996 >'" "c-lbl-naladi-1996" "c-msg-naladi-1996" "10"}

        END.

        /******************************************************************************* NALADI 2002 ****************************************************************************/
        FOR EACH  tt-naladi-2002 NO-LOCK
            WHERE tt-naladi-2002.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-naladi-2002"}

            ASSIGN c-msg-naladi-2002 = "<TR>"
                   c-lbl-naladi-2002 = "<TR>". 

            {esp/inp/esinp003.i "tt-naladi-2002.codigo"       "fiscosoft-naladi-2002.codigo"       "c-lbl-naladi-2002"    "'C¢digo'"      "c-msg-naladi-2002"}      
            {esp/inp/esinp003.i "tt-naladi-2002.descricao"    "fiscosoft-naladi-2002.descricao"    "c-lbl-naladi-2002"    "'Descri‡Æo'"   "c-msg-naladi-2002"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< NALADI 2002 >'" "c-lbl-naladi-2002" "c-msg-naladi-2002" "11"}

        END.

        /******************************************************************************* NALADI 2007 ****************************************************************************/
        FOR EACH  tt-naladi-2007 NO-LOCK
            WHERE tt-naladi-2007.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-naladi-2007"}

            ASSIGN c-msg-naladi-2007 = "<TR>"
                   c-lbl-naladi-2007 = "<TR>". 

            {esp/inp/esinp003.i "tt-naladi-2007.codigo"       "fiscosoft-naladi-2007.codigo"       "c-lbl-naladi-2007"    "'C¢digo'"       "c-msg-naladi-2007"}      
            {esp/inp/esinp003.i "tt-naladi-2007.descricao"    "fiscosoft-naladi-2007.descricao"    "c-lbl-naladi-2007"    "'Descri‡Æo'"    "c-msg-naladi-2007"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< NALADI 2007 >'" "c-lbl-naladi-2007" "c-msg-naladi-2007" "12"}

        END.
        
        /*********************************************************************** Defesa Comercial ******************************************************************************/
        FOR EACH  tt-defesa-comercial NO-LOCK
            WHERE tt-defesa-comercial.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-defesa-comercial"}

            ASSIGN c-msg-defesa = "<TR>"
                   c-lbl-defesa = "<TR>". 

            {esp/inp/esinp003.i "tt-defesa-comercial.produto"             "fiscosoft-defesa-comercial.produto"             "c-lbl-defesa"   "'Produto'"            "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.pais"                "fiscosoft-defesa-comercial.pais"                "c-lbl-defesa"   "'Pa¡s'"               "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.medida"              "fiscosoft-defesa-comercial.medida"              "c-lbl-defesa"   "'Medida'"             "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.direito_aplicado"    "fiscosoft-defesa-comercial.direito-aplicado"    "c-lbl-defesa"   "'Direito Aplicado'"   "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.vigencia_de"         "fiscosoft-defesa-comercial.vigencia-de"         "c-lbl-defesa"   "'Vigˆncia De'"        "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.vigencia_ate"        "fiscosoft-defesa-comercial.vigencia-ate"        "c-lbl-defesa"   "'Vigˆncia At‚'"       "c-msg-defesa"}      
            {esp/inp/esinp003.i "tt-defesa-comercial.observacoes"         "fiscosoft-defesa-comercial.observacoes"         "c-lbl-defesa"   "'Observa‡äes'"        "c-msg-defesa"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< DEFESA COMERCIAL >'" "c-lbl-defesa" "c-msg-defesa" "13"}

        END.
               
        /************************************************************************* EX Tarif rio *********************************************************************************/
        FOR EACH  tt-icms-convenio NO-LOCK
            WHERE tt-icms-convenio.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-icms-convenio"}

            ASSIGN c-msg-icms-conv = "<TR>"
                   c-lbl-icms-conv = "<TR>". 

            {esp/inp/esinp003.i "tt-icms-convenio.descriminacao"    "fiscosoft-icms-convenio.descriminacao"     "c-lbl-icms-conv"    "'Descrimina‡Æo'"    "c-msg-icms-conv"}      
            {esp/inp/esinp003.i "tt-icms-convenio.convenio"         "fiscosoft-icms-convenio.convenio"          "c-lbl-icms-conv"    "'Convˆnio'"         "c-msg-icms-conv"}      
            {esp/inp/esinp003.i "tt-icms-convenio.anexo"            "fiscosoft-icms-convenio.anexo"             "c-lbl-icms-conv"    "'Anexo'"            "c-msg-icms-conv"}      
            {esp/inp/esinp003.i "tt-icms-convenio.tratamento"       "fiscosoft-icms-convenio.tratamento"        "c-lbl-icms-conv"    "'Tratamento'"       "c-msg-icms-conv"}      
            {esp/inp/esinp003.i "tt-icms-convenio.resumo"           "fiscosoft-icms-convenio.resumo"            "c-lbl-icms-conv"    "'Resumo'"           "c-msg-icms-conv"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< ICMS CONVÒNIO >'" "c-lbl-icms-conv" "c-msg-icms-conv" "14"}

        END.

        /******************************************************************  Acordos  **********************************************************************/
        FOR EACH  tt-acordos NO-LOCK
            WHERE tt-acordos.sequencia_ncm = tt-ncm.sequencia_ncm:
    
            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-acordos"}
    
            ASSIGN c-msg-acordos = "<TR>" 
                   c-lbl-acordos = "<TR>". 
    
            {esp/inp/esinp003.i "tt-acordos.ex"             "fiscosoft-acordos.ex"             "c-lbl-acordos"    "'EX'"              "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.tipo_codigo"    "fiscosoft-acordos.tipo-codigo"    "c-lbl-acordos"    "'Tipo C¢digo'"     "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.acordo"         "fiscosoft-acordos.acordo"         "c-lbl-acordos"    "'Acordo'"          "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.anotacoes_imp"  "fiscosoft-acordos.anotacoes-imp"  "c-lbl-acordos"    "'Anota‡äes IMP'"   "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.anotacoes_exp"  "fiscosoft-acordos.anotacoes-exp"  "c-lbl-acordos"    "'Anota‡äes EXP'"   "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.aliq"           "fiscosoft-acordos.aliq"           "c-lbl-acordos"    "'Al¡quota'"        "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.pp_imp"         "fiscosoft-acordos.pp-imp"         "c-lbl-acordos"    "'PP IMP'"          "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.pp_exp"         "fiscosoft-acordos.pp-exp"         "c-lbl-acordos"    "'PP EXP'"          "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.vigencia_de"    "fiscosoft-acordos.vigencia-de"    "c-lbl-acordos"    "'Vigˆncia De'"     "c-msg-acordos"}      
            {esp/inp/esinp003.i "tt-acordos.vigencia_ate"   "fiscosoft-acordos.vigencia-ate"   "c-lbl-acordos"    "'Vigˆncia At‚'"    "c-msg-acordos"}      
                
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< ACORDOS INT >'" "c-lbl-acordos" "c-msg-acordos" "15"}
    
        END.
    
        /*********************************************************************** Acordos INT PTR04  *****************************************************************************/
        FOR EACH  tt-acordo-ptr04 NO-LOCK
            WHERE tt-acordo-ptr04.sequencia_ncm = tt-ncm.sequencia_ncm:
    
            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-acordo-ptr04"}
    
            ASSIGN c-msg-acordos-ptr = "<TR>"
                   c-lbl-acordos-ptr = "<TR>". 
    
            {esp/inp/esinp003.i "tt-acordo-ptr04.naladi_1996"    "fiscosoft-acordo-ptr04.naladi-1996"    "c-lbl-acordos-ptr"    "'NALADI 1996'"     "c-msg-acordos-ptr"}      
            {esp/inp/esinp003.i "tt-acordo-ptr04.exceto"         "fiscosoft-acordo-ptr04.exceto"         "c-lbl-acordos-ptr"    "'Exceto'"          "c-msg-acordos-ptr"}      
    
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< ACORDOS INT PTR 04 >'" "c-lbl-acordos-ptr" "c-msg-acordos-ptr" "16"}
    
        END.

        /************************************************************************ TRA SISCOMEX *************************************************************************************/
        FOR EACH  tt-tra-siscomex NO-LOCK
            WHERE tt-tra-siscomex.sequencia_ncm = tt-ncm.sequencia_ncm:

            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-tra-siscomex"}

            ASSIGN c-msg-tra-siscomex = "<TR>"
                   c-lbl-tra-siscomex = "<TR>". 

            {esp/inp/esinp003.i "tt-tra-siscomex.ncm"                    "fiscosoft-tra-siscomex.ncm"                    "c-lbl-tra-siscomex"    "'NCM'"                   "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.orgao_anuente"          "fiscosoft-tra-siscomex.orgao-anuente"          "c-lbl-tra-siscomex"    "'OrgÆo Anuente'"         "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.indicadores"            "fiscosoft-tra-siscomex.indicadores"            "c-lbl-tra-siscomex"    "'Indicadores'"           "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.tratamento"             "fiscosoft-tra-siscomex.tratamento"             "c-lbl-tra-siscomex"    "'Tratamento'"            "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.ex"                     "fiscosoft-tra-siscomex.ex"                     "c-lbl-tra-siscomex"    "'EX'"                    "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.ex_descricao"           "fiscosoft-tra-siscomex.ex-descricao"           "c-lbl-tra-siscomex"    "'EX Descri‡Æo'"          "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.fundamento_legal"       "fiscosoft-tra-siscomex.fundamento-legal"       "c-lbl-tra-siscomex"    "'Fundamento Legal'"      "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.descricao_mercadoria"   "fiscosoft-tra-siscomex.descricao-mercadoria"   "c-lbl-tra-siscomex"    "'Descri‡Æo Mercadoria'"  "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.excecoes"               "fiscosoft-tra-siscomex.excecoes"               "c-lbl-tra-siscomex"    "'Exce‡äes'"              "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.vigencia_de"            "fiscosoft-tra-siscomex.vigencia-de"            "c-lbl-tra-siscomex"    "'Vigˆncia De'"           "c-msg-tra-siscomex"}      
            {esp/inp/esinp003.i "tt-tra-siscomex.vigencia_ate"           "fiscosoft-tra-siscomex.vigencia-ate"           "c-lbl-tra-siscomex"    "'Vigˆncia At‚'"          "c-msg-tra-siscomex"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< TRATAMENTO ADMINISTRATIVO >'" "c-lbl-tra-siscomex" "c-msg-tra-siscomex" "17"}

        END.

        /************************************************************************ PIS/COFINS ***************************************************************************************/
        FOR EACH  tt-pis-cofins NO-LOCK
            WHERE tt-pis-cofins.sequencia_ncm = tt-ncm.sequencia_ncm:
    
            /* Cria para ncm e data de baixa atual*/
            {esp/inp/esinp003.i1 "fiscosoft-pis-cofins"}
    
            ASSIGN c-msg-pis = "<TR>"
                   c-lbl-pis = "<TR>". 
    
            {esp/inp/esinp003.i "tt-pis-cofins.pis"              "fiscosoft-pis-cofins.pis"             "c-lbl-pis"    "'PIS'"             "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.cofins"           "fiscosoft-pis-cofins.cofins"          "c-lbl-pis"    "'COFINS'"          "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.anotacao"         "fiscosoft-pis-cofins.anotacao"        "c-lbl-pis"    "'Anota‡Æo'"        "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.grupo"            "fiscosoft-pis-cofins.grupo"           "c-lbl-pis"    "'Grupo'"           "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.classificacao"    "fiscosoft-pis-cofins.classificacao"   "c-lbl-pis"    "'Classifica‡Æo'"   "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.principal"        "fiscosoft-pis-cofins.principal"       "c-lbl-pis"    "'Principal'"       "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.vigencia_de"      "fiscosoft-pis-cofins.vigencia-de"     "c-lbl-pis"    "'Vigˆncia De'"     "c-msg-pis"}      
            {esp/inp/esinp003.i "tt-pis-cofins.vigencia_ate"     "fiscosoft-pis-cofins.vigencia-ate"    "c-lbl-pis"    "'Vigˆncia At‚'"    "c-msg-pis"}      
            /* Cria a temp-table que serÿ utilizada para montas as informa‡äes do e-mail */
            {esp/inp/esinp003.i2 "'< PIS/COFINS >'" "c-lbl-pis" "c-msg-pis" "18"}
    
        END.
    
    END. /* TRANSA°€O */
END.


PROCEDURE pi-envia-email:

     DEF VAR h-utapi019 AS HANDLE NO-UNDO.
    
     EMPTY TEMP-TABLE tt-envio2.
     EMPTY TEMP-TABLE tt-mensagem1.
     EMPTY TEMP-TABLE tt-erros-1.

     FIND FIRST param-global NO-LOCK NO-ERROR.

     DEF VAR c-msg-cab    AS CHAR NO-UNDO.
     DEF VAR c-mensagem-1 AS CHAR NO-UNDO.
     DEF VAR c-assunto    AS CHAR NO-UNDO.

     ASSIGN c-msg-cab    = "<html>Prezado, " + "<BR><BR>" +                                                                         
                        "    Seguem altera‡äes nas estruturas de informa‡Æo da(s) NCM(s) enviadas pelo Sistema FiscoSoft." + "<BR>" + 
                        "    Data Atualiza‡Æo: " + STRING(TODAY, "99/99/9999") + "<BR><BR>" + 
                        "    As altera‡äes estÆo classificadas pelo C¢digo NCM, conforme segue: " + "<BR><BR>".                  
                                                                                                                                  
     ASSIGN c-mensagem-1 = "Prezado, " + CHR(10) + CHR(10) +
                         "    Segue anexo html com as altera‡äes nas estruturas de informa‡Æo da(s) NCM(s) enviadas pelo Sistema FiscoSoft." + CHR(10) +
                         "    As altera‡äes estÆo classificadas pelo C¢digo NCM. " + CHR(10) + CHR(10) +
                         "Data da Atualiza‡Æo: " + STRING(TODAY, "99/99/9999") + CHR(10) + CHR(10) +
                         "Atenciosamente,".


     PUT STREAM s UNFORMATTED c-msg-cab SKIP.
     /*********************** Monta a mesagem por NCM, de acordo com as altera»‡äes encotradas. ***********************/
     FOR EACH tt-ncm-email
         BREAK BY tt-ncm-email.codigo
               BY tt-ncm-email.c-posicao:

         IF  FIRST-OF (tt-ncm-email.codigo) THEN DO:
             FIND FIRST fiscosoft-ncm NO-LOCK
                  WHERE fiscosoft-ncm.codigo = tt-ncm-email.codigo 
                    AND fiscosoft-ncm.dt-baixa < dt-baixa NO-ERROR.
             IF  NOT AVAIL fiscosoft-ncm THEN DO:
                 CREATE tt-mensagem.
                 ASSIGN tt-mensagem.mensagem = "<BR><BR><BR>" + '<font color="red" size="4"> NOVA </font>'.
             END.

             FIND FIRST bf-fiscosoft-ncm NO-LOCK
                  WHERE bf-fiscosoft-ncm.codigo = tt-ncm-email.codigo NO-ERROR.

             CREATE tt-mensagem.
             ASSIGN tt-mensagem.mensagem = '<font color="#0000FF" size="4">' + "<b>=> NCM: " + tt-ncm-email.codigo + " - " + IF  AVAIL bf-fiscosoft-ncm THEN bf-fiscosoft-ncm.descricao ELSE "" + "</B>" + "</font>" + "<BR><BR>".
        END.

         IF  FIRST-OF(tt-ncm-email.c-posicao) THEN  DO:
             CREATE tt-mensagem.
             ASSIGN tt-mensagem.mensagem = "<BR>"  + "<B>" + '<font color="black">' + tt-ncm-email.tipo + "</font></B>" + "<BR>".

             CREATE tt-mensagem.
             ASSIGN tt-mensagem.mensagem = "<table border='1' cellspacing='1' cellpadding='2'>" + tt-ncm-email.c-informacao.
         END.

         CREATE tt-mensagem.
         ASSIGN tt-mensagem.mensagem = replace(tt-ncm-email.c-label, "<TD></TD>", "<TD>.</TD>").

         IF  LAST-OF(tt-ncm-email.c-posicao) THEN  DO:
             CREATE tt-mensagem.
             ASSIGN tt-mensagem.mensagem = "</table>" + "<BR>".

             FOR EACH tt-mensagem:
                 PUT STREAM s UNFORMATTED tt-mensagem.mensagem.

                 DELETE tt-mensagem.
             END.

             PUT STREAM s SKIP.
         END.

     END.

     PUT STREAM s UNFORMATTED "<BR><BR>" + 'Atenciosamente, ' + '<BR>' + '</html>' SKIP.

     OUTPUT STREAM s CLOSE.


     /****************************************************************************************************************/

     RUN utp/utapi019.p PERSISTENT SET h-utapi019.

     IF  NOT CAN-FIND (FIRST tt-ncm-email ) THEN
         ASSIGN c-assunto = "Nenhuma Atualiza‡Æo Fiscosoft at‚ o momento"
                c-mensagem-1 = "Prezado, " + CHR(10) + CHR(10) +                          
                         "    At‚ a presente data, nenhuma atualiza‡Æo nas informa‡äes de NCMs foi enviada pelo Sistema FiscoSoft." + CHR(10) +
                         "Data da éltima Atualiza‡Æo: " + STRING(TODAY, "99/99/9999") + CHR(10) + CHR(10) +
                         "Atenciosamente,".
     ELSE
         ASSIGN c-assunto = "Aviso de Altera‡äes NCM - FISCOSOFT".

     create tt-envio2.
     assign tt-envio2.versao-integracao = 1
            tt-envio2.servidor          = param-global.serv-mail
            tt-envio2.porta             = param-global.porta-mail
            tt-envio2.remetente         = "EMS@intelbras.com.br"
            tt-envio2.destino           = param-fiscosoft.email
            tt-envio2.assunto           = c-assunto
            tt-envio2.arq-anexo         = cArqEmail
            tt-envio2.formato           = "TEXTO"
            tt-envio2.exchange          = NO.

     CREATE tt-mensagem1.
     ASSIGN tt-mensagem1.seq-mensagem = 1
            tt-mensagem1.mensagem = c-mensagem-1.

     RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                    INPUT TABLE tt-mensagem1,
                                    OUTPUT TABLE tt-erros-1).

     if  return-value = "NOK" 
     AND AVAIL tt-erros-1 then do:

     END.

     DELETE PROCEDURE h-utapi019.
END.
