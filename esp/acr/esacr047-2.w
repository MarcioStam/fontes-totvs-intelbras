&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-erro         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-usuario      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-perc-calc   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-classe AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-prev     AS DECIMAL     NO-UNDO.

DEFINE VARIABLE l-acr AS LOGICAL     NO-UNDO FORMAT "Sim/N∆o":U LABEL "ACR":U COLUMN-LABEL "ACR":U.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr AS RECID                    NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

{esp/acr/esacr047.i}

DEFINE BUFFER bf-int-pagtos-supcard      FOR int-pagtos-supcard.
DEFINE BUFFER bf-int-pagtos-supcard-ocor FOR int-pagtos-supcard-ocor.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brPagtos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-pagtos-supcard int-pagtos-supcard-ocor

/* Definitions for BROWSE brPagtos                                      */
&Scoped-define FIELDS-IN-QUERY-brPagtos ~
fnACR(int-pagtos-supcard-ocor.num-transac, int-pagtos-supcard-ocor.num-parcela) @ l-acr ~
int-pagtos-supcard-ocor.cnpj int-pagtos-supcard-ocor.dat-vencto-parcela ~
int-pagtos-supcard.cod-evento int-pagtos-supcard-ocor.num-bordero ~
int-pagtos-supcard-ocor.num-transac int-pagtos-supcard-ocor.num-parcela ~
int-pagtos-supcard-ocor.qtd-tot-parcelas ~
int-pagtos-supcard-ocor.val-parcela int-pagtos-supcard-ocor.val-compra ~
int-pagtos-supcard-ocor.val-lancamento ~
fnCalcVlPrev(int-pagtos-supcard-ocor.val-parcela,fnPercClasse(int-pagtos-supcard-ocor.cnpj)) @ de-vl-prev ~
fnPercClasse(int-pagtos-supcard-ocor.cnpj) @ de-perc-classe 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPagtos 
&Scoped-define QUERY-STRING-brPagtos FOR EACH int-pagtos-supcard ~
      WHERE int-pagtos-supcard.dat-pagto = INPUT FRAME default-frame dt-pagto ~
 AND int-pagtos-supcard.log-lancto-futuro = NO NO-LOCK, ~
      EACH int-pagtos-supcard-ocor OF int-pagtos-supcard NO-LOCK ~
    BY int-pagtos-supcard-ocor.cnpj ~
       BY int-pagtos-supcard-ocor.num-transac ~
        BY int-pagtos-supcard-ocor.num-parcela INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brPagtos OPEN QUERY brPagtos FOR EACH int-pagtos-supcard ~
      WHERE int-pagtos-supcard.dat-pagto = INPUT FRAME default-frame dt-pagto ~
 AND int-pagtos-supcard.log-lancto-futuro = NO NO-LOCK, ~
      EACH int-pagtos-supcard-ocor OF int-pagtos-supcard NO-LOCK ~
    BY int-pagtos-supcard-ocor.cnpj ~
       BY int-pagtos-supcard-ocor.num-transac ~
        BY int-pagtos-supcard-ocor.num-parcela INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPagtos int-pagtos-supcard ~
