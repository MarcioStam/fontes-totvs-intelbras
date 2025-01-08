 /*********************************************************************************
** Programa: esp/pdp/espdp083rp.p
** Vers∆o..: 1.00
** Data....: 07/04/2015
** Autor...: Julliano da Silva - Vertical TI
** Obs.....: Atualizacao Automatica de Pedidos OEM.
*********************************************************************************/
{include/i-prgvrs.i espdp083rp 2.00.00.000}  

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    FIELD tp-execucao          AS INTEGER
    FIELD cod-estabel-de       AS CHARACTER
    FIELD cod-estabel-ate      AS CHARACTER
    FIELD cod-serie-de         AS CHARACTER
    FIELD cod-serie-ate        AS CHARACTER
    FIELD nr-nota-fiscal-de    AS CHARACTER
    FIELD nr-nota-fiscal-ate   AS CHARACTER
    FIELD dt-emissao-de        AS DATE
    FIELD dt-emissao-ate       AS DATE
    FIELD nm-abrev-cliente-de  AS CHARACTER
    FIELD nm-abrev-cliente-ate AS CHARACTER
    FIELD log-execucao-batch   AS LOGICAL.

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE TEMP-TABLE tt-ped-item NO-UNDO
    FIELD nome-abrev   AS CHARACTER
    FIELD nr-pedcli    AS CHARACTER
    FIELD it-codigo    AS CHARACTER
    FIELD nr-sequencia AS INTEGER
    FIELD cod-refer    AS CHARACTER
    FIELD dt-entrega   AS DATE
    FIELD qt-un-fat    AS DECIMAL
    FIELD qt-pedida    AS DECIMAL.

DEFINE TEMP-TABLE tt-item-tot NO-UNDO
    FIELD it-codigo  AS CHARACTER
    FIELD qt-pedida  AS DECIMAL
    FIELD qt-tot-per AS DECIMAL
    FIELD qt-tot-mes AS DECIMAL
    FIELD qt-un-fat  AS DECIMAL.

DEFINE TEMP-TABLE tt-dev NO-UNDO
    FIELD it-codigo    AS CHARACTER
    FIELD qt-devolvida AS DECIMAL
    FIELD qt-devol-mes AS DECIMAL.

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO
    FIELD nome-abrev AS CHARACTER
    FIELD nr-pedcli  AS CHARACTER.

DEFINE TEMP-TABLE tt-ped-item-aux NO-UNDO LIKE ped-item
    FIELD r-rowid AS ROWID.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE h-acomp                AS HANDLE                             NO-UNDO.
DEFINE VARIABLE bo-ped-venda           AS HANDLE                             NO-UNDO.
DEFINE VARIABLE bo-ped-venda-can       AS HANDLE                             NO-UNDO.
DEFINE VARIABLE bo-ped-item            AS HANDLE                             NO-UNDO.
DEFINE VARIABLE bo-ped-item-can        AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bodi159com           AS HANDLE                             NO-UNDO.
DEFINE VARIABLE d-qt-aux               AS INTEGER                            NO-UNDO.
DEFINE VARIABLE d-dt-aux-de            AS DATE                               NO-UNDO.
DEFINE VARIABLE d-dt-aux-ate           AS DATE                               NO-UNDO.
DEFINE VARIABLE d-total-per            AS DECIMAL   format "->,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE d-total-mes            AS DECIMAL   format "->,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE d-total-ped            AS DECIMAL   format "->,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE d-total-un             AS DECIMAL   format "->,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE c-erro-item            AS CHARACTER FORMAT "X(200)"          NO-UNDO.
DEFINE VARIABLE d-qt-pedida-atualizado AS DECIMAL                            NO-UNDO.
DEFINE VARIABLE l-ok                   AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE d-qt-pedida-aux        AS DECIMAL                            NO-UNDO.
DEFINE VARIABLE d-qt-pv-anterior       AS DECIMAL                            NO-UNDO.
DEFINE VARIABLE d-dt-base              AS DATE                               NO-UNDO.
DEFINE VARIABLE l-ASTEC                AS LOG                                NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)"  NO-UNDO.

DEFINE BUFFER b-ped-item FOR ped-item.
DEFINE BUFFER b-int-nota-fiscal FOR int-nota-fiscal.
def stream s-imp.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
   
{utp/ut-glob.i}
{method/dbotterr.i}
{utp/utapi019.i}
    
/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Atualizando Pedidos OEM").

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa      NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

IF tt-param.destino = 3 THEN /* Terminal */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ESPDP083.tmp".

IF tt-param.tp-execucao = 2 THEN /* batch */   
    ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.

OUTPUT TO VALUE(tt-param.arquivo) NO-CONVERT.

IF log-execucao-batch THEN /* Obtem Data Corrente */
    ASSIGN tt-param.dt-emissao-de  = TODAY - 1
           tt-param.dt-emissao-ate = TODAY.
          
PUT  SKIP(3) 
    "PAR∂METROS DE SELEÄ«O" SKIP(2)
    "Estabelecimento Inicial: " tt-param.cod-estabel-de                          skip
    "Estabelecimento Final:   " tt-param.cod-estabel-ate                         skip
    "Serie Inicial:           " tt-param.cod-serie-de                            skip
    "Serie Final:             " tt-param.cod-serie-ate                           skip
    "Nota Fiscal Inicial:     " tt-param.nr-nota-fiscal-de                       skip
    "Nota Fiscal Final:       " tt-param.nr-nota-fiscal-ate                      skip
    "Data Emiss∆o Inicial:    " tt-param.dt-emissao-de      FORMAT "99/99/9999"  skip
    "Data Emiss∆o Final:      " tt-param.dt-emissao-ate     FORMAT "99/99/9999"  skip
    "Cliente Inicial:         " tt-param.nm-abrev-cliente-de                     skip
    "Cliente Final:           " tt-param.nm-abrev-cliente-ate                    skip
    "Execuá∆o em Batch:       " tt-param.log-execucao-batch FORMAT "Sim/N∆o"
    SKIP(2).  

PUT "PEDIDOS ATUALIZADOS" skip(2)
    "Estab  SÇrie  Nota Fiscal Cliente      Pedido Cliente  Item           Prev.Fatur  Qtd Faturada NF   Qtd PV Anterior  Qtd PV Atual   Observaá∆o" SKIP
    "-----  -----  ----------- ------------ --------------  -------------- ----------  ---------------   ---------------- -------------  -------------------------" SKIP.

EMPTY TEMP-TABLE tt-item-tot.
EMPTY TEMP-TABLE tt-ped-item.
EMPTY TEMP-TABLE tt-dev.
EMPTY TEMP-TABLE tt-ped-venda.

IF d-dt-base <= tt-param.dt-emissao-de THEN
    ASSIGN d-dt-aux-de = d-dt-base.
