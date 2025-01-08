&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esclt004 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt004
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-ean13 fi-it-codigo fi-nr-serie bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE pit-codigo           AS   CHARACTER         NO-UNDO.
DEFINE VARIABLE lcompleto            AS   LOGICAL           NO-UNDO.
DEFINE VARIABLE i-contador           AS   INTEGER           NO-UNDO.
DEFINE VARIABLE c-nr-serie-principal LIKE num-serie.n-serie NO-UNDO. 
DEFINE VARIABLE i-conta-serie        AS   INTEGER           NO-UNDO.
DEFINE VARIABLE c-tipo-aux           AS   CHARACTER         NO-UNDO.
{esp/es0018.i}
{upc/btb910za-upc.i}
DEFINE VARIABLE l-ok                 AS   LOGICAL FORMAT "SIM/N«O" INIT YES NO-UNDO.

/* Buffers Definitions ---                                              */

/* Temp-tables Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-22 fi-ean13 fi-nr-serie fi-qtd ~
fi-qtd-col bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-ean13 fi-it-codigo fi-desc-item ~
fi-nr-serie fi-qtd fi-qtd-col 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 263 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-ean13 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Barras" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 210 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 82 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nr-serie AS CHARACTER FORMAT "x(20)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 210 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtd.Nr.SÇrie" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 35 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd-col AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtd.Col." 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 35 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 84.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 84.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ean13 AT Y 12 X 27 COLON-ALIGNED WIDGET-ID 30
     fi-it-codigo AT Y 36 X 27 COLON-ALIGNED WIDGET-ID 34
     fi-desc-item AT Y 60 X 27 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-nr-serie AT Y 102 X 27 COLON-ALIGNED WIDGET-ID 44
     fi-qtd AT Y 126 X 250 RIGHT-ALIGNED WIDGET-ID 46
     fi-qtd-col AT Y 150 X 250 RIGHT-ALIGNED WIDGET-ID 48
     bt-sair AT Y 259 X 247 WIDGET-ID 40
     RECT-19 AT Y 6 X 0 WIDGET-ID 14
     RECT-22 AT Y 96 X 0 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qtd IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-qtd-col IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ean13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON RETURN OF fi-ean13 IN FRAME fpage0 /* Barras */
