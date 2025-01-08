/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp056rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de pedidos em carteira .
--------------------------------- --------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i espdp056 2.04.00.001}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/pdp/espdp056tt.i}
{esp/es0018.i}

DEF VAR de-preco-venda  AS DECIMAL DECIMALS 4.
DEF VAR perc-desc       AS DECIMAL DECIMALS 4.
DEF VAR h-bodi159cal    AS HANDLE     NO-UNDO.
DEF VAR de-indice-finan AS DECIMAL.
DEF VAR de-fator-cli    AS DECIMAL.
    
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
DEF BUFFER b-ped-item FOR ped-item.
DEF BUFFER b-ped-venda FOR ped-venda.   /*wilson gesplus*/

/*wilson gesplus - criado aqui pois no espdp056tt.i estava dando conflito*/
DEF VAR h_bodi154can              AS HANDLE    NO-UNDO.
DEF VAR h_bodi154                 AS HANDLE    NO-UNDO. 
DEFINE VARIABLE de-valor          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-perc-icms      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-msg138a         AS HANDLE    NO-UNDO.
DEFINE VARIABLE p-indice-financiamento AS DECIMAL     NO-UNDO.
DEF VAR c-desc-motivo       LIKE motivo.descricao NO-UNDO.
DEF VAR h_bodi159com        AS HANDLE NO-UNDO.  /* COMPLETAR O PEDIDO DE VENDA */
DEFINE VARIABLE de-valor-item  AS DEC NO-UNDO.
DEFINE VAR c-descricao AS CHAR NO-UNDO.

DEFINE VAR l-tem-ST AS LOG NO-UNDO.
DEFINE BUFFER b-emitente FOR emitente.

DEF TEMP-TABLE RowErrors NO-UNDO
  FIELD ErrorSequence    AS INTEGER
  FIELD ErrorNumber      AS INTEGER
  FIELD ErrorDescription AS CHARACTER
  FIELD ErrorParameters  AS CHARACTER
  FIELD ErrorType        AS CHARACTER
  FIELD ErrorHelp        AS CHARACTER
  FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-erro2 NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE tt-erro NO-UNDO
   FIELD i-sequen             as integer        
   FIELD cd-erro              as integer        
   FIELD mensagem             as CHARACTER.

DEF TEMP-TABLE TT-PED-ITEM NO-UNDO LIKE PED-ITEM
  FIELD r-rowid  AS ROWID.

FORM 
    tt-erro.i-sequen
    tt-erro.cd-erro 
    tt-erro.mensagem FORMAT "x(100)"
    WITH FRAME f-erro WIDTH 262 64 DOWN NO-ATTR-SPACE STREAM-IO .
/*wilson gesplus*/

FORM ped-venda.nr-pedcli
     ped-venda.cod-emitente
     ped-venda.nome-abrev
     ped-venda.dt-entrega   COLUMN-LABEL "Prev. Fatur Ped"  /*wilson gesplus*/
     ped-item.nat-operacao
     ped-item.dt-entrega    COLUMN-LABEL "Prev. Fatur Item"
     ped-venda.dt-emissao
     ped-venda.cod-priori
     ped-venda.tp-pedido
     ped-item.it-codigo
     ped-item.qt-pedida  /*242*/
     ped-item.per-des-item
     int-ped-item-pci.nr-tabpre
     ped-item.observacao                

WITH FRAME f-detalhe WIDTH 262 64 DOWN NO-ATTR-SPACE STREAM-IO .



FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Alteraá∆o Data Prev. Fatur Pedidos"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP056"
       c-versao       = "2.04"
       c-revisao      = "001".