ELSE
    ASSIGN d-dt-aux-de = tt-param.dt-emissao-de.

ASSIGN d-dt-aux-de = DATE(MONTH(d-dt-aux-de),01,YEAR(d-dt-aux-de)).

/* Tratamento para selecionar o faturamento inteiro do mes */
IF MONTH(d-dt-aux-de) = 12 THEN
    ASSIGN d-dt-aux-ate = DATE(01,01,YEAR(d-dt-aux-de) + 1) - 1.
ELSE
    ASSIGN d-dt-aux-ate = DATE(MONTH(d-dt-aux-de) + 1,01,YEAR(d-dt-aux-de + 1)) - 1.

PUT " DATA DE PREV DE FATURAMENTO DE PEDIDOS CONSIDERADA -> : " d-dt-aux-de " ATê " d-dt-aux-ate   SKIP.

RUN pi-seleciona-pedidos.
RUN pi-atualiza-devolucao.

DO TRANSACTION:

    RUN pi-atualiza-astec.
    
    RUN pi-atualiza-notas.
     
    RUN pi-completa-pedido.
    
END.

PROCEDURE pi-atualiza-astec:
     
    ASSIGN l-ASTEC = YES.

    FOR EACH movto-estoq NO-LOCK
        WHERE movto-estoq.dt-trans   >= tt-param.dt-emissao-de       
          AND movto-estoq.dt-trans   <= tt-param.dt-emissao-ate      
          AND movto-estoq.cod-depos  = "epv"            
          AND movto-estoq.tipo-trans = 1                   
          AND movto-estoq.esp-docto  = 33: /* Saida */
        
        /* Se j† realizou a soma de pedido OEM - desconsidera */
        IF  CAN-FIND(int-movto-estoq
                        WHERE int-movto-estoq.nr-trans = movto-estoq.nr-trans
                          AND int-movto-estoq.atualizou-OEM) THEN
            NEXT.

        /* T O T A L I Z A Ä « O */
        FIND tt-item-tot
            WHERE tt-item-tot.it-codigo = movto-estoq.it-codigo NO-ERROR.

        IF  NOT AVAIL tt-item-tot THEN DO:
            CREATE tt-item-tot.
            ASSIGN tt-item-tot.it-codigo = movto-estoq.it-codigo.
        END.

         /* Descarta as notas fiscais emitidas antes da importacao dos pedidos OEM */
        IF  movto-estoq.dt-trans >= d-dt-base THEN
            ASSIGN tt-item-tot.qt-tot-mes = tt-item-tot.qt-tot-mes + movto-estoq.quantidade.

        /* Descarta as notas fiscais que estao fora do periodo selecionado pelo usuario */
        IF  movto-estoq.dt-trans  >= tt-param.dt-emissao-de    
        AND movto-estoq.dt-trans  <= tt-param.dt-emissao-ate THEN
            ASSIGN tt-item-tot.qt-tot-per = tt-item-tot.qt-tot-per + movto-estoq.quantidade.

        ASSIGN d-qt-aux = movto-estoq.quantidade.

        DO TRANSACTION:

            /* Diminui as quantidades ou cancela os itens e pedidos faturados */
            FOR EACH tt-ped-item
               WHERE tt-ped-item.it-codigo = movto-estoq.it-codigo
                  BY tt-ped-item.dt-entrega:

                ASSIGN c-erro-item = "".

                RUN pi-atualiza-pedidos.

                IF d-qt-aux = 0 THEN LEAVE.
            END. 

        END.  /****** DO TRANSACTION **********/
        
        
    END.

    ASSIGN l-ASTEC = NO.
END.

PROCEDURE pi-atualiza-notas:
        
    /* Seleciona as notas fiscais faturadas */
    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-de
          AND nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-ate
          AND nota-fiscal.emite-duplic  = YES
          AND nota-fiscal.esp-docto     = 22: /* Saida */

        //nao atualizar pedido q nao baixa estoque - remessa 
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-oper = nota-fiscal.nat-oper NO-ERROR.
        IF AVAIL natur-oper THEN
            IF natur-oper.baixa-estoq = NO THEN NEXT.

        IF  nota-fiscal.dt-cancela <> ?
        AND nota-fiscal.dt-cancela = nota-fiscal.dt-emis-nota  THEN NEXT. /* quando a nota Ç cancelada no dia seguinte do faturamento a quantidade dela deve ser adicionada Ö PV */
        /*Chamado 66585*/
        IF nota-fiscal.nr-pedcli <> "" THEN DO:
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                   AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

            IF AVAIL ped-venda THEN DO:
                FIND FIRST int-ped-venda NO-LOCK
                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

                IF  AVAIL int-ped-venda
                AND SUBSTRING(int-ped-venda.char-1, 11, 1) = "S" THEN 
                    NEXT.
            END.
        END.
    
        /* Totalizacao */
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
              EACH ITEM NO-LOCK
                  WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
                    AND ITEM.ge-codigo = 45 /* Produto Acabado OEM */: 
        
            FIND tt-item-tot
                WHERE tt-item-tot.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
        
            IF NOT AVAIL tt-item-tot THEN DO:
                CREATE tt-item-tot.
                ASSIGN tt-item-tot.it-codigo = it-nota-fisc.it-codigo.
            END.
        
             /* Descarta as notas fiscais emitidas antes da importacao dos pedidos OEM */
            IF nota-fiscal.dt-emis-nota >= d-dt-base THEN
                ASSIGN tt-item-tot.qt-tot-mes = tt-item-tot.qt-tot-mes + it-nota-fisc.qt-faturada[1].
        
            /* Descarta as notas fiscais que estao fora do periodo selecionado pelo usuario */
            IF nota-fiscal.dt-emis-nota  >= tt-param.dt-emissao-de    AND 
               nota-fiscal.dt-emis-nota  <= tt-param.dt-emissao-ate   THEN
                ASSIGN tt-item-tot.qt-tot-per = tt-item-tot.qt-tot-per + it-nota-fisc.qt-faturada[1].
        END.
    
    
        /*Se Ja realizou soma de pedido OEM, desconsidera */
        IF nota-fiscal.dt-cancela <> ?
            AND nota-fiscal.dt-cancela <> nota-fiscal.dt-emis-nota  THEN DO:
            FIND FIRST int-nota-fiscal NO-LOCK
                WHERE int-nota-fiscal.cod-estabel             = nota-fiscal.cod-estabel
                  and int-nota-fiscal.serie                   = nota-fiscal.serie
                  and int-nota-fiscal.nr-nota-fis             = nota-fiscal.nr-nota-fis
                  and substring(int-nota-fiscal.char-1,44,1)  = "1" NO-ERROR. 

            IF AVAIL int-nota-fiscal THEN NEXT.

        END.
        ELSE DO:
            /*Se Ja realizou baixa de pedido OEM, desconsidera */
            FIND FIRST int-nota-fiscal NO-LOCK
                WHERE int-nota-fiscal.cod-estabel             = nota-fiscal.cod-estabel
                  and int-nota-fiscal.serie                   = nota-fiscal.serie
                  and int-nota-fiscal.nr-nota-fis             = nota-fiscal.nr-nota-fis
                  and substring(int-nota-fiscal.char-1,43,1)  = "1" NO-ERROR. 

            IF AVAIL int-nota-fiscal THEN NEXT.

        END.

        /* it-nota-fisc retirado do for each principal para permitir a atualizacao de todos os itens de uma nota */
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
              first ITEM NO-LOCK
                  WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
                    AND ITEM.ge-codigo = 45 /* Produto Acabado OEM */: 
    
            RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal: " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
                                             
            /* Descarta as notas fiscais que estao fora do periodo selecionado pelo usuario */
            IF nota-fiscal.dt-emis-nota < tt-param.dt-emissao-de   OR 
               nota-fiscal.dt-emis-nota > tt-param.dt-emissao-ate  THEN NEXT.
        
             /* Descarta as notas fiscais que estao fora da selecao do usuario */
            IF nota-fiscal.cod-estabel < tt-param.cod-estabel-de OR 
                nota-fiscal.cod-estabel > tt-param.cod-estabel-ate THEN NEXT.
        
             /* Descarta as notas fiscais que estao fora da selecao do usuario */
            IF nota-fiscal.serie < tt-param.cod-serie-de OR 
                nota-fiscal.serie > tt-param.cod-serie-ate THEN NEXT.
        
            /* Descarta as notas fiscais que estao fora da selecao do usuario */
            IF nota-fiscal.nr-nota-fis < tt-param.nr-nota-fiscal-de OR 
                nota-fiscal.nr-nota-fis > tt-param.nr-nota-fiscal-ate THEN NEXT.
        
             /* Descarta as notas fiscais que estao fora da selecao do usuario */
            IF nota-fiscal.nome-abrev < tt-param.nm-abrev-cliente-de OR 
                nota-fiscal.nome-abrev > tt-param.nm-abrev-cliente-ate THEN NEXT.
            
            ASSIGN d-qt-aux = it-nota-fisc.qt-faturada[1].
                       
            DO TRANSACTION:
        
                /* Diminui as quantidades ou cancela os itens e pedidos faturados */
                FOR EACH tt-ped-item
                   WHERE tt-ped-item.it-codigo = it-nota-fisc.it-codigo
                      BY tt-ped-item.dt-entrega:
        
                    ASSIGN c-erro-item = "".
        
                    RUN pi-atualiza-pedidos.
        
                    IF d-qt-aux = 0 THEN LEAVE.
                END. 
        
            END.  /****** DO TRANSACTION **********/
    
        END. /* for each it-nota-fisc */
    
    END. /* FOR EACH nota-fiscal */

