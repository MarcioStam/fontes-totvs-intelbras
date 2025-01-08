&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgmov           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i b01es539 2.00.00.000}  /*** 010000 ***/

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
&Scop adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-lista-valor    as char init '':U        no-undo.
def var c-sit-item       as char format "x(20)"   no-undo.
def var c-lista-sit-item as char                  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cep

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table cep.cep cep.uf cep.tipo-log cep.nome-log cep.localidade cep.nr-lote-ini cep.nr-lote-fin cep.bairro-ini cep.bairro-fin cep.nome-gran-usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table IF fi-cep <> 0 THEN     OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                      cep.cep = fi-cep NO-LOCK. ELSE     IF  cb-uf     = ""       AND        (cb-tipo   = "Outros" OR         cb-tipo   = "")      AND         fi-lote   = ""       AND         fi-local  = ""       AND         fi-log    = ""       THEN          OPEN QUERY {&SELF-NAME} FOR EACH cep NO-LOCK INDEXED-REPOSITION.      ELSE DO:          /* Informou somente UF e Localidade */         IF cb-uf <> "" AND (cb-tipo = "Outros" OR cb-tipo = "") AND fi-lote = "" AND fi-log = "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.uf         = cb-uf    AND                                              cep.localidade BEGINS fi-local NO-LOCK.         ELSE         /* Informou somente Logradouro */         IF fi-log <> "" AND (cb-tipo = "Outros" OR cb-tipo = "") AND fi-lote = "" AND fi-local = "" AND cb-uf = "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.nome-log BEGINS fi-log NO-LOCK.         ELSE         /* Informou UF, ~
       Localidade e Lote e/ou Logradouro */         IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf <> "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.uf          = cb-uf                      AND                                              cep.localidade  BEGINS fi-local              AND                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" AND                                              cep.nome-log    MATCHES "*" + fi-log   + "*" NO-LOCK.         ELSE         /* Informou Tipo, ~
       UF, ~
       Localidade e/ou Lote e/ou Logradouro */         IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf <> "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.uf          = cb-uf                      AND                                              cep.tipo-log    = cb-tipo                    AND                                              cep.localidade  BEGINS fi-local              AND                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" AND                                              cep.nome-log    MATCHES "*" + fi-log   + "*" NO-LOCK.         ELSE         /* Informou Tipo, ~
       Logradouro e/ou Lote */         IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf = "" AND fi-log <> "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.tipo-log    = cb-tipo                    AND                                              cep.nome-log    BEGINS fi-log                AND                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.         ELSE         /* Informou Tipo e/ou Lote */         IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf = "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.tipo-log    = cb-tipo                    AND                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.         ELSE         /* Informou Logradouro e/ou Lote */         IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf = "" AND fi-log <> "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.nome-log    BEGINS fi-log  AND                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.         ELSE         /* Informou Lote */         IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf = "" THEN             OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE                                              cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.     END.
&Scoped-define TABLES-IN-QUERY-br-table cep
&Scoped-define FIRST-TABLE-IN-QUERY-br-table cep


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cep cb-uf cb-tipo fi-log fi-lote fi-local ~
bt-confirma br-table RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS fi-cep cb-uf cb-tipo fi-log fi-lote ~
fi-local 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Outros","Aeroporto","Alameda","µrea","Avenida","Campo","Ch cara","Col“nia","Condom¡nio","Conjunto","Distrito","Esplanada","Esta‡Æo","Estrada","Favela","Fazenda","Feira","Jardim","Ladeira","Lago","Lagoa","Largo","Loteamento","Morro","N£cleo","Parque","Passarela","P tio","Pra‡a","Quadra","Recanto","Residencial","Rodovia","Rua","Setor","S¡tio","Travessa","Trecho","Trevo","Vale","Vereda","Via","Viaduto","Viela","Vila" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-uf AS CHARACTER FORMAT "X(256)":U 
     LABEL "UF" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "","AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-cep AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "CEP" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(256)":U 
     LABEL "Localidade" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-log AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logradouro" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote AS CHARACTER FORMAT "X(11)":U 
     LABEL "Nr Lote" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      cep SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table DISPLAY
      cep.cep WIDTH 10
