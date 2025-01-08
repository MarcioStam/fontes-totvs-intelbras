{esp/es0018.i}
{esapi/esapi025a.i}


/**********************************************************************************************************************/
/*------------------------------------------------ Definicoes --------------------------------------------------------*/
/**********************************************************************************************************************/

DEFINE BUFFER bf-estabelec FOR estabelec.    

DEFINE TEMP-TABLE tt-fci-excec NO-UNDO
    FIELD cod-estabel AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD dt-implant  AS DATE
    FIELD erro        AS   CHARACTER FORMAT "x(05)"
    INDEX ch-exec cod-estabel it-codigo dt-implant erro.

DEF INPUT PARAM p-item              AS CHAR NO-UNDO.
DEF INPUT PARAM p-sequencia         AS INT  NO-UNDO.
DEF OUTPUT PARAM p-motivo-pendencia AS CHAR NO-UNDO.

DEFINE BUFFER b-item-CD0903 FOR ITEM.
DEFINE BUFFER b-item-aux    FOR ITEM.
DEFINE BUFFER bf-item-uni-estab FOR item-uni-estab.
DEFINE BUFFER b01-historico FOR histor-integra-item.
DEFINE BUFFER b01-item-uf-sem-prot FOR item-uf-sem-prot. 
DEFINE BUFFER b02-item-uf-sem-prot FOR item-uf-sem-prot.    
DEFINE BUFFER b01-sit-tribut-relacto FOR sit-tribut-relacto.
DEFINE BUFFER b02-sit-tribut-relacto FOR sit-tribut-relacto.

DEFINE VARIABLE l-achou         AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-cd0755        AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-ft0918        AS LOGICAL  NO-UNDO.

DEFINE VARIABLE c-nova-familia AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-ct-clas-item NO-UNDO LIKE ct-clas-item
      FIELD r-rowid AS ROWID.

DEF TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD errorSequence         AS INT
    FIELD errorNumber           AS INT
    FIELD errorDescription      AS CHAR
    FIELD errorParameters       AS CHAR
    FIELD errorType             AS CHAR
    FIELD errorHelp             AS CHAR
    FIELD errorsubtype          AS CHAR.

IF OPSYS = "unix":U THEN
   ASSIGN c-arquivo-log1 = '/mnt/spool/is055792/esapi025-B_PROD.txt'.
ELSE
   ASSIGN c-arquivo-log1 = 'c:/temp/esapi025-B.txt'.

RUN pi-gerar-dados-extrato (" " + CHR(13) + CHR(13)).

/**********************************************************************************************************************/
/*-------------------------------------------- Inicio do Programa ----------------------------------------------------*/
/**********************************************************************************************************************/

RUN pi-gerar-dados-extrato (">> Entrou pi-item-faturavel").

FIND FIRST ITEM      WHERE ITEM.it-codigo        = p-item           NO-LOCK NO-ERROR.
FIND FIRST estabelec WHERE estabelec.cod-estabel = ITEM.cod-estabel NO-LOCK NO-ERROR.

IF NOT AVAILABLE ITEM THEN RETURN 'nok'.

RUN pi-gerar-dados-extrato (">> ITEM: " +  ITEM.it-codigo + ' - SEQ: ' + STRING(p-sequencia)).

/* Limpa historico de Erros */
FIND FIRST b01-historico WHERE b01-historico.it-codigo = p-item       
                           AND b01-historico.sequencia = p-sequencia 
EXCLUSIVE-LOCK NO-ERROR.

IF AVAIL b01-historico THEN DO:
   ASSIGN b01-historico.char-1       = ''
          b01-historico.pendente-fat = NO.
   RELEASE b01-historico.
END.

FIND FIRST histor-integra-item WHERE histor-integra-item.it-codigo = ITEM.it-codigo
                                 AND histor-integra-item.sequencia = p-sequencia
NO-LOCK NO-ERROR.

IF NOT AVAIL histor-integra-item THEN RETURN 'nok'.

RUN pi-gerar-dados-extrato (">> AVAIL histor-integra-item - " + STRING( AVAIL histor-integra-item)).

/* Funcao verifica regra para fazer o Item Faturavel */
ASSIGN c-ponto-faturavel = FnItemFaturavel(histor-integra-item.lei-informatica,
                                           estabelec.estado,
                                           histor-integra-item.origem, /*Pais Ori*/   
                                           ITEM.ge-codigo,
                                           ITEM.codigo-orig,
                                           histor-integra-item.tipo-item,
                                           ITEM.fm-codigo).

RUN pi-gerar-dados-extrato (">> PONTO FATURAVEL - " + c-ponto-faturavel).
RUN pi-gerar-dados-extrato ("ANTES pi-atualiz-familia  - " + c-nova-familia).

ASSIGN c-nova-familia = ITEM.fm-codigo
       l-erro         = NO.

/* Regra - Manaus */
IF c-ponto-faturavel = 'Manaus' THEN DO:
   IF ITEM.cod-dcr-item <> '' THEN DO:

      RUN pi-gerar-dados-extrato (">> MANAUS - DCR DIFEREENTE DE BRANCO == " + ITEM.cod-dcr-item  ).

      RUN pi-email (INPUT "leonam.farias@intelbras.com.br",
                    INPUT "Entregar DCRE " + ITEM.it-codigo,
                    INPUT "Entregar DCRE " + ITEM.it-codigo + " e avisar ÿarea tributaria",
                    OUTPUT p-motivo-pendencia).

      RUN pi-gerar-dados-extrato (">> Deu erro !!!! "  ).

      RETURN 'NOK'.
   END.
END.


/* Validacoes FCI */
IF c-ponto-faturavel = 'FCI'  THEN DO:

   RUN pi-gerar-dados-extrato (">> Validacoes FCI "  ).

   ASSIGN l-tab-preco = NO.

   tab_preco_item:
   FOR EACH tb-preco NO-LOCK
       WHERE tb-preco.dt-inival <= TODAY
         AND tb-preco.dt-fimval >= TODAY,
       FIRST preco-item OF tb-preco NO-LOCK
       WHERE preco-item.it-codigo = ITEM.it-codigo:

       ASSIGN l-tab-preco = YES.
       LEAVE tab_preco_item.
   END.

   RUN pi-gerar-dados-extrato (">> TEM tabela preco ??? " + STRING(l-tab-preco) ).
   
   IF NOT l-tab-preco THEN DO:
      RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                               INPUT histor-integra-item.sequencia,
                               INPUT "Nao encontrada tabela de preco para o item").

      ASSIGN p-motivo-pendencia = "Erro: Nao encontrada tabela de preco para o item".

      RUN pi-gerar-dados-extrato (">> Deu erro !!!! " ).

      RETURN 'NOK'.
   END.
    
   IF ITEM.ge-codigo = 45 THEN DO:
      ASSIGN l-ft0918 = NO.
      
      FOR FIRST reg-inf-compl NO-LOCK
          WHERE reg-inf-compl.cod-tab-inform   = "FCI":U
          AND   reg-inf-compl.cod-campo-inform = "FCI":U:
      
          FOR EACH  inf-compl NO-LOCK
              WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*6*/
                AND ENTRY(1,TRIM(inf-compl.cod-indice),CHR(2)) = ITEM.cod-estabel //Estab 
                AND ENTRY(2,TRIM(inf-compl.cod-indice),CHR(2)) = ITEM.it-codigo:  //Item
              
              ASSIGN l-ft0918 = YES. 
          END.
      END.
      
      IF NOT l-ft0918 THEN DO:
         ASSIGN p-motivo-pendencia = "Erro: ITEM REVENDA SEM FCI CADASTRADA".
    
         RUN pi-gerar-dados-extrato (">> Deu erro !!!! "  ).
    
         RETURN 'NOK'.
      END.

      RUN pi-gerar-dados-extrato (">> PASSOU SEM ERRO !!!! "  ).
   END.
   ELSE DO:
       RUN pi-gerar-dados-extrato (">> PASSOU SEM ERRO !!!! "  ).
      
       FIND FIRST estrutura WHERE estrutura.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
      
       IF NOT AVAIL estrutura THEN DO:
          RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                   INPUT histor-integra-item.sequencia,
                                   INPUT "Nao encontrada estrutura para o Produto").
      
          ASSIGN p-motivo-pendencia = "Erro: Nao encontrada estrutura para o Produto".
      
          RUN pi-gerar-dados-extrato (">> ERRO , sem estrutura !!!! "  ).
      
          RETURN 'NOK'.
       END.
       ELSE DO:
          RUN pi-gerar-dados-extrato (">> ANTES CHAMADA esapi025c.p "  ).
      
          RUN esapi/esapi025c.p (INPUT ITEM.it-codigo, OUTPUT TABLE tt-fci).
      
          RUN pi-gerar-dados-extrato (">> DEPOIS CHAMADA esapi025c.p "  ).
      
          ASSIGN de-perc = 0.
      
          FOR EACH tt-fci:
              ASSIGN de-perc = (tt-fci.tot-parcela / tt-fci.valor-medio) * 100. 
          END.
      
          IF de-perc > 100 THEN DO:
             RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                      INPUT histor-integra-item.sequencia,
                                      INPUT "CI Calc% superior ¹ 100%").
      
             ASSIGN p-motivo-pendencia = "Erro: CI Calc% superior ¹ 100%".
      
             RETURN 'NOK'.
          END.    
       END.       
   END.
