/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i FT0527RP 2.00.00.040 } /*** 010040 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ft0527rp MFT}
&ENDIF

/*****************************************************************************
**       Programa: FT0527rp.p
**       Data....: 14/03/07
**       Autor...: DATASUL S.A.
**       Objetivo: Emissor DANFE - NF-e
**       Vers∆o..: 1.00.000 - super
**       OBS.....: Este fonte foi gerado pelo Data Viewer 3.00
*******************************************************************************/

/*define variable c-prog-gerado as character no-undo initial "FT0527rp".

def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.*/

/****************** Definiá∆o de Tabelas Tempor†rias do Relat¢rio **********************/
{esp/es0018.i}
{utp/utapi019.i}
{include/i-freeac.i}

DEFINE STREAM s-arq-param.
DEFINE STREAM s-arq-rmssa. 

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-mail-moura NO-UNDO
    FIELD email-moura AS CHAR
    FIELD r-nota-fiscal AS ROW.


DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             like nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque".

def temp-table tt-param-aux
    field destino              as integer
    field destino-bloq         as integer
    field arquivo              as char
    field arquivo-bloq         as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field cod-layout           as character
    field des-layout           as character
    field log-impr-dados       as logical  
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE mgcad.empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field da-dt-saida          like movdis.nota-fiscal.dt-saida
    field c-hr-saida           AS CHAR FORMAT "xx:xx:xx":U INITIAL "000000"
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as integer
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    FIELD l-gera-danfe-xml     AS LOGICAL
    FIELD c-dir-hist-xml       AS CHARACTER
    FIELD ind-execucao         AS INT
    FIELD data-ini             AS DATE
    FIELD data-fim             AS DATE     
    FIELD nr-nota-fis          AS CHAR
    FIELD serie                AS CHAR
    FIELD cod-estabel          AS CHAR.  

DEFINE TEMP-TABLE tt-log-danfe-xml NO-UNDO
    FIELD seq           AS INTEGER
    FIELD c-nr-nota-xml AS CHARACTER
    FIELD c-chave-xml   AS CHARACTER.                

/******************* Busca XML **********************/

DEFINE TEMP-TABLE tt-historico-xml NO-UNDO
     FIELD dta-historico     AS CHARACTER FORMAT "X(022)" LABEL "Data Criaá∆o":U
     FIELD des-historico     AS CHARACTER FORMAT "X(020)" LABEL "Tipo XML":U
     FIELD cod-arquivo-xml   AS CHARACTER FORMAT "X(200)" LABEL "Arquivo XML":U
     INDEX idx-dta dta-historico DESCENDING.

DEFINE TEMP-TABLE tt-histor-tag NO-UNDO LIKE histor-tag 
    FIELD dt-formated AS CHARACTER FORMAT "x(19)".

DEFINE TEMP-TABLE tt-histor-tag-filtered NO-UNDO LIKE histor-tag
    FIELD cod-tipo-operacao AS CHARACTER FORMAT "x(20)".

DEFINE TEMP-TABLE tt-histor-tag-complete NO-UNDO LIKE histor-tag.

DEFINE TEMP-TABLE tt-nf-entreposto NO-UNDO
       FIELD rw-nota   AS ROWID
       FIELD remessa   AS LOG 
       FIELD venda     AS LOG
       INDEX idx rw-nota.

DEFINE TEMP-TABLE tt-xml-entreposto
       FIELD rw-nota AS ROWID
       FIELD arquivo AS CHAR
       FIELD venda   AS LOG
       INDEX idx rw-nota.


{cdp/cdcfgdis.i}

/****************** Parametros **********************/

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.
    
DEF TEMP-TABLE ttArquivo NO-UNDO
      FIELD sequencia   AS INT
      FIELD nomeArquivo AS CHAR
      INDEX idx1 sequencia.

DEFINE VARIABLE c-itens-moura AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-param AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-notas-impressas
   FIELD r-nota AS ROWID .

{cdp/cdapi090def.i}

{bcp/bcapi004.i}
{cdp/cd0666.i}
{cdp/cdcfgdis.i}
{include/i-epc200.i ft0527rp}

DEF BUFFER b-nota-fiscal FOR nota-fiscal.

DEF BUFFER b-emitente FOR emitente.
DEF BUFFER b-ped-venda FOR ped-venda.

{ftp/ft2010.i1} /* Definicao da temp-table tt-notas-geradas */ 

{ftp/ft0527rp.i1 "NEW"} /* DefiniÁ„o temp-table ttCaracteres como NEW SHARED */
{ftp/ft0527rp.i2}       /* CriaÁ„o registros temp-table ttCaracteres e ttColunasDANFE */

/****************** INCLUDE COM VARI¡VEIS GLOBAIS *********************/

{utp/ut-glob.i}

/****  Variaveis Compartilhadas  ****/
DEFINE NEW SHARED VAR r-nota     AS ROWID.
DEFINE NEW SHARED VAR c-hr-saida AS CHAR    FORMAT "xx:xx:xx" INIT "000000".
DEFINE NEW SHARED VAR l-dt       AS LOGICAL FORMAT "Sim/Nao"  INIT NO.
/*Definiá∆o da vari†veis para busca no xml*/
DEFINE NEW SHARED VARIABLE c-nr-nota-xml AS character.
DEFINE NEW SHARED VARIABLE c-chave-xml   AS character.   
DEFINE NEW SHARED VARIABLE l-gera-danfe-xml   AS logical.   
DEFINE NEW SHARED VARIABLE c-cod-dir-histor-xml AS character. 
                       

/***************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

DEF VAR h-acomp              AS HANDLE NO-UNDO.
DEF VAR v-cod-destino-impres AS CHAR   NO-UNDO.
DEF VAR v-num-reg-lidos      AS INT    NO-UNDO.
DEF VAR v-num-point          AS INT    NO-UNDO.
DEF VAR v-num-set            AS INT    NO-UNDO.
DEF VAR v-num-linha          AS INT    NO-UNDO.
DEF VAR v-cont-registro      AS INT    NO-UNDO.
DEF VAR v-des-retorno        AS CHAR   NO-UNDO.
DEF VAR v-des-local-layout   AS CHAR   NO-UNDO.
DEF VAR c-arquivo-continua   AS CHAR   NO-UNDO.
DEF VAR lSemWord             AS LOG    NO-UNDO.

DEF VAR da-dt-saida          AS DATE   NO-UNDO.
DEF VAR c-cod-layout         AS CHAR   NO-UNDO.
DEF VAR l-mais-itens         AS LOG    NO-UNDO INIT NO.

DEF VAR r-ped-venda     AS ROWID.
DEF VAR r-pre-fat       AS ROWID.
DEF VAR r-emitente      AS ROWID.
DEF VAR r-estabel       AS ROWID.
DEF VAR r-docum-est     AS ROWID.
DEF VAR r-ser-estab     AS ROWID.
DEF VAR r-natur-oper    AS ROWID.
DEF VAR l-tipo-nota     AS LOGICAL FORMAT "Entrada/Saida" NO-UNDO.

DEF VAR i-sit-nota-ini    AS INTEGER NO-UNDO.
DEF VAR i-sit-nota-fim    AS INTEGER NO-UNDO.

DEF VAR lDados            AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR cont              AS INTEGER            NO-UNDO.

DEF VAR c-msg  AS CHAR NO-UNDO.
DEF VAR c-help AS CHAR NO-UNDO.

DEF VAR c-ean       AS CHAR               NO-UNDO.
DEF var c-qt-caixa  AS CHAR               NO-UNDO.
DEF VAR c-descricao LIKE ITEM.descricao-1 NO-UNDO.
DEF VAR c-desc-item LIKE ITEM.desc-item   NO-UNDO.
DEFINE VAR c-caminho-danfe-linux AS CHAR NO-UNDO.
DEFINE VAR c-arquivo-log1 AS CHAR NO-UNDO.

//ASSIGN c-arquivo-log1 = '/mnt/spool/ma054010/esftp0527.txt'.

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.
EMPTY TEMP-TABLE tt-prog-ponto2.


{cdp/cd0590.i} /*tt-comunica */
DEF VAR tp-integ AS CHAR NO-UNDO.

DEFINE STREAM arq-erro.
DEFINE VAR    c-arquivo AS CHAR FORMAT "X(40)".

CREATE tt-param-aux.
RAW-TRANSFER raw-param TO tt-param-aux.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

IF OPSYS = "UNIX" THEN DO:
   // ASSIGN c-arquivo-log1 = '/mnt/spool/log-danfe-xml/esftp0527.txt'.
   RUN esp/es0018p.p (INPUT  'cdapi590',
                      INPUT  1,
                      INPUT  0,
                      INPUT  "":U,
                      OUTPUT TABLE tt-prog-ponto2).
END.
ELSE DO: //DIRETORIO WINDOWS
    RUN esp/es0018p.p (INPUT  'cdapi590',
                       INPUT  2,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto2).
   // ASSIGN c-arquivo-log1 = '\\erpapp\spool\ma054010\esftp0527.txt'.
END.
FIND FIRST tt-prog-ponto2 .

/*OUTPUT TO "\\totvs12\spool\ve888001\esftp0528.txt".*/
/*executado via esftp0528*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Acompanhamento Relat¢rio").

/**Batch**/
IF tt-param-aux.ind-execucao = 2 THEN DO:
    ASSIGN tt-param-aux.data-ini = TODAY - 1
           tt-param-aux.data-fim = TODAY.
