/*******************************************************************************
**  Programa: esp/crm/escrm004.p 
**  Objetivo: MÇtodo de Acesso: Integrar - Recebe como parametro a tabela que vai ser alterada 
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
/*
ParÉmetros de Entrada
"	Entity (Ex: account, contact, customeradress, new_relacionamento)
"	Action (C=Create, W=Write e D=Delete)
"	Message (XML preparado pelo Connector)

ParÉmetros de Sa°da (Realizado no EMS)
"Tabela temporaria tt-retorno
*/

CREATE WIDGET-POOL.

DEF NEW GLOBAL SHARED VAR l-web-service AS LOGICAL NO-UNDO.

{esp/crm/escrm001.i}
{esp/crm/escrm001.i1} /* Definiá∆o das temp-tables de validaá∆o - cdp/cdapi329.p */
{esp/crm/escrm001b.i}   /* Definicoes de temp-tables para buscar as Tabelas do ems5 */

define temp-table tt-erros-crm like tt-erros-geral
FIELD tipo AS INTEGER /* 1 - Erro  2 - Advertencia */.

DEFINE TEMP-TABLE tt-retorno
FIELD mensagem         AS CHARACTER
FIELD chaveintegracao  AS CHARACTER
FIELD cod-entrega      AS CHARACTER.

/* Parametros de Entrada */
DEFINE INPUT PARAMETER peEntity             AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER peAction             AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER peMessage            AS CHAR NO-UNDO.

/* Parametros de Saida */
DEFINE output PARAMETER TABLE FOR tt-retorno.

/* definicoes de Variaveis */
DEFINE VARIABLE  c-usuario-alocando AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER                 NO-UNDO.
DEFIN  VARIABLE c-entrega        AS CHARACTER               NO-UNDO.
define variable i-seq-erro       as int                     no-undo.
DEFINE VARIABLE i-seq-contato    AS INT                     NO-UNDO. 
define variable c-rua            as char                    no-undo. 
define variable c-nro            as char                    no-undo. 
define variable c-comp           as char                    no-undo.
DEFINE VARIABLE c-cgc            AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-erro           AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-des-msg        as char format "x(36)"     no-undo.
DEFINE VARIABLE c-cod-erro       as char format "x(20)"     no-undo.
DEFINE VARIABLE c-cod-ie-sai     like emitente.ins-estadual no-undo.
DEFINE VARIABLE p-prox-emitente  LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE c-usuario        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-atualizou   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cXML          AS CHARACTER NO-UNDO.
define variable h-cdapi704    as handle    no-undo.
DEFINE VARIABLE h-escrm005    AS HANDLE    NO-UNDO.  

DEFINE BUFFER b-emitente FOR emitente.

ASSIGN l-web-service = YES.

FIND FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "escrm004":U
      AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

IF AVAILABLE ponto-programa THEN DO:
    FOR EACH conteudo-programa
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
        
        IF conteudo-programa.sequencia = 1 THEN DO:
            assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.

RUN bi/esbi002.p (INPUT c-usuario,
                  INPUT c-senha).

CREATE tt-retorno.  /* Sempre cria o registro para nao ficar nulo no CRM */

LOG-MANAGER:WRITE-MESSAGE('Entity: ' + peEntity, 'DEBUG') NO-ERROR.

IF peEntity = "Account":U THEN DO: /* Cliente */

    IF peMessage = "":U THEN DO:
        ASSIGN tt-retorno.mensagem        = "Arquivo XML em branco!":U
               tt-retorno.chaveintegracao = "":U.

        RETURN NO-APPLY.
    END.

    CREATE tt-cliente.

    RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.  /* Procedures de leitura do xml */
    RUN readXML IN h-escrm005 (INPUT BUFFER tt-cliente:HANDLE,
                               INPUT peMessage,
                               OUTPUT TABLE tt-atributo-entrada).

    IF VALID-HANDLE(h-escrm005) 
    THEN DELETE PROCEDURE h-escrm005.

    bk-cliente:
    FOR FIRST tt-cliente:
        ASSIGN tt-cliente.address1_addresstypecode = 3
               tt-cliente.address1_name            = "Principal":U
               tt-cliente.address2_addresstypecode = 200000
               tt-cliente.address2_name            = "Cobranáa":U
               tt-cliente.new_exporta_erp          = "":U
               tt-cliente.new_mensagem             = "":U.

        CREATE tt-cliente-valid.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED(emitente) THEN DO:
            ASSIGN c-usuario-alocando = "".
            for first _Lock
                where _Lock._Lock-Flags = "X":
                for first _file
                    where _file._File-Number = _Lock._Lock-Table: END.
                for first _UserLock
                    where _UserLock._UserLock-id = _Lock._Lock-Usr: END.       
               for first _Connect
                   where _Connect._Connect-Usr = _Lock._Lock-Usr: END.        
                ASSIGN c-usuario-alocando = _Lock._Lock-Name.
                     
                    
            end.
            ASSIGN tt-cliente.cod-emitente          = ?
                           tt-cliente.new_status_integracao = "N∆o integrado.":U
                           tt-cliente.new_mensagem          = "Erro: O Registro em questao esta alocado pelo usuario : " + c-usuario-alocando + ", aguarde a liberacao ou entre em contato. Erro na integraá∆o CRM com ERP (Tabela emitente).":U.

                    ASSIGN tt-retorno.mensagem = tt-cliente.new_mensagem.

                    NEXT bk-cliente.
        END.

        IF NOT AVAILABLE emitente THEN DO:
            IF peAction <> "D":U THEN DO:
                FIND FIRST emitente
                    WHERE emitente.nome-abrev = tt-cliente.nome-abrev NO-LOCK NO-ERROR.

                IF AVAILABLE emitente THEN DO:
                    ASSIGN tt-cliente.cod-emitente          = ?
                           tt-cliente.new_status_integracao = "N∆o integrado.":U
                           tt-cliente.new_mensagem          = "Erro: nome abreviado j† existe no sistema. Erro na integraá∆o CRM com ERP (Tabela emitente).":U.

                    

                    ASSIGN tt-retorno.mensagem = tt-cliente.new_mensagem.

                    NEXT bk-cliente.
                END.
                ELSE DO:
                    ASSIGN tt-cliente-valid.modalidade  = 6
                           tt-cliente-valid.portador    = 999
                           tt-cliente-valid.modalidade-ap  = 6
                           tt-cliente-valid.portador-ap    = 999
                           tt-cliente-valid.ind-abrange-aval        = 2.
