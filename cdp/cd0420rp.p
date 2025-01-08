/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/************************************************************************
**
**  i-prgvrs.i - Programa para criacao do log de todos os programas 
**               e objetos do EMS 2.0 para objetos
**  {1} = objeto   provido pelo Roundtable
**  {2} = versao   provido pelo Roundtable
************************************************************************/

/*Alteraá∆o - 08/09/2006 - tech1007 - Alterado para possuir a definiá∆o dos prÇprocessadores logo no in°cio do programa*/
/**** Alteraá∆o efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
/*************************************************
* i_dbvers.i - Include de vers∆o de banco de dados   
**************************************************/

/* Preprocessadores que identificam os bancos do Produto EMS 5 */

/* Preprocessadores que identificam os bancos do Produto EMS 2 */
/*RAC Incorporado na 2.04*/

/* Preprocessadores que identificam os bancos do Produto HR 2 */

/* Fim */


 
/*Fim alteraá∆o 08/09/2006*/

def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.
def var c-prg-vrs as char init "[[[2.00.01.091[[[" no-undo.
def var c-prg-obj as char no-undo.
assign c-prg-vrs = "2.00.01.091"
       c-prg-obj = "CD0420RP".

/* Alteracao - 02/10/2006 - Nakamura - Incluida chamada a include que verifica a integridade dos programas do registro de produto */

 

/*Alteraá∆o - 08/09/2006 - tech1007 - Alteraá∆o para exibir o nome do programa que executou o programa que ser† exibido no extrato de vers∆o
                                      Solicitaá∆o realizada na FO 1239827*/

def var c-prg-obj-pai as char no-undo.

IF VALID-HANDLE(THIS-PROCEDURE:INSTANTIATING-PROCEDURE) THEN DO:
    ASSIGN c-prg-obj-pai = THIS-PROCEDURE:INSTANTIATING-PROCEDURE:FILE-NAME.
END.
ELSE DO:
    ASSIGN c-prg-obj-pai = "".
END.

IF NUM-ENTRIES(c-prg-obj-pai, "~/") > 1 THEN DO:
    ASSIGN c-prg-obj-pai = ENTRY(NUM-ENTRIES(c-prg-obj-pai, "~/"),c-prg-obj-pai, "~/").
END.
IF NUM-ENTRIES(c-prg-obj-pai, ".") > 1 THEN DO:
    ASSIGN c-prg-obj-pai = ENTRY(1,c-prg-obj-pai, ".").
END.

/*Fim alteraá∆o 08/09/2006*/


if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    find prog_dtsul
        where prog_dtsul.cod_prog_dtsul = "CD0420RP"
        no-lock no-error.
        
   if not avail prog_dtsul then do:
          if  c-prg-obj begins "btb":U then
              assign c-prg-obj = "btb~/":U + c-prg-obj.
          else if c-prg-obj begins "men":U then
                  assign c-prg-obj = "men~/":U + c-prg-obj.
          else if c-prg-obj begins "sec":U then
                  assign c-prg-obj = "sec~/":U + c-prg-obj.
          else if c-prg-obj begins "utb":U then
                  assign c-prg-obj = "utb~/":U + c-prg-obj.
          find prog_dtsul where
               prog_dtsul.nom_prog_ext begins c-prg-obj no-lock no-error.
   end .            /*if*/
    
    output to value(c-arquivo-log) append.

    /*Alteraá∆o - 08/09/2006 - tech1007 - Alteraá∆o para exibir o nome do programa que executou o programa que ser† exibido no extrato de vers∆o
                                      Solicitaá∆o realizada na FO 1239827*/
    
        PUT "CD0420RP" AT 1 "2.00.01.091" AT 39 c-prg-obj-pai AT 54 STRING(TODAY,'99/99/99') AT 84 STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
    
    /*Fim alteraá∆o 08/09/2006*/
                                                  
    if  avail prog_dtsul then do:
        if  prog_dtsul.nom_prog_dpc <> "" then
            put "DPC : ":U at 5 prog_dtsul.nom_prog_dpc  at 12 skip.
        if  prog_dtsul.nom_prog_appc <> "" then
            put "APPC: ":U at 5 prog_dtsul.nom_prog_appc at 12 skip.
        if  prog_dtsul.nom_prog_upc <> "" then
            put "UPC : ":U at 5 prog_dtsul.nom_prog_upc  at 12 skip.
    end.
    output close.        
end.  
error-status:error = no.
/***************************************************
** i_dbtype.i - Tipo de Gerenciadores utilizados
***************************************************/


            
    /* Preprocessadores que identificam os bancos do Produto EMS 5 */
                    
    /* Preprocessadores que identificam os bancos do Produto EMS 2 */
                                                                                                                                        
    
    /* Preprocessadores que identificam os bancos do Produto HR 2 */
            

/* Fim */

 

/*alteracao Anderson(tech540) em 04/02/2003 Include com a definicao 
da temp table utilizada nas includes btb008za.i1 e btb008za.i2 para 
execucao de programas via rpc*/
def temp-table tt-control-prog NO-UNDO
    field cod-versao-integracao as integer       format '999'
    field cod-erro              as integer       format '99999'
    field desc-erro             as character     format 'x(60)'
    field wgh-servid-rpc        as widget-handle format '>>>>>>9'.

 
/*fim alteracao Anderson 04/02/2003*/


/* alteraá∆o feita para atender ao WebEnabler - Marcilene Oliveira - 18/12/2003 */

DEFINE NEW GLOBAL SHARED VARIABLE hWenController AS HANDLE     NO-UNDO.
/*Constante utilizada apenas para verificar se a vari†vel acima foi definida */ 

/* fim da alateraá∆o */

/* Alteraá∆o realizada por tech38629 - 19/07/2006 - Definiá∆o do pre-processador para o facelift */
/****************************************************************/
/* i_fclpreproc.i                                               */
/* Criado por: tech38629                                        */
/* Data de criaá∆o: 19/07/2006                                  */
/* Descriá∆o: Define o prÇ-processador que indica a utilizaá∆o  */
/*            do facelift                                       */
/****************************************************************/

 
/* Fim da alteraá∆o */

  /*** 010190 ***/


/*  {include/i_fnctrad.i} */
 /*** Esta include no ems 2.01 n∆o dever† possuir nenhum c¢digo, serve 
     apenas para desenvolvimento tratar o conceito de miniflexibilizaá∆o.
     Utilizado apenas para MANUFATURA. ***/

/*** RELEASE 2.02 ***/
/* Funá‰es ch∆o f†brica e lista de componentes 2.02 - Logoplaste - Manufatura */
/*** RELEASE 2.03 ***/
/* Integraá∆o Magnus x SFC 2.03 - Klimmek - Manufatura *//* Relacionamento Linha Produá∆o x Estabelecimento     *//* Transaá∆o Reporte Ass°ncrono                        *//* Alteraá‰es Gerais EMS 2.03                          */
/*** RELEASE 2.04 ***/
/* Alteraá‰es Gerais EMS 2.04                          */
/*** RELEASE 2.04A ***/
/* Alteraá‰es p/ Foresight                             */
/*** RELEASE 2.05 ***/
/* Importaá∆o de Transaá‰es via ASCII                  *//* 3 Novas Vis‰es Gerenciais no SFC                    *//* Preáo de Venda de Itens Configurados                *//* Ponto de Reposiá∆o no MRP                           *//* Override de Ordens no MRP                           *//* Integraá∆o do ERP com APS                           *//* Tratamento do Fator de Concentraá∆o                 *//* Alteraá‰es Gerais EMS 2.05                          *//* Tratamento do Refugo por Operaá∆o (no SFC)          */
/*** RELEASE 2.06 ***/
/* Alteraá‰es Gerais EMS 2.06                          *//* Alteraá‰es DBR                                      */
/*** RELEASE 2.06B ***/
/* Alteraá‰es Gerais EMS 2.06B                         */
/*** RELEASE 2.07 ***/
/* Alteraá‰es Gerais EMS 2.07                         */
/*** RELEASE 2.07A ***/
/* Alteraá‰es Gerais EMS 2.07A   */
/*** RELEASE 2.08 ***/
/* Utilizado para Teste de Release*//* Funcionalidade de Lote Avanáado */

  /******* Include para mini-flexibilizaá∆o *********/ 

define temp-table tt-raw-digita NO-UNDO
    field raw-digita     as raw.
def var da-termino-f as date   no-undo.

DEFINE TEMP-TABLE tt-item-selec NO-UNDO
    FIELD rowid-item AS ROWID
    FIELD cd-planej  LIKE planejad.cd-planejad
    FIELD nome       LIKE planejad.nome
    index codigo cd-planej.


    define variable l-usa-unid-negoc as logical init no no-undo.
    if(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio":U and 
            funcao.ativo    = yes)) then do:
        assign l-usa-unid-negoc = yes.
    end.

    DEF VAR h-cdapi024    AS HANDLE NO-UNDO.


/* esta temp-table Ç criada na pi-cria-ord-res e vai servir para que se 
   diminua o acesso a disco quando estiver no for each de reservas na 
   cd0284.i */
DEFINE TEMP-TABLE tt-ord-res NO-UNDO
    FIELD nr-ord-produ AS INTEGER
    FIELD cod-estabel  AS CHARACTER
    FIELD estado       AS INTEGER
    FIELD it-codigo    AS CHARACTER
    INDEX id IS PRIMARY UNIQUE
        nr-ord-produ.
DEF TEMP-TABLE tt-itens-excluir NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

def input param raw-param as raw no-undo.
def input param table     for tt-raw-digita.

/* Definiá‰es de Vari†veis p/ P†gina de ParÉmetros */
def var l-param    like param-global.exp-cep no-undo.                 
def var c-lb-tit   as char no-undo extent 2.
def var c-lb-est   as char no-undo extent 2.
def var c-lb-lin   as char no-undo extent 2.
def var c-lb-dest  as char no-undo.
def var c-lb-usuar as char no-undo.
def var c-compr    as char no-undo.
def var c-fabr     as char no-undo.
def var c-ord-pla  as char no-undo.
def var c-ord-com  as char no-undo.
def var c-ord-pro  as char no-undo.


def var c-res-com  as char no-undo.
def var c-res-pla  as char no-undo.
def var c-sld-est  as char no-undo.
def var c-sld-ter  as char no-undo.
def var c-remessa  as char no-undo.
def var c-entrada  as char no-undo.
def var c-transfer as char no-undo.
def var c-re-con   as char no-undo.
def var c-en-con   as char no-undo.
def var c-ped-crt  as char no-undo.
def var c-it-mov   as char no-undo.
def var c-comp     as char no-undo.

    def var c-cod-unid-negoc    like unid-negoc.cod-unid-negoc.

def var c-cred-apr  as char no-undo.
def var c-inf-dep   as char no-undo.
def var c-lb-obsol  as char no-undo.
def var c-lb-form   as char no-undo.
def var c-lb-nivel  as char no-undo.
def var c-lb-corte  as char no-undo.
def var c-lb-op     as char no-undo.
def var c-lb-benef  as char no-undo.
def var c-lb-sel    as char no-undo.
def var c-lb-cla    as char no-undo.
def var c-lb-par    as char no-undo.
def var c-lb-imp    as char no-undo.
def var c-lb-dig    as char no-undo.
def var c-lb-dep    as char no-undo.
def var c-lb-plano  as char no-undo.
def var l-ord-aber  as log  init no no-undo.
def var l-aprova-wf as log  init no no-undo.
DEF VAR i-cont      AS INT NO-UNDO.

DEFINE VARIABLE c-excel        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod  AS COM-HANDLE NO-UNDO.

DEFINE STREAM str-excel.


    if l-usa-unid-negoc then do:
        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    end.


/* Definicao de elementos referentes a UPC */
  /***************************************************************
**
** I-EPC200.I - Include de definiªío da temp-table padrío usada
**              para EPCs em Pontos Estrat≤gicos de programas
**          
** Par≥metros : 
** {1}  - nome do programa a ser localizado na tabela prog_dtsul     
***************************************************************/

/* definicao da temp-table */
/***************************************************************
**
** I-EPC200.I1 - Padroniza a temp-table usada para os epcs
**
***************************************************************/ 

/* begin_temp_table_definition */

define temp-table tt-epc no-undo
   field cod-event     as char format "x(12)"
   field cod-parameter as char format "x(32)"
   field val-parameter as char format "x(54)"
   index  id is primary cod-parameter cod-event ascending.    
   
/* end_temp_table_definition */   
    

  def var c-nom-prog-dpc-mg97  as char init "" no-undo.   
  def var c-nom-prog-appc-mg97 as char init "" no-undo.
  def var c-nom-prog-upc-mg97  as char init "" no-undo.
  def var raw-rowObject        as raw          no-undo.

   
find prog_dtsul where prog_dtsul.cod_prog_dtsul = "cd0420rp" no-lock no-error.
if  avail prog_dtsul then do:
    assign c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
           c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
           c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
end.          
/* i-epc200.i */
 

/* {cdp/cdcfgman.i} */
{utp/ut-glob.i}
{esp/es0018.i}
    /*******************************************************************
**
**  CD0666.I - Definicao temp-table de erros
**
*******************************************************************/
def new global shared var l-multi as logical initial yes.

def var l-del-erros as logical init YES NO-UNDO.
def var v-nom-arquivo-cb as char format "x(50)" no-undo.
def var c-mensagem-cb    as char format "x(132)" no-undo.

def  temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

form
    space(04)
    tt-erro.cd-erro 
    space (02)
    c-mensagem-cb
    with width 132 no-box down stream-io frame f-consiste.

run utp/ut-trfrrp.p (input frame f-consiste:handle).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Mensagem",
                    input "",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
assign tt-erro.cd-erro:label in frame f-consiste = trim(return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Descriá∆o",
                    input "",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-mensagem-cb:label in frame f-consiste = trim(return-value).
 
    /*****************************************************************************
**
**   cpapi020.i - Definiá∆o da tt-balanceia
**
******************************************************************************/

def temp-table tt-balanceia
    field nr-ord-produ          as int   /* Num. Ordem de Produá∆o                      */
    field it-codigo             as char  /* Cod. Item controlado por PPM / Concentraá∆o */
    field quant-requis          as dec   /* Quantidade no fator da reserva              */
    field quant-movto           as dec   /* Quantidade no fator do lote                 */
    field quant-veiculo         as dec   /* Quantidade requisitada para o veiculo       */
    FIELD de-perc-alteracao     AS DEC   /* Campo de uso interno na rotina de Manutená∆o da Alocaá∆o - cpapi013.i15 */
    field cod-versao-integracao as int
    index codigo nr-ord-produ it-codigo.

/*Implementado no projeto 346 - Controle de Potància
  O sistema passa a permitir mais de um ve°culo em uma mesma ordem. Essa temp-table ir† retornar a diferenáa que dever† ser acrescida
  a quantidade de cada ve°culo da ordem para que o mesmo fique balanceado, de acordo com o percentual de distribuiá∆o registrado na reserva*/
DEF TEMP-TABLE tt-veiculos NO-UNDO
    FIELD nr-ord-produ  AS INT                           /*Chave da Reserva*/
    FIELD item-pai      LIKE reservas.item-pai           /*Chave da Reserva*/
    FIELD cod-roteiro   LIKE reservas.cod-roteiro        /*Chave da Reserva*/
    FIELD op-codigo     LIKE reservas.op-codigo          /*Chave da Reserva*/
    FIELD it-codigo     LIKE reservas.it-codigo          /*Chave da Reserva*/
    FIELD cod-refer     LIKE reservas.cod-refer          /*Chave da Reserva*/
    FIELD perc-distrib  AS DEC DECIMALS 4                /*Percentual de Distribuiá∆o do ve°culo na reserva*/
    FIELD soma-perc     AS DEC DECIMALS 4                /*Soma dos percentuais dos ve°culos da ordem*/
    FIELD quant-veiculo LIKE tt-balanceia.quant-veiculo  /*Quantidade balanceada para o Ve°culo*/
    FIELD rw-reservas   AS ROWID                         /*Rowid da tabela Reservas*/
    INDEX id IS PRIMARY UNIQUE nr-ord-produ item-pai cod-roteiro op-codigo it-codigo cod-refer
    INDEX id-rowid rw-reservas.
 
    /*****************************************************************************
**
**   cpapi020.i1 - Definiá∆o das Funá‰es
**
******************************************************************************/

def var h-cpapi020 as handle no-undo.

function f-conv-un returns decimal
    (p-qtde       as dec,
     p-it-codigo  as char,
     p-it-veiculo as char,
     p-un-orig    as char,
     p-un-dest    as char) in h-cpapi020.

function f-retorna-fator returns decimal
    (p-it-codigo  as char,
     p-it-veiculo as char,
     p-un-orig    as char,
     p-un-dest    as char) in h-cpapi020.

function f-conv-qtde returns decimal
    (p-qtde       as dec,
     p-fator-orig as dec,
     p-fator-dest as dec) in h-cpapi020.

function f-conv-per-ppm returns decimal
    (p-valor as dec,
     p-acao  as int) in h-cpapi020.
 


/**************************************************************************
**
**  Include: CD0420.i11 - Define vari†veis, temp-tables e frames
**
**************************************************************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(30)"
    FIELD usuario          AS CHARACTER FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER 
    FIELD c-estab-ini      AS CHARACTER
    FIELD c-estab-fim      AS CHARACTER
    FIELD i-linha-ini      AS INTEGER
    FIELD i-linha-fim      AS INTEGER
    FIELD c-item-ini       AS CHARACTER
    FIELD c-item-fim       AS CHARACTER
    FIELD c-fami-ini       AS CHARACTER
    FIELD c-fami-fim       AS CHARACTER
    FIELD c-plan-ini       AS CHARACTER
    FIELD c-plan-fim       AS CHARACTER
    FIELD i-ge-ini         AS INTEGER
    FIELD i-ge-fim         AS INTEGER
    FIELD c-comp-ini       AS CHARACTER
    FIELD c-comp-fim       AS CHARACTER
    
        FIELD c-cod-unid-negoc-ini LIKE unid-negoc.cod-unid-negoc
        FIELD c-cod-unid-negoc-fim LIKE unid-negoc.cod-unid-negoc
    
    FIELD c-ci-estab-ini   AS CHARACTER
    FIELD c-ci-estab-fim   AS CHARACTER
    FIELD i-ci-linha-ini   AS INTEGER
    FIELD i-ci-linha-fim   AS INTEGER
    FIELD c-ci-item-ini    AS CHARACTER
    FIELD c-ci-item-fim    AS CHARACTER
    FIELD c-ci-fami-ini    AS CHARACTER
    FIELD c-ci-fami-fim    AS CHARACTER
    FIELD c-ci-plan-ini    AS CHARACTER
    FIELD c-ci-plan-fim    AS CHARACTER
    FIELD i-ci-ge-ini      AS INTEGER
    FIELD i-ci-ge-fim      AS INTEGER
    FIELD c-ci-comp-ini    AS CHARACTER
    FIELD c-ci-comp-fim    AS CHARACTER
    
        FIELD c-ci-cod-unid-negoc-ini LIKE unid-negoc.cod-unid-negoc
        FIELD c-ci-cod-unid-negoc-fim LIKE unid-negoc.cod-unid-negoc
    
    FIELD l-comprado       AS LOGICAL
    FIELD l-fabricado      AS LOGICAL
    FIELD da-corte         AS DATE
    FIELD da-op-corte      AS DATE
    FIELD l-planejada      AS LOGICAL
    FIELD l-ord-com        AS LOGICAL
    FIELD l-ord-prod       AS LOGICAL
    FIELD l-res-com        AS LOGICAL
    FIELD l-res-pla        AS LOGICAL
    FIELD l-sld-est        AS LOGICAL
    FIELD l-sld-ter        AS LOGICAL
    FIELD l-ped-crt        AS LOGICAL
    FIELD l-it-sem-mov     AS LOGICAL
    FIELD l-componente     AS LOGICAL
    FIELD l-deposito       AS LOGICAL
    FIELD i-niveis         AS INTEGER
    FIELD l-cred-aprov     AS LOGICAL
    FIELD l-comp-fabr      AS LOGICAL
    FIELD l-comp-comp      AS LOGICAL
    FIELD l-remessa        AS LOGICAL 
    FIELD l-entrada        AS LOGICAL
    FIELD l-transfer       AS LOGICAL 
    FIELD l-re-con         AS LOGICAL
    FIELD l-en-con         AS LOGICAL
    FIELD i-obsoleto       AS INTEGER
    FIELD i-beneficio      AS INTEGER
    FIELD i-tipo           AS INTEGER
    FIELD i-formato        AS INTEGER
    FIELD i-cod-plano      AS INTEGER
    FIELD c-obsoleto       AS CHARACTER
    FIELD c-beneficio      AS CHARACTER
    FIELD c-tipo           AS CHARACTER
    FIELD c-formato        AS CHARACTER
    FIELD c-classe         AS CHARACTER
    FIELD c-destino        AS CHARACTER
    FIELD l-impr-parametro AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD c-it-codigo    LIKE ITEM.it-codigo
    FIELD c-cod-refer    LIKE ref-item.cod-refer
    FIELD c-desc-item    LIKE ITEM.desc-item
    FIELD fm-codigo      LIKE ITEM.fm-codigo
    FIELD cd-planejado   LIKE ITEM.cd-planejado
    FIELD ge-codigo      LIKE ITEM.ge-codigo
    FIELD cod-comprado   LIKE ITEM.cod-comprado
    
        FIELD cod-unid-negoc LIKE unid-negoc.cod-unid-negoc
    
    FIELD c-un           LIKE ITEM.un
    FIELD l-dep          AS LOGICAL
    FIELD c-estab        AS CHARACTER
    FIELD c-depos        AS CHARACTER
    INDEX id IS PRIMARY  UNIQUE c-it-codigo c-cod-refer.

DEFINE TEMP-TABLE tt-depositos NO-UNDO
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD cod-depos      LIKE deposito.cod-depos.

DEFINE TEMP-TABLE tt-estoq NO-UNDO
    FIELD quantidade     AS DECIMAL   FORMAT "->>>>,>>9.9999"
    FIELD tempo          AS CHARACTER
    FIELD tipo           AS CHARACTER FORMAT "x(8)"
    FIELD referencia     AS CHARACTER FORMAT "x(30)"
    FIELD dt-inicio      AS DATE      FORMAT "99/99/9999"
    FIELD dt-termino     AS DATE      FORMAT "99/99/9999"
    FIELD item-pai       AS CHARACTER
    FIELD saldo          AS DECIMAL    
    
        FIELD unid-negoc     LIKE unid-negoc.cod-unid-negoc
    
    INDEX codigo         IS PRIMARY tempo dt-termino tipo.
    
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE ITEM.
    
DEFINE TEMP-TABLE tt-digita-2 NO-UNDO LIKE tt-digita
    FIELD niv-mais-bai   LIKE ITEM.niv-mais-bai
    INDEX niv  niv-mais-bai.

DEFINE BUFFER b-tt-estoq    FOR tt-estoq.
DEFINE BUFFER b-periodo     FOR periodo.
DEFINE BUFFER b-ped-item    FOR ped-item.
DEFINE BUFFER b-item        FOR ITEM.
DEFINE BUFFER b1-item       FOR ITEM.
DEFINE BUFFER b2-item       FOR ITEM.
DEFINE BUFFER b-ped-ent     FOR ped-ent.
DEFINE BUFFER b3-item       FOR ITEM.

DEFINE QUERY q-digita       FOR tt-digita-2 SCROLLING.

DEFINE VARIABLE de-saldo       LIKE reservas.quant-orig   NO-UNDO FORMAT "->>>>>,>>9.9999".
DEFINE VARIABLE de-quant-segur LIKE ITEM.quant-segur      NO-UNDO.
DEFINE VARIABLE c-descricao    LIKE ITEM.desc-item        NO-UNDO.
DEFINE VARIABLE c-fm-codigo    LIKE familia.fm-codigo     NO-UNDO.
DEFINE VARIABLE c-fm-desc      LIKE familia.descricao     NO-UNDO.
DEFINE VARIABLE c-planej       LIKE planejad.cd-planejado NO-UNDO.
DEFINE VARIABLE c-plan-desc    LIKE planejad.nome         NO-UNDO.
DEFINE VARIABLE c-grupo        LIKE ITEM.ge-codigo        NO-UNDO.
DEFINE VARIABLE c-comprado     LIKE ITEM.cod-comprado     NO-UNDO.

    DEFINE VARIABLE c-unid-negoc LIKE unid-negoc.cod-unid-negoc NO-UNDO.

DEFINE VARIABLE c-comp-desc        like comprador.nome no-undo.
DEFINE VARIABLE de-quantidade      as decimal no-undo format "->>>>,>>9.9999"  init 0.
DEFINE VARIABLE de-saldo-item      as decimal no-undo format "->>>>>,>>9.9999" init 0.
DEFINE VARIABLE de-saldo-aloc      as decimal no-undo format "->>>>>,>>9.9999" init 0.
DEFINE VARIABLE de-saldo-inic      as decimal no-undo format "->>>>,>>9.9999".
DEFINE VARIABLE de-saldo-terc      as decimal no-undo format "->>>>,>>9.9999".
DEFINE VARIABLE de-saldo-inic-teor as decimal no-undo format "->>>>,>>9.9999".
DEFINE VARIABLE de-saldo-terc-teor as decimal no-undo format "->>>>,>>9.9999".
DEFINE VARIABLE de-ped-saldo       as decimal no-undo.
DEFINE VARIABLE i-res-var          as integer no-undo.
DEFINE VARIABLE i-tam-per          as integer no-undo.
DEFINE VARIABLE i-nr-dias          as integer no-undo.
DEFINE VARIABLE i-ressup           as integer no-undo.
DEFINE VARIABLE i-resto            as integer no-undo.
DEFINE VARIABLE i-ind              as integer no-undo.
DEFINE VARIABLE i-nivel            as integer no-undo.
DEFINE VARIABLE i-sequencia        as integer no-undo.
DEFINE VARIABLE l-imprimiu         as logical no-undo init no.
DEFINE VARIABLE l-lista            as logical no-undo init no.
DEFINE VARIABLE l-zero             as logical no-undo init no.
DEFINE VARIABLE l-seg              as logical no-undo init no.
DEFINE VARIABLE l-res-estabel      as logical no-undo.
DEFINE VARIABLE r-end-ret          as rowid   no-undo extent 20.
DEFINE VARIABLE da-inicio          as date    no-undo format "99/99/9999".
DEFINE VARIABLE da-termino         as date    no-undo format "99/99/9999".
DEFINE VARIABLE da-data-aux        as date    no-undo format "99/99/9999".
DEFINE VARIABLE c-item             as char    no-undo format "x(12)" extent 20.
DEFINE VARIABLE c-referencia-1     as char    no-undo format "x(30)".
DEFINE VARIABLE c-referencia-2     as char    no-undo format "x(8)".
def var c-observ           as char    no-undo format "x(5)".
def var c-tempo            as char    no-undo.
def var c-tempo2           as char    no-undo.
def var c-tipo-ant         as char    no-undo.
def var c-estado           as char    no-undo.
def var c-cod-item         as char    no-undo.
def var c-un               as char    no-undo.
def var c-desc-cab         as char    no-undo.
def var h-acomp            as handle  no-undo.
def var i-nr-linha-ini     as int     no-undo.
def var i-nr-linha-fim     as int     no-undo.

def var c-un-neg-ini       as char    no-undo format "x(3)".
def var c-un-neg-fim       as char    no-undo format "x(3)".


def var c-liter        as char format "x(18)" extent 15 no-undo.

def var l-sald-est     as logical init yes no-undo.
def var l-remessa-con  as logical init yes no-undo.
def var l-ent-con      as logical init yes no-undo.
def var da-dt-corte    as date format "99/99/9999" init "12/31/9999". 
def var l-ord-comp     as logical init yes no-undo.
def var l-res-comp     as logical init yes no-undo.
def var l-pedidos      as logical init yes no-undo.
def var l-res-plan     as logical init yes no-undo.
def var da-dt-plan     as date format "99/99/9999" init "12/31/9999".
def var da-dat         as date format "99/99/9999" no-undo.
def var da-dat-in      as date format "99/99/9999" no-undo.
def var de-qt-min      as decimal no-undo.
def var de-qt-dlt      as decimal no-undo.
def var i-dias-dlt     as integer no-undo.
def var de-vezes       as decimal no-undo.
def var de-qt-seg      as decimal no-undo.
def var c-cod-refer    like ref-item.cod-refer     no-undo.
def var c-ref-pai      as char    no-undo.
def var c-ref-filho    as char    no-undo.
def var l-util-item    as logical no-undo.
def var l-controla-ref as logical no-undo.
def var l-ref          as logical no-undo.

/* Definiá∆o de Vari†veis p/ Traduá∆o */

def var c-lb-item   as char extent 2 no-undo.
def var c-lb-ref    as char no-undo format "x(8)".
def var c-lb-qt-seg as char no-undo format "x(10)".
def var c-lb-un     as char no-undo format "x(2)".
def var c-lb-desc   as char no-undo format "x(10)".
def var c-lb-sld    as char no-undo format "x(13)".
def var c-lb-s-teor as char no-undo format "x(13)".
def var c-lb-tipo   as char no-undo.
def var c-lb-refer  as char no-undo format "x(15)".
def var c-lb-qtde   as char no-undo format "x(10)".
def var c-lb-dat-i  as char no-undo format "x(10)".
def var c-lb-dat-f  as char no-undo format "x(10)".
def var c-lb-disp   as char no-undo format "x(10)".
def var c-lb-obs    as char no-undo format "x(10)".
def var c-lb-fam    as char no-undo format "x(10)" extent 2.
def var c-lb-plan   as char no-undo format "x(12)" extent 2.
def var c-lb-ge     as char no-undo format "x(15)" extent 2.
def var c-lb-comp   as char no-undo format "x(10)" extent 2.

def var c-lb-cod-unid-negoc as char no-undo format "x(15)" extent 2.
def var c-lb-un-negoc-abrev as char no-undo.

def var da-op-corte as date no-undo format "99/99/9999".

/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "ref-item":U, 
                    input "cod-refer":U, 
                    input integer("2":U)).

/* ut-field.i */
 
assign c-lb-ref = trim (return-value).
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "it-codigo":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-item = trim(return-value).
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "quant-segur":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-qt-seg = trim(return-value).
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "un":U, 
                    input integer("2":U)).

/* ut-field.i */
 
assign c-lb-un = trim(return-value).
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "desc-item":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-desc = trim(return-value).

IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldo_I.Inicial",
                    input "*",
                    input "l") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-sld = trim(return-value).
