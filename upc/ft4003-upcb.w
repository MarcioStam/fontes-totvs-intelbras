&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-wt-it-docto NO-UNDO LIKE wt-it-docto
       field desc-item like item.desc-item.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE NEW GLOBAL SHARED VARIABLE v-row-wt-docto-ft4003 AS ROWID   NO-UNDO.

DEFINE VARIABLE                   v-qtd-itens-db        AS INTEGER NO-UNDO.
DEFINE VARIABLE                   v-qtd-peso-item       AS DECIMAL NO-UNDO.

DEFINE VARIABLE                   v-qtd-itens-liq-db        AS INTEGER NO-UNDO.
DEFINE VARIABLE                   v-qtd-peso-liq-item       AS DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-wt-it-docto

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-wt-it-docto.it-codigo ~
tt-wt-it-docto.desc-item @ tt-wt-it-docto.desc-item ~
tt-wt-it-docto.quantidade[1] tt-wt-it-docto.peso-bruto-it ~
tt-wt-it-docto.peso-liq-it 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens 
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-wt-it-docto NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY br-itens FOR EACH tt-wt-it-docto NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-itens tt-wt-it-docto
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-wt-it-docto


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 rtToolBar v-qtd-peso-nota ~
v-qtd-peso-liquido-nota bt-apl br-itens btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS v-qtd-peso-nota v-qtd-peso-liquido-nota 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-apl 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Aplicar" 
     SIZE 4 BY 1.13 TOOLTIP "Aplicar peso aos intes da nota"
     FONT 4.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE v-qtd-peso-liquido-nota AS DECIMAL FORMAT ">>,>>9.9999":U INITIAL 0 
     LABEL "Peso Liquido Total Mercadoria (kg)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE v-qtd-peso-nota AS DECIMAL FORMAT ">>,>>9.9999":U INITIAL 0 
     LABEL "Peso Bruto Total Mercadoria (kg)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-wt-it-docto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens Dialog-Frame _STRUCTURED
  QUERY br-itens NO-LOCK DISPLAY
      tt-wt-it-docto.it-codigo FORMAT "x(8)":U
      tt-wt-it-docto.desc-item @ tt-wt-it-docto.desc-item COLUMN-LABEL "Descri‡Æo" FORMAT "x(20)":U
            WIDTH 30.86
      tt-wt-it-docto.quantidade[1] COLUMN-LABEL "Qtd" FORMAT ">>,>>9.999":U
            WIDTH 9
      tt-wt-it-docto.peso-bruto-it COLUMN-LABEL "Peso Bruto" FORMAT ">>,>>9.9999":U
            WIDTH 9.86
      tt-wt-it-docto.peso-liq-it FORMAT ">>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 72 BY 13.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     v-qtd-peso-nota AT ROW 1.5 COL 35 COLON-ALIGNED WIDGET-ID 2
     v-qtd-peso-liquido-nota AT ROW 2.75 COL 35 COLON-ALIGNED WIDGET-ID 16
     bt-apl AT ROW 2.75 COL 52 HELP
          "Consultas relacionadas" WIDGET-ID 14
     br-itens AT ROW 4.5 COL 2 WIDGET-ID 100
     btOK AT ROW 18.75 COL 3
     btCancel AT ROW 18.75 COL 13.43
     RECT-3 AT ROW 1.25 COL 2
     rtToolBar AT ROW 18.5 COL 2
     SPACE(0.28) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Peso D‚bito Direto - ft4003-upcb.w"
         DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-wt-it-docto T "?" NO-UNDO mgcad wt-it-docto
      ADDITIONAL-FIELDS:
          field desc-item like item.desc-item
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB br-itens bt-apl Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _TblList          = "Temp-Tables.tt-wt-it-docto"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-wt-it-docto.it-codigo
"tt-wt-it-docto.it-codigo" ? "x(8)" "character" ? ? ? ? ? ? no "Item" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-wt-it-docto.desc-item @ tt-wt-it-docto.desc-item" "Descri‡Æo" "x(20)" ? ? ? ? ? ? ? no ? no no "30.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-wt-it-docto.quantidade[1]
"tt-wt-it-docto.quantidade[1]" "Qtd" ">>,>>9.999" "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-wt-it-docto.peso-bruto-it
"tt-wt-it-docto.peso-bruto-it" "Peso Bruto" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-wt-it-docto.peso-liq-it
"tt-wt-it-docto.peso-liq-it" ? ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Peso D‚bito Direto - ft4003-upcb.w */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-apl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-apl Dialog-Frame
ON CHOOSE OF bt-apl IN FRAME Dialog-Frame /* Aplicar */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    ASSIGN v-qtd-peso-item = 0.

    ASSIGN v-qtd-peso-item = INPUT FRAME {&FRAME-NAME} v-qtd-peso-nota / v-qtd-itens-db.
    ASSIGN v-qtd-peso-liq-item = INPUT FRAME {&FRAME-NAME} v-qtd-peso-liquido-nota / v-qtd-itens-db.

    /* Validar se peso inferior ao m¡nimo aceito no GKO */
    IF  v-qtd-peso-item < 0.0001
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Peso bruto informado insuficiente. ~~O peso informado ‚ inferior ao m¡nimo necess rio para atingir 0,0001 kg por item.").

        RETURN NO-APPLY.
    END.
    IF  v-qtd-peso-liq-item < 0.0001
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Peso liquido informado insuficiente. ~~O peso informado ‚ inferior ao m¡nimo necess rio para atingir 0,0001 kg por item.").

        RETURN NO-APPLY.
    END.
    IF  v-qtd-peso-item < v-qtd-peso-liq-item
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Peso Bruto informado menor que peso Liquido ~~Peso Bruto " +  string(v-qtd-peso-item) +  " informado menor que peso Liquido " + string(v-qtd-peso-liq-item) + ".").

        RETURN NO-APPLY.
    END.
    FOR EACH tt-wt-it-docto:
        ASSIGN tt-wt-it-docto.peso-liq-it   = v-qtd-peso-liq-item
               tt-wt-it-docto.peso-bruto-it = v-qtd-peso-item.

        
    END.

    IF  SESSION:SET-WAIT-STATE("") THEN.

    FIND FIRST tt-wt-it-docto NO-LOCK NO-ERROR.
    IF  AVAIL tt-wt-it-docto
    THEN
        br-itens:REFRESH().

