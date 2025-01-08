/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT0518RP 2.00.00.004 } /*** 010004 ***/


/*     MESSAGE "PROGRAMA DESATIVADO POR SOLICITACAO SR. THIAGO GOULART - CHAMADO 29654" */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                           */
/*                                                      RETURN.                         */
/*                                                                                      */
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ft0518rp MFT}
&ENDIF

/*****************************************************************************
**       Programa: FT0518rp.p
**       Data....: 14/03/07
**       Autor...: DATASUL S.A.
**       Objetivo: Emissor DANFE - NF-e
**       Vers∆o..: 1.00.000 - super
**       OBS.....: Este fonte foi gerado pelo Data Viewer 3.00
*******************************************************************************/

/*define variable c-prog-gerado as character no-undo initial "FT0518rp".

def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.*/

/****************** Definiá∆o de Tabelas Tempor†rias do Relat¢rio **********************/

define temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-param-aux
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
    field ep-codigo            LIKE mguni.empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field c-cod-estabel        like nota-fiscal.cod-estabel
    field c-serie              like nota-fiscal.serie
    field c-nr-nota-fis-ini    like nota-fiscal.nr-nota-fis
    field c-nr-nota-fis-fim    like nota-fiscal.nr-nota-fis
    field de-cdd-embarque-ini  like nota-fiscal.cdd-embarq
    field de-cdd-embarque-fim  like nota-fiscal.cdd-embarq
    field da-dt-saida          like nota-fiscal.dt-saida
    field c-hr-saida           like nota-fiscal.hr-confirma
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as INTEGER
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    field l-gera-danfe-xml as logical
    field c-dir-hist-xml   as character.

define temp-table tt-log-danfe-xml NO-UNDO
    field seq           as int
    field c-nr-nota-xml as character
    field c-chave-xml   as character.
    
DEFINE VARIABLE h-esft066 AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cnpj        AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD codigo      AS CHAR
    FIELD indefinido1 AS CHAR FORMAT "x(100)"
    FIELD indefinido2 AS CHAR FORMAT "x(100)"
    FIELD indefinido3 AS CHAR FORMAT "x(100)"
    FIELD iLinha      AS INT
    FIELD FullPath    AS CHAR
    FIELD FILENAME    AS CHAR
    INDEX ch_principal cnpj serie nr-nota-fis.

/****************** Parametros **********************/

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEF TEMP-TABLE ttArquivo NO-UNDO
      FIELD sequencia AS INT
      FIELD nomeArquivo AS CHAR
      INDEX idx1 sequencia.

define new shared temp-table tt-notas-impressas field r-nota as rowid. 


{bcp/bcapi004.i}
{cdp/cd0666.i}
{cdp/cdcfgdis.i}

/*************************
*   definicao de buffer
*************************/
def buffer b-nota-fiscal for nota-fiscal.
                                                              
{ftp/ft2010.i1} /* Definicao da temp-table tt-notas-geradas */ 

{ftp/ft0518rp.i1 "NEW"} /* Definiá∆o temp-table ttCaracteres como NEW SHARED */
{ftp/ft0518rp.i2}       /* Criaá∆o registros temp-table ttCaracteres e ttColunasDANFE */

/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/

{utp/ut-glob.i}

/****  Variaveis Compartilhadas  ****/
DEFINE NEW SHARED VAR r-nota       AS ROWID.
DEFINE NEW SHARED VAR c-hr-saida   AS CHAR    FORMAT "xx:xx:xx" INIT "000000".
DEFINE NEW SHARED VAR l-dt         AS LOGICAL FORMAT "Sim/Nao"  INIT NO.
/*Definiá∆o da vari†veis para busca no xml*/
DEFINE NEW SHARED VARIABLE c-nr-nota-xml AS character.
DEFINE NEW SHARED VARIABLE c-chave-xml   AS character.   
DEFINE NEW SHARED VARIABLE l-gera-danfe-xml   AS logical.   
DEFINE NEW SHARED VARIABLE c-cod-dir-histor-xml AS character. 
                       