DEFINE VARIABLE c-clientes-oem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux AS LOGICAL     NO-UNDO.
DEF VAR c-desc-param          AS CHAR FORMAT "x(60)"  NO-UNDO.  /*wilson gesplus*/
/*---------------------------  ParÉmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
RUN esp/es0018p.p (INPUT  "clientes-oem":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

ASSIGN c-clientes-oem = "".

FOR EACH tt-prog-ponto:

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int(tt-prog-ponto.conteudo):

        ASSIGN c-clientes-oem = c-clientes-oem + emitente.nome-abrev + ";".

    END.

END.

IF length(c-clientes-oem) > 0 THEN
    ASSIGN c-clientes-oem = SUBSTRING(c-clientes-oem, 1, LENGTH(c-clientes-oem) - 1).

DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}
   {include/i-rpout.i}
   VIEW FRAME f-cabec.
   VIEW FRAME f-rodape.
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN initializeDBO.
   RUN ValidacaoInicial.
   RUN ImprimeParametros.
   RUN destroyDBO.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

PROCEDURE initializeDBO:
   
END.

PROCEDURE destroyDBO:

END.


PROCEDURE ValidacaoInicial:
    
    IF CAN-FIND (FIRST tt-digita) THEN DO:
        EMPTY TEMP-TABLE tt-digita-2 NO-ERROR.
        FOR EACH tt-digita.
            CREATE tt-digita-2.
            BUFFER-COPY tt-digita TO tt-digita-2.
            IF tt-digita.tipo-trans = "I" THEN DO:
                ASSIGN tt-digita-2.seq-imp = 1.
            END.
            ELSE IF tt-digita.tipo-trans = "A" THEN
                ASSIGN tt-digita-2.seq-imp = 2.
            ELSE IF tt-digita.tipo-trans = "C" THEN
                ASSIGN tt-digita-2.seq-imp = 3.

        END.
    END.
   
    
    IF CAN-FIND (FIRST tt-digita-2) THEN DO:
        
        FOR EACH tt-digita-2 BREAK BY tt-digita-2.seq-imp:
            
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli = tt-digita-2.nr-pedcli NO-ERROR.

            IF NOT AVAIL ped-venda THEN 
               NEXT.
            
            /*wilson gesplus*/
            CASE tt-digita-2.tipo-trans:
                WHEN "I" THEN DO:
                RUN pi-cria.
                END.
                WHEN "A" THEN DO:
                    RUN pi-altera.
                END.
                WHEN "C" THEN DO:
                    RUN pi-cancela.
                END.
            END CASE.
            FIND FIRST b-ped-venda
                WHERE rowid(b-ped-venda) = ROWID(ped-venda)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-ped-venda THEN DO:
                IF b-ped-venda.completo = NO THEN DO:
                    EMPTY TEMP-TABLE RowErrors  NO-ERROR.
                    RUN dibo/bodi159com.p      PERSISTENT SET h_bodi159com.
                    RUN emptyRowErrors  IN h_bodi159com.
                    RUN completeorder   IN h_bodi159com (INPUT ROWID(b-ped-venda),
                                                         OUTPUT TABLE rowerrors).
                    IF CAN-FIND(FIRST rowerrors  
                                WHERE RowErrors.ErrorSubType <> 'WARNING'
                                and   RowErrors.ErrorSubType <> 'Information') THEN DO:
                            IF  not can-find(first RowErrors
                                             where Rowerrors.ErrorSubType = "Error":U
                                               and Rowerrors.ErrorType    = "EMS":U) then do:
                                assign b-ped-venda.completo = yes.
                            end.
                            RUN p-converte-error (INPUT TABLE RowErrors,
                                                  OUTPUT TABLE tt-erro).
                    END.
                    DELETE PROCEDURE h_bodi159com.
                    h_bodi159com = ?.
                END.
            END.
        END.
        /*wilson gesplus*/
    END.
    ELSE IF tt-param.pedidos <> "" THEN DO:
        do  i-cont = 1 to num-entries(tt-param.pedidos):
            FIND ped-venda WHERE ped-venda.nr-pedcli = trim(entry(i-cont,tt-param.pedidos))
                             AND ped-venda.completo = YES
                             AND ped-venda.cod-sit-ped < 6
                             AND ped-venda.dt-emissao  >= tt-param.dt-emissao-ini
                             AND ped-venda.dt-emissao  <= tt-param.dt-emissao-fim
                             AND ped-venda.tp-pedido   >= tt-param.atendente-ini 
                             AND ped-venda.tp-pedido   <= tt-param.atendente-fim 
                             AND ped-venda.cod-priori  >= tt-param.prioridade-ini  
                             AND ped-venda.cod-priori  <= tt-param.prioridade-fim
            NO-LOCK NO-ERROR.

            IF AVAIL ped-venda THEN DO:
                FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ped-venda.cod-emitente:
                END.
                RUN ValidaDemaisCampos.
            END.
        END.
    END.               
    ELSE DO:
        /*IF tt-param.nr-pedcli-ini <> "" AND
           tt-param.nr-pedcli-fim <> "ZZZZZZZZZZ" THEN DO:
            FOR EACH ped-venda NO-LOCK
                WHERE ped-venda.nr-pedcli >= tt-param.nr-pedcli-ini
                  AND ped-venda.nr-pedcli <= tt-param.nr-pedcli-fim,
                FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ped-venda.cod-emitente:
                RUN ValidaDemaisCampos.
            END.
        END.
        ELSE DO:*/
            FOR EACH ped-venda NO-LOCK
                WHERE ped-venda.cod-estabel = tt-param.cod-estabel
                  AND ped-venda.completo = YES
                  AND ped-venda.cod-sit-ped < 6
                  AND ped-venda.dt-emissao  >= tt-param.dt-emissao-ini
                  AND ped-venda.dt-emissao  <= tt-param.dt-emissao-fim
                  AND ped-venda.tp-pedido   >= tt-param.atendente-ini 
                  AND ped-venda.tp-pedido   <= tt-param.atendente-fim 
                  AND ped-venda.cod-priori  >= tt-param.prioridade-ini  
                  AND ped-venda.cod-priori  <= tt-param.prioridade-fim
                  AND ped-venda.nr-pedcli >= tt-param.nr-pedcli-ini
                  AND ped-venda.nr-pedcli <= tt-param.nr-pedcli-fim,
                FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ped-venda.cod-emitente:  
                RUN ValidaDemaisCampos.
            END.
        /*END.*/
    END.
END PROCEDURE.

PROCEDURE ValidaDemaisCampos:

    /** Incidente 29678                 **/
    IF ped-venda.tp-pedido  = '34' THEN NEXT.

    /** Incidente 56801                 **/
    IF ped-venda.tp-pedido  = '99' THEN NEXT. 
    
    IF ped-venda.cod-priori =  44  AND tt-param.considera = NO THEN NEXT. 
    IF ped-venda.cod-priori =  09  THEN NEXT. 

    IF ped-venda.cod-sit-ped =  4  THEN NEXT. /*Pendentes*/


    IF tt-param.l-suspensos = NO AND ped-venda.cod-sit-ped =  5  THEN NEXT. /*Suspensos*/

    /*
    IF  ped-venda.cod-estabel = tt-param.cod-estabel
    AND ped-venda.completo = YES
    AND ped-venda.cod-sit-ped < 6
    AND ped-venda.dt-emissao  >= tt-param.dt-emissao-ini
    AND ped-venda.dt-emissao  <= tt-param.dt-emissao-fim
    AND ped-venda.tp-pedido   >= tt-param.atendente-ini 
    AND ped-venda.tp-pedido   <= tt-param.atendente-fim 
    AND ped-venda.cod-priori  >= tt-param.prioridade-ini  
    AND ped-venda.cod-priori  <= tt-param.prioridade-fim 
    AND LOOKUP(ped-venda.nome-abrev, c-clientes-oem, ";") = 0 THEN DO:*/

    
    IF LOOKUP(ped-venda.nome-abrev, c-clientes-oem, ";") = 0 THEN DO:

        RUN pi-acompanhar IN h-acomp (INPUT 'Ped.Venda: ' + ped-venda.nr-pedcli + ' - ' + ped-venda.nome-abrev).

        IF tt-param.l-parcial = NO AND
        ped-venda.cod-sit-ped = 2 THEN RETURN.

        IF tt-param.l-suspensos = NO AND
           ped-venda.cod-sit-ped =  5  THEN RETURN. /*Suspensos*/

        IF tt-param.dt-entrega-futura <> ? AND
           tt-param.i-altera-data = 1      AND
           tt-param.l-so-listar = NO       THEN DO:
           FIND FIRST b-ped-venda
               WHERE rowid(b-ped-venda) = ROWID(ped-venda)
               EXCLUSIVE-LOCK NO-ERROR.

           IF AVAIL b-ped-venda THEN
           DO:
              DISP ped-venda.nr-pedcli
                   ped-venda.cod-emitente
                   ped-venda.nome-abrev
                   ped-venda.dt-entrega    
                   ''
                   ''
                   ped-venda.dt-emissao
                   ped-venda.cod-priori
                   ped-venda.tp-pedido
                WITH FRAME f-detalhe.
                DOWN WITH FRAME f-detalhe.

              
              ASSIGN b-ped-venda.dt-entrega = tt-param.dt-entrega-futura.
           END.
        END.    
        ELSE
           FOR EACH ped-item OF ped-venda NO-LOCK
              WHERE ped-item.it-codigo >= tt-param.it-codigo-ini
                AND ped-item.it-codigo <= tt-param.it-codigo-fim
                /*AND ped-item.cod-sit-item < 6*/
                AND (ped-item.cod-sit-item <= 2
                 OR  ped-item.cod-sit-item  = 5)     /*wilson - gesplus*/
                AND ped-item.dt-entrega  >= tt-param.dt-entrega-ini
                AND ped-item.dt-entrega  <= tt-param.dt-entrega-fim,
              FIRST emitente NO-LOCK
              WHERE emitente.cod-emitente = ped-venda.cod-emitente, 
              FIRST grupo-canais-clientes NO-LOCK
              WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli:

                IF tt-param.l-suspensos = NO AND ped-item.cod-sit-item = 5 THEN NEXT.
                  
                DISP ped-venda.nr-pedcli
                     ped-venda.cod-emitente
                     ped-venda.nome-abrev
                     ped-venda.dt-entrega     /*wilson gesplus*/
                     ped-item.nat-operacao
                     ped-item.dt-entrega
                     ped-venda.dt-emissao
                     ped-venda.cod-priori
                     ped-venda.tp-pedido
                     ped-item.it-codigo
                     ped-item.qt-pedida 
                     ped-item.per-des-item
                     ped-item.observacao
                WITH FRAME f-detalhe.
                DOWN WITH FRAME f-detalhe.
          
                /** Chamado 10747 - Na atualizaá∆o da data de entrega, n∆o estava utilizando o b-ped-item e sim, somente a ped-item, mesmo dentro da leitura do buffer **/
                IF tt-param.dt-entrega-futura <> ? AND
                   tt-param.i-altera-data = 2      AND
                   tt-param.l-so-listar = NO       THEN DO: 
                   FIND b-ped-item 
                        WHERE ROWID(b-ped-item) = ROWID(ped-item) EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAIL b-ped-item THEN DO:
                       
                      ASSIGN b-ped-item.dt-entrega = tt-param.dt-entrega-futura.

                      FOR EACH ped-ent OF b-ped-item EXCLUSIVE-LOCK:
                          ASSIGN ped-ent.dt-entrega = tt-param.dt-entrega-futura.
                      END.
                       
                   END.
                END.
           END.
    END.
