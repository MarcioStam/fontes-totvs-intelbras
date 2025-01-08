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
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr AS RECID NO-UNDO.

DEFINE VARIABLE c-des-envio    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-rej      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-by           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-coluna       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista-layout AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-vl-nota     AS DECIMAL     NO-UNDO.

DEFINE BUFFER bf-int-emitente-supcard-ocor FOR int-emitente-supcard-ocor.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD up-compras   AS LOGICAL
    FIELD transacoes   AS LOGICAL
    FIELD atu-clientes AS LOGICAL
    FIELD pagtos       AS LOGICAL
    FIELD param-compra AS LOGICAL
    FIELD motivo       AS LOGICAL
    FIELD clientes     AS LOGICAL
    FIELD compras      AS LOGICAL
    FIELD pendencias   AS LOGICAL
    FIELD limite       AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brOcor

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-emitente-supcard-ocor ~
int-pendencias-supcard

/* Definitions for BROWSE brOcor                                        */
&Scoped-define FIELDS-IN-QUERY-brOcor int-emitente-supcard-ocor.raiz-cnpj int-emitente-supcard-ocor.dat-avaliacao int-emitente-supcard-ocor.ind-ocor fnDesEnvio(int-emitente-supcard-ocor.ind-env-ret) @ c-des-envio int-emitente-supcard-ocor.num-transac int-emitente-supcard-ocor.num-parcela int-emitente-supcard-ocor.val-limite int-emitente-supcard-ocor.val-limite-sugerido int-emitente-supcard-ocor.log-habilitado int-emitente-supcard-ocor.val-limite-utilizado fnValorNF(int-emitente-supcard-ocor.num-transac) @ de-vl-nota int-emitente-supcard-ocor.qtd-dias-atraso fnDesMotRej(int-emitente-supcard-ocor.cod-motivo) @ c-des-rej int-emitente-supcard-ocor.nom-arquivo int-emitente-supcard-ocor.seq-avaliacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOcor   
&Scoped-define SELF-NAME brOcor
&Scoped-define OPEN-QUERY-brOcor IF  NOT INPUT FRAME default-frame tg-nota THEN DO:     OPEN QUERY {&SELF-NAME} FOR EACH  int-emitente-supcard-ocor NO-LOCK                                 WHERE int-emitente-supcard-ocor.raiz-cnpj     >= INPUT FRAME default-frame c-raiz-cnpj-ini                                 AND   int-emitente-supcard-ocor.raiz-cnpj     <= INPUT FRAME default-frame c-raiz-cnpj-fim                                 AND   int-emitente-supcard-ocor.dat-avaliacao >= INPUT FRAME default-frame dat-avaliacao-ini                                 AND   int-emitente-supcard-ocor.dat-avaliacao <= INPUT FRAME default-frame dat-avaliacao-fim                                 AND   int-emitente-supcard-ocor.num-transac   >= INPUT FRAME default-frame c-num-transac-ini                                 AND   int-emitente-supcard-ocor.num-transac   <= INPUT FRAME default-frame c-num-transac-fim                                 AND   int-emitente-supcard-ocor.num-parcela   >= INPUT FRAME default-frame c-num-parcela-ini                                 AND   int-emitente-supcard-ocor.num-parcela   <= INPUT FRAME default-frame c-num-parcela-fim                                 AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, ~
       c-lista-layout) > 0)                                 AND IF INPUT FRAME default-frame rs-envio = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = INPUT FRAME default-frame rs-envio INDEXED-REPOSITION. END. ELSE DO:     OPEN QUERY {&SELF-NAME} FOR EACH  int-emitente-supcard-ocor NO-LOCK                                 WHERE int-emitente-supcard-ocor.raiz-cnpj     >= INPUT FRAME default-frame c-raiz-cnpj-ini                                 AND   int-emitente-supcard-ocor.raiz-cnpj     <= INPUT FRAME default-frame c-raiz-cnpj-fim                                 AND   int-emitente-supcard-ocor.dat-avaliacao >= INPUT FRAME default-frame dat-avaliacao-ini                                 AND   int-emitente-supcard-ocor.dat-avaliacao <= INPUT FRAME default-frame dat-avaliacao-fim                                 AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, ~
       c-lista-layout) > 0)                                 AND   int-emitente-supcard-ocor.num-transac MATCHES "*" + INPUT FRAME default-frame c-num-transac + "*"                                 AND IF INPUT FRAME default-frame rs-envio = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = INPUT FRAME default-frame rs-envio INDEXED-REPOSITION. END.
&Scoped-define TABLES-IN-QUERY-brOcor int-emitente-supcard-ocor
&Scoped-define FIRST-TABLE-IN-QUERY-brOcor int-emitente-supcard-ocor


