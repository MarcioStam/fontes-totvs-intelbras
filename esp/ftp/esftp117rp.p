{include/i-prgvrs.i esftp117 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESftp117 MFT}
&ENDIF

{include/i_fnctrad.i}
{include/tt-edit.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define temp-table tt-param
    field destino        as integer
    field arquivo        as char
    field usuario        as char
    field data-exec      as date
    field hora-exec      as integer
    field pedido-ini     as integer
    field pedido-fim     as integer
    field dt-implant-ini as date
    field dt-implant-fim as date
    field situacao-ini   as integer
    field situacao-fim   as integer
    .

DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

def temp-table tt-raw-digita
    field raw-digita as raw.

DEF TEMP-TABLE tt-logPedFiscal NO-UNDO LIKE ped-fiscal.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita. 

def var h-acomp as handle no-undo.
DEF VAR h_api_ccusto AS HANDLE NO-UNDO.
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    .

DEF VAR v_des_titulo_ccusto as CHARACTER format "x(40)" no-undo.

def STREAM str-excel.
def var c-arq-excel as character no-undo.

create tt-param.
raw-transfer raw-param to tt-param.  

{utp/ut-glob.i}
{include/i-rpvar.i}

/* ***************************  Main Block  *************************** */
DO  ON STOP UNDO, LEAVE:

    FIND FIRST tt-param NO-LOCK NO-ERROR.

    IF OPSYS = "unix" 
    THEN OUTPUT TO value(c-dir-arquivo-session + trim(tt-param.usuario) +  "/esftp117.txt") NO-CONVERT.
    ELSE OUTPUT TO value(tt-param.arquivo) NO-CONVERT.
    
    assign c-programa     = "esftp117"
           c-titulo-relat = "Elimina Pedidos Nota Extra"
           c-sistema      = "Faturamento"
           c-empresa      = "INTELBRAS"
           c-versao       = "1.00"
           c-revisao      = "00.000"
           c-arq-excel    = replace(tt-param.arquivo, ".lst", "-" + STRING(TIME) + '.csv').

    {include/i-rpcab.i} 

    VIEW FRAME f-cabec.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp(INPUT "Buscando ...").

    EMPTY TEMP-TABLE tt-LogPedFiscal NO-ERROR.
    RUN piMonta-relatorio.

    RUN pi-finalizar in h-acomp.

    PUT SKIP.

    VIEW FRAME f-rodape.

    OUTPUT CLOSE.
    RETURN "OK".
END. /* DO  ON STOP UNDO, LEAVE: */

PROCEDURE piMonta-relatorio:
    ped_block:
    FOR EACH  ped-fiscal EXCLUSIVE-LOCK
       WHERE  ped-fiscal.nr-pedido  >= tt-param.pedido-ini
        AND   ped-fiscal.nr-pedido  <= tt-param.pedido-fim
        AND   ped-fiscal.dt-emissao >= tt-param.dt-implant-ini
        AND   ped-fiscal.dt-emissao <= tt-param.dt-implant-fim
        AND  (ped-fiscal.situacao   >= tt-param.situacao-ini
        AND   ped-fiscal.situacao   <= tt-param.situacao-fim
        AND   ped-fiscal.situacao   <= 2 /* 0-Digitado, 1-A Liberar e 2-A Relacionar */):

        RUN pi-acompanhar IN h-acomp (INPUT 'Pedido nro.: ' + STRING(ped-fiscal.nr-pedido)).

        it_block:
        FOR EACH  it-ped-fiscal EXCLUSIVE-LOCK
            WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido :
            
            RUN pi-acompanhar IN h-acomp (INPUT 'Item: ' + string(it-ped-fiscal.it-codigo)).

            FIND FIRST item NO-LOCK
                 WHERE  item.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.

            IF  ITEM.tipo-contr <> 4 
            AND ITEM.baixa-estoq THEN DO:
                /*Aloca‡Æo por lote*/
                IF item.tipo-con-est = 3 THEN DO:
                    RUN esp/ftp/esftp012f.p (INPUT NO,                           /*p-log-aloca  */
                                             INPUT it-ped-fiscal.nr-pedido,      /*p-nr-pedido  */
                                             INPUT it-ped-fiscal.it-codigo,      /*p-it-codigo  */
                                             INPUT it-ped-fiscal.seq,            /*p-seq        */
                                             INPUT ped-fiscal.cod-estabel,       /*p-cod-estabel*/
                                             INPUT it-ped-fiscal.cod-localizacao,/*p-cod-localiz*/
                                             INPUT it-ped-fiscal.cod-depos,      /*p-cod-depos  */
                                             INPUT it-ped-fiscal.qtde,           /*p-qtde-alocar*/
                                             OUTPUT TABLE tt-erro-aloc).  

                    FOR FIRST tt-erro-aloc:
                        NEXT it_block.
                    END.
                END.
                /*Aloca‡Æo sem lote*/
                ELSE DO:
                    find first saldo-estoq exclusive-lock 
                        where  saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                        and    saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                        and    saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                        and    saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao no-error.
                
                    if  avail saldo-estoq then do:
                        if saldo-estoq.qt-alocada < dec(it-ped-fiscal.qtde) then NEXT it_block.
                          
                       assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - dec(it-ped-fiscal.qtde).
                    end.
                    else NEXT it_block.
                END.
            END. /* IF  ITEM.tipo-contr ... */
            RELEASE saldo-estoq.
            
            DELETE it-ped-fiscal.
        END. /* FOR EACH  it-ped-fiscal NO-LOCK */

        IF  NOT CAN-FIND(FIRST tt-LogPedFiscal
                         WHERE tt-LogPedFiscal.nr-pedido = ped-fiscal.nr-pedido) THEN DO:
            CREATE tt-LogPedFiscal.
            BUFFER-COPY ped-fiscal TO tt-LogPedFiscal NO-ERROR.
        END. /* IF  NOT CAN-FIND(FIRST tt-LogPedFiscal */

        DELETE ped-fiscal.
    END. /* FOR EACH  ped-fiscal NO-LOCK */

    RELEASE ped-fiscal.
    RELEASE it-ped-fiscal.

    IF  CAN-FIND(FIRST tt-LogPedFiscal) THEN DO:
        OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

        PUT STREAM str-excel "Estab;Pedido;Cliente;Nome;Natureza;Desc Nat;EmissÆo;Situa‡Æo;Desc Sit.;Centro Custo;T¡tulo CC" SKIP.

        FOR EACH tt-LogPedFiscal,
            FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-LogPedFiscal.cod-emitente,
            FIRST natureza-ped-fiscal NO-LOCK
            WHERE natureza-ped-fiscal.natureza = tt-LogPedFiscal.nat-oper:

            PUT  STREAM str-excel
                 trim(tt-LogPedFiscal.cod-estabel)  ';'
                 tt-LogPedFiscal.nr-pedido    ';'
                 tt-LogPedFiscal.cod-emitente ';'
                 trim(emitente.nome-emit) ';'
                 tt-LogPedFiscal.nat-oper ';'
                 trim(natureza-ped-fiscal.descricao) ';'
                 tt-LogPedFiscal.dt-emissao ';'
                 tt-LogPedFiscal.situacao ';'.

            CASE tt-LogPedFiscal.situacao:
                WHEN 0 THEN PUT STREAM str-excel "Digitado;".
                WHEN 1 THEN PUT STREAM str-excel "A Liberar;".
                WHEN 2 THEN PUT STREAM str-excel "A Relacionar;".
                WHEN 3 THEN PUT STREAM str-excel "A Faturar".
                WHEN 4 THEN PUT STREAM str-excel "Atendido Parcialmente;".
                WHEN 5 THEN PUT STREAM str-excel "Atendido;".
                WHEN 6 THEN PUT STREAM str-excel "Reprovado;".
            END CASE.

            IF NOT valid-handle(h_api_ccusto) THEN RUN prgint/utb/utb742za.py persistent set h_api_ccusto.
            EMPTY TEMP-TABLE tt_log_erro.
            
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input tt-LogPedFiscal.sc-codigo,       /* CCUSTO */
                                                       input tt-LogPedFiscal.dt-emissao,              /* DATA DE TRANSACAO */
                                                       output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */
        
            IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
            IF CAN-FIND(FIRST tt_log_erro) THEN DO:
                EMPTY TEMP-TABLE tt_log_erro.
            END.
        
            PUT STREAM str-excel tt-LogPedFiscal.sc-codigo ";" trim(v_des_titulo_ccusto) FORMAT 'x(40)' ";".

            PUT STREAM str-excel SKIP.
        END.

        OUTPUT STREAM str-excel CLOSE.
        PUT "Arquivo excel gerado no caminho: " c-arq-excel format 'x(100)' SKIP.    

    END. /* FOR EACH tt-LogPedFiscal: */

END PROCEDURE. /* PROCEDURE piMonta-relatorio: */