DO:
    IF  INPUT FRAME fPage0 fi-ean13 = "" THEN APPLY 'entry':U TO fi-it-codigo IN FRAME fPage0.

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

        ASSIGN fi-qtd-col:SCREEN-VALUE IN FRAME fPage0 = "0".

        ASSIGN INPUT FRAME fPage0 fi-ean13.
        IF fi-ean13 = "":U THEN RETURN NO-APPLY.
        
        ASSIGN fi-ean13:SENSITIVE     IN FRAME fPage0 = FALSE
               fi-it-codigo:SENSITIVE IN FRAME fPage0 = FALSE.

        /*-[ EAN13 ]-*/
        FIND FIRST item-mat NO-LOCK WHERE item-mat.cod-ean = INPUT FRAME fPage0 fi-ean13 NO-ERROR.
        IF  NOT AVAIL item-mat THEN DO:
            /*-[ DUN14 ]-*/
            FIND FIRST item-dun NO-LOCK WHERE item-dun.cod-dun = INPUT FRAME fPage0 fi-ean13 NO-ERROR.
            IF  NOT AVAIL item-dun THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Item n∆o cadastrado ou n∆o possui c¢digo EAN13 ou DUN14.",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN fi-ean13 = "":U
                       fi-qtd   = 0.
                DISPLAY fi-ean13 WITH FRAME fPage0.
                UNDO BLOCO, LEAVE BLOCO.
            END. /* IF  NOT AVAIL item-dun THEN */
            ELSE ASSIGN pit-codigo = item-dun.it-codigo
                        c-tipo-aux = "DUN14":U.
        END. /* IF  NOT AVAIL item-ean THEN */
        ELSE ASSIGN pit-codigo = item-mat.it-codigo
                    c-tipo-aux = "EAN13":U.

        IF item-mat.cod-ean BEGINS "78966376"  THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "ITEM n∆o permite criaá∆o de Num.SÇrie.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN fi-ean13 = "":U
                       fi-qtd   = 0.
                DISPLAY fi-ean13 WITH FRAME fPage0.
                UNDO BLOCO, LEAVE BLOCO.
        END.

        FIND FIRST ITEM NO-LOCK
            WHERE  ITEM.it-codigo = pit-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            IF  ITEM.cod-obsoleto <> 1 /* Ativo */ THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Item obsoleto.":U + CHR(10) + "Informar o c¢digo " + c-tipo-aux + " do item com situaá∆o ATIVO.":U,
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN fi-ean13 = "":U
                       fi-qtd   = 0.
                DISPLAY fi-ean13 WITH FRAME fPage0.
                UNDO BLOCO, LEAVE BLOCO.
            END. /* IF  ITEM.cod-obsoleto <> 1 */
            ELSE ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ITEM.it-codigo
                        fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
        END. /* IF  AVAIL ITEM THEN DO: */

        APPLY "return":U TO fi-it-codigo IN FRAME fPage0.

    END. /* DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO: */

    IF  fi-qtd = 0 THEN DO:
        BELL.
        CLEAR FRAME fPage0 ALL.

        ASSIGN fi-ean13:SENSITIVE     IN FRAME fpage0 = TRUE
               fi-it-codigo:SENSITIVE IN FRAME fpage0 = TRUE
               fi-nr-serie:SENSITIVE  IN FRAME fPage0 = FALSE
               .
        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END. /* IF  fi-qtd = 1 THEN DO: */
    ELSE DO:
        ASSIGN fi-nr-serie:SENSITIVE  IN FRAME fPage0 = TRUE.

        APPLY "ENTRY":U TO fi-nr-serie IN FRAME fPage0.
    END.
    /* -------------------------------------------------------------- */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON RETURN OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    BLOCO_item:
    DO  TRANSACTION ON ERROR UNDO BLOCO_item, LEAVE BLOCO_item:

        ASSIGN fi-qtd-col:SCREEN-VALUE IN FRAME fPage0 = "0".

        ASSIGN INPUT FRAME fPage0 fi-it-codigo.
        IF fi-it-codigo = "":U THEN RETURN NO-APPLY.
        
        ASSIGN fi-it-codigo:SENSITIVE IN FRAME fPage0 = FALSE
               fi-ean13:SENSITIVE     IN FRAME fPage0 = FALSE.

        /*---[ Leitura do EAN13 ou DUN14 ]----------------------------------------------------------*/
        /*-[ EAN13 ]-*/
        FIND FIRST item NO-LOCK WHERE item.it-codigo = INPUT FRAME fPage0 fi-it-codigo NO-ERROR.
        IF  NOT AVAIL item THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Item n∆o cadastrado.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            ASSIGN fi-ean13 = "":U.
            DISPLAY fi-ean13 WITH FRAME fPage0.

            BELL.
            CLEAR FRAME fPage0 ALL.

            ASSIGN fi-ean13:SENSITIVE     IN FRAME fpage0 = TRUE
                   fi-it-codigo:SENSITIVE IN FRAME fpage0 = TRUE
                   fi-nr-serie:SENSITIVE  IN FRAME fPage0 = FALSE
                   .

            APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
            
            UNDO BLOCO_item, LEAVE BLOCO_item.
        END.
        ELSE DO:
            ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ITEM.it-codigo
                   fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.

            /*-[ EAN13 ]-*/
            FIND FIRST item-mat NO-LOCK WHERE item-mat.it-codigo = INPUT FRAME fPage0 fi-it-codigo NO-ERROR.
            IF  NOT AVAIL item-mat THEN DO:
                /*-[ DUN14 ]-*/
                FIND FIRST item-dun NO-LOCK WHERE item-dun.cod-dun = INPUT FRAME fPage0 fi-it-codigo NO-ERROR.
                IF  AVAIL item-dun 
                THEN ASSIGN fi-ean13:SCREEN-VALUE IN FRAME fPage0 = item-dun.cod-dun.
                ELSE ASSIGN fi-ean13:SCREEN-VALUE IN FRAME fPage0 = "".
            END. /* IF  NOT AVAIL item-ean THEN */
            ELSE ASSIGN fi-ean13:SCREEN-VALUE IN FRAME fPage0 = item-mat.cod-ean.

            IF item-mat.cod-ean BEGINS "78966376"  THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "ITEM n∆o permite criaá∆o de Num.SÇrie.",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN fi-ean13 = "":U.
                DISPLAY fi-ean13 WITH FRAME fPage0.
    
                BELL.
                CLEAR FRAME fPage0 ALL.
    
                ASSIGN fi-ean13:SENSITIVE     IN FRAME fpage0 = TRUE
                       fi-it-codigo:SENSITIVE IN FRAME fpage0 = TRUE
                       fi-nr-serie:SENSITIVE  IN FRAME fPage0 = FALSE
                       .
    
                APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
                
                UNDO BLOCO_item, LEAVE BLOCO_item.
            END.


            FIND FIRST item-ean NO-LOCK WHERE item-ean.it-codigo = INPUT FRAME fPage0 fi-it-codigo NO-ERROR.

            IF  AVAIL item-ean
            AND ITEM-ean.int-1 > 0 THEN ASSIGN fi-qtd:SCREEN-VALUE IN FRAME fPage0 = STRING(item-ean.int-1).
                                   ELSE ASSIGN fi-qtd:SCREEN-VALUE IN FRAME fPage0 = "1".

            ASSIGN INPUT FRAME fPage0 fi-qtd.
    
            ASSIGN fi-nr-serie:SENSITIVE IN FRAME fPage0 = TRUE.

            APPLY 'entry':U TO fi-nr-serie IN FRAME {&FRAME-NAME}.

        END.
    END. /* DO  TRANSACTION ON ERROR UNDO BLOCO_item, LEAVE BLOCO_item: */

    /* -------------------------------------------------------------- */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON TAB OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY 'return':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-serie wWindow
