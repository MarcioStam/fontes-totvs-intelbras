&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable c-lista-valor as character init '':U no-undo.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren     AS CHAR  NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_int_solic_transf AS RECID NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_nr_solic_ini    LIKE int_solic_transf.num_solicitacao NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nr_solic_fim    LIKE int_solic_transf.num_solicitacao NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_cta_pat_ini LIKE int_solic_transf.cod_cta_pat     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_cta_pat_fim LIKE int_solic_transf.cod_cta_pat     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_dat_transf_ini  LIKE int_solic_transf.dat_transf      NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_dat_transf_fim  LIKE int_solic_transf.dat_transf      NO-UNDO.

DEF VAR v_usuar_aprov LIKE v_cod_usuar_corren NO-UNDO.

def var v_rec_int_solic_transf
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def var v_log_method
    as logical
    format "Sim/N’o"
    initial yes
    no-undo.

def var v_num_row
    as integer
    format ">>>,>>9":U
    no-undo.

DEF TEMP-TABLE tt_int_solic_transf NO-UNDO
    LIKE int_solic_transf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int_solic_transf

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 int_solic_transf.num_solicitacao int_solic_transf.cod_usuar_solic int_solic_transf.dat_transf int_solic_transf.cod_cta_pat int_solic_transf.num_bem_pat int_solic_transf.num_seq_bem_pat int_solic_transf.cod_ccusto int_solic_transf.cod_estab int_solic_transf.cod_localiz int_solic_transf.cod_motiv_desmob int_solic_transf.cod_unid_negoc int_solic_transf.nr_nota_transf   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6   
&Scoped-define SELF-NAME BROWSE-6
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH int_solic_transf                             WHERE v_usuar_aprov                     = "*"                             AND   int_solic_transf.num_solicitacao >= v_nr_solic_ini                             AND   int_solic_transf.num_solicitacao <= v_nr_solic_fim                             AND   int_solic_transf.cod_cta_pat     >= v_cod_cta_pat_ini                             AND   int_solic_transf.cod_cta_pat     <= v_cod_cta_pat_fim                             AND   int_solic_transf.dat_transf      >= v_dat_transf_ini                             AND   int_solic_transf.dat_transf      <= v_dat_transf_fim                             AND   int_solic_transf.ind_aprovac      = "Pendente"
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY {&SELF-NAME} FOR EACH int_solic_transf                             WHERE v_usuar_aprov                     = "*"                             AND   int_solic_transf.num_solicitacao >= v_nr_solic_ini                             AND   int_solic_transf.num_solicitacao <= v_nr_solic_fim                             AND   int_solic_transf.cod_cta_pat     >= v_cod_cta_pat_ini                             AND   int_solic_transf.cod_cta_pat     <= v_cod_cta_pat_fim                             AND   int_solic_transf.dat_transf      >= v_dat_transf_ini                             AND   int_solic_transf.dat_transf      <= v_dat_transf_fim                             AND   int_solic_transf.ind_aprovac      = "Pendente".
&Scoped-define TABLES-IN-QUERY-BROWSE-6 int_solic_transf
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 int_solic_transf


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-6 bt_aprova bt_reprova bt_todos ~
bt_nenhum 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS
><EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_esfas017-b01 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt_aprova 
     LABEL "Aprova" 
     SIZE 12 BY 1.

DEFINE BUTTON bt_nenhum 
     IMAGE-UP FILE "IMAGE/im-ran_n.bmp":U
     LABEL "Desmarca todas" 
     SIZE 4 BY 1 TOOLTIP "Desmarca todas as solicita‡äes".

DEFINE BUTTON bt_reprova 
     LABEL "Reprova" 
     SIZE 12 BY 1.

