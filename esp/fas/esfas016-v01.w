&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
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

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

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

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR                          NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_bem_pat      AS RECID FORMAT ">>>>>>9" INIT ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_motiv_desmob AS RECID FORMAT ">>>>>>9":U      NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-doc-entrada      AS RECID                         NO-UNDO.

def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.

def new global shared var v_rec_localizacao
    as recid
    format ">>>>>>9":U
    no-undo.

def new global shared var v_rec_ccusto
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR v-row-parent  AS ROWID                              NO-UNDO.
DEF VAR h-acomp       AS HANDLE                             NO-UNDO.
DEF VAR v_num_solic   LIKE int_solic_transf.num_solicitacao NO-UNDO.
DEF VAR v_remetente   AS CHAR                               NO-UNDO.
DEF VAR v_destino     AS CHAR                               NO-UNDO.
DEF VAR v_msg_mail    AS CHAR                               NO-UNDO.
DEF VAR v_aux_observ  AS CHAR                               NO-UNDO.
DEF VAR v_dat_transf  AS DATE                               NO-UNDO.
DEF VAR v_dat_aux     AS DATE                               NO-UNDO.
DEF VAR v_cod_cta_pat LIKE int_solic_transf.cod_cta_pat     NO-UNDO.
DEF VAR v_nome_usuar  LIKE usuar_mestre.nom_usuario         NO-UNDO.
def var v_cod_return_sit as character format "x(40)":U      no-undo.

