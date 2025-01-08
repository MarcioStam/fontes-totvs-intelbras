&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP060a 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VAR I-NumPedidoEsftp060  AS INTEGER   NO-UNDO.

{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES it-ped-fiscal item

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens it-ped-fiscal.seq it-ped-fiscal.it-codigo IF item.tipo-contr = 4 THEN it-ped-fiscal.narrativa ELSE item.desc-item it-ped-fiscal.un it-ped-fiscal.qtde it-ped-fiscal.vl-unit it-ped-fiscal.cod-depos it-ped-fiscal.aliquota-ipi   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH it-ped-fiscal     WHERE it-ped-fiscal.nr-pedido = integer(ped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK, ~
             FIRST item WHERE item.it-codigo = it-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH it-ped-fiscal     WHERE it-ped-fiscal.nr-pedido = integer(ped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK, ~
             FIRST item WHERE item.it-codigo = it-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-itens it-ped-fiscal item
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens it-ped-fiscal
&Scoped-define SECOND-TABLE-IN-QUERY-br-itens item


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ped-fiscal.usuario-magnus ~
ped-fiscal.cod-estabel ped-fiscal.nr-pedido ped-fiscal.situacao ~
ped-fiscal.cod-emitente ped-fiscal.cod-transp ped-fiscal.frete ~
ped-fiscal.cod-rota ped-fiscal.nr-volumes ped-fiscal.sc-codigo ~
ped-fiscal.sc-codigo-rec ped-fiscal.nr-nota-fis ped-fiscal.serie ~
ped-fiscal.dt-emissao ped-fiscal.nat-oper ped-fiscal.prioridade ~
ped-fiscal.motivo-urg ped-fiscal.observacao[1] ped-fiscal.observacao[2] 
&Scoped-define ENABLED-TABLES ped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ped-fiscal
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-17 RECT-18 desc-emit desc-emit-2 ~
c-cc-aprov c-cc-receb c-finalidade c-nat c-receptor br-itens bt-ok bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS ped-fiscal.usuario-magnus ~
ped-fiscal.cod-estabel ped-fiscal.nr-pedido ped-fiscal.situacao ~
ped-fiscal.cod-emitente ped-fiscal.cod-transp ped-fiscal.frete ~
ped-fiscal.cod-rota ped-fiscal.nr-volumes ped-fiscal.sc-codigo ~
ped-fiscal.sc-codigo-rec ped-fiscal.nr-nota-fis ped-fiscal.serie ~
ped-fiscal.dt-emissao ped-fiscal.nat-oper ped-fiscal.prioridade ~
ped-fiscal.motivo-urg ped-fiscal.observacao[1] ped-fiscal.observacao[2] 
&Scoped-define DISPLAYED-TABLES ped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ped-fiscal
&Scoped-Define DISPLAYED-OBJECTS desc-emit desc-emit-2 c-cc-aprov ~
c-cc-receb c-finalidade c-nat c-receptor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cc-aprov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cc-receb AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-finalidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Finalidade" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-receptor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Quem ira Receber?" 
     VIEW-AS FILL-IN 
     SIZE 87 BY .88 NO-UNDO.

DEFINE VARIABLE desc-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75.57 BY .88 NO-UNDO.

DEFINE VARIABLE desc-emit-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 14.25.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 3.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      it-ped-fiscal, 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens w-window _FREEFORM
  QUERY br-itens NO-LOCK DISPLAY
      it-ped-fiscal.seq FORMAT ">>9":U
      it-ped-fiscal.it-codigo FORMAT "x(16)":U
      IF item.tipo-contr = 4 THEN it-ped-fiscal.narrativa ELSE item.desc-item FORMAT "x(60)"
      it-ped-fiscal.un FORMAT "x(2)":U
      it-ped-fiscal.qtde FORMAT ">>>>,>>9.99":U
      it-ped-fiscal.vl-unit FORMAT "->>,>>9.9999":U
      it-ped-fiscal.cod-depos FORMAT "x(3)":U
      it-ped-fiscal.aliquota-ipi FORMAT ">9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100.43 BY 7.46
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ped-fiscal.usuario-magnus AT ROW 1.25 COL 55.72 COLON-ALIGNED WIDGET-ID 66
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ped-fiscal.cod-estabel AT ROW 1.29 COL 33.28 WIDGET-ID 6
          LABEL "Estab"
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     ped-fiscal.nr-pedido AT ROW 1.33 COL 15 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     ped-fiscal.situacao AT ROW 1.33 COL 86.86 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Digitado",0,
                     "A Liberar",1,
                     "A Relacionar",2,
                     "A Faturar",3,
                     "Atendido Parcialmente",4,
                     "Atendido",5,
                     "Reprovado",6
          DROP-DOWN-LIST
          SIZE 13.14 BY 1
     ped-fiscal.cod-emitente AT ROW 2.33 COL 15 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     desc-emit AT ROW 2.33 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     ped-fiscal.cod-transp AT ROW 3.33 COL 15 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     desc-emit-2 AT ROW 3.33 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     ped-fiscal.frete AT ROW 4.33 COL 12.71 WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     ped-fiscal.cod-rota AT ROW 5.33 COL 15 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ped-fiscal.nr-volumes AT ROW 5.33 COL 57.71 WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     ped-fiscal.sc-codigo AT ROW 6.33 COL 15 COLON-ALIGNED WIDGET-ID 48
          LABEL "CCusto Aprovador"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-cc-aprov AT ROW 6.33 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     ped-fiscal.sc-codigo-rec AT ROW 7.33 COL 15 COLON-ALIGNED WIDGET-ID 50
          LABEL "CCusto Recebedor"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-cc-receb AT ROW 7.33 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     ped-fiscal.nr-nota-fis AT ROW 8.88 COL 15 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ped-fiscal.serie AT ROW 8.88 COL 41.72 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ped-fiscal.dt-emissao AT ROW 8.88 COL 64.57 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-finalidade AT ROW 9.88 COL 15 COLON-ALIGNED WIDGET-ID 74
     ped-fiscal.nat-oper AT ROW 10.88 COL 15.14 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-nat AT ROW 10.88 COL 19.14 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     ped-fiscal.prioridade AT ROW 12.46 COL 17 NO-LABEL WIDGET-ID 68
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Urgente", 2
          SIZE 24 BY .63
     ped-fiscal.motivo-urg AT ROW 13.21 COL 17 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 87 BY 2.29
     ped-fiscal.observacao[1] AT ROW 15.67 COL 15 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 87 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104.14 BY 27.04
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     ped-fiscal.observacao[2] AT ROW 16.67 COL 15 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 87 BY .88
     c-receptor AT ROW 17.67 COL 15 COLON-ALIGNED WIDGET-ID 72
     br-itens AT ROW 18.75 COL 3.57 WIDGET-ID 200
     bt-ok AT ROW 26.75 COL 3
     bt-ajuda AT ROW 26.75 COL 94.14
     RECT-1 AT ROW 26.54 COL 2
     RECT-17 AT ROW 12.25 COL 2 WIDGET-ID 78
     RECT-18 AT ROW 8.54 COL 2 WIDGET-ID 88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104.14 BY 27.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 27.08
         WIDTH              = 104.57
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 194.29
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 194.29
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-itens c-receptor F-Main */
ASSIGN 
       c-cc-aprov:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       c-cc-receb:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       c-nat:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN ped-fiscal.cod-estabel IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN ped-fiscal.frete IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       ped-fiscal.motivo-urg:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN ped-fiscal.nr-volumes IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ped-fiscal.sc-codigo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ped-fiscal.sc-codigo-rec IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ped-fiscal.usuario-magnus IN FRAME F-Main
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH it-ped-fiscal
    WHERE it-ped-fiscal.nr-pedido = integer(ped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK,
      FIRST item WHERE item.it-codigo = it-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _JoinCode[2]      = "mgcad.item.it-codigo = mgesp.it-ped-fiscal.it-codigo"
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY desc-emit desc-emit-2 c-cc-aprov c-cc-receb c-finalidade c-nat 
          c-receptor 
      WITH FRAME F-Main IN WINDOW w-window.
  IF AVAILABLE ped-fiscal THEN 
    DISPLAY ped-fiscal.usuario-magnus ped-fiscal.cod-estabel ped-fiscal.nr-pedido 
          ped-fiscal.situacao ped-fiscal.cod-emitente ped-fiscal.cod-transp 
          ped-fiscal.frete ped-fiscal.cod-rota ped-fiscal.nr-volumes 
          ped-fiscal.sc-codigo ped-fiscal.sc-codigo-rec ped-fiscal.nr-nota-fis 
          ped-fiscal.serie ped-fiscal.dt-emissao ped-fiscal.nat-oper 
          ped-fiscal.prioridade ped-fiscal.motivo-urg ped-fiscal.observacao[1] 
          ped-fiscal.observacao[2] 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-17 RECT-18 ped-fiscal.usuario-magnus 
         ped-fiscal.cod-estabel ped-fiscal.nr-pedido ped-fiscal.situacao 
         ped-fiscal.cod-emitente desc-emit ped-fiscal.cod-transp desc-emit-2 
         ped-fiscal.frete ped-fiscal.cod-rota ped-fiscal.nr-volumes 
         ped-fiscal.sc-codigo c-cc-aprov ped-fiscal.sc-codigo-rec c-cc-receb 
         ped-fiscal.nr-nota-fis ped-fiscal.serie ped-fiscal.dt-emissao 
         c-finalidade ped-fiscal.nat-oper c-nat ped-fiscal.prioridade 
         ped-fiscal.motivo-urg ped-fiscal.observacao[1] 
         ped-fiscal.observacao[2] c-receptor br-itens bt-ok bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields w-window 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                              
    DEF VAR c-desc AS CHAR FORMAT "x(100)" NO-UNDO.

    DISABLE ped-fiscal.nr-pedido     
            ped-fiscal.cod-estabel   
            ped-fiscal.situacao      
            ped-fiscal.cod-emitente  
            desc-emit
            ped-fiscal.cod-transp    
            desc-emit-2
            ped-fiscal.cod-rota      
            ped-fiscal.frete         
            ped-fiscal.nr-volumes    
            ped-fiscal.canal-vendas  
            ped-fiscal.ct-codigo     
            ped-fiscal.sc-codigo     
            ped-fiscal.sc-codigo-rec 
            ped-fiscal.nat-oper      
            ped-fiscal.dt-emissao    
            ped-fiscal.usuario-magnus
            ped-fiscal.nr-nota-fis   
            ped-fiscal.serie
            ped-fiscal.prioridade    
               
            ped-fiscal.observacao[1] 
            ped-fiscal.observacao[2]
            c-receptor
            c-finalidade
             WITH FRAME {&FRAME-NAME}.

    FIND natureza-ped-fiscal NO-LOCK
        WHERE natureza-ped-fiscal.natureza = ped-fiscal.nat-oper NO-ERROR.
    IF  AVAIL natureza-ped-fiscal  THEN
        ASSIGN c-nat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = natureza-ped-fiscal.descricao.

    /* CENTRO CUSTO APROVADOR */
    RUN pi-descricao-cc (INPUT  sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         OUTPUT c-desc).
    ASSIGN c-cc-aprov:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc.

    /* CENTRO CUSTO RECEBEDOR */
    RUN pi-descricao-cc (INPUT  sc-codigo-REC:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                         OUTPUT c-desc).
    ASSIGN c-cc-receb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc.

    FIND FIRST ped-fiscal WHERE ped-fiscal.nr-pedido = I-NumPedidoEsftp060 NO-LOCK NO-ERROR.
    IF AVAIL ped-fiscal THEN DO:

        ASSIGN ped-fiscal.nr-pedido     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.nr-pedido)
               ped-fiscal.cod-estabel   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.cod-estabel   
               ped-fiscal.situacao      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.situacao)
               ped-fiscal.cod-emitente  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.cod-emitente)  
               ped-fiscal.cod-transp    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.cod-transp)
               ped-fiscal.cod-rota      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.cod-rota      
               ped-fiscal.frete         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.frete)
               ped-fiscal.nr-volumes    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.nr-volumes)
               ped-fiscal.canal-vendas  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.canal-vendas)
               ped-fiscal.ct-codigo     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.ct-codigo)     
               ped-fiscal.sc-codigo     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.sc-codigo)     
               ped-fiscal.sc-codigo-rec :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.sc-codigo-rec) 
               ped-fiscal.nat-oper      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.nat-oper)
               ped-fiscal.dt-emissao    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.dt-emissao)
               ped-fiscal.usuario-magnus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.usuario-magnus 
               ped-fiscal.nr-nota-fis   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.nr-nota-fis   
               ped-fiscal.serie         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.serie
               ped-fiscal.prioridade    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-fiscal.prioridade)
               ped-fiscal.motivo-urg    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.motivo-urg    
               ped-fiscal.observacao[1] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.observacao[1] 
               ped-fiscal.observacao[2] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ped-fiscal.observacao[2] 
               c-receptor               :SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(ped-fiscal.char-1,90,40)
               c-finalidade             :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF ped-fiscal.nat-oper = 25 THEN 
                                                                                    SUBSTRING(ped-fiscal.char-1,88,2) ELSE 
                                                                                    SUBSTRING(ped-fiscal.char-1,150,500).

        FIND FIRST emitente WHERE emitente.cod-emitente = ped-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN desc-emit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = emitente.nome-emit  .

        FIND FIRST transporte WHERE transporte.cod-transp = ped-fiscal.cod-transp NO-LOCK NO-ERROR.
        IF AVAIL transporte THEN
            ASSIGN desc-emit-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = transporte.nome   .

    END.

    {&open-query-br-itens}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESFTP060a" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'local-display-fields':U ) .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-descricao-cc w-window 
PROCEDURE pi-descricao-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-custo     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-descricao AS CHAR NO-UNDO.
    
    DEF VAR h_api_ccusto        AS HANDLE NO-UNDO.
    DEF VAR v_des_titulo_ccusto AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF VAR v_cod_ccusto        AS CHAR NO-UNDO.

    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.
    run pi_busca_dados_ccusto in h_api_ccusto (input i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               input "",                  /* CODIGO DO PLANO CCUSTO */
                                               input p-custo ,            /* CCUSTO */
                                               input TODAY,                /* DATA DE TRANSACAO */
                                               output p-descricao,         /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).  /* ERROS */

    IF  VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    IF  CAN-FIND(FIRST tt_log_erro) THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
    END.
    
    RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "it-ped-fiscal"}
  {src/adm/template/snd-list.i "item"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

