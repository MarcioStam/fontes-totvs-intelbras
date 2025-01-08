&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esplp005 2.00.00.001}  /*** 010001 ***/
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
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGLAY 
&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGLOG f-pg-log

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

{esp/plp/esplp005tt.i}
{upc/btb910za-upc.i}
{esp/es0018.i}
{utp/ut-glob.i}
/*define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada1     as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

*/
/* Transfer Definitions */

def var raw-param        as raw no-undo.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
def var c-arq-term         as char    no-undo.

{include/i-imdef.i}

DEF TEMP-TABLE tt-planilha NO-UNDO
    FIELD arquivo AS CHAR FORMAT "x(200)" .
DEF BUFFER b-tt-planilha FOR tt-planilha.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-impor
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-import
&Scoped-define BROWSE-NAME Br-Planilha

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-planilha

/* Definitions for BROWSE Br-Planilha                                   */
&Scoped-define FIELDS-IN-QUERY-Br-Planilha IF LENGTH(tt-planilha.arquivo) > 80 THEN "..." + SUBSTRING(tt-planilha.arquivo, IF LENGTH(tt-planilha.arquivo) > 80 THEN LENGTH(tt-planilha.arquivo) - 80 ELSE 1, LENGTH(tt-planilha.arquivo)) ELSE tt-planilha.arquivo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-Br-Planilha   
&Scoped-define SELF-NAME Br-Planilha
&Scoped-define QUERY-STRING-Br-Planilha FOR EACH tt-planilha
&Scoped-define OPEN-QUERY-Br-Planilha OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha.
&Scoped-define TABLES-IN-QUERY-Br-Planilha tt-planilha
&Scoped-define FIRST-TABLE-IN-QUERY-Br-Planilha tt-planilha


/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-sel ~
    ~{&OPEN-QUERY-Br-Planilha}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS im-pg-par im-pg-log im-pg-sel bt-executar ~
bt-cancelar bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-cd-plano 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-log
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

DEFINE BUTTON bt-arquivo-destino 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr-destino 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo-destino AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 11 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 45.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-plano AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 45.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-plano AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Plano" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE BUTTON bt-bi 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-elimina DEFAULT 
     LABEL "Eliminar" 
     SIZE 9.72 BY .92 TOOLTIP "Eliminar Exceá∆o".

DEFINE BUTTON bt-inclui DEFAULT 
     LABEL "Adicionar" 
     SIZE 10 BY .92 TOOLTIP "Incluir Exceá∆o".

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 76 BY 1.5 NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caminho p/ geraraá∆o CSV" 
     VIEW-AS FILL-IN 
     SIZE 50.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-arquivo-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Planilha" 
     VIEW-AS FILL-IN 
     SIZE 60.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-150
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.86 BY 7.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Br-Planilha FOR 
      tt-planilha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Br-Planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Br-Planilha C-Win _FREEFORM
  QUERY Br-Planilha DISPLAY
      IF LENGTH(tt-planilha.arquivo) > 80 THEN "..." + SUBSTRING(tt-planilha.arquivo, IF LENGTH(tt-planilha.arquivo) > 80 THEN LENGTH(tt-planilha.arquivo) - 80 ELSE 1, LENGTH(tt-planilha.arquivo)) ELSE tt-planilha.arquivo   COLUMN-LABEL "" FORMAT "x(200)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 4.25
         FONT 1
         TITLE "Planilha Excel - Arquivo .xlsx" ROW-HEIGHT-CHARS .63 FIT-LAST-COLUMN TOOLTIP "Planilha".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-log
     rs-destino AT ROW 2.08 COL 3.43 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr-destino AT ROW 3.29 COL 43.43 HELP
          "Configuraá∆o da impressora"
     bt-arquivo-destino AT ROW 3.29 COL 43.43 HELP
          "Escolha do nome do arquivo"
     c-arquivo-destino AT ROW 3.33 COL 3.43 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.46 COL 3.29 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.33 COL 4 NO-LABEL
     text-modo AT ROW 4.71 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.63 COL 2.14
     RECT-9 AT ROW 5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77.14 BY 10.46.

