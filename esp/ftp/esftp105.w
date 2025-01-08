&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propr iedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP105 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP105
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 bt-det ccod-estabel icod-transp cestado bt-carga br-notas fi-embarque fi-depos
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esp/es0018.i}

DEF TEMP-TABLE tt-nota-fiscal
    FIELD cod-estabel LIKE volume-nf.cod-estabel
    FIELD estado      LIKE nota-fiscal.estado
    FIELD serie       LIKE volume-nf.serie
    FIELD nr-nota-fis LIKE volume-nf.nr-nota-fis

    FIELD tot-volumes   AS INTEGER
    FIELD tot-coletados AS INTEGER
    FIELD tot-conf-nf   AS INTEGER

    /*FIELD tot-vol-t18 LIKE volume-nf.nr-volume
    FIELD qtd-col-t18 LIKE volume-nf.nr-volume
    FIELD tot-vol-t19 LIKE volume-nf.nr-volume
    FIELD qtd-col-t19 LIKE volume-nf.nr-volume*/
    INDEX ch-pri cod-estabel serie nr-nota-fis.

DEFINE TEMP-TABLE tt-prog-ponto-quarentena NO-UNDO LIKE tt-prog-ponto.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-retorno-astec AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-volta AS LOGICAL     NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto-tmp
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   

DEF BUFFER b-ponto-programa FOR ponto-programa.

DEF BUFFER bconf-volume-nf  FOR conf-volume-nf.

DEF BUFFER bvolume-nf       FOR volume-nf.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE VARIABLE i-tot-vol       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tot-col       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tot-conf-nf   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tot-unit      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tot-frac      AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-nota-fiscal

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-nota-fiscal.cod-estabel tt-nota-fiscal.estado tt-nota-fiscal.serie tt-nota-fiscal.nr-nota-fis tt-nota-fiscal.tot-volumes tt-nota-fiscal.tot-coletados tt-nota-fiscal.tot-conf-nf   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-nota-fiscal
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY {&SELF-NAME} FOR EACH tt-nota-fiscal.
&Scoped-define TABLES-IN-QUERY-br-notas tt-nota-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-nota-fiscal


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-notas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ccod-estabel icod-transp cestado fi-embarque ~
fi-depos fi-tot-col fi-tot-conf-nf fi-tot-frac fi-tot-unit fi-tot-vol ~
btQueryJoins btReportsJoins btExit btHelp bt-carga br-notas btOK btCancel ~
btHelp2 bt-det rtToolBar-2 rtToolBar RECT-20 RECT-21 
&Scoped-Define DISPLAYED-OBJECTS ccod-estabel icod-transp cestado ~
fi-embarque fi-depos fi-tot-col fi-tot-conf-nf fi-tot-frac fi-tot-unit ~
fi-tot-vol cnome-abrev desc-estab 

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
DEFINE BUTTON bt-carga 
     IMAGE-UP FILE "image/im-cq.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-det 
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Detalhar" 
     SIZE 10 BY 1
     FONT 4.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE ccod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cestado AS CHARACTER FORMAT "X(04)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE cnome-abrev AS CHARACTER FORMAT "x(50)":U 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .88 NO-UNDO.

