&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttped-item NO-UNDO LIKE ped-item.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP005A 1.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP005A
&GLOBAL-DEFINE Version        1.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK brSon1 btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.

DEFINE VARIABLE c-descitem     AS CHAR    FORMAT "x(60)"   NO-UNDO LABEL "Descri‡Æo".
DEFINE VARIABLE d-saldo        AS DECIMAL FORMAT "->>>,>>9" NO-UNDO LABEL "Saldo Ped".
DEFINE VARIABLE d-estoque      AS DECIMAL FORMAT "->>>,>>9" NO-UNDO LABEL "Estoq Disp".
DEFINE VARIABLE i-aloca        AS DECIMAL FORMAT ">>>,>>9" NO-UNDO LABEL "Reservado".

{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttped-item

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttped-item.it-codigo ~
fnDescItem() @ c-descitem ttped-item.qt-pedida ttped-item.qt-log-aloca ~
qt-pedida - qt-atendida - qt-log-aloca @ d-saldo fnEstoque() @ d-estoque ~
ttped-item.vl-preuni 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttped-item NO-LOCK ~
    BY ttped-item.it-codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttped-item NO-LOCK ~
    BY ttped-item.it-codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon1 ttped-item
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttped-item


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brSon1 rtToolBar btOK btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstoque wWindow 
FUNCTION fnEstoque RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttped-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wWindow _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttped-item.it-codigo FORMAT "x(16)":U
      fnDescItem() @ c-descitem COLUMN-LABEL "Descri‡Æo" FORMAT "x(60)":U
            WIDTH 45
      ttped-item.qt-pedida COLUMN-LABEL "Qtd Ped" FORMAT ">>>,>>9":U
            WIDTH 7
      ttped-item.qt-log-aloca COLUMN-LABEL "Alocado" FORMAT ">>>,>>9":U
            WIDTH 7
      qt-pedida - qt-atendida - qt-log-aloca @ d-saldo COLUMN-LABEL "Sdo Ped" FORMAT ">>>,>>9":U
      fnEstoque() @ d-estoque COLUMN-LABEL "Estoque" FORMAT ">>>,>>9":U
            WIDTH 7
      ttped-item.vl-preuni COLUMN-LABEL "Pre‡o" FORMAT ">>>,>>9.99":U
            WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 8
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brSon1 AT ROW 1 COL 1
     btOK AT ROW 9.33 COL 2
     btHelp2 AT ROW 9.33 COL 89.72
     rtToolBar AT ROW 9.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.14 BY 9.58
         FONT 1
         DEFAULT-BUTTON btOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttped-item T "?" NO-UNDO mgmov ped-item
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.58
         WIDTH              = 100.29
         MAX-HEIGHT         = 28.92
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.92
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSon1 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttped-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.ttped-item.it-codigo|yes"
     _FldNameList[1]   = Temp-Tables.ttped-item.it-codigo
     _FldNameList[2]   > "_<CALC>"
"fnDescItem() @ c-descitem" "Descri‡Æo" "x(60)" ? ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttped-item.qt-pedida
"ttped-item.qt-pedida" "Qtd Ped" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttped-item.qt-log-aloca
"ttped-item.qt-log-aloca" "Alocado" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"qt-pedida - qt-atendida - qt-log-aloca @ d-saldo" "Sdo Ped" ">>>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnEstoque() @ d-estoque" "Estoque" ">>>,>>9" ? ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttped-item.vl-preuni
"ttped-item.vl-preuni" "Pre‡o" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE brSon1 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wWindow
ON ROW-DISPLAY OF brSon1 IN FRAME fpage0
DO:
    IF AVAIL ttped-item THEN DO:
        FIND FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
            AND   item-uni-estab.it-codigo   = ttped-item.it-codigo
            AND   item-uni-estab.nr-linha    = 20 NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:
            ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 2
                   ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 2
                   ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 2
                   ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 2
                   d-saldo:FGCOLOR IN BROWSE brSon1 = 2
                   d-estoque:FGCOLOR IN BROWSE brSon1 = 2
                   c-descitem:FGCOLOR IN BROWSE brSon1 = 2.    
        END.
        ELSE DO:
            IF fnEstoque() + ttped-item.qt-log-aloca = 0 THEN
                ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 12
                       ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 12
                       ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 12
                       ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 12
                       d-saldo:FGCOLOR IN BROWSE brSon1 = 12
                       d-estoque:FGCOLOR IN BROWSE brSon1 = 12
                       c-descitem:FGCOLOR IN BROWSE brSon1 = 12.
            ELSE
                ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = ?
                       ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = ?
                       ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = ?
                       ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = ?
                       d-saldo:FGCOLOR IN BROWSE brSon1 = ?
                       d-estoque:FGCOLOR IN BROWSE brSon1 = ?
                       c-descitem:FGCOLOR IN BROWSE brSon1 = ?.
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
/* FIND FIRST para-ped NO-LOCK. */
/*    */
FIND FIRST ped-venda WHERE ROWID(ped-venda) = gr-ped-venda NO-LOCK NO-ERROR.
IF AVAIL ped-venda THEN DO:
    FOR EACH ped-item OF ped-venda WHERE ped-item.cod-sit-item <> 3 AND
                                         ped-item.cod-sit-item <> 6 NO-LOCK:
        CREATE ttPed-item.
        BUFFER-COPY ped-item TO ttped-item.
    END.
END.

{&OPEN-QUERY-{&BROWSE-NAME}}

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ITEM OF ttped-item NO-LOCK NO-ERROR.
  IF AVAIL ITEM THEN
    RETURN ITEM.desc-item.
  ELSE
    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstoque wWindow 
FUNCTION fnEstoque RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE qtd               AS DECIMAL   NO-UNDO INIT 0.
DEFINE VARIABLE c-deposESPDP005   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-wms-estab-ativo AS LOGICAL   NO-UNDO.

RUN esp/wmp/eswmpapi006.p( INPUT ped-venda.cod-estabel, OUTPUT l-wms-estab-ativo).

ASSIGN c-deposESPDP005 = IF  l-wms-estab-ativo THEN 'WEX' ELSE 'EXP'.


FIND FIRST item-uni-estab NO-LOCK
     WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
     AND   item-uni-estab.it-codigo   = ttped-item.it-codigo
     AND   item-uni-estab.nr-linha    = 20 NO-ERROR.
IF AVAIL item-uni-estab THEN DO:

    RUN esapi/esapi011.p (input ped-venda.cod-estabel,
                          INPUT ttped-item.it-codigo,
                          INPUT c-deposESPDP005,
                          INPUT "",
                          OUTPUT qtd).

END.
ELSE DO:
  FOR EACH  saldo-estoq NO-LOCK 
      WHERE saldo-estoq.cod-estabel = ped-venda.cod-estabel
      and   saldo-estoq.cod-depos = c-deposESPDP005 
      AND   saldo-estoq.it-codigo = ttped-item.it-codigo:

      FOR FIRST mgesp.ponto-programa
          where ponto-programa.nome-programa = "espdp006"
            AND ponto-programa.ponto = 2,
          FIRST mgesp.conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND ENTRY(1,conteudo-programa.conteudo) = saldo-estoq.cod-depos
            AND ENTRY(2,conteudo-programa.conteudo) = saldo-estoq.cod-localiz:     /* desconsidera as localiza‡äes cadastradas aqui */
      END.
      IF AVAIL conteudo-programa THEN DO:
          NEXT.                   
      END.

      FOR FIRST int-saldo-estoq NO-LOCK
          {dbini\es322.i1 int-saldo-estoq saldo-estoq}:
      END.
      IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.

      ASSIGN qtd = qtd + saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped.
  END.
END. 
                          
RETURN qtd.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

