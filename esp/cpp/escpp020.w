&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-item-fornec NO-UNDO LIKE int-item-fornec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-kit NO-UNDO LIKE int-kit
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttitem-ean NO-UNDO LIKE item-ean
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP020 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP020
&GLOBAL-DEFINE Version        2.04.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Geral,Adicionais,T‚cnica,Auxiliar,Kit, Mac Address, NS/Conte£do,Operadoras

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttitem-ean
&GLOBAL-DEFINE hDBOTable      httitem-ean
&GLOBAL-DEFINE DBOTable       httitem-ean

&GLOBAL-DEFINE page0KeyFields   ttitem-ean.it-codigo
&GLOBAL-DEFINE page0Fields      ttitem-ean.it-codigo   
&GLOBAL-DEFINE page1Fields      ttitem-ean.linha[1] ttitem-ean.linha[2]                       ~
                                ttitem-ean.fone ttitem-ean.destaque ttitem-ean.origem         ~
                                ttitem-ean.nome-abrev ttitem-ean.char-2 ttitem-ean.char-3 ttitem-ean.tp-fabric
&GLOBAL-DEFINE page2Fields      ttitem-ean.texto[1] ttitem-ean.texto[10] ttitem-ean.texto[11] ~
                                ttitem-ean.texto[12] ttitem-ean.texto[13]ttitem-ean.texto[14] ~
                                ttitem-ean.texto[15] ttitem-ean.texto[2] ttitem-ean.texto[3]  ~
                                ttitem-ean.texto[4] ttitem-ean.texto[5] ttitem-ean.texto[6]   ~
                                ttitem-ean.texto[7] ttitem-ean.texto[8] ttitem-ean.texto[9]   ~
                                ttitem-ean.lmarcador[1] ttitem-ean.lmarcador[2]               ~
                                ttitem-ean.lmarcador[3] ttitem-ean.lmarcador[4]               ~
                                ttitem-ean.lmarcador[5] ttitem-ean.lmarcador[6]               ~
                                ttitem-ean.lmarcador[7] ttitem-ean.lmarcador[8]               ~
                                ttitem-ean.lmarcador[9] ttitem-ean.lmarcador[10]              ~
                                ttitem-ean.lmarcador[11] ttitem-ean.lmarcador[12]             ~
                                ttitem-ean.lmarcador[13] ttitem-ean.lmarcador[14]             ~
                                ttitem-ean.lmarcador[15]
&GLOBAL-DEFINE page3Fields      ttItem-ean.homolog ttItem-ean.info-tec[1] ~
                                ttItem-ean.info-tec[2] ttItem-ean.info-tec[3] ~
                                ttItem-ean.nc ttItem-ean.MODULO ttItem-ean.log-banda-ku ~
                                ttItem-ean.cod-sap
&GLOBAL-DEFINE page4Fields      cb-tipo-01 cb-tipo-02 cb-tipo-03 fi-linha-1-1 fi-linha-1-2 fi-linha-2-1 fi-linha-2-2 fi-linha-3-1 fi-linha-3-2

&GLOBAL-DEFINE page5Fields

&GLOBAL-DEFINE page6Fields      ttitem-ean.imei ttitem-ean.qtd-mac cb-modelo

&GLOBAL-DEFINE page7Fields      ttitem-ean.qtd-ns c-conteudo-1 c-conteudo-2 c-conteudo-3 c-conteudo-4 c-conteudo-5 c-conteudo-6

&GLOBAL-DEFINE page8Fields      ttitem-ean.operadora

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-updating AS LOGICAL     NO-UNDO.
DEFINE VARIABLE latualiza  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-libera   AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE c-item     LIKE item.it-codigo NO-UNDO.
DEFINE VARIABLE c-ean13    AS CHARACTER   NO-UNDO FORMAT "x(13)":U.
DEFINE VARIABLE c-origem   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-des-unid-negoc LIKE unid-negoc.des-unid-negoc NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-acomp        AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin684    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boes700    AS HANDLE      NO-UNDO.

{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */
/*git*/
{esp/es0018.i}

DEFINE VARIABLE c-prefixoEAN-aux AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brCompKit

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-kit tt-int-item-fornec

/* Definitions for BROWSE brCompKit                                     */
&Scoped-define FIELDS-IN-QUERY-brCompKit tt-int-kit.sequencia ~
tt-int-kit.es-codigo fnDescItem(tt-int-kit.es-codigo) @ c-desc-item ~
tt-int-kit.qtd-produto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brCompKit 
&Scoped-define QUERY-STRING-brCompKit FOR EACH tt-int-kit NO-LOCK ~
    BY tt-int-kit.sequencia
&Scoped-define OPEN-QUERY-brCompKit OPEN QUERY brCompKit FOR EACH tt-int-kit NO-LOCK ~
    BY tt-int-kit.sequencia.
&Scoped-define TABLES-IN-QUERY-brCompKit tt-int-kit
&Scoped-define FIRST-TABLE-IN-QUERY-brCompKit tt-int-kit


/* Definitions for BROWSE brItemFornec                                  */
&Scoped-define FIELDS-IN-QUERY-brItemFornec tt-int-item-fornec.cod-emitente ~
fnDesEmit(tt-int-item-fornec.cod-emitente) tt-int-item-fornec.buffer-mac 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItemFornec ~
tt-int-item-fornec.buffer-mac 
&Scoped-define ENABLED-TABLES-IN-QUERY-brItemFornec tt-int-item-fornec
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brItemFornec tt-int-item-fornec
&Scoped-define QUERY-STRING-brItemFornec FOR EACH tt-int-item-fornec NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brItemFornec OPEN QUERY brItemFornec FOR EACH tt-int-item-fornec NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brItemFornec tt-int-item-fornec
&Scoped-define FIRST-TABLE-IN-QUERY-brItemFornec tt-int-item-fornec


/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-brCompKit}

