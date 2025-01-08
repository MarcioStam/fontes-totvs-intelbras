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
**  Programa.: esp/rep/esrep030.i
**  Objetivo.: Gerar Relat¢rios de Importa‡Æo (Defini‡Æo de Temp-Tables).
**  Cria‡Æo..: 03/05/2010
**
*******************************************************************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(80)":U
    field arquivo-csv      as char format "x(80)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field estabel-ini      as char format "x(03)":U
    field estabel-fim      as char format "x(03)":U
    FIELD embarque-ini     AS CHAR FORMAT "x(12)"
    FIELD embarque-fim     AS CHAR FORMAT "x(12)"
    field emitente-ini     as int  format ">>>>>>>>9":U
    field emitente-fim     as int  format ">>>>>>>>9":U
    field dt-trans-ini     as date format "99/99/9999":U
    field dt-trans-fim     as date format "99/99/9999":U
    field awb              as log
    field di               as log
    field dt-emb-ent       as log
    field fat-ci-swift     as log
    FIELD despesas         AS LOG
    field itinerario       as log
    FIELD narrativa-emb    AS LOG
    FIELD transportador    AS LOG
    FIELD peso-embarque    AS LOG
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/
 
 define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
 
 define temp-table tt-raw-digita
    field raw-digita       as raw.
