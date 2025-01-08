&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
*******************************************************************************/
{include/i-prgvrs.i ESCQ0210A-B01 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i escq0210a-b01 MCQ}
&ENDIF

/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w
&glob ORIGINALNAME inbrw/b04in050.w 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Variaveis usadas internamente pelo estilo, favor nao elimina-las     */

/* v†ri†veis de uso globla */
def new global shared var v-row-parent as rowid no-undo.

/* vari†veis de uso local */
def var v-row-table  as rowid.

def var wh-pesquisa as widget-handle no-undo.

def var i-seq-comp as integer no-undo.
def var de-res-min as decimal no-undo.
def var de-res-max as decimal no-undo.
def var c-texto    as char    no-undo.

def var r-res-fic-cq as rowid no-undo.
def var r-comp-exame as rowid no-undo.
def var l-implanta   as logical init no.
def var c-dec        as char format "x(04)".
def var c-aux        as char format "x(04)" init "9999".
def var c-formato    as char format "x(14)".



define new global SHARED temp-table tt-resultado no-undo
    field cod-comp     AS INTEGER format ">>>9" /*like res-fic-cq.cod-comp*/
    field cod-exame    like res-fic-cq.cod-exame
    field descricao    like comp-exame.descricao
    field cdn-versao   like comp-exame.cdn-versao
    field it-codigo    like it-comp-exame.it-codigo
    field laudo        like res-fic-cq.laudo
    field narrativa    like res-fic-cq.narrativa
    field nr-tabela    like res-fic-cq.nr-tabela
    field res-max      like res-fic-cq.res-max
    field resultado    like res-fic-cq.resultado
    field seq-comp     like res-fic-cq.seq-comp
    field tipo-result  like res-fic-cq.tipo-result
    field unidade      like comp-exame.unidade
    field origem       as   integer format "9". 
    /* O atributo "origem" indica se o registro foi gerado a partir 
    da entidade "it-comp-exame" ou da "comp-exame". */


/* fim das variaveis utilizadas no estilo */

DEF VAR l-retorno AS LOG NO-UNDO.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES exam-ficha
&Scoped-define FIRST-EXTERNAL-TABLE exam-ficha


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR exam-ficha.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-resultado

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-resultado.cod-comp tt-resultado.descricao tt-resultado.nr-tabela tt-resultado.seq-comp tt-resultado.resultado tt-resultado.unidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table tt-resultado.seq-comp ~
tt-resultado.resultado   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-table tt-resultado
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-table tt-resultado
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-resultado
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-resultado.
&Scoped-define TABLES-IN-QUERY-br-table tt-resultado
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-resultado


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-Atualizar bt-Narrativa 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-Atualizar 
     LABEL "&Atualizar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-Narrativa 
     LABEL "&Narrativa" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-resultado SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK NO-WAIT DISPLAY
      tt-resultado.cod-comp COLUMN-LABEL "Comp"
      tt-resultado.descricao
      tt-resultado.nr-tabela
      tt-resultado.seq-comp
      tt-resultado.resultado
      tt-resultado.unidade
  ENABLE
      tt-resultado.seq-comp
      tt-resultado.resultado
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 83.14 BY 7.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1.04 COL 1
     bt-Atualizar AT ROW 8.88 COL 1
     bt-Narrativa AT ROW 8.88 COL 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: movind.exam-ficha
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 9
         WIDTH              = 83.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-resultado
     _END_FREEFORM
     _Options          = "no-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
    apply 'choose' to bt-Atualizar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-DISPLAY OF br-table IN FRAME F-Main
