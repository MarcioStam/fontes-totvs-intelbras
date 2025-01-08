/*--------------------------------------------------------------------*/
/*  Programa......: esp/esb/esesbapi003.p                             */
/*  Objetivo......: API DE CRIAÄ«O DE MOVIMENTOS DA CONTA CONRRENTE   */
/*     Autor......: Roger Marcelino Bruhn                             */
/*  Consideraá‰es.:                                                   */
/*           > Campo sequencia: Ç uma sequencia na ordem de tempo em  */
/*                              que as movimentaá‰es acontecem        */
/*                                                                    */
/*           > Campo transacao: 01 - Entrada de Tranferància          */
/*                              02 - Sa°da de Transferància           */
/*                              03 - Ajuste de saldo                  */
/*                              04 - Criaá∆o Conta Manual             */
/*                              10 - Saldo Inicial Primeiro Trimestre */
/*                              20 - Saldo Inicial Segundo Trimestre  */
/*                              30 - Saldo Inicial Terceiro Trimestre */
/*                              40 - Saldo Inicial Quarto Trimestre   */                       
/*                                                                    */
/*--------------------------------------------------------------------*/
  
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.
DEF TEMP-TABLE tt-erro-benef   LIKE tt-erro.
DEF TEMP-TABLE tt-erro-central LIKE tt-erro.  

DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD canal      AS INTEGER
    FIELD guid-canal AS CHAR FORMAT "x(36)"
    FIELD guid-class AS CHAR FORMAT "x(36)"
       INDEX idx-canal  IS PRIMARY UNIQUE canal .

DEF TEMP-TABLE tt-movto NO-UNDO 
    LIKE int-cc-benef-movto.

define temp-table resultado no-undo xml-node-name 'Resultado'
   field idm as int xml-node-type 'hidden'
   field Sucesso as log initial yes
   field CodigoErro as int
   field Mensagem as CHAR INITIAL "".

/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

{utp/ut-glob.i}

DEF TEMP-TABLE tt-nova-cc LIKE int-cc-benef.

DEF BUFFER b-origem  FOR int-cc-benef.
DEF BUFFER b-destino FOR int-cc-benef.
DEF BUFFER b-ajuste  FOR int-cc-benef.

DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.    

{esp/esb/esesbapi003-movtos.i1} /* pi-valida-operacao-usuario */
{esp/esb/esesbapi003-movtos.i2} /* pi-cria-transacao-saldo-inicial */

/* Canais de acordo com a a estrutura de centralizaá∆o da apuraá∆o de benef°cios*/
{esp/esb/esesbapi005.i} 

FUNCTION fn-beneficio RETURNS CHAR
    (p-status AS INT) FORWARD.

FUNCTION fn-status RETURNS CHAR
    (p-status AS INT) FORWARD.

PROCEDURE pi-carreta-tt-central:
    
    DEF INPUT PARAM p-canal-central AS INTEGER NO-UNDO.
    /* CARREGA APENAS OS CANAIS CENTRAIS, ISTO ê, VERIFICA SE O CLIENTE POSSUIT APURAÄ«O DE BENENF÷CIOS
       CENTRALIZADA NA MATRIZ. NESTE CASO, UMA FILIAL PODE SER UMA CENTRAL DESDE QUE ESTEJA PARAMETRIZADA
       PARA APURALÄ«O DE BENEF÷CIOS DIVIDIDA POR FILIAL. CASO CONTRµRIO, SOMENTE A MATRIZ PODERµ GERAR
       REGISTROS DE CONTA CORRENTE, SENDO QUE A BASE DE FATURAMENTO PARA O CµLCULO DO BENEF÷CIO, SERµ
       CONSIDERADA TODAS AS FILIAIS DA MATRIZ */

    IF  CAN-FIND (FIRST tt-central
                    WHERE tt-central.canal-central = p-canal-central) THEN
        RETURN "OK".

    EMPTY TEMP-TABLE tt-erro-central.
    EMPTY TEMP-TABLE tt-central.
    RUN esp/esb/esesbapi005.p (INPUT p-canal-central,
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro-central).
    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro-central) THEN DO:
        FOR EACH tt-erro-central:
            CREATE tt-erro.
            BUFFER-COPY tt-erro-central TO tt-erro.
        END.
        RETURN "NOK".

    END.

    RETURN "OK".

END.


