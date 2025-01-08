&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE item.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEFINE VARIABLE wh-imprime       AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-des-item       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_num_linhas_sel AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-importa-item NO-UNDO
    FIELD it-codigo   AS CHAR
    FIELD cod-estabel AS CHAR
    INDEX id-item
            cod-estabel
            it-codigo.

DEF BUFFER b_int_item_integra_gesplan FOR int_item_integra_gesplan.
DEF BUFFER b-item                     FOR ITEM.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-item-disp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item int_item_integra_gesplan

/* Definitions for BROWSE br-item-disp                                  */
&Scoped-define FIELDS-IN-QUERY-br-item-disp tt-item.it-codigo ~
tt-item.desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-disp 
&Scoped-define QUERY-STRING-br-item-disp FOR EACH tt-item NO-LOCK
&Scoped-define OPEN-QUERY-br-item-disp OPEN QUERY br-item-disp FOR EACH tt-item NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-item-disp tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-disp tt-item


/* Definitions for BROWSE br-item-gesplan                               */
&Scoped-define FIELDS-IN-QUERY-br-item-gesplan ~
int_item_integra_gesplan.it-codigo fn-desc-item() @ v-des-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-gesplan 
&Scoped-define QUERY-STRING-br-item-gesplan FOR EACH int_item_integra_gesplan ~
      WHERE int_item_integra_gesplan.cod-estabel = c-estab NO-LOCK
&Scoped-define OPEN-QUERY-br-item-gesplan OPEN QUERY br-item-gesplan FOR EACH int_item_integra_gesplan ~
      WHERE int_item_integra_gesplan.cod-estabel = c-estab NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-item-gesplan int_item_integra_gesplan
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-gesplan int_item_integra_gesplan


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-item-disp}~
    ~{&OPEN-QUERY-br-item-gesplan}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold IMAGE-1 IMAGE-2 br-item-disp ~
br-item-gesplan bt-add bt-del bt-importar c-item-disp-ini c-item-disp-fim ~
bt-fil c-estab bt-integrado 
&Scoped-Define DISPLAYED-OBJECTS c-item-disp-ini c-item-disp-fim c-estab 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item V-table-Win 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br-item-disp 
       MENU-ITEM m_Todos        LABEL "Todos"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "Incluir" 
     SIZE 5 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "Eliminar" 
     SIZE 5 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar Itens Dispon¡veis" 
     SIZE 5 BY 1 TOOLTIP "Filtrar Itens Dispon¡veis".

DEFINE BUTTON bt-importar 
     IMAGE-UP FILE "image/im-load.bmp":U
     LABEL "Importar arquivo com itens x estabelecimentos" 
     SIZE 5 BY 1.13 TOOLTIP "Importar arquivo com itens x estabelecimentos".

DEFINE BUTTON bt-integrado 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Apresentar itens parametrizados para integra‡Æo" 
     SIZE 5 BY 1 TOOLTIP "Apresentar itens parametrizados para integra‡Æo".

DEFINE VARIABLE c-estab AS CHARACTER FORMAT "X(3)":U INITIAL "101" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE c-item-disp-fim AS CHARACTER FORMAT "X(8)":U INITIAL "500000000" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE c-item-disp-ini AS CHARACTER FORMAT "X(8)":U INITIAL "400000000" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY 1.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 19.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-item-disp FOR 
      tt-item SCROLLING.

DEFINE QUERY br-item-gesplan FOR 
      int_item_integra_gesplan SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-item-disp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-disp V-table-Win _STRUCTURED
  QUERY br-item-disp NO-LOCK DISPLAY
      tt-item.it-codigo FORMAT "x(16)":U WIDTH 9.43
      tt-item.desc-item FORMAT "x(60)":U WIDTH 35.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 49 BY 17.25
         FONT 1
         TITLE "Itens Dispon¡veis" FIT-LAST-COLUMN.

DEFINE BROWSE br-item-gesplan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-gesplan V-table-Win _STRUCTURED
  QUERY br-item-gesplan NO-LOCK DISPLAY
      int_item_integra_gesplan.it-codigo FORMAT "x(16)":U WIDTH 9.43
      fn-desc-item() @ v-des-item COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
            WIDTH 34.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 47 BY 17.25
         FONT 1
         TITLE "Item Selecionados Para Integra‡Æo" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     br-item-disp AT ROW 1.75 COL 3 WIDGET-ID 400
     br-item-gesplan AT ROW 1.75 COL 58 WIDGET-ID 300
     bt-add AT ROW 8.75 COL 52.57 WIDGET-ID 8
     bt-del AT ROW 10.38 COL 52.57 WIDGET-ID 10
     bt-importar AT ROW 19.21 COL 100 WIDGET-ID 20
     c-item-disp-ini AT ROW 19.25 COL 5 COLON-ALIGNED WIDGET-ID 2
     c-item-disp-fim AT ROW 19.25 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     bt-fil AT ROW 19.25 COL 41.29 WIDGET-ID 6
     c-estab AT ROW 19.25 COL 68 COLON-ALIGNED WIDGET-ID 18
     bt-integrado AT ROW 19.25 COL 74.14 WIDGET-ID 16
     rt-mold AT ROW 1.25 COL 2
     IMAGE-1 AT ROW 19.33 COL 19.29 WIDGET-ID 12
     IMAGE-2 AT ROW 19.33 COL 25.72 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-item T "?" NO-UNDO mgcad item
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 19.5
         WIDTH              = 105.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-item-disp IMAGE-2 f-main */
