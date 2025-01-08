&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-titulos NO-UNDO
    FIELD cod-estabel   AS CHARACTER
    FIELD matriz        AS INTEGER
    FIELD nome-matriz   AS CHARACTER 
    FIELD num-id-titulo AS INTEGER
    FIELD documento     AS CHARACTER
    FIELD cod-unid-neg  AS CHARACTER 
    FIELD periodo       AS CHARACTER 
    FIELD valor-movto   AS DECIMAL
    FIELD valor-titulo  AS DECIMAL
    FIELD saldo-titulo  AS DECIMAL
    FIELD diferenca     AS DECIMAL
    FIELD forma-pagto   AS CHARACTER
    FIELD incidencia    AS CHARACTER
    FIELD pagto         AS CHARACTER.

DEFINE TEMP-TABLE tt-movimentos NO-UNDO
    LIKE movto-acordo-fatur
    FIELD valor-cancelado AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD valor-liquido   AS DECIMAL FORMAT "->>>,>>>,>>9.99".

def new global shared var v_rec_tit_ap as RECID format ">>>>>>9":U initial ? no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-movimentos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-movimentos tt-titulos

/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-movimentos.num-id-movto tt-movimentos.usuario tt-movimentos.data tt-movimentos.hora tt-movimentos.valor tt-movimentos.valor-cancelado tt-movimentos.valor-liquido   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos   
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH tt-movimentos WHERE tt-movimentos.num-id-titulo = tt-titulos.num-id-titulo
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos WHERE tt-movimentos.num-id-titulo = tt-titulos.num-id-titulo.
&Scoped-define TABLES-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos tt-movimentos


