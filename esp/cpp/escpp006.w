&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR i-contadorIni  AS INT NO-UNDO.
DEF VAR c-descTraduc   AS CHAR EXTENT 2 NO-UNDO.
DEF VAR i-posicao      AS INT NO-UNDO.

DEF BUFFER b-traduc-item FOR traduc-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES traduc-item linha-item ITEM

/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem traduc-item.it-codigo traduc-item.tr-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem   
&Scoped-define SELF-NAME brItem
&Scoped-define QUERY-STRING-brItem FOR EACH traduc-item WHERE traduc-item.it-codigo BEGINS INPUT FRAME fpage2 fiIniciaisItem                                          AND traduc-item.cod-idioma = INPUT FRAME fpage2 cbIdioma, ~
                             EACH linha-item WHERE linha-item.it-codigo = traduc-item.it-codigo                                         AND linha-item.nr-linha = INPUT FRAME fpage2 fiLinhaProducao, ~
                             EACH ITEM WHERE ITEM.it-codigo = linha-item.it-codigo                                   AND ITEM.cod-obsoleto = 1 NO-LOCK BY traduc-item.it-codigo
&Scoped-define OPEN-QUERY-brItem OPEN QUERY brItem FOR EACH traduc-item WHERE traduc-item.it-codigo BEGINS INPUT FRAME fpage2 fiIniciaisItem                                          AND traduc-item.cod-idioma = INPUT FRAME fpage2 cbIdioma, ~
                             EACH linha-item WHERE linha-item.it-codigo = traduc-item.it-codigo                                         AND linha-item.nr-linha = INPUT FRAME fpage2 fiLinhaProducao, ~
                             EACH ITEM WHERE ITEM.it-codigo = linha-item.it-codigo                                   AND ITEM.cod-obsoleto = 1 NO-LOCK BY traduc-item.it-codigo.
&Scoped-define TABLES-IN-QUERY-brItem traduc-item linha-item ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-brItem traduc-item
&Scoped-define SECOND-TABLE-IN-QUERY-brItem linha-item
&Scoped-define THIRD-TABLE-IN-QUERY-brItem ITEM


/* Definitions for BROWSE brTrilingue                                   */
&Scoped-define FIELDS-IN-QUERY-brTrilingue traduc-item.it-codigo traduc-item.cod-idioma traduc-item.tr-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTrilingue   
&Scoped-define SELF-NAME brTrilingue
&Scoped-define QUERY-STRING-brTrilingue FOR EACH traduc-item WHERE traduc-item.it-codigo                                            BEGINS INPUT FRAME fpage3 fiIniciaisItemTri                                               AND traduc-item.cod-idioma BEGINS "POR"                                             NO-LOCK
&Scoped-define OPEN-QUERY-brTrilingue OPEN QUERY brTrilingue FOR EACH traduc-item WHERE traduc-item.it-codigo                                            BEGINS INPUT FRAME fpage3 fiIniciaisItemTri                                               AND traduc-item.cod-idioma BEGINS "POR"                                             NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTrilingue traduc-item
&Scoped-define FIRST-TABLE-IN-QUERY-brTrilingue traduc-item


