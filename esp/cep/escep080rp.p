
/* include de controle de versao */
{include/i-prgvrs.i ESCEP080 1.00.00.000}

/* definicao das temp-tables para recebimento de parametros */
{esp/cep/escep080.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE BUFFER b-item-uni-estab FOR item-uni-estab.

/* recebimento de par³metros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE chExcel       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estabel     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-politica        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tipo-contr      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-emissao-ord     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estab-demanda   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tp-ressup       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-perm-saldo-neg  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tipo-est-seg    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-criticidade     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ind-refugo      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tipo-requis     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-reporta-ggf     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-reporta-mob     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-sit-aloc        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-classe-repro    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-controle-estoq  AS CHARACTER NO-UNDO.  
DEFINE VARIABLE c-rep-prod        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-acond           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-conv-tempo      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-div-ordem       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-repres-demanda  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-liber           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-excel           AS CHARACTER NO-UNDO.

DEFINE STREAM st-excel.

{utp/ut-glob.i}
{esp/es0018.i}

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padr’o para variÿveis de relat½rio  */
{include/i-rpvar.i}

/* defini»’o de variÿveis  */
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.

/* include padr’o para output de relat½rios */
{include/i-rpout.i}

/* include com a defini»’o da frame de cabe»alho e rodap² */
{include/i-rpcab.i}


/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESCEP080"
	    c-versao	    = "1.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "ESP"
	    c-titulo-relat  = "Fam¡lias".


/* para nÆo visualizar cabe»alho/rodap‚ em sa­da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilitÿrio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/* corpo do relat½rio */
OUTPUT STREAM st-excel TO VALUE(tt-param.excel).

ASSIGN c-excel = tt-param.excel.

PUT STREAM st-excel UNFORMATTED
    "Familia;Descricao;Estabelecimento;Depos.Padrao;Tp.Despesa;Natureza.Despesa;Politica;TP.Controle;Moeda Padrao;Unid.Padrao;Unid.Negocio;Emis.Ordens;Demanda;Tp.Ressuprimento;Perm.Saldo.Negat;Tp.Est.Seg;Tempo.Segur;Ciclo.Contag;Criticidade;NQA;N¡vel;Indic.Refugo;Planejador;Capac.Esto.Fabr;Tipo Requisicao;Reporta MOB;Reporta GGF;Tipo aloc;Classe Reprogramacao;Tipo.Contr.Estoq;Reportar.Prod;Meses Validade;Fluxo SharePoint;EX;Grupo Est;Acondicionamento;Norma/Procedimento;Linha Producao;% de perda;Descricao Ingles;Padrao Nom;Periodo Fixo;Converte.Tempo.Seg;Divisao de ordens;Prioridade MRP;Repressa Demanda;Prioridade;Ressupr.Compras;Ressupr.CQ;Ressupr.Fornec;Horizonte.Liber;Horizonte Fixo"	SKIP.

ASSIGN c-cod-estabel    = ""
       c-politica       = ""
       c-tipo-contr     = ""
       c-emissao-ord    = ""
       c-estab-demanda  = ""
       c-tp-ressup      = ""
       c-perm-saldo-neg = ""
       c-tipo-est-seg   = ""
       c-criticidade    = ""
       c-ind-refugo     = ""
       c-tipo-requis    = ""
       c-reporta-ggf    = ""
       c-reporta-mob    = ""
       c-sit-aloc       = ""
       c-classe-repro   = ""
       c-controle-estoq = ""
       c-rep-prod       = ""
       c-acond          = ""
       c-conv-tempo     = ""
       c-div-ordem      = ""
       c-repres-demanda = ""
       c-liber          = "".

FOR EACH int-familia NO-LOCK
    WHERE int-familia.fm-codigo >= tt-param.fm-codigo-ini
      AND int-familia.fm-codigo <= tt-param.fm-codigo-fim:

    RUN pi-acompanhar IN h-acomp("Familia: " + int-familia.fm-codigo).
    
    FOR EACH fam-uni-estab NO-LOCK
        WHERE fam-uni-estab.fm-codigo = int-familia.fm-codigo:
        
        FIND FIRST familia NO-LOCK
            WHERE familia.fm-codigo = int-familia.fm-codigo NO-ERROR.

        FIND FIRST tipo-rec-desp NO-LOCK                                                                                                                                                                                                                                                                                                                                                                                                        
            WHERE tipo-rec-desp.tp-codigo = familia.int-1 NO-ERROR.
        
        FIND FIRST familia-mat NO-LOCK                                                                                                                                                                                                                                                                                                                                                           
            WHERE familia-mat.fm-codigo = fam-uni-estab.fm-codigo NO-ERROR.   
         
        FIND FIRST natureza-despesa NO-LOCK
            WHERE natureza-despesa.nat-despesa = familia-mat.nat-despesa NO-ERROR.

        FIND FIRST moeda NO-LOCK
            WHERE moeda.mo-codigo = familia.moeda-padrao NO-ERROR.

        FIND grup-estoque NO-LOCK
            WHERE grup-estoque.ge-codigo = int-familia.ge-codigo NO-ERROR.

        FIND FIRST lin-prod NO-LOCK
            WHERE lin-prod.cod-estabel = fam-uni-estab.cod-estabel NO-ERROR. 

        FIND FIRST c-tab-res NO-LOCK
            WHERE c-tab-res.nr-tabela = 4
              AND c-tab-res.sequencia = int-familia.acond NO-ERROR.

        IF AVAIL c-tab-res THEN
            ASSIGN c-acond = c-tab-res.descricao.
        
        CASE familia.politica:
            WHEN 1 THEN
                ASSIGN c-politica = "Periodo Fixo".
            WHEN 2 THEN
                ASSIGN c-politica = "Lote Economico".
            WHEN 3 THEN
                ASSIGN c-politica = "Ordem".
            WHEN 4 THEN
                ASSIGN c-politica = "Nivel Superior".
            WHEN 5 THEN
                ASSIGN c-politica = "Configurado".
            WHEN 6 THEN
                ASSIGN c-politica = "Composto".
            WHEN 7 THEN
                ASSIGN c-politica = "Ponto de Reposicao".
        END CASE.

        CASE fam-uni-estab.tp-ressup:
            WHEN 1 THEN
                ASSIGN c-tp-ressup = "Ponto de Encomenda".
            WHEN 2 THEN
                ASSIGN c-tp-ressup = "Manual".
            WHEN 3 THEN
                ASSIGN c-tp-ressup = "Periodico".
        END CASE.

        CASE familia.tipo-contr:
            WHEN 1 THEN
                ASSIGN c-tipo-contr = "Fisico".
            WHEN 2 THEN
                ASSIGN c-tipo-contr = "Total".
            WHEN 3 THEN
                ASSIGN c-tipo-contr = "Consignado".
            WHEN 4 THEN
                ASSIGN c-tipo-contr = "Debito Direto".
            WHEN 5 THEN
                ASSIGN c-tipo-contr = "Nao Definido".
        END CASE.

        CASE familia.perm-saldo-neg:
            WHEN 1 THEN
                ASSIGN c-perm-saldo-neg = "Nao".
            WHEN 2 THEN
                ASSIGN c-perm-saldo-neg = "Sim Confirmado".
            WHEN 3 THEN
                ASSIGN c-perm-saldo-neg = "Sim".
        END CASE.

        CASE familia.criticidade:
            WHEN 1 THEN
                ASSIGN c-criticidade = "X".
            WHEN 2 THEN
                ASSIGN c-criticidade = "Y".
            WHEN 3 THEN
                ASSIGN c-criticidade = "Z".
        END CASE.

        CASE familia.tipo-requis:
            WHEN 1 THEN
                ASSIGN c-tipo-requis = "Normal".
            WHEN 2 THEN
                ASSIGN c-tipo-requis = "Transferencia".
            WHEN 3 THEN
                ASSIGN c-tipo-requis = "Debito GGF".
        END CASE.

        CASE familia.sit-aloc:
            WHEN 1 THEN
                ASSIGN c-sit-aloc = "Total".
            WHEN 2 THEN
                ASSIGN c-sit-aloc = "Parcial".
            WHEN 3 THEN
                ASSIGN c-sit-aloc = "Proporcional".
        END CASE.

        CASE familia.classe-repro:
            WHEN 1 THEN
                ASSIGN c-classe-repro = "Antecipa/Prorroga".
            WHEN 2 THEN
                ASSIGN c-classe-repro = "Prorroga".
            WHEN 3 THEN
                ASSIGN c-classe-repro = "Antecipa".
            WHEN 4 THEN
                ASSIGN c-classe-repro = "Nao Reprograma".
        END CASE.

        CASE familia.tipo-con-est:
            WHEN 1 THEN
                ASSIGN c-controle-estoq = "Serial".
            WHEN 2 THEN  
                ASSIGN c-controle-estoq = "Numero de Serie".
            WHEN 3 THEN  
                ASSIGN c-controle-estoq = "Lote".
            WHEN 4 THEN  
                ASSIGN c-controle-estoq = "Referencia".
        END CASE.

        CASE familia.rep-prod:
            WHEN 1 THEN
                ASSIGN c-rep-prod = "Ordem".
            WHEN 2 THEN  
                ASSIGN c-rep-prod = "Operacao".
            WHEN 3 THEN  
                ASSIGN c-rep-prod = "Ponto de Controle".
            WHEN 4 THEN  
                ASSIGN c-rep-prod = "Item".
        END CASE.
        
        CASE familia.div-ordem:
            WHEN 1 THEN
                ASSIGN c-div-ordem = "Nao Divide".
            WHEN 2 THEN
                ASSIGN c-div-ordem = "Lote Multiplo".
            WHEN 3 THEN
                ASSIGN c-div-ordem = "Lote Economico".
        END CASE.
        
        IF familia.reporte-mob = 1 THEN
            ASSIGN c-reporta-mob = "Real".
        ELSE
            ASSIGN c-reporta-mob = "Padrao".

        IF familia.reporte-ggf = 1 THEN
            ASSIGN c-reporta-ggf = "Real".
        ELSE
            ASSIGN c-reporta-ggf = "Padrao".
        
        IF familia.ind-refugo = 1 THEN
            ASSIGN c-ind-refugo = "Perda Total".
        ELSE
            ASSIGN c-ind-refugo = "Reciclavel".

        IF familia.emissao-ord = 1 THEN
            ASSIGN c-emissao-ord = "Automatico".                                                                                                                     
        ELSE
            ASSIGN c-emissao-ord = "Manual".

        IF familia.demanda = 1 THEN
            ASSIGN c-estab-demanda = "Dependente".                                                                                                                                                                                                                   
        ELSE
            ASSIGN c-estab-demanda = "Independente".

        IF familia.tipo-est-seg = 1 THEN
            ASSIGN c-tipo-est-seg = "Quantidade".
        ELSE
            ASSIGN c-tipo-est-seg = "Tempo".

        IF familia.ind-refugo = 1 THEN
            ASSIGN c-ind-refugo = "Perda Total".
        ELSE
            ASSIGN c-ind-refugo = "Reciclavel".

        IF familia.conv-tempo-seg = YES THEN
            ASSIGN c-conv-tempo = "Sim".
        ELSE
            ASSIGN c-conv-tempo = "Nao".

        IF SUBSTRING(fam-uni-estab.char-1,132,1) = "1" THEN
            ASSIGN c-repres-demanda = "Sim".                                                                                                                                                                                                                         
        ELSE
            ASSIGN c-repres-demanda = "Nao". 
        
        ASSIGN c-liber = SUBSTRING(fam-uni-estab.char-1,129,3).
        
        PUT STREAM st-excel UNFORMATTED
            int-familia.fm-codigo           ";"   /* Codigo Familia    */  
            familia.descricao               ";"   /* Descricao familia */
            fam-uni-estab.cod-estabel       ";"   /* Estabelecimento   */
            familia.deposito-pad            ";"   /* Deposito PadrÆo   */
            tipo-rec-desp.descricao         ";".  /* TP Despesa */
        
        IF AVAIL natureza THEN
            PUT STREAM st-excel UNFORMATTED natureza-despesa.descricao ";".  /* Natureza despesa*/
        ELSE
            PUT STREAM st-excel UNFORMATTED ";".
        
        PUT STREAM st-excel UNFORMATTED
            c-politica                      ";"  /* Politica  */
            c-tipo-contr                    ";"  /* Tipo de controle */   
            moeda.descricao                 ";"  /* Moeda Padrao */       
            familia.un                      ";"  /* Unidade Padrao */     
            familia-mat.cod-unid-negoc      ";"  /* Unidade de negocio */ 
            c-emissao-ord                   ";"   /* Emissao Ordens */                              
            c-estab-demanda                 ";"   /* Demanda */                                     
            c-tp-ressup                     ";"   /* Tipo de ressuprimento */                       
            c-perm-saldo-neg                ";"   /* Permite Saldo Negativo  */                     
            c-tipo-est-seg                  ";"   /* Tipo Est Seg */                                
            familia.tempo-segur             ";"   /* Tempo Seguranca */                             
            familia.ciclo-contag            ";"   /* Ciclo Contagem */                              
            c-criticidade                   ";"   /* Criticidade */                                 
            familia.perc-nqa                ";"   /* NQA */                                          
            familia.nivel                   ";".  /* N¡vel de inspecao */                            
        
        PUT STREAM st-excel UNFORMATTED                                                              
            c-ind-refugo                    ";"   /* Indice de refugo */   
            familia.cd-planejado            ";"   /* CP0104 Planejador */                            
            fam-uni-estab.cap-est-fabr      ";"   /* Capacidade estoque fabrica */                   
            c-tipo-requis                   ";"   /* Tipo de requisicao */  
            c-reporta-mob                   ";"   /* Reporta MOB */ 
            c-reporta-ggf                   ";"   /* Reporta GGF*/  
            c-sit-aloc                      ";"   /* Tipo aloc */   
            c-classe-repro                  ";"   /* Classe reprogramacao */ 
            c-controle-estoq                ";"   /* Tipo Controle Estoque */
            c-rep-prod                      ";"   /* Reportar Prod */
            int-familia.meses-validade      ";"   /* Meses Validade */       
            int-familia.fluxo-sp            ";"   /* Fluxo SharePoint */     
            int-familia.ex                  ";"   /* EX */                   
            grup-estoque.descricao          ";"   /* Grupo Estoque */        
            c-acond                         ";"   /* Acondicionamento int-familia.acond */     
            int-familia.norma               ";"   /* Norma */  
            lin-prod.descricao              ";"   /* Linha Producao */     
            int-familia.perc-perda          ";"   /* Percentual de perda */
            int-familia.desc-ingles         ";"   /* Descricao Ingles */   
            int-familia.pad-nomenc          ";"   /* Padrao Nom */         
            fam-uni-esta.periodo-fixo       ";"   /* Periodo Fixo */       
            c-conv-tempo                    ";"   /* Converte tempo seg */ 
            c-div-ordem                     ";"   /* Divisao de ordens */  
            fam-uni-esta.int-1              ";"   /* Prioridade MRP */ 
            c-repres-demanda                ";"   /* Represa Demanda */
            fam-uni-estab.prioridade        ";"   /* Prioridade */         
            fam-uni-esta.res-int-comp       ";"   /* Ressupr Compras */    
            fam-uni-esta.res-cq-comp        ";"   /* Ressupr CQ */         
            fam-uni-esta.res-for-comp       ";"   /* Ressupr Fornec */   
            c-liber                         ";"   /* Horizonte Liber */    
            fam-uni-esta.horiz-fixo         SKIP. /* Horizonte Fixo */     
    END.

END.
OUTPUT STREAM st-excel CLOSE.

PUT UNFORMATTED "Arquivo CSV gerado em " + tt-param.excel + ".".

CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.

IF ERROR-STATUS:ERROR THEN 
    CREATE "Excel.Application":U chExcel.

ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).

chPlanilhaMod:Activate().

ASSIGN chExcel:VISIBLE     = TRUE
       chExcel:WindowState = 3.

RELEASE OBJECT chExcel       NO-ERROR.
RELEASE OBJECT chArquivo     NO-ERROR.
RELEASE OBJECT chPlanilhaMod NO-ERROR. 

            
/*fechamento do output do relat½rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.



