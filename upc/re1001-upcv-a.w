&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movemp           PROGRESS
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
{include/i-prgvrs.i re1001-upcv-a 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        re1001-upcv-a
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Ordens

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 
&GLOBAL-DEFINE page1Widgets   bt-Altera

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-serie        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-documento    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-natureza     AS CHARACTER NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lValidaMsg       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-ex-tarifario   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lErros           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE wh-pesquisa      AS HANDLE NO-UNDO.
DEFINE VARIABLE v-num-entr-param AS INTEGER     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-msg NO-UNDO
    FIELD num-msg AS INT.

DEF TEMP-TABLE tt-conta-transit NO-UNDO
    FIELD conta-transit LIKE docum-est.conta-transit
    FIELD ct-transit    LIKE docum-est.ct-transit
    FIELD sc-transit    LIKE docum-est.sc-transit.

{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brOrdProd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES item-doc-est

/* Definitions for BROWSE brOrdProd                                     */
&Scoped-define FIELDS-IN-QUERY-brOrdProd item-doc-est.it-codigo ~
item-doc-est.serie-docto item-doc-est.nro-docto item-doc-est.cod-emitente ~
item-doc-est.nat-operacao item-doc-est.nr-ord-produ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdProd 
&Scoped-define QUERY-STRING-brOrdProd FOR EACH item-doc-est ~
      WHERE item-doc-est.nro-docto = p-documento ~
 AND item-doc-est.serie-docto = p-serie ~
 AND item-doc-est.cod-emitente = p-cod-emitente ~
 AND item-doc-est.nat-operacao = p-natureza NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brOrdProd OPEN QUERY brOrdProd FOR EACH item-doc-est ~
      WHERE item-doc-est.nro-docto = p-documento ~
 AND item-doc-est.serie-docto = p-serie ~
 AND item-doc-est.cod-emitente = p-cod-emitente ~
 AND item-doc-est.nat-operacao = p-natureza NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brOrdProd item-doc-est
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdProd item-doc-est


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brOrdProd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnExTarifario wWindow 
FUNCTION fnExTarifario RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-altera 
     LABEL "Alterar Todos" 
     SIZE 13 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOrdProd FOR 
      item-doc-est SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOrdProd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdProd wWindow _STRUCTURED
  QUERY brOrdProd NO-LOCK DISPLAY
      item-doc-est.it-codigo FORMAT "x(16)":U
      item-doc-est.serie-docto FORMAT "x(5)":U
      item-doc-est.nro-docto FORMAT "x(16)":U
      item-doc-est.cod-emitente FORMAT ">>>>>>>>9":U
      item-doc-est.nat-operacao FORMAT "x(06)":U
      item-doc-est.nr-ord-produ FORMAT ">>>,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.43 BY 7.63
         FONT 1
         TITLE "Ordens" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 73.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 77.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 81.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 85.29 HELP
          "Ajuda"
     btOK AT ROW 16.79 COL 2.29
     btCancel AT ROW 16.79 COL 13.29
     btHelp2 AT ROW 16.83 COL 76.43
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.58 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.86 BY 17.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brOrdProd AT ROW 1.38 COL 2.29 WIDGET-ID 500
     bt-altera AT ROW 12.5 COL 75 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 88 BY 12.75 WIDGET-ID 400.


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
         HEIGHT             = 17.38
         WIDTH              = 89.86
         MAX-HEIGHT         = 28.83
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.83
         VIRTUAL-WIDTH      = 182.86
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

ASSIGN brOrdprod:SENSITIVE IN FRAME fPage1 = YES.

{&OPEN-QUERY-brOrdprod}

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
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brOrdProd 1 fPage1 */
ASSIGN 
       brOrdProd:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdProd
/* Query rebuild information for BROWSE brOrdProd
     _TblList          = "movemp.item-doc-est"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "movemp.item-doc-est.nro-docto = p-documento
 AND movemp.item-doc-est.serie-docto = p-serie
 AND movemp.item-doc-est.cod-emitente = p-cod-emitente
 AND movemp.item-doc-est.nat-operacao = p-natureza"
     _FldNameList[1]   = movemp.item-doc-est.it-codigo
     _FldNameList[2]   = movemp.item-doc-est.serie-docto
     _FldNameList[3]   = movemp.item-doc-est.nro-docto
     _FldNameList[4]   = movemp.item-doc-est.cod-emitente
     _FldNameList[5]   = movemp.item-doc-est.nat-operacao
     _FldNameList[6]   = movemp.item-doc-est.nr-ord-produ
     _Query            is OPENED
*/  /* BROWSE brOrdProd */
&ANALYZE-RESUME

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-altera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera wWindow
ON CHOOSE OF bt-altera IN FRAME fPage1 /* Alterar Todos */
DO:
  RUN esp/rep/esrep037b.w (INPUT p-cod-emitente,
                           INPUT p-serie,      
                           INPUT p-documento,  
                           INPUT p-natureza).
  
  {&open-query-brOrdProd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
    IF lValidaMsg = YES THEN 
        RUN saveDevolucao.

    IF RETURN-VALUE <> "NOK" THEN
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


&Scoped-define BROWSE-NAME brOrdProd
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wWindow 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN brOrdProd:SENSITIVE IN FRAME fPage1 = YES.

    RELEASE ITEM NO-ERROR.

    {&OPEN-QUERY-brOrdProd}

    RETURN "OK".
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDevolucao wWindow 
PROCEDURE saveDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST docum-est EXCLUSIVE-LOCK 
         WHERE docum-est.serie-docto  = p-serie        
           AND docum-est.nro-docto    = p-documento    
           AND docum-est.cod-emitente = p-cod-emitente 
           AND docum-est.nat-operacao = p-natureza NO-ERROR.

    


     FIND CURRENT docum-est NO-LOCK NO-ERROR.

     RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExTarifario wWindow 
FUNCTION fnExTarifario RETURNS CHARACTER
  ( p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST int-item NO-LOCK
       WHERE int-item.it-codigo = p-it-codigo NO-ERROR.

  IF AVAIL int-item THEN
      RETURN int-item.ex-tarifario.
  ELSE 
      RETURN "".

  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