cep.uf
cep.tipo-log    COLUMN-LABEL "Tipo Log" WIDTH 10
cep.nome-log    COLUMN-LABEL "Nome Logradouro" WIDTH 19
cep.localidade  COLUMN-LABEL "Localidade"      WIDTH 19
cep.nr-lote-ini COLUMN-LABEL "Lote Ini"        WIDTH 8
cep.nr-lote-fin COLUMN-LABEL "Lote Fin"        WIDTH 8
cep.bairro-ini  COLUMN-LABEL "Bairro Ini"      WIDTH 20
cep.bairro-fin  COLUMN-LABEL "Bairro Fin"      WIDTH 20
cep.nome-gran-usuar COLUMN-LABEL "Grande Usuar" WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83.57 BY 6.96 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cep AT ROW 1.21 COL 10 COLON-ALIGNED HELP
          "CEP" WIDGET-ID 2
     cb-uf AT ROW 2.5 COL 10 COLON-ALIGNED
     cb-tipo AT ROW 3.5 COL 10 COLON-ALIGNED
     fi-log AT ROW 2.5 COL 41 COLON-ALIGNED HELP
          "Informe o nome da avenida, rua, pra‡a, travessa, alameda, etc."
     fi-lote AT ROW 3.5 COL 41 COLON-ALIGNED HELP
          "N§/Lote/Apto/Casa"
     fi-local AT ROW 4.5 COL 41 COLON-ALIGNED HELP
          "Informe o nome da cidade, munic¡pio,  distrito ou povoado."
     bt-confirma AT ROW 1 COL 80.43
     br-table AT ROW 5.79 COL 1.57 WIDGET-ID 100
     RECT-1 AT ROW 1.04 COL 1 WIDGET-ID 4
     RECT-2 AT ROW 2.29 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgcad emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ped-item T "?" NO-UNDO mgmov ped-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
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
         HEIGHT             = 11.96
         WIDTH              = 84.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-brwzoo.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br-table bt-confirma F-Main */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:HEIGHT           = 11.96
       FRAME F-Main:WIDTH            = 84.72.

ASSIGN 
       br-table:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE
       br-table:COLUMN-MOVABLE IN FRAME F-Main         = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
IF fi-cep <> 0 THEN
    OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                     cep.cep = fi-cep NO-LOCK.
