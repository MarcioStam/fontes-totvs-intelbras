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
{esp/es0018.i}

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
DEFINE NEW GLOBAL SHARED VAR h-ViewerEstabLib   AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-itemLiberacao  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuarioSolicit AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-statusSolicit  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-numSolicit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-estabSolicit   AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-lib-item-fat_Usu  FOR lib-item-fat.
DEFINE BUFFER b-usu-lib-item-fat  FOR usu-lib-item-fat.

DEFINE TEMP-TABLE tt-itemValida
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD campo        AS CHARACTER FORMAT  'X(20)'
    FIELD valor        AS CHARACTER FORMAT 'X(100)'
    FIELD responsavel  AS CHARACTER FORMAT  'X(12)'.

DEFINE TEMP-TABLE tt-liberacoes
    FIELD cod-solicitacao       LIKE lib-item-fat.cod-solicitacao 
    FIELD cod-estabel           LIKE lib-item-fat.cod-estab-pad 
    FIELD it-codigo             LIKE lib-item-fat.it-codigo 
    FIELD usuario               LIKE lib-item-fat.usuario 
    FIELD dt-liberacao          LIKE lib-item-fat.dt-liberacao
    FIELD c-status              LIKE lib-item-fat.c-status             COLUMN-LABEL 'STATUS'
    FIELD tipo                  AS LOGICAL FORMAT 'F/T'                COLUMN-LABEL 'Tipo'
    FIELD c-estabel-vincs       AS CHARACTER FORMAT 'X(50)'            COLUMN-LABEL 'Vincs.'
    FIELD cod-estab-trans-orig  LIKE lib-item-fat.cod-estab-trans-orig COLUMN-LABEL 'Estab Orig'
    FIELD cod-estab-trans-dest  LIKE lib-item-fat.cod-estab-trans-dest COLUMN-LABEL 'Estab Dest'.

DEFINE TEMP-TABLE tt-ClassItem
    FIELD class-fiscal  LIKE ITEM.class-fiscal
    FIELD usuario-lib   LIKE lib-item-fat.usuario-lib.

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
&Scoped-define INTERNAL-TABLES tt-liberacoes

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-liberacoes.cod-solicitacao tt-liberacoes.it-codigo tt-liberacoes.tipo tt-liberacoes.usuario tt-liberacoes.dt-liberacao tt-liberacoes.c-estabel-vincs tt-liberacoes.cod-estab-trans-orig tt-liberacoes.cod-estab-trans-dest tt-liberacoes.c-status   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH tt-liberacoes BY tt-liberacoes.cod-solicitacao DESC
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH tt-liberacoes BY tt-liberacoes.cod-solicitacao DESC.
&Scoped-define TABLES-IN-QUERY-br_table tt-liberacoes
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-liberacoes


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table bt-libera 

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
it-codigo||y|mgesp.int-item.it-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "it-codigo"':U).

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
DEFINE BUTTON bt-libera 
     LABEL "Libera Solicitacao" 
     SIZE 18.29 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-liberacoes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      tt-liberacoes.cod-solicitacao
tt-liberacoes.it-codigo   
tt-liberacoes.tipo 
tt-liberacoes.usuario        
tt-liberacoes.dt-liberacao
tt-liberacoes.c-estabel-vincs       
tt-liberacoes.cod-estab-trans-orig 
tt-liberacoes.cod-estab-trans-dest
tt-liberacoes.c-status
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79 BY 13.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.13 COL 3
     bt-libera AT ROW 14.42 COL 63.72 HELP
          "Aprova Solicit. Transferˆncia / Libera Solicit. Faturamento" WIDGET-ID 4
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
         HEIGHT             = 14.54
         WIDTH              = 82.57.
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

