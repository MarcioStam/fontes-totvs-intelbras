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
{include/i-prgvrs.i esacr003h 1.00.00.000}
{esp/acr/esacr003h.i "new shared"}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esacr003h
&GLOBAL-DEFINE Version        1.0

&GLOBAL-DEFINE WindowType     ThinWindow

&GLOBAL-DEFINE page0Widgets   btOK btCancel fi_cod_estab fi_cod_espec_docto fi_cod_ser_docto fi_cod_tit_acr fi_cod_parcela fi_cdn_cliente fi_nom_cliente ~
                              fi_cod_estab_dest fi_cod_espec_docto_dest fi_cod_ser_docto_dest fi_cod_tit_acr_dest fi_cod_parcela_dest fi_cdn_cliente_dest fi_nom_cliente_dest ~
                              fi_cod_cta_ctbl fi_data fi_valor ed-obs

/* Parameters Definitions ---                                           */
DEF INPUT PARAM pcod_estab          LIKE tit_acr.cod_estab.
DEF INPUT PARAM pcod_espec_docto    LIKE tit_acr.cod_espec_docto.
DEF INPUT PARAM pcod_ser_docto      LIKE tit_acr.cod_ser_docto.
DEF INPUT PARAM pcod_tit_acr        LIKE tit_acr.cod_tit_acr.
DEF INPUT PARAM pcod_parcela        LIKE tit_acr.cod_parcela.
DEF INPUT PARAM pcdn_cliente        LIKE tit_acr.cdn_cliente    .

/* Variable Definitions ---                                       */
DEFINE VARIABLE i-seq-erro-aux            AS INTEGER     NO-UNDO.
DEFINE VARIABLE de_val_titulo             LIKE tit_acr.val_sdo_tit_acr     NO-UNDO.
def new global shared var v_rec_clien_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/* Variaveis conta ctbl */
def var h_api_cta_ctbl       as handle no-undo.
def var c-formato-conta      as char no-undo.
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".
/**/

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF BUFFER tit_acr_origem FOR tit_acr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-10 RECT-11 RECT-12 ~
fi_cod_estab_dest fi_cod_espec_docto_dest fi_cod_ser_docto_dest ~
fi_cod_tit_acr_dest fi_cod_parcela_dest fi_cdn_cliente_dest fi_cod_cta_ctbl ~
fi_data fi_valor ed-obs btOK btCancel btHelp 
&Scoped-Define DISPLAYED-OBJECTS fi_cod_estab fi_cod_espec_docto ~
fi_cod_ser_docto fi_cod_tit_acr fi_cod_parcela fi_cdn_cliente ~
fi_nom_cliente fi_cod_estab_dest fi_cod_espec_docto_dest ~
fi_cod_ser_docto_dest fi_cod_tit_acr_dest fi_cod_parcela_dest ~
fi_cdn_cliente_dest fi_nom_cliente_dest fi_cod_cta_ctbl fi_desc_cta_ctbl ~
fi_data fi_valor ed-obs 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Transferir" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-obs AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 58 BY 3.5 NO-UNDO.

