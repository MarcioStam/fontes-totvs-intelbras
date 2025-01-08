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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-item-dt-entrega
    FIELD it-codigo          AS CHAR 
    FIELD cod-gr-canais      AS INTEGER
    FIELD dt-entrega-futura  AS DATE
    FIELD linha              AS INTEGER .

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

DEFINE VARIABLE hShowMsg     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME espdp055a

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 3.72 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 1.

DEFINE BUTTON bt-ok 
     LABEL "&Importar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 1.

DEFINE VARIABLE ed-layout AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 64.29 BY 2.79
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-arquivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Importar", 1,
"Eliminar", 2
     SIZE 28 BY 1.25
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-139
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 3.75.

DEFINE RECTANGLE RECT-140
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 4.25.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 67.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME espdp055a
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.57 BY 11.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage0
     ed-layout AT ROW 2.42 COL 2.86 NO-LABEL WIDGET-ID 2
     rs-tipo AT ROW 6.5 COL 21.86 NO-LABEL WIDGET-ID 8
     bt-arquivo AT ROW 8.21 COL 63.29 WIDGET-ID 14
     fi-arquivo AT ROW 8.25 COL 7.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     bt-cancela AT ROW 10.75 COL 1.72 WIDGET-ID 18
     bt-ok AT ROW 10.75 COL 29.14 WIDGET-ID 20
     bt-ajuda AT ROW 10.75 COL 58 WIDGET-ID 16
     "Arquivo:" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 8.33 COL 2.57 WIDGET-ID 24
          FONT 1
     "Layout Arquivo p/ Importaá∆o ou Eliminaá∆o:" VIEW-AS TEXT
          SIZE 31 BY .67 AT ROW 1.38 COL 3 WIDGET-ID 6
          FONT 1
     RECT-139 AT ROW 1.75 COL 2 WIDGET-ID 4
     rt-buttom AT ROW 10.5 COL 1 WIDGET-ID 22
     RECT-140 AT ROW 5.75 COL 2 WIDGET-ID 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.25
         SIZE 68 BY 11.25 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 11.88
         WIDTH              = 70.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* REPARENT FRAME */
ASSIGN FRAME fpage0:FRAME = FRAME espdp055a:HANDLE.

/* SETTINGS FOR FRAME espdp055a
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fpage0
                                                                        */
ASSIGN 
       ed-layout:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda W-Win
ON CHOOSE OF bt-ajuda IN FRAME fpage0 /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo W-Win
ON CHOOSE OF bt-arquivo IN FRAME fpage0
DO:
  DEF VAR l-ok AS LOG NO-UNDO.
  DEF VAR c-arquivo AS CHAR FORMAT "x(200)" NO-UNDO.

  /* Solicita arquivo que ser† importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN RETURN "NOK":U.

    ASSIGN fi-arquivo:SCREEN-VALUE IN FRAME fpage0 = c-arquivo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME fpage0 /* Importar */
DO:
  

    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1" THEN DO:
        /* CONFIRMA IMPORTAÄ«O */
        run utp/ut-msgs.p (input "show", input 27100, input "Atená∆o! Confirma importaá∆o das previs‰es de entrega por item?").
        IF  RETURN-VALUE <> "YES" THEN RETURN.

        RUN pi-importa.

    END.
    ELSE DO:
        /* CONFIRMA A ELIMINAÄ«O */
        run utp/ut-msgs.p (input "show", input 27100, input "Atená∆o! Eliminaá∆o em lote atravÇs de arquivo" + "~~" +
                           "Nesta Opá∆o, todos os regisros constantes no arquivo ser∆o exclu°dos da base de dados. Confirma?").
        IF  RETURN-VALUE <> "YES" THEN RETURN.

        RUN pi-elimina.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo W-Win
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage0
DO:
  
    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1" THEN
        ASSIGN bt-ok:LABEL IN FRAME fpage0 = "Importar".
    ELSE
        ASSIGN bt-ok:LABEL IN FRAME fpage0 = "Eliminar".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME espdp055a
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN ed-layout:SCREEN-VALUE IN FRAME fpage0 = "4700002;1;01/01/2017" + chr(10) + 
                                                "4700008;2;01/12/2017" + chr(10) + 
                                                "4701218;3;01/02/2018" + chr(10).

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
  VIEW FRAME espdp055a IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-espdp055a}
  DISPLAY ed-layout rs-tipo fi-arquivo 
      WITH FRAME fpage0 IN WINDOW W-Win.
  ENABLE RECT-139 rt-buttom RECT-140 ed-layout rs-tipo bt-arquivo fi-arquivo 
         bt-cancela bt-ok bt-ajuda 
      WITH FRAME fpage0 IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initilize W-Win 
