{cdp/cdapi244.i "new shared"}   /* Defini‡Æo temp-table tt-item */

{utp/utapi019.i}

DEFINE BUFFER b01-item      FOR ITEM.

/* Defini‡Æo das Temp-Tables tt-item e tt-mensagem */
DEFINE TEMP-TABLE tt-prod NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX chPrimario IS PRIMARY UNIQUE
        it-codigo.

DEFINE TEMP-TABLE tt-mensagem-aux NO-UNDO
       FIELD sequencia AS INTEGER              FORMAT ">>>>>>>>9":U LABEL "Sequencia":U       COLUMN-LABEL "Seq":U
       FIELD codigo    LIKE cadast_msg.cdn_msg                      LABEL "C¢digo Mensagem":U COLUMN-LABEL "C¢digo":U
       FIELD tipo      AS CHARACTER            FORMAT "x(12)":U     LABEL "Tipo Mensagem":U   COLUMN-LABEL "Tp Msgs":U
       FIELD mensagem  LIKE cadast_msg.des_text_msg                 LABEL "Mensagem":U        COLUMN-LABEL "Msgs":U
       FIELD ajuda     LIKE cadast_msg.dsl_help_msg                 LABEL "Ajuda":U           COLUMN-LABEL "Ajuda":U
       INDEX chPrimario IS PRIMARY UNIQUE
             sequencia
       INDEX chCodigo
             codigo
             sequencia
       INDEX chTipo
              tipo
              sequencia.

DEFINE TEMP-TABLE tt-item-alt LIKE item
    FIELD cod-maq-origem  AS INTEGER FORMAT "9999"      INITIAL 0
    FIELD num-processo    AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0
    FIELD num-sequencia   AS INTEGER FORMAT ">>>>>9"    INITIAL 0
    FIELD ind-tipo-movto  AS INTEGER FORMAT "99"        INITIAL 1
    INDEX ch-codigo       IS PRIMARY  cod-maq-origem
                                      num-processo
                                      num-sequencia.

/* Temp-table utilizada pelo programa ESCRM005 */
DEFINE TEMP-TABLE tt-atributo-entrada NO-UNDO
    FIELD tipo          AS CHARACTER
    FIELD nome          AS CHARACTER
    FIELD nome-pai      AS CHARACTER
    FIELD valor         AS CHARACTER
    INDEX id_principal  AS PRIMARY UNIQUE
        tipo
        nome
        nome-pai.

/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD ind-origem-msg        AS INTEGER FORMAT "99" /* i01mp900.i */.

/* Temp-table utilizada pelo programa CDAPI344 */
DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg           AS CHAR    FORMAT "x(60)"
    FIELD num-sequencia-erro    AS INTEGER FORMAT "999"
    FIELD cod-erro              AS INTEGER FORMAT "99999"   
    FIELD des-erro              AS CHAR    FORMAT "x(60)"
    FIELD cod-maq-origem        AS INTEGER FORMAT "999"
    FIELD num-processo          AS INTEGER FORMAT "999999999".

DEF TEMP-TABLE tt-fci 
    FIELD it-codigo        AS CHAR
    FIELD tot-parcela      AS DEC 
    FIELD valor-medio      AS DEC 
    FIELD contr-importacao AS DEC.

DEFINE VARIABLE i-seq-histor   AS INTEGER       NO-UNDO.
DEFINE VARIABLE c-arquivo-log1 AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-ponto-faturavel AS CHARACTER  NO-UNDO.

DEFINE VARIABLE de-perc     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-tab-preco AS LOGICAL     NO-UNDO.

DEFINE VARIABLE l-gerador-solar AS LOGICAL  NO-UNDO.