DEFINE VARIABLE desc-estab AS CHARACTER FORMAT "x(50)":U 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-depos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deposito" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embarque AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-col AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tot Vol Coletados" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-conf-nf AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tot Vol Conf NF" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-frac AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tot Vol Fracionado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-unit AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tot Vol Unit†rio" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-vol AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Tot Volumes" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE icod-transp AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Transp" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-nota-fiscal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-nota-fiscal.cod-estabel                                          WIDTH 7
    tt-nota-fiscal.estado           COLUMN-LABEL "Estado"               WIDTH 6
    tt-nota-fiscal.serie                                                WIDTH 6
    tt-nota-fiscal.nr-nota-fis                                          WIDTH 10
    tt-nota-fiscal.tot-volumes      COLUMN-LABEL "Tot Volumes"          WIDTH 16
    tt-nota-fiscal.tot-coletados    COLUMN-LABEL "Vol Coletados"        WIDTH 16
    tt-nota-fiscal.tot-conf-nf      COLUMN-LABEL "Vol Conf NF"          WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 9.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ccod-estabel AT ROW 3 COL 28 COLON-ALIGNED WIDGET-ID 66
     icod-transp AT ROW 4 COL 28 COLON-ALIGNED WIDGET-ID 50
     cestado AT ROW 5 COL 28 COLON-ALIGNED WIDGET-ID 54
     fi-embarque AT ROW 6 COL 28 COLON-ALIGNED WIDGET-ID 86
     fi-depos AT ROW 7 COL 28 COLON-ALIGNED WIDGET-ID 88
     fi-tot-col AT ROW 19.25 COL 21 COLON-ALIGNED WIDGET-ID 76
     fi-tot-conf-nf AT ROW 20.25 COL 21 COLON-ALIGNED WIDGET-ID 78
     fi-tot-frac AT ROW 19.25 COL 58 COLON-ALIGNED WIDGET-ID 82
     fi-tot-unit AT ROW 18.25 COL 58 COLON-ALIGNED WIDGET-ID 80
     fi-tot-vol AT ROW 18.25 COL 21 COLON-ALIGNED WIDGET-ID 74
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     cnome-abrev AT ROW 4 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     bt-carga AT ROW 3.75 COL 76 HELP
          "Consultas relacionadas" WIDGET-ID 68
     br-notas AT ROW 8.25 COL 2 WIDGET-ID 200
     btOK AT ROW 22.13 COL 2
     btCancel AT ROW 22.13 COL 13
     btHelp2 AT ROW 22.13 COL 80
     desc-estab AT ROW 3 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     bt-det AT ROW 22.13 COL 43.57 HELP
          "Consultas relacionadas" WIDGET-ID 84
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 21.92 COL 1
     RECT-20 AT ROW 2.75 COL 2 WIDGET-ID 2
     RECT-21 AT ROW 18 COL 2 WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22.58
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
         HEIGHT             = 22.58
         WIDTH              = 90
         MAX-HEIGHT         = 22.58
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 22.58
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-notas bt-carga fpage0 */
/* SETTINGS FOR FILL-IN cnome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-estab IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-nota-fiscal.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
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


&Scoped-define BROWSE-NAME br-notas
&Scoped-define SELF-NAME br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON MOUSE-SELECT-DBLCLICK OF br-notas IN FRAME fpage0
DO:
  
    APPLY "CHOOSE" TO bt-det IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON ROW-DISPLAY OF br-notas IN FRAME fpage0
DO:

    IF tt-nota-fiscal.tot-volumes <> tt-nota-fiscal.tot-coletados OR
       tt-nota-fiscal.tot-volumes <> tt-nota-fiscal.tot-conf-nf THEN DO:

        ASSIGN tt-nota-fiscal.cod-estabel:FGCOLOR IN BROWSE br-notas = 12
               tt-nota-fiscal.estado:FGCOLOR      = 12
               tt-nota-fiscal.serie:FGCOLOR       = 12
               tt-nota-fiscal.nr-nota-fis:FGCOLOR = 12
               tt-nota-fiscal.tot-volumes:FGCOLOR = 12
               tt-nota-fiscal.tot-coletados:FGCOLOR = 12
               tt-nota-fiscal.tot-conf-nf:FGCOLOR = 12.

    END.
    ELSE DO:

        ASSIGN tt-nota-fiscal.cod-estabel:FGCOLOR = 1
               tt-nota-fiscal.estado:FGCOLOR      = 1
               tt-nota-fiscal.serie:FGCOLOR       = 1
               tt-nota-fiscal.nr-nota-fis:FGCOLOR = 1
               tt-nota-fiscal.tot-volumes:FGCOLOR = 1
               tt-nota-fiscal.tot-coletados:FGCOLOR = 1
               tt-nota-fiscal.tot-conf-nf:FGCOLOR = 1.

    END.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carga wWindow
ON CHOOSE OF bt-carga IN FRAME fpage0 /* Query Joins */
DO:

    RUN pi-carga.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det wWindow
ON CHOOSE OF bt-det IN FRAME fpage0 /* Detalhar */
DO:

    IF AVAIL tt-nota-fiscal THEN DO:

        RUN esp/ftp/esftp105a.w (INPUT tt-nota-fiscal.cod-estabel,
                                 INPUT tt-nota-fiscal.serie,
                                 INPUT string(tt-nota-fiscal.nr-nota-fis)).


    END.

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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel wWindow
ON F5 OF ccod-estabel IN FRAME fpage0 /* Estab */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=ccod-estabel
                        &campozoom=cod-estabel
                        &campo2=desc-estab
                        &campozoom2=nome}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel wWindow
ON LEAVE OF ccod-estabel IN FRAME fpage0 /* Estab */
DO:

    ASSIGN desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = SELF:SCREEN-VALUE:

        ASSIGN desc-estab:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.

    END.

    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel IN FRAME fpage0 /* Estab */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cestado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cestado wWindow
