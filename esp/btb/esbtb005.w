&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/***********************************************************************
**  Programa..: esp/btb/esbtb005.w
**  Autor.....: Nicolas Martinez
**  Data......: Novembro/2021 - Desenvolvimento
**  Descricao.: Importador de usuarios x impressora
**  Versao....: 001 29/11/2021
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i esbtb005 1.00.00.000}
{utp/ut-glob.i}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Temp-tables Definitions ---                                          */
DEFINE TEMP-TABLE tt-importado NO-UNDO
    FIELD cod-usuario AS CHAR.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp       AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-linha       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-arquivo-log AS CHARACTER FORMAT "X(100)":U NO-UNDO.

{include/i-rpvar.i}
{include/i-rpc255.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Log de execuá∆o - ESBTB005":U
       c-sistema          = "Espec°ficos Intelbras":U
       C-Versao       = "1.00"
       C-Revisao      = "000"
       C-Sistema      = "ESP".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-8 EDITOR-1 bt-arquivo-entrada ~
c-arquivo-entrada fi-impressora fi-dispositivo bt-executar 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 c-arquivo-entrada fi-impressora ~
fi-dispositivo text-entrada 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo-entrada 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "&Importar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 72 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 77 BY 2.88 NO-UNDO.

DEFINE VARIABLE fi-dispositivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dispositivo" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE fi-impressora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impressora" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)" INITIAL "Arquivo:" 
      VIEW-AS TEXT 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.72 BY 7.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     EDITOR-1 AT ROW 2.88 COL 12 NO-LABEL WIDGET-ID 46
     bt-arquivo-entrada AT ROW 6.21 COL 84.43 HELP
          "Escolha do nome do arquivo" WIDGET-ID 20
     c-arquivo-entrada AT ROW 6.29 COL 12 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 22
     fi-impressora AT ROW 7.29 COL 10 COLON-ALIGNED WIDGET-ID 48
     fi-dispositivo AT ROW 8.29 COL 10 COLON-ALIGNED WIDGET-ID 50
     bt-executar AT ROW 9.96 COL 1.86 HELP
          "Importa tabela de preáo do arquivo indicado." WIDGET-ID 28
     text-entrada AT ROW 6.29 COL 6 NO-LABEL WIDGET-ID 26
     rt-button AT ROW 1 COL 1
     RECT-8 AT ROW 2.5 COL 1 WIDGET-ID 24
     RECT-1 AT ROW 9.75 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.86 BY 10.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.33
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
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME f-cad
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME f-cad     = 
                "Arquivo:".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-entrada w-livre
ON CHOOSE OF bt-arquivo-entrada IN FRAME f-cad
DO:
    DEFINE VARIABLE c-arq-conv AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-ok       AS LOGICAL   NO-UNDO.
    
    assign c-arq-conv = replace(input frame f-cad c-arquivo-entrada, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS &IF "{3}" <> "" &THEN {3} 
               &ENDIF
               &IF "{3}" = "" &THEN
               "*.txt" "*.txt",
               "*.*" "*.*"         
               &ENDIF      
       &IF 'c-arquivo-entrada' <> 'c-arquivo-entrada' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-arquivo-entrada = replace(c-arq-conv, "\", "/").
        display c-arquivo-entrada with frame f-cad.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-livre
ON CHOOSE OF bt-executar IN FRAME f-cad /* Importar */
DO:
    IF SEARCH(INPUT FRAME f-cad c-arquivo-entrada) = ? 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Arquivo ou diretorio n∆o encontrado!").

        RETURN NO-APPLY.

    END.

    IF INPUT FRAME f-cad fi-impressora = ""
    THEN DO:   
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Informe uma impressora!").

        RETURN NO-APPLY.
    END.
    ELSE DO:
        FIND FIRST impressora WHERE
                   impressora.nom_impressora = INPUT FRAME f-cad fi-impressora
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL impressora 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show',
                               INPUT 17006,
                               INPUT "Impressora n∆o cadastrada!").
            
            RETURN NO-APPLY.
        END.
    END.

    IF INPUT FRAME f-cad fi-dispositivo = ""
    THEN DO:
    
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Informe um dispositivo!").

        RETURN NO-APPLY.
    END.

    RUN pi-importar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-livre
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


ASSIGN editor-1 = "Layout do Arquivo: " + CHR(13) +
                  "ra078531" + CHR(13) +
                  "cl053219" + CHR(13) +
                  "aa050851" .

DISP editor-1
    WITH FRAME f-cad.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             EDITOR-1:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 c-arquivo-entrada fi-impressora fi-dispositivo text-entrada 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-8 EDITOR-1 bt-arquivo-entrada c-arquivo-entrada 
         fi-impressora fi-dispositivo bt-executar 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "esbtb005" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importar w-livre 
PROCEDURE pi-importar :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

IF  NOT VALID-HANDLE(h-acomp) THEN DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "":U).
END. /* IF  NOT VALID-HANDLE(h-acomp) THEN DO: */

INPUT STREAM s-imp FROM VALUE(c-arquivo-entrada).

EMPTY TEMP-TABLE tt-importado NO-ERROR.

REPEAT ON STOP UNDO, LEAVE:
    IMPORT STREAM s-imp UNFORMATTED c-linha.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Arq Usu†rio: " + c-linha).

    CREATE tt-importado.
    ASSIGN tt-importado.cod-usuario = c-linha.

END. /* REPEAT ON STOP UNDO, LEAVE: */
INPUT STREAM s-imp CLOSE.

FOR EACH tt-importado:
    IF NOT CAN-FIND(FIRST usuar_mestre WHERE
                          usuar_mestre.cod_usuario = tt-importado.cod-usuario) 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Usuario n∆o cadastrado!"
                           + "~~" +
                           "Usu†rio " + tt-importado.cod-usuario + " n∆o esta cadatrado no sistema, importaá∆o do arquivo n∆o efetuada").
        
        IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

        RETURN NO-APPLY.
    END.
END.

FOR EACH tt-importado:
    FIND FIRST imprsor_usuar 
         WHERE imprsor_usuar.nom_impressora = INPUT FRAME f-cad fi-impressora
         AND   imprsor_usuar.cod_usuario    = tt-importado.cod-usuario
               EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL imprsor_usuar 
    THEN DO:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Alterando Usu†rio: " + tt-importado.cod-usuario).

        ASSIGN imprsor_usuar.nom_disposit_so = INPUT FRAME f-cad fi-dispositivo.

        RELEASE imprsor_usuar.
    END.
    ELSE DO:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Incluindo Usu†rio: " + tt-importado.cod-usuario).

        create imprsor_usuar.
        assign imprsor_usuar.nom_impressora        = INPUT FRAME f-cad fi-impressora
               imprsor_usuar.cod_usuario           = tt-importado.cod-usuario
               imprsor_usuar.nom_disposit_so       = INPUT FRAME f-cad fi-dispositivo
               imprsor_usuar.cod_usuar_ult_atualiz = v_cod_usuar_corren
               imprsor_usuar.dat_ult_atualiz       = today
               imprsor_usuar.hra_ult_atualiz       = replace(string(time,'HH:MM:SS'),':','').
    END.
END.

RUN utp/ut-msgs.p (INPUT "SHOW":U,
                   INPUT 15825,
                   INPUT "Arquivo importado com sucesso!":U).

IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

