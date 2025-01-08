&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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

/* Local Variable Definitions ---                                       */


DEF INPUT PARAM c-item-pai AS CHAR FORMAT "x(16)" NO-UNDO.

DEF TEMP-TABLE tt-int-rateio-kit
    FIELD it-codigo     LIKE int-rateio-kit.it-codigo     
    FIELD it-componente LIKE int-rateio-kit.it-componente 
    FIELD perc-custo    LIKE int-rateio-kit.perc-custo    
    FIELD perc-fatur    LIKE int-rateio-kit.perc-fatur    
    FIELD r-rowid AS ROWID
    FIELD descricao AS CHAR FORMAT "x(40)".

DEFINE VARIABLE c-descricao LIKE ITEM.desc-item NO-UNDO.
DEF VAR l-mouse AS LOG NO-UNDO.

DEF BUFFER b-tt-int-rateio-kit FOR tt-int-rateio-kit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brFilhos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-rateio-kit

/* Definitions for BROWSE brFilhos                                      */
&Scoped-define FIELDS-IN-QUERY-brFilhos tt-int-rateio-kit.it-componente tt-int-rateio-kit.descricao tt-int-rateio-kit.perc-custo tt-int-rateio-kit.perc-fatur   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brFilhos tt-int-rateio-kit.it-componente ~
tt-int-rateio-kit.perc-custo ~
tt-int-rateio-kit.perc-fatur   
&Scoped-define ENABLED-TABLES-IN-QUERY-brFilhos tt-int-rateio-kit
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brFilhos tt-int-rateio-kit
&Scoped-define SELF-NAME brFilhos
&Scoped-define QUERY-STRING-brFilhos FOR EACH tt-int-rateio-kit     WHERE tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0        BY tt-int-rateio-kit.it-codigo
&Scoped-define OPEN-QUERY-brFilhos OPEN QUERY {&SELF-NAME} FOR EACH tt-int-rateio-kit     WHERE tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0        BY tt-int-rateio-kit.it-codigo.
&Scoped-define TABLES-IN-QUERY-brFilhos tt-int-rateio-kit
&Scoped-define FIRST-TABLE-IN-QUERY-brFilhos tt-int-rateio-kit


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brFilhos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-20 RECT-21 c-it-pai ~
c-desc-it-pai brFilhos bt-incluir bt-retirar bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-it-pai c-desc-it-pai 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descricao w-window 
FUNCTION fn-descricao RETURNS CHARACTER
  ( pItem AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 11.57 BY 1.13.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-retirar 
     LABEL "Excluir" 
     SIZE 11.57 BY 1.13.

DEFINE VARIABLE c-desc-it-pai AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-pai AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item Pai" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.29 BY 1.79.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 1.79.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brFilhos FOR 
      tt-int-rateio-kit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brFilhos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFilhos w-window _FREEFORM
  QUERY brFilhos DISPLAY
      tt-int-rateio-kit.it-componente
      tt-int-rateio-kit.descricao
      tt-int-rateio-kit.perc-custo
      tt-int-rateio-kit.perc-fatur
  ENABLE
      tt-int-rateio-kit.it-componente
      tt-int-rateio-kit.perc-custo
      tt-int-rateio-kit.perc-fatur
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ROW-MARKERS SEPARATORS SIZE 84 BY 8.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-it-pai AT ROW 1.63 COL 13 COLON-ALIGNED WIDGET-ID 12
     c-desc-it-pai AT ROW 1.63 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     brFilhos AT ROW 3.5 COL 2 WIDGET-ID 200
     bt-incluir AT ROW 12.25 COL 30.72 WIDGET-ID 20
     bt-retirar AT ROW 12.25 COL 43.29 WIDGET-ID 22
     bt-ok AT ROW 14.08 COL 2.86
     bt-cancelar AT ROW 14.08 COL 14.14
     bt-ajuda AT ROW 14.08 COL 75.29
     RECT-1 AT ROW 13.88 COL 2
     RECT-20 AT ROW 1.21 COL 1.72 WIDGET-ID 14
     RECT-21 AT ROW 11.96 COL 2 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 14.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Componentes do Kit"
         HEIGHT             = 14.5
         WIDTH              = 86.14
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brFilhos c-desc-it-pai fpage0 */
ASSIGN 
       c-desc-it-pai:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       c-it-pai:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFilhos
/* Query rebuild information for BROWSE brFilhos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-rateio-kit
    WHERE tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0
       BY tt-int-rateio-kit.it-codigo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brFilhos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Componentes do Kit */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Componentes do Kit */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFilhos
&Scoped-define SELF-NAME brFilhos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON END-ERROR OF brFilhos IN FRAME fpage0
DO:
    if  brFilhos:new-row in frame fpage0 then do:
        if  avail tt-int-rateio-kit then do:
            delete tt-int-rateio-kit.
            end.
        if  brFilhos:delete-current-row() in frame fpage0 then.
    end.
    else do:
        get current brFilhos.
        display tt-int-rateio-kit.it-componente 
                tt-int-rateio-kit.descricao
                tt-int-rateio-kit.perc-custo
                tt-int-rateio-kit.perc-fatur with browse brFilhos.
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON F5 OF brFilhos IN FRAME fpage0
DO:
    if  not avail tt-int-rateio-kit 
   and not brFilhos:new-row in frame FPAGE0 then
       return no-apply.
   {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                      &campo=tt-int-rateio-kit.it-componente
                      &campozoom=it-codigo
                      &browse=brFilhos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON MOUSE-SELECT-CLICK OF brFilhos IN FRAME fpage0
DO:
  assign l-mouse = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON MOUSE-SELECT-DBLCLICK OF brFilhos IN FRAME fpage0
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON OFF-END OF brFilhos IN FRAME fpage0
DO:
  apply 'entry' to bt-incluir in frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON RETURN OF brFilhos IN FRAME fpage0
DO:
  APPLY "tab" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilhos w-window
ON ROW-LEAVE OF brFilhos IN FRAME fpage0
DO:

   assign l-mouse = no.
   if  not valid-handle (wh-pesquisa) and num-results("brFilhos") > 0 then do:
      if  brFilhos:new-row in frame fpage0 then do on error undo, return no-apply:
          /*
          if  can-find(b-tt-int-rateio-kit
                  where b-tt-int-rateio-kit.it-componente = tt-int-rateio-kit.it-componente:screen-value
                                                  in browse BrFilhos)
          THEN DO:
              run utp/ut-msgs.p (input "show", input 108, input "").
              apply "ENTRY":U to tt-int-rateio-kit.it-componente in browse BrFilhos.
              return no-apply.
          end.
          else 
          */   run pi-cria-tt-rateio.

  end. /*
  ELSE
     run pi-cria-tt-rateio.
       */

  if BrFilhos:new-row then BrFilhos:create-result-list-entry() in frame fpage0.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME fpage0 /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME fpage0 /* Cancelar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-window
ON CHOOSE OF bt-incluir IN FRAME fpage0 /* Incluir */
DO:
   
    if num-results("BrFilhos") > 0 THEN DO:
        BrFilhos:INSERT-ROW("after") in frame fpage0.
    END.
    else do transaction:
        create tt-int-rateio-kit.
        ASSIGN tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0.
        open query BrFilhos for each tt-int-rateio-kit NO-LOCK.

        apply 'entry' to tt-int-rateio-kit.it-componente in browse BrFilhos. 
    end.
    /*
    APPLY "entry" TO brFilhos.
    APPLY "f5" TO brFilhos.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME fpage0 /* OK */
DO:
    
    DEF VAR c-erro-item         AS CHAR NO-UNDO.
    DEF VAR c-erro-fatur-zerado AS CHAR NO-UNDO.
    DEF VAR c-erro-custo-zerado AS CHAR NO-UNDO.
    DEF VAR c-erro-aux          AS CHAR NO-UNDO.
    DEF VAR de-tot-custo AS DEC NO-UNDO.
    DEF VAR de-tot-fatur AS DEC NO-UNDO.

    /* Valida Itens existentes na base ou obsoletos */
    DO WITH FRAME fpage0:
        FOR EACH tt-int-rateio-kit:
            IF NOT CAN-FIND(FIRST item
                            WHERE item.it-codigo = tt-int-rateio-kit.it-componente 
                              AND ITEM.cod-obsoleto <> 4) THEN DO:
                IF  c-erro-item = "" THEN
                    ASSIGN c-erro-item = "<" + tt-int-rateio-kit.it-componente + ">".
                ELSE
                    ASSIGN c-erro-item = c-erro-item + chr(10) + "<" + tt-int-rateio-kit.it-componente + ">".
            END.
        END.

        IF  c-erro-item <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Itens n∆o cadastrados ou obsoletos~~" + c-erro-item).
            RETURN NO-APPLY.
        END.
        
        /* Valida Itens DUPLICADOS */
        ASSIGN c-erro-item = "".
        FOR EACH tt-int-rateio-kit:

            IF   CAN-FIND(FIRST b-tt-int-rateio-kit
                            WHERE b-tt-int-rateio-kit.it-componente = tt-int-rateio-kit.it-componente 
                              AND rowid(b-tt-int-rateio-kit) <> rowid(tt-int-rateio-kit)) THEN DO:
                IF  c-erro-item = "" THEN
                    ASSIGN c-erro-item = "<" + tt-int-rateio-kit.it-componente + ">" + "|".
                ELSE DO:
                    DEF VAR i AS INTEGER NO-UNDO.

                    ASSIGN c-erro-aux = c-erro-item.

                    DO  i = 1 TO NUM-ENTRIES(c-erro-aux, "|"):
                    
                        IF  ENTRY(i, c-erro-item, "|") = tt-int-rateio-kit.it-componente THEN
                            NEXT.
                        ELSE DO:
                            ASSIGN c-erro-item = c-erro-item +  "<" + tt-int-rateio-kit.it-componente + ">" +  "|".
                            LEAVE.
                        END.
                    END.
                END.
            END.
        END.

        IF  c-erro-item <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Itens aparecem mais de uma vez no rateio ~~" + c-erro-item).
            RETURN NO-APPLY.
        END.
        
        /* Valida percentuais zerados */
        FOR EACH tt-int-rateio-kit:
            IF  tt-int-rateio-kit.perc-fatur = 0  OR tt-int-rateio-kit.perc-fatur = ? THEN DO:
                IF  c-erro-fatur-zerado = "" THEN
                    c-erro-fatur-zerado = "<" + tt-int-rateio-kit.it-componente + ">".
                ELSE
                    c-erro-fatur-zerado = c-erro-fatur-zerado + CHR(10) + "<" + tt-int-rateio-kit.it-componente + ">".
             END.

            IF  tt-int-rateio-kit.perc-custo = 0 OR tt-int-rateio-kit.perc-custo = ? THEN
                IF  c-erro-custo-zerado = "" THEN
                    c-erro-custo-zerado = "<" + tt-int-rateio-kit.it-componente + ">".
                ELSE
                    c-erro-custo-zerado = c-erro-custo-zerado + CHR(10) + "<" + tt-int-rateio-kit.it-componente + ">" .
        END.

        IF  c-erro-custo-zerado <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Itens com % de custo zerados ~~" + c-erro-custo-zerado).
            RETURN NO-APPLY.
        END.
        IF  c-erro-fatur-zerado <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Itens com % de faturamento zerados ~~" + c-erro-fatur-zerado).
            RETURN NO-APPLY.
        END.
        
        /* Totalizar percentuais. Sempre devem somar 100%  */
        FOR EACH tt-int-rateio-kit NO-LOCK
            WHERE tt-int-rateio-kit.it-codigo     = c-it-pai:SCREEN-VALUE IN FRAME fpage0:
            ASSIGN de-tot-custo = de-tot-custo + tt-int-rateio-kit.perc-custo
                   de-tot-fatur = de-tot-fatur + tt-int-rateio-kit.perc-fatur.
        END.
        IF  de-tot-custo  <> 100 AND num-results("brFilhos") > 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "A Soma dos rateios deve ter % de Custo igual a 100%.").
            RETURN NO-APPLY.
        END.
        IF  de-tot-fatur <> 100 AND num-results("brFilhos") > 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "A Soma dos rateios deve ter % de Faturamento igual a 100%.").
            RETURN NO-APPLY.
        END.


    END.

    /* SALVA OS ALTERAÄÂES RATEIOS */
    DO TRANS ON ERROR UNDO, RETURN NO-APPLY:
        FOR EACH int-rateio-kit EXCLUSIVE-LOCK
            WHERE int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0:
            DELETE int-rateio-kit.
        END.

        FOR EACH tt-int-rateio-kit
            WHERE tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0:
            CREATE int-rateio-kit.
            BUFFER-COPY tt-int-rateio-kit EXCEPT r-rowid descricao TO int-rateio-kit.
        END.

    END.

    run utp/ut-msgs.p (input "show", input 27100, input "Confirma alteraá‰es para o Rateio?").
    IF  RETURN-VALUE <> "YES" THEN 
        RETURN NO-APPLY.

    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-window
