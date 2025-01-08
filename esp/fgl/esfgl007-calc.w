&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME esfgl007b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esfgl007b 
{include/i-prgvrs.i esfgl007-calc 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


DEF INPUT PARAM p-operacao-sugerida AS CHAR FORMAT "x(15)" NO-UNDO.

{utp/ut-glob.i}


{esp/fgl/esfgl007.i}

    DEF STREAM s.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-mes rs-calcula bt-ok bt-cancelar ~
bt-fechar cb-ano fi-operacao rt-button RECT-119 
&Scoped-Define DISPLAYED-OBJECTS cb-mes rs-calcula cb-ano fi-operacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBeneficio esfgl007b 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto esfgl007b 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus esfgl007b 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esfgl007b AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancelar 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-fechar AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&calcula" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040" 
     DROP-DOWN-LIST
     SIZE 8.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per°odo" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6.29 BY 1 NO-UNDO.

DEFINE VARIABLE fi-operacao AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 TOOLTIP "Operaá∆o" NO-UNDO.

DEFINE VARIABLE rs-calcula AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todas", 1,
"Informada", 2
     SIZE 21 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.43 BY 3.63.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     cb-mes AT ROW 1.75 COL 15 COLON-ALIGNED WIDGET-ID 92
     rs-calcula AT ROW 3.25 COL 17 NO-LABEL WIDGET-ID 98
     bt-ok AT ROW 5.13 COL 1.86
     bt-cancelar AT ROW 5.13 COL 12.57 WIDGET-ID 58
     bt-fechar AT ROW 5.13 COL 50.43
     cb-ano AT ROW 1.75 COL 23.43 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     fi-operacao AT ROW 3.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 248
     "/" VIEW-AS TEXT
          SIZE 1.14 BY .54 AT ROW 1.92 COL 23.86 WIDGET-ID 94
          FONT 0
     "Calcular Operá∆o" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 3.46 COL 4 WIDGET-ID 102
     rt-button AT ROW 4.92 COL 1
     RECT-119 AT ROW 1.13 COL 1.57 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 60.72 BY 5.88
         FONT 1
         DEFAULT-BUTTON bt-cancelar.


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
  CREATE WINDOW esfgl007b ASSIGN
         HIDDEN             = YES
         TITLE              = "C†lculo Operaá∆o"
         HEIGHT             = 5.38
         WIDTH              = 60.72
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esfgl007b 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esfgl007b
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-cancelar:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-fechar:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007b)
THEN esfgl007b:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esfgl007b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007b esfgl007b
ON END-ERROR OF esfgl007b /* C†lculo Operaá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007b esfgl007b
ON WINDOW-CLOSE OF esfgl007b /* C†lculo Operaá∆o */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar esfgl007b
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar esfgl007b
ON CHOOSE OF bt-fechar IN FRAME f-cad /* Fechar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esfgl007b
ON CHOOSE OF bt-ok IN FRAME f-cad /* calcula */
DO:

    /*------------------------------------ VALIDAÄÂES GERAIS ------------------------------------*/

    DEF VAR c-periodo     AS CHAR NO-UNDO.
    DEF VAR c-periodo-ant AS CHAR NO-UNDO.
    DEF VAR i-mes-ant     AS INT  NO-UNDO.
    DEF VAR i-ano-ant     AS INT  NO-UNDO.

    ASSIGN c-periodo = cb-ano:SCREEN-VALUE IN FRAME f-cad + cb-mes:SCREEN-VALUE IN FRAME f-cad.
    
    IF  cb-mes:SCREEN-VALUE IN FRAME f-cad = "01" THEN 
        ASSIGN i-mes-ant = 12
               i-ano-ant = int(cb-ano:SCREEN-VALUE IN FRAME f-cad) - 1.
    ELSE 
        ASSIGN i-mes-ant = int(cb-mes:SCREEN-VALUE IN FRAME f-cad) - 1
               i-ano-ant = int(cb-ano:SCREEN-VALUE IN FRAME f-cad).

    ASSIGN c-periodo-ant = STRING(i-ano-ant, "9999") + STRING(i-mes-ant, "99").

    /* PARA OPERAÄ«O INFORMADA */
    IF  rs-calcula:SCREEN-VALUE IN FRAME f-cad = "2" 
    AND NOT CAN-FIND (int-operacao
                        WHERE int-operacao.operacao = fi-operacao:SCREEN-VALUE IN FRAME f-cad) THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Operaá∆o inexistente").

         RETURN NO-APPLY.
    END.

    DEF VAR c-erro-operacao AS CHAR FORMAT "x(200)" NO-UNDO.
    DEF VAR c-erro          AS CHAR FORMAT "x(200)" NO-UNDO.
    /*----------------------------------------- GRAVAÄ«O-----------------------------------------*/

    DEF VAR c-arquivo AS CHAR NO-UNDO.
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "Rel_Calculo_Operacao_" + STRING(DAY(TODAY)) + "-" + STRING(MONTH(TODAY)) + "-" + STRING(YEAR(TODAY)) + "_" + STRING(TIME) + ".csv".
    OUTPUT STREAM s TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT STREAM s "Calculada;Operaá∆o;Fechamento;Vencimento;Valor Operaá∆o; Observaá∆o" SKIP.

    IF  rs-calcula:SCREEN-VALUE IN FRAME f-cad = "2" THEN DO: /* INFORMADA */
        
        FIND FIRST int-operacao NO-LOCK
            WHERE int-operacao.operacao = fi-operacao:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

        /*   V A L I D A Ä Â E S   */
        /* N∆o permite c†lculo se periodo de fechamento e vencimento forem iguais */
        IF  MONTH (int-operacao.dt-fechamento) = MONTH(int-operacao.dt-vencimento) 
        AND YEAR  (int-operacao.dt-fechamento) = YEAR (int-operacao.dt-vencimento)THEN
            ASSIGN c-erro-operacao = "Per°odo de fechamento Ç igual ao vencimento." + " | ".

        /* Caso j† exista movimento para o per°odo informado em tela */
        FOR FIRST int-operacao-lancto NO-LOCK
             WHERE int-operacao-lancto.operacao  = int-operacao.operacao
               AND int-operacao-lancto.periodo   = c-periodo:
            RUN utp/ut-msgs.p(INPUT "show":U,
                              INPUT 17006,
                              INPUT "Per°odo j† est† calculado" ).
                    
            RETURN NO-APPLY.
        END.

        /*Verifica lanáamento inicial no màs de fechamento */
        FOR FIRST int-operacao-lancto NO-LOCK
             WHERE int-operacao-lancto.operacao  = int-operacao.operacao
               AND int-operacao-lancto.periodo   = (STRING(YEAR(int-operacao.dt-fechamento), "9999") + STRING(MONTH(int-operacao.dt-fechamento), "99"))
               AND int-operacao-lancto.tp-lancto = "C":
        END.
        IF  NOT AVAIL int-operacao-lancto 
        AND c-periodo <> (STRING(YEAR(int-operacao.dt-fechamento), "9999") + STRING(MONTH(int-operacao.dt-fechamento), "99")) THEN DO:
            RUN utp/ut-msgs.p(INPUT "show":U,
                              INPUT 17006,
                              INPUT "Deve existir previamente um c†lculo para o màs de fechamento." ).
            RETURN NO-APPLY.
        END.

        /* Verifica o lanáamento anterior */
        FIND LAST int-operacao-lancto NO-LOCK
             WHERE int-operacao-lancto.operacao  = int-operacao.operacao
               AND int-operacao-lancto.tp-lancto = "C" NO-ERROR.

        IF  AVAIL int-operacao-lancto
        AND int-operacao-lancto.periodo <> c-periodo-ant THEN DO:
        
            RUN utp/ut-msgs.p(INPUT "show":U,
                              INPUT 17006,
                              INPUT "Èltimo per°odo calculado deve ser imediatamente anterior ao per°odo proposto para c†lculo." ).
            RETURN NO-APPLY.
        END.


        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 27100,
                          INPUT "Confirma C†lculo da operaá∆o < " + int-operacao.operacao + " > para o per°odo?" + "~~" +
                                "Apenas a operaá∆o informada").
        IF  RETURN-VALUE = "no" THEN 
            RETURN NO-APPLY.

        RUN pi-calcula-operacao (OUTPUT c-erro).

        IF  c-erro <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT c-erro).
            RETURN NO-APPLY.
        END.

        
        PUT STREAM s   (IF c-erro-operacao <> "" THEN "N∆o" ELSE "SIM")  FORMAT "X(3)"  ";"
                        int-operacao.operacao                                            ";"
                        int-operacao.dt-fechamento                                       ";"
                        int-operacao.dt-vencimento                                       ";"
                        int-operacao.val-operacao                                        ";"
                        (IF c-erro-operacao <> "" THEN c-erro-operacao ELSE "Calculada") FORMAT "x(300)" SKIP.


    END.
    /*********/
    /* TODAS */
    /*********/
    ELSE DO:  

        DEF VAR da-data-vencto       AS DATE NO-UNDO.
        DEF VAR da-data-fechamento   AS DATE NO-UNDO.
        
        DO WITH FRAME f-cad:
            ASSIGN da-data-vencto = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)).
        