END PROCEDURE.

RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo resumo por Item...").

RUN pi-resumo-item.

OUTPUT CLOSE.

FOR FIRST ponto-programa NO-LOCK
     WHERE ponto-programa.nome-programa = "espdp083"
       AND ponto-programa.ponto         = 1,
      EACH conteudo-programa NO-LOCK
     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

     RUN pi-envia-email (input conteudo-programa.conteudo).

 END. /* FOR FIRST ponto-programa */

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE (bo-ped-item) THEN DO:
    RUN DestroyBO in bo-ped-item.
    ASSIGN bo-ped-item = ?.
END.

IF VALID-HANDLE (bo-ped-item-can) THEN DO:
    RUN DestroyBO in bo-ped-item-can.
    ASSIGN bo-ped-item-can = ?.
END.

IF VALID-HANDLE (bo-ped-venda) THEN DO:
    RUN DestroyBO in bo-ped-venda.
    ASSIGN bo-ped-venda = ?.
END.

IF VALID-HANDLE (bo-ped-venda-can) THEN DO:
    RUN DestroyBO in bo-ped-venda-can.
    ASSIGN bo-ped-venda-can = ?.
END.

IF VALID-HANDLE (h-bodi159com) THEN DO:
    RUN destroyBO in h-bodi159com.

    IF VALID-HANDLE (h-bodi159com) THEN DO:
        RUN destroyBO   in h-bodi159com.
    END.
    ASSIGN h-bodi159com = ?.
END.

PROCEDURE pi-seleciona-pedidos:

    ASSIGN d-dt-base = ?.

    /* Seleciona os pedidos OEM do mes */
    FOR EACH ped-venda NO-LOCK 
        WHERE ped-venda.cod-priori   = 44
          AND ped-venda.tp-pedido    = "34"
          AND ped-venda.cod-sit-ped <= 2
        BY ped-venda.dt-entrega: /* Aberto e atendido parcialmente */

        //nao atualizar pedido q nao baixa estoque - remessa 
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-oper = ped-venda.nat-oper NO-ERROR.
        IF AVAIL natur-oper THEN
            IF natur-oper.baixa-estoq = NO THEN NEXT.
    
        FOR EACH ped-item NO-LOCK
            WHERE ped-item.nome-abrev    = ped-venda.nome-abrev
              AND ped-item.nr-pedcli     = ped-venda.nr-pedcli 
              AND ped-item.dt-entrega   >= d-dt-aux-de  
              AND ped-item.dt-entrega   <= d-dt-aux-ate 
              AND ped-item.cod-sit-item <= 2: /* Aberto e atendido parcialmente */

            /* Data de implantacao dos pedidos OEM */
            IF d-dt-base = ? OR d-dt-base > ped-venda.dt-implant THEN
                ASSIGN d-dt-base = ped-venda.dt-implant.
    
            CREATE tt-ped-item.
            ASSIGN tt-ped-item.nome-abrev   = ped-item.nome-abrev  
                   tt-ped-item.nr-pedcli    = ped-item.nr-pedcli   
                   tt-ped-item.it-codigo    = ped-item.it-codigo   
                   tt-ped-item.nr-sequencia = ped-item.nr-sequencia
                   tt-ped-item.cod-refer    = ped-item.cod-refer   
                   tt-ped-item.dt-entrega   = ped-item.dt-entrega
                   tt-ped-item.qt-un-fat    = ped-item.qt-un-fat
                   tt-ped-item.qt-pedida    = ped-item.qt-pedida.
    
            FIND tt-item-tot
                WHERE tt-item-tot.it-codigo = ped-item.it-codigo NO-ERROR.
    
            IF NOT AVAIL tt-item-tot THEN DO:
                CREATE tt-item-tot.
                ASSIGN tt-item-tot.it-codigo = ped-item.it-codigo.
            END.
     
        END. /* FOR EACH ped-item */

        /* Atualiza Data Base quando nao encontrado Item */
        IF d-dt-base = ? THEN
            ASSIGN d-dt-base = ped-venda.dt-implant.
    
    END. /* FOR EACH ped-venda */

