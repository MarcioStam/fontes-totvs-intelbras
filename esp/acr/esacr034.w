&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE VARIABLE c-lista      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuario    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hShowMsg     AS HANDLE      NO-UNDO.
DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.


DEFINE TEMP-TABLE tt-int-emitente-supcard-ocor NO-UNDO
    FIELD cnpj-cliente              AS CHARACTER FORMAT "x(14)"
    FIELD nome-matriz               LIKE emitente.nome-emit
    FIELD dat-avaliacao             LIKE int-emitente-supcard-ocor.dat-avaliacao
    FIELD seq-avaliacao             LIKE int-emitente-supcard-ocor.seq-avaliacao
    FIELD val-limite-sugerido       LIKE int-emitente-supcard-ocor.val-limite-sugerido
    FIELD emergencial               AS CHARACTER FORMAT "x(01)"
    FIELD ativo                     AS CHARACTER FORMAT "x(01)".

DEFINE TEMP-TABLE tt-filial NO-UNDO
    FIELD cnpj-cliente AS CHARACTER FORMAT "x(14)"
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD ativo        AS CHARACTER FORMAT "x(01)".

{method/dbotterr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brFilial

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-filial tt-int-emitente-supcard-ocor

/* Definitions for BROWSE brFilial                                      */
&Scoped-define FIELDS-IN-QUERY-brFilial tt-filial.cnpj-cliente tt-filial.ativo tt-filial.cod-emitente tt-filial.nome-emit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brFilial   
&Scoped-define SELF-NAME brFilial
&Scoped-define QUERY-STRING-brFilial FOR EACH tt-filial
&Scoped-define OPEN-QUERY-brFilial OPEN QUERY {&SELF-NAME} FOR EACH tt-filial.
&Scoped-define TABLES-IN-QUERY-brFilial tt-filial
&Scoped-define FIRST-TABLE-IN-QUERY-brFilial tt-filial


/* Definitions for BROWSE brOcorEmit                                    */
&Scoped-define FIELDS-IN-QUERY-brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente tt-int-emitente-supcard-ocor.ativo tt-int-emitente-supcard-ocor.val-limite-sugerido tt-int-emitente-supcard-ocor.emergencial tt-int-emitente-supcard-ocor.nome-matriz   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente ~
tt-int-emitente-supcard-ocor.val-limite-sugerido ~
tt-int-emitente-supcard-ocor.emergencial   
&Scoped-define ENABLED-TABLES-IN-QUERY-brOcorEmit ~
tt-int-emitente-supcard-ocor
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brOcorEmit tt-int-emitente-supcard-ocor
&Scoped-define SELF-NAME brOcorEmit
&Scoped-define QUERY-STRING-brOcorEmit FOR EACH  tt-int-emitente-supcard-ocor
&Scoped-define OPEN-QUERY-brOcorEmit OPEN QUERY {&SELF-NAME} FOR EACH  tt-int-emitente-supcard-ocor.
&Scoped-define TABLES-IN-QUERY-brOcorEmit tt-int-emitente-supcard-ocor
&Scoped-define FIRST-TABLE-IN-QUERY-brOcorEmit tt-int-emitente-supcard-ocor


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brFilial}~
    ~{&OPEN-QUERY-brOcorEmit}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar brOcorEmit btIncluir btAlterar ~
btExcluir brFilial btOK btCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar o registro corrente".

DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 10 BY 1 TOOLTIP "Excluir o registro corrente".

DEFINE BUTTON btIncluir 
     LABEL "Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir um novo registro".

DEFINE BUTTON btOK 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brFilial FOR 
      tt-filial SCROLLING.

DEFINE QUERY brOcorEmit FOR 
      tt-int-emitente-supcard-ocor SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brFilial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFilial C-Win _FREEFORM
  QUERY brFilial DISPLAY
      tt-filial.cnpj-cliente WIDTH 20 COLUMN-LABEL "CNPJ Cliente"
      tt-filial.ativo                 COLUMN-LABEL "Ativo? (S/N)"
      tt-filial.cod-emitente WIDTH 10 COLUMN-LABEL "C¢digo"
      tt-filial.nome-emit    WIDTH 45 COLUMN-LABEL "Nome"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 5.21
         FONT 1
         TITLE "Filiais".

