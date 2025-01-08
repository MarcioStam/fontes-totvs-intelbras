&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/apb/esctp001.p
**     Descricao .......: Importa/Exporta Rateios.
**     Versao...........: 1.00.001
**     Autor............: Catia Schmauch - Gestech
**     Criado...........: 04/02/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.
&SCOPED-DEFINE NomProg   ESCTP001
&SCOPED-DEFINE DescProg  Importa/Exporta Rateios.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS LOG INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.

{esinc\es0000.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-2 RECT-29 RECT-7 RECT-9 ~
fiCod_empresa_ini fiCod_empresa_end fiCod_rateio_ctbl_ini ~
fiCod_rateio_ctbl_end i-opcao bt-importacao fiArquivo rs-execucao ~
rs-destino bt-arquivo bt-cfimp c-arquivo bt-imprime bt-salva 
&Scoped-Define DISPLAYED-OBJECTS fiCod_empresa_ini fiCod_empresa_end ~
fiCod_rateio_ctbl_ini fiCod_rateio_ctbl_end i-opcao fiArquivo rs-execucao ~
rs-destino c-arquivo 

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

DEFINE BUTTON bt-importacao 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-imprime 
     LABEL "Executar" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "esctp001.lst" 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE fiArquivo AS CHARACTER FORMAT "X(60)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fiCod_empresa_end AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiCod_empresa_ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiCod_rateio_ctbl_end AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCod_rateio_ctbl_ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Rateio Cont†bil" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Exportaá∆o", 1,
"Importaá∆o", 2
     SIZE 36 BY 1.25 NO-UNDO.

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
     SIZE 10.86 BY 2.5 TOOLTIP "Execuá∆o On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66.86 BY 2.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.86 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.86 BY 3.17.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 3.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66.86 BY 3.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     fiCod_empresa_ini AT ROW 1.67 COL 17.29 COLON-ALIGNED
     fiCod_empresa_end AT ROW 1.67 COL 35.57 COLON-ALIGNED NO-LABEL
     fiCod_rateio_ctbl_ini AT ROW 2.67 COL 17.29 COLON-ALIGNED
     fiCod_rateio_ctbl_end AT ROW 2.67 COL 35.57 COLON-ALIGNED NO-LABEL
     i-opcao AT ROW 4.67 COL 17 NO-LABEL
     bt-importacao AT ROW 6.33 COL 62.14 HELP
          "Localiza Arquivo"
     fiArquivo AT ROW 6.38 COL 15 COLON-ALIGNED
     rs-execucao AT ROW 8.58 COL 54.14 HELP
          "Execuá∆o On Line ou Batch" NO-LABEL
     rs-destino AT ROW 8.96 COL 2 HELP
          "Destino da Impress∆o" NO-LABEL
     bt-arquivo AT ROW 9.96 COL 46.57 HELP
          "Localiza Arquivo"
     bt-cfimp AT ROW 9.96 COL 46.57 HELP
          "Layout Impress∆o"
     c-arquivo AT ROW 10.04 COL 2.14 HELP
          "Destino" NO-LABEL
     bt-imprime AT ROW 11.88 COL 2
     bt-salva AT ROW 11.88 COL 13.72
     "Seleá∆o:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1 COL 4
          FONT 6
     "ParÉmetros:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 4 COL 4
          FONT 6
     " Execuá∆o" VIEW-AS TEXT
          SIZE 9.43 BY .54 AT ROW 7.83 COL 53.86
          FONT 6
     "  Impress∆o" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 7.83 COL 3
          FONT 6
     RECT-10 AT ROW 1.25 COL 1
     RECT-2 AT ROW 11.58 COL 1
     RECT-29 AT ROW 8.17 COL 53
     RECT-7 AT ROW 8.08 COL 1
     RECT-9 AT ROW 4.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.86 BY 12.42
         FONT 1
         DEFAULT-BUTTON bt-imprime.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "{&DescProg} - {&NomProg}"
         HEIGHT             = 12.42
         WIDTH              = 66.86
         MAX-HEIGHT         = 33.83
         MAX-WIDTH          = 228.57
         VIRTUAL-HEIGHT     = 33.83
         VIRTUAL-WIDTH      = 228.57
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* {DescProg} - {NomProg} */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* {DescProg} - {NomProg} */
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
               "*.*" "*"
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


&Scoped-define SELF-NAME bt-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao C-Win
ON CHOOSE OF bt-importacao IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv = replace(input frame f-relat c-arquivo, "/", "\").

    IF INPUT FRAME f-relat i-opcao = 1 THEN
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.csv" "*.csv",
                   "*.lst" "*.lst",
                   "*.*" "*.*"
           DEFAULT-EXTENSION "csv"
           SAVE-AS
           ASK-OVERWRITE
           USE-FILENAME
           TITLE 'Exportar para o arquivo'
           UPDATE l-ok.
    ELSE
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.csv" "*.csv",
                   "*.lst" "*.lst",
                   "*.*" "*.*"
           DEFAULT-EXTENSION "csv"
           MUST-EXIST
           USE-FILENAME
           TITLE 'Importar do arquivo'
           UPDATE l-ok.

    IF l-ok THEN DO:
        assign fiArquivo = c-arq-conv.
        display fiArquivo with frame f-relat.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-relat /* Executar */
DO:
  ASSIGN fiarquivo = INPUT FRAME {&FRAME-NAME} fiarquivo.

  IF  INPUT FRAME {&FRAME-NAME} rs-execucao = 2
  THEN DO:
      IF  INDEX(fiarquivo,":") <> 0 OR
          INDEX(fiarquivo,"\") <> 0 OR
          INDEX(fiarquivo,"/") <> 0
      THEN DO:
          RUN utp\ut-msgs.p (INPUT "show",
                             INPUT "17006",
                             INPUT "Nome do arquivo inv†lido.~~Para execuá∆o Batch, " + 
                                   "informe apenas o nome do arquivo e sua extens∆o." + CHR(13) + "Ex.: rateios.csv").
          RETURN NO-APPLY.
      END.
  END.

  RUN pi-vld-param.
  IF RETURN-VALUE = "no" 
  THEN RETURN NO-APPLY.
  RUN pi_salva_param.
  IF rs-execucao:SCREEN-VALUE IN FRAME f-relat = "2" THEN
  DO.
    RUN prgtec/btb/btb911za.p (INPUT  "esctp001rp",
                               INPUT  "1.00.000",
                               INPUT  0,
                               INPUT  RECID(emsfnd.dwb_set_list_param),
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
  DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    RUN esp/ctp/esctp001rp.p.
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
          find first emsfnd.imprsor_usuar no-lock
              where imprsor_usuar.cod_usuario = v_cod_usuar_corren
              use-index imprsrsr_id no-error.
          if avail imprsor_usuar then do:
              find first emsfnd.layout_impres no-lock
                  where layout_impres.nom_impressora  = emsfnd.imprsor_usuar.nom_impressora no-error.
              if avail layout_impres then
                  assign c-arquivo:screen-value in frame f-relat = emsfnd.imprsor_usuar.nom_impressora 
                                                               + ":" 
                                                               + emsfnd.layout_impres.cod_layout_impres
                         c-impressora                          = emsfnd.imprsor_usuar.nom_impressora
                         c-layout                              = emsfnd.layout_impres.cod_layout_impres.
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
          assign c-arquivo:screen-value in frame f-relat = session:temp-directory + "esctp001.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
      else
          assign c-arquivo:screen-value in frame f-relat = "esctp001.lst"
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
     ASSIGN rs-destino = 2.
     DISP rs-destino WITH FRAME f-relat.
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

   
    run pi-recupera-param.

    RUN enable_UI.

    APPLY "value-changed" TO rs-destino IN FRAME {&FRAME-NAME}.


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
  DISPLAY fiCod_empresa_ini fiCod_empresa_end fiCod_rateio_ctbl_ini 
          fiCod_rateio_ctbl_end i-opcao fiArquivo rs-execucao rs-destino 
          c-arquivo 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE RECT-10 RECT-2 RECT-29 RECT-7 RECT-9 fiCod_empresa_ini 
         fiCod_empresa_end fiCod_rateio_ctbl_ini fiCod_rateio_ctbl_end i-opcao 
         bt-importacao fiArquivo rs-execucao rs-destino bt-arquivo bt-cfimp 
         c-arquivo bt-imprime bt-salva 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
/* */
  FIND emsfnd.dwb_set_list_param EXCLUSIVE-LOCK
       WHERE emsfnd.dwb_set_list_param.cod_dwb_program = "esctp001"
         AND emsfnd.dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
  
  IF AVAIL emsfnd.dwb_set_list_param THEN 
  DO WITH FRAME f-relat:
    ASSIGN rs-execucao:SCREEN-VALUE       IN FRAME f-relat = entry(1,emsfnd.dwb_set_list_param.cod_dwb_parameters,chr(10))
           rs-destino:SCREEN-VALUE        IN FRAME f-relat = IF emsfnd.dwb_set_list_param.cod_dwb_output = "impressora" 
                                                               THEN "1"
                                                               ELSE IF emsfnd.dwb_set_list_param.cod_dwb_output = "arquivo" 
                                                                    THEN "2"
                                                                    ELSE "3".
    ASSIGN i-opcao                  = INT(ENTRY(02,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))) NO-ERROR.
    ASSIGN fiCod_empresa_ini        =     ENTRY(03,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
    ASSIGN fiCod_empresa_end        =     ENTRY(04,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
    ASSIGN fiCod_rateio_ctbl_ini    =     ENTRY(05,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
    ASSIGN fiCod_rateio_ctbl_end    =     ENTRY(06,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.
    ASSIGN fiarquivo                =     ENTRY(07,emsfnd.dwb_set_list_param.cod_dwb_parameters,CHR(10))  NO-ERROR.


    APPLY "value-changed" TO rs-destino      IN FRAME f-relat.  
  END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-param C-Win 
PROCEDURE pi-vld-param :
/* */
if input frame f-relat rs-destino = 2 then 
do:
  for each emsfnd.ped_exec no-lock
      where emsfnd.ped_exec.cod_prog_dtsul = "espb006"
        and emsfnd.ped_exec.ind_sit_ped    = "N∆o executado" :
          
    find emsfnd.ped_exec_param  of ped_exec no-lock no-error.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND emsfnd.prog_dtsul NO-LOCK
    WHERE emsfnd.prog_dtsul.cod_prog_dtsul = "esftp015" NO-ERROR.

IF AVAIL emsfnd.prog_dtsul THEN 
DO:
  FOR EACH emsfnd.usuar_grp_usuar NO-LOCK
      WHERE emsfnd.usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST emsfnd.prog_dtsul_segur NO-LOCK
                    WHERE  emsfnd.prog_dtsul_segur.cod_prog_dtsul = "espb006"
                      AND (emsfnd.prog_dtsul_segur.cod_grp_usuar  = emsfnd.usuar_grp_usuar.cod_grp_usuar
                       OR  emsfnd.prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
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
         INPUT FRAME f-relat rs-destino
         INPUT FRAME f-relat rs-execucao
         INPUT FRAME f-relat i-opcao
         INPUT FRAME f-relat fiCod_empresa_end
         INPUT FRAME f-relat fiCod_empresa_ini
         INPUT FRAME f-relat fiCod_rateio_ctbl_end
         INPUT FRAME f-relat fiCod_rateio_ctbl_ini
         INPUT FRAME f-relat Fiarquivo.


  RUN prgtec/btb/btb906za.p.    
  IF rs-destino  = 2 AND 
     rs-execucao = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo,"~/") <> 0.
      ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
    END.
  END.

  IF  rs-execucao = 2
  THEN DO:
      EMPTY TEMP-TABLE tt-prog-ponto.
      RUN esp/es0018p.p (INPUT "spool-unix",
                         INPUT 1, 
                         INPUT 0,
                         INPUT "", 
                         OUTPUT TABLE tt-prog-ponto).

      FOR FIRST tt-prog-ponto NO-LOCK:
          ASSIGN Fiarquivo = tt-prog-ponto.conteudo + "/" + v_cod_usuar_corren + "/" + Fiarquivo.
      END.
  END.

        /* Recuperar parÉmetros da £ltima execuá∆o */
  FIND emsfnd.dwb_set_list_param EXCLUSIVE-LOCK
       WHERE emsfnd.dwb_set_list_param.Cod_dwb_program = "esctp001rp"
         AND emsfnd.dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL emsfnd.dwb_set_list_param 
  THEN CREATE emsfnd.dwb_set_list_param.
    
  ASSIGN emsfnd.dwb_set_list_param.Cod_dwb_program          = "esctp001rp"
         emsfnd.dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         emsfnd.dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-relat c-arquivo
         emsfnd.dwb_set_list_param.nom_dwb_printer          = c-impressora
         emsfnd.dwb_set_list_param.Cod_dwb_print_layout     = c-layout
         emsfnd.dwb_set_list_param.qtd_dwb_line             = 60
         emsfnd.dwb_set_list_param.Cod_dwb_output           = IF rs-destino = 1 
                                                              THEN "Impressora"
                                                              ELSE IF rs-destino = 2 
                                                                   THEN "Arquivo"
                                                                   ELSE IF rs-destino = 3 
                                                                        THEN "Terminal"
                                                                        ELSE "arquivo".
  ASSIGN emsfnd.dwb_set_list_param.Cod_dwb_parameters       = 
                 STRING(rs-execucao)      + CHR(10) + 
                 STRING(i-opcao)          + CHR(10) + 
                 fiCod_empresa_ini        + CHR(10) +
                 fiCod_empresa_end        + CHR(10) +
                 fiCod_rateio_ctbl_ini    + CHR(10) +
                 fiCod_rateio_ctbl_end    + CHR(10) +
                 fiarquivo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

