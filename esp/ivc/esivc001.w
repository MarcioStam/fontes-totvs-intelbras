&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 

/*****************************************************************************
**     Programa.........: esp/ivc/esivc001.p
**     Descricao .......: Importaá∆o Regra Destinaá∆o
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 16/05/2013
*******************************************************************************/

CREATE WIDGET-POOL.
&SCOPED-DEFINE NomProg   ESIVC001
&SCOPED-DEFINE DescProg  Importaá∆o Regras de Destinaá∆o

DEF VAR v_num_ped_exec_rpw    AS INTE.

{esinc/es0000.i}
{esp/es0018.i}

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define FRAME-NAME f-relat

&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-29 RECT-7 RECT-8 RECT-9 rs-execucao bt-imprime bt-salva 
&Scoped-Define DISPLAYED-OBJECTS rs-execucao c-arquivo 

&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(60)":U
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 TOOLTIP "Regras"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "On Line", 1, "Batch", 2
     SIZE 10.86 BY 2.5 TOOLTIP "Execuá∆o On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 3.17.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 3.25.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     rs-execucao AT ROW 2 COL 54.14 HELP
          "Execuá∆o On Line ou Batch" NO-LABEL
     c-arquivo  AT ROW 2.5 COL 2 LABEL "Arquivo"
     bt-arquivo AT ROW 2.38 COL 47.5 HELP "Localiza Arquivo"
     bt-imprime AT ROW 5.29 COL 2
     bt-salva   AT ROW 5.29 COL 13.72
     "  Arquivo Importaá∆o" VIEW-AS TEXT
          SIZE 18.57 BY .54 AT ROW 1.25 COL 3
          FONT 6
     " Execuá∆o" VIEW-AS TEXT
          SIZE 9.43 BY .54 AT ROW 1.25 COL 53.86
          FONT 6
     RECT-2  AT ROW 5 COL 1
     RECT-29 AT ROW 1.58 COL 53
     RECT-7  AT ROW 1.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.86 BY 5.83
         FONT 1
         DEFAULT-BUTTON bt-imprime.


&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "{&DescProg} - {&NomProg}"
         COLUMN             = 46.72
         ROW                = 13.5
         HEIGHT             = 5.83
         WIDTH              = 66.86
         MAX-HEIGHT         = 33.04
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 33.04
         VIRTUAL-WIDTH      = 164.57
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

/*
&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* {DescProg} - {NomProg} */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.
&ANALYZE-RESUME
*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* {DescProg} - {NomProg} */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    DEFINE VARIABLE c-dir-ini AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "FINANC":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-ini = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END.

    IF SUBSTRING(c-dir-ini, LENGTH(c-dir-ini), 1) <> "~\":U THEN
        ASSIGN c-dir-ini = c-dir-ini + "~\":U.

    ASSIGN c-dir-ini = c-dir-ini + "ivc~\regra":U.

    assign c-arq-conv = replace(input frame f-relat c-arquivo, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv"       ASK-OVERWRITE 
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR c-dir-ini
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
        display c-arq-conv @ c-arquivo with frame f-relat.
    end.

END.
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-relat /* Imprimir */
DO:
  RUN pi-vld-param.
  IF RETURN-VALUE = "no" 
  THEN RETURN NO-APPLY.
  RUN pi_salva_param.
  IF rs-execucao:SCREEN-VALUE IN FRAME f-relat = "2" THEN
  DO.
    RUN prgtec/btb/btb911za.p (INPUT  "esivc001rp",
                               INPUT  "1.00.000",
                               INPUT  0,
                               INPUT  RECID(dwb_set_list_param),
                               OUTPUT v_num_ped_exec_rpw).

    IF v_num_ped_exec_rpw <> 0 THEN
    DO.
      RUN pi_message  (INPUT "show",
                       INPUT 3556,
                       INPUT SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                             v_num_ped_exec_rpw)).
    END.
  END.
  ELSE 
  DO.
    IF SESSION:SET-WAIT-STATE("general") THEN.
    RUN esp/ivc/esivc001rp.p.
    IF SESSION:SET-WAIT-STATE("") THEN.
  END.