/* Definitions for FRAME fpage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage2 ~
    ~{&OPEN-QUERY-brItem}

/* Definitions for FRAME fpage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage3 ~
    ~{&OPEN-QUERY-brTrilingue}
&Scoped-define QUERY-STRING-fpage3 FOR EACH item SHARE-LOCK
&Scoped-define OPEN-QUERY-fpage3 OPEN QUERY fpage3 FOR EACH item SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fpage3 item
&Scoped-define FIRST-TABLE-IN-QUERY-fpage3 item


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar btExit btHelp rs-opcao 
&Scoped-Define DISPLAYED-OBJECTS rs-opcao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Arquivo 
       MENU-ITEM miExit         LABEL "&Sair"         .

DEFINE MENU MbMain MENUBAR
       SUB-MENU  m_Arquivo      LABEL "&Arquivo"      
       MENU-ITEM m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Teste", 1,
"Item", 2
     SIZE 89.72 BY 1
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25
     BGCOLOR 15 .

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btImprimeTeste 
     LABEL "Imprime" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fiNrEtiqTeste AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Nr de Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrNaEtiqueta AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Nr na Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE BUTTON btConfirmParam2 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-chck1.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btImprimeItem 
     LABEL "Imprime" 
     SIZE 15 BY 1.17.

DEFINE VARIABLE cbIdioma AS CHARACTER FORMAT "X(256)":U INITIAL "Espanhol" 
     LABEL "Idioma" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Portuguˆs","Espanhol","Inglˆs" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiIniciaisItem AS CHARACTER FORMAT "X(9)":U 
     LABEL "Iniciais do Item" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiLinhaProducao AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Linha de Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrEtiqItem AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Nr de Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 9.75.

DEFINE BUTTON btConfirmParamTri 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btImprimeTrilingue 
     LABEL "Imprime" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fiIniciaisItemTri AS CHARACTER FORMAT "X(7)":U 
     LABEL "Iniciais do Item" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiNrEtiqTrilingue AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Nr de Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.75.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 10.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItem FOR 
      traduc-item, 
      linha-item, 
      ITEM SCROLLING.

DEFINE QUERY brTrilingue FOR 
      traduc-item SCROLLING.

DEFINE QUERY fpage3 FOR 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem C-Win _FREEFORM
  QUERY brItem DISPLAY
      traduc-item.it-codigo FORMAT "x(9)"
traduc-item.tr-desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 8.5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brTrilingue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTrilingue C-Win _FREEFORM
  QUERY brTrilingue DISPLAY
      traduc-item.it-codigo   FORMAT "x(9)"
 traduc-item.cod-idioma  FORMAT "x(16)"
 traduc-item.tr-desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 9.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExit AT ROW 1.17 COL 82 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86 HELP
          "Ajuda"
     rs-opcao AT ROW 2.92 COL 1.29 NO-LABEL
     RECT-1 AT ROW 2.79 COL 1
     rtToolBar AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 15.83
         FONT 1.

DEFINE FRAME fpage3
     fiIniciaisItemTri AT ROW 1.5 COL 39 COLON-ALIGNED
     btConfirmParamTri AT ROW 1.25 COL 51
     brTrilingue AT ROW 2.75 COL 1
     fiNrEtiqTrilingue AT ROW 12.42 COL 59 COLON-ALIGNED
     btImprimeTrilingue AT ROW 12.25 COL 76
     RECT-20 AT ROW 1 COL 1
     RECT-21 AT ROW 2.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.25
         SIZE 90 BY 12.5
         FONT 1.

DEFINE FRAME fpage1
     fiNrNaEtiqueta AT ROW 5 COL 29 COLON-ALIGNED
     fiNrEtiqTeste AT ROW 6 COL 29 COLON-ALIGNED
     btImprimeTeste AT ROW 7.5 COL 31
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.25
         SIZE 90 BY 12.25
         FONT 1.

DEFINE FRAME fpage2
     fiIniciaisItem AT ROW 1.5 COL 27 COLON-ALIGNED
     fiLinhaProducao AT ROW 2.5 COL 27 COLON-ALIGNED
     cbIdioma AT ROW 1.5 COL 52 COLON-ALIGNED
     btConfirmParam2 AT ROW 1.25 COL 71
     brItem AT ROW 3.75 COL 1
     fiNrEtiqItem AT ROW 12.42 COL 59 COLON-ALIGNED
     btImprimeItem AT ROW 12.25 COL 76
     RECT-18 AT ROW 1 COL 1
     RECT-19 AT ROW 3.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.25
         SIZE 90 BY 12.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ESCPP006.W - 2.04.000 - ImpressÆo de Etiquetas para Placas"
         HEIGHT             = 15.83
         WIDTH              = 90.57
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
         MAX-BUTTON         = no
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME fpage1:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME fpage2:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME fpage3:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fpage1
                                                                        */
/* SETTINGS FOR FRAME fpage2
   Custom                                                               */
/* BROWSE-TAB brItem btConfirmParam2 fpage2 */
/* SETTINGS FOR FRAME fpage3
   Custom                                                               */
