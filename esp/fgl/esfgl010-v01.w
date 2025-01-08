&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

/* {include/i-freeac.i} */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEFINE VARIABLE wh-imprime       AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_des_tit_ctbl   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-msg-valida     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE r-int-agrup      AS ROWID       NO-UNDO.
DEFINE VARIABLE l-erro-layout    AS LOGICAL     NO-UNDO.

DEF BUFFER b-int-agrup-demonst-ctbl FOR int-agrup-demonst-ctbl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-agrupadores

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-agrup-demonst-ctbl

/* Definitions for BROWSE br-agrupadores                                */
&Scoped-define FIELDS-IN-QUERY-br-agrupadores ~
int-agrup-demonst-ctbl.des-agrup-nivel-1 ~
int-agrup-demonst-ctbl.des-agrup-nivel-2 ~
int-agrup-demonst-ctbl.des-agrup-nivel-3 ~
int-agrup-demonst-ctbl.des-agrup-nivel-4 ~
int-agrup-demonst-ctbl.des-agrup-nivel-5 ~
int-agrup-demonst-ctbl.cod-cta-ctbl fn-titulo-ctbl() @ v_des_tit_ctbl ~
int-agrup-demonst-ctbl.cod-usuar-ult-alterac ~
int-agrup-demonst-ctbl.dat-ult-alterac ~
int-agrup-demonst-ctbl.hor-ult-alterac ~
int-agrup-demonst-ctbl.ind-orig-alterac 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-agrupadores ~
int-agrup-demonst-ctbl.des-agrup-nivel-1 ~
int-agrup-demonst-ctbl.des-agrup-nivel-2 ~
int-agrup-demonst-ctbl.des-agrup-nivel-3 ~
int-agrup-demonst-ctbl.des-agrup-nivel-4 ~
int-agrup-demonst-ctbl.des-agrup-nivel-5 ~
int-agrup-demonst-ctbl.cod-cta-ctbl 
&Scoped-define ENABLED-TABLES-IN-QUERY-br-agrupadores ~
int-agrup-demonst-ctbl
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-agrupadores int-agrup-demonst-ctbl
&Scoped-define QUERY-STRING-br-agrupadores FOR EACH int-agrup-demonst-ctbl ~
      WHERE int-agrup-demonst-ctbl.cod-cta-ctbl >= c-cta-disp-ini and ~
int-agrup-demonst-ctbl.cod-cta-ctbl <= c-cta-disp-fim NO-LOCK
&Scoped-define OPEN-QUERY-br-agrupadores OPEN QUERY br-agrupadores FOR EACH int-agrup-demonst-ctbl ~
      WHERE int-agrup-demonst-ctbl.cod-cta-ctbl >= c-cta-disp-ini and ~
int-agrup-demonst-ctbl.cod-cta-ctbl <= c-cta-disp-fim NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-agrupadores int-agrup-demonst-ctbl
&Scoped-define FIRST-TABLE-IN-QUERY-br-agrupadores int-agrup-demonst-ctbl


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-agrupadores}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold IMAGE-1 IMAGE-2 br-agrupadores ~
bt-importar c-cta-disp-ini c-cta-disp-fim bt-fil bt-inc bt-del 
&Scoped-Define DISPLAYED-OBJECTS c-cta-disp-ini c-cta-disp-fim 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-titulo-ctbl V-table-Win 
FUNCTION fn-titulo-ctbl RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/im-era.bmp":U
     LABEL "Eliminar" 
     SIZE 5 BY 1.13 TOOLTIP "Eliminar Agrupador".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar Contas Dispon¡veis" 
     SIZE 5 BY 1 TOOLTIP "Filtrar Contas Dispon¡veis".

DEFINE BUTTON bt-importar 
     IMAGE-UP FILE "image/im-load.bmp":U
     LABEL "Importar arquivo com itens x estabelecimentos" 
     SIZE 5 BY 1.13 TOOLTIP "Importar arquivo com itens x estabelecimentos".

DEFINE BUTTON bt-inc 
     IMAGE-UP FILE "image/im-add.bmp":U
     LABEL "incluir" 
     SIZE 5 BY 1.13 TOOLTIP "Incluir Agrupador".

