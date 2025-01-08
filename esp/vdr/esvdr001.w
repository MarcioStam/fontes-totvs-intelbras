&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp\vdr\esvdr001.w
**     Descricao .......: Relat¢rio de titulos vendor a negociar
**     Versao...........: 1.00.000
**     Autor............: Claudiney klitzke
**     Criado...........: 02/01/2007
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.
 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES planilha_vendor

/* Definitions for FRAME f-relat                                        */
&Scoped-define QUERY-STRING-f-relat FOR EACH planilha_vendor SHARE-LOCK
&Scoped-define OPEN-QUERY-f-relat OPEN QUERY f-relat FOR EACH planilha_vendor SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-relat planilha_vendor
&Scoped-define FIRST-TABLE-IN-QUERY-f-relat planilha_vendor


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-7 RECT-8 cod-estabel ~
data-base-ini data-base-fim cod-portador-ini cod-portador-fim ~
cod-emitente-ini cod-emitente-fim data-emis-ini data-emis-fim rs-destino ~
bt-cfimp bt-arquivo c-arquivo bt-imprime bt-salva rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS cod-estabel data-base-ini data-base-fim ~
cod-portador-ini cod-portador-fim cod-emitente-ini cod-emitente-fim ~
data-emis-ini data-emis-fim rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-cfimp 
     IMAGE-UP FILE "image/im-pri.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Layout Impress∆o".

DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "esacr001.lst" 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE cod-emitente-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cod-emitente-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cod-estabel AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE cod-portador-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE cod-portador-ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88.

DEFINE VARIABLE data-base-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE data-base-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data base" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE data-emis-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE data-emis-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 43.57 BY .83 TOOLTIP "Destino da Impress∆o"
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "On Line", 1,
"Batch", 2
     SIZE 1 BY .88 TOOLTIP "Execuá∆o On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 56.72 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 2.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 6.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-relat FOR 
      planilha_vendor SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     cod-estabel AT ROW 2.08 COL 17 COLON-ALIGNED HELP
          "Data base da operaá∆o de Vendor"
     data-base-ini AT ROW 3.08 COL 17 COLON-ALIGNED HELP
          "Data base da operaá∆o de Vendor"
     data-base-fim AT ROW 3.08 COL 32 COLON-ALIGNED HELP
          "Data base da operaá∆o de Vendor" NO-LABEL
     cod-portador-ini AT ROW 4.08 COL 17 COLON-ALIGNED HELP
          "C¢digo Portador"
     cod-portador-fim AT ROW 4.08 COL 32 COLON-ALIGNED HELP
          "C¢digo Portador" NO-LABEL
     cod-emitente-ini AT ROW 5.08 COL 17 COLON-ALIGNED HELP
          "C¢digo Cliente"
     cod-emitente-fim AT ROW 5.08 COL 32 COLON-ALIGNED HELP
          "C¢digo Cliente" NO-LABEL
     data-emis-ini AT ROW 6.08 COL 17 COLON-ALIGNED HELP
          "Data de emiss∆o da duplicata"
     data-emis-fim AT ROW 6.08 COL 32 COLON-ALIGNED HELP
          "Data de emiss∆o da duplicata" NO-LABEL
     rs-destino AT ROW 8.79 COL 7.43 HELP
          "Destino da Impress∆o" NO-LABEL
     bt-cfimp AT ROW 9.88 COL 47 HELP
          "Layout Impress∆o"
     bt-arquivo AT ROW 9.88 COL 47 HELP
          "Localiza Arquivo"
     c-arquivo AT ROW 9.96 COL 7.57 HELP
          "Destino" NO-LABEL
     bt-imprime AT ROW 11.63 COL 2.14
     bt-salva AT ROW 11.63 COL 13.86
     rs-execucao AT ROW 12.75 COL 57 HELP
          "Execuá∆o On Line ou Batch" NO-LABEL
     " Seleá∆o" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 1 COL 2.86
          FONT 6
     " Impress∆o" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 8.04 COL 2.86
          FONT 6
     RECT-2 AT ROW 11.33 COL 1.14
     RECT-7 AT ROW 8.25 COL 1
     RECT-8 AT ROW 1.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57.14 BY 13.83
         FONT 1
         DEFAULT-BUTTON bt-imprime.


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
         TITLE              = "Titulos vendor a negociar - ESVDR001"
         COLUMN             = 27
         ROW                = 18.25
         HEIGHT             = 12.04
         WIDTH              = 57.43
         MAX-HEIGHT         = 40.96
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 40.96
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FRAME f-relat
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
ASSIGN 
       rs-execucao:HIDDEN IN FRAME f-relat           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _TblList          = "emscad.planilha_vendor"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Titulos vendor a negociar - ESVDR001 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Titulos vendor a negociar - ESVDR001 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv = replace(input frame f-relat c-arquivo, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
        display c-arq-conv @ c-arquivo with frame f-relat.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cfimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp C-Win
ON CHOOSE OF bt-cfimp IN FRAME f-relat
DO:
    assign c-ant = c-arquivo:screen-value in frame f-relat.
  
    run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).
    
    if c-arquivo <> ":" then
      assign c-arquivo = c-impressora + ":" + c-layout.
    else
      assign c-arquivo = c-ant.
      
    disp c-arquivo with frame f-relat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-relat /* Imprimir */