/***************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

def var h-acomp              as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.
def var v-num-linha          as int    no-undo.
def var v-cont-registro      as int    no-undo.
def var v-des-retorno        as char   no-undo.
def var v-des-local-layout   as char   no-undo.
def var c-arquivo-continua   as char   no-undo.
DEF VAR lSemWord             AS LOG    NO-UNDO.

DEF VAR da-dt-saida          AS DATE   NO-UNDO.
DEF VAR c-cod-layout         AS CHAR   NO-UNDO.
DEF VAR l-mais-itens         AS LOG    NO-UNDO INIT NO.
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-cod-estabel      like nota-fiscal.cod-estabel format "x(05)"       initial "" no-undo.
&ELSE
def var c-cod-estabel      like nota-fiscal.cod-estabel format "X(3)"       initial "" no-undo.
&ENDIF
def var c-serie            like nota-fiscal.serie       format "x(5)"       initial "" no-undo.
def var r-ped-venda     as rowid.
def var r-pre-fat       as rowid.
def var r-emitente      as rowid.
def var r-estabel       as rowid.
def var r-docum-est     as rowid.
DEF VAR r-ser-estab     AS ROWID.
def var r-natur-oper   as rowid.
def var l-tipo-nota     as logical format "Entrada/Saida" no-undo.

def var cont as integer no-undo.
def var i-sit-nota-ini    as integer.
def var i-sit-nota-fim    as integer.
DEF VAR l-reimp           AS LOGICAL NO-UNDO.

/* Impressao baseado no PDF */
DEFINE VARIABLE c-arquivoImp    AS CHARACTER FORMAT 'X(150)'    NO-UNDO.
DEFINE VARIABLE c-caminhoUnix   AS CHARACTER FORMAT 'X(150)'    NO-UNDO.
DEFINE VARIABLE c-caminhoWin    AS CHARACTER FORMAT 'X(150)'    NO-UNDO.
DEFINE VARIABLE erroImp         AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-contImp       AS INTEGER                      NO-UNDO.
DEFINE VARIABLE l-impressaoFCom AS LOGICAL   INIT NO            NO-UNDO.
DEFINE STREAM dirlist.

/* N∆o encontra DANFE - Verifica XML SEFAZ*/
DEFINE VARIABLE c-arquivoXMLEnv AS CHARACTER FORMAT 'X(150)'    NO-UNDO.
DEFINE VARIABLE l-erroImpressao AS LOGICAL   INIT NO            NO-UNDO.

DEFINE TEMP-TABLE tt-ft0910 NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli-ini   LIKE nota-fiscal.nome-ab-cli
    FIELD nome-ab-cli-fim   LIKE nota-fiscal.nome-ab-cli
    FIELD dt-emis-nota-ini  LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim  LIKE nota-fiscal.dt-emis-nota
    FIELD gera-nfe-n-gerada AS LOGICAL
    FIELD gera-nfe-gerada   AS LOGICAL
    FIELD exporta-est-txt   AS LOGICAL
    FIELD gera-nfe-cancel   AS LOGICAL
    FIELD gera-nfe-inut     AS LOGICAL
    FIELD c-motivo          AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-ft0910 NO-UNDO
    FIELD raw-digita AS RAW.


define stream arq-erro.
def var c-arquivo as char format "X(40)".

create tt-param-aux.
raw-transfer raw-param to tt-param-aux.
assign l-gera-danfe-xml = tt-param-aux.l-gera-danfe-xml
       c-cod-dir-histor-xml = tt-param-aux.c-dir-hist-xml.


{include/i-rpvar.i}

assign c-programa     = "FT0518rp":U
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-titulo-relat = "Emissor DANFE - NF-e"
       c-sistema      = "mft".

{varinc/var00002.i}

run utp/ut-acomp.p persistent set h-acomp.

find first mguni.empresa no-lock
    where mguni.empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail mguni.empresa
then
    assign c-empresa  = mguni.empresa.razao-social.
else
    assign c-empresa = "".

/* run setConstant in h-FunctionLibrary ("cCompany", c-empresa).                */
/* run setConstant in h-FunctionLibrary ("cReportTitle", c-titulo-relat).       */
/* run setConstant in h-FunctionLibrary ("cSystem", c-sistema).                 */
/* run setConstant in h-FunctionLibrary ("cProgram", c-programa).               */
/* run setConstant in h-FunctionLibrary ("cVersion", c-versao).                 */
/* run setConstant in h-FunctionLibrary ("cRevision", c-revisao).               */
/* run setConstant in h-FunctionLibrary ("cCurrentUser", tt-param-aux.usuario). */
/* run setConstant in h-FunctionLibrary ("cActualDate", STRING(TODAY)).         */
/* run setConstant in h-FunctionLibrary ("cActualHour", STRING(TIME)).          */

/**** EXECUCAO RELATORIO GRAFICO ****/
case tt-param-aux.destino:
    when 1 then assign v-cod-destino-impres = "Impressora".
    when 2 then assign v-cod-destino-impres = "Arquivo".
    otherwise   assign v-cod-destino-impres = "Terminal".
end case.

/*run printForm in h-FunctionLibrary.*/

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input "Acompanhamento Relat¢rio").

