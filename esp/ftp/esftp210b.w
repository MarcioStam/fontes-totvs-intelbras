&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-simula-dev-it NO-UNDO LIKE int-simula-dev-it
       FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
       field dt-producao as date
       field dt-primeira-nf as date.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999B 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&global-define botao yes
/*:T v ri veis de uso global */


/* Parameters Definitions ---                                           */
 def input-output parameter v-row-table  as rowid         no-undo. 
 def input        parameter v-row-parent as rowid         no-undo. 
 def input        parameter wh-browse    as handle        no-undo.
 def input        parameter estado       as char          no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-seq-item AS INTEGER INITIAL 1    NO-UNDO.

/*:T** Variaveis usadas internamente pelo estilo, favor nao elimina-las   */
def new Global shared var vg-row-int-simula-dev  as ROWID no-undo.

/*:T** Fim das variaveis utilizadas no estilo */
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.
DEFINE BUFFER b-int-simula-dev-it FOR int-simula-dev-it.
DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.
DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-int-simula-dev-it-glob NO-UNDO LIKE int-simula-dev-it
   FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-incmod
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-simula-dev-it

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-int-simula-dev-it.cod-estabel-origem tt-int-simula-dev-it.serie-origem tt-int-simula-dev-it.nr-nota-origem tt-int-simula-dev-it.dt-emis-nota tt-int-simula-dev-it.qt-devolvida tt-int-simula-dev-it.vl-unitario tt-int-simula-dev-it.vl-ipi tt-int-simula-dev-it.vl-icms tt-int-simula-dev-it.vl-tot-it /*tt-int-simula-dev-it.dt-producao tt-int-simula-dev-it.dt-primeira-nf */ tt-int-simula-dev-it.garantia   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-int-simula-dev-it
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-int-simula-dev-it.
&Scoped-define TABLES-IN-QUERY-br-itens tt-int-simula-dev-it
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-int-simula-dev-it


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-import v-it-codigo v-qtd-devol bt-devol ~
br-itens bt-ok bt-excluir bt-ajuda bt-cancela rt-button RECT-1 RECT-2 ~
RECT-3 
&Scoped-Define DISPLAYED-OBJECTS v-cod-emitente c-nome-emit v-dt-simula ~
v-nr-sequencia v-cod-usuario v-it-codigo v-qtd-devol v-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-devol 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-excluir AUTO-END-KEY 
     LABEL "&Excluir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-import 
     LABEL "Importar" 
     SIZE 8 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-save AUTO-GO 
     LABEL "&Salvar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-usuario LIKE int-simula-dev.cod-usuario
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE v-dt-simula AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Simula‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE v-nr-sequencia LIKE int-simula-dev.nr-sequencia
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE v-qtd-devol AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 8.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-int-simula-dev-it SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens w-cadsim _FREEFORM
  QUERY br-itens DISPLAY
      tt-int-simula-dev-it.cod-estabel-origem
 tt-int-simula-dev-it.serie-origem  
 tt-int-simula-dev-it.nr-nota-origem
 tt-int-simula-dev-it.dt-emis-nota   
 tt-int-simula-dev-it.qt-devolvida
 tt-int-simula-dev-it.vl-unitario
 tt-int-simula-dev-it.vl-ipi   WIDTH 10
 tt-int-simula-dev-it.vl-icms  WIDTH 10 
 tt-int-simula-dev-it.vl-tot-it COLUMN-LABEL "Total Item"
 /*tt-int-simula-dev-it.dt-producao
 tt-int-simula-dev-it.dt-primeira-nf */
 tt-int-simula-dev-it.garantia
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 7
         FONT 7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-import AT ROW 5.75 COL 69 WIDGET-ID 26
     v-cod-emitente AT ROW 1.5 COL 17 COLON-ALIGNED WIDGET-ID 4
     c-nome-emit AT ROW 1.5 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     v-dt-simula AT ROW 2.5 COL 17 COLON-ALIGNED WIDGET-ID 8
     v-nr-sequencia AT ROW 2.5 COL 27 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 10
     v-cod-usuario AT ROW 2.5 COL 61 COLON-ALIGNED HELP
          "" WIDGET-ID 12
     v-it-codigo AT ROW 4.75 COL 17.14 COLON-ALIGNED WIDGET-ID 16
     v-qtd-devol AT ROW 5.75 COL 17.14 COLON-ALIGNED WIDGET-ID 20
     bt-devol AT ROW 5.71 COL 31.14 WIDGET-ID 2
     v-desc-item AT ROW 4.75 COL 29.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     br-itens AT ROW 7.75 COL 3.43 WIDGET-ID 200
     bt-ok AT ROW 15.92 COL 2 HELP
          "Salva e sai"
     bt-save AT ROW 15.92 COL 12.43 HELP
          "Salva e cria novo"
     bt-excluir AT ROW 15.92 COL 12.43 HELP
          "Cancela"
     bt-ajuda AT ROW 15.92 COL 77.72
     bt-cancela AT ROW 15.92 COL 23 HELP
          "Cancela" WIDGET-ID 28
     rt-button AT ROW 15.75 COL 1
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 14
     RECT-2 AT ROW 4.5 COL 2 WIDGET-ID 22
     RECT-3 AT ROW 7.25 COL 2 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88.14 BY 16.46
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-incmod
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-simula-dev-it T "?" NO-UNDO mgesp int-simula-dev-it
      ADDITIONAL-FIELDS:
          FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
          field dt-producao as date
          field dt-primeira-nf as date
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Inclui/Modifica <Insira o complemento>"
         HEIGHT             = 16.54
         WIDTH              = 89.29
         MAX-HEIGHT         = 26.75
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.75
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-itens v-desc-item f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-save IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-save:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-cod-emitente IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-cod-usuario IN FRAME f-cad
   NO-ENABLE LIKE = mgesp.int-simula-dev.cod-usuario EXP-SIZE           */
