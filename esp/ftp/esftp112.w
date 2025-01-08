&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp112 2.00.00.032 } /*** 010032 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esftp112 MFT}
&ENDIF

/*------------------------------------------------------------------------

  File: 
  Description: 
  Input Parameters:     <none>
  Output Parameters:    <none>
  Author: 
  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */
{cdp/cdcfgdis.i}
/* Temporary Table Definitions ---                                      */


{esp/ftp/esftp112.i} /* Definiá∆o da tt-param do esftp112rp */

define temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-inf-gerais AS CHARACTER FORMAT "X(26)":U INITIAL "Informaá‰es Complementares" 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE VARIABLE c-preparador AS CHARACTER FORMAT "X(12)":U 
     LABEL "Preparador" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE da-saida AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Sa°da" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-vencto-icms AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento ICMS" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-vencto-ipi AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento IPI" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-vencto-iss AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento ISS" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 5.92.

DEFINE VARIABLE l-b2b AS LOGICAL INITIAL no 
     LABEL "Business-to-Business" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE BUTTON bt-pesquisa 
     IMAGE-UP FILE "image/im-joi.bmp":U
     LABEL "Busca Arquivo" 
     SIZE 4.14 BY 1.13.

DEFINE VARIABLE c-arquivo-import AS CHARACTER FORMAT "x(100)":U 
     LABEL "Arquivo Importaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fim AS CHARACTER FORMAT "x(16)":U INITIAL "9999999999999999" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-ini AS CHARACTER FORMAT "x(16)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-atual AS CHARACTER FORMAT "X(18)":U INITIAL "Tipo de Movimento" 
      VIEW-AS TEXT 
     SIZE 18.14 BY .67 NO-UNDO.

DEFINE VARIABLE da-emissao-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-emissao-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE tipo-atual AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Atualiza", 1,
"Desatualiza", 2
     SIZE 47 BY 1.08 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.42.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74.43 BY 9.63.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.72 BY 11.29
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-par
     da-saida AT ROW 2 COL 31.57 COLON-ALIGNED
     l-b2b AT ROW 2.21 COL 49.72
     da-vencto-ipi AT ROW 3 COL 31.57 COLON-ALIGNED
     da-vencto-icms AT ROW 4 COL 31.57 COLON-ALIGNED
     da-vencto-iss AT ROW 5 COL 31.57 COLON-ALIGNED
     c-preparador AT ROW 6 COL 31.57 COLON-ALIGNED
     c-inf-gerais AT ROW 1 COL 2.57 NO-LABEL
     RECT-12 AT ROW 1.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.88
         SIZE 75 BY 10.13.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
     tipo-atual AT ROW 1.75 COL 17 NO-LABEL WIDGET-ID 8
     da-emissao-ini AT ROW 3.25 COL 21 COLON-ALIGNED
     da-emissao-fim AT ROW 3.25 COL 48 COLON-ALIGNED NO-LABEL
     c-estabel-ini AT ROW 4.25 COL 21 COLON-ALIGNED HELP
          ""
          LABEL "Estab":R7
     c-estabel-fim AT ROW 4.25 COL 48 COLON-ALIGNED HELP
          "" NO-LABEL
     c-serie-ini AT ROW 5.25 COL 21 COLON-ALIGNED
     c-serie-fim AT ROW 5.25 COL 48.29 COLON-ALIGNED NO-LABEL
     c-nr-nota-ini AT ROW 6.25 COL 21 COLON-ALIGNED
     c-nr-nota-fim AT ROW 6.25 COL 48.29 COLON-ALIGNED NO-LABEL
     bt-pesquisa AT ROW 7.5 COL 71 WIDGET-ID 24
     c-arquivo-import AT ROW 7.75 COL 21 COLON-ALIGNED WIDGET-ID 2
     c-tipo-atual AT ROW 1.25 COL 2.14 NO-LABEL WIDGET-ID 4
     "Layout - ESTABELECIMENTO~;SERIE~;NOTA FISCAL" VIEW-AS TEXT
          SIZE 70 BY .75 AT ROW 10 COL 3 WIDGET-ID 28
     "Quando informado o arquivo os campos de seleá∆o acima ser∆o desconsiderados." VIEW-AS TEXT
          SIZE 75 BY .75 AT ROW 9 COL 75 RIGHT-ALIGNED WIDGET-ID 26
          FGCOLOR 9 FONT 2
     IMAGE-1 AT ROW 3.42 COL 42
     IMAGE-15 AT ROW 5.42 COL 42
     IMAGE-16 AT ROW 6.42 COL 46.86
     IMAGE-17 AT ROW 6.42 COL 42
     IMAGE-2 AT ROW 3.42 COL 46.86
     IMAGE-3 AT ROW 4.46 COL 42
     IMAGE-4 AT ROW 4.42 COL 46.86
     IMAGE-9 AT ROW 5.42 COL 46.86
     RECT-13 AT ROW 1.5 COL 1
     RECT-10 AT ROW 1.58 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 75 BY 10.13.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Atualizaá∆o do Estoque e Pedidos"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN c-inf-gerais IN FRAME f-pg-par
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX l-b2b IN FRAME f-pg-par
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-estabel-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-estabel-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-tipo-atual IN FRAME f-pg-sel
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TEXT-LITERAL "Quando informado o arquivo os campos de seleá∆o acima ser∆o desconsiderados."
          SIZE 75 BY .75 AT ROW 9 COL 75 RIGHT-ALIGNED                  */

