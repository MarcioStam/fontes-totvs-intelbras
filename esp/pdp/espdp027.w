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
{include/i-prgvrs.i espdp027 1.00.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp027
&GLOBAL-DEFINE Version        1.00.000.000 

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   E-Mail

&GLOBAL-DEFINE page0Widgets   btExit btHelp ~
                              btAcao
&GLOBAL-DEFINE page1Widgets   fi-dt-validade fi-arq-htm fi-email fi-num-pedido fi-cobranca fi-tipo-pedido btFile tg-observ-pedido listar-qt-aberto tg-classi-fiscal tg-item-alocado tg-email

{esp/es0006a.i}
{esp/es0006.i}
{upc\btb910za-upc.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{esp/es0018.i}
{include/tt-edit.i}

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF VAR l-ok AS LOGICAL NO-UNDO.
DEF VAR wh-num-pedido AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-pesquisa AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-page AS INT NO-UNDO INIT 1.
def var c-data         as char  no-undo.
DEF VAR c-remetente        AS CHAR NO-UNDO INIT "ems@intelbras.com.br".
def var de-preco-total     as decimal no-undo.
DEFINE VARIABLE de-frete-item AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-dt-validade AS DATE        NO-UNDO.

DEFINE VARIABLE p-i-tributacao AS INTEGER     NO-UNDO.

DEF NEW GLOBAL SHARED VAR r-rowid-pd4000  AS ROWID  NO-UNDO.
DEFINE VAR c-email-repres AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btExit btHelp btAcao 

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
DEFINE BUTTON btAcao 
     LABEL "&Gerar" 
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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY .88.

DEFINE VARIABLE fi-cobranca AS CHARACTER FORMAT "X(50)":U 
     LABEL "Cobran»a" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEM-PAIRS "Antecipado","Antecipado",
                     "Boleto","Boleto",
                     "Cheque","Cheque",
                     "Dep½sito","Dep½sito",
                     "Dep½sito/Boleto","Dep½sito/Boleto",
                     "Dinheiro","Dinheiro",
                     "Sem Custo","Sem Custo"
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-tipo-pedido AS CHARACTER FORMAT "X(50)":U 
     LABEL "Tipo de Pedido" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEM-PAIRS "Pedido de Venda","Pedido de Venda",
                     "Solicita»’o de Nota Fiscal","Solicita»’o de Nota Fiscal"
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fi-arq-htm AS CHARACTER FORMAT "X(60)":U 
     LABEL "Arquivo HTML" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-validade AS CHARACTER FORMAT "X(10)":U 
     LABEL "Data Valid. Orcamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(200)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE listar-qt-aberto AS LOGICAL INITIAL no 
     LABEL "Mostrar somente itens e quantidade em aberto." 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE tg-classi-fiscal AS LOGICAL INITIAL no 
     LABEL "Imprime classificacao fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE tg-email AS LOGICAL INITIAL yes 
     LABEL "Enviar Email" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-item-alocado AS LOGICAL INITIAL no 
     LABEL "Mostrar somente itens alocados" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tg-observ-pedido AS LOGICAL INITIAL no 
     LABEL "Trazer no Orcamento a Observacao do Pedido." 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     btAcao AT ROW 16.25 COL 3.57
     rtToolBar AT ROW 16 COL 1.72
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.25
         FONT 1.

DEFINE FRAME fPage1
     fi-num-pedido AT ROW 2 COL 15 COLON-ALIGNED HELP
          "Nœmero do Pedido de Venda"
     fi-cobranca AT ROW 3.25 COL 15 COLON-ALIGNED HELP
          "Tipo Cobran»a"
     fi-tipo-pedido AT ROW 4.25 COL 15 COLON-ALIGNED HELP
          "Tipo de Pedido"
     fi-email AT ROW 5.25 COL 15 COLON-ALIGNED
     fi-arq-htm AT ROW 6.25 COL 15 COLON-ALIGNED
     fi-dt-validade AT ROW 7.25 COL 15.14 COLON-ALIGNED
     tg-observ-pedido AT ROW 8.25 COL 17 WIDGET-ID 2
     btFile AT ROW 8.25 COL 67 HELP
          "Escolha do nome do arquivo"
     listar-qt-aberto AT ROW 9.08 COL 17 WIDGET-ID 4
     tg-classi-fiscal AT ROW 9.96 COL 17 HELP
          "Imprime o campo de classifica»’o fiscal." WIDGET-ID 6
     tg-item-alocado AT ROW 10.88 COL 17 WIDGET-ID 8
     tg-email AT ROW 11.79 COL 17 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.29 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.25
         WIDTH              = 90
         MAX-HEIGHT         = 17.25
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.25
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

{esp/ShowMsg.i}
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
ASSIGN 
       btAcao:PRIVATE-DATA IN FRAME fpage0     = 
                "&Gerar,&Alterar".

/* SETTINGS FOR FRAME fPage1
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


&Scoped-define SELF-NAME btAcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAcao wWindow
ON CHOOSE OF btAcao IN FRAME fpage0 /* Gerar */
DO:
    if  fi-tipo-pedido:screen-value in frame fpage1 = "Pedido de Venda" then do:
        FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = INT(fi-num-pedido:SCREEN-VALUE in frame fpage1) NO-ERROR.
        IF NOT AVAIL ped-venda THEN DO:
            RUN ShowMessage (1, "Pedido de venda n’o cadastrado", "").
     
            APPLY "entry" TO wh-num-pedido.
            RETURN NO-APPLY.
        END.
    end.
    else do:
        FIND FIRST mgesp.ped-fiscal NO-LOCK
            WHERE mgesp.ped-fiscal.nr-pedido = INT(fi-num-pedido:SCREEN-VALUE in frame fpage1) NO-ERROR.
        IF NOT AVAIL mgesp.ped-fiscal THEN DO:
            RUN ShowMessage (1, "Solicita»’o de NF n’o cadastrado", "").
     
            APPLY "entry" TO wh-num-pedido.
            RETURN NO-APPLY.
        END.    
    end.
    APPLY "leave" TO fi-arq-htm IN FRAME fpage1.
 
        IF INPUT FRAME fpage1 fi-email = "" THEN DO:
            RUN ShowMessage (1, "Endere»o de E-Mail n’o informado", "").
  
            APPLY "entry" TO fi-email IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        IF INPUT FRAME fpage1 fi-arq-htm = "" THEN DO:
            RUN ShowMessage (1, "Arquivo HTML n’o informado", "").

            APPLY "entry" TO fi-arq-htm IN FRAME fpage1.
            RETURN NO-APPLY.
        END.

        ASSIGN INPUT FRAME fpage1 fi-arq-htm fi-email fi-num-pedido.
        if  fi-tipo-pedido:screen-value in frame fpage1 = "Pedido de Venda" then do:
            RUN piGera.  
        end.
        else do:
            RUN piGeraSolNota.  
        end.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fPage1
DO:
    SYSTEM-DIALOG GET-FILE fi-arq-htm
      FILTERS "HTML(*.htm*)" "*.htm*",
              "Todos os arquivos(*.*)" "*.*"
      INITIAL-FILTER 1
      ASK-OVERWRITE 
      DEFAULT-EXTENSION "html"
      SAVE-AS
      UPDATE l-ok.

    IF l-ok THEN DISP fi-arq-htm WITH FRAME fpage1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-arq-htm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-arq-htm wWindow
ON LEAVE OF fi-arq-htm IN FRAME fPage1 /* Arquivo HTML */
DO:
    IF R-INDEX(INPUT fi-arq-htm, ".htm") = 0
    AND R-INDEX(INPUT fi-arq-htm, ".html") = 0 THEN 
        DISP INPUT fi-arq-htm + ".html" @ fi-arq-htm WITH FRAME fpage1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON F5 OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
  /*  {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                       &campo="fi-num-pedido"
                       &campozoom="num-pedido"
                       &frame="fPage1"}
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON LEAVE OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = INT(fi-num-pedido:SCREEN-VALUE in frame fpage1) NO-ERROR.
      
      IF AVAIL ped-venda THEN DO:
          ASSIGN fi-email:screen-value in frame fpage1 = c-remetente.

          FOR FIRST ped-repre NO-LOCK
              WHERE ped-repre.nr-pedido   = ped-venda.nr-pedido
                AND ped-repre.nome-ab-rep = ped-venda.no-ab-reppri:

              FIND FIRST repres NO-LOCK
                   WHERE repres.nome-abrev = ped-repre.nome-ab-rep NO-ERROR.

              ASSIGN c-email-repres = repres.e-mail.
          END.
          
          FOR first emitente FIELDS (e-mail) NO-LOCK
              where emitente.cod-emitente = ped-venda.cod-emitente:
              if emitente.e-mail <> "" then
                  assign fi-email:screen-value in frame fpage1 = c-email-repres + "," + c-remetente + "," + emitente.e-mail.
          END.           
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME listar-qt-aberto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL listar-qt-aberto wWindow
ON VALUE-CHANGED OF listar-qt-aberto IN FRAME fPage1 /* Mostrar somente itens e quantidade em aberto. */
DO:
  IF listar-qt-aberto:CHECKED THEN
      ASSIGN tg-item-alocado:CHECKED = NO
             tg-item-alocado:SENSITIVE = NO.
  ELSE
      ASSIGN tg-item-alocado:CHECKED = NO
             tg-item-alocado:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-item-alocado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-item-alocado wWindow
ON VALUE-CHANGED OF tg-item-alocado IN FRAME fPage1 /* Mostrar somente itens alocados */
DO:
  IF tg-item-alocado:CHECKED THEN
      ASSIGN listar-qt-aberto:CHECKED = NO
             listar-qt-aberto:SENSITIVE = NO.
  ELSE
      ASSIGN listar-qt-aberto:CHECKED = NO
             listar-qt-aberto:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
DEF TEMP-TABLE RowErrors2 LIKE RowErrors.
fi-num-pedido:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{include/pi-edit.i}

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari vel nÆo vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE {&List-1} WITH FRAME fPage1.
    
    FOR FIRST param-global NO-LOCK:
    END.
    
    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK:
        assign c-remetente = usuar_mestre.cod_e_mail_local .
    END.   
  
    ASSIGN fi-arq-htm:SCREEN-VALUE IN FRAME fpage1 = SESSION:TEMP-DIRECTORY + "ped"
           fi-cobranca:screen-value in frame fpage1 = "Boleto"
           fi-tipo-pedido:screen-value in frame fpage1 = "Pedido de Venda"
           fi-dt-validade:SCREEN-VALUE IN FRAME fpage1 = string(TODAY + 15).

    FIND FIRST ped-venda NO-LOCK
         WHERE ROWID(ped-venda) = r-rowid-pd4000 NO-ERROR.
    IF AVAIL ped-venda THEN DO:
        ASSIGN fi-num-pedido:SCREEN-VALUE IN FRAME fPage1 = STRING(ped-venda.nr-pedido).
        APPLY "leave" TO fi-num-pedido IN FRAME fPage1.
    END.
           

    return "OK".
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wWindow 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.
    
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.
    
    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.


    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-mail:

        FOR EACH tt-envio2.   DELETE tt-envio2.   END.
        FOR EACH tt-mensagem. DELETE tt-mensagem. END.

        ASSIGN c-lst-arq  = tt-mail.arquivo. 
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-mail.Destinatario     /* Destinatÿrio       */ 
               tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
               tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
               tt-envio2.arq-anexo         = c-lst-arq               /* Arquivo Temporÿrio */
               tt-envio2.formato           = "TEXTO".
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */

        /**** coloquei em comentario pois n’o mostra o programa que foi chamado,
        somente mostra o nome das viewers, trigger, etc   ****/
/*        REPEAT WHILE PROGRAM-NAME(level) <> ?.
               CREATE tt-mensagem.
               ASSIGN tt-mensagem.seq-mensagem = level + 2
                      tt-mensagem.mensagem     = "Nivel: " + string(LEVEL) +
                                                 "  Programa: " + PROGRAM-NAME(level) + CHR(13)
                      level = level + 1.
        END.
  */
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN
          FOR EACH tt-erros:
            MESSAGE "Problema ao enviar e-mail:"
                 tt-erros.cod-erro  SKIP
                 tt-erros.desc-erro SKIP tt-erros.desc-arq VIEW-AS ALERT-BOX.
             
        END.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGera wWindow 
PROCEDURE piGera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-observacoes-2 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-observacoes-3 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c_imagem_usada AS CHARACTER   NO-UNDO.
    def var c-agente           as char no-undo.
    def var c-embarque         as char no-undo.
    def var c-desembarque      as char no-undo.
    def var de-total-compras  as decimal no-undo.
    def var c-mess-err         as char no-undo.
    def var c-nr-pedido        as char format "x(100)" no-undo.
    def var c-tit-ped          as char format "x(100)" no-undo.
    def var c-dados-empresa    as char format "x(300)" no-undo.
    def var c-dados-cliente    as char format "x(500)" no-undo.
    def var c-imagem           as char format "x(120)" no-undo.    
    def var c-complementos     as char format "x(300)" no-undo.
    def var c-mensagem1        as char format "x(500)" no-undo.
    def var c-titulo       as char  no-undo.
    def var de-total-geral     as decimal                              no-undo.
    def var de-total-sipi      as decimal                              no-undo.
    def var de-preco-sipi      as decimal                              no-undo.
    def var de-ipi             as decimal                              no-undo.
    def var de-preco-tot-aux   like de-preco-total NO-UNDO.
    def var de-desc-total      like de-preco-total NO-UNDO.
    def var de-enc             as DECIMAL NO-UNDO.
    def var de-enc-total       like ordem-compra.preco-unit NO-UNDO.
    def var c-totais           as char format "x(300)" no-undo.
    def var c-comprador        like cont-emit.nome no-undo.
    def var c-vendedor         like mgesp.atendente.nm-oper no-undo.
    def var c-desc-pagto       like cond-pagto.descricao no-undo.
    def var c-observacoes-1    as char format "x(500)" no-undo.
    def var c-desc-ad          as char no-undo.
    DEF VAR c-cod-sit-item     AS DECIMAL NO-UNDO.
    def var de-vl-frete        as dec no-undo.
    DEF VAR valor-ipi          AS DEC NO-UNDO.
    DEF VAR ipi-total          AS DEC NO-UNDO.
    DEF VAR qt-pendente        AS DECIMAL NO-UNDO.
    DEF VAR qtde-item          AS DECIMAL NO-UNDO.     
    DEF VAR valor-a-pagar      AS DEC NO-UNDO.
    def var de-vl-pagar        as dec no-undo.
    def var c-cobranca         as char no-undo.
    def var c-tipo-pedido      as char no-undo.
    def var de-valor-st        as dec  no-undo.
    DEF VAR st-total           AS DEC NO-UNDO.
    def var de-valor-mob       as dec  no-undo.
    def var l-cat as logical no-undo.
    def var l-cat-1 as logical no-undo.
    def var c-pedido-venda as char no-undo.
    def var c-pedido-revenda as char no-undo.

    DEF VAR de-vl-ipi-frete-aux AS DEC NO-UNDO.
    
    def var de-vl-orcamento like ped-item.vl-preuni no-undo.
    def var de-vl-ipi like ped-item.aliquota-ipi no-undo.
    def var de-vl-ipi-frete AS DEC NO-UNDO.

    DEF VAR c-aux1 AS CHAR FORMAT "X(20)" NO-UNDO.
    DEF VAR c-aux2 AS CHAR FORMAT "X(20)" NO-UNDO.

    DEF VAR vl-alocado AS DEC NO-UNDO.
    
    def buffer bf-emitente for emitente.

     IF ped-venda.completo = NO  THEN DO:
       MESSAGE "Pedido Nao Estÿ Completo" VIEW-AS ALERT-BOX.
       RETURN "NOK".
    END.

    IF  ped-venda.cod-des-merc = 2 THEN /* Consumo pr½prio */
        ASSIGN c-aux1 = "DIFA"
               c-aux2 = "Valor DIFA".
    ELSE /* Com²rcio indœstria */
        ASSIGN c-aux1 = "ICMS ST"
               c-aux2 = "Valor ST".

    find emitente no-lock
         where emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    find transporte no-lock
         where  transporte.nome-abrev = ped-venda.nome-transp NO-ERROR.    

    find estabelec where
         estabelec.cod-estabel = ped-venda.cod-estabel no-lock no-error.
    if avail estabelec then do:
        find mgcad.empresa where
             empresa.ep-codigo = estabelec.ep-codigo no-lock no-error.
    end.

    assign c-arquivo = fi-arq-htm:screen-value in frame fpage1
           c-titulo = "Orcamento " + string(ped-venda.nr-pedido)
           c-cobranca = fi-cobranca:screen-value in frame fpage1
           c-tipo-pedido = fi-tipo-pedido:screen-value in frame fpage1                      
           
           d-dt-validade = DATE(fi-dt-validade:screen-value in frame fpage1).
           
    output to value(fi-arq-htm) CONVERT TARGET SESSION:CHARSET.

    run html-inicio ("Orcamento").

    find cond-pagto where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error.

    find bf-emitente where
         bf-emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.
    find mgesp.atendente where
         atendente.cd-oper = int(ped-venda.tp-pedido) no-lock no-error.
    if avail atendente then
        assign c-vendedor = atendente.nm-oper.
        
    find first cond-pagto
         where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error.
    if avail cond-pagto then
        assign c-desc-pagto = cond-pagto.descricao.         
        
    find first cont-emit
         where cont-emit.cod-emitente = emitente.cod-emitente no-lock no-error.
    if avail cont-emit then
        assign c-comprador = cont-emit.nome.
    FIND FIRST int-ped-venda NO-LOCK
            WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
              AND int-ped-venda.cod-estabel = ped-venda.cod-estabel  NO-ERROR.

    assign c-data      = string(day(ped-venda.dt-emissao),"99") 
                       + "/"
                       + string(month(ped-venda.dt-emissao),"99")
                       + "/"
                       + string(year(ped-venda.dt-emissao), "9999")
           c-nr-pedido = "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(ped-venda.nr-pedido, ">>>>,>>9")
                       + " - "
                       + c-data
                       + "</FONT> </TH>"                       
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + "<B>Endereco:</B> " + estabelec.endereco + " - " + estabelec.bairro + "<BR>"
                           + "<B>Cidade:</B> " + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"                          
                           + "<B>Fone:</B> "
                           + bf-emitente.telefone[1]
                           + "<BR>"
                           + "<B>Home:</B> " + bf-emitente.home-page
                           + "<BR>"                          
                           + "<B>CNPJ:</B> " + trim(string(estabelec.cgc)) + "<BR>"
                           + "<B>I.Estadual:</B> " + trim(string(estabelec.ins-estadual))
                           + "<BR>"                              
                           + "<B>Vendedor:</B> " + trim(c-vendedor)                           
                           + "<BR><BR><BR>"
                           + "<B>Transportadora:</B> " + ped-venda.nome-transp
           c-dados-cliente =  "<B>Cliente:</B> " + string(emitente.cod-emitente) + " - " + emitente.nome-abrev + "</B>"
                              + "<BR>"                              
                              + "<B>Razao Social:</B> " + emitente.nome-emit 
                              + "<BR>"
                              + "<B>Endereco:</B> " + emitente.endereco + " - " + emitente.bairro
                              + "<BR>"
                              + "<B>Cidade:</B> " + emitente.cidade + " - " + emitente.estado
                              + "<BR>"
                              + "<B>Fone:</B> " + emitente.telefone[1] + "  -  " + "<B>Fax:</B> " + emitente.telefax
                              + "<BR>"
                              + "<B>CNPJ:</B> " + emitente.cgc 
                              + "<BR>"                              
                              + "<B>Cond. Pagto:</B> " + c-desc-pagto
                              + "<BR>"
                              + "<B>Cobranca:</B> " + c-cobranca
                              + "<BR>"
                              + "<BR><BR>"
                              + "<B>Redespacho:</B> " + ped-venda.nome-tr-red
           c-complementos = "Condicao de Pagamento: "
                            + c-desc-pagto
                            + "<BR>Transportador:" 
                            + transporte.nome
           c-mensagem1    = "" 
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Orcamento"
                            + "</FONT>".
    
        assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#2E8B57> Intelbras </FONT> </TH>". 
        
    
    run html-ini-tab.
    
    run html-ini-lin-tab.
    
    put c-imagem skip.

    run html-cab-tab(c-tit-ped).
    
    put c-nr-pedido skip . 
    
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.    
    
    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
    
    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"  trim(c-dados-cliente) format "x(500)" "</TD>" skip. 
        
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("Codigo").
    run html-cab-tab("Descricao").
    
    IF INPUT FRAME fpage1 tg-classi-fiscal = YES THEN
        run html-cab-tab("Classi.Fisc"). 

    run html-cab-tab("Qtde").
    run html-cab-tab("Vlr. Unit.").
    run html-cab-tab("Vlr. Total").
    run html-cab-tab("D.Ad.%").
    run html-cab-tab("IPI").
    run html-cab-tab(c-aux1).
    run html-cab-tab("Vlr Total Item").
    run html-fim-lin-tab.
    
    assign de-vl-orcamento = 0
           de-vl-ipi = 0
           st-total  = 0
           c-pedido-venda = ""
           c-pedido-revenda = ""
           
           ipi-total = 0.    
    
    IF listar-qt-aberto:CHECKED THEN
        ASSIGN c-cod-sit-item = 2.
            ELSE 
                ASSIGN c-cod-sit-item = 3.

    for each ped-item of ped-venda NO-LOCK
        WHERE ped-item.cod-sit-item <= c-cod-sit-item,
        first natur-oper where natur-oper.nat-operacao = ped-item.nat-operacao no-lock
        BREAK BY ped-item.nr-pedcli:
        ASSIGN de-frete-item = 0.
        FIND item where item.it-codigo = ped-item.it-codigo no-lock no-error.
        
           ASSIGN qt-pendente = ped-item.qt-pedida - ped-item.qt-atendida.     
                  
           /*Foi criada a variÿvel qtde-item, que serve para armazenar a quantidade solicitada, por padr’o recebe a
           quantidade pedida total, se for selecionado somente em aberto, recebe o valor da quantidade pendente. */
           ASSIGN qtde-item = ped-item.qt-pedida.
           
           IF listar-qt-aberto:CHECKED THEN 
               ASSIGN qtde-item = qt-pendente.

           IF tg-item-alocado:CHECKED THEN DO: /*lista somente item alocado no pedido*/
              ASSIGN qtde-item = ped-item.qt-log-aloca.
              IF qtde-item = 0 THEN NEXT.
           END.

             assign de-vl-orcamento = de-vl-orcamento + (qtde-item * ped-item.vl-preuni)
                    c-desc-ad  = ped-item.des-pct-desconto-inform.
              
 
         /*-----------------------------------------------+
         | Significado dos c«digos de tributa¯Êo de IPI: |
         | 1 - Tributado                                 |
         | 2 - Isento                                    |
         | 3 - Outras                                    |
         | 4 - Reduzido                                  |
         +-----------------------------------------------*/
    
        assign p-i-tributacao = if  natur-oper.cd-trib-ipi = 1
                                then if  item.cd-trib-ipi = 1
                                     or  item.cd-trib-ipi = 4
                                     then 1
                                     else item.cd-trib-ipi
                                else if  natur-oper.cd-trib-ipi = 2
                                     or  natur-oper.cd-trib-ipi = 3
                                     then natur-oper.cd-trib-ipi
                                     else item.cd-trib-ipi.

            if p-i-tributacao  = 1 AND ped-item.aliquota-ipi > 0 then
                ASSIGN de-frete-item = de-frete-item + round(int-ped-venda.vl-frete * qtde-item * ped-item.vl-preuni / ped-venda.vl-liq-ped ,2) .
/*                                   *  (ped-item.aliquota-ipi / 100). */
            ELSE
                ASSIGN de-frete-item = de-frete-item + round(int-ped-venda.vl-frete * qtde-item * ped-item.vl-preuni / ped-venda.vl-liq-ped ,2).

            if p-i-tributacao  = 1 then
                assign de-vl-ipi  = de-vl-ipi + ROUND((qtde-item * ped-item.vl-preuni ) * (ped-item.aliquota-ipi / 100),2).
           
            ASSIGN de-vl-ipi-frete = 0.
            IF FIRST-OF(ped-item.nr-pedcli) THEN DO:
                ASSIGN de-vl-ipi-frete-aux = 0.
                if p-i-tributacao  = 1 THEN DO:
                    ASSIGN de-vl-ipi-frete =  ROUND(int-ped-venda.vl-frete * (ped-item.aliquota-ipi / 100),2).

                    ASSIGN de-vl-ipi-frete-aux = de-vl-ipi-frete.

                END.
            END.

            run html-ini-lin-tab.
            run html-con-tab (ped-item.it-codigo,"left").
            run html-con-tab (item.desc-item,"left").

           
            IF INPUT FRAME fpage1 tg-classi-fiscal = YES THEN
                run html-con-tab (item.class-fiscal,"left").
            
            run html-con-tab (qtde-item,"right").
            run html-con-tab (string(ped-item.vl-preuni,">>>>>,>>9.9999"),"right").
            run html-con-tab (string((qtde-item * ped-item.vl-preuni),">>>>>,>>9.99"),"right").
            run html-con-tab (c-desc-ad,"right").
          
        
        IF listar-qt-aberto:CHECKED THEN DO:
            ASSIGN valor-a-pagar = valor-a-pagar + (qtde-item * ped-item.vl-preuni). //ped-item.vl-liq-abe.
        END.
        ELSE DO:  
           IF tg-item-alocado:CHECKED THEN DO:
               ASSIGN valor-a-pagar = valor-a-pagar + (qtde-item * ped-item.vl-preuni).
           END.
           ELSE
               ASSIGN valor-a-pagar = valor-a-pagar + (qtde-item * ped-item.vl-preuni). //ped-item.vl-liq-abe. //ped-item.vl-tot-it.
        END.
          
        /*Calculo de IPI*/
        if p-i-tributacao  = 1 THEN DO:
           run html-con-tab (string((ROUND((qtde-item * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2) + de-vl-ipi-frete),">>>>>,>>9.99"),"right").
           ASSIGN ipi-total = ipi-total + ROUND((qtde-item * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2) + de-vl-ipi-frete.
        END.
        else DO:
           run html-con-tab (string(0,">>>,>>9.99"),"right").
        END.
                      
           ASSIGN valor-ipi = ROUND((qtde-item * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2). 
          
            IF natur-oper.subs-trib THEN                                                                     
                IF listar-qt-aberto:CHECKED THEN DO:                                                                  
                    assign de-valor-st = (ped-item.vl-liq-abe - (qtde-item * ped-item.vl-preuni)) - valor-ipi /*- de-frete-item*/ .

                    IF de-valor-st < 0 THEN
                       ASSIGN de-valor-st = 0.

                    ASSIGN st-total = st-total + de-valor-st.
                END.
                ELSE DO:
                    IF tg-item-alocado:CHECKED THEN DO:
                         ASSIGN de-valor-st = ROUND(((ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * qtde-item,2).                        

                        IF de-valor-st < 0 THEN
                           ASSIGN de-valor-st = 0.
                      
                        ASSIGN st-total = st-total + de-valor-st.
                    END.
                    ELSE DO:
                         assign de-valor-st = ped-item.vl-tot-it - ped-item.vl-liq-it - ROUND((qtde-item * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2) /*- de-frete-item*/ .
                         IF de-valor-st < 0 THEN
                            ASSIGN de-valor-st = 0.

                         /*MESSAGE ped-item.it-codigo SKIP
                                 ped-item.nr-sequencia SKIP
                                 de-valor-st
                             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

                         IF FIRST-OF(ped-item.nr-pedcli) THEN DO:
                            IF int-ped-venda.vl-frete > 0 THEN DO:
                                  ASSIGN de-valor-st = de-valor-st - int-ped-venda.vl-frete - de-vl-ipi-frete
                                         st-total    = de-valor-st.
                            END.
                            ELSE
                                  ASSIGN st-total    = de-valor-st.
                         END.
                         ELSE
                            ASSIGN st-total = st-total + de-valor-st.

                         /*MESSAGE "2222" SKIP
                                  ped-item.vl-tot-it  SKIP
                                  ped-item.vl-liq-it  SKIP
                                  ROUND((qtde-item * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2) SKIP
                                  de-valor-st
                             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 2552783*/


                    END.
                END.
            ELSE
               ASSIGN de-valor-st = 0.
               
        
        IF de-valor-st < 0 THEN
           ASSIGN de-valor-st = 0.

        run html-con-tab (string(de-valor-st,">>>>>,>>9.9999"),"right").
             
        
        IF listar-qt-aberto:CHECKED THEN DO:
          run html-con-tab (string(ped-item.vl-liq-abe,">>>>>,>>9.99"),"right").
        END.
        ELSE DO:
            IF tg-item-alocado:CHECKED THEN DO:
                ASSIGN vl-alocado = (qtde-item * ped-item.vl-preuni) + de-valor-st + valor-ipi.
                run html-con-tab (string(vl-alocado,">>>>>,>>9.99"),"right").
            END.
            ELSE 
               run html-con-tab (string(ped-item.vl-tot-it,">>>>>,>>9.99"),"right"). 
        END.
        run html-fim-lin-tab. 
    end.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.


    find first cat
         where cat.nr-pedcli-retorno = ped-venda.nr-pedcli no-lock no-error.
    if avail cat then do:
        ASSIGN l-cat = YES.
        for each cat
           where cat.nr-pedcli-retorno = ped-venda.nr-pedcli no-lock:
            if cat.nr-pedcli-venda <> "" then
                assign c-pedido-venda = if c-pedido-venda = "" then cat.nr-pedcli-venda else c-pedido-venda + "," + cat.nr-pedcli-venda.

            if cat.nr-pedcli-revenda <> "" then
                assign c-pedido-revenda = if c-pedido-revenda = "" then cat.nr-pedcli-venda else c-pedido-revenda + "," + cat.nr-pedcli-venda.
                       
           assign de-valor-mob = de-valor-mob + cat.vl-mao-obra.
        end.
    end.
    ELSE DO:
        find first cat
             where cat.nr-pedcli-revenda = ped-venda.nr-pedcli no-lock no-error.
        if avail cat then DO:
           ASSIGN l-cat-1 = YES.
        END.
        ELSE DO:
        
            find first cat
                 where cat.nr-pedcli-venda = ped-venda.nr-pedcli no-lock no-error.
            if avail cat then DO:
               ASSIGN l-cat-1 = YES.      
            END.
        END.
    END.
    /*
    find first cat
         where cat.nr-pedcli-revenda = ped-venda.nr-pedcli no-lock no-error.
    if avail cat then do:
        assign l-cat = yes.
    
        for each cat
           where cat.nr-pedcli-revenda = ped-venda.nr-pedcli no-lock:
           assign de-valor-mob = de-valor-mob + cat.vl-mao-obra
                  c-pedido-revenda = if c-pedido-revenda = "" then cat.nr-pedcli-venda else c-pedido-revenda + "," + cat.nr-pedcli-venda.
        end.
    end.
    */
    ASSIGN de-vl-frete = int-ped-venda.vl-frete.

    assign 
           c-totais = "<B>Valor do Orcamento: </B>" + string(de-vl-orcamento, ">>>,>>>,>>9.99") + "<BR>".
    assign c-totais = c-totais + 
                          "<B>    Valor do Frete: </B>" + string(int-ped-venda.vl-frete, ">>>,>>>,>>9.99") + "<BR>".
    assign c-totais = c-totais + 
                          "<B>      Valor do IPI: </B>" + string(ipi-total, ">>>,>>>,>>9.99") + "<BR>".

    IF NOT tg-item-alocado:CHECKED THEN
       ASSIGN de-valor-st = ped-venda.vl-tot-ped - ped-venda.vl-liq-ped - de-vl-ipi - de-vl-frete - de-frete-item.

     IF de-valor-st < 0 THEN
        ASSIGN de-valor-st = 0.

     
     IF listar-qt-aberto:CHECKED THEN DO:
        IF qtde-item = 0 THEN DO:                                                                
           assign c-totais = c-totais +
                                 "<B>" + "          " + c-aux2 + ": </B>" + string(0, ">>>,>>>,>>9.99") + "<BR>".
        END.
           ELSE DO:
             assign c-totais = c-totais +
                                   "<B>" + "          " + c-aux2 + ": </B>" + string(st-total, ">>>,>>>,>>9.99") + "<BR>".
           END.
     END.
        ELSE DO: 
            if de-valor-st > 0 then do:
              assign c-totais = c-totais +
                                    "<B>" + "          " + c-aux2 + ": </B>" + string(st-total, ">>>,>>>,>>9.99") + "<BR>".
            END.
        END.
    
     
/*     IF de-frete-item > 0 THEN DO:                                                                       */
/*          assign c-totais = c-totais +                                                                   */
/*                       "<B>    ST sobre Frete: </B>" + string(de-frete-item, ">>>,>>>,>>9.99") + "<BR>". */
/*     END.       
                                                                                          */
    IF tg-item-alocado:CHECKED THEN DO:
        ASSIGN de-vl-pagar = valor-a-pagar + de-vl-frete + st-total + de-vl-ipi + de-vl-ipi-frete-aux.
    END.
    ELSE DO:
        ASSIGN de-vl-pagar = valor-a-pagar + de-vl-frete + de-vl-ipi-frete-aux + de-vl-ipi + st-total.
    END.

  /*  MESSAGE "valor a pagar -> " valor-a-pagar SKIP
            "Frete -> " de-vl-frete SKIP
            "de-vl-ipi-frete -> " de-vl-ipi-frete SKIP
            "ipi-total -> " ipi-total SKIP 
            "de-vl-pagar -> " de-vl-pagar SKIP
            "de-frete-item -> " de-frete-item SKIP
            "de-vl-ipi-frete-aux -> " de-vl-ipi-frete-aux SKIP
            "de-vl-ipi -> " de-vl-ipi SKIP
            "st-total -> " st-total SKIP
            "ped-item.vl-tot-it -> " ped-item.vl-tot-it
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.   */

    assign c-totais = c-totais +                       
                      "<B>     Valor a Pagar: </B>" + string(de-vl-pagar, ">>>,>>>,>>9.99").

    run html-con-tab(c-totais,
                     "right").
    
    run html-fim-lin-tab.
    run html-ini-lin-tab.

    run pi-print-editor (input ped-venda.observacoes, input 60).
    
    assign c-observacoes-1 = "".
    
    IF INPUT FRAME fpage1 tg-observ-pedido THEN DO:
        for each tt-editor:
            assign c-observacoes-1 = c-observacoes-1 + "<B>" + tt-editor.conteudo + "</B>" + "<BR>".
        end.  
        assign c-observacoes-1 = c-observacoes-1 +
                                 "<B>VDA:_____________________________ DATA ____/____/____ HORA: __________</B><BR>" +
                                 "<B>FIN:  _____________________________ DATA ____/____/____ HORA: __________</B><BR>" +
                                 "<B>EXP:_____________________________ DATA ____/____/____ HORA: __________</B><BR>" +                             
                                 "<B>NF:   _____________________________ DATA DE SA™DA ____/____/____</B><BR>" +
                                 "<B>No DO CONHECIMENTO _______________________ ASS. DA TRANSPORTADORA: _________________</B><BR>" +
                                 "<B>DEP.( )  CHQ.( )  BOLETO( )</B><BR>" +
                                 "<B>FORMA ENVIO DE BOLETO: JUNTO COM NF( )  SEDEX ( )</B><BR><BR>".
    END.

        ASSIGN c-observacoes-1 = c-observacoes-1 +
                                 "<B>Data Validade Orcamento:</B> " + string(day(d-dt-validade),"99") 
                                                                    + "/"
                                                                    + string(month(d-dt-validade),"99")
                                                                    + "/"
                                                                    + string(year(d-dt-validade), "9999").                             
        
    if l-cat then do:
        assign c-observacoes-1 = c-observacoes-1 +
                                 "<B>Pedido venda:</B> " + c-pedido-venda + "<BR>" +
                                 "<B>Pedido revenda:</B> " + c-pedido-revenda + "<BR><BR>".
    END.
    IF l-cat-1 THEN DO:

           assign c-observacoes-1 = c-observacoes-1 +
                                 "<B>Bancos para deposito:</B><BR>" +
                                 "<B>Caixa Economica Federal</B><BR>" +
                                 "Agencia: 0941     Conta: 627-1    Operacao: 003<BR><BR>" +
                                 "<B>Itau</B><BR>" +
                                 "Agencia: 3045     Conta: 00212-2 <BR><BR>" +
                                 "<B>Bradesco</B><BR>" +
                                 "Agencia: 1875-9     Conta: 8310-0 <BR>" +
                                 "Para credito de: Maxcom do Brasil Ltda<BR><BR>" +
                                 "<B>ATEN€AO:</B><BR><BR>" +
                                 "Para agilizar a devolucao do seu equipamento, favor passar via FAX ou pelo E-MAIL (atm@maxcom.ind.br) o comprovante de deposito.<BR>" +
                                 "<B>Para liberacao do material no mesmo dia, o comprovante de pagamento deverÿ ser enviado ate² as 12:00 horas.</B><BR><BR>".
                                 
    end.
                                 
    run html-con-tab(c-observacoes-1,"left").
    run html-fim-lin-tab.
    run html-fim-tab.

    RUN esp/es0018p.p (INPUT "espdp027":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    IF CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = string(ped-venda.cod-cond-pag)) THEN DO:
        ASSIGN c-observacoes-2 = c-observacoes-2 + "<br><br><p margin-left='200'>Estou ciente de que o faturamento acima, serÿ realizado pela Intelbras, em favor da AYMORÈ CRÈDITO FINANCIAMENTO E INVESTIMENTO, conforme condicao de pagamento exposta acima.<BR><BR>" +
                                                   "______________________________________<BR>" +
                                                   "Nome:<BR>" +
                                                   "Cargo:</p><BR><BR><BR>".

        ASSIGN c_imagem_usada   = SEARCH("image/contrato_espdp027.png") 
               c-observacoes-3  = c-observacoes-3 + '<img src= ' + c_imagem_usada + ' border="0" >'.

        run html-ini-tab.
        run html-ini-lin-tab.
        run html-con-tab(c-observacoes-2,
                         "left").
        run html-fim-lin-tab.
        run html-fim-tab.
    
        run html-ini-tab.
        run html-ini-lin-tab.
        run html-con-tab(c-observacoes-3,
                         "center").
        run html-fim-lin-tab.
        run html-fim-tab.
    END.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-fim.

    output close.

    
    IF tg-email:CHECKED THEN DO:
       STATUS DEFAULT "Enviando E-Mail...".
      
       RUN piEnviaEmail(INPUT c-remetente,
                        INPUT fi-email:SCREEN-VALUE in frame fpage1,
                        INPUT trim(c-titulo),
                        INPUT "",
                        INPUT c-arquivo).
       STATUS DEFAULT.
      
       if trim(c-mess-err) <> "" then do:
          RUN ShowMessage (1, c-mess-err, "").
       end.
       RUN ShowMessage (2, "E-Mail enviado com sucesso", "").
    END.
    ELSE DO:
        RUN showMessage(2, "Arquivo gerado no diretorio -> " + fi-arq-htm:SCREEN-VALUE IN FRAME fpage1 ,"").
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraSolNota wWindow 
PROCEDURE piGeraSolNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-agente           as char no-undo.
    def var c-embarque         as char no-undo.
    def var c-desembarque      as char no-undo.
    def var de-total-compras  as decimal no-undo.
    def var c-mess-err         as char no-undo.
    def var c-nr-pedido        as char format "x(100)" no-undo.
    def var c-tit-ped          as char format "x(100)" no-undo.
    def var c-dados-empresa    as char format "x(300)" no-undo.
    def var c-dados-cliente    as char format "x(400)" no-undo.
    def var c-imagem           as char format "x(120)" no-undo.    
    def var c-complementos     as char format "x(300)" no-undo.
    def var c-mensagem1        as char format "x(500)" no-undo.
    def var c-titulo       as char  no-undo.
    def var de-total-geral     as decimal                              no-undo.
    def var de-total-sipi      as decimal                              no-undo.
    def var de-preco-sipi      as decimal                              no-undo.
    def var de-ipi             as decimal                              no-undo.
    def var de-preco-tot-aux   like de-preco-total NO-UNDO.
    def var de-desc-total      like de-preco-total NO-UNDO.
    def var de-enc             as DECIMAL NO-UNDO.
    def var de-enc-total       like ordem-compra.preco-unit NO-UNDO.
    def var c-totais           as char format "x(300)" no-undo.
    def var c-comprador        like cont-emit.nome no-undo.
    def var c-vendedor         like mgesp.atendente.nm-oper no-undo.
    def var c-desc-pagto       like cond-pagto.descricao no-undo.
    def var c-observacoes-1    as char format "x(500)" no-undo.
    def var c-desc-ad          as char no-undo.
    def var de-vl-frete        as dec no-undo.
    def var de-vl-pagar        as dec no-undo.
    def var c-cobranca         as char no-undo.
    def var c-tipo-pedido      as char no-undo.
    def var c-nat          as char extent 24 NO-UNDO       
    init ["Amostra",
          "Devol Mat Prima",
          "Devol Mat Uso Consumo",
          "Ret Rep Garantia",
          "Homologacao",
          "Material Promocional",
          "Outros",
          "Rem Curso ASTEC",
          "Rem curso MKT",
          "Rem Industrializacao",
          "Equip para Treinamen",
          "Rep Garan c/ retorno",
          "Rep Garan s/ Retorno",
          "Ret/Rem Conserto",
          "Rem Teste c/ retorno",
          "Rem Teste s/ Retorno",
          "Troca Consum Final",
          "Rem/Ret Emprestimo",
          "Troca Expressa",
          "Ret Troca Expressa",
          "Remessa Feira",
          "Remessa para Locacao",
          "Segunda Locacao",
          "Retorno Locacao"].    
    def var de-vl-orcamento like ped-item.vl-preuni no-undo.
    def var de-vl-ipi like ped-item.aliquota-ipi no-undo.
    
    def buffer bf-emitente for emitente.
    
    find emitente no-lock
         where emitente.cod-emitente = mgesp.ped-fiscal.cod-emitente NO-ERROR.
    find transporte no-lock
         where  transporte.cod-transp = mgesp.ped-fiscal.cod-transp NO-ERROR.    

    find estabelec where
         estabelec.cod-estabel = mgesp.ped-fiscal.cod-estabel no-lock no-error.
    if avail estabelec then do:
        find mgcad.empresa where
             empresa.ep-codigo = estabelec.ep-codigo no-lock no-error.
    end.

    assign c-arquivo = fi-arq-htm:screen-value in frame fpage1
           c-titulo = "Orcamento " + string(ped-fiscal.nr-pedido)
           c-cobranca = fi-cobranca:screen-value in frame fpage1
           c-tipo-pedido = fi-tipo-pedido:screen-value in frame fpage1                      
           d-dt-validade = DATE(fi-dt-validade:screen-value in frame fpage1).
           
    output to value(fi-arq-htm) CONVERT TARGET SESSION:CHARSET.

    run html-inicio ("Orcamento").


    find bf-emitente where
         bf-emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

    assign c-vendedor = "".
        
    find cond-pagto where cond-pagto.cod-cond-pag = emitente.cod-cond-pag no-lock no-error.

    if avail cond-pagto then
        assign c-desc-pagto = cond-pagto.descricao.         
        
    find first cont-emit
         where cont-emit.cod-emitente = emitente.cod-emitente no-lock no-error.
    if avail cont-emit then
        assign c-comprador = cont-emit.nome.

    assign c-data      = string(day(ped-fiscal.dt-emissao),"99") 
                       + "/"
                       + string(month(ped-fiscal.dt-emissao),"99")
                       + "/"
                       + string(year(ped-fiscal.dt-emissao), "9999")
           c-nr-pedido = "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(ped-fiscal.nr-pedido, ">>>,>>9")
                       + " - "
                       + c-data
                       + "</FONT> </TH>"                       
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + "<B>Endereco:</B> " + estabelec.endereco + " - " + estabelec.bairro + "<BR>"
                           + "<B>Cidade:</B> " + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"                          
                           + "<B>Fone:</B> "
                           + bf-emitente.telefone[1]
                           + "<BR>"
                           + "<B>Home:</B> " + bf-emitente.home-page
                           + "<BR>"                          
                           + "<B>CNPJ:</B> " + trim(string(estabelec.cgc)) + "<BR>"
                           + "<B>I.Estadual:</B> " + trim(string(estabelec.ins-estadual))
                           + "<BR>"                              
                           + "<B>Vendedor:</B> " + trim(c-vendedor)                           
                           + "<BR><BR><BR>"
                           + "<B>Transportadora:</B> " + string(mgesp.ped-fiscal.cod-transp)
           c-dados-cliente =  "<B>Cliente:</B> " + string(emitente.cod-emitente) + " - " + emitente.nome-abrev + "</B>"
                              + "<BR>"                              
                              + "<B>Razao Social:</B> " + emitente.nome-emit 
                              + "<BR>"
                              + "<B>Endereco:</B> " + emitente.endereco + " - " + emitente.bairro
                              + "<BR>"
                              + "<B>Cidade:</B> " + emitente.cidade + " - " + emitente.estado
                              + "<BR>"
                              + "<B>Fone:</B> " + emitente.telefone[1] + "  -  " + "<B>Fax:</B> " + emitente.telefax
                              + "<BR>"
                              + "<B>CNPJ:</B> " + emitente.cgc 
                              + "<BR>"                              
                              + "<B>Comprador:</B> " + trim(c-comprador)
                              + "<BR>"
                              + "<B>Cond. Pagto:</B> " + c-desc-pagto
                              + "<BR>"
                              + "<B>Cobranca:</B> " + c-cobranca                              
                              + "<BR><BR><BR>"
                              + "<B>Redespacho:</B> " 
                              c-complementos = "Condicao de Pagamento: "
                            + c-desc-pagto
                            + "<BR>Transportador:" 
                            + transporte.nome
           c-mensagem1    = "" 
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Orcamento"
                            + "</FONT>".
    
    assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#2E8B57> Intelbras </FONT> </TH>". 

    run html-ini-tab.
    
    run html-ini-lin-tab.
    
    put c-imagem skip.

    run html-cab-tab(c-tit-ped).
    
    put c-nr-pedido skip . 
    
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.    
    
    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
    
    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"  trim(c-dados-cliente) format "x(400)" "</TD>" skip. 
        
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("C½digo").
    run html-cab-tab("Descri»’o").
    
    IF INPUT FRAME fpage1 tg-classi-fiscal = YES THEN
        run html-cab-tab("Classi.Fisc"). 
    
    run html-cab-tab("Qtde").
    run html-cab-tab("Vlr. Unit.").
    run html-cab-tab("Vlr. Total").
    run html-cab-tab("D.Ad.%").
    run html-cab-tab("IPI").
    run html-fim-lin-tab.
    
    assign de-vl-orcamento = 0
           de-vl-ipi = 0.
               
    for each mgesp.it-ped-fiscal of mgesp.ped-fiscal no-lock:
        find item where item.it-codigo = it-ped-fiscal.it-codigo no-lock no-error.
        
        
        assign de-vl-orcamento = de-vl-orcamento + (it-ped-fiscal.qtde * it-ped-fiscal.vl-unit).
        
        assign de-vl-ipi  = de-vl-ipi + (it-ped-fiscal.qtde * it-ped-fiscal.vl-unit) * (it-ped-fiscal.aliquota-ipi / 100).
        
        run html-ini-lin-tab.
        run html-con-tab (it-ped-fiscal.it-codigo,"left").
        IF it-ped-fiscal.narrativa <> "" THEN
           run html-con-tab (it-ped-fiscal.narrativa,"left"). 
        ELSE
           run html-con-tab (item.desc-item,"left").
           
           IF INPUT FRAME fpage1 tg-classi-fiscal = YES THEN
               run html-con-tab (item.class-fiscal,"left").
        
        run html-con-tab (it-ped-fiscal.qtde,"right").
        run html-con-tab (string(it-ped-fiscal.vl-unit,">>>>,>>9.99"),"right").
        run html-con-tab (string((it-ped-fiscal.qtde * it-ped-fiscal.vl-unit),">>>>>,>>9.99"),"right").
        run html-con-tab (c-desc-ad,"right").
        run html-con-tab (string(((it-ped-fiscal.qtde * it-ped-fiscal.vl-unit) * (it-ped-fiscal.aliquota-ipi / 100)),">>>>>,>>9.99"),"right").
        
        run html-fim-lin-tab.
    end.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    assign de-vl-pagar = de-vl-orcamento + de-vl-ipi + de-vl-frete
           c-totais = "<B>Valor do Orcamento: </B>" + string(de-vl-orcamento, ">>>,>>>,>>9.99") + "<BR>" +
                      "<B>      Valor do IPI: </B>" + string(de-vl-ipi, ">>>,>>>,>>9.99") + "<BR>" +  
                      "<B>    Valor do Frete: </B>" + string(de-vl-frete, ">>>,>>>,>>9.99") + "<BR>" +                        
                      "<B>     Valor a Pagar: </B>" + string(de-vl-pagar, ">>>,>>>,>>9.99").

    run html-con-tab(c-totais,
                     "right").
    
    run html-fim-lin-tab.
    run html-ini-lin-tab.

    assign c-observacoes-1 = "".
    
    run pi-print-editor (input mgesp.ped-fiscal.observacao[1] + mgesp.ped-fiscal.observacao[2] + mgesp.ped-fiscal.observacao[3] + mgesp.ped-fiscal.observacao[4] + mgesp.ped-fiscal.observacao[5], input 60).

    IF INPUT FRAME fpage1 tg-observ-pedido THEN DO:
        for each tt-editor:
            assign c-observacoes-1 = c-observacoes-1 + "<B>" + tt-editor.conteudo + "</B>" + "<BR>".
        end.
        assign c-observacoes-1 = c-observacoes-1 +
                                 "<B>VDA:_____________________________ DATA ____/____/____ HORA: __________</B><BR>" +
                                 "<B>FIN:  _____________________________ DATA ____/____/____ HORA: __________</B><BR>" +
                                 "<B>EXP:_____________________________ DATA ____/____/____ HORA: __________</B><BR>" +                             
                                 "<B>NF:   _____________________________ DATA DE SA™DA ____/____/____</B><BR>" +
                                 "<B>No DO CONHECIMENTO _______________________ ASS. DA TRANSPORTADORA: _________________</B><BR>" +
                                 "<B>DEP.( )  CHQ.( )  BOLETO( )</B><BR>" +
                                 "<B>FORMA ENVIO DE BOLETO: JUNTO COM NF( )  SEDEX ( )</B><BR>".
    END.
                             
    run html-con-tab(c-observacoes-1,"left").
    run html-fim-lin-tab.
    run html-fim-tab.
    run html-ini-tab.
    run html-ini-lin-tab.
    run html-fim.
    
    output close.

    STATUS DEFAULT "Enviando E-Mail...".

    RUN piEnviaEmail(INPUT c-remetente,
                      INPUT fi-email:SCREEN-VALUE in frame fpage1,
                      INPUT trim(c-titulo),
                      INPUT "",
                      INPUT c-arquivo).
    STATUS DEFAULT.

    if trim(c-mess-err) <> "" then do:
       RUN ShowMessage (1, c-mess-err, "").
    end.
    RUN ShowMessage (2, "E-Mail enviado com sucesso", "").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

