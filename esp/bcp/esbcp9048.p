/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9112 MBC}
&ENDIF


{include/i-prgvrs.i BC9048 2.00.00.017 } /*** "010017" ***/
/********************************************************************************************
**   Programa..: bc9112.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.001 - mar/2003 - Karen de Freitas Machado                         **
**                                                                                         **
**   Objetivo..: Template DB Interface Menu para transacoes                                **
**                                                                                         **
**   Includes..: bc9105.i, bc9102.i                                                        **
**                                                                                         **
********************************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
***************************************************************************************************/

Define New Global Shared Var lMenu          As Logical                               No-undo.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9048
/************************************************************/

/* Definicao Temp-Table tt-erro ---                         */
{bcp/bc9102.i}
{bcp/bc9048.i1} /* definicao variaveis globais coletor e equipamento */
{utp/utapi009.i} /* login */
/************************************************************/

/* Definicao de variaveis do menu ---                       */
{bcp/bc9112.i0} /* Login */
Define Variable c-opcao  As Character Format 'x(01)'              No-Undo.
Define Variable vDesErro As Character View-as Editor Size 5 By 2  No-Undo.
Define Variable vLogErro As Logical Init No                       No-Undo.
Define Variable vNumErro As Integer Format '>>>>>>9'              No-Undo.
Define Variable wgWindow As Handle                                No-Undo.

DEFINE VARIABLE l-controle AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-logado   AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE vcod-usuario     AS CHARACTER FORMAT 'x(25)':U NO-UNDO.
DEFINE VARIABLE vcod-senha       AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE vcod-coletor     AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE vcod-equipamento AS CHARACTER FORMAT 'x(14)':U NO-UNDO.

Define Variable vCodTipoEquip           As Character            Init ''  No-undo.
Define Variable vLogAtivo               As Logical              Init No  No-undo.
Define Variable vLogProcesso            As Logical              Init No  No-undo.
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
DEFINE FRAME Frame01
    'Menu Transaá∆o'        AT ROW 01 COL 01
    "-----------------------------------"              At Row 02 Col 01          ~
    'Usr:'                  AT ROW 03 COL 01
    vcod-usuario            AT ROW 03 COL 05 NO-LABEL FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88
    'Sen:'                  AT ROW 04 COL 01
    vcod-senha              AT ROW 04 COL 05 NO-LABEL
    'Col'                   AT ROW 05 COL 01
    vcod-coletor            AT ROW 05 COL 05 NO-LABEL
    'Equ:'                  AT ROW 06 COL 01
    vcod-equipamento        AT ROW 06 COL 05 NO-LABEL
        WITH 1 DOWN FONT 3 SIZE 35 BY 8 NO-BOX.
/************************************************************/

DEFINE VARIABLE wgbosc092 AS HANDLE      NO-UNDO.

ASSIGN v_cod-coletor_corren     = ''
       v_cod-equipamento_corren = ''.

DEFINE TEMP-TABLE ttTarefas NO-UNDO
    FIELD cod-tarefa AS INTEGER FORMAT '99'
    FIELD nom-tarefa AS CHARACTER FORMAT 'x(20)'
    FIELD prog-leitura LIKE bc-tipo-trans.prog-leitura
    FIELD vli-priorid  LIKE bc-usuar-trans.vli-priorid
    INDEX id IS PRIMARY vli-priorid nom-tarefa.

DEFINE QUERY qryTarefas FOR ttTarefas.

DEFINE BROWSE brwTarefas QUERY qryTarefas NO-LOCK
    DISPLAY ttTarefas.nom-tarefa
    WITH NO-BOX NO-LABELS SIZE 35 BY 8 NO-SCROLLBAR-VERTICAL.

/* Definicao da Frame02 ---                                 */
DEFINE FRAME Frame02
    brwTarefas          AT ROW 01 COL 01
    WITH 1 DOWN FONT 3 SIZE 35 BY 8 NO-BOX.

/* Definicao da _Error ---                                  */
Define Frame _Error
    'Erro:'         At Row 1 Col 1 
    vNumErro        At Row 1 Col 6 No-label
    vDesErro        At Row 2 Col 1 No-label
        With 1 down font 3 SIZE 35 By 8 No-box.

Assign vDesErro:Width  = Frame _Error:Width
       vDesErro:Height = Frame _Error:Height - 1.
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/***********************************   Codigo Principal   ****************************************/
Assign Session:data-entry-return = Yes.
If Session:window-system <> 'TTY' Then Do:
    Create Window wgWindow Assign
          Status-area  = No
          Message-area = No
          Width        = Frame Frame01:Width
          Height       = Frame Frame01:Height
          Title        = 'Menu'.
    Assign Current-window = wgWindow.
End.

Assign lMenu = Yes.

ON 'Enter':U OF brwTarefas IN FRAME Frame02
DO:
    ASSIGN v_cod-coletor_corren     = vcod-coletor
           v_cod-equipamento_corren = vcod-equipamento.
    HIDE ALL NO-PAUSE.
    RUN VALUE(ttTarefas.prog-leitura).
    HIDE ALL NO-PAUSE.
    VIEW FRAME Frame02.
END.

ON 'Esc':U OF brwTarefas IN FRAME Frame02
DO:
    ASSIGN l-controle = NO               
           vcod-senha   = '****************'
           vcod-senha:SCREEN-VALUE IN FRAME Frame01     = '****************'.
END.

