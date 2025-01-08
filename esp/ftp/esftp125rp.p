/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/ftp/esftp125rp.p
**  Objetivo.: 
**  Cria‡Æo..: 
**
*******************************************************************************/
{include/i-prgvrs.i ESFTP125 2.00.00.000}
{utp/ut-glob.i}
{esp/es0018.i}
{esp/imp/esimp000.i1} /*tt-emb*/

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    field item-ini         AS CHAR
    field item-fim         AS CHAR
    field data-ini         AS CHAR
    field data-fim         AS CHAR
    field l-pos            AS LOG
    field l-inv            AS LOG
    field tipo             AS INTEGER
    FIELD i-diario         AS INT /* 1-Diario 2-Semanal */
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define temp-table tt-imprime NO-UNDO
    field it-codigo                     AS CHAR
    field descricao-1                   AS CHAR
    field estado                        AS CHAR 
    field aliquota-icm                  AS DEC
    field log-descons-para-nao-contribt AS CHAR
    field cod-mensagem                  AS INT.

DEFINE TEMP-TABLE tt-arquivo-vendas NO-UNDO
    FIELD Id-WD-SD        AS CHAR    
    FIELD regID           AS INT
    FIELD DistributorName AS CHAR    
    FIELD CustomerName    LIKE emitente.nome-emit FORMAT "x(60)"      
    FIELD CustomerID      LIKE nota-fiscal.cod-emitente 
    FIELD CustomerAddress LIKE nota-fiscal.endereco FORMAT "x(55)"       
    FIELD CustomerCity    LIKE nota-fiscal.cidade       
    FIELD CustomerState   LIKE nota-fiscal.estado       
    FIELD CustomerCountry LIKE nota-fiscal.pais         
    FIELD CustomerCep     LIKE nota-fiscal.cep         
    FIELD ContactPerson   LIKE emitente.nome-abrev 
    FIELD ContactEmail    LIKE emitente.e-mail
    FIELD ProductDesc     LIKE ITEM.desc-item
    FIELD PartNumber      AS CHAR
    FIELD BuyerPartNumber AS CHAR
    FIELD Invoice         LIKE nota-fiscal.nr-nota-fis
    FIELD InvoiceDate     AS CHAR
    FIELD InvoiceDateShip AS CHAR
    FIELD ProductQt       AS DEC
    FIELD vlProduct       AS DEC
    FIELD SerialNumber    AS CHAR
    FIELD nat-operacao     LIKE it-nota-fisc.nat-operacao
    FIELD denominacao      LIKE natur-oper.denomina‡Æo.

DEFINE TEMP-TABLE tt-arquivo-inventario NO-UNDO
        FIELD Id-WD-SD        AS CHAR  
        FIELD regID      AS INT
        FIELD codEstabel       LIKE estabelec.cod-estabel
        FIELD WarehouseName AS CHAR    
        FIELD WarehouseAddress LIKE estabelec.endereco
        FIELD WarehouseCity    LIKE estabelec.cidade  
        FIELD WarehouseState   LIKE estabelec.estado  
        FIELD WarehouseCountry LIKE estabelec.pais    
        FIELD WarehouseCep     LIKE estabelec.cep
        FIELD ProductDesc      LIKE ITEM.desc-item
        FIELD PartNumber       AS CHAR
        FIELD BuyerPartNumber  AS CHAR
        FIELD ProductQtInv     LIKE it-nota-fisc.qt-faturada[1]
        FIELD ProductQtRMA     LIKE it-nota-fisc.qt-faturada[1]
        FIELD ProductQtTransit LIKE it-nota-fisc.qt-faturada[1]
        FIELD ProductQtOrder   LIKE it-nota-fisc.qt-faturada[1]
        FIELD ProductStatus    AS CHAR
        .

DEFINE TEMP-TABLE tt-SerialNumber NO-UNDO
    FIELD regID           AS INT
    FIELD SerialNumber    AS CHAR.

DEFINE TEMP-TABLE tt-prog-ponto2 LIKE tt-prog-ponto.

DEFINE BUFFER bnum-serie-rast    FOR num-serie-rast.
DEFINE BUFFER bnum-serie-fornec  FOR num-serie-fornec.
DEFINE BUFFER bnum-serie         FOR num-serie.
DEFINE BUFFER btt-prog-ponto     FOR tt-prog-ponto.
DEFINE BUFFER btt-arquivo-vendas FOR tt-arquivo-vendas.
DEFINE BUFFER bitem              FOR ITEM.
DEFINE BUFFER bestabelec         FOR estabelec.

    
DEFINE VARIABLE c-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

DEF VAR c-arquivo AS CHAR NO-UNDO.

DEF VAR i-cont    AS INT NO-UNDO.
DEF VAR i-cont-se AS INT NO-UNDO.
DEF VAR i-cont-ge AS INT NO-UNDO.

DEF VAR c-data      AS DATE NO-UNDO.
DEF VAR c-data2     AS DATE NO-UNDO.
DEF VAR cPartNumber AS CHAR NO-UNDO.
DEF VAR cSenderID        AS CHAR NO-UNDO.
DEF VAR cDistributorName AS CHAR NO-UNDO.
DEF VAR cId-WD-SD        AS CHAR NO-UNDO.
DEF VAR cReceiverID      AS CHAR NO-UNDO.
DEF VAR cInterchangeDate AS CHAR NO-UNDO.
DEF VAR cInterchangeTime AS CHAR NO-UNDO.
DEF VAR i-seq_edi_wd     AS INT  NO-UNDO.
DEF VAR cSerialNumber    AS CHAR NO-UNDO.
DEF VAR l-devol          AS LOG  NO-UNDO.
DEF VAR c-dir-saida      AS CHAR NO-UNDO.
DEF VAR c-SerialNumber   AS CHAR NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar in h-acomp (input "Lendo...").

RUN pi-inicial.

IF tt-param.l-pos THEN
    RUN pi-carrega-vendas.

IF tt-param.l-inv THEN
    RUN pi-carrega-inventario.

RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK".

PROCEDURE pi-inicial:

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END.
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END.
    END.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "EDI-WD":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    EMPTY TEMP-TABLE tt-prog-ponto2.
    RUN esp/es0018p.p (INPUT "EDI-WD":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto2).
    FIND FIRST tt-prog-ponto2 NO-ERROR.

    
    IF  tt-param.data-ini = "01/01/0001"
    AND tt-param.data-fim = "31/12/9999" THEN DO:

        IF tt-param.i-diario = 1 THEN /* Diario */
            ASSIGN tt-param.data-ini = STRING(TODAY - 1)
                   tt-param.data-fim = STRING(TODAY - 1).
        ELSE
            ASSIGN tt-param.data-ini = STRING(TODAY - 7)
                   tt-param.data-fim = STRING(TODAY - 1).


    END.

END PROCEDURE.