DEFINE FRAME f-pg-par
     fi-cod-estab AT ROW 3.75 COL 15.72 COLON-ALIGNED WIDGET-ID 8
     c-desc-estabel AT ROW 3.75 COL 23.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi-cd-plano AT ROW 4.75 COL 18.57 COLON-ALIGNED WIDGET-ID 20
     c-desc-plano AT ROW 4.75 COL 23.57 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-arquivo-entrada AT ROW 9.75 COL 53 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77.14 BY 10.75.

DEFINE FRAME f-import
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     im-pg-par AT ROW 1.5 COL 17.57
     im-pg-log AT ROW 1.5 COL 33.14
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     im-pg-sel AT ROW 1.5 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     EDITOR-1 AT ROW 1.75 COL 2 NO-LABEL WIDGET-ID 374
     bt-bi AT ROW 3.92 COL 72.57 HELP
          "Escolha do nome do arquivo" WIDGET-ID 378
     fi-arquivo-imp AT ROW 3.96 COL 3.28 WIDGET-ID 380
     bt-inclui AT ROW 4.92 COL 12 HELP
          "Incluir Exceá∆o" WIDGET-ID 348
     bt-elimina AT ROW 4.92 COL 22.29 HELP
          "Eliminar Exceá∆o" WIDGET-ID 350
     Br-Planilha AT ROW 5.92 COL 3 WIDGET-ID 300
     c-arquivo-csv AT ROW 10.38 COL 24.86 COLON-ALIGNED WIDGET-ID 382
     "Layout modelo:" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1 COL 2.14 WIDGET-ID 376
     RECT-150 AT ROW 3.75 COL 2.14 WIDGET-ID 370
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 10.75 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-impor
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Importaá∆o de Notas Fiscais"
         HEIGHT             = 15.04
         WIDTH              = 81.86
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-impor.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-pg-sel:FRAME = FRAME f-import:HANDLE.

/* SETTINGS FOR FRAME f-import
   FRAME-NAME                                                           */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-log
                                                                        */
/* SETTINGS FOR RADIO-SET rs-destino IN FRAME f-pg-log
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
ASSIGN 
       c-arquivo-entrada:HIDDEN IN FRAME f-pg-par           = TRUE.

ASSIGN 
       c-desc-estabel:READ-ONLY IN FRAME f-pg-par        = TRUE.

ASSIGN 
       c-desc-plano:READ-ONLY IN FRAME f-pg-par        = TRUE.

/* SETTINGS FOR FILL-IN fi-cd-plano IN FRAME f-pg-par
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* BROWSE-TAB Br-Planilha bt-elimina f-pg-sel */
ASSIGN 
       Br-Planilha:COLUMN-RESIZABLE IN FRAME f-pg-sel       = TRUE.

ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME f-pg-sel        = TRUE.

/* SETTINGS FOR FILL-IN fi-arquivo-imp IN FRAME f-pg-sel
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Br-Planilha
/* Query rebuild information for BROWSE Br-Planilha
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-planilha
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE Br-Planilha */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-log
/* Query rebuild information for FRAME f-pg-log
     _Query            is NOT OPENED
*/  /* FRAME f-pg-log */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Importaá∆o de Notas Fiscais */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Importaá∆o de Notas Fiscais */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Br-Planilha
&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME Br-Planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Br-Planilha C-Win
ON START-SEARCH OF Br-Planilha IN FRAME f-pg-sel /* Planilha Excel - Arquivo .xlsx */
DO:
  