/*             IF  cb-mes:SCREEN-VALUE = "12" THEN                                      */
/*                 da-data = DATE(int(cb-mes:SCREEN-VALUE),31,YEAR(da-data)).           */
/*             ELSE                                                                     */
/*                 da-data = DATE(int(cb-mes:SCREEN-VALUE) + 1, 01,YEAR(da-data)) - 1.  */


            ASSIGN da-data-fechamento = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)).
        
            IF  cb-mes:SCREEN-VALUE = "12" THEN
                da-data-fechamento = DATE(int(cb-mes:SCREEN-VALUE),31,YEAR(da-data-fechamento)).
            ELSE
                da-data-fechamento = DATE(int(cb-mes:SCREEN-VALUE) + 1, 01,YEAR(da-data-fechamento)) - 1.

        END.

        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 27100,
                          INPUT "Confirma C†lculo das operaá‰es para o per°odo?" + "~~" +
                                "Ser∆o calculadas todas as operaá‰es com datas iguais ou inferiores ao per°odo informado." ).
        IF  RETURN-VALUE = "no" THEN 
            RETURN NO-APPLY.

        
        /* ------------------------------------------------------------------------ PROCESSA AS OPERAÄÂES --------------------------------------------------------------------------*/
        FOR EACH int-operacao NO-LOCK
            WHERE int-operacao.dt-fechamento <= da-data-fechamento
             AND  int-operacao.dt-vencimento >= da-data-vencto:
        
            ASSIGN c-erro-operacao = ""
                   c-erro          = "".

            /*   V A L I D A Ä Â E S   */
            /* N∆o permite c†lculo se periodo de fechamento e vencimento forem iguais */
            IF  MONTH (int-operacao.dt-fechamento) = MONTH(int-operacao.dt-vencimento) 
            AND YEAR  (int-operacao.dt-fechamento) = YEAR (int-operacao.dt-vencimento)THEN
                ASSIGN c-erro-operacao = "Per°odo de fechamento Ç igual ao vencimento." + " | ".

            /* Caso j† exista movimento para o per°odo informado em tela */
            FOR FIRST int-operacao-lancto NO-LOCK
                 WHERE int-operacao-lancto.operacao  = int-operacao.operacao
                   AND int-operacao-lancto.periodo   = c-periodo:

                  ASSIGN c-erro-operacao = "Per°odo j† est† calculado" + " | ".
                  PUT STREAM s (IF c-erro-operacao <> "" THEN "N∆o" ELSE "SIM")  FORMAT "X(3)"  ";"
                                int-operacao.operacao                                            ";"
                                int-operacao.dt-fechamento                                       ";"
                                int-operacao.dt-vencimento                                       ";"
                                int-operacao.val-operacao                                        ";"
                                (IF c-erro-operacao <> "" THEN c-erro-operacao ELSE "Calculada") FORMAT "x(300)" SKIP.
                
                NEXT.
            END.
                       
            /*Verifica lanáamento inicial no màs de fechamento */
            FOR FIRST int-operacao-lancto NO-LOCK
                 WHERE int-operacao-lancto.operacao  = int-operacao.operacao
                   AND int-operacao-lancto.periodo   = (STRING(YEAR(int-operacao.dt-fechamento), "9999") + STRING(MONTH(int-operacao.dt-fechamento), "99"))
                   AND int-operacao-lancto.tp-lancto = "C":
                /*IF  c-periodo <> int-operacao-lancto.periodo THEN*/
            END.
            IF  NOT AVAIL int-operacao-lancto 
            AND c-periodo <> (STRING(YEAR(int-operacao.dt-fechamento), "9999") + STRING(MONTH(int-operacao.dt-fechamento), "99")) THEN
                ASSIGN c-erro-operacao = "Deve existir previamente um c†lculo para o màs de fechamento." + " | ".

            /* Verifica o lanáamento anterior */
            FIND LAST int-operacao-lancto NO-LOCK
                 WHERE int-operacao-lancto.operacao  = int-operacao.operacao
                   AND int-operacao-lancto.tp-lancto = "C" NO-ERROR.

            IF  AVAIL int-operacao-lancto
            AND int-operacao-lancto.periodo <> c-periodo-ant THEN
                ASSIGN c-erro-operacao = c-erro-operacao + "Èltimo per°odo calculado deve ser imediatamente anterior ao per°odo proposto para c†lculo." + " | ".
                   
            /************* C µ L C U L O **************/
            IF  c-erro-operacao = "" THEN
                RUN pi-calcula-operacao (OUTPUT c-erro).

            IF  c-erro <> "" THEN
                ASSIGN c-erro-operacao = c-erro-operacao + c-erro.

            PUT STREAM s (IF c-erro-operacao <> "" THEN "N∆o" ELSE "SIM")  FORMAT "X(3)"  ";"
                          int-operacao.operacao                                            ";"
                          int-operacao.dt-fechamento                                       ";"
                          int-operacao.dt-vencimento                                       ";"
                          int-operacao.val-operacao                                        ";"
                          (IF c-erro-operacao <> "" THEN c-erro-operacao ELSE "Calculada") FORMAT "x(300)" SKIP.
        END.

    END.

    OUTPUT STREAM s CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).

    apply "close":U to this-procedure.
    
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-calcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-calcula esfgl007b
ON VALUE-CHANGED OF rs-calcula IN FRAME f-cad
DO:
  
    IF  rs-calcula:SCREEN-VALUE IN FRAME f-cad = "1" THEN
        ASSIGN fi-operacao:VISIBLE IN FRAME f-cad = NO.
               
    ELSE
        ASSIGN fi-operacao:VISIBLE IN FRAME f-cad = YES.
               

    fi-operacao:SCREEN-VALUE IN FRAME f-cad = p-operacao-sugerida.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esfgl007b 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esfgl007b  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esfgl007b  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esfgl007b  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007b)
  THEN DELETE WIDGET esfgl007b.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esfgl007b  _DEFAULT-ENABLE
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
  DISPLAY cb-mes rs-calcula cb-ano fi-operacao 
      WITH FRAME f-cad IN WINDOW esfgl007b.
  ENABLE cb-mes rs-calcula bt-ok bt-cancelar bt-fechar cb-ano fi-operacao 
         rt-button RECT-119 
      WITH FRAME f-cad IN WINDOW esfgl007b.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esfgl007b.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esfgl007b 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esfgl007b 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
     
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esfgl007b 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esfgl007b 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/win-size.i}
    
    {utp/ut9000.i "esfgl007-calc" "2.00.00.000"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    RUN dispatch  IN this-procedure ('display-fields':U).

    DO WITH FRAME f-cad:
    
        ASSIGN  cb-mes:SENSITIVE        = YES
                cb-mes:SCREEN-VALUE     = string(MONTH(TODAY),"99")
                cb-ano:SENSITIVE        = YES
                cb-ano:SCREEN-VALUE     = string(YEAR(TODAY))
                rs-calcula:SENSITIVE    = YES
                rs-calcula:SCREEN-VALUE = "2"
                fi-operacao:SENSITIVE   = yes.

        APPLY "value-changed" TO rs-calcula.
    END.
{include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-operacao esfgl007b 
PROCEDURE pi-calcula-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-erro AS CHAR NO-UNDO.

    DEF VAR de-cotacao           AS DEC NO-UNDO.
    DEF VAR de-variacao-inicial  AS DEC NO-UNDO.
    DEF VAR de-valor-lancto      AS DEC NO-UNDO.
    DEF VAR de-variacao-atual    AS DEC NO-UNDO.
    DEF VAR da-data              AS DATE NO-UNDO.
    DEF BUFFER b-int-operacao FOR int-operacao.
    
    RUN pi-retorna-cotacao (INPUT  int-operacao.cod-moeda,
                            INPUT  INT(cb-mes:SCREEN-VALUE IN FRAME f-cad),
                            INPUT  INT(cb-ano:SCREEN-VALUE IN FRAME f-cad),
                            OUTPUT de-cotacao,
                            OUTPUT p-erro).

    IF  de-cotacao <= 0 OR p-erro <> "" THEN
        RETURN "NOK".


                         /*  C µ L C U L O   D A   O P E R A Ä « O   */

    ASSIGN de-variacao-inicial = int-operacao.cotacao * int-operacao.val-operacao
           de-variacao-atual   = de-cotacao * int-operacao.val-operacao.

    /* VALOR LANÄAMENTO (VARIAÄ«O EM REAIS) */
    ASSIGN de-valor-lancto =  de-variacao-atual - de-variacao-inicial.

    /*-------------------------- CASO Jµ EXISTA UM CµLCULO ---------------------------*/

    /*  DEVE REVERTER LANÄAMENTO ANTERIOR                                             */
    DEF BUFFER b-lancto FOR int-operacao-lancto.
    FOR LAST b-lancto NO-LOCK
        WHERE b-lancto.operacao  = int-operacao.operacao
          AND b-lancto.tp-lancto = "C": /* C†lculo*/
            
        DO TRANS:
    
            CREATE int-operacao-lancto.
            
            ASSIGN int-operacao-lancto.operacao  = int-operacao.operacao
                   int-operacao-lancto.tp-lancto = "R" /* Reverte movto anterior */
                   int-operacao-lancto.periodo   = cb-ano:SCREEN-VALUE IN FRAME f-cad +
                                                   cb-mes:SCREEN-VALUE IN FRAME f-cad
                   int-operacao-lancto.variacao  = b-lancto.variacao * (-1).
                   int-operacao-lancto.cotacao   = b-lancto.cotacao.
    
            FIND CURRENT int-operacao-lancto NO-LOCK NO-ERROR.
            RELEASE int-operacao-lancto NO-ERROR.
    
        END.

    END.
     
    DEF VAR l-gerar-calculo AS LOG INIT YES NO-UNDO.

    /*--------------- CASO O ÈLTIMO LANÄAMENTO SEJA O DO PR‡PRIO PER÷ODO -------------*/
    IF  int(cb-ano:SCREEN-VALUE IN FRAME f-cad) =  YEAR(int-operacao.dt-vencimento)
    AND int(cb-mes:SCREEN-VALUE IN FRAME f-cad) = MONTH(int-operacao.dt-vencimento) THEN DO:
        ASSIGN l-gerar-calculo  = NO.     
    END.


    /* Calcula £ltimo dia do per°odo selecionado */
    ASSIGN da-data = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)).
    IF  cb-mes:SCREEN-VALUE = "12" THEN
        da-data = DATE(int(cb-mes:SCREEN-VALUE),31,YEAR(da-data)).
    ELSE
        da-data = DATE(int(cb-mes:SCREEN-VALUE) + 1, 01,YEAR(da-data)) - 1.

    FOR FIRST b-int-operacao NO-LOCK
        WHERE b-int-operacao.operacao       = int-operacao.operacao
         AND  b-int-operacao.dt-fechamento <= da-data
         AND  b-int-operacao.dt-vencimento >= da-data:

    END.
    IF  NOT AVAIL b-int-operacao THEN
        ASSIGN l-gerar-calculo  = NO. 

    /*------------------------------- CRIA LANÄAMENTO --------------------------------*/
    IF  l-gerar-calculo THEN
    DO TRANS:

        CREATE b-lancto.
        
        ASSIGN b-lancto.operacao  = int-operacao.operacao
               b-lancto.tp-lancto =  "C" /* C†lculo */
               b-lancto.periodo   = cb-ano:SCREEN-VALUE IN FRAME f-cad +
                                    cb-mes:SCREEN-VALUE IN FRAME f-cad
               b-lancto.variacao  = de-valor-lancto
               b-lancto.cotacao   = de-cotacao.

        FIND CURRENT b-lancto NO-LOCK NO-ERROR.
        RELEASE b-lancto NO-ERROR.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-cotacao esfgl007b 
