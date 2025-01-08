/*****************************************************************
** 
** Programa: BTAPI523.i
** 
** Objetivo: Defini‡Æo das fun‡äes de param-global
**
** Data    : Agosto de 1998
**
*****************************************************************/
DEFINE VARIABLE {1} as handle.

FUNCTION empresa    RETURNS integer   in {1}.
FUNCTION grupo      RETURNS character in {1}.
FUNCTION serv-mail  RETURNS character in {1}.
FUNCTION porta-mail RETURNS integer   in {1}.
FUNCTION ms-serv    RETURNS logical   in {1}.
FUNCTION modulo-mp  RETURNS logical   in {1}.
FUNCTION sc-format  RETURNS character in {1}.
FUNCTION ct-format  RETURNS character in {1}.
