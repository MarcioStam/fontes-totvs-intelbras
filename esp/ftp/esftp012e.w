&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-wt-docto NO-UNDO LIKE wt-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE ttPed-fiscal NO-UNDO LIKE ped-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP012E 2.00.00.000}  /*** 010000 ***/

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESFTP012E
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Itens

&GLOBAL-DEFINE ttTable           ttPed-fiscal
&GLOBAL-DEFINE hDBOTable         hDBOPed-fiscal
&GLOBAL-DEFINE DBOTable          ped-fiscal

&GLOBAL-DEFINE ttParent          
&GLOBAL-DEFINE DBOParentTable    

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       c-nome-abrev
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
/* def var h-bodi317pr          as handle       no-undo. */
/* def var h-bodi317sd          as handle       no-undo. */
/* def var h-bodi317im1bra      as handle       no-undo. */
/* def var h-bodi317va          as handle       no-undo. */
/* def var h-bodi317in          as handle       no-undo. */
def var c-ultimo-metodo-exec as char         no-undo.
def var l-proc-ok-aux        as log          no-undo.
DEF VAR l-fifo               AS LOG INIT NO  NO-UNDO.
/* Definiá∆o da tabela tempor†ria para itens de devoluá∆o */
/*{dibo/bodi317sd.i1}*/
/***********************************************************************************
**
** BODI317SD.I1 - Definiá∆o da tabela tempor†ria para itens de devoluá∆o.
**
************************************************************************************/

def temp-table tt-itens-devol no-undo
    field serie-docto       like item-doc-est.serie-docto 
    field cod-emitente      like item-doc-est.cod-emitente
    field nro-docto         like item-doc-est.nro-docto   
    field nat-operacao      like item-doc-est.nat-operacao
    field sequencia         like item-doc-est.sequencia
    field it-codigo         like item-doc-est.it-codigo
    field cod-refer         like item-doc-est.cod-refer
    field desc-nar          like item.desc-item
    field quantidade        like item-doc-est.quantidade
    field preco-total       like item-doc-est.preco-total[1]
    field qt-ja-devolvida   like item-doc-est.quantidade
    field qt-a-devolver     like item-doc-est.quantidade
    field qt-a-devolver-inf like item-doc-est.quantidade
    FIELD cod-depos         AS CHAR FORMAT "X(03)" COLUMN-LABEL "Depos."
    FIELD cod-localiz       LIKE saldo-estoq.cod-localiz
    field selecionado       as log
    index codigo 
          serie-docto
          nro-docto    
          cod-emitente 
          nat-operacao 
          sequencia
    index selecionado
          selecionado.

DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
        FIELD mensagem AS CHARACTER FORMAT "x(250)".

def temp-table tt-it-terc-nf no-undo
    field rw-saldo-terc     as rowid
    field sequencia         like saldo-terc.sequencia
    field it-codigo         like saldo-terc.it-codigo
    field cod-refer         like saldo-terc.cod-refer
    field desc-nar          like item.desc-item
    field quantidade        like saldo-terc.quantidade
    field qt-alocada        like saldo-terc.quantidade
    field qt-disponivel     like saldo-terc.quantidade
    field qt-disponivel-inf like saldo-terc.quantidade
    field preco-total       like componente.preco-total[1]
    field preco-total-inf   like componente.preco-total[1]
    field selecionado       as log
    index codigo 
          sequencia
    index selecionado
          selecionado.

/*  BODI317SD.I1  */

/*{dibo/bodi515.i tt-nota-fisc-adc}*/
DEFINE TEMP-TABLE tt-nota-fisc-adc NO-UNDO LIKE nota-fisc-adc
    FIELD r-Rowid AS ROWID.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.
DEFINE NEW GLOBAL SHARED VARIABLE i-filtro       AS INTEGER INITIAL 1 NO-UNDO.

DEFINE BUFFER bf-it-ped-fiscal FOR it-ped-fiscal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-itens-devol

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens-devol

/* Definitions for BROWSE br-tt-itens-devol                             */
&Scoped-define FIELDS-IN-QUERY-br-tt-itens-devol tt-itens-devol.sequencia tt-itens-devol.it-codigo tt-itens-devol.cod-depos tt-itens-devol.cod-localiz tt-itens-devol.quantidade tt-itens-devol.preco-total tt-itens-devol.qt-ja-devolvida tt-itens-devol.qt-a-devolver-inf tt-itens-devol.desc-nar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-itens-devol tt-itens-devol.cod-depos   tt-itens-devol.cod-localiz   tt-itens-devol.qt-a-devolver-inf   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-tt-itens-devol tt-itens-devol
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-tt-itens-devol tt-itens-devol
&Scoped-define SELF-NAME br-tt-itens-devol
&Scoped-define QUERY-STRING-br-tt-itens-devol FOR EACH tt-itens-devol
&Scoped-define OPEN-QUERY-br-tt-itens-devol OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-devol.
&Scoped-define TABLES-IN-QUERY-br-tt-itens-devol tt-itens-devol
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-itens-devol tt-itens-devol


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-tt-itens-devol}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-nome-abrev c-serie-comp c-nro-comp ~
c-nat-comp btSelecionaNota btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fi-estab c-nome-abrev c-serie-comp ~
c-nro-comp c-nat-comp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSelecionaNota AUTO-GO 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Seleciona Nota" 
     SIZE 5 BY 1 TOOLTIP "Mostra os itens da nota selecionada."
     FONT 4.

