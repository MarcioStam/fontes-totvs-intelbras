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
{include/i-prgvrs.i ESCEP073 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP073
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail 

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2 fi-etiqueta br-etiquetas btConfigImpr bt-limpar

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-etiquetas
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-volume         LIKE volume-nf.nr-volume
    FIELD it-codigo         LIKE volume-nf.it-codigo
    INDEX id cod-estabel serie nr-nota-fis nr-volume it-codigo.

DEFINE VARIABLE c-cod-estabel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-volume        AS INTEGER     NO-UNDO.

DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-nr-volumes AS INTEGER     NO-UNDO.

DEFINE VARIABLE AppWord AS COM-HANDLE       NO-UNDO.
DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-regs AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-celula AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pagina AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-lado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-lins-por-pagina AS INTEGER    INIT 21 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiquetas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-etiquetas

/* Definitions for BROWSE br-etiquetas                                  */
&Scoped-define FIELDS-IN-QUERY-br-etiquetas tt-etiquetas.nr-nota-fis tt-etiquetas.serie tt-etiquetas.nr-volume   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiquetas   
&Scoped-define SELF-NAME br-etiquetas
&Scoped-define QUERY-STRING-br-etiquetas FOR EACH tt-etiquetas
&Scoped-define OPEN-QUERY-br-etiquetas OPEN QUERY {&SELF-NAME} FOR EACH tt-etiquetas.
&Scoped-define TABLES-IN-QUERY-br-etiquetas tt-etiquetas
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiquetas tt-etiquetas


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiquetas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-33 RECT-34 ~
bt-limpar btQueryJoins btReportsJoins btExit btHelp fi-etiqueta ~
br-etiquetas btConfigImpr fiPrinter btOK btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-etiqueta fiPrinter 

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
DEFINE BUTTON bt-limpar 
     IMAGE-UP FILE "image/im-clr1.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configura‡Æo da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configura‡Æo da impressora".

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
     LABEL "Imprimir" 
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

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE RECT-34
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiquetas FOR 
      tt-etiquetas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiquetas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiquetas wWindow _FREEFORM
  QUERY br-etiquetas DISPLAY
      tt-etiquetas.nr-nota-fis
     tt-etiquetas.serie
     tt-etiquetas.nr-volume
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 10
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-limpar AT ROW 1.13 COL 1.72 HELP
          "Consultas relacionadas" WIDGET-ID 30
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-etiqueta AT ROW 3 COL 32 COLON-ALIGNED WIDGET-ID 2
     br-etiquetas AT ROW 4.5 COL 2 WIDGET-ID 200
     btConfigImpr AT ROW 15 COL 67.72 HELP
          "Configura‡Æo da impressora" WIDGET-ID 22
     fiPrinter AT ROW 15.08 COL 23 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     btOK AT ROW 16.71 COL 2
     btHelp2 AT ROW 16.71 COL 80
     "" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 15.21 COL 15 WIDGET-ID 28
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.5 COL 1
     RECT-33 AT ROW 2.75 COL 2 WIDGET-ID 4
     RECT-34 AT ROW 14.75 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.92
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
         HEIGHT             = 16.92
         WIDTH              = 90
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.46
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
/* BROWSE-TAB br-etiquetas fi-etiqueta fpage0 */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiquetas
/* Query rebuild information for BROWSE br-etiquetas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-etiquetas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiquetas */
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


&Scoped-define BROWSE-NAME br-etiquetas
&Scoped-define SELF-NAME br-etiquetas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-etiquetas wWindow
ON MOUSE-SELECT-DBLCLICK OF br-etiquetas IN FRAME fpage0
DO:

    IF AVAIL tt-etiquetas THEN DO:
        DELETE tt-etiquetas.
        ASSIGN i-nr-volumes = i-nr-volumes - 1.
        {&open-query-br-etiquetas}
    END.


  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpar wWindow
ON CHOOSE OF bt-limpar IN FRAME fpage0 /* Query Joins */
DO:

    ASSIGN i-nr-volumes = 0.

    FOR EACH tt-etiquetas:
        DELETE tt-etiquetas.
    END.

    {&open-query-br-etiquetas}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configura‡Æo da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
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
ON CHOOSE OF btOK IN FRAME fpage0 /* Imprimir */
DO:


    RUN piImprimirWord.

    
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


&Scoped-define SELF-NAME fi-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON RETURN OF fi-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:

    /*104 001 0272665 00001*/

    ASSIGN c-cod-estabel = SUBSTRING(SELF:SCREEN-VALUE, 1, 3)
           c-serie       = string(int(SUBSTRING(SELF:SCREEN-VALUE, 4, 3)))
           c-nr-nota-fis = SUBSTRING(SELF:SCREEN-VALUE, 7, 7)
           i-volume      = int(SUBSTRING(SELF:SCREEN-VALUE,14,5)).

    FOR FIRST volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = c-cod-estabel
        AND   volume-nf.serie       = c-serie
        AND   volume-nf.nr-nota-fis = c-nr-nota-fis
        AND   volume-nf.nr-volume   = i-volume:

        FOR FIRST tt-etiquetas
            WHERE tt-etiquetas.cod-estabel = volume-nf.cod-estabel
            AND   tt-etiquetas.serie       = volume-nf.serie
            AND   tt-etiquetas.nr-nota-fis = volume-nf.nr-nota-fis
            AND   tt-etiquetas.nr-volume   = volume-nf.nr-volume:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT "17006",
                               INPUT "Volume j  foi lido.").

            APPLY "ENTRY" TO SELF.

            RETURN NO-APPLY.

        END.
            
        ASSIGN i-nr-volumes = i-nr-volumes + 1.

        CREATE tt-etiquetas.
        BUFFER-COPY volume-nf TO tt-etiquetas.

    END.

    {&open-query-br-etiquetas}

    ASSIGN SELF:SCREEN-VALUE = "".

    APPLY "ENTRY" TO SELF.
  
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    ASSIGN fiPrinter:VISIBLE IN FRAME fPage0 = FALSE
           btConfigImpr:VISIBLE IN FRAME fPage0 = FALSE.

    ASSIGN i-nr-volumes = 0.



    /* Carga Inicial para Testes

    DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.


    ASSIGN c-lista = "104001028539200011,104001028539200006,104001028539200005,104001028539200003,104001028539200016,104001028539200017,104001028539200018,104001028539200025,104001028539200026,104001028539200019,104001028539200024,104001028539200015,104001028539200014,104001028539200013,104001028539200012,104001028539200020,104001028539200021,104001028539200022,104001028539200023,104001028539200004,104001028539200010,104001028539200009,104001028539200030,104001028539200029,104001028539200027,104001028539200028,104001028539200002,104001028539200001,104001028539200007,104001028539200008,104001028539200032".

    DO i-aux = 1 TO 31:

        ASSIGN fi-etiqueta:SCREEN-VALUE = ENTRY(i-aux, c-lista).

        APPLY "RETURN" TO fi-etiqueta.

    END.
    
    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirWord wWindow 
PROCEDURE piImprimirWord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-bcapi016  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-bc-ean    AS CHARACTER   NO-UNDO.
    

    session:set-wait-state ("general").

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Imprimindo").
    
    FOR EACH tt-etiquetas
        BREAK BY tt-etiquetas.nr-nota-fis:

        IF FIRST-OF(tt-etiquetas.nr-nota-fis) THEN DO:

            RUN pi-acompanhar IN h-acomp ("NF: " + tt-etiquetas.nr-nota-fis).
    
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/escep073-" + STRING(TIME) + ".docx".
        
            OS-COPY VALUE(SEARCH("esp/cep/escep073.docx")) VALUE(c-arquivo).
            
            CREATE "Word.Application" AppWord.
            AppWord:Documents:OPEN(c-arquivo).
            AppWord:VISIBLE = FALSE.

            ASSIGN i-pagina = 1.

            /**/

            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
                AND   nota-fiscal.serie       = tt-etiquetas.serie
                AND   nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis:
            END.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
            END.

            FOR FIRST filial-cliente NO-LOCK
                WHERE filial-cliente.cnpj = emitente.cgc:
            END.
            
            
            /* In¡cio Cabe‡alho */
            AppWord:ActiveWindow:ActivePane:View:SeekView = 9. /* wdSeekCurrentPageHeader */
            
            /* Emitente / Loja */
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(emitente.nome-emit).
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(IF AVAIL filial-cliente THEN filial-cliente.nr-filial + " - " + filial-cliente.nome-filial ELSE "").
            
            /* NF */
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(string(nota-fiscal.nr-nota-fis)).
            
            /* Fim Cabecalho */
            AppWord:ActiveWindow:ActivePane:View:SeekView = 0. /* wdSeekMainDocument */

            /* Posiciona o Cursor no in¡cio do documento */
            AppWord:Selection:HomeKey(6).

            /**/

            RUN piWordNovaPagina.

            ASSIGN i-linha = -1
                   i-regs = 0
                   c-lado = "".

        END.

        FOR EACH volume-nf NO-LOCK
            WHERE volume-nf.cod-estabel = tt-etiquetas.cod-estabel
            AND   volume-nf.serie       = tt-etiquetas.serie
            AND   volume-nf.nr-nota-fis = tt-etiquetas.nr-nota-fis
            AND   volume-nf.nr-volume   = tt-etiquetas.nr-volume:

            ASSIGN i-regs = i-regs + 1.

            IF NOT i-regs MOD 2 = 0 THEN DO:

                ASSIGN i-linha = i-linha + 2.

                IF i-linha = i-lins-por-pagina THEN
                    ASSIGN i-pagina = i-pagina + 1.

                IF NOT i-linha MOD 2 = 0 THEN
                    RUN piWordNovoQuadro.

            END.

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = volume-nf.it-codigo:
            END.

            FOR FIRST item-mat NO-LOCK
                WHERE item-mat.it-codigo = volume-nf.it-codigo:
            END.

            IF c-lado = "" OR c-lado = "D" THEN
                ASSIGN c-lado = "E".
            ELSE IF c-lado = "E" THEN
                ASSIGN c-lado = "D".

            RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.

            RUN generateEAN13 IN h-bcapi016 (INPUT SUBSTRING(item-mat.cod-ean,1,12),OUTPUT c-bc-ean).

            DELETE PROCEDURE h-bcapi016.
            ASSIGN h-bcapi016 = ?.

            IF c-lado = "E" THEN
                ASSIGN i-celula = 1.
            ELSE
                ASSIGN i-celula = 3.

            AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha):Cells:Item(i-celula):Select.
            AppWord:Selection:TypeText(substring(ITEM.desc-item,1,35)).
            AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):Cells:Item(i-celula):Select.
            AppWord:Selection:TypeText(c-bc-ean).
            AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):Cells:Item(i-celula + 1):Select.
            AppWord:Selection:TypeText(volume-nf.qtde).

        END.


        IF LAST-OF(tt-etiquetas.nr-nota-fis) THEN DO:

            RUN piWordTotal.

            AppWord:ActiveDocument:Save().
            AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).
            
            AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
            AppWord:QUIT().                                              /* Fechar o WORD */
            RELEASE OBJECT AppWord. 
            

            /*OS-DELETE VALUE(c-arquivo). TEMPORARIO, Sà PARA O EMERSON GERAR AS ETIQUETAS PARA MANAUS */

        END.



    END.

    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.

    session:set-wait-state ("").

    RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirWord-olda wWindow 