/*     DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.                                                                                   */
/*     DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.                                                                                   */
/*                                                                                                                                       */
/*     SELF:CLEAR-SORT-ARROWS().                                                                                                         */
/*                                                                                                                                       */
/*     IF SELF:CURRENT-COLUMN:TABLE = "":U OR                                                                                            */
/*        SELF:CURRENT-COLUMN:TABLE = ?    THEN                                                                                          */
/*         RETURN NO-APPLY.                                                                                                              */
/*                                                                                                                                       */
/*     IF v_column <> SELF:CURRENT-COLUMN:NAME THEN                                                                                      */
/*         ASSIGN v_column = SELF:CURRENT-COLUMN:NAME                                                                                    */
/*                v_asc    = YES.                                                                                                        */
/*     ELSE                                                                                                                              */
/*         ASSIGN v_asc = NOT v_asc.                                                                                                     */
/*                                                                                                                                       */
/*     IF v_asc THEN                                                                                                                     */
/*         SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +                                                  */
/*                                  "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).              */
/*     ELSE                                                                                                                              */
/*         SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +                                                  */
/*                                  "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).  */
/*                                                                                                                                       */
/*     DO i_count = 1 TO SELF:NUM-COLUMNS:                                                                                               */
/*         IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN                                                                 */
/*             ASSIGN i_index = i_count.                                                                                                 */
/*     END.                                                                                                                              */
/*                                                                                                                                       */
/*     SELF:SET-SORT-ARROW(i_index, v_asc).                                                                                              */
/*                                                                                                                                       */
/*     SELF:QUERY:QUERY-OPEN().                                                                                                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-import /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME bt-arquivo-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-destino C-Win
ON CHOOSE OF bt-arquivo-destino IN FRAME f-pg-log
DO:
    {include/i-imarq.i c-arquivo-destino f-pg-log}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-bi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bi C-Win
ON CHOOSE OF bt-bi IN FRAME f-pg-sel
DO:
    def var cArqConv  as char no-undo.

    assign cArqConv = replace(input frame f-pg-sel fi-arquivo-imp, "/":U, "~\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.xlsx":U "*.xlsx":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst":U
       INITIAL-DIR session:temp-directory
   
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign fi-arquivo-imp = replace(cArqConv, "~\":U, "/":U).
        display fi-arquivo-imp with frame f-pg-sel.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-import /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME bt-config-impr-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr-destino C-Win
ON CHOOSE OF bt-config-impr-destino IN FRAME f-pg-log
DO:
   {include/i-imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina C-Win
ON CHOOSE OF bt-elimina IN FRAME f-pg-sel /* Eliminar */
DO:
    IF  AVAIL tt-planilha THEN DO TRANS:

        DELETE tt-planilha.
        {&OPEN-QUERY-br-planilha}
        
    END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-import /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui C-Win
ON CHOOSE OF bt-inclui IN FRAME f-pg-sel /* Adicionar */
DO:
    
    DEF VAR i-seq AS INTEGER NO-UNDO.
    
    FIND b-tt-planilha NO-LOCK
        WHERE b-tt-planilha.arquivo = fi-arquivo-imp:SCREEN-VALUE IN FRAME f-pg-sel NO-ERROR.

    IF  AVAIL b-tt-planilha  THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Planilha j† est† sendo considerado.").
        RETURN NO-APPLY.
    END.


    IF  trim(fi-arquivo-imp:SCREEN-VALUE IN FRAME f-pg-sel) = "" THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Informe arquivo .xlsx para importaá∆o").
        RETURN NO-APPLY.
    END.

    DO TRANS:
        CREATE tt-planilha.
        ASSIGN tt-planilha.arquivo = fi-arquivo-imp:SCREEN-VALUE IN FRAME f-pg-sel.
        {&OPEN-QUERY-br-planilha}
    END.

    fi-arquivo-imp:SCREEN-VALUE IN FRAME f-pg-sel = "".

    APPLY "entry" TO fi-arquivo-imp IN FRAME f-pg-sel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME fi-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano C-Win
