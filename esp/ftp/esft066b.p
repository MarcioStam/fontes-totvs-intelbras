DEF INPUT  PARAM pRowNFE AS ROWID.

{utp/ut-glob.i}

{esp/ftp/esft066.i}

def temp-table tt-erros-aux
    field seq-tt-docto  as integer
    field cod-estabel   like nota-fiscal.cod-estabel
    field serie         like nota-fiscal.serie
    field nr-nota-fis   like nota-fiscal.nr-nota-fis.

form                             
    tt-erros-aux.cod-estabel
    tt-erros-aux.serie
    tt-erros-aux.nr-nota
    tt-erros.tabela      label '    '
    tt-erros.cod-erro    label '    '
    tt-erros.desc-erro   label '    ' format "x(70)"
    with width 130 frame f-erro stream-io.         

find first param-global no-lock no-error.
find first para-fat no-lock no-error.

DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.

FOR LAST nota-fiscal EXCLUSIVE-LOCK
    where rowid(nota-fiscal) = pRowNFE,
    FIRST natur-oper OF nota-fiscal NO-LOCK.

    FIND LAST b-nota-fiscal NO-LOCK
        WHERE b-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
          AND b-nota-fiscal.serie       = '900' NO-ERROR.

    create tt-docto.
    assign tt-docto.fat-nota         = if para-fat.ind-pro-fat /* Proc Geracao Fatura */
                                       then 2 /* Nota   */
                                       else 1 /* Fatura */
           tt-docto.ind-tip-nota     = 11     /* Importada */
           tt-docto.nr-prog          = 2015
           tt-docto.seq-tt-docto     = 1
           tt-docto.cod-des-merc     = nota-fiscal.cod-des-merc
           tt-docto.cod-estabel      = nota-fiscal.cod-estabel     
           /*tt-docto.dt-nf-ent-fut    = nota-fiscal.dt-nf-ent-fut   */
           tt-docto.estado           = nota-fiscal.estado          
           tt-docto.nat-operacao     = nota-fiscal.nat-operacao    
           tt-docto.cod-emitente     = nota-fiscal.cod-emitente    
           tt-docto.nr-nota          = STRING(INT(b-nota-fiscal.nr-nota-fis) + 1)
           tt-docto.serie            = '900'
           tt-docto.pais             = nota-fiscal.pais            
           /*tt-docto.perc-embalagem   = nota-fiscal.perc-embalagem
           tt-docto.perc-frete       = nota-fiscal.perc-frete      
           tt-docto.perc-desco1      = nota-fiscal.perc-desco1     
           tt-docto.perc-desco2      = nota-fiscal.perc-desco2     
           tt-docto.perc-seguro      = nota-fiscal.perc-seguro */
           tt-docto.peso-bru-tot     = nota-fiscal.peso-bru-tot    
           tt-docto.peso-liq-tot     = nota-fiscal.peso-liq-tot    
           tt-docto.vl-embalagem     = nota-fiscal.vl-embalagem    
           tt-docto.vl-frete         = nota-fiscal.vl-frete        
           tt-docto.vl-mercad        = nota-fiscal.vl-mercad       
           tt-docto.vl-seguro        = nota-fiscal.vl-seguro       
           tt-docto.vl-desconto      = nota-fiscal.vl-desconto     
           /*tt-docto.vl-desconto-perc = nota-fiscal.vl-desconto-perc*/
           tt-docto.cod-canal-venda  = nota-fiscal.cod-canal-venda 
           tt-docto.bairro           = nota-fiscal.bairro          
           tt-docto.cep              = nota-fiscal.cep             
           tt-docto.cgc              = nota-fiscal.cgc             
           tt-docto.cidade           = nota-fiscal.cidade          
           tt-docto.cidade-cif       = nota-fiscal.cidade-cif      
           tt-docto.cod-cond-pag     = nota-fiscal.cod-cond-pag    
           tt-docto.cod-entrega      = nota-fiscal.cod-entrega     
           /*tt-docto.dt-base-dup      = nota-fiscal.dt-base-dup */
           tt-docto.dt-emis-nota     = nota-fiscal.dt-emis-nota
           tt-docto.endereco         = nota-fiscal.endereco       
           tt-docto.ins-estadual     = nota-fiscal.ins-estadual   
           tt-docto.marca-volume     = nota-fiscal.marca-volume
           tt-docto.mo-codigo        = INT(nota-fiscal.mo-codigo)
           tt-docto.no-ab-reppri     = nota-fiscal.no-ab-reppri   
           tt-docto.nome-tr-red      = nota-fiscal.nome-tr-red    
           tt-docto.nome-transp      = nota-fiscal.nome-transp    
           tt-docto.nivel-rest       = nota-fiscal.nivel-rest     
           tt-docto.nr-fatura        = nota-fiscal.nr-fatura      
           tt-docto.nr-tabpre        = nota-fiscal.nr-tabpre      
           tt-docto.nr-volumes       = nota-fiscal.nr-volumes     
           tt-docto.pc-rest          = nota-fiscal.pc-rest        
           tt-docto.placa            = nota-fiscal.placa          
           /*tt-docto.serie-ent-fut    = nota-fiscal.serie-ent-fut  
           tt-docto.nr-nota-ent-fut  = nota-fiscal.nr-nota-ent-fut*/
           tt-docto.nr-siscomex      = nota-fiscal.nr-siscomex
           tt-docto.ind-lib-nota     = nota-fiscal.ind-lib-nota   
           tt-docto.cod-rota         = nota-fiscal.cod-rota       
           tt-docto.cod-msg          = nota-fiscal.cod-mensagem
           tt-docto.vl-taxa-exp      = nota-fiscal.vl-taxa-exp    
           tt-docto.nr-proc-exp      = nota-fiscal.nr-proc-exp    
           tt-docto.nr-tab-finan     = nota-fiscal.nr-tab-finan   
           tt-docto.nr-ind-finan     = nota-fiscal.nr-ind-finan   
           tt-docto.cod-portador     = nota-fiscal.cod-portador   
           tt-docto.modalidade       = nota-fiscal.modalidade     
           /*tt-docto.nr-nota-base     = nota-fiscal.nr-nota-base   
           tt-docto.serie-base       = nota-fiscal.serie-base     */
           tt-docto.uf-placa         = nota-fiscal.uf-placa       
           tt-docto.dt-embarque      = nota-fiscal.dt-embarque    
           /*tt-docto.serie-dif        = nota-fiscal.serie-dif      
           tt-docto.nr-nota-dif      = nota-fiscal.nr-nota-dif    
           tt-docto.perc-acres-dif   = nota-fiscal.perc-acres-dif 
           tt-docto.vl-acres-dif     = nota-fiscal.vl-acres-dif   
           tt-docto.vl-taxa-exp-dif  = nota-fiscal.vl-taxa-exp-dif*/
           tt-docto.cond-redespa     = nota-fiscal.cond-redespa   
           tt-docto.obs              = nota-fiscal.observ-nota.

    assign tt-docto.esp-docto = if  avail natur-oper then {ininc/i03in218.i 06 natur-oper.especie-doc} else 22 .                              

    /*assign  
        tt-docto.dt-cancela       = date(substr(c-linha,4690,8))
        tt-docto.motvo-cance      = substr(c-linha,4698,2000).*/

    /* Tratamento Faturamento em Outras Moedas */
    &if defined(bf_dis_fat_moeda) &then
        if  para-fat.ind-legislacao  = 1 then 
            assign substring(tt-docto.char-1,21,5) = substring(nota-fiscal.char-1,21,5).
    &endif

    /************************************************************ 
    *  PrÇ-Processador para o m¢dulo de Descontos e Bonificaá∆o
    ************************************************************/
    &if defined (bf_dis_desc_bonif) &then
        create tt-docto-bn.                
        assign tt-docto-bn.cod-estabel                = nota-fiscal.cod-estabel
               tt-docto-bn.nr-nota                    = tt-docto.nr-nota
               tt-docto-bn.serie                      = tt-docto.serie
               tt-docto-bn.val-pct-desconto-tab-preco = nota-fiscal.val-pct-desconto-tab-preco
               tt-docto-bn.des-pct-desconto-inform    = nota-fiscal.des-pct-desconto-inform   
               tt-docto-bn.val-pct-desconto-total     = nota-fiscal.val-pct-desconto-total    