END PROCEDURE.

PROCEDURE pi-atualiza-pedidos:


    FIND FIRST ped-item NO-LOCK
        WHERE ped-item.nome-abrev   = tt-ped-item.nome-abrev  
          and ped-item.nr-pedcli    = tt-ped-item.nr-pedcli   
          and ped-item.it-codigo    = tt-ped-item.it-codigo   
          and ped-item.nr-sequencia = tt-ped-item.nr-sequencia
          and ped-item.cod-refer    = tt-ped-item.cod-refer NO-ERROR.
                 
    IF NOT AVAIL ped-item THEN NEXT.
     
    FIND FIRST ped-venda EXCLUSIVE-LOCK 
        WHERE ped-venda.nome-abrev = tt-ped-item.nome-abrev 
          AND ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli NO-ERROR.
                   
    IF NOT AVAIL ped-venda THEN NEXT.

    ASSIGN ped-venda.completo = NO.

    FIND FIRST emitente
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

    FIND FIRST tt-ped-venda
        WHERE tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
          AND tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli NO-ERROR.

    IF NOT AVAIL tt-ped-venda THEN DO:
        CREATE tt-ped-venda.
        ASSIGN tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
               tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli.
    END.

    ASSIGN d-qt-pedida-atualizado = ped-item.qt-pedida
           d-qt-pv-anterior       = ped-item.qt-pedida.

    FIND CURRENT ped-venda NO-LOCK.

    IF l-ASTEC = NO 
    AND AVAIL nota-fiscal
    AND nota-fiscal.dt-cancela <> ? /* Quando a nota esta cancelada devera somar a quantidade da nota na PV */
    AND nota-fiscal.dt-cancela <> nota-fiscal.dt-emis-nota  THEN DO:

            RUN pi-altera-item.
            ASSIGN c-erro-item = "Nota Cancelada Quantidade Adicionada ao Pedido!".
            IF CAN-FIND (FIRST rowErrors  
                            WHERE RowErrors.ErrorType   <> "INTERNAL"
                              AND RowErrors.ErrorSubType = "Error":U) THEN DO:

                ASSIGN c-erro-item = "".
                FOR EACH rowErrors
                    WHERE RowErrors.ErrorType   <> "INTERNAL"
                      AND RowErrors.ErrorSubType = "Error":U:

                    ASSIGN c-erro-item = c-erro-item + " " + string(RowErrors.errorNumber) + " - " + RowErrors.errorDescription.
                END.
            END.
            ELSE 
                ASSIGN d-qt-aux = 0
                       d-qt-pedida-atualizado = tt-ped-item-aux.qt-pedida.
    END.
    ELSE DO:

        /* Pedido possui qtdade superior ao faturado */
        IF ped-item.qt-pedida > d-qt-aux THEN DO:

            RUN pi-altera-item.

            IF CAN-FIND (FIRST rowErrors  
                            WHERE RowErrors.ErrorType   <> "INTERNAL"
                              AND RowErrors.ErrorSubType = "Error":U) THEN DO:

                ASSIGN c-erro-item = "".
                FOR EACH rowErrors
                    WHERE RowErrors.ErrorType   <> "INTERNAL"
                      AND RowErrors.ErrorSubType = "Error":U:

                    ASSIGN c-erro-item = c-erro-item + " " + string(RowErrors.errorNumber) + " - " + RowErrors.errorDescription.
                END.
            END.
            ELSE 
                ASSIGN d-qt-aux = 0
                       d-qt-pedida-atualizado = tt-ped-item-aux.qt-pedida.


        END. /* ped-item.qt-pedida > d-qt-aux */
        ELSE DO:

            ASSIGN d-qt-pedida-aux = ped-item.qt-pedida.

            RUN pi-cancela-item.

            IF CAN-FIND (FIRST RowErrors
                             WHERE RowErrors.ErrorType   <> "INTERNAL"
                               AND RowErrors.ErrorSubType = "Error":U) THEN DO:

                ASSIGN c-erro-item = "".
                FOR EACH rowErrors
                    WHERE RowErrors.ErrorType   <> "INTERNAL"
                      AND RowErrors.ErrorSubType = "Error":U:

                    ASSIGN c-erro-item = c-erro-item + " " + string(RowErrors.errorNumber) + " - " + RowErrors.errorDescription.
                END.
            END.
            ELSE DO:

                ASSIGN c-erro-item            = " Item Cancelado!"
                       d-qt-pedida-atualizado = 0.

                IF d-qt-pedida-aux = d-qt-aux THEN
                    ASSIGN d-qt-aux = 0.
                ELSE
                    ASSIGN d-qt-aux = d-qt-aux - d-qt-pedida-aux.
            END.

            IF NOT CAN-FIND(FIRST b-ped-item
                            WHERE b-ped-item.nome-abrev    = tt-ped-item.nome-abrev
                              and b-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
                              and (b-ped-item.nr-sequencia <> tt-ped-item.nr-sequencia
                                   OR b-ped-item.it-codigo <> tt-ped-item.it-codigo
                                   OR b-ped-item.cod-refer <> tt-ped-item.cod-refer )
                              AND  b-ped-item.cod-sit-item <> 6) /* Cancelado */ THEN DO:

                RUN pi-cancela-pedido.

                IF CAN-FIND (FIRST RowErrors
                                WHERE RowErrors.ErrorType   <> "INTERNAL"
                                  AND RowErrors.ErrorSubType = "Error":U
                                  AND RowErrors.errorNumber <> 4916) /* Msg de advertencia que nao impede o cancelamento */
                    THEN DO:

                    ASSIGN c-erro-item = "".
                    FOR EACH rowErrors
                        WHERE RowErrors.ErrorType   <> "INTERNAL"
                          AND RowErrors.ErrorSubType = "Error":U:

                        ASSIGN c-erro-item = c-erro-item + " " + string(RowErrors.errorNumber) + " - " + RowErrors.errorDescription.
                    END.
                END.
                ELSE 
                    ASSIGN c-erro-item = " Pedido Cancelado!".

            END. /* NOT CAN-FIND FIRST b-ped-item */

        END. /* ped-item.qt-pedida > d-qt-aux */

    END.


    IF  l-ASTEC = NO  THEN DO:
        FIND FIRST b-int-nota-fiscal EXCLUSIVE-LOCK
              WHERE b-int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                and b-int-nota-fiscal.serie       = nota-fiscal.serie      
                and b-int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                NO-ERROR. /* Pendente de baixa de pedido OEM */
    
    /*     output stream s-imp to '/opt/totvs/spool/an046325/espdp083_log.txt' append.                */
    /*                                                                                                */
    /*     PUT STREAM s-imp string(today) " Antes Atualizar a nota "  nota-fiscal.cod-estabel     " " */
    /*                                                 nota-fiscal.serie           " "                */
    /*                                                 nota-fiscal.nr-nota-fis     " "                */
    /*                                                 AVAIL b-int-nota-fiscal SKIP.                  */
    
    
        IF NOT AVAIL b-int-nota-fiscal THEN DO:
            CREATE b-int-nota-fiscal.
            ASSIGN b-int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                   b-int-nota-fiscal.serie       = nota-fiscal.serie
                   b-int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis.
            IF nota-fiscal.dt-cancela <> ?
                AND nota-fiscal.dt-cancela <> nota-fiscal.dt-emis-nota  THEN DO:
                ASSIGN OVERLAY(b-int-nota-fiscal.char-1,44,1) = "1".    
    
            END.
            ELSE
                ASSIGN OVERLAY(b-int-nota-fiscal.char-1,43,1) = "1".
    /*         put STREAM s-imp unformatted string(today) "Criou Registro;" b-int-nota-fiscal.cod-estabel  ";" b-int-nota-fiscal.serie ";"  b-int-nota-fiscal.nr-nota-fis ";char-1 ->" substring(b-int-nota-fiscal.char-1,43,1)  skip. */
        END.
        ELSE DO:
            IF nota-fiscal.dt-cancela <> ?
            AND nota-fiscal.dt-cancela <> nota-fiscal.dt-emis-nota  THEN DO:
                ASSIGN OVERLAY(b-int-nota-fiscal.char-1,44,1) = "1".    
            
            END.
            ELSE
                if substring(b-int-nota-fiscal.char-1,43,1) <> "1" THEN DO:
                    ASSIGN OVERLAY(b-int-nota-fiscal.char-1,43,1) = "1".
    /*                 put STREAM s-imp unformatted string(today) "Atualizou Registro ;" b-int-nota-fiscal.cod-estabel  ";" b-int-nota-fiscal.serie ";"  b-int-nota-fiscal.nr-nota-fis ";char-1 ->" substring(b-int-nota-fiscal.char-1,43,1)  skip. */
        
                END.
        END.
            
    END.
    ELSE DO:
        /*  P A R A   A S T E C  apenas cliente 195035 */

        FIND FIRST int-movto-estoq EXCLUSIVE-LOCK
            WHERE int-movto-estoq.nr-trans = movto-estoq.nr-trans NO-ERROR.

        IF  NOT AVAIL int-movto-estoq THEN DO:
            CREATE int-movto-estoq.
            ASSIGN int-movto-estoq.nr-trans      = movto-estoq.nr-trans
                   int-movto-estoq.atualizou-OEM = YES
                   int-movto-estoq.data-atualiz  = TODAY
                   int-movto-estoq.nr-pedido     = ped-venda.nr-pedido.
        END.
    END.

