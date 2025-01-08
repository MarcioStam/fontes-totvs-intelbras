DEF VAR l-ok                    AS LOG INIT NO. /* */
DEF VAR c-rateio                AS CHAR FORMAT "x(200)" NO-UNDO.
DEF VAR de-tot-rat              AS DEC                                 NO-UNDO.
DEF VAR de-valor-base-calc      like int-cc-benef.vl-base-calc         NO-UNDO.
DEF VAR de-VerbaCalculada       like int-cc-benef.VerbaCalculada       NO-UNDO.
DEF VAR de-VerbaAcumulada       like int-cc-benef.VerbaAcumulada       NO-UNDO.
DEF VAR de-VerbaCancelada       like int-cc-benef.VerbaCancelada       NO-UNDO.
DEF VAR de-VerbaAjustada        like int-cc-benef.VerbaAjustada        NO-UNDO.
DEF VAR de-VerbaPeriodoAnterior like int-cc-benef.VerbaPeriodoAnterior NO-UNDO.
DEF VAR de-tot-clientes         AS INTEGER NO-UNDO.
DEF VAR i-cont                  AS INTEGER NO-UNDO.


DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.


DEF TEMP-TABLE tt-rateio-unid
    FIELD canal          AS INTEGER
    FIELD tipo-beneficio AS INTEGER
    FIELD nova-unidade   AS CHAR FORMAT "!!!"
    FIELD unid-neg       AS CHAR FORMAT "!!!"
    FIELD conta          AS CHAR
    FIELD centro-custo   AS CHAR
    FIELD cod-estabel    AS CHAR
    FIELD cod-especie    AS CHAR
    FIELD tipo-fluxo     AS CHAR
    FIELD vl-rateio      AS DEC.

DEF STREAM atuais.
DEF STREAM erro.
DEF STREAM nova.

{esp/esb/esesbapi004-benef.i}
{esp/esb/esesbapi010-saldo.i1}
{esp/esb/esesbapi002.i}

DEF TEMP-TABLE tt-cc-benef NO-UNDO LIKE int-cc-benef
    FIELD vl-saldo-consolidado AS DEC
    FIELD nome-abrev AS CHAR FORMAT "x(12)".

DEF TEMP-TABLE tt-erro-saldo NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-apb   LIKE tt-erro-saldo.
DEF TEMP-TABLE tt-erro-benef LIKE tt-erro-saldo.

DEF BUFFER b-int-cc-benef FOR int-cc-benef.

OUTPUT STREAM nova   TO c:\temp\cc_conta_ADM.csv CONVERT TARGET "iso8859-1".
OUTPUT STREAM erro   TO c:\temp\cc_novas_erros.csv CONVERT TARGET "iso8859-1".
OUTPUT STREAM atuais TO c:\temp\cc_atuais.csv CONVERT TARGET "iso8859-1".


PUT STREAM erro   UNFORMATTED "Erro;Mensagem;Ajuda" SKIP.
PUT STREAM atuais UNFORMATTED "Canal;NomeAbrev;Unid Original;Benefcio;Data ini;Data-fim;Saldo" SKIP.
PUT STREAM nova   UNFORMATTED "Canal;Nome;Unidade;Benef;Classi;Catego;guid-canal;guid-benef;guid-benef-canal;" +
                              "Data Ini;Data Fim;Forma pagto;Base Calc;VerbaCalculada;VerbaAcumulada;VerbaCancelada;VerbaAjustada;VerbaPeriodoAnterior;" +
                              "Vl Saldo Consolidado;% Custo; % Benef; % Prov Meta;Transao;Vencto;status;usuario;Canal-Matriz" SKIP.

     
/* Criar a tt-canal */
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Buscando Contas Correntes ativas").

FOR EACH int-cc-benef NO-LOCK
    WHERE int-cc-benef.id-status      = 1   /* Ativo   */
      AND int-cc-benef.tp-movto       = 2   /* Despesa */ 
      AND (int-cc-benef.tipo-beneficio = 37
      OR   int-cc-benef.tipo-beneficio = 66
      OR   int-cc-benef.tipo-beneficio = 21) /* VMC 21 - Rebate 37 - Rebate Pos 66 */
    ,FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = int-cc-benef.canal
    ,FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int-cc-benef.canal:

    IF  CAN-FIND(FIRST tt-canal WHERE tt-canal.canal = int-emitente.cod-emitente) THEN
        NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "Emitente: " + emitente.nome-abrev).
    CREATE tt-canal.           
    ASSIGN tt-canal.canal      = int-emitente.cod-emitente
           tt-canal.guid-canal = int-emitente.cod-guid
           tt-canal.guid-class = int-emitente.guid-class.

    ASSIGN de-tot-clientes = de-tot-clientes + 1.
