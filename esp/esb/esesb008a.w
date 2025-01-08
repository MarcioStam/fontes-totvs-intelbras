&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esesb008a 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD l-provisao           AS LOG
    FIELD l-despesa            AS LOG
    FIELD l-rebate             AS LOG
    FIELD l-rebate-pos         AS LOG
    FIELD l-vmc                AS LOG
    FIELD l-stock              AS LOG
    FIELD l-backup             AS LOG
    FIELD l-showroom           AS LOG
    FIELD l-price              AS LOG
    FIELD c-unid-ini           AS CHAR
    FIELD c-unid-fim           AS CHAR
    FIELD c-class-ini          AS CHAR
    FIELD c-class-fim          AS CHAR
    FIELD l-ouro               AS LOG    
    FIELD l-prata              AS LOG
    FIELD l-bronze             AS LOG
    FIELD l-distribuidor       AS LOG
    FIELD l-Revenda-Solucoes   AS LOG
    FIELD l-Provedores         AS LOG
    FIELD l-ativo              AS LOG
    FIELD l-finalizado         AS LOG
    FIELD da-periodo-ini       AS DATE
    FIELD da-periodo-fim       AS DATE
    FIELD da-trans-ini         AS DATE
    FIELD da-trans-fim         AS DATE
    FIELD da-vencto-ini        AS DATE
    FIELD da-vencto-fim        AS DATE
    FIELD l-ok                 AS LOG.



DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-param.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-10 IMAGE-15 IMAGE-16 IMAGE-21 ~
IMAGE-22 IMAGE-23 IMAGE-24 RECT-116 IMAGE-25 IMAGE-26 RECT-117 RECT-118 ~
RECT-119 RECT-120 tg-ShowRoom tg-ouro tg-provisao tg-rebate tg-Price ~
tg-prata tg-despesa tg-rebate-pos tg-bronze tg-vmc tg-distribuidor tg-Stock ~
tg-Revenda-Solucoes tg-liberado tg-Backup tg-Provedores tg-finalizado ~
c-unidade-ini c-unidade-fim dt-periodo-ini dt-periodo-fim dt-trans-ini ~
dt-trans-fim dt-vencto-ini dt-vencto-fim bt-ok bt-restaura bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS tg-ShowRoom tg-ouro tg-provisao tg-rebate ~
tg-Price tg-prata tg-despesa tg-rebate-pos tg-bronze tg-vmc tg-distribuidor ~
tg-Stock tg-Revenda-Solucoes tg-liberado tg-Backup tg-Provedores ~
tg-finalizado c-unidade-ini c-unidade-fim dt-periodo-ini dt-periodo-fim ~
dt-trans-ini dt-trans-fim dt-vencto-ini dt-vencto-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Filtrar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-restaura 
     IMAGE-UP FILE "adeicon\export-u.bmp":U
     LABEL "Restaura Parƒmetros iniciais" 
     SIZE 10 BY 1 TOOLTIP "Restaurar Parametriza‡Æo inicial".

DEFINE VARIABLE c-unidade-fim AS CHARACTER FORMAT "x(6)":U INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-unidade-ini AS CHARACTER FORMAT "x(6)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2099 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/14 
     LABEL "Per¡odo de Apura‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-trans-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2099 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-trans-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/14 
     LABEL "Data de Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vencto-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2099 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vencto-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/14 
     LABEL "Data de Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 7.

DEFINE RECTANGLE RECT-116
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 5.

DEFINE RECTANGLE RECT-117
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 2.5.

DEFINE RECTANGLE RECT-118
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.57 BY 6.17.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 6.13.

