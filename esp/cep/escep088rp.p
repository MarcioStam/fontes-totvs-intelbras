
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep088brp 3.00.00.000 }

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino       AS INTEGER
    FIELD arquivo       AS CHAR
    FIELD usuario       AS CHAR FORMAT "x(12)"
    FIELD data-exec     AS DATE
    FIELD data-geracao  AS DATE
    FIELD log-rpw       AS LOG.

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

{cdp/cd0666.i}
{esp/ftp/esftp083tt.i}
{esp/es0018.i}

DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   

DEF TEMP-TABLE tt-item-consumo NO-UNDO
    FIELD cod-estabel   AS CHAR
    FIELD it-codigo     AS CHAR 
    FIELD periodo       AS CHAR
    FIELD consumo-atual AS DEC
    INDEX idx cod-estabel
              it-codigo
              periodo.

DEF TEMP-TABLE tt-item-consumo-nf NO-UNDO
    FIELD nr-nota-fis   AS CHAR
    FIELD serie         AS CHAR
    FIELD cod-estabel   AS CHAR
    FIELD it-codigo     AS CHAR 
    INDEX idx nr-nota-fis 
              serie  
              cod-estabel
              it-codigo.

DEF TEMP-TABLE tt-item-plan NO-UNDO
    FIELD it-codigo AS CHAR.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var c-erro          as char                         no-undo.
def var c-erro1         as char                         no-undo.
def var h-acomp         as handle                       no-undo.
def var cLinha          as char                         no-undo.
def var cEstab          as char                         no-undo.
def var cDepos          as char                         no-undo.
def var cItem           as char                         no-undo.
def var i-aux           as int                          no-undo.


DEFINE VARIABLE cAcomp                      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estab-ressup              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-item                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-un                        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-saldo-inicial            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-atual              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-consumo-atual            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-origem             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-cubagem-item             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dePercentualAtendimento     AS DECIMAL     NO-UNDO.

                                            
DEFINE VARIABLE de-ressup-mes               AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-demanda-atual            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-demanda-m1               AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-demanda-m2               AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-previsao-venda-mes       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtde-aloc-prod           AS DECIMAL     NO-UNDO. 
DEFINE VARIABLE de-qtde-aloc-ped            AS DECIMAL     NO-UNDO. 
                                            
DEFINE VARIABLE de-producao-atual           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-producao-m1              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-producao-m2              AS DECIMAL     NO-UNDO.

DEFINE VARIABLE de-oem-atual                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-oem-m1                   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-oem-m2                   AS DECIMAL     NO-UNDO.
                                            
DEFINE VARIABLE de-estoq-transferir         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-estoq-transito           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-entrega-saldo-enviar     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-quant-ressup-periodo     AS DECIMAL     NO-UNDO.


DEFINE VARIABLE deCalculo-1                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deCalculo-2                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-carga-restante           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-reservas-ast             AS DECIMAL     NO-UNDO.

DEFINE VARIABLE da-iniper-fech              AS DATE        NO-UNDO.
DEFINE VARIABLE da-fimper-fech              AS DATE        NO-UNDO.
DEFINE VARIABLE da-iniperM0                 AS DATE        NO-UNDO.
DEFINE VARIABLE da-fimperM0                 AS DATE        NO-UNDO.
DEFINE VARIABLE da-iniperM1                 AS DATE        NO-UNDO.
DEFINE VARIABLE da-fimperM1                 AS DATE        NO-UNDO.
DEFINE VARIABLE da-iniperM2                 AS DATE        NO-UNDO.
DEFINE VARIABLE da-fimperM2                 AS DATE        NO-UNDO.
DEFINE VARIABLE i-per-m0                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-m0                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-per-m1                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-m1                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-per-m2                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-m2                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-per-m3                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-m3                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-sequencia                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE fechamentoM0                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fechamentoM1                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fechamentoM2                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-central-config            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-achou                     AS LOGICAL     NO-UNDO.

DEFINE VARIABLE dt-today       AS DATE        NO-UNDO.

DEFINE VARIABLE i-mes AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-int-item-estab-depos-pv FOR int-item-estab-depos-pv.
DEFINE TEMP-TABLE tt-int-dados-bi   NO-UNDO LIKE int-dados-bi.

FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG) FORWARD.

FUNCTION fnDispFat RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG) FORWARD.


DEF STREAM stExp.
DEF STREAM stImp.

//DEF STREAM s-log.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FORM 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    "Data Geraá∆o"  colon 45
    "-" tt-param.data-geracao    format "99/99/9999"   NO-LABEL
    skip(1)
    tt-param.usuario            colon 60
    with stream-io down width 132 side-labels frame f-det.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Processando * r}
run pi-inicializar in h-acomp (input trim(return-value)).

{include/i-rpvar.i}
DEFINE NEW GLOBAL SHARED VARIABLE v_cdn_empres_usuar            AS CHARACTER    NO-UNDO.

find first mguni.empresa
     where empresa.ep-codigo = v_cdn_empres_usuar no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Geraá∆o Dados Analit°cos" * L}
assign c-titulo-relat = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.



IF tt-param.log-rpw THEN
   ASSIGN tt-param.data-geracao = TODAY.


RUN pi-gera-dados.


{utp/ut-liter.i IMPRESS«O * r}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Usu†rio * r}
assign tt-param.usuario:label in frame f-det = trim(return-value).

disp c-impressao
     tt-param.data-geracao
     tt-param.usuario
     with frame f-det.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK".


