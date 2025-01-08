&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-produto
    FIELD nr-produto LIKE produto-contrato.nr-produto
    FIELD num-serie  LIKE produto-contrato.num-serie
    FIELD bm-codigo  LIKE produto-contrato.bm-codigo
    FIELD bm-indice  LIKE produto-contrato.bm-indice
    FIELD nf-fatura  LIKE produto-contrato.nf-fatura
    FIELD nf-pat     LIKE produto-contrato.nf-pat
    FIELD ser-fatura LIKE produto-contrato.ser-fatura
    FIELD ser-pat    LIKE produto-contrato.ser-pat
    FIELD it-codigo  LIKE produto-contrato.it-codigo
    FIELD desc-item  LIKE ITEM.desc-item.

DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

DEF VAR i-cont       AS INT.
DEF VAR i-contrato   AS INT.
DEF VAR i-cliente    AS INT.
DEF VAR i-nr-os      AS INT.

DEF BUFFER b-contrato-venda FOR contrato-venda.
DEF BUFFER b-os             FOR os.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brProduto

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-produto emitente

/* Definitions for BROWSE brProduto                                     */
&Scoped-define FIELDS-IN-QUERY-brProduto tt-produto.nr-produto tt-produto.desc-item tt-produto.num-serie tt-produto.bm-codigo tt-produto.bm-indice tt-produto.nf-fatura tt-produto.ser-fatura tt-produto.nf-pat tt-produto.ser-pat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brProduto tt-produto.num-serie ~
tt-produto.bm-codigo ~
tt-produto.bm-indice ~
tt-produto.nf-fatura ~
tt-produto.ser-fatura   tt-produto.nf-pat ~
 tt-produto.ser-pat   
&Scoped-define ENABLED-TABLES-IN-QUERY-brProduto tt-produto
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brProduto tt-produto
&Scoped-define SELF-NAME brProduto
&Scoped-define QUERY-STRING-brProduto FOR EACH tt-produto
&Scoped-define OPEN-QUERY-brProduto OPEN QUERY {&SELF-NAME} FOR EACH tt-produto.
&Scoped-define TABLES-IN-QUERY-brProduto tt-produto
&Scoped-define FIRST-TABLE-IN-QUERY-brProduto tt-produto


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brProduto}
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH emitente SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH emitente SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame emitente
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame emitente


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cod-contrato nome agencia nome-agencia ~
brProduto btOK btCancel RECT-1 RECT-2 RECT-3 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cod-contrato nome cod-emitente nome-abrev ~
agencia nome-agencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE agencia AS CHARACTER FORMAT "999999-x" 
     LABEL "Agencia" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE VARIABLE cod-contrato AS CHARACTER FORMAT "x(40)" 
     LABEL "Contrato" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88.

DEFINE VARIABLE cod-emitente AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE nome AS CHARACTER FORMAT "x(30)" 
     LABEL "Nome Master" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE nome-abrev AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .88.

DEFINE VARIABLE nome-agencia AS CHARACTER FORMAT "x(30)" 
     LABEL "Nome Agencia" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 116 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 116 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 116 BY 10.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 116 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brProduto FOR 
      tt-produto SCROLLING.

DEFINE QUERY Dialog-Frame FOR 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brProduto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brProduto Dialog-Frame _FREEFORM
  QUERY brProduto DISPLAY
      tt-produto.nr-produto 
    tt-produto.desc-item  COLUMN-LABEL "Descriá∆o Item"
    tt-produto.num-serie  COLUMN-LABEL "N£mero SÇrie" 
    tt-produto.bm-codigo  COLUMN-LABEL "C¢digo Bem"
    tt-produto.bm-indice  COLUMN-LABEL "Indice"
    tt-produto.nf-fatura  COLUMN-LABEL "NF Fatura"
    tt-produto.ser-fatura COLUMN-LABEL "SÇrie Fat"
    tt-produto.nf-pat     COLUMN-LABEL "NF Patrimìnio"
    tt-produto.ser-pat    COLUMN-LABEL "SÇrie Patrim"
