DEFINE STREAM stReporte.

DEFINE TEMP-TABLE tt-filtro NO-UNDO
    FIELD cod-estabel-ini           AS CHARACTER
    FIELD cod-estabel-fim           AS CHARACTER
    FIELD dt-implant-ini            AS DATE 
    FIELD dt-implant-fim            AS DATE
    FIELD nr-ordem-ini              AS INTEGER
    FIELD nr-ordem-fim              AS INTEGER
    FIELD nr-pedido-ini             AS INTEGER
    FIELD nr-pedido-fim             AS INTEGER
    FIELD cod-emitente-ini          AS INTEGER
    FIELD cod-emitente-fim          AS INTEGER
    FIELD cod-depos-alocacao        AS CHARACTER
    FIELD tg-aberto                 AS LOGICAL
    FIELD tg-atendido-parc          AS LOGICAL
    FIELD tg-atendido-tot           AS LOGICAL
    FIELD tg-pendente               AS LOGICAL
    FIELD tg-suspenso               AS LOGICAL
    FIELD tg-cancelado              AS LOGICAL
    FIELD tg-aguardando-lib         AS LOGICAL
    FIELD tg-aguardando-ger-fci     AS LOGICAL
    FIELD tg-aguardando-sep         AS LOGICAL
    FIELD tg-lib-fat                AS LOGICAL
    FIELD tg-faturado               AS LOGICAL
    FIELD tg-aloc-pendente          AS LOGICAL
    FIELD tg-aloc-bloqueada         AS LOGICAL
    FIELD tg-aloc-parcial           AS LOGICAL
    FIELD tg-aloc-finalizada        AS LOGICAL
    FIELD tg-nf-calculada           AS LOGICAL
    FIELD tg-nf-confirmada          AS LOGICAL
    FIELD tg-nf-impressa            AS LOGICAL
    FIELD tg-openquery              AS LOGICAL
    .

DEFINE TEMP-TABLE tt-monitor-solar  NO-UNDO
    FIELD logSelecionado        AS LOGICAL      FORMAT "*/"                LABEL "Sel"
    FIELD nr-ord-prod           LIKE ord-prod.nr-ord-prod       
    FIELD nr-pedido             LIKE ped-venda.nr-pedido
    FIELD nr-pedcli             LIKE ped-venda.nr-pedcli
    FIELD cod-estabel           LIKE ped-venda.cod-estabel
    FIELD cod-depos-wms         AS CHARACTER    FORMAT "X(03)"
    FIELD dt-implant            AS DATE         FORMAT "99/99/9999"         LABEL "Data"
    FIELD it-codigo             AS CHARACTER    FORMAT "X(16)"              LABEL "Item Pai"
    FIELD nr-nota-fis           AS CHARACTER    FORMAT "X(16)"              LABEL "Nota Fiscal"
    FIELD serie                 AS CHARACTER    
    FIELD ind-situacao-solar    AS INTEGER
    FIELD des-sit-solar         AS CHARACTER    FORMAT "X(25)"              LABEL "Situaá∆o Solar"
    FIELD ind-situacao-wms      AS INTEGER
    FIELD des-sit-wms           AS CHARACTER    FORMAT "X(25)"              LABEL "Situaá∆o WMS"
    FIELD ind-situacao-alocacao AS INTEGER
    FIELD des-sit-alocacao      AS CHARACTER    FORMAT "X(25)"              LABEL "Situaá∆o Alocaá∆o"
    FIELD ind-situacao-op       AS INTEGER
    FIELD des-sit-op            AS CHARACTER    FORMAT "X(25)"              LABEL "Situaá∆o OP"
    FIELD estado                AS CHARACTER    FORMAT "X(02)"              LABEL "UF"
    FIELD cod-projeto           like int-ped-venda.cod-projeto
    FIELD vlr-comissao          like int-ped-venda.vlr-comissao
    FIELD vl-serv-inst          like int-ped-venda.vl-serv-inst
    FIELD des-sit-nota              AS CHARACTER FORMAT "X(15)"             LABEL "Situaá∆o NFs"
    FIELD des-forma-emis-nf-eletro  AS CHARACTER FORMAT "X(20)"             LABEL "Tipo de Emiss∆o"
    FIELD des-sit-nf-eletro         AS CHARACTER FORMAT "X(20)"             LABEL "Situaá∆o NFe"
    FIELD num-serie-solar           AS CHARACTER FORMAT "x(15)"             LABEL "Nr serie gerador"
    FIELD rw-ped-venda          AS ROWID
    FIELD rw-ord-prod           AS ROWID
    FIELD rw-wm-docto           AS ROWID
    FIELD rw-nota-fiscal        AS ROWID
    INDEX idxKey cod-estabel nr-ord-prod
