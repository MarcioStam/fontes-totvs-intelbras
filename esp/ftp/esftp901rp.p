{include/i-prgvrs.i ESFTP901 02.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ES091 MFT}
&ENDIF

{include/i_fnctrad.i}
{include/tt-edit.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    FIELD cod-estabel          LIKE estabelec.cod-estabel
    FIELD c-serie-ini          LIKE nota-fiscal.serie
    FIELD c-serie-fim          LIKE nota-fiscal.serie
    FIELD c-nota-ini           LIKE nota-fiscal.nr-nota-fis
    FIELD c-nota-fim           LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-ini          LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-fim          LIKE nota-fiscal.dt-emis-nota
    FIELD cod-cli-ini          like emitente.cod-emitente
    FIELD cod-cli-fim          like emitente.cod-emitente
    FIELD ind-memoria          AS INTEGER.

def temp-table tt-raw-digita
    field raw-digita       as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita. 

def var h-acomp     as handle no-undo.
DEF VAR i-codigo-orig   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-niv-trib-icms AS INTEGER     NO-UNDO.
define variable c-niv-trib-icms as char no-undo.
DEFINE VARIABLE l-sub AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cod-trib-cliente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-perc-FCP        AS DEC FORMAT ">>9.99" NO-UNDO.
DEFINE VARIABLE vlr-fcp-it         AS DEC NO-UNDO.

DEFINE VARIABLE tot-vl-mercad  LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-ipi     LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-bicms   LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-icms    LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-bicmsst LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-icmsst  LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.
DEFINE VARIABLE tot-vl-tot-it  LIKE it-nota-fisc.vl-merc-liq     NO-UNDO.


create tt-param.
raw-transfer raw-param to tt-param.  

DEF STREAM str-inut.

{utp/ut-glob.i}
{include/i-rpvar.i}

assign c-programa = "ESFTP901"
       c-versao   = "1.00"
       c-revisao  = "000"
       c-titulo-relat = "Memoria de Calculo NFS"
       c-sistema  = "".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i} */
/*     {include/i-rpout.i} */
    IF OPSYS = "unix" THEN
        OUTPUT TO value(c-dir-arquivo-session + trim(tt-param.usuario) +  "/esftp901.tmp").
    ELSE
        OUTPUT TO value(c-dir-arquivo-session + "esftp901.tmp").


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

/*     if tt-param.excel = no then do: */
/*        VIEW FRAME f-cabec.          */
/*        VIEW FRAME f-rodape.         */
/*     end.                            */

    RUN piMontaRelat-1.

    RUN pi-finalizar in h-acomp.
    OUTPUT CLOSE.

    
/*     MESSAGE "O Arquivo gerado encontra-se em : "  session:temp-directory + "esftp041.tmp" VIEW-AS ALERT-BOX. */

/*     {include/i-rpclo.i} */
    RETURN "OK".
END.


PROCEDURE piMontaRelat-1:
FIND FIRST estabelec
    WHERE estabelec.cod-estabel = tt-param.cod-estabel
    NO-LOCK NO-ERROR.
IF  NOT AVAIL estabelec THEN do:
    run pi-finalizar in h-acomp.
    RETURN "NOK".
END.

run pi-inicializar in h-acomp (input "Gerando mem½ria de cÿlculo").

find first estabelec
     where estabelec.cod-estabel = tt-param.cod-estabel
     no-lock no-error.

put "Nota Fiscal"       ";"
    "Emissao"           ";"
    "Pedido"            ";"
    "Numero de Volumes.NF" ";"
    "Cliente"           ";"
    "UF"                ";"
    "CFOP"              ";"
    "CST"               ";"
    "Item"              ";"
    "NCM"               ";"
    "% IPI"             ";"
    "Mercad"            ";"
    "IPI"               ";"
    "BC ICMS"           ";"
    "ICMS"              ";"
    "MVA"               ";" 
    "% Red"             ";" 
    "% ICMS Inter"      ";" 
    "% ICMS Intra"      ";" 
    "% Cred Intra"      ";" 
    "BC ICMS ST"        ";"
    "ICMS ST"           ";"
    "Aliq. FCP"         ";" 
    "Vl. FCP"           ";"
    "Total ITEM NF"     ";".

IF  tt-param.ind-memoria = 1 THEN
    PUT "MVA 'C'"           ";"
        "% Red 'C'"         ";"
        "% ICMS Inter 'C'"  ";"
        "% ICMS Intra 'C'"  ";"
        "% Cred Intra 'C'"  ";"
        "CF"                ";"
        "Trib.Cliente"      ";".

PUT "Mensagem"          ";".
PUT skip.

ASSIGN tot-vl-mercad  = 0
       tot-vl-ipi     = 0
       tot-vl-bicms   = 0
       tot-vl-icms    = 0
       tot-vl-bicmsst = 0
       tot-vl-icmsst  = 0
       tot-vl-tot-it  = 0.