/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Atualizaá∆o do Estoque e Pedidos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Atualizaá∆o do Estoque e Pedidos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa C-Win
ON CHOOSE OF bt-pesquisa IN FRAME f-pg-sel /* Busca Arquivo */
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign c-arquivo-import = c-arq-conv.
        display c-arquivo-import with frame f-pg-sel.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estabel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-ini C-Win
ON LEAVE OF c-estabel-ini IN FRAME f-pg-sel /* Estab */
DO:
    IF tipo-atual:SCREEN-VALUE IN FRAME f-pg-sel = "2" THEN DO:
       ASSIGN  
              da-emissao-fim  =  date(da-emissao-ini:SCREEN-VALUE IN FRAME f-pg-sel)
              c-estabel-fim   = c-estabel-ini:SCREEN-VALUE IN FRAME f-pg-sel   
              c-serie-fim     = c-serie-ini:SCREEN-VALUE IN FRAME f-pg-sel     
              c-nr-nota-fim   = c-nr-nota-ini:SCREEN-VALUE IN FRAME f-pg-sel   .
                             
      DISPLAY  da-emissao-fim  
               c-estabel-fim   
               c-serie-fim     
               c-nr-nota-fim   
               
          WITH FRAME F-PG-SEL .
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-nota-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-nota-ini C-Win
ON LEAVE OF c-nr-nota-ini IN FRAME f-pg-sel /* Nota Fiscal */
DO:
    IF tipo-atual:SCREEN-VALUE IN FRAME f-pg-sel = "2" THEN DO:
       ASSIGN  
              da-emissao-fim  =  date(da-emissao-ini:SCREEN-VALUE IN FRAME f-pg-sel)
              c-estabel-fim   = c-estabel-ini:SCREEN-VALUE IN FRAME f-pg-sel   
              c-serie-fim     = c-serie-ini:SCREEN-VALUE IN FRAME f-pg-sel     
              c-nr-nota-fim   = c-nr-nota-ini:SCREEN-VALUE IN FRAME f-pg-sel   .

      DISPLAY  da-emissao-fim  
               c-estabel-fim   
               c-serie-fim     
               c-nr-nota-fim   
       
          WITH FRAME F-PG-SEL .
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-ini C-Win
ON LEAVE OF c-serie-ini IN FRAME f-pg-sel /* SÇrie */
DO:
    IF tipo-atual:SCREEN-VALUE IN FRAME f-pg-sel = "2" THEN DO:
       ASSIGN  
              da-emissao-fim  =  date(da-emissao-ini:SCREEN-VALUE IN FRAME f-pg-sel)
              c-estabel-fim   = c-estabel-ini:SCREEN-VALUE IN FRAME f-pg-sel   
              c-serie-fim     = c-serie-ini:SCREEN-VALUE IN FRAME f-pg-sel     
              c-nr-nota-fim   = c-nr-nota-ini:SCREEN-VALUE IN FRAME f-pg-sel   .

      DISPLAY  da-emissao-fim  
               c-estabel-fim   
               c-serie-fim     
               c-nr-nota-fim   
      
          WITH FRAME F-PG-SEL .
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-emissao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-emissao-ini C-Win
ON LEAVE OF da-emissao-ini IN FRAME f-pg-sel /* Data de Emiss∆o */
DO:
    IF tipo-atual:SCREEN-VALUE IN FRAME f-pg-sel = "2" THEN DO:
       ASSIGN  
              da-emissao-fim  =  date(da-emissao-ini:SCREEN-VALUE IN FRAME f-pg-sel)
              c-estabel-fim   = c-estabel-ini:SCREEN-VALUE IN FRAME f-pg-sel   
              c-serie-fim     = c-serie-ini:SCREEN-VALUE IN FRAME f-pg-sel     
              c-nr-nota-fim   = c-nr-nota-ini:SCREEN-VALUE IN FRAME f-pg-sel   .

      DISPLAY  da-emissao-fim  
               c-estabel-fim   
               c-serie-fim     
               c-nr-nota-fim   
          WITH FRAME F-PG-SEL .
  END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
 run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME tipo-atual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tipo-atual C-Win
