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
{include/i-prgvrs.i ESCPP066 2.00.00.000}
{include/i-license-manager.i ESCPP106A FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP106A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 c-it-codigo cb-modelo ~
                              c-sigla i-qtd btConfigImpr   
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-it-codigo          AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-sigla              AS CHAR     NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
 
DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER NO-UNDO.

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
c-it-codigo c-desc-item c-desc-modelo c-sigla c-desc-sigla c-cod-estabel ~
c-desc-estabelec i-qtd cb-modelo btConfigImpr btOK btCancel fiPrinter ~
btHelp2 rtToolBar-2 rtToolBar RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-desc-item c-desc-modelo ~
c-sigla c-desc-sigla c-cod-estabel c-desc-estabelec i-qtd cb-modelo ~
fiPrinter 

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
     LIST-ITEM-PAIRS "620",1
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab.Pad.Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sigla AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-sigla AS CHARACTER FORMAT "X(2)":U 
     LABEL "CÇlula" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 4.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.25.

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
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     c-it-codigo AT ROW 3 COL 18.72 COLON-ALIGNED WIDGET-ID 4
     c-desc-item AT ROW 3 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-desc-modelo AT ROW 3.92 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-sigla AT ROW 4.83 COL 18.72 COLON-ALIGNED WIDGET-ID 8
     c-desc-sigla AT ROW 4.83 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-cod-estabel AT ROW 5.75 COL 18.72 COLON-ALIGNED WIDGET-ID 42
     c-desc-estabelec AT ROW 5.75 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     i-qtd AT ROW 7.13 COL 18.72 COLON-ALIGNED WIDGET-ID 10
     cb-modelo AT ROW 3.92 COL 18.72 COLON-ALIGNED WIDGET-ID 32 NO-TAB-STOP 
     btConfigImpr AT ROW 7.96 COL 65.29 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     btOK AT ROW 9.5 COL 2
     btCancel AT ROW 9.5 COL 12
     fiPrinter AT ROW 8.04 COL 20.72 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     btHelp2 AT ROW 9.5 COL 88.43
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 8.17 COL 12.57 WIDGET-ID 26
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 9.29 COL 1
     RECT-1 AT ROW 2.75 COL 1 WIDGET-ID 2
     RECT-2 AT ROW 6.92 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 9.79
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
         HEIGHT             = 9.79
         WIDTH              = 98.72
         MAX-HEIGHT         = 34
         MAX-WIDTH          = 219.43
         VIRTUAL-HEIGHT     = 34
         VIRTUAL-WIDTH      = 219.43
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Imprimir */
DO:
    
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
        ASSIGN l-teste = NO.
    ELSE
        ASSIGN l-teste = YES.
   
    RUN piImpressao.
/*    IF l-teste THEN
        RUN piImpTeste.
    ELSE
        RUN piImpressao.*/
  
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


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON F5 OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabelec
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF AVAIL estabelec THEN
        ASSIGN c-desc-estabelec:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
    ELSE
        ASSIGN c-desc-estabelec:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON RETURN OF c-cod-estabel IN FRAME fpage0 /* Estab.Pad.Item */
DO:
    APPLY "LEAVE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/zoomfields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"        
                         &FieldScreen1="c-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"        
                         &FieldScreen2="c-desc-item"
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

    APPLY "ENTRY" TO c-sigla.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sigla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON F5 OF c-sigla IN FRAME fpage0 /* CÇlula */
DO: 

    {method/zoomfields.i &ProgramZoom="eszoom\z01es244.w"
                         &FieldZoom1="sigla"        
                         &FieldScreen1="c-sigla"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"        
                         &FieldScreen2="c-desc-sigla"
                         &Frame2="fPage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON LEAVE OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    DO WITH FRAME fPage0:

        ASSIGN c-desc-sigla:SCREEN-VALUE = "".
    
        FOR FIRST ns-sigla NO-LOCK
            WHERE ns-sigla.sigla = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-sigla:SCREEN-VALUE = ns-sigla.descricao.
    
        END.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON MOUSE-SELECT-DBLCLICK OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sigla wWindow
ON VALUE-CHANGED OF c-sigla IN FRAME fpage0 /* CÇlula */
DO:

    ASSIGN self:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).

    APPLY "END" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modelo wWindow
ON LEAVE OF cb-modelo IN FRAME fpage0 /* Modelo */
DO:

    DO  WITH FRAME fPage0:

        ASSIGN c-desc-modelo:SCREEN-VALUE = "".
    
        FOR FIRST modelo-etiq NO-LOCK
            WHERE modelo-etiq.cod-modelo = int(SELF:SCREEN-VALUE):
    
            ASSIGN c-desc-modelo:SCREEN-VALUE = modelo-etiq.descricao.
            
            ASSIGN i-cont-tot    = 0
                   i-qtd-embalag = 0.
            IF  modelo-etiq.tipo = 5 OR modelo-etiq.tipo = 7 /*DUN14 ou Caixa*/ THEN DO:
                ASSIGN INPUT FRAME fPage0 c-it-codigo.

                SELECT COUNT(*) INTO i-cont-tot FROM item-dun WHERE item-dun.it-codigo = c-it-codigo.

                IF  i-cont-tot > 1 THEN DO:
                    RUN esp\cpp\escpp066b.w (INPUT c-it-codigo, OUTPUT i-qtd-embalag).
                    APPLY "entry":U TO c-sigla IN FRAME fPage0.
                END. /* IF  i-cont-tot > 1 THEN DO: */
                ELSE do: 
                    IF i-cont-tot = 1 THEN DO:
                        FOR FIRST item-dun NO-LOCK WHERE item-dun.it-codigo = c-it-codigo:
                            ASSIGN i-qtd-embalag = item-dun.qtd-emb.
                        END. /* FOR FIRST item-dun NO-LOCK */
                        APPLY "entry":U TO c-sigla IN FRAME fPage0.
                     END.
                END.
            END. /* IF  modelo-etiq.tipo */

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

                END.

            END.

        END. /* FOR FIRST modelo-etiq NO-LOCK */
    END. /* DO  WITH FRAME fPage0: */
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF c-sigla:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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

ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0      = NO
       c-it-codigo:SENSITIVE IN FRAME fPage0    = NO
       c-sigla:SENSITIVE IN FRAME fPage0        = NO
       c-it-codigo:SCREEN-VALUE IN FRAME fPage0 = p-it-codigo
       c-sigla:SCREEN-VALUE IN FRAME fPage0     = p-sigla.

RUN piCarregaModelo.

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
     LABEL "Capa(pc)"
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
    DO WITH FRAME fPage0:
      //  ASSIGN cb-modelo:SCREEN-VALUE = "1".
        ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0". 
        
        FOR EACH item-mod-etiq NO-LOCK
            WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE:

            cb-modelo:ADD-LAST(string(item-mod-etiq.cod-modelo) , item-mod-etiq.cod-modelo).

        END.

        IF LENGTH(cb-modelo:LIST-ITEM-PAIRS) > 0 THEN DO:
/*
            FOR FIRST item-mod-etiq NO-LOCK
                WHERE item-mod-etiq.it-codigo = c-it-codigo:SCREEN-VALUE
                AND   item-mod-etiq.padrao:
    
                ASSIGN cb-modelo:SCREEN-VALUE = string(item-mod-etiq.cod-modelo).
    
            END.
*/

            RUN esp/es0018p.r (INPUT "ESCPP106A",
                               INPUT 1,
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).
            
            FIND FIRST tt-prog-ponto NO-LOCK.

            IF AVAIL tt-prog-ponto 
            THEN ASSIGN cb-modelo:SCREEN-VALUE = string(tt-prog-ponto.conteudo).

        END.
        ELSE DO:

            ASSIGN cb-modelo:LIST-ITEM-PAIRS = ",0".

            ASSIGN cb-modelo:SCREEN-VALUE = "0".

        END.

      //  APPLY "LEAVE" TO cb-modelo.

        FIND FIRST modelo-etiq WHERE
                   modelo-etiq.cod-modelo = int(cb-modelo:SCREEN-VALUE)
                   NO-LOCK NO-ERROR.

        IF AVAIL modelo-etiq THEN
        ASSIGN c-desc-modelo:SCREEN-VALUE = modelo-etiq.descricao.

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = c-it-codigo:SCREEN-VALUE
                   NO-LOCK NO-ERROR.

        IF AVAIL ITEM THEN
        ASSIGN c-desc-item:SCREEN-VALUE = ITEM.desc-item.
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

    DEFINE VARIABLE i-capacidade AS INTEGER NO-UNDO.

    RUN piValidate.

    IF RETURN-VALUE <> "OK":U THEN
        RETURN "NOK":U.

    IF modelo-etiq.tipo = 8 THEN DO:
        RUN piCapacidade(OUTPUT i-capacidade).
        IF i-capacidade = 0 THEN DO:
            MESSAGE "Etiqueta n∆o gerada."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.
        ASSIGN i-qtd-embalag = i-capacidade.
    END.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
  //  RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

    EMPTY TEMP-TABLE tt-lista-ns.

    FOR FIRST modelo-etiq NO-LOCK
        WHERE modelo-etiq.cod-modelo = INPUT FRAME fPage0 cb-modelo:

        IF modelo-etiq.tipo = 1 THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT "Gerando Etiquetas").

            RUN piGeraNSeMAC IN h-esapi016 (INPUT INPUT FRAME fPage0 c-it-codigo,
                                        INPUT INPUT FRAME fPage0 cb-modelo,
                                        INPUT INPUT FRAME fPage0 c-sigla,
                                        INPUT INPUT FRAME fPage0 i-qtd,
                                        INPUT 0,  /* Motivo Reimpress∆o */
                                        INPUT 0,  /* Pedido de Compra */
                                        INPUT INPUT FRAME fPage0 fiPrinter,
                                        INPUT 1,  /* Geraá∆o e Impress∆o */
                                        INPUT NO,  /* Tratamento ASTEC */
                                        INPUT "",
                                        INPUT "",
                                        OUTPUT TABLE tt-lista-ns).

            IF RETURN-VALUE <> "OK":U THEN DO:

                EMPTY TEMP-TABLE tt-erro.
        
                RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).

                RUN pi-finalizar IN h-acomp.
        
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                DELETE PROCEDURE h-esapi016.
        
                RETURN "NOK":U.
        
            END.
            ELSE DO:

                IF modelo-etiq.usa-kit THEN DO:
                    
                    RUN piGeraKitNS IN h-esapi016(INPUT modelo-etiq.cod-modelo,
                                                  INPUT INPUT FRAME fPage0 c-sigla,
                                                  INPUT TABLE tt-lista-ns).

                END.

            END.

        END.

    END.

    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

    RUN piImpressao IN h-esapi016 (INPUT 0, /* Num PO */
                                   INPUT INPUT FRAME fPage0 c-it-codigo,
                                   INPUT INPUT FRAME fPage0 cb-modelo,
                                   INPUT INPUT FRAME fPage0 c-sigla,
                                   INPUT INPUT FRAME fPage0 i-qtd,
                                   INPUT i-qtd-embalag,
                                   INPUT 0,  /* Motivo Reimpress∆o */
                                   INPUT 0,  /* Pedido de Compra */
                                   INPUT INPUT FRAME fPage0 fiPrinter,
                                   INPUT 4,  /* N∆o valida nada, pois j† foi validado na geraá∆o. */
                                   INPUT NO,
                                   INPUT i-capacidade,
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

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpTeste wWindow 
PROCEDURE piImpTeste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-cod-etiq-teste AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-etiq-teste-pai AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-capacidade     AS INTEGER     NO-UNDO.

RUN piValidate.

IF RETURN-VALUE <> "OK":U THEN
    RETURN "NOK":U.

IF INT(i-qtd:SCREEN-VALUE IN FRAME fpage0) > 10 THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "O Limite de impress∆o para teste Ç de 10 etiquetas.").
    
    RETURN "NOK":U.
