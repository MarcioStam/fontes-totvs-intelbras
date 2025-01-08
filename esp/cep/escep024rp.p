{include/i-prgvrs.i ESCEP024 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESCEP024RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Listagem de Requisicoes
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/cep/escep024tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

def var i-cont as INT NO-UNDO.
def var c-local    as char format "X(13)" NO-UNDO.
/****************************  Temp-Tables  ****************************/
def buffer b-it-requisicao for it-requisicao.
def temp-table tt-it-req
    field seq as int format ">>9"
    field it-codigo like item.it-codigo
    field qt-a-atender as dec
    field tel as dec
    field smd as dec
    field inj as dec
    field pci as dec
    field plc as dec
    field cnt as dec
    field isf as dec
    field ast as dec
    field kan as dec
    field out as dec
    field pdo as dec
    field iao as dec
    field iac as dec
    field ias as dec
    field iat as dec
    field cob as dec    
    field reservas as dec
    field bloq as log
    FIELD cod-depos AS CHARACTER
    FIELD saldo     AS DECIMAL.
DEF TEMP-TABLE tt-saldo-estoq
    FIELD it-codigo AS CHARACTER
    FIELD prioridade AS INTEGER
    FIELD cod-depos AS CHARACTER
    FIELD saldo     AS DECIMAL
    INDEX ch-item prioridade it-codigo.

/****************************  Frames       ****************************/
form header
"       Item Descricao                    Local    Qtde" skip
"    TEL   CNT    PCI    INJ    SMD    PLC    ISF    KAN    AST    PDO    IAO    IAC    IAS    IAT    COB      OUT"    
 skip
fill("-",135) format "x(135)"
with page-top frame header-frame width 255 NO-BOX STREAM-IO.


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
DEF VAR i-posicao    AS INTEGER.
DEF VAR i-libera     AS INTEGER.
DEF VAR etiq1-requisicao LIKE requisicao.nr-requisicao.
DEF VAR etiq1-item   LIKE ped-item.it-codigo.
DEF VAR etiq1-dep    AS CHAR. 
DEF VAR etiq1-qtde   LIKE ped-item.qt-pedida.
DEF VAR etiq2-requisicao LIKE requisicao.nr-requisicao.
DEF VAR etiq2-item   LIKE ped-item.it-codigo.
DEF VAR etiq2-dep    AS CHAR. 
DEF VAR etiq2-qtde   LIKE ped-item.qt-pedida.
DEF VAR etiq3-requisicao LIKE requisicao.nr-requisicao.
DEF VAR etiq3-item   LIKE ped-item.it-codigo.
DEF VAR etiq3-dep    AS CHAR. 
DEF VAR etiq3-qtde   LIKE ped-item.qt-pedida.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Listagem de Requisi‡äes"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESCEP024"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    run utp/ut-acomp.p persistent set h-acomp.  
    IF tt-param.tipo-relatorio = 1 THEN DO:
        VIEW FRAME f-cabec.
        VIEW FRAME f-rodape.
    END.
    
    RUN piMontaRelat.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.


PROCEDURE piMontaRelat:
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

  for each requisicao no-lock
      where requisicao.nr-requisicao >= tt-param.ini-nr-requisicao
        and requisicao.nr-requisicao <= tt-param.fim-nr-requisicao
        AND requisicao.cod-estabel    = tt-param.cod-estabel
        and requisicao.situacao = 1
        and requisicao.estado = 1:
         
      RUN pi-acompanhar IN h-acomp (INPUT STRING(requisicao.nr-requisicao)).

      for each tt-it-req:
          delete tt-it-req.
      end.

      /* agrupamento de itens iguais */
      
      for each it-requisicao 
          where it-requisicao.nr-requisicao = requisicao.nr-requisicao
            and it-requisicao.qt-a-atender > 0:
          for each b-it-requisicao 
              where b-it-requisicao.nr-requisicao = requisicao.nr-requisicao
                and b-it-requisicao.it-codigo = it-requisicao.it-codigo
                and recid(b-it-requisicao) <> recid(it-requisicao):
              assign it-requisicao.qt-a-atender = 
                                  it-requisicao.qt-a-atender +
                                  b-it-requisicao.qt-a-atender
                      it-requisicao.qt-requisitada =
                                  it-requisicao.qt-requisitada +
                                  b-it-requisicao.qt-requisitada
                      
                      it-requisicao.qt-atendida = 
                                  it-requisicao.qt-atendida +
                                  b-it-requisicao.qt-atendida
                      
                      it-requisicao.qt-devolvida =
                                  it-requisicao.qt-devolvida +
                                  b-it-requisicao.qt-devolvida
                      
                      it-requisicao.qt-a-devolver = 
                                  it-requisicao.qt-a-devolver +
                                  b-it-requisicao.qt-a-devolver.
                delete b-it-requisicao.                          
          end.
      end.
      IF tt-param.tipo-relatorio = 1 THEN DO:
          view frame f-cabec.
          view frame f-rodape.
          view frame header-frame.
      END.
      find requisitante 
           where requisitante.nome-abrev = requisicao.nome-abrev 
           no-lock no-error.
      IF tt-param.tipo-relatorio = 1 THEN DO:
          disp "Requisicao ==> " 
               requisicao.nr-requisicao " - "
               requisitante.sc-codigo " - "
               requisicao.nome-abrev
               " - " 
               requisicao.loc-entrega
               " - " when requisicao.narrativa <> ""
               requisicao.narrativa when requisicao.narrativa <> ""
               with no-labels width 132 NO-BOX STREAM-IO.
      END.
      assign i-cont = 0.
      for each it-requisicao  no-lock
          where it-requisicao.nr-requisicao = requisicao.nr-requisicao
            and it-requisicao.qt-a-atender > 0:
          find tt-it-req 
               where tt-it-req.it-codigo = it-requisicao.it-codigo no-error.
          if not avail tt-it-req then do:
              assign i-cont = i-cont + 1.
              create tt-it-req.
          end.
          
          assign tt-it-req.seq = i-cont
                 tt-it-req.it-codigo = it-requisicao.it-codigo
                 tt-it-req.qt-a-atender = tt-it-req.qt-a-atender +
                                          it-requisicao.qt-a-atender.
      end.
      for each tt-it-req:
          for each saldo-estoq no-lock
              where  saldo-estoq.cod-estabel = requisicao.cod-estabel
              and    saldo-estoq.it-codigo = tt-it-req.it-codigo:

             IF tt-param.tipo-relatorio = 2 THEN DO: 
                 CREATE tt-saldo-estoq.
                 ASSIGN tt-saldo-estoq.it-codigo = saldo-estoq.it-codigo
                        tt-saldo-estoq.saldo     = saldo-estoq.qtidade-atu
                        tt-saldo-estoq.cod-depos = saldo-estoq.cod-depos .
                 IF  saldo-estoq.cod-depos = "ast" AND
                     saldo-estoq.cod-localiz = "pdo" THEN 
                     ASSIGN tt-saldo-estoq.prioridade = 1.
                 ELSE
                     IF saldo-estoq.cod-depos = "pdo" THEN
                        ASSIGN tt-saldo-estoq.prioridade = 2.
                     ELSE
                         IF saldo-estoq.cod-depos = "ast" AND 
                            saldo-estoq.cod-localiz = "" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 3.
                         ELSE
                         IF saldo-estoq.cod-depos = "ast" AND 
                            saldo-estoq.cod-localiz = "mex" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 4.
                         ELSE
                         IF saldo-estoq.cod-depos = "smd" OR
                             saldo-estoq.cod-depos = "wsm" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 5.
                         ELSE
                         IF saldo-estoq.cod-depos = "plc" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 6.
                         ELSE
                         IF saldo-estoq.cod-depos = "cnt" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 7. 
                         ELSE
                         IF saldo-estoq.cod-depos = "psf" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 8.
                         ELSE
                         IF saldo-estoq.cod-depos = "isf" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 9.
                         ELSE
                         IF saldo-estoq.cod-depos = "pci" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 10.
                         ELSE
                         IF saldo-estoq.cod-depos = "tel" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 11.
                         ELSE
                         IF saldo-estoq.cod-depos = "inj" OR 
                             saldo-estoq.cod-depos = "win" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 12.
                         ELSE
                         IF saldo-estoq.cod-depos = "alm" OR 
                             saldo-estoq.cod-depos = "wal" THEN
                            ASSIGN tt-saldo-estoq.prioridade = 13.


             END.
             ELSE DO:
                 /* REVER 
                  if substr(saldo-estoq.u-char-1,1,1) <> "" then
                     assign tt-it-req.bloq = yes.
                  */     
                  case saldo-estoq.cod-depos:
                       when "tel" then assign tt-it-req.tel = tt-it-req.tel +
                                       saldo-estoq.qtidade-atu.
                       when "cnt" then assign tt-it-req.cnt = tt-it-req.cnt +
                                       saldo-estoq.qtidade-atu.
                       when "pci" then assign tt-it-req.pci = tt-it-req.pci +
                                       saldo-estoq.qtidade-atu.
                       when "inj" then assign tt-it-req.inj = tt-it-req.inj +
                                       saldo-estoq.qtidade-atu.
                       when "win" then assign tt-it-req.inj = tt-it-req.inj +
                                       saldo-estoq.qtidade-atu.
                       when "smd" then assign tt-it-req.smd = tt-it-req.smd +
                                       saldo-estoq.qtidade-atu.
                       when "wsm" then assign tt-it-req.smd = tt-it-req.smd +
                                       saldo-estoq.qtidade-atu.
                       when "plc" then assign tt-it-req.plc = tt-it-req.plc +
                                       saldo-estoq.qtidade-atu.
                       when "isf" then assign tt-it-req.isf = tt-it-req.isf +
                                       saldo-estoq.qtidade-atu.
                       when "pdo" then assign tt-it-req.pdo = tt-it-req.pdo +
                                       saldo-estoq.qtidade-atu.
                       when "ast" then do:
                           if saldo-estoq.cod-localiz = "kanbam" then
                               assign tt-it-req.kan = tt-it-req.kan +
                                      saldo-estoq.qtidade-atu.
                           else
                               assign tt-it-req.ast = tt-it-req.ast +
                                      saldo-estoq.qtidade-atu.
                       end.  
                       when "iao" then assign tt-it-req.iao = tt-it-req.iao +
                                       saldo-estoq.qtidade-atu.
                       when "iac" then assign tt-it-req.iac = tt-it-req.iac +
                                       saldo-estoq.qtidade-atu.
                       when "ias" then assign tt-it-req.ias = tt-it-req.ias +
                                       saldo-estoq.qtidade-atu.
                       when "iat" then assign tt-it-req.iat = tt-it-req.iat +
                                       saldo-estoq.qtidade-atu.
                       when "cob" then assign tt-it-req.cob = tt-it-req.cob +
                                       saldo-estoq.qtidade-atu.
                       otherwise assign tt-it-req.out = tt-it-req.out +
                                        saldo-estoq.qtidade-atu.
                  END CASE.
              end.
          end.

/* reservas retiradas por solicitacao de comissao de uso do progama - Ezelaide, Adriana  

- reservas recolocadas por solicitacao da CIDA em 24/04/2003 */

          if requisicao.nome-abrev = "ass tecnica" then do:
             for each reservas no-lock
                 where reservas.estado = 1
                   and reservas.it-codigo = it-requisicao.it-codigo
                   and month(reservas.dt-reserva) = month(today)
                   and year(reservas.dt-reserva) = year(today)
                   and reservas.quant-atend - reservas.quant-orig > 0:
                 assign tt-it-req.reservas = tt-it-req.reservas +
                           reservas.quant-atend - reservas.quant-orig.
             end.
          end.
      end. /***** FOR EACH IT-REQUISICAO ********/


      IF tt-param.tipo-relatorio = 1 THEN DO:
          for each tt-it-req :
              find item where item.it-codigo = tt-it-req.it-codigo no-lock.
              find first ae-item no-lock use-index fifo where
                   ae-item.cod-estabel = tt-param.cod-estabel and
                   ae-item.it-codigo = tt-it-req.it-codigo and
                   not ae-item.situacao no-error.
                   
              if avail ae-item and ae-item.localizacao <> "" then
                 assign c-local = ae-item.localizacao.
              else
                 assign c-local = item.cod-localiz.
                 
              if tt-it-req.bloq then
                 assign c-local = "(*)" + c-local.
                  disp tt-it-req.seq
                       tt-it-req.it-codigo format "x(7)"
                       item.descricao-1 + item.descricao-2 format "X(28)"
                       c-local format "X(8)"
                       tt-it-req.qt-a-atender format ">>>9" skip with no-labels width 255 no-box stream-io.
                       
                  disp tt-it-req.tel format ">>>>>9"
                       tt-it-req.cnt format ">>>>>9"
                       tt-it-req.pci format ">>>>>9"
                       tt-it-req.inj format ">>>>>9"
                       tt-it-req.smd format ">>>>>9"
                       tt-it-req.plc format ">>>>>9"
                       tt-it-req.isf format ">>>>>9"
                       tt-it-req.kan format ">>>>>9"
                       tt-it-req.ast format ">>>>>9"
                       tt-it-req.pdo format ">>>>>9"
                       tt-it-req.iao format ">>>>>9"
                       tt-it-req.iac format ">>>>>9"
                       tt-it-req.ias format ">>>>>9"
                       tt-it-req.iat format ">>>>>9"
                       tt-it-req.cob format ">>>>>9"               
                       tt-it-req.out format ">>>>>>>9"
                       tt-it-req.reservas format ">>>>>>9" 
                       when tt-it-req.reservas > 0 
                       "** > 5%"
                       when tt-it-req.reservas > 0 and
                            (tt-it-req.qt-a-atender > tt-it-req.reservas * 0.05)
                       with no-labels width 255 NO-BOX STREAM-IO.
          end.   
      END.
      ELSE do:
          RUN piOrganizaImpressao.
      END.
   end. /************* FOR EACH REQUISICAO *********/
END.

PROCEDURE piOrganizaImpressao:
    FOR EACH tt-it-req:
        FOR EACH tt-saldo-estoq
            WHERE tt-saldo-estoq.it-codigo = tt-it-req.it-codigo
            BREAK BY tt-saldo-estoq.prioridade:
            IF tt-saldo-estoq.saldo > tt-it-req.saldo THEN DO:
               ASSIGN tt-it-req.saldo     = tt-saldo-estoq.saldo
                      tt-it-req.cod-depos = tt-saldo-estoq.cod-depos.    
               IF tt-saldo-estoq.saldo >= tt-it-req.qt-a-atender THEN DO:
                  LEAVE.
               END.
            END.
        END.
    END.

    i-posicao = 1.
    FOR EACH  tt-it-req BY tt-it-req.cod-depos: 
        IF i-posicao = 1 THEN DO:
           etiq1-requisicao = requisicao.nr-requisicao.
           etiq1-item   =  string(tt-it-req.seq) + " - " + tt-it-req.it-codigo.
           etiq1-dep    = tt-it-req.cod-depos.
           etiq1-qtde   = tt-it-req.qt-a-atender.
           ASSIGN i-posicao = 2.
        END.
        ELSE DO:
           IF i-posicao = 2 THEN DO:
              etiq2-requisicao = requisicao.nr-requisicao.   
              etiq2-item   = string(tt-it-req.seq) + " - " + tt-it-req.it-codigo.
              etiq2-dep    = tt-it-req.cod-depos.        
              etiq2-qtde   = tt-it-req.qt-a-atender.     
              ASSIGN i-posicao = 3.
           END.
           ELSE DO:
              etiq3-requisicao = requisicao.nr-requisicao.   
              etiq3-item   = string(tt-it-req.seq) + " - " + tt-it-req.it-codigo.
              etiq3-dep    = tt-it-req.cod-depos.        
              etiq3-qtde   = tt-it-req.qt-a-atender.     
              ASSIGN i-posicao = 1.
              i-libera = 3.
           END.
        END.

        IF i-libera = 3 THEN DO:
           RUN piImprimeEtiqueta-3. 
               etiq1-requisicao = 0.
               etiq2-requisicao = 0.
               etiq3-requisicao = 0.
               i-posicao = 1.
               i-libera = 1.
        END.

    END.

    
    IF etiq2-requisicao <> 0 THEN DO:
        RUN piImprimeEtiqueta-2. 
    END.
    ELSE DO:
        IF etiq1-requisicao <> 0 THEN DO:
            RUN piImprimeEtiqueta-1. 
        END.
    END.
END PROCEDURE.

PROCEDURE piImprimeEtiqueta-3:
    /* OUTPUT TO \\intel200\zebrabkp. */
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */

        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */

        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ² o numero de Dot‹s que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,35^BY3^A0N,35,Y,N^FD" "Req: " etiq1-requisicao
                                      "^FS"        
        "^FO300,35^BY3^A0N,35,Y,N^FD" "Req: " etiq2-requisicao
                                     "^FS" 
        "^FO570,35^BY3^A0N,35,Y,N^FD" "Req: " etiq3-requisicao
                                     "^FS" 
        SKIP

        "^FO45,70^BY3^A0N,35,Y,N^FD" etiq1-item
                                      "^FS"        
        "^FO300,70^BY3^A0N,35,Y,N^FD" etiq2-item
                                     "^FS" 
        "^FO570,70^BY3^A0N,35,Y,N^FD" etiq3-item
                                     "^FS" 
        SKIP

        "^FO45,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq1-dep
                                      "^FS"        
        "^FO300,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq2-dep
                                     "^FS" 
        "^FO570,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq3-dep
                                     "^FS" 
        SKIP

        "^FO45,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq1-qtde
                                      "^FS"        
        "^FO300,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq2-qtde
                                     "^FS" 
        "^FO570,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq3-qtde
                                     "^FS" 
        "^XZ".    
    OUTPUT CLOSE.
END PROCEDURE.




PROCEDURE piImprimeEtiqueta-2:
    /* OUTPUT TO \\intel200\zebrabkp. */
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */

        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */

        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ² o numero de Dot‹s que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,35^BY3^A0N,35,Y,N^FD" "Req: " etiq1-requisicao
                                      "^FS"        
        "^FO300,35^BY3^A0N,35,Y,N^FD" "Req: " etiq2-requisicao
                                     "^FS" 
        SKIP

        "^FO45,70^BY3^A0N,35,Y,N^FD" etiq1-item
                                      "^FS"        
        "^FO300,70^BY3^A0N,35,Y,N^FD" etiq2-item
                                     "^FS" 
        SKIP

        "^FO45,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq1-dep
                                      "^FS"        
        "^FO300,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq2-dep
                                     "^FS" 
        SKIP

        "^FO45,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq1-qtde
                                      "^FS"        
        "^FO300,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq2-qtde
                                     "^FS" 
        "^XZ".    
    OUTPUT CLOSE.
END PROCEDURE.




PROCEDURE piImprimeEtiqueta-1:
    /* OUTPUT TO \\intel200\zebrabkp. */
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */

        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */

        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ² o numero de Dot‹s que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,35^BY3^A0N,35,Y,N^FD" "Req: " etiq1-requisicao
                                      "^FS"        
        SKIP

        "^FO45,70^BY3^A0N,35,Y,N^FD" etiq1-item
                                      "^FS"        
        SKIP

        "^FO45,105^BY3^A0N,35,Y,N^FD" "Deposito: " etiq1-dep
                                      "^FS"        
        SKIP

        "^FO45,140^BY3^A0N,35,Y,N^FD" "Qtde: " etiq1-qtde
                                      "^FS"        
        "^XZ".    
    OUTPUT CLOSE.
END PROCEDURE.