ENABLE
    tt-produto.num-serie  
    tt-produto.bm-codigo  
    tt-produto.bm-indice  
    tt-produto.nf-fatura  
    tt-produto.ser-fatura
    tt-produto.nf-pat     
    tt-produto.ser-pat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114 BY 9.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cod-contrato AT ROW 1.58 COL 41.86 COLON-ALIGNED HELP
          "Digite o numero do contrato"
     nome AT ROW 2.58 COL 41.86 COLON-ALIGNED
     cod-emitente AT ROW 4.33 COL 41.86 COLON-ALIGNED
     nome-abrev AT ROW 4.33 COL 50.14 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     agencia AT ROW 5.33 COL 41.86 COLON-ALIGNED HELP
          "Informe a Agencia quando aplicavel"
     nome-agencia AT ROW 6.33 COL 41.86 COLON-ALIGNED HELP
          "Informe o nome da agencia"
     brProduto AT ROW 8.25 COL 2
     btOK AT ROW 18.25 COL 2
     btCancel AT ROW 18.25 COL 12
     RECT-1 AT ROW 1.25 COL 1
     RECT-2 AT ROW 4 COL 1
     RECT-3 AT ROW 7.75 COL 1
     rtToolBar AT ROW 18 COL 1
     "Contrato" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 1 COL 2
     "Cliente" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 3.75 COL 2
     "Produto / OS" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 7.5 COL 2
     SPACE(105.71) SKIP(11.40)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Manutená∆o de Contrato - ft4003-upca.w"
         DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.


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
                                                                        */
/* BROWSE-TAB brProduto nome-agencia Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cod-emitente IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nome-abrev IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brProduto
/* Query rebuild information for BROWSE brProduto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-produto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brProduto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "mgcad.emitente"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Manutená∆o de Contrato - ft4003-upca.w */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME agencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia Dialog-Frame
ON ENTRY OF agencia IN FRAME Dialog-Frame /* Agencia */
DO:
    ASSIGN agencia:FORMAT IN FRAME {&FRAME-NAME} = "x(7)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia Dialog-Frame
