  
/*------------------------------------------------------------------------
    File        : esftp042crp.p
    Purpose     : Gerar arquivo com as chaves de acesso para gerar o PIN
    Syntax      : <none>
    Description : <none>

------------------------------------------------------------------------*/

{include/i-prgvrs.i esftp042c 2.00.00.000}  /*** 010000 ***/

{utp/ut-glob.i}
{include/i-rpvar.i}
{include/i-freeac.i}
{esp/es0018.i}
{utp/utapi019.i}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-mail-destino AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-notas NO-UNDO
           FIELD nr-chave  AS CHAR FORMAT "x(50)"
           FIELD cod-estab AS CHAR .

DEFINE TEMP-TABLE tt-estab NO-UNDO
       FIELD cod-estab AS CHAR.

DEFINE TEMP-TABLE tt-notas-geral NO-UNDO
       FIELD nr-nota-fis AS CHAR
       FIELD serie       AS CHAR
       FIELD cod-estabel AS CHAR
       FIELD chave       AS CHAR
       FIELD nr-pedcli   AS CHAR.

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.

DEFINE VAR c-estab            AS CHAR NO-UNDO.
DEFINE VAR c-arquivos-gerados AS CHAR NO-UNDO.
DEFINE VAR c-arquivo-estab    AS CHAR NO-UNDO.
DEFINE VAR c-arquivo-geral    AS CHAR NO-UNDO.
DEFINE VAR c-dia              AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
/* Parameters Definitions ---                                           */

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

EMPTY TEMP-TABLE tt-notas.
EMPTY TEMP-TABLE tt-estab.
EMPTY TEMP-TABLE tt-notas-geral.
EMPTY TEMP-TABLE tt-prog-ponto.
EMPTY TEMP-TABLE tt-prog-ponto2.

