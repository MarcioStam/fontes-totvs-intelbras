/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCPAPI016 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESBCPAPI016 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9020.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Criaá∆o do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Ressuprimento WMS                                    **                                                                                         
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{esp/bcp/esbcp016.i}
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter pRaw         As Raw       No-undo.
Define Input        PARAMETER p-rBoxMovto  AS ROWID     NO-UNDO.
Define Input-Output Parameter Table For tt-erro.
/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)" No-undo.
Define                   Variable wgbosc096                     As Widget-handle            No-undo.      
Define                   Variable vNumCont                      As Integer         Init 0   No-undo.
Define                   Variable v-cod-estabel                 As Character                No-undo.
Define                   Variable v-cod-local                   As Character                No-undo.
Define                   Variable vDesSeriais                   As Character                No-undo.
/*****************************************************************************/

/*****************************************************************************/
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.
/*****************************************************************************/

DEFINE TEMP-TABLE tt-serial NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado         
            INDEX idx-serial  AS PRIMARY UNIQUE
                  id-etiqueta.

DEFINE TEMP-TABLE tt-leitura-transfer NO-UNDO
       		FIELD id-docto              LIKE wm-docto-itens.id-docto
           	FIELD num-seq-item          LIKE wm-docto-itens.num-seq-item
           	FIELD ind-tipo-movto        LIKE wm-box-movto.ind-tipo-movto
           	FIELD id-movto              LIKE wm-box-movto.id-movto           
           	FIELD id-box-saida          LIKE wm-box-movto.id-box
           	FIELD id-box-entrada        LIKE wm-box-movto.id-box            
           	FIELD cod-item-lido         LIKE wm-docto-itens.cod-item
           	FIELD qtd-item-lido         LIKE wm-docto-itens.qtd-item
           	FIELD cod-embalagem-lido    LIKE wm-box-movto.cod-embalagem
           	FIELD qti-embalagem-lido    LIKE wm-box-movto.qti-embalagem
           	FIELD qtd-item-picking      LIKE wm-box-movto.qtd-item-picking.        

DEF TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD CodUsuario     LIKE wm-tarefa-docto-itens.cod-usuario     
    FIELD CodEquipamento LIKE wm-tarefa-docto-itens.cod-equipamento 
    FIELD CodColetor     LIKE wm-tarefa-docto-itens.cod-coletor     
    FIELD TempoInicio    AS INTEGER.

Define Temp-table tt-box-movto NO-UNDO Like wm-box-movto.

DEFINE TEMP-TABLE tt-etiqueta NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item    LIKE wm-etiqueta.qtd-item
            INDEX codigo IS UNIQUE id-etiqueta.

DEFINE BUFFER bf-box-movto FOR wm-box-movto.
DEFINE VARIABLE i-id-movto LIKE wm-box-movto.id-movto  NO-UNDO.

/* Inicializacao dos objetos ativos ---                     */ 
Run scbo/bosc096.p Persistent Set wgbosc096.
Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.

/************************************************************/

