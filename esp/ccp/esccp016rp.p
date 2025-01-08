&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCCP016RP 1.00.00.002}

/* ***************************  Definitions  ************************** */

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-saldos                     as char format "x(15)" no-undo.
def var c-relatorio                  as char format "x(15)" no-undo.

DEFINE VARIABLE de-qtd-pol AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-unidade AS CHARACTER   NO-UNDO.
{esp/ccp/esccp016tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel AT 2        no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-comprado-ini format "X(12)" label "Comprador" colon 40
    " |<  >| " at 60
    tt-param.cod-comprado-fim format "X(12)" no-label skip
    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40
    " |<  >| " at 60
    tt-param.it-codigo-fim format "x(16)" no-label skip
    tt-param.data-ini format "99/99/9999" label "Data" colon 40
    " |<  >| " at 60
    tt-param.data-fim format "99/99/9999" no-label skip
/*     tt-param.data-politica-ini format "99/99/9999" label "Data Pol¡tica" colon 40 */
/*     " |<  >| " at 60                                                               */
/*     tt-param.data-politica-fim format "99/99/9999" no-label skip                  */
    tt-param.periodo-ini format ">>9" label "Per¡odo" colon 40
    " |<  >| " at 60
    tt-param.periodo-fim format ">>9" no-label skip
    tt-param.cod-obsoleto-ini format "9" label "Obsoleto" colon 40
    " |<  >| " at 60
    tt-param.cod-obsoleto-fim format "9" no-label 
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par AT 2        no-label
    skip(1)
    /*form-parametro-usuario*/
    tt-param.cd-plano format ">>9" label "Plano" colon 40 skip
    tt-param.ano format "9999" label "Ano" colon 40 skip
    tt-param.ge-codigo format "99" label "Grupo Estoque" colon 40 skip
    c-saldos colon 40 label "Saldos" skip
    c-relatorio colon 40 label "Relat¢rio de Saldos" skip
    tt-param.l-dependente format "Sim/NÆo" colon 40 label "Dependente" skip
    tt-param.l-independente format "Sim/NÆo" colon 40 label "Independente" skip
    tt-param.l-des-sal-ent-zr format "Sim/NÆo" colon 40 label "Desconsiderar Saldo e Entregas Zeradas" skip
    tt-param.l-dep-saldo-disp format "Sim/NÆo" colon 40 label "Somente Dep¢sito Saldo Dispon¡vel" skip
    tt-param.cod-estabel label "Estabelecimento" colon 40 
    skip(1)
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp AT 2        no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/

assign c-liter-par = "PAR¶METROS:"
       c-liter-sel = "SELE€ÇO:"
       c-liter-imp = "IMPRESSÇO:".

assign c-destino:label in frame f-impressao = "Destino".
assign tt-param.usuario:label in frame f-impressao = "Usuario".   

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

assign c-sistema = "Especificos Intelbras".
assign c-titulo-relat = "Relatorio de Saldos por Comprador".

assign c-empresa     = param-global.grupo
       c-programa    = "ESCCP016RP":U
       c-versao      = "1.00":U
       c-revisao     = "001"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-saldos      = entry(tt-param.ind-saldos, "Todos,Zerados")
       c-relatorio   = entry(tt-param.ind-relatorio, "Comprador,Proje‡Æo").

{esp/imp/esimp000.i1} /*tt-emb*/

def temp-table tt-erro no-undo
    field embarque like mgcex.embarque-imp.embarque    
    field desc-erro as char.

{include/tt-edit.i}
{include/pi-edit.i}
{include/i-rpcab.i}

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run pi-relat.
    
    if can-find(first tt-erro) then do:
        page.
        put "Rela‡Æo de Erros Encontrados" at 50 skip(1)
            "Embarque      Erro" skip
            fill("-", 90) format "x(90)" skip.
        
        for each tt-erro:
            put tt-erro.embarque at 1
                tt-erro.desc-erro format "x(75)" at 15.
        end.         
            
    end.
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp c-liter-sel
         tt-param.cod-comprado-ini 
         tt-param.cod-comprado-fim 
         tt-param.it-codigo-ini 
         tt-param.it-codigo-fim 
         tt-param.data-ini 
         tt-param.data-fim 
/*          tt-param.data-politica-ini */
/*          tt-param.data-politica-fim */
         tt-param.periodo-ini 
         tt-param.periodo-fim 
         tt-param.cod-obsoleto-ini 
         tt-param.cod-obsoleto-fim 
         c-liter-par         
         tt-param.cd-plano
         tt-param.ano
         tt-param.ge-codigo
         c-saldos
         c-relatorio
         tt-param.l-dependente
         tt-param.l-independente
         tt-param.l-des-sal-ent-zr
         tt-param.l-dep-saldo-disp
         tt-param.cod-estabel 
         c-liter-imp
         c-destino
         tt-param.arquivo   
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


PROCEDURE busca-posicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each mgcex.embarque-imp no-lock
       where mgcex.embarque-imp.situacao = 1
         AND mgcex.embarque-imp.cod-estabel = ordens-embarque.cod-estabel
         and mgcex.embarque-imp.embarque = ordens-embarque.embarque:
       
        {esp/imp/esimp000.i}   
    end.   

END PROCEDURE.

PROCEDURE pi-relat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-val-unit LIKE item-estab.val-unit-mat-m[1] no-undo.
    def var de-val-mat  LIKE item-estab.val-unit-mat-m[1] no-undo. 
    def var de-val-ggf  LIKE item-estab.val-unit-mat-m[1] no-undo.
    def var de-val-mob  LIKE item-estab.val-unit-mat-m[1] no-undo.
    def var de-val-rec as dec  format ">>,>>>,>>9.99" NO-UNDO.
    def var de-val-alm as dec  format ">>,>>>,>>9.99" NO-UNDO.
    def var de-val-pro as dec  format ">>,>>>,>>9.99" NO-UNDO.
    def var de-val-reca as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-alma as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-proa as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-recb as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-almb as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-prob as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-recc as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-almc as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-val-proc as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-saldo-rec as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-saldo-alm as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-saldo-pro as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-saldo-oc  as dec  format ">>,>>>,>>9.99" no-undo.
    DEF VAR c-tipo       AS CHAR FORMAT "x(10)"         NO-UNDO.
    def var de-politica  as dec  format ">>,>>>,>>9.99" no-undo.
    def var de-disp      as dec  format "->>,>>>,>>9.99" no-undo.
    def var de-pl             as dec  format "->>,>>>,>>9.99" no-undo.
    def var de-pl-pol        as dec  format "->>,>>>,>>9.99" no-undo.
    def var i-cont as int no-undo.
    def var i-num-calc-plano like it-periodo.num-calc-plano no-undo.
    
    find pl-prod no-lock where pl-prod.cd-plano = tt-param.cd-plano no-error.
    if avail pl-prod then assign i-num-calc-plano = pl-prod.num-calc-plano.
    else assign i-num-calc-plano = 0.
    
    for each item-uni-estab no-lock
       where item-uni-estab.cod-estabel   = tt-param.cod-estabel
         AND item-uni-estab.cod-comprado >= tt-param.cod-comprado-ini
         AND item-uni-estab.cod-comprado <= tt-param.cod-comprado-fim
         and item-uni-estab.it-codigo >= tt-param.it-codigo-ini
         and item-uni-estab.it-codigo <= tt-param.it-codigo-fim,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = item-uni-estab.it-codigo
         and ITEM.ge-codigo = tt-param.ge-codigo
         and ITEM.cod-obsoleto >= tt-param.cod-obsoleto-ini
         and ITEM.cod-obsoleto <= tt-param.cod-obsoleto-fim
          by item.classif-abc 
          by item.it-codigo:

        IF tt-param.l-dependente AND NOT tt-param.l-independente AND item.demanda = 2 THEN NEXT.
        IF tt-param.l-dependente AND NOT tt-param.l-independente AND item.demanda = 1 AND item.tipo-contr = 4 THEN NEXT.
        IF NOT tt-param.l-dependente AND tt-param.l-independente AND item.demanda = 1 THEN NEXT.

        run pi-acompanhar in h-acomp (input "Item: " + ITEM.it-codigo).

        assign de-val-unit = 0
               de-val-mat  = 0
               de-val-mob  = 0
               de-val-ggf  = 0
               c-tipo      = "":U.

        find item-estab no-lock
            where item-estab.cod-estabel = tt-param.cod-estabel 
              and item-estab.it-codigo = item.it-codigo no-error.

        if avail item-estab then 
           assign de-val-unit = item-estab.val-unit-mat-m[1]
                              + item-estab.val-unit-mob-m[1]
                              + item-estab.val-unit-ggf-m[1]
                  de-val-mat = item-estab.val-unit-mat-m[1]
                  de-val-mob = item-estab.val-unit-mob-m[1]
                  de-val-ggf = item-estab.val-unit-ggf-m[1].
        else assign de-val-unit = 0.                      
         /*  fim  */

        ASSIGN de-qtd-pol = 0.
        FIND FIRST int-item-uni-estab NO-LOCK
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.
        IF AVAIL int-item-uni-estab THEN
           ASSIGN de-qtd-pol = int-item-uni-estab.qtd-pol.

        assign de-saldo-rec = 0
               de-saldo-alm = 0
               de-saldo-pro = 0.

        for each saldo-estoq no-lock
           where saldo-estoq.it-codigo = item.it-codigo 
             and saldo-estoq.cod-estabel = tt-param.cod-estabel
             and saldo-estoq.qtidade-atu > 0:

            IF tt-param.l-dep-saldo-disp THEN DO:
                FIND FIRST deposito
                    WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK NO-ERROR.
                    
                IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
            END.

            if saldo-estoq.cod-depos = "rec" then
                assign de-saldo-rec = de-saldo-rec + saldo-estoq.qtidade-atu.
            else assign de-saldo-alm = de-saldo-alm + saldo-estoq.qtidade-atu.
        end.

        if tt-param.ind-saldos = 2 and de-saldo-alm > 0 then next.

        find pl-it-calc
             where pl-it-calc.it-codigo = item.it-codigo 
               and pl-it-calc.cd-plano  = tt-param.cd-plano no-lock no-error.
        if avail pl-it-calc then assign de-disp = pl-it-calc.saldo.
        else assign de-disp = 0.

        assign de-disp = 0
               de-pl   = 0
               de-pl-pol = 0.

        for each reservas no-lock use-index planejamento
           where reservas.it-codigo = item.it-codigo
             and reservas.estado = 1:
              if  reservas.dt-reserva >= tt-param.data-ini
              and reservas.dt-reserva <= tt-param.data-fim THEN DO:
                  assign de-pl = de-pl + reservas.quant-orig - reservas.quant-atend.
              END.

/*                  if  reservas.dt-reserva >= tt-param.data-politica-ini                          */
/*                  and reservas.dt-reserva <= tt-param.data-politica-fim then                     */
/*                      assign de-pl-pol = de-pl-pol + reservas.quant-orig - reservas.quant-atend. */
        end.

        do i-cont = tt-param.periodo-ini to tt-param.periodo-fim:
            for each it-periodo no-lock where
                it-periodo.num-calc-plano = i-num-calc-plano and 
                it-periodo.it-codigo = item.it-codigo and
                it-periodo.ano       = tt-param.ano and
                it-periodo.cod-estabel = tt-param.cod-estabel and
                it-periodo.periodo   = i-cont:

                FIND first periodo 
                    where periodo.nr-periodo = it-periodo.periodo
                    and   periodo.ano        = it-periodo.ano
                    and   periodo.cd-tipo    = pl-prod.cd-tipo NO-LOCK NO-ERROR.
/*                     IF periodo.dt-inicio >= tt-param.data-politica-ini AND     */
/*                        periodo.dt-inicio <= tt-param.data-politica-fim THEN    */
/*                         ASSIGN de-pl-pol = de-pl-pol + it-periodo.qt-res-plan. */

                assign de-pl = de-pl + it-periodo.qt-res-plan
                       de-disp = de-disp + it-periodo.qt-ord-comp - it-periodo.qt-res-comp. 
            end.
        end.

        assign de-saldo-oc = 0.
        for each prazo-compra no-lock where
            prazo-compra.data-entrega >= tt-param.data-ini and
            prazo-compra.data-entrega <= tt-param.data-fim and
            prazo-compra.situacao = 2 and
            prazo-compra.it-codigo = item.it-codigo and
            prazo-compra.quant-saldo <> 0,
            first ordem-compra no-lock where
                  ordem-compra.numero-ordem = prazo-compra.numero-ordem and
                  ordem-compra.cod-estabel  = tt-param.cod-estabel      AND
                  ordem-compra.num-pedido <> 0:

            for each tt-emb:
                delete tt-emb.
            end.
            for each ordens-embarque no-lock
               where ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                 and ordens-embarque.parcela       = prazo-compra.parcela 
                 and ordens-embarque.cod-estabel   = tt-param.cod-estabel:
                run busca-posicao. 

            end.

                find first tt-emb no-error.
                if avail tt-emb and tt-emb.situacao = 4 then next.

            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN DO:
                IF emitente.natureza = 3 THEN DO:
                    IF c-tipo = "Nacional":U THEN
                        ASSIGN c-tipo = "Ambos":U.
                    IF c-tipo = "":U THEN
                        ASSIGN c-tipo = "Importado":U.
                END.
                ELSE DO:
                    IF c-tipo = "Importado":U THEN
                        ASSIGN c-tipo = "Ambos":U.
                    IF c-tipo = "":U THEN
                        ASSIGN c-tipo = "Nacional":U.
                END.
            END.
            
            assign de-saldo-oc = de-saldo-oc + prazo-compra.quant-saldo. 
        end.

        assign de-val-alm = de-val-alm + (de-saldo-alm * de-val-unit) 
               de-val-rec = de-val-rec + (de-saldo-rec * de-val-unit)
               de-val-pro = de-val-pro + (de-saldo-pro *
                                          de-val-unit).                   

        if item.classif-abc = 1 then 
            assign de-val-alma = de-val-alma + (de-saldo-alm * de-val-unit)
                   de-val-reca = de-val-reca + (de-saldo-rec * de-val-unit)
                   de-val-proa = de-val-proa + (de-saldo-pro * de-val-unit).

        if item.classif-abc = 2 then 
             assign de-val-almb = de-val-almb + (de-saldo-alm * de-val-unit)
                    de-val-recb = de-val-recb + (de-saldo-rec * de-val-unit)
                    de-val-prob = de-val-prob + (de-saldo-pro * de-val-unit).
        if item.classif-abc = 3 then 
             assign de-val-almc = de-val-almc + (de-saldo-alm * de-val-unit)
                    de-val-recc = de-val-recc + (de-saldo-rec * de-val-unit)
                    de-val-proc = de-val-proc + (de-saldo-pro * de-val-unit).
        
/*             ASSIGN de-pl-pol = ITEM.quant-segur + ((ITEM.periodo-fixo / 28) * de-pl-pol). */

/*            if tt-param.ind-relatorio = 2 then do: /****** Projecao ******/*/

        ASSIGN c-unidade = "".
        IF ITEM.fm-cod-com <> "" THEN DO:
            FIND FIRST fam-com-item NO-LOCK
                 WHERE fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,2) NO-ERROR.
            IF AVAIL fam-com-item THEN
                ASSIGN c-unidade = fam-com-item.descricao.
        END.

