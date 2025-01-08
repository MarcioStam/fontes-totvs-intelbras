/********************************************************************************
 ** UPC........: escrm0001a.p 
 ** Data.......: Setembro / 2010
 ** Objetivo...: 
 ********************************************************************************/
{esp/es0018.i} 

{esp/crm/escrm001api.i} /* Pre-processadores de conexÆo e variavel c-base-crm */
{esp/crm/escrm001b.i}   /* Definicoes de temp-tables para buscar as Tabelas do ems5 */

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.

DEFINE VARIABLE h-escrm001api     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
define variable pContaLinhasTrace as int         no-undo.
define variable pentidade         as char        no-undo.
define variable cevento           as char        no-undo.
DEFINE VARIABLE i-cont            AS INTEGER     NO-UNDO.

{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

define buffer b-emitente for emitente.   

define input parameter p-table     as char.
define input parameter p-evento    as char.
define input parameter p-row-table as rowid. 
define input parameter table for tt-raw-transfer. 
/*
/* *** Provis¢rio, pois a base de testes do CRM est  fora do ar - Sakae - In¡cio *** */
IF OPSYS = "win32":U THEN DO:
    IF INDEX(SESSION:STARTUP-PARAMETERS, "-S 18201":U) > 0 THEN DO:
        DELETE WIDGET-POOL.

        RETURN "OK":U.
    END.
END.
ELSE DO:
    IF INDEX(SESSION:STARTUP-PARAMETERS, "usr10":U) > 0 THEN DO:
        DELETE WIDGET-POOL.

        RETURN "OK":U.
    END.
END.
/* *** Provis¢rio, pois a base de testes do CRM est  fora do ar - Sakae - Final *** */
*/
assign cevento = p-evento. 

RUN piCarregaBos.

IF '{&ativar-envio}' = 'yes' THEN
    RUN piConnection in h-escrm001api.
   

empty temp-table tt-atributo.

/* NÆo retirar, evita erro compila‡Æo */
find first emitente no-lock no-error.
/**/

if p-table = "Preco-item"
then do:
   if cevento = "W" 
   then do:
      find first preco-item no-lock where
           rowid(preco-item) = p-row-table no-error.
      if avail preco-item
      then do:           
         create tt-preco-item-atu.
         buffer-copy preco-item to tt-preco-item-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-preco-item-atu.
      create tt-preco-item-atu.
   
      raw-transfer tt-raw-transfer.record to tt-preco-item-atu.
   end.

   find first tt-preco-item-atu no-error.

   ASSIGN pEntidade = "new_item_tabela":U.

   {esp/crm/escrm001a.i "Preco-item"}

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-preco-item:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

   FOR EACH rowerrors:
       MESSAGE rowerrors.errornumber
           rowerrors.errordescription
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
   END.

    EMPTY TEMP-TABLE tt-preco-item.
    EMPTY TEMP-TABLE tt-preco-item-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Tb-preco"
then do:
   if cevento = "W" 
   then do:
      find first tb-preco no-lock where
           rowid(tb-preco) = p-row-table no-error.
      if avail tb-preco
      then do:           
         create tt-tb-preco-atu.
         buffer-copy tb-preco to tt-tb-preco-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-tb-preco-atu.
      create tt-tb-preco-atu.
   
      raw-transfer tt-raw-transfer.record to tt-tb-preco-atu.
   end.

   find first tt-tb-preco-atu no-error.

   ASSIGN pEntidade = "new_tabela_preco":U.

   {esp/crm/escrm001a.i "Tb-preco"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-tb-preco:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-tb-preco.
    EMPTY TEMP-TABLE tt-tb-preco-atu.       
    empty temp-table tt-raw-transfer.
        
end.
       
if p-table = "Emitente"
then do:
   find first emitente no-lock where
             rowid(emitente) = p-row-table no-error.                 
   
   find first param-global no-lock no-error.
    
    assign pentidade = "account".
                
   {esp/crm/escrm001cliente.i}
   
   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                                              INPUT  pEntidade,
                                              INPUT  cevento,
                                              INPUT  "0":U,
                                              INPUT  BUFFER tt-cliente:HANDLE,
                                              INPUT  TABLE tt-atributo,
                                              OUTPUT TABLE RowErrors).

   EMPTY TEMP-TABLE tt-cliente.
end.

if p-table = "Cont-emit"
then do:
   if cevento = "W" 
   then do:
      find first cont-emit no-lock where
                rowid(cont-emit) = p-row-table no-error.
      if avail cont-emit
      then do:           
         create tt-cont-emit-atu.
         buffer-copy cont-emit to tt-cont-emit-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-cont-emit-atu.
      create tt-cont-emit-atu.
   
      raw-transfer tt-raw-transfer.record to tt-cont-emit-atu.
   end.
     
   find first tt-cont-emit-atu no-error.

   find first emitente no-lock where
              emitente.cod-emitente = tt-cont-emit-atu.cod-emitente no-error.
                     
   assign pentidade = "contact".
      
   {esp/crm/escrm001a.i "Cont-emit"}        
      
   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-cont-emit:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).    
    
   EMPTY TEMP-TABLE tt-cont-emit.
   EMPTY TEMP-TABLE tt-cont-emit-atu.     
   empty temp-table tt-raw-transfer.
        
