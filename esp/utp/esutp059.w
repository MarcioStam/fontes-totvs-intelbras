&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP059 2.00.06.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESUTP059
&GLOBAL-DEFINE Version        2.00.06.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-arquivo bt-fil bt-sal bt-arq btExit br-itens

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-dat-ult-movto AS DATE        NO-UNDO.

/* Temp Table Definitions ---                                          */

DEF TEMP-TABLE tt-itens NO-UNDO
    FIELD des-unidade AS CHAR
    FIELD des-familia AS CHAR
    FIELD des-sub-fam AS CHAR
    FIELD cod-ean13   AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD desc-item   AS CHAR
    INDEX id-item
            it-codigo.

DEF BUFFER b-fam-com-item FOR fam-com-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-itens.it-codigo tt-itens.desc-item tt-itens.des-unidade tt-itens.des-familia tt-itens.des-sub-fam tt-itens.cod-ean13   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-itens
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-itens.
&Scoped-define TABLES-IN-QUERY-br-itens tt-itens
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-itens


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-fil v-cod-arquivo bt-arq bt-sal btExit ~
br-itens RECT-2 
&Scoped-Define DISPLAYED-OBJECTS v-cod-arquivo 

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


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arq 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Selecionar arquivo destino".

DEFINE BUTTON bt-fil 
     LABEL "Gerar Lista de Itens em Tela" 
     SIZE 56 BY 1 TOOLTIP "Gerar Lista de Itens em Tela"
     FONT 4.

DEFINE BUTTON bt-sal 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Salvar" 
     SIZE 4 BY 1 TOOLTIP "Gerar arquivo"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1 TOOLTIP "Sair"
     FONT 4.

DEFINE VARIABLE v-cod-arquivo AS CHARACTER FORMAT "X(60)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-itens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens wWindow _FREEFORM
  QUERY br-itens DISPLAY
      tt-itens.it-codigo   FORMAT "x(08)" LABEL "Item"
    tt-itens.desc-item   FORMAT "x(25)" LABEL "Descriá∆o"
    tt-itens.des-unidade FORMAT "x(14)" LABEL "Unididade"
    tt-itens.des-familia FORMAT "x(18)" LABEL "Fam°lia"
    tt-itens.des-sub-fam FORMAT "x(18)" LABEL "Sub-Fam°lia"
    tt-itens.cod-ean13   FORMAT "x(13)" LABEL "EAN13"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 16.75
         FONT 1 ROW-HEIGHT-CHARS .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-fil AT ROW 1.5 COL 19 HELP
          "Consultas relacionadas" WIDGET-ID 14
     v-cod-arquivo AT ROW 2.75 COL 17 COLON-ALIGNED WIDGET-ID 86
     bt-arq AT ROW 2.75 COL 75 HELP
          "Localiza Arquivo" WIDGET-ID 6
     bt-sal AT ROW 2.75 COL 79 HELP
          "Confirma alteraá‰es" WIDGET-ID 68
     btExit AT ROW 2.75 COL 85.86 HELP
          "Sair"
     br-itens AT ROW 4.25 COL 2 WIDGET-ID 200
     RECT-2 AT ROW 1.42 COL 2 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 20.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.08
         WIDTH              = 91.29
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.96
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
/* BROWSE-TAB br-itens btExit fpage0 */
ASSIGN 
       br-itens:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       br-itens:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
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
       TITLE 'Selecionar arquivo destino'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign v-cod-arquivo = c-arq-conv.
        display v-cod-arquivo with frame {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Gerar Lista de Itens em Tela */
DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Inicializar....").

    EMPTY TEMP-TABLE tt-itens.
    RUN pi-gera-lista-itens.

    RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-br-itens}

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Geraá∆o da lista de itens finalizada.").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sal wWindow
ON CHOOSE OF bt-sal IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN v-cod-arquivo = INPUT FRAME {&FRAME-NAME} v-cod-arquivo.

    IF  INDEX(v-cod-arquivo,".csv") = 0
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Extens∆o do arquivo inv†lida. ~~ O arquivo informado deve possuir extens∆o (.csv).").
        RETURN NO-APPLY.
    END.

    IF  SEARCH(v-cod-arquivo) <> ?
    THEN
        OS-DELETE VALUE(v-cod-arquivo).


    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Confirma geraá∆o do arquivo?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        FIND FIRST tt-itens NO-LOCK NO-ERROR.

        IF  NOT AVAIL tt-itens
        THEN
            APPLY "CHOOSE" TO bt-fil IN FRAME {&FRAME-NAME}.

        IF SESSION:SET-WAIT-STATE("general") THEN.
        OUTPUT TO VALUE(v-cod-arquivo) CONVERT TARGET "iso8859-1".
        PUT UNFORMATTED "Unidade;Fam°lia;Sub-Fam°lia;EAN 13;SKU;C¢digo Interno do Produto;Descriá∆o do Produto;Cor;Voltagem" SKIP.

        FOR EACH tt-itens NO-LOCK:
        
                PUT UNFORMATTED tt-itens.des-unidade ";" 
                                tt-itens.des-familia ";"
                                tt-itens.des-sub-fam ";"
                                tt-itens.cod-ean13   ";"
                                ""                   ";"
                                tt-itens.it-codigo   ";"
                                tt-itens.desc-item   ";"
                                ""                   ";" 
                                ""                   SKIP.
        END.
        OUTPUT CLOSE.
        
        IF SESSION:SET-WAIT-STATE("") THEN.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Arquivo gerado com sucesso.").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/



