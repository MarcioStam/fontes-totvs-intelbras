CREATE WIDGET-POOL.

DEF TEMP-TABLE tt-atraso-emitente
    FIELD cod-emitente AS INTEGER
    FIELD dias-atraso AS INTEGER.

{esp/esb/out/msg0120.i}
{utp/ut-glob.i}

DEFINE INPUT  PARAM TABLE FOR tt-atraso-emitente.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' for cabecalho, conteudo, msg0120, msg0120-CanaisItem, msg0120-CanalItem 
   DATA-RELATION FOR conteudo, msg0120                     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0120, msg0120-CanaisItem           RELATION-FIELDS (idm, idm) NESTED
/*   DATA-RELATION FOR msg0120, resultado                    RELATION-FIELDS (idm, idm) NESTED*/
   DATA-RELATION FOR msg0120-CanaisItem, msg0120-CanalItem RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME "MENSAGEM" FOR cabecalhor, conteudor, msg0120r, resultado
   DATA-RELATION FOR conteudor, msg0120r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0120r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       
       cabecalho.CodigoMensagem    = "MSG0120"
       cabecalho.LoginUsuario      = c-seg-usuario.

CREATE conteudo.
/* CREATE resultado. */
 
CREATE msg0120.
   
CREATE msg0120-CanaisItem.

IF  CAN-FIND (FIRST tt-atraso-emitente) THEN DO:

    FOR EACH tt-atraso-emitente:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = tt-atraso-emitente.cod-emitente NO-ERROR.
    
        CREATE msg0120-CanalItem.
        ASSIGN msg0120-CanalItem.CodigoConta  = int-emitente.cod-guid
               msg0120-CanalItem.NumeroDiasAtraso   = tt-atraso-emitente.dias-atraso.       

        ASSIGN cabecalho.NumeroOperacao    = STRING(int-emitente.cod-emitente).
    END.
END.
ELSE
    CREATE msg0120-CanalItem.



/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN.
