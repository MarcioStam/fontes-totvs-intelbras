&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_int_param_alatur NO-UNDO LIKE int_param_alatur.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i tela 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{utp/ut-glob.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
def new global shared var h-facelift as handle no-undo.
DEF VAR i-folder AS INTEGER INIT 1 NO-UNDO.

def new global shared var v_rec_tip_fluxo_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def new global shared var v_rec_estabelecimento 
    as recid 
    format ">>>>>>9":U 
    no-undo. 

def new global shared var v_rec_cta_ctbl_integr
    as recid 
    format ">>>>>>9":U 
    no-undo. 

def new global shared var v_rec_usuar_financ_estab_apb
    as recid 
    format ">>>>>>9":U 
    no-undo. 

def new global shared var v_rec_espec_docto
    as recid 
    format ">>>>>>9":U 
    no-undo. 

def new global shared var v_rec_portador
    as recid 
    format ">>>>>>9":U 
    no-undo. 

def new global shared var v_rec_forma_pagto
    as recid 
    format ">>>>>>9":U 
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_int_param_alatur

/* Definitions for FRAME fPage1                                         */
&Scoped-define FIELDS-IN-QUERY-fPage1 ~
tt_int_param_alatur.dat_inicio_integracao ~
tt_int_param_alatur.log_integra_an tt_int_param_alatur.log_integra_pc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fPage1 ~
tt_int_param_alatur.dat_inicio_integracao ~
tt_int_param_alatur.log_integra_an tt_int_param_alatur.log_integra_pc 
&Scoped-define ENABLED-TABLES-IN-QUERY-fPage1 tt_int_param_alatur
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fPage1 tt_int_param_alatur
&Scoped-define QUERY-STRING-fPage1 FOR EACH tt_int_param_alatur SHARE-LOCK
&Scoped-define OPEN-QUERY-fPage1 OPEN QUERY fPage1 FOR EACH tt_int_param_alatur SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fPage1 tt_int_param_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-fPage1 tt_int_param_alatur


/* Definitions for FRAME fPage2                                         */
&Scoped-define FIELDS-IN-QUERY-fPage2 tt_int_param_alatur.cod_estab_ad ~
tt_int_param_alatur.cod_espec_docto_ad tt_int_param_alatur.cod_ser_docto_ad ~
tt_int_param_alatur.cod_portador_ad ~
tt_int_param_alatur.cod_tip_fluxo_financ_ad ~
tt_int_param_alatur.cod_unid_negoc_ad ~
tt_int_param_alatur.num_dias_integra_ad ~
tt_int_param_alatur.num_dias_vencto_ad ~
tt_int_param_alatur.cod_email_integracao_ad ~
tt_int_param_alatur.cod_param_ad tt_int_param_alatur.cod_param_ad_viagem tt_int_param_alatur.cod_ser_docto_rot
&Scoped-define ENABLED-FIELDS-IN-QUERY-fPage2 ~
tt_int_param_alatur.cod_estab_ad tt_int_param_alatur.cod_espec_docto_ad ~
tt_int_param_alatur.cod_ser_docto_ad tt_int_param_alatur.cod_portador_ad ~
tt_int_param_alatur.cod_tip_fluxo_financ_ad ~
tt_int_param_alatur.cod_unid_negoc_ad ~
tt_int_param_alatur.num_dias_integra_ad ~
tt_int_param_alatur.num_dias_vencto_ad ~
tt_int_param_alatur.cod_email_integracao_ad ~
tt_int_param_alatur.cod_param_ad tt_int_param_alatur.cod_param_ad_viagem tt_int_param_alatur.cod_ser_docto_rot
&Scoped-define ENABLED-TABLES-IN-QUERY-fPage2 tt_int_param_alatur
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fPage2 tt_int_param_alatur
&Scoped-define QUERY-STRING-fPage2 FOR EACH tt_int_param_alatur SHARE-LOCK
&Scoped-define OPEN-QUERY-fPage2 OPEN QUERY fPage2 FOR EACH tt_int_param_alatur SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fPage2 tt_int_param_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-fPage2 tt_int_param_alatur


/* Definitions for FRAME fpage3                                         */
&Scoped-define FIELDS-IN-QUERY-fpage3 tt_int_param_alatur.cod_estab_cr ~
tt_int_param_alatur.cod_espec_docto_cr tt_int_param_alatur.cod_ser_docto_cr ~
tt_int_param_alatur.cod_tip_fluxo_financ_cr ~
tt_int_param_alatur.cod_unid_negoc_cr tt_int_param_alatur.cod_cta_ctbl_cr ~
tt_int_param_alatur.num_dias_integra_cr ~
tt_int_param_alatur.num_dias_vencto_cr ~
tt_int_param_alatur.cod_email_integracao_cr ~
tt_int_param_alatur.cod_param_ad_cr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fpage3 ~
tt_int_param_alatur.cod_estab_cr tt_int_param_alatur.cod_espec_docto_cr ~
tt_int_param_alatur.cod_ser_docto_cr ~
tt_int_param_alatur.cod_tip_fluxo_financ_cr ~
tt_int_param_alatur.cod_unid_negoc_cr tt_int_param_alatur.cod_cta_ctbl_cr ~
tt_int_param_alatur.num_dias_integra_cr ~
tt_int_param_alatur.num_dias_vencto_cr ~
tt_int_param_alatur.cod_email_integracao_cr ~
tt_int_param_alatur.cod_param_ad_cr 
&Scoped-define ENABLED-TABLES-IN-QUERY-fpage3 tt_int_param_alatur
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fpage3 tt_int_param_alatur
&Scoped-define QUERY-STRING-fpage3 FOR EACH tt_int_param_alatur SHARE-LOCK
&Scoped-define OPEN-QUERY-fpage3 OPEN QUERY fpage3 FOR EACH tt_int_param_alatur SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fpage3 tt_int_param_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-fpage3 tt_int_param_alatur


/* Definitions for FRAME fPage4                                         */
&Scoped-define FIELDS-IN-QUERY-fPage4 ~
tt_int_param_alatur.cod_espec_docto_pc tt_int_param_alatur.cod_ser_docto_pc ~
tt_int_param_alatur.cod_portador_pc ~
tt_int_param_alatur.cod_tip_fluxo_financ_pc ~
tt_int_param_alatur.cod_forma_pagto_pc ~
tt_int_param_alatur.num_dias_integra_pc ~
tt_int_param_alatur.num_dias_vencto_pc ~
tt_int_param_alatur.cod_email_integracao_pc ~
tt_int_param_alatur.cod_param_pc tt_int_param_alatur.cod_param_pc_ad ~
tt_int_param_alatur.cod_param_pc_ad_viagem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fPage4 ~
tt_int_param_alatur.cod_espec_docto_pc tt_int_param_alatur.cod_ser_docto_pc ~
tt_int_param_alatur.cod_portador_pc ~
tt_int_param_alatur.cod_tip_fluxo_financ_pc ~
tt_int_param_alatur.cod_forma_pagto_pc ~
tt_int_param_alatur.num_dias_integra_pc ~
tt_int_param_alatur.num_dias_vencto_pc ~
tt_int_param_alatur.cod_email_integracao_pc ~
tt_int_param_alatur.cod_param_pc tt_int_param_alatur.cod_param_pc_ad ~
tt_int_param_alatur.cod_param_pc_ad_viagem 
&Scoped-define ENABLED-TABLES-IN-QUERY-fPage4 tt_int_param_alatur
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fPage4 tt_int_param_alatur
&Scoped-define QUERY-STRING-fPage4 FOR EACH tt_int_param_alatur SHARE-LOCK
&Scoped-define OPEN-QUERY-fPage4 OPEN QUERY fPage4 FOR EACH tt_int_param_alatur SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fPage4 tt_int_param_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-fPage4 tt_int_param_alatur


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button folder-1 folder-2 folder-3 ~
folder-4 bt-exit bt-ok bt-cancela bt-historico 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-GO 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 7.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-historico AUTO-GO 
     LABEL "&Hist¢rico" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 7.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Salvar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 7.

DEFINE IMAGE folder-1
     FILENAME "image\ts-up110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-2
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-3
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-4
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 120.29 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-124
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 7.5.

DEFINE RECTANGLE RECT-125
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 7.5.

DEFINE RECTANGLE RECT-126
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 7.5.

DEFINE RECTANGLE RECT-127
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 7.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY fPage1 FOR 
      tt_int_param_alatur SCROLLING.

DEFINE QUERY fPage2 FOR 
      tt_int_param_alatur SCROLLING.

DEFINE QUERY fpage3 FOR 
      tt_int_param_alatur SCROLLING.

DEFINE QUERY fPage4 FOR 
      tt_int_param_alatur SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-exit AT ROW 1.17 COL 116.14
     bt-ok AT ROW 12.33 COL 1.43
     bt-cancela AT ROW 12.33 COL 12 WIDGET-ID 162
     bt-historico AT ROW 12.33 COL 111.86 WIDGET-ID 160
     "Geral" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 2.71 COL 2.86
          BGCOLOR 8 FONT 7
     "Presta‡Æo Contas" VIEW-AS TEXT
          SIZE 14.29 BY .67 AT ROW 2.67 COL 49.72 WIDGET-ID 166
          BGCOLOR 8 FONT 7
     "Adiantamento" VIEW-AS TEXT
          SIZE 13.72 BY .67 AT ROW 2.67 COL 18.29
          BGCOLOR 8 FONT 7
     "CartÆo de Cr‚dito" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 2.67 COL 34
          BGCOLOR 8 FONT 7
     rt-button AT ROW 1.04 COL 1.72
     folder-1 AT ROW 2.5 COL 1.29
     folder-2 AT ROW 2.5 COL 17
     folder-3 AT ROW 2.5 COL 32.72
     folder-4 AT ROW 2.5 COL 48.43 WIDGET-ID 164
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121.57 BY 12.75
         BGCOLOR 15 .

DEFINE FRAME fPage1
     tt_int_param_alatur.dat_inicio_integracao AT ROW 2.25 COL 15 COLON-ALIGNED WIDGET-ID 4
          LABEL "Inicio Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt_int_param_alatur.log_integra_an AT ROW 3.33 COL 17 WIDGET-ID 6
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     tt_int_param_alatur.log_integra_pc AT ROW 4.33 COL 17 WIDGET-ID 8
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     "Geral" VIEW-AS TEXT
          SIZE 4.86 BY .54 AT ROW 1.33 COL 3.14 WIDGET-ID 12
     RECT-124 AT ROW 1.58 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 3.71
         SIZE 120 BY 8.38
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fPage2
     tt_int_param_alatur.cod_estab_ad AT ROW 2.25 COL 17.57 COLON-ALIGNED WIDGET-ID 18
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_espec_docto_ad AT ROW 3.25 COL 17.57 COLON-ALIGNED WIDGET-ID 16
          LABEL "Esp‚cie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_ser_docto_ad AT ROW 4.25 COL 17.57 COLON-ALIGNED WIDGET-ID 26
          LABEL "S‚rie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_portador_ad AT ROW 5.25 COL 17.57 COLON-ALIGNED WIDGET-ID 24
          LABEL "Portador"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_tip_fluxo_financ_ad AT ROW 6.25 COL 17.57 COLON-ALIGNED WIDGET-ID 28
          LABEL "Tipo Fluxo"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt_int_param_alatur.cod_unid_negoc_ad AT ROW 7.25 COL 17.57 COLON-ALIGNED WIDGET-ID 30
          LABEL "Unidade de Neg¢cio"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.num_dias_integra_ad AT ROW 2.25 COL 50.86 COLON-ALIGNED WIDGET-ID 32
          LABEL "Dias Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.num_dias_vencto_ad AT ROW 3.25 COL 50.86 COLON-ALIGNED WIDGET-ID 34
          LABEL "Dias Vencimento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.cod_email_integracao_ad AT ROW 4.25 COL 40.72 WIDGET-ID 14
          LABEL "Email Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_ad AT ROW 5.25 COL 50.86 COLON-ALIGNED WIDGET-ID 20
          LABEL "Parƒmetro AD"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_ad_viagem AT ROW 6.25 COL 50.86 COLON-ALIGNED WIDGET-ID 22
          LABEL "Parƒmetro AD Viagem"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_ser_docto_rot AT ROW 7.25 COL 50.86 COLON-ALIGNED WIDGET-ID 42
          LABEL "S‚rie AD Rotativo"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 5.5 COL 103 WIDGET-ID 38
          FGCOLOR 12 
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 6.5 COL 103 WIDGET-ID 40
          FGCOLOR 12 
     "Adiantamento" VIEW-AS TEXT
          SIZE 9.86 BY .54 AT ROW 1.33 COL 3.14 WIDGET-ID 12
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 4.5 COL 103 WIDGET-ID 36
          FGCOLOR 12 
     RECT-125 AT ROW 1.58 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 3.71
         SIZE 120 BY 8.42
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fpage3
     tt_int_param_alatur.cod_estab_cr AT ROW 2.25 COL 17.57 COLON-ALIGNED WIDGET-ID 20
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_espec_docto_cr AT ROW 3.25 COL 17.57 COLON-ALIGNED WIDGET-ID 18
          LABEL "Esp‚cie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_ser_docto_cr AT ROW 4.25 COL 17.57 COLON-ALIGNED WIDGET-ID 24
          LABEL "S‚rie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_tip_fluxo_financ_cr AT ROW 5.25 COL 17.57 COLON-ALIGNED WIDGET-ID 26
          LABEL "Fluxo Financeito"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt_int_param_alatur.cod_unid_negoc_cr AT ROW 6.25 COL 17.57 COLON-ALIGNED WIDGET-ID 28
          LABEL "Unidade de Neg¢cio"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_cta_ctbl_cr AT ROW 2.25 COL 50.86 COLON-ALIGNED WIDGET-ID 14
          LABEL "Conta Cont bil"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt_int_param_alatur.num_dias_integra_cr AT ROW 3.25 COL 50.86 COLON-ALIGNED WIDGET-ID 30
          LABEL "Dias Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.num_dias_vencto_cr AT ROW 4.25 COL 50.86 COLON-ALIGNED WIDGET-ID 32
          LABEL "Dias Vencimento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.cod_email_integracao_cr AT ROW 5.25 COL 48.43 WIDGET-ID 16
          LABEL "Email"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_ad_cr AT ROW 6.25 COL 50.86 COLON-ALIGNED WIDGET-ID 22
          LABEL "Parƒmetro AD Cr‚dito"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 5.5 COL 103 WIDGET-ID 40
          FGCOLOR 12 
     "CartÆo de Cr‚dito" VIEW-AS TEXT
          SIZE 12.86 BY .54 AT ROW 1.33 COL 3.14 WIDGET-ID 12
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 6.5 COL 103 WIDGET-ID 42
          FGCOLOR 12 
     RECT-126 AT ROW 1.58 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 3.71
         SIZE 120 BY 8.42
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fPage4
     tt_int_param_alatur.cod_espec_docto_pc AT ROW 2.25 COL 17.57 COLON-ALIGNED WIDGET-ID 16
          LABEL "Esp‚cie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_ser_docto_pc AT ROW 3.25 COL 17.57 COLON-ALIGNED WIDGET-ID 28
          LABEL "S‚rie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_portador_pc AT ROW 4.25 COL 17.57 COLON-ALIGNED WIDGET-ID 26
          LABEL "Portador"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.cod_tip_fluxo_financ_pc AT ROW 5.25 COL 17.57 COLON-ALIGNED WIDGET-ID 30
          LABEL "Fluxo Financeito"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt_int_param_alatur.cod_forma_pagto_pc AT ROW 6.25 COL 17.57 COLON-ALIGNED WIDGET-ID 18
          LABEL "Forma Pagamento"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt_int_param_alatur.num_dias_integra_pc AT ROW 2.25 COL 50.86 COLON-ALIGNED WIDGET-ID 32
          LABEL "Dias Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.num_dias_vencto_pc AT ROW 3.25 COL 50.86 COLON-ALIGNED WIDGET-ID 34
          LABEL "Dias Vencimento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt_int_param_alatur.cod_email_integracao_pc AT ROW 4.25 COL 40.72 WIDGET-ID 14
          LABEL "Email Integra‡Æo"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_pc AT ROW 5.25 COL 50.86 COLON-ALIGNED WIDGET-ID 20
          LABEL "Parƒmetro PC"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_pc_ad AT ROW 6.25 COL 50.86 COLON-ALIGNED WIDGET-ID 22
          LABEL "Parƒmetro PC AD"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tt_int_param_alatur.cod_param_pc_ad_viagem AT ROW 7.25 COL 50.86 COLON-ALIGNED WIDGET-ID 24
          LABEL "Parƒmetro PC AD Viagem"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 7.5 COL 103 WIDGET-ID 48
          FGCOLOR 12 
     "Presta‡Æo Contas" VIEW-AS TEXT
          SIZE 12.86 BY .54 AT ROW 1.33 COL 3.14 WIDGET-ID 12
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 6.5 COL 103 WIDGET-ID 42
          FGCOLOR 12 
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 5.5 COL 103 WIDGET-ID 44
          FGCOLOR 12 
     "Separados por v¡rgula" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 4.5 COL 103 WIDGET-ID 46
          FGCOLOR 12 
     RECT-127 AT ROW 1.58 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 3.71
         SIZE 120 BY 8.42
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt_int_param_alatur T "?" NO-UNDO mgesp int_param_alatur
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 12.88
         WIDTH              = 121.29
         MAX-HEIGHT         = 29.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.71
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE
       FRAME fPage2:FRAME = FRAME f-cad:HANDLE
       FRAME fpage3:FRAME = FRAME f-cad:HANDLE
       FRAME fPage4:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.dat_inicio_integracao IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_email_integracao_ad IN FRAME fPage2
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_espec_docto_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_estab_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_ad_viagem IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_portador_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_ser_docto_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_tip_fluxo_financ_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_unid_negoc_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_integra_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_vencto_ad IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage3
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_cta_ctbl_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_email_integracao_cr IN FRAME fpage3
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_espec_docto_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_estab_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_ad_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_ser_docto_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_tip_fluxo_financ_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_unid_negoc_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_integra_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_vencto_cr IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage4
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_email_integracao_pc IN FRAME fPage4
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_espec_docto_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_forma_pagto_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_pc_ad IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_param_pc_ad_viagem IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_portador_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_ser_docto_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.cod_tip_fluxo_financ_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_integra_pc IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt_int_param_alatur.num_dias_vencto_pc IN FRAME fPage4
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _TblList          = "Temp-Tables.tt_int_param_alatur"
     _Query            is OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _TblList          = "Temp-Tables.tt_int_param_alatur"
     _Query            is OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _TblList          = "Temp-Tables.tt_int_param_alatur"
     _Query            is OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _TblList          = "Temp-Tables.tt_int_param_alatur"
     _Query            is OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit w-cadsim
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-historico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-historico w-cadsim
ON CHOOSE OF bt-historico IN FRAME f-cad /* Hist¢rico */
DO:
    RUN esp/ala/ala0001a.w.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Salvar */
DO:
    RUN pi-cria-registro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt_int_param_alatur.cod_cta_ctbl_cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_cta_ctbl_cr w-cadsim
ON F5 OF tt_int_param_alatur.cod_cta_ctbl_cr IN FRAME fpage3 /* Conta Cont bil */
DO:
    ASSIGN v_rec_cta_ctbl_integr = ?.
    RUN prgint/utb/utb033na.p (INPUT "APB" /*l_apb*/,
                               INPUT "PadrÆo",
                               INPUT "Conta Movimento" /*l_conta_movimento*/) /*prg_see_cta_ctbl_integr*/.

    IF  v_rec_cta_ctbl_integr <> ? THEN DO:
       FIND FIRST cta_ctbl_integr NO-LOCK
            WHERE RECID(cta_ctbl_integr) = v_rec_cta_ctbl_integr NO-ERROR.

       ASSIGN tt_int_param_alatur.cod_cta_ctbl_cr:SCREEN-VALUE IN FRAME fPage3 = STRING(cta_ctbl_integr.cod_cta_ctbl).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_cta_ctbl_cr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_cta_ctbl_cr IN FRAME fpage3 /* Conta Cont bil */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt_int_param_alatur.cod_espec_docto_ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_ad w-cadsim
ON F5 OF tt_int_param_alatur.cod_espec_docto_ad IN FRAME fPage2 /* Esp‚cie */
DO:
    ASSIGN v_rec_espec_docto = ?.
    RUN prgint/ufn/ufn010na.p (INPUT NO,
                               INPUT YES,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES) /*prg_see_espec_docto_financ_param*/.

    IF v_rec_espec_docto <> ? THEN DO:
        FIND FIRST espec_docto NO-LOCK
             WHERE RECID(espec_docto) = v_rec_espec_docto NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_espec_docto_ad:SCREEN-VALUE IN FRAME fPage2 = string(espec_docto.cod_espec_docto).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_ad w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_espec_docto_ad IN FRAME fPage2 /* Esp‚cie */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt_int_param_alatur.cod_espec_docto_cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_cr w-cadsim
ON F5 OF tt_int_param_alatur.cod_espec_docto_cr IN FRAME fpage3 /* Esp‚cie */
DO:
    ASSIGN v_rec_espec_docto = ?.
    RUN prgint/ufn/ufn010na.p (INPUT NO,
                               INPUT YES,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES) /*prg_see_espec_docto_financ_param*/.

    IF v_rec_espec_docto <> ? THEN DO:
        FIND FIRST espec_docto NO-LOCK
             WHERE RECID(espec_docto) = v_rec_espec_docto NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_espec_docto_cr:SCREEN-VALUE IN FRAME fPage3 = string(espec_docto.cod_espec_docto).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_cr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_espec_docto_cr IN FRAME fpage3 /* Esp‚cie */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt_int_param_alatur.cod_espec_docto_pc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_pc w-cadsim
ON F5 OF tt_int_param_alatur.cod_espec_docto_pc IN FRAME fPage4 /* Esp‚cie */
DO:
    ASSIGN v_rec_espec_docto = ?.
    RUN prgint/ufn/ufn010na.p (INPUT YES,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT NO,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES) /*prg_see_espec_docto_financ_param*/.

    IF v_rec_espec_docto <> ? THEN DO:
        FIND FIRST espec_docto NO-LOCK
             WHERE RECID(espec_docto) = v_rec_espec_docto NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_espec_docto_pc:SCREEN-VALUE IN FRAME fPage4 = string(espec_docto.cod_espec_docto).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_espec_docto_pc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_espec_docto_pc IN FRAME fPage4 /* Esp‚cie */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt_int_param_alatur.cod_estab_ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_estab_ad w-cadsim
ON F5 OF tt_int_param_alatur.cod_estab_ad IN FRAME fPage2 /* Estabelecimento */
DO:
    RUN prgfin/apb/apb004nb.p (INPUT YES,
                               INPUT NO,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES) /*prg_see_usuar_financ_estab_apb*/.

    IF v_rec_usuar_financ_estab_apb <> ? THEN DO:
        FIND FIRST estabelecimento NO-LOCK
             WHERE RECID(estabelecimento) = v_rec_usuar_financ_estab_apb NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_estab_ad:SCREEN-VALUE IN FRAME fPage2 = STRING(estabelecimento.cod_estab).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_estab_ad w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_estab_ad IN FRAME fPage2 /* Estabelecimento */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt_int_param_alatur.cod_estab_cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_estab_cr w-cadsim
ON F5 OF tt_int_param_alatur.cod_estab_cr IN FRAME fpage3 /* Estabelecimento */
DO:
        RUN prgfin/apb/apb004nb.p (INPUT YES,
                               INPUT NO,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES,
                               INPUT YES) /*prg_see_usuar_financ_estab_apb*/.

    IF v_rec_usuar_financ_estab_apb <> ? THEN DO:
        FIND FIRST estabelecimento NO-LOCK
             WHERE RECID(estabelecimento) = v_rec_usuar_financ_estab_apb NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_estab_cr:SCREEN-VALUE IN FRAME fPage3 = STRING(estabelecimento.cod_estab).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_estab_cr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_estab_cr IN FRAME fpage3 /* Estabelecimento */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt_int_param_alatur.cod_forma_pagto_pc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_forma_pagto_pc w-cadsim
ON F5 OF tt_int_param_alatur.cod_forma_pagto_pc IN FRAME fPage4 /* Forma Pagamento */
DO:
    ASSIGN v_rec_forma_pagto = ?.
    RUN prgfin/apb/apb005ka.p /*prg_sea_forma_pagto*/.
    IF v_rec_forma_pagto <> ? THEN DO:
        FIND FIRST forma_pagto NO-LOCK 
             WHERE RECID(forma_pagto) = v_rec_forma_pagto NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_forma_pagto_pc:SCREEN-VALUE IN FRAME fPage4 = STRING(forma_pagto.cod_forma_pagto).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_forma_pagto_pc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_forma_pagto_pc IN FRAME fPage4 /* Forma Pagamento */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt_int_param_alatur.cod_portador_ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_portador_ad w-cadsim
ON F5 OF tt_int_param_alatur.cod_portador_ad IN FRAME fPage2 /* Portador */
DO:
    ASSIGN v_rec_portador = ?.
    RUN prgint/ufn/ufn008ka.p.
    IF v_rec_portador <> ? THEN DO:

        FIND FIRST emscad.portador NO-LOCK
             WHERE RECID(portador) = v_rec_portador NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_portador_ad:SCREEN-VALUE IN FRAME fPage2 = STRING(portador.cod_portad).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_portador_ad w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_portador_ad IN FRAME fPage2 /* Portador */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt_int_param_alatur.cod_portador_pc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_portador_pc w-cadsim
ON F5 OF tt_int_param_alatur.cod_portador_pc IN FRAME fPage4 /* Portador */
DO:
    ASSIGN v_rec_portador = ?.
    RUN prgint/ufn/ufn008ka.p.
    IF v_rec_portador <> ? THEN DO:

        FIND FIRST emscad.portador NO-LOCK
             WHERE RECID(portador) = v_rec_portador NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_portador_pc:SCREEN-VALUE IN FRAME fPage4 = STRING(portador.cod_portad).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_portador_pc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_portador_pc IN FRAME fPage4 /* Portador */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt_int_param_alatur.cod_ser_docto_pc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_ser_docto_pc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_ser_docto_pc IN FRAME fPage4 /* S‚rie */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt_int_param_alatur.cod_tip_fluxo_financ_ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_ad w-cadsim
ON F5 OF tt_int_param_alatur.cod_tip_fluxo_financ_ad IN FRAME fPage2 /* Tipo Fluxo */
DO:
    ASSIGN v_rec_tip_fluxo_financ = ?.
    RUN prgint/utb/utb037nb.p (Input "Anal¡tica" /*l_analitica*/) /*prg_see_tip_fluxo_financ*/.
    IF v_rec_tip_fluxo_financ <> ? THEN DO:

        FIND FIRST tip_fluxo_financ NO-LOCK
             WHERE RECID(tip_fluxo_financ) = v_rec_tip_fluxo_financ NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_tip_fluxo_financ_ad:SCREEN-VALUE IN FRAME fPage2 = STRING(tip_fluxo_financ.cod_tip_fluxo_financ).
        APPLY "entry" to tt_int_param_alatur.cod_tip_fluxo_financ_ad IN FRAME fPage2.
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_ad w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_tip_fluxo_financ_ad IN FRAME fPage2 /* Tipo Fluxo */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt_int_param_alatur.cod_tip_fluxo_financ_cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_cr w-cadsim
ON F5 OF tt_int_param_alatur.cod_tip_fluxo_financ_cr IN FRAME fpage3 /* Fluxo Financeito */
DO:
    ASSIGN v_rec_tip_fluxo_financ = ?.
    RUN prgint/utb/utb037nb.p (Input "Anal¡tica" /*l_analitica*/) /*prg_see_tip_fluxo_financ*/.
    IF v_rec_tip_fluxo_financ <> ? THEN DO:

        FIND FIRST tip_fluxo_financ NO-LOCK
             WHERE RECID(tip_fluxo_financ) = v_rec_tip_fluxo_financ NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_tip_fluxo_financ_cr:SCREEN-VALUE IN FRAME fPage3 = STRING(tip_fluxo_financ.cod_tip_fluxo_financ).
        APPLY "entry" to tt_int_param_alatur.cod_tip_fluxo_financ_cr IN FRAME fPage3.
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_cr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_tip_fluxo_financ_cr IN FRAME fpage3 /* Fluxo Financeito */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt_int_param_alatur.cod_tip_fluxo_financ_pc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_pc w-cadsim
ON F5 OF tt_int_param_alatur.cod_tip_fluxo_financ_pc IN FRAME fPage4 /* Fluxo Financeito */
DO:
    ASSIGN v_rec_tip_fluxo_financ = ?.
    RUN prgint/utb/utb037nb.p (Input "Anal¡tica" /*l_analitica*/) /*prg_see_tip_fluxo_financ*/.
    IF v_rec_tip_fluxo_financ <> ? THEN DO:

        FIND FIRST tip_fluxo_financ NO-LOCK
             WHERE RECID(tip_fluxo_financ) = v_rec_tip_fluxo_financ NO-ERROR.

        ASSIGN tt_int_param_alatur.cod_tip_fluxo_financ_pc:SCREEN-VALUE IN FRAME fPage4 = STRING(tip_fluxo_financ.cod_tip_fluxo_financ).
        APPLY "entry" to tt_int_param_alatur.cod_tip_fluxo_financ_pc IN FRAME fPage4.
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_tip_fluxo_financ_pc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_tip_fluxo_financ_pc IN FRAME fPage4 /* Fluxo Financeito */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt_int_param_alatur.cod_unid_negoc_ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_unid_negoc_ad w-cadsim
ON F5 OF tt_int_param_alatur.cod_unid_negoc_ad IN FRAME fPage2 /* Unidade de Neg¢cio */
DO:
    ASSIGN v_rec_unid_negoc = ?.
    FIND FIRST estabelecimento NO-LOCK
         WHERE estabelecimento.cod_estab = tt_int_param_alatur.cod_estab_ad:SCREEN-VALUE NO-ERROR.
        
    ASSIGN v_rec_estabelecimento = IF AVAIL estabelecimento THEN RECID(estabelecimento) ELSE ?.

    RUN prgint/utb/utb011na.p /*prg_see_unid_negoc_estab*/.
    IF  v_rec_unid_negoc <> ? THEN DO:

        FIND FIRST unid_negoc NO-LOCK 
             WHERE RECID(unid_negoc) = v_rec_unid_negoc NO-ERROR.
        ASSIGN tt_int_param_alatur.cod_unid_negoc_ad:SCREEN-VALUE IN FRAME fPage2 = STRING(unid_negoc.cod_unid_negoc).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_unid_negoc_ad w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_unid_negoc_ad IN FRAME fPage2 /* Unidade de Neg¢cio */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt_int_param_alatur.cod_unid_negoc_cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_unid_negoc_cr w-cadsim
ON F5 OF tt_int_param_alatur.cod_unid_negoc_cr IN FRAME fpage3 /* Unidade de Neg¢cio */
DO:
    ASSIGN v_rec_unid_negoc = ?.

    FIND FIRST estabelecimento NO-LOCK
         WHERE estabelecimento.cod_estab = tt_int_param_alatur.cod_estab_cr:SCREEN-VALUE NO-ERROR.
        
    ASSIGN v_rec_estabelecimento = IF AVAIL estabelecimento THEN RECID(estabelecimento) ELSE ?.

    RUN prgint/utb/utb011na.p /*prg_see_unid_negoc_estab*/.
    IF  v_rec_unid_negoc <> ? THEN DO:
        FIND FIRST unid_negoc NO-LOCK 
             WHERE RECID(unid_negoc) = v_rec_unid_negoc NO-ERROR.
        ASSIGN tt_int_param_alatur.cod_unid_negoc_cr:SCREEN-VALUE IN FRAME fPage3 = STRING(unid_negoc.cod_unid_negoc).
    END /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt_int_param_alatur.cod_unid_negoc_cr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF tt_int_param_alatur.cod_unid_negoc_cr IN FRAME fpage3 /* Unidade de Neg¢cio */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME folder-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-1 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-1 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-2:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-3:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  
  VIEW FRAME fPage1.
  HIDE FRAME fPage2.
  HIDE FRAME fPage3.
  HIDE FRAME fPage4.

  ASSIGN i-folder = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-2 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-2 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-2:LOAD-IMAGE("image/ts-up110.bmp").
  folder-3:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  
  HIDE FRAME fPage1.
  VIEW FRAME fPage2.
  HIDE FRAME fPage3.
  HIDE FRAME fPage4.
  

  ASSIGN i-folder = 2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-3 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-3 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-2:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-3:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage2.
  VIEW FRAME fPage3.
  HIDE FRAME fPage4.

  ASSIGN i-folder = 3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-4 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-4 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-2:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-3:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-up110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage2.
  HIDE FRAME fPage3.
  VIEW FRAME fPage4.

  ASSIGN i-folder = 4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  ENABLE rt-button folder-1 folder-2 folder-3 folder-4 bt-exit bt-ok bt-cancela 
         bt-historico 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}

  {&OPEN-QUERY-fPage1}
  GET FIRST fPage1.
  IF AVAILABLE tt_int_param_alatur THEN 
    DISPLAY tt_int_param_alatur.dat_inicio_integracao 
          tt_int_param_alatur.log_integra_an tt_int_param_alatur.log_integra_pc 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  ENABLE RECT-124 tt_int_param_alatur.dat_inicio_integracao 
         tt_int_param_alatur.log_integra_an tt_int_param_alatur.log_integra_pc 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}

  {&OPEN-QUERY-fPage2}
  GET FIRST fPage2.
  IF AVAILABLE tt_int_param_alatur THEN 
    DISPLAY tt_int_param_alatur.cod_estab_ad 
          tt_int_param_alatur.cod_espec_docto_ad 
          tt_int_param_alatur.cod_ser_docto_ad 
          tt_int_param_alatur.cod_portador_ad 
          tt_int_param_alatur.cod_tip_fluxo_financ_ad 
          tt_int_param_alatur.cod_unid_negoc_ad 
          tt_int_param_alatur.num_dias_integra_ad 
          tt_int_param_alatur.num_dias_vencto_ad 
          tt_int_param_alatur.cod_email_integracao_ad 
          tt_int_param_alatur.cod_param_ad 
          tt_int_param_alatur.cod_param_ad_viagem 
          tt_int_param_alatur.cod_ser_docto_rot
      WITH FRAME fPage2 IN WINDOW w-cadsim.
  ENABLE tt_int_param_alatur.cod_estab_ad 
         tt_int_param_alatur.cod_espec_docto_ad 
         tt_int_param_alatur.cod_ser_docto_ad 
         tt_int_param_alatur.cod_portador_ad 
         tt_int_param_alatur.cod_tip_fluxo_financ_ad 
         tt_int_param_alatur.cod_unid_negoc_ad 
         tt_int_param_alatur.num_dias_integra_ad 
         tt_int_param_alatur.num_dias_vencto_ad 
         tt_int_param_alatur.cod_email_integracao_ad 
         tt_int_param_alatur.cod_param_ad 
         tt_int_param_alatur.cod_param_ad_viagem 
         tt_int_param_alatur.cod_ser_docto_rot RECT-125 
      WITH FRAME fPage2 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage2}

  {&OPEN-QUERY-fpage3}
  GET FIRST fpage3.
  IF AVAILABLE tt_int_param_alatur THEN 
    DISPLAY tt_int_param_alatur.cod_estab_cr 
          tt_int_param_alatur.cod_espec_docto_cr 
          tt_int_param_alatur.cod_ser_docto_cr 
          tt_int_param_alatur.cod_tip_fluxo_financ_cr 
          tt_int_param_alatur.cod_unid_negoc_cr 
          tt_int_param_alatur.cod_cta_ctbl_cr 
          tt_int_param_alatur.num_dias_integra_cr 
          tt_int_param_alatur.num_dias_vencto_cr 
          tt_int_param_alatur.cod_email_integracao_cr 
          tt_int_param_alatur.cod_param_ad_cr 
      WITH FRAME fpage3 IN WINDOW w-cadsim.
  ENABLE RECT-126 tt_int_param_alatur.cod_estab_cr 
         tt_int_param_alatur.cod_espec_docto_cr 
         tt_int_param_alatur.cod_ser_docto_cr 
         tt_int_param_alatur.cod_tip_fluxo_financ_cr 
         tt_int_param_alatur.cod_unid_negoc_cr 
         tt_int_param_alatur.cod_cta_ctbl_cr 
         tt_int_param_alatur.num_dias_integra_cr 
         tt_int_param_alatur.num_dias_vencto_cr 
         tt_int_param_alatur.cod_email_integracao_cr 
         tt_int_param_alatur.cod_param_ad_cr 
      WITH FRAME fpage3 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage3}

  {&OPEN-QUERY-fPage4}
  GET FIRST fPage4.
  IF AVAILABLE tt_int_param_alatur THEN 
    DISPLAY tt_int_param_alatur.cod_espec_docto_pc 
          tt_int_param_alatur.cod_ser_docto_pc 
          tt_int_param_alatur.cod_portador_pc 
          tt_int_param_alatur.cod_tip_fluxo_financ_pc 
          tt_int_param_alatur.cod_forma_pagto_pc 
          tt_int_param_alatur.num_dias_integra_pc 
          tt_int_param_alatur.num_dias_vencto_pc 
          tt_int_param_alatur.cod_email_integracao_pc 
          tt_int_param_alatur.cod_param_pc tt_int_param_alatur.cod_param_pc_ad 
          tt_int_param_alatur.cod_param_pc_ad_viagem 
      WITH FRAME fPage4 IN WINDOW w-cadsim.
  ENABLE RECT-127 tt_int_param_alatur.cod_espec_docto_pc 
         tt_int_param_alatur.cod_ser_docto_pc 
         tt_int_param_alatur.cod_portador_pc 
         tt_int_param_alatur.cod_tip_fluxo_financ_pc 
         tt_int_param_alatur.cod_forma_pagto_pc 
         tt_int_param_alatur.num_dias_integra_pc 
         tt_int_param_alatur.num_dias_vencto_pc 
         tt_int_param_alatur.cod_email_integracao_pc 
         tt_int_param_alatur.cod_param_pc tt_int_param_alatur.cod_param_pc_ad 
         tt_int_param_alatur.cod_param_pc_ad_viagem 
      WITH FRAME fPage4 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage4}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "tela" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  {include/i-inifld.i}

  APPLY 'mouse-select-click' TO folder-1 IN FRAME f-cad.

  IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage1:HANDLE ).
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage2:HANDLE ).
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage3:HANDLE ).

  IF tt_int_param_alatur.cod_tip_fluxo_financ_ad:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
  IF tt_int_param_alatur.cod_tip_fluxo_financ_cr:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.
  IF tt_int_param_alatur.cod_tip_fluxo_financ_pc:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.

  IF tt_int_param_alatur.cod_unid_negoc_ad:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
  IF tt_int_param_alatur.cod_unid_negoc_cr:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.

  IF tt_int_param_alatur.cod_cta_ctbl_cr:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.

  IF tt_int_param_alatur.cod_estab_ad:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
  IF tt_int_param_alatur.cod_estab_cr:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.

  IF tt_int_param_alatur.cod_espec_docto_ad:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
  IF tt_int_param_alatur.cod_espec_docto_cr:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.
  IF tt_int_param_alatur.cod_espec_docto_pc:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.

  IF tt_int_param_alatur.cod_portador_ad:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
  IF tt_int_param_alatur.cod_portador_pc:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.

  IF tt_int_param_alatur.cod_forma_pagto_pc:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.

  RUN pi-mostra-registro.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro w-cadsim 