END PROCEDURE.

PROCEDURE ImprimeParametros:
    PAGE.
CASE tt-param.i-altera-data:
    WHEN 1 THEN
        c-desc-param = 'Alterar a data somente no cabeáalho do pedido'.
    WHEN 2 THEN
        c-desc-param = 'Alterar datas nos itens do pedido'.
END CASE.
PUT "------------------------------------------- Parametros ----------------------------------------------------" SKIP
    "" SKIP
    "                                Estabel: " tt-param.cod-estabel         SKIP
    "                             Dt.Emissao: " tt-param.dt-emissao-ini     " <> " tt-param.dt-emissao-fim  SKIP
    "                         Dt.Prev. Fatur: " tt-param.dt-entrega-ini     " <> " tt-param.dt-entrega-fim  SKIP
    "                                 Pedido: " tt-param.nr-pedcli-ini      " <> " tt-param.nr-pedcli-fim   SKIP
    "                              Atendente: " tt-param.atendente-ini      " <> " tt-param.atendente-fim   SKIP
    "                             Prioridade: " tt-param.prioridade-ini     " <> " tt-param.prioridade-fim  SKIP
    "Verifica Pedidos Atendidos Parcialmente: " tt-param.l-parcial       SKIP
    " Somente Lista, N∆o atualiza Dt.Prev. Fatur: "tt-param.l-so-listar      SKIP
    "Verifica Pedidos Suspensos: " tt-param.l-suspensos SKIP
    "   Pedidos: " tt-param.pedidos        FORMAT "x(200)" skip
    "Alterar: " c-desc-param               FORMAT "x(60)"       /*wilson gesplus*/
    SKIP(2). 


PUT "-------------------------------------------- Digitaá∆o ----------------------------------------------------" SKIP(2).

PUT "Tipo Trans Pedido            Item                  Seq   Data Entrega Futura    Preáo           Quatidade       % Desconto  Observacao "        SKIP
    "---------- ----------------- --------------------- ---   ---------------------- --------------- --------------- ----------- --------------------------------------------------" SKIP.
FOR EACH tt-digita-2:

    ASSIGN c-descricao = "".

    /*wilson - gesplus*/
    find FIRST ped-item 
         WHERE ped-item.nr-pedcli = tt-digita-2.nr-pedcli
           AND ped-item.it-codigo = tt-digita-2.it-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL ped-item THEN NEXT.
    IF ped-item.cod-sit-item > 2 OR (tt-param.l-suspensos = NO AND ped-item.cod-sit-item = 5) THEN DO: /*Suspensos*/

        IF (tt-param.l-suspensos = NO AND ped-item.cod-sit-item = 5) THEN
            ASSIGN c-descricao = "Pedido/Item suspenso, verificar se esta com o flag para atualizar".
        ELSE IF ped-item.cod-sit-item = 3 THEN
                ASSIGN c-descricao = "Item Atendido Total, n∆o ser† alterado!".
             ELSE IF ped-item.cod-sit-item = 6 THEN
                     ASSIGN c-descricao = "Item cancelado, n∆o ser† alterado!".

        /*PUT tt-digita-2.it-codigo      
            tt-digita-2.nr-pedcli  
            tt-digita-2.nr-sequencia "          "
            c-descricao FORMAT "x(60)" SKIP.  */

        PUT tt-digita-2.tipo-trans         "           "     
            tt-digita-2.nr-pedcli          "      "
            tt-digita-2.it-codigo          " "
            tt-digita-2.nr-sequencia       "    " 
            tt-digita-2.dt-entrega-futura  "    " 
            tt-digita-2.vl-preuni        
            tt-digita-2.qt-pedida          " "
            tt-digita-2.per-des-item "   "
            c-descricao                
            SKIP.
    END.                                                                
    ELSE
    /*wilson - gesplus*/
        PUT tt-digita-2.tipo-trans         "           "     
            tt-digita-2.nr-pedcli          "      "
            tt-digita-2.it-codigo          " "
            tt-digita-2.nr-sequencia       "    " 
            tt-digita-2.dt-entrega-futura  "    " 
            tt-digita-2.vl-preuni        
            tt-digita-2.qt-pedida          " "
            tt-digita-2.per-des-item "   "
            tt-digita-2.nr-tabpre "     "
            tt-digita-2.observacao                
            SKIP.

END.

END PROCEDURE.