/*------------------------------------------------------*/
/*      TRANSAÄ«O  (01)  - ENTRADA DE TRANSFER“NCIA     */
/*                 (02)  - SA÷DA   DE TRANSFER“NCIA     */
/*------------------------------------------------------*/
PROCEDURE pi-transferencia:

    DEF INPUT  PARAM p-transacao        AS INTEGER                                    NO-UNDO.
    DEF INPUT  PARAM p-r-movto-origem   AS ROWID                                      NO-UNDO.
    DEF INPUT  PARAM p-r-movto-destino  AS ROWID                                      NO-UNDO.
    DEF INPUT  PARAM p-usuario          AS CHAR                                       NO-UNDO.
    DEF INPUT  PARAM p-vl-movto         AS DEC DECIMALS 4  FORMAT "->>>,>>>,>>9.9999" NO-UNDO.
    DEF INPUT  PARAM p-unid-neg-dest    AS CHAR                                       NO-UNDO. 
    DEF INPUT  PARAM p-dt-trasacao-ap   AS DATE                                       NO-UNDO.
    DEF INPUT  PARAM p-hist-usuario     AS CHAR     FORMAT "x(255)"                   NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR i-sequencia      AS INTEGER NO-UNDO.
    DEF VAR da-fim           AS DATE    NO-UNDO.
    DEF VAR r-rowid-cc       AS ROWID   NO-UNDO.
    DEF VAR c-erro-permissao AS CHAR NO-UNDO.

    RUN pi-limpa-temp-tables.
    /* VERIFICAÄ«O DE PERMISSÂES DE USUµRIOS */
    RUN pi-valida-operacao-usuario (INPUT  p-usuario,
                                    INPUT  2,
                                    OUTPUT c-erro-permissao /*Entrada de Transferància*/) .
    IF  RETURN-VALUE <> "OK" THEN DO:
        RUN pi-cria-erro (INPUT 17006, /* Erro */
                          INPUT "Usu†rio sem permiss∆o. ",
                          INPUT c-erro-permissao).
        RETURN "NOK".
    END.
   
    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR UNDO bloco, LEAVE bloco:

        FIND FIRST b-origem   WHERE rowid(b-origem)   = p-r-movto-origem  NO-LOCK NO-ERROR.
        FIND FIRST b-destino  WHERE rowid(b-destino)  = p-r-movto-destino EXCLUSIVE-LOCK NO-ERROR.
    
        IF  NOT AVAIL(b-origem) THEN DO:
            RUN pi-cria-erro (INPUT 17006, /* Erro */
                              INPUT "Registro de conta corrente origem indispon°vel...",
                              INPUT "").
            UNDO bloco, RETURN "NOK".
        END.
    
        RUN pi-valida-canal (INPUT b-origem.canal,
                             INPUT NO, /*PROVIS«O?*/
                             INPUT b-origem.unid-neg,
                             INPUT b-origem.tipo-beneficio).

        IF  RETURN-VALUE <> "OK" THEN DO: UNDO bloco, RETURN "NOK". END.

        IF  NOT AVAIL b-destino THEN 
            RUN pi-cria-nova-cc-transf (INPUT p-r-movto-origem,  
                                        INPUT p-unid-neg-dest,
                                        INPUT p-vl-movto, 
                                        INPUT p-usuario,
                                        INPUT p-dt-trasacao-ap).
             
        IF  RETURN-VALUE <> "OK" THEN DO: UNDO bloco, RETURN "NOK". END.

        /*-------------------------------------------*/
        /*    MOVIMENTO DE SA÷DA DE TRANSFER“NCIA    */
        /*-------------------------------------------*/
        FOR LAST int-cc-benef-movto fields(sequencia) NO-LOCK
            WHERE int-cc-benef-movto.tp-movto       = 2
              AND int-cc-benef-movto.canal          = b-origem.canal
              AND int-cc-benef-movto.tipo-beneficio = b-origem.tipo-beneficio
              AND int-cc-benef-movto.unid-neg       = b-origem.unid-neg
              AND int-cc-benef-movto.dt-periodo-ini = b-origem.dt-periodo-ini
              AND int-cc-benef-movto.dt-periodo-fim = b-origem.dt-periodo-fim :
              ASSIGN i-sequencia = int-cc-benef-movto.sequencia.
        END.
    
        CREATE int-cc-benef-movto.
        ASSIGN int-cc-benef-movto.tp-movto          = 2       
               int-cc-benef-movto.canal             = b-origem.canal          
               int-cc-benef-movto.tipo-beneficio    = b-origem.tipo-beneficio 
               int-cc-benef-movto.unid-neg          = b-origem.unid-neg       
               int-cc-benef-movto.dt-periodo-ini    = b-origem.dt-periodo-ini 
               int-cc-benef-movto.dt-periodo-fim    = b-origem.dt-periodo-fim 
               int-cc-benef-movto.sequencia         = i-sequencia + 10
               int-cc-benef-movto.transacao         = 1 /* 1 - Sa°da de Transferància */
               int-cc-benef-movto.dt-movto          = TODAY
               int-cc-benef-movto.hr-movto          = STRING(TIME, "HH:MM:SS")
               int-cc-benef-movto.id-operacao       = 2 /*a menor*/
               int-cc-benef-movto.hist-automatico   = "Sa°da de Transferància de saldo da Unidade " + b-origem.unid-neg + 
                                                      " no valor de R$ " + trim(string(p-vl-movto, ">>>,>>>,>>9.9999")) + ", para a Unidade " + p-unid-neg-dest
               int-cc-benef-movto.hist-usuario      = p-hist-usuario
               int-cc-benef-movto.usuario           = p-usuario
               int-cc-benef-movto.vl-saldo-anterior = b-origem.vl-saldo
               int-cc-benef-movto.vl-movto          = p-vl-movto * (-1).
    
        RELEASE int-cc-benef-movto.
    
        ASSIGN i-sequencia = 0.
        /*---------------------------------------------*/
        /*  MOVIMENTO DE ENTRADA DE SALDO TRANSFERIDO  */
        /*---------------------------------------------*/
        FOR LAST int-cc-benef-movto fields(sequencia) NO-LOCK
            WHERE int-cc-benef-movto.tp-movto       = 2
              AND int-cc-benef-movto.canal          = b-destino.canal
              AND int-cc-benef-movto.tipo-beneficio = b-destino.tipo-beneficio
              AND int-cc-benef-movto.unid-neg       = b-destino.unid-neg
              AND int-cc-benef-movto.dt-periodo-ini = b-destino.dt-periodo-ini
              AND int-cc-benef-movto.dt-periodo-fim = b-destino.dt-periodo-fim:
              ASSIGN i-sequencia = int-cc-benef-movto.sequencia.
        END.
    
        CREATE int-cc-benef-movto.
        ASSIGN int-cc-benef-movto.tp-movto          = 2     
               int-cc-benef-movto.canal             = b-destino.canal          
               int-cc-benef-movto.tipo-beneficio    = b-destino.tipo-beneficio 
               int-cc-benef-movto.unid-neg          = b-destino.unid-neg       
               int-cc-benef-movto.dt-periodo-ini    = b-destino.dt-periodo-ini 
               int-cc-benef-movto.dt-periodo-fim    = b-destino.dt-periodo-fim 
               int-cc-benef-movto.sequencia         = i-sequencia + 10
               int-cc-benef-movto.transacao         = 2 /* 2 - Entrada de Transferància */
               int-cc-benef-movto.dt-movto          = TODAY
               int-cc-benef-movto.hr-movto          = STRING(TIME, "HH:MM:SS")
               int-cc-benef-movto.id-operacao       = 1 /*a maior*/
               int-cc-benef-movto.hist-automatico   = "Entrada de Transferància de saldo na Unidade " + b-destino.unid-neg + " a partir da Unidade " + b-origem.unid-neg +
                                                    ", no valor de R$ " + trim(string(p-vl-movto, ">>>,>>>,>>9.9999"))
               int-cc-benef-movto.hist-usuario      = p-hist-usuario
               int-cc-benef-movto.usuario           = p-usuario
               int-cc-benef-movto.vl-saldo-anterior = 0
               int-cc-benef-movto.vl-movto          = p-vl-movto.
    
        RELEASE int-cc-benef-movto.
    
        /* ADICIONA O SALDO TRANSFERIDO NO CASO DE N«O SER UMA CONTA CORRENTE NOVA */
        IF  p-r-movto-destino <> ? THEN DO:
        
            FIND CURRENT b-origem EXCLUSIVE-LOCK NO-ERROR.
    
            ASSIGN b-destino.vl-saldo-ant = b-destino.vl-saldo
                   b-destino.vl-saldo     = b-destino.vl-saldo + p-vl-movto
                   b-origem.vl-saldo-ant  = b-origem.vl-saldo
                   b-origem.vl-saldo      = b-origem.vl-saldo  - p-vl-movto.
    
    
            FIND CURRENT b-destino NO-LOCK NO-ERROR.
            FIND CURRENT b-origem  NO-LOCK NO-ERROR.
    
            CASE MONTH(b-destino.dt-periodo-fim):
                WHEN 01 OR WHEN 02 OR WHEN 03 THEN 
                    ASSIGN da-fim = DATE(03,31,YEAR(b-destino.dt-periodo-fim)).
                WHEN 04 OR WHEN 05 OR WHEN 06 THEN 
                    ASSIGN da-fim = DATE(06,30,YEAR(b-destino.dt-periodo-fim)).
                WHEN 07 OR WHEN 08 OR WHEN 09 THEN 
                    ASSIGN da-fim = DATE(09,30,YEAR(b-destino.dt-periodo-fim)).
                WHEN 10 OR WHEN 11 OR WHEN 12 THEN 
                    ASSIGN da-fim = DATE(12,31,YEAR(b-destino.dt-periodo-fim)).
            END CASE.
    
            /* INTEGRAR O NOVO REGISTRO DE CONTA CORRENTE COM O APB */
            IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
                RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.
        
            ASSIGN r-rowid-cc = rowid(b-origem).
            RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT r-rowid-cc,
                                                          INPUT p-dt-trasacao-ap,
                                                          INPUT da-fim,
                                                          OUTPUT TABLE tt-erro-apb).
           IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
               FOR EACH tt-erro-apb:
                   CREATE tt-erro.
                   BUFFER-COPY tt-erro-apb TO tt-erro.
               END.
               UNDO bloco, RETURN "NOK". 
           END.
        
            ASSIGN r-rowid-cc = ROWID(b-destino).
            RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT r-rowid-cc,
                                                          INPUT p-dt-trasacao-ap,
                                                          INPUT da-fim,
                                                          OUTPUT TABLE tt-erro-apb).
            IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
                FOR EACH tt-erro-apb:
                    CREATE tt-erro.
                    BUFFER-COPY tt-erro-apb TO tt-erro.
                END.
                UNDO bloco, RETURN "NOK". 
            END.
            
        END.
    
        RELEASE b-origem. 
        RELEASE b-destino.
    
    END.

    RETURN "OK".

