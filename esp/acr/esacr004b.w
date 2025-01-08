&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER pRwFedex AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES fedex

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame fedex.cod_usuario fedex.tipo ~
fedex.data-sol fedex.encerrado fedex.empresa fedex.material fedex.cod_estab ~
fedex.cod-mensagem fedex.conhecimento fedex.recebido fedex.dt-rec ~
fedex.ct-codigo fedex.cc-codigo fedex.mp fedex.cod-transp fedex.usuar-mat ~
fedex.desc-sdcv fedex.usuar-retira fedex.dt-retira fedex.freight ~
fedex.valor-frete fedex.dt-emis-frete fedex.dt-venc-frete ~
fedex.cod-emitente-imp fedex.dt-ap-frete fedex.fatura-frete fedex.duties ~
fedex.valor-imp fedex.dt-emis-imp fedex.dt-venc-imp fedex.cod-emit-frete ~
fedex.dt-ap-imp fedex.fatura-imp fedex.icms fedex.nota 
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH fedex ~
      WHERE rowid(fedex) = pRwFedex NO-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH fedex ~
      WHERE rowid(fedex) = pRwFedex NO-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame fedex
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame fedex


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-32 RECT-33 RECT-34 RECT-35 ~
RECT-36 Btn_OK 
&Scoped-Define DISPLAYED-FIELDS fedex.cod_usuario fedex.tipo fedex.data-sol ~
fedex.encerrado fedex.empresa fedex.material fedex.cod_estab ~
fedex.cod-mensagem fedex.conhecimento fedex.recebido fedex.dt-rec ~
fedex.ct-codigo fedex.cc-codigo fedex.mp fedex.cod-transp fedex.usuar-mat ~
fedex.desc-sdcv fedex.usuar-retira fedex.dt-retira fedex.freight ~
fedex.valor-frete fedex.dt-emis-frete fedex.dt-venc-frete ~
fedex.cod-emitente-imp fedex.dt-ap-frete fedex.fatura-frete fedex.duties ~
fedex.valor-imp fedex.dt-emis-imp fedex.dt-venc-imp fedex.cod-emit-frete ~
fedex.dt-ap-imp fedex.fatura-imp fedex.icms fedex.nota 
&Scoped-define DISPLAYED-TABLES fedex
&Scoped-define FIRST-DISPLAYED-TABLE fedex
&Scoped-Define DISPLAYED-OBJECTS c-nome cMensagem cDesc_usuar_mat ~
v_cond_pag cDesc_usuar_ret 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88.