.

DEF TEMP-TABLE tt-aloc-reservas NO-UNDO LIKE reservas
    FIELD ind-situacao-alocacao AS INTEGER
    FIELD des-sit-alocacao      AS CHARACTER    FORMAT "X(25)"              LABEL "Situaá∆o Alocaá∆o"
    FIELD saldoFnEstoque        AS DECIMAL                                  LABEL "Saldo Estoque".


DEF TEMP-TABLE tt-transfere-item NO-UNDO
    FIELD cod-estabel AS CHAR
    FIELD cod-item    AS CHAR
    FIELD qtd-item    AS DEC.

DEF TEMP-TABLE tt-transfere-aloc NO-UNDO
    FIELD cod-depos   AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD cod-estabel AS CHAR.

/*
DEF TEMP-TABLE ttNotas NO-UNDO
    FIELD lok               AS LOG FORMAT ' X/ ' COLUMN-LABEL 'Impr.'
    FIELD limp              AS LOG INITIAL NO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cod-emitente      LIKE nota-fiscal.cod-emitente
    FIELD nome              LIKE emitente.nome-abrev
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque"
    FIELD estado            LIKE nota-fiscal.estado
    FIELD serie             like nota-fiscal.serie
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD cd-oper           LIKE atendente.cd-oper
    FIELD nm-oper           LIKE atendente.nm-oper
    FIELD dt-emis-nota      LIKE nota-fiscal.dt-emis-nota
    FIELD idi-sit-nf-eletro LIKE nota-fiscal.idi-sit-nf-eletro 
    FIELD nat-operacao      LIKE nota-fiscal.nat-operacao
    FIELD r-rowid           AS ROWID.
*/

def temp-table tt-param-aux
    field destino              as integer
    field destino-bloq         as integer
    field arquivo              as char
    field arquivo-bloq         as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field cod-layout           as character
    field des-layout           as character
    field log-impr-dados       as logical  
    field v_num_tip_aces_usuar as integer
    field ep-codigo            LIKE mgcad.empresa.ep-codigo
    field da-dt-saida          like movdis.nota-fiscal.dt-saida
    field c-hr-saida           AS CHAR FORMAT "xx:xx:xx":U INITIAL "000000"
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as integer
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    FIELD l-gera-danfe-xml     AS LOGICAL
    FIELD c-dir-hist-xml       AS CHARACTER
    FIELD ind-execucao         AS INT
    FIELD data-ini             AS DATE
    FIELD data-fim             AS DATE
    FIELD log-imp-notafiscal   AS LOGICAL
    FIELD log-imp-romaneio     AS LOGICAL
    FIELD log-imp-Manual       AS LOGICAL
    FIELD log-imp-Estrutura    AS LOGICAL
    FIELD log-imp-folhaRosto   AS LOGICAL.


DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             like nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque"
    FIELD it-codigo         LIKE tt-monitor-solar.it-codigo
    FIELD nr-ord-prod       LIKE tt-monitor-solar.nr-ord-prod
    FIELD nr-pedido         LIKE tt-monitor-solar.nr-pedido
    FIELD nr-pedcli         LIKE nota-fiscal.nr-pedcli
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD rw-nota-fiscal    AS ROWID.


DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.


DEF VAR h-acomp                     AS HANDLE NO-UNDO.
DEFINE VARIABLE c-deposito          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cod-depos-entrada   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSituacaoSolar      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSituacaoAlocacao   AS CHARACTER   NO-UNDO.
ASSIGN  cSituacaoSolar      = "Aguardando Lib. Financeira,Aguardando Geraá∆o FCI,Aguardando Separaá∆o,Aguardando Faturamento,Faturado"
        cSituacaoAlocacao   = "Pendente,Bloqueada,Parcial,Finalizada".

DEF TEMP-TABLE tt-itens-docto LIKE wm-docto-itens.
DEFINE VARIABLE cArquivo            AS CHARACTER   NO-UNDO.