END.
IF tt-param-aux.arquivo = "esftp0528.txt" THEN DO:

    IF tt-param-aux.nr-nota-fis <> "" THEN DO:

        //RUN pi-gerar-dados-extrato("tt-param-aux.nr-nota-fis -> " + tt-param-aux.nr-nota-fis).
        
        FOR EACH nota-fiscal NO-LOCK //busca notas pela integracao da solar usando a nota/serie/estab
           WHERE nota-fiscal.nr-nota-fis        = tt-param-aux.nr-nota-fis
             AND nota-fiscal.serie              = tt-param-aux.serie
             AND nota-fiscal.cod-estabel        = tt-param-aux.cod-estabel 
             AND nota-fiscal.idi-sit-nf-eletro <> 0: 
        
             IF (nota-fiscal.idi-forma-emis-nf-eletro      = 1        /* Tipo de Emissío   = Normal                  */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
                 OR (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss∆o   = Contingencia DPEC       */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 15       /* Situaá∆o da nota <> DPEC recebido pelo SCE  */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
                 OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss∆o  <> Normal                  */
                 AND nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss∆o  <> Contingencia DPEC       */
                 AND nota-fiscal.idi-sit-nf-eletro         = 5 ) THEN /* Situaá∆o da nota  = Documento Rejeitado     */
                    NEXT.

             //RUN pi-gerar-dados-extrato("ponto 2").
             
             FIND FIRST param-gener NO-LOCK
                  WHERE param-gener.cod-chave-1 = "param-geral-tc"
                    AND param-gener.cod-param   = "dir-arquivos" NO-ERROR.

             ASSIGN c-caminho-danfe-linux = tt-prog-ponto2.conteudo. //'/mnt/neogrid/homologacao' //param-gener.cod-valor
                    c-caminho-danfe-linux = REPLACE(c-caminho-danfe-linux,"\","/").

             /* RUN pi-gerar-dados-extrato("ponto 3").
              RUN pi-gerar-dados-extrato(c-caminho-danfe-linux). */
      
             /*Se j† gerou o pdf desconsidera*/
             /*IF SEARCH(TRIM(param-gener.cod-valor) + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") <> ? THEN 
                 NEXT. */
             
             IF SEARCH(TRIM(c-caminho-danfe-linux) + "/DANFE/" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") <> ? THEN 
                 NEXT.

              //RUN pi-gerar-dados-extrato("ponto 4").
      
           // IF SEARCH(TRIM("v:\ti\marcio") + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") <> ? THEN NEXT.
      
            RUN pi-acompanhar IN h-acomp("Selecionando notas " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
      
            CREATE tt-digita.
            ASSIGN tt-digita.cod-estabel = nota-fiscal.cod-estabel
                   tt-digita.serie       = nota-fiscal.serie      
                   tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                   tt-digita.cdd-embarq  = nota-fiscal.cdd-embarq. 

            //RUN pi-gerar-dados-extrato("ponto 5").
        END.
    END.
    ELSE DO: //busca notas pela data do programa esftp0528
        FOR EACH nota-fiscal NO-LOCK
           WHERE nota-fiscal.dt-emis-nota >= tt-param-aux.data-ini
             AND nota-fiscal.dt-emis-nota <= tt-param-aux.data-fim
             AND nota-fiscal.idi-sit-nf-eletro <> 0: 
        
             IF (nota-fiscal.idi-forma-emis-nf-eletro      = 1        /* Tipo de Emissío   = Normal                  */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
                 OR (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss∆o   = Contingencia DPEC       */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 15       /* Situaá∆o da nota <> DPEC recebido pelo SCE  */
                 AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
                 OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss∆o  <> Normal                  */
                 AND nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss∆o  <> Contingencia DPEC       */
                 AND nota-fiscal.idi-sit-nf-eletro         = 5 ) THEN /* Situaá∆o da nota  = Documento Rejeitado     */
                    NEXT.
      
             FIND FIRST param-gener NO-LOCK
                  WHERE param-gener.cod-chave-1 = "param-geral-tc"
                    AND param-gener.cod-param   = "dir-arquivos" NO-ERROR.
      
             /*Se j† gerou o pdf desconsidera*/
             IF SEARCH(TRIM(param-gener.cod-valor) + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") <> ? THEN 
                 NEXT.
            
            RUN pi-acompanhar IN h-acomp("Selecionando notas " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
      
            CREATE tt-digita.
            ASSIGN tt-digita.cod-estabel = nota-fiscal.cod-estabel
                   tt-digita.serie       = nota-fiscal.serie      
                   tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                   tt-digita.cdd-embarq  = nota-fiscal.cdd-embarq. 
        END.
    END.
    
END.

/*RUN pi-gerar-dados-extrato("ponto 6").
RUN pi-gerar-dados-extrato(tt-param-aux.c-dir-hist-xml).*/
ASSIGN l-gera-danfe-xml     = tt-param-aux.l-gera-danfe-xml
       c-cod-dir-histor-xml = tt-param-aux.c-dir-hist-xml.

{include/i-rpvar.i}

ASSIGN c-programa     = "FT0527rp":U
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-titulo-relat = "Emissor DANFE - NF-e"
       c-sistema      = "mft".

{varinc/var00002.i}

    //RUN pi-gerar-dados-extrato("ponto 7").

FIND FIRST mguni.empresa NO-LOCK
     WHERE mguni.empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.

IF AVAIL mguni.empresa THEN
   ASSIGN c-empresa  = mguni.empresa.razao-social.
ELSE
   ASSIGN c-empresa = "".
   
/* ========================== Chamada EPC ============================= */
IF c-nom-prog-upc-mg97 <> '':U THEN DO:
   FOR EACH tt-epc WHERE tt-epc.cod-event = "Destino":U :
      DELETE tt-epc.
   END.
   CREATE tt-epc.
   ASSIGN tt-epc.cod-event     = "Destino":U
          tt-epc.cod-parameter = "tt-param-aux.destino":U
          tt-epc.val-parameter = STRING(tt-param-aux.destino).

   {include/i-epc201.i "Destino"}

   FOR FIRST tt-epc WHERE tt-epc.cod-event     = "Destino"
                      AND tt-epc.cod-parameter = "tt-param-aux.destino":
      IF tt-epc.val-parameter <> "" AND
         tt-epc.val-parameter <> ? THEN
         ASSIGN tt-param-aux.destino = INTEGER(tt-epc.val-parameter).
   END.
END.
//RUN pi-gerar-dados-extrato("ponto 8").
/* ==================================================================== */

/**** EXECUCAO RELATORIO GRAFICO ****/
CASE tt-param-aux.destino:
    WHEN 1 THEN ASSIGN v-cod-destino-impres = "Impressora".
    WHEN 2 THEN ASSIGN v-cod-destino-impres = "Arquivo".
    OTHERWISE   ASSIGN v-cod-destino-impres = "Terminal".
END CASE.

IF  SEARCH("c:\windows\fonts\dc-code128.ttf") = ? 
AND SEARCH("/usr/share/fonts/dc-code128.ttf") = ? THEN DO:

    /*RUN pi-gerar-dados-extrato("ponto 9").
    RUN pi-gerar-dados-extrato("ponto 9.1 - " + SEARCH("/usr/share/fonts/dc-code128.ttf")).*/

    {utp/ut-liter.i "N∆o_foi_poss°vel_realizar_a_impress∆o."}
    ASSIGN c-msg = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "N∆o_foram_encontradas_as_Fontes_True_Type_necess†rias_para_impress∆o_do_DANFE._Gentileza_instalar_todas_as_FTT_contidas_na_pasta_interfac/bcodefont."}
    ASSIGN c-help = TRIM(RETURN-VALUE).

    //RUN pi-gerar-dados-extrato("ponto 10 " + c-msg).

    IF tt-param-aux.arquivo <> "esftp0528.txt" THEN
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17242,
                           INPUT c-msg + "~~" + c-help).

    RETURN ERROR.
END.

//RUN pi-gerar-dados-extrato("ponto 11").

/*run printForm in h-FunctionLibrary.*/

ASSIGN v-num-reg-lidos = 0.

FOR EACH tt-notas-impressas:
   DELETE tt-notas-impressas.
END.

IF tt-param-aux.data-exec <> ? THEN
   ASSIGN l-dt = yes.
ELSE 
   ASSIGN l-dt = no.

ASSIGN da-dt-saida       = tt-param-aux.da-dt-saida
       c-hr-saida        = STRING(tt-param-aux.c-hr-saida,"99:99:99")
       c-cod-layout      = tt-param-aux.cod-layout
       l-gera-danfe-xml  = tt-param-aux.l-gera-danfe-xml.

IF tt-param-aux.rs-imprime = 3 THEN DO:
    ASSIGN i-sit-nota-ini = 1
           i-sit-nota-fim = 7.
END.
ELSE DO:
    IF tt-param-aux.arquivo = "esftp0528.txt" THEN DO:
        ASSIGN i-sit-nota-ini = 1
               i-sit-nota-fim = 7.
    END.
    ELSE DO:
        IF tt-param-aux.rs-imprime = 1 THEN
           ASSIGN i-sit-nota-ini = 1
                  i-sit-nota-fim = 1.
        ELSE
           ASSIGN i-sit-nota-ini = 2
                  i-sit-nota-fim = 7.
    END.
END.

/* Seguranáa por estabelecimento */
&scoped-define TTONLY YES    
{include/i-estab-security.i}

FOR EACH tt-nf-entreposto: DELETE tt-nf-entreposto. END.


FOR EACH tt-digita:
    //RUN pi-gerar-dados-extrato("ponto 6").
    
    /*executado via esftp0528*/
    IF tt-param-aux.arquivo = "esftp0528.txt" THEN DO:
        FIND FIRST ser-estab NO-LOCK
             WHERE ser-estab.cod-estabel = tt-digita.cod-estabel
               AND ser-estab.serie       = tt-digita.serie NO-ERROR.
        
        IF  AVAIL ser-estab THEN DO:
    
            IF ser-estab.idi-format-emis-danfe = 1 
            OR ser-estab.idi-format-emis-danfe = 2 THEN DO:
               /*run utp/ut-msgs.p (input "show",
                                  INPUT 52042,
                                  input "").*/
               RETURN ERROR.
            END.
            
            IF ser-estab.idi-format-emis-danfe = 1 THEN
                ASSIGN c-cod-layout = "DANFE-Mod.1":U.
            ELSE IF ser-estab.idi-format-emis-danfe = 2 THEN
                ASSIGN c-cod-layout = "DANFE-Mod.2":U.
        END.
    
        IF c-cod-layout = "" THEN
           ASSIGN c-cod-layout = "DANFE-Mod.1":U.
    END.
    //RUN pi-gerar-dados-extrato("ponto 7").
    IF l-estab-security-active = YES THEN DO:
       FOR EACH {&ESTAB-SEC-TT} NO-LOCK,
           EACH nota-fiscal NO-LOCK
          WHERE nota-fiscal.cod-estabel   = tt-digita.cod-estabel
            AND nota-fiscal.cod-estabel   = {&ESTAB-SEC-TT-FIELD}
            AND nota-fiscal.serie         = tt-digita.serie
            AND nota-fiscal.nr-nota-fis   = tt-digita.nr-nota-fis
            AND nota-fiscal.cdd-embarq    = tt-digita.cdd-embarq
            AND nota-fiscal.ind-sit-nota >= i-sit-nota-ini
            AND nota-fiscal.ind-sit-nota <= i-sit-nota-fim
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.serie
                  BY nota-fiscal.nr-nota-fis:
    
          &IF DEFINED (bf_dis_nfe) &THEN
             &IF "{&bf_dis_versao_ems}" >= "2.07" &THEN
                IF (nota-fiscal.idi-forma-emis-nf-eletro  = 1        /* Tipo de Emiss∆o   = Normal                  */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* SituaÁ„o da nota <> Uso Autorizado          */
                OR (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss„o   = Contingencia EPEC       */
                AND nota-fiscal.idi-sit-nf-eletro        <> 15       /* SituaÁ„o da nota <> EPEC recebido pelo SCE  */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* SituaÁ„o da nota <> Uso Autorizado          */
                OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss„o  <> Normal                  */
                AND nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss„o  <> Contingencia EPEC       */
                AND nota-fiscal.idi-sit-nf-eletro         = 5 )      /* Situaá∆o da nota  = Documento Cancelado     */
                OR (nota-fiscal.idi-forma-emis-nf-eletro <> 2        /* Tipo de Emiss∆o  <> Contingencia FS         */
                AND nota-fiscal.idi-forma-emis-nf-eletro <> 5        /* Tipo de Emiss∆o  <> Contingencia FS-DA      */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 ) THEN /* Situaá∆o da nota <> Uso Autorizado          */
                   NEXT.
             &ELSE
                IF SUBSTR(nota-fiscal.char-2,65,2) = '' THEN 
                   NEXT.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '1' THEN DO: /*Tp Emis 1 = Normal*/
                   FIND FIRST sit-nf-eletro NO-LOCK
                        WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                          AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                          AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                   IF NOT AVAIL sit-nf-eletro OR sit-nf-eletro.idi-sit-nf-eletro <> 3 THEN /*Sit 3 = Uso Autorizado*/
                      NEXT.
                END.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '4' THEN DO: /*Tp Emis 4 = Contingància EPEC*/
                   FIND FIRST sit-nf-eletro NO-LOCK
                        WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                          AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                          AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                   IF NOT AVAIL sit-nf-eletro OR (sit-nf-eletro.idi-sit-nf-eletro <> 15 AND sit-nf-eletro.idi-sit-nf-eletro <> 3) THEN /*Sit 15 = EPEC recebido pelo SCE*/
                      NEXT.
                END.
             &ENDIF
          &ENDIF
          
                
          /* SE ESTIVER MARCADO PARA GERAR DANFE PELO XML, MONTA O NOME DOS ARQUIVOS COM BASE: 
              1-c-nr-nota-xml - Estabelecimento, SÇrie e Nro. da nota 
              2-c-chave-xml   - Chave de Acesso */
          IF l-gera-danfe-xml THEN  DO: 
    
              RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                                 INPUT "NF-e",
                                 OUTPUT tp-integ).
           
              if  tp-integ = "TC2" then do:
                  
                  bloco_leitura:
                  FOR EACH integr-totvs-colab WHERE
                          integr-totvs-colab.cod-edi   = "170" AND
                          integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro AND
                          integr-totvs-colab.log-lido  = yes NO-LOCK:
                  
                      EMPTY TEMP-TABLE tt-comunica.
                      {cdp/cd0590.i2 "tt-comunica" "integr-totvs-colab"}
                      
                      if  tt-comunica.cStat = "100" then  do:
                           assign c-nr-nota-xml = trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
                           leave bloco_leitura.
                      end.
                  end.
              end.
              else do:
    
                  ASSIGN c-nr-nota-xml = TRIM(nota-fiscal.cod-estabel) +                              
                                         SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,23,3) + 
                                         TRIM(STRING(INTEGER(SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,26,9)),">>9999999")) + ".XML"
                                     
                         c-chave-xml = TRIM(nota-fiscal.cod-chave-aces-nf-eletro) + ".XML". 
              END.
                       
             /* SE N«O ENCONTRAR O ARQUIVO .XML NO DIRET‡RIO VAI PARA O PR‡XIMO REGISTRO */    
             IF((SEARCH(c-cod-dir-histor-xml + "/" + c-nr-nota-xml) = ? AND
                 SEARCH(c-cod-dir-histor-xml + "/" + c-chave-xml) = ?)) THEN DO:   
                 
                 /*CRIA TEMP-TABLE COM INFORMAÄÂES DAS NOTAS EM 
                   QUE O XML N«O FOI ENCONTRADO NO DIRET‡RIO*/
                 ASSIGN cont = cont + 1.  
                 CREATE tt-log-danfe-xml.
                 ASSIGN tt-log-danfe-xml.seq           = cont
                        tt-log-danfe-xml.c-nr-nota-xml = TRIM(nota-fiscal.nr-nota-fis)
                        tt-log-danfe-xml.c-chave-xml   = nota-fiscal.cod-chave-aces-nf-eletro.           
       
                 NEXT.
             END.
          END.

          ASSIGN lDados = YES.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Gerando_DANFE_para_nota" *}
          RUN pi-acompanhar IN h-acomp(RETURN-VALUE + " " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
       
          ASSIGN v-num-reg-lidos = v-num-reg-lidos + 1.
          
          IF FIRST-OF(nota-fiscal.nr-nota-fis) THEN DO:
             ASSIGN v-cont-registro = 0.
          END.
       
          IF FIRST-OF(nota-fiscal.nr-nota-fis) THEN DO:
              //RUN pi-gerar-dados-extrato("ponto 21").
              RUN pi-imprime-nota.
          END.                                     
          
          RUN pi-cria-tt-moura (ROWID(nota-fiscal)).

          IF tt-param-aux.rs-imprime = 1 THEN // 1¯ Impressao NF
             RUN pi-cria-nf-entreposto (ROWID(nota-fiscal)).
       END.
    END.
    ELSE DO:
       FOR EACH {&ESTAB-SEC-TT} NO-LOCK,
           EACH nota-fiscal NO-LOCK
          WHERE nota-fiscal.cod-estabel   = tt-digita.cod-estabel
            AND nota-fiscal.serie         = tt-digita.serie
            AND nota-fiscal.nr-nota-fis   = tt-digita.nr-nota-fis
            AND nota-fiscal.cdd-embarq    = tt-digita.cdd-embarq
            AND nota-fiscal.ind-sit-nota >= i-sit-nota-ini
            AND nota-fiscal.ind-sit-nota <= i-sit-nota-fim
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.serie
                  BY nota-fiscal.nr-nota-fis:

          &IF DEFINED (bf_dis_nfe) &THEN
             &IF "{&bf_dis_versao_ems}" >= "2.07" &THEN
                IF (nota-fiscal.idi-forma-emis-nf-eletro  = 1        /* Tipo de Emiss∆o   = Normal                  */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* SituaÁ„o da nota <> Uso Autorizado          */
                OR (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss„o   = Contingencia EPEC       */
                AND nota-fiscal.idi-sit-nf-eletro        <> 15       /* SituaÁ„o da nota <> EPEC recebido pelo SCE  */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* SituaÁ„o da nota <> Uso Autorizado          */
                OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss„o  <> Normal                  */
                AND nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss„o  <> Contingencia EPEC       */
                AND nota-fiscal.idi-sit-nf-eletro         = 5 )      /* Situaá∆o da nota  = Documento Cancelado     */
                OR (nota-fiscal.idi-forma-emis-nf-eletro <> 2        /* Tipo de Emiss∆o  <> Contingencia FS         */
                AND nota-fiscal.idi-forma-emis-nf-eletro <> 5        /* Tipo de Emiss∆o  <> Contingencia FS-DA      */
                AND nota-fiscal.idi-sit-nf-eletro        <> 3 ) THEN /* Situaá∆o da nota <> Uso Autorizado          */
                   NEXT.
             &ELSE
                IF SUBSTR(nota-fiscal.char-2,65,2) = '' THEN 
                   NEXT.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '1' THEN DO: /*Tp Emis 1 = Normal*/
                   FIND FIRST sit-nf-eletro NO-LOCK
                        WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                          AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                          AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                   IF NOT AVAIL sit-nf-eletro OR sit-nf-eletro.idi-sit-nf-eletro <> 3 THEN /*Sit 3 = Uso Autorizado*/
                      NEXT.
                END.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '4' THEN DO: /*Tp Emis 4 = Contingància EPEC*/
                   FIND FIRST sit-nf-eletro NO-LOCK
                        WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                          AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                          AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                   IF NOT AVAIL sit-nf-eletro OR (sit-nf-eletro.idi-sit-nf-eletro <> 15 AND sit-nf-eletro.idi-sit-nf-eletro <> 3) THEN /*Sit 15 = EPEC recebido pelo SCE*/
                      NEXT.
                END.
             &ENDIF
          &ENDIF
       
          /* SE ESTIVER MARCADO PARA GERAR DANFE PELO XML, MONTA O NOME DOS ARQUIVOS COM BASE: 
              1-c-nr-nota-xml - Estabelecimento, SÇrie e Nro. da nota 
              2-c-chave-xml   - Chave de Acesso */
          IF l-gera-danfe-xml THEN  DO: 
              RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                                 INPUT "NF-e",
                                 OUTPUT tp-integ).
           
              if  tp-integ = "TC2" then do:
                  
                  bloco_leitura:
                  FOR EACH integr-totvs-colab WHERE
                          integr-totvs-colab.cod-edi   = "170" AND
                          integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro AND
                          integr-totvs-colab.log-lido  = yes NO-LOCK:
                  
                      EMPTY TEMP-TABLE tt-comunica.
                      {cdp/cd0590.i2 "tt-comunica" "integr-totvs-colab"}
                      
                      if  tt-comunica.cStat = "100" then  do:
                           assign c-nr-nota-xml = trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
                           leave bloco_leitura.
                      end.
                  end.
              end.
              else do:
    
                  ASSIGN c-nr-nota-xml = TRIM(nota-fiscal.cod-estabel) +                              
                                         SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,23,3) + 
                                         TRIM(STRING(INTEGER(SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,26,9)),">>9999999")) + ".XML"
                                     
                         c-chave-xml = TRIM(nota-fiscal.cod-chave-aces-nf-eletro) + ".XML". 
              END.
                       
             /* SE N«O ENCONTRAR O ARQUIVO .XML NO DIRET‡RIO VAI PARA O PR‡XIMO REGISTRO */    
             IF((SEARCH(c-cod-dir-histor-xml + "/" + c-nr-nota-xml) = ? AND
                 SEARCH(c-cod-dir-histor-xml + "/" + c-chave-xml) = ?)) THEN DO:   
                 
                 /*CRIA TEMP-TABLE COM INFORMAÄÂES DAS NOTAS EM 
                   QUE O XML N«O FOI ENCONTRADO NO DIRET‡RIO*/
                 ASSIGN cont = cont + 1.  
                 CREATE tt-log-danfe-xml.
                 ASSIGN tt-log-danfe-xml.seq           = cont
                        tt-log-danfe-xml.c-nr-nota-xml = TRIM(nota-fiscal.nr-nota-fis)
                        tt-log-danfe-xml.c-chave-xml   = nota-fiscal.cod-chave-aces-nf-eletro.           
       
                 NEXT.
             END.
          END.
       
          ASSIGN lDados = YES.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Gerando_DANFE_para_nota" *}
          RUN pi-acompanhar IN h-acomp(RETURN-VALUE + " " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
       
          ASSIGN v-num-reg-lidos = v-num-reg-lidos + 1.
          
          IF FIRST-OF(nota-fiscal.nr-nota-fis) THEN DO:
             ASSIGN v-cont-registro = 0.
          END.
       
          IF FIRST-OF(nota-fiscal.nr-nota-fis) THEN DO:
              //RUN pi-gerar-dados-extrato("ponto 20").
              RUN pi-imprime-nota.
          END.

          RUN pi-cria-tt-moura (ROWID(nota-fiscal)).

          IF tt-param-aux.rs-imprime = 1 THEN // 1¯ Impressao NF
             RUN pi-cria-nf-entreposto (ROWID(nota-fiscal)).
       END.
    END.
    //RUN pi-gerar-dados-extrato("ponto 8").
END. /*For each tt-digita*/
    
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Gerando_Arquivo_Final" *}
RUN pi-acompanhar in h-acomp(RETURN-VALUE).

/*Serie e estab Ç igual em todas, pega da primeira*/
FIND FIRST tt-digita NO-ERROR.

IF  AVAIL tt-digita 
AND CAN-FIND (FIRST ser-estab
             WHERE ser-estab.cod-estabel = tt-digita.cod-estabel
               AND ser-estab.serie       = tt-digita.serie
               AND &IF "{&bf_dis_versao_ems}":U >= "2.08":U &THEN
                       ser-estab.log-word-danfe
                   &ElSE
                       substring(ser-estab.char-1,70,1) = "S":U
                   &ENDIF) THEN
    ASSIGN lSemWord = YES.

/*Tratamento Aceite e manuseio placas solares*/
DEFINE VARIABLE i-qtd-arquivos AS INTEGER     NO-UNDO.

FOR EACH ttArquivo:
    ASSIGN i-qtd-arquivos = i-qtd-arquivos + 1.
END.

FOR EACH ttArquivo:
    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = ENTRY(1,ttArquivo.nomeArquivo,"-")
           AND nota-fiscal.serie       = ENTRY(2,ttArquivo.nomeArquivo,"-")
           AND nota-fiscal.nr-nota-fis = ENTRY(3,ttArquivo.nomeArquivo,"-") NO-ERROR.

    /*Imprime romaneio solar*/
    FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        IF ITEM.cod-unid-negoc = "ENS" THEN DO:
            RUN esp/ftp/esftp215.p (INPUT ROWID(nota-fiscal),
                                    INPUT SESSION:TEMP-DIRECTORY + ttArquivo.nomeArquivo).
        END.
    END.
END.


IF lDados = YES THEN DO:
    //RUN pi-gerar-dados-extrato("ponto 13").
    RUN piJuntaArquivos.
END.
ELSE DO:
    {utp/ut-liter.i "N∆o_foi_poss°vel_realizar_a_impress∆o."}
    ASSIGN c-msg = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "N∆o_h†_dados_para_imprimir."}
    ASSIGN c-help = TRIM(RETURN-VALUE).

    IF tt-param-aux.arquivo <> "esftp0528.txt" THEN
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 53082,
                           INPUT c-msg + "~~" + c-help).
END.



/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Abrindo_Documento_DANFE" *}
RUN pi-acompanhar in h-acomp(RETURN-VALUE).

ASSIGN v-des-retorno = "OK":U.

IF v-des-retorno <> "OK" THEN DO:
   IF i-num-ped-exec-rpw <> 0 THEN
      RETURN v-des-retorno.
   ELSE
      MESSAGE v-des-retorno VIEW-AS ALERT-BOX ERROR BUTTONS OK.
end.

IF VALID-HANDLE(h-acomp) THEN /*gr9030g*/
    RUN pi-finalizar IN h-acomp NO-ERROR.

/*Cria Log de mlx n∆o encontrados*/
IF CAN-FIND(FIRST tt-log-danfe-xml) THEN DO:                       
    RUN  ftp/ft0518g.p(INPUT raw-param, 
                       INPUT TABLE tt-raw-digita, 
                       INPUT TABLE tt-log-danfe-xml).
    
    IF tt-param-aux.arquivo <> "esftp0528.txt" THEN
       run utp/ut-msgs.p (INPUT "show":U,
                          INPUT 53366,
                          INPUT SESSION:TEMP-DIRECTORY + "FT0518_log.txt").
END.

RETURN 'OK'.

/* Procedure para impressao da nota fiscal */
PROCEDURE pi-imprime-nota:
   /* data de saida da nota fiscal */
   ASSIGN r-nota = rowid(nota-fiscal).

   {cdp/cdapi090a.i SCI CREATE nota-fiscal TP8}

   //RUN pi-gerar-dados-extrato("ponto 22").

   IF l-dt = YES AND string(da-dt-saida) <> "" AND da-dt-saida <> ? AND tt-param-aux.arquivo <> "esftp0528.txt" THEN DO:
      FIND FIRST b-nota-fiscal
           WHERE rowid(b-nota-fiscal) = rowid(nota-fiscal) EXCLUSIVE-LOCK no-error.

      IF b-nota-fiscal.dt-saida = ? THEN
          ASSIGN b-nota-fiscal.dt-saida = da-dt-saida.
    
      {cdp/cdapi090a.i SCI CREATE b-nota-fiscal TP9}

      RELEASE b-nota-fiscal.
   END.

   //RUN pi-gerar-dados-extrato("ponto 22").

   FIND FIRST ped-venda
        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
          NO-LOCK NO-ERROR.

   FIND FIRST estabelec
        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
        NO-LOCK NO-ERROR.

   FIND FIRST emitente
        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli
        NO-LOCK NO-ERROR.

   FIND FIRST pre-fatur 
        WHERE pre-fatur.cdd-embarq   = nota-fiscal.cdd-embarq
        AND   pre-fatur.nome-abrev   = nota-fiscal.nome-ab-cli
        AND   pre-fatur.nr-pedcli    = nota-fiscal.nr-pedcli
        AND   pre-fatur.nr-resumo    = nota-fiscal.nr-resumo
        NO-LOCK NO-ERROR.

   FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
        NO-LOCK NO-ERROR.

   FIND FIRST ser-estab NO-LOCK
        WHERE ser-estab.cod-estabel = tt-digita.cod-estabel
          AND ser-estab.serie       = tt-digita.serie NO-ERROR.

   ASSIGN r-estabel    = rowid(estabelec)
          r-ped-venda  = rowid(ped-venda)
          r-emitente   = rowid(emitente)
          r-natur-oper = rowid(natur-oper)
          r-ser-estab  = ROWID(ser-estab)
          r-pre-fat    = IF AVAIL pre-fatur THEN
                             rowid(pre-fatur)
                         ELSE ?
          l-tipo-nota  = no.

   IF (&IF "{&bf_dis_versao_ems}" >= "2.071" &THEN
            TRIM(estabelec.des-vers-layout)
        &ELSE
            TRIM(SUBSTRING(estabelec.char-1,173,10)
        &ENDIF >= "3.10") THEN DO:
        
        //RUN pi-gerar-dados-extrato("ponto 23").

        RUN ftp/ft0527f4.p (INPUT-OUTPUT TABLE ttArquivo).
    END.
    ELSE DO:
        //RUN pi-gerar-dados-extrato("ponto 24").
        RUN ftp/ft0527f.p (INPUT-OUTPUT TABLE ttArquivo).
    END.

    //RUN pi-gerar-dados-extrato("ponto 25").

   /* muda o status da nota-fiscal */
   IF nota-fiscal.ind-sit-nota <> 2 AND tt-param-aux.arquivo <> "esftp0528.txt" THEN
      RUN ftp/ft0503a.p.

   //RUN pi-gerar-dados-extrato("ponto 26").

   CREATE tt-notas-impressas.
   ASSIGN tt-notas-impressas.r-nota = rowid(nota-fiscal).

   /* GERA ETIQUETAS PARA O MODULO DE COLETA DE DADOS */

   IF  AVAIL param-global
   AND param-global.modulo-cl
   AND ( nota-fiscal.ind-tip-nota = 2) /* tipo de nota-fiscal Manual */
   THEN DO:
       //RUN pi-gerar-dados-extrato("ponto 27").
      CREATE tt-prog-bc.
      ASSIGN tt-prog-bc.cod-prog-dtsul        = "ft0513"
             tt-prog-bc.cod-versao-integracao = 1
             tt-prog-bc.usuario               = tt-param-aux.usuario
             tt-prog-bc.opcao                 = 1.

      RUN bcp/bcapi004.p (INPUT-OUTPUT TABLE tt-prog-bc,
                          INPUT-OUTPUT TABLE tt-erro).

      FIND FIRST tt-prog-bc NO-ERROR.

      ASSIGN c-arquivo = tt-prog-bc.nome-dir-etiq + "/" + c-arquivo.

      IF return-value = "OK" THEN DO:
         {utp/ut-liter.i Gerando_Etiquetas  MRE R}
         RUN pi-acompanhar in h-acomp (INPUT RETURN-VALUE).

         erro:
         DO ON stop     UNDO erro,LEAVE erro
            ON quit     UNDO erro,LEAVE erro
            ON error    UNDO erro,LEAVE erro
            ON endkey   UNDO erro,LEAVE erro:

            RUN value(tt-prog-bc.prog-criacao)(INPUT tt-prog-bc.cd-trans,
                                               INPUT rowid(nota-fiscal),
                                               INPUT-OUTPUT TABLE tt-erro) NO-ERROR.

            IF ERROR-STATUS:ERROR 
            OR (    ERROR-STATUS:GET-NUMBER(1) <> 138
                AND ERROR-STATUS:NUM-MESSAGES  <> 0)
            THEN DO:
               OUTPUT STREAM arq-erro TO VALUE(c-arquivo) APPEND.

               {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas_-_Progress MRE R}
               PUT STREAM arq-erro "***" RETURN-VALUE SKIP.
               {utp/ut-liter.i Programa * R}
               PUT STREAM arq-erro ERROR-STATUS:GET-MESSAGE(1) SKIP.
               PUT STREAM arq-erro RETURN-VALUE ": " tt-prog-bc.prog-criacao SKIP.
               PUT STREAM arq-erro nota-fiscal.serie                           AT 1.
               PUT STREAM arq-erro nota-fiscal.nr-nota-fis                     AT 7.
               PUT STREAM arq-erro nota-fiscal.cod-estabel                     AT 24.

               OUTPUT STREAM arq-erro CLOSE.
            END.

            IF RETURN-VALUE = "NOK" THEN DO:
               FIND FIRST tt-erro NO-ERROR.
               IF AVAIL tt-erro
               THEN DO:
                  OUTPUT STREAM arq-erro TO VALUE(c-arquivo) APPEND.

                  {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas MRE R}
                  PUT STREAM arq-erro "***" RETURN-VALUE SKIP.
                  FOR EACH tt-erro:
                     PUT STREAM arq-erro SKIP tt-erro.cd-erro " - " tt-erro.mensagem.
                  END.
                  PUT STREAM arq-erro SKIP.
                  OUTPUT STREAM arq-erro CLOSE.
               END.
            END.
         END.
      END.
      ELSE DO:
          //RUN pi-gerar-dados-extrato("ponto 26").
         /**** caso tenha integraá∆o com o coleta e ocorreu erros ***/
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO:
            OUTPUT STREAM arq-erro TO VALUE(c-arquivo) APPEND.

            {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas MRE R}
            PUT STREAM arq-erro "***" RETURN-VALUE SKIP.
            FOR EACH tt-erro:
                PUT stream arq-erro skip tt-erro.cd-erro " - " tt-erro.mensagem.
            END.
            PUT STREAM arq-erro SKIP.
            OUTPUT STREAM arq-erro CLOSE.
         END.
      END.
   END.
END PROCEDURE.

PROCEDURE OpenDocument:
   DEF INPUT PARAM c-doc  AS CHAR NO-UNDO.

   DEFINE VARIABLE c-exec AS CHAR NO-UNDO.
   DEFINE VARIABLE h-Inst AS INT  NO-UNDO.

   ASSIGN c-exec = FILL("x",255).
   RUN FindExecutableA (INPUT c-doc,
                        INPUT "",
                        INPUT-OUTPUT c-exec,
                        OUTPUT h-inst).

   IF h-inst >= 0 AND h-inst <= 32 THEN
      RUN ShellExecuteA (INPUT 0,
                         INPUT "open",
                         INPUT "rundll32.exe",
                         INPUT "shell32.dll,OpenAs_RunDLL " + c-doc,
                         INPUT "",
                         INPUT 1,
                         OUTPUT h-inst).

   RUN ShellExecuteA (INPUT 0,
                      INPUT "open",
                      INPUT c-doc,
                      INPUT "",
                      INPUT "",
                      INPUT 1,
                      OUTPUT h-inst).

   IF h-inst < 0 OR h-inst > 32 THEN RETURN "OK".
   ELSE RETURN "NOK".
END PROCEDURE.

PROCEDURE FindExecutableA EXTERNAL "Shell32.dll" persistent:
   DEFINE INPUT        PARAMETER lpFile      AS CHAR NO-UNDO.
   DEFINE INPUT        PARAMETER lpDirectory AS CHAR NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER lpResult    AS CHAR NO-UNDO.
   DEFINE RETURN       PARAMETER hInstance   AS LONG.
END.

PROCEDURE ShellExecuteA EXTERNAL "Shell32.dll" persistent:
   DEFINE INPUT  PARAMETER hwnd         AS LONG.
   DEFINE INPUT  PARAMETER lpOperation  AS CHAR NO-UNDO.
   DEFINE INPUT  PARAMETER lpFile       AS CHAR NO-UNDO.
   DEFINE INPUT  PARAMETER lpParameters AS CHAR NO-UNDO.
   DEFINE INPUT  PARAMETER lpDirectory  AS CHAR NO-UNDO.
   DEFINE INPUT  PARAMETER nShowCmd     AS LONG.
   DEFINE RETURN PARAMETER hInstance    AS LONG.
END PROCEDURE.

PROCEDURE piJuntaArquivos:
   DEFINE VARIABLE dt-data        	   AS DATE      NO-UNDO.
   DEFINE VARIABLE c-hora         	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-arq          	   AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-dir-tmp      	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE v_cod_arq      	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE v_cod_arq_aux  	   AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-fullpath     	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-command-line 	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-numero-copia 	   AS INTEGER   NO-UNDO.  
   DEFINE VARIABLE c-anexo             AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE h-printacrord32        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE c-diretorio-acroRd32   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-arquivo-bat-acroRd32 AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-comando-acroRd32     AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-impressora-padrao    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE h-inst                 AS LONGCHAR  NO-UNDO.

   DEFINE VARIABLE c-caminho-xml-nota     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-diretorio-entreposto AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-copia-arquivo-xml    AS CHARACTER NO-UNDO.

   DEFINE VARIABLE c-arquivo-nf-remessa   AS CHARACTER NO-UNDO.

   //RUN pi-gerar-dados-extrato("ponto 30").

   ASSIGN dt-data   = TODAY
          c-hora    = STRING(TIME,"HH:MM:SS")
          c-arq     = "FT0527" + REPLACE(STRING(dt-data), "/", "") + REPLACE(c-hora, ":", "") + ".pdf"
          c-dir-tmp = SESSION:TEMP-DIRECTORY.

   
   /* Busca o nome do primeiro Danfe gerado */
   FOR FIRST ttArquivo:
       //RUN pi-gerar-dados-extrato("ponto 31").
      ASSIGN v_cod_arq_aux = c-dir-tmp + ttArquivo.nomeArquivo.
      /*RUN pi-gerar-dados-extrato("ponto 32").
      RUN pi-gerar-dados-extrato(v_cod_arq_aux).*/
   END.    

   ASSIGN v_cod_arq_aux = replace(v_cod_arq_aux, ".pdf", "")    + "-m.pdf"
          c-fullpath    = SEARCH("ftp/pdf-merge.jar":U).


   /*RUN pi-gerar-dados-extrato(c-fullpath).
   RUN pi-gerar-dados-extrato("ponto 33").*/

   /* Se n∆o for encontrado o .Jar ou tiver rodando em batch n∆o executa a juná∆o dos arquivos*/
   IF  c-fullpath <> ? 
   AND tt-param-aux.arquivo <> "esftp0528.txt" THEN DO:
      /* Salva na vari†vel uma lista de Danfes */

      /*Imprime os parametros em um arquivo*/
      ASSIGN c-arquivo-param = SESSION:TEMP-DIRECTORY + "junta_arq_param_" + c-seg-usuario + STRING(TIME) + ".txt".
      OS-DELETE VALUE(c-arquivo-param).
      OUTPUT STREAM s-arq-param TO VALUE(c-arquivo-param).

      FOR EACH tt-xml-entreposto: DELETE tt-xml-entreposto. END.

      FOR EACH ttArquivo:   
         DO i-numero-copia = 1 TO tt-param-aux.nr-copias:
              //ASSIGN v_cod_arq = v_cod_arq + c-dir-tmp + ttArquivo.nomeArquivo + " ".
            PUT STREAM s-arq-param UNFORMATTED c-dir-tmp + ttArquivo.nomeArquivo + " ".
         END.

         /*Envio mail moura*/
         FIND FIRST nota-fiscal NO-LOCK
              WHERE nota-fiscal.cod-estabel = ENTRY(1,ttArquivo.nomeArquivo,"-")
                AND nota-fiscal.serie       = ENTRY(2,ttArquivo.nomeArquivo,"-")
                AND nota-fiscal.nr-nota-fis = ENTRY(3,ttArquivo.nomeArquivo,"-") NO-ERROR.

         ASSIGN c-caminho-xml-nota = ''.

         //Nota Fiscal Entreposto

         FIND FIRST tt-nf-entreposto
              WHERE tt-nf-entreposto.rw-nota = ROWID(nota-fiscal)
         NO-ERROR.

         IF AVAIL tt-nf-entreposto THEN DO:
  
            RUN pi-busca-xml-nota (INPUT rowid(nota-fiscal),OUTPUT c-caminho-xml-nota).

            RUN esp/es0018p.p (INPUT "esftp0527":U,
                               INPUT IF tt-nf-entreposto.venda THEN 3 ELSE 2,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            
            FOR EACH tt-prog-ponto:
                ASSIGN c-diretorio-entreposto = tt-prog-ponto.conteudo.
            END.

            OS-COPY VALUE(c-dir-tmp + ttArquivo.nomeArquivo) VALUE(c-diretorio-entreposto + ttArquivo.nomeArquivo). //COPIA DANFE

            IF c-caminho-xml-nota <> '' THEN DO: 

               ASSIGN c-caminho-xml-nota = REPLACE(c-caminho-xml-nota,'/','\').

               ASSIGN c-copia-arquivo-xml = entry(NUM-ENTRIES(c-caminho-xml-nota,'\'),c-caminho-xml-nota,'\').

               OS-COPY VALUE(c-caminho-xml-nota) VALUE(c-diretorio-entreposto + c-copia-arquivo-xml).  //COPIA XML  
            END.

            ASSIGN c-diretorio-entreposto = ''.

            RUN esp/es0018p.p (INPUT "esftp0527":U,
                               INPUT 4, //CAMINHO ARQUIVO PRODUTOS NF
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            FOR EACH tt-prog-ponto:
                ASSIGN c-diretorio-entreposto = tt-prog-ponto.conteudo.
            END.

            ASSIGN c-arquivo-nf-remessa = nota-fiscal.nr-nota-fis + '_' + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '.txt'.

            ASSIGN c-arquivo-nf-remessa = c-diretorio-entreposto + c-arquivo-nf-remessa. 

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
                FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.cod-estabel = nota-fiscal.cod-estabel
                  AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo,
                FIRST ITEM OF it-nota-fisc NO-LOCK 
                WHERE ITEM.cod-obsoleto = 1 
                  AND ITEM.ind-item-fat
                BREAK BY it-nota-fisc.it-codigo:

                FIND FIRST item-caixa WHERE item-caixa.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
               
                IF AVAIL item-caixa THEN
                   FIND FIRST embalag WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.

                IF NOT AVAIL embalag THEN NEXT.
               
                IF FIRST(it-nota-fisc.it-codigo) THEN 
                   OUTPUT STREAM s-arq-rmssa TO VALUE(c-arquivo-nf-remessa).

                IF FIRST-OF(it-nota-fisc.it-codigo) THEN DO:
                   RUN pi-remessa-entreposto.
                END.

                IF LAST(it-nota-fisc.it-codigo) THEN 
                   OUTPUT STREAM s-arq-rmssa CLOSE.
            END.

         END.

         
         IF CAN-FIND (FIRST tt-mail-moura
                      WHERE tt-mail-moura.r-nota-fiscal = ROWID(nota-fiscal)) THEN DO:
             ASSIGN c-anexo = c-dir-tmp + ttArquivo.nomeArquivo.
             RUN run-envia-mail-moura (INPUT c-anexo).
         END. 
          

      END.

      OUTPUT STREAM s-arq-param CLOSE.

      ASSIGN c-command-line = "java -jar ":U  + c-fullpath + " " + c-arquivo-param.  

      IF LENGTH(c-command-line) >= 2000 THEN DO:
          /* Para evitar o erro "** OS escap COMMAND too long. (379)" */
          OUTPUT TO VALUE(c-dir-tmp + "command-line-temp.bat").
    	      PUT UNFORMATTED c-command-line.
    	  OUTPUT CLOSE.
          
          /* Executa o .bat criado */
          OS-COMMAND SILENT VALUE(c-dir-tmp + "command-line-temp.bat").  

          /* Elimina o .bat */
          OS-DELETE VALUE(c-dir-tmp + "command-line-temp.bat") NO-ERROR.
      END.
      ELSE DO:
          /* Executa .Jar respons†vel pela juná∆o dos Danfes */   

          OS-COMMAND SILENT VALUE(c-command-line).
      END.                         

      /* Renomeia o arquivo gerado com todos os Danfes para o padr∆o */
      OS-RENAME VALUE(v_cod_arq_aux) VALUE(c-dir-tmp + c-arq).

   
      /* Abre em tela se a opcao for Terminal */
      IF  tt-param-aux.destino = 3 THEN DO:
         RUN OpenDocument(c-dir-tmp + c-arq).
      END.
	  ELSE DO:
         OS-RENAME VALUE(c-dir-tmp + c-arq) VALUE(tt-param-aux.arquivo).
		 
		 /* Envia para a impressora */
		 IF tt-param-aux.destino = 1 THEN DO:

             {utp/ut-liter.i "Enviando_arquivo_para_a_impressora" *}
			 RUN pi-acompanhar in h-acomp(RETURN-VALUE).

             IF INDEX (tt-param-aux.impressora-so," in session") > 0 THEN
                ASSIGN tt-param-aux.impressora-so = tt-param-aux.impressora-so + " on " + SESSION:PRINTER-PORT.

             RUN ftp/printacrord32.p PERSISTENT SET h-printacrord32.

             RUN printAcroRd32 IN h-printacrord32 (INPUT tt-param-aux.arquivo, INPUT tt-param-aux.impressora-so).

             IF VALID-HANDLE(h-printacrord32) THEN DO:
                 DELETE PROCEDURE h-printacrord32.
                 ASSIGN h-printacrord32 = ?.
             END. 
         END.
	  END.
	  
	  /* Apaga Danfes individuais */ 
/*       FOR EACH ttArquivo:                                             */
/*          OS-DELETE VALUE(c-dir-tmp + ttArquivo.nomeArquivo) NO-ERROR. */
/*       END.                                                            */
   END.
   ELSE DO:
      //RUN pi-gerar-dados-extrato("ponto 10").
      FOR EACH ttArquivo NO-LOCK:
         /*Executado via esftp0528 batch*/
         IF tt-param-aux.arquivo = "esftp0528.txt" THEN DO:

             FIND FIRST nota-fiscal NO-LOCK
                  WHERE nota-fiscal.cod-estabel = ENTRY(1,ttArquivo.nomeArquivo,"-")
                    AND nota-fiscal.serie       = ENTRY(2,ttArquivo.nomeArquivo,"-")
                    AND nota-fiscal.nr-nota-fis = ENTRY(3,ttArquivo.nomeArquivo,"-") NO-ERROR.

             FIND FIRST param-gener NO-LOCK
                  WHERE param-gener.cod-chave-1 = "param-geral-tc"
                    AND param-gener.cod-param   = "dir-arquivos" NO-ERROR.

             RUN pi-acompanhar in h-acomp("Copiando arquivos " + nota-fiscal.cod-chave-aces-nf-eletro).

             /*RUN pi-gerar-dados-extrato("ponto 11").
             RUN pi-gerar-dados-extrato(c-dir-tmp).*/

             IF tt-param-aux.nr-nota-fis <> "" THEN DO:
                 /*RUN pi-gerar-dados-extrato("ponto 12").
                 RUN pi-gerar-dados-extrato(c-dir-tmp).
                 RUN pi-gerar-dados-extrato(ttArquivo.nomeArquivo).
                 RUN pi-gerar-dados-extrato("ponto 15 marc").*/
             END.                                                                          
             OS-COPY VALUE(c-dir-tmp + ttArquivo.nomeArquivo) VALUE(TRIM(/*param-gener.cod-valor*/ c-caminho-danfe-linux) + "/DANFE/" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf"). 
             //OS-COPY VALUE(c-dir-tmp + ttArquivo.nomeArquivo) VALUE(TRIM("V:\TI\Marcio") + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf").
             OS-DELETE VALUE(c-dir-tmp + ttArquivo.nomeArquivo) NO-ERROR.
         END.
         ELSE 
            RUN OpenDocument(c-dir-tmp + ttArquivo.nomeArquivo). 
      END.
   END.
END.

PROCEDURE pi-cria-tt-moura:
    DEFINE INPUT PARAM p-row-nota AS ROWID.
    DEFINE BUFFER b-item-moura FOR ITEM.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE rowid(nota-fiscal) = p-row-nota NO-ERROR.

    ASSIGN c-itens-moura = "".

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FIND FIRST tt-mail-moura
             WHERE tt-mail-moura.r-nota-fiscal = p-row-nota NO-ERROR.

        RUN esp/es0018p.p (INPUT "esftp0527", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa itens moura*/
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF CAN-FIND (FIRST tt-prog-ponto 
                     WHERE tt-prog-ponto.conteudo = it-nota-fisc.it-codigo) THEN DO:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

            IF NOT AVAIL tt-mail-moura THEN DO:
                CREATE tt-mail-moura.
                ASSIGN tt-mail-moura.r-nota-fiscal = p-row-nota.
            END.

            ASSIGN tt-mail-moura.email-moura = tt-mail-moura.email-moura + ITEM.it-codigo + " - "  + ITEM.desc-item + "," + " Quantidade: "  + string(it-nota-fisc.qt-faturada[1]) + CHR(10).

            IF c-itens-moura = "" THEN
                ASSIGN c-itens-moura = ITEM.desc-item.
            ELSE
                ASSIGN c-itens-moura = c-itens-moura + "," + ITEM.desc-item.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-nf-entreposto:

    DEFINE INPUT PARAM p-row-nota AS ROWID NO-UNDO.

    DEFINE VARIABLE l-remessa AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-venda   AS LOGICAL NO-UNDO.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE rowid(nota-fiscal) = p-row-nota NO-ERROR.

    IF AVAIL nota-fiscal THEN DO:

       FIND estabelec WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

       IF AVAIL estabelec THEN DO:
          IF substring(estabelec.char-1,396,1) = 'S' THEN DO:
             ASSIGN l-remessa = NO
                    l-venda   = NO.
           
             IF nota-fiscal.nome-ab-cli = "SUPPLOG ARMA" THEN DO:
                ASSIGN l-remessa = YES.
             END.  
             
             FOR FIRST fat-ser-lote OF nota-fiscal NO-LOCK:
                 FIND FIRST deposito
                      WHERE deposito.cod-depos = fat-ser-lote.cod-depos 
                 NO-LOCK NO-ERROR. 
             
                 IF AVAIL deposito THEN DO:
                    IF deposito.ind-tipo-dep = 2 THEN //DEPOSITO EXTERNO
                        ASSIGN l-venda = YES.
                 END.
             END.

             IF l-remessa = YES OR l-venda = YES THEN DO:
                 FIND FIRST tt-nf-entreposto
                      WHERE tt-nf-entreposto.rw-nota = p-row-nota                                              
                 NO-ERROR.
                 
                 IF NOT AVAIL tt-nf-entreposto THEN DO:
                    CREATE tt-nf-entreposto.
                    ASSIGN tt-nf-entreposto.rw-nota = p-row-nota
                           tt-nf-entreposto.remessa = l-remessa
                           tt-nf-entreposto.venda   = l-venda.
                 END.  
             END.

          END.
       END.
    END.   

END PROCEDURE.




PROCEDURE run-envia-mail-moura:
    DEFINE INPUT PARAM p-arquivo-danfe AS CHAR.
    DEFINE VARIABLE c-entrega-moura AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-obs-moura     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lista-email   AS CHARACTER   NO-UNDO.
    
    FOR FIRST tt-mail-moura
        WHERE tt-mail-moura.r-nota-fiscal = ROWID(nota-fiscal):

        ASSIGN c-entrega-moura = "Endereáo Entrega: " + nota-fiscal.endereco + CHR(10) 
                                                      + "CEP: " + nota-fiscal.cep + CHR(10)
                                                      + "Cidade: " + nota-fiscal.cidade + CHR(10) 
                                                      + "UF: " + nota-fiscal.estado.
        
        ASSIGN c-obs-moura = "@MOURA gentileza incluir a observaá∆o abaixo em sua NF" + CHR(13) + CHR(13) + 
                             "Produto faz parte da estrutura do item " + c-itens-moura + CHR(13) +
                             "conforme Nota Fiscal " + nota-fiscal.nr-nota-fis + " Emiss∆o: " + string(nota-fiscal.dt-emis).
        
        FIND FIRST transporte NO-LOCK   
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

        FIND FIRST b-ped-venda
             WHERE b-ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
               AND b-ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.

       FIND FIRST b-emitente
            WHERE b-emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
        
        ASSIGN c-lista-email = "".
        FIND FIRST ponto-programa
             where ponto-programa.nome-programa = "ft2100"
               AND ponto-programa.ponto         = 3 NO-LOCK NO-ERROR.
        IF AVAIL ponto-programa THEN DO:
            FOR EACH conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
                IF c-lista-email = "" THEN
                    ASSIGN c-lista-email = conteudo-programa.conteudo.
                ELSE
                    ASSIGN c-lista-email = c-lista-email + "," + conteudo-programa.conteudo.
        
            END.
        END.
        RUN piEnviaEmailAtendente(INPUT c-lista-email /*atendente.email*/,
                                  INPUT "Faturamento de baterias MOURA",
                                  INPUT "Nota Fiscal n£mero: " + string(nota-fiscal.nr-nota-fis) + CHR(13) +
                                        "CNPJ: " + nota-fiscal.cgc + " - " + b-emitente.nome-abrev + CHR(13) +
                                        "Pedido n£mero: " + string(b-ped-venda.nr-pedcli) + CHR(13) + CHR(13) +
                                        "Foram faturados os produtos: " + chr(13) + 
                                        tt-mail-moura.email-moura + CHR(13) + CHR(13) +
                                        c-entrega-moura + chr(13) + chr(13) +
                                        c-obs-moura,
                                  INPUT p-arquivo-danfe ).
        
    END.

END PROCEDURE.

PROCEDURE piEnviaEmailAtendente :
    
    DEFINE INPUT  PARAM pDestino   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAnexo     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    empty temp-table tt-envio2.
    empty temp-table tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                 /* Destinatˇrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pAnexo                   /* Arquivo Temporˇrio */
           tt-envio2.formato           = "TEXTO".
    
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem    = 1
           tt-mensagem.mensagem        = pDescEmail + CHR(13). /* Mensagem */
    
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.

         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.

    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 
    
END PROCEDURE.




PROCEDURE pi-busca-xml-nota:

   DEF INPUT  PARAM p-rowid-nota  AS ROWID  NO-UNDO.
   DEF OUTPUT PARAM p-caminho-xml AS CHAR   NO-UNDO. 

   DEFINE VARIABLE h-bodi135na   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE h-bodi520     AS HANDLE  NO-UNDO.
   
   DEFINE VARIABLE c-key               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE l-utiliza-docto-tag AS LOGICAL   NO-UNDO.
   
   DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
       
   DEFINE VARIABLE c-cod-dir-histor-xml       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-caminho-xml          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-dir-arq-xml-nfse     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-dir-histor-xml-nfse  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cChaveAcesso               AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cCodDocto                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXML                AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXMLCancel          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXMLInut            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cDiretorioHistoricoXML     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cFileName                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cPathName                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cTypeDesc                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoFinalTC2           AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE tp-integ                   AS CHARACTER   NO-UNDO.
   
   DEFINE VARIABLE  rNotaFiscal AS ROWID       NO-UNDO.
   
   DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-nota-fisc AS CHARACTER   NO-UNDO.


   IF NOT VALID-HANDLE (h-bodi520) THEN DO:
       RUN dibo/bodi520.p PERSISTENT SET h-bodi520.
       RUN openQueryStatic IN h-bodi520 (INPUT "Main":U).
   END.
   
   IF  NOT VALID-HANDLE(h-bodi135na) THEN DO:
       RUN dibo/bodi135na.p PERSISTENT SET h-bodi135na.
       RUN openQueryStatic IN h-bodi135na (INPUT "Main":U).
   END.


   FOR EACH tt-historico-xml: DELETE tt-historico-xml. END.
   FOR EACH tt-histor-tag-complete. DELETE tt-histor-tag-complete. END.
   
   // Busca a Nota Fiscal a partir do ROWID passado como parametro

   FIND FIRST nota-fiscal 
        WHERE ROWID(nota-fiscal) = p-rowid-nota
   NO-LOCK NO-ERROR.
   
   IF AVAIL nota-fiscal THEN
      ASSIGN c-estab     = nota-fiscal.cod-estabel
             c-serie    = nota-fiscal.serie
             rNotaFiscal = ROWID(nota-fiscal).
   
   
   RUN repositionRecord IN h-bodi135na (INPUT rNotaFiscal).
   
   RUN getCharField     IN h-bodi135na (INPUT  "cod-chave-aces-nf-eletro":U,
                                        OUTPUT cChaveAcesso).
   RUN getCharField     IN h-bodi135na (INPUT  "cod-estabel":U,
                                        OUTPUT c-estab).
   RUN getCharField     IN h-bodi135na (INPUT  "serie":U,
                                        OUTPUT c-serie).
   RUN getCharField     IN h-bodi135na (INPUT  "nr-nota-fis":U,
                                        OUTPUT c-nota-fisc).
   RUN getCharField     IN h-bodi135na (INPUT  "cod-rps":U,
                                        OUTPUT cCodDocto).
   
   
   RUN goToKey          IN h-bodi520   (INPUT c-estab).
                                      
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-histor-xml":U,
                                        OUTPUT c-cod-dir-histor-xml).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-caminho-xml":U,
                                        OUTPUT c-cod-caminho-xml).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-arq-xml-nfse":U,
                                        OUTPUT c-cod-dir-arq-xml-nfse).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-histor-xml-nfse":U,
                                        OUTPUT c-cod-dir-histor-xml-nfse).
   
   FOR FIRST ser-estab
       WHERE ser-estab.cod-estab = c-estab
         AND ser-estab.serie     = c-serie no-lock:
   
       /* NFS-e */
       IF &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
              ser-estab.log-emite-nf-serv-eletro
          &ELSE
              SUBSTRING(ser-estab.char-1,71,1) = "S":U
          &ENDIF
       THEN DO:
   
           RUN cdp/cd0360b.p (INPUT c-estab,
                              INPUT "NFS-e",
                              OUTPUT tp-integ).
       
           IF  tp-integ = 'TC2' THEN DO:
               
               FOR EACH param-gener NO-LOCK WHERE
                   param-gener.cod-chave-1 = "param-geral-tc" :
   
                   CASE param-gener.cod-param:
                       WHEN "dir-doctos-lidos":U THEN
                           ASSIGN cArquivoXML = param-gener.cod-valor. /*Pasta Received*/
               
                       WHEN "dir-arquivos":U THEN
                           ASSIGN cDiretorioHistoricoXML = param-gener.cod-valor. /*Pasta SENT*/
               
                   END CASE.
               
               END.
   
               IF (cArquivoXML            = ""
               OR  cDiretorioHistoricoXML = "") THEN NEXT.
   
               ASSIGN cArquivoXML            = replace(cArquivoXML,"~/","\")
                      cDiretorioHistoricoXML = replace(cDiretorioHistoricoXML,"~/","\").
               
               IF  SUBSTRING(cArquivoXML, LENGTH(cArquivoXML), 1) <> "\" THEN
                   ASSIGN cArquivoXML = cArquivoXML + "\".
               ASSIGN cArquivoXML = cArquivoXML + "RECEIVED\".
               
               IF  SUBSTRING(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) <> "\" THEN
                   ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "\".
               ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "SENT\".
   
               IF  cCodDocto = "" THEN
                   ASSIGN cCodDocto = c-nota-fisc.
   
               FOR EACH integr-totvs-colab NO-LOCK WHERE
                   (integr-totvs-colab.cod-edi   = "203" OR
                    integr-totvs-colab.cod-edi   = "204") AND
                    integr-totvs-colab.cod-docto = TRIM(c-serie) + STRING(DEC(cCodDocto),"999999999"):
       
                   ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                 THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                 ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
       
                    ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                   STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                   STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                   integr-totvs-colab.hra-reg
       
                              tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                      THEN "ENV - ":U
                                                                      ELSE "RET - ":U
       
                              tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
       
                       CASE integr-totvs-colab.cod-edi:
                           WHEN "203" THEN DO:
                                IF  integr-totvs-colab.cod-origem = 2 AND
                                    TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                ELSE
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                           END.
                           WHEN "204" THEN DO:
                               ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                           END.
                       END CASE.
       
                   END.
               END.
   
               FOR FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = c-estab:
               END.
   
               FOR EACH integr-totvs-colab NO-LOCK WHERE
                   (integr-totvs-colab.cod-edi   = "203" OR
                    integr-totvs-colab.cod-edi   = "204") AND
                    integr-totvs-colab.cod-docto = TRIM(STRING(estabelec.cgc, '99999999999999')) + TRIM(c-serie) + STRING(DEC(cCodDocto),"999999999"):
       
                   ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                 THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                 ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
       
                    ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                   STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                   STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                   integr-totvs-colab.hra-reg
       
                              tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                      THEN "ENV - ":U
                                                                      ELSE "RET - ":U
       
                              tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
       
                       CASE integr-totvs-colab.cod-edi:
                           WHEN "203" THEN DO:
                                IF  integr-totvs-colab.cod-origem = 2 AND
                                    TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                ELSE
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                           END.
                           WHEN "204" THEN DO:
                               ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                           END.
                       END CASE.
       
                   END.
               END.
           END.
           ELSE DO:
               /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/
               IF  c-cod-dir-arq-xml-nfse <> "" THEN DO:
       
                   ASSIGN cArquivoXML = c-cod-dir-arq-xml-nfse
                          cArquivoXML = REPLACE(cArquivoXML,"~\","/").
       
                   IF  NOT SUBSTR(cArquivoXML, LENGTH(cArquivoXML), 1) = "/"  THEN
                       ASSIGN cArquivoXML = cArquivoXML + "/".
       
                   ASSIGN cArquivoXML = TRIM(cArquivoXML)
                                      + TRIM(c-estab)
                                      + TRIM(c-serie)
                                      + TRIM(STRING(INTEGER(c-nota-fisc),">>9999999")).
       
       
                   ASSIGN cArquivoXMLCancel = cArquivoXML + "_Cancel":U + ".xml":U
                          cArquivoXMLInut   = cArquivoXML + "_Inut":U + ".xml":U
                          cArquivoXML       = cArquivoXML + ".xml":U.
               END.
               /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
               /***** Busca Historico XML *****/
               IF  c-cod-dir-histor-xml-nfse <> "" THEN DO:
       
                   ASSIGN cDiretorioHistoricoXML = c-cod-dir-histor-xml-nfse
                          cDiretorioHistoricoXML = REPLACE(cDiretorioHistoricoXML,"~\","/").
       
                   IF  NOT SUBSTR(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) = "/"  THEN
                       ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "/".
       
                   ASSIGN cDiretorioHistoricoXML = TRIM(cDiretorioHistoricoXML)
                                                 + TRIM(c-estab)
                                                 + TRIM(c-serie)
                                                 + TRIM(STRING(INTEGER(c-nota-fisc),">>9999999")).
               END.
               /** Fim - Busca Historico XML **/
   
           END.
          
       END.
       ELSE DO:
           /* NF-e */
           IF &IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN
                  ser-estab.log-nf-eletro
              &ELSE
                  TRIM(SUBSTRING(ser-estab.char-1,1,03)) = "yes":U
              &ENDIF
           THEN DO:
               
               RUN cdp/cd0360b.p (INPUT c-estab,
                                  INPUT "NF-e",
                                  OUTPUT tp-integ).
   
               IF  tp-integ = 'TC2' THEN DO:
   
                   FOR EACH param-gener NO-LOCK WHERE
                       param-gener.cod-chave-1 = "param-geral-tc" :
                   
                       CASE param-gener.cod-param:
                           WHEN "dir-doctos-lidos":U THEN
                               ASSIGN cArquivoXML = param-gener.cod-valor. /*Pasta Received*/
                   
                           WHEN "dir-arquivos":U THEN
                               ASSIGN cDiretorioHistoricoXML = param-gener.cod-valor. /*Pasta SENT*/
                   
                       END CASE.
                   
                   END.
   
                   IF (cArquivoXML            = ""
                   OR  cDiretorioHistoricoXML = "") THEN NEXT.
   
                   ASSIGN cArquivoXML            = replace(cArquivoXML,"~/","\")
                          cDiretorioHistoricoXML = replace(cDiretorioHistoricoXML,"~/","\").
                   
                   IF  SUBSTRING(cArquivoXML, LENGTH(cArquivoXML), 1) <> "\" THEN
                       ASSIGN cArquivoXML = cArquivoXML + "\".
                   ASSIGN cArquivoXML = cArquivoXML + "RECEIVED\".
                   
                   IF  SUBSTRING(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) <> "\" THEN
                       ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "\".
                   ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "SENT\".
           
                   FOR EACH integr-totvs-colab NO-LOCK WHERE
                       integr-totvs-colab.cod-edi   >= "170" AND
                       integr-totvs-colab.cod-edi   <= "172" AND
                       integr-totvs-colab.cod-docto = cChaveAcesso:
           
                       ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                     THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                     ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
           
                                                          
                       
                       ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                           CREATE tt-historico-xml.
                           ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                       STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                       STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                       integr-totvs-colab.hra-reg
           
                                  tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                          THEN "ENV - ":U
                                                                          ELSE "RET - ":U
           
                                  tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
           
                           CASE integr-totvs-colab.cod-edi:
                               WHEN "170" THEN DO:
                                    IF  integr-totvs-colab.cod-origem = 2 AND
                                        TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                        ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                    ELSE
                                        ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                               END.
                               WHEN "171" THEN DO:
                                   ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                               END.
                               WHEN "172" THEN DO:
                                   ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Inutilizaá∆o".
                               END.
                           END CASE.
           
                       END.
           
                   END.
           
               END.
               ELSE DO:
   
                   /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/                                        
                   IF  c-cod-caminho-xml <> "" THEN DO:
       
                       ASSIGN cArquivoXML = c-cod-caminho-xml                                                             
                              cArquivoXML = REPLACE(cArquivoXML,"~\","/").                                                
       
                       IF  NOT SUBSTR(cArquivoXML, LENGTH(cArquivoXML), 1) = "/"  THEN                
                           ASSIGN cArquivoXML = cArquivoXML + "/".                                                        
       
                       ASSIGN cArquivoXML = TRIM(cArquivoXML)                                                             
                                          + TRIM(STRING(c-estab,"x(05)"))                                                
                                          + SUBSTR(cChaveAcesso,23,3)                                                     
                                          + TRIM(STRING(INTEGER(SUBSTR(cChaveAcesso,26,9)),">>9999999")).                
       
                       ASSIGN cArquivoXMLCancel = cArquivoXML + "_Cancel":U + ".xml":U
                              cArquivoXMLInut   = cArquivoXML + "_Inut":U + ".xml":U
                              cArquivoXML       = cArquivoXML + ".xml":U.
                   END.
                   /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
                   /***** Busca Historico XML *****/
                   IF  c-cod-dir-histor-xml <> "" THEN DO:
       
                       ASSIGN cDiretorioHistoricoXML = c-cod-dir-histor-xml
                              cDiretorioHistoricoXML = REPLACE(cDiretorioHistoricoXML,"~\","/").
       
                       IF  NOT SUBSTR(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) = "/"  THEN
                           ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "/".
       
                       ASSIGN cDiretorioHistoricoXML = TRIM(cDiretorioHistoricoXML)
                                                     + TRIM(STRING(c-estab,"x(05)"))
                                                     + SUBSTR(cChaveAcesso,23,3)
                                                     + TRIM(STRING(INTEGER(SUBSTR(cChaveAcesso,26,9)),">>9999999")).
                   END.
                   /** Fim - Busca Historico XML **/
               END.
           END.
       END.
   END.
   
   IF  tp-integ <> "TC2":U THEN DO:
       /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXMLCancel.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Cancelamento":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXMLInut.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Inutilizaá∆o":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXML.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Autorizaá∆o":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
       /***** Busca Historico XML *****/
       ASSIGN FILE-INFO:FILE-NAME = cDiretorioHistoricoXML.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO: /* diretorio existe? */
           INPUT FROM OS-DIR(cDiretorioHistoricoXML) CONVERT TARGET "iso8859-1":U.
           REPEAT:
               IMPORT cFileName cPathName cTypeDesc.
               IF  cTypeDesc <> "D" THEN DO:
                   ASSIGN FILE-INFO:FILE-NAME = cPathName.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                                  + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                                  + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                                  + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                              tt-historico-xml.des-historico    = "Hist¢rico":U
                              tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
                   END.
               END.
           END.
       END.
       /** Fim - Busca Historico XML **/
   END.
   
   /* Tratamentos para a aba Hist. Tag */
   IF CAN-FIND(FIRST estabelec
               WHERE estabelec.cod-estabel = c-estab
                 AND estabelec.log-utiliza-docto-tag = YES) THEN DO:
       
       ASSIGN c-key = c-estab + "|" + c-serie + "|" + c-nota-fisc
              l-utiliza-docto-tag = YES.
   
       FOR EACH histor-tag NO-LOCK
          WHERE histor-tag.nom-tab-histor-tag = "nota-fiscal"
            AND histor-tag.cod-histor-tag = c-key
            BREAK BY histor-tag.cdn-seq-histor-tag:
   
           IF LAST-OF(histor-tag.cdn-seq-histor-tag) THEN DO:
               CREATE tt-histor-tag.
               BUFFER-COPY histor-tag TO tt-histor-tag
               ASSIGN tt-histor-tag.dt-formated = STRING(tt-histor-tag.dtm-histor-tag).
           END.
   
           CREATE tt-histor-tag-complete.
           BUFFER-COPY histor-tag TO tt-histor-tag-complete.
       END.
   END.


   FOR EACH tt-historico-xml
       WHERE tt-historico-xml.des-historico MATCHES 'RET - Autoriza*':
       
       /*DISP tt-historico-xml.dta-historico  
            tt-historico-xml.des-historico  
            tt-historico-xml.cod-arquivo-xml WITH WIDTH 333 1 COL.*/

       ASSIGN p-caminho-xml = tt-historico-xml.cod-arquivo-xml.
   END.

      
END PROCEDURE.



PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR NO-UNDO.

    DEFINE VARIABLE i-cont     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER    NO-UNDO.
    
    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN NEXT.
           when "b" THEN NEXT.
           when "c" THEN NEXT.
           when "d" THEN NEXT.
           when "e" THEN NEXT.
           when "f" THEN NEXT.
           when "g" THEN NEXT.
           when "h" THEN NEXT.
           when "i" THEN NEXT.
           when "j" THEN NEXT.
           when "k" THEN NEXT.
           when "l" THEN NEXT.
           when "m" THEN NEXT.
           when "n" THEN NEXT.
           when "o" THEN NEXT.
           when "p" THEN NEXT.
           when "q" THEN NEXT.
           when "r" THEN NEXT.
           when "s" THEN NEXT.
           when "t" THEN NEXT.
           when "u" THEN NEXT.
           when "v" THEN NEXT.
           when "w" THEN NEXT.
           when "x" THEN NEXT.
           when "y" THEN NEXT.
           when "z" THEN NEXT.
           when " " THEN NEXT.
           when "0" THEN NEXT.
           when "1" THEN NEXT.
           when "2" THEN NEXT.
           when "3" THEN NEXT.
           when "4" THEN NEXT.
           when "5" THEN NEXT.
           when "6" THEN NEXT.
           when "7" THEN NEXT.
           when "8" THEN NEXT.
           when '9' THEN NEXT.
           when '"' THEN NEXT.
           when "'" THEN NEXT.
           when "!" THEN NEXT.
           when "[" THEN NEXT.
           when "]" THEN NEXT.
           when "@" THEN NEXT.
           when "#" THEN NEXT.
           when "$" THEN NEXT.
           when "%" THEN NEXT.
           when "&" THEN NEXT.
           when "*" THEN NEXT.
           when "(" THEN NEXT.
           when ")" THEN NEXT.
           when "-" THEN NEXT.
           when "_" THEN NEXT.
           when "=" THEN NEXT.
           when "+" THEN NEXT.
           when "<" THEN NEXT.
           when ">" THEN NEXT.
           when "," THEN NEXT.
           when "." THEN NEXT.
           when ":" THEN NEXT.
           when ";" THEN NEXT.
           when "?" THEN NEXT.
           when "/" THEN NEXT.
           when "~\" THEN NEXT.
           OTHERWISE do:
               
               ASSIGN OVERLAY(c-texto,i-cont,1) = "".
           END.
       END.
    END.

END PROCEDURE.


PROCEDURE pi-remessa-entreposto:

    ASSIGN c-ean      = ""
           c-qt-caixa = "".
    
    FOR FIRST item-mat NO-LOCK
        WHERE item-mat.it-codigo = ITEM.it-codigo:
        ASSIGN c-ean = item-mat.cod-ean.  /*ean13*/
    END.
    
    ASSIGN c-desc-item = ITEM.desc-item
           c-descricao = ITEM.descricao-1.

    RUN RetiraAcentos (INPUT-OUTPUT c-desc-item).
    RUN RetiraAcentos (INPUT-OUTPUT c-descricao).
    
    ASSIGN c-desc-item = fn-free-accent(UPPER(TRIM(c-desc-item)))
           c-descricao = fn-free-accent(UPPER(TRIM(c-descricao))).
    
    PUT STREAM s-arq-rmssa
        UNFORMATTED 'I'                  '|'
        TRIM(item-uni-estab.it-codigo)   '|'
        c-desc-item                      '|'
        c-descricao FORMAT "x(18)"       '|'.
        
    IF AVAIL item-caixa THEN  
       ASSIGN c-qt-caixa = STRING(ITEM-caixa.qt-item).
       
    PUT STREAM s-arq-rmssa
        UNFORMATTED /*c-qt-caixa*/  '1' '|'.
      
    PUT STREAM s-arq-rmssa
        UNFORMATTED  ITEM.un            '|'
        ITEM.cod-unid-neg               '|'
        {ininc/i03in172.i 4 item-uni-estab.classif-abc}  FORMAT 'x'    '|'
        c-ean                           '|'
        TRIM(ITEM.it-codigo)            '|'.
        
    IF AVAIL embalag THEN 
       PUT STREAM s-arq-rmssa
           UNFORMATTED  
           TRIM(STRING(dec(embalag.altura  / 1000))) '|'
           TRIM(STRING(dec(embalag.largura / 1000))) '|'
           TRIM(STRING(dec(embalag.comprim / 1000))) '|'.
    ELSE PUT '0|0|0|'.
    
    PUT STREAM s-arq-rmssa
        UNFORMATTED  '1'                 '|'
        '1'                              '|'
        TRIM(STRING(ITEM.peso-liquido))  '|'
        TRIM(STRING(ITEM.peso-bruto))    '|'
        TRIM(ITEM.class-fiscal)          '|'
        TRIM(c-desc-item)                '|'
        TRIM(c-descricao) FORMAT "x(18)" '|'
        'N'                              '|'
        'N'                              '|'                
        'S'                              '|'.
        
    FIND FIRST item-dun WHERE item-dun.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR. 

    IF AVAIL item-dun THEN
       PUT STREAM s-arq-rmssa item-dun.cod-dun '|'.
    ELSE 
       PUT STREAM s-arq-rmssa ' |'.
    
    PUT STREAM s-arq-rmssa '' SKIP.

END PROCEDURE.
/* fim do programa */


PROCEDURE pi-gerar-dados-extrato:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT  p-string  FORMAT "x(200)" SKIP.
       OUTPUT CLOSE. 
    
    end.
END PROCEDURE.