DO:
  DEFINE VARIABLE vLogErro AS LOGICAL INITIAL NO NO-UNDO.

  ASSIGN cod-emitente-fim 
         cod-emitente-ini 
         cod-portador-fim 
         cod-portador-ini 
         data-base-fim 
         data-base-ini 
         data-emis-fim 
         data-emis-ini.
  
  RUN pi_salva_param.

  IF rs-execucao:SCREEN-VALUE IN FRAME f-relat = "2" THEN
  DO.
    RUN prgtec/btb/btb911za.p (INPUT  "esvdr001",
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
    
    RUN esp/vdr/esvdr001rp.p.
    
    IF SESSION:SET-WAIT-STATE("") THEN.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
  RUN pi_salva_param.
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-relat
DO:
  if input frame f-relat rs-destino = 1 then do:
      assign bt-arquivo:visible  in frame f-relat = no
             bt-cfimp:visible    in frame f-relat = yes
             c-arquivo:visible   in frame f-relat = yes
             c-arquivo:sensitive in frame f-relat = no.
      if c-impressora = "" then do:
          find first imprsor_usuar no-lock
              where imprsor_usuar.cod_usuario = v_cod_usuar_corren
              use-index imprsrsr_id no-error.
          if avail imprsor_usuar then do:
              find first layout_impres no-lock
                  where layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
              if avail layout_impres then
                  assign c-arquivo:screen-value in frame f-relat = imprsor_usuar.nom_impressora 
                                                               + ":" 
                                                               + layout_impres.cod_layout_impres
                         c-impressora                          = imprsor_usuar.nom_impressora
                         c-layout                              = layout_impres.cod_layout_impres.
          end.
      end.
      else
          assign c-arquivo:screen-value in frame f-relat = c-impressora + ":" + c-layout.
          
  end.
             
  if input frame f-relat rs-destino = 2 then do:
      assign bt-arquivo:visible  in frame f-relat = yes
             bt-cfimp:visible    in frame f-relat = no
             c-arquivo:visible   in frame f-relat = yes             
             c-arquivo:sensitive in frame f-relat = yes.
      if input frame f-relat rs-execucao = 1 then
          assign c-arquivo:screen-value in frame f-relat = session:temp-directory + "esvdr001.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
      else
          assign c-arquivo:screen-value in frame f-relat = "esvdr001.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
          
          
  end.

  if input frame f-relat rs-destino = 3 then
      assign bt-arquivo:visible  in frame f-relat = no
             bt-cfimp:visible    in frame f-relat = no
             c-arquivo:visible   in frame f-relat = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-relat
DO:
  if input frame f-relat rs-execucao = 2 then do:
     if rs-destino:disable("Terminal") in frame f-relat then.
  end.
  else do:
      if rs-destino:enable("Terminal") in frame f-relat then.
  end.
  
  apply "value-changed" to rs-destino in frame f-relat.
     
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

  APPLY "value-changed" TO rs-destino IN FRAME {&FRAME-NAME}.
  
  run pi-recupera-param.
  
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
  DISPLAY cod-estabel data-base-ini data-base-fim cod-portador-ini 
          cod-portador-fim cod-emitente-ini cod-emitente-fim data-emis-ini 
          data-emis-fim rs-destino c-arquivo rs-execucao 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE RECT-2 RECT-7 RECT-8 cod-estabel data-base-ini data-base-fim 
         cod-portador-ini cod-portador-fim cod-emitente-ini cod-emitente-fim 
         data-emis-ini data-emis-fim rs-destino bt-cfimp bt-arquivo c-arquivo 
         bt-imprime bt-salva rs-execucao 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
/* */

  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.cod_dwb_program = "esvdr001"
         AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
  
  IF AVAIL dwb_set_list_param THEN 
  DO WITH FRAME f-relat:
    ASSIGN rs-execucao:SCREEN-VALUE       IN FRAME f-relat = entry(1,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-estabel:SCREEN-VALUE       IN FRAME f-relat = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           data-base-ini:SCREEN-VALUE     IN FRAME f-relat = entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
           data-base-fim:SCREEN-VALUE     IN FRAME f-relat = entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-portador-ini:SCREEN-VALUE  IN FRAME f-relat = entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-portador-fim:SCREEN-VALUE  IN FRAME f-relat = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-emitente-ini:SCREEN-VALUE  IN FRAME f-relat = entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-emitente-fim:SCREEN-VALUE  IN FRAME f-relat = entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           data-emis-ini:SCREEN-VALUE     IN FRAME f-relat = entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           data-emis-fim:SCREEN-VALUE     IN FRAME f-relat = entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10)).
           rs-destino:SCREEN-VALUE        IN FRAME f-relat = IF dwb_set_list_param.cod_dwb_output = "impressora" 
                                                               THEN "1"
                                                               ELSE IF dwb_set_list_param.cod_dwb_output = "arquivo" 
                                                                    THEN "2"
                                                                    ELSE "3".
    APPLY "value-changed" TO rs-destino      IN FRAME f-relat.  
  END.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esvdr001" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esvdr001"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