PROCEDURE piImprimirWord-olda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    DEFINE VARIABLE c-arquivo AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE AppWord AS COM-HANDLE       NO-UNDO.
    DEFINE VARIABLE i-cont AS INTEGER           NO-UNDO.
    DEFINE VARIABLE c-lado AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE c-bc-ean AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE h-bcapi016 AS HANDLE        NO-UNDO.
    DEFINE VARIABLE i-aux AS INTEGER     INIT 0 NO-UNDO.
    DEFINE VARIABLE i-total AS INTEGER          NO-UNDO.
    DEFINE VARIABLE h-acomp AS HANDLE           NO-UNDO.
    DEFINE VARIABLE i-cont-quadros AS INTEGER   NO-UNDO.


    /*
    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.nom_impressora = cPrinter
        AND   imprsor_usuar.cod_usuario    = v_cod_usuar_corren:
    END.

    IF NOT AVAIL imprsor_usuar OR
        imprsor_usuar.nom_disposit_so = "" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Impressora inv lida. Verifique se a impressora est  cadastrada para o usu rio e se o Dispositivo est  correto.").

        RETURN "NOK":u.

    END.
    */

    session:set-wait-state ("general").

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Imprimindo").
    
    FOR EACH tt-etiquetas
        BREAK BY tt-etiquetas.nr-nota-fis:

        IF FIRST-OF(tt-etiquetas.nr-nota-fis) THEN DO:

            RUN pi-acompanhar IN h-acomp ("NF: " + tt-etiquetas.nr-nota-fis).
    
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/escep073-" + STRING(TIME) + ".docx".
        
            OS-COPY VALUE(SEARCH("esp/cep/escep073.docx")) VALUE(c-arquivo).
            
            CREATE "Word.Application" AppWord.
            AppWord:Documents:OPEN(c-arquivo).
            AppWord:VISIBLE = FALSE.

            ASSIGN i-cont-quadros = 0.


            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = tt-etiquetas.cod-estabel
                AND   nota-fiscal.serie       = tt-etiquetas.serie
                AND   nota-fiscal.nr-nota-fis = tt-etiquetas.nr-nota-fis:
            END.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
            END.

            FOR FIRST filial-cliente NO-LOCK
                WHERE filial-cliente.cnpj = emitente.cgc:
            END.
            
            
            /* In¡cio Cabe‡alho */
            AppWord:ActiveWindow:ActivePane:View:SeekView = 9. /* wdSeekCurrentPageHeader */
            
            /*
            /* Fornecedor */
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(emitente.nome-emit).
            */
            
            /* Emitente / Loja */
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(emitente.nome-emit).
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(IF AVAIL filial-cliente THEN filial-cliente.nr-filial + " - " + filial-cliente.nome-filial ELSE "").
            
            /* NF */
            AppWord:Selection:MoveDown(5, 1).
            AppWord:Selection:EndKey(5). /* wdLine */
            AppWord:Selection:TypeText(string(nota-fiscal.nr-nota-fis)).
            
            /* Fim Cabecalho */
            AppWord:ActiveWindow:ActivePane:View:SeekView = 0. /* wdSeekMainDocument */

            /* Posiciona o Cursor no in¡cio do documento */
            AppWord:Selection:HomeKey(6).

            ASSIGN c-lado = ""
                   i-total = 0.

        END.

        FOR EACH volume-nf NO-LOCK
            WHERE volume-nf.cod-estabel = tt-etiquetas.cod-estabel
            AND   volume-nf.serie       = tt-etiquetas.serie
            AND   volume-nf.nr-nota-fis = tt-etiquetas.nr-nota-fis
            AND   volume-nf.nr-volume   = tt-etiquetas.nr-volume:

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = volume-nf.it-codigo:
            END.

            FOR FIRST item-mat NO-LOCK
                WHERE item-mat.it-codigo = volume-nf.it-codigo:
            END.

            IF c-lado = "" OR c-lado = "D" THEN
                ASSIGN c-lado = "E".
            ELSE IF c-lado = "E" THEN
                ASSIGN c-lado = "D".


            ASSIGN i-aux = i-aux + 1.

            RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.

            RUN generateEAN13 IN h-bcapi016 (INPUT SUBSTRING(item-mat.cod-ean,1,12),OUTPUT c-bc-ean).

            DELETE PROCEDURE h-bcapi016.
            ASSIGN h-bcapi016 = ?.

            IF c-lado = "E" THEN DO:
            
                ASSIGN i-cont-quadros = i-cont-quadros + 1.

                /* Cria novo Quadro */
                AppWord:Selection:MoveRight(1, 5, 1). /* Unit:=wdCharacter, Count:=5, Extend:=wdExtend */
                AppWord:Selection:MoveDown(5, 1, 1). /* Unit:=wdLine, Count:=1, Extend:=wdExtend */
                AppWord:Selection:MoveRight(1, 1, 1). /* Unit:=wdCharacter, Count:=1, Extend:=wdExtend */
                AppWord:Selection:Copy().

                /*
                IF i-cont-quadros = 14 THEN DO:

                    AppWord:Selection:InsertBreak(7).
                    AppWord:Selection:MoveDown(5, 1). /* Unit:=wdLine, Count:=1*/
                    AppWord:Selection:HomeKey(5).

                END.
                */
                

                AppWord:Selection:PasteAndFormat(16). /* wdFormatOriginalFormatting */
                AppWord:Selection:MoveUp(5, 2). /* Unit:=wdLine, Count:=2 */
                
                /* Dados do Item Esquerda */
                AppWord:Selection:TypeText(substring(ITEM.desc-item,1,35)).
            
                AppWord:Selection:MoveDown(5, 1). /* Unit:=wdLine, Count:=1*/
                AppWord:Application:WindowState = 0. /* wdWindowStateNormal */
                AppWord:Selection:TypeText(c-bc-ean).
            
                AppWord:Selection:MoveRight(12). /* Unit:=wdCell */
                AppWord:Selection:TypeText(volume-nf.qtde).

            END.
            ELSE DO:
        
                /* Dados do Item Direita */
                AppWord:Selection:MoveRight(12). /* Unit:=wdCell */
                AppWord:Selection:MoveUp(5, 1). /* Unit:=wdLine, Count:=1 */
                AppWord:Selection:TypeText(SUBSTRING(ITEM.desc-item,1,35)).
            
                AppWord:Selection:MoveDown(5, 1). /* Unit:=wdLine, Count:=1*/
                AppWord:Selection:TypeText(c-bc-ean).
            
                AppWord:Selection:MoveRight(12). /* Unit:=wdCell*/
                AppWord:Selection:TypeText(volume-nf.qtde). 
            
                /* Posiciona no pr¢ximo Quadro */
                AppWord:Selection:MoveDown(5, 1). /* Unit:=wdLine, Count:=1 */
                AppWord:Selection:MoveLeft(12, 3). /* Unit:=wdCell */

            END.

            ASSIGN i-total = i-total + volume-nf.qtde.
                
        END.

        IF LAST-OF(tt-etiquetas.nr-nota-fis) THEN DO:

            IF c-lado = "E" THEN DO:

                AppWord:Selection:MoveDown(5, 1). /* Unit:=wdLine, Count:=1 */
                AppWord:Selection:MoveLeft(2, 2). /*Unit:=wdWord, Count:=2 */

            END.

            AppWord:Selection:MoveRight(2, 7, 1). /* Unit:=wdWord, Count:=8, Extend:=wdExtend */
            AppWord:Selection:Rows:Delete().

            AppWord:Selection:EndKey(5). /* wdLine */
            /*AppWord:Selection:TypeText(i-total).*/
            AppWord:Selection:TypeText(i-nr-volumes).
            
            AppWord:Selection:HomeKey(6). /* Unit:=wdStory */

            AppWord:ActiveDocument:Save().

            /* ImpressÆo */
            /*AppWord:ActivePrinter = imprsor_usuar.nom_disposit_so.*/
            /*AppWord:ActivePrinter = "\\serv-printer-01\Finan-Laser".*/
            

            /*PrintOut([Background], [Append], [Range], [OutputFileName], [From], [To], [Item], [Copies], [Pages], [PageType], [PrintToFile], [Collate], [FileName], [ActivePrinterMacGX], [ManualDuplexPrint], [PrintZoomColumn], [PrintZoomRow], [PrintZoomPaperWidth], [PrintZoomPaperHeight])*/

            AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).

            /*
            IF INPUT FRAME fpage0 rs-saida = 1 THEN DO:

                AppWord:Application:PrintOut(TRUE,,0,,,,7,1,"",0,FALSE,TRUE,"",,,0,0,0,0).

                AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
                AppWord:QUIT().                                              /* Fechar o WORD */
                RELEASE OBJECT AppWord.                                      /* Elimina o endere»o utilizado para o WORD na mÿquina */

            END.
            ELSE
                AppWord:VISIBLE = TRUE.
                */

            /*
            AppWord:Application:PrintOut FileName:="", Range:=wdPrintAllDocument, Item:= _
            wdPrintDocumentWithMarkup, Copies:=1, Pages:="", PageType:= _
            wdPrintAllPages, Collate:=True, Background:=True, PrintToFile:=False, _
            PrintZoomColumn:=0, PrintZoomRow:=0, PrintZoomPaperWidth:=0, _
            PrintZoomPaperHeight:=0
            */

            /*AppWord:Documents:CLOSE(FALSE).*/
            /*AppWord:Application:QUIT(FALSE).*/
            
            /*AppWord:visible = true.*/

            /*OS-DELETE VALUE(c-arquivo).*/

            AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
            AppWord:QUIT().                                              /* Fechar o WORD */
            RELEASE OBJECT AppWord. 
            

            /*OS-DELETE VALUE(c-arquivo). TEMPORARIO, Sà PARA O EMERSON GERAR AS ETIQUETAS PARA MANAUS */

        END.

    END.

    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.

    session:set-wait-state ("").

    RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordNovaPagina wWindow 