/*wilson gesplus*/
PROCEDURE pi-cria:

    
    IF tt-digita-2.nr-sequencia = 0 THEN DO:
        FIND FIRST ped-venda
            WHERE ped-venda.nr-pedcli = tt-digita-2.nr-pedcli
            NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND LAST ped-item OF ped-venda NO-LOCK NO-ERROR.
            IF AVAIL ped-item THEN
                ASSIGN tt-digita-2.nr-sequencia = ped-item.nr-sequencia + 10.
            ELSE
                ASSIGN tt-digita-2.nr-sequencia = 10.
        END.
    END.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    EMPTY TEMP-TABLE tt-ped-item    NO-ERROR.
    RUN dibo/bodi154.p         PERSISTENT SET h_bodi154.

    
    FIND FIRST ITEM
        WHERE ITEM.it-codigo = tt-digita-2.it-codigo
        NO-LOCK NO-ERROR.
    IF NOT AVAIL ITEM THEN
        NEXT.
    
    RUN pi-verifica-ST(OUTPUT l-tem-ST).
    
    CREATE tt-ped-item.
    BUFFER-COPY ped-venda EXCEPT nr-versao des-pct-desconto-inform TO tt-ped-item.
    ASSIGN tt-ped-item.nr-sequencia     = tt-digita-2.nr-sequencia
           tt-ped-item.qt-pedida        = tt-digita-2.qt-pedida
           tt-ped-item.qt-un-fat        = tt-digita-2.qt-pedida
           tt-ped-item.des-un-medida    = ITEM.un
           tt-ped-item.it-codigo        = ITEM.it-codigo
           tt-ped-item.ind-icm-ret      = l-tem-ST /*NO*/
           tt-ped-item.ind-componen     = IF item.politica = 4 THEN 1 ELSE 0
           tt-ped-item.ind-fat-qtfam    = item.ind-inf-qtf
           tt-ped-item.observacao       = ITEM.desc-item 
           tt-ped-item.aliquota-ipi     = item.aliquota-ipi
           tt-ped-item.tipo-atend       = 2
           tt-ped-item.cod-unid-negoc   = ITEM.cod-unid-negoc
           tt-ped-item.dt-entrega       = tt-digita-2.dt-entrega-futura
           substr(tt-ped-item.char-2,1,8) = ITEM.class-fiscal.

    ASSIGN tt-ped-item.des-pct-desconto-inform = string(tt-digita-2.per-des-item)
           tt-ped-item.observacao              = tt-digita-2.observacao.

    IF tt-digita-2.vl-preuni > 0 THEN DO:
        ASSIGN tt-ped-item.vl-preori        = tt-digita-2.vl-preuni
               tt-ped-item.vl-pretab        = tt-digita-2.vl-preuni
               tt-ped-item.vl-preuni        = tt-digita-2.vl-preuni.
    END.
    ELSE DO:
        IF AVAIL int-emitente AND NOT int-emitente.log-salesforce THEN
           RUN pi-calcula.
        ELSE DO:
            RUN pi-atualiza-pedido-salesforce.
            ASSIGN tt-ped-item.vl-preori = de-preco-venda
                   tt-ped-item.vl-pretab = de-preco-venda
                   tt-ped-item.vl-preuni = de-preco-venda.
       END.
    END.

    IF AVAIL int-emitente AND int-emitente.log-salesforce THEN
        RUN pi-cria-item-pci.

    empty temp-table tt-erro    no-error.
    RUN openQueryStatic IN h_bodi154(INPUT "Main":U).
    RUN setRecord       IN h_bodi154(INPUT TABLE tt-ped-item).
    RUN emptyRowErrors  IN h_bodi154.
    RUN createRecord    IN h_bodi154.
    RUN getRowErrors    IN h_bodi154(OUTPUT TABLE RowErrors).
    IF CAN-FIND(FIRST rowerrors  
       WHERE RowErrors.ErrorSubType <> 'WARNING'
       and   RowErrors.ErrorSubType <> 'Information') THEN DO:
    
/*         FOR EACH RowErrors NO-LOCK.                                          */
/*             MESSAGE '7' SKIP 'no RowErrors' SKIP                             */
/*                 'RowErrors.ErrorSequence   ' RowErrors.ErrorSequence    skip */
/*                 'RowErrors.ErrorNumber     ' RowErrors.ErrorNumber      skip */
/*                 'RowErrors.ErrorDescription' RowErrors.ErrorDescription skip */
/*                 'RowErrors.ErrorParameters ' RowErrors.ErrorParameters  skip */
/*                 'RowErrors.ErrorType       ' RowErrors.ErrorType        skip */
/*                 'RowErrors.ErrorHelp       ' RowErrors.ErrorHelp        skip */
/*                 'RowErrors.ErrorSubType    ' RowErrors.ErrorSubType     skip */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                    */
/*         END.                                                                 */

        RUN p-converte-error (INPUT TABLE RowErrors,
                               OUTPUT TABLE tt-erro).
/*         RUN cdp/cd0666.w (INPUT TABLE tt-erro).       */
/*         RETURN NO-APPLY.                              */
        /*UNDO blocoAtualizaItem, RETURN no-apply.*/
    END.
    ELSE DO:
         FIND FIRST int-ped-venda NO-LOCK 
              WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

         FIND FIRST int-emitente NO-LOCK
              WHERE int-emitente.cod-emitente = ped-venda.cod-emitente 
                AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.
        
         IF AVAIL int-emitente THEN DO:

             IF AVAIL ped-venda THEN DO:
                     
                FIND FIRST int-calculo-canal-item NO-LOCK
                     WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                       AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                       AND int-calculo-canal-item.it-codigo   = tt-digita-2.it-codigo
                       AND NOT int-calculo-canal-item.bloqueado NO-ERROR.
                IF AVAIL int-calculo-canal-item THEN DO:
        
                    FIND FIRST int-ped-item-rebate
                         WHERE int-ped-item-rebate.nome-abrev   = tt-ped-item.nome-abrev  
                           AND int-ped-item-rebate.nr-pedcli    = tt-digita-2.nr-pedcli   
                           AND int-ped-item-rebate.nr-sequencia = tt-digita-2.nr-sequencia
                           AND int-ped-item-rebate.it-codigo    = tt-digita-2.it-codigo   
                           AND int-ped-item-rebate.cod-refer    = tt-ped-item.cod-refer     EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL int-ped-item-rebate THEN DO:
                        ASSIGN int-ped-item-rebate.log-calcrebate         = int-calculo-canal-item.log-calcrebate    
                               int-ped-item-rebate.log-preco-alterado     = int-calculo-canal-item.log-preco-alterado
                               int-ped-item-rebate.log-rebate-antec       = int-calculo-canal-item.log-rebate-antec  
                               int-ped-item-rebate.perc-descto-verde      = int-calculo-canal-item.perc-descto-verde
                               int-ped-item-rebate.perc-descto-top-milhao = int-calculo-canal-item.perc-descto-top-milhao
                               int-ped-item-rebate.perc-rebate-antec      = int-calculo-canal-item.perc-rebate-antec
                               .
                    END. /* IF AVAIL int-ped-item-rebate THEN DO: */
                    ELSE DO:
                        CREATE int-ped-item-rebate.
                        ASSIGN int-ped-item-rebate.nome-abrev              = tt-ped-item.nome-abrev  
                               int-ped-item-rebate.nr-pedcli               = tt-digita-2.nr-pedcli   
                               int-ped-item-rebate.nr-sequencia            = tt-digita-2.nr-sequencia
                               int-ped-item-rebate.it-codigo               = tt-digita-2.it-codigo   
                               int-ped-item-rebate.cod-refer               = tt-ped-item.cod-refer   
                               int-ped-item-rebate.log-calcrebate          = int-calculo-canal-item.log-calcrebate      
                               int-ped-item-rebate.log-preco-alterado      = int-calculo-canal-item.log-preco-alterado  
                               int-ped-item-rebate.log-rebate-antec        = int-calculo-canal-item.log-rebate-antec    
                               int-ped-item-rebate.perc-descto-verde       = int-calculo-canal-item.perc-descto-verde
                               int-ped-item-rebate.perc-descto-top-milhao  = int-calculo-canal-item.perc-descto-top-milhao
                               int-ped-item-rebate.perc-rebate-antec       = int-calculo-canal-item.perc-rebate-antec
                            .
                    END. /* IF NOT AVAIL int-ped-item-rebate THEN DO: */
                    FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
                    RELEASE int-ped-item-rebate.
                END. /* IF AVAIL int-calculo-canal-item THEN DO: */
             END.
         END.  
    END.

    delete tt-ped-item.
    
    DELETE PROCEDURE h_bodi154.
    ASSIGN h_bodi154    = ?.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-erro THEN DO:
        FOR EACH tt-erro NO-LOCK.
            DISP tt-erro.i-sequen                 
                 tt-erro.cd-erro                  
                 tt-erro.mensagem FORMAT "x(100)" 
                WITH FRAME f-erro.
                DOWN WITH FRAME f-erro.

        END.
    END.
    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    
