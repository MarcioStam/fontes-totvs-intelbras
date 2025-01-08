/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte Ç de propriedade exclusiva da PRIME Consultoria, sua reproduá∆o parcial ou total por qualquer meio, s¢ poder† ser feita mediante autorizaá∆o expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmapi-emitente                                                                                                                                      **
** Data .........: Outubro de 2020                                                                                                                                      **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: API para criar emitente no datasul                                                                                                                   **
** Revis‰es **************************************************************************************************************************************************************
** Autor                Ver.   Data     Cliente     Solicitante     Descriá∆o                                                                                           **
** Alexandro Carvalho   00.001 13/10/20 Prime                       1) Desenvolvimento inicial do programa                                                              **
** Gabriel Poli         00.002 09/05/22 Prime                       1) Validaá∆o erro integraá∆o                                                                        **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

BLOCK-LEVEL ON ERROR UNDO,THROW.

{prmapi/prmapi-emitente.i}

/*--- Definiá∆o ParÉmetros ---*/
DEFINE INPUT PARAMETER TABLE FOR tt-emitente.
DEFINE INPUT PARAMETER TABLE FOR tt-loc-entr.
DEFINE OUTPUT PARAMETER TABLE FOR tt-achar-erros.
DEFINE OUTPUT PARAMETER p-rw-emitente AS ROWID   NO-UNDO.

/*--- Variaveis Globais ---*/
DEFINE TEMP-TABLE tt-emitente-int NO-UNDO LIKE tt-emitente.

/*--- Variaveis Locais ---*/

/*--- Inicio Execuá∆o ---*/
FOR EACH tt-emitente NO-LOCK:
    EMPTY TEMP-TABLE tt-achar-erros.

    FIND FIRST param_integr_ems WHERE ind_param_integr_ems = 'Clientes 2.00' NO-LOCK NO-ERROR.

    FIND FIRST mguni.pais WHERE mguni.pais.nome-pais = tt-emitente.pais NO-LOCK NO-ERROR.

    /* Remove caracteres do CPF / CNPJ */
    ASSIGN tt-emitente.cgc = REPLACE(REPLACE(REPLACE(tt-emitente.cgc,"/",""),"-",""),".","")
           tt-emitente.cep = REPLACE(REPLACE(tt-emitente.cep,'-',''),'.','').

    /* Valida o formato de CPF / CNPJ */
    IF tt-emitente.cgc <> "" THEN DO:
        IF LENGTH(tt-emitente.cgc) <> 11 AND LENGTH(tt-emitente.cgc) <> 14 THEN DO:
            CREATE tt-achar-erros.
            ASSIGN tt-achar-erros.cgc     = tt-emitente.cgc
                   tt-achar-erros.cd-erro = 17006
                   tt-achar-erros.msg     = 'Formato de CPF/CNPJ Inv†lido'.
        END.
    END.   
    
    ASSIGN tt-emitente.endereco = REPLACE(tt-emitente.endereco,"-","")
           tt-emitente.endereco-cob = REPLACE(tt-emitente.endereco-cob,"-","").    

    FIND FIRST gr-cli NO-LOCK
         WHERE gr-cli.cod-gr-cli = tt-emitente.cod-gr-cli NO-ERROR.
    IF NOT AVAILABLE gr-cli THEN DO:
        CREATE tt-achar-erros.
        ASSIGN tt-achar-erros.cgc     = tt-emitente.cgc
               tt-achar-erros.cd-erro = 17006
               tt-achar-erros.msg     = 'Grupo de Cliente N∆o Localizado ou Inv†lido.'.
    END.
    
    IF NOT CAN-FIND(FIRST tt-achar-erros) THEN DO:
        RUN pi-limpa-tt.
        RUN pi-executa.
    END.
END.

/*------------------------------------------- Procedures Internas --------------------------------------------*/
PROCEDURE pi-limpa-tt:
    EMPTY TEMP-TABLE tt-versao-integr.
    EMPTY TEMP-TABLE tt-erros-geral.
    EMPTY TEMP-TABLE tt-loc-entr.
    EMPTY TEMP-TABLE tt-dist-emitente.
    EMPTY TEMP-TABLE tt-emitente-int.