END.

RUN pi-inicializar IN h-acomp (INPUT "Buscando Benefcios...").
RUN pi-BUSCA-BENEFICIO-CANAL.

IF  RETURN-VALUE <> "OK" THEN DO:
    MESSAGE "Retorno com erro da pi-busca-beneficio-canal"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "NOK".
END.

RUN pi-inicializar IN h-acomp (INPUT "Agrupando contas VMC...").

BLOCO:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco ON ERROR UNDO bloco, LEAVE bloco:

    FOR EACH int-cc-benef EXCLUSIVE-LOCK
        WHERE int-cc-benef.id-status      = 1       /* Ativo   */
          AND int-cc-benef.tp-movto       = 2        /* Despesa */ 
          AND (int-cc-benef.tipo-beneficio = 37
          OR  int-cc-benef.tipo-beneficio = 66
          OR   int-cc-benef.tipo-beneficio = 21)  
        ,FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = int-cc-benef.canal
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int-cc-benef.canal
        BREAK BY int-cc-benef.canal
              BY int-cc-benef.tipo-beneficio: 

        IF  FIRST-OF(int-cc-benef.tipo-beneficio) THEN DO:
            ASSIGN de-tot-rat              = 0
                   de-valor-base-calc      = 0
                   de-VerbaCalculada       = 0
                   de-VerbaAcumulada       = 0
                   de-VerbaCancelada       = 0
                   de-VerbaAjustada        = 0
                   de-VerbaPeriodoAnterior = 0
                   i-cont                  = i-cont + 1.

            RUN pi-acompanhar IN h-acomp (INPUT "Processando Cliente " + STRING(i-cont) + " / " + string(de-tot-clientes) ).
        END. 

        /*Buscar Saldo Disponvel*/
        RUN esp/esb/esesbapi010-saldo.p (INPUT  int-cc-benef.canal,
                                         INPUT  int-cc-benef.tipo-beneficio,
                                         INPUT  int-cc-benef.unid-neg,
                                         INPUT  int-cc-benef.dt-periodo-ini,
                                         INPUT  int-cc-benef.dt-periodo-fim,
                                         INPUT  ?,
                                         INPUT  ?,
                                         OUTPUT l-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro-saldo).

        FIND FIRST tt-saldo.
    

        PUT STREAM atuais int-cc-benef.canal            ";"
                          emitente.nome-abrev           ";"
                          int-cc-benef.unid-neg         ";"
                          int-cc-benef.tipo-beneficio   ";"
                          int-cc-benef.dt-periodo-ini   ";"
                          int-cc-benef.dt-periodo-fim   ";"
                          tt-saldo.VerbaTotal SKIP.
    

        /* Alimentar Rateio */
        FIND FIRST tt-beneficio
            WHERE tt-beneficio.canal          = int-cc-benef.canal
              AND tt-beneficio.tipo-beneficio = /*21*/ int-cc-benef.tipo-beneficio
              AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg NO-ERROR.
    
        IF  NOT AVAIL tt-beneficio THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 "No encontrado benefcio para unidade ADM",
                                                 "Canal: " + STRING(int-cc-benef.canal) + "Unidade: " + int-cc-benef.unid-neg).

             MESSAGE "Canal: " + STRING(int-cc-benef.canal) + " Unidade: " + int-cc-benef.unid-neg + " Tp Benef: " + string(int-cc-benef.tipo-beneficio)
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
             UNDO bloco, RETURN "NOK".
            
        END.

        IF  ROUND(tt-saldo.VerbaTotal,2) > 0.01 THEN DO:
            CREATE tt-rateio-unid.
            ASSIGN tt-rateio-unid.canal          = int-cc-benef.canal 
                   tt-rateio-unid.tipo-beneficio = /*21*/ /*VMC*/ int-cc-benef.tipo-beneficio
                   tt-rateio-unid.nova-unidade   = "ADM"
                   tt-rateio-unid.unid-neg       = int-cc-benef.unid-neg
                   tt-rateio-unid.vl-rateio      = round(tt-saldo.VerbaTotal,2)
                   tt-rateio-unid.conta          = tt-beneficio.conta       
                   tt-rateio-unid.centro-custo   = tt-beneficio.centro-custo
                   tt-rateio-unid.cod-estabel    = tt-beneficio.cod-estabel 
                   tt-rateio-unid.cod-especie    = tt-beneficio.cod-especie 
                   tt-rateio-unid.tipo-fluxo     = tt-beneficio.tipo-fluxo 
                   de-tot-rat                    = de-tot-rat + tt-rateio-unid.vl-rateio.

        END.

        ASSIGN de-valor-base-calc       = de-valor-base-calc      + int-cc-benef.vl-base-calc
               de-VerbaCalculada        = de-VerbaCalculada       + int-cc-benef.VerbaCalculada      
               de-VerbaAcumulada        = de-VerbaAcumulada       + int-cc-benef.VerbaAcumulada      
               de-VerbaCancelada        = de-VerbaCancelada       + int-cc-benef.VerbaCancelada      
               de-VerbaAjustada         = de-VerbaAjustada        + int-cc-benef.VerbaAjustada       
               de-VerbaPeriodoAnterior  = de-VerbaPeriodoAnterior + int-cc-benef.VerbaPeriodoAnterior.

        IF  LAST-OF (int-cc-benef.tipo-beneficio) THEN DO:

            RUN PI-CRIA-CONTA-CORRENTE-ADM (INPUT de-valor-base-calc      ,
                                            INPUT de-VerbaCalculada       ,
                                            INPUT de-VerbaAcumulada       ,
                                            INPUT de-VerbaCancelada       ,
                                            INPUT de-VerbaAjustada        ,
                                            INPUT de-VerbaPeriodoAnterior ,
                                            INPUT int-cc-benef.forma-pagto,
                                            INPUT de-tot-rat).
        END.

        /* MUDAR AS SOLICITAES ATRELADAS A CONTA CORRENTE PARA A UNIDADE ADM */
        FOR EACH int-solicitacao EXCLUSIVE-LOCK
            WHERE int-solicitacao.cod-emitente         = int-cc-benef.canal
              AND int-solicitacao.CodigoUnidadeNegocio = int-cc-benef.unid-neg
              AND int-solicitacao.tipo-beneficio       = int-cc-benef.tipo-beneficio
              AND int-solicitacao.dt-periodo-ini       = int-cc-benef.dt-periodo-ini
              AND int-solicitacao.dt-periodo-fim       = int-cc-benef.dt-periodo-fim
              AND NOT int-solicitacao.log-historica /* solicitao histrica */
              /*AND int-solicitacao.int-1 = 0 /* Distribuidores */*/ :
                  ASSIGN int-solicitacao.CodigoUnidadeNegocio  = "ADM".
        END.

        ASSIGN int-cc-benef.id-status = 2. /* INATIVA A CONTA QUE FUI UTILIZADA PRA COMPOR A CONTA ADM CONSOLIDADE */
            
    END.

    ASSIGN l-ok = NO.

    RUN pi-efetiva-conta-integra-apb (OUTPUT l-ok).
    
    IF  NOT l-ok THEN 
        UNDO bloco.
    
    RUN pi-finalizar IN h-acomp.


    /*RUN esp/esb/esesb008.w.*/
    
    OUTPUT STREAM erro   CLOSE.
    OUTPUT STREAM nova   CLOSE.
    OUTPUT STREAM atuais CLOSE.

    
