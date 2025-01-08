&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME ESAPB100e
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ESAPB100e 
CREATE WIDGET-POOL.

DEF VAR c-corpo-mail    AS LONGCHAR NO-UNDO.
DEF VAR c-corpo-email-ini AS LONGCHAR NO-UNDO.
DEF VAR c-corpo-email-fim AS LONGCHAR NO-UNDO.
DEF VAR c-destinatario  AS CHAR FORMAT "x(200)" NO-UNDO.
DEF VAR de-total        LIKE item_bord_ap.val_pagto NO-UNDO.
DEF VAR da-data-bord    AS DATE NO-UNDO.

DEF VAR c-ant                    AS CHAR.
DEF VAR v_num_ped_exec_rpw       AS INTE.
DEF VAR v_log_det                AS LOGICAL INIT NO.
DEF VAR v_cod_exessao            AS CHAR.
DEF VAR c-impressora             AS CHAR.
DEF VAR c-layout                 AS CHAR.
DEF VAR wh-exessao               as HANDLE.
DEF VAR i-cont                   AS INT.
DEF VAR c_aux_histor             AS CHAR                                                                                                     NO-UNDO.
DEF VAR v_val_tot_impto          AS DEC     FORMAT "->>>,>>>,>>9.99":U DECIMALS 2 LABEL "Total a Ratear" COLUMN-LABEL "Valor Total a Ratear" NO-UNDO.
DEF VAR v_log_impto_vincul_refer AS LOGICAL FORMAT "Sim/N∆o" INIT YES                                                                        NO-UNDO.
DEF VAR i-nr-titulos             AS INT INIT 0                                                                                               NO-UNDO.

DEF VAR v_conhec_house  LIKE embarque-imp.cod-conhecto-house  NO-UNDO.
DEF VAR v_conhec_master LIKE embarque-imp.cod-conhecto-master NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_msg_financ AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bas-tg-envio-email   as widget-handle       no-undo.

{cdp/cdcfgfin.i}
{esp/es0018.i}
{utp/ut-glob.i}
{esp/acr/esacr016tt.i}
{utp/utapi019.i} /* Temp-table para envio de e-mail */ 

