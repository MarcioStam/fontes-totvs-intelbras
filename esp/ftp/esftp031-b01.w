&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-item
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD campo        AS CHARACTER FORMAT  'X(20)'
    FIELD nome-campo   AS CHARACTER FORMAT  'X(50)'
    FIELD valor        AS CHARACTER FORMAT 'X(100)'
    FIELD responsavel  AS CHARACTER FORMAT  'X(25)'
    FIELD cd-origem    LIKE item.cd-origem
    FIELD desc-origem  AS CHARACTER FORMAT  'X(20)'.

DEFINE VARIABLE c-it-codigo LIKE ITEM.it-codigo   NO-UNDO.
DEFINE VARIABLE l-botaoN    AS LOGICAL   INIT NO  NO-UNDO.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES lib-item-fat
&Scoped-define FIRST-EXTERNAL-TABLE lib-item-fat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lib-item-fat.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-item.campo tt-item.nome-campo tt-item.valor tt-item.responsavel   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH tt-item NO-LOCK     WHERE tt-item.it-codigo = c-it-codigo ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH tt-item NO-LOCK     WHERE tt-item.it-codigo = c-it-codigo ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-item


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table bt-valida 

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
fm-codigo||y|mgcad.item.fm-codigo
it-codigo||y|mgcad.item.it-codigo
class-fiscal||y|mgcad.item.class-fiscal
cod-comprado||y|mgcad.item.cod-comprado
cod-estabel||y|mgcad.item.cod-estabel
fm-cod-com||y|mgcad.item.fm-cod-com
ge-codigo||y|mgcad.item.ge-codigo
cd-tag||y|mgcad.item.cd-tag
nr-linha||y|mgcad.item.nr-linha
cd-planejado||y|mgcad.item.cd-planejado
cod-refer||y|mgcad.item.cod-refer
un||y|mgcad.item.un
nat-despesa||y|mgcad.item.nat-despesa
cod-servico||y|mgcad.item.cod-servico
cod-tax||y|mgcad.item.cod-tax
cod-unid-negoc||y|mgcad.item.cod-unid-negoc
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "fm-codigo,it-codigo,class-fiscal,cod-comprado,cod-estabel,fm-cod-com,ge-codigo,cd-tag,nr-linha,cd-planejado,cod-refer,un,nat-despesa,cod-servico,cod-tax,cod-unid-negoc"':U).

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
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-valida 
     LABEL "Valida" 
     SIZE 15 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      tt-item.campo                       COLUMN-LABEL 'Campo'
tt-item.nome-campo  FORMAT 'X(20)'  COLUMN-LABEL 'Descricao'
tt-item.valor       FORMAT 'X(20)'  COLUMN-LABEL 'Valor'
tt-item.responsavel                 COLUMN-LABEL 'Responsavel'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71.43 BY 13.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.13 COL 1.57
     bt-valida AT ROW 14.42 COL 58 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: mgesp.lib-item-fat
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
         HEIGHT             = 14.67
         WIDTH              = 72.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item NO-LOCK
    WHERE tt-item.it-codigo = c-it-codigo ~{&SORTBY-PHRASE}.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "mgcad.item.it-codigo = lib-item-fat.it-codigo"
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
  
    CASE tt-item.campo:
/*         WHEN 'class-fiscal' THEN                                   */
/*             IF SUBSTRING(tt-item.it-codigo,1,3) <> '288'           */
/*             and SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT. */
        WHEN 'cod-ean' THEN
            IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
        WHEN 'altura'  THEN
            IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
        WHEN 'largura' THEN
            IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
        WHEN 'comprim' THEN
            IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
    END CASE.

    IF AVAIL tt-item
    AND (tt-item.valor = '0'
     OR  tt-item.valor = ?
     OR  tt-item.valor = ''
    /*OR  tt-item.valor = '00000000'*/ ) THEN
    ASSIGN tt-item.campo      :FGCOLOR IN BROWSE BR_TABLE = 12
           tt-item.nome-campo :FGCOLOR IN BROWSE BR_TABLE = 12
           tt-item.valor      :FGCOLOR IN BROWSE BR_TABLE = 12
           tt-item.responsavel:FGCOLOR IN BROWSE BR_TABLE = 12
           l-botaoN                                       = YES.

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


&Scoped-define SELF-NAME bt-valida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-valida B-table-Win
ON CHOOSE OF bt-valida IN FRAME F-Main /* Valida */
DO:

    DEFINE VARIABLE c-valida AS CHARACTER   NO-UNDO.

    FOR EACH tt-item NO-LOCK:

        CASE tt-item.campo:
