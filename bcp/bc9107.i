/***********************************************************************************
** Produto....: CLD 2.00 - Coleda de Dados                                        **
**                                                                                **
** Include....: bc9007.i                                                          **
**                                                                                **
** Finalidade.: Armazenar os dados detalhe de comunicacao com o adapter do produto**
**                                                                                **
** Parametros.: 1 - New Shared                                                    **
**                                                                                **
** Autor......: Luciano Leonhardt                                                 **
**                                                                                **
** Versao.....: 2.0.00.000 - 01/09/2000                                           **
***********************************************************************************/

/*** Defini‡Æo Temp-Table utilizada para atualizar valores nos Proxy (EMS, MG)  ***/
Define {1} {2} Temp-Table ttAdapterParms NO-UNDO
    Field StandRecord1stPart    As Character
    Field StandRecord2ndPart    As Character
    Field StandRecord3rdPart    As Character
    Field CustomRecord1stPart   As Character
    Field CustomRecord2ndPart   As Character
    Field CustomRecord3rdPart   As Character
    .

/*** Defini‡Æo Temp-Table utilizada para atualizar valores nos Proxy (EMS, MG) ***/
Define {1} Temp-Table ttIntegracao  No-Undo
    Field Atributo              As Character
    Field TipoDado              As Character
    Field ValorChar             As Character
    Field ValorInte             As Integer
    Field ValorDeci             As Decimal
    Field ValorDate             As Date
    Field ValorLogi             As Logical
    Index ch-primary is primary Atributo
    .

/*** Defini‡Æo das Fun‡äes Para Busca dos Valores Nos Programas Proxy           ***/
/**********************************************************************************/
Function _RetornaValChar    Returns Character (Input pField As Character)   Forward.
Function _RetornaValInte    Returns Integer   (Input pField As Character)   Forward.
Function _RetornaValDeci    Returns Decimal   (Input pField As Character)   Forward.
Function _RetornaValData    Returns Date      (Input pField As Character)   Forward.
Function _RetornaValLogi    Returns Logical   (Input pField As Character)   Forward.
Function _AddField          Returns Character (Input pField As Character,
                                               Input pValor As Character,
                                               Input pType  As Character)   Forward.


Def var c-Lit-Erro      As Character        no-undo.
run utp/ut-msgs.p ( input "msg",
                    input 25345,
                    input "").
Assign  c-Lit-Erro = Trim(Return-Value).

Def var c-Lit-Logico    As Character        no-undo.
run utp/ut-liter.p (input "Sim",
                    input "*",
                    input "L") no-error.
Assign  c-Lit-Logico = Trim(Return-Value).



/*** Fun‡Æo Respons vel para Retornar o Valor Caracter                          ***/
/**********************************************************************************/
Function _RetornaValChar    Returns Character (Input pField As Character).

    Find First ttIntegracao
         Where ttIntegracao.Atributo = pField
         No-lock No-error.

    If  Avail ttIntegracao Then
        Return ttIntegracao.ValorChar.
    Else do:
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25345
                tt-erro.mensagem    = c-Lit-Erro + "( " + Trim(pField) + " )".
        Return " ".
    End.
End Function. /* _RetornaValChar */



/*** Fun‡Æo Respons vel para Retornar o Valor Inteiro                           ***/
/**********************************************************************************/
Function _RetornaValInte    Returns Integer (Input pField As Character).

    Find First ttIntegracao
         Where ttIntegracao.Atributo = Trim(pField)
         No-lock No-error.

    If  Avail ttIntegracao Then
        Return ttIntegracao.ValorInte.
    Else do:
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25345
                tt-erro.mensagem    = c-Lit-Erro + "( " + Trim(pField) + " )".
        Return 0.
    End.

End Function. /* _RetornaValInte */



/*** Fun‡Æo Respons vel para Retornar o Valor Decimal                           ***/
/**********************************************************************************/
Function _RetornaValDeci    Returns Decimal (Input pField As Character).

    Find First ttIntegracao
         Where ttIntegracao.Atributo = pField
         No-lock No-error.

    If  Avail ttIntegracao Then
        Return ttIntegracao.ValorDeci.
    Else do:
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25345
                tt-erro.mensagem    = c-Lit-Erro + "( " + Trim(pField) + " )".
        Return 0.00.
    End.

End Function. /* _RetornaValDeci */



/*** Fun‡Æo Respons vel para Retornar o Valor Data                              ***/
/**********************************************************************************/
Function _RetornaValData    Returns Date (Input pField As Character).

    Find First ttIntegracao
         Where ttIntegracao.Atributo = Trim(pField)
         No-lock No-error.

    If  Avail ttIntegracao Then
        Return ttIntegracao.ValorDate.
    Else do:
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25345
                tt-erro.mensagem    = c-Lit-Erro + "( " + Trim(pField) + " )".
        Return &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
    End.

End Function. /* _RetornaValDate */



/*** Fun‡Æo Respons vel para Retornar o Valor Logico                            ***/
/**********************************************************************************/
Function _RetornaValLogi    Returns Logical (Input pField As Character).

    Find First ttIntegracao
         Where ttIntegracao.Atributo = Trim(pField)
         No-lock No-error.

    If  Avail ttIntegracao Then
        Return ttIntegracao.ValorLogi.
    Else do:
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25345
                tt-erro.mensagem    = c-Lit-Erro + "( " + Trim(pField) + " )".
        Return No.
    End.

End Function. /* _RetornaValLogi */

/***********************************************************************************/



/*********************************************************************************/
Function _AddField Returns Character (Input pField As Character,
                                      Input pValor As Character,
                                      Input pType  As Character).

    If  Trim(pType) <> "Character" 
    And Trim(pType) <> "Integer"
    And Trim(pType) <> "Decimal"
    And Trim(pType) <> "Date"
    And Trim(pType) <> "Logical" 
    Then Do:
        run utp/ut-msgs.p ( input "msg",
                            input 25310,
                            input Trim(pField) + "~~" + Trim(pType)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro     = 25310
                tt-erro.mensagem    = trim(return-value).
        Return "NOK".
    End.

    Create  ttIntegracao.
    Assign  ttIntegracao.Atributo = Trim(pField).

    Case Trim(pType):
        When "Character" Then
            Assign  ttIntegracao.ValorChar  = String(pValor)
                    ttIntegracao.TipoDado   = "Character".
        When "Integer" Then
            Assign  ttIntegracao.ValorInte  = Integer(Trim(pValor))
                    ttIntegracao.TipoDado   = "Integer".
        When "Decimal" Then
            Assign  ttIntegracao.ValorDeci  = Decimal(Trim(pValor))
                    ttIntegracao.TipoDado   = "Decimal".
        When "Date" Then
            Assign  ttIntegracao.ValorDate  = Date(Trim(pValor))
                    ttIntegracao.TipoDado   = "Date".
        When "Logical" Then Do:
            Assign  ttIntegracao.ValorLogi  =  (If  Trim(pValor) = c-Lit-Logico
                                                Or  Trim(pValor) = 'Yes'
                                                Or  Trim(pValor) = 'Si'
                                                Then Yes Else No)
                    ttIntegracao.TipoDado   = "Logical".
        End.
    End Case.

End Function.
