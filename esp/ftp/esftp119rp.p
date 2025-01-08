{utp/utapi019.i}
{esp/es0018.i}
{utp/ut-glob.i}
{include/pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE c-arquivos-gerados AS CHARACTER   NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estab-ini    LIKE nota-fiscal.cod-estabel
    FIELD cod-estab-fim    LIKE nota-fiscal.cod-estabel
    FIELD serie-ini        LIKE nota-fiscal.serie
    FIELD serie-fim        LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE nota-fiscal.nr-nota-fis
    FIELD l-envia-email    AS LOG INITIAL NO
    FIELD l-imprime-trib   AS LOG INITIAL NO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE c-arquivo-pdf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-endereco    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tributos    AS CHARACTER   FORMAT "x(200)" NO-UNDO.
DEFINE VARIABLE d-vl-icms     AS DEC         NO-UNDO.
DEFINE VARIABLE d-vl-ipi      AS DEC         NO-UNDO.
DEFINE VARIABLE d-vl-st       AS DEC         NO-UNDO.

DEFINE BUFFER bf-it-nota-fisc FOR it-nota-fisc.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-pdf = "ESFTP119_" + STRING(TIME) + ".pdf":U.

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

    /*RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Arquivos Gerados: ~~" + c-arquivos-gerados).*/
    
    RUN pi-finalizar in h-acomp.
    RETURN "OK".   
END.


PROCEDURE pi-gera-pdf:
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.cod-estabel >= tt-param.cod-estab-ini
         AND nota-fiscal.cod-estabel <= tt-param.cod-estab-fim
         AND nota-fiscal.serie       >= tt-param.serie-ini
         AND nota-fiscal.serie       <= tt-param.serie-fim
         AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-fis-ini
         AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fis-fim:

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

        FIND FIRST mensagem NO-LOCK
             WHERE mensagem.cod-mensagem = natur-oper.cod-mensage NO-ERROR.

        /*Chamado 99798*/
        FIND FIRST ser-estab NO-LOCK
             WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
               AND ser-estab.serie       = nota-fiscal.serie NO-ERROR.
        
        /*Nota de fatura*/
/*         IF  AVAIL ser-estab                                */
/*         AND ser-estab.log-nf-eletro = NO                   */
/*         AND SUBSTR(ser-estab.char-1,71,1) <> "S"  THEN DO: */

            FOR EACH fat-duplic NO-LOCK
               WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                 AND fat-duplic.serie       = nota-fiscal.serie
                 AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
                ASSIGN c-arquivo-pdf = "ESFTP119_" + STRING(TIME) + "_" + STRING(fat-duplic.nr-fatura) + "_" + STRING(fat-duplic.parcela) + ".pdf":U.
                ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).
    
               /* Alteracao para gravar arquivo pdf executado via linux */
                IF  OPSYS = "WIN32" THEN DO:
                     ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U).
                
                     MESSAGE c-arq-pdf                     
                         VIEW-AS ALERT-BOX INFO BUTTONS OK.
                
                END.

                IF c-arquivos-gerados = "" THEN
                    ASSIGN c-arquivos-gerados = c-arq-pdf.
                ELSE 
                    ASSIGN c-arquivos-gerados = c-arquivos-gerados + ", " + c-arq-pdf.
               
                RUN pdf_new ("Spdf",c-arq-pdf).
                RUN pdf_set_PaperType("Spdf","A4").
               
                /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
                RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-intelbras","image/logo-intelbras-grande.jpg").
                RUN pdf_new_page("Spdf").
               
                RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo cabeáalho fatura: " + STRING(fat-duplic.nr-fatura)).
                RUN pi-cabecalho (INPUT fat-duplic.nr-fatura,
                                  INPUT fat-duplic.parcela,
                                  INPUT nota-fiscal.serie,
                                  INPUT nota-fiscal.dt-emis,
                                  INPUT nota-fiscal.cod-estabel). 
               
                RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo destinat†tio fatura: " + STRING(fat-duplic.nr-fatura)).
                RUN pi-destinatario (INPUT emitente.nome-emit,
                                     INPUT nota-fiscal.cgc,
                                     INPUT nota-fiscal.endereco,
                                     INPUT nota-fiscal.bairro,
                                     INPUT nota-fiscal.cep,
                                     INPUT nota-fiscal.estado,
                                     INPUT nota-fiscal.cidade,
                                     INPUT nota-fiscal.ins-estadual,
                                     INPUT emitente.telefone[1]).
    
               RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo fatura: " + STRING(fat-duplic.nr-fatura)).

               FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK NO-ERROR.
               IF NOT AVAIL it-nota-fisc THEN NEXT.

               
               RUN pi-fatura (INPUT fat-duplic.nr-fatura,
                              INPUT fat-duplic.dt-venciment,
                              INPUT fat-duplic.vl-parcela - it-nota-fisc.val-retenc-csll - it-nota-fisc.val-retenc-pis - it-nota-fisc.val-retenc-cofins).

               ASSIGN c-tributos = "".
               IF tt-param.l-imprime-trib THEN DO:

                   ASSIGN d-vl-icms   = 0
                          d-vl-ipi    = 0
                          d-vl-st     = 0.

                   FOR EACH bf-it-nota-fisc OF nota-fiscal NO-LOCK:
                       ASSIGN d-vl-icms = d-vl-icms + bf-it-nota-fisc.vl-icms-it
                              d-vl-ipi  = d-vl-ipi  + bf-it-nota-fisc.vl-ipi-it
                              d-vl-st   = d-vl-st   + bf-it-nota-fisc.vl-icmsub-it.
                   END.

                   ASSIGN c-tributos = "   ICMS: " + string(d-vl-icms) + " " + /*CHR(10) +*/
                                       "    IPI: " + string(d-vl-ipi)  + " " + /*CHR(10) + */
                                       "ICMS ST: " + string(d-vl-st).
                                       
               END.

               RUN pi-dados-locacao.
    
               RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo observaá∆o fatura: " + STRING(fat-duplic.nr-fatura)).
               
               IF AVAIL mensagem 
               AND mensagem.cod-mensagem > 0 THEN
                   RUN pi-observacao (INPUT mensagem.texto-mensag + CHR(13) + c-tributos).
               ELSE
                   RUN pi-observacao (INPUT nota-fiscal.observ-nota +  CHR(13) + c-tributos).
    
               RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo rodapÇ fatura: " + STRING(fat-duplic.nr-fatura)).
               RUN pi-rodape (INPUT fat-duplic.nr-fatura,
                              INPUT nota-fiscal.nat-operacao). 
    
               RUN pdf_close ("Spdf").  
               
            END.

            IF tt-param.l-envia-email THEN
                RUN pi-envia-email.