/* BROWSE-TAB brTrilingue btConfirmParamTri fpage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _START_FREEFORM
OPEN QUERY brItem FOR EACH traduc-item WHERE traduc-item.it-codigo BEGINS INPUT FRAME fpage2 fiIniciaisItem
                                         AND traduc-item.cod-idioma = INPUT FRAME fpage2 cbIdioma,
                      EACH linha-item WHERE linha-item.it-codigo = traduc-item.it-codigo
                                        AND linha-item.nr-linha = INPUT FRAME fpage2 fiLinhaProducao,
                      EACH ITEM WHERE ITEM.it-codigo = linha-item.it-codigo
                                  AND ITEM.cod-obsoleto = 1 NO-LOCK BY traduc-item.it-codigo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTrilingue
/* Query rebuild information for BROWSE brTrilingue
     _START_FREEFORM
OPEN QUERY brTrilingue FOR EACH traduc-item WHERE traduc-item.it-codigo
                                           BEGINS INPUT FRAME fpage3 fiIniciaisItemTri
                                              AND traduc-item.cod-idioma BEGINS "POR"
                                            NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brTrilingue */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _TblList          = "mgcad.item"
     _Query            is OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ESCPP006.W - 2.04.000 - ImpressÆo de Etiquetas para Placas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESCPP006.W - 2.04.000 - ImpressÆo de Etiquetas para Placas */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btConfirmParam2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirmParam2 C-Win
ON CHOOSE OF btConfirmParam2 IN FRAME fpage2 /* Button 4 */
DO:
    {&OPEN-query-brItem} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btConfirmParamTri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirmParamTri C-Win
ON CHOOSE OF btConfirmParamTri IN FRAME fpage3
DO:
    {&OPEN-query-brTrilingue} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btImprimeItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimeItem C-Win
