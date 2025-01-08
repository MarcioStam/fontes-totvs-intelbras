{include/i-prgvrs.i ESCEP064 2.06.00.001}
/***********************************************************************
**  Programa..: ESP/CEP/ESCEP064RP.P
**  Autor.....: Hoepers
**  Data......: 11/10/2012
**  Descricao.: Exporta‡Æo Dados de Controle Quotas Manaus para Pinho
**  VersÆo....: 001 11/10/2012 -  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
{esp/cep/escep064.i}

/****************************  Variaveis    ****************************/
DEFINE VARIABLE v-dat-tmp         AS DATE        NO-UNDO.
DEFINE VARIABLE v-num-entr-param  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-ind-origem      AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-ind-tipo        AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-ind-destino     AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-seq-nivel       AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-seq-estrutura   AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-log-importado   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-log-nfe         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-log-perda       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-cod-dir-destino AS CHARACTER   NO-UNDO.
/****************************  Frames       ****************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF BUFFER b-item      FOR ITEM.
DEF BUFFER b-estrutura FOR estrutura.
    
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa NO-LOCK
   WHERE empresa.ep-codigo = param-global.empresa-pri.
FIND FIRST estabelec NO-LOCK
   WHERE estabelec.ep-codigo = empresa.ep-codigo.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Controle Quotas Manaus para Pinho"
       c-empresa      = IF AVAILABLE (empresa) THEN empresa.razao-social ELSE ""
       c-programa     = "ESCEP064"
       c-versao       = "2.06"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-item-doc-est.
EMPTY TEMP-TABLE tt-item-nfs.
EMPTY TEMP-TABLE tt-estoque.
EMPTY TEMP-TABLE tt-perdas.
EMPTY TEMP-TABLE tt-naturezas.
EMPTY TEMP-TABLE tt-cta-perda.
EMPTY TEMP-TABLE tt-item-importado.
EMPTY TEMP-TABLE tt-tp-desp-imp.
EMPTY TEMP-TABLE tt-estrutura.
EMPTY TEMP-TABLE tt-estrutura-exp.
EMPTY TEMP-TABLE tt-item-estrutura.

/* Identificar parƒmetros para filtro de notas */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "escep064"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "TP_DESP_IMP"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-tp-desp-imp.
                ASSIGN tt-tp-desp-imp.tp-desp-padrao = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_NFE"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-naturezas.
                ASSIGN tt-naturezas.nat-operacao = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")
                       tt-naturezas.log-entrada  = YES
                       tt-naturezas.log-perda    = NO.
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_NFS"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-naturezas.
                ASSIGN tt-naturezas.nat-operacao = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")
                       tt-naturezas.log-entrada  = NO
                       tt-naturezas.log-perda    = NO.
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_PERDA"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-naturezas.
                ASSIGN tt-naturezas.nat-operacao = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")
                       tt-naturezas.log-entrada  = ?
                       tt-naturezas.log-perda    = YES.
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CTA_PERDA"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-cta-perda.
                ASSIGN tt-cta-perda.ct-codigo = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "DIRWIN" AND
            OPSYS                                   = "WIN32"
        THEN
            ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").

        IF  ENTRY(1,conteudo-programa.conteudo,";")  = "DIRUNIX" AND
            OPSYS                                   <> "WIN32"
        THEN
            ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").


        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ESTRUTURA"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-item-estrutura.
                ASSIGN tt-item-estrutura.it-codigo = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

    END.
END.


DO ON ERROR UNDO, LEAVE:
    
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes...").

   IF  tt-param.log-nfe OR
       tt-param.log-nfs OR
       tt-param.log-perda
   THEN
       RUN pi-le-movto-estoq.


   IF  tt-param.log-nfe
   THEN
       RUN pi-exporta-entrada.

   IF  tt-param.log-nfs
   THEN
       RUN pi-exporta-saida.

   IF  tt-param.log-perda
   THEN
       RUN pi-exporta-perdas.


   IF  tt-param.log-estoque
   THEN DO:
       RUN pi-le-estoque.
       RUN pi-exporta-estoque.
   END.

   IF  tt-param.log-estrutura
   THEN DO:
       RUN pi-le-estrutura.
       RUN pi-exporta-estrutura.
   END.

   IF tt-param.log-tab-preco 
   THEN DO:
       RUN pi-le-tabela-preco.
       RUN pi-exporta-tabela-preco.
   END.

   RUN pi-finalizar IN h-acomp.
   RETURN "OK".
