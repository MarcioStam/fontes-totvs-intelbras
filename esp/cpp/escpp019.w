&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_impres_layout    AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so  AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_tit_prog_dtsul   AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hproc            AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-mes            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ano            AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-cod-b          AS CHAR      NO-UNDO.
DEFINE VARIABLE v-cod-n          AS CHAR      NO-UNDO.
DEFINE VARIABLE i-nr-sequencia   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cUltimaSequencia AS CHARACTER NO-UNDO.
DEFINE VARIABLE ultimaSequencia  AS INTEGER   NO-UNDO.
DEFINE VARIABLE tot-seq          AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPrinter         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxFile         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLayout          AS CHARACTER NO-UNDO.

{esp/showmsg.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME default-frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES item

/* Definitions for FRAME default-frame                                  */
&Scoped-define QUERY-STRING-default-frame FOR EACH item SHARE-LOCK
&Scoped-define OPEN-QUERY-default-frame OPEN QUERY default-frame FOR EACH item SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-default-frame item
&Scoped-define FIRST-TABLE-IN-QUERY-default-frame item


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-47 RECT-48 RECT-49 RECT-50 IMAGE-1 ~
IMAGE-2 fi-it-codigo fi-copias fi-sequencia fi-ultima-sequencia ~
bt-impressora fiPrinter btImprimir btsair tb-reimprime 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item fi-copias ~
fi-sequencia fi-ultima-sequencia fiPrinter tb-reimprime 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-barra C-Win 
FUNCTION fn-barra RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cont-barra C-Win 
FUNCTION fn-cont-barra RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-impressora 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.21.

DEFINE BUTTON btImprimir 
     LABEL "Imprimir" 
     SIZE 13 BY 1.13.

DEFINE BUTTON btsair 
     LABEL "Sair" 
     SIZE 13 BY 1.13.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 49.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fi-copias AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Qtde C¢pias" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE fi-sequencia AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ultima-sequencia AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.5.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.

DEFINE VARIABLE tb-reimprime AS LOGICAL INITIAL no 
     LABEL "Reimprimir etiquetas" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY default-frame FOR 
      item SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME default-frame
     fi-it-codigo AT ROW 1.79 COL 9 COLON-ALIGNED HELP
          "C¢digo do Item"
     fi-desc-item AT ROW 1.79 COL 24.14 COLON-ALIGNED NO-LABEL
     fi-copias AT ROW 4.54 COL 18.14 COLON-ALIGNED
     fi-sequencia AT ROW 5.54 COL 18.29 COLON-ALIGNED HELP
          "Sequencia Inicial"
     fi-ultima-sequencia AT ROW 5.54 COL 43.29 COLON-ALIGNED HELP
          "Sequencia Final" NO-LABEL
     bt-impressora AT ROW 8 COL 69.86 HELP
          "Configuraá∆o da impressora" WIDGET-ID 30 NO-TAB-STOP 
     fiPrinter AT ROW 8.13 COL 20.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 32
     btImprimir AT ROW 10.46 COL 4
     btsair AT ROW 10.46 COL 18
     tb-reimprime AT ROW 10.5 COL 49 WIDGET-ID 16
     "Impressora:" VIEW-AS TEXT
          SIZE 11.29 BY .67 AT ROW 8.29 COL 8.57 WIDGET-ID 36
     RECT-47 AT ROW 1.29 COL 2
     RECT-48 AT ROW 3.71 COL 2
     RECT-49 AT ROW 9.96 COL 2
     RECT-50 AT ROW 7.63 COL 2 WIDGET-ID 34
     IMAGE-1 AT ROW 5.54 COL 33 WIDGET-ID 8
     IMAGE-2 AT ROW 5.54 COL 41.43 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 14.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Etiquetas SOPHO"
         HEIGHT             = 11.21
         WIDTH              = 90.86
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 102.29
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 102.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME default-frame
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME default-frame
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:RETURN-INSERTED IN FRAME default-frame  = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME default-frame
/* Query rebuild information for FRAME default-frame
     _TblList          = "mgcad.item"
     _Query            is OPENED
*/  /* FRAME default-frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Etiquetas SOPHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Etiquetas SOPHO */
DO:

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME default-frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL default-frame C-Win
ON ENTRY OF FRAME default-frame
DO:
    fi-sequencia:SENSITIVE = FALSE.
    fi-ultima-sequencia:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impressora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressora C-Win
ON CHOOSE OF bt-impressora IN FRAME default-frame
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir C-Win
ON CHOOSE OF btImprimir IN FRAME default-frame /* Imprimir */
DO:

    IF fi-it-codigo:SCREEN-VALUE = "" THEN DO: 
        MESSAGE "Preencher o c¢digo do item" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

    find item where item.it-codigo = fi-it-codigo:screen-value no-lock no-error.
    if not avail item then do:
        MESSAGE "Item n∆o encontrado" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.    
    end.

    IF  fi-copias:SCREEN-VALUE = "0" THEN DO:
        MESSAGE "Preencher a quantidade de c¢pias" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

    IF  fiPrinter:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Selecione um impressora." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

    ASSIGN v_nom_disposit_so = "".
        
    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = ENTRY(1, fiPrinter:SCREEN-VALUE, ":":U)
          AND imprsor_usuar.cod_usuario    = v_cod_usuar_corren NO-LOCK NO-ERROR.
    IF AVAIL imprsor_usuar THEN
        ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.
    

    ASSIGN INPUT FRAME {&FRAME-NAME} fi-sequencia
           INPUT FRAME {&FRAME-NAME} fi-it-codigo
           INPUT FRAME {&FRAME-NAME} fi-copias.

    FIND item-mat NO-LOCK 
        WHERE item-mat.it-codigo = fi-it-codigo NO-ERROR.
    if  not avail item-mat then do:
        MESSAGE "Item ean n∆o encontrado" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.        
    end.

    FIND item-ean NO-LOCK 
        WHERE item-ean.it-codigo = fi-it-codigo NO-ERROR.
    if  not avail item-ean then do:
        MESSAGE "Item ean n∆o encontrado" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.        
    end.

    IF item-mat.cod-ean = "" THEN DO:
        MESSAGE "Item n∆o possui c¢digo EAN13. Solicitar a Engenharia Industrial." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

    ASSIGN i-nr-sequencia = fi-sequencia.

    CASE STRING(MONTH(TODAY),"99"):
        WHEN "01" THEN ASSIGN c-mes = "A".
        WHEN "02" THEN ASSIGN c-mes = "B".
        WHEN "03" THEN ASSIGN c-mes = "C".
        WHEN "04" THEN ASSIGN c-mes = "D".
        WHEN "05" THEN ASSIGN c-mes = "E".
        WHEN "06" THEN ASSIGN c-mes = "F".
        WHEN "07" THEN ASSIGN c-mes = "G".
        WHEN "08" THEN ASSIGN c-mes = "H".
        WHEN "09" THEN ASSIGN c-mes = "I".
        WHEN "10" THEN ASSIGN c-mes = "J".
        WHEN "11" THEN ASSIGN c-mes = "L".
        WHEN "12" THEN ASSIGN c-mes = "M".
    END CASE.

    CASE STRING(YEAR(TODAY),"9999"):
        WHEN "2006" THEN ASSIGN c-ano = "P".
        WHEN "2007" THEN ASSIGN c-ano = "Q".
        WHEN "2008" THEN ASSIGN c-ano = "R".
        WHEN "2009" THEN ASSIGN c-ano = "S".
        WHEN "2010" THEN ASSIGN c-ano = "T".
        WHEN "2011" THEN ASSIGN c-ano = "U".
        WHEN "2012" THEN ASSIGN c-ano = "V".
        WHEN "2013" THEN ASSIGN c-ano = "W".
        WHEN "2014" THEN ASSIGN c-ano = "X".
        WHEN "2015" THEN ASSIGN c-ano = "Y".
        WHEN "2016" THEN ASSIGN c-ano = "Z".
    END CASE.

    /*OUTPUT TO VALUE(v_nom_disposit_so) page-size 0 convert target SESSION:CHARSET.*/
    OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW832"      SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    /*PUT "^PQ" STRING(1, "9999") SKIP.  /* Quantidade de etiquetas a imprimir */*/

    DO i-cont = 1 TO fi-copias:
        RUN pi-imprime.
    END.

    PUT UNFORMATTED 
        "^XZ".

    OUTPUT CLOSE.

    /*N∆o Ç reimpress∆o atualiza sequencia*/
    IF NOT INPUT tb-reimprime THEN RUN atualiza-sequencia.
   
    ASSIGN fi-it-codigo:SCREEN-VALUE = ""
           fi-desc-item:SCREEN-VALUE = ""
           fi-copias:SCREEN-VALUE = ""
           fi-sequencia:SCREEN-VALUE = ""
           fi-ultima-sequencia:SCREEN-VALUE = ""
           fiPrinter:SCREEN-VALUE = "".

    APPLY "ENTRY":U TO fi-it-codigo IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btsair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btsair C-Win
ON CHOOSE OF btsair IN FRAME default-frame /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-copias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-copias C-Win
ON LEAVE OF fi-copias IN FRAME default-frame /* Qtde C¢pias */
DO:
   
        IF fi-copias:SCREEN-VALUE = "0" THEN DO:
            MESSAGE "Preencher a quantidade de c¢pias"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN fi-ultima-sequencia:SCREEN-VALUE = "".
        END.
        ELSE DO:
            ASSIGN tot-seq = INT(fi-sequencia:SCREEN-VALUE) + INT(fi-copias:SCREEN-VALUE) - 1.
                   fi-ultima-sequencia:SCREEN-VALUE = STRING(tot-seq).
        END.


        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo C-Win
ON LEAVE OF fi-it-codigo IN FRAME default-frame /* Item */
DO:
   if not input tb-reimprime then do:     
      FOR FIRST ITEM NO-LOCK
          WHERE ITEM.it-codigo = INPUT fi-it-codigo:
          DISP ITEM.desc-item @ fi-desc-item WITH FRAME {&FRAME-NAME}.

          IF ITEM.it-codigo = "4040053" THEN
              ASSIGN v-cod-b = "959116064100"
                     v-cod-n = "9591 160 64100 ".
          ELSE
              ASSIGN v-cod-b = "959116120000"
                     v-cod-n = "9591 161 20000 ".

      END.
    
      RUN busca-sequencia.
    
      ASSIGN fi-sequencia:SCREEN-VALUE = string(ultimaSequencia).
   end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sequencia C-Win
ON LEAVE OF fi-sequencia IN FRAME default-frame /* Sequencia */
DO:
   
ASSIGN tot-seq = INT(fi-sequencia:SCREEN-VALUE) + INT(fi-copias:SCREEN-VALUE) - 1
       fi-ultima-sequencia:SCREEN-VALUE = STRING(tot-seq).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-reimprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-reimprime C-Win
ON VALUE-CHANGED OF tb-reimprime IN FRAME default-frame /* Reimprimir etiquetas */
DO:

  if input tb-reimprime then do:
    enable fi-sequencia with frame DEFAULT-FRAME.
  end.
  else do:
    disable fi-sequencia with frame DEFAULT-FRAME.  
    RUN busca-sequencia.
    ASSIGN fi-sequencia:SCREEN-VALUE = string(ultimaSequencia). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  
    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = v_cod_usuar_corren
        AND   imprsor_usuar.log_imprsor_princ:
    
        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:
    
            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME default-frame = layout_impres.nom_impressora + ":" +
                                                                   layout_impres.cod_layout_impres.
    
        END.
    
    END.



  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza-sequencia C-Win 
PROCEDURE atualiza-sequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST mgesp.ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "escpp019"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    IF AVAIL ponto-programa THEN DO:

        FIND FIRST mgesp.conteudo-programa EXCLUSIVE-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
               AND conteudo-programa.sequencia    = 1 NO-ERROR.
        IF AVAIL conteudo-programa THEN DO:
            ASSIGN conteudo-programa.conteudo = STRING(i-nr-sequencia - 1).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-sequencia C-Win 
PROCEDURE busca-sequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /*INPUT FROM VALUE(cEndereco).                
        IMPORT DELIMITER ";" cUltimaSequencia.    
        ASSIGN ultimaSequencia = int(cUltimaSequencia)
               ultimaSequencia = ultimaSequencia + 1.
   INPUT CLOSE.*/


    RUN esp/es0018p.p (INPUT "escpp019", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   
 
    find first tt-prog-ponto
         where tt-prog-ponto.nome-programa = "escpp019"
           and tt-prog-ponto.ponto         = 1 NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN ultimaSequencia = INT(tt-prog-ponto.conteudo) + 1.
    END.
    ELSE 
        ASSIGN ultimaSequencia = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-default-frame}
  GET FIRST default-frame.
  DISPLAY fi-it-codigo fi-desc-item fi-copias fi-sequencia fi-ultima-sequencia 
          fiPrinter tb-reimprime 
      WITH FRAME default-frame IN WINDOW C-Win.
  ENABLE RECT-47 RECT-48 RECT-49 RECT-50 IMAGE-1 IMAGE-2 fi-it-codigo fi-copias 
         fi-sequencia fi-ultima-sequencia bt-impressora fiPrinter btImprimir 
         btsair tb-reimprime 
      WITH FRAME default-frame IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-default-frame}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime C-Win 
