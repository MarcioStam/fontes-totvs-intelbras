/***********************************************************************
**  Programa..: ESP/FTP/ESFTP004RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Atualiza volumes por nota fiscal
**  VersÆo....: 001 15/11/2004 - Chaves
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP004 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/ftp/esftp004tt.i} 
{include/i-rpvar.i}
DEFINE BUFFER b-volume-nf FOR volume-nf.
DEFINE BUFFER b-item      FOR item.

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
DEF VAR i-ult-volume    LIKE volume-nf.nr-volume NO-UNDO.
DEF VAR i-x             AS INT                   NO-UNDO.
DEF VAR i-y             AS INT                   NO-UNDO.
DEF VAR c-descricao     AS CHAR FORMAT 'x(36)'   NO-UNDO.
DEF VAR lSepara-mg      AS LOGICAL               NO-UNDO.
DEF VAR i-cont          AS INT.
DEF VAR c-est           AS CHAR.
DEF VAR c-cod-transp    AS CHAR                  NO-UNDO.
DEF VAR c-sigla-transp  AS CHAR                  NO-UNDO.
DEF VAR c-embalagem     AS CHAR                  NO-UNDO.
DEF VAR l-volta AS LOG.
DEFINE VARIABLE c-sigla-usada AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-volume-itens AS DECIMAL     FORMAT ">,>>9.999999999999" NO-UNDO.

DEF VAR Com-Cli-Dif AS LOG INITIAL NO.

DEF VAR Achou-Cli-Dif AS LOG INITIAL NO.

DEF VAR c-nf-bar AS CHARACTER FORMAT "x(21)" NO-UNDO.

DEF VAR varquivo AS CHARACTER NO-UNDO.
DEF VAR vcomando AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-volume AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-item   AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-transp-ecommerce AS LOGICAL NO-UNDO. 

DEFINE VARIABLE c-ped-cliente AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-desc-separa AS CHARACTER FORMAT 'X(25)'  NO-UNDO.
DEFINE VARIABLE c-deposito    AS CHARACTER NO-UNDO.
DEF BUFFER b1-volume-nf FOR volume-nf.

/*
DEF VAR contRP1 AS INT NO-UNDO.
DEF VAR contRP2 AS INT NO-UNDO.
DEF VAR contRP7 AS INT NO-UNDO.
DEF VAR contRP8 AS INT NO-UNDO.
*/

DEFINE TEMP-TABLE tt-item-rast NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX chItem AS PRIMARY
        it-codigo.

DEFINE TEMP-TABLE tt-seq-item
 FIELD it-codigo LIKE item.it-codigo
 FIELD nr-volume LIKE  volume-nf.nr-volume 
 FIELD sequencia LIKE seq-item.sequencia
 FIELD unico     AS LOG INITIAL NO
INDEX ch-index it-codigo.

DEFINE TEMP-TABLE tt-zona-separa NO-UNDO
    FIELD cod-zona LIKE zona-separa-box.cod-zona.

DEFINE TEMP-TABLE tt-item-imobilizado NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

/****************************  Frames       ****************************/
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.


CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR each tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

DEFINE TEMP-TABLE tt-estado
    FIELD estado            AS CHAR FORMAT "x(02)".

DEF var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Atualiza volumes por nota fiscal"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP004"
       c-versao       = "2.04"
       c-revisao      = "001".

IF tt-param.c-estado <> "" THEN DO:
   DO i-cont = 1 TO 30:
      ASSIGN c-est = ENTRY(i-cont,tt-param.c-estado) NO-ERROR.
      IF c-est <> "" THEN DO:
         CREATE tt-estado.
         ASSIGN tt-estado.estado = SUBSTRING(c-est,1,2)
                c-est            = "".
      END.
   END.
END.

/* INICIO CARREGA TEMP-TABLE FAIXA DE NOTAS A DESCONSIDERAR */
DEFINE VARIABLE c-nota-des AS CHARACTER   NO-UNDO .
DEFINE VARIABLE c-inicial-nota-des AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-final-nota-des AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-faixa-nota-des AS CHARACTER   NO-UNDO.
DEF TEMP-TABLE tt-nota-des
    FIELD c-cod-nota-des-ini AS CHARACTER
    FIELD c-cod-nota-des-fim AS CHARACTER.

ASSIGN c-nota-des = tt-param.notas-desconsiderar.
DO i-cont = 1 TO NUM-ENTRIES(c-nota-des):
    ASSIGN c-faixa-nota-des = ENTRY(i-cont,c-nota-des).
    ASSIGN c-inicial-nota-des   = "" 
           c-final-nota-des   = "".

    IF NUM-ENTRIES(c-faixa-nota-des, "-") > 1 THEN DO:
        ASSIGN c-inicial-nota-des = ENTRY(1,c-faixa-nota-des,"-")  /* Faixa de Sele»’o de nota-des */
               c-final-nota-des   = ENTRY(2,c-faixa-nota-des,"-").
        CREATE tt-nota-des.
        ASSIGN tt-nota-des.c-cod-nota-des-ini = c-inicial-nota-des
               tt-nota-des.c-cod-nota-des-fim = c-final-nota-des.
    END.
    ELSE DO:
        CREATE tt-nota-des.             
        ASSIGN tt-nota-des.c-cod-nota-des-ini = ENTRY(i-cont,c-nota-des)
               tt-nota-des.c-cod-nota-des-fim = ENTRY(i-cont,c-nota-des).
    END.
END.
/* FIM CARREGA TEMP-TABLE FAIXA DE NOTAS A DESCONSIDERAR */

ASSIGN c-nf-bar = "".