/* Definitions for BROWSE brPendencias                                  */
&Scoped-define FIELDS-IN-QUERY-brPendencias int-pendencias-supcard.identific fnRequisicao(int-pendencias-supcard.identific) fnOrigem(int-pendencias-supcard.identific,int-pendencias-supcard.cod-estab, int-pendencias-supcard.cod-tit-acr, int-pendencias-supcard.cod-ser-docto) int-pendencias-supcard.dat-criacao int-pendencias-supcard.cod-usuar int-pendencias-supcard.cod-estab int-pendencias-supcard.cod-ser-docto int-pendencias-supcard.cod-tit-acr int-pendencias-supcard.cod-espec-docto int-pendencias-supcard.cod-parcela int-pendencias-supcard.val-lancamento int-pendencias-supcard.val-limite-sugerido int-pendencias-supcard.dias-prorrog fnTipoBloqueio(int-pendencias-supcard.tipo-bloqueio) int-pendencias-supcard.dat-bloqueio int-pendencias-supcard.dat-envio int-pendencias-supcard.dat-retorno int-pendencias-supcard.log-emergencial int-pendencias-supcard.log-manual int-pendencias-supcard.obs   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPendencias   
&Scoped-define SELF-NAME brPendencias
&Scoped-define OPEN-QUERY-brPendencias IF  AVAIL int-emitente-supcard-ocor THEN DO:     IF  int-emitente-supcard-ocor.num-transac <> "" THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK                                     WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente, ~
      1, ~
      8) = INPUT BROWSE brOcor int-emitente-supcard-ocor.raiz-cnpj                                     AND   int-pendencias-supcard.cod-estab                   = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac, ~
      1, ~
      4)))                                     AND   int-pendencias-supcard.cod-ser-docto               = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac, ~
      5, ~
      3)))                                     AND   int-pendencias-supcard.cod-tit-acr                 = SUBSTRING(int-emitente-supcard-ocor.num-transac, ~
      8, ~
      7)                                     AND   int-pendencias-supcard.cod-espec-docto             = "DM"                                     BY    int-pendencias-supcard.dat-criacao DESC                                     BY    int-pendencias-supcard.identific.     END.     ELSE DO:         OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK                                     WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente, ~
      1, ~
      8) = INPUT BROWSE brOcor int-emitente-supcard-ocor.raiz-cnpj                                     BY    int-pendencias-supcard.dat-criacao DESC                                     BY    int-pendencias-supcard.identific.     END. END. ELSE DO:     OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK                                 WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente, ~
      1, ~
      8) >= INPUT FRAME default-frame c-raiz-cnpj-ini                                 AND   SUBSTRING(int-pendencias-supcard.cnpj-cliente, ~
      1, ~
      8) <= INPUT FRAME default-frame c-raiz-cnpj-fim                                 BY    int-pendencias-supcard.dat-criacao DESC                                 BY    int-pendencias-supcard.identific. END.  RUN pi-controla-pendencias IN THIS-PROCEDURE.
&Scoped-define TABLES-IN-QUERY-brPendencias int-pendencias-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-brPendencias int-pendencias-supcard


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brOcor}~
    ~{&OPEN-QUERY-brPendencias}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brPendencias ed-obs btLayouts c-num-transac ~