{utp/utapi019.i}
{cdp/cd0666.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES int_solic_transf
&Scoped-define FIRST-EXTERNAL-TABLE int_solic_transf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int_solic_transf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int_solic_transf.num_solicitacao ~
int_solic_transf.num_bem_pat int_solic_transf.num_seq_bem_pat ~
int_solic_transf.cod_cta_pat int_solic_transf.cod_estab ~
int_solic_transf.cod_ccusto int_solic_transf.cod_unid_negoc ~
int_solic_transf.dat_transf 
&Scoped-define ENABLED-TABLES int_solic_transf
&Scoped-define FIRST-ENABLED-TABLE int_solic_transf
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 RECT-10 RECT-11 
&Scoped-Define DISPLAYED-FIELDS int_solic_transf.num_solicitacao ~
int_solic_transf.ind_aprovac int_solic_transf.num_bem_pat ~
int_solic_transf.num_seq_bem_pat int_solic_transf.cod_cta_pat ~
int_solic_transf.cod_est_ori int_solic_transf.cod_estab ~
int_solic_transf.cod_ccus_ori int_solic_transf.cod_ccusto ~
int_solic_transf.cod_unid_neg_ori int_solic_transf.cod_unid_negoc ~
int_solic_transf.cod_usuar_super int_solic_transf.dat_transf ~
int_solic_transf.cod_usuar_solic int_solic_transf.serie_transf ~
int_solic_transf.nr_nota_transf int_solic_transf.emitente_transf ~
int_solic_transf.nat_oper_transf 
&Scoped-define DISPLAYED-TABLES int_solic_transf
&Scoped-define FIRST-DISPLAYED-TABLE int_solic_transf
&Scoped-Define DISPLAYED-OBJECTS v_descricao v_observ 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS int_solic_transf.cod_est_ori ~
int_solic_transf.cod_ccus_ori int_solic_transf.cod_unid_neg_ori ~
int_solic_transf.serie_transf int_solic_transf.nr_nota_transf ~
int_solic_transf.emitente_transf int_solic_transf.nat_oper_transf 
&Scoped-define ADM-MODIFY-FIELDS int_solic_transf.num_solicitacao ~
int_solic_transf.num_bem_pat int_solic_transf.num_seq_bem_pat ~
int_solic_transf.cod_cta_pat int_solic_transf.serie_transf ~
int_solic_transf.nr_nota_transf int_solic_transf.emitente_transf ~
int_solic_transf.nat_oper_transf 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE v_observ AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 152 SCROLLBAR-VERTICAL
     SIZE 80 BY 3 NO-UNDO.

DEFINE VARIABLE v_descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 14.5.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 4.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 4.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int_solic_transf.num_solicitacao AT ROW 1.25 COL 24 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     int_solic_transf.ind_aprovac AT ROW 1.25 COL 70 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     int_solic_transf.num_bem_pat AT ROW 2.25 COL 24 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88 TOOLTIP "Utilize duplo clique para consultar o bem patrimonial"
     int_solic_transf.num_seq_bem_pat AT ROW 2.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88 TOOLTIP "Utilize duplo clique para consultar o bem patrimonial"
     v_descricao AT ROW 2.25 COL 43.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     int_solic_transf.cod_cta_pat AT ROW 3.25 COL 24 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88 TOOLTIP "Utilize duplo clique para consultar o bem patrimonial"
     int_solic_transf.cod_est_ori AT ROW 5.25 COL 24 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     int_solic_transf.cod_estab AT ROW 5.25 COL 63 COLON-ALIGNED WIDGET-ID 12
          LABEL "Estab Destino"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     int_solic_transf.cod_ccus_ori AT ROW 6.25 COL 24 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     int_solic_transf.cod_ccusto AT ROW 6.25 COL 63 COLON-ALIGNED WIDGET-ID 8
          LABEL "Centro Custo Destino"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     int_solic_transf.cod_unid_neg_ori AT ROW 7.25 COL 24 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int_solic_transf.cod_unid_negoc AT ROW 7.25 COL 63 COLON-ALIGNED WIDGET-ID 18
          LABEL "Unid Negocio Destino"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     int_solic_transf.cod_usuar_super AT ROW 8.25 COL 24 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     int_solic_transf.dat_transf AT ROW 8.25 COL 63 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 11 BY .88 TOOLTIP "Data de corte dia 25. Ap¢s esta data ser† transferido dia 01 do màs seguinte."
     int_solic_transf.cod_usuar_solic AT ROW 9.25 COL 24 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     int_solic_transf.serie_transf AT ROW 10.5 COL 63 COLON-ALIGNED WIDGET-ID 58
          LABEL "SÇrie Transf"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     int_solic_transf.nr_nota_transf AT ROW 11.5 COL 63 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     int_solic_transf.emitente_transf AT ROW 12.5 COL 63 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     int_solic_transf.nat_oper_transf AT ROW 13.5 COL 63 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     v_observ AT ROW 15.5 COL 4 NO-LABEL WIDGET-ID 38
     "Nota Transferància" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 9.75 COL 46 WIDGET-ID 62
     "Observaá‰es" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 14.75 COL 4 WIDGET-ID 42
     rt-key AT ROW 1 COL 1.57
     RECT-1 AT ROW 4.75 COL 1.57 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     RECT-10 AT ROW 15 COL 3 WIDGET-ID 40
     RECT-11 AT ROW 10 COL 43 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int_solic_transf
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 18.42
         WIDTH              = 87.72.
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
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN int_solic_transf.cod_ccusto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_ccus_ori IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_cta_pat IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_estab IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_est_ori IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_unid_negoc IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_unid_neg_ori IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_usuar_solic IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.cod_usuar_super IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.emitente_transf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN int_solic_transf.ind_aprovac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solic_transf.nat_oper_transf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN int_solic_transf.nr_nota_transf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN int_solic_transf.num_bem_pat IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN int_solic_transf.num_seq_bem_pat IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN int_solic_transf.num_solicitacao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN int_solic_transf.serie_transf IN FRAME f-main
   NO-ENABLE 2 3 EXP-LABEL                                              */
/* SETTINGS FOR FILL-IN v_descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR v_observ IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME int_solic_transf.cod_ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_ccusto V-table-Win
ON F5 OF int_solic_transf.cod_ccusto IN FRAME f-main /* Centro Custo Destino */
DO:
    run prgint/utb/utb066na.p .

    if  v_rec_ccusto <> ? then do:
        find emscad.ccusto 
            where recid(emscad.ccusto) = v_rec_ccusto no-lock no-error.

        assign int_solic_transf.cod_ccusto:screen-value in frame f-main = string(emscad.ccusto.cod_ccusto).

        /*
        display ccusto.des_tit_ctbl
                with frame f_adp_02_bem_pat.
        */
    end.

    apply "entry" to int_solic_transf.cod_ccusto in frame f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_ccusto V-table-Win
ON LEAVE OF int_solic_transf.cod_ccusto IN FRAME f-main /* Centro Custo Destino */
DO:
    FIND FIRST int-centro-custo
         WHERE int-centro-custo.cod-estabel    = INPUT FRAME {&frame-name} int_solic_transf.cod_estab
         AND   int-centro-custo.cc-codigo      = INPUT FRAME {&frame-name} int_solic_transf.cod_ccusto
         AND   int-centro-custo.cod-unid-negoc = INPUT FRAME {&frame-name} int_solic_transf.cod_unid_negoc NO-LOCK NO-ERROR.

    IF  AVAIL int-centro-custo THEN
        ASSIGN int_solic_transf.cod_usuar_super:SCREEN-VALUE IN FRAME {&FRAME-NAME} = int-centro-custo.cod_usuario.
    ELSE
        ASSIGN int_solic_transf.cod_usuar_super:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    FIND FIRST cc_uni_estab NO-LOCK 
        WHERE cc_uni_estab.cod_ccusto = INPUT FRAME {&frame-name} int_solic_transf.cod_ccusto
        AND   cc_uni_estab.cod_estab  = INPUT FRAME {&frame-name} int_solic_transf.cod_estab NO-ERROR.

    IF  AVAIL cc_uni_estab THEN
        ASSIGN int_solic_transf.cod_unid_negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cc_uni_estab.cod_unid_negoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.cod_ccusto IN FRAME f-main /* Centro Custo Destino */
DO:
    run prgint/utb/utb066na.p .

    if  v_rec_ccusto <> ? then do:
        find emscad.ccusto 
            where recid(emscad.ccusto) = v_rec_ccusto no-lock no-error.

        assign int_solic_transf.cod_ccusto:screen-value in frame f-main = string(emscad.ccusto.cod_ccusto).

        /*
        display ccusto.des_tit_ctbl
                with frame f_adp_02_bem_pat.
        */
    end.

    apply "entry" to int_solic_transf.cod_ccusto in frame f-main.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.cod_cta_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_cta_pat V-table-Win
ON F5 OF int_solic_transf.cod_cta_pat IN FRAME f-main /* Conta Patrimonial */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_cta_pat V-table-Win
ON LEAVE OF int_solic_transf.cod_cta_pat IN FRAME f-main /* Conta Patrimonial */
DO:
    FIND FIRST bem_pat
        WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
        AND   bem_pat.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
        AND   bem_pat.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
        AND   bem_pat.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
        NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN DO:

        IF  DAY(TODAY) > 25 THEN DO:
            ASSIGN v_dat_transf = DATE((IF MONTH(TODAY) = 12 THEN 01
                                        ELSE MONTH(TODAY) + 1),
                                        01,
                                        IF MONTH(TODAY) = 12 THEN YEAR(TODAY) + 1
                                        ELSE YEAR(TODAY)).
            
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_dat_transf).
        END.
        ELSE
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").

        ASSIGN int_solic_transf.cod_est_ori:SCREEN-VALUE                     IN FRAME {&frame-name} = bem_pat.cod_estab
               /*int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = bem_pat.cod_estab*/
               int_solic_transf.cod_ccus_ori:SCREEN-VALUE                    IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons
               /*int_solic_transf.cod_ccusto:SCREEN-VALUE      IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons*/
               int_solic_transf.cod_unid_neg_ori:SCREEN-VALUE                IN FRAME {&frame-name} = bem_pat.cod_unid_negoc
               /*int_solic_transf.cod_unid_negoc:SCREEN-VALUE  IN FRAME {&frame-name} = bem_pat.cod_unid_negoc*/
               int_solic_transf.cod_usuar_solic:SCREEN-VALUE IN FRAME {&frame-name} = v_cod_usuar_corren
               v_observ:SCREEN-VALUE                         IN FRAME {&frame-name} = ""
               v_descricao:SCREEN-VALUE                      IN FRAME {&frame-name} = bem_pat.des_bem_pat.

        IF  PROGRAM-NAME(1) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(2) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(3) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(4) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(5) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(6) MATCHES "*re1001*" THEN DO:
            FIND FIRST docum-est
                WHERE RECID(docum-est) = r-doc-entrada NO-LOCK NO-ERROR.

            IF  AVAIL docum-est THEN
                ASSIGN int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = docum-est.serie-docto
                       int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = docum-est.nro-docto
                       int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = string(docum-est.cod-emitente)
                       int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.nat-operacao
                       int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = docum-est.cod-estabel.
        END.
        ELSE
            ASSIGN r-doc-entrada                                                        = ?
                   int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = ""
                   int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = ""
                   int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = ""
                   int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_cta_pat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.cod_cta_pat IN FRAME f-main /* Conta Patrimonial */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.cod_estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_estab V-table-Win