FOR each emitente no-lock
    where emitente.cod-emitente >= tt-param.cod-cli-ini
    and   emitente.cod-emitente <= tt-param.cod-cli-fim, 
    EACH  nota-fiscal NO-LOCK
    WHERE nota-fiscal.nome-ab-cli   = emitente.nome-abrev
      AND nota-fiscal.cod-estabel   = tt-param.cod-estabel
      AND nota-fiscal.serie        >= tt-param.c-serie-ini
      AND nota-fiscal.serie        <= tt-param.c-serie-fim
      AND nota-fiscal.nr-nota-fis  >= tt-param.c-nota-ini
      AND nota-fiscal.nr-nota-fis  <= tt-param.c-nota-fim
      AND nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini
      AND nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim,
    each it-nota-fisc of nota-fiscal no-lock:

 /*   FIND emitente
        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL emitente THEN NEXT.
    IF  emitente.cod-emitente < tt-param.cod-cli-ini
    OR  emitente.cod-emitente > tt-param.cod-cli-fim THEN NEXT.
   */ 
    find first int-it-nota-fisc of it-nota-fisc no-lock no-error.

    find first natur-oper
         where natur-oper.nat-operacao = it-nota-fisc.nat-operacao
         no-lock no-error.

    find item
        where item.it-codigo = it-nota-fisc.it-codigo
        no-lock no-error.

