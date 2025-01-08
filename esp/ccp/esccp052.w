&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** 
*******************************************************************************/
{include/i-prgvrs.i ESCCP052 2.04.00.006}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE BUFFER empresa         FOR mgcad.empresa.
{cdp/cdcfgman.i}   /* Variòvel preprocessador bf_man_sfc_lc      */
{cpp/cpapi301.i}
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen  AS INTEGER  FORMAT "999"
    FIELD cd-erro   AS INTEGER  FORMAT ">>>>9"
    FIELD mensagem  AS CHAR FORMAT "x(256)".

DEFINE TEMP-TABLE tt-dados NO-UNDO
        FIELD tipo-dados      AS CHAR
        FIELD ordem-aps       AS CHAR FORMAT "x(15)"
        FIELD it-codigo       LIKE ITEM.it-codigo
        FIELD quantidade      AS DEC  FORMAT "->>>,>>>,>>9.9999"
        FIELD data-inicial    AS DATE
        FIELD data-ini-antes  AS DATE
        FIELD data-fim-antes  AS DATE
        FIELD data-final      AS DATE
        FIELD marcado         AS LOGICAL  FORMAT "*/ "
        FIELD numero          AS INTEGER
        FIELD cod-estabel     AS CHAR FORMAT "x(03)"
        FIELD ge-codigo       LIKE ITEM.ge-codigo
        FIELD nr-linha        LIKE ITEM.nr-linha
        FIELD row-tabela      AS ROWID
        FIELD status-reg      AS CHAR FORMAT  "x(05)"
        FIELD nr-sequencia    AS INT
        FIELD desc-item       AS CHAR
        FIELD data-libera     AS DATE
        FIELD dt-necessidade  AS DATE FORMAT "99/99/9999"
        FIELD data-entrega    AS DATE
        FIELD data-emissao    AS DATE 
        FIELD log-integrado   AS LOGICAL
        FIELD log-eliminado   AS LOGICAL
        FIELD parcela         AS INTEGER
        FIELD dias-dif        AS INTEGER
        FIELD mensagem        AS CHAR FORMAT "x(100)"
        FIELD log-inexistente AS LOGICAL
        field sequencia       as integer
        INDEX idx-codigo IS PRIMARY tipo-dados ordem-aps data-final
        INDEX itg        log-integrado log-eliminado
        INDEX idx-marcado marcado.

define temp-table tt-dados-aux no-undo
    field row-tabela as rowid
    field mensagem   as char.

DEF TEMP-TABLE tt-param-usuario NO-UNDO
    FIELD cod-estabel AS CHAR
    FIELD unidade     AS CHAR
    FIELD usuario     AS CHAR
    INDEX idx         cod-estabel unidade usuario.

def new global shared temp-table tt-ordem-esccp052 no-undo
    field it-codigo    like ordem-compra.it-codigo
    field numero-ordem like ordem-compra.numero-ordem
    field qt-solic     like ordem-compra.qt-solic
    index id is primary it-codigo
                        numero-ordem.

DEFINE BUFFER b-tt-dados      FOR tt-dados.
define buffer bf-param-compra for param-compra.

/*--- selecao OP -------*/
DEFINE VARIABLE c-item-ini      AS CHAR NO-UNDO.
DEFINE VARIABLE c-item-fim      AS CHAR NO-UNDO. 
DEFINE VARIABLE c-unid-neg-ini  AS CHAR NO-UNDO.
DEFINE VARIABLE c-unid-neg-fim  AS CHAR NO-UNDO.
DEFINE VARIABLE c-estabel-ini   AS CHAR NO-UNDO.
DEFINE VARIABLE c-estabel-fim   AS CHAR NO-UNDO.
DEFINE VARIABLE d-emissao-ini   AS DATE NO-UNDO.
DEFINE VARIABLE d-emissao-fim   AS DATE NO-UNDO.
DEFINE VARIABLE d-inicio-ini    AS DATE NO-UNDO.
DEFINE VARIABLE d-inicio-fim    AS DATE NO-UNDO.
DEFINE VARIABLE c-ordem-ini     AS CHAR NO-UNDO.
DEFINE VARIABLE c-ordem-fim     AS CHAR NO-UNDO.
DEFINE VARIABLE i-ordem-ini     AS INT  NO-UNDO.
DEFINE VARIABLE i-ordem-fim     AS INT  NO-UNDO.
DEFINE VARIABLE dt-termino-ini  AS DATE NO-UNDO.
DEFINE VARIABLE dt-termino-fim  AS DATE NO-UNDO.
DEFINE VARIABLE dt-neces-ini    AS DATE NO-UNDO.
DEFINE VARIABLE dt-neces-fim    AS DATE NO-UNDO.
DEFINE VARIABLE dt-neces-ini-a  AS DATE NO-UNDO.
DEFINE VARIABLE dt-neces-fim-a  AS DATE NO-UNDO.
DEFINE VARIABLE i-grupo-ini     AS INTEGER NO-UNDO.
DEFINE VARIABLE i-grupo-fim     AS INTEGER NO-UNDO.
DEFINE VARIABLE dt-entrega-ini  AS DATE NO-UNDO.
DEFINE VARIABLE dt-entrega-fim  AS DATE NO-UNDO.
DEFINE VARIABLE c-pedido-ini    AS CHAR NO-UNDO.
DEFINE VARIABLE c-pedido-fim    AS CHAR NO-UNDO.
DEFINE VARIABLE c-fm-codigo-ini AS CHAR NO-UNDO.
DEFINE VARIABLE c-fm-codigo-fim AS CHAR NO-UNDO.
DEFINE VARIABLE c-erro          AS CHAR NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE NO-UNDO.
DEFINE VARIABLE i-acomp         AS INT NO-UNDO.
DEFINE VARIABLE i-acomp-aux     AS INT NO-UNDO.
DEFINE VARIABLE dt-libera-ini   AS DATE NO-UNDO.
DEFINE VARIABLE dt-libera-fim   AS DATE NO-UNDO.
DEFINE VARIABLE l-ok            AS LOG NO-UNDO.
define variable c-msg           as CHAR NO-UNDO.
define variable c-motivo        as char init "Alteraá∆o de Estrutura,Phase out produto" NO-UNDO.
define variable c-cod-obsoleto  as char init "Ativo,Obsoleto Ordens Autom†tica,Obsoleto Todas as Ordens,Totalmente Obsoleto" NO-UNDO.

/*--- funcionalidade de Pedidos ---*/
{btb/btb008za.i0}

{cdp/cdapi300.i1}  /* Temp-TABLE de Erros   */
{cdp/cdcfgdis.i} /*include para pr≤-processadores*/
{utp/utapi019.i}

DEF VAR bo-ped-venda         AS HANDLE  NO-UNDO.
DEF VAR bo-ped-item          AS HANDLE  NO-UNDO.
DEF VAR bo-ped-repre         AS HANDLE  NO-UNDO.
DEF VAR h-bodi233            AS HANDLE  NO-UNDO.
DEF VAR hColumn              AS HANDLE  NO-UNDO.
DEF VAR c-ocorrencia         AS CHAR    NO-UNDO.
DEF VAR i-prox-ordem         LIKE ord-prod.nr-ord-prod NO-UNDO.
def var c-rodape-aux         as char    no-undo.

define variable tg-ord-prod        as logical init yes no-undo.
define variable tg-ordem-compra    as logical init yes no-undo. 
define variable tg-up-ord-prod     as logical init yes no-undo.
define variable tg-up-ordem-compra as logical init yes no-undo.
define variable i-aux              as integer          no-undo.

/*---- funcionalidade de compras ---*/
{cdp/cdcfgmat.i}
{ccp/ccapi202.i}
{ccp/ccapi207.i}

{CPP/CPAPI301.I20} 

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erros-geral.

{include/i-rpvar.i}

/*** Definicao de Forms
**********************************/
form header
    fill("-", 215) format "x(215)" skip
    c-empresa c-titulo-relat at 50
    "Folha:" at 205 page-number  at 211 format ">>>>9" skip
    fill("-", 195) format "x(193)" today format "99/99/9999"
    "-" string(time, "HH:MM:SS") skip(1)
    with stream-io width 215 no-labels no-box page-top frame f-cabecalho.

form header
     c-rodape-aux format "x(215)"
     with stream-io width 215 no-labels no-box page-bottom frame f-rodape1.

DEF TEMP-TABLE tt-log-ord-prod NO-UNDO
    FIELD cod-estab   AS CHAR
    FIELD nr-ord-prod AS INT
    field sequencia   as int
    FIELD it-codigo   AS CHAR
    FIELD dt-inicio   AS DATE
    FIELD dt-termino  AS DATE
    FIELD qtde        AS DEC
    FIELD acao        AS CHAR
    FIELD cStatus     AS CHAR
    FIELD ordem-aps   AS CHAR 
    INDEX idx         nr-ord-prod
                      sequencia.

DEF TEMP-TABLE tt-log-ordem-compra NO-UNDO
    field seq            as inte
    FIELD cod-estab      AS CHAR
    FIELD nr-ord-comp    AS INT
    field sequencia      as int
    FIELD it-codigo      AS CHAR
    FIELD qtde           AS DEC
    FIELD dt-entrega     AS DATE
    FIELD acao           AS CHAR
    FIELD cStatus        AS CHAR
    FIELD ordem-aps      AS CHAR 
    FIELD parcela        AS INT
    FIELD dt-necessidade AS DATE
    INDEX idx  seq nr-ord-comp
                   sequencia.

DEF TEMP-TABLE tt-restricao-usuario NO-UNDO
    FIELD cod-usuario    AS CHAR
    FIELD estab-param    AS CHAR
    FIELD unid-neg-param AS CHAR
    INDEX idx            cod-usuario.

DEF BUFFER bf-param-cp FOR param-cp.

def buffer b-tt-log-ordem-compra for tt-log-ordem-compra.
def buffer b-int-ord-comp-aps    for int-ord-comp-aps.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brDados

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-dados

