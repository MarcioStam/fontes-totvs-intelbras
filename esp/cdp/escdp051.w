&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
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
{include/i-prgvrs.i ESCDP051 2.06.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP051
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   ed-observacao fi-cod-estabel btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Include Definitions ---                                              */

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

/* Parameters Definitions ---                                           */

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar ed-observacao fi-cod-estabel ~
fi-nome btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS ed-observacao fi-cod-estabel fi-nome 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-observacao AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 67 BY 4.13 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ed-observacao AT ROW 1.63 COL 12.57 HELP
          "Observaá∆o" NO-LABEL NO-TAB-STOP 
     fi-cod-estabel AT ROW 6.67 COL 21.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento"
     fi-nome AT ROW 6.67 COL 29.57 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     btOK AT ROW 8.75 COL 2 HELP
          "OK"
     btCancel AT ROW 8.75 COL 13 HELP
          "Cancelar"
     btHelp2 AT ROW 8.75 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 8.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9
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
         HEIGHT             = 9
         WIDTH              = 90
         MAX-HEIGHT         = 9
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 9
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
       ed-observacao:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE               */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME fpage0
   LIKE = mgcad.estabelec.nome EXP-SIZE                                */
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
    RUN pi-execute IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON F5 OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom="adzoom\z01ad107.w"
                       &campo="fi-cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="fPage0"
                       &campo2="fi-nome"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON LEAVE OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN INPUT FRAME fPage0 fi-cod-estabel.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fi-cod-estabel NO-LOCK NO-ERROR.

    ASSIGN fi-nome = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

    DISPLAY fi-nome
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON RETURN OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "LEAVE":U TO SELF.
    APPLY "CHOOSE":U TO btOK IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fi-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
   
    ASSIGN ed-observacao  = "Observaá∆o:":U + CHR(10) + CHR(10) +
                            "    O presente programa tem por objetivo alterar o estabelecimento padr∆o do usu†rio na seá∆o atual do ":U +
                            "Datasul EMS, bastando apenas inserir um novo estabelecimento v†lido e confirmando.":U + CHR(10) +
                            "    Este programa n∆o faz alteraá∆o definitiva desta informaá∆o, sendo apenas utilizado para a seá∆o corrente.":U
           fi-cod-estabel = v_cod_estab_usuar.
     
    DISPLAY ed-observacao
            fi-cod-estabel
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO fi-cod-estabel IN FRAME fPage0.
    APPLY "ENTRY":U TO fi-cod-estabel IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-execute wWindow 
PROCEDURE pi-execute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0 fi-cod-estabel.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fi-cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento":U).
       
        APPLY "ENTRY":U TO fi-cod-estabel IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    ASSIGN v_cod_estab_usuar = fi-cod-estabel
           v2_cod_estab_usuar = fi-cod-estabel.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

