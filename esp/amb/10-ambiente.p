DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

for first ponto-programa no-lock
  where ponto-programa.nome-programa = 'ambiente'
    and ponto-programa.ponto = 1,
  first conteudo-programa of ponto-programa exclusive-lock:
  assign conteudo-programa.conteudo = c-ambiente.
end.

for first ponto-programa no-lock
  where ponto-programa.nome-programa = 'ambiente'
    and ponto-programa.ponto = 2,
  first conteudo-programa of ponto-programa exclusive-lock:
  assign conteudo-programa.conteudo = STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS").
end.

FOR FIRST ponto-programa NO-LOCK
    WHERE ponto-programa.nome-programa = 'canais'
      AND ponto-programa.ponto = 1,
    FIRST conteudo-programa of ponto-programa EXCLUSIVE-LOCK:

    IF c-ambiente = "HOMOLOGACAO" THEN
        ASSIGN conteudo-programa.conteudo = '-WSDL http://esbhomo.intelbras.com.br:8088/?wsdl'.

    IF c-ambiente = "DESENVOLVIMENTO" THEN
        ASSIGN conteudo-programa.conteudo = '-WSDL http://esbdev.intelbras.com.br:8080/?wsdl'.
    
END.

FOR EACH servid_rpc EXCLUSIVE-LOCK:

    IF  c-ambiente = "HOMOLOGACAO" THEN DO:
        IF servid_rpc.cod_servid_rpc = "aserpte" THEN
            ASSIGN servid_rpc.log_servid_rpc_dispon = YES.
        ELSE
            ASSIGN servid_rpc.log_servid_rpc_dispon = NO.
    END.

    IF  c-ambiente = "DESENVOLVIMENTO" THEN DO:
        IF servid_rpc.cod_servid_rpc = "aserpdev" THEN
            ASSIGN servid_rpc.log_servid_rpc_dispon = YES.
        ELSE
            ASSIGN servid_rpc.log_servid_rpc_dispon = NO.
    END.

END.

FOR EACH aplicat_dtsul EXCLUSIVE-LOCK
   WHERE aplicat_dtsul.cod_servid_rpc <> '':

    IF  c-ambiente = "HOMOLOGACAO" THEN
        ASSIGN aplicat_dtsul.cod_servid_rpc = "aserpte".

    IF  c-ambiente = "DESENVOLVIMENTO" THEN
        ASSIGN aplicat_dtsul.cod_servid_rpc = "aserpdev".

END.

FOR EACH servid_exec exclusive-lock:

    IF  c-ambiente = "HOMOLOGACAO" THEN DO:
        IF servid_exec.cod_servid_exec = "HOMOLOGA" THEN
            ASSIGN servid_exec.log_servid_exec_dispon = YES.
        ELSE
            ASSIGN servid_exec.log_servid_exec_dispon = NO.
    END.

    IF  c-ambiente = "DESENVOLVIMENTO" THEN DO:
        IF servid_exec.cod_servid_exec = "TICDEV" THEN
            ASSIGN servid_exec.log_servid_exec_dispon = YES.
        ELSE
            ASSIGN servid_exec.log_servid_exec_dispon = NO.
    END.
END.

/* ** Altera a integra‡Æo para o endere‡o da base de TESTE do MES - PPI Multitask ***/
IF  c-ambiente = "HOMOLOGACAO"
OR  c-ambiente = "DESENVOLVIMENTO" THEN DO:
    FOR EACH param-cp EXCLUSIVE-LOCK:
        ASSIGN param-cp.des-url-ws = "http://10.1.3.111:4321/PcfIntegService".
    END.
END.


RETURN 'ok'.