ON F5 OF int_solic_transf.cod_estab IN FRAME f-main /* Estab Destino */
DO:
    run prgint/utb/utb071na.p (Input v_cod_empres_usuar).

    if  v_rec_estabelecimento <> ? then do:
        find estabelecimento 
            where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.

        assign int_solic_transf.cod_estab:screen-value in frame f-main = string(estabelecimento.cod_estab).

        /*
        display estabelecimento.nom_pessoa
                with frame f_adp_02_bem_pat.
        */

        apply "entry" to int_solic_transf.cod_estab in frame f-main.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_estab V-table-Win
ON LEAVE OF int_solic_transf.cod_estab IN FRAME f-main /* Estab Destino */
DO:
  IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab <> INPUT FRAME {&frame-name} int_solic_transf.cod_est_ori THEN
      ASSIGN int_solic_transf.nr_nota_transf:SENSITIVE  IN FRAME {&frame-name} = YES
             int_solic_transf.serie_transf:SENSITIVE    IN FRAME {&frame-name} = YES
             int_solic_transf.emitente_transf:SENSITIVE IN FRAME {&frame-name} = YES
             int_solic_transf.nat_oper_transf:SENSITIVE IN FRAME {&frame-name} = YES.
  ELSE
      ASSIGN int_solic_transf.nr_nota_transf:SENSITIVE  IN FRAME {&frame-name} = NO
             int_solic_transf.serie_transf:SENSITIVE    IN FRAME {&frame-name} = NO
             int_solic_transf.emitente_transf:SENSITIVE IN FRAME {&frame-name} = NO
             int_solic_transf.nat_oper_transf:SENSITIVE IN FRAME {&frame-name} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_estab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.cod_estab IN FRAME f-main /* Estab Destino */
DO:
    run prgint/utb/utb071na.p (Input v_cod_empres_usuar).

    if  v_rec_estabelecimento <> ? then do:
        find estabelecimento 
            where recid(estabelecimento) = v_rec_estabelecimento no-lock no-error.

        assign int_solic_transf.cod_estab:screen-value in frame f-main = string(estabelecimento.cod_estab).

        /*
        display estabelecimento.nom_pessoa
                with frame f_adp_02_bem_pat.
        */

        apply "entry" to int_solic_transf.cod_estab in frame f-main.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.cod_unid_negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_unid_negoc V-table-Win
ON F5 OF int_solic_transf.cod_unid_negoc IN FRAME f-main /* Unid Negocio Destino */
DO:
    run prgint/utb/utb011nb.p .

    if  v_rec_unid_negoc <> ? then do:
        find unid_negoc 
            where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.

        assign int_solic_transf.cod_unid_negoc:screen-value in frame f-main = string(unid_negoc.cod_unid_negoc).

        apply "entry" TO int_solic_transf.cod_unid_negoc in frame f-main.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.cod_unid_negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.cod_unid_negoc IN FRAME f-main /* Unid Negocio Destino */
DO:
    run prgint/utb/utb011nb.p .

    if  v_rec_unid_negoc <> ? then do:
        find unid_negoc 
            where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.

        assign int_solic_transf.cod_unid_negoc:screen-value in frame f-main = string(unid_negoc.cod_unid_negoc).

        apply "entry" TO int_solic_transf.cod_unid_negoc in frame f-main.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.dat_transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.dat_transf V-table-Win
ON LEAVE OF int_solic_transf.dat_transf IN FRAME f-main /* Dt Transferància */
DO:
    IF  day(INPUT FRAME {&frame-name} int_solic_transf.dat_transf) > 25 THEN DO:
        ASSIGN v_dat_transf = DATE((IF MONTH(INPUT FRAME {&frame-name} int_solic_transf.dat_transf) = 12 THEN 01
                                    ELSE MONTH(INPUT FRAME {&frame-name} int_solic_transf.dat_transf) + 1),
                                    01,
                                    IF MONTH(INPUT FRAME {&frame-name} int_solic_transf.dat_transf) = 12 THEN YEAR(INPUT FRAME {&frame-name} int_solic_transf.dat_transf) + 1
                                    ELSE YEAR(INPUT FRAME {&frame-name} int_solic_transf.dat_transf)).

        ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_dat_transf).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.emitente_transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.emitente_transf V-table-Win
ON LEAVE OF int_solic_transf.emitente_transf IN FRAME f-main /* Emitente */
DO:
    FIND FIRST docum-est
        WHERE docum-est.serie-docto  = INPUT FRAME {&frame-name} int_solic_transf.serie_transf
        AND   docum-est.nro-docto    = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf
        AND   docum-est.cod-emitente = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
        AND   docum-est.nat-operacao = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
        NO-LOCK NO-ERROR.

    IF  AVAIL docum-est THEN
        ASSIGN int_solic_transf.cod_estab:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.cod-estabel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.nat_oper_transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.nat_oper_transf V-table-Win
ON LEAVE OF int_solic_transf.nat_oper_transf IN FRAME f-main /* Nat Operaá∆o */
DO:
    FIND FIRST docum-est
        WHERE docum-est.serie-docto  = INPUT FRAME {&frame-name} int_solic_transf.serie_transf
        AND   docum-est.nro-docto    = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf
        AND   docum-est.cod-emitente = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
        AND   docum-est.nat-operacao = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
        NO-LOCK NO-ERROR.

    IF  AVAIL docum-est THEN
        ASSIGN int_solic_transf.cod_estab:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.cod-estabel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.nr_nota_transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.nr_nota_transf V-table-Win
ON LEAVE OF int_solic_transf.nr_nota_transf IN FRAME f-main /* Nota Fiscal Transf */
DO:
    FIND FIRST docum-est
        WHERE docum-est.serie-docto  = INPUT FRAME {&frame-name} int_solic_transf.serie_transf
        AND   docum-est.nro-docto    = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf
        AND   docum-est.cod-emitente = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
        AND   docum-est.nat-operacao = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
        NO-LOCK NO-ERROR.

    IF  AVAIL docum-est THEN
        ASSIGN int_solic_transf.cod_estab:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.cod-estabel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.num_bem_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_bem_pat V-table-Win