assign v-num-reg-lidos = 0.
EMPTY TEMP-TABLE ttArquivo.

for each tt-notas-impressas:
    delete tt-notas-impressas.
end.

if tt-param-aux.data-exec <> ? then 
   assign l-dt = yes.
else 
   assign l-dt = no.

   assign c-cod-estabel     = tt-param-aux.c-cod-estabel
          c-serie           = tt-param-aux.c-serie
          da-dt-saida       = tt-param-aux.da-dt-saida
          c-hr-saida        = string(tt-param-aux.c-hr-saida,"99:99:99")
          c-cod-layout      = tt-param-aux.cod-layout
          l-gera-danfe-xml  = tt-param-aux.l-gera-danfe-xml
          c-nr-nota-fis-ini = c-nr-nota-fis-ini
          c-nr-nota-fis-fim = c-nr-nota-fis-fim.

   IF c-nr-nota-fis-fim = "" THEN
       ASSIGN c-nr-nota-fis-fim = "ZZZZZZZZZZZZZZZZ". 

if   tt-param-aux.rs-imprime = 1 then
     assign i-sit-nota-ini = 1
            i-sit-nota-fim = 7
            l-reimp        = NO.
else assign i-sit-nota-ini = 2
            i-sit-nota-fim = 7
            l-reimp        = YES.

for each nota-fiscal no-lock
   where nota-fiscal.cod-estabel  = c-cod-estabel      
     and nota-fiscal.serie        = c-serie
     and nota-fiscal.nr-nota-fis >= c-nr-nota-fis-ini
     and nota-fiscal.nr-nota-fis <= c-nr-nota-fis-fim
     and nota-fiscal.cdd-embarq  >= de-cdd-embarque-ini 
     and nota-fiscal.cdd-embarq  <= de-cdd-embarque-fim 
     and   nota-fiscal.ind-sit-nota >= i-sit-nota-ini
     and   nota-fiscal.ind-sit-nota <= i-sit-nota-fim  
     break by nota-fiscal.cod-estabel
           by nota-fiscal.serie
           by nota-fiscal.nr-nota-fis:

    IF nota-fiscal.dt-cancel <> ? THEN NEXT.

    ASSIGN l-impressaoFCom  = YES.

    IF  tt-param-aux.rs-imprime = 1
    AND NOT CAN-FIND (FIRST fat-comercial
                 WHERE fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                   AND fat-comercial.serie       = nota-fiscal.serie      
                   AND fat-comercial.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN
        ASSIGN l-impressaoFCom = NO.

    IF l-impressaoFCom = YES THEN DO:

        IF nota-fiscal.ind-sit-nota = 1 THEN DO:
            RUN esp/ftp/esft066rp.p PERSISTENT SET h-esft066.
            run pi-atualiza-status IN h-esft066 (input nota-fiscal.cod-estabel,
                                                 input nota-fiscal.serie,
                                                 input string(int(nota-fiscal.nr-nota-fis)),
                                                 INPUT-OUTPUT TABLE tt-import). 
            DELETE PROCEDURE h-esft066.
            /* muda o status da nota-fiscal */

            assign r-nota = rowid(nota-fiscal).

        END.

        &IF DEFINED (bf_dis_nfe) &THEN                                                                       
            &IF "{&bf_dis_versao_ems}" >= "2.07" &THEN                                                       

                IF 
                    /*(nota-fiscal.idi-forma-emis-nf-eletro  = 1        /* Tipo de Emiss∆o   = Normal                  */
               AND  nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */ 
                OR */
                   (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss∆o   = Contingencia DPEC       */
               AND  nota-fiscal.idi-sit-nf-eletro        <> 15       /* Situaá∆o da nota <> DPEC recebido pelo SCE  */
               AND  nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */ 
                OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss∆o  <> Normal                  */
               AND  nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss∆o  <> Contingencia DPEC       */
               AND  nota-fiscal.idi-sit-nf-eletro         = 5 ) THEN /* Situaá∆o da nota  = Documento Rejeitado */
                   NEXT.
            &ELSE
                IF  SUBSTR(nota-fiscal.char-2,65,2) = '' THEN 
                    NEXT.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '1' THEN DO: /*Tp Emis 1 = Normal*/

                    FIND FIRST sit-nf-eletro NO-LOCK
                         WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                           AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                           AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                    IF  NOT AVAIL sit-nf-eletro OR sit-nf-eletro.idi-sit-nf-eletro <> 3 THEN /*Sit 3 = Uso Autorizado*/
                        NEXT.
                END.
                IF SUBSTR(nota-fiscal.char-2,65,2) = '4' THEN DO: /*Tp Emis 4 = Contingància DPEC*/

                    FIND FIRST sit-nf-eletro NO-LOCK
                         WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                           AND sit-nf-eletro.cod-serie     = nota-fiscal.serie      
                           AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis NO-ERROR.
                    IF  NOT AVAIL sit-nf-eletro OR (sit-nf-eletro.idi-sit-nf-eletro <> 15 AND sit-nf-eletro.idi-sit-nf-eletro <> 3) THEN /*Sit 15 = DPEC recebido pelo SCE*/
                        NEXT.
                END.
            &ENDIF
        &ENDIF

        /* SE ESTIVER MARCADO PARA GERAR DANFE PELO XML, MONTA O NOME DOS ARQUIVOS COM BASE: 
       1-c-nr-nota-xml - Estabelecimento, SÇrie e Nro. da nota 
       2-c-chave-xml   - Chave de Acesso */
    IF l-gera-danfe-xml THEN  DO: 
        ASSIGN c-nr-nota-xml = TRIM(nota-fiscal.cod-estabel) +                              
                               SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,23,3) + 
                               TRIM(STRING(INTEGER(SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,26,9)),">>9999999")) + ".XML"
                           
               c-chave-xml = TRIM(nota-fiscal.cod-chave-aces-nf-eletro) + ".XML".    
                 
       /* SE N«O ENCONTRAR O ARQUIVO .XML NO DIRET‡RIO VAI PARA O PR‡XIMO REGISTRO */    
       IF((SEARCH(c-cod-dir-histor-xml + "/" + c-nr-nota-xml) = ? AND
           SEARCH(c-cod-dir-histor-xml + "/" + c-chave-xml) = ?)) THEN DO:   
           
           /*CRIA TEMP-TABLE COM INFORMAÄÂES DAS NOTAS EM 
             QUE O XML N«O FOI ENCONTRADO NO DIRET‡RIO*/
           assign cont = cont + 1.  
           create tt-log-danfe-xml.
           assign tt-log-danfe-xml.seq           = cont
                  tt-log-danfe-xml.c-nr-nota-xml = trim(nota-fiscal.nr-nota-fis)
                  tt-log-danfe-xml.c-chave-xml   = trim(replace(c-chave-xml, ".XML", " ")).              

            NEXT.
       END.
    END.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gerando_DANFE_para_nota" *}
    run pi-acompanhar in h-acomp(RETURN-VALUE + " " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).

    assign v-num-reg-lidos = v-num-reg-lidos + 1.

        if  first-of(nota-fiscal.nr-nota-fis) then do:
            assign v-cont-registro = 0.
        end.

        if  first-of(nota-fiscal.nr-nota-fis) then do:
            ASSIGN l-erroImpressao = NO.
            /* muda o status da nota-fiscal */
            IF nota-fiscal.ind-sit-nota = 1 THEN
                run ftp/ft0503a.p .

            run pi-imprime-nota.
        end.

    END. /* IF l-impressaoFCom = YES THEN DO: */