/* Definitions for FRAME fPage6                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage6 ~
    ~{&OPEN-QUERY-brItemFornec}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem-ean.it-codigo 
&Scoped-define ENABLED-TABLES ttitem-ean
&Scoped-define FIRST-ENABLED-TABLE ttitem-ean
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btLista btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttitem-ean.it-codigo 
&Scoped-define DISPLAYED-TABLES ttitem-ean
&Scoped-define FIRST-DISPLAYED-TABLE ttitem-ean
&Scoped-Define DISPLAYED-OBJECTS fi-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 ttitem-ean.it-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBloqueia wMaintenance 
FUNCTION fnBloqueia RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesEmit wMaintenance 
FUNCTION fnDesEmit RETURNS CHARACTER
  (INPUT p-cod-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnModelo wMaintenance 
FUNCTION fnModelo RETURNS CHARACTER
  (p-tipo AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnModeloChar wMaintenance 
FUNCTION fnModeloChar RETURNS INTEGER
  (p-tipo AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipo wMaintenance 
FUNCTION fnTipo RETURNS CHARACTER
  (p-tipo AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDesc wMaintenance 
FUNCTION fnTipoDesc RETURNS INTEGER
  ( p-tipo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLista 
     IMAGE-UP FILE "image/im-det.bmp":U
     LABEL "List" 
     SIZE 4 BY 1.25 TOOLTIP "Listagem dos c¢digos EAN"
     FONT 4.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 4.75.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 4.75.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.58.

DEFINE VARIABLE cb-tipo-01 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Informa‡Æo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Num.S‚rie","C¢d.Item","Outros","Homologa‡Æo","NS + QrCode","Homologa‡Æo + Origem" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-02 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Informa‡Æo 2" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Num.S‚rie","C¢d.Item","Outros","Homologa‡Æo","NS + QrCode","Homologa‡Æo + Origem" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-03 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Informa‡Æo 3" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Num.S‚rie","C¢d.Item","Outros","Homologa‡Æo","NS + QrCode","Homologa‡Æo + Origem" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-linha-1-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 1" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE VARIABLE fi-linha-1-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 2" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE VARIABLE fi-linha-2-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 1" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE VARIABLE fi-linha-2-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 2" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE VARIABLE fi-linha-3-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 1" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE VARIABLE fi-linha-3-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linha 2" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.58.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.58.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.58.

DEFINE BUTTON bt-eliminar 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-modelo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modelo Mac-Address" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEMS "Somente c¢digo de barras","C¢digo de barras + gponsn","Somente qr-code","Qr-code com senha m ster","Qr-code com senha m ster e acesso remoto","MAC + GPON C¢digo de Barra","Qr-code com senha m ster e acesso remoto Positron","MAC + GPON C¢digo de Barra Tripla","QR CODE com senha ADMIN + Senha WIFI" 
     DROP-DOWN-LIST
     SIZE 39.14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.

DEFINE VARIABLE c-conteudo-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 1" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-conteudo-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 2" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-conteudo-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 3" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-conteudo-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 4" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-conteudo-5 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 5" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-conteudo-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conte£do 6" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 7.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brCompKit FOR 
      tt-int-kit SCROLLING.

DEFINE QUERY brItemFornec FOR 
      tt-int-item-fornec SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brCompKit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brCompKit wMaintenance _STRUCTURED
  QUERY brCompKit NO-LOCK DISPLAY
      tt-int-kit.sequencia FORMAT ">>>>9":U
      tt-int-kit.es-codigo FORMAT "x(7)":U WIDTH 10
      fnDescItem(tt-int-kit.es-codigo) @ c-desc-item COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)":U
            WIDTH 47
      tt-int-kit.qtd-produto COLUMN-LABEL "Qtd Prod" FORMAT ">>>>9":U
            WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 10.75
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE brItemFornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItemFornec wMaintenance _STRUCTURED
  QUERY brItemFornec NO-LOCK DISPLAY
      tt-int-item-fornec.cod-emitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>9":U
            WIDTH 10.43
      fnDesEmit(tt-int-item-fornec.cod-emitente) COLUMN-LABEL "Nome Abrev." FORMAT "x(40)":U
            WIDTH 50.43
      tt-int-item-fornec.buffer-mac COLUMN-LABEL "% Buffer" FORMAT ">>9.99":U
            WIDTH 12.14
  ENABLE
      tt-int-item-fornec.buffer-mac
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btLista AT ROW 1.13 COL 60 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttitem-ean.it-codigo AT ROW 3 COL 5.29 COLON-ALIGNED
          LABEL "Item"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-desc-item AT ROW 3 COL 22.43 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.04
         FONT 1.

DEFINE FRAME fPage6
     ttitem-ean.imei AT ROW 2.17 COL 19 WIDGET-ID 10
          LABEL "IMEI"
          VIEW-AS TOGGLE-BOX
          SIZE 8 BY .83
     ttitem-ean.qtd-mac AT ROW 3.21 COL 16.86 COLON-ALIGNED WIDGET-ID 2 FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     cb-modelo AT ROW 4.21 COL 16.86 COLON-ALIGNED WIDGET-ID 4
     brItemFornec AT ROW 7.25 COL 4
     "Buffer Mac-Adress" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 6.25 COL 7 WIDGET-ID 8
     RECT-25 AT ROW 6.5 COL 2 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.2
         SIZE 84.43 BY 13.1
         FONT 1.

DEFINE FRAME fPage4
     fi-linha-1-1 AT ROW 2.04 COL 40 COLON-ALIGNED WIDGET-ID 32
     cb-tipo-01 AT ROW 2.5 COL 11 COLON-ALIGNED WIDGET-ID 26
     fi-linha-1-2 AT ROW 2.96 COL 40 COLON-ALIGNED WIDGET-ID 34
     fi-linha-2-1 AT ROW 5.67 COL 40 COLON-ALIGNED WIDGET-ID 36
     cb-tipo-02 AT ROW 6.13 COL 11 COLON-ALIGNED WIDGET-ID 28
     fi-linha-2-2 AT ROW 6.58 COL 40 COLON-ALIGNED WIDGET-ID 38
     fi-linha-3-1 AT ROW 9.33 COL 40 COLON-ALIGNED WIDGET-ID 40
     cb-tipo-03 AT ROW 9.71 COL 11 COLON-ALIGNED WIDGET-ID 30
     fi-linha-3-2 AT ROW 10.25 COL 40 COLON-ALIGNED WIDGET-ID 42
     "Etiquetinha 3:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 8.63 COL 4 WIDGET-ID 54
     "Etiquetinha 1:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.33 COL 3.86 WIDGET-ID 50
     "Etiquetinha 2:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5 COL 4 WIDGET-ID 52
     RECT-22 AT ROW 1.63 COL 2.29 WIDGET-ID 44
     RECT-23 AT ROW 5.25 COL 2.29 WIDGET-ID 46
     RECT-24 AT ROW 8.92 COL 2.29 WIDGET-ID 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     ttitem-ean.linha[1] AT ROW 3.96 COL 11.86 COLON-ALIGNED
          LABEL "Linha 1" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 64.14 BY .88
     ttitem-ean.linha[2] AT ROW 4.88 COL 11.86 COLON-ALIGNED
          LABEL "Linha 2" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 64.14 BY .88
     ttitem-ean.nome-abrev AT ROW 8.46 COL 11.86 COLON-ALIGNED WIDGET-ID 52
          LABEL "Modelo" FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     ttitem-ean.tp-fabric AT ROW 9.21 COL 47 COLON-ALIGNED WIDGET-ID 74
          LABEL "Tipo de Fabric"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "",0,
                     "CKD",1,
                     "SKD",2,
                     "OEM",3
          DROP-DOWN-LIST
          SIZE 29 BY 1
     ttitem-ean.destaque AT ROW 9.38 COL 11.86 COLON-ALIGNED WIDGET-ID 56 FORMAT "x(4)"
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     ttitem-ean.char-2 AT ROW 10.21 COL 47 COLON-ALIGNED HELP
          "" WIDGET-ID 66
          LABEL "Ind£stria"
          VIEW-AS COMBO-BOX INNER-LINES 4
          LIST-ITEM-PAIRS "INTELBRAS S/A","INTELBRAS S/A",
                     "Importado por INTELBRAS S/A","Importado por INTELBRAS S/A",
                     "Fabricado por:","Fabricado por:",
                     "Importado por:","Importado por:"
          DROP-DOWN-LIST
          SIZE 29 BY 1 TOOLTIP "Informar a ind£stria"
     ttitem-ean.fone AT ROW 10.29 COL 11.86 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 22.57 BY 1
     ttitem-ean.origem AT ROW 11.21 COL 11.86 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 22.57 BY 1
     ttitem-ean.char-3 AT ROW 11.21 COL 47 COLON-ALIGNED HELP
          "" WIDGET-ID 72
          LABEL "Identificador" FORMAT "x(30)"
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     "Descri‡Æo" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 2.25 COL 8.14 WIDGET-ID 62
          FGCOLOR 1 FONT 0
     RECT-20 AT ROW 2.5 COL 3 WIDGET-ID 58
     RECT-21 AT ROW 7.92 COL 3 WIDGET-ID 60
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1.

DEFINE FRAME fPage3
     ttitem-ean.homolog AT ROW 2.63 COL 12.29 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     ttitem-ean.nc AT ROW 3.58 COL 12.29 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     ttitem-ean.modulo AT ROW 4.46 COL 12.29 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     ttitem-ean.info-tec[1] AT ROW 6.46 COL 12.29 COLON-ALIGNED WIDGET-ID 44
          LABEL "[1]"
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     ttitem-ean.info-tec[2] AT ROW 7.38 COL 12.29 COLON-ALIGNED WIDGET-ID 54
          LABEL "[2]"
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     ttitem-ean.info-tec[3] AT ROW 8.29 COL 12.29 COLON-ALIGNED WIDGET-ID 56
          LABEL "[3]"
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     ttitem-ean.cod-sap AT ROW 10 COL 12.43 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     ttitem-ean.log-banda-ku AT ROW 10 COL 67 WIDGET-ID 70
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     "Informa‡äes T‚cnicas" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 5.71 COL 10 WIDGET-ID 52
          FGCOLOR 1 
     RECT-8 AT ROW 5.96 COL 3 WIDGET-ID 50
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1.

DEFINE FRAME fpage8
     ttitem-ean.operadora AT ROW 2.5 COL 12 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nenhum", 0,
"CLARO", 1,
"OI", 2,
"TIM", 3,
"VIVO", 4
          SIZE 63.29 BY 2.25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.21
         SIZE 85 BY 13.04 WIDGET-ID 500.

DEFINE FRAME fPage7
     ttitem-ean.qtd-ns AT ROW 2.29 COL 16.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-conteudo-1 AT ROW 7 COL 18 COLON-ALIGNED WIDGET-ID 18
     c-conteudo-2 AT ROW 8 COL 18 COLON-ALIGNED WIDGET-ID 20
     c-conteudo-3 AT ROW 9 COL 18 COLON-ALIGNED WIDGET-ID 22
     c-conteudo-4 AT ROW 10 COL 18 COLON-ALIGNED WIDGET-ID 24
     c-conteudo-5 AT ROW 11 COL 18 COLON-ALIGNED WIDGET-ID 26
     c-conteudo-6 AT ROW 12 COL 18 COLON-ALIGNED WIDGET-ID 28
     "Conte£do da Embalagem" VIEW-AS TEXT
          SIZE 19 BY .54 AT ROW 6.25 COL 5 WIDGET-ID 32
     RECT-26 AT ROW 6.5 COL 4 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.21
         SIZE 84.43 BY 13.08
         FONT 1.

DEFINE FRAME fpage5
     brCompKit AT ROW 1.75 COL 4 WIDGET-ID 300
     bt-incluir AT ROW 12.67 COL 4 WIDGET-ID 2
     bt-eliminar AT ROW 12.67 COL 14 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fpage2
     ttitem-ean.lmarcador[1] AT ROW 1.29 COL 2.72 RIGHT-ALIGNED WIDGET-ID 2
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[1] AT ROW 1.29 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Caixa"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[2] AT ROW 2.13 COL 1.72 WIDGET-ID 6
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[2] AT ROW 2.13 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Caixa"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[3] AT ROW 2.96 COL 1.72 WIDGET-ID 10
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[3] AT ROW 2.96 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Caixa"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[4] AT ROW 3.79 COL 1.72 WIDGET-ID 14
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[4] AT ROW 3.79 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Caixa"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[5] AT ROW 4.63 COL 1.72 WIDGET-ID 18
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[5] AT ROW 4.63 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[6] AT ROW 5.46 COL 1.72 WIDGET-ID 22
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[6] AT ROW 5.46 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[7] AT ROW 6.29 COL 1.72 WIDGET-ID 26
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[7] AT ROW 6.29 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[8] AT ROW 7.13 COL 1.72 WIDGET-ID 30
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[8] AT ROW 7.13 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[9] AT ROW 7.96 COL 1.72 WIDGET-ID 34
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[9] AT ROW 7.96 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[10] AT ROW 8.79 COL 1.72 WIDGET-ID 38
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[10] AT ROW 8.79 COL 11.86 COLON-ALIGNED
          LABEL "Inf Tec Prod"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[11] AT ROW 9.63 COL 1.72 WIDGET-ID 42
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[11] AT ROW 9.63 COL 11.86 COLON-ALIGNED
          LABEL ">>> 11"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[12] AT ROW 10.46 COL 1.72 WIDGET-ID 44
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage2
     ttitem-ean.texto[12] AT ROW 10.46 COL 11.86 COLON-ALIGNED
          LABEL "Prazo Valid"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[13] AT ROW 11.29 COL 1.72 WIDGET-ID 46
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[13] AT ROW 11.29 COL 11.86 COLON-ALIGNED
          LABEL ">>> 13"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[14] AT ROW 12.13 COL 1.72 WIDGET-ID 48
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[14] AT ROW 12.13 COL 11.86 COLON-ALIGNED
          LABEL "Composi‡Æo"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
     ttitem-ean.lmarcador[15] AT ROW 12.96 COL 1.72 WIDGET-ID 50
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .79
     ttitem-ean.texto[15] AT ROW 12.96 COL 11.86 COLON-ALIGNED
          LABEL "Composi‡Æo"
          VIEW-AS FILL-IN 
          SIZE 71.29 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.25
         SIZE 84.43 BY 13.1
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-item-fornec T "?" NO-UNDO mgesp int-item-fornec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-kit T "?" NO-UNDO mgesp int-kit
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttitem-ean T "?" NO-UNDO mgesp item-ean
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.13
         WIDTH              = 90
         MAX-HEIGHT         = 34
         MAX-WIDTH          = 219.43
         VIRTUAL-HEIGHT     = 34
         VIRTUAL-WIDTH      = 219.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fpage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE
       FRAME fpage8:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN ttitem-ean.it-codigo IN FRAME fpage0
   1 EXP-LABEL                                                          */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR COMBO-BOX ttitem-ean.char-2 IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN ttitem-ean.char-3 IN FRAME fPage1
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN ttitem-ean.destaque IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN ttitem-ean.linha[1] IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttitem-ean.linha[2] IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttitem-ean.nome-abrev IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX ttitem-ean.tp-fabric IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[10] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[11] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[12] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[13] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[14] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[15] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[1] IN FRAME fpage2
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[2] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[3] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[4] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[5] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[6] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[7] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[8] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.lmarcador[9] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[10] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[11] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[12] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[13] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[14] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[15] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[1] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[2] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[3] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[4] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[5] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[6] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[7] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[8] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.texto[9] IN FRAME fpage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN ttitem-ean.info-tec[1] IN FRAME fPage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.info-tec[2] IN FRAME fPage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.info-tec[3] IN FRAME fPage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* BROWSE-TAB brCompKit 1 fpage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* BROWSE-TAB brItemFornec cb-modelo fPage6 */
/* SETTINGS FOR TOGGLE-BOX ttitem-ean.imei IN FRAME fPage6
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-ean.qtd-mac IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage7
                                                                        */