/*----------------------- Funcoes --------------------------------*/
FUNCTION FnItemFaturavel RETURNS CHARACTER (INPUT l-info       AS LOG,
                                            INPUT c-estado     AS CHAR, 
                                            INPUT c-pais       AS CHAR,
                                            INPUT i-gr-estoque AS INT,
                                            INPUT i-origem-it  AS INT,
                                            INPUT c-tipo-item  AS CHAR,
                                            INPUT c-fam-mat    AS CHAR):

    IF l-info THEN DO:
       IF c-estado <> 'AM' THEN DO:
          // Ponto Lei de inform tica itens fabricados
          IF i-gr-estoque = 40 /*Interno*/ OR i-gr-estoque = 42 /*CKD*/ THEN DO:
             RETURN 'Fabricado'.   
          END.
    
          // Ponto Lei de inform tica itens de revenda
          IF i-gr-estoque = 45 /*OEM*/  THEN DO:
             RETURN 'Revenda'.
          END.
          
       END.
    END. /* Lei Informatica */
    ELSE DO:

       /*Ponto FCI */
       IF c-estado <> 'AM' THEN DO:
          IF i-gr-estoque = 40 OR i-gr-estoque = 42 OR i-gr-estoque = 45 THEN DO:
             IF i-gr-estoque = 45 THEN DO:
                IF i-origem-it = 3 OR i-origem-it = 5 OR i-origem-it = 8 THEN
                   RETURN 'FCI'.
             END.
             ELSE
               RETURN 'FCI'.
          END.
       END.

       
       IF i-gr-estoque = 45 OR i-gr-estoque = 15 THEN DO: /*OEM*/
          IF c-pais <> '' AND c-pais <> 'Brasil' THEN 
             RETURN 'Importado'. 
          ELSE
             RETURN 'Revenda Nacional'.
       END.

    END.
    
    // Ponto Manaus
    IF c-estado = 'AM' THEN DO:
       IF i-gr-estoque = 40 OR i-gr-estoque = 42 THEN 
          RETURN 'Manaus'.
    END.
    
    /* 6 - Servicos */
    IF c-tipo-item = 'SERVICOS' THEN
       RETURN 'Servicos'.

    /*
    /* 7 - Itens Combo */
    IF c-tipo-item  = 'Combo' THEN 
       RETURN 'Combo'.
    */

    RETURN ''.

END FUNCTION.


FUNCTION FnAtualizaFt0312 RETURNS LOGICAL (INPUT p-ponto AS CHAR):

   IF p-ponto = 'Fabricado'        OR 
      p-ponto = 'Revenda'          OR 
      p-ponto = 'Revenda Nacional' THEN DO: 
      IF estabelec.estado = 'SC' THEN 
         RETURN YES.
      ELSE
         RETURN NO.
   END.

   /* Ponto FCI */
   IF p-ponto = 'FCI' THEN 
      RETURN YES.   
   
   /* Ponto Manaus */
   IF p-ponto = 'Manaus' THEN 
      RETURN YES.

END FUNCTION.


FUNCTION FnAtualizFam RETURNS CHARACTER (INPUT c-fam-com AS CHAR): 

    RETURN '400' + SUBSTRING(c-fam-com,1,2).

END FUNCTION.                                                           


/***************************** Procedures *****************************/

