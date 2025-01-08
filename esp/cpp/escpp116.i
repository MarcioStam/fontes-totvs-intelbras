{cdp/cd0666.i}
/* Temp Tables Reporte Ordem de Producao - cpapi001 */

DEF TEMP-TABLE tt-rep-prod 
    FIELD tipo                  AS INTEGER 
    FIELD nr-reporte            AS INTEGER 
    FIELD nr-ord-produ          AS INTEGER 
    FIELD data                  AS DATE 
    FIELD qt-reporte            AS DECIMAL 
    FIELD qt-refugo             AS DECIMAL  
    FIELD qt-apr-cond           AS DECIMAL
    FIELD it-codigo             AS CHARACTER
    FIELD un                    AS CHARACTER 
    FIELD nro-docto             AS CHARACTER 
    FIELD serie-docto           AS CHARACTER 
    FIELD cod-depos             As CHARACTER 
    FIELD cod-localiz           AS CHARACTER 
    FIELD dep-refugo            AS CHARACTER 
    FIELD loc-refugo            AS CHARACTER 
    FIELD per-ppm               AS DECIMAL 
    FIELD lote-serie            AS CHARACTER
    FIELD cod-refer             AS CHARACTER 
    FIELD dt-vali-lote          AS DATE 
    FIELD ct-codigo             AS CHARACTER 
    FIELD sc-codigo             AS CHARACTER 
    FIELD cod-cta-unif          AS CHARACTER 
    FIELD cod-ccusto-unif       AS CHARACTER
    FIELD ct-refugo             AS CHARACTER
    FIELD sc-refugo             AS CHARACTER
    FIELD cod-depos-sai         AS CHARACTER 
    FIELD cod-local-sai         AS CHARACTER 
    FIELD op-codigo             AS INTEGER 
    FIELD cod-roteiro           AS CHARACTER 
    FIELD it-oper               AS CHARACTER
    FIELD pto-controle          AS INTEGER
    FIELD sequencia             AS INTEGER 
    FIELD baixa-reservas        AS INTEGER 
    FIELD time-out              AS INTEGER
    FIELD tentativas            AS INTEGER 
    FIELD procura-saldos        AS LOGICAL 
    FIELD carrega-reservas      AS LOGICAL 
    FIELD requis-automatica     AS LOGICAL
    FIELD prog-seg              AS CHARACTER 
    FIELD finaliza-ordem        AS LOGICAL
    FIELD finaliza-oper         AS LOGICAL 
    FIELD reserva               AS LOGICAL 
    FIELD nro-ord-seq           AS INTEGER 
    FIELD linha                 AS INTEGER 
    FIELD cod-versao-integracao AS INTEGER 
    FIELD cod-emitente          AS INTEGER 
    FIELD nat-operacao          AS CHARACTER. 

DEF TEMP-TABLE tt-refugo 
    FIELD nr-ord-produ AS INTEGER 
    FIELD codigo-rejei AS INTEGER 
    FIELD qt-refugo    AS DECIMAL 
    FIELD observacao   AS CHARACTER
    FIELD nro-ord-seq  AS INTEGER. 

DEF TEMP-TABLE tt-res-neg 
    FIELD nr-ord-produ AS INTEGER
    FIELD it-codigo    AS CHARACTER 
    FIELD quantidade   AS DECIMAL 
    FIELD cod-depos    AS CHARACTER 
    FIELD cod-localiz  AS CHARACTER
    FIELD lote-serie   AS CHARACTER 
    FIELD cod-refer    AS CHARACTER
    FIELD dt-vali-lote AS DATE
    FIELD positivo     AS LOGICAL 
    FIELD nro-ord-seq  AS INTEGER. 

DEF TEMP-TABLE tt-apont-mob 
    FIELD nr-ord-prod    AS INTEGER
    FIELD tipo-movto     AS INTEGER 
    FIELD op-codigo      AS INTEGER 
    FIELD cod-roteiro    AS CHARACTER
    FIELD it-codigo      AS CHARACTER 
    FIELD cd-mob-dir     AS CHARACTER
    FIELD gm-codigo      AS CHARACTER 
    FIELD tipo-relogio   AS INTEGER 
    FIELD hora-ini       AS INTEGER
    FIELD min-ini        AS INTEGER 
    FIELD hora-fim       AS INTEGER
    FIELD min-fim        AS INTEGER 
    FIELD centesimal-ini AS DECIMAL
    FIELD centesimal-fim AS DECIMAL
    FIELD tempo          AS DECIMAL 
    FIELD minutos-report AS INTEGER
    FIELD referencia     AS CHARACTER
    FIELD matr-func      AS INTEGER 
    FIELD nro-ord-seq    AS INTEGER. 