/* */
  ASSIGN INPUT FRAME f-relat c-arquivo
                             rs-destino
                             rs-execucao
                             cod-estabel
                             cod-emitente-ini
                             cod-emitente-fim 
                             cod-portador-ini
                             cod-portador-fim 
                             data-base-ini
                             data-base-fim 
                             data-emis-ini
                             data-emis-fim.

  RUN prgtec/btb/btb906za.p.    
  IF rs-destino  = 2 AND 
     rs-execucao = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo,"~/") <> 0.
      ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
    END.
  END.

        /* Recuperar parÉmetros da £ltima execuá∆o */
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.Cod_dwb_program = "esvdr001"
         AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL dwb_set_list_param 
  THEN CREATE dwb_set_list_param.
    
  ASSIGN dwb_set_list_param.Cod_dwb_program          = "esvdr001"
         dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-relat c-arquivo
         dwb_set_list_param.nom_dwb_printer          = c-impressora
         dwb_set_list_param.Cod_dwb_print_layout     = c-layout
         dwb_set_list_param.qtd_dwb_line             = 60
         dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-execucao) + chr(10) + 
                                                              STRING(cod-estabel) + CHR(10) +
                                                              string(data-base-ini) + chr(10) + 
                                                              string(data-base-fim) + chr(10) +
                                                              string(cod-portador-ini) + chr(10) +
                                                              string(cod-portador-fim) + chr(10) +
                                                              string(cod-emitente-ini) + chr(10) +
                                                              string(cod-emitente-fim) + chr(10) +
                                                              string(data-emis-ini) + chr(10) +
                                                              string(data-emis-fim) + chr(10) 
                                                              
         dwb_set_list_param.Cod_dwb_output           = IF rs-destino = 1 
                                                              THEN "Impressora"
                                                              ELSE IF rs-destino = 2 
                                                                   THEN "Arquivo"
                                                                   ELSE IF rs-destino = 3 
                                                                        THEN "Terminal"
                                                                        ELSE "arquivo".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