/* ***************************  Main Block  *************************** */
DO on stop undo, leave: 
   
   {esp/es0018.i} 
   {include/i-rpout.i}
   
   RUN utp/ut-acomp.p persistent set h-acomp.  

   RUN pi-inicializar in h-acomp (input "Imprimindo...").

   /* Coloquei estas linhas no programa - Clayton Antunes */
   DEF VAR i-nome-programa AS CHAR.
   DEF VAR i-ponto AS INT.
   DEF VAR i-sequencia AS INT.
   DEF VAR i-conteudo AS CHAR.  

   DEF TEMP-TABLE tt-prog-ponto-tmp
       FIELD nome-programa    LIKE ponto-programa.nome-programa
       FIELD ponto            LIKE ponto-programa.ponto
       FIELD sequencia        LIKE conteudo-programa.sequencia 
       FIELD conteudo         LIKE conteudo-programa.conteudo
       INDEX seq-campo nome-programa ponto sequencia.   
   DEF BUFFER b-ponto-programa FOR ponto-programa.

   FOR EACH b-ponto-programa WHERE 
            b-ponto-programa.nome-programa = "esftp004":
       RUN esp/es0018p.p (INPUT b-ponto-programa.nome-programa,
                          INPUT b-ponto-programa.ponto,
                          INPUT i-sequencia,
                          INPUT i-conteudo,
                          OUTPUT TABLE tt-prog-ponto) NO-ERROR.
       FOR EACH TT-PROG-PONTO:
           CREATE tt-prog-ponto-tmp.
           BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
       END.
   END.
   /* Fim */

   IF tt-param.Rastreabilidade <> 3 THEN DO:
       FOR EACH item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
           WHERE item-rast.data-ini  <= TODAY
           AND   item-rast.data-fim   > TODAY:
    
           CREATE tt-item-rast.         
           ASSIGN tt-item-rast.it-codigo = item-rast.it-codigo.
       END.
       /*
       FIND FIRST ponto-programa
           WHERE ponto-programa.nome-programa = "esftp082":U
             AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

       IF AVAILABLE ponto-programa THEN DO:
           FOR EACH conteudo-programa NO-LOCK USE-INDEX ind-prog-seq
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
               CREATE tt-item-rast.
               ASSIGN tt-item-rast.sequencia = conteudo-programa.sequencia
                      tt-item-rast.it-codigo = conteudo-programa.conteudo.
           END.
       END.
       */
   END.
    
   RUN piImprimeRelat.

   RUN pi-finalizar in h-acomp.

   /*IF tt-param.cod-estabel = "104" /* OR
      tt-param.cod-estabel = "101" */ THEN DO:
       OUTPUT CLOSE.

       ASSIGN vcomando = "print /d:\\serv-printer-02\" + ENTRY(1,tt-param.arquivo,":") + " " + varquivo.

       DOS SILENT VALUE(vcomando).
   END.
   ELSE DO:*/
       {include/i-rpclo.i}
   /*END.*/

   RETURN "OK".

END. 