END.


ASSIGN l-gerador-solar = NO.

RUN esp/es0018p.p (INPUT  'esapi025',
                   INPUT  3,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
        ASSIGN l-gerador-solar = YES.
END.


/* Atualiza Familia Material */
IF l-gerador-solar OR 
   ((ITEM.it-codigo >= '2880000' AND ITEM.it-codigo <= '2889999') OR  
   (ITEM.it-codigo >= '4000000' AND ITEM.it-codigo <= '4999999')) THEN
   IF NOT (c-ponto-faturavel = 'Importado' AND ITEM.ge-codigo = 15) AND c-ponto-faturavel <> 'Revenda' THEN 
      RUN pi-atualiz-familia (INPUT ITEM.it-codigo, 
                              INPUT ITEM.cod-estabel, 
                              INPUT-OUTPUT c-nova-familia,
                              INPUT ITEM.fm-cod-com,
                              INPUT ITEM.ge-codigo,
                              INPUT ITEM.class-fisc,
                              OUTPUT l-erro). 


RUN pi-gerar-dados-extrato("DEPOIS pi-atualiz-familia  - " + c-nova-familia ).
RUN pi-gerar-dados-extrato("ERRO pi-atualiz-familia  - "   + STRING(l-erro) ).


IF l-erro THEN DO:
   RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                            INPUT histor-integra-item.sequencia,
                            INPUT 'Item nao habilitado para lei de informatica (ESCDP090)').

   ASSIGN p-motivo-pendencia = 'Item nao habilitado para lei de informatica (ESCDP090)'.

   RETURN 'NOK'.
END.


/* Troca Familia */
FIND familia WHERE familia.fm-codigo = c-nova-familia NO-LOCK NO-ERROR.

RUN pi-gerar-dados-extrato("AVAIL FAMILIA  - " + STRING(AVAIL familia) ).

IF AVAIL familia THEN DO:
   FIND b-item-aux WHERE b-item-aux.it-codigo  = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL b-item-aux THEN
      ASSIGN b-item-aux.fm-codigo = c-nova-familia.

   RELEASE b-item-aux.
END.
ELSE DO:
   RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                            INPUT histor-integra-item.sequencia,
                            INPUT 'Erro - Familia Tributaria nao encontrada : ' + c-nova-familia).

   ASSIGN p-motivo-pendencia = 'Erro - Familia Tributaria nao encontrada : ' + c-nova-familia.

   RETURN 'NOK'.
END.


/* CD0147 - Atualizacao Item Estab */
FOR EACH item-uni-estab NO-LOCK 
    WHERE item-uni-estab.it-codigo = ITEM.it-codigo,
    FIRST bf-estabelec WHERE bf-estabelec.cod-estabel = item-uni-estab.cod-estabel NO-LOCK:

    IF bf-estabelec.ep-codigo <> estabelec.ep-codigo THEN NEXT.

    IF bf-estabelec.cod-estabel = '110' THEN DO: /* Entreposto */
       IF c-ponto-faturavel = 'Servicos' THEN NEXT.
       IF estabelec.estado <> 'SC' AND estabelec.estado <> 'MG' THEN NEXT.
         
       IF c-ponto-faturavel = 'Importado' THEN DO:

          FIND bf-item-uni-estab WHERE ROWID(bf-item-uni-estab) = ROWID(item-uni-estab) EXCLUSIVE-LOCK NO-ERROR.

          IF AVAIL bf-item-uni-estab THEN DO:
               IF ITEM.codigo-orig = 1 THEN
                  ASSIGN substring(bf-item-uni-estab.char-2,18,3) = '2'.

               IF ITEM.codigo-orig = 6 THEN
                  ASSIGN substring(bf-item-uni-estab.char-2,18,3) = '7'. 
          END.
       END.
    END.
    ELSE DO:
       IF bf-estabelec.estado <> estabelec.estado THEN NEXT.
    END. 

    FIND bf-item-uni-estab WHERE ROWID(bf-item-uni-estab) = ROWID(item-uni-estab) EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL bf-item-uni-estab THEN DO:

       /*
       IF NOT (c-ponto-faturavel = 'Importado' AND ITEM.ge-codigo = 15) THEN 
          ASSIGN bf-item-uni-estab.ind-item-fat = YES.
       */

       RELEASE bf-item-uni-estab.
    END.
END.


/* Atualiza programas tornar Item Faturavel */
IF c-ponto-faturavel = 'Fabricado'        OR
   c-ponto-faturavel = 'Revenda'          OR 
   c-ponto-faturavel = 'Importado'        OR 
   c-ponto-faturavel = 'Revenda Nacional' OR
   c-ponto-faturavel = 'Manaus'           OR 
   c-ponto-faturavel = 'FCI'              THEN DO:

   RUN pi-atualiza-cd0903.

   FIND FIRST ITEM WHERE ITEM.it-codigo = p-item NO-LOCK NO-ERROR.
   
   RUN pi-gerar-dados-extrato (' 222 item.cd-trib-icm -- ' + STRING(item.cd-trib-icm)).

   IF NOT l-gerador-solar THEN DO:
      IF ITEM.cod-estabel <> '601' AND 
         ITEM.cod-estabel <> '602' THEN
         RUN pi-atualiza-escdp050.
    
      RUN pi-atualiza-cd0356.
    
      RUN pi-gerar-dados-extrato (' 333 item.cd-trib-icm -- ' + STRING(item.cd-trib-icm)).
    
      IF estabelec.estado = 'SC' THEN DO:
         RUN pi-atualiza-cd0755. 
         RUN pi-atualiza-ft0312.
      END.
    
      RUN pi-gerar-dados-extrato (' 444 item.cd-trib-icm -- ' + STRING(item.cd-trib-icm)).
    
      /* Regra Manaus */
      IF c-ponto-faturavel = 'Manaus' THEN DO:
         RUN pi-atualiza-OF0147.   
         RUN pi-atualiza-cd0355. 
      END.
   END. /* NOT l-gerador */

END.

/* Servicos */
IF c-ponto-faturavel = 'Servicos' THEN DO:
   RUN pi-atualiza-cd0903. 
END.    

/* Itens Combo */
IF histor-integra-item.tipo-item = 'Combo' THEN DO:
   FIND b-item-aux WHERE b-item-aux.it-codigo  = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL b-item-aux THEN
      ASSIGN b-item-aux.cd-trib-icm  = 2. /* Isento */

   RELEASE b-item-aux.
END.

RUN pi-gerar-dados-extrato (' 666 item.cd-trib-icm -- ' + STRING(item.cd-trib-icm)).


/* Comentado 17/02/21 dœvida do Leonam em como tratar

/* Exportacao */ 

FIND FIRST classif-fisc 
     WHERE classif-fisc.class-fiscal = ITEM.class-fiscal 
NO-LOCK NO-ERROR.

IF AVAIL classif-fisc THEN DO:
   IF classif-fisc.unidade = 'PC' AND SUBSTRING(classif-fisc.char-2,2,2) = 'KG' THEN DO:
   
      FIND b-item-aux WHERE b-item-aux.it-codigo  = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL b-item-aux THEN DO:
         ASSIGN SUBSTRING(b-item-aux.char-1,341,1) = '4' /* Origem Unidade Tributavel*/
                b-item-aux.cd-trib-icm  = 2. /* Isento */

         RUN pi-gerar-dados-extrato (' 77777 item.cd-trib-icm -- ' + STRING(b-item-aux.cd-trib-icm)).

         RELEASE b-item-aux.
      END.
   END.
