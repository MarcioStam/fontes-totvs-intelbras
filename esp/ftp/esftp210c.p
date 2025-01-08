{utp/utapi019.i}
{esp/es0018.i}
{utp/ut-glob.i}
{include/pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE c-arquivos-gerados AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER r-row-id AS ROWID NO-UNDO.
DEFINE INPUT PARAMETER i-acao   AS INT   NO-UNDO.

DEFINE VARIABLE c-arquivo-pdf   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-cfop-reversa  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-niv-trib-icms AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-sub           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cst           AS CHARACTER FORMAT "x(3)"  NO-UNDO.
DEFINE VARIABLE v-base-icms-uni AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-base-icms-it  AS DECIMAL     NO-UNDO.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-pdf = "ESFTP210_" + STRING(TIME) + ".pdf":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Gerando PDF ...").

    RUN pi-gera-pdf.

    RUN pi-finalizar in h-acomp.
    RETURN "OK".   
END.


PROCEDURE pi-gera-pdf:

    FOR FIRST int-simula-dev NO-LOCK
        WHERE ROWID(int-simula-dev) = r-row-id:
    
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = int-simula-dev.cod-emitente NO-ERROR.

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = int-simula-dev.cod-estabel NO-ERROR.

        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = int-simula-dev.nome-transp NO-ERROR.

        ASSIGN c-arquivo-pdf = "ESFTP210_" + STRING(TIME) + "_" + STRING(int-simula-dev.nr-sequencia) + ".pdf":U.
        ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).

        ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U)
               c-arquivos-gerados = c-arq-pdf.
       
        RUN pdf_new ("Spdf",c-arq-pdf).
        RUN pdf_set_PaperType("Spdf","A4").
       
        /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
        RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-intelbras","image/logo-intelbras-grande.jpg").
        RUN pdf_new_page("Spdf").
       
        RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo simula‡Æo: " + STRING(int-simula-dev.nr-sequencia)).
        RUN pi-cabecalho. 

       RUN pi-dados-simulacao.

       RUN pi-observacao (INPUT int-simula-dev.narrativa).

       RUN pdf_close ("Spdf").  

       /*Somente gera o pdf*/
        IF i-acao = 1 THEN DO:
            OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.
        END.
        /*Envia e-mail*/
        ELSE DO:
            RUN enviaMail (INPUT "intelbras@intelbras.com.br",
                           INPUT emitente.e-mail,
                           INPUT "Orienta‡äes para NF de Devolu‡Æo",
                           INPUT "Segue anexo orienta‡äes para NF de Devolu‡Æo",
                           INPUT c-arq-pdf).
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-cabecalho:
    /**********Cabe‡alho**********/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               65, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               170,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               420 /*Width*/,
                               65, /* Height */
                               1  /* Weight */).

     RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 190 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               115, /* Height */ 
                               1  /* Weight */).
    
    
    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-intelbras",
                                     pdf_LeftMargin("Spdf"), /*LEFT*/
                                     pdf_PageHeight("Spdf") - 790, /*top*/
                                     pdf_LeftMargin("Spdf") + 145, 
                                     35).
    
    RUN pdf_set_font("Spdf","Courier-bold", 19).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Orienta‡äes para NF Devolu‡Æo",  210,  pdf_PageHeight("Spdf") - 40). 

    RUN pdf_set_font("Spdf","Courier-bold", 11). 

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cliente:",  33,  pdf_PageHeight("Spdf") - 90).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Fone:",  453,  pdf_PageHeight("Spdf") - 90).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endere‡o:",  26,  pdf_PageHeight("Spdf") - 105).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","IE:",  466,  pdf_PageHeight("Spdf") - 105).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cidade:",  39,  pdf_PageHeight("Spdf") - 120).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Transp:",  39,  pdf_PageHeight("Spdf") - 135).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ:",  453,  pdf_PageHeight("Spdf") - 120).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ:",  453,  pdf_PageHeight("Spdf") - 135).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endere‡o:",  26,  pdf_PageHeight("Spdf") - 150).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CEP:",  453,  pdf_PageHeight("Spdf") - 150).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cidade:",  39,  pdf_PageHeight("Spdf") - 165).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data:",  453,  pdf_PageHeight("Spdf") - 165).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","E-mail:",  39,  pdf_PageHeight("Spdf") - 180).    

    RUN pdf_set_font("Spdf","Courier", 10). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.nome),  88,  pdf_PageHeight("Spdf") - 90).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(emitente.telefone[1]),  485,  pdf_PageHeight("Spdf") - 90).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.endereco),  88,  pdf_PageHeight("Spdf") - 105).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.ins-estadual),  485,  pdf_PageHeight("Spdf") - 105).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.cidade),  88,  pdf_PageHeight("Spdf") - 120).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev.nome-transp),  88,  pdf_PageHeight("Spdf") - 135).                      
    IF AVAIL transporte THEN DO:
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(transporte.cgc),  485,  pdf_PageHeight("Spdf") - 135).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(transporte.endereco),  88,  pdf_PageHeight("Spdf") - 150).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(transporte.cep),  485,  pdf_PageHeight("Spdf") - 150).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(transporte.cidade),  88,  pdf_PageHeight("Spdf") - 165).                      
    END.

    IF int-simula-dev.frete-cif THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf","FRETE POR CONTA DO DESTINATµRIO",  395,  pdf_PageHeight("Spdf") - 180).                      

    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.cgc),  485,  pdf_PageHeight("Spdf") - 120).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev.dt-simula,"99/99/9999") + "-" + STRING(int-simula-dev.nr-sequencia,"99999"),  485,  pdf_PageHeight("Spdf") - 165).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev.email),  88,  pdf_PageHeight("Spdf") - 180).                      

