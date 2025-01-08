/*****************************************************************************
**     Programa.........: esp/cpp/escpp023rp.p
**     Descricao .......: ComissÆo revenda
**     Versao...........: 1.00.000
**     Autor............: Clayton Antunes
**     Criado...........: 01/03/2006
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP023 2.04.00.004}

/****************************  Definitions  ****************************/
{esp/cpp/escpp023tt.i}
{include/i-rpvar.i}
{cdp/cd0666.i}

/****************************  Temp-Tables  ****************************/

/****************************  Variaveis    ****************************/
DEF VAR dt-data AS DATE.


/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE TEMP-TABLE tt-posicoes
    FIELD it-codigo LIKE monta-estrutura.es-codigo
    FIELD posicao   AS CHAR
    FIELD montadora LIKE monta-estrutura.montador.



CREATE tt-param.

RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEF VAR h-acomp AS HANDLE NO-UNDO.
FIND FIRST empresa NO-LOCK WHERE
           empresa.ep-codigo = tt-param.ep-codigo NO-ERROR.

/*
ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "ComissÆo Revenda"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESCPP023"
       c-versao       = "2.04"
       c-revisao      = "001".
*/

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Montando Relat¢rio...").
    RUN pi-relat.
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN pi-imprime.


    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.
/* fim do programa */

PROCEDURE pi-relat:
    FOR EACH tt-seq:
        DELETE tt-seq.
    END.
    FOR EACH estrutura NO-LOCK                                           WHERE
             estrutura.it-codigo = tt-param.cod-item AND
             estrutura.data-inicio <= TODAY                              AND
             estrutura.data-termino > TODAY:
        IF estrutura.es-codigo begins "108" THEN DO:
           FIND item NO-LOCK WHERE
                item.it-codigo = estrutura.es-codigo NO-ERROR.
           ASSIGN c-descricao = item.descricao-1 + item.descricao-2.
        END.

        IF tt-param.l-parcial THEN DO:
            /*Faz impressÆo somente dos componentes selecionados, 
              feito para economizar, desnecess rio impressÆo de todos os componentes*/
            IF NOT CAN-FIND(FIRST tt-digita 
                            WHERE tt-digita.componente = estrutura.es-codigo 
                              AND tt-digita.selecionado) THEN NEXT.
        END.

        FOR EACH monta-estrutura NO-LOCK                          WHERE
                 monta-estrutura.it-codigo = estrutura.it-codigo  AND
                 monta-estrutura.es-codigo = estrutura.es-codigo: 

            RUN piQuebraPosicao (INPUT monta-estrutura.posicao).

            FOR EACH tt-posicoes:

                FIND FIRST tt-seq                                                  
                    WHERE tt-seq.it-codigo = tt-posicoes.it-codigo                  
                    AND   tt-seq.posicao   = tt-posicoes.posicao
                    AND   tt-seq.montadora = tt-posicoes.montadora NO-ERROR.
    
                IF NOT AVAIL tt-seq THEN DO:
                   CREATE tt-seq.
                   ASSIGN tt-seq.it-codigo = tt-posicoes.it-codigo
                          tt-seq.posicao   = tt-posicoes.posicao
                          tt-seq.montadora = tt-posicoes.montadora.
                END.

            END.

        END.
    END.

    ASSIGN i-ind = 0
           c-posicao = ""
           c-desc-componente = ""             
           c-desc-componente-2 = ""
           i-montadora = 0
           c-item = "".


    FIND item NO-LOCK WHERE
         item.it-codigo = tt-param.cod-item NO-ERROR.
    ASSIGN c-desc-temp = item.descricao-1 + item.descricao-2
           c-desc-acabado = "".

    ASSIGN i-centro = (35 - length(c-desc-temp)) / 2 + 1
           substr(c-desc-acabado[1],i-centro,35) = c-desc-temp
           substr(c-desc-acabado[2],i-centro,35) = c-desc-temp
           substr(c-desc-acabado[3],i-centro,35) = c-desc-temp. 

END PROCEDURE.

PROCEDURE pi-imprime:
    DEFINE VARIABLE c-desc-aux AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linha    AS INTEGER     NO-UNDO INITIAL 0.

