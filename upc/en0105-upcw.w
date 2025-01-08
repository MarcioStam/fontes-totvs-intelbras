&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i EN0105-UPCW 2.04.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

/*&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        EN0105-UPCW
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2 c-arq-imp bt-importacao ~
                              bt-simular br-estrutura btExp btCon
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo AS CHAR    
    FIELD sequencia AS INT
    FIELD es-codigo AS CHAR    
    FIELD qt-item   AS DEC
    FIELD linha     AS INT
    FIELD coluna    AS INT
    FIELD visivel   AS LOGICAL
    FIELD nivel     AS CHAR
    FIELD r-pai     AS ROWID
    FIELD ds-item   LIKE item.desc-item
    INDEX id AS PRIMARY it-codigo sequencia es-codigo
    INDEX id-posicao AS UNIQUE coluna linha.

DEFINE BUFFER b-tt-item FOR tt-item.

DEFINE VARIABLE iLinha      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCol        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-item      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iColMaior   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iColQtd     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.

DEFINE VARIABLE chExcel     AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorksheet AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chWorkbook  AS COM-HANDLE  NO-UNDO.

DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-estrutura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE br-estrutura                                  */
&Scoped-define FIELDS-IN-QUERY-br-estrutura tt-item.nivel + tt-item.es-codigo tt-item.ds-item tt-item.qt-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-estrutura   
&Scoped-define SELF-NAME br-estrutura
&Scoped-define QUERY-STRING-br-estrutura FOR EACH tt-item WHERE tt-item.visivel                                          BY tt-item.linha                                          BY tt-item.coluna                                          BY tt-item.sequencia
&Scoped-define OPEN-QUERY-br-estrutura OPEN QUERY {&SELF-NAME} FOR EACH tt-item WHERE tt-item.visivel                                          BY tt-item.linha                                          BY tt-item.coluna                                          BY tt-item.sequencia.
&Scoped-define TABLES-IN-QUERY-br-estrutura tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-estrutura tt-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-estrutura}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-2 btQueryJoins ~
btReportsJoins btExit btHelp bt-importacao bt-simular c-arq-imp ~
br-estrutura btOk btExp btCon btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-arq-imp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-importacao 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-simular 
     IMAGE-UP FILE "image/fields2.bmp":U
     LABEL "Simular" 
     SIZE 3.86 BY 1.08 TOOLTIP "Simular Importaá∆o".

DEFINE BUTTON btCon 
     LABEL "Contrair" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExp 
     LABEL "Expandir" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOk 
     LABEL "Importar" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE c-arq-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 64.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-estrutura FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-estrutura wWindow _FREEFORM
  QUERY br-estrutura DISPLAY
      tt-item.nivel + tt-item.es-codigo      FORMAT "x(40)"             COLUMN-LABEL "Item"
    tt-item.ds-item                        FORMAT "x(40)"             COLUMN-LABEL "Descriá∆o" WIDTH 42
    tt-item.qt-item                        FORMAT ">>>,>>>,>9.999999" COLUMN-LABEL "Qtd. Usada"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 11.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     bt-importacao AT ROW 2.92 COL 80.43 HELP
          "Localiza Arquivo" WIDGET-ID 24
     bt-simular AT ROW 2.92 COL 84.72 HELP
          "Localiza Arquivo" WIDGET-ID 26
     c-arq-imp AT ROW 3 COL 13.72 COLON-ALIGNED WIDGET-ID 16
     br-estrutura AT ROW 4.5 COL 2 WIDGET-ID 200
     btOk AT ROW 16.21 COL 2
     btExp AT ROW 16.21 COL 32 WIDGET-ID 28
     btCon AT ROW 16.21 COL 43 WIDGET-ID 30
     btHelp2 AT ROW 16.21 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16 COL 1
     RECT-2 AT ROW 2.75 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.58
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
         HEIGHT             = 16.54
         WIDTH              = 90.14
         MAX-HEIGHT         = 19.33
         MAX-WIDTH          = 105.57
         VIRTUAL-HEIGHT     = 19.33
         VIRTUAL-WIDTH      = 105.57
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
/* BROWSE-TAB br-estrutura c-arq-imp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-estrutura
/* Query rebuild information for BROWSE br-estrutura
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item WHERE tt-item.visivel
                                         BY tt-item.linha
                                         BY tt-item.coluna
                                         BY tt-item.sequencia.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-estrutura */
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