END.


PROCEDURE pi-le-movto-estoq:

    DO v-dat-tmp = tt-param.dat-inicial TO tt-param.dat-final:

        RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(v-dat-tmp)).

        bloco-movto-estoq:
        FOR EACH  movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel = tt-param.cod-estabel
              AND movto-estoq.dt-trans    = v-dat-tmp:

            RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(v-dat-tmp)).

            IF  movto-estoq.tipo-trans = 2 /* Sa¡da */
            THEN DO:
                /* Gerar Perdas */
                IF  tt-param.log-perda    = YES AND
                   (movto-estoq.esp-docto = 22   OR /* NFS */
                    movto-estoq.esp-docto = 28)     /* REQ */
                THEN DO:
                    ASSIGN v-ind-tipo      = 1 /* Mat‚ria-Prima */
                           v-log-importado = NO.

                    RUN pi-valida-item (INPUT movto-estoq.it-codigo).

                    IF  v-log-importado = YES
                    THEN
                        RUN pi-valida-perda.
                END.

                /* Gerar Notas Sa¡da */
                IF  tt-param.log-nfs      = YES AND
                   (movto-estoq.esp-docto = 22   OR /* NFS */
                    movto-estoq.esp-docto = 23)     /* NFT */
                THEN DO:
                    ASSIGN v-ind-tipo      = 1  /* Mat‚ria-Prima */
                           v-ind-destino   = 1  /* Consumidor    */
                           v-log-importado = NO.

                    RUN pi-valida-item (INPUT movto-estoq.it-codigo).

                    IF  v-log-importado = YES
                    THEN
                        RUN pi-valida-nfs.
                END.
            END. /* IF  movto-estoq.tipo-trans = 1 */
            ELSE DO:
                /* Gerar Notas Entrada */
                IF  tt-param.log-nfe      = YES AND
                   (movto-estoq.esp-docto = 21   OR /* NFE */
                    movto-estoq.esp-docto = 23)     /* NFT */
                THEN DO:
                    ASSIGN v-ind-tipo      = 1 /* Mat‚ria-Prima */
                           v-ind-origem    = 1 /* Fornecedor */
                           v-log-importado = NO.

                    RUN pi-valida-item (INPUT movto-estoq.it-codigo).

                    IF  v-log-importado = YES
                    THEN
                        RUN pi-valida-nfe.
                END.
            END. /* ELSE IF  movto-estoq.tipo-trans = 1 */
        END. /* FOR EACH  movto-estoq NO-LOCK */
    END. /* DO v-dat-tmp = tt-param.dat-inicial TO tt-param.dat-final: */

END PROCEDURE.


PROCEDURE pi-le-estoque:

    bloco-saldo:
    FOR EACH  sl-it-per NO-LOCK
        WHERE sl-it-per.periodo >= tt-param.dat-inicial 
          AND sl-it-per.periodo <= tt-param.dat-final:

        RUN pi-acompanhar IN h-acomp (INPUT "Data Estque: " + STRING(sl-it-per.periodo) + " - Item: " + sl-it-per.it-codigo).

        IF  sl-it-per.cod-estabel <> tt-param.cod-estabel
        THEN
          NEXT bloco-saldo.
        
        ASSIGN v-ind-tipo      = 1 /* Mat‚ria-Prima */
               v-log-importado = NO.

        RUN pi-valida-item (INPUT sl-it-per.it-codigo).

        IF  v-log-importado = YES
        THEN DO:
            FIND tt-estoque 
                WHERE tt-estoque.it-codigo  = sl-it-per.it-codigo
                  AND tt-estoque.data-saldo = sl-it-per.periodo NO-ERROR.

            IF  NOT AVAIL tt-estoque
            THEN DO:
                CREATE tt-estoque.
                ASSIGN tt-estoque.it-codigo     = sl-it-per.it-codigo                      
                       tt-estoque.data-saldo    = sl-it-per.periodo                        
                       tt-estoque.quantidade    = sl-it-per.quantidade                     
                       tt-estoque.un            = ITEM.un                                  
                       tt-estoque.class-fiscal  = ITEM.class-fiscal                        
                       tt-estoque.ind-tipo      = v-ind-tipo.

                RUN pi-narrativa-item (INPUT  ITEM.narrativa,
                                       OUTPUT tt-estoque.narrativa).
            END.
            ELSE
                ASSIGN tt-estoque.quantidade = tt-estoque.quantidade + sl-it-per.quantidade.
        END. /* IF  v-log-importado = YES */
    END. /* FOR EACH  sl-it-per NO-LOCK */