/*     /* manda para bandeja Manual "*/                                       */
/*     put UNFORMATTED  chr(027) + chr(038) + chr(108) + chr(050) + chr(072). */

    /* a4 */
    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(050) + chr(054) + chr(065).

    /* densidade horizontal */
    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).

    /* espacamento de linha */
    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).

    /* Comprimento da p gina */
    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(100) + chr(080).

    /********* ETIQUETA PEQUENA **********/
    IF tt-param.Ident = 1 THEN DO:
        FOR EACH tt-seq,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-seq.it-codigo:
            
            ASSIGN i-ind = i-ind + 1.

            IF i-ind = 4 THEN DO:
                ASSIGN i-linha = i-linha + 1.

                IF i-linha > 19 THEN DO:
                    PAGE.

                    ASSIGN i-linha = 1.
                END.

                if line-counter <= 7 then do:
                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).

                    /* espacamento de linha */
                    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).

                    /* Posiciona o cursor na coluna */
                    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 

                    put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                        space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                        "Placa: " tt-param.cod-item format "X(07)" " - " 
                        trim(c-desc-acabado[1]) format "X(35)" skip
                        "Placa: " c-descricao       
                        space(40) "Pagina: " page-number format ">>9" skip(1).

                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
    
                    /* espacamento de linha */
                    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(052) + chr(067).
                END.

                RUN imprime-pequena.

                ASSIGN c-posicao = ""
                       c-desc-componente = ""
                       c-desc-componente-2 = ""
                       i-montadora = 0
                       c-item = ""
                       i-ind = 1.
            END.

            ASSIGN i-centro = (35 - length(tt-seq.posicao)) / 2 + 1
                   substr(c-posicao[i-ind],i-centro,35) = tt-seq.posicao
                   c-desc-temp = SUBSTRING(item.desc-item, 1, 30)
                   c-desc-temp-2 = SUBSTRING(item.desc-item, 31).

            ASSIGN i-centro = (30 - length(trim(c-desc-temp))) / 2 + 1
                   substr(c-desc-componente[i-ind],i-centro,30) = c-desc-temp
                   i-centro = (30 - length(trim(c-desc-temp-2))) / 2 + 1
                   substr(c-desc-componente-2[i-ind],i-centro,30) = c-desc-temp-2
                   i-montadora[i-ind] = tt-seq.montadora
                   c-item[i-ind] = "(" + tt-seq.it-codigo + ")".
        END.

        IF i-ind <> 0 THEN DO:
            IF i-ind = 1 THEN
                ASSIGN c-desc-acabado[2] = ""
                       c-desc-acabado[3] = "".

            IF i-ind = 2 THEN
                ASSIGN c-desc-acabado[3] = "".

            ASSIGN i-linha = i-linha + 1.

            IF i-linha > 19 THEN DO:
                PAGE.

                ASSIGN i-linha = 1.
            END.

            if line-counter <= 7 then do:
                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).

                /* espacamento de linha */
                put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).

                /* Posiciona o cursor na coluna */
                put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 

                put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                    space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                    "Placa: " tt-param.cod-item format "X(07)" " - " 
                    trim(c-desc-acabado[1]) format "X(35)" skip
                    "Placa: " c-descricao       
                    space(40) "Pagina: " page-number format ">>9" skip(1).

                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).

                /* espacamento de linha */
                put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(052) + chr(067).
            END.

            RUN imprime-pequena.
        END.
    END.

    /************ ETIQUETA GRANDE ***********/
    IF tt-param.Ident = 2 THEN DO:
        FOR EACH tt-seq,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-seq.it-codigo:

            ASSIGN i-ind = i-ind + 1.

            IF i-ind = 3 THEN DO:
                ASSIGN i-linha = i-linha + 1.

                IF i-linha > 11 THEN DO:
                    PAGE.

                    ASSIGN i-linha = 1.
                END.

                if line-counter <= 7 then do:
                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                    
                    /* espacamento de linha */
                    put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).
                    
                    /* Posiciona o cursor na coluna */
                    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
                    
                    put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                        space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                        "Placa: " tt-param.cod-item format "X(07)" " - " 
                        trim(c-desc-acabado[1]) format "X(35)" skip
                        "Placa: " c-descricao       
                        space(40) "Pagina: " page-number format ">>9" skip(1).
                    
                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + "4" + chr(083).
                    
                    /* espacamento de linha */
                    put UNFORMATTED chr(027) + chr(038) + chr(108) + CHR(055) + chr(067).
                    
                    /* Posiciona o cursor na linha 4 */
                    put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(082).  
                END.
                    
                RUN imprime-grande.
                    
                ASSIGN c-posicao = ""
                       c-desc-componente = ""
                       c-desc-componente-2 = ""
                       i-montadora = 0
                       c-item = ""
                       i-ind = 1.
            END.
                
            ASSIGN i-centro = (35 - length(tt-seq.posicao)) / 2 + 1
                   substr(c-posicao[i-ind],i-centro,35) = tt-seq.posicao
                   c-desc-temp = SUBSTRING(item.desc-item, 1, 30)
                   c-desc-temp-2 = SUBSTRING(item.desc-item, 31).
                
            ASSIGN i-centro = (30 - length(trim(c-desc-temp))) / 2 + 1
                   substr(c-desc-componente[i-ind],i-centro,30) = c-desc-temp
                   i-centro = (30 - length(trim(c-desc-temp-2))) / 2 + 1
                   substr(c-desc-componente-2[i-ind],i-centro,30) = c-desc-temp-2
                   i-montadora[i-ind] = tt-seq.montadora
                   c-item[i-ind] = "(" + tt-seq.it-codigo + ")".
        END.
            
        IF i-ind <> 0 THEN DO:
            IF i-ind = 1 THEN
                ASSIGN c-desc-acabado[2] = "".

            ASSIGN i-linha = i-linha + 1.

            IF i-linha > 11 THEN DO:
                PAGE.

                ASSIGN i-linha = 1.
            END.

            if line-counter <= 7 then do:
                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                
                /* espacamento de linha */
                put UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).
                
                /* Posiciona o cursor na coluna */
                put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
                
                put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                    space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                    "Placa: " tt-param.cod-item format "X(07)" " - " 
                    trim(c-desc-acabado[1]) format "X(35)" skip
                    "Placa: " c-descricao       
                    space(40) "Pagina: " page-number format ">>9" skip(1).
                
                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + "4" + chr(083).
                
                /* espacamento de linha */
                put UNFORMATTED chr(027) + chr(038) + chr(108) + CHR(055) + chr(067).
                
                /* Posiciona o cursor na linha 4 */
                put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(082).  
            END.
                
            RUN imprime-grande.
        END.
    END.

    /************ ETIQUETA MEDIA ***********/
    IF tt-param.Ident = 3 THEN DO:
        /* densidade horizontal */
        put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
        
        /* espacamento de linha */
        put UNFORMATTED chr(027) + chr(038) + chr(108) + CHR(054) + chr(067).

        FOR EACH tt-seq,
            FIRST item NO-LOCK
            WHERE item.it-codigo = tt-seq.it-codigo:

            ASSIGN i-ind = i-ind + 1.
                
            IF i-ind = 3 THEN DO:
                ASSIGN i-linha = i-linha + 1.
                    
                IF i-linha > 13 THEN DO:
                    PAGE.
                        
                    ASSIGN i-linha = 1.
                END.
                    
                if line-counter <= 7 then do:
                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                    
                    /* espacamento de linha */
                    PUT UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).
                    
                    /* Posiciona o cursor na coluna */
                    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
                    
                    put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                        space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                        "Placa: " tt-param.cod-item format "X(07)" " - " 
                        trim(c-desc-acabado[1]) format "X(35)" skip
                        "Placa: " c-descricao       
                        space(40) "Pagina: " page-number format ">>9" skip(1).
                    
                    /* densidade horizontal */
                    put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                    
                    /* espacamento de linha */
                    put UNFORMATTED chr(027) + chr(038) + chr(108) + CHR(054) + chr(067).
                END.
                    
                RUN imprime-media.
                    
                ASSIGN c-posicao = ""
                       c-desc-componente = ""
                       c-desc-componente-2 = ""
                       i-montadora = 0
                       c-item = ""
                       i-ind = 1.
            END.
                
            ASSIGN i-centro = (35 - length(tt-seq.posicao)) / 2 + 1
                   substr(c-posicao[i-ind],i-centro,35) = tt-seq.posicao
                   c-desc-temp = SUBSTRING(item.desc-item, 1, 30)
                   c-desc-temp-2 = SUBSTRING(item.desc-item, 31).

            ASSIGN i-centro = (30 - length(trim(c-desc-temp))) / 2 + 1
                   substr(c-desc-componente[i-ind],i-centro,30) = c-desc-temp
                   i-centro = (30 - length(trim(c-desc-temp-2))) / 2 + 1
                   substr(c-desc-componente-2[i-ind],i-centro,30) = c-desc-temp-2
                   i-montadora[i-ind] = tt-seq.montadora
                   c-item[i-ind] = "(" + tt-seq.it-codigo + ")".
        END.
            
        IF i-ind <> 0 THEN DO:
            IF i-ind = 1 THEN
                ASSIGN c-desc-acabado[2] = "".

            ASSIGN i-linha = i-linha + 1.
                    
            IF i-linha > 13 THEN DO:
                PAGE.
                    
                ASSIGN i-linha = 1.
            END.
                
            if line-counter <= 7 then do:
                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                
                /* espacamento de linha */
                PUT UNFORMATTED chr(027) + chr(038) + chr(108) + chr(053) + chr(067).
                
                /* Posiciona o cursor na coluna */
                put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
                
                put UNFORMATTED "SEQUENCIA DE MONTAGEM "
                    space(43) "Ultima Alteracao: " c-dt-ult-alter skip
                    "Placa: " tt-param.cod-item format "X(07)" " - " 
                    trim(c-desc-acabado[1]) format "X(35)" skip
                    "Placa: " c-descricao       
                    space(40) "Pagina: " page-number format ">>9" skip(1).
                
                /* densidade horizontal */
                put UNFORMATTED chr(027) + chr(038) + chr(107) + chr(050) + chr(083).
                
                /* espacamento de linha */
                put UNFORMATTED chr(027) + chr(038) + chr(108) + CHR(054) + chr(067).
            END.
                
            RUN imprime-media.
        END.
    END.

    OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE imprime-pequena.
    
    /****************** Primeira Linha - Local Montagem *******************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
    
    /* Caracter do inicio da linha, canto superior esquerdo */
    put UNFORMATTED chr(218). 

    /* Posiciona o cursor na linha */
    /*put UNFORMATTED chr(027) + chr(038) + chr(097) + "8" + chr(082).  */

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067). 

    /* Primeira Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),41) format "x(34)" .

    /* Caracter de meio da linha, separador das colunas  */
    put UNFORMATTED chr(194).

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "36" + chr(067).

    /* Segunda Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),41) format "x(34)" .
 
    /* Caracter de meio da linha, separador das colunas  */
    put UNFORMATTED chr(194).

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "71" + chr(067).

    /* Terceira Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),41) format "x(34)" .
 
    /* Caracter de final da linha, canto superior direito */
    put UNFORMATTED chr(191) skip.



    /****************** Segunda Linha - Local Montagem *******************/
    /* Alterar Conjunto de Caract‚r - ISO 8859-1 */
    put UNFORMATTED chr(027) + chr(040) + chr(048) + chr(078).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|" .                         

    /* Habilita impressao Negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put c-posicao[1].

    /* Desabilita negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "35" + chr(067).
    put UNFORMATTED "|" .
       
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 36 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "36" + chr(067).  
    put c-posicao[2].

    /* Desabilita impressao negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
  
    /* Posiciona o cursor na coluna 70 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "70" + chr(067).
    put UNFORMATTED "|".

    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 81 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "71" + chr(067).  
    put c-posicao[3].

    /* Desabilita impressao negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
  
    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "105" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** Terceira Linha - Descricao do Item ***************/
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 3 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(067).
    put c-desc-componente[1].

    /* Posiciona o cursor na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "35" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 38 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).
    put c-desc-componente[2].

    /* Posiciona o cursor na coluna 70 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "70" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 73 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "73" + chr(067).
    put c-desc-componente[3].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "105" + chr(067).
    put UNFORMATTED "|" skip.


    /******************** Quarta Linha - Descricao do Item ***************/
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 3 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(067).
    put c-desc-componente-2[1].

    /* Posiciona o cursor na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "35" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 38 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).
    put c-desc-componente-2[2].

    /* Posiciona o cursor na coluna 70 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "70" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 73 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "73" + chr(067).
    put c-desc-componente-2[3].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "105" + chr(067).
    put UNFORMATTED "|" skip.



    /********************* Quinta Linha - Item Pai **********************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put c-desc-acabado[1].

    /* Posiciona o cursor na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "35" + chr(067).
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 36 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "36" + chr(067).
    put c-desc-acabado[2].

    /* Posiciona o cursor na coluna 70 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "70" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna 71 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "71" + chr(067).
    put c-desc-acabado[3].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "105" + chr(067).
    put UNFORMATTED "|" skip.



    /**************** Sexta Linha - Montadora e Codigo do Item *************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put i-montadora[1] space(10) c-item[1].

    /* Posiciona o cursor na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "35" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "36" + chr(067).
    put i-montadora[2] space(10) c-item[2].

    /* Posiciona o cursor na coluna 70 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "70" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna 71 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "71" + chr(067).
    put i-montadora[3] space(10) c-item[3].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "105" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** S‚tima Linha - Traco Inferior *********************/
    /* Alterar Conjunto de Caract‚r - Windows 3.1 */
    PUT UNFORMATTED chr(027) + chr(040) + chr(049) + chr(048) + chr(085).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).

    /* Caracter de inicio de linha, canto inferior esquerdo */
    put UNFORMATTED chr(192) .

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put UNFORMATTED fill(chr(196),41) format "x(34)".

    /* Caracter de separacao das colunas */
    put UNFORMATTED chr(193).

    /* Posiciona o cursor na coluna 36 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "36" + chr(067).
    put UNFORMATTED fill(chr(196),41) format "x(34)".
    
    /* Caracter de separacao das colunas */
    put UNFORMATTED chr(193).

    /* Posiciona o cursor na coluna 71 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "71" + chr(067).
    put UNFORMATTED fill(chr(196),41) format "x(34)".
 
    /* Caracter de final de linha, canto inferior direito */
    put UNFORMATTED chr(217).

