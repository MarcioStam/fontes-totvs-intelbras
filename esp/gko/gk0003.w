&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-gko-importacao NO-UNDO LIKE gko-importacao
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-gko-log-importacao NO-UNDO LIKE gko-log-importacao.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GK0003 2.00.00.002}
/*------------------------------------------------------------------------
    File        : GK0003.W
    Purpose     : Monitor de integra‡Æo GKO X EMS.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Program        GK0003
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   datIntegIni datIntegFin tgIntegrErro tgTodosMovtos ~
                              cbTipoInteg btFiltrar btExit brHistorico btExcluir ~
                              brLogHistorico btDetalhe
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cArquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHora       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOcorrencia AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTipoInteg  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDiretorio  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cListaTpInteg AS CHARACTER   NO-UNDO INITIAL "Conhecimento,Fatura,Data de Sa¡da,Contabiliza‡Æo,Material,Parceiro Comercial, Notas":U.

DEFINE VARIABLE deWidth     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deWidthDif  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deHeight    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deheightDif AS DECIMAL     NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bf-gko-importacao FOR gko-importacao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brHistorico

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-gko-importacao tt-gko-log-importacao

/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico ~
fnArquivo(tt-gko-importacao.nom-arquivo-integracao) @ cArquivo ~
tt-gko-importacao.seq-imp-arquivo tt-gko-importacao.dat-integracao ~
STRING (tt-gko-importacao.hor-integracao, "hh:mm":U)  @ cHora ~
fnTipoInteg(tt-gko-importacao.ind-tipo-integracao) @ cTipoInteg ~
fnOcorrencia(tt-gko-importacao.log-imp-erro) @ cOcorrencia ~
fnDiretorio(tt-gko-importacao.nom-arquivo-integracao) @ cDiretorio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico 
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-gko-importacao NO-LOCK ~
    BY tt-gko-importacao.nom-arquivo-integracao ~
       BY tt-gko-importacao.seq-imp-arquivo DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY brHistorico FOR EACH tt-gko-importacao NO-LOCK ~
    BY tt-gko-importacao.nom-arquivo-integracao ~
       BY tt-gko-importacao.seq-imp-arquivo DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-gko-importacao
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-gko-importacao


/* Definitions for BROWSE brLogHistorico                                */
&Scoped-define FIELDS-IN-QUERY-brLogHistorico ~
tt-gko-log-importacao.seq-log-erro tt-gko-log-importacao.des-erro-imp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLogHistorico 
&Scoped-define QUERY-STRING-brLogHistorico FOR EACH tt-gko-log-importacao NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brLogHistorico OPEN QUERY brLogHistorico FOR EACH tt-gko-log-importacao NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brLogHistorico tt-gko-log-importacao
&Scoped-define FIRST-TABLE-IN-QUERY-brLogHistorico tt-gko-log-importacao


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brHistorico}~
    ~{&OPEN-QUERY-brLogHistorico}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cbTipoInteg datIntegIni datIntegFin ~
