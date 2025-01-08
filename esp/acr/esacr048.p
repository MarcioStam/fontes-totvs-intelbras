/*****************************************************************************
** Programa.: esp/acr/esacr048.p
** VersÆo...: 1.00
** Data.....: 08/12/2011
** Autor....: Estevan Krger - Exponencial TI
** Obs......: API para tratar os arquivos utilizados pela SupplierCard
*****************************************************************************/

/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE c-cod-emp   AS CHARACTER   NO-UNDO.

/* C¢digo padrÆo da Intelbras, para a SupplierCard */
ASSIGN c-cod-emp = "G7".




/*--- Procedures Internas ---*/
PROCEDURE pi-retornar-arquivo-remessa:
    /*****************************************************************************
    ** Programa.: pi-retornar-arquivo-remessa
    ** Objetivo.: Retornar o arquivo, juntamente com o sequˆncial correto e o
    **            diret¢rio, dos arquivos da SupplierCard
    **            Layouts Suportados: 8.1, 8.2, 8.4, 8.10
    *****************************************************************************/
    /*--- Defini‡Æo dos Parƒmetros ---*/
    DEFINE INPUT  PARAMETER pLayout  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pArquivo AS CHARACTER   NO-UNDO.
    

    /*--- Defini‡Æo das Vari veis ---*/
    DEFINE VARIABLE c-dir-remessa AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-arq     AS INTEGER     NO-UNDO.


    /*--- Bloco Principal ---*/
    /* Gera a nomenclatura inicial do arquivo, antes do sequencial */
    CASE pLayout:
        WHEN "8.1" THEN DO:
            ASSIGN pArquivo = "CGCLI" + STRING(c-cod-emp, "x(02)") + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99").
        END.
        WHEN "8.2" OR
        WHEN "8.4" THEN DO:
            ASSIGN pArquivo = "UP"    + STRING(c-cod-emp, "x(02)") + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99").
        END.
        WHEN "8.10" THEN DO:
            ASSIGN pArquivo = "CGLIM" + STRING(c-cod-emp, "x(02)") + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99").
        END.
        OTHERWISE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Layout (" + pLayout + ") nÆo ‚ suportado pela API!").
    
            RETURN "NOK":U.
        END.
    END CASE.


    /* Busca o diret¢rio do arquivo */
    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    IF  AVAIL int-param-supcard THEN DO:
        ASSIGN c-dir-remessa = int-param-supcard.diretorio-remessa.
    
        IF  SUBSTRING(c-dir-remessa,LENGTH(c-dir-remessa),1) = "/" THEN
            ASSIGN OVERLAY(c-dir-remessa,LENGTH(c-dir-remessa),1) = "".
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Parƒmetros da SupplierCard nÆo estÆo cadastrados!").

        ASSIGN pArquivo = "".
        RETURN "NOK":U.
    END.


    /* Verifica na tabela de ocorrˆncias qual dever  ser o sequˆncial do arquivo */
    FIND LAST int-emitente-supcard-ocor NO-LOCK
        WHERE int-emitente-supcard-ocor.dat-avaliacao = TODAY
        AND   int-emitente-supcard-ocor.ind-ocor      = pLayout NO-ERROR.
    IF  AVAIL int-emitente-supcard-ocor THEN DO:
        ASSIGN c-arquivo = int-emitente-supcard-ocor.nom-arquivo.
    
        CASE pLayout:
            WHEN "8.1" THEN DO: /* CGCLIG7DDMM01.REM */
                IF  SUBSTRING(c-arquivo,1,5)  = "CGCLI"  /* Carga Cliente */ AND
                    SUBSTRING(c-arquivo,1,11) = pArquivo /* Mesmo Arquivo */ THEN DO:
                    ASSIGN i-seq-arq = INT(SUBSTRING(c-arquivo,12,2)) + 1.
                END.
            END.
            WHEN "8.2" THEN DO: /* UPG7DDMM001.REM */
                IF  SUBSTRING(c-arquivo,1,2) = "UP"     /* Uploads */       AND
                    ENTRY(2,c-arquivo,".")   = "REM"    /* Remessa */       AND
                    SUBSTRING(c-arquivo,1,8) = pArquivo /* Mesmo Arquivo */ THEN DO:
                    ASSIGN i-seq = INT(SUBSTRING(c-arquivo,9,3)).
        
                    /* Intervalo do arquivo de Upload de Compras (8.2) */
                    IF  i-seq >= 1 AND i-seq < 5 THEN
                        ASSIGN i-seq-arq = i-seq + 1.
                END.
            END.
            WHEN "8.4" THEN DO: /* UPG7DDMM005.REM */
                IF  SUBSTRING(c-arquivo,1,2) = "UP"     /* Uploads */       AND
                    ENTRY(2,c-arquivo,".")   = "REM"    /* Remessa */       AND
                    SUBSTRING(c-arquivo,1,8) = pArquivo /* Mesmo Arquivo */ THEN DO:
                    ASSIGN i-seq = INT(SUBSTRING(c-arquivo,9,3)).
        
                    /* Intervalo do arquivo de Upload Outras Transa‡äes (8.4) */
                    IF  i-seq >= 5 AND i-seq < 10 THEN
                        ASSIGN i-seq-arq = i-seq + 1.
                END.
            END.
            WHEN "8.10" THEN DO: /* CGLIMG7DDMM01.REM */
                IF  SUBSTRING(c-arquivo,1,5)  = "CGLIM"  /* Limite Cr‚dito */ AND
                    SUBSTRING(c-arquivo,1,11) = pArquivo /* Mesmo Arquivo  */ THEN DO:
                    ASSIGN i-seq-arq = INT(SUBSTRING(c-arquivo,12,2)) + 1.
                END.
            END.
        END CASE.

    END.
    
    /* Se nÆo encontrou arquivo para o layout */
    IF  i-seq-arq = 0 THEN DO:
        ASSIGN i-seq-arq = 1.
    
        /* Layout 8.4 o sequencial inicial no 5 */
        IF  pLayout = "8.4" THEN
            ASSIGN i-seq-arq = 5.
    END.
    
    
    /* Coloca o sequencial e a extensÆo no arquivo */
    CASE pLayout:
        WHEN "8.1"  OR
        WHEN "8.10" THEN
            ASSIGN pArquivo = pArquivo + STRING(i-seq-arq, "99") + ".REM".
        WHEN "8.2" OR
        WHEN "8.4" THEN
            ASSIGN pArquivo = pArquivo + STRING(i-seq-arq, "999") + ".REM".
    END CASE.
    
    
    /* Retorna o caminho completo do arquivo */
    ASSIGN pArquivo = c-dir-remessa + "/" + pArquivo.
    
    RETURN "OK":U.