DEFINE VARIABLE fi_cdn_cliente AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cdn_cliente_dest AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_cta_ctbl AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Cont bil" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_espec_docto AS CHARACTER FORMAT "X(3)":U 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_espec_docto_dest AS CHARACTER FORMAT "X(3)":U 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_estab_dest AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_parcela AS CHARACTER FORMAT "X(02)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_parcela_dest AS CHARACTER FORMAT "X(02)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_ser_docto AS CHARACTER FORMAT "X(3)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_ser_docto_dest AS CHARACTER FORMAT "X(3)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_tit_acr AS CHARACTER FORMAT "X(16)":U 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_tit_acr_dest AS CHARACTER FORMAT "X(16)":U 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_valor AS DEC FORMAT ">>>,>>>,>>9.99"
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi_desc_cta_ctbl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi_nom_cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi_nom_cliente_dest AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 3.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 3.71.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 6.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 74.57 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi_cod_estab AT ROW 2 COL 15 COLON-ALIGNED WIDGET-ID 34
     fi_cod_espec_docto AT ROW 2 COL 39 COLON-ALIGNED WIDGET-ID 36
     fi_cod_ser_docto AT ROW 2 COL 57 COLON-ALIGNED WIDGET-ID 38
     fi_cod_tit_acr AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 40
     fi_cod_parcela AT ROW 3 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi_cdn_cliente AT ROW 4 COL 15 COLON-ALIGNED WIDGET-ID 44
     fi_nom_cliente AT ROW 4 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     fi_cod_estab_dest AT ROW 6.04 COL 15 COLON-ALIGNED WIDGET-ID 56
     fi_cod_espec_docto_dest AT ROW 6.04 COL 39 COLON-ALIGNED WIDGET-ID 54
     fi_cod_ser_docto_dest AT ROW 6.04 COL 57 COLON-ALIGNED WIDGET-ID 60
     fi_cod_tit_acr_dest AT ROW 7.04 COL 15 COLON-ALIGNED WIDGET-ID 62
     fi_cod_parcela_dest AT ROW 7.04 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     fi_cdn_cliente_dest AT ROW 8.04 COL 15 COLON-ALIGNED WIDGET-ID 52
     fi_nom_cliente_dest AT ROW 8.04 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     fi_cod_cta_ctbl AT ROW 9.75 COL 15 COLON-ALIGNED WIDGET-ID 72
     fi_desc_cta_ctbl AT ROW 9.75 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     fi_data AT ROW 10.75 COL 15 COLON-ALIGNED WIDGET-ID 76
     fi_valor AT ROW 10.75 COL 40 COLON-ALIGNED /*WIDGET-ID 77*/
     ed-obs AT ROW 11.75 COL 17 NO-LABEL WIDGET-ID 78
     btOK AT ROW 16.21 COL 1.86
     btCancel AT ROW 16.21 COL 13
     btHelp AT ROW 16.21 COL 64.43 WIDGET-ID 20
     "Destino:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 5.25 COL 6.86 WIDGET-ID 68
     "Origem:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.21 COL 6.86 WIDGET-ID 48
     rtToolBar AT ROW 16 COL 1
     RECT-10 AT ROW 1.5 COL 2 WIDGET-ID 46
     RECT-11 AT ROW 5.54 COL 2 WIDGET-ID 66
     RECT-12 AT ROW 9.5 COL 2 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76.14 BY 17
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
         TITLE              = "Transferir Cr‚dito"
         HEIGHT             = 17.33
         WIDTH              = 76.57
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
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
/* SETTINGS FOR FILL-IN fi_cdn_cliente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_espec_docto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_estab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_parcela IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_ser_docto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_tit_acr IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_desc_cta_ctbl IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_nom_cliente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_nom_cliente_dest IN FRAME fpage0
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
ON END-ERROR OF wWindow /* Transferir Cr‚dito */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Transferir Cr‚dito */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Transferir */
DO:
    ASSIGN INPUT FRAME fpage0 fi_cod_estab fi_cod_espec_docto fi_cod_ser_docto fi_cod_tit_acr 
        fi_cod_parcela fi_cdn_cliente fi_nom_cliente fi_cod_estab_dest fi_cod_espec_docto_dest 
        fi_cod_ser_docto_dest fi_cod_tit_acr_dest fi_cod_parcela_dest fi_cdn_cliente_dest 
        fi_nom_cliente_dest fi_cod_cta_ctbl fi_desc_cta_ctbl fi_data fi_valor ed-obs.
        
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Transferir cr‚dito." + "~~" + "Deseja transferir cr‚dito, confirma?").
    IF RETURN-VALUE = "NO" THEN
        RETURN NO-APPLY.

    RUN pi-valida.
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.

    RUN pi-transferir.
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.

    RUN pi-cria-historico.
    
    /* sucesso */
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Transferˆncia de cr‚dito realizada com sucesso" + "~~" +
                             "Gerado a altera‡Æo (AVMN) no t¡tulo de origem e registrado o t¡tulo destino." + CHR(10) + 
                             "Estab: " + fi_cod_estab_dest + " Esp: " + fi_cod_espec_docto_dest + " Ser: " + fi_cod_ser_docto_dest + 
                             " Tit: " + fi_cod_tit_acr_dest + " Pa: " + fi_cod_parcela_dest + " Cliente: " + STRING(fi_cdn_cliente_dest)).
    

    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi_cdn_cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cdn_cliente wWindow
ON LEAVE OF fi_cdn_cliente IN FRAME fpage0 /* Cliente */
DO:
  FIND FIRST emscad.cliente NO-LOCK
       WHERE cliente.cdn_cliente = INPUT FRAME fpage0 fi_cdn_cliente NO-ERROR.
  IF AVAIL cliente THEN
      ASSIGN fi_nom_cliente:SCREEN-VALUE IN FRAME fpage0 = cliente.nom_pessoa.
  ELSE
      ASSIGN fi_nom_cliente:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi_cdn_cliente_dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cdn_cliente_dest wWindow