/*         END. */
    END.
END PROCEDURE.

PROCEDURE pi-cabecalho:
    DEFINE INPUT PARAM p-nr-fatura   LIKE fat-duplic.nr-fatura.
    DEFINE INPUT PARAM p-parcela     LIKE fat-duplic.parcela.
    DEFINE INPUT PARAM p-serie       LIKE nota-fiscal.serie.
    DEFINE INPUT PARAM p-dt-emis     LIKE nota-fiscal.dt-emis.
    DEFINE INPUT PARAM p-cod-estabel LIKE nota-fiscal.cod-estabel.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = p-cod-estabel NO-ERROR.

    FIND FIRST estab-distrib NO-LOCK
         WHERE estab-distrib.cod-estab = p-cod-estabel NO-ERROR.

    /**********Cabeáalho**********/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               65, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               130,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               280 /*Width*/,
                               65, /* Height */ 
                               0.1  /* Weight */).
    
    
    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-intelbras",
                                     pdf_LeftMargin("Spdf"), /*LEFT*/
                                     pdf_PageHeight("Spdf") - 790, /*top*/
                                     pdf_LeftMargin("Spdf") + 105, 
                                     35).
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(estabelec.nome,1,26),  165,  pdf_PageHeight("Spdf") - 15). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(estabelec.nome,27,30),  195,  pdf_PageHeight("Spdf") - 25). 
    
    RUN pdf_set_font("Spdf","Courier", 10).

    ASSIGN c-endereco = estabelec.bairro + " - " + estabelec.cidade + " Cep: " + string(estabelec.cep) + "UF: " + estabelec.estado.
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.endereco,  185,  pdf_PageHeight("Spdf") - 40). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",c-endereco, 135,  pdf_PageHeight("Spdf") - 50). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ " + estabelec.cgc +  "  TEL.: " + estab-distrib.cod-telef, 135,  pdf_PageHeight("Spdf") - 65). 
    
    RUN pdf_set_font("Spdf","Courier-bold", 14).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","NOTA FATURA",  415,  pdf_PageHeight("Spdf") - 20). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-nr-fatura + "/" + p-parcela,  415,  pdf_PageHeight("Spdf") - 35). 
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","SÇrie: " + p-serie,  415,  pdf_PageHeight("Spdf") - 50). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Emiss∆o: " + STRING(p-dt-emis),  415,  pdf_PageHeight("Spdf") - 65). 
END PROCEDURE.

