
DEFINE VARIABLE v_file AS CHARACTER   NO-UNDO.

ASSIGN v_file = SESSION:TEMP-DIRECTORY + "lista-cli-grp.txt".

OUTPUT TO VALUE(v_file).
FOR EACH int-emitente NO-LOCK:
    FIND emscad.cliente NO-LOCK
        WHERE cliente.cod_empresa = '1'
          AND cliente.cdn_cliente = int-emitente.cod-emitente NO-ERROR.
    IF AVAIL cliente 
       THEN PUT UNFORMATTED cliente.cdn_cliente ";" cliente.cod_grp_cli ";" int-emitente.cod-gr-cob SKIP.
END.
OUTPUT CLOSE.

MESSAGE "Arquivo Gerado: " + v_file
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
