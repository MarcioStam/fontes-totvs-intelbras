&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp038 1.00.00.000}
{utp/ut-glob.i}

/* <programa>:  esp/ccp/esccp038.w                                                */
/* <m¢dulo>  :  compras                                                           */

/* Create an unnamed pool to store all the widgets created 
   by this procedure. This is a good default which assures
   that this procedure's triggers and internal  procedures 
   will  execute  in  this  procedure's storage, and  that 
   proper cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Temp-tables Definitions ---                                          */

define temp-table tt-param no-undo
    field destino   as integer
    field arquivo   as char format "x(35)"
    field usuario   as char format "x(12)"
    field data-exec as date
    field hora-exec as integer.

DEFINE TEMP-TABLE tt-item-importado NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD fornec      LIKE emitente.cod-emitente
    FIELD cond-pagto  LIKE tb-pr-cc.cod-cond-pag
    FIELD mo-codigo   LIKE moeda.mo-codigo
    FIELD dt-inic-tab LIKE tb-pr-cc.dt-inicio
    FIELD dt-term-tab LIKE tb-pr-cc.dt-termino
    FIELD dt-a-partir LIKE tb-pr-cc.dt-inicio
    FIELD it-codigo   LIKE item-tab.it-codigo
    FIELD pr-item     LIKE item-tab.pr-item
    FIELD qtd-orig    LIKE item-tab.quant-min
    FIELD nova-qtd    LIKE item-tab.quant-min
    FIELD aliq-ipi    LIKE item-tab.aliquota-ipi.

DEFINE TEMP-TABLE tt-validacao-itens NO-UNDO LIKE tt-item-importado
    FIELD motivo      AS   CHARACTER FORMAT "x(200)":U.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp       AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-linha       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-arquivo-log AS CHARACTER FORMAT "X(100)":U NO-UNDO.
DEFINE VARIABLE h-esccp038a   AS HANDLE                      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-justif-esccp038 AS CHARACTER FORMAT "X(500)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-tb-pr-cc       AS ROWID NO-UNDO.

{include/i-rpvar.i}
{include/i-rpc255.i}

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Log de execuá∆o - ESCCP038":U
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
&Scoped-Define ENABLED-OBJECTS rt-button RECT-8 EDITOR-1 rs-acao-item ~
bt-arquivo-entrada c-arquivo-entrada des-justifica bt-executar 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 rs-acao-item c-arquivo-entrada ~
des-justifica text-entrada text-entrada-2 

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
     SIZE 53 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE des-justifica AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 77 BY 6.63 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 77 BY 2.88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)" INITIAL "Arquivo:" 
      VIEW-AS TEXT 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada-2 AS CHARACTER FORMAT "X(256)" INITIAL "Justificativa:" 
      VIEW-AS TEXT 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE rs-acao-item AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Alteraá∆o de Itens", 1,
"&Inclus∆o de Itens", 2
     SIZE 15.14 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.72 BY 13.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     EDITOR-1 AT ROW 2.88 COL 12 NO-LABEL WIDGET-ID 46
     rs-acao-item AT ROW 6.5 COL 72.43 HELP
          "Incluir ou Alterar o item importado" NO-LABEL WIDGET-ID 34
     bt-arquivo-entrada AT ROW 6.63 COL 65.29 HELP
          "Escolha do nome do arquivo" WIDGET-ID 20
     c-arquivo-entrada AT ROW 6.71 COL 12 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 22
     des-justifica AT ROW 8.63 COL 12 HELP
          "Justificativa de Inclus∆o/Alteraá∆o Tabela Preáo" NO-LABEL WIDGET-ID 14
     bt-executar AT ROW 15.71 COL 1.86 HELP
          "Importa tabela de preáo do arquivo indicado." WIDGET-ID 28
     text-entrada AT ROW 6.71 COL 6 NO-LABEL WIDGET-ID 26
     text-entrada-2 AT ROW 8.63 COL 3 NO-LABEL WIDGET-ID 32
     rt-button AT ROW 1 COL 1
     RECT-8 AT ROW 2.5 COL 1 WIDGET-ID 24
     RECT-1 AT ROW 15.5 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.86 BY 16.08
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
         HEIGHT             = 16.08
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