END PROCEDURE.


PROCEDURE pi-valida-nfe:
    ASSIGN v-log-nfe = NO.

    RELEASE docto-estoq-nfe-imp.

    FIND FIRST tt-naturezas NO-LOCK
        WHERE  tt-naturezas.nat-operacao = movto-estoq.nat-operacao 
          AND  tt-naturezas.log-entrada  = YES NO-ERROR.

    IF  AVAIL tt-naturezas
    THEN DO:
        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = movto-estoq.nat-operacao NO-ERROR.

        IF  AVAIL natur-oper
        THEN DO:
            IF  natur-oper.mercado = 2 /* Externo */
            THEN DO:
                ASSIGN v-log-nfe = YES.
                FIND docto-estoq-nfe-imp NO-LOCK
                    WHERE docto-estoq-nfe-imp.cod-ser-docto    = movto-estoq.serie
                      AND docto-estoq-nfe-imp.cod-docto        = movto-estoq.nro-docto
                      AND docto-estoq-nfe-imp.cdn-emitente     = movto-estoq.cod-emitente
                      AND docto-estoq-nfe-imp.cod-natur-operac = movto-estoq.nat-operacao NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE  estabelec.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

                IF  AVAIL estabelec
                THEN
                    ASSIGN v-ind-origem = 2 /* Transferˆncia */
                           v-log-nfe    = YES.
            END. /* Else IF  natur-oper.mercado = 2 */
        END. /* IF  AVAIL natur-oper */
    END. /* IF  AVAIL tt-naturezas */

    IF  v-log-nfe = YES
    THEN DO:
        CREATE tt-item-doc-est.
        ASSIGN tt-item-doc-est.nro-docto        = movto-estoq.nro-docto               
               tt-item-doc-est.serie            = movto-estoq.serie             
               tt-item-doc-est.cod-emitente     = movto-estoq.cod-emitente
               tt-item-doc-est.nat-operacao     = movto-estoq.nat-operacao
               tt-item-doc-est.dt-emissao       = movto-estoq.dt-trans              
               tt-item-doc-est.it-codigo        = movto-estoq.it-codigo            
               tt-item-doc-est.quantidade       = movto-estoq.quantidade           
               tt-item-doc-est.un-fornec        = movto-estoq.un                   
               tt-item-doc-est.un-interna       = movto-estoq.un
               tt-item-doc-est.class-fiscal     = ITEM.class-fiscal
               tt-item-doc-est.ind-tipo         = v-ind-tipo    /* 1-Materia-Prima, 2-Acabado */
               tt-item-doc-est.ind-origem       = v-ind-origem. /* 1-Fornecedor, 2-Transferenc */

        RUN pi-narrativa-item (INPUT  ITEM.narrativa,
                               OUTPUT tt-item-doc-est.narrativa).

        FIND item-fornec NO-LOCK
            WHERE item-fornec.cod-emitente = movto-estoq.cod-emitente
              AND item-fornec.it-codigo    = item-doc-est.it-codigo NO-ERROR.

        IF  AVAIL item-fornec
        THEN
            ASSIGN tt-item-doc-est.un-fornec = item-fornec.unid-med-for.

        IF  AVAIL docto-estoq-nfe-imp
        THEN
            ASSIGN tt-item-doc-est.des-decla-import = docto-estoq-nfe-imp.des-decla-impo.
    END. /* IF  v-log-nfe = YES */
