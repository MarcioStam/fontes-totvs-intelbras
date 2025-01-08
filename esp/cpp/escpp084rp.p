
/* include de controle de versÊo */
{include/i-prgvrs.i ESCPP084RP 2.00.00.000}

/* defini¯Êo das temp-tables para recebimento de parümetros */
{esp/cpp/escpp084.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parümetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padrÊo para vari˜veis de relat«rio  */
{include/i-rpvar.i}

DEF STREAM A .

DEF TEMP-TABLE tt-grafico NO-UNDO
    FIELD origem AS CHAR FORMAT "x(15)"
    FIELD quant  AS INTEGER
    FIELD perc   AS DEC FORMAT ">>9.99".

DEF VAR de-tot-grafico AS INTEGER NO-UNDO.
DEF VAR de-maior-grafico AS INTEGER NO-UNDO.

DEF TEMP-TABLE tt-lista NO-UNDO
    FIELD origem AS CHAR FORMAT "x(15)"
    FIELD perc   AS DEC FORMAT ">>9.99".


/* defini¯Êo de vari˜veis  */
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER    NO-UNDO.

DEFINE VARIABLE dt-ini AS DATETIME    NO-UNDO.
DEFINE VARIABLE dt-fim AS DATETIME    NO-UNDO.
DEFINE VARIABLE c-nome-usuar AS CHARACTER   NO-UNDO.

DEFINE VARIABLE d-total  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-total2 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dt-aux   AS DATE    NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE dt-ultima AS DATE    NO-UNDO.
DEFINE VARIABLE c-meses AS CHARACTER  INIT "Janeiro,Fevereiro,Mar‡o,Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro" NO-UNDO.
DEFINE VARIABLE d-vol-prod AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-cont-dias AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-linhas AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-diario AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-diario2 AS INTEGER     NO-UNDO.
DEF VAR d-qtd-prod         AS DECIMAL NO-UNDO.

DEFINE VARIABLE i-cont-placa AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-excel  NO-UNDO
    FIELD nr-linha            AS INT
    FIELD cod-prod            AS INT
    FIELD desc-prod           AS CHAR
    FIELD es-codigo           AS CHAR
    FIELD local-montag        AS CHAR
    FIELD origem              AS CHAR
    FIELD cod-falha           AS INT 
    FIELD des-falha           AS CHAR
    FIELD data                AS DATE
    FIELD quantidade          AS DECIMAL
    FIELD cod-origem          AS INTEGER
    FIELD qtd-produ           AS DECIMAL
    FIELD dt-produ            AS DATE
    FIELD nr-placa-seq        AS INT
    FIELD log-possui-etiq-tec AS LOG
    FIELD dt-registro         AS DATE.

DEF TEMP-TABLE tt-excel-aux LIKE tt-excel.

DEFINE TEMP-TABLE tt-diario NO-UNDO
    FIELD nr-linha      AS INT
    FIELD cod-prod      AS INT
    FIELD desc-prod     AS CHAR
    FIELD es-codigo     AS CHAR
    FIELD local-montag  AS CHAR
    FIELD origem        AS CHAR
    FIELD cod-falha     AS INT 
    FIELD des-falha     AS CHAR
    FIELD data          AS DATE
    FIELD observacao    AS CHAR
    FIELD qtd-produ     AS DECI
    FIELD qtd-falha     AS DECI.

DEFINE STREAM st-excel.

DEF TEMP-TABLE tt-produtos NO-UNDO
    FIELD es-codigo        LIKE ITEM.it-codigo
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD qtd-produ        AS DECIMAL
    FIELD qtd-estru        AS DECIMAL.

DEF BUFFER b-estrutura     FOR estrutura.
DEF BUFFER b2-estrutura    FOR estrutura.

DEFINE BUFFER b-tt-excel FOR tt-excel.    

FUNCTION f-qtd-total-meses-ant RETURNS DECIMAL
    (INPUT data AS DATE,
     INPUT p-local-pontag LIKE tt-excel.local-montag, 
     INPUT p-cod-origem   LIKE tt-excel.cod-origem, 
     INPUT p-cod-falha    LIKE tt-excel.cod-falha) :

    DEFINE VARIABLE dt-aux      AS DATE     NO-UNDO.
    DEFINE VARIABLE d-tot-falha AS DECIMAL  NO-UNDO.

    ASSIGN dt-aux = data
           d-tot-falha = 0.

    bl-leitura:
    REPEAT:

        FOR EACH tt-excel-aux
            WHERE tt-excel-aux.local-montag = p-local-pontag
              AND tt-excel-aux.cod-origem   = p-cod-origem 
              AND tt-excel-aux.cod-falha    = p-cod-falha  
              AND tt-excel-aux.data         = dt-aux :
            ASSIGN d-tot-falha = d-tot-falha + tt-excel-aux.quantidade.
            
        END.

        ASSIGN dt-aux = dt-aux + 1.

        IF MONTH(dt-aux) <> MONTH(data) THEN
            LEAVE bl-leitura.
    END.

    RETURN d-tot-falha.

END FUNCTION.

FUNCTION f-desc-mes RETURNS CHARACTER
  ( INPUT mes AS INT ) :

    IF mes < 1 THEN
        ASSIGN mes = mes + 12.

    RETURN ENTRY(mes, c-meses).

END FUNCTION.


FUNCTION f-qtd-prevista-mes RETURNS DECIMAL
    (INPUT data AS DATE) :

    DEFINE VARIABLE dt-aux AS DATE    NO-UNDO.
    DEFINE VARIABLE d-qtd-mes AS DECIMAL     NO-UNDO.


    ASSIGN dt-aux    = data
           d-qtd-mes = 0.

    bl-leitura:
    REPEAT:

        FOR EACH estimativa-produ NO-LOCK
            WHERE estimativa-produ.cod-estabel = tt-param.cod-estabel
            AND   estimativa-produ.data        = dt-aux
            AND   estimativa-produ.cod-prod    = tt-param.cod-prod:
    
            ASSIGN d-qtd-mes = d-qtd-mes + estimativa-produ.qtd-estimada.
    
        END.

        ASSIGN dt-aux = dt-aux + 1.

        IF MONTH(data) <> MONTH(dt-aux) THEN
            LEAVE bl-leitura.

    END.

    RETURN d-qtd-mes.

END FUNCTION.


FUNCTION f-qtd-reportada-mes RETURNS DECIMAL
    (INPUT data AS DATE) :

    DEFINE VARIABLE dt-aux AS DATE    NO-UNDO.
    DEFINE VARIABLE d-qtd-reportada AS DECIMAL     NO-UNDO.


    ASSIGN dt-aux = data
           d-qtd-reportada = 0.

    bl-leitura:
    REPEAT:

        FOR EACH aponta-mqa NO-LOCK
            WHERE aponta-mqa.cod-estabel  = tt-param.cod-estabel
            AND   aponta-mqa.data         = dt-aux
            AND   aponta-mqa.cod-prod     = tt-param.cod-prod:

            ASSIGN d-qtd-reportada = d-qtd-reportada + aponta-mqa.qtd-falha.
    
        END.

        ASSIGN dt-aux = dt-aux + 1.

        IF MONTH(dt-aux) <> MONTH(data) THEN
            LEAVE bl-leitura.

    END.

    RETURN d-qtd-reportada.

END FUNCTION.


FUNCTION f-retorna-data-ini-mes RETURN DATE
    (INPUT mes-desc AS INTEGER) :

    DEFINE VARIABLE i-mes-aux AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ano-aux AS INTEGER     NO-UNDO.

    
    ASSIGN i-mes-aux = MONTH(tt-param.data-ini) - mes-desc
           i-ano-aux = YEAR(tt-param.data-ini).

    IF i-mes-aux <= 0 THEN
        ASSIGN i-mes-aux = i-mes-aux + 12
               i-ano-aux = i-ano-aux - 1.

    RETURN DATE(i-mes-aux, 01, i-ano-aux).

END FUNCTION.


FUNCTION f-conta-quebra RETURN INT
    (INPUT texto AS CHAR) :

    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    ASSIGN i-cont = 0.

    DO i-aux = 1 TO LENGTH(texto):
        
        IF SUBSTRING(texto, i-aux, 1) = CHR(10) OR
           SUBSTRING(texto, i-aux, 1) = CHR(13) THEN
            ASSIGN i-cont = i-cont + 1.

    END.

    IF i-cont > 0 THEN
        ASSIGN i-cont = i-cont - 1. /* Desconta 1 porque sempre considera 1 quebra para cada registro. Mas se a quebra estiver no texto, entao ir  duplicar a contagem. */

    RETURN i-cont.


END FUNCTION.

             

/* include padrÊo para output de relat«rios */
{include/i-rpout.i}

/* include com a defini¯Êo da frame de cabe¯alho e rodapý */
{include/i-rpcab.i}


FOR FIRST tt-param:
END.

/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESCPP084"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "CPP"
	    c-titulo-relat  = "Apontamentos MQA".


/* para nÊo visualizar cabe¯alho/rodapý em saðda RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilit˜rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.


/* corpo do relat«rio */

RUN pi-gera-totais-meses-anteriores.

RUN pi-gera-dados.

RUN pi-cria-csv.

RUN pi-cria-excel.


PAGE.


disp skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     tt-param.cod-prod    LABEL "Produto" FORMAT ">>>,>>>,>>9"  AT 04
     tt-param.data-ini    LABEL "Per¡odo"                 AT 04    "|<    >|" AT 22  tt-param.data-fim NO-LABEL                     AT 32
     with frame f-selec width 132 stream-io side-labels.


disp skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 4
     " - " tt-param.arquivo FORMAT "X(60)" 
     skip
     "Usu rio:" at 4
     tt-param.usuario 
     with frame f-impressao width 132 stream-io no-labels.

/*fechamento do output do relat«rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.

PROCEDURE pi-gera-dados:

    RUN pi-inicializar IN h-acomp (INPUT "Gera‡Æo dos Dados").

    ASSIGN i-cont-dias = 0
           i-nr-diario = 0.
     
    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:

        ASSIGN i-cont-dias = i-cont-dias + 1.
    
        FOR EACH aponta-mqa NO-LOCK
            WHERE aponta-mqa.cod-estabel     = tt-param.cod-estabel
            AND   aponta-mqa.data            = dt-aux
            AND (IF tt-param.cod-prod       <> 0 THEN aponta-mqa.cod-prod     = tt-param.cod-prod     ELSE YES)
            AND (IF tt-param.cod-falha      <> 0 THEN aponta-mqa.cod-falha    = tt-param.cod-falha    ELSE YES)
            AND (IF tt-param.origem-falha   <> 0 THEN aponta-mqa.origem-falha = tt-param.origem-falha ELSE YES)
            AND (IF tt-param.cod-componente <> "" THEN aponta-mqa.es-codigo = tt-param.cod-componente ELSE YES):                    
    
            FOR FIRST falha-mqa NO-LOCK
                WHERE falha-mqa.cod-falha = aponta-mqa.cod-falha:
            END.

            FOR FIRST item-mqa NO-LOCK
                WHERE item-mqa.cod-prod    = aponta-mqa.cod-prod
                  AND item-mqa.cod-estabel = aponta-mqa.cod-estabel:
            END.

            FOR FIRST origem-mqa NO-LOCK
                WHERE origem-mqa.origem-falha = aponta-mqa.origem-falha:
            END.
        
            CREATE tt-excel.
            ASSIGN tt-excel.cod-prod             = aponta-mqa.cod-prod
                   tt-excel.desc-prod            = string(aponta-mqa.cod-prod) + IF AVAIL item-mqa THEN " - " + item-mqa.descricao ELSE ""
                   tt-excel.nr-linha             = aponta-mqa.nr-linha
                   tt-excel.es-codigo            = aponta-mqa.es-codigo
                   tt-excel.local-montag         = aponta-mqa.local-montag   
                   tt-excel.origem               = IF AVAIL origem-mqa THEN origem-mqa.descricao ELSE ""
                   tt-excel.cod-falha            = aponta-mqa.cod-falha      
                   tt-excel.des-falha            = IF AVAIL falha-mqa THEN falha-mqa.descricao ELSE ""
                   tt-excel.data                 = aponta-mqa.data
                   tt-excel.cod-origem           = aponta-mqa.origem-falha
                   tt-excel.quantidade           = 0
                   tt-excel.qtd-produ            = 0
                   tt-excel.nr-placa-seq         = aponta-mqa.nr-placa-seq
                   tt-excel.log-possui-etiq-tec  = aponta-mqa.log-possui-etiq-tec
                   tt-excel.dt-registro          = aponta-mqa.dt-registro.
        
            IF tt-excel.log-possui-etiq-tec THEN
                ASSIGN tt-excel.desc-prod = tt-excel.desc-prod + " *".

            IF tt-param.cod-prod <> 0 THEN DO: 
                FIND FIRST tt-grafico
                    WHERE tt-grafico.origem = tt-excel.origem NO-ERROR.
                IF  NOT AVAIL tt-grafico THEN
                    CREATE tt-grafico.
                
                ASSIGN tt-grafico.origem = tt-excel.origem
                       tt-grafico.quant  = tt-grafico.quant + 1.
                
                de-tot-grafico = de-tot-grafico + 1.
            END.
            
            IF aponta-mqa.observacao <> "" THEN DO:

                ASSIGN i-nr-diario = i-nr-diario + 1.
    
                CREATE tt-diario.
                ASSIGN tt-diario.cod-prod     = aponta-mqa.cod-prod
                       tt-diario.desc-prod    = string(aponta-mqa.cod-prod) + IF AVAIL item-mqa THEN " - " + item-mqa.descricao ELSE ""
                       tt-diario.nr-linha     = aponta-mqa.nr-linha
                       tt-diario.es-codigo    = aponta-mqa.es-codigo
                       tt-diario.local-montag = aponta-mqa.local-montag   
                       tt-diario.origem       = IF AVAIL origem-mqa THEN origem-mqa.descricao ELSE ""
                       tt-diario.cod-falha    = aponta-mqa.cod-falha      
                       tt-diario.des-falha    = IF AVAIL falha-mqa THEN falha-mqa.descricao ELSE ""
                       tt-diario.data         = aponta-mqa.data
                       tt-diario.observacao   = replace(replace(aponta-mqa.observacao, CHR(10), CHR(10) + ";;;;;;"), CHR(13), CHR(13) + ";;;;;;")
                       tt-diario.qtd-produ    = 0.

                ASSIGN i-nr-diario = i-nr-diario + f-conta-quebra(tt-diario.observacao).      
            END.
        
            ASSIGN tt-excel.quantidade = tt-excel.quantidade + aponta-mqa.qtd-falha.        
        END.
    END.

END PROCEDURE.


PROCEDURE pi-cria-csv:

    DEF VAR wprod AS DECIMAL NO-UNDO.
    DEF VAR wdef  AS DECIMAL NO-UNDO.

    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-dt-registro AS CHAR        NO-UNDO.

    IF tt-param.tg-produ 
    THEN DO:
       FOR EACH tt-excel
           BREAK BY tt-excel.es-codigo:
       
           IF LAST-OF (tt-excel.es-codigo) 
           THEN DO:
               FOR EACH estrutura NO-LOCK
                  WHERE estrutura.es-codigo     = tt-excel.es-codigo
                    AND estrutura.data-inicio  <= TODAY
                    AND estrutura.data-termino >= TODAY :
                   
                   IF CAN-FIND (FIRST b-estrutura NO-LOCK
                                WHERE b-estrutura.es-codigo = estrutura.it-codigo
                                  AND b-estrutura.data-inicio  <= TODAY
                                  AND b-estrutura.data-termino >= TODAY) THEN DO:
                       RUN pi-sobe-estrutura (INPUT estrutura.it-codigo,
                                              INPUT estrutura.quant-usada).
                   END. 
               END.
       
               FOR EACH tt-produtos WHERE
                        tt-produtos.es-codigo = tt-excel.es-codigo
                        NO-LOCK.
       
                   FIND FIRST estrutura WHERE
                              estrutura.es-codigo     = tt-produtos.it-codigo AND
                              estrutura.data-inicio  <= TODAY                 AND
                              estrutura.data-termino >= TODAY
                              NO-LOCK NO-ERROR.
                   
                   IF NOT AVAIL estrutura 
                   THEN DO:
                   
                      ASSIGN d-qtd-prod = 0.
                   
                      FOR EACH rep-prod WHERE
                               rep-prod.it-codigo   = tt-produtos.it-codigo AND
                               rep-prod.cod-estabel = tt-param.cod-estabel  AND
                               rep-prod.data       >= tt-param.data-ini     AND
                               rep-prod.data       <= tt-param.data-fim
                               NO-LOCK.
                   
                          RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(rep-prod.data, "99/99/9999") + " Item: " + rep-prod.it-codigo).
       
                          ASSIGN d-qtd-prod = d-qtd-prod + rep-prod.qt-reporte - rep-prod.qt-estorno.
                   
                      END.
                   
                      ASSIGN tt-produtos.qtd-produ = tt-produtos.qtd-estru * d-qtd-prod.

                   END.
               END.
           END.
       END.
    END.

    RUN pi-inicializar IN h-acomp (INPUT "Cria‡Æo do Excel").

    OUTPUT STREAM st-excel TO value(tt-param.saida-excel) CONVERT TARGET "iso8859-1".
    
    PUT STREAM st-excel UNFORMATTED
        ";" SKIP
        ";;;;;;MQA" SKIP
        ";" SKIP
        "Linha;Produto;Componente;Local Mont;Origem;Falha;Dt.Apont;N£mero de Pe‡as Detectadas no Per¡odo".

    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:
        PUT STREAM st-excel UNFORMATTED 
            ";".
    END.
    
    PUT STREAM st-excel UNFORMATTED
        "" /*"Totais"*/
        SKIP.
    
    PUT STREAM st-excel UNFORMATTED
        ";;;;;;;".
    
    ASSIGN d-vol-prod = 0.

    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(dt-aux, "99/99/9999")).
    
        FOR FIRST estimativa-produ NO-LOCK
            WHERE estimativa-produ.cod-estabel = tt-param.cod-estabel
            AND   estimativa-produ.data        = dt-aux
            AND   estimativa-produ.cod-prod    = tt-param.cod-prod:
    
            PUT STREAM st-excel UNFORMATTED
                estimativa-produ.qtd-estimada.
    
            ASSIGN d-vol-prod = d-vol-prod + estimativa-produ.qtd-estimada.
    
        END.
    
        PUT STREAM st-excel UNFORMATTED ";".
    
    END.   
    
    /* Total Periodo */
    PUT STREAM st-excel UNFORMATTED 
        /*string(d-vol-prod) + ";".*/
         "" ";".
    
    
    /* Total Mes - 1 a 5 */
    /*PUT STREAM st-excel UNFORMATTED
        STRING(f-qtd-prevista-mes(f-retorna-data-ini-mes(1))) + ";" + 
        STRING(f-qtd-prevista-mes(f-retorna-data-ini-mes(2))) + ";" + 
        STRING(f-qtd-prevista-mes(f-retorna-data-ini-mes(3))) + ";" + 
        STRING(f-qtd-prevista-mes(f-retorna-data-ini-mes(4))) + ";" + 
        STRING(f-qtd-prevista-mes(f-retorna-data-ini-mes(5))) SKIP 
        ";;;;;;".   
        */
    PUT STREAM st-excel UNFORMATTED
        "" + ";" + 
        "" + ";" + 
        "" + ";" + 
        "" + ";" + 
        "" SKIP 
        ";;;;;;".   
   
    /* Dias */
    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:
    
        PUT STREAM st-excel UNFORMATTED
            ";" + SUBSTRING(STRING(dt-aux, "99/99/9999"), 1, 5).
    
    END.
    /*
    PUT STREAM st-excel UNFORMATTED
        ";Per¡odo"                                + ";" +
        f-desc-mes(MONTH(tt-param.data-ini) - 1) + ";" +
        f-desc-mes(MONTH(tt-param.data-ini) - 2) + ";" +
        f-desc-mes(MONTH(tt-param.data-ini) - 3) + ";" +
        f-desc-mes(MONTH(tt-param.data-ini) - 4) + ";" +
        f-desc-mes(MONTH(tt-param.data-ini) - 5) + ";" .
    */
    PUT STREAM st-excel UNFORMATTED
        ";"                                + ";" +
        "" + ";" +
        "" + ";" +
        "" + ";" +
        "" + ";" +
        "" + ";" .

    ASSIGN i-nr-linhas = 6.

    FOR EACH tt-excel
        BREAK BY tt-excel.cod-prod
              BY tt-excel.data
              BY tt-excel.nr-placa-seq
              BY tt-excel.local-montag
              BY tt-excel.cod-falha
              BY tt-excel.cod-origem:

        RUN pi-acompanhar IN h-acomp (INPUT " Local: " + string(tt-excel.local-montag) + " - Falha: " + string(tt-excel.cod-falha) + " - Data: " + STRING(tt-excel.data, "99/99/99")).
               
        ASSIGN d-total     = 0
               dt-ultima   = tt-param.data-ini
               i-nr-linhas = i-nr-linhas + 1
               c-desc-item = "".        

        IF tt-excel.nr-placa-seq NE 0 THEN DO:

            IF CAN-FIND(FIRST b-tt-excel
                        WHERE b-tt-excel.cod-prod     = tt-excel.cod-prod
                          AND b-tt-excel.data         = tt-excel.data
                          AND b-tt-excel.nr-placa-seq = tt-excel.nr-placa-seq
                          AND ROWID(b-tt-excel)       NE rowid(tt-excel))  THEN DO:
                ASSIGN c-desc-item = "".                
            END.
        END.

        IF LAST-OF(tt-excel.cod-prod) OR
           LAST-OF(tt-excel.data) OR
           LAST-OF(tt-excel.nr-placa-seq) THEN DO:

            ASSIGN c-desc-item = tt-excel.desc-prod.
        END.        
        ELSE DO:
            IF tt-excel.nr-placa-seq = 0 THEN
                ASSIGN c-desc-item = tt-excel.desc-prod.
        END.


        IF tt-excel.dt-registro NE ? THEN
            ASSIGN c-dt-registro = string(tt-excel.dt-registro,"99/99/9999").
        ELSE
            ASSIGN c-dt-registro = "".
        
        PUT STREAM st-excel UNFORMATTED 
            SKIP            
            string(tt-excel.nr-linha)   + ";" +
            c-desc-item                 + ";" +
            tt-excel.es-codigo          + ";" +
            tt-excel.local-montag       + ";" +
            tt-excel.origem             + ";" + 
            /*string(tt-excel.cod-falha)  + ";" + */
            tt-excel.des-falha          + ";" +
            c-dt-registro        + ";" .         
    
        IF dt-ultima <= (tt-excel.data - 1) THEN DO:
    
            DO dt-aux = dt-ultima TO tt-excel.data - 1:
                PUT STREAM st-excel UNFORMATTED ";".
            END.

        END.

        ASSIGN d-total = d-total + tt-excel.quantidade.

        PUT STREAM st-excel UNFORMATTED 
            string(tt-excel.quantidade) + ";".
    
        ASSIGN dt-ultima = tt-excel.data + 1.

        IF LAST-OF(tt-excel.local-montag) 
        OR LAST-OF(tt-excel.cod-origem) 
        OR LAST-OF(tt-excel.cod-falha) THEN DO:
            
            DO dt-aux = dt-ultima TO tt-param.data-fim:
                PUT STREAM st-excel UNFORMATTED ";".
            END.
            /*
            PUT STREAM st-excel UNFORMATTED
                STRING (d-total) + ";" +
                STRING (f-qtd-total-meses-ant( f-retorna-data-ini-mes(1), tt-excel.local-montag, tt-excel.cod-origem,   tt-excel.cod-falha)) + ";"
                STRING (f-qtd-total-meses-ant( f-retorna-data-ini-mes(2), tt-excel.local-montag, tt-excel.cod-origem,   tt-excel.cod-falha)) + ";"
                STRING (f-qtd-total-meses-ant( f-retorna-data-ini-mes(3), tt-excel.local-montag, tt-excel.cod-origem,   tt-excel.cod-falha)) + ";"
                STRING (f-qtd-total-meses-ant( f-retorna-data-ini-mes(4), tt-excel.local-montag, tt-excel.cod-origem,   tt-excel.cod-falha)) + ";"
                STRING (f-qtd-total-meses-ant( f-retorna-data-ini-mes(5), tt-excel.local-montag, tt-excel.cod-origem,   tt-excel.cod-falha)) + ";".
            */
        END.

    END.

    PUT STREAM st-excel UNFORMATTED 
        SKIP
        ";;;;;;;;;;".
    
    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:
        PUT STREAM st-excel UNFORMATTED ";".
    END.

    PUT STREAM st-excel UNFORMATTED
        /*"VOLUME ESTIMADO"  + ";" +
        string(d-vol-prod )*/
        SKIP(1)
        "DIµRIO DE BORDO E PLANO DE A€åES"
        SKIP
        "Linha;Produto;Componente;Local Mont;Origem;Falha;Observa‡Æo" 
        SKIP.

    FOR EACH tt-diario: 
      /*  BREAK BY tt-diario.nr-linha: */

        PUT STREAM st-excel UNFORMATTED
            string(tt-diario.nr-linha)  + ";" +
            tt-diario.desc-prod         + ";" +
            tt-diario.es-codigo         + ";" +
            tt-diario.local-montag      + ";" +
            tt-diario.origem            + ";" +
            /*string(tt-diario.cod-falha) + ";" +*/
            tt-diario.des-falha         + ";" +
            tt-diario.observacao
            SKIP.

        /*
        FIND FIRST tt-grafico
            WHERE tt-grafico.origem = tt-diario.origem NO-ERROR.
        IF  NOT AVAIL tt-grafico THEN
            CREATE tt-grafico.

        ASSIGN tt-grafico.origem = tt-diario.origem
               tt-grafico.quant  = tt-grafico.quant + 1.

        de-tot-grafico = de-tot-grafico + 1.
        */
    END.

    IF tt-param.cod-prod = 0 AND
       tt-param.tg-produ
    THEN DO:

       PUT STREAM st-excel UNFORMATTED
           SKIP(2)
           "ACOMPANHAMENTO DE DEFEITOS X COMPONENTES"
           SKIP
          /* "Componente;Produtos;Total Prod;Local Mont;Origem;Total Defeitos;% Def;Observa‡Æo" */
           "Componente;Total Prod;Total Defeitos;% Def"
           SKIP.

       FOR EACH tt-excel NO-LOCK
          BREAK BY tt-excel.es-codigo:

           ASSIGN wdef  = wdef  + tt-excel.quantidade.

           IF LAST-OF(tt-excel.es-codigo) 
           THEN DO:

              FOR EACH tt-produtos WHERE
                       tt-produtos.es-codigo = tt-excel.es-codigo
                       NO-LOCK.
                  ASSIGN wprod = wprod + tt-produtos.qtd-produ.
              END.

              PUT STREAM st-excel UNFORMATTED
                  tt-excel.es-codigo     + ";" +
                  string(wprod)          + ";" +
                  string(wdef)           + ";" +
                  IF (wdef  <> 0 AND
                      wprod <> 0) 
                      THEN String((wdef / wprod) * 100,"zzzzzz9.99")
                      ELSE "0,00"        + ";"
                  SKIP.

              ASSIGN i-nr-diario2 = i-nr-diario2 + 1.

              ASSIGN wprod = 0
                     wdef  = 0.
           END.
       END.
