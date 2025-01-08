&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i escep074 2.00.00.000}
{esp/es0018.i}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escep074 escep}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp112
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels  

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 c-arquivo-imp bt-arquivo-entrada ~
                              editor-1 fi-pedido fi-it-codigo fi-desc-item
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-arq-uuid NO-UNDO
    FIELD linha   AS INTEGER
    FIELD uuid    AS CHAR
    FIELD authkey AS CHAR.

DEF TEMP-TABLE tt-num-serie NO-UNDO
    FIELD linha   AS INTEGER
    FIELD n-serie AS CHAR
    FIELD uuid    AS CHAR
    FIELD authkey AS CHAR.

DEF STREAM s-import.

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
btReportsJoins btExit btHelp bt-arquivo-entrada c-arquivo-imp EDITOR-1 btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-pedido fi-it-codigo fi-desc-item ~
c-arquivo-imp EDITOR-1 

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
DEFINE BUTTON bt-arquivo-entrada 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

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
     LABEL "Executar" 
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

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 78 BY 4 NO-UNDO.

DEFINE VARIABLE c-arquivo-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88
     BGCOLOR 15 .

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .79 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(12)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-pedido AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     fi-pedido AT ROW 2.63 COL 9 COLON-ALIGNED WIDGET-ID 16
     fi-it-codigo AT ROW 3.67 COL 9 COLON-ALIGNED WIDGET-ID 18
     fi-desc-item AT ROW 3.67 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     bt-arquivo-entrada AT ROW 4.63 COL 51.43 HELP
          "Escolha do nome do arquivo" WIDGET-ID 8
     c-arquivo-imp AT ROW 4.71 COL 9 COLON-ALIGNED WIDGET-ID 4
     EDITOR-1 AT ROW 5.92 COL 11 NO-LABEL WIDGET-ID 10
     btOK AT ROW 10.42 COL 2
     btCancel AT ROW 10.42 COL 13
     btHelp2 AT ROW 10.42 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 10.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.67
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 10.67
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME bt-arquivo-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-entrada wWindow
ON CHOOSE OF bt-arquivo-entrada IN FRAME fpage0
DO:

    SYSTEM-DIALOG GET-FILE c-arquivo-imp
    FILTERS "*.csv" "*.csv",
            "*.*" "*.*"         
    DEFAULT-EXTENSION "csv"
    INITIAL-DIR "spool" 
    USE-FILENAME.
    
    ASSIGN c-arquivo-imp:SCREEN-VALUE IN FRAME fPage0 = c-arquivo-imp.
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
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    //RUN esp\cep\escep074rp.p (INPUT c-arquivo-imp:SCREEN-VALUE IN FRAME fPage0). 
    RUN pi-importa-uuid.
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


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
   FIND FIRST ITEM WHERE
              ITEM.it-codigo = INPUT fi-it-codigo:SCREEN-VALUE IN FRAME fPage0
              NO-LOCK NO-ERROR.

   IF AVAIL ITEM 
   THEN ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fpage0 = ITEM.desc-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

ASSIGN editor-1 = "**** Importaá∆o de UUID e Authkey ****" + CHR(13) +
                   "Layout do Arquivo: UUID;Authkey" + CHR(13) +
                   "tuyabca053cd2f05d8d3;ABCDg2IW39zU4uNBe2kjkYw27RKN31sx" + CHR(13) +
                   "tuyabde999sffer55443;TGDZa1IW39zU4uNBe2kjkYw27RKN31ww" + CHR(13) .

DISP editor-1
    WITH FRAME fPage0.