ON CHOOSE OF bt-retirar IN FRAME fpage0 /* Excluir */
DO:
    if  brFilhos:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brFilhos.
        delete tt-int-rateio-kit NO-ERROR.
        if  brFilhos:delete-current-row() in frame fpage0  then.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */


on f5                    of tt-int-rateio-kit.it-componente in browse brFilhos
or mouse-select-dblclick of tt-int-rateio-kit.it-componente in browse brFilhos do:

    APPLY "f5" TO brfilhos IN FRAME fpage0.
               
end.

on leave of tt-int-rateio-kit.it-componente in browse brFilhos do:
   IF NUM-RESULTS("brFilhos") > 0 THEN DO:

       find item where item.it-codigo = 
                 tt-int-rateio-kit.it-componente:screen-value in browse brFilhos
           AND ITEM.cod-obsoleto <> 4 no-lock no-error.
       if  avail item then do:
           ASSIGN  tt-int-rateio-kit.descricao:SCREEN-VALUE = ITEM.desc-item NO-ERROR.               
       end.
       else do:
           run utp/ut-msgs.p (input 'show', INPUT 17006, input "Item inexistente ou obsoleto").
           apply "ENTRY" to tt-int-rateio-kit.it-componente in browse brFilhos.
       end.
        
   END.
