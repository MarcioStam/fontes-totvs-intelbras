/******************************************************************************
**  Programa.: ESCRM001A.I
**  Objetivo.: ê passado como parametro qual tabela ser† enviada para
**             o CRM 
**             {1} = Tabela que ser† enviada                
**  Autor....: SQLWorks
*******************************************************************************/

find first tt-cont-emit-atu              no-error.
find first tt-loc-entr-atu               no-error.
find first tt-repres-atu                 no-error.
find first tt-portador-atu               no-error.
find first tt-receita-padrao-atu         no-error.
find first tt-cond-pagto-atu             no-error.
find first tt-cep-atu                    no-error.
find first tt-transporte-atu             no-error.
find first tt-canal-venda-atu            no-error.
find first tt-gr-cli-atu                 no-error.
find first tt-relacionamento-cliente-atu no-error.
FIND FIRST tt-cidade-atu                 NO-ERROR.
FIND FIRST tt-unid-feder-atu             NO-ERROR.

FIND FIRST tt-item-atu                   NO-ERROR.      
FIND FIRST tt-familia-material-atu       NO-ERROR.
FIND FIRST tt-familia-comercial-atu      NO-ERROR.
FIND FIRST tt-estrutura-atu              NO-ERROR.
FIND FIRST tt-grup-estoque-atu           NO-ERROR.
FIND FIRST tt-natur-oper-atu             NO-ERROR.
FIND FIRST tt-mensagem-atu               NO-ERROR.
FIND FIRST tt-estabelec-atu              NO-ERROR.
FIND FIRST tt-tab-finan-atu              NO-ERROR.
FIND FIRST tt-ind-tab-finan-atu          NO-ERROR.
FIND FIRST tt-rota-atu                   NO-ERROR.
FIND FIRST tt-crm-categoria-atu          NO-ERROR.
find first tt-crm-categ-un-atu           no-error.  
find first tt-tb-preco-atu               no-error.           
find first tt-preco-item-atu             no-error.  
FIND FIRST tt-new_unidade_familia-atu    NO-ERROR.
FIND FIRST tt-new_segmento-atu           NO-ERROR.
FIND FIRST tt-new_familia-atu            NO-ERROR.
FIND FIRST tt-new_subfamilia-atu         NO-ERROR.
FIND FIRST tt-new_origem-atu             NO-ERROR. 

if "{1}" = "Preco-item"
then do: 

    CREATE tt-preco-item.
    ASSIGN tt-preco-item.it-codigo           = tt-preco-item-atu.it-codigo          
           tt-preco-item.nr-tabpre           = tt-preco-item-atu.nr-tabpre          
           tt-preco-item.dt-inival           = tt-preco-item-atu.dt-inival          
           tt-preco-item.quant-min           = tt-preco-item-atu.quant-min          
           tt-preco-item.preco-venda         = tt-preco-item-atu.preco-venda        
           tt-preco-item.preco-fob           = tt-preco-item-atu.preco-fob          
           tt-preco-item.preco-min-cif       = tt-preco-item-atu.preco-min-cif      
           tt-preco-item.preco-min-fob       = tt-preco-item-atu.preco-min-fob      
           tt-preco-item.new_chaveintegracao = TRIM(STRING(tt-preco-item-atu.it-codigo)) + ",":U + 
                                               TRIM(STRING(tt-preco-item-atu.cod-refer)) + ",":U + 
                                               TRIM(STRING(tt-preco-item-atu.nr-tabpre)) + ",":U + 
                                               TRIM(STRING(tt-preco-item-atu.dt-inival)) + ",":U + 
                                               TRIM(STRING(tt-preco-item-atu.quant-min)).

    FIND FIRST int-preco-item
         WHERE int-preco-item.it-codigo = tt-preco-item-atu.it-codigo
           AND int-preco-item.cod-refer = tt-preco-item-atu.cod-refer
           AND int-preco-item.nr-tabpre = tt-preco-item-atu.nr-tabpre
           AND int-preco-item.dt-inival = tt-preco-item-atu.dt-inival
           AND int-preco-item.quant-min = tt-preco-item-atu.quant-min NO-LOCK NO-ERROR.
    
    IF AVAILABLE int-preco-item THEN
        ASSIGN tt-preco-item.preco-unico = int-preco-item.preco-unico
               tt-preco-item.pma         = int-preco-item.pma
               tt-preco-item.pmd         = int-preco-item.pmd.
