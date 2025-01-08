/************************************************************
* Include para implementar a seguranáa por estabelecimento 
*
* 1.00.00.000 - 09/12/2014 - Jaime - Criada a include
************************************************************/

&IF DEFINED(DYNAMIC-QUERY-ENABLED) = 0 &THEN
    &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED NO
&ENDIF 

&IF DEFINED(SEGUR-ESTAB-NOTFIND-MES) = 0 AND (DEFINED(BROWSE-NAME) > 0 OR DEFINED(QUERY-NAME) > 0) &THEN
    &GLOBAL-DEFINE SEGUR-ESTAB-NOTFIND-MES TRUE
&ELSE    
    &GLOBAL-DEFINE SEGUR-ESTAB-NOTFIND-MES FALSE
&ENDIF 

/*possiveis nomes de query*/
&IF DEFINED(BROWSE-NAME) > 0 &THEN
    &GLOBAL-DEFINE MY-QUERY {&BROWSE-NAME}
&ELSEIF DEFINED(QUERY-NAME) > 0 &THEN
    &GLOBAL-DEFINE MY-QUERY {&QUERY-NAME}
&ELSEIF DEFINED(QUERYNAME) > 0 &THEN
    &GLOBAL-DEFINE MY-QUERY {&QUERYNAME}    
&ENDIF    

