&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE p-object AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-destino NO-UNDO LIKE ncm-origem-sem-prot
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-orig 
    FIELD cod-orig  AS INT.

DEFINE INPUT PARAM p-cod-ncm AS INT NO-UNDO.
DEFINE INPUT PARAM TABLE FOR tt-destino.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RECT-5 c-cod-ncm tg-0 tg-1 ~
tg-2 tg-3 tg-4 tg-5 tg-6 tg-7 tg-8 bt-copiar bt-cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 c-cod-ncm tg-0 tg-1 tg-2 tg-3 ~
tg-4 tg-5 tg-6 tg-7 tg-8 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancel 
     LABEL "Cancelar" 
     SIZE 11 BY 1.13 TOOLTIP "Cancelar".

DEFINE BUTTON bt-copiar 
     LABEL "OK" 
     SIZE 11 BY 1.13.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "Este campo replica dados da NCM e Origem atualmente selecionadas para outras NCMs ou Origens" 
     VIEW-AS EDITOR
     SIZE 44 BY 1.75
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-ncm AS CHARACTER FORMAT "99999999" INITIAL "00000000" 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.38.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.63.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 44.29 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-0 AS LOGICAL INITIAL no 
     LABEL "0" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-1 AS LOGICAL INITIAL no 
     LABEL "1" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-2 AS LOGICAL INITIAL no 
     LABEL "2" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-3 AS LOGICAL INITIAL no 
     LABEL "3" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-4 AS LOGICAL INITIAL no 
     LABEL "4" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-5 AS LOGICAL INITIAL no 
     LABEL "5" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-6 AS LOGICAL INITIAL no 
     LABEL "6" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-7 AS LOGICAL INITIAL no 
     LABEL "7" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE tg-8 AS LOGICAL INITIAL no 
     LABEL "8" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     EDITOR-1 AT ROW 1.75 COL 2 NO-LABEL WIDGET-ID 42
     c-cod-ncm AT ROW 4.38 COL 17.43 COLON-ALIGNED HELP
          "Classifica‡Æo Fiscal do Item" WIDGET-ID 2
     tg-0 AT ROW 6.83 COL 13.72 WIDGET-ID 32
     tg-1 AT ROW 6.83 COL 19.72 WIDGET-ID 8
     tg-2 AT ROW 6.83 COL 25.72 WIDGET-ID 14
     tg-3 AT ROW 6.83 COL 31.72 WIDGET-ID 16
     tg-4 AT ROW 6.83 COL 37.72 WIDGET-ID 18
     tg-5 AT ROW 7.96 COL 13.72 WIDGET-ID 20
     tg-6 AT ROW 7.96 COL 19.72 WIDGET-ID 22
     tg-7 AT ROW 7.96 COL 25.72 WIDGET-ID 24
     tg-8 AT ROW 7.96 COL 31.72 WIDGET-ID 26
     bt-copiar AT ROW 9.38 COL 2.57 WIDGET-ID 4
     bt-cancel AT ROW 9.38 COL 34.72 WIDGET-ID 30
     "Origens" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 6.17 COL 3.43 WIDGET-ID 12
     RECT-3 AT ROW 3.75 COL 2.14 WIDGET-ID 6
     RECT-4 AT ROW 6.5 COL 2.14 WIDGET-ID 10
     RECT-5 AT ROW 9.21 COL 2 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 45.57 BY 9.75 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Copiar Tabela"
         HEIGHT             = 9.75
         WIDTH              = 45.57
         MAX-HEIGHT         = 9.75
         MAX-WIDTH          = 45.57
         VIRTUAL-HEIGHT     = 9.75
         VIRTUAL-WIDTH      = 45.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-1:PRIVATE-DATA IN FRAME fPage0     = 
                "Este campo replica dados da NCM e Origem atualmente selecionadas para outras NCMs ou Origens".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Copiar Tabela */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Copiar Tabela */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancel W-Win