END PROCEDURE.


PROCEDURE pi-valida-nfs:

    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = movto-estoq.cod-estabel
          AND nota-fiscal.serie       = movto-estoq.serie
          AND nota-fiscal.nr-nota-fis = movto-estoq.nro-docto NO-ERROR.

    IF  AVAIL nota-fiscal AND
              nota-fiscal.dt-cancela = ?
    THEN DO:
        FIND FIRST tt-naturezas NO-LOCK
            WHERE  tt-naturezas.nat-operacao = nota-fiscal.nat-operacao 
              AND  tt-naturezas.log-entrada  = NO NO-ERROR.

        IF  AVAIL tt-naturezas
        THEN DO:
            FIND FIRST estabelec NO-LOCK
                WHERE  estabelec.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            IF  AVAIL estabelec
            THEN
                ASSIGN v-ind-destino = 2. /* Transferˆncia */

            CREATE tt-item-nfs.
            ASSIGN tt-item-nfs.nr-nota-fis     = movto-estoq.nro-docto               
                   tt-item-nfs.serie           = movto-estoq.serie            
                   tt-item-nfs.cod-estabel     = movto-estoq.cod-estabel
                   tt-item-nfs.dt-emis-nota    = movto-estoq.dt-trans
                   tt-item-nfs.it-codigo       = movto-estoq.it-codigo            
                   tt-item-nfs.qt-faturada     = movto-estoq.quantidade
                   tt-item-nfs.un-fatur        = movto-estoq.un
                   tt-item-nfs.class-fiscal    = ITEM.class-fiscal
                   tt-item-nfs.ind-tipo        = v-ind-tipo     /* 1-Materia-Prima, 2-Acabado    */
                   tt-item-nfs.ind-destino     = v-ind-destino. /* 1-Consumidor, 2-Transferˆncia */

            RUN pi-narrativa-item (INPUT  ITEM.narrativa,
                                   OUTPUT tt-item-nfs.narrativa).
        END. /* IF  NOT AVAIL tt-naturezas */
    END. /* IF  AVAIL nota-fical AND */

END PROCEDURE.


PROCEDURE pi-valida-perda:
    ASSIGN v-log-perda = NO.

    IF  movto-estoq.esp-docto = 22 /* NFS */
    THEN DO:
        FIND FIRST tt-naturezas NO-LOCK
            WHERE  tt-naturezas.nat-operacao = movto-estoq.nat-operacao 
              AND  tt-naturezas.log-entrada  = ? 
              AND  tt-naturezas.log-perda    = YES NO-ERROR.

        IF  AVAIL tt-naturezas
        THEN
            ASSIGN v-log-perda = YES.
    END. /* IF  movto-estoq.esp-docto  = 22 /* NFS */ */
    ELSE DO:
        FIND FIRST tt-cta-perda NO-LOCK
            WHERE  tt-cta-perda.ct-codigo = movto-estoq.ct-codigo NO-ERROR.

        IF  AVAIL tt-cta-perda
        THEN
            ASSIGN v-log-perda = YES.
    END.

    IF  v-log-perda = YES
    THEN DO:
        CREATE tt-perdas.
        ASSIGN tt-perdas.it-codigo     = movto-estoq.it-codigo  
               tt-perdas.data-perda    = movto-estoq.dt-trans 
               tt-perdas.quantidade    = movto-estoq.quantidade 
               tt-perdas.un            = ITEM.un 
               tt-perdas.class-fiscal  = ITEM.class-fiscal
               tt-perdas.ind-tipo      = v-ind-tipo.

        RUN pi-narrativa-item (INPUT  ITEM.narrativa,
                               OUTPUT tt-perdas.narrativa).
    END. /* IF  v-log-perda = YES */

END PROCEDURE.


