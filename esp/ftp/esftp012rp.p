{esp/es0006a.i}
{esp/es0006.i}

{upc/btb910za-upc.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{include/tt-edit.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

  DEF INPUT PARAMETER i-pedido      AS INTEGER.
  DEF INPUT PARAMETER c-cod-usuario AS CHARACTER.
  /*DEFINE VARIABLE h-boes150a        AS HANDLE      NO-UNDO.*/
  DEFINE VARIABLE c-supervisor      AS CHARACTER   NO-UNDO.
  DEF var c-email                   AS CHARACTER   NO-UNDO.
  def var de-preco-total            AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE c-data            AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE c-remetente       AS CHARACTER   NO-UNDO.
  DEF VAR c_chave                   AS CHARACTER.
/*   RUN esbo/boes150a.p PERSISTENT SET h-boes150a.                                                                                    */
/*   RUN busca_supervisor IN h-boes150a (INPUT v_cod_estab_usuar, INPUT c-cod-usuario, OUTPUT c-email, OUTPUT c-supervisor). */
/*   DELETE PROCEDURE h-boes150a.                                                                                                      */

  ASSIGN c-email = "".
  FIND ped-fiscal
       WHERE ped-fiscal.nr-pedido = i-pedido exclusive-LOCK NO-ERROR.

  
  IF AVAIL ped-fiscal THEN DO:

      FIND FIRST int-centro-custo
          WHERE int-centro-custo.cod-estabel = ped-fiscal.cod-estabel
            AND int-centro-custo.cc-codigo   = ped-fiscal.sc-codigo
          NO-LOCK NO-ERROR.
      IF NOT AVAIL int-centro-custo THEN DO:
          MESSAGE "Centro de Custo n∆o encontrado, e-mail enviado para grupo.contabil@intelbras.com.br e grupo.custos@intelbras.com.br para correá∆o do cadastro "
              VIEW-AS ALERT-BOX INFO BUTTONS OK.

          RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                            INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                            INPUT "Centro de Custo n∆o Encontrado",
                            INPUT "Usuario " + c-cod-usuario + " Esta tentando Liberar uma solicitaá∆o de Notas Fiscais e o Centro de Custos " + string(ped-fiscal.sc-codigo) + " n∆o esta Cadastrado para o Estabelecimento " + ped-fiscal.cod-estabel,
                            INPUT "").

      END.
      ELSE DO:
          

           FIND FIRST usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
           IF NOT AVAIL usuar_mestre THEN DO:
               MESSAGE "Supervisor n∆o cadastrado no cadastro de usuarios (usuar_mestre), e-mail enviado para grupo.contabil@intelbras.com.br para correá∆o do cadastro "
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.

               RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                                 INPUT "grupo.contabil@intelbras.com.br",
                                 INPUT "Supervisor nao cadastrado",
                                 INPUT "Supervisor n∆o cadastrado no cadastro de usuarios (usuar_mestre). O usuario " + c-cod-usuario +  " Esta tentando Liberar uma solicitaá∆o de Notas Fiscais e o Supervisor " + string(INT-CENTRO-CUSTO.COD_USUARIO) + "  nao esta cadastrado no cadastrado de usuarios, CCUSTO " + string(ped-fiscal.sc-codigo) + " Estabelecimento " + ped-fiscal.cod-estabel,
                                 INPUT "").

           END.
           ELSE DO:
               ASSIGN c-email      = usuar_mestre.cod_e_mail_local
                      c-supervisor = usuar_mestre.cod_usuario.

           END.
          
      END.
            
      IF c-email <> "" THEN DO:

        RUN piGeraSolNota.
      END.
      ELSE DO:
          MESSAGE "e-mail do Supervisor em branco, e-mail enviado para grupo.contabil@intelbras.com.br para correá∆o do cadastro"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.

          RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                            INPUT "grupo.contabil@intelbras.com.br",
                            INPUT "E-mail em branco",
                            INPUT "Usuario " + c-cod-usuario + " Esta tentando Liberar uma solicitaá∆o de Notas Fiscais e o E-mail do supervisor esta em branco, Supervisor " + STRING(INT-CENTRO-CUSTO.COD_USUARIO) + "  nao esta cadastrado no cadastrado de usuarios, CCUSTO " + string(ped-fiscal.sc-codigo) + " Estabelecimento " + ped-fiscal.cod-estabel,
                            INPUT "").

      END.
  END.
  ELSE DO:
      MESSAGE "Pedido N∆o Encontrado " i-pedido
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

  

  RETURN "ok":U.

PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.
    
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.
    
    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.


    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-mail:

        FOR EACH tt-envio2.   DELETE tt-envio2.   END.
        FOR EACH tt-mensagem. DELETE tt-mensagem. END.

        ASSIGN c-lst-arq  = tt-mail.arquivo. 
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
               tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
               tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
               tt-envio2.arq-anexo         = c-lst-arq               /* Arquivo Tempor†rio */
               tt-envio2.formato           = "TEXTO".
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */

        /**** coloquei em comentario pois n∆o mostra o programa que foi chamado,
        somente mostra o nome das viewers, trigger, etc   ****/
/*        REPEAT WHILE PROGRAM-NAME(level) <> ?.
               CREATE tt-mensagem.
               ASSIGN tt-mensagem.seq-mensagem = level + 2
                      tt-mensagem.mensagem     = "Nivel: " + string(LEVEL) +
                                                 "  Programa: " + PROGRAM-NAME(level) + CHR(13)
                      level = level + 1.
        END.
  */
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN
           OUTPUT TO value(TRIM(c-cod-usuario) + "erros-comerc.LOG") APPEND.
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END.
    RETURN "OK":U.
END PROCEDURE.
PROCEDURE piGeraSolNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    def var c-agente           as char                     no-undo.
    def var c-embarque         as char                     no-undo.
    def var c-desembarque      as char                     no-undo.
    def var de-total-compras   as decimal                  no-undo.
    def var c-mess-err         as char                     no-undo.
    def var c-nr-pedido        as char format "x(100)"     no-undo.
    def var c-tit-ped          as char format "x(100)"     no-undo.
    def var c-dados-empresa    as char format "x(300)"     no-undo.
    def var c-dados-cliente    as char format "x(600)"     no-undo.
    def var c-imagem           as char format "x(120)"     no-undo.    
    def var c-complementos     as char format "x(300)"     no-undo.
    def var c-mensagem1        as char format "x(500)"     no-undo.
    def var c-titulo           as char                     no-undo.
    def var de-total-geral     as decimal                  no-undo.
    def var de-total-sipi      as decimal                  no-undo.
    def var de-preco-sipi      as decimal                  no-undo.
    def var de-ipi             as decimal                  no-undo.
    def var de-preco-tot-aux like de-preco-total           NO-UNDO.
    def var de-desc-total    like de-preco-total           NO-UNDO.
    def var de-enc             as DECIMAL                  NO-UNDO.
    def var de-enc-total     like ordem-compra.preco-unit  NO-UNDO.
    def var c-totais           as char format "x(300)"     no-undo.
    def var c-comprador      like cont-emit.nome           no-undo.
    def var c-vendedor       like atendente.nm-oper no-undo.
    def var c-desc-pagto     like cond-pagto.descricao     no-undo.
    def var c-observacoes-1    as char format "x(500)"     no-undo.
    def var c-desc-ad          as char                     no-undo.
    def var de-vl-frete        as dec                      no-undo.
    def var de-vl-pagar        as dec                      no-undo.
    def var c-cobranca         as char                     no-undo.
    def var c-tipo-pedido      as char                     no-undo.
    DEF VAR c_acao             AS CHARACTER                NO-UNDO.
    def var de-vl-orcamento  like ped-item.vl-preuni       no-undo.
    def var de-vl-ipi        like ped-item.aliquota-ipi    no-undo.
    
    def buffer bf-emitente for emitente.
    FIND ped-fiscal
         WHERE ped-fiscal.nr-pedido = i-pedido exclusive-LOCK NO-ERROR.
    
    find emitente no-lock
         where emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.
    find transporte no-lock
         where  transporte.cod-transp = ped-fiscal.cod-transp NO-ERROR.    

    find estabelec where
         estabelec.cod-estabel = ped-fiscal.cod-estabel no-lock no-error.
    if avail estabelec then do:
        find mgcad.empresa where
             mgcad.empresa.ep-codigo = estabelec.ep-codigo no-lock no-error.
    end.

    assign /*c-arquivo = session:temp-directory + "/esftp012.html". */
           c-arquivo = c-dir-arquivo-session + "/esftp012.html".
           c-titulo = "Solicitaá∆o de Emiss∆o de Nota Fiscal " + string(ped-fiscal.nr-pedido).
           
    output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.

    run html-inicio ("Solicitaá∆o de Nota Fiscal").

    find bf-emitente where
         bf-emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

    assign c-vendedor = "".
        
    find first cont-emit
         where cont-emit.cod-emitente = emitente.cod-emitente no-lock no-error.
    if avail cont-emit then
        assign c-comprador = cont-emit.nome.

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = ped-fiscal.nat-oper NO-ERROR.

    assign c-data      = string(day(ped-fiscal.dt-emissao),"99") 
                       + "/"
                       + string(month(ped-fiscal.dt-emissao),"99")
                       + "/"
                       + string(year(ped-fiscal.dt-emissao), "9999")
           c-nr-pedido = CHR(10) 
                       + "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(ped-fiscal.nr-pedido, ">>>,>>9")
                       + " - "
                       + c-data
                       + "</FONT> </TH>"                       
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + "<B>Endereáo:</B> " + estabelec.endereco + " - " + estabelec.bairro + "<BR>"
                           + "<B>Cidade:</B> " + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"                          
                           + "<B>Fone:</B> "
                           + bf-emitente.telefone[1]
                           + "<BR>"
                           + "<B>Home:</B> " + bf-emitente.home-page
                           + "<BR>"                          
                           + "<B>CNPJ:</B> " + trim(string(estabelec.cgc)) + "<BR>"
                           + "<B>I.Estadual:</B> " + trim(string(estabelec.ins-estadual))
                           + "<BR>"                              
                           + "<B>Vendedor:</B> " + trim(c-vendedor)                           
                           + "<BR><BR><BR>"
                           + "<B>Transportadora:</B> " + string(ped-fiscal.cod-transp)
           c-dados-cliente =  "<B>Cliente:</B> " + string(emitente.cod-emitente) + " - " + emitente.nome-abrev + "</B>"
                              + "<BR>"                              
                              + "<B>Raz∆o Social:</B> " + emitente.nome-emit 
                              + "<BR>"
                              + "<B>Endereáo:</B> " + emitente.endereco + " - " + emitente.bairro
                              + "<BR>"
                              + "<B>Cidade:</B> " + emitente.cidade + " - " + emitente.estado
                              + "<BR>"
                              + "<B>Fone:</B> " + emitente.telefone[1] + "  -  " + "<B>Fax:</B> " + emitente.telefax
                              + "<BR>"
                              + "<B>CNPJ:</B> " + emitente.cgc 
                              + "<BR>"                              
                              + "<B>Nat.Oper:</B> " + IF  AVAIL natureza-ped-fiscal THEN natureza-ped-fiscal.descricao ELSE STRING(ped-fiscal.nat-oper)
                              + "<BR><BR>"
                              + "<B>Redespacho:</B> " 
                              c-complementos = "Condicao de Pagamento: "
                            + c-desc-pagto
                            + "<BR>Transportador:" 
                            + transporte.nome
           c-mensagem1    = "" 
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Solicitaá∆o de Nota Fiscal"
                            + "</FONT>".

    IF estabelec.cod-estabel = "101" OR estabelec.cod-estabel = "104" THEN
         ASSIGN  c-imagem   = "<TH> <FONT FACE=" + CHR(34) + "Arial Black, sans-serif" + CHR(34) + " SIZE=5 COLOR=#33FF66> Intelbras - Matriz </FONT> </TH>". 

    IF estabelec.cod-estabel = "102" OR estabelec.cod-estabel = "103" OR estabelec.cod-estabel = "301" THEN
         ASSIGN  c-imagem   = "<TH> <FONT FACE=" + CHR(34) + "Arial Black, sans-serif" + CHR(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 
    
    run html-ini-tab.
    run html-ini-lin-tab.
    put "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=4> Atená∆o: Esta solicitaá∆o de Notas Fiscais necessita de sua aprovaá∆o. Verifique os dados e aprove ou reprove utilizando o link abaixo </FONT> </TH>" FORMAT "x(300)" skip.
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    
    run html-ini-lin-tab.
    put c-imagem skip.

    run html-cab-tab(c-tit-ped).
    
    put c-nr-pedido skip . 
    
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.    
    
    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
    
    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"  trim(c-dados-cliente) format "x(600)" "</TD>" skip. 
        
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("C¢digo").
    run html-cab-tab("Descriá∆o"). 
    run html-cab-tab("Qtde").
    run html-cab-tab("Vlr. Unit.").
    run html-cab-tab("Vlr. Total").
    run html-cab-tab("D.Ad.%").
    run html-cab-tab("IPI").
    run html-fim-lin-tab.
    
    assign de-vl-orcamento = 0
           de-vl-ipi = 0.
               
    for each it-ped-fiscal of ped-fiscal no-lock:
        find item where item.it-codigo = it-ped-fiscal.it-codigo no-lock no-error.
        
        assign de-vl-orcamento = de-vl-orcamento + (it-ped-fiscal.qtde * it-ped-fiscal.vl-unit).

        assign de-vl-ipi  = de-vl-ipi + (it-ped-fiscal.qtde * it-ped-fiscal.vl-unit) * (it-ped-fiscal.aliquota-ipi / 100).
        
        run html-ini-lin-tab.
        run html-con-tab (it-ped-fiscal.it-codigo,"left").
        IF it-ped-fiscal.narrativa <> "" THEN
           run html-con-tab (it-ped-fiscal.narrativa,"left"). 
        ELSE
           run html-con-tab (item.desc-item,"left"). 
        run html-con-tab (it-ped-fiscal.qtde,"right").
        run html-con-tab (string(it-ped-fiscal.vl-unit,">>>,>>9.99"),"right").
        run html-con-tab (string((it-ped-fiscal.qtde * it-ped-fiscal.vl-unit),">>>,>>9.99"),"right").
        run html-con-tab (c-desc-ad,"right").
        run html-con-tab (string(((it-ped-fiscal.qtde * it-ped-fiscal.vl-unit) * (it-ped-fiscal.aliquota-ipi / 100)),">>>,>>9.99"),"right").
        
        run html-fim-lin-tab.
    end.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    assign de-vl-pagar = de-vl-orcamento + de-vl-ipi + de-vl-frete
           c-totais = "<B>Valor da Solicitaá∆o: </B>" + string(de-vl-orcamento, ">>>,>>>,>>9.99") + "<BR>" +
                      "<B>      Valor do IPI: </B>" + string(de-vl-ipi, ">>>,>>>,>>9.99") + "<BR>" +  
                      "<B>    Valor do Frete: </B>" + string(de-vl-frete, ">>>,>>>,>>9.99") + "<BR>" +                        
                      "<B>     Valor a Pagar: </B>" + string(de-vl-pagar, ">>>,>>>,>>9.99").

    run html-con-tab(c-totais,
                     "right").
    
    run html-fim-lin-tab.
    run html-ini-lin-tab.

    ASSIGN c-observacoes-1 = REPLACE(ped-fiscal.observacao[1] + ped-fiscal.observacao[2] + ped-fiscal.observacao[3] + ped-fiscal.observacao[4] + 
                         ped-fiscal.observacao[5],"Usu†rio solicitante:","") + ", Centro de Custo : " + string(ped-fiscal.sc-codigo).
    
    run pi-print-editor (input c-observacoes-1, input 60).
    
    assign c-observacoes-1 = "".
    
    for each tt-editor:
        
        assign c-observacoes-1 = c-observacoes-1 + "<B>" + tt-editor.conteudo + "</B>" + "<BR>".
    end.    

    ASSIGN c-observacoes-1 = "<B>Usu†rio solicitante:</B><BR>" + c-observacoes-1.

    run html-ini-tab.
    run html-ini-lin-tab. 
    
    ASSIGN c_chave = STRING(ped-fiscal.nr-pedido).

    ASSIGN c-observacoes-1 = c-observacoes-1 + 
        '<B> <td align=center colspan="10"> ' + CHR(10) +
        '<BR>' + CHR(10) +  
        '<form name="formulario">' + CHR(10) +
        
/*         '     <th align="right" nowrap class="linhaForm">Texto:</th>' + CHR(10) + */
        
/*         '     <td nowrap class="linhaForm"><!--webbot              ' + CHR(10) + */
/*                                                                                  */
/*         '     bot="Validation" i-maximum-length="260" --><textarea' + CHR(10) +  */
/*         '     name="w_texto" rows="5" cols="30"></textarea>' + CHR(10) +         */
         '<BR>' + CHR(10) +  
        '     <B>Click no Link abaixo para aprovar ou reprovar esta solicitaá∆o de Notas Fiscais</B> ' + CHR(10) + 
        '     <a href="http://dbprogress.intelbras.com.br/cgi-bin/cgi/WService=dbprod_web/esp/ftp/wesftp012.w?chave=' + STRING(ped-fiscal.nr-pedido) + '&cod_estabel=' + v_cod_estab_usuar + '&solicitante=' + c-cod-usuario + '&usuario=' + c-supervisor +  '">'  + CHR(10) + 
        '        <!--BXLS-->Aprovar ou Reprovar<!--EXLS--></a>'     + CHR(10) +
        
/*          '<BR>' + CHR(10) +                                                                                                          */
/*         '       <input type="Button" name="bt_aprovar" value="Aprovar" onClick="javascript:return  BotaoAprovar();"  >' + CHR(10) +  */
/*         '       <input type="Button" name="bt_reprovar" value="Reprovar" onClick="javascript:return BotaoReprovar();" >' + CHR(10) + */
         '</form>' + CHR(10) +
        
        '</td>    </td> ' + CHR(10) + ' </B>' + CHR(10).
    run html-fim-lin-tab.
    run html-ini-tab.
    run html-ini-lin-tab.  

    run html-con-tab(c-observacoes-1,"left").
    run html-fim-lin-tab.
    run html-fim-tab.
       
    run html-ini-tab.
    run html-ini-lin-tab.

/*     PUT '<script language ="javascript">':U FORMAT "x(500)" skip.                                                             */
/*                                                                                                                               */
/*     put 'function BotaoReprovar() ~{':U FORMAT "x(100)" skip                                                                  */
/*                                                                                                                               */
/*          'if (document.formulario.w_texto.value == "") ~{' skip                                                               */
/*        '       alert("Por favor, informe o Texto para Reprovaá∆o");' skip                                                     */
/*        '       return false;' SKIP                                                                                            */
/*        '  ~} else ~{ ' SKIP                                                                                                   */
/*       '  location = "esp/ftp/wesftp012.w?param=Reprova&chave=' + STRING(ped-fiscal.nr-pedido) +  '";':U FORMAT "x(100)" skip  */
/*       '  return true;' FORMAT "x(15)"SKIP                                                                                     */
/*       '~}':U SKIP                                                                                                             */
/*       '~}':U skip.                                                                                                            */
/*     put 'function BotaoAprovar() ~{':U FORMAT "x(100)" skip                                                                   */
/*         '  location = "esp/ftp/wesftp012.w?param=Aprova&chave=' + STRING(ped-fiscal.nr-pedido) +  '";':U FORMAT "x(100)" skip */
/*         '  return true;' FORMAT "x(15)"SKIP                                                                                   */
/*         '~}':U skip                                                                                                           */
/*                                                                                                                               */
/*         '</script>' skip.                                                                                                     */

    run html-fim.
    
    output close.
                       
    IF c-cod-usuario <> c-supervisor THEN DO:
        STATUS DEFAULT "Enviando E-Mail...".
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = c-cod-usuario NO-ERROR.
        
        
        RUN piEnviaEmail (INPUT (IF AVAIL usuar_mestre THEN usuar_mestre.cod_e_mail_local ELSE c-email),
                          INPUT c-email,
                          INPUT trim(c-titulo),
                          INPUT "",
                          INPUT c-arquivo).
        STATUS DEFAULT.
        
        if trim(c-mess-err) <> "" then do:
           MESSAGE c-mess-err VIEW-AS ALERT-BOX.
           RETURN.
        end.
        ASSIGN ped-fiscal.situacao = 1
               ped-fiscal.supervisor = c-supervisor .

        IF ped-fiscal.nat-oper = 25 THEN DO:
            for first ponto-programa
                where ponto-programa.nome-programa = "esftp012"
                  AND ponto-programa.ponto         = 2,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                RUN piEnviaEmail (INPUT (IF AVAIL usuar_mestre THEN usuar_mestre.cod_e_mail_local ELSE c-email),
                                  INPUT conteudo-programa.conteudo,
                                  INPUT "Implantado pedido de transferància",
                                  INPUT "Implantado pedido de transferància nro: " + string(ped-fiscal.nr-pedido) + " pelo usuario: "  + c-cod-usuario ,
                                  INPUT "").

            end.

        END.
        message "E-Mail enviado com sucesso para " c-email VIEW-AS ALERT-BOX.
    END.
    ELSE DO:
        ASSIGN ped-fiscal.situacao = 2
               ped-fiscal.dt-aprovacao = TODAY
               ped-fiscal.supervisor = c-supervisor .
               ped-fiscal.motivo   = "Solicitaá∆o Liberada por " + c-supervisor.

        message "Solicitaá∆o Liberada" VIEW-AS ALERT-BOX.
    END.                 
    /*IF ped-fiscal.canal-vendas = 0 THEN DO:
        FIND centro-custo
             WHERE centro-custo.cc-codigo = ped-fiscal.sc-codigo
             NO-LOCK NO-ERROR.
        IF AVAIL centro-custo THEN
            ASSIGN ped-fiscal.canal-vendas = centro-custo.val-unit-up[2].
    END.*/
END PROCEDURE.


{include/pi-edit.i}
