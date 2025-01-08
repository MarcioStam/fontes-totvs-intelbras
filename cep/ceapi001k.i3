/*************************************************************************
 **
 **   Procedure Interna.....: pi-atualiza-consumo
 **   Descricao.............: Atualizaá∆o de consumos
 **   Criado por............: Werner / Wellington
 **   Criado em  ...........: 10/06/1997 - 15:00 Hrs
 **
 *************************************************************************/

PROCEDURE pi-atualiza-consumo :

def param buffer b-movto-cons for movto-estoq.

def var i-per-cons          as integer no-undo.
def var c-per-cons          as character no-undo.

def var l-conta-contab-valida as logical no-undo.


do on error undo, return error:

    assign c-per-cons = string(year(b-movto-cons.dt-trans),"9999") +
                        string(month(b-movto-cons.dt-trans),"99"). 


    find estabelec where
         estabelec.cod-estabel = tt-movto.cod-estabel no-lock no-error.

    if  valid-handle(h_api_cta_ctbl) 
    and avail estabelec then do:
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  estabelec.ep-codigo,         /* EMPRESA EMS2 */
                                                        input  estabelec.cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                        input  b-movto-cons.cod-unid-negoc, /* UNIDADE NEG‡CIO */
                                                        input  "",                          /* PLANO CONTAS */ 
                                                        input  b-movto-cons.ct-codigo,      /* CONTA */
                                                        input  "",                          /* PLANO CCUSTO */ 
                                                        input  b-movto-cons.sc-codigo,      /* CCUSTO */
                                                        input  today,                       /* DATA TRANSACAO */
                                                        output table tt_log_erro).          /* ERROS */
        if  return-value = "NOK":U then
            return "NOK":U.
    end.

        /*******************************************************************
        * Programa passa a atualizar consumo para todos os tipos de contas *
        * Wellington.                                                      *
        *******************************************************************/  
    
    &if defined (bf_mat_consumo_estab) &then
    
        find first estab-mat
           where estab-mat.cod-estabel = b-movto-cons.cod-estabel
           no-lock no-error.

        find consumo-estab use-index periodo
               where consumo-estab.periodo          = c-per-cons
                 and consumo-estab.cod-estabel-prin = estab-mat.cod-estabel-prin
                 and consumo-estab.it-codigo        = b-movto-cons.it-codigo
                 and consumo-estab.ct-codigo        = b-movto-cons.ct-codigo
                 and consumo-estab.sc-codigo        = b-movto-cons.sc-codigo
             exclusive-lock no-error.
                
        if not avail consumo-estab then do:
           create consumo-estab.
           assign consumo-estab.ct-codigo        = b-movto-cons.ct-codigo
                  consumo-estab.sc-codigo        = b-movto-cons.sc-codigo
                  consumo-estab.it-codigo        = b-movto-cons.it-codigo
                  consumo-estab.periodo          = c-per-cons
                  consumo-estab.cod-estabel-prin = estab-mat.cod-estabel-prin.
        end.        
            
        if b-movto-cons.tipo-trans = 1 then do:
           if  l-sumariza-movtos-reporte then
               assign consumo-estab.qt-entrada = consumo-estab.qt-entrada + 
                                                 tt-movto.quantidade.
           else
               assign consumo-estab.qt-entrada = consumo-estab.qt-entrada + 
                                                 b-movto-cons.quantidade.
        end.
        else do:
           if  l-sumariza-movtos-reporte then
               assign consumo-estab.qt-saida   = consumo-estab.qt-saida   + 
                                                 tt-movto.quantidade.
           else
               assign consumo-estab.qt-saida   = consumo-estab.qt-saida   + 
                                                 b-movto-cons.quantidade.                                      
        end.
    &else

        find consumo use-index conta-item
               where consumo.ct-codigo  = b-movto-cons.ct-codigo
                 and consumo.sc-codigo  = b-movto-cons.sc-codigo
                 and consumo.it-codigo  = b-movto-cons.it-codigo
                 and consumo.periodo    = c-per-cons
             exclusive-lock no-error.
                
        if not avail consumo then do:
           create consumo.
           assign consumo.ct-codigo             = b-movto-cons.ct-codigo
                  consumo.sc-codigo             = b-movto-cons.sc-codigo
                  consumo.it-codigo             = b-movto-cons.it-codigo
                  consumo.periodo               = c-per-cons
                  consumo.cod-estab             = b-movto-cons.cod-estabel.
        end.
            
        if b-movto-cons.tipo-trans = 1 then  do:
           if  l-sumariza-movtos-reporte then
               assign consumo.qt-entrada = consumo.qt-entrada + 
                                           tt-movto.quantidade.
           else
               assign consumo.qt-entrada = consumo.qt-entrada + 
                                           b-movto-cons.quantidade.
        end.
        else do:
           if  l-sumariza-movtos-reporte then
               assign consumo.qt-saida   = consumo.qt-saida   +
                                           tt-movto.quantidade.
           else  
               assign consumo.qt-saida   = consumo.qt-saida   +
                                           b-movto-cons.quantidade.
        end.
    &endif
    
end.

END PROCEDURE. /* pi-atualiza-consumo */
