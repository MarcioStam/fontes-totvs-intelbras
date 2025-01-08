{esp/es0018.i}
{utp/ut-glob.i}
{include/pdf_inc.i "THIS-PROCEDURE"}


DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    FIELD ordem-avulsa     AS LOG
    FIELD nao-impressas    AS LOG
    FIELD numero-ordem-ini LIKE ord-prod.nr-ord-prod
    FIELD numero-ordem-fim LIKE ord-prod.nr-ord-prod
    FIELD it-codigo-ini    LIKE ord-prod.it-codigo
    FIELD it-codigo-fim    LIKE ord-prod.it-codigo
    field l-habilitaRtf    as LOG
    FIELD cod-estabel      LIKE ord-prod.cod-estabel
    FIELD imp-pagina       AS LOG.

define temp-table tt-digita no-undo
    FIELD l-selecionado    AS LOG
    field nr-pedcli        LIKE ped-venda.nr-pedcli
    FIELD nr-sequencia     LIKE ord-prod.nr-sequencia
    field nome-abrev       LIKE ped-venda.nome-abrev
    FIELD nome-emit        LIKE emitente.nome-emit
    FIELD it-codigo        LIKE ped-item.it-codigo
    FIELD dt-emis          LIKE ped-venda.dt-emis
    FIELD l-impresso       AS LOG
    FIELD nr-ord-prod      LIKE ord-prod.nr-ord-prod
    FIELD r-ped-item       AS CHAR.

DEF TEMP-TABLE tt-desenho-item
    FIELD it-codigo AS CHAR
    INDEX idx it-codigo.

DEF TEMP-TABLE tt-pag-observ
    FIELD pag AS INT
    INDEX idx pag.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

DEFINE VARIABLE c-arquivo-pdf    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-row            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-col            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-aux       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-aux2      AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-item-imp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-nr-seq-imp     LIKE ord-prod.nr-sequencia.
DEFINE VARIABLE v-prox-seq       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qtd-lin        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pag-total      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pag-atual      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tmp            AS DEC         NO-UNDO.
DEFINE VARIABLE h-bcapi016       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-bar-code       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista-um-tempo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE nr-ord-prod-matriz LIKE ord-prod.nr-ord-prod.
DEFINE VARIABLE c-dir-desenho    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-nivel     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-saida AS INTEGER     NO-UNDO.

DEFINE BUFFER b-ord-prod FOR ord-prod.

DEFINE BUFFER b-item      FOR ITEM.
DEFINE BUFFER b-estrutura FOR estrutura.

DEFINE TEMP-TABLE tt-roteiro NO-UNDO
    FIELD seq          AS INT
    FIELD operacao     AS CHAR
    FIELD recurso      AS CHAR
    FIELD tempo        AS CHAR
    FIELD tempo-maquin LIKE operacao.tempo-maquin
    FIELD un-med-tempo LIKE operacao.un-med-tempo.

DEFINE TEMP-TABLE tt-saida
    FIELD it-pai         LIKE estrutura.it-codigo
    FIELD it-pai-desc    LIKE ITEM.desc-item 
    FIELD it-filho       LIKE estrutura.es-codigo
    FIELD it-filho-desc  LIKE item.desc-item
    FIELD nivel          AS INTEGER FORMAT "99"
    FIELD tipo           AS CHAR FORMAT "x(10)"
    FIELD quantidade     LIKE estrutura.quant-usada
    FIELD seq            AS INT
    FIELD fantasma       AS CHAR
    FIELD un             LIKE ITEM.un.

DEFINE TEMP-TABLE tt-saida-semi LIKE tt-saida
    FIELD cc-codigo LIKE gm-estab.cc-codigo.

ASSIGN c-lista-um-tempo = {ininc/i02in261.i 03}.

