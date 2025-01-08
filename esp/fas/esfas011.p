&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*--------------------------------------------------------------------------------------------------------------------
** Nome Externo .........: esp/fas/esfas011.p
** Data Criaá∆o .........: 17/06/2013
** Criado por ...........: Sensus Tecnologia
----------------------------------------------------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar         as CHARACTER format "x(03)":U label "Empresa"              column-label "Empresa"          no-undo.
def new global shared var v_cod_estab_usuar          as CHARACTER format "x(03)":U label "Estabelecimento"      column-label "Estab"            no-undo.
def new global shared var v_cod_grp_usuar_lst        as CHARACTER format "x(03)":U label "Grupo Usu†rios"       column-label "Grupo"            no-undo.
def new global shared var v_cod_idiom_usuar          as CHARACTER format "x(08)":U label "Idioma"               column-label "Idioma"           no-undo.
def new global shared var v_cod_pais_empres_usuar    as CHARACTER format "x(03)":U label "Pa°s Empresa Usu†rio" column-label "Pa°s"             no-undo.
def new global shared var v_cod_usuar_corren         as CHARACTER format "x(12)":U label "Usu†rio Corrente"     column-label "Usu†rio Corrente" no-undo.
def new global shared var v_cod_usuar_corren_criptog as CHARACTER format "x(16)":U no-undo. 

def new global shared var v5_cod_empres_usuar         as CHARACTER format 'x(03)':U label 'Empresa'              column-label 'Empresa'          no-undo.
def new global shared var v5_cod_estab_usuar          as CHARACTER format 'x(03)':U label 'Estabelecimento'      column-label 'Estab'            no-undo.
def new global shared var v5_cod_grp_usuar_lst        as CHARACTER format 'x(03)':U label 'Grupo Usu†rios'       column-label 'Grupo'            no-undo.
def new global shared var v5_cod_idiom_usuar          as CHARACTER format 'x(08)':U label 'Idioma'               column-label 'Idioma'           no-undo.
def new global shared var v5_cod_pais_empres_usuar    as CHARACTER format 'x(03)':U label 'Pa°s Empresa Usu†rio' column-label 'Pa°s'             no-undo.
def new global shared var v5_cod_usuar_corren         as CHARACTER format 'x(12)':U label 'Usu†rio Corrente'     column-label 'Usu†rio Corrente' no-undo.
def new global shared var v5_cod_usuar_corren_criptog as CHARACTER format 'x(16)':U no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-param c-dir-arquivo bt_file c-cod_motiv_trans_externa c-des-motiv_trans_externa ~
c-cod_motiv_trans_interna c-des-motiv_trans_interna l-inventario RECT-impress RECT-exec rs-destino ~
rs-execucao bt-cfimp bt-arquivo c-arquivo RECT-BUTTONS bt_ok bt_can                   
&Scoped-Define DISPLAYED-OBJECTS bt_ok bt_can c-dir-arquivo bt_file rs-destino bt-cfimp bt-arquivo c-arquivo ~
rs-execucao c-cod_motiv_trans_externa c-cod_motiv_trans_interna l-inventario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

{esp/es0018.i}

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER usuar_mestre FOR usuar_mestre.

DEF NEW GLOBAL SHARED VAR v_rec_motiv_desmob AS RECID FORMAT ">>>>>>9":U NO-UNDO.

DEF BUTTON bt_can LABEL "&Fechar"   TOOLTIP "&Fechar"   SIZE 1 BY 1 AUTO-ENDKEY.
DEF BUTTON bt_ok  LABEL "&Executar" TOOLTIP "&Executar" SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_file    IMAGE-UP FILE "image/im-sea":U IMAGE-INSENSITIVE FILE "image/ii-sea":U LABEL "" SIZE 4 BY 1.
DEF BUTTON bt-arquivo IMAGE-UP FILE "image/im-sea1.bmp":U LABEL "" SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".
DEF BUTTON bt-cfimp   IMAGE-UP FILE "image/im-pri.bmp":U  LABEL "" SIZE 3.86 BY 1.08 TOOLTIP "Layout Impress∆o".

DEF RECTANGLE RECT-BUTTONS EDGE-PIXELS 2 GRAPHIC-EDGE         SIZE 79 BY 1.42 BGCOLOR 7.
DEF RECTANGLE RECT-exec    EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 13 BY 3.17.
DEF RECTANGLE RECT-impress EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 65 BY 3.17.
DEF RECTANGLE RECT-param   EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 79 BY 5.25.

