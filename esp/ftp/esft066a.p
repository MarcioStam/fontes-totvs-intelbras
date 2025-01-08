TRIGGER PROCEDURE FOR WRITE OF nfe.

/*
01 - NF-e nao gerada
02 - Em processamento no EAI
03 - Uso autorizado
04 - Uso denegado
05 - Documento rejeitado
06 - Documento cancelado
07 - Documento inutilizado
08 - Em processamento no aplicativo de transmissao
09 - EM processamento na SEFAZ
10 - Em processamento no SCAN
11 - NF-e Gerada
*/

DEFINE TEMP-TABLE param-nfe NO-UNDO
    FIELD cod-estabel   AS CHAR
    FIELD e-mail        AS CHAR.

DEFINE TEMP-TABLE ext-emitente NO-UNDO
    FIELD cod-emitente  AS INTEGER
    FIELD email-xml     AS CHAR.

{include/i-prgvrs.i TWDI020 2.00.00.001}
 
/** N∆o elimine a linha abaixo, Ç o indicador de vers∆o do gatilho **/
def var c-versao-mg97   as char init "01.00.00" no-undo.


/*assign NFE.nr-nota-fis = string(int(NFE.nr-nota-fis),"9999999") no-error.*/
{esp/ftp/esft066a.i}

.run progress/unifica.p.

FOR FIRST estabelec NO-LOCK 
    WHERE estabelec.cod-estabel = NFE.cod-estabel.
    
    FOR FIRST nota-fiscal EXCLUSIVE-LOCK
        where nota-fiscal.cod-estabel = ESTABELEC.COD-ESTABEL   
          AND nota-fiscal.serie       = NFE.SERIE               
          AND nota-fiscal.nr-nota-fis = NFE.nr-nota-fis:              

        ASSIGN nota-fiscal.IDI-SIT-NF-ELETRO = NFE.ACAO.

        FOR FIRST docum-est exclusive-lock
            where docum-est.serie-docto  = nota-fiscal.serie
              and docum-est.nro-docto    = nota-fiscal.nr-nota-fis
              and docum-est.cod-emitente = nota-fiscal.cod-emitente
              and docum-est.nat-operacao = nota-fiscal.nat-operacao.
            ASSIGN docum-est.idi-sit-nf-eletro = NFE.ACAO.
        END.

        CASE NFE.ACAO.
            WHEN 01 THEN DO: /* NF-e nao gerada                               */
            END.
            WHEN 02 THEN DO: /* Em processamento no EAI                       */
            END.
            WHEN 03 THEN DO: /* Uso autorizado                                */
/*                 run piAtualizaCE. */
/*                 run piAtualizaCR. */
                run piEnviaEmail.
/*                 run piAtualizaOF.  */
                if avail nota-fiscal and nfe.protocolo <> "" and nfe.protocolo <> "?" THEN
                    assign nota-fiscal.cod-protoc = nfe.protocolo .
                RUN piLog.    
            END.
            WHEN 04 THEN DO: /* Uso denegado                                  */
                RUN piLog.            
            END.
            WHEN 05 THEN DO: /* Documento rejeitado                           */
                RUN piLog.            
            END.
            WHEN 06 THEN DO: /* Documento cancelado                           */
                if avail nota-fiscal and nfe.protocolo <> "" and nfe.protocolo <> "?" THEN
                    assign nota-fiscal.cod-protoc = nfe.protocolo .
                RUN piLog.                    
            END.
            WHEN 07 THEN DO: /* Documento inutilizado                         */
                if avail nota-fiscal and nfe.protocolo <> "" and nfe.protocolo <> "?" THEN
                    assign nota-fiscal.cod-protoc = nfe.protocolo .
                RUN piLog.                    
            END.
            WHEN 08 THEN DO: /* Em processamento no aplicativo de transmissao */
            END.
            WHEN 09 THEN DO: /* EM processamento na SEFAZ                     */
            END.
            WHEN 10 THEN DO: /* Em processamento no SCAN                      */
            END.
            WHEN 11 THEN DO: /* NF-e Gerada                                   */
                RUN piLog.            
            END.
        END CASE.    
        
    END.
END.
/** N∆o elimine a linha abaixo, Ç a chamada EPC **/
/*{include/i-epc101.i nfe b-old-nfe}*/
return "OK":U.