ON F5 OF fi-cd-plano IN FRAME f-pg-par /* Plano */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z01in318.w
                         &campo=fi-cd-plano
                         &campozoom=cd-plano
                         &campo2=c-desc-plano
                          &campozoom2=descricao
                         &frame=f-pg-par}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano C-Win
ON LEAVE OF fi-cd-plano IN FRAME f-pg-par /* Plano */
DO:
  FIND FIRST pl-prod NO-LOCK
      WHERE pl-prod.cd-plano = INPUT FRAME f-pg-par fi-cd-plano NO-ERROR.

  IF  AVAIL pl-prod THEN
      ASSIGN c-desc-plano:SCREEN-VALUE = pl-prod.descricao.
  ELSE
      ASSIGN c-desc-plano:SCREEN-VALUE = "inexistente".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-plano IN FRAME f-pg-par /* Plano */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab C-Win
ON F5 OF fi-cod-estab IN FRAME f-pg-par /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=fi-cod-estab
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab C-Win
ON LEAVE OF fi-cod-estab IN FRAME f-pg-par /* Estabelecimento */
DO:
    ASSIGN INPUT FRAME f-pg-par fi-cod-estab.
    
    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = fi-cod-estab NO-ERROR.
    IF  AVAIL estabelec THEN
        ASSIGN c-desc-estabel = estabelec.nome.
    ELSE
        ASSIGN c-desc-estabel = "".
    
    DISPLAY c-desc-estabel WITH FRAME f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab IN FRAME f-pg-par /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME im-pg-log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-log C-Win
ON MOUSE-SELECT-CLICK OF im-pg-log IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-log
DO:
do  with frame f-pg-log:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo-destino:sensitive     = no
                   bt-arquivo-destino:visible      = no
                   bt-config-impr-destino:visible  = yes.
        end.
        when "2" then do:
            assign c-arquivo-destino:sensitive     = yes
                   bt-arquivo-destino:visible      = yes
                   bt-config-impr-destino:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo-destino:sensitive     = no
                   bt-arquivo-destino:visible      = no
                   bt-config-impr-destino:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-log
