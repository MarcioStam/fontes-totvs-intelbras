/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
DEF VAR v1 AS HANDLE.
DEF VAR v2 AS HANDLE.
DEFINE TEMP-TABLE tt-estrutura NO-UNDO
   FIELD seq            like int-estrutura.sequencia
   FIELD nivel          AS INTEGER
   FIELD it-codigo      LIKE estrutura.it-codigo
   FIELD descricao      AS CHAR FORMAT "X(60)"
   FIELD it-pai         LIKE item.it-codigo
   FIELD quant-usada    AS DECIMAL FORMAT "->>,>>9.9999999999"
   FIELD local-montag   AS CHARACTER FORMAT "x(55)"
   FIELD garantia       AS INTEGER
   FIELD venda          AS LOGICAL
   FIELD permite-os     AS LOGICAL
   INDEX idx_pri IS PRIMARY UNIQUE seq nivel.

CREATE SERVER v1.
v1:CONNECT("-WSDL 'http://wsa.intelbras.com.br:8080/wsa2/wsa2/wsdl?targetURI=urn:crm:intelbras.com.br'").

RUN  integracaoERPobj ON SERVER v1 SET v2.

RUN buscarEstruturaDoItemPor IN v2 (INPUT "",
                                    INPUT "4920526",
                                    OUTPUT TABLE tt-estrutura).

OUTPUT TO c:\temp\telecontrol.csv CONVERT TARGET "iso8859-1".

PUT "Seq;Nivel;Item;Desc;Item Pai;Qtd.usada;local;garantia;venda;permite-os" SKIP.

FOR EACH tt-estrutura NO-LOCK:
    PUT UNFORMATTED
        tt-estrutura.seq ";"
        tt-estrutura.nivel ";"
        tt-estrutura.it-codigo ";"
        tt-estrutura.descricao ";"
        tt-estrutura.it-pai ";"
        tt-estrutura.quant-usada ";"
        tt-estrutura.local-montag ";"
        tt-estrutura.garantia ";"
        tt-estrutura.venda ";"
        tt-estrutura.permite-os SKIP.
END.
OUTPUT CLOSE.
