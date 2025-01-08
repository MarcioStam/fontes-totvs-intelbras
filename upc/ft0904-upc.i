/**************************************************************************************************
** FUNCAO.....: Busca handle de campo desejado
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
**
** PARAMETROS.: p-obj_vock   = Objetos a serem pesquisados. ex: "it-codigo,descricao"
**              p-frame_vock = Handle do frame para pesquisa
** RETORNO....: Handle dos objetos encontrados na mesma ordem de envio do campo p-obj_vock
** ATUALIZACAO: 06/01/2011
**************************************************************************************************/


FUNCTION fc-handle-obj RETURN CHARACTER (p-obj_vock AS CHAR, p-frame_vock AS WIDGET-HANDLE):
    
    DEF VAR wh-objeto_vock AS WIDGET-HANDLE NO-UNDO.
    
    wh-objeto_vock = p-frame_vock:FIRST-CHILD.
    
    DO WHILE VALID-HANDLE(wh-objeto_vock):
    
       IF  wh-objeto_vock:TYPE = "field-group" THEN DO:
           p-obj_vock = fc-handle-obj(p-obj_vock,wh-objeto_vock).
       END. 
       
       IF  wh-objeto_vock:TYPE = "frame" THEN DO:
           p-obj_vock = fc-handle-obj(p-obj_vock,wh-objeto_vock).
       END.
           
       IF  LOOKUP(wh-objeto_vock:NAME,p-obj_vock) <> 0 AND
           LOOKUP(wh-objeto_vock:NAME,p-obj_vock) <> ? THEN DO:
           ENTRY(LOOKUP(wh-objeto_vock:NAME,p-obj_vock),p-obj_vock) = STRING(wh-objeto_vock:HANDLE).
       END.
         
       wh-objeto_vock = wh-objeto_vock:NEXT-SIBLING.
    END.
        
    RETURN p-obj_vock.
END FUNCTION.