DEF VAR c-dir-arquivo             AS   CHARACTER FORMAT "x(256)" LABEL "Diret¢rio Arquivos" VIEW-AS FILL-IN SIZE 50 BY .88 TOOLTIP "Diret¢rio Arquivos" BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR c-cod_motiv_trans_externa LIKE motiv_desmob.cod_motiv_desmob INIT "TRA" VIEW-AS FILL-IN    SIZE 05 BY .88 BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR c-des_motiv_trans_externa LIKE motiv_desmob.des_motiv_desmob            VIEW-AS FILL-IN    SIZE 42 BY .88 BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR c-cod_motiv_trans_interna LIKE motiv_desmob.cod_motiv_desmob INIT "TRI" VIEW-AS FILL-IN    SIZE 05 BY .88 BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR c-des_motiv_trans_interna LIKE motiv_desmob.des_motiv_desmob            VIEW-AS FILL-IN    SIZE 42 BY .88 BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR l-inventario              AS   LOGICAL INIT YES                         VIEW-AS TOGGLE-BOX SIZE 11 BY .88 FONT 1 NO-UNDO.
DEF VAR c-arquivo                 AS   CHARACTER FORMAT "x(40)":U INIT "esfas011.lst" VIEW-AS FILL-IN SIZE 44.29 BY .88 TOOLTIP "Destino"            BGCOLOR 15 FONT 1 NO-UNDO.
DEF VAR c-impressora              AS   CHARACTER       NO-UNDO.
DEF VAR c-layout                  AS   CHARACTER       NO-UNDO.
DEF VAR wh-exessao                AS   HANDLE          NO-UNDO.
DEF VAR c-ant                     AS   CHARACTER       NO-UNDO.
DEF VAR v_num_ped_exec_rpw        AS   INTEGER         NO-UNDO.
DEF VAR v_log_det                 AS   LOGICAL INIT NO NO-UNDO.
DEF VAR rs-destino                AS   INTEGER INIT 3 VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "Impressora", 1, "Arquivo", 2, "Terminal", 3 SIZE 43.57 BY .83 TOOLTIP "Destino da Impress∆o"      FONT 1 NO-UNDO.
DEF VAR rs-execucao               AS   INTEGER INIT 1 VIEW-AS RADIO-SET VERTICAL   RADIO-BUTTONS "On Line", 1, "Batch", 2                     SIZE 8.86 BY 1.83 TOOLTIP "Execuá∆o On Line ou Batch" FONT 1 NO-UNDO.
DEF VAR c-dir-inicial             AS   CHARACTER NO-UNDO.
DEF VAR c-dir-inicial-rpw         AS   CHARACTER NO-UNDO.
DEFINE VARIABLE v_num_inventario  AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino       AS INTEGER
    FIELD arquivo       AS CHARACTER FORMAT "x(35)":U
    FIELD usuario       AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec     AS DATE
    FIELD hora-exec     AS INTEGER
    FIELD c-dir-arquivo AS CHARACTER.


/* ************************  Frame Definitions  *********************** */
DEF FRAME fPage0
    " ParÉmetros" VIEW-AS TEXT SIZE 11    BY .54 AT ROW 1     COL 3.43 FONT 6
    RECT-param                                   AT ROW 01.25 COL 02
    c-dir-arquivo                                AT ROW 01.90 COL 18 COLON-ALIGNED HELP "Diret¢rio Arquivos":U
    bt_file                                      AT ROW 01.85 COL 70
    c-cod_motiv_trans_externa                    AT ROW 02.90 COL 18 COLON-ALIGNED LABEL "Motivo Transf.Externa":U HELP "Motivo Transferància Externa":U
    c-des_motiv_trans_externa                    AT ROW 02.90 COL 25 NO-LABEL
    c-cod_motiv_trans_interna                    AT ROW 03.90 COL 18 COLON-ALIGNED LABEL "Motivo Transf.Interna":U HELP "Motivo Transferància Interna":U
    c-des_motiv_trans_interna                    AT ROW 03.90 COL 25 NO-LABEL
    v_num_inventario                             AT ROW 04.90 COL 07.50 LABEL "Èltimo Invent†rio:"
    l-inventario                                 AT ROW 04.90 COL 35 LABEL "Invent†rio" HELP "Importaá∆o Ç um invent†rio de transferància?":U
    "  Impress∆o" VIEW-AS TEXT SIZE 10.57 BY .54 AT ROW 06.58 COL 2.86 FONT 6
    " Execuá∆o"   VIEW-AS TEXT SIZE 9.50  BY .54 AT ROW 06.58 COL 69   FONT 6
    RECT-impress                                 AT ROW 06.79 COL 02
    RECT-exec                                    AT ROW 06.79 COL 68
    rs-destino                                   AT ROW 7.5   COL 11    HELP "Destino da Impress∆o" NO-LABEL
    rs-execucao                                  AT ROW 7.5   COL 70.50 HELP "Execuá∆o On Line ou Batch" NO-LABEL
    bt-cfimp                                     AT ROW 8.5   COL 55.57 HELP "Layout Impress∆o"
    bt-arquivo                                   AT ROW 8.5   COL 55.57 HELP "Localiza Arquivo"
    c-arquivo                                    AT ROW 8.58  COL 11.14 HELP "Destino" NO-LABEL
    RECT-BUTTONS                                 AT ROW 10.25 COL 02
    bt_ok                                        AT ROW 10.45 COL 03 HELP "Dispara a execuá∆o":U
    bt_can                                       AT ROW 10.45 COL 14 HELP "Cancela"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11
         FONT 1
         DEFAULT-BUTTON bt_OK.