DEFINE BROWSE brOcorEmit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOcorEmit C-Win _FREEFORM
  QUERY brOcorEmit DISPLAY
      tt-int-emitente-supcard-ocor.cnpj-cliente         WIDTH 20 COLUMN-LABEL "CNPJ Cliente"
      tt-int-emitente-supcard-ocor.ativo                         COLUMN-LABEL "Ativo? (S/N)"
      tt-int-emitente-supcard-ocor.val-limite-sugerido  WIDTH 16
      tt-int-emitente-supcard-ocor.emergencial          WIDTH 14 COLUMN-LABEL "Emergencial? (S/N)"
      tt-int-emitente-supcard-ocor.nome-matriz          WIDTH 45 COLUMN-LABEL "Nome"
   ENABLE
      tt-int-emitente-supcard-ocor.cnpj-cliente
      tt-int-emitente-supcard-ocor.val-limite-sugerido
      tt-int-emitente-supcard-ocor.emergencial
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 8.75
         FONT 1
         TITLE "Novos Clientes para a SupplierCard".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brOcorEmit AT ROW 1.17 COL 2
     btIncluir AT ROW 9.92 COL 2
     btAlterar AT ROW 9.92 COL 12
     btExcluir AT ROW 9.92 COL 22
     brFilial AT ROW 11.17 COL 2
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 12.43
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
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
         TITLE              = "Ocorràncias do Emitente - SupplierCard"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brOcorEmit rtToolBar DEFAULT-FRAME */
/* BROWSE-TAB brFilial btExcluir DEFAULT-FRAME */
ASSIGN 
       brFilial:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE
       brFilial:COLUMN-MOVABLE IN FRAME DEFAULT-FRAME         = TRUE.

ASSIGN 
       brOcorEmit:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE
       brOcorEmit:COLUMN-MOVABLE IN FRAME DEFAULT-FRAME         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFilial
/* Query rebuild information for BROWSE brFilial
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-filial.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brFilial */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOcorEmit
/* Query rebuild information for BROWSE brOcorEmit
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH  tt-int-emitente-supcard-ocor.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brOcorEmit */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Ocorràncias do Emitente - SupplierCard */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Ocorràncias do Emitente - SupplierCard */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOcorEmit
&Scoped-define SELF-NAME brOcorEmit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOcorEmit C-Win
ON ROW-LEAVE OF brOcorEmit IN FRAME DEFAULT-FRAME /* Novos Clientes para a SupplierCard */
DO:
    IF  brOcorEmit:NEW-ROW IN FRAME default-frame THEN DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        CREATE tt-int-emitente-supcard-ocor.
        ASSIGN INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.val-limite-sugerido
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.emergencial
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.nome-matriz.
    
        brOcorEmit:CREATE-RESULT-LIST-ENTRY() IN FRAME default-frame.
    END.
    ELSE DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        ASSIGN INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.val-limite-sugerido
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.emergencial
               INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.nome-matriz.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOcorEmit C-Win
ON VALUE-CHANGED OF brOcorEmit IN FRAME DEFAULT-FRAME /* Novos Clientes para a SupplierCard */
DO:
    RUN pi-cria-filiais.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar C-Win
ON CHOOSE OF btAlterar IN FRAME DEFAULT-FRAME /* Alterar */
DO:
    APPLY "ENTRY" TO tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir C-Win
ON CHOOSE OF btExcluir IN FRAME DEFAULT-FRAME /* Excluir */
DO:
    RUN pi-exclui-registro IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir C-Win
ON CHOOSE OF btIncluir IN FRAME DEFAULT-FRAME /* Incluir */
DO:
    RUN pi-cria-registro IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        APPLY "CHOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFilial
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.


ON "MOUSE-SELECT-DBLCLICK":U OF tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit OR
   "F5":U                    OF tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit DO:
    IF AVAILABLE tt-int-emitente-supcard-ocor THEN DO:
        {method/zoomfields.i &ProgramZoom="adzoom/z23ad098.w"
                             &FieldZoom1="cod-emitente"
                             &FieldScreen1="tt-int-emitente-supcard-ocor.cnpj-cliente"
                             &Browse1="brOcorEmit"
                             &FieldZoom2="nome-matriz"
                             &FieldScreen2="tt-int-emitente-supcard-ocor.nome-matriz"
                             &Browse2="brOcorEmit"
                             &enableImplant="NO"}
                         
        WAIT-FOR "CLOSE" OF hProgramZoom.

        APPLY "LEAVE":U TO tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit.
    END.
