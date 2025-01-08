/********************************************************************************
 ** UPC........: wdi189.p - UPC WRITE tb-preco
 ** Data.......: Junho / 2011
 ** Objetivo...: Repassa inclusäes e modifica‡äes para a Base Oracle
 
 compile \\tsclient\c\fontes\esp\trgw\win172.p save into c:\temp\esp\trgw.
 
 ********************************************************************************/
DEF PARAM BUFFER b-tb-preco      FOR tb-preco.
DEF PARAM BUFFER b-old-tb-preco  FOR tb-preco.
    
{esp/esb/esesb000.i}
{esp/esb/out/msg0195.i}
DEF VAR raw-param AS RAW NO-UNDO.

/*Situa‡Æo da Tabela de pro‡o. 0-Manuten‡Æo / 1-elimina‡Æo */
DEF VAR i-situacao AS INTEGER.
DEF BUFFER b-preco-item FOR preco-item.

IF  b-tb-preco.situacao <> b-old-tb-preco.situacao 
AND b-tb-preco.situacao = 1 THEN /* ATIVA */
    ASSIGN i-situacao = 0. /* ativa no CRM */
ELSE 
    ASSIGN i-situacao = 1. /* Inativa ou simula‡Æo no totvs, e INATIVA no CRM */

{esp/trgw/wdi189.i i-situacao}

/*
/* itens da tabela */
IF  b-tb-preco.situacao <> b-old-tb-preco.situacao 
AND b-tb-preco.situacao = 1 THEN DO: /* ATIVA */

    ASSIGN i-situacao = 0. /* ativa no CRM */

    FOR EACH b-preco-item 
        OF b-tb-preco NO-LOCK:
        /* 0 - Situa‡Æo da Tabela de pre‡o (manuten‡Æo , 0 - situa‡Æo do item da tabela (manute‡Æo)*/
        {esp/trgw/wdi163.i "0" "0"}
    END.
    
END.
ELSE DO:
    ASSIGN i-situacao = 1. /* Inativa ou simula‡Æo no totvs, e INATIVA no CRM */

    FOR EACH b-preco-item
       of b-tb-preco NO-LOCK:
        /* 0 - Situa‡Æo da Tabela de pre‡o (manuten‡Æo , 0 - situa‡Æo do item da tabela (manute‡Æo)*/
        {esp/trgw/wdi163.i "1" "1"}
    END.
    
END.
*/




RETURN "OK".




/*
/********************** Integracao do Ems para o CRM *****************/
IF  NEW b-tb-preco                                                OR
    b-old-tb-preco.cd-colecao       = b-tb-preco.cd-colecao       OR
    b-old-tb-preco.cd-gr-preco      = b-tb-preco.cd-gr-preco      OR
    b-old-tb-preco.Desconto         = b-tb-preco.Desconto         OR
    b-old-tb-preco.descricao        = b-tb-preco.descricao        OR
    b-old-tb-preco.dt-fimval        = b-tb-preco.dt-fimval        OR
    b-old-tb-preco.dt-inival        = b-tb-preco.dt-inival        OR
    b-old-tb-preco.dt-ult-atual     = b-tb-preco.dt-ult-atual     OR
    b-old-tb-preco.dt-val-preco     = b-tb-preco.dt-val-preco     OR
    b-old-tb-preco.ind-atualiz      = b-tb-preco.ind-atualiz      OR   
    b-old-tb-preco.log-valor-pauta  = b-tb-preco.log-valor-pauta  OR
    b-old-tb-preco.mo-codigo        = b-tb-preco.mo-codigo        OR
    b-old-tb-preco.nr-dias          = b-tb-preco.nr-dias          OR
    b-old-tb-preco.nr-tabpre        = b-tb-preco.nr-tabpre        OR
    b-old-tb-preco.observacoes      = b-tb-preco.observacoes      OR
    b-old-tb-preco.situacao         = b-tb-preco.situacao         OR
    b-old-tb-preco.taxa-finan       = b-tb-preco.taxa-finan       OR
    b-old-tb-preco.user-atualiz     = b-tb-preco.user-atualiz     THEN DO:

    {esp/crm/escrm001.i}
    {esp/crm/escrm001a.i1}
    RUN esp/crm/escrm001a.p (INPUT "Tb-preco",
                             INPUT "W",
                             INPUT ROWID(b-tb-preco),
                             INPUT TABLE tt-raw-transfer).
END.
*/