DEFINE VARIABLE cDesc_usuar_mat AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE cDesc_usuar_ret AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE cMensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE v_cond_pag AS CHARACTER FORMAT "X(15)":U 
     LABEL "Cond Pag" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.25.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 7.67.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.25.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.25.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      fedex SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fedex.cod_usuario AT ROW 1.17 COL 9 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-nome AT ROW 1.17 COL 15 COLON-ALIGNED NO-LABEL
     fedex.tipo AT ROW 1.17 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fedex.data-sol AT ROW 1.17 COL 60 COLON-ALIGNED
          LABEL "Data"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.encerrado AT ROW 1.17 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fedex.empresa AT ROW 2.75 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     fedex.material AT ROW 2.75 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.86 BY .88
     fedex.cod_estab AT ROW 3.75 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     fedex.cod-mensagem AT ROW 3.75 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     cMensagem AT ROW 3.75 COL 56 COLON-ALIGNED NO-LABEL
     fedex.conhecimento AT ROW 4.75 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     fedex.recebido AT ROW 4.75 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fedex.dt-rec AT ROW 4.75 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.ct-codigo AT ROW 5.75 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.cc-codigo AT ROW 5.75 COL 27 COLON-ALIGNED
          LABEL "CC"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fedex.mp AT ROW 5.75 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fedex.cod-transp AT ROW 5.75 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     fedex.usuar-mat AT ROW 6.75 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cDesc_usuar_mat AT ROW 6.75 COL 23.57 COLON-ALIGNED NO-LABEL
     v_cond_pag AT ROW 7.75 COL 11 COLON-ALIGNED WIDGET-ID 4
     fedex.desc-sdcv AT ROW 7.75 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     fedex.usuar-retira AT ROW 8.75 COL 11.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cDesc_usuar_ret AT ROW 8.75 COL 23.57 COLON-ALIGNED NO-LABEL
     fedex.dt-retira AT ROW 8.75 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.freight AT ROW 10.75 COL 11 COLON-ALIGNED
          LABEL "Tipo"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     fedex.valor-frete AT ROW 10.75 COL 27 COLON-ALIGNED
          LABEL "Valor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fedex.dt-emis-frete AT ROW 10.75 COL 48 COLON-ALIGNED
          LABEL "Emiss∆o"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.dt-venc-frete AT ROW 10.75 COL 69 COLON-ALIGNED
          LABEL "Vencimento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.cod-emitente-imp AT ROW 11.75 COL 11 COLON-ALIGNED
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fedex.dt-ap-frete AT ROW 11.75 COL 27 COLON-ALIGNED
          LABEL "Int"
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     fedex.fatura-frete AT ROW 11.75 COL 48 COLON-ALIGNED
          LABEL "Fatura"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fedex.duties AT ROW 13.5 COL 11 COLON-ALIGNED
          LABEL "Tipo"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     fedex.valor-imp AT ROW 13.5 COL 27 COLON-ALIGNED
          LABEL "Valor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fedex.dt-emis-imp AT ROW 13.5 COL 48 COLON-ALIGNED
          LABEL "Emiss∆o"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.dt-venc-imp AT ROW 13.5 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.cod-emit-frete AT ROW 14.5 COL 11 COLON-ALIGNED
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fedex.dt-ap-imp AT ROW 14.5 COL 27 COLON-ALIGNED
          LABEL "Int"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fedex.fatura-imp AT ROW 14.5 COL 48 COLON-ALIGNED
          LABEL "Fatura"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     fedex.icms AT ROW 14.5 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fedex.nota AT ROW 16 COL 11 COLON-ALIGNED
          LABEL "Nota Fiscal"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     Btn_OK AT ROW 18.58 COL 2
     "[ 12267 - RAF / 5055 - FEDEX / 13 - UPS / 5145 - DHL / Outro Transp.]" VIEW-AS TEXT
          SIZE 69 BY .54 AT ROW 17.25 COL 13
     "Frete:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 10.33 COL 3
     "Impostos:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 13.08 COL 3
     RECT-2 AT ROW 18.33 COL 1
     RECT-32 AT ROW 1 COL 1
     RECT-33 AT ROW 2.5 COL 1
     RECT-34 AT ROW 10.58 COL 1
     RECT-35 AT ROW 13.33 COL 1
     RECT-36 AT ROW 15.83 COL 1
     SPACE(0.00) SKIP(1.83)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Detalhes do Controle de Frete - ESACR004B".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-nome IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.cc-codigo IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cDesc_usuar_mat IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cDesc_usuar_ret IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cMensagem IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.cod-emit-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.cod-emitente-imp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.cod-mensagem IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.cod-transp IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.cod_estab IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.cod_usuario IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.conhecimento IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.ct-codigo IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.data-sol IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.desc-sdcv IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.dt-ap-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.dt-ap-imp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.dt-emis-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.dt-emis-imp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.dt-rec IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.dt-retira IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.dt-venc-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.dt-venc-imp IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.duties IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.empresa IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.encerrado IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.fatura-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.fatura-imp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.freight IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.icms IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.material IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.mp IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.nota IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.recebido IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.tipo IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.usuar-mat IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.usuar-retira IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.valor-frete IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fedex.valor-imp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN v_cond_pag IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "mgesp.fedex"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "rowid(fedex) = pRwFedex"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Detalhes do Controle de Frete - ESACR004B */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  
  ASSIGN fedex.usuar-mat:LABEL    IN FRAME {&FRAME-NAME} = "Usuar Mat"
         fedex.usuar-retira:LABEL IN FRAME {&FRAME-NAME} = "Usuar Ret"
         fedex.desc-sdcv:LABEL    IN FRAME {&FRAME-NAME} = "Nr SDCVÔs"
         fedex.cod_estab:LABEL    IN FRAME {&FRAME-NAME} = "Estab".

  FIND mensagem NO-LOCK WHERE mensagem.cod-mensagem = fedex.cod-mensagem NO-ERROR.
  
  IF AVAILABLE mensagem THEN
      ASSIGN cMensagem = mensagem.descricao.

  FIND usuar_mestre NO-LOCK 
      WHERE usuar_mestre.cod_usuario = fedex.cod_usuario NO-ERROR.
  
  ASSIGN c-nome = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "Eliminado".

  ASSIGN cDesc_usuar_mat = ""
         cDesc_usuar_ret = "".
  
  IF  fedex.usuar-mat <> "" THEN DO:  
      FIND FIRST usuar_mestre NO-LOCK 
         WHERE usuar_mestre.cod_usuario = fedex.usuar-mat NO-ERROR.

      assign cDesc_usuar_mat = usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre.
  END.
  
  IF  fedex.usuar-retira <> "" THEN DO:  
      FIND FIRST usuar_mestre NO-LOCK 
         WHERE usuar_mestre.cod_usuario = fedex.usuar-retira NO-ERROR.

      assign cDesc_usuar_ret = usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre.
  END.

  IF  fedex.cod-cond-pag = 1 THEN
      ASSIGN v_cond_pag = "Com Pagamento".

  IF  fedex.cod-cond-pag = 2 THEN
      ASSIGN v_cond_pag = "Sem Pagamento".

  IF  fedex.cod-cond-pag = 3 THEN
      ASSIGN v_cond_pag = "Cart∆o de CrÇdito".

  DISPLAY cMensagem 
          cDesc_usuar_mat
          cDesc_usuar_ret
          c-nome
          v_cond_pag
          WITH FRAME {&FRAME-NAME}.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  DISPLAY c-nome cMensagem cDesc_usuar_mat v_cond_pag cDesc_usuar_ret 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE fedex THEN 
    DISPLAY fedex.cod_usuario fedex.tipo fedex.data-sol fedex.encerrado 
          fedex.empresa fedex.material fedex.cod_estab fedex.cod-mensagem 
          fedex.conhecimento fedex.recebido fedex.dt-rec fedex.ct-codigo 
          fedex.cc-codigo fedex.mp fedex.cod-transp fedex.usuar-mat 
          fedex.desc-sdcv fedex.usuar-retira fedex.dt-retira fedex.freight 
          fedex.valor-frete fedex.dt-emis-frete fedex.dt-venc-frete 
          fedex.cod-emitente-imp fedex.dt-ap-frete fedex.fatura-frete 
          fedex.duties fedex.valor-imp fedex.dt-emis-imp fedex.dt-venc-imp 
          fedex.cod-emit-frete fedex.dt-ap-imp fedex.fatura-imp fedex.icms 
          fedex.nota 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-2 RECT-32 RECT-33 RECT-34 RECT-35 RECT-36 Btn_OK 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

