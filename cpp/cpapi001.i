/****************************************************************************
**
**   Include: CPAPI001.I  - Defini‡Æo das Temp-Tables do Reporte
**
*****************************************************************************/

def temp-table tt-rep-prod NO-UNDO
    field tipo              as integer init 1
    field nr-reporte        like rep-prod.nr-reporte
    field nr-ord-produ      like ord-prod.nr-ord-produ
    field data              like rep-prod.data
    field qt-reporte        like rep-prod.qt-reporte
    field qt-refugo         like rep-prod.qt-refugo
    field qt-apr-cond       like rep-prod.qt-apr-cond    
    field it-codigo         like rep-prod.it-codigo
    field un                like ord-prod.un    
    field nro-docto         like rep-prod.nro-docto
    field serie-docto       like rep-prod.serie-docto
    field cod-depos         like rep-prod.cod-depos
    field cod-localiz       like rep-prod.cod-localiz

    /*** Deposito para material reciclavel 2.02 ***/
    &IF DEFINED (bf_man_sfc_lc) &THEN  
    field dep-refugo         like rep-prod.cod-depos
    field loc-refugo         like rep-prod.cod-localiz
    &ENDIF
    
    &IF DEFINED (bf_man_per_ppm) &THEN
    field per-ppm           like item.per-ppm
    &ENDIF
    
    field lote-serie        like rep-prod.lote-serie
    field cod-refer         like rep-prod.cod-refer
    field dt-vali-lote      like rep-prod.dt-vali-lote
	
	field ct-codigo			as character /* Bruno todo like rep-prod.ct-codigo */
	field sc-codigo			as character /* Bruno todo like rep-prod.sc-codigo */	
	field cod-cta-unif		as character /* Bruno todo like rep-prod.ct-codigo */
	field cod-ccusto-unif	as character /* Bruno todo like rep-prod.sc-codigo */	
	field ct-refugo			as character /* Bruno todo like rep-prod.ct-codigo */
	field sc-refugo			as character /* Bruno todo like rep-prod.sc-codigo */	
	
    field cod-depos-sai     like rep-prod.cod-depos-sai
    field cod-local-sai     like rep-prod.cod-local-sai
    field op-codigo         like oper-ord.op-codigo
    field cod-roteiro       like oper-ord.cod-roteiro
    field it-oper           like oper-ord.it-codigo
    field pto-controle      like oper-ord.pto-controle
    field sequencia         like oper-ord.sequencia  
    field baixa-reservas    as integer init 1
    field time-out          as integer init 30
    field tentativas        as integer init 10
    field procura-saldos    as logical init yes
    field carrega-reservas  as logical init yes
    field requis-automatica as logical
    field prog-seg          as char
    field finaliza-ordem    as logical
    field finaliza-oper     as logical
    field reserva           as logical init yes
    field nro-ord-seq       as integer
    field linha             as integer
    field cod-versao-integracao as integer format "999"
   &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    field cod-emitente      like movto-estoq.cod-emitente
    field nat-operacao      like movto-estoq.nat-operacao
   &endif
    index codigo  is primary unique nr-ord-produ nro-ord-seq
    index reserva reserva.

/* Temp-table com os codigos de rejeicao e as respectivas quantidades
   rejeitadas. */

def temp-table tt-refugo NO-UNDO
    field nr-ord-produ like ord-prod.nr-ord-produ
    field codigo-rejei like cod-rejeicao.codigo-rejei
    field qt-refugo    like ord-prod.qt-refugada
    field observacao   like ref-ordem.observacao
    field nro-ord-seq  as integer init 0
    index ordem-rejei  nr-ord-produ codigo-rejei.

/* Temp-table para retorno ao estoque das reservas negativas e/ou positivas */

def temp-table tt-res-neg NO-UNDO
    field nr-ord-produ like ord-prod.nr-ord-produ
    field it-codigo    like reservas.it-codigo
    field quantidade   like reservas.quant-orig
    field cod-depos    like reservas.cod-depos
    field cod-localiz  like item.cod-localiz
    field lote-serie   like ord-prod.lote-serie
    field cod-refer    like ord-prod.cod-refer
    field dt-vali-lote like saldo-estoq.dt-vali-lote
    field positivo     as logical format "Sim/Nao"
    field nro-ord-seq  as integer init 0
    index codigo is primary nr-ord-produ it-codigo cod-depos
    index indicador positivo.
    
def temp-table tt-apont-mob NO-UNDO
    field nr-ord-prod    like ord-prod.nr-ord-prod
    field tipo-movto     as int format "99"
    field op-codigo      like movto-ggf.op-codigo
    field cod-roteiro    like movto-ggf.cod-roteiro
    field it-codigo      like operacao.it-codigo
    field cd-mob-dir     like operacao.cd-mob-dir
    field gm-codigo      like operacao.gm-codigo
    field tipo-relogio   as int
    field hora-ini       as int format "9999"
    field min-ini        as int format "99"
    field hora-fim       as int format "9999"
    field min-fim        as int format "99"
    field centesimal-ini as dec format ">>>>>>>9,9999"
    field centesimal-fim as dec format ">>>>>>>9,9999"   
    field tempo          like movto-ggf.horas-report 
    field minutos-report as int format "99"
    field referencia     like movto-ggf.referencia
    field matr-func      like movto-ggf.matr-func
    field nro-ord-seq    as integer
    index relogio tipo-relogio
    index ordem is primary nr-ord-prod tipo-movto.      
           
def var c-referencia as char no-undo.    
