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
{include/i-prgvrs.i ESCLT009 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT009
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-etiqueta bt-imprimir bt-apagar bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-etiquetas
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-volume         LIKE volume-nf.nr-volume
    FIELD it-codigo         LIKE volume-nf.it-codigo
    INDEX id cod-estabel serie nr-nota-fis nr-volume it-codigo.

DEF VAR c-anterior      AS CHAR.
DEF VAR c-caixa-atu     AS CHAR.
DEF VAR c-caixa         AS CHAR.
DEF VAR i-quant-cx      AS INT.
DEF VAR i-quant-pt      AS INT.
DEF VAR i-cont          AS INT.
DEF VAR i-contEtiq      AS INT.
DEF VAR l-erro          AS LOG.
DEF VAR c-acao          AS CHAR.
DEF VAR l-ok            AS LOG.
DEF VAR l-reincorpora   AS LOG.

DEFINE VARIABLE v-it-codigo LIKE item.it-codigo NO-UNDO.

DEF BUFFER b-ns-volume FOR ns-volume.

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
&Scoped-Define ENABLED-OBJECTS RECT-17 fi-etiqueta br-etiquetas bt-imprimir ~
bt-apagar bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-etiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-apagar 
     LABEL "Apagar" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE BUTTON bt-imprimir 
     LABEL "Imprimir" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 182 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 36.

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
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 9
          &ELSE SIZE-PIXELS 308 BY 210 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-etiqueta AT Y 12 X 70 COLON-ALIGNED WIDGET-ID 2
     br-etiquetas AT Y 48 X 7 WIDGET-ID 200
     bt-imprimir AT Y 258 X 7 WIDGET-ID 50
     bt-apagar AT Y 258 X 188 WIDGET-ID 48
     bt-sair AT Y 258 X 252 WIDGET-ID 40
     RECT-17 AT Y 6 X 7 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 408
         MAX-WIDTH-P        = 630
         VIRTUAL-HEIGHT-P   = 408
         VIRTUAL-WIDTH-P    = 630
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB br-etiquetas fi-etiqueta fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

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


&Scoped-define SELF-NAME bt-apagar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-apagar wWindow
ON CHOOSE OF bt-apagar IN FRAME fpage0 /* Apagar */
DO:

     ASSIGN i-nr-volumes = 0.

    FOR EACH tt-etiquetas:
        DELETE tt-etiquetas.
    END.

    {&open-query-br-etiquetas}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir wWindow
ON CHOOSE OF bt-imprimir IN FRAME fpage0 /* Imprimir */
DO:


    RUN piImprimirWord.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON RETURN OF fi-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:

    /*104 001 0272665 0001*/

    ASSIGN c-cod-estabel = SUBSTRING(SELF:SCREEN-VALUE, 1, 3)
           c-serie       = string(int(SUBSTRING(SELF:SCREEN-VALUE, 4, 3)))
           c-nr-nota-fis = SUBSTRING(SELF:SCREEN-VALUE, 7, 7)
           i-volume      = int(SUBSTRING(SELF:SCREEN-VALUE,14,4)).

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

            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Volume j  foi lido.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
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
    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

    /*
FOR EACH tt-etiqueta:
      DELETE tt-etiqueta.
  END.
  ASSIGN c-anterior = "".
    
  {&OPEN-QUERY-{&BROWSE-NAME}}
*/

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

    ASSIGN i-nr-volumes = 0.

    

    RETURN "OK":U.


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
    
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esclt009-" + STRING(TIME) + ".docx".
        
            OS-COPY VALUE(SEARCH("esp/clt/esclt009.docx")) VALUE(c-arquivo).
            
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

