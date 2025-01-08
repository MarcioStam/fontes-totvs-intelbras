/******************************************************************************
**  Programa.: ESCRM001b.i
**  Objetivo.: Defini‡Æo das Temp-Tables
**  Autor....: SQLWORKS - Setembro 2010 
*******************************************************************************/

DEFINE VARIABLE c-param-chave AS CHARACTER EXTENT 10  NO-UNDO.

DEFINE TEMP-TABLE tt-raw-param NO-UNDO
    FIELD raw-trans AS RAW.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER FORMAT "x(3)"
    FIELD des-unid-negoc AS CHARACTER FORMAT "x(40)"
    INDEX idx-unid-negoc AS PRIMARY UNIQUE
          cod-unid-negoc.
                       
DEFINE TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod-ccusto     AS CHARACTER FORMAT "x(11)"
    FIELD descricao      AS CHARACTER FORMAT "x(40)"
    INDEX idx-ccusto AS PRIMARY UNIQUE
          cod-ccusto.