DEFINE VARIABLE c-cta-disp-fim AS CHARACTER FORMAT "X(20)":U INITIAL "99999999" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cta-disp-ini AS CHARACTER FORMAT "X(20)":U INITIAL "10000000" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

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
DEFINE QUERY br-agrupadores FOR 
      int-agrup-demonst-ctbl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-agrupadores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-agrupadores V-table-Win _STRUCTURED
  QUERY br-agrupadores NO-LOCK DISPLAY
      int-agrup-demonst-ctbl.des-agrup-nivel-1 FORMAT "x(60)":U
            WIDTH 55
      int-agrup-demonst-ctbl.des-agrup-nivel-2 FORMAT "x(60)":U
            WIDTH 55
      int-agrup-demonst-ctbl.des-agrup-nivel-3 FORMAT "x(60)":U
            WIDTH 55
      int-agrup-demonst-ctbl.des-agrup-nivel-4 FORMAT "x(60)":U
            WIDTH 55
      int-agrup-demonst-ctbl.des-agrup-nivel-5 FORMAT "x(60)":U
            WIDTH 55
      int-agrup-demonst-ctbl.cod-cta-ctbl FORMAT "x(8)":U WIDTH 8.43
      fn-titulo-ctbl() @ v_des_tit_ctbl COLUMN-LABEL "T¡tulo" FORMAT "x(40)":U
            WIDTH 30
      int-agrup-demonst-ctbl.cod-usuar-ult-alterac FORMAT "x(16)":U
      int-agrup-demonst-ctbl.dat-ult-alterac FORMAT "99/99/9999":U
            WIDTH 11.14
      int-agrup-demonst-ctbl.hor-ult-alterac FORMAT "x(8)":U WIDTH 9.29
      int-agrup-demonst-ctbl.ind-orig-alterac FORMAT "x(12)":U
  ENABLE
      int-agrup-demonst-ctbl.des-agrup-nivel-1
      int-agrup-demonst-ctbl.des-agrup-nivel-2
      int-agrup-demonst-ctbl.des-agrup-nivel-3
      int-agrup-demonst-ctbl.des-agrup-nivel-4
      int-agrup-demonst-ctbl.des-agrup-nivel-5
      int-agrup-demonst-ctbl.cod-cta-ctbl
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 102 BY 17.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     br-agrupadores AT ROW 1.75 COL 3 WIDGET-ID 400
     bt-importar AT ROW 19.21 COL 100 WIDGET-ID 20
     c-cta-disp-ini AT ROW 19.25 COL 6 COLON-ALIGNED WIDGET-ID 2
     c-cta-disp-fim AT ROW 19.25 COL 27.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     bt-fil AT ROW 19.25 COL 43.43 WIDGET-ID 6
     bt-inc AT ROW 19.25 COL 89.72 WIDGET-ID 22
     bt-del AT ROW 19.25 COL 94.86 WIDGET-ID 24
     rt-mold AT ROW 1.25 COL 2
     IMAGE-1 AT ROW 19.33 COL 22.14 WIDGET-ID 12
     IMAGE-2 AT ROW 19.33 COL 26.14 WIDGET-ID 14
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
/* BROWSE-TAB br-agrupadores IMAGE-2 f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-agrupadores
/* Query rebuild information for BROWSE br-agrupadores
     _TblList          = "mgesp.int-agrup-demonst-ctbl"
     _Options          = "NO-LOCK"
     _Where[1]         = "int-agrup-demonst-ctbl.cod-cta-ctbl >= c-cta-disp-ini and
int-agrup-demonst-ctbl.cod-cta-ctbl <= c-cta-disp-fim"
     _FldNameList[1]   > mgesp.int-agrup-demonst-ctbl.des-agrup-nivel-1
"des-agrup-nivel-1" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.int-agrup-demonst-ctbl.des-agrup-nivel-2
"des-agrup-nivel-2" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.int-agrup-demonst-ctbl.des-agrup-nivel-3
"des-agrup-nivel-3" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.int-agrup-demonst-ctbl.des-agrup-nivel-4
"des-agrup-nivel-4" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.int-agrup-demonst-ctbl.des-agrup-nivel-5
"des-agrup-nivel-5" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no "55" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.int-agrup-demonst-ctbl.cod-cta-ctbl
"cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fn-titulo-ctbl() @ v_des_tit_ctbl" "T¡tulo" "x(40)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = mgesp.int-agrup-demonst-ctbl.cod-usuar-ult-alterac
     _FldNameList[9]   > mgesp.int-agrup-demonst-ctbl.dat-ult-alterac
"dat-ult-alterac" ? ? "date" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > mgesp.int-agrup-demonst-ctbl.hor-ult-alterac
"hor-ult-alterac" ? ? "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = mgesp.int-agrup-demonst-ctbl.ind-orig-alterac
     _Query            is OPENED
*/  /* BROWSE br-agrupadores */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-agrupadores
&Scoped-define SELF-NAME br-agrupadores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-agrupadores V-table-Win
ON ROW-LEAVE OF br-agrupadores IN FRAME f-main
DO:
    IF  AVAIL int-agrup-demonst-ctbl
    THEN DO:
        IF  int-agrup-demonst-ctbl.des-agrup-nivel-1 <> int-agrup-demonst-ctbl.des-agrup-nivel-1:SCREEN-VALUE IN BROWSE br-agrupadores OR
            int-agrup-demonst-ctbl.des-agrup-nivel-2 <> int-agrup-demonst-ctbl.des-agrup-nivel-2:SCREEN-VALUE IN BROWSE br-agrupadores OR
            int-agrup-demonst-ctbl.des-agrup-nivel-3 <> int-agrup-demonst-ctbl.des-agrup-nivel-3:SCREEN-VALUE IN BROWSE br-agrupadores OR
            int-agrup-demonst-ctbl.des-agrup-nivel-4 <> int-agrup-demonst-ctbl.des-agrup-nivel-4:SCREEN-VALUE IN BROWSE br-agrupadores OR
            int-agrup-demonst-ctbl.des-agrup-nivel-5 <> int-agrup-demonst-ctbl.des-agrup-nivel-5:SCREEN-VALUE IN BROWSE br-agrupadores OR
            int-agrup-demonst-ctbl.cod-cta-ctbl      <> int-agrup-demonst-ctbl.cod-cta-ctbl     :SCREEN-VALUE IN BROWSE br-agrupadores
        THEN DO:
            FIND FIRST b-int-agrup-demonst-ctbl NO-LOCK
                WHERE  b-int-agrup-demonst-ctbl.cod-cta-ctbl  = int-agrup-demonst-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-agrupadores
                  AND ROWID(b-int-agrup-demonst-ctbl)        <> ROWID(int-agrup-demonst-ctbl) NO-ERROR.

            IF  NOT AVAIL b-int-agrup-demonst-ctbl
            THEN DO:
                FIND FIRST b-int-agrup-demonst-ctbl EXCLUSIVE-LOCK
                    WHERE  ROWID(b-int-agrup-demonst-ctbl) = ROWID(int-agrup-demonst-ctbl) NO-ERROR.

                ASSIGN b-int-agrup-demonst-ctbl.des-agrup-nivel-1     = int-agrup-demonst-ctbl.des-agrup-nivel-1:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-2     = int-agrup-demonst-ctbl.des-agrup-nivel-2:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-3     = int-agrup-demonst-ctbl.des-agrup-nivel-3:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-4     = int-agrup-demonst-ctbl.des-agrup-nivel-4:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-5     = int-agrup-demonst-ctbl.des-agrup-nivel-5:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.cod-cta-ctbl          = int-agrup-demonst-ctbl.cod-cta-ctbl     :SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.ind-orig-alterac      = "Manual"
                       b-int-agrup-demonst-ctbl.cod-usuar-ult-alterac = c-seg-usuario
                       b-int-agrup-demonst-ctbl.dat-ult-alterac       = TODAY
                       b-int-agrup-demonst-ctbl.hor-ult-alterac       = STRING(TIME,"hh:mm:ss").

                RELEASE b-int-agrup-demonst-ctbl.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "J  existe agrupador para a conta cont bil informada.").

                RETURN NO-APPLY.
            END.
        END.
    END.
    ELSE DO:
        IF  int-agrup-demonst-ctbl.cod-cta-ctbl:SCREEN-VALUE <> ""
        THEN DO:
            FIND FIRST b-int-agrup-demonst-ctbl NO-LOCK
                WHERE  b-int-agrup-demonst-ctbl.cod-cta-ctbl = int-agrup-demonst-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-agrupadores NO-ERROR.

            IF  NOT AVAIL b-int-agrup-demonst-ctbl
            THEN DO:
                CREATE b-int-agrup-demonst-ctbl.
                ASSIGN b-int-agrup-demonst-ctbl.des-agrup-nivel-1     = int-agrup-demonst-ctbl.des-agrup-nivel-1:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-2     = int-agrup-demonst-ctbl.des-agrup-nivel-2:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-3     = int-agrup-demonst-ctbl.des-agrup-nivel-3:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-4     = int-agrup-demonst-ctbl.des-agrup-nivel-4:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.des-agrup-nivel-5     = int-agrup-demonst-ctbl.des-agrup-nivel-5:SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.cod-cta-ctbl          = int-agrup-demonst-ctbl.cod-cta-ctbl     :SCREEN-VALUE IN BROWSE br-agrupadores
                       b-int-agrup-demonst-ctbl.ind-orig-alterac      = "Manual"
                       b-int-agrup-demonst-ctbl.cod-usuar-ult-alterac = c-seg-usuario
                       b-int-agrup-demonst-ctbl.dat-ult-alterac       = TODAY
                       b-int-agrup-demonst-ctbl.hor-ult-alterac       = STRING(TIME,"hh:mm:ss").

                RELEASE b-int-agrup-demonst-ctbl.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "J  existe agrupador para a conta cont bil informada.").

                RETURN NO-APPLY.
            END.
        END.
    END.
    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-agrupadores V-table-Win