END.

if "{1}" = "Tb-preco"
then do: 

    CREATE tt-tb-preco.
    ASSIGN tt-tb-preco.nr-tabpre = tt-tb-preco-atu.nr-tabpre
           tt-tb-preco.descricao = tt-tb-preco-atu.descricao
           tt-tb-preco.dt-inival = tt-tb-preco-atu.dt-inival
           tt-tb-preco.dt-fimval = tt-tb-preco-atu.dt-fimval
           tt-tb-preco.situacao  = tt-tb-preco-atu.situacao 
           tt-tb-preco.mo-codigo = STRING(tt-tb-preco-atu.mo-codigo).
END.

if "{1}" = "Cont-emit"
then do: 

    CREATE tt-cont-emit.

    FIND FIRST int-emitente WHERE 
               int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
               
    IF AVAILABLE int-emitente         AND
       int-emitente.cod-emitente <> 0 AND
       int-emitente.vl-guid <> "":U   AND
       int-emitente.vl-guid <> ?      THEN DO:
        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-cont-emit)
               tt-atributo.nome-campo   = "cod-emitente":U
               tt-atributo.nome-atrib   = "crmid":U
               tt-atributo.vl-atrib     = int-emitente.vl-guid.
    END.

    FIND FIRST int-cont-emit
        WHERE int-cont-emit.cod-emitente = tt-cont-emit-atu.cod-emitente
          AND int-cont-emit.sequencia    = tt-cont-emit-atu.sequencia NO-LOCK NO-ERROR.
      
    IF AVAILABLE int-cont-emit       AND
       int-cont-emit.vl-guid <> "":U AND
       int-cont-emit.vl-guid <> ?    THEN DO:
        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-cont-emit)
               tt-atributo.nome-campo   = "new_chaveintegracao":U
               tt-atributo.nome-atrib   = "crmid":U
               tt-atributo.vl-atrib     = int-cont-emit.vl-guid.
    END.

    ASSIGN tt-cont-emit.cod-emitente        = tt-cont-emit-atu.cod-emitente
           tt-cont-emit.sequencia           = tt-cont-emit-atu.sequencia
           tt-cont-emit.nome                = tt-cont-emit-atu.nome
           
           tt-cont-emit.cargo               = tt-cont-emit-atu.cargo
           tt-cont-emit.area                = tt-cont-emit-atu.area
           tt-cont-emit.telefone            = tt-cont-emit-atu.telefone
           tt-cont-emit.ramal               = substring(tt-cont-emit-atu.ramal,1,5)
           tt-cont-emit.telefax             = tt-cont-emit-atu.telefax
           tt-cont-emit.ramal-fax           = substring(tt-cont-emit-atu.ramal-fax,1,5)
           tt-cont-emit.e-mail              = substring(tt-cont-emit-atu.e-mail,1,40)
           tt-cont-emit.observacao          = tt-cont-emit-atu.observacao
           tt-cont-emit.identific             = tt-cont-emit-atu.identific
           tt-cont-emit.new_exporta_crm       = "":U
           tt-cont-emit.new_chaveintegracao   = TRIM(STRING(tt-cont-emit-atu.cod-emitente)) + ",":U + TRIM(STRING(tt-cont-emit-atu.sequencia))
           tt-cont-emit.new_mensagem          = ""
           tt-cont-emit.new_status_integracao = "Integrado com sucesso.":U.
           
     if tt-cont-emit.area = "" then 
        assign tt-cont-emit.area = "a classificar".      
               
end.      