end.


run pi-acompanhar in h-acomp("Gerando Arquivo Final").

IF l-impressaoFCom = YES THEN DO:

    IF CAN-FIND (FIRST ser-estab                                 
                 WHERE ser-estab.cod-estabel = c-cod-estabel      
                   AND ser-estab.serie       = c-serie
                   AND &IF "{&bf_dis_versao_ems}":U >= "2.08":U &THEN    
                           ser-estab.log-word-danfe                      
                       &ElSE                                             
                           substring(ser-estab.char-1,70,1) = "S":U   
                       &ENDIF) THEN ASSIGN lSemWord = YES. 
    
    IF NOT lSemWord THEN
       RUN piJuntaArquivos.
    
    run pi-acompanhar in h-acomp("Abrindo Documento DANFE").
    
    /*IF tt-param-aux.destino = 1 OR tt-param-aux.destino = 4 THEN DO:
        RUN setPrintable IN h-FunctionLibrary.
        IF l-mais-itens THEN
            RUN setPrintable IN h-FunctionLibrary2.
    END.                                      
    
    run saveXML in h-FunctionLibrary(input tt-param-aux.arquivo).
    ASSIGN c-arquivo-continua = session:temp-directory + "FT0518aa-cont.pdf".
    IF l-mais-itens THEN
        run saveXML in h-FunctionLibrary2(input c-arquivo-continua).
    */
    assign v-des-retorno = "OK":U.

    if v-des-retorno <> "OK" then do:
        if i-num-ped-exec-rpw <> 0 then
            return v-des-retorno.
        else
            message v-des-retorno view-as alert-box error buttons ok.
    end.

