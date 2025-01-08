/**************************************************************************************************
** PROGRAMA...: espnfse2020rp.p - Relatorio RPS
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 12/09/2011
**************************************************************************************************/
{include/i-prgvrs.i espnfse2020 3.00.00.000}  /*** 010000 ***/
 
{cdp/cdcfgdis.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG
    FIELD lista-movto      AS LOG 
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-estabel-fim  AS CHAR
    FIELD serie-ini        AS CHAR
    FIELD serie-fim        AS CHAR
    FIELD nr-rps-ini       AS CHAR
    FIELD nr-rps-fim       AS CHAR
    FIELD dt-emis-ini      AS DATE
    FIELD dt-emis-fim      AS DATE
    FIELD nat-oper-ini     AS CHAR
    FIELD nat-oper-fim     AS CHAR
    FIELD l-pendente       AS LOG
    FIELD l-enviado        AS LOG
    FIELD l-convertido     AS LOG
    FIELD l-cancelado      AS LOG
    FIELD l-erro           AS LOG.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR c-insc-aux         AS CHAR FORMAT "x(08)"            NO-UNDO.
DEF VAR c-est-aux          AS CHAR FORMAT "x(12)"            NO-UNDO.
DEF VAR c-cgc-aux          AS CHAR FORMAT "x(14)"            NO-UNDO.
DEF VAR c-situacao         AS CHAR FORMAT "x(10)"            NO-UNDO.
DEF VAR h-acomp            AS HANDLE                         NO-UNDO.
DEF VAR i-qt-linhas        AS INT                            NO-UNDO.
DEF VAR de-vl-tot-serv     AS DEC                            NO-UNDO.     
DEF VAR de-vl-tot-deducao  AS DEC                            NO-UNDO.
DEF VAR vl-iss             AS DEC FORMAT ">>>>>>,>>9.99"     NO-UNDO.
DEF VAR vl-iss-ret         AS DEC FORMAT ">>>>>>,>>9.99"     NO-UNDO.
DEF VAR vl-iss-total       AS DEC FORMAT ">>>>>>>,>>9.99"    NO-UNDO.
DEF VAR vl-iss-ret-total   AS DEC FORMAT ">>>>>>>,>>9.99"    NO-UNDO.
DEF VAR vl-tot-nota-total  AS DEC FORMAT ">>>>>>,>>>,>>9.99" NO-UNDO.

DEF STREAM s-saida.

FORM nota-fiscal.cod-estabel              COLUMN-LABEL "Estab"
     nota-fiscal.serie                    COLUMN-LABEL "SÇrie"
     nota-fiscal.nr-nota-fis              COLUMN-LABEL "Nr RPS"
     nota-fiscal.nat-operacao             COLUMN-LABEL "Nat Oper"
     nota-fiscal.dt-emis                  COLUMN-LABEL "Dt Emiss∆o"
     nota-fiscal.vl-tot-nota              COLUMN-LABEL "Valor Total"
     vl-iss                               COLUMN-LABEL "Vl ISS"
     vl-iss-ret                           COLUMN-LABEL "Vl ISS Ret"
     c-situacao                           COLUMN-LABEL "Situaá∆o RPS"
     esp-ext-nota-fiscal.nr-nota-el       COLUMN-LABEL "Nr NFSe"
     esp-ext-nota-fiscal.cod-autentic-nfe COLUMN-LABEL "Cod Verificaá∆o"
     with down stream-io no-box width 159 frame f-rps.
     
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Gerando_Informaá‰es *}
run pi-inicializar in h-acomp (input  Return-value ).

{include/i-rpvar.i}

{utp/ut-liter.i Listagem_RPS_-_Recibo_Provis¢rio_Serviáo * r}
ASSIGN c-programa = "espnfse2020"
       c-versao   = c-prg-vrs
       c-revisao  = "000"
       c-titulo-relat = TRIM(RETURN-VALUE)
       c-rodape       = c-programa + " - V:" + c-versao + c-revisao
       c-rodape       = FILL("-",141 - LENGTH(c-rodape)) + c-rodape.

FORM HEADER
    SKIP(1)
    c-rodape FORMAT "x(141)"
WITH FRAME f-rodape WIDTH 141 NO-LABELS NO-BOX PAGE-BOTTOM STREAM-IO.

FORM HEADER
    FILL("-",141) FORMAT "x(141)"           AT 001
    c-empresa                               AT 001
    c-titulo-relat                          AT 048
    "Folha:"                                AT 132
    PAGE-NUMBER FORMAT ">>>9"               AT 138
    FILL("-",119) FORMAT "x(119)"           AT 001
    TODAY FORMAT "99/99/9999"               AT 121
    "-"                                     AT 132
    STRING(TIME,"HH:MM:SS")                 AT 134 SKIP (1)