PROCEDURE pi-cria-historico:

   DEF INPUT PARAM p-item             AS CHAR NO-UNDO.
   DEF INPUT-OUTPUT PARAM p-sequencia AS INT  NO-UNDO.
   DEF INPUT PARAM p-info             AS LOG  NO-UNDO.
   DEF INPUT PARAM p-tipo             AS CHAR NO-UNDO.       
   DEF INPUT PARAM p-it-orig          AS CHAR NO-UNDO.  
   DEF INPUT PARAM p-pais-orig        AS CHAR NO-UNDO.  

   DEF BUFFER b-item  FOR ITEM.
   DEF BUFFER b-estab FOR estabelec.

   FIND FIRST b-item  WHERE b-item.it-codigo    = p-item NO-LOCK NO-ERROR.
   
   IF AVAIL b-item THEN DO:

      FIND FIRST b-estab WHERE b-estab.cod-estabel = b-item.cod-estabel NO-LOCK NO-ERROR.

      IF p-sequencia = 0 THEN DO:
         RUN pi-gerar-dados-extrato (">> CRIA HISTORICO 11111").
       
         ASSIGN i-seq-histor = 1.
         
         FIND LAST histor-integra-item USE-INDEX idx_seq
              WHERE histor-integra-item.it-codigo = b-item.it-codigo
         NO-LOCK NO-ERROR.
    
         IF AVAIL histor-integra-item THEN
            ASSIGN i-seq-histor = histor-integra-item.sequencia + 1.
    
         RUN pi-gerar-dados-extrato (">> SEQYENCIA HISTORICO - " + STRING(i-seq-histor)).
    
         CREATE histor-integra-item.
         ASSIGN histor-integra-item.it-codigo     = b-item.it-codigo
                histor-integra-item.sequencia     = i-seq-histor
                histor-integra-item.pendente-fat  = NO.

         ASSIGN p-sequencia = i-seq-histor.
                
      END.
      ELSE DO:   
          RUN pi-gerar-dados-extrato (">> ATUALIZA HISTORICO ").
    
          FIND FIRST histor-integra-item 
               WHERE histor-integra-item.it-codigo    = b-item.it-codigo  
                 AND histor-integra-item.sequencia    = p-sequencia
          EXCLUSIVE-LOCK NO-ERROR.
      END.
    
      IF AVAIL histor-integra-item THEN DO: 
         ASSIGN histor-integra-item.data         = TODAY
                histor-integra-item.hora         = STRING(TIME,'HH:MM:SS')
                histor-integra-item.cod-estabel  = b-item.cod-estabel  
                histor-integra-item.codigo-orig  = b-item.codigo-orig
                histor-integra-item.ge-codigo    = b-item.ge-codigo  
                histor-integra-item.fm-codigo    = b-item.fm-codigo
                histor-integra-item.fm-cod-com   = b-item.fm-cod-com
                histor-integra-item.class-fiscal = b-item.class-fiscal
                histor-integra-item.ind-item-fat = b-item.ind-item-fat
                histor-integra-item.origem       = p-pais-orig.
         
         ASSIGN histor-integra-item.lei-informatica = p-info        
                histor-integra-item.tipo-item       = p-tipo    
                histor-integra-item.char-3          = p-it-orig. 

          RUN pi-gerar-dados-extrato("ANTES FnItemFaturavel "  ).

          RUN pi-gerar-dados-extrato("histor-integra-item.lei-informatica - " + STRING(histor-integra-item.lei-informatica) ).
          RUN pi-gerar-dados-extrato("histor-integra-item.cod-estabel - " + STRING(histor-integra-item.cod-estabel) ).
          RUN pi-gerar-dados-extrato("histor-integra-item.ge-codigo - " + STRING(histor-integra-item.ge-codigo) ).
          RUN pi-gerar-dados-extrato("histor-integra-item.codigo-orig - " + STRING(histor-integra-item.codigo-orig) ).
          RUN pi-gerar-dados-extrato("histor-integra-item.tipo-item - " + STRING(histor-integra-item.tipo-item) ).
          RUN pi-gerar-dados-extrato("histor-integra-item.fm-codigo - " + STRING(histor-integra-item.fm-codigo) ).

          ASSIGN c-ponto-faturavel = FnItemFaturavel(histor-integra-item.lei-informatica,
                                                     b-estab.estado,
                                                     p-pais-orig,
                                                     histor-integra-item.ge-codigo,
                                                     histor-integra-item.codigo-orig,
                                                     histor-integra-item.tipo-item,
                                                     histor-integra-item.fm-codigo).

          RUN pi-gerar-dados-extrato("DEPOIS FnItemFaturavel "  ).
          RUN pi-gerar-dados-extrato("c-ponto-faturavel == " + c-ponto-faturavel ).

           
          IF c-ponto-faturavel <> '' THEN
             ASSIGN histor-integra-item.char-2 = c-ponto-faturavel.
    
         RUN pi-gerar-dados-extrato("lei-informatica - " + STRING(histor-integra-item.lei-informatica) ).
         RUN pi-gerar-dados-extrato("tipo-item - "       + STRING(histor-integra-item.tipo-item) ).
         RUN pi-gerar-dados-extrato("origem    - "       + STRING(histor-integra-item.origem)    ).
      END.
   END.
   

END PROCEDURE.




