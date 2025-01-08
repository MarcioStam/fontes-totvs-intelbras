/********************************************************************************
  Programa baseado no CEP/CE0505RP.P (l¢gica) e ESP/CEP/ESCEP055.W (tela)
*******************************************************************************/
{include/i-prgvrs.i ESCEP068RP 2.00.00.000}  /*** 010000 ***/
{include/i_fnctrad.i}
/******************************************************************************/
{utp\ut-glob.i}
{esp/cep/escep068.i}
{upc/btb910za-upc.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
DEFINE VARIABLE c-finalidade AS CHARACTER   NO-UNDO.
def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

DEFINE TEMP-TABLE tt-estab
    FIELD cod-estabel AS CHAR
    FIELD nome AS CHAR.


def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def buffer b-consumo  for consumo-estab.

DEF TEMP-TABLE tt-periodo NO-UNDO
    FIELD periodo        AS CHAR FORMAT "9999/99"
    index codigo periodo.

DEF TEMP-TABLE tt-item-estab NO-UNDO
    FIELD cod-estabel LIKE consumo-estab.cod-estabel
    FIELD it-codigo   LIKE consumo-estab.it-codigo
    FIELD tot-consumo AS DECIMAL
    INDEX codigo it-codigo
                 cod-estabel.

def temp-table tt-consumo no-undo
    field cod-estabel    like consumo-estab.cod-estabel
    field it-codigo      like consumo-estab.it-codigo
    FIELD periodo        AS CHAR
    field consumo        as decimal format "-ZZZZZZZ,ZZ9.99"
    index codigo cod-estabel
                 it-codigo
                 periodo.

{include/i-rpvar.i}

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

DEFINE STREAM st-excel.

/* foi incluido variaveis acima pertencentes a cdapi005.i antes executada */

/*def var c-periodo      as char    format "9999/99" extent 12 no-undo.*/
def var c-mes-ext      as char    format "x(3)"    extent 12 no-undo.
def var c-descricao    as char    format "x(50)"   no-undo.
def var c-traco        as char    format "x(132)" no-undo.
def var l-impresso     as logical init "yes" no-undo.
def var l-var          as logical extent 13 no-undo.
def var de-variavel    as decimal format "-ZZZZZZZ,ZZ9.99" extent 12 no-undo.
def var de-var-val     as decimal format "->>>>>>>,>>9.99" extent 12 no-undo.
def var de-preco       as decimal format "-ZZZZZZZ,ZZ9.99" no-undo.
def var de-consumo     as decimal format "-ZZZZZZZ,ZZ9.99" no-undo.
def var i-per-tot      as integer format 99   init 0 no-undo.
def var i-cont         as integer format 99   init 0 no-undo.
def var i-num          as integer no-undo.
def var l-primeiro     as l       no-undo.
def var h-acomp        as handle  no-undo.
def var c-acompanha    as char no-undo.
def var c-lb-periodo   as char no-undo.
def var c-lb-ge        as char no-undo.
DEFINE VARIABLE c-lb-situacao AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-ano-per-ini   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mes-per-ini   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-per-fim   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mes-per-fim   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-per-aux   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mes-per-aux   AS INTEGER     NO-UNDO.

DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-abc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qt-politica AS DECIMAL     FORMAT "->>>,>>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE d-qtd-consumo-item AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-nr-periodos AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-arq-excel AS CHARACTER   NO-UNDO.



def var c-tabela as char extent 12 no-undo.
{utp/ut-liter.i Jan * r}
assign c-tabela[1] = trim(return-value).
{utp/ut-liter.i Fev * r}
assign c-tabela[2] = trim(return-value).
{utp/ut-liter.i Mar * r}
assign c-tabela[3] = trim(return-value).
{utp/ut-liter.i Abr * r}
assign c-tabela[4] = trim(return-value).
{utp/ut-liter.i Mai * r}
assign c-tabela[5] = trim(return-value).
{utp/ut-liter.i Jun * r}
assign c-tabela[6] = trim(return-value).
{utp/ut-liter.i Jul * r}
assign c-tabela[7] = trim(return-value).
{utp/ut-liter.i Ago * r}
assign c-tabela[8] = trim(return-value).
{utp/ut-liter.i Set * r}
assign c-tabela[9] = trim(return-value).
{utp/ut-liter.i Out * r}
assign c-tabela[10] = trim(return-value).
{utp/ut-liter.i Nov * r}
assign c-tabela[11] = trim(return-value).
{utp/ut-liter.i Dez * r}
assign c-tabela[12] = trim(return-value).

/* Define Variaveis para traducao */
def var c-bl-periodo as char no-undo.
def var c-lb-item    as char no-undo.
def var c-lb-comprador   as char no-undo.
def var c-lb-consumo as char no-undo.
def var c-lb-conta   as char no-undo.
def var c-lb-descr   as char no-undo.
def var c-lb-param   as char no-undo.
def var c-lb-param1  as char no-undo.
def var c-lb-param2  as char no-undo.
def var c-lb-param3  as char no-undo.
def var c-lb-param4  as char no-undo.
def var c-lb-param5  as char no-undo.
def var c-lb-preco as char no-undo.
def var c-lb-custo as char no-undo.
def var c-lb-selec   as char no-undo.
def var c-lb-impr    as char no-undo.
def var c-lb-destino as char no-undo.
def var c-lb-usuario as char no-undo.
def var c-lb-est1    as char format "x(16)" no-undo.
DEF VAR c-lb-digita  AS CHAR FORMAT "x(10)" NO-UNDO.

{utp/ut-liter.i Estabelecimento}
assign c-lb-est1 = trim(return-value).
{utp/ut-liter.i Per¡odo * r}
assign c-bl-periodo = trim(return-value).
{utp/ut-liter.i Per¡odo * r}
assign c-lb-periodo = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-lb-item = trim(return-value).
{utp/ut-liter.i Comprador * r}
assign c-lb-comprador = trim(return-value).
{utp/ut-liter.i Consumo_M‚dio * r}
assign c-lb-consumo = trim(return-value).
{utp/ut-liter.i Conta_Cont bil * r}
assign c-lb-conta = trim(return-value).
{utp/ut-liter.i Descri‡Æo * r}
assign c-lb-descr = trim(return-value).
{utp/ut-liter.i Tipo_de_Pre‡o * r}
assign c-lb-preco = trim(return-value).
{utp/ut-liter.i Tipo_de_Custo * r}
assign c-lb-custo = trim(return-value).
{utp/ut-liter.i PAR¶METROS * r}
assign c-lb-param = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
assign c-lb-selec = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-impr = trim(return-value).
{utp/ut-liter.i Situa‡Æo * r}
assign c-lb-param1 = trim(return-value).
{utp/ut-liter.i Apenas_Itens_com_Saldo * r}
assign c-lb-param2 = trim(return-value).
{utp/ut-liter.i Apenas_Itens_com_Consumo * r}
assign c-lb-param3 = trim(return-value).
{utp/ut-liter.i Somente_Dep¢sito_Saldo_Dispon¡vel * r}
assign c-lb-param4 = trim(return-value).
{utp/ut-liter.i Data_Ultimo_Per¡odo * r}
assign c-lb-param5 = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-destino = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuario = trim(return-value).

def var c-lb-estabel as char format "X(03)".
{utp/ut-liter.i Est * r}
assign c-lb-estabel = trim(return-value).
{utp/ut-liter.i DIGITA€ÇO * r}
ASSIGN c-lb-digita = TRIM(RETURN-VALUE).



run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Preparando_Informa‡äes_Relat¢rio}
run pi-inicializar in h-acomp (input return-value).
{utp/ut-field.i mgind item ge-codigo 2}
assign c-lb-ge = return-value.

