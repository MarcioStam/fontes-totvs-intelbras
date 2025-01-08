/********************************************************************************************/
/* Programa...: esp/esb/in/msg0122.p - REGISTRA_CATEGORIA_CANAL                             */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 24/06/2014                                                                  */ 
/* Objetivo...: Mensagem criaá∆o/alteraá∆o Categoria Canal  (CRM)                           */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0122.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0122
   DATA-RELATION FOR conteudo, msg0122 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0122R1, resultado
   DATA-RELATION FOR conteudor, MSG0122R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0122R1, resultado RELATION-FIELDS (idm, idm) NESTED.

DEF BUFFER b-int-categoria-canal  FOR int-categoria-canal.
DEF BUFFER b1-int-categoria-canal FOR int-categoria-canal.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0122R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0122 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE MSG0122R1.

/* CRIAÄ«O CATEGORIA CANAL */
RUN pi-categoria.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.


DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-categoria:

    EMPTY TEMP-TABLE tt-erro.

    /* CATEGORIA */
    FIND FIRST int-categoria NO-LOCK
        WHERE int-categoria.guid-categoria = msg0122.Categoria NO-ERROR.
    
    IF  NOT AVAIL int-categoria THEN DO:
          RUN pi-erro (INPUT 'C¢digo da Categoria inexistente').
          RETURN "NOK".
    END.

    /* CONTA */
    FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-guid = msg0122.Conta NO-ERROR.
    
    IF  NOT AVAIL int-emitente THEN DO:
          RUN pi-erro (INPUT 'Conta inexistente').
          RETURN "NOK".
    END.

    /* UNIDADE DE NEG‡CIO */
    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = msg0122.UnidadeNegocio NO-ERROR.

    IF  NOT AVAIL unid-negoc THEN DO:
        RUN pi-erro (INPUT 'Unidade de Neg¢cio inexistente').
        RETURN "NOK".
    END.

    /* CLASSIFICAÄ«O */
    FIND FIRST int-class-canal NO-LOCK
        WHERE int-class-canal.codigo-classificacao = msg0122.Classificacao NO-ERROR.

    IF  NOT AVAIL int-class-canal THEN DO:
        RUN pi-erro (INPUT 'Classificacao inexistente').
        RETURN "NOK".
    END.
    IF  AVAIL int-class-canal AND int-class-canal.situacao = 1 THEN DO:
        RUN pi-erro (INPUT 'Classificaá∆o n∆o est† ativa').
        RETURN "NOK".
    END.

    FIND FIRST b1-int-categoria-canal NO-LOCK
        WHERE b1-int-categoria-canal.unid-neg              = msg0122.UnidadeNegocio  
          AND b1-int-categoria-canal.guid-conta            = msg0122.Conta           
          AND b1-int-categoria-canal.guid-classificacao    = msg0122.Classificacao   
          AND b1-int-categoria-canal.guid-sub-class        = msg0122.SubClassificacao
          AND b1-int-categoria-canal.guid-categoria        = msg0122.Categoria NO-ERROR.
/*           AND b1-int-categoria-canal.guid-categoria-canal <> msg0122.CodigoCategoriaCanal */

/*     IF  AVAIL b1-int-categoria-canal THEN DO:                                                */
/*         RUN pi-erro (INPUT 'J† existe uma categoria de canal cadastrada com ' +              */
/*                      "Unidade: " + b1-int-categoria-canal.unid-neg   +                       */
/*                      ", Conta: " + b1-int-categoria-canal.guid-conta   +                     */
/*                      ", Classificaá∆o: " + b1-int-categoria-canal.guid-classificacao  +      */
/*                      ", Sub Classificaá∆o: " + b1-int-categoria-canal.guid-sub-class       + */
/*                      ", Categoria: " + b1-int-categoria-canal.guid-categoria).               */
/*         RETURN "NOK".                                                                        */
/*     END.                                                                                     */

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:

        {esp/esb/in/msg9999.i01     "b-int-categoria-canal"
                                    " FIND FIRST b-int-categoria-canal 
                                       WHERE b-int-categoria-canal.unid-neg              = msg0122.UnidadeNegocio      
                                         AND b-int-categoria-canal.guid-conta            = msg0122.Conta               
                                         AND b-int-categoria-canal.guid-classificacao    = msg0122.Classificacao       
                                         AND b-int-categoria-canal.guid-sub-class        = msg0122.SubClassificacao    
                                         AND b-int-categoria-canal.guid-categoria        = msg0122.Categoria 
                                        EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /*************************** CATEGORIA **************************/
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE int-categoria-canal.
            ASSIGN int-categoria-canal.guid-categoria-canal = msg0122.CodigoCategoriaCanal
                   int-categoria-canal.nome                 = msg0122.nome
                   int-categoria-canal.unid-neg             = msg0122.UnidadeNegocio
                   int-categoria-canal.guid-conta           = msg0122.Conta
                   int-categoria-canal.guid-classificacao   = msg0122.Classificacao
                   int-categoria-canal.guid-categoria       = msg0122.Categoria
                   int-categoria-canal.guid-sub-class       = msg0122.SubClassificacao
                   int-categoria-canal.ind-situacao         = msg0122.Situacao
                   int-categoria-canal.guid-proprietario    = msg0122.Proprietario
                   int-categoria-canal.tipo-proprietario    = msg0122.TipoProprietario.

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Categoria em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE
                /* Est† Dispon°vel para atualizaá∆o */
                ASSIGN b-int-categoria-canal.nome                 = msg0122.nome
                       b-int-categoria-canal.unid-neg             = msg0122.UnidadeNegocio
                       b-int-categoria-canal.guid-conta           = msg0122.Conta
                       b-int-categoria-canal.guid-classificacao   = msg0122.Classificacao
                       b-int-categoria-canal.guid-categoria       = msg0122.Categoria
                       b-int-categoria-canal.guid-sub-class       = msg0122.SubClassificacao
                       b-int-categoria-canal.ind-situacao         = msg0122.Situacao
                       b-int-categoria-canal.guid-proprietario    = msg0122.Proprietario
                       b-int-categoria-canal.tipo-proprietario    = msg0122.TipoProprietario.
        END.

        RELEASE b-int-categoria-canal NO-ERROR.

    END. /* TRANSAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