if "{1}" = "Loc-entr"
then do:

    CREATE tt-loc-entr.

    CREATE tt-atributo.
    ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
           tt-atributo.nome-campo   = "nome-abrev":U
           tt-atributo.nome-atrib   = "entity":U
           tt-atributo.vl-atrib     = "account":U.

    CREATE tt-atributo.
    ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
           tt-atributo.nome-campo   = "nome-abrev":U
           tt-atributo.nome-atrib   = "keyfield":U
           tt-atributo.vl-atrib     = "accountnumber":U.

    FIND FIRST int-emitente
        WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF AVAILABLE int-emitente       AND
       int-emitente.vl-guid <> "":U AND
       int-emitente.vl-guid <> ?    THEN DO:
        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
               tt-atributo.nome-campo   = "nome-abrev":U
               tt-atributo.nome-atrib   = "crmid":U
               tt-atributo.vl-atrib     = int-emitente.vl-guid.
    END.
                 
    FIND FIRST int-loc-entr  WHERE 
               int-loc-entr.nome-abrev  = tt-loc-entr-atu.nome-abrev AND 
               int-loc-entr.cod-entrega = tt-loc-entr-atu.cod-entrega NO-LOCK NO-ERROR.

    IF AVAILABLE int-loc-entr       AND
       int-loc-entr.vl-guid <> "":U AND
       int-loc-entr.vl-guid <> ?    THEN DO:
           
        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
               tt-atributo.nome-campo   = "new_chaveintegracao":U
               tt-atributo.nome-atrib   = "crmid":U
               tt-atributo.vl-atrib     = int-loc-entr.vl-guid.
    END.
   
    ASSIGN tt-loc-entr.nome-abrev          = emitente.cod-emitente
           tt-loc-entr.cod-entrega         = tt-loc-entr-atu.cod-entrega.
           
    IF AVAIL int-loc-entr AND
       int-loc-entr.endereco-completo <> "" THEN
        ASSIGN tt-loc-entr.endereco        = SUBSTRING(tt-loc-entr-atu.endereco,1,80).
    ELSE
        ASSIGN tt-loc-entr.endereco        = SUBSTRING(tt-loc-entr-atu.endereco,1,40).

    ASSIGN tt-loc-entr.bairro              = substring(tt-loc-entr-atu.bairro,1,30)
           tt-loc-entr.cidade              = substring(tt-loc-entr-atu.cidade,1,25)
           tt-loc-entr.estado              = tt-loc-entr-atu.estado
           tt-loc-entr.cep                 = tt-loc-entr-atu.cep
           tt-loc-entr.caixa-postal        = tt-loc-entr-atu.caixa-postal
           tt-loc-entr.pais                = tt-loc-entr-atu.pais
           tt-loc-entr.cgc                 = tt-loc-entr-atu.cgc
           tt-loc-entr.ins-estadual        = tt-loc-entr-atu.ins-estadual
           tt-loc-entr.obs-entrega         = tt-loc-entr-atu.obs-entrega
           tt-loc-entr.cod-tip-ent         = tt-loc-entr-atu.cod-tip-ent               
           tt-loc-entr.e-mail              = substring(tt-loc-entr-atu.e-mail,1,40)
           tt-loc-entr.cod-tax             = tt-loc-entr-atu.cod-tax
           tt-loc-entr.addresstypecode     = 1
           tt-loc-entr.objecttypecode      = "account":U
           tt-loc-entr.new_exporta_erp     = "":U
           tt-loc-entr.new_chaveintegracao = TRIM(STRING(emitente.cod-emitente)) + ",":U + TRIM(STRING(tt-loc-entr-atu.cod-entrega))
           tt-loc-entr.new_mensagem        = "":U.

    ASSIGN tt-loc-entr.endereco = TRIM(ENTRY(1, tt-loc-entr-atu.endereco, ",":U)).

    IF NUM-ENTRIES(tt-loc-entr-atu.endereco, ",":U) >= 2 THEN DO:
        IF NUM-ENTRIES(TRIM(ENTRY(2, tt-loc-entr-atu.endereco, ",":U)), "-":U) >= 2 THEN
            ASSIGN tt-loc-entr.new_numero_endereco = TRIM(ENTRY(1, TRIM(ENTRY(2, tt-loc-entr-atu.endereco, ",":U)), "-":U)).
        ELSE
            ASSIGN tt-loc-entr.new_numero_endereco = TRIM(ENTRY(2, tt-loc-entr-atu.endereco, ",":U)).
    END.

    IF NUM-ENTRIES(tt-loc-entr-atu.endereco, "-":U) >= 2 THEN
        ASSIGN tt-loc-entr.line3 = TRIM(ENTRY(NUM-ENTRIES(tt-loc-entr-atu.endereco, "-":U), tt-loc-entr-atu.endereco, "-":U)).


    FIND FIRST param-global NO-LOCK NO-ERROR.

    CASE emitente.natureza:
        WHEN 1 THEN
            ASSIGN tt-loc-entr.cgc = STRING(tt-loc-entr.cgc, param-global.formato-id-pessoal).
        WHEN 2 THEN
            ASSIGN tt-loc-entr.cgc = STRING(tt-loc-entr.cgc, param-global.formato-id-federal).
        WHEN 3 THEN
            ASSIGN tt-loc-entr.cep = tt-loc-entr-atu.zip-code.
    END CASE.