END.
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
  RUN pi_salva_param.
  APPLY "close" TO THIS-PROCEDURE.
END.
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 

&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-relat
DO:

    ASSIGN rs-execucao.

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF rs-execucao = 1 THEN DO:
        RUN esp/es0018p.p (INPUT  "FINANC":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto:
            ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END.

        IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "~\":U THEN
            ASSIGN c-arquivo = c-arquivo + "~\":U.

        ASSIGN c-arquivo = c-arquivo + "ivc~\regra~\esivc001.csv":U.
    END.
    ELSE DO:
        RUN esp/es0018p.p (INPUT  "FINANC":U,
                           INPUT  2,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto:
            ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END.

        IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
            ASSIGN c-arquivo = c-arquivo + "/":U.

        ASSIGN c-arquivo = c-arquivo + "ivc/regra/esivc001.csv":U.
    END.

    DISP c-arquivo WITH FRAME f-relat.     

END.


/* ***************************  Main Block  *************************** */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  run pi-recupera-param.

  APPLY "VALUE-CHANGED" TO rs-execucao IN FRAME f-relat.

  RUN enable_UI.

  /*IF NOT THIS-PROCEDURE:PERSISTENT THEN */
     WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  /*IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.*/
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
  DISPLAY rs-execucao c-arquivo WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE rs-execucao bt-imprime bt-salva WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.cod_dwb_program = "esivc001"
         AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
       
  IF AVAIL dwb_set_list_param THEN 
  DO WITH FRAME f-relat:
    ASSIGN rs-execucao:SCREEN-VALUE IN FRAME f-relat = ENTRY(01,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c-arquivo:SCREEN-VALUE   IN FRAME f-relat = ENTRY(02,dwb_set_list_param.cod_dwb_parameters,CHR(10)) NO-ERROR.
  END.   
END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-param C-Win 
PROCEDURE pi-vld-param :

if input frame f-relat rs-execucao = 2 then 
do:
  for each ped_exec no-lock
      where ped_exec.cod_prog_dtsul = "esivc001"
        and ped_exec.ind_sit_ped    = "1" :
          
    find ped_exec_param  of ped_exec no-lock no-error.
    if avail ped_exec_param then 
    do:
      if ped_exec_param.cod_dwb_file = input frame f-relat c-arquivo then 
      do:
        run utp/message2.p (input "Nome do Arquivo encontrado em outro pedido,Deseja continuar ? ",
                            input  "Foi encontrado um pedido com o mesmo nome a ser criado."      + chr(10) +
                                   "Arquivo....: " + ped_exec_param.cod_dwb_file + chr(10) +
                                   "Usuario....: " + ped_exec.cod_usuar   + chr(10) +
                                   "Num Pedido.: " + string(ped_exec_param.num_ped_exec)).
        leave.
      end.  
    end.
  end.    
end.
END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esivc001" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esivc001"
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

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :

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

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :

  ASSIGN INPUT FRAME f-relat c-arquivo
                             rs-execucao.
  RUN prgtec/btb/btb906za.p.    

  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.Cod_dwb_program = "esivc001"
         AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL dwb_set_list_param 
  THEN CREATE dwb_set_list_param.
    
  ASSIGN dwb_set_list_param.Cod_dwb_program          = "esivc001"
         dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         dwb_set_list_param.Cod_dwb_file             = "esivc001.txt"
         dwb_set_list_param.Cod_dwb_output           = "Arquivo".
                                                                        
  ASSIGN dwb_set_list_param.Cod_dwb_parameters = STRING(rs-execucao) + CHR(10) + STRING(c-arquivo) NO-ERROR.

END PROCEDURE.

&ANALYZE-RESUME
