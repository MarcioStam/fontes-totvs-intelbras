&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-mat NO-UNDO LIKE item-mat
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP075 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP075
&GLOBAL-DEFINE Version        2.04.00.002

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-item
&GLOBAL-DEFINE hDBOTable      htt-item
&GLOBAL-DEFINE DBOTable       htt-item

&GLOBAL-DEFINE page0KeyFields   tt-item.it-codigo
&GLOBAL-DEFINE page0Fields      tt-item.it-codigo tt-item-mat.cod-ean

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-updating AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-libera   AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE c-item     LIKE item.it-codigo NO-UNDO.
DEFINE VARIABLE c-ean13    AS CHARACTER   NO-UNDO FORMAT "x(13)":U.

DEFINE VARIABLE v-des-unid-negoc LIKE unid-negoc.des-unid-negoc NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin684    AS HANDLE      NO-UNDO.

{upc/btb910za-upc.i} /* Definiá∆o do estabelecimento do usu†rio */

DEFINE VARIABLE c-prefixoEAN-aux AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-boin667 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-prefixo-ean AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item.it-codigo tt-item-mat.cod-ean 
&Scoped-define ENABLED-TABLES tt-item tt-item-mat
&Scoped-define FIRST-ENABLED-TABLE tt-item
&Scoped-define SECOND-ENABLED-TABLE tt-item-mat
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-6 btFirst btPrev ~
btNext btLast btGoTo btSearch btUpdate btUndo btCancel btSave btLista ~
btQueryJoins btReportsJoins btExit btHelp bt-ean 
&Scoped-Define DISPLAYED-FIELDS tt-item.it-codigo tt-item.desc-item ~
tt-item-mat.cod-ean 
&Scoped-define DISPLAYED-TABLES tt-item tt-item-mat
&Scoped-define FIRST-DISPLAYED-TABLE tt-item
&Scoped-define SECOND-DISPLAYED-TABLE tt-item-mat


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-item.it-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBloqueia wMaintenance 
FUNCTION fnBloqueia RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesUnidNegoc wMaintenance 
FUNCTION fnDesUnidNegoc RETURNS CHARACTER
  ( p-cod-unid-negoc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ean 
     LABEL "Calcular EAN-13 ..." 
     SIZE 15 BY 1.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLista 
     IMAGE-UP FILE "image/im-det.bmp":U
     LABEL "List" 
     SIZE 4 BY 1.25 TOOLTIP "Listagem dos c¢digos EAN"
     FONT 4.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btLista AT ROW 1.13 COL 60 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-item.it-codigo AT ROW 3 COL 17.43 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-item.desc-item AT ROW 3 COL 30.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 45.57 BY .88
     tt-item-mat.cod-ean AT ROW 4.75 COL 28 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     bt-ean AT ROW 4.75 COL 47 WIDGET-ID 2
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-6 AT ROW 4.5 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.42
         FONT 1.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 80 ROW 4.75
         SIZE 8.43 BY .79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-item T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-mat T "?" NO-UNDO mgcad item-mat
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.29
         WIDTH              = 90
         MAX-HEIGHT         = 28.46
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.46
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-item.desc-item IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-item.it-codigo IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */

  IF tt-item-mat.cod-ean:SENSITIVE IN FRAME fpage0 THEN DO:
      MESSAGE "Alteraá∆o ainda nao foi salva" SKIP(1) 
              "Realmente deseja fechar o programa sem salvar ??" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-fechar-prog AS LOGICAL.
       
      IF NOT l-fechar-prog THEN
         RETURN NO-APPLY.
  END.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ean
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ean wMaintenance
ON CHOOSE OF bt-ean IN FRAME fpage0 /* Calcular EAN-13 ... */
DO:

    RUN piCalculaEAN.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:

    MESSAGE "Deseja mesmo cancelar a alteraá∆o do cadastro ??"  SKIP(1)
            "Caso escolha 'SIM' as alteracá‰es 'NAO SER«O SALVAS'"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-fechar-prog AS LOGICAL.

    IF NOT l-fechar-prog THEN
       RETURN NO-APPLY.

    RUN cancelRecord IN THIS-PROCEDURE.
    bt-ean:sensitive in frame fPage0 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLista wMaintenance
ON CHOOSE OF btLista IN FRAME fpage0 /* List */
DO:
  RUN esp/cpp/escpp020a.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
    fnBloqueia().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK" THEN
        RUN piGravaWMS.

    bt-ean:sensitive in frame fPage0 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="inzoom/z22in172.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    l-updating = YES.
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


tt-item.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterControlToolBar wMaintenance 
PROCEDURE afterControlToolBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    fnBloqueia().

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-boin667) then
        delete procedure h-boin667.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-qtd-linha AS INTEGER     NO-UNDO.

    
    
    ENABLE btLista WITH FRAME fpage0.

    



    /*
    RUN setConstraintRangeItemEstab IN h-boin684 (INPUT INPUT FRAME fPage0 ttitem-ean.it-codigo,
                                                  INPUT INPUT FRAME fPage0 ttitem-ean.it-codigo,
                                                  INPUT "":U,
                                                  INPUT "ZZZ":U) NO-ERROR.

    RUN openQueryStatic IN h-boin684 (INPUT "RangeItemEstab":U) NO-ERROR.

    RUN getBatchRecords IN h-boin684 (INPUT  ?,
                                      INPUT  ?,
                                      INPUT  ?,
                                      OUTPUT v-qtd-linha,
                                      OUTPUT TABLE ttitem-uni-estab).

    {&OPEN-QUERY-brUnidNegoc}
    */

    DISP tt-item.desc-item with FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  l-updating THEN DO:
        DISABLE {&List-1} WITH FRAME fpage0.
        /*run setFolder IN hFolder (input 1).*/
        APPLY "entry" TO tt-item-mat.cod-ean IN FRAME fpage0.
    END. /* IF  l-updating THEN */
    ASSIGN l-updating = NO.

    IF  cAction = "ADD" 
    OR  cAction = "COPY" 
    OR  tt-item-mat.cod-ean:SCREEN-VALUE IN FRAME fPage0 = "" 
    THEN ASSIGN bt-ean:SENSITIVE IN FRAME fpage0 = TRUE.
    ELSE ASSIGN bt-ean:SENSITIVE IN FRAME fpage0 = FALSE.

    IF  cAction = "UPDATE" THEN DO:
        /* Caso tenha n£meros de sÇries relacionados, dever† habilitar o campo quantidade do folder "SÇrie Relac." */
        FIND FIRST int-estabelec NO-LOCK
            WHERE  int-estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
        IF  NOT AVAIL int-estabelec 
        THEN FIND FIRST int-estabelec NO-LOCK
                WHERE   int-estabelec.cod-estabel = "101" NO-ERROR.
    
        IF  AVAIL int-estabelec
        THEN ASSIGN c-prefixoEAN-aux = TRIM(STRING(int-estabelec.prefixo-ean13)).
        ELSE ASSIGN c-prefixoEAN-aux = "".
        
    END. /* IF  cAction = "UPDATE" THEN DO: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       
        fnBloqueia().

        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFIelds wMaintenance 
PROCEDURE beforeDisplayFIelds :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle(h-boin667) then do:
       run gotokey in h-boin667 ( input tt-item.it-codigo ).
       run getRecord in h-boin667 ( output table tt-item-mat ).   
   end.

   find first tt-item-mat no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Cadastro EAN" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        

        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cadastro EAN":U).            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 inbo/boin172.p }
        {btb/btb008za.i2 inbo/boin172.p '' {&hDBOTable}}
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.


    IF  NOT VALID-HANDLE(h-boin667) THEN
        RUN inbo/boin667.p PERSISTENT SET h-boin667.

    RUN openQueryStatic IN h-boin667 (INPUT "Default":U) NO-ERROR.

    /*
    IF NOT VALID-HANDLE(h-boin684) OR
       h-boin684:TYPE <> "PROCEDURE":U OR
       h-boin684:FILE-NAME <> "boin684.p":U THEN DO:
        {btb/btb008za.i1 inbo\boin684.p YES}
        {btb/btb008za.i2 inbo\boin684.p '' h-boin684}
    END.

    RUN setConstraintRangeItemEstab IN h-boin684 (INPUT "":U,
                                                  INPUT FILL("Z":U, 16),
                                                  INPUT "":U,
                                                  INPUT "ZZZ":U) NO-ERROR.   
    RUN openQueryStatic IN h-boin684 (INPUT "RangeItemEstab":U) NO-ERROR.
    */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaEAN wMaintenance 
