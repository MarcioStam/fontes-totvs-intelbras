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
{include/i-prgvrs.i ESESB015A 2.00.00.000}  /*** 010001 ***/


CREATE WIDGET-POOL.


/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB015A
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-uf-ori c-cidade-dest c-uf-dest ~
cb-tp-beneficio c-nat-oper c-ds-nat-oper btOK btSalvar btCancel btHelp2 ~
RECT-14 RECT-15 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-uf-ori c-cidade-dest c-uf-dest ~
cb-tp-beneficio c-nat-oper c-ds-uf-dest c-ds-uf-ori c-ds-nat-oper 

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
                     "Price Protection",6,
                     "Stock Backup",7
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cidade-dest AS CHARACTER FORMAT "X(50)" 
     LABEL "Cidade Destino" 
     VIEW-AS FILL-IN 
     SIZE 60.86 BY .88.

DEFINE VARIABLE c-ds-nat-oper AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-uf-dest AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-uf-ori AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "X(8)" 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE c-uf-dest AS CHARACTER FORMAT "x(2)":U 
     LABEL "UF Destino" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-ori AS CHARACTER FORMAT "!!" 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 5.17.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-uf-ori AT ROW 1.63 COL 18.14 COLON-ALIGNED
     c-cidade-dest AT ROW 2.63 COL 18.14 COLON-ALIGNED
     c-uf-dest AT ROW 3.63 COL 18.14 COLON-ALIGNED WIDGET-ID 6
     cb-tp-beneficio AT ROW 4.92 COL 18.14 COLON-ALIGNED WIDGET-ID 2
     c-nat-oper AT ROW 7.46 COL 18.14 COLON-ALIGNED
     c-ds-uf-dest AT ROW 3.63 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-ds-uf-ori AT ROW 1.63 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-ds-nat-oper AT ROW 7.46 COL 29.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 9.75 COL 1.86
     btSalvar AT ROW 9.75 COL 12.86
     btCancel AT ROW 9.75 COL 23.86
     btHelp2 AT ROW 9.75 COL 80
     RECT-14 AT ROW 1.13 COL 2.29
     RECT-15 AT ROW 6.5 COL 2.29
     rtToolBar AT ROW 9.5 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.17
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
         HEIGHT             = 10.25
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
/* SETTINGS FOR FILL-IN c-ds-uf-dest IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ds-uf-ori IN FRAME fPage0
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

            ASSIGN c-uf-ori      = ""
                   c-ds-uf-ori   = ""
                   c-cidade-dest = ""
                   c-uf-dest     = ""
                   c-ds-uf-dest  = ""
                   c-nat-oper    = ""
                   c-ds-nat-oper = "".
    
            DISPLAY c-uf-ori     
                    c-ds-uf-ori  
                    c-cidade-dest
                    c-uf-dest    
                    c-ds-uf-dest 
                    c-nat-oper   
                    c-ds-nat-oper WITH FRAME fpage0.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cidade-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cidade-dest wWindow
ON F5 OF c-cidade-dest IN FRAME fPage0 /* Cidade Destino */
DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                        &FieldZoom1="cidade"
                        &FieldScreen1="c-cidade-dest"
                        &Frame1="fPage0"
                        &FieldZoom2="estado"
                        &FieldScreen2="c-uf-dest"
                        &Frame2="fPage0"
                        &EnableImplant="NO"}
                        
                     
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cidade-dest wWindow
ON LEAVE OF c-cidade-dest IN FRAME fPage0 /* Cidade Destino */
DO:
    APPLY "LEAVE":U TO c-uf-dest      IN FRAME fPage0.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cidade-dest wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cidade-dest IN FRAME fPage0 /* Cidade Destino */
DO:
  APPLY "F5" TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON F5 OF c-nat-oper IN FRAME fPage0 /* Natureza Opera‡Æo */
