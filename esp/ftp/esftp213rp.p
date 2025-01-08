{include/i-prgvrs.i esftp213rp 2.00.00.001}
{esp/es0018.i}

DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE dt-ini        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim        AS DATE        NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHAR.

DEFINE TEMP-TABLE tt-ok NO-UNDO
    FIELD mensagem AS CHAR.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR emscad.empresa.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-canal-ini    AS INT
    FIELD cod-canal-fim    AS INT
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD periodo-ini      AS CHAR
    FIELD periodo-fim      AS CHAR
    FIELD import-del       AS INT
    FIELD arquivo-entrada  AS CHAR
    FIELD dt-ini-meta      AS DATE
    FIELD dt-fim-meta      AS DATE . 
   

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR qtd-dispon LIKE preco-item.quant-min.
DEF VAR l-central-config AS LOG NO-UNDO.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp124_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        /*
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).*/

        ASSIGN c-arq-excel = SESSION:TEMP-DIRECTORY + "esftp213.csv" .
        
    END.
END.

FUNCTION getMes RETURNS INT ( pDesMes AS CHAR ) FORWARD.

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    IF tt-param.import-del = 1 THEN
        RUN pi-importa.
    ELSE 
        RUN pi-deleta.

    
    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        PUT STREAM str-excel UNFORMATTED "Erros" SKIP.

        FOR EACH tt-erro:
            PUT STREAM str-excel UNFORMATTED tt-erro.mensagem SKIP.
        END.
    END.

    IF CAN-FIND (FIRST tt-ok) THEN DO:
        PUT STREAM str-excel UNFORMATTED "Processados" SKIP.
        FOR EACH tt-ok:
            PUT STREAM str-excel UNFORMATTED tt-ok.mensagem SKIP.
        END.
    END.
    
    OUTPUT STREAM str-excel CLOSE.
    
    RUN pi-finalizar IN h-acomp.

    
    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-importa:
    DEFINE VARIABLE c-linha             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-periodo           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c_it-codigo         LIKE ITEM.it-codigo         NO-UNDO.
    DEFINE VARIABLE c_desc-grp-canais   LIKE grupo-canais.descricao NO-UNDO.
    DEFINE VARIABLE dt-ini-meta         AS DATE                     NO-UNDO.
    DEFINE VARIABLE dt-fim-meta         AS DATE                     NO-UNDO.
    DEFINE VARIABLE dt-entrega-item     AS DATE                     NO-UNDO.
    DEFINE VARIABLE qtd-meta            AS DEC                      NO-UNDO.
    DEFINE VARIABLE dt-ini-periodo      AS DATE                     NO-UNDO.
    DEFINE VARIABLE l-first             AS LOGICAL                  NO-UNDO.

    INPUT FROM VALUE (tt-param.arquivo-entrada) NO-CONVERT.

    ASSIGN l-first = YES.

    REPEAT:
        IMPORT UNFORMATTED c-linha.

        /*IF l-first THEN DO:
            ASSIGN l-first = NO.
            NEXT.
        END.*/

        ASSIGN dt-ini-meta       = DATE(ENTRY(1, c-linha, ";"))
               dt-fim-meta       = DATE(ENTRY(2, c-linha, ";"))
               c_desc-grp-canais = STRING(ENTRY(3, c-linha, ";"))
               c_it-codigo       = ENTRY(4, c-linha, ";")
               qtd-meta          = DEC(ENTRY(5, c-linha, ";"))
               dt-entrega-item   = DATE(ENTRY(6, c-linha, ";")) .
    /*
        MESSAGE "dt-ini-meta       " dt-ini-meta        skip
                "dt-fim-meta       " dt-fim-meta        skip
                "c_desc-grp-canais " c_desc-grp-canais  skip
                "c_it-codigo       " c_it-codigo        skip
                "qtd-meta          " qtd-meta           skip
                "dt-entrega-item   " dt-entrega-item    skip
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

        RETURN.
            */

              /* c-periodo = ENTRY(1, c-linha, ";")
               i-mes     = getMes(ENTRY(1,c-periodo,"/"))
               i-ano     = INT(ENTRY(2,c-periodo,"/")) + 2000.*/

        /*RUN pi-acompanhar IN h-acomp (INPUT "Importando " + STRING(i-mes,"99") + "/" + STRING(i-ano) + " Item: " + ENTRY(3, c-linha, ";")).*/

        FIND FIRST grupo-canais NO-LOCK
             WHERE grupo-canais.descricao = c_desc-grp-canais NO-ERROR.

        IF NOT AVAIL grupo-canais THEN DO:
            RUN pi-erro (INPUT "Grupo de Canais '" + c_desc-grp-canais + "' nÆo encontrado").
            NEXT.
        END.
        
        IF tt-param.cod-canal-ini > grupo-canais.cod-gr-canais
        OR tt-param.cod-canal-fim < grupo-canais.cod-gr-canais
        OR tt-param.it-codigo-ini > c_it-codigo
        OR tt-param.it-codigo-fim < c_it-codigo THEN NEXT .
        /*
        OR tt-param.periodo-ini   > STRING(i-mes,"99") + STRING(i-ano)
        OR tt-param.periodo-fim   < STRING(i-mes,"99") + STRING(i-ano)*/
             
           

        RUN pi-acompanhar IN h-acomp (INPUT "Importando: Dat Ini Meta: " + STRING(dt-ini-meta) + "Dat Fim Meta: " + STRING(dt-fim-meta) + " Item: " + ENTRY(3, c-linha, ";") + "Grupo :" + grupo-canais.descricao).

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = c_it-codigo NO-ERROR.

        IF NOT AVAIL ITEM THEN DO:
            RUN pi-erro (INPUT "Item '" + c_it-codigo + "' nÆo encontrado").
            NEXT.
        END.

        FIND FIRST int-pv-canal EXCLUSIVE-LOCK
             WHERE int-pv-canal.cod-canal = grupo-canais.cod-gr-canais
               AND int-pv-canal.it-codigo = c_it-codigo
               AND int-pv-canal.dt-ini-meta = dt-ini-meta
               AND int-pv-canal.dt-fim-meta = dt-fim-meta NO-ERROR.
        IF NOT AVAIL int-pv-canal THEN DO:
            CREATE int-pv-canal.
            ASSIGN int-pv-canal.cod-canal   = grupo-canais.cod-gr-canais   
                   int-pv-canal.it-codigo   = c_it-codigo       
                   int-pv-canal.dt-ini-meta = dt-ini-meta 
                   int-pv-canal.dt-fim-meta = dt-fim-meta .
        END.

        /*Grava entrega com primeiro dia do mˆs seguinte*/
        ASSIGN dt-ini-periodo               = dt-ini-meta
               int-pv-canal.dt-entrega-item = dt-entrega-item
               int-pv-canal.qt-meta         = qtd-meta.

        /*Zera totais e inicial datas para totalizar*/
        ASSIGN dt-ini = dt-ini-periodo
               dt-fim = dt-fim-meta
               int-pv-canal.qt-faturada = 0
               int-pv-canal.qt-carteira = 0.

        RUN pi-totaliza.

        CREATE tt-ok.
        ASSIGN tt-ok.mensagem = "PrevisÆo importada. Item: " + int-pv-canal.it-codigo + " Per¡odo: Data Ini: " + string(int-pv-canal.dt-ini-meta) + " Data Fim: " + string(int-pv-canal.dt-fim-meta)  + " Canal: " + string(int-pv-canal.cod-canal).
    END.

    INPUT CLOSE.
