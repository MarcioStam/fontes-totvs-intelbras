&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

create widget-pool.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&scoped-define FONTES-WINDOWS \\erpapp\liberacoes$\totvs12\fontes
&scoped-define FONTES-LINUX /mnt/liberacoes/totvs12/fontes/
&scoped-define DESTINO-TESTE \\erpapp\erp\quarentena-desenv\especificos\
&scoped-define DESTINO-TESTE-LINUX /mnt/erp/quarentena-desenv/especificos/
&scoped-define DESTINO-LIBERACOES \\erpapp\liberacoes$\totvs12\
&scoped-define DESTINO-LIBERACOES-LINUX /mnt/liberacoes/totvs12/
&scoped-define APPSERVER-TESTE -AppService dbdevel_comp -H dbprogress.intelbras.com.br

define temp-table tt-include no-undo
   field arquivo as character
   index ch-pri is primary unique arquivo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fFrame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiProgramas btProcurar btPropath btLimpar ~
btCompilar fiFontes edLog 
&Scoped-Define DISPLAYED-OBJECTS fiProgramas fiFontes edLog 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE rsAppServer AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Teste", 1,
"Produá∆o", 2
     SIZE 10.72 BY 2.38 NO-UNDO.

DEFINE VARIABLE fiPasta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pasta" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .79 NO-UNDO.

DEFINE VARIABLE rsDestino AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Teste", 1,
"Liberaá‰es", 2
     SIZE 12 BY 2.38 NO-UNDO.

DEFINE VARIABLE tgPasta AS LOGICAL INITIAL no 
     LABEL "Pasta separada" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE BUTTON btCompilar 
     LABEL "&Compilar" 
     SIZE 11 BY 1.13
     FONT 1.

DEFINE BUTTON btLimpar 
     LABEL "&Limpar log" 
     SIZE 12 BY 1.13
     FONT 1.

DEFINE BUTTON btProcurar 
     LABEL "&Procurar..." 
     SIZE 11 BY 1.13
     FONT 1.

DEFINE BUTTON btPropath 
     LABEL "PROPATH" 
     SIZE 11 BY 1.13.

DEFINE VARIABLE edLog AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 90 BY 6
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiProgramas AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 90 BY 5.75 NO-UNDO.

DEFINE VARIABLE fiFontes AS CHARACTER FORMAT "X(256)":U INITIAL "c:/fontes12/" 
     LABEL "&Base dos fontes" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .79 NO-UNDO.

DEFINE VARIABLE tg32 AS LOGICAL INITIAL yes 
     LABEL "GUI" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE tg64 AS LOGICAL INITIAL NO 
     LABEL "TTY" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fFrame
     fiProgramas AT ROW 1.5 COL 2 NO-LABEL WIDGET-ID 14
     btProcurar AT ROW 7.75 COL 81 WIDGET-ID 10
     btPropath AT ROW 9 COL 81 WIDGET-ID 18
     btLimpar AT ROW 11.25 COL 2 WIDGET-ID 4
     btCompilar AT ROW 11.25 COL 81 WIDGET-ID 6
     fiFontes AT ROW 11.42 COL 45 COLON-ALIGNED WIDGET-ID 16
     edLog AT ROW 12.5 COL 2 NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.57 BY 17.54
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fDestino
     rsDestino AT ROW 1 COL 3 NO-LABEL WIDGET-ID 2
     tgPasta AT ROW 1.25 COL 23 WIDGET-ID 6
     fiPasta AT ROW 2.25 COL 21 COLON-ALIGNED WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 29 ROW 7.75
         SIZE 51 BY 3.25
         FONT 1
         TITLE "Destino" WIDGET-ID 400.

DEFINE FRAME fAppServer
     rsAppServer AT ROW 1 COL 3 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 15 ROW 7.75
         SIZE 13 BY 3.25
         FONT 1
         TITLE "AppServer" WIDGET-ID 300.

DEFINE FRAME fOS
     tg32 AT ROW 1.25 COL 2 WIDGET-ID 2
     tg64 AT ROW 2.25 COL 2 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 7.75
         SIZE 12 BY 3.25
         FONT 1
         TITLE "Sistema" WIDGET-ID 200.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Compilador"
         HEIGHT             = 17.54
         WIDTH              = 91.57
         MAX-HEIGHT         = 17.54
         MAX-WIDTH          = 95.14
         VIRTUAL-HEIGHT     = 17.54
         VIRTUAL-WIDTH      = 95.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fAppServer:FRAME = FRAME fFrame:HANDLE
       FRAME fDestino:FRAME = FRAME fFrame:HANDLE
       FRAME fOS:FRAME = FRAME fFrame:HANDLE.

