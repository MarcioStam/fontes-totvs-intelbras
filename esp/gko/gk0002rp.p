/*****************************************************************************
**
**     Objetivo: Importaá∆o Data Sa°da Notas no GKO (Embarque)
**
**     Versao..: 2.00.00.000
**     Autor: hoepers - 16/05/2012
*****************************************************************************/

{include/i-prgvrs.i gk0002 2.00.00.000}

{utp/ut-glob.i}
define temp-table tt-param   no-undo
    field destino            as integer
    field arquivo            as char    format "x(35)"
    field usuario            as char    format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field diretorio          as CHAR.

define temp-table tt-digita no-undo
    field num-nota     like nota-fiscal.nr-nota-fis.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD nom-arquivo      AS CHAR
    FIELD nom-completo     AS CHAR
    FIELD ind-tipo-arquivo AS CHAR.

DEF TEMP-TABLE tt-notas NO-UNDO
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD dt-saida    LIKE nota-fiscal.dt-saida
    FIELD nom-arquivo   AS CHAR
    INDEX id-nota
            cod-estabel
            serie      
            nr-nota-fis.

{esp/gko/gkapi001.i} /* Definiá∆o temp-table "tt-log-gko" */

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

DEFINE BUFFER b-tt-log-gko FOR tt-log-gko.

DEFINE VARIABLE v-cod-dir-origem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-dir-destino AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-linha-imp   AS CHARACTER   NO-UNDO.

/*******************************************************************/

FIND LAST param-global NO-LOCK NO-ERROR.

EMPTY TEMP-TABLE tt-log-gko.
EMPTY TEMP-TABLE tt-arquivos.
EMPTY TEMP-TABLE tt-notas.

/* Identificar diret¢rio destino dos arquivos */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0002"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
            THEN
                ASSIGN v-cod-dir-origem = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
            THEN
                ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
            THEN
                ASSIGN v-cod-dir-origem = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
            THEN
                ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.


/* Ler arquivos no diret¢rio de origem */
INPUT FROM OS-DIR(v-cod-dir-origem) NO-ECHO.
REPEAT:
    CREATE tt-arquivos.
    IMPORT tt-arquivos.nom-arquivo tt-arquivos.nom-completo tt-arquivos.ind-tipo-arquivo.

    IF  NOT tt-arquivos.nom-arquivo BEGINS "frdtsaida" OR
            tt-arquivos.ind-tipo-arquivo <> "F"
    THEN
        DELETE tt-arquivos.
END.
INPUT CLOSE.

/* Importar conte£do dos arquivos encontrados */
FOR EACH  tt-arquivos.  
    IF  SEARCH(tt-arquivos.nom-completo) <> ?
    THEN DO:
        INPUT FROM VALUE(SEARCH(tt-arquivos.nom-completo)).
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.ind-tipo-integracao    = 3
               tt-log-gko.log-imp-erro           = NO
               tt-log-gko.des-erro-imp           = "Integraá∆o realizada com sucesso."
               tt-log-gko.nom-arquivo-integracao = SEARCH(tt-arquivos.nom-completo)
               tt-log-gko.cod-arquivo-integracao = tt-arquivos.nom-arquivo.
        REPEAT:
            IMPORT UNFORMATTED v-cod-linha-imp.

            FIND FIRST estabelec NO-LOCK
                WHERE  estabelec.cod-emitente = INT(TRIM(SUBSTR(v-cod-linha-imp,1,10))) NO-ERROR.

            IF  AVAIL estabelec
            THEN DO:
                CREATE tt-notas.
                ASSIGN tt-notas.cod-estabel = estabelec.cod-estabel
                       tt-notas.nr-nota-fis = STRING(INT(SUBSTR(v-cod-linha-imp,11,8)),"9999999")
                       tt-notas.serie       = TRIM(SUBSTR(v-cod-linha-imp,19,3))
                       tt-notas.dt-saida    = DATE(TRIM(SUBSTR(v-cod-linha-imp,22,10)))
                       tt-notas.nom-arquivo = SEARCH(tt-arquivos.nom-completo).
            END.
            ELSE DO:
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 3
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.des-erro-imp           = "N∆o foi encontrado estabelecimento para o emitente de c¢digo (" + TRIM(SUBSTR(v-cod-linha-imp,1,10)) + ").".
                       tt-log-gko.nom-arquivo-integracao = SEARCH(tt-arquivos.nom-completo).
            END.
        END.
        INPUT CLOSE.
    END.
END.


/* Atualizar notas fiscais no EMS */
FOR EACH tt-notas:
    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = tt-notas.cod-estabel
          AND nota-fiscal.serie       = tt-notas.serie
          AND nota-fiscal.nr-nota-fis = tt-notas.nr-nota-fis NO-ERROR.

    IF  NOT AVAIL nota-fiscal
    THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.ind-tipo-integracao    = 3
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.des-erro-imp           = "N∆o foi encontrada nota fiscal de sa°da para:"
                                                 + CHR(13)
                                                 + "Estabelecimento: " + tt-notas.cod-estabel + CHR(13)
                                                 + "SÇrie..........: " + tt-notas.serie       + CHR(13)
                                                 + "Nota Fiscal....: " + tt-notas.nr-nota-fis
               tt-log-gko.nom-arquivo-integracao = tt-notas.nom-arquivo.
    END.
    ELSE DO:
        IF  nota-fiscal.dt-cancela <> ?
        THEN DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.ind-tipo-integracao    = 3
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "Nota fiscal foi cancelada, n∆o pode ter data de sa°da."
                                                     + CHR(13)
                                                     + "Estabelecimento: " + tt-notas.cod-estabel + CHR(13)
                                                     + "SÇrie..........: " + tt-notas.serie       + CHR(13)
                                                     + "Nota Fiscal....: " + tt-notas.nr-nota-fis + CHR(13)
                                                     + "Data Cancelada.: " + STRING(nota-fiscal.dt-cancela,"99/99/9999")
                   tt-log-gko.nom-arquivo-integracao = tt-notas.nom-arquivo.
        END.
        ELSE DO:
            FIND CURRENT nota-fiscal EXCLUSIVE-LOCK.
            ASSIGN nota-fiscal.dt-saida = tt-notas.dt-saida.
            IF  nota-fiscal.dt-embarque = ?
            THEN
                ASSIGN nota-fiscal.dt-embarque = tt-notas.dt-saida.
            FIND CURRENT nota-fiscal NO-LOCK.
        END.
    END.
END.

FOR EACH  b-tt-log-gko
    WHERE b-tt-log-gko.log-imp-erro = NO:
    FIND FIRST tt-log-gko
        WHERE  tt-log-gko.nom-arquivo-integracao = b-tt-log-gko.nom-arquivo-integracao
          AND  tt-log-gko.log-imp-erro           = YES NO-ERROR.

    IF  AVAIL tt-log-gko
    THEN
        DELETE b-tt-log-gko.
    ELSE DO:
        OS-COPY   VALUE(b-tt-log-gko.nom-arquivo-integracao) VALUE(v-cod-dir-destino + b-tt-log-gko.cod-arquivo-integracao).
        OS-DELETE VALUE(b-tt-log-gko.nom-arquivo-integracao) NO-ERROR.
    END.
END.

RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).

RETURN "ok".

/**********************************************************************/