DEFINE VARIABLE c-nat-comp AS CHARACTER FORMAT "x(06)" 
     LABEL "Natureza Nota Devoluá∆o":R25 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "x(8)" 
     LABEL "Cliente/Fornec" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE c-nro-comp AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr Nota Devoluá∆o":R14 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-serie-comp AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btDesmarca 
     LABEL "&Desmarca" 
     SIZE 15 BY 1.

DEFINE BUTTON btDesmarcaTodos 
     LABEL "Desma&rca Todos" 
     SIZE 15 BY 1.

DEFINE BUTTON btMarca 
     LABEL "&Marca" 
     SIZE 15 BY 1.

DEFINE BUTTON btMarcaTodos 
     LABEL "Marca &Todos" 
     SIZE 15 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tt-itens-devol FOR 
      tt-itens-devol SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-itens-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-itens-devol wMaintenanceNoNavigation _FREEFORM
  QUERY br-tt-itens-devol NO-LOCK DISPLAY
      tt-itens-devol.sequencia    
    tt-itens-devol.it-codigo    
    tt-itens-devol.cod-depos        FORMAT "X(03)" COLUMN-LABEL "Depos"
    tt-itens-devol.cod-localiz       FORMAT "X(12)"              COLUMN-LABEL "Local."
    tt-itens-devol.quantidade        column-label "Quantidade"
    tt-itens-devol.preco-total       
    tt-itens-devol.qt-ja-devolvida   column-label "Qt j† Devolvida"
    tt-itens-devol.qt-a-devolver-inf column-label "Qt Ö Devolver"
    tt-itens-devol.desc-nar          column-label "Descriá∆o/Narrativa"
  ENABLE
    tt-itens-devol.cod-depos
    tt-itens-devol.cod-localiz
    tt-itens-devol.qt-a-devolver-inf
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84.72 BY 9.17
         FONT 2 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-estab AT ROW 3.29 COL 20 COLON-ALIGNED WIDGET-ID 2
     c-nome-abrev AT ROW 1.25 COL 20 COLON-ALIGNED
     c-serie-comp AT ROW 2.25 COL 20 COLON-ALIGNED
     c-nro-comp AT ROW 1.25 COL 58 COLON-ALIGNED
     c-nat-comp AT ROW 2.25 COL 58 COLON-ALIGNED HELP
          "Natureza do documento de origem"
     btSelecionaNota AT ROW 2.21 COL 70.29 HELP
          "Confirma alteraá‰es"
     btOK AT ROW 16.75 COL 2
     btSave AT ROW 16.75 COL 13
     btCancel AT ROW 16.75 COL 24
     btHelp AT ROW 16.75 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     br-tt-itens-devol AT ROW 1.63 COL 1.14
     btMarca AT ROW 10.83 COL 1.29
     btDesmarca AT ROW 10.83 COL 16.29
     btMarcaTodos AT ROW 10.83 COL 31.29
     btDesmarcaTodos AT ROW 10.83 COL 46.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 85.14 BY 10.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-wt-docto T "?" NO-UNDO mgdis wt-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: ttPed-fiscal T "?" NO-UNDO mgesp ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 38.17
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.17
         VIRTUAL-WIDTH      = 182.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN fi-estab IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-estab:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-tt-itens-devol 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-itens-devol
