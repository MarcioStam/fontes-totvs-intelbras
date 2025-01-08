&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

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

DEF NEW GLOBAL SHARED VAR v_rec_centro-custo AS RECID NO-UNDO.
def new global shared var v_rec_unid_negoc   as RECID format ">>>>>>9":U no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

DEF TEMP-TABLE tt-bem-pat-nf LIKE INT_bem_pat_nf
    FIELD nat-oper-item      AS CHAR
    FIELD desc-nat-oper-item AS CHAR
    FIELD desc-emitente      AS CHAR
    /*Retorno*/
    FIELD da-remessa         AS DATE FORMAT "99/99/9999"
    FIELD c-tipo             AS CHAR
    FIELD da-retorno         AS DATE FORMAT "99/99/9999"
    FIELD cod-estab-retorno  AS CHAR
    FIELD serie-docto        AS CHAR 
    FIELD nro-docto          AS CHAR
    FIELD nat-operacao-ret   AS CHAR
    FIELD r-rowid            AS ROWID .

DEF BUFFER b-bem-pat FOR bem_pat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brNotas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-bem-pat-nf

/* Definitions for BROWSE brNotas                                       */
&Scoped-define FIELDS-IN-QUERY-brNotas tt-bem-pat-nf.cod-estabel tt-bem-pat-nf.serie tt-bem-pat-nf.nr-nota-fis tt-bem-pat-nf.nr-seq-fat tt-bem-pat-nf.it-codigo tt-bem-pat-nf.nat-oper-item tt-bem-pat-nf.desc-nat-oper-item tt-bem-pat-nf.cod-emitente tt-bem-pat-nf.desc-emitente tt-bem-pat-nf.dt-vigencia tt-bem-pat-nf.da-remessa tt-bem-pat-nf.da-retorno tt-bem-pat-nf.cod-estab-retorno tt-bem-pat-nf.serie-docto tt-bem-pat-nf.nro-docto tt-bem-pat-nf.nat-operacao-ret   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNotas   
&Scoped-define SELF-NAME brNotas
&Scoped-define QUERY-STRING-brNotas FOR EACH tt-bem-pat-nf
&Scoped-define OPEN-QUERY-brNotas OPEN QUERY {&SELF-NAME} FOR EACH tt-bem-pat-nf.
&Scoped-define TABLES-IN-QUERY-brNotas tt-bem-pat-nf
&Scoped-define FIRST-TABLE-IN-QUERY-brNotas tt-bem-pat-nf


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brNotas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-4 RECT-6 cclass-fiscal ~
nr-serie-bem val-icms c-ind-terceiro nf-emprestimo dat-emprestimo bt_zoo_un ~
cod_unid_negoc bt_zoo_cc cod_ccusto bt-ok bt_inventario 
&Scoped-Define DISPLAYED-OBJECTS cclass-fiscal nr-serie-bem val-icms ~
c-ind-terceiro nf-emprestimo dat-emprestimo cod_unid_negoc cod_ccusto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt_inventario 
     LABEL "Invent†rio" 
     SIZE 12 BY 1.

DEFINE BUTTON bt_zoo_cc 
     IMAGE-UP FILE "image/im-zoo":U
     LABEL "bt_zoo_un 2" 
     SIZE 4 BY 1.

DEFINE BUTTON bt_zoo_un 
     IMAGE-UP FILE "image/im-zoo":U
     LABEL "Button 2" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-ind-terceiro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Indicador Terceiro" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","EmprÇstimo","Comodato","Conserto","EmprÇstimo Colaborador" 
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cclass-fiscal AS CHARACTER FORMAT "9999.99.99" 
     LABEL "Classificaá∆o Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE cod_ccusto AS CHARACTER FORMAT "x(5)" 
     LABEL "Centro de Custo" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE VARIABLE cod_unid_negoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Un Proj" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE dat-emprestimo AS DATE FORMAT "99/99/9999" 
     LABEL "Data EmprÇstimo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nf-emprestimo AS CHARACTER FORMAT "x(15)" 
     LABEL "NF EmprÇstimo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE nr-serie-bem AS CHARACTER FORMAT "x(30)" 
     LABEL "N£mero de SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE val-icms AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Valor ICMS" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 7.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 8.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103.14 BY 1.38
     BGCOLOR 7 .

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 15 BY 1.

