&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
compile \\tsclient\c\fontes\esp\imp\esimp004rp.p save into c:\temp\esp.
*******************************************************************************/
{include/i-prgvrs.i ESIMP004RP 2.04.00.000}

/* ***************************  Definitions  ************************** */
{esp/imp/esimp004tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

def temp-table tt-erro-emb
    field embarque like embarque-imp.embarque
    field tipo as log format "Erro/Advertencia"
    field erro as char format "x(70)".

{esp/imp/esimp000.i1} /*tt-emb*/

def temp-table tt-itens
    field num-pedido like pedido-compr.num-pedido
    field numero-ordem like ordem-compra.numero-ordem
    field parcela like prazo-compra.parcela
    field it-codigo like item.it-codigo
    field descricao as char format "x(36)"
    field quantidade like ordens-embarque.quantidade
    index codigo is primary it-codigo.

{esp/es0006a.i}
{esp/es0006.i}  
{esp/utp/envio-email.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Lendo embarques":U). 
    
    find first tt-param no-error.
    
    run pi-leitura-embarques.
    
    run pi-inicializar in h-acomp (input "Gerando texto E-Mail":U). 
    
    run pi-gera-texto.
    
    run pi-inicializar in h-acomp (input "Enviando E-Mail":U). 
    
    run pi-envia-email.
    
    run pi-finalizar in h-acomp.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-imprime-faturas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-faturas Procedure 
PROCEDURE imprime-faturas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-cod-tit-ap as char no-undo.
    def var de-val-orig as dec no-undo.
    def var de-val-sdo-tit-ap as dec no-undo.
    def var de-tot-ci-orig as dec no-undo.    
    def var de-tot-ci-saldo as dec no-undo.

    put "<TD>" .
    assign c-tam-tab = "200".
    run html-ini-tab.
    for each invoice-emb-imp no-lock
       where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel 
         and invoice-emb-imp.embarque    = embarque-imp.embarque:
         for each pagamento-invoice no-lock
            where pagamento-invoice.embarque = invoice-emb-imp.embarque
              and pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice
              and pagamento-invoice.parcela = invoice-emb-imp.parcela:
        
              run esp/imp/esimp004rp-1.p (input embarque-imp.cod-estabel,
                                          input emitente.cod-emitente,
                                          input pagamento-invoice.nr-pagamento,
                                          output c-cod-tit-ap,
                                          output de-val-orig,
                                          output de-val-sdo-tit-ap).
                                          
              run html-ini-lin-tab.
              if c-cod-tit-ap ne "" then do:
                run html-con-w-tab(string(c-cod-tit-ap),"right","20%").
                run html-con-w-tab(string(de-val-orig,">,>>>,>>9.99"),"right","40%").
                 run html-con-w-tab(
                 string(de-val-sdo-tit-ap,">,>>>,>>9.99"),"right","40%").
                 assign de-tot-ci-orig = de-tot-ci-orig + de-val-orig
                        de-tot-ci-saldo = de-tot-ci-saldo + de-val-sdo-tit-ap.
              end.
              else do:
                run html-con-w-tab("&nbsp;","right","20%").
                run html-con-w-tab("&nbsp;","right","40%").
                run html-con-w-tab("&nbsp;","right","40%").
              
              end.
              run html-fim-lin-tab.  
        end.
    end.        
    run html-fim-tab.
    put "</TD>".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprime-itens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-itens Procedure 
PROCEDURE imprime-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-ordem as char no-undo.
    
    put "<TD>" .
    assign c-tam-tab = "450".
    run html-ini-tab.
    for each tt-itens:

          assign c-ordem = 
          '<a href="JavaScript:popWindow('  + "'http://ecenter2.intelbras.com.br/tools/teste/flavio.php?oc=" + string(tt-itens.numero-ordem) + "'" + 
            ", 'NewItem', 560,390,'no', 'no');" + '"' + '>' + string(tt-itens.numero-ordem) + '</a>'.
           
          run html-ini-lin-tab.
          run html-con-w-tab(string(tt-itens.num-pedido),"right","15%").
          run html-con-w-tab(c-ordem,"right","20%").
          run html-con-w-tab(string(tt-itens.parcela),"right","5%").
          run html-con-w-tab(tt-itens.it-codigo,"right","15%").
          run html-con-w-tab(tt-itens.descricao,"right","30%").
          run html-con-w-tab(string(tt-itens.quantidade),"right","15%").
          run html-fim-lin-tab.  
    end.        
    run html-fim-tab.
    put "</TD>".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-envia-email) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email Procedure 
PROCEDURE pi-envia-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-destinatarios as char no-undo.
    
    for each tt-digita:
        c-destinatarios = c-destinatarios + tt-digita.e-mail + ";".
    end.
    substring(c-destinatarios, max(1, length(c-destinatarios), 1)) = "".
    
    if c-destinatarios > "" then 
        run enviaMail in this-procedure
            (input "intelbras@intelbras.com.br",
             input c-destinatarios,
             input "Saldos dos Embarques",
             input codepage-convert(c-texto-html[1] + "~n" + c-texto-html[2] + "~n" + c-texto-html[4], "iso8859-1", session:charset),
             input c-arquivo).
                
    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-gera-texto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-texto Procedure 
PROCEDURE pi-gera-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-tot-sit as dec no-undo.
    def var c-situacao as char format "x(40)" extent 5 no-undo 
        initial ["N∆o Embarcados","Embarcados","No EADI", "Aguardando NF","Aguardando Conferància"].
    def var de-tot-ci-orig as decimal no-undo.
    def var de-tot-ci-saldo as decimal no-undo.
    def var de-tot-emb as decimal no-undo.

    assign c-arquivo = session:temp-directory + "emb-" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + "-" + SUBstring(STRING(TIME,"hh:mm:ss"),1,2) + SUBstring(STRING(TIME,"hh:mm:ss"),4,2) + ".htm"
           c-arquivo-2 = session:temp-directory + "saldos-emb.htm"
           c-assunto = "Saldos dos Embarques"
           c-texto-html[1] = "Segue em anexo relat¢rio com os saldos dos embarques"
           c-texto-html[2] = "A tabela de erros/advertàncias, mostra embarques que precisam ser revistos."
           c-texto-html[4] = "Os embarques com erro n∆o constam do relat¢rio e portanto n∆o comp‰e saldos.".

    output to value(c-arquivo) convert target "iso8859-1".       
    run html-inicio("Saldos dos Embarques").

    run html-link-origem("Erros").
    put "<BR>".
    for each tt-emb
       break by tt-emb.situacao:
        if first-of(tt-emb.situacao) then do:
            assign de-tot-sit = 0.
            assign c-tit-html =  string(tt-emb.situacao) + "-" + 
            c-situacao[tt-emb.situacao].
            run html-link-origem(c-tit-html).
            put skip "<BR>".
        end.
    end.
    assign c-tam-tab = "750".
    
    run html-link-destino("Erros").
    put skip "<BR>".
    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("Embarque").
    run html-cab-tab("Tipo").
    run html-cab-tab("Erro").
    run html-fim-lin-tab.
    for each tt-erro-emb
        by tt-erro-emb.tipo descending
        by tt-erro-emb.embarque:
        run html-ini-lin-tab.
        run html-con-tab(tt-erro-emb.embarque,"right").
        run html-con-tab(string(tt-erro-emb.tipo,"Erro/Advertància"),"center").
        run html-con-tab(tt-erro-emb.erro,"left").
        run html-fim-lin-tab.
    end.
    
    run html-fim-tab.
    
    
    for each tt-emb
       break by tt-emb.situacao
             by tt-emb.embarque:
             
        run pi-acompanhar in h-acomp (input "Embarque: " + string(tt-emb.embarque)).
             
        for each tt-itens:
            delete tt-itens.
        end.
             

        if first-of(tt-emb.situacao) then do:
            assign c-tit-html =  string(tt-emb.situacao) + "-" + c-s~ituacao[tt-emb.situacao].
            run html-link-destino(c-tit-html).
            run html-titulo(c-tit-html).
            run html-ini-tab.
            run html-ini-lin-tab.
            run html-cab-tab("Embarque").
            run html-cab-tab("Conhecimento").
            if tt-param.l-veiculo then
                run html-cab-tab("Ve°culo").
            run html-cab-tab("DT Embarque").
            run html-cab-tab("DT Ent. EADI").
            run html-cab-tab("DT Sai. EADI").
            run html-cab-tab("Entrada").
            run html-cab-tab("Fornec.").
            run html-cab-tab("Nome").
            run html-cab-tab("Total US$").
            run html-cab-tab("Total R$").
            if l-fatur then do:
                put "<TD>".
                assign c-tam-tab = "200".
                run html-ini-tab.
                run html-con-w-tab("CI","center","20%").
                run html-con-w-tab("Vl. Orig.","center","40%").
                run html-con-w-tab("Saldo","center","40%").
                run html-fim-tab.
                put "</TD>".
            
            end.
            if l-det then do:
                put "<TD>".
                assign c-tam-tab = "450".
                run html-ini-tab.
                run html-con-w-tab("Pedido","center","15%").
                run html-con-w-tab("Ordem","center","20%").
                run html-con-w-tab("P","center","5%").
                run html-con-w-tab("Item","center","15%").
                run html-con-w-tab("Descriá∆o","center","30%").
                run html-con-w-tab("Quantidade","center","15%").
                run html-fim-tab.
                put "</TD>".
            end.
            
            run html-fim-lin-tab.
            assign de-tot-sit = 0
                   de-tot-ci-orig = 0
                   de-tot-ci-saldo = 0.
        end.
        find FIRST embarque-imp 
             where embarque-imp.cod-estabel = tt-emb.cod-estabel
               AND embarque-imp.embarque = tt-emb.embarque no-lock.
         assign de-tot-emb = 0.
         for each ordens-embarque no-lock
            where ordens-embarque.cod-estabel = tt-param.cod-estabel AND
                  ordens-embarque.embarque = tt-emb.embarque
            break by ordens-embarque.embarque:
              find ordem-compra where 
                   ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
              
              IF NOT AVAIL ordem-compra THEN NEXT.

              assign de-tot-emb = de-tot-emb + 
                     ordens-embarque.quantidade * ordem-compra.preco-unit.
              
              if l-det then do:
                  find item where item.it-codigo = ordem-compra.it-codigo no-lock.
                  create tt-itens.
                  assign tt-itens.num-pedido = ordem-compra.num-pedido
                         tt-itens.numero-ordem = ordem-compra.numero-ordem
                         tt-itens.parcela = ordens-embarque.parcela
                         tt-itens.it-codigo = ordem-compra.it-codigo
                         tt-itens.descricao = item.descricao-1 + item.descricao-2
                         tt-itens.quantidade = ordens-embarque.quantidade.
              end.
    
              if last-of(ordens-embarque.embarque) then do:         
                  find emitente no-lock where 
                       emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
                  run html-ini-lin-tab.
                  run html-con-tab(tt-emb.embarque,"right").
                  if embarque-imp.cod-conhecto-master <> "" then
                     run html-con-tab(embarque-imp.cod-conhecto-master,"right").
                  else run html-con-tab("&nbsp;","right").
                  if l-veiculo then do:
                      if substring(embarque-imp.char-1,1,20) <> "" then 
                         run                      html-con-tab(substring(embarque-imp.char-1,1,20),"right").
                      else
                         run html-con-tab("&nbsp;","right").
                  end.
                  run html-con-tab(tt-emb.dt-embarque,"right").
                  run html-con-tab(tt-emb.dt-ent-eadi,"right").
                  run html-con-tab(tt-emb.dt-sai-eadi,"right").
                  run html-con-tab(tt-emb.dt-ent-int,"right").
                  run html-con-tab(emitente.cod-emitente,"right").
                  run html-con-tab(emitente.nome-abrev,"right").
                  run html-con-tab(string(de-tot-emb,">>>,>>>,>>>,>>9.99"),"right").
                  run html-con-tab(string(de-tot-emb * de-cotacao,">>>,>>>,>>>,>>9.99"),"right").
    
                  if l-fatur then run imprime-faturas.
    
                  if l-det then run imprime-itens.  
     
                  run html-fim-lin-tab.
                  assign de-tot-sit = de-tot-sit + de-tot-emb.
                               
              end.
        end.
    
        if last-of(tt-emb.situacao) then do:
            run html-tot-tab(8,"Total da Situaá∆o",string(de-tot-sit,">,>>>,>>>,>>9.9~9")).
            run html-con-tab(string(de-tot-sit * de-cotacao,">>>,>>>,>>>,>>9.99"),"righ~t").
    
            if l-det then do:
                put "<TD>" .
                assign c-tam-tab = "200".
                run html-ini-tab. 
            
         run html-con-w-tab("&nbsp;","right","20%").
         run html-con-w-tab(string(de-tot-ci-orig,">>,>>>,>>9.99"),"right","40%").
         run html-con-w-tab(string(de-tot-ci-saldo,">>>,>>>,>>>,>>9.99"),"right","40%").
                run html-fim-tab.
                run html-fim-tab.
            end.
        end.
    
    end.
    
    run html-fim.
    
    output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-leitura-embarques) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leitura-embarques Procedure 
PROCEDURE pi-leitura-embarques :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each embarque-imp no-lock
       where embarque-imp.situacao = 1 
         AND embarque-imp.cod-estabel = tt-param.cod-estabel:
       
       run pi-acompanhar in h-acomp (input "Embarque: " + string(embarque-imp.embarque)).
       
       {esp/imp/esimp000.i}
    end.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

