/**************************************************************************/
/* Objetivo.: Retornar se o estabelecimento tem integra‡Æo do FATURAMENTO */
/*            ativa com o WMS.                                            */
/* Autor....: Roger Marcelino Bruhn                                       */
/**************************************************************************/
    
DEF INPUT  PARAM p-estabel AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-wms-ativo   AS LOG  INIT NO NO-UNDO.
        
FOR FIRST ponto-programa NO-LOCK
  WHERE ponto-programa.nome-programa = "wm0260"
    AND ponto-programa.ponto         = 1:
  
    FOR EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
        IF  entry(1,conteudo-programa.conteudo, ",") = p-estabel THEN DO:
            ASSIGN  p-wms-ativo = YES.
            RETURN "OK".
        END.
        

    END.
END.

RETURN "OK".