/* Definitions for BROWSE brDados                                       */
&Scoped-define FIELDS-IN-QUERY-brDados tt-dados.tipo-dados tt-dados.cod-estabel tt-dados.ordem-aps tt-dados.numero tt-dados.parcela tt-dados.it-codigo tt-dados.desc-item tt-dados.quantidade tt-dados.data-emissao tt-dados.data-ini-antes tt-dados.data-inicial tt-dados.data-fim-antes tt-dados.data-entrega tt-dados.dt-necessidade tt-dados.data-libera tt-dados.data-final tt-dados.dias-dif tt-dados.marcado tt-dados.mensagem   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDados   
&Scoped-define SELF-NAME brDados
&Scoped-define QUERY-STRING-brDados FOR EACH tt-dados
&Scoped-define OPEN-QUERY-brDados OPEN QUERY brDados FOR EACH tt-dados.
&Scoped-define TABLES-IN-QUERY-brDados tt-dados
&Scoped-define FIRST-TABLE-IN-QUERY-brDados tt-dados


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-brDados}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rt-button btSelec btImporta ~
i-opcao l-elimina brDados 
&Scoped-Define DISPLAYED-OBJECTS i-opcao l-elimina tg-split dTotalReg ~
dTotalRegSel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaDataInicioOP w-livre 
FUNCTION fnBuscaDataInicioOP RETURNS DATE
  ( dtOrig AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaDataTerminoOp w-livre 
FUNCTION fnBuscaDataTerminoOp RETURNS DATE
  ( dtOrig AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnErro w-livre 
FUNCTION fnErro RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&esccp052"     
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     LABEL "Confirma" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-desmarca 
     LABEL "Desmarca" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-marca 
     LABEL "Marca" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btImporta 
     IMAGE-UP FILE "image\toolbar\im-imp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Importa Ordens Compra/Produá∆o do APS".

DEFINE BUTTON btSelec 
     IMAGE-UP FILE "image\im-ran":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Seleá∆o".

DEFINE VARIABLE dTotalReg AS DECIMAL FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Total de Registros" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE dTotalRegSel AS DECIMAL FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Total de Registros Selecionados" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE i-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ordem de Produá∆o", 1,
"Ordem de Compra", 2,
"Atualiza Ordem de Produá∆o", 3,
"Atualiza Ordem de Compra", 4
     SIZE 94.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 137.72 BY 3.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 106 BY 2.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142 BY 1.46
     BGCOLOR 7 .

DEFINE VARIABLE l-elimina AS LOGICAL INITIAL no 
     LABEL "Elimina Ordem Selecionada" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-split AS LOGICAL INITIAL no 
     LABEL "Div. OC Forn." 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDados FOR 
      tt-dados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDados w-livre _FREEFORM
  QUERY brDados DISPLAY
      tt-dados.tipo-dados      COLUMN-LABEL "Tipo"
      tt-dados.cod-estabel     COLUMN-LABEL "Est"
      tt-dados.ordem-aps       COLUMN-LABEL "Ordem APS" FORMAT "x(15)"
      tt-dados.numero          COLUMN-LABEL "Ordem" width 12
      tt-dados.parcela         COLUMN-LABEL "Parcela"
      tt-dados.it-codigo       COLUMN-LABEL "Item"
      tt-dados.desc-item       COLUMN-LABEL "Descriá∆o" FORMAT "x(36)"
      tt-dados.quantidade      COLUMN-LABEL "Quantidade"
      tt-dados.data-emissao    COLUMN-LABEL "Data Emiss∆o"
      tt-dados.data-ini-antes  COLUMN-LABEL "Data In°cio Antes"
      tt-dados.data-inicial    COLUMN-LABEL "Data In°cio"
      tt-dados.data-fim-antes  COLUMN-LABEL "Data TÇrmino Antes"
      tt-dados.data-entrega    COLUMN-LABEL "Data TÇrmino"
      tt-dados.dt-necessidade  COLUMN-LABEL "Data Necessidade"
      tt-dados.data-libera     COLUMN-LABEL "Data Entrega"
      tt-dados.data-final      COLUMN-LABEL "Data Final"
      tt-dados.dias-dif        COLUMN-LABEL "Dias Diferenáa"
      tt-dados.marcado         COLUMN-LABEL "*"
      tt-dados.mensagem        COLUMN-LABEL "Erros"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 138 BY 17.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btSelec AT ROW 1.13 COL 119.43
     btImporta AT ROW 1.17 COL 113 WIDGET-ID 4
     i-opcao AT ROW 3.63 COL 15.14 NO-LABEL WIDGET-ID 18
     l-elimina AT ROW 4.13 COL 116.57 WIDGET-ID 2
     tg-split AT ROW 4.63 COL 37 WIDGET-ID 16
     brDados AT ROW 6.25 COL 5
     bt-confirma AT ROW 24.13 COL 5
     bt-marca AT ROW 24.13 COL 20
     bt-desmarca AT ROW 24.13 COL 35 WIDGET-ID 14
     dTotalReg AT ROW 24.21 COL 89 COLON-ALIGNED WIDGET-ID 10
     dTotalRegSel AT ROW 24.21 COL 129.14 COLON-ALIGNED WIDGET-ID 12
     "Opá∆o:" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 3.13 COL 6.86 WIDGET-ID 24
     RECT-1 AT ROW 2.75 COL 5.29
     RECT-2 AT ROW 3 COL 6 WIDGET-ID 8
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.29 BY 24.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 24.63
         WIDTH              = 144.43
         MAX-HEIGHT         = 40.5
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 40.5
         VIRTUAL-WIDTH      = 274.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB brDados tg-split f-cad */
/* SETTINGS FOR BUTTON bt-confirma IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-desmarca IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-marca IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dTotalReg IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dTotalRegSel IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-split IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDados
/* Query rebuild information for BROWSE brDados
     _START_FREEFORM
OPEN QUERY brDados FOR EACH tt-dados.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDados */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDados
&Scoped-define SELF-NAME brDados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDados w-livre
ON DEFAULT-ACTION OF brDados IN FRAME f-cad
DO:
   if not avail tt-dados then return.

   IF INPUT i-opcao = 1 THEN
   DO:
       RUN pi-muda-browse(INPUT 1).

       /*--- encontra a ordem ---*/
      /* FIND ord-prod WHERE
            ord-prod.nr-ord-prod = tt-dados.numero 
            NO-LOCK NO-ERROR.
       IF NOT AVAIL ord-prod THEN
       DO:
          MESSAGE "Ordem de producao nao encontrada no EMS. Nao ser† possivel MODIFICAR !!!"
                  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.*/

       if  l-elimina:checked in frame f-cad = no
       and tt-dados.marcado                 = no
       then do:
           FIND ITEM WHERE
                ITEM.it-codigo = tt-dados.it-codigo
                NO-LOCK NO-ERROR.

           IF NOT AVAIL item THEN
           DO:
               MESSAGE "Item nao cadastrado !"
                       VIEW-AS ALERT-BOX ERROR.
               UNDO, RETURN NO-APPLY.
           END.
    
           FIND item-uni-estab WHERE
                item-uni-estab.cod-estabel = tt-dados.cod-estabel AND
                item-uni-estab.it-codigo   = tt-dados.it-codigo
                NO-LOCK NO-ERROR.
    
           IF NOT AVAIL item-uni-estab THEN
           DO:
               MESSAGE "Item X Estabelec. nao cadastrado !"
                       VIEW-AS ALERT-BOX ERROR.
               UNDO, RETURN NO-APPLY.
           END.
    
           IF item-uni-estab.cd-planejado = "" THEN
           DO:
              MESSAGE "Planejador nao cadastrado para o item !"
                      VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN NO-APPLY.
           END.   
    
           IF item-uni-estab.cod-obsoleto > 1 THEN
           DO:
              assign c-msg = "Item n∆o est† ativo !".
    
              if item-uni-estab.cod-obsoleto < 5
              then do:
                   assign c-msg = "Item est† "
                                + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).
    
                   for first int-item fields(motivo-situacao) no-lock
                       where int-item.it-codigo       = item-uni-estab.it-codigo
                         and int-item.motivo-situacao > 0
                         and int-item.motivo-situacao < 3:
                       assign c-msg = c-msg 
                                    + " - "
                                    + entry(int-item.motivo-situacao,c-motivo).
                   end. /* for first int-item */
    
                   assign c-msg = c-msg + " !".
              end. /* if item-uni-estab.cod-obsoleto < 5 */
    
              MESSAGE c-msg
                      VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          end.

           IF NOT CAN-FIND(FIRST operacao
                           WHERE operacao.it-codigo     = tt-dados.it-codigo
                           AND   operacao.data-inicio  <= TODAY
                           AND   operacao.data-termino >= TODAY) THEN
           DO:
              
              MESSAGE "Item n∆o possui roteiro de fabricaá∆o ativo!"
                      VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN NO-APPLY.
           END.
       END. /* IF item-uni-estab.cod-obsoleto > 1 */
       
       IF tt-dados.marcado = TRUE THEN
          ASSIGN tt-dados.marcado = FALSE.
       ELSE
          ASSIGN tt-dados.marcado = TRUE.

   END.
   ELSE
   IF INPUT i-opcao = 2 THEN
   DO:
      RUN pi-muda-browse(INPUT 2).

      if  l-elimina:checked in frame f-cad = no
      and tt-dados.marcado                 = no
      then do:
          FIND ITEM WHERE
               ITEM.it-codigo = tt-dados.it-codigo NO-LOCK NO-ERROR.

          IF NOT AVAIL ITEM THEN
          DO:
             MESSAGE "Item nao cadastrado no EMS !!!"
                     VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
          END.
    
          FIND item-uni-estab WHERE
               item-uni-estab.cod-estabel = tt-dados.cod-estabel AND
               item-uni-estab.it-codigo   = tt-dados.it-codigo
               NO-LOCK NO-ERROR.
    
          IF NOT AVAIL item-uni-estab THEN
          DO:
              MESSAGE "Item X Estabelec. nao cadastrado !"
                      VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
    
          IF item-uni-estab.cod-obsoleto > 1 THEN
          DO:
             assign c-msg = "Item n∆o est† ativo !".
    
             if item-uni-estab.cod-obsoleto < 5
             then do:
                  assign c-msg = "Item est† "
                               + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).
    
                  for first int-item fields(motivo-situacao) no-lock
                      where int-item.it-codigo       = item-uni-estab.it-codigo
                        and int-item.motivo-situacao > 0
                        and int-item.motivo-situacao < 3:
                      assign c-msg = c-msg 
                                   + " - "
                                   + entry(int-item.motivo-situacao,c-motivo).
                  end. /* for first int-item */
    
                  assign c-msg = c-msg + " !".
             end. /* if item-uni-estab.cod-obsoleto < 5 */
    
             MESSAGE c-msg
                     VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
          END. /* IF item-uni-estab.cod-obsoleto > 1 */
      end.

      IF tt-dados.marcado = TRUE THEN
         ASSIGN tt-dados.marcado = FALSE.
      ELSE
         ASSIGN tt-dados.marcado = TRUE.

   END.
   IF INPUT i-opcao = 3 THEN
   DO:
      RUN pi-muda-browse(INPUT 3). 

      IF  l-elimina:checked in frame f-cad = no
      and tt-dados.marcado                     = no
      and CAN-FIND(FIRST ord-prod where
                        ord-prod.nr-ord-produ = tt-dados.numero
                    and ord-prod.estado       > 6
                    and ord-prod.estado      <= 8
                        no-lock)
      then do:
           MESSAGE "Ordem de Produá∆o finalizada ou terminada !"
                   VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      end.

      IF tt-dados.marcado = TRUE THEN
         ASSIGN tt-dados.marcado = FALSE.
      ELSE
         ASSIGN tt-dados.marcado = TRUE.
   END.
   IF INPUT i-opcao = 4 THEN
   DO:
      RUN pi-muda-browse(INPUT 4).

      if  l-elimina:checked in frame f-cad = no
      and tt-dados.marcado                 = no
      then do:
           if CAN-FIND(FIRST prazo-compra NO-LOCK
                       WHERE prazo-compra.numero-ordem = tt-dados.numero
                         AND prazo-compra.parcela      = tt-dados.parcela
                         and prazo-compra.situacao     = 4) THEN DO:
                MESSAGE "Parcela da Ordem foi eliminada !"
                          VIEW-AS ALERT-BOX ERROR.
                return no-apply.
           END.

           if CAN-FIND(FIRST prazo-compra NO-LOCK
                       WHERE prazo-compra.numero-ordem = tt-dados.numero
                         AND prazo-compra.parcela      = tt-dados.parcela
                         and prazo-compra.situacao     = 6) THEN DO:
                MESSAGE "Parcela da Ordem est† recebida !"
                          VIEW-AS ALERT-BOX ERROR.
                return no-apply.
           END.
      end.

      IF tt-dados.marcado = TRUE THEN
         ASSIGN tt-dados.marcado = FALSE.
      ELSE
         ASSIGN tt-dados.marcado = TRUE.

   END.
   
   ASSIGN dTotalRegSel = 0.
   FOR EACH tt-dados
      WHERE tt-dados.marcado = TRUE.
       ASSIGN dTotalRegSel = dTotalRegSel + 1.
   END.
   ASSIGN dTotalRegSel:SCREEN-VALUE IN FRAME f-cad = STRING(dTotalRegSel).

   IF brDados:REFRESH() THEN.

   assign bt-desmarca:SENSITIVE in frame f-cad = can-find(first tt-dados where
                                                 tt-dados.marcado = true)
          bt-confirma:sensitive in frame f-cad = bt-desmarca:sensitive in frame f-cad
          bt-marca:sensitive in frame f-cad = can-find(first tt-dados where
                                              tt-dados.marcado = false).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDados w-livre
ON ROW-DISPLAY OF brDados IN FRAME f-cad
DO:

  IF tt-dados.marcado THEN
     ASSIGN INPUT BROWSE brDados
            tt-dados.tipo-dados     :font = 6
            tt-dados.cod-estabel    :font = 6
            tt-dados.ordem-aps      :font = 6
            tt-dados.numero         :font = 6
            tt-dados.it-codigo      :font = 6
            tt-dados.desc-item      :font = 6
            tt-dados.parcela        :font = 6
            tt-dados.quantidade     :font = 6
            tt-dados.data-emissao   :font = 6
            tt-dados.data-inicial   :font = 6
            tt-dados.data-entrega   :font = 6
            tt-dados.data-ini-antes :font = 6
            tt-dados.data-fim-antes :font = 6
            tt-dados.dt-necessidade :font = 6
            tt-dados.data-libera    :font = 6
            tt-dados.data-final     :font = 6
            tt-dados.marcado        :font = 6
            tt-dados.mensagem       :font = 6.
  ELSE
     ASSIGN INPUT BROWSE brDados
            tt-dados.tipo-dados     :font = ?
            tt-dados.cod-estabel    :font = ?
            tt-dados.ordem-aps      :font = ?
            tt-dados.numero         :font = ?
            tt-dados.it-codigo      :font = ?
            tt-dados.desc-item      :font = ?
            tt-dados.parcela        :font = ?
            tt-dados.quantidade     :font = ?
            tt-dados.data-emissao   :font = ?
            tt-dados.data-inicial   :font = ?
            tt-dados.data-ini-antes :font = ?
            tt-dados.data-fim-antes :font = ?
            tt-dados.data-entrega   :font = ?
            tt-dados.dt-necessidade :font = ?
            tt-dados.data-libera    :font = ?
            tt-dados.data-final     :font = ?
            tt-dados.marcado        :font = ?
            tt-dados.mensagem       :font = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-livre
ON CHOOSE OF bt-confirma IN FRAME f-cad /* Confirma */
DO:
   FIND FIRST param-global NO-LOCK NO-ERROR.
   FIND FIRST param-cp     NO-LOCK NO-ERROR.
   FIND FIRST param-cs     NO-LOCK NO-ERROR.

   def var i-tipo as inte no-undo.

   IF NOT CAN-FIND(FIRST tt-dados WHERE tt-dados.marcado) THEN
   DO:
      run utp/ut-msgs.p (input "show", 
                         input 17006, 
                         input "Selecione as linhas a serem processadas!").
      RETURN NO-APPLY.
   END.

   RUN pi-muda-browse(INPUT i-opcao).
   if l-elimina:checked in frame f-cad
   then do:
        MESSAGE "Deseja mesmo eliminar o(s) registro(s) selecionado(s)? "
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lElimina AS LOGICAL.

        if lElimina <> yes
        then do:
             MESSAGE "Registro(s) N«O ser†(∆o) eliminado(s)."
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             return no-apply.
        end. /* if lElimina <> yes*/
   end. /* if l-elimina:checked in frame f-cad */

   ASSIGN i-acomp     = 0
          i-acomp-aux = 0.

   FOR EACH tt-dados NO-LOCK WHERE tt-dados.marca:
       i-acomp = i-acomp + 1.
   END.
   
   IF i-opcao = 1 /* ordem de producao */ THEN
   DO:
/*       RUN pi-muda-browse(INPUT 1). */

      run utp/ut-acomp.p persistent set h-acomp.  
      run pi-inicializar in h-acomp (input "Acompanhamento..."). 

      EMPTY TEMP-TABLE tt-log-ord-prod.
      
      leitura:
      FOR EACH tt-dados WHERE tt-dados.marcado = TRUE:

          IF l-elimina:CHECKED IN FRAME f-cad = NO THEN DO:

              FIND ITEM WHERE ITEM.it-codigo = tt-dados.it-codigo NO-LOCK NO-ERROR.

              if not avail item
              then do:
                  CREATE tt-log-ord-prod.
                  ASSIGN tt-log-ord-prod.cod-estab = tt-dados.cod-estabel
                         tt-log-ord-prod.ordem-aps = tt-dados.ordem-aps
                         tt-log-ord-prod.it-codigo = tt-dados.it-codigo
                         tt-log-ord-prod.qtde      = tt-dados.quantidade
                         tt-log-ord-prod.acao      = "Criacao"
                         tt-log-ord-prod.cStatus   = "Erro! Item nao cadastrado no EMS".
                   next.
              end.
          
              FIND item-uni-estab WHERE
                   item-uni-estab.cod-estabel = tt-dados.cod-estabel AND
                   item-uni-estab.it-codigo   = tt-dados.it-codigo
                   NO-LOCK NO-ERROR.

              if  avail item-uni-estab
              and item-uni-estab.cod-obsoleto = 1
              then.
              else do:
                   CREATE tt-log-ord-prod.
                   ASSIGN tt-log-ord-prod.cod-estab = tt-dados.cod-estabel
                          tt-log-ord-prod.ordem-aps = tt-dados.ordem-aps
                          tt-log-ord-prod.it-codigo = tt-dados.it-codigo
                          tt-log-ord-prod.qtde      = tt-dados.quantidade
                          tt-log-ord-prod.acao      = "Criacao".
                   if avail item-uni-estab
                   then do:
                        assign tt-log-ord-prod.cStatus = "Erro! Item x Estabelecimento esta " + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).

                        for first int-item fields(motivo-situacao) no-lock
                            where int-item.it-codigo       = item-uni-estab.it-codigo                               
                              and int-item.motivo-situacao > 0
                              and int-item.motivo-situacao < 3:
                            assign tt-log-ord-prod.cStatus = tt-log-ord-prod.cStatus 
                                                           + " - "
                                                           + entry(int-item.motivo-situacao,c-motivo).
                        end. /* for first int-item */
                   end.
                   else assign tt-log-ord-prod.cStatus = "Erro! Item x Estabelecimento nao cadastrado no EMS".
                   next.   
              end.

              IF NOT CAN-FIND(FIRST operacao
                              WHERE operacao.it-codigo     = tt-dados.it-codigo
                              AND   operacao.data-inicio  <= TODAY
                              AND   operacao.data-termino >= TODAY)
              then do:
                  CREATE tt-log-ord-prod.
                  ASSIGN tt-log-ord-prod.cod-estab = tt-dados.cod-estabel
                         tt-log-ord-prod.ordem-aps = tt-dados.ordem-aps
                         tt-log-ord-prod.it-codigo = tt-dados.it-codigo
                         tt-log-ord-prod.qtde      = tt-dados.quantidade
                         tt-log-ord-prod.acao      = "Criacao"
                         tt-log-ord-prod.cStatus   = "Erro! Nao cadastrada Operacao para o Item no EMS".
                   next.
              end.


              FIND int-ord-prod-aps WHERE ROWID(int-ord-prod-aps) = tt-dados.row-tabela NO-ERROR.

              /*--- INCLUI ---*/         
              EMPTY TEMP-TABLE tt-ord-prod.
              EMPTY TEMP-TABLE tt-erro.
    
              i-prox-ordem = ?.
    
              FIND LAST ord-prod 
                  WHERE ord-prod.nr-ord-prod >= param-cp.prox-ord-aut
                    AND ord-prod.nr-ord-prod <= param-cp.ult-ord-aut-cp NO-LOCK NO-ERROR.
    
              i-prox-ordem = IF AVAIL ord-prod THEN ord-prod.nr-ord-prod + 1 ELSE param-cp.prox-ord-aut.
    
              i-acomp-aux = i-acomp-aux + 1.
    
              RUN pi-acompanhar IN h-acomp (INPUT SUBSTITUTE("Criando ORDEM APS: &1... (" + STRING(( i-acomp-aux * 100 ) / i-acomp, ">>9" ) + "%) ", tt-dados.ordem-aps)).
              
              CREATE tt-ord-prod.
              ASSIGN tt-ord-prod.ind-tipo-movto        = 1 /* incluir */
                     tt-ord-prod.seg-usuario           = c-seg-usuario
                     tt-ord-prod.nr-ord-prod           = i-prox-ordem
                     tt-ord-prod.faixa-numeracao       = 2 /* automatica */
                     tt-ord-prod.cod-versao-integracao = 3
                     tt-ord-prod.it-codigo             = tt-dados.it-codigo
                     tt-ord-prod.qt-ordem              = tt-dados.quantidade
                     tt-ord-prod.dt-inicio             = tt-dados.data-inicial //fnBuscaDataInicioOP(tt-dados.data-inicial)
                     tt-ord-prod.dt-termino            = tt-dados.data-entrega //fnBuscaDataTerminoOp(tt-dados.data-final)
                     tt-ord-prod.nr-linha              = tt-dados.nr-linha
                     tt-ord-prod.narrativa             = "ORDEM: " + STRING(i-prox-ordem)
                     tt-ord-prod.cod-estabel           = tt-dados.cod-estabel
                     tt-ord-prod.conta-ordem           = IF AVAIL param-cp THEN param-cp.conta-ordem ELSE ''
                     tt-ord-prod.ct-codigo             = IF AVAIL param-cp THEN param-cp.ct-ordem ELSE ''
                     tt-ord-prod.sc-codigo             = IF AVAIL param-cp THEN param-cp.sc-ordem ELSE ''
                     tt-ord-prod.rep-prod              = IF AVAIL item-uni-estab THEN item-uni-estab.rep-prod ELSE
                                                         IF AVAIL ITEM           THEN ITEM.rep-prod           ELSE 3
                     tt-ord-prod.sit-aloc              = 1
                     tt-ord-prod.un                    = IF AVAIL ITEM THEN ITEM.un ELSE ''
                     tt-ord-prod.cd-planejado          = IF AVAIL item-uni-estab THEN item-uni-estab.cd-planejado ELSE 
                                                         IF AVAIL ITEM           THEN ITEM.cd-planejado           ELSE ''
                     tt-ord-prod.estado                = 1 /* nao iniciada */
                     tt-ord-prod.cod-depos             = IF AVAIL item-uni-estab THEN item-uni-estab.deposito-pad ELSE 
                                                         IF AVAIL ITEM           THEN ITEM.deposito-pad           ELSE ''
                     tt-ord-prod.dt-emissao            = tt-dados.data-emissao
                     tt-ord-prod.lote-serie            = ''
                     tt-ord-prod.dt-orig               = tt-dados.data-entrega
                     tt-ord-prod.emite-requis          = TRUE
                     tt-ord-prod.emite-ordem           = TRUE   
                     tt-ord-prod.reporte-mob           = 2
                     tt-ord-prod.cons-mrp              = TRUE
                     tt-ord-prod.cons-pmp              = TRUE
                     tt-ord-prod.calc-cs-mat           = IF AVAIL param-cs THEN param-cs.calc-cs-mat ELSE 1 /* proporcinal */
                     tt-ord-prod.calc-cs-mob           = IF AVAIL param-cs THEN param-cs.calc-cs-mob ELSE 2 /* total */
                     tt-ord-prod.calc-cs-ggf           = IF AVAIL param-cs THEN param-cs.calc-cs-ggf ELSE 2 /* total */
                     tt-ord-prod.reporte-ggf           = 2
                     tt-ord-prod.nr-estrut             = 1
                     tt-ord-prod.gera-relacionamentos  = TRUE                     
                     tt-ord-prod.tipo                  = 1 /* Interna */
                         .

              if can-find(first operacao where
                                operacao.it-codigo     = tt-dados.it-codigo
                            and operacao.tipo-oper     = 2 /* Externa */
                            and operacao.data-inicio  <= today
                            and operacao.data-termino >= today
                                no-lock)
              then if not can-find(first operacao where
                                         operacao.it-codigo     = tt-dados.it-codigo
                                     and operacao.tipo-oper     = 1 /* Interna */
                                     and operacao.data-inicio  <= today
                                     and operacao.data-termino >= today
                                         no-lock)
                   then assign tt-ord-prod.tipo = 2. /* Externa */
                   else assign tt-ord-prod.tipo = 3. /* Interna/Externa */
    
              CREATE tt-log-ord-prod.
              ASSIGN tt-log-ord-prod.cod-estab        = tt-ord-prod.cod-estabel
                     tt-log-ord-prod.nr-ord-prod      = tt-ord-prod.nr-ord-prod
                     tt-log-ord-prod.it-codigo        = tt-ord-prod.it-codigo
                     tt-log-ord-prod.dt-inicio        = tt-ord-prod.dt-inicio 
                     tt-log-ord-prod.dt-termino       = tt-ord-prod.dt-termino
                     tt-log-ord-prod.qtde             = tt-ord-prod.qt-ordem
                     tt-log-ord-prod.acao             = "Criacao".
    
              /*--- execucao da API -----*/
              Run cpp/cpapi301.p (input-output table tt-ord-prod,
                                  Input-output table tt-reapro,
                                  Input-output table tt-erro,
                                  Input YES).
    
              c-erro = fnErro().

              assign int-ord-prod-aps.usuar-integr-out = c-seg-usuario
                     int-ord-prod-aps.dt-integr-out    = now.
       
              IF c-erro <> '' then do:
                 ASSIGN tt-log-ord-prod.nr-ord-prod = 0
                        tt-log-ord-prod.cStatus     = c-erro.

                 create tt-dados-aux.
                 assign tt-dados-aux.row-tabela = tt-dados.row-tabela
                        tt-dados-aux.mensagem   = tt-log-ord-prod.cStatus.
                 find current tt-dados-aux no-error.
              end.
              ELSE DO:
                 ASSIGN tt-log-ord-prod.cStatus = "OK".
    
                 FIND FIRST tt-ord-prod NO-LOCK NO-ERROR.
    
                 /*--- atualiza parametro de producao ---*/
                 FIND FIRST bf-param-cp EXCLUSIVE-LOCK NO-ERROR.
    
                 IF AVAIL bf-param-cp THEN
                    bf-param-cp.prox-ord-aut = tt-ord-prod.nr-ord-prod + 1.
    
                 IF AVAIL int-ord-prod-aps THEN 
                     ASSIGN int-ord-prod-aps.nr-ord-prod   = tt-ord-prod.nr-ord-prod
                            int-ord-prod-aps.log-integrado = YES
                            tt-log-ord-prod.ordem-aps      = int-ord-prod-aps.cod-ordem-aps.
    
              END.
          END.
          ELSE DO:

/*               MESSAGE "Deseja eliminar o registro selecionado? "                               */
/*                   VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lElimina AS LOGICAL. */
/*                                                                                                */
/*               IF lElimina THEN DO:                                                             */
                  FIND int-ord-prod-aps WHERE ROWID(int-ord-prod-aps) = tt-dados.row-tabela NO-ERROR.
              
                  ASSIGN int-ord-prod-aps.cod-ordem-aps    = tt-dados.ordem-aps
                         int-ord-prod-aps.log-eliminado    = YES
                         int-ord-prod-aps.log-integrado    = NO
                         int-ord-prod-aps.usuar-integr-out = c-seg-usuario
                         int-ord-prod-aps.dt-integr-out    = now.
    
                  CREATE tt-log-ord-prod.
                  ASSIGN tt-log-ord-prod.cod-estab = int-ord-prod-aps.cod-estab
                         tt-log-ord-prod.ordem-aps = int-ord-prod-aps.cod-ordem-aps
                         tt-log-ord-prod.it-codigo = int-ord-prod-aps.it-codigo
                         tt-log-ord-prod.qtde      = int-ord-prod-aps.qt-ord-prod
                         tt-log-ord-prod.acao      = "Eliminado pelo usuario".
/*               END.                                              */
/*               ELSE DO:                                          */
/*                   MESSAGE "Registro n∆o foi eliminado."         */
/*                       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
/*                   LEAVE leitura.                                */
/*               END.                                              */
          END.
      END.
      
      /* gerando log */
      Assign c-sistema      = "INTEGRACAO"
             c-titulo-relat = "GERACAO ORDENS PRODUCAO"
             c-empresa      = param-global.grupo
             c-programa     = "ESCCP052"
             c-versao       = "2.08.00."
             c-revisao      = "001".

      assign c-rodape-aux = "DATASUL EMS 2.04 - " 
                          + c-sistema 
                          + " - " 
                          + c-programa 
                          + " - V:" 
                          + c-versao
                          + "."
                          + c-revisao
             c-rodape-aux = fill("-", 215 - length(c-rodape-aux)) + c-rodape-aux.
   
      /* Log de divergencias */
      OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "esccp052-geracao-OP.txt") PAGE-SIZE 64 no-convert.
   
         VIEW FRAME f-cabecalho.
         VIEW FRAME f-rodape1.
   
         FOR EACH tt-log-ord-prod NO-LOCK:

             DISP tt-log-ord-prod.cod-estab                             COLUMN-LABEL "Estab"
                  tt-log-ord-prod.nr-ord-prod FORMAT "zzz,zzz,zz9"      COLUMN-LABEL "Ordem"
                  tt-log-ord-prod.ordem-aps   FORMAT "x(15)"            COLUMN-LABEL "Ordem APS"
                  tt-log-ord-prod.it-codigo   FORMAT "x(16)"            COLUMN-LABEL "Item"
                  tt-log-ord-prod.dt-inicio   FORMAT "99/99/9999"       COLUMN-LABEL "Dt Inicio"
                  tt-log-ord-prod.dt-termino  FORMAT "99/99/9999"       COLUMN-LABEL "Dt Termino"
                  tt-log-ord-prod.qtde        FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Qtde"
                  tt-log-ord-prod.acao        FORMAT "x(30)"            COLUMN-LABEL "Acao"
                  tt-log-ord-prod.cStatus     FORMAT "x(75)"            COLUMN-LABEL "Status"
             WITH STREAM-IO WIDTH 215.

         END.

      OUTPUT CLOSE.

      RUN pi-finalizar IN h-acomp.

      DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "esccp052-geracao-OP.txt").
      
   END. /*--- i-opcao = 1 ---*/

   ELSE 
   IF i-opcao = 2 THEN
   DO:
/*       RUN pi-muda-browse(INPUT 2). */
      RUN pi-atualiza-compras.
   END.

   ELSE 
   IF i-opcao = 3 THEN
   DO:
/*       RUN pi-muda-browse(INPUT 3). */
      RUN pi-atualiza-op.
   END.

   ELSE 
   IF i-opcao = 4 THEN
   DO:
/*       RUN pi-muda-browse(INPUT 4). */
      RUN pi-atualiza-oc.
   END.

   RUN pi-gera-tabela-temporaria.

   OPEN QUERY brDados FOR EACH tt-dados WHERE tt-dados.log-integrado = NO AND tt-dados.log-eliminado = NO AND tt-dados.log-inexistente = NO.
   ASSIGN dTotalReg = 0
          dTotalRegSel = 0.
   FOR EACH tt-dados
      WHERE tt-dados.log-integrado = NO 
        AND tt-dados.log-eliminado = NO:
       ASSIGN dTotalReg = dTotalReg + 1.
   END.
   FOR EACH tt-dados
      WHERE tt-dados.marcado = TRUE
        AND tt-dados.log-integrado = NO 
        AND tt-dados.log-eliminado = NO:
       ASSIGN dTotalRegSel = dTotalRegSel + 1.
   END.
   ASSIGN dTotalReg:SCREEN-VALUE IN FRAME f-cad = STRING(dTotalReg)
          dTotalRegSel:SCREEN-VALUE IN FRAME f-cad = STRING(dTotalRegSel).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca w-livre
ON CHOOSE OF bt-desmarca IN FRAME f-cad /* Desmarca */
DO:
   IF AVAIL tt-dados THEN
   DO:
      IF INPUT i-opcao = 1 THEN
      DO:
          RUN pi-muda-browse(INPUT 1).

          IF tt-dados.marcado = TRUE THEN
             FOR EACH b-tt-dados:
                ASSIGN b-tt-dados.marcado = FALSE.
             END.
          
          IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 2 THEN
      DO:
         RUN pi-muda-browse(INPUT 2).

         IF tt-dados.marcado = TRUE THEN
         DO:
             FOR EACH b-tt-dados:
                ASSIGN b-tt-dados.marcado = FALSE.
             END.
         END.
         
         IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 3 THEN
      DO:
         RUN pi-muda-browse(INPUT 3).

         IF tt-dados.marcado = TRUE THEN
         DO:
             FOR EACH b-tt-dados:
                ASSIGN b-tt-dados.marcado = FALSE.
             END.
         END.
         
         IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 4 THEN
      DO:
         RUN pi-muda-browse(INPUT 4).

         IF tt-dados.marcado = TRUE THEN
         DO:
             FOR EACH b-tt-dados:
                ASSIGN b-tt-dados.marcado = FALSE.
             END.
         END.
         
         IF brDados:REFRESH() THEN.
      END.
   END.

   FOR EACH b-tt-dados:
      ASSIGN b-tt-dados.marcado = FALSE.
   END.

   IF brDados:REFRESH() THEN.

   ASSIGN dTotalRegSel:SCREEN-VALUE IN FRAME f-cad = '0'
          bt-desmarca:SENSITIVE in frame f-cad = can-find(first tt-dados where
                                                 tt-dados.marcado = true)
          bt-confirma:sensitive in frame f-cad = bt-desmarca:sensitive in frame f-cad
          bt-marca:sensitive in frame f-cad = can-find(first tt-dados where
                                              tt-dados.marcado = false).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca w-livre
