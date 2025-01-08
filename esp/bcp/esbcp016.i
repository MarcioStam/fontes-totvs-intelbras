/********************************************************************************************
**   Include...: bc9020.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Ressuprimento WMS                    **
**                                                                                         **
********************************************************************************************/

{cdp/cdcfgmat.i} 

Define {1} Temp-Table tt-ressup-wms NO-UNDO
    Field cod-usuario               As Character    Format 'x(12)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field des-endereco              As Character    Format 'x(25)':U                                    Label 'Endereco'
    Field num-documento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    Field num-movimento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Movimento' 
    Field num-seq-item              As Integer      Format '>>>>9':U                                    Label 'Sequencia Item'
    Field num-box                   As Integer      Format '>>>>9':U                                    Label 'Box'           
    Field num-tempo-inicio          As Decimal      Format '>>>>>>>>>>>>>9':U                           Label 'Tempo Inicio'  
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field cod-item                  As Character    Format 'x(16)':U                                    Label 'Item'            
    Field qtd-item                  As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Item'            
    Field qtd-item-digit            As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Item Lido'            
    Field num-box-orig              As Decimal      Format '>>>>>>>9':U                                 Label 'Box Lido'
    Field num-box-lido              As Decimal      Format '>>>>>>>9':U                                 Label 'Box Lido'
    Field cod-embalagem             As Character    Format 'x(10)':U                                    Label 'Embalagem'
    Field qtd-embalagem             As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Embal'       
    Field qtd-embal-lidas           As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Embal Lidas' 
    Field des-seriais               As Character    Format 'X(50)':U                                    Label 'Seriais'
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Ultimo Serial'
    Field dat-atualizacao           As Date         Format '99/99/9999'                                 Label 'Atualizacao'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
    FIELD des-endereco-entrada      As Character    Format 'x(25)':U                                    Label 'Endereco Entrada'
    Field des-qtdseriais            As Character    Format 'X(50)':U                                    Label 'Qtd Seriais'
    Field cod-opcao                 As INTEGER      Format 9    
    FIELD r-rowid                   AS ROWID
    Field cod-zona-ini              As Character    Format 'X(5)':U
    Field cod-zona-fim              As Character    Format 'X(5)':U
    index ID  is primary num-serial.    

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
define temp-table ttEmbSelec NO-UNDO
    field cChave as char
    field cNumEmbal as char
    field qtdItem like ttResumo.qtd-item
    index idItmEmb is unique cChave.


