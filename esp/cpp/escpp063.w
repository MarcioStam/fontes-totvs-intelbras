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
{include/i-prgvrs.i ESCPP063 2.00.06.004}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP063
&GLOBAL-DEFINE Version        2.00.06.004

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   vCodEstabel vCodPeriodoIni vCodPeriodoFin vCodUnidNegoc btFil btExit brPrevisao
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-previsao NO-UNDO
    FIELD cod-estabel          LIKE estabelec.cod-estabel
    FIELD it-codigo            LIKE item.it-codigo
    FIELD desc-item            LIKE item.desc-item                            LABEL "Descri‡Æo Item":U          COLUMN-LABEL "Desc Item":U
    FIELD cod-periodo-previsao AS CHARACTER FORMAT "9999/99":U                LABEL "Per¡odo":U                 COLUMN-LABEL "Per¡odo":U
    FIELD dat-reg-previsao     AS DATE      FORMAT "99/99/9999":U             LABEL "VersÆo":U                  COLUMN-LABEL "VersÆo":U
    FIELD qtd-pedido           AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "Pedido":U                  COLUMN-LABEL "Pedido":U
    FIELD qtd-prev-venda       AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "PrevisÆo Venda":U          COLUMN-LABEL "Prev Venda":U
    FIELD qtd-faturado         AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "Faturado":U                COLUMN-LABEL "Faturado":U
    FIELD qtd-faturado-mes     AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "Faturado Mˆs":U            COLUMN-LABEL "Faturado Mˆs":U
    FIELD qtd-planejado        AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "Planejado":U               COLUMN-LABEL "Planejado":U
    FIELD qtd-produzido        AS DECIMAL   FORMAT "->>>,>>>,>>9":U INITIAL 0 LABEL "Produzido":U               COLUMN-LABEL "Produzido":U
    FIELD quant-segur          LIKE item-uni-estab.quant-segur                LABEL "Qtd Seguran‡a":U           COLUMN-LABEL "Qtd Seguran‡a":U
    FIELD cod-unid-negoc       LIKE item-uni-estab.cod-unid-negoc
    FIELD fm-cod-com           LIKE item.fm-cod-com
    FIELD ge-codigo            LIKE item.ge-codigo
    FIELD desc-ge              LIKE grup-estoque.descricao                    LABEL "Descri‡Æo Grupo Estoque":U COLUMN-LABEL "Desc Gr Estoq":U
    FIELD dt-prim-movto-prod   AS DATE      FORMAT "99/99/9999":U             LABEL "Primeiro Movto Prod":U     COLUMN-LABEL "Primeiro Movto Prod":U
    FIELD dt-prim-saida        AS DATE      FORMAT "99/99/9999":U             LABEL "Primeira Sa¡da":U          COLUMN-LABEL "Primeira Sa¡da":U
    INDEX ch-primario IS PRIMARY UNIQUE
        cod-estabel
        it-codigo
        desc-item
        cod-periodo-previsao
        dat-reg-previsao.

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE lDesc        AS LOGICAL       NO-UNDO INITIAL NO.
DEFINE VARIABLE cQuery       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cCampoSearch AS CHARACTER     NO-UNDO.
DEFINE VARIABLE dtIni        AS DATE          NO-UNDO.
DEFINE VARIABLE dtFin        AS DATE          NO-UNDO.
DEFINE VARIABLE dtAux        AS DATE          NO-UNDO.
DEFINE VARIABLE vCodPeriodo  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE iContReg     AS INTEGER       NO-UNDO.
DEFINE VARIABLE v-wgh-col-br AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPrevisao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-previsao

