&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE cEventBrowse          AS CHARACTER NO-UNDO.
DEFINE VARIABLE rCurrentRow              AS ROWID NO-UNDO.
DEF VAR iRowsReturned                 AS INTEGER NO-UNDO.

DEF TEMP-TABLE ttTableAux LIKE {&ttTable}.

ON 'Cursor-Down':U OF {&BrowseName}
DO:
    RUN applyCursorDown.
END.

ON 'Cursor-Up':U OF {&BrowseName}
DO:
    RUN applyCursorUp.
END.

ON 'Mouse-Select-DblClick':U OF {&BrowseName}
DO:
    RUN applyDblClick.
END.

ON 'End':U OF {&BrowseName}
DO:
    RUN applyEnd.
END.

ON 'Home':U OF {&BrowseName}
DO:
    RUN applyHome.
END.

ON 'Off-End':U OF {&BrowseName}
DO:
    RUN applyOffEnd.
END.

ON 'Off-Home':U OF {&BrowseName}
DO:
    RUN applyOffHome.
END.

ON 'Page-Down':U OF {&BrowseName}
DO:
    RUN applyPageDown.
END.

ON 'Page-Up':U OF {&BrowseName}
DO:
    RUN applyPageUp.
END.

ON 'Value-Changed':U OF {&BrowseName}
DO:
    RUN applyValueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCursorDown Include 
PROCEDURE applyCursorDown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cEventBrowse = "CURSOR-DOWN":U.
    
    ASSIGN rCurrentRow = IF AVAILABLE {&ttTable}
                            THEN ROWID({&ttTable})
                            ELSE ?.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCursorUp Include 
PROCEDURE applyCursorUp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cEventBrowse = "CURSOR-UP":U.
    
    ASSIGN rCurrentRow = IF AVAILABLE {&ttTable}
                            THEN ROWID({&ttTable})
                            ELSE ?.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyDblClick Include 