ON VALUE-CHANGED OF tipo-atual IN FRAME f-pg-sel
DO:
    IF tipo-atual:SCREEN-VALUE IN FRAME f-pg-sel = "2" THEN DO:
        ASSIGN  da-emissao-ini  = 12/31/2999
                da-emissao-fim  = 12/31/2999
                c-estabel-ini   = "999"
                c-estabel-fim   = "999"
                c-serie-ini     = "999"
                c-serie-fim     = "999"
                c-nr-nota-ini   = "ZZZZZZZ"
                c-nr-nota-fim   = "ZZZZZZZ".
        DISPLAY  da-emissao-ini  
                 da-emissao-fim  
                 c-estabel-ini   
                 c-estabel-fim   
                 c-serie-ini     
                 c-serie-fim     
                 c-nr-nota-ini   
                 c-nr-nota-fim   
                 
            WITH FRAME F-PG-SEL .
        ENABLE
               da-emissao-ini  c-estabel-ini  c-serie-ini 
                c-nr-nota-ini  
                c-arquivo-import 
            WITH FRAME f-pg-sel .
        DISABLE
                da-emissao-fim  c-estabel-fim 
               c-serie-fim  c-nr-nota-fim 
             
            WITH FRAME f-pg-sel .

    END.
    ELSE DO:
        ASSIGN  da-emissao-ini  = DATE(MONTH(TODAY), 01, YEAR(TODAY))
                da-emissao-fim  = 12/31/2999
                c-estabel-ini   = ""
                c-estabel-fim   = "999"
                c-serie-ini     = ""
                c-serie-fim     = "999"
                c-nr-nota-ini   = ""
                c-nr-nota-fim   = "ZZZZZZZ".
                

        DISPLAY  da-emissao-ini  
                 da-emissao-fim  
                 c-estabel-ini   
                 c-estabel-fim   
                 c-serie-ini     
                 c-serie-fim     
                 c-nr-nota-ini   
                 c-nr-nota-fim   
                 
            WITH FRAME F-PG-SEL .

        ENABLE
               da-emissao-ini  c-estabel-ini  c-serie-ini 
                c-nr-nota-ini  
                c-arquivo-import 
            WITH FRAME f-pg-sel .
        ENABLE
                da-emissao-fim  c-estabel-fim 
               c-serie-fim  c-nr-nota-fim 
               
            WITH FRAME f-pg-sel .

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESFTP112" "2.00.00.001"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.
    RUN enable_UI.

/*   &if defined (bf_b2b) &then           
 *        assign  l-b2b:visible  in frame f-pg-par = yes
 *                l-b2b:sensitive in frame f-pg-par = yes .
 *    &endif .            
 */

    {include/i-rpmbl.i}
    assign da-vencto-icms:screen-value in frame f-pg-par = string(today)
           da-vencto-ipi:screen-value  in frame f-pg-par = string(today)
           da-vencto-iss:screen-value  in frame f-pg-par = string(today)
           da-emissao-ini:screen-value in frame f-pg-sel = string(today)
           da-emissao-fim:screen-value in frame f-pg-sel = string(today)
           c-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".

    {utp/ut-liter.i Estabelecimento * R}
    ASSIGN c-estabel-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE).

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY tipo-atual da-emissao-ini da-emissao-fim c-estabel-ini c-estabel-fim 
          c-serie-ini c-serie-fim c-nr-nota-ini c-nr-nota-fim c-arquivo-import 
          c-tipo-atual 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-9 
         RECT-13 RECT-10 tipo-atual da-emissao-ini da-emissao-fim c-estabel-ini 
         c-estabel-fim c-serie-ini c-serie-fim c-nr-nota-ini c-nr-nota-fim 
         bt-pesquisa c-arquivo-import 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY da-saida da-vencto-ipi da-vencto-icms da-vencto-iss c-preparador 
          c-inf-gerais 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-12 da-saida l-b2b da-vencto-ipi da-vencto-icms da-vencto-iss 
         c-preparador 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTParam C-Win 