/* SETTINGS FOR FRAME fpage8
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brCompKit
/* Query rebuild information for BROWSE brCompKit
     _TblList          = "Temp-Tables.tt-int-kit"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-int-kit.sequencia|yes"
     _FldNameList[1]   = Temp-Tables.tt-int-kit.sequencia
     _FldNameList[2]   > Temp-Tables.tt-int-kit.es-codigo
"tt-int-kit.es-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescItem(tt-int-kit.es-codigo) @ c-desc-item" "Descri‡Æo" "X(60)" ? ? ? ? ? ? ? no ? no no "47" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-kit.qtd-produto
"tt-int-kit.qtd-produto" "Qtd Prod" ? "integer" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brCompKit */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItemFornec
/* Query rebuild information for BROWSE brItemFornec
     _TblList          = "Temp-Tables.tt-int-item-fornec"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-int-item-fornec.cod-emitente
"tt-int-item-fornec.cod-emitente" "Fornecedor" ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDesEmit(tt-int-item-fornec.cod-emitente)" "Nome Abrev." "x(40)" ? ? ? ? ? ? ? no ? no no "50.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-item-fornec.buffer-mac
"tt-int-item-fornec.buffer-mac" "% Buffer" ? "decimal" ? ? ? ? ? ? yes ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brItemFornec */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage8
/* Query rebuild information for FRAME fpage8
     _Query            is NOT OPENED
*/  /* FRAME fpage8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage4 wMaintenance
ON ENTRY OF FRAME fPage4
DO:
    
    ASSIGN fi-linha-1-1:SENSITIVE IN FRAME fpage4 = cb-tipo-01:SENSITIVE IN FRAME fpage4.
           fi-linha-1-2:SENSITIVE IN FRAME fpage4 = cb-tipo-01:SENSITIVE IN FRAME fpage4.
           fi-linha-2-1:SENSITIVE IN FRAME fpage4 = cb-tipo-02:SENSITIVE IN FRAME fpage4.
           fi-linha-2-2:SENSITIVE IN FRAME fpage4 = cb-tipo-02:SENSITIVE IN FRAME fpage4.
           fi-linha-3-1:SENSITIVE IN FRAME fpage4 = cb-tipo-03:SENSITIVE IN FRAME fpage4.
           fi-linha-3-2:SENSITIVE IN FRAME fpage4 = cb-tipo-03:SENSITIVE IN FRAME fpage4.

           
    IF  cb-tipo-01:SCREEN-VALUE IN FRAME fpage4 <> "OUTROS" THEN
        ASSIGN fi-linha-1-1:SENSITIVE IN FRAME fpage4 = NO
               fi-linha-1-2:SENSITIVE IN FRAME fpage4 = NO.

    IF  cb-tipo-02:SCREEN-VALUE IN FRAME fpage4 <> "OUTROS" THEN
        ASSIGN fi-linha-2-1:SENSITIVE IN FRAME fpage4 = NO
               fi-linha-2-2:SENSITIVE IN FRAME fpage4 = NO.
 
    IF  cb-tipo-03:SCREEN-VALUE IN FRAME fpage4 <> "OUTROS" THEN
        ASSIGN fi-linha-3-1:SENSITIVE IN FRAME fpage4 = NO
               fi-linha-3-2:SENSITIVE IN FRAME fpage4 = NO.
           
           /*
    APPLY "value-changed" TO cb-tipo-01 IN FRAME fpage4.
    APPLY "value-changed" TO cb-tipo-02 IN FRAME fpage4.
    APPLY "value-changed" TO cb-tipo-03 IN FRAME fpage4.
*/    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wMaintenance
ON CHOOSE OF bt-eliminar IN FRAME fpage5 /* Eliminar */
DO:

    IF AVAIL tt-int-kit THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT "Deseja eliminar o componente do Kit ?").

        IF RETURN-VALUE = "YES" THEN DO:

            RUN RepositionRecord IN h-boes700 (tt-int-kit.r-rowid).

            RUN deleteRecord IN h-boes700.

            RUN openQueryKit.

        END.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fpage5 /* Incluir */