/*                            tt-cliente-valid.mod-prefer  = 6        /* POR SOLICITACAO ANDRE ANDERSEN */ */
/*                            tt-cliente-valid.port-prefer = 999.                                          */
                END.

                FIND LAST emitente NO-LOCK NO-ERROR.

                IF AVAILABLE emitente THEN DO:
                    /* Busca o proximo cliente valido */

                    run cdp/cd9960.p (OUTPUT p-prox-emitente).

                    ASSIGN tt-cliente.cod-emitente = p-prox-emitente.
                END.
                ELSE
                    ASSIGN tt-cliente.cod-emitente = 0.

                ASSIGN tt-cliente-valid.ind-tipo-movto = 1.
            END.
        END.
        ELSE DO:

            FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE int-emitente AND int-emitente.ind-forma-tributo <> tt-cliente.ind-forma-tributo THEN DO:

                FIND FIRST int-emitente-trib NO-LOCK
                    WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
                IF  AVAIL  int-emitente-trib THEN DO:

                    IF int-emitente-trib.ind-declaracao = YES THEN DO:
                        ASSIGN tt-cliente.cod-emitente          = ?
                               tt-cliente.new_status_integracao = "N∆o integrado.":U
                               tt-cliente.new_mensagem          = "Erro: Cliente " + emitente.nome-abrev + " - Declaraá∆o j† entregue. Verificar com o o grupo tributario.":U.
                        ASSIGN tt-retorno.mensagem        = tt-cliente.new_mensagem.
                        NEXT bk-cliente.
                    END. /* IF int-emitente-trib.ind-declaracao = YES THEN DO: */

                END. /* IF  AVAIL  int-emitente-trib THEN DO: */

            END. /* IF AVAILABLE int-emitente AND int-emitente.ind-forma-tributo <> tt-cliente.ind-forma-tributo THEN DO: */

            IF emitente.cod-emitente = 0 THEN DO:
                ASSIGN tt-cliente.cod-emitente          = ?
                       tt-cliente.new_status_integracao = "N∆o integrado.":U
                       tt-cliente.new_mensagem          = "Erro: Tentativa de alterar cliente com codigo zero, nao permitida.":U.

                ASSIGN tt-retorno.mensagem        = tt-cliente.new_mensagem.

                NEXT bk-cliente.
            END.

            BUFFER-COPY emitente except cod-emitente TO tt-cliente-valid .

            IF peAction = "D":U THEN
                ASSIGN tt-cliente-valid.ind-tipo-movto = 3. /* Eliminacao */
            ELSE
                ASSIGN tt-cliente-valid.ind-tipo-movto = 2.
        END.

        ASSIGN tt-cliente-valid.endereco = "":U.

        IF tt-cliente.endereco <> "":U THEN
            ASSIGN tt-cliente-valid.endereco = tt-cliente.endereco.

        IF tt-cliente.new_numero_endereco_principal <> "":U THEN DO:
            IF tt-cliente-valid.endereco <> "":U THEN
                ASSIGN tt-cliente-valid.endereco = tt-cliente-valid.endereco + ", ":U + tt-cliente.new_numero_endereco_principal.
            ELSE
                ASSIGN tt-cliente-valid.endereco = tt-cliente.new_numero_endereco_principal.
        END.

        IF tt-cliente.address1_line2 <> "":U THEN DO:
            IF tt-cliente-valid.endereco <> "":U THEN
                ASSIGN tt-cliente-valid.endereco = tt-cliente-valid.endereco + " - ":U + tt-cliente.address1_line2.
            ELSE
                ASSIGN tt-cliente-valid.endereco = tt-cliente.address1_line2.
        END.

        ASSIGN tt-cliente-valid.endereco-cob = "":U.

        IF tt-cliente.endereco-cob <> "":U THEN
            ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.endereco-cob.

        IF tt-cliente.new_numero_endereco_cobranca <> "":U THEN DO:
            IF tt-cliente-valid.endereco-cob <> "":U THEN
                ASSIGN tt-cliente-valid.endereco-cob = tt-cliente-valid.endereco-cob + ", ":U + tt-cliente.new_numero_endereco_cobranca.
            ELSE
                ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.new_numero_endereco_cobranca.
        END.

        IF tt-cliente.address2_line2 <> "":U THEN DO:
            IF tt-cliente-valid.endereco-cob <> "":U THEN
                ASSIGN tt-cliente-valid.endereco-cob = tt-cliente-valid.endereco-cob + " - ":U + tt-cliente.address2_line2.
            ELSE
                ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.address2_line2.
        END.

        ASSIGN tt-cliente-valid.cod-emitente            = tt-cliente.cod-emitente
               tt-cliente-valid.nome-emit               = tt-cliente.nome-emit
               tt-cliente-valid.nome-abrev              = tt-cliente.nome-abrev.
        IF AVAIL emitente THEN
            IF emitente.identific >= 2 THEN
               ASSIGN tt-cliente-valid.identific        = 3.
            ELSE
               ASSIGN tt-cliente-valid.identific        = tt-cliente.identific .
        ELSE
            ASSIGN tt-cliente-valid.identific               = tt-cliente.identific.
        ASSIGN tt-cliente-valid.cep                     = IF tt-cliente.estado = "EX" THEN "11111111" ELSE REPLACE(tt-cliente.cep, "-":U, "":U)
               tt-cliente-valid.bairro                  = tt-cliente.bairro
               tt-cliente-valid.cidade                  = tt-cliente.cidade
               tt-cliente-valid.estado                  = tt-cliente.estado
               tt-cliente-valid.pais                    = tt-cliente.pais
               tt-cliente-valid.cep-cob                 = IF tt-cliente.estado = "EX" THEN "11111111" ELSE REPLACE(tt-cliente.cep-cob, "-":U, "":U)
               tt-cliente-valid.end-cobranca            = tt-cliente.cod-emitente
               tt-cliente-valid.bairro-cob              = tt-cliente.bairro-cob  
               tt-cliente-valid.cidade-cob              = tt-cliente.cidade-cob  
               tt-cliente-valid.estado-cob              = tt-cliente.estado-cob  
               tt-cliente-valid.pais-cob                = tt-cliente.pais-cob    
               tt-cliente-valid.telefone[1]             = tt-cliente.telephone   
               tt-cliente-valid.ramal[1]                = tt-cliente.ramal       
               tt-cliente-valid.telefone[2]             = tt-cliente.telephone2  
               tt-cliente-valid.ramal[2]                = tt-cliente.ramal2      
               tt-cliente-valid.telefax                 = tt-cliente.fax         
               tt-cliente-valid.ramal-fax               = tt-cliente.ramalfax    
               tt-cliente-valid.e-mail                  = tt-cliente.email       
               tt-cliente-valid.home-page               = tt-cliente.home-page
               tt-cliente-valid.cod-rep                 = tt-cliente.cod-rep
               tt-cliente-valid.natureza                = tt-cliente.natureza    
               tt-cliente-valid.ins-municipal           = tt-cliente.ins-municipal
               tt-cliente-valid.cod-gr-cli              = tt-cliente.cod-gr-cli          
               tt-cliente-valid.contrib-icms            = tt-cliente.contrib-icms   
               tt-cliente-valid.cod-suframa             = tt-cliente.cod-suframa    
               tt-cliente-valid.cod-transp              = tt-cliente.cod-transp
               tt-cliente-valid.nome-tr-red             = tt-cliente.nome-tr-red
               tt-cliente-valid.cod-canal-venda         = tt-cliente.cod-canal-venda
               tt-cliente-valid.nome-mic-reg            = "1"
               tt-cliente-valid.insc-subs-trib          = tt-cliente.insc-subs-trib
               OVERLAY(tt-cliente-valid.char-1,  21, 1) = IF tt-cliente.i-susp-ipi             THEN "2":U ELSE "1":U
               tt-cliente-valid.agente-retencao         = tt-cliente.agente-retencao
               OVERLAY(tt-cliente-valid.char-1,  29, 1) = IF tt-cliente.i-calc-pis-cofins-unid THEN "S":U ELSE "N":U
               tt-cliente-valid.log-nf-eletro           = IF tt-cliente.i-recebe-nfe           THEN YES ELSE NO                   
               tt-cliente-valid.data-implant            = tt-cliente.data-implant
               tt-cliente-valid.cgc-cob                 = tt-cliente.cgc
               tt-cliente-valid.ins-est-cob             = tt-cliente.ins-estadual
               tt-cliente-valid.tip-cob-desp            = 2 /* Rateia despesas entre todas as duplicatas */
               overlay(tt-cliente-valid.char-1,103,20)  = tt-cliente.nro-passaporte.



        DO i-cont = 1 TO 2:
            ASSIGN tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],"(","")
                   tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],") ","")
                   tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],"-","").
        END.

        ASSIGN tt-cliente-valid.telefax     = REPLACE(tt-cliente-valid.telefax,"(","")
               tt-cliente-valid.telefax     = REPLACE(tt-cliente-valid.telefax,") ","")
               tt-cliente-valid.telefax     = REPLACE(tt-cliente-valid.telefax,"-","")
               tt-cliente-valid.cod-entrega = "Padr∆o":U.

        /* Campos que devem integrar EMS/CRM mas nao podem ser enviados do CRM/EMS */

        IF AVAILABLE emitente THEN
            ASSIGN tt-cliente-valid.lim-credito             = emitente.lim-credito
                   tt-cliente-valid.dt-lim-cred             = emitente.dt-lim-cred