tgIntegrErro tgTodosMovtos btFiltrar brHistorico btExcluir brLogHistorico ~
btDetalhe btExit IMAGE-1 IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS cbTipoInteg datIntegIni datIntegFin ~
tgIntegrErro tgTodosMovtos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnArquivo wWindow 
FUNCTION fnArquivo RETURNS CHARACTER
  ( pArqCompleto AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDiretorio wWindow 
FUNCTION fnDiretorio RETURNS CHARACTER
  ( pArqCompleto AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnOcorrencia wWindow 
FUNCTION fnOcorrencia RETURNS CHARACTER
  ( pIntegErro AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoInteg wWindow 
FUNCTION fnTipoInteg RETURNS CHARACTER
  ( pTipoInteg AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExport       LABEL "&Exportar"      ACCELERATOR "CTRL-E"
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btDetalhe 
     LABEL "&Detalhe" 
     SIZE 10 BY 1 TOOLTIP "Detalhe do Log".

DEFINE BUTTON btExcluir 
     LABEL "&Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "&Sair" 
     SIZE 4 BY 1.13
     FONT 4.

DEFINE BUTTON btFiltrar 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-sav.bmp":U
     LABEL "&Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar".

DEFINE VARIABLE cbTipoInteg AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "Tipo Integra‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 21.57 BY 1 NO-UNDO.

DEFINE VARIABLE datIntegFin AS DATE FORMAT "99/99/9999" INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE datIntegIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Integra‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE tgIntegrErro AS LOGICAL INITIAL yes 
     LABEL "Somente Integra‡äes com Erro na éltimo Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.57 BY .83.

DEFINE VARIABLE tgTodosMovtos AS LOGICAL INITIAL no 
     LABEL "Apresentar Todos os Movimentos de Cada Integra‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brHistorico FOR 
      tt-gko-importacao SCROLLING.

DEFINE QUERY brLogHistorico FOR 
      tt-gko-log-importacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wWindow _STRUCTURED
  QUERY brHistorico NO-LOCK DISPLAY
      fnArquivo(tt-gko-importacao.nom-arquivo-integracao) @ cArquivo COLUMN-LABEL "Arquivo" FORMAT "x(100)":U
            WIDTH 23.14
      tt-gko-importacao.seq-imp-arquivo FORMAT ">>>,>>>,>>9":U
            WIDTH 7.43
      tt-gko-importacao.dat-integracao FORMAT "99/99/9999":U
      STRING (tt-gko-importacao.hor-integracao, "hh:mm":U)  @ cHora COLUMN-LABEL "Hora" FORMAT "x(5)":U
            WIDTH 5.29
      fnTipoInteg(tt-gko-importacao.ind-tipo-integracao) @ cTipoInteg COLUMN-LABEL "Tipo Integra‡Æo" FORMAT "x(15)":U
            WIDTH 11.72
      fnOcorrencia(tt-gko-importacao.log-imp-erro) @ cOcorrencia COLUMN-LABEL "Ocorrˆncia" FORMAT "x(22)":U
            WIDTH 20
      fnDiretorio(tt-gko-importacao.nom-arquivo-integracao) @ cDiretorio COLUMN-LABEL "Diret¢rio" FORMAT "x(100)":U
            WIDTH 80
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 87.43 BY 8.71
         FONT 1
         TITLE "Hist¢rico".

DEFINE BROWSE brLogHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLogHistorico wWindow _STRUCTURED
  QUERY brLogHistorico NO-LOCK DISPLAY
      tt-gko-log-importacao.seq-log-erro FORMAT ">>>,>>>,>>9":U
      tt-gko-log-importacao.des-erro-imp FORMAT "x(500)":U WIDTH 100
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87.43 BY 5.92
         FONT 1
         TITLE "Log do Hist¢rico".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cbTipoInteg AT ROW 1.25 COL 58.72 COLON-ALIGNED HELP
          "Tipo de Integra‡Æo"
     datIntegIni AT ROW 1.25 COL 14.14 COLON-ALIGNED HELP
          "Data inicial em que foi realizada a integra‡Æo"
     datIntegFin AT ROW 1.25 COL 35 COLON-ALIGNED HELP
          "Data final em que foi realizada a integra‡Æo" NO-LABEL
     tgIntegrErro AT ROW 2.46 COL 4.43 HELP
          "Somente Integra‡äes com Erro na éltimo Importa‡Æo"
     tgTodosMovtos AT ROW 2.46 COL 44.57 HELP
          "Apresentar Todos os Movimentos de Cada Integra‡Æo"
     btFiltrar AT ROW 2.33 COL 85.72 HELP
          "Filtrar dados"
     brHistorico AT ROW 3.63 COL 2.29 HELP
          "Hist¢rico da integra‡äes"
     btExcluir AT ROW 12.33 COL 2.29
     brLogHistorico AT ROW 13.46 COL 2.29
     btDetalhe AT ROW 19.38 COL 2.29 HELP
          "Detalhe do Log"
     btExit AT ROW 1.13 COL 85.72 HELP
          "Sair"
     IMAGE-1 AT ROW 1.25 COL 26.43
     IMAGE-2 AT ROW 1.25 COL 33.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-gko-importacao T "?" NO-UNDO mgesp gko-importacao
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-gko-log-importacao T "?" NO-UNDO mgesp gko-log-importacao
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.71
         WIDTH              = 90
         MAX-HEIGHT         = 200
         MAX-WIDTH          = 300
         VIRTUAL-HEIGHT     = 200
         VIRTUAL-WIDTH      = 300
         RESIZE             = no
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
/* BROWSE-TAB brHistorico btFiltrar fpage0 */
/* BROWSE-TAB brLogHistorico btExcluir fpage0 */
ASSIGN 
       brHistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brHistorico:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       brLogHistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brLogHistorico:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _TblList          = "Temp-Tables.tt-gko-importacao"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-gko-importacao.nom-arquivo-integracao|yes,Temp-Tables.tt-gko-importacao.seq-imp-arquivo|no"
     _FldNameList[1]   > "_<CALC>"
"fnArquivo(tt-gko-importacao.nom-arquivo-integracao) @ cArquivo" "Arquivo" "x(100)" ? ? ? ? ? ? ? no "Arquivo em que foi realizada a integra‡Æo" no no "23.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-gko-importacao.seq-imp-arquivo
"tt-gko-importacao.seq-imp-arquivo" ? ? "integer" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-gko-importacao.dat-integracao
     _FldNameList[4]   > "_<CALC>"
"STRING (tt-gko-importacao.hor-integracao, ""hh:mm"":U)  @ cHora" "Hora" "x(5)" ? ? ? ? ? ? ? no "Hora que foi realizada a integra‡Æo" no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnTipoInteg(tt-gko-importacao.ind-tipo-integracao) @ cTipoInteg" "Tipo Integra‡Æo" "x(15)" ? ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnOcorrencia(tt-gko-importacao.log-imp-erro) @ cOcorrencia" "Ocorrˆncia" "x(22)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnDiretorio(tt-gko-importacao.nom-arquivo-integracao) @ cDiretorio" "Diret¢rio" "x(100)" ? ? ? ? ? ? ? no "Diret¢rio do arquivo em que foi realizada a integra‡Æo" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brHistorico */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLogHistorico
/* Query rebuild information for BROWSE brLogHistorico
     _TblList          = "Temp-Tables.tt-gko-log-importacao"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-gko-log-importacao.seq-log-erro
     _FldNameList[2]   > Temp-Tables.tt-gko-log-importacao.des-erro-imp
"tt-gko-log-importacao.des-erro-imp" ? ? "character" ? ? ? ? ? ? no ? no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brLogHistorico */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow
DO:
    ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
           FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
           FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
           FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
           FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
           FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT
           deWidthDif                  = CURRENT-WINDOW:WIDTH - deWidth
           deHeightDif                 = CURRENT-WINDOW:HEIGHT - deHeight.

    ASSIGN datIntegIni:COLUMN                   IN FRAME fPage0 = datIntegIni:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           datIntegIni:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = datIntegIni:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-1:COLUMN                       IN FRAME fPage0 = IMAGE-1:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-2:COLUMN                       IN FRAME fPage0 = IMAGE-2:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)
           datIntegFin:COLUMN                   IN FRAME fPage0 = datIntegFin:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           cbTipoInteg:COLUMN                   IN FRAME fPage0 = cbTipoInteg:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           cbTipoInteg:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = cbTipoInteg:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           tgIntegrErro:COLUMN                  IN FRAME fPage0 = tgIntegrErro:COLUMN                  IN FRAME fPage0 + (deWidthDif / 2)
           tgTodosMovtos:COLUMN                 IN FRAME fPage0 = tgTodosMovtos:COLUMN                 IN FRAME fPage0 + (deWidthDif / 2)
           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 +  deWidthDif
           btFiltrar:COLUMN                     IN FRAME fPage0 = btFiltrar:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           brHistorico:WIDTH                    IN FRAME fPage0 = brHistorico:WIDTH                    IN FRAME fPage0 +  deWidthDif
           brHistorico:HEIGHT                   IN FRAME fPage0 = brHistorico:HEIGHT                   IN FRAME fPage0 + (deHeightDif / 2)
           btExcluir:ROW                        IN FRAME fPage0 = btExcluir:ROW                        IN FRAME fPage0 + (deHeightDif / 2)
           brLogHistorico:WIDTH                 IN FRAME fPage0 = brLogHistorico:WIDTH                 IN FRAME fPage0 +  deWidthDif
           brLogHistorico:HEIGHT                IN FRAME fPage0 = brLogHistorico:HEIGHT                IN FRAME fPage0 + (deHeightDif / 2)
           brLogHistorico:ROW                   IN FRAME fPage0 = brLogHistorico:ROW                   IN FRAME fPage0 + (deHeightDif / 2)
           btDetalhe:ROW                        IN FRAME fPage0 = btDetalhe:ROW                        IN FRAME fPage0 +  deHeightDif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow
DO:
    IF CURRENT-WINDOW:WIDTH  <> deWidth  AND
       CURRENT-WINDOW:HEIGHT <> deHeight THEN
        RETURN "NOK":U.

    ASSIGN datIntegIni:COLUMN                   IN FRAME fPage0 = datIntegIni:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           datIntegIni:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = datIntegIni:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-1:COLUMN                       IN FRAME fPage0 = IMAGE-1:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-2:COLUMN                       IN FRAME fPage0 = IMAGE-2:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)
           datIntegFin:COLUMN                   IN FRAME fPage0 = datIntegFin:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           cbTipoInteg:COLUMN                   IN FRAME fPage0 = cbTipoInteg:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           cbTipoInteg:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = cbTipoInteg:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)
           tgIntegrErro:COLUMN                  IN FRAME fPage0 = tgIntegrErro:COLUMN                  IN FRAME fPage0 - (deWidthDif / 2)
           tgTodosMovtos:COLUMN                 IN FRAME fPage0 = tgTodosMovtos:COLUMN                 IN FRAME fPage0 - (deWidthDif / 2)
           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 - deWidthDif
           btFiltrar:COLUMN                     IN FRAME fPage0 = btFiltrar:COLUMN                     IN FRAME fPage0 - (deWidthDif / 2)
           brHistorico:WIDTH                    IN FRAME fPage0 = brHistorico:WIDTH                    IN FRAME fPage0 - deWidthDif
           brHistorico:HEIGHT                   IN FRAME fPage0 = brHistorico:HEIGHT                   IN FRAME fPage0 - (deHeightDif / 2)
           btExcluir:ROW                        IN FRAME fPage0 = btExcluir:ROW                        IN FRAME fPage0 - (deHeightDif / 2)
           brLogHistorico:WIDTH                 IN FRAME fPage0 = brLogHistorico:WIDTH                 IN FRAME fPage0 - deWidthDif
           brLogHistorico:HEIGHT                IN FRAME fPage0 = brLogHistorico:HEIGHT                IN FRAME fPage0 - (deHeightDif / 2)
           brLogHistorico:ROW                   IN FRAME fPage0 = brLogHistorico:ROW                   IN FRAME fPage0 - (deHeightDif / 2)
           btDetalhe:ROW                        IN FRAME fPage0 = btDetalhe:ROW                        IN FRAME fPage0 - deHeightDif.

    ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
           FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
           FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
           FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
           FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
           FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistorico
&Scoped-define SELF-NAME brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON DELETE-CHARACTER OF brHistorico IN FRAME fpage0 /* Hist¢rico */
DO:
    APPLY "CHOOSE":U TO btExcluir IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON VALUE-CHANGED OF brHistorico IN FRAME fpage0 /* Hist¢rico */
DO:
    RUN filtrarLogHistorico IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brLogHistorico
&Scoped-define SELF-NAME brLogHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLogHistorico wWindow
ON MOUSE-SELECT-DBLCLICK OF brLogHistorico IN FRAME fpage0 /* Log do Hist¢rico */
DO:
    APPLY "CHOOSE":U TO btDetalhe IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLogHistorico wWindow
ON RETURN OF brLogHistorico IN FRAME fpage0 /* Log do Hist¢rico */
DO:
    APPLY "CHOOSE":U TO btDetalhe IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wWindow
ON CHOOSE OF btDetalhe IN FRAME fpage0 /* Detalhe */
DO:
    RUN detalheLog IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wWindow
ON CHOOSE OF btExcluir IN FRAME fpage0 /* Excluir */
DO:
    RUN excluirDadosHistorico IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltrar wWindow
ON CHOOSE OF btFiltrar IN FRAME fpage0 /* Filtrar */
DO:
    RUN filtrarHistorico IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME datIntegFin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL datIntegFin wWindow
ON RETURN OF datIntegFin IN FRAME fpage0
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME datIntegIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL datIntegIni wWindow
ON RETURN OF datIntegIni IN FRAME fpage0 /* Data Integra‡Æo */
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miContents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miContents wWindow
ON CHOOSE OF MENU-ITEM miContents /* Conte£do */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miExport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExport wWindow
ON CHOOSE OF MENU-ITEM miExport /* Exportar */
DO:
    RUN piExportar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgIntegrErro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgIntegrErro wWindow
ON RETURN OF tgIntegrErro IN FRAME fpage0 /* Somente Integra‡äes com Erro na éltimo Importa‡Æo */
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgTodosMovtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgTodosMovtos wWindow
ON RETURN OF tgTodosMovtos IN FRAME fpage0 /* Apresentar Todos os Movimentos de Cada Integra‡Æo */
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistorico
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN deWidth  = CURRENT-WINDOW:WIDTH
           deHeight = CURRENT-WINDOW:HEIGHT.

   /* APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.*/

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
    DEFINE VARIABLE iAux AS INTEGER     NO-UNDO.

    DO iAux = 1 TO NUM-ENTRIES(cListaTpInteg, ",":U):
        IF iAux = 1 THEN
            ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = ENTRY(iAux, cListaTpInteg, ",":U) + ",":U + TRIM(STRING(iAux)).
        ELSE
            ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 + ",":U + ENTRY(iAux, cListaTpInteg, ",":U) + ",":U + TRIM(STRING(iAux)).
    END.

    ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 + ",":U + "Todos":U + ",":U + TRIM(STRING(NUM-ENTRIES(cListaTpInteg, ",":U) + 1)).

    ASSIGN cbTipoInteg = NUM-ENTRIES(cListaTpInteg, ",":U) + 1.

    DISPLAY cbTipoInteg
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE detalheLog wWindow 
PROCEDURE detalheLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT AVAILABLE tt-gko-importacao THEN
        RETURN "NOK":U.

    IF NOT AVAILABLE tt-gko-log-importacao THEN
        RETURN "NOK":U.

    DEFINE BUTTON btSairDetalheLog AUTO-END-KEY
        LABEL "&Cancelar":U
        SIZE 10 BY 1
        BGCOLOR 8.

    DEFINE RECTANGLE rtButtonDetalheLog
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 61 BY 1.42
        BGCOLOR 7.

    DEFINE VARIABLE c-nom-arquivo-integracao LIKE tt-gko-importacao.nom-arquivo-integracao NO-UNDO
        LABEL "Arquivo":U
        VIEW-AS FILL-IN
        SIZE 33.15 BY 0.88.

    DEFINE VARIABLE i-seq-imp-arquivo LIKE tt-gko-importacao.seq-imp-arquivo NO-UNDO
        LABEL "Seq Arquivo":U
        VIEW-AS FILL-IN
        SIZE 7.43 BY 0.88.

    DEFINE VARIABLE i-seq-log-erro LIKE tt-gko-log-importacao.seq-log-erro NO-UNDO
        LABEL "Seq Log":U
        VIEW-AS FILL-IN
        SIZE 7.43 BY 0.88.

    DEFINE VARIABLE c-des-erro-imp LIKE tt-gko-log-importacao.des-erro-imp NO-UNDO
        LABEL "Descri‡Æo":U
        VIEW-AS EDITOR SCROLLBAR-VERTICAL
        SIZE 50 BY 5
        FONT 2.

    ASSIGN c-nom-arquivo-integracao = fnArquivo(tt-gko-importacao.nom-arquivo-integracao)
           i-seq-imp-arquivo        = tt-gko-importacao.seq-imp-arquivo
           i-seq-log-erro           = tt-gko-log-importacao.seq-log-erro
           c-des-erro-imp           = tt-gko-log-importacao.des-erro-imp.

    DEFINE FRAME fDetalheLog
        c-nom-arquivo-integracao AT ROW  1.21 COLUMN 8.72 COLON-ALIGNED
        i-seq-imp-arquivo        AT ROW  2.21 COLUMN 8.72 COLON-ALIGNED
        i-seq-log-erro           AT ROW  3.21 COLUMN 8.72 COLON-ALIGNED
        c-des-erro-imp           AT ROW  4.21 COLUMN 8.72 COLON-ALIGNED
        btSairDetalheLog         AT ROW 10.13 COLUMN 2.14
        rtButtonDetalheLog       AT ROW  9.88 COLUMN 1.00
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Detalhe Log do Hist¢rico":U FONT 1
             CANCEL-BUTTON btSairDetalheLog.

    ON 'WINDOW-CLOSE':U OF FRAME fDetalheLog
    DO:
        APPLY "GO":U TO FRAME fDetalheLog.
    END.

    ASSIGN c-des-erro-imp:READ-ONLY IN FRAME fDetalheLog = YES.

    DISPLAY c-nom-arquivo-integracao
            i-seq-imp-arquivo
            i-seq-log-erro
            c-des-erro-imp
        WITH FRAME fDetalheLog.

    ENABLE c-des-erro-imp
           btSairDetalheLog
        WITH FRAME fDetalheLog.

    APPLY "ENTRY":U TO btSairDetalheLog IN FRAME fDetalheLog.
    
    WAIT-FOR "GO":U OF FRAME fDetalheLog.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excluirDadosHistorico wWindow 
PROCEDURE excluirDadosHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCount AS INTEGER     NO-UNDO.

    IF brHistorico:NUM-SELECTED-ROWS IN FRAME fPage0 > 0 THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 46700,
                           INPUT "":U).

        IF RETURN-VALUE = "NO":U THEN
            RETURN "OK":U.

        DO iCount = 1 TO brHistorico:NUM-SELECTED-ROWS IN FRAME fPage0:
            brHistorico:FETCH-SELECTED-ROW(icount).

            IF AVAILABLE tt-gko-importacao THEN DO:
                FIND FIRST gko-importacao
                    WHERE ROWID(gko-importacao) = tt-gko-importacao.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE gko-importacao THEN DO:
                    FOR EACH gko-log-importacao EXCLUSIVE-LOCK
                        WHERE gko-log-importacao.seq-importacao = gko-importacao.seq-importacao:
                        DELETE gko-log-importacao.
                    END.

                    DELETE gko-importacao.
                    DELETE tt-gko-importacao.
                END.
            END.
        END.

        {&OPEN-QUERY-brHistorico}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 19177,
                           INPUT "registro":U).

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filtrarHistorico wWindow 
PROCEDURE filtrarHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-gko-importacao.

    ASSIGN INPUT FRAME fPage0 datIntegIni
                              datIntegFin
                              tgIntegrErro
                              tgTodosMovtos
                              cbTipoInteg.

    IF datIntegIni > datIntegFin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 119,
                           INPUT "":U).

        RETURN NO-APPLY.
    END.

    IF tgTodosMovtos THEN DO:
        IF cbTipoInteg <> NUM-ENTRIES(cListaTpInteg, ",":U) + 1 THEN DO:
            FOR EACH gko-importacao NO-LOCK USE-INDEX id-tipo-integra
                WHERE gko-importacao.ind-tipo-integracao = cbTipoInteg
                  AND gko-importacao.dat-integracao     >= datIntegIni
                  AND gko-importacao.dat-integracao     <= datIntegFin
                BREAK BY gko-importacao.nom-arquivo-integracao
                      BY gko-importacao.seq-imp-arquivo:

                FIND LAST bf-gko-importacao
                    WHERE bf-gko-importacao.nom-arquivo-integracao = gko-importacao.nom-arquivo-integracao NO-LOCK NO-ERROR.

                IF AVAILABLE bf-gko-importacao        AND
                   tgIntegrErro                       AND
                   NOT bf-gko-importacao.log-imp-erro THEN NEXT.
                
                CREATE tt-gko-importacao.
                BUFFER-COPY gko-importacao TO tt-gko-importacao.
                ASSIGN tt-gko-importacao.r-rowid = ROWID(gko-importacao).
            END.
        END.
        ELSE DO:
            FOR EACH gko-importacao NO-LOCK USE-INDEX id-data-imp
                WHERE gko-importacao.dat-integracao >= datIntegIni
                  AND gko-importacao.dat-integracao <= datIntegFin
                BREAK BY gko-importacao.nom-arquivo-integracao
                      BY gko-importacao.seq-imp-arquivo:

                FIND LAST bf-gko-importacao
                    WHERE bf-gko-importacao.nom-arquivo-integracao = gko-importacao.nom-arquivo-integracao NO-LOCK NO-ERROR.

                IF AVAILABLE bf-gko-importacao        AND
                   tgIntegrErro                       AND
                   NOT bf-gko-importacao.log-imp-erro THEN NEXT.

                CREATE tt-gko-importacao.
                BUFFER-COPY gko-importacao TO tt-gko-importacao.
                ASSIGN tt-gko-importacao.r-rowid = ROWID(gko-importacao).
            END.
        END.
    END.
    ELSE DO:
        IF cbTipoInteg <> NUM-ENTRIES(cListaTpInteg, ",":U) + 1 THEN DO:
            FOR EACH gko-importacao NO-LOCK USE-INDEX id-tipo-integra
                WHERE gko-importacao.ind-tipo-integracao = cbTipoInteg
                  AND gko-importacao.dat-integracao     >= datIntegIni
                  AND gko-importacao.dat-integracao     <= datIntegFin
                BREAK BY gko-importacao.nom-arquivo-integracao
                      BY gko-importacao.seq-imp-arquivo:

                IF LAST-OF(gko-importacao.nom-arquivo-integracao) AND LAST-OF(gko-importacao.seq-imp-arquivo) THEN DO:
                    IF tgIntegrErro AND NOT gko-importacao.log-imp-erro THEN NEXT.

                    CREATE tt-gko-importacao.
                    BUFFER-COPY gko-importacao TO tt-gko-importacao.
                    ASSIGN tt-gko-importacao.r-rowid = ROWID(gko-importacao).
                END.
            END.
        END.
        ELSE DO:
            FOR EACH gko-importacao NO-LOCK USE-INDEX id-data-imp
                WHERE gko-importacao.dat-integracao >= datIntegIni
                  AND gko-importacao.dat-integracao <= datIntegFin
                BREAK BY gko-importacao.nom-arquivo-integracao
                      BY gko-importacao.seq-imp-arquivo:

                IF LAST-OF(gko-importacao.nom-arquivo-integracao) AND LAST-OF(gko-importacao.seq-imp-arquivo) THEN DO:
                    IF tgIntegrErro AND NOT gko-importacao.log-imp-erro THEN NEXT.

                    CREATE tt-gko-importacao.
                    BUFFER-COPY gko-importacao TO tt-gko-importacao.
                    ASSIGN tt-gko-importacao.r-rowid = ROWID(gko-importacao).
                END.
            END.
        END.
    END.

    {&OPEN-QUERY-brHistorico}

    APPLY "ENTRY":U TO brHistorico IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filtrarLogHistorico wWindow 