PROCEDURE getTTParam :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAM TABLE FOR tt-param.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 &IF defined(bf_dis_versao_ems) &Then
  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.02" &THEN
   run utp/ut-neog.p.
   if return-value = "OK" then
      assign l-b2b:visible   in frame f-pg-par = yes
             l-b2b:sensitive in frame f-pg-par = yes
             l-b2b:checked   in frame f-pg-par = yes.
   ELSE
      assign l-b2b:visible   in frame f-pg-par = no
             l-b2b:sensitive in frame f-pg-par = no
             l-b2b:checked   in frame f-pg-par = no.
  &ENDIF
 &ELSE
   assign l-b2b:visible   in frame f-pg-par = no
          l-b2b:sensitive in frame f-pg-par = no
          l-b2b:checked   in frame f-pg-par = no.
 &ENDIF        
 apply "MOUSE-SELECT-CLICK" to im-pg-sel in frame f-relat.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.                   
            return error.
        end.
    end.

    /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    

    FOR EACH tt-param:
        DELETE tt-param.
    END.
    create tt-param.
    assign tt-param.usuario           = c-seg-usuario
           tt-param.destino           = input frame f-pg-imp rs-destino
           tt-param.tipo-atual        = input frame f-pg-sel tipo-atual
           tt-param.c-desc-tipo-atual = entry((tt-param.tipo-atual - 1) * 2 + 1, 
                                            tipo-atual:radio-buttons in frame f-pg-sel)
           tt-param.da-emissao-ini    = input frame f-pg-sel da-emissao-ini
           tt-param.da-emissao-fim    = input frame f-pg-sel da-emissao-fim
           tt-param.da-saida          = input frame f-pg-par da-saida
           tt-param.da-vencto-icms    = input frame f-pg-par da-vencto-icms
           tt-param.da-vencto-ipi     = input frame f-pg-par da-vencto-ipi
           tt-param.da-vencto-iss     = input frame f-pg-par da-vencto-iss
           tt-param.c-estabel-ini     = input frame f-pg-sel c-estabel-ini
           tt-param.c-estabel-fim     = input frame f-pg-sel c-estabel-fim
           tt-param.c-serie-ini       = input frame f-pg-sel c-serie-ini
           tt-param.c-serie-fim       = input frame f-pg-sel c-serie-fim
           tt-param.c-nr-nota-ini     = input frame f-pg-sel c-nr-nota-ini
           tt-param.c-nr-nota-fim     = input frame f-pg-sel c-nr-nota-fim
           tt-param.de-embarque-ini   = 0
           tt-param.de-embarque-fim   = 99999999
           tt-param.c-preparador      = input frame f-pg-par c-preparador
           tt-param.c-arquivo-import  = input frame f-pg-sel c-arquivo-import
           tt-param.l-disp-men        = no.
           &IF defined(bf_dis_versao_ems) &Then
              &IF "{&BF_DIS_VERSAO_EMS}" >= "2.02" &THEN
                 run utp/ut-neog.p.
                 if return-value = "OK" then
                     assign tt-param.l-b2b = input frame f-pg-par l-b2b.
              &ENDIF
           &ENDIF        

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

/*         MESSAGE tt-param.usuario                      SKIP                                                                                 */
/*                 tt-param.destino                      SKIP                                                                                 */
/*                 tt-param.tipo-atual                   SKIP                                                                                 */
/*                 tt-param.c-desc-tipo-atua                  SKIP                                                                            */
/*                 tt-param.da-emissao-ini                              SKIP                                                                  */
/*                 tt-param.da-emissao-fim                                   SKIP                                                             */
/*                 tt-param.da-saida                                              SKIP                                                        */
/*                 tt-param.da-vencto-icms                                             SKIP                                                   */
/*                 tt-param.da-vencto-ipi                                                   SKIP                                              */
/*                 tt-param.da-vencto-iss                                                        SKIP                                         */
/*                 tt-param.c-estabel-ini                                                             SKIP                                    */
/*                 tt-param.c-estabel-fim                                                                  SKIP                               */
/*                 tt-param.c-serie-ini                                                                         SKIP                          */
/*                 tt-param.c-serie-fim                                                                              SKIP                     */
/*                 tt-param.c-nr-nota-ini                                                                                 SKIP                */
/*                 tt-param.c-nr-nota-fim                                                                                      SKIP           */
/*                 tt-param.de-embarque-ini                                                                                         SKIP      */
/*                 tt-param.de-embarque-fim                                                                                              SKIP */
/*                 tt-param.c-preparador     SKIP                                                                                             */
/*                 tt-param.c-arquivo-import      SKIP                                                                                        */
/*                 tt-param.l-disp-men                 SKIP                                                                                   */
/*                                                                                                                                            */
/*                                                                                                                                            */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                             */
    /*Chamada EPC*/
    IF c-nom-prog-upc-mg97 <> "" THEN
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AtualizaTTParam", 
                                        INPUT "CONTAINER",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "",
                                        INPUT ?).
    FIND FIRST tt-param NO-LOCK NO-ERROR.
    
    /*Fim EPC*/
    /* Limpar o arquivo de saida no diretorio padrao */
    if  tt-param.destino <> 1                                 /* Destino Arquivo  */
    and rs-execucao:screen-value in frame f-pg-imp = "1" then /* Execucao On line */
    do:
        output to value(tt-param.arquivo). 
        output close.
    end.    

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/ftp/esftp112rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTParam C-Win 
PROCEDURE setTTParam :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAM TABLE FOR tt-param.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

