/***********************************************************************
**  Programa..: ESP\FTP\ESFTP102RP.P
**  Autor.....: Francisco Almeida Fran‡a
**  Data......: JANEIRO/2014 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              Desenvolvido a partir do programa ESFTP001
**  VersÆo....: 001 08/01/2014
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP102 2.04.00.002}
 
/****************************  Definitions  ****************************/
{esp/ftp/esftp102tt.i}
{esp/ftp/esftp102.i}
   
{include/i-rpvar.i}
 
/****************************  Temp-Tables  ****************************/

/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
def var h-boes464             as handle  no-undo.
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
def var de-perc-acordo   as decimal no-undo.
DEF VAR i-id-faturamento-acordo AS INTEGER NO-UNDO.
DEF VAR i-id-base-calc-acordo   AS INTEGER NO-UNDO.
DEF VAR i-id-devolucoes         AS INTEGER NO-UNDO.
def var d-dt-ent         like ped-venda.dt-emiss.
def var c-obs            as char format "X(85)".
def var i-atendente      like ped-venda.tp-pedido.
def var c-mail           as char format "X(40)".
def var c-desc-grupo     like gr-cli.descricao.
DEFINE VARIABLE c-sit-ped AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-cod-gerente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nom-gerente AS CHARACTER   NO-UNDO.
def var i-p-medio        as dec format ">>>>>>9".
def var c-unid-neg       as char format "X(10)".
DEF VAR c-unid-nota      as char format "X(10)".
def var de-perc-comissao as dec format ">9.99".
DEF VAR c-desc-cond      LIKE cond-pagto.descricao.
DEF VAR de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant LIKE ped-venda.dt-implant.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-obs-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-observ-item AS CHARACTER   NO-UNDO.
 
DEF VAR c-bandeira-cartao AS CHARACTER NO-UNDO.

DEFINE VARIABLE hDBOcomis-rep AS HANDLE      NO-UNDO.
&GLOBAL-DEFINE ttTable        ttcomis-rep
&GLOBAL-DEFINE hDBOTable      hDBOcomis-rep
&GLOBAL-DEFINE DBOTable       comis-rep
 
def buffer b-emitente for emitente.
/****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
 
create tt-param.
raw-transfer raw-param to tt-param.
 
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
 
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Vendas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP001"
       c-versao       = "2.04"
       c-revisao      = "001".
 
/* ***************************  Main Block  *************************** */
RUN esbo/boes464.p PERSISTENT SET h-boes464.
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.
DELETE PROCEDURE h-boes464.    
 
/* **********************  Internal Procedures  *********************** */
DEF VAR cRegiao AS CHAR FORMAT 'x(40)'.
DEF VAR cPerc   AS CHAR FORMAT 'x(05)'.
DEF VAR a AS DEC FORMAT ">>>,>>>,>>9.99".
 
PROCEDURE initializeDBO:
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes396.p":U THEN DO:
       RUN esbo/boes396.p PERSISTENT SET {&hDBOTable}.
    END.
END.
 
PROCEDURE destroyDBO:
    DELETE PROCEDURE {&hDBOTable}.