END.


/*--------------------------------------------------*/
/*     TRANSAÄ«O  (04)  - CONTA CORRENTE MANUAL     */
/*--------------------------------------------------*/
PROCEDURE pi-conta-corrente-manual:

    DEF INPUT PARAM TABLE FOR tt-nova-cc.
    DEF INPUT PARAM p-usuario        AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-trasacao-ap AS DATE NO-UNDO.
    DEF INPUT PARAM p-hist-usuario   AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    
    DEF VAR i-sequencia      AS INTEGER NO-UNDO.
    DEF VAR da-fim           AS DATE    NO-UNDO.
    DEF VAR c-trimestre      AS CHAR    NO-UNDO.
    DEF VAR c-erro-permissao AS CHAR NO-UNDO.

    RUN pi-limpa-temp-tables.
    
    /* VERIFICAÄ«O DE PERMISSÂES DE USUµRIOS */
    RUN pi-valida-operacao-usuario (INPUT  p-usuario,
                                    INPUT  4, /* Criaá∆o Conta Manual*/
                                    OUTPUT c-erro-permissao) .
    IF  RETURN-VALUE <> "OK" THEN DO:
        RUN pi-cria-erro (INPUT 17006, /* Erro */
                          INPUT "Usu†rio sem permiss∆o. ",
                          INPUT c-erro-permissao).
        RETURN "NOK".
    END.
    
    FIND FIRST tt-nova-cc NO-ERROR.
    
    IF NOT AVAIL tt-nova-cc THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "N∆o foram enviados os dados para criar a conta corrente via solicitaá∆o manual" ,
                                            INPUT "").
        RETURN "NOK".
    END.

    /*-----------------------------------------------------*/
    /*    VALIDAÄÂES PARA CRIAÄ«O DE CONTA CORRENTE NOVA   */
    /*-----------------------------------------------------*/
    RUN pi-valida-canal (INPUT tt-nova-cc.canal,
                         INPUT IF tt-nova-cc.tp-movto = 1 THEN YES ELSE NO, /*PROVIS«O?*/
                         INPUT tt-nova-cc.unid-neg,
                         INPUT tt-nova-cc.tipo-beneficio).
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = tt-nova-cc.unid-neg NO-ERROR.
    IF  NOT AVAIL unid-negoc THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Unidade de neg¢cio " + tt-nova-cc.unid-neg + " Ç inv†lida" ,
                                            INPUT "").
        RETURN "NOK".
    END.

    /* VALIDAÄÂES DE DATAS PARA CRIAÄ«O DA CONTA CORRETAMENTE*/
    IF  NOT tt-nova-cc.dt-vencimento > 01/01/2014
    OR tt-nova-cc.dt-vencimento = ? THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Data de vencimento " + string(tt-nova-cc.dt-vencimento) + " para a conta corrente Ç inv†lida " ,
                                            INPUT "").
        RETURN "NOK".
    END.

    CASE tt-nova-cc.categoria:
        WHEN "Prata" OR WHEN "Bronze" THEN DO:
            IF  tt-nova-cc.dt-periodo-ini <> DATE(01,01,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-ini <> DATE(10,01,YEAR(tt-nova-cc.dt-periodo-ini)) THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Per°odo inicial " + STRING(tt-nova-cc.dt-periodo-ini) + " para conta corrente Ç inv†lido" ,
                                                    INPUT "").
                RETURN "NOK".
            END.
            IF  tt-nova-cc.dt-periodo-fim <> DATE(09,30,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-fim <> DATE(12,31,YEAR(tt-nova-cc.dt-periodo-ini)) THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Per°odo final " + STRING(tt-nova-cc.dt-periodo-fim) + " para conta corrente Ç inv†lido. ",
                                                    INPUT "").
                RETURN "NOK".
            END.
        END.
        OTHERWISE DO:
            IF  tt-nova-cc.dt-periodo-ini <> DATE(01,01,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-ini <> DATE(04,01,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-ini <> DATE(07,01,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-ini <> DATE(10,01,YEAR(tt-nova-cc.dt-periodo-ini)) THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Per°odo inicial " + STRING(tt-nova-cc.dt-periodo-ini) + " para conta corrente Ç inv†lido. ",
                                                    INPUT "").
                RETURN "NOK".
            END.
            IF  tt-nova-cc.dt-periodo-fim <> DATE(03,31,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-fim <> DATE(06,30,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-fim <> DATE(09,30,YEAR(tt-nova-cc.dt-periodo-ini))
            AND tt-nova-cc.dt-periodo-fim <> DATE(12,31,YEAR(tt-nova-cc.dt-periodo-ini)) THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Per°odo final " + STRING(tt-nova-cc.dt-periodo-fim) + " para a conta corrente Ç inv†lido. ",
                                                    INPUT "").
                RETURN "NOK".
            END.

        END.

    END CASE.

    /* TESTA SE Jµ EXISTE A CONTA CORRENTE */
    IF  CAN-FIND (FIRST int-cc-benef
                      WHERE int-cc-benef.tp-movto       = tt-nova-cc.tp-movto
                        AND int-cc-benef.tipo-beneficio = tt-nova-cc.tipo-beneficio
                        AND int-cc-benef.canal          = tt-nova-cc.canal
                        AND int-cc-benef.unid-neg       = tt-nova-cc.unid-neg
                        AND int-cc-benef.dt-periodo-ini = tt-nova-cc.dt-periodo-ini
                        AND int-cc-benef.dt-periodo-fim = tt-nova-cc.dt-periodo-fim ) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "J† existe conta corrente cadastrada para o canal: " + STRING(tt-nova-cc.canal) +
                                                  ", Unidade: " + tt-nova-cc.unid-neg + ", Benef°cio VMC, " +
                                                  " per°odo " + String(tt-nova-cc.dt-periodo-ini) + " atÇ " + String(tt-nova-cc.dt-periodo-fim) ,
                                            INPUT "").
        RETURN "NOK".
    END.

    /* TESTA SE Jµ PER÷ODO POSTERIOR AO QUE ESTµ SENDO CRIADO, PARA IMPEDIR A CRIAÄ«O */
    IF  CAN-FIND (FIRST int-cc-benef
                      WHERE int-cc-benef.tp-movto       = tt-nova-cc.tp-movto
                        AND int-cc-benef.tipo-beneficio = tt-nova-cc.tipo-beneficio
                        AND int-cc-benef.canal          = tt-nova-cc.canal
                        AND int-cc-benef.unid-neg       = tt-nova-cc.unid-neg
                        AND int-cc-benef.dt-periodo-ini > tt-nova-cc.dt-periodo-fim) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "J†  um registro de conta corrente cadastrada para o canal: " + STRING(tt-nova-cc.canal) +
                                                  ", Unidade: " + tt-nova-cc.unid-neg + ", Benef°cio VMC, " +
                                                  " para um per°odo superior a " + String(tt-nova-cc.dt-periodo-fim) ,
                                            INPUT "").
        RETURN "NOK".
    END.


    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR UNDO bloco, LEAVE bloco:
        /*-------------------------------------------*/
        /*    CRIA A CONTA CORRENTE PARA O CANAL     */
        /*-------------------------------------------*/
        CREATE int-cc-benef.
        BUFFER-COPY tt-nova-cc TO int-cc-benef.
        ASSIGN int-cc-benef.guid-beneficio = tt-beneficio.guid-beneficio.
        
        FIND CURRENT int-cc-benef NO-LOCK NO-ERROR.
        
        /*----------------------------------------------*/
        /*    MOVIMENTO CRIAÄ«O CONTA CORRENTE MANUAL   */
        /*----------------------------------------------*/
        FOR LAST int-cc-benef-movto FIELDS (sequencia) NO-LOCK
            WHERE int-cc-benef-movto.tp-movto       = int-cc-benef.tp-movto
              AND int-cc-benef-movto.canal          = int-cc-benef.canal
              AND int-cc-benef-movto.tipo-beneficio = int-cc-benef.tipo-beneficio
              AND int-cc-benef-movto.unid-neg       = int-cc-benef.unid-neg
              AND int-cc-benef-movto.dt-periodo-ini = int-cc-benef.dt-periodo-ini
              AND int-cc-benef-movto.dt-periodo-fim = int-cc-benef.dt-periodo-fim:
              ASSIGN i-sequencia = int-cc-benef-movto.sequencia.
        END.
    
        CREATE int-cc-benef-movto.
        ASSIGN int-cc-benef-movto.tp-movto          = int-cc-benef.tp-movto
               int-cc-benef-movto.canal             = int-cc-benef.canal          
               int-cc-benef-movto.tipo-beneficio    = int-cc-benef.tipo-beneficio 
               int-cc-benef-movto.unid-neg          = int-cc-benef.unid-neg       
               int-cc-benef-movto.dt-periodo-ini    = int-cc-benef.dt-periodo-ini 
               int-cc-benef-movto.dt-periodo-fim    = int-cc-benef.dt-periodo-fim 
               int-cc-benef-movto.sequencia         = i-sequencia + 10
               int-cc-benef-movto.transacao         = 4 /* 4 - Solicitaá∆o Manual */
               int-cc-benef-movto.dt-movto          = TODAY
               int-cc-benef-movto.hr-movto          = STRING(TIME, "HH:MM:SS")
               int-cc-benef-movto.id-operacao       = 1 /*a maior*/
               int-cc-benef-movto.hist-automatico   = "Criaá∆o manual de conta corrente"
               int-cc-benef-movto.hist-usuario      = p-hist-usuario
               int-cc-benef-movto.usuario           = p-usuario
               int-cc-benef-movto.vl-saldo-anterior = 0
               int-cc-benef-movto.vl-movto          = int-cc-benef.vl-saldo.
    
    
        /*-------------------------------------------------------------------------*/
        /*           MOVIMENTO DE CRIAÄ«O SALDO INCIAL, PARA O TRIMESTRE           */
        /*  FUNÄ«O: SER UTILIZADO COM SALDO INICIAL PARA RECONSTRUIR O SALDO ATUAL */
        /*          DOS BENEF÷CIOS EM UM POSS÷VEL RECµLCULO NO PROGRAMA ESESB005   */
        /*-------------------------------------------------------------------------*/
        RUN pi-cria-transacao-saldo-inicial (INPUT int-cc-benef.canal           ,
                                             INPUT int-cc-benef.tipo-beneficio  ,
                                             INPUT int-cc-benef.unid-neg        ,
                                             INPUT int-cc-benef.dt-periodo-ini  ,
                                             INPUT int-cc-benef.dt-periodo-fim  ,
                                             INPUT p-usuario                    ,
                                             INPUT int-cc-benef.vl-saldo).
    
        /* INTEGRAR O NOVO REGISTRO DE CONTA CORRENTE COM O APB */
        IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
            RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.
    
        ASSIGN da-fim = int-cc-benef.dt-periodo-fim.

        /* QUANDO FOR PROVIS«O */
        IF  int-cc-benef.tp-movto = 1  THEN
            RUN pi-Integra-PROVISAO-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                           INPUT p-dt-trasacao-ap,
                                                           INPUT da-fim,
                                                           OUTPUT TABLE tt-erro-apb).
        /* QUANDO FOR DESPESA */
        IF  int-cc-benef.tp-movto = 2  THEN
            RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                           INPUT p-dt-trasacao-ap,
                                                           INPUT da-fim,
                                                           OUTPUT TABLE tt-erro-apb).
    
        RELEASE int-cc-benef.
        RELEASE int-cc-benef-movto.
    
        IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
            FOR EACH tt-erro-apb:
                CREATE tt-erro.
                BUFFER-COPY tt-erro-apb TO tt-erro.
            END.
            UNDO bloco, RETURN "NOK".
        END.
    
    END. /*Transacao Bloco*/

    RETURN "OK".

