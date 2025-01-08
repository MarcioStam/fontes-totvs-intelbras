&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-fiscal NO-UNDO LIKE ped-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttWt-docto NO-UNDO LIKE wt-docto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttWt-it-docto NO-UNDO LIKE wt-it-docto
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp009 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp009
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2  c-nr-solicitacao c-nat-oper dt-emissao i-fin-nfe 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE  NO-UNDO.
DEFINE VARIABLE wh-pesquisa         AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi317           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317in         AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317pr         AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317sd         AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317im1br      AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra     AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317va         AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boin404te         as handle       no-undo.
DEFINE VARIABLE h-bodi321           AS HANDLE       NO-UNDO.

DEFINE VARIABLE h-bodi515           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h_boin368           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h_boin176           AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-fifo              AS LOG INIT NO  NO-UNDO.
DEFINE VARIABLE c-modelo            AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cSerie      LIKE serie.serie                NO-UNDO VIEW-AS FILL-IN SIZE 08 BY 0.88.
DEFINE VARIABLE cNatOper    LIKE natur-oper.nat-operacao    NO-UNDO VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE c-char-aux  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto AS INTEGER     NO-UNDO.

DEFINE VARIABLE cDescSituacao   AS CHARACTER    NO-UNDO COLUMN-LABEL 'Situaá∆o' FORMAT 'x(14)'.

DEFINE NEW GLOBAL SHARED VARIABLE gr-wt-docto   AS ROWID        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hFT4003       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-finalidade-esftp009 AS CHAR NO-UNDO.


DEFINE VARIABLE de-qtde        AS DECIMAL.
DEFINE VARIABLE de-qtde-se     AS DECIMAL.
DEFINE VARIABLE de-qtde-br     AS DECIMAL.
DEFINE VARIABLE de-qt-nf       AS DECIMAL.
DEFINE VARIABLE da-data        AS DATE.
DEFINE VARIABLE c-descricao    AS CHAR.
DEFINE VARIABLE l-proc-ok-aux  AS LOGICAL         NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec AS CHARACTER NO-UNDO.
DEF BUFFER bitem-uni-estab FOR item-uni-estab.
def var l-aloca-estoque as logical initial no.

DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

{cdp/cdcfgdis.i}
{upc\btb910za-upc.i}

    DEFINE TEMP-TABLE tt-nota-fisc-adc NO-UNDO LIKE nota-fisc-adc
        FIELD r-Rowid AS ROWID.

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

    def temp-table tt-itens-devol-aux like tt-itens-devol.

    /*
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
    
     */
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
        &IF "{&bf_dis_versao_ems}" >= "2.062":U &THEN
            field qt-faturada       like it-nota-fisc.qt-faturada[2]
            field un-faturada       like it-nota-fisc.un-fatur[2]
            field un-estoque        like it-nota-fisc.un-fatur[1]
        &ENDIF
        index codigo 
              sequencia
        index selecionado
              selecionado.



DEFINE TEMP-TABLE tt-saldo
    FIELD it-codigo LIKE mgesp.it-ped-fiscal.it-codigo
    FIELD descricao AS CHAR FORMAT "X(36)" LABEL "Descriá∆o"
    FIELD cod-depos LIKE mgesp.it-ped-fiscal.cod-depos
    FIELD cod-localizacao LIKE mgesp.it-ped-fiscal.cod-localiz
    FIELD qtde LIKE mgesp.it-ped-fiscal.qtde
    FIELD qtde-se AS DECIMAL LABEL "Sdo Dep"
    FIELD qtde-br AS DECIMAL LABEL "Sdo Branco"
    FIELD qtde-nf AS DECIMAL LABEL "Nota"
    INDEX idx-saldo IS PRIMARY it-codigo cod-depos.

DEFINE NEW GLOBAL SHARED VARIABLE I-NumPedidoEsftp060    AS INTEGER   NO-UNDO.