ASSIGN fi-desc-item:SENSITIVE IN FRAME fpage0 = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-uuid wWindow 
PROCEDURE pi-cria-uuid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-conta-ns   AS INTEGER NO-UNDO.    
    DEF VAR i-linhas     AS INTEGER NO-UNDO.
    DEF VAR c-uuid       AS CHAR    NO-UNDO.
    DEF VAR c-authey     AS CHAR    NO-UNDO.

    DEF BUFFER b-tt-arq-uuid FOR tt-arq-uuid.

    INPUT STREAM s-import FROM VALUE(c-arquivo-imp:SCREEN-VALUE IN FRAME fpage0).

    ASSIGN i-linhas   = 0.

    EMPTY TEMP-TABLE tt-arq-uuid.

    run pi-acompanhar in h-acomp (input 'Importando Arquivo').

    REPEAT ON ERROR UNDO, LEAVE
           ON STOP  UNDO, LEAVE TRANSACTION:

       IMPORT STREAM s-import DELIMITER ";"
           c-uuid 
           c-authey.

       ASSIGN i-linhas = i-linhas + 1.

       CREATE tt-arq-uuid.
       ASSIGN tt-arq-uuid.linha   = i-linhas
              tt-arq-uuid.uuid    = c-uuid
              tt-arq-uuid.authkey = c-authey.

       FIND FIRST b-tt-arq-uuid WHERE
                  b-tt-arq-uuid.uuid   = c-uuid AND
                  b-tt-arq-uuid.linha <> i-linhas
                  NO-LOCK NO-ERROR.

       IF AVAIL b-tt-arq-uuid 
       THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 17006,
                              INPUT "UUID repetido no arquivo!~~"
                                  + "UUID: " + c-uuid 
                                  + " duplicado no arquivo" ).

           INPUT STREAM s-import CLOSE.

           RETURN "NOK":U.
       END.

       FIND FIRST num-serie-uuid USE-INDEX uuid 
            WHERE num-serie-uuid.uuid = tt-arq-uuid.uuid
                  NO-LOCK NO-ERROR.

       IF AVAIL num-serie-uuid
       THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 17006,
                              INPUT "UUID j† importado!~~"
                                  + "UUID: " + num-serie-uuid.uuid 
                                  + " j† foi importado e vinculado no NS: " 
                                  +  num-serie-uuid.n-serie).

           INPUT STREAM s-import CLOSE.

           RETURN "NOK":U.
       END.     
    END.
    
    INPUT STREAM s-import CLOSE.

    run pi-acompanhar in h-acomp (input 'Contando NS').

    ASSIGN i-conta-ns = 0.

    EMPTY TEMP-TABLE tt-num-serie.

    FOR EACH num-serie WHERE
             num-serie.num-pedido = int(fi-pedido:SCREEN-VALUE IN FRAME fpage0) AND
             num-serie.it-codigo  = fi-it-codigo:SCREEN-VALUE IN FRAME fpage0
             NO-LOCK.

        ASSIGN i-conta-ns = i-conta-ns + 1.

        FIND FIRST tt-arq-uuid WHERE
                   tt-arq-uuid.linha = i-conta-ns
                   NO-LOCK NO-ERROR.

        IF AVAIL tt-arq-uuid 
        THEN DO: 
            CREATE tt-num-serie.
            ASSIGN tt-num-serie.linha   = tt-arq-uuid.linha
                   tt-num-serie.n-serie = num-serie.n-serie
                   tt-num-serie.uuid    = tt-arq-uuid.uuid
                   tt-num-serie.authkey = tt-arq-uuid.authkey.
        END.

    END.

    IF i-conta-ns <> i-linhas 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Quantidade de NS diferente da Quantidade de UUID!~~"
                               + "Quantidades de NS com quantidades de UUID do arquivo n∆o s∆o as mesmas." 
                               + CHR(13)
                               + "Qtd NS: " + STRING(i-conta-ns)
                               + CHR(13)
                               + "Qtd UUID: " + STRING(i-linhas)).

        RETURN "NOK":U.
    END.    

    run pi-acompanhar in h-acomp (input 'Criando vinculos de NS e UUID').

    FOR EACH tt-num-serie NO-LOCK.

        FIND FIRST num-serie-uuid WHERE
                   num-serie-uuid.n-serie = tt-num-serie.n-serie
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL num-serie-uuid 
        THEN DO:
            CREATE num-serie-uuid.
            ASSIGN num-serie-uuid.n-serie     = tt-num-serie.n-serie
                   num-serie-uuid.uuid        = tt-num-serie.uuid
                   num-serie-uuid.authkey     = tt-num-serie.authkey
                   num-serie-uuid.data-imp    = TODAY
                   num-serie-uuid.cod-usuario = c-seg-usuario
                   num-serie-uuid.char-1      = INPUT c-arquivo-imp:SCREEN-VALUE IN FRAME fpage0.
        END.

    END.

    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Arquivo importado com sucesso!").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-uuid wWindow 
