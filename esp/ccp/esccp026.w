&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgcad           PROGRESS
          mgmov           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-prazo-compra NO-UNDO LIKE int-prazo-compra
       FIELD r-Rowid      AS ROWID
       FIELD situacao     AS CHARACTER
       FIELD quantidade   LIKE prazo-compra.quantidade
       FIELD un           LIKE prazo-compra.un
       FIELD qtd-sal-forn LIKE prazo-compra.qtd-sal-forn
       FIELD un-fornec    LIKE prazo-compra.un           LABEL "Unid Fornec":U COLUMN-LABEL "Un Forn":U
       FIELD data-entrega LIKE prazo-compra.data-entrega.
DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP026 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP026
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parcelas

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   brPrazoCompra btUpdate textMensagem
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE txtmsg         O n£mero da Nota Fiscal ‚ meramente informativo e nÆo est  relacionado com o lan‡amento do Recebimento.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pNumeroOrdem LIKE ordem-compra.numero-ordem NO-UNDO.

/* Local Temp-Table Definitions ---                                     */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE v-coluna    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-asc       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-boin356vl AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPrazoCompra

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-prazo-compra

/* Definitions for BROWSE brPrazoCompra                                 */
&Scoped-define FIELDS-IN-QUERY-brPrazoCompra tt-int-prazo-compra.parcela ~
tt-int-prazo-compra.situacao @ tt-int-prazo-compra.situacao ~
tt-int-prazo-compra.quantidade @ tt-int-prazo-compra.quantidade ~
tt-int-prazo-compra.un @ tt-int-prazo-compra.un ~
tt-int-prazo-compra.qtd-sal-forn @ tt-int-prazo-compra.qtd-sal-forn ~
tt-int-prazo-compra.un-fornec @ tt-int-prazo-compra.un-fornec ~
tt-int-prazo-compra.data-entrega @ tt-int-prazo-compra.data-entrega ~
tt-int-prazo-compra.nro-docto tt-int-prazo-compra.serie-docto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPrazoCompra ~
tt-int-prazo-compra.nro-docto tt-int-prazo-compra.serie-docto 
&Scoped-define ENABLED-TABLES-IN-QUERY-brPrazoCompra tt-int-prazo-compra
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brPrazoCompra tt-int-prazo-compra
&Scoped-define QUERY-STRING-brPrazoCompra FOR EACH tt-int-prazo-compra NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brPrazoCompra OPEN QUERY brPrazoCompra FOR EACH tt-int-prazo-compra NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPrazoCompra tt-int-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brPrazoCompra tt-int-prazo-compra


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brPrazoCompra}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-ordem-compra.num-pedido ~
tt-ordem-compra.cod-emitente tt-ordem-compra.numero-ordem ~
tt-ordem-compra.it-codigo 
&Scoped-define ENABLED-TABLES tt-ordem-compra
&Scoped-define FIRST-ENABLED-TABLE tt-ordem-compra
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys fiNomeAbrev fiDescItem btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-ordem-compra.num-pedido ~
tt-ordem-compra.cod-emitente tt-ordem-compra.numero-ordem ~
tt-ordem-compra.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-ordem-compra
&Scoped-define FIRST-DISPLAYED-TABLE tt-ordem-compra
&Scoped-Define DISPLAYED-OBJECTS fiNomeAbrev fiDescItem 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-houve-alteracao wWindow 
FUNCTION fn-houve-alteracao RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao-parcela wWindow 
FUNCTION fn-situacao-parcela RETURNS CHARACTER
  ( p-situacao AS INTEGER )  FORWARD.

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

