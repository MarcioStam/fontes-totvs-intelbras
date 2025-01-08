&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
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
{include/i-prgvrs.i esrep037 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esrep037
&GLOBAL-DEFINE Version        <ProgramVersion>

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 c-cod-depos c-cod-localiz
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-serie        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-documento    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-natureza     AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 c-cod-depos ~
c-desc-dep c-cod-localiz btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-depos c-desc-dep c-cod-localiz 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


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

DEFINE VARIABLE c-cod-depos LIKE item-doc-est.cod-depos
     LABEL "Dep¢sito Novo" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-localiz LIKE item-doc-est.cod-localiz
     LABEL "Localizaá∆o Nova" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 54 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 54 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-depos AT ROW 3.25 COL 13.43 COLON-ALIGNED HELP
          "" WIDGET-ID 2
          LABEL "Dep¢sito Novo"
     c-desc-dep AT ROW 3.25 COL 20.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-cod-localiz AT ROW 4.25 COL 13.43 COLON-ALIGNED HELP
          "" WIDGET-ID 4
          LABEL "Localizaá∆o Nova"
     btOK AT ROW 6.08 COL 2
     btCancel AT ROW 6.08 COL 13
     btHelp2 AT ROW 6.08 COL 43.72
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 5.88 COL 1
     RECT-1 AT ROW 2.58 COL 1.57 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.14 BY 6.75
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
         HEIGHT             = 6.75
         WIDTH              = 54.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* SETTINGS FOR FILL-IN c-cod-depos IN FRAME fpage0
   LIKE = mgmov.item-doc-est.cod-depos EXP-LABEL EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-cod-localiz IN FRAME fpage0
   LIKE = mgmov.item-doc-est.cod-localiz EXP-LABEL EXP-SIZE             */
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
    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 27100,
                      INPUT "Tem certeza que deseja alterar o deposito de todos os itens?").

    IF RETURN-VALUE = "NO" THEN
        RETURN NO-APPLY.

    FIND FIRST deposito NO-LOCK
        WHERE deposito.cod-depos = c-cod-depos:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF NOT AVAIL deposito THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Dep¢sito informado n∆o existe.").
        RETURN NO-APPLY.
    END.

    FIND FIRST docum-est NO-LOCK
        WHERE docum-est.cod-emitente = p-cod-emitente
          AND docum-est.serie-docto  = p-serie       
          AND docum-est.nro-docto    = p-documento   
          AND docum-est.nat-operacao = p-natureza NO-ERROR.

    IF docum-est.ce-atual THEN DO:
         RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Documento j† foi atualizado.").
        RETURN NO-APPLY.
    END.


    FIND FIRST mgcad.localizacao NO-LOCK
        WHERE localizacao.cod-estabel = docum-est.cod-estabel
          AND localizacao.cod-depos   = c-cod-depos:SCREEN-VALUE IN FRAME fPage0
          AND localizacao.cod-localiz = c-cod-localiz:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF NOT AVAIL localizacao THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "N∆o encontrada localizaá∆o para o dep¢sito informado.").
        RETURN NO-APPLY.
    END.

    FOR EACH item-doc-est OF docum-est EXCLUSIVE-LOCK:

/*         IF docum-est.esp-docto = 21 /* NFE */ THEN DO:                                     */
/*             FIND FIRST wm-local-deposito                                                   */
/*                  WHERE wm-local-deposito.cod-estabel = docum-est.cod-estab                 */
/*                    AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.           */
/*             IF AVAIL wm-local-deposito THEN DO:                                            */
/*                                                                                            */
/*                 FIND FIRST int-item-fornec-skip-lote NO-LOCK                               */
/*                      WHERE int-item-fornec-skip-lote.it-codigo    = item-doc-est.it-codigo */
/*                        AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.            */
/*                 IF AVAIL int-item-fornec-skip-lote THEN                                    */
/*                     NEXT.                                                                  */
/*                                                                                            */
/*             END.                                                                           */
/*         END.                                                                               */

        FOR EACH rat-lote {cdp/cd8900.i rat-lote item-doc-est }
             and rat-lote.sequencia = item-doc-est.sequencia EXCLUSIVE-LOCK:
            ASSIGN rat-lote.cod-depos   = c-cod-depos:SCREEN-VALUE IN FRAME fPage0  
                   rat-lote.cod-localiz = c-cod-localiz:SCREEN-VALUE IN FRAME fPage0.
        END.

        ASSIGN item-doc-est.cod-depos   = c-cod-depos:SCREEN-VALUE IN FRAME fPage0
               item-doc-est.cod-localiz = c-cod-localiz:SCREEN-VALUE IN FRAME fPage0.
    END.  

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos wWindow
ON F5 OF c-cod-depos IN FRAME fpage0 /* Dep¢sito Novo */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=c-cod-depos
                     &campo2=c-desc-dep 
                     &campozoom=cod-depos
                     &campozoom2=nome
                     &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME fpage0 /* Dep¢sito Novo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz wWindow
ON F5 OF c-cod-localiz IN FRAME fpage0 /* Localizaá∆o Nova */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in189.w"
                     &campo=c-cod-localiz
                     &campozoom=cod-localiz
                     &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz IN FRAME fpage0 /* Localizaá∆o Nova */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

IF c-cod-depos:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
IF c-cod-localiz:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