PROCEDURE pi-cria-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-validar.

IF RETURN-VALUE <> "OK" THEN
    RETURN.

CREATE int_param_alatur.
ASSIGN int_param_alatur.dat_ult_atualiz         = TODAY
       int_param_alatur.hra_ult_atualiz         = REPLACE(SUBSTRING(STRING(NOW),12,8),":","")
       int_param_alatur.cod_usuar_ult_atualiz   = v_cod_usuar_corren
       /*Geral*/
       int_param_alatur.dat_inicio_integracao   = INPUT FRAME fPage1 tt_int_param_alatur.dat_inicio_integracao
       int_param_alatur.log_integra_an          = INPUT FRAME fPage1 tt_int_param_alatur.log_integra_an        
       int_param_alatur.log_integra_pc          = INPUT FRAME fPage1 tt_int_param_alatur.log_integra_pc
       /*Adiantamento*/
       int_param_alatur.cod_estab_ad            = INPUT FRAME fPage2 tt_int_param_alatur.cod_estab_ad
       int_param_alatur.cod_espec_docto_ad      = INPUT FRAME fPage2 tt_int_param_alatur.cod_espec_docto_ad
       int_param_alatur.cod_ser_docto_ad        = INPUT FRAME fPage2 tt_int_param_alatur.cod_ser_docto_ad 
       int_param_alatur.cod_portador_ad         = INPUT FRAME fPage2 tt_int_param_alatur.cod_portador_ad
       int_param_alatur.cod_tip_fluxo_financ_ad = INPUT FRAME fPage2 tt_int_param_alatur.cod_tip_fluxo_financ_ad
       int_param_alatur.cod_unid_negoc_ad       = INPUT FRAME fPage2 tt_int_param_alatur.cod_unid_negoc_ad
       int_param_alatur.num_dias_integra_ad     = INPUT FRAME fPage2 tt_int_param_alatur.num_dias_integra_ad
       int_param_alatur.num_dias_vencto_ad      = INPUT FRAME fPage2 tt_int_param_alatur.num_dias_vencto_ad
       int_param_alatur.cod_email_integracao_ad = INPUT FRAME fPage2 tt_int_param_alatur.cod_email_integracao_ad
       int_param_alatur.cod_param_ad            = INPUT FRAME fPage2 tt_int_param_alatur.cod_param_ad
       int_param_alatur.cod_param_ad_viagem     = INPUT FRAME fPage2 tt_int_param_alatur.cod_param_ad_viagem
       int_param_alatur.cod_ser_docto_rot       = INPUT FRAME fPage2 tt_int_param_alatur.cod_ser_docto_rot
       /*CartÆo de Cr‚dito*/
       int_param_alatur.cod_estab_cr            = INPUT FRAME fPage3 tt_int_param_alatur.cod_estab_cr
       int_param_alatur.cod_espec_docto_cr      = INPUT FRAME fPage3 tt_int_param_alatur.cod_espec_docto_cr
       int_param_alatur.cod_ser_docto_cr        = INPUT FRAME fPage3 tt_int_param_alatur.cod_ser_docto_cr
       int_param_alatur.cod_tip_fluxo_financ_cr = INPUT FRAME fPage3 tt_int_param_alatur.cod_tip_fluxo_financ_cr
       int_param_alatur.cod_unid_negoc_cr       = INPUT FRAME fPage3 tt_int_param_alatur.cod_unid_negoc_cr
       int_param_alatur.cod_cta_ctbl_cr         = INPUT FRAME fPage3 tt_int_param_alatur.cod_cta_ctbl_cr
       int_param_alatur.num_dias_integra_cr     = INPUT FRAME fPage3 tt_int_param_alatur.num_dias_integra_cr
       int_param_alatur.num_dias_vencto_cr      = INPUT FRAME fPage3 tt_int_param_alatur.num_dias_vencto_cr 
       int_param_alatur.cod_email_integracao_cr = INPUT FRAME fPage3 tt_int_param_alatur.cod_email_integracao_cr
       int_param_alatur.cod_param_ad_cr         = INPUT FRAME fPage3 tt_int_param_alatur.cod_param_ad_cr
       /*Presta‡Æo Contas*/
       int_param_alatur.cod_espec_docto_pc      = INPUT FRAME fPage4 tt_int_param_alatur.cod_espec_docto_pc
       int_param_alatur.cod_ser_docto_pc        = INPUT FRAME fPage4 tt_int_param_alatur.cod_ser_docto_pc
       int_param_alatur.cod_portador_pc         = INPUT FRAME fPage4 tt_int_param_alatur.cod_portador_pc
       int_param_alatur.cod_tip_fluxo_financ_pc = INPUT FRAME fPage4 tt_int_param_alatur.cod_tip_fluxo_financ_pc
       int_param_alatur.cod_forma_pagto_pc      = INPUT FRAME fPage4 tt_int_param_alatur.cod_forma_pagto_pc
       int_param_alatur.num_dias_integra_pc     = INPUT FRAME fPage4 tt_int_param_alatur.num_dias_integra_pc
       int_param_alatur.num_dias_vencto_pc      = INPUT FRAME fPage4 tt_int_param_alatur.num_dias_vencto_pc
       int_param_alatur.cod_email_integracao_pc = INPUT FRAME fPage4 tt_int_param_alatur.cod_email_integracao_pc
       int_param_alatur.cod_param_pc            = INPUT FRAME fPage4 tt_int_param_alatur.cod_param_pc
       int_param_alatur.cod_param_pc_ad         = INPUT FRAME fPage4 tt_int_param_alatur.cod_param_pc_ad
       int_param_alatur.cod_param_pc_ad_viagem  = INPUT FRAME fPage4 tt_int_param_alatur.cod_param_pc_ad_viagem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-registro w-cadsim 