ON CHOOSE OF bt-cancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-copiar W-Win
ON CHOOSE OF bt-copiar IN FRAME fPage0 /* OK */
DO:
    IF  NOT CAN-FIND(FIRST tt-destino) THEN DO:
        /*MESSAGE "Sem informa‡äes para copiar." VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        RUN utp/ut-msgs.p (INPUT 'show', INPUT 15825,  INPUT "Sem informa‡äes para copiar.").
        RETURN NO-APPLY.
    END. /* IF  NOT CAN-FIND(FIRST tt-destino) */
    

    /*
    MESSAGE 'Confirma a c¢pia?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
    UPDATE l-confirma AS LOGICAL FORMAT 'Sim/NÆo'.
    */

    RUN utp/ut-msgs.p (INPUT 'show',
                       INPUT 27100,
                       INPUT 'Confirma a c¢pia?').
    IF  RETURN-VALUE = 'yes' THEN DO:
        RUN pi-copiar.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 c-cod-ncm tg-0 tg-1 tg-2 tg-3 tg-4 tg-5 tg-6 tg-7 tg-8 
      WITH FRAME fPage0 IN WINDOW W-Win.
  ENABLE RECT-3 RECT-4 RECT-5 c-cod-ncm tg-0 tg-1 tg-2 tg-3 tg-4 tg-5 tg-6 tg-7 
         tg-8 bt-copiar bt-cancel 
      WITH FRAME fPage0 IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ENABLE tg-0 tg-1 tg-2 tg-3 tg-4 tg-5 tg-6 tg-7 tg-8 WITH FRAME fPage0.

  ASSIGN c-cod-ncm:SCREEN-VALUE IN FRAME fpage0 = string(p-cod-ncm,"99999999").

  ASSIGN EDITOR-1:FGCOLOR in frame fpage0 = 0. /* preto */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copiar W-Win 
PROCEDURE pi-copiar :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-orig.

IF tg-0:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 0.
END.
IF tg-1:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 1.
END.
IF tg-2:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 2.
END.
IF tg-3:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 3.
END.
IF tg-4:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 4.
END.
IF tg-5:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 5.
END.
IF tg-6:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 6.
END.
IF tg-7:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 7.
END.
IF tg-8:CHECKED IN FRAME fPage0 THEN DO:
    CREATE tt-orig.
    ASSIGN tt-orig.cod-orig = 8.
END.

ASSIGN INPUT FRAME fpage0 c-cod-ncm.

FOR EACH tt-destino NO-LOCK:

    FOR EACH tt-orig: 

        IF NOT CAN-FIND(FIRST ncm-origem NO-LOCK
                        WHERE ncm-origem.cod-ncm      = c-cod-ncm
                          AND ncm-origem.codigo-orig  = tt-orig.cod-orig) THEN DO:
             CREATE ncm-origem.
             ASSIGN ncm-origem.cod-ncm      = c-cod-ncm
                    ncm-origem.codigo-orig  = tt-orig.cod-orig.
        END.

        FIND FIRST ncm-origem-sem-prot EXCLUSIVE-LOCK
             WHERE ncm-origem-sem-prot.cod-ncm      = c-cod-ncm
               AND ncm-origem-sem-prot.codigo-orig  = tt-orig.cod-orig                      
               AND ncm-origem-sem-prot.uf-origem    = tt-destino.uf-origem                  
               AND ncm-origem-sem-prot.uf-destino   = tt-destino.uf-destino NO-ERROR. 
        
        IF NOT AVAIL ncm-origem-sem-prot THEN DO:        
            CREATE ncm-origem-sem-prot.
            ASSIGN ncm-origem-sem-prot.cod-ncm              = c-cod-ncm 
                   ncm-origem-sem-prot.codigo-orig          = tt-orig.cod-orig
                   ncm-origem-sem-prot.uf-origem            = tt-destino.uf-origem      
                   ncm-origem-sem-prot.uf-destino           = tt-destino.uf-destino.
        END.

        ASSIGN ncm-origem-sem-prot.per-sub-tri          = tt-destino.per-sub-tri         
               ncm-origem-sem-prot.perc-red-sub         = tt-destino.perc-red-sub        
               ncm-origem-sem-prot.perc-credito-icms    = tt-destino.perc-credito-icms
               ncm-origem-sem-prot.protocolo            = tt-destino.protocolo
               ncm-origem-sem-prot.cod-msg-nf           = tt-destino.cod-msg-nf
               ncm-origem-sem-prot.dt-ultima-rec        = TODAY /*tt-destino.dt-ultima-rec*/
               ncm-origem-sem-prot.l-gera-of            = tt-destino.l-gera-of        
               ncm-origem-sem-prot.l-tem-st             = tt-destino.l-tem-st         
               ncm-origem-sem-prot.per-sub-tri          = tt-destino.per-sub-tri      
               ncm-origem-sem-prot.perc-aliq-Interna    = tt-destino.perc-aliq-Interna
               ncm-origem-sem-prot.usuar-ultima-rev     = c-seg-usuario /*tt-destino.usuar-ultima-rev*/ . 
        IF  ncm-origem-sem-prot.l-tem-st
        AND ncm-origem-sem-prot.l-gera-of THEN DO:
             RUN esp/cdp/escdp055api.p (INPUT ncm-origem-sem-prot.cod-ncm,
                                        INPUT ncm-origem-sem-prot.codigo-orig).
        END.
    END.
END.

RUN utp/ut-msgs.p (INPUT 'show', INPUT 15825, INPUT "C¢pias efetuadas com sucesso.").

/*MESSAGE "C¢pias efetuadas com sucesso." VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

APPLY "CHOOSE" TO bt-cancel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