RUN esp/es0018p.p (INPUT "esftp042c", //buscar emails da lista                      
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

RUN esp/es0018p.p (INPUT "esftp042c", //buscar atendentes para listar as notas                     
                   INPUT 2,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto2).

ASSIGN c-mail-destino = "".
FOR EACH tt-prog-ponto:
    IF c-mail-destino = "" THEN
        ASSIGN c-mail-destino = tt-prog-ponto.conteudo.
    ELSE
        ASSIGN c-mail-destino = c-mail-destino + "," + tt-prog-ponto.conteudo.
END.

ASSIGN c-dia = STRING(TODAY)
       c-dia = REPLACE(c-dia,"/","").

FOR EACH nota-fiscal NO-LOCK
   WHERE nota-fiscal.dt-emis = TODAY - 1
     AND nota-fiscal.idi-sit-nf-eletro = 3:

    IF nota-fiscal.cod-estabel = "101" THEN NEXT.

    IF nota-fiscal.cod-estabel = "105" AND
       nota-fiscal.estado      = "AM" THEN NEXT.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli  NO-ERROR.
    IF AVAIL ped-venda THEN DO: //mostra somente pedidos dos atendentes da lista
        IF NOT CAN-FIND(FIRST tt-prog-ponto2
                        WHERE tt-prog-ponto2.conteudo = ped-venda.tp-pedido) THEN 
           NEXT.
    END. 
    ELSE
        NEXT. //nao listar notas sem pedidos

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
    IF AVAIL natur-oper AND natur-oper.tipo <> 2 THEN NEXT.

    FIND FIRST emitente
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

    if avail natur-oper AND natur-oper.tipo = 2 AND emitente.cod-suframa <> "" THEN DO:    

        FIND FIRST tt-estab
             WHERE tt-estab.cod-estab = nota-fiscal.cod-estabel NO-ERROR.
        IF NOT AVAIL tt-estab THEN DO:
            CREATE tt-estab.
            ASSIGN tt-estab.cod-estab = nota-fiscal.cod-estabel.
        END.

        CREATE tt-notas.
        ASSIGN tt-notas.nr-chave    = nota-fiscal.cod-chave-aces-nf-eletro
               tt-notas.cod-estab   = nota-fiscal.cod-estabel.

        //gerar arquivo geral
        CREATE tt-notas-geral.
        ASSIGN tt-notas-geral.nr-nota-fis = nota-fiscal.nr-nota-fis
               tt-notas-geral.serie       = nota-fiscal.serie
               tt-notas-geral.cod-estabel = nota-fiscal.cod-estabel
               tt-notas-geral.nr-pedcli   = nota-fiscal.nr-pedcli
               tt-notas-geral.chave       = nota-fiscal.cod-chave-aces-nf-eletro.
    END.

END.

FOR EACH tt-estab:

    ASSIGN c-arquivo-estab = "\\erpapp\spool\" + c-seg-usuario + "\notas-estab-" + tt-estab.cod-estab + "-" + string(c-dia) + ".txt".

    OUTPUT TO VALUE(c-arquivo-estab).
    FOR EACH tt-notas
        WHERE tt-notas.cod-estab = tt-estab.cod-estab:

          DISP tt-notas.nr-chave FORMAT "x(50)" NO-LABEL WITH WIDTH 300.
    END.
    OUTPUT CLOSE.

    IF c-arquivos-gerados = "" THEN
        ASSIGN c-arquivos-gerados = c-arquivo-estab.
    ELSE
        ASSIGN c-arquivos-gerados = c-arquivos-gerados + "," + c-arquivo-estab.

END.

//Busca o arquivo geral pra mostrar as notas com as chaves de acesso
ASSIGN c-arquivo-geral = "\\erpapp\spool\" + c-seg-usuario + "\notas-geral-" + string(c-dia) + ".txt".
OUTPUT TO VALUE(c-arquivo-geral).
  FOR EACH tt-notas-geral
     BREAK BY tt-notas-geral.cod-estabel:
      DISP tt-notas-geral.cod-estabel
           tt-notas-geral.serie
           tt-notas-geral.nr-nota-fis
           tt-notas-geral.nr-pedcli
           tt-notas-geral.chave FORMAT "x(60)" WITH WIDTH 300.
  END.
OUTPUT CLOSE.

IF c-arquivos-gerados = "" THEN
    ASSIGN c-arquivos-gerados = c-arquivo-geral.
ELSE
    ASSIGN c-arquivos-gerados = c-arquivos-gerados + "," + c-arquivo-geral.

RUN pi-envia-email.

PROCEDURE pi-envia-email:
    
    //ASSIGN c-mail-destino = "marcio.stammerjohann@intelbras.com.br".

    RUN enviaMail (INPUT "ems@intelbras.com.br",
                   INPUT c-mail-destino,
                   INPUT "Arquivo PIN " ,
                   INPUT "Segue anexo os arquivo pin gerados para cada estabelecimento",
                   INPUT replace(c-arquivos-gerados,", ", ",")).

END PROCEDURE.

PROCEDURE enviaMail:

    define input parameter pRemetente    as character no-undo.
    define input parameter pDestinatario as character no-undo.
    define input parameter pAssunto      as character no-undo.
    define input parameter pMensagem     as character no-undo.
    define input parameter pAnexo        as character no-undo.

    define variable h-utapi019 as handle      no-undo.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    create tt-envio2.
    assign tt-envio2.versao-integracao  = 1
           tt-envio2.servidor           = param-global.serv-mail
           tt-envio2.porta              = param-global.porta-mail
           tt-envio2.exchange           = param-global.log-1
           tt-envio2.remetente          = pRemetente
           tt-envio2.destino            = pDestinatario
           tt-envio2.assunto            = pAssunto
           tt-envio2.mensagem           = pMensagem
           tt-envio2.arq-anexo          = pAnexo
           tt-envio2.importancia        = 1
           tt-envio2.log-enviada        = no
           tt-envio2.log-lida           = no
           tt-envio2.acomp              = no
           tt-envio2.formato            = 'TEXTO'.

    run utp/utapi019.p persistent set h-utapi019.
    run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).

    delete object h-utapi019.

END PROCEDURE.

