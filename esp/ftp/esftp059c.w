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
{include/i-prgvrs.i esftp059c 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esftp059c MFT}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp059c
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 c-nat-oper l-nat-serie-espec
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-natureza LIKE int-natur-est-mapa.natureza NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
            
def new global shared var v_rec_mapa_distrib_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new global shared var v_ind_tip_mapa_distrib_ccusto
    as character
    format "X(10)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Lista","Lista","Autom†tico","Autom†tico"
    &else
    list-items "Lista","Autom†tico"
    &endif
     /*l_lista*/ /*l_automatico*/
    inner-lines 3
    bgcolor 15 font 2
    label "Tipo Mapa"
    column-label "Tipo Mapa"
    no-undo.

def new global shared var v_cod_estab
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 RECT-16 c-nat-oper ~
c-descricao l-nat-serie-espec btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-natureza c-desc-natur c-nat-oper ~
c-descricao l-nat-serie-espec 

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
     SIZE 60.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "x(6)":U 
     LABEL "Nat Operacao" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-natureza AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.46.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-nat-serie-espec AS LOGICAL INITIAL no 
     LABEL "Natureza possui SÇrie Especial ??" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-natureza AT ROW 1.29 COL 12.86 COLON-ALIGNED WIDGET-ID 2
     c-desc-natur AT ROW 1.29 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-nat-oper AT ROW 2.79 COL 12.86 COLON-ALIGNED WIDGET-ID 4
     c-descricao AT ROW 2.79 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     l-nat-serie-espec AT ROW 3.83 COL 15 WIDGET-ID 18
     btOK AT ROW 5.29 COL 2
     btCancel AT ROW 5.29 COL 13
     btHelp2 AT ROW 5.29 COL 80
     rtToolBar AT ROW 5.08 COL 1
     RECT-15 AT ROW 1.04 COL 1 WIDGET-ID 10
     RECT-16 AT ROW 2.54 COL 1 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 5.75
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
         HEIGHT             = 5.79
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

    ASSIGN INPUT FRAME fPage0 i-natureza c-nat-oper.

    IF NOT CAN-FIND (FIRST natur-oper
                     WHERE natur-oper.nat-operacao = c-nat-oper) THEN DO:
        RUN utp/ut-msgs.p (input "show":U, input 17006, input "Natureza n∆o cadastrada!~~N∆o encontrado cadastro para a natureza informada.").
        apply "ENTRY":U to c-nat-oper in frame fPage0.
        RETURN NO-APPLY.
    END.

    IF  CAN-FIND(FIRST natur-oper-ped-fiscal 
                 WHERE natur-oper-ped-fiscal.natureza     = i-natureza
                 AND   natur-oper-ped-fiscal.nat-operacao = c-nat-oper) THEN DO:
        
        RUN utp/ut-msgs.p (input "show":U, input 17006, input "Natureza j† relacionada!~~J† existe relacionamento para a natureza informada.").
        apply "ENTRY":U to c-nat-oper in frame fPage0.
        RETURN NO-APPLY.
    END.
    
    CREATE natur-oper-ped-fiscal.
    ASSIGN natur-oper-ped-fiscal.natureza     = i-natureza
           natur-oper-ped-fiscal.nat-operacao = c-nat-oper
           natur-oper-ped-fiscal.possui-serie-espec = l-nat-serie-espec:CHECKED IN FRAME fpage0.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON ENTRY OF c-nat-oper IN FRAME fpage0 /* Nat Operacao */
DO:
    ASSIGN i-natureza = p-natureza.
    DISP i-natureza WITH FRAME fpage0.

    APPLY 'leave':U TO i-natureza IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON F5 OF c-nat-oper IN FRAME fpage0 /* Nat Operacao */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="c-nat-oper"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON LEAVE OF c-nat-oper IN FRAME fpage0 /* Nat Operacao */
DO:

    FIND FIRST natur-oper NO-LOCK 
         WHERE natur-oper.nat-operacao = c-nat-oper:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF  AVAIL natur-oper THEN 
        ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = natur-oper.denominacao.
    ELSE 
        ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON MOUSE-SELECT-DBLCLICK OF c-nat-oper IN FRAME fpage0 /* Nat Operacao */
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


/*:T--- L¢gica para inicializaá∆o do programam ---*/

c-nat-oper:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.

APPLY 'entry':U TO c-nat-oper IN FRAME fPage0.

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