end.
else do:

    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldo_Inicial",
                    input "*",
                    input "l") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-sld = trim(return-value).

end.
IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldo_I.Te¢rico",
                    input "*",
                    input "l") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-s-teor = trim(return-value).
end.

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Tipo",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-tipo = trim(return-value).
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Referància",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-refer = trim(return-value).
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Quantidade",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-qtde = trim(return-value).
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Dt_In°cio",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-dat-i = trim(return-value).
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Dt_TÇrmino",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-dat-f = trim(return-value).

IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Dispon°vel_Te¢r",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-disp = trim(return-value).
end.
else do:

    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Dispon°vel",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-disp = trim(return-value).

end.

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Observaá∆o",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-lb-obs = trim(return-value).
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "familia":U, 
                    input "fm-codigo":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-fam = trim(return-value) /*+ ":"*/.
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "cd-planejado":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-plan = trim(return-value) /*+ ":"*/.
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "item":U, 
                    input "ge-codigo":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-ge = trim(return-value) /*+ ":"*/.
/*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "comprador":U, 
                    input "cod-comprado":U, 
                    input integer("1":U)).

/* ut-field.i */
 
assign c-lb-comp = trim(return-value) /*+ ":"*/.

    /*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "unid-negoc":U, 
                    input "cod-unid-negoc":U, 
                    input integer("1":U)).

/* ut-field.i */
 
    assign c-lb-cod-unid-negoc = trim(return-value).
    
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "U._Neg",
                    input "*",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-un-negoc-abrev = trim(return-value). /* Label abreviado da Unidade de Negocio */
    




    if l-usa-unid-negoc then do:
        form header
            c-lb-item[1]
            c-lb-qt-seg    to 33
            c-lb-un        at 37
            c-lb-ref       at 41
            c-lb-desc      at 50
            c-lb-s-teor    at 103
            c-lb-sld       to 132
            c-lb-tipo      at 6
            c-lb-refer     at 15
            c-lb-qtde      to 71        
            c-lb-dat-i     at 73
            c-lb-dat-f     at 84
            c-lb-disp      to 112
            c-lb-obs       at 114
            c-lb-un-negoc-abrev  at 125
            fill("-", 132) format "x(132)"
            with stream-io no-box no-label width 132 page-top frame f-cab-sml-un.
            run utp/ut-trfrrp.p (input frame f-cab-sml-un:handle).
    end.
    else do:

    form header
        c-lb-item[1]
        c-lb-qt-seg    to 33
        c-lb-un        at 37
        c-lb-ref       at 41
        c-lb-desc      at 50
        c-lb-s-teor    at 103
        c-lb-sld       to 132
        c-lb-tipo      at 6
        c-lb-refer     at 15
        c-lb-qtde      to 71        
        c-lb-dat-i     at 73
        c-lb-dat-f     at 84
        c-lb-disp      to 112
        c-lb-obs       at 114 
        fill("-", 132) format "x(132)"
        with stream-io no-box no-label width 132 page-top frame f-cab-sml.
        run utp/ut-trfrrp.p (input frame f-cab-sml:handle).


    end.


form header
     c-lb-fam[1]
     c-fm-codigo "-"
     c-fm-desc   skip(1)
     with stream-io no-box no-label width 132 page-top frame f-cab-fam.
run utp/ut-trfrrp.p (input frame f-cab-fam:handle).     

form header
     c-lb-item[1]  space(0) ":"
     c-cod-item format "x(16)" "-"
     c-desc-cab format "x(60)" "-"
     c-un       skip(1)
     with stream-io no-box no-label width 132 page-top frame f-cab-item.
run utp/ut-trfrrp.p (input frame f-cab-item:handle).     

form header
     c-lb-plan[1]
     c-planej    "-"
     c-plan-desc skip(1)
     with stream-io no-box no-label width 132 page-top frame f-cab-plan.
run utp/ut-trfrrp.p (input frame f-cab-plan:handle).     

form header
     c-lb-ge[1]
     c-grupo   "-"
     c-fm-desc skip(1)
     with stream-io no-box no-label width 132 page-top frame f-cab-ge.
run utp/ut-trfrrp.p (input frame f-cab-ge:handle).     

form header
     c-lb-comp[1]
     c-comprado  "-"
     c-comp-desc skip(1)
     with stream-io no-box no-label width 132 page-top frame f-cab-comp.
run utp/ut-trfrrp.p (input frame f-cab-comp:handle).     

form header
     c-lb-fam[1]
     c-fm-codigo "-"
     c-fm-desc
     c-lb-item[1]   space(0) ":"
     c-cod-item  "-"
     c-desc-cab  "-"
     c-un        skip(1)
     with stream-io no-box no-label width 132 page-top frame f-fam-estr.
run utp/ut-trfrrp.p (input frame f-fam-estr:handle).     

form header
     c-lb-plan[1]
     c-planej   "-"
     c-plan-desc
     c-lb-item[1]  space(0) ":"
     c-cod-item "-"
     c-desc-cab "-"
     c-un       skip(1)
     with stream-io no-box no-label width 132 page-top frame f-plan-estr.
run utp/ut-trfrrp.p (input frame f-plan-estr:handle).     

form header
     c-lb-comp[1]
     c-comprado "-"
     c-comp-desc
     c-lb-item[1]  space(0) ":"
     c-cod-item "-"
     c-desc-cab "-"
     c-un       skip(1)
     with stream-io no-box no-label width 132 page-top frame f-comp-estr.

RUN utp/ut-trfrrp.p (INPUT FRAME f-comp-estr:HANDLE).

/* Fim Include */
  /* Definiá∆o de Vari†veis */

def temp-table tt-dados-fda no-undo
    field i-seq              as integer
    field cod-estabel        like saldo-estoq.cod-estabel    /*obrigatorio*/
    field cod-depos          like saldo-estoq.cod-depos
    field cod-localiz        like saldo-estoq.cod-localiz
    field it-codigo          like saldo-estoq.it-codigo      /*obrigatorio*/
    field cod-refer          like saldo-estoq.cod-refer
    field fm-codigo          like familia.fm-codigo
    field nr-ultimo-lote     like saldo-estoq.lote           /*obrigat¢rio para parecer*/
    field dt-validade-ultimo like saldo-estoq.dt-vali-lote
    field nr-ord-produ       like ord-prod.nr-ord-produ
    field dt-fabric          like movto-estoq.dt-trans
    field cod-emitente       like emitente.cod-emitente
    field nat-operacao       like movto-estoq.nat-operacao
    field nro-docto          like movto-estoq.nro-docto
    field serie-docto        like movto-estoq.serie-docto
    field cod-unid-negoc     like movto-estoq.cod-unid-negoc
    field cod-modul-dtsul    like modul_dtsul.cod_modul_dtsul /*obrigatorio*/
    field cod-usuario        like usuar_mestre.cod_usuario
    field cod-grp-usuar      like usuar_grp_usuar.cod_grp_usuar
    field esp-docto          like movto-estoq.esp-docto
    field cd-estado-novo     as integer. /*obrigatorio para parecer*/

def temp-table tt-valores no-undo
    field i-seq   as integer
    field lote    like tt-dados-fda.nr-ultimo-lote
    field dt-val  like tt-dados-fda.dt-validade-ultimo
    field estado  like tt-dados-fda.cd-estado-novo.

def temp-table tt-valores2 no-undo
    field lote          like tt-dados-fda.nr-ultimo-lote
    field dt-val        like tt-dados-fda.dt-validade-ultimo
    field estado        like tt-dados-fda.cd-estado-novo
    field l-movto       as logical init no
    field l-saldo       as logical init no
    field log-aloca     as log
    field log-aloca-wms as log
    field r-rowid       as rowid
    field des-estado    like fda-lote-estado.des-estado .


PROCEDURE pi-simulacao-estoque:

   
/*****************************************************************************
**
**       CD0284.I (CP0509.I): Calculo de Simulacao de Estoque.
**
*****************************************************************************/
DEF PARAMETER BUFFER b-item FOR ITEM.
DEF INPUT PARAMETER l-sald-est AS LOG NO-UNDO.
DEF INPUT PARAMETER l-remessa AS LOG NO-UNDO.
DEF INPUT PARAMETER l-entrada AS LOG NO-UNDO.
DEF INPUT PARAMETER l-transfer AS LOG NO-UNDO.
DEF INPUT PARAMETER l-remessa-con AS LOG NO-UNDO.
DEF INPUT PARAMETER l-ent-con AS LOG NO-UNDO.
DEF INPUT PARAMETER c-plan-ini AS CHAR NO-UNDO.
DEF INPUT PARAMETER c-plan-fim AS CHAR NO-UNDO.   
DEF INPUT PARAMETER i-nr-linha-ini AS INT NO-UNDO.
DEF INPUT PARAMETER i-nr-linha-fim AS INT NO-UNDO.
DEF INPUT PARAMETER l-sald-terc AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER c-estab-ini AS CHAR NO-UNDO.
DEF INPUT PARAMETER c-estab-fim AS CHAR NO-UNDO.   
DEF INPUT PARAMETER l-ord-prod AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER i-benefic AS INT NO-UNDO.
DEF INPUT PARAMETER l-cred-aprov AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER l-planejada AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER l-res-plan AS LOGICAL NO-UNDO.
DEF INPUT PARAMETER i-cod-plano AS INT NO-UNDO.

DEF INPUT PARAMETER c-un-neg-ini AS CHAR NO-UNDO.
DEF INPUT PARAMETER c-un-neg-fim AS CHAR NO-UNDO.



DEFINE VARIABLE l-usa-unid-negoc AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-cdapi024       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-unid-retornada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-retornado      AS CHARACTER NO-UNDO.

    ASSIGN l-usa-unid-negoc = FALSE.

    IF CAN-FIND (FIRST funcao
                 WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                 AND   funcao.ativo     = TRUE) THEN DO:

        ASSIGN l-usa-unid-negoc = TRUE.

        RUN cdp~/cdapi024.p PERSISTENT SET h-cdapi024.
    END.


DEFINE VARIABLE de-quant    LIKE saldo-terc.quantidade          no-undo.
DEFINE VARIABLE de-aloc     as decimal format "->>>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-aloc-total as decimal format "->>>>>,>>9.9999" NO-UNDO.
define variable de-qtidade    like saldo-estoq.qtidade-atu        no-undo.
define variable l-aprova-wf as logical no-undo.


  def var l-lote-avancado as log    no-undo.
  def var h-ceapi030      as handle no-undo.
  def var l-retorno       as log    no-undo.

  if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                           funcao.ativo) then do:
      assign l-lote-avancado = yes.

      if not valid-handle(h-ceapi030) then
          run cep/ceapi030.p persistent set h-ceapi030(input table tt-dados-fda,
                                                       output table tt-valores,
                                                       output table tt-erro).
  end.


find first param-global no-lock no-error.

find first param-cp no-lock no-error.
/* Eliminacao tt-estoq */
for each tt-estoq:
    delete tt-estoq.
end.

assign de-saldo-inic      = 0
       de-saldo-terc      = 0
       de-saldo-inic-teor = 0
       de-saldo-terc-teor = 0
       de-aloc            = 0
           de-aloc-total      = 0.


    IF l-usa-unid-negoc THEN DO:
        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  b-item.cod-estabel,
                                                 INPUT  b-item.it-codigo,
                                                 INPUT  "",
                                                 OUTPUT c-unid-retornada).
        ASSIGN c-retornado = c-unid-retornada.
        IF c-retornado < c-un-neg-ini OR
           c-retornado > c-un-neg-fim THEN DO:
            RETURN "NOK":U.
        END.
    END.


if  da-op-corte = ? then
    assign da-op-corte = da-dt-corte.

/*---------------------------------------------------------------------------*/
if  param-global.modulo-ce then do:
    find first tt-depositos no-lock no-error.

    if  avail tt-depositos 
    and (l-sald-est or l-remessa     or l-entrada 
      or l-transfer or l-remessa-con or l-ent-con) then do:

        for each  saldo-estoq fields (it-codigo   cod-estabel   cod-depos   qtidade-atu
                                      qt-alocada  qt-aloc-prod  qt-aloc-ped per-ppm cod-refer lote)
            where saldo-estoq.it-codigo = b-item.it-codigo
              and saldo-estoq.cod-refer = c-cod-refer no-lock,
            first tt-depositos
                where tt-depositos.cod-estabel = saldo-estoq.cod-estabel
                  and tt-depositos.cod-depos   = saldo-estoq.cod-depos no-lock:

             if  l-sald-est then DO:
                 
         /*********** KSM 40404 ************/                                

                FIND FIRST para-ped NO-LOCK NO-ERROR.

                IF para-ped.tp-aloca-ped = 2 THEN DO:

                        FIND FIRST res-item WHERE res-item.it-codigo   = b-item.it-codigo
                                             AND  res-item.cod-refer   = c-cod-refer 
                                             AND  res-item.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                        IF AVAIL res-item THEN DO:
                            assign de-aloc = res-item.qt-alocada.
                        END.
                        ELSE
                            assign de-aloc = 0.

                END.
                ELSE 
                    ASSIGN de-aloc = 0.
                    
                assign de-aloc-total = de-aloc-total + de-aloc.

              
                assign l-retorno = yes.

                if l-lote-avancado and 
                   b-item.tipo-con-est > 2 then do:

                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
                    if return-value = "ok":u and
                       not l-retorno then
                        assign de-qtidade = 0.

                end.
                
                if l-retorno then
              

                assign de-qtidade = (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada -
                                     saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).

                if param-global.modulo-per-ppm and 
                   (b-item.tipo-formula = 2 or b-item.tipo-formula = 3) then
                   assign de-saldo-inic      = de-saldo-inic + de-qtidade
                          de-saldo-inic-teor = de-saldo-inic-teor + f-conv-qtde(de-qtidade,saldo-estoq.per-ppm,b-item.per-ppm).
                ELSE 
                    assign de-saldo-inic = de-saldo-inic + de-qtidade.
             END.
        end.

       assign de-saldo-inic = de-saldo-inic - de-aloc-total.

         /*********** KSM 40404 ************/
      
      if l-sald-terc then do:
        for each  saldo-terc fields (it-codigo     cod-estabel   cod-refer
                                     tipo-sal-terc quantidade    lote)
            where saldo-terc.it-codigo = b-item.it-codigo
              and saldo-terc.cod-refer = c-cod-refer no-lock,
            first tt-depositos
                where tt-depositos.cod-estabel = saldo-terc.cod-estabel no-lock:


            /* UPC - Regina Festas - In≠cio */ 
            IF PROGRAM-NAME(3) = "cdp/cd0420rp.p":U THEN DO:

                for each tt-epc exclusive-lock
                    where tt-epc.cod-event = "rg-desc-saldo-terc":U:
                    delete tt-epc.
                end.

                create tt-epc. 
                assign tt-epc.cod-event     = "rg-desc-saldo-terc":U
                       tt-epc.cod-parameter = "saldo-terc-rowid":U
                       tt-epc.val-parameter = string(ROWID(saldo-terc)). 

                /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integraÁ„o/
**              customizaÁ„o.
**
** {1}        - ind-event
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "rg-desc-saldo-terc", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "rg-desc-saldo-terc", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "rg-desc-saldo-terc", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

                IF RETURN-VALUE = "OK":U THEN DO:

                    FIND FIRST tt-epc
                        WHERE tt-epc.cod-event     = "rg-desc-saldo-terc":U
                        AND   tt-epc.cod-parameter = "considera-saldo":U NO-LOCK NO-ERROR.

                    IF AVAIL tt-epc AND tt-epc.val-parameter = "N":U THEN DO:
                        NEXT.
                    END.

                END.

            END.
            ELSE IF PROGRAM-NAME(1) = "pi-calc-sim-estoque inbrw/b47in172.w":U THEN DO:

                run pi-upc (input "RG-DESC-SALDO-TERC":U,
                            input "CONTAINER":U,
                            input ?,
                            input ?,
                            input "saldo-terc-rowid":U,
                            input ROWID(saldo-terc)).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    NEXT.
                END.

            END.
            /* UPC - Regina Festas - Fim */

          
            assign l-retorno = yes.

            if l-lote-avancado and 
               b-item.tipo-con-est > 2 then do:

                run pi-identifica-saldo in h-ceapi030 (input 1,
                                                       input saldo-terc.it-codigo,
                                                       input saldo-terc.cod-estabel,
                                                       input saldo-terc.lote,
                                                       input 0,
                                                       output l-retorno,
                                                       output table tt-valores2,
                                                       output table tt-erro).
                if return-value = "ok":u and 
                   not l-retorno then
                    assign de-quant = 0.
            end.
            
            if l-retorno then do:
          

            IF  param-global.modulo-per-ppm AND 
               (b-item.tipo-formula = 2 OR
                b-item.tipo-formula = 3) THEN DO:
                FOR FIRST saldo-estoq FIELDS (it-codigo cod-estabel cod-refer lote per-ppm)
                     WHERE saldo-estoq.it-codigo   = saldo-terc.it-codigo   AND
                           saldo-estoq.cod-estabel = saldo-terc.cod-estabel AND
                           saldo-estoq.cod-refer   = saldo-terc.cod-refer   AND
                           saldo-estoq.lote        = saldo-terc.lote NO-LOCK:
                    ASSIGN de-quant = f-conv-qtde(saldo-terc.quantidade,saldo-estoq.per-ppm,b-item.per-ppm).
                END.
            END.
            ELSE 
                ASSIGN de-quant = saldo-terc.quantidade.

            if (l-remessa and saldo-terc.tipo-sal-terc = 1) OR
               (l-transfer and saldo-terc.tipo-sal-terc = 3) OR
               (l-remessa-con and saldo-terc.tipo-sal-terc = 4) THEN DO:
                assign de-saldo-inic      = de-saldo-inic + saldo-terc.quantidade
                       de-saldo-terc      = de-saldo-terc + saldo-terc.quantidade
                       de-saldo-inic-teor = de-saldo-inic-teor + de-quant
                       de-saldo-terc-teor = de-saldo-terc-teor + de-quant.
            END.

            if (l-entrada and saldo-terc.tipo-sal-terc = 2) OR
               (l-ent-con and saldo-terc.tipo-sal-terc = 5) THEN 
                assign de-saldo-terc      = de-saldo-terc + saldo-terc.quantidade                    
                       de-saldo-terc-teor = de-saldo-terc-teor + de-quant.

          
            end.
          
        end.
      end.
    end.
    else 
        if  l-sald-est    
        or  l-remessa     
        or  l-entrada     
        or  l-transfer    
        or  l-remessa-con 
        or  l-ent-con then do:

          for each  saldo-estoq fields (it-codigo   cod-estabel   cod-depos   qtidade-atu lote
                                        qt-alocada  qt-aloc-prod  qt-aloc-ped cod-refer per-ppm)
              where saldo-estoq.it-codigo    = b-item.it-codigo
                and saldo-estoq.cod-refer    = c-cod-refer
                and saldo-estoq.cod-estabel >= c-estab-ini
                and saldo-estoq.cod-estabel <= c-estab-fim no-lock,
              each  deposito fields (cod-depos   cons-saldo)
                  where deposito.cod-depos = saldo-estoq.cod-depos
                    and deposito.cons-saldo no-lock:
              if l-sald-est then DO:

             /*********** KSM 40404 ************/                                

                  FIND FIRST para-ped NO-LOCK NO-ERROR.

                  IF para-ped.tp-aloca-ped = 2 THEN DO:

                        FIND FIRST res-item WHERE res-item.it-codigo   = b-item.it-codigo
                                             AND  res-item.cod-refer   = c-cod-refer
                                             AND  res-item.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                        IF AVAIL res-item THEN DO:
                            assign de-aloc = res-item.qt-alocada.
                        END.
                        ELSE
                            assign de-aloc = 0.

                  END.
                  ELSE 

                      ASSIGN de-aloc = 0.
                      
                  assign de-aloc-total = de-aloc-total + de-aloc.

              
                assign l-retorno = yes.

                if l-lote-avancado and 
                   b-item.tipo-con-est > 2 then do:

                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
                    if return-value = "ok":u and
                       not l-retorno then
                        assign de-qtidade = 0.

                end.
                
                if l-retorno then
              

                  assign de-qtidade = (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada -
                                       saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).

                  if param-global.modulo-per-ppm and 
                      (b-item.tipo-formula = 2 or b-item.tipo-formula = 3) then
                      assign de-saldo-inic      = de-saldo-inic + de-qtidade
                             de-saldo-inic-teor = de-saldo-inic-teor + f-conv-qtde(de-qtidade,saldo-estoq.per-ppm,b-item.per-ppm).
                  ELSE 
                      assign de-saldo-inic = de-saldo-inic + de-qtidade.
              END.
          END.
         assign de-saldo-inic = de-saldo-inic - de-aloc-total.

             /*********** KSM 40404 ************/  

          if l-sald-terc then do:
            for each  saldo-terc fields (it-codigo cod-estabel cod-refer
                                         tipo-sal-terc quantidade lote)
                where saldo-terc.it-codigo  = b-item.it-codigo
                  and saldo-terc.cod-refer  = c-cod-refer
                  and saldo-terc.cod-estabel >= c-estab-ini
                  and saldo-terc.cod-estabel <= c-estab-fim NO-LOCK,
                 each deposito where deposito.cod-depos = saldo-terc.cod-depos
                  and deposito.cons-saldo no-lock:

                /* UPC - Regina Festas - In≠cio */ 
                IF PROGRAM-NAME(3) = "cdp/cd0420rp.p":U THEN DO:

                    for each tt-epc exclusive-lock
                        where tt-epc.cod-event = "rg-desc-saldo-terc":U:
                        delete tt-epc.
                    end.

                    create tt-epc. 
                    assign tt-epc.cod-event     = "rg-desc-saldo-terc":U
                           tt-epc.cod-parameter = "saldo-terc-rowid":U
                           tt-epc.val-parameter = string(ROWID(saldo-terc)). 

                    /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integraÁ„o/
**              customizaÁ„o.
**
** {1}        - ind-event
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "rg-desc-saldo-terc", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "rg-desc-saldo-terc", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "rg-desc-saldo-terc", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

                    IF RETURN-VALUE = "OK":U THEN DO:

                        FIND FIRST tt-epc
                            WHERE tt-epc.cod-event     = "rg-desc-saldo-terc":U
                            AND   tt-epc.cod-parameter = "considera-saldo":U NO-LOCK NO-ERROR.

                        IF AVAIL tt-epc AND tt-epc.val-parameter = "N":U THEN DO:
                            NEXT.
                        END.

                    END.

                END.
                ELSE IF PROGRAM-NAME(1) = "pi-calc-sim-estoque inbrw/b47in172.w":U THEN DO:

                    run pi-upc (input "RG-DESC-SALDO-TERC":U,
                                input "CONTAINER":U,
                                input ?,
                                input ?,
                                input "saldo-terc-rowid":U,
                                input ROWID(saldo-terc)).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        NEXT.
                    END.
                END.
                /* UPC - Regina Festas - Fim */

              
                assign l-retorno = yes.

                if l-lote-avancado and 
                   b-item.tipo-con-est > 2 then do:

                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-terc.it-codigo,
                                                           input saldo-terc.cod-estabel,
                                                           input saldo-terc.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
                    if return-value = "ok":u and
                       not l-retorno then
                        assign de-quant = 0.

                end.
                
                if l-retorno then do:
              

                IF param-global.modulo-per-ppm AND 
                   (b-item.tipo-formula = 2 OR
                    b-item.tipo-formula = 3) THEN DO:
                    FOR FIRST saldo-estoq FIELDS (it-codigo cod-estabel cod-refer lote per-ppm)
                         WHERE saldo-estoq.it-codigo   = saldo-terc.it-codigo   AND
                               saldo-estoq.cod-estabel = saldo-terc.cod-estabel AND
                               saldo-estoq.cod-refer   = saldo-terc.cod-refer   AND
                               saldo-estoq.lote        = saldo-terc.lote NO-LOCK:
                        ASSIGN de-quant = f-conv-qtde(saldo-terc.quantidade,saldo-estoq.per-ppm,b-item.per-ppm).
                    END.
                END.
                ELSE 
                    ASSIGN de-quant = saldo-terc.quantidade.

                if (l-remessa and saldo-terc.tipo-sal-terc = 1) OR
                   (l-transfer and saldo-terc.tipo-sal-terc = 3) OR
                   (l-remessa-con and saldo-terc.tipo-sal-terc = 4) then DO:
                    assign de-saldo-inic      = de-saldo-inic + saldo-terc.quantidade
                           de-saldo-terc      = de-saldo-terc + saldo-terc.quantidade
                           de-saldo-inic-teor = de-saldo-inic-teor + de-quant 
                           de-saldo-terc-teor = de-saldo-terc-teor + de-quant.
                END.

                if (l-entrada and saldo-terc.tipo-sal-terc = 2) OR
                   (l-ent-con and saldo-terc.tipo-sal-terc = 5) THEN 
                    assign de-saldo-terc      = de-saldo-terc + saldo-terc.quantidade                    
                           de-saldo-terc-teor = de-saldo-terc-teor + de-quant.      
                    
              
                end.
              
            end.
          end.
        end.

        if c-estab-ini <> c-estab-fim THEN DO:
            FIND FIRST item-man WHERE
                       item-man.it-codigo = b-item.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item-man THEN
                assign de-quant-segur = if item-man.tipo-est-seg = 2 and not item-man.conv-tempo-seg 
                                        then 0
                                        ELSE ITEM-man.quant-segur.
        END.
            
            
        ELSE DO:                
            FOR FIRST item-uni-estab FIELDS (tipo-est-seg conv-tempo-seg quant-segur 
                                             qt-min-res-fabr var-tempo-res-fabr it-codigo 
                                             cod-estabel res-cq-fabr var-qtd-res-fabr tempo-segur)
                WHERE item-uni-estab.it-codigo = b-item.it-codigo   
                  AND item-uni-estab.cod-estabel = c-estab-ini NO-LOCK:
            END.
            IF AVAIL item-uni-estab THEN DO:
            assign de-quant-segur = if item-uni-estab.tipo-est-seg = 2 and not item-uni-estab.conv-tempo-seg 
                                    then 0
                                    else item-uni-estab.quant-segur.
            end.
        END.

/*     assign de-quant-segur = if b-item.tipo-est-seg = 2 and      */
/*                                not b-item.conv-tempo-seg then 0 */
/*                             else b-item.quant-segur.            */
end.

if  not(b-item.fraciona) 
and de-quant-segur <> integer(de-quant-segur) then
    assign de-quant-segur = truncate(de-quant-segur,0) + 1.
IF param-global.modulo-per-ppm THEN
    assign de-saldo = de-saldo-inic-teor.
ELSE
    assign de-saldo = de-saldo-inic.

/*---------------------------------------------------------------------------*/

if  param-global.modulo-cp 
and l-ord-prod then do:

    find first tt-depositos no-lock no-error.
    if  avail tt-depositos then do:

        for each ord-prod fields (it-codigo dt-inicio    dt-termino  cod-estabel  cod-depos
                                  qt-ordem  qt-produzida estado      nr-ord-produ nr-pedido 
                                  cod-refer lote-serie   cod-unid-negoc)
            where ord-prod.it-codigo   = b-item.it-codigo
            and   ord-prod.cod-refer   = c-cod-refer
            and   ord-prod.dt-termino <= da-dt-corte
            and   ord-prod.estado     <  7 no-lock,
            first tt-depositos where
                  tt-depositos.cod-estabel = ord-prod.cod-estabel and
                  tt-depositos.cod-depos   = ord-prod.cod-depos   no-lock:

            assign de-saldo = ord-prod.qt-ordem - ord-prod.qt-produzida.
            if  de-saldo <= 0 then 
                next.

            create tt-estoq.
            assign tt-estoq.tipo = c-liter[1]
                   tt-estoq.referencia = trim(string(ord-prod.nr-ord-produ,"999,999,999")) + " " + 
                                         trim(substring(/**************************************************************************
** i01in271.i  - campo: estado   ( tabela: ord-prod )
**************************************************************************/

 






/***************************************************************************
**  ind01-10.i - define as funcoes de um indicador
**  Para indicadores de 1 a 10 items
**
**  Funcoes disponiveis
**  01: view-as Combo-box
**  02: view-as radio-set
**  03: lista com os itens separados por virgula
**  04 n: retorna o item n da lista
**  05: retorna o numero de items da lista
**  06: retorna a posicao do item (numero)
**  07: valores para a propriedade Radio-Buttons de um Radio-Set
***************************************************************************/

/* verifica parametros ****************************************************/




/* &if lookup("{1}", "01,02,03,04,05,06,07") = 0 &then
    &message *** ({&file-name}): Parametro incorreto: {1} !
    &message *** Deveria ser: 01, 02, 03, 04, 05, 06, 07 
&endif  */
    

  


/* monta lista de items para LISTA (03), NUM (04), ITEM(05), IND(06) ************************/

          
               
     
               
     
               
     
               
     
               
     
               
     
               
     
     


/* funcao Combo-box (01) *************************************************************/


/* funcao Radio-set (02) *************************************************************/


/* funcao Lista (03) **********************************************************/


/* funcao NUM (05) ************************************************************/


/* funcao Item n (04) *********************************************************/    


     entry(ord-prod.estado, "N∆o Iniciada,Liberada,Reservada,Separada,Requisitada,Iniciada,Finalizada,Terminada")



/* funcao IND string (06) ****************************************************/



/* valores para a propriedade Radio-Buttons de um Radio-Set *******************/




    

    

    

    

    

    

    

    

    



/* fim */
 
/* Fim */

 ,1,1)) +
                                         if  ord-prod.nr-pedido <> "" 
                                         then " - " + ord-prod.nr-pedido
                                         else ""
                   tt-estoq.quantidade = de-saldo
                   tt-estoq.dt-inicio  = ord-prod.dt-inicio
                   tt-estoq.dt-termino = ord-prod.dt-termino
                   
                   tt-estoq.unid-negoc = ord-prod.cod-unid-negoc
                   
                   .
        end.
    end.
    else do:
        for each  ord-prod fields (it-codigo  dt-inicio    dt-termino   cod-estabel   cod-depos
                                   qt-ordem   qt-produzida estado       nr-ord-produ
                                   nr-pedido  cod-refer    lote-serie   cod-unid-negoc)
            where ord-prod.it-codigo    = b-item.it-codigo
              and ord-prod.cod-refer    = c-cod-refer
              and ord-prod.dt-termino  <= da-dt-corte
              and ord-prod.cod-estabel >= c-estab-ini
              and ord-prod.cod-estabel <= c-estab-fim
              and ord-prod.estado      <  7 NO-LOCK:

        
            FIND FIRST deposito
                WHERE deposito.cod-depos = ord-prod.cod-depos
                AND   deposito.log-ordens-mrp  NO-LOCK NO-ERROR.
        
        
            IF NOT AVAIL deposito THEN NEXT.

            assign de-saldo = ord-prod.qt-ordem - ord-prod.qt-produzida.

            if  de-saldo <= 0 then 
                next.

            create tt-estoq.
            assign tt-estoq.tipo = c-liter[1]
                   tt-estoq.referencia = trim(string(ord-prod.nr-ord-produ,"999,999,999")) + " " + 
                                         trim(substring(/**************************************************************************
** i01in271.i  - campo: estado   ( tabela: ord-prod )
**************************************************************************/

 






/***************************************************************************
**  ind01-10.i - define as funcoes de um indicador
**  Para indicadores de 1 a 10 items
**
**  Funcoes disponiveis
**  01: view-as Combo-box
**  02: view-as radio-set
**  03: lista com os itens separados por virgula
**  04 n: retorna o item n da lista
**  05: retorna o numero de items da lista
**  06: retorna a posicao do item (numero)
**  07: valores para a propriedade Radio-Buttons de um Radio-Set
***************************************************************************/

/* verifica parametros ****************************************************/




/* &if lookup("{1}", "01,02,03,04,05,06,07") = 0 &then
    &message *** ({&file-name}): Parametro incorreto: {1} !
    &message *** Deveria ser: 01, 02, 03, 04, 05, 06, 07 
&endif  */
    

  


/* monta lista de items para LISTA (03), NUM (04), ITEM(05), IND(06) ************************/

          
               
     
               
     
               
     
               
     
               
     
               
     
               
     
     


/* funcao Combo-box (01) *************************************************************/


/* funcao Radio-set (02) *************************************************************/


/* funcao Lista (03) **********************************************************/


/* funcao NUM (05) ************************************************************/


/* funcao Item n (04) *********************************************************/    


     entry(ord-prod.estado, "N∆o Iniciada,Liberada,Reservada,Separada,Requisitada,Iniciada,Finalizada,Terminada")



/* funcao IND string (06) ****************************************************/



/* valores para a propriedade Radio-Buttons de um Radio-Set *******************/




    

    

    

    

    

    

    

    

    



/* fim */
 
/* Fim */

 ,1,1)) +
                                         if  ord-prod.nr-pedido <> ""
                                         then " - " + ord-prod.nr-pedido
                                         else ""
                   tt-estoq.quantidade = de-saldo
                   tt-estoq.dt-inicio  = ord-prod.dt-inicio
                   tt-estoq.dt-termino = ord-prod.dt-termino
                   
                   tt-estoq.unid-negoc = ord-prod.cod-unid-negoc
                   
                   .
        end.
    end.
