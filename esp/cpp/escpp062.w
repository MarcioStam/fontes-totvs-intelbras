&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-previsao NO-UNDO LIKE int-coesa-prev-venda
       field desc-item like item.desc-item.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP062 2.00.06.003}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp062
&GLOBAL-DEFINE Version        2.00.06.003

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-estabel v-cod-ano v-dat-previsao rs-tipo-prev br-previsoes btExit bt-arq bt-imp bt-salva v-cod-arquivo

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE lDesc          AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE cQuery         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampoSearch   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-linha    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-lst-mes  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-periodo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-per-atu  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-per-ant  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-des-prev     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iContReg       AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-num-colunas  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-num-col-tmp  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-num-mes      AS INTEGER     NO-UNDO.


/* Temp Table Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-previsoes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-previsao

/* Definitions for BROWSE br-previsoes                                  */
&Scoped-define FIELDS-IN-QUERY-br-previsoes tt-previsao.cod-estabel ~
tt-previsao.it-codigo tt-previsao.desc-item @ tt-previsao.desc-item ~
tt-previsao.qtd-prevista tt-previsao.cod-periodo-previsao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-previsoes 
&Scoped-define QUERY-STRING-br-previsoes FOR EACH tt-previsao NO-LOCK ~
    BY tt-previsao.cod-estabel ~
       BY tt-previsao.it-codigo ~
        BY tt-previsao.cod-periodo-previsao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-previsoes OPEN QUERY br-previsoes FOR EACH tt-previsao NO-LOCK ~
    BY tt-previsao.cod-estabel ~
       BY tt-previsao.it-codigo ~
        BY tt-previsao.cod-periodo-previsao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-previsoes tt-previsao
&Scoped-define FIRST-TABLE-IN-QUERY-br-previsoes tt-previsao


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-previsoes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-cod-estabel v-cod-ano v-dat-previsao ~
rs-tipo-prev v-cod-arquivo br-previsoes bt-arq bt-imp bt-salva btExit ~
RECT-11 
&Scoped-Define DISPLAYED-OBJECTS v-cod-estabel v-cod-ano v-dat-previsao ~
rs-tipo-prev v-cod-arquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .

DEFINE MENU pmn-br-previsoes 
       MENU-ITEM miExcluir      LABEL "&Excluir Registro(s)"
       RULE
       MENU-ITEM miMoverColuna  LABEL "&Mover Coluna?"
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arq 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Localizar arquivo de previs‰es".

DEFINE BUTTON bt-imp 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Importar arquivo de previs‰es informado"
     FONT 4.

DEFINE BUTTON bt-salva 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.13 TOOLTIP "Salvar valores importados"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     FONT 4.

DEFINE VARIABLE v-cod-ano AS CHARACTER FORMAT "9999":U 
     LABEL "Ano Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-previsao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Previs∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo-prev AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Venda", 1,
