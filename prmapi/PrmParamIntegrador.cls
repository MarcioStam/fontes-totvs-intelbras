USING Progress.Lang.*.
USING OpenEdge.Core.Collections.List.
USING OpenEdge.Core.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.PrmParamIntegrador:
    
    {prmapi/PrmParamIntegrador.i}
                
    CONSTRUCTOR PUBLIC PrmParamIntegrador():                
    END CONSTRUCTOR.    

    METHOD PUBLIC VOID Salvar(BUFFER b-tt-prm-param-integrador FOR tt-prm-param-integrador):
        
        FIND FIRST prm-param-integrador EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE(prm-param-integrador) THEN
            ValidateCreate(BUFFER b-tt-prm-param-integrador).
            
        ValidateUpdate(BUFFER b-tt-prm-param-integrador).
        
        IF NOT AVAILABLE(prm-param-integrador) THEN
            CREATE prm-param-integrador.
        
        BUFFER-COPY b-tt-prm-param-integrador TO prm-param-integrador.
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.           

    METHOD PUBLIC VOID ValidateUpdate(BUFFER b-tt-prm-param-integrador FOR tt-prm-param-integrador):
        
        IF NOT CAN-FIND(FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = b-tt-prm-param-integrador.cod-grp-usuar-cliente) THEN
            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Grupo de Usu†rio " + b-tt-prm-param-integrador.cod-grp-usuar-cliente + " n∆o encontrado",0).
            
        IF NOT CAN-FIND(FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = b-tt-prm-param-integrador.cod-grp-usuar-integracao) THEN
            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Grupo de Usu†rio " + b-tt-prm-param-integrador.cod-grp-usuar-integracao + " n∆o encontrado",0).
        
        IF NOT CAN-FIND(FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = b-tt-prm-param-integrador.cod-grp-usuar-int-recebimento) THEN
            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Grupo de Usu†rio " + b-tt-prm-param-integrador.cod-grp-usuar-int-recebimento + " n∆o encontrado",0).

        IF NOT CAN-FIND(FIRST gr-cli WHERE gr-cli.cod-gr-cli = b-tt-prm-param-integrador.cod-gr-cli-pj) THEN
            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Grupo de Cliente " + STRING(b-tt-prm-param-integrador.cod-gr-cli-pj) + " n∆o encontrado",0).
        
        IF NOT CAN-FIND(FIRST gr-cli WHERE gr-cli.cod-gr-cli = b-tt-prm-param-integrador.cod-gr-cli-pf) THEN
            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Grupo de Cliente " + STRING(b-tt-prm-param-integrador.cod-gr-cli-pf) + " n∆o encontrado",0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC VOID ValidateCreate(BUFFER b-tt-prm-param-integrador FOR tt-prm-param-integrador):               
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.    

    DESTRUCTOR PUBLIC PrmParamIntegrador ( ):
    END DESTRUCTOR.

END CLASS.