PROCEDURE pi-le-estrutura:
    
    EMPTY TEMP-TABLE tt-estrutura-exp.
    
    ASSIGN v-seq-estrutura = 0.

    FOR EACH tt-item-estrutura NO-LOCK:
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-item-estrutura.it-codigo:

            IF  ITEM.ge-codigo = 40 OR /* Acabados */
                ITEM.ge-codigo = 42 OR
                ITEM.ge-codigo = 45
            THEN DO:
                RUN pi-acompanhar IN h-acomp (INPUT "Item Pai: " + ITEM.it-codigo).
    
                ASSIGN v-seq-estrutura = v-seq-estrutura + 1.
    
                CREATE tt-estrutura-exp.
                ASSIGN tt-estrutura-exp.seq          = v-seq-estrutura
                       tt-estrutura-exp.nivel        = 0
                       tt-estrutura-exp.it-codigo    = ITEM.it-codigo
                       tt-estrutura-exp.un           = item.un              
                       tt-estrutura-exp.class-fiscal = item.class-fiscal
                       tt-estrutura-exp.data-inicio  = ITEM.data-implant
                       tt-estrutura-exp.ind-origem   = 2
                       tt-estrutura-exp.it-pai       = "".
    
                ASSIGN v-log-importado = NO.
                RUN pi-le-tp-desp (INPUT        tt-estrutura-exp.it-codigo,
                                   INPUT-OUTPUT v-log-importado).
    
                IF  v-log-importado = YES
                THEN
                    ASSIGN tt-estrutura-exp.ind-origem = 1.
    
                RUN pi-narrativa-item (INPUT  item.narrativa,
                                       OUTPUT tt-estrutura-exp.narrativa).
        
                FOR EACH estrutura NO-LOCK 
                   WHERE estrutura.it-codigo = ITEM.it-codigo:
               
                    CREATE tt-estrutura-exp.             
                    ASSIGN tt-estrutura-exp.seq          = v-seq-estrutura
                           tt-estrutura-exp.nivel        = 1
                           tt-estrutura-exp.it-codigo    = estrutura.es-codigo
                           tt-estrutura-exp.it-pai       = estrutura.it-codigo
                           tt-estrutura-exp.quantidade   = ROUND(estrutura.quant-usada,4)
                           tt-estrutura-exp.data-inicio  = estrutura.data-inicio
                           tt-estrutura-exp.data-termino = estrutura.data-termino
                           tt-estrutura-exp.ind-origem   = 2.
    
                    ASSIGN v-log-importado = NO.
                    RUN pi-le-tp-desp (INPUT tt-estrutura-exp.it-codigo,
                                       INPUT-OUTPUT v-log-importado).
    
                    IF  v-log-importado = YES
                    THEN
                        ASSIGN tt-estrutura-exp.ind-origem = 1.
    
                    FIND b-item NO-LOCK
                        WHERE b-item.it-codigo = tt-estrutura-exp.it-codigo NO-ERROR.
    
                    IF  AVAIL b-item
                    THEN DO:
                        ASSIGN tt-estrutura-exp.un           = b-item.un              
                               tt-estrutura-exp.class-fiscal = b-item.class-fiscal.
    
                        RUN pi-narrativa-item (INPUT  b-item.narrativa,
                                               OUTPUT tt-estrutura-exp.narrativa).
                    END.
                    
                    ASSIGN v-seq-nivel = 1.
               
                    RUN pi-estrutura-filho (INPUT estrutura.es-codigo,
                                            INPUT estrutura.quant-usada).
                END.
            END. /* IF  ITEM.ge-codigo = 40 OR /* Acabados */ */
        END. /* FOR EACH ITEM NO-LOCK: */
    END. /* FOR EACH tt-item-estrutura NO-LOCK: */
END PROCEDURE.