/*
       FOR EACH tt-excel NO-LOCK
          BREAK BY tt-excel.es-codigo:

           ASSIGN wprod = wprod + tt-excel.qtd-prod
                  wdef  = wdef  + tt-excel.quantidade.

           IF LAST-OF(tt-excel.es-codigo) 
           THEN DO:
              PUT STREAM st-excel UNFORMATTED
                  tt-excel.es-codigo     + ";" +
                  string(wprod)          + ";" +
                  string(wdef)           + ";" +
                  IF (wdef  <> 0 AND
                      wprod <> 0) 
                      THEN String((wdef / wprod) * 100,"zzzzzz9.99")
                      ELSE "0,00"        + ";"
                  SKIP.

              ASSIGN i-nr-diario2 = i-nr-diario2 + 1.

              ASSIGN wprod = 0
                     wdef  = 0.
           END.
       END. */
/*
       FOR EACH tt-diario 
           BREAK BY tt-diario.es-codigo
                 BY tt-diario.cod-prod:
           PUT STREAM st-excel UNFORMATTED
               tt-diario.es-codigo     + ";" +
              /* tt-diario.desc-prod     + ";" +
               String(tt-diario.qtd-produ,"zzzzzz9.99")     + ";" +
               tt-diario.local-montag  + ";" +
               tt-diario.origem        + ";" + */
               String(tt-diario.qtd-produ,"zzzzzz9.99")     + ";" +
               String(tt-diario.qtd-falha,"zzzzzz9.99")                  + ";" +
               IF (tt-diario.qtd-falha <> 0 AND
                  tt-diario.qtd-produ <> 0) THEN
                  String(tt-diario.qtd-falha / tt-diario.qtd-produ,"zzzzzz9.9999")
               ELSE "0,00"                      + ";" 
             /*  tt-diario.observacao    + ";" */
               SKIP.
       END. */
    END. 

    OUTPUT STREAM st-excel CLOSE.