PROCEDURE pi-carrega-vendas:
    DEFINE VARIABLE l-continua AS LOGICAL     NO-UNDO.

    DO c-data = DATE(tt-param.data-ini) TO DATE(tt-param.data-fim):

        run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data)).

        IF tt-param.i-diario = 1 THEN /* Diario */
            EMPTY TEMP-TABLE tt-arquivo-vendas.

        FOR EACH tt-prog-ponto:
            FIND FIRST ITEM NO-LOCK USE-INDEX codigo
                 WHERE ITEM.it-codigo = ENTRY(1,tt-prog-ponto.conteudo,";") NO-ERROR.

            RUN pi-acompanhar IN h-acomp (INPUT "POS: " + STRING(c-data) + " 1.1 " + ITEM.it-codigo).

            RUN pi-cria-tt-arquivos-vendas.
        END.

        /*FOR EACH num-serie-rast NO-LOCK USE-INDEX data
           WHERE DATE(num-serie-rast.data) = c-data
           BREAK BY num-serie-rast.nr-nota-fis:

            /*
            IF  num-serie-rast.it-codigo < tt-param.item-ini
            AND num-serie-rast.it-codigo > tt-param.item-fim THEN NEXT.
            */

            /* CASO ENCONTRE O SERIAL DO ITEM */
            FIND FIRST tt-prog-ponto
                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = num-serie-rast.it-codigo NO-ERROR.
            IF AVAIL tt-prog-ponto THEN DO:

                FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = num-serie-rast.it-codigo NO-ERROR.

                run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data) + " 1.1 " + num-serie-rast.nr-nota-fis).

                ASSIGN cSerialNumber = num-serie-rast.n-serie
                       l-devol       = NO.

                RUN pi-cria-tt-arquivos-vendas.

            END.
            ELSE DO:
                /* CASO NAO ENCONTRE O SERIAL DO ITEM, TENTAR BUSCAR O SERIAL DO COMPONENTE */
                FOR FIRST num-serie-fornec NO-LOCK USE-INDEX ch-pr
                    WHERE num-serie-fornec.n-serie = num-serie-rast.n-serie,
                    FIRST num-serie NO-LOCK USE-INDEX ch-pri 
                    WHERE num-serie.n-serie = num-serie-fornec.n-serie-sec,
                    FIRST tt-prog-ponto
                    WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = num-serie.it-codigo:

                    run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data) + " 1.2 " + num-serie-rast.nr-nota-fis).

                    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = num-serie.it-codigo NO-ERROR.

                    ASSIGN cSerialNumber = num-serie.n-serie
                           l-devol       = NO.

                    RUN pi-cria-tt-arquivos-vendas.

                END.
            END.
        END.*/

        /* DEVOLU€åES */
        FOR EACH devol-cli USE-INDEX ch-dt-emit NO-LOCK
           WHERE devol-cli.dt-devol  = c-data,
            EACH item-doc-est OF devol-cli NO-LOCK
           WHERE item-doc-est.it-codigo >= tt-param.item-ini
             AND item-doc-est.it-codigo <= tt-param.item-fim,
           FIRST nota-fiscal NO-LOCK USE-INDEX ch-nota
           WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
             AND nota-fiscal.serie        = devol-cli.serie
             AND nota-fiscal.nr-nota-fis  = devol-cli.nr-nota-fis,
           FIRST it-nota-fisc OF nota-fiscal NO-LOCK USE-INDEX ch-nota-item
           WHERE it-nota-fisc.it-codigo  = item-doc-est.it-codigo
             AND it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp:

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-oper = it-nota-fisc.nat-oper NO-ERROR.

            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            IF emitente.cod-emitente = 178181 THEN NEXT.

            IF nota-fiscal.cod-estabel = "104" THEN DO:
               
               IF natur-oper.transf = YES AND emitente.cod-emitente <> 143524 THEN NEXT.
              
               IF emitente.cod-emitente = 141000 THEN NEXT.
            END.

            /*Considerar pedidos astec "atendente 94 e 99"*/
            ASSIGN l-continua = NO.

            IF  nota-fiscal.esp-docto = 22 THEN
                ASSIGN l-continua = YES.
    
            IF  NOT l-continua 
            AND nota-fiscal.emite-duplic THEN
                ASSIGN l-continua = YES.
    
           /* IF NOT l-continua THEN
                NEXT. manda tudo*/

            FIND FIRST tt-prog-ponto
                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = item-doc-est.it-codigo NO-ERROR.

            IF AVAIL tt-prog-ponto THEN DO:

                run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data) + " 2.1 " + nota-fiscal.nr-nota-fis).

                FIND FIRST ITEM NO-LOCK 
                     WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.
                
                RUN pi-cria-tt-arquivos-vendas-devol.

            END.

            /*FOR EACH num-serie-rast NO-LOCK USE-INDEX ch-pri
               WHERE num-serie-rast.cod-estabel = nota-fiscal.cod-estabel
                 AND num-serie-rast.serie       = nota-fiscal.serie      
                 AND num-serie-rast.nr-nota-fis = nota-fiscal.nr-nota-fis:

                /* CASO ENCONTRE O SERIAL DO ITEM */
                FIND FIRST tt-prog-ponto
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = num-serie-rast.it-codigo NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:

                    run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data) + " 2.1 " + num-serie-rast.nr-nota-fis).

                    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = num-serie-rast.it-codigo NO-ERROR.
                    
                    ASSIGN cSerialNumber = num-serie-rast.n-serie
                           l-devol       = YES.

                    RUN pi-cria-tt-arquivos-vendas-devol.

                END.
                ELSE DO:
                    /* CASO NAO ENCONTRE O SERIAL DO ITEM, TENTAR BUSCAR O SERIAL DO COMPONENTE */
                    FOR FIRST num-serie-fornec NO-LOCK USE-INDEX ch-pr
                        WHERE num-serie-fornec.n-serie = num-serie-rast.n-serie,
                        FIRST num-serie NO-LOCK USE-INDEX ch-pri 
                        WHERE num-serie.n-serie = num-serie-fornec.n-serie-sec,
                        FIRST tt-prog-ponto
                        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = num-serie.it-codigo:
    
                        FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = num-serie.it-codigo NO-ERROR.

                        run pi-acompanhar in h-acomp (input "POS: " + STRING(c-data) + " 2.2 " + num-serie-rast.nr-nota-fis).
    
                        ASSIGN cSerialNumber = num-serie.n-serie
                               l-devol       = YES.
    
                        RUN pi-cria-tt-arquivos-vendas-devol.
    
                    END.
                END.
            END.*/
        END.
        
        IF  tt-param.i-diario = 1 /* Diario */
        AND CAN-FIND(FIRST tt-arquivo-vendas
                     WHERE tt-arquivo-vendas.Id-WD-SD = "WD") THEN
            RUN pi-imprime-vendas-wd.

        IF  tt-param.i-diario = 1 /* Diario */
        AND CAN-FIND(FIRST tt-arquivo-vendas
                     WHERE tt-arquivo-vendas.Id-WD-SD = "SD") THEN
            RUN pi-imprime-vendas-sd.

    END.

    IF  tt-param.i-diario = 2 /* Semanal */
    AND CAN-FIND(FIRST tt-arquivo-vendas
                 WHERE tt-arquivo-vendas.Id-WD-SD = "WD") THEN
        RUN pi-imprime-vendas-wd.

    IF  tt-param.i-diario = 2 /* Semanal */
    AND CAN-FIND(FIRST tt-arquivo-vendas
                 WHERE tt-arquivo-vendas.Id-WD-SD = "SD") THEN
        RUN pi-imprime-vendas-sd.

END PROCEDURE.