PROCEDURE filtrarLogHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-gko-log-importacao.

    IF brHistorico:NUM-SELECTED-ROWS IN FRAME fPage0 = 1 THEN DO:
        FOR EACH gko-log-importacao NO-LOCK
            WHERE gko-log-importacao.seq-importacao = tt-gko-importacao.seq-importacao:
            CREATE tt-gko-log-importacao.
            BUFFER-COPY gko-log-importacao TO tt-gko-log-importacao.
        END.
    END.

    {&OPEN-QUERY-brLogHistorico}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExportar wWindow 
PROCEDURE piExportar :
/*------------------------------------------------------------------------------
  Purpose: Exportar registros dos browsers
  Notes:   Carlos Daniel -  19/07/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE    NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Exportando...").

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "GK0003_export.csv".


OUTPUT TO VALUE(c-arquivo).
PUT "Arquivo;Seq;Data;Hora;Tipo Integra‡Æo;Ocorrˆncia;Diret¢rio;Seq;Erro" SKIP.

FOR EACH tt-gko-importacao,
    EACH gko-log-importacao
    WHERE gko-log-importacao.seq-importacao = tt-gko-importacao.seq-importacao NO-LOCK:

    RUN pi-acompanhar IN h-acomp (INPUT "Sequˆncia: " + STRING(tt-gko-importacao.seq-importacao) + ".").

    PUT UNFORMATTED fnArquivo(tt-gko-importacao.nom-arquivo-integracao) ";"
        tt-gko-importacao.seq-imp-arquivo                               ";"
        tt-gko-importacao.dat-integracao                                ";"
        STRING (tt-gko-importacao.hor-integracao, "hh:mm":U)            ";"
        fnTipoInteg(tt-gko-importacao.ind-tipo-integracao)              ";"
        fnOcorrencia(tt-gko-importacao.log-imp-erro)                    ";"
        fnDiretorio(tt-gko-importacao.nom-arquivo-integracao)           ";"
        gko-log-importacao.seq-log-erro                                 ";"
        REPLACE(gko-log-importacao.des-erro-imp,CHR(13)," ") SKIP.
END.

OUTPUT CLOSE.
 
RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

DOS SILENT START excel VALUE(c-arquivo).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnArquivo wWindow 
FUNCTION fnArquivo RETURNS CHARACTER
  ( pArqCompleto AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN pArqCompleto = REPLACE(pArqCompleto, "/":U, "~\":U).

    IF NUM-ENTRIES(pArqCompleto, "~\":U) > 0 THEN
        RETURN ENTRY(NUM-ENTRIES(pArqCompleto, "~\":U), pArqCompleto, "\":U).
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDiretorio wWindow 
FUNCTION fnDiretorio RETURNS CHARACTER
  ( pArqCompleto AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN pArqCompleto = REPLACE(pArqCompleto, "/":U, "~\":U).

    IF NUM-ENTRIES(pArqCompleto, "~\":U) > 0 THEN
        RETURN REPLACE(pArqCompleto, ENTRY(NUM-ENTRIES(pArqCompleto, "~\":U), pArqCompleto, "\":U), "":U).
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnOcorrencia wWindow 
FUNCTION fnOcorrencia RETURNS CHARACTER
  ( pIntegErro AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF pIntegErro THEN
        RETURN "Erro de Importa‡Æo":U.
    ELSE
        RETURN "Importado com Sucesso":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoInteg wWindow 
FUNCTION fnTipoInteg RETURNS CHARACTER
  ( pTipoInteg AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF NUM-ENTRIES(cListaTpInteg, ",":U) >= pTipoInteg THEN
        RETURN ENTRY(pTipoInteg, cListaTpInteg, ",":U).
    ELSE
        RETURN "<desconhecido>":U.

/*     CASE pTipoInteg:                  */
/*         WHEN 1 THEN                   */
/*             RETURN "Conhecimento":U.  */
/*         WHEN 2 THEN                   */
/*             RETURN "Fatura":U.        */
/*         WHEN 3 THEN                   */
/*             RETURN "Data de Sa¡da":U. */
/*         OTHERWISE                     */
/*             RETURN "":U.              */
/*     END CASE.                         */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

