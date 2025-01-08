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
{include/i-prgvrs.i ES0019 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

/*{src/web/method/wrap-cgi.i}*/
{utp/ut-glob.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ES0019
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btExit btDesconectar c-usuario c-senha c-usuario-desconecta
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&GLOBAL-DEFINE Program        es0019
&GLOBAL-DEFINE Version        2.00.000.000
&SCOPED-DEFINE RPC-CALL       esp/es0019.r

def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_impres_layout AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_tit_prog_dtsul AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rotina_intelbras AS CHAR NO-UNDO.
def new shared stream WebStream.

DEF VAR hprog AS HANDLE NO-UNDO.
DEF VAR hproc AS HANDLE NO-UNDO.
DEF VAR i-acao AS INTEGER NO-UNDO.
DEF VAR c-msg-erro AS CHAR NO-UNDO.
DEF VAR c-deposito AS CHAR NO-UNDO.
DEF VAR c-quantidade AS CHAR FORMAT "x(06)" NO-UNDO.
DEF VAR i-roteiro AS INT NO-UNDO.
DEF VAR i-nf LIKE ae-item.nf NO-UNDO.
DEF VAR i-contenedor LIKE item.lote-multipl NO-UNDO.
DEF VAR i-quantidade AS DEC NO-UNDO.
DEF VAR c-narrativa LIKE ae-bloqueado.narrativa NO-UNDO.
DEF VAR v-narrativa AS CHAR NO-UNDO.
DEF VAR c-it-codigo AS CHAR NO-UNDO.
DEF VAR c-loc-dev like movto-estoq.cod-localiz NO-UNDO.
DEFINE VARIABLE c-localizacao AS CHARACTER NO-UNDO.

&GLOBAL-DEFINE EXEC-RPC YES

DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}
{esp/utp/acesso-rpc.i}
{upc/btb910za-upc.i}
{esp/btb/esbtb003.i}
{esp/es0019.i}

DEF VAR c-old-usuario AS CHAR NO-UNDO.
DEF VAR raw-param AS RAW.
DEF VAR i-cont AS INT NO-UNDO.

define buffer b-usuar_mestre for usuar_mestre.
define variable i as integer no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-14 btExit ~
c-usuario c-nome-usuario c-senha c-usuario-desconecta ~
c-nome-usuario-desconecta rs-ambiente btDesconectar 
&Scoped-Define DISPLAYED-OBJECTS c-usuario c-nome-usuario c-senha ~
c-usuario-desconecta c-nome-usuario-desconecta rs-ambiente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD delete-cookie wWindow 
FUNCTION delete-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER,
   INPUT p_path                 AS CHARACTER,
   INPUT p_domain               AS CHARACTER ) {&FORWARD} FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-cookie wWindow 
FUNCTION get-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER ) {&FORWARD} FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD set-cookie wWindow 
FUNCTION set-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER,
    INPUT p_value                AS CHARACTER,
    INPUT p_date                 AS DATE,
    INPUT p_time                 AS INTEGER,
    INPUT p_path                 AS CHARACTER,
    INPUT p_domain               AS CHARACTER,
    INPUT p_options              AS CHARACTER ) {&FORWARD} FORWARD.

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
DEFINE BUTTON btDesconectar 
     LABEL "Desconectar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-nome-usuario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-usuario-desconecta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-senha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Senha (TOTVS)" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-desconecta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usu†rio a desconectar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE rs-ambiente AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Produá∆o", 1,
"Homologaá∆o", 2,
"Desenvolvimento", 3
     SIZE 39 BY 1.13 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 7.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 74 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 74 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 70.57 HELP
          "Sair"
     c-usuario AT ROW 4.04 COL 21.72 COLON-ALIGNED WIDGET-ID 2
     c-nome-usuario AT ROW 4.04 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-senha AT ROW 5.04 COL 21.72 COLON-ALIGNED WIDGET-ID 16 PASSWORD-FIELD 
     c-usuario-desconecta AT ROW 6.04 COL 21.72 COLON-ALIGNED WIDGET-ID 18
     c-nome-usuario-desconecta AT ROW 6.04 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     rs-ambiente AT ROW 7.42 COL 17.29 NO-LABEL WIDGET-ID 6
     btDesconectar AT ROW 8.79 COL 28 WIDGET-ID 10
     "Desconecta usu†rio:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 3 COL 8 WIDGET-ID 12
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 10.92 COL 1
     RECT-14 AT ROW 3.25 COL 6 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.14 BY 11.38
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
         HEIGHT             = 11.38
         WIDTH              = 74.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 94.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 94.86
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


