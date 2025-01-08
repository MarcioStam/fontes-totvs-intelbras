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
{include/i-prgvrs.i ESCPP123 2.00.00.000}
{include/i-license-manager.i ESCPP123 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP123
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btImprimir btCancel btHelp2 c-it-codigo fiPrinter btConfigImpr qtd-imprime l-coletivas qtd-embal ~
                                
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
 

{esp/es0018.i}
{esapi/esapi016.i}
{upc/btb910za-upc.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER   NO-UNDO.

DEFINE VARIABLE i-cor         AS INTEGER   NO-UNDO.
DEFINE VARIABLE fc-qr-code    AS CHARACTER NO-UNDO.

DEFINE VARIABLE wh-pesquisa   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VAR c-n-serie          AS CHAR NO-UNDO.
DEFINE VAR c-mac              AS CHAR NO-UNDO EXTENT 10.
DEFINE VAR c-erro             AS CHAR NO-UNDO.
DEFINE VAR i-cont             AS INTE NO-UNDO.

DEFINE BUFFER b-mac-address FOR mac-address.

DEF TEMP-TABLE tt-num-serie LIKE num-serie-vivo
    FIELD num-caixa AS INT
    INDEX idx1 num-caixa n-serie.

DEF TEMP-TABLE tt-etiq-cx
    FIELD num-caixa   AS INT
    FIELD n-serie-ini AS CHAR
    FIELD n-serie-fim AS CHAR
    INDEX idx num-caixa.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-it-codigo qtd-embal qtd-imprime ~
l-coletivas btImprimir btCancel btHelp2 btHelp btQueryJoins btReportsJoins ~
c-desc-item btConfigImpr btExit fiPrinter rtToolBar-2 rtToolBar RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo qtd-embal qtd-imprime ~
l-coletivas c-desc-item fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-carac-esp wWindow 
FUNCTION fn-carac-esp RETURNS CHAR ( INPUT p-palavra AS CHAR ) FORWARD.

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

DEFINE BUTTON btImprimir 
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

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-embal AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Qtde Embal" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-imprime AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Qtde Caixas" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-coletivas AS LOGICAL INITIAL yes 
     LABEL "Caixas Coletivas" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-it-codigo AT ROW 3 COL 18.72 COLON-ALIGNED WIDGET-ID 4
     qtd-embal AT ROW 4 COL 18.72 COLON-ALIGNED WIDGET-ID 52
     qtd-imprime AT ROW 6.5 COL 18.72 COLON-ALIGNED WIDGET-ID 44
     l-coletivas AT ROW 6.54 COL 39 WIDGET-ID 46
     btImprimir AT ROW 7.83 COL 2.14 WIDGET-ID 50
     btCancel AT ROW 7.83 COL 12.57
     btHelp2 AT ROW 7.83 COL 88
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     c-desc-item AT ROW 3 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btConfigImpr AT ROW 4.92 COL 65.29 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     fiPrinter AT ROW 5 COL 20.57 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 5.17 COL 12.57 WIDGET-ID 26
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 7.63 COL 1.29
     RECT-1 AT ROW 2.75 COL 1.43 WIDGET-ID 2
     RECT-2 AT ROW 6.33 COL 1.43 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 8.13
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
         HEIGHT             = 8.13
         WIDTH              = 98.72
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 195.14
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
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Imprimir */
DO: 
   IF c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
       MESSAGE 'Informe um produto valido'
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       APPLY 'entry' TO c-it-codigo IN FRAME {&FRAME-NAME}.

       RETURN 'nok'.
   END.


   FIND FIRST item-ean 
        WHERE item-ean.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
   NO-LOCK NO-ERROR.  

   IF NOT AVAIL item-ean THEN DO:
      MESSAGE 'Item nao cadastrado (ESCPP020)'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      APPLY 'entry' TO c-it-codigo IN FRAME {&FRAME-NAME}.

      RETURN 'nok'.
   END.

   IF item-ean.cod-sap = '' THEN DO:
      MESSAGE 'Cod.SAP nao foi cadastrado (ESCPP020)'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      APPLY 'entry' TO c-it-codigo IN FRAME {&FRAME-NAME}.

      RETURN 'nok'.                                
   END.


   FIND FIRST item-dun 
        WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
   NO-LOCK NO-ERROR.

   IF NOT AVAIL item-dun THEN DO:
      MESSAGE 'Item DUN nao cadastrado (ESCPP067)'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      APPLY 'entry' TO c-it-codigo IN FRAME {&FRAME-NAME}.

      RETURN 'nok'.
   END. 
   ELSE DO:
       FIND FIRST item-dun 
            WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
              AND item-dun.qtd-emb   = INT(qtd-embal:SCREEN-VALUE IN FRAME {&FRAME-NAME})
       NO-LOCK NO-ERROR.
    
       IF NOT AVAIL item-dun THEN DO:
          MESSAGE 'Item DUN nao cadastrado (ESCPP067)'
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    
          APPLY 'entry' TO qtd-embal IN FRAME {&FRAME-NAME}.
    
          RETURN 'nok'.
       END. 
   END.

   
   IF INT(qtd-imprime:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN DO:
       MESSAGE 'Qtde impressoes deve ser informada'
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       APPLY 'entry' TO qtd-imprime IN FRAME {&FRAME-NAME}.

       RETURN 'nok'.
   END.

   RUN piCriaEtiquetas.
   RUN piImpressao.




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
ON F5 OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/zoomfields.i &ProgramZoom="eszoom/z01es614.w"
                         &FieldZoom1="it-codigo"        
                         &FieldScreen1="c-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="qtd-emb"        
                         &FieldScreen2="qtd-embal"
                         &Frame2="fPage0"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Item */
DO:
    DO WITH FRAME fPage0:
        ASSIGN c-desc-item:SCREEN-VALUE = "".
    
        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-item:SCREEN-VALUE = item.desc-item.

        END.

        RUN piCarregaModelo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON RETURN OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    ASSIGN SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,7).

    IF SELF:SCREEN-VALUE BEGINS "8" THEN DO:
        FIND FIRST it-altern NO-LOCK
             WHERE it-altern.it-altern = SELF:SCREEN-VALUE NO-ERROR.
        IF AVAIL it-altern THEN
            ASSIGN SELF:SCREEN-VALUE = it-altern.it-codigo.
    END.

    APPLY "LEAVE" TO SELF.

    

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-coletivas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-coletivas wWindow
ON VALUE-CHANGED OF l-coletivas IN FRAME fpage0 /* Caixas Coletivas */
DO:
   IF NOT l-coletivas:CHECKED IN FRAME {&FRAME-NAME} THEN 
      ASSIGN qtd-imprime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1'.
   ELSE
      ASSIGN qtd-imprime:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '0'
             qtd-imprime:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.
             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qtd-embal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qtd-embal wWindow
ON RETURN OF qtd-embal IN FRAME fpage0 /* Qtde Embal */
DO:
    /*
    RUN piValida.

    IF RETURN-VALUE = 'NOK' THEN
       RETURN.


    FIND FIRST num-serie-dahua
         WHERE num-serie-dahua.n-serie = c-n-serie
           AND num-serie-dahua.mac     = c-mac[1]
    NO-LOCK NO-ERROR.

    IF AVAIL num-serie-dahua THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Num.Serie/MAC ja foi impresso').

        RETURN NO-APPLY.
    END.       


    RUN piImpressao (INPUT '').
    */
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qtd-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qtd-imprime wWindow
ON RETURN OF qtd-imprime IN FRAME fpage0 /* Qtde Caixas */
DO:
    /*
    RUN piValida.

    IF RETURN-VALUE = 'NOK' THEN
       RETURN.


    FIND FIRST num-serie-dahua
         WHERE num-serie-dahua.n-serie = c-n-serie
           AND num-serie-dahua.mac     = c-mac[1]
    NO-LOCK NO-ERROR.

    IF AVAIL num-serie-dahua THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Num.Serie/MAC ja foi impresso').

        RETURN NO-APPLY.
    END.       


    RUN piImpressao (INPUT '').
    */
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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

APPLY "ENTRY" TO c-it-codigo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCapacidade wWindow 
PROCEDURE piCapacidade :
/*------------------------------------------------------------------------------
  Purpose: Exibe dialog para informar capacidade do pallet
  Notes: Carlos Daniel - 28/01/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER i-capacidade AS INTEGER NO-UNDO.

DEFINE VARIABLE i-qtdCapacidade AS INTEGER FORMAT ">,>>>,>>9"
     LABEL "Cap. (pc)"
     VIEW-AS FILL-IN 
     SIZE 15 BY .75 NO-UNDO.

DEFINE BUTTON btCapacidadeCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btCapacidadeOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtCapacidadeButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fCapacidadeRecord
    i-qtdCapacidade        AT ROW 1.21 COL 8.00 COLON-ALIGNED VIEW-AS FILL-IN FORMAT ">,>>>,>>9"

    btCapacidadeOK      AT ROW 2.63 COL 2.14
    btCapacidadeCancel  AT ROW 2.63 COL 13
    rtCapacidadeButton  AT ROW 2.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Qtde.Capacidade" FONT 1
         DEFAULT-BUTTON btCapacidadeOK CANCEL-BUTTON btCapacidadeCancel.

ON "CHOOSE":U OF btCapacidadeOK IN FRAME fCapacidadeRecord DO:
    ASSIGN i-qtdCapacidade.

    IF i-qtdCapacidade = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Capacidade pallet n∆o informada~~Favor informar a capacidade do Pallet.").
        RETURN "NOK".
    END.

    ASSIGN i-capacidade = i-qtdCapacidade.

    APPLY "GO":U TO FRAME fCapacidadeRecord.
END.

ENABLE i-qtdCapacidade btCapacidadeCancel btCapacidadeOK
    WITH FRAME fCapacidadeRecord. 

WAIT-FOR "GO":U OF FRAME fCapacidadeRecord.

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

      /*
    DO WITH FRAME fPage0:

        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:

            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                AND   item-mod-etiq.padrao:
    
                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
    
            END.

        END.
        ELSE DO:

            ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0".

            ASSIGN cb-modelo:SCREEN-VALUE = "0".

        END.

        APPLY "LEAVE" TO cb-modelo.

    END.
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaEtiquetas wWindow 
PROCEDURE piCriaEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b01-num-serie-vivo FOR num-serie-vivo.

DEFINE VARIABLE i-seq-aux   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cont1     AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cont2     AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-qtd-caixa AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-num-serie AS CHARACTER NO-UNDO.

ASSIGN i-qtd-caixa = 1.

FIND FIRST item-dun 
     WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
       AND item-dun.qtd-emb   = INT(qtd-embal:SCREEN-VALUE IN FRAME {&FRAME-NAME})
NO-LOCK NO-ERROR.

FIND FIRST item-ean 
     WHERE item-ean.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
NO-LOCK NO-ERROR.  

IF AVAIL item-dun THEN DO:
   ASSIGN i-qtd-caixa = item-dun.qtd-emb.
END.

FOR EACH tt-etiq-cx:
    DELETE tt-etiq-cx.
END.

FOR EACH tt-num-serie:
    DELETE tt-num-serie.
END.

ASSIGN i-seq-aux = 0.

/*
MESSAGE i-qtd-caixa
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

DO i-cont1 = 1 TO INT(qtd-imprime:SCREEN-VALUE IN FRAME {&FRAME-NAME}):

   IF NOT l-coletivas:CHECKED IN FRAME {&FRAME-NAME} THEN DO:

      FOR EACH b01-num-serie-vivo NO-LOCK:
          ASSIGN i-seq-aux = b01-num-serie-vivo.sequencia.
      END.
    
      IF i-seq-aux <> 0 THEN
         ASSIGN c-num-serie = item-ean.cod-sap + TRIM(STRING(i-seq-aux + 1,'>>>999999'))
                i-sequencia = i-seq-aux + 1.
      ELSE 
         ASSIGN c-num-serie = item-ean.cod-sap + TRIM(STRING(1,'>>>999999'))
                i-sequencia = 1.

      FIND FIRST tt-etiq-cx WHERE tt-etiq-cx.num-caixa = i-cont1 NO-ERROR.
    
      IF NOT AVAIL tt-etiq-cx THEN DO:
          CREATE tt-etiq-cx.   
          ASSIGN tt-etiq-cx.num-caixa   = i-cont1
                 tt-etiq-cx.n-serie-ini = c-num-serie
                 tt-etiq-cx.n-serie-fim = c-num-serie.
      END.                                                       
   END.
   ELSE DO:
       DO i-cont2 = 1 TO i-qtd-caixa:
           
          FOR EACH b01-num-serie-vivo NO-LOCK
              WHERE b01-num-serie-vivo.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
              BREAK BY b01-num-serie-vivo.sequencia:
              ASSIGN i-seq-aux = b01-num-serie-vivo.sequencia.
          END.
    
          IF i-seq-aux <> 0 THEN
             ASSIGN c-num-serie = item-ean.cod-sap + TRIM(STRING(i-seq-aux + 1,'>>>999999'))
                    i-sequencia = i-seq-aux + 1.
          ELSE 
             ASSIGN c-num-serie = item-ean.cod-sap + TRIM(STRING(1,'>>>999999'))
                    i-sequencia = 1.
    
          /* 
          FIND LAST b01-num-serie-vivo USE-INDEX ch-seq
               WHERE b01-num-serie-vivo.it-codigo =  c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-LOCK NO-ERROR.
          
          IF AVAIL b01-num-serie-vivo THEN
             ASSIGN c-num-serie = item-ean.texto[11] + STRING(b01-num-serie-vivo.sequencia + 1,'>>>999999')
                    i-sequencia = b01-num-serie-vivo.sequencia + 1.
          ELSE
             ASSIGN c-num-serie = item-ean.texto[11] + STRING(1,'>>>999999')
                    i-sequencia = 1.
          */         
    
          /*
          MESSAGE c-num-serie
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
    
    
          /* Criaá∆o da Tabela */
          CREATE num-serie-vivo.
          ASSIGN num-serie-vivo.n-serie     = c-num-serie
                 num-serie-vivo.it-codigo   = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}                          
                 num-serie-vivo.ano         = YEAR(TODAY)                                 
                 num-serie-vivo.sequencia   = i-sequencia                         
                 num-serie-vivo.num-pedido  = 0
                 num-serie-vivo.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
                 num-serie-vivo.data        = NOW
                 num-serie-vivo.usuario     = c-seg-usuario                           
                 num-serie-vivo.re-impr     = 0
                 num-serie-vivo.dt-ult-re   = ?                                     
                 num-serie-vivo.us-ult-re   = ?                                     
                 num-serie-vivo.motiv-re    = ?.
           
          CREATE tt-num-serie.
          BUFFER-COPY num-serie-vivo TO tt-num-serie.
    
          ASSIGN tt-num-serie.num-caixa = i-cont1.
    
          FIND FIRST tt-etiq-cx WHERE tt-etiq-cx.num-caixa = i-cont1 NO-ERROR.
    
          IF NOT AVAIL tt-etiq-cx THEN DO:
              CREATE tt-etiq-cx.   
              ASSIGN tt-etiq-cx.num-caixa   = i-cont1
                     tt-etiq-cx.n-serie-ini = num-serie-vivo.n-serie.
          END.
    
          /* Ultima etiqueta caixa coletiva */
          IF i-cont2 = i-qtd-caixa THEN DO:
             IF AVAIL tt-etiq-cx THEN
                ASSIGN tt-etiq-cx.n-serie-fim = num-serie-vivo.n-serie.
          END.
    
       END.
   END.
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
   
   
   if input frame {&frame-name} fiPrinter = "":U then do:
      message "Informe uma impressora v†lida.":U view-as alert-box.
      return no-apply.
   end.
    
   RUN piSetaImpressora(INPUT input frame {&frame-name} fiPrinter).
    
   //ASSIGN v_nom_disposit_so = 'c:/temp/teste123.txt'.

   OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

   {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/ 

    FIND FIRST item-dun 
         WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    NO-LOCK NO-ERROR.

   FIND FIRST item-ean 
         WHERE item-ean.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    NO-LOCK NO-ERROR.  
    
    FIND FIRST item-mat 
         WHERE item-mat.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    NO-LOCK NO-ERROR.  

   FOR EACH tt-etiq-cx:

       FOR EACH tt-num-serie 
           WHERE tt-num-serie.num-caixa = tt-etiq-cx.num-caixa:

           PUT "^XA" SKIP.     
       
           PUT UNFORMATTED "^FO450,65^A0N,26,26^FDSAP:^FS" SKIP.
           PUT UNFORMATTED "^FO520,60^BY2^BCN,30,N,N,N,N^FD" item-ean.cod-sap  "^FS"   SKIP.
           PUT UNFORMATTED "^FO470,95^A0N,18,18^FB300,1,0,C^FD" item-ean.cod-sap "^FS" SKIP. 
        
           PUT UNFORMATTED "^FO510,120^A0N,26,26^FD" "NS:" "^FS" SKIP.
           PUT UNFORMATTED "^FO560,120^BY1^BCN,30,N,N,N,N^FD"  tt-num-serie.n-serie "^FS"   SKIP. 
           PUT UNFORMATTED "^FO550,155^A0N,18,18^FB200,1,0,C^FD" tt-num-serie.n-serie "^FS" SKIP.

           PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
           PUT "^XZ" SKIP.
       END.

       PUT "^XA" SKIP.                                                                                                                                                          
       
       PUT UNFORMATTED "^FO20,30^A0N,26,26^FB50,1,0,C^FD" "SAP" "^FS"       SKIP.
       PUT UNFORMATTED "^FO90,25^BY2^BCN,30,N,N,N,N^FD" "22017515" "^FS"    SKIP. /* Codigo de Barras EAN 128 */                                                          
       PUT UNFORMATTED "^FO60,60^A0N,18,18^FB300,1,0,C^FD" "22017515" "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
    
       PUT UNFORMATTED "^FO20,90^A0N,26,26^FB50,1,0,C^FD" "EAN" "^FS" SKIP.
       PUT UNFORMATTED "^FO90,85^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */                                               
       
       PUT UNFORMATTED "^FO50,160^A0N,18,18^FB80,1,0,C^FDNS INI^FS"                         SKIP.
       PUT UNFORMATTED "^FO130,160^BY1^BCN,30,N,N,N,N^FD" tt-etiq-cx.n-serie-ini "^FS"      SKIP. /* Codigo de Barras EAN 128 */                                                          
       PUT UNFORMATTED "^FO60,195^A0N,18,18^FB300,1,0,C^FDNS:" tt-etiq-cx.n-serie-ini "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
       
       PUT UNFORMATTED "^FO50,210^A0N,18,18^FB80,1,0,C^FDNS FIM^FS" SKIP.
       PUT UNFORMATTED "^FO130,220^BY1^BCN,30,N,N,N,N^FD" tt-etiq-cx.n-serie-fim "^FS" SKIP.      /* Codigo de Barras EAN 128 */                                                          
       PUT UNFORMATTED "^FO60,255^A0N,18,18^FB300,1,0,C^FDNS:" tt-etiq-cx.n-serie-fim "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
    
       PUT UNFORMATTED "^FO20,245^A0N,27,27^FB80,1,0,C^FD" "Qtd: " STRING(item-dun.qtd-emb) "^FS" SKIP.

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
       PUT "^XZ" SKIP.
   END.

   OUTPUT CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaImpressora wWindow 
PROCEDURE piSetaImpressora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAM p-impressora  AS CHAR NO-UNDO.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:

    ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
           cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora    = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.
ELSE DO:
    IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
           cLayout  = ENTRY(2, p-impressora, ":":U).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.


ASSIGN v_nom_disposit_so = "".

IF AVAIL imprsor_usuar THEN
    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValida wWindow 
PROCEDURE piValida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /*
    ASSIGN fc-qr-code = fn-carac-esp(INPUT FRAME fPage0 c-qr-code).

    //assign input frame fPage0 c-qr-code:screen-value = "". 

    IF INPUT FRAME fPage0 c-it-codigo = ""
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Informe um item.'
                                 + '~~' + 'Informe um item.').
        RETURN "NOK":U.
    END.

    IF INPUT FRAME fPage0 cb-modelo = 000
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'M¢delo invalido.'
                                 + '~~' + 'Modelo informado n∆o cadastrado ou item sem m¢delo vinculado.').
        RETURN "NOK":U.
    END.

    IF c-qr-code:screen-value = "" 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Informe o QrCode').
        RETURN "NOK":U.
    END.



    //Limpa variaveis do retorno
    ASSIGN c-erro    = ""
           c-n-serie = "".

    DO i-cont = 1 TO 10: 
        ASSIGN c-mac[i-cont] = "".
    END.
    //Fim limpa variaveis

    /*
    RUN esp\cpp\escpp106a.p (INPUT INPUT FRAME fPage0 c-it-codigo,
                            INPUT fc-qr-code,
                            OUTPUT c-n-serie,
                            OUTPUT c-mac,
                            OUTPUT c-erro).*/

    //Padr∆o na devoluá∆o de Numero de Serie e MAC
    ASSIGN c-n-serie = SUBSTRING(c-qr-code:SCREEN-VALUE,5,15)
           c-mac[1]  = SUBSTRING(c-qr-code:SCREEN-VALUE,26,12).
           //c-mac[2]  = SUBSTRING(c-qr-code,42,12).

     */  
    
    /*
    MESSAGE 'c-n-serie : ' c-n-serie  SKIP 
            'c-mac[1] :'   c-mac[1]
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate wWindow 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-acesso      AS LOGICAL     NO-UNDO.
ASSIGN c-cod-estabel = v_cod_estab_usuar.

/*
IF  c-cod-estabel = "" OR  c-cod-estabel = ? THEN
    ASSIGN c-cod-estabel = "101".

/* Se a CÇlula foi informada, deve ser v†lida. */
IF INPUT FRAME fPage0 c-sigla <> "" THEN DO:
    IF NOT CAN-FIND(FIRST ns-sigla
                    WHERE ns-sigla.sigla = INPUT FRAME fPage0 c-sigla) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 56,
                       INPUT "CÇlula").
        RETURN "NOK":U.
    END.
END.

FOR FIRST modelo-etiq NO-LOCK
        WHERE modelo-etiq.cod-modelo = INPUT FRAME fPage0 cb-modelo:

    IF  modelo-etiq.tipo = 1 /* N£mero de SÇrie */ THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo = INPUT FRAME fPage0 c-it-codigo
            AND   item-uni-estab.cod-estabel = c-cod-estabel:
    
            FOR FIRST tt-prog-ponto
                WHERE entry(1, tt-prog-ponto.conteudo, ";") = c-cod-estabel
                AND   int(ENTRY(2, tt-prog-ponto.conteudo, ";")) = item-uni-estab.nr-linha:
        
                IF INPUT FRAME fPage0 c-sigla = "" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "CÇlula deve ser informada.").
                    RETURN "NOK":U.
                END.
            END.
        END.

        /********************* Carlos Daniel 13/04/2016 - Chamado 68342 *********************/
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto NO-ERROR.

        FOR EACH usuar_grp_usuar
            WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-LOCK:
        
            IF LOOKUP(usuar_grp_usuar.cod_grp_usuar,tt-prog-ponto.conteudo) > 0 THEN DO:
                ASSIGN l-acesso = YES.
                LEAVE.
            END.
        END.

        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "ESCPP066":U, /* Nome do programa */
                           INPUT 3,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto NO-ERROR.
        /*
        IF LOOKUP(cb-modelo:SCREEN-VALUE,tt-prog-ponto.conteudo) = 0 THEN DO:
            FOR LAST num-serie
                WHERE num-serie.it-codigo = c-it-codigo:SCREEN-VALUE
                NO-LOCK BY num-serie.data:
            
                IF DATE(num-serie.data) < DATE("01/03/2016") THEN DO:
                    IF l-acesso THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 27100,
                                           INPUT "Revis∆o Item~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Deseja imprimir? " +
                                                 "Caso for impresso, o item ficar† automaticamente liberado para produá∆o." ).
                        IF RETURN-VALUE = "NO" THEN
                            RETURN "NOK":U.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                           INPUT 17006,
                                           INPUT "Item inv†lido~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Solicitar a Engenharia Industrial.").
                        RETURN "NOK":U.
                    END.
                END.
            END.

            IF NOT AVAIL num-serie THEN DO:
                IF l-acesso THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 27100,
                                       INPUT "Revis∆o Item~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Deseja imprimir? " +
                                             "Caso for impresso, o item ficar† automaticamente liberado para produá∆o." ).
                    IF RETURN-VALUE = "NO" THEN
                        RETURN "NOK":U.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 17006,
                                       INPUT "Item inv†lido~~Este item n∆o Ç montado a algum tempo e necessita de uma revis∆o em seu cadastro. Solicitar a Engenharia Industrial.").
                    RETURN "NOK":U.
                END.
            END.
        END. */
    END.

    IF  modelo-etiq.tipo = 5 OR modelo-etiq.tipo = 7 /* DUN14 */ THEN DO:
        IF  NOT CAN-FIND(FIRST item-dun
                         WHERE item-dun.it-codigo = c-it-codigo:SCREEN-VALUE) THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Item incorreto.' + '~~' + 'Item n∆o possui DUN14 cadastrado.').
            APPLY 'entry':U TO c-it-codigo IN FRAME fpage0.
            RETURN "NOK":U.
        END.
    END.
END.

RETURN "OK":U.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-carac-esp wWindow 
FUNCTION fn-carac-esp RETURNS CHAR ( INPUT p-palavra AS CHAR ):
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-palavra AS CHARACTER   NO-UNDO.

    ASSIGN c-palavra = p-palavra
           c-palavra =  replace(c-palavra, "~{", " ")
           c-palavra =  replace(c-palavra, "~}", " ").
    
    DO i-cont = 1 TO LENGTH(c-palavra):
        IF ASC(SUBSTRING(c-palavra, i-cont, 1)) < 32  OR
           ASC(SUBSTRING(c-palavra, i-cont, 1)) > 125 THEN
            ASSIGN OVERLAY(c-palavra, i-cont, 1) = "":U.
    END.

    RETURN c-palavra.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