ON F5 OF fi_cdn_cliente_dest IN FRAME fpage0 /* Cliente */
DO:
    run prgint/ufn/ufn011ka.p /*prg_sea_clien_financ*/.
    if  v_rec_clien_financ <> ?
    then do:
        find clien_financ where recid(clien_financ) = v_rec_clien_financ no-lock no-error.
        assign fi_cdn_cliente_dest:screen-value in frame fpage0 = string(clien_financ.cdn_cliente).

        apply "entry" to fi_cdn_cliente_dest in frame fpage0.
    end /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cdn_cliente_dest wWindow
ON LEAVE OF fi_cdn_cliente_dest IN FRAME fpage0 /* Cliente */
DO:
  FIND FIRST emscad.cliente NO-LOCK
       WHERE cliente.cdn_cliente = INPUT FRAME fpage0 fi_cdn_cliente_dest NO-ERROR.
  IF AVAIL cliente THEN
      ASSIGN fi_nom_cliente_dest:SCREEN-VALUE IN FRAME fpage0 = cliente.nom_pessoa.
  ELSE
      ASSIGN fi_nom_cliente_dest:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cdn_cliente_dest wWindow
ON MOUSE-SELECT-DBLCLICK OF fi_cdn_cliente_dest IN FRAME fpage0 /* Cliente */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi_cod_cta_ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cod_cta_ctbl wWindow
ON F5 OF fi_cod_cta_ctbl IN FRAME fpage0 /* Conta Cont bil */
DO:
  def var v_cod_finalid as char no-undo.                                               

   assign v_cod_finalid = "(nenhum)".


   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                  input  "ACR",              /* MÎDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  TODAY,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

    if v_titulo_cta_ctbl <> "" then do:
        ASSIGN fi_cod_cta_ctbl:SCREEN-VALUE IN FRAME fpage0 = v_cod_cta_ctbl.
        ASSIGN fi_desc_cta_ctbl:SCREEN-VALUE IN FRAME fpage0 = v_titulo_cta_ctbl.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cod_cta_ctbl wWindow
ON LEAVE OF fi_cod_cta_ctbl IN FRAME fpage0 /* Conta Cont bil */
DO:
    ASSIGN INPUT FRAME fpage0 fi_cod_cta_ctbl.

    /* Busca dados da conta contëbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output fi_cod_cta_ctbl,     /* CONTA */
                                                   input        TODAY,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAÜ›O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    ASSIGN fi_desc_cta_ctbl:SCREEN-VALUE IN FRAME fpage0 = v_titulo_cta_ctbl. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cod_cta_ctbl wWindow
ON MOUSE-SELECT-DBLCLICK OF fi_cod_cta_ctbl IN FRAME fpage0 /* Conta Cont bil */
DO:
  APPLY "F5" TO SELF.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplay wWindow 
PROCEDURE AfterDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
fi_cdn_cliente_dest:load-mouse-pointer("image\lupa.cur") in frame {&frame-name}.
fi_cod_cta_ctbl:load-mouse-pointer("image\lupa.cur") in frame {&frame-name}.

/* dados do titulo de origem */
ASSIGN fi_cod_estab      :SCREEN-VALUE IN FRAME fpage0 = pcod_estab      
       fi_cod_espec_docto:SCREEN-VALUE IN FRAME fpage0 = pcod_espec_docto
       fi_cod_ser_docto  :SCREEN-VALUE IN FRAME fpage0 = pcod_ser_docto  
       fi_cod_tit_acr    :SCREEN-VALUE IN FRAME fpage0 = pcod_tit_acr    
       fi_cod_parcela    :SCREEN-VALUE IN FRAME fpage0 = pcod_parcela    
       fi_cdn_cliente    :SCREEN-VALUE IN FRAME fpage0 = STRING(pcdn_cliente). 

/* sugere os mesmos dados do titulo de origem para o destino, menos o cliente */
ASSIGN fi_cod_estab_dest      :SCREEN-VALUE IN FRAME fpage0 = pcod_estab      
       fi_cod_espec_docto_dest:SCREEN-VALUE IN FRAME fpage0 = pcod_espec_docto
       fi_cod_ser_docto_dest  :SCREEN-VALUE IN FRAME fpage0 = pcod_ser_docto  
       fi_cod_tit_acr_dest    :SCREEN-VALUE IN FRAME fpage0 = pcod_tit_acr    
       fi_cod_parcela_dest    :SCREEN-VALUE IN FRAME fpage0 = pcod_parcela.    