PROCEDURE pi-imprime :
DEFINE VARIABLE h-aux AS HANDLE NO-UNDO.

RUN esapi/esapi016.p PERSISTENT SET h-aux.
/*
RUN piCargaImagem("local-anatel").

    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^FO37,20^BY3^A0N,35,Y,N^FD" "SOPHO" "^FS" SKIP   
        "^FO37,55^BY3^A0N,17,Y,N^FD" "Produzido por:82.901.000/0001-27 IND.BRASILEIRA" "^FS" SKIP        
        "^FO37,80^BY1^BCN,50,N,N,N,N^SN"  + trim(fn-barra()) + "^FS" FORMAT "x(70)" SKIP
        "^FO37,140^A0N,24,24^FD" fn-cont-barra() FORMAT "x(30)" "^FS" SKIP
        "^FO30,160^XGlocal-anatel.GRF^FS" SKIP  /* Impressao da Imagem ANATEL */   
        "^FO160,160^BY1,3.0^BCN,24,N,N,N,N^FD010" item-mat.cod-ean "^FS" SKIP  /* Codigo de Barras EAN 128 */
        "^FO160,187^A0N,24,24^FD010" item-mat.cod-ean "^FS" SKIP  /* Valor do Codigo de Barras EAN 128 */
        "^FO160,210^A0N,44,34^FD" item-ean.linha[1] FORMAT "x(15)" "^FS" SKIP
        "^FO147,250^BY3^A0N,20,Y,N^FD" "Homol Anatel: " item-ean.homolog FORMAT "x(15)" "^FS" SKIP 
        "^XZ".
  */

