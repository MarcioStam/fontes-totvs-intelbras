&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movdis           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i UPC-FT0502-V01 3.00.00.000}
/**ATUALIZACAO: 12/09/2011**/
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var hProgramZoom as Handle no-undo.

DEF BUFFER bf-nota-fiscal FOR nota-fiscal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES nota-fiscal
&Scoped-define FIRST-EXTERNAL-TABLE nota-fiscal


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR nota-fiscal.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-processada fi-nr-nota-el ~
fi-cod-autentic-nfe fi-nr-nota-subs fi-cidade fi-estado fi-pais ~
fi-ult-usuario fi-ult-data fi-ult-hora RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS tg-processada fi-nr-nota-el ~
fi-cod-autentic-nfe fi-nr-nota-subs fi-cidade fi-estado fi-pais ~
fi-ult-usuario fi-ult-data fi-ult-hora 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-cidade AS CHARACTER FORMAT "x(25)" 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88.

DEFINE VARIABLE fi-cod-autentic-nfe AS CHARACTER FORMAT "x(16)" 
     LABEL "Cod Autenticaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "x(2)" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-nr-nota-el AS CHARACTER FORMAT "X(16)" 
     LABEL "Nr NFS-e" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fi-nr-nota-subs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nr NFSe Substitu°da" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 TOOLTIP "Informe o n£mero da NFSe substitu°da" NO-UNDO.

DEFINE VARIABLE fi-pais AS CHARACTER FORMAT "x(20)" 
     LABEL "Pa°s" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-ult-data AS DATE FORMAT "99/99/9999" 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ult-hora AS CHARACTER FORMAT "X(8)":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ult-usuario AS CHARACTER FORMAT "x(16)" 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 3.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 3.75.

DEFINE VARIABLE tg-processada AS LOGICAL INITIAL no 
     LABEL "Processado" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-processada AT ROW 1.83 COL 21 WIDGET-ID 16
     fi-nr-nota-el AT ROW 4.13 COL 19.14 COLON-ALIGNED WIDGET-ID 10
     fi-cod-autentic-nfe AT ROW 5.13 COL 19.14 COLON-ALIGNED WIDGET-ID 6
     fi-nr-nota-subs AT ROW 6.13 COL 19 COLON-ALIGNED HELP
          "Informe o n£mero da NFSe substitu°da" WIDGET-ID 30
     fi-cidade AT ROW 4.13 COL 49 COLON-ALIGNED WIDGET-ID 4
     fi-estado AT ROW 5.13 COL 49 COLON-ALIGNED WIDGET-ID 8
     fi-pais AT ROW 6.13 COL 49 COLON-ALIGNED WIDGET-ID 12
     fi-ult-usuario AT ROW 8.21 COL 20 COLON-ALIGNED HELP
          "Usu†rio da £ltima atualizaá∆o" WIDGET-ID 18
     fi-ult-data AT ROW 8.21 COL 40 COLON-ALIGNED HELP
          "Data da £ltima atualizaá∆o" WIDGET-ID 20
     fi-ult-hora AT ROW 8.21 COL 58 COLON-ALIGNED WIDGET-ID 22
     "Local Prestaá∆o Serviáo" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 3.25 COL 46 WIDGET-ID 42
     "NFS-e" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 3.25 COL 8 WIDGET-ID 40
     "RPS" VIEW-AS TEXT
          SIZE 4 BY .67 AT ROW 1.25 COL 8 WIDGET-ID 38
     "Èltima Atualizaá∆o" VIEW-AS TEXT
          SIZE 12.43 BY .67 AT ROW 7.5 COL 8 WIDGET-ID 28
     RECT-1 AT ROW 7.71 COL 5 WIDGET-ID 24
     RECT-2 AT ROW 3.5 COL 5 WIDGET-ID 32
     RECT-3 AT ROW 1.5 COL 5 WIDGET-ID 34
     RECT-4 AT ROW 3.5 COL 43 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.57 BY 8.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movdis.nota-fiscal
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.88
         WIDTH              = 82.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fi-cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cidade V-table-Win
