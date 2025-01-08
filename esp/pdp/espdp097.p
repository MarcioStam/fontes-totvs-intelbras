/*********************************************************************************
**  programa: esp\pdp\espdp097.p
**  autor   : Isac Abrahao
**  data    : 19/04/2021
**  objetivo: Calcular impostos do pedido antes do faturamento
**********************************************************************************/
//{geraNotaFiscalAPI.i}
{method/dbotterr.i} /* rowerrors */

/*--- temp-tables ---*/
DEF TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS  ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.   

DEF TEMP-TABLE tt-ped-item LIKE ped-item
    FIELD qtde-alocar AS DEC.

DEF TEMP-TABLE tt-itens-pedido NO-UNDO
    FIELD nr-sequencia        AS INT
    FIELD it-codigo           AS CHAR
    FIELD id-item-sf          AS CHAR
    FIELD cod-refer           AS CHAR
    FIELD nat-operacao        AS CHAR 
    FIELD qtde                AS DEC
    FIELD vl-preori           AS DEC
    FIELD vl-instal           AS DEC
    FIELD vl-start            AS DEC
    FIELD vl-embal            AS DEC
    FIELD vl-frete            AS DEC
    FIELD vl-unit-calc        AS DEC
    FIELD vl-tot-item         AS DEC
    FIELD vl-sugere-it        AS DEC
    FIELD per-descto-it       AS DEC

    FIELD aliq-ipi            AS DEC
    FIELD vl-base-calc-ipi    AS DEC
    FIELD vl-ipi              AS DEC
    FIELD aliq-pis            AS DEC
    FIELD vl-base-calc-pis    AS DEC
    FIELD vl-pis              AS DEC
    FIELD aliq-cofins         AS DEC
    FIELD vl-base-calc-cofins AS DEC
    FIELD vl-cofins           AS DEC
    FIELD aliq-icms           AS DEC
    FIELD vl-base-calc-icms   AS DEC
    FIELD vl-icms             AS DEC
    FIELD aliq-st             AS DEC
    FIELD vl-base-calc-st     AS DEC
    FIELD vl-st               AS DEC.

DEF temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF INPUT PARAM p-pedido           AS INT.
//DEF INPUT PARAM p-lista-qtd-aberto AS LOG.
//DEF INPUT PARAM p-item-alocado     AS LOG.
DEF INPUT  PARAM TABLE FOR tt-ped-item.
DEF OUTPUT PARAM TABLE FOR tt-itens-pedido.
DEF OUTPUT PARAM TABLE FOR tt-erro.

DEF TEMP-TABLE tt-saldo-estoq LIKE saldo-estoq
    FIELD qt-disponivel AS DEC.

/*--- definicao de variaveis globais ---*/
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

/*--- definicao de variaveis locais ---*/
DEFINE VARIABLE i-nr-nota-fis          AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-seq-item             AS INTEGER   NO-UNDO.
DEFINE VARIABLE h-bodi317pr            AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317sd            AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317in            AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317va            AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317ef            AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-date-aux             AS DATETIME  NO-UNDO.
DEFINE VARIABLE iSeqMsg                AS INT       NO-UNDO.
DEFINE VARIABLE cComplMsgErro          AS CHAR      NO-UNDO.
DEFINE VARIABLE i-seq-wt-it-docto      AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-ok                   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-char-aux             AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-quantidade-aux      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE l-nf-man-dev-terc-dif  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-recal-apenas-totais  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-notas-geradas        AS CHAR      NO-UNDO.
DEFINE VARIABLE c-doctos-gerados       AS CHAR      NO-UNDO.
DEFINE VARIABLE iCont                  AS INT       NO-UNDO.
DEFINE VARIABLE deNumeroTotalNotas     AS DEC       NO-UNDO.
DEFINE VARIABLE iContItemNotaAtu       AS INT       NO-UNDO.
DEFINE VARIABLE deTotalBaixaEstoque    AS DEC       NO-UNDO.
define variable h-ft4015               as handle    no-undo.
define variable l-possui-impressao-aut as log       no-undo.
define variable l-proc-ok-aux          as log       no-undo.
define variable i-seq-wt-docto-aux     as int       no-undo.
DEFINE VARIABLE de-vl-tot-nota         AS DEC       NO-UNDO.
DEFINE VARIABLE c-natoper-capa-temp    AS CHAR      NO-UNDO.

DEF VAR h-cdapi995 AS HANDLE NO-UNDO.

/* defini‡Æo de buffers */
def buffer b-wt-nota-trans    for wt-nota-trans.
def buffer b-wt-fat-duplic    for wt-fat-duplic.
def buffer b-wt-fat-repre     for wt-fat-repre.
def buffer b-wt-it-docto      for wt-it-docto.
def buffer b-wt-it-imposto    for wt-it-imposto.
def buffer b-wt-fat-ser-lote  for wt-fat-ser-lote.
def buffer b-wt-it-docto-imp  for wt-it-docto-imp.
def buffer b-wt-item-embal    for wt-item-embal.
def buffer b-wt-nota-embal    for wt-nota-embal.
def buffer b-wt-msg-docto     for wt-msg-docto.
def buffer b-wt-docto         for wt-docto.