RUN esp/es0018p.p (INPUT "bas_bord_apb",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

DEF TEMP-TABLE tt-bord NO-UNDO
    FIELD matriz              LIKE emitente.nome-abrev
    FIELD cod-emitente-matriz AS INTEGER
    FIELD cgc-matriz          AS CHAR FORMAT "x(20)"
    FIELD emitente            LIKE emitente.cod-emitente
    FIELD emitente-cgc        AS CHAR FORMAT "x(20)"
    FIELD emitente-nome-abrev LIKE emitente.nome-abrev
    FIELD cod_tit_ap          LIKE item_bord_ap.cod_tit_ap
    FIELD cod_parcela         LIKE item_bord_ap.cod_parcela
    FIELD val_pagto           LIKE item_bord_ap.val_pagto
    FIELD email               AS CHAR FORMAT "x(70)"
    FIELD banco               LIKE item_bord_ap.cod_banco               
    FIELD agencia             LIKE item_bord_ap.cod_agenc_bcia_pagto    
    FIELD conta-corren        LIKE item_bord_ap.cod_cta_corren_bco_pagto
    FIELD estabel             LIKE item_bord_ap.cod_estab_bord
    FIELD portador            LIKE item_bord_ap.cod_portador
    FIELD bordero             LIKE item_bord_ap.num_bord_ap
    FIELD dat_pagto           LIKE item_bord_ap.dat_pagto_tit_ap
    FIELD val_liq             LIKE item_bord_ap.val_pagto
    FIELD historico           LIKE histor_tit_movto_ap.des_text_histor
    FIELD conhec-house        LIKE embarque-imp.cod-conhecto-house 
    FIELD conhec-master       LIKE embarque-imp.cod-conhecto-master
    FIELD cod_chave_pix       LIKE item_bord_ap.cod_chave_pix_tit.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bord_ap_upc AS RECID       NO-UNDO
    FORMAT ">>>>>>9":U
    INITIAL ?.

 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

DEF BUFFER b-emitente FOR emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES mensagem

/* Definitions for FRAME f-relat                                        */
&Scoped-define QUERY-STRING-f-relat FOR EACH mensagem SHARE-LOCK
&Scoped-define OPEN-QUERY-f-relat OPEN QUERY f-relat FOR EACH mensagem SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-relat mensagem
&Scoped-define FIRST-TABLE-IN-QUERY-f-relat mensagem


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ed-copia cod-mensagem-ini c-narrativa-ini ~
cod-mensagem-fim c-narrativa-fim bt-ok bt-salva RECT-2 RECT-31 RECT-35 ~
RECT-36 
&Scoped-Define DISPLAYED-OBJECTS ed-copia cod-mensagem-ini texto-mensag-ini ~
c-narrativa-ini cod-mensagem-fim texto-mensag-fim c-narrativa-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR ESAPB100e AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 11.14 BY 1 TOOLTIP "OK"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-narrativa-fim AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 81.86 BY 2.92.

DEFINE VARIABLE c-narrativa-ini AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 81.86 BY 2.92.

DEFINE VARIABLE ed-copia AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 83 BY 2.75 NO-UNDO.

DEFINE VARIABLE texto-mensag-fim AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60.86 BY 3.25.

DEFINE VARIABLE texto-mensag-ini AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.13
     FGCOLOR 0 .

DEFINE VARIABLE cod-mensagem-fim AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Mensagem Padr∆o Final" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .88.

DEFINE VARIABLE cod-mensagem-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Mensagem Padr∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.57 BY 7.75.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.72 BY 7.75.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.57 BY 3.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-relat FOR 
      mensagem SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     ed-copia AT ROW 1.75 COL 2.14 NO-LABEL WIDGET-ID 12
     cod-mensagem-ini AT ROW 6 COL 18.86 COLON-ALIGNED
     texto-mensag-ini AT ROW 6 COL 25 NO-LABEL
     c-narrativa-ini AT ROW 9.83 COL 3.14 NO-LABEL
     cod-mensagem-fim AT ROW 14.54 COL 18.14 COLON-ALIGNED
     texto-mensag-fim AT ROW 14.54 COL 24.14 NO-LABEL
     c-narrativa-fim AT ROW 18.58 COL 3.14 NO-LABEL
     bt-ok AT ROW 22.29 COL 2
     bt-salva AT ROW 22.29 COL 73.86
     " Mensagem Inicial" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 5.17 COL 2.43
          FONT 6
     " Narrativa Inicial" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 9.17 COL 2.57
     " Mensagem Final" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 13.63 COL 2.14
          FONT 6
     " Narrativa Final" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 17.79 COL 2.57
     "C¢piar email para:" VIEW-AS TEXT
          SIZE 13.14 BY .54 AT ROW 1.13 COL 2.86 WIDGET-ID 10
     RECT-2 AT ROW 22 COL 1
     RECT-31 AT ROW 5.5 COL 1.43
     RECT-35 AT ROW 14 COL 1.43 WIDGET-ID 6
     RECT-36 AT ROW 1.5 COL 1.43 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.86 BY 23.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW ESAPB100e ASSIGN
         HIDDEN             = YES
         TITLE              = "Narrativa E-mail"
         COLUMN             = 17.43
         ROW                = 6
         HEIGHT             = 22.88
         WIDTH              = 85.72
         MAX-HEIGHT         = 29.13
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29.13
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ESAPB100e
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR EDITOR texto-mensag-fim IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR texto-mensag-ini IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ESAPB100e)
THEN ESAPB100e:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _TblList          = "mgcad.mensagem"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ESAPB100e
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ESAPB100e ESAPB100e
ON END-ERROR OF ESAPB100e /* Narrativa E-mail */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ESAPB100e ESAPB100e
ON WINDOW-CLOSE OF ESAPB100e /* Narrativa E-mail */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok ESAPB100e
ON CHOOSE OF bt-ok IN FRAME f-relat /* OK */
DO:

  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini NO-ERROR.
  IF  NOT AVAIL msg_financ THEN DO:
      RUN utp/ut-msgs.p ("SHOW",
                         INPUT 17006,
                         INPUT "Mensagem Padr∆o Inicial n∆o cadastrada").
      RETURN NO-APPLY.
  END.
  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim NO-ERROR.
  IF  NOT AVAIL msg_financ THEN DO:
      RUN utp/ut-msgs.p ("SHOW",
                         INPUT 17006,
                         INPUT "Mensagem Padr∆o Final n∆o cadastrada").
      RETURN NO-APPLY.
  END.

  RUN pi-monta-corpo-email.

  APPLY "close" TO THIS-PROCEDURE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva ESAPB100e
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-mensagem-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim ESAPB100e
ON F5 OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
  RUN prgint/ufn/ufn004ka.r.
  FIND msg_financ NO-LOCK 
      WHERE RECID(msg_financ) = v_rec_msg_financ NO-ERROR.
  IF AVAIL msg_financ THEN 
      ASSIGN cod-mensagem-fim:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.cod_mensagem)
             texto-mensag-fim:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.des_mensagem).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim ESAPB100e