ON ENTRY OF int_solic_transf.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
    ASSIGN v_observ:SCREEN-VALUE IN FRAME {&frame-name} = "".

    FIND LAST int_solic_transf NO-LOCK NO-ERROR.

    IF  AVAIL int_solic_transf THEN
        ASSIGN v_num_solic = int_solic_transf.num_solicitacao + 1.
    ELSE
        ASSIGN v_num_solic = 1.

    ASSIGN int_solic_transf.num_solicitacao:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_num_solic).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_bem_pat V-table-Win
ON F5 OF int_solic_transf.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_bem_pat V-table-Win
ON LEAVE OF int_solic_transf.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
    FIND FIRST bem_pat
        WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
        AND   bem_pat.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
        AND   bem_pat.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
        AND   bem_pat.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
        NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN DO:
        IF  DAY(TODAY) > 25 THEN DO:
            ASSIGN v_dat_transf = DATE((IF MONTH(TODAY) = 12 THEN 01
                                        ELSE MONTH(TODAY) + 1),
                                        01,
                                        IF MONTH(TODAY) = 12 THEN YEAR(TODAY) + 1
                                        ELSE YEAR(TODAY)).
            
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_dat_transf).
        END.
        ELSE
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").

        ASSIGN int_solic_transf.cod_est_ori:SCREEN-VALUE                     IN FRAME {&frame-name} = bem_pat.cod_estab
               /*int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = bem_pat.cod_estab*/
               int_solic_transf.cod_ccus_ori:SCREEN-VALUE                    IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons
               /*int_solic_transf.cod_ccusto:SCREEN-VALUE      IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons*/
               int_solic_transf.cod_unid_neg_ori:SCREEN-VALUE                IN FRAME {&frame-name} = bem_pat.cod_unid_negoc
               /*int_solic_transf.cod_unid_negoc:SCREEN-VALUE  IN FRAME {&frame-name} = bem_pat.cod_unid_negoc*/
               int_solic_transf.cod_usuar_solic:SCREEN-VALUE IN FRAME {&frame-name} = v_cod_usuar_corren
               v_observ:SCREEN-VALUE                         IN FRAME {&frame-name} = ""
               v_descricao:SCREEN-VALUE                      IN FRAME {&frame-name} = bem_pat.des_bem_pat.

        IF  PROGRAM-NAME(1) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(2) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(3) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(4) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(5) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(6) MATCHES "*re1001*" THEN DO:
            FIND FIRST docum-est
                WHERE RECID(docum-est) = r-doc-entrada NO-LOCK NO-ERROR.

            IF  AVAIL docum-est THEN
                ASSIGN int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = docum-est.serie-docto
                       int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = docum-est.nro-docto
                       int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = string(docum-est.cod-emitente)
                       int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.nat-operacao
                       int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = docum-est.cod-estabel.
        END.
        ELSE
            ASSIGN r-doc-entrada                                                        = ?
                   int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = ""
                   int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = ""
                   int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = ""
                   int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_bem_pat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.num_seq_bem_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_seq_bem_pat V-table-Win
ON F5 OF int_solic_transf.num_seq_bem_pat IN FRAME f-main /* Sequància */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_seq_bem_pat V-table-Win
ON LEAVE OF int_solic_transf.num_seq_bem_pat IN FRAME f-main /* Sequància */
DO:

    FIND FIRST bem_pat
        WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
        AND   bem_pat.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
        AND   bem_pat.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
        AND   bem_pat.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
        NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN DO:
        IF  DAY(TODAY) > 25 THEN DO:
            ASSIGN v_dat_transf = DATE((IF MONTH(TODAY) = 12 THEN 01
                                        ELSE MONTH(TODAY) + 1),
                                        01,
                                        IF MONTH(TODAY) = 12 THEN YEAR(TODAY) + 1
                                        ELSE YEAR(TODAY)).
            
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_dat_transf).
        END.
        ELSE
            ASSIGN int_solic_transf.dat_transf:SCREEN-VALUE IN FRAME {&frame-name} = STRING(TODAY,"99/99/9999").

        ASSIGN int_solic_transf.cod_est_ori:SCREEN-VALUE                     IN FRAME {&frame-name} = bem_pat.cod_estab
               /*int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = bem_pat.cod_estab*/
               int_solic_transf.cod_ccus_ori:SCREEN-VALUE                    IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons
               /*int_solic_transf.cod_ccusto:SCREEN-VALUE      IN FRAME {&frame-name} = bem_pat.cod_ccusto_respons*/
               int_solic_transf.cod_unid_neg_ori:SCREEN-VALUE                IN FRAME {&frame-name} = bem_pat.cod_unid_negoc
               /*int_solic_transf.cod_unid_negoc:SCREEN-VALUE  IN FRAME {&frame-name} = bem_pat.cod_unid_negoc*/
               int_solic_transf.cod_usuar_solic:SCREEN-VALUE IN FRAME {&frame-name} = v_cod_usuar_corren
               v_observ:SCREEN-VALUE                         IN FRAME {&frame-name} = ""
               v_descricao:SCREEN-VALUE                      IN FRAME {&frame-name} = bem_pat.des_bem_pat.

        IF  PROGRAM-NAME(1) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(2) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(3) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(4) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(5) MATCHES "*re1001*" 
        OR  PROGRAM-NAME(6) MATCHES "*re1001*" THEN DO:
            FIND FIRST docum-est
                WHERE RECID(docum-est) = r-doc-entrada NO-LOCK NO-ERROR.

            IF  AVAIL docum-est THEN
                ASSIGN int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = docum-est.serie-docto
                       int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = docum-est.nro-docto
                       int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = string(docum-est.cod-emitente)
                       int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.nat-operacao
                       int_solic_transf.cod_estab:SCREEN-VALUE       IN FRAME {&frame-name} = docum-est.cod-estabel.
        END.
        ELSE
            ASSIGN r-doc-entrada                                                        = ?
                   int_solic_transf.serie_transf:SCREEN-VALUE    IN FRAME {&frame-name} = ""
                   int_solic_transf.nr_nota_transf:SCREEN-VALUE  IN FRAME {&frame-name} = ""
                   int_solic_transf.emitente_transf:SCREEN-VALUE IN FRAME {&frame-name} = ""
                   int_solic_transf.nat_oper_transf:SCREEN-VALUE IN FRAME {&frame-name} = "".
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "O bem informado n∆o foi localizado !").

        APPLY "ENTRY":U TO int_solic_transf.cod_cta_pat IN FRAME {&frame-name}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.num_seq_bem_pat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_solic_transf.num_seq_bem_pat IN FRAME f-main /* Sequància */