ON LEAVE OF agencia IN FRAME Dialog-Frame /* Agencia */
DO:
  IF INPUT FRAME {&FRAME-NAME} agencia <> "" THEN 
      ASSIGN agencia:FORMAT IN FRAME {&FRAME-NAME} = "999999-x".
  ELSE
      ASSIGN agencia:FORMAT IN FRAME {&FRAME-NAME} = "x(7)".
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel Dialog-Frame
ON CHOOSE OF btCancel IN FRAME Dialog-Frame /* Cancelar */
DO:
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK Dialog-Frame
ON CHOOSE OF btOK IN FRAME Dialog-Frame /* OK */
DO:
    IF AVAIL nota-fiscal THEN DO:

        IF INPUT FRAME {&FRAME-NAME} cod-contrato = "" THEN DO:
            MESSAGE "Contrato n∆o informado"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry" TO cod-contrato IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.                                            
        END.

        IF INPUT FRAME {&FRAME-NAME} nome = "" THEN DO:
            MESSAGE "Nome contrato n∆o informado"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry" TO cod-contrato IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.                                            
        END.
        /*
        IF INPUT FRAME {&FRAME-NAME} agencia = "" THEN DO:
            MESSAGE "Agància n∆o informada"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry" TO cod-contrato IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.                                            
        END.

        IF INPUT FRAME {&FRAME-NAME} nome-agencia = "" THEN DO:
            MESSAGE "Nome da agància n∆o informado"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry" TO cod-contrato IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.                                            
        END.
        */
        FIND LAST b-contrato-venda NO-LOCK NO-ERROR.
        IF AVAIL b-contrato-venda THEN
            ASSIGN i-contrato = b-contrato-venda.numero + 1.
        ELSE 
            ASSIGN i-contrato = 1.

        FIND FIRST contrato-venda EXCLUSIVE-LOCK
            WHERE contrato-venda.cod-contrato = INPUT FRAME {&FRAME-NAME} cod-contrato NO-ERROR.
        IF NOT AVAIL contrato-venda THEN DO:
            CREATE contrato-venda.
            ASSIGN contrato-venda.numero       = i-contrato
                   contrato-venda.cod-tipo     = 2
                   contrato-venda.cod-contrato = INPUT FRAME {&FRAME-NAME} cod-contrato
                   contrato-venda.data         = TODAY
                   contrato-venda.nome         = INPUT FRAME {&FRAME-NAME} nome.
        END.
        ELSE
            ASSIGN contrato-venda.nome = INPUT FRAME {&FRAME-NAME} nome.

        FIND LAST cliente-final NO-LOCK
            WHERE cliente-final.numero = contrato-venda.numero NO-ERROR.
        IF AVAIL cliente-final THEN
            ASSIGN i-cliente = cliente-final.nr-cli-fin + 1.
        ELSE 
            ASSIGN i-cliente = 1.

        CREATE cliente-final.
        ASSIGN cliente-final.numero       = contrato-venda.numero
               cliente-final.nr-cli-fin   = i-cliente
               cliente-final.agencia      = INPUT FRAME {&FRAME-NAME} agencia
               cliente-final.nome-agencia = INPUT FRAME {&FRAME-NAME} nome-agencia
               cliente-final.cod-emitente = nota-fiscal.cod-emitente.

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = cliente-final.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN 
            ASSIGN cliente-final.endereco = emitente.endereco-cob 
                   cliente-final.estado   = emitente.estado-cob 
                   cliente-final.bairro   = emitente.bairro-cob
                   cliente-final.cep      = INT(emitente.cep-cob)    
                   cliente-final.cidade   = emitente.cidade-cob.

        FOR EACH tt-produto:

            CREATE produto-contrato.
            ASSIGN produto-contrato.numero     = contrato-venda.numero
                   produto-contrato.nr-cli-fin = cliente-final.nr-cli-fin
                   produto-contrato.nr-produto = tt-produto.nr-produto
                   produto-contrato.num-serie  = tt-produto.num-serie
                   produto-contrato.bm-codigo  = tt-produto.bm-codigo
                   produto-contrato.bm-indice  = tt-produto.bm-indice
                   produto-contrato.nf-fatura  = tt-produto.nf-fatura
                   produto-contrato.nf-pat     = tt-produto.nf-pat
                   produto-contrato.ser-fatura = tt-produto.ser-fatura
                   produto-contrato.ser-pat    = tt-produto.ser-pat
                   produto-contrato.it-codigo  = tt-produto.it-codigo
                   produto-contrato.descricao  = tt-produto.desc-item.

            FIND LAST b-os NO-LOCK NO-ERROR.
                ASSIGN i-nr-os = IF AVAIL b-os THEN b-os.nr-os + 1 ELSE 1.

            CREATE os.
            ASSIGN os.nr-os         = i-nr-os
                   os.numero        = contrato-venda.numero
                   os.nr-cli-fin    = cliente-final.nr-cli-fin
                   os.nr-produto    = tt-produto.nr-produto
                   os.tipo          = NO
                   os.data-abertura = nota-fiscal.dt-emis-nota
                   os.tipo-os       = 1.
        END.

        MESSAGE "Criado contrato n£mero " contrato-venda.numero
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-contrato Dialog-Frame
ON LEAVE OF cod-contrato IN FRAME Dialog-Frame /* Contrato */
DO:
  FIND FIRST contrato-venda NO-LOCK
      WHERE contrato-venda.cod-contrato = INPUT FRAME {&FRAME-NAME} cod-contrato NO-ERROR.
  IF AVAIL contrato-venda THEN DO:
      ASSIGN nome:SCREEN-VALUE IN FRAME {&FRAME-NAME} = contrato-venda.nome.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brProduto
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

  RUN pi-monta-display.

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
  DISPLAY cod-contrato nome cod-emitente nome-abrev agencia nome-agencia 
      WITH FRAME Dialog-Frame.
  ENABLE cod-contrato nome agencia nome-agencia brProduto btOK btCancel RECT-1 
         RECT-2 RECT-3 rtToolBar 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-display Dialog-Frame 
PROCEDURE pi-monta-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST nota-fiscal NO-LOCK
      WHERE ROWID(nota-fiscal) = p-rowid NO-ERROR.
  IF AVAIL nota-fiscal THEN DO:
      ASSIGN cod-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(nota-fiscal.cod-emitente).
      FIND FIRST emitente NO-LOCK
          WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
      IF AVAIL emitente THEN
          ASSIGN nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME} = emitente.nome-abrev.

      ASSIGN i-cont = 0.
      FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
          FIRST ITEM OF it-nota-fisc NO-LOCK:

          ASSIGN i-cont = i-cont + 1.

          CREATE tt-produto.
          ASSIGN tt-produto.nr-produto = i-cont
                 tt-produto.it-codigo  = it-nota-fisc.it-codigo
                 tt-produto.desc-item  = ITEM.desc-item.
      END.

      {&OPEN-QUERY-{&BROWSE-NAME}}
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