int-pagtos-supcard-ocor
&Scoped-define FIRST-TABLE-IN-QUERY-brPagtos int-pagtos-supcard
&Scoped-define SECOND-TABLE-IN-QUERY-brPagtos int-pagtos-supcard-ocor


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brPagtos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS dt-pagto btCheck btPendentes btLiquidar ~
btExit brPagtos btPrev btNext 
&Scoped-Define DISPLAYED-OBJECTS dt-pagto de-vl-tot-bruto de-vl-tot-perc ~
de-vl-tot-liquido de-vl-tot-sel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnACR C-Win 
FUNCTION fnACR RETURNS LOGICAL
  ( p-num-transac AS CHARACTER, p-num-parcela AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCalcPerc C-Win 
FUNCTION fnCalcPerc RETURNS DECIMAL
  ( de-vl-parcela    AS DECIMAL,
    de-vl-lancamento AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCalcVlPrev C-Win 
FUNCTION fnCalcVlPrev RETURNS DECIMAL
  ( de-vl-parcela AS DECIMAL,
    de-vl-taxa    AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPercClasse C-Win 
FUNCTION fnPercClasse RETURNS DECIMAL
  ( c-cnpj-cliente AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Atualizar" 
     SIZE 5 BY 1 TOOLTIP "Atualizar informaá‰es".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1 TOOLTIP "Fechar"
     FONT 4.

DEFINE BUTTON btLiquidar 
     LABEL "&Liquidar" 
     SIZE 12 BY 1 TOOLTIP "Liquidar todos os t°tulos em tela".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1 TOOLTIP "Pr¢xima data".

DEFINE BUTTON btPendentes 
     LABEL "Tit &Pendentes" 
     SIZE 12 BY 1 TOOLTIP "Verificar t°tulos pendentes em datas anteriores".

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1 TOOLTIP "Data anterior".

DEFINE VARIABLE de-vl-tot-bruto AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Val Tot Bruto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Total dos valores das parcelas" NO-UNDO.

DEFINE VARIABLE de-vl-tot-liquido AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Val Tot Liquido" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Total do pagamento enviado no arquivo" NO-UNDO.

DEFINE VARIABLE de-vl-tot-perc AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Val Tot Taxa" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Total da diferenáa entre o valor da parcela e o valor do lanáamento" NO-UNDO.

DEFINE VARIABLE de-vl-tot-sel AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Selecionado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Total dos valores de lanáamento selecionados na tela" NO-UNDO.

DEFINE VARIABLE dt-pagto AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPagtos FOR 
      int-pagtos-supcard, 
      int-pagtos-supcard-ocor SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPagtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPagtos C-Win _STRUCTURED
  QUERY brPagtos NO-LOCK DISPLAY
      fnACR(int-pagtos-supcard-ocor.num-transac, int-pagtos-supcard-ocor.num-parcela) @ l-acr COLUMN-LABEL "ACR" FORMAT "Sim/N∆o":U
      int-pagtos-supcard-ocor.cnpj COLUMN-LABEL "CNPJ Cliente" FORMAT "x(14)":U
            WIDTH 13.43
      int-pagtos-supcard-ocor.dat-vencto-parcela COLUMN-LABEL "Dat Vencto" FORMAT "99/99/9999":U
            WIDTH 9.43
      int-pagtos-supcard.cod-evento FORMAT "x(07)":U WIDTH 7.43
      int-pagtos-supcard-ocor.num-bordero FORMAT "x(06)":U WIDTH 9.57
      int-pagtos-supcard-ocor.num-transac FORMAT "x(14)":U WIDTH 13.86
      int-pagtos-supcard-ocor.num-parcela COLUMN-LABEL "Parc" FORMAT ">9":U
            WIDTH 3.86
      int-pagtos-supcard-ocor.qtd-tot-parcelas COLUMN-LABEL "Tot Parc" FORMAT ">9":U
            WIDTH 6.43
      int-pagtos-supcard-ocor.val-parcela COLUMN-LABEL "Val Parcela" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 10.86
      int-pagtos-supcard-ocor.val-compra COLUMN-LABEL "Val Compra" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 11
      int-pagtos-supcard-ocor.val-lancamento COLUMN-LABEL "Val Lanáamento" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.86
      fnCalcVlPrev(int-pagtos-supcard-ocor.val-parcela,fnPercClasse(int-pagtos-supcard-ocor.cnpj)) @ de-vl-prev COLUMN-LABEL "Valor Previsto" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 12
      fnPercClasse(int-pagtos-supcard-ocor.cnpj) @ de-perc-classe COLUMN-LABEL "% Classe" FORMAT ">>9.99":U
            WIDTH 7
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 119 BY 16.92
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     dt-pagto AT ROW 1.38 COL 21.29 COLON-ALIGNED WIDGET-ID 2
     btCheck AT ROW 1.29 COL 36.14 WIDGET-ID 28
     btPendentes AT ROW 1.25 COL 89.29 HELP
          "Verificar T°tulos Pendentes" WIDGET-ID 42
     btLiquidar AT ROW 1.25 COL 101.57 HELP
          "Liquidar os T°tulos Selecionados" WIDGET-ID 40
     btExit AT ROW 1.25 COL 116.57 HELP
          "Sair" WIDGET-ID 44
     brPagtos AT ROW 2.58 COL 2 WIDGET-ID 200
     de-vl-tot-bruto AT ROW 19.67 COL 9.86 COLON-ALIGNED HELP
          "Valor do pagamento" WIDGET-ID 30
     de-vl-tot-perc AT ROW 19.67 COL 32.57 COLON-ALIGNED HELP
          "Valor do pagamento" WIDGET-ID 32
     de-vl-tot-liquido AT ROW 19.67 COL 56.72 COLON-ALIGNED HELP
          "Valor do pagamento" WIDGET-ID 34
     de-vl-tot-sel AT ROW 19.67 COL 106.43 COLON-ALIGNED HELP
          "Valor do pagamento" WIDGET-ID 36
     btPrev AT ROW 1.29 COL 1.86 HELP
          "Ocorrància anterior" WIDGET-ID 48
     btNext AT ROW 1.29 COL 5.86 HELP
          "Pr¢xima ocorrància" WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120.86 BY 19.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Conciliaá∆o SupplierCard"
         HEIGHT             = 19.67
         WIDTH              = 120.86
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brPagtos btExit DEFAULT-FRAME */
ASSIGN 
       brPagtos:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR FILL-IN de-vl-tot-bruto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-tot-liquido IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-tot-perc IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-tot-sel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPagtos
/* Query rebuild information for BROWSE brPagtos
     _TblList          = "mgesp.int-pagtos-supcard,mgesp.int-pagtos-supcard-ocor OF mgesp.int-pagtos-supcard"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _OrdList          = "mgesp.int-pagtos-supcard-ocor.cnpj|yes,mgesp.int-pagtos-supcard-ocor.num-transac|yes,mgesp.int-pagtos-supcard-ocor.num-parcela|yes"
     _Where[1]         = "mgesp.int-pagtos-supcard.dat-pagto = INPUT FRAME default-frame dt-pagto
 AND mgesp.int-pagtos-supcard.log-lancto-futuro = NO"
     _FldNameList[1]   > "_<CALC>"
"fnACR(int-pagtos-supcard-ocor.num-transac, int-pagtos-supcard-ocor.num-parcela) @ l-acr" "ACR" "Sim/N∆o" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.int-pagtos-supcard-ocor.cnpj
"int-pagtos-supcard-ocor.cnpj" "CNPJ Cliente" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.int-pagtos-supcard-ocor.dat-vencto-parcela
"int-pagtos-supcard-ocor.dat-vencto-parcela" "Dat Vencto" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.int-pagtos-supcard.cod-evento
"int-pagtos-supcard.cod-evento" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.int-pagtos-supcard-ocor.num-bordero
"int-pagtos-supcard-ocor.num-bordero" ? ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.int-pagtos-supcard-ocor.num-transac
"int-pagtos-supcard-ocor.num-transac" ? ? "character" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.int-pagtos-supcard-ocor.num-parcela
"int-pagtos-supcard-ocor.num-parcela" "Parc" ? "integer" ? ? ? ? ? ? no ? no no "3.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.int-pagtos-supcard-ocor.qtd-tot-parcelas
"int-pagtos-supcard-ocor.qtd-tot-parcelas" "Tot Parc" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > mgesp.int-pagtos-supcard-ocor.val-parcela
"int-pagtos-supcard-ocor.val-parcela" "Val Parcela" ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > mgesp.int-pagtos-supcard-ocor.val-compra
"int-pagtos-supcard-ocor.val-compra" "Val Compra" ? "decimal" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > mgesp.int-pagtos-supcard-ocor.val-lancamento
"int-pagtos-supcard-ocor.val-lancamento" "Val Lanáamento" ? "decimal" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fnCalcVlPrev(int-pagtos-supcard-ocor.val-parcela,fnPercClasse(int-pagtos-supcard-ocor.cnpj)) @ de-vl-prev" "Valor Previsto" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fnPercClasse(int-pagtos-supcard-ocor.cnpj) @ de-perc-classe" "% Classe" ">>9.99" ? ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPagtos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Conciliaá∆o SupplierCard */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Conciliaá∆o SupplierCard */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPagtos
&Scoped-define SELF-NAME brPagtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPagtos C-Win
ON MOUSE-EXTEND-CLICK OF brPagtos IN FRAME DEFAULT-FRAME
DO:
    APPLY "MOUSE-SELECT-CLICK" TO BROWSE brPagtos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPagtos C-Win
ON MOUSE-SELECT-CLICK OF brPagtos IN FRAME DEFAULT-FRAME
DO:
    RUN pi-totais-selecao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPagtos C-Win
ON MOUSE-SELECT-DBLCLICK OF brPagtos IN FRAME DEFAULT-FRAME
DO:
    FIND FIRST tit_acr NO-LOCK
        WHERE  tit_acr.cod_estab       = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,1,4)))
        AND    tit_acr.cod_espec_docto = "DM"
        AND    tit_acr.cod_ser_docto   = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,5,3)))
        AND    tit_acr.cod_tit_acr     = SUBSTRING(int-pagtos-supcard-ocor.num-transac,8,7)
        AND    tit_acr.cod_parcela     = STRING(int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
    IF  AVAIL  tit_acr THEN DO:
        ASSIGN v_rec_tit_acr = RECID(tit_acr).
        RUN prgfin/acr/acr212aa.p.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPagtos C-Win
ON ROW-DISPLAY OF brPagtos IN FRAME DEFAULT-FRAME
DO:
    /* Se o valor do lanáamento Ç negativo, deixa vermelho */
    IF  int-pagtos-supcard-ocor.val-lancamento < 0 THEN
        ASSIGN int-pagtos-supcard-ocor.val-lancamento:FGCOLOR IN BROWSE brPagtos = 12.

    /* Se o valor previsto e o valor de lanáamento estiverem igual, deixa eles verde */
    IF  fnCalcVlPrev(int-pagtos-supcard-ocor.val-parcela,fnPercClasse(int-pagtos-supcard-ocor.cnpj)) = int-pagtos-supcard-ocor.val-lancamento THEN
        ASSIGN int-pagtos-supcard-ocor.val-lancamento:FGCOLOR IN BROWSE brPagtos = 10
               de-vl-prev:FGCOLOR                             IN BROWSE brPagtos = 10.

    /* Se o pagamento j† foi conciliado, deixa cinza */
    IF  int-pagtos-supcard-ocor.log-conciliado THEN DO:
        ASSIGN l-acr:FGCOLOR                                      IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.cnpj:FGCOLOR               IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.dat-vencto-parcela:FGCOLOR IN BROWSE brPagtos = 8
               int-pagtos-supcard.cod-evento:FGCOLOR              IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.num-bordero:FGCOLOR        IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.num-transac:FGCOLOR        IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.num-parcela:FGCOLOR        IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.qtd-tot-parcelas:FGCOLOR   IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.val-parcela:FGCOLOR        IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.val-compra:FGCOLOR         IN BROWSE brPagtos = 8
               int-pagtos-supcard-ocor.val-lancamento:FGCOLOR     IN BROWSE brPagtos = 8
               de-vl-prev:FGCOLOR                                 IN BROWSE brPagtos = 8
               de-perc-classe:FGCOLOR                             IN BROWSE brPagtos = 8.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck C-Win
ON CHOOSE OF btCheck IN FRAME DEFAULT-FRAME /* Atualizar */
DO:
    RUN pi-totais-pagtos.

    {&OPEN-QUERY-brPagtos}

    IF  AVAIL int-pagtos-supcard THEN
        ASSIGN btLiquidar:SENSITIVE IN FRAME default-frame = YES.
    ELSE
        ASSIGN btLiquidar:SENSITIVE IN FRAME default-frame = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLiquidar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLiquidar C-Win
ON CHOOSE OF btLiquidar IN FRAME DEFAULT-FRAME /* Liquidar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Deseja conciliar todos os pagamentos?~~":U +
                             "Ao responder sim, todos os pagamentos exibidos em tela ser∆o conciliados.":U +
                             "Caso contr†rio, nenhum pagamento ser† conciliado.").
    IF  RETURN-VALUE = "YES" THEN DO:
        bk-liquida-titulo:
        DO TRANSACTION ON ERROR UNDO bk-liquida-titulo, LEAVE bk-liquida-titulo
                       ON STOP  UNDO bk-liquida-titulo, LEAVE bk-liquida-titulo:
            RUN pi-liquidar-titulos.
            IF RETURN-VALUE = "NOK" THEN
                UNDO bk-liquida-titulo, LEAVE bk-liquida-titulo.

            THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = NO.
            RUN esp/acr/esacr003.w.
            THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = YES. 

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 27100,
                               INPUT "Deseja efetivar a liquidaá∆o?":U).

            IF RETURN-VALUE = "NO":U THEN
                UNDO bk-liquida-titulo, LEAVE bk-liquida-titulo.
        END.
    END.

    APPLY "CHOOSE" TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext C-Win
ON CHOOSE OF btNext IN FRAME DEFAULT-FRAME /* Next */
DO:
    RUN pi-navega IN THIS-PROCEDURE (INPUT "Next").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPendentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPendentes C-Win
ON CHOOSE OF btPendentes IN FRAME DEFAULT-FRAME /* Tit Pendentes */
DO:
    RUN esp/acr/esacr047b.w (INPUT INPUT FRAME default-frame dt-pagto).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev C-Win
ON CHOOSE OF btPrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
    RUN pi-navega IN THIS-PROCEDURE (INPUT "Prev").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN afterInitializeInterface.

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface C-Win 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  c-seg-usuario = "" THEN
        ASSIGN c-usuario = v_cod_usuar_corren.
    ELSE
        ASSIGN c-usuario = c-seg-usuario.

    /* Valida se o usu†rio que est† acessando a tela tem permiss∆o para isto. */
    ASSIGN l-erro = YES.
    FIND FIRST ponto-programa NO-LOCK
        WHERE  ponto-programa.nome-programa = "supplierCard"
        AND    ponto-programa.ponto         = 1 NO-ERROR.
    IF  AVAIL  ponto-programa THEN DO:
        IF  CAN-FIND(FIRST conteudo-programa NO-LOCK
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                     AND   conteudo-programa.conteudo     = c-usuario) THEN
            ASSIGN l-erro = NO.
    END.

    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Usu†rio sem permiss∆o para acessar esse programa.~~Favor entrar em contato com o Financeiro.":U).

        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN "NOK":U.
    END.

    ASSIGN dt-pagto = TODAY.
    
    DISPLAY dt-pagto
        WITH FRAME default-frame.

    APPLY "CHOOSE" TO btCheck IN FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY dt-pagto de-vl-tot-bruto de-vl-tot-perc de-vl-tot-liquido 
          de-vl-tot-sel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE dt-pagto btCheck btPendentes btLiquidar btExit brPagtos btPrev btNext 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-liquidar-titulos C-Win 
PROCEDURE pi-liquidar-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-verificado AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-int-pagtos-supcard-ocor.

    ASSIGN l-verificado = NO.

    /* Monta a temp-table com todos os pagtos em tela */
    FOR EACH  bf-int-pagtos-supcard NO-LOCK
        WHERE bf-int-pagtos-supcard.dat-pagto         = INPUT FRAME default-frame dt-pagto
        AND   bf-int-pagtos-supcard.log-lancto-futuro = NO,
        EACH  bf-int-pagtos-supcard-ocor OF bf-int-pagtos-supcard NO-LOCK
        BY    bf-int-pagtos-supcard-ocor.cnpj
        BY    bf-int-pagtos-supcard-ocor.num-transac
        BY    bf-int-pagtos-supcard-ocor.num-parcela:

        /* Valida se possui T°tulo no Contas Ö Receber (ACR) */
        IF NOT l-verificado THEN DO:
            IF NOT CAN-FIND(FIRST tit_acr NO-LOCK
                            WHERE tit_acr.cod_estab       = STRING(INTEGER(SUBSTRING(bf-int-pagtos-supcard-ocor.num-transac, 1, 4)))
                              AND tit_acr.cod_espec_docto = "DM":U
                              AND tit_acr.cod_ser_docto   = STRING(INTEGER(SUBSTRING(bf-int-pagtos-supcard-ocor.num-transac, 5, 3)))
                              AND tit_acr.cod_tit_acr     = SUBSTRING(bf-int-pagtos-supcard-ocor.num-transac, 8, 7)
                              AND tit_acr.cod_parcela     = STRING(bf-int-pagtos-supcard-ocor.num-parcela, "99":U)) THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 27100,
                                   INPUT "Existe(m) registro(s) sem t°tulo(s) no Contas Ö Receber. Deseja continuar a liquidaá∆o?":U).

                IF RETURN-VALUE = "NO":U THEN
                    RETURN "NOK":U.

                ASSIGN l-verificado = YES.
            END.
        END.

        CREATE tt-int-pagtos-supcard-ocor.
        BUFFER-COPY bf-int-pagtos-supcard-ocor TO tt-int-pagtos-supcard-ocor.
        ASSIGN tt-int-pagtos-supcard-ocor.r-rowid = ROWID(bf-int-pagtos-supcard-ocor).
    END.

    RUN esp/acr/esacr047a.p (INPUT TABLE tt-int-pagtos-supcard-ocor).
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-navega C-Win 
PROCEDURE pi-navega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNaveg AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME default-frame dt-pagto.

    CASE pNaveg:
        WHEN "Prev" THEN
            ASSIGN dt-pagto = dt-pagto - 1.
        WHEN "Next" THEN
            ASSIGN dt-pagto = dt-pagto + 1.
        OTHERWISE
            ASSIGN dt-pagto = dt-pagto.
    END CASE.

    DISPLAY dt-pagto
        WITH FRAME default-frame.

    APPLY "CHOOSE" TO btCheck IN FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totais-pagtos C-Win 