END.
*/

RUN pi-gerar-dados-extrato (' FINAL item.cd-trib-icm -- ' + STRING(item.cd-trib-icm)).


RUN pi-verifica-pendencia (INPUT ITEM.it-codigo, 
                           INPUT p-sequencia,    
                           INPUT c-ponto-faturavel).

RUN pi-gerar-dados-extrato (">> FIM pi-item-faturavel").


RETURN 'OK'.

/*Fim Programa */

/**********************************************************************************************************************/
/*------------------------------------------- Procedures Internas ----------------------------------------------------*/
/**********************************************************************************************************************/

PROCEDURE pi-atualiza-escdp050:

   DEFINE VARIABLE c-ufs       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-ufs-aux   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cont-uf   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE i-num-uf-pe AS INTEGER   NO-UNDO.

   ASSIGN c-ufs = 'RO,AC,AM,RR,PA,AP,TO,MA,PI,CE,RN,PB,PE,AL,SE,BA,MG,ES,RJ,SP,PR,SC,RS,MS,MT,GO,DF'.

   FIND FIRST ITEM WHERE ITEM.it-codigo = p-item NO-LOCK NO-ERROR.        

   RUN pi-gerar-dados-extrato (">> ENTROU pi-atualiza-escdp050 ").

   RUN pi-gerar-dados-extrato (">> ITEM: " + ITEM.it-codigo + 
                               " - NCM:  " + histor-integra-item.class-fiscal + 
                               " - ORIGEM: " + string(ITEM.codigo-orig)).

   ASSIGN l-achou = NO.

     /* Estados de Atendimento Entreposto */
   RUN esp/es0018p.p (INPUT  'esftp212',
                      INPUT  1,
                      INPUT  0,
                      INPUT  "":U,
                      OUTPUT TABLE tt-prog-ponto).

   FIND FIRST tt-prog-ponto NO-ERROR.

   IF AVAIL tt-prog-ponto THEN
      ASSIGN i-num-uf-pe = NUM-ENTRIES(tt-prog-ponto.conteudo,';').

   IF ITEM.it-codigo < '3999999' AND 
      ITEM.it-codigo > '5000000' THEN DO:
      Loop_Item:
      FOR EACH b01-item NO-LOCK 
          WHERE b01-item.it-codigo    <> ITEM.it-codigo
            AND b01-item.class-fiscal = histor-integra-item.class-fiscal
            AND b01-item.codigo-orig  = ITEM.codigo-orig,
          FIRST b01-item-uf-sem-prot NO-LOCK
          WHERE b01-item-uf-sem-prot.it-codigo = b01-item.it-codigo
            AND b01-item-uf-sem-prot.cod-estado-orig = estabelec.estado
          BREAK BY b01-item.it-codigo DESC:

          ASSIGN l-achou = NO.

          RUN pi-gerar-dados-extrato (INPUT 'ITEM COPIA: 1111 - ' + b01-item.it-codigo  ).

          RUN pi-create-escdp050.          

          IF l-achou THEN
             LEAVE loop_Item.
      END.                                 
   END.
   ELSE DO:
       Loop_Item:
       FOR EACH b01-item NO-LOCK 
           WHERE b01-item.it-codigo    <> ITEM.it-codigo
             AND b01-item.it-codigo   >= '3999999'  //'4000000'
             AND b01-item.it-codigo   <= '5000000'  //'4999999'
             AND b01-item.class-fiscal = histor-integra-item.class-fiscal
             AND b01-item.codigo-orig  = ITEM.codigo-orig,
           FIRST b01-item-uf-sem-prot NO-LOCK
           WHERE b01-item-uf-sem-prot.it-codigo = b01-item.it-codigo
             AND b01-item-uf-sem-prot.cod-estado-orig = estabelec.estado:
    
           ASSIGN i-cont-uf = 0
                  c-ufs-aux = ''.
    
           FOR EACH b02-item-uf-sem-prot NO-LOCK 
               WHERE b02-item-uf-sem-prot.it-codigo = b01-item.it-codigo:
    
               IF INDEX(c-ufs,b02-item-uf-sem-prot.estado) > 0 AND 
                  INDEX(c-ufs-aux,b02-item-uf-sem-prot.estado) = 0 THEN DO:  
    
                  IF b02-item-uf-sem-prot.cod-estado-orig = estabelec.estado THEN
                     ASSIGN i-cont-uf = i-cont-uf + 1
                            c-ufs-aux = c-ufs-aux + b02-item-uf-sem-prot.estado + ','.
               END.
    
               IF estabelec.estado <> 'AM' AND b02-item-uf-sem-prot.cod-estado-orig = 'PE' THEN DO:
                  FIND FIRST tt-prog-ponto NO-ERROR.
        
                  IF AVAIL tt-prog-ponto THEN DO:
                     IF INDEX(tt-prog-ponto.conteudo,b02-item-uf-sem-prot.estado) > 0 THEN DO:
                        ASSIGN i-cont-uf = i-cont-uf + 1.
                     END.
                  END.
               END.
           END.
            
           IF estabelec.estado = 'AM' THEN DO:
              IF i-cont-uf < 27 THEN NEXT Loop_Item.
           END.
           ELSE DO:
              IF i-cont-uf < 27 + i-num-uf-pe THEN NEXT Loop_Item.
           END.
    
           RUN pi-gerar-dados-extrato (INPUT 'ITEM COPIA: 2222 - ' + b01-item.it-codigo  ).
    
           /*
           FOR EACH b02-item-uf-sem-prot NO-LOCK 
               WHERE b02-item-uf-sem-prot.it-codigo = b01-item.it-codigo
                 /*AND b02-item-uf-sem-prot.cod-estado-orig = estabelec.estado*/ :
                
               CASE estabelec.estado:
                   WHEN 'SC' THEN DO:
                      IF b02-item-uf-sem-prot.cod-estado-orig <> 'SC' AND 
                         b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
                   END.  
                   WHEN 'MG' THEN DO:
                      IF b02-item-uf-sem-prot.cod-estado-orig <> 'MG' AND 
                         b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
                   END.  
                   WHEN 'AM' THEN DO:
                      IF b02-item-uf-sem-prot.cod-estado-orig <> 'AM' AND 
                         b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
                   END.
               END CASE.
           
               FIND FIRST item-uf-sem-prot NO-LOCK 
                    WHERE item-uf-sem-prot.it-codigo = ITEM.it-codigo
                      AND item-uf-sem-prot.cod-estado-orig = b02-item-uf-sem-prot.cod-estado-orig
                      AND item-uf-sem-prot.estado = b02-item-uf-sem-prot.estado
               NO-ERROR.
           
               IF NOT AVAIL item-uf-sem-prot THEN DO:
                  CREATE item-uf-sem-prot.
                  BUFFER-COPY b02-item-uf-sem-prot EXCEPT it-codigo TO item-uf-sem-prot.
           
                  ASSIGN item-uf-sem-prot.it-codigo = ITEM.it-codigo.
                   
                  /* Destaque NF */
                  IF b02-item-uf-sem-prot.log-1 THEN 
                  DO:
                     /* Cria CD0904A */
                     RUN pi-atualiza-cd0904a.
                  END.
    
                  RUN pi-gerar-dados-extrato (">> CRIOU - ITEM: " + b01-item.it-codigo + 
                                              " - DESTINO: " + item-uf-sem-prot.estado + 
                                              " - ORIGEM: "  + item-uf-sem-prot.cod-estado-orig ).
    
               END.
               ELSE DO:
                  /* Destaque NF */
                  IF item-uf-sem-prot.log-1 THEN 
                     RUN pi-atualiza-cd0904a.
               END.
           
               ASSIGN l-achou = YES.
           END.
           */
    
           RUN pi-create-escdp050.
           
           IF l-achou THEN
              LEAVE loop_Item.
       END.
   END.



   IF l-achou THEN DO:
      RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                 INPUT p-sequencia,
                                 INPUT 'escdp050').
   END.
   ELSE DO:
      RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                               INPUT p-sequencia,
                               INPUT 'ESCDP050 Pendente: Nao localizado nenhum Item com NCM e UF Origem semelhantes').
   END.

   RUN pi-gerar-dados-extrato (">> FIM pi-atualiza-escdp050 ").

END PROCEDURE.


