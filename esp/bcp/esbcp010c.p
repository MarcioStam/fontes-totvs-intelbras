/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9030C 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9030c MBC}
&ENDIF

/**********************************************************************************
**     Programa...: bc9030c.p
**
**     Finalidade.: Pre-api de transferencia entre depositos com WMS
**
**     Criado em..: Abril/2005
**
**     Versao.....: 2.00.00.000 Marcelo Dumke
**********************************************************************************/
{bcp/bc9030.i}   /* Defini»’o da temp-table de transferencia do coleta de dados  */
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
/*********************************************************************************/

/*********************************************************************************/
Do:
    Find Last Param-BC No-lock No-error.

    If  Not AvailAble Param-BC Then Return 'NOK'.

    &if '{&mgcld_version}' <= '2.04' &then
        Assign vNumProduto = Param-BC.int-2.
    &else
        Assign vNumProduto = Param-BC.ind-sistema.
    &endif

    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'esp/bcp/esbcp010d.p'.
    
    End. /* Case */

    Create tt-transfer-serial-wms.
    Raw-Transfer pRawConteudo to tt-transfer-serial-wms.

    _AddField('cod-usuario'                    , String(tt-transfer-serial-wms.cod-usuario)                  , 'Character').
    _AddField('cod-coletor'                    , String(tt-transfer-serial-wms.cod-coletor)                  , 'Character').
    _AddField('cod-equipamento'                , String(tt-transfer-serial-wms.cod-equipamento)              , 'Character').
    _AddField('cod-serial'                     , String(tt-transfer-serial-wms.cod-serial)                   , 'Decimal  ').
    _AddField('cod-depos-orig'                 , String(tt-transfer-serial-wms.cod-depos-orig)               , 'Character').
    _AddField('cod-local-orig'                 , String(tt-transfer-serial-wms.cod-local-orig)               , 'Character').
    _AddField('cod-depos-dest'                 , String(tt-transfer-serial-wms.cod-depos-dest)               , 'Character').
    _AddField('cod-local-dest'                 , String(tt-transfer-serial-wms.cod-local-dest)               , 'Character').
    _AddField('tipo-equipamento'               , String(tt-transfer-serial-wms.tipo-equipamento)             , 'Integer  ').
    _AddField('cod-item'                       , String(tt-transfer-serial-wms.cod-item)                     , 'Character').
    _AddField('qtd-item'                       , String(tt-transfer-serial-wms.qtd-item)                     , 'Decimal  ').
    _AddField('data-atualizacao'               , String(tt-transfer-serial-wms.data-atualizacao)             , 'Date     ').
    _AddField('data-transacao'                 , String(tt-transfer-serial-wms.data-transacao)               , 'Date     ').
    _AddField('cod-lote'                       , String(tt-transfer-serial-wms.cod-lote)                     , 'character').
    _AddField('num-docto-transf'               , String(tt-transfer-serial-wms.num-docto-transf)             , 'Integer').
    _AddField('cod-estabel'                    , String(tt-transfer-serial-wms.cod-estabel)                  , 'Character').
    _AddField('cod-livre-1'                    , String(tt-transfer-serial-wms.cod-livre-1)                  , 'Character').
    _AddField('cod-livre-2'                    , String(tt-transfer-serial-wms.cod-livre-2)                  , 'Character').
    _AddField('cod-livre-3'                    , String(tt-transfer-serial-wms.cod-livre-3)                  , 'Character').
    _AddField('cod-livre-4'                    , String(tt-transfer-serial-wms.cod-livre-4)                  , 'Character').
    _AddField('cod-livre-5'                    , String(tt-transfer-serial-wms.cod-livre-5)                  , 'Character').
    _AddField('num-livre-1'                    , String(tt-transfer-serial-wms.num-livre-1)                  , 'Integer  ').
    _AddField('num-livre-2'                    , String(tt-transfer-serial-wms.num-livre-2)                  , 'Integer  ').
    _AddField('num-livre-3'                    , String(tt-transfer-serial-wms.num-livre-3)                  , 'Integer  ').
    _AddField('num-livre-4'                    , String(tt-transfer-serial-wms.num-livre-4)                  , 'Integer  ').
    _AddField('num-livre-5'                    , String(tt-transfer-serial-wms.num-livre-5)                  , 'Integer  ').
    _AddField('dec-livre-1'                    , String(tt-transfer-serial-wms.dec-livre-1)                  , 'Decimal  ').
    _AddField('dec-livre-2'                    , String(tt-transfer-serial-wms.dec-livre-2)                  , 'Decimal  ').
    _AddField('dec-livre-3'                    , String(tt-transfer-serial-wms.dec-livre-3)                  , 'Decimal  ').
    _AddField('dec-livre-4'                    , String(tt-transfer-serial-wms.dec-livre-4)                  , 'Decimal  ').
    _AddField('dec-livre-5'                    , String(tt-transfer-serial-wms.dec-livre-5)                  , 'Decimal  ').
    _AddField('log-livre-1'                    , String(tt-transfer-serial-wms.log-livre-1)                  , 'Logical  ').
    _AddField('log-livre-2'                    , String(tt-transfer-serial-wms.log-livre-2)                  , 'Logical  ').
    _AddField('log-livre-3'                    , String(tt-transfer-serial-wms.log-livre-3)                  , 'Logical  ').
    _AddField('log-livre-4'                    , String(tt-transfer-serial-wms.log-livre-4)                  , 'Logical  ').
    _AddField('log-livre-5'                    , String(tt-transfer-serial-wms.log-livre-5)                  , 'Logical  ').
    _AddField('dat-livre-1'                    , String(tt-transfer-serial-wms.dat-livre-1)                  , 'Date     ').
    _AddField('dat-livre-2'                    , String(tt-transfer-serial-wms.dat-livre-2)                  , 'Date     ').
    _AddField('dat-livre-3'                    , String(tt-transfer-serial-wms.dat-livre-3)                  , 'Date     ').
    _AddField('dat-livre-4'                    , String(tt-transfer-serial-wms.dat-livre-4)                  , 'Date     ').
    _AddField('dat-livre-5'                    , String(tt-transfer-serial-wms.dat-livre-5)                  , 'Date     ').
    _AddField('opcao'                          , String(tt-transfer-serial-wms.opcao)                        , 'INTEGER  ').
    
    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/***********************************************************************************************************/

