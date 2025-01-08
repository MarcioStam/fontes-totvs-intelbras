/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp070rp.p
**  Autor.....: Roger Marcelino Bruhn
**  Data......: 01/11/2012
**  Descricao.: Relat¢rio itens bloqueados
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp070 2.04.00.002}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
DEF BUFFER b-emitente FOR emitente.

FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Aprovaá∆o Pedido"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP070"
       c-versao       = "2.04"
       c-revisao      = "001".

{esp/pdp/espdp070tt.i}
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-obs            AS CHARACTER   NO-UNDO FORMAT 'x(80)'.
DEFINE VARIABLE c-cond-espec     AS CHARACTER   NO-UNDO FORMAT 'x(80)'.
DEFINE VARIABLE de-perc-comissao AS DECIMAL     NO-UNDO.
DEFINE VARIABLE hDBOcomis-rep    AS HANDLE      NO-UNDO.
DEFINE VARIABLE  c-motivo-aprovacao LIKE int-ped-item.motivo-aprovacao.
&GLOBAL-DEFINE ttTable        ttcomis-rep
&GLOBAL-DEFINE hDBOTable      hDBOcomis-rep
&GLOBAL-DEFINE DBOTable       comis-rep


DEF BUFFER b-unid-feder FOR unid-feder.

DEFINE VARIABLE c-texto AS CHAR FORMAT "x(09)" NO-UNDO.
/*---------------------------  ParÉmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR de-liquido LIKE ped-item.vl-preori NO-UNDO.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN piImprimeRelat.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

PROCEDURE piImprimeRelat:

   PUT "Repres;Nome;Cod.Emit;Nome Abrev;Nome;Pedido;Implantaá∆o;Item;Descriá∆o;Seq;Quantidade;Preáo Negociado;Preáo Min. Tab +Imp;STATUS;Èlt Preáo Aprovado;Aprovador;Aprovacao;;Motivo" SKIP.

   FOR EACH ped-venda NO-LOCK
      WHERE ped-venda.dt-implant   >= tt-param.dt-implant-ini
        AND ped-venda.dt-implant   <= tt-param.dt-implant-fim
        AND ped-venda.no-ab-reppri >= tt-param.repres-ini
        AND ped-venda.no-ab-reppri <= tt-param.repres-fim
        AND ped-venda.tp-pedido <> ""
        ,FIRST atendente NO-LOCK
            WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
              AND atendente.aprovador <> ""
              AND atendente.aprovador >= tt-param.aprovador-ini
              AND atendente.aprovador <= tt-param.aprovador-fim
      ,EACH ped-item NO-LOCK
         WHERE  ped-item.nome-abrev   = ped-venda.nome-abrev
           AND  ped-item.nr-pedcli    = ped-venda.nr-pedcli
      ,FIRST emitente NO-LOCK
           WHERE emitente.nome-abrev    = ped-venda.nome-abrev
      ,FIRST repres NO-LOCK
           WHERE repres.nome-abrev = ped-venda.no-ab-reppri
      ,FIRST item FIELDS (it-codigo desc-item) NO-LOCK
            WHERE item.it-codigo = ped-item.it-codigo
      ,FIRST int-ped-item NO-LOCK
           WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
             AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
             AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
             AND int-ped-item.it-codigo    = ped-item.it-codigo
             AND int-ped-item.cod-refer    = ped-item.cod-refer
             AND int-ped-item.ind-status-preco <> 0 /*n∆o existe aprovador, logo n∆o tem que sair no relat¢rio */

            BY ped-venda.dt-implant
            BY ped-venda.nr-pedido
            BY int-ped-item.ind-status-preco:

      RUN pi-acompanhar IN h-acomp (INPUT "Selecionando pedido: " + STRING(ped-venda.nr-pedido)).
      
      IF  tt-param.rs-status = 1  /* Bloqueados */
      AND int-ped-item.ind-status-preco <> 1 THEN NEXT.

      IF  tt-param.rs-status = 2  /* Aprovados */
      AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3) THEN NEXT.

      IF  tt-param.rs-status = 3 /* Reprovados */
      AND int-ped-item.ind-status-preco <> 3 THEN NEXT.
       
      ASSIGN c-texto = IF int-ped-item.ind-status-preco = 1 THEN "Bloqueado"
                                       ELSE IF int-ped-item.ind-status-preco = 2 THEN "Aprovado "
                                            ELSE IF int-ped-item.ind-status-preco = 3 THEN "Reprovado"
                                                 ELSE "ERRO     ".

      ASSIGN de-liquido = ped-item.vl-preori. 

      RUN esp/pdp/espdp074.p (INPUT ped-venda.nome-abrev,
                              INPUT ped-venda.nr-pedcli,   
                              INPUT ped-item.nr-sequencia,
                              INPUT ped-item.it-codigo,   
                              INPUT ped-item.cod-refer,   
                              INPUT NO,
                              INPUT "", 
                              INPUT-OUTPUT de-liquido). /* preori sem os descontos - l°quido */
      ASSIGN c-motivo-aprovacao = replace(int-ped-item.motivo-aprovacao,";","")
             c-motivo-aprovacao = replace(int-ped-item.motivo-aprovacao,"|",";").


      PUT UNFORMATTED
         ped-venda.no-ab-reppri         ";"
         repres.nome                    ";"
         emitente.cod-emitente          ";"
         emitente.nome-abrev            ";"
         emitente.nome-emit             ";"
         ped-venda.nr-pedcli            ";"
         ped-venda.dt-implant           ";"
         ITEM.it-codigo                 ";"
         ITEM.desc-item                 ";"
         ped-item.nr-sequencia          ";"
         ped-item.qt-pedida             ";"
         de-liquido                     ";"
         int-ped-item.preco-tabela      ";"
         c-texto                        ";"
         int-ped-item.ult-preco-aprov   ";"
         int-ped-item.cod-aprovador     ";"
         int-ped-item.data-aprovacao    ";"
         c-motivo-aprovacao SKIP.


   END.

END.

