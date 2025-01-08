

/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0059 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0059
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0059.i}

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0059
   DATA-RELATION FOR conteudo, msg0059 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0059r, resultado
   DATA-RELATION FOR conteudor, msg0059r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0059r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0059.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.
ASSIGN cabecalhor.CodigoMensagem = 'MSG0059R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0059r. 
 

IF string(msg0059.CodigoCliente) <> "" THEN DO:
    FIND FIRST cont-emit EXCLUSIVE-LOCK
         WHERE cont-emit.cod-emitente = INTEGER(msg0059.CodigoCliente) NO-ERROR.

    DELETE cont-emit.
END.

     

     