PROCEDURE pi-importa-uuid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF int(fi-pedido:SCREEN-VALUE IN FRAME fpage0) = 0 
   THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Informe um pedido!~~Informe um pedido":U).

       RETURN "NOK":U.
   END.
   ELSE DO:
       FIND FIRST pedido-compr WHERE
                  pedido-compr.num-pedido = INT(INPUT fi-pedido:SCREEN-VALUE IN FRAME fpage0)
                  NO-LOCK NO-ERROR.

       IF NOT AVAIL pedido-compr 
       THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 17006,
                              INPUT "Pedido n∆o cadastrado!~~Pedido informado errado ou n∆o cadastrado":U).

           RETURN "NOK":U.
       END.
   END.

   IF fi-it-codigo:SCREEN-VALUE IN FRAME fpage0 = "" 
   THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Informe um item!~~Informe um item":U).

       RETURN "NOK":U.
   END.
   ELSE DO:
       FIND FIRST ordem-compra USE-INDEX pedido-item 
            WHERE ordem-compra.num-pedido = int(fi-pedido:SCREEN-VALUE IN FRAME fpage0)
              AND ordem-compra.it-codigo  = fi-it-codigo:SCREEN-VALUE IN FRAME fpage0
                  NO-LOCK NO-ERROR.

       IF NOT AVAIL ordem-compra 
       THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 17006,
                              INPUT "Item n∆o vinculado com o pedido!~~Item informado n∆o esta vinculado dentro do pedido":U).
           
           RETURN "NOK":U.
       END.
   END.

   FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.

   RUN esp\es0018p.p (INPUT "uuid",   /* Nome do programa */
                      INPUT 1,          /* Ponto do programa */
                      INPUT 0,
                      INPUT "",
                      OUTPUT TABLE tt-prog-ponto) NO-ERROR.

   FIND FIRST tt-prog-ponto WHERE 
              tt-prog-ponto.conteudo = INPUT fi-it-codigo:SCREEN-VALUE IN FRAME fpage0 
              NO-LOCK NO-ERROR.

   IF NOT AVAIL tt-prog-ponto THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Item n∆o parametrizado para utilizar UUID!~~O item informado n∆o esta liberado para utilizar UUID nem Authkey":U).

       RETURN "NOK":U.
   END.

   IF NOT CAN-FIND(FIRST num-serie WHERE
                         num-serie.num-pedido = int(fi-pedido:SCREEN-VALUE IN FRAME fpage0) AND
                         num-serie.it-codigo  = fi-it-codigo:SCREEN-VALUE IN FRAME fpage0
                         NO-LOCK) 
   THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Pedido sem Numeros de Serie!~~Pedido e Item informados n∆o tem nenhum numero de serie vinculado":U).

       RETURN "NOK":U.
   END.
   ELSE DO:
       FIND FIRST num-serie 
            WHERE num-serie.num-pedido = int(fi-pedido:SCREEN-VALUE IN FRAME fpage0) 
              AND num-serie.it-codigo  = fi-it-codigo:SCREEN-VALUE IN FRAME fpage0
                  NO-LOCK NO-ERROR.

       IF AVAIL num-serie 
       THEN DO:
           FIND FIRST num-serie-uuid WHERE
                      num-serie-uuid.n-serie = num-serie.n-serie
                      NO-LOCK NO-ERROR.

           IF AVAIL num-serie-uuid 
           THEN DO:
               RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                  INPUT 17006,
                                  INPUT "UUID e Authkey j† importados!~~UUID e Authkey j† importados para o PO e item informados":U).
               
               RETURN "NOK":U.
           END.
       END.
   END.

   IF INPUT c-arquivo-imp:SCREEN-VALUE IN FRAME fpage0 = "" 
   THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Arquivo deve ser inforado!~~Informe um arquivo":U).

       RETURN "NOK":U.
   END.
   ELSE DO:
       IF search(INPUT c-arquivo-imp:SCREEN-VALUE IN FRAME fpage0) = ? 
       THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 17006,
                              INPUT "Arquivo n∆o foi localizado!~~Arquivo informado n∆o localizado, verifique ou informe um arquivo correto":U).

           RETURN "NOK":U.
       END.
   END.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    RUN pi-inicializar in h-acomp (input "Importando UUID"). 
    
    RUN pi-cria-uuid.

    RUN pi-finalizar IN h-acomp.

    ASSIGN h-acomp = ?.

    //CREATE 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

