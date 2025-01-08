CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{cdp/cd0666.i}
{utp/ut-glob.i}
{esp/esb/in/msg0090.i}

DEFINE VARIABLE h-esapi001                as handle    NO-UNDO.
DEFINE VARIABLE de-vl-lim-total-supcard   as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-lim-tot-supcard     as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-aloc-pedido         as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-comp-nfs            as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-lim-dispo-supcard   as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-lim-total-intelbras as decimal   NO-UNDO.
DEFINE VARIABLE de-vl-lim-dispo-intelbras as decimal   NO-UNDO.
DEFINE VARIABLE d-vl-aberto               AS DECIMAL     NO-UNDO.
def var de-fator-1       as decimal format "999999,9999" init 1 no-undo.

DEFINE BUFFER bf-emitente FOR emitente.
DEFINE BUFFER bmovto_tit_acr_perdas FOR movto_tit_acr.

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0090
   DATA-RELATION FOR conteudo, msg0090 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0090r, resultado
   DATA-RELATION FOR conteudor, msg0090r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0090r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0090.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0090R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE msg0090r.

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = msg0090.CodigoConta NO-ERROR.
    
    IF NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "NÆo encontrado cliente no CRM").
    END.
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    
    if not avail emitente then do:
        RUN pi-erro (INPUT "NÆo encontrado emitente " + STRING(int-emitente.cod-emitente) + " cadastrado!").
    end.
    
    FIND FIRST gr-cli NO-LOCK
         WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.
    
    IF NOT AVAIL gr-cli THEN DO:
        RUN pi-erro (INPUT "NÆo encontrado grupo de clientes " + STRING(emitente.cod-gr-cli) + " cadastrado!").
    END.
    
    IF CAN-FIND (FIRST tt-erro) THEN
        UNDO blk_principal, LEAVE blk_principal.
    
    IF  AVAIL gr-cli
    AND AVAIL emitente THEN DO:
    
/*         FIND FIRST ponto-programa NO-LOCK                                          */
/*              WHERE ponto-programa.nome-programa = "escrm004":U                     */
/*                AND ponto-programa.ponto         = 1 NO-ERROR.                      */
/*                                                                                    */
/*         IF AVAIL ponto-programa THEN DO:                                           */
/*             FOR FIRST conteudo-programa NO-LOCK                                    */
/*                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa */
/*                   AND conteudo-programa.sequencia    = 1:                          */
/*                                                                                    */
/*                 ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")         */
/*                        c-senha   = ENTRY(2,conteudo-programa.conteudo,",").        */
/*             END.                                                                   */
/*         END.                                                                       */
/*                                                                                    */
/*         IF v_cod_usuar_corren = ""                                                 */
/*         OR v_cod_usuar_corren = c-usuario THEN DO:                                 */
/*             /* Login no EMS */                                                     */
/*             RUN bi/esbi002.p (INPUT c-usuario,                                     */
/*                               INPUT c-senha).                                      */
/*         END.                                                                       */
    
        IF NOT VALID-HANDLE(h-esapi001) THEN
            RUN esp/esapi001.p PERSISTENT SET h-esapi001.
    
        IF VALID-HANDLE(h-esapi001) THEN DO:
            RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                                  OUTPUT de-vl-lim-total-supcard,
                                                  OUTPUT de-vl-lim-tot-supcard,
                                                  OUTPUT de-vl-aloc-pedido,
                                                  OUTPUT de-vl-comp-nfs,
                                                  OUTPUT de-vl-lim-dispo-supcard).
        END.
             
        IF RETURN-VALUE = "nok":U THEN DO:
            ASSIGN de-vl-lim-total-supcard = 0
                   de-vl-lim-tot-supcard   = 0
                   de-vl-lim-dispo-supcard = 0.
        END.

        DELETE PROCEDURE h-esapi001.
            ASSIGN h-esapi001 = ?.
    
        /* O limite de cr‚dito fica gravado na Matriz do cliente */
        FIND FIRST bf-emitente no-lock
             where bf-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.
        
        ASSIGN de-vl-lim-total-intelbras = IF AVAIL bf-emitente THEN bf-emitente.lim-credito ELSE emitente.lim-credito.
        
        RUN pi-lim-disp-intelbras IN THIS-PROCEDURE (INPUT  emitente.cod-emitente,
                                                     OUTPUT de-vl-lim-dispo-intelbras).
        
        ASSIGN de-vl-lim-dispo-intelbras = de-vl-lim-total-intelbras - de-vl-lim-dispo-intelbras.
    
        IF de-vl-lim-dispo-intelbras < 0 THEN DO:
            ASSIGN de-vl-lim-dispo-intelbras = 0.
        END.
          
        ASSIGN msg0090r.LimiteIntelbras           = de-vl-lim-total-intelbras 
               msg0090r.LimiteUtilizadoIntelbras  = de-vl-lim-total-intelbras - de-vl-lim-dispo-intelbras 
               msg0090r.LimiteDisponivelIntelbras = de-vl-lim-dispo-intelbras 
               msg0090r.LimiteIntelbrasClub       = de-vl-lim-total-supcard   
               msg0090r.LimiteUtilizadoClub       = de-vl-lim-total-supcard - de-vl-lim-dispo-supcard   
               msg0090r.LimiteDisponivelClub      = de-vl-lim-dispo-supcard.
    END.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.

