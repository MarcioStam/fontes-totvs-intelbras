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
{include/i-prgvrs.i ESCPP097 2.00.00.000}
{include/i-license-manager.i ESCPP097 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP097
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 c-it-codigo fi-etiqueta~
                              btConfigImpr btReimprimir btPO
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
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER NO-UNDO.

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEF VAR c-ID        AS CHAR FORMAT "x(9)"  NO-UNDO.
DEF VAR c-Ch-Acesso AS CHAR FORMAT "x(06)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOk c-it-codigo btConfigImpr fi-etiqueta ~
btCancel btQueryJoins btReportsJoins btExit fiPrinter c-desc-item btHelp ~
btHelp2 btReimprimir btPO rtToolBar-2 rtToolBar RECT-1 RECT-2 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo fi-etiqueta fiPrinter ~
c-desc-item 

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

DEFINE BUTTON btOk  NO-FOCUS
     LABEL "OK" 
     SIZE 11 BY 1.

DEFINE BUTTON btPO 
     IMAGE-UP FILE "image\ii-barras":U
     LABEL "Imp. PO" 
     SIZE 4 BY 1.25 TOOLTIP "Imprime Etiqueta PO".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReimprimir 
     IMAGE-UP FILE "image\im-repr2":U
     IMAGE-INSENSITIVE FILE "image\ii-repr2":U
     LABEL "Reimprimir" 
     SIZE 4 BY 1.25 TOOLTIP "Reimprimir Etiqueta".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 47 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .79 TOOLTIP "Bipar QRCode" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 2.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOk AT ROW 12.96 COL 1.86 WIDGET-ID 52 NO-TAB-STOP 
     c-it-codigo AT ROW 3.25 COL 14.14 COLON-ALIGNED WIDGET-ID 4
     btConfigImpr AT ROW 5.79 COL 63.29 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     fi-etiqueta AT ROW 8.75 COL 14.14 COLON-ALIGNED WIDGET-ID 44
     btCancel AT ROW 12.96 COL 68 WIDGET-ID 50
     btQueryJoins AT ROW 1.13 COL 66.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 70.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 74.29 HELP
          "Sair"
     fiPrinter AT ROW 5.88 COL 16.14 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     c-desc-item AT ROW 3.25 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12 NO-TAB-STOP 
     btHelp AT ROW 1.13 COL 62.14 HELP
          "Ajuda"
     btHelp2 AT ROW 12.96 COL 68
     btReimprimir AT ROW 1.13 COL 1.57 HELP
          "Reimprimir Etiqueta" WIDGET-ID 54
     btPO AT ROW 1.13 COL 5.72 HELP
          "Reimprimir Etiqueta" WIDGET-ID 56
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 6 COL 8 WIDGET-ID 26
          FONT 1
     "QRCode Etiqueta:" VIEW-AS TEXT
          SIZE 12.72 BY .54 AT ROW 8.83 COL 3.43 WIDGET-ID 46
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 12.75 COL 1
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 2
     RECT-2 AT ROW 5.25 COL 2 WIDGET-ID 18
     RECT-4 AT ROW 8.04 COL 2 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.43 BY 13.29
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
         HEIGHT             = 13.29
         WIDTH              = 79
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
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
       btHelp:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btHelp2:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btOk:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btQueryJoins:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btReportsJoins:HIDDEN IN FRAME fpage0           = TRUE.

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


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wWindow
ON CHOOSE OF btOk IN FRAME fpage0 /* OK */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPO wWindow
ON CHOOSE OF btPO IN FRAME fpage0 /* Imp. PO */
/*&WINDOW-NAME}:SENSITIVE = NO.*/
  RUN esp/cpp/escpp097b.w.

/*{&WINDOW-NAME}:SENSITIVE = YES.*/

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


&Scoped-define SELF-NAME btReimprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimprimir wWindow
ON CHOOSE OF btReimprimir IN FRAME fpage0 /* Reimprimir */
DO:
/*&WINDOW-NAME}:SENSITIVE = NO.*/
    /* Valida permiss∆o para reimprimir */
    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.
    RUN esp\es0018p.p (INPUT "escpp097",   /* Nome do programa */
                       INPUT 2,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.

    IF NOT AVAIL tt-prog-ponto THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Usu†rio sem permiss∆o para reimprimir." + "~~" + 
                                 "Usu†rio logado no sistema n∆o tem permiss∆o para reimprimir etiqueta.").
        
        RETURN "NOK":U.
    END.  

    RUN esp/cpp/escpp097a.w.
/*{&WINDOW-NAME}:SENSITIVE = YES.*/

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


&Scoped-define SELF-NAME fi-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON RETURN OF fi-etiqueta IN FRAME fpage0
DO:
    ASSIGN v_nom_disposit_so = "".

    RUN piValidate.

    IF RETURN-VALUE <> "OK":U THEN
        RETURN NO-APPLY.

    RUN piImpressao.
    ASSIGN fi-etiqueta:SCREEN-VALUE IN FRAME fpage0 = "".
    APPLY "entry" TO fi-etiqueta IN FRAME fpage0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao wWindow 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEFINE VARIABLE h-acomp        AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-capacidade   AS INTEGER NO-UNDO.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").
    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

    EMPTY TEMP-TABLE tt-lista-ns.

    RUN pi-acompanhar IN h-acomp (INPUT "Gerando Etiqueta...").

    FOR FIRST modelo-etiq NO-LOCK
        WHERE modelo-etiq.cod-modelo = 999:

        IF modelo-etiq.tipo = 1 THEN DO:
            RUN piGeraNS IN h-esapi016 (INPUT INPUT FRAME fPage0 c-it-codigo,
                                        INPUT "999",                          /*INPUT FRAME fPage0 cb-modelo*/
                                        INPUT "",                             /*INPUT FRAME fPage0 c-sigla*/
                                        INPUT 1,                              /*INPUT FRAME fPage0 i-qtd*/
                                        INPUT 0,                              /* Motivo Reimpress∆o */
                                        INPUT 0,                              /* Pedido de Compra */
                                        INPUT INPUT FRAME fPage0 fiPrinter,   /* Nome Impressora */
                                        INPUT 1,                              /* gera e imprime */
                                        INPUT NO,                             /* Tratamento ASTEC */
                                        INPUT caps(c-ID),                     /* ID q vai na etiqueta(9 d°gitos) */
                                        INPUT caps(c-Ch-Acesso),              /* Chave de acesso que vai na etiqueta (6 caracteres) */  
                                        OUTPUT TABLE tt-lista-ns).
        
            IF RETURN-VALUE <> "OK":U THEN DO:
                EMPTY TEMP-TABLE tt-erro.
                RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
                RUN pi-finalizar IN h-acomp.
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                DELETE PROCEDURE h-esapi016.
                RETURN "NOK":U.
            END.
        END.
    END.

    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").
    
    RUN piImprimeEscpp097 IN h-esapi016 (INPUT INPUT FRAME fPage0 c-it-codigo,
                                         "999",     /* MODELO */
                                         "",        /* SIGLA*/  
                                         01,        /* Quantidade Etiquetas */    
                                         00,        /* Quantidade Embalagens */               
                                        INPUT 0,    /* Motivo Reimpress∆o */
                                        INPUT 0,    /* Pedido de Compra */
                                        INPUT INPUT FRAME fPage0 fiPrinter, /* Nome Impressora */
                                        INPUT 4,    /* N∆o valida nada, pois j† foi validado na geraá∆o. */
                                        INPUT  NO , /*INPUT FRAME fPage0 tg-astec*/
                                        INPUT  00,  /*i-capacidade*/
                                        INPUT caps(c-ID),
                                        INPUT caps(c-Ch-Acesso),
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

    DEF VAR i                  AS INTEGER NO-UNDO.
    DEF VAR l-erro             AS LOGICAL NO-UNDO.
    DEF VAR i-num-char-hibrido AS INTEGER NO-UNDO.
    /******************************** Validar Item ***********************************/
    IF  NOT CAN-FIND(FIRST ITEM 
                        WHERE item.it-codigo = c-it-codigo:SCREEN-VALUE IN FRAM fpage0)
    OR  trim(c-it-codigo:SCREEN-VALUE IN FRAM fpage0) = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Item informado Ç inv†lido.").
        RETURN "NOK".
    END.

    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "escpp097"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN i-num-char-hibrido = int(conteudo-programa.conteudo).
    END.

    /*-----------*/
    /* Valida ID */
    /*-----------*/
    ASSIGN l-erro = NO.
    ASSIGN c-ID = substr(fi-etiqueta:SCREEN-VALUE IN FRAME fpage0, 1,9).
    DO  i = (i-num-char-hibrido + 1) TO 9:
        IF  SUBSTR(c-ID, i, 1) < "0" OR SUBSTR(c-ID, i, 1) > "9"  THEN
            l-erro = YES.
    END.

    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Etiqueta Inv†lida -> ID incorreto.~~O ID deve conter apenas n£meros e a Chave de Acesso apenas letras").
        RETURN "NOK".
    END.

    /*------------------*/
    /* Valida ch-acesso */
    /*------------------*/
    ASSIGN l-erro = NO.
    ASSIGN c-Ch-Acesso = substr(fi-etiqueta:SCREEN-VALUE IN FRAME fpage0, 10, 6).
    DO  i = 1 TO 6:
        IF  SUBSTR(c-Ch-Acesso, i, 1) < "A" OR SUBSTR(c-Ch-Acesso, i, 1) > "Z"  THEN
            l-erro = YES.
    END.

    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Etiqueta Inv†lida -> Chave Acesso incorreta.~~O ID deve conter apenas n£meros e a Chave de Acesso apenas letras").
        RETURN "NOK".
    END.

    FIND FIRST num-serie NO-LOCK
        WHERE num-serie.ID = c-ID
          AND num-serie.ch-acesso = c-ch-acesso NO-ERROR.

    IF  AVAIL num-serie THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "QR Code informado j† foi impresso anteriormente.~~Utilize a opá∆o 'Reimpress∆o'.").
        RETURN "NOK".
    END.

    FIND FIRST mac-address WHERE
               mac-address.id        = c-ID AND
               mac-address.ch-acesso = c-ch-acesso
               NO-LOCK NO-ERROR.

    IF NOT AVAIL mac-address THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "QR Code informado n∆o vinculado a nenhum Mac-address.~~Verifique se o ID e Chave de Acesso do QR Code est∆o vinculados a um MAC, caso n∆o, devem importar no programa ESCPP102.").
        RETURN "NOK".
    END.
    
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

