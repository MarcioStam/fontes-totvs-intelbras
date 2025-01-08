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
{include/i-prgvrs.i esftp059b 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esftp059b MFT}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp059b
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 c-estab c-mapa
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
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 RECT-16 c-estab ~
c-descricao c-mapa c-desc-mapa btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-natureza c-desc-natur c-estab ~
c-descricao c-mapa c-desc-mapa 

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

DEFINE VARIABLE c-desc-mapa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab AS CHARACTER FORMAT "x(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-mapa AS CHARACTER FORMAT "x(8)":U 
     LABEL "Mapa Distrib.CC" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-natureza AT ROW 1.29 COL 12.86 COLON-ALIGNED WIDGET-ID 2
     c-desc-natur AT ROW 1.29 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-estab AT ROW 2.79 COL 12.86 COLON-ALIGNED WIDGET-ID 4
     c-descricao AT ROW 2.79 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-mapa AT ROW 3.79 COL 12.86 COLON-ALIGNED WIDGET-ID 16
     c-desc-mapa AT ROW 3.79 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
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
         HEIGHT             = 5.92
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

    ASSIGN INPUT FRAME fPage0 i-natureza c-estab c-mapa.

    IF  CAN-FIND(FIRST int-natur-est-mapa 
                 WHERE int-natur-est-mapa.natureza            = i-natureza
                 AND   int-natur-est-mapa.cod-estabel         = c-estab
                 AND   int-natur-est-mapa.cod-mapa-distrib-cc = c-mapa) THEN DO:
        
        RUN utp/ut-msgs.p (input "show":U, input 17006, input "Estabelecimento e Mapa j† relacionados!~~Estabelecimento e Mapa j† cadastrados para esta natureza " + STRING(i-natureza)).
        apply "ENTRY":U to c-estab in frame fPage0.
        RETURN NO-APPLY.
    END.
    
    CREATE int-natur-est-mapa.
    ASSIGN int-natur-est-mapa.natureza            = i-natureza
           int-natur-est-mapa.cod-estabel         = c-estab
           int-natur-est-mapa.cod-mapa-distrib-cc = c-mapa.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab wWindow
ON ENTRY OF c-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN i-natureza = p-natureza.
    DISP i-natureza WITH FRAME fpage0.

    APPLY 'leave':U TO i-natureza IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab wWindow
ON F5 OF c-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z06ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-estab"
                         &FieldZoom2="nome"
                         &FieldScreen2="c-descricao"
                         &Frame1="fPage0"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab wWindow
ON LEAVE OF c-estab IN FRAME fpage0 /* Estabelecimento */
DO:

    FIND FIRST ESTABELEC NO-LOCK 
        WHERE  ESTABELEC.cod-estabel = c-estab:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.
    IF  AVAIL ESTABELEC 
    THEN ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
    ELSE ASSIGN c-descricao:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF c-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-mapa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mapa wWindow
ON ENTRY OF c-mapa IN FRAME fpage0 /* Mapa Distrib.CC */
DO:
    ASSIGN INPUT FRAME fPage0 c-estab.

    ASSIGN v_cod_estab                   = c-estab
           v_ind_tip_mapa_distrib_ccusto = "Lista":U.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mapa wWindow
ON F5 OF c-mapa IN FRAME fpage0 /* Mapa Distrib.CC */
DO:
    IF  c-estab:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Estabelecimento n∆o pode ser branco.' + '~~' +
                                 'Informe um estabelecimento primeiro.').
        APPLY 'entry':U TO c-estab IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    run prgint/utb/utb028ka.p /* prg_sea_mapa_distrib_ccusto */.

    if  v_rec_mapa_distrib_ccusto <> ? then do:

        FIND FIRST mapa_distrib_ccusto WHERE RECID(mapa_distrib_ccusto) = v_rec_mapa_distrib_ccusto NO-LOCK NO-ERROR.
        IF  AVAIL mapa_distrib_ccusto 
        THEN assign c-mapa      = string(mapa_distrib_ccusto.cod_mapa_distrib_ccusto)
                    c-desc-mapa = string(mapa_distrib_ccusto.des_mapa_distrib_ccusto).
        ELSE assign c-mapa      = ""
                    c-desc-mapa = "".
            
        display c-mapa c-desc-mapa with frame fPage0.

    end /* if  v_rec_mapa_distrib_ccusto <> ? then do: */.
    ELSE DO:
        assign c-mapa      = ""
               c-desc-mapa = "".
            
        display c-mapa c-desc-mapa with frame fPage0.
    END. /* ELSE DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mapa wWindow
ON LEAVE OF c-mapa IN FRAME fpage0 /* Mapa Distrib.CC */
DO:
    ASSIGN INPUT FRAME fPage0 c-estab c-mapa.

    FIND FIRST mapa_distrib_ccusto NO-LOCK 
        WHERE  mapa_distrib_ccusto.cod_estab               = c-estab
        AND    mapa_distrib_ccusto.cod_mapa_distrib_ccusto = c-mapa NO-ERROR.
    IF  AVAIL  mapa_distrib_ccusto 
    THEN ASSIGN c-desc-mapa:SCREEN-VALUE IN FRAME fPage0 = mapa_distrib_ccusto.des_mapa_distrib_ccusto.
    ELSE ASSIGN c-desc-mapa:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mapa wWindow
ON MOUSE-SELECT-DBLCLICK OF c-mapa IN FRAME fpage0 /* Mapa Distrib.CC */
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

c-estab:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.
c-mapa:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fpage0.

APPLY 'entry':U TO c-estab IN FRAME fPage0.

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