PROCEDURE pi-cria-tt-arquivos-vendas:
    DEFINE VARIABLE l-continua AS LOG   NO-UNDO.

    ASSIGN cPartNumber      = ENTRY(3,tt-prog-ponto.conteudo,";")
           cDistributorName = ENTRY(5,tt-prog-ponto.conteudo,";")
           cId-WD-SD        = ENTRY(6,tt-prog-ponto.conteudo,";").

    FOR EACH nota-fiscal NO-LOCK USE-INDEX nfftrm-25
        WHERE nota-fisca.idi-sit-nf-eletro   = 3
          AND nota-fiscal.dt-emis-nota       = c-data
         // AND nota-fiscal.dt-cancela         = ?:
          AND nota-fiscal.esp-docto         <> 20 /*NFD*/
          AND int(nota-fiscal.ind-tip-nota) <> 8, /*Tipo recebimento*/
         EACH it-nota-fisc NO-LOCK OF nota-fiscal USE-INDEX ch-nota-item
        WHERE it-nota-fisc.it-codigo  = ENTRY(1,tt-prog-ponto.conteudo,";"):

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
       
            IF natur-oper.nat-oper = "590700" or
               natur-oper.nat-oper = "590600" THEN NEXT. //nao criar para notas de retorno simbolico
       
            FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
       
            IF emitente.cod-emitente = 178181 THEN NEXT.
       
            FIND FIRST bestabelec NO-LOCK
                 WHERE bestabelec.cgc = emitente.cgc NO-ERROR.
       
            IF nota-fiscal.cod-estabel = "105" OR nota-fiscal.cod-estabel = "109" THEN DO:
                IF AVAIL bestabelec THEN NEXT. /*Nao listar transferencia entra 105 e 109*/
            END.
            ELSE IF nota-fiscal.cod-estabel = "104" THEN DO:
                    IF AVAIL bestabelec AND bestabelec.cod-estabel = "110" THEN NEXT.
       
                 IF natur-oper.transf = YES AND emitente.cod-emitente <> 143524 THEN NEXT.
       
                 IF emitente.cod-emitente = 141000 THEN NEXT.
            END.
       
            IF nota-fiscal.cod-estabel = "110" THEN DO:
               IF natur-oper.transf = YES AND emitente.cod-emitente <> 143524 THEN NEXT.
            END.

            /*Considerar pedidos astec "atendente 94 e 99"*/
            ASSIGN l-continua = NO.
       
            IF  nota-fiscal.esp-docto = 22 THEN
                ASSIGN l-continua = YES.
       
            IF  NOT l-continua 
            AND nota-fiscal.emite-duplic THEN
                ASSIGN l-continua = YES.
       
            /*IF NOT l-continua THEN
                NEXT.  mandar tudo pro arquivo*/
       
           /* FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR. */
       
            ASSIGN i-cont = i-cont + 1.

            CREATE tt-arquivo-vendas.
            ASSIGN tt-arquivo-vendas.Id-WD-SD        = cId-WD-SD
                   tt-arquivo-vendas.regID           = i-cont
                   tt-arquivo-vendas.DistributorName = cDistributorName
                   tt-arquivo-vendas.CustomerName    = emitente.nome-emit
                   tt-arquivo-vendas.CustomerID      = nota-fiscal.cod-emitente
                   tt-arquivo-vendas.CustomerAddress = nota-fiscal.endereco
                   tt-arquivo-vendas.CustomerCity    = nota-fiscal.cidade
                   tt-arquivo-vendas.CustomerState   = IF nota-fiscal.estado = "EX" THEN SUBSTRING(nota-fiscal.bairro,1,2) ELSE nota-fiscal.estado
                   tt-arquivo-vendas.CustomerCountry = IF nota-fiscal.pais = "Brasil" THEN "BR" ELSE REPLACE(nota-fiscal.pais,".","")
                   tt-arquivo-vendas.CustomerCep     = nota-fiscal.cep
                   tt-arquivo-vendas.ContactPerson   = "Leandro Jonk"
                   tt-arquivo-vendas.ContactEmail    = "leandro.jonk@intelbras.com.br"
                   tt-arquivo-vendas.ProductDesc     = ITEM.desc-item
                   tt-arquivo-vendas.PartNumber      = cPartNumber
                   tt-arquivo-vendas.BuyerPartNumber = ITEM.it-codigo
                   tt-arquivo-vendas.Invoice         = nota-fiscal.nr-nota-fis
                   //tt-arquivo-vendas.InvoiceDate     = STRING(YEAR(nota-fiscal.dt-emis-nota),"9999") + STRING(MONTH(nota-fiscal.dt-emis-nota),"99") + STRING(DAY(nota-fiscal.dt-emis-nota),"99")
                   //tt-arquivo-vendas.InvoiceDateShip = STRING(YEAR(num-serie-rast.data),"9999") + STRING(MONTH(num-serie-rast.data),"99") + STRING(DAY(num-serie-rast.data),"99")
                   tt-arquivo-vendas.InvoiceDate     = STRING(YEAR(nota-fiscal.dt-emis-nota),"9999") + STRING(MONTH(nota-fiscal.dt-emis-nota),"99") + STRING(DAY(nota-fiscal.dt-emis-nota),"99")
                   tt-arquivo-vendas.InvoiceDateShip = STRING(YEAR(nota-fiscal.dt-emis-nota),"9999") + STRING(MONTH(nota-fiscal.dt-emis-nota),"99") + STRING(DAY(nota-fiscal.dt-emis-nota),"99")
                   tt-arquivo-vendas.ProductQt       = it-nota-fisc.qt-faturada[1]
                   tt-arquivo-vendas.vlProduct       = it-nota-fisc.vl-merc-liq
                   tt-arquivo-vendas.SerialNumber    = cSerialNumber
                   tt-arquivo-vendas.nat-operacao    = it-nota-fisc.nat-operacao
                   tt-arquivo-vendas.denominacao     = natur-oper.denomina‡Æo.            
       
            IF tt-arquivo-vendas.InvoiceDateShip = ? THEN ASSIGN tt-arquivo-vendas.InvoiceDateShip = tt-arquivo-vendas.InvoiceDate.
            
        
    END.

END PROCEDURE.


PROCEDURE pi-cria-tt-arquivos-vendas-devol:

    ASSIGN cPartNumber      = ENTRY(3,tt-prog-ponto.conteudo,";")
           cDistributorName = ENTRY(5,tt-prog-ponto.conteudo,";")
           cId-WD-SD        = ENTRY(6,tt-prog-ponto.conteudo,";").

    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.

    IF natur-oper.nat-oper = "590700" or
       natur-oper.nat-oper = "590600" THEN NEXT. //nao criar para notas de retorno simbolico

    ASSIGN i-cont = i-cont + 1.

    CREATE tt-arquivo-vendas.
    ASSIGN tt-arquivo-vendas.Id-WD-SD        = cId-WD-SD
           tt-arquivo-vendas.regID           = i-cont
           tt-arquivo-vendas.DistributorName = cDistributorName
           tt-arquivo-vendas.CustomerName    = emitente.nome-emit
           tt-arquivo-vendas.CustomerID      = nota-fiscal.cod-emitente
           tt-arquivo-vendas.CustomerAddress = nota-fiscal.endereco
           tt-arquivo-vendas.CustomerCity    = nota-fiscal.cidade
           tt-arquivo-vendas.CustomerState   = IF nota-fiscal.estado = "EX" THEN SUBSTRING(nota-fiscal.bairro,1,2) ELSE nota-fiscal.estado
           tt-arquivo-vendas.CustomerCountry = IF nota-fiscal.pais = "Brasil" THEN "BR" ELSE REPLACE(nota-fiscal.pais,".","")
           tt-arquivo-vendas.CustomerCep     = nota-fiscal.cep
           tt-arquivo-vendas.ContactPerson   = "Leandro Jonk"
           tt-arquivo-vendas.ContactEmail    = "leandro.jonk@intelbras.com.br"
           tt-arquivo-vendas.ProductDesc     = ITEM.desc-item
           tt-arquivo-vendas.PartNumber      = cPartNumber
           tt-arquivo-vendas.BuyerPartNumber = ITEM.it-codigo
           tt-arquivo-vendas.Invoice         = nota-fiscal.nr-nota-fis
           tt-arquivo-vendas.InvoiceDate     = STRING(YEAR(devol-cli.dt-devol),"9999") + STRING(MONTH(devol-cli.dt-devol),"99") + STRING(DAY(devol-cli.dt-devol),"99")
           tt-arquivo-vendas.InvoiceDateShip = STRING(YEAR(devol-cli.dt-devol),"9999") + STRING(MONTH(devol-cli.dt-devol),"99") + STRING(DAY(devol-cli.dt-devol),"99")
           tt-arquivo-vendas.ProductQt       = item-doc-est.quantidade * -1
           tt-arquivo-vendas.vlProduct       = it-nota-fisc.vl-merc-liq * -1
           tt-arquivo-vendas.SerialNumber    = cSerialNumber
           tt-arquivo-vendas.nat-operacao    = it-nota-fisc.nat-operacao
           tt-arquivo-vendas.denominacao     = natur-oper.denomina‡Æo.

    IF tt-arquivo-vendas.InvoiceDateShip = ? THEN ASSIGN tt-arquivo-vendas.InvoiceDateShip = tt-arquivo-vendas.InvoiceDate.

