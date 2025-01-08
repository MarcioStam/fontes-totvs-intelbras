&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-colab-salario-var NO-UNDO LIKE colab-salario-var
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*****************************************************************************
** Programa: esp/ftp/esftp096a.w
** Vers∆o..: 1.00
** Data....: 20/11/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Manutená∆o de Sal†rio Vari†vel do Colaborador
*****************************************************************************/
{include/i-prgvrs.i ESFTP096A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP096A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pAcao  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pRowid AS ROWID       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-colab-salario-var.cod-colab ~
tt-colab-salario-var.cod-rep tt-colab-salario-var.fm-cod-com-ini ~
tt-colab-salario-var.fm-cod-com-fim tt-colab-salario-var.dt-vigencia-ini ~
tt-colab-salario-var.dt-vigencia-fim tt-colab-salario-var.pc-variavel ~
tt-colab-salario-var.vl-teto tt-colab-salario-var.vl-fixo ~
tt-colab-salario-var.obs 
&Scoped-define ENABLED-TABLES tt-colab-salario-var
&Scoped-define FIRST-ENABLED-TABLE tt-colab-salario-var
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
RECT-1 c-nome-colab c-nome-rep btOK btCancel btHelp2 text-1 
&Scoped-Define DISPLAYED-FIELDS tt-colab-salario-var.cod-colab ~
tt-colab-salario-var.cod-rep tt-colab-salario-var.fm-cod-com-ini ~
tt-colab-salario-var.fm-cod-com-fim tt-colab-salario-var.dt-vigencia-ini ~
tt-colab-salario-var.dt-vigencia-fim tt-colab-salario-var.pc-variavel ~
tt-colab-salario-var.vl-teto tt-colab-salario-var.vl-fixo ~
tt-colab-salario-var.obs 
&Scoped-define DISPLAYED-TABLES tt-colab-salario-var
&Scoped-define FIRST-DISPLAYED-TABLE tt-colab-salario-var
&Scoped-Define DISPLAYED-OBJECTS c-nome-colab c-nome-rep text-1 

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

DEFINE VARIABLE c-nome-colab AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 56.67 BY .87 NO-UNDO.

DEFINE VARIABLE c-nome-rep AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 56.67 BY .87 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(12)":U INITIAL "Observaá∆o:" 
      VIEW-AS TEXT 
     SIZE 10.22 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .93.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .93.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .93.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .93.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 11.6.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.43
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-colab-salario-var.cod-colab AT ROW 1.47 COL 16 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11 BY .87
     c-nome-colab AT ROW 1.47 COL 27.33 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     tt-colab-salario-var.cod-rep AT ROW 2.47 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11 BY .87
     c-nome-rep AT ROW 2.47 COL 27.33 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     tt-colab-salario-var.fm-cod-com-ini AT ROW 3.47 COL 16 COLON-ALIGNED WIDGET-ID 12
          LABEL "Fam°lia Comercial"
          VIEW-AS FILL-IN 
          SIZE 14 BY .87
     tt-colab-salario-var.fm-cod-com-fim AT ROW 3.47 COL 43.89 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 14 BY .87
     tt-colab-salario-var.dt-vigencia-ini AT ROW 4.47 COL 16 COLON-ALIGNED WIDGET-ID 8
          LABEL "Data Vigància"
          VIEW-AS FILL-IN 
          SIZE 14 BY .87
     tt-colab-salario-var.dt-vigencia-fim AT ROW 4.47 COL 43.89 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 14 BY .87
     tt-colab-salario-var.pc-variavel AT ROW 5.47 COL 16 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 10 BY .87
     tt-colab-salario-var.vl-teto AT ROW 6.47 COL 16 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .87
     tt-colab-salario-var.vl-fixo AT ROW 7.47 COL 16 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .87
     tt-colab-salario-var.obs AT ROW 8.47 COL 18 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR MAX-CHARS 300 SCROLLBAR-VERTICAL
          SIZE 68.56 BY 4.13
     btOK AT ROW 13.2 COL 2
     btCancel AT ROW 13.2 COL 13
     btHelp2 AT ROW 13.2 COL 80
     text-1 AT ROW 8.53 COL 5.78 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     rtToolBar AT ROW 12.97 COL 1
     IMAGE-1 AT ROW 3.53 COL 34.33 WIDGET-ID 28
     IMAGE-2 AT ROW 3.53 COL 40.67 WIDGET-ID 30
     IMAGE-3 AT ROW 4.53 COL 34.33 WIDGET-ID 52
     IMAGE-4 AT ROW 4.53 COL 40.67 WIDGET-ID 54
     RECT-1 AT ROW 1.2 COL 1.56 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.47
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-colab-salario-var T "?" NO-UNDO mgesp colab-salario-var
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Inclui/Modifica Sal†rio Vari†vel"
         HEIGHT             = 13.47
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-colab-salario-var.dt-vigencia-ini IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-colab-salario-var.fm-cod-com-ini IN FRAME fPage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Inclui/Modifica Sal†rio Vari†vel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Sal†rio Vari†vel */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-salario-var.cod-colab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.cod-colab wWindow
ON LEAVE OF tt-colab-salario-var.cod-colab IN FRAME fPage0 /* Colaborador */
DO:
    ASSIGN INPUT FRAME fPage0 tt-colab-salario-var.cod-colab.

    FIND FIRST emsfnd.usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = tt-colab-salario-var.cod-colab NO-ERROR.

    ASSIGN c-nome-colab = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

    DISPLAY c-nome-colab
        WITH FRAME fPage0.

    RUN pi-sugerir-valores IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-salario-var.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.cod-rep wWindow
ON F5 OF tt-colab-salario-var.cod-rep IN FRAME fPage0 /* Representante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad229.w"
                       &campo="tt-colab-salario-var.cod-rep"
                       &campozoom="cod-rep"
                       &frame="fPage0"
                       &campo2="c-nome-rep"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.cod-rep wWindow
ON LEAVE OF tt-colab-salario-var.cod-rep IN FRAME fPage0 /* Representante */
DO:
    ASSIGN INPUT FRAME fPage0 tt-colab-salario-var.cod-rep.

    FIND FIRST repres NO-LOCK
        WHERE  repres.cod-rep = tt-colab-salario-var.cod-rep NO-ERROR.

    ASSIGN c-nome-rep = IF AVAIL repres THEN repres.nome-abrev + " - " + repres.nome ELSE "".

    DISPLAY c-nome-rep
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.cod-rep wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-colab-salario-var.cod-rep IN FRAME fPage0 /* Representante */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-salario-var.fm-cod-com-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.fm-cod-com-fim wWindow
ON F5 OF tt-colab-salario-var.fm-cod-com-fim IN FRAME fPage0 /* fm-cod-com-fim */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z01di050.w"
                       &campo="tt-colab-salario-var.fm-cod-com-fim"
                       &campozoom="fm-cod-com"
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.fm-cod-com-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-colab-salario-var.fm-cod-com-fim IN FRAME fPage0 /* fm-cod-com-fim */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-salario-var.fm-cod-com-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.fm-cod-com-ini wWindow
ON F5 OF tt-colab-salario-var.fm-cod-com-ini IN FRAME fPage0 /* Fam°lia Comercial */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z01di050.w"
                       &campo="tt-colab-salario-var.fm-cod-com-ini"
                       &campozoom="fm-cod-com"
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-salario-var.fm-cod-com-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-colab-salario-var.fm-cod-com-ini IN FRAME fPage0 /* Fam°lia Comercial */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
tt-colab-salario-var.cod-rep:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fPage0.
tt-colab-salario-var.fm-cod-com-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-colab-salario-var.fm-cod-com-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{window/mainblock.i}

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

    CREATE tt-colab-salario-var.

    ENABLE tt-colab-salario-var.cod-colab
           tt-colab-salario-var.cod-rep
           tt-colab-salario-var.fm-cod-com-ini
           tt-colab-salario-var.fm-cod-com-fim
           tt-colab-salario-var.dt-vigencia-ini
           tt-colab-salario-var.dt-vigencia-fim
           tt-colab-salario-var.pc-variavel
           tt-colab-salario-var.vl-teto
           tt-colab-salario-var.vl-fixo
           tt-colab-salario-var.obs
        WITH FRAME fPage0.

    IF  pAcao = "Inclui" THEN DO:
        ASSIGN tt-colab-salario-var.dt-vigencia-ini = DATE(MONTH(TODAY), 01, YEAR(TODAY))
               tt-colab-salario-var.dt-vigencia-fim = ADD-INTERVAL(tt-colab-salario-var.dt-vigencia-ini, 1, "month") - 1.
    END.
    ELSE DO: /* Alteraá∆o ou C¢pia */
        FIND FIRST colab-salario-var NO-LOCK
            WHERE  ROWID(colab-salario-var) = pRowid NO-ERROR.
        IF  AVAIL  colab-salario-var THEN DO:
            BUFFER-COPY colab-salario-var TO tt-colab-salario-var.
            ASSIGN tt-colab-salario-var.r-rowid = ROWID(colab-salario-var).
        END.

        IF  pAcao = "Modifica" THEN
            DISABLE tt-colab-salario-var.cod-colab
                    tt-colab-salario-var.cod-rep
                    tt-colab-salario-var.fm-cod-com-ini
                    tt-colab-salario-var.dt-vigencia-ini
                WITH FRAME fPage0.
    END.

    DISPLAY tt-colab-salario-var.cod-colab
            tt-colab-salario-var.cod-rep
            tt-colab-salario-var.fm-cod-com-ini
            tt-colab-salario-var.fm-cod-com-fim
            tt-colab-salario-var.dt-vigencia-ini
            tt-colab-salario-var.dt-vigencia-fim
            tt-colab-salario-var.pc-variavel
            tt-colab-salario-var.vl-teto
            tt-colab-salario-var.vl-fixo
            tt-colab-salario-var.obs
            text-1
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO tt-colab-salario-var.cod-colab IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-colab-salario-var.cod-rep   IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0 tt-colab-salario-var.cod-colab
           INPUT FRAME fPage0 tt-colab-salario-var.cod-rep
           INPUT FRAME fPage0 tt-colab-salario-var.fm-cod-com-ini
           INPUT FRAME fPage0 tt-colab-salario-var.fm-cod-com-fim
           INPUT FRAME fPage0 tt-colab-salario-var.dt-vigencia-ini
           INPUT FRAME fPage0 tt-colab-salario-var.dt-vigencia-fim
           INPUT FRAME fPage0 tt-colab-salario-var.pc-variavel
           INPUT FRAME fPage0 tt-colab-salario-var.vl-teto
           INPUT FRAME fPage0 tt-colab-salario-var.vl-fixo
           INPUT FRAME fPage0 tt-colab-salario-var.obs.

    EMPTY TEMP-TABLE rowErrors.

    RUN pi-validar IN THIS-PROCEDURE.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}

        RETURN "NOK":U.
    END.

    /* Criaá∆o ou C¢pia */
    IF  pAcao <> "Modifica" THEN DO:
        CREATE colab-salario-var.
        ASSIGN colab-salario-var.cod-colab       = tt-colab-salario-var.cod-colab
               colab-salario-var.fm-cod-com-ini  = tt-colab-salario-var.fm-cod-com-ini
               colab-salario-var.dt-vigencia-ini = tt-colab-salario-var.dt-vigencia-ini.
    END.
    ELSE DO: /* Alteraá∆o */
        FIND FIRST colab-salario-var EXCLUSIVE-LOCK
            WHERE ROWID(colab-salario-var) = tt-colab-salario-var.r-rowid NO-ERROR.
        IF  NOT AVAIL colab-salario-var THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Sal†rio Vari†vel do colaborador n∆o localizado!~~Sal†rio Vari†vel do colaborador n∆o foi localizado, por isso a alteraá∆o n∆o ser† efetivada.":U).
            RETURN "NOK":U.
        END.
    END.


    BUFFER-COPY tt-colab-salario-var EXCEPT cod-colab fm-cod-com-ini dt-vigencia-ini TO colab-salario-var.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugerir-valores wWindow 
