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
{include/i-prgvrs.i ESCDP030A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP030A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pType           AS CHARACTER   NO-UNDO. /* Create or Update */
DEFINE INPUT        PARAMETER pCd-unid-comerc AS INTEGER     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pRow-table      AS ROWID       NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 IMAGE-1 IMAGE-2 RECT-5 ~
IMAGE-3 IMAGE-4 i-cd-unid-comerc c-ds-unid-comerc i-cod-gr-cli c-ds-gr-cli ~
i-cd-categoria c-ds-categoria c-fm-cod-com c-ds-fm-com dt-vigencia-ini ~
dt-vigencia-fim de-qtd-ini de-qtd-fim de-pc-desconto btOK btSalvar btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-cd-unid-comerc c-ds-unid-comerc ~
i-cod-gr-cli c-ds-gr-cli i-cd-categoria c-ds-categoria c-fm-cod-com ~
c-ds-fm-com dt-vigencia-ini dt-vigencia-fim de-qtd-ini de-qtd-fim ~
de-pc-desconto 

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
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-fm-com AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-gr-cli AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-cod-com AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-pc-desconto AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Percentual Desconto" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-fim AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-ini AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

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
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-cli AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 6.33.

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
     c-ds-gr-cli AT ROW 2.88 COL 28.14 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 38
     i-cd-categoria AT ROW 3.88 COL 18 COLON-ALIGNED HELP
          "C¢digo da Categoria" WIDGET-ID 18
     c-ds-categoria AT ROW 3.88 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     c-fm-cod-com AT ROW 4.88 COL 18 COLON-ALIGNED HELP
          "C¢digo da Fam¡lia Comercial" WIDGET-ID 44
     c-ds-fm-com AT ROW 4.88 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     dt-vigencia-ini AT ROW 5.88 COL 18 COLON-ALIGNED HELP
          "Data de vigˆncia inicial" WIDGET-ID 22
     dt-vigencia-fim AT ROW 5.88 COL 41 COLON-ALIGNED HELP
          "Data de Vigˆncia Inicial" NO-LABEL WIDGET-ID 24
     de-qtd-ini AT ROW 6.88 COL 18 COLON-ALIGNED HELP
          "Quantidade Inicial" WIDGET-ID 50
     de-qtd-fim AT ROW 6.88 COL 41 COLON-ALIGNED HELP
          "Quantidade Final" NO-LABEL WIDGET-ID 48
     de-pc-desconto AT ROW 7.88 COL 18 COLON-ALIGNED HELP
          "Percentual de Desconto" WIDGET-ID 42
     btOK AT ROW 9.38 COL 2
     btSalvar AT ROW 9.38 COL 12.43 WIDGET-ID 40
     btCancel AT ROW 9.38 COL 22.86
     rtToolBar AT ROW 9.17 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     IMAGE-1 AT ROW 5.92 COL 31.86 WIDGET-ID 28
     IMAGE-2 AT ROW 5.92 COL 38.14 WIDGET-ID 30
     RECT-5 AT ROW 2.67 COL 1.43 WIDGET-ID 32
     IMAGE-3 AT ROW 6.92 COL 31.86 WIDGET-ID 52
     IMAGE-4 AT ROW 6.92 COL 38.14 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.71
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
         TITLE              = "Inclui/Modifica Desconto por Quantidade por Unidade de Neg¢cio x Grupo de Cliente x Categoria"
         HEIGHT             = 9.63
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
ON END-ERROR OF wWindow /* Inclui/Modifica Desconto por Quantidade por Unidade de Neg¢cio x Grupo de Cliente x Categoria */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Desconto por Quantidade por Unidade de Neg¢cio x Grupo de Cliente x Categoria */
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


&Scoped-define SELF-NAME c-fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-cod-com wWindow
ON F5 OF c-fm-cod-com IN FRAME fPage0 /* Fam¡lia Comercial */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z01di050.w"
                       &campo="c-fm-cod-com"
                       &campozoom="fm-cod-com"
                       &frame="fPage0"
                       &campo2="c-ds-fm-com"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-cod-com wWindow
ON LEAVE OF c-fm-cod-com IN FRAME fPage0 /* Fam¡lia Comercial */
DO:
    ASSIGN INPUT FRAME fPage0 c-fm-cod-com.

    FIND FIRST fam-comerc NO-LOCK
        WHERE  fam-comerc.fm-cod-com = c-fm-cod-com NO-ERROR.
    
    ASSIGN c-ds-fm-com = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE "".

    DISP c-ds-fm-com WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-cod-com wWindow
ON MOUSE-SELECT-DBLCLICK OF c-fm-cod-com IN FRAME fPage0 /* Fam¡lia Comercial */
DO:
    APPLY "F5" TO SELF.
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
c-fm-cod-com:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.

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
                   c-fm-cod-com
                   dt-vigencia-ini
                   de-qtd-ini
                   btSalvar
                WITH FRAME fPage0.
        END.
        WHEN "Update":U OR
        WHEN "Copy":U   THEN DO:
            FIND FIRST crm-desc-qtd NO-LOCK
                WHERE  ROWID(crm-desc-qtd) = pRow-table NO-ERROR.
            IF  AVAIL  crm-desc-qtd THEN
                ASSIGN i-cod-gr-cli    = crm-desc-qtd.cod-gr-cli
                       i-cd-categoria  = crm-desc-qtd.cd-categoria
                       c-fm-cod-com    = crm-desc-qtd.fm-cod-com
                       dt-vigencia-ini = crm-desc-qtd.dt-vigencia-ini
                       dt-vigencia-fim = crm-desc-qtd.dt-vigencia-fim
                       de-qtd-ini      = crm-desc-qtd.qtd-ini
                       de-qtd-fim      = crm-desc-qtd.qtd-fim
                       de-pc-desconto  = crm-desc-qtd.pc-desconto.

            IF  pType = "Copy" THEN
                ENABLE i-cod-gr-cli
                       i-cd-categoria
                       c-fm-cod-com
                       dt-vigencia-ini
                       de-qtd-ini
                       btSalvar
                   WITH FRAME fPage0.
        END.
        OTHERWISE .
    END CASE.

    ENABLE dt-vigencia-fim
           de-qtd-fim
           de-pc-desconto
        WITH FRAME fPage0.

    DISP i-cd-unid-comerc
         i-cod-gr-cli
         i-cd-categoria
         c-fm-cod-com
         dt-vigencia-ini
         dt-vigencia-fim
         de-qtd-ini
         de-qtd-fim
         de-pc-desconto
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-gr-cli     IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cd-categoria   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-fm-cod-com     IN FRAME fPage0.
    
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
           INPUT FRAME fPage0 c-fm-cod-com
           INPUT FRAME fPage0 dt-vigencia-ini
           INPUT FRAME fPage0 dt-vigencia-fim
           INPUT FRAME fPage0 de-qtd-ini
           INPUT FRAME fPage0 de-qtd-fim
           INPUT FRAME fPage0 de-pc-desconto.

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    CASE pType:
        WHEN "Create":U OR
        WHEN "Copy":U   THEN DO:
            CREATE crm-desc-qtd.
            ASSIGN crm-desc-qtd.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                   crm-desc-qtd.cod-gr-cli      = i-cod-gr-cli
                   crm-desc-qtd.cd-categoria    = i-cd-categoria
                   crm-desc-qtd.fm-cod-com      = c-fm-cod-com
                   crm-desc-qtd.dt-vigencia-ini = dt-vigencia-ini
                   crm-desc-qtd.qtd-ini         = de-qtd-ini.
        END.
        WHEN "Update":U THEN DO:
            FIND FIRST crm-desc-qtd EXCLUSIVE-LOCK
                WHERE  ROWID(crm-desc-qtd) = pRow-table NO-ERROR.
            IF  NOT AVAIL crm-desc-qtd THEN
                RETURN "NOK":U.
        END.
        OTHERWISE .
    END CASE.

    ASSIGN crm-desc-qtd.dt-vigencia-fim = dt-vigencia-fim
           crm-desc-qtd.qtd-fim         = de-qtd-fim
           crm-desc-qtd.pc-desconto     = de-pc-desconto.

    /* Retorna o Rowid do registro Criado/Alterado */
    ASSIGN pRow-table = ROWID(crm-desc-qtd).

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

        IF  NOT CAN-FIND(FIRST fam-comerc NO-LOCK
                         WHERE fam-comerc.fm-cod-com = c-fm-cod-com) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Fam¡lia Comercial":U).

            APPLY "ENTRY":U TO c-fm-cod-com IN FRAME fPage0.
            RETURN "NOK":U.
        END.


        IF  dt-vigencia-ini = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de vigˆncia Inicial inv lida!~~Informe uma data de Vigˆncia Inicial v lida.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
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

        IF  CAN-FIND(FIRST crm-desc-qtd NO-LOCK
                     WHERE crm-desc-qtd.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                     AND   crm-desc-qtd.cod-gr-cli      = i-cod-gr-cli
                     AND   crm-desc-qtd.cd-categoria    = i-cd-categoria
                     AND   crm-desc-qtd.fm-cod-com      = c-fm-cod-com
                     AND   crm-desc-qtd.dt-vigencia-ini = dt-vigencia-ini
                     AND   crm-desc-qtd.qtd-ini         = de-qtd-ini) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Desconto por Quantidade por Unidade Comercial x Grupo Cliente x Categoria":U).

            APPLY "ENTRY":U TO i-cod-gr-cli IN FRAME fPage0.
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

    IF  de-qtd-ini > de-qtd-fim THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Faixa de Quantidade inv lida!~~Faixa Inicial maior do que a Faixa Final.":U).

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    IF  de-qtd-fim <= 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Quantidade Final zerada!~~Quantidade final deve ser diferente de 0 (zero).":U).

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    IF  de-pc-desconto < 0   OR
        de-pc-desconto > 100 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Percentual de Desconto inv lido!~~Percentual de desconto deve ser maior do que 0 (zero) ":U +
                                 "e menor que 100 (cem).":U).

        APPLY "ENTRY":U TO de-pc-desconto IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    IF  de-pc-desconto = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Percentual de Desconto Zerado!~~Percentual de desconto deve ser informado.":U).

        APPLY "ENTRY":U TO de-pc-desconto IN FRAME fPage0.
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
           c-fm-cod-com    = ""
           dt-vigencia-ini = TODAY
           dt-vigencia-fim = ?
           de-qtd-ini      = 0
           de-qtd-fim      = 0
           de-pc-desconto  = 0.

    DISPLAY i-cod-gr-cli
            i-cd-categoria
            c-fm-cod-com
            dt-vigencia-ini
            dt-vigencia-fim
            de-qtd-ini
            de-qtd-fim
            de-pc-desconto
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-gr-cli     IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cd-categoria   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-fm-cod-com     IN FRAME fPage0.
    APPLY "ENTRY":U TO i-cod-gr-cli     IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

