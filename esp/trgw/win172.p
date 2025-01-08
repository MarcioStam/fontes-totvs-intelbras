/********************************************************************************
 ** UPC........: win172.p - UPC WRITE item
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es dos itens para a Base Oracle
 
 compile \\tsclient\c\fontes\esp\trgw\win172.p save into c:\temp\esp\trgw.
 
 ********************************************************************************/

{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}
/*{cdp/cd0666.i}*/
{esp/crm/escrm001.i}

def new global shared var l-multi as logical initial yes.
DEFINE VARIABLE c-mail AS CHARACTER   NO-UNDO.
def var l-del-erros as logical init YES NO-UNDO.
def var v-nom-arquivo-cb as char format "x(50)" no-undo.
def var c-mensagem-cb    as char format "x(132)" no-undo.
DEFINE VARIABLE c-email-destino AS CHARACTER   NO-UNDO.
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF VAR l-enviar-email AS LOG INIT YES NO-UNDO.


/*Tratamento criado para que, em rotinas criticas nas quais esta include s¢ Ç chamada para definir a tt-erro, seja possivel
  fazer com que n∆o seja definida a frame nem seja chamado o tratamento de traduá∆o, pois isto degrada performance.*/
&if '{&excludeFrameDefinition}' = 'yes' &then 
&else
                                              
    form
        space(04)
        tt-erro.cd-erro 
        space (02)
        c-mensagem-cb
        with width 132 no-box down stream-io frame f-consiste.
    
    run utp/ut-trfrrp.p (input frame f-consiste:handle).
    assign tt-erro.cd-erro:label in frame f-consiste = "Mensagem".
    assign c-mensagem-cb:label in frame f-consiste   = "Descricao".

&endif

DEF PARAM BUFFER b-item      FOR ITEM.
DEF PARAM BUFFER b-old-item  FOR ITEM.

DEF BUFFER bf-it-exame          FOR it-exame.
DEF BUFFER bf-exame-insp        FOR exame-insp.
DEF BUFFER bf-it-comp-exame     FOR it-comp-exame.
DEF BUFFER bf-item-compon-test  FOR item-compon-test.
def buffer bf-ponto-programa    for ponto-programa.
def buffer bf-conteudo-programa for conteudo-programa.

/*Inicio Integraá∆o Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

IF  b-item.ind-item-fat = NO THEN
    ASSIGN l-enviar-email = NO.

IF  b-item.ind-item-fat <> b-old-item.ind-item-fat  
AND b-item.ind-item-fat THEN DO:

    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = b-item.it-codigo NO-ERROR.
    IF  AVAIL int-item 
    AND int-item.nr-ped-energia <> "" THEN DO:
        RUN esp/trgw/win172b.p (INPUT b-item.it-codigo).
    END.
END.

IF NEW b-item THEN
    ASSIGN b-item.peso-liquido = 0.00001
           b-item.peso-bruto   = 0.00001.


/*Testa se algum dos campos a ser integrado foi alterado para ent∆o chamar a integraá∆o, no caso de campo novo na integraá∆o adicionar na clausular abaixo.*/
IF b-item.it-codigo      <> b-old-item.it-codigo 
OR b-item.desc-item      <> b-old-item.desc-item
OR b-item.descricao-1    <> b-old-item.descricao-1
OR b-item.descricao-2    <> b-old-item.descricao-2
OR b-item.peso-bruto     <> b-old-item.peso-bruto
OR b-item.ge-codigo      <> b-old-item.ge-codigo
OR b-item.cod-unid-negoc <> b-old-item.cod-unid-negoc
OR b-item.fm-cod-com     <> b-old-item.fm-cod-com
OR b-item.un             <> b-old-item.un
OR b-item.fm-codigo      <> b-old-item.fm-codigo 
OR b-item.aliquota-ipi   <> b-old-item.aliquota-ipi    
OR b-item.class-fiscal   <> b-old-item.class-fiscal THEN DO:

    RAW-TRANSFER b-item TO raw-param.
    
    RUN esp/trgw/win172a.p (INPUT raw-param,
                            INPUT 'msg0088').
END.
/*Fim Integraá∆o Canais*/