tg-nota btExcluir btIncluir text-selecao c-raiz-cnpj-ini c-raiz-cnpj-fim ~
dat-avaliacao-ini dat-avaliacao-fim c-num-transac-ini c-num-parcela-ini ~
c-num-transac-fim c-num-parcela-fim rs-envio btCheck text-ocorrencias ~
text-pendencias btFechar IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 RECT-1 IMAGE-5 ~
IMAGE-6 RECT-2 RECT-3 brOcor 
&Scoped-Define DISPLAYED-OBJECTS ed-obs c-num-transac tg-nota text-selecao ~
c-raiz-cnpj-ini c-raiz-cnpj-fim dat-avaliacao-ini dat-avaliacao-fim ~
c-num-transac-ini c-num-parcela-ini c-num-transac-fim c-num-parcela-fim ~
rs-envio text-ocorrencias text-pendencias 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesEnvio C-Win 
FUNCTION fnDesEnvio RETURNS CHARACTER
  (pCodEnvio AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesMotRej C-Win 
FUNCTION fnDesMotRej RETURNS CHARACTER
  (i-cod-motivo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRequisicao C-Win 
FUNCTION fnRequisicao RETURNS CHARACTER
  (pIdentific AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRequisicao C-Win 
FUNCTION fnOrigem RETURNS CHARACTER
  (pIdentific AS INTEGER,
   pEstab     AS CHAR,
   pNota      AS CHAR,
   pSer       AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoBloqueio C-Win 
FUNCTION fnTipoBloqueio RETURNS CHARACTER
  (pTipoBloqueio AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValorNF C-Win 
FUNCTION fnValorNF RETURNS DECIMAL
  (pNumTransac AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Atualizar" 
     SIZE 11.14 BY 2.63 TOOLTIP "Atualizar informa‡äes".

DEFINE BUTTON btExcluir 
     LABEL "&Excluir" 
     SIZE 9 BY 1 TOOLTIP "Excluir a pendˆncia selecionada".

DEFINE BUTTON btFechar 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "&Fechar" 
     SIZE 5 BY 1.25 TOOLTIP "Fechar"
     FONT 4.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 9 BY 1 TOOLTIP "Incluir uma nova pendˆncia".

DEFINE BUTTON btLayouts 
     LABEL "Layouts" 
     SIZE 10 BY 1 TOOLTIP "Selecionar os layouts desejados.".

DEFINE VARIABLE ed-obs AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 101 BY 2.04 NO-UNDO.

DEFINE VARIABLE c-num-parcela-fim AS CHARACTER FORMAT "x(2)" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-parcela-ini AS CHARACTER FORMAT "x(2)" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-transac AS CHARACTER FORMAT "X(14)":U 
     LABEL "Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-transac-fim AS CHARACTER FORMAT "x(14)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-transac-ini AS CHARACTER FORMAT "x(14)" 
     LABEL "Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-raiz-cnpj-fim AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-raiz-cnpj-ini AS CHARACTER FORMAT "x(10)" 
     LABEL "Raiz CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE dat-avaliacao-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE dat-avaliacao-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Avalia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE text-ocorrencias AS CHARACTER FORMAT "X(10)":U INITIAL "Ocorrˆncias" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-pendencias AS CHARACTER FORMAT "X(10)":U INITIAL "Pendˆncias" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-selecao AS CHARACTER FORMAT "X(10)":U INITIAL "Sele‡Æo" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE VARIABLE rs-envio AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Envio", 1,
"Retorno", 2,
"Ambos", 3
     SIZE 12 BY 2.96 TOOLTIP "Tipo de arquivo" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101.57 BY 4.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 8.38.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 7.33.

DEFINE VARIABLE tg-nota AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal?" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOcor FOR 
      int-emitente-supcard-ocor SCROLLING.

DEFINE QUERY brPendencias FOR 
      int-pendencias-supcard SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOcor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOcor C-Win _FREEFORM
  QUERY brOcor NO-LOCK DISPLAY
      int-emitente-supcard-ocor.raiz-cnpj                             WIDTH 11    FORMAT "x(10)":U
      int-emitente-supcard-ocor.dat-avaliacao                         WIDTH 11    FORMAT "99/99/9999":U
      int-emitente-supcard-ocor.ind-ocor                              WIDTH 7     FORMAT "x(8)":U           COLUMN-LABEL "Layout"
      fnDesEnvio(int-emitente-supcard-ocor.ind-env-ret) @ c-des-envio WIDTH 10    FORMAT "x(10)":U          COLUMN-LABEL "Tipo Arquivo"
      int-emitente-supcard-ocor.num-transac                           WIDTH 14    FORMAT "x(14)"            COLUMN-LABEL "Transa‡Æo"
      int-emitente-supcard-ocor.num-parcela                           WIDTH 4     FORMAT "x(02)"            COLUMN-LABEL "Parc"
      int-emitente-supcard-ocor.val-limite                            WIDTH 13    FORMAT ">>>,>>>,>>9.99":U
      int-emitente-supcard-ocor.val-limite-sugerido                   WIDTH 13    FORMAT ">>>,>>>,>>9.99":U COLUMN-LABEL "Val Lim Sugerido"
      int-emitente-supcard-ocor.log-habilitado                        WIDTH 10    FORMAT "Sim/NÆo":U
      int-emitente-supcard-ocor.val-limite-utilizado                  WIDTH 14    FORMAT ">>>,>>>,>>9.99":U COLUMN-LABEL "Val Lim Utilizado"
      fnValorNF(int-emitente-supcard-ocor.num-transac) @ de-vl-nota   WIDTH 14    FORMAT ">>>,>>>,>>9.99":U COLUMN-LABEL "Valor Nota"
      int-emitente-supcard-ocor.qtd-dias-atraso                       WIDTH 12    FORMAT ">>9":U
      fnDesMotRej(int-emitente-supcard-ocor.cod-motivo) @ c-des-rej   WIDTH 22    FORMAT "x(100)"           COLUMN-LABEL "Motivo Retorno"
      int-emitente-supcard-ocor.nom-arquivo                           WIDTH 20    FORMAT "x(50)":U
      int-emitente-supcard-ocor.seq-avaliacao                         WIDTH 7     FORMAT ">>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 7.75
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brPendencias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPendencias C-Win _FREEFORM
  QUERY brPendencias DISPLAY
      int-pendencias-supcard.identific                     WIDTH 4   FORMAT "99":U              COLUMN-LABEL "C¢d"       
      fnRequisicao(int-pendencias-supcard.identific)       WIDTH 26  FORMAT "x(30)":U           COLUMN-LABEL "Requisi‡Æo"
      fnOrigem(int-pendencias-supcard.identific,
               int-pendencias-supcard.cod-estab,
               int-pendencias-supcard.cod-tit-acr,    
               int-pendencias-supcard.cod-ser-docto)       WIDTH 12  FORMAT "x(30)":U           COLUMN-LABEL "Origem"
      int-pendencias-supcard.dat-criacao                   WIDTH 11  FORMAT "99/99/9999":U
      int-pendencias-supcard.cod-estab                     WIDTH 9   FORMAT "x(3)":U            COLUMN-LABEL "Estabel"   
      int-pendencias-supcard.cod-ser-docto                 WIDTH 7   FORMAT "x(3)":U
      int-pendencias-supcard.cod-tit-acr                   WIDTH 10  FORMAT "x(10)":U
      int-pendencias-supcard.cod-espec-docto               WIDTH 7   FORMAT "x(3)":U            COLUMN-LABEL "Espec"     
      int-pendencias-supcard.cod-parcela                   WIDTH 5   FORMAT "x(2)":U            COLUMN-LABEL "Parc"      
      int-pendencias-supcard.cod-usuar                     WIDTH 10  FORMAT "x(12)"
      int-pendencias-supcard.val-lancamento                WIDTH 13  FORMAT "->>>,>>>,>>9.99":U
      int-pendencias-supcard.val-limite-sugerido           WIDTH 13  FORMAT "->>>,>>>,>>9.99":U
      int-pendencias-supcard.dias-prorrog                  WIDTH 10  FORMAT ">>9":U             COLUMN-LABEL "Dias Prorrog"
      fnTipoBloqueio(int-pendencias-supcard.tipo-bloqueio) WIDTH 20  FORMAT "x(30)":U           COLUMN-LABEL "Tipo Bloqueio"
      int-pendencias-supcard.dat-bloqueio                  WIDTH 10  FORMAT "99/99/9999":U
      int-pendencias-supcard.dat-envio                     WIDTH 10  FORMAT "99/99/9999":U
      int-pendencias-supcard.dat-retorno                   WIDTH 10  FORMAT "99/99/9999":U
      int-pendencias-supcard.log-emergencial               WIDTH 10  FORMAT "Sim/NÆo"
      int-pendencias-supcard.log-manual                    WIDTH 8   FORMAT "Sim/NÆo"
      int-pendencias-supcard.obs                           WIDTH 45  FORMAT "x(100)":U          COLUMN-LABEL "Observa‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 5.63
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brPendencias AT ROW 15.5 COL 2.43 WIDGET-ID 300
     ed-obs AT ROW 22.63 COL 1.86 NO-LABEL WIDGET-ID 114
     btLayouts AT ROW 4.5 COL 78.29 WIDGET-ID 112
     c-num-transac AT ROW 4.58 COL 39.57 COLON-ALIGNED WIDGET-ID 110
     tg-nota AT ROW 3.58 COL 43.72 WIDGET-ID 108
     btExcluir AT ROW 21.21 COL 11.72 WIDGET-ID 102
     btIncluir AT ROW 21.21 COL 2.43 WIDGET-ID 100
     text-selecao AT ROW 1 COL 2.29 NO-LABEL WIDGET-ID 66
     c-raiz-cnpj-ini AT ROW 1.58 COL 28 COLON-ALIGNED HELP
          "Raiz do CNPJ" WIDGET-ID 42
     c-raiz-cnpj-fim AT ROW 1.58 COL 55.29 COLON-ALIGNED HELP
          "Raiz do CNPJ" NO-LABEL WIDGET-ID 44
     dat-avaliacao-ini AT ROW 2.58 COL 28 COLON-ALIGNED WIDGET-ID 46
     dat-avaliacao-fim AT ROW 2.58 COL 55.29 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     c-num-transac-ini AT ROW 4.58 COL 22.57 COLON-ALIGNED HELP
          "N£mero da Transa‡Æo" WIDGET-ID 80
     c-num-parcela-ini AT ROW 4.58 COL 36.72 COLON-ALIGNED HELP
          "N£mero da Parcela" NO-LABEL WIDGET-ID 86
     c-num-transac-fim AT ROW 4.58 COL 55.29 COLON-ALIGNED HELP
          "N£mero da Transa‡Æo" NO-LABEL WIDGET-ID 90
     c-num-parcela-fim AT ROW 4.58 COL 69.43 COLON-ALIGNED HELP
          "N£mero da Parcela" NO-LABEL WIDGET-ID 88
     rs-envio AT ROW 1.46 COL 79 NO-LABEL WIDGET-ID 74
     btCheck AT ROW 2.92 COL 91 WIDGET-ID 28
     text-ocorrencias AT ROW 5.92 COL 2.29 NO-LABEL WIDGET-ID 94
     text-pendencias AT ROW 14.79 COL 2.29 NO-LABEL WIDGET-ID 98
     btFechar AT ROW 1.5 COL 97.14 HELP
          "Sair" WIDGET-ID 116
     brOcor AT ROW 6.58 COL 2.43 WIDGET-ID 200
     IMAGE-1 AT ROW 1.58 COL 42.43 WIDGET-ID 16
     IMAGE-2 AT ROW 1.58 COL 53.72 WIDGET-ID 18
     IMAGE-3 AT ROW 2.58 COL 42.43 WIDGET-ID 56
     IMAGE-4 AT ROW 2.58 COL 53.72 WIDGET-ID 58
     RECT-1 AT ROW 1.33 COL 1.43 WIDGET-ID 64
     IMAGE-5 AT ROW 4.58 COL 42.43 WIDGET-ID 82
     IMAGE-6 AT ROW 4.58 COL 53.72 WIDGET-ID 84
     RECT-2 AT ROW 6.25 COL 1.43 WIDGET-ID 92
     RECT-3 AT ROW 15.13 COL 1.43 WIDGET-ID 96
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103 BY 23.79
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
         TITLE              = "Monitor de Ocorrˆncias"
         HEIGHT             = 23.79
         WIDTH              = 103
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
/* BROWSE-TAB brPendencias 1 DEFAULT-FRAME */
/* BROWSE-TAB brOcor RECT-3 DEFAULT-FRAME */
ASSIGN 
       brOcor:ALLOW-COLUMN-SEARCHING IN FRAME DEFAULT-FRAME = TRUE
       brOcor:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

ASSIGN 
       brPendencias:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

ASSIGN 
       ed-obs:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN text-ocorrencias IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-pendencias IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-selecao IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOcor
/* Query rebuild information for BROWSE brOcor
     _START_FREEFORM
IF  NOT INPUT FRAME default-frame tg-nota THEN DO:
    OPEN QUERY {&SELF-NAME} FOR EACH  int-emitente-supcard-ocor NO-LOCK
                                WHERE int-emitente-supcard-ocor.raiz-cnpj     >= INPUT FRAME default-frame c-raiz-cnpj-ini
                                AND   int-emitente-supcard-ocor.raiz-cnpj     <= INPUT FRAME default-frame c-raiz-cnpj-fim
                                AND   int-emitente-supcard-ocor.dat-avaliacao >= INPUT FRAME default-frame dat-avaliacao-ini
                                AND   int-emitente-supcard-ocor.dat-avaliacao <= INPUT FRAME default-frame dat-avaliacao-fim
                                AND   int-emitente-supcard-ocor.num-transac   >= INPUT FRAME default-frame c-num-transac-ini
                                AND   int-emitente-supcard-ocor.num-transac   <= INPUT FRAME default-frame c-num-transac-fim
                                AND   int-emitente-supcard-ocor.num-parcela   >= INPUT FRAME default-frame c-num-parcela-ini
                                AND   int-emitente-supcard-ocor.num-parcela   <= INPUT FRAME default-frame c-num-parcela-fim
                                AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, c-lista-layout) > 0)
                                AND IF INPUT FRAME default-frame rs-envio = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = INPUT FRAME default-frame rs-envio INDEXED-REPOSITION.
END.
ELSE DO:
    OPEN QUERY {&SELF-NAME} FOR EACH  int-emitente-supcard-ocor NO-LOCK
                                WHERE int-emitente-supcard-ocor.raiz-cnpj     >= INPUT FRAME default-frame c-raiz-cnpj-ini
                                AND   int-emitente-supcard-ocor.raiz-cnpj     <= INPUT FRAME default-frame c-raiz-cnpj-fim
                                AND   int-emitente-supcard-ocor.dat-avaliacao >= INPUT FRAME default-frame dat-avaliacao-ini
                                AND   int-emitente-supcard-ocor.dat-avaliacao <= INPUT FRAME default-frame dat-avaliacao-fim
                                AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, c-lista-layout) > 0)
                                AND   int-emitente-supcard-ocor.num-transac MATCHES "*" + INPUT FRAME default-frame c-num-transac + "*"
                                AND IF INPUT FRAME default-frame rs-envio = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = INPUT FRAME default-frame rs-envio INDEXED-REPOSITION.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgesp.int-emitente-supcard-ocor.ind-ocor|yes"
     _Query            is OPENED
*/  /* BROWSE brOcor */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPendencias
/* Query rebuild information for BROWSE brPendencias
     _START_FREEFORM
IF  AVAIL int-emitente-supcard-ocor THEN DO:
    IF  int-emitente-supcard-ocor.num-transac <> "" THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK
                                    WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente,1,8) = INPUT BROWSE brOcor int-emitente-supcard-ocor.raiz-cnpj
                                    AND   int-pendencias-supcard.cod-estab                   = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,1,4)))
                                    AND   int-pendencias-supcard.cod-ser-docto               = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,5,3)))
                                    AND   int-pendencias-supcard.cod-tit-acr                 = SUBSTRING(int-emitente-supcard-ocor.num-transac,8,7)
                                    AND   int-pendencias-supcard.cod-espec-docto             = "DM"
                                    BY    int-pendencias-supcard.dat-criacao DESC
                                    BY    int-pendencias-supcard.identific.
    END.
    ELSE DO:
        OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK
                                    WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente,1,8) = INPUT BROWSE brOcor int-emitente-supcard-ocor.raiz-cnpj
                                    BY    int-pendencias-supcard.dat-criacao DESC
                                    BY    int-pendencias-supcard.identific.
    END.
END.
ELSE DO:
    OPEN QUERY {&SELF-NAME} FOR EACH  int-pendencias-supcard NO-LOCK
                                WHERE SUBSTRING(int-pendencias-supcard.cnpj-cliente,1,8) >= INPUT FRAME default-frame c-raiz-cnpj-ini
                                AND   SUBSTRING(int-pendencias-supcard.cnpj-cliente,1,8) <= INPUT FRAME default-frame c-raiz-cnpj-fim
                                BY    int-pendencias-supcard.dat-criacao DESC
                                BY    int-pendencias-supcard.identific.
END.

RUN pi-controla-pendencias IN THIS-PROCEDURE.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brPendencias */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Monitor de Ocorrˆncias */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Monitor de Ocorrˆncias */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOcor
&Scoped-define SELF-NAME brOcor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOcor C-Win
ON MOUSE-SELECT-DBLCLICK OF brOcor IN FRAME DEFAULT-FRAME
DO:
    IF  AVAIL int-emitente-supcard-ocor THEN DO:
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab     = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_espec     = "DM"
            AND    tit_acr.cod_ser_docto = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr   = SUBSTRING(int-emitente-supcard-ocor.num-transac,8,7)
            AND    tit_acr.cod_parcela   = STRING(int-emitente-supcard-ocor.num-parcela, "99") NO-ERROR.
        IF  AVAIL  tit_acr THEN DO:
            ASSIGN v_rec_tit_acr = RECID(tit_acr).
            RUN prgfin/acr/acr212aa.p.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOcor C-Win
ON START-SEARCH OF brOcor IN FRAME DEFAULT-FRAME
DO:
    CASE brOcor:CURRENT-COLUMN:NAME:
        WHEN "c-des-envio" THEN
            ASSIGN c-by = "ind-env-ret".
        WHEN "c-des-rej" THEN
            ASSIGN c-by = "cod-motivo".
        WHEN "de-vl-nota" THEN
            ASSIGN c-by = "num-transac".
        OTHERWISE
            ASSIGN c-by = brOcor:CURRENT-COLUMN:NAME.
    END CASE.
    
    IF  c-coluna = brOcor:CURRENT-COLUMN:NAME THEN
        ASSIGN c-by     = c-by + " DESC"
               c-coluna = "".
    ELSE
        ASSIGN c-coluna = brOcor:CURRENT-COLUMN:NAME.


    IF  NOT INPUT FRAME default-frame tg-nota THEN DO:
        brOcor:HANDLE:QUERY:QUERY-PREPARE("FOR EACH int-emitente-supcard-ocor NO-LOCK " +
                                          "WHERE int-emitente-supcard-ocor.raiz-cnpj     >= '" + INPUT FRAME default-frame c-raiz-cnpj-ini   + "' "       +  
                                          "AND   int-emitente-supcard-ocor.raiz-cnpj     <= '" + INPUT FRAME default-frame c-raiz-cnpj-fim   + "' "       +
                                          "AND   int-emitente-supcard-ocor.dat-avaliacao >=  " + INPUT FRAME default-frame dat-avaliacao-ini + "  "       +
                                          "AND   int-emitente-supcard-ocor.dat-avaliacao <=  " + INPUT FRAME default-frame dat-avaliacao-fim + "  "       +
                                          "AND   int-emitente-supcard-ocor.num-transac   >= '" + INPUT FRAME default-frame c-num-transac-ini + "' "       +
                                          "AND   int-emitente-supcard-ocor.num-transac   <= '" + INPUT FRAME default-frame c-num-transac-fim + "' "       +
                                          "AND   int-emitente-supcard-ocor.num-parcela   >= '" + INPUT FRAME default-frame c-num-parcela-ini + "' "       +
                                          "AND   int-emitente-supcard-ocor.num-parcela   <= '" + INPUT FRAME default-frame c-num-parcela-fim + "' "       +
                                          "AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, '" + c-lista-layout                              + "') > 0) " +
                                          "AND IF " + INPUT FRAME default-frame rs-envio + " = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = " + INPUT FRAME default-frame rs-envio + " " +
                                          "BY    int-emitente-supcard-ocor." + c-by).
    END.
    ELSE DO:
        brOcor:HANDLE:QUERY:QUERY-PREPARE("FOR EACH int-emitente-supcard-ocor NO-LOCK " +
                                          "WHERE int-emitente-supcard-ocor.raiz-cnpj     >= '" + INPUT FRAME default-frame c-raiz-cnpj-ini   + "' "       +  
                                          "AND   int-emitente-supcard-ocor.raiz-cnpj     <= '" + INPUT FRAME default-frame c-raiz-cnpj-fim   + "' "       +
                                          "AND   int-emitente-supcard-ocor.dat-avaliacao >=  " + INPUT FRAME default-frame dat-avaliacao-ini + "  "       +
                                          "AND   int-emitente-supcard-ocor.dat-avaliacao <=  " + INPUT FRAME default-frame dat-avaliacao-fim + "  "       +
                                          "AND  (LOOKUP(int-emitente-supcard-ocor.ind-ocor, '" + c-lista-layout                              + "') > 0) " +
                                          "AND   int-emitente-supcard-ocor.num-transac MATCHES '*" + INPUT FRAME default-frame c-num-transac + "*' "      +
                                          "AND IF " + INPUT FRAME default-frame rs-envio + " = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = " + INPUT FRAME default-frame rs-envio + " " +
                                          "BY    int-emitente-supcard-ocor." + c-by).
    END.

    /*
    brOcor:HANDLE:QUERY:QUERY-PREPARE("FOR EACH int-emitente-supcard-ocor NO-LOCK " +
                                      "WHERE int-emitente-supcard-ocor.raiz-cnpj     >= '" + INPUT FRAME default-frame c-raiz-cnpj-ini   + "' " +  
                                      "AND   int-emitente-supcard-ocor.raiz-cnpj     <= '" + INPUT FRAME default-frame c-raiz-cnpj-fim   + "' " +
                                      "AND   int-emitente-supcard-ocor.dat-avaliacao >=  " + INPUT FRAME default-frame dat-avaliacao-ini + "  " +
                                      "AND   int-emitente-supcard-ocor.dat-avaliacao <=  " + INPUT FRAME default-frame dat-avaliacao-fim + "  " +
                                      "AND   int-emitente-supcard-ocor.num-transac   >= '" + INPUT FRAME default-frame c-num-transac-ini + "' " +
                                      "AND   int-emitente-supcard-ocor.num-transac   <= '" + INPUT FRAME default-frame c-num-transac-fim + "' " +
                                      "AND   int-emitente-supcard-ocor.num-parcela   >= '" + INPUT FRAME default-frame c-num-parcela-ini + "' " +
                                      "AND   int-emitente-supcard-ocor.num-parcela   <= '" + INPUT FRAME default-frame c-num-parcela-fim + "' " +
                                      "AND IF " + INPUT FRAME default-frame rs-envio + " = 3 /*Ambos*/ THEN YES ELSE int-emitente-supcard-ocor.ind-env-ret = " + INPUT FRAME default-frame rs-envio + " " +
                                      "BY    int-emitente-supcard-ocor." + c-by).
    */

    brOcor:HANDLE:QUERY:QUERY-OPEN().
    {&OPEN-QUERY-brPendencias}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOcor C-Win
ON VALUE-CHANGED OF brOcor IN FRAME DEFAULT-FRAME
DO:
    {&OPEN-QUERY-brPendencias}

    IF  AVAIL int-emitente-supcard-ocor THEN
        ASSIGN ed-obs:SCREEN-VALUE IN FRAME default-frame = int-emitente-supcard-ocor.obs.
    ELSE
        ASSIGN ed-obs:SCREEN-VALUE IN FRAME default-frame = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPendencias
&Scoped-define SELF-NAME brPendencias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPendencias C-Win
ON VALUE-CHANGED OF brPendencias IN FRAME DEFAULT-FRAME
DO:
    RUN pi-controla-pendencias IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck C-Win
ON CHOOSE OF btCheck IN FRAME DEFAULT-FRAME /* Atualizar */
DO:
    {&OPEN-QUERY-brOcor}
    {&OPEN-QUERY-brPendencias}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir C-Win
ON CHOOSE OF btExcluir IN FRAME DEFAULT-FRAME /* Excluir */
DO:
    IF  AVAIL int-pendencias-supcard      AND
        int-pendencias-supcard.log-manual THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).
        IF  RETURN-VALUE = "YES" THEN DO:
            FIND CURRENT int-pendencias-supcard EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL int-pendencias-supcard THEN
                DELETE int-pendencias-supcard.
          
            {&OPEN-QUERY-brPendencias}
            RUN pi-controla-pendencias IN THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar C-Win
ON CHOOSE OF btFechar IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir C-Win
ON CHOOSE OF btIncluir IN FRAME DEFAULT-FRAME /* Incluir */
DO:
    IF  INPUT BROWSE brOcor int-emitente-supcard-ocor.ind-ocor = "8.1" OR
        INPUT BROWSE brOcor int-emitente-supcard-ocor.ind-ocor = "8.2" THEN DO:
        IF  INPUT BROWSE brOcor int-emitente-supcard-ocor.ind-ocor = "8.2" THEN DO:
            FIND LAST bf-int-emitente-supcard-ocor NO-LOCK
                WHERE bf-int-emitente-supcard-ocor.num-transac = INPUT BROWSE brOcor int-emitente-supcard-ocor.num-transac
                AND   bf-int-emitente-supcard-ocor.ind-ocor    = "8.3" NO-ERROR.
            IF  NOT AVAIL bf-int-emitente-supcard-ocor THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Pendˆncia nÆo pode ser gerada!~~Pendˆncia s¢ pode ser gerada para as notas que tiveram algum retorno da SupplierCard!":U).
                LEAVE.
            END.
            ELSE DO:
                IF  bf-int-emitente-supcard-ocor.log-habilitado = NO THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 27100,
                                       INPUT "Deseja incluir uma pendˆncia de Reenvio de Nota?~~A nota fiscal teve seu £ltimo retorno negado. Deseja reenviar a nota?":U).
                    IF  RETURN-VALUE = "YES" THEN DO:
                        RUN pi-incluir-pendencia-nota IN THIS-PROCEDURE.
    
                        {&OPEN-QUERY-brPendencias}
                        RUN pi-controla-pendencias IN THIS-PROCEDURE.
                    END.
    
                    LEAVE.
                END.
            END.
        END.

        RUN esp/acr/esacr041a.w (INPUT ROWID(int-emitente-supcard-ocor)).

        {&OPEN-QUERY-brPendencias}
        RUN pi-controla-pendencias IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLayouts
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayouts C-Win
ON CHOOSE OF btLayouts IN FRAME DEFAULT-FRAME /* Layouts */
DO:
    RUN esp/acr/esacr041b.w (INPUT-OUTPUT TABLE tt-param).

    RUN pi-lista-layout.

    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-num-parcela-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-num-parcela-fim C-Win
ON RETURN OF c-num-parcela-fim IN FRAME DEFAULT-FRAME
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-num-parcela-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-num-parcela-ini C-Win
ON RETURN OF c-num-parcela-ini IN FRAME DEFAULT-FRAME
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-num-transac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-num-transac C-Win
ON RETURN OF c-num-transac IN FRAME DEFAULT-FRAME /* Transa‡Æo */
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-num-transac-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-num-transac-fim C-Win
ON RETURN OF c-num-transac-fim IN FRAME DEFAULT-FRAME
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-num-transac-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-num-transac-ini C-Win
ON RETURN OF c-num-transac-ini IN FRAME DEFAULT-FRAME /* Transa‡Æo */
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-raiz-cnpj-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-fim C-Win
ON LEAVE OF c-raiz-cnpj-fim IN FRAME DEFAULT-FRAME
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INT(INPUT FRAME default-frame c-raiz-cnpj-fim) NO-ERROR.
    IF  AVAIL  emitente THEN
        ASSIGN c-raiz-cnpj-fim:SCREEN-VALUE IN FRAME default-frame = SUBSTRING(emitente.cgc,1,8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-fim C-Win
ON RETURN OF c-raiz-cnpj-fim IN FRAME DEFAULT-FRAME
DO:
    APPLY "LEAVE":U  TO SELF.
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-raiz-cnpj-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-ini C-Win
ON LEAVE OF c-raiz-cnpj-ini IN FRAME DEFAULT-FRAME /* Raiz CNPJ */
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INT(INPUT FRAME default-frame c-raiz-cnpj-ini) NO-ERROR.
    IF  AVAIL  emitente THEN
        ASSIGN c-raiz-cnpj-ini:SCREEN-VALUE IN FRAME default-frame = SUBSTRING(emitente.cgc,1,8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-ini C-Win
ON RETURN OF c-raiz-cnpj-ini IN FRAME DEFAULT-FRAME /* Raiz CNPJ */
DO:
    APPLY "LEAVE":U  TO SELF.
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dat-avaliacao-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-avaliacao-fim C-Win
ON RETURN OF dat-avaliacao-fim IN FRAME DEFAULT-FRAME
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dat-avaliacao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-avaliacao-ini C-Win
ON RETURN OF dat-avaliacao-ini IN FRAME DEFAULT-FRAME /* Data Avalia‡Æo */
DO:
    APPLY "CHOOSE":U TO btCheck IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nota C-Win
ON VALUE-CHANGED OF tg-nota IN FRAME DEFAULT-FRAME /* Nota Fiscal? */
DO:
    IF  INPUT FRAME default-frame tg-nota THEN DO:
        ASSIGN c-num-transac:VISIBLE     IN FRAME default-frame = YES
               c-num-transac-ini:VISIBLE IN FRAME default-frame = NO
               c-num-parcela-ini:VISIBLE IN FRAME default-frame = NO
               c-num-transac-fim:VISIBLE IN FRAME default-frame = NO
               c-num-parcela-fim:VISIBLE IN FRAME default-frame = NO
               image-5:VISIBLE           IN FRAME default-frame = NO
               image-6:VISIBLE           IN FRAME default-frame = NO.
    END.
    ELSE DO:
        ASSIGN c-num-transac:VISIBLE     IN FRAME default-frame = NO
               c-num-transac-ini:VISIBLE IN FRAME default-frame = YES
               c-num-parcela-ini:VISIBLE IN FRAME default-frame = YES
               c-num-transac-fim:VISIBLE IN FRAME default-frame = YES
               c-num-parcela-fim:VISIBLE IN FRAME default-frame = YES
               image-5:VISIBLE           IN FRAME default-frame = YES
               image-6:VISIBLE           IN FRAME default-frame = YES.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOcor
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
    RUN beforeInitializeInterface.
    RUN enable_UI.
    RUN afterInitializeInterface.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
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

    APPLY "VALUE-CHANGED":U TO tg-nota IN FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface C-Win 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-raiz-cnpj-ini   = "00000000"
           c-raiz-cnpj-fim   = "99999999"
           dat-avaliacao-ini = ADD-INTERVAL(TODAY, -6, "Month")
           dat-avaliacao-fim = TODAY
           c-num-transac     = ""
           c-num-transac-ini = ""
           c-num-transac-fim = "ZZZZZZZZZZZZZZ"
           c-num-parcela-ini = ""
           c-num-parcela-fim = "ZZ".

    /* Quando abre a tela, deve trazer todos os layouts selecionados */
    CREATE tt-param.
    ASSIGN tt-param.up-compras   = YES
           tt-param.transacoes   = YES
           tt-param.atu-clientes = YES
           tt-param.pagtos       = YES
           tt-param.param-compra = YES
           tt-param.motivo       = YES
           tt-param.clientes     = YES
           tt-param.compras      = YES
           tt-param.pendencias   = YES
           tt-param.limite       = YES.

    RUN pi-lista-layout.

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
  DISPLAY ed-obs c-num-transac tg-nota text-selecao c-raiz-cnpj-ini 
          c-raiz-cnpj-fim dat-avaliacao-ini dat-avaliacao-fim c-num-transac-ini 
          c-num-parcela-ini c-num-transac-fim c-num-parcela-fim rs-envio 
          text-ocorrencias text-pendencias 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE brPendencias ed-obs btLayouts c-num-transac tg-nota btExcluir 
         btIncluir text-selecao c-raiz-cnpj-ini c-raiz-cnpj-fim 
         dat-avaliacao-ini dat-avaliacao-fim c-num-transac-ini 
         c-num-parcela-ini c-num-transac-fim c-num-parcela-fim rs-envio btCheck 
         text-ocorrencias text-pendencias btFechar IMAGE-1 IMAGE-2 IMAGE-3 
         IMAGE-4 RECT-1 IMAGE-5 IMAGE-6 RECT-2 RECT-3 brOcor 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-pendencias C-Win 
PROCEDURE pi-controla-pendencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DISABLE btIncluir
            btExcluir
        WITH FRAME default-frame.


    IF  AVAIL int-pendencias-supcard      AND
        int-pendencias-supcard.log-manual THEN
        ENABLE btExcluir WITH FRAME default-frame.

    IF  INPUT BROWSE brOcor int-emitente-supcard-ocor.ind-ocor = "8.1" OR
        INPUT BROWSE brOcor int-emitente-supcard-ocor.ind-ocor = "8.2" THEN
        ENABLE btIncluir WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-incluir-pendencia-nota C-Win 
PROCEDURE pi-incluir-pendencia-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,1,4)))
        AND    nota-fiscal.serie       = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,5,3)))
        AND    nota-fiscal.nr-nota-fis = SUBSTRING(int-emitente-supcard-ocor.num-transac,8,7) NO-ERROR.
    IF  NOT AVAIL nota-fiscal THEN
        RETURN "NOK":U.
    
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
    /* Grava as informa‡äes da Nota no T¡tulo, para reutilizar o campo */
    CREATE int-pendencias-supcard.
    ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
           int-pendencias-supcard.cnpj-cliente        = emitente.cgc
           int-pendencias-supcard.cod-estab           = nota-fiscal.cod-estabel
           int-pendencias-supcard.cod-espec-docto     = "DM" /* Grava para localizar nas pendˆncias */
           int-pendencias-supcard.cod-parcela         = ""
           int-pendencias-supcard.cod-ser-docto       = nota-fiscal.serie
           int-pendencias-supcard.cod-tit-acr         = nota-fiscal.nr-nota-fis
           int-pendencias-supcard.dat-criacao         = TODAY
           int-pendencias-supcard.identific           = 97 /* Reenvio de Notas */
           int-pendencias-supcard.log-manual          = YES
           int-pendencias-supcard.log-emergencial     = NO
           int-pendencias-supcard.tipo-bloqueio       = ?
           int-pendencias-supcard.dias-prorrog        = 0
           int-pendencias-supcard.val-lancamento      = 0
           int-pendencias-supcard.val-limite-sugerido = 0
           int-pendencias-supcard.obs                 = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lista-layout C-Win 
