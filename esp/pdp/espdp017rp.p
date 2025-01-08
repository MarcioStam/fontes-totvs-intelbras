/***********************************************************************
**  Programa..: ESP\PDP\ESPDP017RP.P
**  Autor.....: CLAUDINEY KLITZKE - INTELBRAS
**  Data......: JULHO/2006 - Desenvolvimento
**  Descricao.: Relatorio de PROFORMA/PACKING LIST
**  Vers∆o....: 001 21/07/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESPDP017 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/pdp/espdp017tt.i}
{include/i-rpvar.i}
{esp/es0010.i}  /* serie de notas fiscais e especie de titulos */
{include/tt-edit.i} /*** definiáa‰ da temp-table tt-editor ***/
{include/pi-edit.i} /*** procedure pi-print-editor ****/

{utp/ut-glob.i}
/****************************  Temp-Tables  ****************************/

DEF TEMP-TABLE volume-ped
    FIELD cod-estabel    LIKE ped-venda.cod-estabel
    FIELD nome-abrev     LIKE ped-venda.nome-abrev
    FIELD nr-pedcli      LIKE ped-venda.nr-pedcli
    FIELD nr-volume      LIKE volume-nf.nr-volume
    FIELD it-codigo      LIKE ped-item.it-codigo
    FIELD qtde           LIKE volume-nf.qtde
    FIELD varios-itens   AS LOG
    FIELD soma           AS LOGICAL
    FIELD sigla-emb      LIKE embalag.sigla-emb
    INDEX volume-ped IS PRIMARY UNIQUE cod-estabel nome-abrev nr-pedcli nr-volume it-codigo
    INDEX item-vol   it-codigo nr-volume cod-estabel nome-abrev nr-pedcli.

def temp-table tt-resto
    field it-codigo like item.it-codigo
    field qtde      as dec
    index tt-resto is primary unique it-codigo
    index qtde     qtde.

