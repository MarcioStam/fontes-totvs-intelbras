&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i PRM4103A 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-rowid        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER p-copia        AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-proj-int AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 fi-cfop cb-tipo fi-estado ~
fi-it-codigo cb-ind-origem fi-nat-operacao tg-ind-contribuinte bt-ok ~
bt-cancelar 
&Scoped-Define DISPLAYED-OBJECTS fi-cfop c-nome-cfop cb-tipo fi-estado ~
c-no-estado fi-it-codigo c-desc-item cb-ind-origem fi-nat-operacao ~
c-nat-oper-venda tg-ind-contribuinte 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-ind-origem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "*","Comprado","Fabricado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Devolucao","Remessa","Retorno","Venda" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-oper-venda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-no-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-cfop AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cfop AS CHARACTER FORMAT "x(4)" 
     LABEL "CFOP" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "x(4)" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE fi-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 13.67.

DEFINE VARIABLE tg-ind-contribuinte AS LOGICAL INITIAL no 
     LABEL "Contribuinte ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cfop AT ROW 1.71 COL 23.14 COLON-ALIGNED WIDGET-ID 18
     c-nome-cfop AT ROW 1.71 COL 32.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     cb-tipo AT ROW 2.75 COL 23 COLON-ALIGNED WIDGET-ID 50
     fi-estado AT ROW 3.88 COL 23 COLON-ALIGNED WIDGET-ID 4
     c-no-estado AT ROW 3.88 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     fi-it-codigo AT ROW 4.88 COL 23 COLON-ALIGNED WIDGET-ID 8
     c-desc-item AT ROW 4.88 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     cb-ind-origem AT ROW 6 COL 23 COLON-ALIGNED WIDGET-ID 48
     fi-nat-operacao AT ROW 7.25 COL 23 COLON-ALIGNED WIDGET-ID 16
     c-nat-oper-venda AT ROW 7.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     tg-ind-contribuinte AT ROW 8.25 COL 25 WIDGET-ID 42
     bt-ok AT ROW 15.21 COL 3
     bt-cancelar AT ROW 15.21 COL 14
     RECT-1 AT ROW 15 COL 2
     RECT-2 AT ROW 1.33 COL 2.14 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 15.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 15.54
         WIDTH              = 79.57
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-oper-venda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-no-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-cfop IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    RUN pi-salvar.

    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cfop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cfop w-window
ON MOUSE-SELECT-DBLCLICK OF fi-cfop IN FRAME F-Main /* CFOP */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estado w-window
ON F5 OF fi-estado IN FRAME F-Main /* Estado */
DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                       &campo=fi-estado
                       &campozoom=estado
                       &campo2=c-no-estado
                       &campozoom2=no-estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estado w-window