"Produá∆o", 2
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-previsoes FOR 
      tt-previsao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-previsoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-previsoes wWindow _STRUCTURED
  QUERY br-previsoes NO-LOCK DISPLAY
      tt-previsao.cod-estabel FORMAT "x(3)":U
      tt-previsao.it-codigo FORMAT "x(16)":U WIDTH 9.86
      tt-previsao.desc-item @ tt-previsao.desc-item COLUMN-LABEL "Descriá∆o" FORMAT "x(40)":U
            WIDTH 48.43
      tt-previsao.qtd-prevista FORMAT "->>>,>>>,>>9.99":U
      tt-previsao.cod-periodo-previsao FORMAT "9999/99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 18.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     v-cod-estabel AT ROW 1.83 COL 9 COLON-ALIGNED WIDGET-ID 62
     v-cod-ano AT ROW 1.83 COL 27.29 COLON-ALIGNED WIDGET-ID 64
     v-dat-previsao AT ROW 1.83 COL 54 COLON-ALIGNED WIDGET-ID 66
     rs-tipo-prev AT ROW 1.83 COL 71 NO-LABEL WIDGET-ID 68
     v-cod-arquivo AT ROW 2.88 COL 9 COLON-ALIGNED WIDGET-ID 4
     br-previsoes AT ROW 4.25 COL 1.57
     bt-arq AT ROW 2.75 COL 70.29 HELP
          "Localiza Arquivo" WIDGET-ID 6
     bt-imp AT ROW 2.75 COL 74.43 HELP
          "Filtrar objetos expedidos pelos previsoes" WIDGET-ID 46
     bt-salva AT ROW 2.75 COL 78.57 HELP
          "Confirma alteraá‰es" WIDGET-ID 50
     btExit AT ROW 2.79 COL 86 HELP
          "Sair do programa"
     " Importaá∆o Previs∆o" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 1.04 COL 3 WIDGET-ID 60
     RECT-11 AT ROW 1.38 COL 1.57 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-previsao T "?" NO-UNDO mgesp int-coesa-prev-venda
      ADDITIONAL-FIELDS:
          field desc-item like item.desc-item
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
         HEIGHT             = 22
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 22
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
/* BROWSE-TAB br-previsoes v-cod-arquivo fpage0 */
ASSIGN 
       br-previsoes:POPUP-MENU IN FRAME fpage0             = MENU pmn-br-previsoes:HANDLE
       br-previsoes:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-previsoes:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-previsoes
/* Query rebuild information for BROWSE br-previsoes
     _TblList          = "Temp-Tables.tt-previsao"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-previsao.cod-estabel|yes,Temp-Tables.tt-previsao.it-codigo|yes,Temp-Tables.tt-previsao.cod-periodo-previsao|yes"
     _FldNameList[1]   = Temp-Tables.tt-previsao.cod-estabel
     _FldNameList[2]   > Temp-Tables.tt-previsao.it-codigo
"tt-previsao.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-previsao.desc-item @ tt-previsao.desc-item" "Descriá∆o" "x(40)" ? ? ? ? ? ? ? no ? no no "48.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-previsao.qtd-prevista
     _FldNameList[5]   = Temp-Tables.tt-previsao.cod-periodo-previsao
     _Query            is OPENED
*/  /* BROWSE br-previsoes */
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


