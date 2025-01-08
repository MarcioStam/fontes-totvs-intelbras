{esp/es0018.i}
{esp/ftp/esftp083tt.i}
{include/pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE c-arquivo-pdf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-pdf   AS CHARACTER   NO-UNDO.


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD nome-abrev       LIKE emitente.nome-abrev
    FIELD nat-operacao     LIKE natur-oper.nat-operacao
    FIELD nome-transp      LIKE transporte.nome-abrev.

define temp-table tt-digita no-undo
    field it-codigo    LIKE ITEM.it-codigo
    FIELD desc-item    LIKE ITEM.desc-item
    field qtde         AS DEC FORMAT ">>>>>>>>9.99" COLUMN-LABEL "Quantidade"
    index idx it-codigo.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

/* create tt-param.                              */
/* ASSIGN tt-param.nome-transp  = "Translovato"  */
/*        tt-param.nat-operacao = "6107es"       */
/*        tt-param.cod-estabel  = "104"          */
/*        tt-param.nome-abrev   = "03681738602". */
/*                                               */
/* CREATE tt-digita.                             */
/* ASSIGN tt-digita.it-codigo = "4849281".       */

raw-transfer raw-param to tt-param. 

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-pdf = "esftp216_" + STRING(TIME) + ".pdf":U.

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
        ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).

        ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U).
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
    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = tt-param.nome-abrev NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = tt-param.cod-estabel NO-ERROR.
   
    RUN pdf_new ("Spdf",c-arq-pdf).
    RUN pdf_set_PaperType("Spdf","A4").
   
    /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
    RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-intelbras","image/logo-intelbras-grande.jpg").
    RUN pdf_new_page("Spdf").
   
    RUN pi-acompanhar  IN h-acomp (INPUT "Simulando c lculo").
    RUN pi-cabecalho. 
    RUN pi-item.
    RUN pi-estrutura. 
    RUN pdf_close ("Spdf").  
    
    OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.

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
                               pdf_PageHeight("Spdf") - 160 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               80, /* Height */ 
                               1  /* Weight */).
    
    
    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-intelbras",
                                     pdf_LeftMargin("Spdf"), /*LEFT*/
                                     pdf_PageHeight("Spdf") - 790, /*top*/
                                     pdf_LeftMargin("Spdf") + 145, 
                                     35).
    
    RUN pdf_set_font("Spdf","Courier-bold", 16).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","SIMULA€ÇO DE VOLUMES",  290,  pdf_PageHeight("Spdf") - 40). 

    RUN pdf_set_font("Spdf","Courier-bold", 11). 

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cliente:",  33,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Transportador:",  413,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endere‡o:",  26,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cidade:",  39,  pdf_PageHeight("Spdf") - 130).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Natureza:",  446,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data:",  52,  pdf_PageHeight("Spdf") - 145).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Estabelecimeto:",  406,  pdf_PageHeight("Spdf") - 130).                      
    

    RUN pdf_set_font("Spdf","Courier", 10). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.nome),  88,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-param.nome-transp),  510,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.endereco),  88,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.cidade),  88,  pdf_PageHeight("Spdf") - 130).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(TODAY,"99/99/9999"),  88,  pdf_PageHeight("Spdf") - 145).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-param.nat-operacao),  510,  pdf_PageHeight("Spdf") - 115).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-param.cod-estabel),  510,  pdf_PageHeight("Spdf") - 130).
              

END PROCEDURE.

PROCEDURE pi-item:
    DEFINE VARIABLE p-erros      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esftp083   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-nr-volumes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE d-volume     AS DECIMAL  FORMAT ">>>>>>9,99"  DECIMALS 2 NO-UNDO.

    FOR EACH tt-digita:
        CREATE tt-itens-calculo.
        ASSIGN tt-itens-calculo.it-codigo  = tt-digita.it-codigo
               tt-itens-calculo.quantidade = tt-digita.qtde.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-digita.it-codigo NO-ERROR.