ASSIGN 
       br_table:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE
       br_table:COLUMN-MOVABLE IN FRAME F-Main         = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-liberacoes BY tt-liberacoes.cod-solicitacao DESC.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is OPENED
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

    IF AVAIL tt-liberacoes  THEN DO:

        CASE tt-liberacoes.c-status:

            WHEN 'Solicitacao Gerada' THEN DO:
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 9
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 9 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 9 .
            END.
            WHEN 'Aguardando Liberacao' THEN DO:
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 7
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 7 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 7.
            END.
            WHEN 'Liberado' THEN DO: 
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 2.
            END.
            WHEN 'Transf. Aprovada' THEN DO: 
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 2
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 2 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 2.
            END.
            WHEN 'Recusado' THEN DO: 
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 13
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 13 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 13.
            END.
            WHEN 'Cancelado' THEN DO: 
                ASSIGN tt-liberacoes.cod-solicitacao     :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.it-codigo           :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.tipo                :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.usuario             :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.dt-liberacao        :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.c-estabel-vincs     :FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.cod-estab-trans-orig:FGCOLOR IN BROWSE BR_TABLE = 12
                       tt-liberacoes.cod-estab-trans-dest:FGCOLOR IN BROWSE BR_TABLE = 12 
                       tt-liberacoes.c-status            :FGCOLOR IN BROWSE BR_TABLE = 12.
            END.

        END CASE.

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