ON CHOOSE OF bt-marca IN FRAME f-cad /* Marca */
DO:
   IF AVAIL tt-dados THEN
   DO:
      IF INPUT i-opcao = 1 THEN
      DO:
          RUN pi-muda-browse(INPUT 1).

          IF tt-dados.marcado = FALSE THEN
             FOR EACH b-tt-dados:
             
                 if l-elimina:checked in frame f-cad = no
                 then do:
                     FIND item-uni-estab WHERE
                          item-uni-estab.cod-estabel = b-tt-dados.cod-estabel AND
                          item-uni-estab.it-codigo   = b-tt-dados.it-codigo
                          NO-LOCK NO-ERROR.
    
                      IF NOT AVAIL item-uni-estab THEN
                          NEXT.
    
                      IF item-uni-estab.cd-planejado = "" THEN
                         NEXT.
    
                      if item-uni-estab.cod-obsoleto > 1 then
                          next.
    
                      IF NOT CAN-FIND(FIRST operacao
                                      WHERE operacao.it-codigo     = b-tt-dados.it-codigo
                                      AND   operacao.data-inicio  <= TODAY
                                      AND   operacao.data-termino >= TODAY) THEN
                         NEXT.
                 end.
             
                 ASSIGN b-tt-dados.marcado = TRUE.
             END.

          IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 2 THEN
      DO:
         RUN pi-muda-browse(INPUT 2).

         IF tt-dados.marcado = FALSE THEN
         DO:
             FOR EACH b-tt-dados:
               if l-elimina:checked in frame f-cad = no
               then do:
                   FIND ITEM WHERE
                        ITEM.it-codigo = b-tt-dados.it-codigo
                        NO-LOCK NO-ERROR.
                   IF NOT AVAIL ITEM THEN
                      NEXT.
    
                   find item-uni-estab WHERE
                       item-uni-estab.cod-estabel = b-tt-dados.cod-estabel AND
                       item-uni-estab.it-codigo   = b-tt-dados.it-codigo
                       NO-LOCK NO-ERROR.
    
                   IF NOT AVAIL item-uni-estab THEN
                       NEXT.
    
                   if item-uni-estab.cod-obsoleto > 1 then
                       next.
               end.

               ASSIGN b-tt-dados.marcado = TRUE.
            END.
         END.

         IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 3 THEN
      DO:
         RUN pi-muda-browse(INPUT 3).

         IF tt-dados.marcado = FALSE THEN
         DO:
             FOR EACH b-tt-dados:
               if l-elimina:checked in frame f-cad = no
               and CAN-FIND(FIRST ord-prod where
                                  ord-prod.nr-ord-produ = b-tt-dados.numero
                              and ord-prod.estado       > 6
                              and ord-prod.estado      <= 8
                                  no-lock)
               then next.

               ASSIGN b-tt-dados.marcado = TRUE.
            END.
         END.

         IF brDados:REFRESH() THEN.
      END.
      ELSE
      IF INPUT i-opcao = 4 THEN
      DO:
         RUN pi-muda-browse(INPUT 4).

         IF tt-dados.marcado = FALSE THEN
         DO:
             FOR EACH b-tt-dados:
               if  l-elimina:checked in frame f-cad = no
               and CAN-FIND(FIRST prazo-compra WHERE 
                                  prazo-compra.numero-ordem = b-tt-dados.numero
                              AND prazo-compra.parcela      = b-tt-dados.parcela
                              and prazo-compra.situacao     > 3
                              and prazo-compra.situacao    <= 6
                              and prazo-compra.situacao    <> 5
                                  no-lock) 
               then next.          

               ASSIGN b-tt-dados.marcado = TRUE.
             END.
         END.
         IF brDados:REFRESH() THEN.
      END.
   END.

   ASSIGN dTotalRegSel = 0.
   FOR EACH tt-dados
      WHERE tt-dados.marcado = TRUE.
       ASSIGN dTotalRegSel = dTotalRegSel + 1.
   END.
   ASSIGN dTotalRegSel:SCREEN-VALUE IN FRAME f-cad = STRING(dTotalRegSel)
          bt-desmarca:SENSITIVE in frame f-cad = can-find(first tt-dados where
                                                 tt-dados.marcado = true)
          bt-confirma:sensitive in frame f-cad = bt-desmarca:sensitive in frame f-cad
          bt-marca:sensitive in frame f-cad = can-find(first tt-dados where
                                              tt-dados.marcado = false).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImporta w-livre
ON CHOOSE OF btImporta IN FRAME f-cad
DO:
    assign i-aux = 0.

    RUN esp/ccp/esccp052e.w (INPUT-OUTPUT tg-ord-prod,
                             INPUT-OUTPUT tg-ordem-compra, 
                             INPUT-OUTPUT tg-up-ord-prod, 
                             INPUT-OUTPUT tg-up-ordem-compra,
                             OUTPUT       l-ok           ).

   IF l-ok 
   then DO:
        if tg-ordem-compra
        then RUN esapi\esapi034.p.

        if tg-ord-prod
        then RUN esapi\esapi035.p.

        if  tg-up-ord-prod
        and tg-up-ordem-compra
        then assign i-aux = 3. /* Ambos updates */
        else if tg-up-ord-prod
             then assign i-aux = 1. /* Somente update OP */
             else if tg-up-ordem-compra
                  then assign i-aux = 2. /* Somente update OC */
            
        if i-aux > 0
        then RUN esapi\esapi037.p (input i-aux).

        IF RETURN-VALUE = "OK" THEN DO:
            if tg-ordem-compra
            then DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "dados-oc-aps.txt").

            if tg-ord-prod
            then DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "dados-op-aps.txt").

            if i-aux > 0
            then do:
                 if i-aux <> 1
                 then DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "atualizacao-oc-aps.txt").

                 if i-aux <> 2
                 then DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "atualizacao-op-aps.txt").
            end.


        END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelec w-livre
ON CHOOSE OF btSelec IN FRAME f-cad
DO:
   IF INPUT i-opcao = 1 THEN
   DO:
      RUN pi-muda-browse(INPUT 1).

      RUN esp/ccp/esccp052a.w (INPUT-OUTPUT c-estabel-ini  ,
                               INPUT-OUTPUT c-estabel-fim  , 
                               INPUT-OUTPUT c-ordem-ini    , 
                               INPUT-OUTPUT c-ordem-fim    , 
                               INPUT-OUTPUT d-emissao-ini  ,
                               INPUT-OUTPUT d-emissao-fim  ,
                               INPUT-OUTPUT d-inicio-ini   ,
                               INPUT-OUTPUT d-inicio-fim   ,
                               INPUT-OUTPUT dt-termino-ini ,
                               INPUT-OUTPUT dt-termino-fim ,
                               INPUT-OUTPUT c-item-ini     ,
                               INPUT-OUTPUT c-item-fim     ,
                               OUTPUT       l-ok           ).
      
   END.
   ELSE
   IF INPUT i-opcao = 2 THEN
   DO:
       RUN pi-muda-browse(INPUT 2).

      RUN esp/ccp/esccp052b.w (INPUT-OUTPUT c-estabel-ini  ,
                               INPUT-OUTPUT c-estabel-fim  , 
                               INPUT-OUTPUT c-ordem-ini    , 
                               INPUT-OUTPUT c-ordem-fim    , 
                               INPUT-OUTPUT dt-entrega-ini ,
                               INPUT-OUTPUT dt-entrega-fim , 
                               INPUT-OUTPUT dt-neces-ini   ,
                               INPUT-OUTPUT dt-neces-fim   , 
                               INPUT-OUTPUT d-emissao-ini  ,
                               INPUT-OUTPUT d-emissao-fim  ,
                               INPUT-OUTPUT c-item-ini     ,
                               INPUT-OUTPUT c-item-fim     ,
                               OUTPUT       l-ok           ).
   END.
   ELSE
   IF INPUT i-opcao = 3 THEN
   DO:
      RUN pi-muda-browse(INPUT 3).

      RUN esp/ccp/esccp052c.w (INPUT-OUTPUT c-estabel-ini  ,
                               INPUT-OUTPUT c-estabel-fim  , 
                               INPUT-OUTPUT i-ordem-ini    , 
                               INPUT-OUTPUT i-ordem-fim    , 
                               INPUT-OUTPUT dt-entrega-ini ,
                               INPUT-OUTPUT dt-entrega-fim , 
                               INPUT-OUTPUT dt-termino-ini ,
                               INPUT-OUTPUT dt-termino-fim ,
                               INPUT-OUTPUT c-item-ini     ,
                               INPUT-OUTPUT c-item-fim     ,
                               OUTPUT       l-ok           ).
   END.
   ELSE
   IF INPUT i-opcao = 4 THEN
   DO:
      RUN pi-muda-browse(INPUT 4).

      RUN esp/ccp/esccp052d.w (INPUT-OUTPUT c-estabel-ini  ,
                               INPUT-OUTPUT c-estabel-fim  ,
                               INPUT-OUTPUT i-ordem-ini    , 
                               INPUT-OUTPUT i-ordem-fim    , 
                               INPUT-OUTPUT dt-neces-ini   ,
                               INPUT-OUTPUT dt-neces-fim   ,
                               INPUT-OUTPUT c-item-ini     ,
                               INPUT-OUTPUT c-item-fim     ,
                               OUTPUT       l-ok           ).
   END.
   
   IF l-ok THEN
   DO:
      empty temp-table tt-dados-aux.
      ASSIGN i-opcao.
      RUN pi-gera-tabela-temporaria.
      OPEN QUERY brDados FOR EACH tt-dados WHERE tt-dados.log-integrado = NO AND tt-dados.log-eliminado = NO AND tt-dados.log-inexistente = NO.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-opcao w-livre
ON VALUE-CHANGED OF i-opcao IN FRAME f-cad
DO:
   ASSIGN dTotalReg:SCREEN-VALUE    IN FRAME f-cad = '0'
          dTotalRegSel:SCREEN-VALUE IN FRAME f-cad = '0'.

   FOR EACH tt-dados
      WHERE tt-dados.marcado = YES.
       ASSIGN tt-dados.marcado = NO
              /*bt-marca:SENSITIVE = YES*/
           .
   END.

   ASSIGN dt-entrega-ini  = 01/01/2000 
          dt-entrega-fim  = 12/31/2999
          dt-termino-ini  = 01/01/2000  
          dt-termino-fim  = 12/31/2999 
          c-estabel-ini   = ""
          c-estabel-fim   = "ZZZZZ"
          c-unid-neg-ini  = ""
          c-unid-neg-fim  = "ZZZ"
          c-ordem-ini     = ""
          c-ordem-fim     = "ZZZZZZZZZZZZZZZ"
          i-ordem-ini     = 0
          i-ordem-fim     = 99999999
          i-grupo-ini     = 0
          i-grupo-fim     = 99
          c-pedido-ini    = ""
          c-pedido-fim    = "ZZZZZZZZZZZZZZZ"
          c-fm-codigo-ini = ''
          c-fm-codigo-fim = 'ZZZZZZZZ'
          c-item-ini      = ''
          c-item-fim      = 'ZZZZZZZZZZZZZZZZ'
          dt-libera-ini   = 01/01/2000 
          dt-libera-fim   = 12/31/2999 
          d-emissao-ini   = 01/01/2000  
          d-emissao-fim   = 12/31/2999  
          d-inicio-ini    = 01/01/2000   
          d-inicio-fim    = 12/31/2999 
          dt-neces-ini    = 01/01/2000   
          dt-neces-fim    = 12/31/2999
          dt-neces-ini-a  = 01/01/2000   
          dt-neces-fim-a  = 12/31/2999.

   assign bt-confirma:sensitive in frame f-cad = no
          bt-marca:sensitive    in frame f-cad = no
          bt-desmarca:sensitive in frame f-cad = no
          tg-split:sensitive    in frame f-cad = input frame f-cad i-opcao = 2 and
                                                 not l-elimina:checked in frame f-cad
          tg-split:checked      in frame f-cad = no.

   if tg-split:sensitive in frame f-cad
   then assign tg-split:checked in frame f-cad = tg-split.

   CLOSE QUERY brDados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-elimina w-livre
ON VALUE-CHANGED OF l-elimina IN FRAME f-cad /* Elimina Ordem Selecionada */
DO:
  if  self:checked = no
  and bt-desmarca:sensitive in frame f-cad
  then apply 'choose' to bt-desmarca in frame f-cad.

  assign tg-split:sensitive in frame f-cad = input frame f-cad i-opcao = 2 and
                                             not l-elimina:checked in frame f-cad
         tg-split:checked   in frame f-cad = no.

   if tg-split:sensitive in frame f-cad
   then assign tg-split:checked in frame f-cad = tg-split.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* esccp052 */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-split
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-split w-livre
ON VALUE-CHANGED OF tg-split IN FRAME f-cad /* Div. OC Forn. */
DO:
  assign tg-split = tg-split:checked in frame f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

RUN pi-muda-browse(INPUT 1).

FIND FIRST param-cp NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 126.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             btImporta:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY i-opcao l-elimina tg-split dTotalReg dTotalRegSel 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE RECT-1 RECT-2 rt-button btSelec btImporta i-opcao l-elimina brDados 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN dt-entrega-ini = 01/01/2000 
         dt-entrega-fim = 12/31/2999
         dt-termino-ini = 01/01/2000  
         dt-termino-fim = 12/31/2999 
         c-estabel-ini  = ""
         c-estabel-fim  = "ZZZZZ"
         c-unid-neg-ini = ""
         c-unid-neg-fim = "ZZZ"
         c-ordem-ini    = ""
         c-ordem-fim    = "ZZZZZZZZZZZZZZZ"
         i-ordem-ini    = 0
         i-ordem-fim    = 99999999
         i-grupo-ini    = 0
         i-grupo-fim    = 99
         c-pedido-ini   = ""
         c-pedido-fim   = "ZZZZZZZZZZZZZZZ"
         c-fm-codigo-ini = ''
         c-fm-codigo-fim = 'ZZZZZZZZ'
         c-item-ini      = ''
         c-item-fim      = 'ZZZZZZZZZZZZZZZZ'
         dt-libera-ini   = 01/01/2000 
         dt-libera-fim   = 12/31/2999 
         d-emissao-ini   = 01/01/2000  
         d-emissao-fim   = 12/31/2999  
         d-inicio-ini    = 01/01/2000   
         d-inicio-fim    = 12/31/2999 
         dt-neces-ini    = 01/01/2000   
         dt-neces-fim    = 12/31/2999
         dt-neces-ini-a  = 01/01/2000   
         dt-neces-fim-a  = 12/31/2999.  

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "ESCCP052" "2.04.00.006"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.

  assign tg-split = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-compras w-livre 
