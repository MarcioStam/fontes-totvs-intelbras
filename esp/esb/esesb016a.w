&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright Exponencial TI (2011)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Exponencial TI, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESESB016A 2.00.00.000}  /*** 010001 ***/


CREATE WIDGET-POOL.


/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB016A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    

&GLOBAL-DEFINE page0Widgets   btOK btSalvar btCancel btHelp2


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pNovoRegistro  AS ROWID     NO-UNDO.



DEFINE TEMP-TABLE tt-param-nat NO-UNDO LIKE int-param-nat-oper-benef
    FIELD ds-tp-beneficio AS CHAR FORMAT "X(16)"
    FIELD r-rowid AS ROWID.


/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-unid-negoc cb-tp-beneficio i-canal-venda ~
c-ds-canal-venda btOK btSalvar btCancel btHelp2 RECT-14 RECT-15 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-unid-negoc cb-tp-beneficio i-canal-venda ~
c-ds-unid-negoc c-ds-canal-venda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-tp-beneficio AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "Tipo Beneficio" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEM-PAIRS "VMC",1,
                     "Stock Rotation",2,
                     "Rebate",3,
                     "Rebate P¢s-Venda",4,
                     "Show Room",5,
                     "Stock Backup",6,
                     "Price Protection",7
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-ds-canal-venda AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-negoc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE i-canal-venda AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal de Venda" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 3.13.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 2.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-unid-negoc AT ROW 1.63 COL 18.14 COLON-ALIGNED
     cb-tp-beneficio AT ROW 2.71 COL 18.14 COLON-ALIGNED WIDGET-ID 2
     i-canal-venda AT ROW 5.38 COL 18.14 COLON-ALIGNED
     c-ds-unid-negoc AT ROW 1.63 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-ds-canal-venda AT ROW 5.38 COL 29.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 7.63 COL 1.86
     btSalvar AT ROW 7.63 COL 12.86
     btCancel AT ROW 7.63 COL 23.86
     btHelp2 AT ROW 7.63 COL 80
     RECT-14 AT ROW 1.13 COL 2.29
     RECT-15 AT ROW 4.54 COL 2.29
     rtToolBar AT ROW 7.38 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.29
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
         HEIGHT             = 8.21
         WIDTH              = 90.14
         MAX-HEIGHT         = 27.58
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.58
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME UNDERLINE Custom                                          */
/* SETTINGS FOR FILL-IN c-ds-unid-negoc IN FRAME fPage0
   NO-ENABLE                                                            */
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
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK":U.
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
    IF pcAction = "Detail" THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
    ELSE DO:
        RUN saveRecord IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "OK":U THEN
            APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fPage0 /* Salvar */
DO:
    IF pcAction = "Detail" THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
    ELSE DO:

        RUN saveRecord IN THIS-PROCEDURE. 


        IF RETURN-VALUE = "OK" THEN DO:

            ASSIGN c-unid-negoc      = ""
                   c-ds-unid-negoc   = ""
                   i-canal-venda     = 0
                   c-ds-canal-venda  = "".
    
            DISPLAY c-unid-negoc    
                    c-ds-unid-negoc 
                    i-canal-venda   
                    c-ds-canal-venda WITH FRAME fpage0.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON F5 OF c-unid-negoc IN FRAME fPage0 /* Unidade Neg¢cio */
DO:                         
        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="c-unid-negoc"
                         &Frame1="fPage0"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="c-ds-unid-negoc"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON LEAVE OF c-unid-negoc IN FRAME fPage0 /* Unidade Neg¢cio */
DO:
  
    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = INPUT FRAME fpage0 c-unid-negoc NO-ERROR.

    
    IF AVAIL unid-negoc THEN
        ASSIGN c-ds-unid-negoc = unid-negoc.des-unid-negoc.


    DISPLAY c-ds-unid-negoc WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON MOUSE-SELECT-DBLCLICK OF c-unid-negoc IN FRAME fPage0 /* Unidade Neg¢cio */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-canal-venda wWindow
ON F5 OF i-canal-venda IN FRAME fPage0 /* Canal de Venda */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z01di232.w"
                       &campo=i-canal-venda
                       &campozoom=cod-canal-venda
                       &campo2=c-ds-canal-venda
                       &campozoom2=descricao}

    /*
  {method/zoomfields.i &ProgramZoom="dizoom/z01di232.w"
                         &FieldZoom1="cod-canal-venda"
                         &FieldScreen1="i-canal-venda"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-canal-venda"
                         &FieldScreen2="c-ds-canal-venda"
                         &Frame2="fPage0"
                         &EnableImplant="NO"} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-canal-venda wWindow
ON LEAVE OF i-canal-venda IN FRAME fPage0 /* Canal de Venda */
DO:
    FIND FIRST canal-venda NO-LOCK
        WHERE canal-venda.cod-canal-venda = INPUT FRAME fpage0 i-canal-venda NO-ERROR.

    IF AVAIL canal-venda THEN
        ASSIGN c-ds-canal-venda = canal-venda.descricao.

    DISPLAY c-ds-canal-venda WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-canal-venda wWindow