END.

/*----------------------------------------------------*/
/*   TRANSAÄ«O  (3)  - AJUSTE DE SALDO DE SALDO CC    */
/*----------------------------------------------------*/
PROCEDURE pi-ajuste:

    DEF INPUT PARAM p-r-movto-origem  AS ROWID           NO-UNDO.
    DEF INPUT PARAM p-vl-movto        AS DEC  DECIMALS 4 NO-UNDO.
    DEF INPUT PARAM p-usuario         AS CHAR            NO-UNDO.
    DEF INPUT PARAM p-hist-usuario    AS CHAR            NO-UNDO.
    DEF INPUT PARAM p-dt-trasacao-ap  AS DATE            NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR i-sequencia      AS INTEGER NO-UNDO.
    DEF VAR da-fim           AS DATE    NO-UNDO.
    DEF VAR l-ajuste-a-maior AS LOG     NO-UNDO.
    DEF VAR c-erro-permissao AS CHAR    NO-UNDO.

    RUN pi-limpa-temp-tables.
    /* VERIFICAÄ«O DE PERMISSÂES DE USUµRIOS */
    RUN pi-valida-operacao-usuario (INPUT p-usuario,
                                    INPUT 3, /*Ajuste de Saldo*/
                                    OUTPUT c-erro-permissao) .
    IF  RETURN-VALUE <> "OK" THEN DO:
        RUN pi-cria-erro (INPUT 17006, /* Erro */
                          INPUT "Usu†rio sem permiss∆o. ",
                          INPUT c-erro-permissao).
        RETURN "NOK".
    END.

    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR UNDO bloco, LEAVE bloco:

        FIND FIRST b-ajuste  
            WHERE rowid(b-ajuste) = p-r-movto-origem  EXCLUSIVE-LOCK NO-ERROR.
    
        IF  NOT AVAIL(b-ajuste) THEN DO:
            RUN pi-cria-erro (INPUT 17006, /* Erro */
                              INPUT "Registro de conta corrente indispon°vel para ajuste...",
                              INPUT "").
            UNDO bloco, RETURN "NOK".
        END.
    
        RUN pi-valida-canal (INPUT b-ajuste.canal,
                             INPUT IF b-ajuste.tp-movto = 1 THEN YES ELSE NO, /*PROVIS«O?*/
                             INPUT b-ajuste.unid-neg,
                             INPUT b-ajuste.tipo-beneficio).
        IF  RETURN-VALUE <> "OK" THEN do: UNDO bloco, RETURN "NOK". END.
    
        /*--------------------------------------------*/
        /*    MOVIMENTO DE AJUSTE DA CONTA CORRENTE   */
        /*--------------------------------------------*/
        FOR LAST int-cc-benef-movto FIELDS(sequencia) NO-LOCK
            WHERE int-cc-benef-movto.tp-movto       = b-ajuste.tp-movto
              AND int-cc-benef-movto.canal          = b-ajuste.canal
              AND int-cc-benef-movto.tipo-beneficio = b-ajuste.tipo-beneficio
              AND int-cc-benef-movto.unid-neg       = b-ajuste.unid-neg
              AND int-cc-benef-movto.dt-periodo-ini = b-ajuste.dt-periodo-ini
              AND int-cc-benef-movto.dt-periodo-fim = b-ajuste.dt-periodo-fim:
              ASSIGN i-sequencia = int-cc-benef-movto.sequencia.
        END.
    
        ASSIGN l-ajuste-a-maior = IF p-vl-movto >= b-ajuste.vl-saldo THEN YES ELSE NO.
        
        CREATE int-cc-benef-movto.
        ASSIGN int-cc-benef-movto.tp-movto          = b-ajuste.tp-movto
               int-cc-benef-movto.canal             = b-ajuste.canal          
               int-cc-benef-movto.tipo-beneficio    = b-ajuste.tipo-beneficio 
               int-cc-benef-movto.unid-neg          = b-ajuste.unid-neg       
               int-cc-benef-movto.dt-periodo-ini    = b-ajuste.dt-periodo-ini 
               int-cc-benef-movto.dt-periodo-fim    = b-ajuste.dt-periodo-fim 
               int-cc-benef-movto.sequencia         = i-sequencia + 10
               int-cc-benef-movto.transacao         = 3 /* 1 - Sa°da de Transferància */
               int-cc-benef-movto.dt-movto          = TODAY
               int-cc-benef-movto.hr-movto          = STRING(TIME, "HH:MM:SS")
               int-cc-benef-movto.id-operacao       = IF l-ajuste-a-maior THEN 1 ELSE 2
               int-cc-benef-movto.hist-automatico   = "Ajuste de saldo " + (IF l-ajuste-a-maior THEN "a maior" ELSE "a menor") +
                                                        " de R$ " + TRIM(string(b-ajuste.vl-saldo, ">>>,>>>,>>9.9999")) + " para R$ " + TRIM(string(p-vl-movto, ">>>,>>>,>>9.9999"))
               int-cc-benef-movto.hist-usuario      = p-hist-usuario
               int-cc-benef-movto.usuario           = p-usuario
               int-cc-benef-movto.vl-saldo-anterior = b-ajuste.vl-saldo
               int-cc-benef-movto.vl-movto          = IF p-vl-movto >= b-ajuste.vl-saldo THEN 
                                                         (p-vl-movto - b-ajuste.vl-saldo) 
                                                      ELSE
                                                         (b-ajuste.vl-saldo - p-vl-movto).
               IF  NOT l-ajuste-a-maior THEN
                   ASSIGN int-cc-benef-movto.vl-movto = int-cc-benef-movto.vl-movto * - 1.

        /* DESCONTA O SALDO TRANSFERIDO */
        ASSIGN  b-ajuste.vl-saldo-ant = b-ajuste.vl-saldo 
                b-ajuste.vl-saldo     = p-vl-movto.
    
        RELEASE int-cc-benef-movto.
    
        FIND CURRENT b-ajuste NO-LOCK NO-ERROR.
    
        /* INTEGRAR O NOVO REGISTRO DE CONTA CORRENTE COM O APB */
        IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
            RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.
    
        ASSIGN da-fim = b-ajuste.dt-periodo-fim.
    

        /* QUANDO FOR PROVIS«O */
        IF  b-ajuste.tp-movto = 1  THEN
            RUN pi-Integra-PROVISAO-APB IN h-esesb003-apb (INPUT ROWID(b-ajuste),
                                                           INPUT p-dt-trasacao-ap,
                                                           INPUT da-fim,
                                                           OUTPUT TABLE tt-erro-apb).

        /* QUANDO FOR DESPESA */
        IF  b-ajuste.tp-movto = 2  THEN
            RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(b-ajuste),
                                                           INPUT p-dt-trasacao-ap,
                                                           INPUT da-fim,
                                                           OUTPUT TABLE tt-erro-apb).

        IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
            FOR EACH tt-erro-apb:
                CREATE tt-erro.
                BUFFER-COPY tt-erro-apb TO tt-erro.
            END.
            UNDO bloco, RETURN "NOK".
        END.
    
        RELEASE b-ajuste.
    END. /* Transaá∆o Bloco */

    RETURN "OK".

