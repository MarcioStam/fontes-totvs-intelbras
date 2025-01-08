&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESFTP107 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP107
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 bt-file 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.


{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER NO-UNDO.

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-lista
    FIELD seq          AS DECIMAL
    FIELD cod-estabel  AS CHAR
    FIELD serie        AS CHAR
    FIELD nr-nota-fis  AS CHAR
    FIELD n-serie      AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
c-arquivo btOK btCancel btHelp2 bt-file rtToolBar-2 rtToolBar RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-arquivo 

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
DEFINE BUTTON bt-file 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Gerar" 
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

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     c-arquivo AT ROW 3 COL 21 COLON-ALIGNED WIDGET-ID 4
     btOK AT ROW 4.71 COL 2
     btCancel AT ROW 4.71 COL 12
     btHelp2 AT ROW 4.71 COL 80
     bt-file AT ROW 2.96 COL 68 HELP
          "Escolha o arquivo de modelo" WIDGET-ID 40
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 4.5 COL 1
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 4.92
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
         HEIGHT             = 4.92
         WIDTH              = 90
         MAX-HEIGHT         = 23.08
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 23.08
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
ASSIGN 
       bt-file:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME bt-file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-file wWindow
ON CHOOSE OF bt-file IN FRAME fpage0
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign c-arquivo = replace(input frame {&frame-name} c-arquivo, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       /*INITIAL-DIR "modelos" */
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-arquivo:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Gerar */
DO:
    RUN piGeracao.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeracao wWindow 
PROCEDURE piGeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
    DEFINE VARIABLE c-linha         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-estab         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-serie         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-nf            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-linha-abaixo  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE i-linha         AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-arquivo-saida AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE i-tot-linhas    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE i-aux           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE chExcel         AS COM-HANDLE   NO-UNDO.
    DEFINE VARIABLE chArquivo       AS COM-HANDLE   NO-UNDO.
    DEFINE VARIABLE chPlanilha      AS COM-HANDLE   NO-UNDO.
    DEFINE VARIABLE chSelecao       AS COM-HANDLE   NO-UNDO.
    DEFINE VARIABLE d-seq           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-nf            AS LOGICAL     NO-UNDO.

           

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Lendo NFs").

    EMPTY TEMP-TABLE tt-lista.

    INPUT FROM VALUE(c-arquivo:SCREEN-VALUE IN FRAME fPage0).

    ASSIGN d-seq   = 0.

    REPEAT:

        IMPORT c-linha.

        ASSIGN c-estab = ENTRY(1, c-linha, ";")
               c-serie = ENTRY(2, c-linha, ";")
               c-nf    = string(int(ENTRY(3, c-linha, ";")), "9999999").
               

        RUN pi-acompanhar IN h-acomp (INPUT "NF: " + STRING(c-nf)).

        FOR EACH num-serie-rast NO-LOCK
            WHERE num-serie-rast.cod-estabel = c-estab
            AND   num-serie-rast.nr-nota-fis = c-nf
            AND   num-serie-rast.serie       = c-serie:

            IF num-serie-rast.it-codigo BEGINS "432" THEN DO:
    
                FOR FIRST num-serie NO-LOCK
                    WHERE num-serie.n-serie = num-serie-rast.n-serie:
    
                    /* NF Remessa */
                    CREATE tt-lista.
                    ASSIGN d-seq                 = d-seq + 1
                           tt-lista.seq          = d-seq
                           tt-lista.cod-estabel  = c-estab
                           tt-lista.serie        = c-serie
                           tt-lista.nr-nota-fis  = string(int(c-nf), "9999999")
                           tt-lista.n-serie      = num-serie.n-serie.

                    /* NF Faturamento */
                    CREATE tt-lista.
                    ASSIGN d-seq                 = d-seq + 1
                           tt-lista.seq          = d-seq
                           tt-lista.cod-estabel  = c-estab
                           tt-lista.serie        = c-serie
                           tt-lista.nr-nota-fis  = string(int(c-nf) - 1, "9999999")
                           tt-lista.n-serie      = num-serie.n-serie.
    
                END.

            END.

        END.

    END.

    INPUT CLOSE.

    /**/

    RUN pi-inicializar IN h-acomp (INPUT "Gerando sa¡da").

    ASSIGN c-arquivo-saida = SESSION:TEMP-DIR + "esftp107-" + string(YEAR(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)) + "-" + string(TIME) + ".csv".

    OUTPUT TO value(c-arquivo-saida) CONVERT TARGET "iso8859-1".
    
    ASSIGN i-cont = 0
           i-linha = 0
           c-linha-abaixo = ""
           i-tot-linhas = 0.

    FOR EACH tt-lista
        BY tt-lista.seq:

        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "NF: " + STRING(tt-lista.nr-nota-fis)).

        PUT UNFORMATTED
            string(tt-lista.nr-nota-fis, "9999999") + ";;".

        ASSIGN c-linha-abaixo = c-linha-abaixo + "NS§ " + tt-lista.n-serie + ";;".

        IF i-cont = 4 THEN DO:

            PUT UNFORMATTED
                SKIP
                c-linha-abaixo SKIP.

            ASSIGN i-cont = 0
                   c-linha-abaixo = ""
                   i-linha = i-linha + 1.

            ASSIGN i-tot-linhas = i-tot-linhas + 2.

        END.

        IF i-linha = 19 THEN DO:

            ASSIGN i-cont = 0
                   i-linha = 0
                   c-linha-abaixo = ""
                   i-tot-linhas = i-tot-linhas + 1.

            PUT UNFORMATTED SKIP(1).

        END.

    END.

    IF i-cont < 4 THEN DO:

        PUT UNFORMATTED
            SKIP
            c-linha-abaixo SKIP(2).

        ASSIGN i-cont = 0
               c-linha-abaixo = ""
               i-linha = i-linha + 1.

        ASSIGN i-tot-linhas = i-tot-linhas + 2.

    END.

    OUTPUT CLOSE.

    /**/

    RUN pi-inicializar IN h-acomp ("Formatando").

    CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
    IF ERROR-STATUS:ERROR THEN 
        CREATE "Excel.Application":U chExcel.

    ASSIGN chArquivo  = chExcel:WorkBooks:Open(c-arquivo-saida).
    ASSIGN chPlanilha = chArquivo:Sheets:Item(1).

    ASSIGN chPlanilha:Cells:RowHeight = 19.25.
    ASSIGN chExcel:Range("A:A;C:C;E:E;G:G"):ColumnWidth = 22.57.
    ASSIGN chExcel:Range("B:B;D:D;F:F"):ColumnWidth = 1.14.
    ASSIGN chExcel:Cells:HorizontalAlignment = -4108.
    
    chPlanilha:PageSetup:PrintTitleRows = "".
    chPlanilha:PageSetup:PrintTitleColumns = "".

    chPlanilha:PageSetup:PrintArea = "".
    chPlanilha:PageSetup:LeftHeader = "".
    
    ASSIGN 
        chPlanilha:PageSetup:CenterHeader = ""
        chPlanilha:PageSetup:RightHeader = ""
        chPlanilha:PageSetup:LeftFooter = ""
        chPlanilha:PageSetup:CenterFooter = ""
        chPlanilha:PageSetup:RightFooter = ""
        chPlanilha:PageSetup:LeftMargin = chExcel:InchesToPoints(0.47244094488189)
        chPlanilha:PageSetup:RightMargin = chExcel:InchesToPoints(0)
        chPlanilha:PageSetup:TopMargin = chExcel:InchesToPoints(0.62992125984252)
        chPlanilha:PageSetup:BottomMargin = chExcel:InchesToPoints(0)
        chPlanilha:PageSetup:HeaderMargin = chExcel:InchesToPoints(0)
        chPlanilha:PageSetup:FooterMargin = chExcel:InchesToPoints(0)
        chPlanilha:PageSetup:PrintHeadings = False
        chPlanilha:PageSetup:PrintGridlines = False
        chPlanilha:PageSetup:PrintComments = -4142
        chPlanilha:PageSetup:PrintQuality = 600
        chPlanilha:PageSetup:CenterHorizontally = False
        chPlanilha:PageSetup:CenterVertically = False
        chPlanilha:PageSetup:Orientation = 1
        chPlanilha:PageSetup:Draft = False  
        chPlanilha:PageSetup:PaperSize = 1
        chPlanilha:PageSetup:FirstPageNumber = -4105
        chPlanilha:PageSetup:Order = 1
        chPlanilha:PageSetup:BlackAndWhite = False
        chPlanilha:PageSetup:Zoom = 100
        chPlanilha:PageSetup:PrintErrors = 0
        chPlanilha:PageSetup:OddAndEvenPagesHeaderFooter = False
        chPlanilha:PageSetup:DifferentFirstPageHeaderFooter = False
        chPlanilha:PageSetup:ScaleWithDocHeaderFooter = True
        chPlanilha:PageSetup:AlignMarginsHeaderFooter = True.

    ASSIGN chSelecao = chPlanilha:PageSetup:EvenPage.

    ASSIGN chSelecao:LeftHeader:Text = ""
           chSelecao:CenterHeader:Text = ""
           chSelecao:RightHeader:Text = ""
           chSelecao:LeftFooter:Text = ""
           chSelecao:CenterFooter:Text = ""
           chSelecao:RightFooter:Text = "".

    RELEASE OBJECT chSelecao.

    ASSIGN chSelecao = chPlanilha:PageSetup:FirstPage.

    ASSIGN chSelecao:LeftHeader:Text = ""
           chSelecao:CenterHeader:Text = ""
           chSelecao:RightHeader:Text = ""
           chSelecao:LeftFooter:Text = ""
           chSelecao:CenterFooter:Text = ""
           chSelecao:RightFooter:Text = "".

    RELEASE OBJECT chSelecao.

    ASSIGN l-nf = TRUE.

    DO i-aux = 1 TO i-tot-linhas:

        IF NOT i-aux MOD 39 = 0 THEN DO:

            ASSIGN chSelecao = chExcel:Rows(string(i-aux)  + ":" + string(i-aux)).
    
            IF l-nf THEN
                ASSIGN chSelecao:VerticalAlignment = -4107 /* xlBottom */
                       l-nf = FALSE.
            ELSE
                ASSIGN chSelecao:VerticalAlignment = -4160 /* xlTop */
                       l-nf = TRUE.

            RELEASE OBJECT chSelecao.

        END.

    END.

    /*chExcel:VISIBLE = TRUE.*/
    chPlanilha:SaveAs(REPLACE(c-arquivo-saida, ".csv", ".xlsx"), "51",,,,,) NO-ERROR.

    RUN pi-finalizar IN h-acomp.

    /*chArquivo:CLOSE(NO).
    chExcel:QUIT().*/

    chExcel:VISIBLE = TRUE.

    RELEASE OBJECT chExcel.
    RELEASE OBJECT chArquivo.
    RELEASE OBJECT chPlanilha  NO-ERROR.
          

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

