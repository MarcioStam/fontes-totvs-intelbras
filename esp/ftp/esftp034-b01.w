&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{utp/ut-glob.i}

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-lib-item-fat LIKE lib-item-fat
    FIELD l-liberado      AS LOGICAL 
    FIELD nome-usuario    AS CHARACTER FORMAT 'X(25)'
    FIELD nome-usuario-l  AS CHARACTER FORMAT 'X(25)'
    FIELD estab-pendente  LIKE lib-item-fat.cod-estab-vinculado
    FIELD estab-liberados LIKE lib-item-fat.cod-estab-vinculado.

DEFINE BUFFER b-LibItemFat FOR lib-item-fat.

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
&Scoped-define INTERNAL-TABLES tt-lib-item-fat ITEM unid-negoc

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-lib-item-fat.cod-solicitacao tt-lib-item-fat.log-1 tt-lib-item-fat.it-codigo ITEM.class-fiscal ITEM.cod-unid-neg unid-negoc.des-unid-negoc tt-lib-item-fat.cod-estab-pad tt-lib-item-fat.l-liberado tt-lib-item-fat.cod-estab-vinculado tt-lib-item-fat.estab-pendente tt-lib-item-fat.estab-liberados tt-lib-item-fat.cod-estab-trans-orig tt-lib-item-fat.cod-estab-trans-dest tt-lib-item-fat.c-status tt-lib-item-fat.nome-usuario-l tt-lib-item-fat.nome-usuario tt-lib-item-fat.dt-solicitacao tt-lib-item-fat.hr-solicitacao tt-lib-item-fat.dt-liberacao tt-lib-item-fat.hr-liberacao tt-lib-item-fat.char-1   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH tt-lib-item-fat NO-LOCK, ~
           EACH ITEM WHERE ITEM.it-codigo = tt-lib-item-fat.it-codigo NO-LOCK, ~
           FIRST unid-negoc WHERE unid-negoc.cod-unid-neg = ITEM.cod-unid-neg NO-LOCK     ~{&SORTBY-PHRASE}BY tt-lib-item-fat.cod-solicitacao DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH tt-lib-item-fat NO-LOCK, ~
           EACH ITEM WHERE ITEM.it-codigo = tt-lib-item-fat.it-codigo NO-LOCK, ~
           FIRST unid-negoc WHERE unid-negoc.cod-unid-neg = ITEM.cod-unid-neg NO-LOCK     ~{&SORTBY-PHRASE}BY tt-lib-item-fat.cod-solicitacao DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table tt-lib-item-fat ITEM unid-negoc
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-lib-item-fat
&Scoped-define SECOND-TABLE-IN-QUERY-br_table ITEM
&Scoped-define THIRD-TABLE-IN-QUERY-br_table unid-negoc


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-19 IMAGE-20 IMAGE-21 ~
IMAGE-22 IMAGE-31 IMAGE-32 IMAGE-33 IMAGE-34 IMAGE-35 IMAGE-36 IMAGE-37 ~
IMAGE-38 c-cod-solicitacao-ini c-cod-solicitacao-fim i-status bt-confirma ~
c-cod-estabel-ini c-cod-estabel-fim c-it-codigo-ini c-it-codigo-fim ~
c-usuario-lib-ini c-usuario-lib-fim dt-solicitacao-ini dt-solicitacao-fim ~
c-resp-ini c-resp-fim c-class-fiscal-ini c-class-fiscal-fim br_table 
&Scoped-Define DISPLAYED-OBJECTS c-cod-solicitacao-ini ~
c-cod-solicitacao-fim i-status c-cod-estabel-ini c-cod-estabel-fim ~
c-it-codigo-ini c-it-codigo-fim c-usuario-lib-ini c-usuario-lib-fim ~
dt-solicitacao-ini dt-solicitacao-fim c-resp-ini c-resp-fim ~
c-class-fiscal-ini c-class-fiscal-fim 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-class-fiscal-fim AS CHARACTER FORMAT "9999.99.99" INITIAL "999999999" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-fiscal-ini AS CHARACTER FORMAT "9999.99.99" INITIAL "00000000" 
     LABEL "Classifica‡Æo Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-solicitacao-fim AS INTEGER FORMAT ">>>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-solicitacao-ini AS INTEGER FORMAT ">>>>>>>>>9" INITIAL 1 
     LABEL "Solicitacao" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-resp-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-resp-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Responsavel" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-lib-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-lib-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Usuario Lib" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE dt-solicitacao-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE dt-solicitacao-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-31
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-32
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-33
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-34
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-35
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-36
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-37
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-38
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE VARIABLE i-status AS INTEGER INITIAL 8 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solicitacao Gerada", 1,
"Aguardando Liberacao", 2,
"Pendente", 3,
"Pendencia Liberada", 4,
"Transf. Aprovada", 5,
"Liberado", 6,
"Cancelado", 7,
"Todos", 8
     SIZE 21 BY 4.75 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-lib-item-fat, 
      ITEM, 
      unid-negoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      tt-lib-item-fat.cod-solicitacao
