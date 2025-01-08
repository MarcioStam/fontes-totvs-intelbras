/*****************************************************************************************************/
/* Programa...: esp/esb/in/msg0155.p            REGISTRA_SOLICITACAO_PRICE_PROTECTION                */
/* Altor......: Roger Marcelino Bruhn                                                                */
/* Data.......: 06/08/2015                                                                           */ 
/* Objetivo...: Mensagem enviada quando for criado ou atualizado uma solicitaá∆o de PRICE PROTECTION */
/*****************************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEF VAR l-ok AS LOG INIT NO NO-UNDO.

{esp/esb/esesb000.i}
{esp/esb/in/msg0152.i1}
{esp/esb/in/msg0155.i}
{esp/esb/in/msg9999.i}

{esp/esb/out/msg0159.i}

{esp/esb/in/msg0152.i3} /*tt-erro*/
{esp/esb/esesbapi010-saldo.i1}

/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0155, msg0155-ProdutoSolicitacaoItens, msg0155-ProdutoSolicitacaoItem
   DATA-RELATION FOR conteudo, msg0155                                                RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0155, msg0155-ProdutoSolicitacaoItens                         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0155-ProdutoSolicitacaoItens, msg0155-ProdutoSolicitacaoItem  RELATION-FIELDS (idm, idm) NESTED.
   
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0155R1, msg0155r1-SaldoBeneficioCanal, resultado
   DATA-RELATION FOR conteudor, MSG0155R1                       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0155R1, msg0155r1-SaldoBeneficioCanal   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0155R1, resultado                       RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-solicitacao      FOR int-solicitacao.
DEF BUFFER b-int-solicitacao-item FOR int-solicitacao-item.

DEF VAR h-esesbapi007-solicita AS HANDLE NO-UNDO.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0155R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0155R1.

ASSIGN resultado.sucesso    = no.

RUN esp/esb/esesbapi007-solicita.p PERSISTENT SET h-esesbapi007-solicita.

/*-----------------------------------------------------------------------------------------------------------------*/
/* Esta API Ç utilizada pelos programas msg0152/msg0155/msg0156, pois os 3 gravam a mesma tabela - int-solicitacao */
/*-----------------------------------------------------------------------------------------------------------------*/
FOR EACH msg0155:
    CREATE msg0152.
    BUFFER-COPY msg0155 TO msg0152.
END.

RUN pi-cria-atualiza-solicitacao IN h-esesbapi007-solicita (INPUT "msg0155",
                                                            INPUT TABLE  msg0152, /*sempre passa a temp-table 152, pra n∆o dar problema de assinatura de tabela*/
                                                            INPUT TABLE  msg0155-ProdutoSolicitacaoItem,
                                                            OUTPUT TABLE tt-saldo,
                                                            OUTPUT TABLE tt-erro,
                                                            OUTPUT l-ok).

/* --------------------------------------- RETORNA SALDO -----------------------------------*/
FIND FIRST tt-saldo NO-LOCK NO-ERROR.
IF  AVAIL tt-saldo THEN DO:
    CREATE msg0155r1-SaldoBeneficioCanal.
    ASSIGN msg0155r1-SaldoBeneficioCanal.CodigoBeneficioCanal = tt-saldo.CodigoBeneficioCanal
           msg0155r1-SaldoBeneficioCanal.VerbaCalculada       = tt-saldo.VerbaCalculada
           msg0155r1-SaldoBeneficioCanal.VerbaPeriodoAnterior = tt-saldo.VerbaPeriodoAnterior
           msg0155r1-SaldoBeneficioCanal.VerbaTotal           = tt-saldo.VerbaTotal          
           msg0155r1-SaldoBeneficioCanal.VerbaEmpenhada       = tt-saldo.VerbaEmpenhadaTotal      
           msg0155r1-SaldoBeneficioCanal.VerbaReembolsada     = tt-saldo.VerbaReembolsada    
           msg0155r1-SaldoBeneficioCanal.VerbaCancelada       = tt-saldo.VerbaCancelada      
           msg0155r1-SaldoBeneficioCanal.VerbaAjustada        = tt-saldo.VerbaAjustada       
           msg0155r1-SaldoBeneficioCanal.VerbaDisponivel      = tt-saldo.VerbaDisponivel     .
END.
/*------------------------------------------------------------------------------------------*/

IF  RETURN-VALUE <> "OK"
OR  NOT l-ok THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "(ERP) - ".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:

        ASSIGN resultado.Mensagem =  resultado.Mensagem +  string(tt-erro.codigo) + " - " + tt-erro.mensagem + " Ajuda: " + tt-erro.ajuda + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.
ELSE
    ASSIGN resultado.sucesso = YES.

FIND FIRST msg0155 NO-ERROR.

/*Eliminar handles*/
DELETE PROCEDURE h-esesbapi007-solicita.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
