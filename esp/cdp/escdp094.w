&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i ESCDP094 1.00.00.001}
/*------------------------------------------------------------------------
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Program        ESCDP094
&GLOBAL-DEFINE Version        1.00.00.001

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   datIntegIni datIntegFin fi-item-ini fi-item-fim i-lista ~
                              bt-it-faturavel btFiltrar btExit  ~
                              brHistorico 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cArquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHora       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOcorrencia AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTipoInteg  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDiretorio  AS CHARACTER   NO-UNDO.


DEFINE VARIABLE deWidth     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deWidthDif  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deHeight    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deheightDif AS DECIMAL     NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE VARIABLE c-estado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-regra  AS CHARACTER   NO-UNDO.

{esp/es0018.i}
{esapi/esapi025a.i}

DEF TEMP-TABLE tt-histor-integra-item LIKE histor-integra-item
    FIELD r-rowid AS ROWID.

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
&Scoped-define INTERNAL-TABLES tt-histor-integra-item ITEM

/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-histor-integra-item.data tt-histor-integra-item.hora tt-histor-integra-item.cod-estabel fnEstado(ITEM.cod-estabel) @ c-estado tt-histor-integra-item.acao tt-histor-integra-item.it-codigo ITEM.desc-item tt-histor-integra-item.codigo-orig tt-histor-integra-item.ge-codigo tt-histor-integra-item.fm-codigo tt-histor-integra-item.fm-cod-com tt-histor-integra-item.class-fiscal tt-histor-integra-item.lei-informatica tt-histor-integra-item.ind-item-fat tt-histor-integra-item.cd0755 tt-histor-integra-item.cd0355 tt-histor-integra-item.cd0356 tt-histor-integra-item.cd0903 tt-histor-integra-item.cd0904a tt-histor-integra-item.escdp050 tt-histor-integra-item.ft0312 tt-histor-integra-item.of0147 tt-histor-integra-item.tipo-item tt-histor-integra-item.pendente-fat tt-histor-integra-item.origem tt-histor-integra-item.char-2 tt-histor-integra-item.char-1   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico   
&Scoped-define SELF-NAME brHistorico
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-histor-integra-item NO-LOCK, ~
             EACH ITEM OF tt-histor-integra-item       WHERE ITEM.it-codigo = tt-histor-integra-item.it-codigo NO-LOCK          BY tt-histor-integra-item.data DESC          BY tt-histor-integra-item.hora DESC     INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-integra-item NO-LOCK, ~
             EACH ITEM OF tt-histor-integra-item       WHERE ITEM.it-codigo = tt-histor-integra-item.it-codigo NO-LOCK          BY tt-histor-integra-item.data DESC          BY tt-histor-integra-item.hora DESC     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-histor-integra-item ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-histor-integra-item
&Scoped-define SECOND-TABLE-IN-QUERY-brHistorico ITEM


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brHistorico}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brHistorico i-lista datIntegIni datIntegFin ~
btFiltrar btExit fi-item-ini fi-item-fim IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
RECT-1 RECT-2 RECT-3 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS i-lista datIntegIni datIntegFin ~
fi-item-ini fi-item-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnEstado wWindow 
FUNCTION FnEstado RETURNS CHARACTER
  ( cEstab AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnRegra wWindow 
FUNCTION FnRegra RETURNS CHARACTER
  ( i-regra AS INT )  FORWARD.

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
DEFINE BUTTON bt-it-faturavel 
     LABEL "Tornar Item Faturavel" 
     SIZE 16.86 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "&Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair"
     FONT 4.

DEFINE BUTTON btFiltrar 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-sav.bmp":U
     LABEL "&Filtrar" 
     SIZE 6 BY 1.5 TOOLTIP "Filtrar".

DEFINE VARIABLE datIntegFin AS DATE FORMAT "99/99/9999" INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE datIntegIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Integraá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE i-lista AS INTEGER INITIAL 8 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendencia Faturavel", 1,
"Integrado com Sucesso", 2,
"Faturavel", 3,
"N«O Faturavel", 4,
"Lei da Informatica", 5,
"Itens Criados", 6,
"Itens Alterados", 7,
"Èltima integraá∆o do Item", 8,
"Todos", 9
     SIZE 24.14 BY 5.67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 6.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 13.92.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 6.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brHistorico FOR 
      tt-histor-integra-item, 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wWindow _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-histor-integra-item.data                                         FORMAT "99/99/9999":U WIDTH 8.43 
tt-histor-integra-item.hora               COLUMN-LABEL "Hora"       FORMAT "x(12)":U      WIDTH 7.43
tt-histor-integra-item.cod-estabel        COLUMN-LABEL "Estab"      FORMAT "x(5)":U       WIDTH 4
fnEstado(ITEM.cod-estabel) @ c-estado     COLUMN-LABEL "UF"                               WIDTH 3
tt-histor-integra-item.acao               COLUMN-LABEL "Aá∆o"                             WIDTH 4
tt-histor-integra-item.it-codigo                                    FORMAT "x(19)":U      WIDTH 9
ITEM.desc-item                                                      FORMAT "x(60)":U      WIDTH 30
tt-histor-integra-item.codigo-orig        COLUMN-LABEL "Cod.Orig"   FORMAT ">9":U         WIDTH 6
tt-histor-integra-item.ge-codigo          COLUMN-LABEL "Gr.Estoq"                         WIDTH 6
tt-histor-integra-item.fm-codigo          COLUMN-LABEL "Fam.Mat"                          WIDTH 8
tt-histor-integra-item.fm-cod-com         COLUMN-LABEL "Fam.Comerc"                       WIDTH 8
tt-histor-integra-item.class-fiscal       COLUMN-LABEL "Class.Fisc" FORMAT "9999.99.99":U WIDTH 10
tt-histor-integra-item.lei-informatica    COLUMN-LABEL "Lei INFO"   FORMAT "Sim/N∆o":U    WIDTH 6.29
tt-histor-integra-item.ind-item-fat       COLUMN-LABEL "Fatur."     FORMAT "Sim/N∆o":U    WIDTH 6.29
tt-histor-integra-item.cd0755             COLUMN-LABEL "CD0755"     FORMAT "Sim/N∆o":U    WIDTH 6.43
tt-histor-integra-item.cd0355             COLUMN-LABEL "CD0355"     FORMAT "Sim/N∆o":U    WIDTH 6.43
tt-histor-integra-item.cd0356             COLUMN-LABEL "CD0356"     FORMAT "Sim/N∆o":U    WIDTH 6.43
tt-histor-integra-item.cd0903             COLUMN-LABEL "CD0903"     FORMAT "Sim/N∆o":U    WIDTH 6.43
tt-histor-integra-item.cd0904a            COLUMN-LABEL "CD0904A"    FORMAT "Sim/N∆o":U    WIDTH 7
tt-histor-integra-item.escdp050           COLUMN-LABEL "ESCDP050"   FORMAT "Sim/N∆o":U    WIDTH 8.14
tt-histor-integra-item.ft0312             COLUMN-LABEL "ft0312"     FORMAT "Sim/N∆o":U    WIDTH 5.86
tt-histor-integra-item.of0147             COLUMN-LABEL "OF0147"     FORMAT "Sim/N∆o":U    WIDTH 6.72
tt-histor-integra-item.tipo-item          COLUMN-LABEL "Tipo Item"  FORMAT "x(60)":U      WIDTH 17
tt-histor-integra-item.pendente-fat       COLUMN-LABEL "Faturavel Pend"     FORMAT "Sim/N∆o":U   WIDTH 12
tt-histor-integra-item.origem             COLUMN-LABEL "Nacionalidade"      FORMAT "x(60)":U     WIDTH 12
tt-histor-integra-item.char-2             COLUMN-LABEL "REGRA"              FORMAT "x(60)":U     WIDTH 15
tt-histor-integra-item.char-1             COLUMN-LABEL "Motivos Pendencias" FORMAT "x(1000)":U   WIDTH 100
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 149.86 BY 13.5
         FONT 1 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brHistorico AT ROW 7.79 COL 2.14 WIDGET-ID 100
     i-lista AT ROW 1.33 COL 20.86 NO-LABEL WIDGET-ID 48
     bt-it-faturavel AT ROW 21.79 COL 2 WIDGET-ID 24
     datIntegIni AT ROW 1.83 COL 60 COLON-ALIGNED HELP
          "Data inicial em que foi realizada a integraá∆o"
     datIntegFin AT ROW 1.83 COL 80.86 COLON-ALIGNED HELP
          "Data final em que foi realizada a integraá∆o" NO-LABEL
     btFiltrar AT ROW 1.79 COL 93.43 HELP
          "Filtrar dados"
     btExit AT ROW 1.25 COL 147.29 HELP
          "Sair"
     fi-item-ini AT ROW 2.83 COL 60 COLON-ALIGNED WIDGET-ID 4
     fi-item-fim AT ROW 2.83 COL 80.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     IMAGE-1 AT ROW 1.83 COL 72.29
     IMAGE-2 AT ROW 1.83 COL 79.72
     IMAGE-3 AT ROW 2.83 COL 72.14 WIDGET-ID 6
     IMAGE-4 AT ROW 2.83 COL 79.72 WIDGET-ID 8
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 18
     RECT-2 AT ROW 7.63 COL 1 WIDGET-ID 20
     RECT-3 AT ROW 21.67 COL 1 WIDGET-ID 22
     RECT-5 AT ROW 1.13 COL 19 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 154.72 BY 22.38
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
         HEIGHT             = 22.42
         WIDTH              = 153.57
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
/* BROWSE-TAB brHistorico 1 fpage0 */
ASSIGN 
       brHistorico:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brHistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR BUTTON bt-it-faturavel IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-integra-item NO-LOCK,
      EACH ITEM OF tt-histor-integra-item
      WHERE ITEM.it-codigo = tt-histor-integra-item.it-codigo NO-LOCK
         BY tt-histor-integra-item.data DESC
         BY tt-histor-integra-item.hora DESC
    INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[2]         = "mgcad.item.it-codigo = histor-integra-item.it-codigo"
     _Query            is OPENED