END.
 
 
PROCEDURE piImprimeRelat:
    
    RUN initializeDBO.
 
    PUT UNFORMATTED "Estab; Pedcli;Emitente ;   item; desc ITEM                 ; Nome Emitente                  ;  CPF/CNPJ    ; Telefone      ; e-mail                " SKIP.
    
    do da-data = tt-param.da-data-ini to tt-param.da-data-fim:
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999")).
       for each nota-fiscal fields(nome-ab-cli  nr-nota-fis  vl-taxa-exp  serie   nr-pedcli    emite-duplic dt-emis-nota nat-operacao cod-emitente cidade     
                                   estado       cod-rep      no-ab-reppri nome-transp nr-praz-med  cod-estabel  nr-fatura    cod-cond-pag observ-nota vl-frete) USE-INDEX ch-distancia no-lock
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini 
           AND   nota-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
           AND   nota-fiscal.cod-emitente >= tt-param.i-cod-cli-ini 
           AND   nota-fiscal.cod-emitente <= tt-param.i-cod-cli-fim 
           AND   nota-fiscal.estado       >= tt-param.uf-ini
           AND   nota-fiscal.estado       <= tt-param.uf-fim
           AND   nota-fiscal.dt-cancel    = ?,
           first emitente fields(nome-emit cgc e-mail cod-gr-cli cod-rep cod-emitente telefone) no-lock 
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente 
                 AND   emitente.cod-gr-cli   >= tt-param.i-gr-cli-ini 
                 AND   emitente.cod-gr-cli   <= tt-param.i-gr-cli-fim
                 AND   emitente.cod-rep      >= tt-param.i-cod-rep-ini
                 AND   emitente.cod-rep      <= tt-param.i-cod-rep-fim
                 and   ((emitente.cgc        >= c-cgc-ini 
                 AND   emitente.cgc          <= c-cgc-fim) 
                 OR    emitente.cgc = ?),
           FIRST b-emitente  NO-LOCK
              WHERE b-emitente.nome-abrev = emitente.nome-matriz,
           each it-nota-fisc fields(it-codigo nr-pedcli nr-seq-ped qt-faturada[1] vl-merc-liq nr-seq-fat it-codigo cod-estabel serie nr-nota-fis
                                    aliquota-icm vl-tot-item it-nota-fisc.vl-preuni vl-ipi-it nat-operacao cod-unid-neg vl-icmsub-it) of nota-fiscal no-lock,
           FIRST ITEM fields(it-codigo desc-item fm-cod-com cod-unid-neg) NO-LOCK 
                 WHERE item.it-codigo  = it-nota-fisc.it-codigo:
 
           IF item.fm-cod-com <> "" THEN
              IF ITEM.fm-cod-com < tt-param.i-familia-com-ini OR
                 ITEM.fm-cod-com > tt-param.i-familia-com-fim THEN NEXT.
         
          IF tt-param.i-dup-ini = "S" AND 
             tt-param.i-dup-fim = "S" AND 
             nota-fiscal.emite-duplic = NO THEN NEXT.
               
          IF tt-param.i-dup-ini = "N" AND 
             tt-param.i-dup-fim = "N" AND 
             nota-fiscal.emite-duplic = YES THEN NEXT.
           
           if (it-nota-fisc.it-codigo < ItCodigoIni or 
               it-nota-fisc.it-codigo > ItCodigoFim) then next. 
                                                                                                         
           if can-find(first tt-digita) then do:
              find first tt-digita no-lock where
                   tt-digita.cd-gr-com = ITEM.fm-cod-com no-error.
              if not avail tt-digita then next.
           end.

           FIND fam-comerc
                WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
                NO-LOCK NO-ERROR.
 
           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
 
           find first ped-venda no-lock 
                WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.
           assign d-dt-ent = ?
                  c-obs      = ""
                  i-atendente = ""
                  dt-dt-implant = ?.
           IF NOT AVAIL ped-venda THEN DO:
               IF tt-param.c-cod-atendente-ini <> "00" or tt-param.c-cod-atendente-fim <> "99" THEN NEXT.
           END.                  
 
           ASSIGN a = a + it-nota-fisc.vl-merc-liq.
           if avail ped-venda then do:
              find first ped-item no-lock of ped-venda where
                   ped-item.it-codigo    = ITEM.it-codigo and
                   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped no-error.
              find int-ped-item exclusive-lock
                 where int-ped-item.nome-abrev      = ped-venda.nome-abrev
                   and int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
                   and int-ped-item.nr-sequencia    = ped-item.nr-sequencia
                   and int-ped-item.it-codigo       = ped-item.it-codigo
                   and int-ped-item.cod-refer       = ped-item.cod-refer no-error.

              assign d-dt-ent  = if avail ped-item then ped-item.dt-entrega
                                                   else ped-venda.dt-entrega
                     i-atendente   = ped-venda.tp-pedido
                     c-obs         = substr(ped-venda.observacoes,1,85)
                     dt-dt-implant = ped-venda.dt-implant
                     c-obs         = REPLACE(c-obs,CHR(10),"")
                     c-obs         = REPLACE(c-obs,CHR(13),"")
                     c-obs         = REPLACE(c-obs,CHR(9),"")
                     c-obs         = REPLACE(c-obs,";",",")
                     c-observ-item = ped-item.observacao
                     c-observ-item = REPLACE(c-observ-item,CHR(10),"")
                     c-observ-item = REPLACE(c-observ-item,CHR(13),"")
                     c-observ-item = REPLACE(c-observ-item,CHR(9),"")
                     c-observ-item = REPLACE(c-observ-item,";",","). /* pode ter conteudo separado por ponto e virgula */
              IF int(i-atendente) < int(tt-param.c-cod-atendente-ini) OR
                 int(i-atendente) > int(tt-param.c-cod-atendente-fim) THEN NEXT.

           end.

           FIND FIRST item-uni-estab
               WHERE item-uni-estab.it-codigo   = item.it-codigo
                 AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
           
           RUN piTrataRelat.

           IF  c-unid-neg < tt-param.c-unid-neg-ini or
               c-unid-neg > tt-param.c-unid-neg-fim THEN NEXT.
 
           FIND int-repres
                WHERE int-repres.cod-repres = nota-fiscal.cod-rep
                NO-LOCK NO-ERROR.
           IF AVAIL INT-repres THEN
              ASSIGN c-cod-gerente = string(int-repres.cod-gerente).
           ELSE
              ASSIGN c-cod-gerente = "".
           
           FIND gerente
                WHERE gerente.cod-gerente = INT(c-cod-gerente)
                NO-LOCK NO-ERROR.
           IF AVAIL gerente THEN 
              ASSIGN c-nom-gerente = gerente.nome.
           ELSE
              ASSIGN c-nom-gerente = "".
          
          ASSIGN c-sit-ped = "".
          IF AVAIL ped-venda THEN
             IF ped-venda.cod-sit-ped = 1 THEN
                ASSIGN c-sit-ped = "ABERTO".
             ELSE
                IF ped-venda.cod-sit-ped = 2 THEN 
                   ASSIGN c-sit-ped = "AT.PARCIAL".
                ELSE
                    IF ped-venda.cod-sit-ped = 3 THEN 
                       ASSIGN c-sit-ped = "AT.TOTAL".
                     ELSE
                        IF ped-venda.cod-sit-ped = 5 THEN 
                           ASSIGN c-sit-ped = "SUSPENSO".