/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE pi-gera-dados:
    DEFINE VARIABLE iTimeIni AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTimeFim AS INTEGER     NO-UNDO.

    //OUTPUT STREAM s-log TO 'c:\temp\vitor\escep088.csv'.

    ASSIGN iTimeIni = TIME.
    ASSIGN  i-per-m0 = MONTH(TODAY)
            i-ano-m0 = YEAR(TODAY ).
    ASSIGN  i-per-m1 = IF i-per-m0 = 12 THEN 1 ELSE i-per-m0 + 1.
            i-ano-m1 = IF i-per-m1 = 1  THEN i-ano-m0 + 1 ELSE i-ano-m0.
    ASSIGN  i-per-m2 = IF i-per-m1 = 12 THEN 1 ELSE i-per-m1 + 1.
            i-ano-m2 = IF i-per-m2 = 1  THEN i-ano-m1 + 1 ELSE i-ano-m1.
    ASSIGN  i-per-m3 = IF i-per-m2 = 12 THEN 1 ELSE i-per-m2 + 1.
            i-ano-m3 = IF i-per-m3 = 1  THEN i-ano-m2 + 1 ELSE i-ano-m2.
    ASSIGN  da-iniperM0 = DATE(i-per-m0,01,i-ano-m0)
            da-fimperM0 = DATE(i-per-m1,01,i-ano-m1) - 1.
    ASSIGN  da-iniperM1 = DATE(i-per-m1,01,i-ano-m1)
            da-fimperM1 = DATE(i-per-m2,01,i-ano-m2) - 1.
    ASSIGN  da-iniperM2 = DATE(i-per-m2,01,i-ano-m2)
            da-fimperM2 = DATE(i-per-m3,01,i-ano-m3) - 1.
    /*-----------------------------------*/

    /* #Alteraá∆o para pegar periodo de 21 a 20 
    ASSIGN dt-today = TODAY.

    IF DAY(dt-today) < 21 THEN
        ASSIGN i-mes = MONTH(dt-today) - 1.
    ELSE
        ASSIGN i-mes = MONTH(dt-today).
    
    IF i-mes < 1 THEN
        ASSIGN i-mes = 12
               i-ano = YEAR(dt-today) - 1.
    ELSE
        ASSIGN i-ano = YEAR(dt-today).
    
    IF i-mes = 12 AND i-ano = 2023 THEN
        ASSIGN da-iniperM0 = DATE(i-mes,23,i-ano).
    ELSE
        ASSIGN da-iniperM0 = DATE(i-mes,21,i-ano).
    
    RUN pi-fim-periodo(INPUT da-iniperM0,                           
                       OUTPUT da-fimperM0).
    
    ASSIGN da-iniperM1 = DATE(MONTH(da-fimperM0),21,YEAR(da-fimperM0)).
    
    RUN pi-fim-periodo(INPUT da-iniperM1,                           
                       OUTPUT da-fimperM1).
    
    ASSIGN da-iniperM2 = DATE(MONTH(da-fimperM1),21,YEAR(da-fimperM1)).
    
    RUN pi-fim-periodo(INPUT da-iniperM2,                           
                       OUTPUT da-fimperM2).

    ASSIGN i-per-m0 = MONTH(da-fimperM0)
           i-ano-m0 = YEAR(da-fimperM0)
           i-per-m1 = MONTH(da-fimperM1)
           i-ano-m1 = YEAR(da-fimperM1) 
           i-per-m2 = MONTH(da-fimperM2)
           i-ano-m2 = YEAR(da-fimperM2).
    /*-----------------------------------*/
    */

    FOR EACH int-estabel-ressuprimento NO-LOCK:
        IF NOT CAN-FIND(FIRST int-estabel-origem-ressup NO-LOCK
                        WHERE int-estabel-origem-ressup.cod-estabel-ressup  = int-estabel-ressuprimento.cod-estabel-ressup
                          AND int-estabel-origem-ressup.cod-depos-ressup    = int-estabel-ressuprimento.cod-depos-ressup)
        THEN NEXT.

        EMPTY TEMP-TABLE tt-item-consumo.
        EMPTY TEMP-TABLE tt-item-consumo-nf.

        FOR  EACH int-estabel-origem-ressup NO-LOCK
            WHERE int-estabel-origem-ressup.cod-estabel-ressup  = int-estabel-ressuprimento.cod-estabel-ressup
              AND int-estabel-origem-ressup.cod-depos-ressup    = int-estabel-ressuprimento.cod-depos-ressup:

            RUN piCalculaConsumoAtualReservas.
            FOR  EACH int-item-estab-depos NO-LOCK
                WHERE int-item-estab-depos.cod-estabel = int-estabel-origem-ressup.cod-estabel-ressup
                 AND int-item-estab-depos.cod-depos    = int-estabel-origem-ressup.cod-depos-ressup:
                 //AND int-item-estab-depos.it-codigo = '4613532'   : /*Gustavo */ 
               

                ASSIGN cAcomp =             "Orig:"  + int-estabel-origem-ressup.cod-estabel-origem + "/" + int-estabel-origem-ressup.cod-depos-origem.
                ASSIGN cAcomp = cAcomp +    " - Dest:" + int-estabel-origem-ressup.cod-estabel-ressup + "/" + int-estabel-origem-ressup.cod-depos-ressup.
                ASSIGN cAcomp = cAcomp +    " - Item:"  + int-item-estab-depos.it-codigo.

                run pi-acompanhar in h-acomp (input cAcomp).

                ASSIGN  c-des-item      = ""
                        c-un            = ""
                        c-cod-estabel   = "".
                FOR FIRST ITEM fields(desc-item un cod-estabel ge-codigo)NO-LOCK
                    WHERE ITEM.it-codigo = int-item-estab-depos.it-codigo:
                    ASSIGN  c-des-item      = ITEM.desc-item
                            c-un            = ITEM.un
                            c-cod-estabel   = ITEM.cod-estabel.
                END.
                //Deve gerar os dados somente do estabelecimento padr∆o do item.
                IF c-cod-estabel <> int-estabel-origem-ressup.cod-estabel-origem THEN NEXT.

                CREATE  tt-int-dados-bi.
                ASSIGN  i-sequencia                             = i-sequencia + 1
                        tt-int-dados-bi.sequencia               = i-sequencia
                        tt-int-dados-bi.data-geracao            = TODAY
                        tt-int-dados-bi.cod-estabel-origem      = int-estabel-origem-ressup.cod-estabel-origem
                        tt-int-dados-bi.it-codigo               = int-item-estab-depos.it-codigo.

                ASSIGN  tt-int-dados-bi.cod-estabel-ressup      = int-item-estab-depos.cod-estabel
                        tt-int-dados-bi.des-item                = c-des-item
                        tt-int-dados-bi.un                      = c-un
                        tt-int-dados-bi.politica                = int-item-estab-depos.politica
                        tt-int-dados-bi.log-estoq-minimo        = IF NOT int-item-estab-depos.log-estoq-minimo THEN 0 ELSE 1
                        tt-int-dados-bi.classif-abc             = int-item-estab-depos.classif-abc
                        tt-int-dados-bi.cubagem-carga           = int-estabel-ressuprimento.cubagem-carga.
                        //Cubagem=Capacidade do caminh∆o
                    .
                /******************************************************************************************/
                /******************************************************************************************/
                //Estoque de Seguranáa
                IF int-item-estab-depos.log-estoq-minimo
                THEN DO:
                    ASSIGN  tt-int-dados-bi.estoque-minimo      = int-item-estab-depos.estoque-minimo
                            tt-int-dados-bi.estoque-seguranca   = 0.
                END.
                ELSE DO:
                    ASSIGN  tt-int-dados-bi.estoque-minimo      = 0
                            tt-int-dados-bi.estoque-seguranca   = IF int-item-estab-depos.tipo-est-seg = 1  THEN int-item-estab-depos.quant-segur 
                                                                                                            ELSE int-item-estab-depos.tempo-segur.

                END.
                /******************************************************************************************/
                /******************************************************************************************/
                ASSIGN de-consumo-atual = 0.
                RUN piCalculaConsumoAtual.
                FIND FIRST tt-item-consumo
                     WHERE tt-item-consumo.cod-estabel = tt-int-dados-bi.cod-estabel-ressup 
                       AND tt-item-consumo.it-codigo   = tt-int-dados-bi.it-codigo   
                       AND tt-item-consumo.periodo     = STRING(MONTH(tt-int-dados-bi.data-geracao),'99') + STRING(YEAR(tt-int-dados-bi.data-geracao),'9999') 
                NO-ERROR.

                IF AVAIL tt-item-consumo THEN DO:
                    ASSIGN de-consumo-atual = tt-item-consumo.consumo-atual. //CHAMADO M2105-139
                    /*EXPORT STREAM s-log DELIMITER ";"
                                tt-int-dados-bi.cod-estabel-ressup 
                                ""
                                ""
                                tt-int-dados-bi.it-codigo
                                tt-item-consumo.consumo-atual
                                "consumo reserva".*/

                END.

     
                ASSIGN tt-int-dados-bi.consumo-atual = de-consumo-atual.

                /******************************************************************************************/
                /******************************************************************************************/
                //Busca Saldo Inicial do estabelecimento de ressuprimento
                ASSIGN de-saldo-inicial = 0.
                FOR  EACH sl-it-per fields(quantidade) USE-INDEX per-item NO-LOCK
                    WHERE sl-it-per.periodo     = DATE(MONTH(TODAY),01,YEAR(TODAY)) - 1 /*gustavo */
                      AND sl-it-per.cod-estabel = int-estabel-origem-ressup.cod-estabel-ressup
                      AND sl-it-per.it-codigo   = int-item-estab-depos.it-codigo
                      AND sl-it-per.cod-depos   = int-estabel-origem-ressup.cod-depos-ressup: 
                    ASSIGN de-saldo-inicial = de-saldo-inicial + sl-it-per.quantidade.
                END.

                /******************************************************************************************/
                /******************************************************************************************/
                //Busca Saldo Atual do estabelecimento de ressuprimento
                ASSIGN de-saldo-atual = 0
                       de-qtde-aloc-prod   = 0
                       de-qtde-aloc-ped    = 0.
                FOR  EACH saldo-estoq fields(qt-aloc-prod qt-aloc-ped cod-estabel it-codigo cod-depos cod-localiz lote) USE-INDEX dep-item NO-LOCK
                    WHERE saldo-estoq.cod-estabel   = int-item-estab-depos.cod-estabel
                      AND saldo-estoq.it-codigo     = int-item-estab-depos.it-codigo
                      AND saldo-estoq.cod-depos     = int-item-estab-depos.cod-depos:
                    ASSIGN de-qtde-aloc-prod = de-qtde-aloc-prod  + saldo-estoq.qt-aloc-prod
                           de-qtde-aloc-ped  = de-qtde-aloc-ped   + saldo-estoq.qt-aloc-ped
                           de-saldo-atual = de-saldo-atual + fnEstoque(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, saldo-estoq.lote, l-central-config).
                END.
                 
                //VERIFICAR 29/07/21 - ASSIGN de-saldo-atual = de-saldo-atual + de-qtde-aloc-ped.  
                /******************************************************************************************/
                /******************************************************************************************/
                ASSIGN l-central-config = CAN-FIND(FIRST item-uni-estab USE-INDEX codigo
                                                   WHERE item-uni-estab.it-codigo   = int-item-estab-depos.it-codigo
                                                   AND   item-uni-estab.cod-estabel = int-estabel-origem-ressup.cod-estabel-origem
                                                   AND   item-uni-estab.nr-linha    = 20).

                //Busca Saldo Origem do estabelecimento de origem
                ASSIGN de-saldo-origem = 0.
                FOR  EACH saldo-estoq fields(cod-estabel it-codigo cod-depos cod-localiz lote) USE-INDEX dep-item NO-LOCK
                    WHERE saldo-estoq.cod-estabel   = int-estabel-origem-ressup.cod-estabel-origem
                      AND saldo-estoq.it-codigo     = int-item-estab-depos.it-codigo 
                      AND saldo-estoq.cod-depos     = int-estabel-origem-ressup.cod-depos-origem:
                    ASSIGN de-saldo-origem = de-saldo-origem + fnDispFat(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, saldo-estoq.lote, l-central-config).
                END.
               
                ASSIGN  tt-int-dados-bi.saldo-inicial   = de-saldo-inicial
                        tt-int-dados-bi.saldo-atual     = de-saldo-atual
                        tt-int-dados-bi.saldo-origem    = de-saldo-origem .
               
            

                /******************************************************************************************/
                /******************************************************************************************/   
                //Demanda
                ASSIGN  de-ressup-mes       = 0
                        de-demanda-atual    = 0
                        de-demanda-m1       = 0
                        de-demanda-m2       = 0.
                        
                ASSIGN de-previsao-venda-mes = 0.
                        
                FOR  EACH int-item-estab-depos-pv NO-LOCK
                    WHERE int-item-estab-depos-pv.cod-estabel   = int-item-estab-depos.cod-estabel
                      AND int-item-estab-depos-pv.it-codigo     = int-item-estab-depos.it-codigo
                      AND int-item-estab-depos-pv.ano           = i-ano-m0:

                    ASSIGN de-previsao-venda-mes = int-item-estab-depos-pv.quant-previsao-venda[i-per-m0].

                    ASSIGN  de-demanda-atual = de-demanda-atual + int-item-estab-depos-pv.quant-previsao-venda[i-per-m0]
                            de-ressup-mes    = de-ressup-mes + int-item-estab-depos-pv.quant-previsao-venda[i-per-m0].
              
                    IF i-per-m0 = 11
                    THEN DO:
                        ASSIGN  de-demanda-m1 = de-demanda-m1 + int-item-estab-depos-pv.quant-previsao-venda[i-per-m1].
                        // Busca o M2 do ano seguinte..
                        FOR  EACH bf-int-item-estab-depos-pv NO-LOCK
                            WHERE bf-int-item-estab-depos-pv.cod-estabel    = int-item-estab-depos.cod-estabel
                              AND bf-int-item-estab-depos-pv.it-codigo      = int-item-estab-depos.it-codigo
                              AND bf-int-item-estab-depos-pv.ano            = i-ano-m2:
                            ASSIGN  de-demanda-m2 = de-demanda-m2 + bf-int-item-estab-depos-pv.quant-previsao-venda[i-per-m2]. //Janeiro
                        END.
                    END.
                    ELSE DO:
                        // Precisa Buscar o M1 e o M2 do ano seguinte...
                        IF i-per-m0 = 12 //Precisa 0 M1 do ano seguinte...
                        THEN DO:
                            FOR  EACH bf-int-item-estab-depos-pv NO-LOCK
                                WHERE bf-int-item-estab-depos-pv.cod-estabel    = int-item-estab-depos.cod-estabel
                                  AND bf-int-item-estab-depos-pv.it-codigo      = int-item-estab-depos.it-codigo
                                  AND bf-int-item-estab-depos-pv.ano            = i-ano-m1: //Ano m1 e m2 tem o mesmo valor
                                ASSIGN  de-demanda-m1 = de-demanda-m1 + bf-int-item-estab-depos-pv.quant-previsao-venda[i-per-m1]
                                        de-demanda-m2 = de-demanda-m2 + bf-int-item-estab-depos-pv.quant-previsao-venda[i-per-m2].
                            END.
                        END.
                        ELSE DO:
                            //Busca M1 e M2 do ano corrente
                            ASSIGN  de-demanda-m1 = de-demanda-m1 + int-item-estab-depos-pv.quant-previsao-venda[i-per-m1]
                                    de-demanda-m2 = de-demanda-m2 + int-item-estab-depos-pv.quant-previsao-venda[i-per-m2].
                        END.
                    END.
                END.

                ASSIGN  de-demanda-atual                = IF de-demanda-atual = 0  THEN 0 ELSE (de-demanda-atual - de-consumo-atual)  /* gustavo */
                        //Verificar 29/07/21 - de-demanda-atual                = IF de-previsao-venda-mes = 0 THEN 0 ELSE de-demanda-atual //CHAMADO M2105-140
                        tt-int-dados-bi.demanda-atual   = de-demanda-atual
                        tt-int-dados-bi.demanda-m1      = de-demanda-m1
                        tt-int-dados-bi.demanda-m2      = de-demanda-m2.

                /******************************************************************************************
                campo produá∆o-atual / produá∆o m1 / produá∆o m2:
                Ordens de produá∆o e reservas planejadas (todos os grupos de estoque) (Conforme explicaá∆o do Michel)
                +
                Pedidos OEM (todos os grupos de estoque, exceto grupo de estoque CKD 12 e 42)
                ******************************************************************************************/
                //Produá∆o
                ASSIGN  de-producao-atual   = 0
                        de-producao-m1      = 0
                        de-producao-m2      = 0
                        de-oem-atual        = 0
                        de-oem-m1           = 0
                        de-oem-m2           = 0.

                RUN piDadosPlanejamento (   INPUT da-iniperM0,
                                            INPUT da-fimperM0,
                                            INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                            INPUT int-item-estab-depos.it-codigo,
                                            OUTPUT de-producao-atual).

                RUN piDadosPlanejamento (   INPUT da-iniperM1,
                                            INPUT da-fimperM1,
                                            INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                            INPUT int-item-estab-depos.it-codigo,
                                            OUTPUT de-producao-m1).

                RUN piDadosPlanejamento (   INPUT da-iniperM2,
                                            INPUT da-fimperM2,
                                            INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                            INPUT int-item-estab-depos.it-codigo,
                                            OUTPUT de-producao-m2).

                IF  ITEM.ge-codigo <> 12 
                AND ITEM.ge-codigo <> 42 
                THEN DO:
                    RUN piCalculaOEM  ( INPUT da-iniperM0,
                                        INPUT da-fimperM0,
                                        INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                        INPUT int-item-estab-depos.it-codigo,
                                        OUTPUT de-oem-atual).

                    RUN piCalculaOEM (  INPUT da-iniperM1,
                                        INPUT da-fimperM1,
                                        INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                        INPUT int-item-estab-depos.it-codigo,
                                        OUTPUT de-oem-m1).

                    RUN piCalculaOEM (  INPUT da-iniperM2,
                                        INPUT da-fimperM2,
                                        INPUT int-estabel-origem-ressup.cod-estabel-origem,
                                        INPUT int-item-estab-depos.it-codigo,
                                        OUTPUT de-oem-m2).
                END.

                ASSIGN  tt-int-dados-bi.producao-atual  = de-producao-atual + de-oem-atual
                        tt-int-dados-bi.producao-m1     = de-producao-m1    + de-oem-m1
                        tt-int-dados-bi.producao-m2     = de-producao-m2    + de-oem-m2.

                /******************************************************************************************/
                /******************************************************************************************/
                //Estoque a Transferir
                ASSIGN  de-estoq-transferir = 0.
                FOR  EACH saldo-estoq FIELDS(qtidade-atu) USE-INDEX dep-item NO-LOCK
                    WHERE saldo-estoq.cod-depos     = int-estabel-origem-ressup.cod-depos-cdi
                      AND saldo-estoq.it-codigo     = int-item-estab-depos.it-codigo
                      AND saldo-estoq.cod-estabel   = int-estabel-origem-ressup.cod-estabel-origem:

                    //ASSIGN  de-estoq-transferir = de-estoq-transferir + saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).
                    ASSIGN  de-estoq-transferir = de-estoq-transferir + saldo-estoq.qtidade-atu.
                END.
                ASSIGN  tt-int-dados-bi.estoque-transferir  = de-estoq-transferir.
               
                
                /******************************************************************************************/
                /******************************************************************************************/
                //Estoque em Transito
                //"Buscar todas AS NF DO Estabelec, depos (CDI), item descontar da DOCUM-est as mesma NF como entrada)"
                ASSIGN  de-estoq-transito       = 0
                        de-quant-ressup-periodo = 0
                        de-carga-restante       = 0.
                RUN pCalculaEmTransito.
                ASSIGN  tt-int-dados-bi.estoque-transito             = de-estoq-transito
                        tt-int-dados-bi.entrega-quant-ressup-periodo = de-quant-ressup-periodo.

                /******************************************************************************************/
                /******************************************************************************************/
                /******************************************************************************************/
                //Ressuprimento
                ASSIGN  tt-int-dados-bi.ressup-necessidade      = (de-saldo-atual + de-estoq-transito + de-estoq-transferir) - (de-demanda-atual + int-item-estab-depos.quant-segur)
                        tt-int-dados-bi.ressup-necessidade      = IF tt-int-dados-bi.ressup-necessidade > 0 THEN 0 ELSE tt-int-dados-bi.ressup-necessidade
                        tt-int-dados-bi.ressup-mes              = (de-ressup-mes + int-item-estab-depos.quant-segur) - de-saldo-inicial

                        //15/04-2021 - O cliente deve retirar estes campos M1 e M2    
                        tt-int-dados-bi.ressup-m1               = de-demanda-m1 - de-saldo-atual 
                        tt-int-dados-bi.ressup-m2               = de-demanda-m2 - de-saldo-atual.

                /******************************************************************************************/
                /******************************************************************************************/

                // Cubagem Ressuprimento Atual
                // Deve considerar o volume
                // Deve considerar o resultado do volume = total por item
                //
                ASSIGN de-cubagem-item = 0.
                RUN piCalculaCubagemItem.

                ASSIGN tt-int-dados-bi.ressup-cubagem-carga = IF (de-cubagem-item * tt-int-dados-bi.ressup-necessidade) < 0 THEN (de-cubagem-item * tt-int-dados-bi.ressup-necessidade) * -1 ELSE (de-cubagem-item * tt-int-dados-bi.ressup-necessidade).
                       tt-int-dados-bi.cubagem-item         = de-cubagem-item.
                /******************************************************************************************/
                /******************************************************************************************/
                //Saldo a Enviar
                FOR  EACH reservas-ast
                    WHERE reservas-ast.cod-depos    = int-item-estab-depos.cod-depos
                      AND reservas-ast.it-codigo    = int-item-estab-depos.it-codigo
                      AND reservas-ast.cod-estabel  = int-item-estab-depos.cod-estabel
                      AND reservas-ast.dt-reserva   <= TODAY NO-LOCK:

                    IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY
                    THEN DO:
                        ASSIGN de-entrega-saldo-enviar  = de-entrega-saldo-enviar + reservas-ast.qt-reserva.
                    END.
                END.

                /******************************************************************************************/
                //Cardas Restantes

                //15/04/2021 - Precisa definir detalhes deste campos
                //Saldo bloqueado no WEX
                ASSIGN  dePercentualAtendimento = tt-int-dados-bi.entrega-quant-ressup-periodo / tt-int-dados-bi.ressup-mes
                        dePercentualAtendimento = IF dePercentualAtendimento = ? THEN 0 ELSE dePercentualAtendimento
                        //dePercentualAtendimento = IF dePercentualAtendimento > 999 THEN 999 ELSE dePercentualAtendimento.
                        .

                ASSIGN  tt-int-dados-bi.entrega-saldo-enviar            = de-estoq-transferir - tt-int-dados-bi.ressup-necessidade.
                ASSIGN  tt-int-dados-bi.frequencia-entrega              = int-estabel-ressuprimento.frequencia-entrega
                        tt-int-dados-bi.entrega-num-quant-restantes     = (int-estabel-ressuprimento.frequencia-entrega - de-carga-restante)
                        tt-int-dados-bi.entrega-percent-atendimento     = dePercentualAtendimento
                    
                    

                    .




                ASSIGN  deCalculo-1 = 0
                        deCalculo-2 = 0
                        deCalculo-1 = (tt-int-dados-bi.entrega-saldo-enviar / tt-int-dados-bi.entrega-num-quant-restantes)
                        deCalculo-2 = deCalculo-1 - TRUNCATE(deCalculo-1,0)
                        tt-int-dados-bi.entrega-quant-prox-entrega      = TRUNCATE(deCalculo-1,0) + IF deCalculo-2 > 0 THEN 1 ELSE 0
                        tt-int-dados-bi.entrega-quant-prox-entrega      = IF tt-int-dados-bi.entrega-quant-prox-entrega = ? THEN 0 ELSE tt-int-dados-bi.entrega-quant-prox-entrega.

            END.
        END.
    END.
    ASSIGN iTimeFim = TIME.

    run pi-acompanhar in h-acomp (input "Atualizando Dados Tabela BI").
    
    FOR  EACH int-dados-bi EXCLUSIVE-LOCK
        WHERE int-dados-bi.data-geracao = TODAY.
        DELETE int-dados-bi.
    END.

    PUT UNFORMATTED
        "Per°odo Atual....: " STRING(da-iniperM0, "99/99/9999") " - " STRING(da-fimperM0, "99/99/9999")
        SKIP
        "Per°odo M1.......: " STRING(da-iniperM1, "99/99/9999") " - " STRING(da-fimperM1, "99/99/9999")
        SKIP
        "Per°odo M2.......: " STRING(da-iniperM2, "99/99/9999") " - " STRING(da-fimperM2, "99/99/9999")
        SKIP
        "Tempo de Geraá∆o.: " STRING(iTimeFim - iTimeIni, "HH:MM:SS")
        SKIP(1).
    
    PUT UNFORMATTED
        SPACE(01)
        "Sequencia"
        SPACE(01)
        "Data Geracao"
        SPACE(01)
        "Est.Ori"
        SPACE(01)
        "Est.Res"
        SPACE(03)
        "Item"
        SPACE(14)
        "Descriá∆o Item"
        SPACE(87)
        "UN"
        SPACE(03)
        "Pol°tica"
        SPACE(13)
        "Cubagem"
        SPACE(05)
        "Saldo Inicial"
        SPACE(07)
        "Saldo Atual"
        SPACE(06)
        "Saldo Origem"
        SPACE(05)
        "Demanda Atual"
        SPACE(08)
        "Demanda M1"
        SPACE(08)
        "Demanda M2"
        SPACE(05)
        "Consumo Atual"
        SPACE(02)
        "Estoque Seguranca"
        SPACE(04)
        "Estoque M°nimo"
        SPACE(04)
        "Produá∆o Atual"
        SPACE(07)
        "Produá∆o M1"
        SPACE(07)
        "Produá∆o M2"
        SPACE(02)
        "Estoque Transferir"
        SPACE(02)
        "Estoque TrÉnsito"
        SPACE(02)
        "Ressuprimento Necessidade"
        SPACE(02)
        "Ressuprimento Cubagem"
        SPACE(02)
        "Ressuprimento Màs" 
        SPACE(02)
        "Ressuprimento M1"
        SPACE(02)
        "Ressuprimento M2"
        SPACE(01)
        "FreqÅància de Entrega"
        SPACE(02)
        "Quantidade Ressuprida Per°odo"
        SPACE(04)
        "Saldo a Enviar"
        SPACE(01)
        "Cargas Restantes"
        SPACE(03)
        "Quantidade Enviar Pr¢xima Carga"
        SPACE(01)
        "Percentual de Atendimento"
        SPACE(01)
        "Classif.ABC"
        SPACE(12)
        "Cubagem Item"
        SPACE(02)
        "Log Estoque Minimo"
        SKIP.
    
    FOR EACH tt-int-dados-bi:
        
        CREATE int-dados-bi.
        BUFFER-COPY tt-int-dados-bi TO int-dados-bi.        
    
        PUT
            tt-int-dados-bi.sequencia
            SPACE(02)
            tt-int-dados-bi.data-geracao
            SPACE(05)
            tt-int-dados-bi.cod-estabel-origem
            SPACE(03)
            tt-int-dados-bi.cod-estabel-ressup
            SPACE(01)
            tt-int-dados-bi.it-codigo
            SPACE(01)
            tt-int-dados-bi.des-item
            SPACE(01)
            tt-int-dados-bi.un
            SPACE(03)
            tt-int-dados-bi.politica
            SPACE(01)
            tt-int-dados-bi.cubagem-carga
            SPACE(01)
            tt-int-dados-bi.saldo-inicial
            SPACE(01)
            tt-int-dados-bi.saldo-atual
            SPACE(01)
            tt-int-dados-bi.saldo-origem
            SPACE(01)
            tt-int-dados-bi.demanda-atual
            SPACE(01)
            tt-int-dados-bi.demanda-m1
            SPACE(01)
            tt-int-dados-bi.demanda-m2
            SPACE(01)
            tt-int-dados-bi.consumo-atual
            SPACE(02)
            tt-int-dados-bi.estoque-seguranca
            SPACE(01)
            tt-int-dados-bi.estoque-minimo
            SPACE(01)
            tt-int-dados-bi.producao-atual
            SPACE(01)
            tt-int-dados-bi.producao-m1
            SPACE(01)
            tt-int-dados-bi.producao-m2
            SPACE(03)
            tt-int-dados-bi.estoque-transferir
            SPACE(01)
            tt-int-dados-bi.estoque-transito
            SPACE(10)
            tt-int-dados-bi.ressup-necessidade
            SPACE(06)
            tt-int-dados-bi.ressup-cubagem-carga
            SPACE(02)
            tt-int-dados-bi.ressup-mes
            SPACE(01)
            tt-int-dados-bi.ressup-m1
            SPACE(01)
            tt-int-dados-bi.ressup-m2
            SPACE(16)
            tt-int-dados-bi.frequencia-entrega
            SPACE(14)
            tt-int-dados-bi.entrega-quant-ressup-periodo
            SPACE(01)
            tt-int-dados-bi.entrega-saldo-enviar
            SPACE(14)
            tt-int-dados-bi.entrega-num-quant-restantes
            SPACE(19)
            tt-int-dados-bi.entrega-quant-prox-entrega
            SPACE(18)
            tt-int-dados-bi.entrega-percent-atendimento
            SPACE(11)
            tt-int-dados-bi.classif-abc
            SPACE(01)
            tt-int-dados-bi.cubagem-item
            SPACE(19)
            tt-int-dados-bi.log-estoq-minimo
            SKIP.
    
    END.
    PUT SKIP(03).

    //OUTPUT STREAM s-log CLOSE.
    
