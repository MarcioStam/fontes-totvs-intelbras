&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP076 2.00.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEF NEW GLOBAL SHARED VAR gr-ped-item       AS ROWID         NO-UNDO.
DEF var  c-nome-abrev   LIKE ped-item.nome-abrev   NO-UNDO.
DEF var  c-nr-pedcli    LIKE ped-item.nr-pedcli    NO-UNDO.
DEF var  i-nr-sequencia LIKE ped-item.nr-sequencia NO-UNDO.
DEF var  c-it-codigo    LIKE ped-item.it-codigo    NO-UNDO.
DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.
FIND ped-item
    WHERE ROWID(ped-item) = gr-ped-item NO-LOCK NO-ERROR.

IF AVAIL ped-item THEN DO:
    ASSIGN c-nome-abrev    = ped-item.nome-abrev
            c-nr-pedcli    = ped-item.nr-pedcli
            i-nr-sequencia = ped-item.nr-sequencia
            c-it-codigo    = ped-item.it-codigo.
END.

RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Esta tela tem por objetivo informar o rateio da receita entre as unidades. Confirma a Informa‡Æo?":U).
IF  RETURN-VALUE = "NO" THEN DO:
    RETURN "NOK":U.
END.
/*  IF ped-item.cod-sit-item > 2 THEN DO:                                                   */
/*      MESSAGE "Situacao do Item do Pedido Nao permite altera‡Æo de percentuais de rateio" */
/*          VIEW-AS ALERT-BOX INFO BUTTONS OK.                                              */
/*      RETURN "NOK":U.                                                                     */
/*  END.                                                                                    */



DEF BUFFER b-ped-item-segmentos FOR ped-item-segmentos.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ped-item-segmentos

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ped-item-segmentos.cod-segmento ~
ped-item-segmentos.val-percentual 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 ~
ped-item-segmentos.val-percentual 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 ped-item-segmentos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 ped-item-segmentos
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ped-item-segmentos ~
      WHERE ped-item-segmentos.nr-pedcli = c-nr-pedcli ~
 AND ped-item-segmentos.nome-abrev = c-nome-abrev ~
 AND ped-item-segmentos.nr-sequencia = i-nr-sequencia ~
 AND ped-item-segmentos.it-codigo = c-it-codigo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ped-item-segmentos ~
      WHERE ped-item-segmentos.nr-pedcli = c-nr-pedcli ~
 AND ped-item-segmentos.nome-abrev = c-nome-abrev ~
 AND ped-item-segmentos.nr-sequencia = i-nr-sequencia ~
 AND ped-item-segmentos.it-codigo = c-it-codigo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ped-item-segmentos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ped-item-segmentos


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 c-cod-segmento ~
de-percentual bt-incluir BROWSE-2 bt-localizar bt-excluir bt-ok bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-nr-pedcli-tela c-it-codigo-tela ~
c-cod-segmento c-descricao de-percentual 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-excluir 
     IMAGE-UP FILE "adeicon/del-ad.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.5.

DEFINE BUTTON bt-incluir 
     IMAGE-UP FILE "adeicon/editor.ico":U
     LABEL "Incluir" 
     SIZE 6 BY 1.5 TOOLTIP "Incluir novo Registro".