END.

IF modelo-etiq.tipo = 8 THEN DO:
    RUN piCapacidade(OUTPUT i-capacidade).    
    IF i-capacidade = 0 THEN DO:
        MESSAGE "Etiqueta n∆o gerada."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.
    ASSIGN i-qtd-embalag = i-capacidade.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

EMPTY TEMP-TABLE tt-lista-ns.

FOR FIRST modelo-etiq NO-LOCK
    WHERE modelo-etiq.cod-modelo = INPUT FRAME fPage0 cb-modelo:

    IF modelo-etiq.tipo = 1 THEN DO:

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando Etiquetas").

        DO i-aux = 1 TO INPUT FRAME fPage0 i-qtd:

            ASSIGN c-cod-etiq-teste = "TESTE" + STRING(MTIME, "99999999").

            CREATE num-serie.
            ASSIGN num-serie.n-serie     = c-cod-etiq-teste                                    
                   num-serie.it-codigo   = INPUT FRAME fPage0 c-it-codigo                           
                   num-serie.ano         = YEAR(TODAY)                                 
                   num-serie.semana      = 99                                 
                   num-serie.sequencia   = TIME                                 
                   num-serie.num-pedido  = 0
                   num-serie.sigla       = CAPS(INPUT FRAME fPage0 c-sigla)
                   num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
                   num-serie.data        = NOW
                   num-serie.usuario     = c-seg-usuario                           
                   num-serie.re-impr     = 0
                   num-serie.dt-ult-re   = ?                                     
                   num-serie.us-ult-re   = ?                                     
                   num-serie.motiv-re    = ?                                      
                   num-serie.ns-keycode  = ""
                .

            CREATE tt-lista-ns.
            ASSIGN tt-lista-ns.num-serie = c-cod-etiq-teste.

            FIND FIRST item-ean WHERE
                       item-ean.it-codigo = INPUT FRAME fPage0 c-it-codigo 
                       NO-LOCK NO-ERROR.
            
            IF AVAIL item-ean AND
                     item-ean.qtd-ns > 1 
            THEN DO:
                ASSIGN c-cod-etiq-teste-pai = c-cod-etiq-teste.
            
                ASSIGN c-cod-etiq-teste = "TEST2" + STRING(MTIME, "99999999").
            
                CREATE num-serie.
                ASSIGN num-serie.n-serie     = c-cod-etiq-teste                                    
                       num-serie.it-codigo   = INPUT FRAME fPage0 c-it-codigo                           
                       num-serie.ano         = YEAR(TODAY)                                 
                       num-serie.semana      = 99                                 
                       num-serie.sequencia   = TIME                                 
                       num-serie.num-pedido  = 0
                       num-serie.sigla       = CAPS(INPUT FRAME fPage0 c-sigla)
                       num-serie.cod-estabel = IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101"
                       num-serie.data        = NOW
                       num-serie.usuario     = c-seg-usuario                           
                       num-serie.re-impr     = 0
                       num-serie.dt-ult-re   = ?                                     
                       num-serie.us-ult-re   = ?                                     
                       num-serie.motiv-re    = ?                                      
                       num-serie.ns-keycode  = ""
                    .
            
                CREATE tt-lista-ns.
                ASSIGN tt-lista-ns.num-serie = c-cod-etiq-teste.
            
                FIND FIRST num-serie-vinc WHERE
                           num-serie-vinc.n-serie      = c-cod-etiq-teste-pai AND
                           num-serie-vinc.n-serie-vinc = c-cod-etiq-teste
                           NO-ERROR.
            
                IF NOT AVAIL num-serie-vinc 
                THEN DO:
                    CREATE num-serie-vinc.
                    ASSIGN num-serie-vinc.n-serie      = c-cod-etiq-teste-pai
                           num-serie-vinc.n-serie-vinc = c-cod-etiq-teste.
            
                    RELEASE num-serie-vinc.
                END.  
            END.

            PAUSE(2).

        END.
    END.