ASSIGN fi_data:SCREEN-VALUE IN FRAME fpage0 = STRING(TODAY).

FIND FIRST tit_acr NO-LOCK
     WHERE tit_acr.cod_estab       = pcod_estab      
       AND tit_acr.cod_espec_docto = pcod_espec_docto
       AND tit_acr.cod_ser_docto   = pcod_ser_docto  
       AND tit_acr.cod_tit_acr     = pcod_tit_acr    
       AND tit_acr.cod_parcela     = pcod_parcela NO-ERROR.

IF  AVAIL tit_acr THEN
    ASSIGN fi_valor:SCREEN-VALUE IN FRAME fpage0 = STRING(tit_acr.val_sdo_tit_acr).

APPLY "LEAVE" TO fi_cdn_cliente IN FRAME fpage0.

DISABLE fi_cod_estab      
        fi_cod_espec_docto
        fi_cod_ser_docto  
        fi_cod_tit_acr    
        fi_cod_parcela    
        fi_cdn_cliente
        fi_nom_cliente 
        fi_nom_cliente_dest WITH FRAME fpage0.

if NOT valid-handle(h_api_cta_ctbl) then
      run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.

RUN pi-atualiza-formato.
ASSIGN fi_cod_cta_ctbl:SCREEN-VALUE IN FRAME fpage0 = "00000000".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-formato wWindow 
PROCEDURE pi-atualiza-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input TODAY,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  
  IF c-formato-conta <> "" THEN
    ASSIGN fi_cod_cta_ctbl:FORMAT IN FRAME fpage0 = c-formato-conta.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico wWindow 
PROCEDURE pi-cria-historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CREATE hist-transfer-credito. 
ASSIGN hist-transfer-credito.cdn_cliente          = fi_cdn_cliente
       hist-transfer-credito.cdn_cliente_dest     = fi_cdn_cliente_dest
       hist-transfer-credito.cod_cta_ctbl         = fi_cod_cta_ctbl
       hist-transfer-credito.cod_espec_docto      = fi_cod_espec_docto
       hist-transfer-credito.cod_espec_docto_dest = fi_cod_espec_docto_dest
       hist-transfer-credito.cod_estab            = fi_cod_estab
       hist-transfer-credito.cod_estab_dest       = fi_cod_estab_dest
       hist-transfer-credito.cod_parcela          = fi_cod_parcela
       hist-transfer-credito.cod_parcela_dest     = fi_cod_parcela_dest
       hist-transfer-credito.cod_ser_docto        = fi_cod_ser_docto
       hist-transfer-credito.cod_ser_docto_dest   = fi_cod_ser_docto_dest
       hist-transfer-credito.cod_tit_acr          = fi_cod_tit_acr
       hist-transfer-credito.cod_tit_acr_dest     = fi_cod_tit_acr_dest
       hist-transfer-credito.data                 = fi_data
       hist-transfer-credito.usuario              = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-item-lote wWindow 