ON LEAVE OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
    FIND FIRST msg_financ NO-LOCK
        WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim NO-ERROR.
    ASSIGN texto-mensag-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL msg_financ THEN msg_financ.des_mensagem ELSE "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim ESAPB100e
ON MOUSE-SELECT-DBLCLICK OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-mensagem-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini ESAPB100e
ON F5 OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
  RUN prgint/ufn/ufn004ka.r.
  FIND msg_financ NO-LOCK 
      WHERE RECID(msg_financ) = v_rec_msg_financ NO-ERROR.
  IF AVAIL msg_financ THEN 
      ASSIGN cod-mensagem-ini:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.cod_mensagem)
             texto-mensag-ini:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.des_mensagem).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini ESAPB100e
ON LEAVE OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
    FIND FIRST msg_financ NO-LOCK
        WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini NO-ERROR.
    ASSIGN texto-mensag-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL msg_financ THEN msg_financ.des_mensagem ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini ESAPB100e
ON MOUSE-SELECT-DBLCLICK OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ESAPB100e 


/* ***************************  Main Block  *************************** */

cod-mensagem-ini:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME f-relat.
cod-mensagem-fim:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME f-relat.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  FOR EACH tt-prog-ponto:
      IF  ed-copia:SCREEN-VALUE IN FRAME f-relat = "" THEN
          ASSIGN ed-copia:SCREEN-VALUE IN FRAME f-relat = tt-prog-ponto.conteudo.
      ELSE
          ASSIGN ed-copia:SCREEN-VALUE IN FRAME f-relat =  ed-copia:SCREEN-VALUE IN FRAME f-relat + ";" + tt-prog-ponto.conteudo.
  END.


  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
     WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ESAPB100e  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ESAPB100e)
  THEN DELETE WIDGET ESAPB100e.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ESAPB100e  _DEFAULT-ENABLE
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
  DISPLAY ed-copia cod-mensagem-ini texto-mensag-ini c-narrativa-ini 
          cod-mensagem-fim texto-mensag-fim c-narrativa-fim 
      WITH FRAME f-relat IN WINDOW ESAPB100e.
  ENABLE ed-copia cod-mensagem-ini c-narrativa-ini cod-mensagem-fim 
         c-narrativa-fim bt-ok bt-salva RECT-2 RECT-31 RECT-35 RECT-36 
      WITH FRAME f-relat IN WINDOW ESAPB100e.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW ESAPB100e.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-mail ESAPB100e 