/* SETTINGS FOR FRAME fAppServer
                                                                        */
/* SETTINGS FOR RADIO-SET rsAppServer IN FRAME fAppServer
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fDestino
                                                                        */
/* SETTINGS FOR FRAME fFrame
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fOS:MOVE-AFTER-TAB-ITEM (fiProgramas:HANDLE IN FRAME fFrame)
       XXTABVALXX = FRAME fDestino:MOVE-BEFORE-TAB-ITEM (btProcurar:HANDLE IN FRAME fFrame)
       XXTABVALXX = FRAME fAppServer:MOVE-BEFORE-TAB-ITEM (FRAME fDestino:HANDLE)
       XXTABVALXX = FRAME fOS:MOVE-BEFORE-TAB-ITEM (FRAME fAppServer:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fOS
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tg32 IN FRAME fOS
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg64 IN FRAME fOS
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Compilador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Compilador */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCompilar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCompilar wWindow
ON CHOOSE OF btCompilar IN FRAME fFrame /* Compilar */
do:
   define variable c-programa as character no-undo.
   define variable c-destino as character no-undo.
   define variable c-mkdir as character no-undo.
   define variable hProc as handle no-undo.
   define variable c-erro as character no-undo.
   define variable c-path as character no-undo.
   define variable h-acomp as handle no-undo.
   define variable i as integer no-undo.

   assign input frame fFrame fiFontes:screen-value = replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/').
   if substring(input frame fFrame fiFontes:screen-value, length(input frame fFrame fiFontes:screen-value), 1) <> '/' then
      assign input frame fFrame fiFontes:screen-value = input frame fFrame fiFontes:screen-value + '/'.

   if num-entries(input frame fFrame fiProgramas:screen-value) = 0 then do:
      message 'Nenhum arquivo pra compilar!' view-as alert-box error buttons ok.
      return.
   end.

   if not input frame fOS tg32 and not input frame fOS tg64 then do:
      message 'Nenhuma plataforma escolhida!' view-as alert-box error buttons ok.
      return.
   end.

   if input frame fFrame fiFontes:screen-value = '' then do:
      message 'Diret¢rio base dos fontes n∆o informado!' view-as alert-box error buttons ok.
      return.
   end.

   run utp/ut-acomp.p persistent set h-acomp.

   if index(replace(lc(propath), '~\', '/'), 
            replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/')) = 0 then
      assign propath = replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/') + ',' + propath.

   do i = 1 to num-entries(input frame fFrame fiProgramas:screen-value):
      assign c-programa = entry(i, input frame fFrame fiProgramas:screen-value)
             c-programa = trim(lc(replace(c-programa, '\', '/'))).

      run pi-inicializar in h-acomp (input 'Compilando ' + c-programa).

      file-info:file-name = c-programa no-error.
      if index(file-info:file-type, 'F') = 0 then do:
         assign input frame fFrame edLog:screen-value = 'Arquivo ' + c-programa + ' n∆o encontrado, n∆o Ç arquivo, ou n∆o pode ser lido!~r~n' + input frame fFrame edLog:screen-value.
         next.
      end.
      
      run pi-acompanhar in h-acomp (input 'Compilando em GUI').

      assign c-destino = (if input frame fDestino rsDestino = 1 then "{&DESTINO-TESTE}" else "{&DESTINO-LIBERACOES}")
             c-mkdir   = c-destino + (if input frame fDestino tgPasta and input frame fDestino fiPasta:screen-value <> '' then
                                         trim(input frame fDestino fiPasta:screen-value) + '~\'
                                      else
                                         '')
                         + replace(c-programa, replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/'), '')
             c-mkdir = replace(c-mkdir, '/', '~\')
             c-mkdir = substring(c-mkdir, 1, r-index(c-mkdir, '~\') - 1).

      file-info:file-name = c-mkdir.
      if file-info:file-type = ? then
         os-command silent value('mkdir ' + c-mkdir).

      compile value(c-programa)
         save into value(c-mkdir)
         no-error.

      if compiler:error and not compiler:get-message(1) begins 'WARNING' then
         assign input frame fFrame edLog:screen-value = 'Erro compilando ' + c-programa + ': ' + compiler:get-message(1) + '~r~n' + input frame fFrame edLog:screen-value.
      else
         assign input frame fFrame edLog:screen-value = 'Programa ' + c-programa + ' compilado com sucesso!~r~n' + input frame fFrame edLog:screen-value.
         
      IF input frame fOS tg64 THEN DO:

          if c-programa matches '*.w' then do:
             assign input frame fFrame edLog:screen-value = 'Programa ' + c-programa + ' n∆o precisa em TTY!~r~n' + input frame fFrame edLog:screen-value.
             next.
          end.
    
          assign rcode-info:file-name = c-mkdir + '/' + substring(entry(num-entries(c-programa, '/'), c-programa, '/'), 1, r-index(entry(num-entries(c-programa, '/'), c-programa, '/'), '.')) + 'r'
                 file-info:file-name  = rcode-info:file-name.
    
          if file-info:file-type = ? then do:
             assign input frame fFrame edLog:screen-value = 'Programa ' + c-programa + ' compilado n∆o encontrado, n∆o sei se precisa de tty!~r~n' + input frame fFrame edLog:screen-value.
             next.
          end.
    
          if rcode-info:display-type <> 'GUI' then do:
             assign input frame fFrame edLog:screen-value = 'Programa ' + c-programa + ' n∆o precisa em tty!~r~n' + input frame fFrame edLog:screen-value.
             next.
          end.

          /** Compila pra Linux **/
          run pi-acompanhar in h-acomp (input 'Gerando XREF pra pegar as includes').
          run piIncludes (input c-programa, output table tt-include, output c-erro).
    
          run pi-acompanhar in h-acomp (input 'Copiando arquivos').
          for each tt-include no-lock:
             if search(replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/') + tt-include.arquivo) = ? then
                next.
    
             assign c-mkdir = "{&FONTES-WINDOWS}" + replace(tt-include.arquivo, input frame fFrame fiFontes:screen-value, '')
                    c-mkdir = replace(c-mkdir, '/', '~\')
                    c-mkdir = substring(c-mkdir, 1, r-index(c-mkdir, '~\')).
    
             file-info:file-name = c-mkdir.
    
             if file-info:file-type = ? then
                os-command silent value('mkdir ' + c-mkdir).
    
             os-copy value(replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/') + tt-include.arquivo) value(c-mkdir).
    
             assign input frame fFrame edLog:screen-value = 'Include ' + tt-include.arquivo + ' copiada para ' + c-mkdir + '~r~n' + input frame fFrame edLog:screen-value.
          end.
    
          assign c-mkdir = "{&FONTES-WINDOWS}" + replace(c-programa, input frame fFrame fiFontes:screen-value, '')
                 c-mkdir = replace(c-mkdir, '/', '~\')
                 c-mkdir = substring(c-mkdir, 1, r-index(c-mkdir, '~\') - 1).
    
          file-info:file-name = c-mkdir.
    
          if file-info:file-type = ? then
             os-command silent value('mkdir ' + c-mkdir).
    
          os-copy value(c-programa) value(c-mkdir).
    
          assign c-destino = (if input frame fDestino rsDestino = 1 then "{&DESTINO-TESTE}" else "{&DESTINO-LIBERACOES}")
                 c-mkdir = c-destino + (if input frame fDestino tgPasta and input frame fDestino fiPasta:screen-value <> '' then
                                                   trim(input frame fDestino fiPasta:screen-value) + '~\'
                                                else
                                                   '')
                                              + 'tty\' + replace(c-programa, input frame fFrame fiFontes:screen-value, '')
                 c-mkdir = replace(c-mkdir, '/', '~\')
                 c-mkdir = substring(c-mkdir, 1, r-index(c-mkdir, '~\') - 1).
    
          file-info:file-name = c-mkdir.
    
          if file-info:file-type = ? then
             os-command silent value('mkdir ' + c-mkdir).
    
          assign c-path = replace(c-programa, input frame fFrame fiFontes:screen-value, '')
                 c-path = replace(c-path, '~\', '/')
                 c-path = substring(c-path, 1, r-index(c-path, '/') - 1).
      
          run pi-acompanhar in h-acomp (input 'Compilando via AppServer').
          create server hProc.
          hProc:connect("{&APPSERVER-TESTE}") no-error.

          if hProc:connected() then do:

             run bacas/compilador-64.p on server hProc (input "{&FONTES-LINUX}" + replace(c-programa, replace(trim(lc(input frame fFrame fiFontes:screen-value)), '~\', '/'), ''),
                                                        input (if input frame fDestino rsDestino = 1 then "{&DESTINO-TESTE-LINUX}" else "{&DESTINO-LIBERACOES-LINUX}") +
                                                           (if input frame fDestino tgPasta and input frame fDestino fiPasta:screen-value <> '' then
                                                               trim(input frame fDestino fiPasta:screen-value) + '/'
                                                            else
                                                              '') + 'tty/' + c-path,
                                                        output c-erro).
    
             if (return-value = 'OK') then
                assign input frame fFrame edLog:screen-value = 'Programa ' + c-programa + ' compilado em tty com sucesso!~r~n' + input frame fFrame edLog:screen-value.
             else
                assign input frame fFrame edLog:screen-value = 'Erro compilando ' + c-programa + ' em tty: ' + c-erro + '~r~n' + input frame fFrame edLog:screen-value.
          end.
          else do:
             assign input frame fFrame edLog:screen-value = 'N∆o deu pra compilar! Nem conectou: ' + error-status:get-message(1) + '~r~n' + input frame fFrame edLog:screen-value.
          end.
      
          if hProc:connected() then
             hProc:disconnect().
          if valid-handle(hProc) then
             delete object hProc.

          for each tt-include no-lock:
              assign c-mkdir = "{&DESTINO-TESTE}" + 'tty~\' + replace(tt-include.arquivo, input frame fFrame fiFontes:screen-value, '')
                     c-mkdir = replace(c-mkdir, '/', '~\').
    
             if search(c-mkdir) = ? then
                next.
    
             os-delete value(c-mkdir).
          end.

          assign c-mkdir = "RMDIR /S /Q " + "{&FONTES-WINDOWS}".

          OS-COMMAND SILENT VALUE(c-mkdir).
      
      END.

      run pi-acompanhar in h-acomp (input 'Compilado!').
   end.

   run pi-finalizar in h-acomp.

   if valid-handle(h-acomp) then
      delete object h-acomp.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpar wWindow
ON CHOOSE OF btLimpar IN FRAME fFrame /* Limpar log */
do:
   assign input frame fFrame edLog:screen-value = ''.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btProcurar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btProcurar wWindow
ON CHOOSE OF btProcurar IN FRAME fFrame /* Procurar... */
do:
   define variable c-programa as character no-undo.
   define variable l-ok as logical no-undo.

   system-dialog get-file c-programa
      filters "Procedure (*.p)" "*.p",
              "Window (*.w)" "*.w",
              "Class (*.cls)" "*.w",
              "Todos (*.*)" "*.*"
      must-exist
      update l-ok.

   if l-ok then
      if input frame fFrame fiProgramas:screen-value = '' then
         assign input frame fFrame fiProgramas:screen-value = c-programa.
      else
         assign input frame fFrame fiProgramas:screen-value = input frame fFrame fiProgramas:screen-value + ',' + c-programa.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPropath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPropath wWindow
ON CHOOSE OF btPropath IN FRAME fFrame /* PROPATH */
do:
   run protools/_propath.r.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  DISPLAY fiProgramas fiFontes edLog 
      WITH FRAME fFrame IN WINDOW wWindow.
  ENABLE fiProgramas btProcurar btPropath btLimpar btCompilar fiFontes edLog 
      WITH FRAME fFrame IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fFrame}
  DISPLAY tg32 tg64 
      WITH FRAME fOS IN WINDOW wWindow.
  ENABLE tg32 tg64 
      WITH FRAME fOS IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fOS}
  DISPLAY rsAppServer 
      WITH FRAME fAppServer IN WINDOW wWindow.
  VIEW FRAME fAppServer IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fAppServer}
  DISPLAY rsDestino tgPasta fiPasta 
      WITH FRAME fDestino IN WINDOW wWindow.
  ENABLE rsDestino tgPasta fiPasta 
      WITH FRAME fDestino IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fDestino}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIncludes wWindow 
PROCEDURE piIncludes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter pFonte as character no-undo.
   define output parameter table for tt-include.
   define output parameter pErro as character no-undo.

   define variable c-xref as character no-undo.
   define variable c-linha as character no-undo.
   define variable c-arquivo as character no-undo.

   assign c-xref = pFonte + '.xref'.

   empty temp-table tt-include.

   compile value(pFonte)
      xref value(c-xref) no-error.

   if compiler:error and not compiler:get-message(1) begins 'WARNING' then do:
      assign pErro = compiler:get-message(1).
      return 'NOK'.
   end.
   
   input from value(c-xref).

   repeat:
      import unformatted c-linha.

      if (entry(4, c-linha, ' ') = 'INCLUDE') then do:
         assign c-arquivo = trim(lc(replace(replace(replace(entry(5, c-linha, ' '), '"', ''), '~\', '/'), '>', ''))).

         if not can-find (first tt-include
                          where tt-include.arquivo = c-arquivo) then do:
            create tt-include.
            assign tt-include.arquivo = replace(c-arquivo, "~\":U, "/":U).
         end.
      end.
   end.

   input close.

   os-delete value(c-xref) no-error.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