*/  /* BROWSE brHistorico */
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
           
           datIntegFin:COLUMN                   IN FRAME fPage0 = datIntegFin:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
          
           fi-item-ini:COLUMN                   IN FRAME fPage0 = fi-item-ini:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           fi-item-ini:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = fi-item-ini:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           
           fi-item-fim:COLUMN                   IN FRAME fPage0 = fi-item-fim:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           
           IMAGE-1:COLUMN                       IN FRAME fPage0 = IMAGE-1:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-2:COLUMN                       IN FRAME fPage0 = IMAGE-2:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)

           IMAGE-3:COLUMN                       IN FRAME fPage0 = IMAGE-3:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-4:COLUMN                       IN FRAME fPage0 = IMAGE-4:COLUMN                       IN FRAME fPage0 + (deWidthDif / 2)

           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 +  deWidthDif
           btFiltrar:COLUMN                     IN FRAME fPage0 = btFiltrar:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           
           brHistorico:WIDTH                    IN FRAME fPage0 = brHistorico:WIDTH                    IN FRAME fPage0 +  deWidthDif
           brHistorico:HEIGHT                   IN FRAME fPage0 = brHistorico:HEIGHT                   IN FRAME fPage0 + (deHeightDif / 2)
           
           bt-it-faturavel:ROW                  IN FRAME fPage0 = (brHistorico:ROW IN FRAME fPage0 + brHistorico:HEIGHT IN FRAME fPage0 + 0.4).
        
   ASSIGN  RECT-1:VISIBLE                   IN FRAME fPage0 = NO
           RECT-2:VISIBLE                   IN FRAME fPage0 = NO
           RECT-3:VISIBLE                   IN FRAME fPage0 = NO.
           
           
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
           
           fi-item-ini:COLUMN                   IN FRAME fPage0 = fi-item-ini:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           fi-item-ini:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = fi-item-ini:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)

           fi-item-fim:COLUMN                   IN FRAME fPage0 = fi-item-fim:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           datIntegFin:COLUMN                   IN FRAME fPage0 = datIntegFin:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           
           IMAGE-1:COLUMN                       IN FRAME fPage0 = IMAGE-1:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-2:COLUMN                       IN FRAME fPage0 = IMAGE-2:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)

           IMAGE-3:COLUMN                       IN FRAME fPage0 = IMAGE-3:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-4:COLUMN                       IN FRAME fPage0 = IMAGE-4:COLUMN                       IN FRAME fPage0 - (deWidthDif / 2)

           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 - deWidthDif
           btFiltrar:COLUMN                     IN FRAME fPage0 = btFiltrar:COLUMN                     IN FRAME fPage0 - (deWidthDif / 2)
           
           brHistorico:WIDTH                    IN FRAME fPage0 = brHistorico:WIDTH                    IN FRAME fPage0 - deWidthDif
           brHistorico:HEIGHT                   IN FRAME fPage0 = brHistorico:HEIGHT                   IN FRAME fPage0 - (deHeightDif / 2)

           bt-it-faturavel:ROW                  IN FRAME fPage0 = (brHistorico:ROW IN FRAME fPage0 + brHistorico:HEIGHT IN FRAME fPage0 + 0.4).
   
    ASSIGN RECT-1:VISIBLE IN FRAME fPage0 = YES
           RECT-2:VISIBLE IN FRAME fPage0 = YES
           RECT-3:VISIBLE IN FRAME fPage0 = YES.

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
ON MOUSE-SELECT-CLICK OF brHistorico IN FRAME fpage0
DO:
   IF tt-histor-integra-item.char-1:SCREEN-VALUE IN BROWSE brHistorico <> '' THEN
      ASSIGN brHistorico:TOOLTIP IN FRAME {&FRAME-NAME} = tt-histor-integra-item.char-1:SCREEN-VALUE IN BROWSE brHistorico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON ROW-DISPLAY OF brHistorico IN FRAME fpage0
