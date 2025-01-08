/***********************************************************************
**  Programa..: ESP/FTP/ESFTP032RP.P
**  Autor.....: Felipe Braun Azambuja
**  Data......: Julho/2007
**  Descricao.: Relatorio agrupado de Vendas
**  VersÆo....: 000 05/07/2007
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP032 2.04.00.000}

/****************************  Definitions  ****************************/
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
{esp/ftp/esftp032tt.i}

/****************************  Variaveis    ****************************/
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
def var d-dt-ent         like ped-venda.dt-emiss.
def var c-obs            as char format "X(85)".
def var i-atendente      like ped-venda.tp-pedido.
def var c-mail           as char format "X(40)".
def var i-p-medio        as dec format ">>>>>>9".
def var c-unid-neg       as char format "X(10)".
def var de-perc-comissao as dec format ">9.99".
DEF VAR c-desc-cond      LIKE cond-pagto.descricao.
DEF VAR de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant LIKE ped-venda.dt-implant.
DEFINE VARIABLE c-familia AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rep-matriz       LIKE repres.cod-rep.
DEF VARIABLE c-nome-rep            LIKE repres.nome.
DEFINE BUFFER b-emitente FOR emitente.

DEFINE VARIABLE dt-data     AS DATE     NO-UNDO.
DEFINE VARIABLE d-vl-item   AS DECIMAL  NO-UNDO.
DEFINE VARIABLE i-qt-item   AS INTEGER  NO-UNDO.

FORM     tt-result.periodo 
         tt-result.cod-matriz COLUMN-LABEL "Cod.Matriz"
         tt-result.nome-matriz COLUMN-LABEL "Nome Matriz"
         tt-result.cod-emitente     
         tt-result.nome-emit        
         tt-result.rep-matriz
         tt-result.nome-rep-matriz
         tt-result.cod-familia
         tt-result.desc-gr-cli
         tt-result.estado
         tt-result.desc-sub-familia
         tt-result.unid-neg
         tt-result.qt-item
         tt-result.vl-item
         emitente.cod-rep
         repres.nome-abrev
WITH FRAME f-detalhe WIDTH 500 64 DOWN STREAM-IO.


/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FOR FIRST estabelec NO-LOCK
    WHERE estabelec.ep-codigo = empresa.ep-codigo: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio agrupado de Vendas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP032"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
/*
A fam¡lia Comercial dever  seguir o seguinte formato:
GGSSMMCC
Onde: 
 GG - Indica‡Æo do grupo do Produto (Num‚rico);     1,2
 SS - Indica‡Æo do subgrupo do Produto (Num‚rico);  3,2
 MM - Indica‡Æo da Marca do Produto (Num‚rico);     5,2
 CC - Indica‡Æo do Complemento (Num‚rico).          7,2
*/
DEF VAR cRegiao AS CHAR FORMAT 'x(40)'.
DEF VAR cPerc   AS CHAR FORMAT 'x(05)'.
DEF VAR a AS DEC FORMAT ">>>,>>>,>>9.99".