&Scoped-define SELF-NAME btDesconectar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesconectar wWindow
ON CHOOSE OF btDesconectar IN FRAME fpage0 /* Desconectar */
DO:
    CASE rs-ambiente:SCREEN-VALUE IN FRAME fPage0:
        WHEN "1" THEN RUN pi-desconecta (INPUT "producao").         
        WHEN "2" THEN RUN pi-desconecta (INPUT "s/homol").      
        WHEN "3" THEN RUN pi-desconecta (INPUT "s/desenv").  
    END CASE.
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


&Scoped-define SELF-NAME c-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wWindow
ON LEAVE OF c-usuario IN FRAME fpage0 /* Usu†rio */
DO:
    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = INPUT c-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_mestre THEN
        ASSIGN c-nome-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    ELSE DO:
        ASSIGN c-nome-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar_mestre.nom_usuario.

        ASSIGN rs-ambiente:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-usuario-desconecta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario-desconecta wWindow
ON LEAVE OF c-usuario-desconecta IN FRAME fpage0 /* Usu†rio a desconectar */
DO:
    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = INPUT c-usuario-desconecta NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_mestre THEN
        ASSIGN c-nome-usuario-desconecta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".                   
    ELSE 
        ASSIGN c-nome-usuario-desconecta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar_mestre.nom_usuario.
  
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


&Scoped-define SELF-NAME rs-ambiente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-ambiente wWindow
ON VALUE-CHANGED OF rs-ambiente IN FRAME fpage0
DO:
    RUN pi-desconecta-bancos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-bancos wWindow 
PROCEDURE pi-conecta-bancos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pAmbiente AS CHAR NO-UNDO.

CASE pAmbiente:
    WHEN "producao" THEN DO:
        /* PRODUCAO */
        if not connected("emsfnd") THEN CONNECT -db emsfnd  -ld emsfnd  -S 10006 -H dbprogress.intelbras.com.br -N tcp NO-ERROR.
    END.
    WHEN "s/homol" THEN DO:
        /* HOMOLOG */
        if not connected("emsfnd") THEN CONNECT -db emsfnd  -ld emsfnd  -S 20006 -H dbprogress.intelbras.com.br -N tcp NO-ERROR.
    END.
    WHEN "s/desenv" THEN DO:
        /* DESENVOLVIMENTO */
        if not connected("emsfnd") THEN CONNECT -db emsfnd  -ld emsfnd  -S 30006 -H dbprogress.intelbras.com.br -N tcp NO-ERROR.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-pedido-rpw wWindow 
PROCEDURE pi-cria-pedido-rpw :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST usuar_mestre WHERE
          usuar_mestre.cod_usuar = v_cod_usuar_corren AND
          usuar_mestre.cod_servid_exec <> ""           NO-LOCK: END.

    FOR EACH tt-param:
       DELETE tt-param.
    END.
    FOR EACH tt_param_segur:
       DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
       DELETE tt_ped_exec.
    END.
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = v_cod_usuar_corren
           tt-param.destino         = 3
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.arquivo         = "ES0019":U + ".LST".
    
    RAW-TRANSFER tt-param TO raw-param.
    
    ASSIGN hr-aux = STRING(time,"hh:mm:ss")
           SUBSTR(hr-aux,3,1) = "" 
           SUBSTR(hr-aux,5,1) = "".

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "DIS":U
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_usuar_corren
           tt_param_segur.tta_cod_idiom_usuar          = "Por"
           tt_param_segur.tta_cod_modul_dtsul_corren   = "mpd":U
           tt_param_segur.tta_cod_pais_empres_usuar    = "Brasil"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = ENCODE(v_cod_usuar_corren).
   
    CREATE tt_ped_exec.
    ASSIGN tt_ped_exec.tta_num_seq                = 1
           tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
           tt_ped_exec.tta_cod_prog_dtsul         = "ES0019":U       
           tt_ped_exec.tta_cod_prog_dtsul_rp      = "esp/es0019rp.p" 
           tt_ped_exec.tta_cod_release_prog_dtsul = "2.00.00.000"    
           tt_ped_exec.tta_dat_exec_ped_exec      = DATE(STRING(tt-param.data-exec,"99/99/9999"))
           tt_ped_exec.tta_hra_exec_ped_exec      = hr-aux
           tt_ped_exec.tta_cod_servid_exec        = usuar_mestre.cod_servid_exec /* sec/sec000aa. */
           tt_ped_exec.tta_cdn_estil_dwb          = 97.
    

    /*
    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = 1
          tt_ped_exec_param.tta_cod_dwb_file         = "esp/es0019rp.p":U /* ???? "xxx/xxx9999.p":U */
          tt_ped_exec_param.tta_cod_dwb_output       = "Arquivo"
          tt_ped_exec_param.tta_nom_dwb_printer      = "ES0019.lst"
          tt_ped_exec_param.tta_cod_dwb_print_layout = "ES0019.lst".
          raw-transfer tt-param to tt_ped_exec_param.tta_raw_param_ped_exec.*/


    CREATE tt_ped_exec_param.
    ASSIGN tt_ped_exec_param.tta_num_seq              = 1
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/es0019rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = "Arquivo".
    
    RAW-TRANSFER tt-param TO tt_ped_exec_param.tta_raw_param_ped_exec. 
    
    FOR EACH tt-digita:
        DELETE tt-digita.
    END.
    FOR EACH tt-raw-digita:
        DELETE tt-raw-digita.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.

    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita: 
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end.         .

    FOR FIRST tt-raw-digita:
      CREATE tt_ped_exec_param_aux.
      ASSIGN tt_ped_exec_param_aux.tta_num_seq            = 1
             tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita
             tt_ped_exec_param_aux.tta_num_dwb_order      = 1.
    END.
    
    RUN btb/btb912zb.p (INPUT-OUTPUT TABLE tt_param_segur,
                        INPUT-OUTPUT TABLE tt_ped_exec,
                        INPUT TABLE tt_ped_exec_param,
                        INPUT TABLE tt_ped_exec_param_aux,
                        INPUT TABLE tt_ped_exec_sel).
                        