DO ON STOP UNDO, LEAVE:

    FOR EACH tt-pag-observ: DELETE tt-pag-observ. END.

    ASSIGN c-arquivo-pdf = "ESCPP111_" + STRING(TIME) + ".pdf":U.

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

    ASSIGN c-arquivo-pdf = "ESCPP111_" + STRING(TIME) + ".pdf":U.
    
    ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).
    
    ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U).
    
    RUN pdf_new ("Spdf",c-arq-pdf).
    
    RUN pdf_set_PaperType("Spdf","A4").

    IF search("c:\windows\fonts\dc-code128.ttf") <> ? THEN
       RUN pdf_load_font ("Spdf","IQsCode128","c:\windows\fonts\dc-code128.ttf", "PDFinclude/dc-code128.afm","").
    
    /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/

    IF search("image/logo_decio.jpg") <> ? THEN
       RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-decio",search("image/logo_decio.jpg")). 

    IF search("image/registro_cotas2.jpg") <> ? THEN
       RUN pdf_load_image  IN h_PDFinc ("Spdf","regcotas",search("image/registro_cotas2.jpg")).

    FOR EACH tt-desenho-item: DELETE tt-desenho-item. END.

    /*Ordem avulsa*/
    IF tt-param.ordem-avulsa THEN DO:

        FOR EACH ord-prod NO-LOCK
           WHERE ord-prod.nr-ord-prod >= tt-param.numero-ordem-ini
             AND ord-prod.nr-ord-prod <= tt-param.numero-ordem-fim
             AND ord-prod.it-codigo >= tt-param.it-codigo-ini
             AND ord-prod.it-codigo <= tt-param.it-codigo-fim
             AND ord-prod.cod-estabel = tt-param.cod-estabel:
           
            IF tt-param.nao-impressas 
            AND NOT ord-prod.emite-ordem THEN
                NEXT.
        
            ASSIGN i-pag-atual = 0.

            
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli = ord-prod.nr-pedido NO-ERROR.
    
            /*Busca o item pai no pedido*/
            FIND FIRST ped-item OF ped-venda NO-LOCK
                 WHERE ped-item.nr-sequencia = ord-prod.nr-sequencia NO-ERROR.
    
            /*Busca a ordem do item pai*/
            FIND FIRST b-ord-prod NO-LOCK
                 WHERE b-ord-prod.nr-pedido     = ped-item.nr-pedcli
                   AND b-ord-prod.nr-sequencia  = ped-item.nr-sequencia
                   AND b-ord-prod.it-codigo     = ped-item.it-codigo NO-ERROR.
    
            ASSIGN nr-ord-prod-matriz = IF AVAIL b-ord-prod THEN b-ord-prod.nr-ord-prod ELSE 0.
    
            EMPTY TEMP-TABLE tt-digita.
            CREATE tt-digita.
            ASSIGN tt-digita.nome-abrev   = IF AVAIL ped-venda THEN ped-venda.nome-abrev ELSE ?
                   tt-digita.nr-pedcli    = IF AVAIL ped-venda THEN ped-venda.nr-pedcli ELSE ?
                   tt-digita.nr-sequencia = ord-prod.nr-sequencia
                   tt-digita.nr-ord-prod = ord-prod.nr-ord-prod.
    
            /*Gera a estrutura para imprimir o acabado*/
            EMPTY TEMP-TABLE tt-saida.
            RUN pi-ler-estrutura (INPUT ord-prod.it-codigo,INPUT ord-prod.nr-ord-prod).
    
            ASSIGN v-item-imp = ord-prod.it-codigo.

            RUN pi-geral (INPUT ord-prod.nr-ord-prod).
            
        END.
    END.
    ELSE DO:
        FOR EACH tt-digita
           WHERE tt-digita.l-selecionado:
    
            ASSIGN i-pag-atual = 0.
            FIND FIRST ord-prod NO-LOCK
                 WHERE ord-prod.nr-ord-prod = tt-digita.nr-ord-prod NO-ERROR.

            ASSIGN nr-ord-prod-matriz = ord-prod.nr-ord-prod.
        
            /*Gera a estrutura para imprimir o acabado*/
            EMPTY TEMP-TABLE tt-saida.
            RUN pi-ler-estrutura (INPUT ord-prod.it-codigo,INPUT ord-prod.nr-ord-prod).

            ASSIGN v-item-imp = ord-prod.it-codigo.
            RUN pi-geral (INPUT ord-prod.nr-ord-prod).

            /*Gera estrutura completa para imprimir o semi-acabado*/
            FIND FIRST ord-prod NO-LOCK
                 WHERE ord-prod.nr-ord-prod = tt-digita.nr-ord-prod NO-ERROR.
             
            EMPTY TEMP-TABLE tt-saida.
            RUN pi-ler-estrutura (INPUT ord-prod.it-codigo,INPUT ord-prod.nr-ord-prod).
        
            EMPTY TEMP-TABLE tt-saida-semi.
            FOR EACH tt-saida:
                CREATE tt-saida-semi.
                BUFFER-COPY tt-saida TO tt-saida-semi.


                FIND FIRST b-ord-prod NO-LOCK
                     WHERE b-ord-prod.nome-abrev    = tt-digita.nome-abrev
                       AND b-ord-prod.nr-pedido     = tt-digita.nr-pedcli
                       AND b-ord-prod.nr-sequencia  = tt-digita.nr-sequencia
                       AND b-ord-prod.it-codigo     = tt-saida-semi.it-filho NO-ERROR.


                FOR FIRST oper-ord OF b-ord-prod NO-LOCK,
                    FIRST gm-estab NO-LOCK
                    WHERE gm-estab.gm-codigo   = oper-ord.gm-codigo
                      AND gm-estab.cod-estabel = b-ord-prod.cod-estabel:
                
                    ASSIGN tt-saida-semi.cc-codigo = gm-estab.cc-codigo.
                END.
            END.
    
            EMPTY TEMP-TABLE tt-saida.
        
            FOR EACH tt-saida-semi
            BREAK BY tt-saida-semi.cc-codigo
                  BY tt-saida-semi.it-pai:

                FIND FIRST b-ord-prod NO-LOCK
                     WHERE b-ord-prod.nome-abrev = tt-digita.nome-abrev
                       AND b-ord-prod.nr-pedido  = tt-digita.nr-pedcli
                       AND b-ord-prod.nr-sequencia  = tt-digita.nr-sequencia
                       AND b-ord-prod.it-codigo  = tt-saida-semi.it-filho NO-ERROR.
    
                IF AVAIL b-ord-prod THEN DO:
                    RUN pi-ler-estrutura (INPUT b-ord-prod.it-codigo,INPUT b-ord-prod.nr-ord-prod).
                    
                    //IF AVAIL tt-saida THEN DO:
                        ASSIGN v-item-imp = b-ord-prod.it-codigo.
                        ASSIGN i-pag-atual = 0.
                        RUN pi-geral (INPUT b-ord-prod.nr-ord-prod).
                    //END.
        
                    EMPTY TEMP-TABLE tt-saida.
                END.
        
                //CREATE tt-saida.
                //BUFFER-COPY tt-saida-semi TO tt-saida.
            END.
        
    /*         FIND FIRST tt-saida                     */
    /*              WHERE tt-saida.nivel = 1 NO-ERROR. */
    /*                                                 */
    /*         ASSIGN v-item-imp = tt-saida.it-filho.  */
    /*         ASSIGN i-pag-atual = 0.                 */
    /*         RUN pi-geral.                           */
    
            /*Marca como impresso*/
            FIND FIRST ped-item NO-LOCK
                 WHERE rowid(ped-item) = TO-ROWID(tt-digita.r-ped-item) NO-ERROR.
    
            IF AVAIL ped-item THEN DO:
                FOR LAST int-espelho-reporte NO-LOCK
                   WHERE int-espelho-reporte.it-codigo    = ped-item.it-codigo   
                     AND int-espelho-reporte.nome-abrev   = ped-item.nome-abrev  
                     AND int-espelho-reporte.nr-pedcli    = ped-item.nr-pedcli   
                     AND int-espelho-reporte.nr-sequencia = ped-item.nr-sequencia:
                END.
    
                IF AVAIL int-espelho-reporte THEN
                    ASSIGN v-prox-seq = int-espelho-reporte.seq-impres + 1.
                ELSE 
                    ASSIGN v-prox-seq = 1.
    
                CREATE int-espelho-reporte.
                BUFFER-COPY ped-item TO int-espelho-report.
                ASSIGN int-espelho-reporte.seq-impres  = v-prox-seq
                       int-espelho-reporte.cod-usuario = c-seg-usuario
                       int-espelho-reporte.dt-impres = TODAY
                       int-espelho-reporte.hr-impres = STRING(TIME,"HH:MM:SS").
            END.
    
        END.
    END.

    IF i-pag-atual <> 0 THEN DO:
        RUN pdf_close ("Spdf").  
        OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.
    END.
    