/* Query rebuild information for BROWSE br-tt-itens-devol
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-devol.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-tt-itens-devol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tt-itens-devol
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-tt-itens-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-itens-devol wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF br-tt-itens-devol IN FRAME fPage1
DO:
    if  avail tt-itens-devol then
        if  not tt-itens-devol.selecionado then 
            apply "CHOOSE":U to btMarca in frame fPage1.
        else 
            apply "CHOOSE":U to btDesmarca in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-itens-devol wMaintenanceNoNavigation
ON ROW-DISPLAY OF br-tt-itens-devol IN FRAME fPage1
DO:
    if  avail tt-itens-devol then
        if  tt-itens-devol.selecionado then 
            assign tt-itens-devol.sequencia:fgcolor         in browse br-tt-itens-devol = 9    
                   tt-itens-devol.it-codigo:fgcolor         in browse br-tt-itens-devol = 9
                   tt-itens-devol.quantidade:fgcolor        in browse br-tt-itens-devol = 9 
                   tt-itens-devol.preco-total:fgcolor       in browse br-tt-itens-devol = 9
                   tt-itens-devol.qt-ja-devolvida:fgcolor   in browse br-tt-itens-devol = 9
                   tt-itens-devol.qt-a-devolver-inf:fgcolor in browse br-tt-itens-devol = 9
                   tt-itens-devol.desc-nar:fgcolor          in browse br-tt-itens-devol = 9
                   tt-itens-devol.cod-depos:fgcolor         in browse br-tt-itens-devol = 9
                   tt-itens-devol.cod-localiz:fgcolor       in browse br-tt-itens-devol = 9
                   tt-itens-devol.sequencia:font            in browse br-tt-itens-devol = 6    
                   tt-itens-devol.it-codigo:font            in browse br-tt-itens-devol = 6
                   tt-itens-devol.quantidade:font           in browse br-tt-itens-devol = 6 
                   tt-itens-devol.preco-total:font          in browse br-tt-itens-devol = 6
                   tt-itens-devol.qt-ja-devolvida:font      in browse br-tt-itens-devol = 6
                   tt-itens-devol.qt-a-devolver-inf:font    in browse br-tt-itens-devol = 6
                   tt-itens-devol.desc-nar:font             in browse br-tt-itens-devol = 6
                   tt-itens-devol.cod-depos:font            in browse br-tt-itens-devol = 6
                   tt-itens-devol.cod-localiz:font          in browse br-tt-itens-devol = 6.
        else
            assign tt-itens-devol.sequencia:fgcolor         in browse br-tt-itens-devol = 0    
                   tt-itens-devol.it-codigo:fgcolor         in browse br-tt-itens-devol = 0
                   tt-itens-devol.quantidade:fgcolor        in browse br-tt-itens-devol = 0 
                   tt-itens-devol.preco-total:fgcolor       in browse br-tt-itens-devol = 0
                   tt-itens-devol.qt-ja-devolvida:fgcolor   in browse br-tt-itens-devol = 0
                   tt-itens-devol.qt-a-devolver-inf:fgcolor in browse br-tt-itens-devol = 0
                   tt-itens-devol.desc-nar:fgcolor          in browse br-tt-itens-devol = 0
                   tt-itens-devol.cod-depos:fgcolor         in browse br-tt-itens-devol = 0
                   tt-itens-devol.cod-localiz:fgcolor       in browse br-tt-itens-devol = 0
                   tt-itens-devol.sequencia:font            in browse br-tt-itens-devol = 2    
                   tt-itens-devol.it-codigo:font            in browse br-tt-itens-devol = 2
                   tt-itens-devol.quantidade:font           in browse br-tt-itens-devol = 2 
                   tt-itens-devol.preco-total:font          in browse br-tt-itens-devol = 2
                   tt-itens-devol.qt-ja-devolvida:font      in browse br-tt-itens-devol = 2
                   tt-itens-devol.qt-a-devolver-inf:font    in browse br-tt-itens-devol = 2
                   tt-itens-devol.desc-nar:font             in browse br-tt-itens-devol = 2
                   tt-itens-devol.cod-depos:font            in browse br-tt-itens-devol = 2
                   tt-itens-devol.cod-localiz:font          in browse br-tt-itens-devol = 2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    IF l-fifo THEN DO:
        RUN ftp/ft4003d.w (INPUT ttPed-fiscal.cod-emitente,
                           INPUT c-serie-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT c-nro-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT c-nat-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT 0).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDesmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarca wMaintenanceNoNavigation
ON CHOOSE OF btDesmarca IN FRAME fPage1 /* Desmarca */
DO:
    if  avail tt-itens-devol then do:
        assign tt-itens-devol.selecionado = no.
        apply "ROW-DISPLAY":U to br-tt-itens-devol in frame fPage1.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcaTodos wMaintenanceNoNavigation
ON CHOOSE OF btDesmarcaTodos IN FRAME fPage1 /* Desmarca Todos */
DO:
    for each tt-itens-devol exclusive:
        assign tt-itens-devol.selecionado = no.
        br-tt-itens-devol:REFRESH() in frame fPage1.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarca wMaintenanceNoNavigation
ON CHOOSE OF btMarca IN FRAME fPage1 /* Marca */
DO:
    if  avail tt-itens-devol then do:
        assign tt-itens-devol.selecionado = yes.
        apply "ROW-DISPLAY":U to br-tt-itens-devol in frame fPage1.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcaTodos wMaintenanceNoNavigation
