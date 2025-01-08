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
{include/i-prgvrs.i esftp059a 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esftp059a MFT}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp059a
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 c-item tg-sugere-ncm
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-natureza LIKE int-natur-est-mapa.natureza NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 RECT-16 c-item c-descricao ~
tg-sugere-ncm btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-natureza c-desc-natur c-item c-descricao ~
tg-sugere-ncm 

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

DEFINE VARIABLE c-desc-natur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-natureza AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.46.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-sugere-ncm AS LOGICAL INITIAL no 
     LABEL "Sugere NCM" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-natureza AT ROW 1.29 COL 12.86 COLON-ALIGNED WIDGET-ID 2
     c-desc-natur AT ROW 1.29 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-item AT ROW 2.79 COL 12.86 COLON-ALIGNED WIDGET-ID 4
     c-descricao AT ROW 2.79 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tg-sugere-ncm AT ROW 2.88 COL 78.72 WIDGET-ID 14
     btOK AT ROW 4.29 COL 2
     btCancel AT ROW 4.29 COL 13
     btHelp2 AT ROW 4.29 COL 80
     rtToolBar AT ROW 4.08 COL 1
     RECT-15 AT ROW 1.04 COL 1 WIDGET-ID 10
     RECT-16 AT ROW 2.54 COL 1 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 4.75
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
         HEIGHT             = 4.88
         WIDTH              = 90
         MAX-HEIGHT         = 17.21
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.21
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-natur IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-natureza IN FRAME fpage0
   NO-ENABLE                                                            */
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

    ASSIGN INPUT FRAME fPage0 i-natureza c-item tg-sugere-ncm.

    IF  CAN-FIND(FIRST it-natureza-ped-fiscal 
                 WHERE it-natureza-ped-fiscal.natureza  = i-natureza
                 AND   it-natureza-ped-fiscal.it-codigo = c-item) THEN DO:
        
        RUN utp/ut-msgs.p (input "show":U, input 17006, input "Item invalido!~~Item j  cadastrado para esta natureza " + STRING(i-natureza)).
        apply "ENTRY":U to c-item in frame fPage0.
        RETURN NO-APPLY.
    END.
    
    CREATE it-natureza-ped-fiscal.
    ASSIGN it-natureza-ped-fiscal.natureza  = i-natureza
           it-natureza-ped-fiscal.it-codigo = c-item
           it-natureza-ped-fiscal.log-sugere-ncm = tg-sugere-ncm.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON ENTRY OF c-item IN FRAME fpage0 /* Item */
DO:
    ASSIGN i-natureza = p-natureza.
    DISP i-natureza WITH FRAME fpage0.

    APPLY 'leave':U TO i-natureza IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON F5 OF c-item IN FRAME fpage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=c-item
                       &campozoom=it-codigo
                       &FRAME=fPage0
                       &campo2=c-descricao
                       &campozoom2=nome
                       &FRAME2=fPage0}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON LEAVE OF c-item IN FRAME fpage0 /* Item */
DO:

    FIND FIRST ITEM NO-LOCK 
        WHERE  ITEM.it-codigo = c-item:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF  AVAIL ITEM THEN DO:
        IF  ITEM.tipo-contr NE 4 THEN DO:
            ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = "".
                   c-item:SCREEN-VALUE      IN FRAME fPage0 = "".

            RUN utp/ut-msgs.p (input "show":U, input 17006, input "Item inv lido!~~Item deve ser D‚bito Direto.":U).
            apply "ENTRY":U to c-item in frame fPage0.
            RETURN NO-APPLY.
        END.
        ELSE ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
    END.
    ELSE ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON MOUSE-SELECT-DBLCLICK OF c-item IN FRAME fpage0 /* Item */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-natureza wWindow
ON LEAVE OF i-natureza IN FRAME fpage0 /* Natureza */
DO:
    DO WITH FRAME fpage0:

        FIND FIRST natureza-ped-fiscal NO-LOCK
            WHERE  natureza-ped-fiscal.natureza = int(SELF:SCREEN-VALUE) NO-ERROR.
        IF  AVAIL natureza-ped-fiscal
        THEN ASSIGN c-desc-natur = natureza-ped-fiscal.descricao.
        ELSE ASSIGN c-desc-natur = "".

        DISP c-desc-natur WITH FRAME fpage0.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

c-item:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.                                          
APPLY 'entry':U TO c-item IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize wWindow 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