/* SETTINGS FOR FILL-IN text-entrada-2 IN FRAME f-cad
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       text-entrada-2:PRIVATE-DATA IN FRAME f-cad     = 
                "Justificativa:".

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
               "*.csv" "*.csv",
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
    ASSIGN INPUT FRAME f-cad c-arquivo-entrada rs-acao-item des-justifica.    

    IF  des-justifica = "" THEN DO:
        MESSAGE "Justificativa deve ser informada!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO des-justifica IN FRAME f-cad.
        RETURN NO-APPLY.
    END. /* IF  des-justifica = "" THEN DO: */

    run pi-importar.

    if  can-find(first tt-item-importado) then do:
        run pi-validar.
        
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Se retorno NOK, nada ser† importado, ent∆o a temp-table Ç zerada */
            EMPTY TEMP-TABLE tt-item-importado NO-ERROR.
            RUN pi-saida-relat.

            RETURN NO-APPLY.
        END.
        
        run pi-executar.
    end. /* if  can-find(first tt-item-importado) then do: */

    RUN pi-saida-relat.

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
                  "Estab;Fornec;Cond.Pagto;Moeda;Dt.Inicio;Dt.Term;Dt.a Partir;Item;Preáo Item;Qtde.Orig;Nova Qtde;%IPI" + CHR(13) +
                  "101;114411;10;1;10092015;21092016;15092015;1000020;2,45;2;3;17" + CHR(13) +
                  "101;114411;28;2;10092015;21092016;15092015;1000022;32,45;5;8;12" .

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
  DISPLAY EDITOR-1 rs-acao-item c-arquivo-entrada des-justifica text-entrada 
          text-entrada-2 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-8 EDITOR-1 rs-acao-item bt-arquivo-entrada 
         c-arquivo-entrada des-justifica bt-executar 
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

  {utp/ut9000.i "esccp038" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-motivo w-livre 
PROCEDURE pi-cria-motivo :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-motivo AS CHARACTER FORMAT "x(100)":U NO-UNDO.

CREATE tt-validacao-itens.
ASSIGN tt-validacao-itens.cod-estabel = tt-item-importado.cod-estabel
       tt-validacao-itens.fornec      = tt-item-importado.fornec      
       tt-validacao-itens.cond-pagto  = tt-item-importado.cond-pagto 
       tt-validacao-itens.mo-codigo   = tt-item-importado.mo-codigo
       tt-validacao-itens.dt-inic-tab = tt-item-importado.dt-inic-tab 
       tt-validacao-itens.dt-term-tab = tt-item-importado.dt-term-tab 
       tt-validacao-itens.dt-a-partir = tt-item-importado.dt-a-partir 
       tt-validacao-itens.it-codigo   = tt-item-importado.it-codigo   
       tt-validacao-itens.pr-item     = tt-item-importado.pr-item     
       tt-validacao-itens.qtd-orig    = tt-item-importado.qtd-orig
       tt-validacao-itens.nova-qtd    = tt-item-importado.nova-qtd
       tt-validacao-itens.aliq-ipi    = tt-item-importado.aliq-ipi    
       tt-validacao-itens.motivo      = p-motivo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-livre 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

RUN esp/ccp/esccp038a.p PERSISTENT SET h-esccp038a.

RUN utp/ut-acomp PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT 'Processando ...':U).