END.

RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

RUN piImpressao IN h-esapi016 (INPUT 0, /* Num PO */
                               INPUT INPUT FRAME fPage0 c-it-codigo,
                               INPUT INPUT FRAME fPage0 cb-modelo,
                               INPUT INPUT FRAME fPage0 c-sigla,
                               INPUT INPUT FRAME fPage0 i-qtd,
                               INPUT i-qtd-embalag,
                               INPUT 0,  /* Motivo Reimpress∆o */
                               INPUT 0,  /* Pedido de Compra */
                               INPUT INPUT FRAME fPage0 fiPrinter,
                               INPUT 4,  /* N∆o valida nada, pois j† foi validado na geraá∆o. */
                               INPUT NO,
                               INPUT i-capacidade,
                               INPUT TABLE tt-lista-ns).

IF RETURN-VALUE <> "OK":U THEN DO:

    EMPTY TEMP-TABLE tt-erro.

    RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).

    RUN pi-finalizar IN h-acomp.

    RUN cdp/cd0666.w (INPUT TABLE tt-erro).

    DELETE PROCEDURE h-esapi016.

    FOR EACH tt-lista-ns:

        FOR FIRST num-serie EXCLUSIVE-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:

            DELETE num-serie.

        END.

    END.

    RETURN "NOK":U.

END.

RUN pi-finalizar IN h-acomp.

DELETE PROCEDURE h-esapi016.

FOR EACH tt-lista-ns:

    FOR FIRST num-serie EXCLUSIVE-LOCK
        WHERE num-serie.n-serie = tt-lista-ns.num-serie:

        FOR EACH num-serie-vinc WHERE
                 num-serie-vinc.n-serie = tt-lista-ns.num-serie
                 EXCLUSIVE-LOCK:

            DELETE num-serie-vinc.
        END.
        DELETE num-serie.

    END.

END.

RETURN "OK":U.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate wWindow 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-acesso      AS LOGICAL     NO-UNDO.
ASSIGN c-cod-estabel = v_cod_estab_usuar.

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
        END.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

