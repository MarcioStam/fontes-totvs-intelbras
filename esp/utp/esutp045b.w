&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-matriz      AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-id-titulo   AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-unid-neg    AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-movimentos NO-UNDO
    FIELD selecionado   AS LOGICAL FORMAT "x/"
    FIELD num-id-movto  LIKE movto-acordo-fatur.num-id-movto 
    FIELD num-id-titulo LIKE movto-acordo-fatur.num-id-titulo
    FIELD num-id-fatur  LIKE movto-acordo-fatur.num-id-fatur
    FIELD matriz        LIKE acordo-fatur.matriz
    FIELD cod-emitente  LIKE acordo-fatur.cod-emitente
    FIELD cod-estabel   LIKE acordo-fatur.cod-estabel
    FIELD serie         LIKE acordo-fatur.serie
    FIELD nr-nota-fis   LIKE acordo-fatur.nr-nota-fis
    FIELD dt-entrega    AS   DATE INIT ?
    FIELD nr-nota-dev   LIKE acordo-fatur.nr-nota-dev
    FIELD tipo-acordo    AS CHARACTER FORMAT "x(30)"
    FIELD cod-unid-neg  LIKE acordo-fatur.cod-unid-neg
    FIELD per-acordo    LIKE acordo-fatur.per-acordo
    FIELD periodo       LIKE acordo-fatur.periodo
    FIELD valor-origem  LIKE acordo-fatur.valor-acordo
    FIELD valor         LIKE movto-acordo-fatur.valor
    FIELD valor-baixa   LIKE movto-acordo-fatur.valor COLUMN-LABEL "Valor Baixa".

DEFINE BUFFER b-tt-movimentos FOR tt-movimentos.

def new global shared var v_cod_usuar_corren as CHARACTER format "x(12)":U label "Usuario Corrente"     column-label "Usuario Corrente" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-movimentos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-movimentos