END. /* IF l-impressaoFCom = YES THEN DO: */

IF VALID-HANDLE(h-acomp) THEN /*gr9030g*/
    RUN pi-finalizar IN h-acomp NO-ERROR.

return 'OK'.

/* Procedure para impressao da nota fiscal */
procedure pi-imprime-nota:
    /* data de saida da nota fiscal 
    assign r-nota = rowid(nota-fiscal).
    */

    if  l-dt = YES AND string(da-dt-saida) <> "" AND da-dt-saida <> ? then do:
        find first b-nota-fiscal
             where rowid(b-nota-fiscal) = rowid(nota-fiscal) EXCLUSIVE-LOCK no-error.
        assign b-nota-fiscal.dt-saida = da-dt-saida.
    end.
    
    find first ped-venda
         where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
         no-lock no-error.
    
    find first estabelec
         where estabelec.cod-estabel = nota-fiscal.cod-estabel
         no-lock no-error.

    find first emitente
         where emitente.nome-abrev = nota-fiscal.nome-ab-cli
         no-lock no-error.

    find first pre-fatur use-index ch-embarque
         where pre-fatur.cdd-embarq   = nota-fiscal.cdd-embarq
         and   pre-fatur.nome-abrev   = nota-fiscal.nome-ab-cli
         and   pre-fatur.nr-pedcli    = nota-fiscal.nr-pedcli
         and   pre-fatur.nr-resumo    = nota-fiscal.nr-resumo
         no-lock no-error.

    find first natur-oper
         where natur-oper.nat-operacao = nota-fiscal.nat-operacao
         no-lock no-error.

    FIND FIRST ser-estab NO-LOCK
        WHERE  ser-estab.cod-estabel = c-cod-estabel
          AND  ser-estab.serie       = c-serie NO-ERROR.

    assign r-estabel    = rowid(estabelec)
           r-ped-venda  = rowid(ped-venda)
           r-emitente   = rowid(emitente)
           r-natur-oper = rowid(natur-oper)
           r-ser-estab  = ROWID(ser-estab)
           r-pre-fat    = if  avail pre-fatur then
                              rowid(pre-fatur)
                          else ?
           l-tipo-nota  = no.

    IF (tt-param-aux.destino = 1
    OR  tt-param-aux.destino = 3) THEN DO:

        for each gati-nfe-param no-lock
            where gati-nfe-param.cod-estabel = nota-fiscal.cod-estabel.

            FIND FIRST gati-nfe-param-ext
                WHERE gati-nfe-param-ext.cod-estabel = gati-nfe-param.cod-estabel NO-LOCK NO-ERROR.

            ASSIGN c-caminhoUnix = replace(gati-nfe-param-ext.end-imp-nfe-unix,'insercao/saida','idanfe')
                   c-caminhoWin  = replace(gati-nfe-param.end-imp-nfe     ,'insercao\saida','idanfe')
                   i-contImp     = i-contImp + 1  .


            IF opsys <> 'WIN32' THEN DO:
                ASSIGN c-arquivoImp = c-caminhoUnix + "/"  + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf".
            END.
            ELSE DO:     
                ASSIGN c-arquivoImp = c-caminhoWin  + "~\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf".
            END.

            IF SEARCH(c-arquivoImp) = ? THEN DO:

                ASSIGN c-caminhoUnix = ''
                       c-caminhoWin  = ''
                       c-caminhoUnix = gati-nfe-param-ext.end-exp-nfe + '-bkp'
                       c-caminhoWin  = gati-nfe-param.end-exp-nfe + '-bkp'.

                /*** reenvia arquivo txt e xml ***/
                IF opsys <> 'WIN32' THEN DO:
                    ASSIGN c-arquivoXMLEnv = c-caminhoUnix + "/" + string(int(nota-fiscal.nr-nota-fis)) + "_" + nota-fiscal.serie + ".xml".
                END.
                ELSE DO:     
                    ASSIGN c-arquivoXMLEnv = c-caminhoWin  + "~\" + string(int(nota-fiscal.nr-nota-fis)) + "_" + nota-fiscal.serie + ".xml".
                END.

