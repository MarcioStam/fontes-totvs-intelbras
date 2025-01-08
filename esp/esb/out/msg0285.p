{include/i-prgvrs.i msg0285 2.00.00.000}  /*** 010000 ***/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-matricula NO-UNDO
    FIELD idi-tipo  AS INT
    FIELD codigo    AS INT
    FIELD mes-periodo AS INT
    FIELD ano-periodo AS INT.

{esp/esb/out/msg0285.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR msg0285r.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-matricula AS CHARACTER   NO-UNDO.

CREATE tt-matricula.
RAW-TRANSFER raw-param TO tt-matricula.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0285
   DATA-RELATION FOR conteudo, msg0285                RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0285r, resultado
   DATA-RELATION FOR conteudor, msg0285r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0285r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0285'.
     
CREATE conteudo.
CREATE msg0285.

FOR FIRST tt-matricula NO-LOCK:

    /*Executivo*/
    IF tt-matricula.idi-tipo = 1 THEN DO:
        FIND FIRST int-executivo NO-LOCK
             WHERE int-executivo.cod-executivo = tt-matricula.codigo NO-ERROR.

        ASSIGN c-matricula = IF AVAIL int-executivo THEN int-executivo.matricula ELSE "".
    END.
    /*Supervisor*/
    ELSE DO:
        FIND FIRST int-supervisor NO-LOCK
             WHERE int-supervisor.cod-supervisor = tt-matricula.codigo NO-ERROR.
    
        ASSIGN c-matricula = IF AVAIL int-supervisor THEN int-supervisor.matricula ELSE "".
    END.

    IF c-matricula = "" THEN
        RETURN "NOK".

    ASSIGN msg0285.Empresa          = 1
           msg0285.TipoColaborador  = 1
           msg0285.Matricula        = c-matricula
           msg0285.DataReferencia   = TODAY
           cabecalho.NumeroOperacao = c-matricula + "-" + STRING(tt-matricula.mes-periodo,"99") + "/" + STRING(tt-matricula.ano-periodo).
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