PROCEDURE pi-create-escdp050:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH b02-item-uf-sem-prot NO-LOCK 
        WHERE b02-item-uf-sem-prot.it-codigo = b01-item.it-codigo
          /*AND b02-item-uf-sem-prot.cod-estado-orig = estabelec.estado*/ :

        CASE estabelec.estado:
            WHEN 'SC' THEN DO:
               IF b02-item-uf-sem-prot.cod-estado-orig <> 'SC' AND 
                  b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
            END.  
            WHEN 'MG' THEN DO:
               IF b02-item-uf-sem-prot.cod-estado-orig <> 'MG' AND 
                  b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
            END.  
            WHEN 'AM' THEN DO:
               IF b02-item-uf-sem-prot.cod-estado-orig <> 'AM' AND 
                  b02-item-uf-sem-prot.cod-estado-orig <> 'PE' THEN NEXT.  
            END.
        END CASE.

        FIND FIRST item-uf-sem-prot NO-LOCK 
             WHERE item-uf-sem-prot.it-codigo = ITEM.it-codigo
               AND item-uf-sem-prot.cod-estado-orig = b02-item-uf-sem-prot.cod-estado-orig
               AND item-uf-sem-prot.estado = b02-item-uf-sem-prot.estado
        NO-ERROR.

        IF NOT AVAIL item-uf-sem-prot THEN DO:
           CREATE item-uf-sem-prot.
           BUFFER-COPY b02-item-uf-sem-prot EXCEPT it-codigo TO item-uf-sem-prot.

           ASSIGN item-uf-sem-prot.it-codigo = ITEM.it-codigo.

           /* Destaque NF */
           IF b02-item-uf-sem-prot.log-1 THEN 
           DO:
              /* Cria CD0904A */
              RUN pi-atualiza-cd0904a.
           END.

           RUN pi-gerar-dados-extrato (">> CRIOU - ITEM: " + b01-item.it-codigo + 
                                       " - DESTINO: " + item-uf-sem-prot.estado + 
                                       " - ORIGEM: "  + item-uf-sem-prot.cod-estado-orig ).

        END.
        ELSE DO:
           /* Destaque NF */
           IF item-uf-sem-prot.log-1 THEN 
              RUN pi-atualiza-cd0904a.
        END.

        ASSIGN l-achou = YES.
    END.

END PROCEDURE.


PROCEDURE pi-atualiza-cd0356:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-grupoEmit AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-cd0356    AS LOGICAL NO-UNDO.

    RUN pi-gerar-dados-extrato ("INICIO cd0356").
    
    FOR EACH sit-tribut NO-LOCK 
        WHERE sit-tribut.cdn-tribut     = 21
          /*AND sit-tribut.cdn-sit-tribut >= 700
          AND sit-tribut.cdn-sit-tribut <= 1200*/ :

        RUN pi-gerar-dados-extrato ("ENTROU sit-tribut ").

        FOR FIRST b01-sit-tribut-relacto NO-LOCK
            WHERE b01-sit-tribut-relacto.cdn-tribut       = 21                                                               
              AND b01-sit-tribut-relacto.idi-tip-docto    = 2 //Saida
              AND b01-sit-tribut-relacto.cdn-sit-tribut   = sit-tribut.cdn-sit-tribut  
              AND b01-sit-tribut-relacto.cod-ncm          = ITEM.class-fiscal
              AND b01-sit-tribut-relacto.cod-item         <> ITEM.it-codigo
              AND b01-sit-tribut-relacto.cod-item         <> '*':
             
             RUN pi-gerar-dados-extrato ("ENTROU b01-sit-tribut-relacto ").

            FOR EACH b02-sit-tribut-relacto NO-LOCK
                WHERE b02-sit-tribut-relacto.cdn-tribut       = 21                                                               
                  AND b02-sit-tribut-relacto.idi-tip-docto    = 2 
                  AND b02-sit-tribut-relacto.cdn-sit-tribut   = b01-sit-tribut-relacto.cdn-sit-tribut
                  AND b02-sit-tribut-relacto.cod-ncm          = ITEM.class-fiscal
                  AND b02-sit-tribut-relacto.cod-item         = b01-sit-tribut-relacto.cod-item:

                RUN pi-gerar-dados-extrato ("ENTROU b02-sit-tribut-relacto " + b02-sit-tribut-relacto.cod-item).

                FIND FIRST sit-tribut-relacto
                     WHERE sit-tribut-relacto.cdn-tribut       = 21                                                               
                       AND sit-tribut-relacto.idi-tip-docto    = 2 
                       AND sit-tribut-relacto.cod-estab        = b02-sit-tribut-relacto.cod-estab       
                       AND sit-tribut-relacto.cod-natur-operac = b02-sit-tribut-relacto.cod-natur-operac
                       AND sit-tribut-relacto.cod-ncm          = b02-sit-tribut-relacto.cod-ncm         
                       AND sit-tribut-relacto.cod-item         = ITEM.it-codigo        
                       AND sit-tribut-relacto.cdn-grp-emit     = b02-sit-tribut-relacto.cdn-grp-emit
                       AND sit-tribut-relacto.cdn-emitente     = b02-sit-tribut-relacto.cdn-emitente    
                       AND sit-tribut-relacto.cdn-sit-tribut   = b02-sit-tribut-relacto.cdn-sit-tribut   
                       AND sit-tribut-relacto.cod-livre-1      = b02-sit-tribut-relacto.cod-livre-1     
                NO-LOCK NO-ERROR.

                RUN pi-gerar-dados-extrato ("AVAIL sit-tribut-relacto " + STRING(AVAIL sit-tribut-relacto) ).

                IF NOT AVAIL sit-tribut-relacto THEN DO:
                   ASSIGN l-cd0356 = YES.

                   RUN pi-gerar-dados-extrato ("CRIOU sit-tribut-relacto").

                   CREATE sit-tribut-relacto.
                   BUFFER-COPY b02-sit-tribut-relacto EXCEPT cod-item TO sit-tribut-relacto.

                   ASSIGN sit-tribut-relacto.cod-item  = ITEM.it-codigo.
                   
                END.
                ELSE
                  ASSIGN l-cd0356  = YES.
            END.
        END.
    END.
   
    IF l-cd0356 THEN
       RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                  INPUT p-sequencia,
                                  INPUT 'cd0356').
    ELSE DO:
       RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                INPUT p-sequencia,
                                INPUT 'CD0356 Pendente: Nao localizado nenhum outro Item com NCM semelhante para realizar copia').
    END.


     RUN pi-gerar-dados-extrato ("FIM cd0356").

END PROCEDURE.

PROCEDURE pi-atualiza-cd0755:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-bodi618 AS HANDLE   NO-UNDO.
    
    RUN dibo/bodi618.p PERSISTENT SET h-bodi618.
    
    RUN openQueryStatic IN h-bodi618 (INPUT "Main":U).
     
    RUN emptyRowErrors IN h-bodi618.

    /*
    RUN esp/es0018p.p (INPUT  'esapi025',
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN l-cd0755 = NO.

    RUN pi-gerar-dados-extrato ('INICIO cd0755').

    FOR EACH tt-prog-ponto:
        IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
            ASSIGN l-cd0755 = YES.
    END.*/

    FOR EACH secao-19 WHERE secao-19.class-fiscal = ITEM.class-fiscal NO-LOCK:

       
       RUN pi-gerar-dados-extrato ('POSSUI PONTO cd0755 - ' + string(l-cd0755) + ' ' + ITEM.class-fiscal).
    
       FOR EACH tt-ct-clas-item: DELETE tt-ct-clas-item. END.
    
       CREATE tt-ct-clas-item.
       ASSIGN tt-ct-clas-item.cod-clas-fisc = secao-19.cod-class-fisc.
       
       IF NOT CAN-FIND(FIRST ct-clas-item                                               
                       WHERE ct-clas-item.cod-clas-fisc = tt-ct-clas-item.cod-clas-fisc 
                       AND   ct-clas-item.cod-item      = ITEM.it-codigo ) THEN DO: 
    
           RUN pi-gerar-dados-extrato ('CRIA ct-clas-item' ).
       
           ASSIGN tt-ct-clas-item.cod-item = ITEM.it-codigo.      

           RUN setRecord    IN h-bodi618 (INPUT TABLE tt-ct-clas-item).                 
           RUN createRecord IN h-bodi618.  
       
           EMPTY TEMP-TABLE RowErrorsAux.
           RUN getRowErrors IN h-bodi618 (OUTPUT TABLE RowErrorsAux).
       END. 

       
       RUN pi-gerar-dados-extrato ("AVAIL rowErrors : " + string(CAN-FIND(FIRST RowErrorsAux)) ).
    
       IF NOT CAN-FIND(FIRST RowErrorsAux) THEN 
          RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                     INPUT p-sequencia,
                                     INPUT 'cd0755').
       ELSE DO:
          FOR EACH RowErrorsAux:
              RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                       INPUT p-sequencia,
                                       INPUT 'CD0755 Pendente: ' + RowErrorsAux.ErrorDescription).
          END.
       END.
    END. /* FOR EACH secao-19 */

    DELETE PROCEDURE h-bodi618.
           
    RUN pi-gerar-dados-extrato ('FIM cd0755').