PROCEDURE pi-atualiza-compras :
/*------------------------------------------------------------------------------
  Purpose: Atualizaá∆o da programaá∆o de compras
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-seq-aux as inte no-undo.
def var i-seq-aps as inte no-undo.

EMPTY TEMP-TABLE tt-versao-integr.
EMPTY TEMP-TABLE tt-ordem-compra.
EMPTY TEMP-TABLE tt-prazo-compra.
EMPTY TEMP-TABLE tt-log-ordem-compra.

FIND FIRST param-compra NO-LOCK NO-ERROR.
DEF VAR i-ord-aux LIKE ordem-compra.numero-ordem.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Acompanhamento..."). 

EMPTY TEMP-TABLE tt-erro-aux.

leitura:
FOR EACH tt-dados WHERE tt-dados.marcado = TRUE:

    assign i-seq-aux = i-seq-aux + 1.

    DO TRANSACTION:

        IF l-elimina:CHECKED IN FRAME f-cad = NO THEN DO:

            EMPTY TEMP-TABLE tt-versao-integr.
            EMPTY TEMP-TABLE tt-ordem-compra.
            EMPTY TEMP-TABLE tt-prazo-compra.
            EMPTY TEMP-TABLE tt-cotacao-item.
            EMPTY TEMP-TABLE tt-erros-geral.

            FIND ITEM WHERE ITEM.it-codigo = tt-dados.it-codigo NO-LOCK NO-ERROR.           

            if not avail item
            then do:
                  CREATE tt-log-ordem-compra.
                  ASSIGN tt-log-ordem-compra.seq       = i-seq-aux
                         tt-log-ordem-compra.cod-estab = tt-dados.cod-estabel
                         tt-log-ordem-compra.ordem-aps = tt-dados.ordem-aps
                         tt-log-ordem-compra.it-codigo = tt-dados.it-codigo
                         tt-log-ordem-compra.qtde      = tt-dados.quantidade
                         tt-log-ordem-compra.acao      = "Criacao"
                         tt-log-ordem-compra.cStatus   = "Erro! Item nao cadastrado no EMS".
                  next.
            end.

            FIND FIRST item-uni-estab
                 WHERE item-uni-estab.it-codigo   = tt-dados.it-codigo
                   AND item-uni-estab.cod-estabel = tt-dados.cod-estabel NO-LOCK NO-ERROR.

            if  avail item-uni-estab
            and item-uni-estab.cod-obsoleto = 1
            then.
            else do:
                 CREATE tt-log-ordem-compra.
                 ASSIGN tt-log-ordem-compra.seq       = i-seq-aux
                        tt-log-ordem-compra.cod-estab = tt-dados.cod-estabel
                        tt-log-ordem-compra.ordem-aps = tt-dados.ordem-aps
                        tt-log-ordem-compra.it-codigo = tt-dados.it-codigo
                        tt-log-ordem-compra.qtde      = tt-dados.quantidade
                        tt-log-ordem-compra.acao      = "Criacao".
                 if avail item-uni-estab
                 then do:
                      assign tt-log-ordem-compra.cStatus = "Erro! Item x Estabelecimento esta " + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).

                      for first int-item fields(motivo-situacao) no-lock
                          where int-item.it-codigo       = item-uni-estab.it-codigo                               
                            and int-item.motivo-situacao > 0
                            and int-item.motivo-situacao < 3:
                          assign tt-log-ordem-compra.cStatus = tt-log-ordem-compra.cStatus 
                                                             + " - "
                                                             + entry(int-item.motivo-situacao,c-motivo).
                      end. /* for first int-item */
                 end.
                 else assign tt-log-ordem-compra.cStatus = "Erro! Item x Estabelecimento nao cadastrado no EMS".
                 next.   
            end.
            
            /* busca proxima numeracao de ordem disponivel */
            i-ord-aux = ?.
            
            DO i-ord-aux = param-compra.prox-ord-aut TO param-compra.ult-ord-man:
            
               IF NOT CAN-FIND(FIRST ordem-compra WHERE ordem-compra.numero-ordem = i-ord-aux) THEN
                  LEAVE.
                
            END.
            
            IF i-ord-aux = ? THEN
            DO:
               IF NOT CAN-FIND(FIRST tt-erro-aux
                               WHERE tt-erro-aux.des-erro = "Sem numeraá∆o dispon°vel para criaá∆o de OCs") THEN
               DO:
                  CREATE tt-erro-aux.
                  ASSIGN tt-erro-aux.cod-erro = 17006
                         tt-erro-aux.des-erro = "Sem numeraá∆o dispon°vel para criaá∆o de OCs".
               END.
            
               LEAVE.
            END.

            empty temp-table tt-ordem-esccp052.
            assign i-seq-aps = 0.
            
            CREATE tt-versao-integr.
            ASSIGN tt-versao-integr.cod-versao-integracao = 1.           
            
            i-acomp-aux = i-acomp-aux + 1.
            
            RUN pi-acompanhar IN h-acomp (INPUT SUBSTITUTE("Criando OC: &1... (" + STRING(( i-acomp-aux * 100 ) / i-acomp, ">>9" ) + "%) ", i-ord-aux)).
              
            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.it-codigo      = tt-dados.it-codigo
                   tt-ordem-compra.ind-tipo-movto = 1
                   tt-ordem-compra.origem         = 2
                   tt-ordem-compra.num-sequencia  = 0
                   tt-ordem-compra.numero-ordem   = i-ord-aux
                   tt-ordem-compra.qt-solic       = tt-dados.quantidade
                   tt-ordem-compra.cod-comprado   = item-uni-estab.cod-comprado
                   tt-ordem-compra.cod-estabel    = tt-dados.cod-estabel
                   tt-ordem-compra.tp-despesa     = item-uni-estab.tp-desp-padrao
                   tt-ordem-compra.requisitante   = c-seg-usuario
                   tt-ordem-compra.dep-almoxar    = IF AVAIL item-uni-estab THEN item-uni-estab.deposito-pad ELSE 
                                                    IF AVAIL ITEM           THEN ITEM.deposito-pad           ELSE ''
                   tt-ordem-compra.l-split        = tg-split:checked in frame f-cad.
            
            CREATE tt-prazo-compra.
            ASSIGN tt-prazo-compra.numero-ordem    = tt-ordem-compra.numero-ordem
                   tt-prazo-compra.it-codigo       = tt-ordem-compra.it-codigo
                   tt-prazo-compra.num-sequencia   = 0
                   tt-prazo-compra.ind-tipo-movto  = 1
                   tt-prazo-compra.un              = ITEM.un
                   tt-prazo-compra.quantid-orig    = tt-dados.quantidade
                   tt-prazo-compra.quantidade      = tt-prazo-compra.quantid-orig
                   tt-prazo-compra.data-entrega    = tt-dados.data-final //tt-dados.data-inicial
                   tt-prazo-compra.quant-saldo     = tt-prazo-compra.quantid-orig
                   tt-dados.numero                 = tt-ordem-compra.numero-ordem.

            if tt-ordem-compra.l-split
            then do:
                 create tt-ordem-esccp052.
                 assign tt-ordem-esccp052.numero-ordem = tt-ordem-compra.numero-ordem
                        tt-ordem-esccp052.it-codigo    = tt-ordem-compra.it-codigo
                        tt-ordem-esccp052.qt-solic     = tt-ordem-compra.qt-solic.
                 find current tt-ordem-esccp052 no-error.
                 release tt-ordem-esccp052.
            end. /* if tt-ordem-compra.l-split */
            
            /* garantindo que a data entrega seja dia util */
            IF tt-prazo-compra.data-entrega = ? THEN
               tt-prazo-compra.data-entrega = TODAY.
            
            FOR FIRST calen-data NO-LOCK USE-INDEX codigo
                WHERE calen-data.cd-calen = "cmp"
                  AND calen-data.data    >= tt-prazo-compra.data-entrega
                  AND calen-data.tipo-dia = 1 /* util */:
            
                ASSIGN tt-prazo-compra.data-entrega = calen-data.data.
            END.
            
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.seq            = i-seq-aux
                   tt-log-ordem-compra.cod-estab      = tt-ordem-compra.cod-estabel
                   tt-log-ordem-compra.nr-ord-comp    = tt-ordem-compra.numero-ordem
                   tt-log-ordem-compra.it-codigo      = tt-ordem-compra.it-codigo
                   tt-log-ordem-compra.qtde           = tt-ordem-compra.qt-solic
                   tt-log-ordem-compra.dt-entrega     = tt-prazo-compra.data-entrega
                   tt-log-ordem-compra.dt-necessidade = tt-dados.dt-necessidade
                   tt-log-ordem-compra.ordem-aps      = tt-dados.ordem-aps
                   tt-log-ordem-compra.acao           = "Criacao".
            
            RUN ccp/ccapi302.p (INPUT  TABLE tt-versao-integr,
                                OUTPUT TABLE tt-erros-geral,
                                INPUT  TABLE tt-ordem-compra,
                                INPUT  TABLE tt-prazo-compra,
                                INPUT  TABLE tt-cotacao-item,
                                &IF DEFINED(bf_mat_despesa_fase_II) &THEN
                                   INPUT TABLE tt-desp-cotacao-item,
                                &ENDIF
                                &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
                                   INPUT TABLE tt-matriz-rat-med,
                                &ENDIF
                                INPUT  "MAT002").

            FIND int-ord-comp-aps WHERE ROWID(int-ord-comp-aps) = tt-dados.row-tabela NO-ERROR.

            assign int-ord-comp-aps.usuar-integr-out = c-seg-usuario
                   int-ord-comp-aps.dt-integr-out    = now.
            
            FIND FIRST tt-erros-geral NO-LOCK NO-ERROR.
            
            IF AVAIL tt-erros-geral then do:
               ASSIGN tt-log-ordem-compra.nr-ord-comp = 0
                      tt-log-ordem-compra.cStatus     = string(tt-erros-geral.cod-erro) + ": " + tt-erros-geral.des-erro.

               create tt-dados-aux.
               assign tt-dados-aux.row-tabela = tt-dados.row-tabela
                      tt-dados-aux.mensagem   = tt-log-ordem-compra.cStatus.
               find current tt-dados-aux no-error.
            end.
            ELSE DO:               
               FIND FIRST bf-param-compra EXCLUSIVE-LOCK NO-ERROR.
            
               IF AVAIL bf-param-compra THEN
                  ASSIGN bf-param-compra.prox-ord-aut = tt-dados.numero + 1.
                
               ASSIGN int-ord-comp-aps.nr-ord-comp   = tt-dados.numero
                      int-ord-comp-aps.log-integrado = YES
                      tt-log-ordem-compra.cStatus    = "OK".

               for first int-prazo-compra
                   where int-prazo-compra.numero-ordem = tt-dados.numero
                         exclusive-lock: end.

               if not avail int-prazo-compra
               then for first prazo-compra no-lock
                        where prazo-compra.numero-ordem = tt-dados.numero:
                        create int-prazo-compra.
                        assign int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                               int-prazo-compra.parcela      = prazo-compra.parcela.
                    end. /* for first prazo-compra */

               if avail int-prazo-compra               
               then assign int-prazo-compra.data-necessidade = tt-dados.dt-necessidade.
               find current int-prazo-compra no-lock no-error.

               find tt-ordem-esccp052 where
                    tt-ordem-esccp052.it-codigo = tt-dados.it-codigo
                    no-error.

               if ambiguous tt-ordem-esccp052
               then for each tt-ordem-esccp052
                       where tt-ordem-esccp052.it-codigo = tt-dados.it-codigo:
                        assign i-seq-aps = i-seq-aps + 1.

                        create b-int-ord-comp-aps.
                        buffer-copy int-ord-comp-aps except nr-ord-comp 
                                                            qtd-ord-comp 
                                                            cod-ordem-aps to b-int-ord-comp-aps
                            assign b-int-ord-comp-aps.cod-ordem-aps = int-ord-comp-aps.cod-ordem-aps
                                                                    + "_"
                                                                    + string(i-seq-aps,"99")
                                   b-int-ord-comp-aps.nr-ord-comp   = tt-ordem-esccp052.numero-ordem
                                   b-int-ord-comp-aps.qtd-ord-comp  = tt-ordem-esccp052.qt-solic
                                   b-int-ord-comp-aps.log-integrado = yes.
                        find current b-int-ord-comp-aps no-lock no-error.

                        for first int-prazo-compra
                            where int-prazo-compra.numero-ordem = tt-ordem-esccp052.numero-ordem
                                  exclusive-lock: end.
            
                        if not avail int-prazo-compra
                        then for first prazo-compra no-lock
                                 where prazo-compra.numero-ordem = tt-ordem-esccp052.numero-ordem:
                                 create int-prazo-compra.
                                 assign int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                                        int-prazo-compra.parcela      = prazo-compra.parcela.
                             end. /* for first prazo-compra */
            
                        if avail int-prazo-compra
                        then assign int-prazo-compra.data-necessidade = tt-dados.dt-necessidade.
                        find current int-prazo-compra no-lock no-error.

                        if tt-ordem-esccp052.numero-ordem = tt-log-ordem-compra.nr-ord-comp 
                        then do:
                             assign tt-log-ordem-compra.qtde = tt-ordem-esccp052.qt-solic.
                             next.
                        end.

                        IF AVAIL bf-param-compra THEN
                           ASSIGN bf-param-compra.prox-ord-aut = bf-param-compra.prox-ord-aut + 1.
        
                        create b-tt-log-ordem-compra.
                        buffer-copy tt-log-ordem-compra to b-tt-log-ordem-compra
                            assign b-tt-log-ordem-compra.nr-ord-comp = tt-ordem-esccp052.numero-ordem
                                   b-tt-log-ordem-compra.qtde        = tt-ordem-esccp052.qt-solic.
                        find current b-tt-log-ordem-compra no-error.       
                    end. /* for each tt-ordem-esccp052 */
            END.
        END.
        ELSE DO:
/*             MESSAGE "Deseja eliminar o registro selecionado? "                                 */
/*                   VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lElimina AS LOGICAL. */
/*                                                                                                */
/*             IF lElimina THEN DO:                                                               */
                FIND int-ord-comp-aps WHERE ROWID(int-ord-comp-aps) = tt-dados.row-tabela NO-ERROR.
            
                ASSIGN int-ord-comp-aps.cod-ordem-aps    = tt-dados.ordem-aps
                       int-ord-comp-aps.log-eliminado    = YES
                       int-ord-comp-aps.log-integrado    = NO
                       int-ord-comp-aps.usuar-integr-out = c-seg-usuario
                       int-ord-comp-aps.dt-integr-out    = now.
    
                CREATE tt-log-ordem-compra.
                ASSIGN tt-log-ordem-compra.seq       = i-seq-aux
                       tt-log-ordem-compra.cod-estab = int-ord-comp-aps.cod-estab
                       tt-log-ordem-compra.ordem-aps = int-ord-comp-aps.cod-ordem-aps
                       tt-log-ordem-compra.it-codigo = int-ord-comp-aps.it-codigo
                       tt-log-ordem-compra.qtde      = int-ord-comp-aps.qtd-ord-comp
                       tt-log-ordem-compra.acao      = "Eliminado pelo usuario".
/*             END.                                              */
/*             ELSE DO:                                          */
/*                 MESSAGE "Registro n∆o foi eliminado."         */
/*                     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
/*                 LEAVE leitura.                                */
/*             END.                                              */
        END.

        empty temp-table tt-ordem-esccp052.
    END.
END.

/* gerando log */
Assign c-sistema      = "INTEGRACAO"
       c-titulo-relat = "GERACAO ORDENS COMPRA"
       c-empresa      = param-global.grupo
       c-programa     = "ESCCP052"
       c-versao       = "2.08.00."
       c-revisao      = "001".

