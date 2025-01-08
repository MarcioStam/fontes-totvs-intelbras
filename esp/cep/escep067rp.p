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
**  Programa.: esp/cep/escep067rp.p
**  Objetivo.: Atualizar campo Necessita Inspe‡Æo Origem
**  Cria»’o..: 21/01/2013 - Maicon Correa - Sensus Tecnologia
**
*******************************************************************************/
{include/i-prgvrs.i ESCEP067RP 2.00.00.002}

{utp/ut-glob.i}
{include/i-rpvar.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.

DEFINE VARIABLE h-esapi017 AS HANDLE      NO-UNDO.


{cdp/cd0666.i} /* defini»’o da temp-table de erros */   
{method/dbotterr.i}       

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Atualiza‡Æo - Necessita Inspe‡Æo Origem":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESCEP067":U
       c-versao       = "2.00.00":U
       c-revisao      = "000":U.
       
FORM SKIP(1)
     "IMPRESS€O":U AT 13 SKIP(1)
     tt-param.arquivo        FORMAT "x(80)":U      LABEL "Destino":U          COLON 40 SKIP
     tt-param.usuario        FORMAT "x(12)":U      LABEL "Usuÿrio":U          COLON 40 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.



RUN esapi/esapi017.p PERSISTENT SET h-esapi017.
RUN pi-atualiza IN h-esapi017.
DELETE PROCEDURE h-esapi017.
ASSIGN h-esapi017 = ?.




PAGE.
DISPLAY tt-param.arquivo 
        tt-param.usuario 
    WITH FRAME f-impressao.

{include/i-rpclo.i}

RETURN "OK":U.