PROCEDURE pi-destinatario:
    DEFINE INPUT PARAM p-nome-emit    LIKE emitente.nome-emit.
    DEFINE INPUT PARAM p-cgc          LIKE nota-fiscal.cgc.
    DEFINE INPUT PARAM p-endereco     LIKE nota-fiscal.endereco.
    DEFINE INPUT PARAM p-bairro       LIKE nota-fiscal.bairro.
    DEFINE INPUT PARAM p-cep          LIKE nota-fiscal.cep.
    DEFINE INPUT PARAM p-estado       LIKE nota-fiscal.estado.
    DEFINE INPUT PARAM p-cidade       LIKE nota-fiscal.cidade.
    DEFINE INPUT PARAM p-ins-estadual LIKE nota-fiscal.ins-estadual.
    DEFINE INPUT PARAM p-telefone     LIKE emitente.telefone[1].
    

    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 220 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               150, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","DESTINATµRIO", 15,  pdf_PageHeight("Spdf") - 85). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Raz∆o Social/Nome Cliente", 15,  pdf_PageHeight("Spdf") - 110). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CPF/CNPJ", 320,  pdf_PageHeight("Spdf") - 110). 
    
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-nome-emit, 15,  pdf_PageHeight("Spdf") - 125). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-cgc, 320,  pdf_PageHeight("Spdf") - 125). 
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endereáo", 15,  pdf_PageHeight("Spdf") - 145). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Bairro", 320,  pdf_PageHeight("Spdf") - 145). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CEP", 450,  pdf_PageHeight("Spdf") - 145). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UF", 540,  pdf_PageHeight("Spdf") - 145). 
    
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-endereco, 15,  pdf_PageHeight("Spdf") - 160). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-bairro, 320,  pdf_PageHeight("Spdf") - 160). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-cep, 450,  pdf_PageHeight("Spdf") - 160). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-estado, 540,  pdf_PageHeight("Spdf") - 160). 
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cidade", 15,  pdf_PageHeight("Spdf") - 180). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Iscriá∆o Estadual", 320,  pdf_PageHeight("Spdf") - 180). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Telefone", 450,  pdf_PageHeight("Spdf") - 180). 
    
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-cidade, 15,  pdf_PageHeight("Spdf") - 195). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-ins-estadual, 320,  pdf_PageHeight("Spdf") - 195). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-telefone, 450,  pdf_PageHeight("Spdf") - 195). 
END PROCEDURE.

PROCEDURE pi-fatura:
    DEFINE INPUT PARAM p-nr-fatura    LIKE fat-duplic.nr-fatura.
    DEFINE INPUT PARAM p-dt-venciment LIKE fat-duplic.dt-venciment.
    DEFINE INPUT PARAM p-vl-parcela   LIKE fat-duplic.vl-parcela.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 270 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               50, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","FATURA/DUPLICATA", 15,  pdf_PageHeight("Spdf") - 240). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","VENCIMENTO", 150,  pdf_PageHeight("Spdf") - 240). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","VALOR LIQ", 250,  pdf_PageHeight("Spdf") - 240). 
    
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-nr-fatura, 15,  pdf_PageHeight("Spdf") - 255). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(p-dt-venciment), 150,  pdf_PageHeight("Spdf") - 255). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","R$" + STRING(p-vl-parcela), 250,  pdf_PageHeight("Spdf") - 255). 
END PROCEDURE.

