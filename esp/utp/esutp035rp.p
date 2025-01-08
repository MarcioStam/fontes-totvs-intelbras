/***********************************************************************
**  Programa..: ESP\REP\ESUTP035RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio telefonia para Usu rios Excel
**  VersÆo....: 001 01/07/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESUTP035 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/utp/esutp035tt.i}

{utp/utapi009.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

{esp/es0018.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-processos NO-UNDO
    FIELD processo      AS CHARACTER FORMAT "x(20)"
    FIELD dt-processo   AS DATE FORMAT "99/99/9999"
    FIELD dt-receb      AS DATE FORMAT "99/99/9999"
    FIELD autor         AS CHARACTER FORMAT "x(60)"
    FIELD cidade        AS CHARACTER FORMAT "x(50)"
    FIELD estado        AS CHARACTER FORMAT "x(02)"
    FIELD dt-prevista   AS DATE FORMAT "99/99/9999"
    FIELD acao          AS CHARACTER FORMAT "x(30)"
    FIELD motivo        AS CHARACTER FORMAT "x(30)"
    FIELD tipo          AS CHARACTER FORMAT "x(30)"
    FIELD situacao      AS CHARACTER FORMAT "x(15)"
    FIELD vara          AS CHARACTER FORMAT "x(30)"
    FIELD unid-negoc    AS CHARACTER FORMAT "x(05)"
    FIELD produto       AS CHARACTER FORMAT "x(40)"
    FIELD valor-causa   AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD objeto-acao   AS CHARACTER FORMAT "x(40)"
    FIELD solucao       AS CHARACTER FORMAT "x(40)"
    FIELD despesa       AS CHARACTER 
    FIELD valor-despesa AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD valor-danos-cobr AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD valor-danos-pago AS DECIMAL FORMAT "->>>,>>>,>>9.99".


DEFINE VARIABLE i-erro    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-nome    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email   AS CHARACTER   NO-UNDO.

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
       c-titulo-relat = "Planilha Processos Jur¡dicos"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESUTP035"
       c-versao       = "2.04"
       c-revisao      = "001".



/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    FOR EACH tt-processos:
        DELETE tt-processos.
    END.

    ASSIGN i-erro = 0.

    IF tt-param.i-tipo = 1 THEN
        RUN pi-gera-sintetico.
    ELSE DO:
        IF NOT tt-param.l-despesas THEN
            RUN pi-gera-analitico.
        ELSE 
            RUN pi-gera-analitico-despesas.
    END.
        
    PUT UNFORMATTED 
        SKIP(2)
        "Processo:"                            TO 20 
        tt-param.processo-ini                  AT 22 
        " < > "                                AT 43
        tt-param.processo-fim                  AT 48 SKIP
        "Dt.Recebimento:"                      TO 20 
        tt-param.dt-receb-ini                  AT 22 
        " < > "                                AT 43
        tt-param.dt-receb-fim                  AT 48 SKIP
        "Data Processo:"                       TO 20 
        tt-param.dt-processo-ini               AT 22 
        " < > "                                AT 43
        tt-param.dt-processo-fim               AT 48 SKIP
        "Cod. Acao:"                           TO 20 
        tt-param.cod-acao-ini                  AT 22 
        " < > "                                AT 43
        tt-param.cod-acao-fim                  AT 48 SKIP
        "Data Prevista:"                       TO 20 
        tt-param.dt-prevista-ini               AT 22 
        " < > "                                AT 43
        tt-param.dt-prevista-fim               AT 48 SKIP
        "Cod. Despesa:"                        TO 20 
        tt-param.cod-despesa-ini               AT 22 
        " < > "                                AT 43
        tt-param.cod-despesa-fim               AT 48 SKIP.


    {include/i-rpclo.i}

    RUN pi-finalizar in h-acomp.

    OS-COMMAND NO-WAIT VALUE(tt-param.c-arq-excel).

    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:

    
END PROCEDURE.

PROCEDURE pi-gera-sintetico:

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    FOR EACH juridico-processos NO-LOCK
       WHERE juridico-processos.processo     >= tt-param.processo-ini   
         AND juridico-processos.processo     <= tt-param.processo-fim   
         AND juridico-processos.dt-processo  >= tt-param.dt-processo-ini
         AND juridico-processos.dt-processo  <= tt-param.dt-processo-fim
         AND juridico-processos.dt-recebimento >= tt-param.dt-receb-ini
         AND juridico-processos.dt-recebimento  <= tt-param.dt-receb-fim:

        run pi-acompanhar in h-acomp (INPUT "Processo: " + juridico-processos.processo).

        FIND FIRST juridico-motivos NO-LOCK
             WHERE juridico-motivos.codigo = juridico-processos.cod-motivo NO-ERROR.
        FIND FIRST juridico-tipos NO-LOCK
             WHERE juridico-tipos.codigo = juridico-processos.cod-tipo NO-ERROR.
        FIND FIRST juridico-situacoes NO-LOCK
             WHERE juridico-situacoes.codigo = juridico-processos.cod-situacao NO-ERROR.
        FIND FIRST juridico-solucoes NO-LOCK
             WHERE juridico-solucoes.codigo = juridico-processos.cod-solucao NO-ERROR.

        CREATE tt-processos.
        ASSIGN tt-processos.processo    = juridico-processos.processo
               tt-processos.dt-processo = juridico-processos.dt-processo
               tt-processos.dt-receb    = juridico-processos.dt-recebimento
               tt-processos.autor       = juridico-processos.autor
               tt-processos.cidade      = juridico-processos.cidade
               tt-processos.estado      = juridico-processos.estado
               tt-processos.vara        = juridico-processos.vara-judicial
               tt-processos.unid-negoc  = juridico-processos.cod-unid-negoc
               tt-processos.produto     = juridico-processos.produto
               tt-processos.motivo      = TRIM(STRING(juridico-processos.cod-motivo))   + " - " + IF AVAIL juridico-motivos THEN juridico-motivos.descricao ELSE "Nao Cadastrado"
               tt-processos.tipo        = TRIM(STRING(juridico-processos.cod-tipo))     + " - " + IF AVAIL juridico-tipos THEN juridico-tipos.descricao ELSE "Nao Cadastrado"
               tt-processos.situacao    = TRIM(STRING(juridico-processos.cod-situacao)) + " - " + IF AVAIL juridico-situacoes THEN juridico-situacoes.descricao ELSE "Nao Cadastrado"
               tt-processos.solucao     = TRIM(STRING(juridico-processos.cod-solucao))  + " - " + IF AVAIL juridico-solucoes THEN juridico-solucoes.descricao   ELSE "Nao Cadastrado"
               tt-processos.objeto-acao = juridico-processos.objeto-acao
               tt-processos.valor-causa = juridico-processos.valor-acao
               tt-processos.valor-danos-cobr = juridico-processos.valor-danos-cobr
               tt-processos.valor-danos-pago = juridico-processos.valor-danos-pago.

        FOR EACH juridico-andamentos OF juridico-processos NO-LOCK     
           WHERE juridico-andamentos.cod-acao    >= tt-param.cod-acao-ini   
             AND juridico-andamentos.cod-acao    <= tt-param.cod-acao-fim   
             AND juridico-andamentos.dt-prevista >= tt-param.dt-prevista-ini
             AND juridico-andamentos.dt-prevista <= tt-param.dt-prevista-fim:
            FOR EACH juridico-despesas OF juridico-andamentos NO-LOCK
               WHERE juridico-despesas.cod-despesa  >= tt-param.cod-despesa-ini
                 AND juridico-despesas.cod-despesa  <= tt-param.cod-despesa-fim:
                ASSIGN tt-processos.valor-despesa = tt-processos.valor-despesa + juridico-despesas.valor.
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-processos) THEN DO:
        RUN pi-inicializar in h-acomp (input "Gerando Excel...").

        OUTPUT TO VALUE(tt-param.c-arq-excel) CONVERT TARGET SESSION:CHARSET.

        PUT UNFORMATTED "Processo;Data Processo;Dt.Recebimento;Autor;Cidade;Estado;Motivo;Tipo;Situa‡Æo;Solu‡Æo;Vara;Unid.Negoc.;Produto;Objeto A‡Æo;Valor Causa;Cobr.Danos Morais;Pago Danos Morais;Despesas" SKIP.

        FOR EACH tt-processos
            BY tt-processos.processo
            BY tt-processos.acao:

            run pi-acompanhar in h-acomp (INPUT "Imprimindo Processo: " + tt-processos.processo).

            PUT UNFORMATTED
                 tt-processos.processo          ";"
                 tt-processos.dt-processo       ";"
                 tt-processos.dt-receb          ";"
                 tt-processos.autor             ";"
                 tt-processos.cidade            ";"
                 tt-processos.estado            ";"
                 tt-processos.motivo            ";"
                 tt-processos.tipo              ";"
                 tt-processos.situacao          ";"
                 tt-processos.solucao           ";"
                 tt-processos.vara              ";"
                 tt-processos.unid-negoc        ";"
                 tt-processos.produto           ";"
                 tt-processos.objeto-acao       ";"
                 tt-processos.valor-causa       ";"
                 tt-processos.valor-danos-cobr  ";"
                 tt-processos.valor-danos-pago  ";"
                 tt-processos.valor-despesa     SKIP.
        END.
        OUTPUT CLOSE.
    END.
    ELSE DO:
        MESSAGE "NÆo encontrado nenhum processo com a sele‡Æo utilizada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END PROCEDURE.

PROCEDURE pi-gera-analitico:

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    FOR EACH juridico-processos NO-LOCK
       WHERE juridico-processos.processo     >= tt-param.processo-ini   
         AND juridico-processos.processo     <= tt-param.processo-fim   
         AND juridico-processos.dt-processo  >= tt-param.dt-processo-ini
         AND juridico-processos.dt-processo  <= tt-param.dt-processo-fim
         AND juridico-processos.dt-recebimento >= tt-param.dt-receb-ini
         AND juridico-processos.dt-recebimento  <= tt-param.dt-receb-fim,
        EACH juridico-andamentos OF juridico-processos NO-LOCK     
       WHERE juridico-andamentos.cod-acao    >= tt-param.cod-acao-ini   
         AND juridico-andamentos.cod-acao    <= tt-param.cod-acao-fim   
         AND juridico-andamentos.dt-prevista >= tt-param.dt-prevista-ini
         AND juridico-andamentos.dt-prevista <= tt-param.dt-prevista-fim:

        FIND FIRST juridico-acoes NO-LOCK
             WHERE juridico-acoes.codigo = juridico-andamentos.cod-acao NO-ERROR.
        FIND FIRST juridico-motivos NO-LOCK
             WHERE juridico-motivos.codigo = juridico-processos.cod-motivo NO-ERROR.
        FIND FIRST juridico-tipos NO-LOCK
             WHERE juridico-tipos.codigo = juridico-processos.cod-tipo NO-ERROR.
        FIND FIRST juridico-situacoes NO-LOCK
             WHERE juridico-situacoes.codigo = juridico-processos.cod-situacao NO-ERROR.
        FIND FIRST juridico-solucoes NO-LOCK
             WHERE juridico-solucoes.codigo = juridico-processos.cod-solucao NO-ERROR.

        run pi-acompanhar in h-acomp (INPUT "Processo: " + juridico-processos.processo).

        CREATE tt-processos.
        ASSIGN tt-processos.processo    = juridico-processos.processo
               tt-processos.dt-processo = juridico-processos.dt-processo
               tt-processos.dt-receb    = juridico-processos.dt-recebimento
               tt-processos.autor       = juridico-processos.autor
               tt-processos.cidade      = juridico-processos.cidade
               tt-processos.estado      = juridico-processos.estado
               tt-processos.dt-prevista = juridico-andamentos.dt-prevista
               tt-processos.acao        = TRIM(STRING(juridico-andamentos.cod-acao))  + " - " + IF AVAIL juridico-andamentos THEN juridico-acoes.descricao ELSE "Nao Cadastrado"
               tt-processos.motivo      = TRIM(STRING(juridico-processos.cod-motivo)) + " - " + IF AVAIL juridico-motivos THEN juridico-motivos.descricao ELSE "Nao Cadastrado"
               tt-processos.tipo        = TRIM(STRING(juridico-processos.cod-tipo))   + " - " + IF AVAIL juridico-tipos THEN juridico-tipos.descricao ELSE "Nao Cadastrado"
               tt-processos.situacao    = TRIM(STRING(juridico-processos.cod-situacao)) + " - " + IF AVAIL juridico-situacoes THEN juridico-situacoes.descricao ELSE "Nao Cadastrado"
               tt-processos.solucao     = TRIM(STRING(juridico-processos.cod-solucao))  + " - " + IF AVAIL juridico-solucoes THEN juridico-solucoes.descricao   ELSE "Nao Cadastrado"
               tt-processos.vara        = juridico-processos.vara-judicial
               tt-processos.unid-negoc  = juridico-processos.cod-unid-negoc
               tt-processos.produto     = juridico-processos.produto
               tt-processos.objeto-acao = juridico-processos.objeto-acao
               tt-processos.valor-causa = juridico-processos.valor-acao
               tt-processos.valor-danos-cobr = juridico-processos.valor-danos-cobr
               tt-processos.valor-danos-pago = juridico-processos.valor-danos-pago.

        FOR EACH juridico-despesas OF juridico-andamentos NO-LOCK
           WHERE juridico-despesas.cod-despesa  >= tt-param.cod-despesa-ini
             AND juridico-despesas.cod-despesa  <= tt-param.cod-despesa-fim:
            ASSIGN tt-processos.valor-despesa = tt-processos.valor-despesa + juridico-despesas.valor.
        END.
    END.

    IF CAN-FIND(FIRST tt-processos) THEN DO:
        RUN pi-inicializar in h-acomp (input "Gerando Excel...").

        OUTPUT TO VALUE(tt-param.c-arq-excel) CONVERT TARGET SESSION:CHARSET.

        PUT UNFORMATTED
             "Processo;Data Processo;Dt.Recebimento;Autor;Cidade;Estado;A‡Æo;Data Prevista;Motivo;Tipo;Situa‡Æo;Solu‡Æo;Vara;Unid.Negoc.;Produto;Objeto A‡Æo;Valor Causa;Cobr.Danos Morais;Pago Danos Morais;Despesas" SKIP.

        FOR EACH tt-processos
            BY tt-processos.processo
            BY tt-processos.acao:

            run pi-acompanhar in h-acomp (INPUT "Imprimindo Processo: " + tt-processos.processo).

            PUT UNFORMATTED
                tt-processos.processo             ";"
                tt-processos.dt-processo          ";"
                tt-processos.dt-receb             ";"
                tt-processos.autor                ";"
                tt-processos.cidade               ";"
                tt-processos.estado               ";"
                tt-processos.acao                 ";"
                tt-processos.dt-prevista          ";"
                tt-processos.motivo               ";"
                tt-processos.tipo                 ";"
                tt-processos.situacao             ";"
                tt-processos.solucao              ";"
                tt-processos.vara                 ";"
                tt-processos.unid-negoc           ";"
                tt-processos.produto              ";"
                tt-processos.objeto-acao          ";"
                tt-processos.valor-causa          ";"
                tt-processos.valor-danos-cobr     ";"
                tt-processos.valor-danos-pago     ";"
                tt-processos.valor-despesa        SKIP.
        END.

        OUTPUT TO CLOSE.
    END.
    ELSE DO:
        MESSAGE "NÆo encontrado nenhum processo com a sele‡Æo utilizada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.


PROCEDURE pi-gera-analitico-despesas:

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    FOR EACH juridico-processos NO-LOCK
       WHERE juridico-processos.processo     >= tt-param.processo-ini   
         AND juridico-processos.processo     <= tt-param.processo-fim   
         AND juridico-processos.dt-processo  >= tt-param.dt-processo-ini
         AND juridico-processos.dt-processo  <= tt-param.dt-processo-fim
         AND juridico-processos.dt-recebimento >= tt-param.dt-receb-ini
         AND juridico-processos.dt-recebimento  <= tt-param.dt-receb-fim,
        EACH juridico-andamentos OF juridico-processos NO-LOCK     
       WHERE juridico-andamentos.cod-acao    >= tt-param.cod-acao-ini   
         AND juridico-andamentos.cod-acao    <= tt-param.cod-acao-fim   
         AND juridico-andamentos.dt-prevista >= tt-param.dt-prevista-ini
         AND juridico-andamentos.dt-prevista <= tt-param.dt-prevista-fim:

        FIND FIRST juridico-acoes NO-LOCK
             WHERE juridico-acoes.codigo = juridico-andamentos.cod-acao NO-ERROR.
        FIND FIRST juridico-motivos NO-LOCK
             WHERE juridico-motivos.codigo = juridico-processos.cod-motivo NO-ERROR.
        FIND FIRST juridico-tipos NO-LOCK
             WHERE juridico-tipos.codigo = juridico-processos.cod-tipo NO-ERROR.
        FIND FIRST juridico-situacoes NO-LOCK
             WHERE juridico-situacoes.codigo = juridico-processos.cod-situacao NO-ERROR.
        FIND FIRST juridico-solucoes NO-LOCK
             WHERE juridico-solucoes.codigo = juridico-processos.cod-solucao NO-ERROR.

        run pi-acompanhar in h-acomp (INPUT "Processo: " + juridico-processos.processo).

        IF CAN-FIND(FIRST juridico-despesas OF juridico-andamentos NO-LOCK
                    WHERE juridico-despesas.cod-despesa  >= tt-param.cod-despesa-ini
                      AND juridico-despesas.cod-despesa  <= tt-param.cod-despesa-fim) THEN DO:
            FOR EACH juridico-despesas OF juridico-andamentos NO-LOCK
               WHERE juridico-despesas.cod-despesa  >= tt-param.cod-despesa-ini
                 AND juridico-despesas.cod-despesa  <= tt-param.cod-despesa-fim:

                FIND FIRST juridico-tp-despesa NO-LOCK
                     WHERE juridico-tp-despesa.codigo = juridico-despesas.cod-despesa NO-ERROR.

                CREATE tt-processos.
                ASSIGN tt-processos.processo    = juridico-processos.processo
                       tt-processos.dt-processo = juridico-processos.dt-processo
                       tt-processos.dt-receb    = juridico-processos.dt-recebimento
                       tt-processos.autor       = juridico-processos.autor
                       tt-processos.cidade      = juridico-processos.cidade
                       tt-processos.estado      = juridico-processos.estado
                       tt-processos.dt-prevista = juridico-andamentos.dt-prevista
                       tt-processos.acao        = TRIM(STRING(juridico-andamentos.cod-acao))  + " - " + IF AVAIL juridico-andamentos THEN juridico-acoes.descricao ELSE "Nao Cadastrado"
                       tt-processos.motivo      = TRIM(STRING(juridico-processos.cod-motivo)) + " - " + IF AVAIL juridico-motivos THEN juridico-motivos.descricao ELSE "Nao Cadastrado"
                       tt-processos.tipo        = TRIM(STRING(juridico-processos.cod-tipo))   + " - " + IF AVAIL juridico-tipos THEN juridico-tipos.descricao ELSE "Nao Cadastrado"
                       tt-processos.situacao    = TRIM(STRING(juridico-processos.cod-situacao)) + " - " + IF AVAIL juridico-situacoes THEN juridico-situacoes.descricao ELSE "Nao Cadastrado"
                       tt-processos.solucao     = TRIM(STRING(juridico-processos.cod-solucao))  + " - " + IF AVAIL juridico-solucoes THEN juridico-solucoes.descricao   ELSE "Nao Cadastrado"
                       tt-processos.vara        = juridico-processos.vara-judicial
                       tt-processos.unid-negoc  = juridico-processos.cod-unid-negoc
                       tt-processos.produto     = juridico-processos.produto
                       tt-processos.objeto-acao = juridico-processos.objeto-acao
                       tt-processos.despesa     = TRIM(STRING(juridico-despesas.cod-despesa))  + " - " + IF AVAIL juridico-tp-despesa THEN juridico-tp-despesa.descricao ELSE "Nao Cadastrado"
                       tt-processos.valor-despesa = juridico-despesas.valor
                       tt-processos.valor-causa = juridico-processos.valor-acao
                       tt-processos.valor-danos-cobr = juridico-processos.valor-danos-cobr
                       tt-processos.valor-danos-pago = juridico-processos.valor-danos-pago.

            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-processos) THEN DO:
        RUN pi-inicializar in h-acomp (input "Gerando Excel...").

        OUTPUT TO VALUE(tt-param.c-arq-excel) CONVERT TARGET SESSION:CHARSET.
        PUT UNFORMATTED
             "Processo;Data Processo;Dt.Recebimento;Autor;Cidade;Estado;A‡Æo;Data Prevista;Motivo;Tipo;Situa‡Æo;Solu‡Æo;Vara;Unid.Negoc.;Produto;Objeto A‡Æo;Valor Causa;Cobr.Danos Morais;Pago Danos Morais;Despesa;Valor Despesa" SKIP.

        FOR EACH tt-processos
            BY tt-processos.processo
            BY tt-processos.acao:

            run pi-acompanhar in h-acomp (INPUT "Imprimindo Processo: " + tt-processos.processo).

            PUT UNFORMATTED
                tt-processos.processo         ";"
                tt-processos.dt-processo      ";"
                tt-processos.dt-receb         ";"
                tt-processos.autor            ";"
                tt-processos.cidade           ";"
                tt-processos.estado           ";"
                tt-processos.acao             ";"
                tt-processos.dt-prevista      ";"
                tt-processos.motivo           ";"
                tt-processos.tipo             ";"
                tt-processos.situacao         ";"
                tt-processos.solucao          ";"
                tt-processos.vara             ";"
                tt-processos.unid-negoc       ";"
                tt-processos.produto          ";"
                tt-processos.objeto-acao      ";"
                tt-processos.valor-causa      ";"
                tt-processos.valor-danos-cobr ";"
                tt-processos.valor-danos-pago ";"
                tt-processos.despesa          ";"
                tt-processos.valor-despesa SKIP.

        END.
        OUTPUT TO CLOSE.
    END.
    ELSE DO:
        MESSAGE "NÆo encontrado nenhum processo com a sele‡Æo utilizada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.
