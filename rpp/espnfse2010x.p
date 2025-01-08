/*****************************************************************************************************************************
# CHAMADA ESPECIFICA PARA CUSTOMIZAR ARQUIVO DE INTEGRACAO DO EMS COM CW NFSe                                                #
*****************************************************************************************************************************/
{rpp/espnfse2010.i}
    

DEF INPUT-OUTPUT PARAM TABLE FOR tt-rps.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-rps-item.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.
DEF INPUT PARAM TABLE FOR tt-param.
DEF INPUT PARAM h-this-procedure AS HANDLE.

DEF VAR c-email-destino AS CHAR NO-UNDO.

FOR EACH tt-rps:
 
    IF CAN-find(FIRST cont-emit no-lock                                                       
         where cont-emit.cod-emitente = tt-rps.cod-emitente                              
           and (cont-emit.nome        BEGINS 'NFE'                                            
            or cont-emit.nome         BEGINS 'NF-e')) THEN DO:                                
        ASSIGN c-email-destino = "".                                                          

        FOR each cont-emit no-lock                                                            
             where cont-emit.cod-emitente = tt-rps.cod-emitente                          
               and (cont-emit.nome        BEGINS 'NFE'                                        
                or cont-emit.nome         BEGINS 'NF-e'):                                     
            IF c-email-destino = "" THEN                                                      
               ASSIGN c-email-destino = trim(cont-emit.e-mail).                               
            ELSE                                                                              
               ASSIGN c-email-destino = trim(c-email-destino) + "," + trim(cont-emit.e-mail). 
        END.                  

    END.                                                                                     
    ELSE DO:                                                                                 
         find first emitente no-lock                                                        
              where emitente.cod-emitente = tt-rps.cod-emitente no-error.              
         ASSIGN c-email-destino = emitente.e-mail.  

    END.                                                                                     
     
    ASSIGN tt-rps.cli-email  = c-email-destino.

END.

RETURN "OK".
