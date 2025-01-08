/***********************************************************************
**  Programa..: ESP/FTP/ESFTP037RP.P
**  Autor.....: Rubia Oliveira - SENSUS
**  Data......: Maio/2016
**  Descricao.: Atualiza volumes por nota fiscal
**  Vers∆o....: 001 15/11/2004 - Chaves
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP037 1.12.00.001}

/****************************  Definitions  ****************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U

    FIELD ItCodigoIni      LIKE ITEM.it-codigo
    FIELD ItCodigoFim      LIKE ITEM.it-codigo 
    FIELD NrEmbarqueIni    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD NrEmbarqueFim    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD NrNotaFisIni     LIKE nota-fiscal.nr-nota-fis
    FIELD NrNotaFisFim     LIKE nota-fiscal.nr-nota-fis
    FIELD NrVolumeIni      AS INT /*LIKE volume-nf.nr-volume*/
    FIELD NrVolumeFim      AS INT /*LIKE volume-nf.nr-volume*/ 
    FIELD DtPeriodoIni     LIKE integra-mft-wms.dt-integra
    FIELD DtPeriodoFim     LIKE integra-mft-wms.dt-integra

    FIELD iTipoNota        AS INT
    FIELD ImprimeEtiqueta  AS INT
    FIELD i-impressora     AS INT

    FIELD Rastreabilidade  AS INTEGER
    FIELD tipo-volume      AS INTEGER
    FIELD nome-transp-ini  LIKE embarque.nome-transp
    FIELD l-estado         AS LOG
    FIELD c-estado         AS CHAR
    field cod-estabel      as char
    FIELD reimpressao      AS LOGICAL.

define temp-table tt-digita no-undo
    FIELD selecionado   AS LOGICAL LABEL 'Sel'
    FIELD cdd-embarq    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD cod-estabel   LIKE integra-mft-wms-notas.cod-estabel
    FIELD serie         LIKE integra-mft-wms-notas.serie      
    FIELD nr-nota-fis   LIKE integra-mft-wms-notas.nr-nota-fis
    FIELD nr-volume     LIKE volume-nf.nr-volume
    FIELD it-codigo     LIKE integra-mft-wms-notas.it-codigo 
    index id 
    cdd-embarq 
    cod-estabel
    serie      
    nr-nota-fis.

define temp-table tt-digita2 no-undo
    FIELD cdd-embarq    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD cod-estabel   LIKE integra-mft-wms-notas.cod-estabel
    FIELD serie         LIKE integra-mft-wms-notas.serie      
    FIELD nr-nota-fis   LIKE integra-mft-wms-notas.nr-nota-fis
    FIELD nr-volume     LIKE volume-nf.nr-volume
    index id 
    cdd-embarq 
    cod-estabel
    serie      
    nr-nota-fis.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
    
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

DEFINE VARIABLE c-ped-cliente AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-transp-ecommerce AS LOGICAL NO-UNDO.

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
INDEX ch-index it-codigo.


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

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Atualiza volumes por nota fiscal"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP004"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */
DO on stop undo, leave: 
   
    
    {include/i-rpout.i}
   
   RUN utp/ut-acomp.p persistent set h-acomp.  

   RUN pi-inicializar in h-acomp (input "Imprimindo...").

   /* Coloquei estas linhas no programa - Clayton Antunes */
   DEF VAR i-nome-programa AS CHAR.
   DEF VAR i-ponto AS INT.
   DEF VAR i-sequencia AS INT.
   DEF VAR i-conteudo AS CHAR.
   {esp/es0018.i}

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
   END.
    
   RUN piImprimeRelat.

   RUN pi-finalizar in h-acomp.

   {include/i-rpclo.i}

   RETURN "OK".

END. 