PROCEDURE pi-atualiz-familia:
     
   DEF INPUT        PARAM p-item     AS CHAR NO-UNDO.
   DEF INPUT        PARAM p-estab    AS CHAR NO-UNDO.
   DEF INPUT-OUTPUT PARAM p-familia  AS CHAR NO-UNDO.
   DEF INPUT        PARAM p-fam-com  AS CHAR NO-UNDO.
   DEF INPUT        PARAM p-ge-estoq AS INT  NO-UNDO.
   DEF INPUT        PARAM p-classif  AS CHAR NO-UNDO.
   DEF OUTPUT       PARAM p-log-erro AS LOG  NO-UNDO. 

   DEFINE VARIABLE c-fam-old AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-classif AS INTEGER     NO-UNDO.

   ASSIGN c-fam-old = p-familia.

   //ASSIGN OVERLAY(p-familia,4,2) = SUBSTRING(p-fam-com,1,2).

   ASSIGN p-log-erro = NO.

   RUN pi-gerar-dados-extrato("NEWWWWWWWWWW pi-atualiz-familia - c-ponto-faturavel - " + c-ponto-faturavel).

   /* Produzido */
   IF c-ponto-faturavel = 'Fabricado' THEN DO:

      ASSIGN i-classif = 0.

      FOR EACH int-portaria-item NO-LOCK 
          WHERE int-portaria-item.it-codigo   = p-item
            AND int-portaria-item.cod-estabel = p-estab:
      
          FIND FIRST int-portaria-movto
               WHERE int-portaria-movto.it-codigo     = int-portaria-item.it-codigo     
                 AND int-portaria-movto.cod-estabel   = int-portaria-item.cod-estabel
                 AND int-portaria-movto.seq           = int-portaria-item.seq
                 AND int-portaria-movto.classificacao = 'DEF'
                 AND int-portaria-movto.dt-fim        = ? 
          NO-LOCK NO-ERROR.

          IF AVAIL int-portaria-movto THEN
             ASSIGN i-classif = 3.

          FIND FIRST int-portaria-movto
               WHERE int-portaria-movto.it-codigo     = int-portaria-item.it-codigo     
                 AND int-portaria-movto.cod-estabel   = int-portaria-item.cod-estabel
                 AND int-portaria-movto.seq           = int-portaria-item.seq
                 AND int-portaria-movto.classificacao = 'BEM'
                 AND int-portaria-movto.dt-fim        = ? 
          NO-LOCK NO-ERROR.

          IF AVAIL int-portaria-movto THEN
             ASSIGN i-classif = 4.
            
          /* Habilitacao Definitiva */
          IF i-classif = 3 THEN DO:
             //ASSIGN p-familia = SUBSTRING(p-familia,1,LENGTH(p-familia) - 3).
      
             IF estabelec.estado = 'SC' THEN
                ASSIGN p-familia = FnAtualizFam(p-fam-com) + '130'.
             ELSE
                ASSIGN p-familia = FnAtualizFam(p-fam-com) + '330'.
          END.

          IF i-classif = 4 THEN DO:
             /* Bem */ 
             IF AVAIL int-portaria-movto THEN DO:
                IF estabelec.estado = 'SC' THEN
                   ASSIGN p-familia = FnAtualizFam(p-fam-com) + '132'.
                ELSE
                   ASSIGN p-familia = FnAtualizFam(p-fam-com) + '332'.
             END.
          END.
      END. /*FOR EACH int-portaria-item*/

      IF c-fam-old = p-familia THEN
         ASSIGN p-log-erro = YES.
   END.

   /* Revenda */
   IF c-ponto-faturavel = 'Revenda' THEN DO:
      IF estabelec.estado = 'SC' THEN
         ASSIGN p-familia = FnAtualizFam(p-fam-com) + '181'.
      ELSE
         ASSIGN p-familia = FnAtualizFam(p-fam-com) + '381'.
   END.
   
   /* Manaus */
   IF c-ponto-faturavel = 'Manaus' THEN DO:
      ASSIGN p-familia = FnAtualizFam(p-fam-com) + '540'.
   END.
   
   /* Importado */
   IF c-ponto-faturavel = 'Importado' THEN DO:
      IF estabelec.estado = 'SC' THEN
         ASSIGN p-familia = FnAtualizFam(p-fam-com) + '100'.

      IF estabelec.estado = 'AM' THEN
         ASSIGN p-familia = FnAtualizFam(p-fam-com) + '500'.
   END.
       
   /* FCI */
   /* Revenda Nacional */
   IF c-ponto-faturavel = 'FCI' OR c-ponto-faturavel = 'Revenda Nacional' THEN DO:
      IF c-ponto-faturavel = 'Revenda Nacional' THEN DO:
         IF estabelec.estado = 'SC' THEN
            ASSIGN p-familia = FnAtualizFam(p-fam-com) + '180'.
    
         IF estabelec.estado = 'AM' THEN
            ASSIGN p-familia = FnAtualizFam(p-fam-com) + '380'.
      END.
      ELSE DO: 

         FIND FIRST secao-19 
              WHERE secao-19.class-fisc     = p-classif
                AND secao-19.cod-class-fisc = 'Decreto 10.356'
         NO-LOCK NO-ERROR.

         RUN pi-gerar-dados-extrato("AVAIL secao-19 - Decreto 10.356 " + string(AVAIL(secao-19)) ).

         IF AVAIL secao-19 THEN DO:
            ASSIGN p-familia = FnAtualizFam(p-fam-com) + '131'.

            IF estabelec.estado = 'MG' THEN
               ASSIGN p-familia = FnAtualizFam(p-fam-com) + '331'.
         END.
         ELSE DO:
             IF estabelec.estado = 'SC' THEN
                ASSIGN p-familia = FnAtualizFam(p-fam-com) + '120'.
    
             IF estabelec.estado = 'MG' THEN
                ASSIGN p-familia = FnAtualizFam(p-fam-com) + '320'.
    
             IF p-ge-estoq  = 45 THEN DO:
                 IF estabelec.estado = 'SC' THEN
                    ASSIGN p-familia = FnAtualizFam(p-fam-com) + '180'.
    
                  IF estabelec.estado = 'MG' THEN
                    ASSIGN p-familia = FnAtualizFam(p-fam-com) + '380'.
             END.                                                      
         END.
      END.
   END. 
  
   IF l-gerador-solar THEN DO:
      ASSIGN p-familia = FnAtualizFam(p-fam-com) + '140'.
   END.                                                  

   /*
   IF c-ponto-faturavel = 'Servicos' THEN DO:
   END.*/

   RUN pi-gerar-dados-extrato("l-gerador-solar: " + STRING(l-gerador-solar ) ). 

   RUN pi-gerar-dados-extrato("p-familia  - " + p-familia ).