end. 

if "{1}" = "Repres"
then do:

    CREATE tt-repres.
    ASSIGN tt-repres.cod-rep    = tt-repres-atu.cod-rep   
           tt-repres.nome       = tt-repres-atu.nome      
           tt-repres.nome-abrev = tt-repres-atu.nome-abrev
           tt-repres.natureza   = tt-repres-atu.natureza  
           tt-repres.cep        = tt-repres-atu.cep       
           tt-repres.endereco   = tt-repres-atu.endereco  
           tt-repres.bairro     = tt-repres-atu.bairro    
           tt-repres.cidade     = tt-repres-atu.cidade    
           tt-repres.estado     = tt-repres-atu.estado    
           tt-repres.pais       = tt-repres-atu.pais      
           tt-repres.telefone   = tt-repres-atu.telefone[1]
           tt-repres.e-mail     = tt-repres-atu.e-mail    
           tt-repres.home-page  = tt-repres-atu.home-page 
           tt-repres.state      = tt-repres-atu.ind-situacao.    
end.
        
if "{1}" = "Portador"
then do:
    CREATE tt-portador.
    ASSIGN tt-portador.cod-portador = tt-portador-atu.cod-portador
           tt-portador.nome         = tt-portador-atu.nome.
end.        
        
if "{1}" = "Receita-Padrao"
then do:
   CREATE tt-receita-padrao.
   ASSIGN tt-receita-padrao.tp-codigo = tt-receita-padrao-atu.tp-codigo
          tt-receita-padrao.descricao = tt-receita-padrao-atu.descricao.
end.               
        
if "{1}" = "Cond-Pagto"
then do:
    FIND FIRST int-cond-pagto NO-LOCK
        WHERE  int-cond-pagto.cod-cond-pag = tt-cond-pagto-atu.cod-cond-pag NO-ERROR.

    CREATE tt-cond-pagto.
    ASSIGN tt-cond-pagto.cod-cond-pag = tt-cond-pagto-atu.cod-cond-pag
           tt-cond-pagto.descricao    = tt-cond-pagto-atu.descricao
           tt-cond-pagto.num-parcelas = tt-cond-pagto-atu.num-parcelas
           tt-cond-pagto.per-des-pgan = tt-cond-pagto-atu.per-des-pgan.

    IF AVAIL int-cond-pagto THEN
        IF  int-cond-pagto.ativa = YES
        AND SUBSTRING(int-cond-pagto.char-1,7,1) = "S" THEN
            ASSIGN tt-cond-pagto.ind-situacao = 0.
        ELSE
            ASSIGN tt-cond-pagto.ind-situacao = 1.
    ELSE
        ASSIGN tt-cond-pagto.ind-situacao = 0.

    ASSIGN tt-cond-pagto.new_suppliercard = IF AVAILABLE int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = 'S' THEN YES ELSE NO.

end.           
    
if "{1}" = "CEP"
then do:

    CREATE tt-cep.
    ASSIGN tt-cep.cep                 = tt-cep-atu.cep           
           tt-cep.bairro-ini          = tt-cep-atu.bairro-ini
           tt-cep.bairro-fin          = tt-cep-atu.bairro-fin
           tt-cep.localidade          = tt-cep-atu.localidade
           tt-cep.uf                  = tt-cep-atu.uf
           tt-cep.new_chaveintegracao = string(tt-cep-atu.cep).  

    assign tt-cep.nome-complto = trim(string(tt-cep-atu.tipo-log))      + " " +  
                                 trim(string(tt-cep-atu.preposicao))    + " " +
                                 trim(string(tt-cep-atu.tit-pat-log))   + " " + 
                                 trim(string(tt-cep-atu.nome-log))      + " " + 
                                 trim(string(tt-cep-atu.nr-lote-ini))   + " " +
                                 trim(string(tt-cep-atu.nome-complto))  + " " +
                                 trim(string(tt-cep-atu.nr-complto))    + " " +
                                 trim(string(tt-cep-atu.nome-complto2)) + " " +
                                 trim(string(tt-cep-atu.nr-complto2)).  
end.
        