PROCEDURE pi-estrutura-filho:

    DEFINE INPUT PARAMETER p-it-codigo    LIKE ITEM.it-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER p-qt-usada-pai LIKE estrutura.quant-usada NO-UNDO.

    FOR EACH b-estrutura NO-LOCK
       WHERE b-estrutura.it-codigo = p-it-codigo:

        ASSIGN v-seq-nivel     = v-seq-nivel     + 1
               v-seq-estrutura = v-seq-estrutura + 1.

        CREATE tt-estrutura-exp.             
        ASSIGN tt-estrutura-exp.seq            = v-seq-estrutura
               tt-estrutura-exp.nivel          = v-seq-nivel
               tt-estrutura-exp.it-codigo      = b-estrutura.es-codigo
               tt-estrutura-exp.it-pai         = b-estrutura.it-codigo
               tt-estrutura-exp.quantidade     = ROUND(b-estrutura.quant-usada,4)
               tt-estrutura-exp.data-inicio    = b-estrutura.data-inicio
               tt-estrutura-exp.data-termino   = b-estrutura.data-termino
               tt-estrutura-exp.ind-origem     = 2.

        ASSIGN v-log-importado = NO.
        RUN pi-le-tp-desp (INPUT tt-estrutura-exp.it-codigo,
                           INPUT-OUTPUT v-log-importado).

        IF  v-log-importado = YES
        THEN
            ASSIGN tt-estrutura-exp.ind-origem = 1.

        FIND b-item NO-LOCK
            WHERE b-item.it-codigo = tt-estrutura-exp.it-codigo NO-ERROR.

        IF  AVAIL b-item
        THEN DO:
            ASSIGN tt-estrutura-exp.un           = b-item.un              
                   tt-estrutura-exp.class-fiscal = b-item.class-fiscal.

            RUN pi-narrativa-item (INPUT  b-item.narrativa,
                                   OUTPUT tt-estrutura-exp.narrativa).
        END.

        RUN pi-estrutura-filho (INPUT b-estrutura.es-codigo,
                                INPUT b-estrutura.quant-usada).

        ASSIGN v-seq-nivel = v-seq-nivel - 1.
    END.

END PROCEDURE.



PROCEDURE pi-valida-item:
    DEF INPUT PARAM p-it-codigo LIKE ITEM.it-codigo NO-UNDO.

    ASSIGN v-log-importado = NO.

    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    FIND FIRST tt-item-importado NO-LOCK
        WHERE  tt-item-importado.it-codigo = p-it-codigo NO-ERROR.

    IF  AVAIL tt-item-importado
    THEN DO:
        IF  tt-item-importado.log-importado = YES
        THEN
            ASSIGN v-log-importado = YES.

        ASSIGN v-ind-tipo = tt-item-importado.ind-tipo.
    END.
    ELSE DO:
        IF  ITEM.ge-codigo = 40 OR /* Acabados */
            ITEM.ge-codigo = 42 OR
            ITEM.ge-codigo = 45
        THEN
            ASSIGN v-ind-tipo = 2. /* Acabado */

        IF  ITEM.ge-codigo <> 40 AND /* Acabados */
            ITEM.ge-codigo <> 42 AND
            ITEM.ge-codigo <> 45 AND
            ITEM.ge-codigo <> 20 AND /* Semi Acabado */
            ITEM.ge-codigo <> 25
        THEN
            RUN pi-le-tp-desp (INPUT ITEM.it-codigo,
                               INPUT-OUTPUT v-log-importado).
        ELSE DO:
            EMPTY TEMP-TABLE tt-estrutura.
            RUN pi-estrutura (INPUT ROWID(ITEM)).

            bloco-estrutura:
            FOR EACH tt-estrutura NO-LOCK:
                RUN pi-le-tp-desp (INPUT tt-estrutura.es-codigo,
                                   INPUT-OUTPUT v-log-importado).

                IF  v-log-importado = YES
                THEN
                    LEAVE bloco-estrutura.
            END.
        END.
        
        CREATE tt-item-importado.
        ASSIGN tt-item-importado.it-codigo     = p-it-codigo
               tt-item-importado.log-importado = v-log-importado
               tt-item-importado.ind-tipo      = v-ind-tipo.
    END. /* IF  AVAIL tt-item-importado */

END PROCEDURE.