END PROCEDURE.

FUNCTION getMes RETURNS INT ( pDesMes AS CHAR ) :

    IF pDesMes = "Jan" THEN
        RETURN 1.
    ELSE IF pDesMes = "Fev" THEN
        RETURN 2.
    ELSE IF pDesMes = "Mar" THEN
        RETURN 3.
    ELSE IF pDesMes = "Abr" THEN
        RETURN 4.
    ELSE IF pDesMes = "Mai" THEN
        RETURN 5.
    ELSE IF pDesMes = "Jun" THEN
        RETURN 6.
    ELSE IF pDesMes = "Jul" THEN
        RETURN 7.
    ELSE IF pDesMes = "Ago" THEN
        RETURN 8.
    ELSE IF pDesMes = "Set" THEN
        RETURN 9.
    ELSE IF pDesMes = "Out" THEN
        RETURN 10.
    ELSE IF pDesMes = "Nov" THEN
        RETURN 11.
    ELSE IF pDesMes = "Dez" THEN
        RETURN 12.

END FUNCTION.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM p-erro AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = p-erro.
END PROCEDURE.

PROCEDURE pi-totaliza:
    DEFINE VARIABLE dt-aux   AS DATE        NO-UNDO.
    DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.
        
    DO dt-aux = dt-ini TO dt-fim:

        /*Totaliza Faturado*/
        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.it-codigo    = int-pv-canal.it-codigo
             AND it-nota-fisc.dt-emis-nota = dt-aux,
           FIRST nota-fiscal OF it-nota-fisc 
           WHERE nota-fiscal.idi-sit-nf-eletro = 3 NO-LOCK:

            IF nota-fiscal.emite-duplic = NO THEN 
                NEXT.
    
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli
                   AND ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.
            
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.
            
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
            
            IF AVAIL int-ped-venda2 THEN DO:
               ASSIGN de-total = de-total +  it-nota-fisc.qt-faturada[1].
            END.
        END.
       
        /* devolu‡äes */
        FOR EACH devol-cli
           WHERE devol-cli.dt-devol        = dt-aux
             AND devol-cli.it-codigo       = int-pv-canal.it-codigo,
           FIRST nota-fiscal        
           WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
             AND nota-fiscal.serie         = devol-cli.serie
             AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
             AND nota-fiscal.emite-duplic,
            EACH item-doc-est FIELDS OF devol-cli NO-LOCK:
    
            FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK 
                 WHERE it-nota-fisc.it-codigo  = item-doc-est.it-codigo 
                   AND it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp NO-ERROR.

            IF AVAIL it-nota-fisc THEN
               FIND FIRST ped-venda NO-LOCK 
                    WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                      AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
             
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
    
            IF NOT AVAIL int-ped-venda2 THEN  
                NEXT.

            ASSIGN de-total = de-total + (item-doc-est.quantidade * -1).
        END.

        ASSIGN int-pv-canal.qt-faturada = de-total.

        /*Totaliza Carteira*/
        FOR EACH ped-item NO-LOCK
           WHERE ped-item.it-codigo     = int-pv-canal.it-codigo
             AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) 
             AND ped-item.dt-entrega    = dt-aux,
           FIRST ped-venda OF ped-item NO-LOCK,
           FIRST int-ped-venda2 
           WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido 
             AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-LOCK:

            /*considerar somente os pedidos que geram titulo*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            IF NOT natur-oper.emite-duplic THEN
                NEXT.

            IF ped-venda.cod-priori = 44 /* or‡amento */ THEN 
                NEXT.
            
            ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
        END.
    END.
