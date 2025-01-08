/****************************************************************************
**
**  CPAPI002.I - Defini‡Æo temp-tables.
**
*****************************************************************************/

define temp-table tt-ord
        field nr-ord-produ   like ord-prod.nr-ord-produ
        field c-arquivo1     as char format "x(10)"
        field it-codigo      like ord-prod.it-codigo
        field qt-ordem       like ord-prod.qt-ordem
        field un             like ord-prod.un
        field tipo           like ord-prod.tipo
        field estado         like ord-prod.estado 
        field nr-linha       like ord-prod.nr-linha
        /*field dt-inicio      like ord-prod.dt-inicio*/
        /*field dt-termino     like ord-prod.dt-termino*/
        field mes-inicio     as int format "99"
        field dia-inicio     as int format "99"
        field ano-inicio     as int 
        field mes-termino    as int format "99"
        field dia-termino    as int format "99"
        field ano-termino    as int
        field mes-emissao    as int format "99"
        field dia-emissao    as int format "99"
        field ano-emissao    as int
        field cd-planejado   like ord-prod.cd-planejado
        field ct-codigo	     like ord-prod.ct-codigo
		field sc-codigo	     like ord-prod.sc-codigo
        field rep-prod       like ord-prod.rep-prod
        field cod-estabel    like ord-prod.cod-estabel
        field cod-depos      like ord-prod.cod-depos
        field nome-abrev     like ord-prod.nome-abrev
        field cod-gr-cli     like ord-prod.cod-gr-cli
        field nr-pedido      like ord-prod.nr-pedido
        field nr-sequencia   like ord-prod.nr-sequencia
        field cod-refer      like ord-prod.cod-refer
        field lote-serie     like ord-prod.lote-serie
        field emite-requis   like ord-prod.emite-requis
        field emite-ordem    like ord-prod.emite-ordem
        field prioridade     like ord-prod.prioridade
        field sit-aloc       like ord-prod.sit-aloc
        field narrativa      like ord-prod.narrativa
        field linha          as int format ">>>>9"
        &IF DEFINED (bf_man_sfc_ref_oper) &THEN
            FIELD log-control-estoq-refugo LIKE ord-prod.log-control-estoq-refugo
            FIELD log-refugo-preco-fisc    LIKE ord-prod.log-refugo-preco-fisc
            FIELD cod-item-refugo          LIKE ord-prod.cod-item-refugo
            FIELD val-relac-refugo-item    LIKE ord-prod.val-relac-refugo-item
        &ENDIF
        .       

define temp-table tt-res
        field nr-ord-produ like ord-prod.nr-ord-produ
        field c-arquivo1   as char format "x(10)"
        field it-codigo    like reservas.it-codigo
        field item-pai     like reservas.item-pai
        field cod-roteiro  like reservas.cod-roteiro
        field op-codigo    like reservas.op-codigo
        field quant-orig   like reservas.quant-orig
        field un           like reservas.un
        field tipo-sobra   like reservas.tipo-sobra
        field mes-reserva  as int format "99"
        field dia-reserva  as int format "99"
        field ano-reserva  as int
        field lote-serie   like reservas.lote-serie
        field localizacao  like reservas.cod-localiz
        field cod-depos    like reservas.cod-depos
        field estado       like reservas.estado
        field linha        as int format ">>>>9"
    &IF DEFINED(bf_man_per_ppm) &THEN
        field veiculo      like reservas.veiculo
        field per-ppm      like reservas.per-ppm
    &ENDIF
        FIELD cod-refer    LIKE reservas.cod-ref
        .

define temp-table tt-ope
        field nr-ord-produ   like ord-prod.nr-ord-produ
        field c-arquivo1     as char format "x(12)"
        field it-codigo      like oper-ord.it-codig
        field cod-roteiro    like oper-ord.cod-roteiro
        field op-codigo      like oper-ord.op-codigo
        field descricao-oper like oper-ord.descricao
        field tipo-oper      like oper-ord.tipo-oper
        field gm-codigo      like oper-ord.gm-codigo
        field revisao-oper   like oper-ord.revisao
        field fi-codigo      like oper-ord.fi-codigo
        field ferramenta     like oper-ord.ferramenta
        field pto-controle   like oper-ord.pto-controle
        field fator-sobrep   like oper-ord.fator-sobrep
        field proporcao      like oper-ord.proporcao
        field un-med-tempo   like oper-ord.un-med-tempo
        field nr-unidades    like oper-ord.nr-unidades
        field tempo-prepar   like oper-ord.tempo-prepar
        field tempo-homem    like oper-ord.tempo-homem
        field tempo-maquin   like oper-ord.tempo-maquin
        field numero-homem   like oper-ord.numero-homem
        field emite-ficha    like oper-ord.emite-ficha
        field oper-cq        like oper-ord.oper-cq
        field cd-mob-dir     like oper-ord.cd-mob-dir
        field linha          as int format ">>>>9"
    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
        FIELD cod-item-refugo          LIKE oper-ord.cod-item-refugo
        FIELD val-relac-refugo-item    LIKE oper-ord.val-relac-refugo-item
    &ENDIF
        index operacao op-codigo.

def temp-table tt-erros no-undo
    field nr-ord-produ like ord-prod.nr-ord-produ
    field linha        as integer format ">>>,>>9"
    field msg-erros    as char    format "x(100)"
    index codigo nr-ord-produ linha.

def temp-table tt-lixo
    field nr-ord-produ   like ord-prod.nr-ord-produ
    field c-arquivo1     as char format "x(10)"
    field linha          as int format ">>>>9".

/* Fim do Include */