/* SETTINGS FOR FILL-IN v-desc-item IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-dt-simula IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-nr-sequencia IN FRAME f-cad
   NO-ENABLE LIKE = mgesp.int-simula-dev.nr-sequencia EXP-SIZE          */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-simula-dev-it.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _Query            is NOT OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Inclui/Modifica <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Inclui/Modifica <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
{include/cancefil.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-devol w-cadsim
ON CHOOSE OF bt-devol IN FRAME f-cad
DO: 
    DEFINE VARIABLE de-saldo-it       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE qt-acum           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
    DEFINE VARIABLE qtde-comprometida AS DECIMAL     NO-UNDO.

    DEFINE BUFFER b-int-simula-dev-it FOR int-simula-dev-it.
    
    IF CAN-FIND (FIRST tt-int-simula-dev-it) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Para informar outro item favor confirmar ou cancelar a sele‡Æo atual.").
        RETURN.
    END.

    ASSIGN v-qtd-devol = INPUT FRAME f-cad v-qtd-devol.
    
    IF v-qtd-devol <= 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Quantidade a devolver deve ser maior que 0.").
        RETURN.
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = v-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        FIND FIRST num-serie-rast NO-LOCK
             WHERE num-serie-rast.n-serie = v-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = num-serie-rast.it-codigo NO-ERROR.
    END.

    IF NOT AVAIL ITEM THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado item com o c¢digo informado.").
        RETURN.
    END.

    FIND FIRST int-simula-dev NO-LOCK
         WHERE ROWID(int-simula-dev) = v-row-parent NO-ERROR.

    FIND LAST int-simula-dev-it NO-LOCK
        WHERE int-simula-dev-it.cod-emitente = int-simula-dev.cod-emitente
          AND int-simula-dev-it.dt-simula    = int-simula-dev.dt-simula
          AND int-simula-dev-it.nr-sequencia = int-simula-dev.nr-sequencia NO-ERROR.

    IF AVAIL int-simula-dev-it THEN
        ASSIGN i-seq-item = int-simula-dev-it.nr-seq-it + 1.
    
    RUN utp/ut-acomp.p PERSISTEN set h-acomp.
    RUN pi-inicializar IN h-acomp (input "Buscando Notas").

    FOR EACH it-nota-fisc USE-INDEX ch-item-nota NO-LOCK
       WHERE it-nota-fisc.it-codigo = ITEM.it-codigo,
       FIRST nota-fiscal OF it-nota-fisc 
       WHERE nota-fiscal.cod-emit   = int-simula-dev.cod-emit
         AND nota-fiscal.cod-estabel = int-simula-dev.cod-estabel
         AND nota-fiscal.dt-cancela = ? 
         AND nota-fiscal.dt-entr-cli <> ?
          BY nota-fiscal.dt-emis-nota DESC
          BY it-nota-fisc.nr-seq-fat:

        RUN pi-acompanhar IN h-acomp (INPUT "Emitente:" + STRING(nota-fiscal.cod-emit) + " " + "Data: " + STRING(nota-fiscal.dt-emis-nota)).

        IF  nota-fiscal.emite-dup = YES 
        AND int-simula-dev.id-tipo-nota = 2 THEN 
            NEXT.

        IF  nota-fiscal.emite-dup = NO
        AND int-simula-dev.id-tipo-nota = 1 THEN 
            NEXT.

        ASSIGN de-saldo-it = it-nota-fisc.qt-faturada[1].

        FOR EACH devol-cli
           WHERE devol-cli.cod-estabel = it-nota-fisc.cod-estabel  
             AND devol-cli.serie       = it-nota-fisc.serie  
             AND devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis  
             AND devol-cli.it-codigo   = it-nota-fisc.it-codigo
             AND devol-cli.nr-seq      = it-nota-fisc.nr-seq-fat NO-LOCK:
           ASSIGN de-saldo-it = de-saldo-it - devol-cli.qt-devol.    
        END.

        ASSIGN qtde-comprometida = 0.    
        
        FOR EACH b-int-simula-dev-it
           WHERE b-int-simula-dev-it.cod-estabel-origem = it-nota-fisc.cod-estabel 
             AND b-int-simula-dev-it.serie-origem = it-nota-fisc.serie  
             AND b-int-simula-dev-it.nr-nota-origem = it-nota-fisc.nr-nota-fis  
             AND b-int-simula-dev-it.it-codigo = it-nota-fisc.it-codigo:

            ASSIGN qtde-comprometida = qtde-comprometida + b-int-simula-dev-it.qt-devolvida.
        END.

        ASSIGN de-saldo-it = de-saldo-it - qtde-comprometida.

        IF de-saldo-it <= 0 THEN
            NEXT.
        
        CREATE tt-int-simula-dev-it.
        ASSIGN tt-int-simula-dev-it.cod-emitente = int-simula-dev.cod-emitente
               tt-int-simula-dev-it.dt-simula    = int-simula-dev.dt-simula
               tt-int-simula-dev-it.it-codigo    = ITEM.it-codigo
               tt-int-simula-dev-it.nr-seq-it    = i-seq-item
               tt-int-simula-dev-it.nr-sequencia = int-simula-dev.nr-sequencia
               tt-int-simula-dev-it.observacao   = nota-fiscal.observ-nota
               tt-int-simula-dev-it.qt-devolvida = IF qt-acum + de-saldo-it >= v-qtd-devol THEN v-qtd-devol - qt-acum ELSE de-saldo-it
               tt-int-simula-dev-it.vl-cofins    = (it-nota-fisc.vl-finsocial * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it.vl-icms      = (it-nota-fisc.vl-icms-it   * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it.vl-icmsdifal = 0 /*(it-nota-fisc.vl-finsocial * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]*/
               tt-int-simula-dev-it.vl-icmsst    = (it-nota-fisc.vl-icmsub-it * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it.vl-ipi       = (it-nota-fisc.vl-ipi-it * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it.vl-pis       = (it-nota-fisc.vl-pis * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
               tt-int-simula-dev-it.vl-tot-it    = (it-nota-fisc.vl-tot-item / it-nota-fisc.qt-faturada[1]) * tt-int-simula-dev-it.qt-devolvida
               tt-int-simula-dev-it.vl-unitario  = it-nota-fisc.vl-preuni
               tt-int-simula-dev-it.nr-nota-origem  = nota-fiscal.nr-nota-fis
               tt-int-simula-dev-it.cod-estabel-origem  = nota-fiscal.cod-estabel
               tt-int-simula-dev-it.serie-origem        = nota-fiscal.serie
               tt-int-simula-dev-it.dt-emis-nota = nota-fiscal.dt-emis-nota.

        IF AVAIL num-serie-rast THEN DO:
             FIND FIRST b-nota-fiscal NO-LOCK 
                  WHERE b-nota-fiscal.cod-estabel  = num-serie-rast.cod-estabel
                    AND b-nota-fiscal.serie        = num-serie-rast.serie
                    AND b-nota-fiscal.nr-nota-fis  = num-serie-rast.nr-nota-fis NO-ERROR.

            ASSIGN tt-int-simula-dev-it.dt-producao    = num-serie-rast.data
                   tt-int-simula-dev-it.dt-primeira-nf = b-nota-fiscal.dt-emis-nota.
        END.

        ASSIGN qt-acum = qt-acum + de-saldo-it
               i-seq-item = i-seq-item + 1.

        IF  v-qtd-devol <= qt-acum THEN 
            LEAVE. 

    END.

    RUN pi-finalizar IN h-acomp.

    IF v-qtd-devol > qt-acum THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "NÆo foram encontradas notas suficientes para devolver a quantia " + STRING(v-qtd-devol) + "~~ Quantia encontrada nas notas " + STRING(qt-acum)).
    END.

    {&open-query-br-itens}

    ASSIGN v-it-codigo:SCREEN-VALUE IN FRAME f-cad = ""
           v-qtd-devol:SCREEN-VALUE IN FRAME f-cad = "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir w-cadsim
ON CHOOSE OF bt-excluir IN FRAME f-cad /* Excluir */
DO:

    IF AVAIL tt-int-simula-dev-it THEN DO:
        DELETE tt-int-simula-dev-it.
    END.
    {&open-query-br-itens}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-import w-cadsim
ON CHOOSE OF bt-import IN FRAME f-cad /* Importar */
DO:
    IF CAN-FIND (FIRST tt-int-simula-dev-it) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Para informar outro item favor confirmar ou cancelar a sele‡Æo atual.").
        RETURN.
    END.

    ASSIGN vg-row-int-simula-dev = v-row-parent.
    RUN esp/ftp/esftp210d.w.

    FOR EACH tt-int-simula-dev-it-glob:
        CREATE tt-int-simula-dev-it.
        BUFFER-COPY tt-int-simula-dev-it-glob TO tt-int-simula-dev-it.
    END.

    {&open-query-br-itens}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    FIND FIRST int-simula-dev NO-LOCK
         WHERE ROWID(int-simula-dev) = v-row-parent NO-ERROR.

    FOR EACH tt-int-simula-dev-it:

        FIND FIRST b-int-simula-dev-it EXCLUSIVE-LOCK
             WHERE b-int-simula-dev-it.cod-emitente   = tt-int-simula-dev-it.cod-emitente
               AND b-int-simula-dev-it.dt-simula      = tt-int-simula-dev-it.dt-simula
               AND b-int-simula-dev-it.nr-sequencia   = tt-int-simula-dev-it.nr-sequencia
               AND b-int-simula-dev-it.it-codigo      = tt-int-simula-dev-it.it-codigo
               AND b-int-simula-dev-it.nr-nota-origem     = tt-int-simula-dev-it.nr-nota-origem 
               AND b-int-simula-dev-it.cod-estabel-origem = tt-int-simula-dev-it.cod-estabel-origem
               AND b-int-simula-dev-it.serie-origem       = tt-int-simula-dev-it.serie-origem   
               /*AND b-int-simula-dev-it.vl-unitario  = tt-int-simula-dev-it.vl-unitario*/ NO-ERROR.

        IF AVAIL b-int-simula-dev-it THEN DO:
            ASSIGN b-int-simula-dev-it.qt-devolvida = b-int-simula-dev-it.qt-devolvida + tt-int-simula-dev-it.qt-devolvida
                   b-int-simula-dev-it.observacao   = b-int-simula-dev-it.observacao   + " " + tt-int-simula-dev-it.observacao
                   b-int-simula-dev-it.vl-cofins    = b-int-simula-dev-it.vl-cofins    + tt-int-simula-dev-it.vl-cofins   
                   b-int-simula-dev-it.vl-icms      = b-int-simula-dev-it.vl-icms      + tt-int-simula-dev-it.vl-icms     
                   b-int-simula-dev-it.vl-icmsdifal = b-int-simula-dev-it.vl-icmsdifal + tt-int-simula-dev-it.vl-icmsdifal
                   b-int-simula-dev-it.vl-icmsst    = b-int-simula-dev-it.vl-icmsst    + tt-int-simula-dev-it.vl-icmsst   
                   b-int-simula-dev-it.vl-ipi       = b-int-simula-dev-it.vl-ipi       + tt-int-simula-dev-it.vl-ipi      
                   b-int-simula-dev-it.vl-pis       = b-int-simula-dev-it.vl-pis       + tt-int-simula-dev-it.vl-pis      
                   b-int-simula-dev-it.vl-tot-it    = b-int-simula-dev-it.vl-tot-it    + tt-int-simula-dev-it.vl-tot-it.
        END.
        ELSE DO:

            FIND FIRST int-estrutura NO-LOCK 
                 WHERE int-estrutura.it-codigo = tt-int-simula-dev-it.it-codigo
                   AND int-estrutura.es-codigo = tt-int-simula-dev-it.it-codigo NO-ERROR.

            CREATE int-simula-dev-it.
            BUFFER-COPY tt-int-simula-dev-it TO int-simula-dev-it.

            IF AVAIL int-estrutura THEN
                ASSIGN int-simula-dev-it.garantia = int-estrutura.garantia.
        END.
    END.

    RUN dispatch IN wh-browse('open-query':U).

    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-emitente w-cadsim
ON LEAVE OF v-cod-emitente IN FRAME f-cad /* Cliente */
DO:
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INPUT FRAME f-cad v-cod-emitente NO-ERROR.
   
    IF AVAIL emitente THEN
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
    ELSE 
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-cad = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-it-codigo w-cadsim
ON F5 OF v-it-codigo IN FRAME f-cad /* Item */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=v-it-codigo
                       &campozoom=it-codigo
                       FRAME=f-cad}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-it-codigo w-cadsim
ON LEAVE OF v-it-codigo IN FRAME f-cad /* Item */
DO:
  FIND FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = v-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

  IF NOT AVAIL ITEM THEN DO:
      FIND FIRST num-serie-rast NO-LOCK
           WHERE num-serie-rast.n-serie = v-it-codigo:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

      FIND FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = num-serie-rast.it-codigo NO-ERROR.
  END.

  IF AVAIL ITEM THEN
      ASSIGN v-desc-item:SCREEN-VALUE IN FRAME f-cad = ITEM.desc-item.
  ELSE 
      ASSIGN v-desc-item:SCREEN-VALUE IN FRAME f-cad = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-it-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF v-it-codigo IN FRAME f-cad /* Item */
DO:
   APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

if v-it-codigo   :load-mouse-pointer ("image/lupa.cur") then.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY v-cod-emitente c-nome-emit v-dt-simula v-nr-sequencia v-cod-usuario 
          v-it-codigo v-qtd-devol v-desc-item 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE bt-import v-it-codigo v-qtd-devol bt-devol br-itens bt-ok bt-excluir 
         bt-ajuda bt-cancela rt-button RECT-1 RECT-2 RECT-3 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
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

  {utp/ut9000.i "ESFTP210B" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /*run pi-atualiza-parent in h_<viewer_principal> (input v-row-parent).*/
  if estado = "modificar" then
     assign bt-save:sensitive in frame {&frame-name} = no.
     
  /* Code placed here will execute AFTER standard behavior.    */
   FIND FIRST int-simula-dev NO-LOCK
        WHERE ROWID(int-simula-dev) = v-row-parent NO-ERROR.

   IF AVAIL int-simula-dev THEN DO:
       ASSIGN v-cod-emitente:SCREEN-VALUE IN FRAME f-cad = STRING(int-simula-dev.cod-emitente)
              v-dt-simula:SCREEN-VALUE IN FRAME f-cad = STRING(int-simula-dev.dt-simula)
              v-nr-sequencia:SCREEN-VALUE IN FRAME f-cad = STRING(int-simula-dev.nr-sequencia)
              v-cod-usuario:SCREEN-VALUE IN FRAME f-cad = STRING(int-simula-dev.cod-usuario).

       APPLY "leave" TO v-cod-emitente IN FRAME f-cad.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona w-cadsim 
PROCEDURE pi-reposiciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*RUN pi-reposiciona-query IN h_<query-name> (input v-row-table).*/
         
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
  {src/adm/template/snd-list.i "tt-int-simula-dev-it"}

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

