/***********************************************************************
**  Programa..: ESP\REP\ESUTP017RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio telefonia para Usu†rios Excel
**  Vers∆o....: 001 01/07/2008 - Desenvolvimento Programa
**              002 04/10/2011 - Hoepers: conforme solicitado pelo Sr. Lazare, ser† calculado o valor por ligaá∆o com valor zero e removido o Total outros, que equivale ao rateio do pacote mensal
**              003 10/10/2011 - Hoepers: n∆o calcular minutagem para serviáos Tarifa Zero, Gerar planilha para todos aparelhos TIM independente da situaá∆o e tipo
**              004 04/10/2012 - Sakae: Inclus∆o da coluna "Valor Serviáos" e "Total" na opá∆o "Geral", para apresentar o total de custo em serviáos por equipamento e usu†rio, assim como o total de ligaá‰es e serviáos.
**              005 04/10/2012 - Sakae: Retirado a coluna "Justificativa" da opá∆o "Geral".
************************************************************************/
{include/i-prgvrs.i ESUTP017 2.06.00.005}

/****************************  Definitions  ****************************/
{esp/utp/esutp017tt.i}

{utp/utapi009.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}

/****************************  Temp-Tables  ****************************/

DEFINE VARIABLE chExcel2  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWBook2  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWSheet2 AS COMPONENT-HANDLE NO-UNDO.

DEFINE VARIABLE i-linha   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-erro    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-nome    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-formula AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-nome-arq AS CHARACTER   NO-UNDO.


DEFINE TEMP-TABLE tt-verificar NO-UNDO
    FIELD cod-erro  AS INTEGER
    FIELD desc-erro AS CHARACTER FORMAT "x(60)"
    FIELD log-bloq  AS LOGICAL.

DEFINE TEMP-TABLE tt-usuarios NO-UNDO
    FIELD equipamento AS CHARACTER 
    FIELD cod-usuario AS CHARACTER
    FIELD nome        AS CHARACTER FORMAT "x(40)"
    FIELD email       AS CHARACTER
    FIELD copia       AS CHARACTER
    FIELD limite      AS DECIMAL
    INDEX id-equipto 
            equipamento
    INDEX id-nome
            nome.

DEFINE TEMP-TABLE tt-telefonia NO-UNDO LIKE telefonia
    FIELD considera-limite AS LOGICAL
    INDEX ch-busca equipamento mes-ref.

DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.
DEF VAR h-acomp      as handle no-undo.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FOR FIRST param-global NO-LOCK. END.

FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Planilha telefonia usu†rios Excel"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP017"
       c-versao       = "2.06"
       c-revisao      = "005".

DEF STREAM str-csv.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:

    IF tt-param.relatorio = 1 THEN DO:
        {include/i-rpcab.i}
        {include/i-rpout.i}  
        RUN pi-individual.
        {include/i-rpclo.i}
    END.                 
    ELSE DO:
        {include/i-rpout.i &pagesize="0"}
        RUN pi-geral.
        {include/i-rpclo.i}
    END.
    
    RETURN "OK".
END.