//integracao item pro sales force
IF NEW b-item 
OR b-item.it-codigo      <> b-old-item.it-codigo 
OR b-item.desc-item      <> b-old-item.desc-item
OR b-item.descricao-1    <> b-old-item.descricao-1
OR b-item.descricao-2    <> b-old-item.descricao-2
OR b-item.peso-bruto     <> b-old-item.peso-bruto
OR b-item.ge-codigo      <> b-old-item.ge-codigo
OR b-item.cod-unid-negoc <> b-old-item.cod-unid-negoc
OR b-item.fm-cod-com     <> b-old-item.fm-cod-com
OR b-item.un             <> b-old-item.un
OR b-item.fm-codigo      <> b-old-item.fm-codigo 
OR b-item.aliquota-ipi   <> b-old-item.aliquota-ipi    
OR b-item.class-fiscal   <> b-old-item.class-fiscal
OR b-item.ind-item-fat   <> b-old-item.ind-item-fat THEN DO:

    run esp/wso/eswso0007.p (INPUT b-item.it-codigo).
END.

DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE C-ALTERACAO AS char format "x(35)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-atu AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-ant AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

/* a trigger de write foi substituida pelas triggers de assign. */
IF NEW b-item THEN do:
    IF b-item.it-codigo BEGINS "Contrato" THEN /* Item que inicia como Contrato deve ser D≤bito Direto = SOS 41818 */
        ASSIGN b-item.tipo-contr = 4.

    IF b-item.consumo-prev = 0 THEN /* Atualiza consumo previsto = 1 na criaªío do item */
        ASSIGN b-item.consumo-prev = 1.

    assign b-item.reporte-ggf = 2  /* Alterado por Osnir. O item sempre deve ser reporte ggf igual a padr∆o */
           b-ITEM.ind-item-fat = NO.

       

    /* SOS 2010/00016929 */
    ASSIGN OVERLAY(b-item.char-2,31,5)   = "1,65"
           OVERLAY(b-item.char-2,36,5)   = "7,60"
           overlay(b-item.char-2,20,2)   = "01" /* Cod. Tributacao II - re0106 */
           overlay(b-item.char-2,22,6)   = "  0,00" /* Aliquota II - re0106 */
           OVERLAY(b-item.char-2,52,1)   = "2" /* Origem Aliquota PIS - re0106 */
           OVERLAY(b-item.char-2,53,1)   = "2" /* Origem Aliquota Cofins - re0106 */
           overlay(b-item.char-1,50,5)   = "Nao" /* Pis / Cofins - Subst Total NF - cd0903 - Por solicitacao Adriana = chamado ir37140*/
           b-ITEM.fator-reaj-icms        = 1.


    FIND FIRST item-mat EXCLUSIVE-LOCK 
         WHERE item-mat.it-codigo = b-item.it-codigo NO-ERROR.
       
    IF AVAIL item-mat THEN
        ASSIGN item-mat.idi-tributac-pis    = 1 /* Cod. Tributacao Pis - Importacao*/
               item-mat.idi-tributac-cofins = 1 /* Cod. Tributacao Pis - Importacao*/ .
    ELSE DO TRANS:
        CREATE item-mat.
        ASSIGN item-mat.it-codigo           = b-item.it-codigo
               item-mat.idi-tributac-pis    = 1 /* Cod. Tributacao Pis - Importacao*/
               item-mat.idi-tributac-cofins = 1 /* Cod. Tributacao Pis - Importacao*/.
    END.

    RELEASE item-mat.       

    find int-item where int-item.it-codigo = b-item.it-codigo EXCLUSIVE-LOCK no-error.

    if not avail int-item
    then do:
         create int-item.
         assign int-item.it-codigo = b-item.it-codigo.
    end.

    assign int-item.catalogo-ariba = no
           int-item.dt-atualiza    = today.
    for each bf-conteudo-programa use-index ind-conteudo no-lock
       where bf-conteudo-programa.conteudo = b-item.fm-codigo,
       first bf-ponto-programa no-lock
       where bf-ponto-programa.cod-programa  = bf-conteudo-programa.cod-programa
         and bf-ponto-programa.nome-programa = "catalog"
         and bf-ponto-programa.ponto         = 1
         and bf-ponto-programa.tipo          = 3:
        assign int-item.catalogo-ariba = yes.
        leave.
    end. /* for each bf-conteudo-programa */
    find current int-item no-lock no-error.

    /* Grupos que ser∆o controlados por lote */
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 2,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto). 

    FIND FIRST tt-prog-ponto
         WHERE tt-prog-ponto.conteudo = STRING(b-item.ge-codigo) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
       ASSIGN b-item.tipo-con-est = 3.
    END.

    /* Replica exames e componentes CQ */
    FIND FIRST bf-it-exame NO-LOCK
         WHERE bf-it-exame.it-codigo BEGINS substr(b-item.it-codigo,1,3) NO-ERROR.
    IF AVAIL bf-it-exame THEN DO:

        FIND FIRST it-exame NO-LOCK 
             WHERE it-exame.it-codigo = b-item.it-codigo
               AND it-exame.cod-exame = bf-it-exame.cod-exame
        NO-ERROR.
       
        IF NOT AVAIL it-exame THEN DO:
           CREATE it-exame.
           BUFFER-COPY bf-it-exame EXCEPT bf-it-exame.it-codigo TO it-exame.
           ASSIGN it-exame.it-codigo = b-item.it-codigo.
           
    
           FOR EACH bf-exame-insp OF bf-it-exame NO-LOCK:
               CREATE exame-insp.
               BUFFER-COPY bf-exame-insp EXCEPT bf-exame-insp.it-codigo TO exame-insp.
               ASSIGN exame-insp.it-codigo = b-item.it-codigo.
           END.
    
           FOR EACH bf-it-comp-exame OF bf-it-exame NO-LOCK:
               CREATE it-comp-exame.
               BUFFER-COPY bf-it-comp-exame EXCEPT bf-it-comp-exame.it-codigo TO it-comp-exame.
               ASSIGN it-comp-exame.it-codigo = b-item.it-codigo.
    
               FOR EACH bf-item-compon-test NO-LOCK
                  WHERE bf-item-compon-test.cod-item        = bf-it-comp-exame.it-codigo 
                    AND bf-item-compon-test.cdn-exam        = bf-it-comp-exame.cod-exame 
                    AND bf-item-compon-test.cdn-compon-exam = bf-it-comp-exame.cod-comp:
                   CREATE item-compon-test.
                   BUFFER-COPY bf-item-compon-test EXCEPT bf-item-compon-test.cod-item TO item-compon-test.
                   ASSIGN item-compon-test.cod-item = b-item.it-codigo.
               END.
           END.
        END.
    END.

    /* CHAMADO C2112-1118 - Envio de e-mail item novo */

    ASSIGN c-email-destino = ''.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 6,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   
    
    FOR EACH tt-prog-ponto:
        IF ENTRY(1, tt-prog-ponto.conteudo,";") = b-item.cod-estabel THEN 
           ASSIGN c-email-destino = c-email-destino + ENTRY(2, tt-prog-ponto.conteudo,";") + ";".
    END.

    RUN pi-manda-email-item-novo.