DO:  
   FIND it-comp-exame WHERE
        it-comp-exame.it-codigo = tt-resultado.it-codigo AND
        it-comp-exame.cod-exame = tt-resultado.cod-exame AND
        it-comp-exame.cod-comp  = tt-resultado.cod-comp NO-LOCK NO-ERROR.

   IF AVAIL it-comp-exame THEN DO:
      ASSIGN c-dec = "." +  substr(c-aux,1,it-comp-exame.nr-decimais).
      IF  c-dec = "." THEN
          ASSIGN c-dec = "".
      ASSIGN c-formato = "->,>>>,>>9" + c-dec
             tt-resultado.resultado:FORMAT IN BROWSE {&BROWSE-NAME} = c-formato.   
   END.
   ELSE DO:
      FIND FIRST comp-exame NO-LOCK
           WHERE comp-exame.cod-exame  = tt-resultado.cod-exame 
             AND comp-exame.cod-comp   = tt-resultado.cod-comp 
             AND comp-exame.cdn-versao = tt-resultado.cdn-versao NO-ERROR.
      IF AVAILABLE comp-exame THEN DO: 
         ASSIGN c-dec = "." +  substr(c-aux,1,comp-exame.nr-decimais).
         IF c-dec = "." THEN
             ASSIGN c-dec = "".
         ASSIGN c-formato = "->,>>>,>>9" + c-dec
                tt-resultado.resultado:FORMAT IN BROWSE {&BROWSE-NAME} = c-formato.
      END.
   END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
   /* Do not disable this code or no updates will take place except
      by pressing the Save button on an Update SmartPanel. */

   {src/adm/template/brsleave.i}     

   assign tt-resultado.resultado:read-only in browse {&browse-name} = yes.
   assign tt-resultado.seq-comp:read-only in browse {&browse-name} = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:

  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  /* run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))). */   

   assign tt-resultado.resultado:read-only in browse {&browse-name} = yes.
   assign tt-resultado.seq-comp:read-only in browse {&browse-name} = yes.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Atualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Atualizar B-table-Win
ON CHOOSE OF bt-Atualizar IN FRAME F-Main /* Atualizar */
DO:
    IF c-nom-prog-upc-mg97 <> "" THEN
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "Atualizar",
                                        INPUT "BROWSER",
                                        INPUT THIS-PROCEDURE,
                                        INPUT BROWSE br-table:HANDLE,
                                        INPUT string(TEMP-TABLE tt-resultado:HANDLE),
                                        INPUT ROWID(tt-resultado)).
    IF RETURN-VALUE = "OK":U THEN
        ASSIGN l-retorno = YES.

    FIND FIRST comp-exame NO-LOCK
         WHERE comp-exame.cod-comp   = tt-resultado.cod-comp  
           AND comp-exame.cdn-versao = tt-resultado.cdn-versao NO-ERROR.

    IF NOT AVAILABLE tt-resultado THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17947,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    
    /* tt-resultado.origem = 1 ---> existe it-comp-exame cadastrada */
    if tt-resultado.origem = 1 then do:
    
        find it-comp-exame where
             it-comp-exame.cod-exame = tt-resultado.cod-exame and
             it-comp-exame.cod-comp  = tt-resultado.cod-comp  and
             it-comp-exame.it-codigo = tt-resultado.it-codigo 
             no-lock no-error.
        {cqp/escq0210.i1 it-}
        ASSIGN tt-resultado.resultado = INPUT BROWSE {&browse-name} tt-resultado.resultado.
    end.
    else do:
        FIND FIRST comp-exame NO-LOCK
             WHERE comp-exame.cod-exame  = tt-resultado.cod-exame
               AND comp-exame.cod-comp   = tt-resultado.cod-comp
               AND comp-exame.cdn-versao = tt-resultado.cdn-versao NO-ERROR. 
             
        {cqp/escq0210.i1 }
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Narrativa B-table-Win
ON CHOOSE OF bt-Narrativa IN FRAME F-Main /* Narrativa */
DO:

    IF  AVAIL ficha-cq
    AND AVAIL tt-resultado THEN DO:

        find first res-fic-cq
             where res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
               and res-fic-cq.it-codigo = ficha-cq.it-codigo
               and res-fic-cq.cod-exame = tt-resultado.cod-exame
               and res-fic-cq.cod-comp  = tt-resultado.cod-comp NO-LOCK NO-ERROR.
        IF  AVAIL res-fic-cq THEN DO:
            assign r-res-fic-cq = rowid(res-fic-cq)
                   c-texto      = res-fic-cq.narrativa.

            run cqp/escq0210b.w (input-output c-texto).

            find FIRST res-fic-cq
                where rowid(res-fic-cq) = r-res-fic-cq exclusive-lock no-error.
            IF AVAIL res-fic-cq THEN
                assign res-fic-cq.narrativa = c-texto.

            find current res-fic-cq no-lock no-error.

        END.
        ELSE do: /* informa o usu†rio que o resultado n∆o foi digitado */
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Resultado" *}
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 27224,
                              INPUT RETURN-VALUE).
            RETURN "ADM-ERROR".
        END.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