DEFINE BUTTON btIncluir 
     LABEL "Incluir" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-bem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Bem Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 15.29 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-conta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-data-aquis AS DATE FORMAT "99/99/9999":U 
     LABEL "Aquisiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-seq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brNotas FOR 
      tt-bem-pat-nf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNotas w-cadsim _FREEFORM
  QUERY brNotas DISPLAY
      tt-bem-pat-nf.cod-estabel         column-label "Est"
tt-bem-pat-nf.serie               column-label "Ser"
tt-bem-pat-nf.nr-nota-fis         column-label "Nr Nf" WIDTH 7
tt-bem-pat-nf.nr-seq-fat          column-label "Seq"
tt-bem-pat-nf.it-codigo           column-label "Item"  WIDTH 7
tt-bem-pat-nf.nat-oper-item       column-label "Nat item"
tt-bem-pat-nf.desc-nat-oper-item  column-label "Desc Nat item"
tt-bem-pat-nf.cod-emitente        column-label "Destinat†rio" WIDTH 9
tt-bem-pat-nf.desc-emitente       column-label "Nome"         WIDTH 17
tt-bem-pat-nf.dt-vigencia         column-label "Vigància"
tt-bem-pat-nf.da-remessa           COLUMN-LABEL "Remessa" 
tt-bem-pat-nf.da-retorno           column-label "Retorno"
tt-bem-pat-nf.cod-estab-retorno    column-label "Est Ret"
tt-bem-pat-nf.serie-docto          column-label "Ser Ret"
tt-bem-pat-nf.nro-docto            column-label "Nr nf Ret"
tt-bem-pat-nf.nat-operacao-ret     column-label "Nat Ret"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100.72 BY 4.17
         FONT 1
         TITLE "Notas" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     cclass-fiscal AT ROW 9.75 COL 22 COLON-ALIGNED WIDGET-ID 4
     nr-serie-bem AT ROW 10.75 COL 22 COLON-ALIGNED WIDGET-ID 8
     val-icms AT ROW 11.75 COL 22 COLON-ALIGNED WIDGET-ID 10
     c-ind-terceiro AT ROW 12.75 COL 22 COLON-ALIGNED WIDGET-ID 36
     nf-emprestimo AT ROW 13.88 COL 22 COLON-ALIGNED WIDGET-ID 14
     dat-emprestimo AT ROW 13.92 COL 57.86 COLON-ALIGNED WIDGET-ID 16
     bt_zoo_un AT ROW 14.83 COL 30 WIDGET-ID 20
     cod_unid_negoc AT ROW 14.88 COL 22 COLON-ALIGNED WIDGET-ID 18
     bt_zoo_cc AT ROW 14.88 COL 67.72 WIDGET-ID 24
     cod_ccusto AT ROW 14.92 COL 57.86 COLON-ALIGNED WIDGET-ID 22
     bt-ok AT ROW 16.79 COL 2.57
     bt_inventario AT ROW 16.79 COL 13.43 WIDGET-ID 2
     rt-button AT ROW 16.58 COL 1.86
     RECT-4 AT ROW 9.5 COL 2 WIDGET-ID 26
     RECT-6 AT ROW 1 COL 2 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104.72 BY 17.25 WIDGET-ID 100.

DEFINE FRAME fpage0
     fi-conta AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 6
     fi-estab AT ROW 1.25 COL 56.29 COLON-ALIGNED WIDGET-ID 12
     fi-data-aquis AT ROW 1.25 COL 80.29 COLON-ALIGNED WIDGET-ID 16
     fi-bem AT ROW 2.25 COL 17 COLON-ALIGNED WIDGET-ID 8
     fi-seq AT ROW 2.25 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-desc AT ROW 2.25 COL 38.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     brNotas AT ROW 3.33 COL 1 WIDGET-ID 200
     btIncluir AT ROW 7.63 COL 37 WIDGET-ID 2
     btExcluir AT ROW 7.63 COL 52.29 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 1.17
         SIZE 101 BY 7.75
         FONT 1 WIDGET-ID 300.


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
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 17.21
         WIDTH              = 104.86
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
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
/* REPARENT FRAME */
ASSIGN FRAME fpage0:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       cod_ccusto:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FRAME fpage0
                                                                        */