/*         /** para Geradores Solar, explode a estrutura **/                */
        IF ITEM.cod-unid-neg = 'ENS' THEN DO:
           FIND FIRST estrutura NO-LOCK
                WHERE estrutura.it-codigo = ITEM.it-codigo NO-ERROR.

           IF AVAIL estrutura THEN
              DELETE tt-itens-calculo.

           FOR EACH estrutura NO-LOCK
              WHERE estrutura.it-codigo = ITEM.it-codigo
                AND estrutura.data-inicio  <= TODAY
                AND estrutura.data-termino >  TODAY:

             CREATE tt-itens-calculo.
             ASSIGN tt-itens-calculo.it-codigo  = estrutura.es-codigo
                    tt-itens-calculo.quantidade = estrutura.quant-usada.
           END.
        END.
    END.         
     
    RUN esp/ftp/esftp083.p PERSISTENT SET h-esftp083.
    EMPTY TEMP-TABLE tt-volumes.

    RUN pi-calcula-volumes IN h-esftp083 (INPUT emitente.cod-emitente,
                                          INPUT tt-param.nat-operacao,
                                          INPUT tt-param.cod-estabel,
                                          INPUT tt-param.nome-transp,
                                          INPUT  TABLE tt-itens-calculo,
                                          OUTPUT TABLE tt-volumes,
                                          OUTPUT p-erros).
    
    DELETE PROCEDURE h-esftp083.
    ASSIGN h-esftp083 = ?.

    IF CAN-FIND(FIRST tt-volumes) THEN DO:
        FOR LAST tt-volumes:
/*                 DISP tt-volumes.it-codigo          */
/*                      tt-volumes.nr-volume          */
/*                      tt-volumes.qtde               */
/*                      tt-volumes.sigla-emb          */
/*                      tt-volumes.varios-itens SKIP. */
            ASSIGN i-nr-volumes = tt-volumes.nr-volume. 
        END.

        FOR EACH tt-volumes:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-volumes.it-codigo NO-ERROR.
            ASSIGN d-volume = d-volume + (((item.altura / 100) * (item.largura / 100) * (item.comprim / 100)) * tt-volumes.qtde).
        END.
     END.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 205 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               35, /* Height */
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Courier-bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Volumes:",  99,  pdf_PageHeight("Spdf") - 190).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cubagem:",  470,  pdf_PageHeight("Spdf") - 190).

    RUN pdf_set_font("Spdf","Courier", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(i-nr-volumes),  155,  pdf_PageHeight("Spdf") - 190).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(d-volume),  525,  pdf_PageHeight("Spdf") - 190).

END PROCEDURE.

PROCEDURE pi-estrutura:
    DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 230 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = 612.

    RUN pdf_set_font("Spdf","Courier-bold", 11). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vol.",  15,  pdf_PageHeight("Spdf") - 225).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Comp.",  50,  pdf_PageHeight("Spdf") - 225).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descri‡Æo",  100,  pdf_PageHeight("Spdf") - 225).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde",  460,  pdf_PageHeight("Spdf") - 225).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","V rios Itens",  500,  pdf_PageHeight("Spdf") - 225).                      

    /*Solar, somente 1 item*/
    FOR EACH tt-volumes:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-volumes.it-codigo NO-ERROR.

        ASSIGN i-linha = i-linha - 15.
        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                    5,    /*From Column*/
                                    i-linha /*From  Row*/,
                                    pdf_PageWidth("Spdf") - 10 /*Width*/,
                                    15, /* Height */
                                    1  /* Weight */).

        RUN pdf_set_font("Spdf","Courier", 10).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-volumes.nr-volume),  20,  i-linha + 4).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-volumes.it-codigo),  50,  i-linha + 4).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(ITEM.desc-item,1,60),  100,  i-linha + 4).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-volumes.qtde,  460,  i-linha + 4).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-volumes.varios-itens,"Sim/NÆo"),  500,  i-linha + 4).
/*         RUN pdf_text_xy IN h_PDFinc ("Spdf",estrutura.es-codigo,  90,  i-linha + 4).            */
/*         RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  170,  i-linha + 4).                */
/*         RUN pdf_text_xy IN h_PDFinc ("Spdf",string(estrutura.quant-usada),  520,  i-linha + 4). */
    END.
END PROCEDURE