table_block:
do transaction on endkey undo table_block, leave table_block on error undo table_block, leave table_block:

    ASSIGN g-justif-esccp038 = des-justifica.

    princ_block:
    FOR EACH tt-item-importado:

        RUN pi-acompanhar IN h-acomp (INPUT 'ITEM: ':U + STRING(tt-item-importado.it-codigo)).

        IF  CAN-FIND(FIRST tt-validacao-itens
                     WHERE tt-validacao-itens.cod-estabel  = tt-item-importado.cod-estabel      
                     and   tt-validacao-itens.fornec       = tt-item-importado.fornec               
                     and   tt-validacao-itens.cond-pagto   = tt-item-importado.cond-pagto 
                     AND   tt-validacao-itens.mo-codigo    = tt-item-importado.mo-codigo
                     and   tt-validacao-itens.dt-inic-tab  = tt-item-importado.dt-inic-tab  
                     and   tt-validacao-itens.dt-term-tab  = tt-item-importado.dt-term-tab  
                     and   tt-validacao-itens.dt-a-partir  = tt-item-importado.dt-a-partir  
                     and   tt-validacao-itens.it-codigo    = tt-item-importado.it-codigo    
                     and   tt-validacao-itens.pr-item      = tt-item-importado.pr-item      
                     and   tt-validacao-itens.qtd-orig     = tt-item-importado.qtd-orig
                     and   tt-validacao-itens.nova-qtd     = tt-item-importado.nova-qtd
                     and   tt-validacao-itens.aliq-ipi     = tt-item-importado.aliq-ipi) THEN NEXT princ_block.
        
        FOR FIRST item-fornec-estab NO-LOCK
            WHERE item-fornec-estab.it-codigo    = tt-item-importado.it-codigo
            AND   item-fornec-estab.cod-emitente = tt-item-importado.fornec
            AND   item-fornec-estab.cod-estabel  = tt-item-importado.cod-estabel 
            AND   SUBSTR(item-fornec-estab.char-1,1,2) = STRING(tt-item-importado.mo-codigo):
        
            FIND FIRST tb-pr-cc NO-LOCK
                WHERE  tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                AND    tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag
                AND    tb-pr-cc.dt-inicio    = tt-item-importado.dt-inic-tab
                AND    tb-pr-cc.mo-codigo    = tt-item-importado.mo-codigo
                AND    tb-pr-cc.situacao     = 1 /* Ativa */ NO-ERROR.
            IF  AVAIL  tb-pr-cc THEN DO:

                /* Para uso no win185.p */
                ASSIGN gr-tb-pr-cc = ROWID(tb-pr-cc).

                CASE rs-acao-item:
                    WHEN 1 /* Alteraá∆o de Item */ THEN DO:
                        FIND FIRST item-tab OF tb-pr-cc EXCLUSIVE-LOCK
                            WHERE  item-tab.it-codigo = tt-item-importado.it-codigo 
                            AND    item-tab.quant-min = tt-item-importado.qtd-orig NO-ERROR.
                        IF  AVAIL item-tab THEN DO:
                            ASSIGN item-tab.pr-item      = tt-item-importado.pr-item
                                   item-tab.quant-min    = tt-item-importado.nova-qtd
                                   item-tab.aliquota-ipi = tt-item-importado.aliq-ipi
                                   item-tab.mo-codigo    = tt-item-importado.mo-codigo.
                        END. /* IF  AVAIL item-tab THEN DO: */
                    END. /* WHEN 1 */
                    WHEN 2 /* Inclus∆o de Item */ THEN DO:
                        FIND FIRST item-tab OF tb-pr-cc EXCLUSIVE-LOCK
                            WHERE  item-tab.it-codigo = tt-item-importado.it-codigo 
                            AND    item-tab.quant-min = tt-item-importado.qtd-orig NO-ERROR.
                        IF  NOT AVAIL item-tab THEN DO:
                            CREATE item-tab.
                            ASSIGN item-tab.cod-emitente   = tb-pr-cc.cod-emitente
                                   item-tab.cdn-fabrican   = tb-pr-cc.cdn-fabrican
                                   item-tab.des-referencia = ""
                                   item-tab.cod-cond-pag   = tb-pr-cc.cod-cond-pag
                                   item-tab.nr-tab         = tb-pr-cc.nr-tab
                                   item-tab.dt-inicio      = tt-item-importado.dt-inic-tab
                                   item-tab.it-codigo      = tt-item-importado.it-codigo
                                   item-tab.quant-min      = tt-item-importado.qtd-orig
                                   item-tab.pr-item        = tt-item-importado.pr-item
                                   item-tab.aliquota-ipi   = tt-item-importado.aliq-ipi
                                   item-tab.mo-codigo      = tt-item-importado.mo-codigo.

                            FOR FIRST emitente NO-LOCK
                                WHERE emitente.cod-emitente = item-tab.cod-emitente:
                                ASSIGN item-tab.nome-abrev = emitente.nome-abrev.
                            END. /* FOR FIRST emitente ... */

                        END. /* IF  NOT AVAIL item-tab THEN DO: */
                    END. /* WHEN 2 */
                END CASE.
            END. /* IF  AVAIL  tb-pr-cc THEN DO: */

            /*
            IF  AVAIL item-tab THEN DO:
                RUN p-atualiza-pedido IN h-esccp038a (INPUT ROWID(item-tab),
                                                      INPUT tt-item-importado.dt-a-partir).
            END. /* IF  AVAIL item-tab THEN DO: */
            */
        END. /* FOR FIRST item-fornec-estab NO-LOCK */
    END. /* FOR EACH tt-item-importado: */