DEFINE VARIABLE fiDescItem LIKE item.desc-item
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeAbrev LIKE emitente.nome-abrev
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btUpdate 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE textMensagem AS CHARACTER INITIAL "Para Desenvolvedores: A mensagem deve ser colocada no pr‚-processador ~"txtmsg~"." 
     VIEW-AS EDITOR NO-BOX
     SIZE 85 BY 1.29
     FGCOLOR 12 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPrazoCompra FOR 
      tt-int-prazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPrazoCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPrazoCompra wWindow _STRUCTURED
  QUERY brPrazoCompra NO-LOCK DISPLAY
      tt-int-prazo-compra.parcela FORMAT ">>>>9":U WIDTH 5 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.situacao @ tt-int-prazo-compra.situacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(15)":U
            WIDTH 14.43 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.quantidade @ tt-int-prazo-compra.quantidade COLUMN-LABEL "Qtde" FORMAT ">>>>,>>9.9999":U
            WIDTH 11.57 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.un @ tt-int-prazo-compra.un COLUMN-LABEL "Un Med" FORMAT "xx":U
            WIDTH 6.86 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.qtd-sal-forn @ tt-int-prazo-compra.qtd-sal-forn COLUMN-LABEL "Qt Saldo Forn" FORMAT ">>>>,>>9.9999":U
            WIDTH 11.57 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.un-fornec @ tt-int-prazo-compra.un-fornec COLUMN-LABEL "Unid Forn" FORMAT "xx":U
            WIDTH 6.86 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.data-entrega @ tt-int-prazo-compra.data-entrega COLUMN-LABEL "Data Entrega" FORMAT "99/99/9999":U
            WIDTH 12 COLUMN-BGCOLOR 17
      tt-int-prazo-compra.nro-docto COLUMN-LABEL "Nota Fiscal" FORMAT "x(16)":U
            WIDTH 14.57
      tt-int-prazo-compra.serie-docto COLUMN-LABEL "S‚rie" FORMAT "x(5)":U
            WIDTH 6
  ENABLE
      tt-int-prazo-compra.nro-docto HELP "Nota Fiscal"
      tt-int-prazo-compra.serie-docto HELP "S‚rie Nota Fiscal"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 97 BY 7.33
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-ordem-compra.num-pedido AT ROW 1.17 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-ordem-compra.cod-emitente AT ROW 1.17 COL 28.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiNomeAbrev AT ROW 1.17 COL 102 RIGHT-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     tt-ordem-compra.numero-ordem AT ROW 2.17 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-ordem-compra.it-codigo AT ROW 2.17 COL 28.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescItem AT ROW 2.17 COL 102 RIGHT-ALIGNED HELP
          "" NO-LABEL
     btOK AT ROW 14.83 COL 2
     btCancel AT ROW 14.83 COL 13
     btHelp2 AT ROW 14.83 COL 95
     rtToolBar AT ROW 14.58 COL 1
     rtKeys AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105 BY 15.2
         FONT 1.

DEFINE FRAME fPage1
     brPrazoCompra AT ROW 1.17 COL 2
     btUpdate AT ROW 8.54 COL 2
     textMensagem AT ROW 8.67 COL 14 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 99.43 BY 9.12
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-prazo-compra T "?" NO-UNDO mgesp int-prazo-compra
      ADDITIONAL-FIELDS:
          FIELD r-Rowid      AS ROWID
          FIELD situacao     AS CHARACTER
          FIELD quantidade   LIKE prazo-compra.quantidade
          FIELD un           LIKE prazo-compra.un
          FIELD qtd-sal-forn LIKE prazo-compra.qtd-sal-forn
          FIELD un-fornec    LIKE prazo-compra.un           LABEL "Unid Fornec":U COLUMN-LABEL "Un Forn":U
          FIELD data-entrega LIKE prazo-compra.data-entrega
      END-FIELDS.
      TABLE: tt-ordem-compra T "?" NO-UNDO mgmov ordem-compra
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.21
         WIDTH              = 105
         MAX-HEIGHT         = 15.21
         MAX-WIDTH          = 105
         VIRTUAL-HEIGHT     = 15.21
         VIRTUAL-WIDTH      = 105
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fiDescItem IN FRAME fpage0
   ALIGN-R LIKE = mgcad.item.desc-item EXP-SIZE                        */
/* SETTINGS FOR FILL-IN fiNomeAbrev IN FRAME fpage0
   ALIGN-R LIKE = mgcad.emitente.nome-abrev EXP-SIZE                   */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brPrazoCompra 1 fPage1 */
ASSIGN 
       brPrazoCompra:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE
       brPrazoCompra:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

ASSIGN 
       textMensagem:READ-ONLY IN FRAME fPage1        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPrazoCompra
/* Query rebuild information for BROWSE brPrazoCompra
     _TblList          = "Temp-Tables.tt-int-prazo-compra"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-int-prazo-compra.parcela
"tt-int-prazo-compra.parcela" ? ? "integer" 17 ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-int-prazo-compra.situacao @ tt-int-prazo-compra.situacao" "Situa‡Æo" "x(15)" ? 17 ? ? ? ? ? no "Situa‡Æo da Parcela" no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-int-prazo-compra.quantidade @ tt-int-prazo-compra.quantidade" "Qtde" ">>>>,>>9.9999" ? 17 ? ? ? ? ? no "Quantidade" no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-int-prazo-compra.un @ tt-int-prazo-compra.un" "Un Med" "xx" ? 17 ? ? ? ? ? no "Unidade Medida" no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-int-prazo-compra.qtd-sal-forn @ tt-int-prazo-compra.qtd-sal-forn" "Qt Saldo Forn" ">>>>,>>9.9999" ? 17 ? ? ? ? ? no "Quantidade Saldo Fornecedor" no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-int-prazo-compra.un-fornec @ tt-int-prazo-compra.un-fornec" "Unid Forn" "xx" ? 17 ? ? ? ? ? no "Unidade Medida Fornecedor" no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-int-prazo-compra.data-entrega @ tt-int-prazo-compra.data-entrega" "Data Entrega" "99/99/9999" ? 17 ? ? ? ? ? no "Data de Entrega" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-int-prazo-compra.nro-docto
"tt-int-prazo-compra.nro-docto" "Nota Fiscal" ? "character" ? ? ? ? ? ? yes "Nota Fiscal" no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-int-prazo-compra.serie-docto
"tt-int-prazo-compra.serie-docto" "S‚rie" ? "character" ? ? ? ? ? ? yes "S‚rie Nota Fiscal" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPrazoCompra */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPrazoCompra
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brPrazoCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPrazoCompra wWindow
ON RETURN OF brPrazoCompra IN FRAME fPage1
ANYWHERE DO:
    APPLY "TAB":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPrazoCompra wWindow
ON ROW-LEAVE OF brPrazoCompra IN FRAME fPage1
DO:
    DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        IF AVAILABLE tt-int-prazo-compra THEN
            ASSIGN INPUT BROWSE brPrazoCompra tt-int-prazo-compra.serie-docto
                                              tt-int-prazo-compra.nro-docto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPrazoCompra wWindow
ON START-SEARCH OF brPrazoCompra IN FRAME fPage1
DO:
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-index AS INTEGER     NO-UNDO.

    IF v-coluna <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v-coluna = SELF:CURRENT-COLUMN:NAME
               l-asc    = YES.
    ELSE
        ASSIGN l-asc = NOT l-asc.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE <> "":U AND
       SELF:CURRENT-COLUMN:TABLE <> ? THEN DO:
        IF l-asc THEN
            SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
        ELSE
            SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).

        DO i-cont = 1 TO SELF:NUM-COLUMNS:
            IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i-cont) THEN
                ASSIGN i-index = i-cont.
        END.

        SELF:SET-SORT-ARROW(i-index, l-asc).

        SELF:QUERY:QUERY-OPEN().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    IF fn-houve-alteracao() THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT "Deseja descartar a(s) altera‡Æo(äes) realizada(s)?":U).

        IF RETURN-VALUE = "NO":U THEN
            RETURN NO-APPLY.
    END.

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
    IF fn-houve-alteracao() THEN
        RUN saveDocto IN THIS-PROCEDURE.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wWindow
