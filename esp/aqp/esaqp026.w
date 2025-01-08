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
{include/i-prgvrs.i ESAQP026 2.00.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESAQP026
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp bt-clr  ~
                              btFechar btHelp2 br-etiqueta bt-excel bt-imprimir ~
                              f-cod-etiqueta
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-esapi004 AS HANDLE NO-UNDO.
DEFINE VARIABLE i-cont     AS INTEGER                  NO-UNDO.

{esapi/esapi004tt.i}

RUN esapi/esapi004.p PERSISTENT SET h-esapi004.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-item.cod-ean13 tt-item.it-codigo tt-item.desc-item tt-item.cod-unid-negoc tt-item.des-unid-negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH tt-item BY ROWID(tt-item) DESC
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-item BY ROWID(tt-item) DESC.
&Scoped-define TABLES-IN-QUERY-br-etiqueta tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta tt-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-33 RECT-35 ~
bt-imprimir bt-clr bt-excel btQueryJoins btReportsJoins btExit btHelp ~
f-cod-etiqueta i-nro-reg br-etiqueta btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS f-cod-etiqueta i-nro-reg 

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
DEFINE BUTTON bt-clr 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-DOWN FILE "image/ii-clr1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "Limpar" 
     SIZE 5 BY 1.25 TOOLTIP "Limpa campos em tela"
     FONT 4.

DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image/toolbar/excel.bmp":U
     IMAGE-DOWN FILE "image/toolbar/ii-excel.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-excel.bmp":U
     LABEL "Excel" 
     SIZE 5 BY 1.25 TOOLTIP "Gerar Excel"
     FONT 4.

DEFINE BUTTON bt-imprimir 
     IMAGE-UP FILE "image\im-pri":U NO-FOCUS FLAT-BUTTON
     LABEL "Imprimir" 
     SIZE 5 BY 1.25 TOOLTIP "Gera Relat¢rio"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
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

DEFINE VARIABLE f-cod-etiqueta AS CHARACTER FORMAT "X(30)":U 
     LABEL "C¢digo de barras" 
     VIEW-AS FILL-IN 
     SIZE 30.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-nro-reg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro. Registros" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113.72 BY 1.5.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113.72 BY 16.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113.72 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113.72 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta wWindow _FREEFORM
  QUERY br-etiqueta DISPLAY
      tt-item.cod-ean13      COLUMN-LABEL "EAN-13"          FORMAT "x(30)"
      tt-item.it-codigo      COLUMN-LABEL "Item"            FORMAT "x(16)"
      tt-item.desc-item      COLUMN-LABEL "Descricao"
      tt-item.cod-unid-negoc COLUMN-LABEL "Unid Negoc"      FORMAT "X(03)"
      tt-item.des-unid-negoc COLUMN-LABEL "Desc Unid Negoc" FORMAT "X(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 15.92
         FONT 1 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-imprimir AT ROW 1.13 COL 10.43 HELP
          "Gera Relat¢rio" WIDGET-ID 2
     bt-clr AT ROW 1.13 COL 1.43 HELP
          "Limpa campos em tela" WIDGET-ID 32
     bt-excel AT ROW 1.13 COL 5.72 HELP
          "Gerar Excel" WIDGET-ID 10
     btQueryJoins AT ROW 1.13 COL 97.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109.43 HELP
          "Ajuda"
     f-cod-etiqueta AT ROW 3.08 COL 14.57 COLON-ALIGNED WIDGET-ID 16
     i-nro-reg AT ROW 3.08 COL 97 COLON-ALIGNED WIDGET-ID 36
     br-etiqueta AT ROW 4.92 COL 4.43 WIDGET-ID 200
     btFechar AT ROW 21.75 COL 2
     btHelp2 AT ROW 21.75 COL 102.86
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 21.54 COL 1
     RECT-33 AT ROW 2.75 COL 1 WIDGET-ID 26
     RECT-35 AT ROW 4.63 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.72 BY 22.13
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 22.13
         WIDTH              = 113.72
         MAX-HEIGHT         = 22.13
         MAX-WIDTH          = 113.72
         VIRTUAL-HEIGHT     = 22.13
         VIRTUAL-WIDTH      = 113.72
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
/* BROWSE-TAB br-etiqueta i-nro-reg fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item BY ROWID(tt-item) DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
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
    IF VALID-HANDLE(h-esapi004) THEN
        DELETE PROCEDURE h-esapi004.

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-clr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-clr wWindow
ON CHOOSE OF bt-clr IN FRAME fpage0 /* Limpar */
DO:
    EMPTY TEMP-TABLE tt-item.
    ASSIGN i-cont = 0
           i-nro-reg:SCREEN-VALUE IN FRAME fPage0 = STRING(i-cont).
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel wWindow
ON CHOOSE OF bt-excel IN FRAME fpage0 /* Excel */
DO:
    RUN piGeraExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir wWindow
ON CHOOSE OF bt-imprimir IN FRAME fpage0 /* Imprimir */
DO:
    RUN piImprime.
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


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME f-cod-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cod-etiqueta wWindow
ON RETURN OF f-cod-etiqueta IN FRAME fpage0 /* C¢digo de barras */
DO:
    RUN piMonta.
    RETURN NO-APPLY.
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


&Scoped-define BROWSE-NAME br-etiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraExcel wWindow 
PROCEDURE piGeraExcel :
/*------------------------------------------------------------------------------
  Purpose: Gera excel registros em tela
  Notes:   Carlos Daniel - 17/03/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-total   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-quant   AS INTEGER   NO-UNDO.

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.

IF LENGTH(c-arquivo) > 0 AND LOOKUP(SUBSTRING(c-arquivo, LENGTH(c-arquivo)), "/,\") = 0 THEN
    ASSIGN c-arquivo = c-arquivo + "\".
    
ASSIGN c-arquivo = c-arquivo + STRING(TODAY,"999999") + STRING(TIME) + ".csv".

OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

PUT UNFORMATTED 
    "Relacionamento EAN-13/Item"                    SKIP
    "EAN-13;Item;Descri‡Æo;Quantidade;Unid.Negocio" SKIP.
     
ASSIGN i-total = 0.

FOR EACH tt-item NO-LOCK BREAK BY tt-item.cod-ean13:

    IF FIRST-OF(tt-item.cod-ean13) THEN
        ASSIGN i-quant = 0.

    ASSIGN i-quant = i-quant + 1
           i-total = i-total + 1.

    IF LAST-OF(tt-item.cod-ean13) THEN DO:
        PUT UNFORMATTED 
             tt-item.cod-ean13      FORMAT "x(13)"      ";"
             tt-item.it-codigo      FORMAT "x(16)"      ";"
             tt-item.desc-item      FORMAT "x(50)"      ";"
             i-quant                FORMAT ">>,>>>,>>9" ";" 
             tt-item.des-unid-negoc FORMAT "X(30)" SKIP.

        ASSIGN i-quant = 0.
    END.
END.

IF i-total <> 0 THEN
    PUT UNFORMATTED
        ";;;;"                       SKIP
        ";;TOTAL;"                    
        i-total  FORMAT ">>,>>>,>>9" SKIP.

OUTPUT CLOSE.
DOS SILENT START excel value(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprime wWindow 
PROCEDURE piImprime :
/*------------------------------------------------------------------------------
  Purpose: Imprime registros em txt    
  Notes:   Carlos Daniel - 17/03/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-total   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-quant   AS INTEGER   NO-UNDO.

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.

IF LENGTH(c-arquivo) > 0 AND LOOKUP(SUBSTRING(c-arquivo, LENGTH(c-arquivo)), "/,\") = 0 THEN
    ASSIGN c-arquivo = c-arquivo + "\".
    
ASSIGN c-arquivo = c-arquivo + STRING(TODAY,"999999") + STRING(TIME) + ".tmp".

OUTPUT TO VALUE(c-arquivo) page-size 62 CONVERT TARGET SESSION:CHARSET.

PUT UNFORMATTED 
    "Relacionamento EAN-13/Item" SKIP(2)
    "EAN-13        Item             Descricao                                          Quantidade" AT 01 SKIP
    "------------- ---------------- -------------------------------------------------- ----------" AT 01 SKIP.
     
ASSIGN i-total = 0.

FOR EACH tt-item NO-LOCK BREAK BY tt-item.cod-ean13:

    IF FIRST-OF(tt-item.cod-ean13) THEN
        ASSIGN i-quant = 0.

    ASSIGN i-quant = i-quant + 1
           i-total = i-total + 1.

    IF LAST-OF(tt-item.cod-ean13) THEN DO:
        PUT UNFORMATTED 
             tt-item.cod-ean13 FORMAT "x(13)"      AT 01
             tt-item.it-codigo FORMAT "x(16)"      AT 15
             tt-item.desc-item FORMAT "x(50)"      AT 32
             i-quant           FORMAT ">>,>>>,>>9" TO 92 SKIP.
        ASSIGN i-quant = 0.
    END.
END.

IF i-total <> 0 THEN
    PUT UNFORMATTED
        "----------"                 TO 92 SKIP
        "TOTAL"                      TO 81 
        i-total  FORMAT ">>,>>>,>>9" TO 92 SKIP.

OUTPUT CLOSE.
OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMonta wWindow 
PROCEDURE piMonta :
/*------------------------------------------------------------------------------
  Purpose: Busca informa‡äes item materiais de acordo com leitura c¢digo de
           barras    
  Notes:   Carlos Daniel - 17/03/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-ean      AS CHARACTER FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE pcod-ean13 AS CHARACTER FORMAT "X(13)" NO-UNDO.
DEFINE VARIABLE pit-codigo AS CHARACTER FORMAT "X(7)"  NO-UNDO.
DEFINE VARIABLE pdesc-item AS CHARACTER FORMAT "X(60)" NO-UNDO.


EMPTY TEMP-TABLE tt-ean.

ASSIGN c-ean = f-cod-etiqueta:SCREEN-VALUE IN FRAME fPage0.
          
IF LENGTH(c-ean) = 16 THEN
    ASSIGN c-ean = SUBSTRING(c-ean,4,13).

RUN checa-ean IN h-esapi004 (INPUT c-ean,
                             INPUT-OUTPUT TABLE tt-ean).

FIND LAST tt-ean NO-ERROR.
IF AVAIL tt-ean THEN DO:
    IF tt-ean.cont > 1 THEN DO:
        RUN esp/aqp/esaqp026a.w (INPUT TABLE tt-ean,
                                 OUTPUT pcod-ean13,
                                 OUTPUT pit-codigo,
                                 OUTPUT pdesc-item).
    
        CREATE tt-item.
        ASSIGN tt-item.cod-ean13 = pcod-ean13
               tt-item.it-codigo = pit-codigo
               tt-item.desc-item = pdesc-item.

        ASSIGN i-cont = i-cont + 1.
    END.
    ELSE DO:
        CREATE tt-item.
        ASSIGN tt-item.cod-ean13 = tt-ean.cod-ean13
               tt-item.it-codigo = tt-ean.it-codigo
               tt-item.desc-item = tt-ean.desc-item.

        ASSIGN i-cont = i-cont + 1.
    END.
END.
ELSE DO:
    CREATE tt-item.
    ASSIGN tt-item.cod-ean13 = c-ean
           tt-item.it-codigo = ""
           tt-item.desc-item = "Item Inv lido".

    ASSIGN i-cont = i-cont + 1.
END.

RUN pi-unid-negoc IN h-esapi004 (INPUT  tt-item.it-codigo,
                                 OUTPUT tt-item.cod-unid-negoc,
                                 OUTPUT tt-item.des-unid-negoc).


ASSIGN f-cod-etiqueta:SCREEN-VALUE IN FRAME fPage0 = ""
       i-nro-reg:SCREEN-VALUE IN FRAME fPage0 = STRING(i-cont).

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