/*     output STREAM s-imp close. */
        
    release b-int-nota-fiscal.    

    IF  l-ASTEC = NO THEN
        PUT nota-fiscal.cod-estabel
            nota-fiscal.serie                                AT 12 
            nota-fiscal.nr-nota-fis     FORMAT "X(11)"       AT 17 
            tt-ped-item.nome-abrev      FORMAT "X(12)"       AT 28 
            tt-ped-item.nr-pedcli                            AT 43 
            tt-ped-item.it-codigo       FORMAT "X(14)"       AT 57 
            tt-ped-item.dt-entrega      FORMAT "99/99/9999"  AT 73 
            it-nota-fisc.qt-faturada[1] FORMAT ">>>,>>9.99"  AT 90
            /*
            tt-ped-item.qt-pedida       FORMAT ">>>,>>9.99"  AT 109
            */
            d-qt-pv-anterior            FORMAT ">>>,>>9.99"  AT 109
            d-qt-pedida-atualizado      FORMAT ">>>,>>9.99"  AT 124
            c-erro-item                                      AT 135 SKIP.
    ELSE
        PUT movto-estoq.cod-estabel
            " - "                                            AT 12 
            " - "                       FORMAT "X(11)"       AT 17 
            tt-ped-item.nome-abrev      FORMAT "X(12)"       AT 28 
            tt-ped-item.nr-pedcli                            AT 43 
            tt-ped-item.it-codigo       FORMAT "X(14)"       AT 57 
            tt-ped-item.dt-entrega      FORMAT "99/99/9999"  AT 73 
            movto-estoq.quantidade      FORMAT ">>>,>>9.99"  AT 90
            /*
            tt-ped-item.qt-pedida       FORMAT ">>>,>>9.99"  AT 109
            */
            d-qt-pv-anterior            FORMAT ">>>,>>9.99"  AT 109
            d-qt-pedida-atualizado      FORMAT ">>>,>>9.99"  AT 124
            c-erro-item                                      AT 135 SKIP.

                                                       
END PROCEDURE.

