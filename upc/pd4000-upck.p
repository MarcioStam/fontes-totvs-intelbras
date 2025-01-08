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
DEFINE INPUT PARAM p-combo-pd4000           AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-nat-operacao-pd4000    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-it-codigo-pd4000       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEFINE VARIABLE i-tipo-faturamento          AS INTEGER     NO-UNDO.
/*
&glob val1 1 - Venda          
&glob val2 2 - Revenda        
&glob val3 3 - Bonifica‡Æo    
&glob val4 4 - VPC 
*/

IF p-combo-pd4000:SCREEN-VALUE = "1 - Venda" THEN 
   ASSIGN i-tipo-faturamento = 1.
ELSE
    IF p-combo-pd4000:SCREEN-VALUE = "2 - Revenda" THEN 
       ASSIGN i-tipo-faturamento = 2.
    ELSE
        IF p-combo-pd4000:SCREEN-VALUE = "3 - Bonifica‡Æo" THEN 
           ASSIGN i-tipo-faturamento = 3.
        ELSE
            IF p-combo-pd4000:SCREEN-VALUE = "4 - VPC" THEN 
                ASSIGN i-tipo-faturamento = 4.

        ELSE RETURN "OK".
    


FIND ped-venda
     WHERE ROWID(ped-venda) = gr-ped-venda NO-LOCK NO-ERROR.
FIND ITEM 
    WHERE ITEM.it-codigo = p-it-codigo-pd4000:SCREEN-VALUE NO-LOCK NO-ERROR.

FIND nat-item-uf
     WHERE nat-item-uf.cod-estabel      = ped-venda.cod-estabel
       AND nat-item-uf.it-codigo        = ITEM.it-codigo 
       AND nat-item-uf.fm-codigo        = ITEM.fm-codigo   
       AND nat-item-uf.uf               = ped-venda.estado
       AND nat-item-uf.tipo-faturamento = i-tipo-faturamento
       NO-LOCK NO-ERROR.

IF NOT AVAIL nat-item-uf THEN 
    FIND nat-item-uf
         WHERE nat-item-uf.cod-estabel      = ped-venda.cod-estabel
           AND nat-item-uf.it-codigo        = ?
           AND nat-item-uf.fm-codigo        = ITEM.fm-codigo   
           AND nat-item-uf.uf               = ped-venda.estado
           AND nat-item-uf.tipo-faturamento = i-tipo-faturamento
           NO-LOCK NO-ERROR.

IF NOT AVAIL nat-item-uf THEN 
    FIND nat-item-uf
         WHERE nat-item-uf.cod-estabel      = ped-venda.cod-estabel
           AND nat-item-uf.it-codigo        = ?
           AND nat-item-uf.fm-codigo        = ? 
           AND nat-item-uf.uf               = ped-venda.estado
           AND nat-item-uf.tipo-faturamento = i-tipo-faturamento
           NO-LOCK NO-ERROR.
IF NOT AVAIL nat-item-uf THEN DO:
        MESSAGE "Natureza de Opera‡Æo NÆo encontrada com esta Opera‡Æo Informada"  SKIP
                "Verifique no Cadastro - espdp041" SKIP
            "Estabelecimento  " ped-venda.cod-estabel   SKIP
            "Item             " ITEM.it-codigo              SKIP
            "Familia          " ITEM.fm-codigo                  SKIP
            "Estado           " ped-venda.estado                    SKIP
            "Tipo Faturamento " i-tipo-faturamento " " p-combo-pd4000:SCREEN-VALUE
             VIEW-AS ALERT-BOX.
        RETURN "NOK".
END.
IF AVAIL nat-item-uf  THEN
   ASSIGN p-nat-operacao-pd4000:SCREEN-VALUE = nat-item-uf.nat-operacao.
RETURN "OK".