end.    
else do:

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 2,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto). 

    FIND FIRST tt-prog-ponto
         WHERE tt-prog-ponto.conteudo = STRING(b-item.ge-codigo) NO-ERROR.

    IF AVAIL tt-prog-ponto THEN DO:
       IF b-old-item.ge-codigo = 0 THEN
          ASSIGN b-item.tipo-con-est = 3.
    END.                             

    ASSIGN overlay(b-item.char-1,50,5)   = "Nao". /* Pis / Cofins - Subst Total NF - cd0903 - Por solicitacao Adriana = chamado ir37140*/
    if b-item.CLASS-fiscal = "" and
       b-old-item.class-fiscal <> "" then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15825, 
                           INPUT "Classificacao Fiscal esta em branco").
        ASSIGN ERROR-STATUS:ERROR = YES.
        RETURN 'nok'.
    end.

    if b-item.reporte-ggf = 1 then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15825, 
                           INPUT "UPC-Reporte GGF do item deve ser padr∆o!").
        ASSIGN ERROR-STATUS:ERROR = YES.
        RETURN 'nok'.
    end.

    IF  b-item.it-codigo   = "" AND 
        b-item.tipo-contr <> 4  THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "UPC-Item deve ser DÇbito Direto!").
        ASSIGN ERROR-STATUS:ERROR = YES.
        RETURN 'nok'.
    END.

    if not can-find(first int-item use-index codigo where
                          int-item.it-codigo   = b-item.it-codigo
                      and int-item.dt-atualiza = today
                          no-lock)
    then do:
         for first int-item 
             where int-item.it-codigo = b-item.it-codigo
                   exclusive-lock: end.
        
         if not avail int-item
         then do:
              create int-item.
              assign int-item.it-codigo = b-item.it-codigo.
         end.
        
         assign int-item.dt-atualiza = today.
         find current int-item no-lock no-error.
    end.
