DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel     AS CHARACTER INITIAL ?
    FIELD serie           AS CHARACTER INITIAL ?
    FIELD nr-nota-fis     AS CHARACTER INITIAL ?
    FIELD cod-emitente    AS INTEGER   INITIAL ?
    FIELD cod-rep         AS INTEGER   
    FIELD tipo-nf         AS INTEGER   INITIAL ?    
    FIELD dt-emis-nota    AS DATE      INITIAL ?
    FIELD nat-operacao    AS CHARACTER INITIAL ?
    FIELD cod-canal-venda AS INTEGER   INITIAL ?
    FIELD cod-transp      AS INTEGER   INITIAL ?
    FIELD cod-entrega     AS CHARACTER INITIAL ?
    FIELD nr-tabpre       AS CHARACTER 
    FIELD volumes         AS DECIMAL   INITIAL ?
    FIELD observacao      AS CHARACTER INITIAL ?
    FIELD cod-cond-pag    AS INTEGER   INITIAL ?
    FIELD cod-des-merc    AS INTEGER
    FIELD estado          AS CHARACTER
    FIELD pais            AS CHARACTER
    FIELD endereco    AS CHARACTER
    FIELD bairro          AS CHARACTER
    FIELD cidade        AS CHARACTER
    FIELD cep             AS CHARACTER
    FIELD ins-estadual    AS CHARACTER
    FIELD nr-volumes      AS CHARACTER
    FIELD peso-bru-tot    AS DECIMAL
    FIELD peso-liq-tot    AS DECIMAL
    FIELD vl-embalagem    AS DECIMAL
    FIELD vl-mercad       AS DECIMAL
    FIELD moeda           AS INTEGER    
    FIELD nome-tr-red     AS CHARACTER
    FIELD nome-transp     AS CHARACTER
    FIELD nr-fatura       AS CHARACTER
    FIELD ind-lib-nota    AS LOGICAL
    FIELD cod-portador    AS INTEGER
    FIELD modalidade      AS INTEGER
    FIELD nr-tab-finan    AS INTEGER
    FIELD nr-ind-finan    AS INTEGER    
    FIELD chave-acesso-nfe AS CHARACTER
    FIELD situacao-nfe    AS CHARACTER
    FIELD vl-frete        AS DECIMAL
    FIELD vl-desc-tot     AS DECIMAL
	FIELD vl-taxa-exp     AS DECIMAL.

DEFINE TEMP-TABLE item-nota-fiscal NO-UNDO
    FIELD it-codigo     AS CHARACTER
    FIELD nr-seq-fat    AS INTEGER
    FIELD cod-refer     AS CHARACTER
    FIELD qt-faturada   AS DECIMAL
    FIELD nat-operacao  AS CHARACTER
    FIELD cod-depos     AS CHARACTER
    FIELD cod-localiz   AS CHARACTER
    FIELD nr-serlote    AS CHARACTER
    FIELD dt-vali-lote  AS DATE 
    FIELD vl-preori-ped AS DECIMAL
    FIELD baixa-estoq   AS LOGICAL
    FIELD class-fiscal  AS CHARACTER
    FIELD un-fatur      AS CHARACTER
    FIELD vl-merc-liq   AS DECIMAL
    FIELD vl-merc-ori   AS DECIMAL
    FIELD vl-merc-tab   AS DECIMAL
    FIELD vl-pretab     AS DECIMAL
    FIELD vl-preuni     AS DECIMAL
    FIELD vl-tot-item   AS DECIMAL
    FIELD cd-trib-icm   AS INTEGER
    FIELD cd-trib-ipi   AS INTEGER
    FIELD vl-bicms-it   AS DECIMAL
    FIELD vl-bipi-it    AS DECIMAL
    FIELD aliquota-icm  AS DECIMAL
    FIELD vl-icms-it    AS DECIMAL
    FIELD aliquota-ipi  AS DECIMAL
    FIELD vl-ipi-it     AS DECIMAL
    FIELD vl-ipi-outros AS DECIMAL
    FIELD cd-trib-iss   AS INTEGER
    FIELD vl-frete      AS DECIMAL
    FIELD vBCUFDest     AS DECIMAL
    FIELD vBCFCPUFDest  AS DECIMAL
    FIELD pFCPUFDest    AS DECIMAL
    FIELD pICMSUFDest   AS DECIMAL
    FIELD pICMSInter    AS DECIMAL
    FIELD pICMSInterPart AS DECIMAL
    FIELD vFCPUFDest    AS DECIMAL
    FIELD vICMSUFDest   AS DECIMAL
    FIELD vICMSUFRemet  AS DECIMAL
    FIELD vl-base-pis   AS DECIMAL
    FIELD perc-pis      AS DECIMAL
    FIELD vl-pis        AS DECIMAL
    FIELD vl-base-cofins AS DECIMAL
    FIELD perc-cofins    AS DECIMAL
    FIELD vl-cofins      AS DECIMAL
    FIELD perc-red-icms  AS DECIMAL
    FIELD vl-icms-nt     AS DECIMAL
    FIELD vl-desconto    AS DECIMAL
    FIELD vl-bsubs-it    AS DECIMAL
    FIELD vICMSST        AS DECIMAL
    FIELD pICMSST        AS DECIMAL
    FIELD vBCFCPST       AS DECIMAL
    FIELD pFCPST         AS DECIMAL
    FIELD vFCPST         AS DECIMAL
    INDEX ITEM it-codigo.
    
DEFINE TEMP-TABLE tt-fat-duplic NO-UNDO LIKE fat-duplic.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INTEGER             
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)".