end.

/*---------------------------------------------------------------------------*/

if  param-global.modulo-cc then do:
    find first tt-depositos no-lock no-error.

    if  avail tt-depositos 
    and l-ord-comp then do:
        for each prazo-compra fields (it-codigo     situacao    data-entrega   quant-saldo  
                                      numero-ordem  parcela     pedido-clien   cod-refer)
            where prazo-compra.it-codigo     = b-item.it-codigo
              and prazo-compra.cod-refer     = c-cod-refer
              and prazo-compra.situacao     <> 4 
              and prazo-compra.situacao     <> 6
              and prazo-compra.data-entrega <= da-dt-corte no-lock:

            if  prazo-compra.quant-saldo <= 0 then 
                next.

            for each  ordem-compra fields (it-codigo  numero-ordem  cod-emitente  situacao   cod-estabel   
                                           cod-refer  dep-almoxar   natureza      num-pedido ordem-servic  cod-unid-negoc)  
                where ordem-compra.numero-ordem = prazo-compra.numero-ordem 
                  and ordem-compra.situacao <> 4 no-lock,
                first tt-depositos
                     where tt-depositos.cod-estabel = ordem-compra.cod-estabel
                     and   tt-depositos.cod-depos   = ordem-compra.dep-almoxar no-lock:

                if  ordem-compra.natureza = 3 
                and i-benefic             = 2 then 
                    next.

                find emitente 
                    where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.

                create tt-estoq.
                assign tt-estoq.tipo = if  ordem-compra.natureza = 3
                                       and i-benefic = 3 then c-liter[2]
                                                         else c-liter[3]
                       tt-estoq.referencia = trim(string(prazo-compra.numero-ordem,"zzzzz9,99"))  + "/" +
                                             string(prazo-compra.parcela) + "/" +
                                            (if  not avail emitente then " " 
                                                                    else trim(string(emitente.nome-abrev,"x(12)"))) + "/" +
                                             trim(string(ordem-compra.num-pedido,"zzzz9,999")) + 
                                            (if  prazo-compra.pedido-clien <> ""
                                             then " - " + prazo-compra.pedido-clien
                                             else if  ordem-compra.natureza      = 3
                                                  and ordem-compra.ordem-servic <> 0 
                                                  then " - " + c-liter[4] + trim(string(ordem-compra.ordem-servic,"zzz,zz9,999"))
                                                  else "")
                       tt-estoq.dt-inicio  = ?
                       tt-estoq.dt-termino = prazo-compra.data-entrega
                       
                       tt-estoq.unid-negoc = ordem-compra.cod-unid-negoc
                       
                       .
                
                assign tt-estoq.quantidade = prazo-compra.quant-saldo.

            end.
        end.
    end.
    else if l-ord-comp then do:
        for each prazo-compra fields (it-codigo    situacao   data-entrega   quant-saldo
                                      numero-ordem parcela    pedido-clien   cod-refer)
            where prazo-compra.it-codigo     = b-item.it-codigo
              and prazo-compra.cod-refer     = c-cod-refer
              and prazo-compra.situacao     <> 4 
              and prazo-compra.situacao     <> 6
              and prazo-compra.data-entrega <= da-dt-corte no-lock,
            first ordem-compra fields (it-codigo  numero-ordem  cod-emitente  situacao   cod-estabel 
                                       cod-refer  dep-almoxar   natureza      num-pedido ordem-servic  cod-unid-negoc)
                where ordem-compra.numero-ordem = prazo-compra.numero-ordem
                  and ordem-compra.cod-estabel >= c-estab-ini
                  and ordem-compra.cod-estabel <= c-estab-fim no-lock,

      
            first deposito fields (cod-depos  log-ordens-mrp) 
                where deposito.cod-depos = ordem-compra.dep-almoxar
                and   deposito.log-ordens-mrp no-lock:
      

            if  prazo-compra.quant-saldo <= 0 then next.
            if  ordem-compra.situacao = 4     then next.
            if  ordem-compra.natureza = 3 
            and i-benefic             = 2     then next.

            find emitente 
                where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.

            create tt-estoq.
            assign tt-estoq.tipo = if  ordem-compra.natureza = 3
                                   and i-benefic = 3 then c-liter[2]
                                                     else c-liter[3]
                   tt-estoq.referencia = trim(string(prazo-compra.numero-ordem,"zzzzz9,99")) + "/" +
                                         string(prazo-compra.parcela) + "/" +
                                        (if  not avail emitente then " " 
                                                                else trim(string(emitente.nome-abrev,"x(12)"))) + "/" +
                                         trim(string(ordem-compra.num-pedido,"zzzz9,999")) + 
                                         if  prazo-compra.pedido-clien <> ""
                                         then " - " + prazo-compra.pedido-clien
                                         else if  ordem-compra.natureza = 3
                                              and ordem-compra.ordem-servic <> 0
                                              then " - " + c-liter[4] + trim(string(ordem-compra.ordem-servic,"zzz,zz9,999"))
                                              else ""
                   tt-estoq.dt-inicio  = ?
                   tt-estoq.dt-termino = prazo-compra.data-entrega
                   
                   tt-estoq.unid-negoc = ordem-compra.cod-unid-negoc
                   
                   .

            assign tt-estoq.quantidade = prazo-compra.quant-saldo.
        end.
    end.
end.
/*---------------------------------------------------------------------------*/

if  param-global.modulo-cp and l-res-comp then do:
    find first tt-depositos no-lock no-error.
    if  avail tt-depositos then
        for each  reservas fields (it-codigo   dt-reserva   estado    quant-aloc
                                   quant-atend quant-orig   cod-depos nr-ord-produ
                                   cod-refer qt-aloc-lote qt-atend-lote) 
            where reservas.it-codigo   = b-item.it-codigo
              and reservas.cod-refer   = c-cod-refer
              and reservas.dt-reserva <= da-dt-corte
              and reservas.estado      = 1 no-lock:
            
            assign de-saldo = reservas.quant-orig - reservas.quant-aloc - reservas.quant-atend.

            if reservas.quant-orig = 0 then next.
            if reservas.quant-orig < 0 and de-saldo >= 0 then next.
            if reservas.quant-orig > 0 and de-saldo <= 0 then next.

            for first ord-prod fields (it-codigo  dt-termino    cod-estabel  cod-depos
                                       qt-ordem   qt-produzida  estado       nr-ord-produ
                                       nr-pedido  cod-refer     lote-serie   cod-unid-negoc)
                where reservas.nr-ord-produ = ord-prod.nr-ord-produ
                  and ord-prod.estado < 7 no-lock: end.
            if  not avail ord-prod then 
                next.

            find first tt-depositos
                 where tt-depositos.cod-estabel = ord-prod.cod-estabel
                   and tt-depositos.cod-depos   = reservas.cod-depos
                 no-lock no-error.
            if  not avail tt-depositos then 
                next.

            create tt-estoq.
            assign tt-estoq.tipo = c-liter[5]
                   tt-estoq.referencia = string(reservas.nr-ord-produ, "999,999,999") + " - " + 
                                         ord-prod.it-codigo
                   tt-estoq.quantidade = de-saldo
                   tt-estoq.dt-inicio  = ?
                   tt-estoq.dt-termino = reservas.dt-reserva
                   
                   tt-estoq.unid-negoc = ord-prod.cod-unid-negoc
                   
                   .
        end.
    else 
        for each  reservas fields (it-codigo   dt-reserva   estado    quant-aloc
                                   quant-atend quant-orig   cod-depos nr-ord-produ
                                   cod-refer qt-aloc-lote qt-atend-lote)
            where reservas.it-codigo   = b-item.it-codigo
              and reservas.cod-refer   = c-cod-refer
              and reservas.dt-reserva <= da-dt-corte
              and reservas.estado      = 1 no-lock,
            first deposito fields (cod-depos   cons-saldo)
                where deposito.cod-depos = reservas.cod-depos
                  and deposito.cons-saldo no-lock:

            assign de-saldo = reservas.quant-orig - reservas.quant-aloc - reservas.quant-atend.

            if reservas.quant-orig = 0 then next.
            if reservas.quant-orig < 0 and de-saldo >= 0 then next.
            if reservas.quant-orig > 0 and de-saldo <= 0 then next.

            for first ord-prod fields (it-codigo  dt-termino    cod-estabel  cod-depos
                                       qt-ordem   qt-produzida  estado       nr-ord-produ
                                       nr-pedido  cod-refer     lote-serie   cod-unid-negoc)
                where ord-prod.nr-ord-produ = reservas.nr-ord-produ
                  and ord-prod.cod-estabel   >= c-estab-ini
                  and ord-prod.cod-estabel   <= c-estab-fim
                  and ord-prod.estado < 7 no-lock:

                create tt-estoq.
                assign tt-estoq.tipo = c-liter[5]
                       tt-estoq.referencia = string(reservas.nr-ord-produ, "999,999,999") 
                                           + " - " + ord-prod.it-codigo
                       tt-estoq.quantidade = de-saldo
                       tt-estoq.dt-inicio  = ?
                       tt-estoq.dt-termino = reservas.dt-reserva
                       
                       tt-estoq.unid-negoc = ord-prod.cod-unid-negoc
                       
                       .
            end.
        end.
end.
/*----------------------------------------------------------------------------*/

if  param-global.modulo-pd and l-pedidos and b-item.baixa-estoq then 
    for  each ped-ent fields (it-codigo   dt-entrega   cd-sit-prog   cod-sit-ent
                              nome-abrev  nr-pedcli    nr-sequencia  cod-refer
                              qt-pedida   qt-atendida  qt-alocada    qt-log-aloc
                              char-2      qtd-aloc-op  qtd-reporta-op-ped)
    where ped-ent.it-codigo = b-item.it-codigo
      and ped-ent.cod-refer = c-cod-refer
      and ped-ent.dt-entrega <= da-dt-corte
      and (ped-ent.qt-log-aloca = 0
       or (ped-ent.qt-pedida - ped-ent.qt-log-aloca) > 0)
      and ped-ent.cd-sit-prog = 2
      and (ped-ent.cod-sit-ent = 1 
       or ped-ent.cod-sit-ent = 2
       or ped-ent.cod-sit-ent = 4) no-lock,
        first ped-item fields (nome-abrev   nr-pedcli    nr-sequencia   it-codigo
                               cod-refer    nat-operacao ind-componen
                               cod-sit-item it-codigo ind-componen)
            where ped-item.nome-abrev   = ped-ent.nome-abrev
              and ped-item.nr-pedcli    = ped-ent.nr-pedcli
              and ped-item.nr-sequencia = ped-ent.nr-sequencia
              and ped-item.it-codigo    = ped-ent.it-codigo
              and ped-item.cod-refer    = ped-ent.cod-refer no-lock:

        

        find first para-ped no-lock no-error.
        
        assign l-aprova-wf = para-ped.log-usa-aprovac-workflow.

        for first natur-oper fields (nat-operacao   baixa-estoq ind-entfu)
            where natur-oper.nat-operacao = ped-item.nat-operacao no-lock: end.

        if (avail natur-oper and not natur-oper.baixa-estoq
                             and not natur-oper.ind-entfu) then
            next.

        if  ped-item.ind-componen = 3 then do:
            find first b-ped-item
                where b-ped-item.nome-abrev   = ped-item.nome-abrev
                  and b-ped-item.nr-pedcli    = ped-item.nr-pedcli
                  and b-ped-item.nr-sequencia = ped-item.nr-sequencia
                  and b-ped-item.ind-componen = 2 no-lock no-error.
            find b3-item where b3-item.it-codigo = b-ped-item.it-codigo no-lock no-error.
            if  not avail b-ped-item or not avail b3-item or b3-item.baixa-estoq then
                next.
        end.  

        if  c-estab-ini = ""  and c-estab-fim = "ZZZ" then do:

            if  not l-cred-aprov then 
                for first ped-venda fields (nome-abrev   nr-pedcli 
                                            cod-sit-aval cod-estabel)
                    where ped-venda.nome-abrev = ped-item.nome-abrev
                      and ped-venda.nr-pedcli  = ped-item.nr-pedcli
                      AND ped-venda.completo
                      AND NOT ped-venda.log-cotacao  no-lock: end.
            else
               if l-aprova-wf then do: /* Desconsidera pedido que n∆o est† aprovado no workflow de desconto */
                  for first ped-venda fields (nome-abrev   nr-pedcli 
                                              cod-sit-aval cod-estabel
                                              log-aprov-workflow)
                      where ped-venda.nome-abrev   = ped-item.nome-abrev
                        and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                        AND ped-venda.completo
                        and ped-venda.cod-sit-aval > 1 
                        and ped-venda.cod-sit-aval < 4
                        AND NOT ped-venda.log-cotacao
                        AND ped-venda.log-aprov-workflow no-lock: end.
               END.
               ELSE DO:
                  for first ped-venda fields (nome-abrev   nr-pedcli 
                                             cod-sit-aval cod-estabel)
                     where ped-venda.nome-abrev   = ped-item.nome-abrev
                       and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                       AND ped-venda.completo
                       and ped-venda.cod-sit-aval > 1 
                       and ped-venda.cod-sit-aval < 4
                       AND NOT ped-venda.log-cotacao  no-lock: end.

               END.

        end.
        else 
            if  not l-cred-aprov then            
                for first ped-venda fields (nome-abrev   nr-pedcli 
                                            cod-sit-aval cod-estabel)
                    where ped-venda.nome-abrev = ped-item.nome-abrev
                      and ped-venda.nr-pedcli  = ped-item.nr-pedcli
                      AND ped-venda.completo
                      and ped-venda.cod-estabel >= c-estab-ini
                      and ped-venda.cod-estabel <= c-estab-fim
                      AND NOT ped-venda.log-cotacao  no-lock: end.
            ELSE
               if l-aprova-wf THEN DO: /* Desconsidera pedido que n∆o est† aprovado no workflow de desconto */
              
                  for first ped-venda fields (nome-abrev   nr-pedcli 
                                              cod-sit-aval cod-estabel
                                              log-aprov-workflow)
                      where ped-venda.nome-abrev = ped-item.nome-abrev
                        and ped-venda.nr-pedcli  = ped-item.nr-pedcli
                        AND ped-venda.completo
                        and ped-venda.cod-estabel >= c-estab-ini
                        and ped-venda.cod-estabel <= c-estab-fim 
                        and ped-venda.cod-sit-aval > 1 
                        and ped-venda.cod-sit-aval < 4
                        AND NOT ped-venda.log-cotacao 
                        AND ped-venda.log-aprov-workflow no-lock: end.
                END.
                ELSE
                  for first ped-venda fields (nome-abrev   nr-pedcli 
                                             cod-sit-aval cod-estabel)
                     where ped-venda.nome-abrev = ped-item.nome-abrev
                       and ped-venda.nr-pedcli  = ped-item.nr-pedcli
                       AND ped-venda.completo
                       and ped-venda.cod-estabel >= c-estab-ini
                       and ped-venda.cod-estabel <= c-estab-fim 
                       and ped-venda.cod-sit-aval > 1 
                       and ped-venda.cod-sit-aval < 4
                       AND NOT ped-venda.log-cotacao no-lock: end.

        if  avail ped-venda then do:
            if  avail tt-depositos then do:
                find first tt-depositos 
                     where tt-depositos.cod-estabel = ped-venda.cod-estabel no-lock no-error.
                if not avail tt-depositos then next.
            end.

            if ped-item.ind-componen = 2 then do:              
               /*------------------------------------------------------------*
                * Procura um pedido de Produto Configurado                   *
                *         A                                                  *
                *     +---+---+   onde A eh ind-componen 1 (Configurado)     *
                *     B       C        B e C ind-conponen 2 (Comp.do Config) *
                * Neste caso,se A nao baixa estoque, deve considerar o pedido*
                * de B ou C.                                                 *
                *------------------------------------------------------------*/

                for first b-ped-item fields (nome-abrev   nr-pedcli   nr-sequencia
                                             ind-componen it-codigo)
                    where b-ped-item.nome-abrev   = ped-item.nome-abrev
                      and b-ped-item.nr-pedcli    = ped-item.nr-pedcli
                      and b-ped-item.nr-sequencia = ped-item.nr-sequencia
                      and b-ped-item.ind-componen = 1 no-lock: end.
                if avail b-ped-item then 
                   for first b1-item fields (it-codigo   baixa-estoq)
                       where b1-item.it-codigo = b-ped-item.it-codigo no-lock: end.
                /*-----------------------------------------------------* 
                 * Se nao encontrou ped-item com ind-componen 1,
                 * ou nao achou o item do b-ped-item, ou o item localizado
                 * baixa estoque, entao nao considera o ped b-item.
                 *-----------------------------------------------------*/
                 if not avail b-ped-item
                 or not avail b1-item 
                 or b1-item.baixa-estoq then 
                    next.
            end.

           assign de-saldo-item = 
                  if (ped-ent.qt-pedida - ped-ent.qt-atendida ) > 0 
                      then  (ped-ent.qt-pedida - ped-ent.qt-atendida )
                  else 0
                  de-saldo-aloc = 
                  if (ped-ent.qt-alocada - ped-ent.qt-atendida)  > 0
                      then (ped-ent.qt-alocada - ped-ent.qt-atendida)
                  else 0.        
                  de-ped-saldo  =  (de-saldo-item - de-saldo-aloc).
                  IF ((ped-ent.qt-pedida - ped-ent.qt-log-aloc) >= 0) THEN
                   ASSIGN de-ped-saldo = de-ped-saldo - ped-ent.qt-log-aloc.

                 /* Alocacao de OP no Embarque (FT3000) - ksm41636 - GL - FO 1899.998*/
                  IF (( ped-ent.qtd-aloc-op - ped-ent.qtd-reporta-op-ped) > 0) THEN

                   ASSIGN de-ped-saldo = de-ped-saldo + 
                                         ped-ent.qtd-aloc-op -  /* quantidade alocada na producao */
                                         ped-ent.qtd-reporta-op-ped. /* quantidade reportada */
                 /* - FIM - Alocaªío de Orden de Produªío no Embarque - FIM - */


           if  de-ped-saldo <> 0 then do:
               create tt-estoq.
               assign tt-estoq.tipo  = c-liter[6]
                      tt-estoq.referencia =
                          trim(string(ped-ent.nome-abrev,"x(12)")) +
                                            "/"               +
                          string(ped-ent.nr-pedcli,"x(12)") + 
                      (if ped-item.cod-sit-item = 4 then
                          "*"
                       else "")
                      tt-estoq.quantidade = de-ped-saldo
                      tt-estoq.dt-inicio  = ?
                      tt-estoq.dt-termino = ped-ent.dt-entrega
                      
                      tt-estoq.unid-negoc = c-unid-retornada
                      
                      .
           end.
        end.
    end.


/*----------------------------------------------------------------------------*/

if  l-planejada or  l-res-plan then
    for first pl-prod  fields (cd-plano pl-estado cd-tipo tp-seg-comp tp-seg-fabr 
                               log-multi-estabel  num-calc-plano) 
        where pl-prod.cd-plano = i-cod-plano no-lock:
        /*cd0501.i.  */

find tipo-per where tipo-per.cd-tipo = pl-prod.cd-tipo no-lock no-error.
if available tipo-per then do:
    if  tipo-per.nr-dia = 0 then do:
        if  tipo-per.tipo = 3 then    
            assign i-tam-per = 7.
        else if  tipo-per.tipo = 2 then   
                 assign i-tam-per = 15.
             else if  tipo-per.tipo = 1 then         
                      assign i-tam-per = 30.
    end.
    else
        assign i-tam-per = tipo-per.nr-dia.
end.
 

        for first pl-it-calc fields (it-codigo  cd-plano nr-dias-desl   res-cq-fabri
                                     tempo-segur ressup-fabri   char-1)
            where pl-it-calc.cd-plano  = pl-prod.cd-plano and
                  pl-it-calc.it-codigo = b-item.it-codigo no-lock:

            find item where item.it-codigo = pl-it-calc.it-codigo no-lock no-error.

            if pl-prod.log-multi-estabel  then do:
               for each  estabelec 
                   where estabelec.cod-estabel >= c-estab-ini 
                   and   estabelec.cod-estabel <= c-estab-fim no-lock:

                   /*** C¢digo Duplicado - estabel ****/

                   for each it-periodo
                       where it-periodo.num-calc-plano = pl-prod.num-calc-plano                
                       and   it-periodo.cod-estabel    = estabelec.cod-estabel
                       and   it-periodo.it-codigo      = pl-it-calc.it-codigo
                       and   it-periodo.cod-refer      = c-cod-refer
                       and ((it-periodo.qt-ord-plan    > 0 and l-planejada)
                       or  ((it-periodo.qt-res-plan - it-periodo.qt-pedidos > 0)
                       and l-res-plan)) no-lock:


                       FIND first periodo where
                           periodo.nr-periodo = it-periodo.periodo and
                           periodo.ano        = it-periodo.ano     and
                           periodo.cd-tipo    = pl-prod.cd-tipo NO-LOCK NO-ERROR.
                       IF AVAIL periodo THEN DO:
                           if periodo.dt-inicio <= da-dt-plan then do:
                              if b-item.compr-fabr = 1 then do:
                                 /********************************************************************************
*
* cd0901.i4 Include para calculo da data de termino e inicio da ordem de compra
*
*********************************************************************************/


   assign da-termino = periodo.dt-termino.
   if i-tam-per > 1 THEN do:
        find prev periodo where
                  periodo.cd-tipo    = pl-prod.cd-tipo no-lock no-error.
        if avail periodo then 
           assign da-termino = periodo.dt-termino
                  da-inicio  = periodo.dt-termino.
   end.
   
   assign da-termino = if  item.tipo-est-seg = 2 /* (no) tempo */
                       and item.conv-tempo-seg = no /* converte tempo seguranáa */
                       and pl-prod.tp-seg-comp
                           then da-termino - item.res-cq-comp
                                - item.tempo-segur
                       else da-termino - item.res-cq-comp.
   
   if i-tam-per = 1 then do:
       find first calen-prod where
           calen-prod.cod-estabel = param-cp.cod-estabel and
           calen-prod.data        = da-termino no-lock no-error.
       do  while true:
           if  avail calen-prod
               and calen-prod.tipo-dia = 1 then do:
               assign da-termino = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                   where calen-prod.cod-estabel = param-cp.cod-estabel
                     and calen-prod.data        < da-termino
                     and calen-prod.tipo-dia    = 1
                        no-lock no-error.                                       
               if   not avail calen-prod then do:
                   find first calen-prod where 
                              calen-prod.cod-estabel = param-cp.cod-estabel and
                              calen-prod.data       >= da-termino          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                   if  avail calen-prod then
                       assign da-termino = calen-prod.data.
                   leave. 
               end.
           end.
       end.
   end.
                       
   assign  da-inicio = if item.tipo-est-seg =  2 /* (no) tempo */
                      and item.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then da-termino - item.res-int-comp
                              - item.res-for-comp
                      else da-termino - item.res-int-comp
                           - item.res-for-comp.
                           
   if da-inicio > da-termino then do:
       find last periodo where
           periodo.cd-tipo    = pl-prod.cd-tipo and
           periodo.dt-termino <= da-termino no-lock no-error.
           
       assign  da-inicio = if item.tipo-est-seg =  2 /* (no) tempo */
                      and item.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then periodo.dt-termino - item.res-int-comp
                              - item.res-for-comp
                      else periodo.dt-termino - item.res-int-comp
                           - item.res-for-comp.
   end.


     
   if i-tam-per > 1 then do:
       FIND FIRST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                            AND periodo.dt-termino >= da-termino NO-LOCK NO-ERROR.  
       ASSIGN da-termino = periodo.dt-termino.
       FIND LAST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                           AND periodo.dt-inicio <= da-inicio NO-LOCK NO-ERROR.    
       ASSIGN da-inicio = periodo.dt-inicio.
   end.
   
   assign da-data-aux = da-termino.
   if i-tam-per = 1 then do:
       find first calen-prod where
               calen-prod.cod-estabel = param-cp.cod-estabel and
               calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-termino = da-data-aux.
   
   assign da-data-aux = da-inicio.
   if i-tam-per = 1 then do:
       find first calen-prod where
                  calen-prod.cod-estabel = param-cp.cod-estabel and
                  calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                               calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-inicio = da-data-aux.
   



/* fim da include */

  /*calcula da-inicio da-termino - compras*/
                                 assign da-dat    = da-termino
                                        da-dat-in = da-inicio.
                                 IF i-tam-per = 1 THEN DO:
                                     for first calen-prod fields (cod-estabel   data   tipo-dia)
                                         where calen-prod.cod-estabel = param-cp.cod-estabel
                                         and   calen-prod.data        = da-dat no-lock: end.
    
                                     if avail calen-prod then
                                     repeat:
                                        if calen-prod.tipo-dia = 1 then
                                           leave.
                                        else do:
                                            assign da-inicio = da-inicio - 1
                                                   da-dat    = da-dat - 1.
                                            for first calen-prod fields (cod-estabel   data   tipo-dia)
                                                where calen-prod.cod-estabel = param-cp.cod-estabel 
                                                and   calen-prod.data        = da-dat no-lock: end.
                                        end.
                                     end.
                                     assign da-termino = da-dat.
                                 END.
                              end.
                              else do:
                                      RUN pi-cd0901(INPUT 1). /* 1 - item */