end.   

on mouse-select-click of tt-int-rateio-kit.it-componente in browse brFilhos do:
   assign l-mouse = yes.
end.

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
  DISPLAY c-it-pai c-desc-it-pai 
      WITH FRAME fpage0 IN WINDOW w-window.
  ENABLE RECT-1 RECT-20 RECT-21 c-it-pai c-desc-it-pai brFilhos bt-incluir 
         bt-retirar bt-ok bt-cancelar bt-ajuda 
      WITH FRAME fpage0 IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
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
  
  {utp/ut9000.i "esftp121a" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN c-it-pai:SCREEN-VALUE IN FRAME fpage0 = c-item-pai  
         c-desc-it-pai:SCREEN-VALUE IN FRAME fpage0 = fn-descricao(c-item-pai).

  EMPTY TEMP-TABLE tt-int-rateio-kit.    

  FOR EACH int-rateio-kit NO-LOCK
      WHERE int-rateio-kit.it-codigo = c-item-pai:
      CREATE tt-int-rateio-kit.
      BUFFER-COPY int-rateio-kit TO tt-int-rateio-kit.
      ASSIGN tt-int-rateio-kit.r-rowid = ROWID(int-rateio-kit).

      ASSIGN tt-int-rateio-kit.descricao = fn-descricao(int-rateio-kit.it-componente).

  END.

  {&OPEN-QUERY-brFilhos}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-rateio w-window 
PROCEDURE pi-cria-tt-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do transaction:
      create tt-int-rateio-kit.
      assign tt-int-rateio-kit.it-codigo = c-it-pai:SCREEN-VALUE IN FRAME fpage0
             input browse brFilhos tt-int-rateio-kit.it-componente
             input browse brFilhos tt-int-rateio-kit.descricao
             input BROWSE brFilhos tt-int-rateio-kit.perc-custo 
             input BROWSE brFilhos tt-int-rateio-kit.perc-fatur.
  end.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-int-rateio-kit"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-descricao w-window 
FUNCTION fn-descricao RETURNS CHARACTER
  ( pItem AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST item
         WHERE item.it-codigo = pItem NO-LOCK NO-ERROR.

    IF AVAIL item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