WITH WIDTH 150 NO-LABELS NO-BOX PAGE-TOP FRAME f-cabec STREAM-IO.

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FOR EACH esp-ext-ser-estab NO-LOCK
   WHERE esp-ext-ser-estab.serie       >= tt-param.serie-ini
     AND esp-ext-ser-estab.serie       <= tt-param.serie-fim
     AND esp-ext-ser-estab.cod-estabel >= tt-param.cod-estabel-ini
     AND esp-ext-ser-estab.cod-estabel <= tt-param.cod-estabel-fim
     AND esp-ext-ser-estab.emite-rps,
    EACH nota-fiscal NO-LOCK
   WHERE nota-fiscal.cod-estabel   = esp-ext-ser-estab.cod-estabel
     AND nota-fiscal.serie         = esp-ext-ser-estab.serie
     AND nota-fiscal.nr-nota-fis  >= tt-param.nr-rps-ini
     AND nota-fiscal.nr-nota-fis  <= tt-param.nr-rps-fim
     AND nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini
     AND nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim
     AND nota-fiscal.nat-operacao >= tt-param.nat-oper-ini
     AND nota-fiscal.nat-operacao <= tt-param.nat-oper-fim:

    FIND FIRST esp-ext-nota-fiscal NO-LOCK
         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

    /** RPS Pendente de Convers∆o **/
    IF  NOT AVAIL esp-ext-nota-fiscal THEN
        ASSIGN c-situacao = "Pendente".

    ELSE DO:

        /** REGRA: Cancelamento NFSe **/
        IF  nota-fiscal.dt-cancela <> ? THEN DO:
    
            /** RPS Cancelamento Pendente **/
            IF  esp-ext-nota-fiscal.int-1 <= 1 THEN
                ASSIGN c-situacao = "Pendente".

            /** RPS Cancelamento Enviado **/
            IF  esp-ext-nota-fiscal.int-1 = 2 THEN
                ASSIGN c-situacao = "Enviado".

            /** RPS Cancelamento Cancelado **/
            IF  esp-ext-nota-fiscal.int-1 = 3 THEN
                ASSIGN c-situacao = "Cancelado".

            /** RPS Cancelamento Erro **/
            IF  esp-ext-nota-fiscal.int-1 <> 3 AND 
                CAN-FIND(FIRST esp-ext-nota-fiscal-erro
                         WHERE esp-ext-nota-fiscal-erro.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal-erro.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal-erro.nr-nota-fis = nota-fiscal.nr-nota-fis
                           AND esp-ext-nota-fiscal-erro.tipo-erro  <> "IM") THEN
                ASSIGN c-situacao = "Erro".
        END.

        /** REGRA: Conversao de RPS **/
        ELSE DO:
            
            /** RPS Convers∆o Pendente **/
            IF  NOT esp-ext-nota-fiscal.processada THEN
                ASSIGN c-situacao = "Pendente".

            /** RPS Convers∆o Enviado **/
            IF  esp-ext-nota-fiscal.processada THEN
                ASSIGN c-situacao = "Enviado".

            /** RPS Convers∆o Convertido **/
            IF  esp-ext-nota-fiscal.nr-nota-el       <> "" AND
                esp-ext-nota-fiscal.cod-autentic-nfe <> "" THEN
                ASSIGN c-situacao = "Convertido".

            /** RPS Convers∆o Erro **/
            IF  esp-ext-nota-fiscal.nr-nota-el       = "" AND
                esp-ext-nota-fiscal.cod-autentic-nfe = "" AND
                CAN-FIND(FIRST esp-ext-nota-fiscal-erro
                         WHERE esp-ext-nota-fiscal-erro.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal-erro.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal-erro.nr-nota-fis = nota-fiscal.nr-nota-fis
                           AND esp-ext-nota-fiscal-erro.tipo-erro  <> "IM") THEN
                ASSIGN c-situacao = "Erro".
        END.
    END.

    /*PARAMETROS*/
    IF  NOT tt-param.l-Pendente AND 
        c-situacao = "Pendente" THEN
        NEXT.

    IF  NOT tt-param.l-Enviado AND 
        c-situacao = "Enviado" THEN
        NEXT.

    IF  NOT tt-param.l-Convertido AND 
        c-situacao = "Convertido" THEN
        NEXT.

    IF  NOT tt-param.l-Cancelado AND 
        c-situacao = "Cancelado" THEN
        NEXT.

    IF  NOT tt-param.l-Erro AND 
        c-situacao = "Erro" THEN
        NEXT.
    
    /*VALOR ISS*/
    ASSIGN vl-iss     = 0
           vl-iss-ret = 0.
    
    FOR EACH it-nota-fisc NO-LOCK OF nota-fiscal:
        ASSIGN vl-iss     = vl-iss + it-nota-fisc.vl-iss-it
               vl-iss-ret = vl-iss-ret + DEC(SUBSTR(it-nota-fisc.char-2,218,14)).
    END.

    /*TOTALIZADOR*/
    ASSIGN vl-iss-total      = vl-iss-total      + vl-iss
           vl-iss-ret-total  = vl-iss-ret-total  + vl-iss-ret
           vl-tot-nota-total = vl-tot-nota-total + nota-fiscal.vl-tot-nota.

    /*IMPRESSAO*/
    DISP nota-fiscal.cod-estabel
         nota-fiscal.serie
         nota-fiscal.nr-nota-fis
         nota-fiscal.nat-operacao
         nota-fiscal.dt-emis
         nota-fiscal.vl-tot-nota
         vl-iss
         vl-iss-ret
         c-situacao
         esp-ext-nota-fiscal.nr-nota-el       WHEN AVAIL esp-ext-nota-fiscal
         esp-ext-nota-fiscal.cod-autentic-nfe WHEN AVAIL esp-ext-nota-fiscal
         WITH FRAME f-rps DOWN.
    DOWN WITH FRAME f-rps.
END.

PUT "----------------- ------------- -------------" AT 50 SKIP
    vl-tot-nota-total                               AT 50
    vl-iss-total
    vl-iss-ret-total SKIP.

{include/i-rpclo.i}

IF VALID-HANDLE (h-acomp) THEN
   run pi-finalizar in h-acomp.