END PROCEDURE.


PROCEDURE pi-cria-excel:

    RUN pi-inicializar IN h-acomp (INPUT "Formata‡Æo do Excel").

    DEFINE VARIABLE chExcel             AS COM-HANDLE       NO-UNDO.
    DEFINE VARIABLE chArquivo           AS COM-HANDLE       NO-UNDO.
    DEFINE VARIABLE chPlanilha          AS COM-HANDLE       NO-UNDO.
    DEFINE VARIABLE chSelecao           AS com-handle       NO-UNDO.
    DEFINE VARIABLE i-aux               AS INTEGER          NO-UNDO.
    DEFINE VARIABLE i-cont-fimsem       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE i-lin-aux           AS INTEGER          NO-UNDO.
    DEFINE VARIABLE i-col-aux           AS INTEGER          NO-UNDO.

    DEFINE VARIABLE d-problema          AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE d-atencao           AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE d-fator             AS DECIMAL          NO-UNDO.


    CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
    IF ERROR-STATUS:ERROR THEN 
        CREATE "Excel.Application":U chExcel.

    //chExcel:DisplayAlerts = FALSE.

    OS-RENAME VALUE(tt-param.saida) VALUE(REPLACE(tt-param.saida-excel, ".xlsx", ".csv")).

    ASSIGN chArquivo  = chExcel:WorkBooks:Open(REPLACE(tt-param.saida-excel, ".xlsx", ".csv")).
    ASSIGN chPlanilha = chArquivo:Sheets:Item(1).

    chPlanilha:SaveAs(tt-param.saida-excel,"51",,,,,) NO-ERROR.

    OS-DELETE VALUE(REPLACE(tt-param.saida-excel, ".xlsx", ".csv")).

    /**/

    /* Linha 2 - Altura */
    chPlanilha:Rows("2:2"):RowHeight = 40.


    /* Todas Colunas - Cor Branca */
    chSelecao = chPlanilha:Range(chPlanilha:COLUMNS(1), chPlanilha:COLUMNS(tt-param.data-fim - tt-param.data-ini + 13)).
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:ThemeColor = 1.
    chSelecao:Interior:TintAndShade = 0.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.

    
    /* Linha 4 - Altura */
    chSelecao = chPlanilha:Rows("4:4").
    chSelecao:Font:Bold = TRUE.
    chSelecao:RowHeight = 30.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Logo Intelbras */
    chPlanilha:Range("A2"):Select.
    chSelecao = chPlanilha:Pictures:Insert( SEARCH("image\logo-intelbras-grande.jpg") ).
    chSelecao:ShapeRange:ScaleWidth(0.8, 0, 0).
    chSelecao:ShapeRange:ScaleHeight(0.8, 0, 0).
    RELEASE OBJECT chSelecao.

    /* Logo MQA */
    chPlanilha:Range(chPlanilha:cells(2,6),chPlanilha:cells(2,6)):Select.
    chSelecao = chPlanilha:Pictures:Insert( SEARCH("image\logo-mqa.jpg") ).
    chSelecao:ShapeRange:ScaleWidth(0.7, 0, 0).
    chSelecao:ShapeRange:ScaleHeight(0.7, 0, 0).
    RELEASE OBJECT chSelecao.

    /* Logo SIM */
    chPlanilha:Range(chPlanilha:cells(2,i-cont-dias + 10),chPlanilha:cells(2,i-cont-dias + 10)):Select.
    chSelecao = chPlanilha:Pictures:Insert( SEARCH("image\logo-sim-intelbras.jpg") ).
    chSelecao:ShapeRange:ScaleWidth(0.7, 0, 0).
    chSelecao:ShapeRange:ScaleHeight(0.7, 0, 0).
    RELEASE OBJECT chSelecao.
                             

    /* MQA - Montagem Final */
    chSelecao = chPlanilha:Range(chPlanilha:cells(2,7),chPlanilha:cells(2,i-cont-dias + 7)).
    chSelecao:merge.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    chSelecao:Font:Size           = 30.
    chSelecao:Font:ThemeColor     = 1.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:Interior:Color      = 9656630.
    RELEASE OBJECT chSelecao.


    /* Linha */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,1),chPlanilha:cells(6,1)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Produto */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,2),chPlanilha:cells(6,2)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Componente */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,3),chPlanilha:cells(6,3)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Local Montagem */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,4),chPlanilha:cells(6,4)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Origem */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,5),chPlanilha:cells(6,5)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Descri‡Æo Falha */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,6),chPlanilha:cells(6,6)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.

    /* Dt. Apont */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,7),chPlanilha:cells(6,7)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* N£mero de Pe‡as detectadas no Per¡odo */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,8),chPlanilha:cells(4,i-cont-dias + 7)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /*/* Totais */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,i-cont-dias + 8),chPlanilha:cells(4,i-cont-dias + 13)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.


    /* Volume Estimado */
    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas + 1, i-cont-dias + 11),chPlanilha:cells(i-nr-linhas + 1,i-cont-dias + 12)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.*/

    /*chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas + 1, i-cont-dias + 11),chPlanilha:cells(i-nr-linhas + 1,i-cont-dias + 13)).
    chSelecao:Borders(5):LineStyle = -4142.
    chSelecao:Borders(6):LineStyle = -4142.

    chSelecao:Borders(7):LineStyle = 1.
    chSelecao:Borders(7):ColorIndex = 0.
    chSelecao:Borders(7):TintAndShade = 0.
    chSelecao:Borders(7):Weight = 2.

    chSelecao:Borders(8):LineStyle = 1.
    chSelecao:Borders(8):ColorIndex = 0.
    chSelecao:Borders(8):TintAndShade = 0.
    chSelecao:Borders(8):Weight = 2.

    chSelecao:Borders(9):LineStyle = 1.
    chSelecao:Borders(9):ColorIndex = 0.
    chSelecao:Borders(9):TintAndShade = 0.
    chSelecao:Borders(9):Weight = 2.

    chSelecao:Borders(10):LineStyle = 1.
    chSelecao:Borders(10):ColorIndex = 0.
    chSelecao:Borders(10):TintAndShade = 0.
    chSelecao:Borders(10):Weight = 2.

    chSelecao:Borders(11):LineStyle = 1.
    chSelecao:Borders(11):ColorIndex = 0.
    chSelecao:Borders(11):TintAndShade = 0.
    chSelecao:Borders(11):Weight = 2.

    chSelecao:Borders(12):LineStyle = 1.
    chSelecao:Borders(12):ColorIndex = 0.
    chSelecao:Borders(12):TintAndShade = 0.
    chSelecao:Borders(12):Weight = 2.
    RELEASE OBJECT chSelecao.*/

    
    /* Quadro Superior (Apontamentos) */
    chSelecao = chPlanilha:Range(chPlanilha:cells(4,1),chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
    chSelecao:Borders(5):LineStyle = -4142.
    chSelecao:Borders(6):LineStyle = -4142.

    chSelecao:Borders(7):LineStyle = 1.
    chSelecao:Borders(7):ColorIndex = 0.
    chSelecao:Borders(7):TintAndShade = 0.
    chSelecao:Borders(7):Weight = 2.

    chSelecao:Borders(8):LineStyle = 1.
    chSelecao:Borders(8):ColorIndex = 0.
    chSelecao:Borders(8):TintAndShade = 0.
    chSelecao:Borders(8):Weight = 2.

    chSelecao:Borders(9):LineStyle = 1.
    chSelecao:Borders(9):ColorIndex = 0.
    chSelecao:Borders(9):TintAndShade = 0.
    chSelecao:Borders(9):Weight = 2.

    chSelecao:Borders(10):LineStyle = 1.
    chSelecao:Borders(10):ColorIndex = 0.
    chSelecao:Borders(10):TintAndShade = 0.
    chSelecao:Borders(10):Weight = 2.

    chSelecao:Borders(11):LineStyle = 1.
    chSelecao:Borders(11):ColorIndex = 0.
    chSelecao:Borders(11):TintAndShade = 0.
    chSelecao:Borders(11):Weight = 2.

    chSelecao:Borders(12):LineStyle = 1.
    chSelecao:Borders(12):ColorIndex = 0.
    chSelecao:Borders(12):TintAndShade = 0.
    chSelecao:Borders(12):Weight = 2.
    RELEASE OBJECT chSelecao.
    

    /* Labels Superiores (Apontamentos) - Cor */
    chSelecao = chPlanilha:Range("A4:G6").
    chSelecao:Interior:Pattern = 1.
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:ThemeColor = 4.
    chSelecao:Interior:TintAndShade = 0.799981688894314.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.
    
    chSelecao = chPlanilha:Range("H4",chPlanilha:cells(4, i-cont-dias + 7)).
    chSelecao:Interior:Pattern = 1.
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:ThemeColor = 4.
    chSelecao:Interior:TintAndShade = 0.799981688894314.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.

    chSelecao = chPlanilha:Range("H5",chPlanilha:cells(6, i-cont-dias + 7)).
    chSelecao:Interior:Pattern = 1.
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:ThemeColor = 1.
    chSelecao:Interior:TintAndShade = -0.149998474074526.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.
   

    /* Pintura Sabados e Domingos */
    ASSIGN i-cont-fimsem = 7.

    DO dt-aux = tt-param.data-ini TO tt-param.data-fim:

        ASSIGN i-cont-fimsem = i-cont-fimsem + 1.

        IF WEEKDAY(dt-aux) = 1 OR
           WEEKDAY(dt-aux) = 7 THEN DO:

            chSelecao = chPlanilha:Range(chPlanilha:cells(7,i-cont-fimsem), chPlanilha:cells(i-nr-linhas, i-cont-fimsem)).
            chSelecao:Interior:Pattern = 1.
            chSelecao:Interior:PatternColorIndex = -4105.
            chSelecao:Interior:ThemeColor = 4.
            chSelecao:Interior:TintAndShade = 0.399975585192419.
            chSelecao:Interior:PatternTintAndShade = 0.
            RELEASE OBJECT chSelecao.

        END.
    END.

    /*/* Pintura Total Per¡odo Verde */
    chSelecao = chPlanilha:Range(chPlanilha:cells(7,i-cont-dias + 7), chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
    chSelecao:Interior:Pattern = 1.
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:Color = 5287936. /* Verde */
    chSelecao:Interior:TintAndShade = 0.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.*/

    ASSIGN i-lin-aux = 6.           

    /* Pintura Aten‡Æo e Urgente (Amarelo / Vermelho) */
    FOR FIRST item-mqa NO-LOCK
        WHERE item-mqa.cod-prod = tt-param.cod-prod
          AND item-mqa.cod-estabel = tt-param.cod-estabel:

        FOR EACH tt-excel
            BREAK BY tt-excel.cod-prod
                  BY tt-excel.data
                  BY tt-excel.nr-placa-seq
                  BY tt-excel.local-montag
                  BY tt-excel.cod-falha
                  BY tt-excel.cod-origem:         
        
            /*IF FIRST-OF(tt-excel.cod-prod) OR
               FIRST-OF(tt-excel.nr-placa-seq) OR
               FIRST-OF(tt-excel.local-montag) OR
               FIRST-OF(tt-excel.cod-falha) OR 
               FIRST-OF(tt-excel.cod-origem) THEN DO:*/
    
                ASSIGN i-lin-aux = i-lin-aux + 1
                       i-col-aux = 6.
    
                FOR FIRST indice-qualid NO-LOCK
                    WHERE indice-qualid.cod-estabel = tt-param.cod-estabel
                    AND   indice-qualid.it-codigo   = tt-excel.es-codigo:
    
                END.    
            /*END.*/
    
            /*DO dt-aux = tt-param.data-ini TO tt-param.data-fim:*/
    
            ASSIGN i-col-aux = 8 + (tt-excel.data - tt-param.data-ini).
    
            /*IF tt-excel.data = dt-aux THEN DO:*/

                IF AVAIL indice-qualid THEN DO:
    
                    FOR FIRST estimativa-produ NO-LOCK
                       WHERE estimativa-produ.cod-estabel = tt-param.cod-estabel
                       AND   estimativa-produ.data        = tt-excel.data
                       AND   estimativa-produ.cod-prod    = tt-param.cod-prod:
        
                        IF estimativa-produ.qtd-estimada <= item-mqa.vl-critico THEN DO:
            
                            /* Absoluto */
                            ASSIGN d-problema = indice-qualid.absol-problema
                                   d-atencao  = indice-qualid.absol-atencao.
            
                        END.
                        ELSE DO:
            
                            /* Relativo (Percentual) */
                            ASSIGN d-problema = indice-qualid.relat-problema / 100
                                   d-atencao  = indice-qualid.relat-atencao / 100.
            
                        END.
            
                        ASSIGN d-fator = tt-excel.quantidade / estimativa-produ.qtd-estimada.
    
                        IF d-fator >= d-problema THEN DO:
    
                            /*ASSIGN rt-status:FILLED = TRUE
                                   rt-status:BGCOLOR = 12.  /* Vermelho */*/
    
                            chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                            chSelecao:Interior:Pattern = 1.
                            chSelecao:Interior:PatternColorIndex = -4105.
                            chSelecao:Interior:Color = 255.
                            chSelecao:Interior:TintAndShade = 0.
                            chSelecao:Interior:PatternTintAndShade = 0.
                            RELEASE OBJECT chSelecao.
    
                        END.
                        ELSE IF d-fator >= d-atencao  THEN DO:
    
                            /*ASSIGN rt-status:FILLED = TRUE
                                   rt-status:BGCOLOR = 14.  /* Amarelo */*/
    
                            chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                            chSelecao:Interior:Pattern = 1.
                            chSelecao:Interior:PatternColorIndex = -4105.
                            chSelecao:Interior:Color = 65535.
                            chSelecao:Interior:TintAndShade = 0.
                            chSelecao:Interior:PatternTintAndShade = 0.
                            RELEASE OBJECT chSelecao.
    
                        END.

                        /* Come‡a logica aqui conforme chamado 124322 */
                        IF estimativa-produ.qtd-estimada < item-mqa.vl-critico 
                        THEN DO:

                           IF  tt-excel.quantidade >= indice-qualid.absol-problema
                           THEN DO:
                              /* Pinta Vermelho */
                              chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                              chSelecao:Interior:Pattern = 1.
                              chSelecao:Interior:PatternColorIndex = -4105.
                              chSelecao:Interior:Color = 255.
                              chSelecao:Interior:TintAndShade = 0.
                              chSelecao:Interior:PatternTintAndShade = 0.
                              RELEASE OBJECT chSelecao.
                           END.
                           ELSE DO:
                               IF (tt-excel.quantidade > indice-qualid.absol-atencao AND
                                   tt-excel.quantidade < indice-qualid.absol-problema)
                               THEN DO:
                                  /* Pinta Amarelo */
                                  chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                                  chSelecao:Interior:Pattern = 1.
                                  chSelecao:Interior:PatternColorIndex = -4105.
                                  chSelecao:Interior:Color = 65535.
                                  chSelecao:Interior:TintAndShade = 0.
                                  chSelecao:Interior:PatternTintAndShade = 0.
                                  RELEASE OBJECT chSelecao.
                               END.
                           END.
                        END.
                        ELSE DO:
                           IF (tt-excel.quantidade * 100 / estimativa-produ.qtd-estimada ) >= indice-qualid.relat-problema  
                           THEN DO:
                              /* Pinta Vermelho */
                              chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                              chSelecao:Interior:Pattern = 1.
                              chSelecao:Interior:PatternColorIndex = -4105.
                              chSelecao:Interior:Color = 255.
                              chSelecao:Interior:TintAndShade = 0.
                              chSelecao:Interior:PatternTintAndShade = 0.
                              RELEASE OBJECT chSelecao.
                           END.
                           ELSE DO:
                              IF ((tt-excel.quantidade * 100 / estimativa-produ.qtd-estimada ) > indice-qualid.relat-atencao AND
                                  (tt-excel.quantidade * 100 / estimativa-produ.qtd-estimada ) < indice-qualid.relat-problema)
                              THEN DO:
                                  /* Pinta Amarelo */
                                  chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-col-aux),chPlanilha:cells(i-lin-aux,i-col-aux)).
                                  chSelecao:Interior:Pattern = 1.
                                  chSelecao:Interior:PatternColorIndex = -4105.
                                  chSelecao:Interior:Color = 65535.
                                  chSelecao:Interior:TintAndShade = 0.
                                  chSelecao:Interior:PatternTintAndShade = 0.
                                  RELEASE OBJECT chSelecao.
                              END.
                           END.
                        END.
                        
                        IF LAST-OF(tt-excel.cod-prod) OR
                           LAST-OF(tt-excel.data) OR
                           LAST-OF(Tt-excel.nr-placa-seq) THEN DO:                            
                            
                            IF tt-excel.nr-placa-seq NE 0 THEN DO:
                                
                                IF CAN-FIND(FIRST b-tt-excel
                                            WHERE b-tt-excel.cod-prod     = tt-excel.cod-prod
                                              AND b-tt-excel.data         = tt-excel.data
                                              AND b-tt-excel.nr-placa-seq = tt-excel.nr-placa-seq
                                              AND rowid(b-tt-excel)       NE ROWID(tt-excel)) THEN DO:
                                    
                                    ASSIGN i-cont-placa = 0.
                                    FOR EACH  b-tt-excel
                                        WHERE b-tt-excel.cod-prod = tt-excel.cod-prod
                                          AND b-tt-excel.data     = tt-excel.data
                                          AND b-tt-excel.nr-placa = tt-excel.nr-placa-seq
                                          AND rowid(b-tt-excel)  NE rowid(tt-excel).

                                        ASSIGN i-cont-placa = i-cont-placa + 1.
                                    END.

                                    chSelecao = chPlanilha:Range(chPlanilha:cells((i-lin-aux - i-cont-placa),2),chPlanilha:cells(i-lin-aux,2)).                                    
                                    chSelecao:merge.                                    
                                    chSelecao:VerticalAlignment   = -4108. /* xlCenter */                                    
                                END.
                            END.
                        END.
                    END. /* for first estimativa-prod */
                END. /* avail indice-qualid */
                /*END.*/
            /*END.*/

           IF FIRST-OF(tt-excel.cod-prod) OR
              FIRST-OF(tt-excel.data) OR
              FIRST-OF(tt-excel.nr-placa-seq) OR
              FIRST-OF(tt-excel.local-montag) OR 
              FIRST-OF(tt-excel.cod-origem) OR
              FIRST-OF(tt-excel.cod-falha) 
           THEN DO:
              ASSIGN d-total2 = 0.
           END.

           ASSIGN d-total2 = d-total2 + tt-excel.quantidade.

           IF d-vol-prod < 6000
           THEN DO:
              IF d-total2 >= 120 
              THEN DO:
                 /* Pinta Vermelho */
                 chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-cont-dias + 7),chPlanilha:cells(i-lin-aux,i-cont-dias + 7)).
                 chSelecao:Interior:Pattern = 1.
                 chSelecao:Interior:PatternColorIndex = -4105.
                 chSelecao:Interior:Color = 255.
                 chSelecao:Interior:TintAndShade = 0.
                 chSelecao:Interior:PatternTintAndShade = 0.
                 RELEASE OBJECT chSelecao.
              END.
              ELSE DO:
                 IF (d-total2 > 60 AND
                     d-total2 < 120)
                 THEN DO:
                    /* Pinta Amarelo */
                    chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-cont-dias + 7),chPlanilha:cells(i-lin-aux,i-cont-dias + 7)).
                    chSelecao:Interior:Pattern = 1.
                    chSelecao:Interior:PatternColorIndex = -4105.
                    chSelecao:Interior:Color = 65535.
                    chSelecao:Interior:TintAndShade = 0.
                    chSelecao:Interior:PatternTintAndShade = 0.
                    RELEASE OBJECT chSelecao.
                 END.
              END.
           END.
           ELSE DO:
              IF (d-total2 * 100 / d-vol-prod ) >= indice-qualid.relat-problema
              THEN DO:
                 /* Pinta Vermelho */
                 chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-cont-dias + 7),chPlanilha:cells(i-lin-aux,i-cont-dias + 7)).
                 chSelecao:Interior:Pattern = 1.
                 chSelecao:Interior:PatternColorIndex = -4105.
                 chSelecao:Interior:Color = 255.
                 chSelecao:Interior:TintAndShade = 0.
                 chSelecao:Interior:PatternTintAndShade = 0.
                 RELEASE OBJECT chSelecao.
              END.
              ELSE DO:
                 IF ((d-total2 * 100 / d-vol-prod ) > indice-qualid.relat-atencao AND
                     (d-total2 * 100 / d-vol-prod ) < indice-qualid.relat-problema)
                 THEN DO:
                    /* Pinta Amarelo */
                    chSelecao = chPlanilha:Range(chPlanilha:cells(i-lin-aux,i-cont-dias + 7),chPlanilha:cells(i-lin-aux,i-cont-dias + 7)).
                    chSelecao:Interior:Pattern = 1.
                    chSelecao:Interior:PatternColorIndex = -4105.
                    chSelecao:Interior:Color = 65535.
                    chSelecao:Interior:TintAndShade = 0.
                    chSelecao:Interior:PatternTintAndShade = 0.
                    RELEASE OBJECT chSelecao.
                 END.
              END.
           END.
        END.
    END.
    

    /**/


    /* Di rio de Bordo e Plano de A‡äes */
    ASSIGN i-nr-linhas = i-nr-linhas + 3.
    chPlanilha:Rows(string(i-nr-linhas) + ":" + string(i-nr-linhas)):RowHeight = 30.
    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,1),chPlanilha:cells(i-nr-linhas,i-cont-dias + 7)).
    chSelecao:merge.
    chSelecao:Font:Bold           = TRUE.
    chSelecao:HorizontalAlignment = -4108. /* xlCenter */
    chSelecao:VerticalAlignment   = -4108. /* xlCenter */
    RELEASE OBJECT chSelecao.

    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,1), chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
    chSelecao:Interior:Pattern              = 1.
    chSelecao:Interior:PatternColorIndex    = -4105.
    chSelecao:Interior:ThemeColor           = 1.
    chSelecao:Interior:Color                = 9656630.
    chSelecao:Interior:PatternTintAndShade  = 0.
    chSelecao:Font:ThemeColor               = 1.
    RELEASE OBJECT chSelecao.


    /* Observa‡Æo (Label) */
    ASSIGN i-nr-linhas = i-nr-linhas + 1.
    chPlanilha:Rows(string(i-nr-linhas) + ":" + string(i-nr-linhas)):Font:Bold = TRUE.
    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,7),chPlanilha:cells(i-nr-linhas,i-cont-dias + 7)).
    chSelecao:merge.

    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas, 1), chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
    chSelecao:Interior:Pattern = 1.
    chSelecao:Interior:PatternColorIndex = -4105.
    chSelecao:Interior:ThemeColor = 4.
    chSelecao:Interior:TintAndShade = 0.799981688894314.
    chSelecao:Interior:PatternTintAndShade = 0.
    RELEASE OBJECT chSelecao.

    /* Observa‡Æo (Registros) */
    ASSIGN i-nr-linhas = i-nr-linhas + 1.

    DO i-aux = i-nr-linhas  TO (i-nr-linhas + i-nr-diario):

        chSelecao = chPlanilha:Range(chPlanilha:cells(i-aux,7),chPlanilha:cells(i-aux,i-cont-dias + 7)).
        chSelecao:merge.
        
    END.

    /* Di rio de Bordo e Plano de A‡äes (Registros) - Quadro */
    chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas - 2,1),chPlanilha:cells(i-nr-linhas + i-nr-diario, i-cont-dias + 7)).
    chSelecao:Borders(5):LineStyle = -4142.
    chSelecao:Borders(6):LineStyle = -4142.

    chSelecao:Borders(7):LineStyle = 1.
    chSelecao:Borders(7):ColorIndex = 0.
    chSelecao:Borders(7):TintAndShade = 0.
    chSelecao:Borders(7):Weight = 2.

    chSelecao:Borders(8):LineStyle = 1.
    chSelecao:Borders(8):ColorIndex = 0.
    chSelecao:Borders(8):TintAndShade = 0.
    chSelecao:Borders(8):Weight = 2.

    chSelecao:Borders(9):LineStyle = 1.
    chSelecao:Borders(9):ColorIndex = 0.
    chSelecao:Borders(9):TintAndShade = 0.
    chSelecao:Borders(9):Weight = 2.

    chSelecao:Borders(10):LineStyle = 1.
    chSelecao:Borders(10):ColorIndex = 0.
    chSelecao:Borders(10):TintAndShade = 0.
    chSelecao:Borders(10):Weight = 2.

    chSelecao:Borders(11):LineStyle = 1.
    chSelecao:Borders(11):ColorIndex = 0.
    chSelecao:Borders(11):TintAndShade = 0.
    chSelecao:Borders(11):Weight = 2.

    chSelecao:Borders(12):LineStyle = 1.
    chSelecao:Borders(12):ColorIndex = 0.
    chSelecao:Borders(12):TintAndShade = 0.
    chSelecao:Borders(12):Weight = 2.
    RELEASE OBJECT chSelecao.


    IF tt-param.cod-prod = 0 
    THEN DO:
        ASSIGN i-nr-linhas = i-aux.

       /* aqui */
       ASSIGN i-nr-linhas = i-nr-linhas + 1.
       chPlanilha:Rows(string(i-nr-linhas) + ":" + string(i-nr-linhas)):RowHeight = 30.
       chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,1),chPlanilha:cells(i-nr-linhas,i-cont-dias + 7)).
       chSelecao:merge.
       chSelecao:Font:Bold           = TRUE.
       chSelecao:HorizontalAlignment = -4108. /* xlCenter */
       chSelecao:VerticalAlignment   = -4108. /* xlCenter */
       RELEASE OBJECT chSelecao.
       
       chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,1), chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
       chSelecao:Interior:Pattern              = 1.
       chSelecao:Interior:PatternColorIndex    = -4105.
       chSelecao:Interior:ThemeColor           = 1.
       chSelecao:Interior:Color                = 9656630.
       chSelecao:Interior:PatternTintAndShade  = 0.
       chSelecao:Font:ThemeColor               = 1.
       RELEASE OBJECT chSelecao.
       
       
       /* Teste 2 */
       ASSIGN i-nr-linhas = i-nr-linhas + 1.
       chPlanilha:Rows(string(i-nr-linhas) + ":" + string(i-nr-linhas)):Font:Bold = TRUE.
       chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas,8),chPlanilha:cells(i-nr-linhas,i-cont-dias + 7)).
       chSelecao:merge.
       
       chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas, 1), chPlanilha:cells(i-nr-linhas, i-cont-dias + 7)).
       chSelecao:Interior:Pattern = 1.
       chSelecao:Interior:PatternColorIndex = -4105.
       chSelecao:Interior:ThemeColor = 4.
       chSelecao:Interior:TintAndShade = 0.799981688894314.
       chSelecao:Interior:PatternTintAndShade = 0.
       RELEASE OBJECT chSelecao.
       
       /* teste 3 */
       ASSIGN i-nr-linhas = i-nr-linhas + 1.
       
       DO i-aux = i-nr-linhas  TO (i-nr-linhas + i-nr-diario2):
       
           chSelecao = chPlanilha:Range(chPlanilha:cells(i-aux,8),chPlanilha:cells(i-aux,i-cont-dias + 7)).
           chSelecao:merge.
           
       END. 
       
       /* teste 4 */
       chSelecao = chPlanilha:Range(chPlanilha:cells(i-nr-linhas - 2,1),chPlanilha:cells(i-nr-linhas + i-nr-diario2, i-cont-dias + 7)).
       chSelecao:Borders(5):LineStyle = -4142.
       chSelecao:Borders(6):LineStyle = -4142.
       
       chSelecao:Borders(7):LineStyle = 1.
       chSelecao:Borders(7):ColorIndex = 0.
       chSelecao:Borders(7):TintAndShade = 0.
       chSelecao:Borders(7):Weight = 2.
       
       chSelecao:Borders(8):LineStyle = 1.
       chSelecao:Borders(8):ColorIndex = 0.
       chSelecao:Borders(8):TintAndShade = 0.
       chSelecao:Borders(8):Weight = 2.
       
       chSelecao:Borders(9):LineStyle = 1.
       chSelecao:Borders(9):ColorIndex = 0.
       chSelecao:Borders(9):TintAndShade = 0.
       chSelecao:Borders(9):Weight = 2.
       
       chSelecao:Borders(10):LineStyle = 1.
       chSelecao:Borders(10):ColorIndex = 0.
       chSelecao:Borders(10):TintAndShade = 0.
       chSelecao:Borders(10):Weight = 2.
       
       chSelecao:Borders(11):LineStyle = 1.
       chSelecao:Borders(11):ColorIndex = 0.
       chSelecao:Borders(11):TintAndShade = 0.
       chSelecao:Borders(11):Weight = 2.
       
       chSelecao:Borders(12):LineStyle = 1.
       chSelecao:Borders(12):ColorIndex = 0.
       chSelecao:Borders(12):TintAndShade = 0.
       chSelecao:Borders(12):Weight = 2.
       RELEASE OBJECT chSelecao.
    END. 

    IF tt-param.cod-prod <> 0 
    THEN DO:
       /* Quadro indice qualidade */
       chPlanilha:Range("A" + STRING(i-nr-linhas + i-nr-diario + 3)):Select.
       chSelecao = chPlanilha:Pictures:Insert( SEARCH("image\indice-qualidade.jpg") ).
       chSelecao:ShapeRange:ScaleWidth(1.0, 0, 0).
       chSelecao:ShapeRange:ScaleHeight(1.0, 0, 0).
       /*RELEASE OBJECT chSelecao. */
    END.

    /* Ajusta tamanho das Colunas */
    chPlanilha:Cells:EntireColumn:AutoFit.
    chPlanilha:Columns("A:A"):ColumnWidth = 10.
    //chPlanilha:Columns("G:G"):ColumnWidth = chPlanilha:Columns("H:H"):ColumnWidth.

    DEF VAR de-perc AS DEC NO-UNDO.

    FOR EACH tt-grafico
        BREAK BY tt-grafico.origem:

        IF  LAST-OF(tt-grafico.origem) THEN DO:
            CREATE tt-lista.
            ASSIGN tt-lista.origem = tt-grafico.origem
                   de-perc         = (tt-grafico.quant / de-tot-grafico) * 100
                   tt-lista.perc   = de-perc.
            IF  de-perc > de-maior-grafico THEN
                de-maior-grafico = de-perc.
        END.
    END.

    DEF VAR i       AS INTEGER NO-UNDO.
    DEF VAR j-ini   AS INTEGER NO-UNDO.
    DEF VAR j-fim   AS INTEGER NO-UNDO.
    DEF VAR c-sheet AS CHAR FORMAT "x(60)" NO-UNDO.                    

    RUN pi-sheet(INPUT tt-param.saida-excel,
                 OUTPUT c-sheet).

    chSelecao = chPlanilha:Range("A":U + STRING(i-nr-linhas + i-nr-diario + 12),"B":U + STRING(i-nr-linhas + i-nr-diario + 12)).

    IF tt-param.cod-prod <> 0
    THEN DO:
       chSelecao = chPlanilha:Range("A":U + STRING(i-nr-linhas + i-nr-diario + 12),"B":U + STRING(i-nr-linhas + i-nr-diario + 12)).
       chSelecao:Font:Bold           = TRUE.
       chSelecao:HorizontalAlignment = -4108. /* xlCenter */
       chSelecao:VerticalAlignment   = -4108. /* xlCenter */


        chPlanilha:Range("A":U + STRING(i-nr-linhas + i-nr-diario + 12)):VALUE = "Resumo".
        chPlanilha:Range("B":U + STRING(i-nr-linhas + i-nr-diario + 12)):VALUE = "(%)".
    
        j-ini = i-nr-linhas + i-nr-diario + 14.

        FOR EACH tt-lista:
            chPlanilha:Range("A":U + STRING(i-nr-linhas + i-nr-diario + 14 + i)):VALUE = tt-lista.origem.
            chPlanilha:Range("B":U + STRING(i-nr-linhas + i-nr-diario + 14 + i)):VALUE = ROUND(tt-lista.perc, 2).
            i = i + 1.
        END.
    END.

    j-fim = j-ini + (IF i = 0 THEN 0 ELSE i - 1).

    IF tt-param.cod-prod <> 0 
    THEN DO:

       chPlanilha:Range("J" + STRING(j-fim + 3)):Select.
       ASSIGN chSelecao = chArquivo:Charts:ADD()
              chSelecao:ChartType = 5 /* xl3DPie = -4102 */
              chSelecao:HasTitle = TRUE.
       
       FIND FIRST tt-excel NO-ERROR.

       chSelecao:ChartTitle:Characters:Text = "Origem " + (IF AVAIL tt-excel THEN tt-excel.desc-prod ELSE "").
       chSelecao:SetSourceData(chPlanilha:Range("A" + string(j-ini) + ":B" + STRING(j-fim)), 2).
       chSelecao:ApplyDataLabels(3 /* xlDataLabelsShowLabelAndPercent = 5 */).
       chSelecao:Location(2 /* xlLocationAsObject = 2 */, c-sheet).
    END.
    
    RELEASE OBJECT chSelecao.

    chPlanilha:Range("A1"):Select.

    chArquivo:Save.

    chPlanilha:Activate().

    ASSIGN chExcel:VISIBLE     = TRUE
           chExcel:WindowState = 3.

    /*chPasta:SaveAs(p-nome-arq-excel,,,,,,,,,,,).
    chPasta:CLOSE(NO).
    chExcel:QUIT().*/

    RELEASE OBJECT chExcel.
    RELEASE OBJECT chArquivo.
    RELEASE OBJECT chPlanilha  NO-ERROR.