PROCEDURE pi-retorna-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-moeda   AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-mes     AS INT NO-UNDO.
    DEF INPUT  PARAM p-ano     AS INT NO-UNDO.
    DEF OUTPUT PARAM p-cotacao AS DECIMAL DECIMALS 10.
    DEF OUTPUT PARAM p-erro    AS CHAR NO-UNDO.

    DEF VAR da-data AS DATE NO-UNDO.

    ASSIGN da-data = date(p-mes, 01, p-ano).

    IF  p-mes = 12 THEN
        da-data = DATE(p-mes,31,YEAR(da-data)).
    ELSE 
        da-data = DATE(p-mes + 1, 01,YEAR(da-data)) - 1.

    DEFINE VARIABLE v_dat_cotac_indic_econ AS DATE        NO-UNDO.
    DEFINE VARIABLE v_val_cotac_indic_econ AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_cod_return           AS CHARACTER   NO-UNDO.

    run pi_achar_cotac_indic_econ (Input "Real",     /* moeda base   - Fixo Real                 */
                                   Input p-moeda,    /* moeda indice - Moeda da Operaá∆o         */
                                   Input da-data,    /* £ltimo dia do màs do per°odo da operacao */
                                   Input "Real"      /* tipo cotaá∆o - Fixo Real                 */,
                                   output v_dat_cotac_indic_econ,
                                   output v_val_cotac_indic_econ,
                                   output v_cod_return) /*pi_achar_cotac_indic_econ*/.

    IF  v_cod_return <> "OK" THEN DO:
        ASSIGN p-erro = "N∆o foi poss°vel retornar a cotaá∆o ou a cotaá∆o Ç inexistente.".
        RETURN "NOK".
    END.

    IF  v_val_cotac_indic_econ = 0  THEN DO:
        ASSIGN p-erro = "N∆o foi poss°vel retornar a cotaá∆o ou a cotaá∆o Ç inexistente.".
        RETURN "NOK".
    END.


    ASSIGN p-cotacao = v_val_cotac_indic_econ.
           
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esfgl007b  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esfgl007b 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBeneficio esfgl007b 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto esfgl007b 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus esfgl007b 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-status:
      WHEN 1 THEN RETURN "Ativo".
      WHEN 2 THEN RETURN "Bloqueado".
      WHEN 3 THEN RETURN "Cancelado".
      WHEN 4 THEN RETURN "Finalizado".
  END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

