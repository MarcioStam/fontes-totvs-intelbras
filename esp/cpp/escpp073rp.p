/***********************************************************************
**  Programa..: esp/cpp/escpp073rp.p
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Abril/2015 - Desenvolvimento
**  Descricao.: Relat¢rio N£mero de S‚rie
**  Versao....: 003 07/04/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i ESCPP073RP 2.00.00.000}

/****************************  Definitions  ****************************/

{esp/cpp/escpp073.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER    NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE dt-ini AS DATETIME    NO-UNDO.
DEFINE VARIABLE dt-fim AS DATETIME    NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-usuar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont       AS INT LABEL "Qtd.Num-serie" NO-UNDO.

/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-total-num-serie
    FIELD it-codigo AS CHAR 
    FIELD tot        AS INT
    FIELD data       LIKE num-serie.data.

DEFINE TEMP-TABLE tt-saida
    FIELD ITEM         LIKE num-serie.it-codigo
    FIELD desc-item    LIKE item.desc-item 
    FIELD num-serie    LIKE num-serie.n-serie  
    FIELD sequencia    LIKE num-serie.sequencia
    FIELD data-serie   LIKE num-serie.data
    FIELD sigla        LIKE num-serie.sigla
    FIELD num-pedido   LIKE num-serie.num-pedido
    FIELD usuario      AS CHAR
    FIELD tot          AS INT
    FIELD mac          AS CHAR
    INDEX dt AS PRIMARY UNIQUE data-serie ITEM sequencia.

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "/":U THEN
    ASSIGN c-excel = c-excel + "/":U + TRIM(tt-param.usuario) + "/":U.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
                           
    END.
    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "~\":U THEN
    ASSIGN c-excel = c-excel + "~\":U + TRIM(tt-param.usuario) + "~\":U.
END.

OS-CREATE-DIR VALUE(c-excel).
ASSIGN c-excel = c-excel + "ESCPP073.csv":U.

/* **************************** Frames ********************************* */

{include/i-rpout.i}
{include/i-rpcab.i}

FORM num-serie.it-codigo 
     c-desc-item            COLUMN-LABEL "Descri‡Æo" FORMAT "x(33)"
     num-serie.n-serie 
     num-serie.sequencia
     num-serie.data
     num-serie.sigla     
     c-nome-usuar           COLUMN-LABEL "Nome" FORMAT "X(33)"
     num-serie.num-pedido   COLUMN-LABEL "PO"
     mac-address.mac        COLUMN-LABEL "MAC"  FORMAT "X(13)"
    WITH FRAME f-ns STREAM-IO DOWN WIDTH 155.

FORM num-serie.it-codigo 
     c-desc-item            COLUMN-LABEL "Descri‡Æo" FORMAT "x(33)"
     num-serie.n-serie 
     num-serie.sequencia
     num-serie.data
     num-serie.sigla     
     c-nome-usuar           COLUMN-LABEL "Nome" FORMAT "X(33)"
     num-serie.num-pedido   COLUMN-LABEL "PO"
     mac-address.mac        COLUMN-LABEL "MAC"  FORMAT "X(13)"
     num-serie-uuid.uuid    COLUMN-LABEL "UUID" FORMAT "x(30)"
     num-serie-uuid.authkey    COLUMN-LABEL "Authkey" FORMAT "x(40)"
    WITH FRAME f-ns-uuid STREAM-IO DOWN WIDTH 350.

FORM tt-total-num-serie.it-codigo COLUMN-LABEL "ITEM"
     c-desc-item                  COLUMN-LABEL "Descri‡Æo" FORMAT "x(33)"
     tt-total-num-serie.data
     tt-total-num-serie.tot       COLUMN-LABEL "TOTAL Num.Serie"
    WITH FRAME f-bns STREAM-IO DOWN WIDTH 155.


FOR FIRST tt-param:
END.

ASSIGN  c-programa 	    = "ESCPP073"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "CPP"
	    c-titulo-relat  = "Listagem de N£meros de S‚rie".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET SESSION:CHARSET.
/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i Listando_N£meros_de_S‚rie *}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    ASSIGN dt-ini = DATETIME(month(tt-param.dtDataIni), 
                         day(tt-param.dtDataIni),
                         year(tt-param.dtDataIni),
                         0,  /* hora */
                         0,  /* minutos */
                         0,  /* segundos */
                         0)  /* milisegundos */

           dt-fim = DATETIME(month(tt-param.dtDataFim), 
                         day(tt-param.dtDataFim),
                         year(tt-param.dtDataFim),
                         23,  /* hora */
                         59,  /* minutos */
                         59,  /* segundos */
                         999)  /* milisegundos */.
    
    IF tt-param.tipo-arquivo = 1 THEN
        PUT STREAM str-excel "ITEM;Descri‡Æo;Serial;Num-serie.sec;Data;Sigla;Usuario;PO;MAC" SKIP.
   
    IF tt-param.tipo-arquivo = 2 THEN
        PUT STREAM str-excel "Data;ITEM;Descri‡Æo;Qtd.Serial" SKIP.