ON CHOOSE OF btImprimeItem IN FRAME fpage2 /* Imprime */
DO:
    IF NOT AVAIL ITEM THEN DO:
        MESSAGE "NÆo h  item selecionado." VIEW-AS ALERT-BOX.
        APPLY "entry" TO fiIniciaisItem IN FRAME fpage2.
        RETURN NO-APPLY.
    END.
    FIND traduc-item WHERE traduc-item.it-codigo  = ITEM.it-codigo
                       AND traduc-item.cod-idioma = INPUT FRAME fpage2 cbIdioma
                     NO-LOCK NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        MESSAGE "NÆo existe descri‡Æo para este item no idioma "  INPUT FRAME fpage2 cbIdioma
                VIEW-AS ALERT-BOX.
        APPLY "entry" TO cbIdioma IN FRAME fpage2.
        RETURN NO-APPLY.
    END.
    IF INPUT FRAME fpage2 fiNrEtiqItem = 0 THEN DO:
        MESSAGE "NÆo h  n£mero de etiquetas a imprimir!" VIEW-AS ALERT-BOX.
        APPLY "entry" TO fiNrEtiqItem IN FRAME fpage2.
        RETURN NO-APPLY.
    END.
    IF LENGTH(TRIM(traduc-item.tr-desc-item)) > 20 THEN DO:
        ASSIGN i-posicao = round((LENGTH(TRIM(traduc-item.tr-desc-item)) / 2),0).
        DO WHILE TRUE:
           IF SUBSTRING(traduc-item.tr-desc-item,i-posicao,1) = " " OR i-posicao > 20 THEN
              LEAVE.
           ELSE 
              ASSIGN i-posicao = i-posicao + 1.
        END.
        IF i-posicao > 20 THEN DO:
           ASSIGN i-posicao = round((LENGTH(TRIM(traduc-item.tr-desc-item)) / 2),0).
           DO WHILE TRUE:
              IF SUBSTRING(traduc-item.tr-desc-item,i-posicao,1) = " " THEN
                 LEAVE.
              ELSE 
                 ASSIGN i-posicao = i-posicao - 1.
           END.
        END.
        ASSIGN c-descTraduc[1] = SUBSTRING(traduc-item.tr-desc-item,1,i-posicao)
               c-descTraduc[2] = SUBSTRING(traduc-item.tr-desc-item,(i-posicao + 1)).
    END.
    OUTPUT TO PRINTER.
    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */

         "^PW832"      SKIP   /* Novo comando para zebra 600 */
         "^JUS"        SKIP   /* Novo comando para zebra 600 */

         "^PON"        SKIP   /* Orientacao impressora N = Normal */
         "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
         "^LL296"      SKIP   /* 824 ‚ o numero de Dotïs que formam nr colunas da etiqueta */
         "^PQ" STRING(INPUT FRAME fpage2 fiNrEtiqItem, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
         "^MNY"        SKIP   /* Papel de etiquetas cont¡nuo */

        "^FO88,16^A0N,24,24^FD" ITEM.it-codigo /* Imprime c¢digo do item */
                                 "^FS" SKIP.

    IF LENGTH(TRIM(traduc-item.tr-desc-item)) <= 20 THEN 
       PUT UNFORMATTED
           "^FO32,40^A0N,30,30^FD" traduc-item.tr-desc-item
                                   "^FS" SKIP. /* Descri‡Æo no idioma escolhido */

    ELSE 
       PUT UNFORMATTED
           "^FO32,40^A0N,24,24^FD" c-descTraduc[1] 
                                   "^FS" SKIP /* Descri‡Æo no idioma escolhido Parte 1 */

           "^FO32,60^A0N,24,24^FD" c-descTraduc[2] 
                                   "^FS" SKIP. /* Descri‡Æo no idioma escolhido Parte 2 */
    PUT UNFORMATTED
        "^XZ".
    OUTPUT CLOSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimeItem C-Win
ON TAB OF btImprimeItem IN FRAME fpage2 /* Imprime */
DO:
  APPLY "entry" TO fiNrEtiqItem IN FRAME fPage2.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME btImprimeTeste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimeTeste C-Win
ON CHOOSE OF btImprimeTeste IN FRAME fpage1 /* Imprime */
DO:
    OUTPUT TO PRINTER.
    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */
         "^PON"        SKIP   /* Orientacao impressora N = Normal */
         "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
         "^LL296"      SKIP   /* 824 ‚ o numero de Dotïs que formam nr colunas da etiqueta */
         "^PQ" STRING(INPUT FRAME fpage1 fiNrEtiqTeste, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
         "^MNY"        SKIP   /* Papel de etiquetas cont¡nuo */

         "^FO24,16^A0N,32,32^FDC.Q. TESTE FINAL^FS" SKIP /* Imprime "TESTE FINAL" */
         
         "^FO128,48^A0N,40,60^FD" STRING(INPUT FRAME fpage1 fiNrNaEtiqueta,"99") 
                                 "^FS" /* Imprime o numero de controle na etiqueta */
        
         "^XZ".
    OUTPUT CLOSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btImprimeTrilingue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimeTrilingue C-Win
ON CHOOSE OF btImprimeTrilingue IN FRAME fpage3 /* Imprime */
DO:
  FIND item-mat OF traduc-item NO-LOCK NO-ERROR.
  IF NOT AVAIL item-mat THEN DO:
      MESSAGE "Este item nÆo possui codigo EAN cadastrado. Verifique!" VIEW-AS ALERT-BOX.
      APPLY "entry" TO fiNrEtiqTrilingue IN FRAME fpage3.
      RETURN NO-APPLY.
  END.

  IF INPUT FRAME fpage3 fiNrEtiqTrilingue = 0 THEN DO:
      MESSAGE "NÆo h  n£mero de etiquetas a imprimir!" VIEW-AS ALERT-BOX.
      APPLY "entry" TO fiNrEtiqTrilingue IN FRAME fpage3.
      RETURN NO-APPLY.
  END.

  ASSIGN INPUT FRAME fpage3 fiNrEtiqTrilingue.

  FIND FIRST ns-contador WHERE ns-contador.codigo-contador = 3 NO-ERROR.
  IF NOT AVAIL ns-contador THEN DO:
     CREATE ns-contador.
     ASSIGN ns-contador.codigo-contador = 3.
  END.
  ASSIGN i-contadorIni = ns-contador.valor-contador + 1
         ns-contador.valor-contador = ns-contador.valor-contador + fiNrEtiqTrilingue.

  OUTPUT TO PRINTER.
  PUT UNFORMATTED
       "^XA"         SKIP   /* Inicio Label */
       "^PON"        SKIP   /* Orientacao impressora N = Normal */
       "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
       "^LL296"      SKIP   /* 824 ‚ o numero de Dotïs que formam nr colunas da etiqueta */
       "^PQ" STRING(fiNrEtiqTrilingue, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
       "^MNY"        SKIP   /* Papel de etiquetas cont¡nuo */

       "^FO56,20^BY2^BEN,106,Y,N^FD" item-mat.cod-ean      
                                    "^FS" 
                                    SKIP       /* Codigo de Barras EAN 13 */

/*      "^FO456,50^BY1,3.0^BCN,24,N,N,N,N^SN" STRING(i-contadorIni,"99999999")
                               ",1,Y^FS" SKIP /* Imprime EAN 128 do nr sequencial da etiqueta */

      "^FO476,80^A0N,16,16^SN" STRING(i-contadorIni,"99999999")
                               ",1,Y^FS" SKIP /* Imprime nr sequencial da etiqueta */
*/
      "^FO292,80^A0N,32,32^FD" item-mat.it-codigo /* Imprime c¢digo do item */
                               "^FS" SKIP.

  FOR EACH b-traduc-item WHERE b-traduc-item.it-codigo = traduc-item.it-codigo:
      IF b-traduc-item.cod-idioma BEGINS "Por" THEN
         PUT UNFORMATTED 
             "^FO32,148^A0N,20,24^FD" b-traduc-item.tr-desc-item 
                                      "^FS" SKIP. /* Descri‡Æo em Portuguˆs */
      
      IF b-traduc-item.cod-idioma BEGINS "Esp" THEN
         PUT UNFORMATTED 
             "^FO32,168^A0N,20,24^FD" b-traduc-item.tr-desc-item 
                                      "^FS" SKIP. /* Descri‡Æo em Espanhol */
      
      IF b-traduc-item.cod-idioma BEGINS "Ing" THEN
         PUT UNFORMATTED 
             "^FO32,188^A0N,20,24^FD" b-traduc-item.tr-desc-item 
                                      "^FS" SKIP. /* Descri‡Æo em Inglˆs */

  END.
  PUT UNFORMATTED "^XZ".
  OUTPUT CLOSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimeTrilingue C-Win
ON TAB OF btImprimeTrilingue IN FRAME fpage3 /* Imprime */
DO:
  APPLY "entry" TO fiNrEtiqTrilingue IN FRAME fpage3.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao C-Win
ON VALUE-CHANGED OF rs-opcao IN FRAME DEFAULT-FRAME
DO:
    CASE INPUT FRAME {&FRAME-NAME} rs-opcao:
        WHEN 1 THEN DO:
            HIDE FRAME fpage3.
            HIDE FRAME fpage2.
            VIEW FRAME fpage1.
            APPLY "entry" TO fiNrNaEtiqueta IN FRAME fpage1.
        END.
        WHEN 2 THEN DO:
            HIDE FRAME fpage3.
            HIDE FRAME fpage1.
            VIEW FRAME fpage2.
            APPLY "entry" TO fiIniciaisItem IN FRAME fpage2. 
        END.
        WHEN 3 THEN DO:
            HIDE FRAME fpage1.
            HIDE FRAME fpage2.
            VIEW FRAME fpage3.
            APPLY "entry" TO fiIniciaisItemTri IN FRAME fpage3.

        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

HIDE FRAME fpage4.
HIDE FRAME fpage3.
HIDE FRAME fpage2.
VIEW FRAME fpage1.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/*
ON 'TAB':U OF c-desc IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN.
END.

ON 'TAB':U OF br-item IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = ""
           quantidade:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN NO-APPLY.
END.

ON 'TAB':U OF br-celula IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = ""
           quantidade:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN NO-APPLY.
END.

ON 'TAB':U OF quantidade IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = ""
           quantidade:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN NO-APPLY.
END.

ON 'TAB':U OF btimprime IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = ""
           quantidade:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN NO-APPLY.
END.

ON ENTRY OF c-desc IN FRAME fpage3
DO:
    ASSIGN c-desc:SCREEN-VALUE = ""
           quantidade:SCREEN-VALUE = "".
    APPLY "entry" TO c-desc IN FRAME fpage3.
    RETURN NO-APPLY.
END.
*/



/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  APPLY "entry" TO fiNrNaEtiqueta IN FRAME fpage1.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY rs-opcao 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 rtToolBar btExit btHelp rs-opcao 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY fiNrNaEtiqueta fiNrEtiqTeste 
      WITH FRAME fpage1 IN WINDOW C-Win.
  ENABLE fiNrNaEtiqueta fiNrEtiqTeste btImprimeTeste 
      WITH FRAME fpage1 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage1}
  DISPLAY fiIniciaisItem fiLinhaProducao cbIdioma fiNrEtiqItem 
      WITH FRAME fpage2 IN WINDOW C-Win.
  ENABLE fiIniciaisItem fiLinhaProducao cbIdioma btConfirmParam2 brItem 
         fiNrEtiqItem btImprimeItem RECT-18 RECT-19 
      WITH FRAME fpage2 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage2}

  {&OPEN-QUERY-fpage3}
  GET FIRST fpage3.
  DISPLAY fiIniciaisItemTri fiNrEtiqTrilingue 
      WITH FRAME fpage3 IN WINDOW C-Win.
  ENABLE fiIniciaisItemTri btConfirmParamTri brTrilingue fiNrEtiqTrilingue 
         btImprimeTrilingue RECT-20 RECT-21 
      WITH FRAME fpage3 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage3}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

