&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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


DEF VAR v-cod-arq-orig  AS       CHAR NO-UNDO.
DEF VAR v-des-tp-contr  AS       CHAR NO-UNDO.
DEF VAR v-obsoleto      AS       CHAR NO-UNDO.
DEF VAR v-des-orig-pis  AS       CHAR NO-UNDO.
DEF VAR v-des-orig-cof  AS       CHAR NO-UNDO.
DEF VAR v-num-seq-linha AS        INT NO-UNDO.


/* Temp-table Definitions ---                                         */
DEF VAR hShowMsg AS HANDLE NO-UNDO.        

/* Defini‡Æo da Temp-table onde serÆo retornados os erros */
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEF BUFFER tabela1 FOR dwf-ajust-cr-impto-apurad.
DEF BUFFER tabela2 FOR dwf-ajust-contrib-imp-apurad.
DEF BUFFER tabela3 FOR dwf-contrib-previd-recta.
DEF BUFFER tabela4 FOR dwf-outros-docto-operac.
DEF BUFFER tabela5 FOR dwf-contrib-retid-fonte.

DEFINE TEMP-TABLE ttdwf-ajust-cr-impto-apurad NO-UNDO LIKE dwf-ajust-cr-impto-apurad
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttdwf-ajust-contrib-imp-apurad NO-UNDO LIKE dwf-ajust-contrib-imp-apurad
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttdwf-contrib-previd-recta NO-UNDO LIKE dwf-contrib-previd-recta
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttdwf-outros-docto-operac NO-UNDO LIKE dwf-outros-docto-operac
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttdwf-contrib-retid-fonte NO-UNDO LIKE dwf-contrib-retid-fonte
    FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-fibo387 AS HANDLE NO-UNDO.                               
DEFINE VARIABLE h-fibo389 AS HANDLE NO-UNDO.                               
DEFINE VARIABLE h-fibo422 AS HANDLE NO-UNDO.                                                                    
DEFINE VARIABLE h-fibo344 AS HANDLE NO-UNDO.  
DEFINE VARIABLE h-fibo357 AS HANDLE NO-UNDO.  

IF  NOT VALID-HANDLE(h-fibo387) THEN RUN fibo/bofi387.p PERSISTENT SET h-fibo387.
IF  NOT VALID-HANDLE(h-fibo389) THEN RUN fibo/bofi389.p PERSISTENT SET h-fibo389.
IF  NOT VALID-HANDLE(h-fibo422) THEN RUN fibo/bofi422.p PERSISTENT SET h-fibo422.
IF  NOT VALID-HANDLE(h-fibo344) THEN RUN fibo/bofi344.p PERSISTENT SET h-fibo344.
IF  NOT VALID-HANDLE(h-fibo357) THEN RUN fibo/bofi357.p PERSISTENT SET h-fibo357.

/* Tabela Auxiliar M110/M510 */
DEFINE TEMP-TABLE tt-M110-M510 NO-UNDO 
    FIELD cod-empres           AS character 
    FIELD cod-impto            AS character 
    FIELD cod-cr               AS character 
    FIELD cod-indic-cr         AS character 
    FIELD val-aliq-impto       AS decimal 
    FIELD val-quant-aliq-impto AS decimal 
    FIELD cod-indic-ajust      AS character 
    FIELD val-ajust            AS decimal 
    FIELD cod-ajust            AS character 
    FIELD cod-num-docto        AS character 
    FIELD des-ajust            AS character 
    FIELD dat-refer            AS date 
    FIELD cod-livre-1          AS character 
    FIELD cod-livre-2          AS character 
    FIELD cod-livre-3          AS character 
    FIELD cod-livre-4          AS character 
    FIELD dat-livre-1          AS date 
    FIELD dat-livre-2          AS date 
    FIELD dat-livre-3          AS date 
    FIELD dat-livre-4          AS date 
    FIELD log-livre-1          AS logical 
    FIELD log-livre-2          AS logical 
    FIELD log-livre-3          AS logical 
    FIELD log-livre-4          AS logical 
    FIELD num-livre-1          AS integer 
    FIELD num-livre-2          AS integer 
    FIELD num-livre-3          AS integer 
    FIELD num-livre-4          AS integer 
    FIELD val-livre-1          AS decimal 
    FIELD val-livre-2          AS decimal 
    FIELD val-livre-3          AS decimal 
    FIELD val-livre-4          AS decimal
    FIELD linha-excel          AS INTEGER. 

/* Tabela Auxiliar M220/M620 */
DEFINE TEMP-TABLE tt-M220-M620 NO-UNDO
    FIELD cod-empres           AS character 
    FIELD cod-impto            AS character 
    FIELD cod-contrib          AS CHARACTER
    FIELD val-aliq-impto       AS decimal 
    FIELD val-quant-aliq-impto AS decimal 
    FIELD cod-indic-ajust      AS character 
    FIELD val-ajust            AS decimal 
    FIELD cod-ajust            AS character 
    FIELD cod-num-docto        AS character 
    FIELD des-ajust            AS character 
    FIELD dat-refer            AS date 
    FIELD cod-livre-1          AS character 
    FIELD cod-livre-2          AS character 
    FIELD cod-livre-3          AS character 
    FIELD cod-livre-4          AS character 
    FIELD dat-livre-1          AS date 
    FIELD dat-livre-2          AS date 
    FIELD dat-livre-3          AS date 
    FIELD dat-livre-4          AS date 
    FIELD log-livre-1          AS logical 
    FIELD log-livre-2          AS logical 
    FIELD log-livre-3          AS logical 
    FIELD log-livre-4          AS logical 
    FIELD num-livre-1          AS integer 
    FIELD num-livre-2          AS integer 
    FIELD num-livre-3          AS integer 
    FIELD num-livre-4          AS integer 
    FIELD val-livre-1          AS decimal 
    FIELD val-livre-2          AS decimal 
    FIELD val-livre-3          AS decimal 
    FIELD val-livre-4          AS decimal
    FIELD linha-excel          AS INTEGER. 


/* Auxiliar tem-table tt-P100*/
DEFINE TEMP-TABLE tt-p100
   FIELD cod-empres                   AS character 
   FIELD cod-estab                    AS character 
   FIELD dat-apurac-inicial           AS date 
   FIELD dat-apurac-final             AS date 
   FIELD cod-ativid                   AS CHARACTER 
   FIELD val-aliq                     AS decimal 
   FIELD cod-cta-ctbl                 AS character 
   FIELD num-seq-ident-reg            AS INTEGER 
   FIELD val-recta-bruta-tot-estab    AS decimal 
   FIELD val-recta-bruta-ativid-estab AS decimal 
   FIELD val-exclusao                 AS decimal 
   FIELD val-base-contrib             AS decimal 
   FIELD val-contrib-apurad           AS DECIMAL 
   FIELD des-inf-comp                 AS character 
   FIELD cod-livre-1                  AS character 
   FIELD cod-livre-2                  AS character 
   FIELD cod-livre-3                  AS character 
   FIELD cod-livre-4                  AS character 
   FIELD dat-livre-1                  AS date 
   FIELD dat-livre-2                  AS date 
   FIELD dat-livre-3                  AS date 
   FIELD dat-livre-4                  AS date 
   FIELD log-livre-1                  AS logical 
   FIELD log-livre-2                  AS logical 
   FIELD log-livre-3                  AS logical 
   FIELD log-livre-4                  AS logical 
   FIELD num-livre-1                  AS integer 
   FIELD num-livre-2                  AS integer 
   FIELD num-livre-3                  AS integer 
   FIELD num-livre-4                  AS integer 
   FIELD val-livre-1                  AS decimal 
   FIELD val-livre-2                  AS decimal 
   FIELD val-livre-3                  AS decimal 
   FIELD val-livre-4                  AS decimal 
   FIELD linha-excel                  AS INTEGER.

/* Auxiliar tem-table tt-F100*/ 
DEFINE TEMP-TABLE tt-F100
   FIELD cod-empres                   AS CHAR
   FIELD cod-estab                    AS CHAR
   FIELD dat-trans                    AS DATE
   FIELD num-seq-ident-reg            AS INTEGER
   FIELD cod-indic-operac             AS CHAR
   FIELD cod-participan               AS CHAR
   FIELD cod-item                     AS CHAR
   FIELD dat-operac                   AS DATE
   FIELD val-operac                   AS DEC
   FIELD cod-sit-tributar-pis         AS CHAR
   FIELD val-base-calc-pis            AS DEC
   FIELD val-aliq-pis                 AS DEC
   FIELD val-pis                      AS DEC
   FIELD cod-sit-tributar-cofins      AS CHAR
   FIELD val-base-calc-cofins         AS DEC
   FIELD val-aliq-cofins              AS DEC
   FIELD val-cofins                   AS DEC
   FIELD cod-nat-base-calc-cr         AS CHAR
   FIELD ind-orig                     AS CHAR
   FIELD cod-cta-ctbl                 AS CHAR
   FIELD cod-ccusto                   AS CHAR
   FIELD des-operac                   AS CHAR
   FIELD cod-livre-1                  AS character 
   FIELD cod-livre-2                  AS character 
   FIELD cod-livre-3                  AS character 
   FIELD cod-livre-4                  AS character 
   FIELD dat-livre-1                  AS date 
   FIELD dat-livre-2                  AS date 
   FIELD dat-livre-3                  AS date 
   FIELD dat-livre-4                  AS date 
   FIELD log-livre-1                  AS logical 
   FIELD log-livre-2                  AS logical 
   FIELD log-livre-3                  AS logical 
   FIELD log-livre-4                  AS logical 
   FIELD num-livre-1                  AS integer 
   FIELD num-livre-2                  AS integer 
   FIELD num-livre-3                  AS integer 
   FIELD num-livre-4                  AS integer 
   FIELD val-livre-1                  AS decimal 
   FIELD val-livre-2                  AS decimal 
   FIELD val-livre-3                  AS decimal 
   FIELD val-livre-4                  AS decimal 
   FIELD linha-excel                  AS INTEGER.

/* Auxiliar tem-table tt-F600*/ 
DEFINE TEMP-TABLE tt-F600
     FIELD   cod-empres              AS    char     
     FIELD   cod-estab               AS    char     
     FIELD   dat-trans               AS    date     
     FIELD   num-seq-ident-reg       AS    inte     
     FIELD   cod-grp                 AS    char     
     FIELD   cod-emitente            AS    char     
     FIELD   cod-indic-natur-retenc  AS    char     
     FIELD   dat-recebto-retenc      AS    date     
     FIELD   val-recbdo              AS    dec   
     FIELD   val-retid-fonte         AS    dec   
     FIELD   cod-recta               AS    char     
     FIELD   cod-indic-natur-recta   AS    char     
     FIELD   cod-cnpj                AS    char     
     FIELD   val-retid-pis           AS    dec   
     FIELD   val-retid-cofins        AS    dec  
     FIELD   cod-livre-1             AS    char     
     FIELD   cod-livre-2             AS    char     
     FIELD   cod-livre-3             AS    char     
     FIELD   cod-livre-4             AS    char     
     FIELD   dat-livre-1             AS    date     
     FIELD   dat-livre-2             AS    date     
     FIELD   dat-livre-3             AS    date     
     FIELD   dat-livre-4             AS    date     
     FIELD   log-livre-1             AS    LOGICAL     
     FIELD   log-livre-2             AS    LOGICAL
     FIELD   log-livre-3             AS    LOGICAL
     FIELD   log-livre-4             AS    LOGICAL
     FIELD   num-livre-1             AS    int     
     FIELD   num-livre-2             AS    int     
     FIELD   num-livre-3             AS    int     
     FIELD   num-livre-4             AS    int     
     FIELD   val-livre-1             AS    dec  
     FIELD   val-livre-2             AS    dec   
     FIELD   val-livre-3             AS    dec   
     FIELD   val-livre-4             AS    DEC
     FIELD linha-excel               AS INTEGER.
