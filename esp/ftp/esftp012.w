&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttit-ped-fiscal NO-UNDO LIKE it-ped-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttped-fiscal NO-UNDO LIKE ped-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
compile \\tsclient\c\fontes\esp\ftp\esftp012.w save into c:\temp\esp\ftp.
*******************************************************************************/
{include/i-prgvrs.i esftp012 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          esftp012
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Itens

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES
/*
&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES
*/
&GLOBAL-DEFINE ttParent         ttPed-fiscal
&GLOBAL-DEFINE hDBOParent       hDBOPed-fiscal
&GLOBAL-DEFINE DBOParentTable   ped-fiscal
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttIt-ped-fiscal
&GLOBAL-DEFINE hDBOSon1         hDBOIt-ped-fiscal
&GLOBAL-DEFINE DBOSon1Table     it-ped-fiscal
&GLOBAL-DEFINE DBOSon1Destroy   YES
/*
&GLOBAL-DEFINE ttSon2           <Temp-Table Name>
&GLOBAL-DEFINE hDBOSon2         <Handle DBO Variable Name>
&GLOBAL-DEFINE DBOSon2Table     <DBOSon2 Table Name>
&GLOBAL-DEFINE DBOSon2Destroy   <DBOSon2 Destroy Flag>
*/
&GLOBAL-DEFINE page0Fields      bt-situacao btDet btImport btCkd fi-cod-emitente ttPed-fiscal.nr-pedido ttPed-fiscal.situacao                                

&GLOBAL-DEFINE page1Fields      btEstrutura

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
/*DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.*/

DEFINE VARIABLE hDBOEmitente    AS HANDLE             NO-UNDO.
DEFINE VARIABLE l-aloca-estoque AS LOGICAL INITIAL NO NO-UNDO.
/*DEFINE VARIABLE hDBOItem        AS HANDLE       NO-UNDO.*/

/*DEFINE VARIABLE cDesc-item  LIKE ITEM.desc-item NO-UNDO.*/
{upc\btb910za-upc.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{include/i-win.i}
{cdp/cdcfgman.i}

DEF NEW GLOBAL SHARED VAR novo       AS INT     NO-UNDO INITIAL 2.
DEFINE VARIABLE l-encontrou          AS LOGICAL NO-UNDO.
/* DEFINE VARIABLE h-bodi317sd          AS HANDLE  NO-UNDO. */
/* DEFINE VARIABLE h-bodi317in          AS HANDLE  NO-UNDO. */
/* DEFINE VARIABLE h-bodi317pr          AS HANDLE  NO-UNDO. */
/* DEFINE VARIABLE h-bodi317im1bra      AS HANDLE  NO-UNDO. */
/* DEFINE VARIABLE h-bodi317va          AS HANDLE  NO-UNDO. */
DEFINE VARIABLE l-proc-ok-aux        AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec AS CHAR    NO-UNDO.
DEFINE VARIABLE r-rowid              AS ROWID   NO-UNDO.
DEFINE VARIABLE h-open               AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-inclui             AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-altera             AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-elimina            AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-atend-seq          AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-atend-ped          AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-estrutura          AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-gera-itens         AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-inf-fiscais        AS LOGICAL NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE  p-tipo             AS CHAR NO-UNDO.
DEFINE VARIABLE c-cod-depos   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-localiz AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lote        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-imobilizado AS LOG NO-UNDO.

DEFINE BUFFER b-wt-docto FOR wt-docto.

/* variaveis do word para classes */
DEFINE VARIABLE chWord      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chDocument  AS COM-HANDLE NO-UNDO.

/* Importa */
DEFINE VARIABLE c-linha     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-erro      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_email     AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-cnpj-transportador-vc0901a AS char NO-UNDO.

DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

DEF TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD qtde      LIKE estrutura.qtd-compon.

    /***********************************************************************************
    **
    ** BODI317SD.I1 - Definiá∆o da tabela tempor†ria para itens de devoluá∆o.
    **
    ************************************************************************************/
    DEFINE VARIABLE hDBOtr140fn         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hprogseltf          AS HANDLE      NO-UNDO.
    DEFINE VARIABLE de-peso-total       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total-qtde       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total-cub        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total-vlr        AS DECIMAL     NO-UNDO.

    /* TMS DEFINE TEMP-TABLE tt-nota-fiscal-tr NO-UNDO LIKE movtrp.nota-fiscal-tr
           field r-rowid as rowid.
    DEFINE TEMP-TABLE tt-itens-nf NO-UNDO LIKE movtrp.itens-nf
           field r-rowid as rowid.*/

    def temp-table tt-itens-devol no-undo
        field serie-docto       like item-doc-est.serie-docto 
        field cod-emitente      like item-doc-est.cod-emitente
        field nro-docto         like item-doc-est.nro-docto   
        field nat-operacao      like item-doc-est.nat-operacao
        field sequencia         like item-doc-est.sequencia
        field it-codigo         like item-doc-est.it-codigo
        field cod-refer         like item-doc-est.cod-refer
        field desc-nar          like item.desc-item
        field quantidade        like item-doc-est.quantidade
        field preco-total       like item-doc-est.preco-total[1]
        field qt-ja-devolvida   like item-doc-est.quantidade
        field qt-a-devolver     like item-doc-est.quantidade
        field qt-a-devolver-inf like item-doc-est.quantidade
        field selecionado       as log
        index codigo 
              serie-docto
              nro-docto    
              cod-emitente 
              nat-operacao 
              sequencia
        index selecionado
              selecionado.

    DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
        FIELD mensagem AS CHARACTER FORMAT "x(250)".

    def temp-table tt-it-terc-nf no-undo
        field rw-saldo-terc     as rowid
        field sequencia         like saldo-terc.sequencia
        field it-codigo         like saldo-terc.it-codigo
        field cod-refer         like saldo-terc.cod-refer
        field desc-nar          like item.desc-item
        field quantidade        like saldo-terc.quantidade
        field qt-alocada        like saldo-terc.quantidade
        field qt-disponivel     like saldo-terc.quantidade
        field qt-disponivel-inf like saldo-terc.quantidade
        field preco-total       like componente.preco-total[1]
        field preco-total-inf   like componente.preco-total[1]
        field selecionado       as log
        index codigo 
              sequencia
        index selecionado
              selecionado.

DEFINE TEMP-TABLE tt-custos-param NO-UNDO
    FIELD cod-versao-integracao AS INT
    FIELD l-acomp               AS LOG    INIT yes
    FIELD h-acomp               AS HANDLE
    FIELD tp-preco              AS INT    INIT 1
    FIELD moeda                 AS INT    INIT 0
    FIELD corrige               AS LOG    INIT no
    FIELD cod-estabel           AS CHAR
    FIELD tempo-prepar          AS INT    INIT 0
    FIELD custo-oper            AS INT    INIT 1
    FIELD rkw-up                AS INT    INIT 1
    FIELD nr-niveis             AS INT    INIT 19
    FIELD cod-obsoleto          AS INT    INIT 1
    FIELD atual-custo-data      AS LOG    INIT no
    FIELD tipo-custo            AS INT
    FIELD atual-com-erro        AS LOG    INIT no
    FIELD dt-custo              AS DATE FORMAT '99/99/9999' INIT TODAY
    FIELD cons-estab-fil        AS LOGICAL
    FIELD detalha-ggf           AS LOGICAL
    FIELD l-visao-un            AS LOGICAL INIT NO
    FIELD c-origem              AS CHAR FORMAT "x(2)". /*Novo*/

DEFINE TEMP-TABLE tt-custos-item NO-UNDO
    FIELD i-sequen         AS INT
    FIELD it-codigo        AS CHAR
    FIELD cod-refer        AS CHAR
    FIELD cod-lista-compon AS CHAR
    FIELD cod-roteiro      AS CHAR
    FIELD quantidade       AS DECI   INIT 1
    FIELD dt-corte-estrut  AS DATE FORMAT '99/99/9999' INIT TODAY
    FIELD dt-corte-op      AS DATE FORMAT '99/99/9999' INIT TODAY
    FIELD fm-codigo        LIKE ITEM.fm-codigo
    FIELD ge-codigo        LIKE ITEM.ge-codigo
    FIELD c-origem         AS CHAR FORMAT "x(2)"
    &IF DEFINED(bf_man_206b) &THEN
        FIELD cod-unid-negoc LIKE ITEM.cod-unid-negoc
    &ENDIF
    INDEX ch-item-ref IS UNIQUE
          it-codigo        ASC
          cod-refer        ASC
          cod-lista-compon ASC
          cod-roteiro      ASC
    INDEX ch-seq IS PRIMARY UNIQUE
          i-sequen
    INDEX ch-fm
          fm-codigo
          it-codigo
          cod-refer
    INDEX ch-ge
          ge-codigo.

def temp-table tt-custos-calculo NO-UNDO
    field i-sequen              as int
    field seq-impressao         as int
    field it-codigo             like item.it-codigo 
    field cod-refer             like ref-item.cod-refer
    field nivel                 as int
    field vl-unit-mat           as dec
    field vl-unit-mob           as dec
    field vl-unit-mob-c         as dec
    field vl-unit-ggf           as dec extent 6
    field vl-unit-ggf-c         as dec
    field vl-unit-prep          as dec
    field vl-unit-ext           as dec
    field vl-unit-ref           as dec
    field qt-up                 as dec
    field qt-up-prep            as dec
    field quantidade            like estrutura.quant-usada
&IF DEFINED (bf_man_203) &THEN        
    field quant-liquid          like estrutura.quant-liquid
    field fator-perda           like estrutura.fator-perda
&ENDIF    
    field dt-cotacao            as DATE FORMAT '99/99/9999'
    field fm-codigo             as char
    field ge-codigo             as int
    field ult-nivel             as logi
    FIELD c-origem              AS CHAR FORMAT "x(2)"
    index ch-imp  is unique primary
        i-sequen
        seq-impressao
    index ch-fm 
        i-sequen
        fm-codigo
    index ch-ge
        i-sequen
        ge-codigo
    INDEX ch-ref
        it-codigo
        cod-refer. 

def temp-table tt-custos-mob-dir NO-UNDO
    field i-sequen         as int
    field cd-mob-dir       like tab-mob-dir.cd-mob-dir
    field valor            as decimal init 0
    field tempo            as decimal init 0
    index ch-mob-dir is unique primary
        i-sequen
        cd-mob-dir.

def temp-table tt-custos-ggf NO-UNDO
    field i-sequen         as int
    field cc-codigo        like centro-custo.cc-codigo
    field valor            as deci extent 6 init 0
    field tempo            as deci          init 0
    index ch-ggf is unique primary
        i-sequen
        cc-codigo.

def temp-table tt-custos-op NO-UNDO
    field i-sequen              as int
    field seq-impressao         as int
    field cod-roteiro           like operacao.cod-roteiro
    field op-codigo             like operacao.op-codigo
    field vl-unit-mob           as dec
    field vl-unit-ggf           as dec extent 6
    field vl-unit-prep          as dec
    field vl-unit-ext           as dec
    field tempo                 as dec 
    field qt-up                 as dec
    field qt-up-prep            as dec
    field cc-codigo             as char
    field cd-mob-dir            as char
    FIELD c-origem              AS CHAR FORMAT "x(2)"
    index ch-imp  is primary
        i-sequen
        seq-impressao
    index ch-cc
        i-sequen
        cc-codigo
    index ch-mob-dir
        i-sequen
        cd-mob-dir.

/*  BODI317SD.I1  */
{cdp/cd0666.i}          /* Definicao da temp-table de erros */
DEF VAR p-qtd-total     LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR p-qtd-disp      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR p-qtd-bloq      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEFINE VARIABLE l-okWMS AS LOGICAL      NO-UNDO.

{esp/es0018.i}

DEF TEMP-TABLE tt-fator
    FIELD emitente AS INTEGER 
    FIELD fator    AS DEC DECIMALS 4.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttIt-ped-fiscal item

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttIt-ped-fiscal.seq ttIt-ped-fiscal.it-codigo item.desc-item substring(ttit-ped-fiscal.char-1,11,8) ttIt-ped-fiscal.un ttIt-ped-fiscal.qtde ttIt-ped-fiscal.vl-unit ttIt-ped-fiscal.cod-depos ttIt-ped-fiscal.aliquota-ipi ttIt-ped-fiscal.peso-liq-item ttIt-ped-fiscal.peso-bru-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttIt-ped-fiscal NO-LOCK     WHERE ttIt-ped-fiscal.nr-pedido = int(ttped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME fPage0), ~
             EACH item WHERE ttIt-ped-fiscal.it-codigo = item.it-codigo NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH ttIt-ped-fiscal NO-LOCK     WHERE ttIt-ped-fiscal.nr-pedido = int(ttped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME fPage0), ~
             EACH item WHERE ttIt-ped-fiscal.it-codigo = item.it-codigo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttIt-ped-fiscal item
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttIt-ped-fiscal
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-fiscal.nr-pedido ttped-fiscal.situacao 
&Scoped-define ENABLED-TABLES ttped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttped-fiscal
&Scoped-Define ENABLED-OBJECTS RECT-1 rtParent rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp btDet btImport btCkd bt-situacao ~
fi-cod-emitente cNome-emit 
&Scoped-Define DISPLAYED-FIELDS ttped-fiscal.nr-pedido ~
ttped-fiscal.situacao 
&Scoped-define DISPLAYED-TABLES ttped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttped-fiscal
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente cNome-emit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc-item wMasterDetail 
FUNCTION fnDesc-item RETURNS CHARACTER
  ( pIt-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setaValor wMasterDetail 
FUNCTION setaValor RETURNS LOGICAL
  ( INPUT cCampo AS CHARACTER, 
    INPUT cValor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-situacao 
     IMAGE-UP FILE "adeicon\dog.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Altera Situacao".

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCkd 
     IMAGE-UP FILE "image/im-grava.bmp":U
     LABEL "CKD" 
     SIZE 4 BY 1.25 TOOLTIP "CKD".

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Detalhar" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhes do Pedido".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImport 
     IMAGE-UP FILE "image\im-exp.gif":U
     LABEL "Importar" 
     SIZE 4 BY 1.25 TOOLTIP "Importar".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cNome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 1.33.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-libera 
     LABEL "Lib.Supervisor" 
     SIZE 14 BY 1.

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCalculaFrete 
     LABEL "Calcula Frete" 
     SIZE 14 BY 1.

DEFINE BUTTON btComodato 
     LABEL "Comodato" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon1 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEstrutura 
     LABEL "Estrutura" 
     SIZE 14 BY 1.

DEFINE BUTTON btGeraItens 
     LABEL "&Ger It" 
     SIZE 8 BY 1.

DEFINE BUTTON btGeraItensIND 
     LABEL "Gera Itens IND" 
     SIZE 14 BY 1.

DEFINE BUTTON btGeraItensTransf 
     LABEL "Gera Itens Transf" 
     SIZE 14 BY 1.

DEFINE BUTTON btNotaDev 
     LABEL "Nota Devoluá∆o" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btNotaRem 
     LABEL "Nota Remessa Industrializacao" 
     SIZE 13.86 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttIt-ped-fiscal, 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      ttIt-ped-fiscal.seq FORMAT ">>9":U
      ttIt-ped-fiscal.it-codigo FORMAT "x(16)":U WIDTH 8
      item.desc-item FORMAT "x(60)":U WIDTH 37.14
      substring(ttit-ped-fiscal.char-1,11,8) COLUMN-LABEL "Class. Fiscal"
      ttIt-ped-fiscal.un FORMAT "x(2)":U WIDTH 3.43
      ttIt-ped-fiscal.qtde FORMAT ">>>>,>>9.99":U
      ttIt-ped-fiscal.vl-unit FORMAT "->>>>>>9.9999":U
      ttIt-ped-fiscal.cod-depos FORMAT "x(3)":U
      ttIt-ped-fiscal.aliquota-ipi FORMAT ">9.99":U
      ttIt-ped-fiscal.peso-liq-item FORMAT "->>,>>9.999":U
      ttIt-ped-fiscal.peso-bru-item FORMAT "->>,>>9.999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 97 BY 8
         FONT 2 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 87.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 91.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 95.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 99.57 HELP
          "Ajuda"
     btDet AT ROW 1.17 COL 54 HELP
          "V† Para"
     btImport AT ROW 1.17 COL 62
     btCkd AT ROW 1.17 COL 68 WIDGET-ID 2
     bt-situacao AT ROW 1.17 COL 75 HELP
          "Aprovar Pedido de Notas Fiscais" WIDGET-ID 4
     ttped-fiscal.nr-pedido AT ROW 2.83 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttped-fiscal.situacao AT ROW 2.83 COL 66.43 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Digitado",0,
                     "A Liberar",1,
                     "A Relacionar",2,
                     "A Faturar",3,
                     "Atendido Parcialmente",4,
                     "Atendido",5,
                     "Reprovado",6
          DROP-DOWN-LIST
          SIZE 18.57 BY 1
     fi-cod-emitente AT ROW 4.33 COL 27 COLON-ALIGNED
     cNome-emit AT ROW 4.33 COL 36.14 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.17 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.72 BY 20.75
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 9.17 COL 2.14
     btCopySon1 AT ROW 9.17 COL 12.14
     btUpdateSon1 AT ROW 9.17 COL 22.14
     btDeleteSon1 AT ROW 9.17 COL 32.14
     btNotaDev AT ROW 9.17 COL 42.14
     btEstrutura AT ROW 9.17 COL 55
     bt-libera AT ROW 9.17 COL 69 WIDGET-ID 2
     btNotaRem AT ROW 9.17 COL 83
     btGeraItensIND AT ROW 10.17 COL 2.14
     btCalculaFrete AT ROW 10.17 COL 16.14
     btGeraItens AT ROW 10.17 COL 30.14 WIDGET-ID 4
     btGeraItensTransf AT ROW 10.17 COL 38.14 WIDGET-ID 6
     btComodato AT ROW 10.17 COL 52.29 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.17
         SIZE 99.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttit-ped-fiscal T "?" NO-UNDO mgesp it-ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttped-fiscal T "?" NO-UNDO mgesp ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.83
         WIDTH              = 103.72
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttIt-ped-fiscal NO-LOCK
    WHERE ttIt-ped-fiscal.nr-pedido = int(ttped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME fPage0),
      EACH item WHERE ttIt-ped-fiscal.it-codigo = item.it-codigo NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "ttIt-ped-fiscal.it-codigo = mgcad.item.it-codigo"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage0 wMasterDetail
ON ENTRY OF FRAME fPage0
DO:
  
    btEstrutura:SENSITIVE IN FRAME fpage1 = TRUE.  
    
   /*
    ENABLE btEstrutura WITH FRAME fpage1. 
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-libera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-libera wMasterDetail
ON CHOOSE OF bt-libera IN FRAME fPage1 /* Lib.Supervisor */
DO:
    DEF VAR c-det-itens AS CHAR FORMAT "x(2000)" NO-UNDO.
    FIND FIRST mgesp.ped-fiscal
         WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido NO-LOCK NO-ERROR.

    IF NOT CAN-FIND(FIRST it-ped-fiscal OF ped-fiscal) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Solicitaá∆o sem itens!":U + "~~" +
                                     "Favor incluir um item antes de liberar a solicitaá∆o.":U).
        RETURN NO-APPLY.
    END.

    FOR EACH it-ped-fiscal
       WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido NO-LOCK:

        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.
        
        FIND FIRST it-natureza-ped-fiscal
             WHERE it-natureza-ped-fiscal.natureza  = int(ped-fiscal.nat-oper)
               AND it-natureza-ped-fiscal.it-codigo = it-ped-fiscal.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL it-natureza-ped-fiscal AND ITEM.tipo-contr = 4 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Item Invalido!":U + "~~" +
                                         "Item " + it-ped-fiscal.it-codigo  +
                                         " n∆o vinculado com a natureza " + string(ped-fiscal.nat-oper) + ". Entrar em contato com o Grupo Fiscal.":U).
            RETURN NO-APPLY.
        END.

        ASSIGN c-det-itens = c-det-itens  + "Item: " + it-ped-fiscal.it-codigo + " " + ITEM.desc-item + ", Qtde: " + STRING(it-ped-fiscal.qtde) + ", Vl Total: " 
                                           + STRING(it-ped-fiscal.vl-unit * it-ped-fiscal.qtde, ">>>,>>>,>>9.99") + CHR(13).

    END.

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = int(ttped-fiscal.nat-oper) NO-ERROR.
    IF  AVAIL  natureza-ped-fiscal 
    AND natureza-ped-fiscal.lib-auto /* Liberaá∆o autom†tica */ THEN DO:
        FIND FIRST mgesp.ped-fiscal
             WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido exclusive-LOCK NO-ERROR.
        IF  AVAIL mgesp.ped-fiscal THEN DO:
            ASSIGN mgesp.ped-fiscal.situacao     = 2
                   mgesp.ped-fiscal.supervisor   = ""
                   mgesp.ped-fiscal.dt-aprovacao = TODAY
                   ttped-fiscal.situacao          = 2   
                   ttped-fiscal.supervisor        = ""
                   ttped-fiscal.dt-aprovacao      = TODAY
                   ttped-fiscal.situacao:SCREEN-VALUE IN FRAME fPage0 = '2'.

            MESSAGE "Solicitaá∆o Liberada diretamente para Faturamento" VIEW-AS ALERT-BOX INFO BUTTONS OK. 

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente NO-ERROR.

            RUN piEnviaEmailTranspIncorreta.

            /* Enviar email para Supervisor */
            
            IF  natureza-ped-fiscal.ind-mail-supervisor THEN DO:
                FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
                RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                                  INPUT usuar_mestre.cod_e_mail_local,
                                  INPUT "Aprovaá∆o Autom†tica Pedido: " + string(ttped-fiscal.nr-pedido),
                                  
                                  INPUT "Foi aprovado automaticamente o pedido: " + STRING(ttped-fiscal.nr-pedido) + 
                                        " vinculado ao centro de custo de sua responsabilidade, seguem informaá‰es abaixo:" + CHR(13) + CHR(13) +
                                        "N£mero do Pedido: " + STRING(ttped-fiscal.nr-pedido)+ CHR(13) + CHR(13) +
                                        "Solicitante do Pedido: " + ped-fiscal.observacao[2] + CHR(13) + CHR(13) +
                                        "Cliente: " + STRING(Emitente.cod-emitente) + " - " + emitente.nome-emit + CHR(13) + CHR(13) +
                                        "N£mero do Pedido: " + STRING(ttped-fiscal.nr-pedido) + CHR(13) + CHR(13) +
                                        c-det-itens + CHR(13) + CHR(13) +
                                        "Responsabilidade do Frete: " + (IF ttPed-fiscal.frete THEN "Frete Pago" ELSE "Frete a Pagar"),
                                  INPUT "").
            END.
            
        END.
    END.
    ELSE DO:
        FIND FIRST it-ped-fiscal
            WHERE  it-ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido NO-LOCK NO-ERROR.
        IF  NOT AVAIL it-ped-fiscal THEN DO:
            MESSAGE "Solicitacao sem Itens, completo a solicitacao antes de enviar para o Supervisor" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
        FIND FIRST emitente
             WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL emitente AND emitente.INd-cre-cli = 4 THEN DO:
            MESSAGE "ATENÄ«O!" SKIP
                    "" SKIP
                    "Cliente suspenso para faturamento. Para criaá∆o de pedidos de emiss∆o de notas fiscais Ç necess†rio que o emitente esteja liberado no EMS pelo Departamento Financeiro." SKIP
                    "" SKIP
                    "Deseja enviar e-mail solicitando a liberaá∆o?"
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                            TITLE "" UPDATE choice AS LOGICAL.
            IF  choice =  TRUE THEN DO:
    
                FIND FIRST int-emitente WHERE int-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL int-emitente THEN
                    ASSIGN int-emitente.cod-gr-cob = 16
                           emitente.ind-cre-cli    = 5.

                /* busca email para aviso sobre clientes suspensos */
                ASSIGN v_email = "".
                RUN esp/es0018p.p (INPUT "esftp012", /* Nome do programa  */
                                   INPUT 7,          /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                
                FOR EACH tt-prog-ponto:
                    IF  v_email = "" THEN
                        ASSIGN v_email = tt-prog-ponto.conteudo.
                    ELSE
                        ASSIGN v_email = v_email + ";" + tt-prog-ponto.conteudo.
                END.
                /* busca email para aviso sobre clientes suspensos */

                IF v_email <> "" THEN DO:
                    FIND FIRST natureza-ped-fiscal NO-LOCK
                         WHERE natureza-ped-fiscal.natureza = int(ttped-fiscal.nat-oper) NO-ERROR.    
                   
                       FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
                       RUN piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                         INPUT v_email,
                                         INPUT "Cliente Suspenso " + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit,
                                         INPUT "Solicitacao de liberaá∆o do emitente " + 
                                                string(emitente.cod-emitente) + 
                                               " para a criaá∆o de pedido de emiss∆o de nota extra, " + 
                                                (IF AVAIL natureza-ped-fiscal THEN natureza-ped-fiscal.descricao ELSE "") + 
                                               " conforme solicitado pelo usu†rio " + 
                                                usuar_mestre.cod_usuario + " - " + usuar_mestre.nom_usuario + ". Grupo de cobranáa " + 
                                               " e crÇdito do cliente atualizados. O cliente est† liberado para emitir a nota ",
                                         INPUT "").
                       MESSAGE "E-mail enviado para " v_email " . Grupo de cobranáa e crÇdito do cliente atualizados. O cliente est† liberado para emitir a nota!"
                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
                RUN piEnviaEmailTranspIncorreta.
            END.
        END.
        ELSE DO:
            RUN esp/es0018p.p (INPUT "esftp012", /* Nome do programa  */
                               INPUT 8,          /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
            IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
                FIND FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.
            END.

            IF  ttped-fiscal.situacao = 0 OR AVAIL tt-prog-ponto THEN DO:
                RUN esp/ftp/esftp012rp.p (INPUT ttped-fiscal.nr-pedido, INPUT v_cod_usuar_corren).
                RUN piEnviaEmailTranspIncorreta.
            END.
            ELSE DO:
                MESSAGE "Situaá∆o do Pedido n∆o permite liberaá∆o" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FIND mgesp.ped-fiscal
                WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido NO-LOCK NO-ERROR.
            ASSIGN  ttped-fiscal.situacao:SCREEN-VALUE IN FRAME fpage0 =  string(ped-fiscal.situacao)
                    ttped-fiscal.situacao = mgesp.ped-fiscal.situacao.
            RUN afterControlToolBar.
        END.
        FIND CURRENT emitente NO-LOCK NO-ERROR.
        RELEASE emitente.
    
    END. /* IF NOT AVAIL natureza-ped-fiscal OR natureza-ped-fiscal.lib-auto = NO THEN DO: */

   

    FIND CURRENT mgesp.ped-fiscal NO-LOCK NO-ERROR.
    RELEASE mgesp.ped-fiscal.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-situacao wMasterDetail
ON CHOOSE OF bt-situacao IN FRAME fPage0 /* Button 1 */
OR "CHOOSE":U OF bt-situacao IN FRAME fPage0 DO:
    IF (ttPed-fiscal.situacao = 2  OR 
        ttPed-fiscal.situacao = 3) THEN DO:

        MESSAGE "Confirma retorno solicitacao para Digitado?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN TRUE THEN /* Yes */ DO:
                FIND mgesp.ped-fiscal
                    WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL ped-fiscal THEN
                    ASSIGN mgesp.ped-fiscal.situacao = 0
                           ttPed-fiscal.situacao = mgesp.ped-fiscal.situacao.
                   
                    /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
                    RUN goToKey IN {&hDBOParent} (INPUT mgesp.ped-fiscal.nr-pedido).
                   
                    /*:T Retorna rowid do registro corrente do DBO */
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                    
                    /*:T Reposiciona registro com base em um rowid */
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
                    
            END.
            WHEN FALSE THEN /* No */ DO:
               // RUN cancelRecord IN THIS-PROCEDURE.
            END.
            OTHERWISE /* Cancel */ STOP.
        END CASE.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:

    ASSIGN novo = 1. 

    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/ftp/esftp012a.w":U). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    IF AVAIL ttped-fiscal THEN DO:
        IF (ttped-fiscal.nat-oper = 2 OR ttped-fiscal.nat-oper = 3) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Para esta natureza, favor utilizar o bot∆o Ger It":U).
            RETURN NO-APPLY.
        END.
        ELSE IF (ttped-fiscal.nat-oper = 17 OR ttped-fiscal.nat-oper = 23 OR ttped-fiscal.nat-oper = 24 OR ttped-fiscal.nat-oper = 37) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Para esta natureza, favor utilizar o bot∆o Nota Devoluá∆o ":U).
            RETURN NO-APPLY.
        END.
        ELSE
            {masterdetail/AddSon.i &ProgramSon="esp/ftp/esftp012b.w" &PageNumber="1"}

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCalculaFrete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCalculaFrete wMasterDetail
ON CHOOSE OF btCalculaFrete IN FRAME fPage1 /* Calcula Frete */
DO:

    /* TMS

    /*--- Verifica se o programa vf0401n.w ja esta inicializado ---*/
    IF NOT VALID-HANDLE(hprogseltf) OR
       hprogseltf:TYPE <> "PROCEDURE":U OR
       hprogseltf:FILE-NAME <> "vfp/vf0401n.w":U THEN DO:
        RUN vfp/vf0401n.w PERSISTENT SET hprogseltf.
    END.

    IF NOT VALID-HANDLE(hdbotr140fn) OR
       hdbotr140fn:TYPE <> "PROCEDURE":U OR
       hdbotr140fn:FILE-NAME <> "trbo/botr140fn.p":U THEN DO:
        
        RUN trbo/botr140fn.p persistent set hdbotr140fn.
    END.
    RUN openQueryStatic IN hDBOTR140fn (INPUT "Main":U) NO-ERROR.

    FIND estabelec
         WHERE estabelec.cod-estabel = ttped-fiscal.cod-estabel
         NO-LOCK NO-ERROR.
    FOR EACH tt-nota-fiscal-tr:
        DELETE tt-nota-fiscal-tr.
    END.
    FOR EACH tt-itens-nf:
        DELETE tt-itens-nf.
    END.

    CREATE tt-nota-fiscal-tr.

    find first cidade-tr no-lock
         where cidade-tr.nm-completo = estabelec.cidade no-error.

    IF NOT AVAIL cidade-tr THEN DO:
        MESSAGE "Cidade Origem N∆o encontrada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.
    ASSIGN tt-nota-fiscal-tr.nr-cid-calc-de   = cidade-tr.nr-cidade.

    FIND emitente
         WHERE emitente.cod-emitente = ttPed-fiscal.cod-emitente
         NO-LOCK NO-ERROR.
    find first cidade-tr no-lock
         where cidade-tr.nm-completo = emitente.cidade no-error.

    IF NOT AVAIL cidade-tr THEN DO:
        MESSAGE "Cidade Destino N∆o encontrada " emitente.cidade
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.

    ASSIGN tt-nota-fiscal-tr.nr-cid-calc-ate  = cidade-tr.nr-cidade
           de-peso-total                      = 0
           de-total-qtde                      = 0
           de-total-vlr                       = 0
           de-total-cub                       = 0.
    FOR EACH it-ped-fiscal
        WHERE it-ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-LOCK:
        FIND ITEM
             WHERE ITEM.it-codigo = it-ped-fiscal.it-codigo NO-LOCK NO-ERROR.

        IF it-ped-fiscal.peso-bru-item <> 0 THEN DO:
           ASSIGN de-peso-total = de-peso-total + it-ped-fiscal.peso-bru-item * it-ped-fiscal.qtde.
        END.
        ELSE DO:
            ASSIGN de-peso-total = de-peso-total + ITEM.peso-bruto * it-ped-fiscal.qtde.
        END.
        ASSIGN  de-total-qtde = de-total-qtde + it-ped-fiscal.qtde
                de-total-vlr  = de-total-vlr  + it-ped-fiscal.qtde * it-ped-fiscal.vl-unit
                de-total-cub  = de-total-cub  + it-ped-fiscal.qtde * (item.comprim / 1000) * (item.largura / 1000) * (item.altura / 1000)  .

    END.
    IF de-total-qtde = 0 THEN DO:
        MESSAGE "Informe Itens antes de calcular o Frete "
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END.


    CREATE tt-itens-nf.
    ASSIGN tt-itens-nf.cd-produto = 1
           tt-itens-nf.qt-peso    = de-peso-total
           tt-itens-nf.qt-unidade = de-total-qtde
           tt-itens-nf.qt-m3      = de-total-cub
           tt-itens-nf.vl-item    = de-total-vlr.
        
    CREATE tt-itens-nf.
    ASSIGN tt-itens-nf.cd-produto = 2
           tt-itens-nf.qt-peso    = de-peso-total
           tt-itens-nf.qt-unidade = de-total-qtde
           tt-itens-nf.qt-m3      = de-total-cub
           tt-itens-nf.vl-item    = de-total-vlr.  
        
/*     CREATE tt-itens-nf.                           */
/*     ASSIGN tt-itens-nf.cd-produto = 3             */
/*            tt-itens-nf.qt-peso    = de-peso-total */
/*            tt-itens-nf.qt-unidade = de-total-qtde */
/*            tt-itens-nf.qt-m3      = de-total-cub  */
/*            tt-itens-nf.vl-item    = de-total-vlr. */


/*tt-itens-nf.qt-unidade FORMAT ">>>,>>>,>>9.999":U
tt-itens-nf.qt-peso FORMAT ">>>,>>9.999":U
tt-itens-nf.vl-item FORMAT ">>>>>,>>>,>>9.99":U
tt-itens-nf.qt-m3 FORMAT ">>9.999":U
tt-itens-nf.qt-peso-cubado FORMAT ">>>,>>9.999":U WIDTH 16.57*/

    RUN setarTributacao      IN hDBOtr140fn (INPUT 0, 
                                             INPUT 0, 
                                             INPUT 1).
    RUN setarUsarFastRoute   IN hDBOtr140fn (INPUT YES ). /* l-uti-fast-rot */
    RUN setarGravarFastRoute IN hDBOtr140fn (INPUT no). /* l-gra-fast-rot */
    RUN setarTipoCalculo     IN hDBOtr140fn (INPUT 1 /* Normal */ ).
    RUN setarTipoNegociacao  IN hDBOtr140fn (INPUT 1). /* iTp-negociacao - compra */
    RUN setarTransportador   IN hDBOtr140fn (INPUT "").
    RUN setarTipoVeiculo     IN hDBOtr140fn (INPUT 0).
    RUN setarProduto         IN hDBOtr140fn (INPUT 0).
    RUN setarEstabSaida      IN hDBOTR140fn (INPUT v_cod_estab_usuar ).
    RUN setarDataValidade    IN hDBOtr140fn (INPUT TODAY).
    RUN setarProgSelecaoRota IN hDBOtr140fn (hprogseltf).
    RUN simularCalculoNota   IN hDBOtr140fn (INPUT TABLE tt-nota-fiscal-tr, 
                                             INPUT TABLE tt-itens-nf).
    ASSIGN c-cnpj-transportador-vc0901a = "".
    RUN vfp/vf0901.w (INPUT hDBOtr140fn).           

    IF c-cnpj-transportador-vc0901a <> "" THEN DO:
        ASSIGN c-cnpj-transportador-vc0901a = REPLACE(REPLACE(REPLACE(c-cnpj-transportador-vc0901a,"-",""),"/",""),".","").
        FIND transporte 
             WHERE transporte.cgc = c-cnpj-transportador-vc0901a
             NO-LOCK NO-ERROR.
        IF AVAIL transporte THEN DO:
            MESSAGE "Deseja utilizar a transportadora escolhida na simulaá∆o de fretes? "
                   SKIP(1)
                   transporte.cgc SKIP
                   transporte.nome-abrev SKIP
                   transporte.nome

                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                         TITLE "" UPDATE choice AS LOGICAL.
           IF choice = TRUE THEN DO:
               FIND ped-fiscal
                    WHERE Ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
               IF AVAIL ped-fiscal  THEN DO:
                   ASSIGN ped-fiscal.cod-transp = transporte.cod-transp.

               END.
           END.
        END.
        ELSE DO:
            MESSAGE "Transportadora selecionada nao encontrada no cadastro cd0401 com este CNPJ " c-cnpj-transportador-vc0901a
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.


    IF VALID-HANDLE(hDBOtr140fn) then
       run destroy in hDBOtr140fn .

*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCkd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCkd wMasterDetail
ON CHOOSE OF btCkd IN FRAME fPage0 /* CKD */
DO:

/*     RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                                                        */
/*                        INPUT 1,        /* Ponto do programa */                                                       */
/*                        INPUT 0,                                                                                      */
/*                        INPUT "",                                                                                     */
/*                        OUTPUT TABLE tt-prog-ponto) NO-ERROR.                                                         */
/*                                                                                                                      */
/*      IF NOT CAN-FIND (FIRST tt-prog-ponto                                                                            */
/*                       WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel)                                       */
/*      AND ttped-fiscal.nat-oper <> 28 THEN DO:                                                                        */
/*                                                                                                                      */
/*          RUN utp/ut-msgs.p (INPUT "show",                                                                            */
/*                             INPUT 17006,                                                                             */
/*                             INPUT "Estabelecimento " + ttped-fiscal.cod-estabel + " n∆o pode utilizar este bot∆o."). */
/*          RETURN "OK".                                                                                                */
/*      END.                                                                                                            */

    RUN esp/ftp/esftp012g.w (OUTPUT c-cod-depos,
                             OUTPUT c-cod-localiz,
                             OUTPUT c-lote,
                             OUTPUT l-ok).

    IF l-ok THEN DO:
        RUN pi-ckd.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btComodato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btComodato wMasterDetail
ON CHOOSE OF btComodato IN FRAME fPage1 /* Comodato */
DO:
    
   RUN pi-html.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    assign p-tipo              = "Copy".
    RUN copyRecord (INPUT "esp/ftp/esftp012a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    {masterdetail/CopySon.i &ProgramSon="esp/ftp/esftp012b.w" &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    def var i-nr-pedido as integer.

    BLOCO:
    DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
            
        if l-aloca-estoque then do:
              assign i-nr-pedido =  ttped-fiscal.nr-pedido.
              for each mgesp.it-ped-fiscal
                  where mgesp.it-ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido no-lock,
                  FIRST item 
                  WHERE ITEM.it-codigo = mgesp.it-ped-fiscal.it-codigo NO-LOCK:
                  IF ITEM.tipo-contr <> 4 and
                     item.baixa-estoq = YES THEN DO:

                      FIND FIRST in-grup-estoq NO-LOCK
                           WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                      /*Alocaá∆o por lote*/
                      IF  item.tipo-con-est = 3 THEN DO:

                          RUN esp/ftp/esftp012f.p (INPUT NO,                           /*p-log-aloca  */
                                                   INPUT it-ped-fiscal.nr-pedido,      /*p-nr-pedido  */
                                                   INPUT it-ped-fiscal.it-codigo,      /*p-it-codigo  */
                                                   INPUT it-ped-fiscal.seq,            /*p-seq        */
                                                   INPUT ttPed-fiscal.cod-estabel,     /*p-cod-estabel*/
                                                   INPUT it-ped-fiscal.cod-localizacao,/*p-cod-localiz*/
                                                   INPUT it-ped-fiscal.cod-depos,      /*p-cod-depos  */
                                                   INPUT it-ped-fiscal.qtde,           /*p-qtde-alocar*/
                                                   OUTPUT TABLE tt-erro-aloc).         
                          FOR FIRST tt-erro-aloc:
                              MESSAGE tt-erro-aloc.mensagem VIEW-AS ALERT-BOX.
                                 UNDO BLOCO, LEAVE BLOCO.  
                          END.
                      END.
                      /*Alocaá∆o sem lote*/
                      ELSE DO:
                          find first saldo-estoq
                               where saldo-estoq.it-codigo   = mgesp.it-ped-fiscal.it-codigo
                                 and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                                 and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos
                                 and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao
                                 no-lock no-error.
                
                           if avail saldo-estoq then do:
                              if saldo-estoq.qt-alocada < dec(it-ped-fiscal.qtde) then do:
                                 message "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " mgesp.it-ped-fiscal.qtde " do item: " mgesp.it-ped-fiscal.it-codigo view-as alert-box.
                                 UNDO BLOCO, LEAVE BLOCO.
                              end.

                              find current saldo-estoq exclusive-lock no-error.
                              assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - mgesp.it-ped-fiscal.qtde.
                              release saldo-estoq.
                           end.
                           else do:
                                 message "Saldo em Estoque n∆o Encontrado para item: " mgesp.it-ped-fiscal.it-codigo view-as alert-box.
                                 UNDO BLOCO, LEAVE BLOCO.
                           end.
                      END.
                 END.
              end.
        end.
        RUN deleteRecord IN THIS-PROCEDURE.
        if l-aloca-estoque then do:
            if can-find(first mgesp.it-ped-fiscal where mgesp.it-ped-fiscal.nr-pedido = i-nr-pedido) then do:
                UNDO BLOCO, LEAVE BLOCO.
            end.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    def var i-linha as integer.

    BLOCO:
    DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        if l-aloca-estoque then do:   
            DO i-linha = 1 TO brson1:NUM-SELECTED-ROWS :
                if brson1:fetch-selected-row(i-linha) then do:       
                    FIND FIRST item 
                        WHERE ITEM.it-codigo = ttit-ped-fiscal.it-codigo NO-LOCK NO-ERROR.

                    IF ITEM.tipo-contr <> 4 AND
                       ITEM.baixa-estoq = YES THEN DO:

                        FIND FIRST in-grup-estoq NO-LOCK
                             WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
    
                        /*Alocaá∆o por lote*/
                        IF  ITEM.tipo-con-est = 3 THEN DO:
    
                            RUN esp/ftp/esftp012f.p (INPUT NO,                              /*p-log-aloca  */
                                                     INPUT ttit-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                     INPUT ttit-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                     INPUT ttit-ped-fiscal.seq,             /*p-seq        */
                                                     INPUT ttped-fiscal.cod-estabel,        /*p-cod-estabel*/
                                                     INPUT ttit-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                     INPUT ttit-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                     INPUT ttit-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                     OUTPUT TABLE tt-erro-aloc).         
                            FOR FIRST tt-erro-aloc:
                                MESSAGE tt-erro-aloc.mensagem VIEW-AS ALERT-BOX.
                                   UNDO BLOCO, LEAVE BLOCO.  
                            END.
                        END.
                        /*Alocaá∆o sem lote*/
                        ELSE DO:
                            find first saldo-estoq no-lock 
                                 where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo
                                   and saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                                   and saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos
                                   and saldo-estoq.cod-localiz = ttit-ped-fiscal.cod-localizacao no-error.

                            if avail saldo-estoq then do:
                               if saldo-estoq.qt-alocada < dec(ttit-ped-fiscal.qtde) then do:
                                  message "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " ttit-ped-fiscal.qtde " do item: " ttit-ped-fiscal.it-codigo view-as alert-box.
                                  UNDO BLOCO, LEAVE BLOCO.
                               end.

                               find current saldo-estoq exclusive-lock no-error.
                               assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - dec(ttit-ped-fiscal.qtde).                        
                               release saldo-estoq.
                            end.
                            else do:
                                  message "Saldo em Estoque n∆o Encontrado para item: " ttit-ped-fiscal.it-codigo view-as alert-box.
                                  UNDO BLOCO, LEAVE BLOCO.
                            end.
                        END.
                    END.                
                end.
            END.
        end.
       {masterdetail/DeleteSon.i &PageNumber="1"} 
       if return-value <> "OK" then 
          UNDO BLOCO, LEAVE BLOCO.
    end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet wMasterDetail
ON CHOOSE OF btDet IN FRAME fPage0 /* Detalhar */
DO:
    IF AVAIL ttped-fiscal THEN 
       RUN esp\ftp\esftp012c.w (ttped-fiscal.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEstrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEstrutura wMasterDetail
ON CHOOSE OF btEstrutura IN FRAME fPage1 /* Estrutura */
DO:
    DEFINE VARIABLE rGoTo   AS ROWID        NO-UNDO.
    DEFINE VARIABLE i-seq   AS INT          NO-UNDO.
    
    /*
    DEFINE BUTTON btCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    */

    DEFINE BUTTON btOK AUTO-END-KEY 
         LABEL "&Sair" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOrdem 
     LABEL "S&alvar" 
     SIZE 10 BY 1
     BGCOLOR 8.

    DEFINE RECTANGLE rtOrdemButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEF var i-qtde        LIKE ord-prod.qt-ordem        LABEL "Qtde a Produzir".
    DEF var c-depos       LIKE mgesp.it-ped-fiscal.cod-depos  LABEL "Dep¢sito".
    DEF var c-it-codigo   LIKE item.it-codigo NO-UNDO.

    DEF VAR tot-vl-unit   LIKE mgesp.it-ped-fiscal.vl-unit.
    DEF VAR seq AS INT INITIAL 0.

    DEFINE FRAME fOrdemDev
        c-it-codigo  AT ROW 1.20 COL 16.42 COLON-ALIGNED
        i-qtde        AT ROW 2.40 COL 16.42 COLON-ALIGNED
        c-depos       AT ROW 3.60 COL 16.42 COLON-ALIGNED
        btOrdem       AT ROW 5.83 COL 2.14
        btOK          AT ROW 5.83 COL 13
        /* btCancel      AT ROW 5.83 COL 13 */
        rtOrdemButton AT ROW 5.58 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Estrutura" FONT 1
             DEFAULT-BUTTON btOK. /* CANCEL-BUTTON btCancel. */


    ON "CHOOSE":U OF btOrdem IN FRAME fOrdemDev DO:
        FOR EACH tt-item:
            DELETE tt-item.
        END.
        RUN pi-cria-tt-estrutura (INPUT int(c-it-codigo:SCREEN-VALUE), INPUT int(i-qtde:SCREEN-VALUE)).
/*
        IF ttPed-fiscal.cod-estabel = "101" AND 
           c-depos:SCREEN-VALUE = "ACA" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "N∆o permitido solicitar do dep¢sito ACA").
            undo, LEAVE.
        END.
        ELSE DO:
*/          
            bloco:
            DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
                FOR EACH tt-item:
                     FIND FIRST ITEM WHERE 
                          ITEM.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.

                     FIND FIRST in-grup-estoq NO-LOCK
                          WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
                          
/*                      IF  AVAIL in-grup-estoq                                                                            */
/*                      AND in-grup-estoq.log-ckd THEN DO:                                                                 */
/*                                                                                                                         */
/*                          RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                                      */
/*                                             INPUT 1,        /* Ponto do programa */                                     */
/*                                             INPUT 0,                                                                    */
/*                                             INPUT "",                                                                   */
/*                                             OUTPUT TABLE tt-prog-ponto) NO-ERROR.                                       */
/*                                                                                                                         */
/*                          IF CAN-FIND (FIRST tt-prog-ponto                                                               */
/*                                       WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel) THEN DO:                 */
/*                                                                                                                         */
/*                              IF  ttPed-fiscal.nat-oper <> 8                                                             */
/*                              AND ttPed-fiscal.nat-oper <> 9                                                             */
/*                              AND ttped-fiscal.nat-oper <> 28 THEN DO:                                                   */
/*                                  RUN utp/ut-msgs.p (INPUT "show":U,                                                     */
/*                                                     INPUT 17567,                                                        */
/*                                                     INPUT "Itens CKD s¢ podem ser adicionados atravÇs do bot∆o CKD":U). */
/*                                  UNDO, LEAVE.                                                                           */
/*                              END.                                                                                       */
/*                          END.                                                                                           */
/*                      END.                                                                                               */

                     FIND FIRST item-estab WHERE 
                          item-estab.it-codigo = tt-item.it-codigo AND 
                          item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-LOCK NO-ERROR.
                     IF NOT AVAIL item-estab THEN DO:
                        ASSIGN tot-vl-unit = 0.
                     END.
                     ELSE DO:
                        ASSIGN tot-vl-unit = item-estab.val-unit-mat-m[1]. /* + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].   */
                     END.
                     IF tot-vl-unit = 0 THEN DO:
                         FIND item-uni-estab WHERE
                              item-uni-estab.cod-estabel = item-estab.cod-estabel AND
                              item-uni-estab.it-codigo   = tt-item.it-codigo NO-LOCK NO-ERROR.
                         IF AVAIL item-uni-estab THEN
                             ASSIGN tot-vl-unit = item-uni-estab.preco-ul-ent.
                     END.
    
                     FIND LAST mgesp.it-ped-fiscal NO-LOCK WHERE 
                          mgesp.it-ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-ERROR.
                     IF NOT AVAIL mgesp.it-ped-fiscal THEN DO:
                         ASSIGN seq = seq + 1.
                         CREATE mgesp.it-ped-fiscal.
                         ASSIGN mgesp.it-ped-fiscal.nr-pedido    = ttPed-fiscal.nr-pedido
                                mgesp.it-ped-fiscal.it-codigo    = tt-item.it-codigo 
                                mgesp.it-ped-fiscal.seq          = seq
                                mgesp.it-ped-fiscal.cod-depos    = c-depos:SCREEN-VALUE
                                mgesp.it-ped-fiscal.qtde         = tt-item.qtde
                                mgesp.it-ped-fiscal.un           = ITEM.un                                          
                                mgesp.it-ped-fiscal.vl-unit      = tot-vl-unit
                                mgesp.it-ped-fiscal.aliquota-ipi = ITEM.aliquota-ipi
                                OVERLAY(mgesp.it-ped-fiscal.char-1,11,8) = ITEM.class-fisc
                                mgesp.it-ped-fiscal.peso-liq-item = ITEM.peso-liquido
                                mgesp.it-ped-fiscal.peso-bru-item = ITEM.peso-bruto. 
    
                        if l-aloca-estoque then do:                                      
                            IF ITEM.tipo-contr <> 4 and
                               item.baixa-estoq = YES THEN DO:   
    
                                RUN piValidaWMS.
                                IF l-okWMS = NO THEN DO:
                                    undo, LEAVE.
                                END.

                                FIND FIRST in-grup-estoq NO-LOCK
                                     WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                                /*Alocaá∆o por lote*/
                                IF ITEM.tipo-con-est = 3 THEN DO:
                                    RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                                             INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                             INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                             INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                             INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                             INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                             INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                             INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                             OUTPUT TABLE tt-erro-aloc).         
                                    FOR FIRST tt-erro-aloc:
                                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                                           INPUT 17567, 
                                                           INPUT tt-erro-aloc.mensagem).
                                        undo, LEAVE.  
                                    END.
                                END.
                                /*Alocaá∆o sem lote*/
                                ELSE DO:
                                    find first saldo-estoq
                                       where saldo-estoq.it-codigo      = mgesp.it-ped-fiscal.it-codigo
                                            and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                                            and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao
                                            and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos
                                                no-lock no-error.
        
                                    if not avail saldo-estoq then do:
                                         RUN utp/ut-msgs.p (INPUT "show":U, 
                                                            INPUT 17567, 
                                                            INPUT "Item sem saldo em estoque " + mgesp.it-ped-fiscal.it-codigo).
        
                                         undo, LEAVE.
                                    end.
                                    if saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                       saldo-estoq.qt-aloc-prod < dec(it-ped-fiscal.qtde) 
                                      then do:
                                         RUN utp/ut-msgs.p (INPUT "show":U, 
                                                            INPUT 17567, 
                                                            INPUT "Item com saldo " + string(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                       saldo-estoq.qt-aloc-prod) + " em estoque menor que a quantidade informada " + string(it-ped-fiscal.qtde) + ", inclus∆o n∆o permitida":U ).
        
                                         undo, LEAVE.
        
                                    end.                    
        
                                    find current saldo-estoq exclusive-lock no-error.
                                    assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + mgesp.it-ped-fiscal.qtde.   
                                    release saldo-estoq.
                                END.
                            END.
                         end.
                     END.
                     ELSE DO:
                        ASSIGN seq = mgesp.it-ped-fiscal.seq + 1.
                        CREATE mgesp.it-ped-fiscal.
                        ASSIGN mgesp.it-ped-fiscal.nr-pedido    = ttPed-fiscal.nr-pedido
                               mgesp.it-ped-fiscal.it-codigo    = tt-item.it-codigo 
                               mgesp.it-ped-fiscal.seq          = seq
                               mgesp.it-ped-fiscal.cod-depos    = c-depos:SCREEN-VALUE
                               mgesp.it-ped-fiscal.qtde         = tt-item.qtde
                               mgesp.it-ped-fiscal.un           = ITEM.un                                          
                               mgesp.it-ped-fiscal.vl-unit      = tot-vl-unit
                               mgesp.it-ped-fiscal.aliquota-ipi = ITEM.aliquota-ipi
                               OVERLAY(it-ped-fiscal.char-1,11,8) = ITEM.class-fisc
                               mgesp.it-ped-fiscal.peso-liq-item = ITEM.peso-liquido
                               mgesp.it-ped-fiscal.peso-bru-item = ITEM.peso-bruto.
                        if l-aloca-estoque then do:                           
                            IF ITEM.tipo-contr <> 4 and
                               item.baixa-estoq = YES THEN DO:
    
                                RUN piValidaWMS.
                                IF l-okWMS = NO THEN
                                    undo, LEAVE.

                                FIND FIRST in-grup-estoq NO-LOCK
                                     WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

/*                                 IF  AVAIL in-grup-estoq                                                                            */
/*                                 AND in-grup-estoq.log-ckd THEN DO:                                                                 */
/*                                     RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                                      */
/*                                                        INPUT 1,        /* Ponto do programa */                                     */
/*                                                        INPUT 0,                                                                    */
/*                                                        INPUT "",                                                                   */
/*                                                        OUTPUT TABLE tt-prog-ponto) NO-ERROR.                                       */
/*                                                                                                                                    */
/*                                      IF CAN-FIND (FIRST tt-prog-ponto                                                              */
/*                                                   WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel) THEN DO:                */
/*                                                                                                                                    */
/*                                          IF  ttPed-fiscal.nat-oper <> 8                                                            */
/*                                          AND ttPed-fiscal.nat-oper <> 9                                                            */
/*                                          AND ttped-fiscal.nat-oper <> 28 THEN DO:                                                  */
/*                                              RUN utp/ut-msgs.p (INPUT "show":U,                                                    */
/*                                                                 INPUT 17567,                                                       */
/*                                                                 INPUT "Itens CKD s¢ podem ser adicionados atravÇs do bot∆o CKD."). */
/*                                             UNDO, LEAVE.                                                                           */
/*                                          END.                                                                                      */
/*                                      END.                                                                                          */
/*                                 END.                                                                                               */

                                /*Alocaá∆o por lote*/
                                IF  ITEM.tipo-con-est = 3 THEN DO:
                                    RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                                             INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                             INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                             INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                             INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                             INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                             INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                             INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                             OUTPUT TABLE tt-erro-aloc).         
                                    FOR FIRST tt-erro-aloc:
                                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                                           INPUT 17567, 
                                                           INPUT tt-erro-aloc.mensagem).
                                        UNDO, LEAVE.
                                    END.
                                END.
                                /*Alocaá∆o sem lote*/
                                ELSE DO:
                                    find first saldo-estoq no-lock
                                         where saldo-estoq.it-codigo      = mgesp.it-ped-fiscal.it-codigo
                                           and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                                           and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao
                                           and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos  no-error.
        
                                    if not avail saldo-estoq then do:
                                         RUN utp/ut-msgs.p (INPUT "show":U, 
                                                            INPUT 17567, 
                                                            INPUT "Item sem saldo em estoque " + mgesp.it-ped-fiscal.it-codigo).
        
                                         undo, LEAVE.
                                    end.
                                    if saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                       saldo-estoq.qt-aloc-prod < dec(it-ped-fiscal.qtde) 
                                      then do:
                                         RUN utp/ut-msgs.p (INPUT "show":U, 
                                                            INPUT 17567, 
                                                            INPUT "Item com saldo " + string(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                       saldo-estoq.qt-aloc-prod) + " em estoque menor que a quantidade informada " + string(it-ped-fiscal.qtde) + ", inclus∆o n∆o permitida":U ).
        
                                         undo, leave.
        
                                    end.                    
        
                                    FIND CURRENT saldo-estoq exclusive-lock no-error.
                                    assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + mgesp.it-ped-fiscal.qtde.   
                                    RELEASE saldo-estoq NO-ERROR.
                                END.
                            END.
                        end.
                     END.
                     /* APPLY "CLOSE":U TO FRAME fOrdemDev. */
                END.
            END.
    
            MESSAGE "Estrutura Gerada com Sucesso"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*        END.    */
        APPLY "GO":U TO FRAME fOrdemDev.
    END.

    ENABLE i-qtde c-it-codigo c-depos btOK btOrdem
        WITH FRAME fOrdemDev. 
    
    WAIT-FOR "GO":U OF FRAME fOrdemDev.  
    RUN openQueriesSon.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btGeraItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGeraItens wMasterDetail
