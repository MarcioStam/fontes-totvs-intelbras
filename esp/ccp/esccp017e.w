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
{include/i-prgvrs.i esccp017 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp017
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   parecer rs-condicao avaliador cod-acao quantidade cod-situacao lg-email ~
                              arquivo-anexo btFile
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
def input parameter p-rw-homologacao        as rowid        no-undo.
def input parameter p-rw-lote-hml           as rowid        no-undo.
def input parameter lg-habilita             as log          no-undo.
/* Local Variable Definitions ---                                       */
def var i-nr-pend       like pend-mi.numero         no-undo.
def var c-endereco      as char                     no-undo.

/* variaveis do zoom */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

{utp/utapi019.i}

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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE parecer AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 350
     SIZE 76 BY 4.42 NO-UNDO.

DEFINE VARIABLE arquivo-anexo AS CHARACTER FORMAT "X(200)":U 
     LABEL "Arquivo Anexo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE avaliador AS CHARACTER FORMAT "X(12)" 
     LABEL "Avaliador" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cod-acao AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Aá∆o" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cod-situacao AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE Descricao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE Descricao-sit AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE quantidade AS DECIMAL FORMAT ">>,>>>,>>9.9999" INITIAL 0 
     LABEL "Nova Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE rs-condicao AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Aprovado", yes,
"Rejeitado", no
     SIZE 28 BY .75 NO-UNDO.

DEFINE VARIABLE lg-email AS LOGICAL INITIAL no 
     LABEL "Envia e-mail" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     parecer AT ROW 1.75 COL 4 NO-LABEL WIDGET-ID 2
     rs-condicao AT ROW 6.63 COL 16 NO-LABEL WIDGET-ID 8
     avaliador AT ROW 7.5 COL 14 COLON-ALIGNED WIDGET-ID 26
     cod-acao AT ROW 8.5 COL 14 COLON-ALIGNED WIDGET-ID 14
     Descricao AT ROW 8.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     quantidade AT ROW 9.5 COL 14 COLON-ALIGNED WIDGET-ID 18
     cod-situacao AT ROW 10.5 COL 14 COLON-ALIGNED WIDGET-ID 20
     Descricao-sit AT ROW 10.5 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     lg-email AT ROW 11.5 COL 16 WIDGET-ID 24
     arquivo-anexo AT ROW 11.5 COL 39 COLON-ALIGNED WIDGET-ID 30
     btFile AT ROW 11.5 COL 76 HELP
          "Escolha do nome do arquivo" WIDGET-ID 28
     "Parecer" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.25 COL 5 WIDGET-ID 6
     "Condiá∆o:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 6.67 COL 8 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.25
         SIZE 84.43 BY 11.58
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME arquivo-anexo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL arquivo-anexo wWindow
ON LEAVE OF arquivo-anexo IN FRAME fPage1 /* Arquivo Anexo */
DO:
/*
    IF R-INDEX(INPUT arquivo-anexo, ".htm") = 0
    AND R-INDEX(INPUT arquivo-anexo, ".html") = 0 THEN 
        DISP INPUT arquivo-anexo + ".html" @ arquivo-anexo WITH FRAME fpage1.
  */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fPage1
DO:
    def var l-ok       as log          no-undo.

    SYSTEM-DIALOG GET-FILE arquivo-anexo
      FILTERS "Todos os arquivos(*.*)" "*.*"
      INITIAL-FILTER 1
      ASK-OVERWRITE 
      DEFAULT-EXTENSION "html"
      SAVE-AS
      UPDATE l-ok.

    IF l-ok THEN DISP arquivo-anexo WITH FRAME fpage1.
  
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
       
    if not lg-habilita
    then APPLY "CLOSE":U TO THIS-PROCEDURE.
    else do:
        
        run piValidaDados.
        if return-value = 'NOK'
        then return no-apply.  

        find lote-hml where rowid(lote-hml) = p-rw-lote-hml exclusive-lock no-error.
        assign lote-hml.parecer[1]   = substring(frame fPage1 parecer,1,70)
               lote-hml.parecer[2]   = substring(frame fPage1 parecer,71,70)
               lote-hml.parecer[3]   = substring(frame fPage1 parecer,141,70)
               lote-hml.parecer[4]   = substring(frame fPage1 parecer,211,70)
               lote-hml.parecer[5]   = substring(frame fPage1 parecer,281,70)
               lote-hml.data-parecer = today
               lote-hml.usuario      = c-seg-usuario.
        find lote-hml where rowid(lote-hml) = p-rw-lote-hml no-lock no-error.
    
        find homologacao where rowid(homologacao) = p-rw-homologacao exclusive-lock no-error.
        assign homologacao.situacao     = frame fPage1 cod-situacao
               homologacao.data-ult-sit = today.
        find homologacao where rowid(homologacao) = p-rw-homologacao no-lock no-error.
    
        
        find avaliacao where avaliacao.nr-processo = lote-hml.nr-processo
                         and avaliacao.nr-lote     = lote-hml.nr-lote 
                         no-error.
        if not avail avaliacao
        then do:
            create avaliacao.
            assign avaliacao.nr-processo = lote-hml.nr-processo
                   avaliacao.nr-lote     = lote-hml.nr-lote.
        end.
    
        assign avaliacao.avaliador   = frame fPage1 avaliador
               avaliacao.aprovado    = frame fPage1 rs-condicao
               avaliacao.cod-acao    = frame fPage1 cod-acao
               avaliacao.quantidade  = frame fPage1 quantidade.
               
        if lote-hml.cod-lote = 1 
        and frame fPage1 rs-condicao
        and frame fPage1 lg-email
        then do:
            
            find last pend-mi use-index numero no-lock no-error.
            if not avail pend-mi then
                assign i-nr-pend = 1.
            else
                assign i-nr-pend = pend-mi.numero + 1.
                
            find item where item.it-codigo = homologacao.it-codigo no-lock no-error.
            find comprador where comprador.cod-comprado = item.cod-comprado no-lock no-error.
            find fabricante where fabricante.cod-fabric = homologacao.cod-fabric no-lock no-error.
    
            create pend-mi.
            assign pend-mi.numero      = i-nr-pend
                   pend-mi.data        = today
                   pend-mi.hora        = string(time,"HH:MM:SS")
                   pend-mi.cod-usuario = 22720
                   pend-mi.situacao    = "A"
                   pend-mi.tipo        = 9
                   pend-mi.problema    = "Amostra Aprovada na Homologacao"
                   pend-mi.solicitacao = "Item: " + homologacao.it-codigo  + " - " + item.descricao-1 
                                       + item.descricao-2 + chr(10) + "Fabricante: " 
                                       + string(homologacao.cod-fabric) + " - " + fabricante.nome
                                       + chr(10) + "Comprador: " + item.cod-comprado + " - " + comprador.nome.
            find first ponto-programa
                 where ponto-programa.nome-programa = "esccp017"
                   and ponto-programa.ponto         = 1
                   and ponto-programa.tipo          = 4     /*conta*/ 
                   no-lock no-error.
            if avail ponto-programa
            then do:
                find first conteudo-programa
                     where conteudo-programa.cod-programa = ponto-programa.cod-programa
                       and conteudo-programa.sequencia    = 2
                       no-lock no-error.
                 if avail conteudo-programa
                 then assign pend-mi.cc-codigo = conteudo-programa.conteudo.
            end.           
        end.
                       
        if frame fPage1 lg-email
        then do:
        
            find usuar_mestre where usuar_mestre.cod_usuario = homologacao.solicitante no-lock no-error.
            if avail usuar_mestre
            then do:
                assign c-endereco = usuar_mestre.cod_e_mail_local.
            end.
            else assign c-endereco = "grupo.compras@intelbras.com.br".

        
            RUN piEnviaEmail(INPUT "ems@intelbras.com.br",
                             INPUT c-endereco,
                             INPUT "Amostra de Homologacao",
                             INPUT frame fPage1 parecer,
                             INPUT frame fPage1 arquivo-anexo).
                                     
        end.
    end.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cod-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-acao wWindow
ON F5 OF cod-acao IN FRAME fPage1 /* Aá∆o */
DO:
    /*{include/zoomvar.i &prog-zoom="eszoom/z01es002"
                       &campo="cod-acao"
                       &campozoom="cod-acao"
                       &campo2="descricao"
                       &campozoom2="descricao"
                       &frame="fPage1"}*/
                       

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es002.w"
                         &FieldZoom1="cod-acao"
                         &FieldScreen1="cod-acao"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="descricao"
                         &Frame2="fPage1"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-acao wWindow
ON LEAVE OF cod-acao IN FRAME fPage1 /* Aá∆o */
DO:
  find acao where acao.cod-acao = frame fPage1 cod-acao no-lock no-error.
  if avail acao
  then assign descricao:screen-value in frame fPage1 = acao.descricao.
  else assign descricao:screen-value in frame fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-acao wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-acao IN FRAME fPage1 /* Aá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-situacao wWindow
ON F5 OF cod-situacao IN FRAME fPage1 /* Situaá∆o */
DO:
    /*{include/zoomvar.i &prog-zoom="eszoom/z01es173"
                       &campo="cod-situacao"
                       &campozoom="cod-situacao"
                       &campo2="descricao-sit"
                       &campozoom2="descricao"
                       &frame="fPage1"}*/
                       

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es173.w"
                         &FieldZoom1="cod-situacao"
                         &FieldScreen1="cod-situacao"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="descricao-sit"
                         &Frame2="fPage1"
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-situacao wWindow
ON LEAVE OF cod-situacao IN FRAME fPage1 /* Situaá∆o */
DO:
  find situacao where situacao.cod-situacao = frame fPage1 cod-situacao no-lock no-error.
  if avail situacao
  then assign descricao-sit:screen-value in frame fPage1 = situacao.descricao.
  else assign descricao-sit:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-situacao wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-situacao IN FRAME fPage1 /* Situaá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-email wWindow
ON VALUE-CHANGED OF lg-email IN FRAME fPage1 /* Envia e-mail */
DO:
  if frame fPage1 lg-email = yes
  then enable arquivo-anexo
              btFile
              with frame fPage1.
  else disable arquivo-anexo
               btFile
               with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
cod-acao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
cod-situacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableWidgets wWindow 
PROCEDURE afterEnableWidgets :
if not lg-habilita
 then disable parecer
              rs-condicao
              avaliador
              cod-acao
              descricao
              quantidade
              cod-situacao
              descricao-sit
              lg-email
              with frame fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayWidgets wWindow 
PROCEDURE beforeDisplayWidgets :
find homologacao where rowid(homologacao) = p-rw-homologacao no-lock no-error.
    find lote-hml where rowid(lote-hml) = p-rw-lote-hml no-lock no-error.
    
    assign parecer = lote-hml.parecer[1] + lote-hml.parecer[2] + lote-hml.parecer[3]
                   + lote-hml.parecer[4] + lote-hml.parecer[5].
                   
    
    find avaliacao where avaliacao.nr-processo = lote-hml.nr-processo
                     and avaliacao.nr-lote     = lote-hml.nr-lote 
                     no-error.
    if avail avaliacao 
    then do:
        assign rs-condicao  = avaliacao.aprovado
               avaliador    = avaliacao.avaliador
               cod-acao     = avaliacao.cod-acao
               quantidade   = avaliacao.quantidade
               cod-situacao = homologacao.situacao.
                
        find acao where acao.cod-acao = cod-acao no-lock no-error.
        if avail acao
        then assign descricao = acao.descricao.
        
        find situacao where situacao.cod-situacao = cod-situacao no-lock no-error.
        if avail situacao
        then assign descricao-sit = situacao.descricao.
    end.
                   
    disp parecer
         rs-condicao
         avaliador
         cod-acao
         descricao
         quantidade
         cod-situacao
         descricao-sit
         with frame fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wWindow 
PROCEDURE piEnviaEmail :
DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)'       NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)'   NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)'   NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(250)'  NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(200)'  NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinat†rio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDados wWindow 
PROCEDURE piValidaDados :
find acao where acao.cod-acao = frame fPage1 cod-acao no-lock no-error.
    if not avail acao
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Aá∆o n∆o cadastrada.").
        return 'NOK'.
    end.

    find situacao where situacao.cod-situacao = frame fPage1 cod-situacao no-lock no-error.
    if not avail situacao
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Situaá∆o n∆o cadastrada.").
        return 'NOK'.
    end.
    
    if  frame fPage1 arquivo-anexo <> ""
    and search(frame fPage1 arquivo-anexo) = ?
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Arquivo anexo inv†lido.").
        return 'NOK'.
    end.

    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