END PROCEDURE.



/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE pCalculaEmTransito:
    DEFINE VARIABLE de-estoq-transito-envio     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-docum-est-atualizado     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-docum-est-nao-atualizado AS DECIMAL     NO-UNDO.
    

    DEFINE VARIABLE idCliente       AS INTEGER  NO-UNDO.
    DEFINE VARIABLE idFornecedor    AS INTEGER  NO-UNDO.

    //Soma todas NFs Faturadas para o 
    ASSIGN  de-estoq-transito-envio     = 0
            de-docum-est-atualizado     = 0
            de-docum-est-nao-atualizado = 0.

    //Dados utilizados no recebimento, por isso que Ç fornecedor
    FOR FIRST estabelec fields(cod-emitente) NO-LOCK
        WHERE estabelec.cod-estabel = int-estabel-origem-ressup.cod-estabel-origem:
        FOR FIRST emitente FIELDS(cod-emitente) NO-LOCK
            WHERE emitente.cod-emitente = estabelec.cod-emitente:
            ASSIGN idFornecedor = emitente.cod-emitente.
        END.
    END.

    IF int-estabel-origem-ressup.cod-estabel-origem = '105' AND 
       int-item-estab-depos.cod-depos = 'EPE'               THEN DO:
       
        /*
       FOR EACH saldo-estoq USE-INDEX dep-item NO-LOCK
           WHERE saldo-estoq.cod-depos     = int-item-estab-depos.cod-depos
             AND saldo-estoq.it-codigo     = int-item-estab-depos.it-codigo
             AND saldo-estoq.cod-estabel   = int-estabel-origem-ressup.cod-estabel-origem
             AND saldo-estoq.qt-aloc-prod  > 0:
           ASSIGN de-estoq-transito = de-estoq-transito + saldo-estoq.qt-aloc-prod.
       END.*/

       FOR EACH int-it-nota-fisc-alocado NO-LOCK
           WHERE int-it-nota-fisc-alocado.cod-estabel = int-estabel-origem-ressup.cod-estabel-origem
             AND int-it-nota-fisc-alocado.serie     = '3'
             AND int-it-nota-fisc-alocado.it-codigo = int-item-estab-depos.it-codigo
             AND int-it-nota-fisc-alocado.cod-depos = int-item-estab-depos.cod-depos
             AND int-it-nota-fisc-alocado.log-recebida = NO:
             ASSIGN de-estoq-transito = de-estoq-transito + int-it-nota-fisc-alocado.qt-faturada[1].
        END. 
        ASSIGN tt-int-dados-bi.saldo-atual = tt-int-dados-bi.saldo-atual - de-estoq-transito
               de-saldo-atual              = de-saldo-atual              - de-estoq-transito.
    END.
    ELSE DO:
        
       FOR EACH nota-fiscal fields(cod-estabel serie nr-nota-fis cod-emitente) NO-LOCK
           WHERE nota-fiscal.cod-estabel  = int-estabel-origem-ressup.cod-estabel-origem
             //AND nota-fiscal.nr-nota-fis  = "1970056"
             AND nota-fiscal.nome-ab-cli  = int-estabel-ressuprimento.nome-abrev
             AND nota-fiscal.dt-cancela   = ?
             AND nota-fiscal.dt-emis-nota >= 05/01/2021
             AND nota-fiscal.dt-emis-nota <= TODAY
             AND nota-fiscal.esp-docto <> 20:
            
           //Envio
           FOR EACH it-nota-fisc fields(qt-faturada[1]) OF nota-fiscal NO-LOCK
               WHERE it-nota-fisc.it-codigo = int-item-estab-depos.it-codigo:
               
               ASSIGN  de-estoq-transito-envio = de-estoq-transito-envio + it-nota-fisc.qt-faturada[1]
                       de-carga-restante       = de-carga-restante + 1.
       
           END.
           ASSIGN l-achou = NO.
           //Recebido transito
           FOR EACH docum-est fields(serie-docto nro-docto cod-emitente nat-operacao) NO-LOCK
               WHERE docum-est.cod-estabel     = int-item-estab-depos.cod-estabel //110
                 AND docum-est.serie           = nota-fiscal.serie
                 AND docum-est.nro-docto       = nota-fiscal.nr-nota-fis
                 AND docum-est.cod-emitente    = idFornecedor
                 AND docum-est.ce-atu          = YES:

               FOR EACH item-doc-est fields(quantidade) OF docum-est NO-LOCK
                   WHERE item-doc-est.it-codigo = int-item-estab-depos.it-codigo:
                   
                 ASSIGN  l-achou = YES.
       
                   ASSIGN de-docum-est-atualizado = de-docum-est-atualizado + item-doc-est.quantidade.
                   
               END.
           END.

           IF l-achou = NO THEN DO:

               FOR FIRST nota-fisc-adc FIELDS(cod-estab cod-serie cod-nota-fisc
                                              cdn-emitente) NO-LOCK 
                   WHERE nota-fisc-adc.cod-docto-referado = nota-fiscal.nr-nota-fis
                     AND nota-fisc-adc.cod-ser-docto-referado = nota-fiscal.serie
                     AND nota-fisc-adc.cdn-emit-docto-referado = nota-fiscal.cod-emitente
                     AND nota-fisc-adc.idi-tip-dado = 3
                     AND nota-fisc-adc.cod-estab = nota-fiscal.cod-estabel.               
                   
                   FOR FIRST docum-est fields(serie-docto nro-docto cod-emitente nat-operacao) NO-LOCK
                       WHERE docum-est.cod-estabel  = nota-fisc-adc.cod-estab
                         AND docum-est.serie        = nota-fisc-adc.cod-serie
                         AND docum-est.nro-docto    = nota-fisc-adc.cod-nota-fisc
                         AND docum-est.cod-emitente = nota-fisc-adc.cdn-emitente 
                         AND docum-est.ce-atu.
                                                     
                        FOR EACH item-doc-est fields(quantidade) OF docum-est NO-LOCK
                            WHERE item-doc-est.it-codigo = int-item-estab-depos.it-codigo:
                            
                            ASSIGN de-docum-est-atualizado = de-docum-est-atualizado + item-doc-est.quantidade.
                        END.
                   END.
               END.
           END.
       END.

       ASSIGN  de-estoq-transito = de-estoq-transito-envio - de-docum-est-atualizado.

       //recebido no mes
       ASSIGN de-docum-est-atualizado = 0.

       FOR EACH nota-fiscal fields(cod-estabel serie nr-nota-fis) NO-LOCK
            WHERE nota-fiscal.cod-estabel  = int-estabel-origem-ressup.cod-estabel-origem
              //AND nota-fiscal.nr-nota-fis  = "1414624"
              AND nota-fiscal.nome-ab-cli  = int-estabel-ressuprimento.nome-abrev
              AND nota-fiscal.dt-cancela   = ?
              AND nota-fiscal.dt-emis-nota >= da-iniperM0
              AND nota-fiscal.dt-emis-nota <= da-fimperM0:

           FOR EACH docum-est fields(serie-docto nro-docto cod-emitente nat-operacao) NO-LOCK
               WHERE docum-est.cod-estabel     = int-item-estab-depos.cod-estabel //110
                 AND docum-est.serie           = nota-fiscal.serie
                 AND docum-est.nro-docto       = nota-fiscal.nr-nota-fis
                 AND docum-est.cod-emitente    = idFornecedor
                 AND docum-est.dt-trans        >= da-iniperM0  /* correá∆o da data Gustavo 20/07/2021 */
                 AND docum-est.dt-trans        <= da-fimperM0 
                 AND docum-est.ce-atu          = YES:

               FOR EACH item-doc-est FIELDS(quantidade) OF docum-est NO-LOCK
                   WHERE item-doc-est.it-codigo = int-item-estab-depos.it-codigo:

                   ASSIGN de-docum-est-atualizado = de-docum-est-atualizado + item-doc-est.quantidade.

               END.
           END.
       END.
         
       ASSIGN  de-quant-ressup-periodo = de-docum-est-atualizado.
    END.