ON CHOOSE OF btGeraItens IN FRAME fPage1 /* Ger It */
DO:
    IF AVAIL ttPed-fiscal THEN DO:
        RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/ftp/esftp012e.w":U).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGeraItensIND
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGeraItensIND wMasterDetail
ON CHOOSE OF btGeraItensIND IN FRAME fPage1 /* Gera Itens IND */
DO: DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DEFINE VARIABLE i-seq       AS INT   NO-UNDO.
    DEFINE VARIABLE tot-vl-unit AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE v-tot-mat AS DECIMAL. 
    DEFINE VARIABLE v-tot-mob AS DECIMAL. 
    DEFINE VARIABLE v-tot-ggf AS DECIMAL. 

    MESSAGE "Ser∆o Incluidos nesta solicitaá∆o todos os itens que tiverem saldo " SKIP
            " no deposito IND localizaá∆o BRANCO" SKIP
            ""
            "CONFIRMA ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.

    CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
             FIND LAST mgesp.it-ped-fiscal WHERE 
                  mgesp.it-ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-LOCK NO-ERROR.
             IF AVAIL it-ped-fiscal THEN 
                 ASSIGN i-seq = mgesp.it-ped-fiscal.seq.
             ELSE
                 ASSIGN i-seq = 0.

             DO TRANS:
                 FOR EACH saldo-estoq
                     WHERE saldo-estoq.cod-depos = "IND"
                       AND saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                       AND saldo-estoq.cod-localiz = ""
                       AND (saldo-estoq.qtidade-atu - 
                            saldo-estoq.qt-alocada  - 
                            saldo-estoq.qt-aloc-ped - 
                            saldo-estoq.qt-aloc-prod) > 0 EXCLUSIVE-LOCK
                        BY saldo-estoq.it-codigo
                        BY saldo-estoq.dt-vali-lote:
                     
                     FIND ITEM
                         WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.

                     FIND FIRST in-grup-estoq NO-LOCK
                          WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                     ASSIGN i-seq = i-seq + 1.

                     FIND FIRST item-estab WHERE 
                          item-estab.it-codigo = ITEM.it-codigo AND 
                          item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-LOCK NO-ERROR.
                     IF NOT AVAIL item-estab THEN DO:
                        ASSIGN tot-vl-unit = 0.
                     END.
                     ELSE DO:
                        ASSIGN tot-vl-unit = item-estab.val-unit-mat-m[1]. /* + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].   */
                     END.
                     IF tot-vl-unit = 0 THEN DO:
                         FIND item-uni-estab WHERE
                              item-uni-estab.cod-estabel = item-estab.cod-estabel AND
                              item-uni-estab.it-codigo   = ITEM.it-codigo NO-LOCK NO-ERROR.
                         IF AVAIL item-uni-estab THEN
                             ASSIGN tot-vl-unit = item-uni-estab.preco-ul-ent.
                     END.
    
                     IF tot-vl-unit = 0 THEN DO:
                        RUN piCalculaCusto (INPUT ITEM.it-codigo,
                                            INPUT item-estab.cod-estabel,
                                            OUTPUT v-tot-mat,
                                            OUTPUT v-tot-mob,
                                            OUTPUT v-tot-ggf).
    
                        ASSIGN tot-vl-unit = v-tot-mat + v-tot-mob + v-tot-ggf.
                     END.
    
                     CREATE mgesp.it-ped-fiscal.
                     ASSIGN mgesp.it-ped-fiscal.nr-pedido       = ttPed-fiscal.nr-pedido
                            mgesp.it-ped-fiscal.it-codigo       = saldo-estoq.it-codigo
                            mgesp.it-ped-fiscal.seq             = i-seq
                            mgesp.it-ped-fiscal.cod-depos       = "IND"
                            mgesp.it-ped-fiscal.qtde            = (saldo-estoq.qtidade-atu - 
                                                                    saldo-estoq.qt-alocada  - 
                                                                    saldo-estoq.qt-aloc-ped - 
                                                                    saldo-estoq.qt-aloc-prod)
                            mgesp.it-ped-fiscal.un              = ITEM.un                                          
                            mgesp.it-ped-fiscal.vl-unit         = tot-vl-unit
                            mgesp.it-ped-fiscal.aliquota-ipi    = ITEM.aliquota-ipi
                            OVERLAY(it-ped-fiscal.char-1,11,8)   = ITEM.class-fisc
                            mgesp.it-ped-fiscal.peso-liq-item   = ITEM.peso-liquido
                            mgesp.it-ped-fiscal.peso-bru-item   = ITEM.peso-bruto. 

                     if l-aloca-estoque then do:                                      
                         IF ITEM.tipo-contr <> 4 and
                            ITEM.baixa-estoq = YES THEN DO: 
                             
                             /*Alocaá∆o por lote*/
                             IF  ITEM.tipo-con-est = 3 THEN DO:
                                 RUN esp/ftp/esftp012f1.p (INPUT YES,                           /*p-log-aloca  */
                                                           INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                           INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                           INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                           INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                           INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                           INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                           INPUT saldo-estoq.lote,              /*p-cod-depos  */
                                                           INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                           OUTPUT TABLE tt-erro-aloc).         
                             END.
                             /*Alocaá∆o sem lote*/
                             ELSE DO:
                                ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + mgesp.it-ped-fiscal.qtde. 
                             END.
                         END.
                     END.
                 END.
             END.
             MESSAGE "Processo Efetuado"
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.


            /*:T Retorna rowid do registro corrente do DBO */
            RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
            
            /*:T Reposiciona registro com base em um rowid */
            RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

          END.
         WHEN FALSE THEN /* No */
          DO:
             MESSAGE "Processo Cancelado"
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             RETURN NO-APPLY.
          END.
     END CASE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGeraItensTransf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGeraItensTransf wMasterDetail