/*         run pi-print-editor (item.desc-item, 36). */
/*         FIND FIRST tt-editor NO-LOCK NO-ERROR.    */

        IF tt-param.l-des-sal-ent-zr AND
           (de-saldo-rec + de-saldo-alm + de-saldo-pro) = 0 AND
           de-saldo-oc = 0 THEN NEXT.
        
        disp item.it-codigo  format "x(7)" label "Item"
             item.desc-item format "x(60)" label "Descri‡Æo"
             item-uni-estab.cod-comprado label "Comprador"
             c-unidade LABEL "Unid.Neg."
             item.fm-cod-com FORMAT "x(08)":U LABEL "Fam Coml"
             de-saldo-rec + de-saldo-alm + de-saldo-pro format ">>,>>>,>>9.99"  label "Saldo Total"
             de-val-unit label "Pre‡o Unit."
             (de-saldo-alm + de-saldo-rec + de-saldo-pro) * de-val-unit format ">,>>>,>>9.99" label "Valor Total"
             de-pl label "PL"
             de-saldo-oc label "Entregas"
             c-tipo LABEL "Tipo"
             de-qtd-pol label "Est.Pol." format "->>>,>>>,>>9.99"
             (de-saldo-alm + de-saldo-rec + de-saldo-pro + de-saldo-oc) - de-pl label "Proje‡Æo" format "->>>>>,>>9.99"
             (de-saldo-alm + de-saldo-rec + de-saldo-pro + de-saldo-oc - de-pl) - de-qtd-pol label "Excesso" format "->>>,>>>,>>9.99"
             ((de-saldo-alm + de-saldo-rec + de-saldo-pro + de-saldo-oc - de-pl) - de-qtd-pol)  * de-val-unit label "Val Excesso" format "->>>,>>>,>>9.99"
             with no-labels width 280 frame a 10 down stream-io.          
    end.

    if tt-param.ind-relatorio = 1 then 
       disp "Valor Total" space(38)
            de-val-alm
            de-val-rec
            de-val-pro skip
            "Valor     A" space(38)
            de-val-alma
            de-val-reca
            de-val-proa skip
            "Valor     B" space(38)
            de-val-almb
            de-val-recb
            de-val-prob skip
            "Valor     C" space(38)
            de-val-almc
            de-val-recc
            de-val-proc 
            with no-labels width 132 stream-io.

END PROCEDURE.