END PROCEDURE.

PROCEDURE pi-imprime-vendas-wd:

    IF tt-param.tipo = 1 THEN DO:

        OUTPUT TO VALUE(c-dir-saida + "/" + c-seg-usuario + "/ESFTP125-WD-Vendas-" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".csv") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
        PUT UNFORMATTED "DistributorName;CustomerName;CustomerID;CustomerCity;CustomerState;CustomerCountry;CustomerCep;ProductDesc;PartNumber;BuyerPartNumber;Invoice;InvoiceDate;InvoiceDateShip;ProductQt;SerialNumber;Natureza;Descri‡Æo;" SKIP.     

        FOR EACH tt-arquivo-vendas
           WHERE tt-arquivo-vendas.Id-WD-SD = "WD"
           BREAK BY tt-arquivo-vendas.Invoice
                 BY tt-arquivo-vendas.BuyerPartNumber:

            IF FIRST-OF(tt-arquivo-vendas.BuyerPartNumber) THEN DO:

                PUT UNFORMATTED 
                    tt-arquivo-vendas.DistributorName ";"
                    tt-arquivo-vendas.CustomerName    ";"
                    tt-arquivo-vendas.CustomerID      ";"
                    tt-arquivo-vendas.CustomerCity    ";"
                    tt-arquivo-vendas.CustomerState   ";"
                    tt-arquivo-vendas.CustomerCountry ";"
                    tt-arquivo-vendas.customerCep     ";"
                    tt-arquivo-vendas.ProductDesc     ";"
                    tt-arquivo-vendas.PartNumber      ";"
                    tt-arquivo-vendas.BuyerPartNumber ";"
                    tt-arquivo-vendas.Invoice         ";"
                    tt-arquivo-vendas.InvoiceDate     ";"
                    tt-arquivo-vendas.InvoiceDateShip ";"
                    tt-arquivo-vendas.ProductQt       ";".

                ASSIGN c-SerialNumber = ""
                       i-cont-se      = 0.
                    
                FOR EACH btt-arquivo-vendas 
                   WHERE btt-arquivo-vendas.Invoice         = tt-arquivo-vendas.Invoice
                     AND btt-arquivo-vendas.BuyerPartNumber = tt-arquivo-vendas.BuyerPartNumber:

                    IF  (tt-arquivo-vendas.ProductQt > 0
                    AND i-cont-se >= tt-arquivo-vendas.ProductQt)
                     OR (tt-arquivo-vendas.ProductQt < 0
                    AND i-cont-se >= (tt-arquivo-vendas.ProductQt * -1)) THEN NEXT.   

                    IF c-SerialNumber = "" THEN
                        ASSIGN c-SerialNumber = TRIM(CAPS(btt-arquivo-vendas.SerialNumber)).
                    ELSE                         
                        ASSIGN c-SerialNumber = c-SerialNumber + ", " + TRIM(CAPS(btt-arquivo-vendas.SerialNumber)).
                    
                    ASSIGN i-cont-se = i-cont-se + 1.
                END.

                PUT UNFORMATTED 
                    c-SerialNumber ";"
                    tt-arquivo-vendas.nat-operacao ";"
                    tt-arquivo-vendas.denominacao ";"
                    SKIP.
            END.
        END.
        OUTPUT CLOSE.
    END.
    ELSE DO:

        /**** WESTERN DIGITAL ****/
        ASSIGN cSenderID        = "9000002695"
               cDistributorName = "INTELBRAS S/A - BRAZIL"
               cReceiverID      = "051983567WDC"
               cInterchangeDate = SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99")
               cInterchangeTime = REPLACE(STRING(TIME,"HH:MM"),":","")
               i-cont-ge        = 0
               i-seq_edi_wd     = NEXT-VALUE(seq_edi_wd).
    
        OUTPUT TO VALUE(tt-prog-ponto2.conteudo + "\867WD" + STRING(i-seq_edi_wd,"999999999") + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".wd") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
    
        PUT UNFORMATTED "ISA*00*          *01*          *14*" + cSenderID + "     *14*" + cReceiverID + "   *" + cInterchangeDate + "*" + cInterchangeTime + "*U*00401*" + STRING(i-seq_edi_wd,"999999999") + "*0*P*>" + "~~" SKIP.
        PUT UNFORMATTED "GS*PT*" + cSenderID + "*" + cReceiverID + "*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "*" + REPLACE(STRING(TIME,"HH:MM"),":","") + "*462*X*004010" + "~~"  SKIP.
    
        FOR EACH tt-arquivo-vendas
           WHERE tt-arquivo-vendas.Id-WD-SD = "WD"
           BREAK BY tt-arquivo-vendas.Invoice
                 BY tt-arquivo-vendas.BuyerPartNumber:
    
            IF FIRST-OF(tt-arquivo-vendas.BuyerPartNumber) THEN DO:
                
                ASSIGN i-cont-ge = i-cont-ge + 1.
    
                PUT UNFORMATTED "ST*867*0001" + "~~"  SKIP.
                PUT UNFORMATTED "BPT*00*" + "POS-" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + "-" + string(i-cont-ge) /*tt-arquivo-vendas.Invoice*/ + "*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "*01" + "~~"  SKIP.
                PUT UNFORMATTED "CUR*DS*BRL" + "~~"  SKIP.
                PUT UNFORMATTED "N1*DS*" + cDistributorName + "*92*" + cSenderID + "~~"  SKIP.
                PUT UNFORMATTED "N2*DB*BRAZIL" + "~~"  SKIP.
                PUT UNFORMATTED "PER*BL*" + tt-arquivo-vendas.ContactPerson + "*EM*" + tt-arquivo-vendas.ContactEmail + "~~"  SKIP.
                PUT UNFORMATTED "PTD*SS" + "~~"  SKIP.
                PUT UNFORMATTED "N1*ST*" + SUBSTRING(tt-arquivo-vendas.CustomerName,1,60) + "*92*" + STRING(tt-arquivo-vendas.CustomerID) + "~~"  SKIP.
                PUT UNFORMATTED "N4*" + tt-arquivo-vendas.CustomerCity + "*" + tt-arquivo-vendas.CustomerState + "**" + tt-arquivo-vendas.CustomerCountry + "~~"  SKIP.
                PUT UNFORMATTED "QTY*39*" + STRING(tt-arquivo-vendas.ProductQt) + "*EA" + "~~"  SKIP.
                PUT UNFORMATTED "LIN*1*VP*" + tt-arquivo-vendas.PartNumber + "*BP*" + tt-arquivo-vendas.BuyerPartNumber + "~~"  SKIP.
                PUT UNFORMATTED "PID*F*08***" + tt-arquivo-vendas.ProductDesc + "~~"  SKIP.
                PUT UNFORMATTED "REF*IV*" + tt-arquivo-vendas.Invoice + "~~"  SKIP.
                
                ASSIGN i-cont-se = 0.
            
                FOR EACH btt-arquivo-vendas 
                   WHERE btt-arquivo-vendas.Invoice         = tt-arquivo-vendas.Invoice
                     AND btt-arquivo-vendas.BuyerPartNumber = tt-arquivo-vendas.BuyerPartNumber:
    
                    IF  (tt-arquivo-vendas.ProductQt > 0
                    AND i-cont-se >= tt-arquivo-vendas.ProductQt)
                     OR (tt-arquivo-vendas.ProductQt < 0
                    AND i-cont-se >= (tt-arquivo-vendas.ProductQt * -1)) THEN NEXT.     
    
                    PUT UNFORMATTED "REF*SE*" + CAPS(btt-arquivo-vendas.SerialNumber) + "~~"  SKIP.
            
                    ASSIGN i-cont-se = i-cont-se + 1.
                END.
        
                PUT UNFORMATTED "DTM*003*" + STRING(tt-arquivo-vendas.InvoiceDate) + "~~"  SKIP.
                PUT UNFORMATTED "DTM*011*" + STRING(tt-arquivo-vendas.InvoiceDateShip) + "~~"  SKIP.
                
                PUT UNFORMATTED "CTT*3" + "~~"  SKIP.
                PUT UNFORMATTED "SE*" + STRING(17 + i-cont-se) "*0001" + "~~"  SKIP.
            END.
    
        END.
    
        PUT UNFORMATTED "GE*" + STRING(i-cont-ge) + "*462" + "~~"  SKIP.
        PUT UNFORMATTED "IEA*1*" + STRING(i-seq_edi_wd,"999999999") + "~~"  SKIP.
    
        OUTPUT CLOSE.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-vendas-sd:

    IF tt-param.tipo = 1 THEN DO:

        OUTPUT TO VALUE(c-dir-saida + "/" + c-seg-usuario + "/ESFTP125-SD-Vendas-" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".csv") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
        PUT UNFORMATTED "DistributorName;CustomerName;CustomerID;CustomerCity;CustomerState;CustomerCountry;ProductDesc;PartNumber;BuyerPartNumber;Invoice;InvoiceDate;InvoiceDateShip;ProductQt;SerialNumber;Natureza;Descri‡Æo;" SKIP.  

        FOR EACH tt-arquivo-vendas
           WHERE tt-arquivo-vendas.Id-WD-SD = "SD"
           BREAK BY tt-arquivo-vendas.Invoice
                 BY tt-arquivo-vendas.BuyerPartNumber:

            IF FIRST-OF(tt-arquivo-vendas.BuyerPartNumber) THEN DO:

                PUT UNFORMATTED 
                    tt-arquivo-vendas.DistributorName ";"
                    tt-arquivo-vendas.CustomerName    ";"
                    tt-arquivo-vendas.CustomerID      ";"
                    tt-arquivo-vendas.CustomerCity    ";"
                    tt-arquivo-vendas.CustomerState   ";"
                    tt-arquivo-vendas.CustomerCountry ";"
                    tt-arquivo-vendas.ProductDesc     ";"
                    tt-arquivo-vendas.PartNumber      ";"
                    tt-arquivo-vendas.BuyerPartNumber ";"
                    tt-arquivo-vendas.Invoice         ";"
                    tt-arquivo-vendas.InvoiceDate     ";"
                    tt-arquivo-vendas.InvoiceDateShip ";"
                    tt-arquivo-vendas.ProductQt       ";".

                ASSIGN c-SerialNumber = ""
                       i-cont-se      = 0.
                    
                FOR EACH btt-arquivo-vendas 
                   WHERE btt-arquivo-vendas.Invoice         = tt-arquivo-vendas.Invoice
                     AND btt-arquivo-vendas.BuyerPartNumber = tt-arquivo-vendas.BuyerPartNumber:

                    IF  (tt-arquivo-vendas.ProductQt > 0
                    AND i-cont-se >= tt-arquivo-vendas.ProductQt)
                     OR (tt-arquivo-vendas.ProductQt < 0
                    AND i-cont-se >= (tt-arquivo-vendas.ProductQt * -1)) THEN NEXT.   

                    IF c-SerialNumber = "" THEN
                        ASSIGN c-SerialNumber = CAPS(btt-arquivo-vendas.SerialNumber).
                    ELSE                         
                        ASSIGN c-SerialNumber = c-SerialNumber + ", " + CAPS(btt-arquivo-vendas.SerialNumber).
                    
                    ASSIGN i-cont-se = i-cont-se + 1.
                END.

                 PUT UNFORMATTED 
                    c-SerialNumber ";"
                    tt-arquivo-vendas.nat-operacao ";"
                    tt-arquivo-vendas.denominacao ";"
                    SKIP.
                    
            END.
        END.
        OUTPUT CLOSE.
    END.
    ELSE DO:

        /**** SANDISK ****/
        ASSIGN cSenderID        = "2004573   "
               cDistributorName = "INTELBRAS S/A - BRAZIL"
               cReceiverID      = "051983567WDC"
               cInterchangeDate = SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99")
               cInterchangeTime = REPLACE(STRING(TIME,"HH:MM"),":","")
               i-cont-ge        = 0
               i-seq_edi_wd     = NEXT-VALUE(seq_edi_wd).
    
        OUTPUT TO VALUE(tt-prog-ponto2.conteudo + "\867SD" + STRING(i-seq_edi_wd,"999999999") + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".wd") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
    
        PUT UNFORMATTED "ISA*00*          *01*          *14*" + cSenderID + "     *14*" + cReceiverID + "   *" + cInterchangeDate + "*" + cInterchangeTime + "*U*00401*" + STRING(i-seq_edi_wd,"999999999") + "*0*P*>" + "~~" SKIP.
        PUT UNFORMATTED "GS*PT*" + TRIM(cSenderID) + "*SANDISK*" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + "*" + REPLACE(STRING(TIME,"HH:MM"),":","") + "*462*X*004010" + "~~"  SKIP.
    
        FOR EACH tt-arquivo-vendas
           WHERE tt-arquivo-vendas.Id-WD-SD = "SD"
           BREAK BY tt-arquivo-vendas.Invoice
                 BY tt-arquivo-vendas.BuyerPartNumber:
    
            IF FIRST-OF(tt-arquivo-vendas.BuyerPartNumber) THEN DO:
    
                ASSIGN i-cont-ge = i-cont-ge + 1.
        
                PUT UNFORMATTED "ST*867*0001" + "~~"  SKIP.
                PUT UNFORMATTED "BPT*00*" + "POS-" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + "-" + tt-arquivo-vendas.Invoice + "*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "*01" + "~~"  SKIP.
                PUT UNFORMATTED "CUR*DS*BRL" + "~~"  SKIP.
                PUT UNFORMATTED "N1*DS*" + cDistributorName + "*92*" + cSenderID + "~~"  SKIP.
                PUT UNFORMATTED "N2*DB*BRAZIL" + "~~"  SKIP.
                PUT UNFORMATTED "PER*BL*" + tt-arquivo-vendas.ContactPerson + "*EM*" + tt-arquivo-vendas.ContactEmail + "~~"  SKIP.
                PUT UNFORMATTED "PTD*SS" + "~~"  SKIP.
                PUT UNFORMATTED "N1*ST*" + SUBSTRING(tt-arquivo-vendas.CustomerName,1,60) + "*92*" + STRING(tt-arquivo-vendas.CustomerID) + "~~"  SKIP.
                PUT UNFORMATTED "N4*" + tt-arquivo-vendas.CustomerCity + "*" + tt-arquivo-vendas.CustomerState + "**" + tt-arquivo-vendas.CustomerCountry + "~~"  SKIP.
                PUT UNFORMATTED "QTY*39*" + STRING(tt-arquivo-vendas.ProductQt) + "*EA" + "~~"  SKIP.
                PUT UNFORMATTED "LIN*1*VP*" + tt-arquivo-vendas.PartNumber + "*BP*" + tt-arquivo-vendas.BuyerPartNumber + "~~"  SKIP.
                PUT UNFORMATTED "PID*F*08***" + tt-arquivo-vendas.ProductDesc + "~~"  SKIP.
                PUT UNFORMATTED "REF*IV*" + tt-arquivo-vendas.Invoice + "~~"  SKIP.
                
                ASSIGN i-cont-se = 0.
            
                FOR EACH btt-arquivo-vendas 
                   WHERE btt-arquivo-vendas.Invoice         = tt-arquivo-vendas.Invoice
                     AND btt-arquivo-vendas.BuyerPartNumber = tt-arquivo-vendas.BuyerPartNumber:
    
                    IF  (tt-arquivo-vendas.ProductQt > 0
                    AND i-cont-se >= tt-arquivo-vendas.ProductQt)
                     OR (tt-arquivo-vendas.ProductQt < 0
                    AND i-cont-se >= (tt-arquivo-vendas.ProductQt * -1)) THEN NEXT.     
    
                    PUT UNFORMATTED "REF*SE*" + CAPS(btt-arquivo-vendas.SerialNumber) + "~~"  SKIP.
            
                    ASSIGN i-cont-se = i-cont-se + 1.
                END.
            
                PUT UNFORMATTED "DTM*003*" + STRING(tt-arquivo-vendas.InvoiceDate) + "~~"  SKIP.
                PUT UNFORMATTED "DTM*011*" + STRING(tt-arquivo-vendas.InvoiceDateShip) + "~~"  SKIP.
                
                PUT UNFORMATTED "CTT*3" + "~~"  SKIP.
                PUT UNFORMATTED "SE*" + STRING(17 + i-cont-se) "*0001" + "~~"  SKIP.
    
            END.
    
        END.
    
        PUT UNFORMATTED "GE*" + STRING(i-cont-ge) + "*462" + "~~"  SKIP.
        PUT UNFORMATTED "IEA*1*" + STRING(i-seq_edi_wd,"999999999") + "~~"  SKIP.
    
        OUTPUT CLOSE.
    END.