/* BROWSE-TAB br-item-gesplan br-item-disp f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       br-item-disp:POPUP-MENU IN FRAME f-main             = MENU POPUP-MENU-br-item-disp:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-disp
/* Query rebuild information for BROWSE br-item-disp
     _TblList          = "Temp-Tables.tt-item"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-item.it-codigo
"tt-item.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-item.desc-item
"tt-item.desc-item" ? ? "character" ? ? ? ? ? ? no ? no no "35.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-item-disp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-gesplan
/* Query rebuild information for BROWSE br-item-gesplan
     _TblList          = "mgesp.int_item_integra_gesplan"
     _Options          = "NO-LOCK"
     _Where[1]         = "mgesp.int_item_integra_gesplan.cod-estabel = c-estab"
     _FldNameList[1]   > mgesp.int_item_integra_gesplan.it-codigo
"int_item_integra_gesplan.it-codigo" ? "x(16)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-desc-item() @ v-des-item" "Descri‡Æo" "x(40)" ? ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-item-gesplan */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-item-disp
&Scoped-define SELF-NAME br-item-disp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-disp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-item-disp IN FRAME f-main /* Itens Dispon¡veis */
DO:
    APPLY "choose" TO bt-add IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item-gesplan
&Scoped-define SELF-NAME br-item-gesplan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-gesplan V-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-item-gesplan IN FRAME f-main /* Item Selecionados Para Integra‡Æo */
DO:
    APPLY "choose" TO bt-del IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add V-table-Win
ON CHOOSE OF bt-add IN FRAME f-main /* Incluir */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    ASSIGN c-estab = INPUT FRAME {&FRAME-NAME} c-estab.

    DO  v_num_linhas_sel = 1 TO br-item-disp:NUM-SELECTED-ROWS:
        br-item-disp:FETCH-SELECTED-ROW(v_num_linhas_sel).

        CREATE int_item_integra_gesplan.
        ASSIGN int_item_integra_gesplan.cod-estabel = c-estab
               int_item_integra_gesplan.it-codigo   = tt-item.it-codigo.
    END.

    {&OPEN-QUERY-br-item-gesplan}

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del V-table-Win
ON CHOOSE OF bt-del IN FRAME f-main /* Eliminar */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    DO  v_num_linhas_sel = 1 TO br-item-gesplan:NUM-SELECTED-ROWS:
        br-item-gesplan:FETCH-SELECTED-ROW(v_num_linhas_sel).

        FIND CURRENT int_item_integra_gesplan EXCLUSIVE-LOCK.
        DELETE int_item_integra_gesplan.
    END.

    {&OPEN-QUERY-br-item-gesplan}

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil V-table-Win
ON CHOOSE OF bt-fil IN FRAME f-main /* Filtrar Itens Dispon¡veis */
DO:
    ASSIGN c-item-disp-ini = INPUT FRAME {&FRAME-NAME} c-item-disp-ini
           c-item-disp-fim = INPUT FRAME {&FRAME-NAME} c-item-disp-fim
           c-estab         = INPUT FRAME {&FRAME-NAME} c-estab.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    EMPTY TEMP-TABLE tt-item.

    FOR EACH  ITEM NO-LOCK
        WHERE ITEM.cod-obsoleto  = 1 /* Ativo */
          AND item.it-codigo    >= c-item-disp-ini
          AND item.it-codigo    <= c-item-disp-fim:

        IF  ITEM.tipo-contr = 4 /* Debito Direto */
        THEN
            NEXT.
    
        IF  ITEM.ge-codigo <> 40 AND /* acabado      */
            ITEM.ge-codigo <> 45     /* acabado      */
        THEN
            NEXT.

        IF  CAN-FIND (FIRST b_int_item_integra_gesplan NO-LOCK
                           WHERE b_int_item_integra_gesplan.cod-estabel = c-estab
                             AND b_int_item_integra_gesplan.it-codigo   = item.it-codigo)
        THEN
            NEXT.

        FIND FIRST tt-item NO-LOCK
            WHERE  tt-item.it-codigo = item.it-codigo NO-ERROR.

        IF  NOT AVAIL tt-item
        THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = item.it-codigo
                   tt-item.desc-item = item.desc-item.
        END.
    END.

    OPEN QUERY br-item-disp FOR EACH tt-item NO-LOCK.

    IF  SESSION:SET-WAIT-STATE("") THEN.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar V-table-Win