END PROCEDURE.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE piDadosPlanejamento:
    DEFINE INPUT  PARAMETER pDataIni        AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER pDataFim        AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstabel     AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo       AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdePlanejada  AS DECIMAL      NO-UNDO.
    
    EMPTY TEMP-TABLE tt-item-plan.

    RUN piCarragaItemPlan (INPUT pItCodigo).

    IF NOT CAN-FIND(FIRST tt-item-plan) THEN DO:
       CREATE tt-item-plan.
       ASSIGN tt-item-plan.it-codigo = pItCodigo.
    END.

    FOR EACH tt-item-plan:
        FOR EACH periodo fields(ano nr-periodo) NO-LOCK
            WHERE periodo.dt-inicio  >= pDataIni
              AND periodo.dt-termino <= pDataFim:
           
            FOR EACH  pl-prod fields(num-calc-plano) NO-LOCK 
                WHERE pl-prod.pl-estado = 1:

                FOR  EACH it-periodo fields(qt-ord-plan) NO-LOCK
                    WHERE it-periodo.cod-estabel    = pCodEstabel
                      AND it-periodo.it-codigo      = tt-item-plan.it-codigo
                      AND it-periodo.ano            = periodo.ano
                      AND it-periodo.periodo        = periodo.nr-periodo
                      AND it-periodo.num-calc-plano = pl-prod.num-calc-plano: 
               
                    //Considerado apenas os planos que est∆o dentro do periodo e que j† foram geradas as OPs.
                    IF  it-periodo.qt-ord-plan > 0 THEN DO:
                        ASSIGN  pQtdePlanejada = pQtdePlanejada + it-periodo.qt-ord-plan.
                    END.
                END.
            END.
        END.
    END.

    FOR  EACH ord-prod FIELDS(qt-produzida qt-ordem) NO-LOCK
        WHERE ord-prod.it-codigo    = pItCodigo
          AND ord-prod.cod-estabel  = pCodEstabel
          AND ord-prod.dt-inicio   >= pDataIni
          AND ord-prod.dt-inicio   <= pDataFim
          AND ord-prod.estado       < 7:

        ASSIGN  pQtdePlanejada = pQtdePlanejada + (ord-prod.qt-ordem - ord-prod.qt-produzida).
    END.

