&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME swWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS swWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE NOME-PROGRAMA    CD0704-UPCV21
&GLOBAL-DEFINE VERSAO-PROGRAMA  2.04.00.000

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER h-pai       AS HANDLE      NO-UNDO.
DEFINE INPUT        PARAMETER r-pai       AS ROWID       NO-UNDO.
DEFINE INPUT        PARAMETER l-atualizar AS LOGICAL     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER r-filho     AS ROWID       NO-UNDO.
DEFINE INPUT        PARAMETER c-tipo      AS CHAR        NO-UNDO.

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl   AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-filtro         AS INTEGER INITIAL 1 NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario    AS CHARACTER   NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hWindowParent  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-prog         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa-un AS HANDLE      NO-UNDO.
DEFINE VARIABLE hProgramZoom   AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-implanta     AS LOGICAL     NO-UNDO.

/* Buffer Definitions ---                                               */
DEFINE BUFFER b-relac-cliente FOR crm-relacionamento-cliente.

{src/adm2/widgetprto.i}


/* Definicao da Temp-tables usadas no programa ESCRM001B.p */
{esp/crm/escrm001b.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES emitente gerente

/* Definitions for FRAME fMain                                          */
&Scoped-define QUERY-STRING-fMain FOR EACH emitente ~
      WHERE rowid(emitente) = r-pai SHARE-LOCK, ~
      EACH gerente WHERE TRUE /* Join to emitente incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-fMain OPEN QUERY fMain FOR EACH emitente ~
      WHERE rowid(emitente) = r-pai SHARE-LOCK, ~
      EACH gerente WHERE TRUE /* Join to emitente incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fMain emitente gerente
&Scoped-define FIRST-TABLE-IN-QUERY-fMain emitente
&Scoped-define SECOND-TABLE-IN-QUERY-fMain gerente


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-4 IMAGE-1 IMAGE-2 ~
fi-cod-emitente fi-nome-abrev-emit fi-cd-unid-comerc fi-des_unid_negoc ~
fi-cod-rep fi-nome-abrev fi-cod-gerente fi-nome-gerente fi-cd-categoria ~
fi-ds-categoria dt-vigencia-ini dt-vigencia-fim fi-observacao bt-ok ~
bt-cancelar 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente fi-nome-abrev-emit ~
fi-cd-unid-comerc fi-des_unid_negoc fi-cod-rep fi-nome-abrev fi-cod-gerente ~
fi-nome-gerente fi-cd-categoria fi-ds-categoria dt-vigencia-ini ~
dt-vigencia-fim fi-observacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR swWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-observacao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 52 BY 6.5 NO-UNDO.

DEFINE VARIABLE dt-vigencia-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Vigància" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-categoria AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "C¢digo":R8 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88.

DEFINE VARIABLE fi-cod-gerente LIKE gerente.cod-gerente
     LABEL "Gerente" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rep AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-des_unid_negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ds-categoria AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev-emit AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome Abreviado":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE fi-nome-gerente LIKE gerente.nome
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY fMain FOR 
      emitente, 
      gerente SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     fi-cod-emitente AT ROW 1.17 COL 31.43 COLON-ALIGNED HELP
          "C¢digo Cliente" NO-TAB-STOP 
     fi-nome-abrev-emit AT ROW 2.17 COL 31.43 COLON-ALIGNED HELP
          "Nome abreviado do cliente" NO-TAB-STOP 
     fi-cd-unid-comerc AT ROW 3.88 COL 19.57 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial"
     fi-des_unid_negoc AT ROW 3.88 COL 25.86 COLON-ALIGNED HELP
          "Descriá∆o da Unidade Comercial" NO-LABEL NO-TAB-STOP 
     fi-cod-rep AT ROW 4.88 COL 19.57 COLON-ALIGNED HELP
          "Representante"
     fi-nome-abrev AT ROW 4.88 COL 25.86 COLON-ALIGNED HELP
          "Nome Abreviado do Representante" NO-LABEL NO-TAB-STOP 
     fi-cod-gerente AT ROW 5.88 COL 19.57 COLON-ALIGNED HELP
          "C¢digo do Gerente"
          LABEL "Gerente"
     fi-nome-gerente AT ROW 5.88 COL 25.86 COLON-ALIGNED HELP
          "Nome do Gerente" NO-LABEL NO-TAB-STOP 
     fi-cd-categoria AT ROW 6.83 COL 19.57 COLON-ALIGNED HELP
          "Categoria"
     fi-ds-categoria AT ROW 6.83 COL 25.86 COLON-ALIGNED HELP
          "Descriá∆o do Grupo de Cliente" NO-LABEL NO-TAB-STOP 
     dt-vigencia-ini AT ROW 7.83 COL 19.57 COLON-ALIGNED HELP
          "Data de vigància Inicial"
     dt-vigencia-fim AT ROW 7.83 COL 42.72 COLON-ALIGNED HELP
          "Data de vigància Inicial" NO-LABEL
     fi-observacao AT ROW 9.25 COL 22 NO-LABEL WIDGET-ID 2
     bt-ok AT ROW 16.5 COL 2 HELP
          "OK"
     bt-cancelar AT ROW 16.5 COL 12.29 HELP
          "Cancelar"
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 9.25 COL 11 WIDGET-ID 4
     RECT-1 AT ROW 1 COL 1
     RECT-4 AT ROW 16.25 COL 1
     IMAGE-1 AT ROW 7.83 COL 33.86
     IMAGE-2 AT ROW 7.83 COL 40.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75 BY 17.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW swWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Relacionamento Cliente"
         HEIGHT             = 17.29
         WIDTH              = 75
         MAX-HEIGHT         = 17.29
         MAX-WIDTH          = 75
         VIRTUAL-HEIGHT     = 17.29
         VIRTUAL-WIDTH      = 75
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB swWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW swWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cod-gerente IN FRAME fMain
   LIKE = mgesp.gerente.cod-gerente EXP-LABEL EXP-HELP EXP-SIZE        */
/* SETTINGS FOR FILL-IN fi-nome-gerente IN FRAME fMain
   LIKE = mgesp.gerente.nome EXP-LABEL EXP-HELP EXP-SIZE               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(swWin)
THEN swWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _TblList          = "mgcad.emitente,mgesp.gerente WHERE mgcad.emitente ..."
     _Where[1]         = "rowid(emitente) = r-pai"
     _Query            is OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME swWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL swWin swWin
ON END-ERROR OF swWin /* Relacionamento Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  hWindowParent:SENSITIVE = YES.
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL swWin swWin
ON WINDOW-CLOSE OF swWin /* Relacionamento Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  hWindowParent:SENSITIVE = YES.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar swWin
ON CHOOSE OF bt-cancelar IN FRAME fMain /* Cancelar */
DO:
    hWindowParent:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok swWin
ON CHOOSE OF bt-ok IN FRAME fMain /* OK */
DO:
    RUN pi-salvar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-categoria swWin
ON F5 OF fi-cd-categoria IN FRAME fMain /* Categoria */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es547.w"
                         &FieldZoom1="cd-categoria"
                         &FieldScreen1="fi-cd-categoria"
                         &Frame1="fMain"
                         &FieldZoom2="ds-categoria"
                         &FieldScreen2="fi-ds-categoria"
                         &Frame2="fMain"
                         &RunMethod="RUN setUnidNegoc IN hProgramZoom (INPUT INPUT FRAME fMain fi-cd-unid-comerc)."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-categoria swWin
ON LEAVE OF fi-cd-categoria IN FRAME fMain /* Categoria */
DO:
    FIND FIRST crm-categoria NO-LOCK
        WHERE  crm-categoria.cd-categoria = INPUT FRAME fMain fi-cd-categoria NO-ERROR.

    ASSIGN fi-ds-categoria = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "".

    DISPLAY fi-ds-categoria
        WITH FRAME fMain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-categoria swWin
ON MOUSE-SELECT-DBLCLICK OF fi-cd-categoria IN FRAME fMain /* Categoria */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-unid-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-unid-comerc swWin
ON F5 OF fi-cd-unid-comerc IN FRAME fMain /* Unid Comercial */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es548.w"
                         &FieldZoom1="cd-unid-negoc"
                         &FieldScreen1="fi-cd-unid-comerc"
                         &Frame1="fMain"
                         &FieldZoom2="ds-unid-negoc"
                         &FieldScreen2="fi-des_unid_negoc"
                         &Frame2="fMain"
                         &RunMethod="RUN setUsuario IN hProgramZoom (INPUT c-seg-usuario)."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-unid-comerc swWin
ON LEAVE OF fi-cd-unid-comerc IN FRAME fMain /* Unid Comercial */
DO:
    ASSIGN INPUT FRAME fMain fi-cd-unid-comerc.

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = fi-cd-unid-comerc NO-ERROR.

    ASSIGN fi-des_unid_negoc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    DISPLAY fi-des_unid_negoc WITH FRAME fMain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-unid-comerc swWin
ON MOUSE-SELECT-DBLCLICK OF fi-cd-unid-comerc IN FRAME fMain /* Unid Comercial */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-gerente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-gerente swWin
ON F5 OF fi-cod-gerente IN FRAME fMain /* Gerente */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es382.w"
                         &FieldZoom1="cod-gerente"
                         &FieldScreen1="fi-cod-gerente"
                         &Frame1="fMain"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-nome-gerente"
                         &Frame2="fMain"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-gerente swWin
ON LEAVE OF fi-cod-gerente IN FRAME fMain /* Gerente */
DO:
    FIND FIRST gerente
        WHERE gerente.cod-gerente = INPUT FRAME fMain fi-cod-gerente NO-LOCK NO-ERROR.

    ASSIGN fi-nome-gerente = IF AVAILABLE gerente THEN gerente.nome ELSE "":U.

    DISPLAY fi-nome-gerente
        WITH FRAME fMain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-gerente swWin
ON MOUSE-SELECT-DBLCLICK OF fi-cod-gerente IN FRAME fMain /* Gerente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-rep swWin
ON F5 OF fi-cod-rep IN FRAME fMain /* Representante */
DO:
    ASSIGN l-implanta = NO.
    /*{include/zoomvar.i &prog-zoom=adzoom/z01ad229.w
                       &campo=fi-cod-rep
                       &campozoom=cod-rep
                       &frame=fMain
                       &campo2=fi-nome-abrev
                       &campozoom2=nome-abrev
                       &frame2=fMain}*/
                       
    RUN adzoom/z01ad229.w PERSISTENT SET wh-pesquisa.
    RUN dispatch IN wh-pesquisa ('initialize':U).
    RUN pi-seta-atributos-chave IN wh-pesquisa (STRING(fi-cod-rep:HANDLE    IN FRAME fMain) + '|' + 'cod-rep' + CHR(10) +
                                                STRING(fi-nome-abrev:HANDLE IN FRAME fMain) + '|' + 'nome-abrev').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-rep swWin
ON LEAVE OF fi-cod-rep IN FRAME fMain /* Representante */
DO:
    FIND FIRST repres
        WHERE repres.cod-rep = INPUT FRAME fMain fi-cod-rep NO-LOCK NO-ERROR.

    ASSIGN fi-nome-abrev = IF AVAILABLE repres THEN repres.nome-abrev ELSE "":U.

    DISPLAY fi-nome-abrev
        WITH FRAME fMain.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-rep swWin
ON MOUSE-SELECT-DBLCLICK OF fi-cod-rep IN FRAME fMain /* Representante */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK swWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects swWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI swWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(swWin)
  THEN DELETE WIDGET swWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI swWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-fMain}
  GET FIRST fMain.
  DISPLAY fi-cod-emitente fi-nome-abrev-emit fi-cd-unid-comerc fi-des_unid_negoc 
          fi-cod-rep fi-nome-abrev fi-cod-gerente fi-nome-gerente 
          fi-cd-categoria fi-ds-categoria dt-vigencia-ini dt-vigencia-fim 
          fi-observacao 
      WITH FRAME fMain IN WINDOW swWin.
  ENABLE RECT-1 RECT-4 IMAGE-1 IMAGE-2 fi-cod-emitente fi-nome-abrev-emit 
         fi-cd-unid-comerc fi-des_unid_negoc fi-cod-rep fi-nome-abrev 
         fi-cod-gerente fi-nome-gerente fi-cd-categoria fi-ds-categoria 
         dt-vigencia-ini dt-vigencia-fim fi-observacao bt-ok bt-cancelar 
      WITH FRAME fMain IN WINDOW swWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW swWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject swWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject swWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-pai) THEN
        ASSIGN hWindowParent           = h-pai
               hWindowParent:SENSITIVE = NO.
    
    ASSIGN {&WINDOW-NAME}:X = hWindowParent:X + ((hWindowParent:WIDTH-PIXELS  / 2) - ({&WINDOW-NAME}:WIDTH-PIXELS  / 2))
           {&WINDOW-NAME}:Y = hWindowParent:Y + ((hWindowParent:HEIGHT-PIXELS / 2) - ({&WINDOW-NAME}:HEIGHT-PIXELS / 2)).
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST mgcad.empresa
        WHERE mgcad.empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.
    
    IF  AVAILABLE mgcad.empresa THEN
        ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - ":U + '{&NOME-PROGRAMA}' + " - ":U + '{&VERSAO-PROGRAMA}' + " - ":U + STRING(mgcad.empresa.ep-codigo) + " - ":U + mgcad.empresa.nome.
    ELSE
        ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - ":U + '{&NOME-PROGRAMA}' + " - ":U + '{&VERSAO-PROGRAMA}'.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    RUN SUPER.

    /* Code placed here will execute AFTER standard behavior.    */
    fi-cod-rep:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fMain.
    fi-cd-unid-comerc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fMain.
    fi-cod-gerente:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fMain.
    fi-cd-categoria:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fMain.
    
    IF c-tipo = "alterar" THEN DO:
    
    DISABLE fi-des_unid_negoc 
            fi-nome-abrev
            fi-nome-gerente
            fi-ds-categoria
            dt-vigencia-ini
            fi-cod-emitente
            fi-nome-abrev-emit
        WITH FRAME fMain.
    
    ENABLE fi-cd-categoria   
           fi-cd-unid-comerc 
           fi-cod-rep        
           fi-cod-gerente    
           dt-vigencia-fim
        WITH FRAME fMain. 
    END.
    ELSE DO:

    DISABLE fi-des_unid_negoc 
            fi-nome-abrev
            fi-nome-gerente
            fi-ds-categoria
            fi-cod-emitente
            fi-nome-abrev-emit
        WITH FRAME fMain.
    
    ENABLE dt-vigencia-ini
           fi-cd-categoria   
           fi-cd-unid-comerc 
           fi-cod-rep        
           fi-cod-gerente    
           dt-vigencia-fim
        WITH FRAME fMain. 
    END.

