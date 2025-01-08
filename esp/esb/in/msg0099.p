/********************************************************************************************/
/* Programa...: esp/esb/in/msg0099.p - SITUAÄ«O FINANCEIRA - CLIENTES                       */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 01/04/2014                                                                  */ 
/* Objetico...: Mensagem que ser† recebida para consultar a posiá∆o financeira dos canais   */
/*              associados a um Key Account/Representante.                                  */
/********************************************************************************************/

create widget-pool.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD CodigoContaMatriz   AS CHAR
    FIELD ValorAbertoCanal    AS DEC
    FIELD ValorVencidoCanal   AS DEC
    FIELD SituacaoCanal       AS CHAR INIT "Adimplente"
    FIELD CodigoConta         AS CHAR
    FIELD ValorAbertoCliente  AS DEC
    FIELD ValorVencidoCliente AS DEC
    FIELD SituacaoCliente     AS CHAR INIT "Adimplente"
        INDEX idx-canal CodigoContaMatriz.

define input  parameter iXML as longchar no-undo.
define output parameter oXML as longchar no-undo.
{esp/esb/esesbapi001.i}                          

{utp/ut-glob.i}
{esp/esb/in/msg0099.i}

DEFINE VARIABLE l-entrou AS LOGICAL     NO-UNDO.

define dataset mensagem for cabecalho, conteudo, msg0099, msg0099-CanaisCentrais, msg0099-CanaisFiliais
   data-relation for conteudo, msg0099                            relation-fields (idm, idm) NESTED
   data-relation for msg0099, msg0099-CanaisCentrais              relation-fields (idm, idm) NESTED
   data-relation for msg0099-CanaisCentrais , msg0099-CanaisFiliais  relation-fields (ContaCentral, ContaCentral) NESTED.
   

dataset mensagem:read-xml('longchar', iXML, 'empty', ?, ?).


define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0099r1, msg0099r1-CanaisCentrais, msg0099r1-CanaisFiliais, resultado
   data-relation for conteudor, msg0099r1                              relation-fields (idm, idm) NESTED
   data-relation for msg0099r1, msg0099r1-CanaisCentrais               relation-fields (idm, idm) NESTED
   data-relation for msg0099r1-CanaisCentrais, msg0099r1-CanaisFiliais relation-fields (ContaCentral, ContaCentral) NESTED
   data-relation for msg0099r1, resultado                              relation-fields (idm, idm) NESTED.


create cabecalhor.

FIND cabecalho NO-ERROR.

buffer-copy cabecalho EXCEPT IdentidadeEmissor to cabecalhor.

assign cabecalhor.CodigoMensagem    = 'MSG0099R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

create conteudor.
create resultado.
create msg0099r1.

FIND msg0099 NO-ERROR.


DEF TEMP-TABLE tt-clientes
    field guid-matriz         AS CHAR
    field guid-filial         AS CHAR
    FIELD cod-filial          AS INT.

DEF VAR l-vencido AS LOG INIT NO.

DEF VAR i-seq-canal AS INTEGER NO-UNDO.

DEF VAR c-guid-matriz AS CHAR NO-UNDO.


FOR EACH msg0099-CanaisCentrais
  , EACH msg0099-CanaisFiliais
    WHERE msg0099-CanaisFiliais.ContaCentral = msg0099-CanaisCentrais.ContaCentral
       BREAK BY  msg0099-CanaisFiliais.ContaCentral:

    IF  FIRST-OF (msg0099-CanaisFiliais.ContaCentral) THEN DO:
        FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-guid = msg0099-CanaisCentrais.ContaCentral
             /*AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */ */ NO-ERROR.
    
        IF  NOT AVAIL int-emitente THEN DO:
            RUN pi-erro (INPUT "Cliente inexistente ou n∆o participante do programa de canais: " + STRING(msg0099-CanaisCentrais.ContaCentral) + " cadastrado.") .
            LEAVE.
        END.

        CREATE tt-clientes.
        ASSIGN tt-clientes.guid-matriz = int-emitente.cod-guid
               c-guid-matriz           = int-emitente.cod-guid.
    END.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = msg0099-CanaisFiliais.ContaFilial
         /*AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */ */ NO-ERROR.

    IF  NOT AVAIL  int-emitente THEN DO:
        RUN pi-erro (INPUT "Cliente inexistente ou n∆o participante do programa de canais: " + STRING(msg0099-CanaisFiliais.ContaFilial) + " cadastrado.") .
        LEAVE.
    END.
    
    CREATE tt-clientes.
    ASSIGN tt-clientes.guid-matriz = c-guid-matriz
           tt-clientes.guid-filial = int-emitente.cod-guid
           tt-clientes.cod-filial  = int-emitente.cod-emitente.
    