END PROCEDURE.



PROCEDURE pi-atualiza-cd0903:

    DEFINE VARIABLE l-penden-cd0903 AS LOGICAL NO-UNDO.

    ASSIGN l-penden-cd0903 = YES.

    FIND b-item-CD0903  WHERE b-item-CD0903.it-codigo  = ITEM.it-codigo   EXCLUSIVE-LOCK NO-ERROR.

    RUN pi-gerar-dados-extrato("ENTROU pi-atualiza-cd0903").

    RUN pi-gerar-dados-extrato("SITUACAO/PONTO - " + c-ponto-faturavel).
    
    IF c-ponto-faturavel = 'Servicos' THEN
       ASSIGN b-item-CD0903.cd-trib-iss  = 1. /* Tributado */
    ELSE
       ASSIGN b-item-CD0903.cd-trib-iss  = 2. /* Isento */

    CASE c-ponto-faturavel:
       //Ponto 01 - Lei de informÿtica itens fabricados
       WHEN 'Fabricado' THEN DO:
          IF AVAIL b-item-CD0903 THEN DO:
             ASSIGN b-item-CD0903.codigo-orig  = 4 
                    b-item-CD0903.fator-conver = 1
                    b-item-CD0903.ind-ipi-dife = NO.

             ASSIGN OVERLAY(b-item-CD0903.char-2,31,5) = STRING(1.65,"99.99")  /* Aliq.PIS    */
                    OVERLAY(b-item-CD0903.char-2,36,5) = STRING(7.60,"99.99"). /* Aliq.Cofins */
    
             ASSIGN l-penden-cd0903 = NO.

             RELEASE b-item-CD0903.
          END.
       END.

       WHEN 'Revenda' THEN DO:
          //Ponto 03 - Lei de informÿtica itens de revenda
          IF AVAIL b-item-CD0903 THEN DO:
             ASSIGN b-item-CD0903.codigo-orig  = 4  
                    b-item-CD0903.fator-conver = 1
                    b-item-CD0903.ind-ipi-dife = YES
                    b-item-CD0903.aliquota-ipi = 0
                    b-item-CD0903.cd-trib-ipi  = 3.

             /*Ft Conv Unidade Tributavel */
             ASSIGN OVERLAY(b-item-CD0903.char-1,321,20) = STRING(1,">>>,>>>,>>9.9999999999").
    
             ASSIGN l-penden-cd0903 = NO.          

             RELEASE b-item-CD0903.
          END.
       END.
        
       /*
       WHEN 'FCI' THEN DO:
          //Ponto 04 - FCI
          IF AVAIL b-item-CD0903 THEN DO:
             ASSIGN b-item-CD0903.fator-conver = 1.
             
             ASSIGN b-item-CD0903.ind-ipi-dife = IF b-item-CD0903.ge-codigo = 45 /*REVENDA*/ THEN YES ELSE NO /*PRODUZIDO*/
                    b-item-CD0903.aliquota-ipi = 0
                    b-item-CD0903.cd-trib-ipi  = 3  //OUTROS
                    b-item-CD0903.cd-trib-icm  = 1. //NORMAL ???

             ASSIGN l-penden-cd0903 = NO.
            
             RELEASE b-item-CD0903.
          END.
       END.*/

       WHEN 'Manaus' THEN DO:
          //Ponto 04 - Manaus
          IF AVAIL b-item-CD0903 THEN DO:
              ASSIGN b-item-CD0903.codigo-orig  = 4 
                     b-item-CD0903.fator-conver = 1
                     b-item-CD0903.ind-ipi-dife = YES
                     b-item-CD0903.aliquota-ipi = 0
                     b-item-CD0903.cd-trib-ipi  = 2  //ISENTO
                     b-item-CD0903.cd-trib-icm  = 4. //REDUZIDO

              ASSIGN l-penden-cd0903 = NO.
    
              RELEASE b-item-CD0903.
          END.
       END.

       WHEN 'Importado' THEN DO:
          /*Ft Conv Unidade Tributavel */
          ASSIGN OVERLAY(b-item-CD0903.char-1,321,20) = STRING(1,">>>,>>>,>>9.9999999999").

          ASSIGN l-penden-cd0903 = NO.          

          RELEASE b-item-CD0903.
       END.

       WHEN 'Revenda Nacional' OR 
       WHEN 'FCI' THEN DO:

          RUN pi-gerar-dados-extrato ('ENTROU FCI 1').

          /*Ft Conv Unidade Tributavel */
          ASSIGN OVERLAY(b-item-CD0903.char-1,321,20) = STRING(1,">>>,>>>,>>9.9999999999")
                 b-item-CD0903.ind-ipi-dife = YES
                 b-item-CD0903.aliquota-ipi = 0
                 b-item-CD0903.cd-trib-ipi  = 3.

          ASSIGN l-penden-cd0903 = NO.   
          
          IF c-ponto-faturavel = 'FCI' THEN DO:

             RUN pi-gerar-dados-extrato ('ENTROU FCI CD0903').

             IF AVAIL b-item-CD0903 THEN DO:
                ASSIGN b-item-CD0903.fator-conver = 1.
                 
                 ASSIGN b-item-CD0903.ind-ipi-dife = IF b-item-CD0903.ge-codigo = 45 /*REVENDA*/ THEN YES ELSE NO /*PRODUZIDO*/
                        b-item-CD0903.aliquota-ipi = 0
                        b-item-CD0903.cd-trib-ipi  = IF b-item-CD0903.ge-codigo = 45 /*REVENDA*/ THEN 3 /*OUTROS*/ ELSE 1 /*TRIBUTADO*/
                        b-item-CD0903.cd-trib-icm  = 1. //TRIBUTADO

                 
                 RUN pi-gerar-dados-extrato ('b-item-CD0903.cd-trib-icm -- ' + STRING(b-item-CD0903.cd-trib-icm)).
    
                 ASSIGN l-penden-cd0903 = NO.
                
                 /*
                 IF b-item-CD0903.ge-codigo = 40 OR b-item-CD0903.ge-codigo = 42 THEN
                    ASSIGN b-item-CD0903.ind-ipi-dife = NO.*/
                
                 ASSIGN OVERLAY(b-item-CD0903.char-2,31,5) = STRING(1.65,"99.99")  /*Aliq.PIS*/
                        OVERLAY(b-item-CD0903.char-2,36,5) = STRING(7.60,"99.99"). /*Aliq.Cofins*/
             
                RUN pi-gerar-dados-extrato ('Antes Calcula FCI' + ITEM.it-codigo ).
               
                RUN esapi/esapi025c.p (INPUT ITEM.it-codigo, OUTPUT TABLE tt-fci).
               
                RUN pi-gerar-dados-extrato ('DEPOIS Calcula FCI').
               
                ASSIGN de-perc = 0.
               
                FOR EACH tt-fci:
                    ASSIGN de-perc = ROUND((tt-fci.tot-parcela / tt-fci.valor-medio) * 100,2). 
                END.
               
                RUN pi-gerar-dados-extrato ('PERC.FCI - ' + STRING(de-perc)).
               
                IF de-perc = 0 THEN 
                   ASSIGN b-item-CD0903.codigo-orig = 0.
                ELSE DO:
                   IF de-perc < 40 THEN 
                      ASSIGN b-item-CD0903.codigo-orig = 5.
                   IF de-perc > 40 AND de-perc <= 70 THEN 
                      ASSIGN b-item-CD0903.codigo-orig = 3.
                   IF de-perc > 70 THEN 
                      ASSIGN b-item-CD0903.codigo-orig = 8.
                END.
               
                FIND FIRST tt-fci NO-ERROR.
               
                /*Geracao Arquivo FCI */
                IF AVAIL tt-fci THEN DO:
                   RUN pi-gerar-dados-extrato ('Gerando Arquivo FCI').
               
                   RUN esapi/esapi025d.p (INPUT TABLE tt-fci,OUTPUT TABLE tt-fci-excec).
                 
                   RUN pi-gerar-dados-extrato ('ERRO Arquivo FCI').
               
                   FOR EACH tt-fci-excec:
                       RUN pi-gerar-dados-extrato ('ERRO Arquivo FCI - ' + tt-fci-excec.erro).
                   END.
                END.
               
                RELEASE b-item-CD0903.
             END.
          END.
       END.  
       
       WHEN 'SERVICOS' THEN DO:
          //Ponto 06 - SERVICOS 
          IF AVAIL b-item-CD0903 THEN DO:
             RUN pi-atualiza-servico.

             ASSIGN l-penden-cd0903 = NO.
    
             RELEASE b-item-CD0903.
          END.
       END.  
    END CASE.


    IF l-gerador-solar THEN DO:

       FIND b-item-CD0903  WHERE b-item-CD0903.it-codigo  = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
        
       IF AVAIL b-item-CD0903 THEN DO:
          ASSIGN b-item-CD0903.cd-trib-icm  = 2  //ISENTO     
                 b-item-CD0903.cd-trib-iss  = 2  //ISENTO 
                 b-item-CD0903.cd-trib-ipi  = 1. //TRIBUTADO

          RELEASE b-item-CD0903.
       END.
    END.
       

    RUN pi-gerar-dados-extrato("ATUALIZACAO CD0903 PENTENTE ?? - " + STRING(l-penden-cd0903)).
   
    IF NOT l-penden-cd0903 THEN
       RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                  INPUT p-sequencia,
                                  INPUT 'cd0903').
    ELSE
       RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                INPUT p-sequencia,
                                INPUT 'CD0903 Pendente: Nenhuma condi»’o foi atendida para atualizar este cadastro').


    RUN pi-gerar-dados-extrato("FIM pi-atualiza-cd0903").