/*     ELSE DO:                      */
/*                                   */
/*         DISABLE fi-des_unid_negoc */
/*                 fi-nome-abrev     */
/*                 fi-nome-gerente   */
/*                 fi-ds-categoria   */
/*             WITH FRAME fMain.     */
/*                                   */
/*         ENABLE fi-cod-emitente    */
/*                fi-nome-abrev-emit */
/*                fi-cd-categoria    */
/*                fi-cd-unid-comerc  */
/*                fi-cod-rep         */
/*                fi-cod-gerente     */
/*                dt-vigencia-ini    */
/*                dt-vigencia-fim    */
/*             WITH FRAME fMain.     */
/*     END.                          */
    
    FIND FIRST int-emitente NO-LOCK
        WHERE  ROWID(int-emitente) = r-pai NO-ERROR.
    IF  AVAIL  int-emitente THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    
        ASSIGN fi-cod-emitente    = int-emitente.cod-emitente
               fi-nome-abrev-emit = IF AVAIL emitente THEN emitente.nome-abrev ELSE "".
    END.
    
    DISPLAY fi-cod-emitente
            fi-nome-abrev-emit
        WITH FRAME fMain.


   FIND FIRST int-user-coml NO-LOCK
        WHERE int-user-coml.cd-usuario = c-seg-usuario NO-ERROR.
   IF  AVAIL  int-user-coml THEN
       ASSIGN fi-cd-unid-comerc = INT(int-user-coml.cd-unid-negoc).


    IF  l-atualizar THEN DO:
        FIND FIRST crm-relacionamento-cliente NO-LOCK
            WHERE  ROWID(crm-relacionamento-cliente) = r-filho NO-ERROR.
        IF  AVAIL  crm-relacionamento-cliente THEN DO:
            ASSIGN fi-cod-rep        = crm-relacionamento-cliente.cod-rep
                   fi-cd-unid-comerc = INT(crm-relacionamento-cliente.cd-unid-negoc)
                   fi-cod-gerente    = crm-relacionamento-cliente.cod-gerente
                   fi-cd-categoria   = crm-relacionamento-cliente.cd-categoria
                   dt-vigencia-ini   = crm-relacionamento-cliente.dt-vigencia-ini
                   dt-vigencia-fim   = crm-relacionamento-cliente.dt-vigencia-fim
                   fi-observacao     = crm-relacionamento-cliente.observacao.
    
            FIND FIRST repres NO-LOCK
                WHERE repres.cod-rep = crm-relacionamento-cliente.cod-rep NO-ERROR.
    
            ASSIGN fi-nome-abrev   = IF AVAIL repres THEN repres.nome-abrev ELSE "".
    
            DISPLAY fi-nome-abrev
                    fi-des_unid_negoc
                    fi-ds-categoria
                WITH FRAME fMain.
        END.
        ELSE
            ASSIGN fi-cod-rep        = 0
                   fi-cd-categoria   = 0.
    END.
    
    DISPLAY 
            fi-cd-unid-comerc
            fi-cod-rep
            fi-cod-gerente
            fi-cd-categoria
            dt-vigencia-ini
            dt-vigencia-fim
            fi-observacao
        WITH FRAME fMain.
    
    APPLY "LEAVE":U TO fi-cd-unid-comerc IN FRAME fMain.
    APPLY "LEAVE":U TO fi-cod-gerente    IN FRAME fMain.
    APPLY "LEAVE":U TO fi-cd-categoria   IN FRAME fMain.
    APPLY "ENTRY":U TO fi-cd-unid-comerc IN FRAME fMain.

    IF c-tipo = "copiar" THEN
        ASSIGN c-tipo = "novo"
               l-atualizar = NO.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar swWin 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fMain fi-cd-unid-comerc
           INPUT FRAME fMain fi-cod-rep
           INPUT FRAME fMain fi-cod-gerente
           INPUT FRAME fMain fi-cd-categoria
           INPUT FRAME fMain dt-vigencia-ini
           INPUT FRAME fMain dt-vigencia-fim
           INPUT FRAME fMain fi-observacao.


    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.


    IF  NOT l-atualizar THEN DO:
        /*FIND FIRST b-relac-cliente NO-LOCK
            WHERE  b-relac-cliente.cod-emitente    = emitente.cod-emitente
            AND    b-relac-cliente.cod-rep         = fi-cod-rep
            AND    b-relac-cliente.cd-unid-negoc   = STRING(fi-cd-unid-comerc)
            AND    b-relac-cliente.dt-vigencia-ini = dt-vigencia-ini NO-ERROR.
        IF  AVAIL  b-relac-cliente THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Relacionamento j† existe!":U).

            APPLY "ENTRY":U TO fi-cd-unid-comerc IN FRAME fMain.
            RETURN NO-APPLY.
        END.*/

        FIND LAST b-relac-cliente NO-LOCK
            WHERE b-relac-cliente.cod-emitente = emitente.cod-emitente NO-ERROR.

        CREATE crm-relacionamento-cliente.
        ASSIGN crm-relacionamento-cliente.cod-emitente = emitente.cod-emitente
               crm-relacionamento-cliente.seq          = IF AVAIL b-relac-cliente THEN b-relac-cliente.seq + 1 ELSE 1
               r-filho                                 = ROWID(crm-relacionamento-cliente).
    END.

    IF  NOT AVAIL crm-relacionamento-cliente THEN DO:
        FIND FIRST crm-relacionamento-cliente EXCLUSIVE-LOCK
            WHERE  ROWID(crm-relacionamento-cliente) = r-filho NO-ERROR.
    END.
    ELSE
        FIND CURRENT crm-relacionamento-cliente EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL crm-relacionamento-cliente THEN DO:
        ASSIGN crm-relacionamento-cliente.cod-rep         = fi-cod-rep
               crm-relacionamento-cliente.cd-unid-negoc   = STRING(fi-cd-unid-comerc)
               crm-relacionamento-cliente.cod-gerente     = fi-cod-gerente
               crm-relacionamento-cliente.cd-categoria    = fi-cd-categoria
               crm-relacionamento-cliente.dt-vigencia-ini = dt-vigencia-ini
               crm-relacionamento-cliente.dt-vigencia-fim = dt-vigencia-fim
               crm-relacionamento-cliente.observacao      = fi-observacao.

        /* S¢ pode ter uma Unidade Comercial vigànte para o Cliente */
        FIND LAST b-relac-cliente EXCLUSIVE-LOCK
            WHERE b-relac-cliente.cod-emitente  = fi-cod-emitente 
            AND   b-relac-cliente.cd-unid-negoc = STRING(fi-cd-unid-comerc)
            AND   ROWID(b-relac-cliente)       <> r-filho NO-ERROR.
        IF  AVAIL b-relac-cliente AND b-relac-cliente.dt-vigencia-fim = ? THEN
            ASSIGN b-relac-cliente.dt-vigencia-fim = dt-vigencia-ini.
    END.

    ASSIGN r-filho = ROWID(crm-relacionamento-cliente).

    hWindowParent:SENSITIVE = YES.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar swWin 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST repres NO-LOCK
        WHERE  repres.cod-rep = fi-cod-rep NO-ERROR.
    IF  NOT AVAIL repres THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Representante inv†lido!":U).

        APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.
        RETURN "NOK":U.
    END.


    /* Valida de a Unidade Comercial est† cadastrada */
    IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                     WHERE unid-comerc.cd-unid-comerc = fi-cd-unid-comerc) THEN DO:
        RUN utp/ut-msgs.p (INPUT "":U,
                           INPUT 17006,
                           INPUT "Unidade Comercial inv†lida!":U).

        APPLY "ENTRY":U TO fi-cd-unid-comerc IN FRAME fMain.
        RETURN "NOK":U.
    END.
    /* Fim validaá∆o Cadastro */

    /* Valida se o Usu†rio tem cadastrada essa Unidade Comercial */
    IF  NOT CAN-FIND(FIRST int-user-coml NO-LOCK
                     WHERE int-user-coml.cd-usuario    = c-seg-usuario
                     AND   int-user-coml.cd-unid-negoc = STRING(fi-cd-unid-comerc)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Usu†rio sem relacionamento com a Unidade Comercial!":U).

        APPLY "ENTRY":U TO fi-cd-unid-comerc IN FRAME fMain.
        RETURN "NOK":U.
    END.
    /* Fim cadastro usu†rio */


    /*IF  CAN-FIND(FIRST crm-relacionamento-cliente NO-LOCK
                 WHERE crm-relacionamento-cliente.cod-emitente     = fi-cod-emitente
                 AND   crm-relacionamento-cliente.cd-unid-negoc    = fi-cod-unid-negoc
                 AND   crm-relacionamento-cliente.cod-rep         <> fi-cod-rep
                 AND  (crm-relacionamento-cliente.dt-vigencia-fim <> ? AND
                       crm-relacionamento-cliente.dt-vigencia-ini < dt-vigencia-fim) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "J† existe um relacionamento entre Representante e Unidade de Neg¢cio!~~" + 
                                 "A Unidade de Neg¢cio s¢ pode ter 1 (um) representante ativo. ").

        APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.
        RETURN "NOK":U.
    END.
    /* Fim validaá∆o Representante x UN */*/


    /* Validaá∆o Categoria */
    IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                     WHERE crm-categoria.cd-categoria = fi-cd-categoria) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Categoria inv†lida!":U).

        APPLY "ENTRY":U TO fi-cd-categoria IN FRAME fMain.
        RETURN "NOK":U.
    END.


    /* Validaá∆o entre Categoria x Unidade Neg¢cio */
    IF  NOT CAN-FIND(FIRST crm-categ-un NO-LOCK
                     WHERE crm-categ-un.cd-categoria  = fi-cd-categoria
                     AND   crm-categ-un.cd-unid-negoc = STRING(fi-cd-unid-comerc)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o foi encontrada relaá∆o Categoria x Unidade Comercial!":U).

        APPLY "ENTRY":U TO fi-cd-unid-comerc IN FRAME fMain.
        RETURN "NOK":U.
    END.


    /*/* Valida se j† existe o relacionamento entre a Representante e Unidade Comercial */
    IF  CAN-FIND(FIRST crm-relacionamento-cliente NO-LOCK
                 WHERE crm-relacionamento-cliente.cod-emitente  = fi-cod-emitente
                 AND   crm-relacionamento-cliente.cod-rep       = fi-cod-rep
                 AND   crm-relacionamento-cliente.cd-unid-negoc = STRING(fi-cd-unid-comerc)
                 AND   ROWID(crm-relacionamento-cliente)        <> r-filho) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "J† existe um relacionamento entre Representante e Unidade Comercial!~~" + 
                                 "O Cliente s¢ pode ter um relacionamento entre Representante e Unidade Comercial.").

        APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.
        RETURN "NOK":U.
    END.*/

    /* Validaá∆o da Vigància */
    IF  INPUT FRAME fMain dt-vigencia-ini <> ? THEN DO:
        /*IF  CAN-FIND(FIRST b-relac-cliente NO-LOCK
                     WHERE b-relac-cliente.cod-emitente     = fi-cod-emitente
                     AND   b-relac-cliente.cod-rep          = fi-cod-rep
                     AND   b-relac-cliente.dt-vigància-fim  > dt-vigencia-ini) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data Inicial pertence a faixa de um outra vigància do Representante.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fMain.
            RETURN "NOK":U.
        END.*/
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data Inicial de Vigància n∆o Informada!~~A data inicial da vigància deve ser informada!").

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fMain.
        RETURN "NOK":U.
    END.

    IF  INPUT FRAME fMain dt-vigencia-fim <> ? and
        INPUT FRAME fMain dt-vigencia-fim < INPUT FRAME fMain dt-vigencia-ini THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data Final de Vigància menor que Data Inicial de Vigància!~~Data Final de Vigància menor que Data Inicial de Vigància!").

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fMain.
        RETURN "NOK":U.
    END.


    /* Valida se j† existe outro Representante informado para a Unidade de Neg¢cio */