ON CHOOSE OF btGeraItensTransf IN FRAME fPage1 /* Gera Itens Transf */
DO:
    DEFINE VARIABLE c-cod-depos LIKE saldo-estoq.cod-depos NO-UNDO.
    DEFINE VARIABLE i-seq       AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE tot-vl-unit AS DECIMAL                 NO-UNDO.
    DEFINE VARIABLE rGoTo       AS ROWID                   NO-UNDO.
    DEFINE VARIABLE i           AS INTEGER NO-UNDO.
    DEFINE VARIABLE de-fator    AS DEC DECIMALS 4 NO-UNDO.

    DEFINE BUTTON btDepositoCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btDepositoOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtDepositoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 38 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fDeposito
        c-cod-depos       AT ROW 1.21 COL 15.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5 BY .88
        btDepositoOK      AT ROW 2.63 COL 2.14
        btDepositoCancel  AT ROW 2.63 COL 13
        rtDepositoButton  AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Dep¢sito" FONT 1
             DEFAULT-BUTTON btDepositoOK CANCEL-BUTTON btDepositoCancel.

    ON "CHOOSE":U OF btDepositoOK IN FRAME fDeposito DO:
        ASSIGN c-cod-depos.

        /* Valida se o Dep¢sito existe */
        FIND FIRST deposito NO-LOCK
            WHERE  deposito.cod-depos = c-cod-depos NO-ERROR.
        IF  NOT AVAIL deposito THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Dep¢sito":U).
            APPLY "ENTRY":U TO c-cod-depos IN FRAME fDeposito.
            RETURN NO-APPLY.
        END.

        /* Valida se o Dep¢sito permite Alocaá∆o */
        IF  NOT deposito.alocado THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Dep¢sito n∆o permite alocaá∆o.":U).
            APPLY "ENTRY":U TO c-cod-depos IN FRAME fDeposito.
            RETURN NO-APPLY.
        END.

        IF
           c-cod-depos = "ALM" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "N∆o permitido solicitar do dep¢sito ALM").
            APPLY "ENTRY":U TO c-cod-depos IN FRAME fDeposito.
            RETURN NO-APPLY.
        END.

        IF
           c-cod-depos = "WAL" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "N∆o permitido solicitar do dep¢sito WAL").
            APPLY "ENTRY":U TO c-cod-depos IN FRAME fDeposito.
            RETURN NO-APPLY.
        END.


        FIND LAST it-ped-fiscal NO-LOCK
            WHERE it-ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-ERROR.
        IF  AVAIL it-ped-fiscal THEN 
            ASSIGN i-seq = it-ped-fiscal.seq.
        ELSE
            ASSIGN i-seq = 0.


       EMPTY TEMP-TABLE tt-fator.
       RUN esp/es0018p.p (INPUT "esftp012", /* Nome do programa */
                           INPUT 5,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR EACH tt-prog-ponto:
            DO  i = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo, ";"):
                IF  i = 1  THEN
                    ASSIGN de-fator = dec(ENTRY(i, tt-prog-ponto.conteudo, ";")).
                ELSE DO:
                    CREATE tt-fator.
                    ASSIGN tt-fator.emitente = INT(ENTRY(i, tt-prog-ponto.conteudo, ";"))
                           tt-fator.fator    = de-fator.
                END.
            END.
        END.

        DO TRANS:
            FOR EACH  saldo-estoq EXCLUSIVE-LOCK
                WHERE saldo-estoq.cod-depos    = c-cod-depos
                  AND saldo-estoq.cod-estabel  = ttPed-fiscal.cod-estabel
                  AND saldo-estoq.cod-localiz  = ""
                  AND (saldo-estoq.qtidade-atu - 
                       saldo-estoq.qt-alocada  - 
                       saldo-estoq.qt-aloc-ped - 
                       saldo-estoq.qt-aloc-prod) > 0
                   BY saldo-estoq.dt-vali-lote:
    
                FIND FIRST item NO-LOCK
                    WHERE item.it-codigo = saldo-estoq.it-codigo NO-ERROR.

                FIND FIRST in-grup-estoq NO-LOCK
                     WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
                      
                ASSIGN i-seq = i-seq + 1.
    
                FIND item-estab NO-LOCK WHERE item-estab.it-codigo = ITEM.it-codigo AND item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.
                IF AVAILABLE item-estab THEN DO:
                    ASSIGN  tot-vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
    
                FIND item-estab NO-LOCK 
                    WHERE item-estab.it-codigo = ITEM.it-codigo AND 
                          item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.
                IF AVAILABLE item-estab THEN DO:
                    ASSIGN  tot-vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
                    FIND FIRST natureza-ped-fiscal NO-LOCK
                        WHERE natureza-ped-fiscal.natureza = int(ttped-fiscal.nat-oper) NO-ERROR.

                    IF ttped-fiscal.nat-oper = 8
                    OR ttped-fiscal.nat-oper = 35 THEN DO:
                        FIND FIRST tt-fator NO-LOCK
                             WHERE tt-fator.emitente = ttped-fiscal.cod-emitente NO-ERROR.
                        IF  AVAIL tt-fator THEN
                            ASSIGN  tot-vl-unit = ttIt-ped-fiscal.vl-unit / tt-fator.fator.  
                    END.
                END.
    
                CREATE it-ped-fiscal.
                ASSIGN it-ped-fiscal.nr-pedido              = ttPed-fiscal.nr-pedido
                       it-ped-fiscal.it-codigo              = saldo-estoq.it-codigo
                       it-ped-fiscal.seq                    = i-seq
                       it-ped-fiscal.cod-depos              = saldo-estoq.cod-depos
                       it-ped-fiscal.qtde                   = (saldo-estoq.qtidade-atu - 
                                                               saldo-estoq.qt-alocada  - 
                                                               saldo-estoq.qt-aloc-ped - 
                                                               saldo-estoq.qt-aloc-prod)
                       it-ped-fiscal.un                     = item.un                                          
                       it-ped-fiscal.vl-unit                = tot-vl-unit
                       it-ped-fiscal.aliquota-ipi           = item.aliquota-ipi
                       OVERLAY(it-ped-fiscal.char-1,11,8)   = item.class-fisc
                       it-ped-fiscal.peso-liq-item          = ITEM.peso-liquido
                       it-ped-fiscal.peso-bru-item          = ITEM.peso-bruto. 
    
                IF  l-aloca-estoque THEN DO:
                    IF  item.tipo-contr <> 4 and
                        item.baixa-estoq = YES THEN DO:

                        FIND FIRST in-grup-estoq NO-LOCK
                             WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                        /*Alocaá∆o por lote*/
                        IF ITEM.tipo-con-est = 3 THEN DO:
                            RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                                     INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                     INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                     INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                     INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                     INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                     INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                     INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                     OUTPUT TABLE tt-erro-aloc).         
                            FOR FIRST tt-erro-aloc:
                                MESSAGE tt-erro-aloc.mensagem VIEW-AS ALERT-BOX.
                            END.
                        END.
                        /*Alocaá∆o sem lote*/
                        ELSE DO:
                            ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + it-ped-fiscal.qtde.
                        END.
                    END.
                END.
            END.
          END.
        END.
        MESSAGE "Processo Efetuado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fDeposito.
    END.

    ENABLE c-cod-depos btDepositoOK btDepositoCancel 
        WITH FRAME fDeposito. 

    WAIT-FOR "GO":U OF FRAME fDeposito.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImport wMasterDetail
