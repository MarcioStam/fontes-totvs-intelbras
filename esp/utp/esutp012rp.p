{include/i-prgvrs.i ESUTP012 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESUTP012RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Comunicaá‰es - Rateios - Supervisores
**  Vers∆o....: 001 01/07/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/utp/esutp012tt.i}

{utp/utapi009.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-rateios NO-UNDO LIKE rateio-equipamentos
    FIELD supervisor AS CHARACTER
    FIELD nome-equipamento AS CHARACTER.

DEFINE TEMP-TABLE tt-verificar NO-UNDO
    FIELD cod-erro AS INTEGER
    FIELD desc-erro AS CHARACTER FORMAT "x(60)".

DEFINE TEMP-TABLE tt-supervisores NO-UNDO
    FIELD supervisor AS CHARACTER
    FIELD nome       AS CHARACTER
    FIELD email      AS CHARACTER
    INDEX chave supervisor
    INDEX ch-nome nome.

DEFINE TEMP-TABLE tt-quant-cc NO-UNDO
    FIELD supervisor AS INTEGER
    FIELD mes-ref    AS CHARACTER
    FIELD cc-codigo  AS CHARACTER
    FIELD quant      AS INTEGER.

DEFINE TEMP-TABLE tt-geral NO-UNDO
    FIELD supervisor AS CHARACTER
    FIELD mes-ref    AS CHARACTER
    FIELD valor      AS DECIMAL.

DEFINE VARIABLE i-erro       AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cc         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-supervisor AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE chExcel2  AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWBook2  AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWSheet2 AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-aux  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-quant      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-coluna     AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-selecao-graf AS CHARACTER   NO-UNDO.
/*DEFINE VARIABLE c-periodo-ini  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodo-fim  AS CHARACTER   NO-UNDO.*/
DEFINE VARIABLE c-dir-nome-arq AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-descricao    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE de-valor AS DECIMAL FORMAT "->>>,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE de-total AS DECIMAL FORMAT "->>>,>>>,>>9.99"  NO-UNDO.

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
       c-titulo-relat = "Comunicaá‰es Supervisores"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP012"
       c-versao       = "2.04"
       c-revisao      = "001".

FOR EACH tt-rateios:
    DELETE tt-rateios.
END.

FOR EACH tt-verificar:
    DELETE tt-verificar.
END.

FOR EACH tt-supervisores:
    DELETE tt-supervisores.
END.

FOR EACH tt-geral:
    DELETE tt-geral.
END.

FOR EACH tt-quant-cc:
    DELETE tt-quant-cc.
END.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    RUN pi-carrega-dados.

    IF CAN-FIND(FIRST tt-verificar) THEN DO:
        PUT UNFORMATTED
            "Erro    Descricao                                                        " AT 01
            "------- -----------------------------------------------------------------" AT 01 SKIP.
        FOR EACH tt-verificar:
            PUT UNFORMATTED 
                 tt-verificar.cod-erro  AT 01
                 tt-verificar.desc-erro AT 09 SKIP.
        END.
        PUT UNFORMATTED SKIP(2).
    END.
    ELSE DO:
        RUN pi-gera-excel.
    END.

    PUT UNFORMATTED 
        SKIP
        "Per°odo:"            AT 01
        tt-param.periodo      AT 10
        "Diret¢rio:"          AT 01
        STRING(tt-param.diretorio) AT 12
        "Envia Email Supervisor:"        AT 01
        STRING(tt-param.envia-email,"Sim/N∆o") AT 25.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:

    RUN pi-inicializar in h-acomp (input "Carregando Informaá‰es...").

    ASSIGN i-erro = 0.

    /*IF INT(SUBSTRING(tt-param.periodo,5,2)) = 1 THEN 
        ASSIGN c-periodo-fim = STRING(INT(SUBSTRING(tt-param.periodo,1,4)) - 1,"9999") + "12"
               c-periodo-ini = STRING(INT(SUBSTRING(tt-param.periodo,1,4)) - 1,"9999") + "01".
    ELSE
        ASSIGN c-periodo-fim = STRING(INT(SUBSTRING(tt-param.periodo,1,4)),"9999")      + STRING(INT(SUBSTRING(tt-param.periodo,5,2)) - 1,"99")
               c-periodo-ini = STRING(INT(SUBSTRING(tt-param.periodo,1,4)) - 1,"9999")  + STRING(INT(SUBSTRING(tt-param.periodo,5,2)),"99").*/

    FIND FIRST equipamentos NO-LOCK NO-ERROR.

    IF tt-param.responsavel <> "" THEN DO:
        FOR EACH rateio-equipamentos
           WHERE rateio-equipamentos.tipo        = 0 /*telecomunicacao*/
             AND rateio-equipamentos.cod-estabel = "101"
             /*AND rateio-equipamentos.mes-ref >= c-periodo-ini
             AND rateio-equipamentos.mes-ref <= c-periodo-fim*/
             AND rateio-equipamentos.mes-ref = tt-param.periodo
             AND rateio-equipamentos.cc-codigo >= tt-param.cc-ini
             AND rateio-equipamentos.cc-codigo <= tt-param.cc-fim,
           FIRST int-centro-custo NO-LOCK
           WHERE int-centro-custo.cod-estabel    = rateio-equipamentos.cod-estabel
             AND int-centro-custo.cc-codigo      = rateio-equipamentos.cc-codigo
             AND int-centro-custo.cod-unid-negoc = rateio-equipamentos.cod-unid-negoc
             AND int-centro-custo.cod_usuario = tt-param.responsavel
            BREAK BY rateio-equipamentos.cod-estabel
                  BY rateio-equipamentos.cc-codigo
                  BY rateio-equipamentos.mes-ref:

            ASSIGN c-cc = IF rateio-equipamentos.cc-codigo = "" THEN rateio-equipamentos.ct-codigo ELSE rateio-equipamentos.cc-codigo.

            IF FIRST-OF(rateio-equipamentos.cod-estabel) OR FIRST-OF(rateio-equipamentos.cc-codigo) THEN DO:
                ASSIGN v-supervisor = int-centro-custo.cod_usuario
                       c-nome       = ""
                       c-email      = "".
                
                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
                IF NOT AVAIL usuar_mestre OR usuar_mestre.cod_e_mail_local = "" THEN DO:
                    ASSIGN i-erro = i-erro + 1.
                    CREATE tt-verificar.
                    ASSIGN tt-verificar.cod-erro  = i-erro
                           tt-verificar.desc-erro = "Supervisor: " + STRING(v-supervisor) + " n∆o possui email cadastrado, entre em contato com Departamento TI.".
                END.
                ELSE ASSIGN c-email = usuar_mestre.cod_e_mail_local
                            c-nome = usuar_mestre.nom_usuario.

                FIND FIRST tt-supervisores NO-LOCK
                     WHERE tt-supervisores.supervisor = v-supervisor NO-ERROR.
                IF NOT AVAIL tt-supervisores THEN DO:
                    CREATE tt-supervisores.
                    ASSIGN tt-supervisores.supervisor = v-supervisor
                           tt-supervisores.nome       = c-nome
                           tt-supervisores.email      = c-email.
                END.
            END.

            IF tt-param.responsavel <> "" AND tt-param.responsavel <> v-supervisor THEN NEXT.

            CREATE tt-rateios.
            ASSIGN tt-rateios.equipamento = rateio-equipamentos.equipamento
                   tt-rateios.supervisor  = v-supervisor
                   tt-rateios.cc-codigo   = c-cc                           
                   tt-rateios.mes-ref     = rateio-equipamentos.mes-ref
                   tt-rateios.val-rateio  = rateio-equipamentos.val-rateio.

            IF NOT AVAIL equipamentos OR equipamentos.equipamento <> rateio-equipamentos.equipamento THEN
                FIND FIRST equipamentos NO-LOCK
                     WHERE equipamentos.equipamento = rateio-equipamentos.equipamento NO-ERROR.
            IF AVAIL equipamentos THEN
                ASSIGN tt-rateios.nome-equipamento = equipamentos.descricao.
            ELSE
                ASSIGN tt-rateios.nome-equipamento = rateio-equipamentos.equipamento.

            FIND FIRST tt-geral NO-LOCK
                 WHERE tt-geral.supervisor = v-supervisor 
                   AND tt-geral.mes-ref    = rateio-equipamentos.mes-ref NO-ERROR.
            IF NOT AVAIL tt-geral THEN DO:
                CREATE tt-geral.
                ASSIGN tt-geral.supervisor = v-supervisor
                       tt-geral.mes-ref    = rateio-equipamentos.mes-ref.
            END.
            ASSIGN tt-geral.valor = tt-geral.valor + rateio-equipamentos.val-rateio.
        END.
    END.
    ELSE DO:
        FOR EACH rateio-equipamentos
           WHERE rateio-equipamentos.tipo         = 0 /*telecomunicacao*/
             AND rateio-equipamentos.cod-estabel = "101"
             /*AND rateio-equipamentos.mes-ref >= c-periodo-ini
             AND rateio-equipamentos.mes-ref <= c-periodo-fim*/
             AND rateio-equipamentos.mes-ref = tt-param.periodo
             AND rateio-equipamentos.cc-codigo >= tt-param.cc-ini
             AND rateio-equipamentos.cc-codigo <= tt-param.cc-fim
            BREAK BY rateio-equipamentos.cod-estabel
                  BY rateio-equipamentos.cc-codigo
                  BY rateio-equipamentos.mes-ref:

            ASSIGN c-cc = IF rateio-equipamentos.cc-codigo = "" THEN rateio-equipamentos.ct-codigo ELSE rateio-equipamentos.cc-codigo.

            IF FIRST-OF(rateio-equipamentos.cod-estabel) OR FIRST-OF(rateio-equipamentos.cc-codigo) THEN DO:
                ASSIGN v-supervisor = ""
                       c-nome       = ""
                       c-email      = "".

                IF rateio-equipamentos.cc-codigo <> "" THEN DO:
                    FIND FIRST int-centro-custo NO-LOCK
                         WHERE int-centro-custo.cod-estabel = rateio-equipamentos.cod-estabel
                           AND int-centro-custo.cc-codigo  = rateio-equipamentos.cc-codigo NO-ERROR.
                    IF NOT AVAIL int-centro-custo THEN DO:
                        ASSIGN i-erro = i-erro + 1.
                        CREATE tt-verificar.
                        ASSIGN tt-verificar.cod-erro  = i-erro
                               tt-verificar.desc-erro = "Supervisor n∆o cadastrado para CC.: " + STRING(rateio-equipamentos.cc-codigo) + 
                                                        " - Estab.:" + STRING(rateio-equipamentos.cod-estabel) + 
                                                        " - Periodo: " + STRING(rateio-equipamentos.mes-ref).
                    END.
                    ELSE DO:
                        ASSIGN v-supervisor = int-centro-custo.cod_usuario.
                        
                        FIND FIRST usuar_mestre NO-LOCK
                             WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.

                        IF NOT AVAIL usuar_mestre OR usuar_mestre.cod_e_mail_local = "" THEN DO:
                            ASSIGN i-erro = i-erro + 1.
                            CREATE tt-verificar.
                            ASSIGN tt-verificar.cod-erro  = i-erro
                                   tt-verificar.desc-erro = "Supervisor: " + STRING(v-supervisor) + " n∆o possui email cadastrado, entre em contato com Departamento TI.".
                        END.
                        ELSE ASSIGN c-email = usuar_mestre.cod_e_mail_local
                                    c-nome = usuar_mestre.nom_usuario.
                    END.
                END.

                FIND FIRST tt-supervisores NO-LOCK
                     WHERE tt-supervisores.supervisor = v-supervisor NO-ERROR.
                IF NOT AVAIL tt-supervisores THEN DO:
                    CREATE tt-supervisores.
                    ASSIGN tt-supervisores.supervisor = v-supervisor
                           tt-supervisores.nome       = c-nome
                           tt-supervisores.email      = c-email.
                END.
            END.

            IF tt-param.responsavel <> "" AND tt-param.responsavel <> v-supervisor THEN NEXT.

            CREATE tt-rateios.
            ASSIGN tt-rateios.equipamento = rateio-equipamentos.equipamento
                   tt-rateios.supervisor  = v-supervisor
                   tt-rateios.cc-codigo   = c-cc                           
                   tt-rateios.mes-ref     = rateio-equipamentos.mes-ref
                   tt-rateios.val-rateio  = rateio-equipamentos.val-rateio.

            IF NOT AVAIL equipamentos OR equipamentos.equipamento <> rateio-equipamentos.equipamento THEN
                FIND FIRST equipamentos NO-LOCK
                     WHERE equipamentos.equipamento = rateio-equipamentos.equipamento NO-ERROR.
            IF AVAIL equipamentos THEN
                ASSIGN tt-rateios.nome-equipamento = equipamentos.descricao.
            ELSE
                ASSIGN tt-rateios.nome-equipamento = rateio-equipamentos.equipamento.

            FIND FIRST tt-geral NO-LOCK
                 WHERE tt-geral.supervisor = v-supervisor 
                   AND tt-geral.mes-ref    = rateio-equipamentos.mes-ref NO-ERROR.
            IF NOT AVAIL tt-geral THEN DO:
                CREATE tt-geral.
                ASSIGN tt-geral.supervisor = v-supervisor
                       tt-geral.mes-ref    = rateio-equipamentos.mes-ref.
            END.
            ASSIGN tt-geral.valor = tt-geral.valor + rateio-equipamentos.val-rateio.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-gera-excel:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Excel...").

    /*
    CREATE "Excel.Application" chExcel2 CONNECT NO-ERROR.

    IF ERROR-STATUS:ERROR THEN */
        CREATE "Excel.Application":U chExcel2.

    FOR EACH tt-supervisores BREAK BY tt-supervisores.nome:

        ASSIGN chExcel2:ScreenUpdating = YES
               chExcel2:VISIBLE        = NO.

        assign /*chExcel2:SheetsInNewWorkbook = 1*/
               chWBook2 = chExcel2:WorkBooks:Add().

        assign chWSheet2                            = chWBook2:Sheets:Item(1)
               chWBook2:Windows(1):DisplayGridLines = YES.

        chWSheet2:Activate().

        run pi-acompanhar in h-acomp (INPUT "Supervisor: " + tt-supervisores.nome).

        RUN pi-imprime-rateios.

        IF VALID-HANDLE(chWSheet2) THEN DO:
            RELEASE OBJECT chWSheet2.
            ASSIGN chWSheet2 = ?.
        END.

        ASSIGN chWSheet2 = chWBook2:Sheets:Item(1) NO-ERROR.

        chWSheet2:Activate().

        chWSheet2:Range("A1"):SELECT.

        ASSIGN c-dir-nome-arq = tt-param.diretorio + "comunicacoes-" + tt-param.periodo + "-" + STRING(tt-supervisores.supervisor) + ".xlsx".
        chWBook2:SaveCopyAs(c-dir-nome-arq).
        chWBook2:close(false).


        IF VALID-HANDLE(chWSheet2) THEN DO:
            RELEASE OBJECT chWSheet2.
            ASSIGN chWSheet2 = ?.
        END.


        IF VALID-HANDLE(chWBook2) THEN DO:
            RELEASE OBJECT chWBook2.
            ASSIGN chWBook2 = ?.
        END.

        IF tt-supervisores.supervisor <> ""  AND tt-param.envia-email THEN
            RUN pi-envia-email.
    END.

    IF VALID-HANDLE(chExcel2) THEN DO:
        RELEASE OBJECT chExcel2.
        ASSIGN chExcel2 = ?.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-rateios:

    ASSIGN i-quant = 1.

    FOR EACH tt-rateios 
       WHERE tt-rateios.supervisor = tt-supervisores.supervisor 
         AND tt-rateios.mes-ref    = tt-param.periodo
       BREAK BY tt-rateios.cc-codigo:

        IF FIRST-OF(tt-rateios.cc-codigo) THEN
            ASSIGN i-quant  = i-quant + 1.
    END.

    /*Criando pastas para centro de custo*/
    DO i-cont = 2 TO i-quant: 

        IF VALID-HANDLE(chWSheet2) THEN DO:
            RELEASE OBJECT chWSheet2.
            ASSIGN chWSheet2 = ?.
        END.

        ASSIGN chWSheet2 = chWBook2:Sheets:Item(i-cont) NO-ERROR.
        IF NOT VALID-HANDLE(chWSheet2) THEN DO:
            /*chWSheet2 = chExcel2:sheets:ADD().*/

            chWBook2:Sheets:ADD(,chWBook2:Sheets:Item(i-cont - 1)).

            IF VALID-HANDLE(chWSheet2) THEN DO:
                RELEASE OBJECT chWSheet2.
                ASSIGN chWSheet2 = ?.
            END.

            ASSIGN chWSheet2      = chWBook2:Sheets:Item(i-cont).
            /*chPlanilha:Name = "Dados" + STRING(p-Sheet).*/

            /*ASSIGN chWSheet2 = chWBook2:Sheets:Item(i-cont) NO-ERROR.*/
        END.
    END.

    /*Gera impress∆o da pasta geral*/
    RUN pi-imprime-geral.

    /*Gera impress∆o das pasta centro custo*/
    RUN pi-imprime-centrocusto.

END PROCEDURE.

PROCEDURE pi-imprime-geral:

    ASSIGN i-cont = 1
           i-linha-aux = 0.

    IF VALID-HANDLE(chWSheet2) THEN DO:
        RELEASE OBJECT chWSheet2.
        ASSIGN chWSheet2 = ?.
    END.

    ASSIGN chWSheet2 = chWBook2:Sheets:Item(i-cont) NO-ERROR.
    ASSIGN i-linha = 3
           chWSheet2:Name                     = "Geral"
           /*chWSheet2:Cells(i-linha, 5 ):Value = "Comparativo"
           chWSheet2:Range("E" + STRING(i-linha) + ":F" + STRING(i-linha)):FONT:Bold = TRUE
           i-linha = i-linha + 1
           chWSheet2:Cells(i-linha, 5 ):Value = "Per°odo"
           chWSheet2:Cells(i-linha, 6 ):Value = "Valor"
           chWSheet2:Range("E" + STRING(i-linha) + ":F" + STRING(i-linha)):FONT:Bold = TRUE
           i-linha = i-linha + 1*/ .

    /*ASSIGN de-total = 0.
    FOR EACH tt-geral NO-LOCK
       WHERE tt-geral.supervisor = tt-supervisores.supervisor
        BY tt-geral.mes-ref:

        ASSIGN de-total = de-total + tt-geral.valor 
               chWSheet2:Cells(i-linha, 5 ):numberFormat = "@"
               chWSheet2:Cells(i-linha, 5 ):Value = tt-geral.mes-ref
               chWSheet2:Cells(i-linha, 6 ):Value = tt-geral.valor
               chWSheet2:Cells(i-linha, 6 ):NumberFormat = "#.##0,00"
               i-linha = i-linha + 1.
    END.
    ASSIGN i-linha-aux = i-linha - 1
           chWSheet2:Cells(i-linha, 5 ):Value = "Total"
           chWSheet2:Cells(i-linha, 6 ):Value = de-total
           chWSheet2:Cells(i-linha, 6 ):NumberFormat = "#.##0,00"
           chWSheet2:Range("E" + STRING(i-linha) + ":F" + STRING(i-linha)):FONT:Bold = TRUE.*/

    ASSIGN i-linha = 1
           chWSheet2:Cells(i-linha, 1 ):Value = "Respons†vel: " + tt-supervisores.nome
           chWSheet2:Cells(i-linha, 1 ):FONT:Bold = TRUE.
    chWSheet2:Range("A" + STRING(i-linha) + ":E" + STRING(i-linha)):Merge.
    ASSIGN i-linha = i-linha + 2
           chWSheet2:Cells(i-linha, 1 ):Value = "Per°odo: " + tt-rateios.mes-ref
           chWSheet2:Cells(i-linha, 1 ):FONT:Bold = TRUE.
    chWSheet2:Range("A" + STRING(i-linha) + ":C" + STRING(i-linha)):Merge.
    ASSIGN i-linha = i-linha + 1
           chWSheet2:Cells(i-linha, 1 ):Value = "Centro Custo"
           chWSheet2:Cells(i-linha, 2 ):Value = "Descriá∆o"
           chWSheet2:Cells(i-linha, 3 ):Value = "Valor"
           chWSheet2:Range("A" + STRING(i-linha) + ":C" + STRING(i-linha)):FONT:Bold = TRUE
           i-linha = i-linha + 1.

    ASSIGN de-total = 0.
    FOR EACH tt-rateios 
       WHERE tt-rateios.supervisor = tt-supervisores.supervisor 
         AND tt-rateios.mes-ref    = tt-param.periodo
       BREAK BY tt-rateios.cc-codigo:
        
        IF FIRST-OF(tt-rateios.cc-codigo) THEN
            ASSIGN de-valor = 0.

        ASSIGN de-valor = de-valor + tt-rateios.val-rateio
               de-total = de-total + tt-rateios.val-rateio.
        
        IF LAST-OF(tt-rateios.cc-codigo) THEN DO:

            run prgint\utb\utb742za.py persistent set h_api_ccusto.

            EMPTY TEMP-TABLE tt_log_erro.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,  /* EMPRESA EMS2 */
                                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                       input  tt-rateios.cc-codigo, /* CCUSTO */
                                                       input  today,                /* DATA DE TRANSACAO */
                                                       output v_des_titulo_ccusto,  /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */
            delete object h_api_ccusto.

            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.

            IF  NOT AVAIL tt_log_erro
            THEN
                ASSIGN c-descricao = v_des_titulo_ccusto.
            ELSE
                ASSIGN c-descricao = tt_log_erro.ttv_des_msg_erro.

            ASSIGN chWSheet2:Cells(i-linha, 1 ):numberFormat = "@"
                   chWSheet2:Cells(i-linha, 1 ):Value = tt-rateios.cc-codigo
                   chWSheet2:Cells(i-linha, 2 ):Value = c-descricao
                   chWSheet2:Cells(i-linha, 3 ):Value = de-valor
                   chWSheet2:Cells(i-linha, 3 ):NumberFormat = "#.##0,00"
                   de-valor = 0
                   i-linha = i-linha + 1.
        END.
    END.
    ASSIGN chWSheet2:Cells(i-linha, 2 ):Value = "Total"
           chWSheet2:Cells(i-linha, 3 ):Value = de-total
           chWSheet2:Cells(i-linha, 3 ):NumberFormat = "#.##0,00"
           chWSheet2:Range("B" + STRING(i-linha) + ":C" + STRING(i-linha)):FONT:Bold = TRUE.
    chWSheet2:Range("A1:F" + STRING(i-linha)):Columns:AutoFit.

    /*Gera grafico do periodo*/
    RUN pi-grafico-periodo.

    /*/*Gera grafico comparativo*/
    RUN pi-grafico-comparativo.*/

END PROCEDURE.

PROCEDURE pi-imprime-centrocusto:

    ASSIGN i-cont = 1.

    FOR EACH tt-rateios 
       WHERE tt-rateios.supervisor = tt-supervisores.supervisor 
         AND tt-rateios.mes-ref    = tt-param.periodo
       BREAK BY tt-rateios.cc-codigo
             BY tt-rateios.equipamento:

        IF FIRST-OF(tt-rateios.cc-codigo) THEN DO:

            run prgint\utb\utb742za.py persistent set h_api_ccusto.

            EMPTY TEMP-TABLE tt_log_erro.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,  /* EMPRESA EMS2 */
                                                       input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                       input  tt-rateios.cc-codigo, /* CCUSTO */
                                                       input  today,                /* DATA DE TRANSACAO */
                                                       output v_des_titulo_ccusto,  /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */
            delete object h_api_ccusto.

            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.

            IF  NOT AVAIL tt_log_erro
            THEN
                ASSIGN c-descricao = v_des_titulo_ccusto.
            ELSE
                ASSIGN c-descricao = tt_log_erro.ttv_des_msg_erro.

            ASSIGN i-cont = i-cont + 1.

            IF VALID-HANDLE(chWSheet2) THEN DO:
                RELEASE OBJECT chWSheet2.
                ASSIGN chWSheet2 = ?.
            END.

            ASSIGN chWSheet2 = chWBook2:Sheets:Item(i-cont) NO-ERROR.

            chWSheet2:Activate().

            ASSIGN de-total = 0
                   i-linha  = 1
                   chWSheet2:Name                     = STRING(tt-rateios.cc-codigo)
                   chWSheet2:Cells(i-linha, 1 ):Value = "Per°odo: " + tt-rateios.mes-ref
                   chWSheet2:Range("A" + STRING(i-linha) + ":D" + STRING(i-linha)):FONT:Bold = TRUE.
            chWSheet2:Range("A" + STRING(i-linha) + ":D" + STRING(i-linha)):Merge.
            ASSIGN i-linha = i-linha + 1
                   chWSheet2:Cells(i-linha, 1 ):Value = "Centro Custo: " + tt-rateios.cc-codigo + " - " + c-descricao
                   chWSheet2:Range("A" + STRING(i-linha) + ":G" + STRING(i-linha)):FONT:Bold = TRUE.
            chWSheet2:Range("A" + STRING(i-linha) + ":G" + STRING(i-linha)):Merge.
            ASSIGN i-linha = i-linha + 2
                   chWSheet2:Cells(i-linha, 1 ):Value = "Equipamento"
                   chWSheet2:Cells(i-linha, 2 ):Value = "Nome"
                   chWSheet2:Cells(i-linha, 3 ):Value = "Valor"
                   chWSheet2:Range("A" + STRING(i-linha) + ":C" + STRING(i-linha)):FONT:Bold = TRUE
                   i-linha = i-linha + 1.
        END.
        
        ASSIGN de-total = de-total + tt-rateios.val-rateio
               chWSheet2:Cells(i-linha, 1 ):numberFormat = "@"
               chWSheet2:Cells(i-linha, 1 ):Value = tt-rateios.equipamento
               chWSheet2:Cells(i-linha, 2 ):numberFormat = "@"
               chWSheet2:Cells(i-linha, 2 ):Value = tt-rateios.nome-equipamento
               chWSheet2:Cells(i-linha, 3 ):Value = tt-rateios.val-rateio
               chWSheet2:Cells(i-linha, 3 ):NumberFormat = "#.##0,00"
               i-linha = i-linha + 1.

        IF LAST-OF(tt-rateios.cc-codigo) THEN DO:
            ASSIGN chWSheet2:Cells(i-linha, 2 ):Value = "Total"
                   chWSheet2:Cells(i-linha, 3 ):Value = de-total
                   chWSheet2:Cells(i-linha, 3 ):NumberFormat = "#.##0,00"
                   chWSheet2:Range("A" + STRING(i-linha) + ":C" + STRING(i-linha)):FONT:Bold = TRUE.
            chWSheet2:Range("A1:D" + STRING(i-linha)):Columns:AutoFit.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-grafico-periodo:

    chWSheet2:Activate().

    ASSIGN c-selecao-graf = "B5:C" + STRING(i-linha - 1).
    chWSheet2:Range(c-selecao-graf):SELECT.

    chWSheet2:ChartObjects:Add(420,10,500,300):Activate(). 

    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range(c-selecao-graf), 3, 1, 2, 1, 1, TRUE, "Per°odo " + STRING(tt-param.periodo) , "" , ""). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range(c-selecao-graf), 1).
    
    chExcel2:ActiveChart:ChartTitle:Font:Size = 12.
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = TRUE.
    chExcel2:ActiveChart:RightAngleAxes = TRUE.


    chExcel2:ActiveChart:SeriesCollection(1):XValues = "=~{~" ~"~}".