DEF BUFFER b-tt-resto FOR tt-resto.
DEF BUFFER b-item     FOR ITEM.
def temp-table tt-volume-ped like volume-ped.
def buffer b-embalag for embalag.
DEFINE VARIABLE de-volume-resto AS DECIMAL     NO-UNDO.
/****************************  Variaveis    ****************************/
DEFINE VARIABLE i-indicador    AS INTEGER     NO-UNDO.
DEFINE VARIABLE r-item-caixa   AS ROWID       NO-UNDO.
DEF VAR c-desc-prod     AS CHAR FORMAT "X(76)".
DEF VAR de-tot-vol      AS DEC.
DEF VAR de-tot-bruto    AS DEC.
DEF VAR de-tot-m3       AS DEC.
DEF VAR de-tot-liq      AS DEC.
DEF VAR i-proximo-vol   AS INTEGER      NO-UNDO INIT 1.
DEF VAR i-qt-volumes    AS INTEGER FORMAT ">>>>9".
DEF VAR i-qtde          AS INTEGER FORMAT ">>>>>>>9".
DEF VAR de-peso-bruto   AS DEC FORMAT ">>>>,>>9.999".
DEF VAR de-peso-liq     AS DEC FORMAT ">>,>>9.999".
DEF VAR de-m3           AS DEC FORMAT ">>9.999".
DEF VAR c-emb-escolhida LIKE embalag.sigla-emb.
DEF VAR de-altura       AS DEC FORMAT ">>>9".
DEF VAR de-comprim      AS DEC FORMAT ">>>9".
DEF VAR de-largura      AS DEC FORMAT ">>>9".
DEF VAR c-nome-embal    AS CHAR FORMAT "X(10)".
DEF VAR de-qtde         LIKE ped-item.qt-pedida NO-UNDO.
DEF VAR de-total        LIKE ped-item.vl-tot-it NO-UNDO.
DEF VAR de-total-geral  LIKE ped-venda.vl-tot-ped NO-UNDO.
DEFINE VARIABLE de-vol-embalag  AS DECIMAL  FORMAT ">>,>>9.99999999999999"   NO-UNDO.
DEFINE VARIABLE  l-ativa-log    AS LOGICAL   INITIAL NO  NO-UNDO.
DEFINE VARIABLE  l-ativa-log-1  AS LOGICAL   INITIAL NO  NO-UNDO.
DEFINE VARIABLE i-qtde-itens AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-quantidade AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-vol-acum  AS DECIMAL FORMAT ">>,>>9.99999999999999"    NO-UNDO.
DEFINE VARIABLE de-vol-item  AS DECIMAL FORMAT ">>,>>9.99999999999999"    NO-UNDO.
DEFINE VARIABLE de-qtde-gravada AS DECIMAL     NO-UNDO.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FOR FIRST estabelec NO-LOCK
    WHERE estabelec.ep-codigo = empresa.ep-codigo: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESPDP017"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   
   ASSIGN de-total-geral = 0.
   
   IF tt-param.proforma THEN DO:
      run piMontaProforma.
      PAGE.
   END.

   IF tt-param.packing THEN DO:
      RUN piMontaPacking.
      PAGE.
   END.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piMontaPacking:

    ASSIGN c-titulo-relat = "Packing List".

    run pi-inicializar in h-acomp (input "Montando Relat¢rio...PACKING").
    
    RUN piCabecalho(INPUT 1).
    RUN pi-Calcula-Volumes.


    FOR EACH volume-ped NO-LOCK
        WHERE volume-ped.cod-estabe   = ped-venda.cod-estabel
        AND   volume-ped.nome-abrev   = ped-venda.nome-abrev
        AND   volume-ped.nr-pedcli    = ped-venda.nr-pedcli
        AND   volume-ped.varios-itens = YES,
        FIRST ITEM  
               WHERE item.it-codigo = volume-ped.it-codigo NO-LOCK
        BREAK BY volume-ped.nr-volume
              BY volume-ped.it-codigo
              BY volume-ped.sigla-emb:

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido/Item PACKING: " + 
                                      volume-ped.nr-pedcli + "/" +
                                      volume-ped.it-codigo).

        FIND FIRST embalag NO-LOCK
             WHERE embalag.sigla-emb = volume-ped.sigla-emb NO-ERROR.

        IF FIRST-OF(volume-ped.it-codigo) OR
           FIRST-OF(volume-ped.sigla-emb) THEN DO:
           ASSIGN i-qt-volumes  = volume-ped.nr-volume
                  i-qtde        = 0
                  de-peso-bruto = 0
                  de-peso-liq   = 0.
        END.
        IF FIRST-OF(volume-ped.nr-volume) THEN do:
            ASSIGN de-peso-bruto =  embalag.peso-embal.
 
            
        END.
        IF volume-ped.soma = YES THEN
           ASSIGN i-qtde = i-qtde + volume-ped.qtde.
        ELSE
            IF FIRST-OF(volume-ped.it-codigo) THEN
                ASSIGN i-qtde = i-qtde + volume-ped.qtde.

        ASSIGN  de-peso-bruto = de-peso-bruto + (volume-ped.qtde * ITEM.peso-bruto)
                de-peso-liq   = de-peso-liq   + (volume-ped.qtde * ITEM.peso-liq).
        
        IF l-ativa-log-1 THEN
            PUT volume-ped.it-codigo " QTDE = " volume-ped.qtde " Peso bruto = " ITEM.peso-bruto "  QTD X PESO =  " (volume-ped.qtde * ITEM.peso-bruto) " Peso Bruto + Embaalgem " de-peso-bruto " Peso Embalagem = " embalag.peso-embal SKIP. 
 
        IF LAST-OF(volume-ped.it-codigo) OR
           LAST-OF(volume-ped.sigla-emb) THEN DO:
            RUN piNarrativaItem.
    
            FIND FIRST embalag NO-LOCK
                 WHERE embalag.sigla-emb = volume-ped.sigla-emb NO-ERROR.

            IF AVAIL embalag  THEN DO:
               ASSIGN i-qt-volumes = volume-ped.nr-volume - i-qt-volumes + 1 
                      de-m3 = i-qt-volumes * embalag.volume
                      de-altura = embalag.altura
                      de-comprim = embalag.comprim
                      de-largura = embalag.largura
                      c-nome-embal = embalag.descricao.
            END.
            ELSE DO:
                ASSIGN i-qt-volumes  = 0
                       de-peso-bruto = 0
                       de-peso-liq   = 0
                       de-m3 = 0
                       de-altura = 0
                       de-comprim = 0
                       de-largura = 0
                       c-nome-embal = "".
            END.

            PUT volume-ped.it-codigo FORMAT "X(7)"
                " "
                (IF AVAILABLE tt-editor
                THEN tt-editor.conteudo ELSE "") FORMAT "X(51)"
                i-qtde " ".
            IF FIRST-OF(volume-ped.nr-volume) THEN do:
                ASSIGN de-tot-vol = de-tot-vol + 1
                      de-m3 = i-qt-volumes * embalag.volume
                      de-altura = embalag.altura
                      de-comprim = embalag.comprim
                      de-largura = embalag.largura
                      c-nome-embal = embalag.descricao.
                ASSIGN de-tot-m3    = de-tot-m3 + de-m3.

                PUT 1.
            END.
            PUT de-peso-bruto format ">>>>,>>9.999" at 80 " "
                de-peso-liq " ".
            IF FIRST-OF(volume-ped.nr-volume) THEN
               PUT de-m3 " "
                   de-largura " "
                   de-altura " "
                   de-comprim " "
                   c-nome-embal SKIP.
            ELSE
                PUT "" SKIP.
                
           IF LINE-COUNTER  > PAGE-SIZE
           THEN PAGE.
                
           
           ASSIGN de-tot-bruto = de-tot-bruto + de-peso-bruto
                  de-tot-liq   = de-tot-liq + de-peso-liq.
                  
        END.
        
    END.
    FOR EACH volume-ped NO-LOCK
        WHERE volume-ped.cod-estabe   = ped-venda.cod-estabel
        AND   volume-ped.nome-abrev   = ped-venda.nome-abrev
        AND   volume-ped.nr-pedcli    = ped-venda.nr-pedcli
        AND   volume-ped.varios-itens = NO,
        FIRST ITEM  
               WHERE item.it-codigo = volume-ped.it-codigo NO-LOCK
        BREAK 
              BY volume-ped.it-codigo
              BY volume-ped.sigla-emb
              BY volume-ped.nr-volume  :

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido/Item PACKING: " + 
                                      volume-ped.nr-pedcli + "/" +
                                      volume-ped.it-codigo).

        IF FIRST-OF(volume-ped.it-codigo) OR
           FIRST-OF(volume-ped.sigla-emb) THEN DO:
           ASSIGN i-qt-volumes  = volume-ped.nr-volume
                  i-qtde        = 0
                  de-peso-bruto = 0
                  de-peso-liq   = 0.
        END.
        IF volume-ped.soma = YES THEN
           ASSIGN i-qtde = i-qtde + volume-ped.qtde.
        ELSE
            IF FIRST-OF(volume-ped.it-codigo) THEN
                ASSIGN i-qtde = i-qtde + volume-ped.qtde.
        ASSIGN  de-peso-bruto = de-peso-bruto + (volume-ped.qtde * ITEM.peso-bruto)
                de-peso-liq   = de-peso-liq   + (volume-ped.qtde * ITEM.peso-liq).
        

        FIND FIRST embalag NO-LOCK
             WHERE embalag.sigla-emb = volume-ped.sigla-emb NO-ERROR.

        ASSIGN de-peso-bruto = de-peso-bruto +  embalag.peso-embal .

        IF l-ativa-log-1 THEN
             PUT "-2- " volume-ped.it-codigo " QTDE = " volume-ped.qtde " Peso bruto = " ITEM.peso-bruto "  QTD X PESO =  " (volume-ped.qtde * ITEM.peso-bruto) " Peso Bruto + Embaalgem = " de-peso-bruto " PESO EMBALAGEM = " embalag.peso-embal SKIP. 


        IF LAST-OF(volume-ped.it-codigo) OR
           LAST-OF(volume-ped.sigla-emb) THEN DO:
            RUN piNarrativaItem.

    
            IF AVAIL embalag  THEN DO:
           
               ASSIGN i-qt-volumes = volume-ped.nr-volume - i-qt-volumes + 1 
                      de-m3 = i-qt-volumes * embalag.volume
                      de-altura = embalag.altura
                      de-comprim = embalag.comprim
                      de-largura = embalag.largura
                      c-nome-embal = embalag.descricao.

                    
            END.
            ELSE DO:
                ASSIGN i-qt-volumes  = 0
                       de-peso-bruto = 0
                       de-peso-liq   = 0
                       de-m3 = 0
                       de-altura = 0
                       de-comprim = 0
                       de-largura = 0
                       c-nome-embal = "".
            END.

            PUT volume-ped.it-codigo FORMAT "X(7)"
                " "
                (IF AVAILABLE tt-editor
                THEN tt-editor.conteudo ELSE "") FORMAT "X(51)"
                i-qtde " ".
            IF last-OF(volume-ped.nr-volume) THEN do:
                ASSIGN de-tot-vol = de-tot-vol + i-qt-volumes
                      de-m3 = i-qt-volumes * embalag.volume
                      de-altura = embalag.altura
                      de-comprim = embalag.comprim
                      de-largura = embalag.largura
                      c-nome-embal = embalag.descricao.
                ASSIGN de-tot-m3    = de-tot-m3 + de-m3.
                PUT "     " i-qt-volumes .
            END.
            PUT de-peso-bruto format ">>>>,>>9.999" at 80 " "
                de-peso-liq " ".
            IF FIRST-OF(volume-ped.nr-volume) THEN
               PUT de-m3 " "
                   de-largura " "
                   de-altura " "
                   de-comprim " "
                   c-nome-embal SKIP.
            ELSE
                PUT "" SKIP.
                
           IF LINE-COUNTER  > PAGE-SIZE
           THEN PAGE.
                
           
           ASSIGN de-tot-bruto = de-tot-bruto + de-peso-bruto
                  de-tot-liq   = de-tot-liq + de-peso-liq
                  de-peso-bruto = 0
                  de-peso-liq = 0.
                  
        END.
        
    END.