/* **********************  Internal Procedures  *********************** */
PROCEDURE piImprimeRelat:
    
    FOR EACH  tt-digita
        WHERE tt-digita.selecionado = YES :

        FIND FIRST tt-digita2
            WHERE tt-digita2.cdd-embarq  = tt-digita.cdd-embarq  
              AND tt-digita2.cod-estabel = tt-digita.cod-estabel 
              AND tt-digita2.serie       = tt-digita.serie       
              AND tt-digita2.nr-nota-fis = tt-digita.nr-nota-fis 
              AND tt-digita2.nr-volume   = tt-digita.nr-volume   NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-digita2 THEN DO:
            CREATE tt-digita2 .                                  
            ASSIGN tt-digita2.cdd-embarq  = tt-digita.cdd-embarq 
                   tt-digita2.cod-estabel = tt-digita.cod-estabel
                   tt-digita2.serie       = tt-digita.serie      
                   tt-digita2.nr-nota-fis = tt-digita.nr-nota-fis
                   tt-digita2.nr-volume   = tt-digita.nr-volume  .
        END. /* IF NOT AVAIL tt-digita2 THEN DO: */
        DELETE tt-digita.

    END.

    IF CAN-FIND(FIRST tt-digita2) THEN DO:

       FOR EACH  tt-digita2 ,
                EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita2.cdd-embarq,
              EACH nota-fiscal NO-LOCK                               WHERE
                     nota-fiscal.cod-estabel = tt-digita2.cod-estabel AND 
                     nota-fiscal.serie       = tt-digita2.serie       AND
                     nota-fiscal.nr-nota-fis = tt-digita2.nr-nota-fis,
                EACH volume-nf NO-LOCK                        WHERE
                     volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                     volume-nf.serie       = nota-fiscal.serie       AND
                     volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                     volume-nf.nr-volume   = tt-digita2.nr-volume:

/*            MESSAGE 'Volume tt-digita2.cod-estabel ' tt-digita2.cod-estabel  SKIP */
/*                    'tt-digita2.serie       ' tt-digita2.serie        SKIP        */
/*                    'tt-digita2.nr-nota-fis ' tt-digita2.nr-nota-fis              */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                              */

            FIND FIRST seq-item
                WHERE seq-item.it-codigo = volume-nf.it-codigo NO-LOCK NO-ERROR.

            FIND FIRST tt-seq-item
                  WHERE tt-seq-item.it-codigo = volume-nf.it-codigo
                    AND tt-seq-item.nr-volume = volume-nf.nr-volume NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-seq-item THEN DO:
                CREATE tt-seq-item.
                ASSIGN tt-seq-item.it-codigo = volume-nf.it-codigo
                       tt-seq-item.nr-volume = volume-nf.nr-volume
                       tt-seq-item.sequencia = IF tt-param.tipo-volume = 2 and AVAIL seq-item AND volume-nf.varios-itens = NO THEN seq-item.sequencia ELSE 0.

            END.
       END.
    END.
    
    /* Notas com embarque */
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
    /**********************/
    
    /*** PUT "^XA^FO28,200^GB750,0,40^FS^XZ" SKIP. /* Linha para finalisar impress∆o */***/
    
END PROCEDURE.

