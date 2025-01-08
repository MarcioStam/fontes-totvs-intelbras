&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-emitente-trib NO-UNDO LIKE int-emitente-trib
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
{include/i-prgvrs.i ESCDP066 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP066
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-emitente
&GLOBAL-DEFINE hDBOTable      h-boad098na
&GLOBAL-DEFINE DBOTable       emitente

&GLOBAL-DEFINE page0KeyFields tt-emitente.cod-emitente tt-emitente.nome-emit
&GLOBAL-DEFINE page0Fields    tg-ind-declaracao i-tipo-declar dt-copia c-ordem-arq motivo-libera
&GLOBAL-DEFINE page0Widgets   bt-nr-ordem

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-arquivo
    FIELD nr-arquivo AS INTEGER 
    INDEX idx_ttArquivo nr-arquivo.


/* Local Variable Definitions (DBOs Handles) --- */
{utp/ut-glob.i}
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEF BUFFER b-int-emitente-trib  FOR int-emitente-trib.
DEF BUFFER b-int-emitente       FOR int-emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit 
&Scoped-define ENABLED-TABLES tt-emitente
&Scoped-define FIRST-ENABLED-TABLE tt-emitente
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtKeys-2 RECT-1 btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp c-raiz-cnpj ~
bt-nr-ordem c-ordem-arq rs-forma-tributacao tg-ind-declaracao i-tipo-declar ~
c-usuario motivo-libera text-1 
&Scoped-Define DISPLAYED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit 
&Scoped-define DISPLAYED-TABLES tt-emitente
&Scoped-define FIRST-DISPLAYED-TABLE tt-emitente
&Scoped-Define DISPLAYED-OBJECTS c-raiz-cnpj c-ordem-arq ~
rs-forma-tributacao tg-ind-declaracao i-tipo-declar dt-copia c-usuario ~
motivo-libera text-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
DEFINE BUTTON bt-nr-ordem 
     IMAGE-UP FILE "image/im-inl3.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-inl3.bmp":U
     LABEL "N£mero Ordem Arquivo" 
     SIZE 4 BY 1.25.

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

DEFINE VARIABLE motivo-libera AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 85.43 BY 2.63 NO-UNDO.

DEFINE VARIABLE c-ordem-arq AS CHARACTER FORMAT "x(50)" 
     LABEL "Ordem Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-raiz-cnpj AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "X(16)":U 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE dt-copia AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     VIEW-AS FILL-IN 
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(20)":U INITIAL "Forma Tributa‡Æo" 
      VIEW-AS TEXT 
     SIZE 14.57 BY .67 NO-UNDO.

DEFINE VARIABLE i-tipo-declar AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Original", 1,
"C¢pia", 2
     SIZE 9.14 BY 1.71 NO-UNDO.

DEFINE VARIABLE rs-forma-tributacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Cumulativo", 1,
"Cumulativo todo ou em parte", 2,
"Simples", 3,
"Nenhum", 4,
"Isento", 5
     SIZE 25.14 BY 3.88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.57 BY 4.38.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.57 BY 1.79.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.57 BY 8.92.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-ind-declaracao AS LOGICAL INITIAL no 
     LABEL "Declara‡Æo Entregue?" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.72 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-emitente.cod-emitente AT ROW 3.13 COL 11 COLON-ALIGNED WIDGET-ID 2
          LABEL "Emitente":R8
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-raiz-cnpj AT ROW 3.13 COL 20.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-emitente.nome-emit AT ROW 3.13 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 53 BY .88
     bt-nr-ordem AT ROW 4.83 COL 34.57 HELP
          "Informa o N£mero Ordem Arquivo" WIDGET-ID 36
     c-ordem-arq AT ROW 4.96 COL 15.14 COLON-ALIGNED HELP
          "Ordem do arquivo no Arquivario" WIDGET-ID 22
     rs-forma-tributacao AT ROW 5.67 COL 58.86 NO-LABEL WIDGET-ID 10
     tg-ind-declaracao AT ROW 6.04 COL 17.29 HELP
          "O cliente entregou a Declara‡Æo de Forma de Tributa‡Æo?" WIDGET-ID 24
     i-tipo-declar AT ROW 6.88 COL 19.86 HELP
          "Tipo de declara‡Æo" NO-LABEL WIDGET-ID 26
     dt-copia AT ROW 7.33 COL 28.72 COLON-ALIGNED HELP
          "Data da C¢pia" NO-LABEL WIDGET-ID 30
     c-usuario AT ROW 8.75 COL 15.14 COLON-ALIGNED HELP
          "Usu rio da Libera‡Æo" WIDGET-ID 32
     motivo-libera AT ROW 10.5 COL 3.29 HELP
          "Motivo de Libera‡Æo por Exce‡Æo" NO-LABEL WIDGET-ID 38
     text-1 AT ROW 4.96 COL 56.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     "Motivo Libera‡Æo" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 9.92 COL 5 WIDGET-ID 40
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1.29
     rtKeys-2 AT ROW 4.58 COL 1.29 WIDGET-ID 8
     RECT-1 AT ROW 5.33 COL 57.57 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgcad emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-emitente-trib T "?" NO-UNDO intelbras int-emitente-trib
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
         HEIGHT             = 12.79
         WIDTH              = 90
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-emitente.cod-emitente IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN dt-copia IN FRAME fPage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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


&Scoped-define SELF-NAME bt-nr-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nr-ordem wMaintenance
ON CHOOSE OF bt-nr-ordem IN FRAME fPage0 /* N£mero Ordem Arquivo */
DO:

    FOR EACH int-emitente-arquivo NO-LOCK
        BY int-emitente-arquivo.nr-arquivo :
        IF int-emitente-arquivo.nr-arquivo = 0 THEN NEXT.
        FIND FIRST tt-arquivo
            WHERE tt-arquivo.nr-arquivo = int-emitente-arquivo.nr-arquivo NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-arquivo THEN DO:
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.nr-arquivo = int-emitente-arquivo.nr-arquivo.
        END.

    END.

    IF AVAIL tt-emitente THEN DO:
        FIND FIRST int-emitente-arquivo
            WHERE int-emitente-arquivo.raiz-cnpj = SUBSTRING(tt-emitente.cgc,1,8) NO-LOCK NO-ERROR.
        IF AVAIL int-emitente-arquivo THEN DO:
            IF int-emitente-arquivo.nr-arquivo = 0 THEN DO:
                FIND LAST tt-arquivo NO-LOCK NO-ERROR.
                IF AVAIL tt-arquivo THEN 
                    ASSIGN c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = string(tt-arquivo.nr-arquivo + 1).

                IF NOT CAN-FIND(FIRST tt-arquivo) THEN
                    ASSIGN c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = '1'.
            END.
            ELSE DO:
                ASSIGN c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = string(int-emitente-arquivo.nr-arquivo).
            END.
        END. /* IF AVAIL int-emitente-arquivo THEN DO: */
        ELSE DO:
            FIND LAST tt-arquivo NO-LOCK NO-ERROR.
            IF AVAIL tt-arquivo THEN 
                ASSIGN c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = string(tt-arquivo.nr-arquivo + 1).

            IF NOT CAN-FIND(FIRST tt-arquivo) THEN
                ASSIGN c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = '1'.
        END.

    END. /* IF AVAIL tt-emitente THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="adzoom\z23ad098.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fPage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    ASSIGN c-usuario:SCREEN-VALUE IN FRAME fPage0 = c-seg-usuario.
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ordem-arq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ordem-arq wMaintenance
ON ENTRY OF c-ordem-arq IN FRAME fPage0 /* Ordem Arquivo */
DO:
  
    IF tg-ind-declaracao:SCREEN-VALUE IN FRAME fPage0 = 'YES' THEN DO:
        ENABLE i-tipo-declar WITH FRAME fPage0.

        IF i-tipo-declar:SCREEN-VALUE IN FRAME fPage0 = '2' THEN
            ENABLE  dt-copia WITH FRAME fPage0.
        ELSE 
            DISABLE dt-copia WITH FRAME fPage0.
    END.
    ELSE DO:
        DISABLE i-tipo-declar WITH FRAME fPage0.
        DISABLE dt-copia      WITH FRAME fPage0.
    END.

    IF c-usuario:SCREEN-VALUE IN FRAME fPage0 = '' THEN
        ASSIGN c-usuario:SCREEN-VALUE IN FRAME fPage0 = c-seg-usuario.

    IF c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 = '' THEN
        ENABLE bt-nr-ordem WITH FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-emitente.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-emitente.cod-emitente wMaintenance
ON ENTRY OF tt-emitente.cod-emitente IN FRAME fPage0 /* Emitente */
DO:
  
    IF INPUT FRAME fPage0 i-tipo-declar = 2 THEN
        ENABLE  dt-copia WITH FRAME fPage0.
    ELSE 
        DISABLE dt-copia WITH FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tipo-declar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tipo-declar wMaintenance
ON VALUE-CHANGED OF i-tipo-declar IN FRAME fPage0
DO:
  
    IF AVAIL tt-emitente THEN DO:
        IF INPUT FRAME fPage0 i-tipo-declar = 2 THEN DO:
            FIND FIRST int-emitente-trib NO-LOCK
                WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(tt-emitente.cgc,1,8) NO-ERROR.
            IF  AVAIL  int-emitente-trib THEN DO:

                IF int-emitente-trib.ind-tipo-declaracao = INPUT FRAME fPage0 i-tipo-declar THEN
                    ASSIGN dt-copia:SCREEN-VALUE IN FRAME fPage0 = STRING(int-emitente-trib.dt-copia-declaracao).
            END.
            ENABLE  dt-copia WITH FRAME fPage0.
        END.
        ELSE DO:
            ASSIGN dt-copia:SCREEN-VALUE IN FRAME fPage0 = "01/01/0001".
            DISABLE dt-copia WITH FRAME fPage0.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ind-declaracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ind-declaracao wMaintenance
ON VALUE-CHANGED OF tg-ind-declaracao IN FRAME fPage0 /* Declara‡Æo Entregue? */
DO:
  
    IF INPUT FRAME fPage0 tg-ind-declaracao = YES THEN DO:
        ENABLE  i-tipo-declar WITH FRAME fPage0.

        IF INPUT FRAME fPage0 i-tipo-declar = 2 THEN
            ENABLE  dt-copia WITH FRAME fPage0.
        ELSE 
            DISABLE dt-copia WITH FRAME fPage0.
    END.
    ELSE DO:
        DISABLE i-tipo-declar  WITH FRAME fPage0.
        DISABLE dt-copia        WITH FRAME fPage0.
    END.

    FOR EACH emitente WHERE substring(emitente.cgc,1,8) = INPUT FRAME {&FRAME-NAME} c-raiz-cnpj NO-LOCK .
        IF CAN-FIND(FIRST int-emitente NO-LOCK
                    WHERE int-emitente.cod-emitente         = emitente.cod-emitente
                      AND int-emitente.ind-forma-tributo   <> INPUT FRAME {&FRAME-NAME} rs-forma-tributacao) THEN DO:
            run utp/ut-msgs.p (input 'show', input 17006, INPUT "Tributacao divergente.~~Verifique os cadastros da matriz e filiais para o CNPJ Ra¡z " + INPUT FRAME {&FRAME-NAME} c-raiz-cnpj + ".").
            RETURN "Nok".   

        END.
    END.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL tt-emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
            WHERE  int-emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.

        ASSIGN c-raiz-cnpj         = SUBSTRING(tt-emitente.cgc,1,8)
               rs-forma-tributacao = IF AVAIL int-emitente THEN int-emitente.ind-forma-tributo ELSE 4.

        FIND FIRST int-emitente-trib NO-LOCK
            WHERE  int-emitente-trib.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL  int-emitente-trib THEN
            ASSIGN c-ordem-arq       = int-emitente-trib.ordem-arq
                   tg-ind-declaracao = int-emitente-trib.ind-declaracao
                   i-tipo-declar     = int-emitente-trib.ind-tipo-declaracao
                   dt-copia          = int-emitente-trib.dt-copia-declaracao 
                   c-usuario         = int-emitente-trib.cod-usuario.
        ELSE
            ASSIGN c-ordem-arq       = ""
                   tg-ind-declaracao = NO
                   i-tipo-declar     = 1
                   dt-copia          = 01/01/0001
                   c-usuario         = ''.

        FIND FIRST int-emitente-arquivo NO-LOCK
            WHERE  int-emitente-arquivo.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL  int-emitente-arquivo THEN
            ASSIGN motivo-libera = int-emitente-arquivo.motivo-lib.
        ELSE
            ASSIGN motivo-libera = ''.

        DISPLAY c-raiz-cnpj
                rs-forma-tributacao
                c-ordem-arq
                tg-ind-declaracao
                i-tipo-declar
                dt-copia      
                c-usuario
                motivo-libera
            WITH FRAME fPage0.

    END.

    RETURN "OK":U.
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
    DISPLAY text-1
        WITH FRAME fPage0.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-teste AS CHARACTER   NO-UNDO.

ASSIGN c-teste = dt-copia     :SCREEN-VALUE IN FRAME fPage0.

    ASSIGN INPUT FRAME fPage0 c-raiz-cnpj
           INPUT FRAME fPage0 c-ordem-arq
           INPUT FRAME fPage0 tg-ind-declaracao
           INPUT FRAME fPage0 i-tipo-declar
           INPUT FRAME fPage0 dt-copia
           INPUT FRAME fPage0 c-usuario
           INPUT FRAME fPage0 motivo-libera.

    IF  i-tipo-declar:SCREEN-VALUE IN FRAME fPage0 = '2'
    AND LENGTH(c-teste)                            =  4 THEN DO:
        run utp/ut-msgs.p (input 'show', input 17006, INPUT "Data deve ser informada.~~Data deve ser diferente de branco.").
        apply "ENTRY" to dt-copia in FRAME fPage0.
        RETURN "Nok".   
    END.

    IF c-ordem-arq:SCREEN-VALUE IN FRAME fPage0 <> '' THEN DO:
        FIND FIRST int-emitente-trib NO-LOCK
            WHERE int-emitente-trib.raiz-cnpj <> c-raiz-cnpj 
              AND int-emitente-trib.ordem-arq  = c-ordem-arq NO-ERROR.
        IF AVAIL int-emitente-trib THEN DO:
                run utp/ut-msgs.p (input 'show', input 17006, INPUT "Ordem Arquivo Inv lido.~~Ordem Arquivo utilizado na ra¡z " + int-emitente-trib.raiz-cnpj + ".").
                apply "ENTRY" to c-ordem-arq in FRAME fPage0.
                RETURN "Nok".   
        END.
    END.

    IF  i-tipo-declar:SCREEN-VALUE IN FRAME fPage0 = '1' THEN DO:
        IF (INTEGER(c-ordem-arq)                      =  0
        OR  c-ordem-arq                               = '') THEN DO:
            run utp/ut-msgs.p (input 'show', input 17006, INPUT "Ordem Arquivo Inv lido.~~Ordem Arquivo deve ser informado.").
            apply "ENTRY" to c-ordem-arq in FRAME fPage0.
            RETURN "Nok".   
        END.

        FIND FIRST int-emitente-arquivo NO-LOCK
            WHERE int-emitente-arquivo.raiz-cnpj     <> c-raiz-cnpj 
              AND int-emitente-arquivo.nr-arquivo  = INT(c-ordem-arq) NO-ERROR.
        IF AVAIL int-emitente-arquivo THEN DO:
                run utp/ut-msgs.p (input 'show', input 17006, INPUT "Ordem Arquivo Inv lido.~~Ordem Arquivo utilizado na ra¡z " + int-emitente-arquivo.raiz-cnpj + ".").
                apply "ENTRY" to c-ordem-arq in FRAME fPage0.
                RETURN "Nok".   
        END.

    END.

    IF  AVAIL tt-emitente THEN DO:
        FIND FIRST int-emitente-trib EXCLUSIVE-LOCK
            WHERE  int-emitente-trib.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  NOT AVAIL int-emitente-trib THEN DO:
            CREATE int-emitente-trib.
            ASSIGN int-emitente-trib.raiz-cnpj = c-raiz-cnpj.
        END.

        ASSIGN int-emitente-trib.ordem-arq           = c-ordem-arq
               int-emitente-trib.ind-declaracao      = tg-ind-declaracao
               int-emitente-trib.ind-tipo-declaracao = i-tipo-declar
               int-emitente-trib.dt-copia-declaracao = dt-copia
               int-emitente-trib.cod-usuario         = c-usuario.

        FIND FIRST int-emitente-arquivo
            WHERE int-emitente-arquivo.raiz-cnpj = SUBSTRING(tt-emitente.cgc,1,8) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL int-emitente-arquivo THEN DO:
            CREATE int-emitente-arquivo.
            ASSIGN int-emitente-arquivo.raiz-cnpj  = SUBSTRING(tt-emitente.cgc,1,8)
                   int-emitente-arquivo.motivo-lib = motivo-libera.

            IF i-tipo-declar:SCREEN-VALUE IN FRAME fPage0 = '1' THEN
                ASSIGN int-emitente-arquivo.nr-arquivo = INT(c-ordem-arq).

        END. /* IF NOT AVAIL int-emitente-arquivo THEN DO: */
        ELSE DO:
            IF i-tipo-declar:SCREEN-VALUE IN FRAME fPage0 = '1' THEN
                ASSIGN int-emitente-arquivo.nr-arquivo = INT(c-ordem-arq).
            ASSIGN int-emitente-arquivo.motivo-lib = motivo-libera.
        END.
        FOR EACH b-int-emitente-trib
            WHERE b-int-emitente-trib.raiz-cnpj = SUBSTRING(tt-emitente.cgc,1,8) EXCLUSIVE-LOCK:
            ASSIGN b-int-emitente-trib.ind-declaracao = int-emitente-trib.ind-declaracao.
        END.

    END.

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
    
    DEFINE VARIABLE i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-cod-emitente    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Cliente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-emitente.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-cod-emitente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cliente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cod-emitente btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "adbo/boad098na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098na.p YES}
        {btb/btb008za.i2 adbo/boad098na.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Cliente":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