PROCEDURE pi-dados-locacao:
    DEFINE VARIABLE i-linha-item AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-tot-fatura AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INT NO-UNDO.    
    DEFINE VAR i-multiplo AS INT NO-UNDO.

    ASSIGN i-multiplo = 12.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               525 /* 220 From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               525, /* 352 Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","DADOS DA LOCAÄ«O", 15, 555). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","C¢digo", 15, 530). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o/Configuraá∆o", 70, 530). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade", 315, 530). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor Unit†rio", 395, 530). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor Total", 500, 530). 
    
    RUN pdf_line ("Spdf",
                  5,
                  525,
                  pdf_PageWidth("Spdf") - 10,
                  525,
                  0.1).
    
    ASSIGN i-linha-item = 500.
    
    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        ASSIGN i-cont = i-cont + 1.

        IF i-cont MOD i-multiplo = 0 THEN DO:
            
            ASSIGN i-linha-item = 500.

            RUN pdf_new_page("Spdf").
            
            RUN pi-cabecalho (INPUT fat-duplic.nr-fatura,
                                  INPUT fat-duplic.parcela,
                                  INPUT nota-fiscal.serie,
                                  INPUT nota-fiscal.dt-emis,
                                  INPUT nota-fiscal.cod-estabel).

            RUN pi-destinatario (INPUT emitente.nome-emit,
                                     INPUT nota-fiscal.cgc,
                                     INPUT nota-fiscal.endereco,
                                     INPUT nota-fiscal.bairro,
                                     INPUT nota-fiscal.cep,
                                     INPUT nota-fiscal.estado,
                                     INPUT nota-fiscal.cidade,
                                     INPUT nota-fiscal.ins-estadual,
                                     INPUT emitente.telefone[1]).

            RUN pi-fatura (INPUT fat-duplic.nr-fatura,
                              INPUT fat-duplic.dt-venciment,
                              INPUT fat-duplic.vl-parcela - it-nota-fisc.val-retenc-csll - it-nota-fisc.val-retenc-pis - it-nota-fisc.val-retenc-cofins).

            RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               525 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               525, /* Height */ 
                               1  /* Weight */).

            RUN pdf_set_font("Spdf","Courier-bold", 11).
            RUN pdf_text_xy IN h_PDFinc ("Spdf","DADOS DA LOCAÄ«O", 15, 555). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","C¢digo", 15, 530). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o/Configuraá∆o", 70, 530). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade", 315, 530). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor Unit†rio", 395, 530). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor Total", 500, 530). 
            
        END.



        RUN pdf_set_font("Spdf","Courier", 10).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.it-codigo, 15, i-linha-item + 6). 
    
        IF LENGTH(ITEM.desc-item) <= 39 THEN
            RUN pdf_text_xy IN h_PDFinc ("Spdf",item.desc-item, 70, i-linha-item + 6). 
        ELSE DO:
            RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(item.desc-item,1,39), 70, i-linha-item + 13). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(item.desc-item,40,39), 70, i-linha-item + 3). 
        END.

        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(it-nota-fisc.qt-faturada[1]), 315, i-linha-item + 6). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf", "R$ " + STRING(it-nota-fisc.vl-merc-liq / it-nota-fisc.qt-faturada[1]), 395, i-linha-item + 6). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf", "R$ " + STRING(it-nota-fisc.vl-tot-item), 500, i-linha-item + 6). 
    
        ASSIGN v-tot-fatura = v-tot-fatura + (it-nota-fisc.vl-tot-item - it-nota-fisc.val-retenc-pis - it-nota-fisc.val-retenc-csll - it-nota-fisc.val-retenc-cofins - it-nota-fisc.vl-irf-it).

        RUN pdf_line ("Spdf",
                      5,
                      i-linha-item - 5,
                      pdf_PageWidth("Spdf") - 5,
                      i-linha-item - 5,
                      0.1). 
    
        ASSIGN i-linha-item = i-linha-item - 30.
    END.
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               120 /* 220 From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               130, /* 352 Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor Total da Fatura:", 350, 225). 
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf", "R$ " + STRING(v-tot-fatura), 500, 225). 
END PROCEDURE.

PROCEDURE pi-observacao:
    DEFINE INPUT PARAM p-observacao LIKE nota-fiscal.observ-nota.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               90 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               130, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","OBSERVAÄ«O", 15, 205). 
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,1,94), 15, 190). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,95,94), 15, 180). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,189,94), 15, 170). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,283,94), 15, 160). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,377,94), 15, 150). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,471,94), 15, 140). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,565,94), 15, 130). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,669,94), 15, 120). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(p-observacao,753,94), 15, 110). 
END PROCEDURE.

PROCEDURE pi-rodape:
    DEFINE INPUT PARAM p-nr-fatura    LIKE fat-duplic.nr-fatura.
    DEFINE INPUT PARAM p-nat-operacao LIKE nota-fiscal.nat-operacao.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = p-nat-operacao NO-ERROR.

    RUN pdf_set_dash ("Spdf", 10,10).

    RUN pdf_line ("Spdf",
                  5,
                  85,
                  pdf_PageWidth("Spdf") - 5,
                  85,
                  0.5).
    
    RUN pdf_set_dash ("Spdf", 1,0).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               55 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               25, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               55 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 154 /*Width*/,
                               25, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier", 10).

    IF AVAIL natur-oper THEN DO:
        RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(natur-oper.narrativa,1,67), 10, 70). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(natur-oper.narrativa,68,70), 10, 60). 
    END.
    ELSE DO:
        RUN pdf_text_xy IN h_PDFinc ("Spdf","RECEBI(EMOS) DE INTELBRAS S/A - IND DE TEL ELET BRASILEIRA AS LOCAÄÂES", 10, 70). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","CONSTANTES NESSA FATURA INDICADA AO LADO.", 10, 60). 
    END.
    
    RUN pdf_set_font("Spdf","Courier-bold", 13).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","NOTA FATURA", 450, 63). 
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               5 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               50, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               166,    /*From Column*/
                               5 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 315 /*Width*/,
                               50, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","DATA DO RECEBIMENTO", 10, 45). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","IDENTIFICAÄ«O E ASSINATURA DO RECEBEDOR", 170, 45). 
    
    RUN pdf_set_font("Spdf","Courier-bold", 15).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Nß: " + STRING(p-nr-fatura), 450, 25). 
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
                   INPUT "Fatura de Locaá∆o - " + nota-fiscal.nr-nota-fis,
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
