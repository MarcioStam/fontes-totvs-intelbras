&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cidade NO-UNDO LIKE mgcad.cidade
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-cidade-diverg NO-UNDO LIKE cidade-diverg
       field r-rowid as rowid.



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

{include/i-prgvrs.i ESCDP041 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP041
&GLOBAL-DEFINE Version        2.00.00.000

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE BUFFER bf-cidade     FOR mgcad.cidade.
DEFINE BUFFER bf-cidade-div FOR cidade-diverg.
DEFINE BUFFER bf-cep        FOR cep.

DEFINE VARIABLE hAcomp AS HANDLE      NO-UNDO.

DEFINE VARIABLE  c-cidade-ini  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-estado-ini  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-cidade-div-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-estado-div-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cont             AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-selected-rows NO-UNDO
    FIELD r-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brCad

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cidade tt-cidade-diverg

/* Definitions for BROWSE brCad                                         */
&Scoped-define FIELDS-IN-QUERY-brCad tt-cidade.cidade tt-cidade.estado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brCad   
&Scoped-define SELF-NAME brCad
&Scoped-define QUERY-STRING-brCad FOR EACH tt-cidade NO-LOCK
&Scoped-define OPEN-QUERY-brCad OPEN QUERY {&SELF-NAME} FOR EACH tt-cidade NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brCad tt-cidade
&Scoped-define FIRST-TABLE-IN-QUERY-brCad tt-cidade


/* Definitions for BROWSE brDiv                                         */
&Scoped-define FIELDS-IN-QUERY-brDiv tt-cidade-diverg.cidade tt-cidade-diverg.estado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDiv   
&Scoped-define SELF-NAME brDiv
&Scoped-define QUERY-STRING-brDiv FOR EACH tt-cidade-diverg NO-LOCK
&Scoped-define OPEN-QUERY-brDiv OPEN QUERY {&SELF-NAME} FOR EACH tt-cidade-diverg NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDiv tt-cidade-diverg
&Scoped-define FIRST-TABLE-IN-QUERY-brDiv tt-cidade-diverg


/* Definitions for FRAME FRAME-A                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-FRAME-A ~
    ~{&OPEN-QUERY-brCad}~
    ~{&OPEN-QUERY-brDiv}

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAtualiza 
     LABEL "Atualizar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btCadCidade 
     LABEL "Implantar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fiCidadeCad AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE fiCidadeDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE rsCidadeCad AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cidade", 1,
"Estado", 2
     SIZE 21 BY .75 NO-UNDO.

DEFINE VARIABLE rsCidadeDiv AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cidade", 1,
"Estado", 2
     SIZE 21 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 13.29.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 13.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brCad FOR 
      tt-cidade SCROLLING.

DEFINE QUERY brDiv FOR 
      tt-cidade-diverg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brCad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brCad C-Win _FREEFORM
  QUERY brCad NO-LOCK DISPLAY
      tt-cidade.cidade FORMAT "x(25)":U
      tt-cidade.estado COLUMN-LABEL "Estado" FORMAT "x(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 35.14 BY 10 FIT-LAST-COLUMN.

DEFINE BROWSE brDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDiv C-Win _FREEFORM
  QUERY brDiv NO-LOCK DISPLAY
      tt-cidade-diverg.cidade FORMAT "x(25)":U
      tt-cidade-diverg.estado FORMAT "x(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 35 BY 10 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.14 BY 16.63 WIDGET-ID 100.

DEFINE FRAME FRAME-A
     rsCidadeCad AT ROW 3 COL 12 NO-LABEL
     rsCidadeDiv AT ROW 3 COL 67.72 NO-LABEL WIDGET-ID 10
     fiCidadeCad AT ROW 3.92 COL 5.14
     fiCidadeDiv AT ROW 3.92 COL 61 WIDGET-ID 8
     brCad AT ROW 5.04 COL 4.86 WIDGET-ID 300
     brDiv AT ROW 5.04 COL 61 WIDGET-ID 400
     btAtualiza AT ROW 9.29 COL 43 WIDGET-ID 2
     btCadCidade AT ROW 15.67 COL 4.14
     "Cidades Cadastradas" VIEW-AS TEXT
          SIZE 20 BY .63 AT ROW 2 COL 5.29
     "Cidades Divergentes" VIEW-AS TEXT
          SIZE 20 BY 1 AT ROW 1.79 COL 61.43
     RECT-1 AT ROW 2.25 COL 4 WIDGET-ID 4
     RECT-2 AT ROW 2.25 COL 60 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.57 ROW 1.25
         SIZE 99 BY 16.25 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-cidade T "?" NO-UNDO mgcad cidade
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-cidade-diverg T "?" NO-UNDO mgesp cidade-diverg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Atualizar Cidades Divergentes"
         HEIGHT             = 16.63
         WIDTH              = 100.14
         MAX-HEIGHT         = 30.38
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.38
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME FRAME-A
                                                                        */
/* BROWSE-TAB brCad fiCidadeDiv FRAME-A */
/* BROWSE-TAB brDiv brCad FRAME-A */
/* SETTINGS FOR FILL-IN fiCidadeCad IN FRAME FRAME-A
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiCidadeDiv IN FRAME FRAME-A
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brCad
/* Query rebuild information for BROWSE brCad
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cidade NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brCad */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDiv
/* Query rebuild information for BROWSE brDiv
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cidade-diverg NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDiv */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Atualizar Cidades Divergentes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Atualizar Cidades Divergentes */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brCad
&Scoped-define FRAME-NAME FRAME-A
&Scoped-define SELF-NAME brCad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brCad C-Win
ON MOUSE-SELECT-CLICK OF brCad IN FRAME FRAME-A
DO:
    RUN pi-habilita-browse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDiv
&Scoped-define SELF-NAME brDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDiv C-Win
ON MOUSE-SELECT-CLICK OF brDiv IN FRAME FRAME-A
DO:
   RUN pi-habilita-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza C-Win
ON CHOOSE OF btAtualiza IN FRAME FRAME-A /* Atualizar */
DO:
    RUN utp/ut-msgs.p(INPUT "SHOW",
                      INPUT 701,
                      INPUT "Atualiza‡Æo do cadastro de CEP").

    IF AVAIL tt-cidade AND RETURN-VALUE = "YES" THEN DO:
        RUN pi-atualizar-cep.
        RUN pi-busca-cidade-cad.
        RUN pi-busca-cidade-div.
        RUN pi-habilita-browse.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCadCidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCadCidade C-Win
ON CHOOSE OF btCadCidade IN FRAME FRAME-A /* Implantar */
DO:
  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("":U).
  ASSIGN {&window-name}:SENSITIVE = NO.

  RUN cdp/cd0330.w.

  ASSIGN {&window-name}:SENSITIVE = YES.

  RUN pi-busca-cidade-cad.
  RUN pi-habilita-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCidadeCad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCidadeCad C-Win
ON LEAVE OF fiCidadeCad IN FRAME FRAME-A /* Buscar */
DO:
    IF SELF:MODIFIED THEN DO:
        RUN pi-busca-cidade-cad.
         RUN pi-habilita-browse.
        ASSIGN  SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCidadeDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCidadeDiv C-Win
ON LEAVE OF fiCidadeDiv IN FRAME FRAME-A /* Buscar */
DO:
    IF SELF:MODIFIED THEN DO:
        RUN pi-busca-cidade-div.
         RUN pi-habilita-browse.
        ASSIGN  SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsCidadeCad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsCidadeCad C-Win
ON VALUE-CHANGED OF rsCidadeCad IN FRAME FRAME-A
DO:
  IF SELF:MODIFIED THEN DO:
        RUN pi-busca-cidade-cad.
         RUN pi-habilita-browse.
        ASSIGN  SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsCidadeDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsCidadeDiv C-Win
ON VALUE-CHANGED OF rsCidadeDiv IN FRAME FRAME-A
DO:
  IF SELF:MODIFIED THEN DO:
        RUN pi-busca-cidade-div.
         RUN pi-habilita-browse.
        ASSIGN  SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brCad
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    ASSIGN hAcomp = ?.

    RUN disable_UI.
END.
   

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  RUN pi-busca-cidade-cad.
  RUN pi-busca-cidade-div.

  IF CAN-FIND(FIRST tt-cidade) THEN DO:
     brCad:DESELECT-ROWS().
  END.

  IF CAN-FIND(FIRST tt-cidade-diverg) THEN DO:
     brDiv:DESELECT-ROWS().
  END.

  ASSIGN btAtualiza:SENSITIVE IN FRAME FRAME-A = NO.

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
  VIEW FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY rsCidadeCad rsCidadeDiv fiCidadeCad fiCidadeDiv 
      WITH FRAME FRAME-A IN WINDOW C-Win.
  ENABLE RECT-1 RECT-2 rsCidadeCad rsCidadeDiv fiCidadeCad fiCidadeDiv brCad 
         brDiv btAtualiza btCadCidade 
      WITH FRAME FRAME-A IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar-cep C-Win 
PROCEDURE pi-atualizar-cep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    EMPTY TEMP-TABLE tt-selected-rows.

    DO cont = 1 TO brDiv:NUM-SELECTED-ROWS IN FRAME FRAME-A:
       IF brDiv:FETCH-SELECTED-ROW(cont) THEN DO:
           CREATE tt-selected-rows.
           ASSIGN tt-selected-rows.r-rowid = tt-cidade-diverg.r-rowid .
       END.
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
    
    RUN pi-inicializar IN hAcomp (INPUT "Aguarde...").

    RUN pi-acompanhar  IN hAcomp (INPUT "Atualizando CEP...").

    RUN pi-habilita-cancela IN hAcomp.

    UserCodeBlock:
    DO  ON ERROR UNDO, LEAVE UserCodeBlock
        ON STOP  UNDO, LEAVE UserCodeBlock
        ON QUIT  UNDO, LEAVE UserCodeBlock:

        FOR EACH tt-selected-rows NO-LOCK:
            
            FIND FIRST tt-cidade-diverg
                 WHERE tt-cidade-diverg.r-rowid EQ tt-selected-rows.r-rowid NO-LOCK NO-ERROR.
    
            IF AVAILABLE tt-cidade-diverg THEN DO:

                IF NOT CAN-FIND(FIRST bf-cep 
                                WHERE bf-cep.localidade = tt-cidade-diverg.cidade
                                  AND bf-cep.uf         = tt-cidade-diverg.estado NO-LOCK) THEN NEXT.


                /* Atualiza Ceps */
                FOR EACH bf-cep 
                   WHERE bf-cep.localidade = tt-cidade-diverg.cidade
                     AND bf-cep.uf         = tt-cidade-diverg.estado EXCLUSIVE-LOCK:

                    ASSIGN bf-cep.localidade = tt-cidade.cidade
                           bf-cep.uf         = tt-cidade.estado
                           bf-cep.ibge       = tt-cidade.cdn-munpio-ibge.
                END.

                 /* Elimina Divergˆncia */
                FOR FIRST bf-cidade-div
                    WHERE ROWID(bf-cidade-div) = tt-cidade-diverg.r-rowid.
    
                    DELETE bf-cidade-div.
                END.
            END.
        END.
    END.

    RUN pi-finalizar IN hAcomp.

    EMPTY TEMP-TABLE tt-selected-rows.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cidade-cad C-Win 
PROCEDURE pi-busca-cidade-cad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
    
    RUN pi-inicializar IN hAcomp (INPUT "Aguarde...").

    RUN pi-acompanhar  IN hAcomp (INPUT "Atualizando Cidades Cadastradas...").

    RUN pi-desabilita-cancela IN hAcomp.
    
    EMPTY TEMP-TABLE tt-cidade.

    ASSIGN c-cidade-ini = ""
           c-estado-ini = "".

    IF INPUT FRAME FRAME-A rsCidadeCad = 1 THEN
        ASSIGN c-cidade-ini =  INPUT FRAME FRAME-A fiCidadeCad.
    ELSE
        ASSIGN c-estado-ini =  INPUT FRAME FRAME-A fiCidadeCad.

    FOR EACH bf-cidade 
       WHERE bf-cidade.cidade >= c-cidade-ini
         AND bf-cidade.estado >= c-estado-ini:
    
        CREATE tt-cidade.
        BUFFER-COPY bf-cidade TO tt-cidade.
        ASSIGN tt-cidade.r-rowid = ROWID(bf-cidade).

    END.

    IF INPUT FRAME FRAME-A rsCidadeCad = 1 THEN
        OPEN QUERY brCad FOR EACH tt-cidade  BY tt-cidade.cidade.
    ELSE
        OPEN QUERY brCad FOR EACH tt-cidade  BY tt-cidade.estado.

    RUN pi-finalizar IN hAcomp.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cidade-div C-Win 
PROCEDURE pi-busca-cidade-div :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
    
    RUN pi-inicializar IN hAcomp (INPUT "Aguarde...").

    RUN pi-acompanhar  IN hAcomp (INPUT "Atualizando Cidades Divergentes...").

    RUN pi-desabilita-cancela IN hAcomp.
    
    EMPTY TEMP-TABLE tt-cidade-diverg.

    ASSIGN c-cidade-div-ini = ""
           c-estado-div-ini = "".

    IF INPUT FRAME FRAME-A rsCidadeDiv = 1 THEN
        ASSIGN c-cidade-div-ini =  INPUT FRAME FRAME-A fiCidadeDiv.
    ELSE
        ASSIGN c-estado-div-ini =  INPUT FRAME FRAME-A fiCidadeDiv.

    FOR EACH bf-cidade-div
       WHERE bf-cidade-div.cidade >= c-cidade-div-ini
         AND bf-cidade-div.estado >= c-estado-div-ini:
    
        CREATE tt-cidade-diverg.
        BUFFER-COPY bf-cidade-div TO tt-cidade-diverg.
        ASSIGN tt-cidade-diverg.r-rowid = ROWID(bf-cidade-div).

    END.

    IF INPUT FRAME FRAME-A rsCidadeDiv = 1 THEN
        OPEN QUERY brDiv FOR EACH tt-cidade-diverg  BY tt-cidade-diverg.cidade.
    ELSE
        OPEN QUERY brDiv FOR EACH tt-cidade-diverg  BY tt-cidade-diverg.estado.

    RUN pi-finalizar IN hAcomp.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-browse C-Win 
PROCEDURE pi-habilita-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF brCad:NUM-SELECTED-ROWS IN FRAME fRAME-A > 0 AND
       brDiv:num-selected-rows IN FRAME fRAME-A > 0 THEN DO:

        ASSIGN btAtualiza:SENSITIVE IN FRAME FRAME-A = YES.

    END.
    ELSE 
        ASSIGN btAtualiza:SENSITIVE IN FRAME FRAME-A = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

