/********************************************************************************
**
**  SF0303A.I - Defini‡Æo de temp-table tt-reporte.
**
*********************************************************************************/

def temp-table tt-reporte no-undo
    field rw-split-operac       as rowid
    field cod-ferr-prod         like split-operac.cod-ferr-prod
    field dat-fim-setup         like split-operac.dat-fim-setup
    field dat-inic-setup        like split-operac.dat-inic-setup
    field qtd-segs-fim-setup    like split-operac.qtd-segs-fim-setup
    field qtd-segs-inic-setup   like split-operac.qtd-segs-inic-setup
    field dat-fim-reporte       like rep-oper-ctrab.dat-fim-reporte
    field dat-inic-reporte      like rep-oper-ctrab.dat-inic-reporte
    field qtd-operac-refgda     like rep-oper-ctrab.qtd-operac-refgda
    field qtd-operac-reptda     like rep-oper-ctrab.qtd-operac-reptda
    field qtd-operac-retrab     like rep-oper-ctrab.qtd-operac-retrab
    field qtd-operac-aprov      like rep-oper-ctrab.qtd-operac-aprov
    field qtd-segs-fim-reporte  like rep-oper-ctrab.qtd-segs-fim-reporte
    field qtd-segs-inic-reporte like rep-oper-ctrab.qtd-segs-inic-reporte
    field num-contador-inic     like rep-oper-ctrab.num-contador-inic
    field num-contador-fim      like rep-oper-ctrab.num-contador-fim
    field dep-refugo            like ord-prod.cod-depos
    field loc-refugo            like reservas.cod-localiz
    field cod-equipe            like rep-oper-ctrab.cod-equipe
    field baixa-reservas        as int
    field informa-deposito      as log
    field informa-localizacao   as log
    field requisicao-automatica as log
    field busca-saldos          as log
    field requisita-configurado as log
    field dep-acab              like ord-prod.cod-depos
    field loc-acab              like reservas.cod-localiz
    field cod-depos             like reservas.cod-depos
    field cod-localiz           like reservas.cod-localiz
    field lote-serie            like ord-prod.lote-serie
    field cod-refer             like ord-prod.cod-refer
    field dt-vali-lote          like saldo-estoq.dt-vali-lote
    field conta-refugo          as char 
    field conta-debito          as char
    field per-ppm               like item.per-ppm
    index id is unique primary rw-split-operac.
