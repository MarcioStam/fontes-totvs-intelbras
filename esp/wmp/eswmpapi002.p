DEF TEMP-TABLE ttTipoSeparacao NO-UNDO
    FIELD cod-tipo   AS CHAR FORMAT "X(12)"
    FIELD seq-tipo   AS INT  
    INDEX idx-1 IS PRIMARY UNIQUE cod-tipo.

DEF TEMP-TABLE tt-reqs NO-UNDO
    FIELD nr-requis AS CHAR FORMAT "X(16)"
    FIELD num-docto-transf LIKE docto-transf-depos.num-docto-transf
    FIELD id-docto LIKE docto-transf-depos.id-docto
    FIELD tipo     AS CHARACTER FORMAT "X(1)"
    INDEX id IS PRIMARY UNIQUE id-docto.

DEFINE TEMP-TABLE ttWm-box-movto-idx-picking   NO-UNDO LIKE wm-box-movto
    FIELD val-prioridade AS INTEGER
    FIELD nr-pedcli      LIKE wm-docto-itens-ped.nr-pedcli
    FIELD nome-abrev     LIKE wm-docto-itens-ped.nome-abrev
    INDEX idx-prioridade nr-pedcli nome-abrev val-prioridade DESC.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

PROCEDURE getDoctosTarefa:

    DEF INPUT PARAM p-cod-estabel LIKE wm-local.cod-estabel  NO-UNDO.
    DEF INPUT PARAM p-cod-local   LIKE wm-local.cod-local    NO-UNDO.
    DEF INPUT PARAM p-cod-tipo    AS CHAR                    NO-UNDO.
    DEF INPUT PARAM p-cod-transp  AS CHAR                    NO-UNDO.
    DEF INPUT PARAM p-cod-equipto LIKE wm-equipamento.cod-equipamento NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-reqs.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEF VAR c-tipo              AS CHAR NO-UNDO.
    DEF VAR c-transp            AS CHAR NO-UNDO.
    DEF VAR l-acesso            AS LOG  NO-UNDO.
        
    EMPTY TEMP-TABLE tt-reqs.
    EMPTY TEMP-TABLE RowErrors.

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel = p-cod-estabel
           AND wm-local.cod-local   = p-cod-local NO-ERROR.
    IF  NOT AVAIL wm-local THEN DO:
        RUN piCreateError (INPUT 56,          /* ErrorNumber     */
                           INPUT "Local",     /* ErrorParameters */  
                           INPUT "EMS",       /* ErrorType       */
                           INPUT "ERROR").    /* ErrorSubType    */    
        RETURN "NOK":U.
    END.

    FOR EACH wm-docto NO-LOCK USE-INDEX wmsdocto-10
        WHERE wm-docto.cod-estabel      = wm-local.cod-estabel
          AND wm-docto.cod-local        = wm-local.cod-local
          AND wm-docto.ind-sit-docto    = 1 /* implantado */
          AND wm-docto.ind-tipo-trans   = 2
          /* AND wm-docto.cod-doca        <> 0 */:

        /* Verifica Equipamento Acesso */
        /* Verifica se Equipamento tem Acesso */
        ASSIGN l-acesso = NO.
        FOR EACH wm-box-movto OF wm-docto WHERE
            wm-box-movto.ind-status     <> 3 AND
            wm-box-movto.ind-tipo-movto =  2 NO-LOCK,
            FIRST wm-box OF wm-box-movto NO-LOCK:
            IF CAN-FIND(FIRST wm-equipamento-acesso WHERE
                        wm-equipamento-acesso.cod-equipamento = p-cod-equipto      AND
                        wm-equipamento-acesso.cod-estab       = wm-box.cod-estabel AND
                        wm-equipamento-acesso.cod-local       = wm-box.cod-local   AND 
                        wm-equipamento-acesso.cod-bloco       = wm-box.cod-bloco   AND 
                        wm-equipamento-acesso.cod-rua         = wm-box.cod-rua     AND 
                        wm-equipamento-acesso.cod-nivel       = wm-box.cod-nivel   NO-LOCK) THEN DO:
                ASSIGN l-acesso = YES.
                LEAVE.
            END.
        END.
        IF l-acesso = NO THEN
            NEXT.

        ASSIGN c-tipo   = ENTRY(2,wm-docto.num-docto,"-") NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            ASSIGN c-tipo = "".

        ASSIGN c-transp = ENTRY(2,wm-docto.num-docto-origem,"|") NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            ASSIGN c-transp = "".

        IF p-cod-transp <> c-transp AND c-transp <> "" AND c-transp <> ? THEN
            NEXT.

        IF p-cod-tipo = "Outros" AND 
           c-tipo <> "" AND c-tipo <> ? AND c-transp <> "" AND c-transp <> ? THEN DO:
            NEXT.
        END.
        ELSE IF p-cod-tipo <> "Outros"       AND
                p-cod-tipo <> "Sem UF"      AND
                p-cod-tipo <> c-tipo         THEN DO:
            NEXT.
        END.

        IF p-cod-tipo = "Sem UF" AND (wm-docto.ind-origem-docto <> 5 OR c-tipo <> "") THEN
            NEXT.

        IF p-cod-tipo = "Outros" AND wm-docto.ind-origem-docto = 5 THEN
            NEXT.

        CREATE tt-reqs.
        ASSIGN tt-reqs.id-docto  = wm-docto.id-docto
               tt-reqs.nr-requis = wm-docto.num-docto
               tt-reqs.tipo      = IF wm-docto.ind-origem-docto = 1 THEN "S"
                              ELSE IF wm-docto.ind-origem-docto = 4 THEN "E"
                              ELSE IF wm-docto.ind-origem-docto = 5 THEN "E"
                              ELSE IF wm-docto.ind-origem-docto = 6 THEN "T"
                              ELSE IF wm-docto.ind-origem-docto = 7 THEN "T"
                              ELSE "O". /* Sa°da manual ou outra */

    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE getMovtoTarefasDocto:

    DEFINE INPUT  PARAMETER pIdDocto             LIKE wm-docto.id-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pCodUsuario          LIKE wm-tarefa-docto.cod-usuario         NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEquipamento      LIKE wm-equipamento.cod-equipamento      NO-UNDO.
    DEFINE INPUT  PARAMETER pCdnTipoEquipamento  LIKE wm-equipamento.cdn-tipo-equipamento NO-UNDO.
    DEFINE INPUT  PARAMETER pCodTarefa           LIKE wm-tarefa-docto.cod-tarefa          NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttWm-box-movto-idx-picking.
    
    DEFINE VAR c-cod-rua1      LIKE wm-box.cod-rua   NO-UNDO.
    DEFINE VAR c-cod-rua2      LIKE wm-box.cod-rua   NO-UNDO.
    DEFINE VAR c-cod-nivel1    LIKE wm-box.cod-nivel NO-UNDO.
    DEFINE VAR c-cod-nivel2    LIKE wm-box.cod-nivel NO-UNDO.
    DEFINE VAR hDBOEquipAcesso AS HANDLE NO-UNDO.

    DEF BUFFER bfWm-box-movto FOR wm-box-movto.
    
    EMPTY TEMP-TABLE ttWm-box-movto-idx-picking.

    FIND FIRST WM-DOCTO WHERE WM-DOCTO.ID-DOCTO = PIDDOCTO NO-LOCK NO-ERROR.

    RUN pi-sugestao-docto.
        
    IF NOT VALID-HANDLE (hDBOEquipAcesso) THEN
        RUN scbo/bosc097.p PERSISTENT SET hDBOEquipAcesso.
    RUN openQueryStatic IN hDBOEquipAcesso (INPUT "Main":U) NO-ERROR.

    /* Procura tarefas n∆o iniciadas */
    FOR EACH wm-tarefa-docto-itens NO-LOCK 
        WHERE wm-tarefa-docto-itens.ind-status-tarefa-itens = 1 /* N∆o iniciado */ 
          AND wm-tarefa-docto-itens.id-docto                = pIdDocto
          AND wm-tarefa-docto-itens.cod-tarefa              = pCodTarefa          
          AND wm-tarefa-docto-itens.cdn-tipo-equipamento    = pCdnTipoEquipamento,
        EACH wm-box-movto NO-LOCK
            WHERE wm-box-movto.id-docto     = wm-tarefa-docto-itens.id-docto     
              AND wm-box-movto.id-movto     = wm-tarefa-docto-itens.id-movto     
              AND wm-box-movto.num-seq-item = wm-tarefa-docto-itens.num-seq-item:

        /* Se a tarefa estiver atribu°da a um usu†rio diferente do usu†rio enviado, n∆o considera. */
        IF  wm-tarefa-docto-itens.cod-usuario <> ""
        AND wm-tarefa-docto-itens.cod-usuario <> pCodUsuario THEN
            NEXT.

        /* Se a tarefa estiver atribu°da a um equipamento diferente do equipamento enviado, n∆o considera. */
        IF  wm-tarefa-docto-itens.cod-equipamento <> ""
        AND wm-tarefa-docto-itens.cod-equipamento <> pCodEquipamento THEN
            NEXT.

        FIND FIRST bfWm-box-movto 
            WHERE bfWm-box-movto.id-docto       = wm-tarefa-docto-itens.id-docto     
              AND bfWm-box-movto.id-movto       = wm-tarefa-docto-itens.id-movto     
              AND bfWm-box-movto.num-seq-item   = wm-tarefa-docto-itens.num-seq-item 
              AND bfWm-box-movto.ind-tipo-movto = 2  /* Sa°da */ NO-LOCK NO-ERROR.
        IF  NOT AVAIL bfWm-box-movto THEN
            NEXT.
            
        FIND FIRST wm-box 
            WHERE wm-box.cod-estabel = bfWm-box-movto.cod-estabel 
              AND wm-box.cod-local   = bfWm-box-movto.cod-local   
              AND wm-box.id-box      = bfWm-box-movto.id-box NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-box THEN
            NEXT.

        RUN validaAcessoEquip1Box IN hDBOEquipAcesso (INPUT pCodEquipamento,
                                                      INPUT wm-box.cod-rua,
                                                      INPUT wm-box.cod-nivel,
                                                      INPUT wm-box.cod-estabel,
                                                      INPUT wm-box.cod-local,
                                                      INPUT wm-box.cod-bloco).
        IF  RETURN-VALUE = "NOK":U THEN 
            NEXT.

        /* Validando se o acesso do Equipamento Ç pra ser desconsiderado */
        IF CAN-FIND(FIRST wm-equipamento-acesso WHERE
                    wm-equipamento-acesso.cod-equipamento = pCodEquipamento    AND
                    wm-equipamento-acesso.cod-estab       = wm-box.cod-estabel AND
                    wm-equipamento-acesso.cod-local       = wm-box.cod-local   AND
                    wm-equipamento-acesso.cod-bloco       = wm-box.cod-bloco   AND
                    wm-equipamento-acesso.cod-rua         = wm-box.cod-rua     AND
                    wm-equipamento-acesso.cod-nivel       = wm-box.cod-nivel   AND 
                    wm-equipamento-acesso.val-prioridade  = 999                NO-LOCK) THEN
            NEXT.
                
        CREATE ttWm-box-movto-idx-picking.
        BUFFER-COPY wm-box-movto TO ttWm-box-movto-idx-picking 
             ASSIGN ttWm-box-movto-idx-picking.val-prioridade = wm-tarefa-docto-itens.val-prioridade.

    END.
    
        
    /* Procura tarefas em processo */

    FOR EACH wm-tarefa-docto-itens NO-LOCK 
        WHERE wm-tarefa-docto-itens.ind-status-tarefa-itens = 2    /* Processo */ 
          AND wm-tarefa-docto-itens.id-docto                = pIdDocto
          AND wm-tarefa-docto-itens.cod-tarefa              = pCodTarefa
          AND wm-tarefa-docto-itens.cod-usuario             = pCodUsuario
          AND wm-tarefa-docto-itens.cdn-tipo-equipamento    = pCdnTipoEquipamento,
        EACH wm-box-movto NO-LOCK 
            WHERE wm-box-movto.id-docto     = wm-tarefa-docto-itens.id-docto     
              AND wm-box-movto.id-movto     = wm-tarefa-docto-itens.id-movto    
              AND wm-box-movto.num-seq-item = wm-tarefa-docto-itens.num-seq-item:

        FIND FIRST bfWm-box-movto 
            WHERE bfWm-box-movto.id-docto       = wm-tarefa-docto-itens.id-docto     
              AND bfWm-box-movto.id-movto       = wm-tarefa-docto-itens.id-movto     
              AND bfWm-box-movto.num-seq-item   = wm-tarefa-docto-itens.num-seq-item 
              AND bfWm-box-movto.ind-tipo-movto = 2  /* Sa°da */ NO-LOCK NO-ERROR.
        IF  NOT AVAIL bfWm-box-movto THEN 
            NEXT.
            
        FIND FIRST wm-box 
            WHERE wm-box.cod-estabel = bfWm-box-movto.cod-estabel 
              AND wm-box.cod-local   = bfWm-box-movto.cod-local   
              AND wm-box.id-box      = bfWm-box-movto.id-box NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-box THEN 
            NEXT.

        RUN validaAcessoEquip1Box IN hDBOEquipAcesso (INPUT pCodEquipamento,
                                                      INPUT wm-box.cod-rua,
                                                      INPUT wm-box.cod-nivel,
                                                      INPUT wm-box.cod-estabel,
                                                      INPUT wm-box.cod-local,
                                                      INPUT wm-box.cod-bloco).
        IF  RETURN-VALUE = "NOK":U THEN 
            NEXT.

        CREATE ttWm-box-movto-idx-picking.
        BUFFER-COPY wm-box-movto TO ttWm-box-movto-idx-picking 
        ASSIGN ttWm-box-movto-idx-picking.val-prioridade = wm-tarefa-docto-itens.val-prioridade.

    END.

    IF VALID-HANDLE(hDBOEquipAcesso) THEN DO:
        RUN DESTROY IN hDBOEquipAcesso.
        DELETE OBJECT hDBOEquipAcesso NO-ERROR.
    END.    

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-sugestao-docto:

    DEF VAR d-qtd-item-movto AS DECIMAL NO-UNDO.
    
    FOR EACH wm-docto-itens NO-LOCK
        WHERE wm-docto-itens.cod-estabel   = wm-docto.cod-estabel
        AND   wm-docto-itens.cod-local     = wm-docto.cod-local
        AND   wm-docto-itens.id-docto      = wm-docto.id-docto
        AND   wm-docto-itens.ind-sit-movto = 1:
        
        EMPTY TEMP-TABLE RowErrors.

        ASSIGN d-qtd-item-movto = 0.
        FOR EACH wm-box-movto NO-LOCK
            WHERE wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel 
              AND wm-box-movto.cod-local      = wm-docto-itens.cod-local  
              AND wm-box-movto.id-docto       = wm-docto-itens.id-docto   
              AND wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item
              AND wm-box-movto.ind-tipo-movto = 2:
            ASSIGN d-qtd-item-movto = d-qtd-item-movto + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
        END.
        
        IF  wm-docto-itens.qtd-item - d-qtd-item-movto > 0 THEN DO:
            run wmp/wm9020.p (INPUT  wm-docto-itens.qtd-item - d-qtd-item-movto,
                              INPUT  ROWID(wm-docto-itens),
                              OUTPUT TABLE RowErrors).
        END.
    END.