END PROCEDURE.

PROCEDURE pi-geral:

    DEF INPUT PARAM p-ordem AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt-roteiro.

    
    /*COMENTADO IAB - 16/02/21
    
    FOR EACH operacao NO-LOCK
       WHERE operacao.it-codigo     = v-item-imp
         AND operacao.cod-roteiro   = ""
         AND operacao.data-inicio  <= TODAY
         AND operacao.data-termino >= TODAY:

        FIND FIRST ficha-oper NO-LOCK
             WHERE ficha-oper.num-id-operacao = operacao.num-id-operacao 
               AND ficha-oper.op-altern       = 0 NO-ERROR.
        
        CREATE tt-roteiro.
        ASSIGN tt-roteiro.seq = operacao.op-codigo
               tt-roteiro.operacao = IF AVAIL ficha-oper AND ficha-oper.desc-linha <> "" THEN ficha-oper.desc-linha ELSE operacao.descricao
               tt-roteiro.recurso   = operacao.gm-codigo
               tt-roteiro.tempo-maquin    = operacao.tempo-maquin
               tt-roteiro.un-med-tempo    = operacao.un-med-tempo.
    END.*/

    FOR EACH oper-ord NO-LOCK
        WHERE oper-ord.nr-ord-prod = p-ordem:

        FIND FIRST ficha-oper NO-LOCK
             WHERE ficha-oper.num-id-operacao = oper-ord.num-id-operacao 
               AND ficha-oper.op-altern       = 0 NO-ERROR.
        
        CREATE tt-roteiro.
        ASSIGN tt-roteiro.seq          = oper-ord.op-codigo
               tt-roteiro.operacao     = IF AVAIL ficha-oper AND ficha-oper.desc-linha <> "" THEN ficha-oper.desc-linha ELSE oper-ord.descricao
               tt-roteiro.recurso      = oper-ord.gm-codigo
               tt-roteiro.tempo-maquin = oper-ord.tempo-maquin
               tt-roteiro.un-med-tempo = oper-ord.un-med-tempo.
    END.


    FIND FIRST tt-saida 
         WHERE tt-saida.nivel = 1 NO-ERROR.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nome-abrev = tt-digita.nome-abrev
           AND ped-venda.nr-pedcli  = tt-digita.nr-pedcli NO-ERROR.

   IF tt-param.ordem-avulsa THEN 
        RELEASE ord-prod.
    ELSE DO:  
	    FIND FIRST ord-prod NO-LOCK
	         WHERE ord-prod.nome-abrev = tt-digita.nome-abrev
	           AND ord-prod.nr-pedido  = tt-digita.nr-pedcli
	           AND ord-prod.nr-sequencia  = tt-digita.nr-sequencia
	           AND ord-prod.it-codigo  = v-item-imp NO-ERROR.

    end.
    IF NOT AVAIL ord-prod THEN
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-ord-prod = tt-digita.nr-ord-prod NO-ERROR.


    /*Calcula paginas*/
    ASSIGN i-pag-total = 3
           i-qtd-lin = 0.

    /* COMENTADO IAB - 16/02/21
    FOR EACH operacao NO-LOCK
       WHERE operacao.it-codigo     = ord-prod.it-codigo
         AND operacao.cod-roteiro   = ""
         AND operacao.data-inicio  <= TODAY
         AND operacao.data-termino >= TODAY:
        ASSIGN i-qtd-lin = i-qtd-lin + 1.
    END.*/

    FOR EACH oper-ord NO-LOCK
        WHERE oper-ord.nr-ord-prod = p-ordem:
        ASSIGN i-qtd-lin = i-qtd-lin + 1.
    END.                                


    FOR EACH tt-saida:
        ASSIGN i-qtd-lin = i-qtd-lin + 1.
    END.

    IF i-qtd-lin >= 45  THEN
        ASSIGN i-pag-total = i-pag-total + 1
               i-qtd-lin = i-qtd-lin - 45.

    IF i-qtd-lin > 0 THEN DO:
        ASSIGN i-tmp = i-qtd-lin / 49. /*52 Ç o nro de linha que cabe na pagina*/

        ASSIGN i-pag-total = i-pag-total + TRUNCATE(i-tmp,0).
    END.

    RUN pdf_new_page("Spdf").
    ASSIGN i-pag-atual = i-pag-atual + 1.
    
    RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo item: " + v-item-imp).
    
    RUN pi-cabecalho (INPUT ROWID(ord-prod),
                      INPUT 1,
                      INPUT 3). 

    RUN pi-roteiro (INPUT TABLE tt-roteiro).

    RUN pi-item.

    RUN pi-pag-roteiro.

    //RUN pi-reg-cotas.

    /*Diret¢rio desenhos itens*/
    RUN esp/es0018p.p (INPUT "escpp111":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-desenho = tt-prog-ponto.conteudo + "\" + v-item-imp + ".jpg".

        IF SEARCH(c-dir-desenho) <> ? THEN 
        DO:
            RUN pdf_new_page("Spdf").
            RUN pi-cabecalho-desenho (INPUT ROWID(ord-prod),
                              INPUT 1,
                              INPUT 3). 

            FIND FIRST tt-desenho-item WHERE tt-desenho-item.it-codigo = v-item-imp NO-ERROR.

            IF NOT AVAIL tt-desenho-item THEN
            DO:
                CREATE tt-desenho-item.
                ASSIGN tt-desenho-item.it-codigo = v-item-imp.
            
                RUN pdf_load_image  IN h_PDFinc ("Spdf",v-item-imp,c-dir-desenho).
            END.
                
            RUN pdf_place_image IN h_PDFinc ("Spdf",
                                             v-item-imp,
                                             pdf_LeftMargin("Spdf"), /*LEFT*/
                                             820, /*top*/
                                             570, /*width*/ 
                                             780). /*height*/
            
                                             
        END.
    END.


END PROCEDURE.

PROCEDURE pi-reg-cotas:
    //RUN pdf_new_page("Spdf").
    ASSIGN i-pag-atual = i-pag-atual + 1.

    /*
    RUN pi-cabecalho (INPUT ROWID(ord-prod),
                      INPUT 1,
                      INPUT 3). 

   */

    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).

    IF SEARCH("image/registro_cotas2.jpg") <> ? THEN
       RUN pdf_place_image IN h_PDFinc ("Spdf",
                                        "regcotas",
                                        pdf_LeftMargin("Spdf"), /*LEFT*/
                                        1135 - i-row,   /* variavel */   /*top*/
                                        570 ,  /*width*/ 
                                        300 ). /*height*/


    // IMPRIMIR PAGINA EM BRANCO - IMPRESSAO FRENTE E VERSO - NAO JUNTAR OPs DISTINTAS
    IF tt-param.imp-pagina THEN DO:
       RUN pdf_new_page("Spdf").
       ASSIGN i-pag-atual = i-pag-atual + 1.
    END.
    