DEF TEMP-TABLE tt-aloca 
    FIELD cod-estabel      AS CHARACTER
    FIELD it-codigo        AS CHARACTER  
    FIELD nr-ord-produ     AS INTEGER 
    FIELD cod-depos        AS CHARACTER  
    FIELD cod-localiz      AS CHARACTER
    FIELD lote-serie       AS CHARACTER 
    FIELD quant-aloc       AS DECIMAL   
    FIELD quant-calc       AS DECIMAL   
    FIELD qt-a-req         AS DECIMAL     
    FIELD cod-refer        AS CHARACTER  
    FIELD op-codigo        AS INTEGER    
    FIELD cod-roteiro      AS CHARACTER
    FIELD item-pai         AS CHARACTER   
    FIELD un               AS CHARACTER         
    FIELD dt-vali-lote     AS DATE    
    FIELD rw-aloca-reserva AS ROWID  
    FIELD sequencia        AS INTEGER    
    FIELD veiculo          AS LOGICAL      
    FIELD per-ppm          AS DECIMAL      
    FIELD per-ppm-lote     AS DECIMAL 
    FIELD tipo-formula     AS INTEGER 
    FIELD qt-a-req-fis     AS DECIMAL 
    FIELD qt-aloc-lote     AS DECIMAL 
    FIELD l-balanceado     AS LOGICAL. 

DEF TEMP-TABLE tt-reservas 
    FIELD proporcao             AS DECIMAL    
    FIELD log-sem-saldo         AS LOGICAL
    FIELD nr-ord-produ          AS INTEGER 
    FIELD cod-refer             AS CHARACTER  
    FIELD it-codigo             AS CHARACTER  
    FIELD quant-orig            AS DECIMAL   
    FIELD quant-aloc            AS DECIMAL   
    FIELD quant-atend           AS DECIMAL  
    FIELD quant-calc            AS DECIMAL   
    FIELD quant-requis          AS DECIMAL 
    FIELD cod-depos             AS CHARACTER 
    FIELD cod-localiz           AS CHARACTER
    FIELD lote-serie            AS CHARACTER 
    FIELD dt-vali-lote          AS DATE 
    FIELD un                    AS CHARACTER 
    FIELD estado                AS INTEGER 
    FIELD tipo-sobra            AS INTEGER
    FIELD item-pai              AS CHARACTER
    FIELD op-codigo             AS INTEGER 
    FIELD cod-roteiro           AS CHARACTER 
    FIELD veiculo               AS LOGICAL
    FIELD per-ppm               AS DECIMAL
    FIELD per-ppm-lote          AS DECIMAL 
    FIELD tipo-formula          AS INTEGER 
    FIELD qt-atend-lote         AS DECIMAL
    FIELD qt-requis-lote        AS DECIMAL
    FIELD qt-aloc-lote          AS DECIMAL 
    FIELD alternativo-de        AS CHARACTER 
    FIELD cod-refer-it-original AS CHARACTER
    FIELD qt-atend-res          AS DECIMAL 
    FIELD qt-atend-lote-res     AS DECIMAL 
    FIELD quant-calc-orig       AS DECIMAL 
    FIELD processada            AS LOGICAL 
    FIELD rw-reserva            AS ROWID 
    FIELD rw-saldo-estoq        AS ROWID
    FIELD tipo-ordem            AS INTEGER
    FIELD tempo                 AS INTEGER 
    FIELD tentativas            AS INTEGER 
    FIELD sequencia             AS INTEGER. 

DEF TEMP-TABLE tt-mat-reciclado 
    FIELD nr-ord-produ AS INTEGER 
    FIELD es-codigo    AS CHARACTER 
    FIELD cod-depos    AS CHARACTER 
    FIELD cod-localiz  AS CHARACTER 
    FIELD quant-orig   AS DECIMAL 
    FIELD quant-atend  AS DECIMAL 
    FIELD quant-requis AS DECIMAL
    FIELD perc-requis  AS DECIMAL
    FIELD old-quant    AS DECIMAL 
    FIELD nro-ord-seq  AS INTEGER.

DEF TEMP-TABLE tt-oper 
    FIELD rec-oper AS ROWID. 

DEF TEMP-TABLE tt-res-neg-op-config 
    FIELD nr-ord-produ AS INTEGER  
    FIELD nr-ord-filha AS INTEGER  
    FIELD it-codigo    AS CHARACTER   
    FIELD quantidade   AS DECIMAL    
    FIELD cod-depos    AS CHARACTER   
    FIELD cod-localiz  AS CHARACTER 
    FIELD lote-serie   AS CHARACTER  
    FIELD cod-refer    AS CHARACTER   
    FIELD dt-vali-lote AS DATE     
    FIELD positivo     AS LOGICAL      
    FIELD nro-ord-seq  AS INTEGER.  

DEF VAR ch-connection   AS COM-HANDLE NO-UNDO.
DEF VAR ch-command      AS COM-HANDLE NO-UNDO.
DEF VAR ch-recordset    AS COM-HANDLE NO-UNDO.
DEF VAR ODBC-NULL       AS CHAR       NO-UNDO.

DEF TEMP-TABLE  tt-ordens
    FIELD cod-estabel     LIKE  ord-prod.cod-estabel
    FIELD nr-ord-prod     LIKE  ord-prod.nr-ord-prod
    FIELD qtde            LIKE  ord-prod.qt-ordem.

DEF TEMP-TABLE tt-linha
    FIELD nr-linha       AS INT     
    FIELD cod-depos-entr AS CHAR
    FIELD cod-depos-sai  AS CHAR
    INDEX idx nr-linha.

DEF TEMP-TABLE tt-result-rep
    FIELD nr-ord-prod AS INT
    FIELD it-codigo   AS CHAR
    FIELD desc-item   AS CHAR
    FIELD mensagem    AS CHAR
    FIELD qt-reporte  LIKE rep-prod.qt-reporte. 
    
