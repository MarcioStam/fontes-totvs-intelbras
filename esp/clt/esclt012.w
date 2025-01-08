&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCLT012 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT012
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-cod-estab fi-local fi-endereco bt-sair br-etiqueta
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&Scoped-define BROWSE-NAME br-etiqueta

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bosc047      AS HANDLE    NO-UNDO.

DEFINE VARIABLE pcod-estabel   AS CHARACTER NO-UNDO.
DEFINE VARIABLE pcod-local     AS CHARACTER NO-UNDO.
DEFINE VARIABLE wh-bosc035     AS HANDLE    NO-UNDO.

DEFINE VARIABLE d-qtd-atual    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-qtd-alocada  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-qtd-liberada AS DECIMAL   NO-UNDO.

DEFINE VARIABLE h-bo-wmbox2    AS HANDLE    NO-UNDO.

DEF TEMP-TABLE tt-etiqueta
    FIELD cod-produto   AS CHAR.

DEF TEMP-TABLE ttResumoBox  NO-UNDO
    FIELD id-etiqueta              LIKE wm-etiqueta.id-etiqueta
    FIELD id-agrupador             LIKE wm-etiqueta.id-agrupador
    FIELD cod-serial               LIKE wm-etiqueta.cod-serial
    FIELD cod-item                 LIKE wm-etiqueta.cod-item
    FIELD ind-leitura-etiqueta     LIKE wm-etiqueta.ind-leitura-etiqueta
    FIELD cod-refer                LIKE wm-etiqueta.cod-refer
    FIELD cod-lote                 LIKE wm-etiqueta.cod-lote
    FIELD dt-validade-lote         LIKE wm-etiqueta.dt-validade-lote
    FIELD qtd-item                 LIKE wm-etiqueta.qtd-item
    FIELD qtd-item-retirado        LIKE wm-etiqueta.qtd-item-retirado
    FIELD id-carga                 LIKE wm-etiqueta.id-carga
    FIELD des-item                 LIKE wm-item.des-item
    FIELD r-rowid                  AS ROWID
    INDEX codigo1 id-etiqueta
                  id-agrupador
    INDEX codigo2 id-agrupador.

DEF TEMP-TABLE ttResumo NO-UNDO
         FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
         FIELD cod-local        LIKE  wm-box-saldo.cod-local
         FIELD cod-item         LIKE  wm-box-saldo.cod-item
         FIELD cod-refer        LIKE  wm-box-saldo.cod-refer
         FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
         FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
         FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
         FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem
         FIELD cod-cliente      LIKE  wm-box-saldo.cod-cliente
/*          &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN */
            FIELD log-bloq-movto-cq LIKE wm-box-saldo.log-bloq-movto-cq
            FIELD desc-lote-estado  AS CHARACTER FORMAT "x(20)"