if "{1}" = "Transporte"
then do:

    CREATE tt-transportadora.
    ASSIGN tt-transportadora.cod-transp = tt-transporte-atu.cod-transp
           tt-transportadora.nome       = tt-transporte-atu.nome      
           tt-transportadora.nome-abrev = tt-transporte-atu.nome-abrev.   
             
end.

if "{1}" = "Canal-venda"
then do:
    CREATE tt-canal-venda.
    ASSIGN tt-canal-venda.cod-canal-venda = tt-canal-venda-atu.cod-canal-venda
           tt-canal-venda.descricao       = tt-canal-venda-atu.descricao.
   
end. 

if "{1}" = "Gr-Cli"
then do:
   CREATE tt-gr-cli.
   ASSIGN tt-gr-cli.cod-gr-cli = tt-gr-cli-atu.cod-gr-cli
          tt-gr-cli.descricao  = tt-gr-cli-atu.descricao.

end.

if "{1}" = "Cidade"
then do:

   CREATE tt-cidade.
   ASSIGN tt-cidade.cidade = tt-cidade-atu.cidade
          tt-cidade.estado = tt-cidade-atu.pais + "," + tt-cidade-atu.estado
          tt-cidade.ibge   = tt-cidade-atu.int-2
          tt-cidade.NEW_chave_integracao = tt-cidade-atu.cidade + "," + tt-cidade-atu.estado + "," + tt-cidade-atu.pais.
end.

if "{1}" = "uf"
then do:

   CREATE tt-unid-feder.
   ASSIGN tt-unid-feder.estado               = tt-unid-feder-atu.estado
          tt-unid-feder.pais                 = tt-unid-feder-atu.pais
          tt-unid-feder.no-estado            = tt-unid-feder-atu.no-estado
          tt-unid-feder.new_chave_integracao = tt-unid-feder-atu.pais + "," + tt-unid-feder-atu.estado.
          
end.

if "{1}" = "Crm-Relacionamento-Cliente"
then do:
          
        FIND FIRST unid-comerc NO-LOCK
            WHERE  unid-comerc.cd-unid-comerc = INT(tt-relacionamento-cliente-atu.cd-unid-negoc) NO-ERROR.
        IF  NOT AVAIL unid-comer THEN
            NEXT.

        IF  unid-comerc.ds-unid-comerc = "ICEL" OR
            unid-comerc.ds-unid-comerc = "IADM" THEN
            NEXT.

        CREATE tt-relacionamento-cliente.

        IF tt-relacionamento-cliente-atu.vl-guid <> "":U AND
           tt-relacionamento-cliente-atu.vl-guid <> ?    THEN DO:
            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-relacionamento-cliente)
                   tt-atributo.nome-campo   = "new_chaveintegracao":U
                   tt-atributo.nome-atrib   = "crmid":U
                   tt-atributo.vl-atrib     = tt-relacionamento-cliente-atu.vl-guid.
        END. 

        FIND FIRST crm-categoria NO-LOCK WHERE
                   crm-categoria.cd-categoria = tt-relacionamento-cliente-atu.cd-categoria NO-ERROR.
        IF AVAIL crm-categoria THEN
           ASSIGN tt-relacionamento-cliente.cd-categoria = crm-categoria.cd-categoria.
        ELSE 
           ASSIGN tt-relacionamento-cliente.cd-categoria = 2.

        ASSIGN tt-relacionamento-cliente.cod-emitente          = tt-relacionamento-cliente-atu.cod-emitente
               tt-relacionamento-cliente.seq                   = tt-relacionamento-cliente-atu.seq
               tt-relacionamento-cliente.cod-rep               = tt-relacionamento-cliente-atu.cod-rep
               tt-relacionamento-cliente.cd-unid-negoc         = unid-comerc.ds-unid-comerc 
               tt-relacionamento-cliente.new_status_integracao = "Integrado com Sucesso."
               tt-relacionamento-cliente.new_exporta_ERP       = "":U
               tt-relacionamento-cliente.new_chaveintegracao   = STRING(tt-relacionamento-cliente-atu.cod-emitente) + ",":U + STRING(tt-relacionamento-cliente-atu.seq)
               tt-relacionamento-cliente.new_mensagem          = "":U
               tt-relacionamento-cliente.new_nome              = unid-comerc.ds-unid-comerc
               tt-relacionamento-cliente.dt-vigencia-ini       = tt-relacionamento-cliente-atu.dt-vigencia-ini
               tt-relacionamento-cliente.dt-vigencia-fim       = tt-relacionamento-cliente-atu.dt-vigencia-fim.      

       
               