DO:

    IF AVAIL ttItem-ean AND ttItem-ean.r-rowid <> ? THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/cpp/escpp020b.w (INPUT ?,
                                 INPUT ttItem-ean.r-rowid,
                                 INPUT "ADD",
                                 INPUT THIS-PROCEDURE,
                                 INPUT 5).

        {&WINDOW-NAME}:SENSITIVE = TRUE.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN piManutBrowse(YES).
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN piManutBrowse(NO).
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN piManutBrowse(YES).
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLista wMaintenance
ON CHOOSE OF btLista IN FRAME fpage0 /* List */
DO:
  RUN esp/cpp/escpp020a.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    IF AVAIL tt-int-item-fornec THEN
        APPLY "LEAVE" TO tt-int-item-fornec.buffer-mac IN BROWSE brItemFornec.

    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK" THEN
        RUN piManutBrowse(NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es107.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    l-updating = YES.
    RUN piManutBrowse(YES).
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME cb-tipo-01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-01 wMaintenance
ON VALUE-CHANGED OF cb-tipo-01 IN FRAME fPage4 /* Informa‡Æo 1 */
DO:

    RUN pi-habilita-linhas (INPUT 1).
    RUN pi-mostra-linhas   (INPUT 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-02 wMaintenance
ON VALUE-CHANGED OF cb-tipo-02 IN FRAME fPage4 /* Informa‡Æo 2 */
DO:
     RUN pi-habilita-linhas (INPUT 2).
     RUN pi-mostra-linhas   (INPUT 2).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-03 wMaintenance
ON VALUE-CHANGED OF cb-tipo-03 IN FRAME fPage4 /* Informa‡Æo 3 */
DO:
    RUN pi-habilita-linhas (INPUT 3).
    RUN pi-mostra-linhas   (INPUT 3).
                                   
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttitem-ean.char-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-ean.char-2 wMaintenance
ON VALUE-CHANGED OF ttitem-ean.char-2 IN FRAME fPage1 /* Ind£stria */
DO:
   IF SELF:SCREEN-VALUE = "Fabricado por:"
   OR SELF:SCREEN-VALUE = "Importado por:" THEN DO:
       ASSIGN ttitem-ean.char-3:SENSITIVE IN FRAME fPage1 = YES.
   END.
   ELSE DO:
       ASSIGN ttitem-ean.char-3:SCREEN-VALUE IN FRAME fPage1 = ""
              ttitem-ean.char-3:SENSITIVE IN FRAME fPage1 = NO.
   END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttitem-ean.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-ean.it-codigo wMaintenance
ON F5 OF ttitem-ean.it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage0"
                       &campo2="ttitem-ean.it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-ean.it-codigo wMaintenance
ON LEAVE OF ttitem-ean.it-codigo IN FRAME fpage0 /* Item */
DO:
    DEF BUFFER bitem FOR ITEM.

    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = self:screen-value in frame fpage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-ean.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttitem-ean.it-codigo IN FRAME fpage0 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brCompKit
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


ttitem-ean.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

ON 'LEAVE':U OF tt-int-item-fornec.buffer-mac IN BROWSE brItemFornec DO:
    IF AVAIL tt-int-item-fornec THEN
        ASSIGN tt-int-item-fornec.buffer-mac = DECIMAL(tt-int-item-fornec.buffer-mac:SCREEN-VALUE IN BROWSE brItemFornec).
END.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterControlToolBar wMaintenance 
PROCEDURE afterControlToolBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    fnBloqueia().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE v-qtd-linha AS INTEGER NO-UNDO.
DEFINE VARIABLE h-api023    AS HANDLE  NO-UNDO.

IF AVAIL ttitem-ean THEN DO:

    ASSIGN c-conteudo-1:SCREEN-VALUE IN FRAME fPage7 = ""
           c-conteudo-2:SCREEN-VALUE IN FRAME fPage7 = ""
           c-conteudo-3:SCREEN-VALUE IN FRAME fPage7 = ""
           c-conteudo-4:SCREEN-VALUE IN FRAME fPage7 = ""
           c-conteudo-5:SCREEN-VALUE IN FRAME fPage7 = ""
           c-conteudo-6:SCREEN-VALUE IN FRAME fPage7 = "".

    ASSIGN c-conteudo-1:SCREEN-VALUE IN FRAME fPage7 = ENTRY(1,ttitem-ean.desc-kit,";") NO-ERROR. 
    ASSIGN c-conteudo-2:SCREEN-VALUE IN FRAME fPage7 = ENTRY(2,ttitem-ean.desc-kit,";") NO-ERROR. 
    ASSIGN c-conteudo-3:SCREEN-VALUE IN FRAME fPage7 = ENTRY(3,ttitem-ean.desc-kit,";") NO-ERROR. 
    ASSIGN c-conteudo-4:SCREEN-VALUE IN FRAME fPage7 = ENTRY(4,ttitem-ean.desc-kit,";") NO-ERROR. 
    ASSIGN c-conteudo-5:SCREEN-VALUE IN FRAME fPage7 = ENTRY(5,ttitem-ean.desc-kit,";") NO-ERROR. 
    ASSIGN c-conteudo-6:SCREEN-VALUE IN FRAME fPage7 = ENTRY(6,ttitem-ean.desc-kit,";") NO-ERROR.

    FOR FIRST ITEM FIELDS (desc-item) NO-LOCK 
        WHERE ITEM.it-codigo = ttitem-ean.it-codigo:
        DISP ITEM.desc-item @ fi-desc-item WITH FRAME fpage0.
    END.

    ASSIGN ttItem-ean.origem:SCREEN-VALUE IN FRAME fPage1 = (IF ttItem-ean.origem = "" THEN " " ELSE ttItem-ean.origem)
           ttItem-ean.fone  :SCREEN-VALUE IN FRAME fPage1 = (IF ttItem-ean.fone   = "" THEN " " ELSE ttItem-ean.fone).

    ASSIGN cb-tipo-01:SCREEN-VALUE IN FRAME fpage4 = fnTipo(ttItem-ean.etiq-1-tipo)
           cb-tipo-02:SCREEN-VALUE IN FRAME fpage4 = fnTipo(ttItem-ean.etiq-2-tipo)
           cb-tipo-03:SCREEN-VALUE IN FRAME fpage4 = fnTipo(ttItem-ean.etiq-3-tipo)
           cb-modelo:SCREEN-VALUE  IN FRAME fpage6 = fnModelo(ttitem-ean.modelo-mac-address).
            

END.
ELSE DO:
    ASSIGN ttItem-ean.origem:SCREEN-VALUE IN FRAME fPage1 = " "
           ttItem-ean.fone  :SCREEN-VALUE IN FRAME fPage1 = " "
           cb-modelo:SCREEN-VALUE IN FRAME fpage6 = fnModelo(INPUT 1).

    ASSIGN cb-tipo-01:SCREEN-VALUE IN FRAME fpage4 = "Num.S‚rie"
           cb-tipo-02:SCREEN-VALUE IN FRAME fpage4 = "Num.S‚rie"
           cb-tipo-03:SCREEN-VALUE IN FRAME fpage4 = "Num.S‚rie".

END.

ENABLE btLista WITH FRAME fpage0.

RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piCarregaItemFornec IN h-api023 (INPUT INPUT FRAME fPage0 ttitem-ean.it-codigo,
                                     OUTPUT TABLE tt-int-item-fornec).

IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.

{&OPEN-QUERY-brItemFornec}

RUN OpenQueryKit.

RUN pi-mostra-linhas(1).
RUN pi-mostra-linhas(2).
RUN pi-mostra-linhas(3).


ASSIGN fi-linha-1-1:SENSITIVE IN FRAME fpage4 = cb-tipo-01:SENSITIVE IN FRAME fpage4.
       fi-linha-1-2:SENSITIVE IN FRAME fpage4 = cb-tipo-01:SENSITIVE IN FRAME fpage4.
       fi-linha-2-1:SENSITIVE IN FRAME fpage4 = cb-tipo-02:SENSITIVE IN FRAME fpage4.
       fi-linha-2-2:SENSITIVE IN FRAME fpage4 = cb-tipo-02:SENSITIVE IN FRAME fpage4.
       fi-linha-3-1:SENSITIVE IN FRAME fpage4 = cb-tipo-03:SENSITIVE IN FRAME fpage4.
       fi-linha-3-2:SENSITIVE IN FRAME fpage4 = cb-tipo-03:SENSITIVE IN FRAME fpage4.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    
    IF  l-updating THEN DO:
        DISABLE {&List-1} WITH FRAME fpage0.
        run setFolder IN hFolder (input 1).
        APPLY "entry" TO ttitem-ean.linha[1] IN FRAME fpage1.
    END. /* IF  l-updating THEN */
    
    ASSIGN l-updating = NO.

    IF  cAction = "UPDATE" THEN DO:
        /* Caso tenha n£meros de s‚ries relacionados, dever  habilitar o campo quantidade do folder "S‚rie Relac." */
        FIND FIRST int-estabelec NO-LOCK
            WHERE  int-estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
        IF  NOT AVAIL int-estabelec 
        THEN FIND FIRST int-estabelec NO-LOCK
                WHERE   int-estabelec.cod-estabel = "101" NO-ERROR.
    
        IF  AVAIL int-estabelec
        THEN ASSIGN c-prefixoEAN-aux = TRIM(STRING(int-estabelec.prefixo-ean13)).
        ELSE ASSIGN c-prefixoEAN-aux = "".

        ASSIGN cb-tipo-01:SENSITIVE IN FRAME fpage4 = yes
               cb-tipo-02:SENSITIVE IN FRAME fpage4 = yes
               cb-tipo-03:SENSITIVE IN FRAME fpage4 = yes
               cb-modelo:SENSITIVE IN FRAME fpage6  = YES.
    END. /* IF  cAction = "UPDATE" THEN DO: */
    ELSE
        ASSIGN cb-tipo-01:SENSITIVE IN FRAME fpage4 = NO
               cb-tipo-02:SENSITIVE IN FRAME fpage4 = NO
               cb-tipo-03:SENSITIVE IN FRAME fpage4 = NO
               cb-modelo:SENSITIVE IN FRAME fpage6  = NO.

     APPLY "value-changed" TO cb-tipo-01.
     APPLY "value-changed" TO cb-tipo-02.
     APPLY "value-changed" TO cb-tipo-03.
     APPLY "value-changed" TO ttitem-ean.char-2.

        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


        RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   
                           
        l-libera = can-find(first tt-prog-ponto
                            where tt-prog-ponto.conteudo = c-seg-usuario).    
                            
        fnBloqueia().

        ENABLE brItemFornec
            WITH FRAME fPage6.
        ASSIGN tt-int-item-fornec.buffer-mac:READ-ONLY IN BROWSE brItemFornec = YES.

        ENABLE brCompKit
            WITH FRAME fPage5.

/*         ASSIGN ttItem-ean.origem:LIST-ITEM-PAIRS IN FRAME fPage1 = ",,Origem: Brasil,Origem: Brasil". */
/*
Origem: China,Origem: China,
Made in Brazil,Made in Brazil,
Made in China,Made in China,
Hecho en Brasil,Hecho en Brasil,
Hecho en China,Hecho en China*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                   INPUT 2,            /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

ttItem-ean.origem:LIST-ITEMS IN FRAME fPage1 = "".
ttItem-ean.origem:ADD-LAST("").
FOR EACH tt-prog-ponto:
    ttItem-ean.origem:ADD-LAST(tt-prog-ponto.conteudo).
END.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                   INPUT 3,            /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

ttItem-ean.fone:LIST-ITEMS IN FRAME fPage1 = "".
ttItem-ean.fone:ADD-LAST("").
FOR EACH tt-prog-ponto:
    ttItem-ean.fone:ADD-LAST(tt-prog-ponto.conteudo).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-api023 AS HANDLE NO-UNDO.

    
    ASSIGN ttitem-ean.etiq-1-tipo = fnTipoDesc(INPUT FRAME fpage4 cb-tipo-01) 
           ttitem-ean.etiq-2-tipo = fnTipoDesc(INPUT FRAME fpage4 cb-tipo-02)
           ttitem-ean.etiq-3-tipo = fnTipoDesc(INPUT FRAME fpage4 cb-tipo-03).


    ASSIGN ttitem-ean.etiq-1-info[1] = fi-linha-1-1:screen-value in  FRAME fpage4 
           ttitem-ean.etiq-1-info[2] = fi-linha-1-2:screen-value in  FRAME fpage4 
           ttitem-ean.etiq-2-info[1] = fi-linha-2-1:screen-value in  FRAME fpage4 
           ttitem-ean.etiq-2-info[2] = fi-linha-2-2:screen-value in  FRAME fpage4 
           ttitem-ean.etiq-3-info[1] = fi-linha-3-1:screen-value in  FRAME fpage4 
           ttitem-ean.etiq-3-info[2] = fi-linha-3-2:screen-value in  FRAME fpage4 
           ttitem-ean.modelo-mac-address = fnModeloChar (INPUT FRAME fpage6 cb-modelo).


    ASSIGN ttitem-ean.desc-kit = "".
    ASSIGN ttitem-ean.desc-kit = replace(c-conteudo-1:SCREEN-VALUE IN FRAME fPage7,";",",") + ";"
           ttitem-ean.desc-kit = ttitem-ean.desc-kit + replace(c-conteudo-2:SCREEN-VALUE IN FRAME fPage7,";",",") + ";"
           ttitem-ean.desc-kit = ttitem-ean.desc-kit + replace(c-conteudo-3:SCREEN-VALUE IN FRAME fPage7,";",",") + ";"
           ttitem-ean.desc-kit = ttitem-ean.desc-kit + replace(c-conteudo-4:SCREEN-VALUE IN FRAME fPage7,";",",") + ";"
           ttitem-ean.desc-kit = ttitem-ean.desc-kit + replace(c-conteudo-5:SCREEN-VALUE IN FRAME fPage7,";",",") + ";"
           ttitem-ean.desc-kit = ttitem-ean.desc-kit + replace(c-conteudo-6:SCREEN-VALUE IN FRAME fPage7,";",",") + ";".

    RUN esapi/esapi023.p PERSISTENT SET h-api023.
    
    RUN piAtualizaItemFornec IN h-api023 (INPUT TABLE tt-int-item-fornec).
    
    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.
    
    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDboSonHandle wMaintenance 
PROCEDURE getDboSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     Retorna handle do DBO Filho
  Parameters:  recebe nœmero da pÿgina
               retorna handle do DBO
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.


    IF pPageNumber = 5 THEN
        ASSIGN pDBOHandle = h-boes700.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna temp-table {&ttParent} com o registro corrente
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttItem-ean.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Cadastro Item Etiqueta" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        

        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Parƒmetro Item Etiqueta":U).            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes107.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes107.p YES}
        {btb/btb008za.i2 esbo\boes107.p '' {&hDBOTable}}
    END.

    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.   
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boes700) OR
       h-boes700:TYPE <> "PROCEDURE":U OR
       h-boes700:FILE-NAME <> "boes700.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes700.p YES}
        {btb/btb008za.i2 esbo/boes700.p '' h-boes700}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryKit wMaintenance 
PROCEDURE openQueryKit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE v-qtd-linha AS INTEGER     NO-UNDO.


    EMPTY TEMP-TABLE tt-int-kit.

    RUN setConstraintItCodigo IN h-boes700 (INPUT INPUT FRAME fpage0 ttitem-ean.it-codigo).

    RUN openQueryStatic IN h-boes700 (INPUT "ItCodigo").

    RUN getBatchRecords IN h-boes700 (INPUT  ?,
                                      INPUT  ?,
                                      INPUT  ?,
                                      OUTPUT v-qtd-linha,
                                      OUTPUT TABLE tt-int-kit).

    {&OPEN-QUERY-brCompKit}

    IF CAN-FIND(FIRST tt-int-kit) THEN DO:
        ASSIGN bt-eliminar:SENSITIVE IN FRAME fPage5 = TRUE.
    END.
    ELSE DO:
        ASSIGN bt-eliminar:SENSITIVE IN FRAME fPage5 = FALSE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-linhas wMaintenance 
PROCEDURE pi-habilita-linhas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-combo AS INTEGER NO-UNDO.

    DO WITH FRAME fpage4:

        IF  p-combo = 1  THEN DO: /*INFORMA€ÇO 1*/
            IF  cb-tipo-01:SCREEN-VALUE = "outros" THEN
                ASSIGN fi-linha-1-1:SENSITIVE = YES
                       fi-linha-1-2:SENSITIVE = YES.
            ELSE 
                ASSIGN fi-linha-1-1:SENSITIVE = NO 
                       fi-linha-1-2:SENSITIVE = NO.
        END.

        IF  p-combo = 2  THEN DO: /*INFORMA€ÇO 2*/
            IF  cb-tipo-02:SCREEN-VALUE = "outros" THEN 
                ASSIGN fi-linha-2-1:SENSITIVE = YES
                       fi-linha-2-2:SENSITIVE = YES.
            ELSE
                ASSIGN fi-linha-2-1:SENSITIVE = NO 
                       fi-linha-2-2:SENSITIVE = NO.
        END.

        IF  p-combo = 3  THEN DO: /*INFORMA€ÇO 3*/
            IF  cb-tipo-03:SCREEN-VALUE = "outros" THEN 
                ASSIGN fi-linha-3-1:SENSITIVE = YES
                       fi-linha-3-2:SENSITIVE = YES.
            ELSE 
                ASSIGN fi-linha-3-1:SENSITIVE = NO 
                       fi-linha-3-2:SENSITIVE = NO.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-linhas wMaintenance 
PROCEDURE pi-mostra-linhas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-combo AS INTEGER NO-UNDO.

    DO WITH FRAME fpage4:

        IF  p-combo = 1  THEN DO: /*INFORMA€ÇO 1*/
            IF  cb-tipo-01:SCREEN-VALUE = "outros" THEN
                ASSIGN fi-linha-1-1:SCREEN-VALUE = ttitem-ean.etiq-1-info[1]
                       fi-linha-1-2:SCREEN-VALUE = ttitem-ean.etiq-1-info[2].
            ELSE        
                ASSIGN fi-linha-1-1:SCREEN-VALUE = ""
                       fi-linha-1-2:SCREEN-VALUE = "".
        END.

        IF  p-combo = 2  THEN DO: /*INFORMA€ÇO 2*/
            IF  cb-tipo-02:SCREEN-VALUE = "outros" THEN 
                ASSIGN fi-linha-2-1:SCREEN-VALUE = ttitem-ean.etiq-2-info[1]
                       fi-linha-2-2:SCREEN-VALUE = ttitem-ean.etiq-2-info[2].
            ELSE
                ASSIGN fi-linha-2-1:SCREEN-VALUE = ""
                       fi-linha-2-2:SCREEN-VALUE = "".
        END.

        IF  p-combo = 3  THEN DO: /*INFORMA€ÇO 3*/
            IF  cb-tipo-03:SCREEN-VALUE = "outros" THEN 
                ASSIGN fi-linha-3-1:SCREEN-VALUE = ttitem-ean.etiq-3-info[1]
                       fi-linha-3-2:SCREEN-VALUE = ttitem-ean.etiq-3-info[2].
            ELSE
                ASSIGN fi-linha-3-1:SCREEN-VALUE = ""
                       fi-linha-3-2:SCREEN-VALUE = "".
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piManutBrowse wMaintenance 
PROCEDURE piManutBrowse :
/*------------------------------------------------------------------------------
  Purpose: Habilita/Desabilita browse
  Notes:   Carlos Daniel - 23/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lhabilita AS LOGICAL NO-UNDO.

ASSIGN tt-int-item-fornec.buffer-mac:READ-ONLY IN BROWSE brItemFornec = NOT lhabilita
       bt-incluir                   :SENSITIVE IN FRAME  fPage5       = lhabilita.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona DBO filho atrav²s de um rowid
  Parameters:  recebe rowid
               recebe nœmero da pÿgina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RUN openQueryKit.

    FOR FIRST tt-int-kit NO-LOCK
        WHERE tt-int-kit.r-rowid = pRowid:

        REPOSITION brCompKit TO ROWID ROWID(tt-int-kit).

    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateRecord wMaintenance 
PROCEDURE ValidateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        IF ttitem-ean.it-codigo:SENSITIVE
        AND CAN-FIND(FIRST item-ean NO-LOCK
                     WHERE item-ean.it-codigo = ttitem-ean.it-codigo:SCREEN-VALUE) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 1, 
                               INPUT "Cadastro EAN":U).

            apply "entry" to ttitem-ean.it-codigo.

            RETURN "NOK":U.
    
        END.

    END.
    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBloqueia wMaintenance 
FUNCTION fnBloqueia RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if not l-libera then do:
        disable btAdd btDelete btUpdate btCopy with frame fPage0.                               
        assign menu-item miAdd:sensitive in menu mbMain = no 
               menu-item miCopy:sensitive in menu mbMain = no 
               menu-item miDelete:sensitive in menu mbMain = no 
               menu-item miUpdate:sensitive in menu mbMain = no. 
    end.

    RETURN l-libera.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST ITEM
        WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE ITEM THEN
        RETURN ITEM.desc-item.   /* Function return value. */
    ELSE
        RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesEmit wMaintenance 
FUNCTION fnDesEmit RETURNS CHARACTER
  (INPUT p-cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FOR FIRST emitente FIELDS(nome-abrev)
    WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:

    RETURN emitente.nome-abrev.
END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnModelo wMaintenance 
FUNCTION fnModelo RETURNS CHARACTER
  (p-tipo AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE p-tipo: 
        WHEN 0 OR WHEN 1 THEN RETURN "Somente c¢digo de barras".
        WHEN 2           THEN RETURN "C¢digo de barras + gponsn".              
        WHEN 3           THEN RETURN "Somente qr-code".                        
        WHEN 4           THEN RETURN "Qr-code com senha m ster".
        WHEN 5           THEN RETURN "Qr-code com senha m ster e acesso remoto".
        WHEN 6           THEN RETURN "MAC + GPON C¢digo de Barra".
        WHEN 7           THEN RETURN "Qr-code com senha m ster e acesso remoto Positron".
        WHEN 8           THEN RETURN "MAC + GPON C¢digo de Barra Tripla".
        WHEN 9           THEN RETURN "QR CODE com senha ADMIN + Senha WIFI".

    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnModeloChar wMaintenance 
FUNCTION fnModeloChar RETURNS INTEGER
  (p-tipo AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE p-tipo: 
        WHEN "Somente c¢digo de barras"                 then return  1.
        WHEN "C¢digo de barras + gponsn"                then return  2.
        WHEN "Somente qr-code"                          then return  3.
        WHEN "Qr-code com senha m ster"                 then return  4.
        WHEN "Qr-code com senha m ster e acesso remoto" then return  5.
        WHEN "MAC + GPON C¢digo de Barra"               THEN RETURN  6.
        WHEN "Qr-code com senha m ster e acesso remoto Positron" then return  7.
        WHEN "MAC + GPON C¢digo de Barra Tripla"        THEN RETURN  8.
        WHEN "QR CODE com senha ADMIN + Senha WIFI"     THEN RETURN  9.

    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipo wMaintenance 
FUNCTION fnTipo RETURNS CHARACTER
  (p-tipo AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE p-tipo: 
        WHEN 0 OR WHEN 1 THEN RETURN "Num.S‚rie".
        WHEN 2           THEN RETURN "C¢d.Item".
        WHEN 3           THEN RETURN "Outros".
        WHEN 4           THEN RETURN "Homologa‡Æo".
        WHEN 5           THEN RETURN "NS + QrCode".
        WHEN 6           THEN RETURN "Homologa‡Æo + Origem".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDesc wMaintenance 
FUNCTION fnTipoDesc RETURNS INTEGER
  ( p-tipo AS CHAR ) :

    CASE p-tipo: 
        WHEN "Num.S‚rie"   THEN RETURN 1.
        WHEN "C¢d.Item"    THEN RETURN 2.
        WHEN "Outros"      THEN RETURN 3.
        WHEN "Homologa‡Æo" THEN RETURN 4.
        WHEN "NS + QrCode" THEN RETURN 5.
        WHEN "Homologa‡Æo + Origem" THEN RETURN 6.
    END CASE.

    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