END.

RUN pi-finalizar IN h-acomp.

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

EMPTY TEMP-TABLE tt-item-importado NO-ERROR.

REPEAT ON STOP UNDO, LEAVE:
    IMPORT STREAM s-imp UNFORMATTED c-linha.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Item: " + TRIM(ENTRY(7, c-linha, ";":U))).

    CREATE tt-item-importado.
    ASSIGN tt-item-importado.cod-estabel =    TRIM(ENTRY(1,  c-linha, ";":U))
           tt-item-importado.fornec      = INTEGER(ENTRY(2,  c-linha, ";":U))
           tt-item-importado.cond-pagto  = INTEGER(ENTRY(3,  c-linha, ";":U))
           tt-item-importado.mo-codigo   = INTEGER(ENTRY(4,  c-linha, ";":U))
           tt-item-importado.dt-inic-tab =    DATE(ENTRY(5,  c-linha, ";":U))
           tt-item-importado.dt-term-tab =    DATE(ENTRY(6,  c-linha, ";":U))
           tt-item-importado.dt-a-partir =    DATE(ENTRY(7,  c-linha, ";":U))
           tt-item-importado.it-codigo   =    TRIM(ENTRY(8,  c-linha, ";":U))
           tt-item-importado.pr-item     =     DEC(ENTRY(9,  c-linha, ";":U))
           tt-item-importado.qtd-orig    =     DEC(ENTRY(10, c-linha, ";":U))
           tt-item-importado.nova-qtd    =     DEC(ENTRY(11, c-linha, ";":U))
           tt-item-importado.aliq-ipi    =     DEC(ENTRY(12, c-linha, ";":U)).

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-item-importado.fornec:

        /* Para os fornecedores importados o IPI dever† estar zerado na planilha */
        IF  emitente.natureza = 3 /* Estrangeiro */ THEN
            ASSIGN tt-item-importado.aliq-ipi = 0.0.

    END. /* FOR FIRST emitente NO-LOCK */

END. /* REPEAT ON STOP UNDO, LEAVE: */
INPUT STREAM s-imp CLOSE.

IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saida-relat w-livre 
PROCEDURE pi-saida-relat :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN c-arquivo-log = SESSION:TEMP-DIRECTORY + "esccp038.lst":U.
OUTPUT TO value(c-arquivo-log) NO-CONVERT.

view frame f-cabec-255.

PUT  UNFORMATTED
    "[ ITENS REJEITADOS ]:" SKIP
    "Est Fornec    Cond.Pg Moeda Dt.Inicio  Dt.Termino Dt.A Partir Item             Preáo Item              Qtde.Orig     Nova Qtde  % IPI Motivo" SKIP
    "--- --------- ------- ----- ---------- ---------- ----------- ---------------- ------------------- ------------- ------------- ------ ----------------------------------------------------------------------------------------------------" SKIP.

FOR EACH tt-validacao-itens:
    PUT UNFORMATTED
        tt-validacao-itens.cod-estabel  format "X(03)":U               AT 001 
        tt-validacao-itens.fornec       format ">>>>>>>>9":U           TO 013
        tt-validacao-itens.cond-pagto   format ">>>9":U                TO 021 
        tt-validacao-itens.mo-codigo    format ">9":U                  AT 023
        tt-validacao-itens.dt-inic-tab  format "99/99/9999":U          AT 029 
        tt-validacao-itens.dt-term-tab  format "99/99/9999":U          AT 040 
        tt-validacao-itens.dt-a-partir  format "99/99/9999":U          AT 051 
        tt-validacao-itens.it-codigo    format "X(16)":U               AT 063 
        tt-validacao-itens.pr-item      format ">>>>>,>>>,>>9.99999":U TO 098 
        tt-validacao-itens.qtd-orig     format ">>>>,>>9.9999":U       TO 112 
        tt-validacao-itens.nova-qtd     format ">>>>,>>9.9999":U       TO 126 
        tt-validacao-itens.aliq-ipi     format ">>9.99":U              TO 132 
        tt-validacao-itens.motivo       format "x(100)":U              AT 134 SKIP.