Repeat  On Error Undo, Retry
        On EndKey Undo, Leave:
    {bcp/bc9112.i}  /* Login do Produto */      

    If Session:window-system <> 'TTY' Then
        Assign wgWindow:Title = "Menu".

    VIEW FRAME Frame01.

    IF v_cod_usuar_corren <> '' THEN DO:
        ASSIGN l-logado = YES
               vcod-usuario = v_cod_usuar_corren
               vcod-usuario:SCREEN-VALUE IN FRAME Frame01   = v_cod_usuar_corren
               vcod-senha   = '****************'
               vcod-senha:SCREEN-VALUE IN FRAME Frame01     = '****************'.
        //ASSIGN  vcod-coletor = "c104001"
        //        vcod-equipamento = "h104001f".
                
        UPDATE vcod-coletor vcod-equipamento WITH FRAME Frame01.
    END.
    ELSE DO:
        assign vcod-senha:blank in frame frame01 = YES.
        /*
        ASSIGN  vcod-usuario = "le056548"
                vcod-senha   = 'leonardo1'
                vcod-coletor = "c104001"
                vcod-equipamento = "h104001f".
        */
        UPDATE vcod-usuario vcod-senha vcod-coletor vcod-equipamento WITH FRAME Frame01.
        ASSIGN vcod-senha:SCREEN-VALUE IN FRAME Frame01 = '****************'.
    END.

    IF vcod-usuario = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "101" "Usu†rio Inv†lido (DC)"}
        UNDO, RETRY.
    END.

    IF NOT l-logado THEN DO:
        RUN btb/btapi910za.p (INPUT vcod-usuario,
                              INPUT vcod-senha,
                              OUTPUT TABLE tt-erros) NO-ERROR.
    

        IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4755) THEN DO:
            {bcp/bc9105.i "4755" "Senha Expirou. Favor contactar o Administrador do Sistema!(DC)"}
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            UNDO, RETRY.
        END.

        IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
            {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado!(DC)"}
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            UNDO, RETRY.
        END.
        ELSE DO:
            IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
                {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta!(DC)"} 
                ASSIGN vLogErro           = YES
                       v_cod_usuar_corren = ''.
                UNDO, RETRY.
            END.
        END.
    END.

    IF vcod-coletor = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "102" "Coletor Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF vcod-equipamento = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Equipamento Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       Run scbo/bosc092.p Persistent Set wgbosc092 No-error.
       Run EmptyRowErrors In wgbosc092.
    END.

    Run validaEquipColetor In wgbosc092  (INPUT  vcod-coletor,
                                          OUTPUT vCodTipoEquip,
                                          OUTPUT vLogAtivo,
                                          OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK':U THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Coletor Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF NOT vLogAtivo THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
        UNDO, RETRY.
    END.

    Run validaEquipTransportador In wgbosc092  (INPUT  vcod-equipamento,
                                                OUTPUT vCodTipoEquip,
                                                OUTPUT vLogAtivo,
                                                OUTPUT vLogProcesso).
    If Return-value <> 'OK':U Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Equipamento Inv†lido (WMS)"}
        UNDO, RETRY.
    End.

    IF VALID-HANDLE(wgbosc092) THEN RUN destroy IN wgbosc092.

    If vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
        UNDO, RETRY.
    End.

    ASSIGN l-controle = YES.
    Repeat  On Error Undo, Retry
            On EndKey Undo, Leave:
        Run MontaMenu.
        IF l-controle = NO THEN LEAVE.
    END.
End.

Assign Session:data-entry-return = No.

If Valid-handle(wgWindow) Then Do:
    Assign wgWindow:visible = No.
    Delete  Object wgWindow.
End.

Return.
/**************************************************************************************************/

/*********************************** Procedures Internas ******************************************/
Procedure MontaMenu:
    Assign vLogErro = No.

    EMPTY TEMP-TABLE ttTarefas.

    FOR EACH bc-usuar-trans NO-LOCK
       WHERE bc-usuar-trans.cod-usuario = vcod-usuario,
       FIRST bc-tipo-trans NO-LOCK
       WHERE bc-tipo-trans.cd-trans = bc-usuar-trans.cd-trans
          BY bc-usuar-trans.vli-priorid:
        CREATE ttTarefas.
        ASSIGN ttTarefas.cod-tarefa   = bc-usuar-trans.vli-priorid
               ttTarefas.nom-tarefa   = bc-tipo-trans.descricao
               ttTarefas.prog-leitura = bc-tipo-trans.prog-leitura
               ttTarefas.vli-priorid  = bc-usuar-trans.vli-priorid.
    END.

    IF NOT CAN-FIND(FIRST ttTarefas) THEN DO:
        {bcp/bc9105.i "17006" "N∆o existem transaá‰es associadas ao usu†rio (WMS)"}
        ASSIGN l-controle = NO.
        RETURN.
    END.


    Hide Frame Frame01.
    
    If Session:window-system <> 'TTY' Then
    Assign wgWindow:Title = "Menu".

    OPEN QUERY qryTarefas FOR EACH ttTarefas.

    View frame Frame02.
    Update brwTarefas With Frame Frame02.

    If  Frame Frame01:Visible = Yes Then
        Hide Frame Frame01.

    If  Frame Frame02:Visible = Yes Then
        Hide Frame Frame02.

    Assign lMenu = No.

End Procedure.

FINALLY:   
   
   ASSIGN lMenu = NO
          v_cod-coletor_corren     = ""  
          v_cod-equipamento_corren = "".
    
   IF VALID-HANDLE(THIS-PROCEDURE:INSTANTIATING-PROCEDURE)
      AND ( THIS-PROCEDURE:INSTANTIATING-PROCEDURE:FILE-NAME MATCHES("*men702dc*") ) THEN 
      DELETE PROCEDURE THIS-PROCEDURE.
 
   RETURN 'OK':U.
END FINALLY.