create tt-param.
raw-transfer raw-param to tt-param.

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.

assign c-empresa  = param-global.grupo
       c-programa = "CE/0505"
       c-versao   = "1.00"
       c-revisao  = "000"
       c-traco    = fill ("-",132).

{utp/ut-liter.i Consumo_por_Item * r}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i ESTOQUE * r}
assign c-sistema = trim(return-value).


/*assign i-per-corrente = integer(substring(c-pe-fim,5,2)) + 1
       i-ano-corrente = integer(substring(c-pe-fim,1,4)).

if i-per-corrente > 12 
then  assign i-per-corrente = i-per-corrente - 12
             i-ano-corrente = i-ano-corrente + 1.

/*foi incluido logica acima que pertencia a cdapi005.i1 */

assign i-per-work = i-per-corrente
       i-ano-work = i-ano-corrente.

if  i-per-work > 12 then
    assign i-per-work = i-per-work - 12.
do  i-cont = 12 to 1 by -1:
    assign i-per-work = i-per-work - 1.

    if  i-per-work = 0 then
        assign i-per-work = 12
               i-ano-work = i-ano-work - 1.

    assign i-ano-aux[i-cont] = i-ano-work
           i-mes-aux[i-cont] = i-per-work
           c-periodo[i-cont] = string(i-ano-work,"9999")
                             + string(i-per-work,"99")
           c-mes-ext[i-cont] = c-tabela[i-per-work].