END PROCEDURE.

PROCEDURE pi-carrega-inventario:

    DEF VAR d-ProductQtInv     AS INT NO-UNDO.
    DEF VAR d-ProductQtOrder   AS INT NO-UNDO.
    DEF VAR d-ProductQtTransit AS INT NO-UNDO.
    DEF VAR d-ProductStatus  AS CHAR NO-UNDO.
    DEF VAR de-ProductStatus AS CHAR NO-UNDO.

    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = "104" NO-ERROR.

    DO c-data = DATE(tt-param.data-ini) TO DATE(tt-param.data-fim):
    //DO c-data = DATE(TODAY) TO DATE(TODAY):

        run pi-acompanhar in h-acomp (input "INV: " + STRING(c-data)).
    
        EMPTY TEMP-TABLE tt-arquivo-inventario.
    
        FOR EACH tt-prog-ponto,
           FIRST ITEM
           WHERE ITEM.it-codigo  = ENTRY(1,tt-prog-ponto.conteudo,";")
             AND ITEM.it-codigo >= tt-param.item-ini 
             AND ITEM.it-codigo <= tt-param.item-fim:

             ASSIGN i-cont = i-cont + 1.

             ASSIGN cId-WD-SD        = ENTRY(6,tt-prog-ponto.conteudo,";").

             ASSIGN d-ProductQtInv   = 0
                    d-ProductQtOrder = 0.
             
             FOR EACH bITEM NO-LOCK
                WHERE bITEM.it-codigo  = ENTRY(1,tt-prog-ponto.conteudo,";")
                   /*OR bITEM.it-codigo  = ENTRY(2,tt-prog-ponto.conteudo,";")*/:

                 FOR EACH saldo-estoq NO-LOCK 
                    WHERE saldo-estoq.it-codigo   = bITEM.it-codigo
                      AND (saldo-estoq.cod-estabel = "104"
                       OR  saldo-estoq.cod-estabel = "110"):
                      //AND saldo-estoq.cod-estabel = estabelec.cod-estabel :

                     ASSIGN d-ProductQtInv   = d-ProductQtInv   + saldo-estoq.qtidade-atu.
                            d-ProductQtOrder = d-ProductQtOrder + saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped.

                     IF c-data <> TODAY THEN DO:
                         FOR EACH movto-estoq use-index item-data 
                            WHERE movto-estoq.it-codigo   = saldo-estoq.it-codigo     
                              AND movto-estoq.cod-refer   = saldo-estoq.cod-refer      
                              AND movto-estoq.cod-estabel = saldo-estoq.cod-estabel  
                              AND movto-estoq.cod-depos   = saldo-estoq.cod-depos     
                              AND movto-estoq.lote        = saldo-estoq.lote                
                              AND movto-estoq.cod-localiz = saldo-estoq.cod-localiz  
                              AND movto-estoq.esp-docto  <> 37
                              AND movto-estoq.dt-trans    > c-data no-lock:
                    
                            IF movto-estoq.tipo-trans = 1 then
                                ASSIGN d-ProductQtInv = d-ProductQtInv - movto-estoq.quantidade.
                            ELSE
                                ASSIGN d-ProductQtInv = d-ProductQtInv + movto-estoq.quantidade.
                         END.
                     END.
                 END.
             END.
            
            CREATE tt-arquivo-inventario.
            ASSIGN tt-arquivo-inventario.Id-WD-SD         = cId-WD-SD
                   tt-arquivo-inventario.regID            = i-cont
                   tt-arquivo-inventario.codEstabel       = estabelec.cod-estabel
                   tt-arquivo-inventario.WarehouseName    = "INTELBRAS S/A - BRAZIL XWORKS"
                   tt-arquivo-inventario.WarehouseAddress = estabelec.endereco
                   tt-arquivo-inventario.WarehouseCity    = estabelec.cidade
                   tt-arquivo-inventario.WarehouseState   = estabelec.estado
                   tt-arquivo-inventario.WarehouseCountry = IF estabelec.pais = "Brasil" THEN "BR" ELSE REPLACE(estabelec.pais,".","")
                   tt-arquivo-inventario.WarehouseCep     = estabelec.cep
                   tt-arquivo-inventario.ProductDesc      = item.desc-item
                   tt-arquivo-inventario.PartNumber       = ENTRY(3,tt-prog-ponto.conteudo,";")
                   tt-arquivo-inventario.BuyerPartNumber  = item.it-codigo
                   tt-arquivo-inventario.ProductQtInv     = d-ProductQtInv
                   tt-arquivo-inventario.ProductQtRMA     = 0
                   tt-arquivo-inventario.ProductQtOrder   = d-ProductQtOrder.
                   

            ASSIGN d-ProductQtTransit = 0.
            
            /* SALDO EMB */
            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.it-codigo   = ENTRY(1,tt-prog-ponto.conteudo,";")
                 AND prazo-compra.situacao    = 2
                 AND prazo-compra.quant-saldo > 0,
                EACH ordem-compra no-lock
               WHERE ordem-compra.cod-estabel  = estabelec.cod-estabel
                 AND ordem-compra.numero-ordem = prazo-compra.numero-ordem,
                EACH emitente no-lock
               WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                 AND emitente.cod-emitente = 178181
                  BY prazo-compra.data-entrega:

                FOR EACH ordens-embarque NO-LOCK
                   WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                     AND ordens-embarque.parcela       = prazo-compra.parcela:

                    RUN pi-busca-posicao (INPUT  ordem-compra.cod-estabel,
                                          INPUT  ordens-embarque.embarque). 
                    FIND FIRST tt-emb NO-ERROR.
                    IF NOT AVAIL tt-emb THEN NEXT.
                    IF tt-emb.situacao = 1 THEN NEXT.

                    ASSIGN de-ProductStatus = "".

                    CASE tt-emb.situacao:
                        WHEN 99 THEN ASSIGN de-ProductStatus = "Agt".
                        WHEN 1  THEN ASSIGN de-ProductStatus = "Prev".
                        WHEN 2  THEN ASSIGN de-ProductStatus = "Embar".
                        WHEN 98 THEN ASSIGN de-ProductStatus = "DI".
                        WHEN 3  THEN ASSIGN de-ProductStatus = "Desp".
                        WHEN 4  THEN ASSIGN de-ProductStatus = "NF".
                        WHEN 97 THEN ASSIGN de-ProductStatus = "MANUT".
                        WHEN 96 THEN ASSIGN de-ProductStatus = "INST".
                    END CASE.

                    IF INDEX(d-ProductStatus,de-ProductStatus) = 0 THEN DO:
                        IF d-ProductStatus = "" THEN
                          ASSIGN d-ProductStatus = de-ProductStatus.
                        ELSE
                            ASSIGN d-ProductStatus = d-ProductStatus + "," + de-ProductStatus.

                    END.
                    
                    ASSIGN d-ProductQtTransit = d-ProductQtTransit + ordens-embarque.quantidade.
                
                END.
            END.

            ASSIGN tt-arquivo-inventario.ProductQtTransit = d-ProductQtTransit.
            ASSIGN tt-arquivo-inventario.ProductStatus    = d-ProductStatus.
        END.

        IF  CAN-FIND(FIRST tt-arquivo-inventario
                     WHERE tt-arquivo-inventario.Id-WD-SD = "WD") THEN
            RUN pi-imprime-inventario-wd.

        IF  CAN-FIND(FIRST tt-arquivo-inventario
                     WHERE tt-arquivo-inventario.Id-WD-SD = "SD") THEN
            RUN pi-imprime-inventario-sd.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-inventario-wd:

    IF tt-param.tipo = 1 THEN DO:

        OUTPUT TO VALUE(c-dir-saida + "/" + c-seg-usuario + "/ESFTP125-WD-Inventario-" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".csv") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
        PUT UNFORMATTED "WarehouseCod;WarehouseName;WarehouseAddress;WarehouseCity;WarehouseState;WarehouseCountry;WarehouseCep;ProductDesc;PartNumber;BuyerPartNumber;ProductQtInv;ProductQtRMA;ProductQtTransit;ProductQtOrder;Status;" SKIP. 

        FOR EACH tt-arquivo-inventario
           WHERE tt-arquivo-inventario.Id-WD-SD = "WD":

                PUT UNFORMATTED 
                    tt-arquivo-inventario.codEstabel       ";"
                    tt-arquivo-inventario.WarehouseName    ";"
                    tt-arquivo-inventario.WarehouseAddress ";"
                    tt-arquivo-inventario.WarehouseCity    ";"
                    tt-arquivo-inventario.WarehouseState   ";"
                    tt-arquivo-inventario.WarehouseCountry ";"
                    tt-arquivo-inventario.WarehouseCep     ";"
                    tt-arquivo-inventario.ProductDesc      ";"
                    tt-arquivo-inventario.PartNumber       ";"
                    tt-arquivo-inventario.BuyerPartNumber  ";"
                    tt-arquivo-inventario.ProductQtInv     ";"
                    tt-arquivo-inventario.ProductQtRMA     ";"
                    tt-arquivo-inventario.ProductQtTransit ";"
                    tt-arquivo-inventario.ProductQtOrder   ";"
                    tt-arquivo-inventario.ProductStatus    ";"
                    SKIP.

        END.
        OUTPUT CLOSE.
    END.
    ELSE DO:
    
        /**** WESTERN DIGITAL ****/
    
        ASSIGN cSenderID        = "9000002695"
               cDistributorName = "INTELBRAS S/A - BRAZIL"
               cReceiverID      = "051983567WDC"
               cInterchangeDate = SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99")
               cInterchangeTime = REPLACE(STRING(TIME,"HH:MM"),":","")
               i-cont-ge = 0
               i-seq_edi_wd     = NEXT-VALUE(seq_edi_wd).
    
        OUTPUT TO VALUE(tt-prog-ponto2.conteudo + "\846WD" + STRING(i-seq_edi_wd,"999999999") + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".wd") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
    
        PUT UNFORMATTED "ISA*00*          *00*          *14*" + cSenderID + "     *14*" + cReceiverID + "   *" + cInterchangeDate + "*" + cInterchangeTime + "*U*00401*" + STRING(i-seq_edi_wd,"999999999") + "*0*P*>" + "~~" SKIP.
        PUT UNFORMATTED "GS*IB*" + cSenderID + "*" + cReceiverID + "*" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + "*" + REPLACE(STRING(TIME,"HH:MM"),":","") + "*462*X*004010" + "~~" SKIP.
        
        FOR EACH tt-arquivo-inventario
           WHERE tt-arquivo-inventario.Id-WD-SD = "WD":
    
            ASSIGN i-cont-ge = i-cont-ge + 1.
    
            PUT UNFORMATTED "ST*846*0001" + "~~" SKIP.
            PUT UNFORMATTED "BIA*00*DD*" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + string(i-cont-ge) /*REPLACE(STRING(TIME,"HH:MM:SS"),":","")*/ + "*" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + "~~" SKIP.
            PUT UNFORMATTED "N1*DS*" + cDistributorName + "*92*" + TRIM(cSenderID) + "~~" SKIP.
            PUT UNFORMATTED "N1*WH*" + tt-arquivo-inventario.WarehouseName + "*92*" + tt-arquivo-inventario.codEstabel + "~~" SKIP.
            PUT UNFORMATTED "N3*"    + tt-arquivo-inventario.WarehouseAddress + "~~" SKIP.
            PUT UNFORMATTED "N4*"    + "SÆo Jos‚" /*tt-arquivo-inventario.WarehouseCity*/ + "*" + tt-arquivo-inventario.WarehouseState + "*" + STRING(tt-arquivo-inventario.WarehouseCep) + "*" + tt-arquivo-inventario.WarehouseCountry + "~~" SKIP.
            PUT UNFORMATTED "LIN*1*VP*" + tt-arquivo-inventario.PartNumber + "*BP*" + tt-arquivo-inventario.BuyerPartNumber + "~~" SKIP.
            PUT UNFORMATTED "QTY*17*" + STRING(tt-arquivo-inventario.ProductQtInv    ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*20*" + STRING(tt-arquivo-inventario.ProductQtRMA    ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*IQ*" + STRING(tt-arquivo-inventario.ProductQtTransit) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*63*" + STRING(tt-arquivo-inventario.ProductQtOrder  ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "CTT*1" + "~~" SKIP.
            PUT UNFORMATTED "SE*13*0001" + "~~" SKIP.
        
        END.
    
        PUT UNFORMATTED "GE*" + STRING(i-cont-ge) + "*462" + "~~"  SKIP.
        PUT UNFORMATTED "IEA*1*" + STRING(i-seq_edi_wd,"999999999") + "~~" SKIP.
    
        OUTPUT CLOSE.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-inventario-sd:

    IF tt-param.tipo = 1 THEN DO:

        OUTPUT TO VALUE(c-dir-saida + "/" + c-seg-usuario + "/ESFTP125-SD-Inventario-" + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".csv") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
        PUT UNFORMATTED "WarehouseCod;WarehouseName;WarehouseAddress;WarehouseCity;WarehouseState;WarehouseCountry;WarehouseCep;ProductDesc;PartNumber;BuyerPartNumber;ProductQtInv;ProductQtRMA;ProductQtTransit;ProductQtOrder;Status" SKIP. 

        FOR EACH tt-arquivo-inventario
           WHERE tt-arquivo-inventario.Id-WD-SD = "SD":

                PUT UNFORMATTED 
                    tt-arquivo-inventario.codEstabel       ";"
                    tt-arquivo-inventario.WarehouseName    ";"
                    tt-arquivo-inventario.WarehouseAddress ";"
                    tt-arquivo-inventario.WarehouseCity    ";"
                    tt-arquivo-inventario.WarehouseState   ";"
                    tt-arquivo-inventario.WarehouseCountry ";"
                    tt-arquivo-inventario.WarehouseCep     ";"
                    tt-arquivo-inventario.ProductDesc      ";"
                    tt-arquivo-inventario.PartNumber       ";"
                    tt-arquivo-inventario.BuyerPartNumber  ";"
                    tt-arquivo-inventario.ProductQtInv     ";"
                    tt-arquivo-inventario.ProductQtRMA     ";"
                    tt-arquivo-inventario.ProductQtTransit ";"
                    tt-arquivo-inventario.ProductQtOrder   ";"
                    tt-arquivo-inventario.ProductStatus    ";"
                    SKIP.

        END.
        OUTPUT CLOSE.
    END.
    ELSE DO:
    
        /**** SANDISK ****/
        ASSIGN cSenderID        = "2004573   "
               cDistributorName = "INTELBRAS S/A - BRAZIL"
               cReceiverID      = "051983567WDC"
               cInterchangeDate = SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99")
               cInterchangeTime = REPLACE(STRING(TIME,"HH:MM"),":","")
               i-cont-ge = 0
               i-seq_edi_wd     = NEXT-VALUE(seq_edi_wd).
    
        DEF VAR X AS CHAR NO-UNDO.
    
        OUTPUT TO VALUE(tt-prog-ponto2.conteudo + "\846SD" + STRING(i-seq_edi_wd,"999999999") + STRING(YEAR(c-data),"9999") + STRING(MONTH(c-data),"99") + STRING(DAY(c-data),"99") + ".wd") CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
    
        PUT UNFORMATTED X.
    
        PUT UNFORMATTED "ISA*00*          *00*          *14*" + cSenderID + "     *14*" + cReceiverID + "   *" + cInterchangeDate + "*" + cInterchangeTime + "*U*00401*" + STRING(i-seq_edi_wd,"999999999") + "*0*P*>" + "~~" SKIP.
        PUT UNFORMATTED "GS*IB*" + TRIM(cSenderID) + "*SANDISK*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "*" + REPLACE(STRING(TIME,"HH:MM"),":","") + "*462*X*004010" + "~~" SKIP.
        
        FOR EACH tt-arquivo-inventario
           WHERE tt-arquivo-inventario.Id-WD-SD = "SD":
    
            ASSIGN i-cont-ge = i-cont-ge + 1.
    
            PUT UNFORMATTED "ST*846*0001" + "~~" SKIP.
            PUT UNFORMATTED "BIA*00*DD*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + string(i-cont-ge) /*REPLACE(STRING(TIME,"HH:MM:SS"),":","")*/ + "*" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "~~" SKIP.
            PUT UNFORMATTED "N1*DS*" + cDistributorName + "*92*" + TRIM(cSenderID) + "~~" SKIP.
            PUT UNFORMATTED "N1*WH*" + tt-arquivo-inventario.WarehouseName + "*92*" + tt-arquivo-inventario.codEstabel + "~~" SKIP.
            PUT UNFORMATTED "N3*"    + tt-arquivo-inventario.WarehouseAddress + "~~" SKIP.
            PUT UNFORMATTED "N4*"    + "SÆo Jos‚" /*tt-arquivo-inventario.WarehouseCity*/ + "*" + tt-arquivo-inventario.WarehouseState + "*" + STRING(tt-arquivo-inventario.WarehouseCep) + "*" + tt-arquivo-inventario.WarehouseCountry + "~~" SKIP.
            PUT UNFORMATTED "LIN*1*VP*" + tt-arquivo-inventario.PartNumber + "*BP*" + tt-arquivo-inventario.BuyerPartNumber + "~~" SKIP.
            PUT UNFORMATTED "QTY*17*" + STRING(tt-arquivo-inventario.ProductQtInv    ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*20*" + STRING(tt-arquivo-inventario.ProductQtRMA    ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*IQ*" + STRING(tt-arquivo-inventario.ProductQtTransit) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "QTY*63*" + STRING(tt-arquivo-inventario.ProductQtOrder  ) + "*EA" + "~~" SKIP.
            PUT UNFORMATTED "CTT*1" + "~~" SKIP.
            PUT UNFORMATTED "SE*13*0001" + "~~" SKIP.
        
        END.
    
        PUT UNFORMATTED "GE*" + STRING(i-cont-ge) + "*462" + "~~"  SKIP.
        PUT UNFORMATTED "IEA*1*" + STRING(i-seq_edi_wd,"999999999") + "~~" SKIP.
    
        OUTPUT CLOSE.

    END.

END PROCEDURE.

PROCEDURE pi-busca-posicao :

    DEFINE INPUT  PARAMETER p-cod-estabel   LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque      LIKE embarque-imp.embarque NO-UNDO.

    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.situacao    = 1
         AND embarque-imp.cod-estabel = p-cod-estabel
         AND embarque-imp.embarque    = p-embarque:

        {esp/imp/esimp000.i}
        
    END.

    RETURN "OK":U.

END PROCEDURE.

