&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-etiq-coletiva NO-UNDO LIKE etiq-coletiva
       field cnm-usuar       AS CHARACTER
       field cnm-usuar-reimp AS CHARACTER
       field cnm-usuar-desat AS CHARACTER.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP013A 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP013A
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btFecha
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-etiqueta    AS CHARACTER  NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-etiq-coletiva.cod-estabel ~
tt-etiq-coletiva.data tt-etiq-coletiva.usuario tt-etiq-coletiva.dt-ult-re ~
tt-etiq-coletiva.usuar-ult-re tt-etiq-coletiva.dt-desat ~
tt-etiq-coletiva.usuar-desat 
&Scoped-define ENABLED-TABLES tt-etiq-coletiva
&Scoped-define FIRST-ENABLED-TABLE tt-etiq-coletiva
&Scoped-Define ENABLED-OBJECTS rtToolBar rtCriacao rtReimp rtReimp-2 ~
cnm-usuar cnm-usuar-reimp cnm-usuar-desat btFecha btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-etiq-coletiva.cod-estabel ~
tt-etiq-coletiva.data tt-etiq-coletiva.usuario tt-etiq-coletiva.dt-ult-re ~
tt-etiq-coletiva.usuar-ult-re tt-etiq-coletiva.dt-desat ~
tt-etiq-coletiva.usuar-desat 
&Scoped-define DISPLAYED-TABLES tt-etiq-coletiva
&Scoped-define FIRST-DISPLAYED-TABLE tt-etiq-coletiva
&Scoped-Define DISPLAYED-OBJECTS cnm-usuar cnm-usuar-reimp cnm-usuar-desat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFecha 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE cnm-usuar AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .79 TOOLTIP "Nome completo do usu†rio" NO-UNDO.

DEFINE VARIABLE cnm-usuar-desat AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .79 TOOLTIP "Nome completo do usu†rio" NO-UNDO.

DEFINE VARIABLE cnm-usuar-reimp AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .79 TOOLTIP "Nome completo do usu†rio" NO-UNDO.

DEFINE RECTANGLE rtCriacao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtReimp
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtReimp-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-etiq-coletiva.cod-estabel AT ROW 1.25 COL 17.72 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     tt-etiq-coletiva.data AT ROW 1.25 COL 65.86 COLON-ALIGNED WIDGET-ID 30
          LABEL "Data/Hora Criaá∆o"
          VIEW-AS FILL-IN 
          SIZE 16 BY .79
     tt-etiq-coletiva.usuario AT ROW 2.08 COL 17.72 COLON-ALIGNED WIDGET-ID 34
          LABEL "Usuar.Criaá∆o"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     cnm-usuar AT ROW 2.08 COL 27.86 COLON-ALIGNED HELP
          "Nome completo do usu†rio" NO-LABEL WIDGET-ID 26
     tt-etiq-coletiva.dt-ult-re AT ROW 4.29 COL 17.72 COLON-ALIGNED WIDGET-ID 40
          LABEL "Data/Hora Ult."
          VIEW-AS FILL-IN 
          SIZE 16 BY .79
     tt-etiq-coletiva.usuar-ult-re AT ROW 5.13 COL 17.72 COLON-ALIGNED WIDGET-ID 42
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     cnm-usuar-reimp AT ROW 5.13 COL 27.86 COLON-ALIGNED HELP
          "Nome completo do usu†rio" NO-LABEL WIDGET-ID 44
     tt-etiq-coletiva.dt-desat AT ROW 7.63 COL 17.72 COLON-ALIGNED WIDGET-ID 50
          LABEL "Data/Hora"
          VIEW-AS FILL-IN 
          SIZE 16 BY .79
     tt-etiq-coletiva.usuar-desat AT ROW 8.46 COL 17.72 COLON-ALIGNED WIDGET-ID 52
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     cnm-usuar-desat AT ROW 8.46 COL 27.86 COLON-ALIGNED HELP
          "Nome completo do usu†rio" NO-LABEL WIDGET-ID 54
     btFecha AT ROW 10.38 COL 2.43
     btHelp2 AT ROW 10.38 COL 79.43
     "Desativaá∆o" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 6.79 COL 9.29 WIDGET-ID 48
          FGCOLOR 1 FONT 0
     "Reimpress∆o" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 3.5 COL 9.29 WIDGET-ID 38
          FGCOLOR 1 FONT 0
     rtToolBar AT ROW 10.13 COL 1
     rtCriacao AT ROW 1 COL 1 WIDGET-ID 32
     rtReimp AT ROW 3.75 COL 1 WIDGET-ID 36
     rtReimp-2 AT ROW 7.04 COL 1 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 10.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-etiq-coletiva T "?" NO-UNDO mgesp etiq-coletiva
      ADDITIONAL-FIELDS:
          field cnm-usuar       AS CHARACTER
          field cnm-usuar-reimp AS CHARACTER
          field cnm-usuar-desat AS CHARACTER
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11.08
         WIDTH              = 90.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.29
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
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.data IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.dt-desat IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.dt-ult-re IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.usuar-desat IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.usuar-ult-re IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-etiq-coletiva.usuario IN FRAME fpage0
   EXP-LABEL                                                            */
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


&Scoped-define SELF-NAME btFecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFecha wWindow
ON CHOOSE OF btFecha IN FRAME fpage0 /* Fechar */
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-esapi003 AS HANDLE NO-UNDO.

RUN esapi/esapi003.p PERSISTENT SET h-esapi003.

RUN piBuscaEtiqColetiva IN h-esapi003 (INPUT p-etiqueta,
                                       OUTPUT TABLE tt-etiq-coletiva).

IF VALID-HANDLE(h-esapi003) THEN
    DELETE PROCEDURE h-esapi003.

FOR FIRST tt-etiq-coletiva:
    DISP {&DISPLAYED-FIELDS} WITH FRAME {&FRAME-NAME}.

    ASSIGN cnm-usuar      :SCREEN-VALUE = tt-etiq-coletiva.cnm-usuar
           cnm-usuar-reimp:SCREEN-VALUE = tt-etiq-coletiva.cnm-usuar-reimp
           cnm-usuar-desat:SCREEN-VALUE = tt-etiq-coletiva.cnm-usuar-desat.
END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