END.


PROCEDURE pi-cria-nova-cc-transf:

    DEF INPUT PARAM p-r-movto-origem AS ROWID NO-UNDO.
    DEF INPUT PARAM p-unid-neg       AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-vl-movto       AS DEC   NO-UNDO.
    DEF INPUT PARAM p-usuario        AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-dt-trasacao-ap AS DATE  NO-UNDO.

    DEF VAR r-rowid-cc  AS ROWID   NO-UNDO.
    DEF VAR da-fim      AS DATE    NO-UNDO.
    DEF VAR i           AS INTEGER NO-UNDO.
    DEF VAR c-trimestre AS CHAR    NO-UNDO.
    DEF VAR i-sequencia AS INTEGER NO-UNDO.

    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR UNDO bloco, LEAVE bloco:

        CREATE int-cc-benef.
        BUFFER-COPY b-origem EXCEPT unid-neg vl-saldo vl-saldo-ant vl-empenhado vl-saldo-ori usuario cod_estab num_id_tit_ap
                TO int-cc-benef.
    
        ASSIGN int-cc-benef.unid-neg     = p-unid-neg
               int-cc-benef.vl-saldo     = p-vl-movto
               int-cc-benef.vl-saldo-ant = 0
               int-cc-benef.usuario      = p-usuario.
        
        ASSIGN r-rowid-cc = ROWID(int-cc-benef).
    
        ASSIGN da-fim = int-cc-benef.dt-periodo-fim.
    
        FIND FIRST b-destino OF int-cc-benef NO-LOCK NO-ERROR.
        IF  NOT AVAIL b-destino THEN DO: UNDO bloco, RETURN "NOK". END.
    
        FIND CURRENT b-origem EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL b-origem THEN DO:
            RUN pi-cria-erro (INPUT 17006, /* Erro */
                              INPUT "Registro de conta corrente origem indispon°vel...",
                              INPUT "").
            UNDO bloco, RETURN "NOK".
        END.
    
        RUN pi-valida-canal (INPUT b-destino.canal,
                             INPUT NO, /*PROVIS«O?*/
                             INPUT b-destino.unid-neg,
                             INPUT b-destino.tipo-beneficio).
        IF  RETURN-VALUE <> "OK" THEN DO: UNDO bloco, RETURN "NOK". END.
    
        ASSIGN b-origem.vl-saldo-ant = b-origem.vl-saldo 
               b-origem.vl-saldo     = b-origem.vl-saldo - p-vl-movto.
    
        FIND CURRENT b-origem NO-LOCK NO-ERROR.
    
        /*-------------------------------------------------------------------------*/
        /*          MOVIMENTO DE CRIAÄ«O SALDO INCIAL, PARA O TRIMESTRE            */
        /*  FUNÄ«O: ARMAZEAR O SALDO INICIAL PARA RECONSTRUIR O SALDO ATUAL        */
        /*          DOS BENEF÷CIOS EM UM POSS÷VEL RECµLCULO NO PROGRAMA ESESB005RP */
        /*-------------------------------------------------------------------------*/
        RUN pi-cria-transacao-saldo-inicial   (INPUT int-cc-benef.canal           ,
                                               INPUT int-cc-benef.tipo-beneficio  ,
                                               INPUT int-cc-benef.unid-neg        ,
                                               INPUT int-cc-benef.dt-periodo-ini  ,
                                               INPUT int-cc-benef.dt-periodo-fim  ,
                                               INPUT p-usuario                    ,
                                               INPUT int-cc-benef.vl-saldo).
    
        RELEASE int-cc-benef.
        
        /* INTEGRAR O NOVO REGISTRO DE CONTA CORRENTE COM O APB */
        IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
            RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.
    
        RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT r-rowid-cc,
                                                      INPUT p-dt-trasacao-ap,
                                                      INPUT da-fim,
                                                      OUTPUT TABLE tt-erro-apb).
        IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
            FOR EACH tt-erro-apb:
                CREATE tt-erro.
                BUFFER-COPY tt-erro-apb TO tt-erro.
            END.
            UNDO bloco, RETURN "NOK". 
        END.
    
        ASSIGN r-rowid-cc = ROWID(b-origem).
        RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT r-rowid-cc,
                                                      INPUT p-dt-trasacao-ap,
                                                      INPUT da-fim,
                                                      OUTPUT TABLE tt-erro-apb).
        IF  CAN-FIND (FIRST tt-erro-apb) THEN DO:
            FOR EACH tt-erro-apb:
                CREATE tt-erro.
                BUFFER-COPY tt-erro-apb TO tt-erro.
            END.
            UNDO bloco, RETURN "NOK".
        END.
    END. /*Transaá∆o bloco*/

    RETURN "OK".

