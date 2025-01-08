&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME eswmp015
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS eswmp015 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
{include/i-prgvrs.i wswm015 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-int-wms-nf-atualiz
     LIKE int-wms-nf-atualiz.

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-wm

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-wms-nf-atualiz

/* Definitions for BROWSE br-wm                                         */
&Scoped-define FIELDS-IN-QUERY-br-wm tt-int-wms-nf-atualiz.cod-estabel tt-int-wms-nf-atualiz.serie tt-int-wms-nf-atualiz.nr-nota-fis tt-int-wms-nf-atualiz.nr-seq-fat tt-int-wms-nf-atualiz.it-codigo tt-int-wms-nf-atualiz.cod-depos tt-int-wms-nf-atualiz.qt-baixada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-wm   
&Scoped-define SELF-NAME br-wm
&Scoped-define QUERY-STRING-br-wm FOR EACH tt-int-wms-nf-atualiz
&Scoped-define OPEN-QUERY-br-wm OPEN QUERY {&SELF-NAME} FOR EACH tt-int-wms-nf-atualiz.
&Scoped-define TABLES-IN-QUERY-br-wm tt-int-wms-nf-atualiz
&Scoped-define FIRST-TABLE-IN-QUERY-br-wm tt-int-wms-nf-atualiz


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-wm}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-estab fi-serie fi-nota bt-filtro br-wm ~
bt-ok bt-cancela rt-buttom RECT-20 
&Scoped-Define DISPLAYED-OBJECTS fi-estab fi-serie fi-nota 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR eswmp015 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Eliminar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nota AS CHARACTER FORMAT "X(9)":U 
     LABEL "Nr. Nota" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 4.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 111 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-wm FOR 
      tt-int-wms-nf-atualiz SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-wm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-wm eswmp015 _FREEFORM
  QUERY br-wm DISPLAY
      tt-int-wms-nf-atualiz.cod-estabel
tt-int-wms-nf-atualiz.serie
tt-int-wms-nf-atualiz.nr-nota-fis
tt-int-wms-nf-atualiz.nr-seq-fat
tt-int-wms-nf-atualiz.it-codigo
tt-int-wms-nf-atualiz.cod-depos   COLUMN-LABEL "Dep¢sito"    WIDTH 8
tt-int-wms-nf-atualiz.qt-baixada  COLUMN-LABEL "Qt. Baixada" WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110.72 BY 5.29 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-estab AT ROW 1.83 COL 14 COLON-ALIGNED WIDGET-ID 4
     fi-serie AT ROW 2.83 COL 14 COLON-ALIGNED WIDGET-ID 6
     fi-nota AT ROW 3.83 COL 14 COLON-ALIGNED WIDGET-ID 8
     bt-filtro AT ROW 3.75 COL 29.86 WIDGET-ID 10
     br-wm AT ROW 5.71 COL 2.29 WIDGET-ID 200
     bt-ok AT ROW 11.5 COL 2.86 WIDGET-ID 16
     bt-cancela AT ROW 11.5 COL 102.29 WIDGET-ID 14
     bt-ajuda AT ROW 11.5 COL 91 WIDGET-ID 12
     rt-buttom AT ROW 11.29 COL 2 WIDGET-ID 18
     RECT-20 AT ROW 1.33 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.72 BY 12 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW eswmp015 ASSIGN
         HIDDEN             = YES
         TITLE              = "Eliminaá∆o int-wms-nf-atualiz"
         HEIGHT             = 12.04
         WIDTH              = 113
         MAX-HEIGHT         = 29.38
         MAX-WIDTH          = 194.29
         VIRTUAL-HEIGHT     = 29.38
         VIRTUAL-WIDTH      = 194.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB eswmp015 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW eswmp015
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-wm bt-filtro fpage0 */
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(eswmp015)
THEN eswmp015:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-wm
/* Query rebuild information for BROWSE br-wm
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-wms-nf-atualiz.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-wm */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME eswmp015
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL eswmp015 eswmp015
ON END-ERROR OF eswmp015 /* Eliminaá∆o int-wms-nf-atualiz */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL eswmp015 eswmp015
ON WINDOW-CLOSE OF eswmp015 /* Eliminaá∆o int-wms-nf-atualiz */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda eswmp015
ON CHOOSE OF bt-ajuda IN FRAME fpage0 /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela eswmp015
ON CHOOSE OF bt-cancela IN FRAME fpage0 /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro eswmp015
ON CHOOSE OF bt-filtro IN FRAME fpage0
DO:

  EMPTY TEMP-TABLE tt-int-wms-nf-atualiz.

  FOR EACH int-wms-nf-atualiz NO-LOCK
      WHERE int-wms-nf-atualiz.cod-estabel = INPUT FRAME fpage0 fi-estab
        AND int-wms-nf-atualiz.serie       = INPUT FRAME fpage0 fi-serie
        AND int-wms-nf-atualiz.nr-nota-fis = INPUT FRAME fpage0 fi-nota:

      CREATE tt-int-wms-nf-atualiz.
      BUFFER-COPY int-wms-nf-atualiz TO tt-int-wms-nf-atualiz.
  END.

  {&open-query-br-wm}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok eswmp015