end.


IF b-old-item.cod-servico <> b-item.cod-servico THEN DO:
    FOR EACH item-uni-estab
        WHERE item-uni-estab.it-codigo = b-item.it-codigo EXCLUSIVE-LOCK:
        ASSIGN OVERLAY(ITEM-uni-estab.char-2,21,5) = string(b-item.cod-servico).
    END.
end.

/* Chamado: C2303-2258 - Alterado para que assuma o IPI informado

IF b-item.ge-codigo >= 40 THEN DO:

    IF b-old-item.class-fiscal = "" AND 
       b-item.class-fiscal <> b-old-item.class-fiscal AND
       b-item.tipo-contr = 2 THEN DO:
         assign c-alteracao  = "Campo Classificacao Fiscal Alterado"
                c-fiscal-atu = b-item.class-fiscal
                c-fiscal-ant = b-old-item.class-fiscal.
         
         FIND classif-fisc WHERE
              classif-fisc.class-fiscal = b-item.class-fiscal NO-LOCK NO-ERROR.
         IF AVAIL classif-fisc THEN
             ASSIGN b-item.aliquota-ipi = classif-fisc.aliquota-ipi
                    b-item.aliquota-ii  = decimal(SUBSTRING(classif-fisc.char-1,1,5)).
    end.

END.
*/

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                   INPUT 1,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).   

for each tt-prog-ponto:
    if entry(1, tt-prog-ponto.conteudo,";") = v_cod_estab_usuar then 
        assign c-email-destino = c-email-destino + ENTRY(2, tt-prog-ponto.conteudo,";") + ";".
END.

IF b-item.desc-item <> b-old-item.desc-item  THEN DO:
     assign c-alteracao  = "Descricao Item"
            c-fiscal-atu = string(b-item.desc-item)
            c-fiscal-ant = string(b-old-item.desc-item)
            c-email-destino = c-email-destino  + "ems.item@intelbras.com.br".
     run pi-manda-email-item-alterado.
end.


IF b-item.baixa-estoq <> b-old-item.baixa-estoq  THEN DO:
     assign c-alteracao  = "Campo Baixa Estoque Alterado"
            c-fiscal-atu = string(b-item.baixa-estoq)
            c-fiscal-ant = string(b-old-item.baixa-estoq)
            c-email-destino = c-email-destino  + "ems.item@intelbras.com.br".
     run pi-manda-email-item-alterado.
end.

IF b-item.class-fiscal <> b-old-item.class-fiscal /*AND
   b-item.class-fiscal = "" */ THEN DO:
     assign c-alteracao  = "NCM alterado para nulo"
            c-fiscal-atu = string(b-item.class-fiscal)
            c-fiscal-ant = string(b-old-item.class-fiscal).
     run pi-manda-email-item-alterado.
end.

IF b-item.codigo-orig <> b-old-item.codigo-orig  THEN DO:
     assign c-alteracao  = "Campo Origem alterado"
            c-fiscal-atu = string(b-item.codigo-orig)
            c-fiscal-ant = string(b-old-item.codigo-orig).
     run pi-manda-email-item-alterado.
end.

IF b-item.aliquota-ipi <> b-old-item.aliquota-ipi  THEN DO:
     assign c-alteracao  = "Campo Al°quota IPI alterado"
            c-fiscal-atu = string(b-item.aliquota-ipi)
            c-fiscal-ant = string(b-old-item.aliquota-ipi).
     run pi-manda-email-item-alterado.
end.

IF b-item.fm-codigo <> b-old-item.fm-codigo  THEN DO:
     assign c-alteracao  = "Campo Fam°lia alterado"
            c-fiscal-atu = string(b-item.fm-codigo)
            c-fiscal-ant = string(b-old-item.fm-codigo).
     run pi-manda-email-item-alterado.
end.