BC9020:
DO TRANSACTION on ERROR  undo BC9020, leave BC9020
               on quit   undo BC9020, leave BC9020
               on stop   undo BC9020, leave BC9020
               on endkey undo BC9020, leave BC9020:

    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "esbcp016"
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = c-seg-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    Find First tt-prog-bc   No-error.
    Find First tt-erro      No-error.

    If  Available tt-erro Then Do:
        Create  tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_Trans" *}
        Assign  tt-erro.i-sequen    = 1
                tt-erro.cd-erro     = 1
                tt-erro.mensagem    = RETURN-VALUE.
        Run deleteObjects.
        UNDO BC9020, Return 'NOK':U.
    End. /* If  Available tt-erro */

    EMPTY TEMP-TABLE tt-ressup-wms.
    EMPTY TEMP-TABLE tt-leitura-transfer.
    EMPTY TEMP-TABLE tt-box-movto.
    EMPTY TEMP-TABLE tt-tarefa-docto.
    EMPTY TEMP-TABLE tt-serial.
    EMPTY TEMP-TABLE tt-etiqueta.

    FOR FIRST wm-box-movto NO-LOCK
        WHERE ROWID(wm-box-movto) = p-rBoxMovto:
        ASSIGN i-id-movto = wm-box-movto.id-movto
               v-cod-estabel = wm-box-movto.cod-estabel
               v-cod-local   = wm-box-movto.cod-local.
    END.

    Create tt-ressup-wms.
    Raw-Transfer pRaw To tt-ressup-wms.

    Find First tt-ressup-wms No-error.
    
    /* Valida se o usuario informado na transacao esta cadastrado no ems */
    If  Connected('mguni':U) Then Do:
        {bcp/bc9017.i1 tt-ressup-wms.cod-usuario}
        If  vLogOk = No Then do:
            Create tt-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usuario" *}
            ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "nao_cadastrado_no_Datasul-EMS" *}
            ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
            Assign tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 1
                   tt-erro.mensagem = c-lbl-liter-usuario + ' ' + tt-ressup-wms.cod-usuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
            Run deleteObjects.
            UNDO BC9020, Return 'NOK':U.
        End.
    END.
    
    Create tt-leitura-transfer.
    Assign tt-leitura-transfer.id-docto                  = tt-ressup-wms.num-documento
           tt-leitura-transfer.num-seq-item              = tt-ressup-wms.num-seq-item
           tt-leitura-transfer.ind-tipo-movto            = 2
           tt-leitura-transfer.id-movto                  = tt-ressup-wms.num-movimento
           tt-leitura-transfer.id-box-saida              = tt-ressup-wms.num-box-orig
           tt-leitura-transfer.id-box-entrada            = tt-ressup-wms.num-box-lido
           tt-leitura-transfer.cod-item-lido             = tt-ressup-wms.cod-item 
           tt-leitura-transfer.qtd-item-lido             = tt-ressup-wms.qtd-item           
           tt-leitura-transfer.cod-embalagem-lido        = tt-ressup-wms.cod-embalagem                 
           tt-leitura-transfer.qti-embalagem-lido        = tt-ressup-wms.qtd-embal-lidas.                      
    
    Create tt-box-movto.
    Assign tt-box-movto.cod-embalagem           = tt-ressup-wms.cod-embalagem
           tt-box-movto.cod-estabel             = tt-ressup-wms.cod-estabel
           tt-box-movto.cod-local               = tt-ressup-wms.cod-local
           tt-box-movto.dt-atualizacao          = tt-ressup-wms.dat-atualizacao
           tt-box-movto.dt-transacao            = tt-ressup-wms.dat-transacao
           tt-box-movto.id-box                  = tt-ressup-wms.num-box-orig
           tt-box-movto.id-docto                = tt-ressup-wms.num-documento
           tt-box-movto.id-movto                = tt-ressup-wms.num-movimento
           tt-box-movto.ind-status-movto        = 1
           tt-box-movto.ind-tipo-movto          = 2
           tt-box-movto.log-atualizado-coletor  = Yes
           tt-box-movto.num-seq-item            = tt-ressup-wms.num-seq-item
           tt-box-movto.qtd-item                = tt-ressup-wms.qtd-item
           tt-box-movto.qtd-item-orig           = tt-ressup-wms.qtd-item     
           tt-box-movto.qti-embalagem           = tt-ressup-wms.qtd-embal-lidas.

    Create tt-tarefa-docto.
    Assign tt-tarefa-docto.CodUsuario           = tt-ressup-wms.cod-usuario
           tt-tarefa-docto.CodEquipamento       = tt-ressup-wms.cod-equipamento
           tt-tarefa-docto.CodColetor           = tt-ressup-wms.cod-coletor
           tt-tarefa-docto.TempoInicio          = tt-ressup-wms.num-tempo-inicio.
    
    b-ser:
    Do  vNumCont = 1 To Num-entries(tt-ressup-wms.des-seriais,';':U).
        If Dec(Entry(vNumCont,tt-ressup-wms.des-seriais,';':U)) = 0 Then Next b-ser.
        Create tt-serial.
        Assign tt-serial.id-etiqueta       = Dec(Entry(vNumCont,tt-ressup-wms.des-seriais,';':U)).
               tt-serial.qtd-item-retirado = DEC(ENTRY(vNumCont,tt-ressup-wms.des-qtdseriais,';':U)).
    End.
    
    IF NOT CAN-FIND(FIRST tt-serial) THEN DO:
        CREATE tt-serial.
        ASSIGN tt-serial.id-etiqueta       = tt-ressup-wms.num-serial
               tt-serial.qtd-item-retirado = tt-ressup-wms.qtd-item-digit.
    END.

    FOR EACH tt-serial:
        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.id-etiqueta = tt-serial.id-etiqueta
               tt-etiqueta.qtd-item    = tt-serial.qtd-item-retirado.
    END.