/*     ASSIGN de-perc-FCP = 0.                                                */
/*     FIND item-uf NO-LOCK                                                   */
/*          WHERE item-uf.it-codigo           = it-nota-fisc.it-codigo        */
/*          AND   item-uf.cod-estado-orig     = estabelec.estado              */
/*          AND   item-uf.estado              = nota-fiscal.estado NO-ERROR.  */
/*     IF  AVAIL item-uf THEN DO:                                             */
/*         find first int-item-uf                                             */
/*              where int-item-uf.it-codigo       = item-uf.it-codigo         */
/*              and   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig   */
/*              and   int-item-uf.estado          = item-uf.estado            */
/*              NO-LOCK no-error.                                             */
/*                                                                            */
/*         RUN pi-retorna-aliquota-FCP (INPUT item-uf.it-codigo,              */
/*                                      INPUT item-uf.cod-estado-orig,        */
/*                                      INPUT item-uf.estado,                 */
/*                                      OUTPUT de-perc-FCP).                  */
/*                                                                            */
/*     END.                                                                   */
    ASSIGN i-codigo-orig = ITEM.codigo-orig.

    ASSIGN i-niv-trib-icms = 0
           c-niv-trib-icms = "".

    RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                       OUTPUT i-niv-trib-icms,      
                       OUTPUT l-sub).

    /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
    ASSIGN i-niv-trib-icms = INT(STRING(i-codigo-orig) + STRING(i-niv-trib-icms, "99")) WHEN AVAIL item
           c-niv-trib-icms = string(i-niv-trib-icms,"999").

     /* definidos com hudson
    MVA          = item-uf.per-sub-tri                = int-it-nota-fisc.perc-mva
    % RED        = item-uf.perc-red-sub               = int-it-nota-fisc.perc-red-icm
    % ICMS Intra = item-uf.dec-1                      = int-it-nota-fisc.perc-icms-intra
    % CRED Intra = int-item-uf.perc-credito-interno   = int-it-nota-fisc.perc-cred-intra
    % ICMS Inter = coluna 18 do programa esftp041     = item-uf.dec-1 = int-it-nota-fisc.perc-icms-inter
    */

    put nota-fiscal.nr-nota-fis          ";"
        nota-fiscal.dt-emis-nota         ";"
        it-nota-fisc.nr-pedcli           ";"
        nota-fiscal.nr-volumes           ";".
    
    if  avail emitente then    
        put emitente.cod-emitente        ";".
    else put "" ";".
        
    put nota-fiscal.estado               ";"
	    natur-oper.cod-cfop              ";"
        c-niv-trib-icms                  ";"
        it-nota-fisc.it-codigo           ";".

    if  avail item then        
        put item.class-fiscal            ";".
    else put "" ";".
        
    put it-nota-fisc.aliquota-ipi        ";"
        it-nota-fisc.vl-merc-liq         ";"
        it-nota-fisc.vl-ipi-it           ";"
        it-nota-fisc.vl-bicms-it         ";"
        it-nota-fisc.vl-icms-it          ";".

    ASSIGN tot-vl-mercad = tot-vl-mercad + it-nota-fisc.vl-merc-liq
           tot-vl-ipi    = tot-vl-ipi    + it-nota-fisc.vl-ipi-it
           tot-vl-bicms  = tot-vl-bicms  + it-nota-fisc.vl-bicms-it
           tot-vl-icms   = tot-vl-icms   + it-nota-fisc.vl-icms-it.

    if  avail int-it-nota-fisc then
        put int-it-nota-fisc.perc-mva        ";" 
            int-it-nota-fisc.perc-red-icm    ";" 
            int-it-nota-fisc.perc-icms-inter ";" 
            int-it-nota-fisc.perc-icms-intra ";" 
            int-it-nota-fisc.perc-cred-intra ";" .
    else
        put "" ";" 
            "" ";" 
            "" ";" 
            "" ";" 
            "" ";" .


    /* ----------- Adicionar o valor do fundo de combate a pobresa ao icms subst. --------*/
    ASSIGN vlr-fcp-it  = 0
           de-perc-FCP = 0.
    FOR EACH item-nf-adc NO-LOCK 
          WHERE item-nf-adc.cod-estab        = nota-fiscal.cod-estabel
           AND  item-nf-adc.cod-serie        = nota-fiscal.serie
            AND item-nf-adc.cod-nota         = nota-fiscal.nr-nota-fis
            AND item-nf-adc.idi-tip-dado     = 25 
            AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat:
         assign vlr-fcp-it = vlr-fcp-it + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30))
                de-perc-FCP = item-nf-adc.val-livre-2.
    END.

    put it-nota-fisc.vl-bsubs-it         ";"
        it-nota-fisc.vl-icmsub-it        ";"
        de-perc-FCP                      ";"   
        vlr-fcp-it                       ";".
    /* nota-fiscal.vl-tot-nota          ";".
        
    Coluna ËTotal NFÌ:  em todos os itens est  repetindo o valor total da NF. 
    Solicito a altera‡Æo do nome desta coluna para ËTotal Item NFÌ. 
    O valor deste campo deve ser composto pelo somat¢rio de: coluna ËMercadÌ, 
    coluna ËIPIÌ e coluna ËICMS STÌ, por item da NF;
     */

    PUT (it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-ipi-it + it-nota-fisc.vl-icmsub-it + vlr-fcp-it) ";".

    ASSIGN tot-vl-bicmsst = tot-vl-bicmsst + it-nota-fisc.vl-bsubs-it
           tot-vl-icmsst  = tot-vl-icmsst  + it-nota-fisc.vl-icmsub-it 
           tot-vl-tot-it  = tot-vl-tot-it  + (it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-ipi-it + it-nota-fisc.vl-icmsub-it + vlr-fcp-it). 

    IF  tt-param.ind-memoria = 1 THEN DO:
        if  avail item-uf then
            put item-uf.per-sub-tri          ";"
                item-uf.perc-red-sub         ";".
        else put "" ";" "" ";".
    
        if  avail int-it-nota-fisc then
            put int-it-nota-fisc.perc-icms-inter ";".
        else
            put "" ";".
    
        if  avail item-uf then
            put item-uf.dec-1                ";".
        else
            put "" ";".
    
        if avail int-item-uf then
           put int-item-uf.perc-credito-interno ";".
        else put "" ";".

        ASSIGN c-cod-trib-cliente = "".
        FIND int-emitente 
             WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL  int-emitente THEN
           CASE int-emitente.ind-forma-tributo:
                WHEN 1 THEN ASSIGN c-cod-trib-cliente = "R".
                WHEN 2 THEN ASSIGN c-cod-trib-cliente = "P".
                WHEN 3 THEN ASSIGN c-cod-trib-cliente = "S".
                WHEN 4 THEN ASSIGN c-cod-trib-cliente = "N".
                WHEN 5 THEN ASSIGN c-cod-trib-cliente = "I".
           END CASE.

        PUT natur-oper.consum-final ";"
            c-cod-trib-cliente ";".
    END.
    find first item-uf-sem-prot
         where item-uf-sem-prot.it-codigo       = it-nota-fisc.it-codigo
         and   item-uf-sem-prot.cod-estado-orig = estabelec.estado
         AND   item-uf-sem-prot.estado          = nota-fiscal.estado
         AND   item-uf-sem-prot.int-1           > 0
         no-lock no-error.
    if  avail item-uf-sem-prot then do:
        find first mensagem
             where mensagem.cod-mensagem = item-uf-sem-prot.int-1
             no-lock no-error.
        if avail mensagem then
           put mensagem.texto-mensag ";".
        else 
           put "" ";". 
    end.

    put skip.
END.

PUT "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    tot-vl-mercad ";"
    tot-vl-ipi    ";"
    tot-vl-bicms  ";"
    tot-vl-icms   ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    "" ";"
    tot-vl-bicmsst ";"
    tot-vl-icmsst  ";"
    tot-vl-tot-it  ";" SKIP.

end procedure.