/* Definitions for BROWSE brPrevisao                                    */
&Scoped-define FIELDS-IN-QUERY-brPrevisao tt-previsao.cod-estabel tt-previsao.it-codigo tt-previsao.desc-item tt-previsao.cod-periodo-previsao tt-previsao.dat-reg-previsao tt-previsao.qtd-pedido tt-previsao.qtd-prev-venda tt-previsao.qtd-faturado tt-previsao.qtd-faturado-mes tt-previsao.qtd-planejado tt-previsao.qtd-produzido tt-previsao.quant-segur tt-previsao.cod-unid-negoc tt-previsao.fm-cod-com tt-previsao.ge-codigo tt-previsao.desc-ge tt-previsao.dt-prim-movto-prod tt-previsao.dt-prim-saida   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPrevisao   
&Scoped-define SELF-NAME brPrevisao
&Scoped-define QUERY-STRING-brPrevisao FOR EACH tt-previsao
&Scoped-define OPEN-QUERY-brPrevisao OPEN QUERY {&SELF-NAME} FOR EACH tt-previsao.
&Scoped-define TABLES-IN-QUERY-brPrevisao tt-previsao
&Scoped-define FIRST-TABLE-IN-QUERY-brPrevisao tt-previsao


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brPrevisao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 IMAGE-1 IMAGE-2 vCodEstabel ~
vCodPeriodoIni vCodPeriodoFin vCodUnidNegoc btFil btExit brPrevisao 
&Scoped-Define DISPLAYED-OBJECTS vCodEstabel vCodPeriodoIni vCodPeriodoFin ~
vCodUnidNegoc 

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

DEFINE MENU pmn-brPrevisao 
       MENU-ITEM miMoverColuna  LABEL "&Mover Coluna?"
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     FONT 4.

DEFINE BUTTON btFil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar informa‡äes"
     FONT 4.

DEFINE VARIABLE vCodEstabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE vCodPeriodoFin AS CHARACTER FORMAT "9999/99":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vCodPeriodoIni AS CHARACTER FORMAT "9999/99":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vCodUnidNegoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPrevisao FOR 
      tt-previsao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPrevisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPrevisao wWindow _FREEFORM
  QUERY brPrevisao NO-LOCK DISPLAY
      tt-previsao.cod-estabel          WIDTH  5.00
      tt-previsao.it-codigo
      tt-previsao.desc-item
      tt-previsao.cod-periodo-previsao WIDTH  8.00
      tt-previsao.dat-reg-previsao     WIDTH 10.00
      tt-previsao.qtd-pedido
      tt-previsao.qtd-prev-venda
      tt-previsao.qtd-faturado
      tt-previsao.qtd-faturado-mes
      tt-previsao.qtd-planejado
      tt-previsao.qtd-produzido
      tt-previsao.quant-segur
      tt-previsao.cod-unid-negoc
      tt-previsao.fm-cod-com
      tt-previsao.ge-codigo            WIDTH  5.00
      tt-previsao.desc-ge
      tt-previsao.dt-prim-movto-prod
      tt-previsao.dt-prim-saida
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 18.71
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     vCodEstabel AT ROW 1.58 COL 12.43 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento"
     vCodPeriodoIni AT ROW 2.58 COL 12.43 COLON-ALIGNED HELP
          "Per¡odo Inicial"
     vCodPeriodoFin AT ROW 2.58 COL 31.43 COLON-ALIGNED HELP
          "Per¡odo Final" NO-LABEL
     vCodUnidNegoc AT ROW 2.58 COL 56 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     btFil AT ROW 2.58 COL 82 HELP
          "Filtrar objetos expedidos pelos previsoes" WIDGET-ID 46
     btExit AT ROW 2.58 COL 86 HELP
          "Sair do programa"
     brPrevisao AT ROW 4.08 COL 1.57 HELP
          "Previsäes"
     RECT-11 AT ROW 1.17 COL 1.57
     IMAGE-1 AT ROW 2.58 COL 24.72 WIDGET-ID 76
     IMAGE-2 AT ROW 2.58 COL 30.29 WIDGET-ID 78
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
/* BROWSE-TAB brPrevisao btExit fpage0 */
ASSIGN 
       brPrevisao:POPUP-MENU IN FRAME fpage0             = MENU pmn-brPrevisao:HANDLE
       brPrevisao:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brPrevisao:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPrevisao
/* Query rebuild information for BROWSE brPrevisao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-previsao.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brPrevisao */
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