PROCEDURE piCalculaEAN :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-codigo-12  AS CHARACTER FORMAT "x(12)"  NO-UNDO.
    DEFINE VARIABLE i-soma-impar AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-soma-par   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-total      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-resto      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-digito     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-novo-ean   AS CHARACTER   NO-UNDO.

    FIND FIRST int-estabelec NO-LOCK
        WHERE  int-estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
    IF  NOT AVAIL int-estabelec 
    THEN FIND FIRST int-estabelec NO-LOCK
            WHERE   int-estabelec.cod-estabel = "101" NO-ERROR.

    IF  NOT AVAIL int-estabelec THEN DO:
        MESSAGE "Erro. N∆o encontrado nenhum estabelecimento com informaá‰es de c¢digos EAN." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        LEAVE.
    END.

    IF  int-estabelec.seq-atual-ean13 + 1 > INT(int-estabelec.numeros-ean13) THEN DO:
        MESSAGE "SeqÅància de c¢digos gerados para esse estabelecimento j† estourou." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        LEAVE.
    END.

    IF  int-estabelec.seq-atual-ean13 + 1 > INT(int-estabelec.numeros-ean13) - 10 THEN DO:
        MESSAGE "SeqÅància de c¢digos para esse estabelecimento est† terminando. Favor providenciar novo c¢digo junto ao GS1. Restam somente " +
                STRING(INT(int-estabelec.numeros-ean13) - int-estabelec.seq-atual-ean13) + " c¢digos livres." VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    ASSIGN c-codigo-12 = TRIM(STRING(int-estabelec.prefixo-ean13)) + STRING(int-estabelec.seq-atual-ean13 + 1,int-estabelec.numeros-ean13)
           i-soma-impar = INT(SUBSTRING(c-codigo-12,1,1)) + INT(SUBSTRING(c-codigo-12,3,1)) + INT(SUBSTRING(c-codigo-12,5,1)) + INT(SUBSTRING(c-codigo-12,7,1)) + INT(SUBSTRING(c-codigo-12,9,1)) + INT(SUBSTRING(c-codigo-12,11,1)) 
           i-soma-par   = INT(SUBSTRING(c-codigo-12,2,1)) + INT(SUBSTRING(c-codigo-12,4,1)) + INT(SUBSTRING(c-codigo-12,6,1)) + INT(SUBSTRING(c-codigo-12,8,1)) + INT(SUBSTRING(c-codigo-12,10,1)) + INT(SUBSTRING(c-codigo-12,12,1))
           i-total      = i-soma-impar + i-soma-par * 3
           i-resto      = ((i-total / 10) - trunc(i-total / 10, 0)) * 10.

    IF i-resto = 0 
    THEN ASSIGN i-digito = 0.
    ELSE ASSIGN i-digito = 10 - i-resto. 
    
    ASSIGN c-novo-ean = STRING(c-codigo-12 + STRING(i-digito)).

    IF  CAN-FIND(FIRST item-mat WHERE item-mat.cod-ean = c-novo-ean) THEN DO:
        FIND CURRENT int-estabelec EXCLUSIVE-LOCK.
        ASSIGN int-estabelec.seq-atual-ean13 = int-estabelec.seq-atual-ean13 + 1.
        RUN piCalculaEAN.
        RETURN "OK":U.
    END. /* IF  CAN-FIND(FIRST item-ean */

    ASSIGN tt-item-mat.cod-ean:SCREEN-VALUE IN FRAME fpage0 = c-novo-ean
           tt-item-mat.cod-ean:SENSITIVE    IN FRAME fpage0 = FALSE
           bt-ean:SENSITIVE                 IN FRAME fpage0 = FALSE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaWMS wMaintenance 