END.

MESSAGE "Processamento concluido"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE pi-efetiva-conta-integra-apb:
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    RUN pi-inicializar IN h-acomp (INPUT "Atualizando contas pagar").
    ASSIGN i-cont = 1.              

    FOR EACH tt-cc-benef:
        PUT STREAM erro "for each tt-cc-benef" SKIP.

        CREATE b-int-cc-benef.
        BUFFER-COPY tt-cc-benef EXCEPT vl-saldo-consolidado nome-abrev TO b-int-cc-benef.

        RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Titulo Cliente " + STRING(i-cont) + "/" + string(de-tot-clientes)).
        
        IF  tt-cc-benef.vl-saldo-consolidado = 0 THEN DO:
            MESSAGE "tt-cc-benef.vl-saldo-consolidado: " tt-cc-benef.vl-saldo-consolidado SKIP
                    "tt-cc-benef.canal: " tt-cc-benef.canal SKIP
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        

        RUN pi-atualiza-ap (INPUT ROWID(b-int-cc-benef) ,
                            INPUT tt-cc-benef.vl-saldo-consolidado,
                            INPUT tt-cc-benef.dt-periodo-fim,
                            OUTPUT l-ok).
                            

        IF  NOT l-ok THEN
            RETURN "NOK".
        
       ASSIGN i-cont = i-cont + 1.
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-atualiza-ap:

    DEF INPUT PARAM p-rowid          AS ROWID NO-UNDO.
    DEF INPUT PARAM p-valor-apb      LIKE tt-saldo.VerbaTotal NO-UNDO.
    DEF INPUT PARAM p-da-periodo-fim AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-ok            AS LOG INIT NO NO-UNDO.
    

    DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

    IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
        RUN esp/esb/esesbapi003-apb-aux.p PERSISTENT SET h-esesb003-apb.


    RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT p-rowid,
                                                   INPUT p-valor-apb,
                                                   INPUT YES, /*Valor full*/
                                                   INPUT TODAY,
                                                   INPUT p-da-periodo-fim,
                                                   INPUT NO, /*no  tratado como desconto em duplicata*/
                                                   INPUT TABLE tt-beneficio,
                                                   INPUT TABLE tt-rateio-unid,
                                                   OUTPUT TABLE tt-erro-apb).
     IF  CAN-FIND (FIRST tt-erro-apb)
     OR  RETURN-VALUE <> "OK" THEN DO:
         DEF VAR l-erro AS LOG NO-UNDO.
         FOR EACH tt-erro-apb:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT tt-erro-apb.mensagem,
                                                 INPUT tt-erro-apb.mensagem ).
             l-erro = YES.
         END.

         IF  NOT l-erro THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "Retorno com erro, mas no retornou descrio do mesmo.",
                                                 INPUT "").
             RETURN "NOK".
         END.

         IF  VALID-HANDLE(h-esesb003-apb) THEN
             DELETE PROCEDURE h-esesb003-apb.

         RETURN "NOK".
     END.

     IF  VALID-HANDLE(h-esesb003-apb) THEN
         DELETE PROCEDURE h-esesb003-apb.

     ASSIGN p-ok = YES.