END PROCEDURE.
PROCEDURE piCalculaConsumoAtualReservas:

    DEFINE VARIABLE cUF         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-periodo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE vlConsumo  AS DECIMAL     NO-UNDO.

    
    FOR EACH ponto-programa NO-LOCK 
        where ponto-programa.nome-programa = 'escep088'
          AND ponto-programa.ponto = 1,
        EACH conteudo-programa OF ponto-programa NO-LOCK:
        ASSIGN cUF = cUF + "," + conteudo-programa.conteudo.
    END.
    ASSIGN cUF = SUBSTRING(cUF,2).

    FOR EACH nota-fiscal FIELDS(cod-estabel serie nr-nota-fis emite-duplic idi-sit-nf-eletro
                                nome-ab-cli dt-emis-nota nr-pedcli)NO-LOCK 
        WHERE nota-fiscal.dt-emis-nota >= da-iniperM0
          AND nota-fiscal.dt-emis-nota <= da-fimperM0
          AND (   nota-fiscal.cod-estabel  = int-estabel-origem-ressup.cod-estabel-origem
               OR nota-fiscal.cod-estabel  = int-estabel-origem-ressup.cod-estabel-ressup)
          AND nota-fiscal.serie >= '' 
          AND nota-fiscal.serie <= 'ZZZZZ'
          AND nota-fiscal.nr-nota-fis >= ''
          AND nota-fiscal.nr-nota-fis <= 'ZZZZZZZ'
          AND nota-fiscal.dt-cancela   = ?,
        FIRST it-nota-fisc fields() OF nota-fiscal NO-LOCK
        WHERE it-nota-fisc.cod-unid-neg = 'ENS':  //Energia Solar

        IF nota-fiscal.emite-duplic <> YES THEN NEXT.

        IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT. // Autorizadas 
        
        RUN pi-acompanhar IN h-acomp (INPUT 'Calc.Consumo SOLAR: ' + nota-fiscal.nr-nota-fis).

        FOR FIRST emitente fields(estado) NO-LOCK
            WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli:

            IF INDEX(cUF, emitente.estado) > 0 THEN DO:
               
               ASSIGN c-periodo = STRING(MONTH(nota-fiscal.dt-emis-nota),'99') + STRING(YEAR(nota-fiscal.dt-emis-nota),'9999').
               
               FOR FIRST ped-venda fields(nome-abrev nr-pedcli) NO-LOCK
                   WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                     AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli.
                                    
                   FOR FIRST ord-prod fields(nr-ord-produ) NO-LOCK
                       WHERE ord-prod.nr-pedido  = ped-venda.nr-pedcli
                         AND ord-prod.nome-abrev = ped-venda.nome-abrev.
                              
                       FOR EACH reservas fields(it-codigo quant-requis) NO-LOCK
                          WHERE reservas.nr-ord-prod = ord-prod.nr-ord-prod:

                           FIND FIRST tt-item-consumo-nf
                                WHERE tt-item-consumo-nf.cod-estabel = nota-fiscal.cod-estabel 
                                  AND tt-item-consumo-nf.serie       = nota-fiscal.serie       
                                  AND tt-item-consumo-nf.nr-nota-fis = nota-fiscal.nr-nota-fis 
                                  AND tt-item-consumo-nf.it-codigo   = reservas.it-codigo
                           NO-ERROR.
                          
                           IF AVAIL tt-item-consumo-nf THEN NEXT.
                          
                           CREATE tt-item-consumo-nf.
                           ASSIGN tt-item-consumo-nf.cod-estabel = nota-fiscal.cod-estabel 
                                  tt-item-consumo-nf.serie       = nota-fiscal.serie 
                                  tt-item-consumo-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                                  tt-item-consumo-nf.it-codigo   = reservas.it-codigo.
                           
                          
                           FIND FIRST tt-item-consumo  
                                WHERE tt-item-consumo.cod-estabel = int-estabel-origem-ressup.cod-estabel-ressup
                                  AND tt-item-consumo.it-codigo   = reservas.it-codigo 
                                  AND tt-item-consumo.periodo     = c-periodo NO-ERROR.
                       
                           IF NOT AVAIL tt-item-consumo THEN DO:
                              CREATE tt-item-consumo.
                              ASSIGN tt-item-consumo.cod-estabel = int-estabel-origem-ressup.cod-estabel-ressup
                                     tt-item-consumo.it-codigo   = reservas.it-codigo
                                     tt-item-consumo.periodo     = c-periodo.
                           END.
                           ASSIGN tt-item-consumo.consumo-atual = tt-item-consumo.consumo-atual + reservas.quant-requis.
                       END.
                   END.
               END.
            END.
        END.
    END.
    
    