/*    
    FOR EACH volume-ped NO-LOCK
        WHERE volume-ped.cod-estabe   = ped-venda.cod-estabel
        AND   volume-ped.nome-abrev   = ped-venda.nome-abrev
        AND   volume-ped.nr-pedcli    = ped-venda.nr-pedcli
        AND   volume-ped.varios-itens = YES,
        FIRST ITEM 
               WHERE item.it-codigo = volume-ped.it-codigo NO-LOCK
        BREAK BY volume-ped.sigla-emb
              BY volume-ped.nr-volume:

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido/Item PACKING: " + 
                                      volume-ped.nr-pedcli + "/" +
                                      volume-ped.it-codigo).

        IF FIRST-OF(volume-ped.sigla-emb) or
           first-of(volume-ped.nr-volume)THEN DO:
           ASSIGN i-qtde        = 0
                  de-peso-bruto = 0
                  de-peso-liq   = 0.
        END.

/*         PUT "volume-ped " volume-ped.sigla-emb " " volume-ped.nr-volume " " volume-ped.it-codigo " " volume-ped.qtde SKIP. */

        ASSIGN i-qtde = volume-ped.qtde.

        RUN piNarrativaItem.

        FIND FIRST embalag NO-LOCK
             WHERE embalag.sigla-emb = volume-ped.sigla-emb NO-ERROR.

        IF AVAIL embalag  THEN
           ASSIGN i-qt-volumes = 1 
                  de-peso-bruto = (i-qtde * ITEM.peso-bruto)
                  de-peso-liq   = (i-qtde * ITEM.peso-liq)
                  de-m3 = i-qt-volumes * embalag.volume
                  de-altura = embalag.altura
                  de-comprim = embalag.comprim
                  de-largura = embalag.largura
                  c-nome-embal = embalag.descricao.
        ELSE DO:
            ASSIGN i-qt-volumes = 0
                   de-peso-bruto = 0
                   de-peso-liq   = 0
                   de-m3 = 0
                   de-altura = 0
                   de-comprim = 0
                   de-largura = 0
                   c-nome-embal = "".
        END.

        IF LAST-OF(volume-ped.sigla-emb) or
           last-of(volume-ped.nr-volume) THEN DO:

            /**** sempre o peso da embalagem (caixa) estar† atribuida ao ultimo item *****/
            ASSIGN de-peso-bruto = de-peso-bruto + embalag.peso-embal.

            PUT volume-ped.it-codigo FORMAT "X(7)"
                " "
                (IF AVAILABLE tt-editor 
                THEN tt-editor.conteudo ELSE "") FORMAT "X(51)"
                i-qtde " "
                i-qt-volumes " "
                de-peso-bruto " "
                de-peso-liq " "
                de-m3 " " 
                de-largura " " 
                de-altura " " 
                de-comprim " " 
                c-nome-embal  SKIP.
            ASSIGN de-tot-vol = de-tot-vol + i-qt-volumes
                   de-tot-m3  = de-tot-m3 + de-m3.
            
        END.
        ELSE DO:
            PUT volume-ped.it-codigo FORMAT "X(7)"
                " "
                (IF AVAILABLE tt-editor 
                THEN tt-editor.conteudo ELSE "") FORMAT "X(51)"
                i-qtde "       "
                de-peso-bruto " "
                de-peso-liq SKIP.
        END.
           IF LINE-COUNTER  > PAGE-SIZE
           THEN PAGE.
                        
        ASSIGN de-tot-bruto = de-tot-bruto + de-peso-bruto
               de-tot-liq   = de-tot-liq + de-peso-liq.
        
    END.*/
    
    PUT "-----  ----------- ---------- ------" AT 74
        "TOTAL     " AT 58
        de-tot-vol   FORMAT ">>>>9" AT 74
        de-tot-bruto FORMAT ">>>>>,>>9.999"
        de-tot-liq   FORMAT ">>>,>>9.999"
        de-tot-m3    FORMAT ">>>9.999".

END PROCEDURE.

PROCEDURE piMontaProforma.
    
    ASSIGN c-titulo-relat = "Commercial Invoice".

    run pi-inicializar in h-acomp (input "Montando Relat¢rio...PROFORMA").
    
    RUN piCabecalho(INPUT 2).

    FOR EACH ped-item OF ped-venda NO-LOCK,
        FIRST ITEM  OF ped-item NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido/Item PROFORMA.: " + 
                                      ped-venda.nr-pedcli + "/" +
                                      ped-item.it-codigo).
        RUN piNarrativaItem.
        
        IF tt-param.qtde = 1 THEN
           ASSIGN de-qtde = ped-item.qt-pedida
                  de-total = ped-item.vl-tot-it.
        ELSE
            ASSIGN de-qtde = ped-item.qt-log-aloca
                   de-total = ped-item.qt-log-aloca * ped-item.vl-preuni.

        IF de-qtde = 0 THEN NEXT.

        ASSIGN de-total-geral = de-total-geral + de-total.

        PUT ped-item.it-codigo FORMAT "X(7)"
            " "
            (IF AVAILABLE tt-editor 
            THEN tt-editor.conteudo ELSE "") FORMAT "X(46)"
            de-qtde " "
            ped-item.vl-preuni " "
            de-total  SKIP.
            
            
          IF LINE-COUNTER  > PAGE-SIZE
             THEN PAGE.            
    END.
    PUT "--------------- " AT 87
        "TOTAL       " AT 74
        de-total-geral SKIP.



END PROCEDURE.