/*                    tt-cliente-valid.modalidade              = emitente.modalidade  */
/*                    tt-cliente-valid.portador                = emitente.portador    */
                   tt-cliente-valid.cod-banco               = emitente.cod-banco
                   tt-cliente-valid.agencia                 = emitente.agencia
                   tt-cliente-valid.conta-corren            = emitente.conta-corren
                   tt-cliente-valid.tp-rec-padrao           = emitente.tp-rec-padrao
                   tt-cliente-valid.cod-cond-pag            = emitente.cod-cond-pag
                   tt-cliente-valid.emite-bloq              = emitente.emite-bloq
                   tt-cliente-valid.gera-ad                 = emitente.gera-ad
                   tt-cliente-valid.calcula-multa           = emitente.calcula-multa
                   tt-cliente-valid.recebe-inf-sci          = emitente.recebe-inf-sci
                   tt-cliente-valid.ind-aval                = 3.

        IF tt-cliente.nome-matriz = ? OR
           tt-cliente.nome-matriz = 0 THEN
            ASSIGN tt-cliente-valid.nome-matriz = tt-cliente.nome-abrev.
        ELSE DO:
            FIND FIRST b-emitente
                WHERE b-emitente.cod-emitente = tt-cliente.nome-matriz NO-LOCK NO-ERROR.

            IF AVAILABLE b-emitente THEN
                ASSIGN tt-cliente-valid.nome-matriz = b-emitente.nome-abrev.
            ELSE
                ASSIGN tt-cliente-valid.nome-matriz = tt-cliente.nome-abrev.
        END.

        CASE tt-cliente.natureza:
            WHEN 1 THEN DO:
                ASSIGN tt-cliente-valid.cgc          = REPLACE(REPLACE(tt-cliente.new_cpf, ".":U, "":U), "-":U, "":U)
                       tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.

                IF tt-cliente.ins-estadual = "":U THEN
                    ASSIGN tt-cliente-valid.ins-estadual = "ISENTO":U.
            END.
            WHEN 2 THEN DO:
                ASSIGN tt-cliente-valid.cgc          = REPLACE(REPLACE(REPLACE(tt-cliente.cgc, ".":U, "":U), "-":U, "":U), "~/":U, "":U)
                       tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
            END.
            WHEN 3 THEN DO:
                IF tt-cliente.cgc = "":U THEN
                    ASSIGN tt-cliente-valid.cgc = string(tt-cliente.cod-emitente).
                ELSE
                    ASSIGN tt-cliente-valid.cgc = tt-cliente.cgc.

                ASSIGN tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
            END.
            OTHERWISE DO:
                ASSIGN tt-cliente-valid.cgc          = tt-cliente.cgc
                       tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
            END.
        END CASE.

        /* Atualiza campos para mandar para o xml */

        ASSIGN tt-cliente.lim-credito    = tt-cliente-valid.lim-credito
               tt-cliente.dt-lim-cred    = tt-cliente-valid.dt-lim-cred
/*                tt-cliente.modalidade     = tt-cliente-valid.modalidade */
/*                tt-cliente.portador       = tt-cliente-valid.portador   */
               tt-cliente.cod-banco      = tt-cliente-valid.cod-banco
               tt-cliente.agencia        = tt-cliente-valid.agencia
               tt-cliente.conta-corren   = tt-cliente-valid.conta-corren
               tt-cliente.tp-rec-padrao  = tt-cliente-valid.tp-rec-padrao
               tt-cliente.cod-cond-pag   = STRING(tt-cliente-valid.cod-cond-pag)
               tt-cliente.emite-bloq     = tt-cliente-valid.emite-bloq
               tt-cliente.gera-ad        = tt-cliente-valid.gera-ad
               tt-cliente.calcula-multa  = tt-cliente-valid.calcula-multa
               tt-cliente.recebe-inf-sci = tt-cliente-valid.recebe-inf-sci
               tt-cliente.cgc            = tt-cliente-valid.cgc
               tt-cliente.ins-estadual   = tt-cliente-valid.ins-estadual.
               

        FIND FIRST b-emitente
            WHERE b-emitente.cod-emitente = tt-cliente.nome-matriz NO-LOCK NO-ERROR.

        IF AVAILABLE b-emitente THEN
            ASSIGN tt-cliente.nome-matriz = b-emitente.cod-emitente.

        /* Chamado 4744 - Envio ao banco */
        IF  tt-cliente-valid.cod-gr-cli = 25 THEN
            ASSIGN tt-cliente-valid.modalidade = 1
                   tt-cliente-valid.portador   = 999.

        /*Tarefa 2171: grupo 26 - BNDES seja parametrizado para n∆o enviar a cart¢rio.*/
        IF tt-cliente-valid.cod-gr-cli = 26 THEN
            ASSIGN tt-cliente-valid.ins-banc = 7.

        IF tt-cliente-valid.estado = "EX" THEN
            ASSIGN tt-cliente-valid.modalidade   = 1
                   tt-cliente-valid.portador    = 9999.
/*                    tt-cliente-valid.mod-prefer  = 1                   por solicitacao andre andersen */
/*                    tt-cliente-valid.port-prefer = 999.                                               */

        /* ALTERACAO SOLICITADA POR ANDRE ANDERSEN EM 10/04/11 */

/*         IF tt-cliente-valid.cod-gr-cli = 5 THEN                                                         */
/*             ASSIGN tt-cliente-valid.ind-cre-cli = 2. /* novos clientes Embratel entra com automatico */ */
/*         ELSE IF tt-cliente-valid.cod-gr-cli = 8  OR                                                     */
/*                 tt-cliente-valid.cod-gr-cli = 18 THEN                                                   */
/*             ASSIGN tt-cliente-valid.ind-cre-cli = 1. /* novos clientes Embratel entra com automatico */ */
/*         ELSE                                                                                            */
/*             ASSIGN tt-cliente-valid.ind-cre-cli = 4. /* novos clientes ficam com credito suspenso */    */

        /* ALTERACAO SOLICITADA POR ANDRE ANDERSEN EM 10/04/11 */
            

        IF tt-cliente-valid.estado = "EX" THEN
            ASSIGN tt-cliente-valid.ind-lib-estoque = YES.

        IF tt-cliente-valid.ind-tipo-movto <> 3 THEN DO:
            ASSIGN i-seq-erro = 1.

            FOR LAST tt-erros-crm
                BY tt-erros-crm.num-sequencia-erro:
                ASSIGN i-seq-erro = tt-erros-crm.num-sequencia-erro + 1.
            END.

            RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

            RUN pi-trata-endereco IN h-cdapi704 (INPUT  tt-cliente-valid.endereco,
                                                 OUTPUT c-rua,
                                                 OUTPUT c-nro,
                                                 OUTPUT c-comp).

            DELETE PROCEDURE h-cdapi704.

            IF c-nro = "":U THEN DO:
                CREATE tt-erros-crm.
                ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                       tt-erros-crm.cod-erro           = 1000
                       tt-erros-crm.tipo               = 1
                       tt-erros-crm.des-erro           = "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente":U
                       i-seq-erro                      = i-seq-erro + 1.
            END.

            IF LENGTH(TRIM(c-comp)) = 1 THEN DO:
                CREATE tt-erros-crm.
                ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                       tt-erros-crm.cod-erro           = 1001
                       tt-erros-crm.tipo               = 1
                       tt-erros-crm.des-erro           = "Complemento do Endereco apenas com uma posiá∆o, SEFAZ exige que tenha mais de uma posiá∆o":U
                       i-seq-erro                      = i-seq-erro + 1.
            END.

