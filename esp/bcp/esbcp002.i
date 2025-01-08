/*
Criada a variavel "wgBOSC074" para utiliza‡Æo no programa "bc9023.p".
*/
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9023.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
**                                                                                         **
********************************************************************************************/
          
DEFINE Temp-Table tt-consulta NO-UNDO
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-usuario               As Character    Format 'x(14)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field num-documento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    Field des-endereco              As Character    Format 'x(16)':U                                    Label 'Endereco'    
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>>':U                         Label 'Ultimo Serial'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
    Field cod-livre-1               As Character    Format 'x(40)':U                                    Label 'Cod Livre 1'
    Field cod-livre-2               As Character    Format 'x(40)':U                                    Label 'Cod Livre 2'
    Field cod-livre-3               As Character    Format 'x(40)':U                                    Label 'Cod Livre 3'
    Field cod-livre-4               As Character    Format 'x(40)':U                                    Label 'Cod Livre 4'
    Field cod-livre-5               As Character    Format 'x(40)':U                                    Label 'Cod Livre 5'
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 1'
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 2'     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 3'
    Field num-livre-4               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 4'
    Field num-livre-5               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 5'
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 1'
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 2'
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 3'
    Field dec-livre-4               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 4'
    Field dec-livre-5               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 5'
    Field log-livre-1               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 1'
    Field log-livre-2               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 2'
    Field log-livre-3               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 3'
    Field log-livre-4               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 4'
    Field log-livre-5               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 5'
    Field dat-livre-1               As Date         Format '99/99/9999'                                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                                 Label 'DataLivre 3'
    Field dat-livre-4               As Date         Format '99/99/9999'                                 Label 'DataLivre 4'
    Field dat-livre-5               As Date         Format '99/99/9999'                                 LABEL 'DataLivre 5'.

DEFINE TEMP-TABLE tt-etiq-consulta NO-UNDO  
    FIELD num-docto                  LIKE wm-docto.num-docto
    FIELD cod-estabel                LIKE wm-docto.cod-estabel LABEL "Estab"
    FIELD cod-local                  LIKE wm-docto.cod-local
    FIELD c-ind-origem-docto         AS CHARACTER Format 'x(14)':U LABEL "Origem Docto". 

{utp/ut-glob.i}
def new global shared var v_cod_estab_usuar 
    LIKE estabelec.cod-estabel
    label 'emsuni.estabelecimento' 
    column-label 'Estab' 
    no-undo. 
def new global shared var v_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    label 'emsuni.idioma' 
    column-label 'emsuni.idioma' 
    no-undo. 
def new global shared var v_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    label 'Pa¡s emsuni.empresa Usu rio' 
    column-label 'Pa¡s' 
    no-undo. 
def new global shared var v_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v2_cod_usuar_corren 
    as character 
    format 'x(12)' 
    label 'Usu rio Corrente' 
    column-label 'Usu rio Corrente' 
    no-undo. 
def new global shared var v2_cod_empres_usuar 
    as character 
    format 'x(3)' 
    label 'emsuni.empresa' 
    column-label 'emsuni.empresa' 
    no-undo. 
def new global shared var v2_cod_estab_usuar 
    LIKE estabelec.cod-estabel
    label 'emsuni.estabelecimento' 
    column-label 'Estab' 
    no-undo. 
def new global shared var v2_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    label 'emsuni.idioma' 
    column-label 'emsuni.idioma' 
    no-undo. 
def new global shared var v2_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    label 'Pa¡s emsuni.empresa Usu rio' 
    column-label 'Pa¡s' 
    no-undo. 
def new global shared var v2_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v2_cod_grp_usuar_lst  
    as character  
    label 'Grupo Usu rios'  
    column-label 'Grupo'  
    no-undo. 
DEFINE VARIABLE vcod-senha              
    AS CHARACTER FORMAT 'x(14)':U  NO-UNDO.
DEFINE VARIABLE wgbosc079             
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE wgBOSC092             
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE wgBOSC074 
    AS WIDGET-HANDLE               NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor      
    AS LOGICAL            INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        
    AS LOGICAL            INIT NO  NO-UNDO.
Define Variable vCodTipoEquip           
    As Character          Init ''  No-undo.
Define Variable vLogAtivo        
    As Logical             Init NO No-undo.
Define Variable vLogProcesso 
    As Logical             Init No  No-undo.
Define Variable vNumBox    
    As Integer    Init 0            No-undo.
Define Variable vCodBloco      
    As Character                    No-undo.
Define Variable vCodRua 
    As Character                    No-undo.
Define Variable vCodNivel 
    As Character                    No-undo.
Define Variable vCodColuna 
    As Character                    No-undo.
DEFINE VARIABLE vtexto            
    AS CHARACTER FORMAT 'x(18)'     NO-UNDO.
DEFINE VARIABLE vstatus
    AS INTEGER FORMAT '9'           NO-UNDO.

Define Variable vLogControlaLogin       
    As Logical                 Init No  No-undo.