/*     FIND FIRST b-relac-cliente NO-LOCK                                                                      */
/*         WHERE  b-relac-cliente.cod-emitente  = fi-cod-emitente                                              */
/*         AND    b-relac-cliente.cd-unid-negoc = STRING(fi-cd-unid-comerc)                                    */
/*         /*AND    b-relac-cliente.cod-rep      <> fi-cod-rep*/ NO-ERROR.                                     */
/*     IF  AVAIL  b-relac-cliente THEN DO:                                                                     */
/*         IF  b-relac-cliente.dt-vigencia-fim <> ?  AND                                                       */
/*             dt-vigencia-ini < b-relac-cliente.dt-vigencia-fim THEN DO:                                      */
/*             RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                              */
/*                                INPUT 17006,                                                                 */
/*                                INPUT "Faixa de Datas pertence a outra Vigància!~~" +                        */
/*                                      "A faixa de data informada est† entre outra Vigància j† cadastrada!"). */
/*                                                                                                             */
/*             APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.                                                   */
/*             RETURN "NOK":U.                                                                                 */
/*         END.                                                                                                */
/*     END.                                                                                                    */
/*                                                                                           */
/*     IF INPUT FRAME fMain dt-vigencia-ini < TODAY - 60 THEN DO:                            */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                */
/*                            INPUT 17006,                                                   */
/*                            INPUT "Data Vigencia Inicial Informada menor que 60 dias!~~" + */
/*                                  "Data Vigencia Inicial Informada menor que 60 dias!").   */
/*                                                                                           */
/*         APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain. */
/*         RETURN "NOK":U.                               */
/*     END.                                              */
/*                                                       */
                   
        /*     valida se o ano inserido Ç menor que o ano atual  */

    IF c-tipo = "novo" THEN DO:

        IF year(INPUT FRAME fMain dt-vigencia-ini) < YEAR(TODAY) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data com Ano Menor que Atual!~~" +
                                     "Data com Ano Menor que " + string(YEAR(TODAY), "9999")).
    
            APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.
            RETURN "NOK":U.
        END.

    END.

    /* Retirado incidente 57823 */
    /* Valida se representante est† Ativo 
    FIND FIRST int-repres
         WHERE int-repres.cod-repres = fi-cod-rep NO-LOCK NO-ERROR.
    IF AVAIL int-repres THEN DO:
        IF substring(int-repres.char-1,3,1) = "n" OR
           substring(int-repres.char-1,3,1) = " " THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Representante n∆o est† Ativo!~~" +
                                     "Representante n∆o est† Ativo!").


            APPLY "ENTRY":U TO fi-cod-rep IN FRAME fMain.

            RETURN "NOK":U.
        END.
    END.
    */    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

