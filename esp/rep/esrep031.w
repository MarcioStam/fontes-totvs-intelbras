&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESREP031 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESREP031
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution                               
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo 
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fi-estab fi-serie fi-docum fi-nat-retorno fi-nat-serv ~
                              fi-pedido fi-ord-prod fi-data-trans fi-depo-retorno fi-depo-serv ~
                              fi-quant fi-cod-modalid-frete
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile 
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD serie             LIKE docum-est.serie
    FIELD nro-docto         AS INTEGER FORMAT "9999999":U
    FIELD nat-retorno       LIKE docum-est.nat-operacao
    FIELD nat-servico       LIKE docum-est.nat-operacao
    FIELD num-pedido        LIKE pedido-compr.num-pedido
    FIELD nr-ord-prod       LIKE ord-prod.nr-ord-prod
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD cod-depos-ret     LIKE saldo-terc.cod-depos
    FIELD cod-depos-serv    LIKE saldo-terc.cod-depos
    FIELD cod-fornec        LIKE emitente.cod-emitente
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD qtd               LIKE saldo-terc.quantidade
    FIELD cod-modalid-frete LIKE modalid-frete.cod-modalid-frete
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */

DEF VAR raw-param        AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita     AS RAW.

DEF VAR l-ok             AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita     AS CHAR    NO-UNDO.
DEF VAR c-terminal       AS CHAR    NO-UNDO.
DEF VAR c-rtf            AS CHAR    NO-UNDO.
DEF VAR c-arq-layout     AS CHAR    NO-UNDO.
DEF VAR c-arq-temp       AS CHAR    NO-UNDO.
DEF VAR c-modelo-default AS CHAR    NO-UNDO.

DEF STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-modalid-frete LIKE modalid-frete.cod-modalid-frete
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-depo-retorno AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep Re" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-depo-serv AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep Se" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-modalid-frete LIKE modalid-frete.des-modalid-frete
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-depo-ret AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-depo-serv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-nat-ret AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-nat-serv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-docum AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-fornec AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-retorno AS CHARACTER FORMAT "X(6)":U 
     LABEL "Natureza Retorno" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-serv AS CHARACTER FORMAT "X(6)":U 
     LABEL "Natureza Serviáo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ord-prod AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem Produá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ordem-compr AS INTEGER FORMAT "zzzzzzzzz9,99":U INITIAL 0 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pedido AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL ? 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage2
     fi-estab AT ROW 1.5 COL 2.29
     fi-desc-estab AT ROW 1.5 COL 19.57 COLON-ALIGNED NO-LABEL
     fi-serie AT ROW 2.5 COL 10
     fi-docum AT ROW 3.5 COL 12.29 COLON-ALIGNED
     fi-nat-retorno AT ROW 4.5 COL 12.29 COLON-ALIGNED
     fi-desc-nat-ret AT ROW 4.5 COL 19.57 COLON-ALIGNED NO-LABEL
     fi-depo-retorno AT ROW 4.5 COL 55.43 COLON-ALIGNED HELP
          "Dep¢sito de Retorno"
     fi-desc-depo-ret AT ROW 4.5 COL 61.72 COLON-ALIGNED NO-LABEL
     fi-nat-serv AT ROW 5.5 COL 12.29 COLON-ALIGNED
     fi-desc-nat-serv AT ROW 5.5 COL 19.57 COLON-ALIGNED NO-LABEL
     fi-depo-serv AT ROW 5.5 COL 55.43 COLON-ALIGNED HELP
          "Dep¢sito de Serviáo"
     fi-desc-depo-serv AT ROW 5.5 COL 61.72 COLON-ALIGNED NO-LABEL
     fi-pedido AT ROW 6.5 COL 12.29 COLON-ALIGNED
     fi-ordem-compr AT ROW 6.5 COL 36.57 COLON-ALIGNED
     fi-ord-prod AT ROW 7.5 COL 12.29 COLON-ALIGNED
     fi-data-trans AT ROW 8.5 COL 12.29 COLON-ALIGNED
     fi-fornec AT ROW 9.5 COL 12.29 COLON-ALIGNED
     fi-desc-fornec AT ROW 9.5 COL 25.57 COLON-ALIGNED NO-LABEL
     fi-item AT ROW 10.5 COL 12.29 COLON-ALIGNED
     fi-desc-item AT ROW 10.5 COL 25.57 COLON-ALIGNED NO-LABEL
     fi-quant AT ROW 11.5 COL 12.29 COLON-ALIGNED
     fi-cod-modalid-frete AT ROW 12.5 COL 12.29 COLON-ALIGNED HELP
          "C¢digo Modalidade Frete" WIDGET-ID 2
     fi-des-modalid-frete AT ROW 12.5 COL 25.57 COLON-ALIGNED HELP
          "Descriá∆o Modalidade Frete" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.


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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = "Gera NF Industrializaá∆o"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 32.5
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.5
         VIRTUAL-WIDTH      = 205.72
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN fi-cod-modalid-frete IN FRAME fPage2
   LIKE = mgcad.modalid-frete.cod-modalid-frete EXP-SIZE                */