ON RETURN OF fi-nr-serie IN FRAME fpage0 /* SÇrie */
DO:
    BLOCO_serie:
    DO  TRANSACTION ON ERROR UNDO BLOCO_serie, LEAVE BLOCO_serie:
        
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "N.SÇrie coletado: " + INPUT FRAME fPage0 fi-nr-serie + CHR(10) + "Confirma?",
                                INPUT YES).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        ASSIGN l-ok = (RETURN-VALUE = "YES").
        IF  NOT l-ok THEN DO:
            APPLY "entry" TO fi-nr-serie IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END. /* IF  NOT l-ok THEN */

        IF  fi-qtd >= 1 THEN DO:
            
            IF  INPUT FRAME fPage0 fi-qtd-col = 0 THEN DO:
                FIND FIRST num-serie EXCLUSIVE-LOCK 
                    WHERE  num-serie.n-serie = INPUT FRAME fPage0 fi-nr-serie NO-ERROR.
    
                IF  NOT AVAIL num-serie THEN DO:
                    CREATE num-serie.
                    ASSIGN num-serie.n-serie     = INPUT FRAME fPage0 fi-nr-serie
                           num-serie.it-codigo   = INPUT FRAME fPage0 fi-it-codigo
                           num-serie.ano         = YEAR(TODAY)
                           num-serie.semana      = INTERVAL(TODAY, DATE(01, 01, YEAR(TODAY)), "weeks") + 1
                           num-serie.sequencia   = 0
                           num-serie.num-pedido  = 0
                           num-serie.sigla       = ""
                           num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
                           num-serie.data        = NOW
                           num-serie.usuario     = c-seg-usuario
                           num-serie.re-impr     = 0
                           num-serie.dt-ult-re   = ?
                           num-serie.us-ult-re   = ?
                           num-serie.motiv-re    = ?
                           num-serie.ns-keycode  = "".
        
                    ASSIGN c-nr-serie-principal                    = num-serie.n-serie
                           i-conta-serie                           = i-conta-serie + 1
                           fi-qtd-col:SCREEN-VALUE IN FRAME fPage0 = STRING(i-conta-serie).
    
                    ASSIGN INPUT FRAME fPage0 fi-qtd-col.
    
                    DISP fi-qtd-col WITH FRAME fPage0.
        
                END. /* IF  NOT AVAIL  num-serie THEN DO: */
                ELSE DO:
                    {&WINDOW-NAME}:SENSITIVE = FALSE.
                    RUN esp/clt/esclt006.w (INPUT "N£mero de sÇrie j† cadastrado. Item: " + num-serie.it-codigo,
                                            INPUT NO).
                    {&WINDOW-NAME}:SENSITIVE = TRUE.
                    IF  fi-qtd = 1 THEN DO:
                        ASSIGN fi-ean13   = "":U
                               fi-qtd     = 0
                               fi-qtd-col = 0.
        
                        DISPLAY fi-ean13 fi-qtd fi-qtd-col WITH FRAME fPage0.
                        UNDO BLOCO_serie, LEAVE BLOCO_serie.
                    END. /* IF  fi-qtd = 1 THEN DO: */
                    ELSE DO:
                        APPLY 'entry':U TO fi-nr-serie IN FRAME fPage0.
                        RETURN NO-APPLY.
                    END. /* ELSE DO: */
                END. /* ELSE DO: */
            END. /* IF  INPUT FRAME fPage0 fi-qtd-col = 0 THEN DO: */

            IF  fi-qtd > 1 THEN DO:
                FIND FIRST num-serie-fornec EXCLUSIVE-LOCK
                    WHERE  num-serie-fornec.n-serie     = c-nr-serie-principal
                    AND    num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-nr-serie NO-ERROR.
                IF  NOT AVAIL num-serie-fornec THEN DO:
                    IF  c-nr-serie-principal <> INPUT FRAME fPage0 fi-nr-serie THEN DO:
                        CREATE num-serie-fornec.
                        ASSIGN num-serie-fornec.n-serie                = c-nr-serie-principal
                               num-serie-fornec.n-serie-sec            = INPUT FRAME fPage0 fi-nr-serie
                               i-conta-serie                           = i-conta-serie + 1
                               fi-qtd-col:SCREEN-VALUE IN FRAME fPage0 = STRING(i-conta-serie).
                    END. /* IF  c-nr-serie-principal <> INPUT FRAME fPage0 fi-nr-serie */
                END. /* IF  NOT CAN-FIND(FIRST num-serie-fornec */
                ELSE DO:
                    {&WINDOW-NAME}:SENSITIVE = FALSE.
                    RUN esp/clt/esclt006.w (INPUT "N£mero de sÇrie coletado j† esta relacionado." + CHR(10) + "Produto: " + num-serie-fornec.n-serie + CHR(10) + "N.SÇrie: " + num-serie-fornec.n-serie-sec,
                                            INPUT NO).
                    {&WINDOW-NAME}:SENSITIVE = TRUE.
                    APPLY "entry":U TO fi-nr-serie IN FRAME fPage0.
                    RETURN NO-APPLY.
                END. /* ELSE DO: */
            END. /* IF  fi-qtd > 1 THEN DO: */
    
        END. /* DO  i = 1 */
    END. /* DO  TRANSACTION ON ERROR UNDO */

    IF  INPUT FRAME fPage0 fi-qtd = INPUT FRAME fPage0 fi-qtd-col THEN DO:
        BELL.
        CLEAR FRAME fPage0 ALL.
    
        ASSIGN fi-ean13:SENSITIVE     IN FRAME fpage0 = TRUE
               fi-it-codigo:SENSITIVE IN FRAME fpage0 = TRUE
               fi-nr-serie:SENSITIVE  IN FRAME fPage0 = FALSE
               c-nr-serie-principal                   = ""
               i-conta-serie                          = 0
               .
        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END. /* IF  lcompleto */
    ELSE DO:
        APPLY "ENTRY":U TO fi-nr-serie IN FRAME fPage0.
    END. /* ELSE DO: */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