&Scoped-define BROWSE-NAME br-estrutura
&Scoped-define SELF-NAME br-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-estrutura wWindow
ON MOUSE-SELECT-DBLCLICK OF br-estrutura IN FRAME fpage0
DO:
    DEFINE VARIABLE r-corrente AS ROWID       NO-UNDO.

    FIND CURRENT tt-item NO-ERROR.
    IF AVAIL tt-item THEN DO:
        ASSIGN r-corrente = ROWID(tt-item).
        FOR EACH b-tt-item
            WHERE b-tt-item.r-pai = ROWID(tt-item):
    
            IF b-tt-item.visivel = NO THEN DO:
              ASSIGN b-tt-item.visivel = YES.
            END.
            ELSE DO:
                ASSIGN b-tt-item.visivel = NO.
                RUN pi-fecha(INPUT ROWID(b-tt-item)).
            END.
        END.
    
        {&OPEN-QUERY-br-estrutura}
    
        REPOSITION br-estrutura TO ROWID r-corrente.
    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao wWindow
ON CHOOSE OF bt-importacao IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.xls" "*.xls",
               "*.xlsx" "*.xlsx", 
               "*.*" "*.*"
       DEFAULT-EXTENSION "xsl"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign c-arq-imp = c-arq-conv.
        display c-arq-imp with frame fpage0.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-simular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-simular wWindow
ON CHOOSE OF bt-simular IN FRAME fpage0 /* Simular */
DO:
    RUN pi-importar.  

    {&OPEN-QUERY-br-estrutura}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCon wWindow
ON CHOOSE OF btCon IN FRAME fpage0 /* Contrair */
DO:
    RUN pi-exp-con (INPUT NO).
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


&Scoped-define SELF-NAME btExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExp wWindow
ON CHOOSE OF btExp IN FRAME fpage0 /* Expandir */
DO:
    RUN pi-exp-con (INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wWindow
ON CHOOSE OF btOk IN FRAME fpage0 /* Importar */
DO:
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

    FOR EACH  tt-item
        WHERE tt-item.sequencia > 0.
        
        RUN pi-acompanhar IN h-acomp(INPUT "Item: " + tt-item.it-codigo + " Compon.: " + tt-item.es-codigo).

        ASSIGN i-seq = tt-item.sequencia * 10.

        FIND FIRST estrutura NO-LOCK
             WHERE estrutura.it-codigo = tt-item.it-codigo
               AND estrutura.sequencia = i-seq
               AND estrutura.es-codigo = tt-item.es-codigo NO-ERROR.
        IF NOT AVAIL estrutura THEN DO:

            CREATE estrutura.
            ASSIGN estrutura.it-codigo    = tt-item.it-codigo
                   estrutura.sequencia    = i-seq
                   estrutura.es-codigo    = tt-item.es-codigo
                   estrutura.proporcao    = 100
                   estrutura.quant-usada  = tt-item.qt-item
                   estrutura.data-inicio  = TODAY
                   estrutura.data-termino = 12/31/9999
                   estrutura.tipo-sobra   = 4 /* 4- Normal */
                   estrutura.eng-resp     = 1 /* 1- Produto */
                   estrutura.quant-liquid = tt-item.qt-item
                   estrutura.qtd-item     = 1
                   estrutura.qtd-compon   = tt-item.qt-item.

        END.
    END.

    RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE OBJECT h-acomp.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-con wWindow 
PROCEDURE pi-exp-con :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-acao AS LOGICAL NO-UNDO.

FOR EACH  b-tt-item
    WHERE b-tt-item.r-pai <> ?:
    ASSIGN b-tt-item.visivel = p-acao.
END.

{&OPEN-QUERY-br-estrutura}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fecha wWindow 
PROCEDURE pi-fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-pai AS ROWID NO-UNDO.

FOR EACH b-tt-item
    WHERE b-tt-item.r-pai = p-pai:
    ASSIGN b-tt-item.visivel = NO.
    RUN pi-fecha(INPUT ROWID(b-tt-item)).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importar wWindow 
PROCEDURE pi-importar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
SESSION:SUPPRESS-WARNINGS = YES.

ASSIGN INPUT FRAME fpage0 c-arq-imp.

CREATE "excel.application" chExcel.

/* Open an Excel document  */
chWorkbook = chExcel:Workbooks:Open(c-arq-imp). 

/* Open Excel maximized */
chExcel:WindowState = -4137.

chExcel:visible = FALSE.

/* Add a new worksheet as the last sheet */
chWorksheet = chWorkbook:Worksheets(1).

/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).

