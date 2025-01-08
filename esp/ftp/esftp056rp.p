/***********************************************************************
**  Programa..: ESP\FTP\ESFTP056RP.P
**  Autor.....: Anderson Cenci
**  Data......: Fevereiro/2008 - Desenvolvimento
**  Descricao.: Relatorio de Comiss‰es
**  Vers∆o....: 001 13/02/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP056 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/ftp/esftp056.i}
{include/i-rpvar.i}
{esp/es0018.i}
def temp-table tt_log_erros_comis no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_repres                   as integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_periodo                      as character format "x(06)" label "Per°odo" column-label "Per°odo"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(200)" label "Mensagem Ajuda" column-label "Mensagem Ajuda". 
/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
DEFINE VARIABLE c-e-mail              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-mes-x               AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ano-x               AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-ir                 AS DECIMAL   NO-UNDO.
DEFINE VARIABLE da-dt-vencto          AS DATE      NO-UNDO.
DEFINE VARIABLE c-tipo                AS CHARACTER NO-UNDO FORMAT "x(30)".
DEFINE VARIABLE c-arquivo-mail        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo-mail2       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cgc                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE da-data-ref-vlp       AS DATE      NO-UNDO.
DEFINE VARIABLE de-perc-acordo        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-presente     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-s-acordo     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-a-vista      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-a-vista         AS DECIMAL   NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE de-valor-comissao     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-merc-liq-tot    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-faturamento     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-devolucao       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-inadimplenc     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-inad-paga       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-vl-com-ina-pag     AS DECIMAL   NO-UNDO.    
DEFINE VARIABLE de-vl-com-ina         AS DECIMAL   NO-UNDO.    
DEFINE VARIABLE de-vl-com-fat         AS DECIMAL   NO-UNDO.    
DEFINE VARIABLE de-vl-com-dev         AS DECIMAL   NO-UNDO.  
DEFINE VARIABLE de-1                  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-comissao-tot AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-sem-ir       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-a-receber          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-debito             AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-credito            AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-base         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-valor-base-total   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-media-comissao     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE i-cont                AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-dt-implant          AS DATE      NO-UNDO.
DEFINE VARIABLE de-vl-a-vista2        AS DECIMAL   NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE de-valor-comissao-to2 AS DECIMAL   NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE de-valor-comissao-to3 AS DECIMAL   NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE c-mes AS CHARACTER  EXTENT 12 INITIAL ["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"] FORMAT "x(20)".
{utp/utapi019.i}
DEFINE STREAM s-resumo2.
DEFINE STREAM s-resumo.
DEFINE TEMP-TABLE tt-arq-repres
    FIELD cod-emitente-repre LIKE emitente.cod-emitente.
DEFINE TEMP-TABLE tt-repres
    FIELD cod-rep           LIKE repres.cod-rep
    FIELD cod-emitente-repre LIKE emitente.cod-emitente
    FIELD vl-a-vista-tot    LIKE comissao-fat.vl-a-vista 
    FIELD vl-comissao-tot   LIKE comissao-fat.vl-comissao
    FIELD vl-media-comissao AS DEC.

DEFINE TEMP-TABLE tt-repres-emit
    FIELD cod-rep           LIKE repres.cod-rep
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD vl-comissao-tot   AS DEC
    FIELD lido              AS LOG.

DEF BUFFER b-tt-repres-emit FOR tt-repres-emit.

DEFINE TEMP-TABLE tt-emitente
    FIELD cod-emitente      LIKE emitente.cod-emitente     
    FIELD vl-a-vista-tot    LIKE comissao-fat.vl-a-vista   
    FIELD vl-media-comissao AS DEC.                        

DEFINE TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat 
    FIELD cod-emitente-repre LIKE emitente.cod-emitente.
DEFINE TEMP-TABLE tt-comissao NO-UNDO
    FIELD cod-estabel    LIKE nota-fiscal.cod-estabel
    FIELD cod-rep        LIKE repres.cod-rep
    FIELD cod-emitente-repre LIKE emitente.cod-emitente
    FIELD unid-neg       AS CHARACTER
    FIELD vl-merc-liq    AS DECIMAL
    FIELD valor-comissao AS DECIMAL
    FIELD valor-a-vista  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD vl-faturamento AS DECIMAL   
    FIELD vl-devolucao   AS DECIMAL   
    FIELD vl-inadimplenc AS DECIMAL   
    field vl-inad-paga   AS DECIMAL 
    FIELD vl-com-ina-pag AS DECIMAL
    FIELD vl-com-fat     AS dECIMAL
    FIELD vl-com-dev     AS DECIMAL
    FIELD vl-com-ina     AS DECIMAL
    INDEX ch-principal cod-estabel cod-rep unid-neg.

DEFINE TEMP-TABLE tt-unid-neg
    FIELD unid-neg       AS CHARACTER
    FIELD valor-comissao AS DECIMAL
    INDEX ch-principal unid-neg.
DEFINE TEMP-TABLE tt-comis-deb-cred
    FIELD cod-estabel    LIKE comis-deb-cred.cod-estabel
    FIELD cod-mov        like comis-deb-cred.cod-mov
    FIELD unid-neg       LIKE comis-deb-cred.unid-neg
    FIELD base-final     like comis-deb-cred.base-final    
    FIELD deb-cred       LIKE comis-deb-cred.deb-cred
    FIELD valor          AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD historico      LIKE comis-deb-cred.historico.
DEFINE TEMP-TABLE tt-arq-anexo
    FIELD cod-emitente-repre LIKE emitente.cod-emitente
    FIELD arquivo-mail   AS CHARACTER 
    FIELD arquivo-mail2  AS CHARACTER. 
DEFINE VARIABLE da-data          AS DATE.
DEFINE VARIABLE da-data-ini      LIKE nota-fiscal.dt-emis-nota.
DEFINE VARIABLE da-data-fim      LIKE nota-fiscal.dt-emis-nota.
DEFINE VARIABLE d-dt-ent         LIKE ped-venda.dt-emiss.
DEFINE VARIABLE c-obs            AS CHAR FORMAT "X(85)".
DEFINE VARIABLE i-atendente      LIKE ped-venda.tp-pedido.
DEFINE VARIABLE c-mail           AS CHAR FORMAT "X(40)".
DEFINE VARIABLE c-desc-grupo     LIKE gr-cli.descricao.
DEFINE VARIABLE c-ds-gr          AS CHARACTER.
DEFINE VARIABLE c-ds-sub         AS CHARACTER.
DEFINE VARIABLE c-ds-cor         AS CHARACTER.
DEFINE VARIABLE c-ds-marca       AS CHARACTER. 
DEFINE VARIABLE c-titulo-mail    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-texto-mail     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-data-inicial  AS DATE      NO-UNDO.
DEFINE VARIABLE dt-data-final    AS DATE        NO-UNDO.
DEFINE VARIABLE c-unid-neg       AS CHARACTER FORMAT "X(10)".
DEFINE VARIABLE de-perc-comissao AS DECIMAL FORMAT ">9.99".
DEFINE VARIABLE c-desc-cond      LIKE cond-pagto.descricao.
DEFINE VARIABLE de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant    LIKE ped-venda.dt-implant.
DEFINE BUFFER b-emitente         FOR emitente.
DEFINE BUFFER b-tt-comissao      FOR tt-comissao.
DEFINE BUFFER b-comissao-fat-tot FOR comissao-fat-tot.
DEFINE BUFFER b-emitente-repres  FOR emitente.

DEFINE VARIABLE vl-com-deb-cred  LIKE comis-deb-cred.valor   NO-UNDO.

DEFINE VARIABLE i-cod-repres-aux AS INT NO-UNDO.

/****************************  Frames       ****************************/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE h-acomp      AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relatorio de Vendas"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP056"
       c-versao       = "2.01"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
/*
A fam°lia Comercial dever† seguir o seguinte formato:
GGSSMMCC
Onde: 
 GG - Indicaá∆o do grupo do Produto (NumÇrico);     1,2
 SS - Indicaá∆o do subgrupo do Produto (NumÇrico);  3,2
 MM - Indicaá∆o da Marca do Produto (NumÇrico);     5,2
 CC - Indicaá∆o do Complemento (NumÇrico).          7,2
*/
DEFINE VARIABLE cRegiao    AS CHARACTER FORMAT 'x(40)'.
DEFINE VARIABLE cPerc      AS CHARACTER FORMAT 'x(05)'.
DEFINE VARIABLE a          AS DECIMAL FORMAT ">>>,>>>,>>9.99".
DEFINE VARIABLE h-cmsbo011 AS HANDLE      NO-UNDO.

