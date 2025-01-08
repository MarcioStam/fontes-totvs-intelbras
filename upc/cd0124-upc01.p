/******************************************************************************
*      Programa .....: CD0124-UPC01.P                                         *
*      Data .........: 27 de Maio de 2022                                     *
*      Sistema ......: CD - CADASTRO                                          *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: Chamado pela UPC no CD0124                             *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 27/05/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/ 
def input parameter p-combo          as handle no-undo. 
def input parameter p-i-un-ciclo     as handle no-undo.
def input parameter p-data-ult-manut as handle no-undo.

DEF VAR lg-ferramenta AS LOGI NO-UNDO.

IF NOT VALID-HANDLE(p-combo)
THEN RETURN.

//ASSIGN lg-ferramenta = p-combo:SCREEN-VALUE = "Ferramenta".

IF p-combo:SCREEN-VALUE = "Equipamento tipo P" THEN
   ASSIGN lg-ferramenta = YES.
ELSE 
   ASSIGN lg-ferramenta = NO.

IF VALID-HANDLE(p-i-un-ciclo)
THEN ASSIGN p-i-un-ciclo:HIDDEN     = NOT lg-ferramenta NO-ERROR.
IF VALID-HANDLE(p-data-ult-manut)
THEN ASSIGN p-data-ult-manut:HIDDEN = NOT lg-ferramenta NO-ERROR.

return.
