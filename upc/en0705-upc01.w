&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-item NO-UNDO LIKE int-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i en0507-upc01 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i en0507-upc01 ESP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        en0507-upc01
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins ~
                              btExit btHelp btOK btSave btCancel btHelp2

&GLOBAL-DEFINE ttTable        tt-int-item
&GLOBAL-DEFINE hDBOTable      hDBOIt
&GLOBAL-DEFINE DBOTable       int-item

&GLOBAL-DEFINE page1widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM cItem      AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar rtKey btQueryJoins ~
btReportsJoins btExit btHelp btOK btSave btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-int-item.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-int-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-item
&Scoped-Define DISPLAYED-OBJECTS des-item 

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE des-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKey
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE des-cor AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE des-mod-pl AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE des-pot AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE des-tam-pl AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE des-tip-mp AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.


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
     tt-int-item.it-codigo AT ROW 3.33 COL 15 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-item AT ROW 3.33 COL 26.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     btOK AT ROW 17 COL 2
     btSave AT ROW 17 COL 13
     btCancel AT ROW 17 COL 24 WIDGET-ID 16
     btHelp2 AT ROW 17 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.79 COL 1
     rtKey AT ROW 2.5 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.63
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-int-item.cod-cor AT ROW 1.75 COL 12.43 COLON-ALIGNED WIDGET-ID 2
          LABEL "Cor"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-cor AT ROW 1.75 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-int-item.cod-tipo-mp AT ROW 3.75 COL 12.43 COLON-ALIGNED WIDGET-ID 6
          LABEL "Tipo MP"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-tip-mp AT ROW 3.75 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-int-item.cod-modelo-placa AT ROW 5.75 COL 12.43 COLON-ALIGNED WIDGET-ID 10
          LABEL "Modelo Placa"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-mod-pl AT ROW 5.75 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     tt-int-item.cod-tam-placa AT ROW 7.75 COL 12.43 COLON-ALIGNED WIDGET-ID 14
          LABEL "Tamanho Placa"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-tam-pl AT ROW 7.75 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-int-item.cod-potencia AT ROW 9.75 COL 12.43 COLON-ALIGNED WIDGET-ID 18
          LABEL "Potˆncia"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .79
     des-pot AT ROW 9.75 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.5
         SIZE 84.43 BY 10.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-item T "?" NO-UNDO mgesp int-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.42
         WIDTH              = 90.29
         MAX-HEIGHT         = 18.67
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 18.67
         VIRTUAL-WIDTH      = 90.29
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
/* SETTINGS FOR FILL-IN des-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-item.it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-int-item.cod-cor IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item.cod-modelo-placa IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item.cod-potencia IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item.cod-tam-placa IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-item.cod-tipo-mp IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN des-cor IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-mod-pl IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-pot IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-tam-pl IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-tip-mp IN FRAME fPage1
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN piSave IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-int-item.cod-cor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-cor wWindow
ON LEAVE OF tt-int-item.cod-cor IN FRAME fPage1 /* Cor */
DO:
    {include/leave.i &tabela=int-cor
                     &atributo-ref=desc-cor
                     &variavel-ref=des-cor
                     &where="int-cor.cod-cor = input frame fPage1 
                     tt-int-item.cod-cor"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-cor wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-item.cod-cor IN FRAME fPage1 /* Cor */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp103z1.w"
                         &FieldZoom1="cod-cor"
                         &FieldScreen1="tt-int-item.cod-cor"
                         &Frame1="fPage1"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item.cod-modelo-placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-modelo-placa wWindow
ON LEAVE OF tt-int-item.cod-modelo-placa IN FRAME fPage1 /* Modelo Placa */
DO:
    {include/leave.i &tabela=int-modelo-placa
                     &atributo-ref=desc-modelo-placa
                     &variavel-ref=des-mod-pl
                     &where="int-modelo-placa.cod-modelo-placa = input frame fPage1 
                     tt-int-item.cod-modelo-placa"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-modelo-placa wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-item.cod-modelo-placa IN FRAME fPage1 /* Modelo Placa */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp105z1.w"
                         &FieldZoom1="cod-modelo-placa"
                         &FieldScreen1="tt-int-item.cod-modelo-placa"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item.cod-potencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-potencia wWindow
ON LEAVE OF tt-int-item.cod-potencia IN FRAME fPage1 /* Potˆncia */
DO:
    {include/leave.i &tabela=int-potencia
                     &atributo-ref=desc-potencia
                     &variavel-ref=des-pot
                     &where="int-potencia.cod-potencia = input frame fPage1 
                     tt-int-item.cod-potencia"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-potencia wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-item.cod-potencia IN FRAME fPage1 /* Potˆncia */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp106z1.w"
                         &FieldZoom1="cod-potencia"
                         &FieldScreen1="tt-int-item.cod-potencia"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item.cod-tam-placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-tam-placa wWindow
ON LEAVE OF tt-int-item.cod-tam-placa IN FRAME fPage1 /* Tamanho Placa */
DO:
    {include/leave.i &tabela=int-tam-placa
                     &atributo-ref=desc-tam-placa
                     &variavel-ref=des-tam-pl
                     &where="int-tam-placa.cod-tam-placa = input frame fPage1 
                     tt-int-item.cod-tam-placa"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-tam-placa wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-item.cod-tam-placa IN FRAME fPage1 /* Tamanho Placa */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp107z1.w"
                         &FieldZoom1="cod-tam-placa"
                         &FieldScreen1="tt-int-item.cod-tam-placa"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item.cod-tipo-mp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-tipo-mp wWindow
ON LEAVE OF tt-int-item.cod-tipo-mp IN FRAME fPage1 /* Tipo MP */
DO:
    {include/leave.i &tabela=int-tipo-mp
                     &atributo-ref=desc-tipo-mp
                     &variavel-ref=des-tip-mp
                     &where="int-tipo-mp.cod-tipo-mp = input frame fPage1 
                     tt-int-item.cod-tipo-mp"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.cod-tipo-mp wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-item.cod-tipo-mp IN FRAME fPage1 /* Tipo MP */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp108z1.w"
                         &FieldZoom1="cod-tipo-mp"
                         &FieldScreen1="tt-int-item.cod-tipo-mp"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-int-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item.it-codigo wWindow
ON LEAVE OF tt-int-item.it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/leave.i &tabela=ITEM
                     &atributo-ref=desc-item
                     &variavel-ref=des-item
                     &where="item.it-codigo = input frame fPage0 
                     tt-int-item.it-codigo"}  
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-int-item.cod-cor:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage1.
tt-int-item.cod-tipo-mp:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage1.
tt-int-item.cod-modelo-placa:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage1.
tt-int-item.cod-tam-placa:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage1.
tt-int-item.cod-potencia:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tt-int-item.it-codigo:SCREEN-VALUE IN FRAME fPage0 = cItem.
    APPLY "leave":U TO tt-int-item.it-codigo IN FRAME fPage0.

    ENABLE tt-int-item.cod-cor           
           tt-int-item.cod-tipo-mp
           tt-int-item.cod-modelo-placa
           tt-int-item.cod-tam-placa
           tt-int-item.cod-potencia
               WITH FRAME fPage1. 

    FIND FIRST int-item
         WHERE int-item.it-codigo = cItem NO-ERROR.
    IF AVAIL int-item THEN DO:
        ASSIGN tt-int-item.cod-cor:SCREEN-VALUE IN FRAME fPage1 = int-item.cod-cor
               tt-int-item.cod-tipo-mp:SCREEN-VALUE IN FRAME fPage1 = int-item.cod-tipo-mp       
               tt-int-item.cod-modelo-placa:SCREEN-VALUE IN FRAME fPage1 = int-item.cod-modelo-placa  
               tt-int-item.cod-tam-placa:SCREEN-VALUE IN FRAME fPage1 = int-item.cod-tam-placa
               tt-int-item.cod-potencia:SCREEN-VALUE IN FRAME fPage1 = int-item.cod-potencia. 
    END.
    APPLY "leave":U TO tt-int-item.cod-cor IN FRAME fPage1.
    APPLY "leave":U TO tt-int-item.cod-tipo-mp IN FRAME fPage1.
    APPLY "leave":U TO tt-int-item.cod-modelo-placa IN FRAME fPage1.
    APPLY "leave":U TO tt-int-item.cod-tam-placa IN FRAME fPage1.
    APPLY "leave":U TO tt-int-item.cod-potencia IN FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSave wWindow 
PROCEDURE piSave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST int-item
         WHERE int-item.it-codigo = cItem NO-ERROR.
    IF AVAIL int-item THEN DO:
        ASSIGN int-item.cod-cor = tt-int-item.cod-cor:SCREEN-VALUE IN FRAME fPage1
               int-item.cod-tipo-mp = tt-int-item.cod-tipo-mp:SCREEN-VALUE IN FRAME fPage1       
               int-item.cod-modelo-placa = tt-int-item.cod-modelo-placa:SCREEN-VALUE IN FRAME fPage1  
               int-item.cod-tam-placa = tt-int-item.cod-tam-placa:SCREEN-VALUE IN FRAME fPage1
               int-item.cod-potencia = tt-int-item.cod-potencia:SCREEN-VALUE IN FRAME fPage1.

        MESSAGE "Registro atualizado com sucesso!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    END.
    ELSE DO:
        CREATE int-item.
        ASSIGN int-item.it-codigo = cItem
               int-item.cod-cor = tt-int-item.cod-cor:SCREEN-VALUE IN FRAME fPage1
               int-item.cod-tipo-mp = tt-int-item.cod-tipo-mp:SCREEN-VALUE IN FRAME fPage1       
               int-item.cod-modelo-placa = tt-int-item.cod-modelo-placa:SCREEN-VALUE IN FRAME fPage1  
               int-item.cod-tam-placa = tt-int-item.cod-tam-placa:SCREEN-VALUE IN FRAME fPage1
               int-item.cod-potencia = tt-int-item.cod-potencia:SCREEN-VALUE IN FRAME fPage1. 

        MESSAGE "Registro criado com sucesso!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