DEFINE RECTANGLE RECT-120
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 2.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE tg-Backup AS LOGICAL INITIAL yes 
     LABEL "Stock Backup" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-bronze AS LOGICAL INITIAL yes 
     LABEL "Bronze" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-despesa AS LOGICAL INITIAL yes 
     LABEL "Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-distribuidor AS LOGICAL INITIAL yes 
     LABEL "Distribuidor" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-finalizado AS LOGICAL INITIAL no 
     LABEL "Finalizada" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tg-liberado AS LOGICAL INITIAL yes 
     LABEL "Ativa" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ouro AS LOGICAL INITIAL yes 
     LABEL "Ouro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prata AS LOGICAL INITIAL yes 
     LABEL "Prata" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Price AS LOGICAL INITIAL yes 
     LABEL "Price Protection" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Provedores AS LOGICAL INITIAL yes 
     LABEL "Provedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-provisao AS LOGICAL INITIAL no 
     LABEL "ProvisÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tg-rebate AS LOGICAL INITIAL yes 
     LABEL "Rebate" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-rebate-pos AS LOGICAL INITIAL yes 
     LABEL "Rebate P¢s-Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Revenda-Solucoes AS LOGICAL INITIAL yes 
     LABEL "Revenda Solu‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ShowRoom AS LOGICAL INITIAL yes 
     LABEL "Show Room" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Stock AS LOGICAL INITIAL yes 
     LABEL "Stock Rotation" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-vmc AS LOGICAL INITIAL yes 
     LABEL "V M C" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     tg-ShowRoom AT ROW 1.79 COL 39.86 WIDGET-ID 58
     tg-ouro AT ROW 2 COL 56.29 WIDGET-ID 36
     tg-provisao AT ROW 2.08 COL 4.43
     tg-rebate AT ROW 2.08 COL 22.43 WIDGET-ID 6
     tg-Price AT ROW 2.79 COL 39.86 WIDGET-ID 60
     tg-prata AT ROW 2.92 COL 56.29 WIDGET-ID 34
     tg-despesa AT ROW 3.08 COL 4.43
     tg-rebate-pos AT ROW 3.13 COL 22.43 WIDGET-ID 8
     tg-bronze AT ROW 3.83 COL 56.29 WIDGET-ID 38
     tg-vmc AT ROW 4.13 COL 22.43 WIDGET-ID 10
     tg-distribuidor AT ROW 4.75 COL 56.29 WIDGET-ID 54
     tg-Stock AT ROW 5.08 COL 22.43 WIDGET-ID 12
     tg-Revenda-Solucoes AT ROW 5.63 COL 56.29 WIDGET-ID 62
     tg-liberado AT ROW 5.79 COL 5 WIDGET-ID 46
     tg-Backup AT ROW 6.13 COL 22.43 WIDGET-ID 56
     tg-Provedores AT ROW 6.5 COL 56.29 WIDGET-ID 66
     tg-finalizado AT ROW 6.75 COL 5 WIDGET-ID 48
     c-unidade-ini AT ROW 9 COL 26.43 COLON-ALIGNED WIDGET-ID 14
     c-unidade-fim AT ROW 9 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     dt-periodo-ini AT ROW 10.04 COL 25 COLON-ALIGNED WIDGET-ID 26
     dt-periodo-fim AT ROW 10.04 COL 49.14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     dt-trans-ini AT ROW 11.08 COL 25.14 COLON-ALIGNED
     dt-trans-fim AT ROW 11.08 COL 49.14 COLON-ALIGNED NO-LABEL
     dt-vencto-ini AT ROW 12.08 COL 25.14 COLON-ALIGNED WIDGET-ID 24
     dt-vencto-fim AT ROW 12.08 COL 49.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     bt-ok AT ROW 13.96 COL 3.43
     bt-restaura AT ROW 13.96 COL 36 WIDGET-ID 52
     bt-cancela AT ROW 13.96 COL 68.29
     "Benef¡cio(s):" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.38 COL 21.43 WIDGET-ID 4
     "Sele‡Æo" VIEW-AS TEXT
          SIZE 6.29 BY .54 AT ROW 8.25 COL 4
     "Status:" VIEW-AS TEXT
          SIZE 5.57 BY .54 AT ROW 5.04 COL 3.43 WIDGET-ID 42
     "Movimento(s):" VIEW-AS TEXT
          SIZE 10.43 BY .54 AT ROW 1.38 COL 3
     "Categoria(s):" VIEW-AS TEXT
          SIZE 8.43 BY .54 AT ROW 1.38 COL 56.14 WIDGET-ID 32
     rt-button AT ROW 13.75 COL 2
     RECT-10 AT ROW 1.25 COL 2
     IMAGE-15 AT ROW 10.04 COL 38.57
     IMAGE-16 AT ROW 10.04 COL 47.43
     IMAGE-21 AT ROW 12.13 COL 38.57
     IMAGE-22 AT ROW 12.13 COL 47.43
     IMAGE-23 AT ROW 11.08 COL 38.57
     IMAGE-24 AT ROW 11.08 COL 47.43
     RECT-116 AT ROW 8.5 COL 2
     IMAGE-25 AT ROW 9 COL 38.57
     IMAGE-26 AT ROW 9 COL 47.43
     RECT-117 AT ROW 1.63 COL 2.43
     RECT-118 AT ROW 1.63 COL 20.43 WIDGET-ID 2
     RECT-119 AT ROW 1.67 COL 55 WIDGET-ID 30
     RECT-120 AT ROW 5.29 COL 2.43 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 79.14 BY 14.13
         FONT 7.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 14.21
         WIDTH              = 79.14
         MAX-HEIGHT         = 27.71
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 27.71
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Fechar */
DO:
  ASSIGN tt-param.l-ok = NO.
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Filtrar */
DO:
          
    DO WITH FRAME f-cad:
        ASSIGN tt-param.l-provisao         = tg-provisao:CHECKED 
               tt-param.l-despesa          = tg-despesa:CHECKED 
               tt-param.l-rebate           = tg-rebate:CHECKED 
               tt-param.l-rebate-pos       = tg-rebate-pos:CHECKED 
               tt-param.l-vmc              = tg-vmc:CHECKED 
               tt-param.l-stock            = tg-Stock:CHECKED 
               tt-param.l-backup           = tg-Backup:CHECKED 
               tt-param.l-showroom         = tg-Showroom:CHECKED 
               tt-param.l-price            = tg-Price:CHECKED 
               tt-param.c-unid-ini         = INPUT c-unidade-ini                       
               tt-param.c-unid-fim         = INPUT c-unidade-fim               