/* Para PI-Abre-Excel */
DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContVazio AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-15 IMAGE-16 IMAGE-17 ~
IMAGE-18 IMAGE-19 IMAGE-20 fi-emp-ini fi-emp-fim fi-est-ini fi-est-fim ~
fi-dat-ini fi-dat-fim fi-seq-ini fi-seq-fim 
&Scoped-Define DISPLAYED-OBJECTS fi-emp-ini fi-emp-fim fi-est-ini ~
fi-est-fim fi-dat-ini fi-dat-fim fi-seq-ini fi-seq-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 f1 f2 f3 f4 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_celula C-Win 
FUNCTION fn_celula RETURNS CHARACTER
  ( INPUT fni-c-coluna AS   CHARACTER ,
    INPUT fni-i-linha  AS   INTEGER   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-dat-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dat-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-emp-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-emp-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Empresa":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-est-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-est-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelec":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-seq-fim AS INTEGER FORMAT ">>>>>>>>" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-seq-ini AS INTEGER FORMAT "99999999" INITIAL 0 
     LABEL "Sequˆncia":R17 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE fi-cred-ori-fim AS CHARACTER FORMAT "X" INITIAL "Z" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cred-ori-ini AS CHARACTER FORMAT "X" 
     LABEL "Ind Cred Ori":R17 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dt-refer-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dt-refer-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Dt Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-tp-cr-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-tp-cr-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Tipo CR":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-imposto AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "PIS", 1,
"COFINS", 2,
"AMBOS", 3
     SIZE 34.86 BY .75 NO-UNDO.

DEFINE VARIABLE fi-contrib-fim AS CHARACTER FORMAT "X(4)" INITIAL "ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-contrib-ini AS CHARACTER FORMAT "X(4)" 
     LABEL "contribui‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE fi-apuracao-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-apuracao-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Dt Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-processa 
     LABEL "Exportar" 
     SIZE 21 BY 1.13.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon/exit-au.bmp":U
     LABEL "Sair" 
     SIZE 8 BY 1.13.

DEFINE VARIABLE fi-texto AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 100 BY 1.75 NO-UNDO.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-registro AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 97 BY 1
     FGCOLOR 9 FONT 12 NO-UNDO.

DEFINE VARIABLE fi-acomp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 102 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE rs-acao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "EXPORTAR", 1,
"IMPORTAR", 2
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE rs-registro AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "F100", 1,
"M110/M510", 2,
"M220/M620", 3,
"P100", 4,
"F600", 5
     SIZE 58.14 BY 1
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 1.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 5.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 3.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 1.29.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 7.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 1.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame0
     fi-texto AT ROW 1.5 COL 2.86 NO-LABEL WIDGET-ID 12
     rs-registro AT ROW 4 COL 24 NO-LABEL WIDGET-ID 74
     rs-acao AT ROW 7.96 COL 38.86 NO-LABEL WIDGET-ID 84
     bt-arquivo AT ROW 17.79 COL 69.86 HELP
          "Escolha do nome do arquivo" WIDGET-ID 72
     c-arquivo AT ROW 17.88 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     bt-processa AT ROW 19.79 COL 42 WIDGET-ID 2
     BUTTON-2 AT ROW 19.83 COL 93.86 WIDGET-ID 6
     fi-acomp AT ROW 21.5 COL 2 NO-LABEL WIDGET-ID 32
     c-registro AT ROW 5.38 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     "  FILTRO" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 9.5 COL 48.29 WIDGET-ID 98
     "Arquivo:" VIEW-AS TEXT
          SIZE 6.72 BY .54 AT ROW 17 COL 3.29 WIDGET-ID 96
     " A‡Æo:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 7.25 COL 48.43 WIDGET-ID 90
     "Sele‡Æo de Registro" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 3.5 COL 4 WIDGET-ID 82
     RECT-11 AT ROW 19.54 COL 2 WIDGET-ID 28
     RECT-13 AT ROW 1.25 COL 2 WIDGET-ID 70
     RECT-14 AT ROW 3.75 COL 3 WIDGET-ID 80
     RECT-15 AT ROW 7.71 COL 33.43 WIDGET-ID 88
     RECT-16 AT ROW 9.75 COL 2 WIDGET-ID 92
     RECT-17 AT ROW 17.29 COL 2 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105.43 BY 21.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f4
     fi-emp-ini AT ROW 1.5 COL 24 WIDGET-ID 12
          LABEL "Empresa":R17 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-emp-fim AT ROW 1.46 COL 60.72 NO-LABEL WIDGET-ID 20 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-est-ini AT ROW 2.5 COL 24 WIDGET-ID 30
          LABEL "Estabelec":R17 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-est-fim AT ROW 2.5 COL 60.72 NO-LABEL WIDGET-ID 28 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-apuracao-ini AT ROW 3.5 COL 18.71 WIDGET-ID 4
     fi-apuracao-fim AT ROW 3.5 COL 60.72 NO-LABEL WIDGET-ID 2
     IMAGE-35 AT ROW 1.5 COL 57.14 WIDGET-ID 24
     IMAGE-36 AT ROW 1.5 COL 41.86 WIDGET-ID 26
     IMAGE-37 AT ROW 3.5 COL 41.86 WIDGET-ID 6
     IMAGE-38 AT ROW 3.54 COL 57.29 WIDGET-ID 8
     IMAGE-39 AT ROW 2.54 COL 57.14 WIDGET-ID 32
     IMAGE-40 AT ROW 2.5 COL 41.86 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 10
         SIZE 100 BY 6.5
         FONT 1 WIDGET-ID 500.

DEFINE FRAME f3
     fi-emp-ini AT ROW 1.5 COL 24 WIDGET-ID 12
          LABEL "Empresa":R17 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-emp-fim AT ROW 1.46 COL 60.72 NO-LABEL WIDGET-ID 20 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     rs-imposto AT ROW 2.58 COL 35.14 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "PIS", 1,
"COFINS", 2,
"AMBOS", 3
          SIZE 34.86 BY .75
     fi-dt-refer-ini AT ROW 3.5 COL 18.71 WIDGET-ID 4
          LABEL "Dt Referˆncia" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          FONT 1
     fi-dt-refer-fim AT ROW 3.5 COL 60.72 NO-LABEL WIDGET-ID 2 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
          FONT 1
     fi-contrib-ini AT ROW 4.5 COL 23.71 WIDGET-ID 36
     fi-contrib-fim AT ROW 4.46 COL 60.72 NO-LABEL WIDGET-ID 34
     IMAGE-29 AT ROW 1.5 COL 57.14 WIDGET-ID 24
     IMAGE-30 AT ROW 1.5 COL 41.86 WIDGET-ID 26
     IMAGE-31 AT ROW 3.5 COL 41.86 WIDGET-ID 6
     IMAGE-32 AT ROW 3.54 COL 57.29 WIDGET-ID 8
     IMAGE-33 AT ROW 4.5 COL 57.14 WIDGET-ID 38
     IMAGE-34 AT ROW 4.5 COL 41.86 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 10
         SIZE 100 BY 6.5
         FONT 1 WIDGET-ID 400.

DEFINE FRAME f2
     fi-emp-ini AT ROW 1.5 COL 24 WIDGET-ID 12
          LABEL "Empresa":R17 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     fi-emp-fim AT ROW 1.46 COL 60.72 NO-LABEL WIDGET-ID 20 FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
          FONT 1
     rs-imposto AT ROW 2.58 COL 35.14 NO-LABEL WIDGET-ID 28
     fi-dt-refer-ini AT ROW 3.5 COL 18.71 WIDGET-ID 4
     fi-dt-refer-fim AT ROW 3.5 COL 60.72 NO-LABEL WIDGET-ID 2
     fi-tp-cr-ini AT ROW 4.5 COL 24.28 WIDGET-ID 36
     fi-tp-cr-fim AT ROW 4.46 COL 60.72 NO-LABEL WIDGET-ID 34
     fi-cred-ori-ini AT ROW 5.46 COL 27 WIDGET-ID 44
     fi-cred-ori-fim AT ROW 5.42 COL 60.72 NO-LABEL WIDGET-ID 42
     "Imposto:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.67 COL 28.72 WIDGET-ID 32
     IMAGE-21 AT ROW 1.5 COL 57.14 WIDGET-ID 24
     IMAGE-22 AT ROW 1.5 COL 41.86 WIDGET-ID 26
     IMAGE-23 AT ROW 3.5 COL 41.86 WIDGET-ID 6
     IMAGE-24 AT ROW 3.54 COL 57.29 WIDGET-ID 8
     IMAGE-25 AT ROW 4.5 COL 57.14 WIDGET-ID 38
     IMAGE-26 AT ROW 4.5 COL 41.86 WIDGET-ID 40
     IMAGE-27 AT ROW 5.46 COL 57.14 WIDGET-ID 46
     IMAGE-28 AT ROW 5.46 COL 41.86 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 10
         SIZE 100 BY 6.5
         FONT 1 WIDGET-ID 300.

DEFINE FRAME f1
     fi-emp-ini AT ROW 1.5 COL 24 WIDGET-ID 12
     fi-emp-fim AT ROW 1.5 COL 60.72 NO-LABEL WIDGET-ID 20
     fi-est-ini AT ROW 2.5 COL 24 WIDGET-ID 30
     fi-est-fim AT ROW 2.5 COL 60.72 NO-LABEL WIDGET-ID 28
     fi-dat-ini AT ROW 3.5 COL 17.14 WIDGET-ID 4
     fi-dat-fim AT ROW 3.5 COL 60.72 NO-LABEL WIDGET-ID 2
     fi-seq-ini AT ROW 4.5 COL 21.15 WIDGET-ID 38
     fi-seq-fim AT ROW 4.5 COL 60.72 NO-LABEL WIDGET-ID 44
     IMAGE-1 AT ROW 3.58 COL 41.86 WIDGET-ID 6
     IMAGE-2 AT ROW 3.54 COL 57.29 WIDGET-ID 8
     IMAGE-15 AT ROW 1.54 COL 57.14 WIDGET-ID 24
     IMAGE-16 AT ROW 1.58 COL 41.86 WIDGET-ID 26
     IMAGE-17 AT ROW 2.54 COL 57.14 WIDGET-ID 32
     IMAGE-18 AT ROW 2.58 COL 41.86 WIDGET-ID 34
     IMAGE-19 AT ROW 4.5 COL 57.29 WIDGET-ID 40
     IMAGE-20 AT ROW 4.54 COL 41.86 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 10
         SIZE 100 BY 6.5
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Exporta‡Æo EMS2 - Saneamento PIS/COFINS"
         HEIGHT             = 21.58
         WIDTH              = 104
         MAX-HEIGHT         = 31.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 31.21
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f1:FRAME = FRAME frame0:HANDLE
       FRAME f2:FRAME = FRAME frame0:HANDLE
       FRAME f3:FRAME = FRAME frame0:HANDLE
       FRAME f4:FRAME = FRAME frame0:HANDLE.

/* SETTINGS FOR FRAME f1
   FRAME-NAME 1                                                         */
/* SETTINGS FOR FILL-IN fi-dat-fim IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dat-ini IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-fim IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-ini IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-est-fim IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-est-ini IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-seq-fim IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-seq-ini IN FRAME f1
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME f2
   1 Custom                                                             */
/* SETTINGS FOR FILL-IN fi-cred-ori-fim IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cred-ori-ini IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dt-refer-fim IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dt-refer-ini IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-fim IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-ini IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-tp-cr-fim IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-tp-cr-ini IN FRAME f2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME f3
   1 Custom                                                             */
/* SETTINGS FOR FILL-IN fi-contrib-fim IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-contrib-ini IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dt-refer-fim IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dt-refer-ini IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-fim IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-ini IN FRAME f3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME f4
   1 Custom                                                             */
/* SETTINGS FOR FILL-IN fi-apuracao-fim IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-apuracao-ini IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-fim IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-emp-ini IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-est-fim IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-est-ini IN FRAME f4
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME frame0
                                                                        */
/* SETTINGS FOR FILL-IN c-registro IN FRAME frame0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-acomp IN FRAME frame0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi-texto:AUTO-INDENT IN FRAME frame0      = TRUE
       fi-texto:READ-ONLY IN FRAME frame0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Exporta‡Æo EMS2 - Saneamento PIS/COFINS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Exporta‡Æo EMS2 - Saneamento PIS/COFINS */
DO:
  /* This event will close the window and terminate the procedure.  */

IF  NOT VALID-HANDLE(h-fibo387) THEN
    RUN destroy IN h-fibo387.     

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame0
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME frame0
DO:
    def var cArqConv  as char no-undo.
    DEF VAR l-ok AS LOG NO-UNDO.
    assign cArqConv = replace(input frame frame0 c-arquivo, "/":U, "\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.xls":U "*.xlsx":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "xls":U
       INITIAL-DIR session:temp-directory
       TITLE "Arquivo de Bens do MRI":U
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-arquivo = replace(cArqConv, "\":U, "/":U).
        display c-arquivo with frame frame0.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-processa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-processa C-Win
ON CHOOSE OF bt-processa IN FRAME frame0 /* Exportar */
DO:
    
    DEF VAR c-opcao AS CHAR NO-UNDO.
    CASE rs-registro:SCREEN-VALUE:
        WHEN "1" THEN ASSIGN c-opcao = "F100".
        WHEN "2" THEN ASSIGN c-opcao = "M110/M510".
        WHEN "3" THEN ASSIGN c-opcao = "M220/M620".
        WHEN "4" THEN ASSIGN c-opcao = "P100".
        WHEN "5" THEN ASSIGN c-opcao = "F600".

    END CASE.

    IF INPUT FRAME frame0 rs-Acao = 1 THEN DO:
        FILE-INFO:FILE-NAME = REPLACE(INPUT FRAME frame0 c-Arquivo, ENTRY(NUM-ENTRIES(INPUT FRAME frame0 c-Arquivo, "~\":U), INPUT FRAME frame0 c-Arquivo, "~\":U), "":U).

        IF FILE-INFO:FULL-PATHNAME           = ?    AND
           FILE-INFO:FULL-PATHNAME           = "":U AND
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN DO:

            APPLY "ENTRY":U TO c-Arquivo IN FRAME frame0.

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Diret¢rio inv lido!":U +
                                     "~~":U +
                                     "Informe um diret¢rio v lido para a exporta‡Æo do arquivo.":U).

            RETURN NO-APPLY.
        END.
    END.
    
    IF  rs-acao:SCREEN-VALUE = "2" THEN DO:
        
        /* Verificar se o arquivo informado existe */
        IF  SEARCH(c-arquivo:SCREEN-VALUE) = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Arquivo informado nÆo existe.").
            RETURN NO-APPLY.
        END.

        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 27100,
                          INPUT "Confirma Importa‡Æo dos dados do arquivo para o registro " + c-opcao +  " SPED selecionado?" + "~~" +
                                "") .
    
        IF  RETURN-VALUE = "no":U THEN
            RETURN NO-APPLY.


        CASE rs-registro:SCREEN-VALUE:
            WHEN "1" THEN
                RUN pi-importa-F100     (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "2" THEN
                RUN pi-importa-M110-510 (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "3" THEN
                RUN pi-importa-M220-620 (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "4" THEN
                RUN pi-importa-P100     (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "5" THEN
                RUN pi-importa-F600     (INPUT c-arquivo:SCREEN-VALUE).
        END CASE.

    END.
    ELSE DO:
        CASE rs-registro:SCREEN-VALUE:
            WHEN "1" THEN 
                RUN pi-exporta-F100     (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "2" THEN
                RUN pi-exporta-M110-510 (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "3" THEN
                RUN pi-exporta-M220-620 (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "4" THEN 
                RUN pi-exporta-P100     (INPUT c-arquivo:SCREEN-VALUE).
            WHEN "5" THEN 
                RUN pi-exporta-F600     (INPUT c-arquivo:SCREEN-VALUE).

        END CASE.
    END.

    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME frame0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f4
&Scoped-define SELF-NAME fi-apuracao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-apuracao-ini C-Win
ON LEAVE OF fi-apuracao-ini IN FRAME f4 /* Dt Referˆncia */
DO:
  IF  INPUT FRAME f4 fi-apuracao-ini <> ? THEN DO:

/*       DEF VAR da-aux AS DATE NO-UNDO.                                               */
/*                                                                                     */
/*       da-aux = INPUT FRAME f4 fi-apuracao-ini.                                      */
/*       da-aux = DATE (STRING(MONTH(da-aux)) + "/25/" + string(YEAR(da-aux))) + 10.   */
/*                                                                                     */
/*       MESSAGE da-aux                                                                */
/*           VIEW-AS ALERT-BOX INFO BUTTONS OK.                                        */
/*       da-aux = DATE ( STRING(MONTH(da-aux)) + "/01/" + STRING(YEAR(da-aux) ) ) - 1. */
/*                                                                                     */
/*       MESSAGE da-aux                                                                */
/*           VIEW-AS ALERT-BOX INFO BUTTONS OK.                                        */
/*                                                                                     */
/*       fi-apuracao-fim:SCREEN-VALUE = STRING(da-aux).                                */

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frame0
&Scoped-define SELF-NAME rs-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-acao C-Win
ON VALUE-CHANGED OF rs-acao IN FRAME frame0
DO:
    IF  rs-acao:SCREEN-VALUE = "1" THEN DO:
        ENABLE ALL WITH FRAME f1.
        ENABLE ALL WITH FRAME f2.
        ENABLE ALL WITH FRAME f3.
        ENABLE ALL WITH FRAME f4.
        bt-processa:LABEL = "Exportar".

        APPLY "value-changed" TO rs-registro.
    END.
    ELSE DO:
        DISABLE ALL WITH FRAME f1.
        DISABLE ALL WITH FRAME f2.
        DISABLE ALL WITH FRAME f3.
        DISABLE ALL WITH FRAME f4.
        bt-processa:LABEL = "Importar".
        c-arquivo:SCREEN-VALUE = "".
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-registro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-registro C-Win
ON VALUE-CHANGED OF rs-registro IN FRAME frame0
DO:
  
    CASE INT(rs-registro:SCREEN-VALUE):
        WHEN 1 THEN DO:
            ASSIGN c-registro:SCREEN-VALUE = "F100 - Demais Doctos e Opera‡äes - (dwf-outros-docoto-operac - mgmov)".
            VIEW FRAME f1.
            HIDE FRAME f2.
            HIDE FRAME f3.
            HIDE FRAME f4.
            ASSIGN c-arquivo:SCREEN-VALUE = SESSION:TEMP-DIRECTORY + "export-F100.xlsx".
        END.

        WHEN 2 THEN DO:
            ASSIGN c-registro:SCREEN-VALUE = "M110 / M510 - Ajustes do Cr‚dido (dwf-ajust-cr-apurad - mgmov)".
            VIEW FRAME f2.
            HIDE FRAME f1.
            HIDE FRAME f3.
            HIDE FRAME f4.
            ASSIGN c-arquivo:SCREEN-VALUE = SESSION:TEMP-DIRECTORY + "export-M110-M510.xlsx".
        END.

        WHEN 3 THEN DO:
            ASSIGN c-registro:SCREEN-VALUE = "M220 / M620 - Detalhamento da CO - (dwf-detmnto-contrib - mgmov)".
            VIEW FRAME f3.
            HIDE FRAME f1.
            HIDE FRAME f2.
            HIDE FRAME f4.
            ASSIGN c-arquivo:SCREEN-VALUE = SESSION:TEMP-DIRECTORY + "export-M220-M620.xlsx".
        END.

        WHEN 4 THEN DO:
            ASSIGN c-registro:SCREEN-VALUE = "P100 - Contrib Previd Recta Brut (dwt-contrib-previd-recta - mgmov)".
            VIEW FRAME f4.
            HIDE FRAME f1.
            HIDE FRAME f2.
            HIDE FRAME f3.
            ASSIGN c-arquivo:SCREEN-VALUE = SESSION:TEMP-DIRECTORY + "export-P100.xlsx".
        END.
        WHEN 5 THEN DO:
            ASSIGN c-registro:SCREEN-VALUE = "F600 - Contrib Retida na Fonte)".
            VIEW FRAME f4.
            HIDE FRAME f1.
            HIDE FRAME f2.
            HIDE FRAME f3.
            ASSIGN c-arquivo:SCREEN-VALUE = SESSION:TEMP-DIRECTORY + "export-F600.xlsx".
        END.
    END CASE.

    IF  rs-acao:SCREEN-VALUE = "2" THEN
        c-arquivo:SCREEN-VALUE = "" .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


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

  ASSIGN fi-texto:SCREEN-VALUE = CHR(13) + "                                                              " + 
                                            " Programa para EXPORTA€ÇO/IMPORTA€ÇO de Registros SPED ".
  

  ASSIGN fi-dat-ini:SCREEN-VALUE IN FRAME f1 = STRING(MONTH(TODAY)) +
                                               "/01/" + 
                                               STRING(YEAR(TODAY)).

  ASSIGN fi-dt-refer-ini:SCREEN-VALUE IN FRAME f2 = fi-dat-ini:SCREEN-VALUE IN FRAME f1
         fi-dt-refer-ini:SCREEN-VALUE IN FRAME f3 = fi-dat-ini:SCREEN-VALUE IN FRAME f1
         fi-apuracao-ini:SCREEN-VALUE IN FRAME f4 = fi-dat-ini:SCREEN-VALUE IN FRAME f1.

  APPLY "value-changed" TO rs-registro IN FRAME frame0.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fi-texto rs-registro rs-acao c-arquivo fi-acomp c-registro 
      WITH FRAME frame0 IN WINDOW C-Win.
  ENABLE RECT-11 RECT-13 RECT-14 RECT-15 RECT-16 RECT-17 fi-texto rs-registro 
         rs-acao bt-arquivo c-arquivo bt-processa BUTTON-2 
      WITH FRAME frame0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frame0}
  DISPLAY fi-emp-ini fi-emp-fim fi-est-ini fi-est-fim fi-dat-ini fi-dat-fim 
          fi-seq-ini fi-seq-fim 
      WITH FRAME f1 IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20 
         fi-emp-ini fi-emp-fim fi-est-ini fi-est-fim fi-dat-ini fi-dat-fim 
         fi-seq-ini fi-seq-fim 
      WITH FRAME f1 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f1}
  DISPLAY fi-emp-ini fi-emp-fim rs-imposto fi-dt-refer-ini fi-dt-refer-fim 
          fi-tp-cr-ini fi-tp-cr-fim fi-cred-ori-ini fi-cred-ori-fim 
      WITH FRAME f2 IN WINDOW C-Win.
  ENABLE fi-emp-ini fi-emp-fim rs-imposto fi-dt-refer-ini fi-dt-refer-fim 
         fi-tp-cr-ini fi-tp-cr-fim fi-cred-ori-ini fi-cred-ori-fim IMAGE-21 
         IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 
      WITH FRAME f2 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f2}
  DISPLAY fi-emp-ini fi-emp-fim rs-imposto fi-dt-refer-ini fi-dt-refer-fim 
          fi-contrib-ini fi-contrib-fim 
      WITH FRAME f3 IN WINDOW C-Win.
  ENABLE fi-emp-ini fi-emp-fim rs-imposto fi-dt-refer-ini fi-dt-refer-fim 
         fi-contrib-ini fi-contrib-fim IMAGE-29 IMAGE-30 IMAGE-31 IMAGE-32 
         IMAGE-33 IMAGE-34 
      WITH FRAME f3 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f3}
  DISPLAY fi-emp-ini fi-emp-fim fi-est-ini fi-est-fim fi-apuracao-ini 
          fi-apuracao-fim 
      WITH FRAME f4 IN WINDOW C-Win.
  ENABLE fi-emp-ini fi-emp-fim fi-est-ini fi-est-fim fi-apuracao-ini 
         fi-apuracao-fim IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 IMAGE-39 IMAGE-40 
      WITH FRAME f4 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f4}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-excel C-Win 
PROCEDURE pi-abre-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pArquivo AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        CREATE "Excel.Application":U chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "":U.

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "":U THEN "":U ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a importa‡Æo dos dados no Microsoft Excel.":U +
                                 "~~":U +
                                 "Erros encontrados:":U + CHR(10) + cMensagem).

        RETURN "NOK":U.
    END.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/":U, "~\":U)).

    chPasta = chExcel:WorkBooks:Open(cArqAux,,YES) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        RELEASE OBJECT chPasta NO-ERROR.
        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Ocorreram problemas ao abrir o arquivo.":U).

        RETURN "NOK":U.
    END.

    chPlanilha = chPasta:WorkSheets:Item(1):Activate.
    chExcel:Visible = NO.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-f100 C-Win 
PROCEDURE pi-exporta-f100 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.

    DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

    DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatus    AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a exporta‡Æo dos dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Exportando dados...").

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    chExcel:ScreenUpdating = NO.
    chExcel:SheetsInNewWorkbook = 1.
    chPasta = chExcel:Workbooks:Add().
    chPasta:Sheets:Item(1):Name = "F100".
    chPlanilha = chPasta:Sheets:Item(1).

    ASSIGN iLinha = 1.

    /*************************************** FORMATA CABE€ALHO  ********************************/
    chPlanilha:Range("A" + STRING(iLinha)):Value = "Empresa".
    chPlanilha:Range("B" + STRING(iLinha)):Value = "Estabelecimento".
    chPlanilha:Range("C" + STRING(iLinha)):Value = "Data de Transa‡Æo".
    chPlanilha:Range("D" + STRING(iLinha)):Value = "Seg Ident Registro".
    chPlanilha:Range("E" + STRING(iLinha)):Value = "Tipo Opera‡Æo".
    chPlanilha:Range("F" + STRING(iLinha)):Value = "Participante".
    chPlanilha:Range("G" + STRING(iLinha)):Value = "Item".
    chPlanilha:Range("H" + STRING(iLinha)):Value = "Data Opera‡Æo".
    chPlanilha:Range("I" + STRING(iLinha)):Value = "Valor Opera‡Æo".
    chPlanilha:Range("J" + STRING(iLinha)):Value = "Sit. Tributaria PIS".
    chPlanilha:Range("K" + STRING(iLinha)):Value = "Base PIS".
    chPlanilha:Range("L" + STRING(iLinha)):Value = "% PIS".   
    chPlanilha:Range("M" + STRING(iLinha)):Value = "Valor PIS".
    chPlanilha:Range("N" + STRING(iLinha)):Value = "Sit. Tributaria COFINS".
    chPlanilha:Range("O" + STRING(iLinha)):Value = "Base Calculo COFINS".           
    chPlanilha:Range("P" + STRING(iLinha)):Value = "% CONFINS".              
    chPlanilha:Range("Q" + STRING(iLinha)):Value = "COFINS".          
    chPlanilha:Range("R" + STRING(iLinha)):Value = "Natur. Base Caulc. CR".
    chPlanilha:Range("S" + STRING(iLinha)):Value = "Origem".
    chPlanilha:Range("T" + STRING(iLinha)):Value = "Conta Contabil".          
    chPlanilha:Range("U" + STRING(iLinha)):Value = "Centro de Custo".
    chPlanilha:Range("V" + STRING(iLinha)):Value = "DescrisÆo".

    chPlanilha:Range("A1:D1"):Interior:Color = 255.
    chPlanilha:Range("E1:V1"):Interior:COLOR = 5296274.

    chPlanilha:Columns("A:A"):NumberFormat = "@".                   /* Empresa                          */
    chPlanilha:Columns("B:B"):NumberFormat = "@".                   /* Estabelecimento                  */
    chPlanilha:Columns("C:C"):NumberFormat = "dd/mm/aaaa" .         /* Data de Transa‡Æo                */
    chPlanilha:Columns("D:D"):NumberFormat = "@".                   /* Seg Ident Registro               */
    chPlanilha:Columns("E:E"):NumberFormat = "@".                   /* Indicador Tipo da Opera‡Æo       */
    chPlanilha:Columns("F:F"):NumberFormat = "@".                   /* Participante                     */
    chPlanilha:Columns("G:G"):NumberFormat = "@".                   /* ITEM                             */
    chPlanilha:Columns("H:H"):NumberFormat = "dd/mm/aaaa".          /* Data Opera‡Æo                    */
    chPlanilha:Columns("I:I"):NumberFormat = "##0,00".              /* Valor Opera‡Æo                   */
    chPlanilha:Columns("J:J"):NumberFormat = "@".                   /* SituacÆo Tributaria PIS          */
    chPlanilha:Columns("K:K"):NumberFormat = "##0,00".              /* Valor Base Calculo               */
    chPlanilha:Columns("L:L"):NumberFormat = "##0,00".              /* Al¡quota PIS                     */
    chPlanilha:Columns("M:M"):NumberFormat = "##0,00".              /* Valor DO PIS                     */
    chPlanilha:Columns("N:N"):NumberFormat = "@".                   /* Situa‡Æo Tributaria COFINS       */
    chPlanilha:Columns("O:O"):NumberFormat = "##0,00".              /* Base de Calc. COFINS             */
    chPlanilha:Columns("P:P"):NumberFormat = "##0,00".              /* Al¡quota COFINS                  */
    chPlanilha:Columns("Q:Q"):NumberFormat = "##0,00".              /* Valor Cofins                     */
    chPlanilha:Columns("R:R"):NumberFormat = "@".                   /* Natureza Base Calculo Cr‚dito    */
    chPlanilha:Columns("S:S"):NumberFormat = "@".                   /* Origem                           */
    chPlanilha:Columns("T:T"):NumberFormat = "@".                   /* Conta Cont bil                   */
    chPlanilha:Columns("U:U"):NumberFormat = "@".                   /* Centro Custo                     */
    chPlanilha:Columns("V:V"):NumberFormat = "@".                   /* Descri‡Æo                        */

    chPlanilha:COLUMNS("A:V"):LOCKED = NO.

    DO WITH FRAME f1:                                        
                                                             
        FOR EACH tabela4 NO-LOCK
            WHERE tabela4.cod-empres         >= fi-emp-ini:SCREEN-VALUE 
              AND tabela4.cod-empres         <= fi-emp-fim:SCREEN-VALUE
              AND tabela4.cod-estab          >= fi-est-ini:SCREEN-VALUE
              AND tabela4.cod-estab          <= fi-est-fim:SCREEN-VALUE
              AND tabela4.dat-trans          >= date(fi-dat-ini:SCREEN-VALUE)
              AND tabela4.dat-trans          <= date(fi-dat-fim:SCREEN-VALUE)
              AND tabela4.num-seq-ident-reg  >= int(fi-seq-ini:SCREEN-VALUE)
              AND tabela4.num-seq-ident-reg  <= int(fi-seq-fim:SCREEN-VALUE):

            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "F100 => " + "Emp: " + tabela4.cod-empres +
                                                    "/Estab: " + tabela4.cod-estab + "/Ref: " + string(tabela4.dat-trans, "99/99/9999")).
    
            ASSIGN iLinha = iLinha + 1.
    
            /************************* FORMATA E ALIMENTA OS CAMPOS DA CHAVE DA TABELA  ***************************/
            chPlanilha:Range("A" + STRING(iLinha)):LOCKED = YES.
            chPlanilha:Range("B" + STRING(iLinha)):LOCKED = YES.
            chPlanilha:Range("C" + STRING(iLinha)):LOCKED = YES.
            chPlanilha:Range("D" + STRING(iLinha)):LOCKED = YES.

            chPlanilha:Range("A" + STRING(iLinha)):Value = TRIM(tabela4.cod-empres).       /* Empresa                 */
            chPlanilha:Range("B" + STRING(iLinha)):Value = TRIM(tabela4.cod-estab).        /* Estabelecimento         */
            chPlanilha:Range("C" + STRING(iLinha)):Value = tabela4.dat-trans.              /* Data de Transa‡Æo       */
            chPlanilha:Range("D" + STRING(iLinha)):Value = tabela4.num-seq-ident-reg.      /* Seg Ident Registro      */
            
            /*********************************** DEMAIS CAMPOS DA TABELA ******************************************/
            
            chPlanilha:Range("E" + STRING(iLinha)):Value = tabela4.cod-indic-operac.        /* Tipo Opera‡Æo           */            
            chPlanilha:Range("F" + STRING(iLinha)):Value = tabela4.cod-participan.          /* Participante            */      
            chPlanilha:Range("G" + STRING(iLinha)):Value = tabela4.cod-item.                /* ITEM                    */
            chPlanilha:Range("H" + STRING(iLinha)):Value = tabela4.dat-operac.              /* Data Opera‡Æo           */
            chPlanilha:Range("I" + STRING(iLinha)):Value = tabela4.val-operac.              /* Valor Opera‡Æo          */
            chPlanilha:Range("J" + STRING(iLinha)):Value = tabela4.cod-sit-tributar-pis.    /* Sit. Tributaria PIS     */
            chPlanilha:Range("K" + STRING(iLinha)):Value = tabela4.val-base-calc-pis.       /* Base PIS                */
            chPlanilha:Range("L" + STRING(iLinha)):Value = tabela4.val-aliq-pis.            /* % PIS                   */
            chPlanilha:Range("M" + STRING(iLinha)):Value = tabela4.val-pis.                 /* Valor PIS               */
            chPlanilha:Range("N" + STRING(iLinha)):Value = tabela4.cod-sit-tributar-cofins. /* Sit. Tributaria COFINS" */
            chPlanilha:Range("O" + STRING(iLinha)):Value = tabela4.val-base-calc-cofins.    /* Base Calculo COFINS     */
            chPlanilha:Range("P" + STRING(iLinha)):Value = tabela4.val-aliq-cofins.         /* % CONFINS               */
            chPlanilha:Range("Q" + STRING(iLinha)):Value = tabela4.val-cofins.              /* COFINS                  */
            chPlanilha:Range("R" + STRING(iLinha)):Value = tabela4.cod-nat-base-calc-cr.    /* Natur. Base Caulc. CR   */
            chPlanilha:Range("S" + STRING(iLinha)):Value = tabela4.ind-orig.                /* Origem                  */
            chPlanilha:Range("T" + STRING(iLinha)):Value = tabela4.cod-cta-ctbl.            /* Conta Contabil          */
            chPlanilha:Range("U" + STRING(iLinha)):Value = tabela4.cod-ccusto.              /* Centro de Custo         */
            chPlanilha:Range("V" + STRING(iLinha)):Value = tabela4.des-operac.              /* DescrisÆo               */

            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("H" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("I" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("J" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("K" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("L" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("M" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("N" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("O" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("P" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("Q" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("R" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("S" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("T" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("U" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("V" + STRING(iLinha)):LOCKED = NO.
        
        END.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    chPlanilha:Range("A1:V1"):Font:Bold = YES.
    chPlanilha:Range("A1:V1"):AutoFilter(,,).
    chPlanilha:Columns("A:V"):Autofit.

    chPlanilha:Protect("intelbras",YES,YES,YES,NO,NO,NO,NO,NO,YES,NO,NO,YES,NO,YES,YES).

    chExcel:DisplayAlerts = NO.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/", "\")).

    IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xls" THEN
        chPlanilha:SaveAs(cArqAux, "56",,,,,) NO-ERROR.
    ELSE IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xlsx" THEN
        chPlanilha:SaveAs(cArqAux,,,,,,) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao salvar os dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    chExcel:WindowState = 2.
    chExcel:Visible = NO.
    chExcel:Quit().

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo gerado com sucesso!" +
                             "~~" +
                             "Caminho para o arquivo: " + cArqAux).

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-F600 C-Win 
PROCEDURE pi-exporta-F600 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.

    DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

    DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatus    AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a exporta‡Æo dos dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Exportando dados...").

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    chExcel:ScreenUpdating = NO.
    chExcel:SheetsInNewWorkbook = 1.
    chPasta = chExcel:Workbooks:Add().
    chPasta:Sheets:Item(1):Name = "F600".
    chPlanilha = chPasta:Sheets:Item(1).

    ASSIGN iLinha = 1.

    /*************************************** FORMATA CABE€ALHO  ********************************/
    chPlanilha:Range("A" + STRING(iLinha)):Value = "Empresa".
    chPlanilha:Range("B" + STRING(iLinha)):Value = "Estabelecimento".
    chPlanilha:Range("C" + STRING(iLinha)):Value = "Data Transa‡Æo".
    chPlanilha:Range("D" + STRING(iLinha)):Value = "Sequencia".
    chPlanilha:Range("E" + STRING(iLinha)):Value = "Grupo".
    chPlanilha:Range("F" + STRING(iLinha)):Value = "Cliente".
    chPlanilha:Range("G" + STRING(iLinha)):Value = "Indic Nat Ret".
    chPlanilha:Range("H" + STRING(iLinha)):Value = "Receb Retenc".
    chPlanilha:Range("I" + STRING(iLinha)):Value = "Vl Recebido".
    chPlanilha:Range("J" + STRING(iLinha)):Value = "Retido Fonte".
    chPlanilha:Range("K" + STRING(iLinha)):Value = "Cod Receita".
    chPlanilha:Range("L" + STRING(iLinha)):Value = "Indic Nat Rec".
    chPlanilha:Range("M" + STRING(iLinha)):Value = "CNPJ".
    chPlanilha:Range("N" + STRING(iLinha)):Value = "Retido PIS".
    chPlanilha:Range("O" + STRING(iLinha)):Value = "Retido Cofins".
    chPlanilha:Range("P" + STRING(iLinha)):Value = "Condi‡Æo".

    chPlanilha:Range("A1:D1"):Interior:Color = 255.
    chPlanilha:Range("E1:P1"):Interior:COLOR = 5296274. 

    chPlanilha:Range("A" + STRING(iLinha)):NumberFormat = "#".         
    chPlanilha:Range("B" + STRING(iLinha)):NumberFormat = "###".       
    chPlanilha:Range("C" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa". 
    chPlanilha:Range("D" + STRING(iLinha)):NumberFormat = "#######0".  
    chPlanilha:Range("E" + STRING(iLinha)):NumberFormat = "@".  
    chPlanilha:Range("F" + STRING(iLinha)):NumberFormat = "#######0".  
    chPlanilha:Range("G" + STRING(iLinha)):NumberFormat = "#######0".   
    chPlanilha:Range("H" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa" .
    chPlanilha:Range("I" + STRING(iLinha)):NumberFormat = "##0,00".    
    chPlanilha:Range("J" + STRING(iLinha)):NumberFormat = "##0,00".    
    chPlanilha:Range("K" + STRING(iLinha)):NumberFormat = "#######0".   
    chPlanilha:Range("L" + STRING(iLinha)):NumberFormat = "#######0".   
    chPlanilha:Range("M" + STRING(iLinha)):NumberFormat = "@".         
    chPlanilha:Range("N" + STRING(iLinha)):NumberFormat = "##0,00".    
    chPlanilha:Range("O" + STRING(iLinha)):NumberFormat = "##0,00".    
    chPlanilha:Range("P" + STRING(iLinha)):NumberFormat = "#######0".      

    chPlanilha:COLUMNS("A:N"):LOCKED = NO.

    DO WITH FRAME f4:
            
        FOR EACH tabela5 NO-LOCK
            WHERE tabela5.cod-empres         >= fi-emp-ini:SCREEN-VALUE 
              AND tabela5.cod-empres         <= fi-emp-fim:SCREEN-VALUE
              AND tabela5.cod-estab          >= fi-est-ini:SCREEN-VALUE 
              AND tabela5.cod-estab          <= fi-est-fim:SCREEN-VALUE 
              AND tabela5.dat-trans          >= date(fi-apuracao-ini:SCREEN-VALUE)
              AND tabela5.dat-trans          <= date(fi-apuracao-fim:SCREEN-VALUE):
              
            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "P100 => " + "Emp: " + tabela5.cod-empres +
                                                    "/Estab: " + tabela5.cod-estab + "/Ref: de " + string(tabela5.dat-trans, "99/99/9999") ).
    
            ASSIGN iLinha = iLinha + 1.
    
            /************************* FORMATA E ALIMENTA OS CAMPOS DA CHAVE DA TABELA  ***************************/
            chPlanilha:Range("A" + STRING(iLinha)):LOCKED = YES.
            chPlanilha:Range("B" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("C" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("D" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = YES. 
            
            chPlanilha:Range("A" + STRING(iLinha)):Value = TRIM(tabela5.cod-empres).             
            chPlanilha:Range("B" + STRING(iLinha)):Value = TRIM(tabela5.cod-estab).              
            chPlanilha:Range("C" + STRING(iLinha)):Value = (tabela5.dat-trans).                  
            chPlanilha:Range("D" + STRING(iLinha)):Value = (tabela5.num-seq-ident-reg).           
            chPlanilha:Range("E" + STRING(iLinha)):Value = (tabela5.cod-grp).                 
            chPlanilha:Range("F" + STRING(iLinha)):Value = (tabela5.cod-emitente).                   
            chPlanilha:Range("G" + STRING(iLinha)):Value = (tabela5.cod-indic-natur-retenc).               
            chPlanilha:Range("H" + STRING(iLinha)):Value = (tabela5.dat-recebto-retenc).          
            chPlanilha:Range("I" + STRING(iLinha)):Value = (tabela5.val-recbdo).  
            chPlanilha:Range("J" + STRING(iLinha)):Value = (tabela5.val-retid-fonte).
            chPlanilha:Range("K" + STRING(iLinha)):Value = (tabela5.cod-recta).               
            chPlanilha:Range("L" + STRING(iLinha)):Value = (tabela5.cod-indic-natur-recta).           
            chPlanilha:Range("M" + STRING(iLinha)):Value = (tabela5.cod-cnpj).         
            chPlanilha:Range("N" + STRING(iLinha)):Value = (tabela5.val-retid-pis).   
            chPlanilha:Range("O" + STRING(iLinha)):Value = (tabela5.val-retid-cofins).         
            chPlanilha:Range("P" + STRING(iLinha)):Value = (tabela5.cod-livre-2).   

            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = no. 
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("H" + STRING(iLinha)):LOCKED = no. 
            chPlanilha:Range("I" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("J" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("K" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("L" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("M" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("N" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("O" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("P" + STRING(iLinha)):LOCKED = no.


        END.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    chPlanilha:Range("A1:N1"):Font:Bold = YES.
    chPlanilha:Range("A1:N1"):AutoFilter(,,).
    chPlanilha:Columns("A:N"):Autofit.

    chPlanilha:Protect("intelbras",YES,YES,YES,NO,NO,NO,NO,NO,YES,NO,NO,YES,NO,YES,YES).

    chExcel:DisplayAlerts = NO.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/", "\")).

    IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xls" THEN
        chPlanilha:SaveAs(cArqAux, "56",,,,,) NO-ERROR.
    ELSE IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xlsx" THEN
        chPlanilha:SaveAs(cArqAux,,,,,,) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao salvar os dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    chExcel:WindowState = 2.
    chExcel:Visible = NO.
    chExcel:Quit().

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo gerado com sucesso!" +
                             "~~" +
                             "Caminho para o arquivo: " + cArqAux).

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-M110-510 C-Win 
PROCEDURE pi-exporta-M110-510 :
/*------------------------------------------------------------------------------
  Purpose:     Exporta‡Æo do registro M110 e M510 do SPED
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.

    DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

    DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatus    AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a exporta‡Æo dos dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Exportando dados...").

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    chExcel:ScreenUpdating = NO.
    chExcel:SheetsInNewWorkbook = 1.
    chPasta = chExcel:Workbooks:Add().
    chPasta:Sheets:Item(1):Name = "M110-M510".
    chPlanilha = chPasta:Sheets:Item(1).

    ASSIGN iLinha = 1.

    /*************************************** FORMATA CABE€ALHO  ********************************/
    chPlanilha:Range("A" + STRING(iLinha)):Value = "Empresa".
    chPlanilha:Range("B" + STRING(iLinha)):Value = "Imposto".
    chPlanilha:Range("C" + STRING(iLinha)):Value = "Dt Referˆncia".
    chPlanilha:Range("D" + STRING(iLinha)):Value = "Tipo CR".
    chPlanilha:Range("E" + STRING(iLinha)):Value = "Ind Cred Ori".
    chPlanilha:Range("F" + STRING(iLinha)):Value = "Aliq".
    chPlanilha:Range("G" + STRING(iLinha)):Value = "Qtd. Al¡qutoa Imposto".
    chPlanilha:Range("H" + STRING(iLinha)):Value = "Ind Aj".
    chPlanilha:Range("I" + STRING(iLinha)):Value = "Cod Aj".
    chPlanilha:Range("J" + STRING(iLinha)):Value = "Documento".
    chPlanilha:Range("K" + STRING(iLinha)):Value = "Valor Ajuste".
    chPlanilha:Range("L" + STRING(iLinha)):Value = "Descri‡Æo Ajuste".   

    chPlanilha:Range("A1:J1"):Interior:Color = 255.
    chPlanilha:Range("K1:L1"):Interior:COLOR = 5296274. 
    
    chPlanilha:Range("A" + STRING(iLinha)):NumberFormat = "@".                  /* Empresa */
    chPlanilha:Range("B" + STRING(iLinha)):NumberFormat = "@".                  /* Imposto */
    chPlanilha:Range("C" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa" .        /* Data Referˆncia */
    chPlanilha:Range("D" + STRING(iLinha)):NumberFormat = "@".                  /* Tipo CR */ 
    chPlanilha:Range("E" + STRING(iLinha)):NumberFormat = "@".                  /* Ind Cred Orig */
    chPlanilha:Range("F" + STRING(iLinha)):NumberFormat = "##0,0000".           /* Aliq */
    chPlanilha:Range("G" + STRING(iLinha)):NumberFormat = "##########0,00".     /* Qtd. Al¡qutoa Imposto */
    chPlanilha:Range("H" + STRING(iLinha)):NumberFormat = "@".                  /* Ind Aj */
    chPlanilha:Range("I" + STRING(iLinha)):NumberFormat = "@".                  /* Cod Aj */
    chPlanilha:Range("J" + STRING(iLinha)):NumberFormat = "@".                  /* Documento */
    chPlanilha:Range("K" + STRING(iLinha)):NumberFormat = "##0.00".             /* Valor do Ajuste */  
    chPlanilha:Range("L" + STRING(iLinha)):NumberFormat = "@".                  /* Descri‡Æo */        
            
    chPlanilha:COLUMNS("A:L"):LOCKED = NO.

    DO WITH FRAME f2:
            
        FOR EACH tabela1 NO-LOCK
            WHERE tabela1.cod-empres >= fi-emp-ini:SCREEN-VALUE 
              AND tabela1.cod-empres <= fi-emp-fim:SCREEN-VALUE
              AND (IF rs-imposto:SCREEN-VALUE = "1" THEN 
                     tabela1.cod-impto = "PIS"
                  ELSE IF rs-imposto:SCREEN-VALUE = "2" THEN 
                          tabela1.cod-impto = "COFINS"
                       ELSE YES)
              AND tabela1.dat-refer    >= date(fi-dt-refer-ini:SCREEN-VALUE)
              AND tabela1.dat-refer    <= date(fi-dt-refer-fim:SCREEN-VALUE)
              AND tabela1.cod-cr       >= fi-tp-cr-ini:SCREEN-VALUE
              AND tabela1.cod-cr       <= fi-tp-cr-fim:SCREEN-VALUE
              AND tabela1.cod-indic-cr >= fi-cred-ori-ini:SCREEN-VALUE
              AND tabela1.cod-indic-cr <= fi-cred-ori-fim:SCREEN-VALUE:

            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "M110-510 => " + "Emp: " + tabela1.cod-empres +
                                                    "/Impto: " + tabela1.cod-impto + "/Ref: " + string(tabela1.dat-refer, "99/99/9999")).
    
            ASSIGN iLinha = iLinha + 1.
    
            /************************* FORMATA E ALIMENTA OS CAMPOS DA CHAVE DA TABELA  ***************************/
            chPlanilha:Range("A" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("B" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("C" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("D" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("H" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("I" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("J" + STRING(iLinha)):LOCKED = YES. 
                                                   
            chPlanilha:Range("A" + STRING(iLinha)):Value = TRIM(tabela1.cod-empres).     /* Empresa */              
            chPlanilha:Range("B" + STRING(iLinha)):Value = TRIM(tabela1.cod-impto).      /* Imposto */              
            chPlanilha:Range("C" + STRING(iLinha)):Value = tabela1.dat-Refer.            /* Data Referˆncia */      
            chPlanilha:Range("D" + STRING(iLinha)):Value = tabela1.cod-cr.               /* Tipo CR */              
            chPlanilha:Range("E" + STRING(iLinha)):Value = tabela1.cod-indic-cr.         /* Ind Cred Orig */        
            chPlanilha:Range("F" + STRING(iLinha)):Value = tabela1.val-aliq-impto.       /* Aliq */                 
            chPlanilha:Range("G" + STRING(iLinha)):Value = tabela1.val-quant-aliq-impto. /* Qtd. Al¡qutoa Imposto */
            chPlanilha:Range("H" + STRING(iLinha)):Value = tabela1.cod-indic-ajust.      /* Ind Aj */               
            chPlanilha:Range("I" + STRING(iLinha)):Value = tabela1.cod-ajust.            /* Cod Aj */               
            chPlanilha:Range("J" + STRING(iLinha)):Value = tabela1.cod-num-docto.        /* Documento */            

            /*********************************** DEMAIS CAMPOS DA TABELA ******************************************/
            chPlanilha:Range("K" + STRING(iLinha)):Value = tabela1.val-ajust.        /* Valor do Ajuste */            
            chPlanilha:Range("L" + STRING(iLinha)):Value = tabela1.des-ajust.        /* Descri‡Æo */            

            chPlanilha:Range("K" + STRING(iLinha)):LOCKED = NO.
            chPlanilha:Range("L" + STRING(iLinha)):LOCKED = NO.
        END.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    chPlanilha:Range("A1:L1"):Font:Bold = YES.
    chPlanilha:Range("A1:L1"):AutoFilter(,,).
    chPlanilha:Columns("A:L"):Autofit.

    chPlanilha:Protect("intelbras",YES,YES,YES,NO,NO,NO,NO,NO,YES,NO,NO,YES,NO,YES,YES).

    chExcel:DisplayAlerts = NO.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/", "\")).

    IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xls" THEN
        chPlanilha:SaveAs(cArqAux, "56",,,,,) NO-ERROR.
    ELSE IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xlsx" THEN
        chPlanilha:SaveAs(cArqAux,,,,,,) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao salvar os dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    chExcel:WindowState = 2.
    chExcel:Visible = NO.
    chExcel:Quit().

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo gerado com sucesso!" +
                             "~~" +
                             "Caminho para o arquivo: " + cArqAux).

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-M220-620 C-Win 
PROCEDURE pi-exporta-M220-620 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.

    DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

    DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatus    AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a exporta‡Æo dos dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Exportando dados...").

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    chExcel:ScreenUpdating = NO.
    chExcel:SheetsInNewWorkbook = 1.
    chPasta = chExcel:Workbooks:Add().
    chPasta:Sheets:Item(1):Name = "M220-M620".
    chPlanilha = chPasta:Sheets:Item(1).

    ASSIGN iLinha = 1.

    /*************************************** FORMATA CABE€ALHO  ********************************/
    chPlanilha:Range("A" + STRING(iLinha)):Value = "Empresa".
    chPlanilha:Range("B" + STRING(iLinha)):Value = "Dt Referˆncia".
    chPlanilha:Range("C" + STRING(iLinha)):Value = "Imposto".
    chPlanilha:Range("D" + STRING(iLinha)):Value = "Contribui‡Æo".
    chPlanilha:Range("E" + STRING(iLinha)):Value = "Aliq".
    chPlanilha:Range("F" + STRING(iLinha)):Value = "Qtd. Al¡qutoa Imposto".
    chPlanilha:Range("G" + STRING(iLinha)):Value = "Indic Ajuste".
    chPlanilha:Range("H" + STRING(iLinha)):Value = "Ajuste".
    chPlanilha:Range("I" + STRING(iLinha)):Value = "Documento".
    chPlanilha:Range("J" + STRING(iLinha)):Value = "Vl Ajuste".
    chPlanilha:Range("K" + STRING(iLinha)):Value = "Descri‡Æo Ajuste".   

    chPlanilha:Range("A1:I1"):Interior:Color = 255.
    chPlanilha:Range("J1:K1"):Interior:COLOR = 5296274. 

    chPlanilha:Range("A" + STRING(iLinha)):NumberFormat = "@".                  /* Empresa */
    chPlanilha:Range("B" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa" .        /* Data Referˆncia */
    chPlanilha:Range("C" + STRING(iLinha)):NumberFormat = "@".                  /* Imposto */
    chPlanilha:Range("D" + STRING(iLinha)):NumberFormat = "@".                  /* Contribui‡Æo */ 
    chPlanilha:Range("E" + STRING(iLinha)):NumberFormat = "##0,0000".           /* Aliq */
    chPlanilha:Range("F" + STRING(iLinha)):NumberFormat = "##########0,00".     /* Qtd. Al¡qutoa Imposto */
    chPlanilha:Range("G" + STRING(iLinha)):NumberFormat = "@".                  /* Indic Aj */
    chPlanilha:Range("H" + STRING(iLinha)):NumberFormat = "@".                  /* Ajuste */
    chPlanilha:Range("I" + STRING(iLinha)):NumberFormat = "@".                  /* Documento */
    chPlanilha:Range("J" + STRING(iLinha)):NumberFormat = "##0.00".             /* Valor do Ajuste */                                                                          
    chPlanilha:Range("K" + STRING(iLinha)):NumberFormat = "@".                  /* Descri‡Æo */     

    chPlanilha:COLUMNS("A:K"):LOCKED = NO.

    DO WITH FRAME f3:
            
        FOR EACH tabela2 NO-LOCK
            WHERE tabela2.cod-empres >= fi-emp-ini:SCREEN-VALUE 
              AND tabela2.cod-empres <= fi-emp-fim:SCREEN-VALUE
              AND (IF rs-imposto:SCREEN-VALUE = "1" THEN 
                     tabela2.cod-impto = "PIS"
                  ELSE IF rs-imposto:SCREEN-VALUE = "2" THEN 
                          tabela2.cod-impto = "COFINS"
                       ELSE YES)
              AND tabela2.dat-refer    >= date(fi-dt-refer-ini:SCREEN-VALUE)
              AND tabela2.dat-refer    <= date(fi-dt-refer-fim:SCREEN-VALUE)
              AND tabela2.cod-contrib  >= fi-contrib-ini:SCREEN-VALUE
              AND tabela2.cod-contrib  <= fi-contrib-fim:SCREEN-VALUE:

            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "M220-620 => " + "Emp: " + tabela2.cod-empres +
                                                    "/Imp: " + tabela2.cod-impto + "/Ref: " + string(tabela2.dat-refer, "99/99/9999")).
    
            ASSIGN iLinha = iLinha + 1.
    
            /************************* FORMATA E ALIMENTA OS CAMPOS DA CHAVE DA TABELA  ***************************/
            chPlanilha:Range("A" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("B" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("C" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("D" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("H" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("I" + STRING(iLinha)):LOCKED = YES. 
            
            chPlanilha:Range("A" + STRING(iLinha)):Value = TRIM(tabela2.cod-empres).     /* Empresa */              
            chPlanilha:Range("B" + STRING(iLinha)):Value = tabela2.dat-Refer.            /* Data Referˆncia */      
            chPlanilha:Range("C" + STRING(iLinha)):Value = TRIM(tabela2.cod-impto).      /* Imposto */  
            chPlanilha:Range("D" + STRING(iLinha)):Value = tabela2.cod-contrib.          /* Contribui‡Æo */        
            chPlanilha:Range("E" + STRING(iLinha)):Value = tabela2.val-aliq-impto.       /* Aliq */                 
            chPlanilha:Range("F" + STRING(iLinha)):Value = tabela2.val-quant-aliq-impto. /* Qtd. Al¡qutoa Imposto */
            chPlanilha:Range("G" + STRING(iLinha)):Value = tabela2.cod-indic-ajust.      /* Ind Aj */               
            chPlanilha:Range("H" + STRING(iLinha)):Value = tabela2.cod-ajust.            /* Cod Aj */               
            chPlanilha:Range("I" + STRING(iLinha)):Value = tabela2.cod-num-docto.        /* Documento */            

            /*********************************** DEMAIS CAMPOS DA tabela2 ******************************************/
            chPlanilha:Range("J" + STRING(iLinha)):Value = tabela2.val-ajust.        /* Valor do Ajuste */            
            chPlanilha:Range("K" + STRING(iLinha)):Value = tabela2.des-ajust.        /* Descri‡Æo */            

            chPlanilha:Range("J" + STRING(iLinha)):LOCKED = NO. 
            chPlanilha:Range("K" + STRING(iLinha)):LOCKED = NO. 

        END.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    chPlanilha:Range("A1:K1"):Font:Bold = YES.
    chPlanilha:Range("A1:K1"):AutoFilter(,,).
    chPlanilha:Columns("A:K"):Autofit.

    chPlanilha:Protect("intelbras",YES,YES,YES,NO,NO,NO,NO,NO,YES,NO,NO,YES,NO,YES,YES).

    chExcel:DisplayAlerts = NO.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/", "\")).

    IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xls" THEN
        chPlanilha:SaveAs(cArqAux, "56",,,,,) NO-ERROR.
    ELSE IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xlsx" THEN
        chPlanilha:SaveAs(cArqAux,,,,,,) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao salvar os dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    chExcel:WindowState = 2.
    chExcel:Visible = NO.
    chExcel:Quit().

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo gerado com sucesso!" +
                             "~~" +
                             "Caminho para o arquivo: " + cArqAux).

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-p100 C-Win 
PROCEDURE pi-exporta-p100 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.

    DEFINE VARIABLE chExcel    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPasta    AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE chPlanilha AS COM-HANDLE  NO-UNDO.

    DEFINE VARIABLE cMensagem  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iContMsg   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iLinha     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cStatus    AS CHARACTER   NO-UNDO.

    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao iniciar a exporta‡Æo dos dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Exportando dados...").

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    chExcel:ScreenUpdating = NO.
    chExcel:SheetsInNewWorkbook = 1.
    chPasta = chExcel:Workbooks:Add().
    chPasta:Sheets:Item(1):Name = "P100".
    chPlanilha = chPasta:Sheets:Item(1).

    ASSIGN iLinha = 1.

    /*************************************** FORMATA CABE€ALHO  ********************************/
    chPlanilha:Range("A" + STRING(iLinha)):Value = "Empresa".
    chPlanilha:Range("B" + STRING(iLinha)):Value = "Estabelecimento".
    chPlanilha:Range("C" + STRING(iLinha)):Value = "Apura‡Æo Inicial".
    chPlanilha:Range("D" + STRING(iLinha)):Value = "Apura‡Æo Final".
    chPlanilha:Range("E" + STRING(iLinha)):Value = "Atividade".
    chPlanilha:Range("F" + STRING(iLinha)):Value = "Al¡quota".
    chPlanilha:Range("G" + STRING(iLinha)):Value = "Conta Contabil".
    chPlanilha:Range("H" + STRING(iLinha)):Value = "N£mero Sequencial".
    chPlanilha:Range("I" + STRING(iLinha)):Value = "Receita Total do Estabelecimento".
    chPlanilha:Range("J" + STRING(iLinha)):Value = "Receita Atividade do Estabelecimento".
    chPlanilha:Range("K" + STRING(iLinha)):Value = "Valor ExclusÆo".
    chPlanilha:Range("L" + STRING(iLinha)):Value = "Base Contribui‡Æo".
    chPlanilha:Range("M" + STRING(iLinha)):Value = "Contribui‡Æo Apurada".
    chPlanilha:Range("N" + STRING(iLinha)):Value = "Informa‡äes".

    chPlanilha:Range("A1:G1"):Interior:Color = 255.
    chPlanilha:Range("H1:N1"):Interior:COLOR = 5296274. 

    chPlanilha:Range("A" + STRING(iLinha)):NumberFormat = "#".                  /* Empresa                                */
    chPlanilha:Range("B" + STRING(iLinha)):NumberFormat = "###".                /* Estabelecimento                        */
    chPlanilha:Range("C" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa" .        /* Apura‡Æo Inicial                       */
    chPlanilha:Range("D" + STRING(iLinha)):NumberFormat = "dd/mm/aaaa" .        /* Apura‡Æo FINAL                         */
    chPlanilha:Range("E" + STRING(iLinha)):NumberFormat = "#######0".           /* Atividade                              */
    chPlanilha:Range("F" + STRING(iLinha)):NumberFormat = "##0,0000".           /* Al¡quota                               */
    chPlanilha:Range("G" + STRING(iLinha)):NumberFormat = "##0,00".     /* Conta Contabil                         */
    chPlanilha:Range("H" + STRING(iLinha)):NumberFormat = "##0,00".     /* N£mero Sequencial                      */  
    chPlanilha:Range("I" + STRING(iLinha)):NumberFormat = "##0,00".     /* Receita Total do Estabelecimento       */  
    chPlanilha:Range("J" + STRING(iLinha)):NumberFormat = "##0,00".     /* Receita Atividade do Estabelecimento   */  
    chPlanilha:Range("K" + STRING(iLinha)):NumberFormat = "##0,00".     /* Valor ExclusÆo                         */  
    chPlanilha:Range("L" + STRING(iLinha)):NumberFormat = "##0,00".     /* Base Contribui‡Æo                      */  
    chPlanilha:Range("M" + STRING(iLinha)):NumberFormat = "##0,00".     /* Contribui‡Æo Apurada                   */  
    chPlanilha:Range("N" + STRING(iLinha)):NumberFormat = "@".                  /* Informa‡äes                            */  

    chPlanilha:COLUMNS("A:N"):LOCKED = NO.

    DO WITH FRAME f4:
            
        FOR EACH tabela3 NO-LOCK
            WHERE tabela3.cod-empres         >= fi-emp-ini:SCREEN-VALUE 
              AND tabela3.cod-empres         <= fi-emp-fim:SCREEN-VALUE
              AND tabela3.cod-estab          >= fi-est-ini:SCREEN-VALUE 
              AND tabela3.cod-estab          <= fi-est-fim:SCREEN-VALUE 
              AND tabela3.dat-apurac-inicial >= date(fi-apuracao-ini:SCREEN-VALUE)
              AND tabela3.dat-apurac-final   <= date(fi-apuracao-fim:SCREEN-VALUE):
              
            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "P100 => " + "Emp: " + tabela3.cod-empres +
                                                    "/Estab: " + tabela3.cod-estab + "/Ref: de " + string(tabela3.dat-apurac-inicial, "99/99/9999") + " a " + string(tabela3.dat-apurac-final, "99/99/9999")).
    
            ASSIGN iLinha = iLinha + 1.
    
            /************************* FORMATA E ALIMENTA OS CAMPOS DA CHAVE DA TABELA  ***************************/
            chPlanilha:Range("A" + STRING(iLinha)):LOCKED = YES.
            chPlanilha:Range("B" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("C" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("D" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("E" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("F" + STRING(iLinha)):LOCKED = YES. 
            chPlanilha:Range("G" + STRING(iLinha)):LOCKED = YES. 
            
            chPlanilha:Range("A" + STRING(iLinha)):Value = TRIM(tabela3.cod-empres).                   /* Empresa                                */  
            chPlanilha:Range("B" + STRING(iLinha)):Value = TRIM(tabela3.cod-estab).                    /* Estabelecimento                        */  
            chPlanilha:Range("C" + STRING(iLinha)):Value = (tabela3.dat-apurac-inicial).               /* Apura‡Æo Inicial                       */  
            chPlanilha:Range("D" + STRING(iLinha)):Value = (tabela3.dat-apurac-final).                 /* Apura‡Æo FINAL                         */  
            chPlanilha:Range("E" + STRING(iLinha)):Value = (tabela3.cod-ativid).                       /* Atividade                              */  
            chPlanilha:Range("F" + STRING(iLinha)):Value = (tabela3.val-aliq).                         /* Al¡quota                               */  
            chPlanilha:Range("G" + STRING(iLinha)):Value = (tabela3.cod-cta-ctbl).                     /* Conta Contabil                         */  
            
            /*********************************** DEMAIS CAMPOS DA TABELA ******************************************/
            chPlanilha:Range("H" + STRING(iLinha)):Value = (tabela3.num-seq-ident-reg).                /* N£mero Sequencial                      */  
            chPlanilha:Range("I" + STRING(iLinha)):Value = (tabela3.val-recta-bruta-tot-estab).        /* Receita Total do Estabelecimento       */  
            chPlanilha:Range("J" + STRING(iLinha)):Value = (tabela3.val-recta-bruta-ativid-estab).     /* Receita Atividade do Estabelecimento   */  
            chPlanilha:Range("K" + STRING(iLinha)):Value = (tabela3.val-exclusao).                     /* Valor ExclusÆo                         */  
            chPlanilha:Range("L" + STRING(iLinha)):Value = (tabela3.val-base-contrib).                 /* Base Contribui‡Æo                      */  
            chPlanilha:Range("M" + STRING(iLinha)):Value = (tabela3.val-contrib-apurad).               /* Contribui‡Æo Apurada                   */  
            chPlanilha:Range("N" + STRING(iLinha)):Value = (tabela3.des-inf-comp).                     /* Informa‡äes                            */             

            chPlanilha:Range("H" + STRING(iLinha)):LOCKED = no. 
            chPlanilha:Range("I" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("J" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("K" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("L" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("M" + STRING(iLinha)):LOCKED = no.
            chPlanilha:Range("N" + STRING(iLinha)):LOCKED = no.


        END.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    chPlanilha:Range("A1:N1"):Font:Bold = YES.
    chPlanilha:Range("A1:N1"):AutoFilter(,,).
    chPlanilha:Columns("A:N"):Autofit.

    chPlanilha:Protect("intelbras",YES,YES,YES,NO,NO,NO,NO,NO,YES,NO,NO,YES,NO,YES,YES).

    chExcel:DisplayAlerts = NO.

    ASSIGN cArqAux = TRIM(REPLACE(pArquivo, "/", "\")).

    IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xls" THEN
        chPlanilha:SaveAs(cArqAux, "56",,,,,) NO-ERROR.
    ELSE IF ENTRY(NUM-ENTRIES(cArqAux, "."), cArqAux, ".") = "xlsx" THEN
        chPlanilha:SaveAs(cArqAux,,,,,,) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN cMensagem = "".

        DO iContMsg = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cMensagem = (IF cMensagem = "" THEN "" ELSE (cMensagem + CHR(10))) + ERROR-STATUS:GET-MESSAGE(iContMsg).
        END.

        RELEASE OBJECT chExcel NO-ERROR.

        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Ocorreu(ram) erro(s) ao salvar os dados no Microsoft Excel." +
                                 "~~" +
                                 "Erros encontrados:" + CHR(10) + cMensagem).

        RETURN "NOK".
    END.

    chExcel:WindowState = 2.
    chExcel:Visible = NO.
    chExcel:Quit().

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo gerado com sucesso!" +
                             "~~" +
                             "Caminho para o arquivo: " + cArqAux).

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fecha-excel C-Win 
PROCEDURE pi-fecha-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    chPasta:Close().
    chExcel:Quit().

    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chPasta    NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-f100 C-Win 
PROCEDURE pi-importa-f100 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.
DEFINE VARIABLE l-novo AS LOGICAL     NO-UNDO.

    RUN pi-abre-excel (INPUT pArquivo).

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Importando dados...":U).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    ASSIGN iLinha     = 1
           iContVazio = 0.

    EMPTY TEMP-TABLE tt-f100.

    importa-dados-excel:
    REPEAT:
        ASSIGN iLinha = iLinha + 1.

        IF  TRIM(chExcel:Cells(iLinha, 1):Text) = "" THEN
            LEAVE.

       CREATE   tt-F100.
       ASSIGN   tt-F100.cod-empres                 = TRIM(chExcel:Cells(iLinha, 1):Text)
                tt-F100.cod-estab                  = TRIM(chExcel:Cells(iLinha, 2):Text)
                tt-F100.dat-trans                  = DATE(chExcel:Cells(iLinha, 3):Text)
                tt-F100.num-seq-ident-reg          = INT (chExcel:Cells(iLinha, 4):Text)
                tt-F100.cod-indic-operac           = TRIM(chExcel:Cells(iLinha, 5):Text)
                tt-F100.cod-participan             = TRIM(chExcel:Cells(iLinha, 6):Text)
                tt-F100.cod-item                   = TRIM(chExcel:Cells(iLinha, 7):Text)
                tt-F100.dat-operac                 = DATE(chExcel:Cells(iLinha, 8):Text)
                tt-F100.val-operac                 = DEC (chExcel:Cells(iLinha, 9):Text)
                tt-F100.cod-sit-tributar-pis       = TRIM(chExcel:Cells(iLinha, 10):Text)
                tt-F100.val-base-calc-pis          = DEC (chExcel:Cells(iLinha, 11):Text)
                tt-F100.val-aliq-pis               = DEC (chExcel:Cells(iLinha, 12):Text)
                tt-F100.val-pis                    = DEC (chExcel:Cells(iLinha, 13):Text) 
                tt-F100.cod-sit-tributar-cofins    = TRIM(chExcel:Cells(iLinha, 14):Text) 
                tt-F100.val-base-calc-cofins       = DEC (chExcel:Cells(iLinha, 15):Text) 
                tt-F100.val-aliq-cofins            = DEC (chExcel:Cells(iLinha, 16):Text) 
                tt-F100.val-cofins                 = DEC (chExcel:Cells(iLinha, 17):Text) 
                tt-F100.cod-nat-base-calc-cr       = TRIM(chExcel:Cells(iLinha, 18):Text) 
                tt-F100.ind-orig                   = TRIM(chExcel:Cells(iLinha, 19):Text) 
                tt-F100.cod-cta-ctbl               = TRIM(chExcel:Cells(iLinha, 20):Text) 
                tt-F100.cod-ccusto                 = TRIM(chExcel:Cells(iLinha, 21):Text) 
                tt-F100.des-operac                 = TRIM(chExcel:Cells(iLinha, 22):Text)
                tt-F100.linha-excel                = iLinha.
                                                          


        IF  ERROR-STATUS:ERROR THEN
            LEAVE importa-dados-excel.

        IF  VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Dat Refer: " + STRING(dat-trans, "99/99/9999") + " ...").
    END.

    /* Fechando o Arquivo excel aberto*/
    RUN pi-fecha-excel.

    IF NOT CAN-FIND(FIRST tt-f100) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "NÆo foram encontrados dados na plan¡lha MS Excel informada!":U).

        RETURN "NOK":U.
    END.

    /************************************* Transferir a Tabela tempor ria proveniente do Excel, para a tabela, atrav‚s da bo ******************************************************/
    
    DO TRANS ON ERROR UNDO, LEAVE:
    
        FOR EACH tt-F100 :
        
            EMPTY TEMP-TABLE ttdwf-outros-docto-operac.
            EMPTY TEMP-TABLE RowErrors.
            
            run emptyRowErrors in h-fibo344.
            RUN openQuerystatic IN h-fibo344 ("Default").
            
            run gotoKey in h-fibo344 (input tt-F100.cod-empres              ,
                                      input tt-F100.cod-estab               ,
                                      input tt-F100.dat-trans               ,
                                      input tt-F100.num-seq-ident-reg       ).

            IF  RETURN-VALUE <> "OK" THEN DO:
                CREATE ttdwf-outros-docto-operac.
            
                ASSIGN ttdwf-outros-docto-operac.cod-empres                     = tt-F100.cod-empres            
                       ttdwf-outros-docto-operac.cod-estab                      = tt-F100.cod-estab           
                       ttdwf-outros-docto-operac.dat-trans                      = tt-F100.dat-trans             
                       ttdwf-outros-docto-operac.num-seq-ident-reg              = tt-F100.num-seq-ident-reg
                       l-novo                                                   = YES. 

            END.
            ELSE DO:
                RUN GetRecord in h-fibo344 (OUTPUT table ttdwf-outros-docto-operac).
        
                FIND FIRST ttdwf-outros-docto-operac NO-ERROR.
            END.
            
            /********************************* Atualiza‡Æo dos Campos  nÆo chave *********************************/
            ASSIGN ttdwf-outros-docto-operac.cod-indic-operac        = tt-F100.cod-indic-operac        
                   ttdwf-outros-docto-operac.cod-participan          = tt-F100.cod-participan          
                   ttdwf-outros-docto-operac.cod-item                = tt-F100.cod-item                
                   ttdwf-outros-docto-operac.dat-operac              = tt-F100.dat-operac              
                   ttdwf-outros-docto-operac.val-operac              = tt-F100.val-operac              
                   ttdwf-outros-docto-operac.cod-sit-tributar-pis    = tt-F100.cod-sit-tributar-pis    
                   ttdwf-outros-docto-operac.val-base-calc-pis       = tt-F100.val-base-calc-pis       
                   ttdwf-outros-docto-operac.val-aliq-pis            = tt-F100.val-aliq-pis            
                   ttdwf-outros-docto-operac.val-pis                 = tt-F100.val-pis                 
                   ttdwf-outros-docto-operac.cod-sit-tributar-cofins = tt-F100.cod-sit-tributar-cofins 
                   ttdwf-outros-docto-operac.val-base-calc-cofins    = tt-F100.val-base-calc-cofins    
                   ttdwf-outros-docto-operac.val-aliq-cofins         = tt-F100.val-aliq-cofins         
                   ttdwf-outros-docto-operac.val-cofins              = tt-F100.val-cofins              
                   ttdwf-outros-docto-operac.cod-nat-base-calc-cr    = tt-F100.cod-nat-base-calc-cr    
                   ttdwf-outros-docto-operac.ind-orig                = tt-F100.ind-orig                
                   ttdwf-outros-docto-operac.cod-cta-ctbl            = tt-F100.cod-cta-ctbl            
                   ttdwf-outros-docto-operac.cod-ccusto              = tt-F100.cod-ccusto              
                   ttdwf-outros-docto-operac.des-operac              = tt-F100.des-operac.                

            IF l-novo = YES THEN DO:
                RUN setRecord in h-fibo344 (input table ttdwf-outros-docto-operac).
                RUN CreateRecord in h-fibo344.
                RUN getRowErrors IN h-fibo344 (OUTPUT TABLE RowErrors ).
            END.

            ELSE DO:
                RUN setRecord in h-fibo344 (input table ttdwf-outros-docto-operac).
                RUN UpdateRecord in h-fibo344.
                RUN getRowErrors IN h-fibo344 (OUTPUT TABLE RowErrors ).
            END.

            /* Concatenar na RowErrors a linha do Excel que est  com problemas */
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorhelp = RowErrors.errorhelp + CHR(13) + "Linha Excel: " + string(tt-F100.linha-excel, ">>>>>9").
    
                MESSAGE "RowErrors.errorhelp: " RowErrors.errorhelp
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    
            IF  CAN-FIND(first RowErrors) then do:
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &Modal="YES"}
                {METHOD/showmessage.i3}
        
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Importa‡Æo abortada!":U).
        
                RETURN "NOK":U.
            end.
        END.
    END.
    
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Importa‡Æo realizada com sucesso!" +
                             "~~" +
                             "Registros importadas: " + STRING(iLinha - 2)).
    
    RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-F600 C-Win 
PROCEDURE pi-importa-F600 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.
DEFINE VARIABLE l-novo AS LOGICAL     NO-UNDO.
                                            
    RUN pi-abre-excel (INPUT pArquivo).

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Importando dados...":U).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    ASSIGN iLinha     = 1
           iContVazio = 0.

    EMPTY TEMP-TABLE tt-F600.

    importa-dados-excel:
    REPEAT:
        ASSIGN iLinha = iLinha + 1.

        IF  TRIM(chExcel:Cells(iLinha, 1):Text) = "" THEN
            LEAVE.
        ELSE

        CREATE  tt-F600.
        ASSIGN  tt-F600.cod-empres             = TRIM(chExcel:Cells(iLinha, 1):Text) 
                tt-F600.cod-estab              = TRIM(chExcel:Cells(iLinha, 2):Text)  
                tt-F600.dat-trans              = date(chExcel:Cells(iLinha, 3):Text)
                tt-F600.num-seq-ident-reg      = INT(chExcel:Cells(iLinha, 4):Text)  
                tt-F600.cod-grp                = TRIM(chExcel:Cells(iLinha, 5):Text) 
                tt-F600.cod-emitente           = TRIM(chExcel:Cells(iLinha, 6):Text)  
                tt-F600.cod-indic-natur-retenc = TRIM(chExcel:Cells(iLinha, 7):Text)  
                tt-F600.dat-recebto-retenc     = date(chExcel:Cells(iLinha, 8):Text) 
                tt-F600.val-recbdo             = DEC (chExcel:Cells(iLinha, 9):Text)  
                tt-F600.val-retid-fonte        = DEC (chExcel:Cells(iLinha, 10):Text) 
                tt-F600.cod-recta              = TRIM(chExcel:Cells(iLinha, 11):Text) 
                tt-F600.cod-indic-natur-recta  = TRIM (chExcel:Cells(iLinha, 12):Text) 
                tt-F600.cod-cnpj               = TRIM (chExcel:Cells(iLinha, 13):Text)
                tt-F600.val-retid-pis          = DEC(chExcel:Cells(iLinha, 14):Text)
                tt-F600.val-retid-cofins       = DEC(chExcel:Cells(iLinha, 15):Text)
                tt-F600.cod-livre-2            = TRIM(chExcel:Cells(iLinha, 16):Text)
                tt-F600.linha-excel            = iLinha.
                
        IF  ERROR-STATUS:ERROR THEN
            LEAVE importa-dados-excel.

        IF  VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Dat Refer: " + STRING(dat-TRANS, "99/99/9999") + " ...").
    END.

    /* Fechando o Arquivo excel aberto*/
    RUN pi-fecha-excel.

    IF NOT CAN-FIND(FIRST tt-F600) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "NÆo foram encontrados dados na plan¡lha MS Excel informada!":U).

        RETURN "NOK":U.
    END.

    /************************************* Transferir a Tabela tempor ria proveniente do Excel, para a tabela, atrav‚s da bo ******************************************************/
    
    DO TRANS ON ERROR UNDO, LEAVE:
    
        FOR EACH tt-F600 :
        
            EMPTY TEMP-TABLE ttdwf-contrib-retid-fonte.
            EMPTY TEMP-TABLE RowErrors.
            
            run emptyRowErrors in h-fibo357.
            RUN openQuerystatic IN h-fibo357 ("Default").
            
            run gotoKey in h-fibo357 (input tt-F600.cod-empres                   ,
                                      input tt-F600.cod-estab                    ,
                                      input tt-F600.dat-trans                    ,
                                      input tt-F600.num-seq-ident-reg).

            IF  RETURN-VALUE <> "OK" THEN DO:
                CREATE ttdwf-contrib-retid-fonte.
        
                ASSIGN ttdwf-contrib-retid-fonte.cod-empres                   = tt-F600.cod-empres                  
                       ttdwf-contrib-retid-fonte.cod-estab                    = tt-F600.cod-estab                   
                       ttdwf-contrib-retid-fonte.dat-trans                    = tt-F600.dat-trans
                       ttdwf-contrib-retid-fonte.num-seq-ident-reg            = tt-F600.num-seq-ident-reg       
                       l-novo                                                  = YES.
            END.
            ELSE DO:
                RUN GetRecord in h-fibo357 (OUTPUT table ttdwf-contrib-retid-fonte).

                FIND FIRST ttdwf-contrib-retid-fonte NO-ERROR.
            END.
            
            /********************************* Atualiza‡Æo dos Campos  nÆo chave *********************************/
            ASSIGN ttdwf-contrib-retid-fonte.cod-grp                 = tt-F600.cod-grp                
                   ttdwf-contrib-retid-fonte.cod-emitente            = tt-F600.cod-emitente           
                   ttdwf-contrib-retid-fonte.cod-indic-natur-retenc  = tt-F600.cod-indic-natur-retenc 
                   ttdwf-contrib-retid-fonte.dat-recebto-retenc      = tt-F600.dat-recebto-retenc     
                   ttdwf-contrib-retid-fonte.val-recbdo              = tt-F600.val-recbdo             
                   ttdwf-contrib-retid-fonte.val-retid-fonte         = tt-F600.val-retid-fonte        
                   ttdwf-contrib-retid-fonte.cod-recta               = tt-F600.cod-recta              
                   ttdwf-contrib-retid-fonte.cod-indic-natur-recta   = tt-F600.cod-indic-natur-recta  
                   ttdwf-contrib-retid-fonte.cod-cnpj                = tt-F600.cod-cnpj               
                   ttdwf-contrib-retid-fonte.val-retid-pis           = tt-F600.val-retid-pis          
                   ttdwf-contrib-retid-fonte.val-retid-cofins        = tt-F600.val-retid-cofins       
                   ttdwf-contrib-retid-fonte.cod-livre-2             = tt-F600.cod-livre-2.            


            IF l-novo = YES THEN DO:
                RUN setRecord in h-fibo357 (input table ttdwf-contrib-retid-fonte).
                RUN CreateRecord in h-fibo357.
                RUN getRowErrors IN h-fibo357 (OUTPUT TABLE RowErrors ).
            END.

            ELSE DO:
                RUN setRecord in h-fibo357 (input table ttdwf-contrib-retid-fonte).
                RUN UpdateRecord in h-fibo357.
                RUN getRowErrors IN h-fibo357 (OUTPUT TABLE RowErrors ).
            END.
        
            /* Concatenar na RowErrors a linha do Excel que est  com problemas */
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorhelp = RowErrors.errorhelp + CHR(13) + "Linha Excel: " + string(tt-F600.linha-excel, ">>>>>9").
    
                MESSAGE "RowErrors.errorhelp: " RowErrors.errorhelp
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    
            IF  CAN-FIND(first RowErrors) then do:
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &Modal="YES"}
                {METHOD/showmessage.i3}
        
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Importa‡Æo abortada!":U).
        
                RETURN "NOK":U.
            end.
        END.
    END.
    
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Importa‡Æo realizada com sucesso!" +
                             "~~" +
                             "Registros importadas: " + STRING(iLinha - 2)).
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-M110-510 C-Win 
PROCEDURE pi-importa-M110-510 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE l-novo AS LOGICAL     NO-UNDO.

    RUN pi-abre-excel (INPUT pArquivo).

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Importando dados...":U).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    ASSIGN iLinha     = 1
           iContVazio = 0.

    EMPTY TEMP-TABLE tt-M110-M510.

    importa-dados-excel:
    REPEAT:
        ASSIGN iLinha = iLinha + 1.

        IF  TRIM(chExcel:Cells(iLinha, 1):Text) = "" THEN
            LEAVE.

        CREATE  tt-M110-M510.
        ASSIGN  tt-M110-M510.cod-empres           = TRIM(chExcel:Cells(iLinha, 1):Text)
                tt-M110-M510.cod-impto            = TRIM(chExcel:Cells(iLinha, 2):Text)
                tt-M110-M510.dat-refer            = DATE(chExcel:Cells(iLinha, 3):Text)
                tt-M110-M510.cod-cr               = TRIM(chExcel:Cells(iLinha, 4):Text)
                tt-M110-M510.cod-indic-cr         = TRIM(chExcel:Cells(iLinha, 5):Text)
                tt-M110-M510.val-aliq-impto       = DEC (chExcel:Cells(iLinha, 6):Text)
                tt-M110-M510.val-quant-aliq-impto = DEC (chExcel:Cells(iLinha, 7):Text)
                tt-M110-M510.cod-indic-ajust      = TRIM(chExcel:Cells(iLinha, 8):Text)
                tt-M110-M510.cod-ajust            = TRIM(chExcel:Cells(iLinha, 9):Text)
                tt-M110-M510.cod-num-docto        = TRIM(chExcel:Cells(iLinha, 10):Text)
                tt-M110-M510.val-ajust            = DEC (chExcel:Cells(iLinha, 11):Text)
                tt-M110-M510.des-ajust            = TRIM(chExcel:Cells(iLinha, 12):Text)
                tt-M110-M510.linha-excel          = iLinha.

        IF  ERROR-STATUS:ERROR THEN
            LEAVE importa-dados-excel.

        IF  VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Dat Refer: " + STRING(dat-refer, "99/99/9999") + " ...").
    END.

    /* Fechando o Arquivo excel aberto*/
    RUN pi-fecha-excel.

    IF NOT CAN-FIND(FIRST tt-M110-M510) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "NÆo foram encontrados dados na plan¡lha MS Excel informada!":U).

        RETURN "NOK":U.
    END.

    /************************************* Transferir a Tabela tempor ria proveniente do Excel, para a tabela, atrav‚s da bo ******************************************************/
    
    DO TRANS ON ERROR UNDO, LEAVE:
    
        FOR EACH tt-M110-M510 :
        
            EMPTY TEMP-TABLE ttdwf-ajust-cr-impto-apurad.
            EMPTY TEMP-TABLE RowErrors.
            
            run emptyRowErrors in h-fibo387.
            RUN openQuerystatic IN h-fibo387 ("Default").
            
            run gotoKey in h-fibo387 (input tt-M110-M510.cod-empres          ,
                                      input tt-M110-M510.cod-impto           ,
                                      input tt-M110-M510.dat-Refer           ,
                                      input tt-M110-M510.cod-cr              ,
                                      input tt-M110-M510.cod-indic-cr        ,
                                      input tt-M110-M510.val-aliq-impto      ,
                                      input tt-M110-M510.val-quant-aliq-impto,
                                      input tt-M110-M510.cod-indic-ajust     ,
                                      input tt-M110-M510.cod-ajust           ,
                                      input tt-M110-M510.cod-num-docto       )NO-ERROR.

            IF  RETURN-VALUE <> "OK" THEN DO: 
                CREATE ttdwf-ajust-cr-impto-apurad.
        
                ASSIGN ttdwf-ajust-cr-impto-apurad.cod-empres            = tt-M110-M510.cod-empres          
                       ttdwf-ajust-cr-impto-apurad.cod-impto             = tt-M110-M510.cod-impto           
                       ttdwf-ajust-cr-impto-apurad.dat-Refer             = tt-M110-M510.dat-Refer           
                       ttdwf-ajust-cr-impto-apurad.cod-cr                = tt-M110-M510.cod-cr              
                       ttdwf-ajust-cr-impto-apurad.cod-indic-cr          = tt-M110-M510.cod-indic-cr        
                       ttdwf-ajust-cr-impto-apurad.val-aliq-impto        = tt-M110-M510.val-aliq-impto      
                       ttdwf-ajust-cr-impto-apurad.val-quant-aliq-impto  = tt-M110-M510.val-quant-aliq-impto
                       ttdwf-ajust-cr-impto-apurad.cod-indic-ajust       = tt-M110-M510.cod-indic-ajust     
                       ttdwf-ajust-cr-impto-apurad.cod-ajust             = tt-M110-M510.cod-ajust           
                       ttdwf-ajust-cr-impto-apurad.cod-num-docto         = tt-M110-M510.cod-num-docto     
                       l-novo                                            = YES.       

            END.
            ELSE DO:
                RUN GetRecord in h-fibo387 (OUTPUT table ttdwf-ajust-cr-impto-apurad).
        
                FIND FIRST ttdwf-ajust-cr-impto-apurad NO-ERROR.
            END.
            
            /********************************* Atualiza‡Æo dos Campos  nÆo chave *********************************/
            ASSIGN ttdwf-ajust-cr-impto-apurad.val-ajust  = tt-M110-M510.val-ajust
                   ttdwf-ajust-cr-impto-apurad.des-ajust  = tt-M110-M510.des-ajust.
                      
            IF l-novo = YES THEN DO:
                RUN setRecord in h-fibo387 (input table ttdwf-ajust-cr-impto-apurad).
                RUN CreateRecord in h-fibo387.
                RUN getRowErrors IN h-fibo387 (OUTPUT TABLE RowErrors ).
            END.

            ELSE DO:
                RUN setRecord in h-fibo387 (input table ttdwf-ajust-cr-impto-apurad).
                RUN UpdateRecord in h-fibo387.
                RUN getRowErrors IN h-fibo387 (OUTPUT TABLE RowErrors ).
            END.
        
            /* Concatenar na RowErrors a linha do Excel que est  com problemas */
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorhelp = RowErrors.errorhelp + CHR(13) + "Linha Excel: " + string(tt-M110-M510.linha-excel, ">>>>>9").
    
                MESSAGE "RowErrors.errorhelp: " RowErrors.errorhelp
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    
            IF  CAN-FIND(first RowErrors) then do:
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &Modal="YES"}
                {METHOD/showmessage.i3}
        
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Importa‡Æo abortada!":U).
        
                RETURN "NOK":U.
            end.
        END.
    END.
    
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Importa‡Æo realizada com sucesso!" +
                             "~~" +
                             "Registros importadas: " + STRING(iLinha - 2)).
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-m220-620 C-Win 
PROCEDURE pi-importa-m220-620 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE l-novo AS LOGICAL     NO-UNDO.

    RUN pi-abre-excel (INPUT pArquivo).

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Importando dados...":U).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    ASSIGN iLinha     = 1
           iContVazio = 0.

    EMPTY TEMP-TABLE tt-M220-M620.

    importa-dados-excel:
    REPEAT:
        ASSIGN iLinha = iLinha + 1.

        IF  TRIM(chExcel:Cells(iLinha, 1):Text) = "" THEN
            LEAVE.

        CREATE  tt-M220-M620.
        ASSIGN  tt-M220-M620.cod-empres           = TRIM(chExcel:Cells(iLinha, 1):Text)
                tt-M220-M620.dat-refer            = DATE(chExcel:Cells(iLinha, 2):Text)
                tt-M220-M620.cod-impto            = TRIM(chExcel:Cells(iLinha, 3):Text)
                tt-M220-M620.cod-contrib          = TRIM(chExcel:Cells(iLinha, 4):Text)
                tt-M220-M620.val-aliq-impto       = DEC (chExcel:Cells(iLinha, 5):Text)
                tt-M220-M620.val-quant-aliq-impto = DEC (chExcel:Cells(iLinha, 6):Text)
                tt-M220-M620.cod-indic-ajust      = TRIM(chExcel:Cells(iLinha, 7):Text)
                tt-M220-M620.cod-ajust            = TRIM(chExcel:Cells(iLinha, 8):Text)
                tt-M220-M620.cod-num-docto        = TRIM(chExcel:Cells(iLinha, 9):Text)
                tt-M220-M620.val-ajust            = DEC (chExcel:Cells(iLinha, 10):Text)
                tt-M220-M620.des-ajust            = TRIM(chExcel:Cells(iLinha, 11):Text)
                tt-M220-M620.linha-excel          = iLinha.

        IF  ERROR-STATUS:ERROR THEN
            LEAVE importa-dados-excel.

        IF  VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Dat Refer: " + STRING(dat-refer, "99/99/9999") + " ...").
    END.

    /* Fechando o Arquivo excel aberto*/
    RUN pi-fecha-excel.

    IF NOT CAN-FIND(FIRST tt-M220-M620) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "NÆo foram encontrados dados na plan¡lha MS Excel informada!":U).

        RETURN "NOK":U.
    END.

    /************************************* Transferir a Tabela tempor ria proveniente do Excel, para a tabela, atrav‚s da bo ******************************************************/
    
    DO TRANS ON ERROR UNDO, LEAVE:
    
        FOR EACH tt-M220-M620 :
        
            EMPTY TEMP-TABLE ttdwf-ajust-contrib-imp-apurad.
            EMPTY TEMP-TABLE RowErrors.
            
            run emptyRowErrors in h-fibo389.
            RUN openQuerystatic IN h-fibo389 ("Default").
            
            run gotoKey in h-fibo389 (input tt-M220-M620.cod-empres          ,
                                      input tt-M220-M620.dat-Refer           ,
                                      input tt-M220-M620.cod-impto           ,
                                      input tt-M220-M620.cod-contrib         ,
                                      input tt-M220-M620.val-aliq-impto      ,
                                      input tt-M220-M620.val-quant-aliq-impto,
                                      input tt-M220-M620.cod-indic-ajust     ,
                                      input tt-M220-M620.cod-ajust           ,
                                      input tt-M220-M620.cod-num-docto       ).
                .
            IF  RETURN-VALUE <> "OK" THEN DO:
                CREATE ttdwf-ajust-contrib-imp-apurad.
        
                ASSIGN ttdwf-ajust-contrib-imp-apurad.cod-empres            = tt-M220-M620.cod-empres          
                       ttdwf-ajust-contrib-imp-apurad.dat-Refer             = tt-M220-M620.dat-Refer           
                       ttdwf-ajust-contrib-imp-apurad.cod-impto             = tt-M220-M620.cod-impto           
                       ttdwf-ajust-contrib-imp-apurad.cod-contrib           = tt-M220-M620.cod-contrib 
                       ttdwf-ajust-contrib-imp-apurad.val-aliq-impto        = tt-M220-M620.val-aliq-impto      
                       ttdwf-ajust-contrib-imp-apurad.val-quant-aliq-impto  = tt-M220-M620.val-quant-aliq-impto
                       ttdwf-ajust-contrib-imp-apurad.cod-indic-ajust       = tt-M220-M620.cod-indic-ajust     
                       ttdwf-ajust-contrib-imp-apurad.cod-ajust             = tt-M220-M620.cod-ajust           
                       ttdwf-ajust-contrib-imp-apurad.cod-num-docto         = tt-M220-M620.cod-num-docto     
                       l-novo                                               = YES.    

            END.
            ELSE DO:
                RUN GetRecord in h-fibo389 (OUTPUT table ttdwf-ajust-contrib-imp-apurad).
        
                FIND FIRST ttdwf-ajust-contrib-imp-apurad NO-ERROR.
            END.
            
            /********************************* Atualiza‡Æo dos Campos *********************************/
            ASSIGN ttdwf-ajust-contrib-imp-apurad.val-ajust  = tt-M220-M620.val-ajust
                   ttdwf-ajust-contrib-imp-apurad.des-ajust  = tt-M220-M620.des-ajust.
            
            IF l-novo = YES THEN DO:
                RUN setRecord in h-fibo389 (input table ttdwf-ajust-contrib-imp-apurad).
                RUN CreateRecord in h-fibo389.
                RUN getRowErrors IN h-fibo389 (OUTPUT TABLE RowErrors ).
            END.

            ELSE DO:
                RUN setRecord in h-fibo389 (input table ttdwf-ajust-contrib-imp-apurad).
                RUN UpdateRecord in h-fibo389.
                RUN getRowErrors IN h-fibo389 (OUTPUT TABLE RowErrors ).
            END.
        
            /* Concatenar na RowErrors a linha do Excel que est  com problemas */
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorhelp = RowErrors.errorhelp + CHR(13) + "Linha Excel: " + string(tt-M220-M620.linha-excel, ">>>>>9").
    
                MESSAGE "RowErrors.errorhelp: " RowErrors.errorhelp
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    
            IF  CAN-FIND(first RowErrors) then do:
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &Modal="YES"}
                {METHOD/showmessage.i3}
        
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Importa‡Æo abortada!":U).
        
                RETURN "NOK":U.
            end.
        END.
    END.
    
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Importa‡Æo realizada com sucesso!" +
                             "~~" +
                             "Registros importadas: " + STRING(iLinha - 2)).
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-p100 C-Win 
PROCEDURE pi-importa-p100 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pArquivo AS CHAR NO-UNDO.
DEFINE VARIABLE l-novo AS LOGICAL     NO-UNDO.
                                            
    RUN pi-abre-excel (INPUT pArquivo).

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Importando dados...":U).

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-desabilita-cancela IN hAcomp.

    ASSIGN iLinha     = 1
           iContVazio = 0.

    EMPTY TEMP-TABLE tt-P100.

    importa-dados-excel:
    REPEAT:
        ASSIGN iLinha = iLinha + 1.

        IF  TRIM(chExcel:Cells(iLinha, 1):Text) = "" THEN
            LEAVE.
        ELSE

        CREATE  tt-P100.
        ASSIGN  tt-P100.cod-empres                   = TRIM(chExcel:Cells(iLinha, 1):Text) 
                tt-P100.cod-estab                    = TRIM(chExcel:Cells(iLinha, 2):Text)  
                tt-P100.dat-apurac-inicial           = date(chExcel:Cells(iLinha, 3):Text)
                tt-P100.dat-apurac-final             = date(chExcel:Cells(iLinha, 4):Text)  
                tt-P100.cod-ativid                   = TRIM(chExcel:Cells(iLinha, 5):Text) 
                tt-P100.val-aliq                     = DEC (chExcel:Cells(iLinha, 6):Text)  
                tt-P100.cod-cta-ctbl                 = TRIM(chExcel:Cells(iLinha, 7):Text)  
                tt-P100.num-seq-ident-reg            = INT (chExcel:Cells(iLinha, 8):Text) 
                tt-P100.val-recta-bruta-tot-estab    = DEC (chExcel:Cells(iLinha, 9):Text)  
                tt-P100.val-recta-bruta-ativid-estab = DEC (chExcel:Cells(iLinha, 10):Text) 
                tt-P100.val-exclusao                 = DEC (chExcel:Cells(iLinha, 11):Text) 
                tt-P100.val-base-contrib             = DEC (chExcel:Cells(iLinha, 12):Text) 
                tt-P100.val-contrib-apurad           = DEC (chExcel:Cells(iLinha, 13):Text)
                tt-P100.des-inf-comp                 = TRIM(chExcel:Cells(iLinha, 14):Text)
                tt-P100.linha-excel                  = iLinha.
                
        IF  ERROR-STATUS:ERROR THEN
            LEAVE importa-dados-excel.

        IF  VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Dat Refer: " + STRING(dat-apurac-inicial, "99/99/9999") + " ...").
    END.

    /* Fechando o Arquivo excel aberto*/
    RUN pi-fecha-excel.

    IF NOT CAN-FIND(FIRST tt-P100) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "NÆo foram encontrados dados na plan¡lha MS Excel informada!":U).

        RETURN "NOK":U.
    END.

    /************************************* Transferir a Tabela tempor ria proveniente do Excel, para a tabela, atrav‚s da bo ******************************************************/
    
    DO TRANS ON ERROR UNDO, LEAVE:
    
        FOR EACH tt-P100 :
        
            EMPTY TEMP-TABLE ttdwf-contrib-previd-recta.
            EMPTY TEMP-TABLE RowErrors.
            
            run emptyRowErrors in h-fibo422.
            RUN openQuerystatic IN h-fibo422 ("Default").
            
            run gotoKey in h-fibo422 (input tt-p100.cod-empres                   ,
                                      input tt-p100.cod-estab                    ,
                                      input tt-p100.dat-apurac-inicial           ,
                                      input tt-p100.dat-apurac-final             ,
                                      input tt-p100.cod-ativid                   ,
                                      input tt-p100.val-aliq                     ,
                                      input tt-p100.cod-cta-ctbl                 ).

            IF  RETURN-VALUE <> "OK" THEN DO:
                CREATE ttdwf-contrib-previd-recta.
        
                ASSIGN ttdwf-contrib-previd-recta.cod-empres                   = tt-P100.cod-empres                  
                       ttdwf-contrib-previd-recta.cod-estab                    = tt-P100.cod-estab                   
                       ttdwf-contrib-previd-recta.dat-apurac-inicial           = tt-P100.dat-apurac-inicial          
                       ttdwf-contrib-previd-recta.dat-apurac-final             = tt-P100.dat-apurac-final            
                       ttdwf-contrib-previd-recta.cod-ativid                   = tt-P100.cod-ativid                  
                       ttdwf-contrib-previd-recta.val-aliq                     = tt-P100.val-aliq                    
                       ttdwf-contrib-previd-recta.cod-cta-ctbl                 = tt-P100.cod-cta-ctbl            
                       l-novo                                                  = YES.
            END.
            ELSE DO:
                RUN GetRecord in h-fibo422 (OUTPUT table ttdwf-contrib-previd-recta).

                FIND FIRST ttdwf-contrib-previd-recta NO-ERROR.
            END.
            
            /********************************* Atualiza‡Æo dos Campos  nÆo chave *********************************/
            ASSIGN ttdwf-contrib-previd-recta.num-seq-ident-reg            = tt-P100.num-seq-ident-reg            
                   ttdwf-contrib-previd-recta.val-recta-bruta-tot-estab    = tt-P100.val-recta-bruta-tot-estab    
                   ttdwf-contrib-previd-recta.val-recta-bruta-ativid-estab = tt-P100.val-recta-bruta-ativid-estab 
                   ttdwf-contrib-previd-recta.val-exclusao                 = tt-P100.val-exclusao                 
                   ttdwf-contrib-previd-recta.val-base-contrib             = tt-P100.val-base-contrib             
                   ttdwf-contrib-previd-recta.val-contrib-apurad           = tt-P100.val-contrib-apurad           
                   ttdwf-contrib-previd-recta.des-inf-comp                 = tt-P100.des-inf-comp.                 

            IF l-novo = YES THEN DO:
                RUN setRecord in h-fibo422 (input table ttdwf-contrib-previd-recta).
                RUN CreateRecord in h-fibo422.
                RUN getRowErrors IN h-fibo422 (OUTPUT TABLE RowErrors ).
            END.

            ELSE DO:
                RUN setRecord in h-fibo422 (input table ttdwf-contrib-previd-recta).
                RUN UpdateRecord in h-fibo422.
                RUN getRowErrors IN h-fibo422 (OUTPUT TABLE RowErrors ).
            END.
        
            /* Concatenar na RowErrors a linha do Excel que est  com problemas */
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorhelp = RowErrors.errorhelp + CHR(13) + "Linha Excel: " + string(tt-P100.linha-excel, ">>>>>9").
    
                MESSAGE "RowErrors.errorhelp: " RowErrors.errorhelp
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    
            IF  CAN-FIND(first RowErrors) then do:
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &Modal="YES"}
                {METHOD/showmessage.i3}
        
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Importa‡Æo abortada!":U).
        
                RETURN "NOK":U.
            end.
        END.
    END.
    
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Importa‡Æo realizada com sucesso!" +
                             "~~" +
                             "Registros importadas: " + STRING(iLinha - 2)).
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_celula C-Win 
FUNCTION fn_celula RETURNS CHARACTER
  ( INPUT fni-c-coluna AS   CHARACTER ,
    INPUT fni-i-linha  AS   INTEGER   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE     fno-c-celula            AS   CHARACTER              NO-UNDO. 

    ASSIGN fno-c-celula = TRIM (fni-c-coluna) + TRIM (STRING (fni-i-linha)) .

    RETURN fno-c-celula. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