END.


ON "LEAVE":U OF tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit DO:
    IF  AVAIL tt-int-emitente-supcard-ocor THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = INT(INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente) NO-ERROR.
        IF AVAILABLE emitente THEN DO:
            FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

            ASSIGN tt-int-emitente-supcard-ocor.cnpj-cliente:SCREEN-VALUE IN BROWSE brOcorEmit = emitente.cgc
                   tt-int-emitente-supcard-ocor.nome-matriz:SCREEN-VALUE  IN BROWSE brOcorEmit = emitente.nome-emit
                   tt-int-emitente-supcard-ocor.ativo:SCREEN-VALUE        IN BROWSE brOcorEmit = IF AVAILABLE int-emitente THEN (IF int-emitente.id-ativo THEN "S" ELSE "N") ELSE "".

            ASSIGN INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente
                                           tt-int-emitente-supcard-ocor.nome-matriz
                                           tt-int-emitente-supcard-ocor.ativo.
    
            APPLY "VALUE-CHANGED":U TO BROWSE brOcorEmit.
        END.
    END.
END.


ON "RETURN":U OF tt-int-emitente-supcard-ocor.emergencial IN BROWSE brOcorEmit DO:
    APPLY "CHOOSE" TO btIncluir IN FRAME default-frame.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN initializeObjects.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
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
  ENABLE rtToolBar brOcorEmit btIncluir btAlterar btExcluir brFilial btOK 
         btCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObjects C-Win 
PROCEDURE initializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ENABLE brOcorEmit
           btIncluir
        WITH FRAME default-frame.

    RUN pi-controle-browse.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controle-browse C-Win 
PROCEDURE pi-controle-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  CAN-FIND(FIRST tt-int-emitente-supcard-ocor) THEN DO:
        ENABLE btAlterar
               btExcluir
            WITH FRAME default-frame.
    END.
    ELSE DO:
        DISABLE btAlterar
                btExcluir
            WITH FRAME default-frame.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-filiais C-Win 
PROCEDURE pi-cria-filiais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-filial.

    IF AVAILABLE tt-int-emitente-supcard-ocor                   AND
       tt-int-emitente-supcard-ocor.cnpj-cliente          <> ?  AND
       tt-int-emitente-supcard-ocor.cnpj-cliente          <> "" AND
       DECIMAL(tt-int-emitente-supcard-ocor.cnpj-cliente) <> 0  THEN DO:
        FOR EACH emitente NO-LOCK USE-INDEX cgc
            WHERE emitente.cgc BEGINS SUBSTRING(tt-int-emitente-supcard-ocor.cnpj-cliente, 1, 8):
            IF emitente.cgc = INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente THEN NEXT.

            FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

            CREATE tt-filial.
            ASSIGN tt-filial.cnpj-cliente = emitente.cgc
                   tt-filial.cod-emitente = emitente.cod-emitente
                   tt-filial.nome-emit    = emitente.nome-emit
                   tt-filial.ativo        = IF AVAILABLE int-emitente THEN (IF int-emitente.id-ativo THEN "S" ELSE "N") ELSE "".
        END.
    END.

    {&OPEN-QUERY-brFilial}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro C-Win 
PROCEDURE pi-cria-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.

    DO TRANSACTION:
        CREATE tt-int-emitente-supcard-ocor.
        ASSIGN r-rowid = ROWID(tt-int-emitente-supcard-ocor).
        {&OPEN-QUERY-brOcorEmit}
        REPOSITION brOcorEmit TO ROWID r-rowid.
        APPLY "VALUE-CHANGED" TO brOcorEmit IN FRAME DEFAULT-FRAME.
        APPLY "ENTRY" TO tt-int-emitente-supcard-ocor.cnpj-cliente IN BROWSE brOcorEmit.
    END.

    RUN pi-controle-browse IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-registro C-Win 
