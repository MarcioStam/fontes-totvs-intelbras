&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
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
{include/i-prgvrs.i esimp001a 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esimp001a
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btCancela btOK brperc fi-peso-bruto fi-peso-liquido btAtualiza

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-embarque AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-peso-bruto AS DECIMAL NO-UNDO.
DEF OUTPUT PARAM p-peso-liquido AS DECIMAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

{esp/imp/esimp001tt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brperc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-perc

/* Definitions for BROWSE brperc                                        */
&Scoped-define FIELDS-IN-QUERY-brperc tt-perc.it-codigo tt-perc.numero-ordem tt-perc.peso-bruto tt-perc.peso-liq   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brperc tt-perc.peso-bruto tt-perc.peso-liq   
&Scoped-define ENABLED-TABLES-IN-QUERY-brperc tt-perc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brperc tt-perc
&Scoped-define SELF-NAME brperc
&Scoped-define QUERY-STRING-brperc FOR EACH tt-perc
&Scoped-define OPEN-QUERY-brperc OPEN QUERY {&SELF-NAME} FOR EACH tt-perc.
&Scoped-define TABLES-IN-QUERY-brperc tt-perc
&Scoped-define FIRST-TABLE-IN-QUERY-brperc tt-perc


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brperc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brperc btAtualiza fi-peso-bruto ~
fi-peso-liquido btOK btCancela RECT-20 
&Scoped-Define DISPLAYED-OBJECTS fi-peso-bruto fi-peso-liquido 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAtualiza 
     LABEL "&Atualiza Pesos" 
     SIZE 12 BY 1.

DEFINE BUTTON btCancela 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-peso-bruto AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Peso Bruto":R12 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-peso-liquido AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Peso L¡quido" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brperc FOR 
      tt-perc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brperc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brperc wWindow _FREEFORM
  QUERY brperc DISPLAY
      tt-perc.it-codigo
         tt-perc.numero-ordem
         tt-perc.peso-bruto
         tt-perc.peso-liq
     ENABLE
     tt-perc.peso-bruto
tt-perc.peso-liq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-AUTO-VALIDATE SEPARATORS NO-VALIDATE SIZE 50 BY 8.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brperc AT ROW 1.25 COL 20
     btAtualiza AT ROW 10.25 COL 20 HELP
          "Atualiza os pesos bruto e l¡quido"
     fi-peso-bruto AT ROW 10.25 COL 69 RIGHT-ALIGNED HELP
          "Peso Bruto Unit rio do Item"
     fi-peso-liquido AT ROW 11.25 COL 69 RIGHT-ALIGNED HELP
          "Peso l¡quido do item"
     btOK AT ROW 12.79 COL 2
     btCancela AT ROW 12.79 COL 12
     RECT-20 AT ROW 12.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
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
         HEIGHT             = 13.13
         WIDTH              = 90
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.88
         VIRTUAL-WIDTH      = 90
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{utp/utapi019.i}
{esp/ShowMsg.i}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brperc 1 fpage0 */
/* SETTINGS FOR FILL-IN fi-peso-bruto IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-peso-liquido IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brperc
/* Query rebuild information for BROWSE brperc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-perc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brperc */
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
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "choose":U TO btCancela IN FRAME fpage0.
  RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0 /* Atualiza Pesos */
DO:
    assign fi-peso-bruto   = 0
           fi-peso-liquido = 0.
    for each tt-perc:
        assign fi-peso-bruto   = fi-peso-bruto + tt-perc.peso-bruto
               fi-peso-liquido = fi-peso-liquido  + tt-perc.peso-liq.
    end.
    for each tt-perc:
        assign tt-perc.perc-liq   = tt-perc.peso-liq / fi-peso-liquido
               tt-perc.perc-bruto = tt-perc.peso-bruto / fi-peso-bruto.
    end.
    
    DISP fi-peso-bruto  
         fi-peso-liquido WITH FRAME fpage0.
    ENABLE fi-peso-bruto fi-peso-liquido WITH FRAME fpage0.
    APPLY "entry" TO fi-peso-bruto IN FRAME fpage0.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN INPUT FRAME fpage0 fi-peso-bruto fi-peso-liquido.

    assign fi-peso-bruto   = 0
           fi-peso-liquido = 0.
    for each tt-perc:
        assign fi-peso-bruto   = fi-peso-bruto + tt-perc.peso-bruto
               fi-peso-liquido = fi-peso-liquido  + tt-perc.peso-liq.
    end.
    for each tt-perc:
        assign tt-perc.perc-liq   = tt-perc.peso-liq / fi-peso-liquido
               tt-perc.perc-bruto = tt-perc.peso-bruto / fi-peso-bruto.
        assign tt-perc.novo-peso-liq = (tt-perc.perc-liq * fi-peso-liquido) /* / tt-perc.quantidade*/
               tt-perc.novo-peso-bruto = (tt-perc.perc-bruto * fi-peso-bruto) /*  / tt-perc.quantidade*/.

        for each ordens-embarque exclusive-lock
           where ordens-embarque.numero-ordem = tt-perc.numero-ordem:
    
            IF ordens-embarque.char-2 = ? THEN
                ASSIGN ordens-embarque.char-2 = " ".

            IF tt-perc.novo-peso-liq = ? THEN
                ASSIGN ordens-embarque.peso-liquido = 0.
            ELSE
                assign ordens-embarque.peso-liquido = tt-perc.novo-peso-liq.
    
            IF tt-perc.novo-peso-bruto = ? THEN
                ASSIGN ordens-embarque.peso-bruto = 0.
            ELSE
                ASSIGN ordens-embarque.peso-bruto = tt-perc.novo-peso-bruto.
        END.
    END.

    ASSIGN p-peso-bruto   = fi-peso-bruto
           p-peso-liquido = fi-peso-liquido.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brperc
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-zero AS LOGICAL NO-UNDO.
    STATUS DEFAULT.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    for each tt-perc:   
        delete tt-perc.
    end.
    assign fi-peso-bruto   = 0
           fi-peso-liquido = 0.
    assign l-zero = no.
    for each ordens-embarque no-lock
       where ordens-embarque.embarque = p-embarque:
        find ordem-compra where 
             ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
        find item where item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        IF ordens-embarque.peso-liquido = 0 THEN DO:
            ASSIGN fi-peso-liquido = fi-peso-liquido + (item.peso-liquido * ordens-embarque.quantidade).
        END.
        ELSE DO:
            ASSIGN fi-peso-liquido = fi-peso-liquido + ordens-embarque.peso-liquido.
        END.

        IF ordens-embarque.peso-bruto = 0 THEN DO:
            assign fi-peso-bruto = fi-peso-bruto + (item.peso-bruto * ordens-embarque.quantidade).
        END.
        ELSE DO:
            assign fi-peso-bruto = fi-peso-bruto + ordens-embarque.peso-bruto.
        END.

        find tt-perc
             where tt-perc.reg = recid(ordens-embarque) no-error.
        if not avail tt-perc then do:
            create tt-perc.
            assign tt-perc.reg = recid(ordens-embarque)
                   tt-perc.it-codigo = item.it-codigo
                   tt-perc.numero-ordem = ordens-embarque.numero-ordem
                   tt-perc.quantidade = ordens-embarque.quantidade.

            IF ordens-embarque.peso-liquido = 0 THEN DO:
                ASSIGN tt-perc.peso-liq = (item.peso-liquido * ordens-embarque.quantidade).
            END.
            ELSE DO:
                ASSIGN tt-perc.peso-liq = ordens-embarque.peso-liquido /* ordens-embarque.quantidade*/.
            END.

            IF ordens-embarque.peso-bruto = 0 THEN DO:
                ASSIGN tt-perc.peso-bruto = (item.peso-bruto * ordens-embarque.quantidade).
            END.
            ELSE DO:
                ASSIGN tt-perc.peso-bruto = ordens-embarque.peso-bruto /* ordens-embarque.quantidade*/.
            END.
                   .
            if tt-perc.peso-liq = 0 or
               tt-perc.peso-bruto = 0 then 
               assign l-zero = yes.
        end.
    END.
    SESSION:SET-WAIT-STATE("":U).
    if l-zero then do:
        STATUS DEFAULT "Existem itens sem peso definido. Consulte relat¢rio".
    end.
    {&OPEN-QUERY-brperc}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