END PROCEDURE.

/*PROCEDURE pi-grafico-comparativo:

    chWSheet2:Activate().
    ASSIGN c-selecao-graf = "E5:F" + STRING(i-linha-aux).
    chWSheet2:Range(c-selecao-graf):SELECT.
    chWSheet2:ChartObjects:Add(420,315,500,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range(c-selecao-graf), 3, 1, 2, 1, 1, TRUE, "Comparativo" , "" , ""). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range(c-selecao-graf), 1).
    
    chExcel2:ActiveChart:ChartTitle:Font:Size = 12.
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = 4.
    chExcel2:ActiveChart:HasLegend = TRUE.
    chExcel2:ActiveChart:RightAngleAxes = TRUE.

    chExcel2:ActiveChart:SeriesCollection(1):XValues = "=~{~" ~"~}".
END PROCEDURE.*/

PROCEDURE pi-envia-email:

    PUT UNFORMATTED 
        "Enviando email para: " + STRING(tt-supervisores.email) FORMAT "x(80)" AT 01 SKIP.
    
    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    FIND FIRST param-global NO-LOCK.

    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.porta             = param-global.porta-mail
           tt-envio.servidor          = param-global.serv-mail 
           tt-envio.destino           = tt-supervisores.email
           tt-envio.remetente         = "ems@intelbras.com.br"
           tt-envio.assunto           = "Relat¢rio Comunicaá‰es " + tt-param.periodo
           tt-envio.mensagem          = "Ol†, tudo bem ?" + CHR(10) + CHR(10) + "Segue anexo o relat¢rio de comunicaá∆o dos equipamentos de telefonia vinculados ao seu centro de custo. Para d£vidas ou verificaá‰es entre em contato com Eduarda Camilo ou Manuela Assis." + CHR(10) +
                                        "Para alteraá‰es abra um chamado no portal da TI em: http://helpdesk.intelbras.com.br" + CHR(10) + CHR(10) + 
                                        "Agradecemos e ficamos † disposiá∆o !"
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = no.
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