END PROCEDURE.

PROCEDURE getMovtoTarefasDoctoTransEnd :

    DEFINE INPUT  PARAMETER pCodUsuario          LIKE wm-tarefa-docto.cod-usuario         NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEquipamento      LIKE wm-equipamento.cod-equipamento      NO-UNDO.
    DEFINE INPUT  PARAMETER pCdnTipoEquipamento  LIKE wm-equipamento.cdn-tipo-equipamento NO-UNDO.
    DEFINE INPUT  PARAMETER pCodTarefa           LIKE wm-tarefa-docto.cod-tarefa          NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttWm-box-movto-idx-picking.
    
    DEFINE VAR c-cod-rua1      LIKE wm-box.cod-rua   NO-UNDO.
    DEFINE VAR c-cod-rua2      LIKE wm-box.cod-rua   NO-UNDO.
    DEFINE VAR c-cod-nivel1    LIKE wm-box.cod-nivel NO-UNDO.
    DEFINE VAR c-cod-nivel2    LIKE wm-box.cod-nivel NO-UNDO.
    DEFINE VAR hDBOEquipAcesso AS HANDLE NO-UNDO.

    DEF BUFFER bfWm-box-movto FOR wm-box-movto.

    EMPTY TEMP-TABLE ttWm-box-movto-idx-picking.

    IF NOT VALID-HANDLE (hDBOEquipAcesso) THEN
        RUN scbo/bosc097.p PERSISTENT SET hDBOEquipAcesso.
    RUN openQueryStatic IN hDBOEquipAcesso (INPUT "Main":U) NO-ERROR.

    /* Procura tarefas n∆o iniciadas */
    FOR EACH wm-tarefa-docto-itens NO-LOCK
        WHERE wm-tarefa-docto-itens.ind-status-tarefa-itens = 1 /* N∆o iniciado */ 
          AND wm-tarefa-docto-itens.cod-tarefa              = pCodTarefa          
          AND wm-tarefa-docto-itens.cdn-tipo-equipamento    = pCdnTipoEquipamento,
        FIRST wm-docto NO-LOCK
        WHERE wm-docto.cod-estabel = wm-tarefa-docto-itens.cod-estabel
          AND wm-docto.cod-local   = wm-tarefa-docto-itens.cod-local  
          AND wm-docto.id-docto    = wm-tarefa-docto-itens.id-docto   
          AND wm-docto.ind-origem-docto = 18,
        EACH wm-box-movto NO-LOCK
            WHERE wm-box-movto.id-docto     = wm-tarefa-docto-itens.id-docto     
              AND wm-box-movto.id-movto     = wm-tarefa-docto-itens.id-movto     
              AND wm-box-movto.num-seq-item = wm-tarefa-docto-itens.num-seq-item:

        /* Se a tarefa estiver atribu°da a um usu†rio diferente do usu†rio enviado, n∆o considera. */
        IF  wm-tarefa-docto-itens.cod-usuario <> ""
        AND wm-tarefa-docto-itens.cod-usuario <> pCodUsuario THEN
            NEXT.

        /* Se a tarefa estiver atribu°da a um equipamento diferente do equipamento enviado, n∆o considera. */
        IF  wm-tarefa-docto-itens.cod-equipamento <> ""
        AND wm-tarefa-docto-itens.cod-equipamento <> pCodEquipamento THEN
            NEXT.

        FIND FIRST bfWm-box-movto 
            WHERE bfWm-box-movto.id-docto       = wm-tarefa-docto-itens.id-docto     
              AND bfWm-box-movto.id-movto       = wm-tarefa-docto-itens.id-movto     
              AND bfWm-box-movto.num-seq-item   = wm-tarefa-docto-itens.num-seq-item 
              AND bfWm-box-movto.ind-tipo-movto = 2  /* Sa°da */ NO-LOCK NO-ERROR.
        IF  NOT AVAIL bfWm-box-movto THEN
            NEXT.

        FIND FIRST wm-box 
            WHERE wm-box.cod-estabel = bfWm-box-movto.cod-estabel 
              AND wm-box.cod-local   = bfWm-box-movto.cod-local   
              AND wm-box.id-box      = bfWm-box-movto.id-box NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-box THEN
            NEXT.
                
        RUN validaAcessoEquip1Box IN hDBOEquipAcesso (INPUT pCodEquipamento,
                                                      INPUT wm-box.cod-rua,
                                                      INPUT wm-box.cod-nivel,
                                                      INPUT wm-box.cod-estabel,
                                                      INPUT wm-box.cod-local,
                                                      INPUT wm-box.cod-bloco).
        IF  RETURN-VALUE = "NOK":U THEN 
            NEXT.
                
        CREATE ttWm-box-movto-idx-picking.
        BUFFER-COPY wm-box-movto TO ttWm-box-movto-idx-picking 
            ASSIGN ttWm-box-movto-idx-picking.val-prioridade = wm-tarefa-docto-itens.val-prioridade.
    END.
    
        
    /* Procura tarefas em processo */

    FOR EACH wm-tarefa-docto-itens NO-LOCK 
        WHERE wm-tarefa-docto-itens.ind-status-tarefa-itens = 2    /* Processo */ 
          AND wm-tarefa-docto-itens.cod-tarefa              = pCodTarefa
          AND wm-tarefa-docto-itens.cod-usuario             = pCodUsuario
          AND wm-tarefa-docto-itens.cdn-tipo-equipamento    = pCdnTipoEquipamento,
        FIRST wm-docto NO-LOCK
        WHERE wm-docto.cod-estabel = wm-tarefa-docto-itens.cod-estabel
          AND wm-docto.cod-local   = wm-tarefa-docto-itens.cod-local  
          AND wm-docto.id-docto    = wm-tarefa-docto-itens.id-docto   
          AND wm-docto.ind-origem-docto = 18,
        EACH wm-box-movto NO-LOCK 
            WHERE wm-box-movto.id-docto     = wm-tarefa-docto-itens.id-docto     
              AND wm-box-movto.id-movto     = wm-tarefa-docto-itens.id-movto    
              AND wm-box-movto.num-seq-item = wm-tarefa-docto-itens.num-seq-item:
            
        FIND FIRST bfWm-box-movto 
            WHERE bfWm-box-movto.id-docto       = wm-tarefa-docto-itens.id-docto     
              AND bfWm-box-movto.id-movto       = wm-tarefa-docto-itens.id-movto     
              AND bfWm-box-movto.num-seq-item   = wm-tarefa-docto-itens.num-seq-item 
              AND bfWm-box-movto.ind-tipo-movto = 2  /* Sa°da */ NO-LOCK NO-ERROR.
        IF  NOT AVAIL bfWm-box-movto THEN 
            NEXT.
            
        FIND FIRST wm-box 
            WHERE wm-box.cod-estabel = bfWm-box-movto.cod-estabel 
              AND wm-box.cod-local   = bfWm-box-movto.cod-local   
              AND wm-box.id-box      = bfWm-box-movto.id-box NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-box THEN 
            NEXT.
                
        RUN validaAcessoEquip1Box IN hDBOEquipAcesso (INPUT pCodEquipamento,
                                                      INPUT wm-box.cod-rua,
                                                      INPUT wm-box.cod-nivel,
                                                      INPUT wm-box.cod-estabel,
                                                      INPUT wm-box.cod-local,
                                                      INPUT wm-box.cod-bloco).
        IF  RETURN-VALUE = "NOK":U THEN 
            NEXT.
            
        CREATE ttWm-box-movto-idx-picking.
        BUFFER-COPY wm-box-movto TO ttWm-box-movto-idx-picking 
            ASSIGN ttWm-box-movto-idx-picking.val-prioridade = wm-tarefa-docto-itens.val-prioridade.
    END.

    IF VALID-HANDLE(hDBOEquipAcesso) THEN DO:
        RUN DESTROY IN hDBOEquipAcesso.
        DELETE OBJECT hDBOEquipAcesso NO-ERROR.
    END.    
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE retornaTipoSeparacao:

    DEF INPUT PARAM p-cod-estabel LIKE wm-local.cod-estabel              NO-UNDO.
    DEF INPUT PARAM p-cod-local   LIKE wm-local.cod-local                NO-UNDO.
    DEF INPUT PARAM p-cod-transp  LIKE transporte.nome-abrev             NO-UNDO.
    DEF INPUT PARAM p-cod-equipto LIKE wm-equipamento.cod-equipamento    NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR ttTipoSeparacao.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEF VAR c-tipo          AS CHAR         NO-UNDO.
    DEF VAR c-transp        AS CHAR         NO-UNDO.
    DEF VAR l-acesso        AS LOG          NO-UNDO.
        
    FOR EACH ttTipoSeparacao:
        DELETE ttTipoSeparacao.
    END.

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel = p-cod-estabel
           AND wm-local.cod-local   = p-cod-local NO-ERROR.
    IF  NOT AVAIL wm-local THEN DO:
        RUN piCreateError (INPUT 56,          /* ErrorNumber     */
                           INPUT "Local",     /* ErrorParameters */  
                           INPUT "EMS",       /* ErrorType       */
                           INPUT "ERROR").    /* ErrorSubType    */    
        RETURN "NOK":U.
    END.

    FOR EACH wm-docto NO-LOCK USE-INDEX wmsdocto-10
        WHERE wm-docto.cod-estabel      = wm-local.cod-estabel
          AND wm-docto.cod-local        = wm-local.cod-local
          AND wm-docto.ind-sit-docto    = 1 /* implantado */
          AND wm-docto.ind-tipo-trans   = 2:

        /* Verifica se Equipamento tem Acesso */
        ASSIGN l-acesso = NO.
        FOR EACH wm-box-movto OF wm-docto WHERE
            wm-box-movto.ind-status     <> 3 AND
            wm-box-movto.ind-tipo-movto =  2 NO-LOCK,
            FIRST wm-box OF wm-box-movto NO-LOCK:
            IF CAN-FIND(FIRST wm-equipamento-acesso WHERE
                        wm-equipamento-acesso.cod-equipamento = p-cod-equipto      AND
                        wm-equipamento-acesso.cod-estab       = wm-box.cod-estabel AND
                        wm-equipamento-acesso.cod-local       = wm-box.cod-local   AND 
                        wm-equipamento-acesso.cod-bloco       = wm-box.cod-bloco   AND 
                        wm-equipamento-acesso.cod-rua         = wm-box.cod-rua     AND 
                        wm-equipamento-acesso.cod-nivel       = wm-box.cod-nivel   NO-LOCK) THEN DO:
                ASSIGN l-acesso = YES.
                LEAVE.
            END.
        END.
        IF l-acesso = NO THEN
            NEXT.

        ASSIGN c-transp = ENTRY(2,wm-docto.num-docto-origem,"|") NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
            ASSIGN c-transp = "".

        IF (c-transp <> ? AND c-transp <> "") AND
            c-transp <> p-cod-transp  THEN
            NEXT.

        ASSIGN c-tipo =  ENTRY(2,wm-docto.num-docto,"-") NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            ASSIGN c-tipo = "".
        IF c-tipo <> ? AND c-tipo <> "" THEN DO:
            FIND FIRST ttTipoSeparacao
                 WHERE ttTipoSeparacao.cod-tipo = ENTRY(2,wm-docto.num-docto,"-") NO-ERROR.
            IF NOT AVAIL ttTipoSeparacao THEN DO:
                CREATE ttTipoSeparacao.
                ASSIGN ttTipoSeparacao.cod-tipo = ENTRY(2,wm-docto.num-docto,"-") NO-ERROR.
            END.
        END.
        ELSE IF c-tipo = ""  AND wm-docto.ind-origem-docto = 5 THEN DO:
            IF NOT CAN-FIND(FIRST ttTipoSeparacao WHERE
                            ttTipoSeparacao.cod-tipo = "Sem UF" NO-LOCK) THEN DO:
                CREATE ttTipoSeparacao.
                ASSIGN ttTipoSeparacao.cod-tipo = "Sem UF"
                       ttTipoSeparacao.seq-tipo = 998. 
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST ttTipoSeparacao WHERE
                            ttTipoSeparacao.cod-tipo = "Outros" NO-LOCK) THEN DO:
                CREATE ttTipoSeparacao.
                ASSIGN ttTipoSeparacao.cod-tipo = "Outros"
                       ttTipoSeparacao.seq-tipo = 999. 
            END.
        END.

    END.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    END.

    RETURN "OK":U.    

END PROCEDURE.
