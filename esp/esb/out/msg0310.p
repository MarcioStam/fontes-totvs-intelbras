/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0310 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0310
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
create widget-pool.

{esp/es0018.i}
{utp/ut-glob.i}
{esp/esb/out/msg0310.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE BUFFER b-ped-item FOR ped-item.

DEF VAR v-vl-liq-abe    AS DEC                   NO-UNDO.
DEF VAR v_desc_compl    AS CHAR                  NO-UNDO.
DEF VAR v_prazo_pedido  AS CHAR                  NO-UNDO.
DEF VAR v_cont          AS INT                   NO-UNDO.
DEF VAR v_num_parcelas  AS INT                   NO-UNDO.
DEF VAR v_dias_parcelas AS INT                   NO-UNDO.
DEF VAR v_num_pedido    LIKE ped-venda.nr-pedido NO-UNDO.
DEF VAR v_dias_negoc    AS INT                   NO-UNDO.
DEF VAR v_dt_negoc      AS DATE                  NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_val_dec_1   LIKE int-ped-venda2.dec-2   NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_status_ped  AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_desc_bloq   AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_categ   AS CHAR                     NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_val_entrada       LIKE int-ped-venda2.dec-2 NO-UNDO.

DEF BUFFER b-int-ped-venda2 FOR int-ped-venda2.

CREATE tt-pedido-integra.
RAW-TRANSFER raw-param TO tt-pedido-integra.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0310, ListaCategoria, InformacoesComplementares, ListaMotivo, CadastrosComplementares, CategoriaItem
    DATA-RELATION FOR conteudo, msg0310                  RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0310, ListaCategoria            RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0310, InformacoesComplementares RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0310, ListaMotivo               RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0310, CadastrosComplementares   RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0310, CategoriaItem             RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0310r, resultado
   DATA-RELATION FOR conteudor, msg0310r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0310r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0310'
       cabecalho.LoginUsuario      = c-seg-usuario.
     
CREATE conteudo.
CREATE msg0310.

RUN pi-carga-pedido.

IF RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

PROCEDURE pi-carga-pedido:

    ASSIGN v_num_pedido = 0
           v_status_ped = ""
           v_cod_categ  = "".

    FIND FIRST ped-venda EXCLUSIVE-LOCK
         WHERE ROWID(ped-venda) = tt-pedido-integra.r-rowid NO-ERROR.

    IF NOT AVAIL ped-venda THEN
        RETURN "NOK".

    IF ped-venda.cod-priori = 44 THEN 
        RETURN "NOK".

    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

    IF  AVAIL int-ped-venda2 THEN
        ASSIGN v_val_dec_1  = int-ped-venda2.dec-1.

    FIND FIRST int-ped-venda
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    RUN esp/es0018p.p (INPUT "dps-canal-vd", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    IF NOT CAN-FIND (FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN
        RETURN "NOK".

    IF  tt-pedido-integra.i-origem-inegr = 1 /*Pedido*/ 
    AND ped-venda.completo THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK.
        ASSIGN ped-venda.cod-sit-aval = 1 /* aberto */
               /* ped-venda.cod-sit-ped  = 4  pendente */.
        FIND CURRENT ped-venda NO-LOCK.
    END.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.

    FIND FIRST ped-antecip NO-LOCK
         WHERE ped-antecip.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    ASSIGN cabecalho.NumeroOperacao       = STRING(ped-venda.nr-pedcli) + "/" + ped-venda.nome-abrev
           msg0310.NumeroPedido           = ped-venda.nr-pedido         
           msg0310.TipoCliente            = IF emitente.natureza = 1 THEN "F" ELSE "J"
           msg0310.CpfCnpjCodEstrangeiro  = emitente.cgc                
           msg0310.NumeroPedidoCliente    = ped-venda.nr-pedcli         
           msg0310.DataEmissao            = ped-venda.dt-emissao        
           msg0310.DataPrimeiroVencimento = ped-venda.dt-entrega-prim   
           msg0310.ValorTotal             = ped-venda.vl-tot-ped        
           msg0310.ValorEntrada           = IF AVAIL ped-antecip THEN ped-antecip.vl-antecip[1] ELSE 0
           msg0310.ValorLiquido           = ped-venda.vl-liq-ped        
           msg0310.DataAtualizaSituacao   = TODAY
           msg0310.DataFaturamento        = IF tt-pedido-integra.i-origem-inegr = 2 THEN TODAY ELSE TODAY.

    IF  v_val_entrada > 0
    AND msg0310.ValorEntrada = 0 THEN
        ASSIGN msg0310.ValorEntrada = v_val_entrada.

    ASSIGN v_num_pedido = ped-venda.nr-pedido.

    IF  tt-pedido-integra.i-origem-inegr = 1 
    OR  tt-pedido-integra.i-origem-inegr = 3 THEN DO:
        
        ASSIGN msg0310.StatusAvaliacao = "Aguardando Faturamento".

        IF  tt-pedido-integra.i-origem-inegr = 3
        AND ped-venda.cod-sit-aval           = 4 THEN
            ASSIGN msg0310.StatusAvaliacao = "Bloqueado1".
    END.
    ELSE DO:
        ASSIGN msg0310.StatusAvaliacao = "A Faturar"
               ped-venda.dsp-pre-fat   = YES.
    END.
    
    IF AVAIL cond-pagto THEN
        ASSIGN msg0310.CodigoTipoPagamento = IF cond-pagto.cod-vencto = 3 THEN 2 /*Antecipado*/ 
                                             ELSE IF cond-pagto.cod-vencto = 2 THEN 1 /*· vista*/
                                             ELSE 0 /*A prazo*/
               msg0310.PrazoPedido         = cond-pagto.descricao
               msg0310.NumeroParcelas      = cond-pagto.num-parcelas
               msg0310.DiasEntreParcelas   = cond-pagto.prazos[1].

    ASSIGN v-vl-liq-abe = 0.

    RUN esp/es0018p.p (INPUT "dps-dt-negoc", /* Nome do programa  */
                       INPUT 1,             /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND FIRST tt-prog-ponto 
        WHERE entry(1,tt-prog-ponto.conteudo,";") = STRING(month(today)) NO-LOCK NO-ERROR.

    IF  AVAIL tt-prog-ponto THEN
        ASSIGN v_dt_negoc = date((entry(2,tt-prog-ponto.conteudo,";"))).
    ELSE
        ASSIGN v_dt_negoc = today.

    RUN esp/es0018p.p (INPUT "dps-dias-neg", /* Nome do programa  */
                       INPUT 1,             /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

    IF  AVAIL tt-prog-ponto THEN
        ASSIGN v_dias_negoc = int(tt-prog-ponto.conteudo).
    ELSE
        ASSIGN v_dias_negoc = 0.

    IF tt-pedido-integra.i-origem-inegr = 2 THEN DO:

        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF  AVAIL int-ped-venda2 THEN
            ASSIGN v-vl-liq-abe = int-ped-venda2.dec-2.

    END.
    ELSE DO:
        IF  ped-venda.completo THEN DO:
            RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                               INPUT 1,             /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            FIND FIRST tt-prog-ponto
                WHERE entry(1,tt-prog-ponto.conteudo,";") = STRING(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.

            /*   vista/bndes/cond especiais */
            IF   tt-pedido-integra.i-origem-inegr <> 3
            AND (AVAIL tt-prog-ponto
            OR   ped-venda.cod-cond-pag           = 0
            OR  (int-ped-venda.dt-negociacao     <> ?
            AND  int-ped-venda.dt-negociacao      > v_dt_negoc
            AND  int-ped-venda.dt-negociacao      > TODAY)
            OR  (int-ped-venda.dias-negociacao    > 0
            AND  int-ped-venda.dias-negociacao    > v_dias_negoc)
            OR   msg0310.ValorEntrada             > 0) THEN
                ASSIGN v-vl-liq-abe = ped-venda.vl-tot-ped.
            ELSE DO:
                FOR EACH b-ped-item OF ped-venda NO-LOCK
                   WHERE b-ped-item.vl-liq-abe > 0 /*b-ped-item.dt-entrega = ped-item.dt-entrega*/:

                    IF  b-ped-item.qt-pedida > b-ped-item.qt-atendida THEN
                        ASSIGN v-vl-liq-abe            = v-vl-liq-abe + b-ped-item.vl-liq-abe
                               msg0310.DataFaturamento = b-ped-item.dt-entrega.
                END.
            END.
        END.
    END.

    ASSIGN msg0310.ValorSaldo = v-vl-liq-abe.

    IF  v-vl-liq-abe = 0 THEN
        ASSIGN msg0310.StatusAvaliacao = "Atendido Total".

    RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                       INPUT 1,             /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND FIRST tt-prog-ponto
        WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.

    /*   vista/bndes/cond especiais */
    IF   tt-pedido-integra.i-origem-inegr <> 3
    AND (AVAIL tt-prog-ponto
    OR   ped-venda.cod-cond-pag            = 0
    OR  (int-ped-venda.dt-negociacao      <> ?
    AND  int-ped-venda.dt-negociacao       > v_dt_negoc
    AND  int-ped-venda.dt-negociacao       > TODAY)
    OR  (int-ped-venda.dias-negociacao     > 0
    AND  int-ped-venda.dias-negociacao     > v_dias_negoc)
    OR   msg0310.ValorEntrada              > 0) THEN DO:
        ASSIGN msg0310.StatusAvaliacao = "A Faturar"
               ped-venda.dsp-pre-fat   = YES.

        IF  AVAIL tt-prog-ponto THEN DO:
            CREATE ListaCategoria.
            ASSIGN ListaCategoria.CodigoCategoriaDEPS = string(entry(2,tt-prog-ponto.conteudo,";"))
                   ListaCategoria.RegistroRemovido    = NO.

            ASSIGN msg0310.StatusAvaliacao = "Aguardando analise".

            ASSIGN v_cod_categ = string(entry(2,tt-prog-ponto.conteudo,";")).

            IF  v_cod_categ = "REES" THEN DO:
                IF  int-ped-venda.dt-negociacao <> ? THEN 
                    ASSIGN v_desc_compl = "Data Negocia‡Æo: " + STRING(int-ped-venda.dt-negociacao,"99/99/9999").
                
                IF  int-ped-venda.dias-negociacao > 0 THEN
                    ASSIGN v_desc_compl = "Dias Negocia‡Æo: " + STRING(int-ped-venda.dias-negociacao).

                IF  v_desc_compl <> "" THEN DO:
                    CREATE InformacoesComplementares.
                    ASSIGN InformacoesComplementares.Descricao       = v_desc_compl
                           InformacoesComplementares.DataHoraCriacao = string(YEAR(TODAY),"9999") + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + 'T' + STRING(TIME,"HH:MM:SS":U).
                END.

                IF  ped-venda.cod-cond-pag = 0 THEN DO:
                    ASSIGN v_prazo_pedido = ""
                           v_num_parcelas = 0
                           v_cont         = 0.

                    FOR EACH cond-ped
                        WHERE cond-ped.nr-pedido = ped-venda.nr-pedido NO-LOCK:
                        
                        IF  cond-ped.nr-dias-venc > 0 THEN DO:
                            IF  v_prazo_pedido = "" THEN
                                ASSIGN v_prazo_pedido = IF msg0310.ValorEntrada > 0 THEN "Prazo + Antecipa‡Æo: " + string(cond-ped.nr-dias-venc) ELSE string(cond-ped.nr-dias-venc).
                            ELSE
                                ASSIGN v_prazo_pedido = v_prazo_pedido + "/" + string(cond-ped.nr-dias-venc).
    
                            ASSIGN v_num_parcelas = v_cont + 1.
    
                            IF  v_cont = 1 THEN
                                ASSIGN v_dias_parcelas = cond-ped.nr-dias-venc.
                        END.
                        ELSE DO:
                            IF  v_prazo_pedido = "" THEN
                                ASSIGN v_prazo_pedido = IF msg0310.ValorEntrada > 0 THEN "Prazo + Antecipa‡Æo: " + STRING(cond-ped.data-pagto,"99/99/9999") ELSE "Vencimento Pedido: " + STRING(cond-ped.data-pagto,"99/99/9999").            
                            ELSE
                                ASSIGN v_prazo_pedido = v_prazo_pedido + " - " + STRING(cond-ped.data-pagto,"99/99/9999").  
                        END.
                    END.

                    IF  v_prazo_pedido <> "" THEN DO:
                        CREATE InformacoesComplementares.
                        ASSIGN InformacoesComplementares.Descricao       = v_prazo_pedido
                               InformacoesComplementares.DataHoraCriacao = string(YEAR(TODAY),"9999") + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + 'T' + STRING(TIME,"HH:MM:SS":U).

                        ASSIGN v_prazo_pedido = "Vencimento Especial".
                    END.

                    IF  v_prazo_pedido <> "" THEN
                        ASSIGN msg0310.PrazoPedido       = v_prazo_pedido
                               msg0310.DiasEntreParcelas = v_dias_parcelas.

                    IF  v_num_parcelas > 0 THEN
                        ASSIGN msg0310.NumeroParcelas = v_num_parcelas.
                END.
            END.
        END.
        ELSE DO:
            IF (ped-venda.cod-cond-pag        = 0
            OR (int-ped-venda.dt-negociacao  <> ?
            AND int-ped-venda.dt-negociacao   > v_dt_negoc
            AND int-ped-venda.dt-negociacao   > TODAY)
            OR (int-ped-venda.dias-negociacao > 0
            AND int-ped-venda.dias-negociacao > v_dias_negoc)
            OR  msg0310.ValorEntrada          > 0) THEN DO:
                
                ASSIGN v_desc_compl = "".

                CREATE ListaCategoria.
                ASSIGN ListaCategoria.CodigoCategoriaDEPS = "REES"
                       ListaCategoria.RegistroRemovido    = NO.

                ASSIGN msg0310.StatusAvaliacao = "Aguardando analise".

                ASSIGN v_cod_categ = "REES".

                IF  int-ped-venda.dt-negociacao <> ? THEN 
                    ASSIGN v_desc_compl = "Data Negocia‡Æo: " + STRING(int-ped-venda.dt-negociacao,"99/99/9999").
                
                IF  int-ped-venda.dias-negociacao > 0 THEN
                    ASSIGN v_desc_compl = "Dias Negocia‡Æo: " + STRING(int-ped-venda.dias-negociacao).

                IF  v_desc_compl <> "" THEN DO:
                    CREATE InformacoesComplementares.
                    ASSIGN InformacoesComplementares.Descricao       = v_desc_compl
                           InformacoesComplementares.DataHoraCriacao = string(YEAR(TODAY),"9999") + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + 'T' + STRING(TIME,"HH:MM:SS":U).
                END.

                IF  ped-venda.cod-cond-pag = 0 THEN DO:
                    ASSIGN v_prazo_pedido = ""
                           v_num_parcelas = 0
                           v_cont         = 0.

                    FOR EACH cond-ped
                        WHERE cond-ped.nr-pedido = ped-venda.nr-pedido NO-LOCK:
                        
                        IF  cond-ped.nr-dias-venc > 0 THEN DO:
                            IF  v_prazo_pedido = "" THEN
                                ASSIGN v_prazo_pedido = IF msg0310.ValorEntrada > 0 THEN "Prazo + Antecipa‡Æo: " + string(cond-ped.nr-dias-venc) ELSE string(cond-ped.nr-dias-venc).
                            ELSE
                                ASSIGN v_prazo_pedido = v_prazo_pedido + "/" + string(cond-ped.nr-dias-venc).
    
                            ASSIGN v_num_parcelas = v_cont + 1.
    
                            IF  v_cont = 1 THEN
                                ASSIGN v_dias_parcelas = cond-ped.nr-dias-venc.
                        END.
                        ELSE DO:
                            IF  v_prazo_pedido = "" THEN
                                ASSIGN v_prazo_pedido = IF msg0310.ValorEntrada > 0 THEN "Prazo + Antecipa‡Æo: " + STRING(cond-ped.data-pagto,"99/99/9999") ELSE "Vencimento Pedido: " + STRING(cond-ped.data-pagto,"99/99/9999").            
                            ELSE
                                ASSIGN v_prazo_pedido = v_prazo_pedido + " - " + STRING(cond-ped.data-pagto,"99/99/9999").  
                        END.
                    END.

                    IF  v_prazo_pedido <> "" THEN DO:
                        CREATE InformacoesComplementares.
                        ASSIGN InformacoesComplementares.Descricao       = v_prazo_pedido
                               InformacoesComplementares.DataHoraCriacao = string(YEAR(TODAY),"9999") + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") + 'T' + STRING(TIME,"HH:MM:SS":U).

                        ASSIGN v_prazo_pedido = "Vencimento Especial".
                    END.

                    IF  v_prazo_pedido <> "" THEN
                        ASSIGN msg0310.PrazoPedido       = v_prazo_pedido
                               msg0310.DiasEntreParcelas = v_dias_parcelas.

                    IF  v_num_parcelas > 0 THEN
                        ASSIGN msg0310.NumeroParcelas = v_num_parcelas.
                END.
            END.
            ELSE DO:
                /* andrey chamado - C2202-0710 */
                CREATE ListaCategoria.
                ASSIGN ListaCategoria.CodigoCategoriaDEPS = "REES"
                       ListaCategoria.RegistroRemovido    = YES.

                ASSIGN v_cod_categ = "".
            END.
        END.
    END.
    ELSE DO:
        /* andrey chamado - C2202-0710 */
        CREATE ListaCategoria.
        ASSIGN ListaCategoria.CodigoCategoriaDEPS = "REES"
               ListaCategoria.RegistroRemovido    = YES.

        ASSIGN v_cod_categ = "".
    END.

    IF  tt-pedido-integra.i-origem-inegr = 1 THEN DO: /* completa pedido */
        FIND FIRST int-ped-venda2
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
             AND   int-ped-venda2.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
    
        IF  AVAIL int-ped-venda2 THEN DO:

            IF  int-ped-venda2.char-3 <> ""
            AND int-ped-venda2.char-3 <> v_cod_categ THEN DO:
                /*
                IF  OPSYS = 'UNIX' THEN DO:                                
                    OUTPUT TO "/mnt/spool/an052677/log_deps_homolog.txt" APPEND.
                    PUT UNFORMATTED "3 - msg0310 - int-ped-venda2.char-3 " int-ped-venda2.char-3 SKIP
                                    " v_cod_categ " v_cod_categ SKIP.
                    OUTPUT CLOSE.                                
                END.
                */

                CREATE ListaCategoria.
                ASSIGN ListaCategoria.CodigoCategoriaDEPS = int-ped-venda2.char-3
                       ListaCategoria.RegistroRemovido    = YES. /* exclui categoria antiga do DEPS */

                ASSIGN int-ped-venda2.char-3 = "".
            END.
            ELSE DO:
                IF  int-ped-venda2.char-3 = "" 
                AND v_cod_categ          <> "" THEN
                    ASSIGN int-ped-venda2.char-3 = v_cod_categ.

            END.
        END.
    END.

    IF  tt-pedido-integra.i-origem-inegr = 3 THEN DO: /* atualiza saldo apos faturar */

        FIND FIRST b-int-ped-venda2
             WHERE b-int-ped-venda2.cod-estabel = ped-venda.cod-estabel
             AND   b-int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
    
        IF  AVAIL b-int-ped-venda2 THEN DO:

            IF  msg0310.StatusAvaliacao <> "Atendido Total" THEN DO:

                /* Faturamento parcial, envia saldo restante como aprovado ao deps */
                IF  ped-venda.cod-sit-aval = 3
                AND b-int-ped-venda2.dec-1 > b-int-ped-venda2.dec-2 THEN
                    ASSIGN msg0310.StatusAvaliacao = "3" /* aprovado */
                           msg0310.ValorSaldo      = b-int-ped-venda2.dec-1 - b-int-ped-venda2.dec-2.
                ELSE DO:
                    FIND FIRST tt-prog-ponto
                        WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.
                
                    /* pedido categorizado */
                    IF   AVAIL tt-prog-ponto
                    OR   ped-venda.cod-cond-pag          = 0
                    OR  (int-ped-venda.dt-negociacao    <> ?
                    AND  int-ped-venda.dt-negociacao     > v_dt_negoc
                    AND  int-ped-venda.dt-negociacao     > TODAY)
                    OR  (int-ped-venda.dias-negociacao   > 0
                    AND  int-ped-venda.dias-negociacao   > v_dias_negoc)
                    OR   msg0310.ValorEntrada            > 0 THEN
                         ASSIGN msg0310.StatusAvaliacao = "Aguardando analise".
                    ELSE
                        ASSIGN msg0310.StatusAvaliacao = "Aguardando Faturamento".
                END.
            END.
            
            IF  b-int-ped-venda2.char-3 <> "" THEN
                ASSIGN v_cod_categ = b-int-ped-venda2.char-3.
        END.
    END.

    IF  tt-pedido-integra.i-origem-inegr = 2  /* faturamento */
    AND msg0310.StatusAvaliacao = "A Faturar" THEN DO:
        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF  AVAIL int-ped-venda2 THEN
            ASSIGN int-ped-venda2.dec-1 = 0
                   v_val_dec_1          = 0.
    END.

    IF  (tt-pedido-integra.i-origem-inegr = 2  /* faturamento */
    OR   tt-pedido-integra.i-origem-inegr = 3)  /* faturamento */
    AND  msg0310.StatusAvaliacao          = "Aguardando analise" THEN DO:
        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF  AVAIL int-ped-venda2 THEN
            ASSIGN int-ped-venda2.dec-1 = msg0310.ValorSaldo
                   v_val_dec_1          = msg0310.ValorSaldo.
    END.

    IF  tt-pedido-integra.i-origem-inegr = 4 THEN DO: /* cancela pedido */ 
        IF  ped-venda.cod-sit-ped = 6 
        OR  ped-venda.cod-sit-ped = 1 THEN
            ASSIGN msg0310.StatusAvaliacao = "Cancelado".
        ELSE
            ASSIGN msg0310.StatusAvaliacao = "Atendido Total"
                   msg0310.ValorSaldo      = 0.
    END.

    RETURN "OK".
            
END PROCEDURE.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

FIND FIRST msg0310r NO-LOCK NO-ERROR.

IF  NOT AVAIL msg0310r THEN DO:
    FIND FIRST resultado EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL resultado THEN DO:
        CREATE resultado.
        ASSIGN resultado.sucesso  = NO
               resultado.mensagem = "NÆo houve retorno ao integrar pedido com o DEPS.".
    END.   
END.

IF  tt-pedido-integra.i-origem-inegr = 2 /*Faturamento*/ THEN DO: 
    FIND FIRST resultado NO-LOCK NO-ERROR.

    IF  AVAIL resultado
    AND resultado.sucesso THEN DO:

        FIND FIRST ped-venda EXCLUSIVE-LOCK
             WHERE ped-venda.nr-pedido = v_num_pedido NO-ERROR.

        IF  AVAIL msg0310r
        AND AVAIL ped-venda THEN DO:

            IF  msg0310r.StatusAvaliacao = "3" THEN DO:
                /*
                IF  ped-venda.cod-sit-aval <> 3 THEN DO:
                    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL int-ped-venda2 THEN
                        ASSIGN int-ped-venda2.dec-1 = ped-venda.vl-liq-ped /*int-ped-venda2.dec-2*/ /* se o valor foi aprovado agora, setar dec-1 igual ao valor faturado */
                               v_val_dec_1          = ped-venda.vl-liq-ped /*int-ped-venda2.dec-2*/.

                END.
                */

                ASSIGN ped-venda.cod-sit-aval = 3
                       ped-venda.dt-apr-cred  = TODAY
                       ped-venda.quem-aprovou = c-seg-usuario
                       ped-venda.desc-bloq-cr = "".
            END.
            ELSE DO:
                IF  msg0310r.StatusAvaliacao = "Bloqueado1" THEN DO:

                    ASSIGN v_desc_bloq = "".
                    RUN esp/es0018p.p (INPUT "dps-motivo", /* Nome do programa  */
                                       INPUT 1,            /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                    
                    FIND FIRST tt-prog-ponto
                        WHERE entry(1,tt-prog-ponto.conteudo,";") = msg0310r.DescricaoParecer NO-LOCK NO-ERROR.
                        
                    IF  AVAIL tt-prog-ponto THEN
                        ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")).
                    ELSE
                        ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Erro: " + msg0310r.DescricaoParecer.

                    ASSIGN ped-venda.cod-sit-aval = 4
                           ped-venda.dt-apr-cred  = ?
                           ped-venda.quem-aprovou = ""
                           ped-venda.desc-bloq-cr = v_desc_bloq.

                    ASSIGN v_status_ped = "Bloqueado1".

                    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL int-ped-venda2 THEN
                        ASSIGN int-ped-venda2.dec-1 = int-ped-venda2.dec-2 /* andrey saldo */
                               v_val_dec_1          = int-ped-venda2.dec-2.

                END.
                ELSE DO:
                    IF  msg0310r.StatusAvaliacao = "Bloqueado2" THEN DO:
                        ASSIGN v_desc_bloq = "".
                        RUN esp/es0018p.p (INPUT "dps-motivo",
                                           INPUT 1,
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                        
                        FIND FIRST tt-prog-ponto
                            WHERE entry(1,tt-prog-ponto.conteudo,";") = msg0310r.DescricaoParecer NO-LOCK NO-ERROR.
                            
                        IF  AVAIL tt-prog-ponto THEN DO:
                            ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")).
                        END.
                        ELSE
                            ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Erro: " + msg0310r.DescricaoParecer.

    
                        ASSIGN ped-venda.cod-sit-aval = 4
                               ped-venda.dt-apr-cred  = ?
                               ped-venda.quem-aprovou = ""
                               ped-venda.desc-bloq-cr = v_desc_bloq.

                        ASSIGN v_status_ped = "Bloqueado2".
                    END.
                    ELSE DO:
                        ASSIGN v_status_ped = "".
                        
                        RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                                           INPUT 1,             /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                        FIND FIRST tt-prog-ponto
                            WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.

                        IF  AVAIL tt-prog-ponto
                        OR  ped-venda.cod-cond-pag         = 0
                        OR (int-ped-venda.dt-negociacao   <> ?
                        AND int-ped-venda.dt-negociacao    > v_dt_negoc
                        AND int-ped-venda.dt-negociacao    > TODAY)
                        OR (int-ped-venda.dias-negociacao  > 0 
                        AND int-ped-venda.dias-negociacao  > v_dias_negoc) THEN 
                            ASSIGN v_status_ped = "REAV".
                    END.
                END.
            END.
        END.

        RELEASE ped-venda.
    END.

    IF  AVAIL msg0310r
    AND msg0310r.StatusAvaliacao <> "3" /* aprovado */
    AND msg0310r.DescricaoParecer <> "" THEN DO:
        FIND FIRST resultado EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL resultado THEN
            ASSIGN resultado.sucesso  = NO
                   resultado.mensagem = msg0310r.DescricaoParecer.
    END.        
END.
ELSE DO:
    /*   vista/bndes/cond especiais */
    RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                       INPUT 1,             /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND FIRST tt-prog-ponto
        WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.

    IF   tt-pedido-integra.i-origem-inegr = 1   /* Completa Pedido */ 
    AND (AVAIL tt-prog-ponto
    OR   ped-venda.cod-cond-pag           = 0
    OR  (int-ped-venda.dt-negociacao     <> ?
    AND  int-ped-venda.dt-negociacao      > v_dt_negoc
    AND  int-ped-venda.dt-negociacao      > TODAY)
    OR  (int-ped-venda.dias-negociacao    > 0
    AND  int-ped-venda.dias-negociacao    > v_dias_negoc)) THEN DO:
    
        FIND FIRST resultado NO-LOCK NO-ERROR.
    
        IF  AVAIL resultado
        AND resultado.sucesso THEN DO:
            
            FIND FIRST ped-venda EXCLUSIVE-LOCK
                 WHERE ped-venda.nr-pedido = v_num_pedido NO-ERROR.
    
            IF  AVAIL ped-venda THEN DO:
                FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                     WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                       AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                IF  AVAIL int-ped-venda2 THEN
                    ASSIGN int-ped-venda2.dec-1 = v-vl-liq-abe
                           v_val_dec_1          = v-vl-liq-abe.

            END.
        END.
    END.
    ELSE DO:
        FIND FIRST resultado NO-LOCK NO-ERROR.

        IF  AVAIL resultado THEN DO:
            IF  resultado.sucesso THEN DO:

                FIND FIRST ped-venda EXCLUSIVE-LOCK
                     WHERE ped-venda.nr-pedido = v_num_pedido NO-ERROR.
    
                IF  AVAIL ped-venda THEN DO:

                    IF  tt-pedido-integra.i-origem-inegr = 3 THEN do: /* atualiza saldo deps */            

                        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        
                        IF  AVAIL int-ped-venda2 THEN DO:

                            /* andrey C2007-0373 */
                            IF  ped-venda.cod-sit-aval = 3
                            AND int-ped-venda2.dec-1 > int-ped-venda2.dec-2 THEN DO:
                                ASSIGN /*int-ped-venda2.dec-1 = int-ped-venda2.dec-1 - int-ped-venda2.dec-2*/
                                       v_val_dec_1          = int-ped-venda2.dec-1 - int-ped-venda2.dec-2.

                            END.
                            ELSE DO:
                                /*ASSIGN int-ped-venda2.dec-1 = 0
                                       v_val_dec_1          = 0.*/
    
                                ASSIGN ped-venda.cod-sit-aval = 1
                                       ped-venda.dt-apr-cred  = ?
                                       ped-venda.quem-aprovou = "".
                            END.                            
                        END.
                    END.
                END.
            END.
        END.
    END.
END.

RETURN.