PROCEDURE pi-gera-csv:
    DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-soma   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-tempo AS DECIMAL     NO-UNDO.
    
    PUT STREAM str-csv ";;;"STRING(tt-usuarios.cod-usuario) ";" tt-usuarios.nome ";Limite:;" tt-usuarios.limite SKIP(1).

    PUT STREAM str-csv "Equipamento;Data;Hora;Numero;Servico;Duracao;Valor" SKIP.

    ASSIGN i-linha = 3.
    FOR EACH tt-telefonia  
       WHERE tt-telefonia.equipamento = tt-usuarios.equipamento
       AND   tt-telefonia.considera-limite = TRUE
          BY tt-telefonia.servico 
          BY tt-telefonia.numero
          BY tt-telefonia.data
          BY tt-telefonia.hora:        

        ASSIGN i-linha  = i-linha + 1
               de-tempo = 0.
        
        IF tt-telefonia.valor = 0 AND tt-telefonia.fornecedor = 3 AND tt-telefonia.servico <> "Chamadas recebidas em Roaming Nacional" THEN DO:

            IF SUBSTRING(tt-telefonia.duracao,3,1) = ":" THEN DO:
                
                ASSIGN de-tempo = INT(SUBSTRING(tt-telefonia.duracao,1,2)) * 60 +
                                  INT(SUBSTRING(tt-telefonia.duracao,4,2))      +
                                  INT(SUBSTRING(tt-telefonia.duracao,7,2)) / 60 NO-ERROR.

                IF de-tempo = ? THEN 
                    ASSIGN de-tempo = 0.

            END.
            ELSE IF INDEX(tt-telefonia.duracao,"m") <> 0 AND 
                    INDEX(tt-telefonia.duracao,"s") <> 0 THEN DO:

                ASSIGN de-tempo = (IF INDEX(tt-telefonia.duracao,"h") <> 0 THEN INT(SUBSTRING(tt-telefonia.duracao,INDEX(tt-telefonia.duracao,"h") - 2,2)) * 60 
                                   ELSE 0)  +
                                  INT(SUBSTRING(tt-telefonia.duracao,INDEX(tt-telefonia.duracao,"m") - 2,2)) +
                                  INT(SUBSTRING(tt-telefonia.duracao,INDEX(tt-telefonia.duracao,"s") - 2,2)) / 60 NO-ERROR.

                IF de-tempo = ? THEN 
                    ASSIGN de-tempo = 0.

           END.

           IF  INDEX(tt-telefonia.servico,"zero") = 0 THEN
               ASSIGN tt-telefonia.valor = de-tempo * tt-param.reais-minuto.

        END.

        ASSIGN de-valor = de-valor + tt-telefonia.valor.

        IF  LENGTH(tt-telefonia.numero) > 10 AND
            tt-telefonia.numero BEGINS "55"
        THEN
            ASSIGN tt-telefonia.numero = TRIM(SUBSTR(tt-telefonia.numero,3,LENGTH(tt-telefonia.numero))).

        PUT STREAM str-csv
            tt-telefonia.equipamento ";"
            tt-telefonia.data        ";"
            tt-telefonia.hora        ";"
            tt-telefonia.numero      ";"
            tt-telefonia.servico     ";"
            tt-telefonia.duracao     ";"
            tt-telefonia.valor       ";" SKIP.
    END.
    
    PUT STREAM str-csv ";;;;;;" SKIP.
    PUT STREAM str-csv ";;;;VALOR TOTAL UTILIZAÄ«O;;" de-valor SKIP.
    PUT STREAM str-csv ";;;;VALOR LIMITE;;" tt-usuarios.limite FORMAT ">>>,>>9.99" SKIP.

    PUT STREAM str-csv ";;;;;;;" SKIP.

    FOR EACH tt-telefonia NO-LOCK 
       WHERE tt-telefonia.equipamento = tt-usuarios.equipamento
         AND tt-telefonia.considera-limite = FALSE
          BY tt-telefonia.servico:        
        
        PUT STREAM str-csv ";;;;"
            tt-telefonia.servico ";;"
            tt-telefonia.valor ";" SKIP.

        ASSIGN de-valor = de-valor + tt-telefonia.valor.
    END.
    
    PUT STREAM str-csv ";;;;;;;" SKIP.
    PUT STREAM str-csv ";;;;VALOR TOTAL CONTA;;" de-valor SKIP.

    PUT STREAM str-csv ";;;;;;;" SKIP.

END PROCEDURE.


PROCEDURE pi-valida-usuario:

    DEFINE INPUT  PARAMETER p-usuario     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-equipamento AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nome        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-email       AS CHARACTER NO-UNDO.

    ASSIGN p-nome = ""
           p-email = "".

    IF p-usuario = "" THEN
        RETURN "NOK":U.    /* Pricila pediu para n∆o apresentar mensagem de erro. */
    
    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = p-usuario NO-ERROR.

    IF NOT AVAIL usuar_mestre THEN DO:
        ASSIGN i-erro = i-erro + 1.
        CREATE tt-verificar.
        ASSIGN tt-verificar.cod-erro  = i-erro
               tt-verificar.desc-erro = "Usu†rio: " + STRING(p-usuario) + " do equipamento: " + equipamentos.equipamento + " n∆o cadastrado!"
               tt-verificar.log-bloq  = YES. 
        RETURN "nok".
    END.

    IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local = "" THEN DO:
        ASSIGN i-erro = i-erro + 1.
        CREATE tt-verificar.
        ASSIGN tt-verificar.cod-erro  = i-erro
               tt-verificar.desc-erro = "Usu†rio: " + STRING(p-usuario) + "-" + TRIM(usuar_mestre.nom_usuario) + " do equipamento: " + equipamentos.equipamento + " n∆o tem email cadastrado!"
               tt-verificar.log-bloq  = YES. 
        RETURN "nok".
    END.

    ASSIGN p-email = usuar_mestre.cod_e_mail_local.
           p-nome  = usuar_mestre.nom_usuario.
    
    RETURN "ok".