def var de-resultado-old as decimal no-undo.

ON  entry OF tt-resultado.resultado do:
    assign de-resultado-old  = tt-resultado.resultado.   
END.

ON  leave OF tt-resultado.resultado do:
    if tt-resultado.origem = 1 then
        find it-comp-exame where
             it-comp-exame.cod-exame = tt-resultado.cod-exame and
             it-comp-exame.cod-comp  = tt-resultado.cod-comp  and
             it-comp-exame.it-codigo = ficha-cq.it-codigo
             no-lock no-error.
    else
        FIND FIRST comp-exame NO-LOCK
             WHERE comp-exame.cod-exame  = tt-resultado.cod-exame
               AND comp-exame.cod-comp   = tt-resultado.cod-comp
               AND comp-exame.cdn-versao = tt-resultado.cdn-versao NO-ERROR.
    if  input browse {&browse-name} tt-resultado.resultado <> "" then do:  
        if tt-resultado.origem = 1 then do:
            if input browse {&browse-name} tt-resultado.resultado < it-comp-exame.result-min or
               input browse {&browse-name} tt-resultado.resultado > it-comp-exame.result-max then do:
                run utp/ut-msgs.p (input "show", input 833, input "").
                if  return-value = 'no' then do:                
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(de-resultado-old)
                           tt-resultado.resultado:read-only in browse {&browse-name} = yes.
                    return no-apply.
                end.    
                else
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(input browse {&browse-name} tt-resultado.resultado).
            end.            
        end.
        else do:
            if  input browse {&browse-name} tt-resultado.resultado < comp-exame.result-min or
                input browse {&browse-name} tt-resultado.resultado > comp-exame.result-max then do:
                run utp/ut-msgs.p (input "show", input 833, input "").                
                if  return-value = 'no' then do:
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(de-resultado-old)
                           tt-resultado.resultado:read-only in browse {&browse-name} = yes.
                    return no-apply.
                end.
                else
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(input browse {&browse-name} tt-resultado.resultado).
            end.
        end.
    end.   
    else do:
         if tt-resultado.origem = 1 then do:
            if tt-resultado.resultado < it-comp-exame.result-min or
               tt-resultado.resultado > it-comp-exame.result-max then do:
                run utp/ut-msgs.p (input "show", input 833, input "").
                if  return-value = 'no' then do:
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(de-resultado-old)
                           tt-resultado.resultado:read-only in browse {&browse-name} = yes.
                    return no-apply.
                end.
                else
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(input browse {&browse-name} tt-resultado.resultado).
            end.
        end.
        else do:
            if  tt-resultado.resultado < comp-exame.result-min or
                tt-resultado.resultado > comp-exame.result-max then do:
                run utp/ut-msgs.p (input "show", input 833, input "").
                if  return-value = 'no' then do:
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(de-resultado-old)
                           tt-resultado.resultado:read-only in browse {&browse-name} = yes.
                  
                end.
                else
                    assign tt-resultado.resultado:screen-value in browse {&browse-name} = string(input browse {&browse-name} tt-resultado.resultado).
            end.
        end.
    end.
    {cqp/escq0210.i}
    assign res-fic-cq.resultado = input browse {&browse-name} tt-resultado.resultado.    
END.