ON CHOOSE OF btMarcaTodos IN FRAME fPage1 /* Marca Todos */
DO:
    for each tt-itens-devol exclusive:
        assign tt-itens-devol.selecionado = yes.
        br-tt-itens-devol:REFRESH() in frame fPage1.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN l-fifo = NO.
    RUN saveRecordCustom.
    IF  RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.

    IF l-fifo THEN DO:
        RUN ftp/ft4003d.w (INPUT ttPed-fiscal.cod-emitente,
                           INPUT c-serie-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT c-nro-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT c-nat-comp:SCREEN-VALUE IN FRAME fpage0,
                           INPUT 0 ).
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecordCustom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecionaNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecionaNota wMaintenanceNoNavigation
ON CHOOSE OF btSelecionaNota IN FRAME fpage0 /* Seleciona Nota */
DO:
    EMPTY TEMP-TABLE RowErrors.
    RUN geraItensDevolucaoTtItensDevol (INPUT  ttPed-fiscal.seq-wt-docto, 
                                        INPUT  ttPed-fiscal.cod-estabel,
                                        INPUT  INPUT FRAME fPage0 c-serie-comp,
                                        INPUT  INPUT FRAME fPage0 c-nro-comp,
                                        INPUT  INPUT FRAME fPage0 c-nat-comp,
                                        OUTPUT TABLE tt-itens-devol,
                                        OUTPUT l-proc-ok-aux).

    FOR EACH tt-itens-devol
        WHERE tt-itens-devol.qt-a-devolver-inf = 0:

        DELETE tt-itens-devol.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF  AVAIL RowErrors THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-comp wMaintenanceNoNavigation