RUN piCargaImagem IN h-aux (INPUT "local-anatel5").

PUT "^XA" SKIP.
PUT UNFORMATTED "^FO25,35^A0B,14,14^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO80,35^BY3^BEN,65,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO375,35^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
PUT UNFORMATTED "^FO20,150^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^FO20,185^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^LRY^FO25,140^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */
PUT UNFORMATTED "^FO60,225^BY1^BCN,24,N,N,N,N^FD" TRIM(fn-barra()) "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO30,255^A0N,18,18^FB368,1,0,C^FDNS:"fn-cont-barra() "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
/* PUT UNFORMATTED "^FO345,255^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */ */

{esapi/esapi016a2.i 425} /* Cabeáalho modelo */

PUT UNFORMATTED "^FO425,239^A0N,20,18^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
PUT UNFORMATTED "^FO425,259^A0N,14,12^FB210,1,0,C^FDNS:" fn-cont-barra()  "^FS" SKIP. /* Data - Etiqueta Pequena 1 */

PUT UNFORMATTED "^FO625,239^A0N,20,18^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
PUT UNFORMATTED "^FO625,259^A0N,14,12^FB210,1,0,C^FDNS:" fn-cont-barra()  "^FS" SKIP. /* Data - Etiqueta Pequena 1 */