procedure piAtualizaCE.

    find natur-oper where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.
    if avail natur-oper and natur-oper.auto-ce then do:
        create tt-ft2100.
        assign 
            tt-ft2100.destino           = 2
            tt-ft2100.arquivo           = "CE" 
                                          + ESTABELEC.COD-ESTABEL
                                          + NFE.SERIE
                                          + NFE.nr-nota-fis
                                          + ".txt"
            tt-ft2100.usuario           = c-seg-usuario
            tt-ft2100.data-exec         = today
            tt-ft2100.hora-exec         = time
            tt-ft2100.tipo-atual        = 1   /* 1 - Atualiza, 2 - Desatualiza */
            tt-ft2100.c-desc-tipo-atual = "Atualiza"
            tt-ft2100.da-emissao-ini    = nota-fiscal.dt-emis-nota
            tt-ft2100.da-emissao-fim    = nota-fiscal.dt-emis-nota
            tt-ft2100.da-saida          = ?
            tt-ft2100.da-vencto-ipi     = today
            tt-ft2100.da-vencto-icms    = today
            tt-ft2100.da-vencto-iss     = today
            tt-ft2100.c-estabel-ini     = nota-fiscal.cod-estabel
            tt-ft2100.c-estabel-fim     = nota-fiscal.cod-estabel
            tt-ft2100.c-serie-ini       = nota-fiscal.serie
            tt-ft2100.c-serie-fim       = nota-fiscal.serie
            tt-ft2100.c-nr-nota-ini     = nota-fiscal.nr-nota-fis
            tt-ft2100.c-nr-nota-fim     = nota-fiscal.nr-nota-fis
            tt-ft2100.i-embarque-ini    = nota-fiscal.cdd-embarq
            tt-ft2100.i-embarque-fim    = nota-fiscal.cdd-embarq
            tt-ft2100.c-preparador      = ""
            tt-ft2100.l-disp-men        = no
            tt-ft2100.l-b2b             = no
            tt-ft2100.log-1             = no.

        raw-transfer tt-ft2100 to raw-param.
        run ftp/ft2100rp.p (input raw-param,
                            input table tt-raw-digita).
        {include/i-rpexc.i}
    end.

end procedure.

procedure piAtualizaOF.

    find natur-oper where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.
    if avail natur-oper and natur-oper.auto-ct then do:
        create tt-ft0604.
        assign 
            tt-ft0604.destino         = 2
            tt-ft0604.arquivo         = session:temp-directory 
                                        + "OF" 
                                        + ESTABELEC.COD-ESTABEL
                                        + NFE.SERIE
                                        + NFE.nr-nota-fis
                                        + ".txt"
            tt-ft0604.usuario         = c-seg-usuario
            tt-ft0604.data-exec       = today
            tt-ft0604.da-periodo-ini  = today
            tt-ft0604.da-periodo-fim  = today
            tt-ft0604.c-estabel-ini   = nota-fiscal.cod-estabel
            tt-ft0604.c-estabel-fim   = nota-fiscal.cod-estabel
            tt-ft0604.rs-tipo-nota    = 2
            tt-ft0604.rs-data-atualiz = 1
            tt-ft0604.tg-serie-padrao = no.
        
        raw-transfer tt-ft0604 to raw-param.
        run ftp/ft0604rp.p (input raw-param,
                            input table tt-raw-digita).
        {include/i-rpexc.i}
    end.
        
end procedure.

procedure piAtualizaCR.

    find natur-oper where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.
    if avail natur-oper and natur-oper.auto-cr then do:
        create tt-ft0603.
        assign 
            tt-ft0603.destino         = 2
            tt-ft0603.arquivo         = session:temp-directory 
                                        + "CR" 
                                        + ESTABELEC.COD-ESTABEL
                                        + NFE.SERIE
                                        + NFE.nr-nota-fis
                                        + ".txt"
            tt-ft0603.usuario         = c-seg-usuario
            tt-ft0603.data-exec       = today
            tt-ft0603.hora-exec       = time
            tt-ft0603.classifica      = 1
            tt-ft0603.da-emis-ini     = today
            tt-ft0603.da-emis-fim     = today
            tt-ft0603.c-estabel-ini   = nota-fiscal.cod-estabel
            tt-ft0603.c-serie-ini     = nota-fiscal.serie
            tt-ft0603.c-serie-fim     = nota-fiscal.serie
            tt-ft0603.c-nota-fis-ini  = nota-fiscal.nr-nota-fis
            tt-ft0603.c-nota-fis-fim  = nota-fiscal.nr-nota-fis
            tt-ft0603.i-embarque-ini  = 0
            tt-ft0603.i-embarque-fim  = 999999
            tt-ft0603.i-cod-portador  = nota-fiscal.cod-portador
            tt-ft0603.rs-gera-titulo  = 1
            tt-ft0603.desc-titulo     = "Gera para Endereco de Entrega"
            tt-ft0603.i-pais          = i-pais-impto-usuario
            tt-ft0603.c-estabel-fim   = nota-fiscal.cod-estabel
            tt-ft0603.c-arquivo-exp   = "spool\lin-i-cr.d".

        raw-transfer tt-ft0603 to raw-param.
        run ftp/ft0603rp.p (input raw-param,
                            input table tt-raw-digita).

        {include/i-rpexc.i}
      
    end.