&Scoped-define SELF-NAME bt-libera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-libera B-table-Win
ON CHOOSE OF bt-libera IN FRAME F-Main /* Libera Solicitacao */
DO:
  EMPTY TEMP-TABLE tt-prog-ponto.
  RUN esp/es0018p.p (INPUT  "esftp031":U,
                     INPUT  3,
                     INPUT  0,
                     INPUT  "":U,
                     OUTPUT TABLE tt-prog-ponto).

  FOR EACH tt-prog-ponto NO-LOCK:  
    FOR EACH usu-lib-item-fat 
        WHERE (usu-lib-item-fat.cod-usuario = ENTRY(1,tt-prog-ponto.conteudo,";")
          OR   usu-lib-item-fat.cod-usuario = ENTRY(2,tt-prog-ponto.conteudo,";"))  EXCLUSIVE-LOCK:
    
       ASSIGN usu-lib-item-fat.log-1 = YES.
    END.
   
    
    FOR EACH lib-item-fat
        WHERE lib-item-fat.c-status <> "Cancelado" 
          AND lib-item-fat.c-status <> "Liberado"  
          AND lib-item-fat.c-status <> "Transf. Aprovada"NO-LOCK .

        FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:

            FIND FIRST tt-ClassItem
                WHERE tt-ClassItem.class-fiscal = ITEM.class-fiscal NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-ClassItem THEN DO:
                IF   lib-item-fat.usuario-lib <> '' 
                AND (lib-item-fat.usuario-lib <> ENTRY(1,tt-prog-ponto.conteudo,";")
                AND  lib-item-fat.usuario-lib <> ENTRY(2,tt-prog-ponto.conteudo,";")) THEN DO:
                    CREATE tt-ClassItem.
                    ASSIGN tt-ClassItem.class-fiscal = ITEM.class-fiscal 
                           tt-ClassItem.usuario-lib  = lib-item-fat.usuario-lib .
                END. /* IF lib-item-fat.usuario-lib <> '' THEN DO: */
            END. /* IF NOT AVAIL tt-ClassItem THEN DO: */
        END. /* IF AVAIL ITEM THEN DO: */
    END. /* FOR EACH lib-item-fat */

    FIND FIRST lib-item-fat
        WHERE lib-item-fat.cod-solicitacao = i-numSolicit EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN DO:

        ASSIGN lib-item-fat.c-status     = "Aguardando Liberacao"
               lib-item-fat.dt-liberacao = TODAY.
     
      IF  lib-item-fat.cod-estab-vinculado MATCHES('*103*') THEN
          ASSIGN lib-item-fat.usuario-lib = ENTRY(1,tt-prog-ponto.conteudo,";").
      
      IF  lib-item-fat.cod-estab-vinculado MATCHES('*601*') OR 
          lib-item-fat.cod-estab-vinculado MATCHES('*602*') OR
          lib-item-fat.cod-estab-vinculado MATCHES('*601,602*') THEN
          ASSIGN lib-item-fat.usuario-lib = ENTRY(2,tt-prog-ponto.conteudo,";").       
      
        ELSE DO:    
            FIND FIRST b-lib-item-fat_Usu
                WHERE  b-lib-item-fat_Usu.cod-solicitacao <> lib-item-fat.cod-solicitacao 
                  AND  b-lib-item-fat_Usu.it-codigo        = lib-item-fat.it-codigo 
                  AND  b-lib-item-fat_Usu.c-status        <> "Cancelado"       
                  AND  b-lib-item-fat_Usu.c-status        <> "Liberado"        
                  AND  b-lib-item-fat_Usu.c-status        <> "Transf. Aprovada"
                  AND  b-lib-item-fat_Usu.usuario-lib     <> ''                
                  AND  (b-lib-item-fat_Usu.usuario-lib    <> ENTRY(1,tt-prog-ponto.conteudo,";")
                  AND  b-lib-item-fat_Usu.usuario-lib     <> ENTRY(2,tt-prog-ponto.conteudo,";")) NO-LOCK NO-ERROR.
    
            IF AVAIL b-lib-item-fat_Usu THEN DO:

                FIND FIRST usu-lib-item-fat 
                    WHERE usu-lib-item-fat.cod-usuario  = b-lib-item-fat_Usu.usuario-lib
                      AND usu-lib-item-fat.gerencial    = YES NO-LOCK NO-ERROR.
                IF AVAIL usu-lib-item-fat THEN
                    ASSIGN lib-item-fat.usuario-lib = b-lib-item-fat_Usu.usuario-lib.                     
            END.
            ELSE DO:
                FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL ITEM AND ITEM.class-fiscal <> '' THEN DO:
                    FIND FIRST tt-ClassItem WHERE tt-ClassItem.class-fiscal = ITEM.class-fiscal NO-LOCK NO-ERROR.
                    IF AVAIL tt-ClassItem THEN DO:
                        FIND FIRST usu-lib-item-fat 
                            WHERE usu-lib-item-fat.cod-usuario  = tt-ClassItem.usuario-lib
                              AND usu-lib-item-fat.gerencial    = YES NO-LOCK NO-ERROR.
                        IF AVAIL usu-lib-item-fat THEN
                            ASSIGN lib-item-fat.usuario-lib = tt-ClassItem.usuario-lib.  
                    END.
                END. /* IF AVAIL ITEM AND ITEM.class-fiscal <> '' THEN DO: */
            END.
    
            IF lib-item-fat.usuario-lib = '' THEN DO:
    
                IF NOT CAN-FIND(FIRST usu-lib-item-fat
                               WHERE usu-lib-item-fat.log-1 = NO
                                 AND usu-lib-item-fat.astec = NO) THEN DO:
                    FOR EACH usu-lib-item-fat EXCLUSIVE-LOCK:
                        ASSIGN usu-lib-item-fat.log-1 = NO.
                    END. /* FOR EACH usu-lib-item-fat EXCLUSIVE-LOCK: */
                END. /* IF NOT CAN-FIND(FIRST usu-lib-item-fat */
    
                FIND FIRST usu-lib-item-fat 
                    WHERE (usu-lib-item-fat.cod-usuario <> ENTRY(1,tt-prog-ponto.conteudo,";")
                      AND usu-lib-item-fat.cod-usuario  <> ENTRY(2,tt-prog-ponto.conteudo,";")) 
                      AND usu-lib-item-fat.log-1        = NO 
                      AND usu-lib-item-fat.astec        = NO EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL usu-lib-item-fat THEN DO:
                    ASSIGN lib-item-fat.usuario-lib  = usu-lib-item-fat.cod-usuario
                           usu-lib-item-fat.log-1    = YES.
                END. /* FOR EACH usu-lib-item-fat NO-LOCK. */
            END. /* IF lib-item-fat.usuario-lib = '' THEN DO: */
        END. /* IF  lib-item-fat.cod-estab-vinculado NOT-MATCHES('*103*') THEN */
     END. /* IF AVAIL lib-item-fat THEN DO: */
   END. //tt-prog-ponto
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bt-libera:SENSITIVE = NO.
      /*DISABLE bt-libera.*/
  END. /* DO WITH FRAME {&FRAME-NAME}: */

  RUN pi-atualizaStatus IN h-ViewerEstabLib.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-AlteraColuna B-table-Win 