PROCEDURE piGravaWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    FOR FIRST wm-item
        WHERE wm-item.cod-item = tt-item.it-codigo:SCREEN-VALUE EXCLUSIVE-LOCK:
    
        ASSIGN wm-item.cod-barras = tt-item-mat.cod-ean:SCREEN-VALUE.
    END.

    RELEASE wm-item.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateRecord wMaintenance 
PROCEDURE ValidateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        IF tt-item-mat.cod-ean:SCREEN-VALUE <> "" THEN DO:
    
            IF CAN-FIND(FIRST item-mat
                        WHERE item-mat.it-codigo <> tt-item.it-codigo:SCREEN-VALUE
                        AND   item-mat.cod-ean    = tt-item-mat.cod-ean:SCREEN-VALUE) THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "C¢digo EAN j† existe em outro item.").
    
                APPLY "Entry" TO bt-ean.
    
                RETURN "NOK":U.
    
            END.

        END.

        IF tt-item-mat.cod-ean:SENSITIVE IN FRAME fPage0 = TRUE THEN DO:

            IF SUBSTRING(tt-item-mat.cod-ean:SCREEN-VALUE IN FRAME fPage0, 1, LENGTH(c-prefixo-ean)) = c-prefixo-ean THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "EAN digitado n∆o pode iniciar com o prefixo " + c-prefixo-ean + ".").
    
                APPLY "Entry" TO bt-ean.
    
                RETURN "NOK":U.

            END.

        END.

    END.

    run gotokey in h-boin667 ( input tt-item.it-codigo ).
    run emptyRowObject in h-boin667.
    run setRecord in h-boin667 ( input table tt-item-mat ).
    run updateRecord in h-boin667.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBloqueia wMaintenance 