END PROCEDURE.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE piCalculaConsumoAtual:

    DEFINE VARIABLE cUF AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE vlConsumo   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE vlDevolucao AS DECIMAL     NO-UNDO.

    ASSIGN de-consumo-atual = 0.
    FOR EACH ponto-programa NO-LOCK 
        where ponto-programa.nome-programa = 'escep088'
          AND ponto-programa.ponto = 1,
        EACH conteudo-programa OF ponto-programa NO-LOCK:
        ASSIGN cUF = cUF + "," + conteudo-programa.conteudo.
    END.
    ASSIGN cUF = SUBSTRING(cUF,2).

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "escep088",                       
                   INPUT 3,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).
        
    FOR  EACH it-nota-fisc fields(cod-estabel serie nr-nota-fis 
                                  it-codigo nome-ab-cli nr-pedcli qt-faturada[1]) NO-LOCK  USE-INDEX ch-item-nota
         WHERE   (   it-nota-fisc.cod-estabel  = int-estabel-origem-ressup.cod-estabel-origem
                 OR  it-nota-fisc.cod-estabel  = int-estabel-origem-ressup.cod-estabel-ressup)
           AND it-nota-fisc.it-codigo    = int-item-estab-depos.it-codigo
           AND it-nota-fisc.dt-cancela   = ?
           AND it-nota-fisc.emite-duplic = YES
           AND it-nota-fisc.dt-emis-nota >= da-iniperM0
           AND it-nota-fisc.dt-emis-nota <= da-fimperM0.
         
        FOR FIRST emitente fields(estado) NO-LOCK
            WHERE emitente.nome-abrev = it-nota-fisc.nome-ab-cli:

            IF INDEX(cUF, emitente.estado) > 0
            THEN DO:

                FOR FIRST ped-venda fields(tp-pedido) NO-LOCK
                    WHERE ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli
                      AND ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli.
                
                    FOR FIRST atendente fields(cod-gr-canais) NO-LOCK
                        WHERE atendente.cd-oper = int(ped-venda.tp-pedido).                    
                
                        IF CAN-FIND(FIRST tt-prog-ponto
                                    WHERE tt-prog-ponto.conteudo = string(atendente.cod-gr-canais)) THEN DO:
                
                            ASSIGN vlConsumo = vlConsumo + it-nota-fisc.qt-faturada[1].    

                            /*EXPORT STREAM s-log DELIMITER ";"
                                it-nota-fisc.cod-estabel
                                it-nota-fisc.serie
                                it-nota-fisc.nr-nota-fis
                                it-nota-fisc.it-codigo
                                it-nota-fisc.qt-faturada[1]
                                atendente.cod-gr-canais.*/
                        END.
                        ELSE DO:
                            /*EXPORT STREAM s-log DELIMITER ";"
                                it-nota-fisc.cod-estabel
                                it-nota-fisc.serie
                                it-nota-fisc.nr-nota-fis
                                it-nota-fisc.it-codigo
                                it-nota-fisc.qt-faturada[1]
                                atendente.cod-gr-canais.*/
                        END.
                    END.                    
                    IF NOT AVAIL atendente THEN DO:
                        /*EXPORT STREAM s-log DELIMITER ";"
                                it-nota-fisc.cod-estabel
                                it-nota-fisc.serie
                                it-nota-fisc.nr-nota-fis
                                it-nota-fisc.it-codigo
                                it-nota-fisc.qt-faturada[1]
                                "sem atendente".*/
                    END.
                END.            
                IF NOT AVAIL ped-venda THEN DO:
                    /*EXPORT STREAM s-log DELIMITER ";"
                                it-nota-fisc.cod-estabel
                                it-nota-fisc.serie
                                it-nota-fisc.nr-nota-fis
                                it-nota-fisc.it-codigo
                                it-nota-fisc.qt-faturada[1]
                                "sem pedido".*/
                END.
            END.
            ELSE DO:
                /*EXPORT STREAM s-log DELIMITER ";"
                                it-nota-fisc.cod-estabel
                                it-nota-fisc.serie
                                it-nota-fisc.nr-nota-fis
                                it-nota-fisc.it-codigo
                                it-nota-fisc.qt-faturada[1]
                                "sem estado".*/
            END.
        END.
    END.

    FOR EACH  devol-cli FIELDS(cod-estabel serie nr-nota-fis 
                              cod-emitente qt-devolvida nr-sequencia) USE-INDEX ch-item NO-LOCK
        where devol-cli.dt-devol     >= da-iniperM0
          AND devol-cli.dt-devol     <= da-fimperM0
          AND (devol-cli.cod-estabel  = int-estabel-origem-ressup.cod-estabel-origem OR 
               devol-cli.cod-estabel  = int-estabel-origem-ressup.cod-estabel-ressup)
          AND devol-cli.it-codigo     = int-item-estab-depos.it-codigo,
        FIRST nota-fiscal fields() NO-LOCK
        WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
          AND nota-fiscal.serie         = devol-cli.serie
          AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
          AND nota-fiscal.emite-duplic,
        FIRST it-nota-fisc fields(cod-estabel serie nr-nota-fis
                                  it-codigo nome-ab-cli nr-pedcli 
                                  qt-faturada[1]) NO-LOCK
        WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
          AND it-nota-fisc.serie       = devol-cli.serie
          AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
          AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
        FIRST ped-venda fields(tp-pedido) NO-LOCK
        WHERE ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli
          AND ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli,
        FIRST atendente fields(cod-gr-canais) NO-LOCK
        WHERE atendente.cd-oper = int(ped-venda.tp-pedido).                                    

        IF CAN-FIND(FIRST tt-prog-ponto
                    WHERE tt-prog-ponto.conteudo = string(atendente.cod-gr-canais)) THEN DO:                  

            FOR FIRST emitente fields(estado)no-lock 
                WHERE emitente.cod-emitente = devol-cli.cod-emitente :
                IF INDEX(cUF, emitente.estado) > 0
                THEN DO:
                    ASSIGN vlDevolucao = vlDevolucao + devol-cli.qt-devolvida.
                    /*EXPORT STREAM s-log DELIMITER ";"
                                   it-nota-fisc.cod-estabel
                                   it-nota-fisc.serie
                                   it-nota-fisc.nr-nota-fis
                                   it-nota-fisc.it-codigo
                                   it-nota-fisc.qt-faturada[1]
                                   "devol".*/
                END.
            END.
        END.
    END.
    
    ASSIGN de-consumo-atual = IF TODAY < 07/01/2021  THEN 0  ELSE  vlConsumo - vlDevolucao.  /*gustavo 20/07 */
    