DEF BUFFER bf-natur-temp      FOR natur-oper.

// Funcao
FUNCTION fnRetornaTranspPadraoCli RETURNS CHARACTER (iCodTransp AS INTEGER):
   FIND FIRST transporte
        WHERE transporte.cod-transp = iCodTransp
   NO-LOCK NO-ERROR.

   RETURN IF AVAIL transporte THEN transporte.nome-abrev ELSE ''.           
END FUNCTION.


RUN piEliminaHandles.

/* iniciando handles que serao utilizadas */
RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995. 

RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.

RUN inicializaBOS  IN h-bodi317in (OUTPUT h-bodi317pr,
                                   OUTPUT h-bodi317sd,     
                                   OUTPUT h-bodi317im1bra,
                                   OUTPUT h-bodi317va).




bloc_notas :
DO TRANSACTION ON STOP UNDO bloc_notas, LEAVE bloc_notas:
  
   FIND ped-venda WHERE ped-venda.nr-pedido = p-pedido NO-LOCK NO-ERROR.

   IF NOT AVAIL ped-venda THEN DO:
      RUN piCriaErro (INPUT '0',
                      INPUT 'Pedido nao localizado').

      UNDO bloc_notas, LEAVE bloc_notas.
   END.
    
   
   /* criando cabecalho da nota fiscal */
   RUN pi-cria-cabecalho-nota.

   IF CAN-FIND(FIRST tt-erro) THEN
   DO:

      MESSAGE 'erro nota'
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

      FOR EACH  RowErrors NO-LOCK
          WHERE RowErrors.errorsubtype = "ERROR":
          RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                          INPUT RowErrors.ErrorDescription).
      END.
      
      UNDO bloc_notas, LEAVE bloc_notas.
   END.

   FOR EACH tt-ped-item,
       FIRST ped-item NO-LOCK
       WHERE ped-item.nome-abrev   = tt-ped-item.nome-abrev 
         AND ped-item.nr-pedcli    = tt-ped-item.nr-pedcli 
         AND ped-item.nr-sequencia = tt-ped-item.nr-sequencia
         AND ped-item.it-codigo    = tt-ped-item.it-codigo:
   
       RUN pi-cria-it-fatura.
       IF CAN-FIND(FIRST tt-erro) THEN
       DO:
          MESSAGE 'erro item'
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

          FOR EACH  RowErrors NO-LOCK
              WHERE RowErrors.errorsubtype = "ERROR":
              RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                              INPUT RowErrors.ErrorDescription).
          END.

          UNDO bloc_notas, LEAVE bloc_notas.
       END.

       ASSIGN de-vl-tot-nota = de-vl-tot-nota + ped-item.vl-preori.
   END.


   /* gerando duplicatas
   *********************************************************************************/
   IF NOT CAN-FIND(FIRST wt-fat-duplic WHERE wt-fat-duplic.seq-wt-docto = i-nr-nota-fis) THEN
   DO:
      CREATE wt-fat-duplic.
      ASSIGN wt-fat-duplic.seq-wt-docto = i-nr-nota-fis
             wt-fat-duplic.nr-seq-nota  = 10
             wt-fat-duplic.parcela      = "01"
             wt-fat-duplic.dt-venciment = TODAY + 10
             wt-fat-duplic.vl-parcela   = de-vl-tot-nota
             wt-fat-duplic.vl-comis     = de-vl-tot-nota.
   END.


   /* completando nota fiscal */
   //RUN pi-completa-nota (INPUT '',INPUT YES).

   RUN piSimulacaoNotaFiscal (input  no,
                              input  i-nr-nota-fis,
                              INPUT-OUTPUT TABLE tt-itens-pedido,
                              output       table RowErrors).

   IF CAN-FIND(FIRST RowErrors) THEN
   DO:
      FOR EACH  RowErrors NO-LOCK
          WHERE RowErrors.errorsubtype = "ERROR":
          RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                          INPUT RowErrors.ErrorDescription).
      END.

      UNDO bloc_notas, LEAVE bloc_notas.
   END.


   RUN eliminaRegistrosWorkTable IN h-bodi317sd (input  i-nr-nota-fis,
                                                 input  yes,
                                                 output l-proc-ok-aux).


   RUN piEliminaHandles.

END.

/* Fim */