PROCEDURE piCabecalho.

    DEF INPUT PARAMETER i-tipo AS INT.

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = tt-param.pedido 
          and ped-venda.nome-abrev = tt-param.nome-abrev NO-ERROR.
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    FIND FIRST moeda OF ped-venda NO-LOCK.
    FIND FIRST cond-pagto OF ped-venda NO-LOCK no-error.

    IF i-tipo = 1 THEN 
       PUT "PACKING LIST: ".
    ELSE
       PUT "COMMERCIAL INVOICE: ".

    PUT PED-VENDA.NR-PEDCLI .
       /* "/" FORMAT "X(2)" 
        YEAR(TODAY) FORMAT "9999"  SPACE(53) */ 
     if ped-venda.cod-cond-pag <> 0 then
        put "PO Nro / Numero Del Ordene de compra: " AT 83
            PED-VENDA.NR-PEDCLI SKIP(1).
     else put "" at 83 skip(1).

    IF I-TIPO = 1 THEN do:
       PUT "EXPORTER/EXPORTADOR: " C-EMPRESA. 
        if ped-venda.cod-cond-pag <> 0 then
           put "        SOLD TO/VENDIDO PARA: ".
        else    
           put "    SAMPLES TO/MUESTRAS PARA: ".

           put emitente.nome-emit SKIP
               EMPRESA.ENDERECO AT 23              emitente.endereco AT 87 SKIP
               EMPRESA.PAIS AT 23                  emitente.pais AT 92 SKIP (1).
    end.
    ELSE do:      
       PUT "EXPORTER/EXPORTADOR: " C-EMPRESA SPACE(20).
       IF ped-venda.cod-estabel <> "301" THEN DO:
           if ped-venda.cod-cond-pag <> 0 then
              put  "BANK INFORMATION: BANCO SANTANDER BANESPA S.A." SKIP.
                 
           put EMPRESA.ENDERECO AT 22.
       
            if ped-venda.cod-cond-pag <> 0 then
                put "Agency ....: 1512" AT 100 SKIP.
            else
                put "" skip.
         
            put EMPRESA.PAIS AT 22.
       
            if ped-venda.cod-cond-pag <> 0 then
                  put "Account Nro: 13000002-5" AT 100 SKIP
                        "Swift .....: BSCHBRSP"   AT 100 SKIP(1).
            else 
                  put "" skip skip(1).
       END.
       ELSE DO:                      
              if ped-venda.cod-cond-pag <> 0 then
                 put  "BANK INFORMATION: ITAU S.A." SKIP.
    
              put EMPRESA.ENDERECO AT 22.
    
               if ped-venda.cod-cond-pag <> 0 then
                   put "Agency ....: 3045" AT 100 SKIP.
               else
                   put "" skip.
    
               put EMPRESA.PAIS AT 22.
    
               if ped-venda.cod-cond-pag <> 0 then
                     put "Account Nro: 00212-2" AT 100 SKIP
                           "Swift .....: BSCHBRSP"   AT 100 SKIP(1).
               else 
                     put "" skip skip(1).

       
      END.    
    END.                 
    
    IF i-tipo = 2 THEN
       PUT "SOLD TO/VENDIDO PARA: " emitente.nome-emit SKIP
           emitente.endereco AT 23 SKIP
           emitente.pais AT 23 SKIP (1).
    
    PUT "                         Country of origin / Pais de origem: "
        empresa.pais SKIP
        "                   Country of destination / Pais de destino: "
        emitente.pais SKIP
        "Port / Airport of loading / Puerto / Aeropuerto de embarque: " tt-param.local-embarque format "x(80)" SKIP
        "                                   Shipped by/ Embarque via: " tt-param.embarque-via format "x(03)" SKIP
        "                                                   INCOTERM: " tt-param.incoterm format "x(80)" SKIP
        "                                            Currency/Moneda: "
        moeda.descricao SKIP
        "                    Payment Condition / Condiciones de Pago: ".
    if avail cond-pagto then
        put cond-pagto.descricao SKIP(1).
    else if ped-venda.cod-cond-pag = 0 then 
            put "Samples with no commercial value/Muestras sin valor comercial" skip(1).
         else put "" skip(1).

    put "        "
        "DESCRIPTION OF GOODS      " SPACE(20) 
        "     QUANTITY ".
    
    IF i-tipo = 1 THEN
       PUT  "     CAJAS "
            "GROSS WEIGHT "
            "NET WEIGHT        ------MM------" SKIP.
    ELSE             
       PUT "       UNIT PRICE "
           "         AMOUNT" SKIP.
    PUT "REFER.  "
        "DESCRIPTION DE LAS MERCANCIAS " SPACE(16)
        "     CANTIDAD ".
    IF I-TIPO = 1 THEN
       PUT "     VOLUM " 
           "  PESO BRUTO "
           " PESO NETO "
           "    M3 "
           "L    "
           "A    "
           "C    " 
           "PACKING  " SKIP.
    ELSE
       PUT "           PRECIO "
           "          TOTAL " SKIP.

    PUT "------- "
        fill("-", 46) format "x(46)"
        " " 
        "------------ ".
    IF I-TIPO = 1 THEN
       PUT "     ----- "
           "------------ "
           "---------- "
           "------ "
           "---- "
           "---- "
           "---- " 
           "---------- " SKIP.
    ELSE
       PUT "----------------- "
           "---------------" SKIP.

END PROCEDURE.

PROCEDURE piNarrativaItem.
    
    if item.ind-imp-desc = 1 THEN /* Descriá∆o */
       ASSIGN c-desc-prod = item.desc-item.

    if  item.ind-imp-desc = 2           /* Descriá∆o + Narrativa */
    or  item.ind-imp-desc = 5           /* Narrativa Item */
    or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
    or  item.ind-imp-desc = 10 THEN DO: /* Descriá∆o + 24 Narrativa Item */

        if  item.ind-imp-desc = 2
        or  item.ind-imp-desc = 10 THEN
            ASSIGN c-desc-prod = item.desc-item.
        ELSE 
            ASSIGN c-desc-prod = "".

        FIND narrativa of item NO-LOCK NO-ERROR.

        IF AVAILABLE narrativa THEN 
            ASSIGN c-desc-prod = c-desc-prod +
                              if  item.ind-imp-desc = 6 THEN
                                  trim(entry(1,SUBSTRING(narrativa.descricao,1,76),chr(10)))
                              ELSE if item.ind-imp-desc = 10 THEN
                                  trim(entry(1,SUBSTRING(narrativa.descricao,1,24),chr(10)))
                              ELSE                        
                                  narrativa.descricao.
    END.

    if  item.ind-imp-desc = 3          /* Descriá∆o + Narrativa Item/Cliente */
    or  item.ind-imp-desc = 8 THEN DO: /* Descriá∆o + 24 Narrativa Item/Cliente */
        FIND item-cli
           WHERE item-cli.nome-abrev = volume-ped.nome-abrev
           and   item-cli.it-codigo  = ITEM.it-codigo
           NO-LOCK NO-ERROR.

        ASSIGN c-desc-prod = item.desc-item.

        IF AVAILABLE item-cli THEN
            ASSIGN c-desc-prod = c-desc-prod +
                               if item.ind-imp-desc = 3 THEN          
                                  item-cli.narrativa
                               ELSE
                                  trim(entry(1,SUBSTRING(item-cli.narrativa,1,24),chr(10))).
    END.

    if  item.ind-imp-desc = 4            /* Descriá∆o + Narrativa Informada */
    or  item.ind-imp-desc = 7            /* Narrativa Informada */
    or  item.ind-imp-desc = 9 THEN DO:   /* Descriá∆o + 24 Narrativa Informada */

        if  item.ind-imp-desc = 4
        or  item.ind-imp-desc = 9 THEN
            ASSIGN c-desc-prod = item.desc-item.
        ELSE 
            ASSIGN c-desc-prod = "".

            /**** o item.ind-imp-desc = 7 (narrativa informada) n∆o precisa
                  ser considerado neste caso ****/
    END.

    run pi-print-editor(INPUT replace(replace(c-desc-prod, chr(13), " "), chr(10), " ") ,
                    INPUT 98).
    FIND FIRST tt-editor NO-LOCK NO-ERROR.

