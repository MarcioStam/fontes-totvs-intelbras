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
{include/i-prgvrs.i ESCDP035A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP035A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pType           AS CHARACTER   NO-UNDO. /* Create or Update */
DEFINE INPUT  PARAMETER pCd-unid-comerc AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pRow-table      AS ROWID       NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-5 IMAGE-1 IMAGE-2 ~
i-cd-unid-comerc c-ds-unid-comerc i-cod-gr-cli c-ds-gr-cli i-cd-categoria ~
c-ds-categoria dt-vigencia-ini dt-vigencia-fim de-vl-minimo btOK btSalvar ~
btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-cd-unid-comerc c-ds-unid-comerc ~
i-cod-gr-cli c-ds-gr-cli i-cd-categoria c-ds-categoria dt-vigencia-ini ~
dt-vigencia-fim de-vl-minimo 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-ds-categoria AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 50.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-gr-cli AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 50.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-minimo AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor M¡nimo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Vigˆncia" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-categoria AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-cli AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     i-cd-unid-comerc AT ROW 1.42 COL 18 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial" WIDGET-ID 14
     c-ds-unid-comerc AT ROW 1.42 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     i-cod-gr-cli AT ROW 2.88 COL 18 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cliente" WIDGET-ID 34
     c-ds-gr-cli AT ROW 2.88 COL 25.29 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 38
     i-cd-categoria AT ROW 3.88 COL 18 COLON-ALIGNED HELP
          "C¢digo da Categoria" WIDGET-ID 18
     c-ds-categoria AT ROW 3.88 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     dt-vigencia-ini AT ROW 4.88 COL 18 COLON-ALIGNED HELP
          "Data de vigˆncia inicial" WIDGET-ID 22
     dt-vigencia-fim AT ROW 4.88 COL 41 COLON-ALIGNED HELP
          "Data de Vigˆncia Inicial" NO-LABEL WIDGET-ID 24
     de-vl-minimo AT ROW 5.88 COL 18 COLON-ALIGNED HELP
          "Valor M¡nimo" WIDGET-ID 42
     btOK AT ROW 7.33 COL 2
     btSalvar AT ROW 7.33 COL 12.43 WIDGET-ID 40
     btCancel AT ROW 7.33 COL 22.86
     rtToolBar AT ROW 7.13 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     RECT-5 AT ROW 2.67 COL 1.43 WIDGET-ID 32
     IMAGE-1 AT ROW 4.92 COL 31.86 WIDGET-ID 48
     IMAGE-2 AT ROW 4.92 COL 38.14 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.63
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
         TITLE              = "Inclui/Modifica Desconto M¡nimo por Grupo de Cliente x Categoria"
         HEIGHT             = 7.63
         WIDTH              = 90
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.33
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
ON END-ERROR OF wWindow /* Inclui/Modifica Desconto M¡nimo por Grupo de Cliente x Categoria */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Desconto M¡nimo por Grupo de Cliente x Categoria */
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


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fPage0 /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        RUN pi-zerar-dados IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-categoria wWindow
ON F5 OF i-cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es547.w"
                         &FieldZoom1="cd-categoria"
                         &FieldScreen1="i-cd-categoria"
                         &Frame1="fPage0"
                         &FieldZoom2="ds-categoria"
                         &FieldScreen2="c-ds-categoria"
                         &Frame2="fPage0"
                         &RunMethod="RUN setUnidNegoc IN hProgramZoom (INPUT INPUT FRAME fPage0 i-cd-unid-comerc)."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-categoria wWindow
ON LEAVE OF i-cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    ASSIGN INPUT FRAME fPage0 i-cd-categoria.

    FIND FIRST crm-categoria NO-LOCK
        WHERE  crm-categoria.cd-categoria = i-cd-categoria NO-ERROR.

    ASSIGN c-ds-categoria = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "".

    DISP c-ds-categoria WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-categoria wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-unid-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-unid-comerc wWindow
ON LEAVE OF i-cd-unid-comerc IN FRAME fPage0 /* Unid Comercial */
DO:
    ASSIGN INPUT FRAME fPage0 i-cd-unid-comerc.

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = i-cd-unid-comerc NO-ERROR.
           
    ASSIGN c-ds-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    DISPLAY c-ds-unid-comerc WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli wWindow
ON F5 OF i-cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad129.w"
                       &campo="i-cod-gr-cli"
                       &campozoom="cod-gr-cli"
                       &frame="fPage0"
                       &campo2="c-ds-gr-cli"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli wWindow
ON LEAVE OF i-cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    ASSIGN INPUT FRAME fPage0 i-cod-gr-cli.

    FIND FIRST gr-cli NO-LOCK
        WHERE  gr-cli.cod-gr-cli = i-cod-gr-cli NO-ERROR.

    ASSIGN c-ds-gr-cli = IF AVAIL gr-cli THEN gr-cli.descricao ELSE "".

    DISP c-ds-gr-cli WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
i-cod-gr-cli:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.
i-cd-categoria:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-cd-unid-comerc = pCd-unid-comerc.

    CASE pType:
        WHEN "Create":U THEN DO:
            ASSIGN dt-vigencia-ini = TODAY.

            ENABLE i-cod-gr-cli
                   i-cd-categoria
                   dt-vigencia-ini
                   btSalvar
                WITH FRAME fPage0.
        END.
        WHEN "Update":U OR
        WHEN "Copy":U   THEN DO:
            FIND FIRST crm-desc-ped-minimo NO-LOCK
                WHERE  ROWID(crm-desc-ped-minimo) = pRow-table NO-ERROR.
            IF  AVAIL  crm-desc-ped-minimo THEN
                ASSIGN i-cod-gr-cli    = crm-desc-ped-minimo.cod-gr-cli
                       i-cd-categoria  = crm-desc-ped-minimo.cd-categoria
                       dt-vigencia-ini = crm-desc-ped-minimo.dt-vigencia-ini
                       dt-vigencia-fim = crm-desc-ped-minimo.dt-vigencia-fim
                       de-vl-minimo    = crm-desc-ped-minimo.vl-minimo.

            IF  pType = "Copy" THEN
                ENABLE i-cod-gr-cli
                       i-cd-categoria
                       dt-vigencia-ini
                       btSalvar
                   WITH FRAME fPage0.
        END.
        OTHERWISE .
    END CASE.

    ENABLE dt-vigencia-fim
           de-vl-minimo
        WITH FRAME fPage0.

    DISP i-cd-unid-comerc
         i-cod-gr-cli
         i-cd-categoria
         dt-vigencia-ini
         dt-vigencia-fim
         de-vl-minimo
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-gr-cli     IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cd-categoria   IN FRAME fPage0.
    
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

    ASSIGN INPUT FRAME fPage0 i-cd-unid-comerc
           INPUT FRAME fPage0 i-cod-gr-cli
           INPUT FRAME fPage0 i-cd-categoria
           INPUT FRAME fPage0 dt-vigencia-ini
           INPUT FRAME fPage0 dt-vigencia-fim
           INPUT FRAME fPage0 de-vl-minimo.

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    CASE pType:
        WHEN "Create":U OR
        WHEN "Copy":U   THEN DO:
            CREATE crm-desc-ped-minimo.
            ASSIGN crm-desc-ped-minimo.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                   crm-desc-ped-minimo.cod-gr-cli      = i-cod-gr-cli
                   crm-desc-ped-minimo.cd-categoria    = i-cd-categoria
                   crm-desc-ped-minimo.dt-vigencia-ini = dt-vigencia-ini.
        END.
        WHEN "Update":U THEN DO:
            FIND FIRST crm-desc-ped-minimo EXCLUSIVE-LOCK
                WHERE  ROWID(crm-desc-ped-minimo) = pRow-table NO-ERROR.
            IF  NOT AVAIL crm-desc-ped-minimo THEN
                RETURN "NOK":U.
        END.
        OTHERWISE .
    END CASE.

    ASSIGN crm-desc-ped-minimo.dt-vigencia-fim = dt-vigencia-fim
           crm-desc-ped-minimo.vl-minimo       = de-vl-minimo.

    /* Grava a data inicial na data final da £ltima vigˆncia da UN x Cliente x Tab Pre‡o */
    FIND LAST crm-desc-ped-minimo EXCLUSIVE-LOCK
        WHERE crm-desc-ped-minimo.cd-unid-negoc   = STRING(i-cd-unid-comerc)
        AND   crm-desc-ped-minimo.cod-gr-cli      = i-cod-gr-cli
        AND   crm-desc-ped-minimo.cd-categoria    = i-cd-categoria
        AND   crm-desc-ped-minimo.dt-vigencia-ini < dt-vigencia-ini NO-ERROR.
    IF  AVAIL crm-desc-ped-minimo AND crm-desc-ped-minimo.dt-vigencia-fim = ? THEN
        ASSIGN crm-desc-ped-minimo.dt-vigencia-fim = dt-vigencia-ini.

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

    IF  pType = "Create":U OR
        pType = "Copy":U   THEN DO:
        IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                         WHERE gr-cli.cod-gr-cli = i-cod-gr-cli) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Grupo Cliente":U).

            APPLY "ENTRY":U TO i-cod-gr-cli IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                         WHERE crm-categoria.cd-categoria = i-cd-categoria) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Categoria":U).

            APPLY "ENTRY":U TO i-cd-categoria IN FRAME fPage0.
            RETURN "NOK":U.
        END.


        IF  dt-vigencia-ini = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de vigˆncia Inicial inv lida!~~Informe uma data de Vigˆncia Inicial v lida.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST crm-desc-ped-minimo NO-LOCK
                     WHERE crm-desc-ped-minimo.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                     AND   crm-desc-ped-minimo.cod-gr-cli      = i-cod-gr-cli
                     AND   crm-desc-ped-minimo.cd-categoria    = i-cd-categoria
                     AND   crm-desc-ped-minimo.dt-vigencia-ini = dt-vigencia-ini) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Desconto M¡nimo por Grupo de Cliente x Categoria":U).

            APPLY "ENTRY":U TO i-cod-gr-cli IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  NOT CAN-FIND(FIRST crm-categ-un NO-LOCK
                         WHERE crm-categ-un.cd-categoria  = i-cd-categoria
                         AND   crm-categ-un.cd-unid-negoc = STRING(i-cd-unid-comerc)) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Categoria nÆo est  relacionada com a Unidade Comercial!":U).

            APPLY "ENTRY":U TO i-cd-categoria IN FRAME fPage0.
            RETURN "NOK":U.
        END.
    END.

    IF  dt-vigencia-ini > dt-vigencia-fim THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Faixa de data inv lida!~~Faixa Inicial maior do que a Faixa Final.":U).

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    IF  de-vl-minimo = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Valor M¡nimo Zerado!~~Valor m¡nimo deve ser informado.":U).

        APPLY "ENTRY":U TO de-vl-minimo IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zerar-dados wWindow 
PROCEDURE pi-zerar-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-cod-gr-cli    = 0
           i-cd-categoria  = 0
           dt-vigencia-ini = TODAY
           dt-vigencia-fim = ?
           de-vl-minimo    = 0.

    DISPLAY i-cod-gr-cli
            i-cd-categoria
            dt-vigencia-ini
            dt-vigencia-fim
            de-vl-minimo
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-gr-cli     IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cd-categoria   IN FRAME fPage0.
    APPLY "ENTRY":U TO i-cod-gr-cli     IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

