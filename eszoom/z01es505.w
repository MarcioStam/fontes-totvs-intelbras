&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-def-nat-operacao NO-UNDO LIKE def-nat-operacao
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i z01es505 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es505
&GLOBAL-DEFINE Version           2.04.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Def. Nat.Opera‡Æo

&GLOBAL-DEFINE Range             NO
&GLOBAL-DEFINE ttTable1          tt-def-nat-operacao
&GLOBAL-DEFINE hDBOTable1        hboes505
&GLOBAL-DEFINE DBOTable1         tt-def-nat-operacao
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO


&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-def-nat-operacao

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-def-nat-operacao.estado-origem ~
tt-def-nat-operacao.class-fiscal tt-def-nat-operacao.ind-cliente-contrib ~
tt-def-nat-operacao.ind-insc-estadual-inf ~
tt-def-nat-operacao.ind-subst-tributaria ~
tt-def-nat-operacao.ind-consumidor-final ~
tt-def-nat-operacao.ind-suframa-inf tt-def-nat-operacao.cidade-destino ~
tt-def-nat-operacao.estado-destino tt-def-nat-operacao.ind-forma-tributo ~
tt-def-nat-operacao.ind-pais-brasil tt-def-nat-operacao.ind-oem ~
tt-def-nat-operacao.ind-lei-bem tt-def-nat-operacao.ind-icms-st-antec ~
tt-def-nat-operacao.ind-origem-item tt-def-nat-operacao.ind-vendas-alc ~
tt-def-nat-operacao.nat-oper-revenda-de ~
tt-def-nat-operacao.nat-oper-revenda-fe ~
tt-def-nat-operacao.nat-oper-serv-de tt-def-nat-operacao.nat-oper-serv-fe ~
tt-def-nat-operacao.nat-oper-venda-de tt-def-nat-operacao.nat-oper-venda-fe 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-def-nat-operacao NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-def-nat-operacao NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-def-nat-operacao
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-def-nat-operacao


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 132 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-class-fiscal-fim AS CHARACTER FORMAT "XXXX.XX.XX" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-class-fiscal-ini AS CHARACTER FORMAT "XXXX.XX.XX" 
     LABEL "Class. Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-estado-dest-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88.

DEFINE VARIABLE fi-estado-dest-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "UF Destino" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-estado-orig-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88.

DEFINE VARIABLE fi-estado-orig-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE VARIABLE tg-cliente-contrib AS LOGICAL INITIAL no 
     LABEL "Cliente Contribuinte" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-consumidor-final AS LOGICAL INITIAL no 
     LABEL "Consumidor Final" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-icms-st AS LOGICAL INITIAL no 
     LABEL "ICMS ST" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-oem AS LOGICAL INITIAL no 
     LABEL "OEM" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-def-nat-operacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-def-nat-operacao.estado-origem FORMAT "x(2)":U
      tt-def-nat-operacao.class-fiscal FORMAT "XXXX.XX.XX":U WIDTH 12.86
      tt-def-nat-operacao.ind-cliente-contrib COLUMN-LABEL "Contribuinte ICMS" FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-insc-estadual-inf COLUMN-LABEL "Insc.Estadual" FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-subst-tributaria FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-consumidor-final FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-suframa-inf COLUMN-LABEL "Suframa" FORMAT "Sim/Nao":U
      tt-def-nat-operacao.cidade-destino FORMAT "x(25)":U
      tt-def-nat-operacao.estado-destino COLUMN-LABEL "Estado Des" FORMAT "x(2)":U
      tt-def-nat-operacao.ind-forma-tributo FORMAT "9":U
      tt-def-nat-operacao.ind-pais-brasil FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-oem FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-lei-bem FORMAT "Sim/Nao":U
      tt-def-nat-operacao.ind-icms-st-antec FORMAT "Sim/NÆo":U
      tt-def-nat-operacao.ind-origem-item FORMAT "9":U
      tt-def-nat-operacao.ind-vendas-alc FORMAT ">9":U
      tt-def-nat-operacao.nat-oper-revenda-de COLUMN-LABEL "Revenda Dentro Estado" FORMAT "x(6)":U
      tt-def-nat-operacao.nat-oper-revenda-fe COLUMN-LABEL "Revenda Fora Estado" FORMAT "x(8)":U
      tt-def-nat-operacao.nat-oper-serv-de COLUMN-LABEL "Servico Dentro Estado" FORMAT "x(8)":U
      tt-def-nat-operacao.nat-oper-serv-fe COLUMN-LABEL "Servico Fora Estado" FORMAT "x(6)":U
      tt-def-nat-operacao.nat-oper-venda-de COLUMN-LABEL "Venda Dentro Estado" FORMAT "x(6)":U
      tt-def-nat-operacao.nat-oper-venda-fe COLUMN-LABEL "Venda Fora Estado" FORMAT "x(6)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 13.25
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 22.46 COL 2
     btCancel AT ROW 22.46 COL 13
     btHelp AT ROW 22.5 COL 122
     rtToolBar AT ROW 22.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133.72 BY 23
         FONT 1.