&Scoped-define BROWSE-NAME brPrevisao
&Scoped-define SELF-NAME brPrevisao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPrevisao wWindow
ON START-SEARCH OF brPrevisao IN FRAME fpage0
DO:
    MESSAGE SELF:CURRENT-COLUMN:WIDTH
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*     IF SELF:CURRENT-COLUMN:TABLE  = "tt-previsao":U AND                                                                                        */
/*        SELF:CURRENT-COLUMN:NAME  <> ?               AND                                                                                        */
/*        SELF:CURRENT-COLUMN:NAME  <> "":U            THEN DO:                                                                                   */
/*         IF cCampoSearch = SELF:CURRENT-COLUMN:NAME THEN DO:                                                                                    */
/*             ASSIGN lDesc = NOT lDesc.                                                                                                          */
/*                                                                                                                                                */
/*             IF lDesc THEN                                                                                                                      */
/*                 ASSIGN cQuery = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " DESC INDEXED-REPOSITION":U. */
/*             ELSE                                                                                                                               */
/*                 ASSIGN cQuery = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U.      */
/*         END.                                                                                                                                   */
/*         ELSE                                                                                                                                   */
/*             ASSIGN cQuery       = "FOR EACH tt-previsao OUTER-JOIN BY tt-previsao.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U     */
/*                    cCampoSearch = SELF:CURRENT-COLUMN:NAME                                                                                     */
/*                    lDesc        = NO.                                                                                                          */
/*                                                                                                                                                */
/*         SELF:QUERY:QUERY-PREPARE(cQuery).                                                                                                      */
/*         SELF:QUERY:QUERY-OPEN().                                                                                                               */
/*     END.                                                                                                                                       */
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


&Scoped-define SELF-NAME btFil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFil wWindow
ON CHOOSE OF btFil IN FRAME fpage0 /* Filtrar */
DO:
    EMPTY TEMP-TABLE tt-previsao.

    {&OPEN-QUERY-brPrevisao}

    ASSIGN INPUT FRAME fpage0 vCodEstabel
                              vCodPeriodoIni
                              vCodPeriodoFin
                              vCodUnidNegoc.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = vCodEstabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Estabelecimento informado nÆo cadastrado.":U).

        RETURN NO-APPLY.
    END.

    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = vCodUnidNegoc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE unid-negoc THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Unidade de Neg¢cio informada nÆo cadastrada.":U).

        RETURN NO-APPLY.
    END.

    IF vCodPeriodoIni = "":U OR
       vCodPeriodoFin = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per¡odo inv lido.":U).

        RETURN NO-APPLY.
    END.

    IF vCodPeriodoIni > vCodPeriodoFin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per¡odo inv lido.":U +
                                 "~~":U +
                                 "O per¡odo inicial deve ser igual ou inferior ao per¡odo final.":U).

        RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Gerando previsäes...":U).

    RUN piPrevisaoVenda IN THIS-PROCEDURE.
    RUN piFaturamento IN THIS-PROCEDURE.
    RUN piPedido IN THIS-PROCEDURE.
    RUN piPlanoMestre IN THIS-PROCEDURE.
    RUN piProducao IN THIS-PROCEDURE.

    {&OPEN-QUERY-brPrevisao}

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

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


&Scoped-define SELF-NAME miMoverColuna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMoverColuna wWindow
ON VALUE-CHANGED OF MENU-ITEM miMoverColuna /* Mover Coluna? */
DO:
    ASSIGN brPrevisao:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = NOT MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-brPrevisao
           brPrevisao:COLUMN-MOVABLE         IN FRAME fpage0 = MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-brPrevisao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vCodUnidNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vCodUnidNegoc wWindow
ON F5 OF vCodUnidNegoc IN FRAME fpage0 /* Unid Neg¢cio */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="vCodUnidNegoc"
                         &Frame1="fpage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vCodUnidNegoc wWindow