/* Procedures */
/*=======================================================================================================*/
PROCEDURE pi-cria-cabecalho-nota:
    

  ASSIGN i-nr-nota-fis = 0
         i-seq-item    = 0.

  run leaveCodEstabel in h-bodi317sd (input  ped-venda.cod-estabel,
                                      input  no,
                                      output c-char-aux).

  RUN pi-verif-erro-bodi317sd.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

  RUN criaWtDocto IN h-bodi317sd (INPUT  c-seg-usuario,
                                  INPUT  ped-venda.cod-estabel,
                                  INPUT  c-char-aux,
                                  INPUT  NEXT-VALUE(seq-nota-fiscal),
                                  INPUT  ped-venda.nome-abrev,
                                  INPUT  ped-venda.nr-pedcli,
                                  INPUT  1,
                                  INPUT  9999,
                                  INPUT  today /*c-date-aux*/ ,
                                  INPUT  0,
                                  INPUT  ped-venda.nat-operacao,
                                  INPUT  0,
                                  OUTPUT i-nr-nota-fis, /* Nota */
                                  OUTPUT l-ok).

  RUN pi-verif-erro-bodi317sd.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

  RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.

  FIND FIRST wt-docto 
       WHERE wt-docto.seq-wt-docto = i-nr-nota-fis 
  EXCLUSIVE-LOCK NO-ERROR.

  IF AVAIL wt-docto THEN 
  DO:
     FIND FIRST emitente WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.

     wt-docto.nome-transp  = fnRetornaTranspPadraoCli(emitente.cod-transp).
     wt-docto.nr-tabpre    = ''. 
     wt-docto.ind-lib-nota = TRUE.

     IF wt-docto.peso-bru-tot-inf = 0 THEN wt-docto.peso-bru-tot-inf = 1.
     IF wt-docto.peso-liq-tot-inf = 0 THEN wt-docto.peso-liq-tot-inf = 1.
  END.

  RUN pi-verif-erro-bodi317sd.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

  RUN localizaWtDocto  IN h-bodi317sd (INPUT i-nr-nota-fis,OUTPUT l-ok).

  RUN defaultsNrTabpre IN h-bodi317sd (OUTPUT l-ok).

  IF l-ok THEN
  DO:
     RUN emptyRowErrors          IN h-bodi317va.
     RUN setaValidaExp           IN h-bodi317va (INPUT YES). 
     RUN atualizaDadosGeraisNota IN h-bodi317sd (INPUT  i-nr-nota-fis,
                                                 OUTPUT l-ok).                                    
  END.

  RUN pi-verif-erro-bodi317sd.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE pi-cria-it-fatura:

   DEF VAR de-qtde-alocar    AS DEC NO-UNDO.

   
   /*
   ASSIGN de-qtde-pendente = ped-item.qt-pedida - ped-item.qt-atendida. 

   ASSIGN de-qtde-alocar = ped-item.qt-pedida.

   IF p-lista-qtd-aberto THEN 
      ASSIGN de-qtde-alocar = de-qtde-pendente.

    IF p-item-alocado THEN DO:    
       ASSIGN de-qtde-alocar = ped-item.qt-log-aloca.
       IF de-qtde-alocar = 0 THEN NEXT.
    END.*/

  ASSIGN de-qtde-alocar = tt-ped-item.qtde-alocar.

  ASSIGN i-seq-item    = i-seq-item + 10.

  FIND ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.

  
  RUN criaWtItDocto in h-bodi317sd  (INPUT  ?,
                                     INPUT  "",
                                     INPUT  ped-item.nr-sequencia /*i-seq-item*/,
                                     INPUT  ped-item.it-codigo,
                                     INPUT  ped-item.cod-refer,
                                     INPUT  ped-item.nat-operacao,
                                     OUTPUT i-seq-wt-it-docto,
                                     OUTPUT l-ok).

  
  RUN pi-verif-erro-bodi317sd.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".
  
  RUN emptyRowErrors    IN h-bodi317in.

  
  
  RUN WriteUomQuantity  IN h-bodi317sd (INPUT  i-nr-nota-fis,
                                        INPUT  i-seq-wt-it-docto,
                                        INPUT  de-qtde-alocar,  /*ped-item.qt-pedida - ped-item.qt-atendida,*/
                                        INPUT  ITEM.un,
                                        OUTPUT de-quantidade-aux,
                                        OUTPUT l-ok).

  RUN pi-verif-erro-bodi317sd. 
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

 

  RUN atualizaUnMedida1 IN h-bodi317sd (INPUT  i-nr-nota-fis,
                                        INPUT  i-seq-wt-it-docto,
                                        INPUT  ITEM.un,
                                        OUTPUT l-ok).

  RUN gravaInfGeraisWtItDocto IN h-bodi317sd (INPUT i-nr-nota-fis,
                                              INPUT i-seq-wt-it-docto,
                                              INPUT de-quantidade-aux,
                                              INPUT ped-item.vl-preori,
                                              INPUT 0,   /*p-de-val-pct-desconto-tab-preco*/
                                              INPUT 0 ). /*p-de-per-des-item)*/ 

  /****************************************************************************************/

  RUN emptyRowErrors        IN h-bodi317in.
  RUN localizaWtDocto       IN h-bodi317pr(INPUT  i-nr-nota-fis,
                                           OUTPUT l-ok).

  RUN localizaWtItDocto     IN h-bodi317pr(INPUT  i-nr-nota-fis,
                                           INPUT  i-seq-wt-it-docto,
                                           OUTPUT l-ok).

  RUN localizaWtItImposto   IN h-bodi317pr(INPUT  i-nr-nota-fis,
                                           INPUT  i-seq-wt-it-docto,
                                           OUTPUT l-ok).

  RUN atualizaDadosItemNota IN h-bodi317pr(OUTPUT l-ok).

  RUN pi-verif-erro-bodi317pr.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".
  
  /* buscando locais do estoque onde serÆo baixados os materiais */
  
  FIND FIRST wt-it-docto 
       WHERE wt-it-docto.seq-wt-docto    = i-nr-nota-fis
         AND wt-it-docto.seq-wt-it-docto = i-seq-wt-it-docto 
  NO-LOCK NO-ERROR.
  
  IF AVAIL wt-it-docto THEN 
  DO:
     /* limpando locais sugeridos pelo sistema */
     FOR EACH  wt-fat-ser-lote EXCLUSIVE-LOCK
         WHERE wt-fat-ser-lote.seq-wt-docto    = wt-it-docto.seq-wt-docto
           AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
           AND wt-fat-ser-lote.it-codigo       = wt-it-docto.it-codigo
           AND wt-fat-ser-lote.cod-refer       = wt-it-docto.cod-refer :
  
         DELETE wt-fat-ser-lote.
     END.
     
     /* criando locais onde serÆo feitas as baixas */

     FOR EACH tt-saldo-estoq: DELETE tt-saldo-estoq. END.

     for each saldo-estoq NO-LOCK
        where saldo-estoq.it-codigo    = wt-it-docto.it-codigo
          AND saldo-estoq.cod-estabel  = ped-venda.cod-estabel: 

         IF saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod > 0 THEN DO:
            create tt-saldo-estoq.
            assign tt-saldo-estoq.it-codigo     = saldo-estoq.it-codigo
                   tt-saldo-estoq.cod-estabel   = saldo-estoq.cod-estabel
                   tt-saldo-estoq.cod-depos     = saldo-estoq.cod-depos
                   tt-saldo-estoq.cod-refer     = saldo-estoq.cod-refer
                   tt-saldo-estoq.cod-localiz   = saldo-estoq.cod-localiz
                   tt-saldo-estoq.lote          = saldo-estoq.lote
                   tt-saldo-estoq.dt-vali-lote  = saldo-estoq.dt-vali-lote
                   tt-saldo-estoq.qtidade-atu   = saldo-estoq.qtidade-atu
                   tt-saldo-estoq.qt-disponivel = saldo-estoq.qtidade-atu  -
                                                  saldo-estoq.qt-alocada   -
                                                  saldo-estoq.qt-aloc-prod. 
         END.
     end.

     FIND FIRST tt-saldo-estoq WHERE tt-saldo-estoq.qt-disponivel >= ped-item.qt-pedida NO-ERROR.

     IF AVAIL tt-saldo-estoq THEN DO:
        RUN setCodRefer            IN h-bodi317sd (INPUT  "" /* cod-refer */).
        RUN criaAlteraWtFatSerLote IN h-bodi317sd (INPUT  YES, /* Yes: Inc. / No: Alt. */
                                                   INPUT  wt-it-docto.seq-wt-docto,
                                                   INPUT  wt-it-docto.seq-wt-it-docto,
                                                   INPUT  wt-it-docto.it-codigo,
                                                   INPUT  tt-saldo-estoq.cod-depos,
                                                   INPUT  '', //LOCALIZACAO
                                                   INPUT  '', //LOTE
                                                   INPUT  de-quantidade-aux,  //QTDE
                                                   INPUT  0,
                                                   INPUT  ?,
                                                   OUTPUT l-ok).
      
        RUN trataErros IN h-bodi317sd (INPUT l-ok, 
                                       INPUT "bodi317sd", 
                                       INPUT h-bodi317sd).
      
        IF NOT l-ok THEN
        DO:
           RUN pi-verif-erro-bodi317sd. 
           IF CAN-FIND(FIRST tt-erro) THEN
              RETURN "NOK".
        END.
     END.
  END.
  
  RUN pi-verif-erro-bodi317sd. 
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".

  RUN emptyRowErrors        IN h-bodi317in.
  RUN defineUsaWarning      IN h-bodi317va(INPUT  YES).
  RUN validaItemDaNota      IN h-bodi317va(INPUT  i-nr-nota-fis,
                                           INPUT  i-seq-wt-it-docto,
                                           OUTPUT l-ok).

  RUN defineUsaWarning      IN h-bodi317va(INPUT  NO).
  
  RUN pi-verif-erro-bodi317sd. 
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".
  
  /* --- acumulando total da nota   --- */
  /* --- atualiza narrativa do item --- */    
  /*
  FIND FIRST wt-it-docto 
       WHERE wt-it-docto.seq-wt-docto    = i-nr-nota-fis
         AND wt-it-docto.seq-wt-it-docto = i-seq-wt-it-docto 
  EXCLUSIVE-LOCK NO-ERROR.

  IF AVAIL wt-it-docto THEN 
     ASSIGN wt-it-docto.narrativa = wt-it-docto.narrativa + ttDadosItemDaNota.narrativa
            de-vl-tot-nota        = de-vl-tot-nota        + (wt-it-docto.vl-preuni * wt-it-docto.quantidade[1])
            /*wt-it-docto.class-fiscal = ITEM.class-fiscal*/.
            */