ON CHOOSE OF btUpdate IN FRAME fPage1 /* Alterar */
DO:
    IF AVAILABLE tt-int-prazo-compra THEN
        APPLY "ENTRY":U TO tt-int-prazo-compra.nro-docto IN BROWSE brPrazoCompra.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin356vl) THEN
        RUN destroy IN h-boin356vl.

    ASSIGN h-boin356vl = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN textMensagem = "** {&txtmsg} **":U.

    DISPLAY textMensagem
        WITH FRAME fPage1.

    ASSIGN textMensagem:FONT IN FRAME fPage1 = 6.

    FIND FIRST tt-ordem-compra NO-ERROR.

    FIND FIRST emitente
        WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN fiNomeAbrev = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U.

    RELEASE emitente.

    FIND FIRST item
        WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

    ASSIGN fiDescItem = IF AVAILABLE item THEN item.desc-item ELSE "":U.

    RELEASE item.

    DISPLAY tt-ordem-compra.num-pedido
            tt-ordem-compra.numero-ordem
            tt-ordem-compra.cod-emitente
            fiNomeAbrev
            tt-ordem-compra.it-codigo
            fiDescItem
        WITH FRAME fPage0.

    EMPTY TEMP-TABLE tt-int-prazo-compra.

    FOR EACH prazo-compra NO-LOCK
        WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:

        FIND FIRST int-prazo-compra
            WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
              AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

        CREATE tt-int-prazo-compra.

        IF AVAILABLE int-prazo-compra THEN DO:
            BUFFER-COPY int-prazo-compra TO tt-int-prazo-compra.

            RELEASE int-prazo-compra.
        END.
        ELSE
            ASSIGN tt-int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                   tt-int-prazo-compra.parcela      = prazo-compra.parcela
                   tt-int-prazo-compra.nro-docto    = "":U
                   tt-int-prazo-compra.serie-docto  = "":U.

        ASSIGN tt-int-prazo-compra.situacao     = fn-situacao-parcela(prazo-compra.situacao)
               tt-int-prazo-compra.quantidade   = prazo-compra.quantidade
               tt-int-prazo-compra.un           = prazo-compra.un
               tt-int-prazo-compra.qtd-sal-forn = prazo-compra.qtd-sal-forn.

        IF NOT VALID-HANDLE(h-boin356vl)                 OR
           h-boin356vl:TYPE      <> "PROCEDURE":U        OR
           h-boin356vl:FILE-NAME <> "inbo/boin356vl.p":U THEN
            RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.

        IF VALID-HANDLE(h-boin356vl) THEN
            RUN getUnFornecedorOrdem IN h-boin356vl (INPUT  tt-int-prazo-compra.numero-ordem,
                                                     OUTPUT tt-int-prazo-compra.un-fornec).

        ASSIGN tt-int-prazo-compra.data-entrega = prazo-compra.data-entrega.
    END.

    {&OPEN-QUERY-brPrazoCompra}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-ordem-compra.

    FIND FIRST ordem-compra
        WHERE ordem-compra.numero-ordem = pNumeroOrdem NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ordem-compra THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Ordem de Compra":U +
                                 "~~":U +
                                 "Ordem: ":U + STRING(pNumeroOrdem, "zzzzz9,99":U)).

        RETURN "NOK":U.
    END.

    CREATE tt-ordem-compra.
    BUFFER-COPY ordem-compra TO tt-ordem-compra.

    RELEASE ordem-compra.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDocto wWindow 
PROCEDURE saveDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-int-prazo-compra:
        FIND FIRST int-prazo-compra
            WHERE int-prazo-compra.numero-ordem = tt-int-prazo-compra.numero-ordem
              AND int-prazo-compra.parcela      = tt-int-prazo-compra.parcela EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-prazo-compra THEN DO:
            CREATE int-prazo-compra.
            ASSIGN int-prazo-compra.numero-ordem = tt-int-prazo-compra.numero-ordem
                   int-prazo-compra.parcela      = tt-int-prazo-compra.parcela.
        END.

        ASSIGN int-prazo-compra.serie-docto = tt-int-prazo-compra.serie-docto
               int-prazo-compra.nro-docto   = tt-int-prazo-compra.nro-docto.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-houve-alteracao wWindow 
FUNCTION fn-houve-alteracao RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR EACH tt-int-prazo-compra:
        FIND FIRST int-prazo-compra
            WHERE int-prazo-compra.numero-ordem = tt-int-prazo-compra.numero-ordem
              AND int-prazo-compra.parcela      = tt-int-prazo-compra.parcela NO-LOCK NO-ERROR.

        IF AVAILABLE int-prazo-compra THEN DO:
            IF int-prazo-compra.serie-docto <> tt-int-prazo-compra.serie-docto OR
               int-prazo-compra.nro-docto   <> tt-int-prazo-compra.nro-docto   THEN
                RETURN YES.
        END.
        ELSE IF tt-int-prazo-compra.serie-docto <> "":U OR
                tt-int-prazo-compra.nro-docto   <> "":U THEN
            RETURN YES.
    END.

    RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao-parcela wWindow 
FUNCTION fn-situacao-parcela RETURNS CHARACTER
  ( p-situacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN {ininc/i02in274.i 04 p-situacao}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