END PROCEDURE.





PROCEDURE pi-email:
  
  DEF INPUT  PARAM p-destinatario AS CHAR NO-UNDO.
  DEF INPUT  PARAM p-titulo       AS CHAR NO-UNDO.
  DEF INPUT  PARAM p-corpo        AS CHAR NO-UNDO.
  DEF OUTPUT PARAM p-erro         AS CHAR NO-UNDO.

  FOR FIRST param-global NO-LOCK:
  END.

  IF param-global.serv-mail = "" THEN DO:
      ASSIGN p-erro = "Servidor de E-mail n’o cadastrado nos par³metros do EMS.".
  END.
  ELSE DO:  
      RUN utp/utapi019.p PERSISTENT SET h-utapi019.
  
      FOR EACH tt-envio2.   DELETE tt-envio2.   END.
      FOR EACH tt-mensagem. DELETE tt-mensagem. END.
  
      CREATE tt-envio2.
      ASSIGN tt-envio2.versao-integracao = 1
             tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
             tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
             tt-envio2.destino           = p-destinatario           /* Destinatÿrio       */ 
             tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
             tt-envio2.assunto           = p-titulo                 /* Assunto            */
             tt-envio2.formato           = "TEXTO"
             tt-envio2.exchange          = NO.
  
      CREATE tt-mensagem.
      ASSIGN tt-mensagem.seq-mensagem = 1
             tt-mensagem.mensagem     = p-corpo.
  
      RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                     INPUT  TABLE tt-mensagem,
                                     OUTPUT TABLE tt-erros).
  
      FOR EACH tt-erros:
         ASSIGN p-erro = tt-erros.desc-erro.
      END.
      
      DELETE PROCEDURE h-utapi019.
  END.

END PROCEDURE.






PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            PUT p-string + " - " + STRING(DATETIME(TODAY, MTIME))  FORMAT "x(500)" SKIP.
       OUTPUT CLOSE. 
    END.
END PROCEDURE.


