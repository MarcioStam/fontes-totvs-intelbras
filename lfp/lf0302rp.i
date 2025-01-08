define {1} {2} temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)"
    field l-parametros       as logical
    field c-empresa          as char
    field i-empresa-ems2     like mgcad.empresa.ep-codigo
    field dt-ini             as date
    field dt-fim             as date
    field c-cenario-contabil as char /* EMS 5 */
    /* field c-matriz-contas    as char /* EMS 5 */ */
    field c-diario           as char
    field c-contabilidade    as char
    field l-ems5-caixa-bancos   as logical format "Sim/NÆo"
    field l-ems5-contas-pagar   as logical format "Sim/NÆo"
    field l-ems5-contas-receber as logical format "Sim/NÆo"
    field l-ems5-ativo-fixo     as logical format "Sim/NÆo"
    field l-ems5-aplic-emprest  as logical format "Sim/NÆo"
    field l-ems5-hrb            as logical format "Sim/NÆo"
    field l-ems5-hpp            as logical format "Sim/NÆo"
    field l-ems5-hfp            as logical format "Sim/NÆo"
    field l-ems2-estoque        as logical format "Sim/NÆo"
    field l-ems2-faturamento    as logical format "Sim/NÆo"
    field l-ems2-caixa-bancos   as logical format "Sim/NÆo"
    field l-ems2-contas-pagar   as logical format "Sim/NÆo"
    field l-ems2-contas-receber as logical format "Sim/NÆo"
    field l-ems2-patrimonio     as logical format "Sim/NÆo"
    field l-ems2-tms            as logical format "Sim/NÆo"
    field l-balancete        as logical format "Sim/NÆo"
    field c-tipo-balancete   as char 
    field i-nivel            as integer
    field l-demonstrativo    as logical format "Sim/NÆo"
    field c-balanco          as char
    field c-demonstracao     as char
    field l-atualiza-participante as logical format "Sim/NÆo"
    field l-relaciona-lancto-participante as logical format "Sim/NÆo"
    FIELD l-ems2-mri AS LOGICAL FORMAT "Sim/NÆo"
    FIELD l-gera-j100 AS LOGICAL FORMAT "Sim/NÆo"
    field l-apura-result-sped as logical format "Sim/NÆo"
    field c-conta-lucros-perdas as char   
    .

define {1} {2} temp-table tt-log-erros-sped no-undo
    field num-seq                      as integer
    field num-cod-erro                 as integer
    field des-erro                     as character
    field des-ajuda                    as character
    field cod-cta-ctbl                 as character
    field cod-ccusto                   as character
    field log-erro-tela                as logical 
    index tt-erro
          num-cod-erro                 ascending
          cod-cta-ctbl                 ascending
          cod-ccusto                   ascending
    index tt-id
          num-seq                      ascending
          num-cod-erro                 ascending
    .