IF  substr(b-item.char-2,52,1) <> substr(b-old-item.char-2,52,1) THEN DO:
     assign c-alteracao  = "Campo Origem Al°quota PIS alterado"
            c-fiscal-atu = (IF substr(b-item.char-2,52,1) = "1" THEN "ITEM" ELSE "NATUREZA")
            c-fiscal-ant = (IF substr(b-old-item.char-2,52,1) = "1" THEN "ITEM" ELSE "NATUREZA")
            c-email-destino = "valdeci.weber@intelbras.com.br".
     
     run pi-manda-email-item-alterado.
END.

IF  substr(b-item.char-2,53,1) <> substr(b-old-item.char-2,53,1) THEN DO:
     assign c-alteracao  = "Campo Origem Al°quota COFINS alterado"
            c-fiscal-atu = (IF substr(b-item.char-2,53,1) = "1" THEN "ITEM" ELSE "NATUREZA")
            c-fiscal-ant = (IF substr(b-old-item.char-2,53,1) = "1" THEN "ITEM" ELSE "NATUREZA")
            c-email-destino = "valdeci.weber@intelbras.com.br".
     
     run pi-manda-email-item-alterado.
END.

/* S¢ enviar email quando o item o campo dispon°vel para faturamento for alterado de sim para n∆o*/
IF b-old-item.ind-item-fat = YES AND b-item.ind-item-fat = NO THEN DO:
     assign c-alteracao  = "Campo Dispon°vel Faturamento alterado"
            c-fiscal-atu = string(b-item.ind-item-fat)
            c-fiscal-ant = string(b-old-item.ind-item-fat).
     ASSIGN l-enviar-email = YES.
     run pi-manda-email-item-alterado.
end.

/* Regra para itens Acabados que n∆o podem ser alterados para fracionados */
IF (NOT b-old-item.fraciona AND b-item.fraciona) THEN DO:   
    
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 8,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).
    
    /* Grupo de Estoques de produtos acabados(Ex: 40, 42, 45) */
    IF CAN-FIND(FIRST tt-prog-ponto
                WHERE tt-prog-ponto.conteudo = string(b-item.ge-codigo)) THEN DO:

        RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                           INPUT 7,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).
        
        /* Somente as Unidade de medidas que s∆o Exceá‰es que podem alterar para fracionado (Ex: Cm, m, m2)*/
        IF NOT CAN-FIND(FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = b-item.un) THEN DO:        
            
            IF NOT OPSYS = "unix" THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "UPC-Quantidade Fracionada (es0018 win172 Ponto 7) ~~ Somente Ç permitido quantidade fracionada para unidade de medida do item que seja fracionada. Quantidade Fracionada ser† desmarcada.").
            END.
            ASSIGN b-item.fraciona = NO.    
        END.
    END.
END.

IF b-item.fm-codigo <> b-old-item.fm-codigo THEN DO:

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 4,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).  

    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = SUBSTRING(b-item.fm-codigo,1,1)
           AND ENTRY(2,tt-prog-ponto.conteudo,";") = SUBSTRING(b-item.fm-codigo,7,2) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
        run pi-manda-email-item-familia.
end.

/*     
IF b-old-item.it-codigo = "" AND b-old-item.desc-item = "" THEN DO:
    RUN pi-manda-email-item-novo.
END.
*/    
/*
run esp/es0669.p (input "yes",
                  "ITEM",
                  upper(b-item.it-codigo),
                  "", "", "", "", "", "", "", "").
  */

run esp/es0639.p (input recid(b-item)).