DO:
/*
   {include/i-imrse.i} */


    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR FIRST tt-prog-ponto:
    
        ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").
    
        IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
            ASSIGN c-dir-saida = c-dir-saida + "~\".
    
    END.



    if  input frame f-pg-log rs-execucao = 2 then do:
        assign c-arquivo-destino
               c-arq-old-batch = c-arquivo-destino.


        ASSIGN c-arquivo-destino = REPLACE(c-arquivo-destino, "/", "~\").

        if index(c-arquivo-destino, c-dir-saida + "spool":U) <> 0 then do:
            assign c-arquivo-destino = replace(c-arquivo-destino, c-dir-saida + "spool~\":U,"").
          disp c-arquivo-destino with frame f-pg-log.
        end.

        if  input frame f-pg-log rs-destino = 3 then do:
            assign rs-destino:screen-value in frame f-pg-log = "2".
            apply "value-changed":U to rs-destino in frame f-pg-log.
        end.
        if  rs-destino:disable(c-terminal) in frame f-pg-log then.
    end.
    else do:
        assign c-arquivo-destino = c-arq-old-batch.
        disp c-arquivo-destino with frame f-pg-log.
        if  rs-destino:enable(c-terminal) in frame f-pg-log then.
    end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESPLP005" "2.00.00.001"}

/* inicializaá‰es do template de importaá∆o */
{include/i-imini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-imlbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    c-arquivo-entrada:HIDDEN IN FRAME f-pg-par = TRUE.
    fi-cd-plano:sensitive IN FRAME f-pg-par = YES.
    {include/i-immbl.i im-pg-sel}
    FIND FIRST dwb_set_list_param NO-LOCK
        WHERE dwb_set_list_param.Cod_dwb_program = "esplp005"
          AND dwb_set_list_param.Cod_dwb_user    = c-seg-usuario NO-ERROR .

    DEF VAR i AS INTEGER NO-UNDO.

    IF  AVAIL dwb_set_list_param  THEN DO:
        DO  i = 1 TO NUM-ENTRIES(dwb_set_list_param.Cod_dwb_parameters, CHR(10)):
            CASE i:
                WHEN 1 THEN
                    ASSIGN fi-cod-estab:SCREEN-VALUE IN FRAME f-pg-par  = ENTRY(i,dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
                WHEN 2 THEN
                    ASSIGN fi-cd-plano:SCREEN-VALUE IN FRAME f-pg-par   = ENTRY(i,dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
                WHEN 3 THEN
                    ASSIGN c-arquivo-csv:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(i,dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
                OTHERWISE  DO:
                    IF  ENTRY(i, dwb_set_list_param.Cod_dwb_parameters, CHR(10)) = "" THEN
                        NEXT.
                    CREATE tt-planilha.
                    ASSIGN tt-planilha.arquivo = ENTRY (i, dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
                END.
            END CASE.
        END.
    END.
    editor-1:SCREEN-VALUE IN FRAME f-pg-sel = "Estabelecimento;Item;Descriá∆o;Data1;Data2;Data3.... (Quantidade)" + CHR(13) +
                                              "101;Item-1;Descriá∆o Item-1;600;300;200;.....".

    APPLY "leave" TO fi-cod-estab IN FRAME f-pg-par.
    APPLY "leave" TO fi-cd-plano IN FRAME f-pg-par.

    RUN select-page IN THIS-PROCEDURE(2).

    
    VIEW FRAME f-pg-sel.
    HIDE FRAME f-pg-par.
    APPLY "selec-click" TO  im-pg-par IN FRAME f-import.

    {&OPEN-QUERY-br-planilha}

/*    {include/i-imvrf.i &programa=re0190 &versao-layout=001} */

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
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
  ENABLE im-pg-par im-pg-log im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-import IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-import}
  DISPLAY rs-destino c-arquivo-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 bt-config-impr-destino bt-arquivo-destino 
         c-arquivo-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-log}
  DISPLAY fi-cod-estab c-desc-estabel fi-cd-plano c-desc-plano c-arquivo-entrada 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE fi-cod-estab c-desc-estabel c-desc-plano c-arquivo-entrada 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY EDITOR-1 fi-arquivo-imp c-arquivo-csv 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE RECT-150 EDITOR-1 bt-bi fi-arquivo-imp bt-inclui bt-elimina 
         Br-Planilha c-arquivo-csv 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-log rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-log c-arquivo-destino).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-log in frame f-import.
            apply 'entry' to c-arquivo-destino in frame f-pg-log.                   
            return error.
        end.
    end.

     FIND FIRST estabelec NO-LOCK
         WHERE  estabelec.cod-estabel = fi-cod-estab:SCREEN-VALUE IN FRAME f-pg-par NO-ERROR.

     IF  NOT AVAIL estabelec THEN DO:

         run utp/ut-msgs.p (input "show",
                            input 17006,
                            input "Estabelecimento n∆o cadastrado.").                               
         apply 'mouse-select-click' to fi-cod-estab in frame f-pg-par.
         apply 'entry' to fi-cod-estab in frame f-pg-par.                
         return error.
     END.

     FIND FIRST pl-prod NO-LOCK
        WHERE pl-prod.cd-plano = INPUT FRAME f-pg-par fi-cd-plano NO-ERROR.

     IF  NOT AVAIL pl-prod THEN DO:
         run utp/ut-msgs.p (input "show",
                            input 17006,
                            input "Plano n∆o cadastrado.").                               
         apply 'mouse-select-click' to fi-cd-plano in frame f-pg-par.
         apply 'entry' to fi-cd-plano in frame f-pg-par.                
         return error.
     END.

     FOR EACH b-tt-planilha:
         assign file-info:file-name =  b-tt-planilha.arquivo.
         if  file-info:pathname = ? then do:
             run utp/ut-msgs.p (input "show",
                                input 326,
                                input b-tt-planilha.arquivo).                               
              return error.
         end.
     END.


     assign file-info:file-name = input frame f-pg-sel c-arquivo-csv.
     if  file-info:pathname = ? then do:
         run utp/ut-msgs.p (input "show",
                            input 326,
                            input c-arquivo-csv).                               
         apply 'entry' to c-arquivo-csv in frame f-pg-sel.                
         return error.
     end. 

     EMPTY TEMP-TABLE tt-digita.
     EMPTY TEMP-TABLE tt-raw-digita.

     FOR EACH b-tt-planilha:
         CREATE tt-digita.
         ASSIGN tt-digita.exemplo = b-tt-planilha.arquivo.
     END.

     IF  NOT CAN-FIND(FIRST tt-digita) THEN DO:
         run utp/ut-msgs.p (input "show",
                            input 17006,
                            input "Nenhuma planilha foi informada para importaá∆o").                               
         return error.
     END.

     DEF VAR r-raw AS RAW NO-UNDO.
     FOR EACH tt-digita:
         CREATE tt-raw-digita.
         RAW-TRANSFER tt-digita TO r-raw.
         tt-raw-digita.raw-digita = r-raw.
     END.

     
    /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    
    DO TRANS:
        FIND FIRST dwb_set_list_param EXCLUSIVE-LOCK
            WHERE dwb_set_list_param.Cod_dwb_program = "esplp005"
              AND dwb_set_list_param.Cod_dwb_user    = c-seg-usuario NO-ERROR .
            
        IF  NOT AVAIL dwb_set_list_param THEN DO:
            CREATE dwb_set_list_param.
            ASSIGN dwb_set_list_param.Cod_dwb_program = "esplp005"   
                   dwb_set_list_param.Cod_dwb_user    = c-seg-usuario.
        END.

        ASSIGN dwb_set_list_param.Cod_dwb_parameters = INPUT FRAME f-pg-par fi-cod-estab   + chr(10) + 
                                                       INPUT FRAME f-pg-par fi-cd-plano    + chr(10) +
                                                       input FRAME f-pg-sel c-arquivo-csv  + chr(10).
        FOR EACH b-tt-planilha:
            ASSIGN dwb_set_list_param.Cod_dwb_parameters = dwb_set_list_param.Cod_dwb_parameters + b-tt-planilha.arquivo + chr(10).
        END.
    END.

    /*CONFIRMA A EXECUÄ«O OFICIAL*/
    run utp/ut-msgs.p (input "show", input 27100, input "Atená∆o! Os itens do plano " + STRING(INPUT FRAME f-pg-par fi-cd-plano) + " ser∆o eliminados. " + "~~" +
                                                        "Os itens desse plano ser∆o eliminados e ser∆o criados novos itens considerando os valores das planilhas informadas. Confirma eliminaá∆o?").
    
    create tt-param.
    assign tt-param.usuario           = c-seg-usuario
           tt-param.destino           = input frame f-pg-log rs-destino
           tt-param.data-exec         = today
           tt-param.hora-exec         = time
           tt-param.cod-estabel       = INPUT FRAME f-pg-par fi-cod-estab
           tt-param.cod-plano         = INPUT FRAME f-pg-par fi-cd-plano
           tt-param.c-arquivo-csv     = input frame f-pg-sel c-arquivo-csv
           tt-param.log-elimina-itens = IF RETURN-VALUE <> "YES" THEN NO ELSE YES.
           
    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame f-pg-log c-arquivo-destino.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    {include/i-imexb.i}

     
    if  session:set-wait-state("general") then.

    {include/i-imrun.i esp/plp/esplp005rp.p}

    {include/i-imexc.i}

    if  session:set-wait-state("") then.

    {include/i-imtrm.i tt-param.arq-destino tt-param.destino}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-imtrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-planilha"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