END PROCEDURE.




PROCEDURE imprime-grande.

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
    
    /* Caracter do inicio da linha, canto superior esquerdo */
    put UNFORMATTED chr(218). 

    /* Posiciona o cursor na linha 8 */
    /*put UNFORMATTED chr(027) + chr(038) + chr(097) + "8" + chr(082).  */

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067). 

    /* Primeira Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),41) format "x(36)" .

    /* Caracter de meio da linha, separador das colunas  */
    put UNFORMATTED chr(194).

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).

    /* Segunda Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),41) format "x(36)" .
 
    /* Caracter de final da linha, canto superior direito */
    put UNFORMATTED chr(191) skip.



    /****************** Segunda Linha - Local Montagem *******************/
    /* Alterar Conjunto de Caract‚r - ISO 8859-1 */
    put UNFORMATTED chr(027) + chr(040) + chr(048) + chr(078).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|" .                         

    /* Habilita impressao Negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put c-posicao[1].

    /* Desabilita negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona na coluna 46 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "37" + chr(067).
    put UNFORMATTED "|" .
       
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).  
    put c-posicao[2].

    /* Desabilita impressao negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
  
    /* Posiciona o cursor na coluna 102 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "74" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** Terceira Linha - Descricao do Item ***************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 3 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(067).
    put c-desc-componente[1].

    /* Posiciona o cursor na coluna 46 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "37" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 49 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "40" + chr(067).
    put c-desc-componente[2].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "74" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** Quarta Linha - Descricao do Item ***************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 3 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "3" + chr(067).
    put c-desc-componente-2[1].

    /* Posiciona o cursor na coluna 46 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "37" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 49 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "40" + chr(067).
    put c-desc-componente-2[2].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "74" + chr(067).
    put UNFORMATTED "|" skip.



    /********************* Quinta Linha - Item Pai **********************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put c-desc-acabado[1].

    /* Posiciona o cursor na coluna 46 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "37" + chr(067).
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).
    put c-desc-acabado[2].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "74" + chr(067).
    put UNFORMATTED "|" skip.



    /**************** Sexta Linha - Montadora e Codigo do Item *************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put i-montadora[1] space(10) c-item[1].

    /* Posiciona o cursor na coluna 35 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "37" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).
    put i-montadora[2] space(10) c-item[2].

    /* Posiciona o cursor na coluna 105 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "74" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** S‚tima Linha - Traco Inferior *********************/
    /* Alterar Conjunto de Caract‚r - Windows 3.1 */
    PUT UNFORMATTED chr(027) + chr(040) + chr(049) + chr(048) + chr(085).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).

    /* Caracter de inicio de linha, canto inferior esquerdo */
    put UNFORMATTED chr(192) .

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put UNFORMATTED fill(chr(196),41) format "x(36)".

    /* Caracter de separacao das colunas */
    put UNFORMATTED chr(193).

    /* Posiciona o cursor na coluna 36 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "38" + chr(067).
    put UNFORMATTED fill(chr(196),41) format "x(36)".
    
    /* Caracter de final de linha, canto inferior direito */
    put UNFORMATTED chr(217).