DO:
    ASSIGN v_rec_bem_pat = ?.
    
    RUN esp/fas/esfas016-z02.p.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.

    IF  AVAIL bem_pat THEN
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = bem_pat.cod_cta_pat
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = string(bem_pat.num_bem_pat)
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN int_solic_transf.cod_cta_pat:SCREEN-VALUE     IN FRAME {&frame-name} = ""
               int_solic_transf.num_bem_pat:SCREEN-VALUE     IN FRAME {&frame-name} = "0"
               int_solic_transf.num_seq_bem_pat:SCREEN-VALUE IN FRAME {&frame-name} = "0".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_solic_transf.serie_transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.serie_transf V-table-Win
ON F5 OF int_solic_transf.serie_transf IN FRAME f-main /* SÇrie Transf */
DO:

      {include/zoomvar.i &prog-zoom="inzoom/z01in090.w"
                         &campo="int_solic_transf.emitente_transf"
                         &campozoom="cod-emitente"
                         &frame="f-main"
                         &campo2="int_solic_transf.serie_transf"
                         &campozoom2="serie-docto"
                         &frame2="f-main"
                         &campo3="int_solic_transf.nr_nota_transf"
                         &campozoom3="nro-docto"
                         &frame3="f-main"
                         &campo4="int_solic_transf.nat_oper_transf"
                         &campozoom4="nat-operacao"
                         &frame4="f-main"}

    /*
    {method/zoomfields.i &ProgramZoom="inzoom/z13in090.w"
                         &FieldZoom1="cod-emitente"
                         &FieldScreen1="int_solic_transf.emitente_transf"
                         &Frame1="fPage0"
                         &FieldZoom2="serie-docto"
                         &FieldScreen2="int_solic_transf.serie_transf"
                         &Frame2="fPage0"
                         &FieldZoom3="nro-docto"
                         &FieldScreen3="int_solic_transf.nr_nota_transf"
                         &Frame3="fPage0"                                                  
                         &FieldZoom4="nat-operacao"
                         &FieldScreen4="int_solic_transf.nat_oper_transf"
                         &Frame4="fPage0"
                         &RunMethod="run setParameters in hProgramZoom( yes )." /*--- doctos atualizados ---*/
                         &EnableImplant="NO"}  
                         */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_solic_transf.serie_transf V-table-Win
ON LEAVE OF int_solic_transf.serie_transf IN FRAME f-main /* SÇrie Transf */
DO:
  
    FIND FIRST docum-est
        WHERE docum-est.serie-docto  = INPUT FRAME {&frame-name} int_solic_transf.serie_transf
        AND   docum-est.nro-docto    = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf
        AND   docum-est.cod-emitente = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
        AND   docum-est.nat-operacao = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
        NO-LOCK NO-ERROR.

    IF  AVAIL docum-est THEN
        ASSIGN int_solic_transf.cod_estab:SCREEN-VALUE IN FRAME {&frame-name} = docum-est.cod-estabel.

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

int_solic_transf.cod_cta_pat:LOAD-MOUSE-POINTER('image/lupa.cur')      IN FRAME {&FRAME-NAME}.
int_solic_transf.num_bem_pat:LOAD-MOUSE-POINTER('image/lupa.cur')      IN FRAME {&FRAME-NAME}.
int_solic_transf.num_seq_bem_pat:LOAD-MOUSE-POINTER('image/lupa.cur')  IN FRAME {&FRAME-NAME}.
int_solic_transf.cod_estab:LOAD-MOUSE-POINTER('image/lupa.cur')        IN FRAME {&FRAME-NAME}.
int_solic_transf.cod_unid_negoc:LOAD-MOUSE-POINTER('image/lupa.cur')   IN FRAME {&FRAME-NAME}.
int_solic_transf.cod_ccusto:LOAD-MOUSE-POINTER('image/lupa.cur')       IN FRAME {&FRAME-NAME}.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "int_solic_transf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int_solic_transf"}

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
     if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
     
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    {include/i-valid.i}
    
    RUN pi-validate.
    
    if RETURN-VALUE = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    ASSIGN v_aux_observ = INPUT FRAME {&frame-name} v_observ.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN entry(1,int_solic_transf.des_historico,";") = v_aux_observ
           int_solic_transf.ind_aprovac                = "Pendente"
           int_solic_transf.cod_usuar_super            = int-centro-custo.cod_usuario
           int_solic_transf.cod_usuar_solic            = v_cod_usuar_corren.
         /*int_solic_transf.cod_ccus_ori               = INPUT FRAME {&frame-name} v_ccusto_orig
           int_solic_transf.cod_est_ori                = INPUT FRAME {&frame-name} v_estab_orig
           int_solic_transf.cod_unid_neg_ori           = INPUT FRAME {&frame-name} v_unid_negoc_orig.*/


    IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab      = INPUT FRAME {&frame-name} int_solic_transf.cod_est_ori
    AND INPUT FRAME {&frame-name} int_solic_transf.cod_unid_negoc = INPUT FRAME {&frame-name} int_solic_transf.cod_unid_neg_ori THEN
        ASSIGN int_solic_transf.cod_motiv_desmob = "TRI".
    ELSE
        ASSIGN int_solic_transf.cod_motiv_desmob = "TRA".

    IF   int_solic_transf.cod_cta_pat <> "BENFEITORIA TERCER" 
    AND  int_solic_transf.cod_cta_pat <> "LOCACAO (12 MESES)" 
    AND  int_solic_transf.cod_cta_pat <> "LOCACAO (24 MESES)"
    AND  int_solic_transf.cod_cta_pat <> "LOCACAO (36 MESES)"
    AND  int_solic_transf.cod_cta_pat <> "LOCACAO (48 MESES)"
    AND  int_solic_transf.cod_cta_pat <> "LOCACAO (60 MESES)"
    AND  int_solic_transf.cod_cta_pat <> "PROJ. ANDAM. INTAN"
    AND  int_solic_transf.cod_cta_pat <> "PROJETOS EM ANDAME"
    AND  int_solic_transf.cod_cta_pat <> "VEICULOS" THEN DO:

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "101" THEN
            ASSIGN int_solic_transf.cod_localiz = "PATRIMONIO".

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "103" THEN
            ASSIGN int_solic_transf.cod_localiz = "MAXCOM".

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "104" THEN
            ASSIGN int_solic_transf.cod_localiz = "SERTAO".

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "105" THEN
            ASSIGN int_solic_transf.cod_localiz = "MANAUS".

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "107" THEN
            ASSIGN int_solic_transf.cod_localiz = "PALHOCA".

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab = "109" THEN
            ASSIGN int_solic_transf.cod_localiz = "DEPOSITO AM".
    END.
    ELSE
        ASSIGN int_solic_transf.cod_localiz = "".

    RUN pi_envia_email_solic.
    RUN pi_envia_email_super.

    IF  PROGRAM-NAME(1) MATCHES "*re1001*" 
    OR  PROGRAM-NAME(2) MATCHES "*re1001*" 
    OR  PROGRAM-NAME(3) MATCHES "*re1001*" 
    OR  PROGRAM-NAME(4) MATCHES "*re1001*" 
    OR  PROGRAM-NAME(5) MATCHES "*re1001*" 
    OR  PROGRAM-NAME(6) MATCHES "*re1001*" THEN
        ASSIGN r-doc-entrada = ?.

    MESSAGE "Solicitaá∆o registrada com sucesso !!!" SKIP(1)
            "Vocà receber† um e-mail com o n£mero da solicitaá∆o e tambÇm ser† notificado" SKIP
            "por e-mail quando ocorrer a aprovaá∆o ou reprovaá∆o da transferància."
            VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF  AVAIL int_solic_transf