ON CHOOSE OF btImport IN FRAME fPage0 /* Importar */
DO:
    RUN esp/ftp/esftp012d.w (OUTPUT c-arquivo,
                             OUTPUT l-ok).

    IF l-ok AND SEARCH(c-arquivo) <> ? THEN DO:
        RUN pi-importa.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).
    END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btNotaDev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNotaDev wMasterDetail
ON CHOOSE OF btNotaDev IN FRAME fPage1 /* Nota Devoluá∆o */
DO:
    DEFINE VARIABLE rGoTo AS ROWID       NO-UNDO.
    RUN esp/ftp/esftp012h.w (INPUT TABLE ttped-fiscal).


    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNotaRem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNotaRem wMasterDetail
ON CHOOSE OF btNotaRem IN FRAME fPage1 /* Nota Remessa Industrializacao */
DO:
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DEFINE VARIABLE i-seq AS INT   NO-UNDO.
    
    DEFINE BUTTON btNotaCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btNotaOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtNotaButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    def var i-nro-docto    like docum-est.nro-docto.
    def var c-serie        like docum-est.serie.
    def var c-cod-emitente like docum-est.cod-emitente.
    def var c-cod-depos    like mgesp.it-ped-fiscal.cod-depos.
    
    
    DEFINE FRAME fNotaRem
        
        i-nro-docto       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-serie           AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-cod-depos       AT ROW 3.21 COL 17.72 COLON-ALIGNED
        c-cod-emitente    AT ROW 4.21 COL 17.72 COLON-ALIGNED
        btNotaOK          AT ROW 5.63 COL 2.14
        btNotaCancel      AT ROW 5.63 COL 13
        rtNotaButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Nota Remessa" FONT 1
             DEFAULT-BUTTON btNotaOK CANCEL-BUTTON btNotaCancel.
    
    ON "CHOOSE":U OF btNotaOK IN FRAME fNotaRem DO:
    
    
        FIND FIRST deposito NO-LOCK 
            WHERE deposito.cod-depos = INPUT FRAME fNotaRem c-cod-depos NO-ERROR.
        IF NOT AVAIL deposito THEN DO:
            MESSAGE "Dep¢sito Inv†lido"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
        END.