PROCEDURE pi-resumo-item:

    PUT SKIP(4)
        "RESUMO POR ITEM - DATA BASE " STRING(d-dt-base) SKIP(2)
        "Item             Qtde Fat Per    Qtde Fat Mes     Qtde PV Anterior    Qtd PV Atual"   SKIP
        "---------------- ------------    -------------    ----------------    --------------" SKIP.

    ASSIGN d-total-per = 0
           d-total-mes = 0
           d-total-ped = 0.

    FOR EACH tt-item-tot
        BY tt-item-tot.it-codigo:

        /* Verifica a sobra do pedido atualizada */
        FOR EACH ped-venda NO-LOCK 
            WHERE ped-venda.cod-priori   = 44
              AND ped-venda.tp-pedido    = "34"
              AND ped-venda.cod-sit-ped <= 2: /* Aberto e atendido parcialmente */
        
            FOR EACH ped-item NO-LOCK
                WHERE ped-item.nome-abrev    = ped-venda.nome-abrev
                  AND ped-item.nr-pedcli     = ped-venda.nr-pedcli 
                  AND ped-item.dt-entrega   >= DATE(MONTH(tt-param.dt-emissao-de),01,YEAR(tt-param.dt-emissao-de))
                  AND ped-item.dt-entrega   <= d-dt-aux-ate
                  AND ped-item.it-codigo     = tt-item-tot.it-codigo:
                  
                ASSIGN tt-item-tot.qt-un-fat = tt-item-tot.qt-un-fat + ped-item.qt-un-fat.
                
                IF ped-item.cod-sit-item <= 2 THEN /* Aberto e atendido parcialmente */
                    ASSIGN tt-item-tot.qt-pedida = tt-item-tot.qt-pedida + ped-item.qt-pedida.                    
            END.
        END.

        FIND FIRST tt-dev 
            WHERE tt-dev.it-codigo = tt-item-tot.it-codigo NO-ERROR.

        IF AVAIL tt-dev THEN
            ASSIGN tt-item-tot.qt-tot-per = tt-item-tot.qt-tot-per - tt-dev.qt-devolvida
                   tt-item-tot.qt-tot-mes = tt-item-tot.qt-tot-mes - tt-dev.qt-devol-mes.
                         
        /* Para itens zerados, mostrar em valor negativo, a quantidade faturada a mais no mes */
        IF tt-item-tot.qt-tot-mes > 0                     AND 
           tt-item-tot.qt-tot-mes > tt-item-tot.qt-un-fat and
           tt-item-tot.qt-pedida  = 0 THEN
            ASSIGN tt-item-tot.qt-pedida = tt-item-tot.qt-un-fat - tt-item-tot.qt-tot-mes.

        PUT tt-item-tot.it-codigo  
            tt-item-tot.qt-tot-per  FORMAT "->,>>>,>>9.99"  AT 20
            tt-item-tot.qt-tot-mes  FORMAT "->,>>>,>>9.99" AT 37
            tt-item-tot.qt-un-fat   FORMAT ">,>>>,>>9.99"  AT 55 
            tt-item-tot.qt-pedida   FORMAT "->,>>>,>>9.99" AT 72 SKIP.

        ASSIGN d-total-per = d-total-per + tt-item-tot.qt-tot-per
               d-total-mes = d-total-mes + tt-item-tot.qt-tot-mes
               d-total-un  = d-total-un  + tt-item-tot.qt-un-fat
               d-total-ped = d-total-ped + tt-item-tot.qt-pedida.
    END.

    PUT "------------     --------------   ------------   -----------------    --------------" SKIP
        "TOTAL"
        d-total-per AT 18
        d-total-mes AT 35
        d-total-un  FORMAT "->>,>>>,>>9.99"  AT 54
        d-total-ped FORMAT "->>,>>>,>>9.99"  AT 71 SKIP.

END PROCEDURE.

PROCEDURE pi-cancela-item:
                            
    IF NOT VALID-HANDLE(bo-ped-item-can)                OR
       bo-ped-item-can:TYPE <> "PROCEDURE":U            OR
       bo-ped-item-can:FILE-NAME <> "dibo/bodi154can.p" THEN
        RUN dibo/bodi154can.p PERSISTENT SET bo-ped-item-can.

    RUN setUserLog in bo-ped-item-can (INPUT c-seg-usuario).
    RUN validateCancelation in bo-ped-item-can (INPUT ROWID(ped-item),
                                                INPUT "Cancelamento realizado pela rotina de atualizaá∆o automatica de pedidos OEM",
                                                INPUT-OUTPUT TABLE RowErrors).

    IF NOT CAN-FIND (FIRST rowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                         AND RowErrors.ErrorSubType = "Error":U) AND NOT ped-venda.completo THEN DO:

        IF ped-item.ind-componen = 2 THEN
            RUN updateCancelationComposto IN bo-ped-item-can (INPUT ROWID(ped-item),
                                                              INPUT "Cancelamento realizado pela rotina de atualizaá∆o automatica de pedidos OEM",
                                                              INPUT TODAY,
                                                              INPUT 1).
        ELSE
            RUN updateCancelation IN bo-ped-item-can (INPUT ROWID(ped-item),                                                              
                                                      INPUT "Cancelamento realizado pela rotina de atualizaá∆o automatica de pedidos OEM",
                                                      INPUT TODAY,                                                                        
                                                      INPUT 1).                                                                           
    END.
   
    IF NOT CAN-FIND (FIRST rowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                         AND RowErrors.ErrorSubType = "Error":U) /* AND NOT ped-venda.completo */ THEN DO:
      
        FIND FIRST tt-ped-venda
            WHERE tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
              AND tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli NO-ERROR.

        IF NOT AVAIL tt-ped-venda THEN DO:
            CREATE tt-ped-venda.
            ASSIGN tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
                   tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli.
        END.
    END.

    IF VALID-HANDLE (bo-ped-item-can) THEN DO:
        RUN DestroyBO in bo-ped-item-can.
        DELETE PROCEDURE bo-ped-item-can.
        ASSIGN bo-ped-item-can = ?.
    END.

END PROCEDURE.

PROCEDURE pi-altera-item:

    EMPTY TEMP-TABLE tt-ped-item-aux.

    CREATE tt-ped-item-aux.
    BUFFER-COPY ped-item TO tt-ped-item-aux.

    IF  l-ASTEC = NO 
    AND AVAIL nota-fiscal
    AND nota-fiscal.dt-cancela <> ? /* Quando a nota esta cancelada devera somar a quantidade da nota na PV */
    AND nota-fiscal.dt-cancela <> nota-fiscal.dt-emis-nota  THEN 
        /* Soma quantidade do pedido */
        ASSIGN tt-ped-item-aux.qt-pedida = ped-item.qt-pedida + d-qt-aux.
    ELSE
        /* Diminui quantidade do pedido */
        ASSIGN tt-ped-item-aux.qt-pedida = ped-item.qt-pedida - d-qt-aux.

    IF tt-ped-item-aux.qt-pedida < 0 THEN
        ASSIGN tt-ped-item-aux.qt-pedida = 0.

    RUN dibo/bodi154.p PERSISTENT SET bo-ped-item.
    RUN emptyRowErrors  IN bo-ped-item.
    RUN openQueryStatic IN bo-ped-item (INPUT "Main"). 
    RUN goToKey         IN bo-ped-item (INPUT tt-ped-item-aux.nome-abrev,
                                        INPUT tt-ped-item-aux.nr-pedcli,
                                        INPUT tt-ped-item-aux.nr-sequencia,
                                        INPUT tt-ped-item-aux.it-codigo,
                                        INPUT tt-ped-item-aux.cod-refer).
        
    RUN setRecord    IN bo-ped-item (INPUT TABLE tt-ped-item-aux).
    RUN updateRecord IN bo-ped-item.
    RUN getRowErrors IN bo-ped-item (OUTPUT TABLE RowErrors).

    

    IF VALID-HANDLE (bo-ped-item) THEN DO:
        RUN DestroyBO in bo-ped-item.
        DELETE PROCEDURE bo-ped-item.
        ASSIGN bo-ped-item = ?.
    END.

    IF NOT CAN-FIND (FIRST rowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                         AND RowErrors.ErrorSubType = "Error":U) /* AND NOT ped-venda.completo */ THEN DO:

        FIND FIRST tt-ped-venda
            WHERE tt-ped-venda.nome-abrev = ped-item.nome-abrev
              AND tt-ped-venda.nr-pedcli  = ped-item.nr-pedcli NO-ERROR.

        IF NOT AVAIL tt-ped-venda THEN DO:
            CREATE tt-ped-venda.
            ASSIGN tt-ped-venda.nome-abrev = ped-item.nome-abrev
                   tt-ped-venda.nr-pedcli  = ped-item.nr-pedcli.
        END.
    END.  
   
    RETURN "OK". 
       