END PROCEDURE.

PROCEDURE pi-dados-simulacao:
    DEFINE VARIABLE i-linha-item    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-tot-simula    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-total         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-tot-ipi       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-tot-icms      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-tot-icmsst    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-tot-peso      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-nota-orig     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE d-qtde-tot-item AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-icms      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-tot-ipi       AS DECIMAL     NO-UNDO.

    RUN pi-label.

    ASSIGN i-linha-item = 600.
    
    FOR EACH int-simula-dev-it OF int-simula-dev NO-LOCK
        BREAK BY int-simula-dev-it.it-codigo
              BY int-simula-dev-it.vl-unitario:

        IF FIRST-OF(int-simula-dev-it.it-codigo) THEN DO:
            ASSIGN c-nota-orig = ""
                 /*  d-qtde-tot-item = 0
                   d-tot-icms      = 0
                   d-tot-ipi       = 0. */.
        END. 

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = int-simula-dev-it.it-codigo NO-ERROR.

        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.nr-nota-fis = int-simula-dev-it.nr-nota-origem 
               AND nota-fiscal.cod-estabel = int-simula-dev-it.cod-estabel-origem 
               AND nota-fiscal.serie       = int-simula-dev-it.serie-origem NO-ERROR.

        FIND FIRST it-nota-fisc NO-LOCK
             WHERE it-nota-fisc.nr-nota-fis  = int-simula-dev-it.nr-nota-origem 
               AND it-nota-fisc.cod-estabel  = int-simula-dev-it.cod-estabel-origem 
               AND it-nota-fisc.serie        = int-simula-dev-it.serie-origem 
               AND it-nota-fisc.it-codigo    = int-simula-dev-it.it-codigo NO-ERROR.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.

        FIND FIRST int-cfop-natur NO-LOCK
             WHERE int-cfop-natur.cod-cfop = natur-oper.cod-cfop NO-ERROR.

        IF AVAIL int-cfop-natur THEN
            ASSIGN c-cfop-reversa = int-cfop-natur.cod-cfop-reversa.
        ELSE 
            ASSIGN c-cfop-reversa = "".

        IF i-linha-item <= 190 THEN DO:
            RUN pi-observacao (INPUT int-simula-dev.narrativa).
            ASSIGN i-linha-item = 600.
            RUN pdf_new_page("Spdf").
            RUN pi-cabecalho. 
            RUN pi-label.
        END.

        ASSIGN c-nota-orig = /*c-nota-orig +*/ int-simula-dev-it.cod-estabel-origem + "/" + 
                                           int-simula-dev-it.serie-origem + "/" + 
                                           int-simula-dev-it.nr-nota-origem + "-" + STRING(nota-fiscal.dt-emis-nota,"99/99/9999") + " ". 

        ASSIGN d-qtde-tot-item = /*d-qtde-tot-item +*/ int-simula-dev-it.qt-devolvida
               d-tot-icms      = /*d-tot-icms      +*/ int-simula-dev-it.vl-icms.

        RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                           OUTPUT i-niv-trib-icms,      
                           OUTPUT l-sub).

        ASSIGN c-cst = STRING(item.codigo-orig) + STRING(i-niv-trib-icms, "99").

        IF c-cst BEGINS "1" THEN
            OVERLAY(c-cst,1,1) = "2".

        IF c-cst BEGINS "6" THEN
            OVERLAY(c-cst,1,1) = "7".

        ASSIGN v-total      = v-total      + (int-simula-dev-it.qt-devolvida * int-simula-dev-it.vl-unitario)
               v-tot-ipi    = v-tot-ipi    + int-simula-dev-it.vl-ipi
               v-tot-icms   = v-tot-icms   + int-simula-dev-it.vl-icms
               v-tot-icmsst = v-tot-icmsst + int-simula-dev-it.vl-icmsst
               v-tot-simula = v-tot-simula + int-simula-dev-it.vl-tot-it
               v-tot-peso   = v-tot-peso   + (ITEM.peso-bruto * int-simula-dev-it.qt-devolvida).

       /* IF NOT LAST-OF(int-simula-dev-it.it-codigo) THEN
            NEXT. */

        ASSIGN v-base-icms-uni = it-nota-fisc.vl-bicms-it / it-nota-fisc.qt-faturada[1]
               v-base-icms-it  = v-base-icms-uni * d-qtde-tot-item.
        
        RUN pdf_set_font("Spdf","Courier", 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.it-codigo, 7, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(item.desc-item,1,32), 37, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf","NF Orig:",37, i-linha-item - 8).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",c-nota-orig, 75, i-linha-item - 8).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",c-cst, 170, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",c-cfop-reversa, 188, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",it-nota-fisc.un[1], 220, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(d-qtde-tot-item,">>>,>>9"), 230, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev-it.vl-unitario,">>>,>>>,>>9.99"), 243, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-base-icms-it,">,>>>,>>9.99"), 304, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(it-nota-fisc.aliquota-icm,">9"), 372, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(d-tot-icms,">>>,>>>,>>9.99"), 375, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev-it.vl-icmsst,">>>,>>>,>>9.99"), 424, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(it-nota-fisc.aliquota-ipi,">>>,>>>,>>9.99"), 453, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev-it.vl-ipi,">>>,>>>,>>9.99"), 485, i-linha-item + 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(int-simula-dev-it.vl-unitario * d-qtde-tot-item,">>>,>>>,>>9.99"), 534, i-linha-item + 6).
        

        RUN pdf_line ("Spdf",
                      5,
                      i-linha-item - 17,
                      pdf_PageWidth("Spdf") - 5,
                      i-linha-item - 17,
                      0.1).

        ASSIGN i-linha-item = i-linha-item - 38.
    END.

    RUN pdf_set_font("Spdf","Courier-bold", 6).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","PESO BRUTO TOTAL: " + STRING(v-tot-peso), 100, i-linha-item + 6).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","TOTAIS:", 250, i-linha-item + 6).
    /*RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-total,">>>,>>>,>>9.99"), 290, i-linha-item + 6).*/
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-tot-icms,">>>,>>>,>>9.99"), 375, i-linha-item + 6).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-tot-ipi,">>>,>>>,>>9.99"), 485, i-linha-item + 6).
    /*RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-tot-icmsst,">>>,>>>,>>9.99"), 455, i-linha-item + 6).*/
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(v-tot-simula,">>>,>>>,>>9.99"), 534, i-linha-item + 6).
    