END PROCEDURE.

PROCEDURE imprime-media.

    /****************** Primeira Linha - Local Montagem *******************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067). 
    
    /* Caracter do inicio da linha, canto superior esquerdo */
    put UNFORMATTED chr(218). 

    /* Posiciona o cursor na linha */
    /*put UNFORMATTED chr(027) + chr(038) + chr(097) + "8" + chr(082).  */

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067). 

    /* Primeira Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),46) format "x(46)" .

    /* Caracter de meio da linha, separador das colunas  */
    put UNFORMATTED chr(194).

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "48" + chr(067).

    /* Segunda Linha - Traco Superior */
    put UNFORMATTED fill(chr(196),46) format "x(46)" .
    
    /* Caracter de final da linha, canto superior direito */
    put UNFORMATTED chr(191) skip.



    /****************** Segunda Linha - Local Montagem *******************/
    /* Alterar Conjunto de Caract‚r - ISO 8859-1 */
    put UNFORMATTED chr(027) + chr(040) + chr(048) + chr(078).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|" .                         

    /* Habilita impressao Negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 4 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "4" + chr(067).
    put c-posicao[1].

    /* Desabilita negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona na coluna 49 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "47" + chr(067).
    put UNFORMATTED "|" .
       
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

    /* Posiciona o cursor na coluna 52 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "52" + chr(067).  
    put c-posicao[2].

    /* Desabilita impressao negrito e torna impressao normal */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
  
   
    /* Posiciona o cursor na coluna 99 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "94" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** Terceira Linha - Descricao do Item ***************/
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 6 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "6" + chr(067).
    put c-desc-componente[1].

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "47" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 54 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "54" + chr(067).
    put c-desc-componente[2].

    
    /* Posiciona o cursor na coluna 94 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "94" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** Quarta Linha - Descricao do Item ***************/
    /* Habilita impressao negrito */
    put UNFORMATTED chr(027) + chr(040) + chr(115) + chr(048) + chr(066).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|".

    /* Posiciona o cursor na coluna 6 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "6" + chr(067).
    put c-desc-componente-2[1].

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "47" + chr(067).    
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 54 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "54" + chr(067).
    put c-desc-componente-2[2].

    
    /* Posiciona o cursor na coluna 94 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "94" + chr(067).
    put UNFORMATTED "|" skip.



    /********************* Quinta Linha - Item Pai **********************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    PUT UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 4 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "4" + chr(067).
    put c-desc-acabado[1].

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "47" + chr(067).
    put UNFORMATTED "|" .

    /* Posiciona o cursor na coluna 52 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "52" + chr(067).
    put c-desc-acabado[2].

    
    /* Posiciona o cursor na coluna 94 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "94" + chr(067).
    put UNFORMATTED "|" skip.



    /**************** Sexta Linha - Montadora e Codigo do Item *************/
    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna 4 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "4" + chr(067).
    put i-montadora[1] space(10) c-item[1].

    /* Posiciona o cursor na coluna 47 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "47" + chr(067).
    put UNFORMATTED "|".

    /* Posiciona o cursor na coluna */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "52" + chr(067).
    put i-montadora[2] space(10) c-item[2].

   
    /* Posiciona o cursor na coluna 94 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "94" + chr(067).
    put UNFORMATTED "|" skip.



    /******************** S‚tima Linha - Traco Inferior *********************/
    /* Alterar Conjunto de Caract‚r - Windows 3.1 */
    PUT UNFORMATTED chr(027) + chr(040) + chr(049) + chr(048) + chr(085).

    /* Posiciona o cursor na coluna 0 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "0" + chr(067).

    /* Caracter de inicio de linha, canto inferior esquerdo */
    put UNFORMATTED chr(192) .

    /* Posiciona o cursor na coluna 1 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "1" + chr(067).
    put UNFORMATTED fill(chr(196),48) format "x(48)".

    /* Caracter de separacao das colunas */
    put UNFORMATTED chr(193).

    /* Posiciona o cursor na coluna 48 */
    put UNFORMATTED chr(027) + chr(038) + chr(097) + "48" + chr(067).
    put UNFORMATTED fill(chr(196),46) format "x(46)".
   
 
    /* Caracter de final de linha, canto inferior direito */
    put UNFORMATTED chr(217).

