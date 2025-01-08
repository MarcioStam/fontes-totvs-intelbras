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
{include/i-prgvrs.i ESCLT011 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT011
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-pick br-contenedor fi-etiqueta bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE tt-pick
    FIELD bloco  AS CHAR FORMAT "x(5)"
    FIELD rua    AS CHAR FORMAT "x(5)"
    FIELD nivel  AS CHAR FORMAT "x(5)"
    FIELD coluna AS CHAR FORMAT "x(5)".     

DEF TEMP-TABLE tt-contenedor
    FIELD tipo        AS CHAR FORMAT "x(2)"
    FIELD qtde        LIKE item-caixa.qt-item
    FIELD altura      LIKE embalag.altura 
    FIELD largura     LIKE embalag.largura
    FIELD comprimento LIKE embalag.comprim
    FIELD peso-bruto  LIKE ITEM.peso-bruto
    FIELD peso-liq    LIKE ITEM.peso-liq.
    


{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */

DEF VAR c-item AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-contenedor

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-contenedor tt-pick

/* Definitions for BROWSE br-contenedor                                 */
&Scoped-define FIELDS-IN-QUERY-br-contenedor tt-contenedor.tipo /*tt-contenedor.sigla */ tt-contenedor.qtde /*tt-contenedor.desc-emb */ tt-contenedor.altura tt-contenedor.largura tt-contenedor.comprimento tt-contenedor.peso-bruto tt-contenedor.peso-liq   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contenedor   
&Scoped-define SELF-NAME br-contenedor
&Scoped-define QUERY-STRING-br-contenedor FOR EACH tt-contenedor
&Scoped-define OPEN-QUERY-br-contenedor OPEN QUERY {&SELF-NAME} FOR EACH tt-contenedor.
&Scoped-define TABLES-IN-QUERY-br-contenedor tt-contenedor
&Scoped-define FIRST-TABLE-IN-QUERY-br-contenedor tt-contenedor


/* Definitions for BROWSE br-pick                                       */
&Scoped-define FIELDS-IN-QUERY-br-pick tt-pick.bloco tt-pick.rua tt-pick.nivel tt-pick.coluna   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pick   
&Scoped-define SELF-NAME br-pick
&Scoped-define QUERY-STRING-br-pick FOR EACH tt-pick
&Scoped-define OPEN-QUERY-br-pick OPEN QUERY {&SELF-NAME} FOR EACH tt-pick.
&Scoped-define TABLES-IN-QUERY-br-pick tt-pick
&Scoped-define FIRST-TABLE-IN-QUERY-br-pick tt-pick


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-contenedor}~
    ~{&OPEN-QUERY-br-pick}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-etiqueta br-contenedor br-pick bt-sair ~
fi-estab-user fi-item 
&Scoped-Define DISPLAYED-OBJECTS fi-etiqueta fi-estab-user fi-item 

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
     SIZE-PIXELS 63 BY 19
     FONT 4.

DEFINE VARIABLE fi-estab-user AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6.43 BY .75
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(20)":U 
     LABEL "EAN13/DUN14/Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 150 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-item AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 311 BY 18
     FGCOLOR 9 FONT 0 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contenedor FOR 
      tt-contenedor SCROLLING.

DEFINE QUERY br-pick FOR 
      tt-pick SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contenedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contenedor wWindow _FREEFORM
  QUERY br-contenedor DISPLAY
      tt-contenedor.tipo        COLUMN-LABEL "Orig"   WIDTH 2.7
      /*tt-contenedor.sigla       COLUMN-LABEL "Sig"    WIDTH 3.5 */
      tt-contenedor.qtde        COLUMN-LABEL "Qt CX"  FORMAT ">>>>9" WIDTH 4.5
      /*tt-contenedor.desc-emb    COLUMN-LABEL "Desc"   WIDTH 10 */
      tt-contenedor.altura      COLUMN-LABEL "Altu"   WIDTH 5.4   
      tt-contenedor.largura     COLUMN-LABEL "Larg"   WIDTH 5.4   
      tt-contenedor.comprimento COLUMN-LABEL "Compr"  WIDTH 6.0
      tt-contenedor.peso-bruto  COLUMN-LABEL "P. Bruto" WIDTH 6.9
      tt-contenedor.peso-liq    COLUMN-LABEL "P. Liq." WIDTH 6.9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 45 BY 4
          &ELSE SIZE-PIXELS 313 BY 95 &ENDIF
         FONT 4 ROW-HEIGHT-CHARS .46.

DEFINE BROWSE br-pick
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pick wWindow _FREEFORM
  QUERY br-pick DISPLAY
      tt-pick.bloco       LABEL "Bloco"  WIDTH 4
      tt-pick.rua         LABEL "Rua"    WIDTH 4
      tt-pick.nivel       LABEL "N¡vel"  WIDTH 4
      tt-pick.coluna      LABEL "Coluna" WIDTH 5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 45 BY 3
          &ELSE SIZE-PIXELS 315 BY 74 &ENDIF
         FONT 4
         TITLE "P i c k i n g" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-etiqueta AT Y 6 X 97 COLON-ALIGNED WIDGET-ID 2
     br-contenedor AT Y 49 X 1 WIDGET-ID 300
     br-pick AT Y 149 X 1 WIDGET-ID 200
     bt-sair AT Y 277 X 126 WIDGET-ID 40
     fi-estab-user AT ROW 1.33 COL 36.72 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     fi-item AT Y 29 X 4 NO-LABEL WIDGET-ID 74
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
         HEIGHT-P           = 300
         WIDTH-P            = 323
         MAX-HEIGHT-P       = 705
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 705
         VIRTUAL-WIDTH-P    = 1366
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
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB br-contenedor fi-etiqueta fpage0 */
/* BROWSE-TAB br-pick br-contenedor fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-item IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contenedor
/* Query rebuild information for BROWSE br-contenedor
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-contenedor.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-contenedor */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pick
/* Query rebuild information for BROWSE br-pick
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pick.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pick */
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
ON ANY-KEY OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:

    APPLY "ANY-KEY" TO fi-etiqueta.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON ANY-KEY OF fi-etiqueta IN FRAME fpage0 /* EAN13/DUN14/Item */
DO:
    /*
    IF LAST-EVENT:LABEL = "e" THEN DO:
        APPLY "CHOOSE" TO bt-embal.
        RETURN NO-APPLY.
    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON RETURN OF fi-etiqueta IN FRAME fpage0 /* EAN13/DUN14/Item */
DO:
    
    DO WITH FRAME fPage0:

        ASSIGN fi-estab-user:SCREEN-VALUE = "Est: " + v_cod_estab_usuar.

        EMPTY TEMP-TABLE tt-pick.
        EMPTY TEMP-TABLE tt-contenedor.
        {&open-query-br-pick}
        {&open-query-br-contenedor}
        ASSIGN Fi-item:SCREEN-VALUE = "".

        FIND FIRST item-mat 
            WHERE item-mat.cod-ean = fi-etiqueta:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF  AVAIL item-mat THEN
            ASSIGN c-item = item-mat.it-codigo.
        ELSE DO:

            FIND FIRST item-dun 
                WHERE item-dun.cod-dun = fi-etiqueta:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF  AVAIL item-dun THEN
                ASSIGN c-item = item-dun.it-codigo.
            ELSE DO:
                FIND FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = fi-etiqueta:SCREEN-VALUE NO-ERROR. 
                IF  NOT AVAIL ITEM THEN
                    RETURN NO-APPLY.
                ELSE
                    ASSIGN c-item = ITEM.it-codigo
                           Fi-item:SCREEN-VALUE = ITEM.it-codigo + " - " + ITEM.desc-item.     .
            END.

        END.

        IF  NOT AVAIL ITEM THEN DO:
            FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = c-item NO-ERROR.
            IF  AVAIL ITEM THEN
                ASSIGN Fi-item:SCREEN-VALUE = ITEM.it-codigo + " - " + ITEM.desc-item.
            ELSE
                RETURN NO-APPLY.
        END.

        /* GERA€ÇO DAS INFORMA€åES DA µREA DE PICKING */
        FOR EACH  wm-estabel 
            WHERE wm-estabel.cod-estabel = v_cod_estab_usuar NO-LOCK:            
            FOR EACH  wm-local
                WHERE wm-local.cod-estabel = wm-estabel.cod-estabel  NO-LOCK:            
                FOR EACH  wm-item-picking
                    WHERE wm-item-picking.cod-estabel = wm-local.cod-estabel 
                      AND wm-item-picking.cod-local   = wm-local.cod-local   
                      AND wm-item-picking.cod-item    = c-item  NO-LOCK:                      
                    FOR EACH  wm-box-picking
                        WHERE wm-box-picking.cod-estabel = wm-item-picking.cod-estabel 
                          AND wm-box-picking.cod-local   = wm-item-picking.cod-local   
                          AND wm-box-picking.cod-picking = wm-item-picking.cod-picking NO-LOCK:
                         
                        FIND FIRST wm-box
                             WHERE wm-box.cod-estabel = wm-box-picking.cod-estabel
                               AND wm-box.cod-local   = wm-box-picking.cod-local
                               AND wm-box.id-box      = wm-box-picking.id-box-comp NO-LOCK NO-ERROR.
                    
                        IF  AVAIL wm-box THEN DO:
                            CREATE tt-pick.
                            ASSIGN tt-pick.bloco  = wm-box.cod-bloco         
                                   tt-pick.rua    = wm-box.cod-rua
                                   tt-pick.nivel  = wm-box.cod-nivel
                                   tt-pick.coluna = wm-box.cod-coluna.
                        END.
                    END.          
                END.          
            END.       
        END.

        /* GERA€ÇO DAS INFORMA€åES DO CONTENEDOR */
        FOR EACH item-caixa NO-LOCK
            WHERE item-caixa.it-codigo = c-item
            ,FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = c-item
            ,FIRST embalag no-lock
                WHERE embalag.sigla-emb = item-caixa.sigla-emb:
            CREATE tt-contenedor.
            ASSIGN tt-contenedor.tipo        = "FT"
                   tt-contenedor.qtde        = item-caixa.qt-item
                   tt-contenedor.altura      = embalag.altura 
                   tt-contenedor.largura     = embalag.largura
                   tt-contenedor.comprimento = embalag.comprim
                   tt-contenedor.peso-bruto  = ITEM.peso-bruto
                   tt-contenedor.peso-liq    = ITEM.peso-liq.
        END.

        FOR EACH wm-item-embalagem-local NO-LOCK
            WHERE wm-item-embalagem-local.cod-estab = v_cod_estab_usuar
              AND wm-item-embalagem-local.cod-item  = c-item:
            CREATE tt-contenedor.          
            ASSIGN tt-contenedor.tipo     = "WM"
                   /* tt-contenedor.sigla    = wm-item-embalagem-local.cod-emb-item */
                   tt-contenedor.qtde     = wm-item-embalagem-local.qtd-emb-item.
        END.
    END.

    {&open-query-br-pick}
    {&open-query-br-contenedor}

    APPLY "ENTRY" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contenedor
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