/*                                      {cdp/cd0901.i5 item} */
                              end.

                              if it-periodo.qt-ord-plan > 0 and
                                 da-termino <= da-op-corte  and
                                 l-planejada then do:
                                 create tt-estoq.
                                 assign tt-estoq.tipo = c-liter[7]
                                        tt-estoq.referencia = ""
                                        tt-estoq.dt-inicio  = da-inicio
                                        tt-estoq.dt-termino = da-termino
                                        
                                        tt-estoq.unid-negoc = c-unid-retornada
                                        
                                        .

                                  assign tt-estoq.quantidade = it-periodo.qt-ord-plan.


                              end.
                              if (it-periodo.qt-res-plan - it-periodo.qt-pedidos) > 0 and
                                  periodo.dt-inicio <= da-op-corte and
                                  l-res-plan then do:
                                  assign de-qt-seg = 0.           

                                 /*----------------------------------------------------------*
                                  * tipo-res => 1 -> plano producao/previsao vendas          *
                                  *             2 -> interna                                 *
                                  *             3 -> pedido                                  *
                                  *             4 -> planejada                               *
                                  *             ? -> reserva interna reprogramada por O.P de *
                                  *                  nivel superior                          *
                                  *----------------------------------------------------------*/

                                 for each  res-aber fields (it-codigo   cod-refer   ano   periodo
                                           nr-pedcli   nome-abrev  quantidade item-pai
                                           num-id-it-periodo  cod-estabel)
                                     where res-aber.num-id-it-periodo = it-periodo.num-id-it-periodo 
                                     and res-aber.it-codigo  = it-periodo.it-codigo
                                     and res-aber.cod-refer  = it-periodo.cod-refer
                                     and res-aber.ano        = it-periodo.ano       
                                     and res-aber.periodo    = it-periodo.periodo   
                                     AND res-aber.cod-estabel = estabelec.cod-estabel
                                     and (res-aber.tipo-res   = 4 or
                                          res-aber.tipo-res   = 7) no-lock:

                                     create tt-estoq.
                                     assign tt-estoq.tipo = c-liter[8]
                                            tt-estoq.referencia = res-aber.item-pai
                                            tt-estoq.dt-inicio  = ?
                                            tt-estoq.dt-termino = periodo.dt-inicio
                                            
                                            tt-estoq.unid-negoc = c-unid-retornada
                                            
                                            tt-estoq.item-pai   = res-aber.item-pai. 

                                     assign tt-estoq.quantidade = res-aber.quantidade.
                                 end.
                              end.
                           end.
                       end.   
                   end.
                  /**** FIM ****/ 
               end.
            end.

            else do:
               /*** C¢digo duplicado - estabel ***/

               for each it-periodo
                   where it-periodo.num-calc-plano = pl-prod.num-calc-plano                
                   and   it-periodo.cod-estabel    = " "
                   and   it-periodo.it-codigo    = pl-it-calc.it-codigo
                   and   it-periodo.cod-refer    = c-cod-refer
                   and ((it-periodo.qt-ord-plan > 0 and l-planejada)
                   or  ((it-periodo.qt-res-plan - it-periodo.qt-pedidos > 0)
                   and l-res-plan)) no-lock:


                   FIND first periodo where
                       periodo.nr-periodo = it-periodo.periodo and
                       periodo.ano        = it-periodo.ano     and
                       periodo.cd-tipo    = pl-prod.cd-tipo NO-LOCK NO-ERROR.
                   IF AVAIL periodo THEN DO:
                           for first item-uni-estab 
                               where item-uni-estab.it-codigo = b-item.it-codigo
                               and item-uni-estab.cod-estabel = b-item.cod-estabel no-lock: 
                           end.

                       if periodo.dt-inicio <= da-dt-plan then do:
                          if b-item.compr-fabr = 1 then do:
                            if avail item-uni-estab then do:
                               /********************************************************************************
*
* cd0901.i4 Include para calculo da data de termino e inicio da ordem de compra
*
*********************************************************************************/


   assign da-termino = periodo.dt-termino.
   if i-tam-per > 1 THEN do:
        find prev periodo where
                  periodo.cd-tipo    = pl-prod.cd-tipo no-lock no-error.
        if avail periodo then 
           assign da-termino = periodo.dt-termino
                  da-inicio  = periodo.dt-termino.
   end.
   
   assign da-termino = if  item-uni-estab.tipo-est-seg = 2 /* (no) tempo */
                       and item-uni-estab.conv-tempo-seg = no /* converte tempo seguranáa */
                       and pl-prod.tp-seg-comp
                           then da-termino - item-uni-estab.res-cq-comp
                                - item-uni-estab.tempo-segur
                       else da-termino - item-uni-estab.res-cq-comp.
   
   if i-tam-per = 1 then do:
       find first calen-prod where
           calen-prod.cod-estabel = param-cp.cod-estabel and
           calen-prod.data        = da-termino no-lock no-error.
       do  while true:
           if  avail calen-prod
               and calen-prod.tipo-dia = 1 then do:
               assign da-termino = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                   where calen-prod.cod-estabel = param-cp.cod-estabel
                     and calen-prod.data        < da-termino
                     and calen-prod.tipo-dia    = 1
                        no-lock no-error.                                       
               if   not avail calen-prod then do:
                   find first calen-prod where 
                              calen-prod.cod-estabel = param-cp.cod-estabel and
                              calen-prod.data       >= da-termino          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                   if  avail calen-prod then
                       assign da-termino = calen-prod.data.
                   leave. 
               end.
           end.
       end.
   end.
                       
   assign  da-inicio = if item-uni-estab.tipo-est-seg =  2 /* (no) tempo */
                      and item-uni-estab.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then da-termino - item-uni-estab.res-int-comp
                              - item-uni-estab.res-for-comp
                      else da-termino - item-uni-estab.res-int-comp
                           - item-uni-estab.res-for-comp.
                           
   if da-inicio > da-termino then do:
       find last periodo where
           periodo.cd-tipo    = pl-prod.cd-tipo and
           periodo.dt-termino <= da-termino no-lock no-error.
           
       assign  da-inicio = if item-uni-estab.tipo-est-seg =  2 /* (no) tempo */
                      and item-uni-estab.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then periodo.dt-termino - item-uni-estab.res-int-comp
                              - item-uni-estab.res-for-comp
                      else periodo.dt-termino - item-uni-estab.res-int-comp
                           - item-uni-estab.res-for-comp.
   end.


     
   if i-tam-per > 1 then do:
       FIND FIRST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                            AND periodo.dt-termino >= da-termino NO-LOCK NO-ERROR.  
       ASSIGN da-termino = periodo.dt-termino.
       FIND LAST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                           AND periodo.dt-inicio <= da-inicio NO-LOCK NO-ERROR.    
       ASSIGN da-inicio = periodo.dt-inicio.
   end.
   
   assign da-data-aux = da-termino.
   if i-tam-per = 1 then do:
       find first calen-prod where
               calen-prod.cod-estabel = param-cp.cod-estabel and
               calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-termino = da-data-aux.
   
   assign da-data-aux = da-inicio.
   if i-tam-per = 1 then do:
       find first calen-prod where
                  calen-prod.cod-estabel = param-cp.cod-estabel and
                  calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                               calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-inicio = da-data-aux.
   



/* fim da include */

  /*calcula da-inicio da-termino - compras*/
                            end.
                            else do:
                               /********************************************************************************
*
* cd0901.i4 Include para calculo da data de termino e inicio da ordem de compra
*
*********************************************************************************/


   assign da-termino = periodo.dt-termino.
   if i-tam-per > 1 THEN do:
        find prev periodo where
                  periodo.cd-tipo    = pl-prod.cd-tipo no-lock no-error.
        if avail periodo then 
           assign da-termino = periodo.dt-termino
                  da-inicio  = periodo.dt-termino.
   end.
   
   assign da-termino = if  item.tipo-est-seg = 2 /* (no) tempo */
                       and item.conv-tempo-seg = no /* converte tempo seguranáa */
                       and pl-prod.tp-seg-comp
                           then da-termino - item.res-cq-comp
                                - item.tempo-segur
                       else da-termino - item.res-cq-comp.
   
   if i-tam-per = 1 then do:
       find first calen-prod where
           calen-prod.cod-estabel = param-cp.cod-estabel and
           calen-prod.data        = da-termino no-lock no-error.
       do  while true:
           if  avail calen-prod
               and calen-prod.tipo-dia = 1 then do:
               assign da-termino = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                   where calen-prod.cod-estabel = param-cp.cod-estabel
                     and calen-prod.data        < da-termino
                     and calen-prod.tipo-dia    = 1
                        no-lock no-error.                                       
               if   not avail calen-prod then do:
                   find first calen-prod where 
                              calen-prod.cod-estabel = param-cp.cod-estabel and
                              calen-prod.data       >= da-termino          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                   if  avail calen-prod then
                       assign da-termino = calen-prod.data.
                   leave. 
               end.
           end.
       end.
   end.
                       
   assign  da-inicio = if item.tipo-est-seg =  2 /* (no) tempo */
                      and item.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then da-termino - item.res-int-comp
                              - item.res-for-comp
                      else da-termino - item.res-int-comp
                           - item.res-for-comp.
                           
   if da-inicio > da-termino then do:
       find last periodo where
           periodo.cd-tipo    = pl-prod.cd-tipo and
           periodo.dt-termino <= da-termino no-lock no-error.
           
       assign  da-inicio = if item.tipo-est-seg =  2 /* (no) tempo */
                      and item.conv-tempo-seg = no  /* converte tempo seguranáa */
                      and pl-prod.tp-seg-comp
                         then periodo.dt-termino - item.res-int-comp
                              - item.res-for-comp
                      else periodo.dt-termino - item.res-int-comp
                           - item.res-for-comp.
   end.


     
   if i-tam-per > 1 then do:
       FIND FIRST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                            AND periodo.dt-termino >= da-termino NO-LOCK NO-ERROR.  
       ASSIGN da-termino = periodo.dt-termino.
       FIND LAST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                           AND periodo.dt-inicio <= da-inicio NO-LOCK NO-ERROR.    
       ASSIGN da-inicio = periodo.dt-inicio.
   end.
   
   assign da-data-aux = da-termino.
   if i-tam-per = 1 then do:
       find first calen-prod where
               calen-prod.cod-estabel = param-cp.cod-estabel and
               calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                              calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-termino = da-data-aux.
   
   assign da-data-aux = da-inicio.
   if i-tam-per = 1 then do:
       find first calen-prod where
                  calen-prod.cod-estabel = param-cp.cod-estabel and
                  calen-prod.data        = da-data-aux no-lock no-error.
       do  while true:
           if  avail calen-prod
           and calen-prod.tipo-dia = 1 then do:
               assign da-data-aux = calen-prod.data.
               leave.
           end. 
           else do:
               find prev calen-prod 
                    where calen-prod.cod-estabel = param-cp.cod-estabel
                      and calen-prod.data        < da-data-aux
                      and calen-prod.tipo-dia    = 1
                         no-lock no-error.                                       
               if   not avail calen-prod then do:
                    find first calen-prod where 
                               calen-prod.cod-estabel = param-cp.cod-estabel and
                               calen-prod.data       >= da-data-aux          and
                               calen-prod.tipo-dia    = 1 no-lock no-error.
                    if  avail calen-prod then
                        assign da-data-aux = calen-prod.data.
                    leave. 
               end.
           end.
       end.
   end.
   assign da-inicio = da-data-aux.
   



/* fim da include */

  /*calcula da-inicio da-termino - compras*/
                            end.
                             assign da-dat    = da-termino
                                    da-dat-in = da-inicio.
                            IF i-tam-per = 1 THEN DO:
                                for first calen-prod fields (cod-estabel   data   tipo-dia)
                                    where calen-prod.cod-estabel = param-cp.cod-estabel
                                    and   calen-prod.data        = da-dat no-lock: end.
                                if avail calen-prod then
                                    repeat:
                                       if calen-prod.tipo-dia = 1 then
                                          leave.
                                       else do:
                                          assign da-inicio = da-inicio - 1
                                                 da-dat    = da-dat - 1.
                                          for first calen-prod fields (cod-estabel   data   tipo-dia)
                                              where calen-prod.cod-estabel = param-cp.cod-estabel 
                                              and   calen-prod.data        = da-dat no-lock: end.
                                       end.
                                    end.
                                assign da-termino = da-dat.
                            END.
                          end.
                          else do:
                              if avail item-uni-estab then do:                                             
                                  RUN pi-cd0901(INPUT 2). /* 2 - item-uni-estab */
/*                                  {cdp/cd0901.i5 item-uni-estab} /*calcula da-inicio da-termino - compras*/ */
                              end.                                                                         
                              else do:                                                                     
                                  RUN pi-cd0901(INPUT 2). /* 2 - item-uni-estab */
/*                                 {cdp/cd0901.i5 item} /*calcula da-inicio da-termino - compras*/ */
                              end.                                                                         
                          end.

                          if it-periodo.qt-ord-plan > 0 and
                             da-termino <= da-op-corte and
                             l-planejada then do:
                             create tt-estoq.
                             assign tt-estoq.tipo = c-liter[7]
                                    tt-estoq.referencia = ""
                                    tt-estoq.dt-inicio  = da-inicio
                                    tt-estoq.dt-termino = da-termino
                                    
                                    tt-estoq.unid-negoc = c-unid-retornada
                                    
                                    .

                             assign tt-estoq.quantidade = it-periodo.qt-ord-plan.

                          end.

                          if (it-periodo.qt-res-plan - it-periodo.qt-pedidos) > 0 and
                              periodo.dt-inicio <= da-op-corte and
                              l-res-plan then do:
                              assign de-qt-seg = 0.           

                             /*----------------------------------------------------------*
                              * tipo-res => 1 -> plano producao/previsao vendas          *
                              *             2 -> interna                                 *
                              *             3 -> pedido                                  *
                              *             4 -> planejada                               *
                              *             ? -> reserva interna reprogramada por O.P de *
                              *                  nivel superior                          *
                              *----------------------------------------------------------*/

                             for each  res-aber fields (it-codigo   cod-refer   ano   periodo
                                       nr-pedcli   nome-abrev  quantidade item-pai
                                       num-id-it-periodo cod-estabel)
                                 where res-aber.num-id-it-periodo = it-periodo.num-id-it-periodo 
                                 and res-aber.it-codigo  = it-periodo.it-codigo
                                 and res-aber.cod-refer  = it-periodo.cod-refer
                                 and res-aber.ano        = it-periodo.ano       
                                 and res-aber.periodo    = it-periodo.periodo   
                                 and (res-aber.tipo-res   = 4 or
                                      res-aber.tipo-res   = 7) no-lock:

                                 create tt-estoq.
                                 assign tt-estoq.tipo = c-liter[8]
                                        tt-estoq.referencia = res-aber.item-pai
                                        tt-estoq.dt-inicio  = ?
                                        tt-estoq.dt-termino = periodo.dt-inicio
                                        
                                        tt-estoq.unid-negoc = c-unid-retornada
                                        
                                        tt-estoq.item-pai   = res-aber.item-pai. 

                                 assign tt-estoq.quantidade = res-aber.quantidade.
                             end.
                          end.
                       end. 
                   end.   
               end.

               /*** FIM ***/  
            end.     


        end.
    end.

    
        IF VALID-HANDLE(h-cdapi024) THEN DO:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        END.
    
    
    
        if valid-handle(h-ceapi030) then
            delete procedure h-ceapi030.
    

/*-------------------------------------------------------------------------*/
END PROCEDURE.

PROCEDURE pi-cd0901.
    /******************************************************************************
    ** CD0901.i5 - Include para calculo da data de termino e inicio da
    **             ordem de producao
    ** comum aos prgs: PL0603.p  pl0604a.p pl0604b.p pl0604c.p plpl0704b.p pl0704b.i
    **                 pl0704g.i  pl0901a.p pl0901.i1 pl0901.i3
    ******************************************************************************/
    DEF INPUT PARAMETER i-estab AS INT NO-UNDO.

    /************************** data de termino ****************************/
        

        assign i-nr-dias = if pl-it-calc.nr-dias-desl <> 999
                                                  then pl-it-calc.nr-dias-desl
                                           else 0.

        IF i-estab = 1 THEN DO:
           if item.compr-fabr = 2 then
                   ASSIGN i-ressup = if ITEM.tipo-est-seg = 2   /* tempo */
                                                         and ITEM.conv-tempo-seg = no /* converte tempo seguranáa */
                                                         and pl-prod.tp-seg-fabr
                                                         then if substring(program-name(1),1,3) = "plp"
                                                                         then ITEM.res-cq-fabr
                                                                                  + ITEM.tempo-segur
                                                                                  - i-nr-dias
                                                                         else ITEM.res-cq-fabr
                                                                                  + ITEM.tempo-segur
                                                                                  - i-nr-dias
                                                         else if substring(program-name(1),1,3) = "plp"
                                                                         then ITEM.res-cq-fabr - i-nr-dias
                                                                         else ITEM.res-cq-fabr - i-nr-dias.
           else 
                   assign i-ressup = 0.

    END.
    ELSE DO:
                if item.compr-fabr = 2 then
                        ASSIGN i-ressup = if ITEM-uni-estab.tipo-est-seg = 2   /* tempo */
                                                          and ITEM-uni-estab.conv-tempo-seg = no /* converte tempo seguranáa */
                                                          and pl-prod.tp-seg-fabr
                                                          then if substring(program-name(1),1,3) = "plp"
                                                                          then ITEM-uni-estab.res-cq-fabr
                                                                                   + ITEM-uni-estab.tempo-segur
                                                                                   - i-nr-dias
                                                                          else ITEM-uni-estab.res-cq-fabr
                                                                                   + ITEM-uni-estab.tempo-segur
                                                                                   - i-nr-dias
                                                   else if substring(program-name(1),1,3) = "plp"
                                                                   then ITEM-uni-estab.res-cq-fabr - i-nr-dias
                                                                   else ITEM-uni-estab.res-cq-fabr - i-nr-dias.
                else
                        assign i-ressup = 0.

    END.


        

        find b-periodo where recid(b-periodo) = recid(periodo) no-lock no-error.

        IF i-tam-per > 1 THEN DO:
                find prev b-periodo use-index codigo
                        where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
                ASSIGN da-termino = b-periodo.dt-termino
                           da-termino-f = da-termino.
                IF i-ressup > 0 THEN DO:
                        IF i-ressup > i-tam-per THEN
                                ASSIGN da-termino = da-termino-f - i-ressup.
                        ELSE
                                ASSIGN da-termino = da-termino-f - i-tam-per.
                        /*Marcos - Se houver ressuprimento e buscar o registro do ultimo periodo*/
                        FIND FIRST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                                                                AND periodo.dt-termino > da-termino NO-LOCK NO-ERROR.  
                        ASSIGN da-termino = periodo.dt-termino.
                        find b-periodo
                          where b-periodo.cd-tipo = pl-prod.cd-tipo
                          and   b-periodo.dt-termino = da-termino no-lock no-error.
                END.
        END.

        if i-tam-per = 1 then
                do  i-ind = 1 to i-ressup:
                        find prev b-periodo use-index codigo
                                where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
                end.

        if  not avail b-periodo then
                find first b-periodo use-index codigo
                         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
        assign da-termino = b-periodo.dt-termino.


        /************************ data de inicio ****************************/

        
                assign de-qt-min = dec(substring(item.char-1,20,12))
                           de-qt-dlt = dec(substring(item.char-1,35,12))
                           i-dias-dlt = int(substring(item.char-1,15,4)).
                           
                IF i-estab = 1 THEN DO:
                        if not avail item-uni-estab then
                                        find first item-uni-estab where
                                                        item-uni-estab.it-codigo   = item.it-codigo and
                                                        item-uni-estab.cod-estabel = it-periodo.cod-estabel no-lock no-error.
                        if avail item-uni-estab then                
                                        assign de-qt-min  = item-uni-estab.qt-min-res-fabr
                                                   i-dias-dlt = item-uni-estab.var-tempo-res-fabr
                                                   de-qt-dlt  = item-uni-estab.var-qtd-res-fabr.
                end.
                
                if it-periodo.qt-ord-plan > de-qt-min then
                   assign de-vezes = (it-periodo.qt-ord-plan - de-qt-min) / de-qt-dlt
                                  de-vezes = (if de-vezes = ? then
                                                                 0
                                                          else
                                                                 de-vezes)
                                  de-vezes = (if trunc(de-vezes,0) = de-vezes then
                                                                 de-vezes
                                                          else
                                                                 trunc(de-vezes,0) + 1)
                                  i-res-var = (de-vezes * i-dias-dlt).             

                if item.compr-fabr = 2 then
                        assign i-ressup = if item.tipo-est-seg = 2     /* tempo */
                                                          and item.conv-tempo-seg = no /* converte tempo seguranáa */
                                                          and pl-prod.tp-seg-fabr
                                                          then if substring(program-name(1),1,3) = "plp"
                                                                          then item.res-cq-fabri + item.tempo-segur - i-nr-dias
                                                                          else item.res-cq-fabri + item.tempo-segur - i-nr-dias
                                                          else if substring(program-name(1),1,3) = "plp"
                                                                   then item.res-cq-fabri - i-nr-dias
                                                                   else item.res-cq-fabri - i-nr-dias.
                else
                        assign i-ressup = 0.

        

        IF i-tam-per > 1 THEN DO:
                ASSIGN i-ressup = i-ressup + i-res-var + item.ressup-fabri.
                IF i-ressup > i-tam-per THEN
                        ASSIGN da-termino-f = da-termino-f - i-ressup.
                ELSE
                        ASSIGN da-termino-f = da-termino-f - i-tam-per.
                FIND LAST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                                                   AND periodo.dt-termino <= da-termino-f NO-LOCK NO-ERROR.  
                ASSIGN da-termino-f = periodo.dt-termino.
                /*Marcos - Se houver ressuprimento e buscar o registro do ultimo periodo*/
                FIND FIRST periodo WHERE periodo.cd-tipo   = pl-prod.cd-tipo
                                                        AND periodo.dt-termino > da-termino-f NO-LOCK NO-ERROR.  
                ASSIGN da-termino-f = periodo.dt-termino.
                find b-periodo
                  where b-periodo.cd-tipo = pl-prod.cd-tipo
                  and   b-periodo.dt-termino = da-termino-f no-lock no-error.
        END.
        else
           find b-periodo where recid(b-periodo) = recid(periodo) no-lock no-error.

        if i-tam-per = 1 then do:
                assign i-ressup = i-ressup + i-res-var + item.ressup-fabri.
                do  i-ind = 1 to i-ressup:
                        find prev b-periodo use-index codigo
                                 where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
                end.
        end.
        if  not avail b-periodo then
                find first b-periodo use-index codigo
                         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock.
        assign da-inicio = b-periodo.dt-inicio.

        /* fim do include */

    
END PROCEDURE.
    /* pi-simulaá∆o-estoque */
/******************************************************************************
**
**  Include: CD0420.i - C†lculo de Simulaá∆o de Estoque
**
*****************************************************************************/

procedure pi-simulacao.

    def param buffer b-item for item.
    def input parameter l-item-pai as logical no-undo.
    
        def input parameter l-usa-unid-negoc as logical no-undo.
    
    def var c-saldo as char format "x(5)" no-undo.
    def var l-sald-terc as logical init yes no-undo.
    DEFINE VARIABLE de-saldo-aux AS DECIMAL     NO-UNDO.
    /*** Esta include no ems 2.01 n∆o dever† possuir nenhum c¢digo, serve 
     apenas para desenvolvimento tratar o conceito de miniflexibilizaá∆o.
     Utilizado apenas para MANUFATURA. ***/

/*** RELEASE 2.02 ***/
/* Funá‰es ch∆o f†brica e lista de componentes 2.02 - Logoplaste - Manufatura */
/*** RELEASE 2.03 ***/
/* Integraá∆o Magnus x SFC 2.03 - Klimmek - Manufatura *//* Relacionamento Linha Produá∆o x Estabelecimento     *//* Transaá∆o Reporte Ass°ncrono                        *//* Alteraá‰es Gerais EMS 2.03                          */
/*** RELEASE 2.04 ***/
/* Alteraá‰es Gerais EMS 2.04                          */
/*** RELEASE 2.04A ***/
/* Alteraá‰es p/ Foresight                             */
/*** RELEASE 2.05 ***/
/* Importaá∆o de Transaá‰es via ASCII                  *//* 3 Novas Vis‰es Gerenciais no SFC                    *//* Preáo de Venda de Itens Configurados                *//* Ponto de Reposiá∆o no MRP                           *//* Override de Ordens no MRP                           *//* Integraá∆o do ERP com APS                           *//* Tratamento do Fator de Concentraá∆o                 *//* Alteraá‰es Gerais EMS 2.05                          *//* Tratamento do Refugo por Operaá∆o (no SFC)          */
/*** RELEASE 2.06 ***/
/* Alteraá‰es Gerais EMS 2.06                          *//* Alteraá‰es DBR                                      */
/*** RELEASE 2.06B ***/
/* Alteraá‰es Gerais EMS 2.06B                         */
/*** RELEASE 2.07 ***/
/* Alteraá‰es Gerais EMS 2.07                         */
/*** RELEASE 2.07A ***/
/* Alteraá‰es Gerais EMS 2.07A   */
/*** RELEASE 2.08 ***/
/* Utilizado para Teste de Release*//* Funcionalidade de Lote Avanáado */

 

    FOR EACH tt-itens-excluir:
        DELETE tt-itens-excluir.
    END.

    assign c-descricao        = b-item.desc-item
           de-saldo-inic      = 0
           de-saldo-terc      = 0
           de-saldo-inic-teor = 0
           de-saldo-terc-teor = 0
           l-imprimiu         = no
           l-sald-est         = tt-param.l-sld-est
           l-remessa-con      = tt-param.l-re-con                                                                      
           l-ent-con          = tt-param.l-en-con
           da-dt-corte        = tt-param.da-corte
           da-op-corte        = tt-param.da-op-corte
           l-ord-comp         = tt-param.l-ord-com
           l-res-comp         = tt-param.l-res-com
           l-pedidos          = tt-param.l-ped-crt
           l-res-plan         = tt-param.l-res-pla
           l-sld-ter          = tt-param.l-sld-ter
           c-plan-ini         = tt-param.c-plan-ini
           c-plan-fim         = tt-param.c-plan-fim
           i-nr-linha-ini     = tt-param.i-linha-ini
           i-nr-linha-fim     = tt-param.i-linha-fim
           
           c-un-neg-ini       = tt-param.c-cod-unid-negoc-ini
           c-un-neg-fim       = tt-param.c-cod-unid-negoc-fim
           
           .

/*     {cdp/cd0284.i b-item} */
    RUN pi-simulacao-estoque (BUFFER b-item,
                              INPUT  l-sald-est,
                              INPUT  l-remessa,
                              INPUT  l-entrada,
                              INPUT  l-transfer,
                              INPUT  l-remessa-con, 
                              INPUT  l-ent-con,
                              INPUT  c-plan-ini,
                              INPUT  c-plan-fim,
                              INPUT  i-nr-linha-ini,
                              INPUT  i-nr-linha-fim,
                              INPUT  l-sald-terc,
                              INPUT  c-estab-ini,
                              INPUT  c-estab-fim,
                              INPUT  l-ord-prod,
                              INPUT  i-benefic,
                              INPUT  l-cred-aprov,
                              INPUT  l-planejada,
                              INPUT  l-res-plan,
                              INPUT  i-cod-plano
                              
                                 ,INPUT c-un-neg-ini,
                                  INPUT c-un-neg-fim
                              
                              ).
    
    find first tt-estoq
         where tt-estoq.tipo <> "" no-lock no-error.
    if  tt-param.l-it-sem-mov
    or (tt-param.l-it-sem-mov = no and avail tt-estoq) then do:

        if tt-param.l-componente AND l-item-pai then 
            PUT SKIP.

        assign l-lista    = no
               l-zero     = no
               l-seg      = no
               c-tipo-ant = string(tt-param.i-tipo).

        repeat while l-lista = no:
            
            IF param-globa.modulo-per-ppm AND 
               b-item.tipo-formula >= 2   AND 
               b-item.tipo-formula <= 3 THEN
                assign de-saldo     = de-saldo-inic-teor
                       de-saldo-aux = de-saldo-inic-teor.
            ELSE
            
                assign de-saldo     = de-saldo-inic
                       de-saldo-aux = de-saldo-inic.
            assign l-zero    = no
                   l-seg     = no.

            if c-tipo-ant = "4" then do:
                for each  tt-estoq no-lock
                    where tt-estoq.tipo <> ""
                    by    tt-estoq.dt-termino
                    by    tt-estoq.tipo:
    
                    if  tt-estoq.tipo = c-liter[5]
                    or  tt-estoq.tipo = c-liter[6]
                    or  tt-estoq.tipo = c-liter[8] then
                        assign de-saldo-aux      = de-saldo-aux - tt-estoq.quantidade.
                    else
                        assign de-saldo-aux = de-saldo-aux + if tt-estoq.tipo <> c-liter[2] then
                                                                tt-estoq.quantidade else 0.
                END.
                if  de-saldo-aux <= 0 THEN DO:
                        CREATE tt-itens-excluir.
                        ASSIGN tt-itens-excluir.it-codigo = b-item.it-codigo
                               de-saldo                   = de-saldo-aux.
                END.
            END.
            IF c-tipo-ant <> "4" or
               (c-tipo-ant = "4"  AND
                NOT CAN-FIND(FIRST tt-itens-excluir WHERE tt-itens-excluir.it-codigo = b-item.it-codigo)) THEN
                
                blk-estoq:
                for each  tt-estoq no-lock
                    where tt-estoq.tipo <> ""
                    by    tt-estoq.dt-termino
                    by    tt-estoq.tipo:
              
                    if l-imprimiu = no then
                       if line-counter >= 62 then
                           page.
              
                    if  tt-estoq.tipo = c-liter[5]
                    or  tt-estoq.tipo = c-liter[6]
                    or  tt-estoq.tipo = c-liter[8] then
                        assign de-saldo      = de-saldo - tt-estoq.quantidade
                               de-quantidade = (tt-estoq.quantidade * (-1)).
                    else
                        assign de-saldo      = de-saldo
                                             + if tt-estoq.tipo <> c-liter[2]
                                                  then tt-estoq.quantidade else 0
                               de-quantidade = tt-estoq.quantidade.
              
                    if  de-saldo <= 0 then do:
                        assign c-observ = c-liter[9]
                               l-zero   = yes.
                        if  de-saldo = 0 then do:
                            if  de-saldo < de-quant-segur then do:
                                if  c-tipo-ant = "2" then
                                    assign l-seg = yes.
                                else
                                    assign c-observ = c-liter[10]
                                           l-seg    = yes.
                            end.
                        end.
                        else
                            assign l-seg = yes.
                    end.
                    else
                    if  de-saldo < de-quant-segur then
                        assign c-observ = c-liter[10]
                               l-seg    = yes.
                    else
                        assign c-observ = "".
              
                    if  c-tipo-ant = "2" then do:
                        if  l-zero = no then next.
                        else do:
                            assign c-tipo-ant = "1".
                            leave.
                        end.
                    end.
                    if  c-tipo-ant = "3" then do:
                        if  l-seg = no then next.
                        else do:
                            assign c-tipo-ant = "1".
                            leave.
                        end.
                    end.
                    /*if c-tipo-ant = "4" then do:
 *                         if l-zero then next blk-estoq. /*
 *                         else do:
 *                             assign c-tipo-ant = "1".
 *                             leave.
 *                         end. */
 *                     end.  */
                    assign l-lista = yes.
                    if  line-counter <= 63 then do:
                        if  l-imprimiu = no  then do:
                            if l-ref = no then do:
                                put b-item.it-codigo
                                    string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                                    b-item.un                                     at 37
                                    c-cod-refer                                   at 41
                                    c-descricao                                   at 50  FORMAT "x(40)"
                                    string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                    string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)".
                            end.
                            else do:
                                put string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                                    c-cod-refer                                   at 41
                                    string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                    string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)".
                            end.
                        end.
                        put tt-estoq.tipo                            at 6    format "x(4)"
                            tt-estoq.referencia                      at 15   format "x(36)"
                            string(de-quantidade,tt-param.c-formato) at 56   format "x(16)"
                            tt-estoq.dt-inicio                       at 73   
                            tt-estoq.dt-termino                      at 84   
                            string(de-saldo,tt-param.c-formato)      at 95   format "x(16)"
                            c-observ                                 at 114  format "x(16)".
                            
                                if l-usa-unid-negoc then do:
                                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  item.cod-estabel,
                                                                             INPUT  item.it-codigo,
                                                                             INPUT  "",
                                                                             OUTPUT c-cod-unid-negoc).
                                    put c-cod-unid-negoc at 130 format "x(3)".  
                                end.
                            
                    end.
                    ELSE DO:
                        put b-item.it-codigo
                            de-quant-segur                                at 18
                            b-item.un                                     at 37
                            c-cod-refer                                   at 41
                            c-descricao                                   at 50
                            string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                            string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)"
                            tt-estoq.tipo                                 at 6   format "x(4)"
                            tt-estoq.referencia                           at 15
                            string(de-quantidade,tt-param.c-formato)      at 56  format "x(16)"
                            tt-estoq.dt-inicio                            at 73
                            tt-estoq.dt-termino                           at 84
                            string(de-saldo,tt-param.c-formato)           at 95  format "x(16)"
                            c-observ                                      at 114 format "x(16)".
                    END.

                    //IF c-item-impr <> b-item.it-codigo THEN
                       put STREAM str-excel UNFORMATTED 
                           b-item.it-codigo                              ";"
                           c-descricao                                   ";" 
                           de-quant-segur                                ";" 
                           b-item.un                                     ";" 
                           c-cod-refer                                   ";" 
                           tt-estoq.tipo                                 ";" 
                           string(de-saldo-inic,tt-param.c-formato)      ";" .
                           //tt-estoq.referencia                           ";"  NOVO
                           //string(de-saldo-inic-teor,tt-param.c-formato) ";" 
                           //string(de-saldo-inic,tt-param.c-formato)      ";". NOVO
                    /*ELSE
                       put STREAM str-excel UNFORMATTED 
                           ";" ";" ";" ";" ";" ";" ";".  */
                      
                    put STREAM str-excel UNFORMATTED 
                        tt-estoq.referencia                           ";" 
                        string(de-quantidade,tt-param.c-formato)      ";" 
                        tt-estoq.dt-inicio                            ";" 
                        tt-estoq.dt-termino                           ";" 
                        string(de-saldo,tt-param.c-formato)           ";" 
                        c-observ                                      ";".

                    FIND LAST int-acao-criticidade-item NO-LOCK
                        WHERE int-acao-criticidade-item.cod-estabel     = c-estab-ini 
                          AND int-acao-criticidade-item.cd-plano        = tt-param.i-cod-plano         
                          AND int-acao-criticidade-item.it-codigo       = b-item.it-codigo               
                          AND NOT int-acao-criticidade-item.acao-sistema NO-ERROR.  

                    IF AVAIL int-acao-criticidade-item THEN 
                       PUT STREAM str-excel UNFORMATTED 
                           STRING(int-acao-criticidade-item.data-acao) + " - " + replace(replace(int-acao-criticidade-item.comentario-acao,CHR(13),""),CHR(10),"") SKIP.
                    ELSE 
                       PUT STREAM str-excel UNFORMATTED SKIP.

                    assign l-imprimiu = yes
                           l-ref      = yes.
                end. /* for each tt-item */

            if  (c-tipo-ant      = "2" and l-zero  = no)
            or  (c-tipo-ant      = "3" and l-seg   = no)
            or  (tt-param.i-tipo = 1   and l-lista = no) then
                assign l-lista = yes.

            if (c-tipo-ant = "4"    and l-zero  = no)
            or (tt-param.i-tipo = 4 and l-lista = no) then
                assign l-lista = yes.

        end. /*repeat */
        
        if  l-imprimiu = no then do:
            if  de-saldo < 0 then do:
                assign c-observ = c-liter[9]
                       l-zero   = yes.
                if  de-saldo = 0 then do:
                    if  de-saldo < de-quant-segur then do:
                        if  c-tipo-ant = "2" then
                            assign l-seg = yes.
                        else
                            assign c-observ = c-liter[10]
                                   l-seg    = yes.
                    end.
                end.
                else
                    assign l-seg = yes.
            end.
            else
                if  de-saldo < de-quant-segur then
                    assign c-observ = c-liter[10]
                           l-seg    = yes.
                else
                    assign c-observ = "".

            /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldo",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
            assign c-saldo = trim(return-value).

            if (c-tipo-ant = "1") or
               (c-tipo-ant = "2" and de-saldo <= 0) or
               (c-tipo-ant = "3" and de-saldo < de-quant-segur) or
               (c-tipo-ant = "4" and de-saldo > 0) THEN DO:
                put b-item.it-codigo
                    string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                    b-item.un                                     at 37
                    c-cod-refer                                   at 41.
                   
                            if  param-global.modulo-per-ppm = YES then 
                                PUT c-descricao                               at 50 format  "x(40)"
                                string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                string(de-saldo,tt-param.c-formato)           at 111 format "x(16)" + " " SKIP.
                            ELSE
                                PUT c-descricao  at 50 format  "x(40)"
                                    /*c-saldo format "x(5)" + ":"*/
                                    string(de-saldo,tt-param.c-formato)   at 111 format "x(16)" + " " SKIP.
                    
            END.

