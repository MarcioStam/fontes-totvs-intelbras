&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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
DEF VAR hproc AS HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario     AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-cont-etiq AS INTEGER NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 RECT-18 rtToolBar RECT-5 btExcel ~
btReimprEtiq btExit btHelp i-quantidade i-capacidade BtCaixa BtPallet ~
bt-impressora text-impressora 
&Scoped-Define DISPLAYED-OBJECTS i-quantidade i-capacidade fi-impressora ~
text-impressora 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-impressora 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON BtCaixa 
     LABEL "Etiqueta de Caixa" 
     SIZE 74 BY 3.25.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Excel" 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON BtPallet 
     LABEL "Etiqueta de Pallet" 
     SIZE 74 BY 3.25.

DEFINE BUTTON btReimprEtiq 
     IMAGE-UP FILE "image/im-repr2.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-repr2.bmp":U
     LABEL "Reimprimir Etiqueta" 
     SIZE 4 BY 1.25 TOOLTIP "Reimprimir Etiqueta".

DEFINE VARIABLE fi-impressora AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 33 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE i-capacidade AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Capacidade" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-quantidade AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-impressora AS CHARACTER FORMAT "X(256)":U INITIAL " Impressora" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 11.75.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btExcel AT ROW 1.13 COL 45.29 WIDGET-ID 132
     btReimprEtiq AT ROW 1.17 COL 65 HELP
          "Reimprimir Etiqueta"
     btExit AT ROW 1.17 COL 73 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 77 HELP
          "Ajuda"
     i-quantidade AT ROW 3.5 COL 23 COLON-ALIGNED
     i-capacidade AT ROW 3.5 COL 55 COLON-ALIGNED
     BtCaixa AT ROW 6 COL 4
     BtPallet AT ROW 10.25 COL 4
     bt-impressora AT ROW 14.75 COL 55.14 HELP
          "Configura‡Æo da impressora" WIDGET-ID 38 NO-TAB-STOP 
     fi-impressora AT ROW 14.88 COL 22.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 40 NO-TAB-STOP 
     text-impressora AT ROW 14.25 COL 2 NO-LABEL WIDGET-ID 44
     RECT-17 AT ROW 2.5 COL 1
     RECT-18 AT ROW 2.75 COL 2
     rtToolBar AT ROW 1 COL 1
     RECT-5 AT ROW 14.46 COL 1 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.43 BY 15.33
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Impressao de etiquetas de Caixa e Pallet - 2.04.001 - ESCPP003.W"
         HEIGHT             = 15.33
         WIDTH              = 80.43
         MAX-HEIGHT         = 15.33
         MAX-WIDTH          = 80.43
         VIRTUAL-HEIGHT     = 15.33
         VIRTUAL-WIDTH      = 80.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR fi-impressora IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       fi-impressora:READ-ONLY IN FRAME fMain        = TRUE.

/* SETTINGS FOR FILL-IN text-impressora IN FRAME fMain
   ALIGN-L                                                              */
ASSIGN 
       text-impressora:PRIVATE-DATA IN FRAME fMain     = 
                "Impressora".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Impressao de etiquetas de Caixa e Pallet - 2.04.001 - ESCPP003.W */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Impressao de etiquetas de Caixa e Pallet - 2.04.001 - ESCPP003.W */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impressora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressora wWin
ON CHOOSE OF bt-impressora IN FRAME fMain
DO:
    RUN pi-impressora.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtCaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtCaixa wWin
