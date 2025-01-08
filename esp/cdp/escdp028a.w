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
{include/i-prgvrs.i ESCDP028A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP028A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT       PARAMETER pType           AS CHARACTER   NO-UNDO. /* Create or Update */
DEFINE INPUT       PARAMETER pCd-unid-comerc AS INTEGER     NO-UNDO.
DEFINE INPUT-OUTPU PARAMETER pRow-table      AS ROWID       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE r-rowid  AS ROWID       NO-UNDO.

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
i-cd-unid-comerc c-ds-unid-comerc i-cod-emitente c-nome-emit c-nr-tabpre ~
c-ds-tabpre i-cod-cond-pag c-ds-cond-pag dt-vigencia-ini dt-vigencia-fim ~
btOK btSalvar btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-cd-unid-comerc c-ds-unid-comerc ~
i-cod-emitente c-nome-emit c-nr-tabpre c-ds-tabpre i-cod-cond-pag ~
c-ds-cond-pag dt-vigencia-ini dt-vigencia-fim 

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

DEFINE VARIABLE c-ds-cond-pag AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-tabpre AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-tabpre AS CHARACTER FORMAT "x(08)" 
     LABEL "Tab Preáos" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Vigància" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Condiá∆o Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Cliente":R8 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

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
     i-cod-emitente AT ROW 2.88 COL 18 COLON-ALIGNED HELP
          "C¢digo do Cliente" WIDGET-ID 34
     c-nome-emit AT ROW 2.88 COL 28.14 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 38
     c-nr-tabpre AT ROW 3.88 COL 18 COLON-ALIGNED HELP
          "Tabela de Preáo" WIDGET-ID 18
     c-ds-tabpre AT ROW 3.88 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     i-cod-cond-pag AT ROW 4.88 COL 18 COLON-ALIGNED HELP
          "C¢digo da Condiá∆o de Pagamento" WIDGET-ID 44
     c-ds-cond-pag AT ROW 4.88 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     dt-vigencia-ini AT ROW 5.88 COL 18 COLON-ALIGNED HELP
          "Data de vigància inicial" WIDGET-ID 22
     dt-vigencia-fim AT ROW 5.88 COL 41 COLON-ALIGNED HELP
          "Data de Vigància Inicial" NO-LABEL WIDGET-ID 24
     btOK AT ROW 7.46 COL 2
     btSalvar AT ROW 7.46 COL 12.43 WIDGET-ID 40
     btCancel AT ROW 7.46 COL 22.86
     rtToolBar AT ROW 7.25 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     IMAGE-1 AT ROW 5.92 COL 31.86 WIDGET-ID 28
     IMAGE-2 AT ROW 5.92 COL 38.14 WIDGET-ID 30
     RECT-5 AT ROW 2.67 COL 1.43 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.75
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
         TITLE              = "Inclui/Modifica Unidade de Neg¢cio x Tabela de Preáo"
         HEIGHT             = 7.75
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
ON END-ERROR OF wWindow /* Inclui/Modifica Unidade de Neg¢cio x Tabela de Preáo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Unidade de Neg¢cio x Tabela de Preáo */
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


&Scoped-define SELF-NAME c-nr-tabpre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre wWindow
ON F5 OF c-nr-tabpre IN FRAME fPage0 /* Tab Preáos */
DO:
    ASSIGN l-implanta = YES.
    {include/zoomvar.i &prog-zoom="dizoom/z01di189.w"
                       &campo="c-nr-tabpre"
                       &campozoom="nr-tabpre"
                       &frame="fPage0"
                       &campo2="c-ds-tabpre"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre wWindow
ON LEAVE OF c-nr-tabpre IN FRAME fPage0 /* Tab Preáos */
DO:
    ASSIGN INPUT FRAME fPage0 c-nr-tabpre.

    FIND FIRST tb-preco NO-LOCK
        WHERE  tb-preco.nr-tabpre = c-nr-tabpre NO-ERROR.

    ASSIGN c-ds-tabpre = IF AVAIL tb-preco THEN tb-preco.descricao ELSE "".

    DISP c-ds-tabpre WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre wWindow
ON MOUSE-SELECT-DBLCLICK OF c-nr-tabpre IN FRAME fPage0 /* Tab Preáos */
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


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wWindow
ON F5 OF i-cod-cond-pag IN FRAME fPage0 /* Condiá∆o Pagamento */
DO:
    ASSIGN l-implanta = YES.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                       &campo="i-cod-cond-pag"
                       &campozoom="cod-cond-pag"
                       &frame="fPage0"
                       &campo2="c-ds-cond-pag"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wWindow
ON LEAVE OF i-cod-cond-pag IN FRAME fPage0 /* Condiá∆o Pagamento */
DO:
    ASSIGN INPUT FRAME fPage0 i-cod-cond-pag.

    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = i-cod-cond-pag NO-ERROR.

    ASSIGN c-ds-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".

    DISP c-ds-cond-pag WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME fPage0 /* Condiá∆o Pagamento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wWindow
ON F5 OF i-cod-emitente IN FRAME fPage0 /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo="i-cod-emitente"
                       &campozoom="cod-emitente"
                       &frame="fPage0"
                       &campo2="c-nome-emit"
                       &campozoom2="nome-emit"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wWindow
ON LEAVE OF i-cod-emitente IN FRAME fPage0 /* Cliente */
DO:
    ASSIGN INPUT FRAME fPage0 i-cod-emitente.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = i-cod-emitente NO-ERROR.

    ASSIGN c-nome-emit = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

    DISPLAY c-nome-emit
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente IN FRAME fPage0 /* Cliente */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
i-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
c-nr-tabpre:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0.
i-cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

            ENABLE i-cod-emitente
                   c-nr-tabpre
                   dt-vigencia-ini
                   btSalvar
                WITH FRAME fPage0.
        END.
        WHEN "Update":U OR
        WHEN "Copy":U   THEN DO:
            FIND FIRST crm-un-cli-tb-preco NO-LOCK
                WHERE  ROWID(crm-un-cli-tb-preco) = pRow-table NO-ERROR.
            IF  AVAIL  crm-un-cli-tb-preco THEN
                ASSIGN i-cod-emitente  = crm-un-cli-tb-preco.cod-emitente
                       c-nr-tabpre     = crm-un-cli-tb-preco.nr-tabpre
                       i-cod-cond-pag  = crm-un-cli-tb-preco.cod-cond-pag
                       dt-vigencia-ini = crm-un-cli-tb-preco.dt-vigencia-ini
                       dt-vigencia-fim = crm-un-cli-tb-preco.dt-vigencia-fim.

            IF  pType = "Copy" THEN
                ENABLE i-cod-emitente
                       c-nr-tabpre
                       dt-vigencia-ini
                       btSalvar
                   WITH FRAME fPage0.
        END.
        OTHERWISE .
    END CASE.

    ENABLE i-cod-cond-pag
           dt-vigencia-fim
        WITH FRAME fPage0.

    DISP i-cd-unid-comerc
         i-cod-emitente
         c-nr-tabpre
         i-cod-cond-pag
         dt-vigencia-ini
         dt-vigencia-fim
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-emitente   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-nr-tabpre      IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-cond-pag   IN FRAME fPage0.
    
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
           INPUT FRAME fPage0 i-cod-emitente
           INPUT FRAME fPage0 c-nr-tabpre
           INPUT FRAME fPage0 i-cod-cond-pag
           INPUT FRAME fPage0 dt-vigencia-ini
           INPUT FRAME fPage0 dt-vigencia-fim.

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    CASE pType:
        WHEN "Create":U OR
        WHEN "Copy":U   THEN DO:
            CREATE crm-un-cli-tb-preco.
            ASSIGN crm-un-cli-tb-preco.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                   crm-un-cli-tb-preco.cod-emitente    = i-cod-emitente
                   crm-un-cli-tb-preco.nr-tabpre       = c-nr-tabpre
                   crm-un-cli-tb-preco.dt-vigencia-ini = dt-vigencia-ini.
        END.
        WHEN "Update":U THEN DO:
            FIND FIRST crm-un-cli-tb-preco EXCLUSIVE-LOCK
                WHERE  ROWID(crm-un-cli-tb-preco) = pRow-table NO-ERROR.
            IF  NOT AVAIL crm-un-cli-tb-preco THEN
                RETURN "NOK":U.
        END.
        OTHERWISE .
    END CASE.

    ASSIGN crm-un-cli-tb-preco.cod-cond-pag    = i-cod-cond-pag
           crm-un-cli-tb-preco.dt-vigencia-fim = dt-vigencia-fim
           r-rowid                             = ROWID(crm-un-cli-tb-preco).

    /* Retorna o Rowid do registro Criado/Alterado */
    ASSIGN pRow-table = ROWID(crm-un-cli-tb-preco).

    /* Grava a data inicial na data final da £ltima vigància da UN x Cliente x Tab Preáo */
    FIND LAST crm-un-cli-tb-preco EXCLUSIVE-LOCK
        WHERE crm-un-cli-tb-preco.cd-unid-negoc  = STRING(i-cd-unid-comerc)
        AND   crm-un-cli-tb-preco.cod-emitente   = i-cod-emitente
        AND   ROWID(crm-un-cli-tb-preco)        <> r-rowid NO-ERROR.
    IF  AVAIL crm-un-cli-tb-preco AND crm-un-cli-tb-preco.dt-vigencia-fim = ? THEN
        ASSIGN crm-un-cli-tb-preco.dt-vigencia-fim = dt-vigencia-ini.

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
        IF  NOT CAN-FIND(FIRST emitente NO-LOCK
                         WHERE emitente.cod-emitente = i-cod-emitente) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Cliente":U).

            APPLY "ENTRY":U TO i-cod-emitente IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  NOT CAN-FIND(FIRST tb-preco NO-LOCK
                         WHERE tb-preco.nr-tabpre = c-nr-tabpre) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Tabela de Preáo":U).

            APPLY "ENTRY":U TO c-nr-tabpre IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  dt-vigencia-ini = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de vigància Inicial inv†lida!~~Informe uma data de Vigància Inicial v†lida.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST crm-un-cli-tb-preco NO-LOCK
                     WHERE crm-un-cli-tb-preco.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                     AND   crm-un-cli-tb-preco.cod-emitente    = i-cod-emitente
                     AND   crm-un-cli-tb-preco.nr-tabpre       = c-nr-tabpre
                     AND   crm-un-cli-tb-preco.dt-vigencia-ini = dt-vigencia-ini ) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Unidade de Neg¢cio x Cliente x Tabela de Preáo":U).

            APPLY "ENTRY":U TO i-cod-emitente IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST crm-un-cli-tb-preco NO-LOCK
                     WHERE crm-un-cli-tb-preco.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                     AND   crm-un-cli-tb-preco.cod-emitente    = i-cod-emitente
                     AND   crm-un-cli-tb-preco.dt-vigencia-ini > dt-vigencia-ini) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de Vigància Inicial Inv†lida.~~Data de vigància inicial deve ser maior do que as vigàncias existentes.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
            RETURN "NOK":U.
        END.
    END.

    IF  i-cod-cond-pag <> 0 THEN DO:
        IF  NOT CAN-FIND(FIRST cond-pagto NO-LOCK
                         WHERE cond-pagto.cod-cond-pag = i-cod-cond-pag) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Condiá∆o de Pagamento":U).

            APPLY "ENTRY":U TO i-cod-cond-pag IN FRAME fPage0.
            RETURN "NOK":U.
        END.
    END.

    IF  dt-vigencia-ini > dt-vigencia-fim THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Faixa de data inv†lida!~~Faixa Inicial maior do que a Faixa Final.":U).

        APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
        RETURN "NOK":U.
    END.

    FIND FIRST tb-preco NO-LOCK
        WHERE  tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre NO-ERROR.
    IF  AVAIL  tb-preco THEN DO:
        IF  dt-vigencia-ini < tb-preco.dt-inival OR
            dt-vigencia-fim > tb-preco.dt-fimval THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Faixa de vigància inv†lida!~~A Faixa de data informada n∆o est† entre a faixa de ":U +
                                     "data informada no cadastro da Tabela de Preáo (CD1508).":U).
    
            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
            RETURN "NOK":U.
        END.
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

    ASSIGN i-cod-emitente  = 0
           c-nr-tabpre     = ""
           dt-vigencia-ini = TODAY
           dt-vigencia-fim = ?
           i-cod-cond-pag  = 0.

    DISPLAY i-cod-emitente
            c-nr-tabpre
            dt-vigencia-ini
            dt-vigencia-fim
            i-cod-cond-pag
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-emitente   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-nr-tabpre      IN FRAME fPage0.
    APPLY "ENTRY":U TO i-cod-emitente   IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