END PROCEDURE.


PROCEDURE pi-envia-email:
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
    
    PUT UNFORMATTED 
        "Enviando email para: " + STRING(tt-usuarios.email) FORMAT "x(80)" AT 01 SKIP.
    
    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    IF tt-param.acima-limite THEN DO:
        ASSIGN c-mensagem = "Ol†, tudo bem ?" + CHR(10) + CHR(10) + 
                            "Vocà ultrapassou seu limite do celular corporativo, segue anexo a planilha excel de suas ligaá‰es efetuadas e utilizaá∆o de dados m¢veis do màs, referente a linha corporativa Intelbras."  + CHR(13) +
                            "Em caso de d£vidas entre em contato via teams ou e-mail com: Eduarda Camilo de Souza ou Manuela Assis Guimar∆es." + CHR(13) +
                            "Para alteraá‰es abra um chamado no portal da TI em: http://helpdesk.intelbras.com.br" + CHR(13) + CHR(10) + 
                            "Agradecemos e ficamos † disposiá∆o !".
    END.
    ELSE DO:
        ASSIGN c-mensagem = "Ol†, tudo bem ?" + CHR(10) + CHR(10) + 
                            "Segue anexo a planilha excel de suas ligaá‰es efetuadas e utilizaá∆o de dados m¢veis do màs, referente a linha corporativa Intelbras."  + CHR(13) +
                            "Em caso de d£vidas entre em contato via teams ou e-mail com: Eduarda Camilo de Souza ou Manuela Assis Guimar∆es." + CHR(13) +
                            "Para alteraá‰es abra um chamado no portal da TI em: http://helpdesk.intelbras.com.br" + CHR(13) + CHR(10) + 
                            "Agradecemos e ficamos † disposiá∆o !".
    END.

    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.destino           = tt-usuarios.email
           tt-envio.remetente         = tt-param.remetente
           tt-envio.assunto           = "Fatura " + tt-param.periodo + " - Celular Corporativo (" + tt-usuarios.equipamento + ")" 
           tt-envio.mensagem          = c-mensagem
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = no
           tt-envio.copia             = tt-usuarios.copia
           tt-envio.arq-anexo         = c-dir-nome-arq.
           
     run utp/utapi009.p ( input  table tt-envio,
                          output  table tt-erros).

     IF CAN-FIND(FIRST tt-erros) THEN DO:
         PUT UNFORMATTED
             SKIP(1)
             "Erro    Descricao                                                        " AT 01
             "------- -----------------------------------------------------------------" AT 01 SKIP.
         FOR EACH tt-erros:
             PUT UNFORMATTED 
                  tt-erros.cod-erro  AT 01
                  tt-erros.desc-erro AT 09 SKIP.
             DELETE tt-erros.
         END.
         PUT UNFORMATTED SKIP(2).
     END.

END PROCEDURE.