END PROCEDURE.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE piCalculaCubagemItem:
    DEFINE VARIABLE de-peso-bruto       AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE de-peso-liquido     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE h-esftp083          AS HANDLE       NO-UNDO.
    DEFINE VARIABLE p-erros             AS CHARACTER    NO-UNDO.

    ASSIGN de-cubagem-item = 0.
    FOR FIRST item-caixa NO-LOCK
        WHERE item-caixa.it-codigo = int-item-estab-depos.it-codigo:

        FOR FIRST embalag NO-LOCK
             WHERE embalag.sigla-emb = item-caixa.sigla-emb:
    
            ASSIGN de-cubagem-item = ((embalag.altura * embalag.comprim * embalag.largura) / 1000000000) / item-caixa.qt-item.
        END.
            
    END.

END PROCEDURE.

/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE piCalculaOEM:
    DEFINE INPUT  PARAMETER pDataIni        AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER pDataFim        AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstabel     AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pItCodigo       AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pQuantidade     AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE logItemOEM  AS LOGICAL     NO-UNDO.

    ASSIGN  pQuantidade = 0.

    //logica copiada do metodo pi-monta-browse do progama escep002.w
    FOR EACH prazo-compra fields(numero-ordem parcela)NO-LOCK
       WHERE prazo-compra.it-codigo   = pItCodigo
         AND prazo-compra.situacao    = 2
         AND prazo-compra.quant-saldo > 0
         AND prazo-compra.data-entrega >= pDataIni
         AND prazo-compra.data-entrega <= pDataFim,
        EACH ordem-compra no-lock
       WHERE (ordem-compra.cod-estabel  = pCodEstabel)
         AND ordem-compra.numero-ordem = prazo-compra.numero-ordem:

        FOR EACH ordens-embarque fields(quantidade) NO-LOCK
           WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
             AND ordens-embarque.parcela       = prazo-compra.parcela:

            ASSIGN  pQuantidade = pQuantidade + ordens-embarque.quantidade.

        END.
    END.

END PROCEDURE.



PROCEDURE piCarragaItemPlan:
    DEF INPUT PARAM pItem AS CHAR NO-UNDO.

    FOR EACH it-altern FIELDS(it-altern) NO-LOCK 
        WHERE it-altern.it-codigo = pItem:

        CREATE tt-item-plan.
        ASSIGN tt-item-plan.it-codigo = it-altern.it-altern.

        RUN piCarragaItemPlan (INPUT it-altern.it-altern).
    END.                                                    

END PROCEDURE.
/*
PROCEDURE pi-fim-periodo:

    DEF INPUT  PARAM pi-data   AS DATE NO-UNDO.        
    DEF OUTPUT PARAM po-data AS DATE NO-UNDO.

    DEFINE VARIABLE i-mes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ano AS INTEGER     NO-UNDO.

    ASSIGN i-mes = month(pi-data) + 1.

    IF i-mes > 12 THEN
        ASSIGN i-ano = YEAR(pi-data) + 1
               i-mes = 1. 
    ELSE
        ASSIGN i-ano = YEAR(pi-data).

    ASSIGN po-data = DATE(i-mes,20,i-ano).

END PROCEDURE.
*/
/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG):

    
    