PROCEDURE pi-lista-layout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-lista-layout = "".

    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF  AVAIL tt-param THEN DO:
        IF  tt-param.clientes THEN
            ASSIGN c-lista-layout = "8.1,".

        IF  tt-param.compras THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.2,".

        IF  tt-param.up-compras THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.3,".

        IF  tt-param.pendencias THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.4,".

        IF  tt-param.transacoes THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.5,".

        IF  tt-param.atu-clientes THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.6,".

        IF  tt-param.pagtos THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.7,".

        IF  tt-param.param-compra THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.8,".

        IF  tt-param.motivo THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.9,".

        IF  tt-param.limite THEN
            ASSIGN c-lista-layout = c-lista-layout + "8.10".
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesEnvio C-Win 
FUNCTION fnDesEnvio RETURNS CHARACTER
  (pCodEnvio AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF  pCodEnvio = 1 THEN
        ASSIGN c-des-envio = "Envio".
    ELSE
        ASSIGN c-des-envio = "Retorno".

    RETURN c-des-envio.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesMotRej C-Win 
FUNCTION fnDesMotRej RETURNS CHARACTER
  (i-cod-motivo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST int-motivo-supcard NO-LOCK
        WHERE  int-motivo-supcard.cod-motivo = i-cod-motivo NO-ERROR.
    ASSIGN c-des-rej = IF AVAIL int-motivo-supcard THEN int-motivo-supcard.des-motivo ELSE "".

    RETURN c-des-rej.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRequisicao C-Win 
FUNCTION fnRequisicao RETURNS CHARACTER
  (pIdentific AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pIdentific:
        WHEN 02 THEN
            RETURN "Prorroga‡Æo de Vencimento".
        WHEN 03 THEN
            RETURN "Cancelamento Total de Compra".
        WHEN 06 THEN
            RETURN "Altera‡Æo de Dados Cadastrais".
        WHEN 10 THEN
            RETURN "Cancelamento Parcial de Compra".
        WHEN 11 THEN
            RETURN "Bonifica‡Æo".
        WHEN 19 THEN
            RETURN "Bloqueio de Cliente".
        WHEN 97 THEN
            RETURN "Reenvio de Nota".
        WHEN 98 THEN
            RETURN "Solicita‡Æo Novo Cliente".
        WHEN 99 THEN
            RETURN "Altera‡Æo Limite de Cr‚dito".
        OTHERWISE
            RETURN "".
    END CASE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRequisicao C-Win 
FUNCTION fnOrigem RETURNS CHARACTER
  (pIdentific AS INTEGER,
   pEstab     AS CHAR,
   pNota      AS CHAR,
   pSer       AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF  pIdentific <> 03 
    AND pIdentific <> 10
        THEN RETURN "".

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = pEstab
           AND nota-fiscal.serie       = pSer 
           AND nota-fiscal.nr-nota-fis = pNota NO-ERROR. 
    IF NOT AVAIL nota-fiscal THEN
       RETURN "".
                 
    IF nota-fiscal.dt-cancel <> ?
       THEN RETURN "Cancelamento".
       ELSE RETURN "Devolu‡Æo".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoBloqueio C-Win 
FUNCTION fnTipoBloqueio RETURNS CHARACTER
  (pTipoBloqueio AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pTipoBloqueio:
        WHEN 0 THEN
            RETURN "Inatividade".
        WHEN 1 THEN
            RETURN "For‡a de Vendas Cadastrada".
        WHEN 2 THEN
            RETURN "ExclusÆo Inatividade".
        OTHERWISE
            RETURN "".
    END CASE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValorNF C-Win 
FUNCTION fnValorNF RETURNS DECIMAL
  (pNumTransac AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = STRING(INT(SUBSTRING(pNumTransac,1,4)))
        AND    nota-fiscal.serie       = STRING(INT(SUBSTRING(pNumTransac,5,3)))
        AND    nota-fiscal.nr-nota-fis = SUBSTRING(pNumTransac,8,7) NO-ERROR.
    ASSIGN de-vl-nota = IF AVAIL nota-fiscal THEN nota-fiscal.vl-tot-nota ELSE 0.

    RETURN de-vl-nota.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