END PROCEDURE.



PROCEDURE piQuebraPosicao:

    DEFINE INPUT PARAMETER p-posicao AS CHAR NO-UNDO.

    DEFINE VARIABLE i-geral AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-virgula-geral AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-pedaco AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-virgula-pedaco AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pos-ini AS INTEGER     NO-UNDO.


    EMPTY TEMP-TABLE tt-posicoes.

    ASSIGN c-pedaco = ""
           i-pos-ini = 1.

    DO i-geral = 1 TO LENGTH(p-posicao):
       
        IF SUBSTRING(p-posicao, i-geral, 1) = "," THEN
            ASSIGN i-virgula-geral = i-geral.
                                  
        ASSIGN c-pedaco = c-pedaco + SUBSTRING(p-posicao, i-geral, 1).

        IF SUBSTRING(c-pedaco, LENGTH(c-pedaco), 1) = ","  THEN
            ASSIGN i-virgula-pedaco = LENGTH(c-pedaco).

        IF LENGTH(c-pedaco) = 35 OR
            i-geral = LENGTH(p-posicao) THEN DO:

            IF SUBSTRING(p-posicao, i-geral + 1, 1) = "," THEN
                ASSIGN i-virgula-pedaco = LENGTH(c-pedaco) + 1
                       i-virgula-geral = i-geral + 1.

            IF i-geral = LENGTH(p-posicao) THEN 
                ASSIGN i-virgula-pedaco = LENGTH(c-pedaco) + 1.

            /*
            MESSAGE c-pedaco SKIP
                    i-pos-ini SKIP
                    i-virgula-geral SKIP
                    i-virgula-pedaco
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                */

            ASSIGN c-pedaco = SUBSTRING(p-posicao, i-pos-ini, i-virgula-pedaco - 1).
            
            CREATE tt-posicoes.
            ASSIGN tt-posicoes.it-codigo = monta-estrutura.es-codigo
                   tt-posicoes.posicao   = c-pedaco
                   tt-posicoes.montadora = monta-estrutura.montador.

            IF i-geral < LENGTH(p-posicao) THEN
            ASSIGN c-pedaco = ""
                   i-pos-ini = i-virgula-geral + 1
                   i-geral = i-virgula-geral.

        END.

    END.