&Scoped-define BROWSE-NAME br-previsoes
&Scoped-define SELF-NAME br-previsoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-previsoes wWindow
ON DELETE-CHARACTER OF br-previsoes IN FRAME fpage0
DO:
/*     IF  SESSION:SET-WAIT-STATE("general") THEN.             */
/*                                                             */
/*     IF SELF:NUM-SELECTED-ROWS > 0 THEN DO:                  */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                  */
/*                            INPUT 46700,                     */
/*                            INPUT "":U).                     */
/*                                                             */
/*         IF RETURN-VALUE = "YES":U THEN DO:                  */
/*             IF  SESSION:SET-WAIT-STATE("general") THEN.     */
/*                                                             */
/*             DO iContReg = 1 TO SELF:NUM-SELECTED-ROWS:      */
/*                 SELF:FETCH-SELECTED-ROW(iContReg).          */
/*                                                             */
/*                 IF AVAILABLE tt-int-nota-conhec THEN        */
/*                     DELETE tt-int-nota-conhec.              */
/*             END.                                            */
/*                                                             */
/*             {&OPEN-QUERY-br-previsoes}                      */
/*         END.                                                */
/*     END.                                                    */
/*     ELSE                                                    */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                  */
/*                            INPUT 17197,                     */
/*                            INPUT "ao menos um registro":U). */
/*                                                             */
/*     IF  SESSION:SET-WAIT-STATE("") THEN.                    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-previsoes wWindow
ON START-SEARCH OF br-previsoes IN FRAME fpage0
DO:
    IF SELF:CURRENT-COLUMN:TABLE  = "tt-previsao":U AND
       SELF:CURRENT-COLUMN:NAME  <> ?                      AND
       SELF:CURRENT-COLUMN:NAME  <> "":U                   THEN DO:
        IF cCampoSearch = SELF:CURRENT-COLUMN:NAME THEN DO:
            ASSIGN lDesc = NOT lDesc.

            IF lDesc THEN DO:
                cQuery = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " DESC INDEXED-REPOSITION":U.
            END.
            ELSE DO:
                cQuery = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U.
            END.
        END.
        ELSE DO:
            ASSIGN cQuery       = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U
                   cCampoSearch = SELF:CURRENT-COLUMN:NAME
                   lDesc        = NO.
        END.

        SELF:QUERY:QUERY-PREPARE(cQuery).
        SELF:QUERY:QUERY-OPEN().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq wWindow
ON CHOOSE OF bt-arq IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign v-cod-arquivo = c-arq-conv.
        display v-cod-arquivo with frame {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imp wWindow
ON CHOOSE OF bt-imp IN FRAME fpage0 /* Filtrar */
DO:
    ASSIGN v-des-prev = "Confirma importaá∆o da Previs∆o V E N D A ?":U.

    IF INPUT FRAME fpage0 rs-tipo-prev <> 1 THEN /* Venda */
        ASSIGN v-des-prev = "Confirma importaá∆o da Previs∆o P R O D U Ä « O ?":U.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT v-des-prev).

    IF RETURN-VALUE = "YES":U THEN DO:
        EMPTY TEMP-TABLE tt-previsao.

        {&OPEN-QUERY-br-previsoes}

        ASSIGN v-cod-ano      = INPUT FRAME {&FRAME-NAME} v-cod-ano
               v-cod-estabel  = INPUT FRAME {&FRAME-NAME} v-cod-estabel
               v-dat-previsao = INPUT FRAME {&FRAME-NAME} v-dat-previsao.

        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = v-cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Estabelecimento informado n∆o cadastrado.":U).

            RETURN NO-APPLY.
        END.

        IF v-cod-ano          = "":U            OR
           INTEGER(v-cod-ano) = 0               OR
           INTEGER(v-cod-ano) < YEAR(TODAY) - 1 OR
           INTEGER(v-cod-ano) > YEAR(TODAY) + 1 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Ano inicial inv†lido.~~O ano inicial deve no m†ximo um ano anterior ou posterior ao ano corrente.":U).

            RETURN NO-APPLY.
        END.

        IF v-dat-previsao = ?          OR
           v-dat-previsao < 01/01/2012 OR
           v-dat-previsao > TODAY      THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de previs∆o inv†lida.~~A data de geraá∆o da previs∆o deve ser maior que 01/01/2012 e, menor que a data corrente.":U).
            RETURN NO-APPLY.
        END.

        IF SEARCH(INPUT FRAME fpage0 v-cod-arquivo) <> ? THEN DO:
            EMPTY TEMP-TABLE tt-previsao.

            ASSIGN iContReg = 0.

            INPUT FROM VALUE(SEARCH(INPUT FRAME fpage0 v-cod-arquivo)).
            REPEAT:
                IMPORT UNFORMATTED v-cod-linha.

                ASSIGN iContReg = iContReg + 1.

                IF icontreg                        = 1 AND
                   NUM-ENTRIES(v-cod-linha, ";":U) < 3 THEN DO:
                    INPUT CLOSE.

                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Arquivo n∆o possui o layout correto para importaá∆o.~~Valide o layout do arquivo junto ao departamento de TIC.":U).

                    RETURN NO-APPLY.
                END.

                IF icontreg = 1 THEN DO:
                    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

                    ASSIGN v-num-colunas = NUM-ENTRIES(v-cod-linha, ";":U)
                           v-cod-periodo = "":U
                           v-cod-per-atu = "":U
                           v-cod-per-ant = "":U.

                    IF v-num-colunas > 14 THEN
                        ASSIGN v-num-colunas = 14. /* Considerar no m†ximo 12 meses para importaá∆o. Codigo e descriá∆o do item + 12 meses */

                    DO v-num-col-tmp = 3 TO v-num-colunas:
                        ASSIGN v-num-mes     = LOOKUP(ENTRY(v-num-col-tmp, v-cod-linha, ";":U), v-cod-lst-mes, ";":U)
                               v-cod-per-atu = v-cod-ano + STRING(v-num-mes, "99":U).

                        IF v-cod-per-atu < v-cod-per-ant THEN
                            ASSIGN v-cod-per-atu = STRING(INTEGER(v-cod-ano) + 1, "9999":U) + STRING(v-num-mes, "99":U).

                        IF v-cod-periodo = "":U THEN
                            ASSIGN v-cod-periodo = v-cod-per-atu.
                        ELSE
                            ASSIGN v-cod-periodo = v-cod-periodo + ";":U + v-cod-per-atu.

                        ASSIGN v-cod-per-ant = v-cod-per-atu.
                    END.
                END.

                IF icontreg > 1 THEN DO:
                    DO v-num-col-tmp = 3 TO v-num-colunas:
                        FIND FIRST tt-previsao
                            WHERE tt-previsao.cod-estabel          = v-cod-estabel
                              AND tt-previsao.it-codigo            = ENTRY(1, v-cod-linha, ";":U)
                              AND tt-previsao.dat-reg-previsao     = v-dat-previsao
                              AND tt-previsao.cod-periodo-previsao = ENTRY(v-num-col-tmp - 2, v-cod-periodo, ";":U) NO-LOCK NO-ERROR.

                        IF NOT AVAILABLE tt-previsao THEN DO:
                            CREATE tt-previsao.
                            ASSIGN tt-previsao.cod-estabel          = v-cod-estabel
                                   tt-previsao.it-codigo            = ENTRY(1, v-cod-linha, ";":U)
                                   tt-previsao.dat-reg-previsao     = v-dat-previsao
                                   tt-previsao.cod-periodo-previsao = ENTRY(v-num-col-tmp - 2, v-cod-periodo, ";":U)
                                   tt-previsao.qtd-prevista         = DECIMAL(ENTRY(v-num-col-tmp, v-cod-linha, ";":U))
                                   tt-previsao.dat-alterac          = TODAY
                                   tt-previsao.hor-alterac          = STRING(TIME, "hh:mm:ss":U)
                                   tt-previsao.cod-usuar-alterac    = c-seg-usuario
                                   tt-previsao.cod-arq-importado    = SEARCH(INPUT FRAME fpage0 v-cod-arquivo).

                            FIND FIRST item
                                WHERE item.it-codigo = tt-previsao.it-codigo NO-LOCK NO-ERROR.

                            IF AVAILABLE item THEN
                                ASSIGN tt-previsao.desc-item = item.desc-item.
                        END.
                    END.
                END. /* IF icontreg > 1 THEN DO:*/
            END. /* REPEAT: */
            INPUT CLOSE.

            {&OPEN-QUERY-br-previsoes}

            IF SESSION:SET-WAIT-STATE("":U) THEN.

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 15825,
                               INPUT "Importaá∆o finalizada com sucesso.":U).

        END. /* IF SEARCH(INPUT FRAME fpage0 v-cod-arquivo) <> ? THEN DO: */
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Arquivo n∆o encontrado.":U).

            RETURN NO-APPLY.
        END.
    END. /* IF  RETURN-VALUE = "YES":U THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva wWindow
ON CHOOSE OF bt-salva IN FRAME fpage0 /* Save */
DO:
    ASSIGN v-des-prev = "Confirma gravaá∆o dos valores importados para Previs∆o V E N D A?".
    IF  INPUT FRAME {&FRAME-NAME} rs-tipo-prev <> 1 /* Venda */
    THEN
        ASSIGN v-des-prev = "Confirma gravaá∆o dos valores importados para Previs∆o P R O D U Ä « O?".

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT v-des-prev).

    IF  RETURN-VALUE = "yes"
    THEN DO:
        IF  SESSION:SET-WAIT-STATE("general") THEN.

        IF  INPUT FRAME {&FRAME-NAME} rs-tipo-prev = 1 /* Venda */
        THEN DO:
            FOR EACH tt-previsao:
                FIND FIRST int-coesa-prev-venda EXCLUSIVE-LOCK
                    WHERE  int-coesa-prev-venda.cod-estabel          = tt-previsao.cod-estabel          
                      AND  int-coesa-prev-venda.it-codigo            = tt-previsao.it-codigo           
                      AND  int-coesa-prev-venda.dat-reg-previsao     = tt-previsao.dat-reg-previsao    
                      AND  int-coesa-prev-venda.cod-periodo-previsao = tt-previsao.cod-periodo-previsao NO-ERROR.

                IF  NOT AVAIL int-coesa-prev-venda
                THEN DO:
                    CREATE int-coesa-prev-venda.
                    BUFFER-COPY tt-previsao TO int-coesa-prev-venda.
                END.
                ELSE 
                    ASSIGN int-coesa-prev-venda.qtd-prevista = tt-previsao.qtd-prevista.

                ASSIGN int-coesa-prev-venda.dat-alterac       = TODAY
                       int-coesa-prev-venda.hor-alterac       = STRING(TIME,"hh:mm:ss")
                       int-coesa-prev-venda.cod-usuar-alterac = c-seg-usuario
                       int-coesa-prev-venda.cod-arq-importado = tt-previsao.cod-arq-importado.

                RELEASE int-coesa-prev-venda.
            END.
        END. /* IF  INPUT FRAME {&FRAME-NAME} rs-tipo-prev = 1 */
        ELSE DO:
            FOR EACH tt-previsao:
                FIND FIRST int-coesa-prev-prod EXCLUSIVE-LOCK
                    WHERE  int-coesa-prev-prod.cod-estabel          = tt-previsao.cod-estabel          
                      AND  int-coesa-prev-prod.it-codigo            = tt-previsao.it-codigo           
                      AND  int-coesa-prev-prod.dat-reg-previsao     = tt-previsao.dat-reg-previsao    
                      AND  int-coesa-prev-prod.cod-periodo-previsao = tt-previsao.cod-periodo-previsao NO-ERROR.

                IF  NOT AVAIL int-coesa-prev-prod
                THEN DO:
                    CREATE int-coesa-prev-prod.
                    BUFFER-COPY tt-previsao TO int-coesa-prev-prod.
                END.
                ELSE 
                    ASSIGN int-coesa-prev-prod.qtd-prevista = tt-previsao.qtd-prevista.

                ASSIGN int-coesa-prev-prod.dat-alterac       = TODAY
                       int-coesa-prev-prod.hor-alterac       = STRING(TIME,"hh:mm:ss")
                       int-coesa-prev-prod.cod-usuar-alterac = c-seg-usuario
                       int-coesa-prev-prod.cod-arq-importado = tt-previsao.cod-arq-importado.

                RELEASE int-coesa-prev-prod.
            END.
        END. /* else IF  INPUT FRAME {&FRAME-NAME} rs-tipo-prev = 1 */

        IF  SESSION:SET-WAIT-STATE("") THEN.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Processo finalizado com sucesso.").
    END.
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


&Scoped-define SELF-NAME miExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExcluir wWindow
ON CHOOSE OF MENU-ITEM miExcluir /* Excluir Registro(s) */
DO:
    APPLY "DELETE-CHARACTER":U TO BROWSE br-previsoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMoverColuna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMoverColuna wWindow
ON VALUE-CHANGED OF MENU-ITEM miMoverColuna /* Mover Coluna? */
DO:
    ASSIGN br-previsoes:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = NOT MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-br-previsoes
           br-previsoes:COLUMN-MOVABLE         IN FRAME fpage0 = MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-br-previsoes.
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
    ASSIGN v-cod-lst-mes = "Jan;Fev;Mar;Abr;Mai;Jun;Jul;Ago;Set;Out;Nov;Dez".

    ASSIGN v-cod-estabel  = "101"
           v-cod-ano      = STRING(YEAR(TODAY),"9999")
           v-dat-previsao = TODAY.

    DISP v-cod-estabel v-cod-ano v-dat-previsao WITH FRAME {&FRAME-NAME}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