end.
*/

{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

EMPTY TEMP-TABLE tt-estab.

FOR EACH estabelec FIELDS(cod-estabel nome) NO-LOCK
   WHERE estabelec.cod-estabel >= tt-param.estab-ini
     AND estabelec.cod-estabel <= tt-param.estab-fim:

    CREATE tt-estab.
    ASSIGN tt-estab.cod-estabel = estabelec.cod-estabel
           tt-estab.nome        = estabelec.nome.
END.


EMPTY TEMP-TABLE tt-periodo.

ASSIGN i-ano-per-ini = INT(SUBSTRING(tt-param.periodo-ini,1,4))
       i-ano-per-fim = INT(SUBSTRING(tt-param.periodo-fim,1,4))
       i-nr-periodos = 0.

DO i-ano-per-aux = i-ano-per-ini TO i-ano-per-fim:

    IF i-ano-per-aux = i-ano-per-ini THEN
        ASSIGN i-mes-per-ini = INT(SUBSTRING(tt-param.periodo-ini,5,2)).
    ELSE 
        ASSIGN i-mes-per-ini = 1.
        
    IF i-ano-per-aux = i-ano-per-fim THEN 
        ASSIGN i-mes-per-fim = INT(SUBSTRING(tt-param.periodo-fim,5,2)).
    ELSE
        ASSIGN i-mes-per-fim = 12.

    
    DO i-mes-per-aux = i-mes-per-ini TO i-mes-per-fim:

        CREATE tt-periodo.
        ASSIGN tt-periodo.periodo = STRING(i-ano-per-aux, "9999") + STRING(i-mes-per-aux, "99").

        ASSIGN i-nr-periodos = i-nr-periodos + 1.

    END.

END.


EMPTY TEMP-TABLE tt-consumo.
EMPTY TEMP-TABLE tt-item-estab.

FOR EACH tt-estab:

    for each consumo-estab fields(periodo it-codigo conta-contabil cod-estabel cod-estabel-prin qt-saida qt-entrada ct-codigo) USE-INDEX estab-item
        WHERE consumo-estab.cod-estabel-prin    =  tt-estab.cod-estabel 
        AND   consumo-estab.it-codigo           >= tt-param.item-ini
        AND   consumo-estab.it-codigo           <= tt-param.item-fim     
        AND   consumo-estab.periodo             >= tt-param.periodo-ini
        AND   consumo-estab.periodo             <= tt-param.periodo-fim no-lock:

        for first item 
            WHERE item.it-codigo = consumo-estab.it-codigo no-lock: 
        end.

        FOR FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.cod-estabel = consumo-estab.cod-estabel
            AND   item-uni-estab.it-codigo   = consumo-estab.it-codigo:

        END.

        IF AVAIL item-uni-estab 
        THEN DO:
            IF item-uni-estab.cod-comprado < tt-param.comprador-ini OR
               item-uni-estab.cod-comprado > tt-param.comprador-fim THEN
                NEXT.
        END.
        ELSE DO:
            IF ITEM.cod-comprado < tt-param.comprador-ini OR
               ITEM.cod-comprado > tt-param.comprador-fim THEN
                NEXT.
        END.

        IF tt-param.i-obsoleto <> 5 AND
           tt-param.i-obsoleto <> item-uni-estab.cod-obsoleto THEN
            NEXT.

        /*if item.ge-codigo > tt-param.i-ge-f or
           item.ge-codigo < tt-param.i-ge-i or
           item.fm-codigo > tt-param.c-fam-f or
           item.fm-codigo < tt-param.c-fam-i
            then next.  

        &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */
            for first item-uni-estab where
                item-uni-estab.it-codigo = consumo-estab.it-codigo and
                item-uni-estab.cod-estabel = consumo-estab.cod-estabel-prin
                no-lock: end.

            if avail item-uni-estab then
                if ((item-uni-estab.classif-abc  = 1 and not tt-param.l-classe-a) or
                    (item-uni-estab.classif-abc  = 2 and not tt-param.l-classe-b) or
                    (item-uni-estab.classif-abc  = 3 and not tt-param.l-classe-c)) then next.
                else.
            else
                if ((item.classif-abc  = 1 and not tt-param.l-classe-a) or
                    (item.classif-abc  = 2 and not tt-param.l-classe-b) or
                    (item.classif-abc  = 3 and not tt-param.l-classe-c)) then next.
                else .
        &else
            for first item-mat-estab where
                item-mat-estab.it-codigo = consumo-estab.it-codigo and
                item-mat-estab.cod-estabel = consumo-estab.cod-estabel-prin
                no-lock: end.
            if avail item-mat-estab then
                if ((item-mat-estab.classif-abc  = 1 and not tt-param.l-classe-a) or
                    (item-mat-estab.classif-abc  = 2 and not tt-param.l-classe-b) or
                    (item-mat-estab.classif-abc  = 3 and not tt-param.l-classe-c)) then next.
                else.
            else
                if ((item.classif-abc  = 1 and not tt-param.l-classe-a) or
                    (item.classif-abc  = 2 and not tt-param.l-classe-b) or
                    (item.classif-abc  = 3 and not tt-param.l-classe-c)) then next.
                else .

        &endif*/

        assign i-empresa = param-global.empresa-prin.
        &if defined (bf_dis_consiste_conta) &then

            for first estabelec fields(cod-estabel ep-codigo) where
                 estabelec.cod-estabel = consumo-estab.cod-estabel-prin no-lock: end.
            assign i-empresa = estabelec.ep-codigo.

            run cdp/cd9970.p (input rowid(estabelec),
                              output i-empresa).
        &endif
        
        run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa, /* EMPRESA EMS2 */
                                                              input  "CEP",  /* C¢digo do M¢dulo */           
                                                              input  "",   /* Plano de Contas */    
                                                              INPUT  consumo-estab.ct-codigo, /* Conta */
                                                              input  TODAY, /* DATA TRANSACAO */   
                                                              output c-finalidade, /* Finalidade da Conta */
                                                              output table tt_log_erro). /* ERROS */ 

        /* Desconsiderar Mercadoria em Transito */
        if avail tt_log_erro or
          (c-finalidade <> "Consumo":U and
           c-finalidade <> "Ordem servi‡o":U and
           c-finalidade <> "Custo mercadoria vendida":U) then
            next.

        assign c-acompanha = c-lb-item + ": " + item.it-codigo
               c-acompanha = c-acompanha  + " " + c-lb-periodo + ": " + string(consumo-estab.periodo,"9999/99").
        
        run pi-acompanhar in h-acomp (input c-acompanha).

        FOR FIRST tt-item-estab
            WHERE tt-item-estab.cod-estabel = consumo-estab.cod-estabel
            AND   tt-item-estab.it-codigo   = consumo-estab.it-codigo:
        END.

        IF NOT AVAIL tt-item-estab THEN DO:

            CREATE tt-item-estab.
            ASSIGN tt-item-estab.cod-estabel = consumo-estab.cod-estabel
                   tt-item-estab.it-codigo   = consumo-estab.it-codigo
                   tt-item-estab.tot-consumo = 0.

        END.

        find first tt-consumo 
            WHERE tt-consumo.cod-estabel = consumo-estab.cod-estabel-prin 
            AND   tt-consumo.it-codigo   = consumo-estab.it-codigo          
            AND   tt-consumo.periodo     = consumo-estab.periodo use-index codigo no-error.

        if not avail tt-consumo then do:

            create tt-consumo.
            assign tt-consumo.cod-estabel    = consumo-estab.cod-estabel-prin 
                   tt-consumo.it-codigo      = consumo-estab.it-codigo
                   tt-consumo.periodo        = consumo-estab.periodo
                   tt-consumo.consumo        = 0.
        end.

        assign tt-consumo.consumo = tt-consumo.consumo + consumo-estab.qt-saida - consumo-estab.qt-entrada.

        ASSIGN tt-item-estab.tot-consumo = tt-item-estab.tot-consumo + consumo-estab.qt-saida - consumo-estab.qt-entrada.

    end.