END PROCEDURE.


PROCEDURE pi-atualiza-servico:

    /*ASSIGN b-item-CD0903.class-fiscal = '0000000'.*/

    ASSIGN b-item-CD0903.codigo-orig  = 0
           b-item-CD0903.fator-conver = 1
           b-item-CD0903.tipo-contr   = 4  /* Debito Direto */
           b-item-CD0903.baixa-estoq  = NO.
              
    /* Treinamento */
    IF b-item-CD0903.fm-codigo = '99000000' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 802
              b-item-CD0903.aliquota-iss = 3
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

    /* Locacao Prod */
    IF b-item-CD0903.fm-codigo = '99100001' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 2
              b-item-CD0903.aliquota-iss = 0
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 2. /* Isento */

    /* Fatura Sinistro */
    IF b-item-CD0903.fm-codigo = '99100003' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 1
              b-item-CD0903.aliquota-iss = 0
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 2. /* Isento */

    /* Locacao Imovel */
    IF b-item-CD0903.fm-codigo = '99100004' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 2
              b-item-CD0903.aliquota-iss = 0
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 2. /* Isento */

    /* Licenca de Software-Comprado */
    IF b-item-CD0903.fm-codigo = '99400000' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 105
              b-item-CD0903.aliquota-iss = 2
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

    /* Licen»a de Software-Des. Interno (Exporta»’o) */
    IF b-item-CD0903.fm-codigo = '99400001' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 105
              b-item-CD0903.aliquota-iss = 2
              b-item-CD0903.cd-trib-ipi  = 1  /* Tributado */
              b-item-CD0903.cd-trib-icm  = 1  /* Tributado */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

    /* Licen»a de Hospedagem-Servidor  */
    IF b-item-CD0903.fm-codigo = '99400002' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 105
              b-item-CD0903.aliquota-iss = 2
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

    /* Licen»a de Software - Prediotech  */
    IF b-item-CD0903.fm-codigo = '99400003' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 1059
              b-item-CD0903.aliquota-iss = 2
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

        /* LSoftware/Produto Lan»ado  */
    IF b-item-CD0903.fm-codigo = '99400004' THEN 
       ASSIGN b-item-CD0903.cod-servico  = 105
              b-item-CD0903.aliquota-iss = 2
              b-item-CD0903.cd-trib-ipi  = 2  /* Isento */
              b-item-CD0903.cd-trib-icm  = 2  /* Isento */
              b-item-CD0903.cd-trib-iss  = 1. /* Tributado */

END PROCEDURE.


PROCEDURE pi-atualiza-ft0312:

    DEFINE VARIABLE l-atualiza-ft0312 AS LOGICAL  NO-UNDO.

    RUN pi-gerar-dados-extrato (">> Entrou pi-atualiza-ft0312 ").
    RUN pi-gerar-dados-extrato (">> SITUACAO/PONTO - " +  c-ponto-faturavel).
   
    CASE c-ponto-faturavel:
        WHEN 'Fabricado' THEN DO:
           ASSIGN l-atualiza-ft0312 = FnAtualizaFt0312(c-ponto-faturavel).

           IF l-atualiza-ft0312 THEN 
               RUN pi-atualiza-ft0312-2(INPUT estabelec.estado, //ESTABELEC
                                        INPUT ITEM.it-codigo,   //ITEM
                                        INPUT 12,               //ALIQUOTA ICMS
                                        INPUT YES,              //DESCONSIDERA PARA NAO CONTRIBUINTE
                                        INPUT 79).              //MENSAGEM     
        END.
        WHEN 'Revenda' OR WHEN 'Revenda Nacional' OR WHEN 'FCI' THEN DO:
           /* Funcao verifica se FT0312 deve ser atualizado */
           ASSIGN l-atualiza-ft0312 = FnAtualizaFt0312(c-ponto-faturavel).

           RUN pi-gerar-dados-extrato (">> FnAtualizaFt0312 - " + STRING(l-atualiza-ft0312)).
        
           IF l-atualiza-ft0312 THEN DO:
              //SECAO XIX
              FIND FIRST secao-19 
                   WHERE secao-19.class-fisc     = ITEM.class-fisc 
                     AND secao-19.cod-class-fisc = 'secao XIX'
              NO-LOCK NO-ERROR.

              RUN pi-gerar-dados-extrato (">> AVAIL secao-19 - " + STRING(AVAIL secao-19)).
              RUN pi-gerar-dados-extrato (">> ITEM.class-fisc  - " + STRING(ITEM.class-fisc )).

              RUN pi-gerar-dados-extrato (">> SITUACAO/PONTO - " +  c-ponto-faturavel).
            
              RUN pi-atualiza-ft0312-2 (INPUT estabelec.estado,                     //ESTABELEC
                                        INPUT ITEM.it-codigo,                       //ITEM
                                        INPUT 12,                                   //ALIQUOTA ICMS
                                        INPUT IF AVAIL secao-19 THEN NO  ELSE YES,  //DESCONSIDERA PARA NAO CONTRIBUINTE
                                        INPUT IF AVAIL secao-19 THEN 823 ELSE 829). //MENSAGEM
           END.
           /*ELSE DO:
              RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                       INPUT histor-integra-item.sequencia,
                                       INPUT 'FT0312 Pendente: Nao encontrado cadastro').
           END.*/
        END.
        WHEN 'Importado' THEN DO:
            IF ITEM.codigo-orig = 1 OR ITEM.codigo-orig = 6 THEN 
               RUN pi-atualiza-ft0312-2(INPUT estabelec.estado, //ESTABELEC
                                        INPUT ITEM.it-codigo,   //ITEM
                                        INPUT IF ITEM.codigo-orig = 1 THEN 4 ELSE 12, //ALIQUOTA ICMS
                                        INPUT YES,               //DESCONSIDERA PARA NAO CONTRIBUINTE
                                        INPUT 78).              //MENSAGEM
        END.

        /*WHEN 'Revenda Nacional' THEN DO:

            ASSIGN l-atualiza-ft0312 = FnAtualizaFt0312(c-ponto-faturavel).
        
            IF l-atualiza-ft0312 THEN DO:
               FIND FIRST secao-19 WHERE secao-19.class-fisc = ITEM.class-fisc NO-LOCK NO-ERROR.
    
               IF AVAIL secao-19 THEN
                  RUN pi-atualiza-ft0312-2 (INPUT estabelec.estado,  //ESTABELEC
                                            INPUT ITEM.it-codigo,    //ITEM
                                            INPUT 12,                //ALIQUOTA ICMS
                                            INPUT NO,                //DESCONSIDERA PARA NAO CONTRIBUINTE
                                            INPUT 823).              //MENSAGEM
               ELSE
                  RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                           INPUT p-sequencia,
                                           INPUT 'FT0312 Pendente: Nao localizado cadastro secao 19 com classificacao - ' + ITEM.class-fisc ).

            END.
        END.*/

    END CASE.

    RUN pi-gerar-dados-extrato (">> ATUALIZOU ft0312 - " + STRING(l-atualiza-ft0312)).
    RUN pi-gerar-dados-extrato (">> FIM ft0312 "). 