PROCEDURE applyDblClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(onDblClick) &THEN
        RUN {&onDblClick} NO-ERROR.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd Include 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rLastCreated AS ROWID NO-UNDO.
    DEFINE VARIABLE rLast     AS ROWID NO-UNDO.
    
    GET LAST {&BrowseName} NO-LOCK.
    IF AVAILABLE {&ttTable} THEN
        ASSIGN rLast = {&ttTable}.r-Rowid.
    ELSE
        ASSIGN rLast = ?.
    
    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    STATUS DEFAULT "Lendo registros, aguarde...".
    &IF DEFINED(DBOVersion) <> 0 &THEN
        /*--- Retorna todos os registros do DBO filho, na temp-table ttTableAux ---*/
        RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                           INPUT STRING(rLast),
                                           INPUT IF rLast = ? THEN NO ELSE YES,
                                           INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                 &ELSE 40 &endif,
                                           OUTPUT iRowsReturned,
                                           OUTPUT TABLE ttTableAux).
    &ELSE
        /*--- Retorna todos os registros do DBO filho, na temp-table ttTableAux ---*/
        RUN getBatchRecords IN {&hDBOTable} (INPUT rLast,
                                            INPUT IF rLast = ? THEN NO ELSE YES,
                                            INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                  &ELSE 40 &endif,
                                            OUTPUT iRowsReturned,
                                            OUTPUT TABLE ttTableAux).
    &ENDIF
    SESSION:SET-WAIT-STATE("":U).
    STATUS DEFAULT "".
    
    /*--- Cancela trigger caso n’o existam mais registros no DBO filho ---*/
    IF CAN-FIND(FIRST ttTableAux) THEN DO:
        FOR EACH ttTableAux:
            IF NOT CAN-FIND(FIRST {&ttTable}
                            WHERE {&ttTable}.r-rowid = ttTableAux.r-rowid) THEN DO:
                RUN createRecord.
                ASSIGN rLastCreated = ROWID({&ttTable}).
            END.
        END.
    
        /*--- Abre o browse filho, para atualiza»’o dos dados ---*/
        {&OPEN-QUERY-{&BrowseName}}
        
        /*--- Seta view-port do browse filho para reposicionamento ---*/
        {&BrowseName}:SET-REPOSITIONED-ROW({&BrowseName}:DOWN IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        /*--- Reposiciona browse filho no œltimo registro ---*/
        REPOSITION {&BrowseName} TO ROWID rLastCreated NO-ERROR.
        GET NEXT {&BrowseName} NO-LOCK.
        
        /*--- Posiciona browse filho no pr½ximo registro ---*/
        {&BrowseName}:SELECT-FOCUSED-ROW().
    END. /*--- CAN-FIND FIRST {&ttTable} ---*/
    
    /*--- Seta variÿvel cEventBrowse com o valor "" ---*/
    ASSIGN cEventBrowse = "":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyHome Include 
PROCEDURE applyHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(DBOVersion) = 0 &THEN    

    DEFINE VARIABLE rLastCreated AS ROWID NO-UNDO.
    DEFINE VARIABLE rFirst    AS ROWID NO-UNDO.
    
    GET FIRST {&BrowseName} NO-LOCK.
    IF AVAILABLE {&ttTable} THEN DO:
        ASSIGN rFirst = {&ttTable}.r-Rowid.
            
        /*--- Seta ponteiro do browse no registro correto ---*/
        BROWSE {&BrowseName}:SELECT-FOCUSED-ROW().
    END.
    ELSE
        ASSIGN rFirst = ?.
        
    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    STATUS DEFAULT "Lendo registros, aguarde...".
    &IF DEFINED(DBOVersion) <> 0 &THEN
        /*--- Retorna registros do DBO filho, na temp-table ttTableAux ---*/
        RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                           INPUT STRING(rFirst),
                                           INPUT IF rFirst = ? THEN NO ELSE YES,
                                           INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                 &ELSE 40 &endif,
                                           OUTPUT iRowsReturned,
                                           OUTPUT TABLE ttTableAux).
    &ELSE
        /*--- Retorna todos os registros do DBO filho, na temp-table ttTableAux ---*/
        RUN getBatchRecordsPrev IN {&hDBOTable} (INPUT rFirst,
                                                INPUT IF rFirst = ? THEN NO ELSE YES,
                                                INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                      &ELSE 40 &endif,
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE ttTableAux).
    &ENDIF
    SESSION:SET-WAIT-STATE("":U).
    STATUS DEFAULT "".
        
    /*--- Cancela trigger caso n’o existam mais registros no DBO filho ---*/
    IF CAN-FIND(FIRST ttTableAux) THEN DO:

        FOR EACH ttTableAux:
            IF NOT CAN-FIND(FIRST {&ttTable}
                            WHERE {&ttTable}.r-rowid = ttTableAux.r-rowid) THEN DO:
                RUN createRecord.
                ASSIGN rLastCreated = ROWID({&ttTable}).
            END.
        END.
        
        /*--- Abre o browse filho, para atualiza»’o dos dados ---*/
        {&OPEN-QUERY-{&BrowseName}}
        
        /*--- Seta view-port do browse filho para reposicionamento ---*/
        {&BrowseName}:SET-REPOSITIONED-ROW({&BrowseName}:DOWN IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        /*--- Reposiciona browse filho no œltimo registro ---*/
        REPOSITION {&BrowseName} TO ROWID rLastCreated NO-ERROR.
        GET NEXT {&BrowseName} NO-LOCK.
        
        /*--- Posiciona browse filho no pr½ximo registro ---*/
        {&BrowseName}:SELECT-FOCUSED-ROW().
    END. /*--- END DO CAN-FIND {&ttTable} ---*/
    &ENDIF /*FIM TESTE PRE-PROCESSADOR (VERS€O DO BO)*/
    
    
    /*--- Seta variÿvel cEventBrowse com o valor "" ---*/
    ASSIGN cEventBrowse = "":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd Include 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rLast AS ROWID NO-UNDO.
    DEFINE VARIABLE rReposition AS ROWID NO-UNDO.
    
    /*--- Tratar evento de SCROLL-NOTIFY do Browse ---*/
    IF cEventBrowse = "":U THEN
        ASSIGN cEventBrowse = "SCROLL-NOTIFY":U.
    
    GET LAST {&BrowseName} NO-LOCK.
    IF AVAILABLE {&ttTable} THEN
        ASSIGN rLast = {&ttTable}.r-Rowid
               rCurrentRow = rowid({&ttTable}).
    ELSE
        ASSIGN rLast = ?.
    
    IF  {&BrowseName}:MULTIPLE IN FRAME {&FRAME-NAME} AND rReposition <> ? THEN
        ASSIGN rCurrentRow = rReposition.
    
    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF DEFINED(DBOVersion) <> 0 &THEN
        /*--- Retorna registros do DBO filho, na temp-table ttTableAux ---*/
        RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                           INPUT STRING(rLast),
                                           INPUT IF rLast = ? THEN NO ELSE YES,
                                           INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                 &ELSE 40 &endif,
                                           OUTPUT iRowsReturned,
                                           OUTPUT TABLE ttTableAux).
    &ELSE
        /*--- Retorna registros do DBO filho, na temp-table ttTableAux ---*/
        RUN getBatchRecords IN {&hDBOTable} (INPUT rLast,
                                            INPUT IF rLast = ? THEN NO ELSE YES,
                                            INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                  &ELSE 40 &endif,
                                            OUTPUT iRowsReturned,
                                            OUTPUT TABLE ttTableAux).
    &ENDIF
    
    /*--- Posiciona no œltimo registro caso n’o existam mais registros no DBO filho ---*/
    IF CAN-FIND(FIRST ttTableAux) THEN DO:
        FOR EACH ttTableAux:
            IF NOT CAN-FIND(FIRST {&ttTable}
                            WHERE {&ttTable}.r-rowid = ttTableAux.r-rowid) THEN DO:
                RUN createRecord.
            END.
        END.

        /*--- Abre o browse filho, para atualiza¯Êo dos dados ---*/
        {&OPEN-QUERY-{&BrowseName}}
    END.
    
    /*--- Posiciona browse filho, no pr½ximo registro ---*/
    CASE cEventBrowse:
        WHEN "PAGE-DOWN":U THEN DO:
            /*--- Seta view-port do browse filho para reposicionamento ---*/
            {&BrowseName}:SET-REPOSITIONED-ROW(1).
            
            /*--- Reposiciona browse filho no registro atual ---*/
            REPOSITION {&BrowseName} TO ROWID rCurrentRow NO-ERROR.
            GET NEXT {&BrowseName} NO-LOCK.
            
            /*--- Seleciona o œltimo registro do view-port do browse filho ---*/
            {&BrowseName}:SELECT-ROW({&BrowseName}:NUM-ITERATIONS IN FRAME {&FRAME-NAME}).
        END.
        OTHERWISE DO:
            /*--- Seta view-port do browse filho para reposicionamento ---*/
            {&BrowseName}:SET-REPOSITIONED-ROW({&BrowseName}:DOWN IN FRAME {&FRAME-NAME} - 1) IN FRAME {&FRAME-NAME}.
            
            IF  rCurrentRow <> ? THEN DO:
                /*--- Reposiciona browse filho no registro atual ---*/
                REPOSITION {&BrowseName} TO ROWID rCurrentRow NO-ERROR.
                GET NEXT {&BrowseName} NO-LOCK.
                
                /*--- Posiciona browse filho no pr«ximo registro ---*/
                /* Paulo H. Lazzarotti */
                /* Testar se retornou registros antes de selecionar proxima linha - FO 804.429 */
                IF iRowsReturned > 0 THEN DO:
                    {&BrowseName}:SELECT-FOCUSED-ROW(). 
                    {&BrowseName}:SELECT-NEXT-ROW().
                END.
            END.
        END.
    END CASE.
    
    /*--- Seta variÿvel cEventBrowse com o valor "" ---*/
    ASSIGN cEventBrowse = "":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffHome Include 
