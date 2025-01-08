&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-matriz-rat-ordem NO-UNDO LIKE matriz-rat-ordem
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
       FIELD it-codigo-novo LIKE item.it-codigo
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp035 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp035
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets    fiNumPedido btLocalizar btQueryJoins btReportsJoins btExit btHelp

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiNumPedido fiDataPedido fiCodEmitente ~
fiNomeAbrev btLocalizar fiCgc btQueryJoins cbNatureza btReportsJoins ~
fiCodEstabel btExit cbSituacao btHelp fiTpPedido rtToolBar-2 rtPedido 
&Scoped-Define DISPLAYED-OBJECTS fiNumPedido fiDataPedido fiCodEmitente ~
fiNomeAbrev fiCgc cbNatureza fiCodEstabel cbSituacao fiTpPedido 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miLocalizarOrdens LABEL "&Localizar Ordens"
       RULE
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

DEFINE BUTTON btLocalizar 
     IMAGE-UP FILE "image\im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav.bmp":U
     LABEL "&Localizar" 
     SIZE 4 BY 1.

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

DEFINE VARIABLE cbNatureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.57 BY 1 NO-UNDO.

DEFINE VARIABLE cbSituacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.29 BY 1 NO-UNDO.

DEFINE VARIABLE fiCgc LIKE emitente.cgc
     VIEW-AS FILL-IN 
     SIZE 17.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEmitente LIKE pedido-compr.cod-emitente
     LABEL "Fornecedor":R12 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .83 NO-UNDO.

DEFINE VARIABLE fiDataPedido LIKE pedido-compr.data-pedido
     LABEL "Data Pedido":R14 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeAbrev LIKE emitente.nome-abrev
     VIEW-AS FILL-IN 
     SIZE 36.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiNumPedido LIKE pedido-compr.num-pedido
     LABEL "Pedido Compra" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiTpPedido AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 26 BY .88 NO-UNDO.

DEFINE RECTANGLE rtPedido
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiNumPedido AT ROW 2.83 COL 16 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra"
          LABEL "Pedido Compra"
     fiDataPedido AT ROW 2.83 COL 63 COLON-ALIGNED HELP
          "Data Pedido Compra"
          LABEL "Data Pedido":R14 NO-TAB-STOP 
     fiCodEmitente AT ROW 3.83 COL 16 COLON-ALIGNED HELP
          "Fornecedor"
          LABEL "Fornecedor":R12 NO-TAB-STOP 
     fiNomeAbrev AT ROW 3.83 COL 26.29 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL NO-TAB-STOP 
     btLocalizar AT ROW 4.75 COL 86.43 HELP
          "Localizar Ordens"
     fiCgc AT ROW 3.83 COL 63 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor" NO-LABEL NO-TAB-STOP 
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     cbNatureza AT ROW 4.83 COL 16 COLON-ALIGNED NO-TAB-STOP 
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     fiCodEstabel AT ROW 4.83 COL 41.72 COLON-ALIGNED NO-TAB-STOP 
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     cbSituacao AT ROW 4.83 COL 63 COLON-ALIGNED NO-TAB-STOP 
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fiTpPedido AT ROW 2.83 COL 26.72 COLON-ALIGNED NO-LABEL
     rtToolBar-2 AT ROW 1 COL 1
     rtPedido AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 5.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-matriz-rat-ordem T "?" NO-UNDO mgmov matriz-rat-ordem
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-ordem-compra T "?" NO-UNDO mgmov ordem-compra
      ADDITIONAL-FIELDS:
          FIELD it-codigo-novo LIKE item.it-codigo
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 5.21
         WIDTH              = 90
         MAX-HEIGHT         = 5.21
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 5.21
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
/* SETTINGS FOR FILL-IN fiCgc IN FRAME fpage0
   LIKE = mgcad.emitente.cgc EXP-LABEL EXP-HELP EXP-SIZE               */
/* SETTINGS FOR FILL-IN fiCodEmitente IN FRAME fpage0
   LIKE = mgmov.pedido-compr.cod-emitente EXP-LABEL EXP-HELP EXP-SIZE  */
/* SETTINGS FOR FILL-IN fiDataPedido IN FRAME fpage0
   LIKE = mgmov.pedido-compr.data-pedido EXP-LABEL EXP-HELP EXP-SIZE   */
/* SETTINGS FOR FILL-IN fiNomeAbrev IN FRAME fpage0
   LIKE = mgcad.emitente.nome-abrev EXP-LABEL EXP-HELP EXP-SIZE        */
/* SETTINGS FOR FILL-IN fiNumPedido IN FRAME fpage0
   LIKE = mgmov.pedido-compr.num-pedido EXP-LABEL EXP-HELP EXP-SIZE    */
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


&Scoped-define SELF-NAME btLocalizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLocalizar wWindow
ON CHOOSE OF btLocalizar IN FRAME fpage0 /* Localizar */
OR CHOOSE OF MENU-ITEM miLocalizarOrdens IN MENU mbMain DO:
    APPLY "LEAVE":U TO fiNumPedido     IN FRAME fPage0.

    RUN piPedidoCompra IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
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


&Scoped-define SELF-NAME fiNumPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNumPedido wWindow
ON F5 OF fiNumPedido IN FRAME fpage0 /* Pedido Compra */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z11in295.w"
                         &FieldZoom1="num-pedido"
                         &FieldScreen1="fiNumPedido"
                         &Frame1="fPage0"
                         &EnableImplant="YES"}

    WAIT-FOR CLOSE OF hProgramZoom.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNumPedido wWindow
