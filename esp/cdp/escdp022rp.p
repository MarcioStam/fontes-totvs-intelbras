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
**  Programa.: Importar arquivos de CEP disponibilizados pelo correio.
**  Objetivo.: Importaá∆o.
**  Criaá∆o..: 01/06/2010
**  Vers∆o...: Gustavo Eduardo Tamanini (SQL Works).
**
*******************************************************************************/
{include/i-prgvrs.i ESCDP022RP 2.00.00.000}

{include/i-rpvar.i}
{esp/es0018.i}

/* Includes Definitions ---                                             */
DEFINE TEMP-TABLE tt-param NO-UNDO     
    FIELD destino     AS INTEGER
    FIELD dir-entrada AS CHAR      FORMAT "x(35)":U
    FIELD arq-destino AS CHARACTER FORMAT "x(35)":U
    FIELD usuario     AS CHAR      FORMAT "x(12)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD todos       AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.

/* Local Variables Definitions ---                                      */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp         AS HANDLE             NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-imprime-todos AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-dir-entrada   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-arq-destino   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i-lin           AS INTEGER INITIAL 0  NO-UNDO.

DEF VAR c-arq-entrada-unix    AS CHAR NO-UNDO.
DEF VAR c-arq-entrada-windows AS CHAR NO-UNDO.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Local Temp-Tables Definitions ---                                    */
DEFINE TEMP-TABLE tt-grandes-usuar NO-UNDO    
    FIELD i-linha          AS INTEGER   LABEL "Linha":U
    FIELD uf               AS CHARACTER FORMAT "x(2)"
    FIELD local-cep        AS INTEGER   FORMAT "999999"
    FIELD local-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local   AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep       AS INTEGER   FORMAT "99999"
    FIELD bairro-dne       AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-bairro  AS CHARACTER FORMAT "x(72)"
    FIELD gran-usuar-cep   AS INTEGER   FORMAT "999999"
    FIELD gran-usuar-dne   AS INTEGER   FORMAT "99999999"
    FIELD nome-gran-usuar  AS CHARACTER FORMAT "x(72)"
    FIELD cep-gran-usuar   AS CHARACTER FORMAT "x(8)"
    FIELD abrev-gran-usuar AS CHARACTER FORMAT "x(36)"
    .

DEFINE TEMP-TABLE tt-grandes-usuar-end NO-UNDO
    FIELD i-linha            AS INTEGER   LABEL "Linha":U
    FIELD gran-usuar-cep     AS INTEGER   FORMAT "999999"
    FIELD gran-usuar-dne     AS INTEGER   FORMAT "99999999"
    FIELD tipo-log           AS CHARACTER FORMAT "x(72)"
    FIELD preposicao         AS CHARACTER FORMAT "x(3)"
    FIELD tit-pat-log        AS CHARACTER FORMAT "x(72)"
    FIELD log-cep            AS INTEGER   FORMAT "999999"
    FIELD log-dne            AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log       AS CHARACTER FORMAT "x(72)"
    FIELD nr-lote            AS CHARACTER FORMAT "x(11)"
    FIELD nome-complto       AS CHARACTER FORMAT "x(36)"
    FIELD nr-complto         AS CHARACTER FORMAT "x(11)"
    FIELD nome-complto2      AS CHARACTER FORMAT "x(36)"
    FIELD nr-complto2        AS CHARACTER FORMAT "x(11)"
    FIELD tipo-ofi-unid-ocup AS CHARACTER FORMAT "x(36)"
    FIELD nr-unid-ocup       AS CHARACTER FORMAT "x(36)"
    .

DEFINE TEMP-TABLE tt-logradouro
    FIELD i-linha        AS INTEGER   LABEL "Linha":U
    FIELD uf             AS CHARACTER FORMAT "x(2)"
    FIELD local-cep      AS INTEGER   FORMAT "999999"
    FIELD local-dne      AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-ini AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-ini AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-ini AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-fin AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-fin AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-fin AS CHARACTER FORMAT "x(72)"
    FIELD tipo-ofi-log   AS CHARACTER FORMAT "x(26)"
    FIELD preposicao     AS CHARACTER FORMAT "x(3)"
    FIELD titulo-ofi-log AS CHARACTER FORMAT "x(72)"
    FIELD log-cep        AS INTEGER   FORMAT "999999"
    FIELD log-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log   AS CHARACTER FORMAT "x(72)"
    FIELD abrev-log      AS CHARACTER FORMAT "x(36)"
    FIELD inf-adicio     AS CHARACTER FORMAT "x(36)"
    FIELD cep-log        AS CHARACTER FORMAT "x(8)"
    FIELD log-gran-usuar AS CHARACTER
    .

DEFINE TEMP-TABLE tt-logradouro-secc
    FIELD i-linha        AS INTEGER   LABEL "Linha":U
    FIELD uf             AS CHARACTER FORMAT "x(2)"    
    FIELD local-cep      AS INTEGER   FORMAT "999999"  
    FIELD local-dne      AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-ini AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-ini AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-ini AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-fin AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-fin AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-fin AS CHARACTER FORMAT "x(72)"
    FIELD tipo-ofi-log   AS CHARACTER FORMAT "x(26)"
    FIELD preposicao     AS CHARACTER FORMAT "x(3)"
    FIELD titulo-ofi-log AS CHARACTER FORMAT "x(72)"
    FIELD log-cep        AS INTEGER   FORMAT "999999"
    FIELD log-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log   AS CHARACTER FORMAT "x(72)"
    FIELD abrev-log      AS CHARACTER FORMAT "x(36)"
    FIELD inf-adicio     AS CHARACTER FORMAT "x(36)"
    FIELD cep-log        AS CHARACTER FORMAT "x(8)"
    FIELD log-gran-usuar AS CHARACTER
    FIELD nr-trecho-ini  AS INTEGER   FORMAT "99999999999"
    FIELD nr-trecho-fin  AS INTEGER   FORMAT "99999999999"
    FIELD ident-pari     AS CHARACTER
    FIELD chave-secc     AS INTEGER   FORMAT "99999999"
    .