PROCEDURE applyOffHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(DBOVersion) = 0 &THEN    

    DEFINE VARIABLE rFirst AS ROWID NO-UNDO.
    DEFINE VARIABLE rReposition AS ROWID NO-UNDO.
    
    /*--- Tratar evento de SCROLL-NOTIFY do Browse ---*/
    IF cEventBrowse = "":U THEN
        ASSIGN cEventBrowse = "SCROLL-NOTIFY":U.
    
        GET FIRST {&BrowseName} NO-LOCK.
        IF AVAILABLE {&ttTable} THEN
            ASSIGN rFirst = {&ttTable}.r-Rowid
                   rReposition = ROWID({&ttTable}).
        ELSE
            ASSIGN rFirst = ?
                   rReposition = ?.
        
        IF  {&BrowseName}:MULTIPLE IN FRAME {&FRAME-NAME} AND rReposition <> ? THEN
            ASSIGN rCurrentRow = rReposition.
    
        /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
        &IF DEFINED(DBOVersion) <> 0 &THEN
            /*--- Retorna registros do DBO filho, na temp-table ttTableAux ---*/
            RUN serverSendRows IN {&hDBOTable} (INPUT ?,
                                               INPUT STRING(rFirst),
                                               INPUT IF rFirst = ? THEN NO ELSE YES,
                                               INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                     &ELSE 40 &endif,
                                               OUTPUT iRowsReturned,
                                               OUTPUT TABLE ttTableAux).
        &ELSE
            /*--- Retorna registros do DBO filho, na temp-table ttTableAux ---*/
            RUN getBatchRecordsPrev IN {&hDBOTable} (INPUT rFirst,
                                                    INPUT IF rFirst = ? THEN NO ELSE YES,
                                                    INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                                          &ELSE 40 &endif,
                                                    OUTPUT iRowsReturned,
                                                    OUTPUT TABLE ttTableAux).
        &ENDIF
            
        IF  CAN-FIND(FIRST {&ttTable}) THEN DO:
            FOR EACH ttTableAux:
                IF NOT CAN-FIND(FIRST {&ttTable}
                                WHERE {&ttTable}.r-rowid = ttTableAux.r-rowid) THEN DO:
                    RUN createRecord.
                END.
            END.
            
            /*--- Abre o browse filho, para atualiza»’o dos dados ---*/
            {&OPEN-QUERY-{&BrowseName}}
        END. /*--- CAN FIND FIRST {&ttTable} ---*/
        
        /*--- Posiciona browse filho, no pr½ximo registro ---*/
        CASE cEventBrowse:
            WHEN "PAGE-UP":U THEN DO:
                /*--- Seta view-port do browse filho para reposicionamento ---*/
                {&BrowseName}:SET-REPOSITIONED-ROW({&BrowseName}:DOWN IN FRAME {&FRAME-NAME}).
                
                /*--- Reposiciona browse filho no registro atual ---*/
                REPOSITION {&BrowseName} TO ROWID rCurrentRow NO-ERROR.
                GET NEXT {&BrowseName} NO-LOCK.
                
                /*--- Seleciona o œltimo registro do view-port do browse filho ---*/
                {&BrowseName}:SELECT-ROW(1).
            END.
            OTHERWISE DO:
                /*--- Seta view-port do browse filho para reposicionamento ---*/
                {&BrowseName}:SET-REPOSITIONED-ROW(1) IN FRAME {&FRAME-NAME}.
                
                IF  rReposition <> ? THEN DO:
                    /*--- Reposiciona browse filho no registro atual ---*/
                    REPOSITION {&BrowseName} TO ROWID rReposition NO-ERROR.
                    GET NEXT {&BrowseName} NO-LOCK.
                    
                    /*--- Posiciona browse filho no registro anterior ---*/
                    {&BrowseName}:SELECT-FOCUSED-ROW().
                    {&BrowseName}:SELECT-PREV-ROW().
                END.
            END.
        END CASE.
    &ENDIF 

    /*--- Seta variÿvel cEventBrowse com o valor "" ---*/
    ASSIGN cEventBrowse = "":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPageDown Include 