/*                                                                    
FOR FIRST usuar_mestre 
    WHERE usuar_mestre.cod_usuar = v_cod_usuar_corren
      AND usuar_mestre.cod_servid_exec <> ""           NO-LOCK: END.

CREATE tt-param.
ASSIGN tt-param.usuario         = v_cod_usuar_corren
       tt-param.destino         = 3
       tt-param.data-exec       = TODAY
       tt-param.hora-exec       = TIME
       tt-param.arquivo         = "ES0019":U + ".LST".

ASSIGN hr-aux = STRING(time,"hh:mm:ss")
                SUBSTR(hr-aux,3,1) = "" 
                SUBSTR(hr-aux,5,1) = "".

create tt_param_segur.
assign tt_param_segur.tta_num_vers_integr_api      = 3
       tt_param_segur.tta_cod_aplicat_dtsul_corren = "DIS":U
       tt_param_segur.tta_cod_empres_usuar         = "1"
       tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_usuar_corren
       tt_param_segur.tta_cod_idiom_usuar          = "Por"
       tt_param_segur.tta_cod_modul_dtsul_corren   = "mpd":U
       tt_param_segur.tta_cod_pais_empres_usuar    = "Brasil"
       tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
       tt_param_segur.tta_cod_usuar_corren_criptog = ENCODE(v_cod_usuar_corren).
       
create tt_ped_exec_aux_2.
assign tt_ped_exec_aux_2.tta_num_seq                = 1
      tt_ped_exec_aux_2.tta_cod_usuario            = v_cod_usuar_corren
      tt_ped_exec_aux_2.tta_cod_prog_dtsul         = "ES0019":U
      tt_ped_exec_aux_2.tta_cod_prog_dtsul_rp      = "esp/es0019rp.p"
      tt_ped_exec_aux_2.tta_cod_release_prog_dtsul = "2.00.00.000"
      tt_ped_exec_aux_2.tta_dat_exec_ped_exec      = TODAY
      tt_ped_exec_aux_2.tta_hra_exec_ped_exec      = hr-aux
      tt_ped_exec_aux_2.tta_cod_servid_exec        = usuar_mestre.cod_servid_exec
      tt_ped_exec_aux_2.tta_cdn_estil_dwb          = 97
      /*tt_ped_exec_aux_2.tta_log_exec_prog_depend   = w_ped_depend
      tt_ped_exec_aux_2.tta_num_ped_exec_pai       = integer(w_ped_exec_pai:screen-value in frame {&frame-name})
      tt_ped_exec_aux_2.ttv_log_envia_email        = w_envia_email*/
      .

create tt_ped_exec_param.
assign tt_ped_exec_param.tta_num_seq              = 1
      tt_ped_exec_param.tta_cod_dwb_file         = "esp/es0019rp.p":U /* ???? "xxx/xxx9999.p":U */
      tt_ped_exec_param.tta_cod_dwb_output       = "Arquivo"
      tt_ped_exec_param.tta_nom_dwb_printer      = "ES0019.lst"
      tt_ped_exec_param.tta_cod_dwb_print_layout = "ES0019.lst".
      raw-transfer tt-param to tt_ped_exec_param.tta_raw_param_ped_exec.

      /*
run btb/btb912zd.p (input-output table tt_param_segur,
                    input-output table tt_ped_exec_aux_2,
                    input table tt_ped_exec_param,
                    input table tt_ped_exec_param_aux,
                    input table tt_ped_exec_sel,
                    output table tt_erros_envio_email,
                    input "ES0019":U) NO-ERROR.
                    */