/*     OPEN QUERY br-tarifas FOR EACH tt-tarifa NO-LOCK. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel Dialog-Frame
ON CHOOSE OF btCancel IN FRAME Dialog-Frame /* Cancelar */
DO:
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK Dialog-Frame
ON CHOOSE OF btOK IN FRAME Dialog-Frame /* OK */
DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Confirma peso?~~Confirma utiliza‡Æo do peso informado para os itens da nota apresentados?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        FOR EACH tt-wt-it-docto:

            IF  tt-wt-it-docto.peso-liq-it < 0.0001 
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Peso Liquido informado insuficiente. ~~O peso informado ‚ inferior ao m¡nimo necess rio para atingir 0,0001 kg por item.").
    
                RETURN NO-APPLY.
            END.
            IF  tt-wt-it-docto.peso-bruto-it < 0.0001 
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Peso Bruto informado insuficiente. ~~O peso informado ‚ inferior ao m¡nimo necess rio para atingir 0,0001 kg por item.").
    
                RETURN NO-APPLY.
            END.
            IF  tt-wt-it-docto.peso-bruto-it < tt-wt-it-docto.peso-liq-it
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Peso Bruto informado menor que peso Liquido ~~Peso Bruto " +  string(tt-wt-it-docto.peso-bruto-it) +  " informado menor que peso Liquido " + string(tt-wt-it-docto.peso-liq-it) + ".").
    
                RETURN NO-APPLY.
            END.
            FIND wt-it-docto EXCLUSIVE-LOCK
                WHERE wt-it-docto.seq-wt-docto    = tt-wt-it-docto.seq-wt-docto   
                  AND wt-it-docto.seq-wt-it-docto = tt-wt-it-docto.seq-wt-it-docto NO-ERROR.

            IF  AVAIL wt-it-docto
            THEN
                ASSIGN wt-it-docto.peso-liq-it      = 0
                       wt-it-docto.peso-liq-it-inf  = tt-wt-it-docto.peso-liq-it
                       wt-it-docto.peso-bruto-it    = 0
                       wt-it-docto.peso-bru-it-inf  = tt-wt-it-docto.peso-bruto-it.

            RELEASE wt-it-docto.
        END.
    END.
    ELSE
        RETURN NO-APPLY.

    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    EMPTY TEMP-TABLE tt-wt-it-docto.

    ASSIGN v-qtd-itens-db = 0.

    IF  v-row-wt-docto-ft4003 <> ?
    THEN DO:
        FIND wt-docto NO-LOCK
            WHERE ROWID(wt-docto) = v-row-wt-docto-ft4003 NO-ERROR.

        IF  AVAIL wt-docto
        THEN DO:
            FOR EACH wt-it-docto OF wt-docto NO-LOCK:

                FIND ITEM OF wt-it-docto NO-LOCK NO-ERROR.
                
                IF  AVAIL ITEM AND 
                    ITEM.tipo-contr = 4 /* D‚bito Direto */
                THEN DO:
                    CREATE tt-wt-it-docto.
                    BUFFER-COPY wt-it-docto TO tt-wt-it-docto.
                    ASSIGN tt-wt-it-docto.desc-item = ITEM.desc-item
                           v-qtd-itens-db           = v-qtd-itens-db + 1.
                END.
            END.
        END.
    END.

    RUN enable_UI.

    WAIT-FOR GO OF FRAME Dialog-Frame.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY v-qtd-peso-nota v-qtd-peso-liquido-nota 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-3 rtToolBar v-qtd-peso-nota v-qtd-peso-liquido-nota bt-apl 
         br-itens btOK btCancel 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