END PROCEDURE.

PROCEDURE pi-completa-nota:
  DEF INPUT PARAM prObservacaoNota AS CHAR NO-UNDO.
  DEF INPUT PARAM prAtualizaNota   AS LOG  NO-UNDO.

  
  FIND FIRST wt-docto  
       WHERE wt-docto.seq-wt-docto = i-nr-nota-fis 
  EXCLUSIVE-LOCK NO-ERROR.

  IF prAtualizaNota THEN 
  DO:
     RUN pi-calcula.
     IF CAN-FIND(FIRST RowErrors) THEN
     DO:
        FOR EACH  RowErrors NO-LOCK
            WHERE RowErrors.errorsubtype = "ERROR":
            RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                            INPUT RowErrors.ErrorDescription).
        END.
    
        RETURN "NOK".
     END.

     /*
     RUN pi-finaliza-nota.
     IF CAN-FIND(FIRST RowErrors) THEN
     DO:
        FOR EACH  RowErrors NO-LOCK
            WHERE RowErrors.errorsubtype = "ERROR":
            RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                            INPUT RowErrors.ErrorDescription).
        END.
    
        RETURN "NOK".
     END.*/
  END.

  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE piSimulacaoNotaFiscal:
  def input  param p-l-calculo      as log form "Calculo/Simula‡Æo" no-undo.
  def input  param p-i-seq-wt-docto as int no-undo.
  DEF INPUT-OUTPUT PARAM TABLE FOR tt-itens-pedido.
  def output       param table for rowerrors.

  def var de-aliq-pis        as dec no-undo.
  def var de-val-base-pis    as dec no-undo.
  def var de-val-pis         as dec no-undo.
  def var de-aliq-cofins     as dec no-undo.
  def var de-val-base-cofins as dec no-undo.
  def var de-val-cofins      as dec no-undo.


  IF NOT VALID-HANDLE(h-bodi317in) THEN
  DO:
     run dibo/bodi317in.p persistent set h-bodi317in.
   
     run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                      output h-bodi317sd,     
                                      output h-bodi317im1bra,
                                      output h-bodi317va).
  END.

  
  run inicializaAcompanhamento in h-bodi317pr.
  
  run emptyRowErrors           in h-bodi317in.
      
  assign i-seq-wt-docto-aux = p-i-seq-wt-docto * -1.
  
  run criaRegistrosAuxiliares (p-i-seq-wt-docto, i-seq-wt-docto-aux).
  
  run retornaVariaveisParaCalculoImpostos in h-bodi317sd (input  i-seq-wt-docto-aux,
                                                          output l-nf-man-dev-terc-dif,
                                                          output l-recal-apenas-totais,
                                                          output l-proc-ok-aux).

  run recebeVariavelTipoCalculoImpostos   in h-bodi317im1bra (input if l-recal-apenas-totais 
                                                                    then 1
                                                                    else 0,
                                                                    output l-proc-ok-aux).

  RUN setaValidaExp            IN h-bodi317va (INPUT YES).
  run confirmaCalculo          in h-bodi317pr(input  i-seq-wt-docto-aux,
                                              output l-proc-ok-aux).
  run finalizaAcompanhamento   in h-bodi317pr.
  run devolveErrosbodi317pr    in h-bodi317pr(output c-ultimo-metodo-exec,
                                              output table RowErrors).
  
  if  not l-proc-ok-aux then do:
      run eliminaRegistrosAuxiliares (i-seq-wt-docto-aux).
      if  valid-handle(h-bodi317in) then do:
          run finalizaBOS in h-bodi317in.
          assign h-bodi317in = ?.
      end.
      return.
  end.

  //FOR EACH tt-itens-pedido: DELETE tt-itens-pedido. END.

  FOR EACH wt-it-imposto NO-LOCK
     WHERE wt-it-imposto.seq-wt-docto = i-seq-wt-docto-aux,
      FIRST wt-it-docto OF wt-it-imposto NO-LOCK,
      FIRST wt-docto OF wt-it-docto NO-LOCK :

      
      CREATE tt-itens-pedido.
      BUFFER-COPY wt-it-docto TO tt-itens-pedido.

      
      RUN piBuscaPisCofins IN h-cdapi995 (INPUT  "wt-it-docto",
                                          INPUT  ROWID(wt-it-docto),
                                          INPUT  NO, /* sempre recalcular, para quando o usu rio mudar a parametriza‡Æo, o c lculo ser refeito na simula‡Æo*/
                                          INPUT  NO,
                                          OUTPUT de-aliq-pis,
                                          OUTPUT de-val-base-pis,
                                          OUTPUT de-val-pis,
                                          OUTPUT de-aliq-cofins,
                                          OUTPUT de-val-base-cofins,
                                          OUTPUT de-val-cofins).

      ASSIGN tt-itens-pedido.vl-ipi             = wt-it-imposto.vl-ipi-it 
             tt-itens-pedido.vl-base-calc-ipi   = wt-it-imposto.vl-bipi-it 
             tt-itens-pedido.aliq-ipi           = wt-it-imposto.aliquota-ipi
                                                
             tt-itens-pedido.vl-pis             = de-val-pis
             tt-itens-pedido.vl-base-calc-pis   = de-val-base-pis
             tt-itens-pedido.aliq-pis           = de-aliq-pis
                                                
             tt-itens-pedido.vl-cofins           = de-val-cofins
             tt-itens-pedido.vl-base-calc-cofins = de-val-base-cofins
             tt-itens-pedido.aliq-cofins         = de-aliq-cofins
                                                
             tt-itens-pedido.vl-icms            = wt-it-imposto.vl-icms-it
             tt-itens-pedido.vl-base-calc-icms  = wt-it-imposto.vl-bicms-it
             tt-itens-pedido.aliq-icms          = wt-it-imposto.aliquota-icm
                                                
             tt-itens-pedido.vl-st              = wt-it-imposto.vl-icmsub-it
             tt-itens-pedido.vl-base-calc-st    = wt-it-imposto.vl-bsubs-it  
             tt-itens-pedido.aliq-st            = DEC(SUBSTRING(wt-it-imposto.char-1,71,6)).

             /*
      MESSAGE 'piSimulacaoNotaFiscal   '  wt-docto.nr-pedcli SKIP 
              'frete: ' wt-docto.vl-frete-inf SKIP 
              'IPI: ' tt-itens-pedido.vl-ipi   SKIP 
              'ST: ' tt-itens-pedido.vl-st       SKIP 
              'Valor Item: ' tt-itens-pedido.vl-tot-item
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.     */
      

      /*
      MESSAGE "==============================" skip
              "ICMS"                           skip
              wt-it-imposto.vl-bicms-it        skip
              wt-it-imposto.aliquota-icm       skip
              wt-it-imposto.vl-icms-it         skip
              wt-it-imposto.vl-icmsnt-it       skip
              wt-it-imposto.vl-icmsou-it       skip
              wt-it-imposto.perc-red-icm       skip
              "==============================" skip
              "IPI"                            skip
              wt-it-imposto.vl-bipi-it         skip
              wt-it-imposto.aliquota-ipi       skip
              wt-it-imposto.vl-ipi-it          skip
              wt-it-imposto.vl-ipint-it        skip
              wt-it-imposto.vl-ipiou-it        skip
              wt-it-imposto.perc-red-ipi       SKIP
              "==============================" skip
              "ST"                                       SKIP         
              wt-it-imposto.vl-bsubs-it                  SKIP       
              wt-it-imposto.vl-icmsub-it                 SKIP    
              DEC(SUBSTRING(wt-it-imposto.char-1,71,6))  SKIP 
              dec(SUBSTRING(wt-it-imposto.char-1,344,7)) SKIP
       VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
       
  END.

  run eliminaRegistrosAuxiliares (i-seq-wt-docto-aux).
  if  valid-handle(h-bodi317in) then do:
      run finalizaBOS in h-bodi317in.
      assign h-bodi317in = ?.
  end.

END PROCEDURE.


/*=======================================================================================================*/
procedure criaRegistrosAuxiliares:
    DEF INPUT PARAM p-i-seq-wt-docto    AS INT NO-UNDO.
    DEF INPUT PARAM pr-seq-wt-docto-aux AS INT NO-UNDO.

    for each wt-nota-trans
        where wt-nota-trans.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-nota-trans.
        buffer-copy wt-nota-trans except wt-nota-trans.seq-wt-docto 
                 to b-wt-nota-trans 
                 assign b-wt-nota-trans.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-fat-duplic
        where wt-fat-duplic.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-fat-duplic.
        buffer-copy wt-fat-duplic except wt-fat-duplic.seq-wt-docto 
                 to b-wt-fat-duplic 
                 assign b-wt-fat-duplic.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-fat-repre    
        where wt-fat-repre.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-fat-repre.
        buffer-copy wt-fat-repre except wt-fat-repre.seq-wt-docto 
                 to b-wt-fat-repre 
                 assign b-wt-fat-repre.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-it-docto  
        where wt-it-docto.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-it-docto.
        buffer-copy wt-it-docto except wt-it-docto.seq-wt-docto 
                 to b-wt-it-docto 
                 assign b-wt-it-docto.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-it-imposto   
        where wt-it-imposto.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-it-imposto.
        buffer-copy wt-it-imposto except wt-it-imposto.seq-wt-docto 
                 to b-wt-it-imposto 
                 assign b-wt-it-imposto.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-fat-ser-lote 
        where wt-fat-ser-lote.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-fat-ser-lote.
        buffer-copy wt-fat-ser-lote except wt-fat-ser-lote.seq-wt-docto 
                 to b-wt-fat-ser-lote 
                 assign b-wt-fat-ser-lote.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-it-docto-imp
        where wt-it-docto-imp.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-it-docto-imp.
        buffer-copy wt-it-docto-imp except wt-it-docto-imp.seq-wt-docto 
                 to b-wt-it-docto-imp 
                 assign b-wt-it-docto-imp.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-item-embal   
        where wt-item-embal.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-item-embal.
        buffer-copy wt-item-embal except wt-item-embal.seq-wt-docto 
                 to b-wt-item-embal 
                 assign b-wt-item-embal.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-nota-embal   
        where wt-nota-embal.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-nota-embal.
        buffer-copy wt-nota-embal except wt-nota-embal.seq-wt-docto 
                 to b-wt-nota-embal 
                 assign b-wt-nota-embal.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-msg-docto
        where wt-msg-docto.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:
        create b-wt-msg-docto.
        buffer-copy wt-msg-docto except wt-msg-docto.seq-wt-docto 
                 to b-wt-msg-docto 
                 assign b-wt-msg-docto.seq-wt-docto = pr-seq-wt-docto-aux.
    end.

    for each wt-docto
        where wt-docto.seq-wt-docto = p-i-seq-wt-docto exclusive-lock:        
        create b-wt-docto.
        buffer-copy wt-docto except wt-docto.seq-wt-docto 
                 to b-wt-docto 
                 assign b-wt-docto.seq-wt-docto = pr-seq-wt-docto-aux.
    end.
