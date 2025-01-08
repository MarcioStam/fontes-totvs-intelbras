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
M‚todo de Acesso:      Buscar_DadosCEP
Parƒmetro de Entrada:  C¢digo CEP
Parƒmetros de Sa¡da:   Endere‡o, Bairro, Cidade e Estado
 
Exemplo de chamada: WS_Integracao_EMS.Buscar_DadosCEP ("02135050",out pEnd, out pBai, out pCid, out pUF);
  */
DEF TEMP-TABLE ttRetornoCEP NO-UNDO
    FIELD Endereco AS CHARACTER 
    FIELD Bairro   AS CHARACTER 
    FIELD Cidade   AS CHARACTER 
    FIELD UF       AS CHARACTER
    FIELD CidadeZF AS LOGICAL
    FIELD ibge     AS INTEGER.

DEFINE INPUT  PARAMETER piCep      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttRetornoCEP.
DEFINE VARIABLE c-tit-pat-log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-preposicao  AS CHARACTER   NO-UNDO.

FIND cep
     WHERE cep.cep = INT(piCep) 
     NO-LOCK NO-ERROR.

CREATE ttRetornoCEP.      /* Cria temp-table mesmo nao existindo o registro para nao dar erro no CRM */
IF NOT AVAIL cep THEN DO:
    RETURN "OK".
END.

IF cep.preposicao <> "" THEN  
    ASSIGN c-preposicao = trim(string(cep.preposicao))   + " ".
ELSE 
    ASSIGN c-preposicao = "".

IF cep.tit-pat-log <> "" THEN
    ASSIGN c-tit-pat-log =  trim(string(cep.tit-pat-log))   + " ".
ELSE
    ASSIGN c-tit-pat-log =  "".

ASSIGN ttRetornoCEP.Endereco   = trim(trim(string(cep.tipo-log))      + " " + 
                                 c-preposicao +
                                 c-tit-pat-log +
                                 trim(string(cep.nome-log))      + " " + 
                                 /* trim(string(cep.nr-lote-ini))   + " " +  */
                                 trim(string(cep.nome-complto))  + " " + 
                                 trim(string(cep.nr-complto))    + " " +
                                 trim(string(cep.nome-complto2)) + " " +  
                                 trim(string(cep.nr-complto2))) + " "
       ttRetornoCEP.Bairro     = trim(string(cep.bairro-ini))
       ttRetornoCEP.Cidade     = trim(string(substring(cep.localidade,1,25)))
       ttRetornoCEP.uf         = trim(string(cep.uf))
       ttRetornoCEP.CidadeZF   = CAN-FIND(FIRST cidade-zf NO-LOCK
                                          WHERE cidade-zf.cidade = ttRetornoCEP.Cidade
                                          AND   cidade-zf.estado = ttRetornoCEP.UF)
       ttRetornoCEP.ibge       = cep.ibge.

RETURN "OK".