/* **********************  Internal Procedures  *********************** */
PROCEDURE piImprimeRelat:
    
    IF CAN-FIND(FIRST tt-digita) THEN DO:
       FOR EACH  tt-digita,
           EACH  embarque NO-LOCK 
          WHERE embarque.cdd-embarq = tt-digita.nr-embarque,
           EACH nota-fiscal NO-LOCK USE-INDEX ch-embarque   
          WHERE nota-fiscal.cod-estabel   = tt-param.cod-estabel     AND 
                nota-fiscal.nr-nota-fis  >= tt-param.nrNotaFisIni    AND
                nota-fiscal.nr-nota-fis  <= tt-param.nrNotaFisFim    AND
                nota-fiscal.cdd-embarq   = embarque.cdd-embarq       AND
                nota-fiscal.nome-transp   = tt-param.nome-transp-ini AND
                nota-fiscal.dt-cancela    = ?,
                EACH volume-nf NO-LOCK                               WHERE
                     volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                     volume-nf.serie       = nota-fiscal.serie       AND
                     volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                     volume-nf.it-codigo >= tt-param.itCodigoIni     AND
                     volume-nf.it-codigo <= tt-param.itCodigoFim     AND
                     volume-nf.nr-volume >= tt-param.nrVolumeIni     AND
                     volume-nf.nr-volume <= tt-param.nrVolumeFim :

            FIND FIRST seq-item
                 WHERE seq-item.it-codigo = volume-nf.it-codigo NO-LOCK NO-ERROR.

            FIND FIRST tt-seq-item
                 WHERE tt-seq-item.it-codigo = volume-nf.it-codigo
                   AND tt-seq-item.nr-volume = volume-nf.nr-volume NO-ERROR.
            IF NOT AVAIL tt-seq-item THEN DO:
                CREATE tt-seq-item.
                ASSIGN tt-seq-item.it-codigo = volume-nf.it-codigo
                       tt-seq-item.nr-volume = volume-nf.nr-volume
                       tt-seq-item.sequencia = IF tt-param.tipo-volume = 2 and AVAIL seq-item AND volume-nf.varios-itens = NO THEN seq-item.sequencia ELSE 0.
            END.

            /* ECOMMERCE */
            IF nota-fiscal.serie = "90" THEN DO:
                IF CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                            WHERE it-nota-fisc.nr-seq-fat = 20) THEN DO:
                    ASSIGN tt-seq-item.unico = YES.
                END.
                ELSE DO:            
                    ASSIGN tt-seq-item.sequencia = int(volume-nf.it-codigo).
                END.
            END.
            
       END.

       /* ECOMMERCE */
       FOR EACH tt-seq-item
            WHERE tt-seq-item.unico:
            ASSIGN tt-seq-item.sequencia = 0.
       END.

    END.
    ELSE DO:
        
        FOR EACH embarque NO-LOCK
           WHERE embarque.cdd-embarq >= tt-param.nrEmbarqueIni
             AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim, 
                EACH nota-fiscal NO-LOCK USE-INDEX ch-embarque WHERE
                     nota-fiscal.cod-estabel   = tt-param.cod-estabel   AND 
                     nota-fiscal.nr-nota-fis  >= tt-param.nrNotaFisIni  AND
                     nota-fiscal.nr-nota-fis  <= tt-param.nrNotaFisFim  AND
                     nota-fiscal.cdd-embarq   = embarque.cdd-embarq     AND
                     nota-fiscal.nome-transp   = tt-param.nome-transp-ini AND
                     nota-fiscal.dt-cancela    = ?,
                EACH volume-nf NO-LOCK                               WHERE
                     volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                     volume-nf.serie       = nota-fiscal.serie       AND
                     volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                     volume-nf.it-codigo >= tt-param.itCodigoIni     AND
                     volume-nf.it-codigo <= tt-param.itCodigoFim     AND
                     volume-nf.nr-volume >= tt-param.nrVolumeIni     AND
                     volume-nf.nr-volume <= tt-param.nrVolumeFim :

            FIND FIRST seq-item
                 WHERE seq-item.it-codigo = volume-nf.it-codigo NO-LOCK NO-ERROR.

            FIND FIRST tt-seq-item
                 WHERE tt-seq-item.it-codigo = volume-nf.it-codigo 
                   AND tt-seq-item.nr-volume = volume-nf.nr-volume NO-ERROR.
            IF NOT AVAIL tt-seq-item THEN DO:
                CREATE tt-seq-item.
                ASSIGN tt-seq-item.it-codigo = volume-nf.it-codigo
                       tt-seq-item.nr-volume = volume-nf.nr-volume 
                       tt-seq-item.sequencia = IF tt-param.tipo-volume = 2 and AVAIL seq-item AND volume-nf.varios-itens = NO THEN seq-item.sequencia ELSE 0.
            END.

            /* ECOMMERCE */
            IF nota-fiscal.serie = "90" THEN DO:
                IF CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                            WHERE it-nota-fisc.nr-seq-fat = 20) THEN DO:
                    ASSIGN tt-seq-item.unico = YES.
                END.
                ELSE DO:            
                    ASSIGN tt-seq-item.sequencia = int(volume-nf.it-codigo).
                END.
            END.
        END.

        /* ECOMMERCE */
        FOR EACH tt-seq-item
             WHERE tt-seq-item.unico:
             ASSIGN tt-seq-item.sequencia = 0.
        END.

    END.
    
    RUN esp/es0018p.p (INPUT "wso0003":U, INPUT 17, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FOR EACH tt-prog-ponto
       WHERE tt-prog-ponto.conteudo = tt-param.nome-transp-ini:
        ASSIGN l-transp-ecommerce = YES.
    END.

    
    /* Notas com embarque */
    IF tt-param.iTipoNota = 1 THEN DO:  
        IF l-transp-ecommerce = NO THEN DO:
            RUN Sem-Diferenciado-Com-Embarque.
            IF Com-Cli-Dif THEN DO:
               PUT  "^XA"                                               SKIP
                    "^PW832^FS"                                         SKIP   /* Novo comando para zebra 600 */
                    "^FO180,100^BY3^A0N,120,Y,N^FD" "CLIENTE" "^FS"     SKIP
                    "^FO50,230^BY3^A0N,120,Y,N^FD" "DIFERENCIADO" "^FS" SKIP
                    "^PQ1^FS"                                           SKIP   
                    " ^XZ"                                              SKIP.
    
                RUN Com-Diferenciado-Com-Embarque. 
            END.
        END.
        ELSE DO:
            RUN Com-Embarque-Ecommerce.
            ASSIGN tt-param.l-imprime-barra = NO.
        END.
    END.
    /**********************/

    /* Notas sem embarque */
    ELSE DO:
        RUN Sem-Diferenciado-Sem-Embarque.
            
        IF Com-Cli-Dif THEN DO:
            PUT  "^XA"                                               SKIP
                 "^PW832^FS"                                         SKIP   /* Novo comando para zebra 600 */
                 "^FO180,100^BY3^A0N,120,Y,N^FD" "CLIENTE" "^FS"     SKIP
                 "^FO50,230^BY3^A0N,120,Y,N^FD" "DIFERENCIADO" "^FS" SKIP
                 "^PQ1^FS"                                           SKIP   
                 " ^XZ"                                              SKIP.
            
           RUN Com-Diferenciado-Sem-Embarque.
        END.
    END.    
    /**********************/
    
    IF tt-param.l-imprime-barra THEN
        PUT "^XA^FO28,200^GB750,0,40^FS^XZ" SKIP. /* Linha para finalisar impressÆo */
    
END PROCEDURE.




PROCEDURE Sem-Diferenciado-Com-Embarque:
    
    IF CAN-FIND(FIRST tt-digita) THEN DO:
                
            FOR EACH  tt-digita,
                EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.nr-embarque,

                
                {esp/ftp/esftp004rp1.i}                               
            END.
                    
            FOR EACH  tt-digita,
                EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.nr-embarque,

                
                {esp/ftp/esftp004rp2.i}
            END.
    END.
    ELSE DO:   
                     
            FOR EACH  embarque NO-LOCK
                WHERE  /* embarque.cdd-embarq = tt-param.nrEmbarqueIni, */
                
                      embarque.cdd-embarq     >= tt-param.nrEmbarqueIni
                      AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim, 

                {esp/ftp/esftp004rp1.i}
            END.
                                
            FOR EACH  embarque NO-LOCK
                WHERE /* embarque.cdd-embar+q = tt-param.nrEmbarqueIni, */
                       embarque.cdd-embarq     >= tt-param.nrEmbarqueIni
                       AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim,

                {esp/ftp/esftp004rp2.i}
            END.
    END.
END.



PROCEDURE Com-Diferenciado-Com-Embarque:
    IF CAN-FIND(FIRST tt-digita) THEN DO:
        
            FOR EACH  tt-digita,
                EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.nr-embarque,
                {esp/ftp/esftp004rp7.i}                               
            END.            
            FOR EACH  tt-digita,
                EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.nr-embarque,
                {esp/ftp/esftp004rp8.i}
            END.            
    END.
    ELSE DO:
        
            FOR EACH  embarque NO-LOCK
                WHERE /* embarque.cdd-embarq = tt-param.nrEmbarqueIni, */
                       embarque.cdd-embarq     >= tt-param.nrEmbarqueIni
                       AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim,
                {esp/ftp/esftp004rp7.i}
            END.     
            FOR EACH  embarque NO-LOCK
                WHERE /* embarque.cdd-embarq = tt-param.nrEmbarqueIni, */
                       embarque.cdd-embarq     >= tt-param.nrEmbarqueIni
                       AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim,
                {esp/ftp/esftp004rp8.i}
            END.            
    END.
END.



PROCEDURE Sem-Diferenciado-Sem-Embarque:
    
        FOR
        {esp/ftp/esftp004rp3.i}
        END.
        FOR
        {esp/ftp/esftp004rp4.i}
        END.
END.


PROCEDURE Com-Diferenciado-Sem-Embarque:
    
        FOR
        {esp/ftp/esftp004rp9.i}
        END.
        FOR
        {esp/ftp/esftp004rp10.i}
        END.
END.

PROCEDURE  Imprime_codigo_basico_central:



    for each estrutura NO-LOCK
         WHERE estrutura.it-codigo     = volume-nf.it-codigo
           AND estrutura.data-inicio  <= TODAY
           AND estrutura.data-termino >= TODAY
           AND (estrutura.es-codigo BEGINS "43" OR
                estrutura.es-codigo BEGINS "44" OR
                estrutura.es-codigo BEGINS "49"),
        FIRST ITEM
        WHERE ITEM.it-codigo = estrutura.es-codigo NO-LOCK:

        ASSIGN i-y = i-y + 28.

         find first item-caixa no-lock
             where item-caixa.sigla-emb  = volume-nf.sigla-emb
               and item-caixa.it-codigo  = volume-nf.it-codigo
               AND item-caixa.fm-cod-com = ?
               AND item-caixa.fm-codigo  = ? no-error.


         
         IF AVAIL item-caixa AND
            (item-caixa.qt-item = 0.5 OR
             item-caixa.qt-item = 0.6) THEN DO:

                put "^FO" + string(i-x,"99") + "," + string(i-y,"999") +
                   "^CF0^A0N,30,25^FD" + 
                    "(" + string(estrutura.es-codigo,"x(7)") + ")  - " + SUBSTRING(ITEM.desc-item,1,30) + " - " + string(estrutura.quant-usada) + 
                   "^FS" format "x(100)" skip.

         END.
    END.

END PROCEDURE.

PROCEDURE Imprime_codigo_barras:
    DEF VAR c-cod AS CHARACTER FORMAT "x(14)".
    DEF VAR i-soma AS INTEGER.
    DEF VAR ind AS INTEGER.

    IF substring(volume-nf.it-codigo,1,3) <> "499" THEN DO:

        FIND item-ean
             WHERE item-ean.it-codigo = volume-nf.it-codigo
            NO-LOCK NO-ERROR.

        IF AVAIL item-ean THEN do:
            
           find first item-caixa no-lock
                where item-caixa.sigla-emb = volume-nf.sigla-emb
                  and item-caixa.it-codigo = volume-nf.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? no-error.

           IF AVAIL item-caixa  AND
               item-caixa.qt-item <> 0.5 and
               item-caixa.qt-item <> 0.6 THEN DO: 
               ASSIGN c-cod = "".

               FOR FIRST item-dun NO-LOCK
                   WHERE item-dun.it-codigo = volume-nf.it-codigo
                   AND   item-dun.qtd-emb = int(item-caixa.qt-item):
               
                   ASSIGN c-cod = item-dun.cod-dun.
                   
               END.

                RUN pi-imprime-etiq-ucc-14  (INPUT c-cod,
                                             INPUT IF item-ean.descricao <> "" THEN item-ean.descricao ELSE item-ean.linha[1],
                                             INPUT "",
                                             INPUT item-caixa.qt-item).
            END.
        END.
    END.
END PROCEDURE.
PROCEDURE pi-imprime-etiq-ucc-14:
    DEF INPUT PARAM p-codi  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-desc  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-desc2  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-quan  AS CHAR NO-UNDO.
/*
    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */
         "^PW832"      SKIP   /* Novo comando para zebra 600 */
         "^LL296"      SKIP   /* 824 ? o numero de Dot‹s que formam nr colunas da etiqueta */
         "^MNY"        SKIP     /* Papel de etiquetas com quebra de etiquetas */
         "^FWN"        SKIP.   /* Orientacao dos Campos N = Normal */
  */


    IF tt-param.ImprimeEtiqueta = 2 THEN DO: /* sem endere‡o */

/*         IF p-codi <> "" THEN DO:               /* Por solicita‡Æo do Cristiano */                                                                                 */
/*             PUT UNFORMATTED                                                                                                     */
/*                 "^FO45,200^B2N,100,Y,N,N^BY2^FD" + p-codi  + "^FS" format "x(70)" skip           /* Codigo de Barras EAN 128 */ */
/*                 SKIP.                                                                                                           */
/*         END.                                                                                                                    */

        PUT UNFORMATTED
             "^FO35,350^A0N,56,24^FD"  + SUBSTRING(p-desc,1,60) + "^FS"  format "x(70)"   /* Imprime descricao Equipto */
             SKIP
                   /*
             "^FO35,270^A0N,70,30^FD" + SUBSTRING(p-desc2,1,60) + "^FS" format "x(70)"   /* Imprime descricao Equipto */
             SKIP    */
                                         /*
             "^F400,270^A0N,70,30^FD" today format "99/99/9999" "^FS" /* Imprime a data */
             SKIP                          */
                     
             "^FO480,350^A0N,70,30^FD " STRING(TODAY,"99/99/9999") + " (" +  p-quan " pcs )^FS" /* Imprime quantidade de etiquetas na caixa */        
    
             SKIP
    
             "^XZ".
    END.
    ELSE DO:

/*         IF p-codi <> "" THEN DO:              /* Por solicita‡Æo do Cristiano */                                                                                  */
/*             PUT UNFORMATTED                                                                                                     */
/*                 "^FO45,220^B2N,100,Y,N,N^BY2^FD" + p-codi  + "^FS" format "x(70)" skip           /* Codigo de Barras EAN 128 */ */
/*                 SKIP.                                                                                                           */
/*         END.                                                                                                                    */

        PUT UNFORMATTED
             "^FO35,350^A0N,50,20^FD"  + SUBSTRING(p-desc,1,60) + "^FS"  format "x(70)"   /* Imprime descricao Equipto */
             SKIP
                   /*
             "^FO35,270^A0N,70,30^FD" + SUBSTRING(p-desc2,1,60) + "^FS" format "x(70)"   /* Imprime descricao Equipto */
             SKIP    */
                                         /*
             "^F400,270^A0N,70,30^FD" today format "99/99/9999" "^FS" /* Imprime a data */
             SKIP                          */
    
             "^FO480,350^A0N,70,30^FD " STRING(TODAY,"99/99/9999") + " (" +  p-quan " pcs )^FS" /* Imprime quantidade de etiquetas na caixa */        
    
             SKIP
    
             "^XZ".

    END.

END.

PROCEDURE Com-Embarque-Ecommerce:

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        FOR EACH tt-digita,
            EACH embarque NO-LOCK
           WHERE embarque.cdd-embarq = tt-digita.nr-embarque,
            EACH nota-fiscal NO-LOCK  USE-INDEX ch-embarque         
           WHERE nota-fiscal.cod-estabel   = tt-param.cod-estabel     
             AND nota-fiscal.nr-nota-fis  >= tt-param.nrNotaFisIni    
             AND nota-fiscal.nr-nota-fis  <= tt-param.nrNotaFisFim    
             AND nota-fiscal.cdd-embarq    = embarque.cdd-embarq      
             AND nota-fiscal.nome-transp   = tt-param.nome-transp-ini 
             AND nota-fiscal.dt-cancela    = ?
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.serie
                  BY nota-fiscal.nr-nota-fis:

            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.cod-estabel = nota-fiscal.cod-estabel
                   AND int-ped-venda2.nr-pedido   = int(nota-fiscal.nr-pedcli) NO-ERROR.
            IF AVAIL int-ped-venda2 THEN DO:

                RUN pi-gera-etiqueta-ecommerce(INPUT nota-fiscal.cod-estabel, 
                                               INPUT nota-fiscal.serie, 
                                               INPUT nota-fiscal.nr-nota-fis,
                                               INPUT int-ped-venda2.PedidoeCommerce).

            END.
        END.
    END.
    ELSE DO:         
        FOR EACH embarque NO-LOCK
           WHERE embarque.cdd-embarq     >= tt-param.nrEmbarqueIni
             AND embarque.cdd-embarq <= tt-param.nrEmbarqueFim, 
            EACH nota-fiscal NO-LOCK  USE-INDEX ch-embarque         
           WHERE nota-fiscal.cod-estabel   = tt-param.cod-estabel     
             AND nota-fiscal.nr-nota-fis  >= tt-param.nrNotaFisIni    
             AND nota-fiscal.nr-nota-fis  <= tt-param.nrNotaFisFim    
             AND nota-fiscal.cdd-embarq    = embarque.cdd-embarq      
             AND nota-fiscal.nome-transp   = tt-param.nome-transp-ini 
             AND nota-fiscal.dt-cancela    = ?
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.serie
                  BY nota-fiscal.nr-nota-fis:

            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.cod-estabel = nota-fiscal.cod-estabel
                   AND int-ped-venda2.nr-pedido   = int(nota-fiscal.nr-pedcli) NO-ERROR.
            IF AVAIL int-ped-venda2 THEN DO:

                RUN pi-gera-etiqueta-ecommerce(INPUT nota-fiscal.cod-estabel, 
                                               INPUT nota-fiscal.serie, 
                                               INPUT nota-fiscal.nr-nota-fis,
                                               INPUT int-ped-venda2.PedidoeCommerce).
            END.
        END.
    END.

    RETURN "OK".

END.

PROCEDURE pi-gera-etiqueta-ecommerce:

    DEF INPUT PARAM c-estab LIKE nota-fiscal.cod-estabel.
    DEF INPUT PARAM c-serie LIKE nota-fiscal.serie.
    DEF INPUT PARAM c-nota  LIKE nota-fiscal.nr-nota-fis.
    DEF INPUT PARAM c-pedido AS CHAR.

    DEF VAR c-etiqueta         AS CHAR NO-UNDO.
    DEF VAR c-imprime-etiqueta AS CHAR NO-UNDO.
    DEF VAR i-ult-volume   LIKE volume-nf.nr-volume NO-UNDO.
    DEF VAR c-cod-transp    AS CHAR                  NO-UNDO.
    DEF VAR c-sigla-transp  AS CHAR                  NO-UNDO.
    DEF BUFFER b-volume-nf FOR volume-nf.
    DEF VAR c-dir-etiqueta AS CHAR NO-UNDO.
    DEF VAR c-arquivo      AS CHAR NO-UNDO.
    DEF VAR c-nf-bar AS CHARACTER FORMAT "x(21)" NO-UNDO.

    DEF VAR c-rota          AS CHAR NO-UNDO.
    DEF VAR i-volume-total  AS INT  INITIAL 1 NO-UNDO.
    DEF VAR c-volume-total  AS CHAR  NO-UNDO.
    DEF VAR c-volume        AS CHAR NO-UNDO.

    DEF VAR c-destinatario  AS CHAR NO-UNDO.
    DEFINE VARIABLE h-cdapi704 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE c-endereco AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-rua      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-nro      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-comp     AS CHARACTER  NO-UNDO.
    DEF VAR c-complemento1  AS CHAR NO-UNDO.
    DEF VAR c-complemento2  AS CHAR NO-UNDO.
    DEF VAR c-bairro        AS CHAR NO-UNDO.
    DEF VAR c-cidade        AS CHAR NO-UNDO.
    DEF VAR c-estado        AS CHAR NO-UNDO.
    DEF VAR c-cep           AS CHAR NO-UNDO.
    DEF VAR c-bairro-cidade AS CHAR NO-UNDO.
    DEF VAR c-codigo-barras AS CHAR NO-UNDO.
    DEF VAR i-nr-volume     AS INT NO-UNDO.
    DEF VAR i-cont-itens    AS INT NO-UNDO.
    DEF VAR c-deposito      AS CHAR NO-UNDO.
    DEF VAR linha           AS INT NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT int-ped-venda2.PedidoeCommerce).

    FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
    ASSIGN c-destinatario = TRIM(STRING(emitente.nome-emit,"x(34)")).
    FIND FIRST loc-entr 
         WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
           AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
    IF AVAIL loc-entr THEN DO:
        FIND FIRST int-loc-entr NO-LOCK
             WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
               AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.
        ASSIGN c-endereco      = IF AVAIL int-loc-entr AND int-loc-entr.endereco-completo <> "" THEN int-loc-entr.endereco-completo ELSE loc-entr.endereco
               c-bairro        = loc-entr.bairro
               c-cidade        = loc-entr.cidade
               c-estado        = loc-entr.estado
               c-cep           = string(loc-entr.cep,"99999999").
    END.
    ELSE DO:
        ASSIGN c-endereco      = emitente.endereco
               c-bairro        = emitente.bairro
               c-cidade        = emitente.cidade
               c-estado        = emitente.estado
               c-cep           = string(loc-entr.cep,"99999999").
    END.

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    DELETE PROCEDURE h-cdapi704.

    ASSIGN c-endereco = "End: " + c-rua + ", " + c-nro.

    IF c-comp <> "" THEN
        ASSIGN c-endereco = c-endereco + " - " + c-comp.

    ASSIGN c-bairro-cidade = c-bairro + " - " + c-cidade + "/" + c-estado.

    IF LENGTH(c-endereco) > 42 THEN DO:
        ASSIGN c-complemento1 = TRIM(SUBSTRING(c-endereco,43,120))
               c-endereco     = TRIM(SUBSTRING(c-endereco,1,42)).

        IF LENGTH(c-complemento1) > 42 THEN
            ASSIGN c-complemento2 = TRIM(SUBSTRING(c-complemento1,43,120))
                   c-complemento1 = TRIM(SUBSTRING(c-complemento1,1,42)).
    END.

    RUN esp/api/busca-transportadora.p (INPUT nota-fiscal.cod-estabel,
                                        INPUT STRING(nota-fiscal.cod-emitente),
                                        INPUT c-cidade,
                                        INPUT c-estado,
                                        INPUT "",
                                        INPUT c-cep,
                                        OUTPUT c-cod-transp,
                                        OUTPUT c-sigla-transp).

    ASSIGN c-etiqueta = ""
           c-imprime-etiqueta = "".

    ASSIGN i-volume-total = int(nota-fiscal.nr-volumes).

    DO i-nr-volume = 1 TO i-volume-total:

        ASSIGN c-rota          = c-sigla-transp
               c-volume-total  = STRING(i-volume-total)
               c-volume        = STRING(i-nr-volume) + " / " + STRING(i-volume-total)
               //c-pedido        = IF AVAIL int-pedido-vtex THEN int-pedido-vtex.seq-pedido ELSE nota-fiscal.nr-pedcli
               c-codigo-barras = STRING(DECIMAL(emitente.cgc),"99999999999999") + 
                                 STRING(DECIMAL(c-nota),"999999999") + 
                                 STRING(DECIMAL(c-serie),"999") +
                                 STRING(i-nr-volume,"9999") +
                                 STRING(i-volume-total,"9999").

        ASSIGN c-etiqueta = c-etiqueta +
             "^XA" + CHR(10) +
             "^MMT" + CHR(10) +
             "^PW812" + CHR(10) +
             "^LL1218" + CHR(10) +
             "^LS0" + CHR(10) +
             "^LRY" + CHR(10) +
             "^FO268,2^GFA,01792,01792,00028,:Z64:" + CHR(10) +
             "eJxjYMAL+P9jA39G5UblRuVG5Yac3CgYBSgAAG+gxnY=:0715" + CHR(10) +
             "^FO556,2^GFA,01536,01536,00024,:Z64:" + CHR(10) +
             "eJxjYMAF+P9jgB+j4qPio+Kj4jgLjVEwxAAAAiVCSg==:5123" + CHR(10) +
             "^FO12,2^GFA,01280,01280,00020,:Z64:" + CHR(10) +
             "eJxjYMAE9f8xwIFRsVGxUTHaiGHJgqOATgAAdVxL6g==:0EB1" + CHR(10) +
             "^FO12,98^GFA,01920,01920,00020,:Z64:" + CHR(10) +
             "eJxjYBgFQxHU/8cAB0bFRsVGxWgjNtD5fRQMTwAAt+dL6g==:1370" + CHR(10) +
             "^FO12,226^GFA,01792,01792,00028,:Z64:" + CHR(10) +
             "eJxjYBgF1AT1/3GBhlG5UblRuVG5ISU33AEAaexzxQ==:2E78" + CHR(10) +
             "^FO296,98^GFA,02304,02304,00024,:Z64:" + CHR(10) +
             "eJxjYBgFowAFsP/HAH9GxUfFR8VHxUkpR0bBKBj0AAC0pEGa:D933" + CHR(10) +
             "^FO12,256^GFA,02688,02688,00028,:Z64:" + CHR(10) +
             "eJztyaENADAIADA+h883icJD0tpGwF75JuWcc6cOaB+4/3PF:D24A" + CHR(10) +
             "^FO12,510^GFA,00768,00768,00012,:Z64:" + CHR(10) +
             "eJxjYCAM6v/DwYNR9iibiCQzZAAAWzzyrA==:F806" + CHR(10) +
             "^FO11,1^GB283,117,2^FS" + CHR(10) +
             "^FT586,35^A0N,28,28^FH\^FDVol:^FS" + CHR(10) +
             "^FO294,1^GB280,117,2^FS" + CHR(10) +
             "^FO574,1^GB236,117,2^FS" + CHR(10) +
             "^FO11,118^GB312,117,2^FS" + CHR(10) +
             "^FO323,118^GB487,117,2^FS" + CHR(10) +
             "^FO11,236^GB798,44,2^FS" + CHR(10) +
             "^FO11,280^GB798,279,2^FS" + CHR(10) +
             "^BY3,3,109^FT79,680^BCN,,Y,N" + CHR(10) +
             "^FD>;" + c-codigo-barras + "^FS" + CHR(10) +
             "^FT21,155^A0N,28,28^FH\^FDNFe:^FS" + CHR(10) +
             "^FT21,268^A0N,28,28^FH\^FDRemetente:^FS" + CHR(10) +
             "^FT331,155^A0N,28,28^FH\^FDPedido:^FS" + CHR(10) +
             "^FT21,315^A0N,28,28^FH\^FDDestinat\A0rio:^FS" + CHR(10) +
             "^FT21,547^A0N,28,28^FH\^FDCEP:^FS" + CHR(10) +
             "^FT21,89^A0N,34,33^FH\^FD" + c-rota + "^FS" + CHR(10) +
             "^FT325,89^A0N,34,33^FH\^FD" + c-volume-total + "^FS" + CHR(10) +
             "^FT601,89^A0N,34,33^FH\^FD" + c-volume + "^FS" + CHR(10) +
             "^FT53,206^A0N,34,33^FH\^FD" + c-nota + "^FS" + CHR(10) +
             "^FT337,206^A0N,34,33^FH\^FD" + c-pedido + "^FS" + CHR(10) +
             "^FT231,270^A0N,34,33^FH\^FDINTELBRAS S/A - IND DE TEL ELET BRAS^FS" + CHR(10) +
             "^FT801,470^A0B,102,100^FH\^FD" + SUBSTRING(c-cep,1,3) + "^FS" + CHR(10) +
             "^FT108,549^A0N,34,33^FH\^FD" + c-cep + "^FS" + CHR(10) +
             "^FT231,314^A0N,34,33^FH\^FD" + c-destinatario + "^FS" + CHR(10) +
             "^FT21,364^A0N,34,33^FH\^FD" + c-endereco + "^FS" + CHR(10) +
             "^FT21,410^A0N,34,33^FH\^FD" + c-complemento1 + "^FS" + CHR(10) +
             "^FT21,499^A0N,34,33^FH\^FD" + c-bairro-cidade + "^FS" + CHR(10) +
             "^FT21,455^A0N,34,33^FH\^FD" + c-complemento2 + "^FS" + CHR(10) +
             "^FT301,35^A0N,28,28^FH\^FDTotal de Vol:^FS" + CHR(10) +
             "^FT21,35^A0N,28,28^FH\^FDRota:^FS" + CHR(10) +
             "^FO6,711^GB803,4,4^FS" + CHR(10) +
             "^BY3,3,100" + CHR(10).

        ASSIGN i-cont-itens = 0
               linha = 830.

        FOR EACH volume-nf NO-LOCK                               
           WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel 
             AND volume-nf.serie       = nota-fiscal.serie       
             AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis 
             AND volume-nf.nr-volume  = i-nr-volume
             AND volume-nf.it-codigo >= tt-param.itCodigoIni     
             AND volume-nf.it-codigo <= tt-param.itCodigoFim     
             AND volume-nf.nr-volume >= tt-param.nrVolumeIni     
             AND volume-nf.nr-volume <= tt-param.nrVolumeFim,
           FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK 
           WHERE ITEM.it-codigo = volume-nf.it-codigo:

            {esp/ftp/esftp004rp11.i}

            IF tt-param.tipo-volume <> 3 THEN DO:
                IF nota-fiscal.nat-operacao BEGINS "7":U THEN DO:
                    FIND FIRST int-emitente
                        WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        
                    IF AVAILABLE int-emitente              AND
                       int-emitente.tipo-embalagem <> "":U THEN DO:
                        FIND FIRST embalag
                            WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.
        
                        IF AVAILABLE embalag THEN
                            FIND FIRST item-caixa
                                WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                                  AND item-caixa.fm-codigo  = ?
                                  AND item-caixa.fm-cod-com = ?
                                  AND item-caixa.sigla-emb BEGINS embalag.sigla-emb NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb   = volume-nf.sigla-emb NO-LOCK NO-ERROR.
        
                        FIND FIRST embalag
                            WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.
        
                        IF NOT AVAILABLE embalag THEN DO:
                            FOR EACH embalag
                                WHERE embalag.embalagem BEGINS "EMB":U
                                  AND embalag.emite-roman
                                BREAK BY embalag.volume:
                                FIND FIRST item-caixa
                                    WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                                      AND item-caixa.fm-codigo  = ?
                                      AND item-caixa.fm-cod-com = ?
                                      AND item-caixa.sigla-emb = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                            END.
                        END.
                    END.
        
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                     = 1 AND
                           volume-nf.qtde MODULO item-caixa.qt-item = 0 THEN NEXT.
        
                        IF tt-param.tipo-volume                      = 2 AND
                           volume-nf.qtde MODULO item-caixa.qt-item <> 0 THEN NEXT.
                    END.
                END.
                ELSE DO:
                    FIND FIRST item-caixa
                        WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                          AND item-caixa.fm-codigo  = ?
                          AND item-caixa.fm-cod-com = ?
                          AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
        
                    IF AVAILABLE item-caixa THEN DO:
                        IF tt-param.tipo-volume                     = 1 AND
                           volume-nf.qtde MODULO item-caixa.qt-item = 0 THEN NEXT.
        
                        IF tt-param.tipo-volume                      = 2 AND
                           volume-nf.qtde MODULO item-caixa.qt-item <> 0 THEN NEXT.
                    END.
                    IF tt-param.tipo-volume = 2 AND
                       NOT AVAIL item-caixa THEN NEXT.
                END.
            END.
        
            IF tt-param.notas-desconsiderar <> "" THEN DO:
                FIND tt-nota-des
                     WHERE int(tt-nota-des.c-cod-nota-des-ini) <= INT(nota-fiscal.nr-nota-fis)
                       AND int(tt-nota-des.c-cod-nota-des-fim) >= INT(nota-fiscal.nr-nota-fis)
                     NO-LOCK NO-ERROR.
                IF AVAIL tt-nota-des THEN NEXT.
             END.
            
            ASSIGN i-cont-itens = i-cont-itens + 1.

            IF i-cont-itens = 1 THEN DO:
                FIND LAST b-volume-nf NO-LOCK WHERE
                         b-volume-nf.cod-estabel = volume-nf.cod-estabel AND
                         b-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis AND
                         b-volume-nf.serie       = volume-nf.serie       NO-ERROR.
                ASSIGN i-ult-volume = b-volume-nf.nr-volume.
                {esp/ftp/esftp004rp13.i} /* desc-separa wms */

                ASSIGN c-nf-bar = volume-nf.cod-estabel + STRING(int(volume-nf.serie),"999") + STRING(volume-nf.nr-nota-fis,"9999999") + STRING(volume-nf.nr-volume,"9999" ) + STRING(i-ult-volume, "9999" )
                       c-etiqueta = c-etiqueta + 
                                    "^FO30,720^BY2^BCN,100,N,N,N,N^SN" + c-nf-bar + ",1,Y^FS" + CHR(10) +   
                                    "^FT580,770^A0N,28,28^FH\^FD" + c-desc-separa + "^FS" + CHR(10).
            END.

            ASSIGN linha = linha + 30.

            ASSIGN c-deposito = "".
            FOR EACH fat-ser-lote
               WHERE fat-ser-lote.cod-estabel = volume-nf.cod-estabel 
                 AND fat-ser-lote.nr-nota-fis = volume-nf.nr-nota-fis 
                 AND fat-ser-lote.serie       = volume-nf.serie       
                 AND fat-ser-lote.it-codigo   = volume-nf.it-codigo   NO-LOCK:

                IF lookup(fat-ser-lote.cod-depos, c-deposito) = 0 THEN
                    IF c-deposito = "" THEN
                        ASSIGN c-deposito = fat-ser-lote.cod-depos.
                ELSE
                    ASSIGN c-deposito = c-deposito + "," + fat-ser-lote.cod-depos.
            END.

            IF i-cont-itens = 13 THEN
                ASSIGN linha = 70
                       c-etiqueta = c-etiqueta + "^PQ1,0,1,Y^XZ" + CHR(10) + 
                       "^XA" + CHR(10) +
                       "^MMT" + CHR(10) +
                       "^PW812" + CHR(10) +
                       "^LL1218" + CHR(10) +
                       "^LS0" + CHR(10) +
                       "^LRY" + CHR(10) +
                       "^FT15,30^A0N,28,28^FH\^FDCONTINUACAO DOS ITENS^FS" + CHR(10).

            ASSIGN c-etiqueta = c-etiqueta + 
                                "^FT35," + STRING(linha) + "^A0N,28,28^FH\^FD" + volume-nf.it-codigo + "^FS" + CHR(10) +
                                //"^FT145," + STRING(linha) + "^A0N,28,28^FH\^FD" + STRING(ITEM.desc-item,"x(30)") + "^FS" + CHR(10) +
                                "^FT620," + STRING(linha) + "^A0N,28,28^FH\^FD" + STRING(volume-nf.qtde,">>>9") + "^FS" + CHR(10) +
                                "^FT690," + STRING(linha) + "^A0N,28,28^FH\^FD" + UPPER(c-deposito) + "^FS" + CHR(10).

            {esp/ftp/esftp004rp12.i}
            
        END.

        IF tt-param.reimpressao = YES THEN
            ASSIGN c-etiqueta = c-etiqueta + "^FT740,90^A0N,90,90^FH\^FDR^FS" + CHR(10).

        ASSIGN c-etiqueta = c-etiqueta + "^PQ1,0,1,Y^XZ" + CHR(10).

        IF i-cont-itens > 0 THEN
            ASSIGN c-imprime-etiqueta = c-imprime-etiqueta + c-etiqueta.

        ASSIGN c-etiqueta = "".

    END.

    IF c-imprime-etiqueta <> "" THEN DO:
        PUT UNFORMATTED
            c-imprime-etiqueta.

        /*OUTPUT TO VALUE("c:\temp\etiqueta-zebra-" + c-nota + ".zpl").
        PUT UNFORMATTED c-imprime-etiqueta.
        OUTPUT CLOSE.*/
    END.

END PROCEDURE.
