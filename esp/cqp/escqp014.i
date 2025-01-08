DEFINE TEMP-TABLE tt-ficha-cq NO-UNDO
    FIELD nr-ficha          AS INTEGER      LABEL "Ficha CQ"            FORMAT ">>>>,>>9"
    FIELD cod-estabel       AS CHARACTER    LABEL "Estab"               FORMAT "X(05)"
    FIELD cod-depos         AS CHARACTER    LABEL "Dep"                 FORMAT "X(03)"
    FIELD cod-deposito-pad  AS CHARACTER    LABEL "Dep.Padrao"           FORMAT "X(03)"
    FIELD dt-ficha          AS DATE         LABEL "Data Ficha"          FORMAT "99/99/9999"
    FIELD it-codigo         AS CHARACTER    LABEL "Item"                FORMAT "X(16)"
    FIELD desc-item         AS CHARACTER    LABEL "Descri‡Æo Item"      FORMAT "X(60)"
    FIELD cod-emitente      AS INTEGER      LABEL "Emitente"            FORMAT ">>>>>>>>9"
    FIELD nome-abrev        AS CHARACTER    LABEL "Nome Abrev"          FORMAT "X(12)"
    FIELD nro-docto         AS CHARACTER    LABEL "Documento"           FORMAT "X(16)"
    FIELD origem            AS INTEGER                                  FORMAT "9"
    FIELD des-origem        AS CHARACTER    LABEL "Origem"              FORMAT "X(12)"
    FIELD skipe-lote        AS INTEGER      LABEL "Skip Lote"          FORMAT ">>>>>>>>9"
    FIELD item-critico      AS CHARACTER    LABEL "Item Cr¡tico"        FORMAT "X(16)"
    FIELD qt-original       AS DECIMAL      LABEL "Qtd.Inspe‡Æo"        FORMAT ">>>>>,>>9.9999"
    FIELD qt-aprovada       AS DECIMAL      LABEL "Qtd.Aprovada"        FORMAT ">>>>>,>>9.9999"
    FIELD qt-rejeitada      AS DECIMAL      LABEL "Qtd.Rejeitada"       FORMAT ">>>>>,>>9.9999"
    FIELD situacao          AS INTEGER                                  FORMAT "9"
    FIELD des-situacao      AS CHARACTER    LABEL "Situa‡Æo"            FORMAT "X(16)" 
    FIELD cod-usuario       AS CHARACTER    LABEL "Usu rio"             FORMAT "X(12)"
    FIELD dt-analise        AS DATE         LABEL "Data An lise"        FORMAT "99/99/9999"
    FIELD hr-analise        AS CHARACTER    LABEL "Hora An lise"        FORMAT "X(08)"
    FIELD num-pedido        AS INTEGER      LABEL "Pedido de Compra"    FORMAT ">>>>>,>>9"
    FIELD baixa-estoq       AS LOGICAL      LABEL "Baixa Estoq"
    FIELD log-wms           AS LOGICAL      LABEL "WMS"
    FIELD rRowid            AS ROWID
    INDEX idxKey IS PRIMARY UNIQUE nr-ficha
    .
    
DEFINE TEMP-TABLE tt-parametros NO-UNDO
    FIELD cod-estabel-ini           AS CHARACTER
    FIELD cod-estabel-fim           AS CHARACTER
    FIELD nr-ficha-ini              AS INTEGER
    FIELD nr-ficha-fim              AS INTEGER
    FIELD dt-ficha-ini              AS DATE
    FIELD dt-ficha-fim              AS DATE
    FIELD it-codigo-ini             AS CHARACTER
    FIELD it-codigo-fim             AS CHARACTER
    FIELD desc-item-ini             AS CHARACTER
    FIELD desc-item-fim             AS CHARACTER
    FIELD cod-depos-ini             AS CHARACTER
    FIELD cod-depos-fim             AS CHARACTER
    FIELD numTempoRefresh           AS INTEGER
    FIELD logItensCriticos          AS LOGICAL
    FIELD logOriEstoque             AS LOGICAL
    FIELD logOriManual              AS LOGICAL
    FIELD logOriManualMovtoEstoque  AS LOGICAL
    FIELD logOriProducao            AS LOGICAL
    FIELD logSitCancelado           AS LOGICAL
    FIELD logSitEmAnalise           AS LOGICAL
    FIELD logSitPendente            AS LOGICAL
    FIELD logSitPendenteNF          AS LOGICAL
    FIELD logSitPendenteRetorno     AS LOGICAL
    FIELD logSitTerminado           AS LOGICAL
    FIELD logSomenteWMS             AS LOGICAL
    .