PROCEDURE piWordNovaPagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pagina <> 1 THEN DO:

        AppWord:Selection:EndKey(6).
        AppWord:Selection:TypeParagraph.
        AppWord:Selection:InsertBreak(7).
        
        ASSIGN i-linha = 1
               i-regs = 1
               c-lado = "".
    END.

    AppWord:Selection:Tables:Add(AppWord:Selection:Range, 2, 4, 1, 0).
    
    AppWord:Selection:Tables:Item(1):Columns:ITEM(1):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(1):PreferredWidth = 8 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):PreferredWidth = 1.49 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(3):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(3):PreferredWidth = 8 *  28.35.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):PreferredWidthType = 3.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):PreferredWidth = 1.49 *  28.35.
    
    AppWord:Selection:Tables:Item(1):Borders:Item(-5):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-6):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-7):LineStyle = 0.
    AppWord:Selection:Tables:Item(1):Borders:Item(-8):LineStyle = 0.
    
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):LineStyle = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):LineWidth = 4.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(1):Borders:ITEM(-4):Color = -16777216.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):LineStyle = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):LineWidth = 4.
    AppWord:Selection:Tables:Item(1):Columns:Item(2):Cells:ITEM(2):Borders:ITEM(-4):Color = -16777216.

    AppWord:Selection:Tables:Item(1):Columns:Item(2):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.
    AppWord:Selection:Tables:Item(1):Columns:Item(4):Select.
    AppWord:Selection:ParagraphFormat:Alignment = 1.

    AppWord:Selection:Tables:Item(1):SELECT.
    AppWord:Selection:Cells:VerticalAlignment = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordNovoQuadro wWindow 