END PROCEDURE.

PROCEDURE pi-calcula-volumes:

    
   def var i-nr-volumes    as int.
   def var i-tmp           as int.
   def var ind             as int.
   def var de-tmp          as dec format "99.999999999".
   def var de-vol-tmp      as dec.
   def var de-tmp-acum     as dec format "99.999999999".

   DEF VAR lItemBranco     AS LOGICAL    NO-UNDO.
   DEF VAR iNrVol          LIKE volume-nf.nr-volume NO-UNDO.
   DEF VAR i-vol-exp       AS INTEGER      NO-UNDO.
   DEF VAR i-nr-vol-aux    AS INTEGER      NO-UNDO INITIAL 0.

   DEFINE VARIABLE i-nro-caixas AS dec     NO-UNDO.
   DEFINE VARIABLE i-caixa AS INTEGER     NO-UNDO.

   assign i-nr-volumes = 0.
   
   for each tt-resto:
       delete tt-resto.
   end.
   for each volume-ped
       where volume-ped.cod-estabel = ped-venda.cod-estabel
         and volume-ped.nome-abrev  = ped-venda.nome-abrev
         and volume-ped.nr-pedcli   = ped-venda.nr-pedcli:
       delete volume-ped.
   end.

   for each ped-item  of ped-venda NO-LOCK 
       where not ped-item.it-codigo begins "servico",
       first item  NO-LOCK 
             where item.it-codigo = ped-item.it-codigo
       break by ped-item.it-codigo:

        /* Desconsidera o item DÇbito Direto */
        IF  item.tipo-contr  = 4  OR
            item.baixa-estoq = NO THEN
            NEXT.
       
        IF l-ativa-log THEN
            PUT "Pi-calcula-volumes "  ped-item.it-codigo " " ped-item.qt-pedida " " ped-item.qt-log-aloca " " tt-param.qtde SKIP.
 

       IF tt-param.qtde = 1 THEN
          ASSIGN de-qtde = ped-item.qt-pedida.
       ELSE
          ASSIGN de-qtde = ped-item.qt-log-aloca.

       IF de-qtde = 0 THEN
          NEXT.
       FIND int-emitente
            WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
            NO-LOCK NO-ERROR.
       

       if avail int-emitente and
          int-emitente.tipo-embalagem <> "" then do:
           
          find first embalag NO-LOCK
             WHERE embalag.embalagem = int-emitente.tipo-embalagem 
             no-error.
          
          IF AVAIL embalag THEN
              ASSIGN c-emb-escolhida = embalag.sigla-emb.
          find first item-caixa no-lock
               where item-caixa.sigla-emb BEGINS embalag.sigla-emb
                 and item-caixa.it-codigo = ped-item.it-codigo 
                 AND item-caixa.fm-cod-com = ?
                 AND item-caixa.fm-codigo  = ? no-error.

           IF l-ativa-log THEN
              PUT "definindo embalagem " AVAIL item-caixa " EMITENTE EMBALAGEM " int-emitente.tipo-embalagem  "SIGLA EMB " embalag.sigla-emb SKIP. 

       END.
       ELSE DO:
           
           find first item-caixa no-lock
                where item-caixa.it-codigo = ped-item.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? 
                  /*AND item-caixa.sigla-emb BEGINS "E"*/ no-error.  

         IF l-ativa-log THEN
              PUT "definindo embalagem -1.01 - achou item-ciaxa " AVAIL item-caixa " " ped-item.it-codigo  SKIP. 

           IF  NOT AVAIL item-caixa THEN DO:
               ASSIGN r-item-caixa = ?.
               blk_sigla:
               FOR EACH  item-caixa NO-LOCK
                    WHERE item-caixa.it-codigo =  ped-item.it-codigo
                    AND   item-caixa.fm-cod-com = ?
                    AND   item-caixa.fm-codigo  = ?:
                    
                    /*IF  SUBSTRING(item-caixa.sigla-emb,1,1) >= "N"
                    AND SUBSTRING(item-caixa.sigla-emb,1,1) <> "S" THEN DO: */
                        IF l-ativa-log THEN
                            PUT "definindo embalagem -1.0 - achou item-ciaxa " AVAIL item-caixa item-caixa.sigla-emb SKIP. 

                        ASSIGN r-item-caixa = ROWID(item-caixa).
                        LEAVE blk_sigla.
                   /* END.*/
               END.

               FIND FIRST item-caixa NO-LOCK
                       WHERE  ROWID(item-caixa) = r-item-caixa NO-ERROR.

           END.


           IF l-ativa-log THEN
              PUT "definindo embalagem -1.1 - achou item-ciaxa " AVAIL item-caixa  SKIP. 

           ASSIGN c-emb-escolhida = "".
            IF AVAIL item-caixa THEN DO:
                FOR FIRST embalag NO-LOCK
                    WHERE embalag.sigla-emb = item-caixa.sigla-emb:
                    ASSIGN c-emb-escolhida = embalag.sigla-emb.
                END.
                IF NOT AVAIL embalag THEN DO:
                    
                    FOR EACH embalag NO-LOCK
                        WHERE embalag.embalagem BEGINS "EMB"
                        AND   embalag.emite-roman 
                        BREAK BY embalag.volume:
                        ASSIGN c-emb-escolhida = embalag.sigla-emb.
                    END.

                    FIND FIRST item-caixa NO-LOCK
                         WHERE item-caixa.sigla-emb  BEGINS c-emb-escolhida
                           AND item-caixa.it-codigo  = ped-item.it-codigo
                           AND item-caixa.fm-cod-com = ?
                           AND item-caixa.fm-codigo  = ? NO-ERROR.
                     IF l-ativa-log THEN
                        PUT "definindo embalagem -2- nao achou " AVAIL item-caixa SKIP. 

                END.
                IF l-ativa-log THEN
                   PUT "definindo embalagem -2- " ped-item.it-codigo " " AVAIL embalag AVAIL item-caixa  SKIP. 

           END.
           IF l-ativa-log THEN   
              PUT "definindo embalagem -2- " AVAIL item-caixa  SKIP. 
       END.
       

       IF l-ativa-log THEN
          PUT "item " ITEM.it-codigo ITEM.comprim ITEM.largura ITEM.altura SKIP. 

       IF ITEM.it-codigo BEGINS "4" THEN
           if item.comprim = 0 or item.largura = 0 or item.altura = 0 then do:
                MESSAGE "Item com informaá‰es das dimens‰es zeradas, Favor conferir as dimens‰es do item, para que n∆o sejam zeradas. " 
                          ITEM.it-codigo
                        VIEW-AS ALERT-BOX.                
                RETURN "NOK".
           END.

       FIND FIRST tt-resto 
             WHERE tt-resto.it-codigo = ped-item.it-codigo NO-ERROR.
       IF  NOT AVAIL tt-resto THEN DO:
            CREATE tt-resto.
            ASSIGN tt-resto.it-codigo = ped-item.it-codigo.
       END.

       IF  AVAIL item-caixa THEN DO:
            IF l-ativa-log THEN
                PUT "-5- "de-qtde " >= "  item-caixa.qt-item SKIP. 

            IF de-qtde >= item-caixa.qt-item THEN DO:
                ASSIGN i-tmp         = TRUNC(de-qtde / item-caixa.qt-item,0)
                       tt-resto.qtde = tt-resto.qtde + de-qtde MOD item-caixa.qt-item
                       de-volume-resto = de-volume-resto + ((de-qtde MOD item-caixa.qt-item) * (item.altura * item.largura * item.comprim) / 1000000000).

                IF  l-ativa-log THEN
                     PUT "-6 GRAVOU RESTO- "  (de-qtde MOD item-caixa.qt-item) " VOLUME DO RESTO " de-volume-resto " volume do item " ((de-qtde MOD item-caixa.qt-item) * (item.altura * item.largura * item.comprim) / 1000000000) SKIP.


                DO  ind = i-proximo-vol TO (i-proximo-vol + i-tmp) - 1:
                    IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                        FOR EACH  estrutura NO-LOCK
                            WHERE estrutura.it-codigo     = ped-item.it-codigo
                            AND   estrutura.data-inicio  <= TODAY
                            AND   estrutura.data-termino >= TODAY
                            AND   NOT estrutura.es-codigo BEGINS "43":

                            FIND FIRST volume-ped EXCLUSIVE-LOCK
                                WHERE  volume-ped.cod-estabel = ped-venda.cod-estabel
                                AND    volume-ped.nome-abrev  = ped-venda.nome-abrev
                                AND    volume-ped.nr-pedcli   = ped-venda.nr-pedcli
                                AND    volume-ped.it-codigo   = estrutura.es-codigo
                                AND    volume-ped.nr-volume   = ind NO-ERROR.
                            IF  NOT AVAIL volume-ped THEN DO:
                                IF  l-ativa-log THEN
                                    PUT "criou -3- " estrutura.quant-usada SKIP. 

                                CREATE volume-ped.
                                ASSIGN volume-ped.cod-estabel = ped-venda.cod-estabel    
                                       volume-ped.nome-abrev  = ped-venda.nome-abrev     
                                       volume-ped.nr-pedcli   = ped-venda.nr-pedcli      
                                       volume-ped.it-codigo   = estrutura.es-codigo   
                                       volume-ped.nr-volume   = ind no-error.       
                            END.

                            ASSIGN volume-ped.qtde         = volume-ped.qtde + estrutura.quant-usada
                                   volume-ped.sigla-emb    = item-caixa.sigla-emb
                                   volume-ped.varios-itens = YES.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST volume-ped EXCLUSIVE-LOCK
                            WHERE  volume-ped.cod-estabel = ped-venda.cod-estabel    
                            AND    volume-ped.nome-abrev  = ped-venda.nome-abrev     
                            AND    volume-ped.nr-pedcli   = ped-venda.nr-pedcli      
                            AND    volume-ped.it-codigo   = ped-item.it-codigo
                            AND    volume-ped.nr-volume   = ind NO-ERROR.
                        IF  NOT AVAIL volume-ped THEN DO:
                            IF  l-ativa-log THEN
                                PUT "criou -4- " item-caixa.qt-item SKIP. 

                            CREATE volume-ped.
                            ASSIGN volume-ped.cod-estabel = ped-venda.cod-estabel    
                                   volume-ped.nome-abrev  = ped-venda.nome-abrev     
                                   volume-ped.nr-pedcli   = ped-venda.nr-pedcli      
                                   volume-ped.it-codigo   = ped-item.it-codigo
                                   volume-ped.nr-volume   = ind.
                        END.
                        ASSIGN volume-ped.qtde      = volume-ped.qtde + item-caixa.qt-item
                               volume-ped.sigla-emb = item-caixa.sigla-emb.
                    
                    END.
                END.

                ASSIGN i-proximo-vol = i-proximo-vol + i-tmp.
                IF  l-ativa-log THEN
                    PUT "-6a- somou tmp "  i-proximo-vol " " i-tmp SKIP. 
            END.
            ELSE DO:
                ASSIGN tt-resto.qtde   = tt-resto.qtde + de-qtde
                       de-volume-resto = de-volume-resto + (de-qtde * (item.altura * item.largura * item.comprim) / 1000000000).

                IF  l-ativa-log THEN
                    PUT "-6- "  de-qtde " VOLUME DO RESTO " de-volume-resto " volume do item " (de-qtde * (item.altura * item.largura * item.comprim) / 1000000000) SKIP.
            END.
       END. /* AVAIL item-caixa */
       ELSE DO:
            ASSIGN tt-resto.qtde   = tt-resto.qtde +  de-qtde
                   de-volume-resto = de-volume-resto + (de-qtde * (item.altura * item.largura * item.comprim) / 1000000000).

            IF l-ativa-log THEN
               PUT "-7- "  de-qtde " Volume do Resto " de-volume-resto " volume do item " (de-qtde * (item.altura * item.largura * item.comprim) / 1000000000) SKIP.
   
       END.
   END.
   
    
    /* Busca uma embalagem unica para colocar todos os itens que s∆o "bagulho" (resto) */
   ASSIGN c-emb-escolhida = "".

   if avail int-emitente and
       int-emitente.tipo-embalagem <> "" then do:
       find first embalag NO-LOCK
          WHERE embalag.embalagem = int-emitente.tipo-embalagem 
          no-error.
       IF AVAIL embalag THEN DO:
           ASSIGN c-emb-escolhida = "".
       END.
   END.

   IF c-emb-escolhida <> "" THEN DO: /* SIGNIFICA QUE ACHOU UMA CAIXA QUE COMPORTA TODO O FRACIONADO */

       FIND LAST volume-ped EXCLUSIVE-LOCK
                   WHERE volume-ped.cod-estabel = ped-venda.cod-estabel    
                   AND   volume-ped.nome-abrev  = ped-venda.nome-abrev     
                   AND   volume-ped.nr-pedcli   = ped-venda.nr-pedcli           NO-ERROR.
       IF  AVAIL volume-ped THEN
           ASSIGN i-proximo-vol = volume-ped.nr-volume + 1.
       ELSE
           ASSIGN i-proximo-vol = 1.

       FOR EACH  tt-resto NO-LOCK
           WHERE tt-resto.qtde > 0,
           FIRST item  NO-LOCK
                 WHERE item.it-codigo = tt-resto.it-codigo
           BREAK BY tt-resto.it-codigo
                 BY tt-resto.qtde:

           IF  FIRST-OF(tt-resto.it-codig) THEN DO:
               FIND FIRST volume-ped EXCLUSIVE-LOCK
                   WHERE  volume-ped.cod-estabel = ped-venda.cod-estabel    
                   AND    volume-ped.nome-abrev  = ped-venda.nome-abrev     
                   AND    volume-ped.nr-pedcli   = ped-venda.nr-pedcli      
                   AND    volume-ped.it-codigo   = item.it-codigo
                   AND    volume-ped.nr-volume   = i-proximo-vol NO-ERROR.
               IF  NOT AVAIL volume-ped THEN DO:
                   CREATE volume-ped.
                   ASSIGN volume-ped.cod-estabel  = ped-venda.cod-estabel    
                          volume-ped.nome-abrev   = ped-venda.nome-abrev     
                          volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                          volume-ped.it-codigo    = item.it-codigo
                          volume-ped.nr-volume    = i-proximo-vol
                          volume-ped.varios-itens = YES
                          volume-ped.qtde         = tt-resto.qtde
                          volume-ped.sigla-emb    = c-emb-escolhida.

                   IF l-ativa-log THEN
                       PUT "criacao do volume-nf " volume-ped.nr-volume " "  volume-nf.sigla-emb " " volume-nf.qtde " " volume-nf.it-codigo SKIP.


               END.
           END.
       END.
    END.
    ELSE DO:
        IF avail int-emitente and
            int-emitente.tipo-embalagem <> "" then do:
            find first embalag NO-LOCK
                    WHERE embalag.embalagem = int-emitente.tipo-embalagem 
                    no-error.
            IF AVAIL embalag THEN DO:
               ASSIGN c-emb-escolhida = embalag.sigla-emb
                      de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
               IF int-emitente.tipo-embalagem = "palletMO" THEN
                   ASSIGN de-vol-embalag = de-vol-embalag * 0.865. /* desconsiderar o tamanho da pallet quando Moáambique */
               ELSE
                   IF int-emitente.tipo-embalagem BEGINS "pallet" THEN
                       ASSIGN de-vol-embalag = de-vol-embalag * 0.90. /* desconsiderar o tamanho da pallet para os demais clientes */
                      

            END.
            IF l-ativa-log THEN DO:
                    PUT "Embalagem Escolhida Exportacao =  " c-emb-escolhida SKIP.
            END.
           
        END.
	    else do:
            FOR EACH  embalag NO-LOCK
                WHERE embalag.sigla-emb BEGINS "F"
                BY    embalag.volume:
                ASSIGN c-emb-escolhida = embalag.sigla-emb
                       de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
                       
         
                IF l-ativa-log THEN DO:
                    PUT "MAIOR Embalagem Encontrada QUE COMPORTA PARTE DO FRACIONADO " de-volume-resto  "  embalag.volume  " embalag.volume " " c-emb-escolhida SKIP.
                END.
            END.
        END.
        ASSIGN de-vol-acum = 0
               de-vol-item = 0.
        FOR EACH tt-resto
            WHERE tt-resto.qtde > 0,
            FIRST item FIELDS(it-codigo comprim largura altura peso-bruto peso-liq) NO-LOCK
                  WHERE item.it-codigo = tt-resto.it-codigo
            BREAK BY tt-resto.it-codigo
                  BY tt-resto.qtde:

            REPEAT:

                IF l-ativa-log THEN DO:
                    PUT "antes de gravar volume-nf  do resto " tt-resto.qtde " " tt-resto.it-codigo SKIP.
                END.

                ASSIGN de-qtde-gravada = 0.
                
                DO  i-quantidade = 1 TO tt-resto.qtde:
                    ASSIGN de-vol-item = ((item.altura * item.largura * item.comprim) / 1000000000).
        
                    IF  (de-vol-acum + de-vol-item) > de-vol-embalag THEN DO:                   

                        IF l-ativa-log THEN DO:
                            PUT "antes leave " ITEM.it-codigo " " tt-resto.qtde " " i-quantidade " "  de-vol-acum " + " de-vol-item " > " de-vol-embalag SKIP.
                        END.
                        ASSIGN de-vol-acum   = 0  
                               i-proximo-vol = i-proximo-vol + 1.  
                        LEAVE.
                    END.
                    ELSE DO:
                        FIND FIRST volume-ped EXCLUSIVE-LOCK
                            WHERE  volume-ped.cod-estabel  = ped-venda.cod-estabel    
                            AND    volume-ped.nome-abrev   = ped-venda.nome-abrev     
                            AND    volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                            AND    volume-ped.it-codigo    = item.it-codigo
                            AND    volume-ped.nr-volume    = i-proximo-vol NO-ERROR.
                        IF  NOT AVAIL volume-ped THEN DO:
                            CREATE volume-ped.
                            ASSIGN volume-ped.cod-estabel  = ped-venda.cod-estabel    
                                   volume-ped.nome-abrev   = ped-venda.nome-abrev     
                                   volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                                   volume-ped.it-codigo    = item.it-codigo
                                   volume-ped.nr-volume    = i-proximo-vol
                                   volume-ped.varios-itens = YES.
                        END.
    
                        ASSIGN volume-ped.qtde             = volume-ped.qtde + 1
                               volume-ped.sigla-emb        = c-emb-escolhida.
                        ASSIGN de-vol-acum                 = de-vol-acum + de-vol-item.

                        ASSIGN de-qtde-gravada = de-qtde-gravada + 1.

                        IF l-ativa-log THEN DO:
                            PUT "Gravou volume-nf " volume-ped.nr-volume " " ITEM.it-codigo " " tt-resto.qtde " " i-quantidade " "  de-vol-acum " + " de-vol-item " > " de-vol-embalag  " " c-emb-escolhida SKIP.
                        END.
                               
                    END.
                END.
                
                ASSIGN tt-resto.qtde = tt-resto.qtde - de-qtde-gravada.

                IF l-ativa-log THEN DO:
                    PUT "Resto =  " tt-resto.qtde " " de-vol-acum " " de-qtde-gravada SKIP.
                END.

                IF de-vol-acum > 0 THEN DO:
                    IF tt-resto.qtde <= 0 THEN LEAVE.
                END.
                IF de-vol-acum = 0 AND
                   tt-resto.qtde = 0 THEN LEAVE.

                IF de-vol-acum = 0 AND
                   de-qtde-gravada = 0 AND
                   (tt-resto.qtde = 1 OR
                    de-vol-item > de-vol-embalag) THEN DO:

                    IF l-ativa-log THEN DO:
                       PUT "GERANDO UMA CAIXA SOMENTE -> " TT-RESTO.QTDE " " ITEM.IT-CODIGO  " " de-vol-item " > " de-vol-embalag SKIP.
                    END.
                       FIND FIRST volume-ped EXCLUSIVE-LOCK
                            WHERE  volume-ped.cod-estabel  = ped-venda.cod-estabel    
                            AND    volume-ped.nome-abrev   = ped-venda.nome-abrev     
                            AND    volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                            AND    volume-ped.it-codigo    = item.it-codigo
                            AND    volume-ped.nr-volume    = i-proximo-vol NO-ERROR.
                        IF  NOT AVAIL volume-ped THEN DO:
                            CREATE volume-ped.
                            ASSIGN volume-ped.cod-estabel  = ped-venda.cod-estabel    
                                   volume-ped.nome-abrev   = ped-venda.nome-abrev     
                                   volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                                   volume-ped.it-codigo    = item.it-codigo
                                   volume-ped.nr-volume    = i-proximo-vol
                                   volume-ped.varios-itens = YES
                                   volume-ped.sigla-emb    = c-emb-escolhida.
                        END.
    
                        ASSIGN volume-ped.qtde             = tt-resto.qtde.
                        ASSIGN i-proximo-vol = i-proximo-vol + 1.
                        LEAVE.
                END.
                    

                ASSIGN de-volume-resto = 0.

                FOR EACH b-tt-resto
                    WHERE b-tt-resto.qtde > 0,
                    FIRST b-item NO-LOCK
                    WHERE b-item.it-codigo = b-tt-resto.it-codigo:
                    ASSIGN de-volume-resto = de-volume-resto + (b-tt-resto.qtde * (b-item.altura * b-item.largura * b-item.comprim) / 1000000000).

                    IF l-ativa-log THEN DO:
                        PUT "somando volume do resto " b-tt-resto.qtde " " b-tt-resto.it-codigo " Volume Resto " de-volume-resto " " (b-tt-resto.qtde * (b-item.altura * b-item.largura * b-item.comprim) / 1000000000) SKIP.
                    END.
                END.
                
                IF de-volume-resto = 0 THEN DO:
                    IF l-ativa-log THEN DO:
                        PUT "-------------------------------------------->>>>>>>>>>>>>  DE-VOLUME-RESTO = 0 " SKIP.
                    END.
                    LEAVE.
                END.
                     
                ASSIGN c-emb-escolhida = "".
                IF  avail int-emitente and
                    int-emitente.tipo-embalagem <> "" then do:
                    find first embalag NO-LOCK
                         WHERE embalag.embalagem = int-emitente.tipo-embalagem 
                         no-error.
                    IF AVAIL embalag THEN DO:
                       ASSIGN c-emb-escolhida = embalag.sigla-emb
                              de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
                       IF int-emitente.tipo-embalagem = "palletMO" THEN
                           ASSIGN de-vol-embalag = de-vol-embalag * 0.865. /* desconsiderar o tamanho da pallet quando Moáambique */
                       ELSE
                           IF int-emitente.tipo-embalagem BEGINS "pallet" THEN
                              ASSIGN de-vol-embalag = de-vol-embalag * 0.90. /* desconsiderar o tamanho da pallet para os demais clientes */

                    END.
             
                END.
	            else do:
                    blk_embalagem1:
                    FOR EACH  embalag NO-LOCK
                        WHERE embalag.sigla-emb BEGINS "F"
                        BY    embalag.volume:
                        IF  embalag.volume >= de-volume-resto THEN DO:
                            ASSIGN c-emb-escolhida = embalag.sigla-emb
                                   de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
            
                            IF l-ativa-log THEN DO:
                                PUT "Embalagem Encontrada QUE COMPORTA TODO O FRACIONADO " de-volume-resto  "  embalag.volume  " embalag.volume " " c-emb-escolhida SKIP.
                            END.
                            LEAVE blk_embalagem1.
                        END.
                    END.
                    IF c-emb-escolhida = "" THEN DO:
                        FOR EACH  embalag NO-LOCK
                            WHERE embalag.sigla-emb BEGINS "F"
                            BY    embalag.volume:
                            ASSIGN c-emb-escolhida = embalag.sigla-emb
                                   de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
                     
                            IF l-ativa-log THEN DO:
                                PUT "MAIOR Embalagem Encontrada QUE COMPORTA PARTE DO FRACIONADO " de-volume-resto  "  embalag.volume  " embalag.volume " " c-emb-escolhida SKIP.
                            END.
                        END.
                    END.
                END.
                IF c-emb-escolhida = "" THEN DO:
                        PUT "NAO ENCONTROU NENHUMA CAIXA QUE COMPORTASSE ESTE ITEM " TT-RESTO.QTDE " " ITEM.IT-CODIGO SKIP.
                       FIND FIRST volume-ped EXCLUSIVE-LOCK
                            WHERE  volume-ped.cod-estabel  = ped-venda.cod-estabel    
                            AND    volume-ped.nome-abrev   = ped-venda.nome-abrev     
                            AND    volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                            AND    volume-ped.it-codigo    = item.it-codigo
                            AND    volume-ped.nr-volume    = i-proximo-vol NO-ERROR.
                        IF  NOT AVAIL volume-ped THEN DO:
                            CREATE volume-ped.
                            ASSIGN volume-ped.cod-estabel  = ped-venda.cod-estabel    
                                   volume-ped.nome-abrev   = ped-venda.nome-abrev     
                                   volume-ped.nr-pedcli    = ped-venda.nr-pedcli      
                                   volume-ped.it-codigo    = item.it-codigo
                                   volume-ped.nr-volume    = i-proximo-vol
                                   volume-ped.varios-itens = YES.
                        END.
    
                        ASSIGN volume-ped.qtde             = tt-resto.qtde
                               volume-ped.sigla-emb        = "CX".
                        LEAVE.
                 END.
            END.
        END.
    END.


    IF  lItemBranco THEN DO:
        FIND LAST  volume-ped NO-LOCK
             WHERE volume-ped.cod-estabel = ped-venda.cod-estabel    
               AND volume-ped.nome-abrev  = ped-venda.nome-abrev     
               AND volume-ped.nr-pedcli   = ped-venda.nr-pedcli       NO-ERROR.
        IF  AVAIL  volume-ped THEN
            ASSIGN iNrVol = volume-ped.nr-volume + 1.
        ELSE
            ASSIGN iNrVol = 1.
   
        IF l-ativa-log THEN
           PUT "criou -8- "  SKIP. 
   
        CREATE volume-ped.
        ASSIGN volume-ped.cod-estabel = ped-venda.cod-estabel    
               volume-ped.nome-abrev  = ped-venda.nome-abrev     
               volume-ped.nr-pedcli   = ped-venda.nr-pedcli      
               volume-ped.it-codigo   = ""
               volume-ped.nr-volume   = iNrVol.
    END.

  
   
END PROCEDURE.

PROCEDURE Pi-grava-embalagem.
    /**** O FOR EACH ABAIXO ATUALIZA A EMBALAGEM NOS VOLUMES QUE N«O
          TINHA SIDO IDENTIFICADO O TAMANHO DA MESMA ***********/
    FOR EACH volume-ped
        where volume-ped.cod-estabel = ped-venda.cod-estabel
        AND   volume-ped.nome-abrev  = ped-venda.nome-abrev
        and   volume-ped.nr-pedcli   = ped-venda.nr-pedcli
        AND   volume-ped.sigla-emb   = "":
        ASSIGN volume-ped.sigla-emb = c-emb-escolhida.
    END.

END PROCEDURE.