PROCEDURE pi-totais-pagtos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN de-vl-tot-bruto   = 0
           de-vl-tot-perc    = 0
           de-vl-tot-liquido = 0.

    FOR EACH  int-pagtos-supcard NO-LOCK
        WHERE int-pagtos-supcard.dat-pagto = INPUT FRAME default-frame dt-pagto
        AND   NOT int-pagtos-supcard.log-lancto-futuro:

        ASSIGN de-vl-tot-liquido = de-vl-tot-liquido + int-pagtos-supcard.val-pagto.

        FOR EACH  int-pagtos-supcard-ocor OF int-pagtos-supcard NO-LOCK:
            ASSIGN de-vl-tot-bruto = de-vl-tot-bruto +  int-pagtos-supcard-ocor.val-parcela
                   de-vl-tot-perc  = de-vl-tot-perc  + (int-pagtos-supcard-ocor.val-parcela - int-pagtos-supcard-ocor.val-lancamento).
        END.
    END.

    DISP de-vl-tot-bruto
         de-vl-tot-perc
         de-vl-tot-liquido
        WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totais-selecao C-Win 
PROCEDURE pi-totais-selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
    ASSIGN de-vl-tot-sel = 0.

    DO i-cont = 1 TO BROWSE brPagtos:NUM-SELECTED-ROWS:
        brPagtos:FETCH-SELECTED-ROW(i-cont) IN FRAME default-frame.

        /*FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab     = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_espec     = "DM"
            AND    tit_acr.cod_ser_docto = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr   = SUBSTRING(int-pagtos-supcard-ocor.num-transac,8,7)
            AND    tit_acr.cod_parcela   = STRING(int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
        IF  AVAIL tit_acr THEN
            ASSIGN de-vl-tot-sel = de-vl-tot-sel + tit_acr.val_sdo_tit_acr.*/

        ASSIGN de-vl-tot-sel = de-vl-tot-sel + int-pagtos-supcard-ocor.val-lancamento.
    END.

    DISP de-vl-tot-sel
        WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnACR C-Win 