/*                tt-param.c-class-ini        = INPUT c-class-ini  */
/*                tt-param.c-class-fim        = INPUT c-class-fim  */
               tt-param.l-ouro             = tg-ouro:CHECKED
               tt-param.l-prata            = tg-prata:CHECKED
               tt-param.l-bronze           = tg-bronze:CHECKED
               tt-param.l-distribuidor     = tg-distribuidor:CHECKED
               tt-param.l-Revenda-Solucoes = tg-Revenda-Solucoes:CHECKED
               tt-param.l-Provedores       = tg-provedores:CHECKED
               tt-param.l-ativo            = tg-liberado:CHECKED                 
               tt-param.l-finalizado       = tg-finalizado:CHECKED                      
               tt-param.da-periodo-ini     = INPUT dt-periodo-ini         
               tt-param.da-periodo-fim     = INPUT dt-periodo-fim                    
               tt-param.da-trans-ini       = INPUT dt-trans-ini   
               tt-param.da-trans-fim       = INPUT dt-trans-fim   
               tt-param.da-vencto-ini      = INPUT dt-vencto-ini    
               tt-param.da-vencto-fim      = INPUT dt-vencto-fim
               tt-param.l-ok               = YES.
 
    END. 
    
    /*
    RUN notify ('update-record':U).
    if return-value <> "adm-error":U then */
     apply "close":U to this-procedure.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-restaura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-restaura w-cadsim
ON CHOOSE OF bt-restaura IN FRAME f-cad /* Restaura Parƒmetros iniciais */
DO:
  
    DO WITH FRAME f-cad:
        ASSIGN        tg-provisao:CHECKED = NO
                       tg-despesa:CHECKED = YES
                       tg-rebate:CHECKED = YES
                   tg-rebate-pos:CHECKED = YES
                          tg-vmc:CHECKED = YES
                        tg-Stock:CHECKED = YES
                       tg-Backup:CHECKED = YES
                     tg-ShowRoom:CHECKED = YES
                        tg-Price:CHECKED = YES
                         tg-ouro:CHECKED = YES
                        tg-prata:CHECKED = YES
                       tg-bronze:CHECKED = YES
                 tg-distribuidor:CHECKED = YES
             tg-Revenda-Solucoes:CHECKED = YES
                   tg-Provedores:CHECKED = YES
                   tg-finalizado:CHECKED = NO
                     tg-liberado:CHECKED = YES
                           c-unidade-ini = ""
                          c-unidade-fim  = "ZZZZZZ"