PROCEDURE pi-AlteraColuna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-liberacoes.c-estabel-vincs     :WIDTH IN BROWSE BR_TABLE = 25
           tt-liberacoes.cod-estab-trans-orig:WIDTH IN BROWSE BR_TABLE = 8
           tt-liberacoes.cod-estab-trans-orig:LABEL IN BROWSE BR_TABLE = 'Estab Orig'
           tt-liberacoes.cod-estab-trans-dest:WIDTH IN BROWSE BR_TABLE = 8
           tt-liberacoes.cod-estab-trans-dest:LABEL IN BROWSE BR_TABLE = 'Estab Dest'.

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
    DEF INPUT PARAMETER c-itemSol AS CHAR            NO-UNDO.
    DEF INPUT PARAMETER l-desabBt AS LOGICAL INIT NO NO-UNDO.

    EMPTY TEMP-TABLE tt-liberacoes.
    DEFINE VARIABLE l-libera AS LOGICAL  INIT YES   NO-UNDO.

    FIND CURRENT lib-item-fat  NO-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN 
        ASSIGN c-itemLiberacao  = lib-item-fat.it-codigo
               c-usuarioSolicit = lib-item-fat.usuario
               c-statusSolicit  = lib-item-fat.c-status
               i-numSolicit     = lib-item-fat.cod-solicitacao
               c-estabSolicit   = lib-item-fat.cod-estab-pad
               l-libera         = IF lib-item-fat.log-1 = YES THEN YES ELSE NO.