END.

IF tt-param.nrPedido > 0 THEN
    RUN piSeriePedido.
ELSE
    RUN piSerieData.

FOR EACH tt-total-num-serie NO-LOCK
    BY DATE(tt-total-num-serie.data)
    BY tt-total-num-serie.it-codigo:

    IF tt-param.tipo-arquivo = 2 THEN DO: 
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-total-num-serie.it-codigo NO-ERROR.

        ASSIGN c-desc-item = ITEM.desc-item.
        
        CREATE tt-saida.
        ASSIGN tt-saida.data-serie = tt-total-num-serie.data
               tt-saida.ITEM       = tt-total-num-serie.it-codigo
               tt-saida.desc-item  = c-desc-item
               tt-saida.tot        = tt-total-num-serie.tot.

        DISPLAY tt-total-num-serie.it-codigo
                c-desc-item
                tt-total-num-serie.data
                tt-total-num-serie.tot WITH FRAME f-bns.
        DOWN WITH FRAME f-bns.
    END.
END. 


PAGE.

disp skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     tt-param.dtDataini   LABEL "Data" FORMAT "99/99/9999"  AT 04    "|<    >|" AT 22  tt-param.dtDataFim   NO-LABEL FORMAT "99/99/9999" AT 32 
     tt-param.itCodigoIni LABEL "Item"                      AT 04    "|<    >|" AT 22  tt-param.itCodigoFim NO-LABEL                     AT 32
     with frame f-selec width 141 stream-io side-labels.


disp skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 4
     " - " tt-param.arquivo FORMAT "X(60)" SKIP
     skip
     "Usu rio:" at 4
     tt-param.usuario 
     with frame f-impressao width 141 stream-io no-labels.


/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

FOR EACH tt-saida NO-LOCK
     BY date(tt-saida.data-serie) 
     BY tt-saida.ITEM:

    IF tt-param.tipo-arquivo = 1 THEN DO:

        IF tt-param.uuid = NO 
        THEN DO:
            PUT STREAM str-excel UNFORMATTED
                TRIM(tt-saida.ITEM)             ";"
                TRIM(tt-saida.desc-item)        ";"
                TRIM(tt-saida.num-serie)        ";" 
                tt-saida.sequencia              ";"
                DATE(tt-saida.data-serie)       ";"
                TRIM(tt-saida.sigla)            ";"
                TRIM(tt-saida.usuario)          ";"
                tt-saida.num-pedido             ";"
                tt-saida.mac                SKIP.

        END.
        ELSE DO:

            FIND FIRST num-serie-uuid WHERE
                       num-serie-uuid.n-serie = TRIM(tt-saida.num-serie)
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL num-serie-uuid 
            THEN PUT STREAM str-excel UNFORMATTED
                     TRIM(tt-saida.ITEM)             ";"
                     TRIM(tt-saida.desc-item)        ";"
                     TRIM(tt-saida.num-serie)        ";" 
                     tt-saida.sequencia              ";"
                     DATE(tt-saida.data-serie)       ";"
                     TRIM(tt-saida.sigla)            ";"
                     TRIM(tt-saida.usuario)          ";"
                     tt-saida.num-pedido             ";"
                     tt-saida.mac                SKIP.
            ELSE PUT STREAM str-excel UNFORMATTED
                     TRIM(tt-saida.ITEM)             ";"
                     TRIM(tt-saida.desc-item)        ";"
                     TRIM(tt-saida.num-serie)        ";" 
                     tt-saida.sequencia              ";"
                     DATE(tt-saida.data-serie)       ";"
                     TRIM(tt-saida.sigla)            ";"
                     TRIM(tt-saida.usuario)          ";"
                     tt-saida.num-pedido             ";"
                     tt-saida.mac                    ";"
                     num-serie-uuid.uuid             ";"
                     num-serie-uuid.authkey
                     SKIP.

        END.
        
    END.
    
    IF tt-param.tipo-arquivo = 2 THEN DO:
         
         PUT STREAM str-excel UNFORMATTED  
             DATE(tt-saida.data-serie)             ";"
             TRIM(tt-saida.ITEM)                   ";"
             TRIM(tt-saida.desc-item)              ";"
             tt-saida.tot                         SKIP.
    
    END.