AND int_solic_transf.ind_aprovac <> "Pendente" THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Somente solicitaá‰es pendentes poder∆o ser exclu°das !").

    RETURN 'ADM-ERROR':U.
END.

/* Dispatch standard ADM method.                             */
RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
    
    disable v_observ with frame {&frame-name}.
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

    ENABLE v_observ with frame {&frame-name}.

    DISABLE int_solic_transf.num_solicitacao with frame {&frame-name}.

    if  adm-new-record = NO THEN
        DISABLE int_solic_transf.cod_cta_pat
                int_solic_transf.num_bem_pat
                int_solic_transf.num_seq_bem_pat
                int_solic_transf.num_solicitacao 
                with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN v_observ:SCREEN-VALUE IN FRAME {&frame-name} = entry(1,int_solic_transf.des_historico,";") WHEN AVAIL int_solic_transf.

  IF  AVAIL int_solic_transf THEN DO:

      FIND FIRST bem_pat
          WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
          AND   bem_pat.cod_cta_pat     = int_solic_transf.cod_cta_pat
          AND   bem_pat.num_bem_pat     = int_solic_transf.num_bem_pat
          AND   bem_pat.num_seq_bem_pat = int_solic_transf.num_seq_bem_pat NO-LOCK NO-ERROR.

      IF  AVAIL bem_pat THEN DO:
          ASSIGN /*int_solic_transf.cod_est_ori:SCREEN-VALUE      IN FRAME {&frame-name} = int_solic_transf.cod_est_ori      
                 v_ccusto_orig:SCREEN-VALUE     IN FRAME {&frame-name} = int_solic_transf.cod_ccus_ori     
                 v_unid_negoc_orig:SCREEN-VALUE IN FRAME {&frame-name} = int_solic_transf.cod_unid_neg_ori */
                 v_descricao:SCREEN-VALUE       IN FRAME {&frame-name} = bem_pat.des_bem_pat.
                 
      END.
  END.

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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i}

    if  adm-new-record = YES THEN DO:
        FIND FIRST int_solic_transf
            WHERE int_solic_transf.num_solicitacao = INPUT FRAME {&frame-name} int_solic_transf.num_solicitacao
            AND   int_solic_transf.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
            AND   int_solic_transf.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
            AND   int_solic_transf.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
            NO-LOCK NO-ERROR.
    
        IF   AVAIL int_solic_transf THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "J† existe solicitaá∆o com este c¢digo para este bem !").
    
            APPLY "ENTRY":U TO int_solic_transf.num_solicitacao IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.

        FIND FIRST int_solic_transf
            WHERE int_solic_transf.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
            AND   int_solic_transf.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
            AND   int_solic_transf.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
            AND   int_solic_transf.ind_aprovac     = "Pendente" NO-LOCK NO-ERROR.
    
        IF   AVAIL int_solic_transf THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "J† existe solicitaá∆o de transferància pendente para o bem informado !").
    
            APPLY "ENTRY":U TO int_solic_transf.num_solicitacao IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.
    END.
    ELSE DO:
        IF  AVAIL int_solic_transf
        AND int_solic_transf.ind_aprovac <> "Pendente" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Somente solicitaá‰es pendentes poder∆o ser alteradas !").

            APPLY "ENTRY":U TO int_solic_transf.dat_transf IN FRAME {&frame-name}.
    
            RETURN 'ADM-ERROR':U.
        END.
    END.

    ASSIGN v_dat_aux = INPUT FRAME {&frame-name} int_solic_transf.dat_transf.

    IF  DAY(TODAY) > 25
    AND DAY(v_dat_aux) > 25 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Transferàncias efetuadas ap¢s o dia 25 somente poder∆o possuir data de transferància no primeiro dia do màs seguinte !").

        APPLY "ENTRY":U TO int_solic_transf.dat_transf IN FRAME {&frame-name}.

        RETURN 'ADM-ERROR':U.
    END.

    run pi_retornar_sit_movimen_modul (Input "FAS",
                                       Input v_cod_empres_usuar,
                                       Input v_dat_aux,
                                       Input "Habilitado",
                                       output v_cod_return_sit).

    if  not can-do(v_cod_return_sit, "Habilitado" ) then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Data de transferància informada em per°odo n∆o habilitado para o m¢dulo Ativo Fixo !").

        APPLY "ENTRY":U TO int_solic_transf.dat_transf IN FRAME {&frame-name}.
        RETURN 'ADM-ERROR':U.
    end.  

    FIND FIRST int-centro-custo
         WHERE int-centro-custo.cod-estabel    = INPUT FRAME {&frame-name} int_solic_transf.cod_estab
         AND   int-centro-custo.cc-codigo      = INPUT FRAME {&frame-name} int_solic_transf.cod_ccusto
         AND   int-centro-custo.cod-unid-negoc = INPUT FRAME {&frame-name} int_solic_transf.cod_unid_negoc NO-LOCK NO-ERROR.

    IF  NOT AVAIL int-centro-custo THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "N∆o localizado cadastro supervisor do centro de custo !").

        APPLY "ENTRY":U TO int_solic_transf.cod_ccusto IN FRAME {&frame-name}.
        RETURN 'ADM-ERROR':U.
    END.

    FIND FIRST bem_pat
        WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
        AND   bem_pat.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
        AND   bem_pat.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
        AND   bem_pat.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
        NO-LOCK NO-ERROR.

    IF  NOT AVAIL bem_pat THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "N∆o existe bem patrimonial com os dados informados !").

        APPLY "ENTRY":U TO int_solic_transf.cod_cta_pat IN FRAME {&frame-name}.
        RETURN 'ADM-ERROR':U.
    END.
    ELSE DO:
        IF  bem_pat.val_perc_bxa >= 100 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Bem totalmente baixado n∆o poder† ser transferido !").
    
            APPLY "ENTRY":U TO int_solic_transf.cod_cta_pat IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.

        IF  INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat   <> "EQUIP. ESTOQUE TIC"
        AND INPUT FRAME {&frame-name} int_solic_transf.cod_estab      = bem_pat.cod_estab
        AND INPUT FRAME {&frame-name} int_solic_transf.cod_ccusto     = bem_pat.cod_ccusto_respons
        AND INPUT FRAME {&frame-name} int_solic_transf.cod_unid_negoc = bem_pat.cod_unid_negoc THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Estabelecimento, Centro de Custo ou Unidade de Neg¢cio precisam ser alterados para que a solicitaá∆o seja inserida !").
    
            APPLY "ENTRY":U TO int_solic_transf.cod_cta_pat IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.
    END.

    IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab <> INPUT FRAME {&frame-name} int_solic_transf.cod_est_ori THEN DO:
        IF  int_solic_transf.nr_nota_transf:SCREEN-VALUE IN FRAME {&frame-name} = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Nota fiscal deve ser informada ao efetuar transferàncias entre estabelecimentos !").

            APPLY "ENTRY":U TO int_solic_transf.nr_nota_transf IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.

        FIND FIRST docum-est
            WHERE docum-est.serie-docto  = INPUT FRAME {&frame-name} int_solic_transf.serie_transf
            AND   docum-est.nro-docto    = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf
            AND   docum-est.cod-emitente = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
            AND   docum-est.nat-operacao = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
            NO-LOCK NO-ERROR.

        IF  NOT AVAIL docum-est THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Nota fiscal informada n∆o localizada !").

            APPLY "ENTRY":U TO int_solic_transf.nr_nota_transf IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.
        ELSE DO:
            RUN esp/es0018p.p (INPUT "esfas016", /* naturezas de transferencia de imobilizado */
                               INPUT 1,
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).

            IF  NOT CAN-FIND (FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Transferància n∆o permitida para notas com esta natureza de operaá∆o !").

                APPLY "ENTRY":U TO int_solic_transf.nr_nota_transf IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.
            END.

            if  adm-new-record = YES THEN DO:
    
                FIND FIRST int_solic_transf
                    WHERE int_solic_transf.serie_transf    = INPUT FRAME {&frame-name} int_solic_transf.serie_transf   
                    AND   int_solic_transf.nr_nota_transf  = INPUT FRAME {&frame-name} int_solic_transf.nr_nota_transf 
                    AND   int_solic_transf.emitente_transf = INPUT FRAME {&frame-name} int_solic_transf.emitente_transf
                    AND   int_solic_transf.nat_oper_transf = INPUT FRAME {&frame-name} int_solic_transf.nat_oper_transf
                    AND   int_solic_transf.cod_cta_pat     = INPUT FRAME {&frame-name} int_solic_transf.cod_cta_pat
                    AND   int_solic_transf.num_bem_pat     = INPUT FRAME {&frame-name} int_solic_transf.num_bem_pat
                    AND   int_solic_transf.num_seq_bem_pat = INPUT FRAME {&frame-name} int_solic_transf.num_seq_bem_pat
                    AND   int_solic_transf.ind_aprovac     = "Pendente" 
                    NO-LOCK NO-ERROR.
            
                IF   AVAIL int_solic_transf THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "J† existe solicitaá∆o com status Pendente para este bem vinculada a mesma Nota !").
            
                    APPLY "ENTRY":U TO int_solic_transf.num_solicitacao IN FRAME {&frame-name}.
                    RETURN 'ADM-ERROR':U.
                END.
            END.

            IF  INPUT FRAME {&frame-name} int_solic_transf.cod_estab <> docum-est.cod-estabel THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Estabelecimento de transferància n∆o pode ser diferente do estabelecimento da nota !").

                APPLY "ENTRY":U TO int_solic_transf.cod_estab IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.
            END.
        END.
    END.

    FIND FIRST cc_uni_estab 
        WHERE cc_uni_estab.cod_ccusto     = INPUT FRAME {&frame-name} int_solic_transf.cod_ccusto
        AND   cc_uni_estab.cod_estab      = INPUT FRAME {&frame-name} int_solic_transf.cod_estab 
        AND   cc_uni_estab.cod_unid_negoc = INPUT FRAME {&frame-name} int_solic_transf.cod_unid_negoc NO-LOCK NO-ERROR.

    IF  NOT AVAIL cc_uni_estab THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "N∆o encontrado relacionamento centro de custo x estabelecimento x unidade de negocio !").

        APPLY "ENTRY":U TO int_solic_transf.cod_estab IN FRAME {&frame-name}.
        RETURN 'ADM-ERROR':U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_envia_email_solic V-table-Win 
