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
{include/i-prgvrs.i ESCPP071 2.06.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCPP071 ESP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP071
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   vCodEstabel vPeriodoIni vPeriodoFin btFil btExit brPrazo
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Emitentes que devem ser desconsiderados na geraá∆o do indicador, separados por v°rgula. */
&GLOBAL-DEFINE descon-emitente  18963

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-prazo NO-UNDO
    FIELD it-codigo        LIKE ordem-compra.it-codigo
    FIELD desc-item        LIKE item.desc-item
    FIELD num-pedido       LIKE ordem-compra.num-pedido
    FIELD cod-fornecedor   LIKE ordem-compra.cod-emitente
    FIELD nome-abrev-forn  LIKE emitente.nome-abrev
    FIELD tp-desp-padrao   LIKE emitente.tp-desp-padrao
    FIELD desc-tp-desp     LIKE tipo-rec-desp.descricao        LABEL "Descriá∆o Despesa":U       COLUMN-LABEL "Desc Despesa":U
    FIELD numero-ordem     LIKE ordem-compra.numero-ordem
    FIELD parcela          LIKE recebimento.parcela
    FIELD data-previsao    LIKE prazo-compra.data-entrega      LABEL "Dt Prev Entrega":U         COLUMN-LABEL "Dt Prev Entreg":U
    FIELD data-emissao     LIKE ordem-compra.data-emissao      LABEL "Dt Emiss∆o":U              COLUMN-LABEL "Dt Emiss∆o":U
    FIELD data-pedido      LIKE ordem-compra.data-pedido       LABEL "Dt Pedido":U               COLUMN-LABEL "Dt Pedido":U
    FIELD data-original-oc AS DATE FORMAT "99/99/9999":U       LABEL "Dt Original OC":U          COLUMN-LABEL "Dt Orig OC":U VIEW-AS FILL-IN SIZE 12 BY 0.88
    FIELD data-entrega     LIKE recebimento.data-movto         LABEL "Dt Entrega":U              COLUMN-LABEL "Dt Entrega":U
    FIELD res-for-comp     LIKE item-uni-estab.res-for-comp
    FIELD tempo-ressup     LIKE item-fornec-estab.tempo-ressup
    FIELD tipo-item        AS CHARACTER FORMAT "x(10)":U       LABEL "Tipo Item":U               COLUMN-LABEL "Tp Item":U
    FIELD fm-cod-com       LIKE item.fm-cod-com
    FIELD ge-codigo        LIKE item.ge-codigo
    FIELD desc-ge          LIKE grup-estoque.descricao         LABEL "Descriá∆o Grupo Estoque":U COLUMN-LABEL "Desc Gr Estoq":U
    FIELD dias-entr-orig   AS INTEGER                          LABEL "Entrega X Original":U      COLUMN-LABEL "Entreg X Orig":U
    FIELD status-entr-orig AS CHARACTER FORMAT "x(10)":U       LABEL "Status Entr X Orig":U      COLUMN-LABEL "Status Entr X Orig":U
    FIELD dias-entr-prev   AS INTEGER                          LABEL "Entrega X Previsto":U      COLUMN-LABEL "Entreg X Prev":U
    FIELD status-entr-prev AS CHARACTER FORMAT "x(10)":U       LABEL "Status Entr X Prev":U      COLUMN-LABEL "Status Entr X Prev":U
    INDEX ch-primario IS PRIMARY UNIQUE
        num-pedido
        numero-ordem
        data-entrega.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lDesc        AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE cQuery       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampoSearch AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hAcomp       AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPrazo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-prazo

/* Definitions for BROWSE brPrazo                                       */
&Scoped-define FIELDS-IN-QUERY-brPrazo tt-prazo.it-codigo tt-prazo.desc-item tt-prazo.num-pedido tt-prazo.cod-fornecedor tt-prazo.nome-abrev-forn tt-prazo.tp-desp-padrao tt-prazo.desc-tp-desp tt-prazo.numero-ordem tt-prazo.parcela tt-prazo.data-previsao tt-prazo.data-emissao tt-prazo.data-pedido tt-prazo.data-original-oc tt-prazo.data-entrega tt-prazo.res-for-comp tt-prazo.tempo-ressup tt-prazo.tipo-item tt-prazo.fm-cod-com tt-prazo.ge-codigo tt-prazo.desc-ge tt-prazo.dias-entr-orig tt-prazo.status-entr-orig tt-prazo.dias-entr-prev tt-prazo.status-entr-prev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPrazo   
&Scoped-define SELF-NAME brPrazo
&Scoped-define QUERY-STRING-brPrazo FOR EACH tt-prazo
&Scoped-define OPEN-QUERY-brPrazo OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo.
&Scoped-define TABLES-IN-QUERY-brPrazo tt-prazo
&Scoped-define FIRST-TABLE-IN-QUERY-brPrazo tt-prazo


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brPrazo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 IMAGE-3 IMAGE-4 vCodEstabel ~
vPeriodoIni vPeriodoFin btFil btExit brPrazo 
&Scoped-Define DISPLAYED-OBJECTS vCodEstabel vPeriodoIni vPeriodoFin 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFiltrar      LABEL "&Filtrar"      
       RULE
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

DEFINE BUTTON btFil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "&Filtrar" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE vCodEstabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE vPeriodoFin AS CHARACTER FORMAT "9999/99":U INITIAL "299912" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vPeriodoIni AS CHARACTER FORMAT "9999/99":U INITIAL "180001" 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPrazo FOR 
      tt-prazo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPrazo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPrazo wWindow _FREEFORM
  QUERY brPrazo DISPLAY
      tt-prazo.it-codigo
      tt-prazo.desc-item
      tt-prazo.num-pedido
      tt-prazo.cod-fornecedor
      tt-prazo.nome-abrev-forn
      tt-prazo.tp-desp-padrao
      tt-prazo.desc-tp-desp
      tt-prazo.numero-ordem
      tt-prazo.parcela
      tt-prazo.data-previsao
      tt-prazo.data-emissao
      tt-prazo.data-pedido
      tt-prazo.data-original-oc
      tt-prazo.data-entrega
      tt-prazo.res-for-comp
      tt-prazo.tempo-ressup
      tt-prazo.tipo-item
      tt-prazo.fm-cod-com
      tt-prazo.ge-codigo
      tt-prazo.desc-ge
      tt-prazo.dias-entr-orig
      tt-prazo.status-entr-orig
      tt-prazo.dias-entr-prev
      tt-prazo.status-entr-prev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 18.71
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     vCodEstabel AT ROW 1.58 COL 12.43 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     vPeriodoIni AT ROW 2.58 COL 12.43 COLON-ALIGNED HELP
          "Per°odo Inicial"
     vPeriodoFin AT ROW 2.58 COL 31.43 COLON-ALIGNED HELP
          "Per°odo Final" NO-LABEL
     btFil AT ROW 2.58 COL 82 HELP
          "Filtrar"
     btExit AT ROW 2.58 COL 86 HELP
          "Sair"
     brPrazo AT ROW 4.08 COL 1.57
     RECT-11 AT ROW 1.17 COL 1.57
     IMAGE-3 AT ROW 2.58 COL 24.72
     IMAGE-4 AT ROW 2.58 COL 30.29
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
   FRAME-NAME                                                           */
/* BROWSE-TAB brPrazo btExit fpage0 */
ASSIGN 
       brPrazo:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brPrazo:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR FILL-IN vCodEstabel IN FRAME fpage0
   LIKE = mgcad.estabelec.cod-estabel                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPrazo
/* Query rebuild information for BROWSE brPrazo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brPrazo */
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


&Scoped-define BROWSE-NAME brPrazo
&Scoped-define SELF-NAME brPrazo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPrazo wWindow
ON START-SEARCH OF brPrazo IN FRAME fpage0
DO:
    IF SELF:CURRENT-COLUMN:TABLE  = "tt-prazo":U AND
       SELF:CURRENT-COLUMN:NAME  <> ?            AND
       SELF:CURRENT-COLUMN:NAME  <> "":U         THEN DO:
        IF cCampoSearch = SELF:CURRENT-COLUMN:NAME THEN DO:
            ASSIGN lDesc = NOT lDesc.

            IF lDesc THEN
                ASSIGN cQuery = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC INDEXED-REPOSITION":U.
            ELSE
                ASSIGN cQuery = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U.
        END.
        ELSE
            ASSIGN cQuery       = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U
                   cCampoSearch = SELF:CURRENT-COLUMN:NAME
                   lDesc        = NO.

        SELF:QUERY:QUERY-PREPARE(cQuery).
        SELF:QUERY:QUERY-OPEN().
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


&Scoped-define SELF-NAME btFil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFil wWindow
ON CHOOSE OF btFil IN FRAME fpage0 /* Filtrar */
OR CHOOSE OF MENU-ITEM miFiltrar IN MENU mbMain DO:
    EMPTY TEMP-TABLE tt-prazo.

    {&OPEN-QUERY-brPrazo}

    ASSIGN INPUT FRAME fpage0 vCodEstabel
                              vPeriodoIni
                              vPeriodoFin.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = vCodEstabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento":U).

        RETURN NO-APPLY.
    END.

    IF vPeriodoIni = "":U OR
       vPeriodoFin = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per°odo inv†lido.":U).

        RETURN NO-APPLY.
    END.

    IF vPeriodoIni > vPeriodoFin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per°odo inv†lido.~~O per°odo inicial deve ser igual ou inferior ao per°odo final.":U).

        RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    EMPTY TEMP-TABLE tt-prazo.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "":U).

    RUN piPrazo IN THIS-PROCEDURE.

    {&OPEN-QUERY-brPrazo}

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE OBJECT hAcomp.

    ASSIGN hAcomp = ?.

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
    ASSIGN vCodEstabel = "101":U
           vPeriodoIni = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 7), "99":U)
           vPeriodoFin = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 1), "99":U).

    DISPLAY vCodEstabel
            vPeriodoIni
            vPeriodoFin
        WITH FRAME fpage0.

    DISABLE vCodEstabel
        WITH FRAME fpage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrazo wWindow 