ON VALUE-CHANGED OF br-agrupadores IN FRAME f-main
DO:
    ASSIGN r-int-agrup = ?.
    IF  AVAIL int-agrup-demonst-ctbl
    THEN
        ASSIGN r-int-agrup = ROWID(int-agrup-demonst-ctbl).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del V-table-Win
ON CHOOSE OF bt-del IN FRAME f-main /* Eliminar */
DO:
    IF  r-int-agrup <> ?
    THEN DO:
        FOR FIRST int-agrup-demonst-ctbl EXCLUSIVE-LOCK
            WHERE ROWID(int-agrup-demonst-ctbl) = r-int-agrup:
            DELETE int-agrup-demonst-ctbl.
        END.
        APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil V-table-Win
ON CHOOSE OF bt-fil IN FRAME f-main /* Filtrar Contas Dispon¡veis */
DO:
    ASSIGN c-cta-disp-ini = INPUT FRAME {&FRAME-NAME} c-cta-disp-ini
           c-cta-disp-fim = INPUT FRAME {&FRAME-NAME} c-cta-disp-fim.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    {&OPEN-QUERY-br-agrupadores}

    IF  SESSION:SET-WAIT-STATE("") THEN.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar V-table-Win
ON CHOOSE OF bt-importar IN FRAME f-main /* Importar arquivo com itens x estabelecimentos */
DO:
    DEFINE VARIABLE l-importar AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE c-arquivo  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE c-msg      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE c-linha    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE c-hora-imp AS CHARACTER            NO-UNDO.

    ASSIGN c-msg = "Confirma‡Æo de Layout.~~O arquivo a ser importardo deve ser .csv, "
                 + "possuir em seu layout os cinco n¡veis mais a conta cont bil "
                 + "separados por ponto e v¡rgula. Ex.:" + CHR(13) + CHR(13)
                 + "N¡vel-1;N¡vel-2;N¡vel-3;Nivel-4;Nivel-5;Conta".

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT c-msg).

    IF  RETURN-VALUE = "no"
    THEN
        RETURN NO-APPLY.

    ASSIGN c-msg = "Confirma‡Æo de Importa‡Æo.~~IMPORTANTE: a importa‡Æo do arquivo informado "
                 + "vai apagar todos os agrupadores j  existentes." + CHR(13) + CHR(13)
                 + "C O N F I R M A ?".

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

         FOR EACH int-agrup-demonst-ctbl EXCLUSIVE-LOCK:
             DELETE int-agrup-demonst-ctbl.
         END.

         ASSIGN c-hora-imp    = STRING(TIME,"hh:mm:ss")
                l-erro-layout = NO.

         INPUT FROM VALUE(c-arquivo) CONVERT SOURCE "iso8859-1".
         REPEAT:
             IMPORT UNFORMATTED c-linha.

             IF  NUM-ENTRIES(c-linha,";") >= 6
             THEN DO:
                FIND FIRST int-agrup-demonst-ctbl NO-LOCK
                    WHERE  int-agrup-demonst-ctbl.cod-cta-ctbl = ENTRY(6,c-linha,";") NO-ERROR.

                IF  NOT AVAIL int-agrup-demonst-ctbl
                THEN DO:
                    CREATE int-agrup-demonst-ctbl.
                    ASSIGN int-agrup-demonst-ctbl.cod-cta-ctbl          = ENTRY(6,c-linha,";")
                           int-agrup-demonst-ctbl.des-agrup-nivel-1     = ENTRY(1,c-linha,";")
                           int-agrup-demonst-ctbl.des-agrup-nivel-2     = ENTRY(2,c-linha,";")
                           int-agrup-demonst-ctbl.des-agrup-nivel-3     = ENTRY(3,c-linha,";")
                           int-agrup-demonst-ctbl.des-agrup-nivel-4     = ENTRY(4,c-linha,";")
                           int-agrup-demonst-ctbl.des-agrup-nivel-5     = ENTRY(5,c-linha,";")
                           int-agrup-demonst-ctbl.ind-orig-alterac      = "Importa‡Æo"
                           int-agrup-demonst-ctbl.cod-usuar-ult-alterac = c-seg-usuario
                           int-agrup-demonst-ctbl.dat-ult-alterac       = TODAY
                           int-agrup-demonst-ctbl.hor-ult-alterac       = c-hora-imp.
                END.
             END.
             ELSE DO:
                 ASSIGN l-erro-layout = YES.
                 LEAVE.
             END.
         END.
         INPUT CLOSE.
     END.

     APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.
     
     IF  SESSION:SET-WAIT-STATE("") THEN.

     IF  l-erro-layout
     THEN
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 17006,
                            INPUT "Layout do arquivo ‚ inv lido, importa‡Æo cancelada.").
     ELSE
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 15825,
                            INPUT "Importa‡Æo finalizada com sucesso.").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inc V-table-Win