ON MOUSE-SELECT-DBLCLICK OF vCodUnidNegoc IN FRAME fpage0 /* Unid Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF vCodUnidNegoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0 THEN.

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
    ASSIGN vCodEstabel    = "101":U
           vCodUnidNegoc  = "SEC":U
           vCodPeriodoIni = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 7), "99":U)
           vCodPeriodoFin = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 1), "99":U).

    DISPLAY vCodEstabel
            vCodPeriodoIni
            vCodPeriodoFin
            vCodUnidNegoc
        WITH FRAME fpage0.

    DISABLE vCodEstabel
        WITH FRAME fpage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFaturamento wWindow 
PROCEDURE piFaturamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Faturamento...":U).

    ASSIGN dtIni = DATE(INTEGER(TRIM(SUBSTRING(vCodPeriodoIni, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(vCodPeriodoIni, 1, 4))))
           dtFin = DATE(INTEGER(TRIM(SUBSTRING(vCodPeriodoFin, 5, 2))), 25, INTEGER(TRIM(SUBSTRING(vCodPeriodoFin, 1, 4))))
           dtFin = dtFin + 15.
           dtFin = dtFin - DAY(dtFin).

    DO dtAux = dtIni TO dtFin:
        FOR EACH nota-fiscal NO-LOCK
            WHERE nota-fiscal.dt-emis-nota = dtAux:

            IF nota-fiscal.dt-cancela = ? THEN DO:
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "NF: ":U + TRIM(nota-fiscal.nr-nota-fis) + "/":U + TRIM(nota-fiscal.serie) + "-Emis.: ":U + TRIM(STRING(nota-fiscal.dt-emis-nota, "99/99/99":U))).

                FIND FIRST natur-oper
                    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

                IF AVAILABLE natur-oper   AND
                   natur-oper.atual-estat THEN DO: /* Foi realizado mesmo tratamento do BI. Informa‡Æo obtida com Claudiney */

                    ASSIGN vCodPeriodo = STRING(YEAR(nota-fiscal.dt-emis), "9999":U) + STRING(MONTH(nota-fiscal.dt-emis), "99":U).

                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                        FOR EACH tt-previsao
                            WHERE tt-previsao.cod-estabel          = vCodEstabel
                              AND tt-previsao.it-codigo            = it-nota-fisc.it-codigo
                              AND tt-previsao.cod-periodo-previsao = vCodPeriodo:
                            ASSIGN tt-previsao.qtd-faturado = tt-previsao.qtd-faturado + it-nota-fisc.qt-faturada[1].

                            FIND FIRST ped-venda
                                WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                  AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.

                            IF AVAILABLE ped-venda                                      AND
                               YEAR(ped-venda.dt-implant)  = YEAR(nota-fiscal.dt-emis)  AND
                               MONTH(ped-venda.dt-implant) = MONTH(nota-fiscal.dt-emis) THEN
                                ASSIGN tt-previsao.qtd-faturado-mes = tt-previsao.qtd-faturado-mes + it-nota-fisc.qt-faturada[1].

                            /* Descontar Devolu‡äes */
                            FOR EACH devol-cli NO-LOCK
                                WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                                  AND devol-cli.serie        = nota-fiscal.serie
                                  AND devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                                  AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat
                                  AND devol-cli.it-codigo    = it-nota-fisc.it-codigo:
                                ASSIGN tt-previsao.qtd-faturado = tt-previsao.qtd-faturado - devol-cli.qt-devolvida.

                                IF AVAILABLE ped-venda                                      AND
                                   YEAR(ped-venda.dt-implant)  = YEAR(nota-fiscal.dt-emis)  AND
                                   MONTH(ped-venda.dt-implant) = MONTH(nota-fiscal.dt-emis) THEN
                                    ASSIGN tt-previsao.qtd-faturado-mes = tt-previsao.qtd-faturado-mes - devol-cli.qt-devolvida.
                            END. /* FOR EACH devol-cli NO-LOCK */
                        END. /* IF AVAILABLE tt-previsao THEN DO: */
                    END. /* FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK: */
                END. /* IF AVAILABLE natur-oper   AND
                           natur-oper.atual-estat THEN DO: */
            END. /* IF nota-fiscal.dt-cancela = ? THEN DO: */
        END. /* FOR EACH nota-fiscal NO-LOCK */
    END. /* DO dtAux = dtIni TO dtFin: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedido wWindow 
PROCEDURE piPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Pedido...":U).

    FOR EACH tt-previsao:
        ASSIGN dtIni = DATE(INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 1, 4))))
               dtFin = DATE(INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 5, 2))), 25, INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 1, 4)))) + 15
               dtFin = dtFin - DAY(dtFin).

        FOR EACH ped-item NO-LOCK
            WHERE ped-item.it-codigo    = tt-previsao.it-codigo
              AND ped-item.cod-sit-item < 5: /* NÆo cancelados ou suspensos */
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + TRIM(ped-item.it-codigo) + " - Prev.: ":U + TRIM(STRING(tt-previsao.cod-periodo-previsao, "9999/99":U))).

            IF ped-item.dt-entorig >= dtIni AND
               ped-item.dt-entorig <= dtFin THEN
                ASSIGN tt-previsao.qtd-pedido = tt-previsao.qtd-pedido + ped-item.qt-pedida.
        END. /* FOR EACH ped-item NO-LOCK */
    END. /* FOR EACH tt-previsao: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPlanoMestre wWindow 
PROCEDURE piPlanoMestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Plano Mestre...":U).

    FOR EACH int-coesa-prev-prod NO-LOCK
        WHERE int-coesa-prev-prod.cod-estabel           = vCodEstabel
          AND int-coesa-prev-prod.cod-periodo-previsao >= vCodPeriodoIni
          AND int-coesa-prev-prod.cod-periodo-previsao <= vCodPeriodoFin:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + TRIM(int-coesa-prev-prod.it-codigo) + " /Per.: ":U + TRIM(STRING(int-coesa-prev-prod.cod-periodo-previsao, "9999/99":U)) + " /Ver.: ":U + TRIM(STRING(int-coesa-prev-prod.dat-reg-previsao, "99/99/99":U))).

        FIND FIRST tt-previsao
            WHERE tt-previsao.cod-estabel          = int-coesa-prev-prod.cod-estabel
              AND tt-previsao.it-codigo            = int-coesa-prev-prod.it-codigo
              AND tt-previsao.cod-periodo-previsao = int-coesa-prev-prod.cod-periodo-previsao
              AND tt-previsao.dat-reg-previsao     = int-coesa-prev-prod.dat-reg-previsao NO-ERROR.

        IF NOT AVAILABLE tt-previsao THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = int-coesa-prev-prod.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item THEN
                NEXT.

            FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo   = item.it-codigo
                  AND item-uni-estab.cod-estabel = int-coesa-prev-prod.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item-uni-estab                   OR
               item-uni-estab.cod-unid-negoc <> vCodUnidNegoc THEN
                NEXT.

            FIND FIRST grup-estoque
                WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.

            FIND LAST int-coesa-estoq-segur USE-INDEX id-estoq-quant
                WHERE int-coesa-estoq-segur.cod-estabel   = item-uni-estab.cod-estabel
                  AND int-coesa-estoq-segur.it-codigo     = item-uni-estab.it-codigo
                  AND int-coesa-estoq-segur.dat-registro <= DATE(INTEGER(TRIM(SUBSTRING(int-coesa-prev-venda.cod-periodo-previsao, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(int-coesa-prev-venda.cod-periodo-previsao, 1, 4)))) NO-LOCK NO-ERROR.

            CREATE tt-previsao.
            ASSIGN tt-previsao.cod-estabel          = int-coesa-prev-prod.cod-estabel
                   tt-previsao.it-codigo            = int-coesa-prev-prod.it-codigo
                   tt-previsao.desc-item            = item.desc-item
                   tt-previsao.cod-periodo-previsao = int-coesa-prev-prod.cod-periodo-previsao
                   tt-previsao.dat-reg-previsao     = int-coesa-prev-prod.dat-reg-previsao
                   tt-previsao.cod-unid-negoc       = item-uni-estab.cod-unid-negoc
                   tt-previsao.fm-cod-com           = item.fm-cod-com
                   tt-previsao.ge-codigo            = item.ge-codigo
                   tt-previsao.desc-ge              = IF AVAILABLE grup-estoque THEN grup-estoque.descricao ELSE "":U
                   tt-previsao.quant-segur          = IF AVAILABLE int-coesa-estoq-segur THEN int-coesa-estoq-segur.quant-segur ELSE item-uni-estab.quant-segur.

            FIND FIRST movto-estoq
                WHERE movto-estoq.esp-docto = 1 /* ACA */
                  AND movto-estoq.it-codigo = int-coesa-prev-venda.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-previsao.dt-prim-movto-prod = IF AVAILABLE movto-estoq THEN movto-estoq.dt-trans ELSE ?.

            FIND FIRST movto-estoq
                WHERE movto-estoq.esp-docto = 22 /* NFS */
                  AND movto-estoq.it-codigo = int-coesa-prev-venda.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-previsao.dt-prim-saida = IF AVAILABLE movto-estoq THEN movto-estoq.dt-trans ELSE ?.
        END.

        ASSIGN tt-previsao.qtd-planejado = tt-previsao.qtd-planejado + int-coesa-prev-prod.qtd-prevista.
    END. /* FOR EACH int-coesa-prev-prod NO-LOCK */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrevisaoVenda wWindow 