/*             if  c-tipo-ant = "2" and de-saldo < 0 then                             */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                    at 37             */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */
/*                                                                                    */
/*             if  c-tipo-ant = "3" and de-saldo < de-quant-segur then                */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                 at 37                */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */
/*                                                                                    */
/*             if  c-tipo-ant = "4" and de-saldo > 0 then                             */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                 at 37                */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */

        end.
        if  line-counter < 63 and l-imprimiu then put SKIP.

        if tt-param.l-componente
           and l-item-pai then
           run pi-processa-componentes.
    end.
end procedure.

    /* pi-simulacao */
/**************************************************************************
**
**  Include: CD0420.i12 - Procedure pi-digitacao
**
**************************************************************************/
PROCEDURE pi-digitacao.
    
    FOR EACH tt-digita
        WHERE tt-digita.c-it-codigo <> "" NO-LOCK:

        FOR EACH tt-digita-2 EXCLUSIVE-LOCK:
            DELETE tt-digita-2.
        END.

        FIND FIRST ITEM
            WHERE ITEM.it-codigo = tt-digita.c-it-codigo NO-LOCK NO-ERROR.

        IF AVAILABLE ITEM
            AND ((ITEM.compr-fabric = 1 AND tt-param.l-comprado)
             OR  (ITEM.compr-fabric = 2 AND tt-param.l-fabricado))
            AND ((ITEM.cod-obsoleto = 1 AND (tt-param.i-obsoleto = 1 OR tt-param.i-obsoleto = 4))
             OR  (ITEM.cod-obsoleto = 2 AND (tt-param.i-obsoleto = 2 OR tt-param.i-obsoleto = 4))
             OR  (ITEM.cod-obsoleto = 3 AND (tt-param.i-obsoleto = 3 OR tt-param.i-obsoleto = 4))
             OR  (ITEM.cod-obsoleto = 4 AND tt-param.i-obsoleto  = 4)) THEN DO:
            
            IF NOT CAN-FIND(FIRST tt-digita-2
                            WHERE tt-digita-2.c-it-codigo = ITEM.it-codigo
                              AND tt-digita-2.c-cod-refer = ITEM.cod-refer) THEN DO:
                
                CREATE tt-digita-2.
                BUFFER-COPY tt-digita TO tt-digita-2.
                ASSIGN tt-digita-2.niv-mais-bai = ITEM.niv-mais-bai.

            END.

        END.
            
        IF tt-param.l-componente THEN DO:
            RUN estrutura-item-dig (INPUT tt-digita.c-it-codigo,
                                    INPUT 1,
                                    INPUT TABLE tt-param).
        END.            
            
        CASE tt-param.classifica:
            WHEN 1 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-cab-item.
                    
                
                    IF l-usa-unid-negoc THEN DO:
                        view frame f-cab-sml-un.
                    END.
                    ELSE DO:
                
                
                VIEW FRAME f-cab-sml.
                    
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.c-it-codigo.
                END.

            END.
                
            WHEN 2 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-fam-estr.
                ELSE
                    VIEW FRAME f-cab-fam.
                        
                
                    IF l-usa-unid-negoc THEN DO:
                        VIEW FRAME f-cab-sml-un.
                    END.
                    ELSE DO:
                
                
                VIEW FRAME f-cab-sml.
                    
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.fm-codigo
                                             BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.fm-codigo
                                             BY tt-digita-2.c-it-codigo.
                END.

            END.
         
            WHEN 3 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-plan-estr.
                ELSE
                    VIEW FRAME f-cab-plan.
                        
                
                    IF l-usa-unid-negoc THEN DO:
                        VIEW FRAME f-cab-sml-un.
                    END.
                    ELSE DO:
                
                
                VIEW FRAME f-cab-sml.
                    
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.cd-planejado
                                             BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.cd-planejado
                                             BY tt-digita-2.c-it-codigo.
                END.

            END.
         
            WHEN 4 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-fam-estr.
                ELSE
                    VIEW FRAME f-cab-ge.
              
                
                    IF l-usa-unid-negoc THEN DO:
                        VIEW FRAME f-cab-sml-un.
                    END.
                    ELSE DO:
                
                
                VIEW FRAME f-cab-sml.
              
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.ge-codigo
                                             BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.ge-codigo
                                             BY tt-digita-2.c-it-codigo.
                END.

            END.
         
            WHEN 5 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-comp-estr.
                ELSE
                    VIEW FRAME f-cab-comp.
                        
                
                    IF l-usa-unid-negoc THEN DO:
                        VIEW FRAME f-cab-sml-un.
                    END.
                    ELSE DO:
                
              
                VIEW FRAME f-cab-sml.
              
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.cod-comprado
                                             BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.cod-comprado
                                             BY tt-digita-2.c-it-codigo.
                END.

            END.
         
            WHEN 6 THEN DO:
                IF tt-param.l-componente THEN
                    VIEW FRAME f-cab-item.
              
                
                    IF l-usa-unid-negoc THEN DO:
                        VIEW FRAME f-cab-sml-un.
                    END.
                    ELSE DO:
                
              
                VIEW FRAME f-cab-sml.
              
                
                    END.
                
                
                IF tt-param.l-componente THEN DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.niv-mais-bai
                                             BY tt-digita-2.c-desc-item                                             
                                             BY tt-digita-2.c-it-codigo.
                END.
                ELSE DO:
                    OPEN QUERY q-digita
                        FOR EACH tt-digita-2 BY tt-digita-2.c-desc-item
                                             BY tt-digita-2.c-it-codigo.
                END.

            END.
         
        END CASE.

        ASSIGN c-cod-item = ?.

        GET FIRST q-digita.
        
        REPEAT WHILE AVAILABLE tt-digita-2:
            FIND FIRST ITEM
                WHERE ITEM.it-codigo = tt-digita-2.c-it-codigo
                  AND ITEM.nr-linha >= tt-param.i-linha-ini
                  AND ITEM.nr-linha <= tt-param.i-linha-fim NO-LOCK NO-ERROR.
                
            IF AVAILABLE ITEM THEN DO:
                RUN pi-acompanhar IN h-acomp (INPUT ITEM.it-codigo).
                
                assign l-ref         = (tt-digita-2.c-it-codigo = c-cod-item)
                       c-descricao   = ITEM.desc-item
                       c-cod-item    = ITEM.it-codigo
                       c-un          = ITEM.un
                       c-desc-cab    = c-descricao
                       c-cod-refer   = tt-digita-2.c-cod-refer
                       de-saldo-inic = 0.                                                   
        
                RUN pi-simulacao (BUFFER ITEM,
                                  INPUT  YES 
                                  ,INPUT l-usa-unid-negoc
                                  ).
            END.

            GET NEXT q-digita.
        END.
            
        IF tt-param.l-componente THEN
            PAGE.

    END.

END PROCEDURE.

PROCEDURE estrutura-item-dig:
    DEFINE INPUT PARAMETER item-pai LIKE estrutura.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER i-nivel  AS INTEGER               NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-param.

    FOR EACH estrutura
        WHERE estrutura.it-codigo = item-pai NO-LOCK:
        
        FIND FIRST ITEM
            WHERE   ITEM.it-codigo     = estrutura.es-codigo
              AND ((ITEM.compr-fabric  = 1 AND tt-param.l-comp-comp)
               OR  (ITEM.compr-fabric  = 2 AND tt-param.l-comp-fabr))
              AND   ITEM.it-codigo    >= tt-param.c-ci-item-ini
              AND   ITEM.it-codigo    <= tt-param.c-ci-item-fim
              AND   ITEM.fm-codigo    >= tt-param.c-ci-fami-ini
              AND   ITEM.fm-codigo    <= tt-param.c-ci-fami-fim
              AND   ITEM.ge-codigo    >= tt-param.i-ci-ge-ini
              AND   ITEM.ge-codigo    <= tt-param.i-ci-ge-fim NO-LOCK NO-ERROR.
            
        IF AVAILABLE ITEM THEN DO:

            
                IF l-usa-unid-negoc THEN DO:
                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                             INPUT item.it-codigo,
                                                             INPUT "",
                                                             OUTPUT c-cod-unid-negoc).
                        
                    IF NOT (c-cod-unid-negoc >= tt-param.c-ci-cod-unid-negoc-ini
                       AND  c-cod-unid-negoc <= tt-param.c-ci-cod-unid-negoc-fim) THEN NEXT.
                END.
            
            
            IF NOT CAN-FIND(FIRST item-uni-estab
                            WHERE item-uni-estab.it-codigo     = item.it-codigo
                              AND item-uni-estab.cod-estabel  >= tt-param.c-ci-estab-ini
                              AND item-uni-estab.cod-estabel  <= tt-param.c-ci-estab-fim
                              AND item-uni-estab.cd-planejado >= tt-param.c-ci-plan-ini
                              AND item-uni-estab.cd-planejado <= tt-param.c-ci-plan-fim
                              AND item-uni-estab.nr-linha     >= tt-param.i-ci-linha-ini
                              AND item-uni-estab.nr-linha     <= tt-param.i-ci-linha-fim
                              AND item-uni-estab.cod-comprado >= tt-param.c-ci-comp-ini
                              AND item-uni-estab.cod-comprado <= tt-param.c-ci-comp-fim) THEN NEXT.

            IF NOT CAN-FIND(FIRST tt-digita-2
                            WHERE tt-digita-2.c-it-codigo = ITEM.it-codigo
                              AND tt-digita-2.c-cod-refer = ITEM.cod-refer) THEN DO:
                
                CREATE tt-digita-2.
                ASSIGN tt-digita-2.c-it-codigo  = ITEM.it-codigo
                       tt-digita-2.c-desc-item  = ITEM.descricao-1
                       tt-digita-2.niv-mais-bai = ITEM.niv-mais-bai.
            END.
        END.
        
        IF i-nivel < tt-param.i-niveis THEN DO:
            RUN estrutura-item-dig (INPUT estrutura.es-codigo,
                                    INPUT i-nivel + 1,
                                    INPUT TABLE tt-param).
        END.

    END.

END PROCEDURE.
  /* pi-digitacao */