END PROCEDURE.

PROCEDURE pi-pag-roteiro:

    ASSIGN i-cont = 1
           i-cont-aux = 0.

    FOR EACH tt-roteiro:
        IF i-cont MOD 4 = 1 THEN
            ASSIGN i-cont-aux = i-cont-aux + 1.
            
        ASSIGN i-cont = i-cont + 1.
    END.

    ASSIGN i-row = i-row - 15.
    
    /* COMENTADO ISAC - 03/10/23
    /* C2204-1812 - Erro de impressao */
    //IF i-row >= 80 + (80 * i-cont-aux) THEN DO:
    IF i-row >= 50 /* Observacao */ +  100 /* Etapa Prod Aux */ + (100 /*Etapa Prod*/ * i-cont-aux) THEN DO:
        ASSIGN i-row = i-row - 15.
    END.
    ELSE
    DO:
        RUN pdf_new_page("Spdf").
        ASSIGN i-pag-atual = i-pag-atual + 1.
    
        RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 

        ASSIGN i-row = 650.
    END.
    */
 
    IF i-row < 140 THEN DO:
        RUN pdf_new_page("Spdf").
        ASSIGN i-pag-atual = i-pag-atual + 1.

         RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 
        
        ASSIGN i-row = 715.
    END.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row + 8 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               17, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ETAPA DE PRODUÄ«O",  218,  i-row + 12).

    ASSIGN i-row = i-row - 10.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row /*From  Row*/,
                               70 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).
  
    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Chapa O.C",  10,  i-row + 4). 
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               80,  /*From Column*/
                               i-row /*From  Row*/,
                               70 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               155,  /*From Column*/
                               i-row /*From  Row*/,
                               60 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).
      
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               220,  /*From Column*/
                               i-row /*From  Row*/,
                               70 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Tinta O.C",  160,  i-row + 4). 
    
    ASSIGN i-row = i-row - 13.
    ASSIGN i-col = 10.

    ASSIGN i-cont = 1.
    FOR EACH tt-roteiro:
        RUN pdf_set_font("Spdf","Helvetica-bold", 9).
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Data I: ________ HI: _______",  i-col, i-row). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Data F: ________ HF: ______",  i-col, i-row - 10). 
        //RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade Perda: ________",  i-col, i-row - 20). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde: _______ NC: ________",  i-col, i-row - 20). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Cota de Controle:",  i-col, i-row - 30). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Sim: (  ) N∆o: (  )",  i-col, i-row - 40). 
        //RUN pdf_text_xy IN h_PDFinc ("Spdf","A\R: ___ No Operador: _____",  i-col, i-row - 50). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","No Operador: ____________",  i-col, i-row - 50). 
        RUN pdf_set_font("Spdf","Helvetica", 6).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-roteiro.operacao,  i-col, i-row - 60). 

        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   i-col - 5,  /*From Column*/
                                   i-row - 62 /*From  Row*/,
                                   135,
                                   72, /* Height */
                                   1  /* Weight */).

        ASSIGN i-col = i-col + 150.

        IF i-cont MOD 4 = 0 THEN DO:
            ASSIGN i-row = i-row - 77
                   i-col = 10.

            IF i-row < 130 THEN DO:
                RUN pdf_new_page("Spdf").
                ASSIGN i-pag-atual = i-pag-atual + 1.
    
                RUN pi-cabecalho (INPUT ROWID(ord-prod),
                                  INPUT 1,
                                  INPUT 3). 

                ASSIGN i-row = 715.
            END.
        END.

        ASSIGN i-cont = i-cont + 1.
    END.

    //Produá∆o Auxiliares
    ASSIGN i-row = i-row - 90.
    
    /* verificar */
    /*IF i-row < 140  THEN DO:
        RUN pdf_new_page("Spdf").
        ASSIGN i-pag-atual = i-pag-atual + 1.

        RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 

        ASSIGN i-row = 650.
    END.*/

    IF i-row < 113 THEN DO:
        RUN pdf_new_page("Spdf").
        ASSIGN i-pag-atual = i-pag-atual + 1.
    
        RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 

        ASSIGN i-row = 715.
    END.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row + 5 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               17, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ETAPA DE PRODUÄ«O - AUXILIARES",  170,  i-row + 8).

    ASSIGN i-row = i-row - 5
           i-col = 10.

    DO i-cont-aux2 = 1 TO 4:
        RUN pdf_set_font("Spdf","Helvetica-bold", 9).
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Data I: ________ HI: _______",  i-col, i-row). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Data F: ________ HF: ______",  i-col, i-row - 10). 
        //RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade Perda: ________",  i-col, i-row - 20). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde: _______ NC: ________",  i-col, i-row - 20). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Cota de Controle:",  i-col, i-row - 30). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Sim: (  ) N∆o: (  )",  i-col, i-row - 40). 
        //RUN pdf_text_xy IN h_PDFinc ("Spdf","A\R: ___ No Operador: _____",  i-col, i-row - 50). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Operador: _______________",  i-col, i-row - 50). 
        RUN pdf_set_font("Spdf","Helvetica", 6).

        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   i-col - 5,  /*From Column*/
                                   i-row - 53 /*From  Row*/,
                                   135,
                                   63, /* Height */
                                   1  /* Weight */).

        ASSIGN i-col = i-col + 150.
    END.

    ASSIGN i-row = i-row - 65.

    FIND FIRST tt-pag-observ
         WHERE tt-pag-observ.pag = pdf_page("Spdf")
    NO-ERROR.

    IF NOT AVAIL tt-pag-observ THEN DO:
       /*
       IF i-row <= 55  THEN DO:
           RUN pdf_new_page("Spdf").
           ASSIGN i-pag-atual = i-pag-atual + 1.
       
           RUN pi-cabecalho (INPUT ROWID(ord-prod),
                             INPUT 1,
                             INPUT 3). 
    
           ASSIGN i-row = 810.
       END.*/
    
       RUN pi-observacao (INPUT "").
    END.

    IF i-row < 350 THEN DO:
       RUN pdf_new_page("Spdf").
       ASSIGN i-pag-atual = i-pag-atual + 1.
    
       RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 

        ASSIGN i-row = 715.
    END.

    RUN pi-reg-cotas.
    