DEFINE BUTTON bt_todos 
     IMAGE-UP FILE "IMAGE/im-ran_a.bmp":U
     LABEL "Marcar todos" 
     SIZE 4 BY 1 TOOLTIP "Seleciona todas as solicita‡äes".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      int_solic_transf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 B-table-Win _FREEFORM
  QUERY BROWSE-6 DISPLAY
      int_solic_transf.num_solicitacao    column-label "Nr Solic"
      int_solic_transf.cod_usuar_solic    column-label "Usuar Solic"
      int_solic_transf.dat_transf         column-label "Dt Transf"
      int_solic_transf.cod_cta_pat        column-label "Conta Pat"
      int_solic_transf.num_bem_pat        column-label "Bem"
      int_solic_transf.num_seq_bem_pat    column-label "Seq Bem"
      int_solic_transf.cod_ccusto         column-label "Centro Custo"
      int_solic_transf.cod_estab          column-label "Estab"
      int_solic_transf.cod_localiz        column-label "Localiza‡Æo"
      int_solic_transf.cod_motiv_desmob   column-label "Motiv Desmob"
      int_solic_transf.cod_unid_negoc     column-label "UN"
      int_solic_transf.nr_nota_transf     column-label "NF Transf"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82 BY 11.75 FIT-LAST-COLUMN TOOLTIP "Clique sobre uma linha ou selecione v rias arrastando sobre as linhas".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-6 AT ROW 1 COL 1 WIDGET-ID 200
     bt_aprova AT ROW 13 COL 1
     bt_reprova AT ROW 13 COL 14 WIDGET-ID 2
     bt_todos AT ROW 13 COL 73 WIDGET-ID 4
     bt_nenhum AT ROW 13 COL 78 WIDGET-ID 6
     SPACE(1.00) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 13.25
         WIDTH              = 82.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-brwzoo.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB BROWSE-6 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH int_solic_transf
                            WHERE v_usuar_aprov                     = "*"
                            AND   int_solic_transf.num_solicitacao >= v_nr_solic_ini
                            AND   int_solic_transf.num_solicitacao <= v_nr_solic_fim
                            AND   int_solic_transf.cod_cta_pat     >= v_cod_cta_pat_ini
                            AND   int_solic_transf.cod_cta_pat     <= v_cod_cta_pat_fim
                            AND   int_solic_transf.dat_transf      >= v_dat_transf_ini
                            AND   int_solic_transf.dat_transf      <= v_dat_transf_fim
                            AND   int_solic_transf.ind_aprovac      = "Pendente".
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 B-table-Win
ON MOUSE-EXTEND-CLICK OF BROWSE-6 IN FRAME F-Main
DO:
    IF  AVAIL int_solic_transf THEN DO:

        /*
        FIND FIRST tt_int_solic_transf
            WHERE tt_int_solic_transf.num_solicitacao = int_solic_transf.num_solicitacao
            AND   tt_int_solic_transf.cod_cta_pat     = int_solic_transf.cod_cta_pat    
            AND   tt_int_solic_transf.num_bem_pat     = int_solic_transf.num_bem_pat    
            AND   tt_int_solic_transf.num_seq_bem_pat = int_solic_transf.num_seq_bem_pat
            NO-LOCK NO-ERROR.

        IF  NOT AVAIL tt_int_solic_transf THEN DO:
            CREATE tt_int_solic_transf.
            BUFFER-COPY int_solic_transf TO tt_int_solic_transf.
        END.
        */
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 B-table-Win
ON ROW-ENTRY OF BROWSE-6 IN FRAME F-Main
DO:

   IF  AVAIL int_solic_transf THEN DO:

       FIND FIRST int-centro-custo
           WHERE int-centro-custo.cod-estabel    = int_solic_transf.cod_estab
           AND   int-centro-custo.cc-codigo      = int_solic_transf.cod_ccusto
           AND   int-centro-custo.cod-unid-negoc = int_solic_transf.cod_unid_negoc NO-LOCK NO-ERROR.

       IF  AVAIL int-centro-custo THEN DO:
           ASSIGN bt_aprova:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
                  bt_reprova:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                  v_rec_int_solic_transf                      = RECID(int_solic_transf).
       END.
       ELSE
           ASSIGN bt_aprova:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
                  bt_reprova:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  v_rec_int_solic_transf                      = ?.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 B-table-Win
ON VALUE-CHANGED OF BROWSE-6 IN FRAME F-Main
DO:

    IF  AVAIL int_solic_transf THEN DO:

        FIND FIRST int-centro-custo
            WHERE int-centro-custo.cod-estabel    = int_solic_transf.cod_estab
            AND   int-centro-custo.cc-codigo      = int_solic_transf.cod_ccusto
            AND   int-centro-custo.cod-unid-negoc = int_solic_transf.cod_unid_negoc NO-LOCK NO-ERROR.

        IF  AVAIL int-centro-custo THEN
            ASSIGN bt_aprova:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
                   bt_reprova:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN bt_aprova:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
                   bt_reprova:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_aprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_aprova B-table-Win