/*                tt-docto-bn.val-desconto-total         = nota-fiscal.val-desconto-total */
               tt-docto-bn.val-pct-desconto-valor     = nota-fiscal.val-pct-desconto-valor.
    &endif

    if tt-docto.dt-base-dup = ? then
        assign tt-docto.dt-base-dup = tt-docto.dt-emis-nota.

    FOR FIRST emitente FIELDS(nome-abrev) NO-LOCK
        where emitente.cod-emitente = tt-docto.cod-emitente.
        assign tt-docto.nome-abrev = emitente.nome-abrev.
    END.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK.
        RUN piCriarTTItem.
    END.


    FOR EACH Nota-trans OF nota-fiscal NO-LOCK.
        create tt-nota-trans.
        assign tt-nota-trans.seq-tt-docto  = 1
               tt-nota-trans.cod-estabel   = nota-trans.cod-estabel  
               tt-nota-trans.serie         = tt-docto.serie        
               tt-nota-trans.nr-nota-fis   = tt-docto.nr-nota
               tt-nota-trans.aliquota-icm  = nota-trans.aliquota-icm 
               tt-nota-trans.vl-bicms      = nota-trans.vl-bicms     
               tt-nota-trans.vl-servico    = nota-trans.vl-servico   
               tt-nota-trans.perc-red-base = nota-trans.perc-red-base
               tt-nota-trans.vl-icms       = nota-trans.vl-icms      
               tt-nota-trans.cod-mensagem  = nota-trans.cod-mensagem 
               tt-nota-trans.ind-cobranca  = nota-trans.ind-cobranca 
               /*tt-nota-trans.ind-icms-ret  = nota-trans.ind-icms-ret */
               tt-nota-trans.observacao    = nota-trans.observacao.
    END.

    EMPTY TEMP-TABLE tt-fat-duplic.
    DEFINE VARIABLE cont4 AS INTEGER     NO-UNDO.
    for each fat-duplic
        where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
          and fat-duplic.serie       = nota-fiscal.serie
          and fat-duplic.nr-fatura   = nota-fiscal.nr-fatura no-lock:

        ASSIGN cont4 = cont4 + 1.
        create tt-fat-duplic.
        assign tt-fat-duplic.seq-tt-fat-duplic = cont4
               tt-fat-duplic.seq-tt-docto      = 1
               tt-fat-duplic.cod-vencto        = fat-duplic.cod-vencto  
               tt-fat-duplic.dt-venciment      = fat-duplic.dt-venciment
               tt-fat-duplic.dt-desconto       = fat-duplic.dt-desconto 
               tt-fat-duplic.vl-desconto       = fat-duplic.vl-desconto 
               tt-fat-duplic.parcela           = fat-duplic.parcela     
               tt-fat-duplic.vl-parcela        = fat-duplic.vl-parcela  
               tt-fat-duplic.vl-comis          = fat-duplic.vl-comis    
               tt-fat-duplic.vl-acum-dup       = fat-duplic.vl-acum-dup 
               tt-fat-duplic.cod-esp           = fat-duplic.cod-esp.
    END.



       









    DEFINE VARIABLE cont5 AS INTEGER     NO-UNDO.
    for each fat-repre use-index ch-fatrep
        where fat-repre.cod-estabel = nota-fiscal.cod-estabel
          and fat-repre.serie       = nota-fiscal.serie
          and fat-repre.nr-fatura   = nota-fiscal.nr-fatura NO-LOCK,
        FIRST repres NO-LOCK
        WHERE repres.nome-abrev = fat-repre.nome-ab-rep:

        assign cont5 = cont5 + 1.
        create tt-fat-repre.
        assign tt-fat-repre.seq-tt-docto = 1
               tt-fat-repre.sequencia    = cont5
               tt-fat-repre.cod-rep      = repres.cod-rep    
               tt-fat-repre.nome-ab-rep  = fat-repre.nome-ab-rep
               tt-fat-repre.perc-comis   = fat-repre.perc-comis 
               tt-fat-repre.comis-emis   = fat-repre.comis-emis 
               /*tt-fat-repre.vl-comis     = fat-repre.vl-comis   */
               /*tt-fat-repre.vl-emis      = fat-repre.vl-emis*/.
               
    end.

    DEFINE VARIABLE cont6 AS INTEGER     NO-UNDO.
    FOR EACH nota-embal OF nota-fiscal NO-LOCK.
        assign cont6 = cont6 + 1.
        create tt-nota-embal.
        assign tt-nota-embal.seq-tt-docto      = 1
               tt-nota-embal.seq-tt-nota-embal = cont6
               tt-nota-embal.cod-estabel       = nota-embal.cod-estabel
               tt-nota-embal.serie             = tt-docto.serie      
               tt-nota-embal.nr-nota-fis       = tt-docto.nr-nota
               tt-nota-embal.sigla-emb         = nota-embal.sigla-emb  
               tt-nota-embal.qt-volumes        = nota-embal.qt-volumes 
               tt-nota-embal.desc-vol          = nota-embal.desc-vol   
               tt-nota-embal.narrativa         = nota-embal.narrativa.
    end.

    
    DEFINE VARIABLE cont2 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cont8 AS INTEGER     NO-UNDO.
    FOR EACH Fat-ser-lote OF nota-fiscal NO-LOCK,
        FIRST it-nota-fisc OF fat-ser-lote NO-LOCK,
        first item 
        where item.it-codigo = fat-ser-lote.it-codigo 
          and (item.politica = 5           /* Configurado */
            or item.politica = 6) no-lock: /* Composto    */ 

        find first tt-it-docto
             where tt-it-docto.cod-estabel     = fat-ser-lote.cod-estabel
             and   tt-it-docto.serie           = tt-docto.serie
             and   tt-it-docto.nr-nota         = tt-docto.nr-nota 
             and   tt-it-docto.nr-sequencia    = fat-ser-lote.nr-seq-fat
             and   tt-it-docto.nr-pedcli       = it-nota-fisc.nr-pedcli
             and   tt-it-docto.ind-componen    = 3
             and   tt-it-docto.calcula         = no
             and   tt-it-docto.baixa-estoq     = yes
             and   tt-it-docto.cod-refer       = fat-ser-lote.cod-refer
             and   tt-it-docto.it-codigo       = ITEM.it-codigo no-error.
        
        if  not avail tt-it-docto then do:
            create tt-it-docto.
            
            assign cont2                       = cont2  + 1
                   tt-it-docto.cod-estabel     = fat-ser-lote.cod-estabel
                   tt-it-docto.serie           = tt-docto.serie
                   tt-it-docto.nr-nota         = tt-docto.nr-nota 
                   tt-it-docto.nr-sequencia    = fat-ser-lote.nr-seq-fat
                   tt-it-docto.nr-pedcli       = it-nota-fisc.nr-pedcli
                   tt-it-docto.ind-componen    = 3
                   tt-it-docto.calcula         = no
                   tt-it-docto.seq-tt-it-docto = cont2 
                   tt-it-docto.baixa-estoq     = yes
                   tt-it-docto.cod-refer       = fat-ser-lote.cod-refer
                   tt-it-docto.nat-operacao    = it-nota-fisc.nat-operacao
                   tt-it-docto.un[1]           = it-nota-fisc.un[1]
                   tt-it-docto.it-codigo       = item.it-codigo.
        end.           

        if  avail tt-it-docto then 
            assign tt-it-docto.quantidade[1] = tt-it-docto.quantidade[1] + fat-ser-lote.qt-baixada[1].

        assign cont8 = cont8 + 1.
        create tt-saldo-estoq.
        assign tt-saldo-estoq.seq-tt-saldo-estoq = cont8
               tt-saldo-estoq.seq-tt-it-docto    = cont2
               tt-saldo-estoq.it-codigo          = fat-ser-lote.it-codigo   
               tt-saldo-estoq.cod-depos          = fat-ser-lote.cod-depos   
               tt-saldo-estoq.cod-localiz        = fat-ser-lote.cod-localiz 
               tt-saldo-estoq.lote               = fat-ser-lote.nr-serlote        
               tt-saldo-estoq.dt-vali-lote       = fat-ser-lote.dt-vali-lote
               tt-saldo-estoq.quantidade         = fat-ser-lote.qt-baixada[1].
    end.
    
    /*when '9' then do:  /* Registro 9 */
    
        assign cont9 = cont9 + 10.
        create tt-it-docto-imp.
        assign tt-it-docto-imp.nr-seq-imp      = cont9
               tt-it-docto-imp.seq-tt-it-docto = cont2
               tt-it-docto-imp.cod-taxa        = int(substr(c-linha,2,3))
               tt-it-docto-imp.tipo-tax        = int(substr(c-linha,5,2))
               tt-it-docto-imp.aliquota        = dec(substr(c-linha,7,5)) / 100
               tt-it-docto-imp.perc-redimp     = dec(substr(c-linha,12,7)) / 10000
               tt-it-docto-imp.conta-tax       = substr(c-linha,19,17)
               tt-it-docto-imp.vl-imposto      = dec(substr(c-linha,36,14)) / 100
               tt-it-docto-imp.vl-base-imp     = dec(substr(c-linha,50,14)) / 100.
        if tt-it-docto-imp.tipo-tax = 4 then  /* Ingressos brutos */
           assign tt-it-docto-imp.uf = tt-docto.estado.
        if tt-it-docto-imp.tipo-tax = 2
        or tt-it-docto-imp.tipo-tax = 3
        or tt-it-docto-imp.tipo-tax = 4 then
           assign tt-it-docto-imp.conta-percepcao = tt-it-docto-imp.conta-tax
                  tt-it-docto-imp.perc-percepcao  = tt-it-docto-imp.aliquota
                  tt-it-docto-imp.vl-percepcao    = tt-it-docto-imp.vl-imposto.
    end.*/





