/*          &ENDIF */
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 IS UNIQUE  cod-item
                                  cod-refer
                                  cod-lote
                                  dt-transacao   
                                  cod-embalagem 
                                  qtd-original 
                                  qtd-item
                                  qtd-item-bloq
                                  ind-status-saldo.

    DEF TEMP-TABLE ttResumoItem NO-UNDO
         FIELD id-box            LIKE  wm-box-saldo.id-box
         FIELD ind-status-box    LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo  LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem     LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item          LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-alocad   LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qtd-item-liberado LIKE  wm-box-saldo.qtd-item-bloq
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 id-box   
                       cod-embalagem
                       ind-status-saldo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttResumoBox

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta ttResumobox.id-etiqueta ttResumobox.qtd-item ttResumobox.qtd-item-retirado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH ttResumoBox
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH ttResumoBox.
&Scoped-define TABLES-IN-QUERY-br-etiqueta ttResumoBox
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta ttResumoBox


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-endereco fi-cod-estab fi-local ~
br-etiqueta fi-cod-item fi-desc-item fi-qtd-item fi-qtd-item-alocad ~
fi-qtd-item-liberado fi-ind-status-saldo bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-endereco fi-cod-estab fi-local ~
fi-cod-item fi-desc-item fi-qtd-item fi-qtd-item-alocad ~
fi-qtd-item-liberado fi-ind-status-saldo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "X(05)":U 
     LABEL "Estabel" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-cod-item AS CHARACTER FORMAT "X(16)":U INITIAL "0" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desc. Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 203 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-endereco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Endere‡o" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-ind-status-saldo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Status Saldo" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(05)":U 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd-item AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qtd. Atual" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd-item-alocad AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qtd. Alocad." 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd-item-liberado AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qtd. Liberada" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      ttResumoBox SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta wWindow _FREEFORM
  QUERY br-etiqueta DISPLAY
      ttResumobox.id-etiqueta   COLUMN-LABEL "Id. Etq"
   ttResumobox.qtd-item
   ttResumobox.qtd-item-retirado
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 42 BY 2
          &ELSE SIZE-PIXELS 294 BY 55 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-endereco AT Y 31 X 64 COLON-ALIGNED WIDGET-ID 84
     fi-cod-estab AT Y 7 X 64 COLON-ALIGNED WIDGET-ID 2
     fi-local AT Y 7 X 155 COLON-ALIGNED WIDGET-ID 82
     br-etiqueta AT Y 201 X 3 WIDGET-ID 200
     fi-cod-item AT Y 56 X 64 COLON-ALIGNED WIDGET-ID 60
     fi-desc-item AT Y 80 X 64 COLON-ALIGNED WIDGET-ID 62
     fi-qtd-item AT Y 104 X 64 COLON-ALIGNED WIDGET-ID 64
     fi-qtd-item-alocad AT Y 128 X 64 COLON-ALIGNED WIDGET-ID 66
     fi-qtd-item-liberado AT Y 151 X 64 COLON-ALIGNED WIDGET-ID 68
     fi-ind-status-saldo AT Y 175 X 63 COLON-ALIGNED WIDGET-ID 78
     bt-sair AT Y 163 X 235 WIDGET-ID 150
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         TITLE              = ""
         HEIGHT-P           = 263
         WIDTH-P            = 301
         MAX-HEIGHT-P       = 737
         MAX-WIDTH-P        = 1280
         VIRTUAL-HEIGHT-P   = 737
         VIRTUAL-WIDTH-P    = 1280
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-etiqueta fi-local fpage0 */
ASSIGN 
       FRAME fpage0:HEIGHT           = 22.05
       FRAME fpage0:WIDTH            = 111.01.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttResumoBox.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
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
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab wWindow
ON RETURN OF fi-cod-estab IN FRAME fpage0 /* Estabel */
DO:
    
    APPLY "ENTRY" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-endereco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-endereco wWindow