/**************************************************************************
**
**  Include: CD0420.i1 - Procedure pi-classifica-1
**
**************************************************************************/
procedure pi-classifica-1.
         
         DEFINE BUFFER B-ORD-CLASS FOR ORD-PROD LABEL "B-ORD-CLASS EM PI-CLASSIFICA-1":U.      
        
         find first para-ped no-lock no-error.
        
         assign l-aprova-wf = para-ped.log-usa-aprovac-workflow.
        
         
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         

             view frame f-cab-sml.

         
            end.
         
    
         for each item 
             where item.it-codigo     >= tt-param.c-item-ini
               and item.it-codigo     <= tt-param.c-item-fim
               and item.fm-codigo     >= tt-param.c-fami-ini
               and item.fm-codigo     <= tt-param.c-fami-fim
               and item.ge-codigo     >= tt-param.i-ge-ini
               and item.ge-codigo     <= tt-param.i-ge-fim:              
               
             
                 if l-usa-unid-negoc then do:
                     RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                              INPUT item.it-codigo,
                                                              INPUT "",
                                                              OUTPUT c-cod-unid-negoc).
                 if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                     and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                     next. 
                 end.                                                                
             
               
             if item.it-codigo = "" then next.
             
             if    ((item.compr-fabric = 1 and  tt-param.l-comprado)
               or   (item.compr-fabric = 2 and  tt-param.l-fabricado))
               and ((item.cod-obsoleto = 1 and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
               or   (item.cod-obsoleto = 2 and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
               or   (item.cod-obsoleto = 3 and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
               or   (item.cod-obsoleto = 4 and  tt-param.i-obsoleto = 4)) then 
                 if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                     create tt-item.
                     buffer-copy item to tt-item.
                 end.
               
             if tt-param.l-componente then do:                    
                 find first tt-item where tt-item.it-codigo = item.it-codigo no-lock no-error.
                 if available tt-item then do:
                     run estrutura-item (input tt-item.it-codigo,
                                         input 1).
                 end.

                 
             end.    
         end.
        
         for each tt-item FIELDS (it-codigo desc-item cod-estabel tipo-est-seg conv-tempo-seg
                               quant-segur fraciona baixa-estoq compr-fabric res-cq-comp
                               tempo-segur res-int-comp res-for-comp res-cq-fabri char-1
                               ressup-fabri compr-fabric cod-obsoleto nr-linha fm-codigo
                               ge-codigo cod-comprado tipo-con-est cd-planejado un):
        
             IF NOT CAN-FIND(FIRST item-uni-estab 
                              WHERE item-uni-estab.it-codigo     = tt-item.it-codigo
                                AND item-uni-estab.cod-estabel  >= tt-param.c-estab-ini
                                AND item-uni-estab.cod-estabel  <= tt-param.c-estab-fim
                                AND item-uni-estab.cd-planejado >= tt-param.c-plan-ini
                                AND item-uni-estab.cd-planejado <= tt-param.c-plan-fim
                                AND item-uni-estab.nr-linha     >= tt-param.i-linha-ini
                                AND item-uni-estab.nr-linha     <= tt-param.i-linha-fim
                                AND item-uni-estab.cod-comprado >= tt-param.c-comp-ini
                                AND item-uni-estab.cod-comprado <= tt-param.c-comp-fim) THEN NEXT.
             
             run pi-acompanhar in h-acomp (input tt-item.it-codigo).
             assign l-ref = no.

             if tt-item.tipo-con-est = 4 then do:
                for each  ref-item 
                    where ref-item.it-codigo = tt-item.it-codigo no-lock:                                        
                    assign c-cod-refer = ref-item.cod-refer.

                    find first saldo-estoq
                         where saldo-estoq.it-codigo    = tt-item.it-codigo
                           and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                           and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                           and saldo-estoq.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first saldo-terc
                         where saldo-terc.it-codigo    = tt-item.it-codigo
                           and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                           and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                           and saldo-terc.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ord-prod
                         where ord-prod.it-codigo    = tt-item.it-codigo
                           and ord-prod.cod-estabel >= tt-param.c-estab-ini
                           and ord-prod.cod-estabel <= tt-param.c-estab-fim
                           and ord-prod.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ordem-compra
                         where ordem-compra.it-codigo    = tt-item.it-codigo
                           and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                           and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                           and ordem-compra.cod-refer    = c-cod-refer
                         no-lock no-error.

                    assign l-res-estabel = no.
                    for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                        where reservas.it-codigo = tt-item.it-codigo and
                              reservas.estado = 1
                          and reservas.cod-refer = c-cod-refer:

                        for first b-ord-class fields (cod-estabel) where
                                  b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:

                                if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                   b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                   assign l-res-estabel = yes.
                                   leave.
                                end.
                        end.
                        
                    end.

                    find first ped-item
                         where ped-item.it-codigo = tt-item.it-codigo
                           and ped-item.cod-refer = c-cod-refer
                         no-lock no-error.
                    if avail ped-item then do:
                    
                       if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                 and ped-venda.log-aprov-workflow
                               no-lock no-error.
                       else
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                       
        
                    end.
                    else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  if not avail saldo-estoq and
                     not avail saldo-terc and
                     not avail ord-prod and
                     not avail ordem-compr and
                     not l-res-estabel and 
                     not avail ped-venda then
                        assign l-ord-aber = yes.
                  

                    if avail saldo-estoq or
                       avail saldo-terc or
                       avail ord-prod or
                       avail ordem-compra or
                       l-ord-aber or
                       l-res-estabel or
                       avail ped-venda then do:
                       assign c-descricao   = tt-item.desc-item
                              c-cod-item    = tt-item.it-codigo
                              c-un          = tt-item.un
                              c-desc-cab    = c-descricao
                              de-saldo-inic = 0
                              de-saldo-terc = 0.                                  

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                           run pi-simulacao (buffer item,
                                             input  yes
                                             
                                                ,input l-usa-unid-negoc
                                             
                                             ).

                    end.
                end.
             end. 
             else do:


                  assign c-cod-refer = "".
                  find first saldo-estoq
                       where saldo-estoq.it-codigo    = tt-item.it-codigo
                         and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                         and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first saldo-terc
                       where saldo-terc.it-codigo    = tt-item.it-codigo
                         and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                         and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ord-prod
                       where ord-prod.it-codigo    = tt-item.it-codigo
                         and ord-prod.cod-estabel >= tt-param.c-estab-ini
                         and ord-prod.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ordem-compra
                       where ordem-compra.it-codigo    = tt-item.it-codigo
                         and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                         and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  assign l-res-estabel = no.
                  for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                      where reservas.it-codigo = tt-item.it-codigo
                       and  reservas.estado = 1:
                      for first b-ord-class fields (cod-estabel) where
                                b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:

                              if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                 b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                 assign l-res-estabel = yes.
                                 leave.
                              end.
                      end.
                  end.

                  find first ped-item
                       where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                  if avail ped-item then do:
                  
                     if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */   
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               and ped-venda.log-aprov-workflow
                             no-lock no-error.
                     else
                        find first ped-venda
                            where ped-venda.nome-abrev   = ped-item.nome-abrev
                              and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                              and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                               or ped-venda.cod-sit-aval = 3)
                              and ped-venda.cod-estabel >= tt-param.c-estab-ini
                              and ped-venda.cod-estabel <= tt-param.c-estab-fim
                            no-lock no-error.
                             
                  end.
                  else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  if not avail saldo-estoq and
                     not avail saldo-terc and
                     not avail ord-prod and
                     not avail ordem-compr and
                     not avail ped-venda and
                     not l-res-estabel then
                        assign l-ord-aber = yes.                  

                  if avail saldo-estoq or
                     avail saldo-terc or
                     avail ord-prod or
                     avail ordem-compra or
                     l-ord-aber     or
                     l-res-estabel or
                     avail ped-venda then do:
                     assign c-descricao   = tt-item.desc-item
                            c-cod-item    = tt-item.it-codigo
                            c-un          = tt-item.un
                            c-desc-cab    = c-descricao
                            de-saldo-inic = 0
                            de-saldo-terc = 0.            

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                           run pi-simulacao (buffer item,
                                             input  yes
                                             
                                             ,input l-usa-unid-negoc
                                             
                                             ).

                  end.
             end.
         end.

end procedure.

procedure estrutura-item:
    define input parameter item-pai like estrutura.it-codigo no-undo.
    define input parameter i-nivel  as integer               no-undo.

    for each estrutura
        where estrutura.it-codigo = item-pai no-lock:
        
        find first b-item 
             where b-item.it-codigo = estrutura.es-codigo
               and ((b-item.compr-fabric = 1 and tt-param.l-comp-comp)
                or  (b-item.compr-fabric = 2 and tt-param.l-comp-fabr))
                                 and b-item.it-codigo    >= tt-param.c-ci-item-ini 
                 and b-item.it-codigo    <= tt-param.c-ci-item-fim 
                 and b-item.fm-codigo    >= tt-param.c-ci-fami-ini
                 and b-item.fm-codigo    <= tt-param.c-ci-fami-fim
                             and b-item.ge-codigo    >= tt-param.i-ci-ge-ini
                 and b-item.ge-codigo    <= tt-param.i-ci-ge-fim
             no-lock no-error.
             
        if available b-item and 
        not can-find(tt-item where tt-item.it-codigo = b-item.it-codigo) then do:
            create tt-item.
            buffer-copy b-item to tt-item.              
        end.
        
        if i-nivel < tt-param.i-niveis then do:
             run estrutura-item (input estrutura.es-codigo,
                                 input i-nivel + 1).
        end.
    end.
end.
   /* pi-classifica-1 */
/**************************************************************************
**
**  Include: CD0420.i2 - Procedure pi-classifica-2
**
**************************************************************************/

procedure pi-classifica-2.
        
         DEFINE BUFFER B-ORD-CLASS FOR ORD-PROD LABEL "B-ORD-CLASS EM PI-CLASSIFICA-2":U.
         
         find first para-ped no-lock no-error.
        
         assign l-aprova-wf = para-ped.log-usa-aprovac-workflow.         

         if tt-param.l-componente then
            view frame f-fam-estr.
         else
             view frame f-cab-fam.
         
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         

             view frame f-cab-sml.

         
            end.
         

         for each  familia fields (fm-codigo descricao) no-lock
             where familia.fm-codigo >= tt-param.c-fami-ini
               and familia.fm-codigo <= tt-param.c-fami-fim:
                           
                         for each tt-item exclusive-lock:
                             delete tt-item.
                         end.
                           
             for each item use-index familia NO-LOCK
               where item.it-codigo    >= tt-param.c-item-ini 
                 and item.it-codigo    <= tt-param.c-item-fim 
                 and item.fm-codigo     = familia.fm-codigo
                 and item.ge-codigo    >= tt-param.i-ge-ini
                 and item.ge-codigo    <= tt-param.i-ge-fim:
                 
                 
                     if l-usa-unid-negoc then do:
                         RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                                  INPUT item.it-codigo,
                                                                  INPUT "",
                                                                  OUTPUT c-cod-unid-negoc).
                         if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                            and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                             next. 
                         end.                                                                
                 
                 
                 if item.it-codigo = "" then next.
                
                 if ((item.compr-fabric = 1 and tt-param.l-comprado)
                 or (item.compr-fabric  = 2 and tt-param.l-fabricado))
                and ((item.cod-obsoleto = 1 and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
                 or (item.cod-obsoleto  = 2 and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
                 or (item.cod-obsoleto  = 3 and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
                 or (item.cod-obsoleto  = 4 and tt-param.i-obsoleto = 4)) then 
                     if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                         create tt-item.
                         buffer-copy item to tt-item.
                     end.
               
                 if tt-param.l-componente then
                                 
                                         find first tt-item where tt-item.it-codigo = item.it-codigo no-lock no-error.
                                         if available tt-item then do:
                                                 run estrutura-item (input tt-item.it-codigo,
                                                                                         input 1).
                                         end.

             end.
         
             for each tt-item 
              FIELDS (it-codigo    desc-item    cod-estabel  tipo-est-seg conv-tempo-seg
                      quant-segur  fraciona     baixa-estoq  compr-fabric res-cq-comp
                      tempo-segur  res-int-comp res-for-comp res-cq-fabri char-1
                      ressup-fabri compr-fabric cod-obsoleto nr-linha     fm-codigo
                      ge-codigo    cod-comprado tipo-con-est cd-planejado un) use-index familia NO-LOCK:

             if not can-find( first item-uni-estab 
                              where item-uni-estab.it-codigo     = tt-item.it-codigo
                                and item-uni-estab.cod-estabel  >= tt-param.c-estab-ini
                                and item-uni-estab.cod-estabel  <= tt-param.c-estab-fim
                                and item-uni-estab.cd-planejado >= tt-param.c-plan-ini
                                and item-uni-estab.cd-planejado <= tt-param.c-plan-fim
                                and item-uni-estab.nr-linha     >= tt-param.i-linha-ini
                                and item-uni-estab.nr-linha     <= tt-param.i-linha-fim
                                AND item-uni-estab.cod-comprado >= tt-param.c-comp-ini
                                AND item-uni-estab.cod-comprado <= tt-param.c-comp-fim) then next.
                                             
             run pi-acompanhar in h-acomp (input c-lb-fam[1] + " " + familia.fm-codigo).
             assign l-ref = no.

             if tt-item.tipo-con-est = 4 then do:
                for each  ref-item
                    where ref-item.it-codigo = tt-item.it-codigo no-lock:

                    assign c-cod-refer = ref-item.cod-refer.             

                    find first saldo-estoq
                         where saldo-estoq.it-codigo    = tt-item.it-codigo
                           and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                           and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                           and saldo-estoq.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first saldo-terc
                         where saldo-terc.it-codigo    = tt-item.it-codigo
                           and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                           and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                           and saldo-terc.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ord-prod
                         where ord-prod.it-codigo    = tt-item.it-codigo
                           and ord-prod.cod-estabel >= tt-param.c-estab-ini
                           and ord-prod.cod-estabel <= tt-param.c-estab-fim
                           and ord-prod.cod-refer    = c-cod-refer
                         no-lock no-error.



                    find first ordem-compra
                         where ordem-compra.it-codigo    = tt-item.it-codigo
                           and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                           and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                           and ordem-compra.cod-refer    = c-cod-refer
                         no-lock no-error.

                    assign l-res-estabel = no.
                    for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                        where reservas.it-codigo = tt-item.it-codigo and
                              reservas.estado = 1
                          and reservas.cod-refer = c-cod-refer:

                        for first b-ord-class fields (cod-estabel) where
                                  b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:

                                if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                   b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                   assign l-res-estabel = yes.
                                   leave.
                                end.
                        end.
                        
                    end.

                    find first ped-item
                         where ped-item.it-codigo = tt-item.it-codigo
                           and ped-item.cod-refer = c-cod-refer
                         no-lock no-error.
                    if avail ped-item then do:
                    
                       if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */         
                          find first ped-venda
                               where ped-venda.nome-abrev    = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli     = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval  = 3)
                                 and ped-venda.cod-estabel  >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel  <= tt-param.c-estab-fim
                                 and ped-venda.log-aprov-workflow
                               no-lock no-error.
                        else
                           find first ped-venda
                               where ped-venda.nome-abrev    = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli     = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval  = 3)
                                 and ped-venda.cod-estabel  >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel  <= tt-param.c-estab-fim
                               no-lock no-error.    
                        
                    end.
                    else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                    /*if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then */
                       assign l-ord-aber = yes.                   

                    if avail saldo-estoq or
                       avail saldo-terc or
                       avail ord-prod or
                       avail ordem-compra or
                       l-ord-aber or
                       l-res-estabel or
                       avail ped-venda then do:
                       assign c-desc-cab  = tt-item.desc-item
                              c-cod-item  = tt-item.it-codigo
                              c-un        = tt-item.un.
                       if familia.fm-codigo <> c-fm-codigo then do:
                          assign c-fm-codigo = familia.fm-codigo
                                 c-fm-desc   = familia.descricao.
                          page.
                       end.                

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                       run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                    end.
                end.
             end.
             else do:
                  assign c-cod-refer = "".
                  find first saldo-estoq
                       where saldo-estoq.it-codigo    = tt-item.it-codigo
                         and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                         and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first saldo-terc
                       where saldo-terc.it-codigo    = tt-item.it-codigo
                         and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                         and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.


                  find first ord-prod
                       where ord-prod.it-codigo    = tt-item.it-codigo
                         and ord-prod.cod-estabel >= tt-param.c-estab-ini
                         and ord-prod.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.


                  find first ordem-compra
                       where ordem-compra.it-codigo    = tt-item.it-codigo
                         and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                         and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  assign l-res-estabel = no.
                  for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                      where reservas.it-codigo = tt-item.it-codigo
                       and  reservas.estado = 1:
                      for first b-ord-class fields (cod-estabel) where
                                b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:

                              if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                 b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                 assign l-res-estabel = yes.
                                 leave.
                              end.
                      end.
                  end.

                  find first ped-item
                       where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                  if avail ped-item then do:
                  
                     if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */    
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               and ped-venda.log-aprov-workflow
                             no-lock no-error.
                     else
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                            no-lock no-error.  
                  end.
                  else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  /*if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then */
                       assign l-ord-aber = yes.                  

                  if avail saldo-estoq or
                     avail saldo-terc or
                     avail ord-prod or
                     avail ordem-compra or
                     l-res-estabel or
                     l-ord-aber or
                     avail ped-venda then do:
                     assign c-desc-cab  = tt-item.desc-item
                            c-cod-item  = tt-item.it-codigo
                            c-un        = tt-item.un.
                     if familia.fm-codigo <> c-fm-codigo then do:
                        assign c-fm-codigo = familia.fm-codigo
                               c-fm-desc   = familia.descricao.
                        page.
                     end.                

                     find item where item.it-codigo = tt-item.it-codigo no-error.
                     if avail item then
                     run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                  end.
             end.                  
             end.
         end.

end procedure.
   /* pi-classifica-2 */
/**************************************************************************
**
**  Include: CD0420.i6 - Procedure pi-classifica-3
**
**************************************************************************/

procedure pi-classifica-3.

         find first para-ped no-lock no-error.
        
         assign l-aprova-wf = para-ped.log-usa-aprovac-workflow. 
        
         if tt-param.l-componente then
            view frame f-plan-estr.
         else
             view frame f-cab-plan.
         
         
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         
         
         view frame f-cab-sml.
         
         
            end.
         
         
         for each item /* use-index planejador */
             where item.it-codigo     >= tt-param.c-item-ini
               and item.it-codigo     <= tt-param.c-item-fim
               and item.fm-codigo     >= tt-param.c-fami-ini
               and item.fm-codigo     <= tt-param.c-fami-fim
               and item.ge-codigo     >= tt-param.i-ge-ini
               and item.ge-codigo     <= tt-param.i-ge-fim no-lock:
               
               
                    if l-usa-unid-negoc then do:
                        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                                 INPUT item.it-codigo,
                                                                 INPUT "",
                                                                 OUTPUT c-cod-unid-negoc).
                        if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                           and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                           next. 
                   end.                                                                
              
              
               if item.it-codigo = "" then next.
         
               if    ((item.compr-fabric = 1  and  tt-param.l-comprado)
                  or  (item.compr-fabric = 2  and  tt-param.l-fabricado))
                 and ((item.cod-obsoleto = 1  and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
                  or  (item.cod-obsoleto = 2  and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
                  or  (item.cod-obsoleto = 3  and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
                  or  (item.cod-obsoleto = 4  and  tt-param.i-obsoleto = 4)) then 
                   if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                       create tt-item.
                       buffer-copy item to tt-item.
                   end.
               
               if tt-param.l-componente then
                 for each estrutura 
                   where estrutura.it-codigo = item.it-codigo no-lock:
                     find first b-item 
                       where b-item.it-codigo    = estrutura.es-codigo
                       and ((b-item.compr-fabric = 1 and tt-param.l-comp-comp)
                       or   (b-item.compr-fabric = 2 and tt-param.l-comp-fabr))
                       no-lock no-error.
                     if avail b-item then 
                         if not can-find(tt-item where tt-item.it-codigo = b-item.it-codigo) then do:
                             create tt-item.
                             buffer-copy b-item to tt-item.
                         end.
                 end.
         end.
         
         for each tt-item FIELDS (IT-CODIGO FM-CODIGO GE-CODIGO COD-COMPRADO):
               for each item-uni-estab where item-uni-estab.it-codigo     = tt-item.it-codigo
                                         and item-uni-estab.cod-estabel  >= tt-param.c-estab-ini
                                         and item-uni-estab.cod-estabel  <= tt-param.c-estab-fim
                                         and item-uni-estab.cd-planejado >= tt-param.c-plan-ini
                                         and item-uni-estab.cd-planejado <= tt-param.c-plan-fim
                                         and item-uni-estab.nr-linha     >= tt-param.i-linha-ini
                                         and item-uni-estab.nr-linha     <= tt-param.i-linha-fim 
                                         AND item-uni-estab.cod-comprado >= tt-param.c-comp-ini
                                         AND item-uni-estab.cod-comprado <= tt-param.c-comp-fim no-lock:

                        
                     find planejad no-lock
                     where planejad.cd-planejado = item-uni-estab.cd-planejado no-error.                

                     create tt-item-selec.
                     assign tt-item-selec.rowid-item = rowid(tt-item)
                            tt-item-selec.cd-planej = if avail planejad 
                                                      then planejad.cd-planej
                                                      else "".
                     assign tt-item-selec.nome      = if avail planejad
                                                      then planejad.nome
                                                      else "".
               end.
         end.

         for each tt-item-selec use-index codigo no-lock:

             find tt-item where rowid(tt-item) = tt-item-selec.rowid-item no-lock no-error.

             run pi-acompanhar in h-acomp (input c-lb-plan[1] + " " + tt-item-selec.cd-planej). 

             assign l-ref = no.

             if tt-item.tipo-con-est = 4 then do:
                for each  ref-item
                    where ref-item.it-codigo = tt-item.it-codigo no-lock:
                    assign c-cod-refer = ref-item.cod-refer.

                    find first saldo-estoq
                         where saldo-estoq.it-codigo    = tt-item.it-codigo
                           and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                           and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                           and saldo-estoq.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first saldo-terc
                         where saldo-terc.it-codigo    = tt-item.it-codigo
                           and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                           and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                           and saldo-terc.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ord-prod
                         where ord-prod.it-codigo    = tt-item.it-codigo
                           and ord-prod.cod-estabel >= tt-param.c-estab-ini
                           and ord-prod.cod-estabel <= tt-param.c-estab-fim
                           and ord-prod.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ordem-compra
                         where ordem-compra.it-codigo    = tt-item.it-codigo
                           and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                           and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                           and ordem-compra.cod-refer    = c-cod-refer
                         no-lock no-error.

                    assign l-res-estabel = no.
                    for each  reservas no-lock
                        where reservas.it-codigo = tt-item.it-codigo
                          and reservas.cod-refer = c-cod-refer:

                        find ord-prod where
                             ord-prod.nr-ord-prod = reservas.nr-ord-prod
                             no-lock no-error.
                        if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                           ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                           assign l-res-estabel = yes.
                           leave.
                        end.
                    end.

                    find first ped-item
                         where ped-item.it-codigo = tt-item.it-codigo
                           and ped-item.cod-refer = c-cod-refer
                         no-lock no-error.
                    if avail ped-item then do:
                    
                       if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */  
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                 and ped-venda.log-aprov-workflow
                               no-lock no-error.
                       else
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                       

       
                    end.
                    else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                    if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                  

                    if avail saldo-estoq or
                       avail saldo-terc or
                       avail ord-prod or
                       avail ordem-compra or
                       l-ord-aber or
                       l-res-estabel or
                       avail ped-venda then do:
                       assign c-desc-cab  = tt-item.desc-item
                              c-cod-item  = tt-item.it-codigo
                              c-un        = tt-item.un.
                       if tt-item-selec.cd-planej <> c-planej then do:
                          assign c-planej    = tt-item-selec.cd-planej
                                 c-plan-desc = tt-item-selec.nome.
                          page.
                       end.

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                       run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                    end.
                end.
             end.
             else do:
                  assign c-cod-refer = "".
                  find first saldo-estoq
                       where saldo-estoq.it-codigo    = tt-item.it-codigo
                         and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                         and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first saldo-terc
                       where saldo-terc.it-codigo    = tt-item.it-codigo
                         and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                         and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ord-prod
                       where ord-prod.it-codigo    = tt-item.it-codigo
                         and ord-prod.cod-estabel >= tt-param.c-estab-ini
                         and ord-prod.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ordem-compra
                       where ordem-compra.it-codigo    = tt-item.it-codigo
                         and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                         and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  assign l-res-estabel = no.
                  for each  reservas no-lock
                      where reservas.it-codigo = tt-item.it-codigo:

                      find ord-prod where
                           ord-prod.nr-ord-prod = reservas.nr-ord-prod
                           no-lock no-error.
                      if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                         ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                         assign l-res-estabel = yes.
                         leave.
                      end.
                  end.

                  find first ped-item
                       where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                  if avail ped-item then do:
                  
                     if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */    
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               and ped-venda.log-aprov-workflow
                             no-lock no-error.
                     else
                        find first ped-venda                                                 
                             where ped-venda.nome-abrev   = ped-item.nome-abrev              
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli               
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov  
                                or ped-venda.cod-sit-aval = 3)                               
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini             
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim             
                             no-lock no-error.                                                    
                  end.
                  else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                  

                  if avail saldo-estoq or
                     avail saldo-terc or
                     avail ord-prod or
                     avail ordem-compra or
                     l-ord-aber or
                     l-res-estabel or
                     avail ped-venda then do:
                     assign c-desc-cab  = tt-item.desc-item
                            c-cod-item  = tt-item.it-codigo
                            c-un        = tt-item.un.

                        if tt-item-selec.cd-planej <> c-planej then do:
                          assign c-planej    = tt-item-selec.cd-planej
                                 c-plan-desc = tt-item-selec.nome.
                           page.
                        end.                     
                     find item where item.it-codigo = tt-item.it-codigo no-error.
                     if avail item then
                     run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                  end.
             end.             
         end.

end procedure.

   /* pi-classifica-3 */
/**************************************************************************
**
**  Include: CD0420.i7 - Procedure pi-classifica-4
**
**************************************************************************/

procedure pi-classifica-4.

        find first para-ped no-lock no-error.
        
        assign l-aprova-wf = para-ped.log-usa-aprovac-workflow. 

        if tt-param.l-componente then
           view frame f-fam-estr.
        else
            view frame f-cab-ge.
        
        
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         
         
         view frame f-cab-sml.
         
         
            end.
         

        for each grup-estoque no-lock
           where grup-estoque.ge-codigo >= tt-param.i-ge-ini
             and grup-estoque.ge-codigo <= tt-param.i-ge-fim,
            each item use-index grupo no-lock
           where item.ge-codigo     = grup-estoque.ge-codigo
             and item.it-codigo    >= tt-param.c-item-ini
             and item.it-codigo    <= tt-param.c-item-fim
             and item.fm-codigo    >= tt-param.c-fami-ini
             and item.fm-codigo    <= tt-param.c-fami-fim:
             
             if item.it-codigo = "" then next.

             if ((item.compr-fabric  = 1 and tt-param.l-comprado)
              or (item.compr-fabric  = 2 and tt-param.l-fabricado))
             and ((item.cod-obsoleto  = 1 and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
              or (item.cod-obsoleto  = 2 and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
              or (item.cod-obsoleto  = 3 and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
              or (item.cod-obsoleto  = 4 and tt-param.i-obsoleto = 4 )) then 
                 if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                     create tt-item.
                     buffer-copy item to tt-item.
                 end.     
                 
             
                    if l-usa-unid-negoc then do:
                        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                                 INPUT item.it-codigo,
                                                                 INPUT "",
                                                                 OUTPUT c-cod-unid-negoc).
                        if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                           and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                           next. 
                   end.                                                                
             
             
             if tt-param.l-componente then
                 for each estrutura 
                   where estrutura.it-codigo = item.it-codigo no-lock:
                     find first b-item 
                       where b-item.it-codigo    = estrutura.es-codigo
                       and ((b-item.compr-fabric = 1 and tt-param.l-comp-comp)
                       or   (b-item.compr-fabric = 2 and tt-param.l-comp-fabr))
                       no-lock no-error.
                     if avail b-item then 
                         if not can-find(tt-item where tt-item.it-codigo = b-item.it-codigo) then do:
                             create tt-item.
                             buffer-copy b-item to tt-item.
                         end.
                 end.
        end.
        
        for each grup-estoque no-lock
           where grup-estoque.ge-codigo >= tt-param.i-ge-ini
             and grup-estoque.ge-codigo <= tt-param.i-ge-fim,
            each tt-item use-index grupo no-lock
            where tt-item.ge-codigo     = grup-estoque.ge-codigo:
            
             if not can-find( first item-uni-estab where item-uni-estab.it-codigo     = tt-item.it-codigo
                                               and item-uni-estab.cod-estabel        >= tt-param.c-estab-ini
                                               and item-uni-estab.cod-estabel        <= tt-param.c-estab-fim
                                               and item-uni-estab.cd-planejado       >= tt-param.c-plan-ini
                                               and item-uni-estab.cd-planejado       <= tt-param.c-plan-fim
                                               and item-uni-estab.nr-linha           >= tt-param.i-linha-ini
                                               and item-uni-estab.nr-linha           <= tt-param.i-linha-fim
                                               AND item-uni-estab.cod-comprado >= tt-param.c-comp-ini
                                               AND item-uni-estab.cod-comprado <= tt-param.c-comp-fim) then
                                               next.

             run pi-acompanhar in h-acomp (input c-lb-ge[1] + " " + string(tt-item.ge-codigo)).
             assign l-ref = no.

             if tt-item.tipo-con-est = 4 then do:
                for each  ref-item
                    where ref-item.it-codigo = tt-item.it-codigo no-lock:
                    assign c-cod-refer = ref-item.cod-refer.                    

                    find first saldo-estoq
                         where saldo-estoq.it-codigo    = tt-item.it-codigo
                           and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                           and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                           and saldo-estoq.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first saldo-terc
                         where saldo-terc.it-codigo    = tt-item.it-codigo
                           and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                           and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                           and saldo-terc.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ord-prod
                         where ord-prod.it-codigo    = tt-item.it-codigo
                           and ord-prod.cod-estabel >= tt-param.c-estab-ini
                           and ord-prod.cod-estabel <= tt-param.c-estab-fim
                           and ord-prod.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ordem-compra
                         where ordem-compra.it-codigo    = tt-item.it-codigo
                           and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                           and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                           and ordem-compra.cod-refer    = c-cod-refer
                         no-lock no-error.

                    assign l-res-estabel = no.
                    for each  reservas no-lock
                        where reservas.it-codigo = tt-item.it-codigo
                          and reservas.cod-refer = c-cod-refer:

                        find ord-prod where
                             ord-prod.nr-ord-prod = reservas.nr-ord-prod
                             no-lock no-error.
                        if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                           ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                           assign l-res-estabel = yes.
                           leave.
                        end.
                    end.

                    find first ped-item
                         where ped-item.it-codigo = tt-item.it-codigo
                           and ped-item.cod-refer = c-cod-refer
                         no-lock no-error.
                    if avail ped-item then do:
                    
                       if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */ 
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                 and ped-venda.log-aprov-workflow
                               no-lock no-error.
                       else     
                          find first ped-venda
                              where ped-venda.nome-abrev   = ped-item.nome-abrev
                                and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                 or ped-venda.cod-sit-aval = 3)
                                and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                and ped-venda.cod-estabel <= tt-param.c-estab-fim
                              no-lock no-error.
     
                    end.
                    else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                    if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                   

                    if avail saldo-estoq or
                       avail saldo-terc or
                       avail ord-prod or
                       avail ordem-compra or
                       l-ord-aber or
                       l-res-estabel or
                       avail ped-venda then do:
                       assign c-desc-cab  = tt-item.desc-item
                              c-cod-item  = tt-item.it-codigo
                              c-un        = tt-item.un.
                       if tt-item.ge-codigo <> c-grupo then do:
                          assign c-grupo   = tt-item.ge-codigo
                                 c-fm-desc = grup-estoque.descricao.
                          page.
                       end.                

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                       run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                    end.
                end.
             end.
             else do:
                  assign c-cod-refer = "".
                  find first saldo-estoq
                       where saldo-estoq.it-codigo    = tt-item.it-codigo
                         and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                         and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first saldo-terc
                       where saldo-terc.it-codigo    = tt-item.it-codigo
                         and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                         and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ord-prod
                       where ord-prod.it-codigo    = tt-item.it-codigo
                         and ord-prod.cod-estabel >= tt-param.c-estab-ini
                         and ord-prod.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ordem-compra
                       where ordem-compra.it-codigo    = tt-item.it-codigo
                         and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                         and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  assign l-res-estabel = no.
                  for each  reservas no-lock
                      where reservas.it-codigo = tt-item.it-codigo:

                      find ord-prod where
                           ord-prod.nr-ord-prod = reservas.nr-ord-prod
                           no-lock no-error.
                      if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                         ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                         assign l-res-estabel = yes.
                         leave.
                      end.
                  end.

                  find first ped-item
                       where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                  if avail ped-item then do:
                  
                     if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */    
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               and ped-venda.log-aprov-workflow
                             no-lock no-error.
                      else
                         find first ped-venda
                            where ped-venda.nome-abrev   = ped-item.nome-abrev
                              and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                              and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                               or ped-venda.cod-sit-aval = 3)
                              and ped-venda.cod-estabel >= tt-param.c-estab-ini
                              and ped-venda.cod-estabel <= tt-param.c-estab-fim
                            no-lock no-error.
                             
                  end.
                  else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                   

                  if avail saldo-estoq or
                     avail saldo-terc or
                     avail ord-prod or
                     avail ordem-compra or
                     l-ord-aber or
                     l-res-estabel or
                     avail ped-venda then do:
                     assign c-desc-cab  = tt-item.desc-item
                            c-cod-item  = tt-item.it-codigo
                            c-un        = tt-item.un.
                     if tt-item.ge-codigo <> c-grupo then do:
                        assign c-grupo   = tt-item.ge-codigo
                               c-fm-desc = grup-estoque.descricao.
                        page.
                     end.              

                     find item where item.it-codigo = tt-item.it-codigo no-error.
                     if avail item then
                     run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                  end.
             end.             
         end.

end procedure.

   /* pi-classifica-4 */
/**************************************************************************
**
**  Include: CD0420.i8 - Procedure pi-classifica-5
**
**************************************************************************/

procedure pi-classifica-5.

         DEFINE BUFFER B-ORD-CLASS FOR ORD-PROD LABEL "B-ORD-CLASS EM PI-CLASSIFICA-8":U.
         
         find first para-ped no-lock no-error.
        
         assign l-aprova-wf = para-ped.log-usa-aprovac-workflow. 
         
         if tt-param.l-componente then
            view frame f-comp-estr.
         else
             view frame f-cab-comp.
         
         
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         
         
         view frame f-cab-sml.
         
         
            end.
         

         for each  comprador no-lock 
             where comprador.cod-comprado >= tt-param.c-comp-ini
               and comprador.cod-comprado <= tt-param.c-comp-fim:
               
                for each item-uni-estab NO-LOCK
                  where item-uni-estab.cod-comprado  = comprador.cod-comprado
                    and item-uni-estab.it-codigo     >= tt-param.c-item-ini
                    and item-uni-estab.it-codigo     <= tt-param.c-item-fim
                    and item-uni-estab.cod-estabel   >= tt-param.c-estab-ini
                    and item-uni-estab.cod-estabel   <= tt-param.c-estab-fim
                    and item-uni-estab.cd-planejado  >= tt-param.c-plan-ini
                    and item-uni-estab.cd-planejado  <= tt-param.c-plan-fim
                    and item-uni-estab.nr-linha      >= tt-param.i-linha-ini
                    and item-uni-estab.nr-linha      <= tt-param.i-linha-fim,                  
                    first item no-lock
                    where item.it-codigo    = item-uni-estab.it-codigo
                      and item.ge-codigo   >= tt-param.i-ge-ini
                      and item.ge-codigo   <= tt-param.i-ge-fim
                      and item.fm-codigo   >= tt-param.c-fami-ini
                      and item.fm-codigo   <= tt-param.c-fami-fim:
                       
                       
                            if l-usa-unid-negoc then do:
                                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                                         INPUT item.it-codigo,
                                                                         INPUT "",
                                                                         OUTPUT c-cod-unid-negoc).
                                if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                                   and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                                   next. 
                            end.                                                                
                       
                       
                   if item.it-codigo = "" then next.
                       
                   if    ((item.compr-fabric = 1 and  tt-param.l-comprado)
                     or   (item.compr-fabric = 2 and  tt-param.l-fabricado))
                     and ((item.cod-obsoleto = 1 and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
                     or   (item.cod-obsoleto = 2 and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
                     or   (item.cod-obsoleto = 3 and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
                     or   (item.cod-obsoleto = 4 and  tt-param.i-obsoleto = 4)) then 
                       if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                           create tt-item.
                           buffer-copy item to tt-item.
                       end.    
               
                   if tt-param.l-componente then
                       for each estrutura 
                         where estrutura.it-codigo = item.it-codigo no-lock:
                           find first b-item 
                             where b-item.it-codigo    = estrutura.es-codigo
                             and ((b-item.compr-fabric = 1 and tt-param.l-comp-comp)
                             or   (b-item.compr-fabric = 2 and tt-param.l-comp-fabr))
                             no-lock no-error.
                           if avail b-item then 
                               if not can-find(tt-item where tt-item.it-codigo = b-item.it-codigo) then do:
                                   create tt-item.
                                   buffer-copy b-item to tt-item.
                               end.
                       end.
               end.        
               for each tt-item use-index comprador no-lock
                     where tt-item.cod-comprado = comprador.cod-comprado:    
                   
                     if not can-find( first item-uni-estab where item-uni-estab.it-codigo     = tt-item.it-codigo
                                                       and item-uni-estab.cod-estabel        >= tt-param.c-estab-ini
                                                       and item-uni-estab.cod-estabel        <= tt-param.c-estab-fim
                                                       and item-uni-estab.cd-planejado       >= tt-param.c-plan-ini
                                                       and item-uni-estab.cd-planejado       <= tt-param.c-plan-fim
                                                       and item-uni-estab.nr-linha           >= tt-param.i-linha-ini
                                                       and item-uni-estab.nr-linha           <= tt-param.i-linha-fim) then
                                                       next.
                    
                     run pi-acompanhar in h-acomp (input c-lb-comp[1] + " "  + comprador.cod-comprado).
                     assign l-ref = no.
                    
                     if tt-item.tipo-con-est = 4 then do:
                        for each  ref-item
                            where ref-item.it-codigo = tt-item.it-codigo no-lock:
                            assign c-cod-refer = ref-item.cod-refer.                
                    
                            find first saldo-estoq
                                 where saldo-estoq.it-codigo    = tt-item.it-codigo
                                   and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                                   and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                                   and saldo-estoq.cod-refer    = c-cod-refer
                                 no-lock no-error.
                    
                            find first saldo-terc
                                 where saldo-terc.it-codigo    = tt-item.it-codigo
                                   and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                                   and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                                   and saldo-terc.cod-refer    = c-cod-refer
                                 no-lock no-error.
                    
                            find first ord-prod
                                 where ord-prod.it-codigo    = tt-item.it-codigo
                                   and ord-prod.cod-estabel >= tt-param.c-estab-ini
                                   and ord-prod.cod-estabel <= tt-param.c-estab-fim
                                   and ord-prod.cod-refer    = c-cod-refer
                                 no-lock no-error.
                    
                            find first ordem-compra
                                 where ordem-compra.it-codigo    = tt-item.it-codigo
                                   and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                                   and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                                   and ordem-compra.cod-refer    = c-cod-refer
                                 no-lock no-error.
                    
                            assign l-res-estabel = no.
                            /* queli */      
                            for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                                where reservas.it-codigo = tt-item.it-codigo and
                                      reservas.estado = 1
                                  and reservas.cod-refer = c-cod-refer:
                    
                                for first b-ord-class fields (cod-estabel) where
                                          b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:
                                          
                                      if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                         b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                         assign l-res-estabel = yes.
                                         leave.
                                      end.
                                end.
                            end.
                            find first ped-item
                                 where ped-item.it-codigo = tt-item.it-codigo
                                   and ped-item.cod-refer = c-cod-refer
                                 no-lock no-error.
                            if avail ped-item then do:
                               if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */ 
                                  find first ped-venda
                                       where ped-venda.nome-abrev   = ped-item.nome-abrev
                                         and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                         and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                          or ped-venda.cod-sit-aval = 3)
                                         and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                         and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                         and ped-venda.log-aprov-workflow
                                       no-lock no-error.
                                else
                                   find first ped-venda
                                      where ped-venda.nome-abrev   = ped-item.nome-abrev
                                        and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                        and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                         or ped-venda.cod-sit-aval = 3)
                                        and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                        and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                      no-lock no-error.
                                       
                            end.
                            else find ped-venda where
                                      rowid (ped-venda) = ? no-lock no-error.
                    
                    
                            if avail saldo-estoq or
                               avail saldo-terc or
                               avail ord-prod or
                               avail ordem-compra or
                               l-res-estabel or
                               avail ped-venda then do:
                               assign c-desc-cab  = tt-item.desc-item
                                      c-cod-item  = tt-item.it-codigo
                                      c-un        = tt-item.un.
                               if tt-item.cod-comprado <> c-comprado then do:
                                  assign c-comprado  = tt-item.cod-comprado
                                         c-comp-desc = comprador.nome.
                                  page.
                               end.                       
                    
                               find item where item.it-codigo = tt-item.it-codigo no-error.
                               if avail item then
                               run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).
                    
                            end.
                        end.
                     end.
                     else do:
                          assign c-cod-refer = "".
                          find first saldo-estoq
                               where saldo-estoq.it-codigo    = tt-item.it-codigo
                                 and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                                 and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                    
                          find first saldo-terc
                               where saldo-terc.it-codigo    = tt-item.it-codigo
                                 and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                                 and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                    
                          find first ord-prod
                               where ord-prod.it-codigo    = tt-item.it-codigo
                                 and ord-prod.cod-estabel >= tt-param.c-estab-ini
                                 and ord-prod.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                    
                          find first ordem-compra
                               where ordem-compra.it-codigo    = tt-item.it-codigo
                                 and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                                 and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                    
                          assign l-res-estabel = no.
                          /* queli */
                          for each  reservas fields (nr-ord-produ) use-index planejamento no-lock
                              where reservas.it-codigo = tt-item.it-codigo
                               and  reservas.estado = 1:    
                               for first b-ord-class fields (cod-estabel) where
                                         b-ord-class.nr-ord-prod = reservas.nr-ord-prod no-lock:
                                   if b-ord-class.cod-estabel >= tt-param.c-estab-ini and
                                      b-ord-class.cod-estabel <= tt-param.c-estab-fim then do:
                                      assign l-res-estabel = yes.
                                      leave.
                                   end.
                               end.
                          end.
                          find first ped-item
                               where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                          if avail ped-item then do:
                          
                             if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */    
                                find first ped-venda
                                     where ped-venda.nome-abrev   = ped-item.nome-abrev
                                       and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                       and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                        or ped-venda.cod-sit-aval = 3)
                                       and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                       and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                       and ped-venda.log-aprov-workflow
                                     no-lock no-error.
                             else
                                find first ped-venda
                                    where ped-venda.nome-abrev   = ped-item.nome-abrev
                                      and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                      and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                       or ped-venda.cod-sit-aval = 3)
                                      and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                      and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                    no-lock no-error.
                                      
                          end.
                          else find ped-venda where
                                      rowid (ped-venda) = ? no-lock no-error.
                    
                    
                          if avail saldo-estoq or
                             avail saldo-terc or
                             avail ord-prod or
                             avail ordem-compra or
                             l-res-estabel or
                             avail ped-venda then do:
                             assign c-desc-cab  = tt-item.desc-item
                                    c-cod-item  = tt-item.it-codigo
                                    c-un        = tt-item.un.
                             if tt-item.cod-comprado <> c-comprado then do:
                                assign c-comprado  = tt-item.cod-comprado
                                       c-comp-desc = comprador.nome.
                                page.
                             end.                     
                    
                             find item where item.it-codigo = tt-item.it-codigo no-error.
                             if avail item then
                             run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).
                    
                          end.
                     end.                  
         end.
     end.
end procedure.        
   /* pi-classifica-5 */
/**************************************************************************
**
**  Include: CD0420.i9 - Procedure pi-classifica-6
**
**************************************************************************/