DO:
   IF tt-histor-integra-item.pendente-fat = YES THEN DO:
      ASSIGN tt-histor-integra-item.data             :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.hora             :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cod-estabel      :BGCOLOR IN BROWSE brHistorico  = 14
             c-estado                             :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.char-2           :BGCOLOR IN BROWSE brHistorico  = 14 
             tt-histor-integra-item.acao             :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.it-codigo        :BGCOLOR IN BROWSE brHistorico  = 14
             ITEM.desc-item                       :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.codigo-orig      :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.ge-codigo        :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.fm-codigo        :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.fm-cod-com       :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.class-fiscal     :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.lei-informatica  :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.ind-item-fat     :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cd0755           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cd0355           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cd0356           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cd0903           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.cd0904a          :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.escdp050         :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.ft0312           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.of0147           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.tipo-item        :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.origem           :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.pendente-fat     :BGCOLOR IN BROWSE brHistorico  = 14
             tt-histor-integra-item.char-1           :BGCOLOR IN BROWSE brHistorico  = 14.
   END.
   ELSE
      ASSIGN tt-histor-integra-item.data             :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.hora             :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cod-estabel      :BGCOLOR IN BROWSE brHistorico  = 10
             c-estado                             :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.char-2           :BGCOLOR IN BROWSE brHistorico  = 10 
             tt-histor-integra-item.acao             :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.it-codigo        :BGCOLOR IN BROWSE brHistorico  = 10
             ITEM.desc-item                       :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.codigo-orig      :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.ge-codigo        :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.fm-codigo        :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.fm-cod-com       :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.class-fiscal     :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.lei-informatica  :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.ind-item-fat     :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cd0755           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cd0355           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cd0356           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cd0903           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.cd0904a          :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.escdp050         :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.ft0312           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.of0147           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.tipo-item        :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.origem           :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.pendente-fat     :BGCOLOR IN BROWSE brHistorico  = 10
             tt-histor-integra-item.char-1           :BGCOLOR IN BROWSE brHistorico  = 10.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON START-SEARCH OF brHistorico IN FRAME fpage0
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE hQueryHandle AS HANDLE        NO-UNDO.
  
    hSortColumn = BROWSE brHistorico:CURRENT-COLUMN.

    IF hSortColumn:NAME = 'data'     THEN LEAVE.
    IF hSortColumn:NAME = 'c-estado' THEN LEAVE.

    FIND FIRST prog_dtsul WHERE prog_dtsul.cod_prog_dtsul = hSortColumn:NAME NO-LOCK NO-ERROR.

    IF AVAIL prog_dtsul THEN
       MESSAGE 'Programa: '  UPPER(prog_dtsul.cod_prog_dtsul) SKIP(1) 
               'Descricao: ' prog_dtsul.des_prog_dtsul
           VIEW-AS ALERT-BOX WARNING BUTTONS OK.


    IF hSortColumn:DATA-TYPE = 'LOGICAL' THEN LEAVE.


    hQueryHandle = BROWSE brHistorico:QUERY.
    hQueryHandle:QUERY-CLOSE().
    hQueryHandle:QUERY-PREPARE("FOR EACH tt-histor-integra-item NO-LOCK " +
                               ", "  + 
                               "EACH item OF tt-histor-integra-item " + 
                               "WHERE mgcad.item.it-codigo = tt-histor-integra-item.it-codigo NO-LOCK BY " + hSortColumn:NAME).

    hQueryHandle:QUERY-OPEN().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-it-faturavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-it-faturavel wWindow