END.


RUN pi-processa.

IF  CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.

END.

IF resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-processa:


    /* CARREGAR MATRIZ E FILIAIS */
    FOR EACH tt-clientes
        WHERE tt-clientes.cod-filial <> 0
        BREAK BY tt-clientes.cod-filial:

        RUN pi-carrega-titulos.

    END.

    DEF VAR de-vl-aberto    AS DEC NO-UNDO.
    DEF VAR de-vl-vencido   AS DEC NO-UNDO.
    DEF VAR l-inadimpliente AS LOG NO-UNDO.
    DEFINE VARIABLE i-idm  AS INTEGER NO-UNDO.


    IF  CAN-FIND (FIRST tt-canal) THEN DO:

        FOR EACH tt-canal
            BREAK BY tt-canal.CodigoContaMatriz:
                
            /******** Criando o N°vel da TAG CanalItem (EMITENTE MATRIZ) *********/
            IF  FIRST-OF (tt-canal.CodigoContaMatriz) THEN DO:
                CREATE msg0099r1-CanaisCentrais.
                ASSIGN msg0099r1-CanaisCentrais.ContaCentral = tt-canal.CodigoContaMatriz.
                       
                ASSIGN de-vl-aberto  = 0
                       de-vl-vencido = 0.

                ASSIGN l-inadimpliente = NO.
            END.

            /******** Crianto o N°vel da TAG ClienteITem ( DEMAIS EMITENTES)*******/
            CREATE msg0099r1-CanaisFiliais.
            ASSIGN msg0099r1-CanaisFiliais.ContaCentral = tt-canal.CodigoContaMatriz
                   msg0099r1-CanaisFiliais.ContaFilial  = tt-canal.CodigoConta
                   msg0099r1-CanaisFiliais.ValorAberto  = tt-canal.ValorAbertoCliente 
                   msg0099r1-CanaisFiliais.ValorVencido = tt-canal.ValorVencidoCliente
                   msg0099r1-CanaisFiliais.Situacao     = tt-canal.SituacaoCliente.

            ASSIGN de-vl-aberto  = de-vl-aberto  + tt-canal.ValorAbertoCliente
                   de-vl-vencido = de-vl-vencido + tt-canal.ValorVencidoCliente.

            IF  tt-canal.SituacaoCliente = "Inadimplente" THEN
                ASSIGN l-inadimpliente = YES.

            /**** TOTALIZA INFORMAÄÂES DO CANAL *****/
            IF  LAST-OF (tt-canal.CodigoContaMatriz) THEN DO:

                ASSIGN msg0099r1-CanaisCentrais.ValorAberto  = de-vl-aberto
                       msg0099r1-CanaisCentrais.ValorVencido = de-vl-vencido
                       msg0099r1-CanaisCentrais.Situacao     = IF l-inadimpliente THEN "Inadimplente" ELSE "Adimplente".

            END.

        END.

    END.
    ELSE DO:
        
        RUN pi-erro (INPUT "Cliente n∆o possui t°tulos") .

/*         CREATE msg0099r1-CanaisCentrais. */
/*         CREATE msg0099r1-CanaisFiliais.  */

    END.
END.

PROCEDURE pi-carrega-titulos:

    /* Carrega a tabela de titulos em aberto do cliente */
    EMPTY TEMP-TABLE tt-titulos-canal.
    RUN esp/esb/esesbapi001.p (INPUT tt-clientes.cod-filial,
                               OUTPUT TABLE tt-titulos-canal).

    CREATE tt-canal.
    ASSIGN tt-canal.CodigoContaMatriz    = tt-clientes.guid-matriz /* Matriz */
           tt-canal.CodigoConta          = tt-clientes.guid-filial. /* Demais Sites*/

    /* ACUMULA OS VALORES PARA OS EMITENTES PARTICIPANTES DO CANAL*/ 
    FOR EACH tt-titulos-canal:

        ASSIGN l-vencido = IF  tt-titulos-canal.DataVencimento - TODAY < 0 THEN  YES  ELSE  NO.

        ASSIGN tt-canal.ValorAbertoCliente   = tt-canal.ValorAbertoCliente + tt-titulos-canal.ValorSaldo  
               tt-canal.ValorVencidoCliente  = tt-canal.ValorVencidoCliente + 
                                               (IF  l-vencido THEN  tt-titulos-canal.ValorSaldo ELSE 0).

      /* Caso qualquer Emitente do Canal esteja INADIMPLENTE, A Situaá∆o do Canal todo fica INADIMPLENTE */
      IF  tt-canal.SituacaoCliente <> "Inadimplente" 
      AND l-vencido THEN
          ASSIGN tt-canal.SituacaoCliente = "Inadimplente".
    END.

END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