/*possiveis nomes de tabela*/
&IF DEFINED(FIRST-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
    &GLOBAL-DEFINE MY-TABLE {&FIRST-TABLE-IN-QUERY-{&MY-QUERY}}
&ELSEIF DEFINED(TABLE-NAME) > 0 &THEN
    &GLOBAL-DEFINE MY-TABLE {&TABLE-NAME}
&ELSEIF DEFINED(TABLENAME) > 0 &THEN
    &GLOBAL-DEFINE MY-TABLE {&TABLENAME}    
&ENDIF 

/*
caso o programa n∆o tenha um reposition procedure definida
atribui como procedure a default repositionEstab
*/

&IF DEFINED(REPOSITION-PROCEDURE) = 0 &THEN
    &GLOBAL-DEFINE REPOSITION-PROCEDURE repositionEstab
&ENDIF     

/*
caso o programa n∆o tenha um reposition procedure diferente
atribui como procedure a default repositionEstab
*/

&IF DEFINED(SEGUR-ESTAB-ATRIBUTE) = 0 &THEN
    &GLOBAL-DEFINE SEGUR-ESTAB-ATRIBUTE cod-estabel
&ENDIF     


/********************************************************
Inicio validacoes
********************************************************/


&IF DEFINED(CHANGE-QUERY-TO-FIND) > 0 &THEN
    MESSAGE "O recurso de seguranáa de estabelecimento n∆o funciona com CHANGE-QUERY-TO-FIND.":U SKIP
        "Retire este c¢digo do fonte.":U
        VIEW-AS ALERT-BOX.
    STOP.

&ENDIF

&IF DEFINED(DEFINE-QUERY) = 0 AND DEFINED(SECOND-TABLE-IN-QUERY-{&MY-QUERY}) > 0 AND DEFINED(REPOSITION-PROCEDURE-KEY-PHRASE) = 0 &THEN
    MESSAGE "Quando tem uma segunda tabela na query deve ser definida a constante REPOSITION-PROCEDURE-KEY-PHRASE.":U SKIP
        "Defina em seu codigo fonte a constante REPOSITION-PROCEDURE-KEY-PHRASE com o conteudo da query que envolva as duas tabelas.":U
        VIEW-AS ALERT-BOX.
    STOP.

&ENDIF

/********************************************************
Fim validacoes
********************************************************/


&GLOBAL-DEFINE ESTAB-SEC-TT tt_estab_ems2
&GLOBAL-DEFINE ESTAB-SEC-TT-FIELD tt_estab_ems2.tta_cod_estab
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren    AS CHAR NO-UNDO FORMAT "x(12)":U .
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren_old    AS CHAR NO-UNDO FORMAT "x(12)":U .
DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario   AS CHAR NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario_old   AS CHAR NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dialet_corren   AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-segur-estab-code    AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-segur-estab         AS LOGICAL NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE {&ESTAB-SEC-TT} NO-UNDO
    FIELD tta_cod_estab AS CHARACTER FORMAT "x(5)" LABEL "Estabelecimento" COLUMN-LABEL "Estab".
 
DEF VAR c-estab-security-Cript  AS CHAR NO-UNDO.
DEF VAR l-estab-security-active AS LOG NO-UNDO INIT FALSE. 


IF NOT CAN-FIND(FIRST {&ESTAB-SEC-TT}) /*se n∆o inicalizou a temp-table*/
    OR v_cod_usuar_corren <> v_cod_usuar_corren_old /*ou se o usuario for diferente*/
    OR i-ep-codigo-usuario <> i-ep-codigo-usuario_old /*ou se a empresa for diferente*/
    THEN DO:
    ASSIGN 
        g-segur-estab = FALSE
        i-ep-codigo-usuario_old = i-ep-codigo-usuario
        v_cod_usuar_corren_old  = v_cod_usuar_corren.
    EMPTY TEMP-TABLE {&ESTAB-SEC-TT}.
    RUN cdp/cd9150e.p.
END.

ASSIGN c-estab-security-Cript = v_cod_usuar_corren + v_cod_dialet_corren.
IF ENCODE(c-estab-security-Cript) = g-segur-estab-code THEN 
    ASSIGN l-estab-security-active = NO.
ELSE 
    ASSIGN l-estab-security-active = YES.
IF l-estab-security-active = YES THEN DO:
    FOR EACH {&ESTAB-SEC-TT} NO-LOCK:
        ASSIGN c-estab-security-Cript = c-estab-security-Cript + {&ESTAB-SEC-TT-FIELD}.
    END.
    IF ENCODE(c-estab-security-Cript) <> g-segur-estab-code THEN DO:
        EMPTY TEMP-TABLE {&ESTAB-SEC-TT}.
        IF LOG-MANAGER:LOGFILE-NAME <> ? THEN LOG-MANAGER:WRITE-MESSAGE("Falha na seguranca por estabelecimento":U).
    END.
END.






/********************************************************
Definiá∆o da query para seguranáa por estabelecimento.
Caso a constante DEFINE-QUERY esteja definida no programa 
chamador, com qualquer valor, nao faz o DEFINE-QUERY o que 
permite criar uma query diferente da query padrao
********************************************************/
&IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
&IF DEFINED(DEFINE-QUERY) = 0 &THEN 
&IF DEFINED(TTONLY) = 0 &THEN 
/*Se a constante DEFINE-QUERY n∆o estiver criada j† faz a definiá∆o da query*/
/*se estiver dentro do UIB n∆o define a query*/
/*se der erro nesse ponto comente a definiá∆o da query no fonte de seu programa*/


    &IF DEFINED(FIFTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
        DEFINE QUERY {&MY-QUERY} FOR {&ESTAB-SEC-TT}, {&MY-TABLE}, {&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}, {&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}, {&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}}, {&FIFTH-TABLE-IN-QUERY-{&MY-QUERY}} SCROLLING.
    &ELSE
    &IF DEFINED(FOURTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
        DEFINE QUERY {&MY-QUERY} FOR {&ESTAB-SEC-TT}, {&MY-TABLE}, {&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}, {&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}, {&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}} SCROLLING.
    &ELSE
    &IF DEFINED(THIRD-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN    
        DEFINE QUERY {&MY-QUERY} FOR {&ESTAB-SEC-TT}, {&MY-TABLE}, {&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}, {&THIRD-TABLE-IN-QUERY-{&MY-QUERY}} SCROLLING.
    &ELSE
    &IF DEFINED(SECOND-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
        DEFINE QUERY {&MY-QUERY} FOR {&ESTAB-SEC-TT}, {&MY-TABLE}, {&SECOND-TABLE-IN-QUERY-{&MY-QUERY}} SCROLLING.
    &ELSE
        DEFINE QUERY {&MY-QUERY} FOR {&ESTAB-SEC-TT}, {&MY-TABLE} SCROLLING.
    &ENDIF
    &ENDIF
    &ENDIF
    &ENDIF

    
&ENDIF
&ENDIF
&ENDIF


/********************************************************
Definiá∆o de parte da clausula do open-query para seguranáa 
por estabelecimento. 
Uma query para seguranáa ativa QUERY-ESTAB-AT outra para
seguranáa inativa QUERY-ESTAB-IN caso estas constantes
ja estiverem defininas no programa principal n∆o sobrepoe
o valor o que permite fazer uma query diferente da query padrao
********************************************************/

&IF DEFINED(QUERY-ESTAB-AT) = 0 &THEN
    &GLOBAL-DEFINE QUERY-ESTAB-AT  FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&MY-TABLE} WHERE {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} = {&ESTAB-SEC-TT-FIELD} AND  
&ENDIF

&IF DEFINED(QUERY-ESTAB-IN) = 0 &THEN
    &GLOBAL-DEFINE QUERY-ESTAB-IN FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&MY-TABLE} WHERE 
&ENDIF

/*temporario*/
/*somente para debug
DEF VAR xxestabs AS CHAR NO-UNDO.
DEF VAR xxestabatu AS CHAR NO-UNDO.
ON CTRL-ALT-B ANYWHERE DO:
    ASSIGN xxestabs = "".
    FOR EACH tt_estab_ems2:
        ASSIGN xxestabs = xxestabs + tt_estab_ems2.tta_cod_estab + " ".
    END.
    IF AVAIL({&MY-TABLE}) THEN 
        ASSIGN xxestabatu = {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE}.
    ELSE 
        ASSIGN xxestabatu = "indispon°vel".

    MESSAGE "Estabel disp : " xxestabs SKIP 
            "Estabel atual: " xxestabatu
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
*/
/*temporario*/




&IF DEFINED(TTONLY) = 0 &THEN

&IF {&DYNAMIC-QUERY-ENABLED} = YES &THEN

    /*RUN {&REPOSITION-PROCEDURE}_QueryBuffer  (INPUT hQuery).*/
    PROCEDURE repositionEstab_QueryBuffer:

        DEFINE INPUT PARAM hQ     AS HANDLE NO-UNDO.

        hQ:SET-BUFFERS(BUFFER {&ESTAB-SEC-TT}:HANDLE, BUFFER {&MY-TABLE}:HANDLE) NO-ERROR.
    END PROCEDURE.
    
    /*RUN {&REPOSITION-PROCEDURE}_QueryPrepare (INPUT-OUTPUT cQueryPrepareClause).*/
    PROCEDURE repositionEstab_QueryPrepare:

        DEFINE INPUT PARAM cDQFieldList   AS CHAR NO-UNDO.
        DEFINE INPUT PARAM cDQWhereClause AS CHAR NO-UNDO.
        DEFINE INPUT PARAM cDQBYClause    AS CHAR NO-UNDO.
 
        DEF OUTPUT PARAM cQuery AS CHAR NO-UNDO.
        
        DEF VAR cSecurityConstraint AS CHAR NO-UNDO.
        
        /* Se nao existir _getSecurityConstraint continua da mesma forma */
        RUN getSecurityConstraint IN THIS-PROCEDURE
            (OUTPUT cSecurityConstraint) NO-ERROR.
        
        IF l-estab-security-active THEN DO:

            /* Prepara o FOR EACH */
            ASSIGN cQuery =
                /* FOR EACH -> Fixo */
                "FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&MY-TABLE} " + 
                /* FIELD LIST  */
                (IF cDQFieldList = "":U THEN "":U
                    ELSE "FIELDS (":U + cDQFieldList + ")":U) +
                /* WHERE Clause*/
                " WHERE {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} = {&ESTAB-SEC-TT-FIELD} " +
                (IF cSecurityConstraint = "":U AND cDQWhereClause = "":U THEN ""
                    /* WHERE */
                    ELSE " AND ":U +
                        /* SecurityConstraint */
                        (IF cSecurityConstraint = "":U THEN "":U 
                            ELSE "(":U + cSecurityConstraint + ")":U +
                                (IF cDQWhereClause = "":U THEN "" ELSE " AND ")) +
                        /* "Dynamic" Where Clause */
                        (IF cDQWhereClause = "":U THEN "" 
                            ELSE "(":U + cDQWhereClause + ")":U)
                ) + " ":U +
                /* BY */
                cDQBYClause + ' INDEXED-REPOSITION'.
        END.
        ELSE DO:

            /* Prepara o FOR EACH */
            ASSIGN cQuery =
                /* FOR EACH -> Fixo */
                "FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&MY-TABLE} " + 
                /* FIELD LIST  */
                (IF cDQFieldList = "":U THEN "":U
                    ELSE "FIELDS (":U + cDQFieldList + ")":U) +
                /* WHERE Clause*/
                (IF cSecurityConstraint = "":U AND cDQWhereClause = "":U THEN ""
                    /* WHERE */
                    ELSE " WHERE ":U +
                        /* SecurityConstraint */
                        (IF cSecurityConstraint = "":U THEN "":U 
                            ELSE "(":U + cSecurityConstraint + ")":U +
                                (IF cDQWhereClause = "":U THEN "" ELSE " AND ")) +
                        /* "Dynamic" Where Clause */
                        (IF cDQWhereClause = "":U THEN "" 
                            ELSE "(":U + cDQWhereClause + ")":U)
                ) + " ":U +
                /* BY */
                cDQBYClause + ' INDEXED-REPOSITION'.
        END.

        IF LOG-MANAGER:LOGFILE-NAME <> ? THEN LOG-MANAGER:WRITE-MESSAGE("Query " + cQuery ).	    
    
    END PROCEDURE.
&ENDIF

PROCEDURE repositionEstab /*{&REPOSITION-PROCEDURE}*/:
    DEFINE INPUT PARAM p-row-table AS ROWID NO-UNDO.    
    DEFINE OUTPUT PARAM rowid-array AS ROWID EXTENT 18 NO-UNDO.
    DEF VAR oldRowid AS ROWID NO-UNDO.
    IF AVAIL({&MY-TABLE}) THEN 
        ASSIGN oldRowid = ROWID({&MY-TABLE}).
    ELSE 
        ASSIGN oldRowid = ?.


    
    
    &IF DEFINED(REPOSITION-PROCEDURE-KEY-PHRASE) > 0 &THEN
                                  
        FOR FIRST {&MY-TABLE} 
             WHERE ROWID({&MY-TABLE}) = p-row-table
             AND {&REPOSITION-PROCEDURE-KEY-PHRASE}:            
        END.
    &ELSE
        FIND FIRST {&MY-TABLE} NO-LOCK 
             WHERE ROWID({&MY-TABLE}) = p-row-table NO-ERROR.
    
    &ENDIF




    IF l-estab-security-active THEN DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
             WHERE {&ESTAB-SEC-TT-FIELD} = {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
    END.
	
    IF AVAIL {&ESTAB-SEC-TT} AND avail {&MY-TABLE} /*aqui*/ THEN DO:
        ASSIGN 
            rowid-array[1] = ROWID({&ESTAB-SEC-TT})
            rowid-array[2] = p-row-table.    
        &IF DEFINED(SECOND-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
            IF AVAIL({&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                ASSIGN rowid-array[3] = ROWID({&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}).    
        &ENDIF        
        &IF DEFINED(THIRD-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
            IF AVAIL({&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                ASSIGN rowid-array[4] = ROWID({&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}).    
        &ENDIF        
        &IF DEFINED(FOURTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
            IF AVAIL({&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                ASSIGN rowid-array[5] = ROWID({&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}}).    
        &ENDIF   
        &IF DEFINED(FIFTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
            IF AVAIL({&FIFTH-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                ASSIGN rowid-array[6] = ROWID({&FIFTH-TABLE-IN-QUERY-{&MY-QUERY}}).    
        &ENDIF           

        RETURN "OK".
    END.
    ELSE DO:
        &IF {&SEGUR-ESTAB-NOTFIND-MES} = TRUE &THEN
            RUN pi-get-label.
            RUN utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value). 
        &ENDIF
        /*inicio logica para retornar ao registro anterior*/
        IF oldRowid <> ? THEN DO:


            &IF DEFINED(REPOSITION-PROCEDURE-KEY-PHRASE) > 0 &THEN                                          
                FOR FIRST {&MY-TABLE} 
                     WHERE ROWID({&MY-TABLE}) = oldRowid
                     AND {&REPOSITION-PROCEDURE-KEY-PHRASE}:                    
                END.
            &ELSE
                FIND FIRST {&MY-TABLE} NO-LOCK 
                     WHERE ROWID({&MY-TABLE}) = oldRowid NO-ERROR.
            
            &ENDIF


            IF l-estab-security-active THEN DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
                     WHERE {&ESTAB-SEC-TT-FIELD} = {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
            END.
        END.
        /*fim logica para retornar ao registro anterior*/
        IF AVAIL {&ESTAB-SEC-TT} AND avail {&MY-TABLE} THEN DO:
            ASSIGN 
                rowid-array[1] = ROWID({&ESTAB-SEC-TT})
                rowid-array[2] = oldRowid.    
                &IF DEFINED(SECOND-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
                    IF AVAIL({&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                        ASSIGN rowid-array[3] = ROWID({&SECOND-TABLE-IN-QUERY-{&MY-QUERY}}).    
                &ENDIF       
                &IF DEFINED(THIRD-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
                    IF AVAIL({&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                        ASSIGN rowid-array[4] = ROWID({&THIRD-TABLE-IN-QUERY-{&MY-QUERY}}).    
                &ENDIF        
                &IF DEFINED(FOURTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
                    IF AVAIL({&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                        ASSIGN rowid-array[5] = ROWID({&FOURTH-TABLE-IN-QUERY-{&MY-QUERY}}).    
                &ENDIF   
                &IF DEFINED(FIFTH-TABLE-IN-QUERY-{&MY-QUERY}) > 0 &THEN
                    IF AVAIL({&FIFTH-TABLE-IN-QUERY-{&MY-QUERY}}) THEN
                        ASSIGN rowid-array[6] = ROWID({&FIFTH-TABLE-IN-QUERY-{&MY-QUERY}}).    
                &ENDIF                     
            RETURN "OK".
        END.
        ELSE DO:        
            ASSIGN ERROR-STATUS:ERROR = NO. /*CORRIGE O ERRO DE STATUS PARA N«O APRESENTAR A MSG 16690*/
            ASSIGN 
                rowid-array[1] = ?    
                rowid-array[2] = ?
                rowid-array[3] = ?
                rowid-array[4] = ?    
                rowid-array[5] = ?
                rowid-array[6] = ?.
            /*RETURN "ADM-ERROR".*/
            RETURN "NOK".
        END.
    END.
END PROCEDURE.

PROCEDURE pi-get-label:
    DEFINE VARIABLE hBuf AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cRet AS CHARACTER NO-UNDO.
    
    CREATE BUFFER hBuf FOR TABLE '{&MY-TABLE}'.
    RUN utp/ut-table.p (INPUT hBuf:DBNAME, 
                        INPUT hBuf:TABLE, 
                        INPUT 1). 
    hBuf:BUFFER-RELEASE().
    ASSIGN cRet = RETURN-VALUE.
    RETURN cRet.
    FINALLY:
        DELETE OBJECT hBuf NO-ERROR.
    END.
END PROCEDURE.

&ENDIF