{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-nr-solicitacao RECT-1 RECT-14 c-cliente ~
rtToolBar c-nat-operacao-solicitacao c-cod-canal-venda c-estado ~
c-estabelecimento c-nat-oper dt-emissao i-fin-nfe btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-nr-solicitacao c-cliente c-nome-cliente ~
c-nat-operacao-solicitacao c-cod-canal-venda c-estado c-estabelecimento ~
c-nat-oper fi-serie c-nome-natureza dt-emissao i-fin-nfe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescSituacao wWindow 
FUNCTION fnDescSituacao RETURNS CHARACTER
  ( piSituacao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE i-fin-nfe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Finalidade NFe" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Nf-e Normal","1",
                     "Nf-e Complementar","2",
                     "Nf-e de Ajuste","3",
                     "Devoluá∆o Mercadoria","4"
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE c-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .79 NO-UNDO.

DEFINE VARIABLE c-cod-canal-venda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal Venda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabelecimento AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado Cliente" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza de Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE c-nat-operacao-solicitacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nat.Operaá∆o Solicitaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .79 NO-UNDO.

DEFINE VARIABLE c-nome-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .79 NO-UNDO.

DEFINE VARIABLE c-nome-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .79 NO-UNDO.

DEFINE VARIABLE c-nr-solicitacao AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Solicitaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE dt-emissao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .79.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.38.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.96.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 86 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-nr-solicitacao AT ROW 1.75 COL 20 COLON-ALIGNED WIDGET-ID 14
     c-cliente AT ROW 2.75 COL 20 COLON-ALIGNED WIDGET-ID 4
     c-nome-cliente AT ROW 2.75 COL 40.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-nat-operacao-solicitacao AT ROW 3.75 COL 20 COLON-ALIGNED WIDGET-ID 16
     c-cod-canal-venda AT ROW 4.75 COL 20 COLON-ALIGNED WIDGET-ID 12
     c-estado AT ROW 4.75 COL 48 COLON-ALIGNED WIDGET-ID 18
     c-estabelecimento AT ROW 4.75 COL 69 COLON-ALIGNED WIDGET-ID 20
     c-nat-oper AT ROW 6.38 COL 19.72 COLON-ALIGNED WIDGET-ID 8
     fi-serie AT ROW 7.29 COL 19.72 COLON-ALIGNED WIDGET-ID 28
     c-nome-natureza AT ROW 6.38 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     dt-emissao AT ROW 8.21 COL 19.72 COLON-ALIGNED WIDGET-ID 22
     i-fin-nfe AT ROW 9.13 COL 19.72 COLON-ALIGNED WIDGET-ID 26
     btOK AT ROW 10.79 COL 2
     btCancel AT ROW 10.79 COL 13
     btHelp2 AT ROW 10.79 COL 76
     RECT-1 AT ROW 6.13 COL 1
     RECT-14 AT ROW 1.04 COL 1.29
     rtToolBar AT ROW 10.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.57 BY 11.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-ped-fiscal T "?" NO-UNDO mgesp ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttWt-docto T "?" NO-UNDO mgcad wt-docto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttWt-it-docto T "?" NO-UNDO mgcad wt-it-docto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Geraá∆o do C†lculo da Nota Fiscal com base em Pedido"
         HEIGHT             = 11.17
         WIDTH              = 86.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-nome-cliente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-natureza IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-serie IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Geraá∆o do C†lculo da Nota Fiscal com base em Pedido */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Geraá∆o do C†lculo da Nota Fiscal com base em Pedido */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    DEF VAR l-ok AS LOG NO-UNDO.
    DEF VAR l-eh-devolucao AS LOG INIT NO NO-UNDO.

    ASSIGN I-NumPedidoEsftp060 = 0.

    FIND FIRST ped-fiscal NO-LOCK
        WHERE  ped-fiscal.nr-pedido = INT(c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
    IF  NOT AVAIL ped-fiscal THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Pedido n∆o Encontrado.').
        APPLY 'entry':U TO c-nr-solicitacao IN FRAME fpage0.
        RETURN 'NOK'.
    END.
    ELSE DO: /* avail */
        IF  LOCKED ped-fiscal THEN DO:
            RUN utp/ut-msgs.p ('show', 17006, 'Registro Alocado por Outro usu†rio.').
            RETURN 'NOK'.
        END.

        IF  ped-fiscal.situacao <> 2 THEN DO:
            RUN utp/ut-msgs.p ('show', 17006, 'Pedido n∆o est† com situaá∆o a Relacionar.').
            RETURN 'NOK'.
        END.
    
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            RUN utp/ut-msgs.p ('show', 17006, 'Cliente informado n∆o encontrado no cadastro.' + '~~' + 'Verifique NO CRM.').
            RETURN 'NOK'.
        END.

        IF ped-fiscal.nr-nota-fis <> "" THEN DO: /*Chamado 144193*/
            RUN utp/ut-msgs.p (INPUT 'show', 
                               INPUT 17006, 
                               INPUT 'Pedido j† possui a nota fiscal ' + ped-fiscal.nr-nota-fis + ' emitida para este pedido').
            RETURN 'NOK'.
        END.

    END.
    
    FIND FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.
    IF  NOT AVAIL natur-oper THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o existe no cadastro(cd0606).').
        APPLY 'entry':U TO c-nat-oper IN FRAME fpage0.
        RETURN 'NOK'.
    END.

    FIND FIRST natur-oper-ped-fiscal NO-LOCK
         WHERE natur-oper-ped-fiscal.natureza = ped-fiscal.nat-oper
           AND natur-oper-ped-fiscal.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.

    IF NOT AVAIL natur-oper-ped-fiscal THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o est† relacionada Ö natureza do pedido.').
        APPLY 'entry':U TO c-nat-oper IN FRAME fpage0.
        RETURN 'NOK'.
    END.
    /*----------------------------------- VALIDAÄ«O PARA DEVOLUÄÂES -------------------------------------*/
    RUN esp/es0018p.p (INPUT "esftp009", /* Nome do programa */
                       INPUT 1,              /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    IF  natur-oper.especie-doc = "NFD" 
    AND i-fin-nfe:SCREEN-VALUE IN FRAME fpage0 <> "4" /*Devoluá∆o*/ THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o diverge da finalidade da nota.').
        APPLY 'entry':U TO c-nat-oper IN FRAME fpage0.
        RETURN 'NOK'.
    END.

    IF  natur-oper.especie-doc <> "NFD" THEN DO:
        FOR EACH  tt-prog-ponto:
            IF  tt-prog-ponto.conteudo = natur-oper.nat-operacao THEN 
                ASSIGN l-eh-devolucao = YES. /* ê USADA COMO DEVOLUÄ«O*/
        END.
    
        IF  l-eh-devolucao AND i-fin-nfe:SCREEN-VALUE IN FRAME fpage0 <> "4" /*Devoluá∆o*/ THEN DO:
            RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o diverge da finalidade da nota.').
            APPLY 'entry':U TO c-nat-oper IN FRAME fpage0.
            RETURN 'NOK'.
        END.
    END.
    /*---------------------------------------- FIM DEVOLUÄÂES ------------------------------------------*/

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = ped-fiscal.cod-estabel NO-LOCK NO-ERROR.
    IF  AVAIL  estabelec THEN DO:
        IF  c-estado:SCREEN-VALUE IN FRAME fpage0 = "EX" THEN DO:
            IF  NOT natur-oper.nat-operacao BEGINS "7" THEN DO:
                RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o deve ser adequada para cliente estrangeiro.').
                RETURN 'NOK'.
            END.
        END.
        ELSE DO:
            IF  estabelec.estado = c-estado:SCREEN-VALUE IN FRAME fpage0 THEN DO:
                IF  NOT natur-oper.nat-operacao BEGINS "5" THEN DO:
                    RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o deve ser adequada para cliente dentro do estado.').
                    RETURN 'NOK'.
                END.
            END.
            ELSE DO:
                IF  NOT natur-oper.nat-operacao BEGINS "6" THEN DO:
                    RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o inadequada para cliente fora do estado.').
                    RETURN 'NOK'.
                END.
            END.
        END.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Estabelecimento n∆o encontrado.').
        RETURN 'NOK'.    
    END.
    
   
    IF fi-serie:SENSITIVE IN FRAME fpage0 = YES AND fi-serie:SCREEN-VALUE IN FRAME fpage0 <> '' THEN DO:
       FIND FIRST ser-estab 
            WHERE ser-estab.serie       = fi-serie:SCREEN-VALUE IN FRAME fpage0
              AND ser-estab.cod-estabel = ped-fiscal.cod-estabel 
       NO-LOCK NO-ERROR.
    
       IF NOT AVAIL ser-estab THEN DO:
          RUN utp/ut-msgs.p ('show', 17006, 'Serie/Estab n∆o encontrada.').
          RETURN 'NOK'.                                  
       END.         
    END.



    ASSIGN l-erro                = FALSE.
    
    CASE i-fin-nfe:SCREEN-VALUE IN FRAME fpage0:
        WHEN "1" THEN g-finalidade-esftp009 = "Nf-e Normal".
        WHEN "2" THEN g-finalidade-esftp009 = "Nf-e Complementar".
        WHEN "3" THEN g-finalidade-esftp009 = "Nf-e de Ajuste".
        WHEN "4" THEN g-finalidade-esftp009 = "Devoluá∆o Mercadoria".
        OTHERWISE  g-finalidade-esftp009 = "".
    END CASE.

    
    run dibo/bodi317in.p persistent set h-bodi317in.
    run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                     output h-bodi317sd,     
                                     output h-bodi317im1bra,
                                     output h-bodi317va).

    run leaveCodEstabel in h-bodi317sd (input  ped-fiscal.cod-estabel, input no, output c-char-aux).

    IF fi-serie:SCREEN-VALUE IN FRAME fpage0 <> '' THEN 
       ASSIGN c-char-aux = fi-serie:SCREEN-VALUE IN FRAME fpage0.

    /*
    FIND FIRST ser-estab NO-LOCK
        WHERE  ser-estab.serie       = c-char-aux  
        AND    ser-estab.cod-estabel = ped-fiscal.cod-estabel NO-ERROR.*/
    

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.

    /* VERIFICA CLIENTE SUSPENSO */
    IF  AVAIL emitente AND emitente.ind-cre-cli = 4 THEN DO:

        FIND FIRST int-emitente WHERE int-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

        FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL int-emitente THEN
            ASSIGN int-emitente.cod-gr-cob = 16
                   emitente.ind-cre-cli    = 5.
        FIND CURRENT emitente NO-LOCK NO-ERROR.
    END.

    run criaWtDocto in h-bodi317sd (input  c-seg-usuario,
                                    input  ped-fiscal.cod-estabel,
                                    input  c-char-aux,   /*Serie*/ 
                                    input  "1",
                                    input  emitente.nome-abrev,
                                    input  ?,
                                    input  4,
                                    input  4003,
                                    input  dt-emissao:SCREEN-VALUE IN FRAME fpage0,
                                    input  0,
                                    input  input frame fPage0 c-nat-oper,
                                    input  ped-fiscal.canal-vendas,
                                    output i-seq-wt-docto,
                                    output l-proc-ok-aux).

    run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec, output table RowErrors).
    
    find first RowErrors no-lock no-error.
    if  avail RowErrors then do:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}
    end.

    IF VALID-HANDLE(h-bodi317in) THEN 
        RUN finalizaBOs IN h-bodi317in.

    IF  not l-proc-ok-aux THEN return no-apply.

    RUN piCriaWt-itens (OUTPUT l-ok).

    IF  RETURN-VALUE = "NOK" 
    OR  NOT l-ok THEN 
        RETURN NO-APPLY.

    IF CAN-FIND(FIRST it-ped-fiscal OF ped-fiscal
                WHERE it-ped-fiscal.cod-depos <> "EPE") THEN DO: //deposito diferente de epe com local de retirada, excluir a nota-fisc-adc

        FOR EACH nota-fisc-adc EXCLUSIVE-LOCK
           WHERE nota-fisc-adc.cod-estab     = ped-fiscal.cod-estabel
             AND nota-fisc-adc.cod-serie     = c-char-aux
             AND nota-fisc-adc.cod-nota-fisc = string(i-seq-wt-docto) //"25272200"
             AND nota-fisc-adc.idi-tip-dado  = 32:

            DELETE nota-fisc-adc.
        
        END.
    END.

    IF  VALID-HANDLE(hFT4003) THEN DO:
        RUN goToRecord2 IN hFT4003 (INPUT i-seq-wt-docto).
        RUN destroyInterface.
        run applyChooseBtUpdate IN hFT4003.
    END.
    
    IF NOT l-erro THEN APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cliente wWindow
ON LEAVE OF c-cliente IN FRAME fpage0 /* Cliente */
DO:
  FIND emitente
      WHERE emitente.cod-emitente = INT(c-cliente:SCREEN-VALUE IN FRAME fpage0)
      NO-LOCK NO-ERROR.
  IF NOT AVAIL emitente THEN DO:
      FIND emitente
          WHERE emitente.nome-abrev = c-cliente:SCREEN-VALUE IN FRAME fpage0
          NO-LOCK NO-ERROR.
      IF NOT AVAIL emitente THEN DO:
          FIND emitente
              WHERE emitente.cgc = c-cliente:SCREEN-VALUE IN FRAME fpage0
              NO-LOCK NO-ERROR.
          IF NOT AVAIL emitente THEN DO:
             RUN utp/ut-msgs.p ('show', 17006, 'Cliente informado n∆o encontrado NO cadastro, verifique NO CRM').
             RETURN 'NOK'.
          END.
      END.
  END.
  ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit
      c-cliente:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-abrev.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estabelecimento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabelecimento wWindow
ON LEAVE OF c-estabelecimento IN FRAME fpage0 /* Estabelecimento */
DO:
    FIND natur-oper
        WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0
        NO-LOCK NO-ERROR.
      IF NOT AVAIL natur-oper THEN DO:
         RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o existe NO cadastro cd0606').
         RETURN 'NOK'.
      END.
      ASSIGN c-nome-natureza:SCREEN-VALUE IN FRAME fpage0 = natur-oper.denominacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estado wWindow
ON LEAVE OF c-estado IN FRAME fpage0 /* Estado Cliente */
DO:
    FIND natur-oper
        WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0
        NO-LOCK NO-ERROR.
      IF NOT AVAIL natur-oper THEN DO:
         RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o existe NO cadastro cd0606').
         RETURN 'NOK'.
      END.
      ASSIGN c-nome-natureza:SCREEN-VALUE IN FRAME fpage0 = natur-oper.denominacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON F5 OF c-nat-oper IN FRAME fpage0 /* Natureza de Operaá∆o */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                       &campo=c-nat-oper
                       &campozoom=nat-operacao
                       &FRAME="fPage0"
                       &campo2=c-nome-natureza
                       &campozoom2=denominacao
                       &FRAME="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON LEAVE OF c-nat-oper IN FRAME fpage0 /* Natureza de Operaá∆o */
DO:
    IF  c-nat-oper:SCREEN-VALUE IN FRAME fpage0 NE "" THEN DO:
            
        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.
        IF  NOT AVAIL natur-oper THEN DO:
            RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o existe no cadastro CD0606').
            ASSIGN c-nome-natureza:SCREEN-VALUE IN FRAME fpage0 = "".
            RETURN 'NOK':U.
        END.
        ELSE ASSIGN c-nome-natureza:SCREEN-VALUE IN FRAME fpage0 = natur-oper.denominacao.
        
        /*---[ Identifica a finalidade da nf-e ]--------------------------------*/
        IF  AVAIL estabelec AND AVAIl natur-oper    
        AND  estabelec.des-vers-layout  >= "3.10"  
        AND ( natur-oper.especie-doc = "NFD" ) 
        THEN ASSIGN i-fin-nfe:SCREEN-VALUE IN FRAME fPage0 = "4":U. /* 4 = Devoluá∆o de Mercadoria */
        ELSE ASSIGN i-fin-nfe:SCREEN-VALUE IN FRAME fPage0 = "1":U. /* 1 = NF-e Normal             */

        FIND FIRST ped-fiscal NO-LOCK
            WHERE  ped-fiscal.nr-pedido = INT(c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
        IF  AVAIL ped-fiscal THEN DO:
            FIND FIRST natureza-ped-fiscal NO-LOCK
                 WHERE natureza-ped-fiscal.natureza = ped-fiscal.nat-oper NO-ERROR.
            IF  natur-oper.especie-doc = "NFD" AND natureza-ped-fiscal.Ind-hab-ger-nf-dev   THEN
                ASSIGN i-fin-nfe:SCREEN-VALUE IN FRAME fPage0 = "4":U. /* 4 = Devoluá∆o de Mercadoria */
            
            IF AVAIL natureza-ped-fiscal  THEN DO:
            
               FIND FIRST natur-oper-ped-fiscal NO-LOCK
                    WHERE natur-oper-ped-fiscal.natureza = natureza-ped-fiscal.natureza
                      AND natur-oper-ped-fiscal.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0
               NO-ERROR.

               ASSIGN fi-serie:SCREEN-VALUE IN FRAME fpage0 = ''.
                      fi-serie:SENSITIVE IN FRAME fpage0    = NO.
              
               IF AVAIL natur-oper-ped-fiscal THEN DO:
                  IF natur-oper-ped-fiscal.possui-serie-espec THEN 
                     ASSIGN fi-serie:SENSITIVE IN FRAME fpage0 = YES.
                  ELSE 
                     ASSIGN fi-serie:SENSITIVE IN FRAME fpage0 = NO.
               END.
            END.
        END.
    END. /* IF  c-nat-oper:SCREEN-VALUE IN FRAME fpage0 NE "" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON MOUSE-SELECT-DBLCLICK OF c-nat-oper IN FRAME fpage0 /* Natureza de Operaá∆o */
DO:
  apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-solicitacao wWindow
ON LEAVE OF c-nat-operacao-solicitacao IN FRAME fpage0 /* Nat.Operaá∆o Solicitaá∆o */
DO:
    FIND natur-oper
        WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fpage0
        NO-LOCK NO-ERROR.
      IF NOT AVAIL natur-oper THEN DO:
         RUN utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o informada n∆o existe NO cadastro cd0606').
         RETURN 'NOK'.
      END.
      ASSIGN c-nome-natureza:SCREEN-VALUE IN FRAME fpage0 = natur-oper.denominacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-solicitacao wWindow
ON ENTRY OF c-nr-solicitacao IN FRAME fpage0 /* Solicitaá∆o */
DO:
  
    IF I-NumPedidoEsftp060 <> 0 THEN
        ASSIGN c-nr-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(I-NumPedidoEsftp060).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-solicitacao wWindow
ON LEAVE OF c-nr-solicitacao IN FRAME fpage0 /* Solicitaá∆o */
DO: 
    IF  c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0 = "" 
    OR  c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0 = "0" THEN DO:

        FIND FIRST ped-fiscal NO-LOCK NO-ERROR.
        IF  AVAIL ped-fiscal THEN ASSIGN c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0 = STRING(ped-fiscal.nr-pedido).

    END.
    ELSE DO:
        FIND FIRST ped-fiscal NO-LOCK 
            WHERE  ped-fiscal.nr-pedido = int(c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
        IF  AVAIL  ped-fiscal THEN DO:
            FIND FIRST emitente NO-LOCK
                WHERE  emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.
            IF  AVAIL  emitente THEN 
                ASSIGN c-nome-cliente:SCREEN-VALUE    IN FRAME fpage0 = emitente.nome-emit
                       c-cliente:SCREEN-VALUE         IN FRAME fpage0 = emitente.nome-abrev
                       c-estado:SCREEN-VALUE          IN FRAME fpage0 = emitente.estado
                       c-cod-canal-venda:SCREEN-VALUE IN FRAME fpage0 = string(ped-fiscal.canal-vendas)
                       c-estabelecimento:SCREEN-VALUE IN FRAME fpage0 = ped-fiscal.cod-estabel.


        
            FIND FIRST natureza-ped-fiscal NO-LOCK
                WHERE  natureza-ped-fiscal.natureza = ped-fiscal.nat NO-ERROR.
            IF  AVAIL  natureza-ped-fiscal 
            THEN ASSIGN c-nat-operacao-solicitacao:SCREEN-VALUE IN FRAME fpage0 = string(natureza-ped-fiscal.natureza) + " - " + natureza-ped-fiscal.descricao.
            ELSE ASSIGN c-nat-operacao-solicitacao:SCREEN-VALUE IN FRAME fpage0 = "".
            
            RUN dibo/bodi317sd.p PERSISTENT SET h-bodi317sd.
            RUN leaveCodEstabel in h-bodi317sd (input  ped-fiscal.cod-estabel, 
                                                input  no, 
                                                output c-char-aux).
    
            DELETE PROCEDURE h-bodi317sd.
            
            FIND FIRST ser-estab
                WHERE  ser-estab.serie       = c-char-aux  
                AND    ser-estab.cod-estabel = ped-fiscal.cod-estabel NO-LOCK NO-ERROR.
                    
            ASSIGN dt-emissao:SCREEN-VALUE IN FRAME fpage0 = IF AVAIL ser-estab 
                                                             THEN string(ser-estab.dt-ult-fat)
                                                             ELSE string(TODAY).               /* Data de emiss∆o da nota    */
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie wWindow
ON F5 OF fi-serie IN FRAME fpage0 /* SÇrie */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z10in407.w"
                         &FieldZoom1="serie"
                         &FieldScreen1="fi-serie"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-serie IN FRAME fpage0 /* SÇrie */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


FOR EACH mgesp.ponto-programa
    where mgesp.ponto-programa.nome-programa = "esftp012"
      AND mgesp.ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.conteudo = "Sim":
        assign l-aloca-estoque = yes.
    end.
    
c-nat-oper:load-mouse-pointer("image/lupa.cur":U) in frame fpage0.
fi-serie:load-mouse-pointer("image/lupa.cur":U) in frame fpage0.

/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exibeRowErrors wWindow 
PROCEDURE exibeRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {method/ShowMessage.i1}
    {method/ShowMessage.i2 &Modal="yes"}
    {method/ShowMessage.i3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalizaHandles wWindow 
PROCEDURE finalizaHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-bodi317in)    THEN RUN finalizaBOs    IN h-bodi317in.
    IF VALID-HANDLE(h-bodi317sd)    THEN RUN finalizaBOs    IN h-bodi317sd.
    IF VALID-HANDLE(h-boin404te)    THEN DELETE PROCEDURE h-boin404te.
    IF VALID-HANDLE(h-bodi317)      THEN DELETE PROCEDURE h-bodi317.
    IF VALID-HANDLE(h-bodi321)      THEN DELETE PROCEDURE h-bodi321.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraItensDevolucaoTtItensDevol wWindow 
PROCEDURE geraItensDevolucaoTtItensDevol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-c-serie-devol     like item-doc-est.serie-docto    no-undo.
    def input  param p-c-nr-nota-devol   like item-doc-est.nro-docto      no-undo.
    def input  param p-i-cod-emitente    like item-doc-est.cod-emitente   no-undo.
    def input  param p-c-nat-oper-devol  like item-doc-est.nat-operacao   no-undo.
    def input  param p-i-sequencia       like item-doc-est.sequencia      no-undo.
    def input  param p-d-qtde            like mgesp.it-ped-fiscal.qtde   no-undo.    
  /*def output param table               for tt-itens-devol-aux.*/
    def output param p-l-procedimento-ok as   log                         no-undo.

    /* Definicao de variaveis locais */
    def var l-proc-ok-aux as log    no-undo.
    def var h-boin672     as handle no-undo.

    run inbo/boin672.p persistent set h-boin672.
    
    for first item-doc-est
        where item-doc-est.serie-docto  = p-c-serie-devol
        and   item-doc-est.nro-docto    = p-c-nr-nota-devol 
        and   item-doc-est.cod-emitente = p-i-cod-emitente
        and   item-doc-est.nat-operacao = p-c-nat-oper-devol 
        and   item-doc-est.sequencia    = p-i-sequencia no-lock:

        find first item where
                   item.it-codigo = item-doc-est.it-codigo no-lock no-error.
        if not avail item then next.

        create tt-itens-devol.
        assign tt-itens-devol.serie-docto  = item-doc-est.serie-docto 
               tt-itens-devol.cod-emitente = item-doc-est.cod-emitente
               tt-itens-devol.nro-docto    = item-doc-est.nro-docto   
               tt-itens-devol.nat-operacao = item-doc-est.nat-operacao
               tt-itens-devol.sequencia    = item-doc-est.sequencia
               tt-itens-devol.it-codigo    = item-doc-est.it-codigo
               tt-itens-devol.cod-refer    = item-doc-est.cod-refer
               tt-itens-devol.desc-nar     = if  item.tipo-contr = 4 /* D≤bito Direto */
                                                 then substr(item.narrativa,1,60)
                                                 else item.desc-item
               tt-itens-devol.quantidade   = item-doc-est.quantidade
               tt-itens-devol.preco-total  = item-doc-est.preco-total[1]
               tt-itens-devol.selecionado  = YES.

        run calculaQuantDevolvida in h-boin672(input  item-doc-est.serie-docto,
                                               input  item-doc-est.nro-docto,
                                               input  item-doc-est.cod-emitente,
                                               input  item-doc-est.nat-operacao,
                                               input  item-doc-est.sequencia,
                                               output tt-itens-devol.qt-ja-devolvida).
        run calculaSaldoDevolver  in h-boin672(input  item-doc-est.serie-docto,
                                               input  item-doc-est.nro-docto,
                                               input  item-doc-est.cod-emitente,
                                               input  item-doc-est.nat-operacao,
                                               input  item-doc-est.sequencia,
                                               output tt-itens-devol.qt-a-devolver).

        assign tt-itens-devol.qt-a-devolver-inf = p-d-qtde. /** o valor de "p-d-qtde" foi informado no programa ESFTP012 - botao "Ger It" **/
    end.

    if  valid-handle(h-boin672) then do:
        delete procedure h-boin672.
        assign h-boin672 = ?.
    end.
        
    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaWt-itens wWindow 
PROCEDURE piCriaWt-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    {esp/ftp/esftp009.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaSaldo wWindow 
PROCEDURE piVerificaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   for each mgesp.it-ped-fiscal of tt-ped-fiscal no-lock,
       first item no-lock where
             item.it-codigo = mgesp.it-ped-fiscal.it-codigo and
             item.baixa-estoq and
             item.tipo-contr <> 4 
             break by mgesp.it-ped-fiscal.cod-depos
                   by mgesp.it-ped-fiscal.it-codigo:
     
       if first-of(it-ped-fiscal.it-codigo) then
          assign de-qtde = 0.
          
       assign de-qtde = de-qtde + mgesp.it-ped-fiscal.qtde.
          
       if last-of(it-ped-fiscal.it-codigo) then do:
          assign de-qtde-se = 0
                 de-qtde-br = 0
                 de-qt-nf = 0.
          
/*           do da-data = today - 32 to today:                                   */
/*              for each nota-fiscal no-lock use-index ch-distancia where        */
/*                  nota-fiscal.dt-confirma = ? and                              */
/*                  nota-fiscal.dt-cancela = ? and                               */
/*                  nota-fiscal.dt-emis-nota = da-data and                       */
/*                  nota-fiscal.cod-estabel = "101" and                          */
/*                  nota-fiscal.nat-operacao >= "510100",                        */
/*                  each it-nota-fis of nota-fiscal no-lock                      */
/*                       where it-nota-fis.it-codigo = mgesp.it-ped-fiscal.it-codigo   */
/*                         and it-nota-fis.baixa-est,                            */
/*                  each fat-ser-lote no-lock                                    */
/*                       where fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo */
/*                         and fat-ser-lote.cod-estabel = "101"                  */
/*                         and fat-ser-lote.serie       = nota-fiscal.serie      */
/*                         and fat-ser-lote.nr-nota-fis =                        */
/*                                                    nota-fiscal.nr-nota-fis    */
/*                         and fat-ser-lote.nr-seq-fat  = it-nota-fis.nr-seq-fat */
/*                         and fat-ser-lote.cod-depos   =                        */
/*                                                    mgesp.it-ped-fiscal.cod-depos:   */
/*                  assign de-qt-nf = de-qt-nf + it-nota-fis.qt-faturada[1].     */
/*              end.                                                             */
/*            end.                                                               */
 
           for each saldo-estoq no-lock 
              where saldo-estoq.it-codigo   = mgesp.it-ped-fiscal.it-codigo 
                and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos
                and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao:
              assign de-qtde-se = de-qtde-se + 
                                  (saldo-estoq.qtidade-atu - 
                                   saldo-estoq.qt-alocada)
                     de-qt-nf = de-qt-nf - saldo-estoq.qt-alocada.
          end.
             
          for each saldo-estoq no-lock 
              where saldo-estoq.it-codigo = mgesp.it-ped-fiscal.it-codigo 
                and saldo-estoq.cod-depos = mgesp.it-ped-fiscal.cod-depos
                and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao:
              assign de-qtde-br = de-qtde-br + 
                                  (saldo-estoq.qtidade-atu - 
                                   saldo-estoq.qt-alocada).
          end.

          assign c-descricao = item.desc-item.
          
          if mgesp.it-ped-fiscal.cod-depos <> "dev" then do:
             if (de-qtde + de-qt-nf) > de-qtde-br then do:
                 CREATE tt-saldo.
                 ASSIGN tt-saldo.it-codigo = mgesp.it-ped-fiscal.it-codigo
                        tt-saldo.descricao = c-descricao
                        tt-saldo.cod-depos = mgesp.it-ped-fiscal.cod-depos
                        tt-saldo.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao
                        tt-saldo.qtde = mgesp.it-ped-fiscal.qtde
                        tt-saldo.qtde-se = de-qtde-se
                        tt-saldo.qtde-br = de-qtde-br
                        tt-saldo.qtde-nf = de-qt-nf.
             end.
             assign de-qtde = 0.
          end.   
          else do:
             if (de-qtde + de-qt-nf) > de-qtde-se then do:
                 CREATE tt-saldo.
                 ASSIGN tt-saldo.it-codigo = mgesp.it-ped-fiscal.it-codigo
                        tt-saldo.descricao = c-descricao
                        tt-saldo.cod-depos = mgesp.it-ped-fiscal.cod-depos
                        tt-saldo.cod-localizacao = mgesp.it-ped-fiscal.cod-localizacao
                        tt-saldo.qtde = mgesp.it-ped-fiscal.qtde
                        tt-saldo.qtde-se = de-qtde-se
                        tt-saldo.qtde-br = de-qtde-br
                        tt-saldo.qtde-nf = de-qt-nf.
             end.
             assign de-qtde = 0.
          end.
       end.   
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescSituacao wWindow 
FUNCTION fnDescSituacao RETURNS CHARACTER
  ( piSituacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cSituacao   AS CHARACTER    NO-UNDO.

    CASE piSituacao:
        WHEN 0 THEN ASSIGN cSituacao = 'Digitado'.
        WHEN 1 THEN ASSIGN cSituacao = 'A Liberar'.
        WHEN 2 THEN ASSIGN cSituacao = 'A Relacionar'.
        WHEN 3 THEN ASSIGN cSituacao = 'A Faturar'.
        WHEN 4 THEN ASSIGN cSituacao = 'Atendida Parcialmente'.
        WHEN 5 THEN ASSIGN cSituacao = 'Atendido'.
        WHEN 6 THEN ASSIGN cSituacao = 'Bloqueado'.
        OTHERWISE   ASSIGN cSituacao = 'Desconhecido'.
    END CASE.

    RETURN cSituacao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