ON CHOOSE OF bt-importar IN FRAME f-main /* Importar arquivo com itens x estabelecimentos */
DO:
    DEFINE VARIABLE l-importar AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-arquivo  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-linha    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg      AS CHARACTER   NO-UNDO.

    ASSIGN c-msg = "Confirma‡Æo de Layout.~~O arquivo a ser importardo deve ser .csv, "
                 + "possuir em seu layout nos dois primeiros campos o c¢digo do estabelecimento "
                 + "e c¢digo do item, separados por ponto e v¡rgula." + CHR(13) + CHR(13)
                 + "Ex.: 101;4331000;CENTRAL TELEFONICA MODULARE MAIS (2x4)".

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT c-msg).

    IF  RETURN-VALUE = "no"
    THEN
        RETURN NO-APPLY.

    SYSTEM-DIALOG GET-FILE c-arquivo
        FILTERS "csv" "*.csv"
        INITIAL-FILTER 1
        ASK-OVERWRITE 
        DEFAULT-EXTENSION "csv" 
        USE-FILENAME 
        UPDATE l-importar.

     IF  l-importar = YES
     THEN DO:
         IF  SEARCH(c-arquivo) = ?
         THEN DO:
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT "Arquivo nÆo encontrado.").
             RETURN NO-APPLY.
         END.

         IF  SESSION:SET-WAIT-STATE("general") THEN.

         FOR EACH int_item_integra_gesplan EXCLUSIVE-LOCK:
             DELETE int_item_integra_gesplan.
         END.

         EMPTY TEMP-TABLE tt-importa-item.

         INPUT FROM VALUE(c-arquivo).
         REPEAT:
             IMPORT UNFORMATTED c-linha.

             IF  NUM-ENTRIES(c-linha,";") > 1
             THEN DO:
                CREATE tt-importa-item.
                ASSIGN tt-importa-item.cod-estabel = ENTRY(1,c-linha,";")
                       tt-importa-item.it-codigo   = ENTRY(2,c-linha,";").
             END.
         END.

         FOR EACH tt-importa-item
             BREAK BY tt-importa-item.cod-estabel
                   BY tt-importa-item.it-codigo:

             IF  FIRST-OF(tt-importa-item.it-codigo)
             THEN DO:
                 FOR FIRST estabelec NO-LOCK
                     WHERE estabelec.cod-estabel = tt-importa-item.cod-estabel:

                     FOR FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = tt-importa-item.it-codigo:

                         FIND FIRST int_item_integra_gesplan NO-LOCK
                             WHERE  int_item_integra_gesplan.cod-estabel = tt-importa-item.cod-estabel
                               AND  int_item_integra_gesplan.it-codigo   = tt-importa-item.it-codigo NO-ERROR.

                         IF  NOT AVAIL int_item_integra_gesplan
                         THEN DO:

                            CREATE int_item_integra_gesplan.
                            ASSIGN int_item_integra_gesplan.cod-estabel = tt-importa-item.cod-estabel
                                   int_item_integra_gesplan.it-codigo   = tt-importa-item.it-codigo.
                         END.
                     END.
                 END.
             END.
         END.
     END.

     APPLY "choose" TO bt-integrado IN FRAME {&FRAME-NAME}.
     
     IF  SESSION:SET-WAIT-STATE("") THEN.

     RUN utp/ut-msgs.p (INPUT "show",
                        INPUT 15825,
                        INPUT "Importa‡Æo finalizada com sucesso.").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-integrado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-integrado V-table-Win
ON CHOOSE OF bt-integrado IN FRAME f-main /* Apresentar itens parametrizados para integra‡Æo */
DO:
    ASSIGN c-estab = INPUT FRAME {&FRAME-NAME} c-estab.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    {&OPEN-QUERY-br-item-gesplan}

    IF  SESSION:SET-WAIT-STATE("") THEN.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todos V-table-Win
ON CHOOSE OF MENU-ITEM m_Todos /* Todos */
DO:
    br-item-disp:SELECT-ALL() IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item-disp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
    DISP c-item-disp-ini
         c-item-disp-fim 
         c-estab
         WITH FRAME {&FRAME-NAME}.

    APPLY "choose" TO bt-fil       IN FRAME {&FRAME-NAME}.
    APPLY "choose" TO bt-integrado IN FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "int_item_integra_gesplan"}
  {src/adm/template/snd-list.i "tt-item"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item V-table-Win 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST b-item NO-LOCK
        WHERE b-item.it-codigo       = int_item_integra_gesplan.it-codigo:
        RETURN b-item.desc-item.
    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