/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-movimentos.selecionado tt-movimentos.cod-estabel tt-movimentos.serie tt-movimentos.nr-nota-fis tt-movimentos.dt-entrega tt-movimentos.matriz tt-movimentos.cod-emitente tt-movimentos.periodo tt-movimentos.cod-unid-neg tt-movimentos.tipo-acordo tt-movimentos.per-acordo tt-movimentos.valor-origem tt-movimentos.valor tt-movimentos.valor-baixa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos tt-movimentos.valor-baixa   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH tt-movimentos                            WHERE tt-movimentos.periodo     BEGINS INPUT FRAME fPage0 fi-periodo                              AND tt-movimentos.nr-nota-fis BEGINS INPUT FRAME fPage0 fi-nr-nota-fis                              AND tt-movimentos.tipo-acordo BEGINS INPUT FRAME fPage0 fi-tipo-acordo
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos                            WHERE tt-movimentos.periodo     BEGINS INPUT FRAME fPage0 fi-periodo                              AND tt-movimentos.nr-nota-fis BEGINS INPUT FRAME fPage0 fi-nr-nota-fis                              AND tt-movimentos.tipo-acordo BEGINS INPUT FRAME fPage0 fi-tipo-acordo.
&Scoped-define TABLES-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos tt-movimentos


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-movimentos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-13 btCarrega fi-periodo ~
fi-nr-nota-fis fi-tipo-acordo br-movimentos btMarcaTodos btDesmarcaTodos ~
ed-observacoes btSalvar btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-periodo fi-nr-nota-fis fi-tipo-acordo ~
fi-valor-total fi-valor-baixa ed-observacoes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Carrega" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btDesmarcaTodos 
     LABEL "Desmarca Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btMarcaTodos 
     LABEL "Marca Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-observacoes AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 120.14 BY 3.08 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "X(06)":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-acordo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Acordo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-baixa AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Baixa" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-total AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 122 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-movimentos FOR 
      tt-movimentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos wWindow _FREEFORM
  QUERY br-movimentos DISPLAY
      tt-movimentos.selecionado            COLUMN-LABEL ""
      tt-movimentos.cod-estabel            COLUMN-LABEL "Est"            WIDTH 2.8  
      tt-movimentos.serie                  COLUMN-LABEL "Ser"            WIDTH 2.8  
      tt-movimentos.nr-nota-fis            COLUMN-LABEL "Nota Fisc"      WIDTH 7
      tt-movimentos.dt-entrega             COLUMN-LABEL "Dt Entrega"     WIDTH 9
      tt-movimentos.matriz                 COLUMN-LABEL "Matriz"         WIDTH 7
      tt-movimentos.cod-emitente           COLUMN-LABEL "Cliente"        WIDTH 7
      tt-movimentos.periodo                COLUMN-LABEL "Per¡odo"        WIDTH 6   
      tt-movimentos.cod-unid-neg           COLUMN-LABEL "Un.Neg"         WIDTH 5.5
      tt-movimentos.tipo-acordo            COLUMN-LABEL "Tipo Acordo"    WIDTH 22  
      tt-movimentos.per-acordo             COLUMN-LABEL "% Acor"         WIDTH 5
      tt-movimentos.valor-origem           COLUMN-LABEL "Valor Origem"   WIDTH 12
      tt-movimentos.valor                  COLUMN-LABEL "Valor"          WIDTH 12  
      tt-movimentos.valor-baixa            COLUMN-LABEL "Valor Baixa"    WIDTH 12
      ENABLE tt-movimentos.valor-baixa
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120.29 BY 12.29
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCarrega AT ROW 1.75 COL 96.29 HELP
          "V  Para" WIDGET-ID 98
     fi-periodo AT ROW 1.96 COL 28.72 COLON-ALIGNED HELP
          "Per¡odo AAAAMM" WIDGET-ID 18
     fi-nr-nota-fis AT ROW 1.96 COL 51.72 COLON-ALIGNED HELP
          "N£mero da Nota Fiscal" WIDGET-ID 16
     fi-tipo-acordo AT ROW 1.96 COL 77.72 COLON-ALIGNED WIDGET-ID 100
     br-movimentos AT ROW 3.75 COL 2.72 WIDGET-ID 300
     btMarcaTodos AT ROW 16.13 COL 2.72 WIDGET-ID 8
     btDesmarcaTodos AT ROW 16.13 COL 14 WIDGET-ID 10
     fi-valor-total AT ROW 16.21 COL 83.29 COLON-ALIGNED WIDGET-ID 6
     fi-valor-baixa AT ROW 16.21 COL 108 COLON-ALIGNED WIDGET-ID 4
     ed-observacoes AT ROW 17.29 COL 2.86 NO-LABEL WIDGET-ID 2
     btSalvar AT ROW 20.71 COL 2.14 WIDGET-ID 12
     btFechar AT ROW 20.71 COL 12.14 WIDGET-ID 14
     btHelp2 AT ROW 20.71 COL 112.14
     "Filtro:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 1.13 COL 23.86 WIDGET-ID 88
     rtToolBar AT ROW 20.5 COL 1
     RECT-13 AT ROW 1.42 COL 22.72 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123 BY 20.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Baixa Notas Fiscais X T¡tulo - ESUTP045B"
         COLUMN             = 4.72
         ROW                = 6.13
         HEIGHT             = 20.92
         WIDTH              = 123
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-movimentos fi-tipo-acordo fpage0 */
/* SETTINGS FOR FILL-IN fi-valor-baixa IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-total IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-movimentos
/* Query rebuild information for BROWSE br-movimentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos
                           WHERE tt-movimentos.periodo     BEGINS INPUT FRAME fPage0 fi-periodo
                             AND tt-movimentos.nr-nota-fis BEGINS INPUT FRAME fPage0 fi-nr-nota-fis
                             AND tt-movimentos.tipo-acordo BEGINS INPUT FRAME fPage0 fi-tipo-acordo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-movimentos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Baixa Notas Fiscais X T¡tulo - ESUTP045B */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Baixa Notas Fiscais X T¡tulo - ESUTP045B */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-movimentos