/* BROWSE-TAB brNotas fi-desc fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNotas
/* Query rebuild information for BROWSE brNotas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-bem-pat-nf.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNotas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  RUN notify ('update-record':U).


  IF cod_ccusto:screen-value in FRAME f-cad <> "" THEN DO:
     FIND emscad.ccusto
          WHERE ccusto.cod_empresa  = v_cod_empres_usuar
          AND   ccusto.cod_plano_cc = "padrao"
          AND   ccusto.cod_ccusto   = cod_ccusto:screen-value in frame f-cad
          NO-LOCK NO-ERROR.

      IF NOT AVAIL ccusto THEN DO:
         MESSAGE "Centro de Custos n∆o cadastrada"  VIEW-AS ALERT-BOX.
         apply "entry" TO cod_ccusto IN frame f-cad.
         RETURN NO-APPLY.
      END.    
  END.
  IF  cod_unid_negoc:SCREEN-VALUE IN frame f-cad <> "" THEN DO:
      FIND unid_negoc
          WHERE unid_negoc.cod_unid_negoc = cod_unid_negoc:SCREEN-VALUE IN frame f-cad
          NO-LOCK NO-ERROR.

      IF NOT AVAIL unid_negoc THEN DO:
         MESSAGE "Unidade de Neg¢cio n∆o cadastrada" VIEW-AS ALERT-BOX.
         apply "entry" TO cod_unid_negoc IN frame f-cad.
         RETURN NO-APPLY.
      END.
  END.

   IF  AVAIL int-bem-pat THEN
       ASSIGN int-bem-pat.nr-serie-bem   = nr-serie-bem   :screen-value in frame f-cad
              int-bem-pat.val-icms       = dec(val-icms   :screen-value in frame f-cad)
              int-bem-pat.ind-terceiro   = c-ind-terceiro:SCREEN-VALUE  in frame f-cad 
              int-bem-pat.nf-emprestimo  = nf-emprestimo  :screen-value in frame f-cad
              int-bem-pat.dat-emprestimo = date(dat-emprestimo :screen-value in frame f-cad)
              int-bem-pat.cod_unid_negoc = cod_unid_negoc :screen-value in frame f-cad
              int-bem-pat.cod_ccusto     = cod_ccusto     :screen-value in frame f-cad.


    MESSAGE  "int-bem-pat.nr-serie-bem   : " int-bem-pat.nr-serie-bem    skip
             "int-bem-pat.val-icms       : " int-bem-pat.val-icms        skip
             "int-bem-pat.ind-terceiro   : " int-bem-pat.ind-terceiro    skip
             "int-bem-pat.nf-emprestimo  : " int-bem-pat.nf-emprestimo   skip
             "int-bem-pat.dat-emprestimo : " int-bem-pat.dat-emprestimo  skip
             "int-bem-pat.cod_unid_negoc : " int-bem-pat.cod_unid_negoc  skip
             "int-bem-pat.cod_ccusto     : " int-bem-pat.cod_ccusto    

        VIEW-AS ALERT-BOX INFO BUTTONS OK.





  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir w-cadsim
ON CHOOSE OF btExcluir IN FRAME fpage0 /* Excluir */
DO:
  
    IF  AVAIL tt-bem-pat-nf THEN DO TRANS:
        
        run utp/ut-msgs.p (input "show", input 27100, input "Confirma eliminaá∆o?").
        IF  RETURN-VALUE <> "YES" THEN 
            RETURN NO-APPLY.

        FIND INT_bem_pat_nf EXCLUSIVE-LOCK
            WHERE ROWID(INT_bem_pat_nf) = tt-bem-pat-nf.r-rowid NO-ERROR.

        IF  AVAIL INT_bem_pat_nf THEN DO:
        
            DELETE INT_bem_pat_nf.
            DELETE tt-bem-pat-nf.

            RUN pi-carrega.
        END.

    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir w-cadsim
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
  /*  IF SESSION:SET-WAIT-STATE("general") THEN.*/

     run epc/fas211aa_epc-inclui.w.
     RUN  pi-carrega.
    /*IF SESSION:SET-WAIT-STATE("") THEN.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt_inventario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_inventario w-cadsim
ON CHOOSE OF bt_inventario IN FRAME f-cad /* Invent†rio */
DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    run epc/fas211aa2_epc.p.
    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_zoo_cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_zoo_cc w-cadsim
ON CHOOSE OF bt_zoo_cc IN FRAME f-cad /* bt_zoo_un 2 */
DO:
  
    run esp/es0512kb-2.p.
    if  v_rec_centro-custo <> ? then do:

        find emscad.ccusto where recid(emscad.ccusto) = v_rec_centro-custo no-lock no-error.

        ASSIGN cod_ccusto:screen-value in frame f-cad = string(emscad.ccusto.cod_ccusto).
    
    end.

    apply "entry" TO cod_ccusto IN frame f-cad.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_zoo_un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_zoo_un w-cadsim