PROCEDURE pi-sugerir-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 tt-colab-salario-var.cod-colab.

    FIND LAST colab-salario-var NO-LOCK
        WHERE colab-salario-var.cod-colab = tt-colab-salario-var.cod-colab NO-ERROR.
    IF  AVAIL colab-salario-var THEN DO:
        ASSIGN tt-colab-salario-var.vl-teto = colab-salario-var.vl-teto
               tt-colab-salario-var.vl-fixo = colab-salario-var.vl-fixo.
    END.

    DISPLAY tt-colab-salario-var.vl-teto
            tt-colab-salario-var.vl-fixo
        WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar wWindow 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  tt-colab-salario-var.cod-colab = "" THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Colaborador n∆o informado!"
               rowErrors.ErrorHelp        = "C¢digo do colaborador deve ser informado.".
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST emsfnd.usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuar = tt-colab-salario-var.cod-colab) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Colaborador n∆o encontrado!"
                   rowErrors.ErrorHelp        = "N∆o foi poss°vel encontrar uma ocorrància de colaborador para o c¢digo informado.".
        END.
    END.

    IF  tt-colab-salario-var.cod-rep = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Representante n∆o informado!"
               rowErrors.ErrorHelp        = "C¢digo do representante deve ser informado.".
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST repres NO-LOCK
                         WHERE repres.cod-rep = tt-colab-salario-var.cod-rep) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Representante n∆o encontrado!"
                   rowErrors.ErrorHelp        = "N∆o foi poss°vel encontrar uma ocorrància de representante para o c¢digo informado.".
        END.
    END.

    IF  tt-colab-salario-var.dt-vigencia-ini = ? THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Data de vigància inicial inv†lida!"
               rowErrors.ErrorHelp        = "Data de vigància inicial deve ser uma data v†lida.".
    END.

    IF  tt-colab-salario-var.dt-vigencia-ini > tt-colab-salario-var.dt-vigencia-fim THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixa de vigància incorreta!"
               rowErrors.ErrorHelp        = "Data inicial da vigància deve ser menor ou igual a data de vigància final.".
    END.

    IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                 WHERE colab-salario-var.cod-colab       = tt-colab-salario-var.cod-colab
                 AND   colab-salario-var.dt-vigencia-fim = ?
                 AND   ROWID(colab-salario-var)         <> tt-colab-salario-var.r-rowid) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixa de vigància em aberto para o colaborador!"
               rowErrors.ErrorHelp        = "Existe uma faixa de vigància em aberto para este colaborador.".
    END.

    IF  tt-colab-salario-var.pc-variavel <= 0   OR
        tt-colab-salario-var.pc-variavel > 100 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Percentual vari†vel Ç inv†lido!"
               rowErrors.ErrorHelp        = "O percentual vari†vel dever ser maior que 0 (zero) e menor ou igual a 100.".
    END.

    IF  tt-colab-salario-var.vl-teto = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Valor de teto n∆o informado!"
               rowErrors.ErrorHelp        = "O valor de teto deve ser informado e diferente de 0 (zero).".
    END.

    IF  tt-colab-salario-var.vl-fixo = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Valor fixo n∆o informado!"
               rowErrors.ErrorHelp        = "O valor fixo deve ser informado e diferente de 0 (zero).".
    END.
    
    IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                 WHERE colab-salario-var.cod-colab        = tt-colab-salario-var.cod-colab
                 AND  ((colab-salario-var.fm-cod-com-ini >= tt-colab-salario-var.fm-cod-com-ini OR
                        colab-salario-var.fm-cod-com-fim >= tt-colab-salario-var.fm-cod-com-ini)
                        OR
                       (colab-salario-var.fm-cod-com-ini >= tt-colab-salario-var.fm-cod-com-fim OR
                        colab-salario-var.fm-cod-com-fim >= tt-colab-salario-var.fm-cod-com-fim))
                 AND   ((colab-salario-var.dt-vigencia-ini >= tt-colab-salario-var.dt-vigencia-ini OR
                        colab-salario-var.dt-vigencia-fim >= tt-colab-salario-var.dt-vigencia-ini)
                        OR
                       (colab-salario-var.dt-vigencia-ini >= tt-colab-salario-var.dt-vigencia-fim OR
                        colab-salario-var.dt-vigencia-fim >= tt-colab-salario-var.dt-vigencia-fim))
                 AND   ROWID(colab-salario-var) <> tt-colab-salario-var.r-rowid) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixas de vigància e/ou Fam Comerc em conflito com outro registro do colaborador!"
               rowErrors.ErrorHelp        = "A faixa de vigància e/ou fam°lia comercial informada est† em conflito com outro cadastro j† feito para este colaborador.".
    END.

    /* Criaá∆o ou C¢pia */
    IF  pAcao <> "Modifica" THEN DO:
        IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                     WHERE colab-salario-var.cod-colab       = tt-colab-salario-var.cod-colab
                     AND   colab-salario-var.cod-rep         = tt-colab-salario-var.cod-rep
                     AND   colab-salario-var.fm-cod-com-ini  = tt-colab-salario-var.fm-cod-com-ini
                     AND   colab-salario-var.dt-vigencia-ini = tt-colab-salario-var.dt-vigencia-ini) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "J† existe uma ocorrància de Sal†rio Vari†vel cadastrada para o Colaborador!"
                   rowErrors.ErrorHelp        = "Sal†rio vari†vel do colaborado j† est† cadastrado para o representante, fam°lia comercial e vigància.".
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

