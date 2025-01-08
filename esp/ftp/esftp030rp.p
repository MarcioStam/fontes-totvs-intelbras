{include/i-prgvrs.i ESFTP030 2.04.00.001}
/***********************************************************************
**  Programa..: ESP/FTP/ESFTP030RP.P
**  Autor.....: Felipe Braun Azambuja
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp030tt.i}

/** Estas includes vieram do Ft0515/ftp/ft0515rp.p **/
{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*Include de definiá∆o de Preprocessadores*/
{cdp/cd0620.i1 "' '"}

{include/tt-edit.i}
{include/pi-edit.i}

{bcp/bcapi004.i}
{cdp/cd0666.i}
{esapi/esapi010tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* Vari†vel usada para a linha lida do CSV */
DEFINE VARIABLE c-linha AS CHARACTER  NO-UNDO.

/* Vari†veis vindas do ft0515 */
def var r-nota-embal           as rowid no-undo.
def var l-lei-informatica      as logi no-undo.
def var l-software             as logi no-undo.
def var i-qt-vol               as int no-undo. 
def var l-resposta             as logical format "Sim/Nao" init yes.
def var i-cont4                as integer.
def var i-cont6                as integer.
def var l-tem-ipi              as logical.
def var i                      as integer.
def var i-qt-volumes           as integer extent 5 format ">>,>>9".
def var i-cont-item            as integer.
def var i-dup                  as integer.
def var l-sub                  as logical.
def var de-aliquota-iss      like it-nota-fisc.aliquota-iss.
def var de-desc              like it-nota-fisc.vl-preori.
def var c-cod-suframa-est    like estabelec.cod-suframa.
def var c-cod-suframa-cli    like emitente.cod-suframa.
def var de-qt-fatur            as decimal format ">>>>,>>9.9999".
def var de-tot-icmssubs      like it-nota-fisc.vl-icmsub-it.
def var de-tot-bicmssubs     like it-nota-fisc.vl-bsubs-it.
def var de-tot-bas-icm       like it-nota-fisc.vl-icms-it.
def var de-tot-bas-iss       like it-nota-fisc.vl-iss-it.
def var de-tot-bas-ipi       like it-nota-fisc.vl-ipi-it.
def var de-tot-icm           like it-nota-fisc.vl-icms-it.
def var de-tot-iss           like it-nota-fisc.vl-iss-it.
def var de-tot-ipi           like it-nota-fisc.vl-ipi-it.
def var de-vl-bipi-it        like it-nota-fisc.vl-bipi-it.
def var de-vl-ipi-it         like it-nota-fisc.vl-ipi-it.
def var de-ger-pisretido     like nota-fiscal.vl-tot-nota.
def var de-ger-cofinsretido  like nota-fiscal.vl-tot-nota.
def var de-ger-csllretido    like nota-fiscal.vl-tot-nota.
DEF VAR de-ger-inssretido    LIKE nota-fiscal.vl-tot-nota.
def var l-frete-bipi           as log.
def var i-cep                like nota-fiscal.cep.
def var c-pago                 as character format "x" init " ".
def var c-opcao                as character.
def var c-class-fiscal         as character format "99".
def var c-mensagem1            as character format "x(380)".
def var c-mensagem2            as character format "x(152)".
def var c-especie              as character extent 5 format "x(30)".
def var c-desc-prod            as character format "x(42)".
def var c-repres               as character format "x(15)".
def var c-redesp               as character .
def var c-nat                  as character format "x.xxx".
def var c-un-fatur             as character format "x(2)".
def var c-tipo-venda           as character extent 6 initial
    ["1 - Laticin.","2 - Corantes","3 - Frigorif.","4 - Export.",
     "5 - Prest.Serv.","6 - Outros"] format "x(13)".
def var r-it-nota              as rowid.
def var i-sit-nota-ini         as integer.
def var i-sit-nota-fim         as integer.
def var c-formato-cfop         as char.
DEF VAR de-peso-embalag        AS DEC.
DEF VAR de-peso-bru            LIKE nota-fiscal.peso-bru-tot.

def new shared var l-dt              as LOGICAL.
def new shared var dt-saida          as date format "99/99/9999".
def new shared var hr-saida          as char format "xx:xx:xx".

DEFINE VARIABLE iLinhaCabecCont AS INTEGER      NO-UNDO.
DEFINE VARIABLE lSaltaLinha     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE i-folhas        AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-folhas-imp    AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-indice        AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-pedido        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-pedido        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE de-pis          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-cofins       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-outr-desp    AS DECIMAL      NO-UNDO.
DEFINE VARIABLE i-proximo-vol   AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-ali-ipi       LIKE it-nota-fisc.aliquota-ipi  NO-UNDO.
DEFINE VARIABLE imp-total-nota  LIKE nota-fiscal.vl-tot-nota    NO-UNDO.
DEFINE VARIABLE cTextoAux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-tem-portaria      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-nao-tem-portaria  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-emb-escolhida     LIKE embalag.sigla-emb.

DEFINE VARIABLE de-aliq-pis     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-aliq-cofins  AS DECIMAL      NO-UNDO.


def new shared var i-parcela   as integer                             extent 6.
def new shared var i-fatura    as char      format "x(16)"            extent 6.
def new shared var da-venc-dup as date      format "99/99/9999"       extent 6.
def new shared var de-vl-dup   as decimal   format ">>>>>,>>>,>>9.99" extent 6.

def new shared var de-cotacao        as decimal format ">>>,>>9.99999999".
def new shared var de-conv           as decimal format ">>>>9.99".

def new shared var de-tot-icms-obs      like it-nota-fisc.vl-icms-it.
def new shared var de-tot-icmssubs-obs  like it-nota-fisc.vl-icmsub-it.
def new shared var de-tot-bicmssubs-obs like it-nota-fisc.vl-bsubs-it.
def new shared var de-tot-ipi-dev-obs   like it-nota-fisc.vl-ipi-it.
def new shared var de-tot-ipi-calc      like it-nota-fisc.vl-ipi-it.
def new shared var de-tot-ipi-nota      like it-nota-fisc.vl-ipi-it.
def new shared var i-codigo          as integer.
def new shared var i-cont            as integer.

def new shared var c-mess     as character NO-UNDO format "x(73)" extent 20 init " ".
def new shared var c-num-nota        as char format "x(16)".
def new shared var c-num-duplic      as char.

def new shared var de-val9100          as decimal.
def new shared var  i-num9100          as integer.
def new shared var  i-tam9100          as integer.
def new shared var  c-ext9100          as character extent 10.

def new shared var r-natur-oper      as rowid.
def new shared var r-nota-fiscal     as rowid.
def new shared var r-item            as rowid.
def new shared var r-nota            as rowid.
def new shared var r-ped-venda       as rowid.
def new shared var r-pre-fat         as rowid.
def new shared var r-emitente        as rowid.
def new shared var r-estabel         as rowid.
def new shared var r-docum-est       as rowid.

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-nota-fiscal
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD serie        LIKE nota-fiscal.serie
    FIELD requisitante AS CHARACTER
    FIELD e-mail       AS CHARACTER
    INDEX ch-pri IS PRIMARY UNIQUE nr-nota-fis serie.

/** temp-tables vindas do ft0515 **/
define temp-table b-class-fis
     field b-cod-class  like  item.class-fisc
     field b-indice     as    integer initial 0
     index b-cod-class
     is primary b-cod-class ascending.

def new shared temp-table item-nota no-undo
    field registro        as rowid
    field it-codigo       like it-nota-fisc.it-codigo
    field aliquota-icm    like it-nota-fisc.aliquota-icm
    field nr-seq-fat      like it-nota-fisc.nr-seq-fat
    field sit-tribut      as integer format ">>>".

def temp-table tt-resto
    field it-codigo like item.it-codigo
    field qtde      as dec
    index tt-resto is primary unique it-codigo
    index qtde     qtde.
    
def temp-table tt-embalagem no-undo
    field seq as int
    field sigla-emb like volume-nf.sigla-emb    
    field qt-volumes like nota-embal.qt-volumes 
    index codigo seq.

def buffer b-nota-fiscal     for nota-fiscal.

/****************************  Variaveis    ****************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp      AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.


ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Espelho de Nota Fiscal"
       c-empresa      = IF AVAILABLE empresa THEN mgcad.empresa.razao-social ELSE ''
       c-programa     = "ESFTP030"
       c-versao       = "2.04"
       c-revisao      = "001".



/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    /*{include/i-rpout.i}*/
/*    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
  */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Montando Relat¢rio...").
    RUN piMontaRelat.

    RUN pi-finalizar IN h-acomp.
  /*
    {include/i-rpclo.i}
*/
    RETURN "OK".
END.



/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:
    /** Vari†veis que ser∆o usadas _apenas_ nesta procedure **/
    DEFINE VARIABLE c-nr-nota-fis  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-serie        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-requisitante AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-e-mail       AS CHARACTER  NO-UNDO.

    /** Ler o arquivo CSV informado **/
    INPUT FROM VALUE(tt-param.arquivo-entrada).
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN c-nr-nota-fis  = ENTRY(1, c-linha, ";")
               c-serie        = ENTRY(2, c-linha, ";")
               c-requisitante = ENTRY(3, c-linha, ";")
               c-e-mail       = ENTRY(4, c-linha, ";").
        
        IF (c-nr-nota-fis = "") OR (c-serie = "") OR (c-requisitante = "") OR (c-e-mail = "") THEN DO:
            MESSAGE "Arquivo n∆o est† com os 4 campos preenchidos!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
        END.

        FIND FIRST tt-nota-fiscal NO-LOCK
            WHERE tt-nota-fiscal.nr-nota-fis = c-nr-nota-fis
              AND tt-nota-fiscal.serie       = c-serie NO-ERROR.
        IF NOT AVAILABLE (tt-nota-fiscal) THEN DO:
            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.nr-nota-fis  = c-nr-nota-fis
                   tt-nota-fiscal.serie        = c-serie.
        END.
        ASSIGN tt-nota-fiscal.requisitante = c-requisitante
               tt-nota-fiscal.e-mail       = c-e-mail.
    END. /** REPEAT **/
    INPUT CLOSE.

    /** Tratamento de cada nota fiscal **/
    FOR EACH tt-nota-fiscal NO-LOCK,
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.nr-nota-fis = tt-nota-fiscal.nr-nota-fis
              AND nota-fiscal.serie       = tt-nota-fiscal.serie
              AND nota-fiscal.cod-estabel = tt-param.cod-estabel
        BREAK BY tt-nota-fiscal.e-mail:

        IF FIRST-OF (tt-nota-fiscal.e-mail) THEN
            OUTPUT TO VALUE(c-dir-arquivo-session + "/" + tt-nota-fiscal.requisitante + ".txt").

        RUN pi-imprime-nota.

        IF LAST-OF (tt-nota-fiscal.e-mail) THEN DO:
            OUTPUT CLOSE.

            IF (tt-param.envia-mail) THEN
                RUN piEnviaEmail.
        END.
    END.

    /** Se chegou atÇ aqui, concluiu sem erros **/
    MESSAGE "Emiss∆o conclu°da."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/** Daqui pra baixo, as procedures foram _copiadas_ do ft0515, exceto a de envio de e-mail **/

/* Procedure para impressao da nota fiscal */
procedure pi-imprime-nota:
    find b-nota-fiscal
         where rowid(b-nota-fiscal) = rowid(nota-fiscal)
         EXCLUSIVE-LOCK no-error.

    find ped-venda
         where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
         and   ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
         no-lock no-error.

    find estabelec
         where estabelec.cod-estabel = nota-fiscal.cod-estabel
         no-lock no-error.

    find emitente
         where emitente.nome-abrev  = nota-fiscal.nome-ab-cli
         no-lock no-error.

    find pre-fatur use-index ch-embarque
         where pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq
         and   pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli
         and   pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli
         and   pre-fatur.nr-resumo   = nota-fiscal.nr-resumo
         no-lock no-error.

    find natur-oper
         where natur-oper.nat-operacao = nota-fiscal.nat-operacao
         no-lock no-error.

    assign r-estabel    = rowid(estabelec)
           r-ped-venda  = rowid(ped-venda)
           r-emitente   = rowid(emitente)
           r-natur-oper = rowid(natur-oper)
           r-pre-fat    = if   avail pre-fatur
                          then rowid(pre-fatur)
                          else ?.

/*----------------------------------------------------------------------------*/

    assign de-conv = 1.

    find first cidade-zf where cidade-zf.cidade = nota-fiscal.cidade
                         and   cidade-zf.estado = nota-fiscal.estado
                         no-lock no-error.

    if  avail cidade-zf 
    and dec(natur-oper.per-des-icms) > 0 then
        assign de-conv = (100 - dec(natur-oper.per-des-icms)) / 100.
/*
    and dec(substr(natur-oper.char-2,66,5)) > 0 then
        assign de-conv = (100 - dec(substr(natur-oper.char-2,66,5))) / 100.*/
        /* valor para tratamento de ZFM */
    
/*     {ftp/ft0515i1.i} */

END PROCEDURE.





PROCEDURE pi-ver-salto-pagina.

    DEFINE VARIABLE i-linhas-tmp AS INTEGER    NO-UNDO.

    ASSIGN i-linhas-tmp = 0.
    FOR EACH tt-editor:
        ASSIGN i-linhas-tmp = i-linhas-tmp + 1.
    END.
    IF i-linhas-tmp > 4 THEN
        ASSIGN i-linhas-tmp = 4.

    IF nota-fiscal.serie = "1" OR nota-fiscal.serie = "3" THEN DO:
       IF i-cont-item + i-linhas-tmp > 22 THEN DO:
          RUN pi-faz-rodape.
          ASSIGN i-cont-item = 0.
          RUN pi-imprime-cabecalho.
       END.
    END.
    ELSE DO:
       IF i-cont-item + i-linhas-tmp > 29 THEN DO:
          RUN pi-faz-rodape.
          ASSIGN i-cont-item = 0.
          RUN pi-imprime-cabecalho.
       END.
    END.
END PROCEDURE.




PROCEDURE pi-imprime-cabecalho:

    DEFINE VARIABLE c-imp-boleto    AS CHARACTER  NO-UNDO FORMAT 'x(4)'.

    ASSIGN i-folhas-imp = i-folhas-imp  + 1.

    /* ------ Inicio impress∆o ------- */
    PUT SKIP (2). /* salto de pagina inicial */


    IF natur-oper.tipo = 1 THEN /* ENTRADA */   
        PUT /*-- c-mess[1] AT 26 */
            "X"       AT 105.
    ELSE                        /* SAIDA   */
        PUT /*-- c-mess[1] AT 26 */ 
            "X"       AT  89.

    PUT nota-fiscal.nr-nota-fis    format "x(7)"      at 124.

    /*
    PUT skip
        "123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789." 
        SKIP.

    */

    assign c-imp-boleto = "". 

    if nota-fiscal.modalidade <> 7 then do:
       if (nota-fiscal.cod-port = 999 and nota-fiscal.modalidade = 6) or
          (nota-fiscal.cod-port = 237 and nota-fiscal.modalidade = 6) then do:
          do i = 1 to 6:
             if (da-venc-dup[i] - nota-fiscal.dt-emis-nota) >= 5
                and (da-venc-dup[i] - nota-fiscal.dt-emis-nota)  <= 25 then
                assign c-imp-boleto = "(**)".
          end.
       end.
    end.

    put "  " c-imp-boleto skip.


    PUT SKIP(5).

 /*--
    put c-mess[2] at 26 " " skip
        c-mess[3] at 26 " " skip
        c-mess[4] at 26 " " skip
        c-mess[5] at 26 " " skip
        c-mess[6] at 26 " " skip
        c-mess[7] at 26 " " skip
        c-mess[8] at 26 " " skip.

   */

    /*-----------------------  DADOS DO ESTABELECIMENTO  ------------------------*/

    /*
    put estabelec.endereco                               at 54 SKIP
      SUBSTRING(estabelec.cidade,1,length(estabelec.cidade)) + " - " +
      estabelec.estado + "    CEP " +
      SUBSTRING(STRING(estabelec.cep,"99999999"),1,5) + "-" +
      SUBSTRING(STRING(estabelec.cep,"99999999"),6,3)
                                 format "x(30)"        at 54 SKIP.


    put estabelec.cgc  pre-impresso            at 104 SKIP(1).
    */

    /* Define o formato de impressao da natureza de operacao */

    ASSIGN c-formato-cfop = if  SUBSTRING(natur-oper.char-2,78,10) <> " "
                  THEN trim(SUBSTRING(natur-oper.char-2,78,10))
                  ELSE "9.99".

    {cdp/cd0620.i1 nota-fiscal.cod-estabel}                                                       
    /*{cdp/cd0620.i3 nat-operacao nota-fiscal.dt-emis-nota}.*/
    put /*-- c-mess[9] at 26 */
        natur-oper.denominacao /*c-desc-cfop-nat*/                             at 01
    {cdp/cd0620.i2 nat-operacao nota-fiscal.dt-emis-nota "' '" c-formato-cfop} at 40.

/*
    if nota-fiscal.dt-emis-nota >= 01/01/2003 then do:
        for first ped-curva use-index ch-vlitem
            where ped-curva.it-codigo = substr(natur-oper.char-1,37,10)
              and ped-curva.vl-aberto = 620 no-lock:
            put c-mess[9] at 26
                natur-oper.denominacao at 87
                substr(natur-oper.char-1,37,10) at 131.
        end.
     end.
     else do:
        assign c-formato-cfop = if substr(natur-oper.char-1,1,7) <> "" then
                                   substr(natur-oper.char-1,1,7)
                                else
                                   "9.99".

        put c-mess[9] at 26
            natur-oper.denominacao                         at 87
            string(natur-oper.nat-operacao,c-formato-cfop) at 131. 
     end.
*/


    /*------ INS. EST. DO SUBSTITUITO TRIB. ------*/

    IF l-sub = yes THEN DO:

        FIND FIRST estab-uf
            WHERE estab-uf.cod-estabel = nota-fiscal.cod-estabel
              AND estab-uf.estado      = nota-fiscal.estado  NO-LOCK NO-ERROR.
        IF AVAILABLE estab-uf THEN DO:
            put estab-uf.ins-estadual   at 52.
        END.

    END.

    /*put estabelec.ins-estadual pre-impresso " " at 104 SKIP.*/
    /*
    if  c-nat <> " " THEN DO:
      if  nota-fiscal.dt-emis-nota >= da-dt-cfop
      and ({cdp/cd0620.i2 nat-operacao nota-fiscal.dt-emis-nota "'XXXX'" c-formato-cfop}) = c-nat  THEN
          ASSIGN c-nat = "".

      put c-nat                                      at 56  SKIP(1).
    END.
    ELSE put " "                                      at 56  SKIP(1).
    */
    /*------------- IMPRESSAO DOS DADOS DO EMITENTE --------------*/

    PUT SKIP(2).

    put /*-- c-mess[10] at 26 SKIP
        c-mess[11] at 26 SKIP
        c-mess[12] at 26 */
        emitente.nome-emit at 01.


    if nota-fiscal.nome-ab-cli <> "brinde" THEN
        put "(" + string(emitente.cod-emitente,">>>,>>9") + 
            ")" format "x(10)" at 75
               emitente.cgc                                      at 87.

    put nota-fiscal.dt-emis-nota FORMAT '99/99/9999' AT 120
        /*-- c-mess[13] at 26 */ SKIP.

    /*----------ENDERECO DO EMITENTE-------------------------------------------*/

    put SKIP(1) /* "0800-7042767" at 7 */
        /*-- c-mess[14] at 26 */
        emitente.endereco /*nota-fiscal.endereco*/        at  1
        emitente.bairro   /*nota-fiscal.bairro*/  FORMAT 'x(20)'        at 66
        emitente.cep      /*nota-fiscal.cep*/     FORMAT param-global.formato-cep at 99
        .

    /* Comentado Ö pedido do Claudiney; esta informaá∆o n∆o deve ser impressa.
    IF b-nota-fiscal.dt-saida <> ? THEN DO:
        PUT b-nota-fiscal.dt-saida FORMAT '99/99/9999' AT 120.
/*            SUBSTRING(STRING(b-nota-fiscal.dt-saida ,"99/99/9999"),1,2) + "/" +
            SUBSTRING(STRING(b-nota-fiscal.dt-saida ,"99/99/9999"),4,2) + "/" +
            SUBSTRING(STRING(b-nota-fiscal.dt-saida ,"99/99/9999"),7,4) AT 210 format "x(10)".*/
    END.
    */

    /*
    put c-mess[15] at 26 SKIP
        c-mess[16] at 26.
      */

    PUT SKIP(1).

    IF nota-fiscal.nome-ab-cli <> "brinde" THEN
        PUT emitente.cidade /*nota-fiscal.cidade */         at  01
            emitente.telefone[1]        at 46
            emitente.estado /*nota-fiscal.estado */         at 78
            nota-fiscal.ins-estadual    at 87.

    PUT SKIP(3).

    /*--
    IF nota-fiscal.nome-ab-cli = "brinde" OR l-dt = NO THEN
        PUT SKIP.


    put /*-- c-mess[17] at 26 */ SKIP
        /*-- c-mess[18] at 26 */ SKIP
        /*-- c-mess[19] at 26 */SKIP.
    */
    /*------  DUPLICATAS  ------*/
    if i-folhas-imp = i-folhas then do:
        DO i = 1 TO 2:
         /*--   IF i-fatura[i] = '' THEN
                PUT c-mess[i + 19] AT 26 SKIP.
            ELSE DO:
           */
                PUT /*-- c-mess[i + 19] AT 26 */
                    da-venc-dup[i]                  AT  01
                    de-vl-dup[i]                    AT  14
                    i-fatura[i]     FORMAT 'x(7)'   AT  35
                    '/'                             AT  42
                    i-parcela[i]    FORMAT '99'     AT  43.

                IF i-parcela[i + 2] <> 0 THEN
                    PUT da-venc-dup[i + 2]                  AT 47
                        de-vl-dup[i + 2]                    AT 61
                        i-fatura[i + 2]     FORMAT 'x(7)'   AT 82
                        '/'                                 AT 89
                        i-parcela[i + 2]    FORMAT '99'     AT 90.

                IF i-parcela[i + 4] <> 0 then
                    PUT da-venc-dup[i + 4]                  AT 93
                        de-vl-dup[i + 4]                    AT 107
                        i-fatura[i + 4]     FORMAT 'x(7)'   AT 128
                        '/'                                 AT 135
                        i-parcela[i + 4]    FORMAT '99'     AT 136.
                PUT SKIP.
          /*--  END.*/

        END.
    END.
    ELSE DO:
        PUT " " SKIP
            " " SKIP.
    END.
    
    /*--
    ELSE DO:
        do i = 1 to 2:  /* linha a serem impressas */
            put c-mess[i + 19] at 26 skip.
        end.
    end.

    put c-mess[22] at 26 SKIP
        c-mess[23] at 26 SKIP
        c-mess[24] at 26 SKIP.

    */

    PUT SKIP(3).

    IF i-fatura[1] <> '' AND i-folhas-imp = i-folhas THEN DO:
        ASSIGN de-val9100 = nota-fiscal.vl-tot-nota
              i-num9100  = 2
              i-tam9100  = 80.
        RUN cdp/cd9100.p.
        PUT /*--  c-mess[25] at 26 */
            c-ext9100[1] format "x(80)" at 14 skip
            /*-- c-mess[26] at 26 */
            c-ext9100[2] format "x(80)" at 14 skip.
    END.
    ELSE PUT " " AT 01 SKIP
             " " AT 01 SKIP.

    PUT SKIP(3).

    
    /*--
    
    ELSE 
       PUT /*-- c-mess[25] at 26 */ SKIP
           /*-- c-mess[26] at 26 */ SKIP.

    PUT /*-- c-mess[27] at 26 */ SKIP
        /*-- c-mess[28] at 26 */ SKIP
        /*-- c-mess[29] at 26 */ skip(2).

    */  
END PROCEDURE. /*pi-imprime-cabecalho*/


PROCEDURE pi-faz-rodape.

    put " " skip 
        "                                          Folha: " 
        i-folhas-imp format ">9" 
        "/" format "X(1)"
        i-folhas  format ">9"
        "       C O N T I N U A   (Convenio 54/96)".
    if nota-fiscal.serie = "1" or nota-fiscal.serie = "3" then
        put " " skip(9).
    else 
        put " " skip(2).

    put "************************" at 01
        "************************" at 29
        "************************" at 56
        "************************" at 84 
        "************************" at 109 skip(1)
        "************************" at 01
        "************************" at 29
        "************************" at 56
        "************************" at 84             
        "************************" at 109
        " " AT 01 SKIP(26). /* feito este put de branco pois se ficar na linha de salto
         de pagina, n∆o esta considerando o skip. Colocando o branco resolve o problema */
    
    PUT nota-fiscal.nr-nota-fis  /*format "999,999"*/ AT 125  skip(4).
    assign i-cont-item  = 0. 
END PROCEDURE.

PROCEDURE pi-calcula-volumes.

   def var i-nr-volumes    as int.
   def var i-tmp           as int.
   def var ind             as int.
   def var de-tmp          as dec format "99.999999999".
   def var de-vol-tmp      as dec.
   def var de-tmp-acum     as dec format "99.999999999".

   DEF VAR lItemBranco     AS LOGICAL    NO-UNDO.
   DEF VAR iNrVol          LIKE volume-nf.nr-volume NO-UNDO.
   DEF VAR i-vol-exp       AS INTEGER      NO-UNDO.
   DEF VAR i-nr-vol-aux    AS INTEGER      NO-UNDO INITIAL 0.

   assign i-nr-volumes = 0.

   for each tt-resto:
       delete tt-resto.
   end.
   for each volume-nf
       where volume-nf.cod-estabel = nota-fiscal.cod-estabel
         and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
         and volume-nf.serie       = nota-fiscal.serie:
       delete volume-nf.
   end.

   for each it-nota-fisc fields(it-codigo qt-faturada) of nota-fiscal NO-LOCK 
       where not it-nota-fisc.it-codigo begins "servico",
       first item FIELDS(comprim largura altura peso-bruto peso-liq) NO-LOCK 
             where item.it-codigo = it-nota-fisc.it-codigo
       break by it-nota-fisc.it-codigo:

       if not it-nota-fisc.it-codigo begins "4" or
          nota-fiscal.nome-transp = "MALOTE" then do:
          ASSIGN lItemBranco = YES.
          NEXT.
       end.

       IF nota-fiscal.nat-operacao BEGINS "7" THEN
           find first item-caixa no-lock
                where item-caixa.sigla-emb BEGINS "e"
                  and item-caixa.it-codigo = it-nota-fisc.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? no-error.
       ELSE 
           find first item-caixa no-lock
                where item-caixa.sigla-emb = "cx"
                  and item-caixa.it-codigo = it-nota-fisc.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? no-error.

       if item.comprim = 0 or item.largura = 0 or item.altura = 0 then do:
          if avail item-caixa then do:
             assign i-tmp = trunc(it-nota-fisc.qt-faturada[1] / item-caixa.qt-item,0).
             if it-nota-fisc.qt-faturada[1] mod item-caixa.qt-item > 0 then
                assign i-tmp = i-tmp + 1.

             do ind = i-proximo-vol to (i-proximo-vol + i-tmp) - 1:
                 /* gera etiquetas dos itens da estrutura para as centrais */
                IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                   FOR EACH estrutura NO-LOCK
                       WHERE estrutura.it-codigo = it-nota-fisc.it-codigo
                       AND   estrutura.data-inicio <= TODAY
                       AND   estrutura.data-termino >= TODAY
                       AND   NOT estrutura.es-codigo BEGINS "43":
                       find first volume-nf
                          where volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                             and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                             and volume-nf.serie       = nota-fiscal.serie
                             and volume-nf.it-codigo   = estrutura.es-codigo
                             and volume-nf.nr-volume   = ind no-error.
                      if not avail volume-nf then do:
                         create volume-nf.
                         assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                                volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                                volume-nf.serie       = nota-fiscal.serie
                                volume-nf.it-codigo   = estrutura.es-codigo
                                volume-nf.nr-volume   = ind.
                      end.
                      assign volume-nf.qtde = estrutura.quant-usada
                             volume-nf.varios-itens = YES
                             volume-nf.sigla-emb = item-caixa.sigla-emb.
                   END.
                END.
                ELSE DO:
                     find first volume-nf
                        where volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                           and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                           and volume-nf.serie       = nota-fiscal.serie
                           and volume-nf.it-codigo   = it-nota-fisc.it-codigo
                           and volume-nf.nr-volume   = ind no-error.
                    if not avail volume-nf then do:
                       create volume-nf.
                       assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                              volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                              volume-nf.serie       = nota-fiscal.serie
                              volume-nf.it-codigo   = it-nota-fisc.it-codigo
                              volume-nf.nr-volume   = ind.
                    end.
                    assign volume-nf.qtde = if ind = (i-proximo-vol + i-tmp) - 1 and
                                               it-nota-fisc.qt-faturada[1] mod item-caixa.qt-item > 0 then
                                               it-nota-fisc.qt-faturada[1] mod item-caixa.qt-item
                                            else
                                               item-caixa.qt-item.
                    ASSIGN volume-nf.sigla-emb  = item-caixa.sigla-emb.
                END.
             end.
             assign i-proximo-vol = i-proximo-vol + i-tmp.
          end.  /**** avail item caixa dentro do comprim, altura, largura = 0 ****/
          else do:
              find first tt-resto 
                   where tt-resto.it-codigo = it-nota-fisc.it-codigo no-error.
              if not avail tt-resto then do:
                 create tt-resto.
                 assign tt-resto.it-codigo = it-nota-fisc.it-codigo.
              end.
              ASSIGN tt-resto.qtde = it-nota-fisc.qt-faturada[1].
          end. 
       END. /*** comprim, largura, altura = 0 ****/
       else do:
          find first tt-resto 
               where tt-resto.it-codigo = it-nota-fisc.it-codigo no-error.
          if not avail tt-resto then do:
             create tt-resto.
             assign tt-resto.it-codigo = it-nota-fisc.it-codigo.
          end.

          if avail item-caixa then do:
             if it-nota-fisc.qt-faturada[1] >= item-caixa.qt-item then do:
                assign i-tmp = trunc(it-nota-fisc.qt-faturada[1] / item-caixa.qt-item,0)
                       tt-resto.qtde = tt-resto.qtde +
                                       it-nota-fisc.qt-faturada[1] MOD item-caixa.qt-item.
                do ind = i-proximo-vol to (i-proximo-vol + i-tmp) - 1:
                    IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                       FOR EACH estrutura NO-LOCK
                           WHERE estrutura.it-codigo = it-nota-fisc.it-codigo
                           AND   estrutura.data-inicio <= TODAY
                           AND   estrutura.data-termino >= TODAY
                           AND   NOT estrutura.es-codigo BEGINS "43":
                           find first volume-nf 
                              where volume-nf.cod-estabel = nota-fiscal.cod-estabel
                              AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                              AND   volume-nf.serie       = nota-fiscal.serie
                              AND   volume-nf.it-codigo   = estrutura.es-codigo
                              AND   volume-nf.nr-volume   = ind no-error.
                          if not avail volume-nf then do:
                             create volume-nf.
                             assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                                    volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis 
                                    volume-nf.serie       = nota-fiscal.serie
                                    volume-nf.it-codigo   = estrutura.es-codigo   
                                    volume-nf.nr-volume   = ind no-error.       
                          END.
                          assign volume-nf.qtde = estrutura.quant-usada
                                 volume-nf.sigla-emb = item-caixa.sigla-emb
                                 volume-nf.varios-itens = YES.
                       END.
                    END.
                    ELSE DO:
                       find first volume-nf 
                            where volume-nf.cod-estabel = nota-fiscal.cod-estabel
                              and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                              and volume-nf.serie       = nota-fiscal.serie
                              and volume-nf.it-codigo   = it-nota-fisc.it-codigo
                              and volume-nf.nr-volume   = ind no-error.
                       if not avail volume-nf then do:
                          create volume-nf.
                          assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                                 volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                                 volume-nf.serie       = nota-fiscal.serie
                                 volume-nf.it-codigo   = it-nota-fisc.it-codigo
                                 volume-nf.nr-volume   = ind.
                       end.
                       assign volume-nf.qtde      = item-caixa.qt-item
                              volume-nf.sigla-emb = item-caixa.sigla-emb.
                    END.
                end.
                assign i-proximo-vol = i-proximo-vol + i-tmp.
             end.
             else do:
                assign tt-resto.qtde = tt-resto.qtde + it-nota-fisc.qt-faturada[1].
             end.
          end. /**** AVAIL ITEM-CAIXA *******/
          else do:
              ASSIGN tt-resto.qtde = it-nota-fisc.qt-faturada[1].
          END.
       END. /***** ELSE DO ALTURA, LARGURA E COMPRIMENTO = 0 ********/
   END.

   assign de-tmp = 0
          de-tmp-acum = 0
          ind = 0.

   /**** pega a maior caixa  E COLOCO C-EMB-ESCOLHIDA EM BRANCO POIS
         S‡ VOU SABER QUAL CAIXA QUERO AP‡S SABER QUAIS OS ITENS QUE
         V«O NA CAIXA. USO A MAIOR CAIXA COMO REFERENCIAL INICIAL SOMENTE.
         O CAMPO EMITE-ROMAN IDENTICA QUAIS EMBALAGENS EST«O LIBERADAS
         NA UTILIZAÄ«O PARA COMPARTILHAR ITENS  ****/
   
   IF nota-fiscal.nat-operacao BEGINS "7" THEN DO:
      FOR EACH embalag NO-LOCK
          WHERE embalag.embalagem BEGINS "EMB"
          AND   embalag.emite-roman 
          BREAK BY embalag.volume:
          ASSIGN c-emb-escolhida = embalag.sigla-emb.
      END.
   END.
   ELSE 
       find first embalag no-lock
            where embalag.sigla-emb = "cx" no-error.

   for each tt-resto where tt-resto.qtde <> 0,
       first ITEM FIELDS(it-codigo comprim largura altura peso-bruto peso-liq)
             where item.it-codigo = tt-resto.it-codigo
       BREAK BY tt-resto.it-codigo
             BY tt-resto.qtde:


       assign de-tmp = (item.comprim / 1000) * (item.largura / 1000) *
                       (item.altura / 1000)  * tt-resto.qtde.

       if de-tmp > embalag.volume * 0.85 then do:
           /* ASSIGN i-proximo-vol = i-proximo-vol + 1. */

          find first volume-nf
               where volume-nf.cod-estabel = nota-fiscal.cod-estabel
                 and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                 and volume-nf.serie       = nota-fiscal.serie
                 and volume-nf.it-codigo   = item.it-codigo
                 and volume-nf.nr-volume   = i-proximo-vol no-error.

          if not avail volume-nf then do:
             create volume-nf.
             assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                    volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                    volume-nf.serie       = nota-fiscal.serie
                    volume-nf.it-codigo   = item.it-codigo
                    volume-nf.nr-volume = i-proximo-vol
                    volume-nf.varios-itens = yes.
          end.
          assign volume-nf.qtde       = tt-resto.qtde
                 volume-nf.sigla-emb  = ""
                 i-proximo-vol = i-proximo-vol + 1
                 de-tmp = 0
                 de-tmp-acum = 0.

          RUN pi-grava-embalagem.

       end.
       else do:

          assign de-tmp-acum = de-tmp-acum + de-tmp
                 ind = ind + 1.

          if de-tmp-acum > embalag.volume * 0.85 or ind > 6 then do:

             RUN pi-grava-embalagem.

             assign i-proximo-vol = i-proximo-vol + 1
                    de-tmp-acum = de-tmp
                    ind = 0.
          end.

          /*** Se for o ultimo item dos restos, procura uma caixa de tamanho
               suficiente para caber o que sobrou do resto ****/
          IF LAST(tt-resto.qtde) THEN DO:
             ASSIGN de-tmp = 99.
             IF nota-fiscal.nat-operacao BEGINS "7" THEN DO:
                 FOR EACH embalag NO-LOCK
                     WHERE embalag.embalagem BEGINS "emb"
                     AND   embalag.emite-roman
                     BY embalag.volume:
                     IF de-tmp-acum - embalag.volume * 0.85 < 0 THEN DO:
                        ASSIGN de-tmp          = de-tmp-acum - embalag.volume
                               c-emb-escolhida = embalag.sigla-emb.
                        LEAVE.
                     END.
                 END.
             END.
          END.

          find first volume-nf
               where volume-nf.cod-estabel = nota-fiscal.cod-estabel
                 and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                 and volume-nf.serie       = nota-fiscal.serie
                 and volume-nf.it-codigo   = item.it-codigo
                 and volume-nf.nr-volume   = i-proximo-vol no-error.

          if not avail volume-nf then do:
             create volume-nf.
             assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                    volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                    volume-nf.serie       = nota-fiscal.serie
                    volume-nf.it-codigo   = item.it-codigo
                    volume-nf.nr-volume   = i-proximo-vol
                    volume-nf.varios-itens = yes.
          end.
          assign  volume-nf.qtde      = tt-resto.qtde
                  volume-nf.sigla-emb = "".
       end.
   end.

   RUN pi-grava-embalagem.

   IF lItemBranco THEN DO:
       find last volume-nf
            where volume-nf.cod-estabel = nota-fiscal.cod-estabel 
              and volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
              and volume-nf.serie       = nota-fiscal.serie no-error.
       IF AVAIL volume-nf THEN
            ASSIGN iNrVol = volume-nf.nr-volume + 1.
       ELSE ASSIGN iNrVol = 1.

       create volume-nf.
       assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
              volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
              volume-nf.serie       = nota-fiscal.serie
              volume-nf.it-codigo   = ""
              volume-nf.nr-volume   = iNrVol.
   END.
END PROCEDURE.

PROCEDURE Pi-grava-embalagem.
    /**** O FOR EACH ABAIXO ATUALIZA A EMBALAGEM NOS VOLUMES QUE N«O
          TINHA SIDO IDENTIFICADO O TAMANHO DA MESMA ***********/
    FOR EACH volume-nf
        where volume-nf.cod-estabel = nota-fiscal.cod-estabel
        AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
        and   volume-nf.serie       = nota-fiscal.serie
        AND   volume-nf.sigla-emb   = "":
        ASSIGN volume-nf.sigla-emb = c-emb-escolhida.
    END.
END PROCEDURE.




PROCEDURE piEnviaEmail:
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    ASSIGN cMensagem = "Prezado Cliente~n~n" +
                "Segue anexo espelho de nota(s) fiscal(is) de venda referente a Campanha 21.~n" +
                "Neste espelho constam todos os dados impressos na nota, inclusivo o Nß do PEDIDO, CONTRATO e ITEM.~n" +
                "Qualquer d£vida solicitamos entrar em contato via e-mail ou telefone abaixo.~n~n" +
                "Att,~n~n" +
                "Naira R. Weiler~n" +
                "Neg¢cios Corporativos~n" +
                "Fone: (48) 3281 9553~n" +
                "naira@intelbras.com.br".

    /** SESSION:TEMP-DIRECTORY pra n∆o usar C:\temp hardcoded **/
    ASSIGN vArqMail = c-dir-arquivo-session + "/" + tt-nota-fiscal.requisitante + ".txt".
    
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = tt-nota-fiscal.e-mail
           tt-mail.remetente     = "naira@intelbras.com.br"
           tt-mail.Assunto       = "Espelho de Nota Fiscal"
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        /*CHR(10) + CHR(10) + */

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    
    FOR EACH tt-erro:
        MESSAGE tt-erro.mensagem
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.