PROCEDURE pi-le-tp-desp:

    DEF INPUT        PARAM p-it-codigo     LIKE ITEM.it-codigo NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-log-importado   AS  LOG           NO-UNDO.

    DEFINE VARIABLE v-tp-desp-tmp AS INTEGER     NO-UNDO.

    ASSIGN v-tp-desp-tmp = ITEM.tp-desp-padrao.

    FIND item-uni-estab NO-LOCK
        WHERE item-uni-estab.it-codigo   = p-it-codigo
          AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.

    IF  AVAIL item-uni-estab
    THEN
        ASSIGN v-tp-desp-tmp = item-uni-estab.tp-desp-padrao.

    FIND FIRST tt-tp-desp-imp NO-LOCK
        WHERE  tt-tp-desp-imp.tp-desp-padrao = v-tp-desp-tmp NO-ERROR.

    IF  AVAIL tt-tp-desp-imp
    THEN
        ASSIGN p-log-importado = YES.

END PROCEDURE.

PROCEDURE pi-estrutura:

    DEF INPUT PARAM p-row-item AS ROWID NO-UNDO.

    run enp/en9991.p (input              p-row-item, 
                      input              "",     
                      input              1,
                      input              1,     /*qtde liquida*/     
                      input              0,     /*nivel*/
                      input-output table tt-estrutura,
                      input              today, /*corte*/
                      input              yes,   /*recursivo*/
                      input              20).   /*Niveis*/
END PROCEDURE.




PROCEDURE pi-narrativa-item:

    DEF INPUT  PARAM p-des-narrativa-item   AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-des-narrativa-manaus AS CHAR NO-UNDO.

    IF INDEX(p-des-narrativa-item,"#MANAUS#") <> 0
    THEN
        ASSIGN p-des-narrativa-manaus = TRIM(SUBSTRING(p-des-narrativa-item,INDEX(p-des-narrativa-item,"#MANAUS#") + 8,LENGTH(p-des-narrativa-item))).

    ASSIGN p-des-narrativa-manaus = REPLACE(p-des-narrativa-manaus,";",",")
           p-des-narrativa-manaus = REPLACE(p-des-narrativa-manaus,CHR(10),",")
           p-des-narrativa-manaus = REPLACE(p-des-narrativa-manaus,CHR(11),",")
           p-des-narrativa-manaus = REPLACE(p-des-narrativa-manaus,CHR(12),",")
           p-des-narrativa-manaus = REPLACE(p-des-narrativa-manaus,CHR(13),",").

END PROCEDURE.


/****************************************************************************/