assign c-rodape-aux = "DATASUL EMS 2.04 - " 
                    + c-sistema 
                    + " - " 
                    + c-programa 
                    + " - V:" 
                    + c-versao
                    + "."
                    + c-revisao
       c-rodape-aux = fill("-", 215 - length(c-rodape-aux)) + c-rodape-aux.

OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "esccp052-geracao-OC.txt") PAGE-SIZE 64 no-convert.

   VIEW FRAME f-cabecalho.
   VIEW FRAME f-rodape1.

   FOR EACH tt-log-ordem-compra NO-LOCK
            break by tt-log-ordem-compra.seq:

       if first-of(tt-log-ordem-compra.seq)
       then
           DISP tt-log-ordem-compra.cod-estab                                COLUMN-LABEL "Estab"
                tt-log-ordem-compra.nr-ord-comp                              COLUMN-LABEL "Ordem Compra"
                tt-log-ordem-compra.ordem-aps      FORMAT "x(15)"            COLUMN-LABEL "Ordem APS"
                tt-log-ordem-compra.it-codigo      FORMAT "x(16)"            COLUMN-LABEL "Item"
                tt-log-ordem-compra.qtde           FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Qtde"
                tt-log-ordem-compra.dt-entrega     FORMAT "99/99/9999"       COLUMN-LABEL "Dt Entrega"
                tt-log-ordem-compra.dt-necessidade format "99/99/9999"       column-label "Dt Necessidade"
                tt-log-ordem-compra.acao           FORMAT "x(30)"            COLUMN-LABEL "Acao"
                tt-log-ordem-compra.cStatus        FORMAT "x(80)"            COLUMN-LABEL "Status"
           WITH STREAM-IO WIDTH 215.
       else
           DISP tt-log-ordem-compra.nr-ord-comp                             COLUMN-LABEL "Ordem Compra"
                tt-log-ordem-compra.qtde          FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Qtde"
           WITH STREAM-IO WIDTH 215.

   END.
   
OUTPUT CLOSE.

run pi-finalizar in h-acomp.

DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "esccp052-geracao-OC.txt").

finally:
    empty temp-table tt-ordem-esccp052.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-oc w-livre 
PROCEDURE pi-atualiza-oc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

run utp/ut-acomp.p persistent set h-acomp. 
run pi-inicializar in h-acomp (input "Acompanhamento...").

EMPTY TEMP-TABLE tt-log-ordem-compra.

IF l-elimina:SCREEN-VALUE IN FRAME f-cad = "no" THEN DO:

    FOR EACH int-upd-compra-aps EXCLUSIVE-LOCK
       WHERE int-upd-compra-aps.log-atualizado  = NO
         AND int-upd-compra-aps.nr-ord-comp    >= i-ordem-ini
         AND int-upd-compra-aps.nr-ord-comp    <= i-ordem-fim
         AND int-upd-compra-aps.dt-necessidade >= dt-neces-ini
         AND int-upd-compra-aps.dt-necessidade <= dt-neces-fim
         AND int-upd-compra-aps.log-inexistente = NO:

        for FIRST tt-dados NO-LOCK
            WHERE tt-dados.numero    = int-upd-compra-aps.nr-ord-comp
              AND tt-dados.parcela   = int-upd-compra-aps.parcela
              and tt-dados.sequencia = int-upd-compra-aps.sequencia:

            if tt-dados.row-tabela <> ?
            then leave.

            ASSIGN int-upd-compra-aps.log-atualizado   = YES
                   int-upd-compra-aps.log-inexistente  = YES
                   int-upd-compra-aps.usuar-integr-out = c-seg-usuario
                   int-upd-compra-aps.dt-integr-out    = now.
            
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.nr-ord-comp    = int-upd-compra-aps.nr-ord-comp
                   tt-log-ordem-compra.parcela        = int-upd-compra-aps.parcela
                   tt-log-ordem-compra.sequencia      = int-upd-compra-aps.sequencia
                   tt-log-ordem-compra.dt-necessidade = int-upd-compra-aps.dt-necessidade
                   tt-log-ordem-compra.acao           = "Alteracao"
                   tt-log-ordem-compra.cStatus        = "Erro! Ordem ou parcela da ordem nao encontrada".
            
        END.

    END.
END.

leitura:
FOR EACH tt-dados 
   WHERE tt-dados.marcado = TRUE:

    IF l-elimina:SCREEN-VALUE IN FRAME f-cad = "no" THEN DO:

        if tt-dados.row-tabela = ?
        then next.

        for first ordem-compra fields(situacao)
            where ordem-compra.numero-ordem = tt-dados.numero
              and ordem-compra.situacao     > 3
              and ordem-compra.situacao     < 7
              and ordem-compra.situacao    <> 5
                  no-lock: end.

        if avail ordem-compra
        then do:
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.cod-estab   = tt-dados.cod-estabel
                   tt-log-ordem-compra.it-codigo   = tt-dados.it-codigo
                   tt-log-ordem-compra.nr-ord-comp = tt-dados.numero
                   tt-log-ordem-compra.parcela     = tt-dados.parcela
                   tt-log-ordem-compra.sequencia   = tt-dados.sequencia
                   tt-log-ordem-compra.acao        = "Alteracao".

            if ordem-compra.situacao = 4
            then assign tt-log-ordem-compra.cStatus = "Erro! Ordem Compra foi eliminada".
            else assign tt-log-ordem-compra.cStatus = "Erro! Ordem Compra j† recebida".
            next.
        end.

        for first prazo-compra fields(situacao)
            where prazo-compra.numero-ordem = tt-dados.numero
              and prazo-compra.parcela      = tt-dados.parcela
                  no-lock: end.

        if not avail prazo-compra
        then do:
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.cod-estab   = tt-dados.cod-estabel
                   tt-log-ordem-compra.it-codigo   = tt-dados.it-codigo
                   tt-log-ordem-compra.nr-ord-comp = tt-dados.numero
                   tt-log-ordem-compra.parcela     = tt-dados.parcela
                   tt-log-ordem-compra.sequencia   = tt-dados.sequencia
                   tt-log-ordem-compra.acao        = "Alteracao"
                   tt-log-ordem-compra.cStatus     = "Erro! Parcela inexistente no EMS".
            next.
        end.

        if  prazo-compra.situacao  > 3
        and prazo-compra.situacao  < 7
        and prazo-compra.situacao <> 5
        then do:
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.cod-estab   = tt-dados.cod-estabel
                   tt-log-ordem-compra.it-codigo   = tt-dados.it-codigo
                   tt-log-ordem-compra.nr-ord-comp = tt-dados.numero
                   tt-log-ordem-compra.parcela     = tt-dados.parcela
                   tt-log-ordem-compra.sequencia   = tt-dados.sequencia
                   tt-log-ordem-compra.acao        = "Alteracao".

            if prazo-compra.situacao = 4
            then assign tt-log-ordem-compra.cStatus = "Erro! Parcela da Ordem foi eliminada".
            else assign tt-log-ordem-compra.cStatus = "Erro! Parcela da Ordem j† recebida".
            next.
        end.

        FIND FIRST int-prazo-compra
             WHERE int-prazo-compra.numero-ordem = tt-dados.numero
               AND int-prazo-compra.parcela      = tt-dados.parcela EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL int-prazo-compra THEN
            ASSIGN int-prazo-compra.data-necessidade = tt-dados.dt-necessidade.
        ELSE DO:
            CREATE int-prazo-compra.
            ASSIGN int-prazo-compra.numero-ordem     = tt-dados.numero
                   int-prazo-compra.parcela          = tt-dados.parcela
                   int-prazo-compra.data-necessidade = tt-dados.dt-necessidade.
        END.
        
           /*--- atualiza tabela especifica ----*/
        FIND FIRST int-upd-compra-aps 
             WHERE int-upd-compra-aps.nr-ord-comp = tt-dados.numero 
               AND int-upd-compra-aps.parcela     = tt-dados.parcela
               and int-upd-compra-aps.sequencia   = tt-dados.sequencia EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL int-upd-compra-aps THEN 
            ASSIGN int-upd-compra-aps.log-atualizado   = YES
                   int-upd-compra-aps.usuar-integr-out = c-seg-usuario
                   int-upd-compra-aps.dt-integr-out    = now.
        
        CREATE tt-log-ordem-compra.
        ASSIGN tt-log-ordem-compra.cod-estab      = tt-dados.cod-estabel
               tt-log-ordem-compra.it-codigo      = tt-dados.it-codigo
               tt-log-ordem-compra.nr-ord-comp    = tt-dados.numero
               tt-log-ordem-compra.parcela        = tt-dados.parcela
               tt-log-ordem-compra.sequencia      = tt-dados.sequencia
               tt-log-ordem-compra.dt-necessidade = tt-dados.dt-necessidade
               tt-log-ordem-compra.acao           = "Alteracao".

    END.  
    ELSE DO:
/*         MESSAGE "Deseja eliminar o registro selecionado? "                                 */
/*               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lElimina AS LOGICAL. */
/*                                                                                            */
/*         IF lElimina THEN DO:                                                               */
            FIND int-upd-compra-aps WHERE ROWID(int-upd-compra-aps) = tt-dados.row-tabela NO-ERROR.
        
            ASSIGN int-upd-compra-aps.nr-ord-comp      = tt-dados.numero
                   int-upd-compra-aps.log-eliminado    = YES
                   int-upd-compra-aps.log-atualizado   = YES
                   int-upd-compra-aps.usuar-integr-out = c-seg-usuario
                   int-upd-compra-aps.dt-integr-out    = now.
        
            CREATE tt-log-ordem-compra.
            ASSIGN tt-log-ordem-compra.cod-estab   = tt-dados.cod-estabel
                   tt-log-ordem-compra.it-codigo   = tt-dados.it-codigo
                   tt-log-ordem-compra.nr-ord-comp = tt-dados.numero
                   tt-log-ordem-compra.parcela     = tt-dados.parcela
                   tt-log-ordem-compra.sequencia   = tt-dados.sequencia
                   tt-log-ordem-compra.acao        = "Eliminado pelo usuario".
/*         END.                                              */
/*         ELSE DO:                                          */
/*             MESSAGE "Registro n∆o foi eliminado."         */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
/*             LEAVE leitura.                                */
/*         END.                                              */
    END.
END.

/* gerando log */
Assign c-sistema      = "INTEGRACAO"
       c-titulo-relat = "ATUALIZACAO ORDENS COMPRA"
       c-empresa      = "INTELBRAS"
       c-programa     = "ESCCP052"
       c-versao       = "2.08.00."
       c-revisao      = "001".

assign c-rodape-aux = "DATASUL EMS 2.04 - " 
                    + c-sistema 
                    + " - " 
                    + c-programa 
                    + " - V:" 
                    + c-versao
                    + "."
                    + c-revisao
       c-rodape-aux = fill("-", 215 - length(c-rodape-aux)) + c-rodape-aux.

/* Log de divergencias */
OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "esccp052-atualizacao-OC.txt") PAGE-SIZE 64 no-convert.

   VIEW FRAME f-cabecalho.
   VIEW FRAME f-rodape1.

   FOR EACH tt-log-ordem-compra NO-LOCK BREAK BY tt-log-ordem-compra.acao:

       DISP tt-log-ordem-compra.cod-estab                                COLUMN-LABEL "Estab" 
            tt-log-ordem-compra.it-codigo                                COLUMN-LABEL "Item"
            tt-log-ordem-compra.nr-ord-comp    FORMAT ">>>>>>>>9"        COLUMN-LABEL "Ordem Compra"
            tt-log-ordem-compra.parcela                                  COLUMN-LABEL "Parcela"
            tt-log-ordem-compra.sequencia      format ">>>>>9"           column-label "Seq"
            tt-log-ordem-compra.dt-necessidade FORMAT "99/99/9999"       COLUMN-LABEL "Dt Necessidade"
            tt-log-ordem-compra.acao           FORMAT "x(80)"            COLUMN-LABEL "Acao"
            tt-log-ordem-compra.cStatus        FORMAT "x(75)"            COLUMN-LABEL "Status"
       WITH STREAM-IO WIDTH 215.

   END.
   
OUTPUT CLOSE.

run pi-finalizar in h-acomp.

DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "esccp052-atualizacao-OC.txt").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-op w-livre 
PROCEDURE pi-atualiza-op :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER bf-int-upd-prod-aps FOR int-upd-prod-aps.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Acompanhamento..."). 

EMPTY TEMP-TABLE tt-log-ord-prod.

IF l-elimina:SCREEN-VALUE IN FRAME f-cad = "no" THEN DO:

    FOR EACH int-upd-prod-aps NO-LOCK
       WHERE int-upd-prod-aps.log-atualizado  = NO
         AND int-upd-prod-aps.dt-inicio      >= dt-entrega-ini
         AND int-upd-prod-aps.dt-inicio      <= dt-entrega-fim
         AND int-upd-prod-aps.dt-fim         >= dt-termino-ini
         AND int-upd-prod-aps.dt-fim         <= dt-termino-fim
         AND int-upd-prod-aps.nr-ord-prod    >= i-ordem-ini
         AND int-upd-prod-aps.nr-ord-prod    <= i-ordem-fim
         AND int-upd-prod-aps.log-inexistente = NO:

        if not can-find(first tt-dados where 
                              tt-dados.numero = int-upd-prod-aps.nr-ord-prod)
        then next.
    
        IF NOT CAN-FIND(FIRST tt-dados NO-LOCK
                        WHERE tt-dados.numero = int-upd-prod-aps.nr-ord-prod
                          and tt-dados.row-tabela <> ?) THEN DO TRANSACTION:

            FOR FIRST bf-int-upd-prod-aps
                WHERE ROWID(bf-int-upd-prod-aps) = ROWID(int-upd-prod-aps)
                      EXCLUSIVE-LOCK: END.
    
            ASSIGN bf-int-upd-prod-aps.log-atualizado   = YES
                   bf-int-upd-prod-aps.log-inexistente  = YES
                   bf-int-upd-prod-aps.usuar-integr-out = c-seg-usuario
                   bf-int-upd-prod-aps.dt-integr-out    = now.
            
            CREATE tt-log-ord-prod.
            ASSIGN tt-log-ord-prod.nr-ord-prod = int-upd-prod-aps.nr-ord-prod
                   tt-log-ord-prod.sequencia   = int-upd-prod-aps.sequencia
                   tt-log-ord-prod.dt-inicio   = int-upd-prod-aps.dt-inicio 
                   tt-log-ord-prod.dt-termino  = int-upd-prod-aps.dt-fim
                   tt-log-ord-prod.acao        = "Alteracao"
                   tt-log-ord-prod.cStatus     = "Erro! Ordem nao encontrada no Datasul".
            
        END.
    END.
    
END.

