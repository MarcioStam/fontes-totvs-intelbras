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
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP083 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
       
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCPP083 MCP}
&ENDIF   

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP083
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Apont.

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 fi-cod-estab fi-data fi-nr-linha bt-carga
&GLOBAL-DEFINE page1Widgets   br-aponta-mqa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esp/es0018.i}

DEFINE BUFFER b-aponta-mqa FOR aponta-mqa.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-falha AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-aponta-mqa
    FIELD cod-prod      LIKE aponta-mqa.cod-prod
    FIELD cod-estabel   LIKE aponta-mqa.cod-estabel
    FIELD desc-prod     LIKE item-mqa.descricao
    FIELD es-codigo     LIKE aponta-mqa.es-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD tot-falha     LIKE aponta-mqa.qtd-falha
    FIELD situacao      AS CHAR FORMAT "X(08)"  LABEL "Situa‡Æo".

DEFINE VARIABLE c-desc-prod AS CHARACTER   FORMAT "X(40)" LABEL "Descri‡Æo"     NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   FORMAT "X(40)" LABEL "Descri‡Æo"     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-aponta-mqa

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-aponta-mqa

/* Definitions for BROWSE br-aponta-mqa                                 */
&Scoped-define FIELDS-IN-QUERY-br-aponta-mqa tt-aponta-mqa.cod-prod f-desc-prod(tt-aponta-mqa.cod-prod, tt-aponta-mqa.cod-estabel) @ c-desc-prod tt-aponta-mqa.es-codigo f-desc-item(tt-aponta-mqa.es-codigo) @ c-desc-item tt-aponta-mqa.tot-falha tt-aponta-mqa.situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-aponta-mqa   
&Scoped-define SELF-NAME br-aponta-mqa
&Scoped-define QUERY-STRING-br-aponta-mqa FOR EACH tt-aponta-mqa NO-LOCK
&Scoped-define OPEN-QUERY-br-aponta-mqa OPEN QUERY {&SELF-NAME} FOR EACH tt-aponta-mqa NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-aponta-mqa tt-aponta-mqa
&Scoped-define FIRST-TABLE-IN-QUERY-br-aponta-mqa tt-aponta-mqa


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-aponta-mqa}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 btQueryJoins ~
btReportsJoins btExit btHelp fi-cod-estab fi-data bt-carga fi-nr-linha ~
fi-desc-linha btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estab fi-data fi-nr-linha ~
fi-desc-linha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-prod wWindow 
FUNCTION f-desc-prod RETURNS CHARACTER
  ( INPUT p-cod-prod AS INT,
    INPUT p-cod-estabel AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-falha wWindow 
FUNCTION f-falha RETURNS CHARACTER
  ( INPUT p-cod-falha AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-origem wWindow 
FUNCTION f-origem RETURNS CHARACTER
  ( INPUT p-cod-origem AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     IMAGE-UP FILE "IMAGE/im-chck3.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

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

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-linha AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
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
DEFINE QUERY br-aponta-mqa FOR 
      tt-aponta-mqa SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-aponta-mqa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-aponta-mqa wWindow _FREEFORM
  QUERY br-aponta-mqa NO-LOCK DISPLAY
      tt-aponta-mqa.cod-prod FORMAT ">>>,>>>,>>9":U
      f-desc-prod(tt-aponta-mqa.cod-prod, tt-aponta-mqa.cod-estabel) @ c-desc-prod     
      tt-aponta-mqa.es-codigo FORMAT "x(16)":U
      f-desc-item(tt-aponta-mqa.es-codigo) @ c-desc-item
      tt-aponta-mqa.tot-falha FORMAT ">>>>>,>>9.9999":U
      tt-aponta-mqa.situacao FORMAT "x(08)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-cod-estab AT ROW 3 COL 25 COLON-ALIGNED WIDGET-ID 2
     fi-data AT ROW 4 COL 25 COLON-ALIGNED WIDGET-ID 4
     bt-carga AT ROW 4.75 COL 79 WIDGET-ID 8
     fi-nr-linha AT ROW 5 COL 25 COLON-ALIGNED WIDGET-ID 6
     fi-desc-linha AT ROW 5 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btOK AT ROW 18.21 COL 2
     btCancel AT ROW 18.21 COL 13
     btHelp2 AT ROW 18.21 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 18 COL 1
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.42
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-aponta-mqa AT ROW 1.25 COL 2 WIDGET-ID 200
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.88
         SIZE 84.43 BY 9.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.42
         WIDTH              = 90
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.46
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-aponta-mqa 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-aponta-mqa
/* Query rebuild information for BROWSE br-aponta-mqa
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-aponta-mqa NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE br-aponta-mqa */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME bt-carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carga wWindow
ON CHOOSE OF bt-carga IN FRAME fpage0
DO:

    RUN pi-carrega.
    
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


&Scoped-define SELF-NAME fi-nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON F5 OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo="fi-nr-linha"
                       &campozoom="nr-linha"
                       &frame="fPage0"
                       &campo2="fi-desc-linha"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON LEAVE OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.nr-linha = INPUT FRAME fPage0 fi-nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = lin-prod.descricao.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
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


&Scoped-define BROWSE-NAME br-aponta-mqa
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

fi-nr-linha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    DO WITH FRAME fPage0:

        ASSIGN fi-cod-estab:SCREEN-VALUE = v_cod_estab_usuar
               fi-data:SCREEN-VALUE = STRING(TODAY).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega wWindow 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-qtd-apont AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-qtd-corte-indice AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-problema AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-atencao AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-fator AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-mostra AS LOGICAL     NO-UNDO.


    EMPTY TEMP-TABLE tt-aponta-mqa.
        
    FOR EACH aponta-mqa NO-LOCK
        WHERE aponta-mqa.cod-estabel = INPUT FRAME fPage0 fi-cod-estab
        AND   aponta-mqa.data        = INPUT FRAME fpage0 fi-data
        AND   aponta-mqa.nr-linha    = INPUT FRAME fPage0 fi-nr-linha
        BREAK BY aponta-mqa.cod-prod
              BY aponta-mqa.es-codigo:

        IF FIRST-OF(aponta-mqa.cod-prod) OR
           FIRST-OF(aponta-mqa.es-codigo) THEN DO:

            ASSIGN d-qtd-apont = 0.
    
            FOR EACH b-aponta-mqa NO-LOCK
                WHERE b-aponta-mqa.cod-estabel  = aponta-mqa.cod-estabel
                AND   b-aponta-mqa.data         = aponta-mqa.data
                AND   b-aponta-mqa.nr-linha     = aponta-mqa.nr-linha
                AND   b-aponta-mqa.cod-prod     = aponta-mqa.cod-prod
                AND   b-aponta-mqa.es-codigo    = aponta-mqa.es-codigo
                /*AND   b-aponta-mqa.local-montag = aponta-mqa.local-montag
                AND   b-aponta-mqa.cod-falha    = aponta-mqa.cod-falha*/ :
    
                ASSIGN d-qtd-apont = d-qtd-apont + b-aponta-mqa.qtd-falha.
    
            END.
    
            /**/
    
            EMPTY TEMP-TABLE tt-prog-ponto.
        
            RUN esp/es0018p.p (INPUT "ESCPP082":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            
            FOR FIRST tt-prog-ponto:
            
                ASSIGN d-qtd-corte-indice = DECIMAL(tt-prog-ponto.conteudo).
        
                FOR FIRST estimativa-produ NO-LOCK
                    WHERE estimativa-produ.cod-estabel = aponta-mqa.cod-estabel
                    AND   estimativa-produ.data        = aponta-mqa.data
                    AND   estimativa-produ.cod-prod    = aponta-mqa.cod-prod:
        
                    FOR FIRST indice-qualid NO-LOCK
                        WHERE indice-qualid.cod-estabel = aponta-mqa.cod-estabel
                        AND   indice-qualid.it-codigo   = aponta-mqa.es-codigo:
        
                        IF estimativa-produ.qtd-estimada <= d-qtd-corte-indice THEN DO:
        
                            /* Absoluto */
                            ASSIGN d-problema = indice-qualid.absol-problema
                                   d-atencao  = indice-qualid.absol-atencao.
        
                        END.
                        ELSE DO:
        
                            /* Relativo */
                            ASSIGN d-problema = indice-qualid.relat-problema
                                   d-atencao  = indice-qualid.relat-atencao.
        
                        END.
        
                        ASSIGN d-fator = d-qtd-apont / estimativa-produ.qtd-estimada.
    
                        IF d-fator < d-atencao  THEN
                            ASSIGN l-mostra = FALSE.
                        ELSE 
                            ASSIGN l-mostra = TRUE.  /* Amarelo */
        
                        IF d-fator >= d-problema THEN
                            ASSIGN l-mostra = TRUE.  /* Vermelho */
        
                    END.
        
                END.
        
            END.
    
            IF l-mostra THEN DO:
    
                CREATE tt-aponta-mqa.
                BUFFER-COPY aponta-mqa TO tt-aponta-mqa.
                ASSIGN tt-aponta-mqa.tot-falha = d-qtd-apont
                       tt-aponta-mqa.situacao  = IF d-fator >= d-problema THEN "Problema" ELSE "Aten‡Æo".
    
            END.

        END.

    END.

    {&open-query-br-aponta-mqa}
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

    RETURN "".   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-prod wWindow 
FUNCTION f-desc-prod RETURNS CHARACTER
  ( INPUT p-cod-prod AS INT,
    INPUT p-cod-estabel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-mqa NO-LOCK
        WHERE item-mqa.cod-prod = p-cod-prod
          AND item-mqa.cod-estabel = p-cod-estabel:

        RETURN item-mqa.descricao.

    END.

    RETURN "".   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-falha wWindow 
FUNCTION f-falha RETURNS CHARACTER
  ( INPUT p-cod-falha AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST falha-mqa NO-LOCK
        WHERE falha-mqa.cod-falha = p-cod-falha:

        RETURN falha-mqa.descricao.

    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-origem wWindow 
FUNCTION f-origem RETURNS CHARACTER
  ( INPUT p-cod-origem AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST origem-mqa NO-LOCK
        WHERE origem-mqa.origem-falha = p-cod-origem:

        RETURN origem-mqa.descricao.

    END.

    RETURN "".   /* Function return value. */
        
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