PROCEDURE pi-cria-item-lote :
/*------------------------------------------------------------------------------
  Purpose:     cria temp-table com o novo t¡tulo no cliente destino
  Parameters:  <none> 
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR v-log-tit-acr-unico  AS LOGICAL   NO-UNDO.
    
    ASSIGN i-sequencia = i-sequencia + 10.

    CREATE tt_integr_acr_item_lote_impl_6.
    ASSIGN tt_integr_acr_item_lote_impl_6.ttv_rec_lote_impl_tit_acr      = v-recid
           tt_integr_acr_item_lote_impl_6.tta_num_seq_refer              = i-sequencia
           tt_integr_acr_item_lote_impl_6.tta_cdn_cliente                = fi_cdn_cliente_dest
           tt_integr_acr_item_lote_impl_6.tta_cod_espec_docto            = fi_cod_espec_docto_dest
           tt_integr_acr_item_lote_impl_6.tta_cod_tit_acr                = fi_cod_tit_acr_dest
           tt_integr_acr_item_lote_impl_6.tta_cod_parcela                = fi_cod_parcela_dest
           tt_integr_acr_item_lote_impl_6.tta_cod_ser_docto              = fi_cod_ser_docto_dest
           tt_integr_acr_item_lote_impl_6.tta_cod_indic_econ             = "Real" 
           /*tt_integr_acr_item_lote_impl_6.tta_cod_finalid_econ           = p_cod_finalid_econ*/
           tt_integr_acr_item_lote_impl_6.tta_ind_tip_espec_docto        = espec_docto.ind_tip_espec_doc
           tt_integr_acr_item_lote_impl_6.tta_dat_vencto_tit_acr         = fi_data
           tt_integr_acr_item_lote_impl_6.tta_dat_emis_docto             = fi_data
           tt_integr_acr_item_lote_impl_6.tta_val_cotac_indic_econ       = 1
           tt_integr_acr_item_lote_impl_6.tta_des_text_histor            = IF ed-obs <> "" THEN ed-obs ELSE "Transf cr‚dito t¡tulo origem: Estab: " + tit_acr_origem.cod_estab + " Esp: " + tit_acr_origem.cod_espec_docto + " Tit: " + tit_acr_origem.cod_tit_acr + " Par: " + tit_acr_origem.cod_parcela + " Ser: " + tit_acr_origem.cod_ser_docto
           tt_integr_acr_item_lote_impl_6.tta_ind_tip_calc_juros         = "Simples"
           tt_integr_acr_item_lote_impl_6.tta_val_tit_acr                = de_val_titulo
           tt_integr_acr_item_lote_impl_6.tta_val_liq_tit_acr            = de_val_titulo
           tt_integr_acr_item_lote_impl_6.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_6).
    

    ASSIGN tt_integr_acr_item_lote_impl_6.tta_dat_prev_liquidac = tt_integr_acr_item_lote_impl_6.tta_dat_vencto_tit_acr.

    ASSIGN tt_integr_acr_item_lote_impl_6.tta_cod_portador  = ""
           tt_integr_acr_item_lote_impl_6.tta_cod_cart_bcia = "".
           
    

    /* apropria‡Æo contabil - rateio */
    CREATE tt_integr_acr_aprop_ctbl_pend.
    ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_6) 
           tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = "102" /*fixo*/
           tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_integr_acr_item_lote_impl_6.tta_val_tit_acr
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = "ADM" /*fixo*/.

    
    ASSIGN tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = fi_cod_cta_ctbl      
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "PADRAO"
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""       
           tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "".      
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-lote wWindow 
PROCEDURE pi-cria-lote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-ref AS CHARACTER   NO-UNDO.

    FIND FIRST espec_docto WHERE espec_docto.cod_espec_docto = fi_cod_espec_docto_dest NO-LOCK NO-ERROR.

    ASSIGN v_log_refer_unica = NO.
    DO WHILE NOT v_log_refer_unica:
        run pi_retorna_sugestao_referencia (Input "F", Input TODAY, Output v_cod_refer) /* pi_retorna_sugestao_referencia*/.

        run pi_verifica_refer_unica_acr    (Input fi_cod_estab_dest,
                                            Input v_cod_refer, 
                                            Input "tit_acr", 
                                            Input ?, 
                                            OUTPUT v_log_refer_unica).
    END.

    CREATE tt_integr_acr_lote_impl.
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = string(i-ep-codigo-usuario)
           tt_integr_acr_lote_impl.tta_cod_estab            = fi_cod_estab_dest
           tt_integr_acr_lote_impl.tta_cod_refer            = v_cod_refer
           tt_integr_acr_lote_impl.tta_cod_indic_econ       = "Real"
           /*tt_integr_acr_lote_impl.tta_cod_finalid_econ     = p_cod_finalid_econ*/
           tt_integr_acr_lote_impl.tta_dat_transacao        = fi_data
           tt_integr_acr_lote_impl.tta_ind_tip_espec_docto  = espec_docto.ind_tip_espec_doc
           tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACR" 
           tt_integr_acr_lote_impl.ttv_log_lote_impl_ok     = YES
           tt_integr_acr_lote_impl.tta_log_liquidac_autom   = YES
           v-recid                                          = RECID(tt_integr_acr_lote_impl).

   
    ASSIGN i-sequencia = 0. /* reinicio da sequencia do filho a cada lote criado */

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transferir wWindow 
PROCEDURE pi-transferir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h_acr711zv                AS HANDLE NO-UNDO.
    DEF VAR v_hdl_api_integr_acr              AS HANDLE NO-UNDO.

    FIND FIRST matriz_trad_org_ext NO-LOCK NO-ERROR.

    /************ ALTERA€ÇO DE TITULO (AVMN) **************/
    RUN prgfin/acr/acr711zv.py   PERSISTENT SET h_acr711zv.

    EMPTY TEMP-TABLE tt_alter_tit_acr_base_5        NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_rateio        NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_ped_vda       NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_comis_1       NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_cheq          NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_iva           NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_impto_retid_2 NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_cobr_espec_2  NO-ERROR.
    EMPTY TEMP-TABLE tt_alter_tit_acr_rat_desp_rec  NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erros_alter_tit_acr     NO-ERROR.
    EMPTY TEMP-TABLE tt-erro                        NO-ERROR.

    FIND FIRST tit_acr_origem NO-LOCK
         WHERE tit_acr_origem.cod_estab       = fi_cod_estab      
           AND tit_acr_origem.cod_espec_docto = fi_cod_espec_docto
           AND tit_acr_origem.cod_ser_docto   = fi_cod_ser_docto  
           AND tit_acr_origem.cod_tit_acr     = fi_cod_tit_acr    
           AND tit_acr_origem.cod_parcela     = fi_cod_parcela NO-ERROR.

    ASSIGN v_log_refer_unica = NO.
    DO WHILE NOT v_log_refer_unica:
        run pi_retorna_sugestao_referencia (Input "F", Input TODAY, Output v_cod_refer) /* pi_retorna_sugestao_referencia*/.

        run pi_verifica_refer_unica_acr    (Input tit_acr_origem.cod_estab,
                                            Input v_cod_refer, 
                                            Input "tit_acr", 
                                            Input ?, 
                                            OUTPUT v_log_refer_unica).
    END.

    CREATE tt_alter_tit_acr_base_5.
    ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tit_acr_origem.cod_estab
           tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tit_acr_origem.num_id_tit_acr
           tt_alter_tit_acr_base_5.tta_dat_transacao               = fi_data
           tt_alter_tit_acr_base_5.tta_cod_refer                   = v_cod_refer
           tt_alter_tit_acr_base_5.ttv_cod_portador_mov            = ?
           tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = tit_acr_origem.val_liq_tit_acr          
           tt_alter_tit_acr_base_5.tta_cod_histor_padr             = ""
           tt_alter_tit_acr_base_5.ttv_des_text_histor             = IF ed-obs <> "" THEN ed-obs ELSE "Transferˆncia de cr‚dito pelo programa ESACR003"
           tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ""
           tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = 1.
    
    ASSIGN tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val      = 'Altera‡Æo' /*'Liquida‡Æo'*/
           tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr           = tit_acr_origem.val_sdo_tit_acr - fi_valor
           tt_alter_tit_acr_base_5.tta_cod_portador              = tit_acr_origem.cod_portador
           tt_alter_tit_acr_base_5.tta_cod_cart_bcia             = tit_acr_origem.cod_cart_bcia
           tt_alter_tit_acr_base_5.tta_dat_emis_docto            = tit_acr_origem.dat_emis_docto
           tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr        = tit_acr_origem.dat_vencto_tit_acr
           tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr          = tit_acr_origem.dat_abat_tit_acr
           tt_alter_tit_acr_base_5.tta_dat_prev_liquidac         = tit_acr_origem.dat_prev_liquidac 
           tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr         = tit_acr_origem.dat_fluxo_tit_acr 
           tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr           = tit_acr_origem.ind_sit_tit_acr
           tt_alter_tit_acr_base_5.tta_cod_cond_cobr             = tit_acr_origem.cod_cond_cobr
           tt_alter_tit_acr_base_5.tta_val_perc_abat_acr         = tit_acr_origem.val_perc_abat_acr
           tt_alter_tit_acr_base_5.tta_val_abat_tit_acr          = tit_acr_origem.val_abat_tit_acr_infor
           tt_alter_tit_acr_base_5.tta_dat_desconto              = tit_acr_origem.dat_desconto
           tt_alter_tit_acr_base_5.tta_val_perc_desc             = tit_acr_origem.val_perc_desc
           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr = tit_acr_origem.qtd_dias_carenc_juros_acr
           tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso = tit_acr_origem.val_perc_juros_dia_atraso
           tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr = tit_acr_origem.qtd_dias_carenc_multa_acr
           tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso     = tit_acr_origem.val_perc_multa_atraso
           tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo       = tit_acr_origem.log_tit_acr_destndo
           tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco           = tit_acr_origem.cod_tit_acr_bco
           tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia       = tit_acr_origem.cod_agenc_cobr_bcia
           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1        = tit_acr_origem.cod_instruc_bcia_1
           tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2        = tit_acr_origem.cod_instruc_bcia_2
           tt_alter_tit_acr_base_5.ttv_dat_base_fechto_vendor    = ?
           tt_alter_tit_acr_base_5.tta_cdn_repres                = tit_acr_origem.cdn_repres.

    CREATE tt_alter_tit_acr_rateio.
    ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr_origem.cod_estab
           tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr_origem.num_id_tit_acr
           tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val
           tt_alter_tit_acr_rateio.tta_cod_refer                   = tt_alter_tit_acr_base_5.tta_cod_refer
           tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 1
           tt_alter_tit_acr_rateio.tta_num_seq_refer               = 1
           tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "PADRAO"
           tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = fi_cod_cta_ctbl
           tt_alter_tit_acr_rateio.tta_cod_unid_negoc              = ""
           tt_alter_tit_acr_rateio.tta_cod_tip_fluxo_financ        = ""
           tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = fi_valor
           tt_alter_tit_acr_rateio.tta_log_impto_val_agreg         = NO
           tt_alter_tit_acr_rateio.tta_cod_pais                    = ''
           tt_alter_tit_acr_rateio.tta_cod_unid_federac            = ''
           tt_alter_tit_acr_rateio.tta_cod_imposto                 = ''
           tt_alter_tit_acr_rateio.tta_cod_classif_impto           = ''
           tt_alter_tit_acr_rateio.tta_dat_transacao               = tt_alter_tit_acr_base_5.tta_dat_transacao
           tt_alter_tit_acr_rateio.tta_cod_plano_ccusto            = ""
           tt_alter_tit_acr_rateio.tta_cod_ccusto                  = "".      

    ASSIGN de_val_titulo = tt_alter_tit_acr_rateio.tta_val_aprop_ctbl. /* guarda o valor da apropriacao, para usar na criacao do titulo novo */
    
    bloco_executa_api:
    DO TRANSACTION ON ERROR UNDO bloco_executa_api,  LEAVE bloco_executa_api:

        RUN pi_main_code_integr_acr_alter_tit_acr_novo_12 in h_acr711zv (INPUT  12,
                                                                         INPUT  TABLE tt_alter_tit_acr_base_5,
                                                                         INPUT  TABLE tt_alter_tit_acr_rateio,
                                                                         INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                                                         INPUT  TABLE tt_alter_tit_acr_comis_1,
                                                                         INPUT  TABLE tt_alter_tit_acr_cheq,
                                                                         INPUT  TABLE tt_alter_tit_acr_iva,
                                                                         INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                                                         INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                                                         INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                                                         OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                                                         INPUT  NO).
    
        IF  CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:

            ASSIGN i-seq-erro-aux = 0.
            FOR EACH tt_log_erros_alter_tit_acr:
                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = i-seq-erro-aux
                       tt-erro.cd-erro  = tt_log_erros_alter_tit_acr.ttv_num_mensagem
                       tt-erro.mensagem = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda.                         
            END.

            /*Tratar os erros retornados*/
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).

            /*** Desfaz a Transacao  ..................................*/
            UNDO bloco_executa_api, LEAVE bloco_executa_api.            
            
        END.
        ELSE DO: /************ GERAR TITUNO NOVO PARA O CLIENTE DESTINO **************/

            EMPTY TEMP-TABLE tt_log_erros_atualiz.
            EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.
            EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_6.
            EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
            EMPTY TEMP-TABLE tt_integr_acr_ped_vda_pend.
            EMPTY TEMP-TABLE tt_erro_tit_acr.
            EMPTY TEMP-TABLE tt-erro.

            RUN pi-cria-lote.
        
            RUN pi-cria-item-lote.

            RELEASE tt_integr_acr_relacto_pend_cheq.
            RELEASE tt_integr_acr_cheq.
            RELEASE tt_integr_acr_aprop_ctbl_pend.
            RELEASE tt_integr_acr_item_lote_impl_6.
            RELEASE tt_integr_acr_lote_impl.
    
            RUN prgfin/acr/acr900zi.py PERSISTENT SET v_hdl_api_integr_acr.
            FIND FIRST tt_integr_acr_item_lote_impl_6 NO-LOCK NO-ERROR. /*tt_integr_acr_lote_impl NO-LOCK NO-ERROR.*/
            IF  AVAIL tt_integr_acr_item_lote_impl_6 THEN DO: /*tt_integr_acr_lote_impl THEN DO:*/
                EMPTY TEMP-TABLE tt_log_erros_atualiz.
        
                RUN pi_main_code_integr_acr_new_6 IN v_hdl_api_integr_acr (INPUT 1,
                                                                           INPUT matriz_trad_org_ext.cod_matriz_trad_org_ext,
                                                                           INPUT YES, /* log_atualiza_refer_acr */
                                                                           INPUT NO,  /* assume data de emissao */
                                                                           INPUT TABLE tt_integr_acr_repres_comis,
                                                                           INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_6,
                                                                           INPUT TABLE tt_integr_acr_aprop_relacto_2).
    
            END.
        
            DELETE PROCEDURE v_hdl_api_integr_acr.
    
            IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:                                                                
    
                ASSIGN i-seq-erro-aux = 0.
                FOR EACH tt_log_erros_atualiz:
                    ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = i-seq-erro-aux
                           tt-erro.cd-erro  = tt_log_erros_atualiz.ttv_num_mensagem
                           tt-erro.mensagem = tt_log_erros_atualiz.ttv_des_msg_erro + tt_log_erros_atualiz.ttv_des_msg_ajuda.                         
                END.
    
                /*Tratar os erros retornados*/
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    
                /*** Desfaz a Transacao  ..................................*/
                UNDO bloco_executa_api, LEAVE bloco_executa_api.   
                
            END.
        END.
    END.

    IF h_acr711zv <> ? THEN
        DELETE PROCEDURE h_acr711zv.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wWindow 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF fi_cod_estab_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Estabelecimento nÆo informado.").

        APPLY "ENTRY" TO fi_cod_estab_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cod_espec_docto_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Esp‚cie nÆo informada.").

        APPLY "ENTRY" TO fi_cod_espec_docto_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cod_ser_docto_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "S‚rie nÆo informada.").

        APPLY "ENTRY" TO fi_cod_ser_docto_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cod_tit_acr_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "T¡tulo nÆo informado.").

        APPLY "ENTRY" TO fi_cod_tit_acr_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cod_parcela_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Parcela nÆo informada.").

        APPLY "ENTRY" TO fi_cod_parcela_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cdn_cliente_dest = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Cliente nÆo informado.").

        APPLY "ENTRY" TO fi_cdn_cliente_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_nom_cliente_dest = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Cliente nÆo cadastrado.").
        APPLY "ENTRY" TO fi_nom_cliente_dest IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_cod_cta_ctbl = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Conta cont bil nÆo informada.").

        APPLY "ENTRY" TO fi_cod_cta_ctbl IN FRAME fpage0.
        RETURN "NOK".
    END.
    
    IF fi_desc_cta_ctbl = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Conta cont bil nÆo cadastrada.").
        APPLY "ENTRY" TO fi_desc_cta_ctbl IN FRAME fpage0.
        RETURN "NOK".
    END.

    IF fi_valor = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                  INPUT 17006,
                  INPUT "Valor de transferˆncia nÆo informado.").

        APPLY "ENTRY" TO fi_valor IN FRAME fpage0.
        RETURN "NOK".
    END.
    ELSE DO:
        FIND FIRST tit_acr NO-LOCK
             WHERE tit_acr.cod_estab       = fi_cod_estab      
               AND tit_acr.cod_espec_docto = fi_cod_espec_docto
               AND tit_acr.cod_ser_docto   = fi_cod_ser_docto  
               AND tit_acr.cod_tit_acr     = fi_cod_tit_acr    
               AND tit_acr.cod_parcela     = fi_cod_parcela NO-ERROR.

        IF  AVAIL tit_acr THEN DO:
            IF  tit_acr.val_sdo_tit_acr < fi_valor THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Valor de transferˆncia nÆo pode ser maior que o saldo do t¡tulo.").
        
                APPLY "ENTRY" TO fi_valor IN FRAME fpage0.
                RETURN "NOK".
            END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_retorna_sugestao_referencia wWindow 
PROCEDURE pi_retorna_sugestao_referencia :
/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
** Criado por............: Barth
** Criado em.............: 21/10/1998 09:14:30
** Alterado por..........: Souza
** Alterado em...........: 18/05/1999 10:12:58
*****************************************************************************/

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_verifica_refer_unica_acr wWindow 
PROCEDURE pi_verifica_refer_unica_acr :
/*****************************************************************************
** Procedure Interna.....: pi_verifica_refer_unica_acr
** Descricao.............: pi_verifica_refer_unica_acr
** Criado por............: Claudia
** Criado em.............: 14/08/1996 09:34:38
** Alterado por..........: its0105
** Alterado em...........: 23/08/2005 17:52:01
*****************************************************************************/

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/NÒo"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.02" &then
    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_renegoc_acr
        for renegoc_acr.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "OperaîÒo financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