end procedure.

/*=======================================================================================================*/
procedure eliminaRegistrosAuxiliares:
    DEF INPUT PARAM pr-seq-wt-docto-aux AS INT NO-UNDO.
    
    for each wt-nota-trans
        where wt-nota-trans.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-nota-trans.
    end.
    
    for each wt-fat-duplic
        where wt-fat-duplic.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-fat-duplic.
    end.
    
    for each wt-fat-repre    
        where wt-fat-repre.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-fat-repre.
    end.
    
    for each wt-it-docto  
        where wt-it-docto.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-it-docto.
    end.
    
    for each wt-it-imposto   
        where wt-it-imposto.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-it-imposto.
    end.
    
    for each wt-fat-ser-lote 
        where wt-fat-ser-lote.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-fat-ser-lote.
    end.
    
    for each wt-it-docto-imp
        where wt-it-docto-imp.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-it-docto-imp.
    end.
    
    for each wt-item-embal   
        where wt-item-embal.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-item-embal.
    end.
    
    for each wt-nota-embal   
        where wt-nota-embal.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-nota-embal.
    end.
    
    for each wt-msg-docto
        where wt-msg-docto.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:
        delete wt-msg-docto.
    end.
    
    for each wt-docto
        where wt-docto.seq-wt-docto = pr-seq-wt-docto-aux exclusive-lock:        
        delete wt-docto.
    end.