leitura:
FOR EACH tt-dados 
   WHERE tt-dados.marcado = TRUE:

    IF l-elimina:SCREEN-VALUE IN FRAME f-cad = "no" THEN DO:   

        for FIRST int-upd-prod-aps WHERE 
                  ROWID(int-upd-prod-aps) = tt-dados.row-tabela
                  no-lock: end.

        if not avail int-upd-prod-aps
        THEN next.
          
         /*--- ALTERA ---*/
         FIND FIRST ord-prod 
              WHERE ord-prod.nr-ord-produ = int-upd-prod-aps.nr-ord-prod NO-LOCK NO-ERROR.

         if not avail ord-prod
         then do:
            CREATE tt-log-ord-prod.
            ASSIGN tt-log-ord-prod.cod-estab   = tt-dados.cod-estabel
                   tt-log-ord-prod.it-codigo   = tt-dados.it-codigo
                   tt-log-ord-prod.nr-ord-prod = tt-dados.numero
                   tt-log-ord-prod.sequencia   = tt-dados.sequencia
                   tt-log-ord-prod.acao        = "OP nao cadastrada".
            next.
         end.

         if  ord-prod.estado  > 6
         and ord-prod.estado <= 8
         then do:
            CREATE tt-log-ord-prod.
            ASSIGN tt-log-ord-prod.cod-estab   = tt-dados.cod-estabel
                   tt-log-ord-prod.it-codigo   = tt-dados.it-codigo
                   tt-log-ord-prod.nr-ord-prod = tt-dados.numero
                   tt-log-ord-prod.sequencia   = tt-dados.sequencia
                   tt-log-ord-prod.acao        = "OP finalizada ou terminada".
              next.
         end.
         
         EMPTY TEMP-TABLE tt-ord-prod.
         EMPTY TEMP-TABLE tt-erro.
        
         i-acomp-aux = i-acomp-aux + 1.
        
         RUN pi-acompanhar IN h-acomp (INPUT SUBSTITUTE("Alterando ORDEM APS: &1... (" + STRING(( i-acomp-aux * 100 ) / i-acomp, ">>9" ) + "%) ", tt-dados.ordem-aps)).
        
         CREATE tt-ord-prod.
         BUFFER-COPY ord-prod TO tt-ord-prod
         ASSIGN tt-ord-prod.ind-tipo-movto        = 2 /* alterar */ 
                tt-ord-prod.cod-versao-integracao = 3
                tt-ord-prod.seg-usuario           = c-seg-usuario
                tt-ord-prod.dt-inicio             = int-upd-prod-aps.dt-inicio
                tt-ord-prod.dt-termino            = int-upd-prod-aps.dt-fim
                tt-ord-prod.gera-relacionamentos  = TRUE
        //&IF DEFINED(bf_man_204) &THEN
                tt-ord-prod.gera-reservas         = TRUE
        //&ENDIF
               .
        
         CREATE tt-log-ord-prod.
         ASSIGN tt-log-ord-prod.cod-estab        = tt-ord-prod.cod-estabel
                tt-log-ord-prod.nr-ord-prod      = tt-ord-prod.nr-ord-produ
                tt-log-ord-prod.sequencia        = tt-ord-prod.sequencia
                tt-log-ord-prod.it-codigo        = tt-ord-prod.it-codigo
                tt-log-ord-prod.dt-inicio        = tt-ord-prod.dt-inicio 
                tt-log-ord-prod.dt-termino       = tt-ord-prod.dt-termino
                tt-log-ord-prod.qtde             = tt-ord-prod.qt-ordem
                tt-log-ord-prod.acao             = "Alteracao".

         do transaction on error undo, leave
                        on stop  undo, leave:
            FIND FIRST bf-int-upd-prod-aps EXCLUSIVE-LOCK
                 WHERE ROWID(bf-int-upd-prod-aps) = tt-dados.row-tabela NO-ERROR.

             /*--- execucao da API -----*/
             Run cpp/cpapi301.p (input-output table tt-ord-prod,
                                 Input-output table tt-reapro,
                                 Input-output table tt-erro,
                                 Input YES).
            
             c-erro = fnErro().
             c-erro-aux = c-erro.

             assign bf-int-upd-prod-aps.usuar-integr-out = c-seg-usuario
                    bf-int-upd-prod-aps.dt-integr-out    = now.
            
             IF c-erro <> '' 
             then do:
                  assign tt-log-ord-prod.cStatus = c-erro.
                  undo, leave.
             end.
             ELSE DO:
                tt-log-ord-prod.cStatus = "Ok".
            
                FIND FIRST tt-ord-prod NO-LOCK NO-ERROR.
            
                /*--- atualiza tabela especifica ----*/
                ASSIGN bf-int-upd-prod-aps.log-atualizado = YES.
             END.
         end. /* do transaction */

         if c-erro-aux <> ""
         then do:
              create tt-dados-aux.
              assign tt-dados-aux.row-tabela = tt-dados.row-tabela
                     tt-dados-aux.mensagem   = c-erro-aux.
              find current tt-dados-aux no-error.
         end.
    END.
    ELSE DO TRANSACTION:
    
/*         MESSAGE "Deseja eliminar o registro selecionado? "                               */
/*             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lElimina AS LOGICAL. */
/*                                                                                          */
/*         IF lElimina THEN DO:                                                             */
            FIND int-upd-prod-aps WHERE ROWID(int-upd-prod-aps) = tt-dados.row-tabela NO-ERROR.
        
            ASSIGN int-upd-prod-aps.nr-ord-prod      = tt-dados.numero
                   int-upd-prod-aps.log-eliminado    = YES
                   int-upd-prod-aps.log-atualizado   = YES
                   int-upd-prod-aps.usuar-integr-out = c-seg-usuario
                   int-upd-prod-aps.dt-integr-out    = now.
    
            CREATE tt-log-ord-prod.
            ASSIGN tt-log-ord-prod.cod-estab   = tt-dados.cod-estabel
                   tt-log-ord-prod.it-codigo   = tt-dados.it-codigo
                   tt-log-ord-prod.nr-ord-prod = tt-dados.numero
                   tt-log-ord-prod.sequencia   = tt-dados.sequencia
                   tt-log-ord-prod.acao        = "Eliminado pelo usuario".
/*         END.                                              */
/*         ELSE DO:                                          */
/*             MESSAGE "Registro n∆o foi eliminado."         */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
/*             LEAVE leitura.                                */
/*         END.                                              */
    END.
END.

/* gerando log */
Assign c-sistema      = "INTEGRACAO"
       c-titulo-relat = "ATUALIZACAO ORDENS PRODUCAO"
       c-empresa      = "INTELBRAS"
       c-programa     = "ESCCP052"
       c-versao       = "2.08.00."
       c-revisao      = "001".

assign c-rodape-aux = "DATASUL EMS 2.04 - " 
                    + c-sistema 
                    + " - " 
                    + c-programa 
                    + " - V:" 
                    + c-versao
                    + "."
                    + c-revisao
       c-rodape-aux = fill("-", 215 - length(c-rodape-aux)) + c-rodape-aux.

/* Log de divergencias */
OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "esccp052-atualizacao-OP.txt") PAGE-SIZE 64 no-convert.

   VIEW FRAME f-cabecalho.
   VIEW FRAME f-rodape1.

   FOR EACH tt-log-ord-prod NO-LOCK BREAK BY tt-log-ord-prod.acao:

       DISP tt-log-ord-prod.cod-estab   format "x(5)"             COLUMN-LABEL "Estab"
            tt-log-ord-prod.nr-ord-prod FORMAT "zzz,zzz,zz9"      COLUMN-LABEL "Ordem"
            tt-log-ord-prod.sequencia   format ">>>>>9"           column-label "Seq"
            tt-log-ord-prod.ordem-aps   FORMAT "x(15)"            COLUMN-LABEL "Ordem APS"
            tt-log-ord-prod.it-codigo   FORMAT "x(16)"            COLUMN-LABEL "Item"
            tt-log-ord-prod.dt-inicio   FORMAT "99/99/9999"       COLUMN-LABEL "Dt Inicio"
            tt-log-ord-prod.dt-termino  FORMAT "99/99/9999"       COLUMN-LABEL "Dt Termino"
            tt-log-ord-prod.qtde        FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Qtde"
            tt-log-ord-prod.acao        FORMAT "x(40)"            COLUMN-LABEL "Acao"
            tt-log-ord-prod.cStatus     FORMAT "x(75)"            COLUMN-LABEL "Status"
       WITH STREAM-IO WIDTH 215.

   END.
   
OUTPUT CLOSE.

run pi-finalizar in h-acomp.

DOS SILENT START VALUE(SESSION:TEMP-DIRECTORY + "esccp052-atualizacao-OP.txt").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tabela-temporaria w-livre 
PROCEDURE pi-gera-tabela-temporaria :
/*------------------------------------------------------------------------------
  Purpose: Geraá∆o de tabela tempor†ria
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-dados.

assign bt-marca:sensitive in frame f-cad    = no
       bt-desmarca:sensitive in frame f-cad = no
       bt-confirma:sensitive in frame f-cad = no.

/*--- ORDENS DE PRODUÄ«O ---*/
IF i-opcao= 1 THEN
DO:
   FOR EACH int-ord-prod-aps  NO-LOCK
      WHERE int-ord-prod-aps.cod-estabel   >= c-estabel-ini   
        AND int-ord-prod-aps.cod-estabel   <= c-estabel-fim   
        AND int-ord-prod-aps.cod-ordem-aps >= c-ordem-ini     
        AND int-ord-prod-aps.cod-ordem-aps <= c-ordem-fim 
        AND int-ord-prod-aps.dt-emissao    >= d-emissao-ini
        AND int-ord-prod-aps.dt-emissao    <= d-emissao-fim
        AND int-ord-prod-aps.dt-inicio     >= d-inicio-ini
        AND int-ord-prod-aps.dt-inicio     <= d-inicio-fim
        AND int-ord-prod-aps.dt-entrega    >= dt-termino-ini
        AND int-ord-prod-aps.dt-entrega    <= dt-termino-fim
        AND int-ord-prod-aps.it-codigo     >= c-item-ini      
        AND int-ord-prod-aps.it-codigo     <= c-item-fim
        AND int-ord-prod-aps.log-integrado  = NO
        AND int-ord-prod-aps.log-eliminado  = NO:
       
       FIND item-uni-estab 
      WHERE item-uni-estab.cod-estabel = int-ord-prod-aps.cod-estabel 
        AND item-uni-estab.it-codigo   = int-ord-prod-aps.it-codigo NO-LOCK NO-ERROR.
       
       FIND ITEM WHERE ITEM.it-codigo = int-ord-prod-aps.it-codigo NO-LOCK NO-ERROR.
/*        IF NOT AVAIL ITEM THEN NEXT. */
       
       CREATE tt-dados.
       ASSIGN tt-dados.tipo-dados    = "CP"
              tt-dados.it-codigo     = int-ord-prod-aps.it-codigo
              tt-dados.quantidade    = int-ord-prod-aps.qt-ord-prod
              tt-dados.marcado       = FALSE
              tt-dados.ordem-aps     = int-ord-prod-aps.cod-ordem-aps
              tt-dados.cod-estabel   = int-ord-prod-aps.cod-estabel
              tt-dados.ge-codigo     = ITEM.ge-codigo when avail item
              tt-dados.nr-linha      = IF AVAIL item-uni-estab THEN item-uni-estab.nr-linha ELSE 0
              tt-dados.row-tabela    = ROWID(int-ord-prod-aps)
              tt-dados.desc-item     = ITEM.desc-item when avail item
              tt-dados.data-libera   = int-ord-prod-aps.dt-entrega
              tt-dados.log-integrado = int-ord-prod-aps.log-integrado
              tt-dados.log-eliminado = int-ord-prod-aps.log-eliminado
              tt-dados.data-emissao  = int-ord-prod-aps.dt-emissao
              tt-dados.data-inicial  = int-ord-prod-aps.dt-inicio
              tt-dados.data-entrega  = int-ord-prod-aps.dt-entrega.

       for first tt-dados-aux
           where tt-dados-aux.row-tabela = tt-dados.row-tabela:
           assign tt-dados.mensagem = tt-dados-aux.mensagem.
       end.

       IF NOT CAN-FIND(FIRST operacao
                       WHERE operacao.it-codigo     = tt-dados.it-codigo
                       AND   operacao.data-inicio  <= TODAY
                       AND   operacao.data-termino >= TODAY) THEN 
          ASSIGN tt-dados.mensagem = "Item n∆o possui roteiro de fabricaá∆o ativo!". 

       if not avail item
       then ASSIGN tt-dados.mensagem = "Item nao cadastrado no EMS !!!".
       else IF NOT AVAIL item-uni-estab THEN
                ASSIGN tt-dados.mensagem = "Item X Estabelec. nao cadastrado !".
            else if item-uni-estab.cd-planejado = "" THEN
               ASSIGN tt-dados.mensagem = "Planejador nao cadastrado para o item !".
                 else if item-uni-estab.cod-obsoleto > 1 
                      then do:
                           assign c-msg = "Item n∆o est† ativo !".
                 
                           if item-uni-estab.cod-obsoleto < 5
                           then do:
                                assign c-msg = "Item est† "
                                             + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).
                 
                                for first int-item fields(motivo-situacao) no-lock
                                    where int-item.it-codigo       = item-uni-estab.it-codigo                               
                                      and int-item.motivo-situacao > 0
                                      and int-item.motivo-situacao < 3:
                                    assign c-msg = c-msg 
                                                 + " - "
                                                 + entry(int-item.motivo-situacao,c-motivo).
                                end. /* for first int-item */
        
                                assign c-msg = c-msg + " !".
                           end. /* if item-uni-estab.cod-obsoleto < 5 */
        
                           ASSIGN tt-dados.mensagem = c-msg.
                      end.
   END.
END.

/*--- ORDEM DE COMPRAS ---*/
ELSE
IF i-opcao = 2 THEN
DO:
   RUN pi-muda-browse(INPUT 2).

   FOR EACH int-ord-comp-aps NO-LOCK
      WHERE int-ord-comp-aps.dt-entrega     >= dt-entrega-ini 
        AND int-ord-comp-aps.dt-entrega     <= dt-entrega-fim 
        AND int-ord-comp-aps.dt-emissao     >= d-emissao-ini
        AND int-ord-comp-aps.dt-emissao     <= d-emissao-fim
        AND int-ord-comp-aps.dt-necessidade >= dt-neces-ini
        AND int-ord-comp-aps.dt-necessidade <= dt-neces-fim
        AND int-ord-comp-aps.cod-estabel    >= c-estabel-ini      
        AND int-ord-comp-aps.cod-estabel    <= c-estabel-fim
        AND int-ord-comp-aps.cod-ordem-aps  >= c-ordem-ini    
        AND int-ord-comp-aps.cod-ordem-aps  <= c-ordem-fim    
        AND int-ord-comp-aps.it-codigo      >= c-item-ini     
        AND int-ord-comp-aps.it-codigo      <= c-item-fim
        AND int-ord-comp-aps.log-integrado   = NO
        AND int-ord-comp-aps.log-eliminado   = NO:

      FIND ITEM WHERE ITEM.it-codigo = int-ord-comp-aps.it-codigo NO-LOCK NO-ERROR.