END PROCEDURE.


PROCEDURE pi-atualiza-ft0312-2:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM p-estado       AS CHAR NO-UNDO.
  DEF INPUT PARAM p-item         AS CHAR NO-UNDO.
  DEF INPUT PARAM p-aliquota     AS DEC  NO-UNDO.
  DEF INPUT PARAM p-desconsidera AS LOG  NO-UNDO.
  DEF INPUT PARAM p-mensagem     AS INT  NO-UNDO.

  FIND FIRST icms-it-uf 
       WHERE icms-it-uf.estado    = p-estado
         AND icms-it-uf.it-codigo = p-item
  EXCLUSIVE-LOCK NO-ERROR.

  IF NOT AVAIL icms-it-uf THEN DO:
     CREATE icms-it-uf.
     ASSIGN icms-it-uf.estado    = p-estado
            icms-it-uf.it-codigo = p-item.
  
     CREATE int-icms-it-uf.
     BUFFER-COPY icms-it-uf TO int-icms-it-uf.
  END.

  ASSIGN icms-it-uf.aliquota-icm = p-aliquota
         icms-it-uf.log-descons-para-nao-contribt = p-desconsidera.

  FIND FIRST int-icms-it-uf 
       WHERE int-icms-it-uf.estado    = p-estado
         AND int-icms-it-uf.it-codigo = p-item
  EXCLUSIVE-LOCK NO-ERROR.

  IF AVAIL int-icms-it-uf THEN DO:
     ASSIGN int-icms-it-uf.cod-mensagem = p-mensagem.

     RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                INPUT histor-integra-item.sequencia,
                                INPUT 'ft0312').
  END.

END PROCEDURE.


PROCEDURE pi-atualiza-cd0904a:
  
    FIND FIRST item-uf
         WHERE item-uf.it-codigo       = ITEM.it-codigo                   
           AND item-uf.estado          = item-uf-sem-prot.estado              
           AND item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig     
    NO-LOCK NO-ERROR.

    IF NOT AVAIL item-uf THEN DO:
       CREATE item-uf.
       ASSIGN item-uf.it-codigo                = ITEM.it-codigo
              item-uf.estado                   = item-uf-sem-prot.estado
              item-uf.cod-estado-orig          = item-uf-sem-prot.cod-estado-orig
              item-uf.per-sub-tri              = item-uf-sem-prot.per-sub-tri             
              item-uf.perc-red-sub             = item-uf-sem-prot.perc-red-sub            
              item-uf.dec-1                    = item-uf-sem-prot.dec-1.                   
    END.
   

    /*
    /* Estados de Atendimento Entreposto */
    RUN esp/es0018p.p (INPUT  'esftp212',
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAIL tt-prog-ponto THEN DO:
       IF INDEX(tt-prog-ponto.conteudo,b02-item-uf-sem-prot.estado) > 0 THEN DO:

          FIND FIRST item-uf
               WHERE item-uf.it-codigo       = ITEM.it-codigo                   
                 AND item-uf.estado          = item-uf-sem-prot.estado              
                 AND item-uf.cod-estado-orig = 'PE'     
          NO-LOCK NO-ERROR.
        
          IF NOT AVAIL item-uf THEN DO:
             CREATE item-uf.
             ASSIGN item-uf.it-codigo                = ITEM.it-codigo
                    item-uf.estado                   = item-uf-sem-prot.estado
                    item-uf.cod-estado-orig          = 'PE'
                    item-uf.per-sub-tri              = item-uf-sem-prot.per-sub-tri             
                    item-uf.perc-red-sub             = item-uf-sem-prot.perc-red-sub            
                    item-uf.dec-1                    = item-uf-sem-prot.dec-1.                   
          END.  
       END.
    END.
    */

    RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                               INPUT p-sequencia,
                               INPUT 'cd0904a').

END PROCEDURE.


PROCEDURE pi-atualiza-OF0147:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-sped-entrada AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-sped-saida   AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN pi-gerar-dados-extrato("ENTROU OF0147").

    FIND FIRST item-uni-estab 
         WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
           AND item-uni-estab.cod-estabel = ITEM.cod-estabel
    EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL item-uni-estab THEN DO:
       RUN pi-gerar-dados-extrato("AVAIl item-uni-estab - OF0147").

       RUN esp/es0018p.p (INPUT  'esapi025',
                          INPUT  2,
                          INPUT  0,
                          INPUT  "":U,
                          OUTPUT TABLE tt-prog-ponto).
    
       RUN pi-gerar-dados-extrato("PASSOU 2 - AVAIL tt-prog-ponto - " + STRING(CAN-FIND(FIRST tt-prog-ponto)) ).

       FOR EACH tt-prog-ponto:
           ASSIGN c-sped-entrada = ENTRY(1,tt-prog-ponto.conteudo,';') 
                  c-sped-saida   = ENTRY(2,tt-prog-ponto.conteudo,';').  
       END.

       RUN pi-gerar-dados-extrato (" c-sped-entrada :" + c-sped-entrada ).
       RUN pi-gerar-dados-extrato (" c-sped-saida :"   + c-sped-saida   ).
    
       ASSIGN OVERLAY(item-uni-estab.char-1,311,10) = c-sped-entrada //Cod Ajuste Entrada
              OVERLAY(item-uni-estab.char-1,321,10) = c-sped-saida.  //Cod Ajuste Saida

       RELEASE item-uni-estab.

       IF c-sped-entrada <> '' AND c-sped-saida <> '' THEN
          RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                     INPUT p-sequencia,
                                     INPUT 'of0147').
       ELSE
          RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                   INPUT p-sequencia,
                                   INPUT 'OF0147 Pendente: Codigo de Ajustes Entrada/Sa­da nao foram preenchidos corretamente no ES0018').
    END.
    ELSE DO:

       RUN pi-gerar-dados-extrato("NOT AVAIl item-uni-estab - OF0147").

       RUN pi-motivo-pendencia (INPUT ITEM.it-codigo,
                                INPUT p-sequencia,
                                INPUT 'OF0147 Pendente: Nao encontrado relacionamento Item UniEstab').
    END.

    RUN pi-gerar-dados-extrato("FIM - OF0147").

END PROCEDURE.


PROCEDURE pi-atualiza-cd0355:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-gerar-dados-extrato("ENTROU cd0355").

    FOR EACH sit-tribut NO-LOCK 
        WHERE sit-tribut.cdn-sit-tribut = 335:
        
        FIND FIRST sit-tribut-relacto
             WHERE sit-tribut-relacto.cdn-tribut       = sit-tribut.cdn-tribut                                                           
               AND sit-tribut-relacto.idi-tip-docto    = 2  //Verificar
               AND sit-tribut-relacto.cod-estab        = '*'
               AND sit-tribut-relacto.cod-natur-operac = '*'
               AND sit-tribut-relacto.cod-ncm          = '*'
               AND sit-tribut-relacto.cod-item         = ITEM.it-codigo        
               AND sit-tribut-relacto.cdn-grp-emit     = 0
               AND sit-tribut-relacto.cdn-emitente     = 0
               AND sit-tribut-relacto.cdn-sit-tribut   = sit-tribut.cdn-sit-tribut  
        NO-LOCK NO-ERROR.
    
        IF NOT AVAIL sit-tribut-relacto THEN DO:

           RUN pi-gerar-dados-extrato("CRIOU sit-tribut-relacto").

           CREATE sit-tribut-relacto.
           ASSIGN sit-tribut-relacto.cdn-tribut       = sit-tribut.cdn-tribut     
                  sit-tribut-relacto.idi-tip-docto    = 2  //Verificar            
                  sit-tribut-relacto.cod-estab        = '*'                       
                  sit-tribut-relacto.cod-natur-operac = '*'                       
                  sit-tribut-relacto.cod-ncm          = '*'                       
                  sit-tribut-relacto.cod-item         = ITEM.it-codigo            
                  sit-tribut-relacto.cdn-grp-emit     = 0                         
                  sit-tribut-relacto.cdn-emitente     = 0                         
                  sit-tribut-relacto.cdn-sit-tribut   = sit-tribut.cdn-sit-tribut 
                  sit-tribut-relacto.dat-valid-inic   = TODAY.   

           RUN pi-atualiza-historico (INPUT ITEM.it-codigo,
                                      INPUT p-sequencia,
                                      INPUT 'cd0355').
        END.
        ELSE
          RUN pi-gerar-dados-extrato("JA EXISTE sit-tribut-relacto").
    END.  

    RUN pi-gerar-dados-extrato("FIM cd0355").

