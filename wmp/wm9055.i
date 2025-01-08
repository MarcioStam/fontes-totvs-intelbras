DEFINE TEMP-TABLE tt-saldo-aloc NO-UNDO
    FIELD cod-estabel      LIKE wms-box-sdo-alocad.cod-estabel
    FIELD cod-local        LIKE wms-box-sdo-alocad.cod-local
    FIELD cod-cliente      LIKE wms-box-sdo-alocad.cod-cliente
    FIELD cod-item         LIKE wms-box-sdo-alocad.cod-item
    FIELD cod-refer        LIKE wms-box-sdo-alocad.cod-refer
    FIELD cod-lote         LIKE wms-box-sdo-alocad.cod-lote
    FIELD id-box           LIKE wms-box-sdo-alocad.id-box
    FIELD cod-embalagem    LIKE wms-box-sdo-alocad.cod-embalagem
    FIELD ind-status-saldo LIKE wms-box-sdo-alocad.ind-status-saldo
    FIELD qtd-alocada      LIKE wms-box-sdo-alocad.qtd-alocada
    FIELD qtd-box          LIKE wms-box-sdo-alocad.qtd-item
    INDEX chave IS PRIMARY UNIQUE cod-estabel cod-local cod-cliente cod-item cod-refer cod-lote cod-embalagem ind-status-saldo id-box.