PROCEDURE piPrevisaoVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "PrevisÆo Venda...":U).

    FOR EACH int-coesa-prev-venda NO-LOCK
        WHERE int-coesa-prev-venda.cod-estabel           = vCodEstabel
          AND int-coesa-prev-venda.cod-periodo-previsao >= vCodPeriodoIni
          AND int-coesa-prev-venda.cod-periodo-previsao <= vCodPeriodoFin:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + TRIM(int-coesa-prev-venda.it-codigo) + "/Per.: ":U + TRIM(STRING(int-coesa-prev-venda.cod-periodo-previsao, "9999/99":U)) + "/Ver.: ":U + TRIM(STRING(int-coesa-prev-venda.dat-reg-previsao, "99/99/99":U))).

        FIND FIRST tt-previsao
            WHERE tt-previsao.cod-estabel          = int-coesa-prev-venda.cod-estabel
              AND tt-previsao.it-codigo            = int-coesa-prev-venda.it-codigo
              AND tt-previsao.cod-periodo-previsao = int-coesa-prev-venda.cod-periodo-previsao
              AND tt-previsao.dat-reg-previsao     = int-coesa-prev-venda.dat-reg-previsao NO-ERROR.

        IF NOT AVAILABLE tt-previsao THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = int-coesa-prev-venda.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item THEN
                NEXT.

            FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo   = item.it-codigo
                  AND item-uni-estab.cod-estabel = int-coesa-prev-venda.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item-uni-estab                   OR
               item-uni-estab.cod-unid-negoc <> vCodUnidNegoc THEN
                NEXT.

            FIND FIRST grup-estoque
                WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.

            FIND LAST int-coesa-estoq-segur USE-INDEX id-estoq-quant
                WHERE int-coesa-estoq-segur.cod-estabel   = item-uni-estab.cod-estabel
                  AND int-coesa-estoq-segur.it-codigo     = item-uni-estab.it-codigo
                  AND int-coesa-estoq-segur.dat-registro <= DATE(INTEGER(TRIM(SUBSTRING(int-coesa-prev-venda.cod-periodo-previsao, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(int-coesa-prev-venda.cod-periodo-previsao, 1, 4)))) NO-LOCK NO-ERROR.

            CREATE tt-previsao.
            ASSIGN tt-previsao.cod-estabel          = int-coesa-prev-venda.cod-estabel
                   tt-previsao.it-codigo            = int-coesa-prev-venda.it-codigo
                   tt-previsao.desc-item            = item.desc-item
                   tt-previsao.cod-periodo-previsao = int-coesa-prev-venda.cod-periodo-previsao
                   tt-previsao.dat-reg-previsao     = int-coesa-prev-venda.dat-reg-previsao
                   tt-previsao.cod-unid-negoc       = item-uni-estab.cod-unid-negoc
                   tt-previsao.fm-cod-com           = item.fm-cod-com
                   tt-previsao.ge-codigo            = item.ge-codigo
                   tt-previsao.desc-ge              = IF AVAILABLE grup-estoque THEN grup-estoque.descricao ELSE "":U
                   tt-previsao.quant-segur          = IF AVAILABLE int-coesa-estoq-segur THEN int-coesa-estoq-segur.quant-segur ELSE item-uni-estab.quant-segur.

            FIND FIRST movto-estoq
                WHERE movto-estoq.esp-docto = 1 /* ACA */
                  AND movto-estoq.it-codigo = int-coesa-prev-venda.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-previsao.dt-prim-movto-prod = IF AVAILABLE movto-estoq THEN movto-estoq.dt-trans ELSE ?.

            FIND FIRST movto-estoq
                WHERE movto-estoq.esp-docto = 22 /* NFS */
                  AND movto-estoq.it-codigo = int-coesa-prev-venda.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-previsao.dt-prim-saida = IF AVAILABLE movto-estoq THEN movto-estoq.dt-trans ELSE ?.
        END. /* IF NOT AVAILABLE tt-previsao THEN DO: */

        ASSIGN tt-previsao.qtd-prev-venda = tt-previsao.qtd-prev-venda + int-coesa-prev-venda.qtd-prevista.
    END. /* FOR EACH int-coesa-prev-venda NO-LOCK */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProducao wWindow 
PROCEDURE piProducao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Produ‡Æo...":U).

    FOR EACH tt-previsao:
        FIND LAST int-coesa-prev-venda
            WHERE int-coesa-prev-venda.cod-estabel           = tt-previsao.cod-estabel
              AND int-coesa-prev-venda.it-codigo             = tt-previsao.it-codigo
              AND int-coesa-prev-venda.cod-periodo-previsao  = tt-previsao.cod-periodo-previsao NO-LOCK NO-ERROR.

        IF AVAILABLE int-coesa-prev-venda THEN
            ASSIGN tt-previsao.qtd-produzido = int-coesa-prev-venda.qtd-prevista.

        ASSIGN dtIni = DATE(INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 1, 4))))
               dtFin = DATE(INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 5, 2))), 25, INTEGER(TRIM(SUBSTRING(tt-previsao.cod-periodo-previsao, 1, 4))))
               dtFin = dtFin + 15.
               dtFin = dtFin - DAY(dtFin).

        DO dtAux = dtIni TO dtFin:
            FOR EACH movto-estoq FIELDS(dt-trans it-codigo esp-docto nr-ord-produ cod-estabel tipo-trans quantidade) USE-INDEX data-item NO-LOCK
                WHERE  movto-estoq.dt-trans      = dtAux
                  AND  movto-estoq.it-codigo     = tt-previsao.it-codigo
                  AND  movto-estoq.nr-ord-produ <> 0
                  AND (movto-estoq.esp-docto     = 1   /* ACA - Acabados */
                   OR  movto-estoq.esp-docto     = 8): /* EAC - Estorno Acabados */

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Movto Estoq - Item: ":U + TRIM(movto-estoq.it-codigo) + " - Trans.: ":U + TRIM(STRING(movto-estoq.dt-trans, "99/99/99":U))).

                IF movto-estoq.esp-docto = 1 THEN
                    ASSIGN tt-previsao.qtd-produzido = tt-previsao.qtd-produzido + movto-estoq.quantidade.
                ELSE
                    ASSIGN tt-previsao.qtd-produzido = tt-previsao.qtd-produzido - movto-estoq.quantidade.
            END. /* FOR EACH movto-estoq FIELDS(dt-trans it-codigo esp-docto nr-ord-produ cod-estabel tipo-trans quantidade) USE-INDEX data-item NO-LOCK */
        END. /* DO dtAux = dtIni TO dtFin: */
    END. /* FOR EACH tt-previsao: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

