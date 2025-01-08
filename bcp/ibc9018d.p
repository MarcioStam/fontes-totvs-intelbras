/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9018D MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************************
**   Programa..: bc9018d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karla - Cria‡Æo do programa                  **
**                                                                                         **
**   Finalidade: Adapter da transacao de Picking WMs                                       ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
{bcp/bc9016.i}     /* Definicao da temp-table de transferencia do coleta de dados */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/
Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg":U,
                            input 25346,
                            input "bc9003d").
        Create  tt-erro.
  
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.i-sequen = vsequencia
                tt-erro.mensagem = trim(return-value).
        Return 'NOK'.
    End.
    
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK":U.
    ASSIGN error-status:ERROR = NO.
    bc9018:
    DO on error  undo bc9018, leave bc9018
       on quit   undo bc9018, leave bc9018
       on stop   undo bc9018, leave bc9018
       on endkey undo bc9018, leave bc9018:
       
       Run 'bcp/bcapi9018.p':U (Input              pNumTrans,
                                INPUT        TABLE ttIntegracao,
                                Input-Output Table tt-erro) NO-ERROR .
    
    END.
    
    if error-status:error = YES OR RETURN-VALUE <> 'OK':U then do:
        ASSIGN vsequencia =  vsequencia + 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API(bcapi9018)" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    END.
End. /* Do: Main */