/*     MESSAGE 'c-itemLiberacao  ' c-itemLiberacao  SKIP */
/*             'c-usuarioSolicit ' c-usuarioSolicit SKIP */
/*             'c-statusSolicit  ' c-statusSolicit  SKIP */
/*             'i-numSolicit     ' i-numSolicit     SKIP */
/*             'c-estabSolicit   ' c-estabSolicit   SKIP */
/*             'l-libera         ' l-libera              */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.            */

    FOR EACH lib-item-fat
        WHERE lib-item-fat.it-codigo = c-itemSol NO-LOCK:

        /*** 
        IF i-numSolicit     = lib-item-fat.cod-solicitacao THEN NEXT.
        ***/

        CREATE tt-liberacoes.
        ASSIGN tt-liberacoes.cod-solicitacao      = lib-item-fat.cod-solicitacao
               tt-liberacoes.cod-estabel          = lib-item-fat.cod-estab-pad    
               tt-liberacoes.it-codigo            = lib-item-fat.it-codigo      
               tt-liberacoes.usuario              = lib-item-fat.usuario       
               tt-liberacoes.dt-liberacao         = lib-item-fat.dt-liberacao
               tt-liberacoes.c-status             = lib-item-fat.c-status
               tt-liberacoes.tipo                 = lib-item-fat.log-1
               tt-liberacoes.c-estabel-vincs      = string(replace(lib-item-fat.cod-estab-vinculado,',',' '),'X(25)')
               tt-liberacoes.cod-estab-trans-orig = lib-item-fat.cod-estab-trans-orig 
               tt-liberacoes.cod-estab-trans-dest = lib-item-fat.cod-estab-trans-dest .  
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN bt-libera:SENSITIVE = l-libera.
    END. /* DO WITH FRAME {&FRAME-NAME}: */

    IF c-usuarioSolicit <> c-seg-usuario THEN DO:
        DO WITH FRAME {&FRAME-NAME}:
            ASSIGN bt-libera:SENSITIVE = NO.
            /*DISABLE bt-libera.*/
        END. /* DO WITH FRAME {&FRAME-NAME}: */
    END. /* IF lib-item-fat.usuario <> c-seg-usuario THEN DO: */
    /*ELSE DO:

        IF c-statusSolicit = 'Solicitacao Gerada' THEN DO:

            RUN pi-validaDados.

            IF CAN-FIND(FIRST tt-itemValida
                        WHERE tt-itemValida.valor = ''
                           OR tt-itemValida.valor = '0'
                           OR tt-itemValida.valor = '00000000'
                           OR tt-itemValida.valor =  ?) THEN DO:

/*                 MESSAGE 'l-desabBt '  l-desabBt        */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                DO WITH FRAME {&FRAME-NAME}:
                    CASE tt-itemValida.campo:
                        WHEN 'class-fiscal' THEN
                            IF SUBSTRING(tt-itemValida.it-codigo,1,1) = '4'
                            OR SUBSTRING(tt-itemValida.it-codigo,1,3) = '288' THEN
                                ASSIGN bt-libera:SENSITIVE = NO .
                        WHEN 'cod-ean' THEN
                            IF SUBSTRING(tt-itemValida.it-codigo,1,1) <> '4'  THEN
                                ASSIGN bt-libera:SENSITIVE = YES .
                        WHEN 'altura'  THEN
                            IF SUBSTRING(tt-itemValida.it-codigo,1,1) <> '4'  THEN
                                ASSIGN bt-libera:SENSITIVE = NO .
                        WHEN 'largura' THEN
                            IF SUBSTRING(tt-itemValida.it-codigo,1,1) <> '4'  THEN
                                ASSIGN bt-libera:SENSITIVE = NO .
                        WHEN 'comprim' THEN
                            IF SUBSTRING(tt-itemValida.it-codigo,1,1) <> '4'  THEN
                                ASSIGN bt-libera:SENSITIVE = NO .
                    END CASE.

                END. /* DO WITH FRAME {&FRAME-NAME}: */
/*                 MESSAGE '2 l-desabBt ' l-desabBt       */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

            END. /* IF CAN-FIND(FIRST tt-itemValidaValida */

        END. /* IF lib-item-fat.c-status = 'Solicitacao Gerada' THEN DO: */
        ELSE DO:

            DO WITH FRAME {&FRAME-NAME}:
                ASSIGN bt-libera:SENSITIVE = NO.
                /*DISABLE bt-libera.*/
            END. /* DO WITH FRAME {&FRAME-NAME}: */
        END.
    END.  ELSE DO: */
    
    IF l-desabBt THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN bt-libera:SENSITIVE = NO.
        /*DISABLE bt-libera.*/
    END. /* DO WITH FRAME {&FRAME-NAME}: */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilitaLibera B-table-Win 
