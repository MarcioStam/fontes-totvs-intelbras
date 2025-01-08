OUTPUT TO c:\temp\clientes_importados_automatiza.txt.
FOR EACH emitente 
    WHERE index(emitente.observacoes,"Importado da Automatiza") <> 0
    AND emitente.data-implant >= 01/01/14:
    FIND int-emitente
        WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    
    
    ASSIGN int-emitente.cod-gr-cob = 35.
    DISP AVAIL int-emitente emitente.cod-emitente emitente.cgc emitente.nome-emit SUBSTRING(emitente.observacoes,1,20) int-emitente.cod-gr-cob
        WITH WIDTH 400 64 DOWN.
END.
OUTPUT CLOSE.

                 
