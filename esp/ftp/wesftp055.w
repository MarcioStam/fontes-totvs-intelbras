
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
{include/i-prgvrs.i wesftp055 2.03.00.000}  /*** 010000 ***/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE hCntSes        h-sessao

&GLOBAL-DEFINE ttTable1       tt-digita
&GLOBAL-DEFINE hDBOTable1     h-dataset
&GLOBAL-DEFINE DBOTable1      faturamento
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
      DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.

      ASSIGN c-periodo = string(YEAR(TODAY)) + string(MONTH(TODAY)).
      find faturamento
            WHERE faturamento.periodo = c-periodo
            AND faturamento.unid-neg = "EXPORT"
            AND faturamento.segmento = "mexico" 
            AND faturamento.mercado  = "Interno"    NO-LOCK NO-ERROR.
      

      assign c-arquivo = session:temp-directory + "/esftp055.html".
             c-titulo = "Atualiza‡Æo Acesso Restrito MEXICO " + string(c-periodo).

/*       output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET APPEND.  */

      run html-inicio ("Atualiza‡Æo Acesso Restrito MEXICO " + string(c-periodo)).
      {&out} '<form method="post">':U.

      
      assign c-data      = string(YEAR(TODAY)) + "/" + string(MONTH(TODAY)).
             c-nr-pedido = CHR(10) 
                         + "<TH> <FONT FACE="
                         + chr(34)
                         + "Times New Roman"
                         + chr(34)
                         + " SIZE=3> "
                         + c-data
                         + "</FONT> </TH>".                       
      run html-ini-tab.

      run html-ini-lin-tab.
      
      assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 

     {&OUT} c-imagem skip.

      run html-cab-tab("Atualiza‡Æo Acesso Restrito - MEXICO ").

      {&OUT} c-nr-pedido skip . 
      run html-fim-lin-tab.
      run html-fim-tab.
      
      run html-ini-lin-tab. 

      

      ASSIGN c-observacoes-1 = c-observacoes-1 +
          '<B> <td align=center colspan="10"> ' + 
          '<BR>' + 
          '<form name="formulario">' + 

          '   <tr>' + 
          '       <th align="right" nowrap class="linhaForm"><!--BXLS-->Usu rio<!--EXLS-->:</th>' + 
          '       <td nowrap class="linhaForm"><input type="text" size="12" maxlength="12" name="w_usuario" value="' + get-value("usuario") + '"></td>' + 
          '       <th align="right" nowrap class="linhaForm"><!--BXLS-->Senha<!--EXLS-->:</th>' + 
          '       <td nowrap class="linhaForm"><input type="password" size="25" maxlength="25" name="w_senha" value="' + get-value("w_senha") + '"></td>' +
          '   </tr>' +
          '   <tr>' + 
          '       <th align="right" nowrap class="linhaForm"><!--BXLS-->Periodo<!--EXLS-->:</th>' + 
          '       <td nowrap class="linhaForm"><input type="text" size="12" maxlength="12" name="w_periodo" value="' + get-value("periodo") + '"></td>' + 
          '   </tr>' +
          '   <tr>'  +
          '     <th align="right" nowrap class="linhaForm">Faturamento Realizado:</th>' + 
          '     <td nowrap class="linhaForm"><textarea name="w_vl-fat-real" value="' + get-value("w_vl-fat-real") + '" rows="1" cols="30"></textarea>' +
          '     <th align="right" nowrap class="linhaForm">Carteira Pendente:</th>' + 
          '     <td nowrap class="linhaForm"><textarea name="w_vl-cart" value="' + get-value("w_vl-cart") + '" rows="1" cols="30"></textarea>' + 
          '   </tr></BR></B>' +

          '<B> <td align=center colspan="10"> ' + 
          '<BR>' + 
          '   <input type="submit" name="bt_gravar" value="Gravar"> </BR></B> ' 
          .

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

        IF get-value("bt_gravar") <> "" THEN DO:
           IF get-value("w_usuario") = "" OR get-value("w_senha") = "" THEN DO:
               ASSIGN l-erro = YES.
               {&out} '<script language ="javascript">':U
                      'alert("Informe Usuario e Senha Corretamente")':U
                      '</script>'.
           END.
           ELSE DO:
               for first mgesp.ponto-programa
                    where ponto-programa.nome-programa = "wesftp055"
                      AND ponto-programa.ponto         = 1,
                     FIRST mgesp.conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND entry(1,conteudo-programa.conteudo, ";") = get-value("w_usuario"):
                    
                end.


               IF NOT AVAIL conteudo-programa THEN DO:
                   ASSIGN l-erro = YES.

                   {&out} '<script language ="javascript">':U
                          'alert("Usuario Indexistente")':U
                          '</script>'.
               END.
               ELSE DO:
                   IF  NOT entry(2,conteudo-programa.conteudo, ";") = get-value("w_senha") THEN DO:
                       ASSIGN l-erro = YES.
                       {&out} '<script language ="javascript">':U
                              'alert("Senha Incorreta");':U
                              '</script>'.
                   END.
               END.
               IF substring(get-value("w_periodo"),1,4) <> string(YEAR(TODAY)) THEN DO:
                       ASSIGN l-erro = YES.
                       {&out} '<script language ="javascript">':U
                              'alert("Ano Invalido");':U
                              '</script>'.
               END.

               IF substring(get-value("w_periodo"),5,2) <> string(MONTH(TODAY),"99") AND 
                  substring(get-value("w_periodo"),5,2) <> string(MONTH(TODAY - 30),"99") AND
                  substring(get-value("w_periodo"),5,2) <> string(MONTH(TODAY - 60),"99") THEN DO:
                       ASSIGN l-erro = YES.
                       {&out} '<script language ="javascript">':U
                              'alert("Mes Invalido, somente ‚ permitido atualizar do ultimo trimestre ");':U
                              '</script>'.
               END.
           END.
        END.
        
        IF l-erro = NO THEN DO:

            IF get-value("bt_gravar") <> "" THEN DO:

                find faturamento
                       WHERE faturamento.periodo = get-value("w_periodo")
                       AND faturamento.unid-neg = "EXPORT"
                       AND faturamento.segmento = "mexico" 
                        EXCLUSIVE-LOCK NO-ERROR.           

                IF NOT AVAIL faturamento THEN DO:
                    CREATE faturamento.
                    ASSIGN faturamento.unid-neg = "EXPORT"   
                           faturamento.segmento = "Mexico"
                           faturamento.mercado  = "Interno" 
                           faturamento.periodo  = get-value("w_periodo").
                END.

                ASSIGN faturamento.vl-fat-real  = DEC(get-value("w_vl-fat-real"))
                       faturamento.vl-cart      = dec(get-value("w_vl-cart")).


                       {&out} '<script language ="javascript">':U
                              'alert("Atualiza‡Æo Efetuada com Exito");':U

                              '</script>'.

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

