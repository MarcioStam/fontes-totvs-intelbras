&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
define variable c-lista-valor as character init '':U no-undo.

DEFINE TEMP-TABLE tt-fatComercial
   FIELD num-ped-exec  LIKE fat-comercial.num-ped-exec  
   FIELD nr-pedcli     LIKE fat-comercial.nr-pedcli     
   FIELD nome-abrev    LIKE fat-comercial.nome-abrev    
   FIELD cod-estabel   LIKE fat-comercial.cod-estabel   
   FIELD serie         LIKE fat-comercial.serie         
   FIELD nr-nota-fis   LIKE fat-comercial.nr-nota-fis  
   FIELD dt-execucao   AS DATE FORMAT '99/99/9999'
   FIELD c-status      LIKE fat-comercial.c-status      
   FIELD tp-pedido     AS CHARACTER FORMAT 'X(02)'
   FIELD cod-emitente  LIKE emitente.cod-emitente
   FIELD hr-fatura     LIKE fat-comercial.hr-fatura
   FIELD po-cliente    AS CHAR
   FIELD cod-depos     AS CHAR.

DEFINE VAR c-hora AS CHAR NO-UNDO.
DEFINE VAR c-deposito AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-fatComercial

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-fatComercial.num-ped-exec tt-fatComercial.dt-execucao fnhora(tt-fatComercial.hr-fatura) @ c-hora tt-fatComercial.nr-pedcli tt-fatComercial.tp-pedido tt-fatComercial.cod-emitente tt-fatComercial.nome-abrev tt-fatComercial.cod-estabel tt-fatComercial.serie tt-fatComercial.nr-nota-fis tt-fatComercial.c-status tt-fatComercial.po-cliente tt-fatComercial.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH tt-fatComercial NO-LOCK     WHERE tt-fatComercial.dt-execucao >= INPUT FRAME {&FRAME-NAME} dt-inicial       AND tt-fatComercial.dt-execucao <= INPUT FRAME {&FRAME-NAME} dt-final     ~{&SORTBY-PHRASE}BY tt-fatComercial.num-ped-exec DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH tt-fatComercial NO-LOCK     WHERE tt-fatComercial.dt-execucao >= INPUT FRAME {&FRAME-NAME} dt-inicial       AND tt-fatComercial.dt-execucao <= INPUT FRAME {&FRAME-NAME} dt-final     ~{&SORTBY-PHRASE}BY tt-fatComercial.num-ped-exec DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table tt-fatComercial
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-fatComercial


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-19 IMAGE-20 IMAGE-21 ~
IMAGE-22 IMAGE-29 IMAGE-30 IMAGE-31 IMAGE-32 RECT-1 i-num-ped-exec-ini ~
i-num-ped-exec-fim i-geraNota c-nr-pedcli-ini c-nr-pedcli-fim ~
c-atendente-ini c-atendente-fim i-atendMestre-ini i-atendMestre-fim ~
bt-confirma dt-inicial dt-final br_table 
&Scoped-Define DISPLAYED-OBJECTS i-num-ped-exec-ini i-num-ped-exec-fim ~
i-geraNota c-nr-pedcli-ini c-nr-pedcli-fim c-atendente-ini c-atendente-fim ~
i-atendMestre-ini i-atendMestre-fim dt-inicial dt-final 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnHora B-table-Win 
FUNCTION fnHora RETURNS CHARACTER
  (INPUT i-hora AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-atendente-fim AS CHARACTER FORMAT "X(2)" INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-atendente-ini AS CHARACTER FORMAT "X(2)" 
     LABEL "Atendente":R17 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Pedido Cliente":R17 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE dt-final AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-inicial AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Execu‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-atendMestre-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-atendMestre-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Atendente Mestre":R17 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-ped-exec-fim AS INTEGER FORMAT "->,>>>,>>9" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-ped-exec-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Pedido Execu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-20
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-21
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-22
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-29
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-30
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-31
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-32
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE VARIABLE i-geraNota AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Gerou Nota", 1,
"NÆo Gerou Nota", 2,
"Ambos", 3
     SIZE 14.72 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 3.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-fatComercial SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      tt-fatComercial.num-ped-exec FORMAT ">>>>>>>>9":U
      tt-fatComercial.dt-execucao  FORMAT '99/99/9999'
      fnhora(tt-fatComercial.hr-fatura) @ c-hora    COLUMN-LABEL "Hora Exec"
      tt-fatComercial.nr-pedcli FORMAT "x(12)":U
      tt-fatComercial.tp-pedido COLUMN-LABEL "Atendente"
      tt-fatComercial.cod-emitente COLUMN-LABEL "Cod Cliente"
      tt-fatComercial.nome-abrev FORMAT "x(12)":U
      tt-fatComercial.cod-estabel FORMAT "X(3)":U
      tt-fatComercial.serie FORMAT "X(5)":U
      tt-fatComercial.nr-nota-fis FORMAT "X(16)":U
      tt-fatComercial.c-status FORMAT "x(256)":U
      tt-fatComercial.po-cliente FORMAT "x(20)"
      tt-fatComercial.cod-depos  FORMAT "x(5)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 154.43 BY 16
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-num-ped-exec-ini AT ROW 1.25 COL 56.86 COLON-ALIGNED HELP
          "Pedido Execu‡Æo" WIDGET-ID 44
     i-num-ped-exec-fim AT ROW 1.25 COL 82.29 COLON-ALIGNED HELP
          "Pedido Execu‡Æo" NO-LABEL WIDGET-ID 42
     i-geraNota AT ROW 1.5 COL 126 NO-LABEL WIDGET-ID 28
     c-nr-pedcli-ini AT ROW 2.21 COL 54 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" WIDGET-ID 4
     c-nr-pedcli-fim AT ROW 2.21 COL 82.29 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" NO-LABEL WIDGET-ID 6
     c-atendente-ini AT ROW 3.21 COL 64 COLON-ALIGNED HELP
          "C¢digo do Atendente" WIDGET-ID 14
     c-atendente-fim AT ROW 3.21 COL 82.29 COLON-ALIGNED HELP
          "C¢digo do Atendente" NO-LABEL WIDGET-ID 12
     i-atendMestre-ini AT ROW 4.21 COL 64 COLON-ALIGNED HELP
          "C¢digo do Atendente Mestre" WIDGET-ID 22
     i-atendMestre-fim AT ROW 4.21 COL 82.29 COLON-ALIGNED HELP
          "C¢digo do Atendente Mestre" NO-LABEL WIDGET-ID 20
     bt-confirma AT ROW 4.83 COL 135.72 WIDGET-ID 40
     dt-inicial AT ROW 5.21 COL 56 COLON-ALIGNED HELP
          "Data de Execu‡Æo" WIDGET-ID 34
     dt-final AT ROW 5.21 COL 82.29 COLON-ALIGNED HELP
          "Data de Execu‡Æo" NO-LABEL WIDGET-ID 32
     br_table AT ROW 6.25 COL 1.72
     IMAGE-1 AT ROW 1.25 COL 69.43 WIDGET-ID 46
     IMAGE-2 AT ROW 1.25 COL 80.86 WIDGET-ID 48
     IMAGE-19 AT ROW 2.21 COL 69.43 WIDGET-ID 8
     IMAGE-20 AT ROW 2.21 COL 80.86 WIDGET-ID 10
     IMAGE-21 AT ROW 3.21 COL 69.43 WIDGET-ID 16
     IMAGE-22 AT ROW 3.21 COL 80.86 WIDGET-ID 18
     IMAGE-29 AT ROW 4.21 COL 69.43 WIDGET-ID 24
     IMAGE-30 AT ROW 4.21 COL 80.86 WIDGET-ID 26
     IMAGE-31 AT ROW 5.21 COL 69.43 WIDGET-ID 36
     IMAGE-32 AT ROW 5.21 COL 80.86 WIDGET-ID 38
     RECT-1 AT ROW 1.25 COL 125 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 21.75
         WIDTH              = 155.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table dt-final F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-fatComercial NO-LOCK
    WHERE tt-fatComercial.dt-execucao >= INPUT FRAME {&FRAME-NAME} dt-inicial
      AND tt-fatComercial.dt-execucao <= INPUT FRAME {&FRAME-NAME} dt-final
    ~{&SORTBY-PHRASE}BY tt-fatComercial.num-ped-exec DESCENDING INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma B-table-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:

  DEFINE VARIABLE DataFatCom AS DATE    NO-UNDO.
  DEFINE VARIABLE DataFim    AS CHAR    NO-UNDO.

  IF INPUT FRAME {&FRAME-NAME} dt-final = 12/31/9999 THEN
      ASSIGN DataFim = string('31/12/' + string(YEAR(TODAY),'9999')).
  ELSE DataFim = INPUT FRAME {&FRAME-NAME} dt-final.

  assign input frame {&frame-name} i-num-ped-exec-ini i-num-ped-exec-fim c-nr-pedcli-ini c-nr-pedcli-fim c-atendente-ini c-atendente-fim i-atendMestre-ini i-atendMestre-fim.

  FOR EACH tt-fatComercial.
      DELETE tt-fatComercial.
  END.

  IF INPUT FRAME {&FRAME-NAME} dt-inicial <> 01/01/0001 THEN DO:

      DO DataFatCom = INPUT FRAME {&FRAME-NAME} dt-inicial TO date(DataFim) :

          FOR EACH fat-comercial 
              WHERE fat-comercial.dt-fatura = DataFatCom NO-LOCK
              BY fat-comercial.num-ped-exec
              BY fat-comercial.nr-pedcli   DESCENDING:

              CASE INPUT FRAME {&FRAME-NAME} i-geraNota:
                  WHEN 1 THEN IF fat-comercial.nr-nota-fis  = '' THEN NEXT.
                  WHEN 2 THEN IF fat-comercial.nr-nota-fis <> '' THEN NEXT.
              END CASE.

              IF (fat-comercial.nr-pedcli < INPUT FRAME {&FRAME-NAME} c-nr-pedcli-ini
              OR  fat-comercial.nr-pedcli > INPUT FRAME {&FRAME-NAME} c-nr-pedcli-fim) THEN NEXT.

              IF (fat-comercial.num-ped-exec < INPUT FRAME {&FRAME-NAME} i-num-ped-exec-ini
              OR  fat-comercial.num-ped-exec > INPUT FRAME {&FRAME-NAME} i-num-ped-exec-fim) THEN NEXT.

              FIND FIRST ped-venda
              WHERE ped-venda.nome-abrev  = fat-comercial.nome-abrev
                AND ped-venda.nr-pedcli   = fat-comercial.nr-pedcli  NO-LOCK NO-ERROR.
              IF AVAIL ped-venda THEN DO:

                  IF (ped-venda.tp-pedido  < INPUT FRAME {&FRAME-NAME} c-atendente-ini 
                  OR  ped-venda.tp-pedido  > INPUT FRAME {&FRAME-NAME} c-atendente-fim) THEN NEXT.

                  FIND FIRST atendente WHERE atendente.cd-oper = INTEGER(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
                  IF AVAIL atendente THEN DO:

                      IF (atendente.oper-mestre  < INPUT FRAME {&FRAME-NAME} i-atendMestre-ini 
                      OR  atendente.oper-mestre  > INPUT FRAME {&FRAME-NAME} i-atendMestre-fim) THEN NEXT.

                      FIND FIRST emitente NO-LOCK
                           WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

                      FIND FIRST int-ped-venda
                           WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                        
                      FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = fat-comercial.num-ped-exec NO-LOCK NO-ERROR.

                      RUN pi-busca-deposito(OUTPUT c-deposito).

                      CREATE tt-fatComercial.
                      ASSIGN tt-fatComercial.num-ped-exec  = fat-comercial.num-ped-exec 
                             tt-fatComercial.nr-pedcli     = fat-comercial.nr-pedcli    
                             tt-fatComercial.nome-abrev    = fat-comercial.nome-abrev   
                             tt-fatComercial.cod-estabel   = fat-comercial.cod-estabel  
                             tt-fatComercial.serie         = fat-comercial.serie        
                             tt-fatComercial.nr-nota-fis   = fat-comercial.nr-nota-fis  
                             tt-fatComercial.c-status      = fat-comercial.c-status     
                             tt-fatComercial.dt-execucao   = fat-comercial.dt-fatura
                             tt-fatComercial.tp-pedido     = IF AVAIL ped-venda THEN ped-venda.tp-pedido ELSE ''
                             tt-fatComercial.cod-emitente  = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0
                             tt-fatcomercial.hr-fatura     = fat-comercial.hr-fatura
                             tt-fatcomercial.po-cliente    = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1, 53,12) ELSE ""
                             tt-fatcomercial.cod-depos     = c-deposito.

                  END. /* IF AVAIL atendente THEN DO: */

              END. /* IF AVAIL ped-venda THEN DO: */

          END. /* FOR EACH fat-comercial */

      END. /* DO DataFatCom */

  END. /* IF INPUT FRAME {&FRAME-NAME} dt-inicial <> ? THEN DO: */

  ELSE DO:
      FOR EACH fat-comercial 
          WHERE fat-comercial.num-ped-exec >= INPUT FRAME {&FRAME-NAME} i-num-ped-exec-ini
            AND fat-comercial.num-ped-exec <= INPUT FRAME {&FRAME-NAME} i-num-ped-exec-fim
            AND fat-comercial.nr-pedcli    >= INPUT FRAME {&FRAME-NAME} c-nr-pedcli-ini
            AND fat-comercial.nr-pedcli    <= INPUT FRAME {&FRAME-NAME} c-nr-pedcli-fim NO-LOCK
          BY fat-comercial.num-ped-exec
          BY fat-comercial.nr-pedcli   DESCENDING:

          IF (fat-comercial.dt-fatura < INPUT FRAME {&FRAME-NAME} dt-inicial 
          OR  fat-comercial.dt-fatura > INPUT FRAME {&FRAME-NAME} dt-final  )  THEN NEXT.

          CASE INPUT FRAME {&FRAME-NAME} i-geraNota:
              WHEN 1 THEN IF fat-comercial.nr-nota-fis  = '' THEN NEXT.
              WHEN 2 THEN IF fat-comercial.nr-nota-fis <> '' THEN NEXT.
          END CASE.

          FIND FIRST ped-venda
          WHERE ped-venda.nome-abrev  = fat-comercial.nome-abrev
            AND ped-venda.nr-pedcli   = fat-comercial.nr-pedcli  NO-LOCK NO-ERROR.
          IF AVAIL ped-venda THEN DO:

              IF (ped-venda.tp-pedido  < INPUT FRAME {&FRAME-NAME} c-atendente-ini 
              OR  ped-venda.tp-pedido  > INPUT FRAME {&FRAME-NAME} c-atendente-fim) THEN NEXT.

              FIND FIRST atendente WHERE atendente.cd-oper = INTEGER(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
              IF AVAIL atendente THEN DO:

                  IF (atendente.oper-mestre  < INPUT FRAME {&FRAME-NAME} i-atendMestre-ini 
                  OR  atendente.oper-mestre  > INPUT FRAME {&FRAME-NAME} i-atendMestre-fim) THEN NEXT.

                  FIND FIRST emitente NO-LOCK
                       WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

                  FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = fat-comercial.num-ped-exec NO-LOCK NO-ERROR.

                  RUN pi-busca-deposito(OUTPUT c-deposito).
                  
                  CREATE tt-fatComercial.
                  ASSIGN tt-fatComercial.num-ped-exec  = fat-comercial.num-ped-exec 
                         tt-fatComercial.nr-pedcli     = fat-comercial.nr-pedcli    
                         tt-fatComercial.nome-abrev    = fat-comercial.nome-abrev   
                         tt-fatComercial.cod-estabel   = fat-comercial.cod-estabel  
                         tt-fatComercial.serie         = fat-comercial.serie        
                         tt-fatComercial.nr-nota-fis   = fat-comercial.nr-nota-fis  
                         tt-fatComercial.c-status      = fat-comercial.c-status     
                         tt-fatComercial.dt-execucao   = fat-comercial.dt-fatura
                         tt-fatComercial.tp-pedido     = IF AVAIL ped-venda THEN ped-venda.tp-pedido ELSE ''
                         tt-fatComercial.cod-emitente  = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0
                         tt-fatcomercial.hr-fatura     = fat-comercial.hr-fatura
                         tt-fatcomercial.cod-depos     = c-deposito.

              END. /* IF AVAIL atendente THEN DO: */

          END.

      END.
  END.


  {&OPEN-QUERY-br_table}

/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U). */
/*   apply 'value-changed':U to {&browse-name}.       */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-deposito B-table-Win 
PROCEDURE pi-busca-deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM p-deposito AS CHAR NO-UNDO.

FIND FIRST nota-fiscal
     WHERE nota-fiscal.cod-estabel   = fat-comercial.cod-estabel
       AND nota-fiscal.serie         = fat-comercial.serie      
       AND nota-fiscal.nr-nota-fis   = fat-comercial.nr-nota-fis NO-LOCK NO-ERROR.

 IF AVAIL nota-fiscal THEN
     
    FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK,

        FIRST fat-ser-lote OF it-nota-fisc NO-LOCK:

    ASSIGN p-deposito = fat-ser-lote.cod-depos.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-fatComercial"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnHora B-table-Win 
FUNCTION fnHora RETURNS CHARACTER
  (INPUT i-hora AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN c-hora = STRING(i-hora,"HH:MM:SS").
  
  RETURN c-hora.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

