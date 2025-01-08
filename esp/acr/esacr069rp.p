{utp/ut-glob.i}
{include/i-rpvar.i}


DEFINE VARIABLE c-dir-retorno AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD up-compras       AS LOG
    FIELD transacoes       AS LOG
    FIELD atu-clientes     AS LOG
    FIELD pagtos           AS LOG
    FIELD param-comp       AS LOG
    FIELD motivo           AS LOG.

DEFINE TEMP-TABLE tt-arquivos 
    FIELD arquivo AS CHAR
    FIELD layout  AS CHAR
    FIELD mes     AS INT
    FIELD dia     AS INT.

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

/*gera tt com os arquivos e os respectivos layouts*/
RUN pi-lista-arquivos. 

/*Chama as apis de importa‡Æo*/
RUN pi-importa.

RETURN "OK".

PROCEDURE pi-importa:

    FOR EACH tt-arquivos
          BY tt-arquivos.mes
          BY tt-arquivos.dia 
          BY tt-arquivos.layout
          BY tt-arquivos.arquivo:

        IF  tt-param.atu-clientes
        AND tt-arquivos.layout = "8.6" THEN
            RUN esp/acr/esacr037.p (INPUT tt-arquivos.layout, 
                                    INPUT tt-arquivos.arquivo).
    
        IF  tt-param.up-compras 
        AND tt-arquivos.layout = "8.3" THEN
            RUN esp/acr/esacr044.p (INPUT tt-arquivos.arquivo).
    
        IF  tt-param.transacoes 
        AND tt-arquivos.layout = "8.5" THEN
            RUN esp/acr/esacr037.p (INPUT tt-arquivos.layout, 
                                    INPUT tt-arquivos.arquivo).
    
        IF  tt-param.pagtos 
        AND tt-arquivos.layout = "8.7" THEN
            RUN esp/acr/esacr046.p (INPUT tt-arquivos.arquivo, 
                                    INPUT TODAY).
    
        IF  tt-param.param-comp
        AND tt-arquivos.layout = "8.8" THEN
            RUN esp/acr/esacr038.p (INPUT tt-arquivos.arquivo).
    
        IF  tt-param.motivo 
        AND tt-arquivos.layout = "8.9" THEN
            RUN esp/acr/esacr039.p (INPUT tt-arquivos.arquivo).
    END.

    RETURN "OK".
END.

PROCEDURE pi-lista-arquivos:
    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    
    IF  AVAIL int-param-supcard THEN DO:
        IF OPSYS = "UNIX" THEN DO:
            ASSIGN c-dir-retorno = int-param-supcard.diretorio-retorno-unix.
        END.
        ELSE DO:
            ASSIGN c-dir-retorno = int-param-supcard.diretorio-retorno.
        END.
    END.
    
    INPUT FROM OS-DIR(c-dir-retorno).
    
    blk_proc_arq:
    REPEAT:
        IMPORT UNFORMATTED c-aux.
    
        IF SUBSTRING(c-aux,LENGTH(c-aux),1) = "F" /* Arquivo */ THEN DO:
            ASSIGN c-arquivo = TRIM(ENTRY(2,c-aux,"~"")).
            
            IF  SUBSTRING(c-arquivo,1,2) = "UP"     /* Uploads */       
            AND ENTRY(2,c-arquivo,".")   = "RET"    /* Retorno */  THEN DO:
    
                ASSIGN i-seq = INT(SUBSTRING(c-arquivo,9,3)).

                /* Intervalo do arquivo de Upload de Compras (8.3) /* UPG7DDMM001.RET */*/
                IF  i-seq >= 1 AND i-seq < 5 THEN DO:
                    CREATE tt-arquivos.
                    ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                           tt-arquivos.layout  = "8.3"
                           tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,5,2))
                           tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,7,2)).
                END.
    
                /* Intervalo do arquivo de Upload Outras Transa‡äes (8.5) /* UPG7DDMM005.RET ou UPG7DDMM010.RET */*/
                IF  i-seq >= 5 AND i-seq <= 10 THEN DO:
                    CREATE tt-arquivos.
                    ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                           tt-arquivos.layout  = "8.5"
                           tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,5,2))
                           tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,7,2)).
                END.
            END.
            
            IF  SUBSTRING(c-arquivo,1,3)  = "CLI"   /* Atu Cliente */   
            AND ENTRY(2,c-arquivo,".")    = "TXT"   /* Arq Texto   */  THEN DO:

                /* CLIG7AAAAMMDD.TXT */             
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                       tt-arquivos.layout  = "8.6"
                       tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,12,2))
                       tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,10,2)).
            END.                                    
    
    
            IF  SUBSTRING(c-arquivo,1,2)  = "PG"    /* Pagamentos */    
            AND ENTRY(2,c-arquivo,".")    = "TXT"   /* Arq Texto  */    THEN DO:

                /* PGG7AAAAMMDD.TXT */              
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                       tt-arquivos.layout  = "8.7"
                       tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,11,2))
                       tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,9,2)).
            END.                                    
    
    
            IF  SUBSTRING(c-arquivo,1,2)  = "CO"    /* Compras   */     
            AND ENTRY(2,c-arquivo,".")    = "TXT"   /* Arq Texto */     THEN DO:

                /* COG7AAAAMMDD.TXT */              
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                       tt-arquivos.layout  = "8.8"
                       tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,11,2))
                       tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,9,2)).
            END.                                    
    
            IF  SUBSTRING(c-arquivo,1,5)  = "OCORR" /* Ocorrˆncias */   
            AND ENTRY(2,c-arquivo,".")    = "TXT"   /* Arq Texto   */   THEN DO:

                /* OCORRAAAAMMDD.TXT */
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.arquivo = c-dir-retorno + "/" + c-arquivo
                       tt-arquivos.layout  = "8.8"
                       tt-arquivos.dia     = INT(SUBSTRING(c-arquivo,12,2))
                       tt-arquivos.mes     = INT(SUBSTRING(c-arquivo,10,2)).
            END.
        END.
    END.
    
    RETURN "OK".
END.