END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.


PROCEDURE pi-valida-canal:

    DEF INPUT PARAM p-canal          AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-provisao       AS LOG     NO-UNDO.
    DEF INPUT PARAM p-unidade        AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-tipo-beneficio AS INTEGER NO-UNDO.

    /*Validaá‰es do canal. Retorna a estrutura de centrais e filiais*/
    RUN pi-carreta-tt-central (INPUT p-canal).

    IF  RETURN-VALUE <> "OK" THEN RETURN "NOK".

    FIND FIRST tt-central
        WHERE tt-central.canal-central = p-canal NO-ERROR.


    IF  tt-central.nome-abrev-central <> tt-central.nome-abrev-filial 
    AND tt-central.centralizada THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Canal " + string(tt-central.canal-filial) + " - " + tt-central.nome-emit-filial + " possui apuraá∆o de benef°cios centralizada.",
                                            INPUT "A movimentaá∆o de conta corrente deve ser feita pela Matriz").
        RETURN "NOK".
    END.

    IF  p-provisao THEN
        RETURN "OK".
    /* VERIFICA SE O BENEF÷CIO ESTµ ATIVO */
    RUN pi-beneficio-ativo (INPUT p-canal,
                            INPUT p-provisao).

    FIND FIRST tt-beneficio 
        WHERE tt-beneficio.tipo-beneficio = p-tipo-beneficio
          AND tt-beneficio.unid-neg       = p-unidade
          AND tt-beneficio.id-status      = 1 NO-ERROR. /* Ativo */ 
    IF  NOT AVAIL tt-beneficio THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Benef°cio " + fn-beneficio(p-tipo-beneficio) + " Ç inv†lido para o canal." ,
                                            INPUT "O tipo de benef°cio n∆o existe ou n∆o est† ativo para o canal.").
        RETURN "NOK".
    END.

    RETURN "OK".