/*                 MESSAGE c-arquivoXMLEnv SKIP           */
/*                         SEARCH(c-arquivoXMLEnv)        */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                IF SEARCH(c-arquivoXMLEnv) = ? THEN DO:
                    /*** gera TXT e XML - MAUAL ***/
                    CREATE tt-ft0910.
                    ASSIGN tt-ft0910.usuario           = ""
                           tt-ft0910.arquivo           = "ft0518rp.txt"
                           tt-ft0910.destino           = 2
                           tt-ft0910.data-exec         = TODAY
                           tt-ft0910.hora-exec         = TIME
                           tt-ft0910.cod-estabel       = nota-fiscal.cod-estabel
                           tt-ft0910.serie             = nota-fiscal.serie
                           tt-ft0910.nr-nota-fis-ini   = nota-fiscal.nr-nota-fis
                           tt-ft0910.nr-nota-fis-fim   = nota-fiscal.nr-nota-fis
                           tt-ft0910.nome-ab-cli-ini   = ""
                           tt-ft0910.nome-ab-cli-fim   = "ZZZZZZZZZZZZZ"
                           tt-ft0910.dt-emis-nota-ini  = 01/01/1900
                           tt-ft0910.dt-emis-nota-fim  = 12/31/2099
                           tt-ft0910.gera-nfe-n-gerada = YES
                           tt-ft0910.gera-nfe-gerada   = YES
                           tt-ft0910.exporta-est-txt   = YES
                           tt-ft0910.gera-nfe-cancel   = YES
                           tt-ft0910.gera-nfe-inut     = YES
                           tt-ft0910.c-motivo          = "".

                    raw-transfer tt-ft0910 to raw-param.
                    RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-ft0910).
                    run esp/ftp/esft067rp.p (input nota-fiscal.cod-estabel,
                                             input 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').
                    /** fim gera TXT e XML - MANUAL **/
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "Nota n∆o integrada na SEFAZ!~~Nota "  + nota-fiscal.nr-nota-fis + "_" + nota-fiscal.cod-estabel + "_" + nota-fiscal.serie + 
                                             " reenviada. Por gentileza, atualizar estoque e reemprimir." ).
                END. /* IF SEARCH(ttArquivo.nomeArquivo) = ? THEN DO: */
                ELSE DO:
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "Arquivo DANFE inexistente!~~Nota "  + nota-fiscal.nr-nota-fis + "_" + nota-fiscal.cod-estabel + "_" + nota-fiscal.serie).
                    ASSIGN l-erroImpressao = YES.
                END.
                /* fim reenvia arquivo txt e xml */
            END. /* IF c-arquivoImp = '' THEN DO: */

            IF c-arquivoImp <> ? THEN DO:
                CREATE ttArquivo.
                ASSIGN ttArquivo.sequencia   = i-contImp
                       ttArquivo.nomeArquivo = c-arquivoImp.
            END.
            ELSE DO:
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Arquivo DANFE inexistente!~~Nota "  + nota-fiscal.nr-nota-fis + "_" + nota-fiscal.cod-estabel + "_" + nota-fiscal.serie).
                ASSIGN l-erroImpressao = YES.
            END.


        END. /* for each gati-nfe-param no-lock */
    END. /* IF  tt-param-aux.destino = 1 THEN DO: */
    ELSE DO:
        run ftp/ft0518f.p (INPUT-OUTPUT TABLE ttArquivo,
                           INPUT l-reimp).
    END.

    IF l-erroImpressao = NO THEN DO:

        create tt-notas-impressas.
        assign tt-notas-impressas.r-nota = rowid(nota-fiscal).

        /* GERA ETIQUETAS PARA O MODULO DE COLETA DE DADOS */

        if  avail param-global
        and param-global.modulo-cl
        and ( nota-fiscal.ind-tip-nota = 2) /* tipo de nota-fiscal Manual */
        then do:
            create tt-prog-bc.
            assign tt-prog-bc.cod-prog-dtsul        = "ft0513"
                   tt-prog-bc.cod-versao-integracao = 1
                   tt-prog-bc.usuario               = tt-param-aux.usuario
                   tt-prog-bc.opcao                 = 1.

            run bcp/bcapi004.p (input-output table tt-prog-bc,
                                input-output table tt-erro).

            find first tt-prog-bc no-error.

            assign  c-arquivo = tt-prog-bc.nome-dir-etiq + "/" + c-arquivo.

            if  return-value = "OK" then do:

                {utp/ut-liter.i Gerando_Etiquetas  MRE R}
                run pi-acompanhar in h-acomp (input return-value).

                erro:
                do  on stop     undo erro,leave erro
                    on quit     undo erro,leave erro
                    on error    undo erro,leave erro
                    on endkey   undo erro,leave erro:

                    run value(tt-prog-bc.prog-criacao)(input tt-prog-bc.cd-trans,
                                                       input rowid(nota-fiscal),
                                                       input-output table tt-erro) no-error.

                    if  ERROR-STATUS:ERROR 
                    or  (    error-status:get-number(1) <> 138
                         and error-status:num-messages  <> 0)
                    then do:
                        output stream arq-erro to value(c-arquivo) append.

                        {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas_-_Progress MRE R}
                        put stream arq-erro "***" return-value skip.
                        {utp/ut-liter.i Programa * R}
                        put stream arq-erro error-status:get-message(1) skip.
                        put stream arq-erro return-value ": " tt-prog-bc.prog-criacao skip.
                        put stream arq-erro nota-fiscal.serie                           at 1.
                        put stream arq-erro nota-fiscal.nr-nota-fis                     at 7.
                        put stream arq-erro nota-fiscal.cod-estabel                     at 24.

                        output stream arq-erro close.
                    end.

                    if  return-value = "NOK" then do:
                        find first tt-erro no-error.
                        if  avail tt-erro
                        then do:
                            output stream arq-erro to value(c-arquivo) append.

                            {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas MRE R}
                            put stream arq-erro "***" return-value skip.
                            for each tt-erro:
                                put stream arq-erro skip tt-erro.cd-erro " - " tt-erro.mensagem.
                            end.
                            put stream arq-erro skip.
                            output stream arq-erro close.
                        end.
                    end.
                end.
            end.
            else do:
                /**** caso tenha integraá∆o com o coleta e ocorreu erros ***/
                find first tt-erro no-error.
                if  avail tt-erro then do:
                    output stream arq-erro to value(c-arquivo) append.

                    {utp/ut-liter.i Ocorreu_na_Geraá∆o_de_Etiquetas MRE R}
                    put stream arq-erro "***" return-value skip.
                    for each tt-erro:
                        put  stream arq-erro skip tt-erro.cd-erro " - " tt-erro.mensagem.
                    end.
                    put stream arq-erro skip.
                    output stream arq-erro close.
                end.
            end.
        end.
    END. /* IF l-erroImpressao = NO THEN DO: */
    /*************************************************/