procedure pi-classifica-6.

         find first para-ped no-lock no-error.
        
         assign l-aprova-wf = para-ped.log-usa-aprovac-workflow. 
         
         if tt-param.l-componente then
            view frame f-cab-item.
         
         
            if l-usa-unid-negoc then do:
                view frame f-cab-sml-un.
            end.
            else do:
         
         
         view frame f-cab-sml.
         
         
            end.
         

         for each item use-index descricao no-lock
            where item.it-codigo    >= tt-param.c-item-ini
              and item.it-codigo    <= tt-param.c-item-fim
              and item.fm-codigo    >= tt-param.c-fami-ini
              and item.fm-codigo    <= tt-param.c-fami-fim
              and item.ge-codigo    >= tt-param.i-ge-ini
              and item.ge-codigo    <= tt-param.i-ge-fim:
              
             
                 if l-usa-unid-negoc then do:
                     RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                              INPUT item.it-codigo,
                                                              INPUT "",
                                                              OUTPUT c-cod-unid-negoc).
                 if not (c-cod-unid-negoc >= tt-param.c-cod-unid-negoc-ini
                     and c-cod-unid-negoc <= tt-param.c-cod-unid-negoc-fim) then
                     next. 
                 end.                                                                
             
              
             if item.it-codigo = "" then next.
              
             if  ((item.compr-fabric  = 1 and  tt-param.l-comprado)
               or (item.compr-fabric  = 2 and  tt-param.l-fabricado))
              and ((item.cod-obsoleto = 1 and (tt-param.i-obsoleto = 1 or tt-param.i-obsoleto = 4))
               or (item.cod-obsoleto  = 2 and (tt-param.i-obsoleto = 2 or tt-param.i-obsoleto = 4))
               or (item.cod-obsoleto  = 3 and (tt-param.i-obsoleto = 3 or tt-param.i-obsoleto = 4))
               or (item.cod-obsoleto  = 4 and  tt-param.i-obsoleto = 4)) then 
               if not can-find(tt-item where tt-item.it-codigo = item.it-codigo) then do:
                     create tt-item.
                     buffer-copy item to tt-item.
                 end.    
               
             if tt-param.l-componente then
                 for each estrutura 
                   where estrutura.it-codigo = item.it-codigo no-lock:
                     find first b-item 
                       where b-item.it-codigo    = estrutura.es-codigo
                       and ((b-item.compr-fabric = 1 and tt-param.l-comp-comp)
                       or   (b-item.compr-fabric = 2 and tt-param.l-comp-fabr))
                       no-lock no-error.
                     if avail b-item then 
                         if not can-find(tt-item where tt-item.it-codigo = b-item.it-codigo) then do:
                             create tt-item.
                             buffer-copy b-item to tt-item.
                         end.
                 end.
         end.
         
         for each tt-item use-index descricao no-lock:

             if not can-find( first item-uni-estab where item-uni-estab.it-codigo     = tt-item.it-codigo
                                               and item-uni-estab.cod-estabel        >= tt-param.c-estab-ini
                                               and item-uni-estab.cod-estabel        <= tt-param.c-estab-fim
                                               and item-uni-estab.cd-planejado       >= tt-param.c-plan-ini
                                               and item-uni-estab.cd-planejado       <= tt-param.c-plan-fim
                                               and item-uni-estab.nr-linha           >= tt-param.i-linha-ini
                                               and item-uni-estab.nr-linha           <= tt-param.i-linha-fim
                                               and item-uni-estab.cod-comprado       >= tt-param.c-comp-ini
                                               and item-uni-estab.cod-comprado       <= tt-param.c-comp-fim) then
                                               next.

             run pi-acompanhar in h-acomp (input tt-item.it-codigo).
             assign l-ref = no.

             if tt-item.tipo-con-est = 4 then do:
                for each  ref-item
                    where ref-item.it-codigo = tt-item.it-codigo no-lock:
                    assign c-cod-refer = ref-item.cod-refer.

                    find first saldo-estoq
                         where saldo-estoq.it-codigo    = tt-item.it-codigo
                           and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                           and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                           and saldo-estoq.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first saldo-terc
                         where saldo-terc.it-codigo    = tt-item.it-codigo
                           and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                           and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                           and saldo-terc.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ord-prod
                         where ord-prod.it-codigo    = tt-item.it-codigo
                           and ord-prod.cod-estabel >= tt-param.c-estab-ini
                           and ord-prod.cod-estabel <= tt-param.c-estab-fim
                           and ord-prod.cod-refer    = c-cod-refer
                         no-lock no-error.

                    find first ordem-compra
                         where ordem-compra.it-codigo    = tt-item.it-codigo
                           and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                           and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                           and ordem-compra.cod-refer    = c-cod-refer
                         no-lock no-error.

                    assign l-res-estabel = no.
                    for each  reservas no-lock
                        where reservas.it-codigo = tt-item.it-codigo
                          and reservas.cod-refer = c-cod-refer:

                        find ord-prod where
                             ord-prod.nr-ord-prod = reservas.nr-ord-prod
                             no-lock no-error.
                        if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                           ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                           assign l-res-estabel = yes.
                           leave.
                        end.
                    end.

                    find first ped-item
                         where ped-item.it-codigo = tt-item.it-codigo
                           and ped-item.cod-refer = c-cod-refer
                         no-lock no-error.
                    if avail ped-item then do:
                    
                       if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */  
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                                 and ped-venda.log-aprov-workflow
                               no-lock no-error.
                       else
                          find first ped-venda
                               where ped-venda.nome-abrev   = ped-item.nome-abrev
                                 and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                                 and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                  or ped-venda.cod-sit-aval = 3)
                                 and ped-venda.cod-estabel >= tt-param.c-estab-ini
                                 and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               no-lock no-error.
                        
                               
                    end.
                    else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                    if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                  


                    if avail saldo-estoq or
                       avail saldo-terc or
                       avail ord-prod or
                       l-ord-aber or
                       avail ordem-compra or
                       l-res-estabel or
                       avail ped-venda then do:
                       assign c-descricao   = tt-item.desc-item
                              c-cod-item    = tt-item.it-codigo
                              c-un          = tt-item.un
                              c-desc-cab    = c-descricao
                              de-saldo-inic = 0
                              de-saldo-terc = 0.                                                

                       find item where item.it-codigo = tt-item.it-codigo no-error.
                       if avail item then
                       run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                    end.
                end.
             end.
             else do:
                  assign c-cod-refer = "".
                  find first saldo-estoq
                       where saldo-estoq.it-codigo    = tt-item.it-codigo
                         and saldo-estoq.cod-estabel >= tt-param.c-estab-ini
                         and saldo-estoq.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first saldo-terc
                       where saldo-terc.it-codigo    = tt-item.it-codigo
                         and saldo-terc.cod-estabel >= tt-param.c-estab-ini
                         and saldo-terc.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ord-prod
                       where ord-prod.it-codigo    = tt-item.it-codigo
                         and ord-prod.cod-estabel >= tt-param.c-estab-ini
                         and ord-prod.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  find first ordem-compra
                       where ordem-compra.it-codigo    = tt-item.it-codigo
                         and ordem-compra.cod-estabel >= tt-param.c-estab-ini
                         and ordem-compra.cod-estabel <= tt-param.c-estab-fim
                       no-lock no-error.

                  assign l-res-estabel = no.
                  for each  reservas no-lock
                      where reservas.it-codigo = tt-item.it-codigo:

                      find ord-prod where
                           ord-prod.nr-ord-prod = reservas.nr-ord-prod
                           no-lock no-error.
                      if ord-prod.cod-estabel >= tt-param.c-estab-ini and
                         ord-prod.cod-estabel <= tt-param.c-estab-fim then do:
                         assign l-res-estabel = yes.
                         leave.
                      end.
                  end.

                  find first ped-item
                       where ped-item.it-codigo = tt-item.it-codigo no-lock no-error.
                  if avail ped-item then do:
                  
                     if l-aprova-wf then /* Desconsidera pedido n∆o aprovado no workflow de desconto */   
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                               and ped-venda.log-aprov-workflow
                             no-lock no-error.
                     else
                        find first ped-venda
                             where ped-venda.nome-abrev   = ped-item.nome-abrev
                               and ped-venda.nr-pedcli    = ped-item.nr-pedcli
                               and (ped-venda.cod-sit-aval = 2 or not tt-param.l-cred-aprov
                                or ped-venda.cod-sit-aval = 3)
                               and ped-venda.cod-estabel >= tt-param.c-estab-ini
                               and ped-venda.cod-estabel <= tt-param.c-estab-fim
                             no-lock no-error.
                  end.
                  else find ped-venda where
                              rowid (ped-venda) = ? no-lock no-error.

                  if can-find(first ord-aber 
                       where ord-aber.it-codigo = tt-item.it-codigo) then 
                       assign l-ord-aber = yes.                  

                  if avail saldo-estoq or
                     avail saldo-terc or
                     avail ord-prod or
                     avail ordem-compra or
                     l-res-estabel or
                     l-ord-aber or
                     avail ped-venda then do:
                     assign c-descricao   = tt-item.desc-item
                            c-cod-item    = tt-item.it-codigo
                            c-un          = tt-item.un
                            c-desc-cab    = c-descricao
                            de-saldo-inic = 0
                            de-saldo-terc = 0.                   

                     find item where item.it-codigo = tt-item.it-codigo no-error.
                     if avail item then
                     run pi-simulacao (buffer item,
                                         input  yes
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).

                  end.
             end.
         end. 

end procedure.

   /* pi-classifica-6 */  

/**************************************************************************
**
**  Include: CD0420.i13 - Procedure pi-processa-componentes
**
**************************************************************************/

procedure pi-processa-componentes.

    assign i-nivel        = 0
           c-ref-pai      = c-cod-refer
           l-controla-ref = (item.tipo-con-est = 4).
    run pi-navega-estrutura (input item.it-codigo).    

end procedure.

procedure pi-navega-estrutura.

    def input parameter c-it-codigo as char no-undo.

    define buffer b-estrutura for estrutura. 

    assign i-nivel = i-nivel + 1.
    
    if i-nivel < tt-param.i-niveis then do:    
       for each  b-estrutura 
           where b-estrutura.it-codigo    =  c-it-codigo
             and b-estrutura.data-inicio  <= tt-param.da-corte  
             and b-estrutura.data-termino >  tt-param.da-corte  no-lock,
           first b-item
           where b-item.it-codigo = b-estrutura.es-codigo no-lock:
           
           if l-controla-ref or b-item.tipo-con-est = 4 then 
              run cdp/cd9060.p (input b-estrutura.it-codigo,
                                input b-estrutura.sequencia,
                                input b-estrutura.es-codigo,
                                input c-ref-pai,
                                output l-util-item,
                                output c-ref-filho).
           else 
               assign l-util-item = yes
                      c-ref-filho = "".

           if l-util-item                                    and
              b-item.cod-estabel  >= tt-param.c-ci-estab-ini and
              b-item.cod-estabel  <= tt-param.c-ci-estab-fim and
              b-item.nr-linha     >= tt-param.i-ci-linha-ini and
              b-item.nr-linha     <= tt-param.i-ci-linha-fim and
              b-item.it-codigo    >= tt-param.c-ci-item-ini  and
              b-item.it-codigo    <= tt-param.c-ci-item-fim  and
              b-item.fm-codigo    >= tt-param.c-ci-fami-ini  and
              b-item.fm-codigo    <= tt-param.c-ci-fami-fim  and 
              b-item.cd-planejado >= tt-param.c-ci-plan-ini  and
              b-item.cd-planejado <= tt-param.c-ci-plan-fim  and
              b-item.ge-codigo    >= tt-param.i-ci-ge-ini    and  
              b-item.ge-codigo    <= tt-param.i-ci-ge-fim    and
              ((b-item.compr-fabric  = 1 and l-comp-comp)     or
              (b-item.compr-fabric  = 2 and l-comp-fabr)) then do:
              
              
                    if l-usa-unid-negoc then do:
                        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT b-item.cod-estabel,
                                                                 INPUT b-item.it-codigo,
                                                                 INPUT "",
                                                                 OUTPUT c-cod-unid-negoc).
                        if not (c-cod-unid-negoc >= tt-param.c-ci-cod-unid-negoc-ini
                           and  c-cod-unid-negoc <= tt-param.c-ci-cod-unid-negoc-fim) then
                           next. 
                   end.                                                                
              
              
              assign c-cod-refer = c-ref-filho
                     l-ref       = no.
              if not b-estrutura.fantasma then
                  run pi-simulacao (buffer b-item,
                                         input  no
                                         
                                            ,input l-usa-unid-negoc
                                         
                                         ).
              run pi-navega-estrutura (input b-item.it-codigo).
           end.

       end.
    end.

    assign i-nivel = i-nivel - 1.

end procedure.
  /* pi-processa-componentes */

/*****************************************************************************
**
**  I-RPVAR.I - Variaveis para Impressío do Cabecalho Padrío (ex-CD9500.I)
**
*****************************************************************************/

/*************************************************
* i_dbvers.i - Include de vers∆o de banco de dados   
**************************************************/

/* Preprocessadores que identificam os bancos do Produto EMS 5 */

/* Preprocessadores que identificam os bancos do Produto EMS 2 */
/*RAC Incorporado na 2.04*/

/* Preprocessadores que identificam os bancos do Produto HR 2 */

/* Fim */


 
/*************************************************
* i_prdvers.i - Include de vers„o do produto   
**************************************************/


/* Fim */

 

define var c-empresa       as character format "x(40)"      no-undo.
define var c-titulo-relat  as character format "x(50)"      no-undo.
define var c-sistema       as character format "x(25)"      no-undo.
define var i-numper-x      as integer   format "ZZ"         no-undo.
define var da-iniper-x     as date      format "99/99/9999" no-undo.
define var da-fimper-x     as date      format "99/99/9999" no-undo.
define var c-rodape        as character                     no-undo.
define var v_num_count     as integer                       no-undo.
define var c-arq-control   as character                     no-undo.
define var i-page-size-rel as integer                       no-undo.
define var c-programa      as character format "x(08)"      no-undo.
define var c-versao        as character format "x(04)"      no-undo.
define var c-revisao       as character format "999"        no-undo.
define var c-impressora    as character                     no-undo.
define var c-layout        as character                     no-undo.


define var i-nr-linha-pag             as integer            no-undo.
define var r-histor_impres            as rowid              no-undo.
define var i-page-counter-aux         as integer            no-undo.
define var i-page-counter             as integer            no-undo.
define var c-arquivo-ctl_imp          as character          no-undo.
define var l-indireta-ctl_imp         as logical            no-undo.
define var l-impresso-ctl_imp         as logical            no-undo.
define var c-destino-ctl_imp          as character          no-undo.
define var c-usuario-solic            as character          no-undo.
DEFINE VAR c-cod-usuar-exec           AS CHARACTER          NO-UNDO.
DEFINE VAR d-dat_inicial              AS DATE               NO-UNDO.
DEFINE VAR i-destino-relat            AS INTEGER            NO-UNDO.
DEFINE VAR tt-buffer-handle           AS HANDLE             NO-UNDO.
DEFINE VAR c-histor_impres_nom_impres AS CHARACTER          NO-UNDO.
DEFINE VAR c-histor_impres_nom_arq    AS CHARACTER          NO-UNDO.


/*Definiá‰es inclu°das para corrigir problema de vari†veis j† definidas pois */
/*as vari†veis e temp-tables eram definidas na include --rpout.i que pode ser*/
/*executada mais de uma vez dentro do mesmo programa (FO 1.120.458) */
/*11/02/2005 - EdÇsio <tech14207>*/
/*-------------------------------------------------------------------------------------------*/
DEF VAR h-procextimpr                               AS HANDLE   NO-UNDO. 
DEF VAR i-num_lin_pag                               AS INT      NO-UNDO.    
DEF VAR c_process-impress                           AS CHAR     NO-UNDO.   
DEF VAR c-cod_pag_carac_conver                      AS CHAR     NO-UNDO.   

/*tech14207
FO 1663218
Inclu°das as definiá‰es das vari†veis e funá‰es
*/

    /*tech868*/
    
        /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito validaá∆o para verificar se a variavel h_pdf_controller j† foi definida 
                                                       anteriormente, evitando erro de duplicidade*/

        
            DEFINE VARIABLE h_pdf_controller     AS HANDLE NO-UNDO.
    
                
            DEFINE VARIABLE v_cod_temp_file_pdf  AS CHAR   NO-UNDO.
    
            DEFINE VARIABLE v_cod_relat          AS CHAR   NO-UNDO.
            DEFINE VARIABLE v_cod_file_config    AS CHAR   NO-UNDO.
    
            FUNCTION allowPrint RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION allowSelect RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION useStyle RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION usePDF RETURNS LOGICAL IN h_pdf_controller.
       
            FUNCTION getPrintFileName RETURNS CHARACTER IN h_pdf_controller.
       
            RUN btb/btb920aa.p PERSISTENT SET h_pdf_controller.
        
        /*Alteracao 03/04/2008 - tech40260 - FO 1746516 -  Feito validaá∆o para verificar se a variavel h_pdf_controller j† foi definida 
                                                       anteriormente, evitando erro de duplicidade*/
    /*tech868*/
    

/*tech14207*/
/*tech30713 - fo:1262674 - Definiá∆o de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_inicio NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .

/*tech30713 - fo:1262674 - Definiá∆o de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_fim NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .
/*-------------------------------------------------------------------------------------------*/

define buffer b_ped_exec_style for ped_exec.
define buffer b_servid_exec_style for servid_exec.

    define new shared stream str-rp.

 
/* i-rpvar.i */
/*Alteraá∆o 20/07/2007 - tech1007 - Definiá∆o da vari†vel utilizada para impress∆o em PDF*/
DEFINE VARIABLE v_output_file        AS CHAR   NO-UNDO.

/*Fim alteraá∆o 20/07/2007*/
 


    IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).
    END.


/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "O_P",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[1] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "O_C*",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[2] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "O_C",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[3] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "O.S.",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[4] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Res",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[5] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "P_V",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[6] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "O_Pl",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[7] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "R_Pl",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[8] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Negativo",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[9] = trim (return-value).

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Abaixo_Qt_Segur",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-liter[10] = trim (return-value).

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

for each tt-digita where tt-digita.l-dep = YES NO-LOCK:
    create tt-depositos.
    assign tt-depositos.cod-estabel = tt-digita.c-estab
           tt-depositos.cod-depos   = tt-digita.c-depos.
    delete tt-digita.
end.

/* Cria 1 Registros para individualizacao do Processamento pelo rowid */

create tt-estoq.
assign c-tempo            = string(rowid(tt-estoq))
       tt-estoq.tempo     = c-tempo
       tt-estoq.dt-inicio = today
       tt-estoq.tipo      = "".

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "CD/0420RP".

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Simulaá∆o_do_Estoque",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-titulo-relat = trim(return-value).
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "CONTROLE_DA_PRODUÄ«O",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
assign c-sistema = trim(return-value).

/****************************************************************************
**
**  I-RPCAB.I - Form do Cabeáalho Padr∆o e RodapÇ, (ex-CD9500.F)
**                              
** {&STREAM} - indica o nome da stream (opcional)
****************************************************************************/

Define Variable vPagina  As Char No-undo.
Define Variable vPeriodo As Char No-undo.
Define Variable vTo As Char format "x(2)" No-undo.

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "P†gina:",
                    input "*",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
Assign vPagina = Return-value.

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Periodo:",
                    input "*",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
Assign vPeriodo = Return-value.

/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "a",
                    input "RPCAB",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
Assign vTo = Return-value.


    form header
        fill("-":U, 132) format "x(132)":U skip
        c-empresa c-titulo-relat at 50
        vPagina format "x(07)" at 121 page-number  at 128 format ">>>>9":U skip
        fill("-":U, 112) format "x(110)":U today format "99/99/9999":U
        "-":U string(time, "HH:MM:SS":U) skip(1)
        with stream-io width 132 no-labels no-box page-top frame f-cabec.
    
    form header
        fill("-":U, 132) format "x(132)":U skip
        c-empresa c-titulo-relat at 50
        vPagina  format "x(07)" at 121 page-number  at 128 format ">>>>9":U skip
        vPeriodo i-numper-x at 09 "-":U
        da-iniper-x at 14 vTo da-fimper-x
        fill("-":U, 74) format "x(72)":U today format "99/99/9999":U
        "-" string(time, "HH:MM:SS":U) skip(1)
        with stream-io width 132 no-labels no-box page-top frame f-cabper.



    
c-rodape = "DATASUL - ":U + c-sistema + " - ":U + c-prg-obj + " - V:":U + c-prg-vrs.
c-rodape = fill("-":U, 132 - length(c-rodape)) + c-rodape.

form header
    c-rodape format "x(132)":U
    with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

/* I-RPCAB.I */

 

/**************************************************************************
**
** I-RPOUT - Define sa°da para impress∆o do relat†rio - ex. cd9520.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
**             {&append} = append    
**             {&tofile} = nome da vari†vel ou campo com arquivo de destino
**             {&pagesize} = tamanho da pagina
**             {&codepage} = permite trocar o c¢digo de p†gina de destino do relat¢rio ou 
**                           para indicar que n∆o haver† convers∆o. Os valores poss°veis ser∆o "no-convert" 
**                           ou um c¢digo de p†gina v†lido para o Progress, por exemplo, iso-8859-1, utf-8, ibm850, etc. 
**                           Quando o parÉmetro n∆o for informado, ser† feita a convers∆o para o c¢digo de p†gina padr∆o - iso-8859-1.
***************************************************************************/

   /*As definiá‰es foram transferidas para a include i-rpvar.i (FO 1.120.458) */
   /*11/02/2005 - EdÇsio <tech14207>*/

   def new global shared var c-dir-spool-servid-exec as char no-undo.                     
   def new global shared var i-num-ped-exec-rpw as int no-undo.                           
                                                                                   
   /*variaveis processador externo impress∆o localizaá∆o*/


   /* procedimento necess†rio para permitir redirecionar saida para arquivo temporario no pdf sem aparecer na pagina de parametros */
   
   ASSIGN v_output_file = tt-param.arquivo.
   

   /*tech14178 inicio definiá‰es PDF */
   
   /*tech868*/   
   /*tech868*/
   IF NUM-ENTRIES(tt-param.arquivo,"|":U) > 1  THEN DO:
      ASSIGN v_cod_relat = ENTRY(2,tt-param.arquivo,"|":U).
      ASSIGN v_cod_file_config = ENTRY(3,tt-param.arquivo,"|":U).
      ASSIGN tt-param.arquivo = ENTRY(1,tt-param.arquivo,"|":U).
      
      RUN pi_prepare_permissions IN h_pdf_controller(INPUT v_cod_relat).
      RUN pi_set_format IN h_pdf_controller(INPUT IF v_cod_relat <> "":U THEN "PDF":U ELSE "Texto":U).
      RUN pi_set_file_config IN h_pdf_controller(INPUT  v_cod_file_config).
      
   END.

   IF usePDF() AND tt-param.destino = 2 THEN DO:
      IF entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U) <> "pdf" THEN
         assign tt-param.arquivo = replace(tt-param.arquivo,".":U + entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U),".pdf":U).
   END.

   IF usePDF() AND tt-param.destino <> 1 THEN /*tech14178 muda o nome do arquivo para salvar temporario quando n∆o Ç impressora*/
      ASSIGN v_output_file = tt-param.arquivo + ".pdt".

   /*tech868*/
   
   IF usePDF() AND tt-param.destino = 1  THEN /*pega arquivo tempor†rio randomico para ser usado como impressora */
      ASSIGN v_cod_temp_file_pdf = getPrintFileName().

   /*
    * Funcionalidade de Controle de Impressao
    * - Separar usuario responsavel pela impressao e solicitante da impressao.
    */
   IF NUM-ENTRIES(tt-param.usuario, CHR(1)) = 2 THEN DO:
      ASSIGN c-usuario-solic  = ENTRY(2, tt-param.usuario, CHR(1))
             tt-param.usuario = ENTRY(1, tt-param.usuario, CHR(1)).
   END.

   /***********************************************/

   /*
    * Funcionalidade de Controle de Impressao
    * - Tratamento para contagem do numero de paginas.
    */
   ASSIGN
   
      i-page-counter-aux = PAGE-NUMBER
   
      NO-ERROR.

   IF i-page-counter < i-page-counter-aux AND i-page-counter-aux <> ? THEN do:
      IF r-histor_impres <> ? THEN DO:
         DO TRANSACTION:
            FIND FIRST histor_impres EXCLUSIVE-LOCK
               WHERE ROWID(histor_impres) = r-histor_impres NO-ERROR.

            IF AVAILABLE histor_impres THEN DO:
               ASSIGN i-page-counter            = i-page-counter-aux
                      histor_impres.qti_pag_tot = i-page-counter.
               FIND CURRENT histor_impres NO-LOCK NO-ERROR.
            END.
         END.
      END.
   end.
   /***********************************************/
   

   /*tech14178 fim definiá‰es PDF */

   /*29/12/2004 - tech1007 - Verifica se o arquivo informado tem extensao rtf, se tiver troca para .lst*/
   

   /*************/
   
   /*
    * Atualizar a data e hora presente no nome do arquivo de sa°da (tt-param.arquivo). 
    * Se o relat¢rio estiver executando em RPW (i-num-ped-exec-rpw > 0), acrescentar o n£mero do pedido no nome do arquivo.
    */
   
   ASSIGN c-arquivo-ctl_imp = tt-param.arquivo.
   

   IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3  THEN DO:
      IF i-num-ped-exec-rpw = 0 THEN DO:
         FIND FIRST histor_impres NO-LOCK 
              WHERE histor_impres.nom_arq = SUBSTRING(c-arquivo-ctl_imp ,R-INDEX(c-arquivo-ctl_imp ,":") + 1) NO-ERROR.
         IF AVAIL histor_impres THEN DO:
            ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".")) 
               + STRING(TODAY,"99999999") 
               + STRING(TIME,"99999") 
               + SUBSTRING(c-arquivo-ctl_imp, INDEX(c-arquivo-ctl_imp, STRING(YEAR(TODAY))) + 9).
         END.
      END.
      ELSE DO:
         IF SUBSTRING(c-arquivo-ctl_imp, LENGTH(c-arquivo-ctl_imp) - 3, 1) = "." THEN DO:
            IF SUBSTRING(c-arquivo-ctl_imp, LENGTH(c-arquivo-ctl_imp) - 3, 4) = ".prn" THEN
               ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp,1, R-INDEX(c-arquivo-ctl_imp,".") - 1) + STRING(i-num-ped-exec-rpw) +  ".prn".
            ELSE
               ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".") - 1) 
                  + STRING(i-num-ped-exec-rpw) 
                  + SUBSTRING(c-arquivo-ctl_imp,LENGTH(c-arquivo-ctl_imp) - 3).
         END.
         ELSE DO:
            ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp, 1, R-INDEX(c-arquivo-ctl_imp,".")) 
               + STRING(TODAY,"99999999") 
               + STRING(TIME,"99999") 
               + SUBSTRING(c-arquivo-ctl_imp, INDEX(c-arquivo-ctl_imp, STRING(YEAR(TODAY))) + 9) 
               + STRING(i-num-ped-exec-rpw).
         END.
      END.
   END.
   
   /*
    * Quanto Ö pasta de destino do arquivo de sa°da: para impress‰es usando impressora, e direcionadas a arquivo, h† o seguinte comportamento:
    *    - Impress∆o on-line: Quando n∆o possuir caminho informado, o arquivo ser† gravado num diret¢rio que ser† a combinaá∆o do diret¢rio e subdiret¢rio 
    *                         de spool do cadastro do usu†rio, a exemplo do que ocorre quando a sa°da do relat¢rio Ç "arquivo". 
    *    - Impress∆o batch: 
    *       - Arquivo ser† gravado num diret¢rio que ser† a combinaá∆o do diret¢rio de spool do servidor RPW com o subdiret¢rio de spool RPW do usu†rio emissor.
    *          - Quando a impressora for do tipo "em escala", o subdiret¢rio do usu†rio deve ser desconsiderado. Verificar nos parÉmetros gerais do m¢dulo B†sico 
    *            se o recurso est† ativado e no cadastro da impressora se a mesma est† apta para impress∆o em escala.
    */
   IF tt-param.destino = 1 THEN DO: /* destino impressora */
      IF i-num-ped-exec-rpw = 0 THEN DO: /* impressao on-line */
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3 THEN DO: /* impressao direcionada para arquivo */
            IF INDEX(c-arquivo-ctl_imp, "~/") = 0 THEN DO: /* caminho nao informado */
               FIND FIRST usuar_mestre NO-LOCK
                  WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-ERROR.
               IF AVAIL usuar_mestre THEN DO:
                  ASSIGN c-arquivo-ctl_imp = SUBSTRING(c-arquivo-ctl_imp,1,LENGTH(c-arquivo-ctl_imp) - LENGTH(ENTRY(3,c-arquivo-ctl_imp,":")))
                     + usuar_mestre.nom_dir_spool 
                     + usuar_mestre.nom_subdir_spool  
                     + "~/"
                     + SUBSTRING(c-arquivo-ctl_imp,LENGTH(c-arquivo-ctl_imp) - LENGTH(ENTRY(3,c-arquivo-ctl_imp,":")) + 1).
               END.
            END.
         END.
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":") = 4 THEN DO:
            /* caminho do arquivo informado e nenhuma acao sera tomada */
         END.
      END.
      ELSE DO: /* impressao em batch */
         IF (NUM-ENTRIES(c-arquivo-ctl_imp,":") = 3 OR  /* impressao direcionada para arquivo */
             NUM-ENTRIES(c-arquivo-ctl_imp,":") = 4) AND /* impressao direcionada para arquivo com caminho informado */ 
            INDEX(c-arquivo-ctl_imp,"~/") <> 0 THEN DO: /* caminho informado */
            /* desconsiderando caminho informado */
            ASSIGN c-arquivo-ctl_imp = ENTRY(1,c-arquivo-ctl_imp,":") 
                                             + ":"
                                             + ENTRY(2,c-arquivo-ctl_imp,":")
                                             + ":"
                                             + SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,"~/") + 1).

            FIND FIRST impressora NO-LOCK
               WHERE impressora.nom_impressora = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":") - 1) NO-ERROR.
            IF AVAIL impressora THEN DO:
               FIND FIRST usuar_mestre NO-LOCK
                  WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-ERROR.
               IF AVAIL usuar_mestre THEN DO:
                  IF NOT impressora.log_impres_escal THEN  /* impressora normal */
                     ASSIGN c-dir-spool-servid-exec = c-dir-spool-servid-exec 
                        + "~/"
                        + usuar_mestre.nom_subdir_spool_rpw.
               END.
            END.
         END.
      END.
   END.
   
   
   ASSIGN tt-param.arquivo = c-arquivo-ctl_imp.
   
   
   
   /*************/

   if  tt-param.destino = 1 then do:
      
      if num-entries(tt-param.arquivo,":") = 2 then do:
      
      
         assign c-impressora = substring(tt-param.arquivo,1,index(tt-param.arquivo,":") - 1).
         assign c-layout     = substring(tt-param.arquivo,index(tt-param.arquivo,":") + 1,length(tt-param.arquivo) - index(tt-param.arquivo,":")). 
      

         find layout_impres no-lock
            where layout_impres.nom_impressora    = c-impressora
            and   layout_impres.cod_layout_impres = c-layout no-error.
         find imprsor_usuar no-lock
            where imprsor_usuar.nom_impressora = c-impressora
            and   imprsor_usuar.cod_usuario    = tt-param.usuario
            use-index imprsrsr_id no-error.
         find impressora  of imprsor_usuar no-lock no-error.
         find tip_imprsor of impressora    no-lock no-error.

         /*Alterado 26/04/2005 - tech1007 - Alterado para n∆o ocasionar problemas na convers∆o do mapa de caracteres*/
         IF AVAILABLE tip_imprsor THEN DO:
            ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
         END.
         IF AVAILABLE layout_impres THEN DO:
            ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
         END.
         /*Fim alteracao - tech1007*/

         
         
         ASSIGN c_process-impress = impressora.cod_livre_1.
         
         IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
               /*verifica se o programa j† est† sendo executado, 
                 caso o encontre na mem¢ria usa o mesmo handle */
               h-procextimpr = SESSION:LAST-PROCEDURE.
               REPEAT:
                  IF VALID-HANDLE(h-procextimpr) AND 
                     h-procextimpr:TYPE = "PROCEDURE" AND 
                     h-procextimpr:FILE-NAME = c_process-impress 
                     THEN LEAVE.                       
                  h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                  IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
               END.
               IF NOT VALID-HANDLE(h-procextimpr) THEN
                  RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
         END.
         
         if  i-num-ped-exec-rpw <> 0 then do:
            find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
            find b_servid_exec_style of b_ped_exec_style no-lock no-error.
            find servid_exec_imprsor of b_servid_exec_style
               where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.
            if available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
            then do:
               ASSIGN i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  output  through value(v_cod_temp_file_pdf)
                     page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                  RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
               END.
               ELSE
               
                  output  through value(servid_exec_imprsor.nom_disposit_so)
                     page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* if */.
            else do:
               /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
               ASSIGN c-arq-control = servid_exec_imprsor.nom_disposit_so.
               /*Fim alteracao 26/04/2005*/

               IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
                  RUN pi_before_output IN h-procextimpr 
                     (INPUT c-impressora,
                      INPUT c-layout,
                      INPUT tt-param.usuario,
                      INPUT-OUTPUT c-arq-control,
                      INPUT-OUTPUT i-num_lin_pag,
                      INPUT-OUTPUT c-cod_pag_carac_conver).

               ASSIGN i-nr-linha-pag = i-num_lin_pag. /* armazena qtd de linhas por pagina */
            
               /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  output   to value(v_cod_temp_file_pdf)
                     page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
                  RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
               END.
               ELSE
               
                  output   to value(c-arq-control)
                     page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
            end /* else */.
         end.
         else do:
            /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
            ASSIGN c-arq-control = imprsor_usuar.nom_disposit_so.
            /*Fim alteracao 26/04/2005*/

            IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
               RUN pi_before_output IN h-procextimpr 
               (INPUT c-impressora,
                INPUT c-layout,
                INPUT tt-param.usuario,
                INPUT-OUTPUT c-arq-control,
                INPUT-OUTPUT i-num_lin_pag,
                INPUT-OUTPUT c-cod_pag_carac_conver).

            if i-num_lin_pag = 0 then do:
               ASSIGN i-nr-linha-pag = 0. /* armazena qtd de linhas por pagina */
               /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  /* sem salta p†gina */
                  output   
                     to value(v_cod_temp_file_pdf)
                     page-size 0
                     convert target c-cod_pag_carac_conver . 
                  RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
               END.
               ELSE
               
                  /* sem salta p†gina */
                  output   
                     to value(c-arq-control)
                     page-size 0
                     convert target c-cod_pag_carac_conver . 
            end.
            else do:
               ASSIGN i-nr-linha-pag = i-num_lin_pag. /* armazena qtd de linhas por pagina */
               /*tech14178 joga para arquivo a ser convertido para PDF */
               IF usePDF() THEN DO:
                  /* sem salta p†gina */
                  output   
                     to value(v_cod_temp_file_pdf)
                     paged page-size value(i-num_lin_pag) 
                     convert target c-cod_pag_carac_conver .
                  RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
               END.
               ELSE
               
                  /* com salta p†gina */
                  output  
                     to value(c-arq-control)
                     paged page-size value(i-num_lin_pag) 
                     convert target c-cod_pag_carac_conver .
            end.
         end.

         for each configur_layout_impres NO-LOCK 
            where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
               by configur_layout_impres.num_ord_funcao_imprsor:

            find configur_tip_imprsor no-lock
               where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
               and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
               and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
               use-index cnfgrtpm_id no-error.
            CREATE tt-configur_layout_impres_inicio.    
            BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
         end.

         IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
            RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

         FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
            BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
            do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):            
               case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                  when 0 then put  control null.
                  when ? then leave.
                  otherwise   put  control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                                     session:cpinternal, 
                                                                     c-cod_pag_carac_conver).
               end case.
            end.
            DELETE tt-configur_layout_impres_inicio.
         END.
      end.
      else do:
         
         assign c-impressora  = entry(1,tt-param.arquivo,":").
         assign c-layout      = entry(2,tt-param.arquivo,":"). 
         if num-entries(tt-param.arquivo,":") = 4 then
            assign c-arq-control = entry(3,tt-param.arquivo,":") + ":" + entry(4,tt-param.arquivo,":").
         else 
            assign c-arq-control = entry(3,tt-param.arquivo,":").
         

         find layout_impres no-lock
            where layout_impres.nom_impressora    = c-impressora
            and   layout_impres.cod_layout_impres = c-layout no-error.
         find imprsor_usuar no-lock
            where imprsor_usuar.nom_impressora = c-impressora
            and   imprsor_usuar.cod_usuario    = tt-param.usuario
            use-index imprsrsr_id no-error.
         find impressora  of imprsor_usuar no-lock no-error.
         find tip_imprsor of impressora    no-lock no-error.

         /*Alterado 26/04/2005 - tech1007 - Alterado para n∆o ocasionar problemas na convers∆o do mapa de caracteres*/
         IF AVAILABLE tip_imprsor THEN DO:
            ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
         END.
         IF AVAILABLE layout_impres THEN DO:
            ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
         END.
         /*Fim alteracao - tech1007*/

         
         
         ASSIGN c_process-impress = impressora.cod_livre_1.
         
         IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
               /*verifica se o programa j† est† sendo executado, 
                 caso o encontre na mem¢ria usa o mesmo handle */
               h-procextimpr = SESSION:LAST-PROCEDURE.
               REPEAT:
                  IF VALID-HANDLE(h-procextimpr) AND 
                     h-procextimpr:TYPE = "PROCEDURE" AND 
                     h-procextimpr:FILE-NAME = c_process-impress 
                     THEN LEAVE.                       
                  h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                  IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
               END.
               IF NOT VALID-HANDLE(h-procextimpr) THEN
                  RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
         END.
         
    
         /*tech14178 adiciona extens∆o PDT para que o arquivo a ser convertido n∆o fique com o mesmo nome do arquivo final*/
         IF usePDF() THEN 
            ASSIGN c-arq-control = c-arq-control + ".pdt":U.
         
      
         if  i-num-ped-exec-rpw <> 0 then do:
            find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
            find b_servid_exec_style of b_ped_exec_style no-lock no-error.
            find servid_exec_imprsor of b_servid_exec_style 
               where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.
            if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
            then do:
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output  to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                  page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* if */.
            else do:
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output   to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                  page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
            end /* else */.
         end.
         else do:
            /*Alterado 26/04/2005 - tech1007 - Removido pois o assign est† sendo realizado antes dos testes
            ASSIGN 
            i-num_lin_pag = layout_impres.num_lin_pag
            c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
            Fim alteracao 26/04/2005*/    

            IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
               RUN pi_before_output IN h-procextimpr 
                  (INPUT c-impressora,
                   INPUT c-layout,
                   INPUT tt-param.usuario,
                   INPUT-OUTPUT c-arq-control,
                   INPUT-OUTPUT i-num_lin_pag,
                   INPUT-OUTPUT c-cod_pag_carac_conver).
            if i-num_lin_pag = 0 then do:
               /* sem salta p†gina */
               output   
                  to value(c-arq-control)
                  page-size 0
                  convert target c-cod_pag_carac_conver . 
            end.
            else do:
               /* com salta p†gina */
               assign i-nr-linha-pag = layout_impres.num_lin_pag. /* armazena qtd de linhas por pagina */
               output  
                  to value(c-arq-control)
                  paged page-size value(layout_impres.num_lin_pag) 
                  convert target tip_imprsor.cod_pag_carac_conver.
            end.
         end.

         /*tech14178 guarda o nome do arquivo a ser convertido para pdf  */
         if  i-num-ped-exec-rpw <> 0 THEN
            RUN pi_set_print_filename IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + c-arq-control).
         ELSE
            RUN pi_set_print_filename IN h_pdf_controller (INPUT c-arq-control).
         
         
         for each configur_layout_impres NO-LOCK 
            where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
               by configur_layout_impres.num_ord_funcao_imprsor:

            find configur_tip_imprsor no-lock
               where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                 and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                 and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                 use-index cnfgrtpm_id no-error.
            CREATE tt-configur_layout_impres_inicio.    
            BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
         end.

         IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN                
            RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

         FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
               BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
            do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):
               case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                  when 0 then put  control null.
                  when ? then leave.
                  otherwise   put  control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                                     session:cpinternal, 
                                                                     c-cod_pag_carac_conver).
               end case.
            end.
            DELETE tt-configur_layout_impres_inicio.
         END.
      end.  
   end.
   else do: /* if  tt-param.destino = 1 then do: */
      
      if  i-num-ped-exec-rpw <> 0 then do:
      
         /*Alterado 14/02/2005 - tech1007 - Alterado para que quando for gerar RTF em batch
           o tamanho da p†gina seja 42*/
      
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output  
            to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
            paged page-size 64
            
            convert target "iso8859-1" .
            
         
         /*Fim alteracao 14/02/2005*/
      
      end.
      else do:
      /* Sa°da para RTF - tech981 20/10/2004 */
      
      
         assign i-nr-linha-pag = 64. /* armazena qtd de linhas por pagina */
         output  
            to value(v_output_file) 
            paged page-size 64 
            
            convert target "iso8859-1" .                
            
         
         
      end.    
         
   end.

