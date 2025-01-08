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
{include/i-prgvrs.i escpp120b 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escpp120b mcp}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp120b
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 fi-ns c-it-codigo cb-reimp ~
                              btConfigImpr      
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.

{esp/es0018.i}
{cdp/cd0666.i}
DEFINE VARIABLE h-esapi038 AS HANDLE   NO-UNDO.

DEF INPUT PARAM p-printer AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-carregou AS LOGICAL  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-4 RECT-5 RECT-6 ~
btQueryJoins btReportsJoins btExit btHelp fi-ns c-it-codigo c-desc-item ~
cb-modelo c-desc-modelo btConfigImpr fiPrinter cb-reimp btOk btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-ns c-it-codigo c-desc-item cb-modelo ~
c-desc-modelo fiPrinter cb-reimp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnModeloEtiq5G wWindow 
FUNCTION FnModeloEtiq5G RETURNS LOGICAL
  ( i-modelo AS INT )  FORWARD.

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

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

DEFINE BUTTON btOk 
     LABEL "Imprimir" 
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

DEFINE VARIABLE cb-modelo AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Modelo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "         0",000
     DROP-DOWN-LIST
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reimp AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Motivo Reimp" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 68 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 64 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ns AS CHARACTER FORMAT "X(13)":U 
     LABEL "NS ou MAC" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE im-imagem
     FILENAME "adeicon/blank":U
     SIZE 90 BY 9.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
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
     fi-ns AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 2
     c-it-codigo AT ROW 4.5 COL 15.14 COLON-ALIGNED WIDGET-ID 18
     c-desc-item AT ROW 4.5 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     cb-modelo AT ROW 5.42 COL 15.14 COLON-ALIGNED WIDGET-ID 32
     c-desc-modelo AT ROW 5.42 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     btConfigImpr AT ROW 6.29 COL 81.14 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     fiPrinter AT ROW 6.33 COL 17.14 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     cb-reimp AT ROW 7.75 COL 14.86 COLON-ALIGNED WIDGET-ID 44
     btOk AT ROW 19.17 COL 2
     btCancel AT ROW 19.17 COL 13
     btHelp2 AT ROW 19.17 COL 80
     "Impressora:" VIEW-AS TEXT
          SIZE 7.86 BY .63 AT ROW 6.46 COL 9.14 WIDGET-ID 46
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 18.96 COL 1
     RECT-4 AT ROW 2.75 COL 1 WIDGET-ID 14
     RECT-5 AT ROW 4.25 COL 1 WIDGET-ID 16
     RECT-6 AT ROW 7.5 COL 1 WIDGET-ID 38
     im-imagem AT ROW 9.21 COL 1 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20
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
         HEIGHT             = 19.46
         WIDTH              = 90.14
         MAX-HEIGHT         = 20.04
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 20.04
         VIRTUAL-WIDTH      = 90.14
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
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR IMAGE im-imagem IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       im-imagem:HIDDEN IN FRAME fpage0           = TRUE.

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


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wWindow
ON CHOOSE OF btOk IN FRAME fpage0 /* Imprimir */
DO:
    DEFINE VARIABLE l-FiberCaixa AS LOGICAL     NO-UNDO.

    ASSIGN INPUT FRAME fpage0 fi-ns c-it-codigo cb-modelo fiPrinter cb-reimp cb-modelo.                 

    FIND FIRST int-etiqueta-5g NO-LOCK
         WHERE int-etiqueta-5g.n-serie = fi-ns NO-ERROR.
    IF NOT AVAIL int-etiqueta-5g THEN DO:

        FIND FIRST int-etiqueta-5g NO-LOCK
             WHERE int-etiqueta-5g.mac = fi-ns NO-ERROR.
        IF NOT AVAIL int-etiqueta-5g THEN DO:

            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'N£mero de sÇrie ainda n∆o foi impresso').

            RETURN NO-APPLY.
        END.        
    END.   
    ELSE DO: 
        RUN esp/es0018p.p (INPUT "escpp120":U,
                           INPUT 4,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR EACH tt-prog-ponto:
            IF tt-prog-ponto.conteudo = cb-modelo:SCREEN-VALUE IN FRAME fpage0 THEN 
               ASSIGN l-FiberCaixa = YES.
        END.    
    END.

    /* Caixa FiberHome */
    IF l-FiberCaixa THEN
       ASSIGN cb-modelo = 665. 
        
    RUN esapi/esapi038.p PERSISTENT SET h-esapi038.        
    
    RUN piImpressao IN h-esapi038 (INPUT fiPrinter,
                                   INPUT ROWID(int-etiqueta-5g),
                                   INPUT YES, /* Reimpress∆o */
                                   INPUT cb-reimp,
                                   INPUT cb-modelo,
                                   OUTPUT TABLE tt-erro).        
    
    RUN cdp\cd0666.w (INPUT TABLE tt-erro).
    
    DELETE PROCEDURE h-esapi038.        
    
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


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    DO WITH FRAME fPage0:

        ASSIGN c-desc-item:SCREEN-VALUE = "".
    
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-item:SCREEN-VALUE = ITEM.desc-item.
    
        END.

        ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = NO.

        RUN piCarregaModelo.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modelo wWindow
ON LEAVE OF cb-modelo IN FRAME fpage0 /* Modelo */
DO:
    
    DO WITH FRAME fPage0:

        ASSIGN c-desc-modelo:SCREEN-VALUE = "".
    
        FOR FIRST modelo-etiq NO-LOCK
            WHERE modelo-etiq.cod-modelo = int(SELF:SCREEN-VALUE):
    
            ASSIGN c-desc-modelo:SCREEN-VALUE = modelo-etiq.descricao.               
        END.

        ASSIGN im-imagem:VISIBLE = TRUE
               l-carregou = im-imagem:LOAD-IMAGE(modelo-etiq.imagem) NO-ERROR.
    
        IF NOT l-carregou THEN ASSIGN im-imagem:VISIBLE = FALSE.

    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modelo wWindow
ON VALUE-CHANGED OF cb-modelo IN FRAME fpage0 /* Modelo */
DO:

    APPLY "leave" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ns
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ns wWindow
ON LEAVE OF fi-ns IN FRAME fpage0 /* NS ou MAC */
DO:
    ASSIGN INPUT FRAME fpage0 fi-ns.


    /*
    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = fi-ns NO-ERROR.*/

    FIND FIRST int-etiqueta-5g 
         WHERE int-etiqueta-5g.n-serie = fi-ns NO-ERROR.

    IF AVAIL int-etiqueta-5g  THEN DO:
        ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME fpage0 = int-etiqueta-5g.it-codigo.
        APPLY 'leave' TO c-it-codigo IN FRAME fpage0.
    END.
    ELSE DO:
        
        FIND FIRST mac-address NO-LOCK
             WHERE mac-address.mac = INPUT fi-ns NO-ERROR.
        IF AVAIL mac-address THEN DO:
            ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME fpage0 = mac-address.it-codigo.            
        END.
        ELSE
            ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME fpage0 = "".

        APPLY 'leave' TO c-it-codigo IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ns wWindow
ON RETURN OF fi-ns IN FRAME fpage0 /* NS ou MAC */
DO:
    APPLY 'leave' TO SELF.

    RETURN NO-APPLY.
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
    DEFINE VARIABLE c-mot-reimp AS CHARACTER   NO-UNDO.   

    DO WITH FRAME fPage0:
    
        RUN esp/es0018p.p (INPUT "escpp066a", 
                           INPUT 1,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).
    
        ASSIGN c-mot-reimp = "".
        
        FOR EACH tt-prog-ponto
            WHERE tt-prog-ponto.sequencia NE 5:
    
            ASSIGN c-mot-reimp = c-mot-reimp + "," + tt-prog-ponto.conteudo + "," + string(tt-prog-ponto.sequencia).
    
        END.
    
        ASSIGN cb-reimp:LIST-ITEM-PAIRS = substring(c-mot-reimp, 2,LENGTH(c-mot-reimp) - 1).
    
    END.
    
    /*
    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:
    
        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:
    
            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = layout_impres.nom_impressora + ":" +
                                                            layout_impres.cod_layout_impres.
    
        END.
    END.*/

    ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = p-printer.

    
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaModelo wWindow 
PROCEDURE piCarregaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        EMPTY TEMP-TABLE tt-prog-ponto.
        /* Modelos Etiqueta 5G */                      
        RUN esp/es0018p.p (INPUT "escpp120":U,         
                           INPUT 2,                    
                           INPUT 0,                    
                           INPUT "":U,                 
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:
           
            FOR EACH item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                BY item-mod-etiq.padrao DESC:
        
                IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.
               
                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
        
               LEAVE.
            END.
        
            ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = YES.
        
        END.
        ELSE DO:

            EMPTY TEMP-TABLE tt-prog-ponto.
            
            /* Modelos Etiqueta FiberHome */                      
            RUN esp/es0018p.p (INPUT "escpp120":U,         
                               INPUT 4,                    
                               INPUT 0,                    
                               INPUT "":U,                 
                               OUTPUT TABLE tt-prog-ponto).
            
            ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
            
            FOR EACH item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:
            
                IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.
            
               cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).
            
            END.
            
            IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:
               
                FOR EACH item-mod-etiq NO-LOCK
                    WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                    BY item-mod-etiq.padrao DESC:
            
                    IF NOT FnModeloEtiq5G(item-mod-etiq.cod-modelo) THEN NEXT.
                   
                    ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
            
                   LEAVE.
                END.
            
                ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = YES.
            
            END.
            ELSE DO:
                ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0".
            
                ASSIGN cb-modelo:SCREEN-VALUE = "0". 
            END.         
        END.

        APPLY "LEAVE" TO cb-modelo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnModeloEtiq5G wWindow 
FUNCTION FnModeloEtiq5G RETURNS LOGICAL
  ( i-modelo AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  FIND FIRST tt-prog-ponto
       WHERE tt-prog-ponto.conteudo = STRING(i-modelo)
  NO-ERROR.

  IF AVAIL tt-prog-ponto THEN
     RETURN YES.   
  ELSE
     RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

