/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP016D 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESBCP016d MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9020d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Criaá∆o do programa                 **
**                                                                                         **
**   Finalidade: Adapter da transacao de Ressuprimento WMS                                 ** 
**                                                                                         **
********************************************************************************************/
{esp/bcp/esbcp016.i}
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
/**********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans   as integer No-undo.
DEFINE Input        PARAMETER p-rBoxMovto AS ROWID  NO-UNDO.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.

/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg":U,
                            input 25346,
                            input "bc9003d":U).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value).
        Return 'NOK':U.
    End.

    Create tt-ressup-wms.
    Assign tt-ressup-wms.cod-usuario      = _RetornaValChar('cod-usuario     ':U).
           tt-ressup-wms.cod-coletor      = _RetornaValChar('cod-coletor     ':U).
           tt-ressup-wms.cod-estabel      = _RetornaValChar('cod-estabel     ':U).
           tt-ressup-wms.cod-local        = _RetornaValChar('cod-local       ':U).
           tt-ressup-wms.des-endereco     = _RetornaValChar('des-endereco    ':U).
           tt-ressup-wms.num-documento    = _RetornaValDeci('num-documento   ':U).
           tt-ressup-wms.num-movimento    = _RetornaValDeci('num-movimento   ':U).
           tt-ressup-wms.num-seq-item     = _RetornaValInte('num-seq-item    ':U).
           tt-ressup-wms.num-box          = _RetornaValInte('num-box         ':U).
           tt-ressup-wms.num-tempo-inicio = _RetornaValDeci('num-tempo-inicio':U).
           tt-ressup-wms.cod-equipamento  = _RetornaValChar('cod-equipamento ':U).
           tt-ressup-wms.cod-item         = _RetornaValChar('cod-item        ':U).
           tt-ressup-wms.qtd-item         = _RetornaValDeci('qtd-item        ':U).
           tt-ressup-wms.qtd-item-digit   = _RetornaValDeci('qtd-item-digit  ':U).
           tt-ressup-wms.num-box-orig     = _RetornaValInte('num-box-orig    ':U).
           tt-ressup-wms.num-box-lido     = _RetornaValInte('num-box-lido    ':U).
           tt-ressup-wms.cod-embalagem    = _RetornaValChar('cod-embalagem   ':U).
           tt-ressup-wms.qtd-embalagem    = _RetornaValDeci('qtd-embalagem   ':U).
           tt-ressup-wms.qtd-embal-lidas  = _RetornaValDeci('qtd-embal-lidas ':U).
           tt-ressup-wms.des-seriais      = _RetornaValChar('des-seriais     ':U).
           tt-ressup-wms.num-serial       = _RetornaValDeci('num-serial      ':U).
           tt-ressup-wms.dat-atualizacao  = _RetornaValData('dat-atualizacao ':U).
           tt-ressup-wms.dat-transacao    = _RetornaValData('dat-transacao   ':U).
           tt-ressup-wms.des-qtdseriais   = _RetornaValChar('des-qtdseriais  ':U).

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK":U.

    Raw-Transfer tt-ressup-wms To vRaw.

    Run 'esp/bcp/esbcpapi016.p':U (Input        pNumTrans,
                                   Input        vRaw,
                                   INPUT        p-rBoxMovto,
                                   Input-Output Table tt-erro).
End. /* Do: Main */