ON F5 OF fi-cidade IN FRAME f-main /* Cidade */
DO:
    {method/zoomfields.i &ProgramZoom  = dizoom/z01di341.w
                         &FieldZoom1   = cidade
                         &FieldScreen1 = fi-cidade
                         &Frame1       = f-main
                         &FieldZoom2   = estado
                         &FieldScreen2 = fi-estado
                         &Frame2       = f-main
                         &FieldZoom3   = pais
                         &FieldScreen3 = fi-pais
                         &Frame3       = f-main
                         &EnableImplant = "no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cidade V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cidade IN FRAME f-main /* Cidade */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estado V-table-Win
ON F5 OF fi-estado IN FRAME f-main /* Estado */
DO:
    {include/zoomvar.i &prog-zoom  = unzoom/z01un007.w
                       &campo      = fi-pais
                       &campozoom  = pais
                       &campo2     = fi-estado
                       &campozoom2 = estado
                       &frame      = f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-estado IN FRAME f-main /* Estado */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-nota-subs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-nota-subs V-table-Win
ON F5 OF fi-nr-nota-subs IN FRAME f-main /* Nr NFSe Substitu°da */
DO:
    {method/zoomFields.i &ProgramZoom="eszoom/z01es135.w"
                         &FieldZoom1="nr-nota-el"
                         &FieldScreen1="fi-nr-nota-subs"
                         &Frame1="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-nota-subs V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nr-nota-subs IN FRAME f-main /* Nr NFSe Substitu°da */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pais V-table-Win
ON F5 OF fi-pais IN FRAME f-main /* Pa°s */
DO:
    {include/zoomvar.i &prog-zoom = unzoom/z01un006.w
                       &campo     = fi-pais
                       &campozoom = nome-pais
                       &frame     = f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-pais IN FRAME f-main /* Pa°s */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if fi-cidade:load-mouse-pointer       ("image/lupa.cur") in frame {&FRAME-NAME} then.
  if fi-estado:load-mouse-pointer       ("image/lupa.cur") in frame {&FRAME-NAME} then.
  if fi-pais:load-mouse-pointer         ("image/lupa.cur") in frame {&FRAME-NAME} then.
  if fi-nr-nota-subs:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "nota-fiscal"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "nota-fiscal"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. 
    {include/i-valid.i}                                          */
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */
    RUN pi-validate IN THIS-PROCEDURE.
    if  RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    if  avail nota-fiscal then do:

        FOR FIRST esp-ext-nota-fiscal OF nota-fiscal EXCLUSIVE-LOCK:
            assign esp-ext-nota-fiscal.processada       = tg-processada:checked            in frame f-main 
                   esp-ext-nota-fiscal.cod-autentic-nfe = fi-cod-autentic-nfe:Screen-value in frame f-main 
                   esp-ext-nota-fiscal.nr-nota-el       = fi-nr-nota-el:Screen-value       in frame f-main 
                   esp-ext-nota-fiscal.cidade           = fi-cidade:screen-value           in frame f-main 
                   esp-ext-nota-fiscal.estado           = fi-estado:Screen-value           in frame f-main 
                   esp-ext-nota-fiscal.pais             = fi-pais:Screen-value             in frame f-main
                   esp-ext-nota-fiscal.nr-nota-fis-subs = fi-nr-nota-subs:SCREEN-VALUE     IN FRAME f-main
                   esp-ext-nota-fiscal.ult-usuario      = c-seg-usuario
                   esp-ext-nota-fiscal.ult-data         = today
                   esp-ext-nota-fiscal.ult-hora         = time.
        END.
    End.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    disable tg-processada
            fi-nr-nota-el
            fi-cod-autentic-nfe
            fi-cidade
            fi-estado
            fi-pais
            fi-nr-nota-subs
            fi-ult-usuario
            fi-ult-data
            fi-ult-hora
        with frame f-main.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
    /* Code placed here will execute AFTER standard behavior.    */
    
    if  avail nota-fiscal then do:
        for first esp-ext-nota-fiscal of nota-fiscal no-lock:
            assign tg-processada:checked            in frame f-main = esp-ext-nota-fiscal.processada
                   fi-cod-autentic-nfe:Screen-value in frame f-main = esp-ext-nota-fiscal.cod-autentic-nfe
                   fi-nr-nota-el:Screen-value       in frame f-main = esp-ext-nota-fiscal.nr-nota-el
                   fi-cidade:screen-value           in frame f-main = esp-ext-nota-fiscal.cidade
                   fi-estado:Screen-value           in frame f-main = esp-ext-nota-fiscal.estado
                   fi-pais:Screen-value             in frame f-main = esp-ext-nota-fiscal.pais
                   fi-nr-nota-subs:SCREEN-VALUE     IN FRAME f-main = esp-ext-nota-fiscal.nr-nota-fis-subs
                   fi-ult-usuario:Screen-value      in frame f-main = esp-ext-nota-fiscal.ult-usuario
                   fi-ult-data:Screen-value         in frame f-main = string(esp-ext-nota-fiscal.ult-data)
                   fi-ult-hora:Screen-value         in frame f-main = string(esp-ext-nota-fiscal.ult-hora,"HH:MM:SS").
        end.
    End.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    /* Habilita os campos da RPS apenas quando a serie eh RPS */
    if  avail nota-fiscal then do:
        for first esp-ext-ser-estab no-lock
            where esp-ext-ser-estab.serie       = nota-fiscal.serie
              and esp-ext-ser-estab.cod-estabel = nota-fiscal.cod-estabel
              and esp-ext-ser-estab.emite-rps:

            enable tg-processada
                   fi-nr-nota-el
                   fi-cod-autentic-nfe
                   fi-cidade
                   fi-estado
                   fi-pais
                with frame f-main.

            /* Habilita Substituicao da nota apenas quando nao estiver processada */
            FIND FIRST esp-ext-nota-fiscal NO-LOCK OF nota-fiscal NO-ERROR.
            
            IF  NOT AVAIL esp-ext-nota-fiscal OR 
                (AVAIL esp-ext-nota-fiscal AND NOT esp-ext-nota-fiscal.processada) THEN
                ENABLE fi-nr-nota-subs
                    WITH FRAME f-main.

            IF  SUBSTRING(esp-ext-ser-estab.char-1,3,1) <> "S" THEN
                DISABLE fi-nr-nota-subs
                    WITH FRAME f-main.
        End.
    End.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
    /* Code placed here will execute AFTER standard behavior.    */
    disable tg-processada
            fi-nr-nota-el
            fi-cod-autentic-nfe
            fi-cidade
            fi-estado
            fi-pais
            fi-nr-nota-subs
            fi-ult-usuario
            fi-ult-data
            fi-ult-hora
        with frame f-main.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.

    find nota-fiscal no-lock where rowid(nota-fiscal) = v-row-parent no-error.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

    if  avail nota-fiscal then do:

        if  fi-cidade:Screen-value in frame           f-main <> "" or
            fi-estado:Screen-value in frame           f-main <> "" or
            fi-pais:Screen-value in frame             f-main <> "" or 
            fi-nr-nota-el:Screen-value in frame       f-main <> "" or
            fi-cod-autentic-nfe:Screen-value in frame f-main <> "" or
            tg-processada:checked in frame  f-main    then do:

            if  not can-find(first esp-ext-nota-fiscal of nota-fiscal) then do:
                run utp/ut-msgs.p (input "show":U,
                                   input 17006,
                                   input "N∆o foi encontrado registro da RPS!" + "~~" +
                                         "Verifique este problema com o administrador do sistema. N∆o foi encontrado registro da RPS para gravar os dados de retorno. Administrador, analisar a tabela: esp-ext-nota-fiscal").
                return "ADM-ERROR":U.
            end.
        end.

        if  fi-cidade:Screen-value in frame f-main <> "" or
            fi-estado:Screen-value in frame f-main <> "" or
            fi-pais:Screen-value in frame   f-main <> "" then do:
        
            if  not can-find(first mgcad.cidade
                             where cidade.cidade = fi-cidade:Screen-value in frame f-main
                               and cidade.estado = fi-estado:Screen-value in frame f-main
                               and cidade.pais   = fi-pais:Screen-value in frame f-main) then do:
            
                run utp/ut-msgs.p (input "show":U,
                                   input 17006,
                                   input "Relacionamento Cidade x Estado x Pais n∆o existe!" + "~~" +
                                         "Verifique este relacionamento no cadastro CD0330.").
                return "ADM-ERROR":U.
            End.
        end.

        IF  fi-nr-nota-subs:SCREEN-VALUE IN FRAME f-main <> "" THEN DO:

            FIND FIRST esp-ext-nota-fiscal NO-LOCK
                 WHERE esp-ext-nota-fiscal.nr-nota-el  = fi-nr-nota-subs:SCREEN-VALUE IN FRAME f-main
                   AND esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

            IF  NOT AVAIL esp-ext-nota-fiscal THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "NFS-e de substituiá∆o n∆o foi localizada!" + "~~" +
                                         "Para substituiá∆o informe uma NFS-e v†lida.").
                RETURN "ADM-ERROR":U.
            END.
            ELSE DO:
                
                /* RPS da NFS-e de substituicao */
                FOR FIRST bf-nota-fiscal NO-LOCK
                    WHERE bf-nota-fiscal.cod-estabel = esp-ext-nota-fiscal.cod-estabel
                      AND bf-nota-fiscal.serie       = esp-ext-nota-fiscal.serie
                      AND bf-nota-fiscal.nr-nota-fis = esp-ext-nota-fiscal.nr-nota-fis:

                    IF  bf-nota-fiscal.dt-cancela = ? THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 17006,
                                           INPUT "NFS-e de substituiá∆o n∆o Ç v†lida!" + "~~" +
                                                 "A NFS-e de substituiá∆o deve ser previamente cancelada pela rotina FT2200.").
                        RETURN "ADM-ERROR":U.
                    END.
                END.
            END.
        END.
    End.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "nota-fiscal"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