END PROCEDURE.

PROCEDURE pi-cancela-pedido:
   
    IF NOT VALID-HANDLE(bo-ped-venda-can) 
    OR bo-ped-venda-can:TYPE <> "PROCEDURE":U 
    OR bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
        RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.
	
    FIND FIRST emitente
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

    RUN emptyRowErrors  IN bo-ped-venda-can.
    RUN setUserLog IN bo-ped-venda-can (INPUT c-seg-usuario).

    RUN validateCancelation IN bo-ped-venda-can (INPUT  ROWID(ped-venda),
                                                 OUTPUT TABLE Rowerrors).

    IF NOT CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorType <> "INTERNAL"
                  AND RowErrors.ErrorSubType = "Error":U) THEN DO:


        RUN updateCancelation    IN bo-ped-venda-can(INPUT ROWID(ped-venda),
                                                     INPUT "Cancelamento realizado pela rotina de atualizaá∆o automatica de pedidos OEM",
                                                     INPUT TODAY,
                                                     INPUT 1).
    END.
   
    IF VALID-HANDLE (bo-ped-venda-can) THEN DO:
        DELETE PROCEDURE bo-ped-venda-can.
        ASSIGN bo-ped-venda-can = ?.
    END.
 
    RETURN "OK":U.  
     
END PROCEDURE.

PROCEDURE pi-envia-email:

    DEFINE INPUT PARAMETER c-email-dest AS CHARACTER NO-UNDO.

    define variable h-utapi019 as handle      no-undo.

    RUN pi-acompanhar in h-acomp (input "Enviando Email...").

    FIND FIRST param-global NO-LOCK. 
    
    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.porta             = param-global.porta-mail
           tt-envio.servidor          = param-global.serv-mail 
           tt-envio.destino           = c-email-dest
           tt-envio.remetente         = "ems@intelbras.com.br"
           tt-envio.assunto           = "Atualizaá∆o Autom†tica Pedidos OEM - " + STRING(TODAY,"99/99/9999")
           tt-envio.mensagem          = "Anexo segue relatorio contendo as atualizaá‰es realizadas." + CHR(10) + tt-param.arquivo
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = NO.          /*
           tt-envio.arq-anexo         = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE REPLACE(tt-param.arquivo,"/","~\").
                                           */

    IF tt-param.destino = 3 THEN /* Terminal */   
        ASSIGN tt-envio.arq-anexo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ES0951.tmp".
    ELSE
        ASSIGN tt-envio.arq-anexo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.

     run utp/utapi019.p persistent set h-utapi019.
     run utp/utapi009.p ( input  table tt-envio,
                          output  table tt-erros).

     delete object h-utapi019.

     IF CAN-FIND(FIRST tt-erros) THEN DO:
         OUTPUT TO VALUE(tt-param.arquivo) APPEND.
         PUT UNFORMATTED
             SKIP(2)
             "Erro    Descricao                                                        " AT 01
             "------- -----------------------------------------------------------------" AT 01 SKIP.
         FOR EACH tt-erros:
             PUT UNFORMATTED 
                  tt-erros.cod-erro  AT 01
                  tt-erros.desc-erro AT 09 SKIP.
         END.
         PUT UNFORMATTED SKIP(2).
         OUTPUT CLOSE.
     END.

END PROCEDURE.

PROCEDURE pi-atualiza-devolucao:

    FOR EACH tt-ped-item
        BREAK BY tt-ped-item.it-codigo
        BY tt-ped-item.dt-entrega:
        
        RUN pi-acompanhar IN h-acomp (INPUT "Atualizando devoluá‰es para o Item: " + tt-ped-item.it-codigo).
                
        IF FIRST-OF (tt-ped-item.it-codigo) THEN DO:

            FOR EACH devol-cli USE-INDEX ch-item NO-LOCK
                WHERE devol-cli.it-codigo = tt-ped-item.it-codigo
                  AND devol-cli.dt-devol >= tt-param.dt-emissao-de 
                  AND devol-cli.dt-devol <= tt-param.dt-emissao-ate,
                FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
                  AND nota-fiscal.serie         = devol-cli.serie
                  AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
                  AND nota-fiscal.emite-duplic  = YES:
               
                /* Descarta as devolucoes realizadas antes da importacao dos pedidos OEM */
                IF devol-cli.dt-devol >= d-dt-base THEN DO:
    
                    FIND FIRST tt-dev WHERE
                        tt-dev.it-codigo = devol-cli.it-codigo NO-ERROR.
        
                    IF AVAIL tt-dev THEN
                        ASSIGN tt-dev.qt-devol-mes = tt-dev.qt-devol-mes + devol-cli.qt-devolvida.
                    ELSE DO:
                        CREATE tt-dev.
                        ASSIGN tt-dev.it-codigo    = devol-cli.it-codigo
                               tt-dev.qt-devol-mes = devol-cli.qt-devolvida.
                    END.
                END.
               
                /* Descarta as devolucoes que estao fora do periodo selecionado pelo usuario */
                IF devol-cli.dt-devol >= tt-param.dt-emissao-de AND 
                    devol-cli.dt-devol <= tt-param.dt-emissao-ate THEN DO:
    
                    FIND FIRST tt-dev WHERE
                        tt-dev.it-codigo = devol-cli.it-codigo NO-ERROR.
        
                    IF AVAIL tt-dev THEN
                        ASSIGN tt-dev.qt-devolvida = tt-dev.qt-devolvida + devol-cli.qt-devolvida.
                    ELSE DO:
                        CREATE tt-dev.
                        ASSIGN tt-dev.it-codigo    = devol-cli.it-codigo
                               tt-dev.qt-devolvida = devol-cli.qt-devolvida.
                    END.
                                                                     
                    IF CAN-FIND( int-devol-cli
                                 WHERE int-devol-cli.cod-estabel          = devol-cli.cod-estabel 
                                   and int-devol-cli.serie                = devol-cli.serie       
                                   and int-devol-cli.nr-nota-fis          = devol-cli.nr-nota-fis 
                                   and int-devol-cli.nr-sequencia         = devol-cli.nr-sequencia
                                   and int-devol-cli.it-codigo            = devol-cli.it-codigo   
                                   and int-devol-cli.serie-docto          = devol-cli.serie-docto 
                                   and int-devol-cli.nro-docto            = devol-cli.nro-docto   
                                   and int-devol-cli.cod-emitente         = devol-cli.cod-emitente
                                   and int-devol-cli.nat-operacao         = devol-cli.nat-operacao
                                   and int-devol-cli.sequencia            = devol-cli.sequencia   
                                   and int-devol-cli.atualizou-pedido-oem ) THEN NEXT.
        
        
                    RUN pi-atualiza-pedidos-devolucao.
    
                END.
    
            END. /* FOR EACH devol-cli */

        END. /* FIRST-OF (tt-ped-item.it-codigo) */
        
    END. /* FOR EACH tt-ped-item */