ON LEAVE OF cestado IN FRAME fpage0 /* UF */
DO:
    ASSIGN cestado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(INPUT FRAME {&FRAME-NAME} cestado).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME icod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON F5 OF icod-transp IN FRAME fpage0 /* Transp */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
                       &campo=icod-transp
                       &campozoom=cod-transp
                       &campo2=cnome-abrev
                       &campozoom2=nome-abrev}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON LEAVE OF icod-transp IN FRAME fpage0 /* Transp */
DO:

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = INPUT FRAME fPage0 icod-transp NO-ERROR.
    IF  AVAIL  transporte THEN
        ASSIGN cnome-abrev:SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev.
    ELSE 
        ASSIGN cnome-abrev:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON MOUSE-SELECT-DBLCLICK OF icod-transp IN FRAME fpage0 /* Transp */
DO:

    APPLY "F5" TO SELF.

  
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
{window/mainblock.i}


ccod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U).
icod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineAstec wWindow 
PROCEDURE defineAstec :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-retorno-astec = NO.
    IF AVAIL ped-venda
    AND  nota-fiscal.nome-transp <> "Sedex"
    AND (ped-venda.tp-pedido = "99"  OR 
         ped-venda.tp-pedido = "9"   OR
         ped-venda.tp-pedido = "94") THEN ASSIGN l-retorno-astec = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-EmbarqueQuarentena wWindow 
PROCEDURE pi-busca-EmbarqueQuarentena :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    EMPTY TEMP-TABLE tt-prog-ponto-quarentena NO-ERROR.

    RUN esp/es0018p.p (INPUT "esftp093",
                   INPUT 1, 
                   INPUT 0,
                   INPUT "", 
                   OUTPUT TABLE tt-prog-ponto-quarentena).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carga wWindow 