/*     FOR EACH bf-box-movto EXCLUSIVE-LOCK                                                                      */
/*         WHERE bf-box-movto.cod-estabel = wm-box-movto.cod-estabel                                             */
/*           AND bf-box-movto.cod-local   = wm-box-movto.cod-local                                               */
/*           AND bf-box-movto.id-movto    = wm-box-movto.id-movto:                                               */
/*         ASSIGN bf-box-movto.ind-status-movto = 1. /* garante nao iniciado por conta de alteraá∆o no wm9061 */ */
/*     END.                                                                                                      */
/*
    IF wm-box-movto.ind-tipo-movto <> 1 THEN
        FIND FIRST wm-box-movto NO-LOCK
            WHERE wm-box-movto.cod-estabel    = v-cod-estabel
              AND wm-box-movto.cod-local      = v-cod-local
              AND wm-box-movto.id-movto       = i-id-movto
              AND wm-box-movto.ind-tipo-movto = 1 NO-ERROR.

    Run esp/wmp/eswm9061.p (INPUT ROWID(wm-box-movto),
                      INPUT tt-ressup-wms.cod-usuario,
                      INPUT tt-ressup-wms.cod-equipamento,
                      INPUT tt-ressup-wms.cod-coletor,
                      INPUT tt-ressup-wms.num-tempo-inicio,
                      INPUT 0, /* id agrupador? */
                      INPUT TABLE tt-etiqueta,
        	          OUTPUT TABLE RowErrors).
*/

    IF wm-box-movto.ind-tipo-movto <> 2 THEN
        FIND FIRST wm-box-movto NO-LOCK
            WHERE wm-box-movto.cod-estabel    = v-cod-estabel
              AND wm-box-movto.cod-local      = v-cod-local
              AND wm-box-movto.id-movto       = i-id-movto
              AND wm-box-movto.ind-tipo-movto = 2 NO-ERROR.

    Run esp/wmp/eswm9061.p (INPUT tt-ressup-wms.num-box-orig,
                      INPUT tt-ressup-wms.num-box-lido,
                      INPUT ROWID(wm-box-movto),
                      INPUT TABLE tt-tarefa-docto,
                      INPUT TABLE tt-etiqueta,
        	          OUTPUT TABLE RowErrors).

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    If  Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
        For Each RowErrors:
            Create tt-erro.
            Assign tt-erro.i-sequen = 8
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
        End. /* Each RowErrors */         
        
        Run getRowErrors In wgbosc096(Output Table RowErrors) No-error.
        For Each RowErrors:
            CREATE tt-erro.
            Assign tt-erro.i-sequen = 19
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
        End. /* Each RowErrors */
        Run deleteObjects.
        UNDO BC9020, Return 'NOK':U.
    End. /* If  Return-value <> 'OK' Then do: */

    /* Processo concluido com sucesso */
    Run deleteObjects.
    Return 'OK':U.
End. /* Do: */

Procedure deleteObjects:
    Run destroy In wgbosc096 No-error.
    If  valid-handle(wgbosc096) Then Delete Object wgbosc096.
End Procedure.

