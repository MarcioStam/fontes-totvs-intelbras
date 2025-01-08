CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* def var iXML as LONGCHAR .                                                      */
/* def var oXML as LONGCHAR .                                                      */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>22330-101-1010000-1010000</NumeroOperacao>                  */
/*     <CodigoMensagem>MSG0227</CodigoMensagem>                                    */
/*     <LoginUsuario>toolsystems.marcelo</LoginUsuario>                            */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0227>                                                                   */
/*       <CodigoItemInicial>1010000</CodigoItemInicial>                            */
/*       <CodigoItemFinal>1010000</CodigoItemFinal>                                */
/*       <CodigoFornecedorEMS>22330</CodigoFornecedorEMS>                          */
/*       <Estabelecimento>                                                         */
/*         <CodigoEstabelecimento>101</CodigoEstabelecimento>                      */
/*       </Estabelecimento>                                                        */
/*       <Estabelecimento>                                                         */
/*         <CodigoEstabelecimento>102</CodigoEstabelecimento>                      */
/*       </Estabelecimento>                                                        */
/*       <MatriculaUsuario>zz99999</MatriculaUsuario>                              */
/*     </MSG0227>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0227.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}

DEF QUERY qr-item-estab-fornec
FOR item-uni-estab, item-fornec-estab, ITEM.

DEFINE VARIABLE de-val-unit AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dt-ult-ent  AS DATE        NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0227, Estabelecimento
   DATA-RELATION FOR conteudo, MSG0227 RELATION-FIELDS (idm, idm)         NESTED
   DATA-RELATION FOR MSG0227,  Estabelecimento RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0227R1, ParamItem, resultado
   DATA-RELATION FOR conteudor, MSG0227R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0227R1, ParamItem RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0227R1, resultado RELATION-FIELDS (idm, idm) NESTED.

DEFINE BUFFER b-usuar-mater FOR usuar-mater.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0227R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0227 NO-ERROR.

CREATE conteudor.
CREATE MSG0227R1.
CREATE resultado.

RUN esp/es0018p.p (INPUT "ESCEP055":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

/* CRIAÄ«O PARAMETROS ITENS */
RUN pi-parametros.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-parametros:

    ASSIGN MSG0227R1.ExibePrecos = fnExibePrecos(MSG0227.MatriculaUsuario).

    /*Filtro com um £nico item informado*/
    IF MSG0227.CodigoItemInicial = MSG0227.CodigoItemFinal THEN DO:
        OPEN QUERY qr-item-estab-fornec
        FOR EACH  item-uni-estab NO-LOCK
           WHERE  item-uni-estab.it-codigo       = MSG0227.CodigoItemInicial,
            EACH  item-fornec-estab NO-LOCK OUTER-JOIN
            WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
              AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
              AND item-fornec-estab.ativo        = YES   
              AND item-fornec-estab.perc-compra  > 0,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
    
        blk_repeat:
        REPEAT:
            GET NEXT qr-item-estab-fornec.
            IF NOT AVAIL item-uni-estab THEN
                LEAVE blk_repeat.
            RUN pi-leituras.
        END.
    END.

    /*Todos os filtros informados*/
    ELSE IF  MSG0227.MatriculaComprador <> ?
    AND MSG0227.CodigoFornecedorEMS     <> ? 
    AND CAN-FIND (FIRST Estabelecimento) THEN DO:

        FOR EACH Estabelecimento:
            OPEN QUERY qr-item-estab-fornec
            FOR EACH item-uni-estab NO-LOCK
               WHERE item-uni-estab.cod-estabel     = Estabelecimento.CodigoEstabelecimento 
                 AND item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
                 AND item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal
                 AND item-uni-estab.cod-comprado    = MSG0227.MatriculaComprador,
                EACH item-fornec-estab NO-LOCK
               WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
                 AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
                 AND item-fornec-estab.cod-emitente = MSG0227.CodigoFornecedorEMS
                 AND item-fornec-estab.ativo        = YES   
                 AND item-fornec-estab.perc-compra  > 0,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
        
            blk_repeat:
            REPEAT:
                GET NEXT qr-item-estab-fornec.
                IF NOT AVAIL item-uni-estab THEN
                    LEAVE blk_repeat.

                RUN pi-leituras.
            END.
        END.
    END.

    /*Filtro Estabelecimento n∆o informado*/
    ELSE IF  MSG0227.MatriculaComprador    <> ?
         AND MSG0227.CodigoFornecedorEMS   <> ? 
         AND NOT CAN-FIND (FIRST Estabelecimento) THEN DO:

        OPEN QUERY qr-item-estab-fornec
        FOR EACH  item-uni-estab NO-LOCK
           WHERE  item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
             AND  item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal
             AND  item-uni-estab.cod-comprado    = MSG0227.MatriculaComprador,
            EACH  item-fornec-estab NO-LOCK 
            WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
              AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
              AND item-fornec-estab.cod-emitente = MSG0227.CodigoFornecedorEMS
              AND item-fornec-estab.ativo        = YES   
              AND item-fornec-estab.perc-compra  > 0,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
    
        blk_repeat:
        REPEAT:
            GET NEXT qr-item-estab-fornec.
            IF NOT AVAIL item-uni-estab THEN
                LEAVE blk_repeat.

            RUN pi-leituras.
        END.
    END.

    /*Filtro Comprador n∆o informado*/
    ELSE IF  MSG0227.MatriculaComprador     = ?
         AND MSG0227.CodigoFornecedorEMS   <> ? 
         AND CAN-FIND (FIRST Estabelecimento) THEN DO:

        FOR EACH estabelecimento:
            OPEN QUERY qr-item-estab-fornec
            FOR EACH  item-uni-estab NO-LOCK
               WHERE  item-uni-estab.cod-estabel     = Estabelecimento.CodigoEstabelecimento 
                 AND  item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
                 AND  item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal,
                EACH  item-fornec-estab NO-LOCK 
                WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
                  AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
                  AND item-fornec-estab.cod-emitente = MSG0227.CodigoFornecedorEMS
                  AND item-fornec-estab.ativo        = YES   
                  AND item-fornec-estab.perc-compra  > 0,
                FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
        
            blk_repeat:
            REPEAT:
                GET NEXT qr-item-estab-fornec.
                IF NOT AVAIL item-uni-estab THEN
                    LEAVE blk_repeat.

                RUN pi-leituras.
            END.
        END.
    END.

    /*Filtro Fornecedor n∆o informado*/
    ELSE IF  MSG0227.MatriculaComprador    <> ?
         AND MSG0227.CodigoFornecedorEMS    = ? 
         AND CAN-FIND (FIRST Estabelecimento) THEN DO:

        FOR EACH Estabelecimento:
            OPEN QUERY qr-item-estab-fornec
            FOR EACH  item-uni-estab NO-LOCK
               WHERE  item-uni-estab.cod-estabel     = Estabelecimento.CodigoEstabelecimento 
                 AND  item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
                 AND  item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal
                 AND  item-uni-estab.cod-comprado    = MSG0227.MatriculaComprador,
                EACH  item-fornec-estab NO-LOCK OUTER-JOIN     
                WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
                  AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
                  AND item-fornec-estab.ativo        = YES   
                  AND item-fornec-estab.perc-compra  > 0,
                FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = item-uni-estab.it-codigo.

            blk_repeat:
            REPEAT:
                GET NEXT qr-item-estab-fornec.
                IF NOT AVAIL item-uni-estab THEN
                    LEAVE blk_repeat.

                RUN pi-leituras.
            END.
        END.
    END.

    /*Filtro somente com Comprador informado*/
    ELSE IF  MSG0227.MatriculaComprador    <> ?
         AND MSG0227.CodigoFornecedorEMS    = ? 
         AND NOT CAN-FIND (FIRST Estabelecimento) THEN DO:

        OPEN QUERY qr-item-estab-fornec
        FOR EACH  item-uni-estab NO-LOCK
           WHERE  item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
             AND  item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal
             AND  item-uni-estab.cod-comprado    = MSG0227.MatriculaComprador,
            EACH  item-fornec-estab NO-LOCK OUTER-JOIN     
            WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
              AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
              AND item-fornec-estab.ativo        = YES   
              AND item-fornec-estab.perc-compra  > 0,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
    
        blk_repeat:
        REPEAT:
            GET NEXT qr-item-estab-fornec.
            IF NOT AVAIL item-uni-estab THEN
                LEAVE blk_repeat.

            RUN pi-leituras.
        END.
    END.

    /*Filtro somente com Fornecedor informado*/
    ELSE IF MSG0227.MatriculaComprador     = ?
        AND MSG0227.CodigoFornecedorEMS   <> ? 
        AND NOT CAN-FIND (FIRST Estabelecimento) THEN DO:
        
        OPEN QUERY qr-item-estab-fornec
        FOR EACH  item-uni-estab NO-LOCK
           WHERE  item-uni-estab.it-codigo      >= MSG0227.CodigoItemInicial
             AND  item-uni-estab.it-codigo      <= MSG0227.CodigoItemFinal,
            EACH  item-fornec-estab NO-LOCK
            WHERE item-fornec-estab.it-codigo    = item-uni-estab.it-codigo
              AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel 
              AND item-fornec-estab.cod-emitente = MSG0227.CodigoFornecedorEMS
              AND item-fornec-estab.ativo        = YES   
              AND item-fornec-estab.perc-compra  > 0,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-uni-estab.it-codigo.
            
        blk_repeat:
        REPEAT:
            GET NEXT qr-item-estab-fornec.
            IF NOT AVAIL item-uni-estab THEN
                LEAVE blk_repeat.

            RUN pi-leituras.
        END.
    END.
    /*Ao menos um filtro deve ser informado*/    
    ELSE DO:
        RUN pi-erro (INPUT "N∆o foi poss°vel executar a consulta, nehum dos filtros obrigat¢rios foi informado!").
        RETURN "NOK".
    END.

    RETURN "OK":U.
