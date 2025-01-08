&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i esbcp004 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esbcp004
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   cEtiqueta brNotas bt-sair  
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE pit-codigo           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE lcompleto            AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE i-contador           AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-nr-serie-principal LIKE num-serie.n-serie  NO-UNDO. 
DEFINE VARIABLE i-conta-serie        AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-tipo-aux           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE l-volta              AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE l-retorno-astec      AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE vqtd-col             LIKE volume-nf.qtde-col NO-UNDO.
DEFINE VARIABLE h-acomp              AS   HANDLE             NO-UNDO.
DEFINE VARIABLE i-volumes            AS   INTEGER            NO-UNDO.
DEFINE VARIABLE i-tot-col            AS   INTEGER            NO-UNDO.
{esp/es0018.i}
{upc/btb910za-upc.i}

/* Buffers Definitions ---                                              */

/* Temp-tables Definitions ---                                          */

DEF TEMP-TABLE ttEtiqueta
    FIELD posicao     AS CHAR 
    FIELD it-codigo   LIKE ITEM.it-codigo
    FIELD quantidade  LIKE wm-box-movto.qtd-item 
    FIELD usuario     AS CHAR FORMAT "x(12)"
    FIELD data        AS DATE FORMAT "99/99/99" 
    FIELD hora        LIKE wm-tarefa-docto-itens.hr-fim-tarefa
    INDEX ch-pri posicao .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brNotas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEtiqueta

/* Definitions for BROWSE brNotas                                       */
&Scoped-define FIELDS-IN-QUERY-brNotas ttEtiqueta.posicao ttEtiqueta.it-codigo ttEtiqueta.quantidade ttEtiqueta.usuario ttEtiqueta.data string(ttEtiqueta.hora, "HH:MM")   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNotas   
&Scoped-define SELF-NAME brNotas
&Scoped-define QUERY-STRING-brNotas FOR EACH ttEtiqueta
&Scoped-define OPEN-QUERY-brNotas OPEN QUERY {&SELF-NAME} FOR EACH ttEtiqueta.
&Scoped-define TABLES-IN-QUERY-brNotas ttEtiqueta
&Scoped-define FIRST-TABLE-IN-QUERY-brNotas ttEtiqueta


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brNotas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-embarque cEtiqueta fi-volumes brNotas ~
bt-sair fi-tot-col RECT-19 
&Scoped-Define DISPLAYED-OBJECTS fi-embarque cEtiqueta fi-volumes ~
fi-tot-col 

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

DEFINE VARIABLE cEtiqueta AS CHARACTER FORMAT "X(15)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 175 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-embarque AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-col AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 35 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-volumes AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 35 BY 16
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 320 BY 75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brNotas FOR 
      ttEtiqueta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNotas wWindow _FREEFORM
  QUERY brNotas DISPLAY
      ttEtiqueta.posicao    COLUMN-LABEL "Posi‡Æo" WIDTH 7
      ttEtiqueta.it-codigo  COLUMN-LABEL "item"    WIDTH 6.5
      ttEtiqueta.quantidade COLUMN-LABEL "Qtde"    WIDTH 7
      ttEtiqueta.usuario    COLUMN-LABEL "Usu rio" WIDTH 7
      ttEtiqueta.data       COLUMN-LABEL "Data"    WIDTH 7
      string(ttEtiqueta.hora, "HH:MM") COLUMN-LABEL "Hora"    WIDTH 5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 7
          &ELSE SIZE-PIXELS 320 BY 170 &ENDIF
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-embarque AT ROW 2.75 COL 8 COLON-ALIGNED WIDGET-ID 66
     cEtiqueta AT Y 12 X 49 COLON-ALIGNED WIDGET-ID 54
     fi-volumes AT Y 252 X 169 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     brNotas AT Y 78 X 0 WIDGET-ID 200
     bt-sair AT Y 270 X 252 WIDGET-ID 40
     fi-tot-col AT Y 252 X 244 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     RECT-19 AT Y 3 X 0 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
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
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB brNotas fi-volumes fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNotas
/* Query rebuild information for BROWSE brNotas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttEtiqueta
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNotas */
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
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  /*IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.  
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


&Scoped-define BROWSE-NAME brNotas
&Scoped-define SELF-NAME brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas wWindow
ON RETURN OF brNotas IN FRAME fpage0
DO:
    APPLY "mouse-select-dblclick":U TO SELF.  
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


&Scoped-define SELF-NAME cEtiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cEtiqueta wWindow
ON RETURN OF cEtiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    
    
    EMPTY TEMP-TABLE ttEtiqueta NO-ERROR.

    FIND FIRST wms-etiq-packing
         WHERE wms-etiq-packing.val-etiq-packing = dec(cEtiqueta:SCREEN-VALUE IN FRAME fpage0) NO-LOCK NO-ERROR.
    IF AVAIL wms-etiq-packing THEN DO:

       ASSIGN fi-embarque:SCREEN-VALUE IN FRAME fpage0 = string(wms-etiq-packing.cdd-embarq ).   

       FOR EACH es-wm-box-movto-etiq NO-LOCK
          WHERE es-wm-box-movto-etiq.val-etiq-separacao = wms-etiq-packing.val-etiq-packing:
   
           FOR EACH wm-tarefa-docto-itens NO-LOCK
              WHERE wm-tarefa-docto-itens.id-tarefa = es-wm-box-movto-etiq.id-tarefa
                AND wm-tarefa-docto-itens.id-movto  = es-wm-box-movto-etiq.id-movto
                AND wm-tarefa-docto-itens.ind-tipo-movto = 2: /* Saida */
       
               FIND FIRST wm-box-movto NO-LOCK
                    WHERE wm-box-movto.cod-estabel    = wm-tarefa-docto-itens.cod-estabel
                      AND wm-box-movto.cod-local      = wm-tarefa-docto-itens.cod-local
                      AND wm-box-movto.id-movto       = wm-tarefa-docto-itens.id-movto 
                      AND wm-box-movto.ind-tipo-movto = 2 NO-ERROR.
               IF NOT AVAIL wm-box-movto THEN NEXT.
   
               FIND FIRST wm-box NO-LOCK
                    WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                    AND   wm-box.cod-local   = wm-box-movto.cod-local
                    AND   wm-box.id-box      = wm-box-movto.id-box NO-ERROR.
   
               FIND FIRST wm-item NO-LOCK
                    WHERE wm-item.cod-item = wm-box-movto.cod-item NO-ERROR.
   
              CREATE ttEtiqueta.
              ASSIGN ttEtiqueta.posicao    = wm-box.cod-bloco + " " + 
                                             wm-box.cod-rua   + " " +
                                             wm-box.cod-nivel + " " +
                                             wm-box.cod-coluna  
                     ttEtiqueta.it-codigo  = wm-box-movto.cod-item
                     ttEtiqueta.quantidade = wm-box-movto.qtd-item
                     ttEtiqueta.usuario    = wm-tarefa-docto-itens.cod-usuario
                     ttEtiqueta.data       = wm-tarefa-docto-itens.dt-fim-tarefa
                     ttEtiqueta.hora       = wm-tarefa-docto-itens.hr-fim-tarefa.
   
           END.
       END.
    END.

    DISP fi-embarque:SCREEN-VALUE IN FRAME fpage0.
    {&OPEN-QUERY-brNotas}

    APPLY "entry":U TO cEtiqueta IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cEtiqueta wWindow
ON TAB OF cEtiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    APPLY 'return':U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}


ASSIGN cEtiqueta:SENSITIVE IN FRAME fPage0 = TRUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    cEtiqueta:SENSITIVE IN FRAME fpage0 = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