FUNCTION fnACR RETURNS LOGICAL
  ( p-num-transac AS CHARACTER, p-num-parcela AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST tit_acr
        WHERE tit_acr.cod_estab       = STRING(INTEGER(SUBSTRING(p-num-transac, 1, 4)))
          AND tit_acr.cod_espec_docto = "DM":U
          AND tit_acr.cod_ser_docto   = STRING(INTEGER(SUBSTRING(p-num-transac, 5, 3)))
          AND tit_acr.cod_tit_acr     = SUBSTRING(p-num-transac, 8, 7)
          AND tit_acr.cod_parcela     = STRING(p-num-parcela, "99":U) NO-LOCK NO-ERROR.

    RETURN AVAILABLE tit_acr.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCalcPerc C-Win 
FUNCTION fnCalcPerc RETURNS DECIMAL
  ( de-vl-parcela    AS DECIMAL,
    de-vl-lancamento AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.

    ASSIGN de-aux = ((de-vl-parcela - de-vl-lancamento) * 100) / de-vl-parcela.

    IF  de-vl-lancamento < 0 THEN
        ASSIGN de-aux = de-aux - 100.

    RETURN de-aux.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCalcVlPrev C-Win 
FUNCTION fnCalcVlPrev RETURNS DECIMAL
  ( de-vl-parcela AS DECIMAL,
    de-vl-taxa    AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  Calcular o valor previsto que a SupplierCar ir† cobrar da Intelbras
    Notes:  Conforme planilha enviada pela SC
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-dias-antecip AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-qtd-dias     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-dias-aux     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-val-pagto   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-iof      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dt-aux         AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-process     AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-pagto       AS DATE        NO-UNDO.

    IF  int-pagtos-supcard.cod-evento = "DEBIT" OR
        int-pagtos-supcard.cod-evento = "CANCE" THEN DO:
        CASE int-pagtos-supcard-ocor.num-bordero:
            WHEN "BONIFI" /* Bonificaá∆o */ THEN DO:
                ASSIGN de-vl-prev = 0. /* N∆o Ç cobrado pela SC */
            END.
            WHEN "RPASSP" /* Prorrograá∆o de Vencimento */ THEN DO:
                FIND FIRST tit_acr NO-LOCK
                    WHERE  tit_acr.cod_estab       = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,1,4)))
                    AND    tit_acr.cod_espec_docto = "DM"
                    AND    tit_acr.cod_ser_docto   = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,5,3)))
                    AND    tit_acr.cod_tit_acr     = SUBSTRING(int-pagtos-supcard-ocor.num-transac,8,7)
                    AND    tit_acr.cod_parcela     = STRING(int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
                IF  AVAIL  tit_acr THEN
                    ASSIGN i-dias-aux = tit_acr.dat_vencto_tit_acr - tit_acr.dat_vencto_orig.
                ELSE
                    ASSIGN i-dias-aux = 0.

                ASSIGN de-vl-iof = de-vl-parcela * ROUND(1.5 / 36500, 6) * i-dias-aux.
    
                ASSIGN de-vl-prev = (de-vl-parcela * EXP(EXP(de-vl-taxa / 100 + 1, 1 / 30), i-dias-aux)) - de-vl-parcela
                       de-vl-prev = de-vl-prev + de-vl-iof.
            END.
            WHEN "CANCEP" /* Cancelamento Parcial */ OR
            WHEN "RPASSC" /* Juros Cancelamento   */ THEN DO:
                /* Busca o valor que foi pago para a Intelbras */
                ASSIGN dt-pagto = TODAY.
                FOR EACH  bf-int-pagtos-supcard-ocor NO-LOCK
                    WHERE bf-int-pagtos-supcard-ocor.num-transac  = int-pagtos-supcard-ocor.num-transac,
                    FIRST bf-int-pagtos-supcard      NO-LOCK
                    WHERE bf-int-pagtos-supcard.id-pagto          = bf-int-pagtos-supcard-ocor.id-pagto
                    AND   bf-int-pagtos-supcard.cod-evento        = "CREDI"
                    AND   bf-int-pagtos-supcard.log-lancto-futuro = NO:
                    ASSIGN de-val-pagto = bf-int-pagtos-supcard-ocor.val-lancamento
                           dt-pagto     = bf-int-pagtos-supcard.dat-pagto.
                END.

                /* Busca a nota para saber a data de cancelamento */
                FIND FIRST nota-fiscal NO-LOCK
                    WHERE  nota-fiscal.cod-estabel = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,1,4)))
                    AND    nota-fiscal.serie       = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,5,3)))
                    AND    nota-fiscal.nr-nota-fis = SUBSTRING(int-pagtos-supcard-ocor.num-transac,8,7) NO-ERROR.
                IF  AVAIL  nota-fiscal THEN DO:
                    IF  nota-fiscal.dt-cancela = ? THEN DO:
                        FIND FIRST devol-cli NO-LOCK
                            WHERE  devol-cli.cod-estabel = nota-fiscal.cod-estabel
                            AND    devol-cli.serie       = nota-fiscal.serie
                            AND    devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                        IF  AVAIL  devol-cli THEN
                            ASSIGN dt-aux = devol-cli.dt-devol.
                        ELSE
                            ASSIGN dt-aux = nota-fiscal.dt-emis-nota.
                    END.
                    ELSE
                        ASSIGN dt-aux = nota-fiscal.dt-cancela.
                    
                    ASSIGN i-dias-aux = dt-aux - dt-pagto.
                END.
                ELSE
                    ASSIGN i-dias-aux = 1.

                ASSIGN de-vl-prev = (de-val-pagto * EXP(EXP((de-vl-taxa / 100) + 1, 1 / 30), i-dias-aux)) - de-val-pagto.
            END.
            OTHERWISE DO: /* Cancelamentos Total */
                /* Busca o valor que foi pago para a Intelbras */
                ASSIGN dt-pagto = TODAY.
                FOR EACH  bf-int-pagtos-supcard-ocor NO-LOCK
                    WHERE bf-int-pagtos-supcard-ocor.num-transac  = int-pagtos-supcard-ocor.num-transac,
                    FIRST bf-int-pagtos-supcard      NO-LOCK
                    WHERE bf-int-pagtos-supcard.id-pagto          = bf-int-pagtos-supcard-ocor.id-pagto
                    AND   bf-int-pagtos-supcard.cod-evento        = "CREDI"
                    AND   bf-int-pagtos-supcard.log-lancto-futuro = NO:
                    ASSIGN de-vl-prev = bf-int-pagtos-supcard-ocor.val-lancamento * -1.
                END.
            END.
        END CASE.
    END.
    ELSE DO: /* int-pagtos-supcard.cod-evento = "CREDI" */
        ASSIGN i-qtd-dias = 1 /* Quantos dias para tras? */
               dt-process = int-pagtos-supcard.dat-alteracao /* A partir de qual data? */.

        /* Funá∆o para buscar o dia anterior. Se for final de semana, pega a data de sexta. */
        DO WHILE i-qtd-dias > 0:
            ASSIGN dt-process = dt-process - 1.

            FIND FIRST dia_calend_glob
                WHERE dia_calend_glob.cod_calend = "Fiscal":U
                  AND dia_calend_glob.dat_calend = dt-process NO-LOCK NO-ERROR.

            IF dia_calend_glob.log_dia_util THEN /* Veirifica se Ç dia £til */
                ASSIGN i-qtd-dias = i-qtd-dias - 1.