end procedure.

PROCEDURE OpenDocument:

    def input param c-doc as char  no-undo.
    def var c-exec as char  no-undo.
    def var h-Inst as int  no-undo.

    assign c-exec = fill("x",255).
    run FindExecutableA (input c-doc,
                         input "",
                         input-output c-exec,
                         output h-inst).

    if h-inst >= 0 and h-inst <=32 then
      run ShellExecuteA (input 0,
                         input "open",
                         input "rundll32.exe",
                         input "shell32.dll,OpenAs_RunDLL " + c-doc,
                         input "",
                         input 1,
                         output h-inst).

    run ShellExecuteA (input 0,
                       input "open",
                       input c-doc,
                       input "",
                       input "",
                       input 1,
                       output h-inst).

    if h-inst < 0 or h-inst > 32 then return "OK".
    else return "NOK".

END PROCEDURE.

PROCEDURE FindExecutableA EXTERNAL "Shell32.dll" persistent:

    define input parameter lpFile as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input-output parameter lpResult as char  no-undo.
    define return parameter hInstance as long.

END.

PROCEDURE ShellExecuteA EXTERNAL "Shell32.dll" persistent:

    define input parameter hwnd as long.
    define input parameter lpOperation as char  no-undo.
    define input parameter lpFile as char  no-undo.
    define input parameter lpParameters as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input parameter nShowCmd as long.
    define return parameter hInstance as long.

END PROCEDURE.