/*
        IF ttped-fiscal.cod-estabel = "101" AND
           c-cod-depos = "ACA" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "N∆o permitido solicitar do dep¢sito ACA").
            RETURN NO-APPLY.
        END.
*/
        FIND FIRST item-doc-est NO-LOCK 
             WHERE item-doc-est.nro-docto    = INPUT FRAME fNotaRem i-nro-docto 
             AND   item-doc-est.serie-docto  = INPUT FRAME fNotaRem c-serie
             AND   item-doc-est.cod-emitente = INPUT FRAME fNotaRem c-cod-emitente NO-ERROR.
             
        IF NOT AVAIL item-doc-est THEN DO:
            MESSAGE "Nota fiscal de Entrada n∆o encontrada"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
        END.
     

        FIND mgesp.ped-fiscal 
            WHERE mgesp.ped-fiscal.nr-pedido = INPUT FRAME fPage0 ttPed-fiscal.nr-pedido NO-LOCK.

        FIND LAST mgesp.it-ped-fiscal OF mgesp.ped-fiscal NO-LOCK NO-ERROR.
        IF AVAIL mgesp.it-ped-fiscal THEN
           ASSIGN i-seq = mgesp.it-ped-fiscal.seq.
        ELSE
           ASSIGN i-seq = 0.

        DO TRANS:

            FOR EACH item-doc-est NO-LOCK 
                WHERE item-doc-est.nro-docto    = INPUT FRAME fNotaRem i-nro-docto 
                AND   item-doc-est.serie-docto  = INPUT FRAME fNotaRem c-serie     
                AND   item-doc-est.cod-emitente = INPUT FRAME fNotaRem c-cod-emitente:
                
                FIND FIRST mgesp.it-ped-fiscal 
                    WHERE mgesp.it-ped-fiscal.nr-pedido = mgesp.ped-fiscal.nr-pedido 
                    AND   mgesp.it-ped-fiscal.it-codigo = item-doc-est.it-codigo NO-ERROR.

                FIND FIRST item 
                     WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

                FIND FIRST in-grup-estoq NO-LOCK
                     WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
                      
/*                 IF  AVAIL in-grup-estoq                                                            */
/*                 AND in-grup-estoq.log-ckd THEN DO:                                                 */
/*                                                                                                    */
/*                     RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                      */
/*                                        INPUT 1,        /* Ponto do programa */                     */
/*                                        INPUT 0,                                                    */
/*                                        INPUT "",                                                   */
/*                                        OUTPUT TABLE tt-prog-ponto) NO-ERROR.                       */
/*                                                                                                    */
/*                     IF CAN-FIND (FIRST tt-prog-ponto                                               */
/*                                  WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel) THEN DO: */
/*                                                                                                    */
/*                         IF  ttPed-fiscal.nat-oper <> 8                                             */
/*                         AND ttPed-fiscal.nat-oper <> 9                                             */
/*                         AND ttped-fiscal.nat-oper <> 28 THEN DO:                                   */
/*                             NEXT.                                                                  */
/*                         END.                                                                       */
/*                     END.                                                                           */
/*                 END.                                                                               */
                    
                IF NOT AVAIL mgesp.it-ped-fiscal THEN DO:
                   ASSIGN i-seq = i-seq + 1.
                   CREATE mgesp.it-ped-fiscal.
                   ASSIGN mgesp.it-ped-fiscal.nr-pedido = mgesp.ped-fiscal.nr-pedido
                          mgesp.it-ped-fiscal.it-codigo = item-doc-est.it-codigo
                          mgesp.it-ped-fiscal.seq       = i-seq.
                END.
                ASSIGN mgesp.it-ped-fiscal.aliquota-ipi = item-doc-est.aliquota-ipi
                       mgesp.it-ped-fiscal.cod-depos    = INPUT FRAME fNotaRem c-cod-depos
                       mgesp.it-ped-fiscal.qtde         = mgesp.it-ped-fiscal.qtde + item-doc-est.quantidade
                       mgesp.it-ped-fiscal.un           = item-doc-est.un
                       mgesp.it-ped-fiscal.vl-unit      = item-doc-est.preco-unit[1]
                       overlay(mgesp.it-ped-fiscal.char-1,11,8) = item.class-fisc
                       mgesp.it-ped-fiscal.peso-liq-item  = ITEM.peso-liquido
                       mgesp.it-ped-fiscal.peso-bru-item  = ITEM.peso-bruto.
                
                IF ITEM.tipo-contr <> 4 and
                   item.baixa-estoq = YES THEN DO:
                    if l-aloca-estoque then do:                   

                        FIND FIRST in-grup-estoq NO-LOCK
                             WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                        /*Alocaá∆o por lote*/
                        IF ITEM.tipo-con-est = 3 THEN DO:
                            RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                                     INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                     INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                     INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                     INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                     INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                     INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                     INPUT item-doc-est.quantidade,       /*p-qtde-alocar*/
                                                     OUTPUT TABLE tt-erro-aloc).         
                            FOR FIRST tt-erro-aloc:
                                RUN utp/ut-msgs.p (INPUT "show":U, 
                                                    INPUT 17567, 
                                                    INPUT tt-erro-aloc.mensagem).
                                NEXT.
                            END.
                        END.
                        /*Alocaá∆o sem lote*/
                        ELSE DO:
                            find first saldo-estoq
                                 where saldo-estoq.it-codigo   = mgesp.it-ped-fiscal.it-codigo
                                   and saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                                   and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localiz
                                   and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos no-lock no-error.           
                                    
                            if not avail saldo-estoq then do:
                                 RUN utp/ut-msgs.p (INPUT "show":U, 
                                                    INPUT 17567, 
                                                    INPUT "Item sem saldo em estoque " + mgesp.it-ped-fiscal.it-codigo).
                                 next.
                            end.
                            if saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                               saldo-estoq.qt-aloc-prod < item-doc-est.quantidade then do:
                                 RUN utp/ut-msgs.p (INPUT "show":U, 
                                                    INPUT 17567, 
                                                    INPUT "Item com saldo " + string(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                                          saldo-estoq.qt-aloc-prod) + " em estoque menor que a quantidade informada " + string(item-doc-est.quantidade) + ", inclus∆o n∆o permitida":U ).
                               next.
                            end.                    
                           
                            find current saldo-estoq exclusive-lock no-error.
                            assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + item-doc-est.quantidade.    
                            release saldo-estoq.
                        END.
                    end.
                END.
            END.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fNotaRem.
    END.
    
    ENABLE i-nro-docto c-serie c-cod-emitente c-cod-depos btNotaOK btNotaCancel 
        WITH FRAME fNotaRem. 
    
    WAIT-FOR "GO":U OF FRAME fNotaRem.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es150.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    ASSIGN novo = 2.

    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/ftp/esftp012a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/UpdateSon.i &ProgramSon="esp/ftp/esftp012b.w" &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMasterDetail
ON LEAVE OF fi-cod-emitente IN FRAME fPage0 /* Cliente */
DO:
    {method/ReferenceFields.i 
      &HandleDBOLeave="hDBOEmitente"
      &KeyValue1="fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome-emit"
      &FieldScreen1="cNome-emit"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
    for first mgesp.ponto-programa
        where ponto-programa.nome-programa = "esftp012"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.conteudo = "Sim":
        assign l-aloca-estoque = yes.
    end.


{masterdetail/MainBlock.i}

    for first mgesp.ponto-programa
        where ponto-programa.nome-programa = "esftp012"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.conteudo = "Sim":
        assign l-aloca-estoque = yes.
    end.

    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterControlToolBar wMasterDetail 
PROCEDURE afterControlToolBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND CURRENT ttPed-fiscal NO-LOCK NO-ERROR.
    IF AVAIL ttPed-fiscal THEN DO:
    
        IF ttPed-fiscal.situacao > 0 then do:
              DISABLE btDelete btUpdate WITH FRAME {&FRAME-NAME}.
              DISABLE btAddSon1 btCopySon1 btDeleteSon1 btUpdateSon1 btNotaDev btNotaRem btGeraItensIND WITH FRAME fPage1.

              IF ttPed-fiscal.situacao = 2 AND (ttped-fiscal.nat-oper = 8 OR ttped-fiscal.nat-oper = 9) THEN DO: /*habilita quando for sucateamento sem aprovacao*/
                  ENABLE btDelete btUpdate WITH FRAME {&FRAME-NAME}.
                  ENABLE btAddSon1 btCopySon1 btDeleteSon1 btUpdateSon1 btNotaDev btNotaRem btGeraItensIND WITH FRAME fPage1.
              END.

              IF (ttPed-fiscal.situacao = 2 OR ttPed-fiscal.situacao = 3) THEN DO:
                  ENABLE bt-situacao WITH FRAME {&FRAME-NAME}.
              END.
        END.
    
        IF  ttped-fiscal.situacao = 0 THEN
            ENABLE btCalculaFrete WITH FRAME fpage1.
        ELSE
            DISABLE btCalculaFrete WITH FRAME fpage1.

        IF  ttped-fiscal.situacao <= 1 THEN 
            ENABLE bt-libera WITH FRAME fpage1.
        ELSE
            DISABLE bt-libera WITH FRAME fpage1.    

        FIND natureza-ped-fiscal NO-LOCK
            WHERE natureza-ped-fiscal.natureza = ttped-fiscal.nat-oper NO-ERROR.

        IF  AVAIL  natureza-ped-fiscal THEN DO:
            IF  natureza-ped-fiscal.Ind-hab-ger-it-ind  THEN
                ENABLE btGeraItensIND WITH FRAME fpage1.
            ELSE
                DISABLE btGeraItensIND WITH FRAME fpage1.
            
            IF  natureza-ped-fiscal.Ind-hab-ger-it-trans  THEN
                ENABLE btGeraItensTransf WITH FRAME fPage1.
            ELSE
                DISABLE btGeraItensTransf WITH FRAME fPage1.
            
            IF  natureza-ped-fiscal.Ind-hab-ger-it  THEN
                ENABLE btGeraItens WITH FRAME fpage1.
            ELSE
                DISABLE btGeraItens WITH FRAME fpage1.

            IF  natureza-ped-fiscal.Ind-hab-ger-nf-dev  THEN
                ENABLE btNotaDev WITH FRAME fpage1.
            ELSE
                DISABLE btNotaDev WITH FRAME fpage1.

        END.
        ELSE DO:
             DISABLE btGeraItensIND    WITH FRAME fpage1.
             DISABLE btGeraItens       WITH FRAME fpage1.
             DISABLE btGeraItensTransf WITH FRAME fPage1.
             DISABLE btNotaDev         WITH FRAME fPage1.
        END.
        
    END. /* IF AVAIL ttPed-fiscal THEN DO: */
/*     DISABLE btCalculaFrete WITH FRAME fpage1. */
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMasterDetail 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
 /*   {btb/btb008za.i3}
       
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
   */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF AVAIL ttped-fiscal THEN
       ASSIGN fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0 = string(ttped-fiscal.cod-emitente).

    APPLY 'Leave' TO fi-cod-emitente IN FRAME {&FRAME-NAME}.

    ENABLE btNotaDev WITH FRAME fPage1.
    
    if v_cod_estab_usuar = "102" then ENABLE  btNotaRem WITH FRAME fPage1.

    RUN piComodato.

    IF (ttPed-fiscal.situacao = 2  OR 
        ttPed-fiscal.situacao = 3) THEN DO:

        ASSIGN bt-situacao:SENSITIVE IN FRAME fPage0 = YES.
    END.
    ELSE 
        ASSIGN bt-situacao:SENSITIVE IN FRAME fPage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraItensTerceirosTtItTercNf wMasterDetail 
PROCEDURE geraItensTerceirosTtItTercNf :
/* Definiªío dos par¸metros de Entrada/Sada */
    
    def input  param p-c-serie-terc      like saldo-terc.serie-docto   no-undo.
    def input  param p-c-nr-nota-terc    like saldo-terc.nro-docto     no-undo.
    def input  param p-c-nat-oper-terc   like saldo-terc.nat-operacao  no-undo.
    def output param table               for tt-it-terc-nf.
    def output param p-l-procedimento-ok as   log                      no-undo.

    DEF BUFFER b-componente FOR componente.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    def var l-proc-ok-aux as log    no-undo.

    for each tt-it-terc-nf exclusive:
        delete tt-it-terc-nf.
    end.

    for each saldo-terc 
        where saldo-terc.nro-docto    = p-c-nr-nota-terc 
        and   saldo-terc.serie-docto  = p-c-serie-terc 
        and   saldo-terc.nat-operacao = p-c-nat-oper-terc 
        and   saldo-terc.cod-emitente = mgesp.ped-fiscal.cod-emitente  no-lock,
        first componente
        where componente.serie-docto  = saldo-terc.serie-docto
        and   componente.nro-docto    = saldo-terc.nro-docto
        and   componente.cod-emitente = saldo-terc.cod-emitente
        and   componente.nat-operacao = saldo-terc.nat-operacao
        and   componente.it-codigo    = saldo-terc.it-codigo
        and   componente.cod-refer    = saldo-terc.cod-refer
        and   componente.sequencia    = saldo-terc.sequencia no-lock:

        FIND ITEM WHERE item.it-codigo = saldo-terc.it-codigo
            NO-LOCK NO-ERROR.
        IF saldo-terc.quantidade - saldo-terc.dec-1 <= 0 THEN NEXT.
        create tt-it-terc-nf.
        assign tt-it-terc-nf.rw-saldo-terc     = rowid(saldo-terc)
               tt-it-terc-nf.sequencia         = saldo-terc.sequencia
               tt-it-terc-nf.it-codigo         = saldo-terc.it-codigo
               tt-it-terc-nf.cod-refer         = saldo-terc.cod-refer
               tt-it-terc-nf.desc-nar          = if  item.tipo-contr = 4 /* D˝bito Direto */
                                                 then substr(item.narrativa,1,60)
                                                 else item.desc-item
               tt-it-terc-nf.quantidade        = saldo-terc.quantidade
               tt-it-terc-nf.qt-alocada        = saldo-terc.dec-1
               tt-it-terc-nf.qt-disponivel     = saldo-terc.quantidade - saldo-terc.dec-1
               tt-it-terc-nf.qt-disponivel-inf = (saldo-terc.quantidade - saldo-terc.dec-1)
               tt-it-terc-nf.preco-total       = componente.preco-total[1]
               tt-it-terc-nf.selecionado       = no.

        for each b-componente
            fields (b-componente.componente
                    b-componente.preco-total[1]
                    b-componente.desconto[1])
            where b-componente.cod-emitente = componente.cod-emitente 
            and   b-componente.nro-comp     = componente.nro-docto    
            and   b-componente.serie-comp   = componente.serie-docto  
            and   b-componente.nat-comp     = componente.nat-operacao 
            and   b-componente.it-codigo    = componente.it-codigo    
            and   b-componente.cod-refer    = componente.cod-refer   
            and   b-componente.seq-comp     = componente.sequencia 
            and   (   b-componente.quantidade <> 0
                   or b-componente.dt-retorno <= mgesp.ped-fiscal.dt-emissao ) no-lock: /* NF Reajuste ate Dt Trans */ 
    

            if  b-componente.componente = 1 then /* Envio */
                assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total + b-componente.preco-total[1].
            else /* Retorno */
                assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total - b-componente.preco-total[1].
        end.

/*         if  natur-oper.tp-oper-terc = 6 then /* Reajuste de preØo */       */
/*             assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total . */

        assign tt-it-terc-nf.preco-total     = if tt-it-terc-nf.preco-total < 0 then 0
                                               else tt-it-terc-nf.preco-total
               tt-it-terc-nf.preco-total-inf = tt-it-terc-nf.preco-total.
    end.

    for each RowErrors
        where RowErrors.ErrorType = "INTERNAL":U:
        delete RowErrors.
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    
    DEFINE VARIABLE iNr-pedido LIKE {&ttParent}.nr-pedido NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        iNr-pedido AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para mgesp.ped-fiscal" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iNr-pedido .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iNr-pedido).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Ped-fiscal":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iNr-pedido btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord2 wMasterDetail 
PROCEDURE goToRecord2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rGoTo AS ROWID       NO-UNDO.

    /* Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

    /* Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-mensagem = "AP‡S O TêRMINO DA DIGITAÄ«O DO SEU PEDIDO, PRESSIONE O BOT«O LIB.SUPERVISOR. " + CHR(13) +
                        "O E-MAIL PARA APROVAÄ«O/REPROVAÄ«O SERµ ENVIADO A SEU SUPERVISOR." + CHR(13) +
                        "SOMENTE AP‡S ESTE PROCEDIMENTO ESTE PEDIDO ESTARµ DISPON÷VEL PARA FATURAMENTO".

    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 17006,
                      INPUT "ATENÄ«O~~" + c-mensagem).



    /* MESSAGE "****************************************************************" SKIP  */
    /*         "                           A T E N Ä « O                        " SKIP  */
    /*         "****************************************************************" SKIP  */
    /*         "   AP‡S O TêRMINO DA DIGITAÄ«O DO SEU PEDIDO DE SOLICITAÄ«O DE  " SKIP  */
    /*         "   NOTA EXTRA, DEVERµ SER PRESSIONADO O BOT«O                   " SKIP  */
    /*         "                                                                " SKIP  */
    /*         "                         LIB.SUPERVISOR                         " SKIP  */
    /*         "                                                                " SKIP  */
    /*         "                                                                " SKIP  */
    /*         "   AP‡S ESTE PROCEDIMENTO O SEU SUPERVISOR RECEBERµ UM E-MAIL   " SKIP  */
    /*         "   ONDE ELE DEVERµ APROVAR OU REPROVAR ESTE PEDIDO              " SKIP  */
    /*         "   SOMENTE AP‡S ESTE PROCEDIMENTO ESTE PEDIDO ESTARµ DISPON÷VEL " SKIP  */
    /*         "   PARA FATURAMENTO                                             " SKIP  */
    /*         "                                                                " SKIP  */
    /*         "   CONFORME E-MAIL ENVIADO PELO COMIT“ DE SEGURANÄA             " SKIP  */
    /*         "                                                                " SKIP  */
    /*         "   AGORA PRESSIONE O BOT«O (OK) PARA CONTINUAR                  " SKIP  */
    /*         "****************************************************************" SKIP  */
    /*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                           */

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes150.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes150.p YES}
        {btb/btb008za.i2 esbo/boes150.p '' {&hDBOParent}} 
    END.
    RUN setConstraintUsuario IN {&hDBOParent} (v_cod_usuar_corren).
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Usuario":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes103.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes103.p YES}
        {btb/btb008za.i2 esbo/boes103.p '' {&hDBOSon1}} 
    END.

    IF NOT VALID-HANDLE(hDBOEmitente) OR
       hDBOEmitente:TYPE <> "PROCEDURE":U OR
       hDBOEmitente:FILE-NAME <> "adbo/boad098na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098na.p YES}
        {btb/btb008za.i2 adbo/boad098na.p '' hDBOEmitente} 
    END.
    RUN openQueryStatic IN hDBOEmitente (INPUT "Main":U) NO-ERROR.