END PROCEDURE.

PROCEDURE pi-gera-totais-meses-anteriores:

    DEF VAR da-ant AS DATE NO-UNDO.
    DEF VAR da-ini-meses AS DATE NO-UNDO.

    RUN pi-inicializar IN h-acomp (INPUT "Totalizando meses anteriores...").

    ASSIGN da-ini-meses = f-retorna-data-ini-mes(5).

    DO da-ant = da-ini-meses TO tt-param.data-ini - 1:
        
        FOR EACH aponta-mqa NO-LOCK
            WHERE aponta-mqa.cod-estabel       = tt-param.cod-estabel
            AND   aponta-mqa.data              = da-ant
            AND   aponta-mqa.cod-prod          = tt-param.cod-prod 
            AND   (IF tt-param.cod-prod       <> 0 THEN aponta-mqa.cod-prod  = tt-param.cod-prod        ELSE YES)
            AND   (IF tt-param.cod-falha      <> 0 THEN aponta-mqa.cod-falha = tt-param.cod-falha       ELSE YES) 
            AND   (IF tt-param.origem-falha   <> 0 THEN aponta-mqa.origem-falha = tt-param.origem-falha ELSE YES)
            AND   (IF tt-param.cod-componente <> "" THEN aponta-mqa.es-codigo = tt-param.cod-componente ELSE YES):
        
            FOR FIRST tt-excel-aux
                WHERE tt-excel-aux.local-montag = aponta-mqa.local-montag
                AND   tt-excel-aux.cod-falha    = aponta-mqa.cod-falha
                AND   tt-excel-aux.data         = aponta-mqa.data
                AND   tt-excel-aux.cod-origem   = aponta-mqa.origem-falha:
            END.

            IF NOT AVAIL tt-excel-aux THEN DO:
    
                FOR FIRST falha-mqa NO-LOCK
                    WHERE falha-mqa.cod-falha = aponta-mqa.cod-falha:
                END.

                FOR FIRST item-mqa NO-LOCK
                    WHERE item-mqa.cod-prod = aponta-mqa.cod-prod
                      AND item-mqa.cod-estabel = aponta-mqa.cod-estabel:
                END.

                FOR FIRST origem-mqa NO-LOCK
                    WHERE origem-mqa.origem-falha = aponta-mqa.origem-falha:
                END.
        
                CREATE tt-excel-aux.
                ASSIGN tt-excel-aux.cod-prod     = aponta-mqa.cod-prod
                       tt-excel-aux.desc-prod    = string(aponta-mqa.cod-prod) + IF AVAIL item-mqa THEN " - " + item-mqa.descricao ELSE ""
                       tt-excel-aux.nr-linha     = aponta-mqa.nr-linha
                       tt-excel-aux.es-codigo    = aponta-mqa.es-codigo
                       tt-excel-aux.local-montag = aponta-mqa.local-montag   
                       tt-excel-aux.origem       = IF AVAIL origem-mqa THEN origem-mqa.descricao ELSE ""
                       tt-excel-aux.cod-falha    = aponta-mqa.cod-falha      
                       tt-excel-aux.des-falha    = IF AVAIL falha-mqa THEN falha-mqa.descricao ELSE ""
                       tt-excel-aux.data         = aponta-mqa.data
                       tt-excel-aux.cod-origem   = aponta-mqa.origem-falha
                       tt-excel-aux.quantidade   = 0.
        
            END.

            ASSIGN tt-excel-aux.quantidade = tt-excel-aux.quantidade + aponta-mqa.qtd-falha.
        
        END.
    
    END.

    /*
    OUTPUT STREAM a TO c:\temp\excel.csv CONVERT TARGET "iso8859-1".
    PUT STREAM A "PRODUTO;DESC;LINHA;ES-CODIGO;LOCAL;ORIGEM;FALHA;DESC-FALHA;DATA;COD-ORIGEM;QUANTIDADE"  SKIP.
                 

    FOR EACH tt-excel-aux:
        PUT STREAM a tt-excel-aux.cod-prod     ";"
                     tt-excel-aux.desc-prod    ";"
                     tt-excel-aux.nr-linha     ";"
                     tt-excel-aux.es-codigo    ";"
                     tt-excel-aux.local-montag ";"
                     tt-excel-aux.origem       ";"
                     tt-excel-aux.cod-falha    ";"
                     tt-excel-aux.des-falha    ";"
                     tt-excel-aux.data         ";"
                     tt-excel-aux.cod-origem   ";"
                     tt-excel-aux.quantidade   ";" SKIP.
    END.
    OUTPUT STREAM a CLOSE.
    */