DEFINE TEMP-TABLE tt-logradouro-complto
    FIELD i-linha        AS INTEGER   LABEL "Linha":U
    FIELD uf             AS CHARACTER FORMAT "x(2)"    
    FIELD local-cep      AS INTEGER   FORMAT "999999"  
    FIELD local-dne      AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-ini AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-ini AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-ini AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-fin AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-fin AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-fin AS CHARACTER FORMAT "x(72)"
    FIELD tipo-ofi-log   AS CHARACTER FORMAT "x(26)"
    FIELD preposicao     AS CHARACTER FORMAT "x(3)"
    FIELD titulo-ofi-log AS CHARACTER FORMAT "x(72)"
    FIELD log-cep        AS INTEGER   FORMAT "999999"
    FIELD log-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log   AS CHARACTER FORMAT "x(72)"
    FIELD abrev-log      AS CHARACTER FORMAT "x(36)"
    FIELD inf-adicio     AS CHARACTER FORMAT "x(36)"
    FIELD cep-log        AS CHARACTER FORMAT "x(8)"
    FIELD log-gran-usuar AS CHARACTER
    FIELD nr-lote-dne    AS CHARACTER FORMAT "x(11)"
    FIELD nome-complto   AS CHARACTER FORMAT "x(36)"
    FIELD nr-complto     AS CHARACTER FORMAT "x(11)"
    FIELD lote-dne       AS CHARACTER FORMAT "x(8)"
    FIELD complto-dne    AS CHARACTER FORMAT "x(8)"
    .

DEFINE TEMP-TABLE tt-logradouro-complto2
    FIELD i-linha        AS INTEGER   LABEL "Linha":U
    FIELD uf             AS CHARACTER FORMAT "x(2)"    
    FIELD local-cep      AS INTEGER   FORMAT "999999"  
    FIELD local-dne      AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-ini AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-ini AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-ini AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-fin AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-fin AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-fin AS CHARACTER FORMAT "x(72)"
    FIELD tipo-ofi-log   AS CHARACTER FORMAT "x(26)"
    FIELD preposicao     AS CHARACTER FORMAT "x(3)"
    FIELD titulo-ofi-log AS CHARACTER FORMAT "x(72)"
    FIELD log-cep        AS INTEGER   FORMAT "999999"
    FIELD log-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log   AS CHARACTER FORMAT "x(72)"
    FIELD abrev-log      AS CHARACTER FORMAT "x(36)"
    FIELD inf-adicio     AS CHARACTER FORMAT "x(36)"
    FIELD cep-log        AS CHARACTER FORMAT "x(8)"
    FIELD log-gran-usuar AS CHARACTER
    FIELD nr-lote-dne    AS CHARACTER FORMAT "x(11)"
    FIELD nome-complto   AS CHARACTER FORMAT "x(36)"
    FIELD nr-complto     AS CHARACTER FORMAT "x(11)"
    FIELD nome-complto2  AS CHARACTER FORMAT "x(11)"
    FIELD nr-complto2    AS CHARACTER FORMAT "x(11)"
    FIELD lote-dne       AS CHARACTER FORMAT "x(8)"
    FIELD complto-dne    AS CHARACTER FORMAT "x(8)"
    FIELD complto-dne2   AS CHARACTER FORMAT "x(8)"
    .

DEFINE TEMP-TABLE tt-logradouro-lote
    FIELD i-linha        AS INTEGER   LABEL "Linha":U
    FIELD uf             AS CHARACTER FORMAT "x(2)"    
    FIELD local-cep      AS INTEGER   FORMAT "999999"  
    FIELD local-dne      AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-local AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-ini AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-ini AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-ini AS CHARACTER FORMAT "x(72)"
    FIELD bairro-cep-fin AS INTEGER   FORMAT "99999"
    FIELD bairro-dne-fin AS INTEGER   FORMAT "99999999"
    FIELD bairro-log-fin AS CHARACTER FORMAT "x(72)"
    FIELD tipo-ofi-log   AS CHARACTER FORMAT "x(26)"
    FIELD preposicao     AS CHARACTER FORMAT "x(3)"
    FIELD titulo-ofi-log AS CHARACTER FORMAT "x(72)"
    FIELD log-cep        AS INTEGER   FORMAT "999999"
    FIELD log-dne        AS INTEGER   FORMAT "99999999"
    FIELD nome-ofi-log   AS CHARACTER FORMAT "x(72)"
    FIELD abrev-log      AS CHARACTER FORMAT "x(36)"
    FIELD inf-adicio     AS CHARACTER FORMAT "x(36)"
    FIELD cep-log        AS CHARACTER FORMAT "x(8)"
    FIELD log-gran-usuar AS CHARACTER
    FIELD nr-lote-dne    AS CHARACTER FORMAT "x(11)"
    FIELD lote-dne       AS CHARACTER FORMAT "x(8)"
    .

DEFINE TEMP-TABLE tt-arquivo
    FIELD cArq        AS CHAR FORMAT "X(20)" 
    FIELD cArqcaminho AS CHAR FORMAT "X(50)" 
    FIELD cArqId      AS CHAR FORMAT "X(20)".

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras":U
       c-titulo-relat = "":U
       c-empresa      = IF AVAILABLE mgcad.empresa THEN mgcad.empresa.razao-social ELSE "":U
       c-programa     = "ESCDP022RP":U
       c-versao       = "2.04":U
       c-revisao      = "000":U.

FORM SKIP(1)
     "PAR∂METRO":U                                                       AT 12 SKIP(1)
     c-dir-entrada    FORMAT "x(80)":U LABEL "Diret¢rio de Entrada":U COLON 37 SKIP(1)
     "LOG":U                                                             AT 12 SKIP(1)
     c-imprime-todos  FORMAT "x(12)":U LABEL "Imprime":U              COLON 37 SKIP
     c-arq-destino    FORMAT "x(80)":U LABEL "Destino":U              COLON 37 SKIP
     tt-param.usuario FORMAT "x(12)":U LABEL "Usu†rio":U              COLON 37 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-arq-entrada-unix = tt-prog-ponto.conteudo. 