PROCEDURE applyPageDown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cEventBrowse = "PAGE-DOWN":U.
    
    ASSIGN rCurrentRow = IF AVAILABLE {&ttTable}
                            THEN ROWID({&ttTable})
                            ELSE ?.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPageUp Include 
PROCEDURE applyPageUp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cEventBrowse = "PAGE-UP":U.
    
    ASSIGN rCurrentRow = IF AVAILABLE {&ttTable}
                            THEN ROWID({&ttTable})
                            ELSE ?.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyValueChanged Include 
PROCEDURE applyValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(onValueChanged) &THEN
        RUN {&onValueChanged} NO-ERROR.
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRecord Include 
PROCEDURE createRecord PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE {&ttTable}.
    BUFFER-COPY ttTableAux TO {&ttTable}.
    &IF DEFINED(afterCreateRecord) &THEN
        RUN {&afterCreateRecord} NO-ERROR.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertNewRow Include 
PROCEDURE insertNewRow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    RUN repositionRecord IN {&hDBOTable} (INPUT p-rowid).
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE ttTableAux).
    FOR FIRST ttTableAux:
        RUN createRecord.
    END.
    IF AVAIL {&ttTable} THEN DO:
        p-rowid = ROWID({&ttTable}).
        {&OPEN-QUERY-{&BrowseName}}
        REPOSITION {&BrowseName} TO ROWID p-rowid NO-ERROR.
        {&BrowseName}:REFRESH() IN FRAME {&FRAME-NAME}.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRow Include 
PROCEDURE updateRow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    RUN repositionRecord IN {&hDBOTable} (INPUT p-rowid).
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE ttTableAux).
    IF AVAIL {&ttTable} THEN 
        p-rowid = ROWID({&ttTable}).
    ELSE p-rowid = ?.

    FOR FIRST ttTableAux,
        FIRST {&ttTable}
        WHERE {&ttTable}.r-rowid = ttTableAux.r-rowid:
        BUFFER-COPY ttTableAux TO {&ttTable}.
    END.

    IF p-rowid NE ? THEN DO:
        {&OPEN-QUERY-{&BrowseName}}
        REPOSITION {&BrowseName} TO ROWID p-rowid NO-ERROR.
        {&BrowseName}:REFRESH() IN FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