/*             WHEN 'class-fiscal' THEN                                     */
/*                 IF SUBSTRING(tt-item.it-codigo,1,1) <> '4'               */
/*                 and SUBSTRING(tt-item.it-codigo,1,3) <> '288' THEN NEXT. */
            WHEN 'cod-ean' THEN
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
            WHEN 'altura'  THEN
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
            WHEN 'largura' THEN
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
            WHEN 'comprim' THEN
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
        END CASE.

        IF (tt-item.valor = '0'
        OR  tt-item.valor = '' 
        OR  tt-item.valor = ? 
        OR  tt-item.valor = '00000000') THEN DO:
            IF c-valida <> '' THEN
                ASSIGN c-valida = tt-item.campo + ' | ' + c-valida. 
            ELSE
                ASSIGN c-valida = tt-item.campo. 

        END.

    END.

    IF c-valida = '' THEN
        MESSAGE 'Campos obrigat¢rios sem dados: ' c-valida
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ELSE
        MESSAGE 'Dados OK'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "lib-item-fat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lib-item-fat"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaTT B-table-Win 
PROCEDURE pi-criaTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-estabCabec LIKE lib-item-fat.cod-estab-pad NO-UNDO.
    DEFINE INPUT  PARAMETER c-itemCabec  LIKE lib-item-fat.it-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-desabBotao AS LOGICAL INIT NO              NO-UNDO.

    DEFINE VARIABLE c-campoSubst  AS CHARACTER FORMAT 'X(100)'  NO-UNDO.
    DEFINE VARIABLE c-NcampoSubst AS CHARACTER FORMAT 'X(100)'  NO-UNDO.
    DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT 'X(100)'  NO-UNDO.
    DEFINE VARIABLE h-buffer      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-buffer2     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-query       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-tabela      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-condicao    AS CHARACTER   NO-UNDO.

    FOR EACH tt-item.
        DELETE tt-item.
    END.

/*     FIND FIRST lib-item-fat NO-LOCK NO-ERROR. */
/*     IF AVAIL lib-item-fat THEN                */
    ASSIGN c-it-codigo = c-itemCabec.

    for EACH mgesp.ponto-programa NO-LOCK
        where ponto-programa.nome-programa = "esftp031"
          AND ponto-programa.ponto         = 1,  
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF ENTRY(1,conteudo-programa.conteudo,",") = 'cod-ean' THEN DO:

            ASSIGN c-tabela      = "item-mat"
                   c-condicao    = " WHERE item-mat.it-codigo = '" + c-it-codigo + "' "
                   c-campoSubst  = ENTRY(1,conteudo-programa.conteudo,",")
                   c-NcampoSubst = ENTRY(2,conteudo-programa.conteudo,",")
                   c-responsavel = ENTRY(3,conteudo-programa.conteudo,",").

            CREATE BUFFER h-buffer2 FOR TABLE c-tabela.
            create query h-query.

            h-query:set-buffers(h-buffer2).

            h-query:QUERY-PREPARE("FOR EACH " + c-tabela +  " no-lock " + c-condicao ).
            h-query:QUERY-OPEN().
            h-query:GET-FIRST().

            REPEAT:

                IF NOT h-buffer2:AVAILABLE THEN LEAVE.

                FIND FIRST ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

                CREATE tt-item.
                ASSIGN tt-item.it-codigo   = h-buffer2:BUFFER-FIELD('it-codigo'):BUFFER-VALUE
                       tt-item.campo       = c-campoSubst
                       tt-item.nome-campo  = c-NcampoSubst
                       tt-item.valor       = h-buffer2:BUFFER-FIELD(c-campoSubst):BUFFER-VALUE
                       tt-item.responsavel = c-responsavel
                       tt-item.cd-origem   = IF AVAIL ITEM THEN item.cd-origem ELSE 0.

                h-query:GET-NEXT() NO-ERROR.

            END.

        END.
        ELSE DO:

            ASSIGN c-tabela      = "item"
                   c-condicao    = " WHERE item.it-codigo = '" + c-it-codigo + "' "
                   c-campoSubst  = ENTRY(1,conteudo-programa.conteudo,",")
                   c-NcampoSubst = ENTRY(2,conteudo-programa.conteudo,",")
                   c-responsavel = ENTRY(3,conteudo-programa.conteudo,",").

            CREATE BUFFER h-buffer FOR TABLE c-tabela.
            create query h-query.

            h-query:set-buffers(h-buffer).

            h-query:QUERY-PREPARE("FOR EACH " + c-tabela +  " no-lock " + c-condicao ).
            h-query:QUERY-OPEN().
            h-query:GET-FIRST().

            REPEAT:

                IF NOT h-buffer:AVAILABLE THEN LEAVE.

                FIND FIRST ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

                CREATE tt-item.
                ASSIGN tt-item.it-codigo   = h-buffer:BUFFER-FIELD('it-codigo'):BUFFER-VALUE
                       tt-item.campo       = c-campoSubst
                       tt-item.nome-campo  = c-NcampoSubst
                       tt-item.valor       = h-buffer:BUFFER-FIELD(c-campoSubst):BUFFER-VALUE
                       tt-item.responsavel = c-responsavel
                       tt-item.cd-origem   = IF AVAIL item THEN item.cd-origem ELSE 0.

                h-query:GET-NEXT() NO-ERROR.

            END.

        END.
    END.

    ASSIGN l-botaoN = NO.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    ASSIGN l-desabBotao = l-botaoN.

    IF NOT CAN-FIND(FIRST tt-item) THEN
        ASSIGN l-desabBotao = YES.
    ELSE DO:
        FOR EACH tt-item NO-LOCK:
            IF tt-item.campo = 'cod-ean' THEN DO:
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
            END.