END PROCEDURE.

PROCEDURE pi-executa:

    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO. /*002*/

    BlkPiExecuta:
    DO TRANSACTION:
        CREATE tt-emitente-int.
        BUFFER-COPY tt-emitente TO tt-emitente-int.        

        CREATE tt-versao-integr.
        ASSIGN tt-versao-integr.cod-versao-integracao = 001
               tt-versao-integr.ind-origem-msg        = 01.
               
        CREATE tt-dist-emitente.
        ASSIGN tt-dist-emitente.cod-emitente               = tt-emitente-int.cod-emitente.
               tt-dist-emitente.log-libera-venda-sem-bonif = YES.                                      
               
        /*Realiza a criacao do cliente(tabela emitente) e retorna*/        
        RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                            OUTPUT TABLE tt-erros-geral,
                            INPUT  TABLE tt-emitente-int,
                            INPUT  TABLE tt-loc-entr,
                            INPUT  TABLE tt-dist-emitente). 

        /*002*/
        ASSIGN l-erro = FALSE.
        FOR EACH tt-erros-geral NO-LOCK.
            FIND FIRST cadast_msg NO-LOCK
                 WHERE cadast_msg.cdn_msg = tt-erros-geral.cod-erro NO-ERROR.
            IF AVAIL cadast_msg AND cadast_msg.idi_tip_msg = 1 THEN DO:
                ASSIGN l-erro = TRUE.
                LEAVE.
            END.
        END.
        /*FIM 002*/
    
        /*Retorna erros encontrados*/
        IF l-erro /*CAN-FIND(FIRST tt-erros-geral)*/ THEN DO: /*002*/
            FOR EACH tt-erros-geral:                                
                CREATE tt-achar-erros.
                ASSIGN tt-achar-erros.cgc     = tt-emitente-int.cgc
                       tt-achar-erros.cd-erro = tt-erros-geral.cod-erro
                       tt-achar-erros.msg     = tt-erros-geral.des-erro.
            END.
        END.
        ELSE DO:
            IF CAN-FIND(FIRST tt_retorno_clien_fornec_new2) THEN DO: 
                FOR EACH tt_retorno_clien_fornec_new2:
                    CREATE tt-achar-erros.
                    ASSIGN tt-achar-erros.cgc     = tt-emitente-int.cgc
                           tt-achar-erros.cd-erro = tt_retorno_clien_fornec_new2.ttv_num_mensagem
                           tt-achar-erros.msg     = "[REPRES] " + tt_retorno_clien_fornec_new2.ttv_des_mensagem.
                END.
    
                UNDO BlkPiExecuta, RETURN NO-APPLY.
            END. 
            ELSE DO:
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cgc = tt-emitente-int.cgc NO-ERROR.
                IF AVAILABLE emitente THEN DO:
                    /* Cria o Local de Entrega Padr∆o */
                    FIND FIRST loc-entr
                         WHERE loc-entr.nome-abrev  = tt-emitente-int.nome-abrev 
                         AND loc-entr.cod-entrega   = 'Padr∆o' NO-ERROR.
                    IF NOT AVAILABLE loc-entr THEN DO:
                        CREATE loc-entr.
                        ASSIGN loc-entr.cod-entrega     = 'Padr∆o'
                               loc-entr.nome-abrev      = tt-emitente-int.nome-abrev 
                               loc-entr.cod-emite       = tt-emitente-int.cod-emite
                               loc-entr.bairro          = tt-emitente-int.bairro-cob
                               loc-entr.endereco        = tt-emitente-int.endereco-cob
                               loc-entr.cidade          = tt-emitente-int.cidade-cob
                               loc-entr.estado          = tt-emitente-int.estado-cob
                               loc-entr.pais            = tt-emitente-int.pais-cob
                               loc-entr.cep             = tt-emitente-int.cep-cob
                               loc-entr.ins-estadual    = tt-emitente-int.ins-est-cob
                               loc-entr.cgc             = tt-emitente-int.cgc
                               loc-entr.cod-emite-entr  = tt-emitente-int.cod-emitente.
                    END.
                    ELSE DO:
                        ASSIGN loc-entr.bairro          = tt-emitente-int.bairro-cob
                               loc-entr.endereco        = tt-emitente-int.endereco-cob
                               loc-entr.cidade          = tt-emitente-int.cidade-cob
                               loc-entr.estado          = tt-emitente-int.estado-cob
                               loc-entr.pais            = tt-emitente-int.pais-cob
                               loc-entr.cep             = tt-emitente-int.cep-cob
                               loc-entr.ins-estadual    = tt-emitente-int.ins-est-cob
                               loc-entr.cgc             = tt-emitente-int.cgc
                               loc-entr.cod-emite-entr  = tt-emitente-int.cod-emitente.
                    END.                                        
                    
                    /*---- Atualiza EMS 5 ----*/                                   
                    RUN cdp/cd1608.p (INPUT tt-emitente-int.cod-emitente,
                                      INPUT tt-emitente-int.cod-emitente, 
                                      INPUT tt-emitente-int.identific,
                                      INPUT YES,
                                      INPUT 1, 
                                      INPUT 0,
                                      INPUT SESSION:TEMP-DIR + '/IntegraClienteEMS5.txt', 
                                      INPUT 'Arquivo',  
                                      INPUT '').  
                  
                    ASSIGN p-rw-emitente = ROWID(emitente).
                                             
                    /*IF ERROR-STATUS:ERROR THEN DO:                                                    
                        CREATE tt-achar-erros.
                        ASSIGN tt-achar-erros.cgc     = tt-emitente-int.cgc
                               tt-achar-erros.cd-erro = ERROR-STATUS:GET-NUMBER(1).
                               tt-achar-erros.msg     = ERROR-STATUS:GET-MESSAGE(1).                            
                        
                        UNDO BlkPiExecuta, RETURN NO-APPLY.
                    END. */                         
                    
                    IF (tt-emitente-int.e-mail <> "" AND tt-emitente-int.e-mail <> ?) THEN 
                        RUN pi-cria-cont-emit.                    
                END. 
            END. 
        END.
        
        CATCH erro AS Progress.Lang.Error :
            CREATE tt-achar-erros.
            ASSIGN tt-achar-erros.cgc     = tt-emitente-int.cgc
                   tt-achar-erros.cd-erro = erro:GetMessageNum(1).
                   tt-achar-erros.msg     = erro:GetMessage(1).          
        END CATCH.
    END. 