run btb/btb912zb.p (input-output table tt_param_segur,
                    input-output table tt_ped_exec_aux_2,
                    input table tt_ped_exec_param,
                    input table tt_ped_exec_param_aux,
                    input table tt_ped_exec_sel) NO-ERROR.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-pedido-rpw2 wWindow 
PROCEDURE pi-cria-pedido-rpw2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN i-cont = i-cont + 1.

FOR FIRST usuar_mestre WHERE
          usuar_mestre.cod_usuar = c-usuario:SCREEN-VALUE IN FRAME fPage0 AND
          usuar_mestre.cod_servid_exec <> ""           NO-LOCK:

    FOR EACH tt-param:
       DELETE tt-param.
    END.
    FOR EACH tt_param_segur:
       DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
       DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
       DELETE tt_ped_exec_param.
    END.
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = usuar_mestre.cod_usuar
           tt-param.destino         = 3
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.arquivo         = "ES0019":U + ".LST".
    
    RAW-TRANSFER tt-param TO raw-param.
    
    ASSIGN hr-aux = STRING(time,"hh:mm:ss")
           SUBSTR(hr-aux,3,1) = "" 
           SUBSTR(hr-aux,5,1) = "".
    
    CREATE  tt_param_segur.
    ASSIGN  tt_param_segur.tta_num_vers_integr_api      = 3
            tt_param_segur.tta_cod_aplicat_dtsul_corren = "DIS"
            tt_param_segur.tta_cod_empres_usuar         = "1"
            tt_param_segur.tta_cod_grp_usuar_lst        = usuar_mestre.cod_usuar
            tt_param_segur.tta_cod_idiom_usuar          = "Por"
            tt_param_segur.tta_cod_modul_dtsul_corren   = "mpd"
            tt_param_segur.tta_cod_pais_empres_usuar    = "Brasil"              
            tt_param_segur.tta_cod_usuar_corren         = usuar_mestre.cod_usuar
            tt_param_segur.tta_cod_usuar_corren_criptog = ENCODE(usuar_mestre.cod_usuar).
   
    CREATE tt_ped_exec.
    ASSIGN tt_ped_exec.tta_num_seq                = i-cont
           tt_ped_exec.tta_cod_usuario            = usuar_mestre.cod_usuar
           tt_ped_exec.tta_cod_prog_dtsul         = "ES0019"
           tt_ped_exec.tta_cod_prog_dtsul_rp      = "esp/es0019rp.p"
           tt_ped_exec.tta_cod_release_prog_dtsul = "2.00.00.000"
           tt_ped_exec.tta_dat_exec_ped_exec      = DATE(STRING(tt-param.data-exec,"99/99/9999"))
           tt_ped_exec.tta_hra_exec_ped_exec      = hr-aux
           tt_ped_exec.tta_cod_servid_exec        = usuar_mestre.cod_servid_exec /* sec/sec000aa. */
           tt_ped_exec.tta_cdn_estil_dwb          = 97.
    
    CREATE tt_ped_exec_param.
    ASSIGN tt_ped_exec_param.tta_num_seq              = i-cont
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/es0019rp.p".
           
    {utp/ut-liter.i Arquivo *}
    ASSIGN tt_ped_exec_param.tta_cod_dwb_output       = RETURN-VALUE.
    
    RAW-TRANSFER tt-param TO tt_ped_exec_param.tta_raw_param_ped_exec. 
    
    FOR EACH tt-digita:
        DELETE tt-digita.
    END.
    FOR EACH tt-raw-digita:
        DELETE tt-raw-digita.
    END.
    
    CREATE tt-digita.
    /*ASSIGN tt-digita.r-docum-est = ROWID(b-docum-est).*/
    
    CREATE tt-raw-digita.
    RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
    
    FOR FIRST tt-raw-digita:
      CREATE tt_ped_exec_param_aux.
      ASSIGN tt_ped_exec_param_aux.tta_num_seq            = i-cont
             tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita
             tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont.
    END.
    
    RUN btb/btb912zb.p (INPUT-OUTPUT TABLE tt_param_segur,
                        INPUT-OUTPUT TABLE tt_ped_exec,
                        INPUT TABLE tt_ped_exec_param,
                        INPUT TABLE tt_ped_exec_param_aux,
                        INPUT TABLE tt_ped_exec_sel).
                        
