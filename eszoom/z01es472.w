&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-juridico-processos NO-UNDO LIKE juridico-processos
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
{include/i-prgvrs.i z01es472 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es472
&GLOBAL-DEFINE Version           2.04.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Solu‡äes

&GLOBAL-DEFINE Range             NO
&GLOBAL-DEFINE ttTable1          tt-juridico-processos
&GLOBAL-DEFINE hDBOTable1        hboes472
&GLOBAL-DEFINE DBOTable1         tt-juridico-processos
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
&Scoped-define INTERNAL-TABLES tt-juridico-processos

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-juridico-processos.processo ~
tt-juridico-processos.autor tt-juridico-processos.cpf-cnpj ~
tt-juridico-processos.cidade fn-motivo(tt-juridico-processos.cod-motivo) ~
fn-situacao(tt-juridico-processos.cod-situacao) ~
fn-solucao(tt-juridico-processos.cod-solucao) ~
fn-tipo(tt-juridico-processos.cod-tipo) vara-judicial ~
tt-juridico-processos.cod-unid-negoc tt-juridico-processos.contato ~
tt-juridico-processos.data-compra tt-juridico-processos.defeito ~
tt-juridico-processos.dt-entrada-astec tt-juridico-processos.dt-processo ~
tt-juridico-processos.dt-recebimento tt-juridico-processos.dt-saida-astec ~
tt-juridico-processos.estado tt-juridico-processos.nr-serie ~
tt-juridico-processos.objeto-acao tt-juridico-processos.ordem-servico ~
tt-juridico-processos.posto-autorizado tt-juridico-processos.produto ~
tt-juridico-processos.solucao tt-juridico-processos.valor-acao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-juridico-processos NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-juridico-processos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-juridico-processos
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-juridico-processos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-motivo wZoom 
FUNCTION fn-motivo RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao wZoom 
FUNCTION fn-situacao RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-solucao wZoom 
FUNCTION fn-solucao RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tipo wZoom 
FUNCTION fn-tipo RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-autor AS CHARACTER FORMAT "X(12)" 
     LABEL "Autor" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88.

DEFINE VARIABLE fi-cpf-cnpj AS CHARACTER FORMAT "X(12)" 
     LABEL "CPF/CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88.

DEFINE VARIABLE fi-processo AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-juridico-processos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-juridico-processos.processo FORMAT "x(30)":U
      tt-juridico-processos.autor FORMAT "x(60)":U WIDTH 33.43
      tt-juridico-processos.cpf-cnpj FORMAT "x(30)":U WIDTH 23.57
      tt-juridico-processos.cidade FORMAT "x(60)":U
      fn-motivo(tt-juridico-processos.cod-motivo) COLUMN-LABEL "Motivo" FORMAT "X(20)":U
            WIDTH 18
      fn-situacao(tt-juridico-processos.cod-situacao) COLUMN-LABEL "Situa‡Æo" FORMAT "X(20)":U
            WIDTH 18
      fn-solucao(tt-juridico-processos.cod-solucao) COLUMN-LABEL "Solu‡Æo" FORMAT "X(20)":U
            WIDTH 18
      fn-tipo(tt-juridico-processos.cod-tipo) COLUMN-LABEL "Tipo" FORMAT "x(20)":U
            WIDTH 18
      vara-judicial COLUMN-LABEL "Vara" FORMAT "x(40)":U WIDTH 30.72
      tt-juridico-processos.cod-unid-negoc FORMAT "x(03)":U
      tt-juridico-processos.contato FORMAT "x(80)":U
      tt-juridico-processos.data-compra FORMAT "99/99/9999":U
      tt-juridico-processos.defeito FORMAT "x(200)":U
      tt-juridico-processos.dt-entrada-astec FORMAT "99/99/9999":U
      tt-juridico-processos.dt-processo FORMAT "99/99/9999":U
      tt-juridico-processos.dt-recebimento FORMAT "99/99/9999":U
      tt-juridico-processos.dt-saida-astec FORMAT "99/99/9999":U
      tt-juridico-processos.estado FORMAT "x(02)":U
      tt-juridico-processos.nr-serie FORMAT "x(40)":U
      tt-juridico-processos.objeto-acao FORMAT "x(60)":U
      tt-juridico-processos.ordem-servico FORMAT "x(40)":U
      tt-juridico-processos.posto-autorizado FORMAT "x(60)":U
      tt-juridico-processos.produto FORMAT "x(60)":U
      tt-juridico-processos.solucao FORMAT "x(200)":U
      tt-juridico-processos.valor-acao FORMAT "->>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     fi-processo AT ROW 1.25 COL 19 COLON-ALIGNED
     fi-autor AT ROW 2.25 COL 19 COLON-ALIGNED WIDGET-ID 2
     fi-cpf-cnpj AT ROW 3.25 COL 19 COLON-ALIGNED WIDGET-ID 4
     btCheck AT ROW 3.25 COL 71 RIGHT-ALIGNED
     brTable1 AT ROW 4.5 COL 2
     btImplant1 AT ROW 13.04 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-juridico-processos T "?" NO-UNDO mgesp juridico-processos
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
         HEIGHT             = 17
         WIDTH              = 90
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
/* BROWSE-TAB brTable1 btCheck fPage1 */
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-juridico-processos"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   = Temp-Tables.tt-juridico-processos.processo
     _FldNameList[2]   > Temp-Tables.tt-juridico-processos.autor
"autor" ? ? "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-juridico-processos.cpf-cnpj
"cpf-cnpj" ? ? "character" ? ? ? ? ? ? no ? no no "23.57" yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.tt-juridico-processos.cidade
     _FldNameList[5]   > "_<CALC>"
"fn-motivo(tt-juridico-processos.cod-motivo)" "Motivo" "X(20)" ? ? ? ? ? ? ? no ? no no "18" yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"fn-situacao(tt-juridico-processos.cod-situacao)" "Situa‡Æo" "X(20)" ? ? ? ? ? ? ? no ? no no "18" yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"fn-solucao(tt-juridico-processos.cod-solucao)" "Solu‡Æo" "X(20)" ? ? ? ? ? ? ? no ? no no "18" yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"fn-tipo(tt-juridico-processos.cod-tipo)" "Tipo" "x(20)" ? ? ? ? ? ? ? no ? no no "18" yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"vara-judicial" "Vara" "x(40)" ? ? ? ? ? ? ? no ? no no "30.72" yes no no "U" "" ""
     _FldNameList[10]   = Temp-Tables.tt-juridico-processos.cod-unid-negoc
     _FldNameList[11]   = Temp-Tables.tt-juridico-processos.contato
     _FldNameList[12]   = Temp-Tables.tt-juridico-processos.data-compra
     _FldNameList[13]   = Temp-Tables.tt-juridico-processos.defeito
     _FldNameList[14]   = Temp-Tables.tt-juridico-processos.dt-entrada-astec
     _FldNameList[15]   = Temp-Tables.tt-juridico-processos.dt-processo
     _FldNameList[16]   = Temp-Tables.tt-juridico-processos.dt-recebimento
     _FldNameList[17]   = Temp-Tables.tt-juridico-processos.dt-saida-astec
     _FldNameList[18]   = Temp-Tables.tt-juridico-processos.estado
     _FldNameList[19]   = Temp-Tables.tt-juridico-processos.nr-serie
     _FldNameList[20]   = Temp-Tables.tt-juridico-processos.objeto-acao
     _FldNameList[21]   = Temp-Tables.tt-juridico-processos.ordem-servico
     _FldNameList[22]   = Temp-Tables.tt-juridico-processos.posto-autorizado
     _FldNameList[23]   = Temp-Tables.tt-juridico-processos.produto
     _FldNameList[24]   = Temp-Tables.tt-juridico-processos.solucao
     _FldNameList[25]   = Temp-Tables.tt-juridico-processos.valor-acao
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
         fi-processo fi-autor fi-cpf-cnpj.
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

    DISP fi-processo fi-autor fi-cpf-cnpj WITH FRAME fPage1.
    ENABLE fi-processo fi-autor fi-cpf-cnpj btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-processo IN FRAME fPage1.
 
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes472.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes472.p YES}
        {btb/btb008za.i2 esbo/boes472.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT "",
                                             INPUT "",
                                             INPUT "").
    
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
            WHEN "processo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.processo).
            WHEN "autor":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.autor).
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
            RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT fi-processo,
                                                     INPUT fi-autor,
                                                     INPUT fi-cpf-cnpj).

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-motivo wZoom 
FUNCTION fn-motivo RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    FIND FIRST juridico-motivos NO-LOCK
         WHERE juridico-motivos.codigo = p-codigo NO-ERROR.
    IF AVAIL juridico-motivos THEN
        ASSIGN c-retorno = STRING(p-codigo) + "-" + juridico-motivos.descricao.
    ELSE 
        ASSIGN c-retorno = STRING(p-codigo) + "-Nao Cadastrado".

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao wZoom 
FUNCTION fn-situacao RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    FIND FIRST juridico-situacoes NO-LOCK
         WHERE juridico-situacoes.codigo = p-codigo NO-ERROR.
    IF AVAIL juridico-situacoes THEN
        ASSIGN c-retorno = STRING(p-codigo) + "-" + juridico-situacoes.descricao.
    ELSE 
        ASSIGN c-retorno = STRING(p-codigo) + "-Nao Cadastrado".

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-solucao wZoom 
FUNCTION fn-solucao RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    FIND FIRST juridico-solucoes NO-LOCK
         WHERE juridico-solucoes.codigo = p-codigo NO-ERROR.
    IF AVAIL juridico-solucoes THEN
        ASSIGN c-retorno = STRING(p-codigo) + "-" + juridico-solucoes.descricao.
    ELSE 
        ASSIGN c-retorno = STRING(p-codigo) + "-Nao Cadastrado".

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tipo wZoom 
FUNCTION fn-tipo RETURNS CHARACTER
  (INPUT p-codigo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    FIND FIRST juridico-tipos NO-LOCK
         WHERE juridico-tipos.codigo = p-codigo NO-ERROR.
    IF AVAIL juridico-tipos THEN
        ASSIGN c-retorno = STRING(p-codigo) + "-" + juridico-tipos.descricao.
    ELSE 
        ASSIGN c-retorno = STRING(p-codigo) + "-Nao Cadastrado".

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