PROCEDURE pi-mostra-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt_int_param_alatur.

IF NOT CAN-FIND (FIRST int_param_alatur) THEN
    RETURN.

FOR LAST int_param_alatur NO-LOCK:
    CREATE tt_int_param_alatur.
    BUFFER-COPY int_param_alatur TO tt_int_param_alatur.
END.

/*Geral*/
DO WITH FRAME fPage1:
    DISPLAY tt_int_param_alatur.dat_inicio_integracao
            tt_int_param_alatur.log_integra_an       
            tt_int_param_alatur.log_integra_pc.      
END.

/*Adiantamento*/
DO WITH FRAME fPage2:
    DISPLAY tt_int_param_alatur.cod_estab_ad           
            tt_int_param_alatur.cod_espec_docto_ad     
            tt_int_param_alatur.cod_ser_docto_ad       
            tt_int_param_alatur.cod_portador_ad        
            tt_int_param_alatur.cod_tip_fluxo_financ_ad
            tt_int_param_alatur.cod_unid_negoc_ad      
            tt_int_param_alatur.num_dias_integra_ad    
            tt_int_param_alatur.num_dias_vencto_ad     
            tt_int_param_alatur.cod_email_integracao_ad
            tt_int_param_alatur.cod_param_ad           
            tt_int_param_alatur.cod_param_ad_viagem
            tt_int_param_alatur.cod_ser_docto_rot.