END.

PROCEDURE piCriarTTItem.
    DEFINE VARIABLE cont2 AS INTEGER     NO-UNDO.

    assign cont2 = cont2 + 1.
    
    create tt-it-docto.
    assign tt-it-docto.calcula             = yes
           tt-it-docto.tipo-atend          = 1   /* Total */
           tt-it-docto.seq-tt-it-docto     = cont2 
           tt-it-docto.baixa-estoq         = it-nota-fisc.baixa-estoq    
           tt-it-docto.class-fiscal        = it-nota-fisc.class-fiscal   
           tt-it-docto.cod-estabel         = it-nota-fisc.cod-estabel    
           tt-it-docto.cod-refer           = it-nota-fisc.cod-refer      
           /*tt-it-docto.data-comp           = it-nota-fisc.data-comp      */
           tt-it-docto.it-codigo           = it-nota-fisc.it-codigo      
           tt-it-docto.nat-comp            = it-nota-fisc.nat-docum
           tt-it-docto.nat-operacao        = it-nota-fisc.nat-operacao   
           tt-it-docto.nr-nota             = tt-docto.nr-nota
           tt-it-docto.nr-sequencia        = it-nota-fisc.nr-seq-fat
           /*tt-it-docto.nro-comp            = it-nota-fisc.nro-comp       */
           tt-it-docto.per-des-item        = it-nota-fisc.per-des-item   
           tt-it-docto.peso-liq-it-inf     = it-nota-fisc.peso-liq-fat
           tt-it-docto.peso-embal-it       = it-nota-fisc.peso-bruto
           tt-it-docto.quantidade[1]       = it-nota-fisc.qt-faturada[1]  
           tt-it-docto.quantidade[2]       = it-nota-fisc.qt-faturada[2].

    assign /*tt-it-docto.seq-comp            = it-nota-fisc.seq-comp           */
           tt-it-docto.serie               = tt-docto.serie              
           /*tt-it-docto.serie-comp          = it-nota-fisc.serie-comp         */
           tt-it-docto.un[1]               = it-nota-fisc.un[1]              
           tt-it-docto.un[2]               = it-nota-fisc.un[2]              
           tt-it-docto.vl-despes-it        = it-nota-fisc.vl-despes-it       
           /*tt-it-docto.vl-embalagem        = it-nota-fisc.vl-embalagem       */
           /*tt-it-docto.vl-frete            = it-nota-fisc.vl-frete           */
           tt-it-docto.vl-merc-liq         = it-nota-fisc.vl-merc-liq        
           tt-it-docto.vl-merc-ori         = it-nota-fisc.vl-merc-ori        
           tt-it-docto.vl-merc-tab         = it-nota-fisc.vl-merc-tab        
           tt-it-docto.vl-preori           = it-nota-fisc.vl-preori          
           tt-it-docto.vl-pretab           = it-nota-fisc.vl-pretab          
           tt-it-docto.vl-preuni           = it-nota-fisc.vl-preuni          
           /*tt-it-docto.vl-seguro           = it-nota-fisc.vl-seguro          */
           tt-it-docto.vl-tot-item         = it-nota-fisc.vl-tot-item        
           tt-it-docto.ct-cuscon           = it-nota-fisc.ct-cuscon          
           tt-it-docto.ind-imprenda        = it-nota-fisc.ind-imprenda       
           /*tt-it-docto.mercliq-moeda-forte = it-nota-fisc.mercliq-moeda-forte
           tt-it-docto.mercori-moeda-forte = it-nota-fisc.mercori-moeda-forte
           tt-it-docto.merctab-moeda-forte = it-nota-fisc.merctab-moeda-forte*/
           tt-it-docto.nivel-rest          = it-nota-fisc.nivel-rest         
           tt-it-docto.pc-rest             = it-nota-fisc.pc-rest            
           /*tt-it-docto.peso-bru-it-inf     = it-nota-fisc.peso-bru-it-inf    
           tt-it-docto.vl-taxa-exp         = it-nota-fisc.vl-taxa-exp          */
           tt-it-docto.vl-desconto         = it-nota-fisc.vl-desconto        
           tt-it-docto.vl-desconto-perc    = it-nota-fisc.per-des-item.

    create tt-it-imposto.
    assign tt-it-imposto.seq-tt-it-docto   = cont2

           tt-it-imposto.aliq-icm-comp = natur-oper.aliq-icm-com

           tt-it-imposto.aliquota-icm      = it-nota-fisc.aliquota-icm     
           tt-it-imposto.aliquota-ipi      = it-nota-fisc.aliquota-ipi     
           tt-it-imposto.aliquota-iss      = it-nota-fisc.aliquota-iss     
           tt-it-imposto.cd-trib-icm       = it-nota-fisc.cd-trib-icm      
           tt-it-imposto.cd-trib-ipi       = it-nota-fisc.cd-trib-ipi      
           tt-it-imposto.cd-trib-iss       = it-nota-fisc.cd-trib-iss      
           tt-it-imposto.cod-servico       = it-nota-fisc.cod-servico      
           tt-it-imposto.ind-icm-ret       = it-nota-fisc.ind-icm-ret      
           tt-it-imposto.per-des-icms      = it-nota-fisc.per-des-icms     
           tt-it-imposto.perc-red-icm      = it-nota-fisc.perc-red-icm     
           tt-it-imposto.perc-red-ipi      = it-nota-fisc.perc-red-ipi     
           tt-it-imposto.perc-red-iss      = it-nota-fisc.perc-red-iss     
           /*tt-it-imposto.vl-bicms-ent-fut  = it-nota-fisc.vl-bicms-ent-fut */
           tt-it-imposto.vl-bicms-it       = it-nota-fisc.vl-bicms-it      
           /*tt-it-imposto.vl-bipi-ent-fut   = it-nota-fisc.vl-bipi-ent-fut  */
           tt-it-imposto.vl-bipi-it        = it-nota-fisc.vl-bipi-it       
           tt-it-imposto.vl-biss-it        = it-nota-fisc.vl-biss-it       
           /*tt-it-imposto.vl-bsubs-ent-fut  = it-nota-fisc.vl-bsubs-ent-fut */
           tt-it-imposto.vl-bsubs-it       = it-nota-fisc.vl-bsubs-it      
           /*tt-it-imposto.icm-complem       = it-nota-fisc.icm-complem      */
           /*tt-it-imposto.vl-icms-ent-fut   = it-nota-fisc.vl-icms-ent-fut  */
           tt-it-imposto.vl-icms-it        = it-nota-fisc.vl-icms-it       
           /*tt-it-imposto.vl-icms-outras    = it-nota-fisc.vl-icms-outras   */
           tt-it-imposto.vl-icmsou-it      = it-nota-fisc.vl-icmsou-it     
           tt-it-imposto.vl-icmsnt-it      = it-nota-fisc.vl-icmsnt-it     
           /*tt-it-imposto.vl-icmsub-ent-fut = it-nota-fisc.vl-icmsub-ent-fut*/
           tt-it-imposto.vl-icmsub-it      = it-nota-fisc.vl-icmsub-it     
           /*tt-it-imposto.vl-ipi-ent-fut    = it-nota-fisc.vl-ipi-ent-fut   */
           tt-it-imposto.vl-ipi-it         = it-nota-fisc.vl-ipi-it        
           /*tt-it-imposto.vl-ipi-outras     = it-nota-fisc.vl-ipi-outras    */
           tt-it-imposto.vl-ipiou-it       = it-nota-fisc.vl-ipiou-it      
           tt-it-imposto.vl-ipint-it       = it-nota-fisc.vl-ipint-it      
           tt-it-imposto.vl-irf-it         = it-nota-fisc.vl-irf-it        
           tt-it-imposto.vl-iss-it         = it-nota-fisc.vl-iss-it        
           tt-it-imposto.vl-issnt-it       = it-nota-fisc.vl-issnt-it      
           tt-it-imposto.vl-issou-it       = it-nota-fisc.vl-issou-it      
           /*tt-it-imposto.vl-pauta          = it-nota-fisc.vl-pauta         */
           /*tt-it-docto.desconto-zf         = it-nota-fisc.desconto-zf*/
        &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
           tt-it-imposto.vl-ir-adic        = it-nota-fisc.vl-ir-adic
        &ENDIF         
            .
    FOR FIRST nar-it-nota NO-LOCK
        where nar-it-nota.cod-estabel = it-nota-fisc.cod-estabel
          and nar-it-nota.serie       = it-nota-fisc.serie
          and nar-it-nota.nr-nota-fis = it-nota-fisc.nr-nota-fis.
        ASSIGN tt-it-docto.narrativa           = nar-it-nota.narrativa.
    END.
           
    
    for first item fields ( politica char-2 )
        where item.it-codigo = tt-it-docto.it-codigo no-lock: end.

    assign tt-it-docto.ind-componen   = if  avail item 
                                        and (   item.politica = 5  /* Configurado */
                                             or item.politica = 6) /* Composto    */
                                        then 2
                                        else 1.

    FOR FIRST natur-oper FIELDS ( char-1 mercado perc-pis per-fin-soc ) WHERE
        natur-oper.nat-operacao = tt-it-docto.nat-operacao NO-LOCK: END.

    /** grava informacoes de PIS e Cofins **/
    if avail item and avail natur-oper then do:

        assign substr(tt-it-docto.char-2,96,1) = substr(natur-oper.char-1,86,1)
               substr(tt-it-docto.char-2,97,1) = substr(natur-oper.char-1,87,1).

        if substr(tt-it-docto.char-2,96,1) = "" then assign substr(tt-it-docto.char-2,96,1) = "1".
        if substr(tt-it-docto.char-2,97,1) = "" then assign substr(tt-it-docto.char-2,97,1) = "1".

        if  substr(tt-it-docto.char-2,96,1) <> "2" 
        and substr(tt-it-docto.char-2,96,1) <> "3"
            then 
                assign substr(tt-it-docto.char-2,76,5) = 
                      if natur-oper.mercado = 1 then                         /* Mercado Interno */
                          if substr(item.char-2,52,1) = "1"                  /* pega do item */
                          then string(dec(substr(item.char-2,31,5)),"99.99") /* Utiliza aliquota do item */
                          else string(natur-oper.perc-pis[1],"99.99")        /* Sen∆o pega aliquota da natureza*/
                      else string(natur-oper.perc-pis[2],"99.99")            /* Mercado externo */
                    substr(tt-it-docto.char-2,86,5) = 
                      if natur-oper.mercado = 1
                      then string(dec(substr(item.char-2,41,5)),"99.99")
                      else "00,00".
            else 
                assign substr(tt-it-docto.char-2,76,5) = "00,00"
                       substr(tt-it-docto.char-2,86,5) = "00,00".

        if  substr(tt-it-docto.char-2,97,1) <> "2" 
        and substr(tt-it-docto.char-2,97,1) <> "3"
            then   
             assign substr(tt-it-docto.char-2,81,5) =
                      if natur-oper.mercado = 1 then                         /* Mercado Interno */               
                          if substr(item.char-2,53,1) = "1"                  /* pega do item */        
                          then string(dec(substr(item.char-2,36,5)),"99.99") /* Utiliza aliquota do item */      
                          else string(natur-oper.per-fin-soc[1],"99.99")     /* Sen∆o pega aliquota da natureza*/
                      else string(natur-oper.per-fin-soc[2],"99.99")         /* Mercado externo */               
                    substr(tt-it-docto.char-2,91,5) = 
                      if natur-oper.mercado = 1
                      then string(dec(substr(item.char-2,46,5)),"99.99")
                      else "00,00".
           else 
             assign substr(tt-it-docto.char-2,81,5) = "00,00"
                    substr(tt-it-docto.char-2,91,5) = "00,00".
    end.

    /************************************************************ 
    *  PrÇ-Processador para o m¢dulo de Descontos e Bonificaá∆o
    ************************************************************/
    &if defined (bf_dis_desc_bonif) &then
        create tt-it-docto-bn.
        assign tt-it-docto-bn.cod-estabel                = tt-it-docto.cod-estabel
               tt-it-docto-bn.serie                      = tt-it-docto.serie
               tt-it-docto-bn.nr-nota                    = tt-it-docto.nr-nota
               tt-it-docto-bn.nr-sequencia               = tt-it-docto.nr-sequencia
               tt-it-docto-bn.it-codigo                  = tt-it-docto.it-codigo
               tt-it-docto-bn.val-pct-desconto-tab-preco = it-nota-fisc.val-pct-desconto-tab-preco
               tt-it-docto-bn.des-pct-desconto-inform    = it-nota-fisc.des-pct-desconto-inform   
               tt-it-docto-bn.val-desconto-inform        = it-nota-fisc.val-desconto-inform       
               tt-it-docto-bn.val-pct-desconto-total     = it-nota-fisc.val-pct-desconto-total    
               tt-it-docto-bn.val-desconto-total         = it-nota-fisc.val-desconto-total        
               tt-it-docto-bn.val-pct-desconto-periodo   = it-nota-fisc.val-pct-desconto-periodo  
               tt-it-docto-bn.val-pct-desconto-prazo     = it-nota-fisc.val-pct-desconto-prazo    
               tt-it-docto-bn.val-desconto[1]            = it-nota-fisc.val-desconto[1]           
               tt-it-docto-bn.val-desconto[2]            = it-nota-fisc.val-desconto[2]           
               tt-it-docto-bn.val-desconto[3]            = it-nota-fisc.val-desconto[3]           
               tt-it-docto-bn.val-desconto[4]            = it-nota-fisc.val-desconto[4]           
               tt-it-docto-bn.val-desconto[5]            = it-nota-fisc.val-desconto[5].
    &endif            

    DEFINE VARIABLE cont7 AS INTEGER     NO-UNDO.
    FOR EACH item-embal OF nota-fiscal NO-LOCK.
        assign cont7 = cont7 + 1.
        create tt-item-embal.
        assign tt-item-embal.seq-tt-nota-embal = cont6
               tt-item-embal.seq-tt-item-embal = cont7
               tt-item-embal.volume            = item-embal.int-1
               tt-item-embal.nr-sequencia      = it-nota-fisc.nr-seq-ped
               tt-item-embal.it-codigo         = item-embal.it-codigo   
               tt-item-embal.qt-embalada       = item-embal.dec-1.
    end.