END.


assign i-cont = 0.

{utp/ut-liter.i Gerando_Relat¢rio_Consumo_Item}

run pi-inicializar in h-acomp (input return-value).

//ASSIGN c-arq-excel = session:TEMP-DIR + "ESCEP068" + ".csv". 
IF OPSYS = 'unix' THEN
   ASSIGN c-arq-excel = c-dir-arquivo-session + c-seg-usuario + "/ESCEP068" + ".csv".
ELSE
   ASSIGN c-arq-excel = c-dir-arquivo-session + c-seg-usuario + "\ESCEP068" + ".csv".

OUTPUT STREAM st-excel TO VALUE(c-arq-excel) NO-CONVERT.


PUT STREAM st-excel UNFORMATTED
    "Estab;Item;Decri‡Æo;Situa‡Æo;Comprador;Pre‡o M‚dio;Consumo M‚dio;Saldo;ABC;Qtde Pol¡tica;Quantidade Segur;".

FOR EACH tt-periodo:
    PUT STREAM st-excel UNFORMATTED string(tt-periodo.periodo, "9999/99") ";".
END.

PUT STREAM st-excel SKIP.


FOR EACH tt-item-estab:

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-item-estab.it-codigo:
    END.

    FOR FIRST item-estab NO-LOCK
        WHERE item-estab.cod-estabel = tt-item-estab.cod-estabel 
        AND   item-estab.it-codigo   = tt-item-estab.it-codigo:
    END.

    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = tt-item-estab.cod-estabel
        AND   item-uni-estab.it-codigo   = tt-item-estab.it-codigo:
    END.

    FOR FIRST int-item-uni-estab NO-LOCK
        WHERE int-item-uni-estab.cod-estabel = tt-item-estab.cod-estabel
        AND   int-item-uni-estab.it-codigo   = tt-item-estab.it-codigo:
    END.

    /**/
        
    ASSIGN de-preco = 0.

    IF AVAIL item-estab THEN
        ASSIGN de-preco = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].


    ASSIGN de-saldo = 0.

    FOR EACH saldo-estoq
       WHERE saldo-estoq.cod-estabel = tt-item-estab.cod-estabel
         AND saldo-estoq.it-codigo   = tt-item-estab.it-codigo NO-LOCK:
    
        IF tt-param.l-dep-saldo-disp THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK NO-ERROR.
    
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
        END.
    
        ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
    END.

    IF tt-param.l-saldo AND de-saldo <= 0 THEN
        NEXT.


    ASSIGN d-qtd-consumo-item = 0.

    FOR EACH tt-consumo
        WHERE tt-consumo.cod-estabel = tt-item-estab.cod-estabel
        AND   tt-consumo.it-codigo   = tt-item-estab.it-codigo:

        ASSIGN d-qtd-consumo-item = d-qtd-consumo-item + tt-consumo.consumo.

    END.

    IF tt-param.l-consumo AND d-qtd-consumo-item <= 0 THEN
        NEXT.



    CASE item-uni-estab.classif-abc:
        WHEN 1 THEN
            ASSIGN c-abc = "A".
        WHEN 2 THEN
            ASSIGN c-abc = "B".
        WHEN 3 THEN
            ASSIGN c-abc = "C".
    END CASE.

    ASSIGN de-qt-politica = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0.

    /**/

    IF AVAIL item-uni-estab THEN
        find comprador 
            where comprador.cod-comprado = ITEM-uni-estab.cod-comprado no-lock no-error.
    ELSE
        find comprador 
            where comprador.cod-comprado = ITEM.cod-comprado no-lock no-error.

    PUT STREAM st-excel UNFORMATTED 
        tt-item-estab.cod-estabel                                                       ";"     /* Estabelecimento */ 
        tt-item-estab.it-codigo                                                         ";"     /* Item */
        ITEM.desc-item                                                                  ";"     /* Descri‡Æo do Item */
        {ininc/i17in172.i 04 ITEM.cod-obsoleto}                                         ";"     /* Situa‡Æo */
        IF AVAIL comprador THEN comprador.nome ELSE ""                                      ";"     /* Comprador */
        trim(string(de-preco, "->>>,>>>,>>9.9999"))                                     ";"     /* Pre‡o M‚dio */
        trim(string(tt-item-estab.tot-consumo / i-nr-periodos, "->>>,>>>,>>9.9999"))    ";"     /* Consumo M‚dio */
        trim(string(de-saldo, "->>>,>>>,>>9.9999"))                                     ";"     /* Saldo */
        c-abc                                                                           ";"     /* ABC */
        trim(string(de-qt-politica, "->>>,>>>,>>9.9999"))                               ";"     /* Qtde Politica */
        trim(string(item-uni-estab.quant-segur, "->>>,>>>,>>9.9999"))                   ";"     /*Quantidade Segur */
        .

    FOR EACH tt-periodo:

        for FIRST tt-consumo
            WHERE tt-consumo.cod-estabel = tt-item-estab.cod-estabel
            AND   tt-consumo.it-codigo   = tt-item-estab.it-codigo
            AND   tt-consumo.periodo     = tt-periodo.periodo:
        END.

        PUT STREAM st-excel UNFORMATTED
            IF AVAIL tt-consumo THEN trim(string(tt-consumo.consumo, "->>>,>>>,>>9.9999")) ELSE "0"
            ";".

    END.

    PUT STREAM st-excel SKIP.