PROCEDURE pi-gera-mail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = c-destinatario
           tt-envio2.remetente         = /*IF usuar_mestre.cod_e_mail_local = "" THEN*/ "ems@intelbras.com.br" /*ELSE usuar_mestre.cod_e_mail_local*/
           tt-envio2.copia             = REPLACE (ed-copia:SCREEN-VALUE IN FRAME f-relat, " ", "")
           tt-envio2.assunto           = "Programaá∆o de Pagamentos: " + STRING(da-data-bord, "99/99/9999") + " - Intelbras"
           tt-envio2.arq-anexo         = ""
           tt-envio2.formato           = "HTML".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email-ini.

    IF  c-corpo-email-fim <> "" 
    AND c-corpo-email-fim <> ? THEN DO:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 2
               tt-mensagem.mensagem     = c-corpo-email-fim.
    END.
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL tt-erros THEN DO:
         EMPTY TEMP-TABLE tt_cliente_integr .
         EMPTY TEMP-TABLE tt_fornecedor_integr.       
         EMPTY TEMP-TABLE tt_clien_financ_integr_e.       
         EMPTY TEMP-TABLE tt_fornec_financ_integr_d.       
         EMPTY TEMP-TABLE tt_pessoa_jurid_integr_e.       
         EMPTY TEMP-TABLE tt_pessoa_fisic_integr_e.       
         EMPTY TEMP-TABLE tt_contato_integr_e.       
         EMPTY TEMP-TABLE tt_contat_clas_integr.       
         EMPTY TEMP-TABLE tt_estrut_fornec_integr.       
         EMPTY TEMP-TABLE tt_estrut_fornec_integr.       
         EMPTY TEMP-TABLE tt_histor_fornec_integr.      
         EMPTY TEMP-TABLE tt_ender_entreg_integr_e.       
         EMPTY TEMP-TABLE tt_telef_integr.       
         EMPTY TEMP-TABLE tt_telef_pessoa_integr.       
         EMPTY TEMP-TABLE tt_pj_ativid_integr.       
         EMPTY TEMP-TABLE tt_pj_ramo_negoc_integr.       
         EMPTY TEMP-TABLE tt_porte_pj_integr.
         EMPTY TEMP-TABLE tt_idiom_pf_integr.      
         EMPTY TEMP-TABLE tt_idiom_contat_integr.

         /* ** Gera hist¢rico do envio de e-mail para o FORNECEDOR ***/
         FIND LAST histor_fornec NO-LOCK
             WHERE histor_fornec.cod_empresa = v_cod_empres_usuar
             AND   histor_fornec.cdn_fornec  = tt-bord.emitente NO-ERROR.
         IF AVAIL histor_fornec THEN
             ASSIGN i-sequencia = histor_fornec.num_seq_histor_fornec + 1.
         ELSE 
             ASSIGN i-sequencia = 1.

         CREATE tt_histor_fornec_integr.
         ASSIGN tt_histor_fornec_integr.tta_cod_empresa                  = v_cod_empres_usuar 
                tt_histor_fornec_integr.tta_cdn_fornec                   = tt-bord.emitente
                tt_histor_fornec_integr.tta_num_seq_histor_fornec        = i-sequencia
                tt_histor_fornec_integr.tta_des_abrev_histor_fornec      = STRING(TODAY,"99/99/9999") + " * E-mail de Pagamentos." 
                tt_histor_fornec_integr.ttv_num_tip_operac               = 1
                tt_histor_fornec_integr.tta_des_histor_fornec            = "Bord " + tt-bord.estabel + "/" + tt-bord.portador + "/" +  STRING(tt-bord.bordero) 
                                                                           + " R$ " + trim(string(de-total,">>>,>>>,>>9.99")) .

         RUN prgint/utb/utb765ze.py(1,
                                    INPUT TABLE tt_cliente_integr,
                                    INPUT TABLE tt_fornecedor_integr,
                                    INPUT TABLE tt_clien_financ_integr_e,
                                    INPUT TABLE tt_fornec_financ_integr_d,
                                    INPUT TABLE tt_pessoa_jurid_integr_e,
                                    INPUT TABLE tt_pessoa_fisic_integr_e,
                                    INPUT TABLE tt_contato_integr_e,
                                    INPUT TABLE tt_contat_clas_integr,
                                    INPUT TABLE tt_estrut_clien_integr,
                                    INPUT TABLE tt_estrut_fornec_integr,
                                    INPUT TABLE tt_histor_clien_integr,
                                    INPUT TABLE tt_histor_fornec_integr,
                                    INPUT TABLE tt_ender_entreg_integr_e,
                                    INPUT TABLE tt_telef_integr,
                                    INPUT TABLE tt_telef_pessoa_integr,
                                    INPUT TABLE tt_pj_ativid_integr,
                                    INPUT TABLE tt_pj_ramo_negoc_integr,
                                    INPUT TABLE tt_porte_pj_integr,
                                    INPUT TABLE tt_idiom_pf_integr,
                                    INPUT TABLE tt_idiom_contat_integr,
                                    INPUT "", /*Matriz de Traduá∆o Organizacional*/
                                    INPUT "", /*Empresa*/
                                    INPUT-OUTPUT TABLE tt_retorno_clien_fornec).
    END.

    IF  VALID-HANDLE(h-utapi019) 
    THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-corpo-email ESAPB100e 