PROCEDURE pi_envia_email_solic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-utapi019  AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
    END.
    ASSIGN v_remetente = IF usuar_mestre.cod_e_mail_local = "" THEN "ems@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.

    ASSIGN v_destino = v_remetente.

    IF  v_destino = "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
    END.
    ELSE DO:

        FIND FIRST cta_pat
            WHERE cta_pat.cod_empresa = v_cod_empres_usuar
            AND   cta_pat.cod_cta_pat = int_solic_transf.cod_cta_pat NO-LOCK NO-ERROR.

        IF  AVAIL cta_pat THEN
            ASSIGN v_cod_cta_pat = cta_pat.des_cta_pat.
        ELSE
            ASSIGN v_cod_cta_pat = int_solic_transf.cod_cta_pat.

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.destino           = v_destino
               tt-envio2.remetente         = v_remetente
               tt-envio2.copia             = ""
               tt-envio2.assunto           = "SOLICITAÄ«O DE TRANSFER“NCIA DE BENS NÈMERO: " + STRING(int_solic_transf.num_solicitacao)
               tt-envio2.arq-anexo         = ""
               tt-envio2.formato           = "TEXTO".
    
        ASSIGN v_msg_mail = "Prezado(a)," + CHR(10) + CHR(10) +
                            "A solicitaá∆o de transferància de bens foi registrada atravÇs do n£mero " + STRING(int_solic_transf.num_solicitacao) + " ." + CHR(10) + 
                            "Quando a controladoria concluir a solicitaá∆o vocà receber† um novo e-mail." + CHR(10) + CHR(10).
    
        ASSIGN v_msg_mail = v_msg_mail               + 
                            "Conta Patrimonial: "    + v_cod_cta_pat                                          + chr(10) +
                            "Bem Patrimonial: "      + STRING(int_solic_transf.num_bem_pat)                   + chr(10) +
                            "Sequància: "            + STRING(int_solic_transf.num_seq_bem_pat)               + chr(10) +
                            "Dt Transferància: "     + STRING(date(int_solic_transf.dat_transf),"99/99/9999") + chr(10) + 
                            "Observaá∆o: "           + entry(1,int_solic_transf.des_historico,";")            + chr(10) + chr(10) +
                            /*"Teste - email destino: " + v_destino + chr(10) + chr(10) +*/
                            "Atenciosamente,"                                                                 + chr(10) +
                            "Intelbras S.A.".
    
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = v_msg_mail.
       
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
    
        FOR EACH tt-erros:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
        END.
    
        IF  VALID-HANDLE(h-utapi019) THEN 
            DELETE PROCEDURE h-utapi019.
    
        ASSIGN h-utapi019 = ?.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_envia_email_super V-table-Win 