/*
    IF NOT VALID-HANDLE(hDBOItem) OR
       hDBOItem:TYPE <> "PROCEDURE":U OR
       hDBOItem:FILE-NAME <> "inbo/boin172na.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p '' hDBOItem} 
    END.
    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bodi317in) THEN DO:
        run dibo/bodi317in.p persistent set h-bodi317in.
        run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                         output h-bodi317sd,     
                                         output h-bodi317im1bra,
                                         output h-bodi317va).
    END.
*/

    ASSIGN btDet:SENSITIVE    IN FRAME fPage0 = YES
           btImport:SENSITIVE IN FRAME fPage0 = YES
           btCkd:SENSITIVE IN FRAME fPage0 = YES.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    {masterdetail/OpenQueriesSon.i &Parent="Ped-fiscal" &Query="Ped-fiscal" &PageNumber="1"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ckd wMasterDetail 
PROCEDURE pi-ckd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST it-ped-fiscal OF ttPed-fiscal NO-LOCK NO-ERROR.

    IF AVAIL it-ped-fiscal THEN
        ASSIGN i-sequencia = it-ped-fiscal.seq.
    ELSE
        ASSIGN i-sequencia = 0.

    blk_ckd:
    DO TRANSACTION:
        FOR EACH saldo-estoq no-lock
           WHERE saldo-estoq.cod-depos   = c-cod-depos
             AND saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
             AND saldo-estoq.cod-localiz = c-cod-localiz
             AND saldo-estoq.lote        = c-lote
             AND (saldo-estoq.qtidade-atu - 
                  saldo-estoq.qt-alocada  - 
                  saldo-estoq.qt-aloc-ped - 
                  saldo-estoq.qt-aloc-prod) > 0 
              BY saldo-estoq.dt-vali-lote:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = saldo-estoq.it-codigo  NO-ERROR.

            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

            IF NOT AVAIL in-grup-estoq
            OR NOT in-grup-estoq.log-ckd
            OR ITEM.tipo-con-est <> 3 THEN
                NEXT.
         
            FIND FIRST item-estab NO-LOCK
                 WHERE item-estab.it-codigo   = ITEM.it-codigo 
                   AND item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.

            ASSIGN i-sequencia = i-sequencia + 1.
         
            CREATE it-ped-fiscal.
            ASSIGN it-ped-fiscal.nr-pedido       = ttPed-fiscal.nr-pedido
                   it-ped-fiscal.it-codigo       = saldo-estoq.it-codigo
                   it-ped-fiscal.seq             = i-sequencia
                   it-ped-fiscal.cod-depos       = saldo-estoq.cod-depos
                   it-ped-fiscal.qtde            = (saldo-estoq.qtidade-atu - 
                                                    saldo-estoq.qt-alocada  - 
                                                    saldo-estoq.qt-aloc-ped - 
                                                    saldo-estoq.qt-aloc-prod)
                   it-ped-fiscal.un              = ITEM.un                                          
                   it-ped-fiscal.vl-unit         = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]
                   it-ped-fiscal.aliquota-ipi    = ITEM.aliquota-ipi
                   OVERLAY(it-ped-fiscal.char-1,11,8) = ITEM.class-fisc
                   it-ped-fiscal.peso-liq-item   = ITEM.peso-liquido
                   it-ped-fiscal.peso-bru-item   = ITEM.peso-bruto. 

            IF  ttPed-fiscal.nat = 25
            OR  ttPed-fiscal.nat = 26 THEN DO:
                FIND FIRST item-estab NO-LOCK
                     WHERE item-estab.it-codigo   = ITEM.it-codigo 
                       AND item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.

                IF AVAIL item-estab THEN DO:
                    ASSIGN it-ped-fiscal.vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
                    IF (ttped-fiscal.cod-estabel = "101" and
                        ttped-fiscal.cod-emitente = 141000) OR 
                       (ttped-fiscal.cod-estabel = "104" and
                        ttped-fiscal.cod-emitente = 103748) THEN . 
                    ELSE
                        IF  ttped-fiscal.cod-emitente = 143524 THEN
                            ASSIGN It-ped-fiscal.vl-unit = It-ped-fiscal.vl-unit / 0.93.  
                        ELSE
                            ASSIGN It-ped-fiscal.vl-unit = It-ped-fiscal.vl-unit / 0.88. 
                END.
            END.
            ELSE DO:
                ASSIGN it-ped-fiscal.vl-unit = DEC(ENTRY(3,c-linha,";")).
                IF  it-ped-fiscal.vl-unit = 0 
                AND ITEM.tipo-contr = 2       
                AND ITEM.it-codigo BEGINS "4" THEN DO:
                    FOR EACH preco-item NO-LOCK
                       WHERE preco-item.it-codigo = ITEM.it-codigo
                         AND preco-item.nr-tabpre = "minimo"
                         AND preco-item.situacao = 1
                         AND preco-item.dt-inival < TODAY,
                       FIRST tb-preco NO-LOCK
                       WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre
                         AND tb-preco.situacao = 1
                         AND tb-preco.dt-inival <= TODAY
                         AND tb-preco.dt-fimval >= TODAY
                       BREAK BY preco-item.preco-venda:
                       ASSIGN it-ped-fiscal.vl-unit = preco-item.preco-venda.
                        LEAVE.
                    END.
                END.
            END.
            
            IF ITEM.baixa-estoq = YES THEN DO: 
                /*Alocaá∆o por lote*/
                RUN esp/ftp/esftp012f1.p (INPUT YES,                           /*p-log-aloca  */
                                          INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                          INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                          INPUT it-ped-fiscal.seq,             /*p-seq        */
                                          INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                          INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                          INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                          INPUT saldo-estoq.lote,              /*p-lote       */
                                          INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                          OUTPUT TABLE tt-erro-aloc).  
            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-estrutura wMasterDetail 
PROCEDURE pi-cria-tt-estrutura :
DEF INPUT PARAM p-it-codigo LIKE estrutura.it-codigo NO-UNDO.
    DEF INPUT PARAM p-qtde AS INTE NO-UNDO.

    for each estrutura no-lock
       where estrutura.it-codigo    = p-it-codigo
         and estrutura.data-inicio <= today
         and estrutura.data-termino > today:

        IF estrutura.fantasma = NO THEN DO:
            FIND FIRST tt-item
                 WHERE tt-item.it-codigo = estrutura.es-codigo NO-ERROR.
            IF NOT AVAIL tt-item THEN DO:
                CREATE tt-item.
                ASSIGN tt-item.it-codigo = estrutura.es-codigo.
            END.
            ASSIGN tt-item.qtde = tt-item.qtde + (estrutura.quant-usada * p-qtde).
        END.
        ELSE DO:
            RUN pi-cria-tt-estrutura (INPUT estrutura.es-codigo, INPUT (estrutura.quant-usada * p-qtde)).
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-html wMasterDetail 
PROCEDURE pi-html :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMes        AS CHAR INIT "JANEIRO, FEVEREIRO, MARÄO, ABRIL, MAIO, JUNHO, JULHO, AGOSTO, SETEMBRO, OUTUBRO, NOVEMBRO, DEZEMBRO" NO-UNDO.
DEFINE VARIABLE cArqDestino AS CHARACTER   NO-UNDO.

FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = ped-fiscal.cod-estabel
       AND nota-fiscal.serie       = ped-fiscal.serie
       AND nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis NO-ERROR.

FIND FIRST it-ped-fiscal OF ped-fiscal NO-ERROR.
FIND FIRST ITEM NO-LOCK
     WHERE ITEM.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.

/* define o valor inicial para as variaveis */
ASSIGN cArqDestino = SESSION:TEMP-DIRECTORY + string(ped-fiscal.nr-pedido) + ".txt".

OUTPUT TO VALUE(cArqDestino).

PUT UNFORMATTED "<html>" SKIP.
    PUT UNFORMATTED "<body bgcolor='#F8F8F8'><span style='font-size:20px;'>Ol&aacute;, Tudo bem?<br />" SKIP.
        PUT UNFORMATTED "<br/>" SKIP.
        PUT UNFORMATTED "Favor responder este e-mail com &quot;Eu Aceito&quot; para que possamos dar andamento<br />" SKIP.
        PUT UNFORMATTED "na libera&ccedil;&atilde;o do sua solicita&ccedil;&atilde;o.<br />" SKIP.
        PUT UNFORMATTED "<br />" SKIP.
        PUT UNFORMATTED "Agradecemos desde j&aacute;.</span><br />" SKIP.
    
        PUT UNFORMATTED "<table border='0' cellpadding='0' cellspacing='0' style='width: 691px;margin-left:5px;'>" SKIP.
                PUT UNFORMATTED "<tbody>" SKIP.
                        PUT UNFORMATTED "<tr>" SKIP.
                                PUT UNFORMATTED "<td style='padding-left:14px;padding-bottom:17px;'><img alt='' height='130' src='https://intelbras.topdesk.net/tas/image?key=lookandfeel.ssd.login.logo' width='320' /></td>" SKIP.
                        PUT UNFORMATTED "</tr>" SKIP.
                        PUT UNFORMATTED "<tr>" SKIP.
                                PUT UNFORMATTED "<td height='30' style='background-color:#00A94C; margin-left:10px;-webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;vertical-align:middle; width:691px;overflow:hidden;margin-left:12px;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;color:#fff;' valign='top' width='691'>&nbsp; &nbsp; Comodato Solicita&ccedil;&atilde;o&nbsp;[N£mero_da_mudanáa]</td>" SKIP.
                        PUT UNFORMATTED "</tr>" SKIP.
                        PUT UNFORMATTED "<tr>" SKIP.
                                PUT UNFORMATTED "<td align='left' valign='top'>" SKIP.
                                PUT UNFORMATTED "<table border='0' cellpadding='0' cellspacing='0' style='width: 705px;'>" SKIP.
                                        PUT UNFORMATTED "<tbody>" SKIP.
                                                PUT UNFORMATTED "<tr>" SKIP.
                                                        PUT UNFORMATTED "<td width='2'>&nbsp;</td>" SKIP.
                                                        PUT UNFORMATTED "<td align='left' bgcolor='#FFFFFF' style='padding-left:14px;padding-right:14px;padding-top:18px;padding-bottom:14px; border-left:1px solid #ddd; border-right:1px solid #ddd; border-bottom:1px solid #ddd;-webkit-border-bottom-right-radius: 5px;-webkit-border-bottom-left-radius: 5px;-moz-border-radius-bottomright: 5px;-moz-border-radius-bottomleft: 5px;border-bottom-right-radius: 5px;border-bottom-left-radius: 5px;' valign='top' width='664'>" SKIP.
                                                        PUT UNFORMATTED "<table border='0' cellpadding='0' cellspacing='0' style='width: 664px'>" SKIP.
                                                                PUT UNFORMATTED "<tbody>" SKIP.
                                                                        PUT UNFORMATTED "<tr>" SKIP.
                                                                                PUT UNFORMATTED "<td align='left' style='font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 20px; color: #000000; line-height: 24px;' valign='top'>" SKIP.
                                                                                PUT UNFORMATTED "<div style='text-align: center;'><br />" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "TERMO DE RECEBIMENTO DE EQUIPAMENTO EM COMODATO</div>" SKIP.
                                                                                PUT UNFORMATTED "&nbsp;" SKIP.
        
                                                                                PUT UNFORMATTED "<table border='0' cellpadding='0' cellspacing='0' style='width: 691px;margin-left:5px;'>" SKIP.
                                                                                        PUT UNFORMATTED "<tbody>" SKIP.
                                                                                                PUT UNFORMATTED "<tr>" SKIP.
                                                                                                        PUT UNFORMATTED "<td style='padding-left:14px;padding-bottom:17px;'>" SKIP.
                                                                                                        PUT UNFORMATTED "<table border='0' cellpadding='0' cellspacing='0' style='width: 664px'>" SKIP.
                                                                                                                PUT UNFORMATTED "<tbody>" SKIP.
                                                                                                                        PUT UNFORMATTED "<tr>" SKIP.
                                                                                                                                PUT UNFORMATTED "<td align='left' style='font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color: #757575; line-height: 21px;' valign='top'>" SKIP.
                                                                                                                                PUT UNFORMATTED "<div style='text-align: left;'><span style='color:#000000;'>&nbsp;<span style='font-size:18px;'>Eu, " + emitente.nome-emit + "- Matr&iacute;cula n.&ordm;  inscrito no CPF sob o n.&ordm; " + emitente.cgc + " , para os devidos fins e a quem de direito interessar, que RECEBI da INTELBRAS S/A - IND&Uacute;STRIA DE TELECOMUNICA&Ccedil;&Atilde;O ELETR&Ocirc;NICA BRASILEIRA, pessoa jur&iacute;dica de direito privado, inscrita no CNPJ sob n&deg; 82901000000127, estabelecida na RODOVIA BR 101, KM 210, AREA INDUSTRIAL, S&Atilde;O JOS&Eacute;/SC, o EQUIPAMENTO abaixo detalhado:</span></span></div>" SKIP.
                                                                                                                                PUT UNFORMATTED "<span style='color:#000000;'>&nbsp;</span>" SKIP.
        
                                                                                                                                PUT UNFORMATTED "<table>" SKIP.
                                                                                                                                        PUT UNFORMATTED "<tbody>" SKIP.
                                                                                                                                                PUT UNFORMATTED "<tr>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#E5E4E2;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;' width='200'><span style='color:#000000;'>Descri&ccedil;&atilde;o</span></td>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#EFEEEC;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;' width='410'>" + it-ped-fiscal.narrativa + "</td>" SKIP.
                                                                                                                                                PUT UNFORMATTED "</tr>" SKIP.
                                                                                                                                                PUT UNFORMATTED "<tr>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#E5E4E2;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;' width='200'><span style='color:#000000;'>N.&ordm; de S&eacute;rie&nbsp;</span></td>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#EFEEEC;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;' width='410'>" + IF NUM-ENTRIES(ped-fiscal.observacao[4],":") >= 2 THEN entry(2,ped-fiscal.observacao[4],":") ELSE "" + "</td>" SKIP.
                                                                                                                                                PUT UNFORMATTED "</tr>" SKIP.
                                                                                                                                                PUT UNFORMATTED "<tr>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#E5E4E2;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;' width='200'><span style='color:#000000;'>Valor (R$)</span></td>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#EFEEEC;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;' width='410'><span style='color:#000000;'>R$" + IF AVAIL nota-fiscal THEN string(nota-fiscal.vl-tot-nota, ">>>>,>>9.99") ELSE "" + "</span></td>" SKIP.
                                                                                                                                                PUT UNFORMATTED "</tr>" SKIP.
                                                                                                                                                PUT UNFORMATTED "<tr>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#E5E4E2;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;font-weight:bold;padding:2px;padding-left:5px;' width='200'><span style='color:#000000;'>Observa&ccedil;&otilde;es</span></td>" SKIP.
                                                                                                                                                        PUT UNFORMATTED "<td style='background-color:#EFEEEC;font-family: Calibri, Arial, Helvetica, Verdana, sans-serif;font-size: 15px;padding:2px;padding-left:5px;' width='410'><span style='color:#000000;'>NF" + ped-fiscal.nr-nota-fis + "</span></td>" SKIP.
                                                                                                                                                PUT UNFORMATTED "</tr>" SKIP.
                                                                                                                                        PUT UNFORMATTED "</tbody>" SKIP.
                                                                                                                                PUT UNFORMATTED "</table>" SKIP.
                                                                                                                                PUT UNFORMATTED "</td>" SKIP.
                                                                                                                        PUT UNFORMATTED "</tr>" SKIP.
                                                                                                                PUT UNFORMATTED "</tbody>" SKIP.
                                                                                                        PUT UNFORMATTED "</table>" SKIP.
                                                                                                        PUT UNFORMATTED "</td>" SKIP.
                                                                                                PUT UNFORMATTED "</tr>" SKIP.
                                                                                        PUT UNFORMATTED "</tbody>" SKIP.
                                                                                PUT UNFORMATTED "</table>" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "<span style='font-size:18px;'>Pelo presente:<br />" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "1.&nbsp;&nbsp; &nbsp;Manifesto total conhecimento do procedimento&nbsp;<a href='https://intelbras.softexpert.com/se/document/dc_view_document/api_view_document.php?cddocument=4153&amp;nmfile=PROCEDIMENTO+PARA+COMODATO+DE+NOTEBOOK%2C+APARELHOS+CELULARES+E+OUTROS+EQUIPAMENTOS.docx'>GTI-TIC-DP-0028</a>;<br />" SKIP.
                                                                                PUT UNFORMATTED "2.&nbsp;&nbsp; &nbsp;Declaro que examinei, testei e recebo o equipamento em perfeito estado de uso e conserva&ccedil;&atilde;o;<br />" SKIP.
                                                                                PUT UNFORMATTED "3.&nbsp;&nbsp; &nbsp;Responsabilizo-me integralmente pela guarda do equipamento;<br />" SKIP.
                                                                                PUT UNFORMATTED "4.&nbsp;&nbsp; &nbsp;Declaro pleno conhecimento da Pol&iacute;tica de Seguran&ccedil;a da Informa&ccedil;&atilde;o da Intelbras;<br />" SKIP.
                                                                                PUT UNFORMATTED "5.&nbsp;&nbsp; &nbsp;Declaro que o referido instrumento traduz a mais expressa manifesta&ccedil;&atilde;o&nbsp;<br />" SKIP.
                                                                                PUT UNFORMATTED "de minha vontade.</span><br />" SKIP.
                                                                                //PUT UNFORMATTED "6.&nbsp;&nbsp; &nbsp;Quando o prazo de permanencia minima do equipamento estiver terminado&nbsp;caso o mesmo ainda esteja em bom estado de utiliza&ccedil;&atilde;o, poder&aacute; ser avaliada a venda&nbsp;do equipamento ao colaborador, para mais informa&ccedil;&otilde;es acessar o procedimento&nbsp;<a href='https://intelbras.softexpert.com/se/document/dc_view_document/api_view_document.php?cddocument=14238&amp;nmfile=d40a5d8f.docx'>GTI-TIC-DP-0067</a>.</span><br />" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "<br />" SKIP.
                                                                                PUT UNFORMATTED "&nbsp;" SKIP.
                                                                                PUT UNFORMATTED "<div style='text-align: right;'><span style='font-size:18px;'>S&atilde;o Jos&eacute; " + string(DAY(nota-fiscal.dt-emis)) + " de " + ENTRY(MONTH(NOTA-FISCAL.DT-EMIS), cMes,",") + " de " + string(YEAR(nota-fiscal.dt-emis),"9999") + ".</span></div>" SKIP.
                                                                                PUT UNFORMATTED "</td>" SKIP.
                                                                        PUT UNFORMATTED "</tr>" SKIP.
                                                                        PUT UNFORMATTED "<tr>" SKIP.
                                                                                PUT UNFORMATTED "<td align='left' style='font-family: Calibri, Arial, Helvetica, Verdana, sans-serif; font-size: 15px; color: #757575; line-height: 21px;' valign='top'>&nbsp;</td>" SKIP.
                                                                        PUT UNFORMATTED "</tr>" SKIP.
                                                                PUT UNFORMATTED "</tbody>" SKIP.
                                                        PUT UNFORMATTED "</table>" SKIP.
                                                        PUT UNFORMATTED "</td>" SKIP.
                                                        PUT UNFORMATTED "<td>&nbsp;</td>" SKIP.
                                                PUT UNFORMATTED "</tr>" SKIP.
                                        PUT UNFORMATTED "</tbody>" SKIP.
                                PUT UNFORMATTED "</table>" SKIP.
                                PUT UNFORMATTED "</td>" SKIP.
                        PUT UNFORMATTED "</tr>" SKIP.
                PUT UNFORMATTED "</tbody>" SKIP.
        PUT UNFORMATTED "</table>" SKIP.
    PUT UNFORMATTED "</body>" SKIP.