/*             IF tt-cliente-valid.natureza = 2 THEN DO: /* Pessoa Juridica */                                                                      */
/*                 IF tt-cliente-valid.ins-estadual = "ISENTO":U AND                                                                                */
/*                    tt-cliente-valid.contrib-icms = YES        THEN DO:                                                                           */
/*                     CREATE tt-erros-crm.                                                                                                         */
/*                     ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro                                                                          */
/*                            tt-erros-crm.cod-erro           = 1002                                                                                */
/*                            tt-erros-crm.tipo               = 1                                                                                   */
/*                            tt-erros-crm.des-erro           = "Cliente n∆o possui inscriá∆o estadual e esta marcado o campo Contribuinte ICMS.":U */
/*                            i-seq-erro                      = i-seq-erro + 1.                                                                     */
/*                 END.                                                                                                                             */
/*                                                                                                                                                  */
/*                 IF tt-cliente-valid.ins-estadual    <> "ISENTO":U AND                                                                            */
/*                    NOT tt-cliente-valid.contrib-icms = YES        THEN DO:                                                                       */
/*                     CREATE tt-erros-crm.                                                                                                         */
/*                     ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro                                                                          */
/*                            tt-erros-crm.cod-erro           = 1003                                                                                */
/*                            tt-erros-crm.tipo               = 1                                                                                   */
/*                            tt-erros-crm.des-erro           = "Cliente marcado como n∆o contribuinte ICMS, inscriá∆o estadual deve ser Isento.":U */
/*                            i-seq-erro                      = i-seq-erro + 1.                                                                     */
/*                 END.                                                                                                                             */
/*             END.                                                                                                                                 */

            IF tt-cliente-valid.natureza  <> 2 /*OR
               tt-cliente-valid.cod-gr-cli = 5*/ THEN DO:
                IF tt-cliente.ind-forma-tributo <> 4 THEN DO:
                    CREATE tt-erros-crm.
                    ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                           tt-erros-crm.cod-erro           = 1004
                           tt-erros-crm.tipo               = 1
                           tt-erros-crm.des-erro           = "Para Pessoa Fisica ou Exportaá∆o ou grupo 5 Informe a forma de tributacao 4, qualquer duvida entre em contato com a controladoria.":U
                           i-seq-erro                      = i-seq-erro + 1.
                END.
            END.
            ELSE DO:
                IF tt-cliente.ind-forma-tributo = 0 OR
                   tt-cliente.ind-forma-tributo = 4 THEN DO:
                    CREATE tt-erros-crm.
                    ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                           tt-erros-crm.cod-erro           = 1005
                           tt-erros-crm.tipo               = 1
                           tt-erros-crm.des-erro           = "Informe a forma de tributacao, qualquer duvida entre em contato com a controladoria.":U
                           i-seq-erro                      = i-seq-erro + 1.
                END.
            END.

            /** Valida se na hora do cadastro o campo bairro est† em branco **/
            IF tt-cliente.bairro = "" THEN DO:
                CREATE tt-erros-crm.
                    ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                           tt-erros-crm.cod-erro           = 1006
                           tt-erros-crm.tipo               = 1
                           tt-erros-crm.des-erro           = "O Bairro n∆o foi informado.":U
                           i-seq-erro                      = i-seq-erro + 1.
            END.

            /*** Valida CGC/CPF Cliente ***/
            IF NOT CAN-FIND(FIRST tt-erros-crm
                            WHERE tt-erros-crm.tipo = 1) THEN DO:
                RUN esp/cdp/escdp027.p (INPUT  tt-cliente-valid.cgc,
                                        INPUT  tt-cliente-valid.natureza,
                                        OUTPUT TABLE tt-erros-geral).

                FOR EACH tt-erros-geral
                    WHERE tt-erros-geral.identif-msg = "1":U:
                    CREATE tt-erros-crm.
                    ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                           tt-erros-crm.tipo               = 1
                           tt-erros-crm.cod-erro           = tt-erros-geral.cod-erro
                           tt-erros-crm.des-erro           = tt-erros-geral.des-erro
                           i-seq-erro                      = i-seq-erro + 1.
                END.
            END.

            IF NOT CAN-FIND(FIRST tt-erros-crm WHERE tt-erros-crm.tipo = 1)         AND
               tt-cliente-valid.natureza                               = 2          AND
               tt-cliente-valid.ins-estadual                          <> "ISENTO":U THEN DO:
                RUN cdp/cd6667.p(INPUT  tt-cliente-valid.pais,
                                 INPUT  tt-cliente-valid.estado,
                                 INPUT  tt-cliente-valid.ins-estadual,
                                 OUTPUT c-cod-erro,
                                 OUTPUT c-cod-ie-sai).

                ASSIGN c-des-msg = " ":U.

                CASE c-cod-erro:
                    WHEN "ERRO FORMATO":U THEN
                        ASSIGN c-des-msg = "Erro no formato da I.E":U.
                    WHEN "ERRO PRIM DIG":U THEN
                        ASSIGN c-des-msg = "UF tem dig. fixos nao inform. na IE":U.
                    WHEN "ERRO DV":U THEN
                        ASSIGN c-des-msg = "Digito verificador da I.E. Invalido":U.
                END CASE.

                IF c-des-msg <> " ":U THEN DO:
                    CREATE tt-erros-crm.
                    ASSIGN tt-erros-crm.num-sequencia-erro = i-seq-erro
                           tt-erros-crm.cod-erro           = 1006
                           tt-erros-crm.tipo               = 1
                           tt-erros-crm.des-erro           = c-des-msg
                           i-seq-erro                      = i-seq-erro + 1.
                END.
            END.

            EMPTY TEMP-TABLE tt-erros-geral.
        END.

        IF NOT CAN-FIND(FIRST tt-erros-crm
                        WHERE tt-erros-crm.tipo = 1) THEN DO:

            bloco_trans:
            DO ON ERROR UNDO bloco_trans, LEAVE bloco_trans:
                EMPTY TEMP-TABLE tt-versao-integr.

                CREATE tt-versao-integr.
                ASSIGN tt-versao-integr.cod-versao-integracao = 001.

                RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                                    OUTPUT TABLE tt-erros-geral,
                                    INPUT  TABLE tt-cliente-valid,
                                    INPUT  TABLE tt-loc-entr-valid,
                                    INPUT  TABLE tt-dist-emit-valid).

                /* Nao considera mensagem 18655 */
                FOR EACH tt-erros-geral
                    WHERE tt-erros-geral.cod-erro <> 18655:
                    CREATE tt-erros-crm.
                    BUFFER-COPY tt-erros-geral TO tt-erros-crm.
                END.

                IF CAN-FIND(FIRST tt-erros-geral) THEN
                    UNDO bloco_trans.
            END.

            FOR EACH tt-erros-crm
                WHERE tt-erros-crm.tipo = 1:
                CREATE tt-erros-geral.
                BUFFER-COPY tt-erros-crm TO tt-erros-geral.
            END.
        END.
        ELSE DO:
            FOR EACH tt-erros-crm
                WHERE tt-erros-crm.tipo = 1:
                CREATE tt-erros-geral.
                BUFFER-COPY tt-erros-crm TO tt-erros-geral.
            END.
        END.

        IF CAN-FIND(FIRST tt-erros-geral) THEN DO:
            FIND FIRST tt-erros-geral NO-ERROR.

            IF AVAILABLE tt-erros-geral THEN
                ASSIGN tt-retorno.mensagem = tt-erros-geral.des-erro.

            FIND FIRST b-emitente
                WHERE b-emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE b-emitente THEN
                ASSIGN tt-retorno.chaveintegracao = string(tt-cliente-valid.cod-emitente).
            ELSE
                ASSIGN tt-retorno.chaveintegracao = "":U.

            IF peAction = "C":U THEN
                ASSIGN tt-cliente.cod-emitente = ?.

            ASSIGN tt-cliente.new_status_integracao = "N∆o integrado.":U
                   tt-cliente.new_mensagem          = "Erro: ":U + c-erro + ". Erro na integraá∆o CRM com ERP (Tabela emitente).":U.

            NEXT bk-cliente.
        END.
        ELSE DO:
            
            FIND FIRST emitente
                WHERE emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            
                /**** Grava o cod-suframa e insc-subs-trib, a api da datasul n∆o grava esses campos ****/
            IF tt-cliente-valid.ind-tipo-movto = 1 THEN DO: /*  Somente inclus∆o */
                IF tt-cliente-valid.cod-gr-cli = 30 THEN
                    ASSIGN emitente.ind-cre-cli = 1
                           emitente.observacoes = "Liberado sem avaliaá∆o de crÇdito para p¢s venda":U
                           emitente.lim-credito = 0 /* novos clientes Embratel entra com Automatico */
                           emitente.dt-lim-cred = DATE(01, 01, 1990).
                ELSE IF emitente.cod-gr-cli = 95   AND
                        emitente.cod-rep    = 1010 THEN
                    ASSIGN emitente.ind-cre-cli = 1
                           emitente.observacoes = "Cliente faz parte do programa fidelidade e n∆o possui documentaá∆o para fins de crÇdito"
                           emitente.lim-credito = 0    /* novos clientes Embratel entra com Automatico */
                           emitente.dt-lim-cred = DATE(01, 01, 1990).
                ELSE DO:
                    FIND FIRST ponto-programa
                        WHERE ponto-programa.nome-programa = "escrm004":U
                          AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
    
                    IF AVAILABLE ponto-programa THEN DO:
                        IF can-find(first conteudo-programa NO-LOCK
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                              AND emitente.cgc BEGINS ENTRY(1,conteudo-programa.conteudo,",")) THEN DO:
                            
                            ASSIGN emitente.ind-cre-cli = 1
                                   emitente.observacoes = "Cliente Banco - parametrizado para entrar com parametro de credito NORMAL"
                                   emitente.lim-credito = 0    /* novos clientes Embratel entra com Automatico */
                                   emitente.dt-lim-cred = DATE(01, 01, 1990).
    
                            if avail int-emitente then
                               assign int-emitente.cod-gr-cob = 6.
                        END.
                        ELSE
                            ASSIGN emitente.ind-cre-cli = 4.
                    END.
                    ELSE
                        ASSIGN emitente.ind-cre-cli = 4.
                END.
            END.
            IF tt-cliente-valid.ind-tipo-movto <> 3 THEN DO:
                IF AVAILABLE emitente THEN DO:
                    ASSIGN emitente.cod-suframa    = tt-cliente.cod-suframa
                           emitente.insc-subs-trib = tt-cliente.insc-subs-trib
                           emitente.nome-matriz    = tt-cliente-valid.nome-matriz.

                    IF tt-cliente.nome-tr-red <> "":U THEN DO:
                        FIND FIRST transporte
                            WHERE transporte.cod-transp = INTEGER(tt-cliente.nome-tr-red) NO-LOCK NO-ERROR.

                        IF AVAILABLE transporte THEN
                            ASSIGN emitente.nome-tr-red = transporte.nome-abrev.
                        ELSE
                            ASSIGN emitente.nome-tr-red = "":U.
                    END.
                    ELSE
                        ASSIGN emitente.nome-tr-red = "":U.
                END.
            END.

            ASSIGN tt-retorno.mensagem        = "":U
                   tt-retorno.chaveintegracao = STRING(tt-cliente-valid.cod-emitente).
        END.

        IF tt-cliente-valid.ind-tipo-movto <> 3 THEN DO:
            IF tt-cliente.cod-emitente = ? THEN DO:
                FIND FIRST b-emitente
                    WHERE b-emitente.nome-abrev = tt-cliente.nome-abrev NO-LOCK NO-ERROR.

                IF AVAILABLE b-emitente THEN
                    ASSIGN tt-cliente.cod-emitente = b-emitente.cod-emitente.
            END.

            ASSIGN tt-retorno.mensagem = "":U.

            IF peAction = "W":U THEN
                ASSIGN tt-retorno.chaveintegracao = string(tt-cliente.cod-emitente).

            FOR EACH tt-atributo-entrada
                WHERE tt-atributo-entrada.tipo = "atributo":U:
                IF tt-atributo-entrada.nome = "crmid":U THEN DO:
                    CASE tt-atributo-entrada.nome-pai:
                        WHEN "cod-emitente":U THEN DO:
                            FIND FIRST int-emitente
                                WHERE int-emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

                            IF AVAILABLE int-emitente THEN
                                ASSIGN int-emitente.vl-guid = tt-atributo-entrada.valor.
                            ELSE DO:
                                CREATE int-emitente.
                                ASSIGN int-emitente.cod-emitente = tt-cliente.cod-emitente
                                       int-emitente.vl-guid      = tt-atributo-entrada.valor.
                            END.

                            FIND FIRST int-emitente-cex
                                WHERE int-emitente-cex.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

                            IF NOT AVAILABLE int-emitente-cex THEN DO:
                                CREATE int-emitente-cex.
                                ASSIGN int-emitente-cex.cod-emitente = tt-cliente.cod-emitente.
                            END.
                        END.
                        WHEN "nome-matriz":U THEN DO:
                            IF tt-cliente.nome-matriz = ? OR
                               tt-cliente.nome-matriz = 0 THEN DO:
                                FIND FIRST int-emitente
                                    WHERE int-emitente.cod-emitente = tt-cliente.nome-matriz EXCLUSIVE-LOCK NO-ERROR.

                                IF AVAILABLE int-emitente THEN
                                    ASSIGN int-emitente.vl-guid = tt-atributo-entrada.valor.
                                ELSE DO:
                                    CREATE int-emitente.
                                    ASSIGN int-emitente.cod-emitente = tt-cliente.nome-matriz
                                           int-emitente.vl-guid      = tt-atributo-entrada.valor.
                                END.

                                FIND FIRST int-emitente-cex
                                    WHERE int-emitente-cex.cod-emitente = tt-cliente.nome-matriz EXCLUSIVE-LOCK NO-ERROR.

                                IF NOT AVAILABLE int-emitente-cex THEN DO:
                                    CREATE int-emitente-cex.
                                    ASSIGN int-emitente-cex.cod-emitente = tt-cliente.nome-matriz.
                                END.
                            END.
                        END.
                    END CASE.
                END.
            END.

            FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE int-emitente THEN DO:
                ASSIGN int-emitente.vl-desconto-cat   = tt-cliente.vl-desconto-cat
                       int-emitente.tipo-embalagem    = tt-cliente.tipo-embalagem
                       int-emitente.observacao-ped    = tt-cliente.observacao-ped
                       int-emitente.dispositivo-legal = tt-cliente.dispositivo-legal
                       int-emitente.dt-vcto-concessao = tt-cliente.dt-vcto-concessao
                       int-emitente.ind-forma-tributo = tt-cliente.ind-forma-tributo
                       int-emitente.ind-vendas-alc    = IF tt-cliente.ind-vendas-alc THEN 1 /* YES */ ELSE 0 /* NO */
                       int-emitente.dt-ult-atualizacao = TODAY
                       int-emitente.logradouro        = tt-cliente.endereco                         
                       int-emitente.numero            = tt-cliente.new_numero_endereco_principal    
                       int-emitente.complemento       = tt-cliente.address1_line2
                       int-emitente.logradouro-cob    = tt-cliente.endereco-cob                         
                       int-emitente.numero-cob        = tt-cliente.new_numero_endereco_cobranca
                       int-emitente.complemento-cob   = tt-cliente.address2_line2 .

                ASSIGN l-atualizou = NO.
                IF tt-cliente.id-ativo = 1 AND 
                   int-emitente.id-ativo = NO THEN
                    ASSIGN int-emitente.id-ativo = YES
                           l-atualizou = YES.
                ELSE
                    IF tt-cliente.id-ativo = 0 AND 
                       int-emitente.id-ativo = YES THEN
                       ASSIGN int-emitente.id-ativo = NO
                              l-atualizou = YES.
    
                IF l-atualizou = YES THEN DO:
                    FIND LAST int-emitente-historico NO-LOCK
                        WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente NO-ERROR.
                    IF NOT AVAIL int-emitente-historico THEN
                        ASSIGN i-seq = 1.
                    ELSE 
                        ASSIGN i-seq = int-emitente-historico.sequencia + 1.
    
                    CREATE int-emitente-historico.
                    ASSIGN int-emitente-historico.cod-emitente = emitente.cod-emitente
                           int-emitente-historico.tipo         = 1
                           int-emitente-historico.sequencia    = i-seq
                           int-emitente-historico.dt-movto     = TODAY
                           int-emitente-historico.hr-movto     = STRING(TIME,"HH:MM:SS")
                           int-emitente-historico.usuario      = c-usuario
                           int-emitente-historico.id-ativo     = int-emitente.id-ativo
                           int-emitente-historico.motivo       = "Alterado pelo CRM".
                END.

            END.

            FIND FIRST int-emitente-cex
                WHERE int-emitente-cex.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE int-emitente-cex THEN DO:
                CREATE int-emitente-cex.
                ASSIGN int-emitente-cex.cod-emitente = tt-cliente.cod-emitente.
            END.

            IF AVAILABLE int-emitente-cex THEN
                ASSIGN int-emitente-cex.local-embarque = tt-cliente.local-embarque
                       int-emitente-cex.embarque-via   = tt-cliente.embarque-via.

            FIND FIRST emitente-cex
                WHERE emitente-cex.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE emitente-cex THEN DO:
                CREATE emitente-cex.
                ASSIGN emitente-cex.cod-emitente = tt-cliente.cod-emitente.
            END.

            ASSIGN emitente-cex.cod-incoterm-exp = tt-cliente.cod-incoterm-exp.

            FIND FIRST loc-entr
                WHERE loc-entr.nome-abrev  = tt-cliente.nome-abrev
                  AND loc-entr.cod-entrega = "Padr∆o":U EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED(loc-entr) THEN DO:
                ASSIGN c-usuario-alocando = "".
                for first _Lock
                    where _Lock._Lock-Flags = "X":
                    for first _file
                        where _file._File-Number = _Lock._Lock-Table: END.
                    for first _UserLock
                        where _UserLock._UserLock-id = _Lock._Lock-Usr: END.       
                   for first _Connect
                       where _Connect._Connect-Usr = _Lock._Lock-Usr: END.        
                    ASSIGN c-usuario-alocando = _Lock._Lock-Name.
                end.
                ASSIGN tt-cliente.cod-emitente          = ?
                               tt-cliente.new_status_integracao = "N∆o integrado.":U
                               tt-cliente.new_mensagem          = "Erro: O Registro em questao esta alocado pelo usuario : " + c-usuario-alocando + ", aguarde a liberacao ou entre em contato. Erro na integraá∆o CRM com ERP (Tabela loc-entr).":U.
    
                        ASSIGN tt-retorno.mensagem = tt-cliente.new_mensagem.
    
                        NEXT bk-cliente.
            END.

            IF NOT CAN-FIND(FIRST mgcad.cidade WHERE cidade.cidade = tt-cliente.cidade 
                                       AND cidade.estado = tt-cliente.estado NO-LOCK) THEN DO: 
                ASSIGN tt-cliente.cod-emitente          = ?
                               tt-cliente.new_status_integracao = "N∆o integrado.":U
                               tt-cliente.new_mensagem          = "Erro: Cidade Informada NO Local de entrega n∆o existe NO ERP, favor corrigir ou solicitar cadastramento para grupo.tributario":U.
    
                        ASSIGN tt-retorno.mensagem = tt-cliente.new_mensagem.
    
                        NEXT bk-cliente.
            END.

            IF NOT AVAILABLE loc-entr THEN DO:
                ASSIGN l-web-service = NO.

                CREATE loc-entr.
                ASSIGN loc-entr.nome-abrev   = tt-cliente.nome-abrev
                       loc-entr.cod-entrega  = "Padr∆o":U.

                ASSIGN l-web-service = YES.
            END.

            ASSIGN loc-entr.endereco = "":U.

            IF tt-cliente.endereco <> "":U THEN
                ASSIGN loc-entr.endereco = tt-cliente.endereco.

            IF tt-cliente.new_numero_endereco_principal <> "":U THEN DO:
                IF loc-entr.endereco <> "":U THEN
                    ASSIGN loc-entr.endereco = loc-entr.endereco + ", ":U + tt-cliente.new_numero_endereco_principal.
                ELSE
                    ASSIGN loc-entr.endereco = tt-cliente.new_numero_endereco_principal.
            END.

            IF tt-cliente.address1_line2 <> "":U THEN DO:
                IF loc-entr.endereco <> "":U THEN
                    ASSIGN loc-entr.endereco = loc-entr.endereco + " - ":U + tt-cliente.address1_line2.
                ELSE
                    ASSIGN loc-entr.endereco = tt-cliente.address1_line2.
            END.

            ASSIGN /*loc-entr.endereco     = SUBSTRING(tt-cliente.endereco, 1, 40)*/
                   loc-entr.bairro       = tt-cliente.bairro
                   loc-entr.cidade       = tt-cliente.cidade
                   loc-entr.estado       = tt-cliente.estado
                   loc-entr.cep          = IF tt-cliente.estado = "EX" THEN "11111111" ELSE REPLACE(tt-cliente.cep, "-":U, "":U)
                   loc-entr.pais         = tt-cliente.pais
                   loc-entr.cgc          = tt-cliente.cgc
                   loc-entr.ins-estadual = tt-cliente.ins-estadual
                   loc-entr.e-mail       = tt-cliente.email
                   loc-entr.nom-cidad-cif  = tt-cliente.cidade.

            FIND FIRST transporte
                WHERE transporte.cod-transp = tt-cliente.cod-transp NO-LOCK NO-ERROR.

            IF AVAILABLE transporte THEN
                ASSIGN loc-entr.nome-transp = transporte.nome-abrev.

            FIND FIRST int-loc-entr
                WHERE int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                  AND int-loc-entr.cod-entrega = loc-entr.cod-entrega EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE int-loc-entr THEN DO:
                CREATE int-loc-entr.
                ASSIGN int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                       int-loc-entr.cod-entrega = loc-entr.cod-entrega.
            END.

            ASSIGN int-loc-entr.endereco-completo = loc-ent.endereco.
        END.
        ELSE DO:
            ASSIGN tt-retorno.mensagem = "Nao encontrou registro para eliminacao":U.

            FIND FIRST tt-atributo-entrada
                WHERE tt-atributo-entrada.nome-pai = "new_chaveintegracao":U NO-ERROR.

            IF AVAILABLE tt-atributo-entrada THEN DO:
                FOR FIRST int-emitente EXCLUSIVE-LOCK
                    WHERE int-emitente.vl-guid = tt-atributo-entrada.valor,
                    FIRST emitente EXCLUSIVE-LOCK
                    WHERE emitente.cod-emitente = int-emitente.cod-emitente:
                    DELETE emitente.

                    ASSIGN tt-retorno.mensagem = "":U.
                END.
            END.
        END.

        RELEASE emitente.
        RELEASE int-emitente.
        RELEASE emitente-cex.
        RELEASE loc-entr.
        RELEASE int-loc-entr.

    END. /* FOR FIRST tt-cliente */

    RETURN "OK".