PROCEDURE piImprimeRelat:
    
   FIND estabelec
        WHERE estabelec.cod-estabel = "101" NO-LOCK NO-ERROR.

   put unformatted "Movto;Est;Serie;Nr.Nota         ;  Cliente;Nome Cliente                            ;Gr; Rep.;Represent.  ;Dt.Impl.;Condiá∆o Pagamento            ;Parcela Inadimplente;Especie Duplic.;Unid.Neg. ;Item            ;Descriá∆o do Item                   ;Grupo   ;Sub.Gr. ;Qtdade;Dt.Emissao;Dt Vencimento;Vlr.Pres;  Pr.Med.;   %Acordo;      Vlr.s/IPI;      Vlr.Pres.;     Vl.s.Acord;     Vl.a Vista; Comiss∆o; Segmento;Emitente; ~r~n" .

   IF tt-param.agendamento = YES THEN DO:
       ASSIGN tt-param.fi-periodo-ini        = string(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
              tt-param.fi-periodo-fim        = string(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
              tt-param.rs-previa-oficial = 1.
       RUN esp/cms/escms011bo.p PERSISTENT SET h-cmsbo011.
       FOR EACH repres NO-LOCK
         WHERE repres.cod-rep >= tt-param.fi-cod-repres-ini 
           AND repres.cod-rep <= tt-param.fi-cod-repres-fim:
           RUN pi-acompanhar IN h-acomp (INPUT "Lendo Inadimplencia:" + string(repres.cod-rep)).
            RUN pi_calc_inad       IN h-cmsbo011 (INPUT tt-param.fi-periodo-ini, /* Per≠odo da leitura */
                                                  INPUT NO,        /* YES - Oficial, gera tabela comissao-fat / NO - Pr≤via, retorna temp-table */
                                                  INPUT repres.cod-rep, /* CΩdigo do Representante */
                                                  INPUT-OUTPUT TABLE tt-comissao-fat).
    
       END.
       DELETE PROCEDURE h-cmsbo011.
   END.
/*    IF tt-param.rs-previa-oficial = 1 THEN                                                                                                    */
/*       ASSIGN c-titulo-mail = "Comissoes - PREVIA "                                                                                           */
/*              c-texto-mail = "Em anexo relatorio de comissoes. Este relat¢rio Ç uma vis∆o prÇvia do fechamento e poder† sofrer alteraá‰es. ". */
/*    ELSE                                                                                                                                      */
      ASSIGN c-titulo-mail = "Comissoes - OFICIAL "
             c-texto-mail = "Em anexo relatorio de comissoes." .
   for each comissao-fat USE-INDEX ch_sec
       WHERE comissao-fat.periodo >= tt-param.fi-periodo-ini
         and comissao-fat.periodo <= tt-param.fi-periodo-fim
         AND comissao-fat.cod-estabel >= tt-param.fi-estab-ini
         AND comissao-fat.cod-estabel <= tt-param.fi-estab-fim NO-LOCK,
       FIRST repres NO-LOCK
       WHERE repres.cod-rep = comissao-fat.cod-rep
         AND repres.cod-rep >= tt-param.fi-cod-repres-ini 
         AND repres.cod-rep <= tt-param.fi-cod-repres-fim,
       FIRST b-emitente-repres NO-LOCK
       WHERE b-emitente-repres.cgc = repres.cgc
         AND b-emitente-repres.cod-emitente >= tt-param.fi-cod-emitente-ini
         AND b-emitente-repres.cod-emitente <= tt-param.fi-cod-emitente-fim:

       IF NOT CAN-FIND(FIRST tt-repres-emit
                       WHERE tt-repres-emit.cod-rep      = comissao-fat.cod-rep
                         AND tt-repres-emit.cod-emitente = b-emitente-repres.cod-emitente) THEN DO:
           CREATE tt-repres-emit.
           ASSIGN tt-repres-emit.cod-rep      = comissao-fat.cod-rep
                  tt-repres-emit.cod-emitente = b-emitente-repres.cod-emitente.
       END.

       CREATE tt-comissao-fat.
       BUFFER-COPY comissao-fat TO tt-comissao-fat.
       ASSIGN tt-comissao-fat.cod-emitente-repre = b-emitente-repres.cod-emitente.

       FIND FIRST tt-repres NO-LOCK
            WHERE tt-repres.cod-rep = comissao-fat.cod-rep NO-ERROR.
       IF NOT AVAIL tt-repres THEN DO:
           CREATE tt-repres.
           ASSIGN tt-repres.cod-rep      = comissao-fat.cod-rep
                  tt-repres.cod-emitente = b-emitente-repres.cod-emitente.
       END.
       ASSIGN tt-repres.vl-a-vista-tot  = tt-repres.vl-a-vista-tot  + tt-comissao-fat.vl-a-vista
              tt-repres.vl-comissao-tot = tt-repres.vl-comissao-tot + tt-comissao-fat.vl-comissao.

       FIND FIRST tt-emitente NO-LOCK
            WHERE tt-emitente.cod-emitente = b-emitente-repres.cod-emitente NO-ERROR.
       IF NOT AVAIL tt-emitente THEN DO:
           CREATE tt-emitente.
           ASSIGN tt-emitente.cod-emitente = b-emitente-repres.cod-emitente.
       END.
       ASSIGN tt-emitente.vl-a-vista-tot  = tt-emitente.vl-a-vista-tot  + tt-comissao-fat.vl-a-vista.
   END.


   FOR EACH tt-emitente:

       ASSIGN de-valor-comissao-tot = 0.
    
       FOR FIRST tt-repres NO-LOCK
           WHERE tt-repres.cod-emitente = tt-emitente.cod-emitente:
           FOR EACH comissoes-faixa
              WHERE comissoes-faixa.cod-rep = tt-repres.cod-rep 
                AND comissoes-faixa.dt-inicial <= TODAY 
                AND comissoes-faixa.dt-final   >= TODAY NO-LOCK:
        
               IF comissoes-faixa.vl-inicial > tt-emitente.vl-a-vista-tot THEN LEAVE.
        
                IF  tt-emitente.vl-a-vista-tot > comissoes-faixa.vl-final THEN DO:
                    ASSIGN de-valor-base = comissoes-faixa.vl-final - comissoes-faixa.vl-inicial.
                END.
                ELSE
                    ASSIGN de-valor-base = tt-emitente.vl-a-vista-tot - comissoes-faixa.vl-inicial.
        
                ASSIGN de-valor-comissao     = de-valor-base         * comissoes-faixa.vl-percentual / 100
                       de-valor-comissao-tot = de-valor-comissao-tot + de-valor-comissao.
            END.
            ASSIGN tt-emitente.vl-media-comissao = de-valor-comissao-tot / tt-emitente.vl-a-vista-tot.
       END.

   END.
   
   for each tt-comissao-fat USE-INDEX ch_sec NO-LOCK,
       FIRST repres NO-LOCK
       WHERE repres.cod-rep = tt-comissao-fat.cod-rep,
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = tt-comissao-fat.cod-emitente,
       FIRST ITEM no-lock
       WHERE ITEM.it-codigo = tt-comissao-fat.it-codigo
       BREAK BY tt-comissao-fat.id-tipo-inform
             BY tt-comissao-fat.dt-emissao
             BY tt-comissao-fat.nr-nota-fis
             BY tt-comissao-fat.it-codigo:

       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(tt-comissao-fat.dt-emissao,"99/99/9999") + " - "+ tt-comissao-fat.nr-nota-fis).

       FIND FIRST fam-com-item NO-LOCK
            WHERE fam-com-item.unidade  = SUBSTRING(item.fm-cod-com,1,2)
              AND fam-com-item.segmento = SUBSTRING(item.fm-cod-com,3,2) NO-ERROR.

       find tt-comissao
            where tt-comissao.cod-estabel = tt-comissao-fat.cod-estabel
              and tt-comissao.cod-rep     = tt-comissao-fat.cod-rep
              and tt-comissao.unid-neg    = tt-comissao-fat.unid-neg
              no-error.
       if not avail tt-comissao then do:
          create tt-comissao.
          assign tt-comissao.cod-estabel  = tt-comissao-fat.cod-estabel
                 tt-comissao.cod-rep      = tt-comissao-fat.cod-rep     
                 tt-comissao.unid-neg     = tt-comissao-fat.unid-neg
                 tt-comissao.cod-emitente-repre = tt-comissao-fat.cod-emitente-repre. 
       end.
       assign tt-comissao.vl-merc-liq     = tt-comissao.vl-merc-liq + tt-comissao-fat.vl-merc-liq.

       IF tt-comissao-fat.id-tipo-inform = 1 THEN
          ASSIGN tt-comissao.vl-faturamento = tt-comissao.vl-faturamento + tt-comissao-fat.vl-merc-liq
                 tt-comissao.vl-com-fat     = tt-comissao.vl-com-fat     + tt-comissao-fat.vl-comissao
                 c-tipo                     = "Faturamento".
       IF tt-comissao-fat.id-tipo-inform = 2 THEN
          ASSIGN tt-comissao.vl-devolucao   = tt-comissao.vl-devolucao   + tt-comissao-fat.vl-merc-liq
                 tt-comissao.vl-com-dev     = tt-comissao.vl-com-dev     + tt-comissao-fat.vl-comissao 
                 c-tipo                     = "Devoluá∆o".
       IF tt-comissao-fat.id-tipo-inform = 3 THEN
          ASSIGN tt-comissao.vl-inadimplenc = tt-comissao.vl-inadimplenc + tt-comissao-fat.vl-merc-liq
                 tt-comissao.vl-com-ina     = tt-comissao.vl-com-ina     + tt-comissao-fat.vl-comissao
                 c-tipo                     = "Inadimplencia".
       IF tt-comissao-fat.id-tipo-inform = 4 THEN
          ASSIGN tt-comissao.vl-inad-paga   = tt-comissao.vl-inad-paga   + tt-comissao-fat.vl-merc-liq
                 tt-comissao.vl-com-ina-pag = tt-comissao.vl-com-ina-pag + tt-comissao-fat.vl-comissao
                 c-tipo                     = "Inad.Paga".
       
       assign de-valor-presente           = tt-comissao-fat.vl-presente
              de-valor-s-acordo           = tt-comissao-fat.vl-s-acordo
              de-valor-a-vista            = tt-comissao-fat.vl-a-vista
              de-valor-comissao           = tt-comissao-fat.vl-comissao
              tt-comissao.valor-a-vista   = tt-comissao.valor-a-vista  + tt-comissao-fat.vl-a-vista
              tt-comissao.valor-comissao  = tt-comissao.valor-comissao + tt-comissao-fat.vl-comissao.
              
       find tt-unid-neg where tt-unid-neg.unid-neg = tt-comissao-fat.unid-neg EXCLUSIVE-LOCK no-error.
       if not avail tt-unid-neg then do:
           create tt-unid-neg.
           assign tt-unid-neg.unid-neg       = tt-comissao-fat.unid-neg.
       end.
       
       /*BUSCA UNIDADE DE NEG‡CIO******ALTERNATIVO*******/
        ASSIGN c-unid-neg = "".
        FIND FIRST it-nota-fisc NO-LOCK
             WHERE it-nota-fisc.cod-estabel = tt-comissao-fat.cod-estabel
               AND it-nota-fisc.serie       = tt-comissao-fat.serie
               AND it-nota-fisc.nr-nota-fis = tt-comissao-fat.nr-nota-fis
               AND it-nota-fisc.nr-seq-fat  = tt-comissao-fat.sequencia
               AND it-nota-fisc.it-codigo   = tt-comissao-fat.it-codigo NO-ERROR.
        IF AVAIL it-nota-fisc THEN
            ASSIGN c-unid-neg = it-nota-fisc.cod-unid-negoc.
        ELSE DO:
           IF AVAIL ITEM THEN
              assign c-unid-neg = ITEM.cod-unid-negoc.
        END.
       /*************************************************/
       

           
       IF   OPSYS <> "win32" THEN
            assign c-arquivo-mail2 = c-dir-spool-servid-exec +  "/" + tt-param.fi-estab-ini + "_" + STRING(tt-comissao-fat.cod-emitente-repre) + "_notas.txt" .                    
       ELSE
           IF  c-dir-spool-servid-exec = "" THEN
               assign c-arquivo-mail2 = SESSION:TEMP-DIRECTORY + tt-param.fi-estab-ini + "_" + STRING(tt-comissao-fat.cod-emitente-repre) + "_notas.txt" .                    
           ELSE
               assign c-arquivo-mail2 = c-dir-spool-servid-exec + "/" + tt-param.fi-estab-ini + "_" + STRING(tt-comissao-fat.cod-emitente-repre) + "_notas.txt" .                  

       FIND FIRST tt-arq-anexo 
            WHERE tt-arq-anexo.cod-emitente-repre = tt-comissao-fat.cod-emitente-repre NO-ERROR.
       IF NOT AVAIL tt-arq-anexo THEN DO:
           CREATE tt-arq-anexo.
           ASSIGN tt-arq-anexo.cod-emitente-repre = tt-comissao-fat.cod-emitente-repre.
       END.
       ASSIGN tt-arq-anexo.arquivo-mail2 = c-arquivo-mail2.
               
       find tt-arq-repres
            where tt-arq-repres.cod-emitente-repre = tt-comissao-fat.cod-emitente-repre
            no-lock no-error.
       if not avail tt-arq-repres then do:
           output stream s-resumo2 TO  value(c-arquivo-mail2).              
           put stream s-resumo2 UNFORMATTED  
               "Movto;Est;Serie;Nr.Nota         ;  Cliente;Nome Cliente                            ;Gr; Rep.;Represent.  ;Dt.Impl.;Condiá∆o Pagamento            ;Parcela Inadimplente;Especie Duplic.;Unid.Neg. ;Item            ;Descriá∆o do Item                   ;Grupo   ;Sub.Gr. ;Qtdade;Dt.Emissao;Dt.Vencimento;Vlr.Pres;  Pr.Med.;   %Acordo;      Vlr.s/IPI;      Vlr.Pres.;     Vl.s.Acord;     Vl.a Vista; Comiss∆o; Segmento;Emitente; ~r~n" .
           CREATE tt-arq-repres.
           assign tt-arq-repres.cod-emitente-repre = tt-comissao-fat.cod-emitente-repre.              
       end.
       else
           output stream s-resumo2 to value(c-arquivo-mail2) append.              
       
      FIND cond-pagto 
          WHERE cond-pagto.cod-cond-pag = tt-comissao-fat.cod-cond-pagto
          NO-LOCK NO-ERROR.

       put stream s-resumo2 unformatted 
           c-tipo                   ";"
           tt-comissao-fat.cod-estabel ";"
           tt-comissao-fat.serie ";"
           tt-comissao-fat.nr-nota-fis ";"
           tt-comissao-fat.cod-emitente ";"
           emitente.nome-emit ";"
           emitente.cod-gr-cli ";"
           repres.cod-rep ";"
           repres.nome-abrev ";"
           tt-comissao-fat.dt-implant-ped ";".
       IF AVAIL cond-pagto THEN
           put  stream s-resumo2 unformatted cond-pagto.descricao ";".
       ELSE
           put  stream s-resumo2 unformatted ";".


       ASSIGN da-dt-vencto = ?.
       IF tt-comissao-fat.id-tipo-inform = 3 OR
          tt-comissao-fat.id-tipo-inform = 4 THEN DO:
           RUN esp/ftp/esftp056a.p (INPUT  tt-comissao-fat.cod-estabel,
                                    INPUT  tt-comissao-fat.especie,       
                                    INPUT  tt-comissao-fat.serie,         
                                    INPUT  tt-comissao-fat.nr-nota-fis, 
                                    INPUT  tt-comissao-fat.parcela,     
                                    OUTPUT da-dt-vencto).
       END.



       put  stream s-resumo2 unformatted
           tt-comissao-fat.parcela ";"
           tt-comissao-fat.especie ";"
           c-unid-neg ";"
           /*tt-comissao-fat.unid-neg ";"*/
           item.it-codigo ";"
           item.descricao-1 
           item.descricao-2 ";"
           c-ds-gr  ";"
           c-ds-sub ";"
           tt-comissao-fat.qt-faturada ";"
           tt-comissao-fat.dt-emissao ";"
           da-dt-vencto ";"
           tt-comissao-fat.dt-ref-vlp ";".
       IF tt-comissao-fat.nr-praz-med < 0 THEN
          PUT stream s-resumo2 "0,00;".
       ELSE
          PUT stream s-resumo2 tt-comissao-fat.nr-praz-med FORMAT ">>>>>9.99" ";".

       FIND FIRST tt-repres NO-LOCK
            WHERE tt-repres.cod-rep = tt-comissao-fat.cod-rep NO-ERROR.
       FIND FIRST tt-emitente NO-LOCK
            WHERE tt-emitente.cod-emitente = tt-comissao-fat.cod-emitente-repre NO-ERROR.

       PUT stream s-resumo2 tt-comissao-fat.perc-acordo ";"
           tt-comissao-fat.vl-merc-liq format "->>>,>>>,>>9.99" ";" 
           tt-comissao-fat.vl-presente format "->>>,>>>,>>9.99" ";"
           tt-comissao-fat.vl-s-acordo format "->>>,>>>,>>9.99" ";"
           tt-comissao-fat.vl-a-vista  format "->>>,>>>,>>9.99" ";"
           (tt-comissao-fat.vl-a-vista * tt-emitente.vl-media-comissao) format "->>>,>>>,>>9.99" ";".

       FIND FIRST tt-repres-emit
            WHERE tt-repres-emit.cod-rep = tt-comissao-fat.cod-rep NO-ERROR.
       ASSIGN tt-repres-emit.vl-comissao-tot = tt-repres-emit.vl-comissao-tot + (tt-comissao-fat.vl-a-vista * tt-emitente.vl-media-comissao).

       IF AVAIL fam-com-item THEN
           PUT stream s-resumo2 fam-com-item.descricao ";".
       ELSE
           PUT stream s-resumo2 ";".

       PUT stream s-resumo2 tt-comissao-fat.cod-emitente-repre "; ~r~n".

       output stream s-resumo2 close.
       
       put unformatted c-tipo                   ";"
           tt-comissao-fat.cod-estabel ";"
           tt-comissao-fat.serie ";"
           tt-comissao-fat.nr-nota-fis ";"
           tt-comissao-fat.cod-emitente ";"
           emitente.nome-emit ";"
           emitente.cod-gr-cli ";"
           repres.cod-rep ";"
           repres.nome-abrev ";"
           tt-comissao-fat.dt-implant-ped ";"               .
       IF AVAIL cond-pagto THEN
           put unformatted cond-pagto.descricao ";".
       ELSE
           put unformatted ";".

       put unformatted tt-comissao-fat.parcela ";"
           tt-comissao-fat.especie ";"
           c-unid-neg ";"
           /*tt-comissao-fat.unid-neg ";"*/
           item.it-codigo ";"
           item.descricao-1 
           item.descricao-2 ";"
           c-ds-gr  ";"
           c-ds-sub ";"
           tt-comissao-fat.qt-faturada ";"
           tt-comissao-fat.dt-emissao ";"
           da-dt-vencto ";"
           tt-comissao-fat.dt-ref-vlp ";".

       IF tt-comissao-fat.nr-praz-med < 0 THEN
          PUT unformatted "0,00;".
       ELSE
          PUT unformatted tt-comissao-fat.nr-praz-med FORMAT ">>>>>9.99" ";".

       FIND FIRST tt-emitente NO-LOCK
            WHERE tt-emitente.cod-emitente = tt-comissao-fat.cod-emitente-repre NO-ERROR.

       PUT UNFORMATTED tt-comissao-fat.perc-acordo ";"
           tt-comissao-fat.vl-merc-liq format "->>>,>>>,>>9.99" ";" 
           tt-comissao-fat.vl-presente format "->>>,>>>,>>9.99" ";"
           tt-comissao-fat.vl-s-acordo format "->>>,>>>,>>9.99" ";"
           tt-comissao-fat.vl-a-vista  format "->>>,>>>,>>9.99" ";"
           (tt-comissao-fat.vl-a-vista * tt-emitente.vl-media-comissao) format "->>>,>>>,>>9.99" ";".

       IF AVAIL fam-com-item THEN
           PUT UNFORMATTED fam-com-item.descricao ";".
       ELSE
           PUT UNFORMATTED ";".

       PUT UNFORMATTED tt-comissao-fat.cod-emitente-repre "; ~r~n".

   end.
    
     put unformatted "arquivo " c-dir-spool-servid-exec +  "/" + tt-param.fi-estab-ini + "_Resumo_Por_Representante.txt" FORMAT "x(400)" "~r~n".


    output close.  

    ASSIGN dt-data-inicial = DATE("01/" + SUBSTRING(tt-comissao-fat.periodo,5,2) + "/" + SUBSTRING(tt-comissao-fat.periodo,1,4)).

    IF SUBSTRING(tt-comissao-fat.periodo,5,2) = "12" THEN
       ASSIGN c-mes-x = "01"
              c-ano-x = string((int( SUBSTRING(tt-comissao-fat.periodo,1,4)   ) + 1), "9999").
    ELSE
        ASSIGN c-mes-x = string((int(SUBSTRING(tt-comissao-fat.periodo,5,2)   ) + 1),"99")
               c-ano-x = string((int(SUBSTRING(tt-comissao-fat.periodo,1,4)   ) ), "9999").


    ASSIGN dt-data-final   = DATE("01/" + c-mes-x + "/" + c-ano-x) - 1.
    
    IF OPSYS <> "win32" THEN
        output TO value(c-dir-spool-servid-exec +  "/" + tt-param.fi-estab-ini + "_Resumo_Por_Representante.txt" ).
    
    ELSE
        IF c-dir-spool-servid-exec = "" THEN
            output TO value(tt-param.arquivo + "2").
        ELSE
            output TO value(c-dir-spool-servid-exec + "/" + tt-param.arquivo + "2").
      
    PUT UNFORMATTED "~r~n~r~n"
        "Resumo Por Representante ~r~n~r~n"
        "Est; Rep.;Nome Abrev  ;".
        for each tt-unid-neg
            break by tt-unid-neg.unid-neg:
            put UNFORMATTED tt-unid-neg.unid-neg "       ;".
        end.
    
    
    
    for each comis-deb-cred    
       where comis-deb-cred.cod-estabel >= tt-param.fi-estab-ini
         AND comis-deb-cred.cod-estabel <= tt-param.fi-estab-fim
         AND comis-deb-cred.dt-movto    >= dt-data-inicial
         AND comis-deb-cred.dt-movto    <= dt-data-final
        break by comis-deb-cred.dt-movto:

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo Comissoes Deb/Cred.:" + string(comis-deb-cred.dt-movto,"99/99/9999")).

        IF NOT CAN-FIND(FIRST tt-repres NO-LOCK
                        WHERE tt-repres.cod-rep = comis-deb-cred.cod-rep) THEN NEXT.
        
        find first tt-comis-deb-cred
             where tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
               AND tt-comis-deb-cred.cod-mov     = comis-deb-cred.cod-mov
               AND tt-comis-deb-cred.unid-neg    = comis-deb-cred.unid-neg
               AND tt-comis-deb-cred.base-final  = comis-deb-cred.base-final
               AND tt-comis-deb-cred.deb-cred    = comis-deb-cred.deb-cred no-lock no-error.
        if not avail tt-comis-deb-cred then do:
           create tt-comis-deb-cred.
           assign tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
                  tt-comis-deb-cred.unid-neg    = comis-deb-cred.unid-neg 
                  tt-comis-deb-cred.base-final  = comis-deb-cred.base-final
                  tt-comis-deb-cred.cod-mov     = comis-deb-cred.cod-mov
                  tt-comis-deb-cred.deb-cred    = comis-deb-cred.deb-cred.
        end.
        IF comis-deb-cred.cod-rep  >= tt-param.fi-cod-repres-ini AND
           comis-deb-cred.cod-rep  <= tt-param.fi-cod-repres-fim THEN DO:

            FIND FIRST repres NO-LOCK
                 WHERE repres.cod-rep = comis-deb-cred.cod-rep NO-ERROR.
            FIND FIRST b-emitente-repres NO-LOCK
                 WHERE b-emitente-repres.cgc = repres.cgc NO-ERROR.

            IF NOT AVAIL b-emitente-repres
            OR (b-emitente-repres.cod-emitente < tt-param.fi-cod-emitente-ini
            AND b-emitente-repres.cod-emitente > tt-param.fi-cod-emitente-fim) THEN NEXT.
            
            FIND tt-comissao
                 WHERE tt-comissao.cod-estabel = comis-deb-cred.cod-estabel
                   AND tt-comissao.cod-rep     = comis-deb-cred.cod-rep
                   AND tt-comissao.unid-neg    = comis-deb-cred.unid-neg
                NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-comissao THEN DO:
                CREATE tt-comissao.
                ASSIGN tt-comissao.cod-estabel = comis-deb-cred.cod-estabel
                       tt-comissao.cod-rep     = comis-deb-cred.cod-rep        
                       tt-comissao.unid-neg    = comis-deb-cred.unid-neg
                       tt-comissao.cod-emitente-repre = b-emitente-repres.cod-emitente.
                
            END.
        END.
    END.

    for each tt-comis-deb-cred
        where tt-comis-deb-cred.base-final = yes
        break by tt-comis-deb-cred.cod-mov:
        find mov-comis
             where mov-comis.cod-mov = tt-comis-deb-cred.cod-mov no-lock no-error.
        put  UNFORMATTE tt-comis-deb-cred.unid-neg + " - " + mov-comis.descricao FORMAT "x(30)"  ";".
    end.     
        
    put UNFORMATTED "   Total Global;             IR;  Valor Liquido;".
    
    for each tt-comis-deb-cred
        where tt-comis-deb-cred.base-final = no
        break by tt-comis-deb-cred.cod-mov :
        find mov-comis
             where mov-comis.cod-mov = tt-comis-deb-cred.cod-mov no-lock no-error.
        put UNFORMATTED tt-comis-deb-cred.unid-neg + " - " + mov-comis.descricao FORMAT "x(30)"  ";".
    end.     

    put UNFORMATTED "      A Receber;Cod Repres.;Razao Social ~r~n".

    /* ** Geraá∆o da CPI - Provis∆o de comiss∆o da inadimplància por competància ***/
    IF tt-param.rs-previa-oficial = 2 
    THEN DO:
         IF tt-param.fi-periodo-ini <> tt-param.fi-periodo-fim 
         THEN DO:
              PUT UNFORMATTED "No modo de execuá∆o Oficial o per°odo inicial deve ser igual ao final. " "~r~n".
              RETURN.
         END.
         DO TRANSACTION:
            RUN esp/cms/escms010b.p(INPUT tt-param.fi-estab-ini,
                                    INPUT tt-param.fi-estab-fim,
                                    INPUT tt-param.fi-periodo-ini, /* ** YYYYMM ***/
                                    OUTPUT TABLE tt_log_erros_comis).
            IF CAN-FIND(FIRST tt_log_erros_comis) 
            THEN DO:
                 PUT UNFORMATTED "Erro na Integracao com o Contas a Pagar CPI " "~r~n".
                 FOR EACH tt_log_erros_comis:
                     PUT UNFORMATTED tt_log_erros_comis.ttv_num_mensagem " - " tt_log_erros_comis.ttv_des_msg_erro FORMAT "X(150)"  "~r~n" tt_log_erros_comis.ttv_des_msg_ajuda FORMAT "X(150)"   "~r~n".
                 END.
                 
                 UNDO, RETURN.
            END.
         END.
    END.


    /* Resumo de notas por representante */

    FOR EACH tt-comissao
        break by tt-comissao.cod-rep
              BY tt-comissao.cod-estabel
              by tt-comissao.unid-neg TRANS:
              
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Resumo:" + string(tt-comissao.cod-rep)).

        IF tt-param.rs-previa-oficial = 2 THEN DO:
             FIND FIRST comissao-fat-tot
                 WHERE comissao-fat-tot.cod-estabel = tt-comissao.cod-estabel
                   AND comissao-fat-tot.cod-rep     = tt-comissao.cod-rep
                   AND comissao-fat-tot.periodo     = string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99")
                   NO-LOCK NO-ERROR.

             IF AVAIL comissao-fat-tot THEN NEXT.
        END.   
      
        if first-of(tt-comissao.cod-estabel)     then do:
           find repres
                where repres.cod-rep = tt-comissao.cod-rep no-lock no-error.
                        
           PUT UNFORMATTED tt-comissao.cod-estabel ";"
               tt-comissao.cod-rep ";"
               repres.nome-abrev   ";".

           for each tt-unid-neg:
               assign tt-unid-neg.valor-comissao = 0.
           end.
           
           for each tt-comis-deb-cred:
                assign tt-comis-deb-cred.valor = 0
                       tt-comis-deb-cred.historico = "".
           end.

           assign de-vl-merc-liq-tot    = 0
                  de-vl-a-vista         = 0
                  de-valor-comissao-tot = 0
                  de-vl-faturamento     = 0
                  de-vl-devolucao       = 0
                  de-vl-inadimplenc     = 0
                  de-vl-inad-paga       = 0
                  de-vl-com-ina-pag     = 0    
                  de-vl-com-ina         = 0    
                  de-vl-com-fat         = 0    
                  de-vl-com-dev         = 0.
        end.
               
        ASSIGN de-vl-merc-liq-tot         = de-vl-merc-liq-tot    + tt-comissao.vl-merc-liq
               de-vl-a-vista              = de-vl-a-vista         + tt-comissao.valor-a-vista
               de-valor-comissao-tot      = de-valor-comissao-tot + tt-comissao.valor-comissao
               de-vl-faturamento          = de-vl-faturamento     + tt-comissao.vl-faturamento
               de-vl-devolucao            = de-vl-devolucao       + tt-comissao.vl-devolucao  
               de-vl-inadimplenc          = de-vl-inadimplenc     + tt-comissao.vl-inadimplenc
               de-vl-inad-paga            = de-vl-inad-paga       + tt-comissao.vl-inad-paga  
               de-vl-com-ina-pag          = de-vl-com-ina-pag     + tt-comissao.vl-com-ina-pag
               de-vl-com-ina              = de-vl-com-ina         + tt-comissao.vl-com-ina
               de-vl-com-fat              = de-vl-com-fat         + tt-comissao.vl-com-fat
               de-vl-com-dev              = de-vl-com-dev         + tt-comissao.vl-com-dev.
        
        find FIRST tt-unid-neg where tt-unid-neg.unid-neg = tt-comissao.unid-neg no-lock no-error.
        IF AVAIL tt-unid-neg THEN 
            assign tt-unid-neg.valor-comissao = tt-comissao.valor-a-vista.

        if LAST-OF(tt-comissao.cod-estabel)     then do:

           if tt-param.rs-previa-oficial = 2 then do:
               
               CREATE comissao-fat-tot.
               ASSIGN comissao-fat-tot.cod-estabel = tt-comissao.cod-estabel
                      comissao-fat-tot.cod-rep     = tt-comissao.cod-rep
                      comissao-fat-tot.periodo     = string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99")
                      comissao-fat-tot.vl-tot-liq-fat   = de-vl-merc-liq-tot
                      comissao-fat-tot.vl-base-comissao = de-vl-a-vista
                      comissao-fat-tot.vl-comissao      = de-valor-comissao-tot.


           end.

        
           /*put unformatted de-vl-merc-liq-tot format "->>>,>>>,>>9.99" ";".*/

           ASSIGN de-vl-a-vista2        = 0
                  de-valor-comissao-to3 = 0.

           /* JONK */

           FOR EACH b-tt-comissao 
               WHERE b-tt-comissao.cod-rep = tt-comissao.cod-rep NO-LOCK:
               ASSIGN de-vl-a-vista2        = de-vl-a-vista2        + b-tt-comissao.valor-a-vista.

               assign de-valor-base         = 0
                      de-valor-comissao-to2 = 0.

               FIND FIRST tt-emitente
                    WHERE tt-emitente.cod-emitente = tt-comissao.cod-emitente-repre NO-LOCK NO-ERROR.

               ASSIGN de-valor-base         = de-vl-a-vista2
                      de-valor-comissao     = de-valor-base         * tt-emitente.vl-media-comissao
                      de-valor-comissao-to2 = de-valor-comissao.

           END.

            /*put unformatted de-vl-a-vista2  format "->>>,>>>,>>9.99" ";" de-valor-comissao-to2 format "->>>,>>>,>>9.99" ";" . */

           assign i-cont = 1.            
           for each tt-unid-neg
               by tt-unid-neg.unid-neg:
               IF  de-vl-a-vista2        = 0
               AND de-valor-comissao-to2 = 0 THEN DO:
                   put "0;" . 
                   ASSIGN de-valor-comissao-to3 = 0.
               END.
               ELSE DO:
                   put unformatted ((tt-unid-neg.valor-comissao / de-vl-a-vista2) * de-valor-comissao-to2) format "->>>,>>>,>>9.99" ";" . 
                   ASSIGN de-valor-comissao-to3 = de-valor-comissao-to3 + ((tt-unid-neg.valor-comissao / de-vl-a-vista2) * de-valor-comissao-to2).

                   /*JONK */

               END.
               /*put unformatted 'tt-unid-neg.valor-comissao' tt-unid-neg.valor-comissao format "->>>,>>>,>>9.99" ";" .               */
           end.

           assign de-debito = 0
                  de-credito = 0.
           
           for each comis-deb-cred no-lock
               WHERE comis-deb-cred.cod-estabel >= tt-comissao.cod-estabel
                 AND comis-deb-cred.cod-estabel <= tt-comissao.cod-estabel
                 AND comis-deb-cred.cod-rep = tt-comissao.cod-rep
                 and comis-deb-cred.base-final = yes
                 and comis-deb-cred.dt-mov  >= dt-data-inicial
                 and comis-deb-cred.dt-mov  <= dt-data-final:
                find first tt-comis-deb-cred
                     where tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
                       AND tt-comis-deb-cred.cod-mov     = comis-deb-cred.cod-mov
                       AND tt-comis-deb-cred.unid-neg    = comis-deb-cred.unid-neg
                       AND tt-comis-deb-cred.base-final  = comis-deb-cred.base-final
                       AND tt-comis-deb-cred.deb-cred    = comis-deb-cred.deb-cred
                      no-error.
                IF AVAIL tt-comis-deb-cred THEN DO:
                    if comis-deb-cred.deb-cred = yes then
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor * -1
                              de-debito               = de-debito               + comis-deb-cred.valor * -1
                              de-valor-comissao-tot   = de-valor-comissao-tot     + comis-deb-cred.valor * -1
                              de-1 = -1.   
                    else
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor
                              de-credito              = de-credito              + comis-deb-cred.valor
                              de-valor-comissao-tot   = de-valor-comissao-tot     + comis-deb-cred.valor
                              de-1 = 1.
                    
                    assign tt-comis-deb-cred.historico  = comis-deb-cred.historico
                           tt-comis-deb-cred.base-final = comis-deb-cred.base-final.
                    if tt-param.rs-previa-oficial = 2 then do:
                        if comis-deb-cred.deb-cred = yes then
                            ASSIGN comissao-fat-tot.vl-deb-cred-base = comissao-fat-tot.vl-deb-cred-base + comis-deb-cred.valor * -1.
                        ELSE
                            ASSIGN comissao-fat-tot.vl-deb-cred-base = comissao-fat-tot.vl-deb-cred-base + comis-deb-cred.valor.
                    END.
                END.
           end.

           for each tt-comis-deb-cred
                where tt-comis-deb-cred.base-final = yes
                by tt-comis-deb-cred.cod-mov:           

                IF  tt-comis-deb-cred.cod-estabel <> tt-comissao.cod-estabel THEN
                    put unformatted "0,00" ";" .
                ELSE
                    if tt-comis-deb-cred.deb-cred = yes then 
                       put unformatted tt-comis-deb-cred.valor  format "->>>,>>9.99" ";" .
                    ELSE
                       put unformatted tt-comis-deb-cred.valor  format "->>>,>>9.99" ";" .
                
                ASSIGN de-valor-comissao-to3 = de-valor-comissao-to3 + tt-comis-deb-cred.valor.

                /*JONK*/
           end.
           find emitente
                 where emitente.cgc = repres.cgc no-lock no-error.

           /**********
           FIND int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-LOCK NO-ERROR.
           IF AVAIL int-emitente AND
               int-emitente.ind-forma-tributo = 3 THEN /* SIMPLES */
               assign de-valor-sem-ir = de-valor-comissao-tot
                      de-ir           = 0.
           ELSE DO:
               ASSIGN de-ir = de-valor-comissao-tot * tt-param.fi-perc-ir / 100.
               IF de-ir >= 10 THEN
                  assign de-valor-sem-ir = de-valor-comissao-tot - de-valor-comissao-tot * tt-param.fi-perc-ir / 100.            
               ELSE
                  assign de-valor-sem-ir = de-valor-comissao-tot
                         de-ir           = 0.
           END.
           */
           FIND int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-LOCK NO-ERROR.
           IF AVAIL int-emitente AND
               int-emitente.ind-forma-tributo = 3 THEN /* SIMPLES */
               assign de-valor-sem-ir = de-valor-comissao-to3
                      de-ir           = 0.
           ELSE DO:
               ASSIGN de-ir = de-valor-comissao-to3 * tt-param.fi-perc-ir / 100.
               IF de-ir >= 10 THEN
                  assign de-valor-sem-ir = de-valor-comissao-to3 - de-valor-comissao-to3 * tt-param.fi-perc-ir / 100.            
               ELSE
                  assign de-valor-sem-ir = de-valor-comissao-to3
                         de-ir           = 0.
           END.
    
           put unformatted de-valor-comissao-to3                 format "->>>,>>>,>>9.99" ";"
               de-ir                                             format "->>>,>>>,>>9.99" ";"
               de-valor-sem-ir                                   format "->>>,>>>,>>9.99" ";" .                         
  
           if tt-param.rs-previa-oficial = 2 then do:
               ASSIGN comissao-fat-tot.vl-tot-comissao = de-valor-comissao-to3
                      comissao-fat-tot.perc-ir         = tt-param.fi-perc-ir
                      comissao-fat-tot.vl-ir           = de-ir
                      comissao-fat-tot.vl-tot-sem-ir   = de-valor-sem-ir .
           END.


           assign de-debito = 0
                  de-credito = 0.
           
           for each comis-deb-cred no-lock
               where comis-deb-cred.cod-estabel >= tt-comissao.cod-estabel
                 AND comis-deb-cred.cod-estabel <= tt-comissao.cod-estabel
                 AND comis-deb-cred.cod-rep = tt-comissao.cod-rep
                 and comis-deb-cred.base-final = no
                 and comis-deb-cred.dt-mov  >= dt-data-inicial
                 and comis-deb-cred.dt-mov  <= dt-data-final:
                find first tt-comis-deb-cred
                     where tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
                       AND tt-comis-deb-cred.cod-mov    = comis-deb-cred.cod-mov
                       AND tt-comis-deb-cred.unid-neg   = comis-deb-cred.unid-neg
                       AND tt-comis-deb-cred.base-final = comis-deb-cred.base-final
                       AND tt-comis-deb-cred.deb-cred   = comis-deb-cred.deb-cred
                     no-error.
                IF AVAIL tt-comis-deb-cred THEN DO:
                    if comis-deb-cred.deb-cred = yes then
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor * -1
                              de-debito               = de-debito               + comis-deb-cred.valor * -1
                              de-1 = -1.
                    else
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor
                              de-credito              = de-credito              + comis-deb-cred.valor
                              de-1 = 1.

                    assign tt-comis-deb-cred.historico = comis-deb-cred.historico
                           tt-comis-deb-cred.base-final = comis-deb-cred.base-final.
                    if tt-param.rs-previa-oficial = 2 then do:
                        if comis-deb-cred.deb-cred = yes then
                            ASSIGN comissao-fat-tot.vl-deb-cred-final = comissao-fat-tot.vl-deb-cred-final + comis-deb-cred.valor * -1.
                        ELSE
                            ASSIGN comissao-fat-tot.vl-deb-cred-final = comissao-fat-tot.vl-deb-cred-final + comis-deb-cred.valor.
                    END.
                END.
            end.

            assign de-a-receber = de-valor-sem-ir.
            
            for each tt-comis-deb-cred
                where tt-comis-deb-cred.base-final  = no
                by tt-comis-deb-cred.cod-mov:          

                IF  tt-comis-deb-cred.cod-estabel <> tt-comissao.cod-estabel THEN
                    put unformatted "0,00" ";" .
                ELSE
                    if tt-comis-deb-cred.deb-cred = yes THEN DO:
                        assign de-a-receber = de-a-receber + tt-comis-deb-cred.valor. 
                        put unformatted tt-comis-deb-cred.valor  format "->>>,>>9.99" ";" .
                    END.
                    ELSE DO:
                        assign de-a-receber = de-a-receber + tt-comis-deb-cred.valor. 
                        put unformatted tt-comis-deb-cred.valor format "->>>,>>9.99" ";" .
                    END.                                                                  
            end.
                 
            put unformatted de-a-receber format "->>>,>>>,>>9.99" ";".
                
            if avail emitente then do:
               put unformatted emitente.cod-emitente        ";" 
                   emitente.nome-emit ";".               

               IF int-emitente.ind-forma-tributo = 1 THEN 
                  PUT UNFORMATTED "LUCRO REAL".
               ELSE
                   IF int-emitente.ind-forma-tributo = 2 THEN
                      PUT UNFORMATTED "LUCRO PRESUMIDO".
                   ELSE                               
                       IF int-emitente.ind-forma-tributo = 3 THEN /* SIMPLES */
                          PUT UNFORMATTED "SIMPLES".
                       ELSE
                           IF int-emitente.ind-forma-tributo = 4 THEN
                              PUT UNFORMATTED "NENHUM".
                           ELSE                               
                               IF int-emitente.ind-forma-tributo = 5 THEN
                                  PUT UNFORMATTED "ISENTO".
                               ELSE
                                   PUT UNFORMATTED "".


            end.   
            put unformatted                 "~r~n".

            if tt-param.rs-previa-oficial = 2 then do:
                IF de-a-receber < 0 THEN
                    ASSIGN comissao-fat-tot.vl-tot-receber = de-a-receber.

                IF comissao-fat-tot.vl-tot-comissao > 0 THEN DO:

                   ASSIGN comissao-fat-tot.vl-tot-receber = de-a-receber.
                   RUN esp/cms/escms010.p (INPUT tt-comissao.cod-estabel,
                                           INPUT tt-comissao.cod-rep,
                                           INPUT string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99"),
                                           OUTPUT TABLE tt_log_erros_comis).
                   IF CAN-FIND(FIRST tt_log_erros_comis) THEN DO:
                       put unformatted    "Erro na Integracao com o Contas a Pagar " "~r~n".
                       FOR EACH tt_log_erros_comis:
                           put unformatted  tt_log_erros_comis.ttv_num_mensagem  " - "  tt_log_erros_comis.ttv_des_msg_erro FORMAT "X(150)"      "~r~n"
                                tt_log_erros_comis.ttv_des_msg_ajuda FORMAT "X(120)" "~r~n".
                            
                       END.

                       FOR EACH b-tt-comissao 
                           WHERE b-tt-comissao.cod-estabel = tt-comissao.cod-estabel
                             AND b-tt-comissao.cod-rep     = tt-comissao.cod-rep:
                             DELETE b-tt-comissao.
                       END.

                       UNDO, NEXT.
                   END.
               END.
            END.
            
        end.          
    end.
    
    put unformatted "     " "~r~n".
    

    /* Resumo para representante e envio de email */
    FOR EACH tt-comissao
        break BY tt-comissao.cod-emitente-repre
              by tt-comissao.unid-neg TRANS:
              
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Resumo:" + string(tt-comissao.cod-rep)).

      
      
        if first-of(tt-comissao.cod-emitente-repre) then do:
           find repres
                where repres.cod-rep = tt-comissao.cod-rep no-lock no-error.
                        
/*            for each tt-unid-neg:                      */
/*                assign tt-unid-neg.valor-comissao = 0. */
/*            end.                                       */
           
           for each tt-comis-deb-cred:
                assign tt-comis-deb-cred.valor = 0
                       tt-comis-deb-cred.historico = "".
           end.

           assign de-vl-merc-liq-tot    = 0
                  de-vl-a-vista         = 0
                  de-valor-comissao-tot = 0
                  de-vl-faturamento     = 0
                  de-vl-devolucao       = 0
                  de-vl-inadimplenc     = 0
                  de-vl-inad-paga       = 0
                  de-vl-com-ina-pag     = 0    
                  de-vl-com-ina         = 0    
                  de-vl-com-fat         = 0    
                  de-vl-com-dev         = 0.

        
           IF OPSYS <> "win32" THEN
                assign c-arquivo-mail = c-dir-spool-servid-exec + "/" + tt-param.fi-estab-ini + "_" + STRING(tt-comissao.cod-emitente-repre) + "_resumo.txt" .                    
           ELSE
               IF c-dir-spool-servid-exec = "" THEN
                   assign c-arquivo-mail = SESSION:TEMP-DIRECTORY + tt-param.fi-estab-ini + "_" + STRING(tt-comissao.cod-emitente-repre) + "_resumo.txt" . 
               ELSE
                   assign c-arquivo-mail = c-dir-spool-servid-exec + "/" + tt-param.fi-estab-ini + "_" + STRING(tt-comissao.cod-emitente-repre) + "_resumo.txt" . 

           FIND FIRST tt-arq-anexo 
                WHERE tt-arq-anexo.cod-emitente-repre = tt-comissao.cod-emitente-repre NO-ERROR.
           IF NOT AVAIL tt-arq-anexo THEN DO:
               CREATE tt-arq-anexo.
               ASSIGN tt-arq-anexo.cod-emitente-repre = tt-comissao.cod-emitente-repre.
           END.
           ASSIGN tt-arq-anexo.arquivo-mail = c-arquivo-mail.
             
           output stream s-resumo to value(c-arquivo-mail).                 
        
           PUT  stream s-resumo "Estabelecimento: " estabelec.cod-estabel " - " estabelec.nome "          "
                               "Referente Faturamento: " trim(c-mes[month(dt-data-inicial)]) "/" trim(STRING(year(dt-data-inicial))) "~r~n~r~n".
               
           PUT  stream s-resumo 
                               "Endereco     :   " estabelec.endereco "~r~n"
                               "                 " estabelec.bairro   "~r~n"
                               "Cidade       :   " estabelec.cidade "/" estabelec.estado  "~r~n"
                               "CEP          :   " estabelec.cep "~r~n"
                               "CNPJ         :   " estabelec.cgc "~r~n"
                               "INSC.ESTADUAL:   " estabelec.ins-estadual "~r~n"
                               " ~r~n~r~n".

           PUT   stream s-resumo "Representante     : " tt-comissao.cod-emitente-repre " - " repres.nome "~r~n~r~n".              

        end.
               
        ASSIGN de-vl-merc-liq-tot         = de-vl-merc-liq-tot    + tt-comissao.vl-merc-liq
               de-vl-a-vista              = de-vl-a-vista         + tt-comissao.valor-a-vista
               de-valor-comissao-tot      = de-valor-comissao-tot + tt-comissao.valor-comissao
               de-vl-faturamento          = de-vl-faturamento     + tt-comissao.vl-faturamento
               de-vl-devolucao            = de-vl-devolucao       + tt-comissao.vl-devolucao  
               de-vl-inadimplenc          = de-vl-inadimplenc     + tt-comissao.vl-inadimplenc
               de-vl-inad-paga            = de-vl-inad-paga       + tt-comissao.vl-inad-paga  
               de-vl-com-ina-pag          = de-vl-com-ina-pag     + tt-comissao.vl-com-ina-pag
               de-vl-com-ina              = de-vl-com-ina         + tt-comissao.vl-com-ina
               de-vl-com-fat              = de-vl-com-fat         + tt-comissao.vl-com-fat
               de-vl-com-dev              = de-vl-com-dev         + tt-comissao.vl-com-dev.
        
/*         find tt-unid-neg where tt-unid-neg.unid-neg = tt-comissao.unid-neg no-lock no-error.            */
/*         IF AVAIL tt-unid-neg THEN                                                                       */
/*             assign tt-unid-neg.valor-comissao = tt-unid-neg.valor-comissao + tt-comissao.valor-a-vista. */

        if tt-param.rs-previa-oficial = 2 then do:
            FIND FIRST comissao-fat-tot
                WHERE comissao-fat-tot.cod-estabel = tt-comissao.cod-estabel
                  AND comissao-fat-tot.cod-rep     = tt-comissao.cod-rep
                  AND comissao-fat-tot.periodo     = string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99")
                  exclusive-LOCK NO-ERROR.
            IF NOT AVAIL comissao-fat-tot THEN DO:
                CREATE comissao-fat-tot.
                ASSIGN comissao-fat-tot.cod-estabel = tt-comissao.cod-estabel
                       comissao-fat-tot.cod-rep     = tt-comissao.cod-rep
                       comissao-fat-tot.periodo     = string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99").

            END.

            ASSIGN comissao-fat-tot.vl-tot-liq-fat   = comissao-fat-tot.vl-tot-liq-fat   + tt-comissao.vl-merc-liq
                   comissao-fat-tot.vl-base-comissao = comissao-fat-tot.vl-base-comissao + tt-comissao.valor-a-vista.

        end.
               
        if last-of(tt-comissao.cod-emitente-repre) then do:       
           
/*            put stream s-resumo  "Total do Faturamento           : "  de-vl-faturamento format "->>>,>>>,>>9.99"   de-vl-com-fat format "->>>,>>>,>>9.99" "~r~n".     */
/*            put stream s-resumo  "Total de Devolucoes            : "  de-vl-devolucao format "->>>,>>>,>>9.99"     de-vl-com-dev format "->>>,>>>,>>9.99" "~r~n".     */
/*            put stream s-resumo  "Total de Inadimplencia         : "  de-vl-inadimplenc format "->>>,>>>,>>9.99"   de-vl-com-ina format "->>>,>>>,>>9.99" "~r~n".     */
/*            put stream s-resumo  "Total da Inadimplencia Paga    : "  de-vl-inad-paga format "->>>,>>>,>>9.99"     de-vl-com-ina-pag format "->>>,>>>,>>9.99" "~r~n". */
/*                                                                                                                                                                      */
/*            put stream s-resumo  "Total da Faturamento Liquido   : "  de-vl-merc-liq-tot format "->>>,>>>,>>9.99" "~r~n".                                             */
/*                                                                                                                                                                      */
/*            put stream s-resumo "Comissao                       : "  de-valor-comissao-tot format "->>>,>>>,>>9.99" "~r~n".                                           */

            put stream s-resumo  "Base para Calculo da Comissao  : "  de-vl-a-vista
                "" "~r~n"
                                 "Calculo Comissao               :       Valor Ate           Base Perc        Calculo" "~r~n".  

            assign de-valor-comissao-tot = 0
                   de-valor-base         = 0
                   de-valor-base-total   = 0.
             
            FOR EACH comissoes-faixa
                WHERE comissoes-faixa.cod-rep = tt-comissao.cod-rep 
                  AND comissoes-faixa.dt-inicial <= TODAY 
                  AND comissoes-faixa.dt-final   >= TODAY NO-LOCK:

                IF comissoes-faixa.vl-inicial > de-vl-a-vista THEN LEAVE.

                IF  de-vl-a-vista > comissoes-faixa.vl-final THEN DO:
                    ASSIGN de-valor-base = comissoes-faixa.vl-final - comissoes-faixa.vl-inicial.
                END.
                ELSE
                    ASSIGN de-valor-base = de-vl-a-vista - comissoes-faixa.vl-inicial.

                ASSIGN de-valor-comissao     = de-valor-base         * comissoes-faixa.vl-percentual / 100
                       de-valor-comissao-tot = de-valor-comissao-tot + de-valor-comissao
                       de-valor-base-total   = de-valor-base-total   + de-valor-base.
            
                put stream s-resumo "                                 " comissoes-faixa.vl-final      format "->>>,>>>,>>9.99"
                                                                        de-valor-base                 format "->>>,>>>,>>9.99"
                                                                        comissoes-faixa.vl-percentual format ">9.99"
                                                                        de-valor-comissao             format "->>>,>>>,>>9.99" "~r~n".
            
            END.
            
            ASSIGN de-media-comissao = de-valor-comissao-tot / de-vl-a-vista * 100.
            
            put stream s-resumo  "" "~r~n"
                              "Comissao                       : "  de-valor-comissao-tot format "->>>,>>>,>>9.99" "~r~n".                            

           assign i-cont = 1.            

           assign de-debito = 0
                  de-credito = 0.

            /*Chamado 145234 */
           ASSIGN i-cod-repres-aux = 0.
           IF tt-comissao.cod-rep = 1386 OR
              tt-comissao.cod-rep = 1468 THEN
               ASSIGN i-cod-repres-aux = 1212.

           IF i-cod-repres-aux = 0 THEN
               ASSIGN i-cod-repres-aux = tt-comissao.cod-rep.

           
           for each comis-deb-cred no-lock
               WHERE comis-deb-cred.cod-estabel >= tt-param.fi-estab-ini
                 AND comis-deb-cred.cod-estabel <= tt-param.fi-estab-fim
                 AND comis-deb-cred.cod-rep = i-cod-repres-aux
                 and comis-deb-cred.base-final = yes
                 and comis-deb-cred.dt-mov  >= dt-data-inicial
                 and comis-deb-cred.dt-mov  <= dt-data-final:
                find first tt-comis-deb-cred
                     where tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
                       AND tt-comis-deb-cred.cod-mov    = comis-deb-cred.cod-mov
                       AND tt-comis-deb-cred.unid-neg   = comis-deb-cred.unid-neg
                       AND tt-comis-deb-cred.base-final = comis-deb-cred.base-final
                       AND tt-comis-deb-cred.deb-cred   = comis-deb-cred.deb-cred
                      no-error.
                IF AVAIL tt-comis-deb-cred THEN DO:
                    if comis-deb-cred.deb-cred = yes then
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor * -1
                              de-debito               = de-debito               + comis-deb-cred.valor * -1
                              de-valor-comissao-tot = de-valor-comissao-tot     + comis-deb-cred.valor * -1
                              de-1 = -1.   
                    else
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor
                              de-credito              = de-credito              + comis-deb-cred.valor
                              de-valor-comissao-tot = de-valor-comissao-tot     + comis-deb-cred.valor
                              de-1 = 1.
                    
                    assign tt-comis-deb-cred.historico  = comis-deb-cred.historico
                           tt-comis-deb-cred.base-final = comis-deb-cred.base-final.
                END.

                find mov-comis
                     where mov-comis.cod-mov = comis-deb-cred.cod-mov no-lock no-error.

                put  stream s-resumo  mov-comis.descricao " : "
                                      comis-deb-cred.valor * de-1 format "->>>,>>>,>>9.99" 
                                      " ".
                    IF AVAIL tt-comis-deb-cred THEN
                       put stream s-resumo tt-comis-deb-cred.historico "~r~n".             
                    ELSE
                       PUT stream s-resumo   "" "~r~n".
           end.
           find emitente
                 where emitente.cgc = repres.cgc no-lock no-error.

           FIND int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-LOCK NO-ERROR.
           IF AVAIL int-emitente AND
               int-emitente.ind-forma-tributo = 3 THEN /* SIMPLES */
               ASSIGN de-ir = 0
                      de-valor-sem-ir = de-valor-comissao-tot.
           ELSE DO:
               ASSIGN de-ir = de-valor-comissao-tot * tt-param.fi-perc-ir / 100.
               IF de-ir >= 10 THEN
                  assign de-valor-sem-ir = de-valor-comissao-tot - de-valor-comissao-tot * tt-param.fi-perc-ir / 100.            
               ELSE
                  assign de-valor-sem-ir = de-valor-comissao-tot
                         de-ir           = 0.                 
           END.
    
           put  stream s-resumo "" "~r~n"
                               "---- DADOS PARA EMISSAO DA NOTA FISCAL -----------------------------------"           "~r~n".
           put  stream s-resumo "~r~n"
                                "TOTAL DA COMISSAO              : " de-valor-comissao-tot format "->>>,>>>,>>9.99"    "~r~n" "~r~n".  
           
           
           PUT  stream s-resumo "Imposto de Renda               : " tt-param.fi-perc-ir format ">>9.99"
                                                                 de-ir                 format "->>>,>>>,>>9.99"  "~r~n"
                              
                               "--------------------------------------------------------------------------"   "~r~n"
                               "" "~r~n".

           assign de-debito = 0
                  de-credito = 0.
           
           for each comis-deb-cred no-lock
               where comis-deb-cred.cod-estabel >= tt-param.fi-estab-ini
                 AND comis-deb-cred.cod-estabel <= tt-param.fi-estab-fim
                 AND comis-deb-cred.cod-rep = tt-comissao.cod-rep
                 and comis-deb-cred.base-final = no
                 and comis-deb-cred.dt-mov  >= dt-data-inicial
                 and comis-deb-cred.dt-mov  <= dt-data-final:
                find first tt-comis-deb-cred
                     where tt-comis-deb-cred.cod-estabel = comis-deb-cred.cod-estabel
                       AND tt-comis-deb-cred.cod-mov    = comis-deb-cred.cod-mov
                       AND tt-comis-deb-cred.unid-neg   = comis-deb-cred.unid-neg
                       AND tt-comis-deb-cred.base-final = comis-deb-cred.base-final
                       AND tt-comis-deb-cred.deb-cred   = comis-deb-cred.deb-cred
                     no-error.
                IF AVAIL tt-comis-deb-cred THEN DO:
                    if comis-deb-cred.deb-cred = yes then
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor * -1
                              de-debito               = de-debito               + comis-deb-cred.valor * -1
                              de-1 = -1.
                    else
                       assign tt-comis-deb-cred.valor = tt-comis-deb-cred.valor + comis-deb-cred.valor
                              de-credito              = de-credito              + comis-deb-cred.valor
                              de-1 = 1.

                    assign tt-comis-deb-cred.historico = comis-deb-cred.historico
                           tt-comis-deb-cred.base-final = comis-deb-cred.base-final.
                END.
                find mov-comis
                     where mov-comis.cod-mov = comis-deb-cred.cod-mov no-lock no-error.

                put  stream s-resumo  mov-comis.descricao " : "
                                   comis-deb-cred.valor * de-1 format "->>>,>>>,>>9.99" 
                                   " ".
                IF AVAIL tt-comis-deb-cred THEN
                   put stream s-resumo tt-comis-deb-cred.historico "~r~n".             
                ELSE
                   PUT stream s-resumo  "" "~r~n".

            end.

            assign de-a-receber = de-valor-sem-ir.
            
            for each tt-comis-deb-cred
                where tt-comis-deb-cred.base-final = no
                by tt-comis-deb-cred.cod-mov:                       

                assign de-a-receber = de-a-receber + tt-comis-deb-cred.valor. 
            end.
            
           put  stream s-resumo  "Total a Receber                : " de-a-receber format "->>>,>>>,>>9.99"  "~r~n~r~n".

           if tt-param.rs-previa-oficial = 2 then do:

               IF de-a-receber < 0 THEN DO:

                   FOR EACH comissao-fat-tot
                       WHERE comissao-fat-tot.cod-rep = tt-comissao.cod-rep
                         AND comissao-fat-tot.periodo = string(year(dt-data-inicial),"9999") + string(month(dt-data-inicial),"99"):

                       FIND FIRST comis-deb-cred
                            where /*comis-deb-cred.cod-estabel = comissao-fat-tot.cod-estabel
                              AND*/ comis-deb-cred.cod-rep     = comissao-fat-tot.cod-rep
                              and comis-deb-cred.base-final  = YES
                              and comis-deb-cred.dt-mov      = dt-data-final + 1 
                              AND comis-deb-cred.base-final  = YES
                              AND comis-deb-cred.cod-mov     = 13
                           NO-ERROR.             
                       IF NOT AVAIL comis-deb-cred THEN DO: 
                          CREATE comis-deb-cred.
                          ASSIGN comis-deb-cred.cod-estabel = comissao-fat-tot.cod-estabel       
                                 comis-deb-cred.cod-rep     = comissao-fat-tot.cod-rep           
                                 comis-deb-cred.dt-movto    = dt-data-final + 1             
                                 comis-deb-cred.deb-cred    = YES
                                 comis-deb-cred.base-final  = YES
                                 comis-deb-cred.cod-mov     = 13

                                 comis-deb-cred.valor       = de-a-receber  * -1
                                 comis-deb-cred.ct-codigo   = 41110005  
                                 comis-deb-cred.sc-codigo   = 21040             
                                 comis-deb-cred.historico   = "Referente saldo negativo de comissao no mes anterior"
                                 comis-deb-cred.unid-neg    = "TER".
                       END. /* IF NOT AVAIL comis-deb-cred THEN DO: */

                   END. /* FOR EACH comissao-fat-tot */

               END.

           END. /* if tt-param.rs-previa-oficial = 2 then do: */
            
           output stream s-resumo close.            
           if tt-param.envia-e-mail then do:

               /*assign c-arquivo-mail2 = c-dir-spool-servid-exec + "/" + tt-param.fi-estab-ini + "_" + STRING(repres.cod-rep) + "_notas.txt" . */

                FIND usuar_mestre
                     WHERE usuar_mestre.cod_usuario = tt-param.usuario
                     NO-LOCK NO-ERROR.
                IF AVAIL usuar_mestre THEN DO:
                    FIND b-emitente
                         WHERE b-emitente.cgc = repres.cgc
                         NO-LOCK NO-ERROR.
                    IF NOT AVAIL b-emitente THEN DO:        
                    /* ** Localiza o endereáo de e-mail da pessoa relacionada ao representante ***/
                        RUN esp/ftp/esftp056rp-a.p(INPUT tt-comissao.cod-estabel,
                                                   INPUT repres.cod-rep,
                                                   OUTPUT c-e-mail).
                    END.
                    ELSE DO:
                        ASSIGN c-e-mail = b-emitente.e-mail.
                    END.

                    FIND FIRST tt-arq-anexo 
                         WHERE tt-arq-anexo.cod-emitente-repre = tt-comissao.cod-emitente-repre NO-ERROR.

                    IF SEARCH(tt-arq-anexo.arquivo-mail2) = ? THEN
                        ASSIGN c-arquivo-mail = tt-arq-anexo.arquivo-mail.
                    ELSE
                        ASSIGN c-arquivo-mail = tt-arq-anexo.arquivo-mail + "," + tt-arq-anexo.arquivo-mail2.

                    /* Incidente 57926 */
                    FIND FIRST int-repres
                        WHERE int-repres.cod-repres = repres.cod-rep NO-LOCK NO-ERROR.
                    IF AVAIL int-repres THEN DO:

                        IF SUBSTRING(int-repres.char-1,3,1) = "n" 
                        OR SUBSTRING(int-repres.char-1,3,1) = " " THEN NEXT.
                        ELSE DO:

                            run piEnviaEmail (input trim(c-e-mail),
                                              input c-titulo-mail,
                                              input c-texto-mail,
                                              input trim(c-arquivo-mail)).
    

                        END. /* ELSE DO: */

                    END. /* IF AVAIL int-repres THEN DO: */

                END.

            end.
        end.          
    end.
    
    
END PROCEDURE.

PROCEDURE piEnviaEmail :
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(250)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)'  NO-UNDO.

    DEFINE VARIABLE icont AS INT. 
    DEFINE VARIABLE c-remetente AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-copia     AS CHARACTER   NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "esftp056",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FOR EACH tt-prog-ponto:
        IF ENTRY(1,tt-prog-ponto.conteudo,";") = "remetente" THEN
            ASSIGN c-remetente = ENTRY(2,tt-prog-ponto.conteudo,";").
    
        IF ENTRY(1,tt-prog-ponto.conteudo,";") = "copia" THEN
            ASSIGN c-copia = ENTRY(2,tt-prog-ponto.conteudo,";").
    END.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinat†rio       */ 
           tt-envio2.remetente         = c-remetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO"
           tt-envio2.copia             = c-copia.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
END PROCEDURE.