END PROCEDURE.




/*

PROCEDURE arquivo.

    DEF VAR i-col-ini AS INT INITIAL 1.
    DEF VAR i-col-fim AS INT INITIAL 1500.
    DEF VAR c-arq-grava AS CHAR FORMAT "x(40)" INITIAL "spool/".
    DEF VAR c-texto AS CHAR FORMAT "x(40)".
    DEF VAR c-texto-ant AS CHAR FORMAT "x(40)".
    DEF VAR i-lin-ini AS INT.
    DEF VAR i-lin-fim AS INT.
    DEF VAR c-ini AS CHAR FORMAT "x(30)" INITIAL "spool/".
    DEF VAR c-arq-arq AS CHAR.
    DEF VAR c-nr-arqs AS CHAR FORMAT "x(30)".
    DEF VAR c-arquivo AS CHAR.

    DEF TEMP-TABLE tt-arquivo
        FIELD c-1 AS CHAR
        FIELD c-2 AS CHAR
        FIELD usuario AS CHAR FORMAT "x(12)"
        FIELD c-4 AS CHAR
        FIELD c-5 AS CHAR
        FIELD c-6 AS CHAR
        FIELD c-7 AS CHAR
        FIELD c-8 AS CHAR
        FIELD arquivo AS CHAR FORMAT "x(45)"
        FIELD geracao AS CHAR FORMAT "x(15)".
    
    DEF QUERY q-arquivo FOR tt-arquivo. 

    DEF BROWSE br-arquivo QUERY q-arquivo

    DEF TEMP-TABLE tt-rel
        FIELD nr-linha as int format ">>>>>>>>9"
        FIELD linha as char format "x(1500)"
        INDEX linha is primary nr-linha.

    DEF BUFFER b-tt-rel FOR tt-rel.    

    DEF QUERY q-editor FOR tt-rel.
    DEF BROWSE br-editor QUERY q-editor
    DISP tt-rel.linha format "x(300)" with 10 down no-box.

    DEF var i-cont   as int.
    DEF var c-linha  like tt-rel.linha.

    def var c-regua as char format "x(1500)" initial 
    "1234567.10....+...20....+...30....+...40....+...50....+...60....+...70....+...80....+...90....+..100....+..110....+..120....+..130....+..140....+..150....+..160....+..170....+..180....+..190....+..200....+..210....+..220....+..230....+..240....+..250....+..260....+..270....+..280....+..290....+..300....+..310....+..320....+..330....+..340....+..350....+..360....+..370....+..380....+..390....+..400....+..410....+..420....+..430....+..440....+..450....+..460....+..470....+..480....+..490....+..500.......510....+..520....+..530....+..540....+..550....+..560....+..570....+..580....+..590....+..600....+..610....+..620....+..630....+..640....+..650....+..660....+..670....+..680....+..690....+..700....+..710....+..720....+..730....+.~.740....+..750....+..760....+..770....+..780....+..790....+..800....+..810....+~..820....+..830....+..840....+..850....+..860....+..870....+..880....+..890....~+..900....+..910....+..920....+..930....+..940....+..950....+..960....+..970...~.+..980....+..990....+.1000....+...10....+...20....+...30....+...40....+...50....+...60....+...70....+...~80....+...90....+..100....+..110....+..120....+..130....+..140....+..150....+..160....+..170....+..180....+..190....+..200....+..210....+..220....+..230....+.~.240....+..250....+..260....+..270....+..280....+..290....+..300....+..310....+~..320....+..330....+..340....+..350....+..360....+..370....+..380....+..390....~+..400....+..410....+..420....+..430....+..440....+..450....+..460....+..470...~.+..480....+..490....+..500".           


    DEF var u-linha as int.
    DEF var u-col as int.
    DEF var x-cab-1a as int initial 1.
    DEF var x-cab as int initial 0.
    DEF var y-cab as int initial 0.

    DEF var ult-linha as int.
    DEF var c-arq-ent as char format "x(54)" initial "spool/".
    DEF var c-arq-sai as char.

    ON RETURN OF br-arquivo IN FRAME f-br-arquivo DO:
       ASSIGN c-arq-ent = tt-arquivo.arquivo.
       IF OPSYS = "Unix" THEN DO:
          IF NOT c-arq-ent begins "/" then 
             ASSIGN c-arquivo = "/usr8/progems/emscar/" + c-arq-ent.
          ELSE 
             ASSIGN c-arquivo = c-arq-ent.
       END.
    END.

    ON LEAVE OF br-arquivo in frame fPage6 DO:
       HIDE FRAME fpage5 no-pause.
    END.


    DEF var c-usu-ini as char format "x(12)".
    DEF var c-usu-fim as char format "x(12)".

    ASSIGN c-saida = "spool/cons-rel.lst".



/*   Selecao  -----------  */
        FOR each tt-arquivo:
            delete tt-arquivo.
        END.
        
        IF OPSYS = "win32" THEN DO:
           DOS SILENT DIR spool\ /b > spool\arquivos.            
           INPUT from spool\arquivos.
           REPEAT:
                CREATE tt-arquivo.
                IMPORT unformatted tt-arquivo.arquivo.
           END.
           INPUT CLOSE.    
           DOS SILENT DEL spool\arquivos.            
        END.        
        ELSE DO:
           INPUT through who am i.
           IMPORT c-usu-ini.
           ASSIGN c-usu-fim = c-usu-ini.
           INPUT close.

           bloco:
                REPEAT ON ENDKEY UNDO, LEAVE:
                    IMPORT c-nr-arqs.
                    HIDE MESSAGE NO-PAUSE.
                    INPUT CLOSE.
                    IF INT(c-nr-arqs) > 0 THEN DO:
                        INPUT FROM VALUE(c-arq-arq).
                        REPEAT:
                            CREATE  tt-arquivo.
                                import  tt-arquivo.c-1
                                        tt-arquivo.c-2
                                        tt-arquivo.usuario
                                        tt-arquivo.c-4
                                        tt-arquivo.c-5
                                        tt-arquivo.c-6
                                        tt-arquivo.c-7
                                        tt-arquivo.c-8
                                        tt-arquivo.arquivo.
                                        ASSIGN tt-arquivo.geracao = tt-arquivo.c-6 + "-" + tt-arquivo.c-7 + "-" + tt-arquivo.c-8.
                        END.
                        INPUT CLOSE.

                        FOR EACH tt-arquivo WHERE
                                 tt-arquivo.usuario < c-usu-ini OR 
                                 tt-arquivo.usuario > c-usu-fim:
                                 DELETE tt-arquivo.
                        END.
                        LEAVE bloco.
                    END.
                    ELSE DO:
                        MESSAGE "Mascara de Selecao incorreta. Tente novamente." view-as  alert-box.
                        UNDO bloco, retry.        
                    END.
                END.
        END.
         
        HIDE FRAME f-selecao NO-PAUSE.
        
        OPEN QUERY q-arquivo FOR EACH tt-arquivo.
        UPDATE br-arquivo WITH FRAME f-br-arquivo.
        
        HIDE FRAME f-br-arquivo NO-PAUSE.        

        HIDE MESSAGE NO-PAUSE.
        END.
        HIDE frame f-br-arquivo no-pause.
        HIDE frame f-selecao no-pause.