PUT UNFORMATTED "^FO450,70^A0N,14,14^FDSOPHO^FS"                         SKIP.
PUT UNFORMATTED "^FO450,90^A0N,14,14^FDCNPJ: 82.901.000/0001-27 ^FS"                            SKIP.
PUT UNFORMATTED "^FO450,110^A0N,14,14^FD" item-ean.fone "^FS"                          SKIP.
PUT UNFORMATTED "^FO450,130^A0N,14,14^FB200,1,0,l^FDINDÈSTRIA BRASILEIRA^FS"       SKIP.
/* PUT UNFORMATTED "^FO615,90^A0N,14,14^FB200,1,0,R^FD" item-ean.origem "^FS"            SKIP. */
PUT UNFORMATTED "^FO450,150^A0N,14,14^FB200,1,0,L^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
PUT UNFORMATTED "^FO450,175^A0N,20,20^FB375,1,0,L^FDNS:"fn-cont-barra() "^FS"       SKIP.

PUT UNFORMATTED "^FO695,57^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */
                "^FO625,115^A0N,12,12^FB215,1,0,C^FD" item-ean.homolog "^FS"                   SKIP  /* homologaá∆o */
                "^FO665,129^BY1,3.0^BCN,24,N,N,N,N^FD>;010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
                "^FO625,158^A0N,12,12^FB215,1,0,C^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT "^XZ" SKIP.
PUT UNFORMATTED "^XA^IDlocal-anatel5.GRF^FS^XZ".

IF i-cont MOD 2 = 0 THEN do:
    ASSIGN i-nr-sequencia = i-nr-sequencia + 1.
END.

DELETE PROCEDURE h-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCargaImagem C-Win 
PROCEDURE piCargaImagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome   AS CHAR NO-UNDO.

    IF p-nome = "local-anatel" THEN
        PUT UNFORMATTED
            "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::".
 
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter C-Win 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME default-frame fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.


    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME default-frame.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-barra C-Win 
FUNCTION fn-barra RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
    RETURN v-cod-b + STRING(MONTH(TODAY),"99") + SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + "1" + STRING(MONTH(TODAY),"99") + STRING(i-nr-sequencia, "99999").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cont-barra C-Win 
FUNCTION fn-cont-barra RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN v-cod-n + STRING(MONTH(TODAY),"99") + SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + " " + c-ano + c-mes + "1" + STRING(i-nr-sequencia, "99999").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