end.

if p-table = "loc-entr"
then do:
   if cevento = "W" 
   then do:
      find first loc-entr no-lock where
                rowid(loc-entr) = p-row-table no-error.
      if avail loc-entr
      then do:           
         create tt-loc-entr-atu.
         buffer-copy loc-entr to tt-loc-entr-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-loc-entr-atu.
      create tt-loc-entr-atu.
   
      raw-transfer tt-raw-transfer.record to tt-loc-entr-atu.
   end.
     
   find first tt-loc-entr-atu no-error.
   
   find first emitente no-lock where
              emitente.nome-abrev = tt-loc-entr-atu.nome-abrev no-error.
                     
   ASSIGN pEntidade = "customeraddress":U.
      
   {esp/crm/escrm001a.i "Loc-entr"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-loc-entr:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-loc-entr.
    EMPTY TEMP-TABLE tt-loc-entr-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Repres"
then do:
   if cevento = "W" 
   then do:
      find first repres no-lock where
                rowid(repres) = p-row-table no-error.
      if avail repres
      then do:           
         create tt-repres-atu.
         buffer-copy repres to tt-repres-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-repres-atu.
      create tt-repres-atu.
   
      raw-transfer tt-raw-transfer.record to tt-repres-atu.
   end.
     
   find first tt-repres-atu no-error.
                     
   ASSIGN pEntidade = "new_representante":U.
      
   {esp/crm/escrm001a.i "Repres"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-repres:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-repres.
    EMPTY TEMP-TABLE tt-repres-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Portador"
then do:
   if cevento = "W" 
   then do:
      find first mgcad.portador no-lock where
                rowid(mgcad.portador) = p-row-table no-error.
      if avail mgcad.portador
      then do:           
         create tt-portador-atu.
         buffer-copy mgcad.portador to tt-portador-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-portador-atu.
      create tt-portador-atu.
   
      raw-transfer tt-raw-transfer.record to tt-portador-atu.
   end.
     
   find first tt-portador-atu no-error.
                     
   ASSIGN pEntidade = "new_portador":U.
      
   {esp/crm/escrm001a.i "Portador"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-portador:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-portador.
    EMPTY TEMP-TABLE tt-portador-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Receita-Padrao"
then do:
   if cevento = "W" 
   then do:
      find first tipo-rec-desp no-lock where
                rowid(tipo-rec-desp) = p-row-table no-error.
      if avail tipo-rec-desp
      then do:           
         create tt-receita-padrao-atu.
         buffer-copy tipo-rec-desp to tt-receita-padrao-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-receita-padrao-atu.
      create tt-receita-padrao-atu.
   
      raw-transfer tt-raw-transfer.record to tt-receita-padrao-atu.
   end.
     
   find first tt-receita-padrao-atu no-error.
                     
   ASSIGN pEntidade = "new_receita_padrao":U.
      
   {esp/crm/escrm001a.i "Receita-Padrao"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-receita-padrao:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-receita-padrao.
    EMPTY TEMP-TABLE tt-receita-padrao-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Cond-Pagto"
then do:
   if cevento = "W" 
   then do:
      find first cond-pagto no-lock where
                rowid(cond-pagto) = p-row-table no-error.
      if avail cond-pagto
      then do:           
         create tt-cond-pagto-atu.
         buffer-copy cond-pagto to tt-cond-pagto-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-cond-pagto-atu.
      create tt-cond-pagto-atu.
   
      raw-transfer tt-raw-transfer.record to tt-cond-pagto-atu.
   end.
     
   find first tt-cond-pagto-atu no-error.
   
                  
   ASSIGN pEntidade = "new_condicao_pagamento":U.
      
   {esp/crm/escrm001a.i "Cond-Pagto"}        
    
             
    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-cond-pagto:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-cond-pagto.
    EMPTY TEMP-TABLE tt-cond-pagto-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Transporte"
then do:
   if cevento = "W" 
   then do:
      find first transporte no-lock where
                rowid(transporte) = p-row-table no-error.
      if avail transporte
      then do:           
         create tt-transporte-atu.
         buffer-copy transporte to tt-transporte-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-transporte-atu.
      create tt-transporte-atu.
   
      raw-transfer tt-raw-transfer.record to tt-transporte-atu.
   end.
     
   find first tt-transporte-atu no-error.
                     
   ASSIGN pEntidade = "new_transportadora":U.
      
   {esp/crm/escrm001a.i "Transporte"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-transportadora:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-transportadora.
    EMPTY TEMP-TABLE tt-transporte-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Canal-venda"
then do:
   if cevento = "W" 
   then do:
      find first canal-venda no-lock where
                rowid(canal-venda) = p-row-table no-error.
      if avail canal-venda
      then do:           
         create tt-canal-venda-atu.
         buffer-copy canal-venda to tt-canal-venda-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-canal-venda-atu.
      create tt-canal-venda-atu.
   
      raw-transfer tt-raw-transfer.record to tt-canal-venda-atu.
   end.
     
   find first tt-canal-venda-atu no-error.
                     
   ASSIGN pEntidade = "new_canal_venda":U.
      
   {esp/crm/escrm001a.i "canal-venda"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-canal-venda:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-canal-venda.
    EMPTY TEMP-TABLE tt-canal-venda-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Gr-Cli"
then do:
   if cevento = "W" 
   then do:
      find first gr-cli no-lock where
                rowid(gr-cli) = p-row-table no-error.
      if avail gr-cli
      then do:           
         create tt-gr-cli-atu.
         buffer-copy gr-cli to tt-gr-cli-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-gr-cli-atu.
      create tt-gr-cli-atu.
   
      raw-transfer tt-raw-transfer.record to tt-gr-cli-atu.
   end.
     
   find first tt-gr-cli-atu no-error.
                     
   ASSIGN pEntidade = "new_grupo_cliente":U.
      
   {esp/crm/escrm001a.i "gr-cli"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-gr-cli:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-gr-cli.
    EMPTY TEMP-TABLE tt-gr-cli-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Crm-relacionamento-Cliente"
then do:
   if cevento = "W" 
   then do:
      find first crm-relacionamento-cliente no-lock where
                rowid(crm-relacionamento-cliente) = p-row-table no-error.
      if avail crm-relacionamento-cliente
      then do:           
         create tt-relacionamento-cliente-atu.
         buffer-copy crm-relacionamento-cliente to tt-relacionamento-cliente-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-relacionamento-cliente-atu.
      create tt-relacionamento-cliente-atu.
   
      raw-transfer tt-raw-transfer.record to tt-relacionamento-cliente-atu.
   end.
     
   find first tt-relacionamento-cliente-atu no-error.
                     
   ASSIGN pEntidade = "new_relacionamento":U.
            
   {esp/crm/escrm001a.i "Crm-relacionamento-cliente"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-relacionamento-cliente:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-relacionamento-cliente.
    EMPTY TEMP-TABLE tt-relacionamento-cliente-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Item"
then do:
   if cevento = "W" 
   then do:
      find first item no-lock where
                rowid(item) = p-row-table no-error.
      if avail ITEM
      then do:           
         create tt-item-atu.
         buffer-copy item to tt-item-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-item-atu.
      create tt-item-atu.
   
      raw-transfer tt-raw-transfer.record to tt-item-atu.
   end.
     
   find first tt-item-atu no-error.
                     
   ASSIGN pEntidade = "product":U.
      
   {esp/crm/escrm001a.i "Item"}        
   IF tt-item-atu.it-codigo = "" THEN 
       ASSIGN tt-item-atu.it-codigo = "BRANCO".

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-item:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
   FOR EACH tt-productpricelevel: 
   
     EMPTY TEMP-TABLE tt-productpricelevel-atu.
     CREATE tt-productpricelevel-atu.
     BUFFER-COPY tt-productpricelevel TO tt-productpricelevel-atu. 
     
     RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  "productpricelevel":U,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-productpricelevel-atu:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   END.

   
   EMPTY TEMP-TABLE tt-item.
   EMPTY TEMP-TABLE tt-item-atu.       
   EMPTY TEMP-TABLE tt-productpricelevel.
   empty temp-table tt-raw-transfer.
        
end.
  
if p-table = "Familia"
then do:
   if cevento = "W" 
   then do:
      find first familia no-lock where
                rowid(familia) = p-row-table no-error.
      if avail familia
      then do:           
         create tt-familia-material-atu.
         buffer-copy familia to tt-familia-material-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-familia-material-atu.
      create tt-familia-material-atu.
   
      raw-transfer tt-raw-transfer.record to tt-familia-material-atu.
   end.
     
   find first tt-familia-material-atu no-error.
                     
   ASSIGN pEntidade = "new_familia_material":U.
      
   {esp/crm/escrm001a.i "Familia"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-familia-material:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-familia-material.
    EMPTY TEMP-TABLE tt-familia-material-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Fam-comerc"
then do:
   if cevento = "W" 
   then do:
      find first fam-comerc no-lock where
                rowid(fam-comerc) = p-row-table no-error.
      if avail fam-comerc
      then do:           
         create tt-familia-comercial-atu.
         buffer-copy fam-comerc to tt-familia-comercial-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-familia-comercial-atu.
      create tt-familia-comercial-atu.
   
      raw-transfer tt-raw-transfer.record to tt-familia-comercial-atu.
   end.
     
   find first tt-familia-comercial-atu no-error.
                     
   ASSIGN pEntidade = "new_familiacomercial":U.
      
   {esp/crm/escrm001a.i "Fam-comerc"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-familia-comercial:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-familia-comercial.
    EMPTY TEMP-TABLE tt-familia-comercial-atu.       
    empty temp-table tt-raw-transfer.
        
end.
    
if p-table = "Natur-oper"
then do:
   if cevento = "W" 
   then do:
      find first natur-oper no-lock where
                rowid(natur-oper) = p-row-table no-error.
      if avail natur-oper
      then do:           
         create tt-natur-oper-atu.
         buffer-copy natur-oper to tt-natur-oper-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-natur-oper-atu.
      create tt-natur-oper-atu.
   
      raw-transfer tt-raw-transfer.record to tt-natur-oper-atu.
   end.
     
   find first tt-natur-oper-atu no-error.
                     
   ASSIGN pEntidade = "new_natureza_operacao":U.
      
   {esp/crm/escrm001a.i "natur-oper"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-natur-oper:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-natur-oper.
    EMPTY TEMP-TABLE tt-natur-oper-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Mensagem"
then do:
   if cevento = "W" 
   then do:
      find first mensagem no-lock where
                rowid(mensagem) = p-row-table no-error.
      if avail mensagem
      then do:           
         create tt-mensagem-atu.
         buffer-copy mensagem to tt-mensagem-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-mensagem-atu.
      create tt-mensagem-atu.
   
      raw-transfer tt-raw-transfer.record to tt-mensagem-atu.
   end.
     
   find first tt-mensagem-atu no-error.
                     
   ASSIGN pEntidade = "new_mensagem":U.
      
   {esp/crm/escrm001a.i "mensagem"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-mensag-crm:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-mensag-crm.
    EMPTY TEMP-TABLE tt-mensagem-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Estabelec"
then do:
   if cevento = "W" 
   then do:
      find first estabelec no-lock where
                rowid(estabelec) = p-row-table no-error.
      if avail estabelec
      then do:           
         create tt-estabelec-atu.
         buffer-copy estabelec to tt-estabelec-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-estabelec-atu.
      create tt-estabelec-atu.
   
      raw-transfer tt-raw-transfer.record to tt-estabelec-atu.
   end.
     
   find first tt-estabelec-atu no-error.
                     
   ASSIGN pEntidade = "new_estabelecimento":U.
   
   {esp/crm/escrm001a.i "estabelec"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-estabelec:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-estabelec.
    EMPTY TEMP-TABLE tt-estabelec-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Tab-finan" OR 
   p-table = "Ind-tab-finan"
then do:

   if cevento = "W" 
   then do:
      find first tab-finan no-lock where
                rowid(tab-finan) = p-row-table no-error.
      if avail tab-finan
      then do:           
         create tt-tab-finan-atu.
         buffer-copy tab-finan to tt-tab-finan-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-tab-finan-atu.
      create tt-tab-finan-atu.
   
      raw-transfer tt-raw-transfer.record to tt-tab-finan-atu.
   end.
     
   find first tt-tab-finan-atu no-error.
                     
   IF p-table = "Tab-finan"
   THEN DO:

       ASSIGN pEntidade = "new_tabela_financiamento":U.
          
       {esp/crm/escrm001a.i "tab-finan"}        
    
       RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                                 INPUT  pEntidade,
                                 INPUT  cevento,
                                 INPUT  "0":U,
                                 INPUT  BUFFER tt-tab-finan:HANDLE,
                                 INPUT  TABLE tt-atributo,
                                 OUTPUT TABLE RowErrors).
   END.
   ELSE DO:

       ASSIGN pEntidade = "new_indice":U.
          
       DO i-cont = 1 TO 12 :
         
           EMPTY TEMP-TABLE tt-ind-tab-finan-atu.
           CREATE tt-ind-tab-finan-atu.

           ASSIGN tt-ind-tab-finan-atu.nr-tab-finan        = tt-tab-finan-atu.nr-tab-finan
                  tt-ind-tab-finan-atu.nr-ind-finan        = i-cont
                  tt-ind-tab-finan-atu.tab-dia-fin         = tt-tab-finan-atu.tab-dia-fin[i-cont]
                  tt-ind-tab-finan-atu.tab-ind-fin         = tt-tab-finan-atu.tab-ind-fin[i-cont].

           {esp/crm/escrm001a.i "ind-tab-finan"}        
        
           RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                                     INPUT  pEntidade,
                                     INPUT  cevento,
                                     INPUT  "0":U,
                                     INPUT  BUFFER tt-ind-tab-finan:HANDLE,
                                     INPUT  TABLE tt-atributo,
                                     OUTPUT TABLE RowErrors).

       END.
   END.

   EMPTY TEMP-TABLE tt-tab-finan.
   EMPTY TEMP-TABLE tt-tab-finan-atu.       
   empty temp-table tt-raw-transfer.
        
end.

if p-table = "Rota"
then do:
   if cevento = "W" 
   then do:
      find first rota no-lock where
                rowid(rota) = p-row-table no-error.
      if avail rota
      then do:           
         create tt-rota-atu.
         buffer-copy rota to tt-rota-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-rota-atu.
      create tt-rota-atu.
   
      raw-transfer tt-raw-transfer.record to tt-rota-atu.
   end.
     
   find first tt-rota-atu no-error.
                     
   ASSIGN pEntidade = "new_rota":U.
      
   {esp/crm/escrm001a.i "rota"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-rota:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).
   
    EMPTY TEMP-TABLE tt-rota.
    EMPTY TEMP-TABLE tt-rota-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Estrutura"
then do:
   if cevento = "W" 
   then do:
      find first estrutura no-lock where
                rowid(estrutura) = p-row-table no-error.
      if avail estrutura
      then do:           
         create tt-estrutura-atu.
         buffer-copy estrutura to tt-estrutura-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-estrutura-atu.
      create tt-estrutura-atu.
   
      raw-transfer tt-raw-transfer.record to tt-estrutura-atu.
   end.
     
   find first tt-estrutura-atu no-error.
                     
   ASSIGN pEntidade = "new_estrutura_produto".
      
   {esp/crm/escrm001a.i "Estrutura"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-estrutura:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-estrutura.
    EMPTY TEMP-TABLE tt-estrutura-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Grup-Estoque"
then do:
   if cevento = "W" 
   then do:
      find first grup-estoque no-lock where
                rowid(grup-estoque) = p-row-table no-error.
      if avail grup-estoque
      then do:           
         create tt-grup-estoque-atu.
         buffer-copy grup-estoque to tt-grup-estoque-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-grup-estoque-atu.
      create tt-grup-estoque-atu.
   
      raw-transfer tt-raw-transfer.record to tt-grup-estoque-atu.
   end.
     
   find first tt-grup-estoque-atu no-error.
                     
   ASSIGN pEntidade = "new_grupo_estoque".
      
   {esp/crm/escrm001a.i "Grup-estoque"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-grup-estoque:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-grup-estoque.
    EMPTY TEMP-TABLE tt-grup-estoque-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "Crm-categoria"
then do:
   if cevento = "W" 
   then do:
      find first Crm-categoria no-lock where
                rowid(Crm-categoria) = p-row-table no-error.
      if avail Crm-categoria
      then do:           
         create tt-Crm-categoria-atu.
         buffer-copy crm-categoria to tt-Crm-categoria-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-Crm-categoria-atu.
      create tt-Crm-categoria-atu.
   
      raw-transfer tt-raw-transfer.record to tt-Crm-categoria-atu.
   end.
        
   find first tt-Crm-categoria-atu no-error.
                     
   ASSIGN pEntidade = "new_categoria".
                 
   {esp/crm/escrm001a.i "Crm-categoria"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-crm-categoria:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-crm-categoria.
    EMPTY TEMP-TABLE tt-crm-categoria-atu.       
    empty temp-table tt-raw-transfer.
        
end.


if p-table = "crm-categ-un"
then do:
   if cevento = "W" 
   then do:
      find first crm-categ-un no-lock where
                rowid(crm-categ-un) = p-row-table no-error.
      if avail crm-categ-un
      then do:           
         create tt-crm-categ-un-atu.
         buffer-copy crm-categ-un to tt-crm-categ-un-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-crm-categ-un-atu.
      create tt-crm-categ-un-atu.
   
      raw-transfer tt-raw-transfer.record to tt-crm-categ-un-atu.
   end.
        
   find first tt-crm-categ-un-atu no-error.
                     
   ASSIGN pEntidade = "new_unxcategoria".
                 
   {esp/crm/escrm001a.i "crm-categ-un"}        

   RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                             INPUT  pEntidade,
                             INPUT  cevento,
                             INPUT  "0":U,
                             INPUT  BUFFER tt-crm-categ-un:HANDLE,
                             INPUT  TABLE tt-atributo,
                             OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-crm-categ-un.
    EMPTY TEMP-TABLE tt-crm-categ-un-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "uf"
then do:
   if cevento = "W" 
   then do:
      find first unid-feder no-lock where
                rowid(unid-feder) = p-row-table no-error.
      if AVAIL unid-feder
      then do:           
         create tt-unid-feder-atu.
         buffer-copy unid-feder to tt-unid-feder-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-unid-feder-atu.
      create tt-unid-feder-atu.
   
      raw-transfer tt-raw-transfer.record to tt-unid-feder-atu.
   end.
     
   find first tt-unid-feder-atu no-error.
                     
   ASSIGN pEntidade = "new_uf":U.
      
   {esp/crm/escrm001a.i "uf"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-unid-feder:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-unid-feder.
    EMPTY TEMP-TABLE tt-unid-feder-atu.       
    empty temp-table tt-raw-transfer.
        
end.

if p-table = "cidade"
then do:
   if cevento = "W" 
   then do:
      find first mgcad.cidade no-lock where
                rowid(mgcad.cidade) = p-row-table no-error.
      if AVAIL mgcad.cidade
      then do:           
         create tt-cidade-atu.
         buffer-copy mgcad.cidade to tt-cidade-atu.          
      end.
   end.
   else do:      
      find first tt-raw-transfer no-error.
      empty temp-table tt-cidade-atu.
      create tt-cidade-atu.
   
      raw-transfer tt-raw-transfer.record to tt-cidade-atu.
   end.
     
   find first tt-cidade-atu no-error.
                     
   ASSIGN pEntidade = "new_cidade":U.
      
   {esp/crm/escrm001a.i "cidade"}        

    RUN InsertIntegrationLog in h-escrm001api (INPUT  "fromERP":U,
                              INPUT  pEntidade,
                              INPUT  cevento,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-cidade:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    EMPTY TEMP-TABLE tt-cidade.
    EMPTY TEMP-TABLE tt-cidade-atu.       
    empty temp-table tt-raw-transfer.
        
end.

IF '{&ativar-envio}' = 'yes' THEN
   RUN piCloseConnection in h-escrm001api. 
        
IF VALID-HANDLE(h-escrm001api) THEN
   DELETE OBJECT h-escrm001api.

DELETE WIDGET-POOL.

PROCEDURE piCarregaBos:
    IF VALID-HANDLE(h-escrm001api) THEN
        DELETE OBJECT h-escrm001api.
        
    RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.
         
END PROCEDURE.



                                

     