END PROCEDURE.





PROCEDURE pi-atualiza-historico:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-item      AS CHARACTER NO-UNDO. 
    DEF INPUT PARAM p-sequencia AS INTEGER   NO-UNDO.
    DEF INPUT PARAM c-programa  AS CHARACTER NO-UNDO.

    RUN pi-gerar-dados-extrato ("ENTROU pi-atualiza-historico: Item : " + p-item + 
                                " - SEQ: " + STRING(p-sequencia) + 
                                " - PROG TUALIZ: " + c-programa ).

    FIND FIRST b01-historico
         WHERE b01-historico.it-codigo = p-item 
           AND b01-historico.sequencia = p-sequencia
    EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL b01-historico THEN DO:
        RUN pi-gerar-dados-extrato ("AVAIL histor-integra-item  - " + c-programa).
        
       CASE c-programa:
          WHEN 'escdp050' THEN b01-historico.escdp050 = YES. 
          WHEN 'cd0355'   THEN b01-historico.cd0355   = YES.
          WHEN 'cd0356'   THEN b01-historico.cd0356   = YES.
          WHEN 'cd0755'   THEN b01-historico.cd0755   = YES.
          WHEN 'cd0903'   THEN b01-historico.cd0903   = YES.
          WHEN 'ft0312'   THEN b01-historico.ft0312   = YES.
          WHEN 'of0147'   THEN b01-historico.of0147   = YES.
          WHEN 'cd0904a'  THEN b01-historico.cd0904a  = YES.
       END CASE.

       RELEASE b01-historico.
    END.                                                          

END PROCEDURE.

  


PROCEDURE pi-motivo-pendencia:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-item      AS CHARACTER NO-UNDO. 
    DEF INPUT PARAM p-sequencia AS INTEGER   NO-UNDO.
    DEF INPUT PARAM p-motivo    AS CHARACTER NO-UNDO.
    
    RUN pi-gerar-dados-extrato ("ENTROU pi-motivo-pendencia: Item : " + p-item + 
                                " - SEQ: " + STRING(p-sequencia) + 
                                " - MOTIVO: " + p-motivo ).

    FIND FIRST b01-historico
         WHERE b01-historico.it-codigo = p-item 
           AND b01-historico.sequencia = p-sequencia
    EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL b01-historico THEN DO:

       ASSIGN b01-historico.pendente-fat = YES.

       RUN pi-gerar-dados-extrato ("AVAIL histor-integra-item  - " + STRING(AVAIL b01-historico)).
        
       ASSIGN b01-historico.char-1 = b01-historico.char-1 + ' * ' + p-motivo.

        RUN pi-gerar-dados-extrato ("Atualiza LOG : " + b01-historico.char-1 ).

       RELEASE b01-historico.
    END.                                                          

END PROCEDURE.


PROCEDURE pi-verifica-pendencia:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-item      AS CHARACTER NO-UNDO. 
    DEF INPUT PARAM p-sequencia AS INTEGER   NO-UNDO.
    DEF INPUT PARAM p-ponto     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE l-valida-ft0312 AS LOGICAL     NO-UNDO.

    RUN pi-gerar-dados-extrato("ENTROU pi-verifica-pendencia").

    FIND FIRST b01-historico
         WHERE b01-historico.it-codigo = p-item 
           AND b01-historico.sequencia = p-sequencia
    EXCLUSIVE-LOCK NO-ERROR.

    RUN pi-gerar-dados-extrato("ITEM : " + p-item + ' SEQ: ' + string(p-sequencia) + 
                               'SITUACAO/PONTO: ' + p-ponto).

    IF AVAIL b01-historico THEN DO:
       
       IF p-ponto = '' /*OR p-ponto = 'FCI'*/  THEN DO:
          ASSIGN b01-historico.pendente-fat = YES.

          /*IF p-ponto = '' THEN*/
             ASSIGN b01-historico.char-1 = 'Erro: Nenhuma condi»’o atendida para tornar o Item Faturavel'.
          /*ELSE
             ASSIGN b01-historico.char-1 = '(Regra para FCI deve ser verificada)'.*/

          ASSIGN p-motivo-pendencia = b01-historico.char-1.

          RUN pi-gerar-dados-extrato("NAO È FATURAVEL: " + b01-historico.char-1).

          RELEASE b01-historico.

          RETURN 'OK'.
       END.
       
       /*
       IF NOT b01-historico.escdp050 OR 
          NOT b01-historico.cd0904a  OR
          NOT b01-historico.cd0356   OR 
          /*NOT b01-historico.cd0755   OR*/ 
          NOT b01-historico.cd0903   THEN 
          ASSIGN b01-historico.pendente-fat = YES.

       ASSIGN l-cd0755 = NO.

       FOR EACH tt-prog-ponto:
           IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
               ASSIGN l-cd0755 = YES.
       END.
      
       IF l-cd0755 THEN DO:
          IF NOT b01-historico.cd0755 THEN 
             ASSIGN b01-historico.pendente-fat = YES.
       END.*/

       RUN pi-gerar-dados-extrato("pi-verifica-pendencia escdp050     - " + STRING(b01-historico.escdp050) ).
       RUN pi-gerar-dados-extrato("pi-verifica-pendencia cd0904a      - " + STRING(b01-historico.cd0904a ) ).
       RUN pi-gerar-dados-extrato("pi-verifica-pendencia cd0356       - " + STRING(b01-historico.cd0356  ) ).
       RUN pi-gerar-dados-extrato("pi-verifica-pendencia cd0755       - " + STRING(b01-historico.cd0755  ) ).
       RUN pi-gerar-dados-extrato("pi-verifica-pendencia cd0903       - " + STRING(b01-historico.cd0903  ) ).
       RUN pi-gerar-dados-extrato("pi-verifica-pendencia PENDENTE FAT - " + STRING(b01-historico.pendente-fat ) ).

       IF p-ponto = 'Manaus' THEN DO:
          /*IF NOT b01-historico.of0147 OR 
             NOT b01-historico.cd0355 THEN
             ASSIGN b01-historico.pendente-fat = YES.*/
          
          RUN pi-gerar-dados-extrato("pi-verifica-pendencia of0147       - " + STRING(b01-historico.of0147  ) ).
          RUN pi-gerar-dados-extrato("pi-verifica-pendencia of0147       - " + STRING(b01-historico.cd0355  ) ).
          RUN pi-gerar-dados-extrato("pi-verifica-pendencia PENDENTE FAT - " + STRING(b01-historico.pendente-fat ) ).
       END.

       /*
       /* Funcao verifica se FT0312 deve ser atualizado */
       ASSIGN l-valida-ft0312 = FnAtualizaFt0312(p-ponto).

       RUN pi-gerar-dados-extrato("pi-verifica-pendencia VALIDAR FT0312 ?? - " + STRING(l-valida-ft0312) ).
       
       IF NOT b01-historico.ft0312 AND l-valida-ft0312 THEN
          ASSIGN b01-historico.pendente-fat = YES.
       */

       IF b01-historico.pendente-fat THEN
          ASSIGN p-motivo-pendencia = b01-historico.char-1.

       RUN pi-gerar-dados-extrato("pi-verifica-pendencia PENDENTE FAT - " + STRING(b01-historico.pendente-fat ) ).

       RELEASE b01-historico.
    END.           

    RUN pi-gerar-dados-extrato("FIM pi-verifica-pendencia").

END PROCEDURE.




