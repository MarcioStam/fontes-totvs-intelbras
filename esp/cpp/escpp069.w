&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP069 2.06.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCPP069 ESP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP069
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   vCodEstabel vDtRegistro vArquivo btPesquisar btImportar btSalvar btExit brEstoqSegur
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-estoq-segur NO-UNDO LIKE int-coesa-estoq-segur
    FIELD desc-item LIKE item.desc-item.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE deWidth     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deWidthDif  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deHeight    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deheightDif AS DECIMAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEstoqSegur

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estoq-segur

/* Definitions for BROWSE brEstoqSegur                                  */
&Scoped-define FIELDS-IN-QUERY-brEstoqSegur tt-estoq-segur.cod-estabel tt-estoq-segur.it-codigo tt-estoq-segur.desc-item tt-estoq-segur.quant-segur   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEstoqSegur   
&Scoped-define SELF-NAME brEstoqSegur
&Scoped-define QUERY-STRING-brEstoqSegur FOR EACH tt-estoq-segur
&Scoped-define OPEN-QUERY-brEstoqSegur OPEN QUERY {&SELF-NAME} FOR EACH tt-estoq-segur.
&Scoped-define TABLES-IN-QUERY-brEstoqSegur tt-estoq-segur
&Scoped-define FIRST-TABLE-IN-QUERY-brEstoqSegur tt-estoq-segur


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEstoqSegur}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 vCodEstabel vDtRegistro btPesquisar ~
btImportar btSalvar btExit vArquivo brEstoqSegur 
&Scoped-Define DISPLAYED-OBJECTS vCodEstabel vDtRegistro vArquivo 

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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.13
     FONT 4.

DEFINE BUTTON btImportar 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "&Importar" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btPesquisar 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "&Pesquisar" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btSalvar 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "&Salvar" 
     SIZE 4 BY 1.13
     FONT 4.

DEFINE VARIABLE vArquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 55.57 BY .88 NO-UNDO.

DEFINE VARIABLE vCodEstabel LIKE estabelec.cod-estabel
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE vDtRegistro AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data Registro" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEstoqSegur FOR 
      tt-estoq-segur SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEstoqSegur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEstoqSegur wWindow _FREEFORM
  QUERY brEstoqSegur DISPLAY
      tt-estoq-segur.cod-estabel
      tt-estoq-segur.it-codigo
      tt-estoq-segur.desc-item
      tt-estoq-segur.quant-segur
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 18.71
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     vCodEstabel AT ROW 1.58 COL 12.43 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento"
          LABEL "Estab"
     vDtRegistro AT ROW 1.58 COL 31.43 COLON-ALIGNED HELP
          "Data do Registro"
     btPesquisar AT ROW 2.46 COL 70.14 HELP
          "Pesquisar Arquivos"
     btImportar AT ROW 2.46 COL 74.14 HELP
          "Importar Arquivo"
     btSalvar AT ROW 2.46 COL 78.14 HELP
          "Salvar Dados Importados"
     btExit AT ROW 2.46 COL 86 HELP
          "Sair"
     vArquivo AT ROW 2.58 COL 12.43 COLON-ALIGNED
     brEstoqSegur AT ROW 4.08 COL 1.57
     RECT-11 AT ROW 1.17 COL 1.57
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
   FRAME-NAME                                                           */
/* BROWSE-TAB brEstoqSegur vArquivo fpage0 */
/* SETTINGS FOR FILL-IN vCodEstabel IN FRAME fpage0
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE      */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEstoqSegur
/* Query rebuild information for BROWSE brEstoqSegur
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estoq-segur.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEstoqSegur */
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

    ASSIGN vCodEstabel:COLUMN                   IN FRAME fPage0 = vCodEstabel:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           vCodEstabel:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vCodEstabel:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           vDtRegistro:COLUMN                   IN FRAME fPage0 = vDtRegistro:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           vDtRegistro:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vDtRegistro:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           vArquivo:COLUMN                      IN FRAME fPage0 = vArquivo:COLUMN                      IN FRAME fPage0 + (deWidthDif / 2)
           vArquivo:SIDE-LABEL-HANDLE:COLUMN    IN FRAME fPage0 = vArquivo:SIDE-LABEL-HANDLE:COLUMN    IN FRAME fPage0 + (deWidthDif / 2)
           btPesquisar:COLUMN                   IN FRAME fPage0 = btPesquisar:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           btImportar:COLUMN                    IN FRAME fPage0 = btImportar:COLUMN                    IN FRAME fPage0 + (deWidthDif / 2)
           btSalvar:COLUMN                      IN FRAME fPage0 = btSalvar:COLUMN                      IN FRAME fPage0 + (deWidthDif / 2)
           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 +  deWidthDif
           RECT-11:WIDTH                        IN FRAME fPage0 = RECT-11:WIDTH                        IN FRAME fPage0 +  deWidthDif
           brEstoqSegur:WIDTH                   IN FRAME fPage0 = brEstoqSegur:WIDTH                   IN FRAME fPage0 +  deWidthDif
           brEstoqSegur:HEIGHT                  IN FRAME fPage0 = brEstoqSegur:HEIGHT                  IN FRAME fPage0 +  deHeightDif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow
DO:
    IF CURRENT-WINDOW:WIDTH  <> deWidth  AND
       CURRENT-WINDOW:HEIGHT <> deHeight THEN
        RETURN "NOK":U.

    ASSIGN vCodEstabel:COLUMN                   IN FRAME fPage0 = vCodEstabel:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           vCodEstabel:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vCodEstabel:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)
           vDtRegistro:COLUMN                   IN FRAME fPage0 = vDtRegistro:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           vDtRegistro:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vDtRegistro:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)
           vArquivo:COLUMN                      IN FRAME fPage0 = vArquivo:COLUMN                      IN FRAME fPage0 - (deWidthDif / 2)
           vArquivo:SIDE-LABEL-HANDLE:COLUMN    IN FRAME fPage0 = vArquivo:SIDE-LABEL-HANDLE:COLUMN    IN FRAME fPage0 - (deWidthDif / 2)
           btPesquisar:COLUMN                   IN FRAME fPage0 = btPesquisar:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           btImportar:COLUMN                    IN FRAME fPage0 = btImportar:COLUMN                    IN FRAME fPage0 - (deWidthDif / 2)
           btSalvar:COLUMN                      IN FRAME fPage0 = btSalvar:COLUMN                      IN FRAME fPage0 - (deWidthDif / 2)
           btExit:COLUMN                        IN FRAME fPage0 = btExit:COLUMN                        IN FRAME fPage0 -  deWidthDif
           RECT-11:WIDTH                        IN FRAME fPage0 = RECT-11:WIDTH                        IN FRAME fPage0 -  deWidthDif
           brEstoqSegur:WIDTH                   IN FRAME fPage0 = brEstoqSegur:WIDTH                   IN FRAME fPage0 -  deWidthDif
           brEstoqSegur:HEIGHT                  IN FRAME fPage0 = brEstoqSegur:HEIGHT                  IN FRAME fPage0 -  deHeightDif.

    ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
           FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
           FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
           FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
           FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
           FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
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


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wWindow
ON CHOOSE OF btImportar IN FRAME fpage0 /* Importar */
DO:
    RUN piImportarArquivo IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar wWindow
ON CHOOSE OF btPesquisar IN FRAME fpage0 /* Pesquisar */
DO:
    DEFINE VARIABLE c-arq-conv AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok       AS LOGICAL     NO-UNDO INITIAL NO.

    ASSIGN c-arq-conv = "":U.

    SYSTEM-DIALOG GET-FILE c-arq-conv
        FILTERS "*.csv":U   "*.csv":U,
                "*.*":U     "*.*":U
        DEFAULT-EXTENSION "csv":U
        MUST-EXIST
        USE-FILENAME
        TITLE "Importar do arquivo":U
        UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN vArquivo = c-arq-conv.

        DISPLAY vArquivo
            WITH FRAME fpage0.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
    RUN piSalvarDados IN THIS-PROCEDURE.
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


&Scoped-define BROWSE-NAME brEstoqSegur
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

    ASSIGN vCodEstabel = "101":U
           vDtRegistro = TODAY.
           
    DISPLAY vCodEstabel
            vDtRegistro
        WITH FRAME fpage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportarArquivo wWindow 