/*                          c-class-ini  = ""                      */
/*                          c-class-fim  = "ZZZZZZZZZZZZZZZZZZZZ"  */
                      dt-periodo-ini     = 01/01/2014
                      dt-periodo-fim     = 12/31/2099
                        dt-trans-ini     = 01/01/2014
                        dt-trans-fim     = 12/31/2099
                       dt-vencto-ini     = 01/01/2014
                       dt-vencto-fim     = 12/31/2099.

        ASSIGN INPUT tg-provisao    
               INPUT tg-despesa    
               INPUT tg-rebate    
               INPUT tg-rebate-pos    
               INPUT tg-vmc    
               INPUT tg-Stock   
               INPUT tg-Backup
               INPUT tg-ShowRoom
               INPUT tg-Price
               INPUT tg-ouro    
               INPUT tg-prata    
               INPUT tg-bronze 
               INPUT tg-distribuidor
               INPUT tg-Revenda-Solucoes
               INPUT tg-Provedores
               INPUT tg-finalizado    
               INPUT tg-liberado    
               INPUT c-unidade-ini    
               INPUT c-unidade-fim    
/*                INPUT c-class-ini  */
/*                INPUT c-class-fim  */
               INPUT dt-periodo-ini    
               INPUT dt-periodo-fim    
               INPUT dt-trans-ini    
               INPUT dt-trans-fim    
               INPUT dt-vencto-ini    
               INPUT dt-vencto-fim.   

        DISP tg-provisao   
             tg-despesa    
             tg-rebate     
             tg-rebate-pos 
             tg-vmc        
             tg-Stock      
             tg-Backup
             tg-ShowRoom
             tg-Price
             tg-ouro       
             tg-prata      
             tg-bronze     
             tg-distribuidor
             tg-Revenda-Solucoes 
             tg-Provedores       
             tg-finalizado 
             tg-liberado   
             c-unidade-ini 
             c-unidade-fim 
/*              c-class-ini  */
/*              c-class-fim  */
             dt-periodo-ini
             dt-periodo-fim
             dt-trans-ini  
             dt-trans-fim  
             dt-vencto-ini 
             dt-vencto-fim.
                           
    END. 

    DO WITH FRAME f-cad:
         ASSIGN c-unidade-ini:SCREEN-VALUE  = ""
                c-unidade-fim:SCREEN-VALUE  = "ZZZZZZ"
/*                 c-class-ini:SCREEN-VALUE    = ""                      */
/*                 c-class-fim:SCREEN-VALUE    = "ZZZZZZZZZZZZZZZZZZZZ"  */
                dt-periodo-ini:SCREEN-VALUE = STRING(01/01/2014)
                dt-periodo-fim:SCREEN-VALUE = STRING(12/31/2099)
                dt-trans-ini:SCREEN-VALUE   = STRING(01/01/2014)
                dt-trans-fim:SCREEN-VALUE   = STRING(12/31/2099)
                dt-vencto-ini:SCREEN-VALUE  = STRING(01/01/2014)
                dt-vencto-fim:SCREEN-VALUE  = STRING(12/31/2099).
    END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY tg-ShowRoom tg-ouro tg-provisao tg-rebate tg-Price tg-prata tg-despesa 
          tg-rebate-pos tg-bronze tg-vmc tg-distribuidor tg-Stock 
          tg-Revenda-Solucoes tg-liberado tg-Backup tg-Provedores tg-finalizado 
          c-unidade-ini c-unidade-fim dt-periodo-ini dt-periodo-fim dt-trans-ini 
          dt-trans-fim dt-vencto-ini dt-vencto-fim 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-10 IMAGE-15 IMAGE-16 IMAGE-21 IMAGE-22 IMAGE-23 
         IMAGE-24 RECT-116 IMAGE-25 IMAGE-26 RECT-117 RECT-118 RECT-119 
         RECT-120 tg-ShowRoom tg-ouro tg-provisao tg-rebate tg-Price tg-prata 
         tg-despesa tg-rebate-pos tg-bronze tg-vmc tg-distribuidor tg-Stock 
         tg-Revenda-Solucoes tg-liberado tg-Backup tg-Provedores tg-finalizado 
         c-unidade-ini c-unidade-fim dt-periodo-ini dt-periodo-fim dt-trans-ini 
         dt-trans-fim dt-vencto-ini dt-vencto-fim bt-ok bt-restaura bt-cancela 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display w-cadsim 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
        MESSAGE c-unidade-ini:SCREEN-VALUE IN FRAME f-cad
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
        DISP    tg-provisao        
                tg-despesa
                tg-rebate      
                tg-rebate-pos
                tg-vmc             
                tg-Stock
                tg-Backup
                tg-ShowRoom
                tg-Price
                c-unidade-ini
                c-unidade-fim