END PROCEDURE.

PROCEDURE pi-altera:

    FOR EACH ped-item OF ped-venda NO-LOCK
       WHERE ped-item.it-codigo    = tt-digita-2.it-codigo
        AND  ped-item.nr-sequencia = tt-digita-2.nr-sequencia
        AND  (ped-item.cod-sit-item <= 2  /*wilson - gesplus*/
         OR   ped-item.cod-sit-item  = 5), /*considera pendentes se estiver marcado o parametro*/
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = ped-venda.cod-emitente,
       FIRST grupo-canais-clientes NO-LOCK
       WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli:

        IF tt-param.l-suspensos = NO AND ped-item.cod-sit-item = 5 THEN NEXT. /*considera pendentes se estiver marcado o parametro*/

        DISP ped-venda.nr-pedcli
             ped-venda.cod-emitente
             ped-venda.nome-abrev
             ped-venda.dt-entrega       /*wilson gesplus*/
             ped-item.nat-operacao
             ped-item.dt-entrega
             ped-venda.dt-emissao
             ped-venda.cod-priori
             ped-venda.tp-pedido
             ped-item.it-codigo
             ped-item.qt-pedida
             ped-item.per-des-item 
             ped-item.observacao 
        WITH FRAME f-detalhe.
        DOWN WITH FRAME f-detalhe.

        /** Chamado 10747 - Na atualizaá∆o da data de entrega, n∆o estava utilizando o b-ped-item e sim, somente a ped-item, mesmo dentro da leitura do buffer **/
/*         IF tt-param.l-so-listar = NO THEN DO:                                        */
/*             /*wilson gesplus*/                                                       */
/*             CASE tt-param.i-altera-data:                                             */
/*                 WHEN 1 THEN DO:                                                      */
/*                     FIND FIRST b-ped-venda                                           */
/*                         WHERE rowid(b-ped-venda) = ROWID(ped-venda)                  */
/*                         EXCLUSIVE-LOCK NO-ERROR.                                     */
/*                     IF AVAIL b-ped-venda THEN                                        */
/*                         ASSIGN b-ped-venda.dt-entrega = tt-digita-2.dt-entrega-futura. */
/*                 END.                                                                 */
/*                 WHEN 2 THEN DO:                                                      */
                    FIND b-ped-item 
                         WHERE ROWID(b-ped-item) = ROWID(ped-item) EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL b-ped-item THEN DO:
                        ASSIGN b-ped-item.dt-entrega = tt-digita-2.dt-entrega-futura.

                        ASSIGN ped-item.observacao    = ped-item.observacao + " " + tt-digita-2.observacao.

                        FOR EACH ped-ent OF b-ped-item EXCLUSIVE-LOCK:
                            ASSIGN ped-ent.dt-entrega = tt-digita-2.dt-entrega-futura.
                        END.
                    END.
/*                 END.  */
/*             END CASE. */
/*                     FIND b-ped-item                                                         */
/*                          WHERE ROWID(b-ped-item) = ROWID(ped-item) EXCLUSIVE-LOCK NO-ERROR. */
/*                     IF AVAIL b-ped-item THEN DO:                                            */
/*                         ASSIGN b-ped-item.dt-entrega = tt-digita-2.dt-entrega-futura.         */
/*                         FOR EACH ped-ent OF b-ped-item EXCLUSIVE-LOCK:                      */
/*                             ASSIGN ped-ent.dt-entrega = tt-digita-2.dt-entrega-futura.        */
/*                         END.                                                                */
/*                     END.                                                                    */
            /*wilson gesplus*/
/*         END. */
    END.

END PROCEDURE.

