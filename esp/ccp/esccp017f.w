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
{include/i-prgvrs.i esccp017F 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp017F
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   cc-codigo 
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

def input parameter p-rw-homologacao    as rowid                no-undo.
def input parameter p-rw-lote-hml       as rowid                no-undo.

/* Local Variable Definitions ---                                       */

def var i-nr-teste      as int          no-undo.

/* Variaveis do zoom */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

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
     SIZE 71 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 71 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cc-codigo AS CHARACTER FORMAT "X(8)":U 
     LABEL "µrea" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE descricao AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 54.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 58.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 62.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 66.72 HELP
          "Ajuda"
     btOK AT ROW 11.96 COL 2
     btCancel AT ROW 11.96 COL 13
     btHelp2 AT ROW 11.96 COL 60.72
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 11.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.43 BY 12.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     cc-codigo AT ROW 3.25 COL 12 COLON-ALIGNED WIDGET-ID 2
     descricao AT ROW 3.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 67.43 BY 7.25
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
         HEIGHT             = 12.58
         WIDTH              = 71.86
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
    find homologacao where rowid(homologacao) = p-rw-homologacao no-lock no-error.  
    find lote-hml where rowid(lote-hml) = p-rw-lote-hml no-lock no-error.
    
    run piValidaDados.
    if return-value = 'NOK'
    then return no-apply.  
  
  
    find last teste
        where teste.nr-processo = lote-hml.nr-processo
          and teste.nr-lote     = lote-hml.nr-lote
          no-lock no-error.
    if avail teste
    then assign i-nr-teste = teste.nr-teste + 1.
    else assign i-nr-teste = 1.

    create teste.
    assign teste.nr-processo      = lote-hml.nr-processo
           teste.nr-lote          = lote-hml.nr-lote
           teste.nr-teste         = i-nr-teste
           teste.cc-codigo        = frame fPage1 cc-codigo
           teste.data-solicitacao = today.
  
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
&Scoped-define SELF-NAME cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-codigo wWindow
ON F5 OF cc-codigo IN FRAME fPage1 /* µrea */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in042"
                       &campo="cc-codigo"
                       &campozoom="cc-codigo"
                       &campo2="descricao"
                       &campozoom2="descricao"
                       &frame="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-codigo wWindow
ON LEAVE OF cc-codigo IN FRAME fPage1 /* µrea */
DO:
    find centro-custo where centro-custo.cc-codigo = frame fPage1 cc-codigo no-lock no-error.
    if avail centro-custo
    then assign descricao:screen-value in frame fPage1 = centro-custo.descricao.
    else assign descricao:screen-value in frame fPage1 = "".
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF cc-codigo IN FRAME fPage1 /* µrea */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDados wWindow 
PROCEDURE piValidaDados :
find centro-custo where centro-custo.cc-codigo = frame fPage1 cc-codigo no-lock no-error.
    if not avail centro-custo
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "µrea n∆o cadastrada.").
        return 'NOK'.
    end.
    
    if centro-custo.nr-up-report <> 1
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "UPs Reportadas da µrea Ç diferente de 1.").
        return 'NOK'.
    end.
    
    find tipo-lote where tipo-lote.cod-lote = lote-hml.cod-lote no-lock no-error.
    
    find first ponto-programa
         where ponto-programa.nome-programa = "esccp017"
           and ponto-programa.ponto         = 1
           and ponto-programa.tipo          = 4     /*conta*/ 
           no-lock no-error.
    if avail ponto-programa
    then do:
        if tipo-lote.cod-lote = 1  
        then do:       
            if homologacao.it-codigo begins "104"
            or homologacao.it-codigo begins "116"
            or homologacao.it-codigo begins "117"
            or homologacao.it-codigo begins "123"
            or homologacao.it-codigo begins "124"
            or homologacao.it-codigo begins "134"
            or homologacao.it-codigo begins "156"
            then do:
                find first conteudo-programa
                     where conteudo-programa.cod-programa = ponto-programa.cod-programa
                       and conteudo-programa.sequencia    = 4
                       no-lock no-error.
                if avail conteudo-programa
                then do:
                    IF INDEX(conteudo-programa.conteudo, centro-custo.cc-codigo) = 0
                    then do:
                        run utp/ut-msgs.p (INPUT "SHOW":U, 
                                           INPUT 17567, 
                                           INPUT "As amostras ser∆o avaliadas somente pela †rea Respons†vel.").
                        return 'NOK'.    
                    end.
                end.
            end.
            else
                if homologacao.it-codigo begins "112"
                or homologacao.it-codigo begins "122"
                then do:
                    find first conteudo-programa
                         where conteudo-programa.cod-programa = ponto-programa.cod-programa
                           and conteudo-programa.sequencia    = 3
                           no-lock no-error.
                    if avail conteudo-programa
                    then do:
                        IF INDEX(conteudo-programa.conteudo, centro-custo.cc-codigo) = 0
                        then do:
                            run utp/ut-msgs.p (INPUT "SHOW":U, 
                                               INPUT 17567, 
                                               INPUT "As amostras ser∆o avaliadas somente pela †rea Respons†vel.").
                            return 'NOK'.    
                        end.
                    end.
                end.
                else
                    if homologacao.it-codigo begins "126"
                    then do:
                        find first conteudo-programa
                             where conteudo-programa.cod-programa = ponto-programa.cod-programa
                               and conteudo-programa.sequencia    = 5
                               no-lock no-error.
                        if avail conteudo-programa
                        then do:
                            IF INDEX(conteudo-programa.conteudo, centro-custo.cc-codigo) = 0
                            then do:
                                run utp/ut-msgs.p (INPUT "SHOW":U, 
                                                   INPUT 17567, 
                                                   INPUT "As amostras ser∆o avaliadas somente pela †rea Respons†vel.").
                                return 'NOK'.    
                            end.
                        end.
                    end.
                    else do:
                        find first conteudo-programa
                             where conteudo-programa.cod-programa = ponto-programa.cod-programa
                               and conteudo-programa.sequencia    = 2
                               no-lock no-error.
                        if avail conteudo-programa
                        then do:
                            IF INDEX(conteudo-programa.conteudo, centro-custo.cc-codigo) = 0
                            then do:
                                run utp/ut-msgs.p (INPUT "SHOW":U, 
                                                   INPUT 17567, 
                                                   INPUT "As amostras ser∆o avaliadas somente pela †rea Respons†vel.").
                                return 'NOK'.    
                            end.
                        end.
                 end.    
        end.
    end.
    
    find first teste
         where teste.nr-processo = lote-hml.nr-processo
           and teste.nr-lote     = lote-hml.nr-lote
           and teste.cc-codigo   = centro-custo.cc-codigo
           no-lock no-error.
    if avail teste 
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Esta †rea j† foi associada a este lote.").
        return 'NOK'.        
    end.
    
    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