/*                 c-class-ini  */
/*                 c-class-fim  */
                tg-ouro                    
                tg-prata                   
                tg-bronze                  
                tg-liberado     
                tg-finalizado   
                dt-periodo-ini
                dt-periodo-fim
                dt-trans-ini  
                dt-trans-fim  
                dt-vencto-ini 
                dt-vencto-fim WITH FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ISGT008a" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  FIND FIRST tt-param NO-ERROR.

  DO WITH FRAME f-cad:                 

        ASSIGN  tg-provisao:CHECKED         = tt-param.l-provisao    
                tg-despesa:CHECKED          = tt-param.l-despesa     
                tg-rebate:CHECKED           = tt-param.l-rebate      
                tg-rebate-pos:CHECKED       = tt-param.l-rebate-pos  
                tg-vmc:CHECKED              = tt-param.l-vmc         
                tg-Stock:CHECKED            = tt-param.l-stock       
                tg-Backup:CHECKED           = tt-param.l-backup      
                tg-Showroom:CHECKED         = tt-param.l-showroom      
                tg-Price:CHECKED            = tt-param.l-price      
                c-unidade-ini:SCREEN-VALUE  = tt-param.c-unid-ini                 
                c-unidade-fim:SCREEN-VALUE  = tt-param.c-unid-fim         
/*                 c-class-ini:SCREEN-VALUE    = tt-param.c-class-ini  */
/*                 c-class-fim:SCREEN-VALUE    = tt-param.c-class-fim  */
                tg-ouro:CHECKED             = tt-param.l-ouro        
                tg-prata:CHECKED            = tt-param.l-prata       
                tg-bronze:CHECKED           = tt-param.l-bronze      
                tg-liberado:CHECKED         = tt-param.l-ativo                 
                tg-finalizado:CHECKED       = tt-param.l-finalizado   
                tg-distribuidor:CHECKED     = tt-param.l-distribuidor
                tg-Revenda-solucoes:CHECKED = tt-param.l-Revenda-solucoes
                tg-Provedores:CHECKED       = tt-param.l-provedores
                dt-periodo-ini:SCREEN-VALUE = string( tt-param.da-periodo-ini)
                dt-periodo-fim:SCREEN-VALUE = string( tt-param.da-periodo-fim)           
                dt-trans-ini:SCREEN-VALUE   = string( tt-param.da-trans-ini  )
                dt-trans-fim:SCREEN-VALUE   = string( tt-param.da-trans-fim  )
                dt-vencto-ini:SCREEN-VALUE  = string( tt-param.da-vencto-ini )
                dt-vencto-fim:SCREEN-VALUE  = string( tt-param.da-vencto-fim )
                tt-param.l-ok               = NO.           

        
        ASSIGN input   tg-provisao        
               input   tg-despesa
               input   tg-rebate      
               input   tg-rebate-pos
               input   tg-vmc             
               input   tg-Stock
               INPUT   tg-Backup
               INPUT   tg-ShowRoom
               INPUT   tg-Price
               input   c-unidade-ini
               input   c-unidade-fim
               INPUT   tg-distribuidor
               INPUT   tg-Revenda-solucoes
               INPUT   tg-Provedores
/*                input   c-class-ini  */
/*                input   c-class-fim  */
               input   tg-ouro                    
               input   tg-prata                   
               input   tg-bronze                  
               input   tg-liberado     
               input   tg-finalizado   
               input   dt-periodo-ini
               input   dt-periodo-fim
               input   dt-trans-ini  
               input   dt-trans-fim  
               input   dt-vencto-ini 
               input   dt-vencto-fim.

  END. 


  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  RUN dispatch  IN this-procedure ('display-fields':U).

  ASSIGN tt-param.l-ok = NO.
  

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

