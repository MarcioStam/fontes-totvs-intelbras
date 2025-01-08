&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttreporte-seletivo NO-UNDO LIKE reporte-seletivo
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP010 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP010
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Para include esp/BrowseMgnt.i no MainBlock */
&GLOBAL-DEFINE ttTable        ttreporte-seletivo
&GLOBAL-DEFINE BrowseName     brMain   
&GLOBAL-DEFINE hDBOTable      h-boes164

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-boes164 AS HANDLE NO-UNDO.
DEF VAR iqtd AS INTEGER NO-UNDO.

def var p-it-codigo-ini     like item.it-codigo         no-undo.
def var p-it-codigo-fim     like item.it-codigo         no-undo.
def var p-es-codigo-ini     like estrutura.es-codigo    no-undo.
def var p-es-codigo-fim     like estrutura.es-codigo    no-undo.
def var p-data-inicial-ini  as date                     no-undo.
def var p-data-inicial-fim  as date                     no-undo.
def var p-data-final-ini    as date                     no-undo.
def var p-data-final-fim    as date                     no-undo.
def var p-tipo-ini          like reporte-seletivo.tipo  no-undo.
def var p-tipo-fim          like reporte-seletivo.tipo  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttreporte-seletivo

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain ttreporte-seletivo.it-codigo ~
ttreporte-seletivo.es-codigo ttreporte-seletivo.data-inicial ~
ttreporte-seletivo.data-final ttreporte-seletivo.tipo ~
ttreporte-seletivo.quantidade ttreporte-seletivo.qtd-unitaria ~
ttreporte-seletivo.quant-saldo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain 
&Scoped-define QUERY-STRING-brMain FOR EACH ttreporte-seletivo NO-LOCK
&Scoped-define OPEN-QUERY-brMain OPEN QUERY brMain FOR EACH ttreporte-seletivo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brMain ttreporte-seletivo
&Scoped-define FIRST-TABLE-IN-QUERY-brMain ttreporte-seletivo


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp brMain btAddSon1 btDeleteSon1 btLimpar bt-faixa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-faixa 
     LABEL "Faixa" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLimpar 
     LABEL "Limpar" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      ttreporte-seletivo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wWindow _STRUCTURED
  QUERY brMain NO-LOCK DISPLAY
      ttreporte-seletivo.it-codigo FORMAT "x(16)":U
      ttreporte-seletivo.es-codigo FORMAT "x(16)":U WIDTH 9.86
      ttreporte-seletivo.data-inicial COLUMN-LABEL "In¡cio" FORMAT "99/99/9999":U
      ttreporte-seletivo.data-final COLUMN-LABEL "Fim" FORMAT "99/99/9999":U
      ttreporte-seletivo.tipo FORMAT "Entrada/Saida":U WIDTH 5.57
      ttreporte-seletivo.quantidade COLUMN-LABEL "Quantidade" FORMAT ">>>>>,>>>,>>9.9999":U
      ttreporte-seletivo.qtd-unitaria COLUMN-LABEL "Unit rio" FORMAT ">>>,>>9.9999":U
      ttreporte-seletivo.quant-saldo FORMAT "->>>>>,>>>,>>9.9999":U
            WIDTH 12.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 10.83
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     brMain AT ROW 2.5 COL 1.57 WIDGET-ID 200
     btAddSon1 AT ROW 13.5 COL 2 WIDGET-ID 4
     btDeleteSon1 AT ROW 13.5 COL 12 WIDGET-ID 6
     btLimpar AT ROW 13.5 COL 22 WIDGET-ID 8
     bt-faixa AT ROW 13.5 COL 32 WIDGET-ID 2
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.92
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 56 ROW 13.5
         SIZE 7 BY 1
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttreporte-seletivo T "?" NO-UNDO mgesp reporte-seletivo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.92
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brMain btHelp fpage0 */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _TblList          = "Temp-Tables.ttreporte-seletivo"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttreporte-seletivo.it-codigo
     _FldNameList[2]   > Temp-Tables.ttreporte-seletivo.es-codigo
"ttreporte-seletivo.es-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttreporte-seletivo.data-inicial
"ttreporte-seletivo.data-inicial" "In¡cio" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttreporte-seletivo.data-final
"ttreporte-seletivo.data-final" "Fim" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttreporte-seletivo.tipo
"ttreporte-seletivo.tipo" ? ? "logical" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttreporte-seletivo.quantidade
"ttreporte-seletivo.quantidade" "Quantidade" ">>>>>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttreporte-seletivo.qtd-unitaria
"ttreporte-seletivo.qtd-unitaria" "Unit rio" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttreporte-seletivo.quant-saldo
"ttreporte-seletivo.quant-saldo" ? "->>>>>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brMain */
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


