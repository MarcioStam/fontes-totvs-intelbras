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
{include/i-prgvrs.i espdp081 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp081
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Detalhes

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   c-arq-imp bt-pesquisa r-seleciona-tipo
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-pedido AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.

DEFINE TEMP-TABLE tt-imp-valor NO-UNDO LIKE imp-valor
    FIELD cod-ajuste      AS CHARACTER
    FIELD cod-ajuste-sped AS CHARACTER.

DEFINE TEMP-TABLE tt-apur-imposto NO-UNDO LIKE apur-imposto.

DEFINE TEMP-TABLE tt-imposto-guia NO-UNDO LIKE imposto-guia
    FIELD c-cod-ajuste       AS CHARACTER
    FIELD c-receita          AS CHARACTER
    FIELD c-cod-proces       AS CHARACTER
    FIELD cb-idi-orig-proces AS CHARACTER
    FIELD c-des-proces       AS CHARACTER
    FIELD c-text-obs         AS CHARACTER.

DEFINE BUFFER b-imposto-guia FOR imposto-guia.
DEFINE TEMP-TABLE tt-dwf-text-msg-fisc NO-UNDO LIKE dwf-text-msg-fisc
    FIELD r-Rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 145 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 173 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-pesquisa 
     IMAGE-UP FILE "image/im-joi.bmp":U
     LABEL "Busca Arquivo" 
     SIZE 4.14 BY 1.13.

DEFINE VARIABLE c-arq-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo de Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 73.14 BY .79 NO-UNDO.

DEFINE VARIABLE r-seleciona-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Valores", 1,
"Recolhimento", 2
     SIZE 45 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image/valores_espdp081.jpg":U
     SIZE 100 BY 3.5.

DEFINE IMAGE IMAGE-4
     FILENAME "image/recolhimento_espdp081.jpg":U
     SIZE 144 BY 3.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 133 BY 5.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 148 BY 5.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.17 COL 157 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 161 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 165 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 169 HELP
          "Ajuda"
     btOK AT ROW 21.38 COL 3.29
     btCancel AT ROW 21.38 COL 14.29
     btHelp2 AT ROW 21.38 COL 132.29
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 21.17 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 173.14 BY 24.88
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     bt-pesquisa AT ROW 1.13 COL 92.72 WIDGET-ID 22
     c-arq-imp AT ROW 1.29 COL 16.57 COLON-ALIGNED WIDGET-ID 12
     r-seleciona-tipo AT ROW 2.5 COL 18 NO-LABEL WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 2.5
         SIZE 151.72 BY 18.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME Frame-Instrucoes
     "Retirar os cabe‡alhos antes de importar." VIEW-AS TEXT
          SIZE 39 BY .88 AT ROW 3.13 COL 50.43 WIDGET-ID 40
     "Retirar os cabe‡alhos antes de importar." VIEW-AS TEXT
          SIZE 39 BY .88 AT ROW 9.04 COL 50.57 WIDGET-ID 42
     "Lay-out do arquivo para Recolhimento:" VIEW-AS TEXT
          SIZE 41 BY .83 AT ROW 9 COL 3 WIDGET-ID 34
     "Os arquivos deverÆo ser em formato .csv" VIEW-AS TEXT
          SIZE 42 BY 1 AT ROW 1.17 COL 3.14 WIDGET-ID 4
     "Lay-out do arquivo para Valores:" VIEW-AS TEXT
          SIZE 41 BY .83 AT ROW 3.17 COL 3.14 WIDGET-ID 6
     RECT-12 AT ROW 2.5 COL 2 WIDGET-ID 26
     RECT-13 AT ROW 8.75 COL 2 WIDGET-ID 32
     IMAGE-3 AT ROW 4.25 COL 6 WIDGET-ID 36
     IMAGE-4 AT ROW 10.25 COL 5 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 4.17
         SIZE 149.86 BY 15.08
         TITLE "Instru‡äes" WIDGET-ID 200.


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
         HEIGHT             = 21.58
         WIDTH              = 152.72
         MAX-HEIGHT         = 27.04
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.04
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME Frame-Instrucoes:FRAME = FRAME fPage1:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME Frame-Instrucoes:MOVE-AFTER-TAB-ITEM (r-seleciona-tipo:HANDLE IN FRAME fPage1)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME Frame-Instrucoes
                                                                        */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa wWindow
ON CHOOSE OF bt-pesquisa IN FRAME fPage1 /* Busca Arquivo */
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
        assign c-arq-imp = c-arq-conv.
        display c-arq-imp with frame fpage1.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF r-seleciona-tipo:SCREEN-VALUE IN FRAME fPage1 = "1" THEN
        RUN pi-importar-valores.
    ELSE
       RUN pi-importar-recolhimento.
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

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importar-recolhimento wWindow 
PROCEDURE pi-importar-recolhimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-linha         AS CHARACTER          NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE             NO-UNDO.
DEFINE VARIABLE i-conta-erro    AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE l-create-msg    AS LOGICAL            NO-UNDO.
DEFINE VARIABLE c-cod-obs       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE h-bofi106       AS HANDLE             NO-UNDO.
    OUTPUT TO c:\temp\log_espdp081.csv.
    
    
    INPUT FROM VALUE(c-arq-imp) CONVERT SOURCE "iso8859-1".
    
    RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
    RUN pi-inicializar IN h-acomp("Importa‡Æo de informa‡äes...").
    
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Importando dados do arquivo ...").
        
        IF  c-linha = "" THEN
            LEAVE.
         
        FIND FIRST apur-imposto
             WHERE apur-imposto.cod-estabel =         TRIM(ENTRY(1, c-linha, ";")) /*Estabelecimento da planilha*/ 
               AND apur-imposto.tp-imposto  = INTEGER(TRIM(ENTRY(2, c-linha, ";"))) /*Tipo imposto da planilha,*/  
               AND apur-imposto.dt-apur-ini =    DATE(TRIM(ENTRY(3, c-linha, ";"))) /*Data inicial planilha*/
               AND apur-imposto.dt-apur-fim =    DATE(TRIM(ENTRY(4, c-linha, ";"))) /*Data final planilha*/ NO-LOCK NO-ERROR.
        IF AVAIL apur-imposto THEN DO:
            
            IF apur-imposto.tp-imposto = 1 OR apur-imposto.tp-imposto = 2 THEN DO:

                CREATE tt-imposto-guia.
        
                FOR LAST b-imposto-guia 
                    WHERE b-imposto-guia.cod-estabel  = apur-imposto.cod-estabel 
                      AND b-imposto-guia.tp-imposto   = apur-imposto.tp-imposto 
                      AND b-imposto-guia.dt-apur-fim  = apur-imposto.dt-apur-fim
                      AND b-imposto-guia.dt-apur-ini  = apur-imposto.dt-apur-ini NO-LOCK
                    BREAK BY b-imposto-guia.nr-sequencia:
                END.
                /*
                IF AVAIL b-imposto-guia THEN DO:
                    ASSIGN tt-imposto-guia.nr-sequencia = b-imposto-guia.nr-sequencia + 1.
                END.
                ELSE DO:
                    ASSIGN tt-imposto-guia.nr-sequencia = 1 NO-ERROR.
                END.
                */
                
                ASSIGN tt-imposto-guia.cod-estabel        =         TRIM(ENTRY(1, c-linha, ";")) 
                       tt-imposto-guia.tp-imposto         = INTEGER(TRIM(ENTRY(2, c-linha, ";")))  
                       tt-imposto-guia.dt-apur-ini        =    DATE(TRIM(ENTRY(3, c-linha, ";"))) 
                       tt-imposto-guia.dt-apur-fim        =    DATE(TRIM(ENTRY(4, c-linha, ";"))) 
                       tt-imposto-guia.nr-guia            = DECIMAL(TRIM(ENTRY(5, c-linha, ";"))) 
                       tt-imposto-guia.dt-guia            =    DATE(TRIM(ENTRY(6, c-linha, ";"))) 
                       tt-imposto-guia.vl-guia            = DECIMAL(TRIM(ENTRY(7, c-linha, ";")))  
                       tt-imposto-guia.org-arrecad        =         TRIM(ENTRY(8, c-linha, ";"))  
                       tt-imposto-guia.c-cod-ajuste       =         TRIM(ENTRY(9, c-linha, ";")) 
                       tt-imposto-guia.c-receita          =         TRIM(ENTRY(10, c-linha, ";")) 
                       tt-imposto-guia.c-cod-proces       =         TRIM(ENTRY(11, c-linha, ";")) 
                       tt-imposto-guia.cb-idi-orig-proces =         TRIM(ENTRY(12, c-linha, ";")) 
                       tt-imposto-guia.c-des-proces       =         TRIM(ENTRY(13, c-linha, ";"))
                       tt-imposto-guia.c-text-obs         =         TRIM(ENTRY(14, c-linha, ";"))
                       tt-imposto-guia.nr-sequencia       = tt-imposto-guia.nr-guia.
                
                PUT UNFORMATTED "Leitura do Arquivo:"      ";"
                                tt-imposto-guia.nr-sequencia ";"
                                tt-imposto-guia.cod-estabel ";"      
                                tt-imposto-guia.tp-imposto  ";"      
                                tt-imposto-guia.dt-apur-ini ";"      
                                tt-imposto-guia.dt-apur-fim ";"      
                                tt-imposto-guia.nr-guia     ";"      
                                tt-imposto-guia.dt-guia     ";"      
                                tt-imposto-guia.vl-guia     ";"      
                                tt-imposto-guia.org-arrecad ";"      
                                tt-imposto-guia.c-cod-ajuste ";"     
                                tt-imposto-guia.c-receita    ";"     
                                tt-imposto-guia.c-cod-proces ";"     
                                tt-imposto-guia.cb-idi-orig-proces ";"
                                tt-imposto-guia.c-des-proces ";"     
                                tt-imposto-guia.c-text-obs SKIP.

            END. /* IF apur-imposto.tp-imposto = 1 OR apur-imposto.tp-imposto = 2 THEN DO: */

        END. /* IF AVAIL apur-imposto THEN DO: */

    END.
    INPUT CLOSE.
    
    run pi-finalizar in h-acomp.
    
    PUT UNFORMATTED SKIP SKIP.
    ASSIGN  l-create-msg = NO.

    FOR EACH tt-imposto-guia NO-LOCK:

/*         MESSAGE tt-imposto-guia.cod-estabel        */
/*                 tt-imposto-guia.tp-imposto         */
/*                 tt-imposto-guia.dt-apur-ini        */
/*                 tt-imposto-guia.dt-apur-fim        */
/*                 tt-imposto-guia.nr-guia            */
/*                 tt-imposto-guia.dt-guia            */
/*                 tt-imposto-guia.vl-guia            */
/*                 tt-imposto-guia.org-arrecad        */
/*                 tt-imposto-guia.c-cod-ajuste       */
/*                 tt-imposto-guia.c-receita          */
/*                 tt-imposto-guia.c-cod-proces       */
/*                 tt-imposto-guia.cb-idi-orig-proces */
/*                 tt-imposto-guia.c-des-proces       */
/*                 tt-imposto-guia.c-text-obs         */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.     */

        IF CAN-FIND(FIRST imposto-guia
                    WHERE imposto-guia.cod-estabel  = tt-imposto-guia.cod-estabel
                      AND imposto-guia.tp-imposto   = tt-imposto-guia.tp-imposto
                      AND imposto-guia.dt-apur-ini  = tt-imposto-guia.dt-apur-ini
                      AND imposto-guia.dt-apur-fim  = tt-imposto-guia.dt-apur-fim
                      AND imposto-guia.nr-guia      = tt-imposto-guia.nr-guia NO-LOCK) THEN do:
            PUT UNFORMATTED "Recolhimento ja cadastrado para Nr Guia: " tt-imposto-guia.nr-guia SKIP.
            ASSIGN i-conta-erro = i-conta-erro + 1.
            NEXT.
        END.
    
        CREATE imposto-guia.
        ASSIGN imposto-guia.cod-estabel            = tt-imposto-guia.cod-estabel  
               imposto-guia.dt-apur-ini            = tt-imposto-guia.dt-apur-ini  
               imposto-guia.dt-apur-fim            = tt-imposto-guia.dt-apur-fim  
               imposto-guia.tp-imposto             = tt-imposto-guia.tp-imposto
               SUBSTRING(imposto-guia.char-1,1,10) = tt-imposto-guia.c-cod-ajuste
               SUBSTRING(imposto-guia.char-2,1,10) = tt-imposto-guia.c-receita
               imposto-guia.nr-guia                = tt-imposto-guia.nr-guia
               imposto-guia.vl-guia                = tt-imposto-guia.vl-guia
               imposto-guia.org-arrecad            = tt-imposto-guia.org-arrecad
               imposto-guia.dt-guia                = tt-imposto-guia.dt-guia   
               imposto-guia.nr-sequencia           = tt-imposto-guia.nr-sequencia
               c-cod-obs                           = "" .
         
        /**** Mensagem ******/
        EMPTY TEMP-TABLE tt-dwf-text-msg-fisc.

        IF NOT VALID-HANDLE(h-bofi106) THEN
          RUN fibo/bofi106.p PERSISTENT SET h-bofi106.
        RUN openQueryStatic IN h-bofi106 (INPUT "ByCodDigi":U) NO-ERROR.

        IF  c-cod-obs                   = "" 
        AND tt-imposto-guia.c-text-obs <> "" THEN DO:
          RUN getLast IN h-bofi106.
          IF RETURN-VALUE = "OK":U THEN
              RUN getCharField IN h-bofi106 (INPUT "cod-msg":U,OUTPUT c-cod-obs).
          CREATE tt-dwf-text-msg-fisc.
          ASSIGN c-cod-obs = "D" + string(INT(substring(c-cod-obs,2,7)) + 1,"9999999") 
                 tt-dwf-text-msg-fisc.cod-msg        = c-cod-obs
                 tt-dwf-text-msg-fisc.dat-inic-valid = 01/01/2000
                 tt-dwf-text-msg-fisc.dat-fim-valid  = ?
                 tt-dwf-text-msg-fisc.dsl-msg        = tt-imposto-guia.c-text-obs
                 l-create-msg                        = YES.
        
        END.
        ELSE IF c-cod-obs <> "" THEN DO:
          RUN gotokey IN h-bofi106 (INPUT c-cod-obs).
          IF RETURN-VALUE = "OK" THEN DO:
              RUN getCurrent IN h-bofi106 (OUTPUT TABLE tt-dwf-text-msg-fisc).
              FIND FIRST tt-dwf-text-msg-fisc.
              IF AVAIL tt-dwf-text-msg-fisc THEN
                  ASSIGN tt-dwf-text-msg-fisc.dsl-msg = tt-imposto-guia.c-text-obs.
          END.
        END.

        IF AVAIL tt-dwf-text-msg-fisc THEN 
          RUN setRecord IN h-bofi106 (INPUT TABLE tt-dwf-text-msg-fisc).
        
/*         MESSAGE "c-cod-obs                           " c-cod-obs                            SKIP    */
/*                 "tt-imposto-guia.c-cod-ajuste        " tt-imposto-guia.c-cod-ajuste         SKIP    */
/*                 "tt-imposto-guia.c-text-obs          " tt-imposto-guia.c-text-obs           SKIP(2) */
/*                 "tt-dwf-text-msg-fisc.cod-msg        "  tt-dwf-text-msg-fisc.cod-msg        SKIP    */
/*                 "tt-dwf-text-msg-fisc.dat-inic-valid "  tt-dwf-text-msg-fisc.dat-inic-valid SKIP    */
/*                 "tt-dwf-text-msg-fisc.dat-fim-valid  "  tt-dwf-text-msg-fisc.dat-fim-valid  SKIP    */
/*                 "tt-dwf-text-msg-fisc.dsl-msg        "  tt-dwf-text-msg-fisc.dsl-msg                */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                      */

        RUN emptyRowErrors IN h-bofi106.
        
        IF RETURN-VALUE = "OK":U THEN DO:
          IF AVAIL tt-dwf-text-msg-fisc THEN 
              IF l-create-msg THEN
                  RUN createRecord IN h-bofi106.
              ELSE
                  RUN updateRecord IN h-bofi106.
        END.
        /** mensagem fim **/

        FIND FIRST dwf-apurac-impto-recolh 
             WHERE dwf-apurac-impto-recolh.cod-estab                = tt-imposto-guia.cod-estabel 
               AND dwf-apurac-impto-recolh.dat-apurac-inicial-impto = tt-imposto-guia.dt-apur-ini 
               AND dwf-apurac-impto-recolh.dat-apurac-final-impto   = tt-imposto-guia.dt-apur-fim 
               AND dwf-apurac-impto-recolh.nume-guia                = tt-imposto-guia.nr-guia
               AND dwf-apurac-impto-recolh.cod-ajust                = tt-imposto-guia.c-cod-ajuste
               AND dwf-apurac-impto-recolh.cod-uf                   = ""                          EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL dwf-apurac-impto-recolh THEN DO:
            ASSIGN dwf-apurac-impto-recolh.cod-receita              = tt-imposto-guia.c-receita
                   dwf-apurac-impto-recolh.val-livre-1              = tt-imposto-guia.tp-imposto
                   dwf-apurac-impto-recolh.dat-fim-valid            = ?                                                 
                   dwf-apurac-impto-recolh.cod-proces               = tt-imposto-guia.c-cod-proces 
                   dwf-apurac-impto-recolh.idi-orig-proces          = INT(tt-imposto-guia.cb-idi-orig-proces)
                   dwf-apurac-impto-recolh.des-proces               = tt-imposto-guia.c-des-proces
                   dwf-apurac-impto-recolh.val-ajust-apurac         = tt-imposto-guia.vl-guia      
                   dwf-apurac-impto-recolh.dat-inic-valid           = 01/01/2000 + tt-imposto-guia.nr-sequencia
                   dwf-apurac-impto-recolh.dat-vencto               = tt-imposto-guia.dt-guia  
                   dwf-apurac-impto-recolh.dat-livre-1              = tt-imposto-guia.dt-guia
                   dwf-apurac-impto-recolh.nume-guia                = tt-imposto-guia.nr-guia
                   dwf-apurac-impto-recolh.cod-impto                = IF tt-imposto-guia.tp-imposto = 1 THEN "ICMS" ELSE "IPI"
                   dwf-apurac-impto-recolh.dsl-ajust-apurac         = c-cod-obs.

        END.
        ELSE DO:
            CREATE dwf-apurac-impto-recolh.
            ASSIGN dwf-apurac-impto-recolh.cod-estab                = tt-imposto-guia.cod-estabel                          
                   dwf-apurac-impto-recolh.dat-apurac-inicial-impto = tt-imposto-guia.dt-apur-ini                          
                   dwf-apurac-impto-recolh.dat-apurac-final-impto   = tt-imposto-guia.dt-apur-fim                          
                   dwf-apurac-impto-recolh.cod-ajust                = tt-imposto-guia.c-cod-ajuste
                   dwf-apurac-impto-recolh.cod-uf                   = ""    
                   dwf-apurac-impto-recolh.cod-receita              = tt-imposto-guia.c-receita
                   dwf-apurac-impto-recolh.val-livre-1              = tt-imposto-guia.tp-imposto 
                   dwf-apurac-impto-recolh.dat-fim-valid            = ?                                                 
                   dwf-apurac-impto-recolh.cod-proces               = tt-imposto-guia.c-cod-proces 
                   dwf-apurac-impto-recolh.idi-orig-proces          = INT(tt-imposto-guia.cb-idi-orig-proces)
                   dwf-apurac-impto-recolh.des-proces               = tt-imposto-guia.c-des-proces
                   dwf-apurac-impto-recolh.val-ajust-apurac         = tt-imposto-guia.vl-guia      
                   dwf-apurac-impto-recolh.dat-inic-valid           = 01/01/2000 + tt-imposto-guia.nr-sequencia
                   dwf-apurac-impto-recolh.dat-vencto               = tt-imposto-guia.dt-guia  
                   dwf-apurac-impto-recolh.dat-livre-1              = tt-imposto-guia.dt-guia
                   dwf-apurac-impto-recolh.nume-guia                = tt-imposto-guia.nr-guia
                   dwf-apurac-impto-recolh.cod-impto                = IF tt-imposto-guia.tp-imposto = 1 THEN "ICMS" ELSE "IPI"
                   dwf-apurac-impto-recolh.dsl-ajust-apurac         = c-cod-obs.
        END.

/*         MESSAGE                                                                                                              */
/*               "dwf-apurac-impto-recolh.val-ajust-apurac             "  dwf-apurac-impto-recolh.val-ajust-apurac         SKIP */
/*               "dwf-apurac-impto-recolh.nume-guia                    "  dwf-apurac-impto-recolh.nume-guia                SKIP */
/*               "dwf-apurac-impto-recolh.idi-orig-proces              "  dwf-apurac-impto-recolh.idi-orig-proces          SKIP */
/*               "dwf-apurac-impto-recolh.dsl-ajust-apurac             "  dwf-apurac-impto-recolh.dsl-ajust-apurac         SKIP */
/*               "dwf-apurac-impto-recolh.des-proces                   "  dwf-apurac-impto-recolh.des-proces               SKIP */
/*               "dwf-apurac-impto-recolh.dat-vencto                   "  dwf-apurac-impto-recolh.dat-vencto               SKIP */
/*               "dwf-apurac-impto-recolh.dat-inic-valid               "  dwf-apurac-impto-recolh.dat-inic-valid           SKIP */
/*               "dwf-apurac-impto-recolh.dat-fim-valid                "  dwf-apurac-impto-recolh.dat-fim-valid            SKIP */
/*               "dwf-apurac-impto-recolh.dat-apurac-inicial-impto     "  dwf-apurac-impto-recolh.dat-apurac-inicial-impto SKIP */
/*               "dwf-apurac-impto-recolh.dat-apurac-final-impto       "  dwf-apurac-impto-recolh.dat-apurac-final-impto   SKIP */
/*               "dwf-apurac-impto-recolh.cod-uf                       "  dwf-apurac-impto-recolh.cod-uf                   SKIP */
/*               "dwf-apurac-impto-recolh.cod-receita                  "  dwf-apurac-impto-recolh.cod-receita              SKIP */
/*               "dwf-apurac-impto-recolh.cod-proces                   "  dwf-apurac-impto-recolh.cod-proces               SKIP */
/*               "dwf-apurac-impto-recolh.cod-impto                    "  dwf-apurac-impto-recolh.cod-impto                SKIP */
/*               "dwf-apurac-impto-recolh.cod-estab                    "  dwf-apurac-impto-recolh.cod-estab                SKIP */
/*               "dwf-apurac-impto-recolh.cod-docto-arrecadac          "  dwf-apurac-impto-recolh.cod-docto-arrecadac      SKIP */
/*               "dwf-apurac-impto-recolh.cod-ajust                    "  dwf-apurac-impto-recolh.cod-ajust                     */
/*           VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                 */

        EMPTY TEMP-TABLE tt-dwf-text-msg-fisc.

        IF VALID-HANDLE(h-bofi106) THEN
            DELETE PROCEDURE h-bofi106.

        FOR EACH RowErrors NO-LOCK:
            PUT RowErrors.ErrorNumber ' - 'RowErrors.ErrorDescription SKIP.
            ASSIGN i-conta-erro = i-conta-erro + 1.
        END.
        ASSIGN c-cod-obs = ''.
        
    END.
    
    OUTPUT CLOSE.
    
    IF i-conta-erro <> 0 THEN
        MESSAGE "Importa‡Æo conclu¡da, por‚m ocorreram erros. arquivo de LOG c:\temp\log_espdp081.csv" SKIP
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ELSE
        MESSAGE "Importa‡Æo conclu¡da com ˆxito. arquivo de LOG c:\temp\log_espdp081.csv"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    ASSIGN i-conta-erro = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importar-valores wWindow 
PROCEDURE pi-importar-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-conta-ok     AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE i-conta-erro   AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE NO-UNDO.
DEFINE VARIABLE c-linha        AS CHARACTER NO-UNDO.

OUTPUT TO c:\temp\log_espdp081.csv.

INPUT FROM VALUE(c-arq-imp) CONVERT SOURCE "iso8859-1".

RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp("Importa‡Æo de valores...").

REPEAT:
    IMPORT UNFORMATTED c-linha.
    
    RUN pi-acompanhar IN h-acomp (INPUT "Importando dados do arquivo ...").

    IF  c-linha = "" THEN
        LEAVE.
     
    FIND FIRST apur-imposto
        WHERE apur-imposto.cod-estabel =         TRIM(ENTRY(1, c-linha, ";")) /*Estabelecimento da planilha*/ 
          AND apur-imposto.tp-imposto  = INTEGER(TRIM(ENTRY(2, c-linha, ";"))) /*Tipo imposto da planilha,*/  
          AND apur-imposto.dt-apur-ini =    date(TRIM(ENTRY(3, c-linha, ";"))) /*Data inicial planilha*/
          AND apur-imposto.dt-apur-fim =    date(TRIM(ENTRY(4, c-linha, ";"))) /*Data final planilha*/ NO-LOCK NO-ERROR.

    IF AVAIL apur-imposto THEN DO:
        
        CREATE tt-imp-valor.
        ASSIGN tt-imp-valor.cod-estabel     =         TRIM(ENTRY(1, c-linha, ";")) 
               tt-imp-valor.tp-imposto      = INTEGER(TRIM(ENTRY(2, c-linha, ";")))
               tt-imp-valor.dt-apur-ini     =    date(TRIM(ENTRY(3, c-linha, ";")))
               tt-imp-valor.dt-apur-fim     =    date(TRIM(ENTRY(4, c-linha, ";")))
               tt-imp-valor.cod-lanc        = INTEGER(TRIM(ENTRY(5, c-linha, ";")))
               tt-imp-valor.cod-ajuste      =         TRIM(ENTRY(6, c-linha, ";"))
               tt-imp-valor.cod-ajuste-sped =         TRIM(ENTRY(7, c-linha, ";"))
               tt-imp-valor.nr-sequencia    = INTEGER(TRIM(ENTRY(8, c-linha, ";")))
               tt-imp-valor.vl-lancamento   = DECIMAL(TRIM(ENTRY(9, c-linha, ";")))
               tt-imp-valor.descricao       =         TRIM(ENTRY(10, c-linha, ";")).

        PUT UNFORMATTED "Leitura do Arquivo;"
                        tt-imp-valor.cod-estabel     ";"
                        tt-imp-valor.tp-imposto      ";"
                        tt-imp-valor.dt-apur-ini     ";"
                        tt-imp-valor.dt-apur-fim     ";"
                        tt-imp-valor.cod-lanc        ";"
                        tt-imp-valor.cod-ajuste      ";"
                        tt-imp-valor.cod-ajuste-sped ";"
                        tt-imp-valor.nr-sequencia    ";"
                        tt-imp-valor.vl-lancamento   ";"
                        tt-imp-valor.descricao      SKIP.
    
    END.
END.
INPUT CLOSE.

run pi-finalizar in h-acomp.    

PUT UNFORMATTED SKIP SKIP.

FOR EACH tt-imp-valor NO-LOCK:
    /*if tt-imp-valor.cod-ajuste <> "" and
        NOT can-find (first ped-curva
                        where ped-curva.vl-aberto = 3135
                          and ped-curva.it-codigo = tt-imp-valor.cod-ajuste NO-LOCK) THEN DO:
        PUT UNFORMATTED "Curva ABC NÆo cadastrada para sequencia: " tt-imp-valor.nr-sequencia.
        ASSIGN i-conta-erro = i-conta-erro + 1.
        NEXT.
    END.*/

    if apur-imposto.tp-imposto = 1 then do:
        FIND FIRST UNID-FEDER 
            WHERE UNID-FEDER.PAIS   = "Brasil":U
            AND   UNID-FEDER.ESTADO = SUBSTRING(tt-imp-valor.cod-ajuste-sped,1,2) NO-LOCK NO-ERROR.
        IF  NOT AVAIL UNID-FEDER THEN DO:
            ASSIGN i-conta-erro = i-conta-erro + 1.
            PUT UNFORMATTED "NÆo foi encontrado estado para o codigo de sped informado." SKIP.
        END.
    end.

    CREATE imp-valor.
    ASSIGN imp-valor.cod-estabel           = tt-imp-valor.cod-estabel    
           imp-valor.tp-imposto            = tt-imp-valor.tp-imposto     
           imp-valor.dt-apur-ini           = tt-imp-valor.dt-apur-ini    
           imp-valor.dt-apur-fim           = tt-imp-valor.dt-apur-fim    
           imp-valor.cod-lanc              = tt-imp-valor.cod-lanc       
           imp-valor.nr-sequencia          = tt-imp-valor.nr-sequencia   
/*            imp-valor.cod-ajuste-sped       = tt-imp-valor.cod-ajuste-sped */
           imp-valor.vl-lancamento         = tt-imp-valor.vl-lancamento  
           imp-valor.descricao             = tt-imp-valor.descricao.     
    
    ASSIGN i-conta-ok = i-conta-ok + 1.

    IF tt-imp-valor.cod-ajuste-sped <> "" AND tt-imp-valor.cod-ajuste-sped <> ? THEN
       ASSIGN OVERLAY(imp-valor.char-1,11,20) = tt-imp-valor.cod-ajuste-sped
              OVERLAY(imp-valor.char-1,1,10)  = "".
    ELSE
       ASSIGN OVERLAY(imp-valor.char-1,1,10) = tt-imp-valor.cod-ajuste.
    

   if avail imp-valor THEN DO:
      FIND FIRST dwf-apurac-impto-ajust
          WHERE  dwf-apurac-impto-ajust.cod-estab                 = imp-valor.cod-estabel
          AND    dwf-apurac-impto-ajust.dat-apurac-inicial-impto  = imp-valor.dt-apur-ini
          AND    dwf-apurac-impto-ajust.dat-apurac-final-impto    = imp-valor.dt-apur-fim 
          AND    dwf-apurac-impto-ajust.cod-ajust                 = TRIM(IF  SUBSTRING(imp-valor.char-1,11,20) <> ? 
                                                                         AND SUBSTRING(imp-valor.char-1,11,20) <> "" THEN 
                                                                             SUBSTRING(imp-valor.char-1,11,20)
                                                                         ELSE substring(imp-valor.char-1,1,10))
          AND    dwf-apurac-impto-ajust.cod-impto                 = {diinc/i01di220.i 04 imp-valor.tp-imposto}
          AND    dwf-apurac-impto-ajust.cod-lancto                = STRING(imp-valor.cod-lanc,"999") 
          AND    dwf-apurac-impto-ajust.num-seq-ajust             = imp-valor.nr-sequencia EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL dwf-apurac-impto-ajust THEN DO:
          DELETE dwf-apurac-impto-ajust.
      END.

      CREATE dwf-apurac-impto-ajust.
      ASSIGN dwf-apurac-impto-ajust.cod-estab                = imp-valor.cod-estabel
             dwf-apurac-impto-ajust.dat-apurac-final-impto   = imp-valor.dt-apur-fim
             dwf-apurac-impto-ajust.dat-apurac-inicial-impto = imp-valor.dt-apur-ini
             dwf-apurac-impto-ajust.cod-ajust                = TRIM(IF  SUBSTRING(imp-valor.char-1,11,20) <> ? 
                                                                      AND SUBSTRING(imp-valor.char-1,11,20) <> "" THEN 
                                                                          SUBSTRING(imp-valor.char-1,11,20)
                                                                      ELSE substring(imp-valor.char-1,1,10))
             dwf-apurac-impto-ajust.cod-impto                = {diinc/i01di220.i 04 imp-valor.tp-imposto}
             dwf-apurac-impto-ajust.num-seq-ajust            = imp-valor.nr-sequencia
             dwf-apurac-impto-ajust.dsl-ajust-apurac         = imp-valor.descricao
             dwf-apurac-impto-ajust.cod-lancto               = STRING(imp-valor.cod-lanc,"999")
             dwf-apurac-impto-ajust.val-ajust-apurac         = imp-valor.vl-lancamento
             dwf-apurac-impto-ajust.dat-inic-valid           = TODAY
             dwf-apurac-impto-ajust.dat-fim-valid            = ?.
   END.
END.

EMPTY TEMP-TABLE tt-imp-valor.

OUTPUT CLOSE.

IF i-conta-erro <> 0 THEN
    MESSAGE "Importa‡Æo conclu¡da, por‚m ocorreram erros." SKIP
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE
    MESSAGE "Importa‡Æo conclu¡da com ˆxito."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

ASSIGN i-conta-erro = 0
       i-conta-ok   = 0.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