/*             ELSE                                                         */
/*             IF tt-item.campo = 'class-fiscal' THEN DO:                   */
/*                 IF SUBSTRING(tt-item.it-codigo,1,1) <> '4'               */
/*                 and SUBSTRING(tt-item.it-codigo,1,3) <> '288' THEN NEXT. */
/*             END.                                                         */
            ELSE IF (tt-item.campo = 'altura' 
                 OR  tt-item.campo = 'largura' 
                 OR  tt-item.campo = 'comprim') THEN DO:
                IF SUBSTRING(tt-item.it-codigo,1,1) <> '4' THEN NEXT.
            END.
            ELSE DO:
                IF (tt-item.valor = '0'
                OR  tt-item.valor = ?
                OR  tt-item.valor = ''
                OR  tt-item.valor = '00000000') THEN
                    ASSIGN l-desabBotao = YES.
            END.

        END. /* FOR EACH tt-item NO-LOCK: */
    END.

/***
OPEN QUERY {&SELF-NAME} FOR EACH item OF lib-item-fat
      WHERE item.it-codigo = lib-item-fat.it-codigo NO-LOCK
    ~{&SORTBY-PHRASE}.
    ***/

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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "fm-codigo" "item" "fm-codigo"}
  {src/adm/template/sndkycas.i "it-codigo" "item" "it-codigo"}
  {src/adm/template/sndkycas.i "class-fiscal" "item" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "item" "cod-comprado"}
  {src/adm/template/sndkycas.i "cod-estabel" "item" "cod-estabel"}
  {src/adm/template/sndkycas.i "fm-cod-com" "item" "fm-cod-com"}
  {src/adm/template/sndkycas.i "ge-codigo" "item" "ge-codigo"}
  {src/adm/template/sndkycas.i "cd-tag" "item" "cd-tag"}
  {src/adm/template/sndkycas.i "nr-linha" "item" "nr-linha"}
  {src/adm/template/sndkycas.i "cd-planejado" "item" "cd-planejado"}
  {src/adm/template/sndkycas.i "cod-refer" "item" "cod-refer"}
  {src/adm/template/sndkycas.i "un" "item" "un"}
  {src/adm/template/sndkycas.i "nat-despesa" "item" "nat-despesa"}
  {src/adm/template/sndkycas.i "cod-servico" "item" "cod-servico"}
  {src/adm/template/sndkycas.i "cod-tax" "item" "cod-tax"}
  {src/adm/template/sndkycas.i "cod-unid-negoc" "item" "cod-unid-negoc"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "lib-item-fat"}
  {src/adm/template/snd-list.i "tt-item"}

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
  DEFINE VARIABLE l-Botao AS LOGICAL INIT NO              NO-UNDO.

  FIND CURRENT lib-item-fat NO-LOCK NO-ERROR.
  IF AVAIL lib-item-fat THEN
      RUN pi-criaTT (INPUT  lib-item-fat.cod-estab-pad,
                     INPUT  lib-item-fat.it-codigo  ,
                     OUTPUT l-Botao).
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