END.

RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).
FOR FIRST tt-prog-ponto:
    ASSIGN c-arq-entrada-windows = tt-prog-ponto.conteudo. 
END.

IF OPSYS = "unix" THEN
    IF INDEX(tt-param.arq-destino,"c-arq-entrada-windows":U) <> 0 THEN
        ASSIGN tt-param.arq-destino = REPLACE(tt-param.arq-destino,c-arq-entrada-windows,c-arq-entrada-unix).
    
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados..":U).

DO ON STOP UNDO, LEAVE:
    RUN pi-tt-arquivo.
    RUN pi-importa-arquivo.
    RUN pi-armazena-informacao.
END.

{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
{include/i-rpcab.i &STREAM="str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

ASSIGN c-imprime-todos = ENTRY(tt-param.todos, "Todos,Rejeitados":U, ",":U)
       c-dir-entrada   = REPLACE(tt-param.dir-entrada, "/":U, "~\":U)
       c-arq-destino   = REPLACE(tt-param.arq-destino, "/":U, "~\":U).

DISPLAY STREAM str-rp
        c-dir-entrada
        c-imprime-todos 
        c-arq-destino
        tt-param.usuario
    WITH FRAME f-impressao.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &STREAM="stream str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.

/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importa-arquivo:

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Importando dados..":U).

    EMPTY TEMP-TABLE tt-grandes-usuar.
    EMPTY TEMP-TABLE tt-grandes-usuar-end.
    EMPTY TEMP-TABLE tt-logradouro.
    EMPTY TEMP-TABLE tt-logradouro-secc.
    EMPTY TEMP-TABLE tt-logradouro-complto.
    EMPTY TEMP-TABLE tt-logradouro-complto2.
    EMPTY TEMP-TABLE tt-logradouro-lote.

    FOR EACH tt-arquivo:
        IF tt-arquivo.cArq = "DNE_GU_GRANDES_USUARIOS.TXT":U THEN
            RUN pi-grandes-usuarios.
        ELSE
            IF  tt-arquivo.cArq BEGINS  "DNE_GU_"           AND
                tt-arquivo.cArq MATCHES "*_LOGRADOUROS.TXT" THEN
                RUN pi-logradouros.
    END.
END PROCEDURE.

PROCEDURE pi-armazena-informacao:

    IF CAN-FIND(FIRST tt-grandes-usuar) THEN DO:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-seta-titulo IN h-acomp (INPUT "Salvando Grandes Usuarios..":U).

        FOR EACH tt-grandes-usuar:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + STRING(tt-grandes-usuar.i-linha)).            

            FOR FIRST tt-grandes-usuar-end
                WHERE tt-grandes-usuar-end.gran-usuar-cep = tt-grandes-usuar.gran-usuar-cep
                  AND tt-grandes-usuar-end.gran-usuar-dne = tt-grandes-usuar.gran-usuar-dne:

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + STRING(tt-grandes-usuar-end.i-linha)).                

                IF NOT CAN-FIND (FIRST cep
                                 WHERE cep.cep = INT(tt-grandes-usuar.cep-gran-usuar) NO-LOCK) THEN DO:
                    CREATE cep.
                    ASSIGN cep.localidade      = tt-grandes-usuar.nome-ofi-local
                           cep.uf              = tt-grandes-usuar.uf.
                END.
                ELSE DO:
                    FOR FIRST cep
                        WHERE cep.cep = INT(tt-grandes-usuar.cep-gran-usuar) EXCLUSIVE-LOCK:
                    END.
                END.

                IF AVAIL cep THEN DO:
                    ASSIGN cep.cep             = INT(tt-grandes-usuar.cep-gran-usuar)
                           cep.nome-gran-usuar = tt-grandes-usuar.nome-gran-usuar
                           cep.bairro-ini      = tt-grandes-usuar.nome-ofi-bairro 
                           cep.bairro-fin      = tt-grandes-usuar.nome-ofi-bairro      
                           cep.tipo-log        = tt-grandes-usuar-end.tipo-log 
                           cep.nome-complto    = tt-grandes-usuar-end.nome-complto
                           cep.nome-complto2   = tt-grandes-usuar-end.nome-complto2
                           cep.nome-log        = tt-grandes-usuar-end.nome-ofi-log  
                           cep.nr-complto      = tt-grandes-usuar-end.nr-complto 
                           cep.nr-complto2     = tt-grandes-usuar-end.nr-complto2 
                           cep.nr-lote-ini     = tt-grandes-usuar-end.nr-lote
                           cep.nr-lote-fin     = tt-grandes-usuar-end.nr-lote
                           cep.preposicao      = tt-grandes-usuar-end.preposicao
                           cep.tit-pat-log     = tt-grandes-usuar-end.tit-pat-log.

                    RUN pi-atualiza-ibge.

                    RELEASE cep.
                END.
            END.
        END.
    END. /* can-find */

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Salvando Logradouros..":U).

    FOR EACH tt-logradouro:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT STRING(tt-logradouro.uf) + " - Linha: ":U + STRING(tt-logradouro.i-linha)).

        IF NOT CAN-FIND (FIRST cep
                         WHERE cep.cep = INT(tt-logradouro.cep-log) NO-LOCK) THEN DO:
            CREATE cep.
            ASSIGN cep.localidade      = tt-logradouro.nome-ofi-local
                   cep.uf              = tt-logradouro.uf.
        END.
        ELSE DO:
            FOR FIRST cep
                WHERE cep.cep = INT(tt-logradouro.cep-log) EXCLUSIVE-LOCK:
            END.
        END.
        
        IF AVAIL cep THEN DO:            
            ASSIGN cep.cep             = INT(tt-logradouro.cep-log)
                   cep.nome-gran-usuar = "":U
                   cep.bairro-ini      = tt-logradouro.bairro-log-ini
                   cep.bairro-fin      = tt-logradouro.bairro-log-fin
                   cep.tipo-log        = tt-logradouro.tipo-ofi-log
                   cep.nome-complto    = "":U
                   cep.nome-complto2   = "":U
                   cep.nome-log        = tt-logradouro.nome-ofi-log
                   cep.nr-complto      = "":U
                   cep.nr-complto2     = "":U
                   cep.nr-lote-ini     = "":U
                   cep.nr-lote-fin     = "":U
                   cep.preposicao      = tt-logradouro.preposicao
                   cep.tit-pat-log     = tt-logradouro.titulo-ofi-log.

            RUN pi-atualiza-ibge.
                  
            RELEASE cep.
        END.
    END.

    FOR EACH tt-logradouro-secc:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT STRING(tt-logradouro-secc.uf) + " - Linha: ":U + STRING(tt-logradouro-secc.i-linha)).        

        IF NOT CAN-FIND (FIRST cep
                         WHERE cep.cep = INT(tt-logradouro-secc.cep-log) NO-LOCK) THEN DO:
            CREATE cep.
            ASSIGN cep.localidade      = tt-logradouro-secc.nome-ofi-local
                   cep.uf              = tt-logradouro-secc.uf.
        END.
        ELSE DO:
            FOR FIRST cep
                WHERE cep.cep = INT(tt-logradouro-secc.cep-log) EXCLUSIVE-LOCK:
            END.
        END.

        IF AVAIL cep THEN DO:            
            ASSIGN cep.cep             = INT(tt-logradouro-secc.cep-log)
                   cep.bairro-ini      = tt-logradouro-secc.bairro-log-ini
                   cep.bairro-fin      = tt-logradouro-secc.bairro-log-fin
                   cep.tipo-log        = tt-logradouro-secc.tipo-ofi-log
                   cep.nome-complto    = "":U
                   cep.nome-complto2   = "":U
                   cep.nome-log        = tt-logradouro-secc.nome-ofi-log
                   cep.nr-complto      = "":U
                   cep.nr-complto2     = "":U
                   cep.nr-lote-ini     = STRING(tt-logradouro-secc.nr-trecho-ini)
                   cep.nr-lote-fin     = STRING(tt-logradouro-secc.nr-trecho-fin)
                   cep.preposicao      = tt-logradouro-secc.preposicao
                   cep.tit-pat-log     = tt-logradouro-secc.titulo-ofi-log.

            RUN pi-atualiza-ibge.

            /* Indicador de existencia de Grande Usuario no Logradouro. */
            IF tt-logradouro-secc.log-gran-usuar = "S":U THEN DO:
                FIND FIRST tt-grandes-usuar WHERE 
                           tt-grandes-usuar.local-cep = tt-logradouro-secc.local-cep AND
                           tt-grandes-usuar.local-dne = tt-logradouro-secc.local-dne NO-LOCK NO-ERROR.

                IF AVAIL tt-grandes-usuar THEN
                    ASSIGN cep.nome-gran-usuar = tt-grandes-usuar.nome-gran-usuar.
            END.
            RELEASE cep.
        END.
    END.

    FOR EACH tt-logradouro-complto:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT STRING(tt-logradouro-complto.uf) + " - Linha: ":U + STRING(tt-logradouro-complto.i-linha)).

        IF NOT CAN-FIND (FIRST cep
                         WHERE cep.cep = INT(tt-logradouro-complto.cep-log) NO-LOCK) THEN DO:
            CREATE cep.
            ASSIGN cep.localidade      = tt-logradouro-complto.nome-ofi-local
                   cep.uf              = tt-logradouro-complto.uf.
        END.
        ELSE DO:
            FOR FIRST cep
                WHERE cep.cep = INT(tt-logradouro-complto.cep-log) EXCLUSIVE-LOCK:
            END.
        END.
        IF AVAIL cep THEN DO:
            ASSIGN cep.cep             = INT(tt-logradouro-complto.cep-log)
                   cep.bairro-ini      = tt-logradouro-complto.bairro-log-ini
                   cep.bairro-fin      = tt-logradouro-complto.bairro-log-fin
                   cep.tipo-log        = tt-logradouro-complto.tipo-ofi-log
                   cep.nome-complto    = tt-logradouro-complto.nome-complto
                   cep.nome-complto2   = ""
                   cep.nome-log        = tt-logradouro-complto.nome-ofi-log
                   cep.nr-complto      = tt-logradouro-complto.nr-complto
                   cep.nr-complto2     = ""
                   cep.nr-lote-ini     = tt-logradouro-complto.nr-lote-dne
                   cep.nr-lote-fin     = tt-logradouro-complto.nr-lote-dne
                   cep.preposicao      = tt-logradouro-complto.preposicao
                   cep.tit-pat-log     = tt-logradouro-complto.titulo-ofi-log.

            RUN pi-atualiza-ibge.
                   
            /* Indicador de existencia de Grande Usuario no Logradouro. */
            IF tt-logradouro-complto.log-gran-usuar = "S":U THEN DO:
                FIND FIRST tt-grandes-usuar WHERE 
                           tt-grandes-usuar.local-cep = tt-logradouro-complto.local-cep AND
                           tt-grandes-usuar.local-dne = tt-logradouro-complto.local-dne NO-LOCK NO-ERROR.
                IF AVAIL tt-grandes-usuar THEN
                    ASSIGN cep.nome-gran-usuar = tt-grandes-usuar.nome-gran-usuar.
            END.
            RELEASE cep.
        END.
    END.

    FOR EACH tt-logradouro-complto2:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT STRING(tt-logradouro-complto2.uf) + " - Linha: ":U + STRING(tt-logradouro-complto2.i-linha)).

        IF NOT CAN-FIND (FIRST cep
                         WHERE cep.cep = INT(tt-logradouro-complto2.cep-log) NO-LOCK) THEN DO:
            CREATE cep.
            ASSIGN cep.localidade      = tt-logradouro-complto2.nome-ofi-local
                   cep.uf              = tt-logradouro-complto2.uf.
        END.
        ELSE DO:
            FOR FIRST cep
                WHERE cep.cep = INT(tt-logradouro-complto2.cep-log) EXCLUSIVE-LOCK:
            END.
        END.
        IF AVAIL cep THEN DO:
            ASSIGN cep.cep             = INT(tt-logradouro-complto2.cep-log)
                   cep.bairro-ini      = tt-logradouro-complto2.bairro-log-ini
                   cep.bairro-fin      = tt-logradouro-complto2.bairro-log-fin
                   cep.tipo-log        = tt-logradouro-complto2.tipo-ofi-log
                   cep.nome-complto    = tt-logradouro-complto2.nome-complto
                   cep.nome-complto2   = tt-logradouro-complto2.nome-complto2
                   cep.nome-log        = tt-logradouro-complto2.nome-ofi-log
                   cep.nr-complto      = tt-logradouro-complto2.nr-complto
                   cep.nr-complto2     = tt-logradouro-complto2.nr-complto2
                   cep.nr-lote-ini     = tt-logradouro-complto2.nr-lote-dne
                   cep.nr-lote-fin     = tt-logradouro-complto2.nr-lote-dne
                   cep.preposicao      = tt-logradouro-complto2.preposicao
                   cep.tit-pat-log     = tt-logradouro-complto2.titulo-ofi-log.

            RUN pi-atualiza-ibge.

            /* Indicador de existencia de Grande Usuario no Logradouro. */
            IF tt-logradouro-complto2.log-gran-usuar = "S":U THEN DO:
                FIND FIRST tt-grandes-usuar WHERE 
                           tt-grandes-usuar.local-cep = tt-logradouro-complto2.local-cep AND
                           tt-grandes-usuar.local-dne = tt-logradouro-complto2.local-dne NO-LOCK NO-ERROR.
                IF AVAIL tt-grandes-usuar THEN
                    ASSIGN cep.nome-gran-usuar = tt-grandes-usuar.nome-gran-usuar.
            END.
            RELEASE cep.
        END.
    END.

    FOR EACH tt-logradouro-lote:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT STRING(tt-logradouro-lote.uf) + " - Linha: ":U + STRING(tt-logradouro-lote.i-linha)).

        IF NOT CAN-FIND (FIRST cep
                         WHERE cep.cep = INT(tt-logradouro-lote.cep-log) NO-LOCK) THEN DO:
            CREATE cep.
            ASSIGN cep.localidade      = tt-logradouro-lote.nome-ofi-local
                   cep.uf              = tt-logradouro-lote.uf.
        END.
        ELSE DO:
            FOR FIRST cep
                WHERE cep.cep = INT(tt-logradouro-lote.cep-log) EXCLUSIVE-LOCK:
            END.
        END.
        IF AVAIL cep THEN DO:
            ASSIGN cep.cep             = INT(tt-logradouro-lote.cep-log)
                   cep.bairro-ini      = tt-logradouro-lote.bairro-log-ini
                   cep.bairro-fin      = tt-logradouro-lote.bairro-log-fin
                   cep.tipo-log        = tt-logradouro-lote.tipo-ofi-log
                   cep.nome-complto    = ""
                   cep.nome-complto2   = ""
                   cep.nome-log        = tt-logradouro-lote.nome-ofi-log
                   cep.nr-complto      = ""
                   cep.nr-complto2     = ""
                   cep.nr-lote-ini     = tt-logradouro-lote.nr-lote-dne
                   cep.nr-lote-fin     = tt-logradouro-lote.nr-lote-dne
                   cep.preposicao      = tt-logradouro-lote.preposicao
                   cep.tit-pat-log     = tt-logradouro-lote.titulo-ofi-log.
                   
            RUN pi-atualiza-ibge.

            /* Indicador de existencia de Grande Usuario no Logradouro. */
            IF tt-logradouro-lote.log-gran-usuar = "S":U THEN DO:
                FIND FIRST tt-grandes-usuar WHERE 
                           tt-grandes-usuar.local-cep = tt-logradouro-lote.local-cep AND
                           tt-grandes-usuar.local-dne = tt-logradouro-lote.local-dne NO-LOCK NO-ERROR.
                IF AVAIL tt-grandes-usuar THEN
                    ASSIGN cep.nome-gran-usuar = tt-grandes-usuar.nome-gran-usuar.
            END.
            RELEASE cep.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-tt-arquivo:

    EMPTY TEMP-TABLE tt-arquivo.

    INPUT FROM OS-DIR(tt-param.dir-entrada) CONVERT SOURCE "iso8859-1".

    REPEAT:
        CREATE tt-arquivo.
        IMPORT tt-arquivo.cArq tt-arquivo.cArqCaminho tt-arquivo.cArqId.
    END.

    /** Elimina os registros que tenham o nome do arquivo diferentes de:
        'DNE_GU_<**>_LOGRADOUROS.TXT' e 'DNE_GU_GRANDES_USUARIOS.TXT'
     **/
    FOR EACH tt-arquivo:
        IF  tt-arquivo.cArq BEGINS  "DNE_GU_"           AND
            tt-arquivo.cArq MATCHES "*_LOGRADOUROS.TXT" THEN
            NEXT.

        IF tt-arquivo.cArq = "DNE_GU_GRANDES_USUARIOS.TXT":U THEN
            NEXT.        

        DELETE tt-arquivo.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-grandes-usuarios:
    /** Importa arquivo 'DNE_GU_GRANDES_USUARIOS.TXT' **/
    INPUT STREAM s-imp FROM VALUE(tt-arquivo.cArqCaminho) CONVERT SOURCE "iso8859-1".

    ASSIGN i-lin = 0.

    REPEAT:
        IMPORT STREAM s-imp UNFORMATTED c-linha.

        ASSIGN i-lin = i-lin + 1.

        /* Ignora a primeira linha, pois Ç o cabeáalho. */
        IF i-lin = 1 THEN
            NEXT.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT c-linha).

        /* D = Dados */
        IF SUBSTRING(c-linha,1,1) = "D":U THEN DO:
            CREATE tt-grandes-usuar.
            ASSIGN tt-grandes-usuar.i-linha          = i-lin
                   tt-grandes-usuar.uf               = SUBSTRING(c-linha,2,2)  
                   tt-grandes-usuar.local-cep        = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-grandes-usuar.local-dne        = INTEGER(SUBSTRING(c-linha,10,8))
                   tt-grandes-usuar.nome-ofi-local   = SUBSTRING(c-linha,18,72) 
                   tt-grandes-usuar.bairro-cep       = INTEGER(SUBSTRING(c-linha,90,5))   
                   tt-grandes-usuar.bairro-dne       = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-grandes-usuar.nome-ofi-bairro  = SUBSTRING(c-linha,103,72) 
                   tt-grandes-usuar.gran-usuar-cep   = INTEGER(SUBSTRING(c-linha,175,6))
                   tt-grandes-usuar.gran-usuar-dne   = INTEGER(SUBSTRING(c-linha,181,8))
                   tt-grandes-usuar.nome-gran-usuar  = SUBSTRING(c-linha,189,72) 
                   tt-grandes-usuar.cep-gran-usuar   = SUBSTRING(c-linha,261,8) 
                   tt-grandes-usuar.abrev-gran-usuar = SUBSTRING(c-linha,269,36). 
        END.
        /* E - EndereÁo */
        ELSE IF SUBSTRING(c-linha,1,1) = "E":U THEN DO:
             CREATE tt-grandes-usuar-end.
             ASSIGN tt-grandes-usuar-end.i-linha            = i-lin
                    tt-grandes-usuar-end.gran-usuar-cep     = INTEGER(SUBSTRING(c-linha,2,6))
                    tt-grandes-usuar-end.gran-usuar-dne     = INTEGER(SUBSTRING(c-linha,8,8))
                    tt-grandes-usuar-end.tipo-log           = SUBSTRING(c-linha,16,72)  
                    tt-grandes-usuar-end.preposicao         = SUBSTRING(c-linha,88,3)  
                    tt-grandes-usuar-end.tit-pat-log        = SUBSTRING(c-linha,91,72)  
                    tt-grandes-usuar-end.log-cep            = INTEGER(SUBSTRING(c-linha,163,6))
                    tt-grandes-usuar-end.log-dne            = INTEGER(SUBSTRING(c-linha,169,8))
                    tt-grandes-usuar-end.nome-ofi-log       = SUBSTRING(c-linha,177,72)  
                    tt-grandes-usuar-end.nr-lote            = SUBSTRING(c-linha,249,11)  
                    tt-grandes-usuar-end.nome-complto       = SUBSTRING(c-linha,260,36)  
                    tt-grandes-usuar-end.nr-complto         = SUBSTRING(c-linha,296,11)  
                    tt-grandes-usuar-end.nome-complto2      = SUBSTRING(c-linha,307,36)  
                    tt-grandes-usuar-end.nr-complto2        = SUBSTRING(c-linha,343,11)  
                    tt-grandes-usuar-end.tipo-ofi-unid-ocup = SUBSTRING(c-linha,354,36)  
                    tt-grandes-usuar-end.nr-unid-ocup       = SUBSTRING(c-linha,390,36).
        END.
    END.
    INPUT STREAM s-imp CLOSE.