PROCEDURE pi-cancela:

    FIND FIRST ped-item OF ped-venda 
         WHERE ped-item.it-codigo    = tt-digita-2.it-codigo
           AND ped-item.nr-sequencia = tt-digita-2.nr-sequencia
           AND (ped-item.cod-sit-item <= 2
            OR  ped-item.cod-sit-item  = 5) EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ped-item THEN DO:

        IF tt-param.l-suspensos = NO AND ped-item.cod-sit-item = 5 THEN NEXT.

        c-desc-motivo = "".

        FIND FIRST motivo WHERE motivo.cod-motivo = 12 NO-LOCK NO-ERROR.

        ASSIGN c-desc-motivo = motivo.descricao + " - " + "Item cancelado pelo programa ESPDP056!".

        EMPTY TEMP-TABLE RowErrors  NO-ERROR.
        EMPTY TEMP-TABLE tt-erro    NO-ERROR.

        IF tt-param.l-suspensos = YES AND ped-item.cod-sit-item = 5 THEN 
            ASSIGN ped-item.cod-sit-item = 1.

        run dibo/bodi154can.p persistent set h_bodi154can.
        run setUserLog in h_bodi154can (input c-seg-usuario).
        run validateCancelation in h_bodi154can (input ROWID(ped-item),
                                                 input c-desc-motivo,
                                                 input-output table RowErrors).
        if  can-find(first RowErrors) THEN DO:
            RUN p-converte-error (INPUT TABLE RowErrors,
                                   OUTPUT TABLE tt-erro).
        END.

        if  not can-find(first RowErrors
                         where RowErrors.ErrorSubType = "Error":U) then do:

            if  ped-item.ind-componen = 2 then             
                run updateCancelationComposto in h_bodi154can (input  ROWID(ped-item),
                                                               input  c-desc-motivo,
                                                               input  TODAY,
                                                               input  motivo.cod-motivo).
            else
                run updateCancelation in h_bodi154can (input  ROWID(ped-item),
                                                       input  c-desc-motivo,
                                                       input  TODAY,
                                                       input  motivo.cod-motivo).

            ASSIGN ped-item.observacao    = ped-item.observacao + " " + tt-digita-2.observacao.
        END.
        RUN DestroyBO IN h_bodi154can.
        delete procedure h_bodi154can.
        assign h_bodi154can = ?.

        FIND FIRST tt-erro NO-LOCK NO-ERROR.
        IF AVAIL tt-erro THEN DO:
            FOR EACH tt-erro NO-LOCK.
                DISP tt-erro.i-sequen                 
                     tt-erro.cd-erro                  
                     tt-erro.mensagem FORMAT "x(100)" 
                    WITH FRAME f-erro.
                    DOWN WITH FRAME f-erro.

            END.
        END.
        EMPTY TEMP-TABLE tt-erro NO-ERROR.

        DISP ped-venda.nr-pedcli
             ped-venda.cod-emitente
             ped-venda.nome-abrev
             ped-venda.dt-entrega       /*wilson gesplus*/
             ped-item.nat-operacao
             ped-item.dt-entrega
             ped-venda.dt-emissao
             ped-venda.cod-priori
             ped-venda.tp-pedido
             ped-item.it-codigo
             ped-item.qt-pedida
             ped-item.per-des-item
             ped-item.observacao                
              
        WITH FRAME f-detalhe.
        DOWN WITH FRAME f-detalhe.

    END.


END PROCEDURE.

PROCEDURE p-converte-error :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR RowErrors.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
    FOR EACH tt-erro: DELETE tt-erro. END.
    
    FOR EACH RowErrors NO-LOCK:
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen  = RowErrors.ErrorSequence
               tt-erro.cd-erro   = RowErrors.ErrorNumber
               tt-erro.mensagem  = RowErrors.ErrorDescription.
               /*tt-erro.parametro = RowErrors.ErrorParameters.*/
    END.

END PROCEDURE.

PROCEDURE pi-calcula:

    FIND FIRST int-ped-venda NO-LOCK 
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente 
           AND int-emitente.ind-participa-canais = 993520001 NO-ERROR.

    IF AVAIL int-emitente THEN DO:

        IF AVAIL ped-venda THEN DO:

            FIND FIRST int-calculo-canal-item NO-LOCK
                 WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                   AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                   AND int-calculo-canal-item.it-codigo   = tt-digita-2.it-codigo
                   AND NOT int-calculo-canal-item.bloqueado NO-ERROR.
            IF AVAIL int-calculo-canal-item THEN DO:

                FOR EACH ped-item OF ped-venda 
                    WHERE ped-item.it-codigo = tt-digita-2.it-codigo NO-LOCK:

                     ASSIGN de-valor          = 0
                            de-perc-icms      = 0
                            de-perc-desc-icms = 0.
               
                       FIND FIRST int-ped-item-rebate
                            WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
                              AND int-ped-item-rebate.nr-pedcli    = tt-digita-2.nr-pedcli   
                              AND int-ped-item-rebate.nr-sequencia = tt-digita-2.nr-sequencia
                              AND int-ped-item-rebate.it-codigo    = tt-digita-2.it-codigo   
                              AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer     EXCLUSIVE-LOCK NO-ERROR.
                          IF AVAIL int-ped-item-rebate THEN DO:
                              ASSIGN int-ped-item-rebate.log-calcrebate     = int-calculo-canal-item.log-calcrebate    
                                     int-ped-item-rebate.log-preco-alterado = int-calculo-canal-item.log-preco-alterado
                                     int-ped-item-rebate.log-rebate-antec   = int-calculo-canal-item.log-rebate-antec  
                                     int-ped-item-rebate.perc-descto-verde      = int-calculo-canal-item.perc-descto-verde
                                     int-ped-item-rebate.perc-descto-top-milhao = int-calculo-canal-item.perc-descto-top-milhao
                                     int-ped-item-rebate.perc-rebate-antec      = int-calculo-canal-item.perc-rebate-antec
                                     .
                          END. /* IF AVAIL int-ped-item-rebate THEN DO: */
                          ELSE DO:
                              CREATE int-ped-item-rebate.
                              ASSIGN int-ped-item-rebate.nome-abrev         = ped-item.nome-abrev  
                                     int-ped-item-rebate.nr-pedcli          = tt-digita-2.nr-pedcli   
                                     int-ped-item-rebate.nr-sequencia       = tt-digita-2.nr-sequencia
                                     int-ped-item-rebate.it-codigo          = tt-digita-2.it-codigo   
                                     int-ped-item-rebate.cod-refer          = ped-item.cod-refer   
                                     int-ped-item-rebate.log-calcrebate     = int-calculo-canal-item.log-calcrebate      
                                     int-ped-item-rebate.log-preco-alterado = int-calculo-canal-item.log-preco-alterado  
                                     int-ped-item-rebate.log-rebate-antec   = int-calculo-canal-item.log-rebate-antec    
                                     int-ped-item-rebate.perc-descto-verde       = int-calculo-canal-item.perc-descto-verde
                                     int-ped-item-rebate.perc-descto-top-milhao  = int-calculo-canal-item.perc-descto-top-milhao
                                     int-ped-item-rebate.perc-rebate-antec       = int-calculo-canal-item.perc-rebate-antec
                                  .
                          END. /* IF NOT AVAIL int-ped-item-rebate THEN DO: */
                          FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
                          RELEASE int-ped-item-rebate.
                   
                          IF NOT VALID-HANDLE (h-msg138a) THEN
                              RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.
                      
                          IF ped-venda.cod-cond-pag <> 0 THEN
                              RUN pi-calc-juros IN h-msg138a (INPUT  ped-venda.cod-cond-pag,
                                                              OUTPUT p-indice-financiamento,
                                                              OUTPUT TABLE tt-erro2).
                          ELSE
                              ASSIGN p-indice-financiamento = 1.
                   
                          RUN pi-calcula-icms IN h-msg138a (INPUT  int-emitente.cod-guid,
                                                            INPUT  ped-venda.cod-estabel,
                                                            INPUT  tt-digita-2.it-codigo,
                                                            OUTPUT de-perc-icms,
                                                            OUTPUT de-perc-desc-icms,
                                                            OUTPUT TABLE tt-erro2).
                   
                          IF VALID-HANDLE(h-msg138a) THEN
                              DELETE PROCEDURE h-msg138a.
                   
                          ASSIGN de-valor = int-calculo-canal-item.valor-produto.
                   
                          IF  de-perc-desc-icms > 0 THEN
                              ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                                     de-valor  = round(de-valor / de-perc-desc-icms,4).
                   
                          RUN esp/pdp/espdp098.p(INPUT int-emitente.cod-guid,
                                                 INPUT ped-venda.cod-estabel,
                                                 INPUT ped-item.it-codigo,
                                                 INPUT de-valor,
                                                 INPUT de-perc-icms,
                                                 INPUT p-indice-financiamento,
                                                 OUTPUT de-valor-item ).
                       
                          IF de-valor-item <> 0 THEN DO:
                               ASSIGN tt-ped-item.vl-preori        = de-valor-item
                                      tt-ped-item.vl-pretab        = de-valor-item
                                      tt-ped-item.vl-preuni        = de-valor-item
                                      tt-ped-item.vl-preori-un-fat = de-valor-item  .
                          END.
                          ELSE DO:
                              ASSIGN tt-ped-item.vl-preori        = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento
                                     tt-ped-item.vl-pretab        = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento
                                     tt-ped-item.vl-preuni        = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento
                                     tt-ped-item.vl-preori-un-fat = (de-valor / ((100 - de-perc-icms) / 100)) * p-indice-financiamento.
                          END.
                END.
            END. /* IF AVAIL int-calculo-canal-item THEN DO: */
            ELSE DO:
                ASSIGN tt-ped-item.vl-preori        = 1
                       tt-ped-item.vl-pretab        = 1
                       tt-ped-item.vl-preuni        = 1
                       tt-ped-item.vl-preori-un-fat = 1.
            END.
        END. /* ped-venda */
    END. /* int-emitente*/
    ELSE DO:
        ASSIGN tt-ped-item.vl-preori        = 1
               tt-ped-item.vl-pretab        = 1
               tt-ped-item.vl-preuni        = 1
               tt-ped-item.vl-preori-un-fat = 1.
    END.