END PROCEDURE.



PROCEDURE pi-cabec-estrut-item:

    ASSIGN i-row = i-row - 8.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               20, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ESTRUTURA DO ITEM",  220,  i-row + 5). 
    
    ASSIGN i-row = i-row - 15.
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item",  10,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",  55,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Ord. Prod.",  310,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde",  380,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UN",  415,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Tp.", 440,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Part Number", 460,  i-row + 4). 
    
    ASSIGN i-row = i-row - 15.

END PROCEDURE.


PROCEDURE pi-item:
    DEFINE VARIABLE d-qt-ord   AS DECIMAL     NO-UNDO.
     
    /*Quebra de p†gina*/
    IF i-row < 55 THEN DO:
        RUN pdf_new_page("Spdf").
        ASSIGN i-pag-atual = i-pag-atual + 1.

        RUN pi-cabecalho (INPUT ROWID(ord-prod),
                          INPUT 1,
                          INPUT 3). 

        ASSIGN i-row = 737.

        RUN pi-cabec-estrut-item.
    END.

    /*Imprime acabado*/
    RUN pi-cabec-estrut-item.


    /* comentado Isac - 03/10/23
    ASSIGN i-row = i-row - 8.
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               20, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ESTRUTURA DO ITEM",  220,  i-row + 5). 

    ASSIGN i-row = i-row - 15.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               i-row /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item",  10,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",  55,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Ord. Prod.",  310,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde",  380,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UN",  415,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Tp.", 440,  i-row + 4). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Part Number", 460,  i-row + 4). 

    ASSIGN i-row = i-row - 15.
    */

    RUN pi-observacao (INPUT "").

    DEFINE VARIABLE ii AS INTEGER     NO-UNDO.
    
    FOR EACH tt-saida:

        ASSIGN d-qt-ord = 0.
        FIND FIRST b-ord-prod NO-LOCK
             WHERE b-ord-prod.nome-abrev = tt-digita.nome-abrev
               AND b-ord-prod.nr-pedido  = tt-digita.nr-pedcli
               AND b-ord-prod.nr-sequencia  = tt-digita.nr-sequencia
               AND b-ord-prod.it-codigo  = tt-saida.it-pai NO-ERROR.
        
        FOR EACH reservas NO-LOCK
           WHERE reservas.nr-ord-produ = b-ord-prod.nr-ord-prod
             AND reservas.it-codigo    = tt-saida.it-filho:
            ASSIGN d-qt-ord = d-qt-ord + reservas.quant-orig.
        END.


        FIND FIRST b-ord-prod NO-LOCK
             WHERE b-ord-prod.nome-abrev = tt-digita.nome-abrev
               AND b-ord-prod.nr-pedido  = tt-digita.nr-pedcli
               AND b-ord-prod.nr-sequencia  = tt-digita.nr-sequencia
               AND b-ord-prod.it-codigo  = tt-saida.it-filho NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-saida.it-filho NO-ERROR.

        FIND FIRST item-fabric NO-LOCK
             WHERE item-fabric.it-codigo = tt-saida.it-filho NO-ERROR.

        IF tt-saida.nivel = 1 THEN DO:
            RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
        END.
        ELSE 
            RUN pdf_set_font("Spdf","Helvetica", 10).

        RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-saida.it-filho,  10,  i-row + 4). 

        
         IF tt-saida.nivel = 1 THEN DO:
            RUN pdf_set_font("Spdf","Helvetica-Bold", 8).
        END.
        ELSE 
            RUN pdf_set_font("Spdf","Helvetica", 8).

        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(tt-saida.it-filho-desc,'x(50)'),  55 + (tt-saida.nivel * 5),  i-row + 4). 
        
         IF tt-saida.nivel = 1 THEN DO:
            RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
        END.
        ELSE 
            RUN pdf_set_font("Spdf","Helvetica", 10).

        //RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-saida.quantidade, "center",  490,  i-row + 4). 
        IF d-qt-ord = 0 THEN
            RUN pdf_text_align("Spdf",string(tt-saida.quantidade, "->>>>>,>>9.99"), "right",  403,  i-row + 4). 
        ELSE 
            RUN pdf_text_align("Spdf",string(d-qt-ord, "->>>>>,>>9.99"), "right",  403,  i-row + 4). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-saida.un,  415,  i-row + 4). 

        IF ITEM.compr-fabric = 1 THEN
            RUN pdf_text_xy IN h_PDFinc ("Spdf","C",  440,  i-row + 4). 
        ELSE 
            RUN pdf_text_xy IN h_PDFinc ("Spdf","F",  440,  i-row + 4). 

        IF AVAIL item-fabric THEN
            RUN pdf_text_xy IN h_PDFinc ("Spdf",item-fabric.it-fabric,  460,  i-row + 4). 

        //IF tt-saida.nivel = 1 THEN DO:
            IF AVAIL b-ord-prod THEN
                RUN pdf_text_xy IN h_PDFinc ("Spdf",b-ord-prod.nr-ord-prod,  310,  i-row + 4). 
       // END.

        ASSIGN i-row = i-row - 12.

        DELETE tt-saida.

        ii = ii + 1.

        /*Quebra de p†gina*/
         IF i-row < 55 THEN DO:
            RUN pdf_new_page("Spdf").
            ASSIGN i-pag-atual = i-pag-atual + 1.

            
            RUN pi-cabecalho (INPUT ROWID(ord-prod),
                              INPUT 1,
                              INPUT 3). 

            //ASSIGN i-row = 820.
            ASSIGN i-row = 737.

            RUN pi-cabec-estrut-item.
        END.
    END.
    

    

