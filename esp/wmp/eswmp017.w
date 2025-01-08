&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wReport


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-caixa NO-UNDO LIKE item-caixa
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttembalag NO-UNDO LIKE embalag
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i eswmp017 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        eswmp017
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page2Fields    fl-it-codigo-ini fl-it-codigo-fim bt-go bt-excel
&GLOBAL-DEFINE page2Browse    brTable1 

/* Parameters Definitions ---                                           */

/* DEFINE BUFFER b-tt-digita for tt-digita. */

/* Transfer Definitions */

DEF VAR raw-param AS RAW NO-UNDO.

/*
DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF VAR l-ok               AS logical no-undo.
DEF VAR c-arq-digita       AS char    no-undo.
DEF VAR c-terminal         AS char    no-undo.
DEF VAR c-rtf              AS char    no-undo.
DEF VAR c-arq-layout       AS char    no-undo.      
DEF VAR c-arq-temp         AS char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
*/
DEFINE STREAM s-imp.
DEFINE STREAM str-excel.
/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

/****************************  Includes  ****************************/
{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES wm-item

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 wm-item.cod-item wm-item.des-item ~
wm-item.qtd-peso wm-item.qtd-comprimento wm-item.qtd-largura ~
wm-item.qtd-altura 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH wm-item ~
      WHERE wm-item.cod-item >= fl-it-codigo-ini:screen-value in frame fPage2 ~
 AND wm-item.cod-item <= fl-it-codigo-fim:screen-value in frame fPage2 ~
 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH wm-item ~
      WHERE wm-item.cod-item >= fl-it-codigo-ini:screen-value in frame fPage2 ~
 AND wm-item.cod-item <= fl-it-codigo-fim:screen-value in frame fPage2 ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 wm-item
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 wm-item


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable1}

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "bt-excel" 
     SIZE 6 BY 1.5.

DEFINE BUTTON bt-go 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "bt-go" 
     SIZE 6 BY 1.5.

DEFINE VARIABLE fl-it-codigo-fim AS CHARACTER FORMAT "X(9)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fl-it-codigo-ini AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 117.86 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      wm-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wReport _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      wm-item.cod-item FORMAT "X(16)":U
      wm-item.des-item FORMAT "X(75)":U
      wm-item.qtd-peso FORMAT ">,>>>,>>9.9999":U
      wm-item.qtd-comprimento FORMAT ">,>>>,>>9.9999":U
      wm-item.qtd-largura FORMAT ">,>>>,>>9.9999":U
      wm-item.qtd-altura FORMAT ">,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 117.72 BY 11.25
         FONT 1 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133.43 BY 20.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     bt-go AT ROW 2.63 COL 80.29 WIDGET-ID 8
     bt-excel AT ROW 2.63 COL 87.29 HELP
          "Gerar Relatorio em Excel" WIDGET-ID 16
     fl-it-codigo-ini AT ROW 3 COL 40 COLON-ALIGNED WIDGET-ID 2
     fl-it-codigo-fim AT ROW 3 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     brTable1 AT ROW 5.46 COL 2.14 WIDGET-ID 200
     IMAGE-1 AT ROW 3 COL 54 WIDGET-ID 12
     IMAGE-2 AT ROW 3 COL 61 WIDGET-ID 14
     RECT-1 AT ROW 2 COL 2.14 WIDGET-ID 18
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 120.43 BY 16.21
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-item-caixa T "?" NO-UNDO mgcad item-caixa
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttembalag T "?" NO-UNDO mgcad embalag
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta itens WMS"
         HEIGHT             = 18.38
         WIDTH              = 124.72
         MAX-HEIGHT         = 40.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 40.67
         VIRTUAL-WIDTH      = 195.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable1 fl-it-codigo-fim fPage2 */
