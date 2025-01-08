/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018C 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9018C MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9018c                                                                   **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karla - Cria‡Æo do programa                  **
**                                                                                         **
**   Finalidade: Pre-api de Picking WMs                                                    ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter pRawConteudo as raw     No-undo.
Define Input-Output Parameter Table        For tt-erro.
/*********************************************************************************/

/*********************************************************************************/
Define Variable vNumProduto         As Integer              No-undo.
Define Variable vAdapterProgram     As Character            No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
Do:
    Find Last Param-BC No-lock No-error.

    If  Not AvailAble Param-BC Then Return 'NOK'.

    &if '{&mgcld_version}' >= '2.04':U &then
        ASSIGN vNumProduto = param-bc.ind-sistema.
    &else 
        Assign vNumProduto = Param-BC.int-2.   
    &endif

    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9018d.p':U.
    End. /* Case */

    FIND FIRST bc-trans WHERE bc-trans.nr-trans = pnumtrans NO-LOCK NO-ERROR.
    IF AVAILABLE bc-trans THEN DO:                                                                                                               
        _AddField('cd-trans              ':U, String(bc-trans.cd-trans                ),  'character ':U).
        _AddField('nr-trans              ':U, String(bc-trans.Nr-trans                ),  'decimal   ':U).
        _AddField('data                  ':U, String(bc-trans.data                    ),  'date      ':U).
        _AddField('detalhe               ':U, String(bc-trans.detalhe                 ),  'character ':U).
        _AddField('ep-codigo             ':U, String(bc-trans.ep-codigo               ),  'integer   ':U).
        _AddField('estado-trans          ':U, String(bc-trans.estado-trans            ),  'integer   ':U).
        _AddField('horario               ':U, String(bc-trans.horario                 ),  'character ':U).
        _AddField('usuario               ':U, String(bc-trans.usuario                 ),  'character ':U).
        _AddField('ind-tipo-trans        ':U, String(bc-trans.ind-tipo-trans          ),  'integer   ':U).
        _AddField('des-observacao        ':U, String(bc-trans.des-observacao          ),  'character ':U).
    END.

    bc9018:
    DO on error  undo bc9018, leave bc9018
       on quit   undo bc9018, leave bc9018
       on stop   undo bc9018, leave bc9018
       on endkey undo bc9018, leave bc9018:
       Run Value(vAdapterProgram) (Input               pNumTrans,
                                   Input        Table  ttIntegracao,
                                   Input-Output Table  tt-erro) NO-ERROR.
    END.

    if error-status:error = YES then do:
        ASSIGN vsequencia = 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_de_execu‡Æo_da_PRE-API" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    end. /* if */ 

End. /* Do Main */