END PROCEDURE.

PROCEDURE pi-cria-cont-emit:
    DEFINE VARIABLE i-seq AS INTEGER NO-UNDO.

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-emitente-int.cod-emitente NO-LOCK NO-ERROR.
    IF AVAILABLE(emitente) THEN DO:
        FIND LAST cont-emit OF emitente NO-LOCK NO-ERROR.   
        IF AVAILABLE(cont-emit) THEN
            ASSIGN i-seq = (cont-emit.sequencia + 10).
        ELSE
            ASSIGN i-seq = 10.
       
        CREATE cont-emit.
        ASSIGN cont-emit.cod-emitente = emitente.Cod-Emitente
               cont-emit.sequencia    = i-seq
               cont-emit.nome         = emitente.nome-emit
               cont-emit.cargo        = ""
               cont-emit.area         = ""
               cont-emit.telefone     = ""
               cont-emit.ramal        = ""
               cont-emit.telefax      = ""
               cont-emit.ramal-fax    = ""
               cont-emit.e-mail       = TRIM(tt-emitente-int.e-mail)
               cont-emit.observacao   = "Implantado automaticamente pela integraá∆o de emitente"
               cont-emit.identific    = Emitente.Identific
               cont-emit.int-1        = 2.
    END.               
END PROCEDURE.