ASSIGN iCol   = 1
       iLinha = 0.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

EMPTY TEMP-TABLE tt-item.

REPEAT:

    ASSIGN iLinha      = iLinha + 1
           c-item      = chWorksheet:cells(iLinha,iCol):FormulaR1C1
           i-seq       = 1.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = c-item
           AND ITEM.it-codigo NE "" NO-ERROR.
    IF AVAIL ITEM THEN DO:  

        ASSIGN iCont = iCol. 

        REPEAT:
            ASSIGN iCont = iCont + 1.          

            IF chWorksheet:cells(iLinha - 1,iCont):FormulaR1C1 BEGINS "Quant" OR chWorksheet:cells(iLinha - 1,iCont):FormulaR1C1 BEGINS "qtd" THEN DO:
                iColQtd = iCont.
                LEAVE.
            END.
        END.

        CREATE tt-item.
        ASSIGN tt-item.visivel     = YES
               tt-item.nivel       = ""
               tt-item.it-codigo   = ITEM.it-codigo
               tt-item.es-codigo   = ITEM.it-codigo
               tt-item.r-pai       = ?
               tt-item.linha       = iLinha
               tt-item.coluna      = iCol
               tt-item.sequencia   = 0
               tt-item.qt-item     = round(chWorksheet:cells(iLinha,iColQtd):VALUE,5)
               tt-item.ds-item     = ITEM.desc-item.
            
        ASSIGN iCol   = iCol + 1
               iLinha = iLinha + 1.        

        RUN pi-proximo-nivel (INPUT c-item).
        LEAVE.
    END. /* Avail item */    
    IF iLinha >= 50 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17242,
                           INPUT "Produto Acabado n∆o cadastrado no sistema").
        LEAVE.
    END.
END.

/* Save the new workbook without displaying alerts */
chExcel:DisplayAlerts = FALSE.
/*chWorkbook:SaveAs("c:\temp\test2.xls",43,,,,,).*/ /* Excel 2016 no longer supports format 43 (Excel 95 & 97 .xls file) */

/* Quit Excel */
chExcel:quit().

/* Release Com-handles used  */
RELEASE OBJECT chWorksheet.
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chExcel.    

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

FOR EACH tt-item.

    FIND FIRST b-tt-item 
         WHERE b-tt-item.es-codigo = tt-item.it-codigo 
           AND b-tt-item.linha     < tt-item.linha
           AND b-tt-item.coluna    = (tt-item.coluna - 1) NO-ERROR.
    IF AVAIL b-tt-item THEN
        ASSIGN tt-item.r-pai = ROWID(b-tt-item).