END.


PROCEDURE PI-CRIA-CONTA-CORRENTE-ADM:
    DEF INPUT PARAM p-vl-base-calc         LIKE tt-cc-benef.vl-base-calc          NO-UNDO.
    DEF INPUT PARAM p-VerbaCalculada       LIKE tt-cc-benef.VerbaCalculada        NO-UNDO.
    DEF INPUT PARAM p-VerbaAcumulada       LIKE tt-cc-benef.VerbaAcumulada        NO-UNDO.
    DEF INPUT PARAM p-VerbaCancelada       LIKE tt-cc-benef.VerbaCancelada        NO-UNDO.
    DEF INPUT PARAM p-VerbaAjustada        LIKE tt-cc-benef.VerbaAjustada         NO-UNDO.
    DEF INPUT PARAM p-VerbaPeriodoAnterior LIKE tt-cc-benef.VerbaPeriodoAnterior  NO-UNDO.
    DEF INPUT PARAM p-forma-pagto          LIKE int-cc-benef.forma-pagto          NO-UNDO.
    DEF INPUT PARAM p-saldo-consolidado    AS   DEC                               NO-UNDO.

    FIND tt-beneficio
        WHERE tt-beneficio.canal          = int-cc-benef.canal
          AND tt-beneficio.tipo-beneficio = /*21*/ int-cc-benef.tipo-beneficio
          AND tt-beneficio.unid-neg       = "ADM" NO-ERROR.

    IF  NOT AVAIL tt-beneficio THEN DO:
         RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                             "No encontrado benefcio para unidade ADM",
                                             "Canal: " + STRING(int-cc-benef.canal)).
         RETURN "NOK".
    END.

    IF  NOT AVAIL tt-rateio-unid THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            "No encontrado tt-rateio-unid",
                                            "Canal: " + STRING(int-cc-benef.canal)).
        RETURN "NOK".
    END.

    ASSIGN tt-beneficio.cod-estabel = tt-rateio-unid.cod-estab
           tt-beneficio.cod-especie = tt-rateio-unid.cod-especie.

    CREATE tt-cc-benef.
    ASSIGN tt-cc-benef.tp-movto               = 2 /*DESPESA*/
           tt-cc-benef.canal                  = int-cc-benef.canal
           tt-cc-benef.nome-abrev             = emitente.nome-abrev
           tt-cc-benef.unid-neg               = "ADM"
           tt-cc-benef.tipo-beneficio         = /*21*/ int-cc-benef.tipo-beneficio
           tt-cc-benef.classificacao          = tt-beneficio.guid-class
           tt-cc-benef.categoria              = tt-beneficio.tipo-categoria
           tt-cc-benef.guid-canal             = tt-beneficio.guid-canal
           tt-cc-benef.guid-beneficio         = tt-beneficio.guid-beneficio
           tt-cc-benef.guid-beneficio-canal   = tt-beneficio.guid-beneficio-canal
           tt-cc-benef.dt-periodo-ini         = int-cc-benef.dt-periodo-ini
           tt-cc-benef.dt-periodo-fim         = int-cc-benef.dt-periodo-fim
           tt-cc-benef.forma-pagto            = p-forma-pagto

           /*Valores*/
           tt-cc-benef.vl-base-calc           = p-vl-base-calc
           tt-cc-benef.VerbaCalculada         = p-VerbaCalculada
           tt-cc-benef.VerbaAcumulada         = p-VerbaAcumulada
           tt-cc-benef.VerbaCancelada         = p-VerbaCancelada
           tt-cc-benef.VerbaAjustada          = p-VerbaAjustada 
           tt-cc-benef.VerbaPeriodoAnterior   = p-VerbaPeriodoAnterior 
           tt-cc-benef.vl-saldo-consolidado   = p-saldo-consolidado

           /* Percentuais */
           tt-cc-benef.perc-custo             = 100
           tt-cc-benef.perc-benef             = tt-beneficio.perc-global
           tt-cc-benef.perc-prov-meta         = tt-beneficio.perc-prov-meta

           /* Gerais */                      
           tt-cc-benef.dt-transacao           = int-cc-benef.dt-transacao
           tt-cc-benef.dt-vencimento          = int-cc-benef.dt-vencimento
           tt-cc-benef.id-status              = 1 /*CONTA CORRENTE ATIVA */
           tt-cc-benef.usuario                = int-cc-benef.usuario 
           tt-cc-benef.cod_estab              = int-cc-benef.cod_estab
           tt-cc-benef.canal-matriz           = int-cc-benef.canal.

    PUT STREAM nova tt-cc-benef.tp-movto             ";"
                    tt-cc-benef.canal                ";"
                    tt-cc-benef.unid-neg             ";"
                    tt-cc-benef.tipo-beneficio       ";"
                    tt-cc-benef.classificacao        ";"
                    tt-cc-benef.categoria            ";"
                    tt-cc-benef.guid-canal           ";"
                    tt-cc-benef.guid-beneficio       ";"
                    tt-cc-benef.guid-beneficio-canal ";"
                    tt-cc-benef.dt-periodo-ini       ";"
                    tt-cc-benef.dt-periodo-fim       ";"
                    tt-cc-benef.forma-pagto          ";"
                    tt-cc-benef.vl-base-calc         ";"
                    tt-cc-benef.VerbaCalculada       ";"
                    tt-cc-benef.VerbaAcumulada       ";"
                    tt-cc-benef.VerbaCancelada       ";"
                    tt-cc-benef.VerbaAjustada        ";"
                    tt-cc-benef.VerbaPeriodoAnterior ";"
                    tt-cc-benef.vl-saldo-consolidado ";"
                    tt-cc-benef.perc-custo           ";"
                    tt-cc-benef.perc-benef           ";"
                    tt-cc-benef.perc-prov-meta       ";"
                    tt-cc-benef.dt-transacao         ";"
                    tt-cc-benef.dt-vencimento        ";"
                    tt-cc-benef.id-status            ";"
                    tt-cc-benef.usuario              ";"
                    tt-cc-benef.canal-matriz         SKIP.