ON CHOOSE OF bt-it-faturavel IN FRAME fpage0 /* Tornar Item Faturavel */
DO:   
   DEFINE VARIABLE l-faturavel      AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE c-motivo-pend    AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-seq-histor     AS INTEGER     NO-UNDO.

   FIND CURRENT tt-histor-integra-item NO-ERROR.

   IF AVAIL tt-histor-integra-item THEN DO:

      FIND FIRST histor-integra-item
           WHERE ROWID(histor-integra-item) = tt-histor-integra-item.r-rowid
      EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL histor-integra-item THEN DO:
         FIND FIRST ITEM WHERE item.it-codigo = histor-integra-item.it-codigo NO-LOCK NO-ERROR.
    
         IF NOT AVAIL ITEM THEN DO:
            MESSAGE 'Item nao encontrado'
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
            RETURN NO-APPLY.
         END.
    
         IF NOT ITEM.ind-item-fat THEN DO:
            MESSAGE 'Item n∆o esta marcado como faturavel no cadastro CD0903' SKIP(1)
                    'Favor verificar antes de tornar o item faturavel' 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
            RETURN NO-APPLY.
         END.
    
    
         /* GERADOR SOLAR
         ASSIGN l-faturavel = YES.
    
         RUN esp/es0018p.p (INPUT  'esapi025',
                            INPUT  3,
                            INPUT  0,
                            INPUT  "":U,
                            OUTPUT TABLE tt-prog-ponto).
         
         FOR EACH tt-prog-ponto:
             IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
                 ASSIGN l-faturavel = NO.
         END.
         
         
         IF NOT l-faturavel THEN DO:
            MESSAGE 'NCM informada nao permitida para tornar o Item faturavel'
                    'NCM: ' ITEM.class-fiscal
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
            RETURN NO-APPLY.
         END.
         */
    
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 27100,                                            
                            INPUT 'Deseja tornar Faturavel o Item Codigo: ' + histor-integra-item.it-codigo + ' ?').
        
         IF RETURN-VALUE <> 'yes' THEN LEAVE.
    
         ASSIGN i-seq-histor = histor-integra-item.sequencia.
    
         /*  Atualiza tabela de log - ESCDP094 */
         RUN pi-cria-historico (INPUT histor-integra-item.it-codigo,  
                                INPUT-OUTPUT i-seq-histor, 
                                INPUT histor-integra-item.lei-informatica,
                                INPUT histor-integra-item.tipo-item,      
                                INPUT histor-integra-item.char-3,
                                INPUT histor-integra-item.origem). /*Pais Ori*/   
         
         RUN esapi/esapi025b.p (INPUT histor-integra-item.it-codigo,
                                INPUT histor-integra-item.sequencia,
                                OUTPUT c-motivo-pend).
    
         IF c-motivo-pend <> '' THEN
            MESSAGE 'Erro ao tornar Item Faturavel !! ' SKIP(2)
                    c-motivo-pend
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
         ELSE DO:
            MESSAGE 'Item tornou-se Faturavel com Sucesso !!'
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.           

            RUN filtrarHistorico IN THIS-PROCEDURE.
         END.
    
         {&open-query-brHistorico}
      END.
   END.
   ELSE
      MESSAGE 'Nenhum registro selecionado'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

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
ON RETURN OF datIntegIni IN FRAME fpage0 /* Data Integraá∆o */
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-fim wWindow
ON RETURN OF fi-item-fim IN FRAME fpage0
DO:
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-ini wWindow
ON RETURN OF fi-item-ini IN FRAME fpage0 /* Produto */
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

    ASSIGN datIntegIni:SCREEN-VALUE IN FRAME fPage0 = STRING(TODAY - 1)
           datIntegFin:SCREEN-VALUE IN FRAME fPage0 = STRING(TODAY).

    ASSIGN bt-it-faturavel:SENSITIVE IN FRAME fPage0 = NO.
    
    APPLY "CHOOSE":U TO btFiltrar IN FRAME fPage0.

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

    /*DO iAux = 1 TO NUM-ENTRIES(cListaTpInteg, ",":U):
        IF iAux = 1 THEN
            ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = ENTRY(iAux, cListaTpInteg, ",":U) + ",":U + TRIM(STRING(iAux)).
        ELSE
            ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 + ",":U + ENTRY(iAux, cListaTpInteg, ",":U) + ",":U + TRIM(STRING(iAux)).
    END.

    ASSIGN cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 = cbTipoInteg:LIST-ITEM-PAIRS IN FRAME fPage0 + ",":U + "Todos":U + ",":U + TRIM(STRING(NUM-ENTRIES(cListaTpInteg, ",":U) + 1)).

    ASSIGN cbTipoInteg = NUM-ENTRIES(cListaTpInteg, ",":U) + 1.

    DISPLAY cbTipoInteg
        WITH FRAME fPage0.*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  DISPLAY i-lista datIntegIni datIntegFin fi-item-ini fi-item-fim 
      WITH FRAME fpage0 IN WINDOW wWindow.
  ENABLE brHistorico i-lista datIntegIni datIntegFin btFiltrar btExit 
         fi-item-ini fi-item-fim IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 RECT-1 RECT-2 
         RECT-3 RECT-5 
      WITH FRAME fpage0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
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

  FOR EACH tt-histor-integra-item: DELETE tt-histor-integra-item. END.
             
  FOR EACH histor-integra-item NO-LOCK
      WHERE histor-integra-item.it-codigo >= fi-item-ini:SCREEN-VALUE IN FRAME fpage0
        AND histor-integra-item.it-codigo <= fi-item-fim:SCREEN-VALUE IN FRAME fpage0
        AND histor-integra-item.data >= DATE(datIntegIni:SCREEN-VALUE IN FRAME fpage0)
        AND histor-integra-item.data <= DATE(datIntegFin:SCREEN-VALUE IN FRAME fpage0),
      FIRST ITEM NO-LOCK 
      WHERE ITEM.it-codigo = histor-integra-item.it-codigo
      BREAK BY histor-integra-item.it-codigo
            BY histor-integra-item.data
            BY histor-integra-item.hora:

      CASE i-lista:SCREEN-VALUE IN FRAME fpage0:
         WHEN '1' THEN IF NOT histor-integra-item.pendente-fat    THEN NEXT.
         WHEN '2' THEN IF histor-integra-item.pendente-fat        THEN NEXT. 
         WHEN '3' THEN IF NOT histor-integra-item.ind-item-fat    THEN NEXT.
         WHEN '4' THEN IF histor-integra-item.ind-item-fat        THEN NEXT.
         WHEN '5' THEN IF NOT histor-integra-item.lei-informatica THEN NEXT.
         WHEN '6' THEN IF histor-integra-item.acao <> 'ADD'       THEN NEXT.
         WHEN '7' THEN IF histor-integra-item.acao <> 'MOD'       THEN NEXT.
      END CASE.
       
      IF i-lista:SCREEN-VALUE IN FRAME fpage0 <> '8' THEN DO:
         CREATE tt-histor-integra-item.
         BUFFER-COPY histor-integra-item TO tt-histor-integra-item.
         BUFFER-COPY ITEM EXCEPT char-1 char-2 TO tt-histor-integra-item. 

         ASSIGN tt-histor-integra-item.r-rowid = ROWID(histor-integra-item).
      END.
      ELSE DO:
         IF LAST-OF(histor-integra-item.it-codigo) THEN DO:
            CREATE tt-histor-integra-item.
            BUFFER-COPY histor-integra-item TO tt-histor-integra-item.
            BUFFER-COPY ITEM EXCEPT char-1 char-2 TO tt-histor-integra-item. 
            
            ASSIGN tt-histor-integra-item.r-rowid = ROWID(histor-integra-item).
         END.
      END.

  END.

  {&OPEN-QUERY-brHistorico}

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnEstado wWindow 
FUNCTION FnEstado RETURNS CHARACTER
  ( cEstab AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND estabelec WHERE estabelec.cod-estabel = cEstab NO-LOCK NO-ERROR.

  IF AVAIL estabelec THEN
     RETURN estabelec.estado.
  ELSE
     RETURN "".   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnRegra wWindow 
FUNCTION FnRegra RETURNS CHARACTER
  ( i-regra AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE i-regra:
      WHEN 0 THEN
          RETURN ''.
      WHEN 1 THEN
          RETURN 'Lei Informatica Item Fabr.'.
      WHEN 2 THEN
          RETURN 'Lei Informatica Item Revenda'.
      WHEN 3 THEN
          RETURN 'FCI'.
      WHEN 4 THEN
          RETURN 'Manaus'.
      WHEN 5 THEN
          RETURN ''.
      WHEN 6 THEN
          RETURN 'Servicos'.
      WHEN 7 THEN
          RETURN 'Item Combo'.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