/*   Consulta  ----------- */

       FOR EACH tt-rel:
           DELETE tt-rel.
       END.

       INPUT FROM VALUE(c-arquivo).
       ASSIGN i-cont = 0.
       REPEAT:
            ASSIGN i-cont = i-cont + 1
                   c-linha = "".
            IMPORT UNFORMATTED c-linha.
            CREATE tt-rel.                   
                ASSIGN tt-rel.nr-linha = i-cont
                       tt-rel.linha = c-linha.
       END.
       INPUT CLOSE.             

       FIND LAST tt-rel NO-ERROR.
       IF NOT AVAIL tt-rel THEN DO:
            MESSAGE "O arquivo selecionado nao possui dados para serem visualizados."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
       END.
       ASSIGN ult-linha = tt-rel.nr-linha - 1 .
       ASSIGN u-linha = x-cab + x-cab-1a 
              u-col   = y-cab.

       
REPEAT on endkey undo, leave:

    DISP SUBSTRING(c-regua,1,y-cab) + substring(c-regua,u-col + 1,80) format "x(80)"
         with no-labels no-box overlay.

    FOR EACH tt-rel WHERE
             tt-rel.nr-linha >= x-cab-1a AND 
             tt-rel.nr-linha <= x-cab + x-cab-1a - 1:
        disp substring(tt-rel.linha,1,y-cab) + 
             substring(tt-rel.linha,u-col + 1,80) format "x(80)" with overlay
             no-labels no-box /* row 3 */.
    END.
    pause 0.

    FOR EACH tt-rel WHERE
             tt-rel.nr-linha >= u-linha AND
             tt-rel.nr-linha <= u-linha + 19 - x-cab - 1: 
        DISP substring(tt-rel.linha,1,y-cab) + substring(tt-rel.linha,u-col + 1,80 - y-cab) format "x(80)"
             with  overlay row x-cab + 2 with no-labels no-box width 100.
    END.

    PUT SCREEN "Lin: " + string(u-linha)  + " - " + string(u-linha + 19 - x-cab - 1) + " de " + string(ult-linha) row 22 col 54.

    if keylabel(lastkey) = "F2" or keylabel(lastkey) = "CTRL-W" then do:
        update c-arq-grava with row 8 centered overlay frame f-grava.
        hide frame f-saida no-pause.
        output to value(c-arq-grava).
        for each b-tt-rel:
            put b-tt-rel.linha skip.
        end.
        output close.
    end.

    if keylabel(lastkey) = "F6" or keylabel(lastkey) = "CTRL-P" then do:
        update i-col-ini validate(i-col-ini >= 1,
        "A coluna inicial deve ser maior ou igual a 1") skip
               i-col-fim skip
               c-texto 
               with row 8 centered side-labels overlay frame f-busca
               title " Localizar ".
    
        assign c-texto = "*" + trim(c-texto) + "*".
        find first tt-rel
             where substring(tt-rel.linha,i-col-ini,i-col-fim - i-col-ini + 1)
             matches(c-texto).
        
        if avail tt-rel then do:
            assign u-linha = tt-rel.nr-linha + x-cab.
            assign u-col = i-col-ini - y-cab - 1.
            if u-col < y-cab then assign u-col = y-cab.
        end.
        else do:
            message "O texto solicitado nao foi encontrado" view-as alert-box.
        end.
    end.


    if keylabel(lastkey) = "F3" or keylabel(lastkey) = "CTRL-T" then do:
    
        update i-col-ini validate(i-col-ini >= 1,"A coluna inicial deve ser mai~or ou igual a 1")  skip
               i-col-fim skip
               c-texto-ant help "Para substituir tudo, informe: trocar tudo"                skip
               c-texto 
               with row 8 centered side-labels overlay frame f-troca
               title " Substituir ".
    
        for each b-tt-rel:
            if c-texto-ant <> "trocar tudo" then do:
            if substring(b-tt-rel.linha,i-col-ini,i-col-fim - i-col-ini + 1) =
                substring(c-texto-ant,1,i-col-fim - i-col-ini + 1) then
            assign substring(b-tt-rel.linha,i-col-ini,i-col-fim - i-col-ini + 1)                     = substring(c-texto,1,i-col-fim - i-col-ini + 1).
            end.
            else
            assign substring(b-tt-rel.linha,i-col-ini,i-col-fim - i-col-ini + 1)                     = substring(c-texto,1,i-col-fim - i-col-ini + 1).
            
        end.
        
        assign u-linha = tt-rel.nr-linha + x-cab.
        assign u-col = i-col-ini - y-cab - 1.
        if u-col < y-cab then assign u-col = y-cab.
    end.


    if keylabel(lastkey) = "F9" or keylabel(lastkey) = "CTRL-D" then do:
    
        update i-col-ini validate(i-col-ini >= 1,"A coluna inicial deve ser mai~~or ou igual a 1")  skip
               i-col-fim skip
               c-texto-ant help "Para substituir tudo, informe: trocar tudo"   ~             skip
               c-texto 
               with row 8 centered side-labels overlay frame f-troca
               title " Substituir ".
    
        for each b-tt-rel:
            assign b-tt-rel.linha = substring(b-tt-rel.linha,1,i-col-ini - 1)
                    + substring(c-texto,1,3) + substring(b-tt-rel.linha,i-col-ini,2000).
            
        end.
        
        assign u-linha = tt-rel.nr-linha + x-cab.
        assign u-col = i-col-ini - y-cab - 1.
        if u-col < y-cab then assign u-col = y-cab.
    end.




    
    if keylabel(lastkey) = "F7" or keylabel(lastkey) = "CTRL-R" then do:
    
        find next tt-rel
             where substring(tt-rel.linha,i-col-ini,i-col-fim - i-col-ini + 1)
             matches(c-texto).
        
        if avail tt-rel then do:
            assign u-linha = tt-rel.nr-linha + x-cab.
            assign u-col = i-col-ini - y-cab - 1.
            if u-col < y-cab then assign u-col = y-cab.
        end.
        else do:
            message "O texto solicitado nao foi encontrado" view-as alert-box.
        end.
    end.
     
    
    if keylabel(lastkey) = "F5" or keylabel(lastkey) = "CTRL-G" then do:

        assign i-lin-ini = u-linha
               i-lin-fim = u-linha + 19 - x-cab - 1.
        update i-lin-ini  skip
               i-lin-fim 
               with side-labels frame f-linhas row 8 centered overlay
               title "Impressao".
               
        assign c-opcao = "arquivo".
        
        {cdp/cd9530.i}

        


        for each b-tt-rel
           where b-tt-rel.nr-linha >= i-lin-ini
             and b-tt-rel.nr-linha <= i-lin-fim:
            disp substring(b-tt-rel.linha,1,265) format "x(265)"
                 with width 270 no-labels. 
        end.
        page.
        
        output close.
        
    
    end.
    
end.
     
     end.



END PROCEDURE.

  */