/********************** Integracao do Ems para o CRM *****************/
/*IF /* b-item.ge-codigo <> 0  AND  /* Debito direto */   
      b-item.ge-codigo <> 20 AND  /* Semi acabado */   
      b-item.ge-codigo <> 25 AND  /* Semi acabado */
      b-item.ge-codigo <> 30 AND /* Material de Consumo */  */
      b-item.ind-item-fat = YES THEN DO:*/

    IF  NEW b-item OR
        b-old-item.ind-item-fat   <> b-item.ind-item-fat   OR
        b-old-item.desc-item      <> b-item.desc-item      OR
        b-old-item.un             <> b-item.un             OR
        b-old-item.compr-fabric   <> b-item.compr-fabric   OR
        b-old-item.ge-codigo      <> b-item.ge-codigo      OR
        b-old-item.fm-codigo      <> b-item.fm-codigo      OR
        b-old-item.fm-cod-com     <> b-item.fm-cod-com     OR
        b-old-item.cod-obsoleto   <> b-item.cod-obsoleto   OR
        b-old-item.ind-item-fat   <> b-item.ind-item-fat   THEN DO:

        /* A validaá∆o da Unidade de Medida Ç utilizada para evitar o envio
           de informaá‰es para o CRM sem a Unidade de Medida v†lida, pois
           sem a validaá∆o do mesmo, ocorre erro no CRM.
           Este fato ocorre durante a manipulaá∆o do registro da tabela "Item"
           na execuá∆o da API do EMS CDAPI344, API esta utilizada quando o
           item Ç criado ou alterado no SharePoint - Fabiano Sakae Ribeiro
           (Exponencial TI) */
        FIND FIRST tab-unidade
            WHERE tab-unidade.un = b-item.un NO-LOCK NO-ERROR.

        IF AVAILABLE tab-unidade THEN DO:
            {esp/crm/escrm001a.i1}

/*             RUN esp/crm/escrm001a.p (INPUT "Item":U,               */
/*                                      INPUT "W":U,                  */
/*                                      INPUT ROWID(b-item),          */
/*                                      INPUT TABLE tt-raw-transfer). */
        END.
   END.
/*END.*/


/* Faz isso, se alterado para fatur†vel no programa CD0903 */
IF  PROGRAM-NAME(6) MATCHES '*v42in172*' THEN DO:
    /*Se o item est† mudando para Fatur†vel deve levar as informaá‰es
    do escdp055 para o cd0904a automatico  Chamado: 33851 */
    IF b-old-item.ind-item-fat = NO  AND
       b-item.ind-item-fat = YES     THEN DO:
    
       IF b-item.cod-dcr-item = '' THEN
           RUN esp/cdp/escdp055api.p (INPUT b-item.class-fiscal,
                                      INPUT b-item.codigo-orig).
    
    END.
END.

/*
//M2108-054 - Integraá∆o Produto x Sales Force - WSO2
IF b-old-item.cod-obsoleto  <> b-item.cod-obsoleto   OR 
   b-old-item.fm-cod-com    <> b-item.fm-cod-com     OR
   b-old-item.descricao-1   <> b-item.descricao-1    OR
   b-old-item.desc-item     <> b-item.desc-item      OR
   b-old-item.desc-inter    <> b-item.desc-inter     OR
   b-old-item.aliquota-ipi  <> b-item.aliquota-ipi   OR
   b-old-item.cod-servico   <> b-item.cod-servico    THEN DO:
   IF b-item.ind-item-fat AND b-item.cod-obsoleto = 1 THEN
      run esp/wso/eswso0007.p (INPUT b-item.it-codigo).
END.
ELSE
   IF b-old-item.it-codigo    =  b-item.it-codigo    AND 
      b-old-item.ind-item-fat <> b-item.ind-item-fat THEN DO:
      run esp/wso/eswso0007.p (INPUT b-item.it-codigo).
   END.
   
   */

/*MESSAGE "marcios -> na trigger 1"  SKIP
        STRING(NEW b-item)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

IF NEW b-item 
OR b-item.it-codigo      <> b-old-item.it-codigo 
OR b-item.desc-item      <> b-old-item.desc-item
OR b-item.descricao-1    <> b-old-item.descricao-1
OR b-item.descricao-2    <> b-old-item.descricao-2
OR b-item.peso-bruto     <> b-old-item.peso-bruto
OR b-item.ge-codigo      <> b-old-item.ge-codigo
OR b-item.cod-unid-negoc <> b-old-item.cod-unid-negoc
OR b-item.fm-cod-com     <> b-old-item.fm-cod-com
OR b-item.un             <> b-old-item.un
OR b-item.fm-codigo      <> b-old-item.fm-codigo 
OR b-item.aliquota-ipi   <> b-old-item.aliquota-ipi    
OR b-item.class-fiscal   <> b-old-item.class-fiscal
OR b-item.ind-item-fat   <> b-old-item.ind-item-fat THEN DO:

    MESSAGE "marcios -> na trigger 2"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.


    run esp/wso/eswso0007.p (INPUT b-item.it-codigo).
END.
*/