tt-lib-item-fat.log-1                   FORMAT 'F/T'
tt-lib-item-fat.it-codigo      
ITEM.class-fiscal                       FORMAT '9999.99.99 '
ITEM.cod-unid-neg                       COLUMN-LABEL 'Unid Neg.'
unid-negoc.des-unid-negoc               WIDTH 15 COLUMN-LABEL 'Desc Unid.Neg.'
tt-lib-item-fat.cod-estab-pad           COLUMN-LABEL 'Pad' WIDTH 04 
tt-lib-item-fat.l-liberado              FORMAT 'S/N' COLUMN-LABEL 'Lib?'
tt-lib-item-fat.cod-estab-vinculado     WIDTH 30
tt-lib-item-fat.estab-pendente          WIDTH 30 COLUMN-LABEL 'Estab Pend'
tt-lib-item-fat.estab-liberados         WIDTH 30 COLUMN-LABEL 'Estab Libs'
tt-lib-item-fat.cod-estab-trans-orig    COLUMN-LABEL 'Estab Orig' WIDTH 04 
tt-lib-item-fat.cod-estab-trans-dest    COLUMN-LABEL 'Estab Dest' WIDTH 04 
tt-lib-item-fat.c-status                COLUMN-LABEL 'STATUS' WIDTH 20
tt-lib-item-fat.nome-usuario-l          COLUMN-LABEL 'Respons vel'
tt-lib-item-fat.nome-usuario            COLUMN-LABEL 'Solicitante'
tt-lib-item-fat.dt-solicitacao 
tt-lib-item-fat.hr-solicitacao
tt-lib-item-fat.dt-liberacao   
tt-lib-item-fat.hr-liberacao
tt-lib-item-fat.char-1                  COLUMN-LABEL 'Historico' WIDTH 50
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 154.43 BY 14
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-cod-solicitacao-ini AT ROW 1.08 COL 59.14 COLON-ALIGNED HELP
          "Codigo da Solicitacao" WIDGET-ID 44
     c-cod-solicitacao-fim AT ROW 1.08 COL 84.57 COLON-ALIGNED HELP
          "Codigo da Solicitacao" NO-LABEL WIDGET-ID 42
     i-status AT ROW 1.25 COL 108 NO-LABEL WIDGET-ID 28
     bt-confirma AT ROW 1.25 COL 150 WIDGET-ID 40
     c-cod-estabel-ini AT ROW 2.04 COL 65.29 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 4
     c-cod-estabel-fim AT ROW 2.04 COL 84.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL WIDGET-ID 6
     c-it-codigo-ini AT ROW 3.04 COL 52.29 COLON-ALIGNED HELP
          "Item da Solicitacao" WIDGET-ID 14
     c-it-codigo-fim AT ROW 3.04 COL 84.57 COLON-ALIGNED HELP
          "Item da Solicitacao" NO-LABEL WIDGET-ID 12
     c-usuario-lib-ini AT ROW 4.04 COL 52.29 COLON-ALIGNED HELP
          "Item da Solicitacao" WIDGET-ID 52
     c-usuario-lib-fim AT ROW 4.04 COL 84.57 COLON-ALIGNED HELP
          "Item da Solicitacao" NO-LABEL WIDGET-ID 50
     dt-solicitacao-ini AT ROW 5.04 COL 58.29 COLON-ALIGNED HELP
          "Data da Solicitacao" WIDGET-ID 34
     dt-solicitacao-fim AT ROW 5.04 COL 84.57 COLON-ALIGNED HELP
          "Data da Solicitacao" NO-LABEL WIDGET-ID 32
     c-resp-ini AT ROW 6.04 COL 52.29 COLON-ALIGNED HELP
          "Item da Solicitacao" WIDGET-ID 60
     c-resp-fim AT ROW 6.04 COL 84.57 COLON-ALIGNED HELP
          "Item da Solicitacao" NO-LABEL WIDGET-ID 58
     c-class-fiscal-ini AT ROW 7.04 COL 58.29 COLON-ALIGNED WIDGET-ID 68
     c-class-fiscal-fim AT ROW 7.04 COL 84.57 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     br_table AT ROW 8.25 COL 1.72
     IMAGE-1 AT ROW 1.08 COL 71.72 WIDGET-ID 46
     IMAGE-2 AT ROW 1.08 COL 83.14 WIDGET-ID 48
     IMAGE-19 AT ROW 2.04 COL 71.72 WIDGET-ID 8
     IMAGE-20 AT ROW 2.04 COL 83.14 WIDGET-ID 10
     IMAGE-21 AT ROW 3.04 COL 71.72 WIDGET-ID 16
     IMAGE-22 AT ROW 3.04 COL 83.14 WIDGET-ID 18
     IMAGE-31 AT ROW 5.04 COL 71.72 WIDGET-ID 36
     IMAGE-32 AT ROW 5.04 COL 83.14 WIDGET-ID 38
     IMAGE-33 AT ROW 4.04 COL 71.72 WIDGET-ID 54
     IMAGE-34 AT ROW 4.04 COL 83.14 WIDGET-ID 56
     IMAGE-35 AT ROW 6.04 COL 71.72 WIDGET-ID 62
     IMAGE-36 AT ROW 6.04 COL 83.14 WIDGET-ID 64
     IMAGE-37 AT ROW 7.04 COL 71.72 WIDGET-ID 70
     IMAGE-38 AT ROW 7.04 COL 83.14 WIDGET-ID 72
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
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 21.33
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
/* BROWSE-TAB br_table c-class-fiscal-fim F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-lib-item-fat NO-LOCK,
    EACH ITEM WHERE ITEM.it-codigo = tt-lib-item-fat.it-codigo NO-LOCK,
    FIRST unid-negoc WHERE unid-negoc.cod-unid-neg = ITEM.cod-unid-neg NO-LOCK
    ~{&SORTBY-PHRASE}BY tt-lib-item-fat.cod-solicitacao DESCENDING INDEXED-REPOSITION.
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  
    IF AVAIL tt-lib-item-fat  THEN DO:

        CASE tt-lib-item-fat.c-status:

            WHEN 'Solicitacao Gerada' THEN DO:
                ASSIGN 
                       tt-lib-item-fat.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-lib-item-fat.log-1               :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-lib-item-fat.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 9
                       ITEM.class-fiscal                   :FGCOLOR IN BROWSE BR_TABLE = 9
                       ITEM.cod-unid-neg                   :FGCOLOR IN BROWSE BR_TABLE = 9
                       unid-negoc.des-unid-negoc           :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-lib-item-fat.cod-estab-pad       :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-lib-item-fat.nome-usuario        :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.dt-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.hr-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.l-liberado          :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.cod-estab-vinculado :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.estab-liberados     :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.c-status            :FGCOLOR IN BROWSE BR_TABLE = 9 
                       
                       tt-lib-item-fat.nome-usuario-l      :FGCOLOR IN BROWSE BR_TABLE = 9 
                       
                       tt-lib-item-fat.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-lib-item-fat.hr-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 9 
                       
                    .
            END.
            WHEN 'Pendente' THEN DO:
                ASSIGN 
                       tt-lib-item-fat.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 06
                       tt-lib-item-fat.log-1               :FGCOLOR IN BROWSE BR_TABLE = 06
                       tt-lib-item-fat.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 06
                       ITEM.class-fiscal                   :FGCOLOR IN BROWSE BR_TABLE = 06
                       ITEM.cod-unid-neg                   :FGCOLOR IN BROWSE BR_TABLE = 06
                       unid-negoc.des-unid-negoc           :FGCOLOR IN BROWSE BR_TABLE = 06
                       tt-lib-item-fat.cod-estab-pad       :FGCOLOR IN BROWSE BR_TABLE = 06
                       tt-lib-item-fat.nome-usuario        :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.dt-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.hr-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.l-liberado          :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.cod-estab-vinculado :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.estab-liberados     :FGCOLOR IN BROWSE BR_TABLE = 06
                       tt-lib-item-fat.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.c-status            :FGCOLOR IN BROWSE BR_TABLE = 06 
                       
                       tt-lib-item-fat.nome-usuario-l      :FGCOLOR IN BROWSE BR_TABLE = 06 
                       
                       tt-lib-item-fat.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 06 
                       tt-lib-item-fat.hr-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 06 
                       
                       .
            END.
            WHEN 'Pendencia Liberada' THEN DO:
                ASSIGN 
                       tt-lib-item-fat.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 02
                       tt-lib-item-fat.log-1               :FGCOLOR IN BROWSE BR_TABLE = 02
                       tt-lib-item-fat.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 02
                       ITEM.class-fiscal                   :FGCOLOR IN BROWSE BR_TABLE = 02
                       ITEM.cod-unid-neg                   :FGCOLOR IN BROWSE BR_TABLE = 02
                       unid-negoc.des-unid-negoc           :FGCOLOR IN BROWSE BR_TABLE = 02
                       tt-lib-item-fat.cod-estab-pad       :FGCOLOR IN BROWSE BR_TABLE = 02
                       tt-lib-item-fat.nome-usuario        :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.dt-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.hr-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.l-liberado          :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.cod-estab-vinculado :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.estab-liberados     :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.estab-pendente      :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.c-status            :FGCOLOR IN BROWSE BR_TABLE = 02 
                       
                       tt-lib-item-fat.nome-usuario-l      :FGCOLOR IN BROWSE BR_TABLE = 02 
                       
                       tt-lib-item-fat.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 02 
                       tt-lib-item-fat.hr-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 02 
                       
                       .
            END.
            WHEN 'Liberado' OR WHEN 'Transf. Aprovada' THEN DO: 
                ASSIGN 
                       tt-lib-item-fat.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-lib-item-fat.log-1               :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-lib-item-fat.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 2
                       ITEM.class-fiscal                   :FGCOLOR IN BROWSE BR_TABLE = 2
                       ITEM.cod-unid-neg                   :FGCOLOR IN BROWSE BR_TABLE = 2
                       unid-negoc.des-unid-negoc           :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-lib-item-fat.cod-estab-pad       :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-lib-item-fat.nome-usuario        :FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.dt-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.hr-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.l-liberado          :FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.cod-estab-vinculado :FGCOLOR IN BROWSE BR_TABLE = 2  
                       tt-lib-item-fat.estab-liberados     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-lib-item-fat.estab-pendente      :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.c-status            :FGCOLOR IN BROWSE BR_TABLE = 2 
                       
                       tt-lib-item-fat.nome-usuario-l      :FGCOLOR IN BROWSE BR_TABLE = 2 
                       
                       tt-lib-item-fat.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-lib-item-fat.hr-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 2 
                       
                       .
            END.
            WHEN 'Cancelado' THEN DO: 
                ASSIGN 
                       tt-lib-item-fat.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-lib-item-fat.log-1               :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-lib-item-fat.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 12
                       ITEM.class-fiscal                   :FGCOLOR IN BROWSE BR_TABLE = 12
                       ITEM.cod-unid-neg                   :FGCOLOR IN BROWSE BR_TABLE = 12
                       unid-negoc.des-unid-negoc           :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-lib-item-fat.cod-estab-pad       :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-lib-item-fat.nome-usuario        :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.dt-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.hr-solicitacao      :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.l-liberado          :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.cod-estab-vinculado :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.estab-liberados     :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.c-status            :FGCOLOR IN BROWSE BR_TABLE = 12 
                       
                       tt-lib-item-fat.nome-usuario-l      :FGCOLOR IN BROWSE BR_TABLE = 12 
                       
                       tt-lib-item-fat.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-lib-item-fat.hr-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 12 
                       
                       . 
            END.

        END CASE.

    END.

    IF  tt-lib-item-fat.c-status = 'Aguardando Liberacao' THEN DO:

        FIND FIRST param-lib-item-fat NO-LOCK NO-ERROR.

        IF tt-lib-item-fat.nome-usuario MATCHES '*astec*' THEN DO:
/*             MESSAGE 'ASTEC ' tt-lib-item-fat.cod-solicitacao '  '  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-simples)           */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                       */
/*             MESSAGE 'ASTEC Completo ' tt-lib-item-fat.cod-solicitacao '  '  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-completo) */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                       */
            IF tt-lib-item-fat.l-liberado = YES THEN DO:
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-simples) <= TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 12.
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-simples) - 1  = TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 14.
            END.
            ELSE DO:
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-completo) <= TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 12.
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-critico-completo) - 1 = TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 14.
            END.
        END.
        ELSE DO:
