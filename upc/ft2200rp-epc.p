/***********************************************************************
**  Programa..: UPC\FT2200-epc.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: MAR€O/2005 - Desenvolvimento
**  Descricao.: Envio de E-mail no cancelamento
**  VersÆo....: 001 31/03/2005
**                  Desenvolvimento Programa
compile \\tsclient\c\fontes\upc\ft2200rp-epc.p save into c:\temp\upc.
************************************************************************/
{include/i-epc200.i1}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

define stream arq-email.

{esapi/esapi010tt.i}
{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}
{utp/utapi019.i}

DEFINE TEMP-TABLE tt-mail-moura NO-UNDO
    FIELD email-moura AS CHAR
    FIELD r-nota-fiscal AS ROW.

/****************************  Variaveis    ****************************/
    
    /*FOR EACH tt-epc:
        MESSAGE 'pIndEvent             ' pIndEvent skip
                'tt-epc.cod-event      ' tt-epc.cod-event     skip
                'tt-epc.cod-parameter  ' tt-epc.cod-parameter 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
*/    

        

CASE pIndEvent:
    WHEN "ft2200rp" THEN DO:
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "ft2200rp"
            AND   tt-epc.cod-parameter = "nota-fiscal rowid":
            FIND FIRST nota-fiscal
                 WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL nota-fiscal AND nota-fiscal.dt-cancela <> ? THEN DO:

                IF nota-fiscal.cod-estabel = "105" THEN DO:
                    
                    FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK NO-ERROR.

                        FIND FIRST fat-ser-lote OF it-nota-fisc NO-LOCK NO-ERROR.

                        IF AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "EPE" THEN

                            RUN piEnviaEmailEntreposto.
                END.
                ELSE 
                   RUN piEnviaEmail.
                   /*baterias Moura*/
                   RUN pi-cria-tt-moura (ROWID(nota-fiscal)).
                   IF CAN-FIND (FIRST tt-mail-moura
                                WHERE tt-mail-moura.r-nota-fiscal = ROWID(nota-fiscal)) THEN DO:
                       
                       RUN run-envia-mail-moura.
                   END.
            END.
        END.
    END.
END CASE.