END.


PROCEDURE pi-beneficio-ativo:

    DEF INPUT PARAM  p-canal AS INTEGER NO-UNDO.
    DEF INPUT PARAM  p-provisao AS LOG NO-UNDO.

    DEF BUFFER b-emitente FOR emitente.
    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.
    EMPTY TEMP-TABLE tt-canal.

    CREATE tt-canal.
    ASSIGN tt-canal.canal       = p-canal
           tt-canal.guid-canal  = tt-central.guid-canal-central
           tt-canal.guid-class  = tt-central.guid-class-central.

    RUN esp/esb/esesbapi004-benef.p (INPUT  p-provisao,
                                     INPUT  NO, /* Buscar msg0111 com o % global de cada benef°cio   */ 
                                     INPUT  NO, /* Buscar msg0142, parÉmetros financeiros e provis∆o */ 
                                     INPUT  ?,    /* (?) para buscar todas as unidades, ou informar uma unidade espec°fica */
                                     INPUT  ?,    /* (?) para buscar todas os beneficios, ou informar uma beneficio espec°fico */
                                     INPUT  TABLE tt-canal,
                                     OUTPUT TABLE tt-erro-benef,
                                     OUTPUT TABLE tt-beneficio).

    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro-benef) THEN DO:
        FOR EACH tt-erro-benef:
            CREATE tt-erro.
            BUFFER-COPY tt-erro-benef TO tt-erro.
        END.
        RETURN "NOK".
    END.

    RETURN "OK".