end procedure.

/*=======================================================================================================*/
PROCEDURE pi-calcula:
   
  RUN emptyRowErrors           IN h-bodi317in.
  
  RUN inicializaAcompanhamento IN h-bodi317pr.

  RUN retornaVariaveisParaCalculoImpostos IN h-bodi317sd     (INPUT  i-nr-nota-fis, /*NR Documento */
                                                              OUTPUT l-nf-man-dev-terc-dif,
                                                              OUTPUT l-recal-apenas-totais,
                                                              OUTPUT l-ok).

  RUN recebeVariavelTipoCalculoImpostos   IN h-bodi317im1bra (INPUT IF l-recal-apenas-totais 
                                                              THEN 1
                                                              ELSE 0,
                                                              OUTPUT l-ok).

  RUN setaValidaExp            IN h-bodi317va (INPUT  YES).

  RUN confirmaCalculo          IN h-bodi317pr (INPUT  i-nr-nota-fis,
                                               OUTPUT l-ok).

  /*
  MESSAGE 'ConfirmaCalculo' SKIP 
          l-ok
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/


  RUN finalizaAcompanhamento   IN h-bodi317pr.

  RUN pi-verif-erro-bodi317pr.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".
  
  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE pi-finaliza-nota:

  RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.
  
  RUN emptyRowErrors           IN h-bodi317in.
  RUN inicializaAcompanhamento IN h-bodi317ef.

  RUN setaHandlesBOS           IN h-bodi317ef (h-bodi317pr,
                                               h-bodi317sd, 
                                               h-bodi317im1bra,
                                               h-bodi317va). 
                                              
  RUN efetivaNota              IN h-bodi317ef (INPUT i-nr-nota-fis,
                                               INPUT YES,
                                               OUTPUT l-ok).                                    
  
  RUN finalizaAcompanhamento   IN h-bodi317ef. 
  
  RUN pi-verif-erro-bodi317ef.
  IF CAN-FIND(FIRST tt-erro) THEN
     RETURN "NOK".
  
  /* Busca as notas fiscais geradas */
  RUN buscaTTNotasGeradas      IN h-bodi317ef (OUTPUT l-ok,
                                               OUTPUT TABLE tt-notas-geradas).
  
  FOR EACH tt-notas-geradas NO-LOCK:
      c-notas-geradas = c-notas-geradas + (IF c-notas-geradas <> '' THEN ';' ELSE '') + tt-notas-geradas.nr-nota.
  END.                                           
  
  /* Elimina o handle do programa bodi317ef */
  DELETE PROCEDURE h-bodi317ef.

  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE pi-verif-erro-bodi317sd :
    
  EMPTY TEMP-TABLE RowErrors.
  
  RUN devolveErrosbodi317sd IN h-bodi317sd (OUTPUT c-ultimo-metodo-exec,
                                            OUTPUT TABLE RowErrors).

  IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN
  DO:
     FOR EACH  RowErrors NO-LOCK
         WHERE RowErrors.errorsubtype = "ERROR":

         RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                         INPUT RowErrors.ErrorDescription).

     END.
     
     RUN emptyRowErrors IN h-bodi317sd.

     RETURN "NOK".
  END.
  
  RUN emptyRowErrors IN h-bodi317sd.

  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE pi-verif-erro-bodi317pr :

  EMPTY TEMP-TABLE RowErrors.
  
  RUN devolveErrosbodi317pr IN h-bodi317pr (OUTPUT c-ultimo-metodo-exec,
                                            OUTPUT TABLE RowErrors).
  
  IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN
  DO:
     FOR EACH  RowErrors NO-LOCK
         WHERE RowErrors.errorsubtype = "ERROR":

         RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                         INPUT RowErrors.ErrorDescription).

     END.
     
     RUN emptyRowErrors IN h-bodi317pr.

     RETURN "NOK".
  END.
  
  RUN emptyRowErrors IN h-bodi317pr.

  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE pi-verif-erro-bodi317ef :

  EMPTY TEMP-TABLE RowErrors.
  
  RUN devolveErrosbodi317ef IN h-bodi317ef (OUTPUT c-ultimo-metodo-exec,
                                            OUTPUT TABLE RowErrors).
  
  IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN
  DO:
     FOR EACH  RowErrors NO-LOCK
         WHERE RowErrors.errorsubtype = "ERROR":
  
         RUN piCriaErro (INPUT RowErrors.ErrorNumber,
                         INPUT RowErrors.ErrorDescription).
  
     END.
     
     RUN emptyRowErrors IN h-bodi317ef.
  
     RETURN "NOK".
  END.
  
  RUN emptyRowErrors IN h-bodi317ef.
  
  RETURN "OK".

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE piCriaErro :
  DEF INPUT PARAM prCodErro AS INT  NO-UNDO. 
  DEF INPUT PARAM prTxtErro AS CHAR NO-UNDO.

  CREATE tt-erro.
  ASSIGN iSeqMsg          = iSeqMsg + 1
         tt-erro.i-sequen = iSeqMsg
         tt-erro.cd-erro  = prCodErro
         tt-erro.mensagem = prTxtErro + (IF cComplMsgErro <> '' THEN ' - ' ELSE '') + cComplMsgErro.