END.


PROCEDURE pi-BUSCA-BENEFICIO-CANAL:

    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.

    /* Busca os benefcios que so automaticamente sincronizados com o ERP pelo CRM */
    RUN esp/esb/esesbapi004-benef-erp-aux.p (INPUT  YES,
                                             INPUT  YES,  /* Buscar msg0111 com o % global de cada benefcio   */
                                             INPUT  YES,  /* Buscar msg0142, parmetros financeiros e proviso */
                                             INPUT  ?,    /* (?) Totadas as Unidades                           */
                                             INPUT  ?,  /* 21 - VMC ou (?) Todas as beneficios                         */
                                             INPUT  TABLE tt-canal,
                                             OUTPUT TABLE tt-erro-benef,
                                             OUTPUT TABLE tt-beneficio).

    IF  RETURN-VALUE <> "OK" OR CAN-FIND(FIRST tt-erro-benef) THEN DO:
        IF  CAN-FIND (FIRST tt-erro-benef) THEN DO:
            FOR EACH tt-erro-benef:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT tt-erro-benef.codigo,
                                                    INPUT tt-erro-benef.mensagem + " Ajuda: " + tt-erro-benef.ajuda).
            END.
            RETURN "NOK".
        END.
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "(1) Erro desconhecido na busca de Benefcios ",
                                            INPUT "Benefcios no foram carregados para clculo, devido a erro desconhecido.").
        RETURN "NOK".
    END.

    RETURN "OK".
END.


PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    PUT STREAM erro UNFORMATTED p-erro ";" p-mensagem ";" p-ajuda SKIP.

END.



