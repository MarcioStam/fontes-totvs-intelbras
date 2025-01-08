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
**  Programa.: esp/utp/esutp048.i
**  Objetivo.: Importa‡Æo usu rio fidelidade (Defini‡Æo das Temp-Tables tt-param,
**             tt-digits e tt-raw-digita) - Fabiano Sakae Ribeiro (SQL Works).
**  Cria‡Æo..: 22/06/2010
**
*******************************************************************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as character format "x(35)":U
    field usuario          as character format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as character format "x(40)":U
    field modelo           as character format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as logical
    /*Fim alteracao 15/02/2005*/
    field todos            as integer
    field arq-entrada      as character
    field arq-destino      as character.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define buffer b-tt-digita for tt-digita.