&Scoped-define SELF-NAME br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON MOUSE-SELECT-DBLCLICK OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN tt-movimentos.selecionado = NOT tt-movimentos.selecionado
               tt-movimentos.valor-baixa = IF tt-movimentos.selecionado THEN tt-movimentos.valor ELSE 0.

        br-movimentos:REFRESH().
    END.

    RUN pi-totaliza.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON ROW-DISPLAY OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        IF tt-movimentos.selecionado THEN DO:
            RUN pi-muda-cor(INPUT 3 , INPUT 15).
        END.
        ELSE DO:
            RUN pi-muda-cor(INPUT ?, INPUT ?).
        END.
    END.
    ELSE RUN pi-muda-cor(INPUT ?, INPUT ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON ROW-LEAVE OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN INPUT BROWSE br-movimentos tt-movimentos.valor-baixa.

        /*IF DEC(tt-movimentos.valor-baixa:SCREEN-VALUE IN BROWSE br-movimentos) = 0 THEN DO:
            ASSIGN tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "no".
        END.
        ELSE DO:
            IF tt-movimentos.valor > 0 THEN DO:
                IF DEC(tt-movimentos.valor-baixa:SCREEN-VALUE IN BROWSE br-movimentos) <= tt-movimentos.valor THEN DO:
                    ASSIGN tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "YES".
                END.
                ELSE DO:
                    MESSAGE "Valor Baixa superior ao saldo, favor informe um valor de at‚: " + STRING(tt-movimentos.valor,"->>>,>>>,>>9.99")
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN NO-APPLY.
                END.
            END.
            ELSE DO:
                IF DEC(tt-movimentos.valor-baixa:SCREEN-VALUE IN BROWSE br-movimentos) >= tt-movimentos.valor THEN DO:
                    ASSIGN tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "YES".
                END.
                ELSE DO:
                    MESSAGE "Valor Baixa inferior ao saldo, favor informe um valor de at‚: " + STRING(tt-movimentos.valor,"->>>,>>>,>>9.99")
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN NO-APPLY.
                END.
            END.
        END.*/

        IF DEC(tt-movimentos.valor-baixa) = 0 THEN DO:
            ASSIGN tt-movimentos.selecionado = NO
                   tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "NO".
        END.
        ELSE DO:
            IF tt-movimentos.valor > 0 THEN DO:
                IF DEC(tt-movimentos.valor-baixa) <= tt-movimentos.valor AND DEC(tt-movimentos.valor-baixa) > 0 THEN DO:
                    ASSIGN tt-movimentos.selecionado = YES
                           tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "YES".
                END.
                ELSE DO:
                    MESSAGE "Valor Baixa superior ao saldo, favor informe um valor de: 0,00 at‚: " + TRIM(STRING(tt-movimentos.valor,"->>>,>>>,>>9.99"))
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN NO-APPLY.
                END.
            END.
            ELSE DO:
                IF DEC(tt-movimentos.valor-baixa) >= tt-movimentos.valor AND DEC(tt-movimentos.valor-baixa) < 0 THEN DO:
                    ASSIGN tt-movimentos.selecionado = YES
                           tt-movimentos.selecionado:SCREEN-VALUE IN BROWSE br-movimentos = "YES".
                END.
                ELSE DO:
                    MESSAGE "Valor Baixa inferior ao saldo, favor informe um valor de: " + TRIM(STRING(tt-movimentos.valor,"->>>,>>>,>>9.99")) + " at‚: 0,00"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN NO-APPLY.
                END.
            END.
        END.



        br-movimentos:REFRESH().
    END.


    RUN pi-totaliza.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Carrega */
DO:

    FOR EACH tt-movimentos:

        ASSIGN tt-movimentos.selecionado = NO
               tt-movimentos.valor-baixa = 0.
    END.

    RUN pi-totaliza.
  {&open-query-br-movimentos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcaTodos wWindow
ON CHOOSE OF btDesmarcaTodos IN FRAME fpage0 /* Desmarca Todos */
DO:
    FOR EACH tt-movimentos
       WHERE tt-movimentos.periodo     BEGINS INPUT FRAME fPage0 fi-periodo
         AND tt-movimentos.nr-nota-fis BEGINS INPUT FRAME fPage0 fi-nr-nota-fis
         AND tt-movimentos.tipo-acordo BEGINS INPUT FRAME fPage0 fi-tipo-acordo.

        ASSIGN tt-movimentos.selecionado = NO
               tt-movimentos.valor-baixa = 0.
    END.
    br-movimentos:REFRESH().
    RUN pi-totaliza.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcaTodos wWindow
ON CHOOSE OF btMarcaTodos IN FRAME fpage0 /* Marca Todos */
DO:
    FOR EACH tt-movimentos
       WHERE tt-movimentos.periodo     BEGINS INPUT FRAME fPage0 fi-periodo
         AND tt-movimentos.nr-nota-fis BEGINS INPUT FRAME fPage0 fi-nr-nota-fis
         AND tt-movimentos.tipo-acordo BEGINS INPUT FRAME fPage0 fi-tipo-acordo.
        ASSIGN tt-movimentos.selecionado = YES
               tt-movimentos.valor-baixa = tt-movimentos.valor.
    END.
    br-movimentos:REFRESH().
    RUN pi-totaliza.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
    DEFINE VARIABLE de-valor-baixa   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-erro           AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-seq-movto      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor-baixado AS DECIMAL     NO-UNDO.
    
    ASSIGN INPUT FRAME fPage0 ed-observacoes.

    ASSIGN de-valor-baixa = 0.
    FOR EACH tt-movimentos WHERE tt-movimentos.selecionado:
        ASSIGN de-valor-baixa = de-valor-baixa + tt-movimentos.valor-baixa.
    END.

    IF de-valor-baixa = 0 OR NOT CAN-FIND(FIRST tt-movimentos NO-LOCK WHERE tt-movimentos.selecionado) THEN DO:
        MESSAGE "Favor selecione algum registro para efetuar a baixa"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.                       
        RETURN NO-APPLY.
    END.

    IF ed-observacoes = "" THEN DO:
        MESSAGE "Observa‡äes deve ser informado!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO ed-observacoes IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab     = p-cod-estabel
           AND tit_ap.num_id_tit_ap = p-id-titulo NO-ERROR.
    IF NOT AVAIL tit_ap THEN DO:
        MESSAGE "T¡tulo nÆo encontrado, processo cancelado!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.

    ASSIGN de-valor-baixado = 0.
    FOR EACH movto-acordo-fatur NO-LOCK
       WHERE movto-acordo-fatur.num-id-titulo  = p-id-titulo
         AND movto-acordo-fatur.usuario-cancel = "":
        ASSIGN de-valor-baixado = de-valor-baixado + movto-acordo-fatur.valor.
    END.

    /*IF de-valor-baixa > (tit_ap.val_origin_tit_ap - tit_ap.val_sdo_tit_ap - de-valor-baixado) THEN DO:
        MESSAGE "Valor da Baixa maior que a diferen‡a entre Financeiro e Faturamento"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.*/

    IF de-valor-baixa < (tit_ap.val_origin_tit_ap - tit_ap.val_sdo_tit_ap - de-valor-baixado) THEN DO:
        MESSAGE "Valor da Baixa menor que a diferen‡a entre Financeiro e Faturamento. Confirma baixa?"
            VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l-confirma AS LOG.

        IF NOT l-confirma THEN
            RETURN NO-APPLY.
    END.

    ASSIGN l-erro = NO
           i-seq-movto = NEXT-VALUE(seq_movto_acordo).
    BAIXA:
    DO TRANSACTION ON ERROR UNDO BAIXA, LEAVE BAIXA:
        FOR EACH tt-movimentos WHERE tt-movimentos.selecionado:
            FIND FIRST acordo-fatur EXCLUSIVE-LOCK
                 WHERE acordo-fatur.num-id-fatur = tt-movimentos.num-id-fatur
                   AND acordo-fatur.saldo       >= tt-movimentos.valor-baixa NO-ERROR.
            IF NOT AVAIL acordo-fatur THEN DO:
                MESSAGE "NÆo encontrou registro faturamento ou saldo do faturamento menor que valor baixa, processo cancelado!"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                ASSIGN l-erro = YES.
                LEAVE.
            END.
            ELSE DO:
                ASSIGN acordo-fatur.saldo = acordo-fatur.saldo - tt-movimentos.valor-baixa.

                CREATE movto-acordo-fatur.
                ASSIGN movto-acordo-fatur.num-id-movto  = i-seq-movto
                       movto-acordo-fatur.num-id-titulo = p-id-titulo /*tt-movimentos.num-id-titulo*/
                       movto-acordo-fatur.num-id-fatur  = tt-movimentos.num-id-fatur
                       movto-acordo-fatur.data          = TODAY
                       movto-acordo-fatur.hora          = STRING(TIME,"HH:MM:SS")
                       movto-acordo-fatur.usuario       = v_cod_usuar_corren
                       movto-acordo-fatur.valor         = tt-movimentos.valor-baixa
                       movto-acordo-fatur.observacoes   = ed-observacoes.
            END.
        END.

        IF l-erro THEN
            UNDO BAIXA, LEAVE BAIXA.
    END.

    IF NOT l-erro THEN DO:
        APPLY "close" TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

  RUN pi-carrega-dados.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN INPUT FRAME fPage0 fi-periodo
                              fi-nr-nota-fis
                              fi-tipo-acordo.
                    
    DEFINE VARIABLE de-valor-total AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.

    FOR EACH tt-movimentos:
        DELETE tt-movimentos.
    END.

    /*FOR EACH movto-acordo-fatur NO-LOCK
       WHERE movto-acordo-fatur.num-id-titulo = p-id-titulo
         AND movto-acordo-fatur.num-id-movto  = p-id-movto,
       FIRST acordo-fatur NO-LOCK
       WHERE acordo-fatur.num-id-fatur = movto-acordo-fatur.num-id-fatur:

        CREATE tt-movimentos.
        ASSIGN tt-movimentos.num-id-titulo = movto-acordo-fatur.num-id-titulo
               tt-movimentos.num-id-movto  = movto-acordo-fatur.num-id-movto 
               tt-movimentos.cod-estabel   = acordo-fatur.cod-estabel   
               tt-movimentos.serie         = acordo-fatur.serie         
               tt-movimentos.nr-nota-fis   = acordo-fatur.nr-nota-fis   
               tt-movimentos.nr-nota-dev   = acordo-fatur.nr-nota-dev
               tt-movimentos.tipo-acordo   = acordo-fatur.tipo-acordo
               tt-movimentos.usuario       = movto-acordo-fatur.usuario 
               tt-movimentos.data          = movto-acordo-fatur.data    
               tt-movimentos.hora          = movto-acordo-fatur.hora    
               tt-movimentos.valor         = movto-acordo-fatur.valor.  
    END.*/

    ASSIGN de-valor-total = 0.

    FOR EACH acordo-fatur NO-LOCK
       WHERE acordo-fatur.cod-estabel    = p-cod-estabel
         AND acordo-fatur.matriz         = p-matriz
         AND acordo-fatur.cod-unid-neg   = p-unid-neg
         AND acordo-fatur.num-id-titulo <> 0 /*nao puxar pendencias*/
         AND acordo-fatur.num-id-titulo <> 1 /*nao puxar devolucoes*/
         AND acordo-fatur.saldo          > 0:

        
        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = acordo-fatur.tipo-acordo NO-ERROR.

        CREATE tt-movimentos.
        ASSIGN tt-movimentos.num-id-movto  = 0
               tt-movimentos.num-id-fatur  = acordo-fatur.num-id-fatur
               tt-movimentos.matriz        = acordo-fatur.matriz
               tt-movimentos.cod-estabel   = acordo-fatur.cod-estabel   
               tt-movimentos.num-id-titulo = acordo-fatur.num-id-titulo 
               tt-movimentos.serie         = acordo-fatur.serie         
               tt-movimentos.nr-nota-fis   = acordo-fatur.nr-nota-fis   
               tt-movimentos.matriz        = acordo-fatur.matriz   
               tt-movimentos.cod-emitente  = acordo-fatur.cod-emitente   
               tt-movimentos.nr-nota-dev   = acordo-fatur.nr-nota-dev
               tt-movimentos.cod-unid-neg  = acordo-fatur.cod-unid-neg
               tt-movimentos.tipo-acordo   = STRING(acordo-fatur.tipo-acordo) + "-" + IF AVAIL tipo-acordo THEN tipo-acordo.descricao ELSE "Nao cadastrado"
               tt-movimentos.periodo       = acordo-fatur.periodo
               tt-movimentos.per-acordo    = acordo-fatur.per-acordo    
               tt-movimentos.valor-origem  = acordo-fatur.valor-acordo
               tt-movimentos.valor         = acordo-fatur.saldo
               tt-movimentos.valor-baixa   = 0.  

        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = acordo-fatur.cod-estabel
              AND  nota-fiscal.serie       = acordo-fatur.serie
              AND  nota-fiscal.nr-nota-fis = acordo-fatur.nr-nota-fis NO-ERROR.
        IF  AVAIL  nota-fiscal THEN 
            ASSIGN tt-movimentos.dt-entrega = nota-fiscal.dt-entr-cli.

        ASSIGN de-valor-total = de-valor-total + tt-movimentos.valor.
    END.

    ASSIGN fi-valor-total:SCREEN-VALUE IN FRAME fPage0 = STRING(de-valor-total,"->>>,>>>,>>9.99").

    {&open-query-br-movimentos}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor wWindow 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-bgcolor AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-fgcolor AS INTEGER     NO-UNDO.

    /*cor de fundo*/
    ASSIGN tt-movimentos.selecionado:BGCOLOR  IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.cod-estabel:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.serie:BGCOLOR       IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.nr-nota-fis:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.matriz:BGCOLOR      IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.cod-emitente:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.cod-unid-neg:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.tipo-acordo:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.periodo:BGCOLOR     IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.per-acordo:BGCOLOR  IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.valor-origem:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.valor:BGCOLOR       IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.valor-baixa:BGCOLOR IN BROWSE br-movimentos = p-bgcolor.

    /*cor da letra*/
    ASSIGN tt-movimentos.selecionado:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.cod-estabel:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.serie:FGCOLOR       IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.nr-nota-fis:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.matriz:FGCOLOR      IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.cod-emitente:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.cod-unid-neg:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.tipo-acordo:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.periodo:FGCOLOR     IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.per-acordo:FGCOLOR  IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.valor-origem:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.valor:FGCOLOR       IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.valor-baixa:FGCOLOR IN BROWSE br-movimentos = p-fgcolor.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza wWindow 
PROCEDURE pi-totaliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-valor-baixas AS DECIMAL     NO-UNDO.

    ASSIGN de-valor-baixas = 0.
    IF AVAIL tt-movimentos THEN DO:
        FOR EACH b-tt-movimentos WHERE b-tt-movimentos.selecionado:
            ASSIGN de-valor-baixas = de-valor-baixas + b-tt-movimentos.valor-baixa.
        END.
    END.

    ASSIGN fi-valor-baixa:SCREEN-VALUE IN FRAME fPage0 = STRING(de-valor-baixas,"->>>,>>>,>>9.99").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

