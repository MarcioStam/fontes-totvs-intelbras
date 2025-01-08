&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP006C 1.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP006C
&GLOBAL-DEFINE Version        1.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btElimina ~
                              fi-nr-volumes fi-observ-nota fi-vl-embalagem fi-vl-frete fi-vl-seguro ~
                              dt-base i-dias-negoc fi-peso-bruto

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF INPUT PARAM pNrPedido LIKE ped-venda.nr-pedido NO-UNDO.

{utp/ut-glob.i}
DEF TEMP-TABLE volume-ped LIKE volume-nf
    FIELD nr-pedcli LIKE ped-venda.nr-pedcli
    INDEX ch_pr nr-pedcli it-codigo nr-volume.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 fi-nr-pedido fi-peso-bruto ~
fiMoeda fi-vl-frete fi-vl-embalagem fi-vl-seguro dt-base i-dias-negoc ~
fi-observ-nota btOK btCancel btElimina fi-texto-1 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-pedido fi-peso-bruto fiMoeda ~
fi-vl-frete fi-vl-embalagem fi-vl-seguro dt-base i-dias-negoc ~
fi-observ-nota fi-texto-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btElimina 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-observ-nota AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 4.25.

DEFINE VARIABLE dt-base AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Base" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedido AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Nr Pedido" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-nr-volumes AS CHARACTER FORMAT "X(10)" 
     LABEL "N£mero Volumes" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-peso-bruto AS DECIMAL FORMAT ">>,>>>,>>>,>>9.999" INITIAL 0 
     LABEL "Peso Bruto Faturado" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88.

DEFINE VARIABLE fi-texto-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Observa‡Æo" 
      VIEW-AS TEXT 
     SIZE .14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-vl-embalagem AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Embalagem" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88.

DEFINE VARIABLE fi-vl-frete AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Frete" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88.

DEFINE VARIABLE fi-vl-seguro AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Seguro" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88.

DEFINE VARIABLE fiMoeda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-dias-negoc AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Dias Negocia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-nr-pedido AT ROW 1.25 COL 17 COLON-ALIGNED HELP
          "N£mero do pedido"
     fi-nr-volumes AT ROW 2.25 COL 17 COLON-ALIGNED
     fi-peso-bruto AT ROW 2.25 COL 52 COLON-ALIGNED WIDGET-ID 16
     fiMoeda AT ROW 3.25 COL 17 COLON-ALIGNED
     fi-vl-frete AT ROW 4.25 COL 17 COLON-ALIGNED
     fi-vl-embalagem AT ROW 5.25 COL 17 COLON-ALIGNED
     fi-vl-seguro AT ROW 6.25 COL 17 COLON-ALIGNED
     dt-base AT ROW 7.25 COL 17 COLON-ALIGNED WIDGET-ID 8
     i-dias-negoc AT ROW 7.25 COL 52 COLON-ALIGNED WIDGET-ID 10
     fi-observ-nota AT ROW 8.25 COL 19.14 NO-LABEL
     btOK AT ROW 13.21 COL 2
     btCancel AT ROW 13.21 COL 13
     btElimina AT ROW 13.21 COL 68.86
     fi-texto-1 AT ROW 8.33 COL 17 COLON-ALIGNED
     rtToolBar AT ROW 13 COL 1
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.43 BY 13.75
         FONT 1
         DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.75
         WIDTH              = 79.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
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

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-nr-volumes IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-nr-volumes:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       fi-texto-1:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wWindow
ON CHOOSE OF btElimina IN FRAME fpage0 /* Eliminar */
DO:
    FIND ped-venda
        WHERE ped-venda.nr-pedido = pNrPedido NO-LOCK NO-ERROR.
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
         WHERE int-ped-venda.nr-pedido = pNrPedido
           AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    IF  AVAIL int-ped-venda THEN
        DELETE int-ped-venda.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    FIND ped-venda
        WHERE ped-venda.nr-pedido = pNrPedido NO-LOCK NO-ERROR.
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
         WHERE int-ped-venda.nr-pedido = pNrPedido 
           AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    IF NOT AVAIL int-ped-venda THEN
    DO:
        CREATE int-ped-venda.
        ASSIGN int-ped-venda.nr-pedido = INPUT fi-nr-pedido
               int-ped-venda.cod-estabel = ped-venda.cod-estabel.
    END.

    ASSIGN int-ped-venda.nr-volumes              = INPUT fi-nr-volumes  
           int-ped-venda.vl-embalagem            = INPUT fi-vl-embalagem
           int-ped-venda.vl-frete                = INPUT fi-vl-frete    
           int-ped-venda.vl-seguro               = INPUT fi-vl-seguro   
           int-ped-venda.observ-nota             = INPUT fi-observ-nota
           int-ped-venda.dt-negociacao           = INPUT dt-base
           int-ped-venda.dias-negociacao         = INPUT i-dias-negoc
           overlay(int-ped-venda.char-1,220,20)  = INPUT fi-peso-bruto.
    RELEASE int-ped-venda.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DISP fi-nr-pedido 
     fiMoeda
     WITH FRAME fPage0.

FIND emitente NO-LOCK
    WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

IF ped-venda.tp-pedido = "99" OR
  (substr(ped-venda.nat-operacao,1,1) = "7" AND AVAIL emitente AND emitente.natureza > 2) OR
   ped-venda.tp-pedido = "92" OR
   ped-venda.tp-pedido = "94" OR
   c-seg-usuario = "AD846512" OR
   c-seg-usuario = "DE846264" OR 
   c-seg-usuario = "an046325" OR 
   c-seg-usuario = "an647553" OR
   c-seg-usuario = "ve647503" or
   c-seg-usuario = "el041780" OR 
   c-seg-usuario = "ka846263" OR 
   c-seg-usuario = "th046535" OR
   c-seg-usuario = "pa046755" OR
   c-seg-usuario = "iv846812" or
   c-seg-usuario = "ge844330" or
   c-seg-usuario = "pa041850" OR
   c-seg-usuario = "ka033330" OR
   c-seg-usuario = "ma005339" OR
   c-seg-usuario = "MA046601" OR
   c-seg-usuario = "th046760"
    THEN DO:
    ASSIGN fi-nr-volumes:SENSITIVE = YES.
END.
ELSE DO:
    ASSIGN fi-nr-volumes:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wWindow 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN fi-nr-pedido = pNrPedido.
FOR FIRST ped-venda  NO-LOCK
    WHERE ped-venda.nr-pedido = pNrPedido,
    FIRST moeda NO-LOCK
    WHERE moeda.mo-codigo = ped-venda.mo-codigo:

    FOR FIRST int-ped-venda NO-LOCK
        WHERE int-ped-venda.nr-pedido = pNrPedido
          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel:
        ASSIGN fi-nr-volumes   = int-ped-venda.nr-volumes   
               fi-vl-embalagem = int-ped-venda.vl-embalagem
               fi-vl-frete     = int-ped-venda.vl-frete    
               fi-vl-seguro    = int-ped-venda.vl-seguro   
               fi-observ-nota  = int-ped-venda.observ-nota
               dt-base         = int-ped-venda.dt-negociacao
               i-dias-negoc    = int-ped-venda.dias-negociacao
               fi-peso-bruto   = dec(substring(int-ped-venda.char-1,220,20)).
    END.

    ASSIGN fiMoeda = moeda.descricao.
END.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