PROCEDURE Sem-Diferenciado-Com-Embarque:
    
    IF CAN-FIND(FIRST tt-digita2) THEN DO:
                
        FOR EACH  tt-digita2 ,
            EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita2.cdd-embarq,
            EACH nota-fiscal NO-LOCK                               WHERE
                   nota-fiscal.cod-estabel = tt-digita2.cod-estabel AND 
                   nota-fiscal.serie       = tt-digita2.serie       AND
                   nota-fiscal.nr-nota-fis = tt-digita2.nr-nota-fis,
              FIRST natur-oper NO-LOCK WHERE
                   natur-oper.nat-operacao    = nota-fiscal.nat-operacao
                /*  AND natur-oper.baixa-estoq */ ,
              EACH volume-nf NO-LOCK                        WHERE
                   volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                   volume-nf.serie       = nota-fiscal.serie       AND
                   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                   volume-nf.nr-volume   = tt-digita2.nr-volume    AND
                   not volume-nf.varios-itens ,
              FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK WHERE
                    ITEM.it-codigo = volume-nf.it-codigo,
              FIRST tt-seq-item
                    WHERE tt-seq-item.it-codigo = item.it-codigo
                      AND tt-seq-item.nr-volume = volume-nf.nr-volume 
              BREAK BY
                    tt-seq-item.sequencia DESCENDING         BY
                    volume-nf.it-codigo                      BY
                    volume-nf.nr-volume                      BY
                    volume-nf.cod-estabel                    BY
                    volume-nf.nr-nota-fis                    BY
                    volume-nf.serie:

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
                                   AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                     END.
                     ELSE DO:
                         FIND FIRST item-caixa
                             WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                               AND item-caixa.fm-codigo  = ?
                               AND item-caixa.fm-cod-com = ?
                               AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.

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
                                       AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                             END.
                         END.
                     END.

                     IF AVAILABLE item-caixa THEN DO:
                         IF tt-param.tipo-volume                     = 1 AND
                            volume-nf.qtde MODULO item-caixa.qt-item = 0 THEN NEXT.

                         IF tt-param.tipo-volume                      = 2 AND
                            volume-nf.qtde MODULO item-caixa.qt-item <> 0 THEN NEXT.
                     END.
                     ELSE
                         IF tt-param.tipo-volume                      = 2 THEN NEXT.
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
                     IF NOT AVAIL item-caixa AND 
                        tt-param.tipo-volume = 2 THEN NEXT.
                 END.
             END.

             {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
             {esinc/es0007.i} /*Valida Centro de Custo Cliente Diferenciado*/

             IF Achou-Cli-Dif THEN DO: 
                 ASSIGN Achou-Cli-Dif = NO
                        Com-Cli-Dif   = YES.
                 NEXT.
             END.


             ASSIGN lSepara-mg = (nota-fiscal.estado = 'MG' AND
                                  CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                                      WHERE it-nota-fisc.class-fiscal = '85171100'
                                         OR it-nota-fisc.class-fiscal = '85171999')).
             
             {esp/ftp/esftp004rp5.i} 

        END.
                
        FOR EACH  tt-digita2 ,
            EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita2.cdd-embarq,
            EACH nota-fiscal NO-LOCK                               WHERE
                   nota-fiscal.cod-estabel = tt-digita2.cod-estabel AND 
                   nota-fiscal.serie       = tt-digita2.serie       AND
                   nota-fiscal.nr-nota-fis = tt-digita2.nr-nota-fis,
              FIRST natur-oper NO-LOCK WHERE
                   natur-oper.nat-operacao    = nota-fiscal.nat-operacao
                /*  AND natur-oper.baixa-estoq */ ,
              EACH volume-nf NO-LOCK                        WHERE
                   volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                   volume-nf.serie       = nota-fiscal.serie       AND
                   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                   volume-nf.nr-volume   = tt-digita2.nr-volume    AND
                   volume-nf.varios-itens,
              FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK WHERE
                    ITEM.it-codigo = volume-nf.it-codigo,
              FIRST tt-seq-item
                    WHERE tt-seq-item.it-codigo = item.it-codigo
                      AND tt-seq-item.nr-volume = volume-nf.nr-volume 
              BREAK BY
                    tt-seq-item.sequencia DESCENDING         BY
                    volume-nf.nr-volume                      BY
                    volume-nf.cod-estabel                    BY
                    volume-nf.nr-nota-fis                    BY
                    volume-nf.serie:

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
                                  AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb = volume-nf.sigla-emb NO-LOCK NO-ERROR.

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
                                      AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
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
                    IF NOT AVAIL item-caixa AND 
                       tt-param.tipo-volume = 2 THEN NEXT.
                END.
            END.

            {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
            {esinc/es0007.i} /*Valida Centro de Custo Cliente Diferenciado*/

            IF Achou-Cli-Dif THEN DO: 
                ASSIGN Achou-Cli-Dif = NO
                       Com-Cli-Dif   = YES.
                NEXT.
            END.

            ASSIGN lSepara-mg = (nota-fiscal.estado = 'MG' AND
                CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                WHERE it-nota-fisc.class-fiscal = '85171100'
                OR it-nota-fisc.class-fiscal = '85171999')).

            {esp/ftp/esftp004rp6.i}

        END.
        
    END.

END.