/*             MESSAGE 'NORMAL ' tt-lib-item-fat.cod-solicitacao '  '  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-simples)           */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                */
/*             MESSAGE 'NORMAL Completo ' tt-lib-item-fat.cod-solicitacao '  '  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-completo) */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                */
            IF tt-lib-item-fat.l-liberado = YES THEN DO:
                IF  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-simples) <= TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 12.
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-simples) - 1   = TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 14.
            END.
            ELSE DO:
                IF  (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-completo) <= TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 12.
                IF (tt-lib-item-fat.dt-liberacao + param-lib-item-fat.prazo-completo) - 1  = TODAY THEN
                    ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 14.
            END.
        END.
            
    /*         param-lib-item-fat.prazo-simples          */
    /*         param-lib-item-fat.prazo-completo         */
    /*         param-lib-item-fat.prazo-critico-simples  */
    /*         param-lib-item-fat.prazo-critico-completo */

    END. /* IF  tt-lib-item-fat.c-status <> 'Cancelado' AND tt-lib-item-fat.c-status <> 'Liberado'  THEN DO: */

    IF tt-lib-item-fat.c-status = 'Pendente' THEN DO:
        IF  (tt-lib-item-fat.dt-liberacao + 3) <= TODAY THEN
            ASSIGN tt-lib-item-fat.nome-usuario-l      :BGCOLOR IN BROWSE br_table = 9.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

  assign input frame {&frame-name}  c-cod-solicitacao-ini   c-cod-solicitacao-fim   
                                    c-cod-estabel-ini       c-cod-estabel-fim       
                                    c-it-codigo-ini         c-it-codigo-fim 
                                    dt-solicitacao-ini      dt-solicitacao-fim      i-status. 

  FOR EACH tt-lib-item-fat.
      DELETE tt-lib-item-fat.
  END.

  FOR EACH lib-item-fat 
      WHERE lib-item-fat.it-codigo     >= INPUT FRAME {&FRAME-NAME} c-it-codigo-ini         
        AND lib-item-fat.it-codigo     <= INPUT FRAME {&FRAME-NAME} c-it-codigo-fim
        AND lib-item-fat.cod-estab-pad >= INPUT FRAME {&FRAME-NAME} c-cod-estabel-ini
        AND lib-item-fat.cod-estab-pad <= INPUT FRAME {&FRAME-NAME} c-cod-estabel-fim NO-LOCK:

 

      IF (lib-item-fat.cod-solicitacao < INPUT FRAME {&FRAME-NAME} c-cod-solicitacao-ini   
      OR  lib-item-fat.cod-solicitacao > INPUT FRAME {&FRAME-NAME} c-cod-solicitacao-fim) THEN NEXT.
      
      

      IF (lib-item-fat.usuario < INPUT FRAME {&FRAME-NAME} c-usuario-lib-ini   
      OR  lib-item-fat.usuario > INPUT FRAME {&FRAME-NAME} c-usuario-lib-fim) THEN NEXT.

      
      IF (lib-item-fat.usuario-lib < INPUT FRAME {&FRAME-NAME} c-resp-ini   
      OR  lib-item-fat.usuario-lib > INPUT FRAME {&FRAME-NAME} c-resp-fim) THEN NEXT.
      

      

      IF (lib-item-fat.dt-solicitacao < INPUT FRAME {&FRAME-NAME} dt-solicitacao-ini   
      OR  lib-item-fat.dt-solicitacao > INPUT FRAME {&FRAME-NAME} dt-solicitacao-fim) THEN NEXT.

      

      FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo NO-LOCK NO-ERROR.
      IF replace(INPUT FRAME {&FRAME-NAME} c-class-fiscal-ini,'.','') = "00000000" AND replace(INPUT FRAME {&FRAME-NAME} c-class-fiscal-fim,'.','') = "99999999" THEN .
      ELSE
          IF AVAIL ITEM THEN DO:
              
              IF (ITEM.class-fiscal < replace(INPUT FRAME {&FRAME-NAME} c-class-fiscal-ini,'.','')
              OR  ITEM.class-fiscal > replace(INPUT FRAME {&FRAME-NAME} c-class-fiscal-fim,'.','')) THEN NEXT.
          END. /* IF AVAIL ITEM THEN DO: */
      


      CASE INPUT FRAME {&FRAME-NAME} i-status:
          WHEN 1 THEN IF lib-item-fat.c-status  <> "Solicitacao Gerada"     THEN NEXT.
          WHEN 2 THEN IF lib-item-fat.c-status  <> "Aguardando Liberacao"   THEN NEXT.
          WHEN 3 THEN IF lib-item-fat.c-status  <> "Pendente"               THEN NEXT.
          WHEN 4 THEN IF lib-item-fat.c-status  <> "Pendencia Liberada"     THEN NEXT.
          WHEN 5 THEN IF lib-item-fat.c-status  <> "Transf. Aprovada"       THEN NEXT.
          WHEN 6 THEN IF lib-item-fat.c-status  <> "Liberado"               THEN NEXT.
          WHEN 7 THEN IF lib-item-fat.c-status  <> "Cancelado"              THEN NEXT.
      END CASE.

      

      CREATE tt-lib-item-fat.     
      BUFFER-COPY lib-item-fat TO tt-lib-item-fat.

      IF CAN-FIND(FIRST item-uni-estab
              WHERE item-uni-estab.it-codigo    = lib-item-fat.it-codigo
                AND item-uni-estab.ind-item-fat = YES) THEN
          ASSIGN tt-lib-item-fat.l-liberado = YES.
      ELSE
          ASSIGN tt-lib-item-fat.l-liberado = NO.

      FOR EACH item-uni-estab
          WHERE item-uni-estab.it-codigo    = lib-item-fat.it-codigo 
            AND item-uni-estab.ind-item-fat = YES NO-LOCK:
          IF tt-lib-item-fat.estab-liberados = '' THEN
              ASSIGN tt-lib-item-fat.estab-liberados = item-uni-estab.cod-estabel.
          ELSE
              ASSIGN tt-lib-item-fat.estab-liberados = tt-lib-item-fat.estab-liberados + ',' + item-uni-estab.cod-estabel.
      END. /* FOR EACH item-uni-estab */

      

      IF lib-item-fat.c-status = "Liberado" THEN DO:
          FOR EACH item-uni-estab
              WHERE item-uni-estab.it-codigo   = lib-item-fat.it-codigo NO-LOCK:
              IF lib-item-fat.cod-estab-vinculado MATCHES "*" + item-uni-estab.cod-estabel + "*" THEN DO:

                  IF item-uni-estab.ind-item-fat  = YES THEN NEXT.

                  IF tt-lib-item-fat.estab-pendente = '' THEN
                      ASSIGN tt-lib-item-fat.estab-pendente = item-uni-estab.cod-estabel.
                  ELSE
                      ASSIGN tt-lib-item-fat.estab-pendente = tt-lib-item-fat.estab-pendente + ',' + item-uni-estab.cod-estabel.
              END. /* IF lib-item-fat.cod-estabel MATCHES "*" + item-uni-estab.cod-estabel + "*" THEN DO: */
          END. /* FOR EACH item-uni-estab */
      END. /* IF lib-item-fat.c-status = "Liberado" THEN DO: */

      FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
      IF AVAIL usuar_mestre THEN DO:
          ASSIGN tt-lib-item-fat.nome-usuario = usuar_mestre.nom_usuario.
          FIND FIRST usu-lib-item-fat WHERE usu-lib-item-fat.cod-usuario = usuar_mestre.cod_usuario NO-LOCK NO-ERROR.
          IF AVAIL usu-lib-item-fat THEN DO:
              IF usu-lib-item-fat.astec THEN
                  ASSIGN tt-lib-item-fat.nome-usuario = "ASTEC " + usuar_mestre.nom_usuario.
          END. /* IF AVAIL usu-lib-item-fat THEN DO: */
      END. /* IF AVAIL usuar_mestre THEN DO: */

      FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lib-item-fat.usuario-lib NO-LOCK NO-ERROR.
      IF AVAIL usuar_mestre THEN 
          ASSIGN tt-lib-item-fat.nome-usuario-l = usuar_mestre.nom_usuario.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available B-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "tt-lib-item-fat"}
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "unid-negoc"}

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

