/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Invent rio WMS                   **
**                                                                                         **
********************************************************************************************/
          

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
Define Variable wgBOSC044
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC051
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC058
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC074
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC079  
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC117
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC118
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC120
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC130
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgBOSC030
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgbcapi001
    AS WIDGET-HANDLE     NO-UNDO.
Define Variable wgbc9024j
    AS WIDGET-HANDLE     NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor      
    AS LOGICAL            INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        
    AS LOGICAL            INIT NO  NO-UNDO.
DEFINE VARIABLE vCodBloco    
    AS CHARACTER Format "X(03)":U NO-UNDO.
DEFINE VARIABLE vCodRua      
    AS CHARACTER Format "X(03)":U NO-UNDO.
DEFINE VARIABLE vCodNivel    
    AS CHARACTER Format "X(03)":U NO-UNDO.
DEFINE VARIABLE vCodColuna   
    AS CHARACTER Format "X(03)":U NO-UNDO.
DEFINE VARIABLE vLado
    AS CHARACTER Format "X(01)":U NO-UNDO.
DEFINE VARIABLE vDesEndereco 
    AS CHARACTER Format "X(10)":U NO-UNDO.
DEFINE VARIABLE vLogOk
    AS LOGICAL  NO-UNDO.
DEFINE VARIABLE vcontrol
    AS LOGICAL NO-UNDO.
Def Var vLogControlaLogin  
    As Logical Init No  
    No-undo.
Define Temp-Table tt-inventario-wms NO-UNDO
    FIELD num-sequencia             AS INTEGER      FORMAT '>>>>>>>>>>>>>9':U                           LABEL 'Sequˆncia'
    Field cod-usuario               As Character    Format 'x(12)':U                                    Label 'Usuario' 
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(03)':U                                    Label 'Local' 
    Field dat-inventario            As Date         Format '99/99/9999'                                 Label 'Data Invent tio'
    Field num-seq-invent            As Integer      Format '>>>>>9':U                                   Label 'Sequencia Inventario'
    Field num-contagem              As Integer      Format '>9':U                                       Label 'Contagem'
    Field num-box                   As Integer      Format '>>>>>>>>>9':U                               Label 'Box'           
    Field log-existe-end            As Logical      Format 'yes/no':U                                   Label 'Existe End?'           
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Serial'
    Field qtd-item                  As Decimal      Format '>>>,>>>,>>9.9999':U                         Label 'Qtd Item'            
    Field cod-item                  As Character    Format 'x(16)':U                                    Label 'Item'            
    FIELD ind-tipo-contr-est        AS INTEGER      FORMAT '>9':U                                       LABEL 'Tipo Controle Item'
    Field cod-lote                  As Character    Format 'x(40)':U                                    Label 'Lote'      
    FIELD cod-embalagem             AS CHARACTER    FORMAT 'x(10)':u                                    LABEL 'Embalagem'
    Field cod-Refer                 As Character    Format 'x(08)':U                                    Label 'Referencia' 
    Field dat-validade              As Date         Format '99/99/9999':U                               Label 'Validade'
    Field qtd-peso                  As Decimal      Format '>>>,>>>,>>9.9999':U                         Label 'Qtd Peso'            
    Field qtd-caixas                As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Caixas'            
    Field ind-transacao             As Integer      Format '99':U                                       Label 'ind transacao'            
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
    Field dat-livre-5               As Date         Format '99/99/9999'                                 Label 'DataLivre 5'
    index ID  is primary num-box 
                         num-serial
                         cod-item 
                         cod-refer 
                         cod-lote
                         cod-embalagem.    

DEFINE TEMP-TABLE tt-inventario-wms-bkp NO-UNDO LIKE tt-inventario-wms
       FIELD nr-trans               AS DECIMAL      FORMAT   'zzzzzzzzz9':U                             LABEL 'Transa‡Æo'
       INDEX id-seq num-sequencia.

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.