ON CHOOSE OF bt_aprova IN FRAME F-Main /* Aprova */
DO:
    EMPTY TEMP-TABLE tt_int_solic_transf.

    browse_block:
    do v_num_row = 1 to browse BROWSE-6:num-selected-rows :
        assign v_log_method = browse BROWSE-6:fetch-selected-row(v_num_row).
        
        if  avail int_solic_transf and v_log_method = TRUE then do:
            get current BROWSE-6 no-lock.

            assign v_rec_int_solic_transf = recid(int_solic_transf).

            find int_solic_transf NO-LOCK 
                where recid(int_solic_transf) = v_rec_int_solic_transf no-error.

            if  avail int_solic_transf then do:
                FIND FIRST tt_int_solic_transf
                    WHERE tt_int_solic_transf.num_solicitacao = int_solic_transf.num_solicitacao
                    AND   tt_int_solic_transf.cod_cta_pat     = int_solic_transf.cod_cta_pat    
                    AND   tt_int_solic_transf.num_bem_pat     = int_solic_transf.num_bem_pat    
                    AND   tt_int_solic_transf.num_seq_bem_pat = int_solic_transf.num_seq_bem_pat
                    NO-LOCK NO-ERROR.

                IF  NOT AVAIL tt_int_solic_transf THEN DO:
                    CREATE tt_int_solic_transf.
                    BUFFER-COPY int_solic_transf TO tt_int_solic_transf.
                END.
            end.
        end.
    end.

    RUN esp\fas\esfas017a.w (INPUT TABLE tt_int_solic_transf,
                             INPUT "A").
    
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    apply 'value-changed':U to {&browse-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_nenhum B-table-Win
ON CHOOSE OF bt_nenhum IN FRAME F-Main /* Desmarca todas */
DO:
    if  can-find( first INT_solic_transf )
    and BROWSE-6:num-selected-rows > 0 then do:
        assign v_log_method = browse BROWSE-6:deselect-rows().
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_reprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_reprova B-table-Win
ON CHOOSE OF bt_reprova IN FRAME F-Main /* Reprova */
DO:
    EMPTY TEMP-TABLE tt_int_solic_transf.

    browse_block:
    do v_num_row = 1 to browse BROWSE-6:num-selected-rows :
        assign v_log_method = browse BROWSE-6:fetch-selected-row(v_num_row).
        
        if  avail int_solic_transf and v_log_method = TRUE then do:
            get current BROWSE-6 no-lock.

            assign v_rec_int_solic_transf = recid(int_solic_transf).

            find int_solic_transf NO-LOCK 
                where recid(int_solic_transf) = v_rec_int_solic_transf no-error.

            if  avail int_solic_transf then do:
                FIND FIRST tt_int_solic_transf
                    WHERE tt_int_solic_transf.num_solicitacao = int_solic_transf.num_solicitacao
                    AND   tt_int_solic_transf.cod_cta_pat     = int_solic_transf.cod_cta_pat    
                    AND   tt_int_solic_transf.num_bem_pat     = int_solic_transf.num_bem_pat    
                    AND   tt_int_solic_transf.num_seq_bem_pat = int_solic_transf.num_seq_bem_pat
                    NO-LOCK NO-ERROR.

                IF  NOT AVAIL tt_int_solic_transf THEN DO:
                    CREATE tt_int_solic_transf.
                    BUFFER-COPY int_solic_transf TO tt_int_solic_transf.
                END.
            end.
        end.
    end.

    RUN esp\fas\esfas017b.w (INPUT TABLE tt_int_solic_transf,
                             INPUT "R").

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    apply 'value-changed':U to {&browse-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_todos B-table-Win
ON CHOOSE OF bt_todos IN FRAME F-Main /* Marcar todos */
DO:
    def var v_num_cont as integer no-undo.
    def var v_num_lin  as integer no-undo.

    assign v_log_method = session:set-wait-state('general')
           v_num_lin = BROWSE-6:num-iterations in frame F-Main.

    BROWSE-6:deselect-rows() in frame F-Main.
    apply "home" to BROWSE-6 in frame F-Main.
    do  v_num_cont = 1 to v_num_lin:
        if  BROWSE-6:is-row-selected(v_num_lin) in frame F-Main then leave.
        if  BROWSE-6:select-row(v_num_cont) in frame F-Main then.
        if  v_num_cont mod v_num_lin = 0 then do:
            apply "page-down" to BROWSE-6 in frame F-Main.
            assign v_num_cont = 0.
        end.  
    end.  
    assign v_log_method = session:set-wait-state('').  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects B-table-Win  _ADM-CREATE-OBJECTS
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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'esp/fas/esfas017-b01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_esfas017-b01 ).
       RUN set-position IN h_esfas017-b01 ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 13.00 , 82.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_esfas017-b01 ,
             BROWSE-6:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  EMPTY TEMP-TABLE tt_int_solic_transf.

  ASSIGN v_usuar_aprov = v_cod_usuar_corren.

  IF  CAN-FIND(FIRST usuar_grp_usuar NO-LOCK
               WHERE usuar_grp_usuar.cod_usuar     = v_cod_usuar_corren
               AND  (usuar_grp_usuar.cod_grp_usuar = "C12"
               OR    usuar_grp_usuar.cod_grp_usuar = "C10"
               OR    usuar_grp_usuar.cod_grp_usuar = "adm")) THEN
      ASSIGN v_usuar_aprov = "*".

  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_open_query B-table-Win 
PROCEDURE pi_open_query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY BROWSE-6 FOR EACH int_solic_transf
                            WHERE v_usuar_aprov                     = "*"
                            AND   int_solic_transf.num_solicitacao >= v_nr_solic_ini
                            AND   int_solic_transf.num_solicitacao <= v_nr_solic_fim
                            AND   int_solic_transf.cod_cta_pat     >= v_cod_cta_pat_ini
                            AND   int_solic_transf.cod_cta_pat     <= v_cod_cta_pat_fim
                            AND   int_solic_transf.dat_transf      >= v_dat_transf_ini
                            AND   int_solic_transf.dat_transf      <= v_dat_transf_fim
                            AND   int_solic_transf.ind_aprovac      = "Pendente".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "int_solic_transf"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "RetornaValorCampo" B-table-Win _INLINE
/* Actions: ? ? ? ? support/brwrtval.p */
/* Procedure desativada */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

