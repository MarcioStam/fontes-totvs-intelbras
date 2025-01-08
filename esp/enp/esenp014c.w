&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-estrut-astec NO-UNDO LIKE estrut-astec
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP014C 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP014C
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER p-acao       AS CHAR         NO-UNDO.
DEFINE INPUT PARAMETER p-it-pai     AS CHAR         NO-UNDO.
DEFINE INPUT PARAMETER p-rw-filho   AS ROWID        NO-UNDO.
DEFINE INPUT PARAMETER p-bo-filho   AS HANDLE       NO-UNDO.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-estrut-astec.it-codigo ~
tt-estrut-astec.sequencia tt-estrut-astec.es-codigo ~
tt-estrut-astec.quantidade 
&Scoped-define ENABLED-TABLES tt-estrut-astec
&Scoped-define FIRST-ENABLED-TABLE tt-estrut-astec
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-2 RECT-3 fi-desc-item ~
fi-desc-comp btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-estrut-astec.it-codigo ~
tt-estrut-astec.sequencia tt-estrut-astec.es-codigo ~
tt-estrut-astec.quantidade 
&Scoped-define DISPLAYED-TABLES tt-estrut-astec
&Scoped-define FIRST-DISPLAYED-TABLE tt-estrut-astec
&Scoped-Define DISPLAYED-OBJECTS fi-desc-item fi-desc-comp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-estrut-astec.it-codigo AT ROW 1.5 COL 17 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-item AT ROW 1.5 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tt-estrut-astec.sequencia AT ROW 2.5 COL 17 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-estrut-astec.es-codigo AT ROW 3.5 COL 17 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-comp AT ROW 3.5 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-estrut-astec.quantidade AT ROW 5.25 COL 17 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 14.72 BY .88
     btOK AT ROW 6.96 COL 2
     btCancel AT ROW 6.96 COL 13
     btHelp2 AT ROW 6.96 COL 80
     rtToolBar AT ROW 6.75 COL 1
     RECT-2 AT ROW 1.25 COL 2 WIDGET-ID 2
     RECT-3 AT ROW 5 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-estrut-astec T "?" NO-UNDO mgesp estrut-astec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 7.17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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

    RUN pi-salvar.

    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-estrut-astec.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-estrut-astec.es-codigo wWindow
ON F5 OF tt-estrut-astec.es-codigo IN FRAME fpage0 /* Componente */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="tt-estrut-astec.es-codigo"    
                       &campo2="fi-desc-comp"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="fpage0"
                       &frame2="fpage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-estrut-astec.es-codigo wWindow
ON LEAVE OF tt-estrut-astec.es-codigo IN FRAME fpage0 /* Componente */
DO:

    ASSIGN fi-desc-comp = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = SELF:SCREEN-VALUE:

        ASSIGN fi-desc-comp = ITEM.desc-item.

    END.

    DISP fi-desc-comp WITH FRAME fPage0.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-estrut-astec.es-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-estrut-astec.es-codigo IN FRAME fpage0 /* Componente */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-estrut-astec.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-estrut-astec.it-codigo wWindow
ON LEAVE OF tt-estrut-astec.it-codigo IN FRAME fpage0 /* Item */
DO:

    ASSIGN fi-desc-item = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = SELF:SCREEN-VALUE:

        ASSIGN fi-desc-item = ITEM.desc-item.

    END.

    DISP fi-desc-item WITH FRAME fPage0.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


tt-estrut-astec.es-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    RUN pi-exibe.

    DO WITH FRAME fpage0:

        IF p-acao = "CREATE" THEN DO:
    
            ASSIGN tt-estrut-astec.sequencia:SENSITIVE = TRUE
                   tt-estrut-astec.es-codigo:SENSITIVE = TRUE.
    
        END.
    
        ASSIGN tt-estrut-astec.quantidade:SENSITIVE = TRUE.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erros wWindow 
PROCEDURE pi-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.


    RUN getRowErrors IN p-bo-filho (OUTPUT TABLE RowErrors).

  
    EMPTY temp-table tt-erro.

    FOR EACH RowErrors:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).

        ASSIGN c-mensagem = RETURN-VALUE.

        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
               tt-erro.cd-erro  = RowErrors.ErrorNumber
               tt-erro.mensagem = c-mensagem.

    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exibe wWindow 
PROCEDURE pi-exibe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.


    EMPTY TEMP-TABLE tt-estrut-astec.

    IF p-acao = "CREATE" THEN DO:

        RUN pi-busca-prox-seq IN p-bo-filho(INPUT p-it-pai,
                                            OUTPUT i-seq).

        CREATE tt-estrut-astec.
        ASSIGN tt-estrut-astec.it-codigo = p-it-pai
               tt-estrut-astec.sequencia = i-seq.

    END.

    IF p-acao = "UPDATE" THEN DO:

        RUN repositionRecord IN p-bo-filho (INPUT p-rw-filho).

        RUN getRecord IN p-bo-filho (OUTPUT TABLE tt-estrut-astec).

        FOR FIRST tt-estrut-astec:
        END.

    END.

    DISP tt-estrut-astec.it-codigo
         tt-estrut-astec.sequencia
         tt-estrut-astec.es-codigo
         tt-estrut-astec.quantidade 
        WITH FRAME fPage0.

    APPLY "LEAVE" TO tt-estrut-astec.it-codigo.

    IF p-acao = "UPDATE" THEN
        APPLY "LEAVE" TO tt-estrut-astec.es-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN emptyRowErrors IN p-bo-filho.

    DO WITH FRAME fPage0:

        ASSIGN tt-estrut-astec.it-codigo   
               tt-estrut-astec.sequencia
               tt-estrut-astec.es-codigo
               tt-estrut-astec.quantidade.

    END.

    IF p-acao = "CREATE" THEN DO:
        RUN newRecord IN p-bo-filho.
    END.

    RUN setRecord IN p-bo-filho (INPUT TABLE tt-estrut-astec).

    RUN validateRecord IN p-bo-filho (INPUT p-acao).

    IF RETURN-VALUE = "NOK" THEN DO:
        RUN pi-erros.
        RETURN "NOK":U.
    END.

    IF p-acao = "CREATE" THEN
        RUN createRecord IN p-bo-filho.

    IF p-acao = "UPDATE" THEN
        RUN updateRecord IN p-bo-filho.

    RUN pi-erros.

    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