END PROCEDURE.

PROCEDURE pi-logradouros:
    /** Importa arquivos 'DNE_GU_<**>_LOGRADOUROS.TXT' **/
    INPUT STREAM s-imp FROM VALUE(tt-arquivo.cArqCaminho) CONVERT SOURCE "iso8859-1".

    ASSIGN i-lin = 0.

    REPEAT:
        IMPORT STREAM s-imp UNFORMATTED c-linha.

        ASSIGN i-lin = i-lin + 1.

        /* Ignora a primeira linha, pois Ç o cabeáalho. */
        IF i-lin = 1 THEN
            NEXT.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT c-linha).

        /* D = Dados */
        IF SUBSTRING(c-linha,1,1) = "D":U THEN DO:
            CREATE tt-logradouro.
            ASSIGN tt-logradouro.i-linha        = i-lin                               
                   tt-logradouro.uf             = SUBSTRING(c-linha,2,2)              
                   tt-logradouro.local-cep      = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-logradouro.local-dne      = INTEGER(SUBSTRING(c-linha,10,8))
                   tt-logradouro.nome-ofi-local = SUBSTRING(c-linha,18,72)
                   tt-logradouro.bairro-cep-ini = INTEGER(SUBSTRING(c-linha,90,5))
                   tt-logradouro.bairro-dne-ini = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-logradouro.bairro-log-ini = SUBSTRING(c-linha,103,72)
                   tt-logradouro.bairro-cep-fin = INTEGER(SUBSTRING(c-linha,175,5))
                   tt-logradouro.bairro-dne-fin = INTEGER(SUBSTRING(c-linha,180,8))
                   tt-logradouro.bairro-log-fin = SUBSTRING(c-linha,188,72)
                   tt-logradouro.tipo-ofi-log   = SUBSTRING(c-linha,260,26)
                   tt-logradouro.preposicao     = SUBSTRING(c-linha,286,3)
                   tt-logradouro.titulo-ofi-log = SUBSTRING(c-linha,289,72)
                 /*tt-logradouro.log-cep        = INTEGER(SUBSTRING(c-linha,361,6))
                   tt-logradouro.log-dne        = INTEGER(SUBSTRING(c-linha,367,8))*/
                   tt-logradouro.nome-ofi-log   = SUBSTRING(c-linha,375,72)
                   tt-logradouro.abrev-log      = SUBSTRING(c-linha,447,36)
                   tt-logradouro.inf-adicio     = SUBSTRING(c-linha,483,36)
                   tt-logradouro.cep-log        = SUBSTRING(c-linha,519,8)
                   tt-logradouro.log-gran-usuar = SUBSTRING(c-linha,527,1).
        END.
        /* S = Seccionamento */
        ELSE IF SUBSTRING(c-linha,1,1) = "S":U THEN DO:
            CREATE tt-logradouro-secc.
            ASSIGN tt-logradouro-secc.i-linha        = i-lin                              
                   tt-logradouro-secc.uf             = SUBSTRING(c-linha,2,2)
                   tt-logradouro-secc.local-cep      = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-logradouro-secc.local-dne      = INTEGER(SUBSTRING(c-linha,10,8))  
                   tt-logradouro-secc.nome-ofi-local = SUBSTRING(c-linha,18,72)
                   tt-logradouro-secc.bairro-cep-ini = INTEGER(SUBSTRING(c-linha,90,5))
                   tt-logradouro-secc.bairro-dne-ini = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-logradouro-secc.bairro-log-ini = SUBSTRING(c-linha,103,72)
                   tt-logradouro-secc.bairro-cep-fin = INTEGER(SUBSTRING(c-linha,175,5))      
                   tt-logradouro-secc.bairro-dne-fin = INTEGER(SUBSTRING(c-linha,180,8))   
                   tt-logradouro-secc.bairro-log-fin = SUBSTRING(c-linha,188,72)
                   tt-logradouro-secc.tipo-ofi-log   = SUBSTRING(c-linha,260,26)
                   tt-logradouro-secc.preposicao     = SUBSTRING(c-linha,286,3) 
                   tt-logradouro-secc.titulo-ofi-log = SUBSTRING(c-linha,289,72)
                 /*tt-logradouro-secc.log-cep        = INTEGER(SUBSTRING(c-linha,361,6))     
                   tt-logradouro-secc.log-dne        = INTEGER(SUBSTRING(c-linha,367,8))*/
                   tt-logradouro-secc.nome-ofi-log   = SUBSTRING(c-linha,375,72)
                   tt-logradouro-secc.abrev-log      = SUBSTRING(c-linha,447,36)
                   tt-logradouro-secc.inf-adicio     = SUBSTRING(c-linha,483,36)
                   tt-logradouro-secc.cep-log        = SUBSTRING(c-linha,519,8) 
                   tt-logradouro-secc.log-gran-usuar = SUBSTRING(c-linha,527,1) 
                   tt-logradouro-secc.nr-trecho-ini  = INTEGER(SUBSTRING(c-linha,528,11))
                   tt-logradouro-secc.nr-trecho-fin  = INTEGER(SUBSTRING(c-linha,539,11))
                   tt-logradouro-secc.ident-pari     = SUBSTRING(c-linha,550,1)
                   tt-logradouro-secc.chave-secc     = INTEGER(SUBSTRING(c-linha,551,8))
                   .
        END.
        /* K = Comlemento */
        ELSE IF SUBSTRING(c-linha,1,1) = "K":U THEN DO:
            CREATE tt-logradouro-complto.
            ASSIGN tt-logradouro-complto.i-linha        = i-lin                              
                   tt-logradouro-complto.uf             = SUBSTRING(c-linha,2,2)
                   tt-logradouro-complto.local-cep      = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-logradouro-complto.local-dne      = INTEGER(SUBSTRING(c-linha,10,8))  
                   tt-logradouro-complto.nome-ofi-local = SUBSTRING(c-linha,18,72)
                   tt-logradouro-complto.bairro-cep-ini = INTEGER(SUBSTRING(c-linha,90,5))
                   tt-logradouro-complto.bairro-dne-ini = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-logradouro-complto.bairro-log-ini = SUBSTRING(c-linha,103,72)
                   tt-logradouro-complto.bairro-cep-fin = INTEGER(SUBSTRING(c-linha,175,5))      
                   tt-logradouro-complto.bairro-dne-fin = INTEGER(SUBSTRING(c-linha,180,8))   
                   tt-logradouro-complto.bairro-log-fin = SUBSTRING(c-linha,188,72)
                   tt-logradouro-complto.tipo-ofi-log   = SUBSTRING(c-linha,260,26)
                   tt-logradouro-complto.preposicao     = SUBSTRING(c-linha,286,3) 
                   tt-logradouro-complto.titulo-ofi-log = SUBSTRING(c-linha,289,72)
                 /*tt-logradouro-complto.log-cep        = INTEGER(SUBSTRING(c-linha,361,6))     
                   tt-logradouro-complto.log-dne        = INTEGER(SUBSTRING(c-linha,367,8))*/
                   tt-logradouro-complto.nome-ofi-log   = SUBSTRING(c-linha,375,72)
                   tt-logradouro-complto.abrev-log      = SUBSTRING(c-linha,447,36)
                   tt-logradouro-complto.inf-adicio     = SUBSTRING(c-linha,483,36)
                   tt-logradouro-complto.cep-log        = SUBSTRING(c-linha,519,8) 
                   tt-logradouro-complto.log-gran-usuar = SUBSTRING(c-linha,527,1) 
                   tt-logradouro-complto.nr-lote-dne    = SUBSTRING(c-linha,528,11)
                   tt-logradouro-complto.nome-complto   = SUBSTRING(c-linha,539,36)
                   tt-logradouro-complto.nr-complto     = SUBSTRING(c-linha,575,11)
                   tt-logradouro-complto.lote-dne       = SUBSTRING(c-linha,586,8)
                   tt-logradouro-complto.complto-dne    = SUBSTRING(c-linha,594,8)
                   .
        END.
        /* Q = Comlemento 2 */
        ELSE IF SUBSTRING(c-linha,1,1) = "Q":U THEN DO:
            CREATE tt-logradouro-complto.
            ASSIGN tt-logradouro-complto.i-linha        = i-lin                              
                   tt-logradouro-complto.uf             = SUBSTRING(c-linha,2,2)
                   tt-logradouro-complto.local-cep      = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-logradouro-complto.local-dne      = INTEGER(SUBSTRING(c-linha,10,8))  
                   tt-logradouro-complto.nome-ofi-local = SUBSTRING(c-linha,18,72)
                   tt-logradouro-complto.bairro-cep-ini = INTEGER(SUBSTRING(c-linha,90,5))
                   tt-logradouro-complto.bairro-dne-ini = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-logradouro-complto.bairro-log-ini = SUBSTRING(c-linha,103,72)
                   tt-logradouro-complto.bairro-cep-fin = INTEGER(SUBSTRING(c-linha,175,5))      
                   tt-logradouro-complto.bairro-dne-fin = INTEGER(SUBSTRING(c-linha,180,8))   
                   tt-logradouro-complto.bairro-log-fin = SUBSTRING(c-linha,188,72)
                   tt-logradouro-complto.tipo-ofi-log   = SUBSTRING(c-linha,260,26)
                   tt-logradouro-complto.preposicao     = SUBSTRING(c-linha,286,3) 
                   tt-logradouro-complto.titulo-ofi-log = SUBSTRING(c-linha,289,72)
                 /*tt-logradouro-complto.log-cep        = INTEGER(SUBSTRING(c-linha,361,6))     
                   tt-logradouro-complto.log-dne        = INTEGER(SUBSTRING(c-linha,367,8))*/
                   tt-logradouro-complto.nome-ofi-log   = SUBSTRING(c-linha,375,72)
                   tt-logradouro-complto.abrev-log      = SUBSTRING(c-linha,447,36)
                   tt-logradouro-complto.inf-adicio     = SUBSTRING(c-linha,483,36)
                   tt-logradouro-complto.cep-log        = SUBSTRING(c-linha,519,8) 
                   tt-logradouro-complto.log-gran-usuar = SUBSTRING(c-linha,527,1) 
                   tt-logradouro-complto.nr-lote-dne    = SUBSTRING(c-linha,528,11)
                   tt-logradouro-complto.nome-complto   = SUBSTRING(c-linha,539,36)
                   tt-logradouro-complto.nr-complto     = SUBSTRING(c-linha,575,11)
                   tt-logradouro-complto.lote-dne       = SUBSTRING(c-linha,586,8)
                   tt-logradouro-complto.complto-dne    = SUBSTRING(c-linha,594,8)
                   .
        END.
        /* N = Numeraá∆o de Lote */
        ELSE IF SUBSTRING(c-linha,1,1) = "N":U THEN DO:
            CREATE tt-logradouro-lote.
            ASSIGN tt-logradouro-lote.i-linha        = i-lin                              
                   tt-logradouro-lote.uf             = SUBSTRING(c-linha,2,2)
                   tt-logradouro-lote.local-cep      = INTEGER(SUBSTRING(c-linha,4,6))
                   tt-logradouro-lote.local-dne      = INTEGER(SUBSTRING(c-linha,10,8))  
                   tt-logradouro-lote.nome-ofi-local = SUBSTRING(c-linha,18,72)
                   tt-logradouro-lote.bairro-cep-ini = INTEGER(SUBSTRING(c-linha,90,5))
                   tt-logradouro-lote.bairro-dne-ini = INTEGER(SUBSTRING(c-linha,95,8))
                   tt-logradouro-lote.bairro-log-ini = SUBSTRING(c-linha,103,72)
                   tt-logradouro-lote.bairro-cep-fin = INTEGER(SUBSTRING(c-linha,175,5))      
                   tt-logradouro-lote.bairro-dne-fin = INTEGER(SUBSTRING(c-linha,180,8))   
                   tt-logradouro-lote.bairro-log-fin = SUBSTRING(c-linha,188,72)
                   tt-logradouro-lote.tipo-ofi-log   = SUBSTRING(c-linha,260,26)
                   tt-logradouro-lote.preposicao     = SUBSTRING(c-linha,286,3) 
                   tt-logradouro-lote.titulo-ofi-log = SUBSTRING(c-linha,289,72)
                 /*tt-logradouro-lote.log-cep        = INTEGER(SUBSTRING(c-linha,361,6))     
                   tt-logradouro-lote.log-dne        = INTEGER(SUBSTRING(c-linha,367,8))*/
                   tt-logradouro-lote.nome-ofi-log   = SUBSTRING(c-linha,375,72)
                   tt-logradouro-lote.abrev-log      = SUBSTRING(c-linha,447,36)
                   tt-logradouro-lote.inf-adicio     = SUBSTRING(c-linha,483,36)
                   tt-logradouro-lote.cep-log        = SUBSTRING(c-linha,519,8) 
                   tt-logradouro-lote.log-gran-usuar = SUBSTRING(c-linha,527,1) 
                   tt-logradouro-lote.nr-lote-dne    = SUBSTRING(c-linha,528,11)
                   tt-logradouro-lote.lote-dne       = SUBSTRING(c-linha,539,8)
                   .
        END.
    END.
    INPUT STREAM s-imp CLOSE.
END.

PROCEDURE pi-atualiza-ibge:

    IF AVAIL cep THEN DO:
    
        /* Busca cidade */
        FIND FIRST mgcad.cidade WHERE
            cidade.estado  = cep.uf  AND 
            cidade.cidade  = cep.localidade NO-LOCK NO-ERROR.
    
        /* Se encontrar a cidade atualiza o c¢digo do ibge */
        IF AVAIL cidade THEN DO:
    
            ASSIGN cep.ibge = cidade.cdn-munpio-ibge.
    
        END.
        ELSE DO: /* Se n∆o encontrar cidade cria cadastro novo de cidades */
    
            IF NOT CAN-FIND(FIRST cidade-diverg 
                            WHERE cidade-diverg.cidade = cep.localidade 
                              AND cidade-diverg.estado = cep.uf NO-LOCK) THEN DO:

                CREATE cidade-diverg.
                ASSIGN cidade-diverg.cidade = cep.localidade
                       cidade-diverg.estado = cep.uf.
                        
            END.

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.