END. /* "Account" */

IF peEntity = "customeraddress" /* local de entrega */ 
THEN DO:

        CREATE tt-loc-entr.

        RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.  /* Procedures de leitura do xml */
        RUN readXML IN h-escrm005 (INPUT BUFFER tt-loc-entr:HANDLE,
                                   INPUT  peMessage,
                                   OUTPUT TABLE tt-atributo-entrada).                      
        

        IF VALID-HANDLE(h-escrm005) 
        THEN DELETE PROCEDURE h-escrm005.

        LOG-MANAGER:WRITE-MESSAGE('001 nome-abrev: ' + string(tt-loc-entr.nome-abrev), 'DEBUG') NO-ERROR.

        FIND FIRST tt-loc-entr EXCLUSIVE-LOCK NO-ERROR.

        find first b-emitente no-lock where
                   b-emitente.cod-emitente = tt-loc-entr.nome-abrev no-error. 

        LOG-MANAGER:WRITE-MESSAGE('002 nome-abrev: ' + string(tt-loc-entr.nome-abrev), 'DEBUG') NO-ERROR.

        IF AVAILABLE tt-loc-entr AND
           AVAILABLE b-emitente
        THEN DO:
                   
               /*IF peAction = "W" THEN  
               ASSIGN tt-retorno.chaveintegracao = TRIM(STRING(tt-loc-entr.nome-abrev)) + ",":U + TRIM(STRING(tt-loc-entr.cod-entrega)).
                */

            ASSIGN  tt-retorno.mensagem        = "". 

            if peAction <> "D"
            then do:                      
            
                ASSIGN tt-loc-entr.new_chaveintegracao = TRIM(STRING(tt-loc-entr.nome-abrev)) + ",":U + TRIM(STRING(tt-loc-entr.cod-entrega))
                       tt-loc-entr.addresstypecode     = 1
                       tt-loc-entr.objecttypecode      = "account":U
                       tt-loc-entr.new_exporta_erp     = "":U.
                
                assign i-seq-erro = 1.
                               
                for last tt-erros-crm by tt-erros-crm.num-sequencia-erro:
                    assign i-seq-erro = tt-erros-crm.num-sequencia-erro + 1.
                end.    

                RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                RUN pi-trata-endereco IN h-cdapi704 (INPUT  tt-loc-entr.endereco + tt-loc-entr.new_numero_endereco,
                                                     OUTPUT c-rua, 
                                                     OUTPUT c-nro, 
                                                     OUTPUT c-comp).

                DELETE PROCEDURE h-cdapi704.
                /*
                IF c-nro = "" THEN DO:
                     create tt-erros-crm.
                     assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                            tt-erros-crm.cod-erro           = 1000
                            tt-erros-crm.des-erro           = "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente"
                            i-seq-erro                      = i-seq-erro + 1.              
                     
                END.
                */
                IF NOT CAN-FIND(FIRST mgcad.cidade WHERE cidade.cidade = tt-loc-entr.cidade 
                                           AND cidade.estado            = tt-loc-entr.estado NO-LOCK) THEN DO: 
                   create tt-erros-crm.
                   assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                          tt-erros-crm.cod-erro           = 1001
                          tt-erros-crm.des-erro           = "Erro: Cidade Informada NO Local de entrega n∆o existe NO ERP, favor corrigir ou solicitar cadastramento para grupo.tributario":U.
                          i-seq-erro                      = i-seq-erro + 1.     
                END.
                IF length(trim(c-comp)) = 1 
                THEN DO:
                   create tt-erros-crm.
                   assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                          tt-erros-crm.cod-erro           = 1001
                          tt-erros-crm.des-erro           = "Complemento do Endereco apenas com uma posiá∆o, SEFAZ exige que tenha mais de uma posiá∆o"
                          i-seq-erro                      = i-seq-erro + 1.            
                END.

                if can-find(first tt-erros-crm)
                then do:
                    FOR FIRST tt-erros-crm:    

                      ASSIGN tt-retorno.mensagem  = STRING(tt-erros-crm.des-erro).
                    end.
                                        
                    ASSIGN tt-loc-entr.new_status_integracao = "N∆o integrado.":U
                           tt-loc-entr.new_mensagem          = "Erro: ":U + c-erro + ". Erro na integraá∆o CRM com ERP (Tabela Local de entrega).":U.
                end.
                else do:
                    
                    IF peAction = "W" THEN
                       ASSIGN c-entrega = tt-loc-entr.cod-entrega.
                    ELSE DO:
                       FIND FIRST loc-entr WHERE 
                                  loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                                  loc-entr.cod-entrega = tt-loc-entr.cod-entrega NO-LOCK NO-ERROR.
                       IF NOT AVAILABLE loc-entr 
                       THEN 
                          ASSIGN c-entrega = tt-loc-entr.cod-entrega. 
                       ELSE DO:

                          ASSIGN i-cont = 0
                                 c-entrega = "".

                          IF INDEX(tt-loc-entr.cod-entrega, "-") > 0 THEN
                             ASSIGN c-entrega = substring(tt-loc-entr.cod-entrega,1,r-index(tt-loc-entr.cod-entrega,"-") - 1).
                          ELSE 
                             ASSIGN c-entrega = tt-loc-entr.cod-entrega.  

                          FOR EACH loc-entr NO-LOCK WHERE
                                   loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                                   loc-entr.cod-entrega BEGINS  c-entrega:

                              ASSIGN i-cont = i-cont + 1.
                                    
                          END.

                          ASSIGN c-entrega = c-entrega + "-" + STRING(i-cont,"99").
                           
                       END.
                    END.
                     
                    FIND FIRST int-loc-entr WHERE 
                               int-loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                               int-loc-entr.cod-entrega = c-entrega EXCLUSIVE-LOCK NO-ERROR.
        
                    IF NOT AVAILABLE int-loc-entr 
                    THEN DO:
                        CREATE int-loc-entr.
                        ASSIGN int-loc-entr.nome-abrev        = b-emitente.nome-abrev
                               int-loc-entr.cod-entrega       = c-entrega
                               int-loc-entr.endereco-completo = trim(substring(tt-loc-entr.endereco,1,80)) + ", ":U + tt-loc-entr.new_numero_endereco
                               int-loc-entr.logradouro        = tt-loc-entr.endereco
                               int-loc-entr.numero            = tt-loc-entr.new_numero_endereco
                               int-loc-entr.complemento       = tt-loc-entr.line3. 
                                        
                         find first tt-atributo-entrada where
                                    tt-atributo-entrada.nome-pai = "new_chaveintegracao":U and
                                    tt-atributo-entrada.nome     = "crmid" no-error.
                         if avail tt-atributo-entrada then
                            assign int-loc-entr.vl-guid = tt-atributo-entrada.valor.                                                    
                    END.
                    ELSE 
                      ASSIGN int-loc-entr.endereco-completo = trim(substring(tt-loc-entr.endereco,1,80)) + ", ":u + tt-loc-entr.new_numero_endereco. 
                      
                      
                    FIND FIRST loc-entr  WHERE 
                               loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                               loc-entr.cod-entrega = c-entrega EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

                    IF LOCKED(loc-entr) THEN DO:
                        ASSIGN c-usuario-alocando = "".
                        for first _Lock
                            where _Lock._Lock-Flags = "X":
                            for first _file
                                where _file._File-Number = _Lock._Lock-Table: END.
                            for first _UserLock
                                where _UserLock._UserLock-id = _Lock._Lock-Usr: END.       
                           for first _Connect
                               where _Connect._Connect-Usr = _Lock._Lock-Usr: END.        
                            ASSIGN c-usuario-alocando = _Lock._Lock-Name.
                        end.
                        create tt-erros-crm.
                        assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                               tt-erros-crm.cod-erro           = 1001
                               tt-erros-crm.des-erro           = "Erro: O Registro em questao esta alocado pelo usuario : " + c-usuario-alocando + ", aguarde a liberacao ou entre em contato. Erro na integraá∆o CRM com ERP (Tabela loc-entr - Parte2)."
                               i-seq-erro                      = i-seq-erro + 1.  
                    END.

        
                    IF NOT AVAILABLE loc-entr THEN DO:        
                        CREATE loc-entr.
                        ASSIGN loc-entr.nome-abrev   = b-emitente.nome-abrev 
                               loc-entr.cod-entrega  = c-entrega.
                    END.   

                    FIND FIRST loc-entr  WHERE 
                               loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                               loc-entr.cod-entrega = c-entrega EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

                    ASSIGN tt-retorno.cod-entrega     = loc-entr.cod-entrega
                           tt-retorno.chaveintegracao = TRIM(STRING(b-emitente.cod-emitente)) + ",":U + TRIM(STRING(loc-entr.cod-entrega)).

                    ASSIGN loc-entr.endereco = "":U.
                    
                    IF tt-loc-entr.endereco <> "":U THEN
                        ASSIGN loc-entr.endereco = tt-loc-entr.endereco.

                    IF tt-loc-entr.new_numero_endereco <> "":U THEN DO:
                        IF loc-entr.endereco <> "":U THEN
                            ASSIGN loc-entr.endereco = loc-entr.endereco + ", ":U + tt-loc-entr.new_numero_endereco.
                        ELSE
                            ASSIGN loc-entr.endereco = tt-loc-entr.new_numero_endereco.
                    END.
                    
                    IF tt-loc-entr.line3 <> "":U THEN DO:
                        IF loc-entr.endereco <> "":U THEN
                            ASSIGN loc-entr.endereco = loc-entr.endereco + " - ":U + tt-loc-entr.line3.
                        ELSE
                            ASSIGN loc-entr.endereco = tt-loc-entr.line3.

                        IF int-loc-entr.endereco-completo <> "":U THEN
                            ASSIGN int-loc-entr.endereco-completo = int-loc-entr.endereco-completo + " - ":U + tt-loc-entr.line3.
                        ELSE
                            ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.line3.
                    END.
                    
                    assign /*loc-entr.endereco     = substring(tt-loc-entr.endereco,1,40)*/
                           loc-entr.bairro       = tt-loc-entr.bairro
                           loc-entr.cidade       = tt-loc-entr.cidade
                           loc-entr.estado       = tt-loc-entr.estado
                           loc-entr.pais         = tt-loc-entr.pais
                           loc-entr.cep          = IF tt-cliente.estado = "EX" THEN "11111111" ELSE REPLACE(tt-loc-entr.cep, "-":U, "":U)  
                           loc-entr.ins-estadual = tt-loc-entr.ins-estadual
                           loc-entr.e-mail       = tt-loc-entr.e-mail.                         
                              
                    ASSIGN c-cgc        = REPLACE(tt-loc-entr.cgc,".","")
                           c-cgc        = REPLACE(c-cgc,"/","")    
                           c-cgc        = REPLACE(c-cgc,"-","")    
                           loc-entr.cgc = c-cgc.  

                    if loc-entr.cgc = "" 
                    then assign loc-entr.cgc = b-emitente.cgc. 
    
                    ASSIGN tt-loc-entr.new_status_integracao = "Integrado com sucesso."
                           tt-loc-entr.new_mensagem          = "".     
                end.
            end. 
            else do:
                                                        
                ASSIGN tt-retorno.mensagem   = "Nao encontrou registro para eliminacao".

                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do:                    
                                        
                   find first int-loc-entr no-lock where 
                             int-loc-entr.vl-guid = tt-atributo-entrada.valor NO-ERROR.

                   if avail int-loc-entr then do:
                       find first loc-entr exclusive-lock where
                                 loc-entr.nome-abrev  = int-loc-entr.nome-abrev and 
                                 loc-entr.cod-entrega = int-loc-entr.cod-entrega no-error.

                        if avail loc-entr then
                            delete loc-entr.       

                        ASSIGN tt-retorno.mensagem = "".
                                   
                   end.                                       

                end.                             
            end.
                        
            release loc-entr.
            release int-loc-entr.            

                    
        end.

        RETURN "OK".

