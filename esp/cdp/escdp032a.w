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
{include/i-prgvrs.i ESCDP032A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP032A
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
i-cd-unid-comerc c-ds-unid-comerc i-cod-emitente c-nm-emit c-it-codigo ~
c-desc-item dt-vigencia-ini dt-vigencia-fim de-pc-desconto ed-obs btOK ~
btSalvar btCancel text-obs 
&Scoped-Define DISPLAYED-OBJECTS i-cd-unid-comerc c-ds-unid-comerc ~
i-cod-emitente c-nm-emit c-it-codigo c-desc-item dt-vigencia-ini ~
dt-vigencia-fim de-pc-desconto ed-obs text-obs 

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

DEFINE VARIABLE ed-obs AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 69 BY 3.25 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(8)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-nm-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-pc-desconto AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Percentual Desconto" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vigencia-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Vigˆncia" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE text-obs AS CHARACTER FORMAT "X(256)":U INITIAL "Observa‡Æo:" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

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
     SIZE 89 BY 7.83.

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
     c-nm-emit AT ROW 2.88 COL 28.14 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 38
     c-it-codigo AT ROW 3.88 COL 18 COLON-ALIGNED HELP
          "C¢digo do Item" WIDGET-ID 18
     c-desc-item AT ROW 3.88 COL 36.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     dt-vigencia-ini AT ROW 4.88 COL 18 COLON-ALIGNED HELP
          "Data de vigˆncia inicial" WIDGET-ID 22
     dt-vigencia-fim AT ROW 4.88 COL 41 COLON-ALIGNED HELP
          "Data de Vigˆncia Inicial" NO-LABEL WIDGET-ID 24
     de-pc-desconto AT ROW 5.88 COL 18 COLON-ALIGNED HELP
          "Percentual de Desconto" WIDGET-ID 42
     ed-obs AT ROW 7 COL 20 NO-LABEL WIDGET-ID 44
     btOK AT ROW 10.79 COL 2
     btSalvar AT ROW 10.79 COL 12.43 WIDGET-ID 40
     btCancel AT ROW 10.79 COL 22.86
     text-obs AT ROW 7 COL 8.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     rtToolBar AT ROW 10.58 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     IMAGE-1 AT ROW 4.92 COL 31.86 WIDGET-ID 28
     IMAGE-2 AT ROW 4.92 COL 38.14 WIDGET-ID 30
     RECT-5 AT ROW 2.67 COL 1.43 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.08
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
         TITLE              = "Inclui/Modifica Desconto por Cliente x Item"
         HEIGHT             = 11.04
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
ON END-ERROR OF wWindow /* Inclui/Modifica Desconto por Cliente x Item */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Desconto por Cliente x Item */
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


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fPage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="c-it-codigo"
                       &campozoom="it-codigo"
                       &frame="fpage0"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &frame2="fpage0"}
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fPage0 /* Item */
DO:
    ASSIGN INPUT FRAME fPage0 c-it-codigo.

    FIND FIRST ITEM NO-LOCK
        WHERE  ITEM.it-codigo = c-it-codigo NO-ERROR.

    ASSIGN c-desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE "".

    DISP c-desc-item WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fPage0 /* Item */
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


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente wWindow
ON F5 OF i-cod-emitente IN FRAME fPage0 /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo="i-cod-emitente"
                       &campozoom="cod-emitente"
                       &frame="fPage0"
                       &campo2="c-nm-emit"
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

    ASSIGN c-nm-emit = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

    DISP c-nm-emit WITH FRAME fPage0.
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
i-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.

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
                   c-it-codigo
                   dt-vigencia-ini
                   btSalvar
                WITH FRAME fPage0.
        END.
        WHEN "Update":U OR
        WHEN "Copy":U   THEN DO:
            FIND FIRST crm-desc-cli NO-LOCK
                WHERE  ROWID(crm-desc-cli) = pRow-table NO-ERROR.
            IF  AVAIL  crm-desc-cli THEN
                ASSIGN i-cod-emitente  = crm-desc-cli.cod-emitente
                       c-it-codigo    = crm-desc-cli.it-codigo
                       dt-vigencia-ini = crm-desc-cli.dt-vigencia-ini
                       dt-vigencia-fim = crm-desc-cli.dt-vigencia-fim
                       de-pc-desconto  = crm-desc-cli.pc-desconto
                       ed-obs          = crm-desc-cli.observacao.

            IF  pType = "Copy" THEN
                ENABLE i-cod-emitente
                       c-it-codigo
                       dt-vigencia-ini
                       btSalvar
                   WITH FRAME fPage0.
        END.
        OTHERWISE .
    END CASE.

    ENABLE dt-vigencia-fim
           de-pc-desconto
           ed-obs
        WITH FRAME fPage0.

    DISP i-cd-unid-comerc
         i-cod-emitente
         c-it-codigo
         dt-vigencia-ini
         dt-vigencia-fim
         de-pc-desconto
         ed-obs
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-emitente   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-it-codigo     IN FRAME fPage0.
    
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
           INPUT FRAME fPage0 c-it-codigo
           INPUT FRAME fPage0 dt-vigencia-ini
           INPUT FRAME fPage0 dt-vigencia-fim
           INPUT FRAME fPage0 de-pc-desconto
           INPUT FRAME fPage0 ed-obs.

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    CASE pType:
        WHEN "Create":U OR
        WHEN "Copy":U   THEN DO:
            CREATE crm-desc-cli.
            ASSIGN crm-desc-cli.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                   crm-desc-cli.cod-emitente    = i-cod-emitente
                   crm-desc-cli.it-codigo      = c-it-codigo
                   crm-desc-cli.dt-vigencia-ini = dt-vigencia-ini.
        END.
        WHEN "Update":U THEN DO:
            FIND FIRST crm-desc-cli EXCLUSIVE-LOCK
                WHERE  ROWID(crm-desc-cli) = pRow-table NO-ERROR.
            IF  NOT AVAIL crm-desc-cli THEN
                RETURN "NOK":U.
        END.
        OTHERWISE .
    END CASE.

    ASSIGN crm-desc-cli.dt-vigencia-fim = dt-vigencia-fim
           crm-desc-cli.pc-desconto     = de-pc-desconto
           crm-desc-cli.observacao      = ed-obs.

    /* Retorna o Rowid do registro Criado/Alterado */
    ASSIGN pRow-table = ROWID(crm-desc-cli).

    /* Grava a data inicial na data final da £ltima vigˆncia da UN x Cliente x Tab Pre‡o */
    FIND LAST crm-desc-cli EXCLUSIVE-LOCK
        WHERE crm-desc-cli.cd-unid-negoc   = STRING(i-cd-unid-comerc)
        AND   crm-desc-cli.cod-emitente    = i-cod-emitente
        AND   crm-desc-cli.it-codigo      = c-it-codigo
        AND   crm-desc-cli.dt-vigencia-ini < dt-vigencia-ini NO-ERROR.
    IF  AVAIL crm-desc-cli AND crm-desc-cli.dt-vigencia-fim = ? THEN
        ASSIGN crm-desc-cli.dt-vigencia-fim = dt-vigencia-ini.

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

        IF  NOT CAN-FIND(FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = c-it-codigo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Item":U).

            APPLY "ENTRY":U TO c-it-codigo IN FRAME fPage0.
            RETURN "NOK":U.
        END.


        IF  dt-vigencia-ini = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Data de vigˆncia Inicial inv lida!~~Informe uma data de Vigˆncia Inicial v lida.":U).

            APPLY "ENTRY":U TO dt-vigencia-ini IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST crm-desc-cli NO-LOCK
                     WHERE crm-desc-cli.cd-unid-negoc   = STRING(i-cd-unid-comerc)
                     AND   crm-desc-cli.cod-emitente    = i-cod-emitente
                     AND   crm-desc-cli.it-codigo       = c-it-codigo
                     AND   crm-desc-cli.dt-vigencia-ini = dt-vigencia-ini) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Desconto por Cliente x Item":U).

            APPLY "ENTRY":U TO i-cod-emitente IN FRAME fPage0.
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

    ASSIGN i-cod-emitente  = 0
           c-it-codigo    = ""
           dt-vigencia-ini = TODAY
           dt-vigencia-fim = ?
           de-pc-desconto  = 0
           ed-obs          = "".

    DISPLAY i-cod-emitente
            c-it-codigo
            dt-vigencia-ini
            dt-vigencia-fim
            de-pc-desconto
            ed-obs
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cod-emitente   IN FRAME fPage0.
    APPLY "LEAVE":U TO c-it-codigo     IN FRAME fPage0.
    APPLY "ENTRY":U TO i-cod-emitente   IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

