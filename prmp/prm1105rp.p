{include/i-prgvrs.i prm1105rp 2.00.00.000}
{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i} /*tt-erro*/
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field arquivo-etiqueta AS CHAR.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD c-linha         AS CHAR
    FIELD linha           AS INTEGER.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Lendo...":U).

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Especificos Intelbras"
       c-titulo-relat = "Imprime etiqueta ZPL"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "PRM1105"
       c-versao       = "2.04"
       c-revisao      = "000".

FIND FIRST tt-param NO-ERROR.

INPUT FROM VALUE(tt-param.arquivo-etiqueta) NO-ECHO.
REPEAT:
    IMPORT UNFORMATTED c-linha.

    ASSIGN i-cont = i-cont + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

    CREATE tt-dados.
    ASSIGN tt-dados.c-linha       = c-linha
           tt-dados.linha         = i-cont.
END.
INPUT CLOSE.

ASSIGN i-cont = i-cont + 1.
CREATE tt-dados.
ASSIGN tt-dados.c-linha       = "^XZ"
       tt-dados.linha         = i-cont.

/* ***************************  Main Block  *************************** */
DO on stop undo, leave: 
    
    {include/i-rpout.i}

   /* Coloquei estas linhas no programa - Clayton Antunes */
   DEF VAR i-nome-programa AS CHAR.
   DEF VAR i-ponto AS INT.
   DEF VAR i-sequencia AS INT.
   DEF VAR i-conteudo AS CHAR.

   RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo etiqueta").

   FOR EACH tt-dados:
       PUT UNFORMATTED 
           tt-dados.c-linha SKIP.
   END.

   {include/i-rpclo.i}

END. 

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

RETURN "OK".