PROCEDURE Com-Diferenciado-Com-Embarque:
    IF CAN-FIND(FIRST tt-digita2) THEN DO:
        
        FOR EACH  tt-digita2 ,
            EACH  embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita2.cdd-embarq,
                EACH nota-fiscal NO-LOCK                               WHERE
                   nota-fiscal.cod-estabel = tt-digita2.cod-estabel AND 
                   nota-fiscal.serie       = tt-digita2.serie       AND
                   nota-fiscal.nr-nota-fis = tt-digita2.nr-nota-fis,
              FIRST natur-oper NO-LOCK WHERE
                   natur-oper.nat-operacao    = nota-fiscal.nat-operacao
                /*  AND natur-oper.baixa-estoq */ ,
              EACH volume-nf NO-LOCK                        WHERE
                   volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                   volume-nf.serie       = nota-fiscal.serie       AND
                   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                   volume-nf.nr-volume   = tt-digita2.nr-volume    AND
                   NOT volume-nf.varios-itens,
            FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK WHERE
                  ITEM.it-codigo = volume-nf.it-codigo,
            FIRST tt-seq-item
                  WHERE tt-seq-item.it-codigo = item.it-codigo
                    AND tt-seq-item.nr-volume = volume-nf.nr-volume 
            BREAK BY
                  tt-seq-item.sequencia DESCENDING         BY
                  volume-nf.nr-nota-fis                    BY
                  volume-nf.it-codigo                      BY
                  volume-nf.nr-volume                      BY
                  volume-nf.cod-estabel                    BY
                  volume-nf.serie:

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
                                  AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.

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
                                      AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
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

            {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
            {esinc/es0007.i} /*Valida Centro de Custo Cliente Diferenciado*/
            
            IF NOT Achou-Cli-Dif THEN DO: 
                NEXT.
            END.
            
            ASSIGN Achou-Cli-Dif = NO.
            
            ASSIGN lSepara-mg = (nota-fiscal.estado = 'MG' AND
                                 CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                                     WHERE it-nota-fisc.class-fiscal = '85171100'
                                        OR it-nota-fisc.class-fiscal = '85171999')).
        
            {esp/ftp/esftp004rp5.i} 
        END.            
        FOR EACH  tt-digita2,
            EACH  embarque NO-LOCK
            WHERE embarque.cdd-embarq = tt-digita2.cdd-embarq,
            EACH nota-fiscal NO-LOCK                               WHERE
               nota-fiscal.cod-estabel = tt-digita2.cod-estabel AND 
               nota-fiscal.serie       = tt-digita2.serie       AND
               nota-fiscal.nr-nota-fis = tt-digita2.nr-nota-fis,
            FIRST natur-oper NO-LOCK WHERE
                  natur-oper.nat-operacao    = nota-fiscal.nat-operacao
                /*  AND natur-oper.baixa-estoq */ ,
            EACH volume-nf NO-LOCK                        WHERE
                 volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
                 volume-nf.serie       = nota-fiscal.serie       AND
                 volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
                 volume-nf.nr-volume   = tt-digita2.nr-volume    AND
                 volume-nf.varios-itens,
            FIRST item FIELDS(it-codigo desc-item) NO-LOCK WHERE
                  item.it-codigo = volume-nf.it-codigo,
            FIRST tt-seq-item
                  WHERE tt-seq-item.it-codigo = item.it-codigo
                    AND tt-seq-item.nr-volume = volume-nf.nr-volume 
            BREAK BY
                  tt-seq-item.sequencia DESCENDING         BY
                  volume-nf.nr-nota-fis                    by
                  volume-nf.nr-volume                      BY 
                  volume-nf.cod-estabel                    by
                  volume-nf.serie:

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
                                  AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.

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
                                      AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
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
                END.
            END.

            {esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/
            {esinc/es0007.i} /*Valida Centro de Custo Cliente Diferenciado*/
            
            IF NOT Achou-Cli-Dif THEN DO: 
               NEXT.
            END.
            
            ASSIGN Achou-Cli-Dif = NO.
            
            ASSIGN lSepara-mg = (nota-fiscal.estado = 'MG' AND
                                 CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                                          WHERE it-nota-fisc.class-fiscal = '85171100'
                                             OR it-nota-fisc.class-fiscal = '85171999')).

            {esp/ftp/esftp004rp6.i}
            
        END.            
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

    IF tt-param.ImprimeEtiqueta = 2 THEN DO: /* sem endereáo */

        PUT UNFORMATTED
             "^FO35,350^A0N,56,24^FD"  + SUBSTRING(p-desc,1,60) + "^FS"  format "x(70)"   /* Imprime descricao Equipto */
             SKIP
             "^FO480,350^A0N,70,30^FD " STRING(TODAY,"99/99/9999") + " (" +  p-quan " pcs )^FS" /* Imprime quantidade de etiquetas na caixa */        
             SKIP
             "^XZ".
    END.
    ELSE DO:

        PUT UNFORMATTED
             "^FO35,350^A0N,50,20^FD"  + SUBSTRING(p-desc,1,60) + "^FS"  format "x(70)"   /* Imprime descricao Equipto */
             SKIP
             "^FO480,350^A0N,70,30^FD " STRING(TODAY,"99/99/9999") + " (" +  p-quan " pcs )^FS" /* Imprime quantidade de etiquetas na caixa */        
             SKIP
             "^XZ".

    END.

END.