PROCEDURE piImportarArquivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLinha AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLinha AS INTEGER     NO-UNDO.

    DEFINE VARIABLE vItCodigo   LIKE int-coesa-estoq-segur.it-codigo   NO-UNDO.
    DEFINE VARIABLE vQuantSegur LIKE int-coesa-estoq-segur.quant-segur NO-UNDO.

    EMPTY TEMP-TABLE tt-estoq-segur.

    {&OPEN-QUERY-brEstoqSegur}

    ASSIGN INPUT FRAME {&FRAME-NAME} vCodEstabel
                                     vDtRegistro
                                     vArquivo.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = vCodEstabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento":U).

        RETURN NO-APPLY.
    END.

    IF  vDtRegistro = ?     OR
        vDtRegistro > TODAY THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Data de previs∆o inv†lida.~~A data de geraá∆o da previs∆o deve ser maior que 01/01/2012 e, menor que a data corrente.":U).

        RETURN NO-APPLY.
    END.

    IF SEARCH(INPUT FRAME fpage0 vArquivo) <> ? THEN DO:
        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        EMPTY TEMP-TABLE tt-estoq-segur.

        ASSIGN iLinha = 0.

        INPUT FROM VALUE(SEARCH(INPUT FRAME fpage0 vArquivo)).

        REPEAT:
            IMPORT UNFORMATTED cLinha.

            ASSIGN iLinha = iLinha + 1.

            IF iLinha                     = 1 AND
               NUM-ENTRIES(cLinha, ";":U) < 2 THEN DO:
                INPUT CLOSE.

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Arquivo n∆o possui o layout correto para importaá∆o.~~Valide o layout do arquivo junto ao departamento de TIC.":U).

                RETURN NO-APPLY.
            END.

            IF iLinha = 1 THEN
                NEXT.

            ASSIGN vItCodigo = TRIM(ENTRY(1, cLinha, ";":U)) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
                ASSIGN vItCodigo = ?.

            FIND FIRST item
                WHERE item.it-codigo = vItCodigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item THEN
                NEXT.

            ASSIGN vQuantSegur = DECIMAL(TRIM(ENTRY(2, cLinha, ";":U))) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
                ASSIGN vQuantSegur = 0.0.

            IF vQuantSegur > 0 THEN DO:
                FIND FIRST tt-estoq-segur
                    WHERE tt-estoq-segur.cod-estabel          = vCodEstabel
                      AND tt-estoq-segur.it-codigo            = vItCodigo
                      AND tt-estoq-segur.dat-registro         = vDtRegistro NO-ERROR.

                IF NOT AVAILABLE tt-estoq-segur THEN DO:
                    CREATE tt-estoq-segur.
                    ASSIGN tt-estoq-segur.cod-estabel       = vCodEstabel
                           tt-estoq-segur.it-codigo         = vItCodigo
                           tt-estoq-segur.dat-registro      = vDtRegistro.

                    FIND FIRST item
                        WHERE item.it-codigo = vItCodigo NO-LOCK NO-ERROR.

                    ASSIGN tt-estoq-segur.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.
                END.

                ASSIGN tt-estoq-segur.quant-segur       = vQuantSegur
                       tt-estoq-segur.dat-alterac       = TODAY
                       tt-estoq-segur.hor-alterac       = STRING(TIME, "hh:mm:ss":U)
                       tt-estoq-segur.cod-usuar-alterac = c-seg-usuario
                       tt-estoq-segur.cod-arq-importado = SEARCH(INPUT FRAME fpage0 vArquivo).

            END. /* IF vQuantSegur > 0 THEN DO: */
        END. /* REPEAT: */

        INPUT CLOSE.

        {&OPEN-QUERY-brEstoqSegur}
            
        IF SESSION:SET-WAIT-STATE("") THEN.

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importaá∆o finalizada com sucesso.":U).

    END. /* IF SEARCH(INPUT FRAME fpage0 vArquivo) <> ? THEN DO: */
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo n∆o encontrado.":U).

        RETURN NO-APPLY.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSalvarDados wWindow 
PROCEDURE piSalvarDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    FOR EACH tt-estoq-segur:
        FIND FIRST int-coesa-estoq-segur
            WHERE int-coesa-estoq-segur.cod-estabel  = tt-estoq-segur.cod-estabel
              AND int-coesa-estoq-segur.it-codigo    = tt-estoq-segur.it-codigo
              AND int-coesa-estoq-segur.dat-registro = tt-estoq-segur.dat-registro EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL int-coesa-estoq-segur THEN DO:
            CREATE int-coesa-estoq-segur.
            BUFFER-COPY tt-estoq-segur EXCEPT quant-segur dat-alterac hor-alterac cod-usuar-alterac cod-arq-importado desc-item TO int-coesa-estoq-segur.
        END.

        ASSIGN int-coesa-estoq-segur.quant-segur       = tt-estoq-segur.quant-segur
               int-coesa-estoq-segur.dat-alterac       = TODAY
               int-coesa-estoq-segur.hor-alterac       = STRING(TIME, "hh:mm:ss":U)
               int-coesa-estoq-segur.cod-usuar-alterac = c-seg-usuario
               int-coesa-estoq-segur.cod-arq-importado = tt-estoq-segur.cod-arq-importado.

        RELEASE int-coesa-estoq-segur.
    END.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Processo finalizado com sucesso.":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