/*------------------------------------------------------------------------------
  Purpose:  Retornar o saldo dispo°vel para alocaá∆o do item
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qtd            AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE qtd-alocada    AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE c-localizacao  AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE p-qtd-total    LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-disp     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-bloq     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE qtd-atualizada LIKE int-wms-nf-atualiz.qt-baixada NO-UNDO.

    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-depos AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-usuar AS CHARACTER   NO-UNDO.   
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    DEFINE BUFFER bf-saldo-estoq-fnEstoque FOR saldo-estoq.
    
    ASSIGN c-localizacao = "".
    
    /*Localizaá‰es que devem ser desconsideradas*/
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006":U
          AND ponto-programa.ponto         = 2,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos:
        IF  c-localizacao = "" THEN
            ASSIGN c-localizacao = ENTRY(2,conteudo-programa.conteudo).
        ELSE
            ASSIGN c-localizacao = c-localizacao + "," + ENTRY(2,conteudo-programa.conteudo).
    END.
    
    FIND FIRST item-uni-estab USE-INDEX codigo NO-LOCK 
         WHERE item-uni-estab.it-codigo   = p-it-codigo
           AND item-uni-estab.cod-estabel = p-cod-estabel
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.
    
    IF  AVAIL item-uni-estab
    AND NOT p-saldo-central THEN DO:
        RUN esapi/esapi011.p (INPUT  p-cod-estabel,
                              INPUT  p-it-codigo,
                              INPUT  p-cod-depos,
                              INPUT  p-cod-localiz,
                              OUTPUT qtd).
    END.
    ELSE DO:
                 
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "ESCEP088":U, 
                           INPUT 4, 
                           INPUT 0, 
                           INPUT "":U, 
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto
            WHERE tt-prog-ponto.sequencia = 1:
            ASSIGN c-estab = tt-prog-ponto.conteudo.
        END.
        
        FOR FIRST tt-prog-ponto
            WHERE tt-prog-ponto.sequencia = 2:
            ASSIGN c-depos = tt-prog-ponto.conteudo.
        END.
        
        FOR FIRST tt-prog-ponto
            WHERE tt-prog-ponto.sequencia = 3:
            ASSIGN c-usuar = tt-prog-ponto.conteudo.
        END.

        ASSIGN de-reservas-ast = 0.

        IF (index(c-estab,p-cod-estabel) > 0 AND
            index(c-depos,p-cod-depos) > 0) THEN DO:
        
            DO i-cont = 1 TO NUM-ENTRIES(c-usuar,";"):
            
                FOR FIRST reservas-ast NO-LOCK
                    WHERE reservas-ast.it-codigo    = p-it-codigo
                      AND reservas-ast.cod-estabel  = p-cod-estabel
                      AND reservas-ast.cod-depos    = p-cod-depos
                      AND reservas-ast.cd-usuario   = entry(i-cont,c-usuar,";")
                      AND reservas-ast.data-limite >= TODAY
                      AND reservas-ast.dt-reserva  <= TODAY.
                
                    ASSIGN de-reservas-ast = de-reservas-ast + reservas-ast.qt-reserva.
                END.
            END.
        END.
        
          
            

        FOR EACH bf-saldo-estoq-fnEstoque NO-LOCK
            WHERE bf-saldo-estoq-fnEstoque.cod-depos   = p-cod-depos
              AND bf-saldo-estoq-fnEstoque.it-codigo   = p-it-codigo
              AND bf-saldo-estoq-fnEstoque.cod-estabel = p-cod-estabel
              AND bf-saldo-estoq-fnEstoque.cod-localiz = p-cod-localiz
              AND bf-saldo-estoq-fnEstoque.lote        = p-lote:

            /* Desconsidera as localizaá‰es cadastradas no ES0018 */
            IF  (bf-saldo-estoq-fnEstoque.cod-localiz <> "" OR c-localizacao <> "") 
            AND (LOOKUP(bf-saldo-estoq-fnEstoque.cod-localiz, c-localizacao) > 0) THEN
                NEXT.

            IF  p-cod-localiz <> "*"
            AND bf-saldo-estoq-fnEstoque.cod-localiz <> p-cod-localiz THEN
                NEXT.
            
            FIND FIRST int-saldo-estoq NO-LOCK
                {dbini\es322.i1 int-saldo-estoq bf-saldo-estoq-fnEstoque} NO-ERROR.

            IF  AVAIL int-saldo-estoq 
            AND int-saldo-estoq.log-bloqueado THEN NEXT.

            ASSIGN qtd         = qtd + bf-saldo-estoq-fnEstoque.qtidade-atu  - bf-saldo-estoq-fnEstoque.qt-alocada  /*- bf-saldo-estoq-fnEstoque.qt-aloc-ped*/
                   qtd-alocada = qtd-alocada + bf-saldo-estoq-fnEstoque.qt-alocada + bf-saldo-estoq-fnEstoque.qt-aloc-ped.

            IF bf-saldo-estoq-fnEstoque.cod-depos = 'WFT' THEN
               ASSIGN qtd = qtd - bf-saldo-estoq-fnEstoque.qt-aloc-prod.

            ASSIGN qtd = qtd - de-reservas-ast.
        END.

        /* Validacao MFT x WMS  */
        FIND FIRST deposito 
             WHERE deposito.cod-depos    = p-cod-depos
               AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.


        IF  AVAIL deposito
        AND NOT AVAIL item-uni-estab THEN DO: /*Central configurada nunca tem saldo no wms, ent∆o considera sempre o saldo cont†bil*/
            EMPTY TEMP-TABLE tt-erro.

            RUN esp/wmp/eswmpapi003.p (INPUT  p-cod-estabel,
                                       INPUT  p-cod-depos,
                                       INPUT  p-it-codigo,
                                       INPUT  "",
                                       OUTPUT p-qtd-total,
                                       OUTPUT p-qtd-disp,
                                       OUTPUT p-qtd-bloq,
                                       OUTPUT TABLE tt-erro).

            FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                DELETE tt-erro.
            END. /* FOR EACH tt-erro */

            /* Verifica quantidade atualizada no estoque e que ainda estah pendente de integracao com o WMS */
            ASSIGN qtd-atualizada = 0.
            FOR EACH int-wms-nf-atualiz NO-LOCK
               WHERE int-wms-nf-atualiz.cod-depos   = p-cod-depos
                 AND int-wms-nf-atualiz.it-codigo   = p-it-codigo
                 AND int-wms-nf-atualiz.cod-estabel = p-cod-estabel:
                ASSIGN qtd-atualizada = qtd-atualizada + int-wms-nf-atualiz.qt-baixada.
            END.
           

            /*Considera o menor entre dispon°vel estoque ou dispon°vel WMS*/
            ASSIGN qtd = qtd + qtd-atualizada.
  
          
        END. /* IF AVAIL deposito THEN DO: */
    END.

    IF qtd < 0 THEN
        ASSIGN qtd = 0.

    RETURN qtd.


END FUNCTION.
/************************************************************//***********************************************************/


FUNCTION fnDispfat RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG):

    
    
/*------------------------------------------------------------------------------
  Purpose:  Retornar o saldo dispo°vel para alocaá∆o do item
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qtd            AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE qtd-alocada    AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE c-localizacao  AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE p-qtd-total    LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-disp     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-bloq     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE qtd-atualiz LIKE int-wms-nf-atualiz.qt-baixada NO-UNDO.

    DEFINE BUFFER bf-saldo-estoq-fnDispFat FOR saldo-estoq.
    
    ASSIGN c-localizacao = "".
    
    /*Localizaá‰es que devem ser desconsideradas*/
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006":U
          AND ponto-programa.ponto         = 2,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos:
        IF  c-localizacao = "" THEN
            ASSIGN c-localizacao = ENTRY(2,conteudo-programa.conteudo).
        ELSE
            ASSIGN c-localizacao = c-localizacao + "," + ENTRY(2,conteudo-programa.conteudo).
    END.
    
    FIND FIRST item-uni-estab USE-INDEX codigo NO-LOCK 
         WHERE item-uni-estab.it-codigo   = p-it-codigo
           AND item-uni-estab.cod-estabel = p-cod-estabel
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.
    
    IF  AVAIL item-uni-estab
    AND NOT p-saldo-central THEN DO:
        RUN esapi/esapi011.p (INPUT  p-cod-estabel,
                              INPUT  p-it-codigo,
                              INPUT  p-cod-depos,
                              INPUT  p-cod-localiz,
                              OUTPUT qtd).
    END.
    ELSE DO:
        
        FOR EACH bf-saldo-estoq-fnDispfat NO-LOCK
            WHERE bf-saldo-estoq-fnDispfat.cod-depos   = p-cod-depos
              AND bf-saldo-estoq-fnDispfat.it-codigo   = p-it-codigo
              AND bf-saldo-estoq-fnDispfat.cod-estabel = p-cod-estabel
              AND bf-saldo-estoq-fnDispfat.cod-localiz = p-cod-localiz
              AND bf-saldo-estoq-fnDispfat.lote        = p-lote:

            /* Desconsidera as localizaá‰es cadastradas no ES0018 */
            IF  (bf-saldo-estoq-fnDispfat.cod-localiz <> "" OR c-localizacao <> "") 
            AND (LOOKUP(bf-saldo-estoq-fnDispfat.cod-localiz, c-localizacao) > 0) THEN
                NEXT.

            IF  p-cod-localiz <> "*"
            AND bf-saldo-estoq-fnDispfat.cod-localiz <> p-cod-localiz THEN
                NEXT.
            
            FIND FIRST int-saldo-estoq NO-LOCK
                {dbini\es322.i1 int-saldo-estoq bf-saldo-estoq-fnDispfat} NO-ERROR.

            IF  AVAIL int-saldo-estoq 
            AND int-saldo-estoq.log-bloqueado THEN NEXT.

            ASSIGN qtd         = qtd + bf-saldo-estoq-fnDispfat.qtidade-atu  - bf-saldo-estoq-fnDispfat.qt-alocada  - bf-saldo-estoq-fnDispfat.qt-aloc-ped
                   qtd-alocada = qtd-alocada + bf-saldo-estoq-fnDispfat.qt-alocada + bf-saldo-estoq-fnDispfat.qt-aloc-ped.
        END.
    

        /* Validacao MFT x WMS  */
        FIND FIRST deposito 
             WHERE deposito.cod-depos    = p-cod-depos
               AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.


        IF  AVAIL deposito
        AND NOT AVAIL item-uni-estab THEN DO: /*Central configurada nunca tem saldo no wms, ent∆o considera sempre o saldo cont†bil*/
            EMPTY TEMP-TABLE tt-erro.

            RUN esp/wmp/eswmpapi003.p (INPUT  p-cod-estabel,
                                       INPUT  p-cod-depos,
                                       INPUT  p-it-codigo,
                                       INPUT  "",
                                       OUTPUT p-qtd-total,
                                       OUTPUT p-qtd-disp,
                                       OUTPUT p-qtd-bloq,
                                       OUTPUT TABLE tt-erro).

            FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                DELETE tt-erro.
            END. /* FOR EACH tt-erro */

            /* Verifica quantidade atualizada no estoque e que ainda estah pendente de integracao com o WMS */
            ASSIGN qtd-atualiz = 0.
            FOR EACH int-wms-nf-atualiz NO-LOCK
               WHERE int-wms-nf-atualiz.cod-depos   = p-cod-depos
                 AND int-wms-nf-atualiz.it-codigo   = p-it-codigo
                 AND int-wms-nf-atualiz.cod-estabel = p-cod-estabel:

                ASSIGN qtd-atualiz = qtd-atualiz + int-wms-nf-atualiz.qt-baixada.
            END.
           

            /*Considera o menor entre dispon°vel estoque ou dispon°vel WMS*/
            ASSIGN qtd = IF p-qtd-disp - qtd-alocada - qtd-atualiz < qtd THEN p-qtd-disp - qtd-alocada - qtd-atualiz ELSE qtd.
  
        END. /* IF AVAIL deposito THEN DO: */
    END.

    IF qtd < 0 THEN
        ASSIGN qtd = 0.

    RETURN qtd.


END FUNCTION.