PROCEDURE piJuntaArquivos:

    DEF VAR lEntrou     AS LOG NO-UNDO.
    DEF VAR ch-app-word AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE i-numero-copia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-impressora-padrao AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE arquivo AS CHARACTER FORMAT "x(30)" NO-UNDO.

    run pi-acompanhar in h-acomp("Imprimindo Nota Fiscal " + ttArquivo.nomeArquivo).

    IF  tt-param-aux.destino = 1 THEN 
        RUN piImprimePDF.
    ELSE DO:

        FOR EACH ttArquivo:

            IF SEARCH(ttArquivo.nomeArquivo) <> ? THEN
            OS-COMMAND NO-WAIT VALUE("START " + ttArquivo.nomeArquivo ).

        END.

        /****
        CREATE 'Word.Application':U ch-app-word.                         /* Cria uma aplicaá∆o WORD */
        ch-app-word:WindowState = 2.                                     /* O estado dois para o Word Ç minimizado */
        ch-app-word:VISIBLE = NO.                                        /* Apenas para n∆o mostrar que o word est† sendo utilizado em tela */

        FOR EACH ttArquivo:

            MESSAGE ttArquivo.nomeArquivo
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            run pi-acompanhar in h-acomp("Imprimindo Nota Fiscal " + ttArquivo.nomeArquivo).

            DO i-numero-copia = 1 TO tt-param-aux.nr-copias:

                IF  ttArquivo.Sequencia = 1 AND 
                    i-numero-copia      = 1 THEN
                    ch-app-word:Documents:ADD(ttArquivo.nomeArquivo).        /* Inclui arquivo */
                ELSE DO:
                    ch-app-word:SELECTION:EndKey(6).                         /* Posiciona cursor no final do arquivo */
                    ch-app-word:SELECTION:InsertBreak(7).                    /* Qubra pagina antes de inserir arquivo */
                    ch-app-word:SELECTION:Insertfile(ttArquivo.nomeArquivo).  /* Insere arquivo no documento aberto */
                END.

            END.

            ASSIGN lEntrou = YES.
        END.

        IF NOT lEntrou THEN
            ch-app-word:Documents:ADD().                                 /* Inclui arquivo */
            ch-app-word:ActiveDocument:ExportAsFixedFormat(session:temp-directory + "docto_NF.pdf",17,YES,0,0,1,1,0,yes,yes,0,yes,yes,no).

    /*     ch-app-word:ActiveDocument:SaveAs(tt-param-aux.arquivo).         /* Salva o arquivo aberto no WORD com o nome final do arquivo */ */
        
        /********
        IF  tt-param-aux.destino = 1 THEN DO: /* Impressora */
            IF INDEX (tt-param-aux.impressora-so," in session") > 0 THEN
                tt-param-aux.impressora-so = tt-param-aux.impressora-so + " on " + SESSION:PRINTER-PORT.
            /* Guarda a impressora padr∆o do windows antes da geraá∆o do DANFE */
            ASSIGN c-impressora-padrao = SESSION:PRINTER-NAME.
            /* Seleciona a impressora para impress∆o */
            ch-app-word:ActivePrinter = tt-param-aux.impressora-so.
            /* Imprime o documento na impressora selecionada */
            ch-app-word:printout(0). /* 0 : N∆o mostra erros nem advertencias */
            /* Volta a impressora padr∆o do windows */
            ch-app-word:ActivePrinter = c-impressora-padrao.    
        END.
        ********/

    /*     ch-app-word:ActiveDocument:CLOSE.                             /* Fecha o arquivo do WORD */ */
        ch-app-word:QUIT().                                              /*  Fechar o WORD */
        RELEASE OBJECT ch-app-word.                                      /* Elimina o endereáo utilizado para o WORD na m†quina */
        ***/

        /***
        FOR EACH ttArquivo:
            OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "/" + ttArquivo.nomeArquivo) NO-ERROR.
        END. /* FOR EACH ttArquivo: */
        ***/

    END.

END.

PROCEDURE piImprimePDF:

    FOR EACH ttArquivo:
        IF SEARCH(ttArquivo.nomeArquivo) = ? THEN NEXT.
        run pi-acompanhar in h-acomp("Imprimindo Nota Fiscal ").
        /***
        DOS SILENT TYPE VALUE(ttArquivo.nomeArquivo) > value(tt-param-aux.impressora-so).
        ***/
        run piFuncaoImpressao (input tt-param-aux.impressora-so,
                               input ttArquivo.nomeArquivo).

    END. /* FOR EACH ttArquivo: */

END.

PROCEDURE piFuncaoImpressao:

    def input param cPrinterName        as character        no-undo.
    def input param cArquivo            as character        no-undo.

    def var         iReturn             as integer          no-undo.
    def var         cWinDir             as character        no-undo.
    def var         h-prog              as handle           no-undo.

    /*****************************************************************************/    

    run utp/ut-utils.p persistent set h-prog.
    run GetSysDir in h-prog (output cWinDir).

    /**** Torna a Impressora Padr∆o a selecionada pelo Usu†rio ****/
    file-info:file-name = cWinDir + "\winspool.dll".

    if file-info:full-pathname <> ? then
        run piPrinterDLL (input cPrinterName).
    else
        run piPrinterDRV (input cPrinterName).

    run PrintDocument in h-prog (cArquivo).
    delete procedure h-prog.

END.

PROCEDURE piPrinterDLL:

    def input param PrinterName     as character        no-undo.
    def var         iReturn         as integer          no-undo.

    run SetDefaultPrinterA(input  PrinterName,
                           output iReturn).

END.

PROCEDURE piPrinterDRV:

    def input param PrinterName     as character        no-undo.
    def var         iReturn         as integer          no-undo.

    run SetDefaultPrinterA(input  PrinterName,
                           output iReturn).

END.

procedure SetDefaultPrinterA external "winspool.drv":U:

    def input   param pszPrinter    as character.
    def return  param ireturn       as long.

end procedure.


/* fim do programa */