END PROCEDURE.

PROCEDURE pi-observacao:
    DEFINE INPUT PARAM p-observacao LIKE nota-fiscal.observ-nota.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               15 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               130, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier-bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","OBSERVA€ÇO", 15, 150). 
    RUN pdf_set_font("Spdf","Courier", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,1,94), 15, 130). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,95,94), 15, 120). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,189,94), 15, 110). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,283,94), 15, 100). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,377,94), 15, 90). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,471,94), 15, 80). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,565,94), 15, 70). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,659,94), 15, 60). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,753,94), 15, 50). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,847,94), 15, 40). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,941,94), 15, 30). 
END PROCEDURE.

PROCEDURE pi-envia-email:
    DEFINE VARIABLE c-mail-destino AS CHARACTER   NO-UNDO.

    FOR EACH cont-emit NO-LOCK
       WHERE cont-emit.cod-emitente = nota-fiscal.cod-emitente
         AND cont-emit.nome begins 'NFE':
        IF c-mail-destino = "" THEN
            ASSIGN c-mail-destino = cont-emit.e-mail.
        ELSE 
            ASSIGN c-mail-destino = c-mail-destino + "," + cont-emit.e-mail.
    END.

    RUN enviaMail (INPUT "ems@intelbras.com.br",
                   INPUT c-mail-destino,
                   INPUT "Fatura de Loca‡Æo - " + nota-fiscal.nr-nota-fis,
                   INPUT "Segue anexo nota fiscal fatura.",
                   INPUT replace(c-arquivos-gerados,", ", ",")).

END PROCEDURE.

PROCEDURE enviaMail:

    define input parameter pRemetente    as character no-undo.
    define input parameter pDestinatario as character no-undo.
    define input parameter pAssunto      as character no-undo.
    define input parameter pMensagem     as character no-undo.
    define input parameter pAnexo        as character no-undo.
    
    define variable h-utapi019 as handle      no-undo.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    create tt-envio2.
    assign tt-envio2.versao-integracao  = 1
           tt-envio2.servidor           = param-global.serv-mail
           tt-envio2.porta              = param-global.porta-mail
           tt-envio2.exchange           = param-global.log-1
           tt-envio2.remetente          = pRemetente
           tt-envio2.destino            = pDestinatario
           tt-envio2.assunto            = pAssunto
           tt-envio2.mensagem           = pMensagem
           tt-envio2.arq-anexo          = pAnexo
           tt-envio2.importancia        = 1
           tt-envio2.log-enviada        = no
           tt-envio2.log-lida           = no
           tt-envio2.acomp              = no
           tt-envio2.formato            = 'TEXTO'.
    
    run utp/utapi019.p persistent set h-utapi019.
    run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).

    delete object h-utapi019.

END PROCEDURE.

PROCEDURE pi-label:
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               620 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               25, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier-bold", 7).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","C¢digo", 7, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descri‡Æo", 37, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CST", 170, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CFOP R.", 188, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Un.", 220, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde", 238, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vl Unit", 265, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Base ICMS", 310, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","% ICMS", 355, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ICMS", 410, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ICMS ST", 445, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","% IPI", 483, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","IPI", 523, 630). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Total", 563, 630). 
END PROCEDURE.