END PROCEDURE.







RUN pi-grava-nota.

if  can-find (first tt-erros) then do:       
    {utp/ut-liter.i NOTAS_REJEITADAS MFT R}
    disp return-value                    at 25 format "x(40)" 
         fill('-',length(trim(return-value))) at 25 format "x(40)" 
         with frame f-1 width 80 stream-io.

    for each tt-erros by int(tt-erros.identifi-msg):            
        find first tt-erros-aux where
             tt-erros-aux.seq-tt-docto = int(tt-erros.identifi-msg) no-error.
        disp tt-erros-aux.cod-estabel
             tt-erros-aux.serie
             tt-erros-aux.nr-nota-fis
             tt-erros.tabela
             tt-erros.cod-erro
             tt-erros.desc-erro 
             with down frame f-erro stream-io.    
        down with frame f-erro.
    end.               
end.

for each tt-notas-geradas:
    for first nota-fiscal fields(cod-estabel serie nr-nota-fis ind-sit-nota)
        where rowid(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal no-lock:
        if nota-fiscal.dt-cancela <> ? then  /* Cancelada */

        disp nota-fiscal.cod-estabel
             nota-fiscal.serie
             nota-fiscal.nr-nota-fis
             with down frame f-4 stream-io.
        down with frame f-4.
    end.
end.












Procedure pi-grava-nota:
    def var h-api as handle.
    /***** Consistàncias da nota **********/
    run ftp/ftapi060a.p persistent set h-api.
    run pi-execucao in h-api 
                    (input table tt-docto,
                     input table tt-it-docto,
                     input table tt-nota-trans,
                     input table tt-saldo-estoq,
                     input table tt-fat-duplic,
                     input table tt-fat-repre,
                     input table tt-nota-embal,
                     input table tt-item-embal,
                     input table tt-it-docto-imp,
                     input table tt-it-imposto,
                     input NO,
                     input-output table tt-erros).
    delete procedure h-api.

    for each tt-erros break by tt-erros.identifi-msg:
       find tt-docto 
            where tt-docto.seq-tt-docto = int(tt-erros.identifi-msg) no-error.
       if avail tt-docto then do:
          create tt-erros-aux.
          assign tt-erros-aux.seq-tt-docto = tt-docto.seq-tt-docto
                 tt-erros-aux.cod-estabel  = tt-docto.cod-estabel
                 tt-erros-aux.serie        = tt-docto.serie
                 tt-erros-aux.nr-nota-fis  = tt-docto.nr-nota.
          /*run pi-elimina-nota.*/
       end.
       else 
          if int(tt-erros.identifi-msg) = 0 then do:
             find first tt-docto no-error.
             create tt-erros-aux.
             assign tt-erros.identifi-msg     = string(tt-docto.seq-tt-docto)
                    tt-erros-aux.seq-tt-docto = tt-docto.seq-tt-docto
                    tt-erros-aux.cod-estabel  = tt-docto.cod-estabel
                    tt-erros-aux.serie        = tt-docto.serie
                    tt-erros-aux.nr-nota-fis  = tt-docto.nr-nota.
          end.
    end.

    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
    find first tt-docto no-lock no-error.
    if avail tt-docto then do:
        RELEASE nota-fiscal NO-ERROR.
       run ftp/ft2010.p (input  YES,
                         output l-erro,
                         input  table tt-docto,
                         input  table tt-it-docto,
                         input  table tt-it-imposto,
                         input  table tt-nota-trans,
                         input  table tt-saldo-estoq,
                         input  table tt-fat-duplic,
                         input  table tt-fat-repre,
                         input  table tt-nota-embal,
                         input  table tt-item-embal,
                         input  table tt-it-docto-imp,
                         &IF DEFINED(bf_dis_desc_bonif) &THEN
                         input  table tt-docto-bn,
                         input  table tt-it-docto-bn,
                         &ENDIF
                     
                         &IF DEFINED(bf_dis_unid_neg) &THEN
                             input table tt-rateio-it-duplic,
                         &ENDIF
                         input-output table tt-notas-geradas
                         &IF DEFINED(bf_dis_ciap) &THEN
                             ,
                             input table tt-it-nota-doc
                         &ENDIF).
       /*run pi-elimina-nota.*/
    end.                  

end procedure.
