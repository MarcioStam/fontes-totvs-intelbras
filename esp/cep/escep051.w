&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-item NO-UNDO LIKE ae-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
{include/i-prgvrs.i escep051 1.00.00.000}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep051
&GLOBAL-DEFINE Version        1.00.00.000

def new global shared var v_cod_usuar_corren as char no-undo.

run btb/btb906za.p.
run men/men901za.p (Input 'escep051').
if  return-value = "2014" then do:
    /* Programa a ser executado nío ≤ um programa vˇlido Datasul ! */
    run utp/ut-msgs.p (input "show", input 3045, input 'escep051').
    return.
end.
    
if  return-value = "2012" then do:
    /* Usuˇrio sem permissío para acessar o programa. */
    run utp/ut-msgs.p (input "show", input 2858, input 'escep051').
    return.
end.    
    
{utp/utapi019.i}
{esapi/esapi010tt.i}
{upc/btb910za-upc.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF BUFFER bae-item FOR ae-item.


DEF VAR i AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ae

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttae-item

/* Definitions for BROWSE br-ae                                         */
&Scoped-define FIELDS-IN-QUERY-br-ae ttae-item.nr-ae ttae-item.sequencia ttae-item.situacao ttae-item.cod-depos ttae-item.data ttae-item.data-fabricacao ttae-item.data-validade ttae-item.impresso ttae-item.it-codigo ttae-item.localizacao ttae-item.nf ttae-item.quantidade ttae-item.roteiro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ae   
&Scoped-define SELF-NAME br-ae
&Scoped-define QUERY-STRING-br-ae FOR EACH ttae-item                          BY ttae-item.cod-estabel                          BY ttae-item.nr-ae
&Scoped-define OPEN-QUERY-br-ae OPEN QUERY {&SELF-NAME} FOR EACH ttae-item                          BY ttae-item.cod-estabel                          BY ttae-item.nr-ae.
&Scoped-define TABLES-IN-QUERY-br-ae ttae-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-ae ttae-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-ae}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 fi-nr-ae-ini rtToolBar RECT-39 ~
fi-nr-ae-fim IMAGE-5 IMAGE-6 bt-atualiza br-ae btOK btCancel btHelp2 ~
btDelete btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-ae-ini fi-sequencia-ini fi-nr-ae-fim ~
fi-sequencia-fim 

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
DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

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
     LABEL "OK" 
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