END PROCEDURE.


PROCEDURE pi-sheet:

    DEF INPUT  PARAM c-sheet AS CHAR FORMAT "x(60)" NO-UNDO.
    DEF OUTPUT PARAM c-sheet-new AS CHAR FORMAT "x(60)" NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.

    ASSIGN c-sheet = REPLACE(c-sheet, ".xlsx", "").

    DO  i = LENGTH(c-sheet) TO 1 BY -1:
    
        IF  SUBSTR(c-sheet,i,1) = "/" OR SUBSTR(c-sheet,i,1) = "\" THEN
            LEAVE.
    
        ASSIGN c-sheet-new = c-sheet-new + SUBSTR(c-sheet,i,1).
    
    END.
    ASSIGN c-sheet     = c-sheet-new
           c-sheet-new = "".
    
    DO  i = LENGTH(c-sheet) TO 1 BY -1:
        ASSIGN c-sheet-new = c-sheet-new + SUBSTR(c-sheet,i,1).
    END.

END.

PROCEDURE pi-sobe-estrutura:
    DEFINE INPUT PARAM p-it-codigo AS CHAR.
    DEFINE INPUT PARAM d-qtd-est   AS DECI.

    FOR EACH b-estrutura NO-LOCK
       WHERE b-estrutura.es-codigo = p-it-codigo
         AND b-estrutura.data-inicio  <= TODAY
         AND b-estrutura.data-termino >= TODAY:

        IF NOT CAN-FIND(FIRST b2-estrutura
                        WHERE b2-estrutura.es-codigo = b-estrutura.it-codigo
                          AND b2-estrutura.data-inicio  <= TODAY
                          AND b2-estrutura.data-termino >= TODAY) THEN DO:
            RUN pi-cria-produto(INPUT d-qtd-est).
        END.
        ELSE DO:
            RUN pi-sobe-estrutura (INPUT b-estrutura.it-codigo,
                                   INPUT b-estrutura.quant-usada * d-qtd-est).
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-produto:
    DEFINE INPUT PARAM d-qtd-est2   AS DECI.

    FIND FIRST tt-produtos WHERE
               tt-produtos.es-codigo = estrutura.es-codigo   AND
               tt-produtos.it-codigo = b-estrutura.it-codigo
               NO-ERROR.

    IF NOT AVAIL tt-produtos 
    THEN DO:

        CREATE tt-produtos.
        ASSIGN tt-produtos.es-codigo = estrutura.es-codigo
               tt-produtos.it-codigo = b-estrutura.it-codigo
               tt-produtos.qtd-estru = d-qtd-est2.

    END.

END PROCEDURE.