END PROCEDURE.

/*=======================================================================================================*/
PROCEDURE piEliminaHandles :
  IF VALID-HANDLE(h-bodi317pr)     THEN DO: DELETE PROCEDURE h-bodi317pr.     h-bodi317pr     = ?. END.  
  IF VALID-HANDLE(h-bodi317sd)     THEN DO: DELETE PROCEDURE h-bodi317sd.     h-bodi317sd     = ?. END.  
  IF VALID-HANDLE(h-bodi317in)     THEN DO: DELETE PROCEDURE h-bodi317in.     h-bodi317in     = ?. END.  
  IF VALID-HANDLE(h-bodi317va)     THEN DO: DELETE PROCEDURE h-bodi317va.     h-bodi317va     = ?. END.  
  IF VALID-HANDLE(h-bodi317im1bra) THEN DO: DELETE PROCEDURE h-bodi317im1bra. h-bodi317im1bra = ?. END.
  IF VALID-HANDLE(h-bodi317ef)     THEN DO: DELETE PROCEDURE h-bodi317ef.     h-bodi317ef     = ?. END. 

  IF VALID-HANDLE(h-cdapi995) THEN DO: 
     RUN pi-finalizar in h-cdapi995. 
     DELETE PROCEDURE h-cdapi995 NO-ERROR.
     ASSIGN h-cdapi995 = ?. 
  END.        

END PROCEDURE.