END PROCEDURE.

/*wilson gesplus*/

PROCEDURE pi-verifica-ST:
    DEFINE OUTPUT PARAM p-ST AS LOG INIT NO NO-UNDO.

    DEFINE VAR h-boes505          AS HANDLE NO-UNDO.
    DEFINE VAR c-nat-oper         AS CHAR   NO-UNDO.
    DEFINE VAR l-return           AS LOG    NO-UNDO.
    DEFINE VAR l-consumidor-final AS LOG    NO-UNDO.

    IF ped-venda.cod-des-merc = 1 THEN
        ASSIGN l-consumidor-final = NO.
    ELSE
        ASSIGN l-consumidor-final = YES.

    FIND FIRST b-emitente NO-LOCK
         WHERE b-emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.pais   = b-emitente.pais
           AND unid-feder.estado = b-emitente.estado NO-ERROR.
    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    IF  b-emitente.natureza <> 3 
    AND b-emitente.contrib-icms = NO
    AND (b-emitente.ins-estadual = ""
    OR   b-emitente.ins-estadual = "ISENTO"
    OR   b-emitente.ins-estadual = "ISENTA") THEN
        ASSIGN l-consumidor-final = YES.
            
    RUN esbo/boes505.p PERSISTENT SET h-boes505.

    RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                        INPUT ped-venda.cod-emitente,
                                        INPUT ped-venda.cod-entrega,
                                        INPUT ITEM.it-codigo,
                                        INPUT l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).
    DELETE PROCEDURE h-boes505.

    IF b-emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:

      FIND FIRST item-uf NO-LOCK
           WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
             AND item-uf.cod-estado-orig = estabelec.estado
             AND item-uf.estado          = b-emitente.estado NO-ERROR.
      FIND FIRST dist-emitente OF b-emitente NO-LOCK NO-ERROR.

      FIND FIRST natur-oper
           WHERE natur-oper.nat-operacao = c-nat-oper NO-LOCK NO-ERROR.
      IF AVAIL natur-oper THEN DO:
          if  natur-oper.subs-trib AND
             AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = ""
             AND b-emitente.insc-subs-trib = "" THEN  DO:

             ASSIGN p-ST = YES.
          END.
      END. /* IF AVAIL natur-oper THEN DO: */

   END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */

END PROCEDURE.

