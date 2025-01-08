/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/ftp/esftp120rp.p
**  Objetivo.: 
**  Cria‡Æo..: 
**
*******************************************************************************/
{include/i-prgvrs.i ESFTP120 2.00.00.000}
{utp/ut-glob.i}
//{esp/es0043.i} /* <--- c-dir-arquivo-session  */
{esp/es0018.i}
def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field modelo           AS char format "x(35)":U
    field item-ini         AS CHAR
    field item-fim         AS CHAR
    field uf-ini           AS CHAR
    field uf-fim           AS CHAR
    field aliq-ini         AS DEC
    field aliq-fim         AS DEC
    field mensagem-ini     AS INT
    field mensagem-fim     AS INT
    /*Alterado 15/02/2005 - tech1007 - Criado campo l½gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define temp-table tt-imprime
    field it-codigo                     AS CHAR
    field descricao-1                   AS CHAR
    field estado                        AS CHAR 
    field aliquota-icm                  AS DEC
    field log-descons-para-nao-contribt AS CHAR
    field cod-mensagem                  AS INT.

DEFINE VARIABLE c-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

DEF VAR c-arquivo AS CHAR NO-UNDO.
DEFINE VAR c-dir-saida AS CHAR NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar in h-acomp (input "Lendo...").

IF  OPSYS = "unix" THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U) + "/" + c-seg-usuario + "/".
    END.
END. 
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U) + "\" + c-seg-usuario + "\".
    END.
END.

RUN pi-carrega.
RUN pi-imprime.

RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arquivo).
END.

RETURN "OK".

PROCEDURE pi-carrega:

    FOR EACH icms-it-uf NO-LOCK
       WHERE icms-it-uf.it-codigo    >= tt-param.item-ini 
         AND icms-it-uf.it-codigo    <= tt-param.item-fim
         AND icms-it-uf.estado       >= tt-param.uf-ini
         AND icms-it-uf.estado       <= tt-param.uf-fim
         AND icms-it-uf.aliquota-icm >= tt-param.aliq-ini
         AND icms-it-uf.aliquota-icm <= tt-param.aliq-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + icms-it-uf.it-codigo).
    
        FIND FIRST ITEM WHERE ITEM.it-codigo = icms-it-uf.it-codigo NO-LOCK NO-ERROR.
        FIND FIRST int-icms-it-uf NO-LOCK 
             WHERE int-icms-it-uf.estado    = icms-it-uf.estado
               AND int-icms-it-uf.it-codigo = icms-it-uf.it-codigo NO-ERROR. 

        CREATE tt-imprime.
        ASSIGN tt-imprime.it-codigo                     = icms-it-uf.it-codigo
               tt-imprime.descricao-1                   = item.descricao-1
               tt-imprime.estado                        = icms-it-uf.estado
               tt-imprime.aliquota-icm                  = icms-it-uf.aliquota-icm
               tt-imprime.log-descons-para-nao-contribt = STRING(icms-it-uf.log-descons-para-nao-contribt,"Sim/NÆo")
               tt-imprime.cod-mensagem                  = IF AVAIL int-icms-it-uf THEN int-icms-it-uf.cod-mensagem ELSE 0.

    END.

END PROCEDURE.

PROCEDURE pi-imprime:

    ASSIGN c-arquivo = c-dir-saida +  "esftp120-" + STRING(TIME) + ".csv".

    OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT "Item;Descri‡Æo;Estado;Aliq;Desconsidera;Mensagem" SKIP.
    
    FOR EACH tt-imprime
       WHERE tt-imprime.cod-mensagem >= tt-param.mensagem-ini
         AND tt-imprime.cod-mensagem <= tt-param.mensagem-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Imprime: " + tt-imprime.it-codigo).
    
        PUT tt-imprime.it-codigo FORMAT "x(20)" ";"                       
            tt-imprime.descricao-1 FORMAT "x(20)" ";"                         
            tt-imprime.estado ";"                             
            tt-imprime.aliquota-icm ";"                       
            tt-imprime.log-descons-para-nao-contribt ";"      
            tt-imprime.cod-mensagem SKIP.                        
    
    END.

    OUTPUT CLOSE.

END PROCEDURE.