PROCEDURE pi-exporta-entrada:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_nfe.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-item-doc-est:

        PUT UNFORMATTED tt-item-doc-est.nro-docto        ";" 
                        tt-item-doc-est.serie            ";"
                        tt-item-doc-est.des-decla-import ";"
                        tt-item-doc-est.dt-emissao       ";"
                        tt-item-doc-est.ind-origem       ";"
                        tt-item-doc-est.it-codigo        ";"
                        tt-item-doc-est.class-fiscal     ";"
                        tt-item-doc-est.narrativa        ";"
                        tt-item-doc-est.quantidade       ";"
                        tt-item-doc-est.un-fornec        ";"
                        tt-item-doc-est.un-interna       ";"
                        tt-item-doc-est.ind-tipo         SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE pi-exporta-saida:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_nfs.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-item-nfs:

        PUT UNFORMATTED tt-item-nfs.nr-nota-fis    ";" 
                        tt-item-nfs.serie          ";"
                        tt-item-nfs.dt-emis-nota   ";"
                        tt-item-nfs.it-codigo      ";"
                        tt-item-nfs.class-fiscal   ";"
                        tt-item-nfs.narrativa      ";"
                        tt-item-nfs.qt-faturada    ";"
                        tt-item-nfs.un-fatur       ";"
                        tt-item-nfs.ind-destino    ";"
                        tt-item-nfs.ind-tipo       SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE pi-exporta-estoque:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_estoque.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-estoque:

        RUN pi-acompanhar IN h-acomp (INPUT "Exportando estoque, aguarde... " + STRING(TIME,"hh:mm:ss")).

        PUT UNFORMATTED tt-estoque.it-codigo     ";"
                        tt-estoque.class-fiscal  ";"
                        tt-estoque.narrativa     ";"
                        tt-estoque.data-saldo    ";"
                        tt-estoque.quantidade    ";"
                        tt-estoque.un            ";"
                        tt-estoque.ind-tipo      SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE pi-exporta-perdas:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_perda.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-perdas:

        RUN pi-acompanhar IN h-acomp (INPUT "Exportando perdas, aguarde... " + STRING(TIME,"hh:mm:ss")).

        PUT UNFORMATTED tt-perdas.it-codigo     ";"
                        tt-perdas.class-fiscal  ";"
                        tt-perdas.narrativa     ";"
                        tt-perdas.data-perda    ";"
                        tt-perdas.quantidade    ";"
                        tt-perdas.un            ";"
                        tt-perdas.ind-tipo      SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE pi-exporta-estrutura:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_estrutura.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-estrutura-exp:

        RUN pi-acompanhar IN h-acomp (INPUT "Exportando estrutura, aguarde... " + STRING(TIME,"hh:mm:ss")).

        PUT UNFORMATTED tt-estrutura-exp.nivel         ";"
                        tt-estrutura-exp.it-pai        ";"
                        tt-estrutura-exp.it-codigo     ";"
                        tt-estrutura-exp.class-fiscal  ";"
                        tt-estrutura-exp.narrativa     ";"
                        tt-estrutura-exp.quantidade    ";"
                        tt-estrutura-exp.un            ";"
                        tt-estrutura-exp.data-inicio   ";"
                        tt-estrutura-exp.data-termino  ";"
                        tt-estrutura-exp.ind-origem    SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE pi-le-tabela-preco:
    FOR EACH item-fornec-estab NO-LOCK
        WHERE item-fornec-estab.cod-estabel = tt-param.cod-estabel:

        IF item-fornec-estab.ativo = NO THEN NEXT. /* Listar somente os ativos */
        IF item-fornec-estab.perc-compra < 100 THEN NEXT. /* e com percentual de compra igual a 100 */

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.
        /*Somente fornecedores estrangeiros*/
        IF emitente.natureza <> 3 THEN
            NEXT.

       
        FOR EACH tb-pr-cc NO-LOCK
            WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
              AND tb-pr-cc.dt-inicio   <= TODAY
              AND tb-pr-cc.dt-termino  >= TODAY
              AND tb-pr-cc.situacao     = 1:

            FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo NO-ERROR.

            FOR EACH item-tab OF tb-pr-cc NO-LOCK
                WHERE item-tab.it-codigo    = item-fornec-estab.it-codigo:
    
                IF NOT CAN-FIND (FIRST tt-item-tab
                                 WHERE tt-item-tab.it-codigo    = item-tab.it-codigo   
                                   AND tt-item-tab.cod-emitente = item-tab.cod-emitente)  THEN DO:

                    FIND FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = item-tab.it-codigo NO-ERROR.

                    FIND item-fornec NO-LOCK
                        WHERE item-fornec.it-codigo    = item-tab.it-codigo 
                          AND item-fornec.cod-emitente = emitente.cod-emitente NO-ERROR. 
    
                    CREATE tt-item-tab.
                    ASSIGN tt-item-tab.it-codigo    = item-tab.it-codigo   
                           tt-item-tab.cod-emitente = item-tab.cod-emitente
                           tt-item-tab.quant-min    = item-tab.quant-min
                           tt-item-tab.un           = IF AVAIL item-fornec THEN item-fornec.unid-med-for ELSE ITEM.un
                           tt-item-tab.mo-descricao = IF AVAIL moeda THEN moeda.descricao ELSE ""
                           tt-item-tab.pr-item      = item-tab.pr-item.
                END.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-exporta-tabela-preco:
    OUTPUT TO VALUE(v-cod-dir-destino + "quotas_manaus_tabela.csv") CONVERT TARGET "iso8859-1".

    FOR EACH tt-item-tab:

        RUN pi-acompanhar IN h-acomp (INPUT "Exportando tabela pre‡o, aguarde... " + STRING(TIME,"hh:mm:ss")).

        PUT UNFORMATTED tt-item-tab.it-codigo    ";"
                        tt-item-tab.cod-emitente ";"
                        tt-item-tab.quant-min ";"
                        tt-item-tab.un ";"
                        tt-item-tab.pr-item ";"
                        tt-item-tab.mo-descricao  SKIP.
    END.
    OUTPUT CLOSE.
END PROCEDURE.
