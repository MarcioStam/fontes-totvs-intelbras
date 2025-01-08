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
*******************************************************************************/
{include/i-prgvrs.i ESIMP006RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESIMP006RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-moeda                      as char format "x(30)" no-undo.

{esp/imp/esimp006tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.data-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.data-fim format "99/99/9999" no-label 
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
    c-moeda label "FOB/Frete/Seguro" colon 40 skip
    tt-param.log-despesas format "Sim/N∆o" label "Imprime Despesas" colon 40 skip
    tt-param.log-invoices format "Sim/N∆o" label "Imprime Invoices" colon 40 skip
    tt-param.log-fator-interna format "Sim/N∆o" label "Imprime Fator de Internaá∆o" colon 40 skip
    tt-param.e-mail[1] format "x(60)" colon 40 label "E-Mail" skip
    tt-param.e-mail[2] format "x(60)" colon 40 label "E-Mail" skip
    tt-param.e-mail[3] format "x(60)" colon 40 label "E-Mail" skip
    tt-param.e-mail[4] format "x(60)" colon 40 label "E-Mail" skip
    tt-param.cod-estabel label "Estabelecimento" colon 40 
    skip(1)
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PAR∂METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELEÄ«O * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESS«O * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu†rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find mgcad.empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec°ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_Para_Seguros * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-moeda       = entry(tt-param.ind-moeda, "Dolar,Real").

{include/tt-edit.i}
{include/pi-edit.i}

def var de-tot-fob as dec no-undo.
def var de-tot-frete as dec no-undo.
def var de-tot-seguro as dec no-undo.
def var de-tot-ipi as dec no-undo.
def var de-tot-ii as dec no-undo.
def var de-desp-geral as dec no-undo.
def var de-tot-desp as dec no-undo.
def var de-fi as dec no-undo.
def var c-via as char format "x(15)" extent 8
  initial["Rodovi†rio","Aerovi†rio","Mar°timo","Ferrovi†rio","RodoFerrovi†rio","Ro
dofluvial","RodoAerovi†rio","Outros"] no-undo.
def var l-veiculo as log label "  Ve°culo" format "Imprime/N∆o Imprime" initial no no-undo.
def var l-fatur as log label   "  Faturas" format "Imprime/N∆o Imprime" initial no no-undo.
def var c-ordem as char no-undo.
def var c-situacao as char format "x(40)" extent 5
  initial ["N∆o Embarcados","Embarcados","No EADI", "Aguardando NF","Aguardando Conferància"] no-undo.
def var de-tot-sit as dec no-undo.
def var de-tot-emb as dec no-undo.
def var de-cotacao as dec format ">9.9999" initial 1 label "  Cotaá∆o" no-undo.
  
def temp-table tt-emb no-undo
  field embarque like embarque-imp.embarque
  field situacao as int
  field vl-frete-us as dec
  field vl-seguro-us as dec
  field vl-frete-r as dec
  field vl-seguro-r as dec
  field peso as dec
  field canal like pto-contr.descricao
  field origem like pto-contr.descricao
  field dt-embarque as date format "99/99/9999"
  field dt-ent-eadi as date format "99/99/9999"
  field dt-sai-eadi as date format "99/99/9999"
  field dt-ent-int  as date format "99/99/9999"
  field data-di like embarque-imp.data-di
  field taxa-di as dec format ">>9.9999"
  field ii as dec  format ">>>,>>9.99"
  field ipi as dec format ">>>,>>9.99"
  index codigo is primary situacao data-di embarque.


def temp-table tt-desp no-undo
  field cod-desp like desp-imp.cod-desp
  field valor as dec.

def temp-table tt-erro-2 no-undo
  field embarque like embarque-imp.embarque
  field tipo as log format "Erro/Advertància"
  field erro as char format "x(70)".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{upc/btb910za-upc.i}
{esp/es0006a.i}
{esp/es0006.i}
{esp/eslib.i}
{esp/showmsg.i}
{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run pi-gera-relat in this-procedure.
    run pi-gera-email in this-procedure.
    
    run pi-finalizar in h-acomp.
    
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    

    page.
    
    disp c-liter-sel
         tt-param.log-despesas
         tt-param.log-invoices
         tt-param.log-fator-interna
         tt-param.e-mail[1] 
         tt-param.e-mail[2] 
         tt-param.e-mail[3] 
         tt-param.e-mail[4] 
         tt-param.data-ini 
         tt-param.data-fim 
         c-liter-par         
         c-moeda
         tt-param.cod-estabel 
         c-liter-imp
         c-destino
         tt-param.arquivo   
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-imprime-despesas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-despesas Procedure 
PROCEDURE imprime-despesas PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign de-tot-desp = 0.
  /*    put "<TD>" .
  assign c-tam-tab = "200".
  run html-ini-tab.
  run html-ini-lin-tab.
  */
  for each desp-imp no-lock
     where desp-imp.cod-desp > 1  :
    find desp-embarque no-lock
      where desp-embarque.cod-estabel = tt-param.cod-estabel
        and desp-embarque.embarque = embarque-imp.embarque
        and desp-embarque.cod-desp = desp-imp.cod-desp no-error.
    if avail desp-embarque then
    do:
      if desp-embarque.mo-codigo = 0 then
      run html-con-tab(string(desp-embarque.val-desp  / de-cotacao,">,>>>,>>9.99"),"right").
      else
      run html-con-tab(string(desp-embarque.val-desp,">,>>>,>>9.99"),"right").
    end.

    else
    run html-con-tab(string(0,">,>>>,>>9.99")
      ,"right").
    .
    if avail desp-embarque then
    do:
      find tt-desp where tt-desp.cod-desp = desp-imp.cod-desp.
      if desp-embarque.mo-codigo = 0 then
      assign de-tot-desp = de-tot-desp + desp-embarque.val-desp / de-cotacao
        tt-desp.valor = tt-desp.valor + desp-embarque.val-desp / de-cotacao .
      else
      assign de-tot-desp = de-tot-desp + desp-embarque.val-desp
        tt-desp.valor = tt-desp.valor + desp-embarque.val-desp.

    end.
  end.
  run html-con-w-tab(string(de-tot-desp,">,>>>,>>9.99"),"right","40%").
  /*    run html-fim-lin-tab.


  run html-fim-tab.
  put "</TD>".
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprime-faturas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-faturas Procedure 
PROCEDURE imprime-faturas PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  put "<TD>" .
  assign c-tam-tab = "200".
  run html-ini-tab.
  for each invoice-emb-imp no-lock
      where invoice-emb-imp.cod-estabel = tt-param.cod-estabel
        and invoice-emb-imp.embarque = embarque-imp.embarque:
    run html-ini-lin-tab.
    run html-con-w-tab(string(invoice-emb-imp.nr-invoice),"right","40%").
    run html-con-w-tab(string(invoice-emb-imp.vl-invoice,">,>>>,>>9.99")
      ,"right","60%").
    run html-fim-lin-tab.
  end.
  run html-fim-tab.
  put "</TD>".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-busca-cotacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cotacao Procedure 
PROCEDURE pi-busca-cotacao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter da-data as date no-undo.

  find cotacao no-lock
    where cotacao.mo-codigo   = 1
    and cotacao.ano-periodo = string(year(da-data),"9999") +
    string(month(da-data),"99")
    no-error.

  if avail cotacao and cotacao.cotacao[day(da-data)] <> 0 then
  do:
    assign de-cotacao = cotacao.cotacao[day(da-data)].
  end.
  else
  assign de-cotacao = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-gera-email) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-email Procedure 
PROCEDURE pi-gera-email PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-arquivo as char no-undo.
    def var i as int no-undo.
    def var c-remetente as char no-undo.
    
    assign c-arquivo = session:temp-directory + "esimp006.htm".
    
    output to value(c-arquivo) convert target session:charset.
    
    run html-inicio("Relat¢rio para Seguro").

    assign c-tam-tab = "750".


    for each tt-emb
        break by tt-emb.situacao
        by tt-emb.data-di
        by tt-emb.embarque:


      if first-of(tt-emb.situacao) then
      do:

        run html-ini-tab.
        run html-ini-lin-tab.
        run html-cab-tab("DI").
        run html-cab-tab("Data DI").
        run html-cab-tab("Taxa DI").
        run html-cab-tab("Origem").
        run html-cab-tab("Nome").
        run html-cab-tab("Tipo").
        run html-cab-tab("Embarque").
        run html-cab-tab("Conhecimento").
        run html-cab-tab("Veiculo").
        run html-cab-tab("Peso").
        run html-cab-tab("FOB US$").
        run html-cab-tab("Frete US$").
        run html-cab-tab("Seguro US$").
        run html-cab-tab("II").
        run html-cab-tab("IPI").
        run html-cab-tab("DT Embarque").
        run html-cab-tab("DT Ent. EADI").
        run html-cab-tab("DT Sai. EADI").
        run html-cab-tab("Entrada").
        run html-cab-tab("Canal").
        if tt-param.log-invoices then
        run html-cab-tab("Invoices (Us$) ").
        if tt-param.log-despesas then
        do:
          for each tt-desp:
            delete tt-desp.
          end.
          for each desp-imp no-lock
             where desp-imp.cod-desp > 1:
            run html-cab-tab(desp-imp.descricao).
            create tt-desp.
            assign tt-desp.cod-desp = desp-imp.cod-desp.
          end.
          run html-cab-tab("Total Desp").
        end.
        if tt-param.log-fator-interna then
        run html-cab-tab("FI").

        run html-fim-lin-tab.
        assign de-tot-sit = 0.
      end.
      find embarque-imp 
           where embarque-imp.cod-estabel = tt-param.cod-estabel
             and embarque-imp.embarque = tt-emb.embarque no-lock.
      assign de-tot-emb = 0.
      for each ordens-embarque no-lock
          where ordens-embarque.cod-estabel = tt-param.cod-estabel
            and ordens-embarque.embarque = tt-emb.embarque
          break by ordens-embarque.embarque:
        find ordem-compra where ordem-compra.numero-ordem =
          ordens-embarque.numero-ordem no-lock.
        find cotacao-item
          where cotacao-item.numero-ordem =
          ordem-compra.numero-ordem
          and cotacao-item.cot-aprovada no-lock.
        assign de-tot-emb = de-tot-emb +
          ordens-embarque.qt-do-forn * ordem-compra.pre-unit-for.


        if last-of(ordens-embarque.embarque) then
        do:
          find emitente no-lock where emitente.cod-emitente =
            ordem-compra.cod-emitente.
          run html-ini-lin-tab.
          run html-con-tab(embarque-imp.declaracao-import,"center").
          run html-con-tab(embarque-imp.data-di,"right").
          run html-con-tab(tt-emb.taxa-di,"right").
          run html-con-tab(tt-emb.origem,"center").
          run html-con-tab(emitente.nome-abrev,"center").
          run html-con-tab(c-via[embarque-imp.cod-via-transp],"center") .
          run html-con-tab(tt-emb.embarque,"center").
          if embarque-imp.cod-conhecto-master <> "" then
          run html-con-tab(embarque-imp.cod-conhecto-master,"center").
          else
          run html-con-tab("&nbsp;","right").

          if substring(embarque-imp.char-1,1,20) <> "" then
          run html-con-tab(substring(embarque-imp.char-1,1,20), "center").
          else
          run html-con-tab("&nbsp;","right").
          run html-con-tab(string(tt-emb.peso,">,>>9.9999"),"right").
          run html-con-tab(string(if tt-param.ind-moeda = 1 then de-tot-emb else
          de-tot-emb * tt-emb.taxa-di ,">>>,>>>,>>9.99"),"right").
          run html-con-tab(string(if tt-param.ind-moeda = 1 then tt-emb.vl-frete-us else 
          tt-emb.vl-frete-us * tt-emb.taxa-di  ,">>>,>>9.99"),"right").
          run html-con-tab(string(if tt-param.ind-moeda = 1 then tt-emb.vl-seguro-us else
          tt-emb.vl-seguro-us * tt-emb.taxa-di ,">>>,>>9.99") ,"right").
          run html-con-tab(string(tt-emb.ii,">>>,>>9.99"),"right").
          run html-con-tab(string(tt-emb.ipi,">>>,>>9.99"),"right").

          assign de-tot-fob    = de-tot-fob    + if tt-param.ind-moeda = 1 then de-tot-emb
                                                 else de-tot-emb *                                                  tt-emb.taxa-di
                 de-tot-frete  = de-tot-frete  + if tt-param.ind-moeda = 1 then                                                  tt-emb.vl-frete-us
                                                 else
                                                 tt-emb.vl-frete-us *                                                             tt-emb.taxa-di
                 de-tot-seguro = de-tot-seguro + if tt-param.ind-moeda = 1 then                                                  tt-emb.vl-seguro-us
                                                 else
                                                 tt-emb.vl-seguro-us  *
                                                 tt-emb.taxa-di
                 de-tot-ii     = de-tot-ii     + tt-emb.ii
                 de-tot-ipi    = de-tot-ipi    + tt-emb.ipi.
          
          run html-con-tab(tt-emb.dt-embarque,"right").
          run html-con-tab(tt-emb.dt-ent-eadi,"right").
          run html-con-tab(tt-emb.dt-sai-eadi,"right").
          run html-con-tab(tt-emb.dt-ent-int,"right").
          run html-con-tab(tt-emb.canal,"left").

          if tt-param.log-invoices then
          run imprime-faturas in this-procedure.
          if tt-param.log-despesas then
          run imprime-despesas in this-procedure.
          if tt-param.log-fator-interna then
          run html-con-tab(string((de-tot-desp + de-tot-emb) / de-tot-emb,">>>,>>9.99" ),"right").


          run html-fim-lin-tab.
          assign de-tot-sit = de-tot-sit + de-tot-emb.

        end.
      end.
      /*
      if last-of(tt-emb.situacao) then do:
      run html-tot-tab(8,"Total da Situacao",string(de-tot-sit,">>>,>>>,>>9.9~9")).
      run html-con-tab(string(de-tot-sit * de-cotacao,">>>,>>>,>>9.99"),"righ~t").
      run html-fim-lin-tab-tab.
      end.
      */

    end.


      run html-ini-lin-tab.
      run html-con-tab("TOTAIS","center").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","center").
      run html-con-tab("&nbsp;","center").
      run html-con-tab("&nbsp;","center") .
      run html-con-tab("&nbsp;","center").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab(string(de-tot-fob,">>>,>>>,>>9.99"),"right").
      run html-con-tab(string(de-tot-frete,">>>,>>9.99"),"right").
      run html-con-tab(string(de-tot-seguro,">>>,>>9.99"),"right").
      run html-con-tab(string(de-tot-ii,">>>,>>9.99"),"right").
      run html-con-tab(string(de-tot-ipi,">>>,>>9.99"),"right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").
      run html-con-tab("&nbsp;","right").

      if tt-param.log-invoices then
      run html-con-tab("&nbsp;","right").
      if tt-param.log-despesas then do:
          assign de-desp-geral = 0.
          for each tt-desp:
                run html-con-tab(string(tt-desp.valor,">,>>>,>>9.99"),"right").
                assign de-desp-geral = de-desp-geral + tt-desp.valor.
          end.
          run html-con-tab(string(de-desp-geral,">,>>>,>>9.99"),"right").
      end.

      if tt-param.log-fator-interna then
      run html-con-tab("&nbsp;","right").

      run html-fim-lin-tab.

    run html-fim-lin-tab.
    
    output close.
    
    run pi-seta-titulo in h-acomp (input "Enviando E-Mail":U). 
    
    do i = 1 to 4:
        if tt-param.e-mail[i] > "" then
            assign c-endereco = c-endereco + tt-param.e-mail[i] + ",".
    end.    
    
    assign substring(c-endereco, max(1, length(c-endereco)), 1) = ""
           c-remetente = "ems@intelbras.com.br".
    
    RUN enviaMail (INPUT c-remetente,
                   INPUT c-endereco,
                   INPUT "Relaá∆o de Embarques para Seguradora",
                   INPUT "Segue em anexo relat¢rio com os embarques para seguradora",
                   INPUT c-arquivo).
                   
    if return-value = "OK" then                       
        RUN ShowMessage (2, "E-Mail enviado com sucesso", "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-gera-relat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat Procedure 
PROCEDURE pi-gera-relat PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each embarque-imp no-lock
        where embarque-imp.data-di >= tt-param.data-ini
        and embarque-imp.data-di <= tt-param.data-fim:
        
        run pi-acompanhar in h-acomp (input "Embarque: " + embarque-imp.embarque).

      assign de-tot-desp = 0
        de-fi = 0.

      create tt-emb.
      assign tt-emb.embarque = embarque-imp.embarque
        tt-emb.situacao = 1
        tt-emb.data-di = embarque-imp.data-di.

      run pi-busca-cotacao in this-procedure (embarque-imp.data-di - 1).
      assign tt-emb.taxa-di = de-cotacao.

      /* pega o valor de seguro */

      for each desp-embarque no-lock
          where desp-embarque.cod-estabel = tt-param.cod-estabel
          and desp-embarque.embarque = embarque-imp.embarque
          and desp-embarque.cod-desp = 22:
        if desp-embarque.mo-codigo = 1 then
        assign tt-emb.vl-seguro-us = desp-embarque.val-desp.
        else
        assign tt-emb.vl-seguro-r = desp-embarque.val-desp.
      end.

      /* pega o valor do frete */
      for each desp-embarque no-lock
          where desp-embarque.cod-estabel = tt-param.cod-estabel
          and desp-embarque.embarque = embarque-imp.embarque
          and desp-embarque.cod-desp = 3:
        if desp-embarque.mo-codigo = 1 then
        assign tt-emb.vl-frete-us = desp-embarque.val-desp.
        else
        assign tt-emb.vl-frete-r = desp-embarque.val-desp.
      end.


      find first historico-embarque of embarque-imp no-lock no-error.
      if not avail historico-embarque then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro     = "Embarque sem registro de acompanhamento".
        delete tt-emb.
        next.
      end.
      find first ordens-embarque of embarque-imp no-lock no-error.
      if not avail ordens-embarque then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro     = "Embarque sem ordens".
        delete tt-emb.
        next.
      end.
      find itinerario where itinerario.cod-itiner = historico-embarque.cod-itiner ~        no-lock.
      if itinerario.pto-embarque = 0 then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro     = "Itiner†rio " + string(historico-embarque.cod-~itiner) + " n∆o tem ponto de embarque definido".
        delete tt-emb.
        next.
      end.

      find historico-embarque of embarque-imp
        where historico-embarque.cod-pto-contr = itinerario.pto-embarque       ~  no-lock no-error.
      if not avail historico-embarque then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro = "Acompanhamento n∆o tem ponto de embarque".
        delete tt-emb.
        next.
      end.
      find pto-contr where pto-contr.cod-pto-contr = itinerario.pto-embarque         no-lock.
      assign tt-emb.origem = pto-contr.descricao.
      if historico-embarque.dt-efetiva <> ? then
      do:
        assign tt-emb.situacao = 2
          tt-emb.dt-embarque = historico-embarque.dt-efetiva.
        if embarque-imp.cod-conhecto-master = "" then
        do:
          create tt-erro-2.
          assign tt-erro-2.embarque = embarque-imp.embarque
            tt-erro-2.tipo     = no
            tt-erro-2.erro = "Embarque j† embarcado sem n£mero de conhecimento".

        end.
      end.
      else
      do:
        if embarque-imp.cod-conhecto-master <> "" then
        do:
          create tt-erro-2.
          assign tt-erro-2.embarque = embarque-imp.embarque
            tt-erro-2.tipo     = no
            tt-erro-2.erro = "Embarque ainda n∆o embarcado com n£mero de conhecimento".
        end.
        assign tt-emb.dt-embarque = historico-embarque.dt-ult-prev.
      end.

      if itinerario.pto-eadi <> 0 then
      do:
        find historico-embarque of embarque-imp
          where historico-embarque.cod-pto-contr = itinerario.pto-eadi          ~           no-lock no-error.
        if not avail historico-embarque then
        do:
          create tt-erro-2.
          assign tt-erro-2.embarque = embarque-imp.embarque
            tt-erro-2.tipo     = yes
            tt-erro-2.erro     = "Acompanhamento sem ponto de entrada no Eadi".
     /*     delete tt-emb.
          next.
          */
        end.
        else do:
            if historico-embarque.dt-efetiva <> ? then
            assign tt-emb.situacao = 3
              tt-emb.dt-ent-eadi = historico-embarque.dt-efetiva.
            else
            assign tt-emb.dt-ent-eadi = historico-embarque.dt-ult-prev.
        end.
        find historico-embarque of embarque-imp
          where historico-embarque.cod-pto-contr = 33 no-lock no-error.
        if not avail historico-embarque then
        do:
          create tt-erro-2.
          assign tt-erro-2.embarque = embarque-imp.embarque
            tt-erro-2.tipo     = yes
            tt-erro-2.erro     = "Acompanhamento sem ponto de sa°da no ~Eadi" .
       /*   delete tt-emb.
          next. */
        end.
        else do:
            assign tt-emb.dt-sai-eadi = historico-embarque.dt-ult-prev.
            if historico-embarque.dt-efetiva <> ? then
            assign tt-emb.dt-sai-eadi = historico-embarque.dt-efetiva.
        end.

      end.
      find historico-embarque of embarque-imp
        where historico-embarque.cod-pto-contr = itinerario.pto-chegada     ~               no-lock no-error.
      if not avail historico-embarque then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro = "Acompanhamento n∆o tem ponto de entrada".
        delete tt-emb.
        next.
      end.
      if historico-embarque.dt-efetiva <> ? then
      assign tt-emb.situacao = 4
        tt-emb.dt-ent-int = historico-embarque.dt-efetiva.
      else
      assign tt-emb.dt-ent-int = historico-embarque.dt-ult-prev.

      /* verifica se a nota ja foi emitida */
      find historico-embarque of embarque-imp
        where historico-embarque.cod-pto-contr = 44 no-lock no-error.
      if not avail historico-embarque then
      do:
        create tt-erro-2.
        assign tt-erro-2.embarque = embarque-imp.embarque
          tt-erro-2.tipo     = yes
          tt-erro-2.erro = "Acompanhamento n∆o tem ponto de emiss∆o de nota".
        delete tt-emb.
        next.
      end.
      if historico-embarque.dt-efetiva <> ? then
      assign tt-emb.situacao = 5
        tt-emb.dt-ent-int = historico-embarque.dt-efetiva.
      else
      assign tt-emb.dt-ent-int = historico-embarque.dt-ult-prev.


      /* soma pesos */

      for each ordens-embarque no-lock
          where ordens-embarque.cod-estabel = tt-param.cod-estabel
            and ordens-embarque.embarque = embarque-imp.embarque:
        assign tt-emb.peso = tt-emb.peso + ordens-embarque.peso-bruto.

      end.

      assign tt-emb.situacao = 5.

      assign tt-emb.canal = "&nbsp;".
      for each historico-embarque of embarque-imp no-lock,
          each pto-contr no-lock
          where pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr
          and pto-contr.descricao matches("*canal*").
        assign tt-emb.canal = pto-contr.descricao.
      end.


      find first docum-est 
           where
             docum-est.nat-operacao begins "3"
             and docum-est.serie = "4"
             and    substring(docum-est.char-1,1,12) = embarque-imp.embarque 
                 no-lock no-error.
      if not avail docum-est then do:
      find first docum-est 
           where
             docum-est.nat-operacao begins "3"
             and docum-est.serie = "2"
             and    substring(docum-est.char-1,1,12) = embarque-imp.embar~que 
                 no-lock no-error.
                 
                 
      end.
      
      if avail docum-est then
      do:
      
      
        assign tt-emb.ipi = docum-est.ipi-deb-cre.
        for each docum-est-cex
            where docum-est-cex.nro-docto    = string(docum-est.nro-docto)
            and docum-est-cex.nat-operacao = docum-est.nat-operacao
            and docum-est-cex.serie-docto  = docum-est.serie-docto
            and docum-est-cex.cod-emitente = docum-est.cod-emitente
            and docum-est-cex.cod-desp     = 1:
          assign tt-emb.ii = docum-est-cex.val-desp.
        end.
      end.
      else do:
      end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

