/***********************************************************************
**  Programa..: ESP\CCP\ESCCP002RP.P
**  Autor.....: Martin E. Mebs
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: Relatorio de relacionamento Produto X Nota Fiscal
**  VersÆo....: 001 19/01/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP020 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/ftp/esftp020tt.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
DEFINE VARIABLE vlogImportado   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE vlogBeneficiado AS LOGICAL    NO-UNDO.
/****************************  Frames       ****************************/
/*     WITH FRAME fDetalhe NO-ATTR-SPACE STREAM-IO WIDTH 132 DOWN.-*/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEF VAR c-nr-nota-ini  AS CHAR NO-UNDO.
DEF VAR c-nr-nota-fim  AS CHAR NO-UNDO.
DEF VAR c-serie-ini    AS CHAR NO-UNDO.
DEF VAR c-serie-fim    AS CHAR NO-UNDO.
DEF VAR i-linguagem    AS INT NO-UNDO.

DEF VAR c-sigla         AS CHAR NO-UNDO.
DEF VAR c-data          AS CHAR NO-UNDO.
DEF VAR i-numero        AS INT  NO-UNDO.
DEF VAR i-cont          AS INT  NO-UNDO.
DEF VAR c-etiqueta      AS CHAR EXTENT 8 NO-UNDO.
DEF VAR c-etiq-eco      AS CHAR EXTENT 8 NO-UNDO.
DEF VAR c-descricao     AS CHAR NO-UNDO.
DEF VAR l-prim          AS LOG  NO-UNDO.
DEF VAR i-contaLinha    AS INT  NO-UNDO.
DEF VAR c-etiq-elimina  AS CHAR NO-UNDO.
DEF VAR c-dun           AS CHAR NO-UNDO.
DEF VAR c-ean           AS CHAR NO-UNDO.
DEF VAR da-data         AS DATE NO-UNDO.

DEF TEMP-TABLE tt-relat NO-UNDO
    FIELD it-codigo           AS CHAR
    FIELD etiqueta            AS CHAR
    FIELD nr-nota-fis         AS CHAR
    FIELD serie               AS CHAR 
    FIELD parcial             AS LOG
    FIELD possui-serie-sec    AS LOG
    FIELD series-sec          AS CHAR 
    FIELD etiqueta-excel      AS CHAR
    FIELD dun-excel           AS CHAR FORMAT "X(14)"
    FIELD ean-excel           AS CHAR FORMAT "X(14)"
    FIELD data-excel          AS DATETIME 
    FIELD usuario-excel       AS CHAR FORMAT "x(20)"
    FIELD qtd-excel           AS INT
    FIELD descricao-traduzida AS CHAR FORMAT "x(40)"
    FIELD etiq-eco            AS CHAR
        INDEX uni nr-nota-fis serie it-codigo.

DEF TEMP-TABLE tt-it-relat NO-UNDO
    FIELD it-codigo  AS CHAR
    FIELD qtd        AS INT
    INDEX cd it-codigo.

DEF BUFFER bftt-relat FOR tt-relat.

FORM tt-relat.nr-nota-fis LABEL "Nota Fiscal:" 
     "-"
     tt-relat.serie       NO-LABEL
     WITH STREAM-IO FRAME f-nota.

FORM SPACE(5)
     c-etiqueta[1]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[2]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[3]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[4]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[5]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[6]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[7]       FORMAT "x(45)" COLUMN-LABEL "  "
     c-etiqueta[8]       FORMAT "x(45)" COLUMN-LABEL "  "
     WITH STREAM-IO NO-LABEL FRAME f-relat WIDTH 150 55 DOWN.

DEF STREAM s.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: 
END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Nota Fiscal X Pallet/Caixa/Produto"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP020"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   /*run utp/ut-perc.p persistent set h-acomp.  */

   run piImprimeRelat.
   run pi-finalizar in h-acomp.

   {include/i-rpclo.i}
   RETURN "OK".
end.


