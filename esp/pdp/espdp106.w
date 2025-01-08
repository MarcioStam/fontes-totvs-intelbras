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
{include/i-prgvrs.i ESPDP106 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP106
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   fi-nome-abrev fi-nr-pedcli btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets 
  
DEFINE INPUT PARAM i-nr-pedido LIKE int-ped-venda.nr-pedido.

DEFINE VAR v-local-entrega     AS CHAR FORMAT "x(256)".
DEFINE VAR v-endereco-completo AS CHAR FORMAT "x(256)".
DEFINE VAR v-bairro            AS CHAR FORMAT "x(256)".
DEFINE VAR v-uf                AS CHAR FORMAT "x(256)".
DEFINE VAR v-cep               AS CHAR FORMAT "x(256)".
DEFINE VAR l-erro              AS LOG.
DEFINE VAR l-tinha-dados       AS LOG.
DEFINE VAR da-agora            AS DATETIME NO-UNDO FORMAT  '99/99/9999 hh:mm:ss'.

RUN pi-carrega.

{utp/ut-glob.i}

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
btReportsJoins btExit btHelp btOK btCancel bt-limpa btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-nome-abrev fi-nr-pedcli 

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
DEFINE BUTTON bt-limpa 
     LABEL "Limpar" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-bairro AS CHARACTER FORMAT "X(100)":U 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cep AS CHARACTER FORMAT "9(8)":U 
     LABEL "CEP" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cidade AS CHARACTER FORMAT "X(100)":U 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .79 NO-UNDO.

DEFINE VARIABLE fi-desc-uf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .79 NO-UNDO.

DEFINE VARIABLE fi-endereco-completo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Endereco Completo" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 2 NO-UNDO.

DEFINE VARIABLE fi-uf AS CHARACTER FORMAT "X(256)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.


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
     fi-nome-abrev AT ROW 2.79 COL 9 COLON-ALIGNED WIDGET-ID 2
     fi-nr-pedcli AT ROW 2.79 COL 34.86 COLON-ALIGNED WIDGET-ID 4
     btOK AT ROW 12.04 COL 2
     btCancel AT ROW 12.04 COL 13
     bt-limpa AT ROW 12.04 COL 24 WIDGET-ID 6
     btHelp2 AT ROW 12.04 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 11.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-endereco-completo AT ROW 1.63 COL 15.57 COLON-ALIGNED WIDGET-ID 4
     fi-bairro AT ROW 4.08 COL 46.86 COLON-ALIGNED WIDGET-ID 16
     fi-cidade AT ROW 4.13 COL 15.57 COLON-ALIGNED WIDGET-ID 6
     fi-uf AT ROW 5.5 COL 15.57 COLON-ALIGNED WIDGET-ID 8
     fi-desc-uf AT ROW 5.5 COL 20.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-cep AT ROW 6.75 COL 15.57 COLON-ALIGNED WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 7.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
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
         HEIGHT             = 12.63
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
/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-pedcli IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN fi-desc-uf IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-uf IN FRAME fPage1
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


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wWindow
ON ENTRY OF FRAME fpage0
DO:
  //  RUN pi-carrega.

    DISABLE fi-nome-abrev   WITH FRAME fPage0.
    DISABLE fi-nr-pedcli    WITH FRAME fPage0.
    DISABLE fi-desc-uf      WITH FRAME fPage1.

    ENABLE fi-endereco-completo  WITH FRAME Fpage1.
    ENABLE fi-bairro             WITH FRAME Fpage1.
    ENABLE fi-uf                 WITH FRAME Fpage1.
    ENABLE fi-cep                WITH FRAME Fpage1.
    ENABLE fi-cidade             WITH FRAME Fpage1.

    ENABLE bt-limpa              WITH FRAME Fpage0.


    FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = i-nr-pedido NO-ERROR.
    IF NOT AVAIL int-ped-venda THEN DO:
        RETURN "NOK" .
    END.
    
    FIND FIRST ped-venda WHERE ped-venda.nr-pedido = i-nr-pedido NO-ERROR.
    
    ASSIGN fi-nome-abrev:SCREEN-VALUE IN FRAME Fpage0 = ped-venda.nome-abrev .
    ASSIGN fi-nr-pedcli:SCREEN-VALUE IN FRAME Fpage0 =  ped-venda.nr-pedcli . 


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpa wWindow
ON CHOOSE OF bt-limpa IN FRAME fpage0 /* Limpar */
DO:
    RUN pi-limpar.
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
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO: 
    /*
    ASSIGN v-local-entrega     = string(fi-local-entrega-2:SCREEN-VALUE IN FRAME Fpage1)     . 
    ASSIGN v-endereco-completo = string(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) .
    ASSIGN v-bairro            = string(fi-bairro:SCREEN-VALUE IN FRAME Fpage1).            
    ASSIGN v-uf                = string(fi-uf:SCREEN-VALUE IN FRAME Fpage1).                
    ASSIGN v-cep               = string(fi-cep:SCREEN-VALUE IN FRAME Fpage1).               
    

    MESSAGE "v-local-entrega" v-local-entrega
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = i-nr-pedido EXCLUSIVE-LOCK.    
    IF AVAIL int-ped-venda THEN DO:

        ASSIGN int-ped-venda.endereco-entrega-alternativo[1] =  v-local-entrega     .
        ASSIGN int-ped-venda.endereco-entrega-alternativo[2] =  v-endereco-completo .
        ASSIGN int-ped-venda.endereco-entrega-alternativo[3] =  v-bairro            .
        ASSIGN int-ped-venda.endereco-entrega-alternativo[4] =  v-uf                .
        ASSIGN int-ped-venda.endereco-entrega-alternativo[5] =  v-cep               .

    END.
    */

    RUN pi-salvar.

    if (return-value = 'OK') then do:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    end.

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
&Scoped-define SELF-NAME fi-cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cidade wWindow
ON F5 OF fi-cidade IN FRAME fPage1 /* Cidade */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                         &FieldZoom1="cidade"
                         &FieldScreen1="fi-cidade"
                         &Frame1="fPage1"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cidade wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cidade IN FRAME fPage1 /* Cidade */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cidade wWindow
ON RIGHT-MOUSE-DBLCLICK OF fi-cidade IN FRAME fPage1 /* Cidade */
DO:
      {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                         &FieldZoom1="cidade"
                         &FieldScreen1="fi-cidade"
                         &Frame1="fPage1"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf wWindow
ON LEAVE OF fi-uf IN FRAME fPage1 /* UF */
DO:
   FIND FIRST unid-feder WHERE unid-feder.estado = fi-uf:SCREEN-VALUE IN FRAME Fpage1
                           AND unid-feder.pais =  "BRASIL" NO-ERROR.
   IF AVAIL unid-feder THEN DO:
       ASSIGN fi-desc-uf:SCREEN-VALUE IN FRAME Fpage1 = unid-feder.no-estado .
   END.
   ELSE DO:
       ASSIGN fi-desc-uf:SCREEN-VALUE IN FRAME Fpage1 = ? .
   END.
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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega wWindow 
PROCEDURE pi-carrega :
FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = i-nr-pedido NO-ERROR.
IF NOT AVAIL int-ped-venda THEN DO:
    RETURN "NOK" .
END.

FIND FIRST ped-venda WHERE ped-venda.nr-pedido = i-nr-pedido NO-ERROR.

ASSIGN fi-nome-abrev:SCREEN-VALUE IN FRAME Fpage0 = ped-venda.nome-abrev .
ASSIGN fi-nr-pedcli:SCREEN-VALUE IN FRAME Fpage0 =  ped-venda.nr-pedcli . 

FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = i-nr-pedido NO-ERROR.
IF AVAIL int-ped-venda THEN DO:

   ASSIGN fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1 = endereco-entrega-alternativo[2].
   ASSIGN fi-bairro:SCREEN-VALUE IN FRAME Fpage1            = endereco-entrega-alternativo[3]. 
   ASSIGN fi-uf:SCREEN-VALUE IN FRAME Fpage1                = endereco-entrega-alternativo[4].
   ASSIGN fi-cep:SCREEN-VALUE IN FRAME Fpage1               = endereco-entrega-alternativo[5].
   ASSIGN fi-cidade:SCREEN-VALUE IN FRAME Fpage1            = endereco-entrega-alternativo[6].

   FIND FIRST unid-feder WHERE unid-feder.estado = fi-uf:SCREEN-VALUE IN FRAME Fpage1
                           AND unid-feder.pais =  "BRASIL" NO-ERROR.
   IF AVAIL unid-feder THEN DO:
       ASSIGN fi-desc-uf:SCREEN-VALUE IN FRAME Fpage1 = unid-feder.no-estado .
   END.

   //Se o pedido ja foi atendido parcial nao vamos deixar com que os dados sejam apagados 
   IF ped-venda.cod-sit-ped > 1 THEN DO:
      ASSIGN l-tinha-dados = YES.
   END.
    
END.


ASSIGN fi-nome-abrev:SCREEN-VALUE IN FRAME Fpage0 = "BLABA" . ped-venda.nome-abrev .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpar wWindow 
PROCEDURE pi-limpar :
ASSIGN fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1 = "" .
   ASSIGN fi-bairro:SCREEN-VALUE IN FRAME Fpage1            = "" . 
   ASSIGN fi-uf:SCREEN-VALUE IN FRAME Fpage1                = "" .
   ASSIGN fi-cep:SCREEN-VALUE IN FRAME Fpage1               = "" . 
   ASSIGN fi-desc-uf:SCREEN-VALUE IN FRAME Fpage1           = "" .
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = i-nr-pedido EXCLUSIVE-LOCK. 

FIND FIRST unid-feder WHERE unid-feder.estado = fi-uf:SCREEN-VALUE IN FRAME Fpage1
                       AND unid-feder.pais =  "BRASIL" NO-ERROR.
IF NOT AVAIL unid-feder THEN DO:
   MESSAGE "Estado n∆o encontrado"
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   RETURN "NOK".
END.

ASSIGN l-erro = NO . 

//Vamos validar se algum campo ficou sem preencher

IF length(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) > 0  THEN DO:
   IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1)        = 0  THEN l-erro = YES.
   IF length(fi-uf:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
   IF INT(fi-cep:SCREEN-VALUE IN FRAME Fpage1)              = 0  THEN l-erro = YES.
   IF length(fi-cidade:SCREEN-VALUE IN FRAME Fpage1)        = 0  THEN l-erro = YES.
END.

IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1) > 0  THEN DO:
   IF length(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) = 0  THEN l-erro = YES.
   IF length(fi-uf:SCREEN-VALUE IN FRAME Fpage1)                = 0  THEN l-erro = YES.
   IF INT(fi-cep:SCREEN-VALUE IN FRAME Fpage1)                  = 0  THEN l-erro = YES.
   IF length(fi-cidade:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
END.

IF length(fi-uf:SCREEN-VALUE IN FRAME Fpage1) > 0  THEN DO:
   IF length(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) = 0  THEN l-erro = YES.
   IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
   IF INT(fi-cep:SCREEN-VALUE IN FRAME Fpage1)                  = 0  THEN l-erro = YES.
   IF length(fi-cidade:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
END.

IF length(string(fi-cep:SCREEN-VALUE IN FRAME Fpage1)) > 0  THEN DO:
   IF length(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) = 0  THEN l-erro = YES.
   IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
   IF length(fi-uf:SCREEN-VALUE IN FRAME Fpage1)                = 0  THEN l-erro = YES.
   IF length(fi-cidade:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
END.

IF length(fi-cidade:SCREEN-VALUE IN FRAME Fpage1) > 0  THEN DO:
   IF length(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1) = 0  THEN l-erro = YES.
   IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1)            = 0  THEN l-erro = YES.
   IF length(fi-uf:SCREEN-VALUE IN FRAME Fpage1)                = 0  THEN l-erro = YES.
   IF INT(fi-cep:SCREEN-VALUE IN FRAME Fpage1)                  = 0  THEN l-erro = YES.
END.

IF l-erro THEN DO:
    MESSAGE "Verifique se todos os campos foram devidamente preenchidos"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

IF l-tinha-dados THEN DO:
     IF LENGTH(fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1)  = 0  THEN l-erro = YES.             
     IF LENGTH(fi-bairro:SCREEN-VALUE IN FRAME Fpage1)             = 0  THEN l-erro = YES.  
     IF LENGTH(fi-uf:SCREEN-VALUE IN FRAME Fpage1)                 = 0  THEN l-erro = YES.  
     IF LENGTH(fi-cidade:SCREEN-VALUE IN FRAME Fpage1)             = 0  THEN l-erro = YES. 
     IF INT(fi-cep:SCREEN-VALUE IN FRAME Fpage1)                   = 0  THEN l-erro = YES.  
END.

IF l-erro THEN DO:
    MESSAGE "Uma vez que os dados de endereco alternativo de entrega ja tenham sido definidos nao podem mais ser apagados"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

FIND FIRST mgcad.cidade NO-LOCK WHERE mgcad.cidade.cidade = fi-cidade:SCREEN-VALUE IN FRAME Fpage1 NO-ERROR.
IF NOT AVAIL mgcad.cidade THEN DO:
    MESSAGE "Cidade informada n∆o existe no cadastro de cidades"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.



ASSIGN da-agora = NOW.

IF AVAIL int-ped-venda THEN DO:
    ASSIGN int-ped-venda.endereco-entrega-alternativo[1]  = fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1 .
    ASSIGN int-ped-venda.endereco-entrega-alternativo[2]  = fi-endereco-completo:SCREEN-VALUE IN FRAME Fpage1 .
    ASSIGN int-ped-venda.endereco-entrega-alternativo[3]  = fi-bairro:SCREEN-VALUE IN FRAME Fpage1. 
    ASSIGN int-ped-venda.endereco-entrega-alternativo[4]  = fi-uf:SCREEN-VALUE IN FRAME Fpage1.
    ASSIGN int-ped-venda.endereco-entrega-alternativo[5]  = string(fi-cep:SCREEN-VALUE IN FRAME Fpage1).
    ASSIGN int-ped-venda.endereco-entrega-alternativo[6]  = fi-cidade:SCREEN-VALUE IN FRAME Fpage1.
    ASSIGN int-ped-venda.endereco-entrega-alternativo[10] = int-ped-venda.endereco-entrega-alternativo[10] + " | Alterado por: " + c-seg-usuario + " " + STRING(da-agora) .
END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