/*****************************Put Relat¢rio***********************************/
                       
            ASSIGN c-desc-item = fn-retira-espec(item.desc-item ).
                     
            
            RUN VerificaCartaoCredito.
            
            PUT UNFORMATTED string(nota-fiscal.cod-estabel)                  ";"
                            string(nota-fiscal.nr-pedcli)                    ";"
                            string(nota-fiscal.cod-emitente)                 ";" 
                            string(it-nota-fisc.it-codigo)    format "x(07)" ";"
                            STRING(ITEM.desc-item)            FORMAT "X(30)" ";" 
                            string(emitente.nome-emit)                       ";" 
                            string(emitente.cgc)              FORMAT "X(14)" ";"              
                            emitente.telefone                 FORMAT "X(15)" ";"
                            string(emitente.e-mail)                          ";".
                            .
           
           
       END. /*FIM FOR EACH*/

    END. /*FIM DO*/
    
    put UNFORMATTED "     " skip.
 
    RUN destroyDBO.
 
END PROCEDURE.
 
PROCEDURE piTrataRelat:
 
    find first cond-pagto no-lock where
          cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag no-error.
 
    if avail cond-pagto then
       ASSIGN c-desc-cond = cond-pagto.descricao.
    ELSE
       ASSIGN c-desc-cond = "NÇO ENCONTRADA OU ESPECIAL".
    assign c-mail = emitente.e-mail.
    
    find gr-cli no-lock where
         gr-cli.cod-gr-cli = emitente.cod-gr-cli no-error.
    if avail gr-cli then
       assign c-desc-grupo = gr-cli.descricao.
    else
       assign c-desc-grupo = string(emitente.cod-gr-cli,"99") + 
                             " - Grupo nao cadastrado".
    
    find first repres no-lock where
         repres.nome-abrev = nota-fiscal.no-ab-reppri no-error.
 
    find first regiao no-lock where    
         regiao.nome-ab-reg = repres.nome-ab-reg no-error.
 
    assign c-unid-neg  = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE item.cod-unid-negoc.
           c-unid-nota = it-nota-fisc.cod-unid-negoc.
 
    RUN getAcordoComercial IN h-boes464    (INPUT emitente.cgc,
                                            INPUT nota-fiscal.cod-estabel,
                                            INPUT c-unid-nota,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT nota-fiscal.dt-emis-nota,
                                            OUTPUT i-id-faturamento-acordo,
                                            OUTPUT i-id-base-calc-acordo,  
                                            OUTPUT i-id-devolucoes,
                                            OUTPUT de-perc-acordo) NO-ERROR.

    
    IF AVAIL cond-pagto THEN DO:
        assign i-p-medio = (cond-pagto.prazos[1] + cond-pagto.prazos[2] +
                            cond-pagto.prazos[3] + cond-pagto.prazos[4] +
                            cond-pagto.prazos[5] + cond-pagto.prazos[6] +
                            cond-pagto.prazos[7] + cond-pagto.prazos[8] +
                            cond-pagto.prazos[9] + cond-pagto.prazos[10] +
                            cond-pagto.prazos[11] + cond-pagto.prazos[12]) /
                            cond-pagto.num-parcelas.
        IF i-p-medio < 0 THEN
           ASSIGN i-p-medio = 0.
    END.
        
    ELSE
        ASSIGN i-p-medio = 1.               