END PROCEDURE.

PROCEDURE pi-observacao:
    DEFINE INPUT PARAM p-observacao AS CHAR.

    
    CREATE tt-pag-observ.
    ASSIGN tt-pag-observ.pag = pdf_page("Spdf").


    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               5 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               50, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Observaá∆o:",  10,  45). 
    RUN pdf_set_font("Spdf","Helvetica", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",p-observacao,  10,  35). 

END PROCEDURE.

PROCEDURE pi-roteiro:
    DEFINE INPUT PARAM TABLE FOR tt-roteiro.
        
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,  /*From Column*/
                               732 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               20, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 13).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ROTEIRO DE PRODUÄ«O",  210,  pdf_PageHeight("Spdf") - 105). 

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               719 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 200 /*Width*/,
                               13, /* Height */ 
                               1 /* Weight */).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               719 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 370 /*Width*/,
                               13, /* Height */ 
                               1 /* Weight */).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               719 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 550 /*Width*/,
                               13, /* Height */ 
                               1 /* Weight */).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               719 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 120 /*Width*/,
                               13, /* Height */ 
                               1 /* Weight */).

/*     RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/   */
/*                                5,    /*From Column*/                 */
/*                                634 /*From  Row*/,                    */
/*                                pdf_PageWidth("Spdf") - 40 /*Width*/, */
/*                                13, /* Height */                      */
/*                                1 /* Weight */).                      */

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Seq.",  10,  pdf_PageHeight("Spdf") - 120). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Operaá∆o",  55,  pdf_PageHeight("Spdf") - 120). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Recurso",  235,  pdf_PageHeight("Spdf") - 120). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Tempo",  405,  pdf_PageHeight("Spdf") - 120). 

   
    ASSIGN i-row = 707.

    RUN pdf_set_font("Spdf","Helvetica", 8).
    //FOR EACH tt-roteiro:
    FOR EACH oper-ord NO-LOCK
       WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod:

        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   5,    /*From Column*/
                                   i-row /*From  Row*/,
                                   pdf_PageWidth("Spdf") - 200 /*Width*/,
                                   12, /* Height */ 
                                   1 /* Weight */).
    
        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   5,    /*From Column*/
                                   i-row /*From  Row*/,
                                   pdf_PageWidth("Spdf") - 370 /*Width*/,
                                   12, /* Height */ 
                                   1 /* Weight */).
    
        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   5,    /*From Column*/
                                   i-row /*From  Row*/,
                                   pdf_PageWidth("Spdf") - 550 /*Width*/,
                                   12, /* Height */ 
                                   1 /* Weight */).

        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   5,    /*From Column*/
                                   i-row /*From  Row*/,
                                   pdf_PageWidth("Spdf") - 120 /*Width*/,
                                   12, /* Height */ 
                                   1 /* Weight */).

       // FIND FIRST operacao NO-LOCK
         //    WHERE operacao.op-codigo = oper-ord.op-codigo NO-ERROR.

        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(oper-ord.sequencia),  10,  i-row + 4). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",oper-ord.op-codigo,  55,  i-row + 4). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",oper-ord.descricao,  235,  i-row + 4). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(oper-ord.tempo-maquin, ">>>>9.999") + " " + string(ENTRY (oper-ord.un-med-tempo, c-lista-um-tempo)) , 405,  i-row + 4). 

        ASSIGN i-row = i-row - 12.
    END.

