&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
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
{include/i-prgvrs.i ESENP018 2.00.00.000}
/*------------------------------------------------------------------------
    File        : ESENP018.p
    Purpose     : Buscar o peso do item pela sua estrutura e sugerir ao
                  usu†rio, para que decida por alterar ou n∆o e efetiva no
                  registro do item.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Janeiro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP018
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp fiItCodigo btBuscaPeso fiPesoLiquido fiPesoBruto btEfetivar btCancelar

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE vPesoLiquido LIKE item.peso-liquido NO-UNDO.
DEFINE VARIABLE vPesoBruto   LIKE item.peso-bruto   NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE              NO-UNDO.
DEFINE VARIABLE hAcomp       AS HANDLE              NO-UNDO.

/* New Global Shared Variable Definitions ---                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiItCodigo btBuscaPeso fiPesoLiquido ~
fiPesoBruto fiDescItem btEfetivar btCancelar btQueryJoins btReportsJoins ~
btExit btHelp rtToolBar-2 rtItem rtPeso 
&Scoped-Define DISPLAYED-OBJECTS fiItCodigo fiPesoLiquido fiPesoBruto ~
fiDescItem 

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
DEFINE BUTTON btBuscaPeso 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "Busca Peso Item" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancelar 
     IMAGE-UP FILE "image/im-can.bmp":U
     LABEL "Cancelar" 
     SIZE 4 BY 1.

DEFINE BUTTON btEfetivar 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "Efetivar" 
     SIZE 4 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-exi.bmp":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-hel.bmp":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-joi.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-pri.bmp":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiDescItem LIKE item.desc-item
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigo LIKE item.it-codigo
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiPesoBruto LIKE item.peso-bruto
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiPesoLiquido LIKE item.peso-liquido
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtItem
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.58.

DEFINE RECTANGLE rtPeso
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.42.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiItCodigo AT ROW 3.08 COL 5 COLON-ALIGNED HELP
          "C¢digo do Item"
     btBuscaPeso AT ROW 3 COL 64.72 HELP
          "Busca Peso Item"
     fiPesoLiquido AT ROW 5.17 COL 14.86 COLON-ALIGNED HELP
          "Peso l°quido do item"
     fiPesoBruto AT ROW 5.17 COL 37 COLON-ALIGNED HELP
          "Peso Bruto Unit†rio do Item"
     fiDescItem AT ROW 3.08 COL 18.14 COLON-ALIGNED HELP
          "" NO-LABEL NO-TAB-STOP 
     btEfetivar AT ROW 5.13 COL 60.43 HELP
          "Efetivar"
     btCancelar AT ROW 5.13 COL 64.57 HELP
          "Cancelar"
     btQueryJoins AT ROW 1.13 COL 54.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 58.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 62.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 66.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtItem AT ROW 2.71 COL 2
     rtPeso AT ROW 4.46 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70 BY 6
         FONT 1.


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
         HEIGHT             = 6
         WIDTH              = 70
         MAX-HEIGHT         = 6
         MAX-WIDTH          = 70
         VIRTUAL-HEIGHT     = 6
         VIRTUAL-WIDTH      = 70
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
/* SETTINGS FOR FILL-IN fiDescItem IN FRAME fpage0
   LIKE = mgcad.item.desc-item EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN fiItCodigo IN FRAME fpage0
   LIKE = mgcad.item.it-codigo EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN fiPesoBruto IN FRAME fpage0
   LIKE = mgcad.item.peso-bruto EXP-SIZE                                */
/* SETTINGS FOR FILL-IN fiPesoLiquido IN FRAME fpage0
   LIKE = mgcad.item.peso-liquido EXP-SIZE                              */
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


&Scoped-define SELF-NAME btBuscaPeso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBuscaPeso wWindow
ON CHOOSE OF btBuscaPeso IN FRAME fpage0 /* Busca Peso Item */
DO:
    RUN piBuscaPeso IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelar wWindow
ON CHOOSE OF btCancelar IN FRAME fpage0 /* Cancelar */
DO:
    RUN piCancelar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEfetivar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEfetivar wWindow
ON CHOOSE OF btEfetivar IN FRAME fpage0 /* Efetivar */
DO:
    RUN piEfetivar IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME fiItCodigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON F5 OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo="fiItCodigo"
                       &campozoom="it-codigo"
                       &frame="fPage0"}

    IF VALID-HANDLE(wh-pesquisa) THEN DO:
        WAIT-FOR CLOSE OF wh-pesquisa.

        APPLY "LEAVE":U TO SELF.
        APPLY "ENTRY":U TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON LEAVE OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    ASSIGN INPUT FRAME fPage0 fiItCodigo.

    FIND FIRST item
        WHERE item.it-codigo = fiItCodigo NO-LOCK NO-ERROR.

    ASSIGN fiDescItem = IF AVAILABLE item THEN item.desc-item ELSE "":U.

    DISPLAY fiDescItem
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON RETURN OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    APPLY "LEAVE":U TO SELF.
    APPLY "CHOOSE":U TO btBuscaPeso IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPesoBruto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPesoBruto wWindow