PROCEDURE pi-desabilitaLibera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DO WITH FRAME {&FRAME-NAME}:
            ASSIGN bt-libera:SENSITIVE = NO.
        END. /* DO WITH FRAME {&FRAME-NAME}: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ValidaDados B-table-Win 
PROCEDURE pi-ValidaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-campoSubst  AS CHARACTER FORMAT 'X(100)'  NO-UNDO.
    DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT 'X(100)'  NO-UNDO.
    DEFINE VARIABLE h-buffer      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-query       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-tabela      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-condicao    AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-itemValida.

    FOR EACH mgesp.ponto-programa NO-LOCK
        where ponto-programa.nome-programa = "esftp031"
          AND ponto-programa.ponto         = 1,  
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF ENTRY(1,conteudo-programa.conteudo,",") = 'cod-ean' THEN DO:
            ASSIGN c-tabela      = "item-mat"
                   c-condicao    = " WHERE item-mat.it-codigo = '" + c-itemLiberacao + "' "
                   c-campoSubst  = 'cod-ean'
                   c-responsavel = ENTRY(2,conteudo-programa.conteudo,",").
    
            CREATE BUFFER h-buffer FOR TABLE c-tabela.
            create query h-query.
    
            h-query:set-buffers(h-buffer).
    
            h-query:QUERY-PREPARE("FOR EACH " + c-tabela +  " no-lock " + c-condicao ).
            h-query:QUERY-OPEN().
            h-query:GET-FIRST().
    
            REPEAT:
    
                IF NOT h-buffer:AVAILABLE THEN LEAVE.
    
                CREATE tt-itemValida.
                ASSIGN tt-itemValida.it-codigo   = h-buffer:BUFFER-FIELD('it-codigo'):BUFFER-VALUE
                       tt-itemValida.campo       = c-campoSubst
                       tt-itemValida.valor       = h-buffer:BUFFER-FIELD(c-campoSubst):BUFFER-VALUE
                       tt-itemValida.responsavel = c-responsavel.

/*                 MESSAGE ' tt-itemValida.it-codigo   ' tt-itemValida.it-codigo   skip */
/*                         ' tt-itemValida.campo       ' tt-itemValida.campo       skip */
/*                         ' tt-itemValida.valor       ' tt-itemValida.valor       skip */
/*                         ' tt-itemValida.responsavel ' tt-itemValida.responsavel      */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                               */
    
                h-query:GET-NEXT() NO-ERROR.
    
            END.
        END.
        ELSE DO:
            ASSIGN c-tabela      = "item"
                   c-condicao    = " WHERE item.it-codigo = '" + c-itemLiberacao + "' "
                   c-campoSubst  = ENTRY(1,conteudo-programa.conteudo,",")
                   c-responsavel = ENTRY(2,conteudo-programa.conteudo,",").
    
            CREATE BUFFER h-buffer FOR TABLE c-tabela.
            create query h-query.
    
            h-query:set-buffers(h-buffer).
    
            h-query:QUERY-PREPARE("FOR EACH " + c-tabela +  " no-lock " + c-condicao ).
            h-query:QUERY-OPEN().
            h-query:GET-FIRST().
    
            REPEAT:
    
                IF NOT h-buffer:AVAILABLE THEN LEAVE.
    
                CREATE tt-itemValida.
                ASSIGN tt-itemValida.it-codigo   = h-buffer:BUFFER-FIELD('it-codigo'):BUFFER-VALUE
                       tt-itemValida.campo       = c-campoSubst
                       tt-itemValida.valor       = h-buffer:BUFFER-FIELD(c-campoSubst):BUFFER-VALUE
                       tt-itemValida.responsavel = c-responsavel.
    
/*                 MESSAGE 2 SKIP                                                       */
/*                         ' tt-itemValida.it-codigo   ' tt-itemValida.it-codigo   skip */
/*                         ' tt-itemValida.campo       ' tt-itemValida.campo       skip */
/*                         ' tt-itemValida.valor       ' tt-itemValida.valor       skip */
/*                         ' tt-itemValida.responsavel ' tt-itemValida.responsavel      */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                               */
    
                h-query:GET-NEXT() NO-ERROR.
    
            END.
        END.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

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
  {src/adm/template/sndkycas.i "it-codigo" "int-item" "it-codigo"}

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
  {src/adm/template/snd-list.i "tt-liberacoes"}

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

  
  FIND CURRENT lib-item-fat  NO-LOCK NO-ERROR.
  IF AVAIL lib-item-fat THEN 
    RUN pi-criaTT (INPUT lib-item-fat.it-codigo,
                   INPUT 'NO').
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