ON F5 OF c-nat-comp IN FRAME fpage0 /* Natureza Nota Devoluá∆o */
DO:
  
  {method/zoomfields.i &ProgramZoom="inzoom/z14in090.w"
                         &FieldZoom1="serie-docto"
                         &FieldScreen1="c-serie-comp"
                         &Frame1="fPage0"
                         &FieldZoom2="nat-operacao"
                         &FieldScreen2="c-nat-comp"
                         &Frame2="fPage0"
                         &FieldZoom3="nro-docto"
                         &FieldScreen3="c-nro-comp"
                         &Frame3="fPage0"                                                  
                         &RunMethod="run setParameters in hProgramZoom( ttPed-fiscal.cod-emitente )."  
                         &EnableImplant="NO"}
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-nat-comp IN FRAME fpage0 /* Natureza Nota Devoluá∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nro-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-comp wMaintenanceNoNavigation
ON F5 OF c-nro-comp IN FRAME fpage0 /* Nr Nota Devoluá∆o */
DO:

   {method/zoomfields.i &ProgramZoom="inzoom/z14in090.w"
                         &FieldZoom1="serie-docto"
                         &FieldScreen1="c-serie-comp"
                         &Frame1="fPage0"
                         &FieldZoom2="nat-operacao"
                         &FieldScreen2="c-nat-comp"
                         &Frame2="fPage0"
                         &FieldZoom3="nro-docto"
                         &FieldScreen3="c-nro-comp"
                         &Frame3="fPage0"                                                  
                         &RunMethod="run setParameters in hProgramZoom( ttPed-fiscal.cod-emitente )."  
                         &EnableImplant="NO"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-nro-comp IN FRAME fpage0 /* Nr Nota Devoluá∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-comp wMaintenanceNoNavigation
ON F5 OF c-serie-comp IN FRAME fpage0 /* SÇrie */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z14in090.w"
                         &FieldZoom1="serie-docto"
                         &FieldScreen1="c-serie-comp"
                         &Frame1="fPage0"
                         &FieldZoom2="nat-operacao"
                         &FieldScreen2="c-nat-comp"
                         &Frame2="fPage0"
                         &FieldZoom3="nro-docto"
                         &FieldScreen3="c-nro-comp"
                         &Frame3="fPage0"                                                  
                         &RunMethod="run setParameters in hProgramZoom( ttPed-fiscal.cod-emitente )."  
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-serie-comp IN FRAME fpage0 /* SÇrie */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

if  c-serie-comp:load-mouse-pointer("image/lupa.cur":U) in frame fPage0 =
    c-nro-comp:load-mouse-pointer("image/lupa.cur")     in frame fPage0 
and c-nat-comp:load-mouse-pointer("image/lupa.cur":U)   in frame fPage0 then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {method/showmessage.i3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DISP ttPed-fiscal.serie @ c-serie-comp WITH FRAME fPage0.

    FIND FIRST emitente
        WHERE  emitente.cod-emitente = ttPed-fiscal.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN
        DISP emitente.nome-abrev @ c-nome-abrev WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DISABLE c-nome-abrev
        WITH FRAME fPage0.

    ENABLE c-serie-comp
           c-nat-comp
           c-nro-comp
           btSelecionaNota
           btSave
        WITH FRAME fPage0.

    ENABLE br-tt-itens-devol
           btMarca 
           btDesmarca 
           btMarcaTodos
           btDesmarcaTodos
        WITH FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     IF NOT VALID-HANDLE(h-bodi317in) THEN DO:                    */
/*         RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.         */
/*         RUN inicializaBOS IN h-bodi317in(OUTPUT h-bodi317pr,     */
/*                                          OUTPUT h-bodi317sd,     */
/*                                          OUTPUT h-bodi317im1bra, */
/*                                          OUTPUT h-bodi317va).    */
/*     END.                                                         */

    ASSIGN br-tt-itens-devol:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 3.

    IF AVAIL ttped-fiscal THEN
       ASSIGN fi-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ttped-fiscal.cod-estabel.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraItensDevolucaoTtItensDevol wMaintenanceNoNavigation 
PROCEDURE geraItensDevolucaoTtItensDevol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-i-seq-wt-docto    LIKE wt-it-docto.seq-wt-docto NO-UNDO.
    DEF INPUT  PARAM p-estab-solic       LIKE ped-fiscal.cod-estabel   NO-UNDO.
    DEF INPUT  PARAM p-c-serie-devol     LIKE docum-est.serie-docto    NO-UNDO.
    DEF INPUT  PARAM p-c-nr-nota-devol   LIKE docum-est.nro-docto      NO-UNDO.
    DEF INPUT  PARAM p-c-nat-oper-devol  LIKE docum-est.nat-operacao   NO-UNDO.
    DEF OUTPUT PARAM TABLE               FOR tt-itens-devol.
    DEF OUTPUT PARAM p-l-procedimento-ok AS   LOG                      NO-UNDO.

    ASSIGN c-ultimo-metodo-exec = REPLACE(PROGRAM-NAME(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    DEF VAR l-proc-ok-aux AS LOG    NO-UNDO.
    DEF VAR h-boin672     AS HANDLE NO-UNDO.

    FOR EACH tt-itens-devol EXCLUSIVE:
        DELETE tt-itens-devol.
    END.

    /* validaGeraItensDevolucaoTtItensDevol */
    FOR FIRST docum-est /*FIELDS (cod-estabel ce-atual)*/
        WHERE docum-est.cod-estabel  = p-estab-solic
          AND docum-est.serie-docto  = p-c-serie-devol
          AND docum-est.nro-docto    = p-c-nr-nota-devol
          AND docum-est.cod-emitente = ttPed-fiscal.cod-emitente
          AND docum-est.nat-operacao = p-c-nat-oper-devol NO-LOCK:
    END.

    IF NOT AVAIL docum-est THEN DO:
        {utp/ut-table.i mgind docum-est 1}
        /* MENSAGEM: 2 - N∆o encontrado(a) &1 para chave informada */
        RUN insertError (INPUT 2,
                         INPUT RETURN-VALUE).
        RETURN.
    END.
    ELSE IF NOT docum-est.ce-atual THEN DO:
        /* MENSAGEM: 25709 - O Documento informado n∆o est† atualizado */
        RUN insertError (INPUT 25709,
                         INPUT "").        
        RETURN.
    END.

    /*
    IF docum-est.cod-estabel <> ttPed-fiscal.cod-estabel THEN DO:
        /* MENSAGEM: 27858 - Estabelecimento difere */
        RUN insertError (INPUT 27858,
                         INPUT "da nota de entrada difere do estabelecimento da devoluá∆o.").        
        RETURN.
    END.
    */

    RUN inbo/boin672.p PERSISTENT SET h-boin672.

    FOR EACH item-doc-est OF docum-est
      /* WHERE item-doc-est.serie-docto  = p-c-serie-devol
         AND item-doc-est.nro-docto    = p-c-nr-nota-devol 
         AND item-doc-est.cod-emitente = ttPed-fiscal.cod-emitente 
         AND item-doc-est.nat-operacao = p-c-nat-oper-devol */ NO-LOCK:

        FIND FIRST ITEM
             WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL ITEM THEN NEXT.

        CREATE tt-itens-devol.
        ASSIGN tt-itens-devol.serie-docto  = item-doc-est.serie-docto 
               tt-itens-devol.cod-emitente = item-doc-est.cod-emitente
               tt-itens-devol.nro-docto    = item-doc-est.nro-docto   
               tt-itens-devol.nat-operacao = item-doc-est.nat-operacao
               tt-itens-devol.sequencia    = item-doc-est.sequencia
               tt-itens-devol.it-codigo    = item-doc-est.it-codigo
               tt-itens-devol.cod-refer    = item-doc-est.cod-refer
               tt-itens-devol.cod-depos    = item-doc-est.cod-depos
               tt-itens-devol.cod-localiz  = item-doc-est.cod-localiz 
               tt-itens-devol.desc-nar     = IF ITEM.tipo-contr = 4 /* Debito Direto */
                                             THEN SUBSTR(ITEM.narrativa,1,60)
                                             ELSE ITEM.desc-item
               tt-itens-devol.quantidade   = item-doc-est.quantidade
               tt-itens-devol.preco-total  = item-doc-est.preco-total[1]
               tt-itens-devol.selecionado  = NO.

        RUN calculaQuantDevolvida IN h-boin672(INPUT  item-doc-est.serie-docto,
                                               INPUT  item-doc-est.nro-docto,
                                               INPUT  item-doc-est.cod-emitente,
                                               INPUT  item-doc-est.nat-operacao,
                                               INPUT  item-doc-est.sequencia,
                                               OUTPUT tt-itens-devol.qt-ja-devolvida).

        RUN calculaSaldoDevolver IN h-boin672(INPUT  item-doc-est.serie-docto,
                                              INPUT  item-doc-est.nro-docto,
                                              INPUT  item-doc-est.cod-emitente,
                                              INPUT  item-doc-est.nat-operacao,
                                              INPUT  item-doc-est.sequencia,
                                              OUTPUT tt-itens-devol.qt-a-devolver).

        ASSIGN tt-itens-devol.qt-a-devolver-inf = tt-itens-devol.qt-a-devolver.

       FOR EACH it-nota-fisc
           WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
             AND it-nota-fisc.nr-docum    = docum-est.nro-docto
             AND it-nota-fisc.serie-docum = docum-est.serie-docto
             AND it-nota-fisc.int-1       = item-doc-est.sequencia
             AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo NO-LOCK,
    
           EACH componente
           WHERE componente.serie-docto  = it-nota-fisc.serie
             AND componente.nro-docto    = it-nota-fisc.nr-nota-fis
             AND componente.it-codigo    = it-nota-fisc.it-codigo
             AND componente.sequencia    = it-nota-fisc.nr-seq-fat
             AND componente.componente   = 2 NO-LOCK:

             ASSIGN tt-itens-devol.qt-ja-devolvida = tt-itens-devol.qt-ja-devolvida + componente.quantidade.

        END.
        
        ASSIGN tt-itens-devol.qt-a-devolver-inf = tt-itens-devol.qt-a-devolver-inf - tt-itens-devol.qt-ja-devolvida.

    END.

    IF VALID-HANDLE(h-boin672) THEN DO:
        DELETE PROCEDURE h-boin672.
        ASSIGN h-boin672 = ?.
    END.

    ASSIGN p-l-procedimento-ok = YES. /* Indica que o processo ocorreu por completo */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraWtItDoctoPartindoDoTtItensDevol wMaintenanceNoNavigation 
PROCEDURE geraWtItDoctoPartindoDoTtItensDevol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-i-seq-wt-docto    LIKE wt-it-docto.seq-wt-docto NO-UNDO.
    DEF INPUT  PARAM TABLE               FOR  tt-itens-devol.
    DEF OUTPUT PARAM p-l-procedimento-ok AS LOG                        NO-UNDO.

    ASSIGN c-ultimo-metodo-exec = REPLACE(PROGRAM-NAME(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    DEF VAR l-proc-ok-aux     AS LOG                           NO-UNDO.
    DEF VAR de-qtd-saldo      AS DEC                           NO-UNDO.
    DEF VAR de-qtd-aux        AS DEC                           NO-UNDO.
    DEF VAR c-cod-depos       AS CHAR                          NO-UNDO. 
    DEF VAR i-seq-wt-it-docto LIKE wt-it-docto.seq-wt-it-docto NO-UNDO.

    /* validaGeraWtItDoctoPartindoDoTtItensDevol in h-bodi317va */
    FOR EACH tt-itens-devol
        WHERE tt-itens-devol.selecionado = YES NO-LOCK:

        FOR FIRST it-ped-fiscal 
            WHERE it-ped-fiscal.nr-pedido                   = ttPed-fiscal.nr-pedido
              AND INT(SUBSTRING(it-ped-fiscal.char-1,55,5)) = tt-itens-devol.sequencia 
              AND it-ped-fiscal.it-codigo                   = tt-itens-devol.it-codigo NO-LOCK:

            /* MENSAGEM: 15678 - "A sequància &1 j† est† selecionada para esta Nota" */
            RUN insertError (INPUT 15678,
                             INPUT STRING(tt-itens-devol.sequencia)).
            RETURN.
        END.

        /* Se a quantidade informada para devoluá∆o for maior que a quantidade m†xima a ser devolvida */
        IF  tt-itens-devol.qt-a-devolver-inf > tt-itens-devol.qt-a-devolver THEN DO:
            /* MENSAGEM: 5705 - "Quantidade devolvida maior que quantidade recebida" */
            RUN insertError (INPUT 5705,
                             INPUT "Sequància: ":U + STRING(tt-itens-devol.sequencia)).
            RETURN.
        END.
    END.
    /**/

    /** Gravado chave da tabela 'item-doc-est' no campo 'it-ped-fiscal.char-1' para ser utilizado no programa
        FT4003 na busca dos itens do pedido de faturamento, com essas informaá‰es ser† feita    
        a l¢gica existe no bot∆o "Ger It" - FT4003.

        --- chave da tabela 'item-doc-est' ---
        Serie-docto  = substring(it-ped-fiscal.char-1,19,5) 
        Nro-docto    = substring(it-ped-fiscal.char-1,24,16)
        Cod-emitente = substring(it-ped-fiscal.char-1,40,9) 
        Nat-operacao = substring(it-ped-fiscal.char-1,49,6) 
        Sequencia    = substring(it-ped-fiscal.char-1,55,5) 
    **/
    FOR EACH tt-itens-devol
        WHERE tt-itens-devol.selecionado = YES NO-LOCK,
        FIRST item-doc-est
        FIELDS (item-doc-est.aliquota-icm   item-doc-est.aliquota-ipi
                item-doc-est.baixa-ce       item-doc-est.class-fiscal
                item-doc-est.cod-depos      item-doc-est.cod-emitente 
                item-doc-est.cod-localiz    item-doc-est.conta-contabil
                item-doc-est.desconto[1]    item-doc-est.despesas[1]
                item-doc-est.it-codigo      item-doc-est.lote
                item-doc-est.narrativa      item-doc-est.nat-operacao
                item-doc-est.nro-docto      item-doc-est.nr-ord-prod
                item-doc-est.numero-ordem   item-doc-est.num-pedido
                item-doc-est.parcela        item-doc-est.preco-total[1]
                item-doc-est.quantidade     item-doc-est.sequencia
                item-doc-est.serie-docto    item-doc-est.un
                item-doc-est.char-2         item-doc-est.cod-refer peso-liquido)
        WHERE item-doc-est.serie-docto  = tt-itens-devol.serie-docto
        AND   item-doc-est.nro-docto    = tt-itens-devol.nro-docto
        AND   item-doc-est.cod-emitente = tt-itens-devol.cod-emitente 
        AND   item-doc-est.nat-operacao = tt-itens-devol.nat-operacao 
        AND   item-doc-est.sequencia    = tt-itens-devol.sequencia NO-LOCK:

        FIND LAST  bf-it-ped-fiscal WHERE
                   bf-it-ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-LOCK NO-ERROR.

        CREATE it-ped-fiscal.
        ASSIGN it-ped-fiscal.aliquota-ipi     = item-doc-est.aliquota-ipi               
               it-ped-fiscal.cod-depos        = tt-itens-devol.cod-depos
               it-ped-fiscal.cod-localizacao  = tt-itens-devol.cod-localiz
             /*it-ped-fiscal.data-1           =
               it-ped-fiscal.dec-1            =
               it-ped-fiscal.int-1            =*/
               it-ped-fiscal.it-codigo        = item-doc-est.it-codigo
             /*it-ped-fiscal.log-1            =
               it-ped-fiscal.narrativa        = */
               it-ped-fiscal.nr-ord-prod      = item-doc-est.nr-ord-produ
               it-ped-fiscal.nr-pedido        = ttPed-fiscal.nr-pedido
               it-ped-fiscal.peso-bru-item    = item-doc-est.peso-liquido
               it-ped-fiscal.peso-liq-item    = item-doc-est.peso-liquido
               it-ped-fiscal.qtde             = tt-itens-devol.qt-a-devolver-inf
               it-ped-fiscal.seq              = IF AVAIL bf-it-ped-fiscal THEN bf-it-ped-fiscal.seq + 1 ELSE 1
               it-ped-fiscal.un               = item-doc-est.un
               it-ped-fiscal.vl-unit          = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) /
                                                (IF item-doc-est.quantidade > 0 
                                                 THEN item-doc-est.quantidade
                                                 ELSE 1)
               it-ped-fiscal.nf-referenciada  = tt-itens-devol.nro-docto.

        /** --- chave da tabela 'item-doc-est' ---
        Sera utilizado no programa FT4003, botao "Buscar Itens do Pedido de Faturamento" **/
        ASSIGN OVERLAY(it-ped-fiscal.char-1,19,5)  = item-doc-est.serie-docto 
               OVERLAY(it-ped-fiscal.char-1,24,16) = item-doc-est.nro-docto
               OVERLAY(it-ped-fiscal.char-1,40,9)  = STRING(item-doc-est.cod-emitente,">>>>>>>>9")
               OVERLAY(it-ped-fiscal.char-1,49,6)  = item-doc-est.nat-operacao
               OVERLAY(it-ped-fiscal.char-1,55,5)  = STRING(item-doc-est.sequencia,">>>>9").

        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.

        IF ITEM.tipo-contr <> 4 and
           item.baixa-estoq = YES THEN DO:

            /*Comentado esta validacao in-grup-estoq devido ao chamado C2112-0563*/
/*            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
               
            /*Alocaá∆o por lote*/
            IF  /*(NOT AVAIL in-grup-estoq OR NOT in-grup-estoq.log-ckd)
            AND */ item.tipo-con-est = 3 THEN DO:*/

            /*Alocaá∆o por lote*/
            IF item.tipo-con-est = 3 THEN DO:

                RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                         INPUT it-ped-fiscal.nr-pedido,      /*p-nr-pedido  */
                                         INPUT it-ped-fiscal.it-codigo,      /*p-it-codigo  */
                                         INPUT it-ped-fiscal.seq,            /*p-seq        */
                                         INPUT ttPed-fiscal.cod-estabel,     /*p-cod-estabel*/
                                         INPUT it-ped-fiscal.cod-localizacao,/*p-cod-localiz*/
                                         INPUT it-ped-fiscal.cod-depos,      /*p-cod-depos  */
                                         INPUT it-ped-fiscal.qtde,           /*p-qtde-alocar*/
                                         OUTPUT TABLE tt-erro-aloc).         
                FOR FIRST tt-erro-aloc:
                    RUN insertError (INPUT 17006,
                                     INPUT tt-erro-aloc.mensagem).
                    UNDO, RETURN.
                END.
            END.
            /*Alocaá∆o sem lote*/
            ELSE DO:

                find first saldo-estoq
                   where saldo-estoq.it-codigo      = it-ped-fiscal.it-codigo
                        and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                        and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                        and saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao
                        no-lock no-error.
                IF NOT AVAIL saldo-estoq THEN DO:
                    RUN insertError (INPUT 17006,
                        INPUT "Saldo DO Estoque n∆o encontrado para deposito " + it-ped-fiscal.it-codigo).
                   UNDO, RETURN.
        
                END.
            
                IF saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped < it-ped-fiscal.qtde THEN DO:
                    RUN insertError (INPUT 17006,
                                     INPUT "Saldo DO Estoque insuficiente NO deposito " + it-ped-fiscal.it-codigo).
                    UNDO, RETURN.
    
                END.
                else do:
                    find current saldo-estoq exclusive-lock no-error.                
                    assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + it-ped-fiscal.qtde.
                    release saldo-estoq.
                end.
            END.
        END.
    END.

    ASSIGN p-l-procedimento-ok = YES. /* Indica que o processo ocorreu por completo */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertError wMaintenanceNoNavigation 
PROCEDURE insertError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-errorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-errorParameters AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-msg  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-help AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-seq  AS INTEGER   NO-UNDO.

    RUN utp/ut-msgs.p (INPUT "msg", INPUT p-errorNumber, INPUT p-errorParameters).
    ASSIGN c-msg = RETURN-VALUE.
    RUN utp/ut-msgs.p (INPUT "help", INPUT p-errorNumber, INPUT p-errorParameters).
    ASSIGN c-help = RETURN-VALUE.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    ASSIGN i-seq = IF AVAIL RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = i-seq
           RowErrors.ErrorNumber      = p-errorNumber
           RowErrors.ErrorDescription = c-msg
         /*RowErrors.ErrorParameters  */
           RowErrors.ErrorType        = "EMS"
           RowErrors.ErrorHelp        = c-help
           RowErrors.ErrorSubType     = "ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordCustom wMaintenanceNoNavigation 
PROCEDURE saveRecordCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE RowErrors.

   for first wt-it-docto 
        where wt-it-docto.nat-comp     = tt-itens-devol.nat-operacao
        and   wt-it-docto.nro-comp     = tt-itens-devol.nro-docto
        and   wt-it-docto.seq-comp     = tt-itens-devol.sequencia
        and   wt-it-docto.serie-comp   = tt-itens-devol.serie-docto no-lock:
        CREATE rowerrors.
        ASSIGN rowerrors.errordescription = "ITEM desta nota ja relacionado a uma solicitaá∆o de nota fiscal com a sequencia " + string(wt-it-docto.seq-wt-docto).
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"} 
   END.

    /* geraWtItDoctoPartindoDoTtItensDevol in h-bodi317sd */
    RUN geraWtItDoctoPartindoDoTtItensDevol (INPUT  ttPed-fiscal.seq-wt-docto,
                                             INPUT  TABLE tt-itens-devol,
                                             OUTPUT l-proc-ok-aux).

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}        
    END.

    IF l-proc-ok-aux THEN DO:

        FOR EACH tt-itens-devol:
            DELETE tt-itens-devol.
        END.

        {&OPEN-QUERY-{&BROWSE-NAME}}

        RUN goToRecord2 IN phCaller.

        RETURN "OK":U.
    END.
    ELSE 
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