END PROCEDURE.




PROCEDURE pi-retornar-arquivo-retorno:
    /*****************************************************************************
    ** Programa.: pi-retornar-arquivo-retorno
    ** Objetivo.: Retorna o arquivo gerado pela SupplierCard (retorno), que deve
    **            estar no diret¢rio parametrizado.
    **            Layouts Suportados: 8.3, 8.5, 8.6, 8.7, 8.8, 8.9
    *****************************************************************************/
    /*--- Defini‡Æo dos Parƒmetros ---*/
    DEFINE INPUT  PARAMETER pLayout  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pArquivo AS CHARACTER   NO-UNDO.
    

    /*--- Defini‡Æo das Vari veis ---*/
    DEFINE VARIABLE c-dir-retorno AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-aux         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-seq         AS INTEGER     NO-UNDO.


    /*--- Bloco Principal ---*/
    /* Gera a nomenclatura inicial do arquivo, antes do sequencial */
    CASE pLayout:
        WHEN "8.3" OR
        WHEN "8.5" THEN DO:
            ASSIGN pArquivo = "UP"    + STRING(c-cod-emp, "x(02)")  + STRING(DAY(TODAY), "99")    + STRING(MONTH(TODAY), "99").
        END.
        WHEN "8.6" THEN DO:
            ASSIGN pArquivo = "CLI"   + STRING(c-cod-emp, "x(02)")  + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99").
        END.
        WHEN "8.7" THEN DO:
            ASSIGN pArquivo = "PG"    + STRING(c-cod-emp, "x(02)")  + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99").
        END.
        WHEN "8.8" THEN DO:
            ASSIGN pArquivo = "CO"    + STRING(c-cod-emp, "x(02)")  + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99").
        END.
        WHEN "8.9" THEN DO:
            ASSIGN pArquivo = "OCORR" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99")  + STRING(DAY(TODAY), "99").
        END.
        OTHERWISE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Layout (" + pLayout + ") nÆo ‚ suportado pela API!").
    
            RETURN "NOK":U.
        END.
    END CASE.


    /* Busca o diret¢rio do arquivo */
    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    IF  AVAIL int-param-supcard THEN DO:
        ASSIGN c-dir-retorno = int-param-supcard.diretorio-retorno.

        IF  SUBSTRING(c-dir-retorno,LENGTH(c-dir-retorno),1) = "/" THEN
            ASSIGN OVERLAY(c-dir-retorno,LENGTH(c-dir-retorno),1) = "".
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Parƒmetros da SupplierCard nÆo estÆo cadastrados!").

        ASSIGN pArquivo = "".
        RETURN "NOK":U.
    END.

    
    /* Verifica no diret¢rio qual o arquivo */
    INPUT FROM OS-DIR(c-dir-retorno).
    blk_proc_arq:
    REPEAT:
        IMPORT UNFORMATTED c-aux.
        IF  SUBSTRING(c-aux,LENGTH(c-aux),1) = "F" /* Arquivo */ THEN DO:
            ASSIGN c-arquivo = TRIM(ENTRY(2,c-aux,"~"")).
    
            CASE pLayout:
                WHEN "8.3" THEN DO: /* UPG7DDMM001.RET */
                    IF  SUBSTRING(c-arquivo,1,2) = "UP"     /* Uploads */       AND
                        ENTRY(2,c-arquivo,".")   = "RET"    /* Retorno */       AND
                        SUBSTRING(c-arquivo,1,8) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN i-seq = INT(SUBSTRING(c-arquivo,9,3)).

                        ASSIGN pArquivo = c-arquivo.

                        /* Intervalo do arquivo de Upload de Compras (8.3) */
                        IF  i-seq >= 1 AND i-seq < 5 THEN DO:
                            ASSIGN pArquivo = c-arquivo.

                            LEAVE blk_proc_arq.
                        END.
                    END.
                END.
                WHEN "8.5" THEN DO: /* UPG7DDMM005.RET ou UPG7DDMM010.RET */
                    IF  SUBSTRING(c-arquivo,1,2) = "UP"     /* Uploads */       AND
                        ENTRY(2,c-arquivo,".")   = "RET"    /* Retorno */       AND
                        SUBSTRING(c-arquivo,1,8) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN i-seq = INT(SUBSTRING(c-arquivo,9,3)).

                        /* Arquivo de Upload Outras Transa‡äes (8.5) - 010 ‚ confirma‡Æo, importa primeiro */
                        IF  i-seq = 10 THEN DO:
                            ASSIGN pArquivo = c-arquivo.

                            LEAVE blk_proc_arq.
                        END.
            
                        /* Intervalo do arquivo de Upload Outras Transa‡äes (8.5) */
                        IF  i-seq >= 5 AND i-seq < 10 THEN DO:
                            ASSIGN pArquivo = c-arquivo.

                            LEAVE blk_proc_arq.
                        END.
                    END.
                END.
                WHEN "8.6" THEN DO: /* CLIG7AAAAMMDD.TXT */
                    IF  SUBSTRING(c-arquivo,1,3)  = "CLI"    /* Atu Cliente */   AND
                        ENTRY(2,c-arquivo,".")    = "TXT"    /* Arq Texto   */   AND
                        SUBSTRING(c-arquivo,1,13) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN pArquivo = c-arquivo.

                        LEAVE blk_proc_arq.
                    END.
                END.
                WHEN "8.7" THEN DO: /* PGG7AAAAMMDD.TXT */
                    IF  SUBSTRING(c-arquivo,1,2)  = "PG"     /* Pagamentos */    AND
                        ENTRY(2,c-arquivo,".")    = "TXT"    /* Arq Texto  */    AND
                        SUBSTRING(c-arquivo,1,12) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN pArquivo = c-arquivo.

                        LEAVE blk_proc_arq.
                    END.
                END.
                WHEN "8.8" THEN DO: /* COG7AAAAMMDD.TXT */
                    IF  SUBSTRING(c-arquivo,1,2)  = "CO"     /* Compras   */     AND
                        ENTRY(2,c-arquivo,".")    = "TXT"    /* Arq Texto */     AND
                        SUBSTRING(c-arquivo,1,12) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN pArquivo = c-arquivo.

                        LEAVE blk_proc_arq.
                    END.
                END.
                WHEN "8.9" THEN DO: /* OCORRAAAAMMDD.TXT */
                    IF  SUBSTRING(c-arquivo,1,5)  = "OCORR"  /* Ocorrˆncias */   AND
                        ENTRY(2,c-arquivo,".")    = "TXT"    /* Arq Texto   */   AND
                        SUBSTRING(c-arquivo,1,13) = pArquivo /* Mesmo Arquivo */ THEN DO:
                        ASSIGN pArquivo = c-arquivo.

                        LEAVE blk_proc_arq.
                    END.
                END.
            END CASE.

        END.
    END.
    INPUT CLOSE.


    IF  NUM-ENTRIES(pArquivo, ".") < 2 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo nÆo foi localizado!~~Favor verificar se o arquivo est  no diret¢rio correto: " + c-dir-retorno).

        ASSIGN pArquivo = "".
        RETURN "NOK":U.
    END.
    

    /* Retorna o caminho completo do arquivo */
    ASSIGN pArquivo = c-dir-retorno + "/" + pArquivo.
    
    RETURN "OK":U.
END PROCEDURE.




PROCEDURE pi-mover-arquivo:
    /*****************************************************************************
    ** Programa.: pi-mover-arquivo
    ** Objetivo.: Move o arquivo que foi processado para a pasta de Antigos
    *****************************************************************************/
    /*--- Defini‡Æo dos Parƒmetros ---*/
    DEFINE INPUT  PARAMETER pArquivo AS CHARACTER   NO-UNDO.
    

    /*--- Defini‡Æo das Vari veis ---*/
    DEFINE VARIABLE c-arquivo  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pasta    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dir-dest AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arq-orig AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arq-dest AS CHARACTER   NO-UNDO.


    /*--- Bloco Principal ---*/
    ASSIGN c-pasta = "Antigos".


    /* Valida o arquivo de origem */
    ASSIGN c-arq-orig = pArquivo.

    ASSIGN FILE-INFO:FILE-NAME  = c-arq-orig.
    IF  FILE-INFO:FULL-PATHNAME = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo de origem nÆo foi localizado!~~Arquivo: " + c-arq-orig).

        RETURN "NOK":U.
    END.


    ASSIGN c-arquivo  = ENTRY(NUM-ENTRIES(c-arq-orig,"/"), c-arq-orig, "/")
           c-dir-dest = c-arq-orig
           ENTRY(NUM-ENTRIES(c-dir-dest,"/"), c-dir-dest, "/") = c-pasta + "/".


    /* Valida o diret¢rio de destino */
    ASSIGN FILE-INFO:FILE-NAME  = c-dir-dest.
    IF  FILE-INFO:FULL-PATHNAME = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Diret¢rio de destino nÆo foi localizado!~~Diret¢rio: " + c-dir-dest).

        RETURN "NOK":U.
    END.


    /* Cria um diret¢rio para organizar os arquivos - DIA.MES.ANO */
    ASSIGN c-dir-dest = c-dir-dest + STRING(DAY(TODAY), "99") + "." + STRING(MONTH(TODAY), "99") + "." + STRING(YEAR(TODAY)) + "/".
    OS-CREATE-DIR VALUE(c-dir-dest).


    /* Copia o arquivo para a pasta de "Antigos/DD.MM.AAAA" */
    ASSIGN c-arq-dest = c-dir-dest + c-arquivo.
    OS-COPY VALUE(c-arq-orig) VALUE(c-arq-dest).


    /* Valida o diret¢rio de destino */
    ASSIGN FILE-INFO:FILE-NAME  = c-arq-dest.
    IF  FILE-INFO:FULL-PATHNAME = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Erro ao copiar o arquivo para a pasta de destino!~~Diret¢rio: " + c-dir-dest).

        RETURN "NOK":U.
    END.

    /* Elimina o arquivo antigo */
    OS-DELETE VALUE(c-arq-orig).

    RETURN "OK":U.
END PROCEDURE.