/* Definitions for BROWSE br-titulos                                    */
&Scoped-define FIELDS-IN-QUERY-br-titulos tt-titulos.cod-estabel tt-titulos.matriz tt-titulos.nome-matriz tt-titulos.periodo tt-titulos.documento tt-titulos.valor-titulo tt-titulos.valor-movto tt-titulos.saldo-titulo tt-titulos.diferenca tt-titulos.forma-pagto tt-titulos.incidencia tt-titulos.pagto
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-titulos   
&Scoped-define SELF-NAME br-titulos
&Scoped-define QUERY-STRING-br-titulos FOR EACH tt-titulos NO-LOCK                            WHERE (IF INPUT FRAME fPage0 tg-diferenca                                   THEN tt-titulos.diferenca <> 0                                   ELSE TRUE)
&Scoped-define OPEN-QUERY-br-titulos OPEN QUERY {&SELF-NAME} FOR EACH tt-titulos NO-LOCK                            WHERE (IF INPUT FRAME fPage0 tg-diferenca                                   THEN tt-titulos.diferenca <> 0                                   ELSE TRUE).
&Scoped-define TABLES-IN-QUERY-br-titulos tt-titulos
&Scoped-define FIRST-TABLE-IN-QUERY-br-titulos tt-titulos


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-movimentos}~
    ~{&OPEN-QUERY-br-titulos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 fi-cod-estabel fi-matriz fi-periodo ~
fi-cod-unid-neg tg-diferenca btCarrega br-titulos btTitulo br-movimentos ~
btDetalhar btBaixa btEstorno btFechar btHelp2 btQueryJoins btReportsJoins ~
btExit btHelp rtToolBar-2 rtToolBar RECT-12 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel fi-matriz fi-periodo ~
fi-cod-unid-neg tg-diferenca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btBaixa 
     LABEL "Baixa" 
     SIZE 10 BY 1.

DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Carrega" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btDetalhar 
     LABEL "Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEstorno 
     LABEL "Estorno" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btTitulo 
     LABEL "T¡tulo" 
     SIZE 8 BY 1.

DEFINE BUTTON BUTTON-1 
     LABEL "Enctro Contas" 
     SIZE 11 BY 1.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-neg AS CHARACTER FORMAT "x(03)":U 
     LABEL "Unid. Neg" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-matriz AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Matriz" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "X(6)":U 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 2.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-diferenca AS LOGICAL INITIAL yes 
     LABEL "Listar somente diferen‡as?" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-movimentos FOR 
      tt-movimentos SCROLLING.

DEFINE QUERY br-titulos FOR 
      tt-titulos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos wWindow _FREEFORM
  QUERY br-movimentos DISPLAY
      tt-movimentos.num-id-movto
      tt-movimentos.usuario
      tt-movimentos.data            COLUMN-LABEL "Data"           WIDTH 10
      tt-movimentos.hora            COLUMN-LABEL "Hora"           WIDTH 8
      tt-movimentos.valor           COLUMN-LABEL "Valor Total"   FORMAT "->>>,>>>,>>9.99" WIDTH 15
      tt-movimentos.valor-cancelado COLUMN-LABEL "Valor Cancel"  FORMAT "->>>,>>>,>>9.99" WIDTH 15
      tt-movimentos.valor-liquido   COLUMN-LABEL "Valor Liquido" FORMAT "->>>,>>>,>>9.99" WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 8.67
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-titulos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-titulos wWindow _FREEFORM
  QUERY br-titulos DISPLAY
      tt-titulos.cod-estabel                         COLUMN-LABEL "Est"           WIDTH 3
    tt-titulos.matriz       FORMAT ">>>>>>>>9"       COLUMN-LABEL "Matriz"        WIDTH 7
    tt-titulos.nome-matriz  FORMAT "x(30)"           COLUMN-LABEL "Nome"          WIDTH 30
    tt-titulos.periodo      FORMAT "x(08)"           COLUMN-LABEL "Per¡odo"       WIDTH 6
    tt-titulos.documento    FORMAT "x(12)"           COLUMN-LABEL "Documento"     WIDTH 9
    tt-titulos.valor-titulo FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Valor Titulo"  WIDTH 13
    tt-titulos.valor-movto  FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Valor Movtos"  WIDTH 13
    tt-titulos.saldo-titulo FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Saldo Titulo"  WIDTH 13
    tt-titulos.diferenca    FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Diferenca"     WIDTH 13
    tt-titulos.forma-pagto  FORMAT "x(20)"           COLUMN-LABEL "Forma Pagto"   WIDTH 13
    tt-titulos.incidencia   FORMAT "x(20)"           COLUMN-LABEL "Incidˆncia"    WIDTH 13
    tt-titulos.pagto        FORMAT "x(20)"           COLUMN-LABEL "Pagamento"     WIDTH 13   
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 8
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     BUTTON-1 AT ROW 24.04 COL 81.43 WIDGET-ID 108
     fi-cod-estabel AT ROW 3.08 COL 32.57 HELP
          "C¢digo do Estabelecimento" WIDGET-ID 76
     fi-matriz AT ROW 3.08 COL 53.57 HELP
          "C¢digo da Matriz" WIDGET-ID 84
     fi-periodo AT ROW 4.13 COL 31.43 HELP
          "Per¡odo AAAAMM" WIDGET-ID 104
     fi-cod-unid-neg AT ROW 4.13 COL 50.71 HELP
          "Unidade de Neg¢cio" WIDGET-ID 106
     tg-diferenca AT ROW 4.17 COL 66 WIDGET-ID 100
     btCarrega AT ROW 3.96 COL 87.57 HELP
          "V  Para" WIDGET-ID 98
     br-titulos AT ROW 5.75 COL 2.72 WIDGET-ID 200
     btTitulo AT ROW 13.83 COL 2.86 HELP
          "Detalha T¡tulo no Contas a Pagar" WIDGET-ID 10
     br-movimentos AT ROW 15.29 COL 2.72 WIDGET-ID 300
     btDetalhar AT ROW 24 COL 2.86 WIDGET-ID 92
     btBaixa AT ROW 24.04 COL 92.57 WIDGET-ID 102
     btEstorno AT ROW 24.04 COL 102.72 WIDGET-ID 94
     btFechar AT ROW 25.71 COL 2
     btHelp2 AT ROW 25.71 COL 103.43
     btQueryJoins AT ROW 1.13 COL 97.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109.57 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 25.5 COL 1
     RECT-12 AT ROW 2.79 COL 2.72 WIDGET-ID 96
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.43 BY 26.13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Acordo Comercial Notas Fiscais X T¡tulos - ESUTP045"
         COLUMN             = 22.72
         ROW                = 3.46
         HEIGHT             = 26.13
         WIDTH              = 113.43
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
         MAX-BUTTON         = no
         RESIZE             = no
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-titulos btCarrega fpage0 */
/* BROWSE-TAB br-movimentos btTitulo fpage0 */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-unid-neg IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-matriz IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-periodo IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-movimentos
/* Query rebuild information for BROWSE br-movimentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos WHERE tt-movimentos.num-id-titulo = tt-titulos.num-id-titulo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-movimentos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-titulos
/* Query rebuild information for BROWSE br-titulos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-titulos NO-LOCK
                           WHERE (IF INPUT FRAME fPage0 tg-diferenca
                                  THEN tt-titulos.diferenca <> 0
                                  ELSE TRUE).
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-titulos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Acordo Comercial Notas Fiscais X T¡tulos - ESUTP045 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Acordo Comercial Notas Fiscais X T¡tulos - ESUTP045 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-titulos
&Scoped-define SELF-NAME br-titulos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulos wWindow
ON VALUE-CHANGED OF br-titulos IN FRAME fpage0
DO:
   {&open-query-br-movimentos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btBaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBaixa wWindow
ON CHOOSE OF btBaixa IN FRAME fpage0 /* Baixa */
DO:
    IF AVAIL tt-titulos THEN DO:
        ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
        RUN esp\utp\esutp045b.w (INPUT tt-titulos.cod-estabel,
                                 INPUT tt-titulos.matriz,
                                 INPUT tt-titulos.num-id-titulo,
                                 INPUT tt-titulos.cod-unid-neg).
        RUN pi-carrega-titulos.
        ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Carrega */
DO:
    RUN pi-carrega-titulos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhar wWindow
ON CHOOSE OF btDetalhar IN FRAME fpage0 /* Detalhar */
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
        RUN esp\utp\esutp045a.w (INPUT tt-movimentos.num-id-titulo,
                                 INPUT tt-movimentos.num-id-movto).
        ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEstorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEstorno wWindow
ON CHOOSE OF btEstorno IN FRAME fpage0 /* Estorno */
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
        RUN esp\utp\esutp045c.w (INPUT tt-movimentos.num-id-titulo,
                                 INPUT tt-movimentos.num-id-movto).
        RUN pi-carrega-titulos.
        ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
DO:
  /*  {include/ajuda.i}*/
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
DO:
    /*RUN showQueryJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
DO:
  /*  RUN showReportsJoins IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTitulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTitulo wWindow
ON CHOOSE OF btTitulo IN FRAME fpage0 /* T¡tulo */
DO:
    ASSIGN v_rec_tit_ap = ?.

    IF AVAIL tt-titulos THEN DO:
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab     = tt-titulos.cod-estabel
               AND tit_ap.num_id_tit_ap = tt-titulos.num-id-titulo NO-ERROR.
        IF AVAIL tit_ap THEN DO:
            ASSIGN v_rec_tit_ap = RECID(tit_ap).

            ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
            RUN prgfin/apb/apb222aa.p.
            ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione algum t¡tulo para detalhes!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWindow
ON CHOOSE OF BUTTON-1 IN FRAME fpage0 /* Enctro Contas */
DO:
  RUN prgfin/apb/apb735aa.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-movimentos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

  APPLY "entry" TO fi-cod-estabel IN FRAME fPage0.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-titulos wWindow 
PROCEDURE pi-carrega-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-valor      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-tot  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-liq  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-pagto       AS CHAR INIT "D + X informado,Por NF,Por Mˆs,Por Bimestre,Por Trimestre,Por Semestre,Por Ano,Data Informada" NO-UNDO.
    DEFINE VARIABLE c-forma-pagto AS CHAR INIT "Boleto,Desconto,Produto" NO-UNDO.
    DEFINE VARIABLE c-incidencia  AS CHAR INIT "Nota Fiscal,Faturamento Per¡odo,Eventos" NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fi-cod-estabel
                              fi-matriz
                              fi-periodo
                              fi-cod-unid-neg.
    
    FOR EACH tt-titulos:
        DELETE tt-titulos.
    END.

    FOR EACH tt-movimentos:
        DELETE tt-movimentos.
    END.

    FOR EACH acordo-fatur NO-LOCK
       WHERE acordo-fatur.tipo-titulo     = 0
         AND acordo-fatur.num-id-titulo  <> 0 /*nao puxar pendencias*/
         AND acordo-fatur.num-id-titulo  <> 1 /*nao puxar devolu‡äes*/
         AND acordo-fatur.periodo BEGINS fi-periodo
         AND (IF fi-cod-estabel <> "" THEN acordo-fatur.cod-estabel = fi-cod-estabel ELSE TRUE)
         AND (IF fi-matriz <> 0 THEN acordo-fatur.matriz = fi-matriz ELSE TRUE)
         AND (IF fi-cod-unid-neg <> "" THEN acordo-fatur.cod-unid-neg = fi-cod-unid-neg ELSE TRUE)
        BREAK BY acordo-fatur.num-id-titulo:

        ASSIGN de-valor = de-valor + acordo-fatur.saldo.

        IF LAST-OF(acordo-fatur.num-id-titulo) THEN DO:

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = acordo-fatur.matriz NO-ERROR.

            FIND FIRST tit_ap NO-LOCK
                 WHERE tit_ap.cod_estab     = acordo-fatur.cod-estabel
                   AND tit_ap.num_id_tit_ap = acordo-fatur.num-id-titulo NO-ERROR.
            CREATE tt-titulos.
            ASSIGN tt-titulos.cod-estabel   = acordo-fatur.cod-estabel
                   tt-titulos.matriz        = acordo-fatur.matriz
                   tt-titulos.nome-matriz   = IF AVAIL emitente 
                                              THEN emitente.nome-emit 
                                              ELSE "nao encontrado"
                   tt-titulos.num-id-titulo = acordo-fatur.num-id-titulo
                   tt-titulos.cod-unid-neg  = acordo-fatur.cod-unid-neg
                   tt-titulos.periodo       = acordo-fatur.periodo
                   tt-titulos.documento     = IF AVAIL tit_ap 
                                              THEN tit_ap.cod_tit_ap
                                              ELSE "nao encontrado"
                   tt-titulos.valor-titulo  = IF AVAIL tit_ap 
                                              THEN tit_ap.val_origin_tit_ap
                                              ELSE 0
                   tt-titulos.saldo-titulo  = IF AVAIL tit_ap 
                                              THEN tit_ap.val_sdo_tit_ap
                                              ELSE 0.

            FIND LAST acordo-contrato NO-LOCK
                 WHERE acordo-contrato.raiz-cnpj      = emitente.cgc
                 AND  (acordo-contrato.cod-estabel    = acordo-fatur.cod-estabel  OR acordo-contrato.cod-estabel  = ?)
                 AND  (acordo-contrato.cod-unid-neg   = acordo-fatur.cod-unid-neg OR acordo-contrato.cod-unid-neg = '1') /*1 ‚  TODAS*/
                 AND   acordo-contrato.fm-cod-com     = ?
                 AND   acordo-contrato.data-vigencia <= tit_ap.dat_emis_docto
                 AND   acordo-contrato.ativo          = YES  NO-ERROR.
            
            IF  AVAIL acordo-contrato THEN DO:
                FIND FIRST acordo-tipo OF acordo-contrato NO-LOCK NO-ERROR.

                IF  AVAIL acordo-tipo THEN DO:
                    ASSIGN tt-titulos.forma-pagto = entry(acordo-tipo.forma-pagto,c-forma-pagto,",")
                           tt-titulos.incidencia  = entry(acordo-tipo.id-incidencia,c-incidencia,",")
                           tt-titulos.pagto       = entry(acordo-tipo.id-pagto,c-pagto,",").
                END.
            END.

            ASSIGN de-valor     = 0
                   de-valor-tot = 0 
                   de-valor-liq = 0.

            FOR EACH movto-acordo-fatur NO-LOCK
               WHERE movto-acordo-fatur.num-id-titulo = acordo-fatur.num-id-titulo
                BREAK BY movto-acordo-fatur.num-id-movto:

                IF movto-acordo-fatur.usuario-cancel = "" THEN DO:
                    ASSIGN de-valor-liq = de-valor-liq + movto-acordo-fatur.valor.

                    IF movto-acordo-fatur.usuario <> "sistema" THEN DO:
                        IF movto-acordo-fatur.usuario = "adm" THEN DO:
                            ASSIGN de-valor = de-valor + (movto-acordo-fatur.valor * -1).
                        END.
                        ELSE 
                            ASSIGN de-valor = de-valor + movto-acordo-fatur.valor.
                    END.
                        
                END.

                ASSIGN de-valor-tot = de-valor-tot + movto-acordo-fatur.valor.

                IF LAST-OF(movto-acordo-fatur.num-id-movto) THEN DO:
                    CREATE tt-movimentos.
                    BUFFER-COPY movto-acordo-fatur TO tt-movimentos.
                    ASSIGN tt-movimentos.valor          = de-valor-tot
                           tt-movimentos.valor-liquido  = de-valor-liq
                           tt-movimentos.valor-cancelado = (de-valor-tot - de-valor-liq) * -1
                           de-valor-tot = 0
                           de-valor-liq = 0.
                END.
                
            END.
            ASSIGN tt-titulos.valor-movto   = de-valor
                   tt-titulos.diferenca     = tt-titulos.saldo-titulo - (tt-titulos.valor-titulo -  tt-titulos.valor-movto)
                   de-valor = 0.
        END.
    END.

    {&open-query-br-titulos}
    {&open-query-br-movimentos}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