ON CHOOSE OF bt_zoo_un IN FRAME f-cad /* Button 2 */
DO:
  
    run esp/es0512ke.p.
    
    if  v_rec_unid_negoc <> ? then do:

        find unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.

        assign cod_unid_negoc:screen-value in frame f-cad = string(unid_negoc.cod_unid_negoc, '999').
    
    end.

    apply "entry" TO cod_unid_negoc IN frame f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brNotas
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
  DISPLAY cclass-fiscal nr-serie-bem val-icms c-ind-terceiro nf-emprestimo 
          dat-emprestimo cod_unid_negoc cod_ccusto 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-4 RECT-6 cclass-fiscal nr-serie-bem val-icms 
         c-ind-terceiro nf-emprestimo dat-emprestimo bt_zoo_un cod_unid_negoc 
         bt_zoo_cc cod_ccusto bt-ok bt_inventario 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  DISPLAY fi-conta fi-estab fi-data-aquis fi-bem fi-seq fi-desc 
      WITH FRAME fpage0 IN WINDOW w-cadsim.
  ENABLE fi-conta fi-estab fi-data-aquis fi-bem fi-seq fi-desc brNotas 
         btIncluir btExcluir 
      WITH FRAME fpage0 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
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
    
    {utp/ut9000.i "XX9999" "9.99.99.999"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    
    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    
    RUN pi-carrega.

    {include/i-inifld.i}

    FIND bem_pat NO-LOCK WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-ERROR.


    IF  NOT AVAIL bem_pat THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Bem Patrimonial n∆o Localizado !").
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END. /* IF  NOT AVAIL bem_pat THEN DO: */

    DO WITH FRAME f-cad:
        FIND int-bem-pat OF bem_pat EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL int-bem-pat THEN DO:
             CREATE int-bem-pat.
             ASSIGN int-bem-pat.cod_empresa     = bem_pat.cod_empresa    
                    int-bem-pat.cod_cta_pat     = bem_pat.cod_cta_pat    
                    int-bem-pat.num_bem_pat     = bem_pat.num_bem_pat    
                    int-bem-pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat.

        END.

        RUN epc/fas211aa3_epc.p (OUTPUT cclass-fiscal).

        IF  AVAIL int-bem-pat THEN DO:
            ASSIGN  cclass-fiscal :screen-value = string(int-bem-pat.class-fiscal, "99999999")
                    nr-serie-bem  :screen-value = int-bem-pat.nr-serie-bem  
                    val-icms      :screen-value = string(int-bem-pat.val-icms)
                    c-ind-terceiro:screen-value = int-bem-pat.ind-terceiro  
                    nf-emprestimo :screen-value = int-bem-pat.nf-emprestimo 
                    dat-emprestimo:screen-value = STRING(int-bem-pat.dat-emprestimo)
                    cod_unid_negoc:screen-value = int-bem-pat.cod_unid_negoc
                    cod_ccusto    :screen-value = int-bem-pat.cod_ccusto.   
            IF  cclass-fiscal:SCREEN-VALUE = "" THEN 
                ASSIGN cclass-fiscal:SCREEN-VALUE IN FRAME f-cad = '00000000'.
                
        END.
    END.

    ASSIGN cclass-fiscal:READ-ONLY = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-cadsim 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME fpage0:
      FIND b-bem-pat
          WHERE RECID(b-bem-pat) = v_rec_bem_pat_epc NO-LOCK NO-ERROR.
    
      IF  AVAIL b-bem-pat THEN DO:
           ASSIGN fi-conta:SCREEN-VALUE      = string(b-bem-pat.cod_cta_pat)
                  fi-bem:SCREEN-VALUE        = string(b-bem-pat.num_bem_pat)
                  fi-seq:SCREEN-VALUE        = string(b-bem-pat.num_seq_bem_pat)
                  fi-desc:SCREEN-VALUE       = b-bem-pat.des_bem_pat
                  fi-data-aquis:SCREEN-VALUE = string(b-bem-pat.dat_aquis_bem_pat)
                  fi-estab:SCREEN-VALUE      = b-bem-pat.cod_estab.

           EMPTY TEMP-TABLE tt-bem-pat-nf.    
           FOR EACH INT_bem_pat_nf NO-LOCK
               WHERE INT_bem_pat_nf.cod_cta_pat = b-bem-pat.cod_cta_pat
                 AND INT_bem_pat_nf.num_bem_pat = b-bem-pat.num_bem_pat
                 AND INT_bem_pat_nf.num_seq_bem_pat = b-bem-pat.num_seq_bem_pat:

               CREATE tt-bem-pat-nf.
               BUFFER-COPY INT_bem_pat_nf TO tt-bem-pat-nf.
               ASSIGN tt-bem-pat-nf.r-rowid = ROWID(INT_bem_pat_nf).

               /*Buscar retorno*/
               FOR EACH nota-fiscal NO-LOCK
                   WHERE nota-fiscal.cod-estabel = tt-bem-pat-nf.cod-estabel
                     AND nota-fiscal.serie       = tt-bem-pat-nf.serie
                     AND nota-fiscal.nr-nota-fis = tt-bem-pat-nf.nr-nota-fis,
                    EACH it-nota-fisc OF nota-fiscal NO-LOCK 
                    WHERE it-nota-fisc.nr-seq-fat = tt-bem-pat-nf.nr-seq-fat
                      AND it-nota-fisc.it-codigo  = tt-bem-pat-nf.it-codigo:

                   FIND emitente NO-LOCK
                       WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                   FIND natur-oper NO-LOCK
                       WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
                   
                   ASSIGN tt-bem-pat-nf.nat-oper-item      = it-nota-fisc.nat-operacao
                          tt-bem-pat-nf.desc-nat-oper-item = natur-oper.denominacao
                          tt-bem-pat-nf.desc-emitente      = nome-emit.

                   IF nota-fiscal.dt-saida <> ? THEN
                       ASSIGN tt-bem-pat-nf.da-remessa = nota-fiscal.dt-saida.
                   ELSE 
                       ASSIGN tt-bem-pat-nf.da-remessa = tt-bem-pat-nf.dt-emis-nota.

                   FOR EACH saldo-terc NO-LOCK USE-INDEX documento 
                       WHERE saldo-terc.serie-docto  = it-nota-fisc.serie
                         AND saldo-terc.nro-docto    = it-nota-fisc.nr-nota-fis
                         AND saldo-terc.cod-emitente = nota-fiscal.cod-emitente
                         AND saldo-terc.nat-operacao = it-nota-fisc.nat-operacao
                         AND saldo-terc.it-codigo    = it-nota-fisc.it-codigo
                         AND saldo-terc.cod-refer    = it-nota-fisc.cod-refer
                         AND saldo-terc.sequencia    = it-nota-fisc.nr-seq-fat:
                       FOR EACH componente NO-LOCK
                          WHERE componente.cod-emitente = saldo-terc.cod-emitente
                            AND componente.it-codigo    = saldo-terc.it-codigo
                            AND componente.cod-refer    = saldo-terc.cod-refer
                            AND (  /* ** Envio ***/
                                   (componente.serie-docto  = saldo-terc.serie-docto  AND
                                    componente.nro-docto    = saldo-terc.nro-docto    AND
                                    componente.nat-operacao = saldo-terc.nat-operacao AND
                                    componente.sequencia    = saldo-terc.sequencia)
                                 OR /* ** Retorno ***/
                                   (componente.serie-comp = saldo-terc.serie-docto   AND
                                    componente.nro-comp   = saldo-terc.nro-docto     AND
                                    componente.nat-comp   = saldo-terc.nat-operacao  AND
                                    componente.seq-comp   = saldo-terc.sequencia)
                                ):
                  
                           IF  componente.componente = 2 THEN /**/
                               ASSIGN tt-bem-pat-nf.c-tipo            = "Retorno"
                                      tt-bem-pat-nf.da-retorno        = componente.dt-retorno
                                      tt-bem-pat-nf.cod-estab-retorno = saldo-terc.cod-estabel
                                      tt-bem-pat-nf.serie-docto       = componente.serie-docto
                                      tt-bem-pat-nf.nro-docto         = componente.nro-docto
                                      tt-bem-pat-nf.nat-operacao-ret  = componente.nat-operacao.
                       END.
                   END.
               END.

           END.

          {&OPEN-QUERY-brNotas}

      END.  
  END.

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
  {src/adm/template/snd-list.i "tt-bem-pat-nf"}

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