END PROCEDURE.

PROCEDURE pi-deleta:
    //IDBA BRUNO JOAQUIM -> C2406-0988 ajustar tela esftp213 na opcao exclusao para ler data e nao mes fechado
    //DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.

    FOR EACH int-pv-canal EXCLUSIVE-LOCK
       WHERE int-pv-canal.cod-canal   >= tt-param.cod-canal-ini
         AND int-pv-canal.cod-canal   <= tt-param.cod-canal-fim
         AND int-pv-canal.it-codigo   >= tt-param.it-codigo-ini
         AND int-pv-canal.it-codigo   <= tt-param.it-codigo-fim
         AND int-pv-canal.dt-ini-meta = tt-param.dt-ini-meta
         AND int-pv-canal.dt-fim-meta = tt-param.dt-fim-meta:

        //ASSIGN c-periodo = string(int-pv-canal.mes-meta,"99") + string(int-pv-canal.ano-meta).
        /*
        IF c-periodo < tt-param.periodo-ini
        OR c-periodo > tt-param.periodo-fim THEN
            NEXT.*/

        CREATE tt-ok.
        ASSIGN tt-ok.mensagem = "PrevisÆo exclu¡da. Item: " + int-pv-canal.it-codigo + " Per¡odo: " + string(int-pv-canal.dt-ini-meta) + " > " + STRING(int-pv-canal.dt-fim-meta) + " Canal: " + string(int-pv-canal.cod-canal).
        
        DELETE int-pv-canal.

    END.

END PROCEDURE.
