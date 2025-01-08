/********************************************************************************
***
***
***
*******************************************************************************/
{include/i-prgvrs.i escpp102rp 2.00.00.000 } /*** 010000 ***/

/*******************************************************************************
***
***
***
*********************************************************************************/
define temp-table tt-param no-undo
    field destino          as INTEGER
    field arquivo          as char format "x(35)":U
    field arq-anexo        as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD arq-importa      AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita as raw.

DEFINE TEMP-TABLE tt-mac NO-UNDO
    FIELD id                AS CHARACTER
    FIELD chave             AS CHARACTER
    FIELD mac               AS CHARACTER
    FIELD po                AS INTEGER
    FIELD linha             AS INTEGER.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD linha             AS INTEGER
    FIELD desc-erro         AS CHARACTER.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp      AS HANDLE             NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-sucesso    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-hora       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-data       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-usuar      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-texto-mail AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i-linha      AS INTEGER            NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
FIND FIRST tt-param NO-LOCK NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FORM "ERROS DE IMPORTAÄ«O:" SKIP
     "====================" SKIP
    WITH FRAME f-cab-erro WIDTH 132 STREAM-IO DOWN.

FORM "Importaá∆o com sucesso:" SKIP
     "=======================" SKIP
    WITH FRAME f-cab-sucesso WIDTH 132 STREAM-IO DOWN.

FORM c-texto-mail              SKIP
     "=======================" SKIP
    WITH FRAME f-cab-sucesso-mail WIDTH 132.

FORM tt-erro.linha             FORMAT "zzzzzz9" COLUMN-LABEL "Linha"            
     tt-erro.desc-erro         FORMAT "X(109)" COLUMN-LABEL "Erro de Importaá∆o"
    WITH FRAME f-erro WIDTH 132 STREAM-IO DOWN.

FORM tt-mac.id       FORMAT "X(15)"       COLUMN-LABEL "ID"
     tt-mac.chave    FORMAT "X(20)"       COLUMN-LABEL "Chave"
     tt-mac.mac      FORMAT "X(30)"       COLUMN-LABEL "MAC"
     tt-mac.po       FORMAT "zzzzz9"      COLUMN-LABEL "PO"
     WITH FRAME f-mac WIDTH 132 STREAM-IO DOWN.
   
/** DefiniØ¥es de variòveis e frames padr¥es **/ 
{include/i-rpvar.i}

{utp/ut-liter.i Importador_ID_Chave escpp}
ASSIGN c-programa     = "ESCPP102":U
       c-versao       = "00"
       c-revisao      = "000"
       c-titulo-relat = RETURN-VALUE.

FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN
        ASSIGN c-empresa = param-global.grupo.

{include/i-rpcab.i}                 
{include/i-rpout.i} 

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gerando Despesas").

ASSIGN i-linha = 0.

INPUT FROM VALUE(tt-param.arq-importa).
REPEAT:
    CREATE tt-mac.
    IMPORT DELIMITER ";" tt-mac  NO-ERROR.

    ASSIGN i-linha = i-linha + 1.

    ASSIGN tt-mac.linha = i-linha.

    RUN pi-acompanhar IN h-acomp (INPUT "PO: " + string(tt-mac.po) + "/MAC: " + tt-mac.mac).
END.
INPUT CLOSE.

RUN pi-seta-titulo IN h-acomp (INPUT "Validando/Criando Importaá∆o").

ASSIGN l-erro = NO.

FOR EACH tt-mac NO-LOCK.

    RUN pi-acompanhar IN h-acomp (INPUT "Atualizando MAC Address...").

    IF tt-mac.po = 0 THEN NEXT.

    IF tt-mac.id = "" 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "ID n∆o informado!"
               l-erro              = YES.
        NEXT.
    END.

    IF tt-mac.chave = "" 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "Chave n∆o informada!"
               l-erro              = YES.
        NEXT.
    END.

    IF tt-mac.mac = "" 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "MAC n∆o informado!"
               l-erro              = YES.
        NEXT.
    END.

    FIND FIRST mac-address WHERE
               mac-address.mac = tt-mac.mac
               EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL mac-address 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "Mac Address (" + STRING(tt-mac.mac) + ") n∆o cadastrado!"
               l-erro              = YES.
        NEXT.
    END.

    IF mac-address.num-pedido <> tt-mac.po 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "Mac Address (" + STRING(tt-mac.mac) + ") n∆o vinculado ao PO (" + STRING(tt-mac.po) + ")"
               l-erro              = YES.
        NEXT.
    END.

    IF CAN-FIND(FIRST mac-address USE-INDEX ch-acesso WHERE
                      mac-address.id        = tt-mac.id) /* AND
                      mac-address.ch-acesso = tt-mac.chave) */

    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "ID (" + STRING(tt-mac.id) + ") j† vinculado ao MAC (" + STRING(tt-mac.mac) + ")"
               l-erro              = YES.
        NEXT.
    END.

    FIND FIRST num-serie USE-INDEX ch-acesso WHERE
               num-serie.ID = tt-mac.id
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.linha       = tt-mac.linha
               tt-erro.desc-erro   = "ID (" + STRING(tt-mac.id) + ") j† vinculado ao n£mero de sÇrie (" + STRING(num-serie.n-serie) + ")"
               l-erro              = YES.
        NEXT.
    END.
  /*  ler num-serie validando se foi impresso em algum momento. */

    RUN pi-acompanhar IN h-acomp (INPUT "Atualizando MAC Address: " + STRING(tt-mac.mac)).

    IF AVAIL mac-address 
    THEN DO:
        ASSIGN mac-address.id        = tt-mac.id
               mac-address.ch-acesso = tt-mac.chave.
        RELEASE mac-address.
    END.

    DISP tt-mac.id   
         tt-mac.chave
         tt-mac.mac  
         tt-mac.po   
         WITH FRAME f-mac WIDTH 132 STREAM-IO DOWN.
    DOWN WITH FRAME f-mac.

END.

FOR EACH tt-erro:
    DISP tt-erro.linha 
         tt-erro.desc-erro
        WITH FRAME f-erro WIDTH 132 STREAM-IO DOWN.
    DOWN WITH FRAME f-erro.
END.

RUN pi-finalizar IN h-acomp.

ASSIGN h-acomp = ?.

{include/i-rpclo.i} 

RETURN "OK":U.
