DEFINE TEMP-TABLE tt-param-esftp061 NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    field cod-estab-ini     as char
    field cod-estab-fim     as char
    FIELD i-ano-med         AS INTEGER FORMAT "9999":U
    FIELD i-mes-med         AS INTEGER FORMAT "99":U
    FIELD da-data-ini       as date
    FIELD da-data-fim       as date
    FIELD da-data-medio     AS DATE
    FIELD it-codigo-ini     AS CHARACTER
    FIELD it-codigo-fim     AS CHARACTER
    FIELD cod-rep-ini       AS INTEGER
    FIELD cod-rep-fim       AS INTEGER
    FIELD cod-emitente-ini  AS INTEGER
    FIELD cod-emitente-fim  AS INTEGER
    FIELD cod-gr-cli-ini    AS INTEGER
    FIELD cod-gr-cli-fim    AS INTEGER
    FIELD fm-cod-com-ini    AS CHARACTER
    FIELD fm-cod-com-fim    AS CHARACTER
    FIELD l-vl-presente     as dec format ">9.999999" 
    FIELD vl-icms-est       AS DEC
    FIELD l-imp-nota        AS LOG.    

DEFINE TEMP-TABLE tt-raw-digita-esftp061
       FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-erro-esftp061 NO-UNDO 
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT 
    FIELD mensagem AS CHAR FORMAT "x(255)".

def temp-table tt-calcula
    FIELD ajustes             AS LOGICAL INITIAL NO
    field tipo                as int   /*( 1 - NFF 2 - Devolucoes **/
    FIELD cod-estabel         AS CHARACTER
    field cod-msg             as int format "999"
    field unid-neg            like unid-neg-fat.cod_unid_negoc /*unid-neg.codigo*/
    field descricao-un        AS CHARACTER  /*like unid-neg-fat.descricao*/
    field unid-neg-nota       like unid-neg-fat.cod_unid_negoc /*unid-neg.codigo*/
    field descricao-un-nota   AS CHARACTER  /*like unid-neg-fat.descricao*/
    field nome-abrev          like emitente.nome-abrev
    FIELD nr-nota-fis         LIKE nota-fiscal.nr-nota-fis
    FIELD nr-pedcli           LIKE nota-fiscal.nr-pedcli
    FIELD dt-emis-nota        AS DATE FORMAT "99/99/9999"
    FIELD nat-operacao        LIKE it-nota-fisc.nat-operacao
    FIELD cod-categoria       AS CHARACTER
    field cgc                 as char 
    field cod-emitente        like emitente.cod-emitente
    field cod-rep             like repres.cod-rep
    field cod-gr-cli          like emitente.cod-gr-cli
    field cd-gr-com           AS CHARACTER FORMAT "x(04)" 
    FIELD c-desc-grupo        AS CHARACTER
    FIELD fm-cod-com          LIKE ITEM.fm-cod-com
    FIELD c-desc-familia      AS CHARACTER
    FIELD fm-codigo           LIKE ITEM.fm-codigo
    FIELD codigo-orig         LIKE ITEM.codigo-orig
    field it-codigo           like item.it-codigo 
    field descricao           as char 
    field qtd                 as decimal
    field receita             as decimal 
    field ipi                 as decimal
    field receita-bruta       as decimal
    field devolucao           as decimal
    field rec-sem-ipi         as decimal
    field vl-icms             as decimal
    field vl-icms-cp          as DECIMAL /* CREDITO PRESUMIDO */
    field vl-icms-cpi         as DECIMAL /* CREDITO PRESUMIDO IMPORTADO */
    FIELD vl-icms-cpre        AS DECIMAL /* CREDITO PRESUMIDO REGIME ESPECIAL */
    FIELD vl-icms-subs        AS DECIMAL
    field vl-pis              as decimal
    field vl-cofins           as decimal
    field vl-iss              as decimal
    FIELD vl-icms-est         AS DECIMAL
    field vl-acordo           as decimal
    field vl-fidelidade       as decimal
    field comissao            as decimal
    field comissao-distrato   as decimal
    field frete               as decimal
    field custo-fixo-prod     as decimal
    field rol                 as decimal 
    FIELD vl-prot-preco       AS DECIMAL
    field vpc                 as decimal 
    field vl-mkt              as decimal 
    field custo-mat           as decimal 
    field lucro-bruto         as decimal 
    field margem-contribuicao as decimal
    field p&d                 as decimal
    field marg-contrib-p&d    as DECIMAL
    field preco-medio         as decimal 
    field perc-lucro-rol      as decimal
    field desp-adm            as decimal
    field desp-com            as decimal
    field lucro-operacional   as decimal 
    FIELD calcula-vpc         AS LOG
    FIELD c-mercado           AS CHARACTER
    FIELD c-origem            AS CHARACTER
    FIELD estado              AS CHARACTER
    FIELD pais                AS CHARACTER
    FIELD nome-repres         AS CHARACTER 
    FIELD transf-margem       AS DECIMAL
    FIELD atendente           AS CHARACTER INITIAL "0"
    FIELD nome-matriz         AS CHARACTER 
    FIELD ncm                 LIKE ITEM.class-fiscal
    FIELD cod-segmento        AS CHAR
    FIELD consum-final        LIKE natur-oper.consum-final
    FIELD vl-bicms-it         LIKE it-nota-fisc.vl-bicms-it
    FIELD c-vertical          AS CHAR
    index item
          it-codigo
    index totais
          ajustes
          unid-neg
          it-codigo
    INDEX chave
          tipo
          cod-estabel
          unid-neg
          nome-abrev
          cod-gr-cli
          fm-cod-com
          it-codigo
          nr-nota-fis
          cod-rep
          cod-segmento
          c-vertical
    INDEX ch-ajustes ajustes tipo cod-estabel c-mercado c-origem unid-neg.

DEFINE TEMP-TABLE tt-param NO-UNDO 
   FIELD usuario     AS CHARACTER 
   FIELD senha       AS CHARACTER 
   FIELD dt-inicial  AS DATE
   FIELD dt-final    AS DATE.

DEF TEMP-TABLE ttDeducoesVendas
    FIELD CD_MasterExterno    AS CHARACTER
    FIELD CD_Empresa          AS CHARACTER
    FIELD CD_Estabelecimeto   AS CHARACTER
    FIELD CD_Mercado          AS CHARACTER
    FIELD CD_Origem           AS CHARACTER
    FIELD CD_Vertical         AS CHARACTER
    FIELD CD_UnidNegoc        AS CHARACTER
    FIELD CD_Segmento         AS CHAR
    FIELD CD_FamiliaComercial AS CHARACTER
    FIELD CD_ClassifFiscal    AS CHARACTER
    FIELD CD_Item             AS CHARACTER 
    FIELD CD_Deducao          AS CHARACTER
    FIELD NM_AnoExtracao      AS INTEGER
    FIELD NM_MesExtracao      AS INTEGER
    FIELD NM_ValorDeducao     AS DECIMAL
    INDEX idx_deducao
            CD_MasterExterno   
            NM_AnoExtracao
            NM_MesExtracao
            CD_Empresa         
            CD_Estabelecimeto  
            CD_Mercado         
            CD_Origem          
            CD_Vertical        
            CD_UnidNegoc       
            CD_Segmento        
            CD_FamiliaComercial
            CD_ClassifFiscal   
            CD_Item
            CD_Deducao.