PROCEDURE pi-monta-corpo-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR c-lista-emit-sem-mail AS CHAR FORMAT "x(3000)" NO-UNDO.

  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini NO-ERROR.
  IF NOT AVAIL msg_financ THEN DO:
     RUN utp/ut-msgs.p("show",
                       17006,
                       "Mensagem Padr∆o Inicial n∆o cadastrada").
     RETURN "NOK".
  END.

  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim NO-ERROR.
  IF NOT AVAIL msg_financ THEN DO:
     RUN utp/ut-msgs.p("show",
                       17006,
                       "Mensagem Padr∆o Final n∆o cadastrada").
     RETURN "NOK".
  END.

  EMPTY TEMP-TABLE tt-bord.
  
  FIND FIRST bord_ap
       WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-LOCK NO-ERROR.

  IF  AVAIL bord_ap THEN
      ASSIGN da-data-bord = bord_ap.dat_transacao.

   FOR EACH item_bord_ap OF bord_ap NO-LOCK
      ,FIRST forma_pagto NO-LOCK
          WHERE forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto
            AND (forma_pagto.ind_tip_forma_pagto = "DOC"                    OR
                 forma_pagto.ind_tip_forma_pagto = "TED CIP"                OR 
                 forma_pagto.ind_tip_forma_pagto = "TED STR"                OR
                 forma_pagto.ind_tip_forma_pagto = "CrÇdito Conta Corrente" OR
                 forma_pagto.ind_tip_forma_pagto = "PIX transferància"      OR
                 forma_pagto.ind_tip_forma_pagto = "Ordem de Pagamento"):

      IF  item_bord_ap.ind_sit_item_bord_ap = "Estornado" THEN
          NEXT.

      ASSIGN v_conhec_house  = ""
             v_conhec_master = "".

      FIND emitente NO-LOCK
          WHERE emitente.cod-emitente = ITEM_bord_ap.cdn_fornecedor NO-ERROR.
      IF  AVAIL emitente THEN DO:
      
          FIND b-emitente NO-LOCK
              WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

          IF  NOT AVAIL b-emitente THEN
              NEXT.

          FIND FIRST tit_ap 
               WHERE tit_ap.cod_estab        = item_bord_ap.cod_estab
               AND tit_ap.cod_espec_docto    = item_bord_ap.cod_espec_docto
               AND tit_ap.cod_ser_docto      = item_bord_ap.cod_ser_docto
               AND tit_ap.cdn_fornecedor     = item_bord_ap.cdn_fornecedor
               AND tit_ap.cod_tit_ap         = item_bord_ap.cod_tit_ap
               AND tit_ap.cod_parcela        = item_bord_ap.cod_parcela NO-LOCK NO-ERROR.

          IF  AVAIL tit_ap THEN DO:

              ASSIGN c_aux_histor = "".

              FIND FIRST movto_tit_ap OF tit_ap
                  WHERE  movto_tit_ap.ind_trans_ap = "Implantaá∆o" NO-LOCK NO-ERROR.

              IF  AVAIL movto_tit_ap THEN DO:
                  FIND FIRST histor_tit_movto_ap 
                      WHERE histor_tit_movto_ap.cod_estab           = tit_ap.cod_estab
                      AND   histor_tit_movto_ap.num_id_tit_ap       = tit_ap.num_id_tit_ap
                      AND   histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                      AND   histor_tit_movto_ap.ind_orig_histor_ap <> "Erro"
                      NO-LOCK NO-ERROR.

                  IF  AVAIL histor_tit_movto_ap THEN DO:
                  
                      IF  substr(histor_tit_movto_ap.des_text_histor,1,5) = "verba" THEN
                          ASSIGN c_aux_histor = trim(histor_tit_movto_ap.des_text_histor).

                      IF  substr(histor_tit_movto_ap.des_text_histor,1,15) = "Notas Devoluá∆o" THEN
                          ASSIGN c_aux_histor = trim(histor_tit_movto_ap.des_text_histor).
                  END.
              END.

              IF  tit_ap.cod_espec_docto = "DI" THEN DO:
                  FIND FIRST embarque-imp
                      WHERE embarque-imp.cod-estabel = tit_ap.cod_estab
                      AND   embarque-imp.embarque    = tit_ap.cod_tit_ap NO-LOCK NO-ERROR.
        
                  IF  AVAIL embarque-imp THEN DO:
                      IF  embarque-imp.cod-conhecto-house <> "" 
                      AND embarque-imp.cod-conhecto-house <> "?"
                      AND embarque-imp.cod-conhecto-house <> ? THEN
                          ASSIGN v_conhec_house  = embarque-imp.cod-conhecto-house.

                      IF  embarque-imp.cod-conhecto-master <> "" 
                      AND embarque-imp.cod-conhecto-master <> "?"
                      AND embarque-imp.cod-conhecto-master <> ? THEN
                          ASSIGN v_conhec_master = embarque-imp.cod-conhecto-master.
                  END.
              END.
          END.
              
          run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab_bord,
                                      Input "",
                                      Input item_bord_ap.cod_portador,
                                      Input item_bord_ap.num_bord_ap,
                                      Input item_bord_ap.num_seq_bord,
                                      Input yes,
                                      Input bord_ap.dat_transacao,
                                      Input "Retido" /*l_retido*/,
                                      output v_log_impto_vincul_refer,
                                      output v_val_tot_impto,
                                      Input ?,
                                      Input ?,
                                      Input ?).

          IF  item_bord_ap.cod_refer_antecip_pef <> "" 
          AND item_bord_ap.cod_refer_antecip_pef <> ? THEN
              find first antecip_pef_pend no-lock 
                  where  antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                  and    antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef no-error.
        
          CREATE tt-bord.
          ASSIGN tt-bord.matriz              = b-emitente.nome-matriz
                 tt-bord.cod-emitente-matriz = b-emitente.cod-emitente
                 tt-bord.cgc-matriz          = b-emitente.cgc
                 tt-bord.emitente            = emitente.cod-emitente
                 tt-bord.emitente-cgc        = emitente.cgc
                 tt-bord.emitente-nome-abrev = emitente.nome-abrev 
                 tt-bord.cod_tit_ap          = IF  item_bord_ap.cod_refer_antecip_pef <> "" AND item_bord_ap.cod_refer_antecip_pef <> ? AND AVAIL antecip_pef_pend THEN antecip_pef_pend.cod_tit_ap  ELSE item_bord_ap.cod_tit_ap  
                 tt-bord.cod_parcela         = IF  item_bord_ap.cod_refer_antecip_pef <> "" AND item_bord_ap.cod_refer_antecip_pef <> ? AND AVAIL antecip_pef_pend THEN antecip_pef_pend.cod_parcela ELSE item_bord_ap.cod_parcela 
                 tt-bord.val_pagto           = item_bord_ap.val_pagto
                 tt-bord.email               = emitente.e-mail
                 tt-bord.banco               = item_bord_ap.cod_bco_pagto
                 tt-bord.agencia             = item_bord_ap.cod_agenc_bcia_pagto + "-" + item_bord_ap.cod_digito_agenc_bcia_pagto
                 tt-bord.conta-corren        = item_bord_ap.cod_cta_corren_bco_pagto + "-" + item_bord_ap.cod_digito_cta_corren_pagto
                 tt-bord.estabel             = item_bord_ap.cod_estab_bord
                 tt-bord.portador            = item_bord_ap.cod_portador
                 tt-bord.bordero             = item_bord_ap.num_bord_ap
                 tt-bord.historico           = IF c_aux_histor <> "" THEN c_aux_histor ELSE ""
                 tt-bord.dat_pagto           = item_bord_ap.dat_pagto_tit_ap
                 tt-bord.conhec-house        = v_conhec_house
                 tt-bord.conhec-master       = v_conhec_master
                 tt-bord.cod_chave_pix       = item_bord_ap.cod_chave_pix_tit
                 tt-bord.val_liq             = item_bord_ap.val_pagto 
                                             + item_bord_ap.val_multa_tit_ap 
                                             + item_bord_ap.val_juros 
                                             - item_bord_ap.val_desc_tit_ap 
                                             - item_bord_ap.val_abat_tit_ap
                                             - v_val_tot_impto.

          IF  item_bord_ap.log_pix_sem_chave = YES THEN DO:
              
              find first cta_corren_fornec no-lock
                   where cta_corren_fornec.cod_empresa    = item_bord_ap.cod_empresa
                   and   cta_corren_fornec.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                   and   cta_corren_fornec.log_cta_corren_prefer no-error.

              IF  AVAIL cta_corren_fornec THEN
                  ASSIGN tt-bord.banco        = cta_corren_fornec.cod_banco         
                         tt-bord.agencia      = cta_corren_fornec.cod_agenc_bcia    
                         tt-bord.conta-corren = cta_corren_fornec.cod_cta_corren_bco.
          END.

          IF  emitente.nome-matriz <> emitente.nome-abrev 
          AND emitente.e-mail <> b-emitente.e-mail THEN
              ASSIGN tt-bord.email = tt-bord.email + ";" + b-emitente.e-mail.
      END.

  END.

  /* Agrupa enviando 1 email para cada Matriz.*/
  DEF VAR c-notas  AS CHAR NO-UNDO.
  DEF VAR c-tabela AS LONGCHAR NO-UNDO.
  DEF VAR l-gerou-algo AS LOG NO-UNDO.
  DEF VAR h-acomp AS HANDLE NO-UNDO.

  RUN utp/ut-acomp PERSISTENT SET h-acomp.
  RUN pi-inicializar IN h-acomp ("Verificando pagamentos").

  ASSIGN i-nr-titulos = 0.

  FOR EACH tt-bord
      BREAK BY tt-bord.emitente:

      ASSIGN i-nr-titulos = i-nr-titulos + 1.

      IF  FIRST-OF (tt-bord.emitente) 
      OR  i-nr-titulos = 1 THEN DO:
          ASSIGN c-tabela = c-tabela + "<p><TABLE BORDER ALIGN='CENTER' BGCOLOR='#FFFFFF' WIDTH='" + string(900) + "'>" + "<BR>".
                 c-tabela = c-tabela + "<TR>".
                
           ASSIGN c-tabela = c-tabela + "<TH>" + "Data de Pagamento" + "</TH>" 
                  c-tabela = c-tabela + "<TH>" + "CNPJ" + "</TH>" 
                  c-tabela = c-tabela + "<TH>" + "Nome Abrev." + "</TH>" 
                  c-tabela = c-tabela + "<TH>" + "T°tulo" + "</TH>" 
                  c-tabela = c-tabela + "<TH>" + "Parcela" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Banco" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Agància" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "C.Corrente" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Chave PIX" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Valor" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Hist¢rico" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Conhec.House" + "</TH>"
                  c-tabela = c-tabela + "<TH>" + "Conhec.Master" + "</TH>" + "</TR>".
      END.

      ASSIGN c-tabela = c-tabela + "<TR>" + "<TD ALIGN=" +  "'" + "center" + "'" + ">"  + string(tt-bord.dat_pagto)                     +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "center" + "'" + ">"  + tt-bord.emitente-cgc                          +  "</TD>"  
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "center" + "'" + ">"  + tt-bord.emitente-nome-abrev                   +  "</TD>"  
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "center" + "'" + ">"  + tt-bord.cod_tit_ap                            +  "</TD>"  
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "center" + "'" + ">"  + tt-bord.cod_parcela                           +  "</TD>"  
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.banco                                 +  "</TD>"   
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.agencia                               +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.conta-corren                          +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.cod_chave_pix                         +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + string(tt-bord.val_liq, ">>>,>>>,>>9.99")     +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.historico                             +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.conhec-house                          +  "</TD>"
             c-tabela = c-tabela +          "<TD ALIGN=" +  "'" + "right"  + "'" + ">"  + tt-bord.conhec-master                         +  "</TD>" + "</TR>".   
      
      ASSIGN de-total = de-total + tt-bord.val_liq.

      IF  LAST-OF (tt-bord.emitente) 
      OR  i-nr-titulos > 70 THEN DO:

          RUN pi-acompanhar IN h-acomp ("Gerando email para fornecedor: " + tt-bord.emitente-nome-abrev).

          /*
          ASSIGN c-corpo-mail = replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-ini, chr(13), "<BR>"), chr(10), "<BR>").

          IF  INPUT FRAME {&FRAME-NAME} c-narrativa-ini <> "" THEN
              ASSIGN c-corpo-mail = c-corpo-mail + "<BR><BR>" + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-ini, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".
        
          ASSIGN c-corpo-mail = c-corpo-mail +  c-tabela + "</TABLE></p>".
                                                                                 
          ASSIGN c-tabela = "".

          ASSIGN c-tabela = c-tabela + "<p><TABLE BORDER ALIGN='CENTER' BGCOLOR='#FFFFFF' WIDTH='" + string(900) + "'>".
                 c-tabela = c-tabela + "<TR>".

          ASSIGN c-tabela = c-tabela + "<TR>" + "<TH ALIGN=" +  "'" + "right"  + "'" + ">"  + "TOTAL L÷QUIDO: " + TRIM(STRING(de-total,">>>,>>>,>>9.99")) + "</TH>"  + "</TR>".

          ASSIGN c-corpo-mail = c-corpo-mail + c-tabela + "</TABLE></p>" + "<BR>"
                 c-corpo-mail = c-corpo-mail + replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>" + "<BR>".
                 c-corpo-mail = c-corpo-mail + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".
          */

          IF  i-nr-titulos > 70 THEN DO:
              ASSIGN c-corpo-email-ini = replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-ini, chr(13), "<BR>"), chr(10), "<BR>").

              IF  INPUT FRAME {&FRAME-NAME} c-narrativa-ini <> "" THEN
                  ASSIGN c-corpo-email-ini = c-corpo-email-ini + "<BR><BR>" + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-ini, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".

              ASSIGN c-corpo-email-ini = c-corpo-email-ini +  c-tabela + "</TABLE></p>".

              ASSIGN c-tabela = "".

              ASSIGN c-tabela = c-tabela + "<p><TABLE BORDER ALIGN='CENTER' BGCOLOR='#FFFFFF' WIDTH='" + string(900) + "'>".
                     c-tabela = c-tabela + "<TR>".

              ASSIGN c-corpo-email-ini = c-corpo-email-ini + c-tabela + "</TABLE></p>" + "<BR>" + "<BR>".
          END.

          ASSIGN c-destinatario = tt-bord.email.

          IF  i-nr-titulos <= 70 THEN DO:
              IF  c-corpo-email-ini = "" THEN DO:
                  ASSIGN c-corpo-email-ini = replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-ini, chr(13), "<BR>"), chr(10), "<BR>").
    
                  IF  INPUT FRAME {&FRAME-NAME} c-narrativa-ini <> "" THEN
                      ASSIGN c-corpo-email-ini = c-corpo-email-ini + "<BR><BR>" + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-ini, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".
    
                  ASSIGN c-corpo-email-ini = c-corpo-email-ini +  c-tabela + "</TABLE></p>".
    
                  ASSIGN c-tabela = "".
    
                  ASSIGN c-tabela = c-tabela + "<p><TABLE BORDER ALIGN='CENTER' BGCOLOR='#FFFFFF' WIDTH='" + string(900) + "'>".
                         c-tabela = c-tabela + "<TR>".
    
                  ASSIGN c-tabela = c-tabela + "<TR>" + "<TH ALIGN=" +  "'" + "right"  + "'" + ">"  + "TOTAL L÷QUIDO: " + TRIM(STRING(de-total,">>>,>>>,>>9.99")) + "</TH>"  + "</TR>".
    
                  ASSIGN c-corpo-email-ini = c-corpo-email-ini + c-tabela + "</TABLE></p>" + "<BR>" + "<BR>"
                         c-corpo-email-ini  = c-corpo-email-ini  + replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>" + "<BR>".
                         c-corpo-email-ini  = c-corpo-email-ini  + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".
              END.
              ELSE DO:
                  IF  c-corpo-email-ini <> "" 
                  AND c-corpo-email-fim = "" THEN DO:
                      ASSIGN c-corpo-email-fim  = "<BR>" + "<BR>"  +  c-tabela + "</TABLE></p>".
                                                                                             
                      ASSIGN c-tabela = "".
            
                      ASSIGN c-tabela = c-tabela + "<p><TABLE BORDER ALIGN='CENTER' BGCOLOR='#FFFFFF' WIDTH='" + string(900) + "'>".
                             c-tabela = c-tabela + "<TR>".
            
                      ASSIGN c-tabela = c-tabela + "<TR>" + "<TH ALIGN=" +  "'" + "right"  + "'" + ">"  + "TOTAL L÷QUIDO: " + TRIM(STRING(de-total,">>>,>>>,>>9.99")) + "</TH>"  + "</TR>".
            
                      ASSIGN c-corpo-email-fim  = c-corpo-email-fim  + c-tabela + "</TABLE></p>" + "<BR>"
                             c-corpo-email-fim  = c-corpo-email-fim  + replace(replace(INPUT FRAME {&FRAME-NAME} texto-mensag-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>" + "<BR>".
                             c-corpo-email-fim  = c-corpo-email-fim  + replace(replace(INPUT FRAME {&FRAME-NAME} c-narrativa-fim, chr(13), "<BR>"), chr(10), "<BR>") + "<BR>".

                  END.
              END.

              RUN pi-gera-mail.

              ASSIGN c-notas           = ""
                     c-tabela          = ""
                     c-corpo-mail      = ""
                     de-total          = 0
                     c-corpo-email-ini = ""
                     c-corpo-email-fim = "".     
    
              IF  c-destinatario  = "" THEN
                  ASSIGN c-lista-emit-sem-mail = c-lista-emit-sem-mail + string(tt-bord.emitente) + " - " + tt-bord.emitente-nome-abrev + CHR(10).
              ELSE
                  l-gerou-algo = YES.
          
          END.

          ASSIGN i-nr-titulos = 0.
      END.
  END.

  IF  VALID-HANDLE(h-acomp) THEN
      DELETE PROCEDURE h-acomp.

  IF  NOT l-gerou-algo THEN
      RUN utp/ut-msgs.p("show",
                  17006,
                  "N∆o existem pagamentos para a data. Nenhum e-mail foi enviado.").
  ELSE DO:
      IF  VALID-HANDLE(wh-bas-tg-envio-email) THEN
          ASSIGN wh-bas-tg-envio-email:CHECKED = YES.

      RUN utp/ut-msgs ("SHOW",
                       15825,
                       "E-mails foram enviados com sucesso.").
  END.

  IF  c-lista-emit-sem-mail <> "" THEN
      RUN utp/ut-msgs ("SHOW",
                       15825,
                       "Os fornecedores abaixo n∆o possuem email para envio ~~" + c-lista-emit-sem-mail ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario ESAPB100e 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esacr014a" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esacr014a"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message ESAPB100e 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