PROCEDURE pi_envia_email_super :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-utapi019  AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
    END.
    ASSIGN v_remetente = IF usuar_mestre.cod_e_mail_local = "" THEN "ems@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = int_solic_transf.cod_usuar_super:
    END.
    ASSIGN v_destino = usuar_mestre.cod_e_mail_local.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = int_solic_transf.cod_usuar_solic:
    END.
    ASSIGN v_nome_usuar = usuar_mestre.nom_usuario.

    FIND FIRST bem_pat
        WHERE bem_pat.cod_empresa     = v_cod_empres_usuar
        AND   bem_pat.cod_cta_pat     = int_solic_transf.cod_cta_pat
        AND   bem_pat.num_bem_pat     = int_solic_transf.num_bem_pat
        AND   bem_pat.num_seq_bem_pat = int_solic_transf.num_seq_bem_pat NO-LOCK NO-ERROR.

    IF  v_destino = "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
    END.
    ELSE DO:
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.destino           = v_destino
               tt-envio2.remetente         = v_remetente
               tt-envio2.copia             = ""
               tt-envio2.assunto           = "SOLICITAÄ«O DE TRANSFER“NCIA DE IMOBILIZADO - " + int_solic_transf.cod_cta_pat         + "/" 
                                                                                              + string(int_solic_transf.num_bem_pat) + "/" 
                                                                                              + STRING(int_solic_transf.num_seq_bem_pat)
               tt-envio2.arq-anexo         = ""
               tt-envio2.formato           = "TEXTO".
    
        ASSIGN v_msg_mail = "Prezado(a)," + CHR(10) + CHR(10) +
                            "O(a) colaborador(a) " + v_nome_usuar + " solicitou a transferància de um bem para o Centro de Custo " + int_solic_transf.cod_ccusto + " ." + CHR(10) + CHR(10).
    
        ASSIGN v_msg_mail = v_msg_mail                + 
                            "N£mero da Solicitaá∆o: " + string(int_solic_transf.num_solicitacao)                                                                                 + chr(10) +
                            "Estabelecimento de origem do bem: " + bem_pat.cod_estab                                                                                             + chr(10) +
                            "Estabelecimento para onde o bem ser† transferido: " + int_solic_transf.cod_estab                                                                    + chr(10) +
                            "Centro de custo para onde o bem ser† transferido: " + int_solic_transf.cod_ccusto                                                                   + chr(10) +
                            "Patrimonio: " + STRING(int_solic_transf.num_bem_pat) + " - Sequància: " + STRING(int_solic_transf.num_seq_bem_pat)                                  + chr(10) +
                            "Descriá∆o: " + bem_pat.des_bem_pat                                                                                                                  + chr(10) +
                            "NF de transferància (aplicavÇl apenas quando a transferància for entre estabelecimentos diferentes): " + int_solic_transf.nr_nota_transf  + chr(10) + chr(10) +
                            "Observaá∆o: " + entry(1,int_solic_transf.des_historico,";")                                                                                         + chr(10) + chr(10) +
                            "Caso n∆o concorde com esta transferància, favor entrar em contato com a †rea Fiscal nos e-mails grupo.fiscal@intelbras.com.br ou servicos.fiscal@intelbras.com.br . "   + chr(10) + chr(10) +
                            /*"Teste - email destino: " + v_destino + chr(10) + chr(10) +*/
                            "Atenciosamente,"                                                                                                                                    + chr(10) +
                            "Intelbras S.A.".
    
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = v_msg_mail.
       
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
    
        FOR EACH tt-erros:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
        END.
    
        IF  VALID-HANDLE(h-utapi019) THEN 
            DELETE PROCEDURE h-utapi019.
    
        ASSIGN h-utapi019 = ?.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_retornar_sit_movimen_modul V-table-Win 
PROCEDURE pi_retornar_sit_movimen_modul :
def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_unid_organ
        as Character
        format "x(5)"
        no-undo.
    def Input param p_dat_refer_sit
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_des_sit_movimen_ent
        as character
        format "x(40)"
        no-undo.
    def output param p_des_sit_movimen_mod
        as character
        format "x(40)"
        no-undo.


    assign p_des_sit_movimen_mod = "".
    situacao:
    for each sit_movimen_modul no-lock
     where sit_movimen_modul.cod_modul_dtsul = p_cod_modul_dtsul
       and sit_movimen_modul.cod_unid_organ = p_cod_unid_organ
       and sit_movimen_modul.dat_inic_sit_movimen <= p_dat_refer_sit
       and sit_movimen_modul.dat_fim_sit_movimen >= p_dat_refer_sit :
        if  p_des_sit_movimen_mod = ""
        then do:
            assign p_des_sit_movimen_mod = sit_movimen_modul.ind_sit_movimen.
        end.
        else do:
            assign p_des_sit_movimen_mod = p_des_sit_movimen_mod + "," + sit_movimen_modul.ind_sit_movimen.
        end.
    end.

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
  {src/adm/template/snd-list.i "int_solic_transf"}

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