DEFINE BUTTON bt-localizar 
     IMAGE-UP FILE "adeicon/asproc-u.bmp":U
     IMAGE-DOWN FILE "adeicon/asproc-d.bmp":U
     LABEL "Localizar" 
     SIZE 6 BY 1.5 TOOLTIP "Incluir novo Registro".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Sair" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-segmento AS CHARACTER FORMAT "X(4)":U INITIAL "0000" 
     LABEL "Segmento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE c-it-codigo-tela AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-tela AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-percentual AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Percentual" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 10.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 3.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ped-item-segmentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-cadsim _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ped-item-segmentos.cod-segmento FORMAT "X(4)":U
      ped-item-segmentos.val-percentual FORMAT ">>9.99":U WIDTH 15.29
  ENABLE
      ped-item-segmentos.val-percentual
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 28 BY 7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-nr-pedcli-tela AT ROW 1.75 COL 19 COLON-ALIGNED WIDGET-ID 18
     c-it-codigo-tela AT ROW 3 COL 19 COLON-ALIGNED WIDGET-ID 22
     c-cod-segmento AT ROW 4.75 COL 19 COLON-ALIGNED WIDGET-ID 2
     c-descricao AT ROW 4.75 COL 29 NO-LABEL WIDGET-ID 10
     de-percentual AT ROW 6 COL 11 WIDGET-ID 8
     bt-incluir AT ROW 8 COL 21 HELP
          "Incluir Novo Registro" WIDGET-ID 12
     BROWSE-2 AT ROW 8 COL 32 WIDGET-ID 200
     bt-localizar AT ROW 10 COL 21 HELP
          "Localizar Registro" WIDGET-ID 14
     bt-excluir AT ROW 12 COL 21 HELP
          "Excluir Registro Corrente" WIDGET-ID 16
     bt-ok AT ROW 15.71 COL 3
     bt-ajuda AT ROW 15.71 COL 69
     rt-button AT ROW 15.5 COL 2
     RECT-1 AT ROW 4.5 COL 4 WIDGET-ID 24
     RECT-2 AT ROW 1.5 COL 4 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "ESPDP068 - Clientes com Parcela Separada ST"
         HEIGHT             = 16.38
         WIDTH              = 79.43
         MAX-HEIGHT         = 30.04
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 30.04
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-2 bt-incluir f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-cad
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-it-codigo-tela IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-pedcli-tela IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-percentual IN FRAME f-cad
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "mgesp.ped-item-segmentos"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.ped-item-segmentos.nr-pedcli = c-nr-pedcli
 AND mgesp.ped-item-segmentos.nome-abrev = c-nome-abrev
 AND mgesp.ped-item-segmentos.nr-sequencia = i-nr-sequencia
 AND mgesp.ped-item-segmentos.it-codigo = c-it-codigo"
     _FldNameList[1]   = mgesp.ped-item-segmentos.cod-segmento
     _FldNameList[2]   > mgesp.ped-item-segmentos.val-percentual
"ped-item-segmentos.val-percentual" ? ? "decimal" ? ? ? ? ? ? yes ? no no "15.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* ESPDP068 - Clientes com Parcela Separada ST */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* ESPDP068 - Clientes com Parcela Separada ST */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir w-cadsim
ON CHOOSE OF bt-excluir IN FRAME f-cad /* Button 1 */
DO:
  MESSAGE "Confirma Elimina‡Æo do Registro? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                         TITLE "" UPDATE l-resposta AS LOGICAL.
  IF l-resposta = YES THEN do:
      FIND b-ped-item-segmentos
          WHERE ROWID(b-ped-item-segmentos) = ROWID(ped-item-segmentos)
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL b-ped-item-segmentos THEN DO:
          DELETE b-ped-item-segmentos.
          MESSAGE "Registro Eliminado"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
              {&OPEN-BROWSERS-IN-QUERY-f-cad}
              VIEW w-cadsim.

      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-cadsim