ON MOUSE-SELECT-DBLCLICK OF i-canal-venda IN FRAME fPage0 /* Canal de Venda */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/


c-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur")     IN FRAME fPage0.
i-canal-venda:LOAD-MOUSE-POINTER("image/lupa.cur")    IN FRAME fPage0.

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


    IF  pcAction = "Create" THEN 
        ENABLE c-unid-negoc    
               cb-tp-beneficio
               i-canal-venda   
            WITH FRAME fPage0.
    ELSE DO:

        ENABLE i-canal-venda
            WITH FRAME fPage0.
    
        FIND int-param-canal-benef NO-LOCK
            WHERE ROWID(int-param-canal-benef) = prTable NO-ERROR.

        IF AVAIL int-param-canal-benef THEN DO:
            ASSIGN c-unid-negoc  = int-param-canal-benef.cod-unid-negoc
                   i-canal-venda = int-param-canal-benef.cod-canal-venda.

            CASE int-param-canal-benef.tp-beneficio:
                WHEN 21 THEN
                    ASSIGN cb-tp-beneficio = 1.
                WHEN 22 THEN
                    ASSIGN cb-tp-beneficio = 2.
                WHEN 37 THEN
                    ASSIGN cb-tp-beneficio = 3.
                WHEN 66 THEN
                    ASSIGN cb-tp-beneficio = 4.
                WHEN 15 THEN
                    ASSIGN cb-tp-beneficio = 5.
                WHEN 04 THEN
                    ASSIGN cb-tp-beneficio = 6.
                WHEN 08 THEN
                    ASSIGN cb-tp-beneficio = 7.

            END CASE.


            DISPLAY c-unid-negoc
                    c-ds-unid-negoc
                    cb-tp-beneficio
                    i-canal-venda
                    c-ds-canal-venda
                 WITH FRAME fPage0.


            APPLY "LEAVE":U TO c-unid-negoc       IN FRAME fPage0.
            APPLY "LEAVE":U TO i-canal-venda      IN FRAME fPage0.

        END.
    END.
                                

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord wWindow 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i-tp-beneficio AS INTEGER     NO-UNDO.


    ASSIGN INPUT FRAME fPage0 i-canal-venda.

    IF NOT CAN-FIND( canal-venda 
                        WHERE canal-venda.cod-canal-venda = i-canal-venda ) THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 56,
                           INPUT "Canal de Venda").

        APPLY "ENTRY":U TO i-canal-venda IN FRAME fPage0.
        RETURN "NOK":U.
    END.
                                          
    IF pcAction = "CREATE" THEN DO:

        ASSIGN INPUT FRAME fPage0 c-unid-negoc
               INPUT FRAME fPage0 cb-tp-beneficio.

        IF NOT CAN-FIND( unid-negoc 
                            WHERE unid-negoc.cod-unid-negoc = c-unid-negoc ) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Unidade de Neg¢cio").
    
            APPLY "ENTRY":U TO c-unid-negoc IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        
        CASE cb-tp-beneficio:
            WHEN 1 THEN
                ASSIGN i-tp-beneficio = 21.
            WHEN 2 THEN
                ASSIGN i-tp-beneficio = 22.
            WHEN 3 THEN
                ASSIGN i-tp-beneficio = 37.
            WHEN 4 THEN
                ASSIGN i-tp-beneficio = 66.
            WHEN 5 THEN
                ASSIGN i-tp-beneficio = 15.
            WHEN 6 THEN
                ASSIGN i-tp-beneficio = 04.
            WHEN 7 THEN
                ASSIGN i-tp-beneficio = 08.

            OTHERWISE DO:
                 RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Tipo De Beneficio inv lido!").
        
                APPLY "ENTRY":U TO cb-tp-beneficio IN FRAME fPage0.
                RETURN "NOK":U.
            END.
        END CASE.


        
        IF CAN-FIND (FIRST int-param-canal-benef
            WHERE int-param-canal-benef.cod-unid-negoc   = c-unid-negoc 
              AND int-param-canal-benef.tp-beneficio     = i-tp-beneficio) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Parametro Canal Venda por Tipo Beneficio").
            RETURN "NOK":U.
        END.

        CREATE int-param-canal-benef.
        ASSIGN int-param-canal-benef.cod-unid-negoc  = c-unid-negoc
               int-param-canal-benef.tp-beneficio    = i-tp-beneficio
               int-param-canal-benef.cod-canal-venda = i-canal-venda.

        ASSIGN pNovoRegistro = ROWID(int-param-canal-benef).

    END.
    ELSE DO: /* Update */
        FIND FIRST int-param-canal-benef EXCLUSIVE-LOCK
            WHERE  ROWID(int-param-canal-benef) = prTable NO-ERROR.

        IF AVAIL int-param-canal-benef THEN
            ASSIGN int-param-canal-benef.cod-canal-venda = i-canal-venda.
    END.
        


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