/*             IF  WEEKDAY(dt-process) <> 1 /* Domingo */ AND  */
/*                 WEEKDAY(dt-process) <> 7 /* S†bado  */ THEN */
/*                 ASSIGN i-qtd-dias = i-qtd-dias - 1.         */
        END.

        ASSIGN i-dias-antecip = int-pagtos-supcard-ocor.dat-vencto-parcela - dt-process.

        ASSIGN de-vl-prev = de-vl-parcela * (1 - (EXP(((de-vl-taxa / 100) + 1), (i-dias-antecip / 30)) - 1)).
    END.

    RETURN ROUND(de-vl-prev, 2).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPercClasse C-Win 
FUNCTION fnPercClasse RETURNS DECIMAL
  ( c-cnpj-cliente AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(c-cnpj-cliente,1,8) NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN DO:
        FIND LAST int-classe-cli-supcard NO-LOCK
            WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-ERROR.
        IF  NOT AVAIL int-classe-cli-supcard THEN
            RETURN 0.

        IF  int-pagtos-supcard.cod-evento = "DEBIT" OR
            int-pagtos-supcard.cod-evento = "CANCE" THEN DO:
            CASE int-pagtos-supcard-ocor.num-bordero:
                WHEN "BONIFI" /* DÇbito por Lanáamento de Bonificaá∆o */ THEN
                    RETURN int-classe-cli-supcard.val-taxa-adm.
                WHEN "RPASSP" /* Juros por Prorrogaá∆o de Vencimento */ THEN
                    RETURN int-classe-cli-supcard.val-taxa-prorrog.
                OTHERWISE
                    RETURN int-classe-cli-supcard.val-taxa-canc-devol.
            END CASE.
        END.
        ELSE DO:
            RETURN int-classe-cli-supcard.val-taxa-adm.
        END.
    END.
    ELSE
        RETURN 0.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