ON  leave OF tt-resultado.seq-comp do:
    ASSIGN tt-resultado.seq-comp = INPUT BROWSE {&browse-name} tt-resultado.seq-comp.
    if  input browse {&browse-name} tt-resultado.seq-comp <> "" then do:
        if tt-resultado.origem = 1 then 
            find first comp-tab-res where 
                 comp-tab-res.nr-tabela = it-comp-exame.nr-tabela and
                 comp-tab-res.seq-comp  = input browse {&browse-name} tt-resultado.seq-comp 
                 no-lock no-error.
        else 
            find first comp-tab-res where 
                 comp-tab-res.nr-tabela = comp-exame.nr-tabela and
                 comp-tab-res.seq-comp  = input browse {&browse-name} tt-resultado.seq-comp 
                 no-lock no-error.
        if  not avail comp-tab-res then do:
            {utp/ut-table.i mgind comp-tab-res 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            return no-apply.
        end. 
    end.    
    {cqp/escq0210.i}
    assign res-fic-cq.seq-comp = input browse {&browse-name} tt-resultado.seq-comp.    
END.               

ON 'F5' OF tt-resultado.seq-comp do:
    {include/zoomvar.i &prog-zoom  = inzoom/z03in052.w
                       &campo      = tt-resultado.seq-comp
                       &campozoom  = seq-comp
                       &browse     = br-table
                       &parametros = "run pi-seta-inicial in wh-pesquisa (input tt-resultado.nr-tabela)."} 
    apply "leave" to tt-resultado.seq-comp in browse {&browse-name}.                  
END.                         

ON  MOUSE-SELECT-DBLCLICK OF tt-resultado.seq-comp do:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "exam-ficha"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "exam-ficha"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-cases B-table-Win 
PROCEDURE local-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query-cases':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reabre B-table-Win 
PROCEDURE pi-reabre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-exam-ficha AS ROWID NO-UNDO.
    
    FOR EACH tt-resultado:
        DELETE tt-resultado.
    END.
    FIND exam-ficha WHERE r-exam-ficha      = ROWID(exam-ficha)   NO-LOCK NO-ERROR.
    FIND ficha-cq   WHERE ficha-cq.nr-ficha = exam-ficha.nr-ficha NO-LOCK NO-ERROR.
    
    IF CAN-FIND (FIRST it-comp-exame 
                 WHERE it-comp-exame.it-codigo = exam-ficha.it-codigo  
                   AND it-comp-exame.cod-exame = exam-ficha.cod-exame) THEN DO:

        FOR EACH it-comp-exame NO-LOCK
           WHERE it-comp-exame.cod-exame = exam-ficha.cod-exame 
             AND it-comp-exame.it-codigo = ficha-cq.it-codigo 
             AND it-comp-exame.situacao = 1 : /* ATIVO */
             
            FIND FIRST res-fic-cq no-lock
                 WHERE res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                   AND res-fic-cq.it-codigo = ficha-cq.it-codigo
                   AND res-fic-cq.cod-exame = it-comp-exame.cod-exame 
                   AND res-fic-cq.cod-comp  = it-comp-exame.cod-comp NO-ERROR.
                   
            IF AVAILABLE res-fic-cq THEN DO:
            
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = res-fic-cq.cod-comp
                       tt-resultado.cod-exame   = res-fic-cq.cod-exame
                       tt-resultado.it-codigo   = it-comp-exame.it-codigo
                       tt-resultado.laudo       = res-fic-cq.laudo
                       tt-resultado.narrativa   = res-fic-cq.narrativa
                       tt-resultado.nr-tabela   = res-fic-cq.nr-tabela
                       tt-resultado.res-max     = res-fic-cq.res-max
                       tt-resultado.resultado   = res-fic-cq.resultado
                       tt-resultado.seq-comp    = res-fic-cq.seq-comp
                       tt-resultado.tipo-result = res-fic-cq.tipo-result
                       tt-resultado.descricao   = it-comp-exame.descricao
                       tt-resultado.unidade     = it-comp-exame.unidade
                       tt-resultado.origem      = 1. /* origem tt-resultado it-comp-exame */
                VALIDATE tt-resultado.
            END.
            ELSE DO:
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = it-comp-exame.cod-comp
                       tt-resultado.cod-exame   = it-comp-exame.cod-exame
                       tt-resultado.it-codigo   = it-comp-exame.it-codigo
                       tt-resultado.laudo       = ""
                       tt-resultado.narrativa   = ""
                       tt-resultado.nr-tabela   = it-comp-exame.nr-tabela
                       tt-resultado.res-max     = 0
                       tt-resultado.resultado   = 0
                       tt-resultado.seq-comp    = 0
                       tt-resultado.tipo-result = it-comp-exame.tipo-result
                       tt-resultado.descricao   = it-comp-exame.descricao
                       tt-resultado.unidade     = it-comp-exame.unidade
                       tt-resultado.origem      = 1. /* origem tt-resultado it-comp-exame */
                 VALIDATE tt-resultado.
            END.
        END.
    END.
    ELSE
    FOR EACH comp-exame 
       WHERE comp-exame.cod-exame  = exam-ficha.cod-exame 
         AND comp-exame.cdn-versao = exam-ficha.cdn-versao
         AND comp-exame.log-1 NO-LOCK: /* Ativo */

       FIND FIRST tt-resultado
            WHERE tt-resultado.cod-exame  = comp-exame.cod-exame 
              AND tt-resultado.cod-comp   = comp-exame.cod-comp 
              AND tt-resultado.cdn-versao = comp-exame.cdn-versao NO-ERROR.
        IF NOT AVAILABLE tt-resultado THEN DO:
            FIND FIRST res-fic-cq NO-LOCK
                 WHERE res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                   AND res-fic-cq.it-codigo = ficha-cq.it-codigo
                   AND res-fic-cq.cod-exame = comp-exame.cod-exame 
                   AND res-fic-cq.cod-comp  = comp-exame.cod-comp NO-ERROR.
            IF AVAILABLE res-fic-cq THEN DO:
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = res-fic-cq.cod-comp
                       tt-resultado.cod-exame   = res-fic-cq.cod-exame
                       tt-resultado.cdn-versao  = comp-exame.cdn-versao
                       tt-resultado.it-codigo   = ?
                       tt-resultado.laudo       = res-fic-cq.laudo
                       tt-resultado.narrativa   = res-fic-cq.narrativa
                       tt-resultado.nr-tabela   = res-fic-cq.nr-tabela
                       tt-resultado.res-max     = res-fic-cq.res-max
                       tt-resultado.resultado   = res-fic-cq.resultado
                       tt-resultado.seq-comp    = res-fic-cq.seq-comp
                       tt-resultado.tipo-result = res-fic-cq.tipo-result
                       tt-resultado.descricao   = comp-exame.descricao
                       tt-resultado.unidade     = comp-exame.unidade
                       tt-resultado.origem      = 2. /* origem tt-resultado comp-exame */ 
                VALIDATE tt-resultado.
            END.
            ELSE DO:
                CREATE tt-resultado.
                ASSIGN tt-resultado.cod-comp    = comp-exame.cod-comp
                       tt-resultado.cod-exame   = comp-exame.cod-exame
                       tt-resultado.cdn-versao  = comp-exame.cdn-versao
                       tt-resultado.it-codigo   = ?
                       tt-resultado.laudo       = ""
                       tt-resultado.narrativa   = ""
                       tt-resultado.nr-tabela   = comp-exame.nr-tabela
                       tt-resultado.res-max     = 0
                       tt-resultado.resultado   = 0
                       tt-resultado.seq-comp    = 0
                       tt-resultado.tipo-result = comp-exame.tipo-result
                       tt-resultado.descricao   = comp-exame.descricao
                       tt-resultado.unidade     = comp-exame.unidade
                       tt-resultado.origem      = 2. /* origem tt-resultado comp-exame */ 
                VALIDATE tt-resultado.
            END.
        END.
    END.  
    
    /***************** Chamada Epc ************************/
     IF  c-nom-prog-upc-mg97 <> "" THEN DO:
         {include/i-epcgeneric.i lista-compon browser THIS-PROCEDURE:HANDLE f-main exam-ficha rowid(exam-ficha)} 
     END.
    /**************************************************************/   
    
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    
    ASSIGN tt-resultado.resultado:READ-ONLY IN BROWSE {&browse-name} = YES
           tt-resultado.seq-comp:READ-ONLY  IN BROWSE {&browse-name} = YES.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT ficha-cq NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
