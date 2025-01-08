/********************************************************************************
*      Programa .....: escdp118b.p                                              *
*      Data .........: 30 de agosto de 2022                                     *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: API para inclus∆o de Ferramenta (escdp118 e escdp120)    *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  30/08/2022  Mauricio C.   Desenvolvimento                   *
*      1.00.00.001  25/04/2023  Mauricio C.   Supress∆o integr. espec°fica MES  *
********************************************************************************/
{com/totvs/datasul/eai/include/error.i}   
{esp/es0018.i}
{utp/utapi019.i}
{utp/ut-glob.i}

def temp-table tt-pendencia no-undo
    field cTransaction      as char   
    field cInternalId       as char  
    field cErrorDescription as char  
	field iTipStatus        as inte
    field c-xml             as char.

def var h-cdapi990 as handle no-undo.
def var h-cdapi991 as handle no-undo.

for first param-global no-lock: end.  

run cdp/cdapi990.p persistent set h-cdapi990.
run cdp/cdapi991.p persistent set h-cdapi991.
run utp/utapi019.p persistent set h-utapi019.

return.

/*************** PROCEDURES ***************/
procedure pi-executa:
    def input  param p-cod-ferr-prod like ferr-prod.cod-ferr-prod no-undo.
    def input  param p-des-ferr-prod like ferr-prod.des-ferr-prod no-undo.
    def output param p-mes-pad       as logi                      no-undo.
   //def output param p-mes-esp       as logi                      no-undo.
    
    def var c-emails  as char     no-undo. 
    def var c-result  as char     no-undo.
    def var c-msg     as char     no-undo.
    def var c-chave   as char     no-undo.
    def var c-xml-aux as longchar no-undo.
    def var c-xml     as longchar no-undo.

    def var c-corpo-email as char format "x(2000)" no-undo.

    empty temp-table RowErrors.
    empty temp-table tt-pendencia.
    empty temp-table tt-envio2.
    empty temp-table tt-mensagem.
    empty temp-table tt-erros.

    if can-find(first ferr-prod where
                      ferr-prod.cod-ferr-prod = p-cod-ferr-prod
                      no-lock)
    then return "NOK":U.
    
    create ferr-prod.
    assign ferr-prod.cod-ferr-prod = p-cod-ferr-prod
           ferr-prod.des-ferr-prod = p-des-ferr-prod
           ferr-prod.un-ciclo      = 0
           ferr-prod.data-2        = today
           ferr-prod.int-2         = 1
           ferr-prod.log-2         = yes
           ferr-prod.char-1        = "Ferramenta".
    find current ferr-prod no-lock no-error.       
    
    empty temp-table RowErrors.
    
    run sendDirectUpsertFerramenta in h-cdapi991 (input rowid(ferr-prod),
                                                  output c-xml,
                                                  output c-chave,
                                                  output table RowErrors).
    
    if temp-table RowErrors:has-records
    then do:
         assign c-msg     = ""
                c-xml-aux = c-xml.
         
         for each RowErrors:
             assign c-msg = c-msg 
                          + RowErrors.errorDescription 
                          + chr(10).
         end. /* for each RowErrors */
         
         empty temp-table RowErrors.  
             
         do while(true):
             create tt-pendencia.
             assign tt-pendencia.cTransaction      = "Resource":U
                    tt-pendencia.cInternalId       = c-chave
                    tt-pendencia.cErrorDescription = c-msg
                    tt-pendencia.iTipStatus        = 1 /* Pendente com erro */
                 .
        
             if length(c-xml-aux) <= 9990
             then do:
                  assign tt-pendencia.c-xml = c-xml-aux.
                  leave.
             end.
             
             assign tt-pendencia.c-xml       = substr(c-xml-aux, 1,9990)
                   overlay(c-xml-aux,1,9990) = "":U.
         end. /* do while(true) */
         find current tt-pendencia no-error.
         release tt-pendencia.
         
         run createPendency in h-cdapi990 (input  table tt-pendencia,
                                           output table RowErrors).
        
         if temp-table RowErrors:has-records
         then return "NOK":U.
    end. /* if not can-find(first RowErrors) */
    else do:
         if can-find(first pendcia-integr-mes where
                           pendcia-integr-mes.cod-chave-ident = c-chave
                           no-lock)
         then run deletePendciaByIdentif in h-cdapi990 (input c-chave).
    
         assign p-mes-pad = yes.
    end. /* else do */

    run esp/es0018p.p (input  "CD0124":U,
                       input  1,
                       input  0,
                       input  "":U,
                       output table tt-prog-ponto).

    assign c-emails = "".

    for each tt-prog-ponto:
        assign c-emails = c-emails + tt-prog-ponto.conteudo + ",".
    end.

    if c-emails = ""
    then return "OK":U.
    
    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail                                      /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail                                     /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                                                    /* Destinat†rio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"                                      /* Remetente          */ 
           tt-envio2.assunto           = "Implantaá∆o Equipamento " + TRIM(ferr-prod.cod-ferr-prod) /* Assunto            */
           tt-envio2.formato           = "TEXTO".
    
    find usuar_mestre where
         usuar_mestre.cod_usuario = c-seg-usuario 
         no-lock no-error.

    assign c-corpo-email = "Implantaá∆o Recurso Secund†rio: " 
                         + trim(ferr-prod.cod-ferr-prod)
                         + chr(13)
                         + "Tipo: "
                         + trim(ferr-prod.char-1)
                         + chr(13)
                         + "Usuario: " 
                         + c-seg-usuario
                         + " - "
                         + if avail usuar_mestre 
                           then usuar_mestre.nom_usuario 
                           else "".
    
    create tt-mensagem.
    assign tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email /* Mensagem */
        .
    
    run pi-execute2 in h-utapi019 (input  table tt-envio2,
                                   input  table tt-mensagem,
                                   output table tt-erros).

/*     run esapi/esapi032.p (input  'update',                */
/*                           input  ferr-prod.cod-ferr-prod, */
/*                           output c-result).               */
/*                                                           */
/*     if substr(c-result,1,2) = '20'                        */
/*     then assign p-mes-esp = yes.                          */

    return "OK".
end procedure. /* procedure pi-executa */

procedure pi-finaliza:
    if valid-handle(h-cdapi990)
    then delete procedure h-cdapi990 no-error.
    if valid-handle(h-cdapi991)
    then delete procedure h-cdapi991 no-error.
    if valid-handle(h-utapi019)
    then delete procedure h-utapi019 no-error.

    return "OK".
end procedure. /* procedure pi-finaliza */