procedure pi-lim-disp-intelbras:
    DEFINE input  parameter p-cod-cliente        as integer NO-UNDO format ">>>>>>>>9":U.
    DEFINE output parameter p-lim-disp-intelbras as decimal NO-UNDO initial 0.

    DEFINE VARIABLE de-fator as decimal NO-UNDO format "999999,9999":U initial 1.

    assign p-lim-disp-intelbras = 0.
   
    for each bf-emitente no-lock
       where bf-emitente.nome-matriz = emitente.nome-matriz:
        for each estabelecimento no-lock:
          /** Ignora t¡tulos da Nova e da Maxcom **/
          if (estabelecimento.cod_estab = '201') 
          or (estabelecimento.cod_estab = '301') then
             next.

            for each tit_acr use-index titacr_cliente no-lock
               where tit_acr.cod_estab           = estabelecimento.cod_estab
                 and tit_acr.cdn_cliente         = bf-emitente.cod-emitente
                 and tit_acr.val_sdo_tit_acr     > 0
                 and tit_acr.log_tit_acr_estordo = no:

                if can-find (first bmovto_tit_acr_perdas
                             where bmovto_tit_acr_perdas.cod_estab           = tit_acr.cod_estab
                               and bmovto_tit_acr_perdas.num_id_tit_acr      = tit_acr.num_id_tit_acr
                               and bmovto_tit_acr_perdas.ind_trans_acr_abrev = "LQPD"
                               and bmovto_tit_acr_perdas.log_movto_estordo   = no) then
                   next.
    
                /* T¡tulos transferidos para o 102 e 103 */
                if tit_acr.cod_estab = "201":U or
                   tit_acr.cod_estab = "301":U then 
                    next.
        
                if tit_acr.ind_tip_espec_docto      = "Normal":U or
                   tit_acr.ind_tip_espec_docto begins "Vendor":U then do:
        
                    IF  tit_acr.cod_portador <> "9905"
                    AND tit_acr.cod_portador <> "9930"
                    AND tit_acr.cod_portador <> "9915"
                    AND tit_acr.cod_portador <> "9943"
                    AND tit_acr.cod_cart_bcia <> "CSR" THEN DO: 

                        if tit_acr.cod_espec_docto = "VE":U then do:
            
                            /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                            FIND FIRST parc_vendor no-lock
                                 where parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                   and parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
            
                            if avail parc_vendor then
                                assign p-lim-disp-intelbras = p-lim-disp-intelbras + parc_vendor.val_parc_vendor_clien.
                        end.
            
                        if tit_acr.cod_espec_docto = "VEM":U then do:
                            assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
            
                            FIND FIRST movto_tit_acr of tit_acr no-lock
                                where movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
            
                            if avail movto_tit_acr then do:
                                FIND FIRST histor_movto_tit_acr no-lock
                                     where histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                       and histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                       and histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
            
                                if avail histor_movto_tit_acr then
                                    assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
                            end.
                        end.
            
                        if tit_acr.cod_espec_docto <> "VE":U  and
                           tit_acr.cod_espec_docto <> "VEM":U then
                            assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
                    END.
                end.
            end.
        end.

        for each  ped-venda no-lock
           where  ped-venda.nome-abrev   = bf-emitente.nome-abrev
             and (ped-venda.cod-sit-ped  = 1  /* Aberto */
              or  ped-venda.cod-sit-ped  = 2) /* Atendido Parcial */
             and  ped-venda.completo     = yes
             and  ped-venda.cod-sit-aval = 3  /* Aprovado */
             and  ped-venda.cod-priori  <> 44:
    
            FIND FIRST cond-pagto no-lock
                 where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
    
            if  avail cond-pagto
            and cond-pagto.cod-cond-pag <> 502 
            and cond-pagto.cod-vencto    = 2 then 
                next.
    
            FIND int-cond-pagto OF cond-pagto NO-LOCK NO-ERROR.
            IF  AVAIL int-cond-pagto
            AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U  
                THEN NEXT.

            RUN pi-converte-moeda (OUTPUT d-vl-aberto).

            ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + d-vl-aberto.

        end.

    end.
    return "OK":U.
end procedure.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE pi-converte-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param de-valor-aberto like ped-venda.vl-liq-abe.

def var i-moeda          as integer no-undo.
def var de-fator-2       like de-fator-1 init 1 no-undo.

    ASSIGN i-moeda = 0.
    
    if  avail ped-venda then do:
        if  ped-venda.mo-codigo = 0 then 
            assign de-fator-1 = 1.
        else do:
             
            find first cotacao
                where cotacao.mo-codigo   = ped-venda.mo-codigo
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-1 = cotacao.cotacao[int(day(TODAY))].
    
        end.
    
        if  i-moeda <> 0 then do:
            
            find first cotacao
                where cotacao.mo-codigo   = i-moeda
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-2 = cotacao.cotacao[int(day(TODAY))].
    
        end.
        else assign de-fator-2 = 1.
    
        assign de-valor-aberto = ped-venda.vl-liq-abe * de-fator-1 / de-fator-2.
        
    end.                          

END PROCEDURE.