PROCEDURE pi-carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-qtde-acum     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-qtde-col-acum AS DECIMAL     NO-UNDO.

    RUN pi-valida-dados.

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK":U.
                                    
    RUN pi-busca-EmbarqueQuarentena.

    ASSIGN cestado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(INPUT FRAME {&FRAME-NAME} cestado).
    
    EMPTY TEMP-TABLE tt-nota-fiscal NO-ERROR.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Buscando notas ...":U).

    FOR FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = INPUT FRAME fPage0 icod-transp:
    END.

    ASSIGN i-tot-vol      = 0
           i-tot-col      = 0
           i-tot-conf-nf  = 0
           i-tot-unit     = 0
           i-tot-frac     = 0.
    
    FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-transp
        WHERE nota-fiscal.nome-transp = transporte.nome-abrev
        AND   nota-fiscal.cod-estabel = INPUT FRAME fpage0 ccod-estabel
        AND   nota-fiscal.dt-saida    = ? 
        AND   nota-fiscal.dt-cancela  = ? 
        AND   nota-fiscal.cdd-embarq <> 0 
        AND   (nota-fiscal.dt-emis-nota >= TODAY - 60 AND
               nota-fiscal.dt-emis-nota <= TODAY):

        IF INPUT FRAME fpage0 fi-embarque <> 0 THEN
           IF nota-fiscal.cdd-embarq  <> INPUT FRAME fpage0 fi-embarque THEN NEXT.

        IF INPUT FRAME fpage0 fi-depos <> "" THEN DO:
           FIND FIRST fat-ser-lote NO-LOCK
                WHERE fat-ser-lote.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-ser-lote.serie       = nota-fiscal.serie
                  AND fat-ser-lote.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
           IF AVAIL fat-ser-lote THEN
               IF fat-ser-lote.cod-depos <> INPUT FRAME fpage0 fi-depos THEN NEXT.
        END.

        IF INPUT FRAME fPage0 cestado <> "" AND
            nota-fiscal.estado <> INPUT FRAME fPage0 cestado THEN
            NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "Nota : " + STRING(nota-fiscal.nr-nota-fis)).

        /* Se encontrar nota-fiscal cujo embarque seja o de quarentena, ignora */
        IF CAN-FIND(FIRST tt-prog-ponto-quarentena
                    WHERE   ENTRY(1, tt-prog-ponto-quarentena.conteudo, ";")  = nota-fiscal.cod-estabel
                    AND int(ENTRY(2, tt-prog-ponto-quarentena.conteudo, ";")) = nota-fiscal.cdd-embarq) THEN NEXT.

        /* Existe devoluá∆o de nota */
        IF  CAN-FIND(FIRST devol-cli
                     WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                     AND   devol-cli.serie       = nota-fiscal.serie
                     AND   devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN NEXT.

        FOR FIRST natur-oper NO-LOCK WHERE
                  natur-oper.nat-operacao = nota-fiscal.nat-operacao:
        END. /* FOR FIRST natur-oper */
        {esinc/es0004.i} /* ValidaNaturezasImpress∆oNFs */

        RUN defineAstec.
        IF l-retorno-astec THEN NEXT.

        FIND LAST volume-nf WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                                  volume-nf.serie       = nota-fiscal.serie       AND
                                  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF NOT AVAIL volume-nf THEN NEXT.

        IF  NOT CAN-FIND(FIRST tt-nota-fiscal
                         WHERE tt-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                         AND   tt-nota-fiscal.serie       = nota-fiscal.serie      
                         AND   tt-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:

            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel   = nota-fiscal.cod-estabel
                   tt-nota-fiscal.estado        = nota-fiscal.estado
                   tt-nota-fiscal.serie         = nota-fiscal.serie      
                   tt-nota-fiscal.nr-nota-fis   = nota-fiscal.nr-nota-fis
                   tt-nota-fiscal.tot-volumes   = volume-nf.nr-volume
                   tt-nota-fiscal.tot-coletados = 0
                   tt-nota-fiscal.tot-conf-nf   = 0.

            /* Volumes Coletados */
            FOR EACH volume-nf NO-LOCK
                WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel 
                AND   volume-nf.serie       = nota-fiscal.serie 
                AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                BREAK BY volume-nf.nr-volume:

                IF FIRST-OF (volume-nf.nr-volume) THEN
                    ASSIGN v-qtde-acum     = 0
                           v-qtde-col-acum = 0.
            
                /*Totaliza por volume, caso seja fracionado v†rios registros correspondem a 1 s¢ volume*/
                ASSIGN v-qtde-acum     = v-qtde-acum     + volume-nf.qtde
                       v-qtde-col-acum = v-qtde-col-acum + volume-nf.qtde-col.
            
                IF LAST-OF(volume-nf.nr-volume) THEN DO:
                    IF v-qtde-acum = v-qtde-col-acum THEN
                        ASSIGN tt-nota-fiscal.tot-coletados = tt-nota-fiscal.tot-coletados + 1.
        
                    IF volume-nf.varios-itens THEN
                        ASSIGN i-tot-frac = i-tot-frac + 1.
                    ELSE
                        ASSIGN i-tot-unit = i-tot-unit + 1.
        
                END.

            END.

            /* Volumes Conferidos na NF */
            FOR EACH  bconf-volume-nf NO-LOCK
                WHERE bconf-volume-nf.cod-estabel = tt-nota-fiscal.cod-estabel
                AND   bconf-volume-nf.serie       = tt-nota-fiscal.serie
                AND   bconf-volume-nf.nr-nota-fis = tt-nota-fiscal.nr-nota-fis:

                ASSIGN tt-nota-fiscal.tot-conf-nf = tt-nota-fiscal.tot-conf-nf + 1.
                       
            END. /* FOR EACH  bconf-volume-nf NO-LOCK */


            ASSIGN i-tot-vol      = i-tot-vol      + tt-nota-fiscal.tot-volumes
                   i-tot-col      = i-tot-col      + tt-nota-fiscal.tot-coletados
                   i-tot-conf-nf  = i-tot-conf-nf  + tt-nota-fiscal.tot-conf-nf.


        END. /* IF  NOT CAN-FIND(FIRST tt-nota-fiscal */
        
    END. /* FOR EACH nota-fiscal */

    RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-br-notas}

    DO WITH FRAME fPage0:

        ASSIGN fi-tot-vol:SCREEN-VALUE      = string(i-tot-vol)
               fi-tot-col:SCREEN-VALUE      = string(i-tot-col)
               fi-tot-conf-nf:SCREEN-VALUE  = string(i-tot-conf-nf)
               fi-tot-unit:SCREEN-VALUE     = string(i-tot-unit)
               fi-tot-frac:SCREEN-VALUE     = string(i-tot-frac).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-dados wWindow 
PROCEDURE pi-valida-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = INPUT FRAME fPage0 ccod-estabel) THEN DO:

        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 56,
                           INPUT "Estabelecimento").

        RETURN "NOK":U.

    END.

    /**/

    IF NOT CAN-FIND(FIRST transporte
                    WHERE transporte.cod-transp = INPUT FRAME fPage0 icod-transp) THEN DO:

        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 56,
                           INPUT "Transportadora").

        RETURN "NOK":U.

    END.

    /**/

    IF INPUT FRAME {&FRAME-NAME} cestado <> "" AND
        NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = INPUT FRAME {&FRAME-NAME} cestado) THEN DO:

        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 56,
                           INPUT "Unidade Federativa").

        RETURN "NOK":U.
        
    END. 


    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