ON CHOOSE OF bt-ok IN FRAME fpage0 /* Eliminar */
DO:
  
    FOR FIRST mgesp.ponto-programa
        where ponto-programa.nome-programa = "eswmp015"
          AND ponto-programa.ponto = 1
        ,FIRST mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.conteudo = c-seg-usuario:
    END.
    IF  NOT AVAIL conteudo-programa THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                          17006,
                          "Usuario " + c-seg-usuario + " n∆o possui permiss∆o de eliminaá∆o.~~Favor entrar em contato com o usu†rio chave da †rea.").
        RETURN NO-APPLY.
    END.



    IF  NOT CAN-FIND(FIRST int-wms-nf-atualiz
                        WHERE int-wms-nf-atualiz.cod-estabel = INPUT FRAME fpage0 fi-estab 
                          AND int-wms-nf-atualiz.serie       = INPUT FRAME fpage0 fi-serie
                          AND int-wms-nf-atualiz.nr-nota-fis = INPUT FRAME fpage0 fi-nota) THEN DO:
         RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Nenhum registro localizado para a seleá∆o").
         RETURN NO-APPLY.
    END.

    /*CONFIRMA A EXECUÄ«O OFICIAL*/
    RUN utp/ut-msgs.p (input "show", 
                       input 27100, 
                       input "Atená∆o! Os Registros da tabela int-wms-nf-atualiz para essa nota ser∆o eliminados. Confirma?").
    IF  RETURN-VALUE <> "YES" THEN 
        RETURN NO-APPLY.

    DO TRANS:
        FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK                      
            WHERE int-wms-nf-atualiz.cod-estabel = INPUT FRAME fpage0 fi-estab    
              AND int-wms-nf-atualiz.serie       = INPUT FRAME fpage0 fi-serie 
              AND int-wms-nf-atualiz.nr-nota-fis = INPUT FRAME fpage0 fi-nota:

            FIND FIRST tab-generica EXCLUSIVE-LOCK
                WHERE tab-generica.utilizacao = "int-wms-nf-atualiz"
                  AND tab-generica.char-1     = int-wms-nf-atualiz.cod-estabel         + ";" +  
                                                int-wms-nf-atualiz.serie               + ";" +
                                                int-wms-nf-atualiz.nr-nota-fis         + ";" + 
                                                string(int-wms-nf-atualiz.nr-seq-fat)  + ";" + 
                                                int-wms-nf-atualiz.it-codigo no-error. /*chave PU da int-wms-nf-atualiz*/
            IF  NOT AVAIL tab-generica THEN DO:
                CREATE tab-generica.
                ASSIGN tab-generica.utilizacao = "int-wms-nf-atualiz"
                       tab-generica.char-1     = int-wms-nf-atualiz.cod-estabel        + ";" + 
                                                 int-wms-nf-atualiz.serie              + ";" + 
                                                 int-wms-nf-atualiz.nr-nota-fis        + ";" + 
                                                 string(int-wms-nf-atualiz.nr-seq-fat) + ";" + 
                                                 int-wms-nf-atualiz.it-codigo.
            END.
            ASSIGN tab-generica.char-2 = int-wms-nf-atualiz.cod-depos          + ";" + 
                                         STRING(int-wms-nf-atualiz.qt-baixada) + ";" + 
                                         c-seg-usuario                         + ";" + 
                                         string(TODAY, "99/99/9999")           + ";" + 
                                         STRING(TIME,"HH:MM:SS"). /* demais campos para recompor ou auditar eliminaá∆o*/

            DELETE int-wms-nf-atualiz.                                  
        END.                                                            
    END.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Registros eliminados com sucesso!").

    APPLY "choose" TO bt-filtro IN FRAME fpage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-wm
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK eswmp015 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects eswmp015  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available eswmp015  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI eswmp015  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(eswmp015)
  THEN DELETE WIDGET eswmp015.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI eswmp015  _DEFAULT-ENABLE
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
  DISPLAY fi-estab fi-serie fi-nota 
      WITH FRAME fpage0 IN WINDOW eswmp015.
  ENABLE fi-estab fi-serie fi-nota bt-filtro br-wm bt-ok bt-cancela rt-buttom 
         RECT-20 
      WITH FRAME fpage0 IN WINDOW eswmp015.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW eswmp015.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit eswmp015 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records eswmp015  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-int-wms-nf-atualiz"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed eswmp015 
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