end.

IF "{1}" = "Item" 
THEN DO:

   CREATE tt-item.
   ASSIGN tt-item.it-codigo             = tt-item-atu.it-codigo
          tt-item.desc-item             = tt-item-atu.desc-item
          tt-item.un                    = tt-item-atu.un
          tt-item.compr-fabric          = tt-item-atu.compr-fabric
          tt-item.ge-codigo             = tt-item-atu.ge-codigo
          tt-item.fm-codigo             = tt-item-atu.fm-codigo
          tt-item.fm-cod-com            = tt-item-atu.fm-cod-com
          tt-item.defaultuomscheduleid  = "Unidade Padr∆o":U
          tt-item.cod-obsoleto          = 0 /*IF tt-item-atu.cod-obsoleto = 1 THEN 0 ELSE 1*/
          tt-item.pricelevelid          = "CRM Real":U
          tt-item.transactioncurrencyid = "Real":U 
          tt-item.unidade               = SUBSTRING(tt-item-atu.fm-cod-com,1,2)
          tt-item.segmento              = SUBSTRING(tt-item-atu.fm-cod-com,1,4)
          tt-item.familia               = SUBSTRING(tt-item-atu.fm-cod-com,1,5)
          tt-item.subfamilia            = SUBSTRING(tt-item-atu.fm-cod-com,1,7)
          tt-item.origem                = SUBSTRING(tt-item-atu.fm-cod-com,1,8).


     /* Tabela de preáo padr∆o do item (Vazia) */
   CREATE tt-productpricelevel.
   ASSIGN tt-productpricelevel.pricelevelid        = "CRM Real":U
          tt-productpricelevel.productidname       = "CRM Real,":U + tt-item-atu.it-codigo
          tt-productpricelevel.productid           = tt-item-atu.it-codigo
          tt-productpricelevel.uomid               = tt-item-atu.un
          tt-productpricelevel.quantitysellingcode = 1
          tt-productpricelevel.pricingmethodcode   = 1
          tt-productpricelevel.amount              = 1.

   CREATE tt-productpricelevel.
   ASSIGN tt-productpricelevel.pricelevelid        = "CRM Dolar":U
          tt-productpricelevel.productidname       = "CRM Dolar,":U + tt-item-atu.it-codigo
          tt-productpricelevel.productid           = tt-item-atu.it-codigo
          tt-productpricelevel.uomid               = tt-item-atu.un
          tt-productpricelevel.quantitysellingcode = 1
          tt-productpricelevel.pricingmethodcode   = 1
          tt-productpricelevel.amount              = 1.
END.

IF "{1}" = "Familia" 
THEN DO:

   CREATE tt-familia-material.
   ASSIGN tt-familia-material.fm-codigo = tt-familia-material-atu.fm-codigo
          tt-familia-material.descricao = tt-familia-material-atu.descricao.

END.

IF "{1}" = "Fam-comerc" 
THEN DO:
   CREATE tt-familia-comercial.
   ASSIGN tt-familia-comercial.fm-cod-com = tt-familia-comercial-atu.fm-cod-com
          tt-familia-comercial.descricao  = tt-familia-comercial-atu.descricao.
END.

IF "{1}" = "new_unidade_familia" 
THEN DO:
    create tt-new_unidade_familia.
    ASSIGN tt-new_unidade_familia.codigo      = tt-new_unidade_familia-atu.codigo   
           tt-new_unidade_familia.descricao   = tt-new_unidade_familia-atu.descricao.
END.
IF "{1}" = "new_segmento" 
THEN DO:
        create tt-new_segmento.
        ASSIGN tt-new_segmento.unidade      = tt-new_segmento-atu.unidade 
               tt-new_segmento.codigo       = tt-new_segmento-atu.codigo
               tt-new_segmento.descricao    = tt-new_segmento-atu.descricao.   
END.
IF "{1}" = "new_familia" 
THEN DO:
        create tt-new_familia.
        ASSIGN tt-new_familia.codigo       = tt-new_familia-atu.codigo
               tt-new_familia.segmento     = tt-new_familia-atu.segmento
               tt-new_familia.descricao    = tt-new_familia-atu.descricao.   