ON CHOOSE OF bt-incluir IN FRAME f-cad /* Incluir */
DO:
  IF substring(fam-com-item.fm-cod-com,1,1) = "" OR
     substring(fam-com-item.fm-cod-com,2,1) = "" OR
      substring(fam-com-item.fm-cod-com,3,1) = "" OR
      substring(fam-com-item.fm-cod-com,4,1) = "" THEN DO:
  
     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Informe o campo Segmento completo":U).
     ASSIGN c-cod-segmento:SCREEN-VALUE = "0000".
     RETURN NO-APPLY.
  END.


    FIND FIRST fam-com-item
         WHERE substring(fam-com-item.fm-cod-com,1,4) = c-cod-segmento:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    
    
  IF NOT AVAIL fam-com-item THEN DO:
     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Segmento":U).
     ASSIGN c-cod-segmento:SCREEN-VALUE = "0000".
     RETURN NO-APPLY.
  END.
  ELSE DO:
      FIND ped-item-segmentos
           WHERE ped-item-segmentos.nr-pedcli  = c-nr-pedcli
             AND ped-item-segmentos.nome-abrev = c-nome-abrev
             AND ped-item-segmentos.nr-sequencia = i-nr-sequencia
             AND ped-item-segmentos.it-codigo    = c-it-codigo
             AND ped-item-segmentos.cod-segmento = c-cod-segmento:SCREEN-VALUE
           NO-LOCK NO-ERROR.
      IF NOT AVAIL ped-item-segmentos THEN DO:
          CREATE ped-item-segmentos.
          ASSIGN ped-item-segmentos.nr-pedcli  = c-nr-pedcli                    
                 ped-item-segmentos.nome-abrev = c-nome-abrev                   
                 ped-item-segmentos.nr-sequencia = i-nr-sequencia               
                 ped-item-segmentos.it-codigo    = c-it-codigo                  
                 ped-item-segmentos.cod-segmento = c-cod-segmento:SCREEN-VALUE 
                 ped-item-segmentos.val-percentual = DEC(de-percentual:SCREEN-VALUE) .
          {&OPEN-BROWSERS-IN-QUERY-f-cad}
          VIEW w-cadsim.
      END.
      ELSE DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Registro ja cadastrado com este Segmento ").

             RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-localizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-localizar w-cadsim
ON CHOOSE OF bt-localizar IN FRAME f-cad /* Localizar */
DO:
      FIND b-ped-item-segmentos
           WHERE b-ped-item-segmentos.nr-pedcli  = c-nr-pedcli
             AND b-ped-item-segmentos.nome-abrev = c-nome-abrev
             AND b-ped-item-segmentos.nr-sequencia = i-nr-sequencia
             AND b-ped-item-segmentos.it-codigo    = c-it-codigo
             AND b-ped-item-segmentos.cod-segmento = c-cod-segmento:SCREEN-VALUE
           NO-LOCK NO-ERROR.
      IF NOT AVAIL b-ped-item-segmentos THEN DO:
        
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Registro NÆo Cadastrado Com Este Segmento " + c-cod-segmento:SCREEN-VALUE).

             RETURN NO-APPLY.

      END.
      ELSE DO:
          REPOSITION browse-2 TO ROWID(rowid(b-ped-item-segmentos)).
          
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Sair */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-segmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-segmento w-cadsim
ON F5 OF c-cod-segmento IN FRAME f-cad /* Segmento */
DO:


    {method/ZoomFields.i &ProgramZoom="eszoom/z04es513.w"
                         &FieldZoom1="fm-cod-com"
                         &FieldScreen1="c-cod-segmento"
                         &Frame1="f-cad"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-descricao"
                         &Frame2="f-cad"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-segmento w-cadsim
ON LEAVE OF c-cod-segmento IN FRAME f-cad /* Segmento */
DO:
    FIND FIRST fam-com-item
         WHERE substring(fam-com-item.fm-cod-com,1,4) = c-cod-segmento:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    
  IF c-cod-segmento:SCREEN-VALUE <> "0000" THEN
      IF NOT AVAIL fam-com-item THEN DO:
         RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Segmento":U).
         ASSIGN c-cod-segmento:SCREEN-VALUE = "0000".
      END.
      ELSE DO:
          ASSIGN c-descricao:SCREEN-VALUE = fam-com-item.descricao.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-segmento w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-cod-segmento IN FRAME f-cad /* Segmento */
DO:
     APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields w-cadsim 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY c-nr-pedcli-tela c-it-codigo-tela c-cod-segmento c-descricao 
          de-percentual 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 RECT-2 c-cod-segmento de-percentual bt-incluir 
         BROWSE-2 bt-localizar bt-excluir bt-ok bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESPDP076" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find first ped-item-segmentos no-lock no-error. 
  if not avail ped-item-segmentos
  then RUN notify IN THIS-PROCEDURE ('add-record':U).
  else RUN new-state ('update-begin':U).

  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}
ASSIGN c-it-codigo-tela:SCREEN-VALUE IN FRAME f-cad = c-it-codigo
       c-nr-pedcli-tela:SCREEN-VALUE IN FRAME f-cad = c-nr-pedcli.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ped-item-segmentos"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