/*       IF NOT AVAIL ITEM THEN NEXT. */
      
      CREATE tt-dados.
      ASSIGN tt-dados.tipo-dados       = "CC"
             tt-dados.it-codigo        = int-ord-comp-aps.it-codigo
             tt-dados.quantidade       = int-ord-comp-aps.qtd-ord-comp
             tt-dados.data-inicial     = int-ord-comp-aps.dt-emissao
             tt-dados.data-final       = int-ord-comp-aps.dt-entrega
             tt-dados.marcado          = FALSE
             tt-dados.ordem-aps        = int-ord-comp-aps.cod-ordem-aps
             tt-dados.cod-estabel      = int-ord-comp-aps.cod-estabel
             tt-dados.ge-codigo        = ITEM.ge-codigo when avail item
             tt-dados.nr-linha         = 0
             tt-dados.row-tabela       = ROWID(int-ord-comp-aps)
             tt-dados.desc-item        = ITEM.desc-item when avail item
             tt-dados.data-libera      = int-ord-comp-aps.dt-entrega
             tt-dados.dt-necessidade   = int-ord-comp-aps.dt-necessidade
             tt-dados.log-integrado    = int-ord-comp-aps.log-integrado
             tt-dados.log-eliminado    = int-ord-comp-aps.log-eliminado.

       for first tt-dados-aux
           where tt-dados-aux.row-tabela = tt-dados.row-tabela:
           assign tt-dados.mensagem = tt-dados-aux.mensagem.
       end.

/*       FIND ITEM WHERE                                            */
/*            ITEM.it-codigo = tt-dados.it-codigo NO-LOCK NO-ERROR. */
      IF NOT AVAIL ITEM THEN 
         ASSIGN tt-dados.mensagem = "Item nao cadastrado no EMS !!!".
      else do:
           FIND item-uni-estab WHERE
                item-uni-estab.cod-estabel = tt-dados.cod-estabel AND
                item-uni-estab.it-codigo   = tt-dados.it-codigo   NO-LOCK NO-ERROR.
           IF NOT AVAIL item-uni-estab THEN
               ASSIGN tt-dados.mensagem = "Item X Estabelec. nao cadastrado !".
           else if item-uni-estab.cod-obsoleto > 1 
                then do:
                     assign c-msg = "Item n∆o est† ativo !".
            
                     if item-uni-estab.cod-obsoleto < 5
                     then do:
                          assign c-msg = "Item est† "
                                       + entry(item-uni-estab.cod-obsoleto,c-cod-obsoleto).
            
                          for first int-item fields(motivo-situacao) no-lock
                              where int-item.it-codigo       = item-uni-estab.it-codigo
                                and int-item.motivo-situacao > 0
                                and int-item.motivo-situacao < 3:
                              assign c-msg = c-msg 
                                           + " - "
                                           + entry(int-item.motivo-situacao,c-motivo).
                          end. /* for first int-item */

                          assign c-msg = c-msg + " !".
                     end. /* if item-uni-estab.cod-obsoleto < 5 */

                     ASSIGN tt-dados.mensagem = c-msg.
                end.
      end.

   END.
END.
ELSE
IF i-opcao = 3 THEN
DO:
    RUN pi-muda-browse(INPUT 3).

    FOR EACH int-upd-prod-aps NO-LOCK
       WHERE int-upd-prod-aps.log-atualizado  = NO
         AND int-upd-prod-aps.dt-inicio      >= dt-entrega-ini
         AND int-upd-prod-aps.dt-inicio      <= dt-entrega-fim
         AND int-upd-prod-aps.dt-fim         >= dt-termino-ini
         AND int-upd-prod-aps.dt-fim         <= dt-termino-fim
         AND int-upd-prod-aps.nr-ord-prod    >= i-ordem-ini
         AND int-upd-prod-aps.nr-ord-prod    <= i-ordem-fim
        //AND int-upd-prod-aps.log-atualizado  = NO
         AND int-upd-prod-aps.log-inexistente = NO:

        FOR EACH ord-prod NO-LOCK
           WHERE ord-prod.nr-ord-produ = int-upd-prod-aps.nr-ord-prod
             AND ord-prod.cod-estabel >= c-estabel-ini
             AND ord-prod.cod-estabel <= c-estabel-fim
             AND ord-prod.it-codigo   >= c-item-ini
             AND ord-prod.it-codigo   <= c-item-fim:
            
            IF LENGTH(int-upd-prod-aps.nr-ord-prod) > 8 THEN NEXT.

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = ord-prod.it-codigo:
            END.

            CREATE tt-dados.
            ASSIGN tt-dados.tipo-dados       = "CP"
                   tt-dados.numero           = int-upd-prod-aps.nr-ord-prod
                   tt-dados.sequencia        = int-upd-prod-aps.sequencia
                   tt-dados.data-inicial     = int-upd-prod-aps.dt-inicio
                   tt-dados.data-final       = int-upd-prod-aps.dt-fim
                   tt-dados.marcado          = FALSE
                   tt-dados.nr-linha         = 0
                   tt-dados.row-tabela       = ROWID(int-upd-prod-aps)
                   tt-dados.log-inexistente  = int-upd-prod-aps.log-inexistente.
    
            ASSIGN tt-dados.it-codigo      = ord-prod.it-codigo
                   tt-dados.quantidade     = ord-prod.qt-ordem
                   tt-dados.cod-estabel    = ord-prod.cod-estabel
                   tt-dados.desc-item      = ITEM.desc-item
                   tt-dados.data-ini-antes = ord-prod.dt-inicio
                   tt-dados.data-fim-antes = ord-prod.dt-termino.

            for first tt-dados-aux
                where tt-dados-aux.row-tabela = tt-dados.row-tabela:
                assign tt-dados.mensagem = tt-dados-aux.mensagem.
            end.

            if ord-prod.estado = 7
            or ord-prod.estado = 8
            then assign tt-dados.mensagem = "Ordem finalizada ou terminada".
            
        END.
        IF NOT CAN-FIND(FIRST ord-prod NO-LOCK
                        WHERE ord-prod.nr-ord-produ = int-upd-prod-aps.nr-ord-prod) 
        THEN  do:
            CREATE tt-dados.
            ASSIGN tt-dados.tipo-dados       = "CP"
                   tt-dados.numero           = int-upd-prod-aps.nr-ord-prod
                   tt-dados.sequencia        = int-upd-prod-aps.sequencia
                   tt-dados.data-inicial     = int-upd-prod-aps.dt-inicio
                   tt-dados.data-final       = int-upd-prod-aps.dt-fim
                   tt-dados.marcado          = FALSE
                   tt-dados.nr-linha         = 0
                   tt-dados.row-tabela       = ?
                   tt-dados.log-inexistente  = int-upd-prod-aps.log-inexistente
                   tt-dados.mensagem = "Ordem nao localizada no Datasul".
        END.

    END.
END.
ELSE
IF i-opcao = 4 THEN
DO:
    RUN pi-muda-browse(INPUT 4).

    FOR EACH int-upd-compra-aps NO-LOCK
       WHERE int-upd-compra-aps.log-atualizado = NO
         AND int-upd-compra-aps.nr-ord-comp    >= i-ordem-ini
         AND int-upd-compra-aps.nr-ord-comp    <= i-ordem-fim
         AND int-upd-compra-aps.dt-necessidade >= dt-neces-ini
         AND int-upd-compra-aps.dt-necessidade <= dt-neces-fim
        //AND int-upd-compra-aps.log-atualizado  = NO
         AND int-upd-compra-aps.log-inexistente = NO:

        IF LENGTH(int-upd-compra-aps.nr-ord-comp) > 8 THEN NEXT.

        if not can-find(first ordem-compra where
                              ordem-compra.numero-ordem = int-upd-compra-aps.nr-ord-comp
                              no-lock)
        then do:
             CREATE tt-dados.
             ASSIGN tt-dados.tipo-dados       = "CC"
                    tt-dados.numero           = int-upd-compra-aps.nr-ord-comp
                    tt-dados.parcela          = int-upd-compra-aps.parcela
                    tt-dados.sequencia        = int-upd-compra-aps.sequencia
                    tt-dados.dt-necessidade   = int-upd-compra-aps.dt-necessidade
                    tt-dados.marcado          = FALSE
                    tt-dados.nr-linha         = 0
                    tt-dados.row-tabela       = ?
                    tt-dados.log-inexistente  = int-upd-compra-aps.log-inexistente
                    tt-dados.mensagem         = "Ordem inexistente no Datasul".
        end.
        else FOR EACH ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem  = int-upd-compra-aps.nr-ord-comp
                  AND ordem-compra.cod-estabel  >= c-estabel-ini 
                  AND ordem-compra.cod-estabel  <= c-estabel-fim 
                  AND ordem-compra.it-codigo    >= c-item-ini 
                  AND ordem-compra.it-codigo    <= c-item-fim:
        
                 FOR FIRST prazo-compra NO-LOCK
                     WHERE prazo-compra.numero-ordem = int-upd-compra-aps.nr-ord-comp
                       AND prazo-compra.parcela      = int-upd-compra-aps.parcela:
                 END.
                 
                 CREATE tt-dados.
                 ASSIGN tt-dados.tipo-dados       = "CC"
                        tt-dados.numero           = int-upd-compra-aps.nr-ord-comp
                        tt-dados.parcela          = int-upd-compra-aps.parcela
                        tt-dados.sequencia        = int-upd-compra-aps.sequencia
                        tt-dados.dt-necessidade   = int-upd-compra-aps.dt-necessidade
                        tt-dados.marcado          = FALSE
                        tt-dados.nr-linha         = 0
                        tt-dados.row-tabela       = ROWID(int-upd-compra-aps)
                        tt-dados.log-inexistente  = int-upd-compra-aps.log-inexistente.

                 for first tt-dados-aux
                     where tt-dados-aux.row-tabela = tt-dados.row-tabela:
                     assign tt-dados.mensagem = tt-dados-aux.mensagem.
                 end.

                 case ordem-compra.situacao:
                     when 4
                     then assign tt-dados.mensagem = "Ordem Compra foi eliminada".
                     when 6
                     then assign tt-dados.mensagem = "Ordem Compra j† recebida".
                 end case.
        
                 FOR FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ordem-compra.it-codigo:
                     ASSIGN tt-dados.it-codigo = ITEM.it-codigo
                            tt-dados.desc-item = ITEM.desc-item.
                 END.
        
                 ASSIGN tt-dados.data-inicial = ordem-compra.data-emissao
                        tt-dados.cod-estabel  = ordem-compra.cod-estabel.
                 
                 IF AVAIL prazo-compra THEN DO:
                     ASSIGN tt-dados.quantidade   = prazo-compra.quant-saldo
                            tt-dados.data-final   = prazo-compra.data-entrega
                            tt-dados.data-libera  = prazo-compra.data-entrega.
                            tt-dados.dias-dif     = INT(prazo-compra.data-entrega - int-upd-compra-aps.dt-necessidade).
                     IF INT(prazo-compra.data-entrega - int-upd-compra-aps.dt-necessidade) < 0 THEN
                         ASSIGN tt-dados.dias-dif = INT(prazo-compra.data-entrega - int-upd-compra-aps.dt-necessidade) * -1.

                     case prazo-compra.situacao:
                         when 4
                         then assign tt-dados.mensagem = "Parcela da Ordem foi eliminada".
                         when 6
                         then assign tt-dados.mensagem = "Parcela da Ordem j† recebida".
                     end case.
            
                 END.
                 ELSE ASSIGN tt-dados.mensagem = "Parcela da Ordem inexistente no Datasul".
             END.
    END.
END.

empty temp-table tt-dados-aux.

ASSIGN dTotalReg = 0.
FOR EACH tt-dados:
    ASSIGN dTotalReg = dTotalReg + 1.
END.
ASSIGN dTotalReg:SCREEN-VALUE IN FRAME f-cad = STRING(dTotalReg)
       bt-marca:sensitive     in frame f-cad = temp-table tt-dados:has-records.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-browse w-livre 
PROCEDURE pi-muda-browse :
/*------------------------------------------------------------------------------
  Purpose: Atualizaá∆o da programaá∆o de compras
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM iOpcao AS INTEGER NO-UNDO.

IF iOpcao = 1 THEN DO:

    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(2)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(3)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(4)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(5)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(6)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(7)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(8)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(9)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(10)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(11)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(12)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(13)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(14)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(15)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(16)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(17)
           hColumn:VISIBLE = NO.
END.

IF iOpcao = 2 THEN DO:

    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(2)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(3)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(4)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(5)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(6)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(7)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(8)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(9)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(10)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(11)
           hColumn:VISIBLE = YES
           hColumn:LABEL = "Data Emiss∆o".
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(12)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(13)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(14)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(15)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(16)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(17)
           hColumn:VISIBLE = NO.
END.

IF iOpcao = 3 THEN DO:

    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(2)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(3)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(4)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(5)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(6)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(7)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(8)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(9)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(10)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(11)
           hColumn:VISIBLE = YES
           hColumn:LABEL = "Data In°cio".
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(12)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(13)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(14)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(15)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(16)
           hColumn:VISIBLE = YES
           hColumn:LABEL = "Data TÇrmino".
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(17)
           hColumn:VISIBLE = NO.
END.

IF iOpcao = 4 THEN DO:

    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(2)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(3)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(4)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(5)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(6)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(7)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(8)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(9)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(10)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(11)
           hColumn:VISIBLE = YES
           hColumn:LABEL = "Data Emiss∆o".
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(12)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(13)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(14)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(15)
           hColumn:VISIBLE = YES.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(16)
           hColumn:VISIBLE = NO.
    ASSIGN hColumn = BROWSE brDados:GET-BROWSE-COLUMN(17)
           hColumn:VISIBLE = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-dados"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaDataInicioOP w-livre 
FUNCTION fnBuscaDataInicioOP RETURNS DATE
  ( dtOrig AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST periodo USE-INDEX ch-termino
       WHERE periodo.cd-tipo     = param-cp.cd-tipo
         AND periodo.dt-termino >= dtOrig NO-LOCK NO-ERROR.
  
  IF AVAIL periodo THEN 
     RETURN periodo.dt-inicio.
  ELSE
     RETURN dtOrig.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaDataTerminoOp w-livre 
FUNCTION fnBuscaDataTerminoOp RETURNS DATE
  ( dtOrig AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST periodo USE-INDEX ch-termino
       WHERE periodo.cd-tipo     = param-cp.cd-tipo
         AND periodo.dt-termino >= dtOrig NO-LOCK NO-ERROR.
  
  IF AVAIL periodo THEN   
     RETURN periodo.dt-termino.
  ELSE
     RETURN dtOrig.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnErro w-livre 
FUNCTION fnErro RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR EACH tt-erro NO-LOCK:

      FIND FIRST cadast_msg
           WHERE cadast_msg.cdn_msg = tt-erro.cd-erro NO-LOCK NO-ERROR.

      IF AVAIL cadast_msg AND cadast_msg.idi_tip_msg <> 1 THEN NEXT.

      RETURN STRING(tt-erro.cd-erro) + ': ' + tt-erro.mensagem.
      
  END.

  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

