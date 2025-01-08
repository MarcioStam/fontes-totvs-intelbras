&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP105E 2.00.00.000}
{include/i-license-manager.i ESCPP105E FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP105E
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 fi-ns-ini fi-ns-fim ~
                              cb-modelo btConfigImpr cb-reimp rs-tipo-rel
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-item-ns AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-primeiro AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi016 AS HANDLE      NO-UNDO.

{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-tipo-rel cb-reimp btQueryJoins ~
btReportsJoins btExit btHelp fi-ns-ini fi-ns-fim c-it-codigo c-desc-item ~
c-desc-modelo btConfigImpr cb-modelo btOK btCancel btHelp2 fiPrinter ~
rtToolBar-2 rtToolBar IMAGE-1 IMAGE-2 RECT-4 RECT-5 RECT-3 RECT-6 rt-cor 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo-rel cb-reimp fi-ns-ini fi-ns-fim ~
c-it-codigo c-desc-item c-desc-modelo cb-modelo fiPrinter 

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
     LABEL "Fechar" 
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

DEFINE BUTTON btOK 
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
     LIST-ITEM-PAIRS "         0",001
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
     SIZE 56.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ns-fim AS CHARACTER FORMAT "X(13)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ns-ini AS CHARACTER FORMAT "X(13)":U 
     LABEL "N£mero de SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE im-imagem
     FILENAME "adeicon/blank":U
     SIZE 95 BY 7.83.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo-rel AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "N£mero de SÇrie", 1
     SIZE 30 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 10.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 3.21.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 1.5.

DEFINE RECTANGLE rt-cor
     EDGE-PIXELS 1 GRAPHIC-EDGE    
     SIZE 95 BY 1.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-tipo-rel AT ROW 2.96 COL 35.72 NO-LABEL WIDGET-ID 48
     cb-reimp AT ROW 8.83 COL 14.86 COLON-ALIGNED WIDGET-ID 44
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-ns-ini AT ROW 3.83 COL 25.86 COLON-ALIGNED WIDGET-ID 2
     fi-ns-fim AT ROW 3.83 COL 56.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-it-codigo AT ROW 5.38 COL 15 COLON-ALIGNED WIDGET-ID 18
     c-desc-item AT ROW 5.38 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     c-desc-modelo AT ROW 6.29 COL 26.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     btConfigImpr AT ROW 7.17 COL 80.86 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     cb-modelo AT ROW 6.29 COL 14.86 COLON-ALIGNED WIDGET-ID 32
     btOK AT ROW 20.79 COL 2
     btCancel AT ROW 20.79 COL 13
     btHelp2 AT ROW 20.79 COL 88.43
     fiPrinter AT ROW 7.21 COL 16.86 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 7.25 COL 8.86 WIDGET-ID 28
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 20.58 COL 1
     IMAGE-1 AT ROW 3.83 COL 43.29 WIDGET-ID 10
     IMAGE-2 AT ROW 3.83 COL 55.14 WIDGET-ID 12
     RECT-4 AT ROW 2.75 COL 2 WIDGET-ID 14
     RECT-5 AT ROW 5.17 COL 2 WIDGET-ID 16
     RECT-3 AT ROW 10.33 COL 2 WIDGET-ID 36
     im-imagem AT ROW 10.58 COL 3 WIDGET-ID 34
     RECT-6 AT ROW 8.58 COL 2 WIDGET-ID 38
     rt-cor AT ROW 18.75 COL 3 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 21.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 84 ROW 5.25
         SIZE 2.72 BY 2.08
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
         HEIGHT             = 21.04
         WIDTH              = 98.72
         MAX-HEIGHT         = 22.25
         MAX-WIDTH          = 98.72
         VIRTUAL-HEIGHT     = 22.25
         VIRTUAL-WIDTH      = 98.72
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR IMAGE im-imagem IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       im-imagem:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME fPage1:SENSITIVE        = FALSE.

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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Imprimir */
DO:
    RUN piImpressao.
    RETURN NO-APPLY.
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


        /*IF INPUT FRAME fPage0 cb-modelo = 0 THEN DO:*/

            RUN piCarregaModelo.

        /*END.*/

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

            /**/

            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = INPUT FRAME fPage0 c-it-codigo
                AND   item-mod-etiq.cod-modelo = modelo-etiq.cod-modelo:

                IF item-mod-etiq.cor <> "" THEN DO:

                    ASSIGN i-cor = COLOR-TABLE:NUM-ENTRIES
                           COLOR-TABLE:NUM-ENTRIES = i-cor + 1. 
                
                    COLOR-TABLE:SET-DYNAMIC(i-cor,TRUE).
                    COLOR-TABLE:SET-RED-VALUE(i-cor, int(ENTRY(1, item-mod-etiq.cor, ","))).
                    COLOR-TABLE:SET-GREEN-VALUE(i-cor, int(ENTRY(2, item-mod-etiq.cor, ","))).
                    COLOR-TABLE:SET-BLUE-VALUE(i-cor, int(ENTRY(3, item-mod-etiq.cor, ","))).
            
                    ASSIGN rt-cor:BGCOLOR = i-cor.

                END.

            END.
    
        END.
    
        /**/
    
        ASSIGN im-imagem:VISIBLE = TRUE.
    
        ASSIGN l-carregou = im-imagem:LOAD-IMAGE(modelo-etiq.imagem) NO-ERROR.
    
        IF NOT l-carregou THEN
            ASSIGN im-imagem:VISIBLE = FALSE.

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


&Scoped-define SELF-NAME fi-ns-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ns-fim wWindow
ON LEAVE OF fi-ns-fim IN FRAME fpage0
DO:
    IF rs-tipo-rel:SCREEN-VALUE = "1" THEN
        RUN piBuscaItem.
    ELSE
        RUN piBuscaItemEtiq.

    IF RETURN-VALUE <> "OK":U THEN DO:
        RUN piLimpaTela (NO).
        RETURN NO-APPLY.
    END.

    DO WITH FRAME fPage0:
        ASSIGN c-it-codigo:SCREEN-VALUE = c-item-ns.
        APPLY "leave" TO c-it-codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo-rel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-rel wWindow
ON VALUE-CHANGED OF rs-tipo-rel IN FRAME fpage0
DO:
    IF rs-tipo-rel:SCREEN-VALUE = "1" THEN
        ASSIGN fi-ns-ini:LABEL = "N£mero de SÇrie".
    ELSE
        ASSIGN fi-ns-ini:LABEL = "C¢digo Caixa/Pallet".
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
        
        FOR EACH tt-prog-ponto:

            ASSIGN c-mot-reimp = c-mot-reimp + "," + tt-prog-ponto.conteudo + "," + string(tt-prog-ponto.sequencia).

        END.

        ASSIGN cb-reimp:LIST-ITEM-PAIRS = substring(c-mot-reimp, 2,LENGTH(c-mot-reimp) - 1).

    END.

    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:

        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:

            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = layout_impres.nom_impressora + ":" +
                                                            layout_impres.cod_layout_impres.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaItem wWindow 
PROCEDURE piBuscaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-primeiro = TRUE
           i-aux = 0.

    IF NOT CAN-FIND (FIRST num-serie
                     WHERE num-serie.n-serie >= INPUT FRAME fPage0 fi-ns-ini
                     AND   num-serie.n-serie <= INPUT FRAME fPage0 fi-ns-fim) THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Faixa de N£mero de SÇrie n∆o encontrada. ~~ Selecione uma faixa de N£mero de SÇrie v†lida.").
        RETURN "NOK":U.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Pesquisando Item").

    FOR EACH num-serie NO-LOCK
        WHERE num-serie.n-serie >= INPUT FRAME fPage0 fi-ns-ini
        AND   num-serie.n-serie <= INPUT FRAME fPage0 fi-ns-fim
        BREAK BY num-serie.it-codigo:

        ASSIGN i-aux = i-aux + 1.

        IF i-aux MOD 100 = 0 THEN
            RUN pi-acompanhar IN h-acomp (INPUT "N£mero de SÇrie: " + num-serie.n-serie).

        IF FIRST-OF(num-serie.it-codigo) THEN DO:

            IF l-primeiro THEN DO:
                ASSIGN c-item-ns = num-serie.it-codigo
                       l-primeiro = FALSE.
            END.
    
            IF c-item-ns <> num-serie.it-codigo THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Faixa de N£mero de SÇrie possui mais de um item. ~~ Selecione uma faixa de N£mero de SÇrie de somente um item por vez.").
                APPLY "ENTRY" TO fi-ns-ini IN FRAME fPage0.
                RUN pi-finalizar IN h-acomp.
                RETURN "NOK":U.
            END.
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    IF i-aux = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Faixa de N£mero de SÇrie n∆o possui item. ~~ Selecione uma faixa v†lida.").
        APPLY "ENTRY" TO fi-ns-ini IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaItemEtiq wWindow 
PROCEDURE piBuscaItemEtiq :
/*------------------------------------------------------------------------------
  Purpose: Busca item pelo c¢digo da etiqueta coletiva    
  Notes:   Carlos Daniel - 29/01/2016
------------------------------------------------------------------------------*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Pesquisando Item").

FOR FIRST etiq-coletiva
    WHERE etiq-coletiva.cod-etiqueta >= INPUT FRAME fPage0 fi-ns-ini
    AND   etiq-coletiva.cod-etiqueta <= INPUT FRAME fPage0 fi-ns-fim NO-LOCK:

    ASSIGN c-item-ns = etiq-coletiva.it-codigo.
END.

IF c-item-ns = "" THEN
    RETURN "NOK".

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

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

        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0".
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo), item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:
/*
            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                AND   item-mod-etiq.padrao:
    
                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
    
            END.
*/
        RUN esp/es0018p.r (INPUT "MOD-DUO",
                           INPUT 1,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
        
        FIND FIRST tt-prog-ponto NO-LOCK.

        IF AVAIL tt-prog-ponto 
        THEN ASSIGN cb-modelo:SCREEN-VALUE = string(tt-prog-ponto.conteudo).
        END.
        ELSE DO:

            ASSIGN cb-modelo:LIST-ITEMS = ",0".

            ASSIGN cb-modelo:SCREEN-VALUE = "0".

        END. 

        APPLY "LEAVE" TO cb-modelo.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao wWindow 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

IF rs-tipo-rel:SCREEN-VALUE IN FRAME fPage0 = "1" THEN
    RUN piBuscaItem.
ELSE
    RUN piBuscaItemEtiq.

IF RETURN-VALUE <> "OK":U THEN DO:
    RUN piLimpaTela (NO).
    RUN pi-finalizar IN h-acomp.
    DELETE PROCEDURE h-esapi016.
    APPLY "entry" TO fi-ns-ini IN FRAME fPage0.
    RETURN "NOK":U.
END.

EMPTY TEMP-TABLE tt-lista-ns.

IF rs-tipo-rel:SCREEN-VALUE IN FRAME fPage0 = "1" THEN DO:
    FOR EACH num-serie NO-LOCK
        WHERE num-serie.n-serie >= INPUT FRAME fPage0 fi-ns-ini
        AND   num-serie.n-serie <= INPUT FRAME fPage0 fi-ns-fim:
    
        CREATE tt-lista-ns.
        ASSIGN tt-lista-ns.num-serie = num-serie.n-serie.

        IF num-serie.char-2 <> "" 
        THEN DO:
            CREATE tt-lista-ns.
            ASSIGN tt-lista-ns.num-serie = num-serie.char-2.
        END.
    END.
END.


RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

RUN piImpressao IN h-esapi016 (INPUT 0, /* Num PO */
                               INPUT INPUT FRAME fPage0 c-it-codigo,
                               INPUT INPUT FRAME fPage0 cb-modelo,
                               INPUT "",  /* Pega da num-serie.sigla */
                               INPUT 0,
                               INPUT 0, /* Quantidade embalagem para DUN14, n∆o utilizado em reimpress∆o */
                               INPUT INPUT FRAME fPage0 cb-reimp,
                               INPUT 0,
                               INPUT INPUT FRAME fPage0 fiPrinter,
                               INPUT 2,
                               INPUT NO,
                               INPUT 0,
                               INPUT TABLE tt-lista-ns).

IF RETURN-VALUE <> "OK":U THEN DO:
    EMPTY TEMP-TABLE tt-erro.
    RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
    RUN pi-finalizar IN h-acomp.
    RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    DELETE PROCEDURE h-esapi016.
    RETURN "NOK":U.
END.

RUN pi-finalizar IN h-acomp.
DELETE PROCEDURE h-esapi016.
RUN piLimpaTela (YES).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimpaTela wWindow 
PROCEDURE piLimpaTela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-faixa-ns AS LOGICAL NO-UNDO.


    DO WITH FRAME fPage0:

        IF p-faixa-ns THEN
            ASSIGN fi-ns-ini:SCREEN-VALUE = ""
                   fi-ns-fim:SCREEN-VALUE = "".

        ASSIGN c-it-codigo:SCREEN-VALUE = ""
               /*fiPrinter:SCREEN-VALUE = ""*/
               cb-reimp:SCREEN-VALUE = "".

       // APPLY "leave" TO c-it-codigo.

        /*RUN piCarregaModelo.*/

    END.

    APPLY "entry" TO fi-ns-ini.

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