ON CHOOSE OF bt-inc IN FRAME f-main /* incluir */
DO:
    br-agrupadores:SELECT-ROW(1).
    APPLY "VALUE-CHANGED" TO br-agrupadores.
    IF  NUM-RESULTS("br-agrupadores") > 0 
    THEN DO:
        br-agrupadores:INSERT-ROW("after").
        apply "entry" to int-agrup-demonst-ctbl.des-agrup-nivel-1 in browse br-agrupadores. 
    END.
    else do:
        create int-agrup-demonst-ctbl.
        ASSIGN int-agrup-demonst-ctbl.cod-cta-ctbl = "99999999".
        
        APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.
        
        apply "entry" to int-agrup-demonst-ctbl.des-agrup-nivel-1 in browse br-agrupadores. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
    DISPLAY c-cta-disp-ini
            c-cta-disp-fim
            WITH FRAME {&FRAME-NAME}.

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-chave V-table-Win 
PROCEDURE pi-valida-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-des-msg AS CHAR.

    FIND FIRST b-int-agrup-demonst-ctbl NO-LOCK
        WHERE  b-int-agrup-demonst-ctbl.cod-cta-ctbl  = int-agrup-demonst-ctbl.cod-cta-ctbl:SCREEN-VALUE IN BROWSE br-agrupadores
          AND ROWID(b-int-agrup-demonst-ctbl)        <> ROWID(int-agrup-demonst-ctbl) NO-ERROR.
    
    IF  NOT AVAIL b-int-agrup-demonst-ctbl
    THEN DO:
/*         FIND FIRST b-int-agrup-demonst-ctbl NO-LOCK                                  */
/*             WHERE  b-int-agrup-demonst-ctbl.cod-cta-ctbl      = c-chave[1]           */
/*               AND  b-int-agrup-demonst-ctbl.des-agrup-nivel-1 = c-chave[2]           */
/*               AND  b-int-agrup-demonst-ctbl.des-agrup-nivel-2 = c-chave[3]           */
/*               AND  b-int-agrup-demonst-ctbl.des-agrup-nivel-3 = c-chave[4] NO-ERROR. */
/*                                                                                      */
/*         IF  NOT AVAIL b-int-agrup-demonst-ctbl                                       */
/*         THEN DO:                                                                     */
/*             CREATE b-int-agrup-demonst-ctbl.                                         */
/*             ASSIGN b-int-agrup-demonst-ctbl.cod-cta-ctbl          = c-chave[1]       */
/*                    b-int-agrup-demonst-ctbl.des-agrup-nivel-1     = c-chave[2]       */
/*                    b-int-agrup-demonst-ctbl.des-agrup-nivel-2     = c-chave[3]       */
/*                    b-int-agrup-demonst-ctbl.des-agrup-nivel-3     = c-chave[4]       */
/*                    b-int-agrup-demonst-ctbl.ind-orig-alterac      = "Importa‡Æo"     */
/*                    b-int-agrup-demonst-ctbl.cod-usuar-ult-alterac = c-seg-usuario    */
/*                    b-int-agrup-demonst-ctbl.dat-ult-alterac       = TODAY            */
/*                    b-int-agrup-demonst-ctbl.hor-ult-alterac       = c-hora-imp.      */
/*         END.                                                                         */
    END.
    ELSE
        ASSIGN p-des-msg = "J  existe agrupador para a conta cont bil informada.".

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
  {src/adm/template/snd-list.i "int-agrup-demonst-ctbl"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-titulo-ctbl V-table-Win 
FUNCTION fn-titulo-ctbl RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR FIRST cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
          AND cta_ctbl.cod_cta_ctbl       = int-agrup-demonst-ctbl.cod-cta-ctbl:
        RETURN cta_ctbl.des_tit_ctbl.
    END.
    
    RETURN "*** CONTA INEXISTENTE ***".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