/* i-rpout */
  
IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "cd0420.csv".
        
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "cd0420.csv".
    END.

END. 

view frame f-cabec.
view frame f-rodape.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

PUT STREAM str-excel 
    UNFORMATTED 'Item;Descricao;Qtde Segur;Un;Ref;Tipo;Saldo Inicial;Referencia;Quantidade;Dt In°cio;Dt Termino;Dispon°vel;Observacao U.Neg;Acao Anterior' SKIP.

run utp/ut-acomp.p persistent set h-acomp.
/**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Simulaá∆o_de_Estoque",
                    input "*",
                    input "") no-error.
                    
                    
/* ut-liter.i */                    
 
run pi-inicializar in h-acomp (input  Return-value ).


if can-find (first tt-digita) then
   run pi-digitacao.
else do:
     case tt-param.classifica:
          when 1 then run pi-classifica-1.
          when 2 then run pi-classifica-2.
          when 3 then run pi-classifica-3.
          when 4 then run pi-classifica-4.     
          when 5 then run pi-classifica-5.
          when 6 then run pi-classifica-6.          
     end case.
end.
if l-impr-parametro =  yes then do:

    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Seleá∆o_de_Itens",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-tit[1] = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Seleá∆o_dos_Componentes_do_Item",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-tit[2] = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Estabelecimento",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-est[1] = trim(return-value)
           c-lb-est[2] = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Linha_Produá∆o",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-lin[1] = trim(return-value)
           c-lb-lin[2] = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Destino",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-dest = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Usu†rio",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-usuar = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Comprados",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-compr = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Fabricados",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-fabr = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Plano",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-plano = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Ordens_Planejadas",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-ord-pla = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Ordens_de_Compra",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-ord-com = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Ordens_de_Produá∆o",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-ord-pro = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Reservas_Comprometidas",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-res-com = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Reservas_Planejadas",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-res-pla = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldos_em_Estoque",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-sld-est = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Saldos_em_Poder_de_Terceiros",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-sld-ter = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Remessa_para_Beneficiamento",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-remessa = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Entrada_para_Beneficiamento",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-entrada = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Transferància",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-transfer = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Remessa_em_Consignaá∆o",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-re-con = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Entrada_em_Consignaá∆o",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-en-con = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Pedidos_em_Carteira",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-ped-crt = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Itens_sem_Reservas/Ordens",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-it-mov = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Componentes_do_Item",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-comp = trim(return-value).
    
            /*************************************************************
**
**  UT-FIELD.I - Chamada Padr∆o para UT-FIELD.P que retornar†
**               as propriedades do campo.
**                                        
*************************************************************/

run utp/ut-field.p (input "mgind":U, 
                    input "unid-negoc":U, 
                    input "cod-unid-negoc":U, 
                    input integer("1":U)).

/* ut-field.i */
 
            assign c-cod-unid-negoc = trim(return-value).
    
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Apenas_Pedidos_com_CrÇditos_Aprovados",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-cred-apr = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Informa_Dep¢sitos",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-inf-dep = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Obsoleto",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-obsol = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Formato",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-form = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "N£mero_de_N°veis_a_Listar",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-nivel = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Data_de_Corte",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-corte = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Data_de_Corte_para_Ordens_Planejadas",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-op = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Ordem_Compra_Beneficiamento",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-benef = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "Tipo",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-tipo = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "SELEÄ«O",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-sel = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "CLASSIFICAÄ«O",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-cla = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "PAR∂METROS",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-par = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "IMPRESS«O",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-imp = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "DIGITAÄ«O",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-dig = trim(return-value).
    /**********************************************************************
**
**  UT-LITER.I - Chamada pardr∆o para UT-LITER.P
**
*********************************************************************/

run utp/ut-liter.p (input "DEP‡SITOS",
                    input "*",
                    input "r") no-error.
                    
                    
/* ut-liter.i */                    
 
    assign c-lb-dep = trim(return-value).

    page.

    hide all no-pause.

    view frame f-cabec.
    view frame f-rodape.

    put unformatted c-lb-par skip(1).

    assign l-param = tt-param.l-comprado.
    put c-compr    at 33 format "x(9)"  ": " l-param.
    assign l-param = tt-param.l-fabricado.
    put c-fabr     at 32 format "x(10)" ": " l-param.
    assign l-param = tt-param.l-planejada.
    put c-ord-pla  at 25 format "x(17)" ": " l-param.
    assign l-param = tt-param.l-ord-com.
    put c-ord-com  at 26 format "x(16)" ": " l-param.
    assign l-param = tt-param.l-ord-prod.
    put c-ord-pro  at 24 format "x(18)" ": " l-param.
    assign l-param = tt-param.l-res-com.
    put c-res-com  at 20 format "x(22)" ": " l-param.
    assign l-param = tt-param.l-res-pla.
    put c-res-pla  at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-sld-est.
    put c-sld-est  at 25 format "x(17)" ": " l-param.
    assign l-param = tt-param.l-sld-ter.
    put c-sld-ter  at 14 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-remessa.
    put c-remessa  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-entrada.
    put c-entrada  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-transfer.
    put c-transfer  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-re-con.
    put c-re-con  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-en-con.
    put c-en-con  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-ped-crt.
    put c-ped-crt  at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-it-sem-mov.
    put c-it-mov   at 17 format "x(25)" ": " l-param.
    assign l-param = tt-param.l-componente.
    put c-comp     at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-comp-comp.
    put c-compr    at 51 format "x(9)"  ": " l-param.
    assign l-param = tt-param.l-comp-fabr.
    put c-fabr     at 50 format "x(10)" ": " l-param.
    assign l-param = tt-param.l-cred-aprov.
    put c-cred-apr at 5  format "x(37)" ": " l-param.
    assign l-param = tt-param.l-deposito.
    put c-inf-dep  at 25 format "x(17)" ": " l-param skip(1).


    if  tt-param.l-deposito then do:
        put unformatted c-lb-dep at 29 skip(1).
        for each tt-depositos:
            disp tt-depositos.cod-estabel at 30
                 tt-depositos.cod-depos
                 with stream-io no-box width 132 down frame f-depositos.
            down with frame f-depositos.
        end.
        put skip(1).
    end.

    
        if l-usa-unid-negoc then do:
            put unformatted
                    c-lb-plano   at 37 ": " tt-param.i-cod-plano
                    c-lb-obsol   at 34 ": " tt-param.c-obsoleto
                    c-lb-form    at 35 ": " tt-param.c-formato
                    c-lb-nivel   at 17 ": " tt-param.i-niveis
                    c-lb-corte   at 29 ": " tt-param.da-corte
                    c-lb-op      at 6  ": " tt-param.da-op-corte
                    c-lb-benef   at 15 ": " tt-param.c-beneficio
                    c-lb-tipo    at 38 ": " tt-param.c-tipo skip(1)
                    c-lb-sel     skip(1)
                    c-lb-tit[1]  at 5  skip(1)
                    c-lb-est[1]  at 10 ": " tt-param.c-estab-ini    "|<  >| " at 44 tt-param.c-estab-fim
                    c-lb-lin[1]  at 11 ": " tt-param.i-linha-ini    "|<  >| " at 44 tt-param.i-linha-fim
                    c-lb-item[1] at 21 ": " tt-param.c-item-ini     "|<  >| " at 44 tt-param.c-item-fim
                    c-lb-fam[1]  at 18 ": " tt-param.c-fami-ini     "|<  >| " at 44 tt-param.c-fami-fim
                    c-lb-plan[1] at 15 ": " tt-param.c-plan-ini     "|<  >| " at 44 tt-param.c-plan-fim
                    c-lb-ge[1]   at 12 ": " tt-param.i-ge-ini       "|<  >| " at 44 tt-param.i-ge-fim
                    c-lb-comp[1] at 16 ": " tt-param.c-comp-ini     "|<  >| " at 44 tt-param.c-comp-fim
                    c-lb-cod-unid-negoc[1] at 10 ": " tt-param.c-cod-unid-negoc-ini "|<  >| " at 44 tt-param.c-cod-unid-negoc-fim skip(1)
                    c-lb-tit[2]  at 5  skip(1)
                    c-lb-est[2]  at 10 ": " tt-param.c-ci-estab-ini "|<  >| " at 44 tt-param.c-ci-estab-fim
                    c-lb-lin[2]  at 11 ": " tt-param.i-ci-linha-ini "|<  >| " at 44 tt-param.i-ci-linha-fim
                    c-lb-item[2] at 21 ": " tt-param.c-ci-item-ini  "|<  >| " at 44 tt-param.c-ci-item-fim
                    c-lb-fam[2]  at 18 ": " tt-param.c-ci-fami-ini  "|<  >| " at 44 tt-param.c-ci-fami-fim
                    c-lb-plan[2] at 15 ": " tt-param.c-ci-plan-ini  "|<  >| " at 44 tt-param.c-ci-plan-fim
                    c-lb-ge[2]   at 12 ": " tt-param.i-ci-ge-ini    "|<  >| " at 44 tt-param.i-ci-ge-fim
                    c-lb-comp[2] at 16 ": " tt-param.c-ci-comp-ini  "|<  >| " at 44 tt-param.c-ci-comp-fim
                    c-lb-cod-unid-negoc[2] at 10 ": " tt-param.c-ci-cod-unid-negoc-ini "|<  >| " at 44 tt-param.c-ci-cod-unid-negoc-fim.
        end.
        else do:
    

        put unformatted
            c-lb-plano   at 37 ": " tt-param.i-cod-plano
            c-lb-obsol   at 34 ": " tt-param.c-obsoleto
            c-lb-form    at 35 ": " tt-param.c-formato
            c-lb-nivel   at 17 ": " tt-param.i-niveis
            c-lb-corte   at 29 ": " tt-param.da-corte
            c-lb-op      at 6  ": " tt-param.da-op-corte
            c-lb-benef   at 15 ": " tt-param.c-beneficio
            c-lb-tipo    at 38 ": " tt-param.c-tipo skip(1)
            c-lb-sel     skip(1)
            c-lb-tit[1]  at 5  skip(1)
            c-lb-est[1]  at 10 ": " tt-param.c-estab-ini    "|<  >| " at 44 tt-param.c-estab-fim
            c-lb-lin[1]  at 11 ": " tt-param.i-linha-ini    "|<  >| " at 44 tt-param.i-linha-fim
            c-lb-item[1] at 21 ": " tt-param.c-item-ini     "|<  >| " at 44 tt-param.c-item-fim
            c-lb-fam[1]  at 18 ": " tt-param.c-fami-ini     "|<  >| " at 44 tt-param.c-fami-fim
            c-lb-plan[1] at 15 ": " tt-param.c-plan-ini     "|<  >| " at 44 tt-param.c-plan-fim
            c-lb-ge[1]   at 12 ": " tt-param.i-ge-ini       "|<  >| " at 44 tt-param.i-ge-fim
            c-lb-comp[1] at 16 ": " tt-param.c-comp-ini     "|<  >| " at 44 tt-param.c-comp-fim skip(1)
            c-lb-tit[2]  at 5  skip(1)
            c-lb-est[2]  at 10 ": " tt-param.c-ci-estab-ini "|<  >| " at 44 tt-param.c-ci-estab-fim
            c-lb-lin[2]  at 11 ": " tt-param.i-ci-linha-ini "|<  >| " at 44 tt-param.i-ci-linha-fim
            c-lb-item[2] at 21 ": " tt-param.c-ci-item-ini  "|<  >| " at 44 tt-param.c-ci-item-fim
            c-lb-fam[2]  at 18 ": " tt-param.c-ci-fami-ini  "|<  >| " at 44 tt-param.c-ci-fami-fim
            c-lb-plan[2] at 15 ": " tt-param.c-ci-plan-ini  "|<  >| " at 44 tt-param.c-ci-plan-fim
            c-lb-ge[2]   at 12 ": " tt-param.i-ci-ge-ini    "|<  >| " at 44 tt-param.i-ci-ge-fim
            c-lb-comp[2] at 16 ": " tt-param.c-ci-comp-ini  "|<  >| " at 44 tt-param.c-ci-comp-fim.
    
    
        end.
    
    
    if  line-counter > 40 then page.
    put unformatted
        c-lb-cla     skip(1)   tt-param.c-classe at 5 skip(1)
        c-lb-imp     skip(1)
        c-lb-dest    at 5 ": " tt-param.c-destino " - " tt-param.arquivo
        c-lb-usuar   at 5 ": " tt-param.usuario.

    if  can-find(first tt-digita where not tt-digita.l-dep) then
        put unformatted skip(1) c-lb-dig skip(1).

    for each tt-digita where not tt-digita.l-dep NO-LOCK:
        disp tt-digita.c-it-codigo at 5
             tt-digita.c-cod-refer
             tt-digita.c-desc-item
             tt-digita.c-un
             tt-digita.fm-codigo
             tt-digita.cd-planejado
             tt-digita.ge-codigo
             with stream-io no-box width 132 down frame f-digita.
        down with frame f-digita.
    end.
end.


    if l-usa-unid-negoc then
        IF VALID-HANDLE(h-cdapi024) THEN DO:
                    DELETE PROCEDURE h-cdapi024.
                    ASSIGN h-cdapi024 = ?.
        END.


run pi-finalizar in h-acomp.


    IF VALID-HANDLE(h-cpapi020) THEN
        DELETE PROCEDURE h-cpapi020.


/**************************************************************************
**
** I-RPCLO - Define sa°da para impress∆o do relat¢rio - ex. cd9540.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
***************************************************************************/
IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
   RUN pi_before_close IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_fim).

FOR EACH tt-configur_layout_impres_fim EXCLUSIVE-LOCK
    BY tt-configur_layout_impres_fim.num_ord_funcao_imprsor :
    do v_num_count = 1 to extent(tt-configur_layout_impres_fim.num_carac_configur):
      case tt-configur_layout_impres_fim.num_carac_configur[v_num_count]:
        when 0 then put  control null.
        when ? then leave.
        OTHERWISE PUT  control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_fim.num_carac_configur[v_num_count]),
                                                         session:cpinternal, 
                                                         c-cod_pag_carac_conver).
      end CASE.
    END.
    DELETE tt-configur_layout_impres_fim.
END.

/* N∆o gerar p†gina em branco - tech14207 11/02/2005 */


/* Controle de impressao */
IF CAN-FIND(FIRST param_extens_ems 
            WHERE param_extens_ems.cod_entid_param_ems = "histor_impres"
              AND param_extens_ems.cod_chave_param_ems = "histor_impres"
              AND param_extens_ems.cod_param_ems       = "log_histor_impres"
              AND param_extens_ems.log_param_ems       = YES) THEN DO:

   CREATE BUFFER tt-buffer-handle FOR TABLE ("tt-param") NO-ERROR.
   IF VALID-HANDLE(tt-buffer-handle) THEN DO:
      tt-buffer-handle:FIND-FIRST NO-ERROR.
      ASSIGN c-cod-usuar-exec = tt-buffer-handle:BUFFER-FIELD("usuario"):BUFFER-VALUE
             d-dat_inicial    = tt-buffer-handle:BUFFER-FIELD("data-exec"):BUFFER-VALUE
             i-destino-relat  = tt-buffer-handle:BUFFER-FIELD("destino"):BUFFER-VALUE
         NO-ERROR.
   END.

   IF i-destino-relat = 1 /*tt-param.destino = 1*/ THEN DO:
      IF (NUM-ENTRIES(c-arquivo-ctl_imp, ":":U) >= 3) THEN DO:
         ASSIGN l-indireta-ctl_imp = TRUE
                l-impresso-ctl_imp = FALSE
                c-histor_impres_nom_impres = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":":u) - 1).
         IF NUM-ENTRIES(c-arquivo-ctl_imp,":":U) = 3 THEN
            ASSIGN c-histor_impres_nom_arq = SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,":":U) + 1).
         ELSE
            ASSIGN c-histor_impres_nom_arq = SUBSTRING(c-arquivo-ctl_imp,R-INDEX(c-arquivo-ctl_imp,":":U) - 1).
      END.
      ELSE
          ASSIGN l-indireta-ctl_imp = FALSE
                 l-impresso-ctl_imp = TRUE
                 c-histor_impres_nom_impres = SUBSTRING(c-arquivo-ctl_imp,1,INDEX(c-arquivo-ctl_imp,":") - 1).
      
   END.
   ELSE
      ASSIGN l-indireta-ctl_imp = FALSE
             l-impresso-ctl_imp = FALSE
             c-histor_impres_nom_impres  = c-arquivo-ctl_imp.
   
   IF d-dat_inicial = ? THEN
      ASSIGN d-dat_inicial = TODAY.

   IF TRIM(c-usuario-solic) = "" THEN DO:

      /* Funcionalidade de Controle de Impressao
       * - Separar usuario responsavel pela impressao e solicitante da impressao. */
      IF NUM-ENTRIES(c-cod-usuar-exec, CHR(1)) = 2 THEN DO:
          ASSIGN c-usuario-solic  = ENTRY(2, c-cod-usuar-exec, CHR(1))
                 c-cod-usuar-exec = ENTRY(1, c-cod-usuar-exec, CHR(1)).
      END.
      ELSE DO:
          ASSIGN c-usuario-solic = c-cod-usuar-exec.
      END.
      /***********************************************/
   END.

   IF NOT CAN-FIND(FIRST histor_impres
                   WHERE histor_impres.dat_inicial = d-dat_inicial
                     AND histor_impres.nom_impressora = c-histor_impres_nom_impres
                     AND histor_impres.nom_arq = c-histor_impres_nom_arq
                     AND histor_impres.cod_prog_dtsul = c-prg-obj
                     AND histor_impres.cod_usuar_exec = c-cod-usuar-exec
                     AND histor_impres.dat_efetivac_impres = TODAY) THEN
      DO TRANSACTION:

         CREATE histor_impres.
         ASSIGN histor_impres.cod_usuar_exec      = c-cod-usuar-exec /* tt-param.usuario */
                histor_impres.cod_usuar_abert     = c-usuario-solic  
                histor_impres.qti_pag_tot         = i-page-counter
                histor_impres.dat_inicial         = d-dat_inicial    /* tt-param.data-exec */
                histor_impres.dat_efetivac_impres = TODAY
                histor_impres.cod_prog_dtsul      = c-prg-obj
                histor_impres.nom_tit_prog        = c-titulo-relat
                histor_impres.log_impressora      = l-impresso-ctl_imp
                histor_impres.nom_impressora      = c-histor_impres_nom_impres
                histor_impres.nom_arq             = c-histor_impres_nom_arq.
   END.

END.

ASSIGN r-histor_impres = ROWID(histor_impres).

/* Finaliza UtAcomp */
ASSIGN   
  
       i-page-counter-aux = PAGE-NUMBER
  
       NO-ERROR.

IF i-page-counter < i-page-counter-aux AND i-page-counter-aux <> ? then do:
   IF r-histor_impres <> ? THEN DO:
      DO TRANSACTION:
         IF AVAILABLE histor_impres THEN DO:
            ASSIGN i-page-counter            = i-page-counter-aux
                   histor_impres.qti_pag_tot = i-page-counter.
         END.
      END.
   END.
end.
    
IF AVAIL histor_impres THEN
   FIND CURRENT histor_impres NO-LOCK NO-ERROR.

/***********************************************/
output  close. 

/* Sa°da para RTF - tech981 20/10/2004 */

/* fim: Sa°da para RTF */

/*tech14178 procedimentos de convers∆o PDF */
/*tech868*/

    IF usePDF() THEN DO:
        IF tt-param.destino = 1 THEN DO:
            RUN pi_print IN h_pdf_controller.
        END.
        ELSE DO:
            /*tech868*/
                IF i-num-ped-exec-rpw <> 0 THEN
                    RUN pi_convert IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO). /* indica se vai para terminal, pois regras de nomenclatura s∆o diferentes */
                ELSE
                    RUN pi_convert IN h_pdf_controller (INPUT v_output_file, IF tt-param.destino = 3 THEN YES ELSE NO).
            /*tech868*/
        END.
    END.
    IF i-num-ped-exec-rpw <> 0 AND VALID-HANDLE(h_pdf_controller) THEN
        DELETE PROCEDURE h_pdf_controller.



IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN DO:
    RUN pi_after_close IN h-procextimpr (INPUT c-arq-control).
    DELETE PROCEDURE h-procextimpr NO-ERROR.
END.

RELEASE histor_impres.

/* i-rpout */

OUTPUT STREAM str-excel CLOSE.    

CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
IF ERROR-STATUS:ERROR THEN CREATE "Excel.Application":U chExcel NO-ERROR.

    
IF NOT ERROR-STATUS:ERROR THEN
DO:
    ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
    ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).
    chPlanilhaMod:Activate().
    
    ASSIGN chExcel:VISIBLE     = TRUE
           chExcel:WindowState = 3.
    
    RELEASE OBJECT chExcel       NO-ERROR.
    RELEASE OBJECT chArquivo     NO-ERROR.
    RELEASE OBJECT chPlanilhaMod NO-ERROR.             
END.
 
return "ok".

PROCEDURE pi-cria-tt-ord-res:

   DEFINE INPUT  PARAMETER p-ordem AS INTEGER    NO-UNDO.

   FIND FIRST tt-ord-res WHERE
              tt-ord-res.nr-ord-produ = p-ordem NO-ERROR.

   IF  NOT AVAIL tt-ord-res THEN DO:
       for first ord-prod fields (it-codigo   dt-termino   cod-estabel   cod-depos
                                  qt-ordem    qt-produzida estado        nr-ord-produ
                                  nr-pedido) where
                 ord-prod.nr-ord-produ = p-ordem NO-LOCK:

           CREATE tt-ord-res.
           ASSIGN tt-ord-res.nr-ord-produ = ord-prod.nr-ord-produ
                  tt-ord-res.cod-estabel  = ORD-PROD.COD-ESTABEL
                  tt-ord-res.estado       = ord-prod.estado
                  tt-ord-res.it-codigo    = ord-prod.it-codigo.
       END.
   END.

END PROCEDURE.

