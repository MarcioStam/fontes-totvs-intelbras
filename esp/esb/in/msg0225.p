CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/*                 <MENSAGEM>                                                                      */
/*                   <CABECALHO>                                                                   */
/*                     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                     <NumeroOperacao>gu048488-2015-07-01-2015-07-31-2-fr04965</NumeroOperacao>   */
/*                     <CodigoMensagem>MSG0225</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0225>                                                               */
/*                             <CodigoTabela>2</CodigoTabela>                                      */
/*                             <CodigoCondicaoPagamento>4</CodigoCondicaoPagamento>                */
/*                         </MSG0225>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0225.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0225
   DATA-RELATION FOR conteudo, MSG0225      RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0225R1, TabelaPreco, ItemTabela, resultado
   DATA-RELATION FOR conteudor, MSG0225R1      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0225R1, TabelaPreco    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR TabelaPreco, ItemTabela   RELATION-FIELDS (relac, relac) NESTED
   DATA-RELATION FOR MSG0225R1, resultado      RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0225R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0225 NO-ERROR.

CREATE conteudor.
CREATE MSG0225R1.
CREATE resultado.

RUN retorna-tabela.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

DEFINE VARIABLE hDoc    AS HANDLE   NO-UNDO.
CREATE X-DOCUMENT hDoc.
hDoc:LOAD("LONGCHAR", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE retorna-tabela:

    ASSIGN MSG0225R1.ExibePrecos = fnExibePrecos(MSG0225.MatriculaUsuario) /*esesb000fn1.i*/.

    ASSIGN i-relac = 0.

    FOR EACH tb-pr-cc NO-LOCK:

        FIND FIRST int-tb-pr-cc EXCLUSIVE-LOCK 
             WHERE int-tb-pr-cc.cod-estabel  = int-tb-pr-cc.cod-estabel
               AND int-tb-pr-cc.cod-emitente = int-tb-pr-cc.cod-emitente 
               AND int-tb-pr-cc.cod-cond-pag = int-tb-pr-cc.cod-cond-pag
               AND int-tb-pr-cc.mo-codigo    = int-tb-pr-cc.mo-codigo    
               AND int-tb-pr-cc.dt-inicio    = int-tb-pr-cc.dt-inicio NO-ERROR.

        ASSIGN i-relac = i-relac + 1.
              
        IF  MSG0225.CodigoTabela <> ?
        AND MSG0225.CodigoTabela <> tb-pr-cc.nr-tab THEN
            NEXT.

        IF  MSG0225.SituacaoTabela <> ?
        AND MSG0225.SituacaoTabela <> tb-pr-cc.situacao THEN
            NEXT.

        IF  MSG0225.CodigoFornecedorEMS <> ?
        AND MSG0225.CodigoFornecedorEMS <> tb-pr-cc.cod-emitente THEN
            NEXT.

        IF  MSG0225.CodigoCondicaoPagamento <> ?
        AND MSG0225.CodigoCondicaoPagamento <> tb-pr-cc.cod-cond-pag THEN
            NEXT.

        IF  MSG0225.CodigoMoedaEMS <> ?
        AND MSG0225.CodigoMoedaEMS <> tb-pr-cc.mo-codigo THEN
            NEXT.

        IF  MSG0225.CodigoEstabelecimento <> ?
        AND MSG0225.CodigoEstabelecimento <> tb-pr-cc.cod-estabel THEN
            NEXT.

        IF  MSG0225.DataVigencia <> ?
        AND (MSG0225.DataVigencia < tb-pr-cc.dt-inicio
         OR  MSG0225.DataVigencia > tb-pr-cc.dt-termino) THEN
            NEXT.

        FOR EACH item-tab NO-LOCK USE-INDEX tab-item
        WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente 
          AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
          AND item-tab.nr-tab       = tb-pr-cc.nr-tab 
          AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio:

            IF  MSG0225.CodigoProduto <> ?
            AND MSG0225.CodigoProduto <> item-tab.it-codigo THEN
                NEXT.

            IF NOT CAN-FIND (FIRST TabelaPreco
                             WHERE TabelaPreco.CodigoFornecedorEMS     = tb-pr-cc.cod-emitente
                               AND TabelaPreco.CodigoCondicaoPagamento = tb-pr-cc.cod-cond-pag
                               AND TabelaPreco.CodigoTabela            = tb-pr-cc.nr-tab      
                               AND TabelaPreco.DataInicio              = tb-pr-cc.dt-inicio) THEN DO:

                CREATE TabelaPreco.
                ASSIGN TabelaPreco.relac                       = i-relac
                       TabelaPreco.CodigoTabela                = tb-pr-cc.nr-tab        
                       TabelaPreco.DescricaoTabela             = tb-pr-cc.nome-abrev    
                       TabelaPreco.DataInicio                  = tb-pr-cc.dt-inicio     
                       TabelaPreco.DataTermino                 = tb-pr-cc.dt-termino    
                       TabelaPreco.SituacaoTabela              = tb-pr-cc.situacao      
                       TabelaPreco.CodigoFornecedorEMS         = tb-pr-cc.cod-emitente  
                       TabelaPreco.CodigoCondicaoPagamento     = tb-pr-cc.cod-cond-pag  
                       TabelaPreco.CodigoMoedaEMS              = tb-pr-cc.mo-codigo     
                       TabelaPreco.IPIIncluso                  = tb-pr-cc.codigo-IPI    
                       TabelaPreco.ValorFrete                  = tb-pr-cc.valor-frete   
                       TabelaPreco.FreteIncluso                = tb-pr-cc.frete         
                       TabelaPreco.EncargosFinanceirosInclusos = tb-pr-cc.taxa-financ
                       TabelaPreco.DiasLiberaFFT               = IF AVAIL int-tb-pr-cc THEN int-tb-pr-cc.num-dias-libera-fft ELSE 0.
            END.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = item-tab.it-codigo NO-ERROR.

            FIND FIRST item-fornec NO-LOCK
                 WHERE item-fornec.it-codigo    = ITEM.it-codigo 
                   AND item-fornec.cod-emitente = tb-pr-cc.cod-emitente NO-ERROR.

            CREATE ItemTabela.
            ASSIGN ItemTabela.relac               = i-relac
                   ItemTabela.CodigoProduto       = item-tab.it-codigo                                          
                   ItemTabela.NomeProduto         = IF msg0225.I18N AND ITEM.desc-inter <> "" THEN ITEM.desc-inter ELSE ITEM.desc-item                                              
                   ItemTabela.CodigoUnidadeMedida = IF AVAIL item-fornec THEN item-fornec.unid-med-for ELSE ITEM.un                                                     
                   ItemTabela.PrecoItem           = item-tab.pr-item                                            
                   ItemTabela.GrupoCorrecoes      = item-tab.int-1                                              
                   ItemTabela.QuantidadeMinima    = item-tab.quant-min                                          
                   ItemTabela.AliquotaIPI         = item-tab.aliquota-IPI                                       
                   ItemTabela.DescontoQuantidade  = item-tab.desco-quant                                        
                   ItemTabela.AliquotaICMS        = item-tab.aliquota-icm                                       
                   ItemTabela.TotalDesconto       = (((item-tab.desco-quant * item-tab.pr-item) * item-tab.desco-quant) / 100).  
        END.
    END.
   
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