END. /* FOR FIRST usuar_mestre WHERE */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desconecta wWindow 
PROCEDURE pi-desconecta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pAmbiente AS CHAR NO-UNDO.

RUN pi-conecta-bancos(INPUT pAmbiente).
RUN pi-gera-registro-desconecta(INPUT pAmbiente).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desconecta-bancos wWindow 
PROCEDURE pi-desconecta-bancos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if connected("emsfnd") THEN 
    DISCONNECT emsfnd .
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-registro-desconecta wWindow 
PROCEDURE pi-gera-registro-desconecta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pAmbiente AS CHAR NO-UNDO.

IF (c-usuario:SCREEN-VALUE IN FRAME fPage0 <> "" and c-senha:SCREEN-VALUE IN FRAME fPage0 <> "" and c-usuario-desconecta:SCREEN-VALUE IN FRAME fPage0 <> "") THEN DO:

    FIND FIRST usuar_mestre no-lock
         where usuar_mestre.cod_usuario = c-usuario:SCREEN-VALUE IN FRAME fPage0 no-error.
    IF AVAILABLE usuar_mestre then do:

        IF usuar_mestre.ind_tip_aces_usuar = "externo" THEN DO:
            EMPTY TEMP-TABLE tt-erros.
            run btb/btapi910za.p (input "intelbras/" + usuar_mestre.cod_usuario, 
                                  INPUT c-senha:SCREEN-VALUE IN FRAME fPage0, 
                                  output table tt-erros) NO-ERROR.     
        END.

        IF (usuar_mestre.ind_tip_aces_usuar = "externo" AND NOT CAN-FIND(FIRST tt-erros))
        OR (usuar_mestre.ind_tip_aces_usuar = "interno" AND usuar_mestre.cod_senha = base64-encode(sha1-digest(LOWER(c-senha:SCREEN-VALUE IN FRAME fPage0)))) then do:

            FIND FIRST b-usuar_mestre no-lock
                 where b-usuar_mestre.cod_usuario = c-usuario-desconecta:SCREEN-VALUE IN FRAME fPage0 no-error.
            if available b-usuar_mestre and b-usuar_mestre.dat_fim_valid >= today then do:

                if b-usuar_mestre.cod_usuario <> usuar_mestre.cod_usuario
                    and (not can-find (first usuar_grp_usuar
                                     where usuar_grp_usuar.cod_grp_usuar = 't20'
                                       and usuar_grp_usuar.cod_usuario   = usuar_mestre.cod_usuario)
                    and not can-find (first usuar_grp_usuar
                                     where usuar_grp_usuar.cod_grp_usuar = 'adm'
                                       and usuar_grp_usuar.cod_usuario   = usuar_mestre.cod_usuario)) then
                    MESSAGE "Usu†rio sem permiss∆o para desconectar"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                else do:
                    FOR EACH int-desconecta-usuar EXCLUSIVE-LOCK
                       WHERE int-desconecta-usuar.cod-usuario = trim(b-usuar_mestre.cod_usuario):
                        DELETE int-desconecta-usuar.
                    END.

                    repeat i = 1 to num-dbs:
                      create alias dictdb for database value (ldbname(i)) no-error.
                      run esp/es0036c.p (input b-usuar_mestre.cod_usuario, input pAmbiente).
                      delete alias dictdb.
                    END.

                    RUN pi-cria-pedido-rpw2.

                    MESSAGE "Usu†rio desconectado!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
                END.
            END.
            else
                MESSAGE "Usu†rio inexistente ou desativado."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        else
            MESSAGE "Senha incorreta"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    else
        MESSAGE "Usu†rio inexistente"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
ELSE
    MESSAGE "Os tràs campos devem ser preenchidos!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION delete-cookie wWindow 
FUNCTION delete-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER,
   INPUT p_path                 AS CHARACTER,
   INPUT p_domain               AS CHARACTER ) {&FORWARD}:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-cookie wWindow 
FUNCTION get-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER ) {&FORWARD}:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION set-cookie wWindow 
FUNCTION set-cookie RETURNS CHARACTER
  ( INPUT p_name                 AS CHARACTER,
    INPUT p_value                AS CHARACTER,
    INPUT p_date                 AS DATE,
    INPUT p_time                 AS INTEGER,
    INPUT p_path                 AS CHARACTER,
    INPUT p_domain               AS CHARACTER,
    INPUT p_options              AS CHARACTER ) {&FORWARD}:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