END. /* tt-item-estab */

OUTPUT STREAM st-excel CLOSE.

/**/

PUT UNFORMATTED "Arquivo gerado: " c-arq-excel SKIP.

page.

put c-lb-selec               skip(1)

    c-lb-est1               at 5  format "x(15)" ".: " at 20
    tt-param.estab-ini      at 23  
    "|<  >|"                at 40
    tt-param.estab-fim      at 47

    c-lb-comprador          at 5  format "x(09)" ".......: " 
    tt-param.comprador-ini  at 23 format "X(12)"
    "|<  >|"                at 40
    tt-param.comprador-fim  at 47 format "x(12)"
                            
    c-lb-item               at 5  "........: "
    tt-param.item-ini       at 23 format "x(16)"
    "|<  >|"                at 40
    tt-param.item-fim       at 47 format "x(16)"

    c-bl-periodo            at 5  "........: "
    tt-param.periodo-ini    at 23
    "|<  >|"                at 40
    tt-param.periodo-fim    at 47 skip(1).


CASE tt-param.i-obsoleto:

    WHEN 1 THEN
        ASSIGN c-lb-situacao = "Ativo".

    WHEN 2 THEN
        ASSIGN c-lb-situacao = "Obsoleto Ordens Autom ticas".

    WHEN 3 THEN
        ASSIGN c-lb-situacao = "Obsoleto Todas as Ordens".

    WHEN 4 THEN
        ASSIGN c-lb-situacao = "Totalmente Obsoleto".

    WHEN 5 THEN
        ASSIGN c-lb-situacao = "Todas".

END CASE.

PUT c-lb-param                    format "x(10)"      skip(1)
    c-lb-param1             at 5  format "x(33)" ": " c-lb-situacao
    c-lb-param2             at 5  format "x(33)" ": " tt-param.l-saldo              FORMAT "Sim/NÆo"
    c-lb-param3             at 5  format "x(33)" ": " tt-param.l-consumo            FORMAT "Sim/NÆo"
    c-lb-param4             at 5  format "x(33)" ": " tt-param.l-dep-saldo-disp     FORMAT "Sim/NÆo"
    skip(1).


PUT c-lb-impr                format "x(9)"  skip(1)
    c-lb-destino       at 5  ": " trim(tt-param.c-destino) " - "
    tt-param.arquivo         format "x(30)"
    c-lb-usuario       at 5  ": " tt-param.usuario.


run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".
