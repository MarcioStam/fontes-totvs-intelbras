define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table ttFactPlanejamentoItem no-undo
    field CD_Estabelecimento     like docum-est.cod-estabel
    field CD_Item                like item-doc-est.it-codigo
    field DT_Posicao               AS DATE
    field DT_Planejado             AS DATE
    field NM_Previsao_Demanda    like item-doc-est.quantidade
    INDEX id-item-estab
            CD_Estabelecimento  
            CD_Item             
            DT_Posicao. 

DEFINE TEMP-TABLE tt-reservas NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD it-codigo   LIKE item-doc-est.it-codigo
    FIELD qtd-prev    LIKE item-doc-est.quantidade
    FIELD cdn-mes       AS INT
    FIELD cdn-ano       AS INT
    INDEX id-item-periodo
            cod-estabel
            it-codigo  
            cdn-mes    
            cdn-ano.

DEFINE TEMP-TABLE tt-estab-plano-prod NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD cd-plano    LIKE pl-prod.cd-plano.

