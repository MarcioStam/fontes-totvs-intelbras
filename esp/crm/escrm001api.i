def var c-base-crm   as CHAR NO-UNDO.
def var c-url-ws-crm as CHAR NO-UNDO.

/* VERIFICA QUAL A CONEXÇO */
FIND FIRST ponto-programa NO-LOCK
    WHERE  ponto-programa.nome-programa = "ambiente"
    AND    ponto-programa.ponto         = 1 NO-ERROR.
IF  AVAIL  ponto-programa THEN DO:
    FOR FIRST conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN c-base-crm = conteudo-programa.conteudo.
    END. /* FOR FIRST conteudo-programa */
END. /* IF  AVAIL  ponto-programa */

&GLOBAL-DEFINE ativar-envio     YES
&GLOBAL-DEFINE ativar-log       YES
&GLOBAL-DEFINE pDns             CODEKSUITE
&GLOBAL-DEFINE pUserId          connector
&GLOBAL-DEFINE pPass            connector


RUN esp/es0018p.p (INPUT "escrm001api", /* Nome do programa */
                   INPUT 2,             /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

DEF VAR c-caminho-prod    AS CHAR FORMAT "X(75)" NO-UNDO.
DEF VAR c-caminho-homolog AS CHAR FORMAT "X(75)" NO-UNDO.
DEF VAR c-caminho-desenv  AS CHAR FORMAT "X(75)" NO-UNDO.

FOR EACH tt-prog-ponto:
    CASE  ENTRY(1, tt-prog-ponto.conteudo, ";"): 
        WHEN "PRODUCAO" THEN
            ASSIGN c-caminho-prod    = ENTRY(2, tt-prog-ponto.conteudo, ";").
        WHEN "HOMOLOG" THEN
            ASSIGN c-caminho-homolog = ENTRY(2, tt-prog-ponto.conteudo, ";").
        WHEN "DESENV" THEN
            ASSIGN c-caminho-desenv  = ENTRY(2, tt-prog-ponto.conteudo, ";").
    END CASE.
END.

CASE c-base-crm:
    WHEN "PRODUCAO" THEN
        assign c-base-crm   = "SQLCRM2015\SQLCRM2015"
               c-url-ws-crm = c-caminho-prod.
    
    WHEN "TESTE" THEN
        assign c-base-crm   = "sjo-dbms-09\crm2015homo" /*"SJO-CRM-02"*/
               c-url-ws-crm = c-caminho-homolog.

    WHEN "DESENV" THEN
        assign c-base-crm   = "sjo-dbms-09\crm2015homo" /*"SJO-CRM-02"*/
               c-url-ws-crm = c-caminho-desenv.
END CASE.