END.
IF "{1}" = "new_subfamilia" 
THEN DO:
        create tt-new_subfamilia.
        ASSIGN tt-new_subfamilia.codigo       = tt-new_subfamilia-atu.codigo
               tt-new_subfamilia.familia      = tt-new_subfamilia-atu.familia
               tt-new_subfamilia.descricao    = tt-new_subfamilia-atu.descricao.   
END.
        IF "{1}" = "new_origem" 
THEN DO:
        create tt-new_origem.
        ASSIGN tt-new_origem.codigo       = tt-new_origem-atu.codigo
               tt-new_origem.subfamilia   = tt-new_origem-atu.subfamilia
               tt-new_origem.descricao    = tt-new_origem-atu.descricao.   
END.


IF "{1}" = "Estrutura" 
THEN DO:
    
  CREATE tt-estrutura.
  ASSIGN tt-estrutura.it-codigo                 = tt-estrutura-atu.it-codigo
         tt-estrutura.sequencia                 = tt-estrutura-atu.sequencia
         tt-estrutura.es-codigo                 = tt-estrutura-atu.es-codigo
         tt-estrutura.fantasma                  = tt-estrutura-atu.fantasma
         tt-estrutura.revisao                   = tt-estrutura-atu.revisao
         tt-estrutura.serie-inicia              = tt-estrutura-atu.serie-inicia
         tt-estrutura.serie-final               = tt-estrutura-atu.serie-final
         tt-estrutura.op-codigo                 = tt-estrutura-atu.op-codigo
         tt-estrutura.local-montag              = tt-estrutura-atu.local-montag
         tt-estrutura.fator-perda               = tt-estrutura-atu.fator-perda
         tt-estrutura.proporcao                 = tt-estrutura-atu.proporcao
         tt-estrutura.quant-usada               = tt-estrutura-atu.quant-usada
         tt-estrutura.data-inicio               = tt-estrutura-atu.data-inicio
         tt-estrutura.data-termino              = tt-estrutura-atu.data-termino
         tt-estrutura.observacao                = tt-estrutura-atu.observacao
         tt-estrutura.var-propor                = tt-estrutura-atu.var-propor
         tt-estrutura.cod-roteiro               = tt-estrutura-atu.cod-roteiro
         tt-estrutura.conc-max                  = tt-estrutura-atu.conc-max
         tt-estrutura.conc-min                  = tt-estrutura-atu.conc-min
         tt-estrutura.concentracao              = tt-estrutura-atu.concentracao
         tt-estrutura.rendimento                = tt-estrutura-atu.rendimento
         tt-estrutura.cod-depos                 = tt-estrutura-atu.cod-depos
         tt-estrutura.reap-desmont              = tt-estrutura-atu.reap-desmont
         tt-estrutura.log-todas-ref-item        = tt-estrutura-atu.log-todas-ref-item
         tt-estrutura.log-ref-estrut-disponivel = tt-estrutura-atu.log-ref-estrut-disponivel
         tt-estrutura.qtd-item                  = tt-estrutura-atu.qtd-item
         tt-estrutura.qtd-compon                = tt-estrutura-atu.qtd-compon
         tt-estrutura.prop-proc                 = tt-estrutura-atu.prop-proc
         tt-estrutura.NAME                      = STRING(tt-estrutura-atu.es-codigo)
         tt-estrutura.new_chaveintegracao       = STRING(tt-estrutura-atu.it-codigo) + ",":U + STRING(tt-estrutura-atu.sequencia) + ",":U + STRING(tt-estrutura-atu.es-codigo).
END.

IF "{1}" =  "Grup-estoque" 
THEN DO:

   CREATE tt-grup-estoque.
   ASSIGN tt-grup-estoque.ge-codigo = tt-grup-estoque-atu.ge-codigo
          tt-grup-estoque.descricao = tt-grup-estoque-atu.descricao.

END.

IF "{1}" = "Natur-oper" 
THEN DO:
           
    CREATE tt-natur-oper.
    ASSIGN tt-natur-oper.nat-operacao = tt-natur-oper-atu.nat-operacao
           tt-natur-oper.tipo         = tt-natur-oper-atu.tipo
           tt-natur-oper.denominacao  = string(tt-natur-oper-atu.nat-operacao) + " - " + tt-natur-oper-atu.denominacao
           tt-natur-oper.nat-ativa    = tt-natur-oper-atu.nat-ativa.
END.