DEFINE FRAME fPage1
     fi-estado-orig-ini AT ROW 1.25 COL 49 COLON-ALIGNED
     fi-estado-orig-fim AT ROW 1.25 COL 69.29 COLON-ALIGNED NO-LABEL
     fi-estado-dest-ini AT ROW 2.25 COL 49 COLON-ALIGNED WIDGET-ID 4
     fi-estado-dest-fim AT ROW 2.25 COL 69.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fi-class-fiscal-ini AT ROW 3.25 COL 46.29 COLON-ALIGNED WIDGET-ID 20
     fi-class-fiscal-fim AT ROW 3.25 COL 69.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     btCheck AT ROW 3.5 COL 125 RIGHT-ALIGNED
     tg-cliente-contrib AT ROW 4.33 COL 26 WIDGET-ID 10
     tg-icms-st AT ROW 4.33 COL 49 WIDGET-ID 12
     tg-consumidor-final AT ROW 4.33 COL 68 WIDGET-ID 14
     tg-oem AT ROW 4.33 COL 92 WIDGET-ID 16
     brTable1 AT ROW 5.5 COL 2
     btImplant1 AT ROW 19 COL 2
     IMAGE-1 AT ROW 1.25 COL 61.29
     IMAGE-2 AT ROW 1.25 COL 67.86
     IMAGE-3 AT ROW 2.25 COL 61.29 WIDGET-ID 6
     IMAGE-4 AT ROW 2.25 COL 67.86 WIDGET-ID 8
     IMAGE-5 AT ROW 3.25 COL 61.29 WIDGET-ID 22
     IMAGE-6 AT ROW 3.25 COL 67.86 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 129.43 BY 19.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-def-nat-operacao T "?" NO-UNDO mgesp def-nat-operacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 23
         WIDTH              = 133.72
         MAX-HEIGHT         = 23
         MAX-WIDTH          = 133.72
         VIRTUAL-HEIGHT     = 23
         VIRTUAL-WIDTH      = 133.72
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 tg-oem fPage1 */
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-def-nat-operacao"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   = Temp-Tables.tt-def-nat-operacao.estado-origem
     _FldNameList[2]   > Temp-Tables.tt-def-nat-operacao.class-fiscal
"class-fiscal" ? ? "character" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-def-nat-operacao.ind-cliente-contrib
"ind-cliente-contrib" "Contribuinte ICMS" "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-def-nat-operacao.ind-insc-estadual-inf
"ind-insc-estadual-inf" "Insc.Estadual" "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-def-nat-operacao.ind-subst-tributaria
"ind-subst-tributaria" ? "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-def-nat-operacao.ind-consumidor-final
"ind-consumidor-final" ? "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-def-nat-operacao.ind-suframa-inf
"ind-suframa-inf" "Suframa" "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.tt-def-nat-operacao.cidade-destino
     _FldNameList[9]   > Temp-Tables.tt-def-nat-operacao.estado-destino
"estado-destino" "Estado Des" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.tt-def-nat-operacao.ind-forma-tributo
     _FldNameList[11]   > Temp-Tables.tt-def-nat-operacao.ind-pais-brasil
"ind-pais-brasil" ? "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-def-nat-operacao.ind-oem
"ind-oem" ? "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-def-nat-operacao.ind-lei-bem
"ind-lei-bem" ? "Sim/Nao" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-def-nat-operacao.ind-icms-st-antec
"ind-icms-st-antec" ? "Sim/NÆo" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   = Temp-Tables.tt-def-nat-operacao.ind-origem-item
     _FldNameList[16]   = Temp-Tables.tt-def-nat-operacao.ind-vendas-alc
     _FldNameList[17]   > Temp-Tables.tt-def-nat-operacao.nat-oper-revenda-de
