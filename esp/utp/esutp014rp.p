/*{include/i-prgvrs.i ESUTP014 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP\UTP\ESUTP005RP.P
**  Autor.....: Raphael Paini
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Integra Contabilidade Telefonia
**  Vers∆o....: 001 07/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{esp/utp/esutp014tt.i}
{esp/es0018.i}

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

DEFINE TEMP-TABLE tt-tarif NO-UNDO LIKE tarifador
    FIELD identif AS CHARACTER.

DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD arquivo AS CHARACTER FORMAT "x(60)".

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEFINE STREAM s-dir.

DEF var h-acomp      as handle no-undo.

DEFINE VARIABLE c-sistema      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo-relat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-empresa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-versao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-revisao      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE pc-diretorio   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-tot-reg AS INTEGER     NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
                 empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Importa Ligaá‰es Tarifador"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP014"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando Dados...").

    FOR EACH tt-arquivos:
        DELETE tt-arquivos.
    END.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "esutp014":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    IF OPSYS = "UNIX" THEN DO:
        FOR FIRST tt-prog-ponto
            WHERE tt-prog-ponto.sequencia = 1:
        END.
    END.
    ELSE DO:
        FOR FIRST tt-prog-ponto
            WHERE tt-prog-ponto.sequencia = 2:
        END.

    END.

    ASSIGN pc-diretorio = replace(tt-prog-ponto.conteudo, "~\", "/").

        

    input stream s-dir from OS-DIR(pc-diretorio)  NO-ATTR-LIST.
    repeat:
         import stream s-dir c-lista.
         IF INDEX(c-lista,".txt") = 0 OR c-lista = "." OR c-lista = ".." THEN 
             NEXT.

         CREATE tt-arquivos.
         ASSIGN tt-arquivos.arquivo   = TRIM(c-lista).

    END.
    input stream s-dir CLOSE.

    OUTPUT TO VALUE(tt-param.arquivo).

    FOR EACH tt-arquivos:
        RUN pi-busca-dados(INPUT pc-diretorio + tt-arquivos.arquivo).

        RUN pi-inicializar in h-acomp (input "Criando Registros...").

        RUN pi-cria-registros.

        PUT UNFORMATTED 
            "Importaá∆o realizada com sucesso! Arquivo: " tt-arquivos.arquivo " - Data: " STRING(TODAY,"99/99/9999") + " - Hora: " + STRING(TIME,"HH:MM:SS") + " - Total Registros: " + STRING(i-tot-reg) SKIP.

        OS-COPY VALUE(pc-diretorio + tt-arquivos.arquivo) VALUE(pc-diretorio + "backup/" + tt-arquivos.arquivo).

        OS-DELETE VALUE(pc-diretorio + tt-arquivos.arquivo).
    END.

    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.

    RETURN "OK".
END.

PROCEDURE pi-busca-dados:
    DEFINE INPUT PARAMETER p-arquivo AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-data AS DATE      NO-UNDO.
    DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-ramal AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-tempo  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-tipo    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-duracao AS CHARACTER   NO-UNDO.

    FOR EACH tt-tarif:
        DELETE tt-tarif.
    END.

    ASSIGN i-linha = 0.

    if search(p-arquivo) = ? then next.

    INPUT FROM VALUE(p-arquivo).
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN i-linha = i-linha + 1.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Lendo Arquivo Linha: " + STRING(i-linha)).

        ASSIGN dt-data = ?.
        ASSIGN dt-data = DATE(SUBSTR(c-linha,56,8)) NO-ERROR.
        IF ERROR-STATUS:ERROR OR dt-data = ? THEN
            NEXT.

        IF dt-data < 03/01/2009 THEN NEXT.

        IF LENGTH(TRIM(SUBSTRING(c-linha,24,20))) <= 8 THEN
            IF TRIM(SUBSTRING(c-linha,24,3)) <> "102" AND TRIM(SUBSTRING(c-linha,24,3)) <> "103" THEN
                NEXT.

        IF SUBSTRING(c-linha,1,1) <> "O" /*Originada*/  THEN NEXT.


        ASSIGN c-tipo    = SUBSTRING(c-linha,113,3)
               de-tempo  = 0.
        IF c-tipo = "CCN" OR c-tipo = "CCE" OR c-tipo = "CCR" THEN DO:
            /*Emilina ligacoes de celular inferior a 48s, pois interface celular nao tem como passar tempo exato da ligacao, assim podendo cobrar ligacoes nao realizadas*/
            ASSIGN c-duracao = SUBSTRING(c-linha,74,8)
                   de-tempo  = (INT(SUBSTRING(c-duracao,1,2)) * 60) + 
                               INT(SUBSTRING(c-duracao,4,2)) +
                               (INT(SUBSTRING(c-duracao,7,2)) / 60).  
            IF de-tempo = ? OR de-tempo <= 0.80 THEN
                NEXT.
        END.

        ASSIGN c-ramal = LEFT-TRIM(SUBSTR(c-linha,3,5)).

        IF c-ramal = "9575" OR 
           c-ramal = "9576" OR 
           c-ramal = "9584" THEN 
            ASSIGN c-ramal = "9577" /*informatica*/ .


        CREATE tt-tarif.
        ASSIGN tt-tarif.identif    = SUBSTRING(c-linha,1,1)
               tt-tarif.ramal      = c-ramal
               tt-tarif.numero     = TRIM(SUBSTRING(c-linha,24,20))
               tt-tarif.data       = dt-data
               tt-tarif.hora       = SUBSTRING(c-linha,65,8)
               tt-tarif.duracao    = SUBSTRING(c-linha,74,8)
               tt-tarif.tipo       = SUBSTRING(c-linha,113,3)
               tt-tarif.valor      = DEC(SUBSTRING(c-linha,118,7))
               tt-tarif.localidade = TRIM(SUBSTRING(c-linha,126,30))
               tt-tarif.uf         = SUBSTRING(c-linha,157,2).
    END.
    INPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-cria-registros:
    ASSIGN i-tot-reg = 0.
    FOR EACH tt-tarif
       WHERE tt-tarif.tipo <> "LOC"
         AND tt-tarif.tipo <> "OTR"
         AND tt-tarif.tipo <> "NDI"
         AND tt-tarif.valor > 0
      BREAK BY tt-tarif.tipo:

        FIND FIRST tarifador NO-LOCK
             WHERE tarifador.ramal  = tt-tarif.ramal
               AND tarifador.data   = tt-tarif.data
               AND tarifador.hora   = tt-tarif.hora
               AND tarifador.numero = tt-tarif.numero NO-ERROR.
        IF NOT AVAIL tarifador THEN DO:
            RUN pi-acompanhar IN h-acomp (INPUT "Criando Registro Tipo: " + STRING(tt-tarif.tipo)).
            CREATE tarifador.
            ASSIGN tarifador.ramal       = tt-tarif.ramal
                   tarifador.data        = tt-tarif.data
                   tarifador.hora        = tt-tarif.hora
                   tarifador.duracao     = tt-tarif.duracao
                   tarifador.numero      = tt-tarif.numero
                   tarifador.localidade  = tt-tarif.localidade                                    
                   tarifador.valor       = tt-tarif.valor
                   tarifador.uf          = tt-tarif.uf           
                   tarifador.tipo        = tt-tarif.tipo
                   tarifador.finalidade  = no
                   tarifador.avaliado    = no
                   tarifador.cobrado     = no.
            ASSIGN i-tot-reg = i-tot-reg + 1.
        END.
    END.
END PROCEDURE.