END. /* FOR EACH tt-validacao-itens: */

PUT SKIP(1).

PUT UNFORMATTED
    "[ ITENS PROCESSADOS ]:" SKIP
    "Est Fornec    Cond.Pg Moeda Dt.Inicio  Dt.Termino Dt.A Partir Item             Preáo Item              Qtde.Orig     Nova Qtde  % IPI" SKIP
    "--- --------- ------- ----- ---------- ---------- ----------- ---------------- ------------------- ------------- ------------- ------" SKIP.

princ_block:
FOR EACH tt-item-importado:
    IF  CAN-FIND(FIRST tt-validacao-itens
                 WHERE tt-validacao-itens.cod-estabel = tt-item-importado.cod-estabel
                 AND   tt-validacao-itens.fornec      = tt-item-importado.fornec     
                 AND   tt-validacao-itens.cond-pagto  = tt-item-importado.cond-pagto 
                 AND   tt-validacao-itens.mo-codigo   = tt-item-importado.mo-codigo 
                 AND   tt-validacao-itens.dt-inic-tab = tt-item-importado.dt-inic-tab
                 AND   tt-validacao-itens.dt-term-tab = tt-item-importado.dt-term-tab
                 AND   tt-validacao-itens.dt-a-partir = tt-item-importado.dt-a-partir
                 AND   tt-validacao-itens.it-codigo   = tt-item-importado.it-codigo  
                 AND   tt-validacao-itens.pr-item     = tt-item-importado.pr-item    
                 AND   tt-validacao-itens.qtd-orig    = tt-item-importado.qtd-orig
                 AND   tt-validacao-itens.nova-qtd    = tt-item-importado.nova-qtd
                 AND   tt-validacao-itens.aliq-ipi    = tt-item-importado.aliq-ipi) THEN NEXT princ_block.

    PUT UNFORMATTED
        tt-item-importado.cod-estabel  format "X(03)":U               AT 001
        tt-item-importado.fornec       format ">>>>>>>>9":U           TO 013
        tt-item-importado.cond-pagto   format ">>>9":U                TO 021
        tt-item-importado.mo-codigo    format ">9":U                  AT 023
        tt-item-importado.dt-inic-tab  format "99/99/9999":U          AT 029
        tt-item-importado.dt-term-tab  format "99/99/9999":U          AT 040
        tt-item-importado.dt-a-partir  format "99/99/9999":U          AT 051
        tt-item-importado.it-codigo    format "X(16)":U               AT 063
        tt-item-importado.pr-item      format ">>>>>,>>>,>>9.99999":U TO 098
        tt-item-importado.qtd-orig     format ">>>>,>>9.9999":U       TO 112
        tt-item-importado.nova-qtd     format ">>>>,>>9.9999":U       TO 126
        tt-item-importado.aliq-ipi     format ">>9.99":U              TO 132 SKIP.

END. /* FOR EACH tt-item-importado: */

PUT SKIP(10).
view frame f-rodape-255.

OUTPUT CLOSE.

RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo-log,
             INPUT 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar w-livre 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-validacao-itens NO-ERROR.

    item_block:
    FOR EACH tt-item-importado:
        /*---[ Fornecedor ]----------------------------------------------------------------------------------------------------*/
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = tt-item-importado.fornec NO-ERROR.
        IF  NOT AVAIL emitente 
        OR  (AVAIL emitente AND emitente.identific = 1 /* cliente */) THEN DO:

            RUN pi-cria-motivo (INPUT "Fornecedor Inexistente.":U).
            RETURN "NOK":U.

        END. /* IF NOT AVAIL emitente THEN DO: */

        /*---[ Condiá∆o de Pagamento ]-----------------------------------------------------------------------------------------*/
        FIND FIRST cond-pagto NO-LOCK
            WHERE  cond-pagto.cod-cond-pag = tt-item-importado.cond-pagto NO-ERROR.
        IF  NOT AVAIL cond-pagto THEN DO:

            RUN pi-cria-motivo (INPUT "Condiá∆o de Pagamento Inexistente.":U).
            RETURN "NOK":U.

        END. /* IF  NOT AVAIL cond-pagto THEN DO: */

        /*---[ Moeda ]-----------------------------------------------------------------------------------------*/
        FIND FIRST moeda NO-LOCK
            WHERE moeda.mo-codigo = tt-item-importado.mo-codigo NO-ERROR.
        IF  NOT AVAIL moeda THEN DO:

            RUN pi-cria-motivo (INPUT "Moeda Inexistente.":U).
            RETURN "NOK":U.

        END. /* IF  NOT AVAIL cond-pagto THEN DO: */

        /*---[ Tabela da Preáo ]-----------------------------------------------------------------------------------------------*/
        IF  CAN-FIND(FIRST tb-pr-cc
                     WHERE tb-pr-cc.cod-emitente = tt-item-importado.fornec    
                     AND   tb-pr-cc.cod-cond-pag = tt-item-importado.cond-pagto
                     AND   tb-pr-cc.dt-inicio    = tt-item-importado.dt-inic-tab
                     AND   tb-pr-cc.mo-codigo    = tt-item-importado.mo-codigo
                     AND   tb-pr-cc.situacao     = 1 /* ativa */) THEN DO:
            FIND FIRST tb-pr-cc NO-LOCK
                WHERE  tb-pr-cc.cod-emitente = tt-item-importado.fornec    
                AND    tb-pr-cc.cod-cond-pag = tt-item-importado.cond-pagto 
                AND    tb-pr-cc.dt-inicio    = tt-item-importado.dt-inic-tab
                AND    tb-pr-cc.mo-codigo    = tt-item-importado.mo-codigo
                AND    tb-pr-cc.situacao     = 1 /* ativa */ NO-ERROR.
            IF  AVAIL  tb-pr-cc THEN DO:

                IF  (tt-item-importado.dt-inic-tab < tb-pr-cc.dt-inicio
                OR   tt-item-importado.dt-term-tab > tb-pr-cc.dt-termino) THEN DO:
            
                    RUN pi-cria-motivo (INPUT "Tabela de Preáo Inativa ou fora de validade.":U).
                    RETURN "NOK":U.

                END. /* IF  (tb-pr-cc.dt-inicio ...*/
            END. /* IF  AVAIL  tb-pr-cc */
        END. /* IF  CAN-FIND(FIRST tb-pr-cc */
        ELSE DO:
            RUN pi-cria-motivo (INPUT "Tabela de Preáo Inexistente ou Inativa.":U).
            RETURN "NOK":U.
        END. /* ELSE DO: */

        /*---[ Item ]----------------------------------------------------------------------------------------------------------*/
        FIND FIRST ITEM NO-LOCK
            WHERE  ITEM.it-codigo = tt-item-importado.it-codigo NO-ERROR.
        IF  NOT AVAIL ITEM THEN DO:

            RUN pi-cria-motivo (INPUT "Item " + tt-item-importado.it-codigo + " Inexistente.":U).
            NEXT item_block.
        
        END. /* IF  NOT AVAIL ITEM THEN DO: */ 

        /*---[ Relacionamento Fornec X Item X Estab ]--------------------------------------------------------------------------*/
        FIND FIRST item-fornec-estab NO-LOCK
            WHERE  item-fornec-estab.it-codigo    = tt-item-importado.it-codigo
            AND    item-fornec-estab.cod-emitente = tt-item-importado.fornec
            AND    item-fornec-estab.cod-estabel  = tt-item-importado.cod-estabel
            AND    SUBSTR(item-fornec-estab.char-1,1,2) = STRING(tt-item-importado.mo-codigo) NO-ERROR.
        IF  NOT AVAIL item-fornec-estab THEN DO:

            RUN pi-cria-motivo (INPUT "Item ":U + tt-item-importado.it-codigo + " sem relacionamento para fornecedor ":U + 
                                      STRING(tt-item-importado.fornec) + " no CC0531 para estabelecimento ":U + tt-item-importado.cod-estabel + " e Moeda ":U + STRING(tt-item-importado.mo-codigo) + ".":U).
            NEXT item_block.
        
        END. /* IF  NOT AVAIL item-fornec-estab THEN DO: */
        ELSE DO:
            IF  item-fornec-estab.cod-cond-pag <> tt-item-importado.cond-pagto THEN DO:
                RUN pi-cria-motivo (INPUT "Item X Fornec X Estab x Moeda possui condiá∆o de pagamento diferente da informada no arquivo. (C¢d.":U + STRING(item-fornec-estab.cod-cond-pag) + ")":U).
                NEXT item_block.
            END.

            IF  NOT item-fornec-estab.ativo THEN DO:
                RUN pi-cria-motivo (INPUT "Relacionamento Item X Fornec X Estab X Moeda n∆o est† ativo. Verifique o programa CC0531.":U).
                NEXT item_block.
            END.

        END. /* ELSE DO: */

        IF  rs-acao-item = 1 /* ALTERAÄ«O de itens */ THEN DO:
            IF  AVAIL tb-pr-cc THEN DO:
                
                FIND FIRST item-tab NO-LOCK
                     WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
                     AND   item-tab.cdn-fabrican = tb-pr-cc.cdn-fabrican
                     AND   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                     AND   item-tab.nr-tab       = tb-pr-cc.nr-tab
                     AND   item-tab.dt-inicio    = tb-pr-cc.dt-inicio
                     AND   item-tab.it-codigo    = tt-item-importado.it-codigo NO-ERROR.
                    
                IF  AVAIL  item-tab THEN DO:

                    IF  item-tab.quant-min <> tt-item-importado.qtd-orig THEN DO:

                        RUN pi-cria-motivo (INPUT "Quantidade original item ":U + tt-item-importado.it-codigo + " informada na planilha Ç divergente da tabela ":U + 
                                            STRING(item-tab.nr-tab) + ".":U).

                        NEXT item_block.
                    END. /* IF  item-tab.quant-min <> tt-item-importado.qtd-orig THEN DO: */

                    
                    IF  tt-item-importado.qtd-orig <> tt-item-importado.nova-qtd
                    AND item-tab.quant-min          = tt-item-importado.nova-qtd THEN DO:
                        RUN pi-cria-motivo (INPUT "Item ":U + tt-item-importado.it-codigo + " j† relacionado ao fornecedor ":U + 
                                            STRING(tt-item-importado.fornec) + " e condiá∆o de pagamento ":U + STRING(tt-item-importado.cond-pagto) + " com esta nova quantidade.":U).
                        NEXT item_block.
                    END. /* IF  item-tab.quant-min = tt-item-importado.nova-qtd ... */
                END. /* IF  AVAIL  item-tab THEN DO: */
                ELSE DO:
                    RUN pi-cria-motivo (INPUT "Item ":U + tt-item-importado.it-codigo + " n∆o relacionado ao fornecedor ":U + 
                                        STRING(tt-item-importado.fornec) + " e condiá∆o de pagamento ":U + STRING(tt-item-importado.cond-pagto) + ".":U).

                    NEXT item_block.                
                END. /* ELSE DO: */
            END. /* IF  AVAIL tb-pr-cc */
        END. /* IF  rs-acao-item = 2 */ 
        ELSE DO: /* INCLUS«O de itens */
            IF  AVAIL tb-pr-cc THEN DO:
                IF  CAN-FIND(FIRST item-tab 
                             WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
                             AND   item-tab.cdn-fabrican = tb-pr-cc.cdn-fabrican
                             AND   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                             AND   item-tab.nr-tab       = tb-pr-cc.nr-tab
                             AND   item-tab.dt-inicio    = tb-pr-cc.dt-inicio
                             AND   item-tab.it-codigo    = tt-item-importado.it-codigo
                             AND   item-tab.quant-min    = tt-item-importado.qtd-orig) THEN DO:

                    RUN pi-cria-motivo (INPUT "Item ":U + tt-item-importado.it-codigo + " j† relacionado ao fornecedor ":U + 
                                        STRING(tt-item-importado.fornec) + " e condiá∆o de pagamento ":U + STRING(tt-item-importado.cond-pagto) + ".":U).
                    NEXT item_block.
                END. /* IF  NOT CAN-FIND(FIRST item-tab */ 

            END. /* IF  AVAIL tb-pr-cc */        END. /* ELSE DO: */

    END. /* FOR EACH tt-item-importado: */

    RETURN "OK":U.
    
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