PUT UNFORMATTED "</html>" SKIP.



/* /* Comunica com o word */                                                   */
/* CREATE "Word.Application" chWord.                                           */
/*                                                                             */
/* /* preenche os campos do formulario modelo */                               */
/* setaValor("cdEmitente"   , emitente.nome-emit).                             */
/* setaValor("cdMatricula"  , "" /*ped-fiscal.usuario-magnus*/).               */
/* setaValor("cdCPF"        , emitente.cgc).                                   */
/* setaValor("cdDescricao"  , it-ped-fiscal.narrativa) /*ITEM.desc-item)*/.    */
/* setaValor("cdSerie"      , entry(2,ped-fiscal.observacao[4],":")).          */
/* setaValor("cdValor"      , string(nota-fiscal.vl-tot-nota, ">>>>,>>9.99")). */
/* setaValor("cdObs"        , ped-fiscal.nr-nota-fis).                         */
/* setaValor("cdColaborador", emitente.nome-emit).                             */
/* setaValor("cdMatricula2" , "" /*ped-fiscal.usuario-magnus*/).               */
/* setaValor("cdDia"        , string(DAY(nota-fiscal.dt-emis))).               */
/* setaValor("cdAno"        , string(YEAR(nota-fiscal.dt-emis),"9999")).       */
/* setaValor("cdMes"        , ENTRY(MONTH(NOTA-FISCAL.DT-EMIS), cMes,",")).    */

OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE(cArqDestino).

/* fim */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa wMasterDetail 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-erro = NO.
    
    FIND LAST it-ped-fiscal OF ttPed-fiscal NO-LOCK NO-ERROR.
    IF AVAIL it-ped-fiscal THEN
        ASSIGN i-sequencia = it-ped-fiscal.seq.
    ELSE
        ASSIGN i-sequencia = 0.

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = int(ttPed-fiscal.nat-oper) NO-ERROR.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo..").

    INPUT FROM VALUE(c-arquivo) CONVERT SOURCE "iso8859-1".
    OUTPUT TO "C:\temp\erros_esftp012.log".

    REPEAT TRANSACTION:
        IMPORT UNFORMATTED c-linha.

        RUN pi-acompanhar IN h-acomp (INPUT "Codigo" + STRING(ENTRY(1,c-linha,";"))).

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = ENTRY(1,c-linha,";") NO-LOCK NO-ERROR.

        IF NOT AVAIL ITEM THEN DO:
            PUT "Item nao encontrado. " ENTRY(1,c-linha,";") FORMAT "x(40)" SKIP.
            ASSIGN l-erro = YES.
        END.
        ELSE DO:

            IF item.baixa-estoq = YES THEN DO:


                /* Validacao MFT x WMS  */
                FIND FIRST deposito
                    WHERE deposito.cod-depos    = ENTRY(4,c-linha,";")
                      AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.
                IF AVAIL deposito THEN DO:

                    RUN esp/wmp/eswmpapi003.p (INPUT  ttped-fiscal.cod-estabel,
                                               INPUT  ENTRY(4,c-linha,";"),
                                               INPUT  ENTRY(1,c-linha,";"),
                                               INPUT  "",
                                               OUTPUT p-qtd-total,
                                               OUTPUT p-qtd-disp,
                                               OUTPUT p-qtd-bloq,
                                               OUTPUT TABLE tt-erro).

                    FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                        DELETE tt-erro.
                    END.

                    IF p-qtd-disp < INT(ENTRY(2,c-linha,";")) THEN DO:
                        PUT "Saldo indisponivel! ~~Item " + ENTRY(1,c-linha,";") + " nao possui saldo f°sico disponivel no deposito " + ENTRY(4,c-linha,";") + "." +
                            "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.".
                        ASSIGN l-erro = YES.
                        NEXT.
                    END. /* IF p-qtd-disp < INT(ENTRY(2,c-linha,";")) THEN DO: */
                    ELSE DO:
                        FIND FIRST saldo-estoq NO-LOCK
                             WHERE saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                             AND   saldo-estoq.it-codigo   = ENTRY(1,c-linha,";")
                             AND   saldo-estoq.cod-depos   = ENTRY(4,c-linha,";")
                             AND   saldo-estoq.cod-localiz = "" NO-ERROR.
                        IF AVAIL saldo-estoq THEN DO:
                            IF p-qtd-disp - (saldo-estoq.qt-alocada  + saldo-estoq.qt-aloc-ped) < INT(ENTRY(2,c-linha,";")) THEN DO:
                                PUT "Saldo indisponivel! ~~Item " + ENTRY(1,c-linha,";") + " nao possui saldo f°sico disponivel no deposito " + ENTRY(4,c-linha,";") + "." +
                                    "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.".
                                ASSIGN l-erro = YES.
                                NEXT.
                            END. /* IF p-qtd-disp - (saldo-estoq.qt-alocada  + saldo-estoq.qt-aloc-ped) < it-ped-fiscal.qtde THEN DO: */
                        END. /* IF AVAIL saldo-estoq THEN DO: */
                    END. /* IF p-qtd-disp > it-ped-fiscal.qtde THEN DO: */

                END. /* IF AVAIL deposito THEN DO: */
                /* Fim Valid MFT x WMS  */
            END.

            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
                  
/*             IF  AVAIL in-grup-estoq                                                             */
/*             AND in-grup-estoq.log-ckd THEN DO:                                                  */
/*                                                                                                 */
/*                  RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                      */
/*                                     INPUT 1,        /* Ponto do programa */                     */
/*                                     INPUT 0,                                                    */
/*                                     INPUT "",                                                   */
/*                                     OUTPUT TABLE tt-prog-ponto) NO-ERROR.                       */
/*                                                                                                 */
/*                  IF CAN-FIND (FIRST tt-prog-ponto                                               */
/*                               WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel) THEN DO: */
/*                                                                                                 */
/*                      IF  ttPed-fiscal.nat-oper <> 8                                             */
/*                      AND ttPed-fiscal.nat-oper <> 9                                             */
/*                      AND ttped-fiscal.nat-oper <> 28 THEN DO:                                   */
/*                                                                                                 */
/*                          PUT "Itens CKD s¢ podem ser adicionados atravÇs do bot∆o CKD" SKIP.    */
/*                          ASSIGN l-erro = YES.                                                   */
/*                          NEXT.                                                                  */
/*                      END.                                                                       */
/*                  END.                                                                           */
/*             END.                                                                                */

            IF ITEM.tipo-contr = 4 AND
                 (dec(ENTRY(6,c-linha,";")) = 0 OR  
                  dec(ENTRY(7,c-linha,";")) = 0)
                  /*ENTRY(5,c-linha,";")      = "")*/ THEN DO:
                     PUT "Item Debito Direto Ç obrigatorio informar peso liquido e peso bruto nas colunas 5, 6 e 7. Item: " ENTRY(1,c-linha,";") " Qtd: " ENTRY(2,c-linha,";") SKIP.
                         ASSIGN l-erro = YES.
                    NEXT.
            END.
                
            IF ITEM.tipo-contr = 4 AND
                  ENTRY(8,c-linha,";")      = "" THEN DO:
                     PUT "Item Debito Direto Ç obrigatorio informar Narrativa na coluna 8. Item: " ENTRY(1,c-linha,";") " Qtd: " ENTRY(2,c-linha,";") SKIP.
                         ASSIGN l-erro = YES.
                    NEXT.
            END.
            IF ITEM.tipo-contr = 4 AND
                  ENTRY(9,c-linha,";")      = "" THEN DO:
                     PUT "Item Debito Direto Ç obrigatorio informar Aliquota IPI na coluna 8. Item: " ENTRY(1,c-linha,";") " Qtd: " ENTRY(2,c-linha,";") SKIP.
                         ASSIGN l-erro = YES.
                    NEXT.
            END.
            IF ITEM.tipo-contr = 4 AND
                  DEC(ENTRY(3,c-linha,";"))      = 0 THEN DO:
                     PUT "Item Debito Direto Ç obrigatorio informar Preáo  na coluna 3. Item: " ENTRY(1,c-linha,";") " Qtd: " ENTRY(2,c-linha,";") SKIP.
                         ASSIGN l-erro = YES.
                    NEXT.
            END.

            ASSIGN i-sequencia = i-sequencia + 1.

            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

            IF item.baixa-estoq = YES THEN DO:
                /*Alocaá∆o por lote*/
                IF  ITEM.tipo-con-est = 3 THEN DO:
                    RUN esp/ftp/esftp012f.p (INPUT YES,                       /*p-log-aloca  */
                                             INPUT ttPed-fiscal.nr-pedido,    /*p-nr-pedido  */
                                             INPUT ENTRY(1,c-linha,";"),      /*p-it-codigo  */
                                             INPUT i-sequencia,               /*p-seq        */
                                             INPUT ttPed-fiscal.cod-estabel,  /*p-cod-estabel*/
                                             INPUT "",                        /*p-cod-localiz*/      
                                             INPUT ENTRY(4,c-linha,";"),      /*p-cod-depos  */
                                             INPUT INT(ENTRY(2,c-linha,";")), /*p-qtde-alocar*/
                                             OUTPUT TABLE tt-erro-aloc).      
                    FOR FIRST tt-erro-aloc:
                        PUT tt-erro-aloc.mensagem SKIP.
                        ASSIGN l-erro = YES.
                        NEXT.
                    END.
                END.
                /*Alocaá∆o sem lote*/
                ELSE DO:
                    FIND FIRST saldo-estoq WHERE
                               saldo-estoq.it-codigo   = ENTRY(1,c-linha,";")     AND
                               saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel AND
                               saldo-estoq.cod-depos   = ENTRY(4,c-linha,";")     AND
                               saldo-estoq.cod-localiz = ""                       EXCLUSIVE-LOCK NO-ERROR.
    
                    IF AVAIL saldo-estoq AND
                        saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped >= INT(ENTRY(2,c-linha,";")) THEN DO:
    
                        ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + INT(ENTRY(2,c-linha,";")).

                        release saldo-estoq.
                    END.
                    ELSE DO:
                        PUT "Nao encontrado saldo estoque para alocacao. Item: " ENTRY(1,c-linha,";") " Qtd: " ENTRY(2,c-linha,";") SKIP.
                            ASSIGN l-erro = YES.
                        NEXT.
                    END.
                END.
            END.

            ASSIGN l-imobilizado = NO.
            IF ENTRY(1,c-linha,";") = "imobile" THEN DO:
                ASSIGN l-imobilizado = YES.

                RUN pi-valida-imobilizado.
                IF l-erro = YES THEN NEXT.

            END.

            CREATE it-ped-fiscal.
            ASSIGN it-ped-fiscal.un             = ITEM.un
                   it-ped-fiscal.seq            = i-sequencia
                   it-ped-fiscal.qtde           = INT(ENTRY(2,c-linha,";"))
                   OVERLAY(it-ped-fiscal.char-1,11,8) = ITEM.class-fiscal
                   it-ped-fiscal.peso-liq-item  = ITEM.peso-liquido
                   it-ped-fiscal.peso-bru-item  = ITEM.peso-bruto
                   it-ped-fiscal.nr-pedido      = ttPed-fiscal.nr-pedido
                   it-ped-fiscal.it-codigo      = ENTRY(1,c-linha,";")
                   it-ped-fiscal.cod-depos      = ENTRY(4,c-linha,";")
                   it-ped-fiscal.cod-localiz    = ""
                   substring(it-ped-fiscal.char-1, 79, 35) = IF l-imobilizado THEN ENTRY(10,c-linha,";") + ";" + ENTRY(11,c-linha,";") + ";" + ENTRY(12,c-linha,";") ELSE "".
            IF  item.tipo-contr = 4 THEN DO:
                ASSIGN OVERLAY(it-ped-fiscal.char-1,11,8)   = IF ENTRY(5,c-linha,";") = "" THEN ITEM.class-fiscal ELSE ENTRY(5,c-linha,";")
                               it-ped-fiscal.peso-liq-item  = dec(ENTRY(6,c-linha,";"))
                               it-ped-fiscal.peso-bru-item  = dec(ENTRY(7,c-linha,";"))
                               it-ped-fiscal.narrativa      = ENTRY(8,c-linha,";")
                               it-ped-fiscal.aliquota-ipi   = IF dec(ENTRY(9,c-linha,";")) = 0 THEN ITEM.aliquota-ipi ELSE DEC(ENTRY(9,c-linha,";"))
                               it-ped-fiscal.vl-unit        = DEC(ENTRY(3,c-linha,";")). 
            END.
            ELSE DO:
                ASSIGN OVERLAY(it-ped-fiscal.char-1,11,8) = ITEM.class-fiscal
                       it-ped-fiscal.peso-liq-item        = ITEM.peso-liquido
                       it-ped-fiscal.peso-bru-item        = ITEM.peso-bruto
                       it-ped-fiscal.aliquota-ipi         = ITEM.aliquota-ipi.

                IF  ttPed-fiscal.nat = 25
                OR  ttPed-fiscal.nat = 26 THEN DO:

                        FIND item-estab NO-LOCK 
                             WHERE item-estab.it-codigo   = ITEM.it-codigo 
                               AND item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.
                        IF AVAILABLE item-estab THEN DO:
                            ASSIGN it-ped-fiscal.vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1].                             
                        END.
                        IF NOT AVAILABLE item-estab OR it-ped-fiscal.vl-unit = 0 THEN DO:
                            FIND FIRST item-estab NO-LOCK 
                                 WHERE item-estab.it-codigo    = ITEM.it-codigo 
                                   AND item-estab.cod-estabel <> ttPed-fiscal.cod-estabel
                                    AND (item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]) > 0 NO-ERROR.
                             IF AVAILABLE item-estab THEN DO:
                                 ASSIGN it-ped-fiscal.vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
                             END.
                        END.

                       /* IF (ttped-fiscal.cod-estabel = "101" and
                            ttped-fiscal.cod-emitente = 141000) OR 
                           (ttped-fiscal.cod-estabel = "104" and
                            ttped-fiscal.cod-emitente = 103748) THEN . 
                        ELSE
                            IF  ttped-fiscal.cod-emitente = 143524 THEN
                                ASSIGN It-ped-fiscal.vl-unit = It-ped-fiscal.vl-unit / 0.93.  
                            ELSE
                                ASSIGN It-ped-fiscal.vl-unit = It-ped-fiscal.vl-unit / 0.88.  */
                    
                END.
                ELSE DO:
                    ASSIGN it-ped-fiscal.vl-unit        = DEC(ENTRY(3,c-linha,";")).
                    IF it-ped-fiscal.vl-unit = 0 AND
                       ITEM.tipo-contr = 2       AND
                       ITEM.it-codigo BEGINS "4" THEN DO:
                            FOR EACH preco-item NO-LOCK
                                WHERE preco-item.it-codigo = ITEM.it-codigo
                                  AND preco-item.nr-tabpre = "minimo"
                                  AND preco-item.situacao = 1
                                  AND preco-item.dt-inival < TODAY,
                                FIRST tb-preco NO-LOCK
                                WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre
                                  AND tb-preco.situacao = 1
                                  AND tb-preco.dt-inival <= TODAY
                                  AND tb-preco.dt-fimval >= TODAY
                                BREAK BY preco-item.preco-venda:
                                ASSIGN It-ped-fiscal.vl-unit = preco-item.preco-venda.

                                LEAVE.
                            END.
                        
                    END.
                END.
            END.
                   
                
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    INPUT CLOSE.
    OUTPUT CLOSE.


   IF l-erro THEN DO:
        RUN utp/ut-utils.p PERSISTENT SET h-open.
        RUN Execute IN h-open(INPUT "C:\temp\erros_esftp012.log",
                              INPUT "").
        DELETE PROCEDURE h-open.
    END.
    ELSE DO:
