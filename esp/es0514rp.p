/*****************************************************************************
** Programa..............: esp/es0514rp.p
** Descri‡Æo.............: Exporta‡Æo seguran‡a or‡amento.
** Autor.................: Andrey M Oliveira
** Criado em.............: 24/10/2019
*****************************************************************************/
{include/i-prgvrs.i es0514rp 1.00.00.000}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

{include/i-rpvar.i}
{esp/esb/esesb000.i}

DEF STREAM s_arqexport.
DEF STREAM s_arqrelat.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar 
    AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

DEF VAR v_cod_usuar_corren AS CHAR               NO-UNDO.
DEF VAR c-msg              AS CHAR FORMAT "x(7)" NO-UNDO.
DEF VAR h-acomp            AS HANDLE             NO-UNDO.
DEF VAR raw-tit-acr        AS RAW                NO-UNDO.
DEF VAR v_nom_usuario      AS CHAR               NO-UNDO.
DEF VAR v_des_ccusto       AS CHAR               NO-UNDO.

EMPTY TEMP-TABLE tt-param.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

{include/i-rpout.i}

PUT UNFORMATTED "Usu rio;Nome;CCusto;Descri‡Æo;Empresa;Estab;UN" SKIP.

FOR EACH usu-cc-un-orc NO-LOCK:

    RUN pi-acompanhar IN h-acomp (INPUT "Exportando seguran‡a or‡amento ...").

    FIND usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = usu-cc-un-orc.cod-usuario NO-ERROR.
    IF AVAIL usuar_mestre 
       THEN ASSIGN v_nom_usuario = usuar_mestre.nom_usuario.
       ELSE ASSIGN v_nom_usuario = "NÆo Localizado".

    FIND emscad.ccusto NO-LOCK
        WHERE emscad.ccusto.cod_empresa      = usu-cc-un-orc.cod-empresa
          AND emscad.ccusto.cod_plano_ccusto = "padrao"
          AND emscad.ccusto.cod_ccusto       = usu-cc-un-orc.cod-ccusto NO-ERROR.

    IF AVAIL emscad.ccusto 
       THEN ASSIGN v_des_ccusto = emscad.ccusto.des_tit_ctbl.
       ELSE IF usu-cc-un-orc.cod-ccusto = "*"
            THEN ASSIGN v_des_ccusto = "Todos".
            ELSE ASSIGN v_des_ccusto = "NÆo Localizado".

    PUT UNFORMATTED usu-cc-un-orc.cod-usuario ";" v_nom_usuario ";" usu-cc-un-orc.cod-ccusto ";" v_des_ccusto ";" usu-cc-un-orc.cod-empresa ";" usu-cc-un-orc.cod-estab ";" usu-cc-un-orc.cod-unid-negoc SKIP.
END.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK".