IF b-item.narrativa <> b-old-item.narrativa THEN DO:
    IF NOT NEW b-item 
    THEN run pi-manda-email-item-narrativa.
end.

PROCEDURE pi-manda-email-item-novo.
    
    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     = c-email-destino
           tt-envio2.assunto     = "Item novo" + b-item.it-codigo
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".

    /* se for item da Maxcom e Intelbras continua enviando para ems.item*/
    /*
    IF v_cod_estab_usuar = "102" THEN
        ASSIGN tt-envio2.destino     = "claudia.wedel@intelbras.com.br".
    */

    /*
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    for each tt-prog-ponto:
        if entry(1, tt-prog-ponto.conteudo,";") = v_cod_estab_usuar then 
            assign tt-envio2.destino = tt-envio2.destino + ENTRY(2, tt-prog-ponto.conteudo,";") + ";".
    END.    */


    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "             Novo Item Cadastrado                 " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Item: " + b-item.it-codigo                          + CHR(13) +
                                      "Descriá∆o: " + b-item.desc-item                     + CHR(13) +
                                      "Aliquota IPI: " + string(b-item.aliquota-ipi)       + CHR(13) +
                                      "Class Fiscal: " + string(b-item.class-fiscal)       + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros THEN DO:
        IF OPSYS = "UNIX" THEN do:

            ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

            output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
            END.

            OUTPUT CLOSE.
        END.
        ELSE DO:
            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
            FOR EACH tt-erros:
                CREATE tt-erro.
                ASSIGN i-cont = i-cont + 1
                       tt-erro.i-sequen = i-cont
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.
      
PROCEDURE pi-manda-email-item-alterado.
    
    IF  NOT l-enviar-email THEN
        RETURN "OK".

    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.


    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     = c-email-destino
           tt-envio2.assunto     = "Alteraá∆o de Item :" + b-item.it-codigo
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".

    /* se for item da Maxcom e Intelbras continua enviando para ems.item*/
    
    /*
    IF v_cod_estab_usuar = "102" THEN
        ASSIGN tt-envio2.destino     = "claudia.wedel@intelbras.com.br;antonio.gallo@intelbras.com.br".
    */
    
    /*
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    for each tt-prog-ponto:
        if entry(1, tt-prog-ponto.conteudo,";") = v_cod_estab_usuar then 
            assign tt-envio2.destino = tt-envio2.destino + ";" + ENTRY(2, tt-prog-ponto.conteudo,";")  .
    END.
    */

    IF b-item.it-codigo = ? THEN
        ASSIGN b-item.it-codigo = "".
    IF b-item.desc-item = ? THEN
        ASSIGN b-item.desc-item = "".
    IF c-alteracao      = ? THEN
        ASSIGN c-alteracao = "".
    IF c-fiscal-atu     = ? THEN
        ASSIGN c-fiscal-atu = "".
    IF c-fiscal-ant     = ? THEN
        ASSIGN c-fiscal-ant = "".
    IF v_cod_usuar_corren = ? THEN
        ASSIGN v_cod_usuar_corren = "".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "             ALTERACAO NAO PERMITIDA              " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Item: "            + b-item.it-codigo                + CHR(13) +
                                      "Descriá∆o: "       + b-item.desc-item                + CHR(13) +
                                      "Alteracao: "       + c-alteracao                     + CHR(13) +
                                      "Valor Atual: "     + c-fiscal-atu                    + CHR(13) +
                                      "Valor Anterior: "  + c-fiscal-ant                    + CHR(13) +
                                      "Usuario:  " + v_cod_usuar_corren                     + CHR(13) +
                                      "Programa: " + IF PROGRAM-NAME(1)  <> ? then PROGRAM-NAME(1)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(2)  <> ? then PROGRAM-NAME(2)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(3)  <> ? then PROGRAM-NAME(3)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(4)  <> ? then PROGRAM-NAME(4)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(5)  <> ? then PROGRAM-NAME(5)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(6)  <> ? then PROGRAM-NAME(6)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(7)  <> ? then PROGRAM-NAME(7)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(8)  <> ? then PROGRAM-NAME(8)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(9)  <> ? then PROGRAM-NAME(9)  else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(10) <> ? then PROGRAM-NAME(10) else ""  + CHR(13) +
                                      "          " + IF PROGRAM-NAME(11) <> ? then PROGRAM-NAME(11) else ""  + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros THEN DO:
        IF OPSYS = "UNIX" THEN do:

            ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

            output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
            END.

            OUTPUT CLOSE.
        END.
        ELSE DO:
            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
            FOR EACH tt-erros:
                CREATE tt-erro.
                ASSIGN i-cont = i-cont + 1
                       tt-erro.i-sequen = i-cont
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