END.

/*CartÆo de Cr‚dito*/
DO WITH FRAME fPage3:
    DISPLAY tt_int_param_alatur.cod_estab_cr           
            tt_int_param_alatur.cod_espec_docto_cr     
            tt_int_param_alatur.cod_ser_docto_cr       
            tt_int_param_alatur.cod_tip_fluxo_financ_cr
            tt_int_param_alatur.cod_unid_negoc_cr      
            tt_int_param_alatur.cod_cta_ctbl_cr        
            tt_int_param_alatur.num_dias_integra_cr    
            tt_int_param_alatur.num_dias_vencto_cr     
            tt_int_param_alatur.cod_email_integracao_cr
            tt_int_param_alatur.cod_param_ad_cr.      
END.

/*Presta‡Æo Contas*/
DO WITH FRAME fPage4:
    DISPLAY tt_int_param_alatur.cod_espec_docto_pc      
            tt_int_param_alatur.cod_ser_docto_pc        
            tt_int_param_alatur.cod_portador_pc         
            tt_int_param_alatur.cod_tip_fluxo_financ_pc 
            tt_int_param_alatur.cod_forma_pagto_pc      
            tt_int_param_alatur.num_dias_integra_pc     
            tt_int_param_alatur.num_dias_vencto_pc      
            tt_int_param_alatur.cod_email_integracao_pc 
            tt_int_param_alatur.cod_param_pc            
            tt_int_param_alatur.cod_param_pc_ad         
            tt_int_param_alatur.cod_param_pc_ad_viagem. 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar w-cadsim 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage2:
    IF NOT CAN-FIND (FIRST estabelecimento
                     WHERE estabelecimento.cod_estab = tt_int_param_alatur.cod_estab_ad:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado estabelecimento de adiantamento informado.").
        RETURN "NOK".
    END.

    FIND FIRST espec_docto NO-LOCK
         WHERE espec_docto.cod_espec_docto = tt_int_param_alatur.cod_espec_docto_ad:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL espec_docto THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado esp‚cie de documento de adiantamento informado.").
        RETURN "NOK".
    END.
    ELSE IF espec_docto.ind_tip_espec_docto <> "Antecipa‡Æo" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Esp‚cie de documento de adiantamento informado nÆo de do tipo 'Antecipa‡Æo'").
        RETURN "NOK".
    END.

    /*IF NOT CAN-FIND (FIRST ser_fisc_nota
                     WHERE ser_fisc_nota.cod_ser_fisc_nota = tt_int_param_alatur.cod_ser_docto_ad:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrada s‚rie fiscal de adiantamento informada.").
        RETURN "NOK".
    END.*/

    IF NOT CAN-FIND (FIRST emscad.portador
                     WHERE portador.cod_portador = tt_int_param_alatur.cod_portador_ad:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado portador de adiantamento informado.").
        RETURN "NOK".
    END.

    IF NOT CAN-FIND (FIRST unid_negoc
                     WHERE unid_negoc.cod_unid_negoc = tt_int_param_alatur.cod_unid_negoc_ad:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado unidade de neg¢cio de adiantamento informado.").
        RETURN "NOK".
    END.

    FIND FIRST tip_fluxo_financ NO-LOCK
         WHERE tip_fluxo_financ.cod_tip_fluxo_financ = tt_int_param_alatur.cod_tip_fluxo_financ_ad:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL tip_fluxo_financ THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado tipo de fluxo financeiro de adiantamento informado.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_tip_secao_fluxo_cx <> "Anal¡tica" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de adiantamento informado nÆo ‚ anal¡tica.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_fluxo_movto_financ <> "Sa¡da" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de adiantamento informado nÆo ‚ de sa¡da.").
        RETURN "NOK".
    END.
END.

DO WITH FRAME fPage3:
    IF NOT CAN-FIND (FIRST estabelecimento
                     WHERE estabelecimento.cod_estab = tt_int_param_alatur.cod_estab_cr:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado estabelecimento de cr‚dito informado.").
        RETURN "NOK".
    END.

    FIND FIRST espec_docto NO-LOCK
         WHERE espec_docto.cod_espec_docto = tt_int_param_alatur.cod_espec_docto_cr:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL espec_docto THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado esp‚cie de documento de cr‚dito informado.").
        RETURN "NOK".
    END.
    ELSE IF espec_docto.ind_tip_espec_docto <> "Antecipa‡Æo" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Esp‚cie de documento de cr‚dito informado nÆo de do tipo 'Antecipa‡Æo'").
        RETURN "NOK".
    END.

    /*IF NOT CAN-FIND (FIRST ser_fisc_nota
                     WHERE ser_fisc_nota.cod_ser_fisc_nota = tt_int_param_alatur.cod_ser_docto_cr:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrada s‚rie fiscal de cr‚dito informada.").
        RETURN "NOK".
    END.*/

    IF NOT CAN-FIND (FIRST unid_negoc
                     WHERE unid_negoc.cod_unid_negoc = tt_int_param_alatur.cod_unid_negoc_cr:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado unidade de neg¢cio de cr‚dito informado.").
        RETURN "NOK".
    END.

    FIND FIRST tip_fluxo_financ NO-LOCK
         WHERE tip_fluxo_financ.cod_tip_fluxo_financ = tt_int_param_alatur.cod_tip_fluxo_financ_cr:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL tip_fluxo_financ THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado tipo de fluxo financeiro de cr‚dito informado.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_tip_secao_fluxo_cx <> "Anal¡tica" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de cr‚dito informado nÆo ‚ anal¡tica.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_fluxo_movto_financ <> "Sa¡da" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de cr‚dito informado nÆo ‚ de sa¡da.").
        RETURN "NOK".
    END.

    IF NOT CAN-FIND (FIRST cta_ctbl
                     WHERE cta_ctbl.cod_cta_ctbl = tt_int_param_alatur.cod_cta_ctbl_cr:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado conta cont bil de cr‚dito informada.").
        RETURN "NOK".
    END.
END.

DO WITH FRAME fPage4:
    /*IF NOT CAN-FIND (FIRST ser_fisc_nota
                     WHERE ser_fisc_nota.cod_ser_fisc_nota = tt_int_param_alatur.cod_ser_docto_pc:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrada s‚rie fiscal de presta‡Æo de contas informada.").
        RETURN "NOK".
    END.*/

    IF NOT CAN-FIND (FIRST emscad.portador
                     WHERE portador.cod_portador = tt_int_param_alatur.cod_portador_pc:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado portador de presta‡Æo de contas informado.").
        RETURN "NOK".
    END.

    FIND FIRST tip_fluxo_financ NO-LOCK
         WHERE tip_fluxo_financ.cod_tip_fluxo_financ = tt_int_param_alatur.cod_tip_fluxo_financ_pc:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL tip_fluxo_financ THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado tipo de fluxo financeiro de presta‡Æo de contas informado.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_tip_secao_fluxo_cx <> "Anal¡tica" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de presta‡Æo de contas informado nÆo ‚ anal¡tica.").
        RETURN "NOK".
    END.
    ELSE IF tip_fluxo_financ.ind_fluxo_movto_financ <> "Sa¡da" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo de fluxo financeiro de presta‡Æo de contas informado nÆo ‚ de sa¡da.").
        RETURN "NOK".
    END.

    FIND FIRST espec_docto NO-LOCK
         WHERE espec_docto.cod_espec_docto = tt_int_param_alatur.cod_espec_docto_pc:SCREEN-VALUE NO-ERROR.

    IF NOT AVAIL espec_docto THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado esp‚cie de documento de presta‡Æo de contas informado.").
        RETURN "NOK".
    END.
    ELSE IF espec_docto.ind_tip_espec_docto <> "Normal" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Tipo da esp‚cie de documento de presta‡Æo de contas diferente de normal.").
        RETURN "NOK".
    END.
    
    IF NOT CAN-FIND (FIRST espec_docto_financ
                     WHERE espec_docto_financ.cod_espec_docto = tt_int_param_alatur.cod_espec_docto_pc:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado esp‚cie de documento financeiro de presta‡Æo de contas informado.").
        RETURN "NOK".
    END.

    IF NOT CAN-FIND (FIRST forma_pagto
                     WHERE forma_pagto.cod_forma_pagto = tt_int_param_alatur.cod_forma_pagto_pc:SCREEN-VALUE) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado forma de pagamento de presta‡Æo de contas informado.").
        RETURN "NOK".
    END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt_int_param_alatur"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