DO: 
     {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="c-nat-oper"
                        &Frame1="fPage0"
                        &FieldZoom2="denominacao"
                        &FieldScreen2="c-ds-nat-oper"
                        &Frame2="fPage0"
                        &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON LEAVE OF c-nat-oper IN FRAME fPage0 /* Natureza Opera‡Æo */
DO:
    FIND FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = INPUT FRAME fpage0 c-nat-oper NO-ERROR.

    IF AVAIL natur-oper THEN
        ASSIGN c-ds-nat-oper = natur-oper.denominacao.

    DISPLAY c-ds-nat-oper WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wWindow
ON MOUSE-SELECT-DBLCLICK OF c-nat-oper IN FRAME fPage0 /* Natureza Opera‡Æo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-uf-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-dest wWindow
ON F5 OF c-uf-dest IN FRAME fPage0 /* UF Destino */
DO:
  {method/zoomfields.i &ProgramZoom="unzoom/z02un007.w"
                         &FieldZoom1=estado
                         &FieldScreen1=c-uf-dest
                         &Frame1=fPage0
                         &FieldZoom2=no-estado
                         &FieldScreen2=c-ds-uf-dest
                         &Frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-dest wWindow
ON LEAVE OF c-uf-dest IN FRAME fPage0 /* UF Destino */
DO:
  
    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.pais   = "Brasil" 
          AND unid-feder.estado = INPUT FRAME fpage0 c-uf-dest NO-ERROR.

    IF AVAIL unid-feder THEN
        ASSIGN c-ds-uf-dest = unid-feder.no-estado.

    DISPLAY c-ds-uf-dest WITH FRAME fpage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-dest wWindow
ON MOUSE-SELECT-DBLCLICK OF c-uf-dest IN FRAME fPage0 /* UF Destino */
DO:
     APPLY "F5" TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-uf-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-ori wWindow
ON F5 OF c-uf-ori IN FRAME fPage0 /* UF Origem */
DO:
     {method/zoomfields.i &ProgramZoom="unzoom/z02un007.w"
                         &FieldZoom1=estado
                         &FieldScreen1=c-uf-ori
                         &Frame1=fPage0
                         &FieldZoom2=no-estado
                         &FieldScreen2=c-ds-uf-ori
                         &Frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-ori wWindow
ON LEAVE OF c-uf-ori IN FRAME fPage0 /* UF Origem */
DO:
  
    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.pais   = "Brasil" 
          AND unid-feder.estado = INPUT FRAME fpage0 c-uf-ori NO-ERROR.

    IF AVAIL unid-feder THEN
        ASSIGN c-ds-uf-ori = unid-feder.no-estado.

    DISPLAY c-ds-uf-ori WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf-ori wWindow
ON MOUSE-SELECT-DBLCLICK OF c-uf-ori IN FRAME fPage0 /* UF Origem */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

c-uf-ori:LOAD-MOUSE-POINTER("image/lupa.cur")       IN FRAME fPage0.
c-uf-dest:LOAD-MOUSE-POINTER("image/lupa.cur")      IN FRAME fPage0.
c-cidade-dest:LOAD-MOUSE-POINTER("image/lupa.cur")  IN FRAME fPage0.
c-nat-oper:LOAD-MOUSE-POINTER("image/lupa.cur")     IN FRAME fPage0.


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
        ENABLE c-uf-ori
               c-cidade-dest
               c-uf-dest
               cb-tp-beneficio
               c-nat-oper
            WITH FRAME fPage0.
    ELSE DO:

        ENABLE c-nat-oper
            WITH FRAME fPage0.
    
        FIND int-param-nat-oper-benef NO-LOCK
            WHERE ROWID(int-param-nat-oper-benef) = prTable NO-ERROR.

        IF AVAIL int-param-nat-oper-benef THEN DO:
            ASSIGN c-uf-ori      = int-param-nat-oper-benef.estado-origem
                   c-cidade-dest = int-param-nat-oper-benef.cidade-destino
                   c-uf-dest     = int-param-nat-oper-benef.estado-destino
                   c-nat-oper    = int-param-nat-oper-benef.nat-operacao.

            CASE int-param-nat-oper-benef.tp-beneficio:
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
                WHEN 08 THEN
                    ASSIGN cb-tp-beneficio = 6.
                WHEN 04 THEN
                    ASSIGN cb-tp-beneficio = 7.

            END CASE.


            DISPLAY c-uf-ori
                    c-cidade-dest
                    c-uf-dest
                    cb-tp-beneficio
                    c-nat-oper
                 WITH FRAME fPage0.


            APPLY "LEAVE":U TO c-uf-ori       IN FRAME fPage0.
            APPLY "LEAVE":U TO c-cidade-dest  IN FRAME fPage0.
            APPLY "LEAVE":U TO c-uf-dest      IN FRAME fPage0.
            APPLY "LEAVE":U TO c-nat-oper     IN FRAME fPage0.

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


    ASSIGN INPUT FRAME fPage0 c-nat-oper.

    IF NOT CAN-FIND( natur-oper 
                        WHERE natur-oper.nat-operacao = c-nat-oper ) THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 56,
                           INPUT "Natureza Opera‡Æo").

        APPLY "ENTRY":U TO c-nat-oper IN FRAME fPage0.
        RETURN "NOK":U.
    END.
                                          
    IF pcAction = "CREATE" THEN DO:

        ASSIGN INPUT FRAME fPage0 c-uf-ori
               INPUT FRAME fPage0 c-cidade-dest
               INPUT FRAME fPage0 c-uf-dest
               INPUT FRAME fPage0 cb-tp-beneficio.

        IF NOT CAN-FIND( unid-feder 
                            WHERE unid-feder.pais   = "Brasil" 
                              AND unid-feder.estado = c-uf-ori ) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Estado Origem").
    
            APPLY "ENTRY":U TO c-uf-ori IN FRAME fPage0.
            RETURN "NOK":U.
        END.
        
        /*
        IF c-cidade-dest = "" AND c-uf-dest = "" THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Cidade ou UF Destino").
    
            APPLY "ENTRY":U TO c-cidade-dest IN FRAME fPage0.
            RETURN "NOK":U.
        END.
        */

        IF c-cidade-dest <> "" AND 
            NOT CAN-FIND( mgcad.cidade 
                    WHERE cidade.pais   = "Brasil" 
                      AND cidade.estado = c-uf-dest
                      AND cidade.cidade = c-cidade-dest ) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Cidade ou UF Destino").
    
            APPLY "ENTRY":U TO c-cidade-dest IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF c-uf-dest <> "" and
            NOT CAN-FIND( unid-feder 
                    WHERE unid-feder.pais   = "Brasil" 
                      AND unid-feder.estado = c-uf-dest ) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Estado Destino").
    
            APPLY "ENTRY":U TO c-uf-dest IN FRAME fPage0.
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
                ASSIGN i-tp-beneficio = 08.
            WHEN 7 THEN
                ASSIGN i-tp-beneficio = 04.


            OTHERWISE DO:
                 RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Tipo De Beneficio inv lido!").
        
                APPLY "ENTRY":U TO cb-tp-beneficio IN FRAME fPage0.
                RETURN "NOK":U.
            END.
        END CASE.


        IF CAN-FIND (int-param-nat-oper-benef
            WHERE int-param-nat-oper-benef.estado-origem  = c-uf-ori 
              AND int-param-nat-oper-benef.cidade-destino = c-cidade-dest
              AND int-param-nat-oper-benef.estado-destino = c-uf-dest
              AND int-param-nat-oper-benef.tp-beneficio   = i-tp-beneficio) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Parametro Natureza por Tipo Beneficio").
            RETURN "NOK":U.
        END.

        CREATE int-param-nat-oper-benef.
        ASSIGN int-param-nat-oper-benef.estado-origem  = c-uf-ori
               int-param-nat-oper-benef.cidade-destino = c-cidade-dest
               int-param-nat-oper-benef.estado-destino = c-uf-dest
               int-param-nat-oper-benef.tp-beneficio   = i-tp-beneficio
               int-param-nat-oper-benef.nat-operacao   = c-nat-oper.

        ASSIGN pNovoRegistro = ROWID(int-param-nat-oper-benef).

    END.
    ELSE DO: /* Update */
        FIND FIRST int-param-nat-oper-benef EXCLUSIVE-LOCK
            WHERE  ROWID(int-param-nat-oper-benef) = prTable NO-ERROR.

        IF AVAIL int-param-nat-oper-benef THEN
            ASSIGN int-param-nat-oper-benef.nat-operacao   = c-nat-oper.
    END.
        


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

