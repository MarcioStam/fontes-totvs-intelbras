/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
/*
M‚todo de Acesso    : Buscar_DadosGrCliente
Parƒmetro de Entrada: C¢digo Grupo Cliente - gr-cli
Parƒmetros de Sa¡da :   
*/

DEF TEMP-TABLE ttRetornoGrupo NO-UNDO
   FIELD cod-rep    AS INTEGER
   FIELD desc-rep   AS CHARACTER.

  DEFINE INPUT  PARAMETER piGrCli  AS integer   NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR ttRetornoGrupo.

  FIND gr-cli WHERE 
       gr-cli.cod-gr-cli = piGrCli NO-LOCK NO-ERROR.
  CREATE ttRetornoGrupo.      /* Cria temp-table mesmo nao existindo o registro para nao dar erro no CRM */
  IF NOT AVAIL gr-cli THEN DO:
      RETURN "OK".
  END.
  
  ASSIGN ttRetornoGrupo.cod-rep    = gr-cli.cod-rep.

  FIND FIRST repres NO-LOCK WHERE
             repres.cod-rep = gr-cli.cod-rep NO-ERROR.
  IF AVAIL repres THEN
  ASSIGN ttRetornoGrupo.desc-rep = repres.nome.

  RETURN "OK".