PROCEDURE pi-individual:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    

    FOR EACH tt-usuarios:
        DELETE tt-usuarios.
    END.

    FOR EACH tt-verificar:
        DELETE tt-verificar.
    END.

    FOR EACH tt-telefonia:
        DELETE tt-telefonia.
    END.

    ASSIGN i-erro = 0.

    RUN pi-inicializar in h-acomp (input "Carregando Informaá‰es...").

    FOR EACH equipamentos NO-LOCK 
       WHERE equipamentos.equipamento >= tt-param.equip-ini
         AND equipamentos.equipamento <= tt-param.equip-fim
         AND equipamentos.tipo        = 2  /* Celular */
         AND (IF tt-param.cod-usuario = "" THEN TRUE ELSE equipamentos.cod_usuario = tt-param.cod-usuario)
         AND (IF NOT tt-param.acima-limite THEN TRUE ELSE equipamentos.val-limite  <> 0):

        IF CAN-FIND(FIRST telefonia NO-LOCK
                    WHERE telefonia.equipamento = equipamentos.equipamento
                      AND telefonia.fornecedor  = tt-param.fornecedor
                      AND telefonia.mes-ref     = tt-param.periodo) THEN DO:

            FIND FIRST tt-usuarios NO-LOCK
                 WHERE tt-usuarios.equipamento = equipamentos.equipamento NO-ERROR.
            IF NOT AVAIL tt-usuarios THEN DO:

                ASSIGN c-nome = "" 
                       c-email = "".

                RUN pi-valida-usuario (INPUT equipamentos.cod_usuario, 
                                       INPUT equipamentos.equipamento,
                                       OUTPUT c-nome,
                                       OUTPUT c-email).

                IF  c-nome = "" THEN
                    ASSIGN c-nome = equipamentos.equipamento.

                IF RETURN-VALUE = "OK" THEN DO:

                    ASSIGN de-valor = 0.

                    FOR EACH telefonia NO-LOCK
                       WHERE telefonia.equipamento = equipamentos.equipamento
                         AND telefonia.fornecedor  = tt-param.fornecedor
                         AND telefonia.mes-ref     = tt-param.periodo:

                        CREATE tt-telefonia.
                        BUFFER-COPY telefonia TO tt-telefonia.

                        /* MAICON */

                        /*IF telefonia.data <> ? OR (telefonia.data  = ? AND (telefonia.servico BEGINS "total de desconto" OR telefonia.servico BEGINS "total outros cr")) THEN DO:
                            ASSIGN de-valor = de-valor + telefonia.valor
                                   tt-telefonia.considera-limite = YES 
                                   tt-telefonia.servico          = TRIM(telefonia.servico).
                        END.
                        ELSE
                            ASSIGN tt-telefonia.considera-limite = NO
                                   tt-telefonia.servico          = "0-" + TRIM(telefonia.servico).*/

                        FOR FIRST tipo-servico NO-LOCK
                            WHERE tipo-servico.servico = telefonia.servico:

                            /* Uso */
                            IF tipo-servico.tipo-serv = 1 THEN
                                ASSIGN de-valor = de-valor + telefonia.valor
                                       tt-telefonia.considera-limite = YES.

                            /* Assinatura */
                            IF tipo-servico.tipo-serv = 2 THEN
                                ASSIGN tt-telefonia.considera-limite = FALSE.

                            /* Serviáo */
                            IF tipo-servico.tipo-serv = 3 THEN DO:
                                DELETE tt-telefonia.
                                NEXT.
                            END.

                        END.

                        IF NOT AVAIL tipo-servico THEN DO:
                        END.
                                   
                    END.

                    IF (tt-param.acima-limite AND de-valor <= equipamentos.val-limite) THEN DO: 
                        /*somente acima limite ou sem valor no periodo ent∆o ignora*/
                        FOR EACH tt-telefonia NO-LOCK
                           WHERE tt-telefonia.equipamento = equipamentos.equipamento
                             AND tt-telefonia.mes-ref     = tt-param.periodo:
                            DELETE tt-telefonia.
                        END.
                        NEXT.
                    END.
                    ELSE DO:
                        CREATE tt-usuarios.
                        ASSIGN tt-usuarios.equipamento = equipamentos.equipamento
                               tt-usuarios.cod-usuario = equipamentos.cod_usuario
                               tt-usuarios.nome        = c-nome
                               tt-usuarios.email       = c-email
                               tt-usuarios.limite      = equipamentos.val-limite.

                        IF  equipamentos.cod_usuario = "" THEN
                            ASSIGN tt-usuarios.cod-usuario = equipamentos.equipamento.

                        IF equipamentos.cod_gestor_cobranca <> "" THEN DO:
                            /*Caso tenha gestor de cobranáa envia copia para usu†rio*/
                            FIND FIRST usuar_mestre NO-LOCK
                                 WHERE usuar_mestre.cod_usuario = equipamentos.cod_gestor_cobranca NO-ERROR.

                            IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN DO:
                                ASSIGN tt-usuarios.copia = usuar_mestre.cod_e_mail_local.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-verificar) THEN DO:
        PUT UNFORMATTED
            "Erro    Descriá∆o                                                        " AT 01
            "------- -----------------------------------------------------------------" AT 01 SKIP.
        FOR EACH tt-verificar:
            PUT UNFORMATTED 
                 tt-verificar.cod-erro  AT 01
                 tt-verificar.desc-erro AT 09 SKIP.
        END.
        PUT UNFORMATTED SKIP(2).
    END.

    IF NOT CAN-FIND(FIRST tt-verificar WHERE tt-verificar.log-bloq = YES) THEN DO:
        RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Excel...").

        PUT UNFORMATTED
            "Equipamento         Codigo Nome                                    " AT 01
            "------------------- ------ ----------------------------------------" AT 01 SKIP.

        FOR EACH tt-usuarios NO-LOCK BY tt-usuarios.nome:
            PUT UNFORMATTED 
                tt-usuarios.equipamento         AT 01
                tt-usuarios.cod-usuario         AT 22
                tt-usuarios.nome FORMAT "x(40)" AT 29 SKIP.
        END.

        FOR EACH tt-usuarios NO-LOCK BY tt-usuarios.nome:
            run pi-acompanhar in h-acomp (INPUT "Planilha: " + tt-usuarios.nome).

            ASSIGN c-dir-nome-arq = tt-param.diretorio + "Conta-" + STRING(tt-usuarios.equipamento) + "-" + tt-param.periodo + ".csv".

            OUTPUT STREAM str-csv TO value(c-dir-nome-arq) CONVERT TARGET "iso8859-1".

            RUN pi-gera-csv.

            OUTPUT STREAM str-csv CLOSE.

            IF  tt-param.envia-email AND
                tt-usuarios.email <> ""
            THEN
                RUN pi-envia-email.
        END.
    END.

    PUT UNFORMATTED 
        SKIP(2)
        "Periodo:"                             TO 20 
        tt-param.periodo                       AT 22
        "Equipamento:"                         TO 20 
        tt-param.equip-ini                     AT 22 
        " < > "                                AT 43
        tt-param.equip-fim                     AT 48
        "Remetente:"                           TO 20
        tt-param.remetente                     AT 22
        "Usuario:"                             TO 20
        tt-param.cod-usuario                   AT 22
        "Diret¢rio:"                           TO 20 
        STRING(tt-param.diretorio)             AT 22
        "Somente fora limite:"                 TO 20
        STRING(tt-param.acima-limite,"Sim/N∆o") AT 22
        "Envia Email Usu†rio:"                 TO 20
        STRING(tt-param.envia-email,"Sim/N∆o") AT 22.

    RUN pi-finalizar in h-acomp.

    IF CAN-FIND(FIRST tt-verificar WHERE tt-verificar.log-bloq = YES) THEN DO:
        MESSAGE "Ocorreu erros na geraá∆o, favor verificar erros listados e gerar novamente!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        IF tt-param.envia-email THEN
            MESSAGE "Processo Conclu°do. Foi enviado email para todos usu†rios Excel!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE 
            MESSAGE "Processo Conclu°do. N∆o foi enviado email, pois parÉmetro de envio estava desmarcado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.