END.  /* CustomerAddress */

IF peEntity = "contact":U THEN DO: /* Contato */
    EMPTY TEMP-TABLE tt-cont-emit.

    CREATE tt-cont-emit.

    RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.  /* Procedures de leitura do xml */
    RUN readXML IN h-escrm005 (INPUT  BUFFER tt-cont-emit:HANDLE,
                               INPUT  peMessage,
                               OUTPUT TABLE tt-atributo-entrada).


    IF VALID-HANDLE(h-escrm005) 
    THEN DELETE PROCEDURE h-escrm005.
    FIND FIRST tt-cont-emit NO-ERROR.

    IF AVAILABLE tt-cont-emit THEN DO:
        ASSIGN tt-retorno.mensagem = "":U.

        IF peAction <> "D":U THEN DO:

            FIND FIRST emitente
                WHERE emitente.cod-emitente = tt-cont-emit.cod-emitente NO-LOCK NO-ERROR.

            IF NOT AVAILABLE emitente THEN
                ASSIGN tt-retorno.mensagem = "Cliente n∆o encontrado":U.
            ELSE DO:
                FIND FIRST cont-emit
                    WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                      AND cont-emit.sequencia    = int(ENTRY(2, tt-cont-emit.new_chaveintegracao, ",")) EXCLUSIVE-LOCK NO-ERROR.

