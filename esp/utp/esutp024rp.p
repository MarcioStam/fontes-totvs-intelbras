/***********************************************************************
**  Programa..: ESP\REP\ESUTP024RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: Janeiro/2009 - Desenvolvimento
**  Descricao.: Relat¢rio Verbas
**  VersÆo....: 001 26/01/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESUTP024 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/utp/esutp024tt.i}

{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
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
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Verbas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESUTP024"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    RUN pi-carrega-dados.

    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    DEFINE VARIABLE c-tipo-acordo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-tipo-verba  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-forma-pagto AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-situacao    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-tp-pagto    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-saldo      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-esapi015    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-observacoes AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.

    PUT UNFORMATTED
        "Emitente;Raiz CNPJ;Nome;Valor;Saldo;Nr.Verba;Tipo Acordo;Tipo Verba;Situa‡Æo;Empenho;Comprova‡Æo;Forma Pagto;Pagamento;NumPagto;Titulo;Especie;Serie;Data Evento;Data Vencto;Data Trans;Data Lib.;UsuTrans;UsuLib;Email;Estab;Matriz;C.Custo;Unid.Negoc;Repres;Observacao;" SKIP.

    FOR EACH vpc NO-LOCK
       WHERE vpc.cod-estabel    >= tt-param.cod-estab-ini
         AND vpc.cod-estabel    <= tt-param.cod-estab-fim
         AND vpc.cod-emitente   >= tt-param.cod-emitente-ini
         AND vpc.cod-emitente   <= tt-param.cod-emitente-fim
         AND vpc.data-trans     >= tt-param.dt-trans-ini
         AND vpc.data-trans     <= tt-param.dt-trans-fim
         AND vpc.data-evento    >= tt-param.dt-evento-ini
         AND vpc.data-evento    <= tt-param.dt-evento-fim
         AND vpc.data-vencto    >= tt-param.dt-vencto-ini
         AND vpc.data-vencto    <= tt-param.dt-vencto-fim
         AND vpc.tipo-acordo    >= tt-param.tipo-acordo-ini
         AND vpc.tipo-acordo    <= tt-param.tipo-acordo-fim
         AND vpc.tipo-verba     >= tt-param.tipo-verba-ini
         AND vpc.tipo-verba     <= tt-param.tipo-verba-fim
        , EACH vpc-rateio NO-LOCK
               WHERE vpc-rateio.nr-vpc = vpc.nr-vpc
                 AND vpc-rateio.cod-unid-negoc >= tt-param.unid-negoc-ini
                 AND vpc-rateio.cod-unid-negoc <= tt-param.unid-negoc-fim
        BREAK BY vpc.nr-vpc:
         
        IF tt-param.situacao <> 9 AND vpc.situacao <> tt-param.situacao THEN NEXT.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = vpc.cod-emitente NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.

        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = vpc.tipo-acordo NO-ERROR.
        IF NOT AVAIL tipo-acordo THEN NEXT.

        FIND FIRST tipo-verba NO-LOCK
             WHERE tipo-verba.codigo = vpc.tipo-verba NO-ERROR.
        IF NOT AVAIL tipo-verba THEN NEXT.

        run pi-acompanhar in h-acomp (INPUT "N£mero: " + STRING(vpc.nr-vpc)).

        ASSIGN c-tipo-acordo = STRING(vpc.tipo-acordo) + "-" + STRING(tipo-acordo.descricao)
               c-tipo-verba  = STRING(vpc.tipo-verba) + "-" + STRING(tipo-verba.descricao).

        CASE vpc.forma-pagto:
            WHEN 0 THEN ASSIGN c-forma-pagto = "Boleto".
            WHEN 1 THEN ASSIGN c-forma-pagto = "Desconto".
            WHEN 2 THEN ASSIGN c-forma-pagto = "Produto".
            WHEN 3 THEN ASSIGN c-forma-pagto = "Dep¢sito".
        END CASE.

        CASE vpc.situacao:
            WHEN 0 THEN ASSIGN c-situacao = "Bloqueado".
            WHEN 1 THEN ASSIGN c-situacao = "Liberado".
            WHEN 2 THEN ASSIGN c-situacao = "Finalizado".
            WHEN 3 THEN ASSIGN c-situacao = "Cancelado".
        END CASE.

        CASE vpc.id-pagto:
            WHEN 0 THEN ASSIGN c-tp-pagto = "Boleto".
            WHEN 1 THEN ASSIGN c-tp-pagto = "Duplicata".
            WHEN 2 THEN ASSIGN c-tp-pagto = "Nota Debito".
            WHEN 3 THEN ASSIGN c-tp-pagto = "Pedido".
        END CASE.
                                                        
        IF  FIRST-OF (vpc.nr-vpc) THEN DO:
            ASSIGN de-saldo = 0.
            RUN pi-retorna-saldo-titulo IN h-esapi015 (INPUT vpc.nr-vpc,
                                                       OUTPUT de-saldo).

        END.

        ASSIGN c-observacoes = vpc.observacoes
               c-observacoes = REPLACE(c-observacoes, ";":U, ",":U).

        DO i-cont = 1 TO 31:
            ASSIGN c-observacoes = REPLACE(c-observacoes, CHR(i-cont), CHR(32)).
        END.

        IF INDEX(c-observacoes, CHR(32) + CHR(32)) <> 0 THEN DO:
            DO i-cont = 12 TO 2 BY -1:
                ASSIGN c-observacoes = REPLACE(c-observacoes, FILL(CHR(32), i-cont), CHR(32)).
            END.
        END.

        ASSIGN c-observacoes = TRIM(c-observacoes).

        PUT UNFORMATTED
            vpc.cod-emitente                  ";"
            SUBSTRING(emitente.cgc,1,8)       ";"
            emitente.nome-emit                ";"
            vpc-rateio.valor                  ";"
            de-saldo                          ";"
            vpc.nr-vpc                        ";"
            c-tipo-acordo                     ";"
            c-tipo-verba                      ";"
            c-situacao                        ";"
            vpc.empenho FORMAT "Sim/NÆo"      ";"
            vpc.comprovacao FORMAT "Sim/NÆo"  ";"
            c-forma-pagto                     ";"
            c-tp-pagto                        ";"
            vpc.num-pagto                     ";" 
            vpc.nro-docto                     ";"
            vpc.cod-esp                       ";"
            vpc.serie-docto                   ";" 
            vpc.data-evento                   ";"
            vpc.data-vencto                   ";"
            vpc.data-trans                    ";"
            vpc.data-liberacao                ";"
            vpc.usuario-trans                 ";"
            vpc.usuario-liberacao             ";"
            REPLACE(vpc.email-repres,";",",") ";"
            vpc.cod-estabel                   ";"
            emitente.nome-matriz              ";" 
            vpc-rateio.cod_ccusto             ";"
            vpc-rateio.cod-unid-negoc         ";"
            emitente.cod-rep                  ";"
            c-observacoes                     ";" SKIP.
              
    END.

    IF VALID-HANDLE(h-esapi015) THEN
        DELETE PROCEDURE h-esapi015.

    RUN pi-finalizar in h-acomp.

    RUN esp/utp/esutp024rpa.p (INPUT  tt-param.cod-estab-ini,
                               INPUT  tt-param.cod-estab-fim,
                               INPUT  tt-param.unid-negoc-ini,
                               INPUT  tt-param.unid-negoc-fim,
                               OUTPUT TABLE tt_tit_acr).

    PUT UNFORMATTED SKIP(2)
                    "Contas a Receber" SKIP
                    "Estab;Espec;Serie;T¡tulo;Parcela;Unid.Negoc;Val.Original;Val.Saldo;% Unid.Negoc;Nome Cliente;Nome Matriz;" SKIP.

    FOR EACH tt_tit_acr NO-LOCK:
        PUT UNFORMATTED tt_tit_acr.cod_estab          ";"
                        tt_tit_acr.cod_espec          ";"
                        tt_tit_acr.cod_ser_docto      ";"
                        tt_tit_acr.cod_tit_acr        ";"
                        tt_tit_acr.cod_parcela        ";"
                        tt_tit_acr.cod_unid_negoc     ";"
                        tt_tit_acr.val_origin_tit_acr ";"
                        tt_tit_acr.val_sdo_tit_acr    ";"
                        tt_tit_acr.val_perc_rat       ";"
                        tt_tit_acr.nom_cliente        ";"
                        tt_tit_acr.nom_matriz         ";" SKIP.
    END.

END PROCEDURE.
