/* Vari veis local ESPDP091   */

DEFINE VARIABLE da-data             AS DATETIME                         NO-UNDO.
DEFINE VARIABLE da-data-atual       AS DATETIME                         NO-UNDO.
DEFINE VARIABLE da-data-ini         AS DATETIME                         NO-UNDO.
DEFINE VARIABLE c_cod_estab_usuar   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE vEstabel-ini        LIKE ped-venda.cod-estabel          NO-UNDO INIT '' LABEL "Estabelecimento" VIEW-AS FILL-IN SIZE 5 BY 0.88.
DEFINE VARIABLE vEstabel-fim        LIKE ped-venda.cod-estabel          NO-UNDO INIT 'ZZZ' VIEW-AS FILL-IN SIZE 5 BY 0.88.
DEFINE VARIABLE vAtendente-ini      LIKE ped-venda.tp-pedido            NO-UNDO INIT 00 LABEL "Atendente" VIEW-AS FILL-IN SIZE 3 BY 0.88.
DEFINE VARIABLE vAtendente-fim      LIKE ped-venda.tp-pedido            NO-UNDO INIT 00 VIEW-AS FILL-IN SIZE 3 BY 0.88.
DEFINE VARIABLE vRepres-ini         LIKE repres.cod-rep                 NO-UNDO INIT "0" LABEL "Representante".
DEFINE VARIABLE vRepres-fim         LIKE repres.cod-rep                  NO-UNDO INIT "99999".
DEFINE VARIABLE vEntrega-ini        LIKE ped-item.dt-entrega            NO-UNDO INIT 01/01/1900 VIEW-AS FILL-IN SIZE 10 BY 0.88 LABEL "Dt Entrega".
DEFINE VARIABLE vEntrega-fim        LIKE ped-item.dt-entrega            NO-UNDO INIT TODAY VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE vPedido-ini         LIKE ped-venda.nr-pedcli            NO-UNDO INIT "".
DEFINE VARIABLE vPedido-fim         LIKE ped-venda.nr-pedcli            NO-UNDO INIT "ZZZZZZZZZZZZ".
DEFINE VARIABLE vImpPed-ini         LIKE ped-venda.dt-implant           NO-UNDO INIT 01/01/1900 VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE vImpPed-fim         LIKE ped-venda.dt-implant           NO-UNDO INIT TODAY VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE vCond-ini           LIKE ped-venda.cod-cond-pag         NO-UNDO INIT 0 VIEW-AS FILL-IN SIZE 4 BY 0.88.
DEFINE VARIABLE vCond-fim           LIKE ped-venda.cod-cond-pag         NO-UNDO INIT 999 VIEW-AS FILL-IN SIZE 4 BY 0.88.
DEFINE VARIABLE vPrior-ini          LIKE ped-venda.cod-priori           NO-UNDO INIT 01 VIEW-AS FILL-IN SIZE 3 BY 0.88.
DEFINE VARIABLE vPrior-fim          LIKE ped-venda.cod-priori           NO-UNDO INIT 01 VIEW-AS FILL-IN SIZE 3 BY 0.88.
DEFINE VARIABLE voperMestreIni      LIKE atendente.oper-mestre   NO-UNDO INIT 00 VIEW-AS FILL-IN SIZE 4 BY 0.88.
DEFINE VARIABLE voperMestreFim      LIKE atendente.oper-mestre   NO-UNDO INit 99 VIEW-AS FILL-IN SIZE 4 BY 0.88.
DEFINE VARIABLE vCodEmite-ini       AS INTEGER  FORMAT '>>>>>>>>9'      NO-UNDO INIT "0" LABEL "Cliente".
DEFINE VARIABLE vCodEmite-fim       AS INTEGER  FORMAT '>>>>>>>>9'      NO-UNDO INIT "999999999".
DEFINE VARIABLE vItCodigo           AS CHARACTER                        NO-UNDO INITIAL "" LABEL "Item".
DEFINE VARIABLE vUnid-Neg           LIKE unid-negoc.cod-unid-negoc      VIEW-AS COMBO-BOX INNER-LINES 5 LABEL 'UN.Neg.' NO-UNDO.
DEFINE VARIABLE vCodSitAval         AS CHARACTER                        VIEW-AS COMBO-BOX INNER-LINES 5 NO-UNDO.
DEFINE VARIABLE vEntFutura          AS LOGICAL                          INIT YES VIEW-AS TOGGLE-BOX NO-UNDO.
DEFINE VARIABLE de-vl-total         AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE vSitCred            AS CHARACTER                        VIEW-AS COMBO-BOX INNER-LINES 5 LABEL 'Sit.Cred.' NO-UNDO.
DEFINE VARIABLE d-saldo             AS DECIMAL FORMAT "->>>,>>9"        NO-UNDO LABEL "Saldo Ped".
DEFINE VARIABLE d-estoque           AS DECIMAL FORMAT "->>>,>>9"        NO-UNDO LABEL "Estoq Disp".
DEFINE VARIABLE i-aloca             AS DECIMAL FORMAT ">>>,>>9"         NO-UNDO LABEL "Reservado".
DEFINE VARIABLE c-descitem          AS CHAR    FORMAT "x(60)"           NO-UNDO LABEL "Descri‡Æo".
DEFINE VARIABLE rGoto               AS ROWID                            NO-UNDO.
DEFINE BUFFER b-ped-item            FOR ped-item.
DEFINE VARIABLE c-nome-abrev-sel    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-nr-pedcli-sel     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE vQtAlocar           LIKE ped-item.qt-pedida             NO-UNDO.
DEFINE VARIABLE vQtAlocada          LIKE ped-item.qt-pedida             NO-UNDO.
DEFINE VARIABLE vQtSaldo            LIKE saldo-estoq.qtidade-atu        NO-UNDO.
DEFINE VARIABLE vQtTransferida      AS   INTEGER                        NO-UNDO.
DEFINE VARIABLE cReturn             AS   CHARACTER                      NO-UNDO.
DEFINE VARIABLE c-old-value         LIKE ped-item.qt-log-aloca          NO-UNDO.
DEFINE VARIABLE c-resp              AS   CHARACTER                      NO-UNDO.
DEFINE VARIABLE l-enter             AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-reserva           AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-cotas             AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE c-mesgitem          AS   CHAR                           NO-UNDO.
DEFINE VARIABLE l-peso              AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE c-mesgitem-nar      AS   CHAR                           NO-UNDO.   
DEFINE VARIABLE l-narrativa         AS   LOGICAL                        NO-UNDO.   
DEFINE VARIABLE l-dt-entrega        AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE c-pedido-critica    AS   CHARACTER                      NO-UNDO.
DEFINE VARIABLE vNrOrdem            AS INT                              NO-UNDO.
DEFINE VARIABLE vMsgErro            AS CHAR                             NO-UNDO.
DEFINE VARIABLE c-ant               AS CHAR                             NO-UNDO.
DEFINE VARIABLE l-limpo             AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-mod               AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE c-lista             AS CHAR                             NO-UNDO.
DEFINE VARIABLE c-imp               AS CHAR                             NO-UNDO.
DEFINE VARIABLE v_log_program_api   AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO NO-UNDO.
DEFINE VARIABLE c-impressora        as char                             NO-UNDO.
DEFINE VARIABLE V_REC_LOG           as RECID format ">>>>>>9"           NO-UNDO.
DEFINE VARIABLE i-parc              AS INT                              NO-UNDO.
DEFINE VARIABLE de-valor            AS DEC                              NO-UNDO.
DEFINE VARIABLE de-valor-param      AS DEC                              NO-UNDO.
DEFINE VARIABLE de-qtd-estoq        AS DECIMAL                          NO-UNDO.                          
DEFINE VARIABLE de-aloca-item-astec    AS DECIMAL                       NO-UNDO.
DEFINE VARIABLE de-desaloca-item-astec AS DECIMAL                       NO-UNDO.
DEFINE VARIABLE de-win-orig-width   AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE de-win-orig-height  AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE c-nome-coluna       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE l-asc               AS LOGICAL                          NO-UNDO INITIAL YES.
DEFINE VARIABLE lista-handle-coluna AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE l-bloqueado         AS LOGICAL                          NO-UNDO INIT NO.
DEFINE VARIABLE de-fnEstoque        AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE i-faturaSel         AS INTEGER                          NO-UNDO INIT 1.
DEFINE VARIABLE v-pedido-anterior   AS INTEGER                          NO-UNDO.
DEFINE VARIABLE raw-param           AS RAW                              NO-UNDO.
DEFINE VARIABLE raw-param2          AS RAW                              NO-UNDO.
DEFINE VARIABLE de-fator-1          as decimal format "999999,9999" init 1 NO-UNDO.
DEFINE VARIABLE d-vl-aberto         as decimal                          NO-UNDO.
DEFINE VARIABLE gr-ped-venda005     AS ROWID                            NO-UNDO.

DEFINE VARIABLE vEstado-ini         LIKE ped-venda.estado               NO-UNDO INIT '' LABEL "Estabelecimento" VIEW-AS FILL-IN SIZE 5 BY 0.88.
DEFINE VARIABLE vEstado-fim         LIKE ped-venda.estado               NO-UNDO INIT 'ZZZ' VIEW-AS FILL-IN SIZE 5 BY 0.88.