END PROCEDURE.


PROCEDURE VerificaCartaoCredito:
    
    ASSIGN c-bandeira-cartao = "".

    FIND ped-venda
        WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli 
          AND ped-venda.nome-abrev   = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.

    FIND cond-pagto
        WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
    FIND int-ped-venda
        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    
    IF AVAIL int-ped-venda THEN DO:
        FIND emitente-cartao-cred NO-LOCK
            WHERE emitente-cartao-cred.cod-emitente = nota-fiscal.cod-emitente
              AND emitente-cartao-cred.sequencia    = int-ped-venda.seq-cartao-cred NO-ERROR.
    
        IF AVAIL emitente-cartao-cred THEN DO:
            IF  emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
            AND emitente-cartao-cred.bandeira    = 07 /*Hipercard*/
                THEN ASSIGN c-bandeira-cartao = 'Hipercard'. 
        
            IF  emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
            AND emitente-cartao-cred.bandeira    = 11 /*Visa*/
                THEN ASSIGN c-bandeira-cartao = 'Visa'.    
        
            IF  emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
            AND emitente-cartao-cred.bandeira    = 10 /*Mastercard*/
                THEN ASSIGN c-bandeira-cartao = 'Mastercard'.    
          
            IF  emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
            AND emitente-cartao-cred.bandeira    = 06 /*Diners*/
                THEN ASSIGN c-bandeira-cartao = 'Diners'.    
        
            IF  emitente-cartao-cred.tipo-cartao = 01 /*B2B*/
            AND emitente-cartao-cred.bandeira    = 10 /*Mastercard*/
                THEN ASSIGN c-bandeira-cartao = 'Mastercard'.   /*Bandeira*/
                                
            IF  emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
            AND emitente-cartao-cred.bandeira    = 01 /*American Express*/
                THEN ASSIGN c-bandeira-cartao = 'American Express'.  /*Bandeira*/
        END.
    END.

END PROCEDURE.


