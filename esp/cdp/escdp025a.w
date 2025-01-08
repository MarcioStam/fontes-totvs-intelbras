&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-crm-categ-un NO-UNDO LIKE crm-categ-un
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP025A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP025A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pCd-unid-comerc AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boes547 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-5 i-cd-unid-comerc ~
c-ds-unid-comerc i-cd-categoria c-ds-categoria btOK btSalvar btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-cd-unid-comerc c-ds-unid-comerc ~
i-cd-categoria c-ds-categoria 

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

DEFINE VARIABLE c-ds-categoria AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-categoria AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     i-cd-unid-comerc AT ROW 1.42 COL 18 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial" WIDGET-ID 14
     c-ds-unid-comerc AT ROW 1.42 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     i-cd-categoria AT ROW 2.92 COL 18 COLON-ALIGNED WIDGET-ID 2
     c-ds-categoria AT ROW 2.92 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     btOK AT ROW 4.38 COL 2
     btSalvar AT ROW 4.38 COL 12.43 WIDGET-ID 34
     btCancel AT ROW 4.38 COL 22.86
     rtToolBar AT ROW 4.17 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     RECT-5 AT ROW 2.67 COL 1.43 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-crm-categ-un T "?" NO-UNDO mgesp crm-categ-un
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
         TITLE              = "Inclui/Modifica Unidade Comercial x Tabela de Pre‡o"
         HEIGHT             = 4.71
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
ON END-ERROR OF wWindow /* Inclui/Modifica Unidade Comercial x Tabela de Pre‡o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Unidade Comercial x Tabela de Pre‡o */
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
    {method/zoomfields.i &ProgramZoom="eszoom/z01es546.w"
                         &FieldZoom1="cd-categoria"
                         &FieldScreen1="i-cd-categoria"
                         &Frame1="fPage0"
                         &FieldZoom2="ds-categoria"
                         &FieldScreen2="c-ds-categoria"
                         &Frame2="fPage0"
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

    DISPLAY c-ds-categoria WITH FRAME fPage0.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-categoria wWindow
ON RETURN OF i-cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    APPLY "CHOOSE":U TO btSalvar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-unid-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-unid-comerc wWindow
ON LEAVE OF i-cd-unid-comerc IN FRAME fPage0 /* Unid Neg¢cio */
DO:
    ASSIGN INPUT FRAME fPage0 i-cd-unid-comerc.

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = i-cd-unid-comerc NO-ERROR.
           
    ASSIGN c-ds-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    DISPLAY c-ds-unid-comerc WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
i-cd-categoria:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boes547) THEN DO:
        RUN destroy IN h-boes547.
        ASSIGN h-boes547 = ?.
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

    RUN initializeDBOs IN THIS-PROCEDURE.

    ASSIGN i-cd-unid-comerc = pCd-unid-comerc.

    DISPLAY i-cd-unid-comerc
        WITH FRAME fPage0.

    ENABLE i-cd-categoria
           btSalvar
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-unid-comerc IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-boes547) THEN
        RUN esbo/boes547.p PERSISTENT SET h-boes547.

    RUN openQueryStatic IN h-boes547 (INPUT "Main":U) NO-ERROR.

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
           INPUT FRAME fPage0 i-cd-categoria.

    IF  VALID-HANDLE(h-boes547) THEN DO:
        RUN newRecord        IN h-boes547.
        RUN getRecord        IN h-boes547 (OUTPUT TABLE tt-crm-categ-un).
    
        FIND FIRST tt-crm-categ-un EXCLUSIVE-LOCK NO-ERROR.
    
        ASSIGN tt-crm-categ-un.cd-unid-negoc = STRING(i-cd-unid-comerc)
               tt-crm-categ-un.cd-categoria  = i-cd-categoria.
    
        RUN setRecord        IN h-boes547 (INPUT TABLE tt-crm-categ-un).
        RUN emptyRowErrors   IN h-boes547.
        RUN createRecord     IN h-boes547.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-boes547 (OUTPUT TABLE rowErrors).
            {method/ShowMessage.i1}.
            {method/ShowMessage.i2 &Modal="YES"}.
            {method/ShowMessage.i3}.
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

    ASSIGN i-cd-categoria = 0.

    DISPLAY i-cd-categoria
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO i-cd-categoria IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