END.
/*
OUTPUT TO 'c:\temp\importar-estrutura.csv'.
EXPORT DELIMITER ";"
    "Item"
    "Seq"
    "Componente"
    "Qtd"
    "Linha"
    "Coluna"
    "Visivel"
    "Nivel"
    "Rowid"
    "Desc".

FOR EACH tt-item.

    EXPORT DELIMITER ";"
        tt-item.it-codigo 
        tt-item.sequencia 
        tt-item.es-codigo 
        tt-item.qt-item   
        tt-item.linha     
        tt-item.coluna    
        tt-item.visivel   
        tt-item.nivel     
        string(tt-item.r-pai)
        tt-item.ds-item.
END.
OUTPUT CLOSE.*/

SESSION:SUPPRESS-WARNINGS = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-proximo-nivel wWindow 
PROCEDURE pi-proximo-nivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-item       AS CHAR                NO-UNDO.    

    DEFINE VARIABLE c-item-aux      AS CHARACTER           NO-UNDO.       
    DEFINE VARIABLE l-tem-valor     AS LOGICAL             NO-UNDO.
    DEFINE VARIABLE iContAux        AS INTEGER             NO-UNDO.
    DEFINE VARIABLE iLinhaAux       AS INTEGER             NO-UNDO.        

    ASSIGN l-tem-valor = NO.

    RUN pi-acompanhar IN h-acomp(INPUT "Linha: " + STRING(iLinha)).
    
    IF NOT CAN-FIND(FIRST tt-item 
                    WHERE tt-item.linha = iLinha) THEN DO:

        bloco_linha:
        DO iLinhaAux = iLinha TO (iLinha + 5):    
            
            bloco_coluna:
            DO iCont = 1 TO (iColQtd - 2):                     
        
                IF NOT chWorksheet:cells(iLinhaAux,iCont):VALUE = ? THEN DO:
                    ASSIGN l-tem-valor = YES.
                    LEAVE bloco_linha.
                END.
            END.
        END.
        
        IF NOT l-tem-valor THEN
            RETURN "OK".
    END.

    ASSIGN c-item-aux = chWorksheet:cells(iLinha,iCol):FormulaR1C1.        

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = c-item-aux 
           AND item.it-codigo NE "" NO-ERROR.
    IF AVAIL ITEM THEN DO:        

        FIND LAST  b-tt-item
             WHERE b-tt-item.it-codigo = p-item NO-ERROR.
        IF AVAIL b-tt-item THEN
            ASSIGN i-seq = b-tt-item.sequencia + 1.

        CREATE tt-item.
        ASSIGN tt-item.it-codigo = p-item
               tt-item.es-codigo = c-item-aux
               tt-item.sequencia = i-seq
               tt-item.qt-item   = round(chWorksheet:cells(iLinha,iColQtd):VALUE,5)
               tt-item.linha     = iLinha
               tt-item.coluna    = iCol
               tt-item.ds-item   = ITEM.desc-item
               tt-item.nivel     = FILL("     ",(iCol - 1))
               tt-item.visivel   = NO.

        ASSIGN iLinha = iLinha + 1.

        IF (ITEM.it-codigo BEGINS "2" AND NOT item.it-codigo BEGINS "208") THEN DO: /* 2- Semi Acabado */
            ASSIGN iCol   = iCol   + 1
                   i-seq  = 1.

            IF iColMaior < iCol THEN
                ASSIGN iColMaior = iCol.            

            RUN pi-proximo-nivel (INPUT tt-item.es-codigo).
        END.
        ELSE DO: /* 1- M†teria prima */           

            RUN pi-proximo-nivel (INPUT tt-item.it-codigo).
        END.
    END.
    ELSE DO:
        ASSIGN iCol = iCol - 1.

        IF iCol = 1 THEN
            ASSIGN iLinha = iLinha + 1
                   iCol   = iColMaior.       
        
        FIND LAST  b-tt-item USE-INDEX id-posicao
             WHERE b-tt-item.coluna = iCol NO-ERROR.
        IF AVAIL b-tt-item THEN
            RUN pi-proximo-nivel (INPUT b-tt-item.it-codigo).
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