END PROCEDURE.


PROCEDURE pi-atualiza-pedidos-devolucao:

    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + tt-ped-item.it-codigo + "." + "Atualizando Pedido: " + tt-ped-item.nome-abrev + "/" + tt-ped-item.nr-pedcli ).

    FIND FIRST ped-item NO-LOCK
        WHERE ped-item.nome-abrev   = tt-ped-item.nome-abrev  
          and ped-item.nr-pedcli    = tt-ped-item.nr-pedcli   
          and ped-item.it-codigo    = tt-ped-item.it-codigo   
          and ped-item.nr-sequencia = tt-ped-item.nr-sequencia
          and ped-item.cod-refer    = tt-ped-item.cod-refer NO-ERROR.
                  
    IF NOT AVAIL ped-item THEN NEXT.
     
    FIND FIRST ped-venda EXCLUSIVE-LOCK 
        WHERE ped-venda.nome-abrev = tt-ped-item.nome-abrev 
          AND ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli NO-ERROR.
                   
    IF NOT AVAIL ped-venda THEN NEXT.
  
    ASSIGN ped-venda.completo = NO.

    FIND CURRENT ped-venda NO-LOCK.

    FIND FIRST tt-ped-venda
        WHERE tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
          AND tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli NO-ERROR.

    IF NOT AVAIL tt-ped-venda THEN DO:
        CREATE tt-ped-venda.
        ASSIGN tt-ped-venda.nome-abrev = tt-ped-item.nome-abrev
               tt-ped-venda.nr-pedcli  = tt-ped-item.nr-pedcli.
    END.

    EMPTY TEMP-TABLE tt-ped-item-aux.

    CREATE tt-ped-item-aux.
    BUFFER-COPY ped-item TO tt-ped-item-aux.

    /* Devolve as quantidades devolvidas para o Pedido */
    ASSIGN tt-ped-item-aux.qt-pedida = ped-item.qt-pedida + devol-cli.qt-devolvida.


    RUN dibo/bodi154.p PERSISTENT SET bo-ped-item.
    RUN emptyRowErrors  IN bo-ped-item.
    RUN openQueryStatic IN bo-ped-item (INPUT "Main"). 
    RUN goToKey         IN bo-ped-item (INPUT tt-ped-item-aux.nome-abrev,
                                        INPUT tt-ped-item-aux.nr-pedcli,
                                        INPUT tt-ped-item-aux.nr-sequencia,
                                        INPUT tt-ped-item-aux.it-codigo,
                                        INPUT tt-ped-item-aux.cod-refer).
        
    RUN setRecord    IN bo-ped-item (INPUT TABLE tt-ped-item-aux).
    RUN updateRecord IN bo-ped-item.
    RUN getRowErrors IN bo-ped-item (OUTPUT TABLE RowErrors).

    IF VALID-HANDLE (bo-ped-item) THEN DO:
        RUN DestroyBO in bo-ped-item.
        DELETE PROCEDURE bo-ped-item.
        ASSIGN bo-ped-item = ?.
    END.
   
    IF NOT CAN-FIND (FIRST rowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                         AND RowErrors.ErrorSubType = "Error":U) /* AND NOT ped-venda.completo */ THEN DO:           
                
        FIND FIRST int-devol-cli EXCLUSIVE-LOCK
             WHERE int-devol-cli.cod-estabel  = devol-cli.cod-estabel 
               and int-devol-cli.serie        = devol-cli.serie       
               and int-devol-cli.nr-nota-fis  = devol-cli.nr-nota-fis 
               and int-devol-cli.nr-sequencia = devol-cli.nr-sequencia
               and int-devol-cli.it-codigo    = devol-cli.it-codigo   
               and int-devol-cli.serie-docto  = devol-cli.serie-docto 
               and int-devol-cli.nro-docto    = devol-cli.nro-docto   
               and int-devol-cli.cod-emitente = devol-cli.cod-emitente
               and int-devol-cli.nat-operacao = devol-cli.nat-operacao
               and int-devol-cli.sequencia    = devol-cli.sequencia NO-ERROR.

        IF NOT AVAIL int-devol-cli THEN DO:
            CREATE int-devol-cli.
            ASSIGN int-devol-cli.cod-estabel          = devol-cli.cod-estabel 
                   int-devol-cli.serie                = devol-cli.serie       
                   int-devol-cli.nr-nota-fis          = devol-cli.nr-nota-fis 
                   int-devol-cli.nr-sequencia         = devol-cli.nr-sequencia
                   int-devol-cli.it-codigo            = devol-cli.it-codigo   
                   int-devol-cli.serie-docto          = devol-cli.serie-docto 
                   int-devol-cli.nro-docto            = devol-cli.nro-docto   
                   int-devol-cli.cod-emitente         = devol-cli.cod-emitente
                   int-devol-cli.nat-operacao         = devol-cli.nat-operacao
                   int-devol-cli.sequencia            = devol-cli.sequencia 
                   int-devol-cli.atualizou-pedido-oem = YES.
        END. /* CAN-FIND( int-devol-cli */
        ELSE
            ASSIGN int-devol-cli.atualizou-pedido-oem = YES.

    END. /* NOT CAN-FIND (FIRST rowErrors */
                                                    
END PROCEDURE.

PROCEDURE pi-completa-pedido:

    IF NOT VALID-HANDLE(h-bodi159com) THEN
        RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.

    FOR EACH tt-ped-venda:

        FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = tt-ped-venda.nome-abrev
              AND ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.

        IF NOT AVAIL ped-venda THEN NEXT.

        FIND FIRST emitente
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

        RUN completeOrder IN h-bodi159com (INPUT  ROWID(ped-venda),
                                           OUTPUT TABLE rowErrors).
    END.

    IF VALID-HANDLE (h-bodi159com) THEN DO:
        RUN destroyBO in h-bodi159com.
    
        IF VALID-HANDLE (h-bodi159com) THEN DO:
            RUN destroyBO   in h-bodi159com.
        END.
        DELETE PROCEDURE h-bodi159com.
        ASSIGN h-bodi159com = ?.
    END.

END PROCEDURE.

RETURN "OK":U.



