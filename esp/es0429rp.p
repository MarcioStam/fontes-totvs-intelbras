/*****************************************************************************
**
**   Programa: es0429.p
**
**   Funcao: Checar validade dos manuais e envia e-mail para documentacao
**           checar validade de outras familias e envia e-mail para almox.
**   Data: 01/06/2000
**
**   Autor: Flavio Schoenell - INTELBRAS S/A.
**   EXECUCAO SEMANAL
******************************************************************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    FIELD cod-estabel      AS CHAR
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
/*{include/i-rpvar.i}*/
{upc/btb910za-upc.i}
{esp/es0018.i}
{esp/eslib.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

define variable de-total as decimal format ">>>>,>>>,>>9" extent 12 no-undo.

define variable de-quantidade like ae-item.quantidade format ">>>>,>>>,>>9" no-undo.
DEF BUFFER bf-ae-item FOR ae-item.

def var h-acomp      as handle no-undo.
define variable c-remetente as character no-undo.
define variable c-destino   as character no-undo.
define variable c-assunto   as character no-undo.
define variable c-descemail as character no-undo.
define variable c-arquivo   as character no-undo.
DEF VAR da-dt-corte AS DATE NO-UNDO.
DEF VAR de-saldo LIKE reservas.quant-orig NO-UNDO.

DEFINE VARIABLE de-saldo-estoq LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEFINE VARIABLE i              AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-month        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-year         AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-aux          AS INTEGER   NO-UNDO.

DEFINE VARIABLE de-total-aux   AS DECIMAL FORMAT ">>>>,>>>,>>9" NO-UNDO.

DEFINE TEMP-TABLE tt-ord-res NO-UNDO
    FIELD nr-ord-produ AS INTEGER
    FIELD cod-estabel  AS CHARACTER
    FIELD estado       AS INTEGER
    FIELD it-codigo    AS CHARACTER
    INDEX id IS PRIMARY UNIQUE
          nr-ord-produ.

DEF TEMP-TABLE tt-periodo
    FIELD nr-ae   LIKE ae-item.nr-ae
    FIELD mes     AS INT
    FIELD ano     AS INT
    FIELD tot-qtd AS DECIMAL FORMAT ">>>>,>>>,>>9" 
    FIELD periodo AS CHAR
    INDEX id IS PRIMARY UNIQUE
          nr-ae      
          mes  
          ano.

DEFINE TEMP-TABLE tt-meses
    FIELD periodo AS CHAR
    FIELD posicao AS INT
    FIELD dia     AS DATE
    INDEX id IS PRIMARY UNIQUE
          periodo.

DEF TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto. 
DEF TEMP-TABLE tt-prog-ponto3 NO-UNDO LIKE tt-prog-ponto.

create tt-param.
raw-transfer raw-param to tt-param.
/* checa validade de manuais */
DEF STREAM s-manual.
DEF STREAM s-materiais.

/*assign c-arquivo = session:temp-directory + "manuais.txt"*/
assign c-arquivo   = c-dir-arquivo-session + "manuais.txt"
       da-dt-corte = TODAY + 180.
/*
{include/i-rpcab.i}
{include/i-rpout.i}
*/

/* run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").
*/ 
output stream s-manual to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.

for each ae-item no-lock
   where ae-item.cod-estabel = tt-param.cod-estabel
     and (ae-item.it-codigo begins "112" 
      or  ae-item.it-codigo begins "164")
     and ae-item.situacao = no
     and ae-item.cod-depos = "alm"
    and (ae-item.data-validade < today or ae-item.data-validade = ?),
    each item no-lock
   where item.it-codigo = ae-item.it-codigo
     and item.descricao-1 matches ("*kit manual*")
/*     and item.descricao-1 begins "KIT MANUAL" **/
    /**** retirado por solicitacao de Alessandra(documentacao) ******/
   break by ae-item.it-codigo
         by ae-item.nr-ae
         by ae-item.sequencia:
     
   /* RUN pi-acompanhar IN h-acomp (INPUT "Lendo Item para manuais " + ae-item.it-codigo). */

   if first-of(ae-item.it-codigo) then
      disp STREAM s-manual ae-item.it-codigo format "x(7)"
           item.descricao-1 +
           item.descricao-2 format "x(30)" label "Descricao".
   
   if first-of(ae-item.nr-ae) then 
      disp STREAM s-manual ae-item.nr-ae.

   disp STREAM s-manual ae-item.sequencia
        ae-item.data
        ae-item.quantidade format ">>>,>>9" (total by ae-item.nr-ae by ae-item.it-codigo)
        with width 132.
end.
output STREAM s-manual close.

assign c-remetente = "ems@intelbras.com.br"
       c-destino   = "ems@intelbras.com.br"
       c-assunto   = "Obsolescencia de manuais"
       c-descemail = "Os Manuais listados no arquivo anexo estao na empresa a mais de 6 meses" + chr(10) + chr(13).

FOR EACH tt-prog-ponto:
    DELETE tt-prog-ponto.
END.

RUN esp/es0018p.p (INPUT "es0429",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).
for each tt-prog-ponto:
    ASSIGN c-destino = c-destino + tt-prog-ponto.conteudo + ";".
END.

RUN enviaMail (INPUT c-remetente,
               INPUT c-destino,
               INPUT c-assunto,
               INPUT c-descemail,
               INPUT c-arquivo).

/*************************** Materiais.csv ****************************************/
ASSIGN i-month = month(today)
       i-year  = year(today).

CREATE tt-meses.
ASSIGN tt-meses.periodo = STRING(i-year,"9999") + STRING(i-month,"99")
       tt-meses.dia     = IF i-month = 12 THEN
                          DATE(i-month,31,i-year)
                          ELSE 
                          DATE(i-month + 1,1,i-year) - 1
       tt-meses.posicao = 1.

DO i-aux = 1 TO 11:
    IF i-month = 12 THEN
        ASSIGN i-month = 1
               i-year  = i-year  + 1.
    ELSE
        ASSIGN i-month = i-month + 1.

    CREATE tt-meses.
    ASSIGN tt-meses.periodo = STRING(i-year,"9999") + STRING(i-month,"99")
           tt-meses.dia     = IF i-month = 12 THEN
                              DATE(i-month,31,i-year)
                              ELSE 
                              DATE(i-month + 1,1,i-year) - 1
           tt-meses.posicao = i-aux + 1.
END.


FOR EACH tt-prog-ponto3:
    DELETE tt-prog-ponto3.
END.

RUN esp/es0018p.p (INPUT "es0429",
                   INPUT 3,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto3).

FOR EACH tt-prog-ponto3 NO-LOCK:

    /* assign c-arquivo = session:temp-directory + "materiais-" + tt-prog-ponto3.conteudo + ".csv". */
    assign c-arquivo = c-dir-arquivo-session + "materiais-" + tt-prog-ponto3.conteudo + ".csv".

    output stream s-materiais to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.
    
    PUT STREAM s-materiais "Item;Descricao;Nr AE;Localizacao;Data;Data Validade;Saldo Estoq(ALM);Pre‡o M‚dio;".
    FOR EACH tt-meses:
        PUT STREAM s-materiais STRING(MONTH(tt-meses.dia),"99") "/" STRING(YEAR(tt-meses.dia),"9999") ";". 
    END.
    
    PUT STREAM s-materiais SKIP.
    
    FOR LAST tt-meses:
    END.

    for each familia no-lock,
        each int-familia of familia
       where int-familia.meses-validade > 0,
        each item no-lock
       where item.fm-codigo = familia.fm-codigo,
        each ae-item no-lock
       where ae-item.cod-estabel = tt-prog-ponto3.conteudo
         and ae-item.it-codigo = item.it-codigo
         and ae-item.situacao = no
         and (ae-item.cod-depos = "alm" or ae-item.cod-depos = "exp")
         and (ae-item.data-validade = ? or ae-item.data-validade < tt-meses.dia)
       break by ae-item.it-codigo
             by ae-item.nr-ae
             by ae-item.sequencia:
    
        /* RUN pi-acompanhar IN h-acomp (INPUT "Lendo AE vencida do item " + ae-item.it-codigo). */
    
        IF  ae-item.data-validade = ?     OR 
            ae-item.data-validade < TODAY THEN
            ASSIGN i-month = month(today)
                   i-year  = year(today).        
        ELSE
            ASSIGN i-month = month(ae-item.data-validade)
                   i-year  = year(ae-item.data-validade).
            
        FIND FIRST tt-periodo
             WHERE tt-periodo.nr-ae = ae-item.nr-ae
               AND tt-periodo.mes   = i-month
               AND tt-periodo.ano   = i-year NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-periodo THEN DO:
            CREATE tt-periodo.
            ASSIGN tt-periodo.nr-ae   = ae-item.nr-ae               
                   tt-periodo.mes     = i-month
                   tt-periodo.ano     = i-year 
                   tt-periodo.tot-qtd = ae-item.quantidade
                   tt-periodo.periodo = STRING(i-year,"9999") + STRING(i-month,"99").
        END.
        ELSE DO:
            ASSIGN tt-periodo.tot-qtd = tt-periodo.tot-qtd + ae-item.quantidade.
        END.
    
        if last-of (ae-item.nr-ae) then do:
            ASSIGN de-saldo-estoq = 0.
            FOR EACH saldo-estoq
               WHERE saldo-estoq.cod-estabel = ae-item.cod-estabel
                 AND saldo-estoq.it-codigo   = ae-item.it-codigo
                 AND saldo-estoq.cod-depos   = "ALM" NO-LOCK:
                ASSIGN de-saldo-estoq = de-saldo-estoq + (saldo-estoq.qtidade-atu  + 
                                                          saldo-estoq.qt-alocada   +
                                                          saldo-estoq.qt-aloc-prod +
                                                          saldo-estoq.qt-aloc-ped).
            END.
    
            do i = 1 to 12:
                assign de-total[i] = 0.
            end.
    
            ASSIGN de-total-aux = 0.
    
            FOR EACH tt-periodo
            BREAK BY tt-periodo.periodo:
    
                ASSIGN de-total-aux = de-total-aux + tt-periodo.tot-qtd.
    
                IF LAST-OF(tt-periodo.periodo) THEN DO:
                    FIND FIRST tt-meses
                         WHERE tt-meses.periodo = tt-periodo.periodo NO-LOCK NO-ERROR.
    
                    ASSIGN de-total[tt-meses.posicao] = de-total-aux
                           de-total-aux    = 0.
                END.
            END.
    
            EMPTY TEMP-TABLE tt-periodo.
    
            FOR FIRST item-estab NO-LOCK
                WHERE item-estab.cod-estabel = ae-item.cod-estabel
                  AND item-estab.it-codigo   = item.it-codigo:
            END.

            PUT STREAM s-materiais
                ae-item.it-codigo format "x(7)" ";"
                item.descricao-1 + item.descricao-2 format "x(30)" ";"
                ae-item.nr-ae ";"
                ae-item.localizacao ";"
                ae-item.data ";"
                ae-item.data-validade ";"
                de-saldo-estoq ";"
                (item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-mat-m[1]) FORMAT ">>>,>>>,>>9.9999" ";"
                de-total[1] ";"
                de-total[2] ";"
                de-total[3] ";"
                de-total[4] ";"
                de-total[5] ";"
                de-total[6] ";"
                de-total[7] ";"
                de-total[8] ";"
                de-total[9] ";"
                de-total[10] ";"
                de-total[11] ";"
                de-total[12] SKIP.
           
       end.
    end.

    output STREAM s-materiais close.

    assign c-remetente = "ems@intelbras.com.br"
           c-assunto   = "Obsolescencia de materiais"
           c-descemail = "Os Materiais listados em anexo estao na empresa alem do prazo estipulado" + chr(10) + chr(13).
    
    FOR EACH tt-prog-ponto2:
        DELETE tt-prog-ponto2.
    END.

    ASSIGN c-destino = "".

    RUN esp/es0018p.p (INPUT "es0429",
                       INPUT 2,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto2).
    for each tt-prog-ponto2 NO-LOCK:
        IF entry(1, tt-prog-ponto2.conteudo, ";") <> tt-prog-ponto3.conteudo THEN NEXT.
    
        ASSIGN c-destino = c-destino + entry(2, tt-prog-ponto2.conteudo, ";") + ",".
    END.

    IF  c-destino <> "" AND substr(c-destino,LENGTH(c-destino), 1) = "," THEN
        c-destino = substr(c-destino, 1, LENGTH(c-destino) - 1).

    IF  c-destino <> "" THEN
        RUN enviaMail (INPUT c-remetente,
                       INPUT c-destino,
                       INPUT c-assunto,
                       INPUT c-descemail,
                       INPUT c-arquivo).
 
END.

/* run pi-finalizar in h-acomp. */
RETURN "ok".

procedure piEnviaEmail:
   define input parameter premetente as character no-undo.
   define input parameter pDestino   as character no-undo.
   define input parameter pAssunto   as character no-undo.
   define input parameter pDescEmail as character no-undo.
   define input parameter pArquivo   as character no-undo.

   empty temp-table tt-mail.
   find first param-global no-lock no-error.

   create tt-mail.
   assign tt-mail.Remetente     = pRemetente
          tt-mail.Destinatario  = pdestino
          tt-mail.Assunto       = pAssunto
          tt-mail.Arquivo       = if pArquivo <> "" then search(pArquivo) else ""
          tt-mail.Mensagem      = pDescEmail.

   run utp/utapi019.p persistent set h-utapi019.

   for each tt-mail:
      empty temp-table tt-envio2.
      empty temp-table tt-mensagem.

      create tt-envio2.
      assign tt-envio2.versao-integracao = 1
             tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */
             tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */
             tt-envio2.destino           = tt-mail.Destinatario     /* Destinat rio       */
             tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */
             tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
             tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor rio */
             tt-envio2.formato           = "TEXTO".

      create tt-mensagem.
      assign tt-mensagem.seq-mensagem = 1
             tt-mensagem.mensagem     = tt-mail.Mensagem.
           
      run pi-execute2 in h-utapi019 (input  table tt-envio2,
                                     input  table tt-mensagem,
                                     output table tt-erros).
           
      if can-find (first tt-erros) then
         return "NOK".
   end.
end procedure.

PROCEDURE pi-cria-tt-ord-res:

   DEFINE INPUT  PARAMETER p-ordem AS INTEGER    NO-UNDO.

   FIND FIRST tt-ord-res WHERE
              tt-ord-res.nr-ord-produ = p-ordem NO-ERROR.

   IF  NOT AVAIL tt-ord-res THEN DO:
       for first ord-prod fields (it-codigo   dt-termino   cod-estabel   cod-depos
                                  qt-ordem    qt-produzida estado        nr-ord-produ
                                  nr-pedido) where
                 ord-prod.nr-ord-produ = p-ordem NO-LOCK:

           CREATE tt-ord-res.
           ASSIGN tt-ord-res.nr-ord-produ = ord-prod.nr-ord-produ
                  tt-ord-res.cod-estabel  = ORD-PROD.COD-ESTABEL
                  tt-ord-res.estado       = ord-prod.estado
                  tt-ord-res.it-codigo    = ord-prod.it-codigo.
       END.
   END.

END PROCEDURE.