PROCEDURE piPrazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE datIni AS DATE        NO-UNDO.
    DEFINE VARIABLE datFin AS DATE        NO-UNDO.
    DEFINE VARIABLE datAux AS DATE        NO-UNDO.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-seta-titulo IN hAcomp (INPUT "Gerando Prazos...":U).

    ASSIGN datIni = DATE(INTEGER(TRIM(SUBSTRING(vPeriodoIni, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(vPeriodoIni, 1, 4))))
           datFin = DATE(INTEGER(TRIM(SUBSTRING(vPeriodoFin, 5, 2))), 25, INTEGER(TRIM(SUBSTRING(vPeriodoFin, 1, 4)))) + 15
           datFin = datFin - DAY(datFin).

    DO datAux = datIni TO datFin:
        FOR EACH ordem-compra USE-INDEX data-emissao NO-LOCK
            WHERE ordem-compra.data-emissao = datAux
              AND ordem-compra.situacao     = 6 /* Recebida */
              AND ordem-compra.cod-estabel  = vCodEstabel
              AND ordem-compra.it-codigo   <> "":U,
            EACH recebimento USE-INDEX pedido NO-LOCK
            WHERE recebimento.num-pedido   = ordem-compra.num-pedido
              AND recebimento.numero-ordem = ordem-compra.numero-ordem:

            /* Emitentes que devem ser desconsiderados (Parametrizar no GLOBAL-DEFINE "descon-emitente") */
            IF LOOKUP(TRIM(STRING(ordem-compra.cod-emitente)), "{&descon-emitente}":U) <> 0 THEN
                NEXT.

            IF CAN-FIND(FIRST tt-prazo
                        WHERE tt-prazo.num-pedido   = ordem-compra.num-pedido
                          AND tt-prazo.numero-ordem = ordem-compra.numero-ordem
                          AND tt-prazo.data-entrega = recebimento.data-movto) THEN
                NEXT.

            FIND FIRST item
                WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item     OR
               (item.ge-codigo <> 10  AND
                item.ge-codigo <> 12  AND
                item.ge-codigo <> 15  AND
                item.ge-codigo <> 20  AND
                item.ge-codigo <> 25  AND
                item.ge-codigo <> 40  AND
                item.ge-codigo <> 42  AND
                item.ge-codigo <> 45) THEN
                NEXT.

            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "Ord Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U)) + " - Dt Emiss∆o: ":U + STRING(ordem-compra.data-emissao, "99/99/9999":U)).

            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
                  AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

            FIND FIRST item-fornec-estab
                WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
                  AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
                  AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

            FIND FIRST grup-estoque
                WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN
                FIND FIRST tipo-rec-desp
                    WHERE tipo-rec-desp.tp-codigo = emitente.tp-desp-padrao NO-LOCK NO-ERROR.
            ELSE
                RELEASE tipo-rec-desp.

            FIND FIRST prazo-compra
                WHERE prazo-compra.numero-ordem = recebimento.numero-ordem
                  AND prazo-compra.parcela      = recebimento.parcela NO-LOCK NO-ERROR.

            CREATE tt-prazo.
            ASSIGN tt-prazo.it-codigo        = ordem-compra.it-codigo
                   tt-prazo.desc-item        = IF AVAILABLE item THEN item.desc-item ELSE "":U
                   tt-prazo.num-pedido       = ordem-compra.num-pedido
                   tt-prazo.cod-fornecedor   = ordem-compra.cod-emitente
                   tt-prazo.nome-abrev-forn  = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U
                   tt-prazo.tp-desp-padrao   = IF AVAILABLE emitente THEN emitente.tp-desp-padrao ELSE 0
                   tt-prazo.desc-tp-desp     = IF AVAILABLE tipo-rec-desp THEN tipo-rec-desp.descricao ELSE "":U
                   tt-prazo.numero-ordem     = ordem-compra.numero-ordem
                   tt-prazo.parcela          = recebimento.parcela
                   tt-prazo.data-previsao    = IF AVAILABLE prazo-compra THEN prazo-compra.data-entrega ELSE ?
                   tt-prazo.data-emissao     = ordem-compra.data-emissao
                   tt-prazo.data-pedido      = ordem-compra.data-pedido
                   tt-prazo.data-original-oc = recebimento.data-movto
                   tt-prazo.data-entrega     = recebimento.data-movto
                   tt-prazo.res-for-comp     = IF AVAILABLE item-uni-estab THEN item-uni-estab.res-for-comp ELSE 0
                   tt-prazo.tempo-ressup     = IF AVAILABLE item-fornec-estab THEN item-fornec-estab.tempo-ressup ELSE 0
                   tt-prazo.tipo-item        = IF item.compr-fabric = 1 THEN "Comprado":U ELSE "Fabricado":U
                   tt-prazo.fm-cod-com       = item.fm-cod-com
                   tt-prazo.ge-codigo        = item.ge-codigo
                   tt-prazo.desc-ge          = IF AVAILABLE grup-estoque THEN grup-estoque.descricao ELSE "":U.

            FOR EACH alt-ped NO-LOCK
                WHERE alt-ped.num-pedido   = ordem-compra.num-pedido
                  AND alt-ped.numero-ordem = ordem-compra.numero-ordem
                  AND alt-ped.parcela      = recebimento.parcela:
                IF alt-ped.data-entrega <> ? THEN DO:
                    ASSIGN tt-prazo.data-original-oc = alt-ped.data-entrega.

                    LEAVE.
                END.
            END.

            IF tt-prazo.data-previsao = ? THEN
                ASSIGN tt-prazo.data-previsao = tt-prazo.data-original-oc.

            ASSIGN tt-prazo.dias-entr-orig = tt-prazo.data-entrega - tt-prazo.data-original-oc
                   tt-prazo.dias-entr-prev = tt-prazo.data-entrega - tt-prazo.data-previsao.

            IF tt-prazo.dias-entr-orig < 0 THEN
                ASSIGN tt-prazo.status-entr-orig = "Adiantado":U.
            ELSE IF tt-prazo.dias-entr-orig = 0 THEN
                ASSIGN tt-prazo.status-entr-orig = "OK":U.
            ELSE
                ASSIGN tt-prazo.status-entr-orig = "Atrasado":U.

            IF tt-prazo.dias-entr-prev < 0 THEN
                ASSIGN tt-prazo.status-entr-prev = "Adiantado":U.
            ELSE IF tt-prazo.dias-entr-prev = 0 THEN
                ASSIGN tt-prazo.status-entr-prev = "OK":U.
            ELSE
                ASSIGN tt-prazo.status-entr-prev = "Atrasado":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

