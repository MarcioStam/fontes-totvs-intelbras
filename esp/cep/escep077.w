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
{include/i-prgvrs.i escep077 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep077
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels  

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 fl-cod-estabel fl-dp-origem ~
                              fl-dp-destino fl-data-ini fl-data-fim fl-total-ae bt-go
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar IMAGE-1 IMAGE-2 ~
RECT-48 RECT-50 btQueryJoins btReportsJoins btExit btHelp fl-cod-estabel ~
fl-dp-origem fl-dp-destino fl-data-ini fl-data-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fl-cod-estabel fl-dp-origem fl-dp-destino ~
fl-data-ini fl-data-fim fl-total-ae 

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
DEFINE BUTTON bt-go 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "bt-go" 
     SIZE 7 BY .88.

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
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
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

DEFINE VARIABLE fl-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fl-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fl-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Periodo inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fl-dp-destino AS CHARACTER FORMAT "X(3)":U 
     LABEL "Deposito Destino" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fl-dp-origem AS CHARACTER FORMAT "X(3)":U 
     LABEL "Deposito Origem" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fl-total-ae AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Qtde AE Movimentadas" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.75.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     fl-cod-estabel AT ROW 3.25 COL 23 HELP
          "Codigo do estabelecimento a ser consultado." WIDGET-ID 68
     fl-dp-origem AT ROW 4.5 COL 33 COLON-ALIGNED WIDGET-ID 6
     fl-dp-destino AT ROW 5.75 COL 22.57 WIDGET-ID 80
     fl-data-ini AT ROW 7 COL 33 COLON-ALIGNED HELP
          "Periodo Inicial" WIDGET-ID 2
     fl-data-fim AT ROW 7 COL 59 COLON-ALIGNED HELP
          "Periodo Final" NO-LABEL WIDGET-ID 82
     bt-go AT ROW 7 COL 75 WIDGET-ID 8
     fl-total-ae AT ROW 9.5 COL 41 COLON-ALIGNED HELP
          "Numero de AE movimentadas." WIDGET-ID 12
     btOK AT ROW 12 COL 3
     btCancel AT ROW 12 COL 14
     btHelp2 AT ROW 12 COL 78 WIDGET-ID 90
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 11.75 COL 2
     IMAGE-1 AT ROW 7 COL 45 WIDGET-ID 72
     IMAGE-2 AT ROW 7 COL 58 WIDGET-ID 74
     RECT-48 AT ROW 2.75 COL 6 WIDGET-ID 84
     RECT-50 AT ROW 9 COL 6 WIDGET-ID 88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 12.5
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
         HEIGHT             = 12.5
         WIDTH              = 90.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.43
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
/* SETTINGS FOR BUTTON bt-go IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       bt-go:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN fl-cod-estabel IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fl-dp-destino IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fl-total-ae IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fl-total-ae:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go wWindow
ON CHOOSE OF bt-go IN FRAME fpage0 /* bt-go */
DO:
    DEFINE BUFFER b-movto-estoq FOR movto-estoq.
    ASSIGN fl-total-ae = 0.

    FOR EACH movto-estoq NO-LOCK
        WHERE movto-estoq.cod-estabel = INPUT FRAME fpage0 fl-cod-estabel
          AND movto-estoq.cod-depos   = INPUT FRAME fpage0 fl-dp-origem
          AND movto-estoq.dt-trans   >= INPUT FRAME fpage0 fl-data-ini
          AND movto-estoq.dt-trans   <= INPUT FRAME fpage0 fl-data-fim
          AND movto-estoq.tipo-trans  = 2
          AND movto-estoq.esp-docto   = 33:

        IF NOT AVAIL movto-estoq THEN NEXT.
        
        FIND FIRST b-movto-estoq 
            WHERE b-movto-estoq.serie-docto = movto-estoq.serie-docto
              AND b-movto-estoq.nro-docto   = movto-estoq.nro-docto      
              AND b-movto-estoq.cod-depos   = INPUT FRAME fpage0 fl-dp-destino
              AND b-movto-estoq.dt-trans   >= INPUT FRAME fpage0 fl-data-ini
              AND b-movto-estoq.dt-trans   <= INPUT FRAME fpage0 fl-data-fim
              AND b-movto-estoq.tipo-trans  = 1
              AND b-movto-estoq.esp-docto   = 33 NO-LOCK NO-ERROR.

        IF NOT AVAIL b-movto-estoq THEN NEXT.
    
        FIND ae-item
            WHERE ae-item.cod-estabel = b-movto-estoq.cod-estabel
              AND ae-item.nr-ae       = int(b-movto-estoq.nro-docto)
              AND ae-item.sequencia   = int(b-movto-estoq.serie-docto)NO-LOCK NO-ERROR.
        
        IF AVAIL ae-item THEN
            ASSIGN fl-total-ae = fl-total-ae + 1.

        DISP fl-total-ae WITH FRAME fPage0.
            
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
    DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Descri‡Æo" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "Programa para transferencia de AE entre depositos para produ‡Æo." + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rtGoToButton    AT ROW 8.28 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Descri‡Æo de Programa" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   /* DEFINE BUFFER b-movto-estoq FOR movto-estoq.
    ASSIGN fl-total-ae = 0.

    FOR EACH movto-estoq NO-LOCK
        WHERE movto-estoq.cod-estabel = INPUT FRAME fpage0 fl-cod-estabel
          AND movto-estoq.cod-depos   = INPUT FRAME fpage0 fl-dp-origem
          AND movto-estoq.dt-trans   >= INPUT FRAME fpage0 fl-data-ini
          AND movto-estoq.dt-trans   <= INPUT FRAME fpage0 fl-data-fim
          AND movto-estoq.tipo-trans  = 2
          AND movto-estoq.esp-docto   = 33:

        IF NOT AVAIL movto-estoq THEN NEXT.
        
        FIND FIRST b-movto-estoq 
            WHERE b-movto-estoq.serie-docto = movto-estoq.serie-docto
              AND b-movto-estoq.nro-docto   = movto-estoq.nro-docto      
              AND b-movto-estoq.cod-depos   = INPUT FRAME fpage0 fl-dp-destino
              AND b-movto-estoq.dt-trans   >= INPUT FRAME fpage0 fl-data-ini
              AND b-movto-estoq.dt-trans   <= INPUT FRAME fpage0 fl-data-fim
              AND b-movto-estoq.tipo-trans  = 1
              AND b-movto-estoq.esp-docto   = 33 NO-LOCK NO-ERROR.

        IF NOT AVAIL b-movto-estoq THEN NEXT.
    
        FIND ae-item
            WHERE ae-item.cod-estabel = b-movto-estoq.cod-estabel
              AND ae-item.nr-ae       = int(b-movto-estoq.nro-docto)
              AND ae-item.sequencia   = int(b-movto-estoq.serie-docto)NO-LOCK NO-ERROR.
        
        IF AVAIL ae-item THEN
            ASSIGN fl-total-ae = fl-total-ae + 1.

        DISP fl-total-ae WITH FRAME fPage0.
            
    END.
   */
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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF VALID-HANDLE(hWenController) THEN DO:
        ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
               l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
               l-habilitaRtf = NO.
               
    END.
    RUN pi-habilitaRtf.
    &endif
/*Fim alteracao 17/02/2005*/

ASSIGN fl-data-ini = TODAY
       fl-data-fim = TODAY.

DISPLAY fl-data-ini
        fl-data-fim WITH FRAME fPage0.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