"nat-oper-revenda-de" "Revenda Dentro Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tt-def-nat-operacao.nat-oper-revenda-fe
"nat-oper-revenda-fe" "Revenda Fora Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.tt-def-nat-operacao.nat-oper-serv-de
"nat-oper-serv-de" "Servico Dentro Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.tt-def-nat-operacao.nat-oper-serv-fe
"nat-oper-serv-fe" "Servico Fora Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.tt-def-nat-operacao.nat-oper-venda-de
"nat-oper-venda-de" "Venda Dentro Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.tt-def-nat-operacao.nat-oper-venda-fe
"nat-oper-venda-fe" "Venda Fora Estado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
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

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck wZoom
ON CHOOSE OF btCheck IN FRAME fPage1
DO:
  ASSIGN INPUT FRAME fpage1
         fi-estado-orig-ini fi-estado-orig-fim 
         fi-estado-dest-ini fi-estado-dest-fim
         fi-class-fiscal-ini fi-class-fiscal-fim
         tg-cliente-contrib tg-icms-st tg-consumidor-final tg-oem .
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    /*
    {zoom/Implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}
   */                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wZoom 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DISP fi-estado-orig-ini fi-estado-orig-fim 
         fi-estado-dest-ini fi-estado-dest-fim
         fi-class-fiscal-ini fi-class-fiscal-fim
         tg-cliente-contrib tg-icms-st tg-consumidor-final tg-oem WITH FRAME fPage1.
    ENABLE fi-estado-orig-ini fi-estado-orig-fim 
         fi-estado-dest-ini fi-estado-dest-fim
        fi-class-fiscal-ini fi-class-fiscal-fim
         tg-cliente-contrib tg-icms-st tg-consumidor-final tg-oem btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-estado-orig-ini IN FRAME fPage1.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "esbo/boes505.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes505.p YES}
        {btb/btb008za.i2 esbo/boes505.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT "",
                                             INPUT "ZZ",
                                             INPUT "",
                                             INPUT "ZZ",
                                             INPUT "",
                                             INPUT "ZZZZ.ZZ.ZZ",
                                             INPUT NO,
                                             INPUT NO,
                                             INPUT NO,
                                             INPUT NO).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {zoom/OpenQueries.i &Query="Zoom1"
                        &PageNumber="1"}
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-entry wZoom 
PROCEDURE pi-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* rotina obsoleta */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-atributos-chave wZoom 
PROCEDURE pi-seta-atributos-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-lista-atributos-chave as character no-undo.
  DEF VAR i AS INTEGER NO-UNDO.
  DEF VAR c-pair AS CHAR NO-UNDO.
  
  ASSIGN cFieldHandles = ""
         cFieldNames   = "".
  DO i = 1 TO NUM-ENTRIES(p-lista-atributos-chave, chr(10)):
     ASSIGN c-pair        = ENTRY(i, p-lista-atributos-chave, chr(10))
            cFieldHandles = cFieldHandles + ENTRY(1, c-pair, "|") + ","
            cFieldNames   = cFieldNames + ENTRY(2, c-pair, "|") + "," .
  END.
  SUBSTRING(cFieldHandles, LENGTH(cFieldHandles), 1) = "".
  SUBSTRING(cFieldNames, LENGTH(cFieldNames), 1) = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "estado-origem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.estado-origem).
            WHEN "estado-destino":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.estado-destino).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN DO:
            RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT fi-estado-orig-ini,
                                                     INPUT fi-estado-orig-fim,
                                                     INPUT fi-estado-dest-ini,
                                                     INPUT fi-estado-dest-fim,
                                                     INPUT fi-class-fiscal-ini,
                                                     INPUT fi-class-fiscal-fim,
                                                     INPUT tg-cliente-contrib,
                                                     INPUT tg-icms-st,
                                                     INPUT tg-consumidor-final,
                                                     INPUT tg-oem).

        END.
            /*:T--- Seta Constraints para o DBO Table1 ---*/
        
    END CASE.
    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