/*         IF SEARCH("C:\temp\erros_esftp012.log") <> ? THEN */
/*         OS-DELETE "C:\temp\erros_esftp012.log".           */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-imobilizado wMasterDetail 
PROCEDURE pi-valida-imobilizado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN l-erro = NO.

FIND FIRST bem_pat NO-LOCK
     WHERE bem_pat.cod_cta_pat     = string(ENTRY(10,c-linha,";"))
       AND bem_pat.num_bem_pat     = INT(ENTRY(11,c-linha,";"))
       AND bem_pat.num_seq_bem_pat = INT(ENTRY(12,c-linha,";")) NO-ERROR.  

IF  NOT AVAIL bem_pat THEN DO:

    IF  ENTRY(1,c-linha,";") = "imobile" 
    OR  ENTRY(1,c-linha,";") = "9930050" 
    OR  ENTRY(1,c-linha,";") = "9890001" THEN DO:
        PUT  "Conta e Bem Patrimonial devem ser informados para o item " +  ENTRY(1,c-linha,";") FORMAT "x(80)" SKIP.
        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF  trim(ENTRY(10,c-linha,";")) <> "" OR  int(ENTRY(11,c-linha,";")) > 0 OR  int(ENTRY(12,c-linha,";")) > 0 THEN DO:

            PUT  "Bem Patrimonial inexistente " +  ENTRY(1,c-linha,";") FORMAT "x(50)" SKIP.
            ASSIGN l-erro = YES.
        END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaCusto wMasterDetail 
PROCEDURE piCalculaCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-it-codigo   LIKE ITEM.it-codigo.
    DEFINE INPUT PARAM p-cod-estabel LIKE estabelec.cod-estabel.
    DEFINE OUTPUT PARAM p-tot-mat AS DECIMAL.
    DEFINE OUTPUT PARAM p-tot-mob AS DECIMAL.
    DEFINE OUTPUT PARAM p-tot-ggf AS DECIMAL.

    DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = p-cod-estabel NO-ERROR.
    
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    EMPTY TEMP-TABLE tt-custos-param.
    EMPTY TEMP-TABLE tt-custos-item.
    
    CREATE tt-custos-param.
    ASSIGN tt-custos-param.cod-versao-integracao = 1
           tt-custos-param.l-acomp               = yes
           tt-custos-param.tp-preco              = 1
           tt-custos-param.moeda                 = 0
           tt-custos-param.corrige               = no
           tt-custos-param.cod-estabel           = estabelec.cod-estabel
           tt-custos-param.tempo-prepar          = 1
           tt-custos-param.custo-oper            = 1
           tt-custos-param.rkw-up                = 1
           tt-custos-param.nr-niveis             = 19
           tt-custos-param.cod-obsoleto          = 1
           tt-custos-param.cons-estab-fil        = no
           tt-custos-param.c-origem              = "EN".
    
    CREATE tt-custos-item.
    ASSIGN tt-custos-item.it-codigo          = ITEM.it-codigo
           tt-custos-item.quantidade         = 1
           tt-custos-item.cod-refer          = ITEM.cod-refer
           tt-custos-item.dt-corte-estrut    = TODAY
           tt-custos-item.dt-corte-op        = TODAY
           tt-custos-item.fm-codigo          = ITEM.fm-codigo
           tt-custos-item.ge-codigo          = ITEM.ge-codigo
           tt-custos-item.c-origem           = "EN".
    
    run csp/csapi001.p (INPUT  TABLE tt-custos-param,
                        INPUT  TABLE tt-custos-item,
                        OUTPUT TABLE tt-custos-calculo,
                        OUTPUT TABLE tt-custos-mob-dir,
                        OUTPUT TABLE tt-custos-ggf,
                        OUTPUT TABLE tt-custos-op,
                        OUTPUT TABLE tt-erro). 
    
     FIND LAST tt-custos-calculo EXCLUSIVE-LOCK
         WHERE tt-custos-calculo.it-codigo = tt-custos-item.it-codigo NO-ERROR.
    
    ASSIGN p-tot-mat = tt-custos-calculo.vl-unit-mat * tt-custos-calculo.quantidade
           p-tot-mob = tt-custos-calculo.vl-unit-mob * tt-custos-calculo.quantidade.
    
    ASSIGN p-tot-ggf = 0.
    
    DO i-cont = 1 TO 6:
        ASSIGN p-tot-ggf = p-tot-ggf + tt-custos-calculo.vl-unit-ggf[i-cont].
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piComodato wMasterDetail 
PROCEDURE piComodato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FIND FIRST mgesp.ped-fiscal 
      WHERE mgesp.ped-fiscal.nr-pedido = INPUT FRAME fPage0 ttPed-fiscal.nr-pedido NO-LOCK NO-ERROR.
 IF AVAIL mgesp.ped-fiscal THEN DO:
 
     IF mgesp.ped-fiscal.nr-nota-fis <> "" THEN DO:

         FIND FIRST ponto-programa NO-LOCK
              WHERE ponto-programa.nome-programa = "esftp012"
                AND ponto-programa.ponto         = 6 NO-ERROR.
         IF AVAIL ponto-programa THEN DO:
             FIND FIRST conteudo-programa  NO-LOCK
                  WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                    AND conteudo-programa.conteudo     = c-seg-usuario NO-ERROR .
             IF AVAIL conteudo-programa THEN 
                 ASSIGN btComodato:SENSITIVE IN FRAME fPage1 = YES.
             ELSE
                 ASSIGN btComodato:SENSITIVE IN FRAME fPage1 = NO.
         END.
     END.
     ELSE
         ASSIGN btComodato:SENSITIVE IN FRAME fPage1 = NO.
     
 END.

 
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wMasterDetail 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.
    
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.
    
    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.


    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-mail:

        FOR EACH tt-envio2.   DELETE tt-envio2.   END.
        FOR EACH tt-mensagem. DELETE tt-mensagem. END.

        ASSIGN c-lst-arq  = tt-mail.arquivo. 
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
               tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
               tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
               tt-envio2.arq-anexo         = c-lst-arq               /* Arquivo Tempor†rio */
               tt-envio2.formato           = "TEXTO".
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */

        /**** coloquei em comentario pois n∆o mostra o programa que foi chamado,
        somente mostra o nome das viewers, trigger, etc   ****/
/*        REPEAT WHILE PROGRAM-NAME(level) <> ?.
               CREATE tt-mensagem.
               ASSIGN tt-mensagem.seq-mensagem = level + 2
                      tt-mensagem.mensagem     = "Nivel: " + string(LEVEL) +
                                                 "  Programa: " + PROGRAM-NAME(level) + CHR(13)
                      level = level + 1.
        END.
  */
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN
           OUTPUT TO erros-comerc.LOG APPEND.
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END.

    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmailTranspIncorreta wMasterDetail 
PROCEDURE piEnviaEmailTranspIncorreta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-mail-transp AS CHAR NO-UNDO.
    
    DEF VAR c-cod-transp-padrao   AS INTEGER NO-UNDO.
    DEF VAR c-sigla-transp-padrao AS CHAR NO-UNDO.

    /* Busca Transportadora */ 
    RUN esp/crm/escrm107.p(INPUT ttPed-fiscal.cod-estabel,
                           INPUT string(emitente.cod-emitente),
                           INPUT emitente.cidade,
                           INPUT emitente.estado,
                           INPUT 0,
                           INPUT emitente.cep,
                           OUTPUT c-cod-transp-padrao,
                           OUTPUT c-sigla-transp-padrao).

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "esftp012"
          AND ponto-programa.ponto         = 4:
    
       FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
            IF  c-mail-transp = "" THEN
                c-mail-transp = conteudo-programa.conteudo .
            ELSE
                c-mail-transp = c-mail-transp + "," + conteudo-programa.conteudo .
    
        END.
    
    END.

    IF  c-mail-transp = "" THEN
        RETURN "NOK".
    
    DEF VAR c-nome-transp-padrao AS CHAR NO-UNDO.
    DEF VAR c-nome-transp-nova   AS CHAR NO-UNDO.
    FOR FIRST transporte 
        WHERE transporte.cod-transp = INTEGER(c-cod-transp-padrao) NO-LOCK:
        ASSIGN c-nome-transp-padrao = transporte.nome-abrev.
    END.
    FOR FIRST transporte 
        WHERE transporte.cod-transp = INTEGER(ttped-fiscal.cod-transp) NO-LOCK:
        ASSIGN c-nome-transp-nova = transporte.nome-abrev.
    END.

    IF  c-nome-transp-padrao = c-nome-transp-nova THEN 
        RETURN "OK".

    FIND FIRST usuar_mestre WHERE
         usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

    RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                      INPUT c-mail-transp,
                      INPUT "Transportadora Incorreta. Pedido: " + STRING(ttped-fiscal.nr-pedido),
                      INPUT "Usu†rio " + c-seg-usuario + " (" + usuar_mestre.nom_usuario + ") selecionou transportadora diferente de padr∆o cadastrado, pedido: " + STRING(ttped-fiscal.nr-pedido) + CHR(13) +
                            "Transportadora anterior: " + c-nome-transp-padrao + CHR(13) +
                            "Nova transportadora selecionada: " + c-nome-transp-nova, 
                     INPUT "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaWMS wMasterDetail 
PROCEDURE piValidaWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            /* Validacao MFT x WMS  */
            FIND FIRST deposito 
                WHERE deposito.cod-depos    = it-ped-fiscal.cod-depos
                  AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.
            IF AVAIL deposito THEN DO:

                RUN esp/wmp/eswmpapi003.p (INPUT  ttped-fiscal.cod-estabel,
                                           INPUT  it-ped-fiscal.cod-depos,
                                           INPUT  it-ped-fiscal.it-codigo,
                                           INPUT  "",
                                           OUTPUT p-qtd-total,
                                           OUTPUT p-qtd-disp,
                                           OUTPUT p-qtd-bloq,
                                           OUTPUT TABLE tt-erro).

                FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                    DELETE tt-erro.
                END. 

                IF p-qtd-disp < it-ped-fiscal.qtde THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Saldo indisponivel! ~~Item " + it-ped-fiscal.it-codigo + " nao possui saldo f°sico disponivel no deposito " + it-ped-fiscal.cod-depos + "." +
                                             "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.").
                    ASSIGN it-ped-fiscal.qtde = 0.
                    ASSIGN l-okwms = no.
                END. /* IF p-qtd-disp < it-ped-fiscal.qtde THEN DO: */
                ELSE DO:
                    FIND FIRST saldo-estoq NO-LOCK 
                         WHERE saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                         AND   saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                         AND   saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos  
                         AND   saldo-estoq.cod-localiz = '' NO-ERROR.
                    IF AVAIL saldo-estoq THEN DO:
                        IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped) - p-qtd-bloq < it-ped-fiscal.qtde THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17006, 
                                               INPUT "Saldo indisponivel! ~~Item " + it-ped-fiscal.it-codigo + " nao possui saldo f°sico disponivel no deposito " + it-ped-fiscal.cod-depos + "." +
                                                     "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.").
                            ASSIGN it-ped-fiscal.qtde = 0.
                            ASSIGN l-okwms = no.
                        END. /* IF p-qtd-disp - (saldo-estoq.qt-alocada  + saldo-estoq.qt-aloc-ped) < it-ped-fiscal.qtde THEN DO: */
                    END. /* IF AVAIL saldo-estoq THEN DO: */
                END. /* IF p-qtd-disp > it-ped-fiscal.qtde THEN DO: */

            END. /* IF AVAIL deposito THEN DO: */
            /* Fim Valid MFT x WMS  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWord wMasterDetail 
PROCEDURE piWord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Inicio Pre-Processadores do Word *************************************************************/
&global-define wdWindowStateMaximize    1 /* 1 - Maximinizada */
&global-define wdWindowStateMinimize    2 /* 2 - Minimizada */
&global-define wdWindowStateNormal      0 /* 3 - Normal */

&global-define wdCursorIBeam            1 /* 1 - Selecao de Texto */
&global-define wdCursorNormal           2 /* 2 - Padrao */
&global-define wdCursorNorthwestArrow   3 /* 3 - Ponteiro */
&global-define wdCursorWait             0 /* 4 - Espera */
&global-define wdNoProtection           -1 /* 4 - Nenhum */

/* Final Pre-Processadores do Word *************************************************************/

/* Nome do arquivo que servira de modelo para o novo documento a ser gerado */
DEFINE VARIABLE cArqModelo  AS CHARACTER NO-UNDO.

/* Nome do novo documento que sera gerado */
DEFINE VARIABLE cArqDestino AS CHARACTER NO-UNDO.

/* Nome da senha do modelo, caso seja necessario */
DEFINE VARIABLE cSenha      AS CHARACTER NO-UNDO.

/* Mostra ou nao o preenchimento do novo documento */
DEFINE VARIABLE lShow       AS LOGICAL    NO-UNDO.

/* Imprime o documento no final */
DEFINE VARIABLE lPrint AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMes   AS CHAR INIT "JANEIRO, FEVEREIRO, MARÄO, ABRIL, MAIO, JUNHO, JULHO, AGOSTO, SETEMBRO, OUTUBRO, NOVEMBRO, DEZEMBRO" NO-UNDO.

FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = ped-fiscal.cod-estabel
       AND nota-fiscal.serie       = ped-fiscal.serie
       AND nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis NO-ERROR.

FIND FIRST it-ped-fiscal OF ped-fiscal NO-ERROR.
FIND FIRST ITEM NO-LOCK
     WHERE ITEM.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.

/* define o valor inicial para as variaveis */
ASSIGN cArqModelo  = search("layout\comodato.docx") /*"c:\temp\comodato.docx"*/
       cArqDestino = SESSION:TEMP-DIRECTORY + string(ped-fiscal.nr-pedido) + ".docx"
       lShow       = FALSE
       lPrint      = FALSE.

/* Comunica com o word */
CREATE "Word.Application" chWord.

/* mostra ou nao o preenchimento do novo documento */
chWord:ScreenUpdating = lShow.
chWord:WindowState = (IF lShow THEN {&wdWindowStateMaximize} ELSE {&wdWindowStateMinimize}).
chWord:Visible = lShow.

/* troca o cursor do word */
chWord:System:Cursor = {&wdCursorWait}.

/* abre o modelo que sera utilizado no novo documento a ser criado */
chDocument = chWord:Documents:Add(cArqModelo).

/* verifica se o documento esta protegido e utiliza uma senha para desprotege-lo caso necessario */
IF  chDocument:ProtectionType <> {&wdNoProtection} THEN 
    chDocument:UnProtect(cSenha).

/* preenche os campos do formulario modelo */
setaValor("cdEmitente"   , emitente.nome-emit).
setaValor("cdMatricula"  , "" /*ped-fiscal.usuario-magnus*/).
setaValor("cdCPF"        , emitente.cgc).
setaValor("cdDescricao"  , it-ped-fiscal.narrativa) /*ITEM.desc-item)*/.
setaValor("cdSerie"      , entry(2,ped-fiscal.observacao[4],":")).
setaValor("cdValor"      , string(nota-fiscal.vl-tot-nota, ">>>>,>>9.99")).
setaValor("cdObs"        , ped-fiscal.nr-nota-fis).
setaValor("cdColaborador", emitente.nome-emit).
setaValor("cdMatricula2" , "" /*ped-fiscal.usuario-magnus*/).
setaValor("cdDia"        , string(DAY(nota-fiscal.dt-emis))).
setaValor("cdAno"        , string(YEAR(nota-fiscal.dt-emis),"9999")).
setaValor("cdMes"        , ENTRY(MONTH(NOTA-FISCAL.DT-EMIS), cMes,",")).

/* salva o documento novo com base no ModeloExemplo */
chDocument:SaveAs(cArqDestino).

/* volta o cursor ao normal */
chWord:System:Cursor = {&wdCursorNormal}.

/* fecha o Word */
chDocument:Close().
chWord:Quit().

/* Retira os objetos do Word da memoria */
RELEASE OBJECT chDocument.
RELEASE OBJECT chWord.

/* Abri o documento recem criado com base na extensao .docx (extensao ".docx" associado ao Word) */
OS-COMMAND NO-WAIT VALUE(cArqDestino).

/* fim */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc-item wMasterDetail 
FUNCTION fnDesc-item RETURNS CHARACTER
  ( pIt-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna descriá∆o do item trazido da BO
    Notes:  Foi substitu°do pela leitura direta Ö tabela no Browse
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cDesc-item  AS CHARACTER    NO-UNDO INITIAL ''.
/*
    RUN goToKey IN hDBOItem (pIt-codigo).
    IF RETURN-VALUE <> 'NOK' THEN
        RUN getCharField IN hDBOItem ('desc-item', OUTPUT cDesc-item).
*/
    RETURN cDesc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setaValor wMasterDetail 
FUNCTION setaValor RETURNS LOGICAL
  ( INPUT cCampo AS CHARACTER, 
    INPUT cValor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  chDocument:FormFields:Item(cCampo):Result = cValor.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