END.

PROCEDURE pi-leituras:
    DEFINE VARIABLE i-cod-emitente   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cod-estabel    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor-frete   AS DECIMAL.
    DEFINE VARIABLE log-frete        AS LOGICAL.
    DEFINE VARIABLE log-taxa-financ  AS LOGICAL.
    DEFINE VARIABLE de-aliquota-icm  LIKE item-tab.aliquota-icm.
    DEFINE VARIABLE log-codigo-ipi   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-aliquota-ipi  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-saldo         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-pr-item       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-moeda-pr-item  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-origem-aux     AS INTEGER     NO-UNDO.

    /*Filtro NomeProduto*/
    IF MSG0227.NomeProduto <> ? THEN
        IF NOT ITEM.desc-item MATCHES("*" + MSG0227.NomeProduto + "*") THEN
            NEXT.

    /*Filtro fornec por 1 unico item*/
    IF MSG0227.CodigoFornecedorEMS <> ? THEN
        IF item-fornec-estab.cod-emitente <> MSG0227.CodigoFornecedorEMS THEN
            NEXT.
        
    /*Filtro estab por 1 unico item*/
    IF CAN-FIND (FIRST Estabelecimento) THEN DO:
        
        IF NOT CAN-FIND (FIRST Estabelecimento
                         WHERE Estabelecimento.CodigoEstabelecimento = item-uni-estab.cod-estabel) THEN
            NEXT.
    END.
                 
        
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.

    FIND FIRST emitente-cex NO-LOCK
         WHERE emitente-cex.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.

    FIND FIRST int-item-fornec-estab NO-LOCK
         WHERE int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo 
           AND int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
           AND int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel NO-ERROR.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = item-fornec-estab.cod-cond-pag NO-ERROR.   

    ASSIGN de-aliquota-ipi = 0
           de-pr-item      = 0
           log-codigo-ipi  = NO
           de-aliquota-icm = 0
           de-valor-frete  = 0
           log-frete       = NO
           log-taxa-financ = NO.

    IF AVAIL item-fornec-estab THEN DO:
        FOR EACH  tb-pr-cc NO-LOCK USE-INDEX tbprcc_ix2
            WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente 
              AND tb-pr-cc.cod-cond-pag = cond-pagto.cod-cond-pag
              AND tb-pr-cc.situacao     = 1
              AND tb-pr-cc.dt-inicio   <= TODAY
              AND tb-pr-cc.dt-termino  >= TODAY,                            
            FIRST item-tab NO-LOCK USE-INDEX tab-item
            WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente 
              AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
              AND item-tab.nr-tab       = tb-pr-cc.nr-tab 
              AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio 
              AND item-tab.it-codigo    = item-fornec-estab.it-codigo:  
        
            ASSIGN de-aliquota-ipi = item-tab.aliquota-ipi
                   de-pr-item      = item-tab.pr-item
                   log-codigo-ipi  = tb-pr-cc.codigo-ipi
                   de-aliquota-icm = item-tab.aliquota-icm
                   de-valor-frete  = tb-pr-cc.valor-frete
                   log-frete       = tb-pr-cc.frete      
                   log-taxa-financ = tb-pr-cc.taxa-financ.
        
            FIND FIRST moeda NO-LOCK
                 WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo NO-ERROR.
        
            IF  AVAIL moeda THEN
                ASSIGN c-moeda-pr-item = moeda.mo-codigo.
            
            LEAVE.
        END.
    END.
        
    FIND FIRST grup-estoque NO-LOCK
         WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-ERROR.
    
    FIND FIRST int-item-uni-estab
         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel  
           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.
    
    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.
    
    FIND FIRST usuar-mater NO-LOCK
         WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.

    FIND FIRST item-estab NO-LOCK
         WHERE item-estab.it-codigo   = item-uni-estab.it-codigo
           AND item-estab.cod-estabel = item-uni-estab.cod-estabel NO-ERROR.
    
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = item-uni-estab.cod-estabel NO-ERROR.
    
    FIND FIRST unid-negoc NO-LOCK
         WHERE unid-negoc.cod-unid-negoc = item-uni-estab.cod-unid-negoc NO-ERROR.
    
    FIND FIRST itinerario NO-LOCK
         WHERE IF AVAIL emitente-cex THEN itinerario.cod-itiner = emitente-cex.cod-itiner-imp ELSE NO NO-ERROR.
    
    FIND FIRST pto-contr NO-LOCK
         WHERE IF AVAIL emitente-cex THEN pto-contr.cod-pto-contr = emitente-cex.cod-pto-contr ELSE NO NO-ERROR.
    
    FIND FIRST inco-cx NO-LOCK
         WHERE IF AVAIL emitente-cex THEN inco-cx.cod-incoterm = emitente-cex.cod-incoterm-imp ELSE NO NO-ERROR.
    
    FIND FIRST item-mat NO-LOCK
         WHERE item-mat.it-codigo = ITEM.it-codigo NO-ERROR.

    FIND FIRST planejad NO-LOCK 
         WHERE planejad.cd-planejado = item-uni-estab.cd-planejado NO-ERROR.

    FIND FIRST tipo-rec-desp NO-LOCK
         WHERE tipo-rec-desp.tp-codigo = item-uni-estab.tp-desp-padrao NO-ERROR.
        
    
    ASSIGN de-saldo = 0.
    
    FOR EACH saldo-estoq USE-INDEX estabel-item NO-LOCK
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel 
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo:
        ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
    END.
    
    RELEASE fabricante.
    IF  AVAIL item-fornec-estab THEN DO:
        FIND FIRST item-fabric NO-LOCK
             WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo 
               AND item-fabric.cod-fabric = INT(item-fornec-estab.item-do-for)                             
               AND item-fabric.estado     = YES /* Ativo */ NO-ERROR.
    
        IF  AVAIL item-fabric THEN 
            FIND FIRST fabricante NO-LOCK                  
                 WHERE fabricante.cod-fabric = ITEM-fabric.cod-fabric NO-ERROR.
    END.

    ASSIGN de-val-unit = ?
           dt-ult-ent  = ?.

    FOR LAST recebimento NO-LOCK USE-INDEX ITEM
       WHERE recebimento.it-codigo = ITEM.it-codigo,
       FIRST ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem = recebimento.numero-ordem
         AND ordem-compra.cod-estabel  = item-uni-estab.cod-estabel:
            run cdp/cd0812.p (INPUT 0, 
                              INPUT 0,
                              INPUT recebimento.preco-unit,
                              INPUT recebimento.data-nota,
                              OUTPUT de-val-unit).

            ASSIGN dt-ult-ent = recebimento.data-movto .
    END.
    
    ASSIGN i-origem-aux = item.codigo-orig + 1.

     

     ASSIGN de-indice = 1.
     
     
    {cdp/cd9950.i item-fornec-estab.it-codigo
                  item-fornec-estab.unid-med-for
                  item-fornec-estab.cod-emitente}

    ASSIGN de-indice = 1 WHEN (de-indice = 0 OR de-indice = ?).

     
    CREATE ParamItem.
    ASSIGN ParamItem.CodigoEstabelecimento         = item-uni-estab.cod-estabel
           ParamItem.NomeEstabelecimento           = IF AVAIL estabelec THEN estabelec.nome ELSE ""
           ParamItem.CodigoProduto                 = item-uni-estab.it-codigo
           ParamItem.NomeProduto                   = IF msg0227.I18N AND ITEM.desc-inter <> "" THEN SUBSTRING(ITEM.desc-inter,1,60) ELSE SUBSTRING(ITEM.desc-item,1,60)
           ParamItem.CodigoUnidadeMedida           = ITEM.un
           ParamItem.CodigoUnidadeNegocio          = item-uni-estab.cod-unid-negoc
           ParamItem.NomeUnidadeNegocio            = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE ""
           ParamItem.SituacaoItemEMS               = IF item-uni-estab.cod-obsoleto <> 0 THEN item-uni-estab.cod-obsoleto ELSE 4
           ParamItem.CotacaoAutomatica             = IF AVAIL item-fornec-estab THEN item-fornec-estab.cot-aut ELSE ?
           ParamItem.MatriculaComprador            = item-uni-estab.cod-comprado
           ParamItem.NomeComprador                 = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE ""
           ParamItem.DataUltimaEntrada             = dt-ult-ent
           ParamItem.NecessitaLI                   = ITEM.log-necessita-li
           ParamItem.NecessitaInspecaoOrigem       = IF AVAIL int-item-fornec-estab THEN int-item-fornec-estab.log-nec-insp ELSE ?
           ParamItem.Antidumping                   = int-item.log-antidumping
           ParamItem.ObservacaoLogistica           = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.observacao ELSE ""
           ParamItem.NCM                           = ITEM.class-fiscal
           ParamItem.DestaqueNCM                   = int-item.destaque
           ParamItem.NVE                           = int-item.nve
           ParamItem.AliquotaII                    = DEC(REPLACE(SUBSTRING(ITEM.char-2,22,6),"0 1","1")) /*Feito replace para corrigir uma inconsistencia da base que estava gravando espaáo*/
           ParamItem.TributacaoII                  = ITEM.cod-trib-ii
           ParamItem.SuspensaoII                   = item-mat.log-suspens-impto-import
           ParamItem.ExTarifario                   = int-item.ex-tarifario
           ParamItem.ConsumoMedio                  = round(item-uni-estab.consumo-prev,2)
           ParamItem.Saldo                         = de-saldo
           ParamItem.ClassificacaoABC              = IF item-uni-estab.classif-abc <> 0 THEN item-uni-estab.classif-abc ELSE ?
           ParamItem.Obtencao                      = ITEM.compr-fabric
           ParamItem.CodigoGrupoEstoque            = ITEM.ge-codigo
           ParamItem.NomeGrupoEstoque              = grup-estoque.descricao
           ParamItem.MatriculaPlanejador           = item-uni-estab.cd-planejado
           ParamItem.NomePlanejador                = IF AVAIL planejad THEN planejad.nome ELSE ""
           ParamItem.Politica                      = item-uni-estab.politica
           ParamItem.TipoDemanda                   = IF item-uni-estab.demanda <> 0 THEN item-uni-estab.demanda ELSE ?
           ParamItem.LoteMultiploProducao          = item-uni-estab.lote-multipl
           ParamItem.LoteMinimoProducao            = item-uni-estab.lote-minimo
           ParamItem.PeriodoFixo                   = item-uni-estab.periodo-fixo
           ParamItem.QuantidadePoliticaEstoque     = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol  ELSE 0
           ParamItem.QuantidadeEstoqueSeguranca    = item-uni-estab.quant-segur
           ParamItem.TipoEstoqueSeguranca          = item-uni-estab.tipo-est-seg
           ParamItem.TempoSeguranc                 = item-uni-estab.tempo-segur
           ParamItem.ConverteTempoSeguranca        = item-uni-estab.conv-tempo-seg
           ParamItem.Reabastecimento               = IF SUBSTR(item-uni-estab.char-1,10,1) <> "" THEN int(SUBSTR(item-uni-estab.char-1,10,1)) ELSE ?
           ParamItem.ClasseReprogramacao           = item-uni-estab.classe-repro
           ParamItem.EmissaoOrdens                 = IF item-uni-estab.emissao-ord <> 0 THEN item-uni-estab.emissao-ord ELSE ?
           ParamItem.DivisaoOrdens                 = item-uni-estab.div-ordem
           ParamItem.PrioridadeMRP                 = item-uni-estab.int-1
           ParamItem.RepressaDemanda               = IF SUBSTRING(item-uni-estab.char-1,132,1) = "1" THEN YES ELSE NO
           ParamItem.Prioridade                    = item-uni-estab.prioridade
           ParamItem.TempoRessuprimentoCompras     = item-uni-estab.res-int-comp
           ParamItem.TempoRessuprimentoCQ          = item-uni-estab.res-cq-comp
           ParamItem.HorizonteLiberacao            = int(SUBSTRING(item-uni-estab.char-1,129,3))
           ParamItem.HorizonteFixoProducao         = item-uni-estab.horiz-fixo      
           ParamItem.DepositoPadrao                = item-uni-estab.deposito-pad    
           ParamItem.CodigoTipoDespesa             = item-uni-estab.tp-desp-padrao  
           ParamItem.DescricaoTipoDespesa          = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""
           ParamItem.CodigoOrigemItem              = IF AVAIL int-item-uni-estab AND int-item-uni-estab.codigo-orig <> 0 THEN int-item-uni-estab.codigo-orig ELSE ?
           /*ParamItem.DescricaoOrigem               = {ininc/i18in122.i 04 i-origem-aux}     Removido pelo Francisco*/
           ParamItem.CodigoFornecedorEMS           = IF AVAIL emitente THEN emitente.cod-emitente ELSE ?
           ParamItem.NomeAbreviadoFornecedor       = IF AVAIL emitente THEN emitente.nome-abrev   ELSE ?
           ParamItem.PercentualCompraFornecedor    = IF AVAIL item-fornec-estab THEN item-fornec-estab.perc-compra ELSE ?
           ParamItem.Pais                          = IF AVAIL emitente   THEN emitente.pais           ELSE ?
           ParamItem.CodigoCondicaoPagamento       = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE ?
           ParamItem.NomeCondicaoPagamento         = IF AVAIL cond-pagto THEN cond-pagto.descricao    ELSE ?
           ParamItem.TempoRessuprimentoFornecedor  = item-uni-estab.res-for-comp
           ParamItem.HorizonteFixo                 = IF AVAIL item-fornec-estab THEN item-fornec-estab.horiz-fixo   ELSE ?
           ParamItem.LoteMultiploItemFornecedor    = IF AVAIL item-fornec-estab THEN item-fornec-estab.lote-mul-for ELSE ?
           ParamItem.LoteMinimoItemFornecedor      = IF AVAIL item-fornec-estab THEN item-fornec-estab.lote-minimo  ELSE ?
           ParamItem.CodigoFabricante              = IF AVAIL fabricante   THEN fabricante.cod-fabric       ELSE IF AVAIL emitente THEN emitente.cod-emitente ELSE ?
           ParamItem.NomeFabricante                = IF AVAIL fabricante   THEN fabricante.nome-abrev       ELSE IF AVAIL emitente THEN emitente.nome-abrev   ELSE ?
           ParamItem.PartNumberItemFabricante      = IF AVAIL item-fabric  THEN item-fabric.it-fabric       ELSE ""
           ParamItem.CodigoUnidadeMedidaFornecedor = IF AVAIL item-fornec-estab THEN item-fornec-estab.unid-med-for ELSE ?
           ParamItem.CodigoItinerarioPadrao        = IF AVAIL emitente-cex THEN emitente-cex.cod-itiner-imp ELSE ?
           ParamItem.DescricaoItinerarioPadrao     = IF AVAIL itinerario   THEN itinerario.descricao        ELSE ?
           ParamItem.CodigoPontoControleBase       = IF AVAIL pto-contr    THEN pto-contr.cod-pto-contr     ELSE ?
           ParamItem.DescricaoPontoControleBase    = IF AVAIL pto-contr    THEN pto-contr.descricao         ELSE ?
           ParamItem.CodigoIncoterm                = IF AVAIL inco-cx      THEN inco-cx.cod-incoterm        ELSE ?
           ParamItem.DescricaoIncoterm             = IF AVAIL inco-cx      THEN inco-cx.descricao           ELSE ?
           ParamItem.IdiomaPadrao                  = IF AVAIL emitente-cex THEN emitente-cex.cod-idioma     ELSE ?
           ParamItem.PercentualGATT                = int-item.perc-gatt  
           ParamItem.SeqSuframa                    = int-item.seq-suframa
           ParamItem.PesoLiquido                   = ITEM.peso-liquido   
           ParamItem.PesoBruto                     = ITEM.peso-bruto     
           ParamItem.TributacaoICMS                = ITEM.cd-trib-icm    
           ParamItem.FatorReajusteICMS             = ITEM.fator-reaj-icms
           ParamItem.AliquotaICMS                  = de-aliquota-icm
           ParamItem.TributacaoPIS                 = item-mat.idi-tributac-pis                 
           ParamItem.OrigemAliquotaPIS             = IF INT(SUBSTR(ITEM.char-2,52,1)) = 1 THEN 1 ELSE 2 /*Tratamento necess†rio pois o produto considera os registros "0" como "Natureza"*/
           ParamItem.AliquotaPIS                   = item-mat.val-aliq-ext-pis                 
           ParamItem.PercentualReducaoPIS          = item-mat.val-reduc-pis-normal             
           ParamItem.TributacaoCOFINS              = item-mat.idi-tributac-cofins
           ParamItem.OrigemAliquotaCOFINS          = IF INT(SUBSTR(ITEM.char-2,53,1)) = 1 THEN 1 ELSE 2 /*Tratamento necess†rio pois o produto considera os registros "0" como "Natureza"*/
           ParamItem.AliquotaCOFINS                = item-mat.val-aliq-ext-cofins              
           ParamItem.PercentualReducaoCOFINS       = item-mat.val-reduc-cofins-normal
           ParamItem.FreteIncluso                  = log-frete          
           ParamItem.ValorFrete                    = de-valor-frete     
           ParamItem.EncargosFinanceiros           = log-taxa-financ.

    ASSIGN ParamItem.PrecoMedio         = IF AVAIL item-estab THEN item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1] ELSE 0
           ParamItem.PrecoItem          = de-pr-item
           ParamItem.CodigoMoedaEMS     = c-moeda-pr-item 
           ParamItem.AliquotaIPI        = de-aliquota-ipi
           ParamItem.TributacaoIPI      = ITEM.cd-trib-ipi          
           ParamItem.FamiliaIPI         = IF AVAIL item-mat THEN item-mat.cod-familia-impto        ELSE ""
           ParamItem.SuspensaoIPI       = IF AVAIL item-mat THEN item-mat.log-suspens-impto-import ELSE ?
           ParamItem.IPIIncluso         = log-codigo-ipi
           ParamItem.PrecoUltimaEntrada = round(de-val-unit,4)
           ParamItem.FatorConversao     = de-indice. 

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