PROCEDURE piWordNovoQuadro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-linha <> 1 THEN DO:

        IF i-linha <= i-lins-por-pagina THEN DO:
            AppWord:Selection:InsertRowsBelow(1).
            AppWord:Selection:InsertRowsBelow(1).
        END.
        ELSE DO:

            RUN piWordNovaPagina.

        END.    

    END.

    AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha):HeightRule = 1.
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Height = 0.5 * 28.35.
    AppWord:Selection:Tables:Item(1):Rows:ITEM(i-linha + 1):HeightRule = 1.
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Height = 1.22 * 28.35.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(2):Select.
    AppWord:Selection:TypeText("QTDE").
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(4):Select.
    AppWord:Selection:TypeText("QTDE").
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
    AppWord:Selection:Borders:ITEM(-1):LineStyle = AppWord:Options:DefaultBorderLineStyle.
    AppWord:Selection:Borders:ITEM(-1):LineWidth = AppWord:Options:DefaultBorderLineWidth.
    AppWord:Selection:Borders:ITEM(-1):Color     = AppWord:Options:DefaultBorderColor.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(1):SELECT.
    AppWord:Selection:Font:Name = "EAN-13 Half Height".
    AppWord:Selection:Font:Size = 36.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(2):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(3):SELECT.
    AppWord:Selection:Font:Name = "EAN-13 Half Height".
    AppWord:Selection:Font:Size = 36.
    
    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha + 1):Cells:ITEM(4):SELECT.
    AppWord:Selection:Font:Name = "Calibri".
    AppWord:Selection:Font:Size = 11.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWordTotal wWindow 
PROCEDURE piWordTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-linha = i-linha + 2.

    AppWord:Selection:InsertRowsBelow(1).
    AppWord:Selection:Cells:Merge.

    AppWord:Selection:Borders:ITEM(-1):LineStyle = AppWord:Options:DefaultBorderLineStyle.
    AppWord:Selection:Borders:ITEM(-1):LineWidth = AppWord:Options:DefaultBorderLineWidth.
    AppWord:Selection:Borders:ITEM(-1):Color     = AppWord:Options:DefaultBorderColor.

    AppWord:Selection:ParagraphFormat:Alignment = 0.
    AppWord:Selection:Font:Size = 14.
    AppWord:Selection:Font:Bold = 9999998.

    AppWord:Selection:Tables:Item(1):Rows:Item(i-linha):Cells:ITEM(1):Select.
    AppWord:Selection:TypeText("NRO. VOLUMES: " + STRING(i-nr-volumes)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