/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEF VAR i-nr-registros AS INT NO-UNDO.

    FIND FIRST tt-param NO-LOCK NO-ERROR.

    ASSIGN c-nr-nota-ini = tt-param.nr-nota-fis-ini
           c-serie-ini   = tt-param.serie-ini
           i-linguagem   = tt-param.i-idioma
           i-nr-registros = 0.       

    /*Por Nota*/
    IF tt-param.rs-opcao = 1 THEN DO:
    
        FOR EACH num-serie-rast NO-LOCK
           WHERE num-serie-rast.cod-estabel = tt-param.cod-estabel
             AND num-serie-rast.nr-nota-fis = c-nr-nota-ini
             AND num-serie-rast.serie       = c-serie-ini:
    
            FOR FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = num-serie-rast.n-serie:
    
                /* EAN 13 */
                FIND FIRST item-mat 
                     WHERE item-mat.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                IF  AVAIL item-mat THEN
                    ASSIGN c-ean = item-mat.cod-ean .
                
                /* dun 14 */
                FIND FIRST item-dun 
                     WHERE item-dun.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL item-dun THEN
                   ASSIGN c-dun = item-dun.cod-dun.

                CREATE tt-relat.            
                ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                       tt-relat.etiqueta      = num-serie.n-serie
                       tt-relat.nr-nota-fis   = num-serie-rast.nr-nota-fis
                       tt-relat.serie         = num-serie-rast.serie
                       tt-relat.parcial       = NO
                       tt-relat.dun-excel     = c-dun
                       tt-relat.ean-excel     = c-ean 
                       tt-relat.data-excel    = num-serie-rast.data
                       tt-relat.usuario-excel = num-serie-rast.usuario.
    
                IF  CAN-FIND(FIRST num-serie-fornec
                             WHERE num-serie-fornec.n-serie = num-serie.n-serie) THEN DO:
                    ASSIGN tt-relat.possui-serie-sec = TRUE.
                
                    FOR EACH num-serie-fornec NO-LOCK
                       WHERE num-serie-fornec.n-serie = num-serie.n-serie:
        
                        IF tt-relat.series-sec = "" THEN 
                           ASSIGN tt-relat.series-sec = num-serie-fornec.n-serie-sec.
                        ELSE 
                           ASSIGN tt-relat.series-sec = tt-relat.series-sec + " " + num-serie-fornec.n-serie-sec.
                    END. /* FOR EACH num-serie-fornec */
                END.
                ELSE ASSIGN tt-relat.possui-serie-sec = FALSE.
    
                FIND FIRST tt-it-relat WHERE tt-it-relat.it-codigo = num-serie.it-codigo NO-ERROR.
    
                IF NOT AVAIL tt-it-relat THEN DO:
                   CREATE tt-it-relat.
                   ASSIGN tt-it-relat.it-codigo = num-serie.it-codigo.
                END.


                FIND FIRST item-ean no-lock
                     WHERE item-ean.it-codigo = num-serie.it-codigo NO-ERROR.
                IF AVAIL item-ean THEN DO:
                                        
                    IF item-ean.log-banda-ku THEN DO:
                        FIND FIRST ns-volume NO-LOCK 
                             WHERE ns-volume.volume-filho = num-serie.n-serie NO-ERROR.
                        IF AVAIL ns-volume THEN DO:
                            IF ns-volume.volume-pai BEGINS "ECO" THEN
                                ASSIGN tt-relat.etiq-eco = ns-volume.volume-pai.
                        END.
                    END.
                END.
                
                ASSIGN tt-it-relat.qtd = tt-it-relat.qtd + 1
                       i-nr-registros = i-nr-registros   + 1.
                
            END. /* FOR FIRST num-serie NO-LOCK */
        END. /* FOR EACH num-serie-rast NO-LOCK */

        IF tt-param.busca-solar 
        THEN DO:
            FOR EACH nota-fiscal WHERE
                     nota-fiscal.cod-estabel = tt-param.cod-estabel AND
                     nota-fiscal.nr-nota-fis = c-nr-nota-ini        AND
                     nota-fiscal.serie       = c-serie-ini
                     NO-LOCK,
                EACH it-nota-fisc OF nota-fiscal
                     NO-LOCK.
           
                FOR EACH int-col-num-serie WHERE
                         int-col-num-serie.nr-pedido    = it-nota-fisc.nr-pedido AND
                         int-col-num-serie.tp-cod-barra = 1                       //Serial             
                         //int-col-num-serie.it-codigo    = it-nota-fisc.it-codigo
                         NO-LOCK.
           
                    FOR FIRST num-serie NO-LOCK
                        WHERE num-serie.n-serie = int-col-num-serie.cod-barra:

                       CREATE tt-relat.            
                       ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                              tt-relat.etiqueta      = num-serie.n-serie
                              tt-relat.nr-nota-fis   = nota-fiscal.nr-nota-fis
                              tt-relat.serie         = nota-fiscal.serie
                              tt-relat.parcial       = NO
                              tt-relat.dun-excel     = ""
                              tt-relat.ean-excel     = ""
                              tt-relat.data-excel    = int-col-num-serie.data
                              tt-relat.usuario-excel = "".

                        FIND FIRST tt-it-relat WHERE tt-it-relat.it-codigo = num-serie.it-codigo NO-ERROR.
                        
                        IF NOT AVAIL tt-it-relat THEN DO:
                           CREATE tt-it-relat.
                           ASSIGN tt-it-relat.it-codigo = num-serie.it-codigo.
                        END.
                    END.
                END.                
            END.
        END.
    END.
    ELSE IF tt-param.rs-opcao = 2 THEN DO: /*Por Cliente e per¡do*/

        FOR EACH num-serie-rast NO-LOCK
            WHERE num-serie-rast.data >= DATETIME (month(tt-param.da-data-ini), day(tt-param.da-data-ini), year(tt-param.da-data-ini), 00, 00)
              AND num-serie-rast.data <= DATETIME (month(tt-param.da-data-fim), day(tt-param.da-data-fim), year(tt-param.da-data-fim), 23, 59):

            FOR FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = num-serie-rast.n-serie:

                FIND FIRST nota-fiscal 
                     WHERE nota-fiscal.cod-estabel  = num-serie-rast.cod-estabel
                       AND nota-fiscal.serie        = num-serie-rast.serie
                       AND nota-fiscal.nr-nota-fis  = num-serie-rast.nr-nota-fis
                       AND nota-fiscal.cod-emitente = tt-param.fi-cod-emitente NO-LOCK NO-ERROR.
                IF  NOT AVAIL nota-fiscal THEN NEXT.
    
                /*
                MESSAGE "achou nota" SKIP
                       " nota-fiscal.cod-estabel  : "  nota-fiscal.cod-estabel skip
                       " nota-fiscal.serie        : "  nota-fiscal.serie       skip                    
                       " nota-fiscal.nr-nota-fis  : "  nota-fiscal.nr-nota-fis skip                        
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                */    
                /* EAN 13 */
                FIND FIRST item-mat 
                     WHERE item-mat.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                IF  AVAIL item-mat THEN
                    ASSIGN c-ean = item-mat.cod-ean .
                
                /* dun 14 */
                FIND FIRST item-dun 
                     WHERE item-dun.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL item-dun THEN
                   ASSIGN c-dun = item-dun.cod-dun.

                CREATE tt-relat.            
                ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                       tt-relat.etiqueta      = num-serie.n-serie
                       tt-relat.nr-nota-fis   = num-serie-rast.nr-nota-fis
                       tt-relat.serie         = num-serie-rast.serie
                       tt-relat.parcial       = NO
                       tt-relat.dun-excel     = c-dun
                       tt-relat.ean-excel     = c-ean 
                       tt-relat.data-excel    = num-serie-rast.data
                       tt-relat.usuario-excel = num-serie-rast.usuario.
        
                IF  CAN-FIND(FIRST num-serie-fornec
                             WHERE num-serie-fornec.n-serie = num-serie.n-serie) THEN DO:
                    ASSIGN tt-relat.possui-serie-sec = TRUE.
                
                    FOR EACH num-serie-fornec NO-LOCK
                       WHERE num-serie-fornec.n-serie = num-serie.n-serie:
        
                        IF  tt-relat.series-sec = "" 
                        THEN ASSIGN tt-relat.series-sec = num-serie-fornec.n-serie-sec.
                        ELSE ASSIGN tt-relat.series-sec = tt-relat.series-sec + " " + num-serie-fornec.n-serie-sec.
                    END. /* FOR EACH num-serie-fornec */
                END.
                ELSE ASSIGN tt-relat.possui-serie-sec = FALSE.
        
                FIND FIRST tt-it-relat WHERE tt-it-relat.it-codigo = num-serie.it-codigo NO-ERROR.
        
                IF NOT AVAIL tt-it-relat THEN DO:
                   CREATE tt-it-relat.
                   ASSIGN tt-it-relat.it-codigo = num-serie.it-codigo.
                END.
        
                ASSIGN tt-it-relat.qtd = tt-it-relat.qtd + 1
                       i-nr-registros = i-nr-registros   + 1.
        
            END. /* FOR FIRST num-serie NO-LOCK */
        END. /* FOR EACH num-serie-rast NO-LOCK */

        IF tt-param.busca-solar 
        THEN DO:
            FOR EACH int-col-num-serie WHERE
                     int-col-num-serie.data >= tt-param.da-data-ini AND
                     int-col-num-serie.data <= tt-param.da-data-fim AND
                     int-col-num-serie.tp-cod-barra = 1 //Serial
                     NO-LOCK.

                FOR EACH it-nota-fisc WHERE
                         it-nota-fisc.nr-pedido = int-col-num-serie.nr-pedido
                         NO-LOCK,
                    EACH nota-fiscal OF it-nota-fisc
                         NO-LOCK.

                    IF nota-fiscal.cod-emitente <> tt-param.fi-cod-emitente THEN NEXT.

                    FOR FIRST num-serie NO-LOCK
                        WHERE num-serie.n-serie = int-col-num-serie.cod-barra:
           
                       CREATE tt-relat.            
                       ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                              tt-relat.etiqueta      = num-serie.n-serie
                              tt-relat.nr-nota-fis   = nota-fiscal.nr-nota-fis
                              tt-relat.serie         = nota-fiscal.serie
                              tt-relat.parcial       = NO
                              tt-relat.dun-excel     = ""
                              tt-relat.ean-excel     = ""
                              tt-relat.data-excel    = int-col-num-serie.data
                              tt-relat.usuario-excel = "".

                        FIND FIRST tt-it-relat WHERE tt-it-relat.it-codigo = num-serie.it-codigo NO-ERROR.
                        
                        IF NOT AVAIL tt-it-relat THEN DO:
                           CREATE tt-it-relat.
                           ASSIGN tt-it-relat.it-codigo = num-serie.it-codigo.
                        END.
                    END.
                END.
            END.
        END.
    END.
    ELSE DO: /*por periodo*/

        FOR EACH num-serie-rast USE-INDEX data NO-LOCK
           WHERE num-serie-rast.data       >= DATETIME (month(tt-param.da-periodo-ini), day(tt-param.da-periodo-ini), year(tt-param.da-periodo-ini), 00, 00)
             AND num-serie-rast.data       <= DATETIME (month(tt-param.da-periodo-fim), day(tt-param.da-periodo-fim), year(tt-param.da-periodo-fim), 23, 59)
             AND num-serie-rast.serie       = tt-param.serie-per
             AND num-serie-rast.cod-estabel = tt-param.cod-estab-per
             AND num-serie-rast.it-codigo  >=  tt-param.it-codigo-ini 
             AND num-serie-rast.it-codigo  <=  tt-param.it-codigo-fim:

             /*run pi-acompanhar in h-acomp2 (input "Lendo Registros..." + string(num-serie-rast.cod-estabel)). */

             FOR FIRST num-serie NO-LOCK
                 WHERE num-serie.n-serie = num-serie-rast.n-serie:

                 FIND FIRST nota-fiscal 
                      WHERE nota-fiscal.cod-estabel  = num-serie-rast.cod-estabel
                        AND nota-fiscal.serie        = num-serie-rast.serie 
                        AND nota-fiscal.nr-nota-fis  = num-serie-rast.nr-nota-fis NO-LOCK NO-ERROR.
                 IF NOT AVAIL nota-fiscal THEN NEXT.     

                 /* EAN 13 */
                 FIND FIRST item-mat 
                      WHERE item-mat.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                 IF  AVAIL item-mat THEN
                     ASSIGN c-ean = item-mat.cod-ean .
                 
                 /* dun 14 */
                 FIND FIRST item-dun 
                      WHERE item-dun.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                 IF AVAIL item-dun THEN
                    ASSIGN c-dun = item-dun.cod-dun.

                 CREATE tt-relat.            
                 ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                        tt-relat.etiqueta      = num-serie.n-serie
                        tt-relat.nr-nota-fis   = num-serie-rast.nr-nota-fis
                        tt-relat.serie         = num-serie-rast.serie
                        tt-relat.parcial       = NO
                        tt-relat.dun-excel     = c-dun
                        tt-relat.ean-excel     = c-ean 
                        tt-relat.data-excel    = num-serie-rast.data
                        tt-relat.usuario-excel = num-serie-rast.usuario.
         
                 IF  CAN-FIND(FIRST num-serie-fornec
                              WHERE num-serie-fornec.n-serie = num-serie.n-serie) THEN DO:
                     ASSIGN tt-relat.possui-serie-sec = TRUE.
                 
                     FOR EACH num-serie-fornec NO-LOCK
                        WHERE num-serie-fornec.n-serie = num-serie.n-serie:
         
                         IF tt-relat.series-sec = "" THEN 
                            ASSIGN tt-relat.series-sec = num-serie-fornec.n-serie-sec.
                         ELSE 
                            ASSIGN tt-relat.series-sec = tt-relat.series-sec + " " + num-serie-fornec.n-serie-sec.
                     END. /* FOR EACH num-serie-fornec */
                 END.
                 ELSE
                      ASSIGN tt-relat.possui-serie-sec = FALSE.
         
                 ASSIGN i-nr-registros = i-nr-registros   + 1.         

                 /*IF i-nr-registros = 10 THEN LEAVE blocoT.*/
                 
             END. /* FOR FIRST num-serie NO-LOCK */
        END. /* FOR EACH num-serie-rast NO-LOCK */

        IF tt-param.busca-solar 
        THEN DO:

            FOR EACH int-col-num-serie WHERE
                     int-col-num-serie.data >= tt-param.da-periodo-ini AND
                     int-col-num-serie.data <= tt-param.da-periodo-fim AND
                     int-col-num-serie.tp-cod-barra = 1 //Serial
                     NO-LOCK.        
                FOR EACH it-nota-fisc WHERE
                         it-nota-fisc.nr-pedido   = int-col-num-serie.nr-pedido 
                         NO-LOCK,
                    EACH nota-fiscal OF it-nota-fisc
                         NO-LOCK.
       
                    IF nota-fiscal.cod-estabel <>  tt-param.cod-estab-per THEN NEXT.
                    IF nota-fiscal.serie       <> tt-param.serie-per      THEN NEXT.

                    FOR FIRST num-serie NO-LOCK
                        WHERE num-serie.n-serie = int-col-num-serie.cod-barra:

                       CREATE tt-relat.            
                       ASSIGN tt-relat.it-codigo     = num-serie.it-codigo
                              tt-relat.etiqueta      = num-serie.n-serie
                              tt-relat.nr-nota-fis   = nota-fiscal.nr-nota-fis
                              tt-relat.serie         = nota-fiscal.serie
                              tt-relat.parcial       = NO
                              tt-relat.dun-excel     = ""
                              tt-relat.ean-excel     = ""
                              tt-relat.data-excel    = int-col-num-serie.data
                              tt-relat.usuario-excel = "".

                        FIND FIRST tt-it-relat WHERE tt-it-relat.it-codigo = num-serie.it-codigo NO-ERROR.
                        
                        IF NOT AVAIL tt-it-relat THEN DO:
                           CREATE tt-it-relat.
                           ASSIGN tt-it-relat.it-codigo = num-serie.it-codigo.
                        END.
                    END.
                END.
            END.
        END.
    END.

    /*run pi-inicializar in h-acomp (input "Imprimindo...", i-nr-registros).*/

    IF tt-param.rs-opcao <> 3 THEN DO:
        FOR EACH tt-relat BREAK BY tt-relat.nr-nota-fis
                                BY tt-relat.serie
                                BY tt-relat.it-codigo
                                /*BY tt-relat.etiqueta*/ WITH FRAME f-relat:
            
            FIND ITEM WHERE ITEM.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
        
            IF  i-linguagem = 2 THEN DO:
                FIND FIRST traduc-item 
                    WHERE traduc-item.cod-idioma = "Espanhol"
                      AND traduc-item.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
                IF  AVAIL traduc-item THEN
                    ASSIGN tt-relat.descricao-traduzida = traduc-item.tr-desc-item.
                ELSE
                    ASSIGN tt-relat.descricao-traduzida = "(Descripci¢n en Portugues) " + ITEM.desc-item.
            END.
            ELSE
                 ASSIGN tt-relat.descricao-traduzida = ITEM.desc-item.
        
        
            FIND FIRST tt-it-relat 
                 WHERE tt-it-relat.it-codigo = tt-relat.it-codigo NO-LOCK NO-ERROR.
        
            ASSIGN tt-relat.qtd-excel = tt-it-relat.qtd.
            
            IF  FIRST-OF(tt-relat.nr-nota-fis)
            AND FIRST-OF(tt-relat.serie)       THEN 
                RUN pi-declaracao.
        
            IF FIRST-OF(tt-relat.it-codigo) THEN DO:
                IF LINE-COUNTER >= 60 THEN
                   PAGE.
                IF i-linguagem = 1 THEN DO:   /* Portugues */
                   PUT UNFORMATTED
                       "PRODUTO: "
                       tt-relat.it-codigo
                       " - "
                       ITEM.desc-item
                       " - QUANTIDADE: "
                       tt-it-relat.qtd
                       SKIP(1).
                END.
                ELSE IF i-linguagem = 2  THEN DO:   /* Espanhol */
                    FIND FIRST traduc-item 
                         WHERE traduc-item.cod-idioma = "Espanhol"
                           AND traduc-item.it-codigo  = tt-relat.it-codigo NO-LOCK NO-ERROR.
                    PUT UNFORMATTED
                        "PRODUCTO: "
                        tt-relat.it-codigo
                        " - ".
                    IF AVAIL traduc-item THEN
                       PUT UNFORMATTED
                           traduc-item.tr-desc-item.
                    ELSE
                       PUT UNFORMATTED
                           "(Descripci¢n en Portugues) "
                           ITEM.desc-item.
                    PUT UNFORMATTED
                           " - CANTIDAD: "
                           tt-it-relat.qtd
                           SKIP(1).
                END.
            END.
            
            IF FIRST-OF(tt-relat.it-codigo) OR (i-cont = 8 AND NOT tt-relat.possui-serie-sec) OR (i-cont = 2 AND tt-relat.possui-serie-sec) THEN DO:
                ASSIGN i-cont     = 0
                       l-prim     = YES
                       c-etiqueta = "".
            END.
            ASSIGN i-cont = i-cont + 1.
        
            IF  tt-relat.possui-serie-sec THEN DO:
                ASSIGN tt-relat.series-sec = "[ " + tt-relat.series-sec + " ]"
                       c-etiqueta[i-cont] = tt-relat.etiqueta + " " + tt-relat.series-sec
                       tt-relat.etiqueta-excel = c-etiqueta[i-cont].
            END.
            ELSE 
                ASSIGN c-etiqueta[i-cont]      = tt-relat.etiqueta
                       tt-relat.etiqueta-excel = tt-relat.etiqueta
                       c-etiq-eco[i-cont]      = tt-relat.etiq-eco.
        
            IF  LAST-OF(tt-relat.it-codigo) OR (i-cont = 8 AND NOT tt-relat.possui-serie-sec) OR (i-cont = 2 AND tt-relat.possui-serie-sec) THEN DO:
                
        
                IF tt-relat.etiq-eco NE "" THEN DO:
                    IF tt-relat.possui-serie-sec THEN
                        PUT UNFORMATTED 
                            trim(c-etiqueta[1]) AT 06 FILL(" ",1)
                            trim(c-etiqueta[2])       SKIP.
                    ELSE DO:
                        IF c-etiqueta[1] = "" THEN ASSIGN c-etiq-eco[1] = "".
                        IF c-etiqueta[2] = "" THEN ASSIGN c-etiq-eco[2] = "".
                        IF c-etiqueta[3] = "" THEN ASSIGN c-etiq-eco[3] = "".
                        IF c-etiqueta[4] = "" THEN ASSIGN c-etiq-eco[4] = "".
                        IF c-etiqueta[5] = "" THEN ASSIGN c-etiq-eco[5] = "".
                        IF c-etiqueta[6] = "" THEN ASSIGN c-etiq-eco[6] = "".
                        IF c-etiqueta[7] = "" THEN ASSIGN c-etiq-eco[7] = "".
                        IF c-etiqueta[8] = "" THEN ASSIGN c-etiq-eco[8] = "".                        

                        PUT UNFORMATTED 
                            trim(c-etiq-eco[1]) AT 06 FILL(" ",1) trim(c-etiqueta[1]) SKIP
                            trim(c-etiq-eco[2]) AT 06 FILL(" ",1) trim(c-etiqueta[2]) SKIP
                            trim(c-etiq-eco[3]) AT 06 FILL(" ",1) trim(c-etiqueta[3]) SKIP
                            trim(c-etiq-eco[4]) AT 06 FILL(" ",1) trim(c-etiqueta[4]) SKIP
                            trim(c-etiq-eco[5]) AT 06 FILL(" ",1) trim(c-etiqueta[5]) SKIP
                            trim(c-etiq-eco[6]) AT 06 FILL(" ",1) trim(c-etiqueta[6]) SKIP
                            trim(c-etiq-eco[7]) AT 06 FILL(" ",1) trim(c-etiqueta[7]) SKIP
                            trim(c-etiq-eco[8]) AT 06 FILL(" ",1) trim(c-etiqueta[8]) SKIP.              
                    END.
                END.
                ELSE DO:
                    IF tt-relat.possui-serie-sec THEN
                        PUT UNFORMATTED 
                            trim(c-etiqueta[1]) AT 06 FILL(" ",1)
                            trim(c-etiqueta[2])       SKIP.
                    ELSE
                        PUT UNFORMATTED 
                            trim(c-etiqueta[1]) AT 06 FILL(" ",1)
                            trim(c-etiqueta[2])       FILL(" ",1)
                            trim(c-etiqueta[3])       FILL(" ",1)
                            trim(c-etiqueta[4])       FILL(" ",1)
                            trim(c-etiqueta[5])       FILL(" ",1)
                            trim(c-etiqueta[6])       FILL(" ",1)
                            trim(c-etiqueta[7])       FILL(" ",1)
                            trim(c-etiqueta[8])       SKIP.                                         
                END.               
                
                ASSIGN l-prim = NO
                       i-contaLinha = (IF i-contaLinha = 50 THEN 0 ELSE i-contaLinha + 1).
            END.
        
            IF last-of(tt-relat.it-codigo) /*AND NOT last(tt-relat.it-codigo)*/ THEN DO:
               PUT UNFORMATTED SKIP(2).
            END.
        END.
    END.

    IF tt-param.rs-opcao <> 3 THEN DO:
       IF  tt-param.gera-excel AND OPSYS <> "unix"  THEN DO:
           RUN esp/ftp/esftp020-excel.p (INPUT tt-param.rs-opcao,
                                         INPUT tt-param.nr-nota-fis-ini + "/" + tt-param.serie-ini,
                                         INPUT i-linguagem, 
                                         INPUT tt-param.arquivo-excel,
                                         INPUT IF tt-param.rs-opcao = 3 THEN 1 ELSE 0,
                                         INPUT TABLE tt-relat).
       END.
    END.
    ELSE DO:

          /*OUTPUT TO c:\temp\esftp020.csv.*/

           PUT UNFORMATTED "DATA;NOTA FISCAL;PRODUTO;NUMERO DE SERIE" SKIP.
            
            FOR EACH tt-relat
               BREAK BY tt-relat.data-excel
                     BY tt-relat.etiqueta
                     BY tt-relat.nr-nota-fis
                     BY tt-relat.it-codigo:

                run pi-acompanhar in h-acomp (input "Imprimindo Registros..." + string(tt-relat.nr-nota-fis)).
          
                PUT UNFORMATTED STRING(tt-relat.DATA-EXCEL, "99/99/9999")  ";"
                                tt-relat.nr-nota-fis ";"
                                tt-relat.it-codigo   ";"
                                tt-relat.etiqueta SKIP.
             END.
        /*OUTPUT CLOSE.*/
    END.
END.

PROCEDURE pi-declaracao:

    PUT UNFORMATTED "Intelbras"  SKIP(2).

    IF i-linguagem = 1 THEN DO: /* Portugues */
        
        PUT UNFORMATTED 
            space(10) "                                  Declara‡Æo" SKIP(2)
            space(10) "Declaramos que os produtos que embarcaram atrav‚s de nossa Nota fiscal " tt-relat.nr-nota-fis " possuem os seguintes n£meros de s‚rie:" SKIP(2).
        RETURN.
    END.
    
    
    IF i-linguagem = 2 THEN DO: /* espanhol */
        PUT UNFORMATTED 
           space(10) "                                      Declaraci¢n"   SKIP(2)
           space(10) "Declaramos que los productos que embarcaron a trav‚s de la nota fiscal " tt-relat.nr-nota-fis " tiene los siguientes n£meros de serie:" SKIP (2).
       RETURN.
        
    END.

END.


/**** Fim do programa ****/