DEFINE VARIABLE fi-nr-ae-fim AS INTEGER FORMAT "9999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae-ini AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "AE" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia-fim AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia-ini AS INTEGER FORMAT "999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.

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
DEFINE QUERY br-ae FOR 
      ttae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ae wWindow _FREEFORM
  QUERY br-ae DISPLAY
      ttae-item.nr-ae
    ttae-item.sequencia format "99999" width 7
    ttae-item.situacao WIDTH 7
    ttae-item.cod-depos 
    ttae-item.data 
    ttae-item.data-fabricacao 
    ttae-item.data-validade 
    ttae-item.impresso 
    ttae-item.it-codigo 
    ttae-item.localizacao 
    ttae-item.nf 
    ttae-item.quantidade  format ">>>>>>>>9"
    ttae-item.roteiro
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-nr-ae-ini AT ROW 3.5 COL 14 COLON-ALIGNED WIDGET-ID 4
     fi-sequencia-ini AT ROW 3.5 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-nr-ae-fim AT ROW 3.5 COL 56 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-sequencia-fim AT ROW 3.5 COL 65 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     bt-atualiza AT ROW 4.25 COL 73 WIDGET-ID 50
     br-ae AT ROW 6 COL 1 WIDGET-ID 200
     btOK AT ROW 19.21 COL 2
     btCancel AT ROW 19.21 COL 13
     btHelp2 AT ROW 19.21 COL 80.29
     btDelete AT ROW 1.13 COL 1.57 HELP
          "Elimina ocorrància corrente" WIDGET-ID 16
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 19 COL 1
     RECT-39 AT ROW 2.5 COL 1 WIDGET-ID 2
     IMAGE-5 AT ROW 3.5 COL 32 WIDGET-ID 12
     IMAGE-6 AT ROW 3.5 COL 52 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 19.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-item T "?" NO-UNDO mgesp ae-item
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
         TITLE              = "Elimina AE com uma unica sequància"
         HEIGHT             = 19.63
         WIDTH              = 90.29
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-ae bt-atualiza fpage0 */
/* SETTINGS FOR FILL-IN fi-sequencia-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sequencia-ini IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ae
/* Query rebuild information for BROWSE br-ae
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttae-item
                         BY ttae-item.cod-estabel
                         BY ttae-item.nr-ae.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ae */
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
ON END-ERROR OF wWindow /* Elimina AE com uma unica sequància */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Elimina AE com uma unica sequància */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fpage0 /* Button 2 */
DO:
    FOR EACH ttae-item:
        DELETE ttae-item.
    END.
    
    IF fi-sequencia-ini <> 1 OR
       fi-sequencia-fim <> 1 THEN DO:
        
        run utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "Faixa de AE n∆o pode ser eliminada.~~Uma das AEÔs informadas possuem mais de uma sequància. Programa s¢ permite eliminar AE com uma sequància.").
        
        RETURN NO-APPLY.
    END.
    
    DO i = INPUT fi-nr-ae-ini TO INPUT fi-nr-ae-fim:
        FIND LAST ae-item WHERE ae-item.cod-estabel = v_cod_estab_usuar AND
                                ae-item.nr-ae = i NO-ERROR.
        IF AVAIL ae-item AND
                 ae-item.sequencia = 1 THEN DO:
            CREATE ttae-item.
            ASSIGN ttae-item.cod-estabel     = ae-item.cod-estabel
                   ttae-item.nr-ae           = ae-item.nr-ae
                   ttae-item.sequencia       = ae-item.sequencia
                   ttae-item.situacao        = ae-item.situacao
                   ttae-item.cod-depos       = ae-item.cod-depos
                   ttae-item.data            = ae-item.data
                   ttae-item.data-fabricacao = ae-item.data-fabricacao
                   ttae-item.data-validade   = ae-item.data-validade
                   ttae-item.impresso        = ae-item.impresso
                   ttae-item.it-codigo       = ae-item.it-codigo
                   ttae-item.localizacao     = ae-item.localizacao
                   ttae-item.nf              = ae-item.nf
                   ttae-item.quantidade      = ae-item.quantidade
                   ttae-item.roteiro         = ae-item.roteiro.
        END.
        
    END.


    {&OPEN-QUERY-br-ae}    
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


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wWindow
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
DO:
    MESSAGE "Confirma exclus∆o das AEÔs da lista?" 
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
             TITLE "" UPDATE choice AS LOGICAL.
    CASE choice:
        WHEN TRUE THEN   /* Yes */ DO:
            FOR EACH ttae-item NO-LOCK:
                FIND FIRST ae-item OF ttae-item NO-ERROR.
                IF AVAIL ae-item THEN DO:
                    DELETE ae-item.
                END.
            END.
                
            FOR EACH ttae-item:
                DELETE ttae-item.
            END.
            br-ae:REFRESH().
            
         END.
         WHEN FALSE THEN /* No */
         DO:
            RETURN NO-APPLY.
         END.
         OTHERWISE       /* Cancel */
            RETURN NO-APPLY.
    END CASE.
    
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
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
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


&Scoped-define SELF-NAME fi-nr-ae-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ae-fim wWindow
ON LEAVE OF fi-nr-ae-fim IN FRAME fpage0
DO:
    FIND LAST bae-item WHERE bae-item.cod-estabel = v_cod_estab_usuar AND
                             bae-item.nr-ae = INPUT fi-nr-ae-fim NO-LOCK NO-ERROR.
    IF AVAIL bae-item THEN
        ASSIGN fi-sequencia-fim = bae-item.sequencia.
    ELSE DO:
        run utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "AE n∆o encontrada.~~AE n∆o cadastrada no sistema.").
        
        ASSIGN fi-nr-ae-fim     = 0
               fi-sequencia-fim = 0.

        DISP fi-nr-ae-fim
             fi-sequencia-fim WITH FRAME fPage0.
        
        RETURN NO-APPLY.
    END.
       
    DISP fi-sequencia-fim WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ae-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ae-ini wWindow
ON LEAVE OF fi-nr-ae-ini IN FRAME fpage0 /* AE */
DO:
    FIND LAST ae-item WHERE ae-item.cod-estabel = v_cod_estab_usuar AND
                            ae-item.nr-ae = INPUT fi-nr-ae-ini NO-LOCK NO-ERROR.
    IF AVAIL ae-item THEN
        ASSIGN fi-sequencia-ini = ae-item.sequencia.
    ELSE DO:
        
        run utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "AE n∆o encontrada.~~AE n∆o cadastrada no sistema.").
        
        ASSIGN fi-nr-ae-ini     = 0
               fi-sequencia-ini = 0.

        DISP fi-nr-ae-ini
             fi-sequencia-ini WITH FRAME fPage0.
        
        RETURN NO-APPLY.

    END.
    DISP fi-sequencia-ini WITH FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ae
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