ON LEAVE OF fi-estado IN FRAME F-Main /* Estado */
DO:
    IF fi-estado:INPUT-VALUE IN FRAME {&FRAME-NAME} = "*" THEN DO:
        ASSIGN c-no-estado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "TODOS".
    END.
    ELSE DO:
        {include/leave.i &tabela=unid-feder
                         &atributo-ref=no-estado
                         &variavel-ref=c-no-estado
                         &where="unid-feder.estado = input frame {&frame-name} fi-estado"}
        
        IF TRIM(c-no-estado:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
            ASSIGN fi-estado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estado w-window
ON MOUSE-SELECT-DBLCLICK OF fi-estado IN FRAME F-Main /* Estado */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo w-window
ON F5 OF fi-it-codigo IN FRAME F-Main /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo=fi-it-codigo
                       &campozoom=it-codigo
                       &campo2=c-desc-item
                       &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo w-window
ON LEAVE OF fi-it-codigo IN FRAME F-Main /* Item */
DO:
    IF fi-it-codigo:INPUT-VALUE IN FRAME {&FRAME-NAME} = "*" THEN DO:
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "TODOS".
    END.
    ELSE DO:
        {include/leave.i &tabela=ITEM
                         &atributo-ref=desc-item
                         &variavel-ref=c-desc-item
                         &where="item.it-codigo = input frame {&frame-name} fi-it-codigo"}
        
        IF TRIM(c-desc-item:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
            ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo w-window
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME F-Main /* Item */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao w-window
ON F5 OF fi-nat-operacao IN FRAME F-Main /* Nat Opera‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                       &campo=fi-nat-operacao
                       &campozoom=nat-operacao
                       &campo2=c-nat-oper-venda
                       &campozoom2=denominacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao w-window
ON LEAVE OF fi-nat-operacao IN FRAME F-Main /* Nat Opera‡Æo */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=c-nat-oper-venda
                     &where="natur-oper.nat-operacao = input frame {&frame-name} fi-nat-operacao"}
    
    IF TRIM(c-nat-oper-venda:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
        ASSIGN fi-nat-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao w-window
ON MOUSE-SELECT-DBLCLICK OF fi-nat-operacao IN FRAME F-Main /* Nat Opera‡Æo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY fi-cfop c-nome-cfop cb-tipo fi-estado c-no-estado fi-it-codigo 
          c-desc-item cb-ind-origem fi-nat-operacao c-nat-oper-venda 
          tg-ind-contribuinte 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-2 fi-cfop cb-tipo fi-estado fi-it-codigo cb-ind-origem 
         fi-nat-operacao tg-ind-contribuinte bt-ok bt-cancelar 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/win-size.i}
    
    {utp/ut9000.i "PRM4103A" "1.00.00.000"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    IF p-rowid <> ? THEN DO:

        FIND FIRST prm-regras-integrador NO-LOCK
             WHERE ROWID(prm-regras-integrador) = p-rowid NO-ERROR.
        IF AVAIL prm-regras-integrador THEN DO:

            ASSIGN fi-cfop           :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.cfop             .  
                   fi-estado         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.estado           .
                   cb-tipo           :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.tipo             .
                   fi-it-codigo      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.it-codigo        .
                   cb-ind-origem     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.origem-item      .
                   fi-nat-operacao   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.nat-operacao     .
                   tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME} = prm-regras-integrador.ind-contribuinte .

                   

        END.
    END.

    APPLY "LEAVE":U TO fi-cfop           IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO fi-estado         IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO fi-it-codigo      IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO fi-nat-operacao   IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO cb-ind-origem       IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO tg-ind-contribuinte IN FRAME {&FRAME-NAME}.

    fi-cfop           :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    fi-estado         :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    fi-it-codigo      :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    fi-nat-operacao   :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar w-window 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN pi-valida.
    IF RETURN-VALUE <> "OK":U THEN
        RETURN "NOK":U.
    
    IF p-rowid = ? THEN DO:
        
        CREATE prm-regras-integrador.
        ASSIGN prm-regras-integrador.cod-proj-int   = p-cod-proj-int
               prm-regras-integrador.cfop           = fi-cfop           :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.estado         = fi-estado         :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.it-codigo      = fi-it-codigo      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.nat-operacao   = fi-nat-operacao :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.tipo             = cb-tipo            :INPUT-VALUE IN FRAME {&FRAME-NAME}.
               
    END.
    ELSE IF p-rowid <> ?
        AND p-copia  = FALSE
    THEN DO:

        FIND FIRST prm-regras-integrador EXCLUSIVE-LOCK
             WHERE ROWID(prm-regras-integrador) = p-rowid NO-ERROR.
        IF AVAIL prm-regras-integrador THEN DO:
            
            ASSIGN prm-regras-integrador.cod-proj-int   = p-cod-proj-int
               prm-regras-integrador.cfop           = fi-cfop           :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.estado         = fi-estado         :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.it-codigo      = fi-it-codigo      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.nat-operacao   = fi-nat-operacao :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.tipo             = cb-tipo            :INPUT-VALUE IN FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE IF p-rowid <> ?
        AND p-copia  = TRUE
    THEN DO:

        CREATE prm-regras-integrador.
        ASSIGN prm-regras-integrador.cod-proj-int   = p-cod-proj-int
               prm-regras-integrador.cfop           = fi-cfop           :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.estado         = fi-estado         :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.it-codigo      = fi-it-codigo      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.nat-operacao   = fi-nat-operacao :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME}
               prm-regras-integrador.tipo             = cb-tipo            :INPUT-VALUE IN FRAME {&FRAME-NAME}.
    END.
    
    RELEASE prm-regras-integrador.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida w-window 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    IF TRIM(fi-estado:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Estado inv lido":U).
        
        APPLY "ENTRY":U TO fi-estado IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.


    IF TRIM(fi-it-codigo:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Item inv lido":U).
        
        APPLY "ENTRY":U TO fi-it-codigo IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.

    IF TRIM(fi-nat-operacao:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Nat Opera‡Æo inv lida":U).
        
        APPLY "ENTRY":U TO fi-nat-operacao IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.
    
    IF p-rowid = ? THEN DO:
        
        FIND FIRST prm-regras-integrador NO-LOCK
             WHERE prm-regras-integrador.cod-proj-int = p-cod-proj-int
               AND prm-regras-integrador.cfop  = fi-cfop:INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.estado       = fi-estado     :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.it-codigo    = fi-it-codigo  :INPUT-VALUE IN FRAME {&FRAME-NAME} 
               AND prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME}
            NO-ERROR.
        IF AVAIL prm-regras-integrador THEN DO:

            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 17006, /* erro */
                              INPUT "J  existe a regra com a chave informada").
            RETURN "NOK":U.
        END.
    END.
    ELSE IF p-rowid <> ?
        AND p-copia  = FALSE
    THEN DO:

        FIND FIRST prm-regras-integrador NO-LOCK
             WHERE prm-regras-integrador.cod-proj-int = p-cod-proj-int
               AND prm-regras-integrador.cfop  = fi-cfop:INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.estado       = fi-estado     :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.it-codigo    = fi-it-codigo  :INPUT-VALUE IN FRAME {&FRAME-NAME} 
               AND prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND ROWID(prm-regras-integrador)      <> p-rowid NO-ERROR.
        IF AVAIL prm-regras-integrador THEN DO:

            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 17006, /* erro */
                              INPUT "J  existe a regra com a chave informada").
            RETURN "NOK":U.
        END.
    END.
    ELSE IF p-rowid <> ?
        AND p-copia  = TRUE
    THEN DO:

        FIND FIRST prm-regras-integrador NO-LOCK
             WHERE prm-regras-integrador.cod-proj-int = p-cod-proj-int
               AND prm-regras-integrador.cfop  = fi-cfop:INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.estado       = fi-estado     :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.it-codigo    = fi-it-codigo  :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.origem-item      = cb-ind-origem      :INPUT-VALUE IN FRAME {&FRAME-NAME}
               AND prm-regras-integrador.ind-contribuinte = tg-ind-contribuinte:INPUT-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
        IF AVAIL prm-regras-integrador THEN DO:

            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 17006, /* erro */
                              INPUT "J  existe a regra com a chave informada").
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
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