PROCEDURE pi-geral:
    DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-valor  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-val-aux AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tempo AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-cc-codigo  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-responsavel AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-tipo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-val-serv AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-val-tot-com-serv AS DECIMAL     NO-UNDO.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    RUN pi-inicializar in h-acomp (input "Carregando Informaá‰es...").

    PUT UNFORMATTED 
         "Equipamento;Descricao;Tipo;Matricula;Cargo;Nome;Email;Limite;Valor;Diferenca;Departamento;Responsavel;Situacao;Valor Serviáos;Total;Descontar RH" SKIP.

    FOR EACH telefonia NO-LOCK
       WHERE telefonia.mes-ref    = tt-param.periodo
         AND telefonia.fornecedor = tt-param.fornecedor
        BREAK BY telefonia.equipamento:

        IF FIRST-OF(telefonia.equipamento) THEN DO:

            ASSIGN de-valor = 0
                   de-val-serv = 0.

            FOR FIRST equipamentos NO-LOCK
                WHERE equipamentos.equipamento = telefonia.equipamento:
            END.

        END.

        IF NOT AVAIL equipamentos OR equipamentos.tipo <> 2 /* Celular */ THEN
            NEXT.


        /**/

        FOR FIRST tipo-servico NO-LOCK
            WHERE tipo-servico.servico = telefonia.servico:

            /* Serviªo */
            IF tipo-servico.tipo-serv = 3 THEN
                NEXT.

        /**/

        /*IF NOT (telefonia.servico BEGINS "total outros cr":U) THEN DO:
            IF telefonia.data <> ? OR (telefonia.data  = ? AND (telefonia.servico BEGINS "total de desconto" OR telefonia.servico BEGINS "total outros cr")) THEN DO:  2014-12-18*/

            /* Uso */
            IF tipo-servico.tipo-serv = 1 THEN DO:

                ASSIGN de-val-aux = telefonia.valor
                       de-tempo   = 0.

                IF telefonia.valor = 0 AND telefonia.fornecedor = 3 AND telefonia.servico <> "Chamadas recebidas em Roaming Nacional" THEN DO:

                    IF SUBSTRING(telefonia.duracao, 3, 1) = ":":U THEN DO:

                        ASSIGN de-tempo = INTEGER(SUBSTRING(telefonia.duracao, 1, 2)) * 60 +
                                          INTEGER(SUBSTRING(telefonia.duracao, 4, 2))      +
                                          INTEGER(SUBSTRING(telefonia.duracao, 7, 2)) / 60 NO-ERROR.

                        IF de-tempo = ? THEN
                            ASSIGN de-tempo = 0.

                    END.
                    ELSE IF INDEX(telefonia.duracao, "m":U) <> 0 AND
                            INDEX(telefonia.duracao, "s":U) <> 0 THEN DO:

                        ASSIGN de-tempo = (IF INDEX(telefonia.duracao, "h":U) <> 0 THEN INTEGER(SUBSTRING(telefonia.duracao, INDEX(telefonia.duracao, "h":U) - 2, 2)) * 60 
                                           ELSE 0) +
                                          INTEGER(SUBSTRING(telefonia.duracao, INDEX(telefonia.duracao, "m":U) - 2, 2)) +
                                          INTEGER(SUBSTRING(telefonia.duracao, INDEX(telefonia.duracao, "s":U) - 2, 2)) / 60 NO-ERROR.

                        IF de-tempo = ? THEN
                            ASSIGN de-tempo = 0.

                    END.

                    IF INDEX(telefonia.servico, "zero":U) = 0 THEN
                        ASSIGN de-val-aux = de-tempo * tt-param.reais-minuto.
                END.

                ASSIGN de-valor = de-valor + ROUND(de-val-aux, 2).

            END.

            /* Assinatura */
            IF tipo-servico.tipo-serv = 2 THEN DO:

                /*IF telefonia.data = ? AND (telefonia.data <> ? OR (NOT telefonia.servico BEGINS "total de desconto" AND NOT telefonia.servico BEGINS "total outros cr")) THEN*/
                    ASSIGN de-val-serv = de-val-serv + telefonia.valor.

            END.

        END.


        /* No individual, se n∆o encontra o tipo de serviáo a flag .considera-limite fica false */
        IF NOT AVAIL tipo-servico THEN
            ASSIGN de-val-serv = de-val-serv + telefonia.valor.

            /*END.
        END. 2014-12-18*/

        

        IF LAST-OF(telefonia.equipamento) THEN DO:
            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = telefonia.equipamento NO-ERROR.
            IF AVAIL equipamentos THEN DO:

                ASSIGN c-email = ""
                       c-cc-codigo = ""
                       c-responsavel = "".
                FIND FIRST cc-equipamentos NO-LOCK
                     WHERE cc-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                IF AVAIL cc-equipamentos THEN DO:
                    ASSIGN c-cc-codigo = cc-equipamentos.cc-codigo.
                    FIND FIRST int-centro-custo NO-LOCK
                         WHERE int-centro-custo.cod-estabel = cc-equipamentos.cod-estabel
                           AND int-centro-custo.cc-codigo   = cc-equipamentos.cc-codigo 
                           AND int-centro-custo.cod-unid-negoc = cc-equipamentos.cod-unid-negoc NO-ERROR.
                    IF AVAIL int-centro-custo THEN DO:
                        ASSIGN c-responsavel = STRING(int-centro-custo.cod_usuario).
                        FIND FIRST usuar_mestre NO-LOCK 
                             WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
                        IF AVAIL usuar_mestre THEN
                            ASSIGN c-responsavel = c-responsavel + "-" + usuar_mestre.nom_usuario.
                    END.

                    run prgint\utb\utb742za.py persistent set h_api_ccusto.
        
                    EMPTY TEMP-TABLE tt_log_erro.
                    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,       /* EMPRESA EMS2 */
                                                               input  "",                        /* CODIGO DO PLANO CCUSTO */
                                                               input  c-cc-codigo,               /* CCUSTO */
                                                               input  today,                     /* DATA DE TRANSACAO */
                                                               output v_des_titulo_ccusto,       /* DESCRICAO DO CCUSTO */
                                                               output table tt_log_erro).        /* ERROS */
                    delete object h_api_ccusto.
                    ASSIGN c-cc-codigo = c-cc-codigo + "-" + v_des_titulo_ccusto.
                END.
                ELSE
                    ASSIGN c-cc-codigo = equipamentos.ct-codigo.

                IF equipamentos.cod_usuario <> "" THEN DO:
                    FOR FIRST usuar_mestre 
                        WHERE usuar_mestre.cod_usuario = equipamentos.cod_usuario NO-LOCK:
                        ASSIGN c-email = usuar_mestre.cod_e_mail_local
                               c-nome  = usuar_mestre.nom_usuario.
                    END.
                END.
                ELSE ASSIGN c-nome = "nao cadastrado".

                ASSIGN c-desc-tipo   = REPLACE(REPLACE(c-desc-tipo,   CHR(10), " ":U), CHR(13), " ":U)
                       c-nome        = REPLACE(REPLACE(c-nome,        CHR(10), " ":U), CHR(13), " ":U)
                       c-email       = REPLACE(REPLACE(c-email,       CHR(10), " ":U), CHR(13), " ":U)
                       c-cc-codigo   = REPLACE(REPLACE(c-cc-codigo,   CHR(10), " ":U), CHR(13), " ":U)
                       c-responsavel = REPLACE(REPLACE(c-responsavel, CHR(10), " ":U), CHR(13), " ":U).

                IF NOT tt-param.acima-limite OR (tt-param.acima-limite AND de-valor > equipamentos.val-limite AND equipamento.val-limite <> 0) THEN DO:
                    run pi-acompanhar in h-acomp (INPUT "Equipamento: " + telefonia.equipamento).


                    ASSIGN c-desc-tipo = "".
                    FIND FIRST tipo-equipamentos NO-LOCK
                         WHERE tipo-equipamentos.codigo = equipamentos.tipo NO-ERROR.
                    IF AVAIL tipo-equipamentos THEN
                        ASSIGN c-desc-tipo = STRING(tipo-equipamentos.codigo) + "-" + tipo-equipamentos.descricao.

                    PUT UNFORMATTED 
                         telefonia.equipamento              ";"
                         equipamentos.descricao             ";"
                         c-desc-tipo                        ";"
                         equipamentos.cod_usuario           ";"
                         equipamentos.cargo                 ";"
                         c-nome                             ";"
                         c-email                            ";"  
                         equipamentos.val-limite            ";"
                         de-valor                           ";" 
                         de-valor - equipamentos.val-limite ";"
                         c-cc-codigo                        ";"
                         c-responsavel                      ";"
                         ENTRY(equipamentos.ind-situacao + 1,"Ativo,Bloqueado,Cancelado") ";"
                         de-val-serv                        ";"
                         de-valor + de-val-serv             ";".
                    
                    
                    IF  equipamentos.log-desconta-integral THEN
                        PUT UNFORMATTED (de-valor + de-val-serv) /*- equipamentos.val-limite*/ SKIP.  /* Priscila falou pra tirar este desconto quando desconta integral */
                    ELSE DO:
                        IF  equipamentos.val-limite = 0 THEN
                            PUT UNFORMATTED 0 SKIP.
                        ELSE
                            IF  de-valor - equipamentos.val-limite > 0 THEN DO:
                                PUT UNFORMATTED de-valor - equipamentos.val-limite SKIP.
                            END.
                            ELSE
                                PUT UNFORMATTED 0 SKIP.
                    END.
                END.
            END.

            ASSIGN de-valor = 0.
        END.
    END.

    RUN pi-finalizar in h-acomp.

END PROCEDURE.