END.


PROCEDURE pi-destroy:

    IF  VALID-HANDLE(h-esesb003-apb) THEN 
        DELETE PROCEDURE h-esesb003-apb.

    IF  VALID-HANDLE(THIS-PROCEDURE) THEN 
        DELETE PROCEDURE THIS-PROCEDURE.

    RETURN "OK".
END.


PROCEDURE pi-limpa-temp-tables:

    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-erro-apb.
    EMPTY TEMP-TABLE tt-erro-central.
    EMPTY TEMP-TABLE tt-canal.
    EMPTY TEMP-TABLE tt-beneficio.
    EMPTY TEMP-TABLE tt-movto.
    EMPTY TEMP-TABLE resultado.

    RETURN "OK".

END.

FUNCTION fn-beneficio RETURNS CHAR
    (p-status AS INT):
    
    CASE p-status:
        WHEN 21 THEN RETURN "VMC". 
        WHEN 37 THEN RETURN "Rebate".  
        WHEN 66 THEN RETURN "Rebate P¢s-venda".
        WHEN 22 THEN RETURN "Stock Rotation". 
    END CASE.

    RETURN "".
END FUNCTION.

FUNCTION fn-status RETURNS CHAR
    (p-status AS INT):
    
    CASE p-status:
        WHEN 1 THEN RETURN "Bloqueado". 
        WHEN 2 THEN RETURN "Liberado".  
        WHEN 3 THEN RETURN "Finalizado".
        WHEN 4 THEN RETURN "Cancelado". 
    END CASE.

    RETURN "".
END FUNCTION.