/*                 PUT "achou 1 " AVAIL cont-emit SKIP. */

                IF NOT AVAILABLE cont-emit THEN DO:

                    FIND FIRST cont-emit
                        WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                          AND cont-emit.nome         = tt-cont-emit.nome
                        EXCLUSIVE-LOCK NO-ERROR.

/*                     PUT "achou 2 " AVAIL cont-emit SKIP. */

                    IF NOT AVAIL cont-emit THEN DO:
                        FIND LAST cont-emit
                            WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAILABLE cont-emit THEN
                            ASSIGN i-seq-contato = cont-emit.sequencia + 10.
                        ELSE
                            ASSIGN i-seq-contato = 10.

                        CREATE cont-emit.
                        ASSIGN cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                               cont-emit.sequencia    = i-seq-contato
                               cont-emit.identific    = 1.
                    END.

                    FIND FIRST int-cont-emit
                        WHERE int-cont-emit.cod-emitente = cont-emit.cod-emitente
                          AND int-cont-emit.sequencia    = cont-emit.sequencia EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAILABLE int-cont-emit THEN DO:
                        CREATE int-cont-emit.
                        ASSIGN int-cont-emit.cod-emitente = cont-emit.cod-emitente
                               int-cont-emit.sequencia    = cont-emit.sequencia.
                    END.

                    FIND FIRST tt-atributo-entrada
                        WHERE tt-atributo-entrada.nome-pai = "new_chaveintegracao":U NO-ERROR.

                    IF AVAILABLE tt-atributo-entrada THEN
                        ASSIGN int-cont-emit.vl-guid = tt-atributo-entrada.valor.

                        ASSIGN tt-retorno.chaveintegracao = TRIM(STRING(cont-emit.cod-emitente)) + ",":U + TRIM(STRING(cont-emit.sequencia)).

                    
                END.
                ELSE DO:
                    
                    IF cont-emit.identific = 2 THEN
                        ASSIGN cont-emit.identific = 3.

                    IF peAction = "C" THEN  
                       ASSIGN tt-retorno.chaveintegracao = TRIM(STRING(cont-emit.cod-emitente)) + ",":U + TRIM(STRING(cont-emit.sequencia)).
                END.
              
                ASSIGN cont-emit.nome       = tt-cont-emit.nome
                       cont-emit.cargo      = tt-cont-emit.cargo
                       cont-emit.area       = tt-cont-emit.area
                       cont-emit.telefone   = tt-cont-emit.telefone
                       cont-emit.ramal      = tt-cont-emit.ramal
                       cont-emit.telefax    = tt-cont-emit.telefax
                       cont-emit.ramal-fax  = tt-cont-emit.ramal-fax
                       cont-emit.e-mail     = tt-cont-emit.e-mail
                       cont-emit.observacao = tt-cont-emit.observacao
                       cont-emit.telefone   = REPLACE(cont-emit.telefone, " ":U, "":U)
                       cont-emit.telefone   = REPLACE(cont-emit.telefone, "(":U, "":U)
                       cont-emit.telefone   = REPLACE(cont-emit.telefone, ")":U, "":U)
                       cont-emit.telefone   = REPLACE(cont-emit.telefone, "-":U, "":U)
                       cont-emit.telefax    = REPLACE(cont-emit.telefax,  " ":U, "":U)
                       cont-emit.telefax    = REPLACE(cont-emit.telefax,  "(":U, "":U)
                       cont-emit.telefax    = REPLACE(cont-emit.telefax,  ")":U, "":U)
                       cont-emit.telefax    = REPLACE(cont-emit.telefax,  "-":U, "":U).
            END.
        END.
        ELSE DO:
            FIND FIRST tt-atributo-entrada
                WHERE tt-atributo-entrada.nome-pai = "new_chaveintegracao":U NO-ERROR.

            FIND FIRST int-cont-emit
                WHERE int-cont-emit.vl-guid = tt-atributo-entrada.valor
                NO-LOCK NO-ERROR.