END PROCEDURE.

PROCEDURE pi-cabecalho:
    
    DEFINE INPUT PARAM p-row-ord-prod AS ROWID.
    DEFINE INPUT PARAM p-pag-atual    AS INT.
    DEFINE INPUT PARAM p-pag-total    AS INT.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = p-row-ord-prod NO-ERROR.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = v-item-imp NO-ERROR.

    /*primeira linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 45 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               40, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               170,    /*From Column*/
                               pdf_PageHeight("Spdf") - 45 /*From  Row*/,
                               420 /*Width*/,
                               40, /* Height */
                               1  /* Weight */).
    
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               170,    /*From Column*/
                               pdf_PageHeight("Spdf") - 45 /*From  Row*/,
                               330 /*Width*/,
                               40, /* Height */
                               1  /* Weight */).

    IF search("image/logo_decio.jpg") <> ? THEN
    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-decio",
                                     pdf_LeftMargin("Spdf") + 20, /*LEFT*/
                                     pdf_PageHeight("Spdf") - 800, /*top*/
                                     pdf_LeftMargin("Spdf") + 100, 
                                     35).


    RUN pdf_set_font("Spdf","Helvetica-Bold", 17).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ORDEM DE PRODUÄ«O",  177,  pdf_PageHeight("Spdf") - 30). 

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","RQ-022",  520,  pdf_PageHeight("Spdf") - 17).

    ASSIGN c-bar-code = "".
    IF AVAIL ord-prod THEN DO:
        RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
        RUN generateCODE128C IN h-bcapi016 (TRIM(STRING(ord-prod.nr-ord-prod)),OUTPUT c-bar-code).
        DELETE PROCEDURE h-bcapi016.
    END.

    IF search("c:\windows\fonts\dc-code128.ttf") <> ? THEN
    DO:
       RUN pdf_set_font ("Spdf", "IQsCode128",27).
       RUN pdf_text_xy IN h_PDFinc ("Spdf",c-bar-code,  380,  pdf_PageHeight("Spdf") - 37). 
    END.

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Rev.: 09",  505,  pdf_PageHeight("Spdf") - 32). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data: 13/11/2023",  505,  pdf_PageHeight("Spdf") - 42). 

    
    /*segunda linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 60 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).

    RUN pdf_text_xy IN h_PDFinc ("Spdf","N£mero OP: ",  200,  pdf_PageHeight("Spdf") - 57). 

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Pedido: ",  60,  pdf_PageHeight("Spdf") - 57). 

    IF AVAIL ord-prod THEN DO:

        FIND CURRENT ord-prod EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN ord-prod.emite-ordem = NO.
        FIND CURRENT ord-prod NO-LOCK NO-ERROR.

        RUN pdf_text_xy IN h_PDFinc ("Spdf",ord-prod.nr-ord-prod,  265,  pdf_PageHeight("Spdf") - 57). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ord-prod.nr-pedido,  100,  pdf_PageHeight("Spdf") - 57). 
    END.

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","OP Matriz: ",  410,  pdf_PageHeight("Spdf") - 57). 

    IF nr-ord-prod-matriz <> 0 THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",nr-ord-prod-matriz,  465,  pdf_PageHeight("Spdf") - 57). 

    
    
    /*terceira linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 75 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    
       
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               370,    /*From Column*/
                               pdf_PageHeight("Spdf") - 75 /*From  Row*/,
                               70 /*pdf_PageWidth("Spdf") - 305*/ /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    /*
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               455,    /*From Column*/
                               pdf_PageHeight("Spdf") - 110 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 50 /*405*/ /*Width*/,
                               30, /* Height */ 
                               1  /* Weight */).*/
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               517,    /*From Column*/
                               pdf_PageHeight("Spdf") - 75 /*From  Row*/ ,
                               73,  /*Width*/ 
                               15, /* Height */ 
                               1  /* Weight */). 

    RUN pdf_set_font("Spdf","Helvetica-Bold", 9).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cliente: ",  10,  pdf_PageHeight("Spdf") - 72). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","QTD.: ",     375 /*305*/ , pdf_PageHeight("Spdf") - 72). 
    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Inicio: ",443 /*405*/ , pdf_PageHeight("Spdf") - 72). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Entr.: ", 520 /*505*/ , pdf_PageHeight("Spdf") - 72). 

    RUN pdf_set_font("Spdf","Helvetica", 9).
    
    IF AVAIL emitente THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(emitente.cod-emitente) + " - " + STRING(emitente.nome-emit,'x(50)') ,  50,  pdf_PageHeight("Spdf") - 72). 

    RUN pdf_text_xy IN h_PDFinc ("Spdf",IF AVAIL ord-prod THEN STRING(ord-prod.qt-ordem) ELSE "0",  405,  pdf_PageHeight("Spdf") - 72). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",IF AVAIL ord-prod THEN STRING(ord-prod.dt-inicio,"99/99/9999") ELSE "",  470,  pdf_PageHeight("Spdf") - 72). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",IF AVAIL ord-prod THEN STRING(ord-prod.dt-termino,"99/99/9999") ELSE "",  543,  pdf_PageHeight("Spdf") - 72). 

    /*quarta linha*/
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 90 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).
                               

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               400,    /*From Column*/
                               pdf_PageHeight("Spdf") - 90 /*From  Row*/,
                               117 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    FIND FIRST item-fabric NO-LOCK
         WHERE item-fabric.it-codigo = v-item-imp NO-ERROR.

    RUN pdf_set_font("Spdf","Helvetica-Bold", 9).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","C¢d. Estrut. Item:",  10,  pdf_PageHeight("Spdf") - 87).
    //RUN pdf_text_xy IN h_PDFinc ("Spdf","Data e hora da impress∆o: ",  305,  pdf_PageHeight("Spdf") - 121).
    RUN pdf_set_font("Spdf","Helvetica", 9).

    
    RUN pdf_text_xy IN h_PDFinc ("Spdf",v-item-imp + " - " + string(ITEM.desc-item,'x(45)') ,  92,  pdf_PageHeight("Spdf") - 87).

    /* C2208-2484 - 27/10/2022
    IF AVAIL item-fabric THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",item-fabric.it-fabric ,  200,  pdf_PageHeight("Spdf") - 124).
    */

    //RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(STRING(NOW),1,19),  435,  pdf_PageHeight("Spdf") - 121). - ISAC
    
                                                                       
    /*quinta linha*/

    /* ISAC
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 170 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               30, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item ",  10,  pdf_PageHeight("Spdf") - 150).

    RUN pdf_set_font("Spdf","Helvetica", 10).

    
    RUN pdf_text_xy IN h_PDFinc ("Spdf",v-item-imp + " - " + ITEM.desc-item ,  10,  pdf_PageHeight("Spdf") - 163). */
    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 9).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item:",  405,  pdf_PageHeight("Spdf") - 87).

    RUN pdf_set_font("Spdf","Helvetica", 9).

    IF AVAIL item-fabric THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(item-fabric.it-fabric,'x(16)') ,  430,  pdf_PageHeight("Spdf") - 87).

     RUN pdf_set_font("Spdf","Helvetica-Bold", 8).
     RUN pdf_text_xy IN h_PDFinc ("Spdf",'Impr.:',520, pdf_PageHeight("Spdf") - 87).

     RUN pdf_set_font("Spdf","Helvetica", 9).
     RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(TODAY,'99/99/9999'), 543, pdf_PageHeight("Spdf") - 87).
     


    


    