&Scoped-define SELF-NAME bt-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-faixa wWindow
ON CHOOSE OF bt-faixa IN FRAME fpage0 /* Faixa */
DO:
  run esp/cpp/escpp010b.w (input-output p-it-codigo-ini,
                           input-output p-it-codigo-fim,
                           input-output p-es-codigo-ini,
                           input-output p-es-codigo-fim,
                           input-output p-data-inicial-ini,
                           input-output p-data-inicial-fim,
                           input-output p-data-final-ini,
                           input-output p-data-final-fim,
                           input-output p-tipo-ini,
                           input-output p-tipo-fim).
                           
                                                                                    
    run setConstraintFaixaItem IN h-boes164 (input p-it-codigo-ini,
                                             input p-it-codigo-fim,
                                             input p-es-codigo-ini,
                                             input p-es-codigo-fim,
                                             input p-data-inicial-ini,
                                             input p-data-inicial-fim,
                                             input p-data-final-ini,
                                             input p-data-final-fim,
                                             input p-tipo-ini,
                                             input p-tipo-fim) no-error.                                                                                               
                                                
    RUN openQueryStatic IN h-boes164 (INPUT "FaixaItem":U) NO-ERROR.    
    
    RUN getBatchRecords IN h-boes164 (INPUT ?,
                                      INPUT ?,
                                      INPUT 40,
                                      OUTPUT iqtd,
                                      OUTPUT TABLE ttreporte-seletivo).
                           
    {&OPEN-QUERY-brMain}                       
                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wWindow
ON CHOOSE OF btAddSon1 IN FRAME fpage0 /* Incluir */
DO:
   wWindow:SENSITIVE = NO.
   RUN esp/cpp/escpp010a.w (INPUT THIS-PROCEDURE, 
                            INPUT h-boes164).
   wWindow:SENSITIVE = YES.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wWindow
ON CHOOSE OF btDeleteSon1 IN FRAME fpage0 /* Eliminar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0    
        THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
        run utp/ut-msgs.p (input "show",
                           input 550,
                           input "").
        IF RETURN-VALUE = "yes" THEN DO:
            RUN emptyRowErrors IN h-boes164 NO-ERROR.        
            RUN repositionRecord IN h-boes164 (INPUT ttreporte-seletivo.r-rowid).  
            RUN deleteRecord IN h-boes164.
            RUN getrowerrors IN h-boes164 (OUTPUT TABLE rowerrors).
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                {method/ShowMessage.i1}.
                {method/ShowMessage.i2 &Modal="YES"}.
                {method/ShowMessage.i3}.
                RETURN NO-APPLY.
            END.
            DELETE ttreporte-seletivo.
            {&OPEN-QUERY-brMain}
        END.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpar wWindow
ON CHOOSE OF btLimpar IN FRAME fpage0 /* Limpar */
DO:
    RUN eliminaReportes IN h-boes164.  
    RUN openQueryStatic IN h-boes164 (INPUT "Main":U) NO-ERROR.
    RUN getBatchRecords IN h-boes164 (INPUT ?,
                                      INPUT ?,
                                      INPUT 40,
                                      OUTPUT iqtd,
                                      OUTPUT TABLE ttreporte-seletivo).
    {&OPEN-QUERY-brMain}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMain
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{esp/BrowseMgnt.i} 

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wWindow 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DELETE PROCEDURE h-boes164.
    ASSIGN h-boes164 = ?.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esbo/boes164.p PERSISTENT SET h-boes164.
    RUN openQueryStatic IN h-boes164 (INPUT "Main":U) NO-ERROR.
    RUN getBatchRecords IN h-boes164 (INPUT ?,
                                      INPUT ?,
                                      INPUT 40,
                                      OUTPUT iqtd,
                                      OUTPUT TABLE ttreporte-seletivo).

    {&OPEN-QUERY-brMain}
    
    ENABLE ALL WITH FRAME fPage0.
    
    assign p-it-codigo-ini      = ""
           p-it-codigo-fim      = "ZZZZZZZZZZZZZZZZ"
           p-es-codigo-ini      = ""
           p-es-codigo-fim      = "ZZZZZZZZZZZZZZZZ"
           p-data-inicial-ini   = 01/01/1900
           p-data-inicial-fim   = 12/31/2999
           p-data-final-ini     = 01/01/1900
           p-data-final-fim     = 12/31/2999
           p-tipo-ini           = no
           p-tipo-fim           = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