{window/mainblock.i}


ASSIGN v-cod-arquivo = SESSION:TEMP-DIRECTORY + "itens_neogrid.csv".

DISPLAY v-cod-arquivo WITH FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-lista-itens wWindow 
PROCEDURE pi-gera-lista-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN v-dat-ult-movto = TODAY - 731. /* data corrente menos dois anos */

    FOR EACH ITEM NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ITEM.it-codigo).

        /* N∆o exportar item sem fam°lia comercial */
        IF  ITEM.fm-cod-com = ""
        THEN
            NEXT.

        /* Exportar apenas itens acabados */
        IF  NOT ITEM.it-codigo BEGINS "4"
        THEN
            NEXT.

        FIND ITEM-mat NO-LOCK
            WHERE item-mat.it-codigo = ITEM.it-codigo NO-ERROR.


        FIND fam-com-item NO-LOCK
            WHERE fam-com-item.fm-cod-com = ITEM.fm-cod-com NO-ERROR.
        IF  NOT AVAIL fam-com-item
        THEN
            NEXT.

        FIND LAST movto-estoq NO-LOCK
            WHERE movto-estoq.it-codigo = ITEM.it-codigo NO-ERROR.

        IF  NOT AVAIL movto-estoq OR 
               (AVAIL movto-estoq AND 
                      movto-estoq.dt-trans < v-dat-ult-movto)
        THEN 
            NEXT.

        CREATE tt-itens.
        ASSIGN tt-itens.it-codigo = ITEM.it-codigo
               tt-itens.desc-item = ITEM.desc-item
               tt-itens.cod-ean13 = IF AVAIL item-mat THEN item-mat.cod-ean ELSE "".

        FIND FIRST b-fam-com-item NO-LOCK
             WHERE b-fam-com-item.segmento = fam-com-item.segmento NO-ERROR.
        IF  AVAIL b-fam-com-item
        THEN
            ASSIGN tt-itens.des-unidade = b-fam-com-item.descricao.

        FIND FIRST b-fam-com-item NO-LOCK
             WHERE b-fam-com-item.segmento = fam-com-item.segmento
               AND b-fam-com-item.unidade  = fam-com-item.unidade 
               AND b-fam-com-item.familia1 = fam-com-item.familia1 NO-ERROR.
        IF  AVAIL b-fam-com-item 
        THEN
            ASSIGN tt-itens.des-familia = b-fam-com-item.descricao.

        FIND FIRST b-fam-com-item NO-LOCK
             WHERE b-fam-com-item.segmento = fam-com-item.segmento
               AND b-fam-com-item.unidade  = fam-com-item.unidade 
               AND b-fam-com-item.familia1 = fam-com-item.familia1 
               AND b-fam-com-item.familia2 = fam-com-item.familia2 NO-ERROR.
        IF  AVAIL b-fam-com-item
        THEN
            ASSIGN tt-itens.des-sub-fam = b-fam-com-item.descricao.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