ON CHOOSE OF BtCaixa IN FRAME fMain /* Etiqueta de Caixa */
DO:
  DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

  IF INPUT FRAME {&frame-name} i-quantidade = 0
  OR INPUT FRAME {&frame-name} i-capacidade = 0 THEN DO:
      MESSAGE "Informar a capacidade e/ou a quantidade das etiquetas" VIEW-AS ALERT-BOX.
      APPLY "entry" TO i-quantidade IN FRAME fMain.
      RETURN NO-APPLY.
  END.
  
  if input frame {&frame-name} fi-impressora = "":U then do:
      message "Informe uma impressora v lida.":U view-as alert-box.
      apply "entry":U to fi-impressora in frame {&frame-name}.
      return no-apply.
  end.

  OUTPUT TO value(v_nom_disposit_so).

  {esapi/esapi016inic.i} /*inicializa parƒmetros impressora*/
  
  DO i-cont-etiq = 1 TO INPUT FRAME {&frame-name} i-quantidade:

      FIND ns-contador WHERE ns-contador.codigo-contador = 1 EXCLUSIVE-LOCK.

      ASSIGN i-sequencia = NEXT-VALUE(seq-ns-volume-eco)
             ns-contador.valor-contador = i-sequencia.

      FIND ns-contador WHERE ns-contador.codigo-contador = 1 NO-LOCK.
      
      PUT UNFORMATTED "^XA" SKIP
    
                      "^PQ" string(1,"99999999") SKIP
                      "^BY2" SKIP
                      "^FO96,40^BCN,136,N,N,N,N^FDECO" 
                      STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") 
                      string((ns-contador.valor-contador),"99999999") "^FS" 
                      SKIP  /* Codigo de Barras EAN 128 */
    
                      "^FO96,204^A0N,32,24^FDECO" STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") 
                                                  string((ns-contador.valor-contador),"99999999") "^FS"
                                                  SKIP  /* Valor do Codigo de Barras EAN128 */
                      
                      "^FO96,240^A0N,80,80^FDCAIXA - " 
                                                STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999")
                                                "^FS"
                                                SKIP    /* Linha Indicativa da capacidade da Caixa */
    
                      "^XZ" SKIP. 
  
      /* Criacao etiquetas Caixa */
      CREATE ns-volume-estab.
      ASSIGN ns-volume-estab.volume-pai      = "ECO" + STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") + string(ns-contador.valor-contador,"99999999") 
             ns-volume-estab.cod-estabel     = v_cod_estab_usuar
             ns-volume-estab.codigo-contador = 1 /* Caixa */ 
             ns-volume-estab.data-imp        = NOW
             ns-volume-estab.usuario-impr    = c-seg-usuario 
             ns-volume-estab.valor-contador  = ns-contador.valor-contador.

      //FIND CURRENT ns-contador NO-LOCK.
  END.

  OUTPUT CLOSE. 
  
  MESSAGE "Etiquetas de caixa impressas!!" VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWin
ON CHOOSE OF btExcel IN FRAME fMain /* Excel */
DO:
   RUN esp/cpp/escpp003b.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWin
ON CHOOSE OF btExit IN FRAME fMain /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWin
ON CHOOSE OF btHelp IN FRAME fMain /* Help */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtPallet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtPallet wWin
ON CHOOSE OF BtPallet IN FRAME fMain /* Etiqueta de Pallet */
DO: 
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    IF INPUT FRAME {&FRAME-NAME} i-quantidade  = 0
    OR INPUT FRAME {&FRAME-NAME} i-capacidade  = 0 THEN DO:
        MESSAGE "Informar a capacidade e/ou a quantidade das etiquetas" VIEW-AS ALERT-BOX.
        APPLY "entry" TO i-quantidade IN FRAME fMain.
        RETURN NO-APPLY.
    END.
    
    if input frame {&frame-name} fi-impressora = "":U then do:
        message "Informe uma impressora v lida.":U view-as alert-box.
        apply "entry":U to fi-impressora in frame {&frame-name}.
        return no-apply.
    end.

    
  
    OUTPUT TO value(v_nom_disposit_so).             

    {esapi/esapi016inic.i} /*inicializa parƒmetros impressora*/

    DO i-cont-etiq = 1 TO INPUT FRAME {&frame-name} i-quantidade:

        FIND ns-contador WHERE ns-contador.codigo-contador = 2 EXCLUSIVE-LOCK.

        ASSIGN i-sequencia = NEXT-VALUE(seq-ns-volume-epa)
               ns-contador.valor-contador = i-sequencia.

        FIND ns-contador WHERE ns-contador.codigo-contador = 2 NO-LOCK.

        PUT UNFORMATTED "^XA" SKIP
                        
                        "^PQ" string(1,"999999") SKIP
                        "^BY2" SKIP
                        "^FO96,40^BCN,136,N,N,N,N^FDEPA" 
                        STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") 
                        string((ns-contador.valor-contador),"99999999") "^FS"
                        SKIP  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
    
                        "^FO96,204^A0N,32,24^FDEPA" STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") 
                                                    string((ns-contador.valor-contador),"99999999") "^FS"
                                                    SKIP  /* Valor do Codigo de Barras EAN128 - Etiqueta Secundaria */
    
                        "^FO80,240^A0N,80,80^FDPALLET - " 
                                                  STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999")
                                                  "^FS"
                                                  SKIP    /* Linha Indicativa da capacidade do Pallet */
    
                        "^XZ" SKIP.  
    
        /* Criacao etiquetas Pallet */
        CREATE ns-volume-estab.
        ASSIGN ns-volume-estab.volume-pai      = "EPA" + STRING((INPUT FRAME {&FRAME-NAME} i-capacidade),"999") + string(ns-contador.valor-contador,"99999999") 
               ns-volume-estab.cod-estabel     = v_cod_estab_usuar
               ns-volume-estab.codigo-contador = 2 /* Pallet */ 
               ns-volume-estab.data-imp        = NOW
               ns-volume-estab.usuario-impr    = c-seg-usuario 
               ns-volume-estab.valor-contador  = ns-contador.valor-contador.

        //FIND CURRENT ns-contador NO-LOCK.
    END.

    OUTPUT CLOSE.

    

    MESSAGE "Etiquetas de pallets impressas!!" VIEW-AS ALERT-BOX.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReimprEtiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimprEtiq wWin
ON CHOOSE OF btReimprEtiq IN FRAME fMain /* Reimprimir Etiqueta */
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.

    DO ON ERROR UNDO, LEAVE:
        RUN esp/cpp/escpp003a.w (INPUT CURRENT-WINDOW:HANDLE).
    END.

    {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY i-quantidade i-capacidade fi-impressora text-impressora 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-17 RECT-18 rtToolBar RECT-5 btExcel btReimprEtiq btExit btHelp 
         i-quantidade i-capacidade BtCaixa BtPallet bt-impressora 
         text-impressora 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-impressora wWin 
PROCEDURE pi-impressora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-arquivo-temp  as char no-undo.
    def var c-impressora    as char no-undo.
    def var c-arq           as char no-undo.
    def var c-layout        as char no-undo.
    def var c-ant           as char no-undo.
    def var c-imp-old       as char no-undo.

    assign c-ant = fi-impressora:screen-value in frame {&FRAME-NAME}
           c-arquivo-temp =  replace(fi-impressora:screen-value in frame {&FRAME-NAME},":",",").
    if fi-impressora:screen-value in frame {&FRAME-NAME} <> "" then do:
      if num-entries(c-arquivo-temp) = 4 then
        assign c-impressora = entry(1,c-arquivo-temp)
               c-layout     = entry(2,c-arquivo-temp)
               c-arq        = entry(3,c-arquivo-temp) + ":" + entry(4,c-arquivo-temp).
      if num-entries(c-arquivo-temp) = 3 then
        assign c-impressora = entry(1,c-arquivo-temp)
               c-layout     = entry(2,c-arquivo-temp)
               c-arq        = entry(3,c-arquivo-temp).
      if num-entries(c-arquivo-temp) = 2 then
        assign c-impressora = entry(1,c-arquivo-temp)
               c-layout     = entry(2,c-arquivo-temp)
               c-arq        = "".
    end.         

    run esp/utp/esut-impr01.w (input-output c-impressora, input-output c-layout, input-output c-arq, INPUT hproc).

    if c-arq = "" then
      assign fi-impressora = c-impressora + ":" + c-layout.
    else
      assign fi-impressora = c-impressora + ":" + c-layout + ":" + c-arq.  

    if fi-impressora = ":" then
      assign fi-impressora = c-ant.

    assign c-imp-old = fi-impressora.

    disp fi-impressora with frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