PROCEDURE pi-manda-email-item-familia.
    
    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     = ""
           tt-envio2.assunto     = "Item novo na familia da Lei de Informatica " + b-item.it-codigo
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".

    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 4,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    for each tt-prog-ponto:
        assign tt-envio2.destino = tt-envio2.destino + ENTRY(3, tt-prog-ponto.conteudo,";") + ";".
    END.    

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "    Item novo na familia da Lei de Informatica    " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Item: " + b-item.it-codigo                          + CHR(13) +
                                      "Descriá∆o: " + b-item.desc-item                     + CHR(13) +
                                      "Familia: " + b-item.fm-codigo                       + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros THEN DO:
        IF OPSYS = "UNIX" THEN do:

            ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

            output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
            END.

            OUTPUT CLOSE.
        END.
        ELSE DO:
            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
            FOR EACH tt-erros:
                CREATE tt-erro.
                ASSIGN i-cont = i-cont + 1
                       tt-erro.i-sequen = i-cont
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

PROCEDURE pi-manda-email-item-narrativa.
    
    DEF VAR c-nom_usuario AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                       INPUT 5,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

    IF AVAIL tt-prog-ponto 
    THEN DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.

        FIND FIRST usuar_mestre WHERE 
                   usuar_mestre.cod_usuario = v_cod_usuar_corren 
                   NO-LOCK NO-ERROR.

        IF AVAILABLE usuar_mestre THEN
           ASSIGN cNom_from     = usuar_mestre.cod_e_mail_local
                  c-nom_usuario = usuar_mestre.nom_usuario.

        IF cNom_from = '' THEN
           ASSIGN cNom_from = 'ems@intelbras.com.br'.

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

        FOR EACH tt-envio2:     DELETE tt-envio2.   END.
        FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.exchange    = param-global.log-1 
               tt-envio2.servidor    = param-global.serv-mail
               tt-envio2.porta       = param-global.porta-mail
               tt-envio2.remetente   = 'ems@intelbras.com.br' //cNom_from
               tt-envio2.destino     = ""
               tt-envio2.assunto     = "Narrativa alterada do item " + b-item.it-codigo
               tt-envio2.importancia = 2
               tt-envio2.log-enviada = YES
               tt-envio2.log-lida    = NO
               tt-envio2.acomp       = NO
               tt-envio2.arq-anexo   = ?
               tt-envio2.formato     = "text".

        assign tt-envio2.destino = tt-prog-ponto.conteudo.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                          "             Narrativa do item alterada           " + CHR(13) +
                                          "**************************************************" + CHR(13) +
                                          "Item: " + b-item.it-codigo                          + CHR(13) +
                                          "Descriá∆o: " + b-item.desc-item                     + CHR(13) +
                                          "Usu†rio: " + v_cod_usuar_corren + " - " + c-nom_usuario + CHR(13) +
                                          "Narrativa Nova: "  + b-item.narrativa               + CHR(13) +
                                          "Narrativa Velha: " + b-old-item.narrativa           + CHR(13) +
                                          "**************************************************" + CHR(10).

        RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

        FIND FIRST tt-erros NO-LOCK NO-ERROR.

        IF AVAIL tt-erros THEN DO:
            IF OPSYS = "UNIX" THEN do:

                ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

                output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

                FOR EACH tt-erros:
                    DISP tt-erros.cod-erro
                         tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
                END.

                OUTPUT CLOSE.
            END.
            ELSE DO:
                FOR EACH tt-erro:
                    DELETE tt-erro.
                END.
                FOR EACH tt-erros:
                    CREATE tt-erro.
                    ASSIGN i-cont = i-cont + 1
                           tt-erro.i-sequen = i-cont
                           tt-erro.cd-erro  = tt-erros.cod-erro
                           tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
                END.
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            END.
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