end procedure.

procedure piEnviaEmail.
    find first param-global no-lock no-error.
    FOR FIRST estabelec NO-LOCK
        where estabelec.cod-estabel = nfe.cod-estabel.

        find first param-nfe no-lock 
            WHERE param-nfe.cod-estabel = estabelec.cod-estabel no-error.

        if avail param-nfe and param-nfe.e-mail <> "" then do:
            
            if avail estabelec then do:
                find ext-emitente where ext-emitente.cod-emitente = nota-fiscal.cod-emitente no-lock no-error.
                if avail ext-emitente and ext-emitente.email-xml <> "" then do:
                    
                    CREATE tt-envio.
                    assign 
                        tt-envio.versao-integracao = 1
                        tt-envio.exchange          = param-global.log-1
                        tt-envio.servidor          = param-global.serv-mail
                        tt-envio.porta             = param-global.porta-mail
                        tt-envio.destino           = ext-emitente.email-xml
                        tt-envio.assunto           = "NFe GERADA"
                        tt-envio.remetente         = param-nfe.e-mail
                        tt-envio.mensagem          = "NFe Gerada. " + nota-fiscal.nr-nota-fis
                        tt-envio.importancia       = 2
                        tt-envio.log-enviada       = no
                        tt-envio.log-lida          = no
                        tt-envio.acomp             = no
                        tt-envio.arq-anexo         = ''.
                    
                    /* API de envio de e-mail */
                    run utp/utapi009.p (input  table tt-envio,
                                        output table tt-erros).
    
                    /* Elimina a tabela tempor†ria para o envio do e-mail */
                    delete tt-envio.
                    output to value(session:temp-directory  + "EMAIL" + ESTABELEC.COD-ESTABEL + NFE.SERIE + NFE.nr-nota-fis + ".txt").
                    for each tt-erros:
                        disp tt-erros with stream-io width 512 down.
                        down.
                    end.
                    output close.
                end.
            end.
        end.
    END.
end procedure.

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.


procedure piLog.

/*     CREATE ret-nf-eletro.                                                                 */
/*     ASSIGN ret-nf-eletro.cod-estabel = estabelec.cod-estabel   NO-ERROR.                  */
/*     ASSIGN ret-nf-eletro.cod-serie   = nota-fiscal.serie       NO-ERROR.                  */
/*     ASSIGN ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.                  */
/*     ASSIGN ret-nf-eletro.cod-msg     = nfe.cod-msg NO-ERROR.                              */
/*     ASSIGN ret-nf-eletro.cod-protoc  = nfe.protocolo NO-ERROR.                            */
/*     ASSIGN ret-nf-eletro.dat-ret     = TODAY NO-ERROR.                                    */
/*     ASSIGN ret-nf-eletro.hra-ret     = REPLACE(STRING(TIME, "HH:MM:SS"),":","") NO-ERROR. */
/*     ASSIGN ret-nf-eletro.log-ativo   = YES NO-ERROR.                                      */
/*     ASSIGN nota-fiscal.cod-chave-aces-nf-eletro = nfe.ds-chave NO-ERROR.                  */
/*     FOR FIRST docum-est                                                                   */
/*         WHERE docum-est.serie-docto  = nota-fiscal.serie                                  */
/*           AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis                            */
/*           AND docum-est.cod-emitente = nota-fiscal.cod-emitente                           */
/*           AND docum-est.nat-operacao = nota-fiscal.nat-operacao EXCLUSIVE-LOCK:           */
/*         ASSIGN docum-est.cod-chave-aces-nf-eletro = nfe.ds-chave.                         */
/*     END.                                                                                  */

end procedure.