FUNCTION fnBloqueia RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST int-estabelec NO-LOCK
        WHERE  int-estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
    IF  NOT AVAIL int-estabelec 
    THEN FIND FIRST int-estabelec NO-LOCK
            WHERE   int-estabelec.cod-estabel = "101" NO-ERROR.

    ASSIGN c-prefixo-ean = "".

    IF AVAIL int-estabelec THEN DO:

        ASSIGN c-prefixo-ean = string(int-estabelec.prefixo-ean13).

    END.

    /***/

    IF INPUT FRAME fPage0 tt-item-mat.cod-ean <> "" THEN DO:

        IF SUBSTRING(INPUT FRAME fPage0 tt-item-mat.cod-ean,1,LENGTH(c-prefixo-ean)) = c-prefixo-ean THEN
            ASSIGN btUpdate:SENSITIVE IN FRAME fPage0 = FALSE.
        ELSE 
            ASSIGN btUpdate:SENSITIVE IN FRAME fPage0 = TRUE.

    END.
    ELSE DO:

        ASSIGN btUpdate:SENSITIVE IN FRAME fPage0 = TRUE.

    END.

    ASSIGN MENU-ITEM miUpdate:SENSITIVE IN MENU mbMain = btUpdate:SENSITIVE IN FRAME fPage0.

    
    RETURN l-libera.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesUnidNegoc wMaintenance 
FUNCTION fnDesUnidNegoc RETURNS CHARACTER
  ( p-cod-unid-negoc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = p-cod-unid-negoc NO-LOCK NO-ERROR.

    IF AVAILABLE unid-negoc THEN
        RETURN unid-negoc.des-unid-negoc.   /* Function return value. */
    ELSE
        RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

