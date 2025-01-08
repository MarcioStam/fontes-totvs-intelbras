
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i wesftp012 2.03.00.000}  /*** 010000 ***/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE hCntSes        h-sessao

&GLOBAL-DEFINE ttTable1       tt-digita
&GLOBAL-DEFINE hDBOTable1     h-dataset
&GLOBAL-DEFINE DBOTable1      ped-fiscal
&GLOBAL-DEFINE DBOTable1Vrs   2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c_fe                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE nc_fe                AS INTEGER   NO-UNDO.
DEFINE VARIABLE xfield               AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-return             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-token              AS CHARACTER NO-UNDO.
DEFINE VARIABLE linhas               AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-seq-erro           AS INTEGER   NO-UNDO.
DEFINE VARIABLE w_cod_estabel        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE aux-contador         AS INTEGER   NO-UNDO.
DEFINE VARIABLE r-checado            as rowid   no-undo.
DEFINE VARIABLE c-cod-usuario        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-supervisor         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boes150a           AS HANDLE      NO-UNDO.
define variable l-aloca-estoque as logical     initial no no-undo.
{include/boerrtab.i}
{include/tt-edit.i}

    {utp/utapi019.i}
DEFINE TEMP-TABLE tt-mail
    FIELD sequencia     AS INTEGER
    FIELD Remetente     AS CHARACTER 
    FIELD Destinatario  AS CHARACTER 
    FIELD Copia         AS CHARACTER 
    FIELD Assunto       AS CHARACTER 
    FIELD Mensagem      AS CHARACTER 
    FIELD Arquivo       AS CHARACTER 
    FIELD lEnviado      AS LOGICAL
    INDEX id sequencia.
DEFINE TEMP-TABLE tt-xml NO-UNDO
   FIELD elementName  AS CHARACTER
   FIELD elementValue AS CHARACTER
   FIELD elementNS    AS CHARACTER.

SESSION:DATE-FORMAT = "dmy". 

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE h-brwapi      AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOTable1} AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hCntSes}    AS HANDLE    NO-UNDO.
def var h-Dataobject as handle  no-undo.

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
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.79
         WIDTH              = 60.29.
