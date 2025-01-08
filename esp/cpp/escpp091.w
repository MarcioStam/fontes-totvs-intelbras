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
{include/i-prgvrs.i ESCPP091 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP091
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-cod-estabel bt-mostra ed-info fi-status btQueryJoins btReportsJoins btExit btHelp ~
                              btHelp2 bt-bloquear bt-desbloquear ed-email fi-email
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}
{esapi/esapi010tt.i}
{utp/utapi019.i}
{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE BUFFER b-conteudo FOR conteudo-programa.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-2 RECT-3 ~
btQueryJoins btReportsJoins btExit btHelp ed-info bt-mostra fi-cod-estabel ~
rs-status ed-email bt-bloquear bt-desbloquear btHelp2 fi-status fi-email 
&Scoped-Define DISPLAYED-OBJECTS ed-info fi-cod-estabel rs-status ed-email ~
fi-status fi-email 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-seq-conteudo wWindow 
FUNCTION f-seq-conteudo RETURNS INTEGER
  ( INPUT p-cod-programa AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON bt-bloquear 
     LABEL "Bloquear" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-desbloquear 
     LABEL "Desbloquear" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-mostra 
     IMAGE-UP FILE "image/im-cq.bmp":U NO-CONVERT-3D-COLORS
     LABEL "Button 1" 
     SIZE 5 BY 1.25.

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

DEFINE VARIABLE ed-email AS CHARACTER INITIAL "grupo.controladores@intelbras.com.br" 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 43 BY 3.08 NO-UNDO.

DEFINE VARIABLE ed-info AS CHARACTER INITIAL "Este programa Bloqueia/Desbloqueia o Reporte de Produá∆o e a Emiss∆o de Ordens de Produá∆o para realizaá∆o do Planejamento." 
     VIEW-AS EDITOR
     SIZE 47 BY 1.75 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(256)":U INITIAL "Avisar por E-mail (separar por ~;)" 
      VIEW-AS TEXT 
     SIZE 22 BY .67 NO-UNDO.

DEFINE VARIABLE fi-status AS CHARACTER FORMAT "X(256)":U INITIAL "Status Atual" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE rs-status AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Desbloqueado", 1,
"Bloqueado", 2
     SIZE 15.29 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 4.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.5.

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
     ed-info AT ROW 3 COL 22 NO-LABEL WIDGET-ID 2
     bt-mostra AT ROW 5.38 COL 50 WIDGET-ID 28
     fi-cod-estabel AT ROW 5.54 COL 38 COLON-ALIGNED WIDGET-ID 22
     rs-status AT ROW 7.58 COL 38 NO-LABEL WIDGET-ID 4
     ed-email AT ROW 11.25 COL 24 NO-LABEL WIDGET-ID 16
     bt-bloquear AT ROW 15.46 COL 2.14 WIDGET-ID 12
     bt-desbloquear AT ROW 15.46 COL 18.14 WIDGET-ID 14
     btHelp2 AT ROW 15.46 COL 80
     fi-status AT ROW 7 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-email AT ROW 10.17 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 15.25 COL 1
     RECT-1 AT ROW 7.33 COL 22 WIDGET-ID 8
     RECT-2 AT ROW 10.5 COL 22 WIDGET-ID 18
     RECT-3 AT ROW 5.25 COL 22 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.71
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
         HEIGHT             = 15.71
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
       ed-info:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME bt-bloquear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bloquear wWindow
ON CHOOSE OF bt-bloquear IN FRAME fpage0 /* Bloquear */
DO:

    RUN pi-muda-status("bloqueia").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desbloquear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desbloquear wWindow
ON CHOOSE OF bt-desbloquear IN FRAME fpage0 /* Desbloquear */
DO:

    RUN pi-muda-status("liberado").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mostra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mostra wWindow
ON CHOOSE OF bt-mostra IN FRAME fpage0 /* Button 1 */
DO:

    RUN pi-mostra-status.
  
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.

    RUN pi-mostra-status.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email wWindow 
PROCEDURE pi-envia-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-emails AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.


    FOR FIRST param-global NO-LOCK:
    END.

    ASSIGN c-emails = INPUT FRAME fPage0 ed-email.

    IF NUM-ENTRIES(c-emails, ";") < 1 THEN
        RETURN.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail             /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail            /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                           /* Destinat†rio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"             /* Remetente          */ 
           tt-envio2.arq-anexo         = ""                                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "O reporte de produá∆o foi ".

    IF INPUT FRAME fPage0 rs-status = 1 THEN
        ASSIGN tt-envio2.assunto    = "Desbloqueio de Reporte de Produá∆o"  /* Assunto            */
               tt-mensagem.mensagem = tt-mensagem.mensagem + "DESBLOQUEADO para o estabelecimento " + INPUT FRAME fPage0 fi-cod-estabel + "." + CHR(13) + "Plano de produá∆o foi finalizado.". 
    ELSE
        ASSIGN tt-envio2.assunto    = "Bloqueio de Reporte de Produá∆o"  /* Assunto            */
               tt-mensagem.mensagem = tt-mensagem.mensagem + "BLOQUEADO para o estabelecimento " + INPUT FRAME fPage0 fi-cod-estabel + "." + CHR(13) + "Plano de produá∆o est† em execuá∆o.".

    ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + CHR(13) + CHR(13) + "D£vidas, entrar em contato com o PCM." + CHR(13) + CHR(13).


    EMPTY TEMP-TABLE tt-erros.
    EMPTY TEMP-TABLE tt-erro.

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    FOR EACH tt-erros:
        CREATE tt-erro.
        ASSIGN iCont             = iCont + 1
               tt-erro.i-sequen  = iCont
               tt-erro.cd-erro   = tt-erros.cod-erro
               tt-erro.mensagem  = tt-erros.desc-erro + tt-erros.desc-arq.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

    END.


    DELETE PROCEDURE h-utapi019.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-status wWindow 
PROCEDURE pi-mostra-status :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont  AS HANDLE      NO-UNDO.

    ASSIGN rs-status = 1.

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "bloq-rep"
        AND   ponto-programa.ponto         = 1:

        FOR FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND   entry(1, conteudo-programa.conteudo, ";") = fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0
            AND   entry(2, conteudo-programa.conteudo, ";") = "bloqueia":

            ASSIGN rs-status = 2.

        END.

    END.

    DISP rs-status WITH FRAME fPage0.

    ASSIGN ed-email:SCREEN-VALUE IN FRAME fPage0 = 'grupo.controladores@intelbras.com.br'.

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "escpp091"
          AND ponto-programa.ponto         = 1:

        FOR FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND ENTRY(1,conteudo-programa.conteudo, ";") = fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0:
            ASSIGN c-email = SUBSTRING(conteudo-programa.conteudo,INDEX(conteudo-programa.conteudo,ENTRY(2,conteudo-programa.conteudo, ";")) ).
        END.                 

        ASSIGN ed-email:SCREEN-VALUE IN FRAME fPage0 = ed-email:SCREEN-VALUE IN FRAME fPage0 + ';' + c-email.
    END.
















END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-status wWindow 
PROCEDURE pi-muda-status :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-status AS CHAR NO-UNDO.


    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "bloq-rep"
        AND   ponto-programa.ponto         = 1:

        FOR FIRST conteudo-programa EXCLUSIVE-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND   entry(1, conteudo-programa.conteudo, ";") = fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0:
        END.

        IF NOT AVAIL conteudo-programa THEN DO:

            CREATE conteudo-programa.
            ASSIGN conteudo-programa.cod-programa = ponto-programa.cod-programa
                   conteudo-programa.sequencia    = f-seq-conteudo(ponto-programa.cod-programa).

        END.

        ASSIGN conteudo-programa.conteudo = fi-cod-estabel:SCREEN-VALUE IN FRAME fpage0 + ";" + p-status.

        RELEASE conteudo-programa.

        RUN pi-mostra-status.

        RUN pi-envia-email.

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 19085,
                           INPUT "Processo conclu°do com sucesso.").

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-seq-conteudo wWindow 
FUNCTION f-seq-conteudo RETURNS INTEGER
  ( INPUT p-cod-programa AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR LAST b-conteudo NO-LOCK USE-INDEX ind-prog-seq
        WHERE b-conteudo.cod-programa = p-cod-programa:

        RETURN b-conteudo.sequencia + 1.

    END.

    RETURN 1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