PROCEDURE local-initilize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina W-Win 
PROCEDURE pi-elimina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont-del  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha     AS CHAR        NO-UNDO.


    EMPTY TEMP-TABLE tt-item-dt-entrega.
    EMPTY TEMP-TABLE rowErrors.
    
    ASSIGN i-cont = 0.

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(fi-arquivo:SCREEN-VALUE IN FRAME fpage0) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        IMPORT c-linha.

        IF  c-linha <> "" THEN DO:
            CREATE tt-item-dt-entrega.
            ASSIGN tt-item-dt-entrega.it-codigo         = ENTRY(1,c-linha,";")
                   tt-item-dt-entrega.cod-gr-canais     = int(ENTRY(2,c-linha,";"))
                   tt-item-dt-entrega.dt-entrega-futura = date(ENTRY(3,c-linha,";"))
                   tt-item-dt-entrega.linha             = i-cont.
        END.
    END.
    INPUT CLOSE.
    
    /* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
    DO TRANS ON ERROR UNDO:

        FOR EACH tt-item-dt-entrega:
        
            FIND FIRST item-dt-entrega EXCLUSIVE-LOCK
                WHERE item-dt-entrega.it-codigo      = tt-item-dt-entrega.it-codigo
                  AND item-dt-entrega.cod-gr-canais  = tt-item-dt-entrega.cod-gr-canais NO-ERROR.
        
            RUN pi-acompanhar IN h-acomp (INPUT "Eliminando item: " + STRING(tt-item-dt-entrega.it-codigo) +  " / Gr. Canal: " + string(tt-item-dt-entrega.cod-gr-canais)).

            IF  NOT AVAIL item-dt-entrega THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Item: " + tt-item-dt-entrega.it-codigo + " / Gr. Canal: " + string(tt-item-dt-entrega.cod-gr-canais)
                       rowErrors.ErrorHelp        = "Registro n∆o existe. N∆o fui poss°vel eliminar! Linha: " + STRING(tt-item-dt-entrega.linha).
                UNDO, LEAVE.
            END.
            ELSE DO:
                DELETE item-dt-entrega.
                ASSIGN i-cont-del = i-cont-del + 1.
            END.
        END.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 15825,
                           INPUT "Eliminaá∆o conclu°da. " + string(i-cont-del) + " registro(s) eliminado(s)! ").
        
    END.
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa W-Win 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha     AS CHAR     NO-UNDO.

    EMPTY TEMP-TABLE tt-item-dt-entrega.
    EMPTY TEMP-TABLE rowErrors.
    
    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(fi-arquivo:SCREEN-VALUE IN FRAME fpage0) NO-ECHO.
    REPEAT:
        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).
        IMPORT c-linha.
        IF  c-linha <> "" THEN DO:
            CREATE tt-item-dt-entrega.
            ASSIGN tt-item-dt-entrega.it-codigo         = ENTRY(1,c-linha,";")
                   tt-item-dt-entrega.cod-gr-canais     = int(ENTRY(2,c-linha,";"))
                   tt-item-dt-entrega.dt-entrega-futura = date(ENTRY(3,c-linha,";"))
                   tt-item-dt-entrega.linha             = i-cont.
        END.
    END.
    INPUT CLOSE.
    
    /* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
    DO TRANS ON ERROR UNDO:
        FOR EACH  tt-item-dt-entrega EXCLUSIVE-LOCK:
    
            RUN pi-acompanhar IN h-acomp (INPUT "item: " + STRING(tt-item-dt-entrega.it-codigo) +  " / Gr. Canal: " + string(tt-item-dt-entrega.cod-gr-canais)).
    
            RUN pi-valida-imp IN THIS-PROCEDURE.

            IF  RETURN-VALUE = "NOK":U THEN DO:
                UNDO, LEAVE.
            END.
    
            CREATE item-dt-entrega.
            BUFFER-COPY tt-item-dt-entrega TO item-dt-entrega.
            i-cont = i-cont + 1.
        END.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importaá∆o conclu°da! " + string(i-cont) + " registro(s) importado(s).").
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-imp W-Win 
PROCEDURE pi-valida-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    /* VALIDAR ITEM */
    IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = tt-item-dt-entrega.it-codigo) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Item: " + tt-item-dt-entrega.it-codigo + " inv†lido."
               rowErrors.ErrorHelp        = "C¢digo de item n∆o cadastrado! Linha: " + STRING(tt-item-dt-entrega.linha).
        RETURN "NOK":U.
    END.

    /* VALIDAR GR CANAIS*/
    IF NOT CAN-FIND(FIRST grupo-canais WHERE grupo-canais.cod-gr-canais = tt-item-dt-entrega.cod-gr-canais) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Gr. Canal: " + string(tt-item-dt-entrega.cod-gr-canais) + " inv†lido."
               rowErrors.ErrorHelp        = "C¢digo de Grupo de Canal n∆o cadastrado! Linha: " + STRING(tt-item-dt-entrega.linha).
        RETURN "NOK":U.
    END.

    /* VALIDAR GR CANAIS*/
    IF CAN-FIND(FIRST item-dt-entrega 
                   WHERE item-dt-entrega.it-codigo     = tt-item-dt-entrega.it-codigo 
                     AND item-dt-entrega.cod-gr-canais = tt-item-dt-entrega.cod-gr-canais) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Registro j† existente: Item" + string(tt-item-dt-entrega.it-codigo) + " / Gr. Canal: " + STRING(tt-item-dt-entrega.cod-gr-canais)
               rowErrors.ErrorHelp        = "Linha: " + STRING(tt-item-dt-entrega.linha).
        RETURN "NOK":U.
    END.

    RETURN "OK".

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

  ASSIGN ed-layout:SCREEN-VALUE IN FRAME fpage0 = "4700002;1;01/01/2017" + chr(10) + 
                                                "4700008;2;01/12/2017" + chr(10) + 
                                                "4701218;3;01/02/2018" + chr(10).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

