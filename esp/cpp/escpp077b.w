&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP077B 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP077B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-it-codigo fi-cod-estabel
&GLOBAL-DEFINE page1Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER p-cod-prod   AS INT     NO-UNDO.

DEFINE BUFFER b-estrut      FOR estrutura.
DEFINE BUFFER b-estr-mqa    FOR estrutura-mqa.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-4 fi-it-codigo fi-desc-item ~
fi-cod-estabel btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item fi-cod-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT ROW 1.5 COL 13 COLON-ALIGNED WIDGET-ID 4
     fi-desc-item AT ROW 1.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-cod-estabel AT ROW 2.5 COL 13 COLON-ALIGNED WIDGET-ID 8
     btOK AT ROW 4.13 COL 2
     btCancel AT ROW 4.13 COL 13
     btHelp2 AT ROW 4.13 COL 80
     rtToolBar AT ROW 3.92 COL 1
     RECT-4 AT ROW 1.25 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 4.54
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 83 ROW 1.5
         SIZE 4 BY .79
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 4.54
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
      
    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 fi-it-codigo,
        FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 fi-cod-estabel:

        RUN pi-gera (INPUT INPUT FRAME fPage0 fi-it-codigo,
                     INPUT INPUT FRAME fPage0 fi-cod-estabel).

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.

    IF NOT AVAIL ITEM THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Item inexistente.").
        RETURN NO-APPLY.
    END.

    IF NOT AVAIL estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Estabelecimento inexistente.").
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON F5 OF fi-cod-estabel IN FRAME fpage0 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="fi-cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fpage0 /* Estab */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="fi-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"
                         &FieldScreen2="fi-desc-item"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 fi-it-codigo:

        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.

    END.

    IF NOT AVAIL ITEM THEN
        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera wWindow 
PROCEDURE pi-gera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.

    DEFINE VARIABLE l-descer-nivel AS LOGICAL     NO-UNDO.    

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo
          AND estrutura.data-inicio <= TODAY           
          AND estrutura.data-termino > TODAY:

        IF estrutura.local-montag <> "" THEN DO:            

            FOR EACH  int-local-montag NO-LOCK
                WHERE int-local-montag.it-codigo = estrutura.it-codigo
                AND   int-local-montag.sequencia = estrutura.sequencia
                AND   int-local-montag.es-codigo = estrutura.es-codigo:

                FOR FIRST estrutura-mqa NO-LOCK
                    WHERE estrutura-mqa.cod-prod     = p-cod-prod
                    AND   estrutura-mqa.local-montag = int-local-montag.local-montag
                    AND   estrutura-mqa.cod-estabel  = p-cod-estabel:
                END.
                IF NOT AVAIL estrutura-mqa THEN DO:

                    CREATE estrutura-mqa.
                    ASSIGN estrutura-mqa.cod-prod     = p-cod-prod
                           estrutura-mqa.local-montag = int-local-montag.local-montag
                           estrutura-mqa.cod-estabel  = p-cod-estabel
                           estrutura-mqa.es-codigo    = estrutura.es-codigo.
                END.
            END.
        END.

        ASSIGN l-descer-nivel = YES.
        
        FIND FIRST item-mqa NO-LOCK
             WHERE item-mqa.cod-estabel = p-cod-estabel
               AND item-mqa.cod-prod    = p-cod-prod NO-ERROR.
        IF AVAIL item-mqa THEN DO:

            IF item-mqa.log-copiar-apenas-nivel THEN
                ASSIGN l-descer-nivel = NO.
        END.

        IF l-descer-nivel THEN
            RUN pi-gera (INPUT estrutura.es-codigo,
                         INPUT p-cod-estabel).

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