PROCEDURE pi-exclui-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  brOcorEmit:NUM-SELECTED-ROWS IN FRAME default-frame = 1 THEN DO:
        FIND FIRST tt-int-emitente-supcard-ocor EXCLUSIVE-LOCK
            WHERE  tt-int-emitente-supcard-ocor.cnpj-cliente = INPUT BROWSE brOcorEmit tt-int-emitente-supcard-ocor.cnpj-cliente NO-ERROR.
        IF  AVAIL  tt-int-emitente-supcard-ocor THEN
            DELETE tt-int-emitente-supcard-ocor.

        IF  brOcorEmit:DELETE-CURRENT-ROW() IN FRAME default-frame THEN.
    END.

    {&OPEN-QUERY-brOcorEmit}

    APPLY "VALUE-CHANGED":U TO brOcorEmit IN FRAME DEFAULT-FRAME.

    RUN pi-controle-browse IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar C-Win 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  c-seg-usuario = "" THEN
        ASSIGN c-usuario = v_cod_usuar_corren.
    ELSE
        ASSIGN c-usuario = c-seg-usuario.

    
    EMPTY TEMP-TABLE rowErrors.
    FOR EACH tt-int-emitente-supcard-ocor NO-LOCK:
        FIND FIRST emitente
            WHERE emitente.cgc = tt-int-emitente-supcard-ocor.cnpj-cliente NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE emitente THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cliente n∆o localizado"
                   rowErrors.ErrorHelp        = "O cliente (" + tt-int-emitente-supcard-ocor.nome-matriz + ") n∆o foi localizado!".
            NEXT.
        END.

        FIND FIRST int-emitente
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE int-emitente THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cliente inativo"
                   rowErrors.ErrorHelp        = "O cliente (" + tt-int-emitente-supcard-ocor.nome-matriz + ") est† inativo!".
            NEXT.
        END.

        /* Valida se o cliente (raiz CNPJ) j† tem cart∆o Intelbras Clube */
        IF  CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                     WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(tt-int-emitente-supcard-ocor.cnpj-cliente,1,8)) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cliente j† possui cart∆o Intelbras Clube"
                   rowErrors.ErrorHelp        = "O cliente (" + tt-int-emitente-supcard-ocor.nome-matriz + ") j† possui cart∆o Intelbras Clube!".
            NEXT.
        END.

        /* Valida se o cliente j† tem uma pendància de Novo Cliente */
        IF  CAN-FIND(FIRST int-pendencias-supcard NO-LOCK
                     WHERE int-pendencias-supcard.cnpj-cliente = tt-int-emitente-supcard-ocor.cnpj-cliente
                     AND   int-pendencias-supcard.identific    = 98 /* Solicitaá∆o de Novo Cliente */
                     AND   int-pendencias-supcard.dat-envio    = ?) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Solicitaá∆o de Novo Cliente j† cadastrada para o Cliente!"
                   rowErrors.ErrorHelp        = "O cliente (" + tt-int-emitente-supcard-ocor.nome-matriz + ") j† possui uma solicitaá∆o de Novo Cliente cadastrada!".
            NEXT.
        END.

        CREATE int-pendencias-supcard.
        ASSIGN int-pendencias-supcard.cod-usuar           = c-usuario
               int-pendencias-supcard.cnpj-cliente        = tt-int-emitente-supcard-ocor.cnpj-cliente
               int-pendencias-supcard.dat-criacao         = TODAY
               int-pendencias-supcard.identific           = 98 /* Solicitaá∆o de Novo Cliente */
               int-pendencias-supcard.log-manual          = YES
               int-pendencias-supcard.log-emergencial     = IF tt-int-emitente-supcard-ocor.emergencial = "s" THEN YES ELSE NO
               int-pendencias-supcard.tipo-bloqueio       = ?
               int-pendencias-supcard.val-limite-sugerido = tt-int-emitente-supcard-ocor.val-limite-sugerido.
    END.

    /* Caso tenha erro, exibe em tela */
    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/ShowMessage.i1}
        {method/ShowMessage.i2 &Modal="YES"}
        {method/ShowMessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Pendàncias de solicitaá∆o de novos clientes geradas com sucesso!":U).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