PROCEDURE piImprimeRelat:
    

   DO dt-data = tt-param.dt-data-ini TO tt-param.dt-data-fim:
      FOR EACH nota-fiscal  NO-LOCK
         WHERE nota-fiscal.dt-emis-nota  = dt-data
           AND nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
           AND nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
           AND nota-fiscal.cod-emitente >= tt-param.i-cod-cli-ini
           AND nota-fiscal.cod-emitente <= tt-param.i-cod-cli-fim
           AND nota-fiscal.dt-cancel     = ?,
         FIRST emitente FIELDS (cod-emitente nome-matriz nome-emit cgc cod-gr-cli cod-rep estado) NO-LOCK
            WHERE   emitente.cod-emitente  = nota-fiscal.cod-emitente
              AND   emitente.cod-gr-cli   >= tt-param.i-gr-cli-ini
              AND   emitente.cod-gr-cli   <= tt-param.i-gr-cli-fim
              AND   emitente.cod-rep      >= tt-param.i-cod-rep-ini
              AND   emitente.cod-rep      <= tt-param.i-cod-rep-fim
              AND ((emitente.cgc          >= c-cgc-ini
                AND emitente.cgc          <= c-cgc-fim)
               OR   emitente.cgc           = ?),
         FIRST b-emitente FIELDS (cod-emitente nome-abrev nome-emit cod-rep) NO-LOCK
            WHERE b-emitente.nome-abrev    = emitente.nome-matriz
              AND b-emitente.cod-emitente >= tt-param.i-cod-matriz-ini
              AND b-emitente.cod-emitente <= tt-param.i-cod-matriz-fim,
         EACH it-nota-fisc  OF nota-fiscal NO-LOCK,
          FIRST natur-oper no-lock
          WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao
            AND natur-oper.atual-estat,

         FIRST item FIELDS (it-codigo desc-item fm-cod-com) OF it-nota-fisc NO-LOCK
               WHERE ITEM.fm-cod-com >= tt-param.i-familia-ini
                 AND ITEM.fm-cod-com <= tt-param.i-familia-fim:

         RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + STRING(dt-data, "99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
         
          assign c-unid-neg = it-nota-fisc.cod-unid-neg.
         IF i-classificacao = 1 THEN
             ASSIGN c-familia  = ITEM.fm-cod-com.
         ELSE 
             ASSIGN c-familia = "".

         FIND FIRST repres NO-LOCK
              WHERE repres.cod-rep = nota-fiscal.cod-rep NO-ERROR.

         IF  AVAIL repres THEN
             ASSIGN c-rep-matriz       = repres.cod-rep
                    c-nome-rep         = repres.nome.
         ELSE DO:
             ASSIGN c-rep-matriz       = emitente.cod-rep.
             FIND FIRST repres NO-LOCK
                  WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.
             IF AVAIL repres THEN
                ASSIGN c-nome-rep = repres.nome.
             ELSE
                ASSIGN c-nome-rep = ""
                       c-rep-matriz = 0.

         END.

         FIND FIRST tt-result NO-LOCK
            WHERE tt-result.cod-matriz      = b-emitente.cod-emitente
              AND tt-result.rep-matriz      = c-rep-matriz
              AND tt-result.cod-emitente    = emitente.cod-emitente
              AND tt-result.cod-gr-cli      = emitente.cod-gr-cli
              AND tt-result.estado          = emitente.estado
              AND tt-result.cod-familia     = c-familia
              AND tt-result.unid-neg        = c-unid-neg
              AND tt-result.periodo         = STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99") NO-ERROR.

         IF NOT AVAILABLE tt-result THEN DO:   
             
            FIND FIRST gr-cli NO-LOCK
               WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

            CREATE tt-result.
            ASSIGN tt-result.cod-matriz       = b-emitente.cod-emitente
                   tt-result.nome-matriz      = b-emitente.nome-emit
                   tt-result.cod-emitente     = emitente.cod-emitente
                   tt-result.nome-emit        = emitente.nome-emit
                   tt-result.rep-matriz       = c-rep-matriz
                   tt-result.nome-rep-matriz  = c-nome-rep.
            
            FIND fam-comerc
                 WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
                 NO-LOCK NO-ERROR.

            ASSIGN tt-result.cod-gr-cli       = emitente.cod-gr-cli
                   tt-result.desc-gr-cli      = gr-cli.descricao
                   tt-result.estado           = emitente.estado
                   tt-result.cod-familia      = c-familia
                   tt-result.desc-sub-familia = (IF i-classificacao = 1 THEN (IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE "NAO ENCONTRADO") ELSE "")   
                   tt-result.unid-neg         = c-unid-neg
                   tt-result.periodo          = STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99").


            RELEASE repres.
         END. /** IF NOT AVAILABLE **/

         ASSIGN tt-result.qt-item = tt-result.qt-item + it-nota-fisc.qt-faturada[1]
                tt-result.vl-item = tt-result.vl-item + it-nota-fisc.vl-merc-liq.

      END. /** FOR EACH **/

      FOR EACH devol-cli NO-LOCK
         WHERE devol-cli.cod-estabel  >= tt-param.cod-estabel-ini
           AND devol-cli.cod-estabel  <= tt-param.cod-estabel-fim
           AND devol-cli.dt-devol      = dt-data
           AND devol-cli.cod-emitente >= tt-param.i-cod-cli-ini
           AND devol-cli.cod-emitente <= tt-param.i-cod-cli-fim,
         FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
              AND nota-fiscal.serie       = devol-cli.serie
              AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis
              AND nota-fiscal.emite-duplic,
         FIRST emitente FIELDS (cod-emitente nome-matriz nome-emit cgc cod-gr-cli cod-rep estado) NO-LOCK
            WHERE   emitente.cod-emitente  = nota-fiscal.cod-emitente
              AND   emitente.cod-gr-cli   >= tt-param.i-gr-cli-ini
              AND   emitente.cod-gr-cli   <= tt-param.i-gr-cli-fim
              AND   emitente.cod-rep      >= tt-param.i-cod-rep-ini
              AND   emitente.cod-rep      <= tt-param.i-cod-rep-fim
              AND ((emitente.cgc          >= c-cgc-ini
              AND   emitente.cgc          <= c-cgc-fim)
               OR   emitente.cgc           = ?),
         FIRST b-emitente FIELDS (cod-emitente nome-abrev nome-emit cod-rep estado) NO-LOCK
            WHERE b-emitente.nome-abrev    = emitente.nome-matriz
              AND b-emitente.cod-emitente >= tt-param.i-cod-matriz-ini
              AND b-emitente.cod-emitente <= tt-param.i-cod-matriz-fim,
         EACH item-doc-est OF devol-cli NO-LOCK,
          first it-nota-fisc no-lock
             where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
               and it-nota-fisc.serie       = devol-cli.serie
               and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
               and it-nota-fisc.it-codigo   = devol-cli.it-codigo
               and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
           FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao
                 AND   natur-oper.atual-estat,
         FIRST item FIELDS (it-codigo desc-item fm-cod-com) NO-LOCK
            WHERE item.it-codigo = item-doc-est.it-codigo
              AND ITEM.fm-cod-com >= tt-param.i-familia-ini
              AND ITEM.fm-cod-com <= tt-param.i-familia-fim:


  
         RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + STRING(dt-data, "99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).

         assign c-unid-neg = it-nota-fisc.cod-unid-neg.
         IF i-classificacao = 1 THEN
             ASSIGN c-familia  = ITEM.fm-cod-com.
         ELSE 
             ASSIGN c-familia = "".

         FIND FIRST repres NO-LOCK
              WHERE repres.cod-rep = nota-fiscal.cod-rep NO-ERROR.

         IF  AVAIL repres THEN
             ASSIGN c-rep-matriz       = repres.cod-rep
                    c-nome-rep         = repres.nome.
         ELSE DO:
             ASSIGN c-rep-matriz       = emitente.cod-rep.
             FIND FIRST repres NO-LOCK
                  WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.
             IF AVAIL repres THEN
                ASSIGN c-nome-rep = repres.nome.
             ELSE
                ASSIGN c-nome-rep = ""
                       c-rep-matriz = 0.

         END.

         FIND FIRST tt-result NO-LOCK
            WHERE tt-result.cod-matriz      = b-emitente.cod-emitente
              AND tt-result.rep-matriz      = c-rep-matriz
              AND tt-result.cod-gr-cli      = emitente.cod-gr-cli
              AND tt-result.estado          = emitente.estado
              AND tt-result.cod-emitente    = emitente.cod-emitente
              AND tt-result.cod-familia     = c-familia
              AND tt-result.unid-neg        = c-unid-neg
              AND tt-result.periodo         = STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99") NO-ERROR.

         IF NOT AVAILABLE (tt-result) THEN DO:                
            FIND FIRST repres NO-LOCK
               WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-ERROR.
            FIND FIRST gr-cli NO-LOCK
               WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

            CREATE tt-result.
            ASSIGN tt-result.cod-matriz       = b-emitente.cod-emitente
                   tt-result.nome-matriz      = b-emitente.nome-emit
                   tt-result.cod-emitente     = emitente.cod-emitente
                   tt-result.nome-emit        = emitente.nome-emit
                   tt-result.rep-matriz       = c-rep-matriz
                   tt-result.nome-rep-matriz  = c-nome-rep.

            FIND fam-comerc
                 WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
                 NO-LOCK NO-ERROR.

            ASSIGN tt-result.cod-gr-cli       = emitente.cod-gr-cli
                   tt-result.desc-gr-cli      = gr-cli.descricao
                   tt-result.estado           = emitente.estado
                   tt-result.cod-familia      = c-familia
                   tt-result.desc-sub-familia = (IF i-classificacao = 1 THEN (IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE "NAO ENCONTRADO") ELSE "")
                   tt-result.unid-neg         = c-unid-neg
                   tt-result.periodo          = STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99").

            RELEASE repres.
         END. /** IF NOT AVAILABLE **/

         ASSIGN tt-result.qt-item = tt-result.qt-item - item-doc-est.quantidade
                tt-result.vl-item = tt-result.vl-item - item-doc-est.preco-total[1].

      END. /** FOR EACH **/
   END. /** DO **/

   PUT "Per¡odo; Matriz ; Nome Matriz ;C¢digo; Nome ; Repres; Repres.; Fam Cml;  Gr. Cliente; UF;   Familia Comercial; Unid Neg  ; Qt ;Vl Mercad Liq ;Rep ;Nome Abreviado;" SKIP.

   FOR EACH tt-result:

       FIND emitente
            WHERE emitente.cod-emitente = tt-result.cod-emitente
            NO-LOCK NO-ERROR.

 
      PUT
                 tt-result.periodo     ";"
                 tt-result.cod-matriz  ";"
                 tt-result.nome-matriz ";" 
                 tt-result.cod-emitente ";"     
                 tt-result.nome-emit    ";"     
                 tt-result.rep-matriz   ";"
                 tt-result.nome-rep-matriz ";"
                 tt-result.cod-familia    ";"
                 tt-result.desc-gr-cli    ";"
                 tt-result.estado         ";"
                 tt-result.desc-sub-familia ";"
                 tt-result.unid-neg          ";"
                 tt-result.qt-item           ";"
                 tt-result.vl-item          ";".  
                 
      IF AVAIL emitente THEN DO:
         PUT emitente.cod-rep ";".
                      

         FIND repres
              WHERE repres.cod-rep = emitente.cod-rep
              NO-LOCK NO-ERROR.
         IF AVAIL repres THEN DO:
             PUT repres.nome-abrev ";".
                 
             
         END.
      END.
      PUT SKIP.
   END.

END PROCEDURE.