ON RETURN OF fi-endereco IN FRAME fpage0 /* Endere‡o */
DO:
    
   DEFINE VARIABLE d-qtde-atual  AS DECIMAL     NO-UNDO.

   IF NOT VALID-HANDLE(wh-bosc035)  THEN DO:
       RUN scbo/bosc035.p PERSISTENT SET wh-bosc035.
       RUN openQueryStatic IN wh-bosc035 (INPUT "Main":U) NO-ERROR. 
    END.  

    ASSIGN 
          // fi-dt-transacao:SCREEN-VALUE IN FRAME fPage0 = ""
          // fi-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-cod-item:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-qtd-item:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-qtd-item-alocad:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-qtd-item-liberado:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-ind-status-saldo:SCREEN-VALUE IN FRAME fPage0 = "".
          // fi-ind-status-box:SCREEN-VALUE IN FRAME fPage0 = "".

    IF VALID-HANDLE(wh-bosc035) THEN DO:
        FOR EACH ttResumo:
            DELETE ttResumo.
        END.

        RUN getOcupacaoBox in wh-bosc035 (INPUT fi-cod-estab:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT fi-local:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT int(fi-endereco:SCREEN-VALUE IN FRAME fPage0),
                                          OUTPUT TABLE ttResumo).

        FOR FIRST ttResumo:            
            RUN getOcupacaoItem IN wh-bosc035 (INPUT ttResumo.cod-estabel,
                                               INPUT ttResumo.cod-local,
                                               INPUT string(ttResumo.cod-cliente),
                                               INPUT ttResumo.cod-item,
                                               INPUT ttResumo.cod-refer,
                                               INPUT ttResumo.cod-lote,
                                               OUTPUT d-qtde-atual,
                                               OUTPUT TABLE ttResumoItem).

            ASSIGN d-qtd-atual    = 0
                   d-qtd-alocada  = 0
                   d-qtd-liberada = 0.

            FOR EACH ttResumoItem WHERE
                     ttResumoItem.id-box = int(fi-endereco:SCREEN-VALUE IN FRAME fPage0):

                FIND FIRST ITEM NO-LOCK
                     WHERE  ITEM.it-codigo = ttResumo.cod-item NO-ERROR.

                ASSIGN d-qtd-atual    = d-qtd-atual    + ttResumoItem.qtd-item
                       d-qtd-alocada  = d-qtd-alocada  + ttResumoItem.qtd-item-alocad
                       d-qtd-liberada = d-qtd-liberada + ttResumoItem.qtd-item-liberado.

                ASSIGN 
                      // fi-dt-transacao:SCREEN-VALUE IN FRAME fPage0 = STRING(ttResumo.dt-transacao)
                      // fi-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 = ttResumo.cod-embalagem
                       fi-cod-item:SCREEN-VALUE IN FRAME fPage0 = ttResumo.cod-item
                       fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item
                      // fi-qtd-item:SCREEN-VALUE IN FRAME fPage0 = STRING(ttResumoItem.qtd-item)
                      // fi-qtd-item-alocad:SCREEN-VALUE IN FRAME fPage0 = STRING(ttResumoItem.qtd-item-alocad)
                      // fi-qtd-item-liberado:SCREEN-VALUE IN FRAME fPage0 = STRING(ttResumoItem.qtd-item-liberado)
                       fi-ind-status-saldo:SCREEN-VALUE IN FRAME fPage0 = {scinc/i01sc035.i 04 ttResumoItem.ind-status-saldo}.
                      // fi-ind-status-box:SCREEN-VALUE IN FRAME fPage0 = {scinc/i01sc030.i 04 ttResumoItem.ind-status-box}.
            END.

            ASSIGN fi-qtd-item:SCREEN-VALUE IN FRAME fPage0 = STRING(d-qtd-atual)
                   fi-qtd-item-alocad:SCREEN-VALUE IN FRAME fPage0 = STRING(d-qtd-alocada)
                   fi-qtd-item-liberado:SCREEN-VALUE IN FRAME fPage0 = STRING(d-qtd-liberada).

        END.
    END.

    IF NOT VALID-HANDLE(h-bo-wmbox2) THEN DO:
        Run scbo/bosc030.p Persistent Set h-bo-wmbox2     No-error.
        Run openQueryStatic In h-bo-wmbox2 (Input "Main":U) No-error.
    END.

    RUN openQueryStatic IN h-bo-wmbox2 (INPUT "main") .

    FOR EACH ttResumoBox: DELETE ttResumoBox. END.
    
    RUN RetornarTtResumos IN h-bo-wmbox2 (INPUT fi-cod-estab:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT fi-local:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT int(fi-endereco:SCREEN-VALUE IN FRAME fPage0),
                                          INPUT 1,
                                          INPUT 2,
                                          INPUT 3,
                                          OUTPUT TABLE ttResumoBox).


    {&OPEN-QUERY-{&BROWSE-NAME}}

    IF  VALID-HANDLE(h-bo-wmbox2) THEN
    DELETE PROCEDURE h-bo-wmbox2 NO-ERROR.
    
    APPLY "entry" TO fi-endereco.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wWindow
ON RETURN OF fi-local IN FRAME fpage0 /* Local */
DO:
    
    APPLY "ENTRY" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
    
RUN getEstabelLocalPad IN h-bosc047 (OUTPUT pcod-estabel,
                                     OUTPUT pcod-local).

ASSIGN fi-cod-estab:SCREEN-VALUE IN FRAME fPage0 = pcod-estabel
       fi-local:SCREEN-VALUE IN FRAME fPage0 = pcod-local.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