ELSE
    IF  cb-uf     = ""       AND
       (cb-tipo   = "Outros" OR
        cb-tipo   = "")      AND
        fi-lote   = ""       AND
        fi-local  = ""       AND
        fi-log    = ""       THEN

        OPEN QUERY {&SELF-NAME} FOR EACH cep NO-LOCK INDEXED-REPOSITION.

    ELSE DO:

        /* Informou somente UF e Localidade */
        IF cb-uf <> "" AND (cb-tipo = "Outros" OR cb-tipo = "") AND fi-lote = "" AND fi-log = "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.uf         = cb-uf    AND
                                             cep.localidade BEGINS fi-local NO-LOCK.
        ELSE
        /* Informou somente Logradouro */
        IF fi-log <> "" AND (cb-tipo = "Outros" OR cb-tipo = "") AND fi-lote = "" AND fi-local = "" AND cb-uf = "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.nome-log BEGINS fi-log NO-LOCK.
        ELSE
        /* Informou UF, Localidade e Lote e/ou Logradouro */
        IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf <> "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.uf          = cb-uf                      AND
                                             cep.localidade  BEGINS fi-local              AND
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" AND
                                             cep.nome-log    MATCHES "*" + fi-log   + "*" NO-LOCK.
        ELSE
        /* Informou Tipo, UF, Localidade e/ou Lote e/ou Logradouro */
        IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf <> "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.uf          = cb-uf                      AND
                                             cep.tipo-log    = cb-tipo                    AND
                                             cep.localidade  BEGINS fi-local              AND
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" AND
                                             cep.nome-log    MATCHES "*" + fi-log   + "*" NO-LOCK.
        ELSE
        /* Informou Tipo, Logradouro e/ou Lote */
        IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf = "" AND fi-log <> "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.tipo-log    = cb-tipo                    AND
                                             cep.nome-log    BEGINS fi-log                AND
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.
        ELSE
        /* Informou Tipo e/ou Lote */
        IF cb-tipo <> "Outros" AND cb-tipo <> "" AND cb-uf = "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.tipo-log    = cb-tipo                    AND
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.
        ELSE
        /* Informou Logradouro e/ou Lote */
        IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf = "" AND fi-log <> "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.nome-log    BEGINS fi-log  AND
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.
        ELSE
        /* Informou Lote */
        IF (cb-tipo = "Outros" OR cb-tipo = "") AND cb-uf = "" THEN
            OPEN QUERY {&SELF-NAME} FOR EACH cep WHERE
                                             cep.nr-lote-ini MATCHES "*" + fi-lote  + "*" NO-LOCK.
    END.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}

    RUN new-state('New-Line|':U + STRING(ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
    RUN seta-valor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
    {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
   /* This ADM trigger code must be preserved in order to notify other
      objects when the browser's current row changes. */
   {src/adm/template/brschnge.i}
   RUN new-state('New-Line|':U + STRING(ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
   RUN new-state('Value-Changed|':U + STRING(THIS-PROCEDURE)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma B-table-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} fi-cep cb-uf
                                     cb-tipo fi-local 
                                     fi-log fi-lote.

    IF fi-local <> "" AND cb-uf = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 822,
                           INPUT "UF").        
        APPLY "ENTRY" TO cb-uf IN FRAME F-Main.
        RETURN "NOK":U.
    END.

    IF (cb-tipo <> "Outros" AND cb-tipo <> "") AND fi-local = "" AND fi-log = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 265,
                           INPUT "Logradouro").
        APPLY "ENTRY" TO fi-log IN FRAME F-Main.
        RETURN "NOK":U.
    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    APPLY 'value-changed':U TO {&browse-name} IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cep B-table-Win
ON LEAVE OF fi-cep IN FRAME F-Main /* CEP */
DO:
    IF INPUT FRAME F-Main fi-cep <> 0 THEN DO:
        ASSIGN cb-uf    = ""
               cb-tipo  = ""
               fi-local = ""
               fi-log   = ""
               fi-lote  = "".
    
        DISABLE cb-uf cb-tipo fi-local fi-log fi-lote WITH FRAME F-Main.
    END.
    ELSE
        ENABLE cb-uf cb-tipo fi-local fi-log fi-lote WITH FRAME F-Main.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor B-table-Win 
PROCEDURE pi-retorna-valor :
DEFINE INPUT PARAMETER P-CAMPO AS CHARACTER NO-UNDO.

    DEFINE VARIABLE P-VALOR AS CHAR INIT "" NO-UNDO.

    if  avail cep then do:
        case p-campo:
            when "bairro-fin" then
                assign p-valor = string(cep.bairro-fin).
            when "bairro-ini" then
                assign p-valor = string(cep.bairro-ini). 
            when "cep" then
                assign p-valor = string(cep.cep).
            when "localidade" then
                assign p-valor = string(cep.localidade).
            when "nome-complto" then
                assign p-valor = string(cep.nome-complto).
            when "nome-complto2" then
                assign p-valor = string(cep.nome-complto2).
            when "nome-gran-usuar" then
                assign p-valor = string(cep.nome-gran-usuar).
            when "nome-log" then
                assign p-valor = string(cep.nome-log).
            when "nr-complto" then
                assign p-valor = string(cep.nr-complto).
            when "nr-complto2" then
                assign p-valor = string(cep.nr-complto2).
            when "nr-lote-fin" then
                assign p-valor = string(cep.nr-lote-fin).
            when "nr-lote-ini" then
                assign p-valor = string(cep.nr-lote-ini).
            when "preposicao" then
                assign p-valor = string(cep.preposicao).
            when "tipo-log" then
                assign p-valor = string(cep.tipo-log).
            when "tit-pat-log" then
                assign p-valor = string(cep.tit-pat-log).
            when "uf" then
                assign p-valor = string(cep.uf).
            WHEN "end-somatoria" THEN DO:
                ASSIGN p-valor = IF trim(cep.tipo-log)                <> "" THEN trim(cep.tipo-log)      + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.preposicao)    <> "" THEN trim(cep.preposicao)    + " " ELSE "" 
                       p-valor = p-valor + IF trim(cep.tit-pat-log)   <> "" THEN trim(cep.tit-pat-log)   + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nome-log)      <> "" THEN trim(cep.nome-log)      + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nr-lote-ini)   <> "" THEN trim(cep.nr-lote-ini)   + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nome-complto)  <> "" THEN trim(cep.nome-complto)  + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nr-complto)    <> "" THEN trim(cep.nr-complto)    + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nome-complto2) <> "" THEN trim(cep.nome-complto2) + " " ELSE ""
                       p-valor = p-valor + IF trim(cep.nr-complto2)   <> "" THEN trim(cep.nr-complto2)   + " " ELSE "".
            END.
        END CASE.
    end.

    IF p-campo = "end-somatoria":U AND LENGTH(p-valor) > 40 THEN
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 27979,
                           INPUT 'Sugerimos que copie e abrevie o endere‡o informado, pois ultrapassa 40 posi‡äes.' 
                                 + '~~' + 'Endere‡o: ' + p-valor).

    IF AVAIL cep                         AND 
        p-campo = "bairro-ini":U         AND 
        cep.bairro-fin <> "":U           AND 
        cep.bairro-ini <> cep.bairro-fin THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 27979,
                           INPUT 'Informe o bairro correto.'
                                 + '~~' + 'O CEP "' + STRING(cep.cep) + '" est  dentro de dois bairros diferentes "' + TRIM(cep.bairro-ini) + '" e "' + TRIM(cep.bairro-fin) + '".').                
        ASSIGN p-valor = "":U.
    END.

    return p-valor.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "RetornaValorCampo" B-table-Win _INLINE
/* Actions: ? ? ? ? support/brwrtval.p */
/* Procedure desativada */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