ASSIGN bt_can:WIDTH-CHARS  IN FRAME fPage0 = 10.00
       bt_can:HEIGHT-CHARS IN FRAME fPage0 = 01.00
       bt_ok:WIDTH-CHARS   IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS  IN FRAME fPage0 = 01.00.

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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Invent†rio - ESFAS011"
         COLUMN             = 14.29
         ROW                = 6.54
         HEIGHT             = 11
         WIDTH              = 81
         MAX-HEIGHT         = 11
         MAX-WIDTH          = 81
         VIRTUAL-HEIGHT     = 11
         VIRTUAL-WIDTH      = 81
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
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cdn-fornec-fin IN FRAME fPage0
   LIKE = tit_ap.cdn_fornecedor EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cdn-fornec-ini IN FRAME fPage0
   LIKE = tit_ap.cdn_fornecedor EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cod-grp-fin IN FRAME fPage0
   LIKE = tit_ap.cod_grp_fornec EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cod-grp-ini IN FRAME fPage0
   LIKE = tit_ap.cod_grp_fornec EXP-SIZE                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Relat¢rio Prazo MÇdio Fornecedor - esFAS011 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Relat¢rio Prazo MÇdio Fornecedor - esFAS011 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON  CHOOSE OF bt-arquivo IN FRAME fPage0 DO:
    DEF VAR c-arq-conv AS CHARACTER NO-UNDO.
    DEF VAR l-ok       AS LOGICAL INIT NO.

    assign c-arq-conv = replace(input frame fPage0 c-arquivo, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR c-dir-inicial 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
        display c-arq-conv @ c-arquivo with frame fPage0.
    end.
END. /* ON  CHOOSE OF bt-arquivo IN FRAME fPage0 DO: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cfimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp C-Win
ON CHOOSE OF bt-cfimp IN FRAME fPage0
DO:
    assign c-ant = c-arquivo:screen-value in frame fPage0.
  
    run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).
    
    if c-arquivo <> ":" then
      assign c-arquivo = c-impressora + ":" + c-layout.
    else
      assign c-arquivo = c-ant.
      
    disp c-arquivo with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_ok C-Win
ON  CHOOSE OF bt_ok IN FRAME fPage0 DO:
    ASSIGN INPUT FRAME fPage0 c-dir-arquivo.

    IF rs-execucao:SCREEN-VALUE IN FRAME fPage0 = "2" 
    THEN DO:
       IF  INDEX(c-dir-arquivo,":") <> 0 OR
           INDEX(c-dir-arquivo,"\") <> 0 OR
           INDEX(c-dir-arquivo,"/") <> 0
       THEN DO:
            RUN utp\ut-msgs.p (INPUT "show",
                               INPUT "17006",
                               INPUT "Nome do arquivo inv†lido. Para execuá∆o Batch, " + 
                                     "informe apenas o nome do arquivo e sua extens∆o." + "~~" + 
                                     "Ex.: inventario.csv." + CHR(10) + CHR(10) + "O arquivo dever† estar no diret¢rio spool\usu†rio.").
            RETURN NO-APPLY.
       END.
    END.
    ELSE DO:
         IF  c-dir-arquivo = "" THEN DO:
            MESSAGE "Diret¢rio Planilha deve ser informado!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry":U TO c-dir-arquivo IN FRAME fPage0.
            RETURN NO-APPLY.
         END. /* IF  c-dir-arquivo = "" THEN DO: */
         ELSE DO:
            FILE-INFO:FILE-NAME = c-dir-arquivo:SCREEN-VALUE IN FRAME fPage0.
            IF  FILE-INFO:PATHNAME = ? THEN DO:
                MESSAGE "Diret¢rio Planilha informado n∆o existe!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                APPLY "entry":U TO c-dir-arquivo IN FRAME fPage0.
                RETURN NO-APPLY.
            END. /* IF  FILE-INFO:PATHNAME = ? THEN DO: */
         END. /* ELSE DO: */
    END.

    RUN pi_salva_param.
    IF  rs-execucao:SCREEN-VALUE IN FRAME fPage0 = "2" THEN DO.
        RUN prgtec/btb/btb911za.p (INPUT  "esfas011rp",
                                   INPUT  "1.00.000",
                                   INPUT  0,
                                   INPUT  RECID(dwb_set_list_param),
                                   OUTPUT v_num_ped_exec_rpw).
        IF  v_num_ped_exec_rpw <> 0 THEN DO.
            RUN pi_message  (INPUT "show",
                             INPUT 3556,
                             INPUT SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", v_num_ped_exec_rpw)).
        END. /* IF  v_num_ped_exec_rpw <> 0 */
    END. /* IF  rs-execucao:SCREEN-VALUE */
    ELSE DO.
        RUN esp/fas/esfas011rp.p.
    END. /* ELSE DO. */

END. /* ON  CHOOSE OF bt_ok IN FRAME fPage0 DO: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_can C-Win
ON CHOOSE OF bt_can IN FRAME fPage0 /* Fechar */
DO:
  RUN pi_salva_param.
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt_file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_file C-Win
ON  CHOOSE OF bt_file IN FRAME fPage0 DO:
    DEF VAR c-arq-conv    AS CHARACTER NO-UNDO.
    DEF VAR l-ok          AS LOGICAL   NO-UNDO.

    ASSIGN c-arq-conv = replace(input frame fPage0 c-dir-arquivo, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS &IF "{3}" <> "" &THEN {3} 
               &ENDIF
               &IF "{3}" = "" &THEN
               "*.csv" "*.csv",
               "*.*" "*.*"         
               &ENDIF      
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR c-dir-inicial
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-dir-arquivo = replace(c-arq-conv, "\", "/").
        display c-dir-arquivo with frame fPage0.
    end.
    
END. /* ON  CHOOSE OF bt_file IN FRAME fPage0 DO: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON  VALUE-CHANGED OF rs-destino IN FRAME fPage0 DO:
    if  input frame fPage0 rs-destino = 1 then do:
        assign bt-arquivo:visible  in frame fPage0 = no
               bt-cfimp:visible    in frame fPage0 = yes
               c-arquivo:visible   in frame fPage0 = yes
               c-arquivo:sensitive in frame fPage0 = no.

        if  c-impressora = "" then do:
            find first imprsor_usuar use-index imprsrsr_id no-lock
                where imprsor_usuar.cod_usuario = v_cod_usuar_corren no-error.
            if  avail imprsor_usuar then do:
                find first layout_impres no-lock
                    where  layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
                if  avail layout_impres then
                    assign c-arquivo:screen-value in frame fPage0 = imprsor_usuar.nom_impressora + ":" + layout_impres.cod_layout_impres
                           c-impressora                           = imprsor_usuar.nom_impressora
                           c-layout                               = layout_impres.cod_layout_impres.
            end. /* if  avail imprsor_usuar then do: */
        end. /* if  c-impressora = "" then do: */
        ELSE assign c-arquivo:screen-value in frame fPage0 = c-impressora + ":" + c-layout.
    end. /* if input frame fPage0 rs-destino = 1 then do: */
               
    if  input frame fPage0 rs-destino = 2 then do:
        assign bt-arquivo:visible  in frame fPage0 = yes
               bt-cfimp:visible    in frame fPage0 = no
               c-arquivo:visible   in frame fPage0 = yes             
               c-arquivo:sensitive in frame fPage0 = yes.
        if input frame fPage0 rs-execucao = 1 
        then assign c-arquivo:screen-value in frame fPage0 = c-dir-inicial + "\esfas011.lst"
                    c-impressora                          = ""
                    c-layout                              = "".
        else assign c-arquivo:screen-value in frame fPage0 = c-dir-inicial-rpw + "/esfas011.lst"
                    c-impressora                          = ""
                    c-layout                              = "".
    end. /* if  input frame fPage0 rs-destino = 2 then do: */
    
    if  input frame fPage0 rs-destino = 3 then
        assign bt-arquivo:visible  in frame fPage0 = no
               bt-cfimp:visible    in frame fPage0 = no
               c-arquivo:visible   in frame fPage0 = no.
END. /* ON  VALUE-CHANGED OF rs-destino IN FRAME fPage0 DO: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME fPage0
DO:
  if input frame fPage0 rs-execucao = 2 then do:
     if rs-destino:disable("Terminal") in frame fPage0 then.
  end.
  else do:
      if rs-destino:enable("Terminal") in frame fPage0 then.
  end.
  
  apply "value-changed" to rs-destino in frame fPage0.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_externa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_externa C-Win
ON LEAVE OF c-cod_motiv_trans_externa IN FRAME fPage0 
DO:
    find motiv_desmob where motiv_desmob.cod_motiv_desmob = INPUT FRAME fPage0 c-cod_motiv_trans_externa no-lock no-error.
    IF  AVAIL motiv_desmob 
    THEN assign c-des_motiv_trans_externa:screen-value in frame fPage0 = motiv_desmob.des_motiv_desmob.
    ELSE assign c-des_motiv_trans_externa:screen-value in frame fPage0 = "".
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_interna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_interna C-Win
ON LEAVE OF c-cod_motiv_trans_interna IN FRAME fPage0 
DO:
    find motiv_desmob where motiv_desmob.cod_motiv_desmob = INPUT FRAME fPage0 c-cod_motiv_trans_interna no-lock no-error.
    IF  AVAIL motiv_desmob 
    THEN assign c-des_motiv_trans_interna:screen-value in frame fPage0 = motiv_desmob.des_motiv_desmob.
    ELSE assign c-des_motiv_trans_interna:screen-value in frame fPage0 = "".
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_interna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_interna C-Win
ON F5 OF c-cod_motiv_trans_interna IN FRAME fPage0 
DO:
    run prgfin/fas/fas028ka.p /*prg_sea_motiv_desmob*/.
    if  v_rec_motiv_desmob <> ? then do:
        find motiv_desmob where recid(motiv_desmob) = v_rec_motiv_desmob no-lock no-error.
        assign c-cod_motiv_trans_interna:screen-value in frame fPage0 = string(motiv_desmob.cod_motiv_desmob)
               c-des_motiv_trans_interna:screen-value in frame fPage0 = motiv_desmob.des_motiv_desmob.
    end /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_externa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_externa C-Win
ON F5 OF c-cod_motiv_trans_externa IN FRAME fPage0 
DO:
    run prgfin/fas/fas028ka.p /*prg_sea_motiv_desmob*/.
    if  v_rec_motiv_desmob <> ? then do:
        find motiv_desmob where recid(motiv_desmob) = v_rec_motiv_desmob no-lock no-error.
        assign c-cod_motiv_trans_externa:screen-value in frame fPage0 = string(motiv_desmob.cod_motiv_desmob)
               c-des_motiv_trans_externa:screen-value in frame fPage0 = motiv_desmob.des_motiv_desmob.
    end /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_externa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_externa C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod_motiv_trans_externa IN FRAME fPage0 
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod_motiv_trans_interna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod_motiv_trans_interna C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod_motiv_trans_interna IN FRAME fPage0 
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

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

  if c-cod_motiv_trans_externa:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.
  if c-cod_motiv_trans_interna:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.

  FIND FIRST usuar_mestre NO-LOCK
      WHERE  usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
  IF  AVAIL usuar_mestre 
  THEN ASSIGN c-dir-inicial     = usuar_mestre.nom_dir_spool + "/" + usuar_mestre.nom_subdir_spool 
              c-dir-inicial     = replace(c-dir-inicial, "/", "~\")
              c-dir-inicial-rpw = usuar_mestre.nom_subdir_spool
              c-dir-inicial-rpw = replace(c-dir-inicial-rpw, "/", "~\").
  ELSE ASSIGN c-dir-inicial = SESSION:TEMP-DIRECTORY.
  
  ASSIGN rs-destino:SCREEN-VALUE IN FRAME fPage0 = "3". /* Terminal */

  run pi-recupera-param.

  APPLY "value-changed":U TO rs-destino  IN FRAME fPage0.
  APPLY "value-changed"   TO rs-execucao IN FRAME fPage0.
  
  APPLY "leave":U TO c-cod_motiv_trans_externa IN FRAME fPage0.
  APPLY "leave":U TO c-cod_motiv_trans_interna IN FRAME fPage0.
    
  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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

  FIND LAST histor_inventario USE-INDEX key_id NO-LOCK NO-ERROR.
  IF AVAIL histor_inventario 
     THEN ASSIGN v_num_inventario = histor_inventario.num_inventario.


  DISPLAY bt_ok bt_can c-dir-arquivo bt_file rs-destino bt-cfimp bt-arquivo c-arquivo rs-execucao c-cod_motiv_trans_externa c-cod_motiv_trans_interna v_num_inventario l-inventario WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE bt_ok bt_can c-dir-arquivo bt_file rs-destino bt-cfimp bt-arquivo c-arquivo rs-execucao c-cod_motiv_trans_externa c-cod_motiv_trans_interna l-inventario WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
    FIND dwb_set_list_param EXCLUSIVE-LOCK
        WHERE dwb_set_list_param.cod_dwb_program = "esfas011rp"
        AND   dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
    IF  AVAIL dwb_set_list_param THEN 
    DO  WITH FRAME fPage0:
        ASSIGN rs-execucao:screen-value               in frame fPage0 = ENTRY(1,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c-dir-arquivo:screen-value             in frame fPage0 = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c-cod_motiv_trans_externa:screen-value in frame fPage0 = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c-cod_motiv_trans_interna:screen-value in frame fPage0 = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,chr(10))
               l-inventario:screen-value              in frame fPage0 = ENTRY(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
               rs-destino:screen-value                in frame fPage0 = IF  dwb_set_list_param.cod_dwb_output = "Impressora" 
                                                                        THEN "1"
                                                                        ELSE IF  dwb_set_list_param.cod_dwb_output = "Arquivo" 
                                                                             THEN "2"
                                                                             ELSE "3" NO-ERROR.
    

        APPLY "value-changed" TO rs-destino IN FRAME fPage0.  
    END. /* IF  AVAIL dwb_set_list_param */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
    ASSIGN INPUT FRAME fPage0 c-arquivo rs-destino rs-execucao c-dir-arquivo ~
                              c-cod_motiv_trans_externa c-cod_motiv_trans_interna l-inventario.
    
    RUN prgtec/btb/btb906za.p.    
    IF  rs-destino  = 2 AND rs-execucao = 2 THEN DO.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "spool-unix",
                           INPUT 1, 
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto NO-LOCK:
            IF INDEX(c-dir-arquivo,"/") = 0 
               THEN ASSIGN c-dir-arquivo = tt-prog-ponto.conteudo + "/" + v_cod_usuar_corren + "/" + c-dir-arquivo.
        END.

    END. /* IF  rs-destino  = 2 AND ... */

    FIND dwb_set_list_param EXCLUSIVE-LOCK
        WHERE dwb_set_list_param.Cod_dwb_program = "esfas011rp"
        AND   dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren NO-ERROR.
    
    IF NOT AVAIL dwb_set_list_param 
    THEN CREATE dwb_set_list_param.
    
    ASSIGN dwb_set_list_param.Cod_dwb_program      = "esfas011rp"
           dwb_set_list_param.Cod_dwb_user         = v_Cod_usuar_corren
           dwb_set_list_param.Cod_dwb_file         = c-arquivo
           dwb_set_list_param.nom_dwb_printer      = c-impressora
           dwb_set_list_param.Cod_dwb_print_layout = c-layout
           dwb_set_list_param.qtd_dwb_line         = 60
           dwb_set_list_param.Cod_dwb_parameters   = STRING(rs-execucao)               + chr(10) + 
                                                            string(c-dir-arquivo)             + chr(10) +
                                                            string(c-cod_motiv_trans_externa) + chr(10) +
                                                            string(c-cod_motiv_trans_interna) + chr(10) +
                                                            ""                                + chr(10) +
                                                            string(l-inventario)              + chr(10)
           dwb_set_list_param.Cod_dwb_output       = IF rs-destino = 1 
                                                            THEN "Impressora"
                                                            ELSE IF rs-destino = 2 
                                                                 THEN "Arquivo"
                                                                 ELSE IF rs-destino = 3 
                                                                      THEN "Terminal"
                                                                      ELSE "Arquivo".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