END PROCEDURE.

PROCEDURE pi-cabecalho-desenho:
    DEFINE INPUT PARAM p-row-ord-prod AS ROWID.
    DEFINE INPUT PARAM p-pag-atual    AS INT.
    DEFINE INPUT PARAM p-pag-total    AS INT.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = p-row-ord-prod NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = v-item-imp NO-ERROR.
    
    
    /*quinta linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 35 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               30, /* Height */ 
                               1  /* Weight */).

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item ",  10,  pdf_PageHeight("Spdf") - 15).

    RUN pdf_set_font("Spdf","Helvetica", 10).

    
    RUN pdf_text_xy IN h_PDFinc ("Spdf",v-item-imp + " - " + ITEM.desc-item ,  10,  pdf_PageHeight("Spdf") - 28). 

    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade",  490,  pdf_PageHeight("Spdf") - 18). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Numero OP:",  350,  pdf_PageHeight("Spdf") - 28). 

    RUN pdf_set_font("Spdf","Helvetica", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",ord-prod.nr-ord-prod,  410,  pdf_PageHeight("Spdf") - 28). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",IF AVAIL ord-prod THEN STRING(ord-prod.qt-ordem) ELSE "0",  490,  pdf_PageHeight("Spdf") - 28). 
    

    IF AVAIL item-fabric THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",item-fabric.it-fabric ,  200,  pdf_PageHeight("Spdf") - 18).

END PROCEDURE.

PROCEDURE pi-ler-estrutura:
    DEFINE INPUT PARAM p-it-codigo AS CHAR.
    DEFINE INPUT PARAM p-ordem     AS INT.


    FOR EACH reservas NO-LOCK
        WHERE reservas.nr-ord-prod = p-ordem:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.
        
        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = reservas.it-codigo NO-ERROR.

        FIND FIRST b-estrutura NO-LOCK
             WHERE b-estrutura.it-codigo = reservas.it-codigo NO-ERROR.
       
        ASSIGN i-nivel = 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = p-it-codigo
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = reservas.it-codigo
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = reservas.quant-orig
               tt-saida.un            = b-item.un.

        ASSIGN tt-saida.fantasma = "".

        IF AVAIL b-estrutura THEN 
           IF b-estrutura.fantasma = YES THEN
              ASSIGN tt-saida.fantasma = "#".
           ELSE
              ASSIGN tt-saida.fantasma = "".
         

       IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = b-estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

       ELSE
           ASSIGN tt-saida.tipo = "Comprado".
           
        RUN pi-estrutura(INPUT reservas.it-codigo,
                         INPUT p-it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
    
    END.



    /*
    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >  TODAY:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.it-codigo NO-ERROR.
        
        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        FIND FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo NO-ERROR.

       
        ASSIGN i-nivel = 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = estrutura.it-codigo        
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = estrutura.es-codigo    
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = estrutura.quant-usada
               tt-saida.un            = b-item.un.

        IF estrutura.fantasma = YES THEN
            ASSIGN tt-saida.fantasma = "#".
        ELSE
            ASSIGN tt-saida.fantasma = "".

       IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

       ELSE
           ASSIGN tt-saida.tipo = "Comprado".
           
        RUN pi-estrutura(INPUT estrutura.es-codigo,
                         INPUT estrutura.it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
    
    END.*/

END.

PROCEDURE pi-estrutura:
    DEFINE INPUT PARAMETER p-es-codigo LIKE estrutura.es-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo LIKE estrutura.it-codigo NO-UNDO.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-es-codigo
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >  TODAY:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-nivel = i-nivel + 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = p-es-codigo        
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = estrutura.es-codigo    
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = estrutura.quant-usada
               tt-saida.un            = b-item.un.
        
        IF estrutura.fantasma = YES THEN
            ASSIGN tt-saida.fantasma = "#".
        ELSE
            ASSIGN tt-saida.fantasma = "".
        
        IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

        ELSE
           ASSIGN tt-saida.tipo = "Comprado".


        RUN pi-estrutura(INPUT estrutura.es-codigo,
                         INPUT p-it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
    END.
END.  