END.
OUTPUT STREAM str-excel CLOSE.

PROCEDURE piSerieData:
    FOR EACH num-serie USE-INDEX data NO-LOCK
        WHERE num-serie.data       >= dt-ini
        AND   num-serie.data       <= dt-fim
        AND   num-serie.it-codigo  >= tt-param.itCodigoIni
        AND   num-serie.it-codigo  <= tt-param.itCodigoFim
        BREAK BY DATE(num-serie.data)
              BY num-serie.it-codigo: 
        
        RUN pi-acompanhar IN h-acomp (INPUT num-serie.data).
        
        ASSIGN c-desc-item = "".
        
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = num-serie.it-codigo:
            
            ASSIGN c-desc-item = ITEM.desc-item.
        END.
    
        IF FIRST-OF (date(num-serie.data)) OR FIRST-OF (num-serie.it-codigo) THEN
            ASSIGN i-cont = 0.
        
        ASSIGN c-nome-usuar = ""
               i-cont = i-cont + 1.
    
        FOR FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = num-serie.usuario: 
            ASSIGN c-nome-usuar = usuar_mestre.nom_usuario.
        END.
        
        IF LAST-OF (date(num-serie.data)) OR LAST-OF (num-serie.it-codigo) THEN DO:
            CREATE tt-total-num-serie.
            ASSIGN tt-total-num-serie.data      = num-serie.data
                   tt-total-num-serie.it-codigo = num-serie.it-codigo
                   tt-total-num-serie.tot       = i-cont.
            ASSIGN i-cont = 0.
        END.
        
        IF tt-param.tipo-arquivo = 1 THEN DO:

            FIND FIRST mac-address USE-INDEX num-serie 
                 WHERE mac-address.n-serie = num-serie.n-serie
                       NO-LOCK NO-ERROR.

            CREATE tt-saida.
            ASSIGN tt-saida.ITEM       = num-serie.it-codigo
                   tt-saida.desc-item  = c-desc-item 
                   tt-saida.num-serie  = num-serie.n-serie  
                   tt-saida.sequencia  = num-serie.sequencia
                   tt-saida.data-serie = num-serie.data
                   tt-saida.sigla      = num-serie.sigla
                   tt-saida.num-pedido = num-serie.num-pedido
                   tt-saida.usuario    = c-nome-usuar
                   tt-saida.mac        = mac-address.mac WHEN AVAIL mac-address.
            
            IF tt-param.uuid = NO 
            THEN DO:
                DISPLAY num-serie.it-codigo
                        c-desc-item
                        num-serie.n-serie
                        num-serie.sequencia
                        num-serie.data
                        num-serie.sigla
                        c-nome-usuar
                        num-serie.num-pedido 
                        mac-address.mac WHEN AVAIL mac-address
                        WITH FRAME f-ns.
                DOWN WITH FRAME f-ns.
            END.
            ELSE DO:
                FIND FIRST num-serie-uuid WHERE
                           num-serie-uuid.n-serie = num-serie.n-serie
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL num-serie-uuid  
                THEN DO:
                    DISPLAY num-serie.it-codigo
                            c-desc-item
                            num-serie.n-serie
                            num-serie.sequencia
                            num-serie.data
                            num-serie.sigla
                            c-nome-usuar
                            num-serie.num-pedido 
                            mac-address.mac WHEN AVAIL mac-address
                            WITH FRAME f-ns.
                    DOWN WITH FRAME f-ns.
                END.
                ELSE DO:
                    DISPLAY num-serie.it-codigo
                            c-desc-item
                            num-serie.n-serie
                            num-serie.sequencia
                            num-serie.data
                            num-serie.sigla
                            c-nome-usuar
                            num-serie.num-pedido 
                            mac-address.mac WHEN AVAIL mac-address
                            num-serie-uuid.uuid
                            num-serie-uuid.authkey
                            WITH FRAME f-ns-uuid.
                    DOWN WITH FRAME f-ns-uuid.
                END.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE piSeriePedido:
    FOR EACH num-serie USE-INDEX ped NO-LOCK
        WHERE num-serie.it-codigo  >= tt-param.itCodigoIni
        AND   num-serie.it-codigo  <= tt-param.itCodigoFim
        AND   num-serie.num-pedido  = tt-param.nrPedido
        BREAK BY DATE(num-serie.data)
              BY num-serie.it-codigo: 
        
        RUN pi-acompanhar IN h-acomp (INPUT num-serie.data).
        
        ASSIGN c-desc-item = "".
        
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = num-serie.it-codigo:
            
            ASSIGN c-desc-item = ITEM.desc-item.
        END.
    
        IF FIRST-OF (date(num-serie.data)) OR FIRST-OF (num-serie.it-codigo) THEN
            ASSIGN i-cont = 0.
        
        ASSIGN c-nome-usuar = ""
               i-cont = i-cont + 1.
    
        FOR FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = num-serie.usuario: 
            ASSIGN c-nome-usuar = usuar_mestre.nom_usuario.
        END.
        
        IF LAST-OF (date(num-serie.data)) OR LAST-OF (num-serie.it-codigo) THEN DO:
            CREATE tt-total-num-serie.
            ASSIGN tt-total-num-serie.data      = num-serie.data
                   tt-total-num-serie.it-codigo = num-serie.it-codigo
                   tt-total-num-serie.tot       = i-cont.
            ASSIGN i-cont = 0.
        END.
        
        IF tt-param.tipo-arquivo = 1 THEN DO:

            FIND FIRST mac-address USE-INDEX num-serie 
                 WHERE mac-address.n-serie = num-serie.n-serie
                       NO-LOCK NO-ERROR.

            CREATE tt-saida.
            ASSIGN tt-saida.ITEM       = num-serie.it-codigo
                   tt-saida.desc-item  = c-desc-item 
                   tt-saida.num-serie  = num-serie.n-serie  
                   tt-saida.sequencia  = num-serie.sequencia
                   tt-saida.data-serie = num-serie.data
                   tt-saida.sigla      = num-serie.sigla
                   tt-saida.num-pedido = num-serie.num-pedido
                   tt-saida.usuario    = c-nome-usuar
                   tt-saida.mac        = mac-address.mac WHEN AVAIL mac-address.
            
            IF tt-param.uuid = NO 
            THEN DO:
                DISPLAY num-serie.it-codigo
                        c-desc-item
                        num-serie.n-serie
                        num-serie.sequencia
                        num-serie.data
                        num-serie.sigla
                        c-nome-usuar
                        num-serie.num-pedido 
                        mac-address.mac WHEN AVAIL mac-address
                        WITH FRAME f-ns.
                DOWN WITH FRAME f-ns.
            END.
            ELSE DO:
                FIND FIRST num-serie-uuid WHERE
                           num-serie-uuid.n-serie = num-serie.n-serie
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL num-serie-uuid  
                THEN DO:
                    DISPLAY num-serie.it-codigo
                            c-desc-item
                            num-serie.n-serie
                            num-serie.sequencia
                            num-serie.data
                            num-serie.sigla
                            c-nome-usuar
                            num-serie.num-pedido 
                            mac-address.mac WHEN AVAIL mac-address
                            WITH FRAME f-ns.
                    DOWN WITH FRAME f-ns.
                END.
                ELSE DO:
                    DISPLAY num-serie.it-codigo
                            c-desc-item
                            num-serie.n-serie
                            num-serie.sequencia
                            num-serie.data
                            num-serie.sigla
                            c-nome-usuar
                            num-serie.num-pedido 
                            mac-address.mac WHEN AVAIL mac-address
                            num-serie-uuid.uuid
                            num-serie-uuid.authkey
                            WITH FRAME f-ns-uuid.
                    DOWN WITH FRAME f-ns-uuid.
                END.
            END.
        END.
    END.
END PROCEDURE.