/* SETTINGS FOR BUTTON bt-go IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       bt-go:HIDDEN IN FRAME fPage2           = TRUE.

ASSIGN 
       fl-it-codigo-fim:PRIVATE-DATA IN FRAME fPage2     = 
                "ASSIGN fl-it-codigo-fim = INPUT FRAME fPage2 fl-it-codigo-ini.".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "mgcad.wm-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _Where[1]         = "mgcad.wm-item.cod-item >= fl-it-codigo-ini:screen-value in frame fPage2
 AND mgcad.wm-item.cod-item <= fl-it-codigo-fim:screen-value in frame fPage2
"
     _FldNameList[1]   = mgcad.wm-item.cod-item
     _FldNameList[2]   > mgcad.wm-item.des-item
"wm-item.des-item" ? "X(75)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = mgcad.wm-item.qtd-peso
     _FldNameList[4]   = mgcad.wm-item.qtd-comprimento
     _FldNameList[5]   = mgcad.wm-item.qtd-largura
     _FldNameList[6]   = mgcad.wm-item.qtd-altura
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Consulta itens WMS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Consulta itens WMS */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel wReport
ON CHOOSE OF bt-excel IN FRAME fPage2 /* bt-excel */
DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    
    IF OPSYS = "UNIX" THEN DO:
        RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                           INPUT 1,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

            OS-CREATE-DIR VALUE(c-excel).

            ASSIGN c-excel = c-excel + "esftp108.csv".

        END.

    END.
    ELSE DO:
        
        RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

            OS-CREATE-DIR VALUE(c-excel).

            ASSIGN c-excel = c-excel + "eswmp017.csv".
        END.

    END.

    OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

    PUT STREAM str-excel "Item;Descri‡Æo;Peso;Comprimento;Largura;Altura" SKIP.
    
    FOR EACH wm-item WHERE
             wm-item.cod-item >= INPUT FRAME fpage2 fl-it-codigo-ini AND
             wm-item.cod-item <= INPUT FRAME fpage2 fl-it-codigo-fim
             NO-LOCK.
    
        PUT STREAM str-excel 
             wm-item.cod-item           ";"
             wm-item.des-item           ";"
             wm-item.qtd-peso        FORMAT ">>>>>>>>>>9.9999"   ";"
             wm-item.qtd-comprimento FORMAT ">>>>>>>>>>9.9999"   ";"
             wm-item.qtd-largura     FORMAT ">>>>>>>>>>9.9999"   ";"
             wm-item.qtd-altura      FORMAT ">>>>>>>>>>9.9999" 
             SKIP.
    END.

    OUTPUT STREAM str-excel CLOSE.

    CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.

    IF ERROR-STATUS:ERROR THEN 
        CREATE "Excel.Application":U chExcel.

    ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
    ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).

    chPlanilhaMod:Activate().

    ASSIGN chExcel:VISIBLE     = TRUE
           chExcel:WindowState = 3.

    RELEASE OBJECT chExcel       NO-ERROR.
    RELEASE OBJECT chArquivo     NO-ERROR.
    RELEASE OBJECT chPlanilhaMod NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go wReport
ON CHOOSE OF bt-go IN FRAME fPage2 /* bt-go */
DO:
   

  /*  IF  SESSION:SET-WAIT-STATE("general") THEN. */
    {&open-query-brTable1}
   
  /*  IF  SESSION:SET-WAIT-STATE("") THEN. */
  
     
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fl-it-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fl-it-codigo-fim wReport
ON LEAVE OF fl-it-codigo-fim IN FRAME fPage2
DO:
    IF INPUT FRAME fPage2 fl-it-codigo-ini <> "" AND INPUT FRAME fPage2 fl-it-codigo-fim = "" THEN
    ASSIGN fl-it-codigo-fim = "".
    
    DO WHILE INPUT FRAME fPage2 fl-it-codigo-ini <> "" AND fl-it-codigo-fim = "":
        
        ASSIGN fl-it-codigo-fim = INPUT FRAME fPage2 fl-it-codigo-ini.
        IF INPUT FRAME fPage2 fl-it-codigo-fim <> "" THEN LEAVE.

        DISPLAY fl-it-codigo-fim WITH FRAME fPage2. 

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN brTable1:SENSITIVE IN FRAME fPage2 = TRUE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