ON LEAVE OF fiNumPedido IN FRAME fpage0 /* Pedido Compra */
DO:
    ASSIGN INPUT FRAME fPage0 fiNumPedido.

    FIND FIRST pedido-compr
        WHERE pedido-compr.num-pedido = fiNumPedido NO-LOCK NO-ERROR.

    IF AVAILABLE pedido-compr THEN DO:
        ASSIGN fiDataPedido  = pedido-compr.data-pedido
               fiCodEmitente = pedido-compr.cod-emitente
               cbNatureza    = {ininc/i01in295.i 04 pedido-compr.natureza}
               fiCodEstabel  = pedido-compr.end-entrega.
               cbSituacao    = {ininc/i02in295.i 04 pedido-compr.situacao}.
            
        FIND FIRST int-pedido-compr
            WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.

        IF AVAILABLE int-pedido-compr THEN DO:
            CASE int-pedido-compr.tp-pedido:
                WHEN 1 THEN
                    ASSIGN fiTpPedido = "PEDIDO AMOSTRA":U.
                WHEN 2 THEN
                    ASSIGN fiTpPedido = "PEDIDO AUTOMµTICO":U.
                WHEN 3 THEN
                    ASSIGN fiTpPedido = "PEDIDO COMUM":U.
                WHEN 4 THEN
                    ASSIGN fiTpPedido = "PEDIDO HOMOLOGA€ÇO":U.
                WHEN 5 THEN
                    ASSIGN fiTpPedido = "PEDIDO INDEPENDENTE":U.
                WHEN 6 THEN
                    ASSIGN fiTpPedido = "PEDIDO RESSARCIMENTO":U.
                WHEN 7 THEN
                    ASSIGN fiTpPedido = "PEDIDO SPOT":U.
                WHEN 8 THEN
                    ASSIGN fiTpPedido = "PEDIDO TROCA DE MODAL":U.
                WHEN 9 THEN
                    ASSIGN fiTpPedido = "PARA MANAUS":U.
                OTHERWISE
                    ASSIGN fiTpPedido = "PEDIDO COMUM":U.
            END CASE.
        END.
        ELSE
            ASSIGN fiTpPedido = "":U.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = fiCodEmitente NO-LOCK NO-ERROR.

        IF AVAILABLE emitente THEN
            ASSIGN fiNomeAbrev = emitente.nome-abrev
                   fiCgc       = emitente.cgc.
        ELSE
            ASSIGN fiNomeAbrev = "":U
                   fiCgc       = "":U.
    END.
    ELSE
        ASSIGN fiTpPedido    = "":U
               fiDataPedido  = ?
               fiCodEmitente = 0
               fiNomeAbrev   = "":U
               fiCgc         = "":U
               cbNatureza    = {ininc/i01in295.i 04 1}
               fiCodEstabel  = "":U
               cbSituacao    = {ininc/i02in295.i 04 1}.

    DISPLAY fiTpPedido
            fiDataPedido
            fiCodEmitente
            fiNomeAbrev
            fiCgc
            cbNatureza
            fiCodEstabel
            cbSituacao
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNumPedido wWindow
ON MOUSE-SELECT-DBLCLICK OF fiNumPedido IN FRAME fpage0 /* Pedido Compra */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNumPedido wWindow
ON RETURN OF fiNumPedido IN FRAME fpage0 /* Pedido Compra */
DO:
    APPLY "CHOOSE":U TO btLocalizar IN FRAME fPage0.
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

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fiNumPedido:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
    ASSIGN fiNumPedido   = 0
           fiDataPedido  = ?
           fiCodEmitente = 0
           cbNatureza    = {ininc/i01in295.i 04 1}
           fiCodEstabel  = "":U
           cbSituacao    = {ininc/i02in295.i 04 1}.

    DISPLAY fiNumPedido
            fiDataPedido
            fiCodEmitente
            cbNatureza
            fiCodEstabel
            cbSituacao
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cbNatureza:LIST-ITEMS IN FRAME fPage0 = {ininc/i01in295.i 03}
           cbSituacao:LIST-ITEMS IN FRAME fPage0 = {ininc/i02in295.i 03}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedidoCompra wWindow 
PROCEDURE piPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0 fiNumPedido.

    FIND FIRST pedido-compr
        WHERE pedido-compr.num-pedido = fiNumPedido NO-LOCK NO-ERROR.

    IF NOT AVAILABLE pedido-compr THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Pedido Compra":U).

        APPLY "ENTRY":U TO fiNumPedido IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF pedido-compr.i-situacao > 1 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Pedido j  atendido!":U +
                                 "~~":U +
                                 "Pedido ~"":U + TRIM(STRING(pedido-compr.num-pedido)) + "~" j  atendido.":U).

        APPLY "ENTRY":U TO fiNumPedido IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF pedido-comp.situacao = 3 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Pedido com situa‡Æo ~"Eliminado~".":U +
                                 "~~":U +
                                 "Pedido ~"":U + TRIM(STRING(pedido-compr.num-pedido)) + "~" est  com situa‡Æo de ~"Eliminado~".":U).

        APPLY "ENTRY":U TO fiNumPedido IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST ordem-compra NO-LOCK
                    WHERE ordem-compra.num-pedido = pedido-compr.num-pedido) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Ordem Compra":U).

        APPLY "ENTRY":U TO fiNumPedido IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN esp/ccp/esccp035a.w (INPUT pedido-compr.num-pedido).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    APPLY "ENTRY":U TO fiNumPedido IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

