/*******************************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************************/
/********************************************************************************************
**   Programa..: bc9018.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
********************************************************************************************/

{cdp/cdcfgmat.i} 

Define {1} Temp-Table tt-picking-wms no-undo
    Field cod-usuario               As Character    Format 'x(14)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field des-endereco              As Character    Format 'x(18)':U                                    Label 'Endereco'
    Field id-docto                  As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    FIELD ind-tipo-movto            AS INTEGER      FORMAT '>9':U                                       LABEL 'Tipo Movto'
    Field id-movto                  As Decimal      Format '>>>>>>>>>9':U                               Label 'Movimento' 
    Field num-seq-item              As Integer      Format '>>>>9':U                                    Label 'Sequencia Item'
    Field num-box                   As Integer      Format '>>>>>9':U                                   Label 'Box'           
    Field num-doca                  As Integer      Format '>>9':U                                      Label 'Doca'          
    Field num-tempo-inicio          As Decimal      Format '>>>>>>>>>>>>>9':U                           Label 'Tempo Inicio'  
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field cod-item                  As Character    Format 'x(16)':U                                    Label 'Item'            
    Field qtd-item                  As Decimal      Format '>>>>>9.9999':U                              Label 'Qtd Item'            
    Field qtd-item-digit            As Decimal      Format '>>>>>9.9999':U                              Label 'Qtd Item'            
    Field num-box-lido              As Decimal      Format '>>>>>9':U                                   Label 'Box Lido'
    Field cod-embalagem             As Character    Format 'x(10)':U                                    Label 'Embalagem'
    Field qtd-embalagem             As Decimal      Format '>>>>>9.9999':U                               Label 'Qtd Embal'       
    Field qtd-embal-lidas           As Decimal      Format '>>>>>9.9999':U                               Label 'Qtd Embal Lidas' 
    Field des-seriais               As Character    Format 'X(50)':U                                    Label 'Seriais'
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Ultimo Serial'
    Field dat-atualizacao           As Date         Format '99/99/9999'                                 Label 'Atualizacao'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
    field cod-lote                  as character    Format 'x(40)'                                      label 'Nr. S‚rie / Lote'
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
    FIELD opcao                     AS INTEGER      FORMAT '9':U                                        LABEL 'Processo'
    Field cod-zona-ini              As Character    Format 'X(5)':U
    Field cod-zona-fim              As Character    Format 'X(5)':U
    index ID  is primary num-serial.    

DEF TEMP-TABLE tt-picking-wms-table no-undo LIKE tt-picking-wms.
/*******************************************************************************/

/* Retorno do metodo getOcupacaoBox da bosc035 */
DEF TEMP-TABLE ttResumo NO-UNDO
         FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
         FIELD cod-local        LIKE  wm-box-saldo.cod-local
         FIELD cod-item         LIKE  wm-box-saldo.cod-item
         FIELD cod-refer        LIKE  wm-box-saldo.cod-refer
         FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
         FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
         FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
         FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem
         FIELD cod-cliente      LIKE  wm-box-saldo.cod-cliente
         &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
            FIELD log-bloq-movto-cq LIKE wm-box-saldo.log-bloq-movto-cq
            FIELD desc-lote-estado  AS CHARACTER FORMAT "x(20)"
         &ENDIF
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 IS UNIQUE  cod-item
                                  cod-refer
                                  cod-lote
                                  dt-transacao   
                                  cod-embalagem 
                                  qtd-original 
                                  qtd-item
                                  qtd-item-bloq
                                  ind-status-saldo.
define temp-table ttEmbSelec no-undo
    field cChave as char
    field cNumEmbal as char
    field qtdItem like ttResumo.qtd-item
    index idItmEmb is unique cChave.