ON END-ERROR OF fiPesoBruto IN FRAME fpage0 /* Peso Bruto */
DO:
    APPLY "CHOOSE":U TO btCancelar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPesoBruto wWindow
ON RETURN OF fiPesoBruto IN FRAME fpage0 /* Peso Bruto */
DO:
    APPLY "CHOOSE":U TO btEfetivar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPesoLiquido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPesoLiquido wWindow
ON END-ERROR OF fiPesoLiquido IN FRAME fpage0 /* Peso Liq */
DO:
    APPLY "CHOOSE":U TO btCancelar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPesoLiquido wWindow
ON RETURN OF fiPesoLiquido IN FRAME fpage0 /* Peso Liq */
DO:
    APPLY "CHOOSE":U TO btEfetivar IN FRAME fPage0.
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

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fiItCodigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializando o programa.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    APPLY "CHOOSE":U TO btCancelar IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaPeso wWindow 
PROCEDURE piBuscaPeso :
/*------------------------------------------------------------------------------
  Purpose:     Buscar o peso do item atravÇs de sua estrutura.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0 fiItCodigo.

    FIND FIRST item
        WHERE item.it-codigo = fiItcodigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Item":U).

        APPLY "ENTRY":U TO fiItCodigo IN FRAME fPage0.

        RETURN NO-APPLY.
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Buscando Pesos da Estrutura":U).

    ASSIGN vPesoLiquido = 0
           vPesoBruto   = 0.

    RUN piEstrutura IN THIS-PROCEDURE (INPUT item.it-codigo,
                                       INPUT hAcomp).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    ASSIGN fiPesoLiquido = vPesoLiquido
           fiPesoBruto   = vPesoBruto
           vPesoLiquido  = 0
           vPesoBruto    = 0.

    DISPLAY fiPesoBruto
            fiPesoLiquido
        WITH FRAME fPage0.

    /*ENABLE fiPesoBruto
           fiPesoLiquido
           btEfetivar
           btCancelar
        WITH FRAME fPage0.

    DISABLE fiItCodigo
            btBuscaPeso
        WITH FRAME fPage0.*/

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    ASSIGN hAcomp = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCancelar wWindow 
PROCEDURE piCancelar :
/*------------------------------------------------------------------------------
  Purpose:     Cancelar a alteraá∆o do peso do item.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN /*fiItCodigo    = "":U*/
           fiPesoBruto   = 0
           fiPesoLiquido = 0.

    DISPLAY fiItCodigo
            fiPesoBruto
            fiPesoLiquido
        WITH FRAME fPage0.

    ENABLE fiItCodigo
           btBuscaPeso
        WITH FRAME fPage0.

    DISABLE fiPesoBruto
            fiPesoLiquido
            btEfetivar
            btCancelar
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO fiItCodigo IN FRAME fPage0.
    APPLY "ENTRY":U TO fiItCodigo IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEfetivar wWindow 
PROCEDURE piEfetivar :
/*------------------------------------------------------------------------------
  Purpose:     Efetivar a aplicaá∆o do valor do peso.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0 fiItCodigo
           INPUT FRAME fPage0 fiPesoBruto
           INPUT FRAME fPage0 fiPesoLiquido.

    FIND FIRST item
        WHERE item.it-codigo = fiItCodigo EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE item THEN
        ASSIGN item.peso-bruto   = fiPesoBruto
               item.peso-liquido = fiPesoLiquido.

    RUN piCancelar IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEstrutura wWindow 
PROCEDURE piEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     Navega pela estrutura do item para buscar o peso.
  Parameters:  pItCodigo (LIKE item.it-codigo), hAcomp (HANDLE).
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pItCodigo LIKE item.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER hAcomp    AS HANDLE           NO-UNDO.

    DEFINE VARIABLE vQuantUsada  LIKE estrutura.quant-usada  NO-UNDO.
    DEFINE VARIABLE vQuantLiquid LIKE estrutura.quant-liquid NO-UNDO.

    RUN esp/enp/esenp018a.p (INPUT pItCodigo,
                             INPUT-OUTPUT vPesoLiquido,
                             INPUT-OUTPUT vPesoBruto,
                             INPUT hAcomp).

    /* Caso n∆o encontre ESTRUTURA abaixo do item atual, busca o peso e grava na vari†vel */
    IF RETURN-VALUE = "NOK":U THEN DO:
        FIND FIRST item
            WHERE item.it-codigo = pItCodigo NO-LOCK NO-ERROR.

        ASSIGN vPesoLiquido = IF AVAILABLE item THEN item.peso-liquido ELSE 0
               vPesoBruto   = IF AVAILABLE item THEN item.peso-bruto   ELSE 0.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