PROCEDURE piEnviaEmail:
    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cItens               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEF VAR i-nr-pedido LIKE ped-fiscal.nr-pedido.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

    FIND FIRST atendente NO-LOCK
         WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

    IF  AVAIL atendente
    AND atendente.email <> "" THEN DO:
        IF cDestinatarioEmail = "" THEN
            ASSIGN cDestinatarioEmail = atendente.email.
        ELSE
            ASSIGN cDestinatarioEmail = cDestinatarioEmail + ";" + atendente.email.
    END.
    
    RUN esp/es0018p.p (INPUT "ft2200rp", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    FOR EACH tt-prog-ponto:
        if entry(1, tt-prog-ponto.conteudo,";") = v_cod_estab_usuar THEN DO: 
            IF cDestinatarioEmail = "" THEN
                ASSIGN cDestinatarioEmail = ENTRY(2, tt-prog-ponto.conteudo,";").
            ELSE
                ASSIGN cDestinatarioEmail = cDestinatarioEmail + ";" + ENTRY(2, tt-prog-ponto.conteudo,";").
        END.
    END.
    
    find first ped-fiscal no-lock where
         ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.
    if avail ped-fiscal then
         assign i-nr-pedido = ped-fiscal.nr-pedido.
    else assign i-nr-pedido = 0.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
        ASSIGN cItens = cItens +
                        "ITEM: " + it-nota-fisc.it-codigo      + CHR(10) + 
                        "Unid neg: " + it-nota-fisc.cod-unid-negoc + CHR(10).
    END.
              
    ASSIGN cMensagem =  "Nota Cancelada" +                                    CHR(10) + 
                    "Estab: "         + nota-fiscal.cod-estabel          + CHR(10) + 
                    "Serie: "     + nota-fiscal.serie                + CHR(10) + 
                    "Cliente: "     + string(nota-fiscal.cod-emitente) + CHR(10) + 
                    "Numero: "     + string(nota-fiscal.nr-nota-fis)  + CHR(10) + 
                    "Pedido: "     + string(nota-fiscal.nr-pedcli)  + CHR(10) + 
                    "Natureza: "     + nota-fiscal.nat-operacao         + CHR(10) +
                    "Valor Total: "   + string(nota-fiscal.vl-tot-nota)  + CHR(10) + 
                    "Motivo: "     + nota-fiscal.desc-cancela         + CHR(10) +
                    cItens + CHR(10).

    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailCancNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = "Nota Fiscal Cancelada.: " + 
                                    nota-fiscal.serie + "/" +  
                                    string(nota-fiscal.nr-nota-fis) + 
                                    " - Pedido: " + STRING(nota-fiscal.nr-pedcli)
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        /*CHR(10) + CHR(10) + */

    /*
    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN*/
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    /*
    FOR EACH tt-erro:
        MESSAGE tt-erro.mensagem
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    */
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.

PROCEDURE pi-cria-tt-moura:
    DEFINE INPUT PARAM p-row-nota AS ROWID.
    DEFINE BUFFER b-item-moura FOR ITEM.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE rowid(nota-fiscal) = p-row-nota NO-ERROR.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FIND FIRST tt-mail-moura
             WHERE tt-mail-moura.r-nota-fiscal = p-row-nota NO-ERROR.

        RUN esp/es0018p.p (INPUT "FT2100", /* Nome do programa */
                           INPUT 4,        /* Ponto do programa itens moura*/
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FOR EACH estrutura NO-LOCK
           WHERE estrutura.it-codigo = it-nota-fisc.it-codigo:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.

            IF CAN-FIND (FIRST tt-prog-ponto /*item pai da nota moura*/
                         WHERE tt-prog-ponto.conteudo = estrutura.es-codigo) THEN DO:
                IF NOT AVAIL tt-mail-moura THEN DO:
                    CREATE tt-mail-moura.
                    ASSIGN tt-mail-moura.r-nota-fiscal = p-row-nota.
                END.
                ASSIGN tt-mail-moura.email-moura = tt-mail-moura.email-moura + ITEM.it-codigo + " - "  + ITEM.desc-item + "," + " Quantidade: "  + string(it-nota-fisc.qt-faturada[1]) + CHR(10).
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE run-envia-mail-moura:
    DEFINE VARIABLE c-entrega-moura AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-obs-moura     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lista-email   AS CHARACTER   NO-UNDO.
    
    FOR FIRST tt-mail-moura
        WHERE tt-mail-moura.r-nota-fiscal = ROWID(nota-fiscal):

        ASSIGN c-entrega-moura = "Endere‡o Entrega: " + nota-fiscal.endereco + CHR(10) 
                                                      + "CEP: " + nota-fiscal.cep + CHR(10)
                                                      + "Cidade: " + nota-fiscal.cidade + CHR(10) 
                                                      + "UF: " + nota-fiscal.estado.
        
        ASSIGN c-obs-moura = "@MOURA gentileza incluir a observa‡Æo abaixo em sua NF: " + string(nota-fiscal.nr-nota-fis) + CHR(13) + CHR(13) + 
                             "Produto faz parte da estrutura do item digite o c¢digo do gerador e sua descri‡Æo aqui." + CHR(13) +
                             "conforme Nota Fiscal (n£mero da NF informada acima) EmissÆo: " + string(nota-fiscal.dt-emis).
        
        FIND FIRST transporte NO-LOCK   
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
        
        ASSIGN c-lista-email = "".
        FIND FIRST ponto-programa
             where ponto-programa.nome-programa = "ft2100"
               AND ponto-programa.ponto         = 3 NO-LOCK NO-ERROR.
        IF AVAIL ponto-programa THEN DO:
            FOR EACH conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
                IF c-lista-email = "" THEN
                    ASSIGN c-lista-email = conteudo-programa.conteudo.
                ELSE
                    ASSIGN c-lista-email = c-lista-email + "," + conteudo-programa.conteudo.
        
            END.
        END.
        RUN piEnviaEmailAtendente(INPUT c-lista-email /*atendente.email*/,
                                  INPUT "CACELAMENTO de nota baterias MOURA",
                                  INPUT "Nota Fiscal n£mero: " + string(nota-fiscal.nr-nota-fis) + CHR(13) +
                                        "CNPJ: " + nota-fiscal.cgc + " - " + emitente.nome-abrev + CHR(13) +
                                        "Pedido n£mero: " + string(ped-venda.nr-pedcli) + CHR(13) + CHR(13) +
                                        "Foram cancelados os produtos: " + chr(13) + 
                                        tt-mail-moura.email-moura + CHR(13) + CHR(13) +
                                        c-entrega-moura + chr(13) + chr(13) +
                                        c-obs-moura,
                                  INPUT "").
        
    END.
END PROCEDURE.

PROCEDURE piEnviaEmailAtendente :
    
    DEFINE INPUT  PARAM pDestino   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAnexo     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    empty temp-table tt-envio2.
    empty temp-table tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                 /* Destinatÿrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pAnexo                   /* Arquivo Temporÿrio */
           tt-envio2.formato           = "TEXTO".
    
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem    = 1
           tt-mensagem.mensagem        = pDescEmail + CHR(13). /* Mensagem */
    
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.

         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.

    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 
    
END PROCEDURE.

PROCEDURE piEnviaEmailEntreposto:
    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    //DEFINE VARIABLE cItens               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    //DEF VAR i-nr-pedido LIKE ped-fiscal.nr-pedido.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

    FIND FIRST atendente NO-LOCK
         WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

    IF  AVAIL atendente
    AND atendente.email <> "" THEN DO:
        IF cDestinatarioEmail = "" THEN
            ASSIGN cDestinatarioEmail = atendente.email.
        ELSE
            ASSIGN cDestinatarioEmail = cDestinatarioEmail + ";" + atendente.email.
    END.
    
    RUN esp/es0018p.p (INPUT "ft2200rp", /* Nome do programa */
                       INPUT 5,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    FOR EACH tt-prog-ponto:
        if entry(1, tt-prog-ponto.conteudo,";") = v_cod_estab_usuar then DO:
            IF cDestinatarioEmail = "" THEN
                ASSIGN cDestinatarioEmail = ENTRY(2, tt-prog-ponto.conteudo,";").
            ELSE
                ASSIGN cDestinatarioEmail = cDestinatarioEmail + ";" + ENTRY(2, tt-prog-ponto.conteudo,";").
        END.
    END.
    
  /*  find first ped-fiscal no-lock where
         ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.
    if avail ped-fiscal then
         assign i-nr-pedido = ped-fiscal.nr-pedido.
    else assign i-nr-pedido = 0.*/

   /* FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
        ASSIGN cItens = cItens +
                        "ITEM: " + it-nota-fisc.it-codigo      + CHR(10) + 
                        "Unid neg: " + it-nota-fisc.cod-unid-negoc + CHR(10).
    END.*/

    FOR EACH emitente
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK:
    
       ASSIGN cMensagem =  "Prezada Supplog" + CHR(10) +
                           "Informamos que a NF " + STRING(nota-fiscal.nr-nota-fis) + " " + "Emitida em " + STRING(nota-fiscal.dt-emis-nota) + CHR(10) +
                           "destinatario " + emitente.nome-emit + " e " + emitente.cgc + ", foi cancelada na Sefaz.".
                       
       ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailCancNF.txt".
       OUTPUT STREAM arq-email TO VALUE(vArqMail).
       PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
       OUTPUT STREAM arq-email CLOSE.
       
       CREATE tt-mail.
       ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
              tt-mail.Assunto       = "Nota Fiscal Cancelada.: " + 
                                       nota-fiscal.serie + "/" +  
                                       string(nota-fiscal.nr-nota-fis) + 
                                       " - Pedido: " + STRING(nota-fiscal.nr-pedcli)
              tt-mail.Mensagem      = cMensagem
              tt-mail.Arquivo       = vArqMail.
       
           ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".
       
       RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                             OUTPUT TABLE tt-erro).
       
       FOR EACH tt-mail:
           DELETE tt-mail.
       END.
    END.
END PROCEDURE.