/* END WINDOW DEFINITION */
*/

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */
{esp/es0006a.i}
{esp/es0006b.i}


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader w-html
PROCEDURE outputHeader :
/*------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any cookie information needed 
               by this procedure.
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is 
               a good place to set the WebState and WebTimeout attributes.
------------------------------------------------------------------------*/

  output-http-header ("Expires":U, format-datetime("cookie":U, today, ?, "LOCAL")).
  output-content-type ("text/html":U).

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request PROCEDURE 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  /* 
  * Output the MIME header and set up the object as state-less or state-aware. 
  * This is required if any HTML is to be returned to the browser.
  */
  
  RUN outputHeader.
 
  /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/

      def var c-agente           as char no-undo.
      def var c-embarque         as char no-undo.
      def var c-desembarque      as char no-undo.
      def var de-total-compras  as decimal no-undo.
      def var c-mess-err         as char no-undo.
      def var c-nr-pedido        as char format "x(100)" no-undo.
      def var c-tit-ped          as char format "x(100)" no-undo.
      def var c-dados-empresa    as char format "x(300)" no-undo.
      def var c-dados-cliente    as char format "x(400)" no-undo.
      def var c-imagem           as char format "x(120)" no-undo.    
      def var c-complementos     as char format "x(300)" no-undo.
      def var c-mensagem1        as char format "x(500)" no-undo.
      def var c-titulo       as char  no-undo.
      def var de-total-geral     as decimal                              no-undo.
      def var de-total-sipi      as decimal                              no-undo.
      def var de-preco-sipi      as decimal                              no-undo.
      def var de-ipi             as decimal                              no-undo.
      def var de-preco-tot-aux   AS DECIMAL NO-UNDO.
      def var de-desc-total      AS DECIMAL NO-UNDO.
      def var de-enc             as DECIMAL NO-UNDO.
      def var de-enc-total       like ordem-compra.preco-unit NO-UNDO.
      def var c-totais           as char format "x(300)" no-undo.
      def var c-comprador        like cont-emit.nome no-undo.
      def var c-vendedor         like atendente.nm-oper no-undo.
      def var c-desc-pagto       like cond-pagto.descricao no-undo.
      def var c-observacoes-1    as char format "x(500)" no-undo.
      def var c-desc-ad          as char no-undo.
      def var de-vl-frete        as dec no-undo.
      def var de-vl-pagar        as dec no-undo.
      def var c-cobranca         as char no-undo.
      def var c-tipo-pedido      as char no-undo.
      DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
      DEFINE VARIABLE c-data AS CHARACTER   NO-UNDO.
      
      DEF VAR c_acao             AS CHARACTER  NO-UNDO.
      DEF VAR i-pedido           AS INTEGER    NO-UNDO.
      def var c-nat          as char extent 24 NO-UNDO       
      init ["Amostra",
            "Devol Mat Prima",
            "Devol Mat Uso Consumo",
            "Ret Rep Garantia",
            "Homologacao",
            "Material Promocional",
            "Outros",
            "Rem Curso ASTEC",
            "Rem curso MKT",
            "Rem Industrializacao",
            "Equip para Treinamen",
            "Rep Garan c/ retorno",
            "Rep Garan s/ Retorno",
            "Ret/Rem Conserto",
            "Rem Teste c/ retorno",
            "Rem Teste s/ Retorno",
            "Troca Consum Final",
            "Rem/Ret Emprestimo",
            "Troca Expressa",
            "Ret Troca Expressa",
            "Remessa Feira",
            "Remessa para Locacao",
            "Segunda Locacao",
            "Retorno Locacao"].    
      def var de-vl-orcamento like ped-item.vl-preuni no-undo.
      def var de-vl-ipi like ped-item.aliquota-ipi no-undo.

      def buffer bf-emitente for emitente.

      ASSIGN i-pedido = INT(get-value("chave")).
      ASSIGN w_cod_estabel = get-value("cod_estabel").

      FIND ped-fiscal
           WHERE ped-fiscal.nr-pedido = i-pedido exclusive-LOCK NO-ERROR.
      
      IF NOT AVAIL ped-fiscal OR ped-fiscal.situacao <> 1 THEN DO:
          {&out} '<script language ="javascript">':U
                 'alert("Situaá∆o de Solicitaá∆o N∆o permite Aprovaá∆o ou Reprovaá∆o");':U
                 '</script>'.
          RETURN.
      END.
      find emitente no-lock
           where emitente.cod-emitente = ped-fiscal.cod-emitente NO-ERROR.
      find transporte no-lock
           where  transporte.cod-transp = ped-fiscal.cod-transp NO-ERROR.    

      find estabelec where
           estabelec.cod-estabel = ped-fiscal.cod-estabel no-lock no-error.
      if avail estabelec then do:
          find mgcad.empresa where
               empresa.ep-codigo = estabelec.ep-codigo no-lock no-error.
      end.

      assign c-arquivo = session:temp-directory + "/esftp012.html".
             c-titulo = "Solicitaá∆o de Emiss∆o de Nota Fiscal " + string(ped-fiscal.nr-pedido).

      output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.

      run html-inicio ("Solicitaá∆o de Nota Fiscal").
      {&out} '<form method="post">':U.

      find bf-emitente where
           bf-emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

      assign c-vendedor = "".

      find cond-pagto where cond-pagto.cod-cond-pag = emitente.cod-cond-pag no-lock no-error.

      if avail cond-pagto then
          assign c-desc-pagto = cond-pagto.descricao.         

      find first cont-emit
           where cont-emit.cod-emitente = emitente.cod-emitente no-lock no-error.
      if avail cont-emit then
          assign c-comprador = cont-emit.nome.
      

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
                         + "</FONT> </TH>".                       
      run html-ini-tab.

      run html-ini-lin-tab.
      
      if estabelec.cod-estabel = "103" OR
         estabelec.cod-estabel = "301" then
           assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Maxcom </FONT> </TH>". 
      if estabelec.cod-estabel = "101" then
           assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras - Matriz </FONT> </TH>". 
      if estabelec.cod-estabel = "102" then
           assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 

     {&OUT} c-imagem skip.

      run html-cab-tab(c-tit-ped).

     {&OUT} c-nr-pedido skip . 

      run html-fim-lin-tab.
      run html-fim-tab.
      
      run html-ini-lin-tab. 

      

      ASSIGN c-observacoes-1 = c-observacoes-1 +
          '<B> <td align=center colspan="10"> ' + CHR(10) +
          '<BR>' + CHR(10) +
          '<form name="formulario">' + CHR(10) +

          '   <tr>' + CHR(10) +
          '       <th align="right" nowrap class="linhaForm"><!--BXLS-->Usu†rio<!--EXLS-->:</th>' + CHR(10) +
          '       <td nowrap class="linhaForm"><input type="text" size="12" maxlength="12" name="w_usuario" value="' + get-value("usuario") + '"></td>' + CHR(10) +
          '   </tr>' + CHR(10) +
          '   <tr>' + CHR(10) +
          '       <th align="right" nowrap class="linhaForm"><!--BXLS-->Senha<!--EXLS-->:</th>' + CHR(10) +
          '       <td nowrap class="linhaForm"><input type="password" size="25" maxlength="25" name="w_senha" value="' + get-value("w_senha") + '"></td>' + CHR(10) +
          '   </tr>' + CHR(10) +
          '     <th align="right" nowrap class="linhaForm">Texto:</th>' + CHR(10) +
          '     <td nowrap class="linhaForm"><!--webbot              ' + CHR(10) +

          '     bot="Validation" i-maximum-length="260" --><textarea' + CHR(10) +
          '     name="w_texto" value="' + get-value("w_texto") + '" rows="5" cols="30"></textarea>' + CHR(10) +
           '<BR>' + CHR(10) +
          '     <B>Click nos bot‰es abaixo para aprovar, reprovar ou retornar para correá∆o esta solicitaá∆o de Notas Fiscais</B> ' + CHR(10) +


           '<BR>' + CHR(10) +
          '       <input type="submit" name="bt_aprovar" value="Aprovar"   >' + CHR(10) +
          '       <input type="submit" name="bt_reprovar" value="Reprovar"  >' + CHR(10) +
          '       <input type="submit" name="bt_retornar" value="Retornar para Correá∆o"   >' + CHR(10) +
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

      
  
      {&OUT} '</form>':U.
      run html-fim.

    IF request_method = "POST" THEN DO:

        ASSIGN l-erro = NO.

        IF ped-fiscal.supervisor <> get-value("w_usuario") THEN DO:
            ASSIGN l-erro = YES.
            {&out} '<script language ="javascript">':U
                   'alert("Usuario n∆o Ç o aprovador desta solicitaá∆o")':U
                   '</script>'.

        END.
        IF get-value("bt_aprovar") <> "" OR get-value("bt_reprovar") <> "" OR get-value("bt_retornar") <> "" THEN DO:
           IF get-value("w_usuario") = "" OR get-value("w_senha") = "" THEN DO:
               ASSIGN l-erro = YES.
               {&out} '<script language ="javascript">':U
                      'alert("Informe Usuario e Senha Corretamente")':U
                      '</script>'.
           END.
           ELSE DO:
               FIND usuar_mestre
                    WHERE usuar_mestre.cod_usuario = get-value("w_usuario")
                    NO-LOCK NO-ERROR.
               IF NOT AVAIL usuar_mestre THEN DO:
                   ASSIGN l-erro = YES.

                   {&out} '<script language ="javascript">':U
                          'alert("Usuario Indexistente")':U
                          '</script>'.
               END.
               ELSE DO:
                   IF  usuar_mestre.cod_senha <> base64-encode(sha1-digest(lc(get-value("w_senha")))) THEN DO:
                       ASSIGN l-erro = YES.
                       {&out} '<script language ="javascript">':U
                              'alert("Senha Incorreta");':U
                              '</script>'.
                   END.
               END.
           END.
        END.
        IF l-erro = NO THEN DO:

            IF get-value("bt_aprovar") <> "" THEN DO:
               ASSIGN ped-fiscal.situacao = 2.
                      ped-fiscal.dt-aprovacao = TODAY.
                      ped-fiscal.motivo   = ped-fiscal.motivo + " " + GET-value("w_texto") + " Usuario Aprovador: " + get-value("w_usuario").
                       {&out} '<script language ="javascript">':U
                              'alert("Aprovaá∆o Efetuada");':U

                              '</script>'.
               RUN piEnviaEmail(INPUT get-value("usuario"),
                                INPUT get-value("solicitante"),
                                INPUT "Solicitaá∆o de Notas Fiscais Nr.: " + string(ped-fiscal.nr-pedido) + " Aprovada",
                                INPUT get-value("w_texto"),
                                INPUT "").

               IF ped-fiscal.dt-aprovacao < ped-fiscal.dt-emissao THEN
                   ASSIGN ped-fiscal.dt-aprovacao = ped-fiscal.dt-emissao.

            END.
    
    
            IF get-value("bt_reprovar") <> "" THEN DO:
                IF get-value("w_texto") = "" THEN DO:
                    {&out} '<script language ="javascript">':U
                           'alert("Informe o texto para Reprovaá∆o");':U
                           '</script>'.
                END.
                ELSE DO:
                    for first mgesp.ponto-programa
                        where ponto-programa.nome-programa = "esftp012"
                          AND ponto-programa.ponto         = 1,
                         EACH mgesp.conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          and conteudo-programa.conteudo = "Sim":
                        assign l-aloca-estoque = yes.
                    end.

                    if l-aloca-estoque then do:
                          for each mgesp.it-ped-fiscal
                              where mgesp.it-ped-fiscal.nr-pedido = mgesp.ped-fiscal.nr-pedido no-lock,
                              FIRST item 
                              WHERE ITEM.it-codigo = mgesp.it-ped-fiscal.it-codigo NO-LOCK:
                              IF ITEM.tipo-contr <> 4 THEN DO:
                                  find first saldo-estoq
                                       where saldo-estoq.it-codigo   = mgesp.it-ped-fiscal.it-codigo
                                         and saldo-estoq.cod-estabel = mgesp.Ped-fiscal.cod-estabel
                                         and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos
                                         and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localizacao
                                         no-lock no-error.
                        
                                   if avail saldo-estoq then do:
                                      if saldo-estoq.qt-alocada < dec(it-ped-fiscal.qtde) then do:
                                          {&out} '<script language ="javascript">':U
                                                 'alert("Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " mgesp.it-ped-fiscal.qtde " do item: " mgesp.it-ped-fiscal.it-codigo);':U
                                                 '</script>'.

                                         
                                         UNDO, LEAVE.
                                      end.
                                      
                                      find current saldo-estoq exclusive-lock no-error.
                                      assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - mgesp.it-ped-fiscal.qtde.
                                      release saldo-estoq.
                                   end.
                                   else do:
                                       {&out} '<script language ="javascript">':U
                                              'alert("Saldo em Estoque n∆o Encontrado para item: " mgesp.it-ped-fiscal.it-codigo );':U
                                              '</script>'.

                                         
                                         UNDO, LEAVE.
                                  end.
                             END.
                          end.
                    end.
                    ASSIGN ped-fiscal.situacao = 6
                           ped-fiscal.motivo = ped-fiscal.motivo + " " + GET-value("w_texto") + " Usuario Aprovador: " + get-value("w_usuario").

                    {&out} '<script language ="javascript">':U
                           'alert("Reprovaá∆o Efetuada");':U
                           '</script>'.
                    RUN piEnviaEmail(INPUT get-value("usuario"),
                                     INPUT get-value("solicitante"),
                                     INPUT "Solicitaá∆o de Notas Fiscais Nr.: " + string(ped-fiscal.nr-pedido) + " Reprovada",
                                     INPUT get-value("w_texto"),
                                     INPUT "").

                END.
    
            END.
            IF get-value("bt_retornar") <> "" THEN DO:
                IF get-value("w_texto") = "" THEN DO:
                    {&out} '<script language ="javascript">':U
                           'alert("Informe o texto para Retorno para Correá∆o");':U
                           '</script>'.

                END.
                ELSE DO:
                    ASSIGN ped-fiscal.situacao = 0
                           ped-fiscal.motivo = ped-fiscal.motivo + " " + GET-value("w_texto") + " Usuario Aprovador: " + get-value("w_usuario").
                    {&out} '<script language ="javascript">':U
                           'alert("Retorno Efetuado");':U
                           '</script>'.
                    RUN piEnviaEmail(INPUT get-value("usuario"),
                                     INPUT get-value("solicitante"),
                                     INPUT "Solicitaá∆o de Notas Fiscais Nr.: " + string(ped-fiscal.nr-pedido) + " Retornou para Alteraá∆o",
                                     INPUT get-value("w_texto"),
                                     INPUT "").

                END.
    
            END.

        END.
    END.
  /* Output your custom HTML to WEBSTREAM here (using {&OUT}).                */
  {&OUT}
    '</form>':U SKIP
    '</body>':U SKIP
    '</html>':U SKIP.
  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    
    FIND usuar_mestre
         WHERE usuar_mestre.cod_usuario = premetente NO-LOCK NO-ERROR.
    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = usuar_mestre.cod_e_mail_local.
    FIND usuar_mestre
         WHERE usuar_mestre.cod_usuario = pdestino NO-LOCK NO-ERROR.

    ASSIGN tt-mail.Destinatario  = usuar_mestre.cod_e_mail_local
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

        ASSIGN c-lst-arq  = tt-mail.arquivo. /* + "," + "\\intel200\erp\ems204\image\logo_maxcom.jpg". */
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
               tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
               tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
               tt-envio2.arq-anexo         = ""              /* Arquivo Tempor†rio */
               tt-envio2.formato           = "TEXTO".
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */

        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN
           OUTPUT TO erros-comerc.LOG APPEND.
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END.
    RETURN "OK":U.
END PROCEDURE.