/* SETTINGS FOR FILL-IN fi-des-modalid-frete IN FRAME fPage2
   LIKE = mgcad.modalid-frete.des-modalid-frete EXP-SIZE                */
/* SETTINGS FOR FILL-IN fi-desc-nat-ret IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-nat-serv IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estab IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-fornec IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-item IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-serie IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Gera NF Industrializaá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Gera NF Industrializaá∆o */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-modalid-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-modalid-frete wReport
ON F5 OF fi-cod-modalid-frete IN FRAME fPage2 /* Modalidade Frete */
DO:
    {method/ZoomFields.i &ProgramZoom="dizoom/z01di600.w"
                         &FieldZoom1="cod-modalid-frete"
                         &FieldScreen1="fi-cod-modalid-frete"
                         &Frame1="fPage2"
                         &FieldZoom2="des-modalid-frete"
                         &FieldScreen2="fi-des-modalid-frete"
                         &Frame2="fPage2"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-modalid-frete wReport
ON LEAVE OF fi-cod-modalid-frete IN FRAME fPage2 /* Modalidade Frete */
DO:
    ASSIGN INPUT FRAME fPage2 fi-cod-modalid-frete.

    FIND FIRST modalid-frete
        WHERE modalid-frete.cod-modalid-frete = fi-cod-modalid-frete NO-LOCK NO-ERROR.

    ASSIGN fi-des-modalid-frete = IF AVAILABLE modalid-frete THEN modalid-frete.des-modalid-frete ELSE "":U.

    DISPLAY fi-des-modalid-frete
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-modalid-frete wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-modalid-frete IN FRAME fPage2 /* Modalidade Frete */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-depo-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-depo-retorno wReport
ON LEAVE OF fi-depo-retorno IN FRAME fPage2 /* Dep Re */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-desc-depo-ret
                     &where="deposito.cod-dep = fi-depo-retorno:screen-value in frame fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-depo-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-depo-serv wReport
ON LEAVE OF fi-depo-serv IN FRAME fPage2 /* Dep Se */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-desc-depo-serv
                     &where="deposito.cod-dep = fi-depo-serv:screen-value in frame fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab wReport
ON LEAVE OF fi-estab IN FRAME fPage2 /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-desc-estab
                     &where="estabelec.cod-estabel = fi-estab:screen-value in frame fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON LEAVE OF fi-fornec IN FRAME fPage2 /* Fornecedor */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-desc-fornec
                     &where="emitente.cod-emitente = int(fi-fornec:screen-value in frame fpage2)"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item wReport
ON LEAVE OF fi-item IN FRAME fPage2 /* Item */
DO:
    {include/leave.i &tabela=ITEM
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-item:screen-value in frame fpage2"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nat-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-retorno wReport
ON LEAVE OF fi-nat-retorno IN FRAME fPage2 /* Natureza Retorno */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-desc-nat-ret
                     &where="natur-oper.nat-operacao = fi-nat-retorno:screen-value in frame fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nat-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-serv wReport
ON LEAVE OF fi-nat-serv IN FRAME fPage2 /* Natureza Serviáo */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-desc-nat-serv
                     &where="natur-oper.nat-operacao = fi-nat-serv:screen-value in frame fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-prod wReport
ON LEAVE OF fi-ord-prod IN FRAME fPage2 /* Ordem Produá∆o */
DO:
    {include/leave.i &tabela=ord-prod
                     &atributo-ref=it-codigo
                     &variavel-ref=fi-item
                     &where="ord-prod.nr-ord-prod = int(fi-ord-prod:screen-value in frame fpage2)"}

    APPLY 'leave' TO fi-item IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pedido wReport
ON LEAVE OF fi-pedido IN FRAME fPage2 /* Pedido */
DO:
    FIND FIRST ordem-compra WHERE 
               ordem-compra.num-pedido = INPUT FRAME fPage2 fi-pedido NO-LOCK NO-ERROR.
    ASSIGN fi-fornec      = IF AVAIL ordem-compra THEN ordem-compra.cod-emitente ELSE 0
           fi-ordem-compr = IF AVAIL ordem-compra THEN ordem-compra.numero-ordem ELSE 0
           fi-quant       = IF AVAIL ordem-compra THEN ordem-compra.qt-solic     ELSE 0.

    DISPLAY fi-fornec fi-ordem-compr fi-quant
        WITH FRAME fPage2.        

    APPLY 'leave' TO fi-fornec IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado
      sobre o fill-in ---*/
IF fi-cod-modalid-frete:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2 THEN.

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
    /* Sugeri estabelecimento do usu†rio. */
    FIND FIRST usuar_univ WHERE 
               usuar_univ.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
    ASSIGN fi-estab             = IF AVAIL usuar_univ THEN usuar_univ.cod_estab ELSE "":U
           fi-data-trans        = TODAY
           fi-nat-retorno       = "190201":U
           fi-nat-serv          = "112401":U
           fi-depo-retorno      = "ind":U
           fi-cod-modalid-frete = "0":U.

    ASSIGN fi-depo-serv = "wal":U.


    DISPLAY fi-estab    fi-data-trans   fi-nat-retorno 
            fi-nat-serv fi-depo-retorno fi-depo-serv
            fi-cod-modalid-frete
        WITH FRAME fPage2.

    FIND FIRST ser-estab WHERE 
               ser-estab.cod-estabel = INPUT FRAME fPage2 fi-estab AND
               ser-estab.log-2 NO-LOCK NO-ERROR.
    ASSIGN fi-serie = IF AVAIL ser-estab THEN ser-estab.serie ELSE "":U.

    DISPLAY fi-serie
        WITH FRAME fPage2.
    
    APPLY 'leave':U TO fi-estab             IN FRAME fPage2.
    APPLY 'leave':U TO fi-nat-retorno       IN FRAME fPage2.
    APPLY 'leave':U TO fi-nat-serv          IN FRAME fPage2.
    APPLY 'leave':U TO fi-depo-retorno      IN FRAME fPage2.
    APPLY 'leave':U TO fi-depo-serv         IN FRAME fPage2.
    APPLY 'leave':U TO fi-fornec            IN FRAME fPage2.
    APPLY 'leave':U TO fi-item              IN FRAME fPage2.
    APPLY 'leave':U TO fi-cod-modalid-frete IN FRAME fPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

/*:T** Relatorio ***/
DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    IF INPUT FRAME fPage6 rsDestiny   = 2 AND
       INPUT FRAME fPage6 rsExecution = 1 THEN DO:
        RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
            APPLY "ENTRY":U TO cFile IN FRAME fPage6.
            RETURN ERROR.
        END.
    END.

    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
       
    /*Estabelecimento*/
    FIND FIRST estabelec WHERE
               estabelec.cod-estabel = INPUT FRAME fPage2 fi-estab NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN DO:
       RUN setFolder IN hFolder (INPUT 1).       
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 2,
                          INPUT "Estabelecimento").
       APPLY "entry" TO fi-estab IN FRAME fPage2.
       RETURN ERROR.
    END.
    /*Serie*/
    IF INPUT FRAME fPage2 fi-serie = "":U THEN DO:
       RUN setFolder IN hFolder (INPUT 1).       
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 3145,
                          INPUT "Serie").
       APPLY "entry" TO fi-serie IN FRAME fPage2.
       RETURN ERROR.
    END.
    /*Documento*/            
    FIND FIRST docum-est WHERE 
               docum-est.cod-estabel  = INPUT FRAME fPage2 fi-estab  AND
               docum-est.serie-docto  = INPUT FRAME fPage2 fi-serie  AND 
               docum-est.nro-docto    = INPUT FRAME fPage2 fi-docum  AND
               docum-est.cod-emitente = INPUT FRAME fPage2 fi-fornec AND
               docum-est.nat-operacao = INPUT FRAME fPage2 fi-nat-retorno NO-LOCK NO-ERROR.
    IF AVAIL docum-est THEN DO:
        RUN setFolder IN hFolder (INPUT 1).       
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Nota Fiscal de Retorno j† existe!" + "~~" + 
                                 "J† existe ocorrància de Nota Fiscal de Retorno com a chave informada.").
        APPLY "entry" TO fi-estab IN FRAME fPage2.
        RETURN ERROR.
    END.
    FIND FIRST docum-est WHERE 
               docum-est.cod-estabel  = INPUT FRAME fPage2 fi-estab  AND
               docum-est.serie-docto  = INPUT FRAME fPage2 fi-serie  AND 
               docum-est.nro-docto    = INPUT FRAME fPage2 fi-docum  AND
               docum-est.cod-emitente = INPUT FRAME fPage2 fi-fornec AND
               docum-est.nat-operacao = INPUT FRAME fPage2 fi-nat-serv NO-LOCK NO-ERROR.
    IF AVAIL docum-est THEN DO:
        RUN setFolder IN hFolder (INPUT 1).       
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Nota Fiscal de Serviáo j† existe!" + "~~" + 
                                 "J† existe ocorrància de Nota Fiscal de Serviáo com a chave informada.").
        APPLY "entry" TO fi-estab IN FRAME fPage2.
        RETURN ERROR.
    END.    
    /*Natureza Retorno*/
    FIND FIRST natur-oper WHERE
               natur-oper.nat-operacao = INPUT FRAME fpage2 fi-nat-retorno NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper THEN DO:
       RUN setFolder IN hFolder (INPUT 1).
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 2,
                          INPUT "Natureza Retorno").
       APPLY "entry" TO fi-nat-retorno IN FRAME fPage2.
       RETURN ERROR.
    END.
    /*Natureza Serviáo*/
    FIND FIRST natur-oper WHERE
               natur-oper.nat-operacao = INPUT FRAME fpage2 fi-nat-serv NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper THEN DO:
       RUN setFolder IN hFolder (INPUT 1).
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 2,
                          INPUT "Natureza Serviáo").
       APPLY "entry" TO fi-nat-serv IN FRAME fPage2.
       RETURN ERROR.
    END.
    /*Pedido*/
    FIND FIRST pedido-compr WHERE
               pedido-compr.num-pedido = INPUT FRAME fPage2 fi-pedido NO-LOCK NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 6363,
                           INPUT "").
        APPLY "entry" TO fi-pedido IN FRAME fPage2.
        RETURN ERROR.
    END.
    ELSE DO:
        IF CAN-FIND (FIRST ordem-compra WHERE
                           ordem-compra.num-pedido = INPUT FRAME fPage2 fi-pedido AND 
                           ordem-compra.situacao  <> 2 NO-LOCK) THEN DO:
            RUN setFolder IN hFolder (INPUT 1).
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 7351,
                               INPUT "").
            APPLY "entry" TO fi-pedido IN FRAME fPage2.
            RETURN ERROR.
        END.
    END.
    /*Ordem Produá∆o*/
    FIND FIRST ord-prod WHERE    
               ord-prod.nr-ord-prod = INPUT FRAME fpage2 fi-ord-prod NO-LOCK NO-ERROR.
    IF NOT AVAIL ord-prod THEN DO:
       RUN setFolder IN hFolder (INPUT 1).
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 2,
                          INPUT "Ordem Produá∆o").
       APPLY "entry" TO fi-ord-prod IN FRAME fPage2.
       RETURN ERROR.
    END.
    ELSE DO:
        IF ord-prod.estado > 6 THEN DO:
            RUN setFolder IN hFolder (INPUT 1).
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Ordem de Produá∆o n∆o pode estar 'Terminada' ou 'Finalizada'.").
            APPLY "entry" TO fi-ord-prod IN FRAME fPage2.
            RETURN ERROR.
        END.

        FIND FIRST lin-prod WHERE
                   lin-prod.cod-estabel = ord-prod.cod-estabel AND
                   lin-prod.nr-linha    = ord-prod.nr-linha NO-LOCK NO-ERROR.
        IF AVAIL lin-prod AND lin-prod.sum-requis <> 2 THEN DO:
            RUN setFolder IN hFolder (INPUT 1).
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 18549,
                               INPUT "Linha de Produá∆o da Ordem de Produá∆o").
            APPLY "entry" TO fi-ord-prod IN FRAME fPage2.
            RETURN ERROR.
        END.
    END.

    FIND FIRST ordem-compra WHERE
               ordem-compra.num-pedido = INPUT FRAME fPage2 fi-pedido
               NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra AND
             ordem-compra.it-codigo <> ord-prod.it-codigo    
    THEN DO:
       RUN setFolder IN hFolder (INPUT 1).
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 17006,
                          INPUT "Itens diferentes.~~Item da Ordem de Produá∆o diferente do item da Ordem de Compra.").
       APPLY "entry" TO fi-ord-prod IN FRAME fPage2.
       RETURN ERROR.
    END.

    /*Data Transaá∆o*/
    IF INPUT FRAME fPage2 fi-data-trans > TODAY THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 29562,
                           INPUT "Transaá∆o n∆o").
        APPLY "entry" TO fi-data-trans IN FRAME fPage2.
        RETURN ERROR.    
    END.
    /*Dep¢sito*/
    FIND FIRST deposito WHERE 
               deposito.cod-dep = INPUT FRAME fPage2 fi-depo-retorno NO-LOCK NO-ERROR.
    IF NOT AVAIL deposito THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 530,
                           INPUT "").
        APPLY "entry" TO fi-depo-retorno IN FRAME fPage2.
        RETURN ERROR.      
    END.
    FIND FIRST deposito WHERE 
               deposito.cod-dep = INPUT FRAME fPage2 fi-depo-serv NO-LOCK NO-ERROR.
    IF NOT AVAIL deposito THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 530,
                           INPUT "").
        APPLY "entry" TO fi-depo-serv IN FRAME fPage2.
        RETURN ERROR.      
    END. 

    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           .
    
    IF tt-param.destino = 1 
    THEN 
        ASSIGN tt-param.arquivo = "":U.
    ELSE IF  tt-param.destino = 2 
        THEN ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
         ELSE DO:
            IF OPSYS = "UNIX" THEN
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-seg-usuario + "/":U + c-programa-mg97 + ".tmp":U.
            ELSE
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
         END.

    ASSIGN tt-param.arquivo = REPLACE(tt-param.arquivo,"\":U,"/":U).

    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    assign tt-param.cod-estabel       = INPUT FRAME fPage2 fi-estab
           tt-param.serie             = INPUT FRAME fPage2 fi-serie
           tt-param.nro-docto         = INPUT FRAME fPage2 fi-docum
           tt-param.nat-retorno       = INPUT FRAME fPage2 fi-nat-retorno
           tt-param.nat-servico       = INPUT FRAME fPage2 fi-nat-serv
           tt-param.num-pedido        = INPUT FRAME fPage2 fi-pedido
           tt-param.nr-ord-prod       = INPUT FRAME fPage2 fi-ord-prod
           tt-param.dt-trans          = INPUT FRAME fPage2 fi-data-trans
           tt-param.cod-depos-ret     = INPUT FRAME fPage2 fi-depo-retorno
           tt-param.cod-depos-serv    = INPUT FRAME fPage2 fi-depo-serv
           tt-param.cod-fornec        = INPUT FRAME fPage2 fi-fornec
           tt-param.it-codigo         = INPUT FRAME fPage2 fi-item
           tt-param.qtd               = INPUT FRAME fPage2 fi-quant
           tt-param.cod-modalid-frete = INPUT FRAME fPage2 fi-cod-modalid-frete.
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/rep/esrep031rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