PROCEDURE pi-cria-item-pci:

    FIND FIRST repres NO-LOCK
         WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.

    FOR FIRST int-segmento-item
        WHERE int-segmento-item.it-codigo  = tt-ped-item.it-codigo
          AND int-segmento-item.cod-gr-cli = emitente.cod-gr-cli no-lock: 
    END.

    for FIRST mgesp.int-ped-item-pci
        WHERE int-ped-item-pci.nome-abrev   = tt-ped-item.nome-abrev
          AND int-ped-item-pci.nr-pedcli    = tt-ped-item.nr-pedcli
          AND int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia
          AND int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
          AND int-ped-item-pci.cod-refer    = tt-ped-item.cod-refer exclusive-lock: end.

    IF NOT AVAIL int-ped-item-pci THEN DO:
         CREATE mgesp.int-ped-item-pci.
         ASSIGN int-ped-item-pci.nome-abrev   = tt-ped-item.nome-abrev
                int-ped-item-pci.nr-pedcli    = tt-ped-item.nr-pedcli
                int-ped-item-pci.nr-sequencia = tt-ped-item.nr-sequencia
                int-ped-item-pci.it-codigo    = tt-ped-item.it-codigo
                int-ped-item-pci.cod-refer    = tt-ped-item.cod-refer.
    END.

    ASSIGN int-ped-item-pci.cod-repres   = repres.cod-rep
           int-ped-item-pci.cod-segmento = IF AVAIL int-segmento-item THEN int-segmento-item.cod-segmento ELSE 0
           int-ped-item-pci.nr-tabpre    = tt-digita-2.nr-tabpre.

                                                                                                               
    // Zera descontos do pci

    ASSIGN int-ped-item-pci.desc-topmilhao = 0
           int-ped-item-pci.desc-maisverde = 0 
           int-ped-item-pci.desc-focounid  = 0
           int-ped-item-pci.desc-distrib20 = 0
           int-ped-item-pci.desc-widecloud = 0.

     // Aplicaá∆o dos descontos do PCI 
    FIND FIRST int-emitente-canal 
         WHERE int-emitente-canal.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL int-emitente-canal THEN
       FIND FIRST emitente 
            WHERE emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-LOCK NO-ERROR.

    IF NOT AVAIL emitente THEN
       FIND FIRST emitente 
            WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR. 

    IF AVAIL emitente THEN DO:
       FOR EACH int-beneficio-conta NO-LOCK
          WHERE int-beneficio-conta.cod-emitente      = emitente.cod-emitente
            AND int-beneficio-conta.log-ativo         = YES
            AND int-beneficio-conta.log-bloq-infracao = NO:

           FIND FIRST ITEM
                WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-LOCK NO-ERROR.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = SUBSTR(item.fm-cod-com,1,5) THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

           IF int-beneficio-conta.segmento-produto = '' AND 
              int-beneficio-conta.familia-produto  = '' THEN
              RUN pi-desconto.

       END.
    END.

    IF tt-ped-item.des-pct-desconto-inform <> '' AND 
       int-ped-item-pci.desc-topmilhao > 0 THEN 
       ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    IF dec(int-ped-item-pci.desc-topmilhao) > 0 THEN
       ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-topmilhao).
    IF tt-ped-item.des-pct-desconto-inform <> '' AND 
       int-ped-item-pci.desc-maisverde > 0 THEN 
       ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    IF dec(int-ped-item-pci.desc-maisverde) > 0 THEN
       ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-maisverde).
    IF tt-ped-item.des-pct-desconto-inform <> '' AND 
       int-ped-item-pci.desc-focounid > 0 THEN 
       ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    IF dec(int-ped-item-pci.desc-focounid) > 0 THEN
       ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-focounid).
    IF tt-ped-item.des-pct-desconto-inform <> '' AND 
       int-ped-item-pci.desc-distrib > 0 THEN 
       ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    IF dec(int-ped-item-pci.desc-distrib) > 0 THEN
       ASSIGN tt-ped-item.des-pct-desconto-inform   = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-distrib20).
    IF tt-ped-item.des-pct-desconto-inform <> '' AND 
       int-ped-item-pci.desc-widecloud > 0 THEN 
       ASSIGN tt-ped-item.des-pct-desconto-inform = tt-ped-item.des-pct-desconto-inform + '+'.
    IF dec(int-ped-item-pci.desc-widecloud) > 0 THEN
       ASSIGN tt-ped-item.des-pct-desconto-inform  = tt-ped-item.des-pct-desconto-inform + string(int-ped-item-pci.desc-widecloud).

    IF tt-ped-item.des-pct-desconto-inform <> '' THEN DO:
       ASSIGN perc-desc = 0.

       if  not valid-handle(h-bodi159cal)
            or  h-bodi159cal:type      <> "PROCEDURE":U
            or  h-bodi159cal:file-name <> "dibo/bodi159cal.p":U then
           run dibo/bodi159cal.p persistent set h-bodi159cal.

       run calculateTextDiscount in h-bodi159cal(input tt-ped-item.des-pct-desconto-inform,
                                                 output perc-desc).

       IF tt-ped-item.vl-preuni = tt-ped-item.vl-preori THEN
          ASSIGN tt-ped-item.per-des-it = perc-desc.
                 tt-ped-item.vl-preuni = tt-ped-item.vl-preuni * (1 - (tt-ped-item.per-des-item / 100)).

    END.

    FIND CURRENT mgesp.int-ped-item-pci NO-LOCK NO-ERROR.
    RELEASE int-ped-item-pci.

END PROCEDURE.


PROCEDURE pi-atualiza-pedido-salesforce.

    IF tt-digita-2.vl-preuni > 0 THEN DO:
        ASSIGN de-preco-venda  = tt-digita-2.vl-preuni.
    END.
    ELSE DO:
        FIND LAST preco-item NO-LOCK
            WHERE preco-item.it-codigo  = tt-digita-2.it-codigo
              AND preco-item.nr-tabpre  = tt-digita-2.nr-tabpre
              AND preco-item.situacao   = 1
              AND preco-item.dt-inival <= TODAY NO-ERROR.
        IF  AVAIL preco-item THEN
            ASSIGN de-preco-venda  = preco-item.preco-venda.
    END.

      FIND FIRST cond-pagto 
          WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
     FIND FIRST tab-finan-indice NO-LOCK
          WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
            AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.
     IF AVAIL tab-finan-indice THEN 
        ASSIGN  de-indice-finan = tab-finan-indice.tab-ind-fin.
    // APLICA INDICE DE FINANCIAMENTO NO PRECO 
      IF de-indice-finan <> 1 THEN DO:
         ASSIGN de-preco-venda = de-preco-venda * de-indice-finan.
      END.


            // APLICA NO PRECO O FATOR DE DESCONTO ACRESCIMO DO CLIENTE 
      ASSIGN de-fator-cli = 0.
      FIND FIRST mgesp.int-ped-item-pci
           WHERE int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
             AND int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev
             AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
             AND int-ped-item-pci.it-codigo    = ped-item.it-codigo NO-ERROR.
      IF AVAIL int-ped-item-pci THEN
      RUN pi-busca-desconto-cliente (INPUT ped-venda.cod-emitente,
                                     INPUT int-ped-item-pci.nr-tabpre,
                                     INPUT ped-item.it-codigo,
                                     OUTPUT de-fator-cli).



     IF de-fator-cli <> 0 THEN DO:
         ASSIGN de-preco-venda = de-preco-venda * de-fator-cli.
      END.
          
END.



 PROCEDURE pi-desconto:

     
    CASE int-beneficio-conta.nome-beneficio: 
        WHEN 'Top Milh∆o'                THEN ASSIGN mgesp.int-ped-item-pci.desc-topmilhao  = int-beneficio-conta.perc-desconto / 100.
        WHEN 'Top Milhao'                THEN ASSIGN mgesp.int-ped-item-pci.desc-topmilhao  = int-beneficio-conta.perc-desconto / 100.
        WHEN 'Mais Verde  '              THEN ASSIGN int-ped-item-pci.desc-maisverde  = int-beneficio-conta.perc-desconto / 100.
        WHEN 'Foco na Unidade'           THEN ASSIGN int-ped-item-pci.desc-focounid   = int-beneficio-conta.perc-desconto / 100.
        WHEN 'Distribuidor 2.0'          THEN ASSIGN int-ped-item-pci.desc-distrib    = int-beneficio-conta.perc-desconto / 100.
        WHEN 'Wide Cloud'                THEN ASSIGN int-ped-item-pci.desc-widecloud  = int-beneficio-conta.perc-desconto / 100.
    END.
 END PROCEDURE.

 PROCEDURE pi-busca-desconto-cliente.
   {esp/wso/eswso0010.i1}
 END.