IF "{1}" = "Mensagem" 
THEN DO:
   CREATE tt-mensag-crm.
   ASSIGN tt-mensag-crm.cod-mensagem = tt-mensagem-atu.cod-mensagem
          tt-mensag-crm.descricao    = tt-mensagem-atu.descricao
          tt-mensag-crm.texto-mensag = substring(tt-mensagem-atu.texto-mensag,1,2000).
END.

IF "{1}" = "Estabelec" 
THEN DO:
   CREATE tt-estabelec.
   ASSIGN tt-estabelec.cod-estabel             = tt-estabelec-atu.cod-estabel
          tt-estabelec.nome                    = tt-estabelec-atu.nome-abrev
          tt-estabelec.NEW_razao_social        = tt-estabelec-atu.nome
          tt-estabelec.id-ativo                = tt-estabelec-atu.id-ativo
          tt-estabelec.new_cnpj                = tt-estabelec-atu.cgc                  
          tt-estabelec.new_inscricao_estadual  = tt-estabelec-atu.ins-estadual         
          tt-estabelec.new_endereco            = tt-estabelec-atu.endereco             
          tt-estabelec.new_cidade              = tt-estabelec-atu.cidade               
          tt-estabelec.new_cep                 = tt-estabelec-atu.cep                  
          tt-estabelec.new_uf                  = tt-estabelec-atu.estado.              
       .
END.

IF "{1}" = "Tab-finan" 
THEN DO:
   
   CREATE tt-tab-finan.
   ASSIGN tt-tab-finan.nr-tab-finan = tt-tab-finan-atu.nr-tab-finan
          tt-tab-finan.dt-ini-val   = tt-tab-finan-atu.dt-ini-val
          tt-tab-finan.dt-fim-val   = tt-tab-finan-atu.dt-fim-val.
END.

IF "{1}" = "Ind-tab-finan" 
THEN DO:

 CREATE tt-ind-tab-finan.
 ASSIGN tt-ind-tab-finan.nr-tab-finan        = tt-ind-tab-finan-atu.nr-tab-finan
        tt-ind-tab-finan.nr-ind-finan        = tt-ind-tab-finan-atu.nr-ind-finan
        tt-ind-tab-finan.tab-dia-fin         = tt-ind-tab-finan-atu.tab-dia-fin
        tt-ind-tab-finan.tab-ind-fin         = tt-ind-tab-finan-atu.tab-ind-fin
        tt-ind-tab-finan.new_chaveintegracao = STRING(tt-ind-tab-finan-atu.nr-tab-finan) + ",":U + STRING(tt-ind-tab-finan-atu.nr-ind-finan).

END.

IF "{1}" = "Rota" 
THEN DO:
   CREATE tt-rota.
   ASSIGN tt-rota.cod-rota  = tt-rota-atu.cod-rota
          tt-rota.descricao = tt-rota-atu.descricao
          tt-rota.roteiro   = tt-rota-atu.roteiro.
END.

IF "{1}" =  "Crm-categoria" 
THEN DO:

   CREATE tt-crm-categoria.
   ASSIGN tt-crm-categoria.cd-categoria  = tt-crm-categoria-atu.cd-categoria
          tt-crm-categoria.ds-categoria  = tt-crm-categoria-atu.ds-categoria.
END.

IF "{1}" =  "Crm-categ-un" 
THEN DO:
                
    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = INT(tt-crm-categ-un-atu.cd-unid-neg) NO-ERROR.
    IF  NOT AVAIL unid-comerc THEN
        NEXT.
      
    find first crm-categoria no-lock where
               crm-categoria.cd-categoria = tt-crm-categ-un-atu.cd-categoria no-error.
    
    CREATE tt-crm-categ-un.
    ASSIGN tt-crm-categ-un.cd-categoria        = string(tt-crm-categ-un-atu.cd-categoria) 
           tt-crm-categ-un.cd-unid-negoc       = unid-comerc.ds-unid-comerc  
           tt-crm-categ-un.NEW_name            = string(unid-comerc.ds-unid-comerc)  + " x " + crm-categoria.ds-categoria 
           tt-crm-categ-un.NEW_chaveintegracao = string(tt-crm-categ-un-atu.cd-categoria) + "," + STRING(unid-comerc.ds-unid-comerc). 

END.

ASSIGN pContaLinhasTrace                      = pContaLinhasTrace + 1.