/*             PUT "achou pelo GUID " AVAIL int-cont-emit " GUID " STRING(tt-atributo-entrada.valor) SKIP. */

            IF AVAIL int-cont-emit THEN
               FIND FIRST cont-emit
                    WHERE cont-emit.cod-emitente = int-cont-emit.cod-emitente
                      AND cont-emit.sequencia    = int-cont-emit.sequencia  EXCLUSIVE-LOCK NO-ERROR.

/*             PUT "achou 1? " AVAIL cont-emit  AVAIL int-cont-emit SKIP. */

            IF NOT AVAIL cont-emit THEN
                FIND FIRST cont-emit
                    WHERE cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                      AND cont-emit.sequencia    = int(ENTRY(2, tt-cont-emit.new_chaveintegracao, ","))  EXCLUSIVE-LOCK NO-ERROR.
            
/*             PUT "achou ? " AVAIL cont-emit SKIP. */

            IF AVAILABLE cont-emit THEN DO:
                
                FIND FIRST int-cont-emit
                    WHERE int-cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                      AND int-cont-emit.sequencia    = tt-cont-emit.sequencia EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE int-cont-emit THEN
                    DELETE int-cont-emit.

                DELETE cont-emit.
            END.
            ELSE
                ASSIGN tt-retorno.mensagem = "Nao encontrou registro para eliminacao":U.
        END.

        RELEASE cont-emit.
        RELEASE int-cont-emit.
    END.
/*     OUTPUT CLOSE. */
    EMPTY TEMP-TABLE tt-cont-emit.

    RETURN "OK".
END.

IF peEntity = "new_relacionamento" /* Relacionamento Cliente */ 
THEN DO:
         
        CREATE tt-relacionamento-cliente.

        RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.  /* Procedures de leitura do xml */
        RUN readXML IN h-escrm005 (INPUT BUFFER tt-relacionamento-cliente:HANDLE,
                                   INPUT peMessage,
                                   OUTPUT TABLE tt-atributo-entrada).                      
        

        IF VALID-HANDLE(h-escrm005) 
        THEN DELETE PROCEDURE h-escrm005.
        FIND FIRST tt-relacionamento-cliente where
                   tt-relacionamento-cliente.cod-emitente > 0  NO-ERROR.                      
        IF AVAILABLE tt-relacionamento-cliente 
        THEN DO:
            
            if peAction <> "D"
            then do:                      
                
                assign i-seq-contato = 10.
                
                for last crm-relacionamento-cliente NO-LOCK where
                         crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente 
                    by crm-relacionamento-cliente.seq:

                       assign i-seq-contato = crm-relacionamento-cliente.seq + 10.
                end.

                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do:   
                    FIND FIRST crm-relacionamento-cliente NO-LOCK WHERE
                               crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor NO-ERROR.
                    IF AVAIL crm-relacionamento-cliente THEN
                       ASSIGN i-seq-contato = crm-relacionamento-cliente.seq.
                end.          

                find first crm-relacionamento-cliente exclusive-lock where
                           crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente and
                           crm-relacionamento-cliente.seq          = i-seq-contato no-error.
                if not avail crm-relacionamento-cliente
                then do:
                    
                    create crm-relacionamento-cliente.
                    assign crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente
                           crm-relacionamento-cliente.seq          = i-seq-contato.                                                   

                    ASSIGN tt-retorno.mensagem = ""
                           tt-retorno.chaveintegracao = string(crm-relacionamento-cliente.cod-emitente) + "," + STRING(crm-relacionamento-cliente.seq). 

                    find first tt-atributo-entrada where
                               tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                    if avail tt-atributo-entrada 
                    then do:
                       ASSIGN crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor.     
                    END. 
                end.      
                
                ASSIGN tt-retorno.mensagem = ""
                       tt-retorno.chaveintegracao = string(crm-relacionamento-cliente.cod-emitente) + "," + STRING(crm-relacionamento-cliente.seq). 

                ASSIGN crm-relacionamento-cliente.cod-rep         = int(tt-relacionamento-cliente.cod-rep)
                       crm-relacionamento-cliente.cd-categoria    = tt-relacionamento-cliente.cd-categoria
                       crm-relacionamento-cliente.dt-vigencia-ini = tt-relacionamento-cliente.dt-vigencia-ini
                       crm-relacionamento-cliente.dt-vigencia-fim = tt-relacionamento-cliente.dt-vigencia-fim. 
                
                IF  CAN-FIND(FIRST unid-comerc NO-LOCK
                             WHERE unid-comerc.cd-unid-comerc = INT(tt-relacionamento-cliente.cd-unid-negoc)) THEN
                    ASSIGN crm-relacionamento-cliente.cd-unid-negoc = tt-relacionamento-cliente.cd-unid-negoc.
                
                ASSIGN  tt-relacionamento-cliente.new_status_integracao = "Integrado com Sucesso."
                        tt-relacionamento-cliente.new_mensagem          = "".

            end.
            ELSE DO:
                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do: 
                                        
                   for first crm-relacionamento-cliente exclusive-lock where 
                             crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor:
                        
                        delete crm-relacionamento-cliente.                 
                   end.      

                end. 
            END.
            
            release crm-relacionamento-cliente.
       end.       
    
    RETURN "OK".
END.

ASSIGN l-web-service = no.


RETURN "OK".

