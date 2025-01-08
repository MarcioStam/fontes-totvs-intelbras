/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP061RP 2.00.00.000}
/*------------------------------------------------------------------------
    File        : ESCPP061RP.P
    Purpose     : Relat¢rio de Mac Address Gerados
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Setembro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/cpp/escpp061.i}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/ut-glob.i}  

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-mac-address NO-UNDO LIKE mac-address
    FIELD faixa LIKE mac-address-param.faixa
    INDEX chMacAddress IS PRIMARY
        mac
    INDEX chMacIntel
        faixa
        mac
    INDEX chUnidNegoc
        cod-unid-negoc
        mac
    INDEX chItem
        it-codigo
        mac.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-desc-item      LIKE item.it-codigo             NO-UNDO.
DEFINE VARIABLE c-des-unid-negoc LIKE unid-negoc.des-unid-negoc  NO-UNDO.

DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO FORMAT "x(15)":U LABEL "Destino":U.

DEFINE VARIABLE c-arquivo-csv  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-nome-wifi AS CHARACTER   NO-UNDO.

DEFINE STREAM str-excel.

/* Form Definitions ---                                                 */

FORM tt-mac-address.mac
     tt-mac-address.it-codigo
     tt-mac-address.lote        COLUMN-LABEL "Lote"
     tt-mac-address.cod-estabel COLUMN-LABEL "Estab":U
     tt-mac-address.sequencia
     tt-mac-address.faixa COLUMN-LABEL "Faixa Mac":U
     tt-mac-address.impresso FORMAT "Sim/N∆o":U COLUMN-LABEL "Etiq?":U
     tt-mac-address.usuario
     tt-mac-address.data FORMAT "99/99/99":U
     tt-mac-address.re-impr COLUMN-LABEL "Reimp":U
     tt-mac-address.us-ult-re COLUMN-LABEL "Usuar Reimp":U
     tt-mac-address.dt-ult-re FORMAT "99/99/99":U COLUMN-LABEL "Dt Reimp":U
     tt-mac-address.motiv-re  FORMAT "x(256)":U COLUMN-LABEL "Motivo Reimpress∆o":U VIEW-AS EDITOR SIZE 31 BY 1
    WITH NO-BOX WIDTH 132 DOWN FRAME f-mac-address STREAM-IO.

FORM tt-mac-address.faixa
     SKIP(1)
    WITH WIDTH 132 SIDE-LABELS FRAME f-cabec-faixa STREAM-IO.

FORM tt-mac-address.mac
     tt-mac-address.it-codigo
     tt-mac-address.lote        COLUMN-LABEL "Lote"
     tt-mac-address.cod-estabel COLUMN-LABEL "Estab":U
     tt-mac-address.sequencia
     tt-mac-address.impresso FORMAT "Sim/N∆o":U COLUMN-LABEL "Etiq?":U
     tt-mac-address.usuario
     tt-mac-address.data FORMAT "99/99/99":U
     tt-mac-address.re-impr COLUMN-LABEL "Reimp":U
     tt-mac-address.us-ult-re COLUMN-LABEL "Usuar Reimp":U
     tt-mac-address.dt-ult-re FORMAT "99/99/99":U COLUMN-LABEL "Dt Reimp":U
     tt-mac-address.motiv-re  FORMAT "x(256)":U COLUMN-LABEL "Motivo Reimpress∆o":U VIEW-AS EDITOR SIZE 39 BY 1
    WITH NO-BOX WIDTH 132 DOWN FRAME f-faixa STREAM-IO.

FORM tt-mac-address.cod-unid-negoc " - ":U
     c-des-unid-negoc NO-LABEL
     SKIP(1)
    WITH WIDTH 132 SIDE-LABELS FRAME f-cabec-unid-negoc STREAM-IO.

FORM tt-mac-address.mac
     tt-mac-address.it-codigo
     tt-mac-address.lote        COLUMN-LABEL "Lote"
     tt-mac-address.cod-estabel COLUMN-LABEL "Estab":U
     tt-mac-address.sequencia
     tt-mac-address.faixa COLUMN-LABEL "Faixa Mac":U
     tt-mac-address.impresso FORMAT "Sim/N∆o":U COLUMN-LABEL "Etiq?":U
     tt-mac-address.usuario
     tt-mac-address.data FORMAT "99/99/99":U
     tt-mac-address.re-impr COLUMN-LABEL "Reimp":U
     tt-mac-address.us-ult-re COLUMN-LABEL "Usuar Reimp":U
     tt-mac-address.dt-ult-re FORMAT "99/99/99":U COLUMN-LABEL "Dt Reimp":U
     tt-mac-address.motiv-re  FORMAT "x(256)":U COLUMN-LABEL "Motivo Reimpress∆o":U VIEW-AS EDITOR SIZE 37 BY 1
    WITH NO-BOX WIDTH 132 DOWN FRAME f-unid-negoc STREAM-IO.

FORM tt-mac-address.it-codigo " - ":U
     c-desc-item NO-LABEL
     SKIP(1)
    WITH WIDTH 132 SIDE-LABELS FRAME f-cabec-it-codigo STREAM-IO.

FORM tt-mac-address.mac
     tt-mac-address.lote        COLUMN-LABEL "Lote"
     tt-mac-address.cod-estabel COLUMN-LABEL "Estab":U
     tt-mac-address.sequencia
     tt-mac-address.faixa COLUMN-LABEL "Faixa Mac":U
     tt-mac-address.impresso FORMAT "Sim/N∆o":U COLUMN-LABEL "Etiq?":U
     tt-mac-address.usuario
     tt-mac-address.data FORMAT "99/99/99":U
     tt-mac-address.re-impr COLUMN-LABEL "Reimp":U
     tt-mac-address.us-ult-re COLUMN-LABEL "Usuar Reimp":U
     tt-mac-address.dt-ult-re FORMAT "99/99/99":U COLUMN-LABEL "Dt Reimp":U
     tt-mac-address.motiv-re  FORMAT "x(256)":U COLUMN-LABEL "Motivo Reimpress∆o":U VIEW-AS EDITOR SIZE 39 BY 1
    WITH NO-BOX WIDTH 132 DOWN FRAME f-it-codigo STREAM-IO.

FORM "SELEÄ«O":U                 AT 05 SKIP(1)
     tt-param.mac-ini            COLON 20
     "|< >|":U                   AT 39
     tt-param.mac-fin            AT 45 NO-LABEL SKIP
     tt-param.it-codigo-ini      COLON 20
     "|< >|":U                   AT 39
     tt-param.it-codigo-fin      AT 45 NO-LABEL SKIP(1)
     "CLASSIFICAÄ«O":U           AT 05 SKIP(1)
     tt-param.desc-classif       AT 10 NO-LABEL SKIP(1)
     "PAR∂METRO":U               AT 05 SKIP(1)
     tt-param.desc-param-etiq    AT 10 NO-LABEL SKIP(1)
     "IMPRESS«O":U               AT 05 SKIP(1)
     c-destino                COLON 20 SKIP
     tt-param.arquivo         COLON 20 SKIP
     tt-param.usuario         COLON 20 SKIP
    WITH WIDTH 132 SIDE-LABELS FRAME f-param STREAM-IO.

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Relat¢rio de Mac Address Gerados":U
       c-sistema      = "Espec°ficos Intelbras":U.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U) NO-ERROR.

IF tt-param.destino = 4 THEN
   RUN pi-cabec-csv.

RUN pi-buscar-mac-address IN THIS-PROCEDURE.

IF tt-param.l-param-impr THEN
    RUN pi-imprime-param IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

IF tt-param.destino = 4 THEN DO:
   OUTPUT STREAM str-excel CLOSE.
    
   IF NOT OPSYS = "unix" THEN DO:
      DOS SILENT START /*excel*/ VALUE(c-arq-excel).
   END.                         
END.

{include/i-rpclo.i}

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-buscar-mac-address :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Buscando Informaá‰es...":U).

    EMPTY TEMP-TABLE tt-mac-address.
   
    
    IF tt-param.num-pedido-ini <> 0 THEN DO:
        
        FOR EACH mac-address NO-LOCK
            WHERE mac-address.num-pedido   >= tt-param.num-pedido-ini
              AND mac-address.num-pedido   <= tt-param.num-pedido-fim:

             IF mac-address.it-codigo    < tt-param.it-codigo-ini OR
                mac-address.it-codigo    > tt-param.it-codigo-fin THEN NEXT.  

            IF  mac-address.mac < tt-param.mac-ini OR
                mac-address.mac > tt-param.mac-fin THEN NEXT.
    
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + mac-address.mac + " - Item: ":U + mac-address.it-codigo).
    
            IF tt-param.ind-etiqueta = 2 AND NOT mac-address.impresso THEN NEXT.
    
            IF tt-param.ind-etiqueta = 3 AND mac-address.impresso THEN NEXT.
    
            CREATE tt-mac-address.
            BUFFER-COPY mac-address TO tt-mac-address.
            ASSIGN tt-mac-address.faixa = SUBSTRING(mac-address.mac, 1, 6).
        END.
    END.
    ELSE DO:
        FOR EACH mac-address NO-LOCK
            WHERE mac-address.mac >= tt-param.mac-ini
              AND mac-address.mac <= tt-param.mac-fin:
            
            IF mac-address.num-pedido   < tt-param.num-pedido-ini OR
               mac-address.num-pedido   > tt-param.num-pedido-fim THEN NEXT.

            IF mac-address.it-codigo  < tt-param.it-codigo-ini OR
               mac-address.it-codigo  > tt-param.it-codigo-fin THEN NEXT.
    
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + mac-address.mac + " - Item: ":U + mac-address.it-codigo).
    
            IF tt-param.ind-etiqueta = 2 AND NOT mac-address.impresso THEN NEXT.
    
            IF tt-param.ind-etiqueta = 3 AND mac-address.impresso THEN NEXT.
    
            CREATE tt-mac-address.
            BUFFER-COPY mac-address TO tt-mac-address.
            ASSIGN tt-mac-address.faixa = SUBSTRING(mac-address.mac, 1, 6).
        END.
    END.

    IF CAN-FIND(FIRST tt-mac-address) THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Relat¢rio...":U).

        CASE tt-param.classificacao:
            WHEN 1 THEN
                RUN pi-classif-mac-address IN THIS-PROCEDURE.
            WHEN 2 THEN
                RUN pi-classif-faixa IN THIS-PROCEDURE.
            WHEN 3 THEN
                RUN pi-classif-it-codigo IN THIS-PROCEDURE.
            OTHERWISE
                RUN pi-classif-mac-address IN THIS-PROCEDURE.
        END CASE.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-classif-mac-address :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-mac-address
        BREAK BY tt-mac-address.mac:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + tt-mac-address.mac).

        IF tt-param.destino = 4 THEN
           RUN pi-imprime-csv.
        ELSE
            DISPLAY tt-mac-address.mac
                    tt-mac-address.it-codigo
                    tt-mac-address.lote
                    tt-mac-address.cod-estabel
                    tt-mac-address.sequencia
                    tt-mac-address.faixa
                    tt-mac-address.impresso
                    tt-mac-address.usuario
                    tt-mac-address.data
                    tt-mac-address.re-impr
                    tt-mac-address.us-ult-re
                    tt-mac-address.dt-ult-re
                    tt-mac-address.motiv-re
                WITH FRAME f-mac-address.
            DOWN WITH FRAME f-mac-address.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-classif-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-mac-address
        BREAK BY tt-mac-address.faixa:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + tt-mac-address.mac).

        IF tt-param.destino = 4 THEN
           RUN pi-imprime-csv.
        ELSE
        DO:
            IF FIRST-OF(tt-mac-address.faixa) THEN DO:
                PAGE.
    
                DISPLAY tt-mac-address.faixa
                    WITH FRAME f-cabec-faixa.
            END.
    
            DISPLAY tt-mac-address.mac
                    tt-mac-address.it-codigo
                    tt-mac-address.lote
                    tt-mac-address.cod-estabel
                    tt-mac-address.sequencia
                    tt-mac-address.impresso
                    tt-mac-address.usuario
                    tt-mac-address.data
                    tt-mac-address.re-impr
                    tt-mac-address.us-ult-re
                    tt-mac-address.dt-ult-re
                    tt-mac-address.motiv-re
                WITH FRAME f-faixa.
            DOWN WITH FRAME f-faixa.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
/*
PROCEDURE pi-classif-cod-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-mac-address
        BREAK BY tt-mac-address.cod-unid-negoc:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + tt-mac-address.mac).

        IF FIRST-OF(tt-mac-address.cod-unid-negoc) THEN DO:
            PAGE.

            FIND FIRST unid-negoc
                WHERE unid-negoc.cod-unid-negoc = tt-mac-address.cod-unid-negoc NO-LOCK NO-ERROR.
    
            ASSIGN c-des-unid-negoc = IF AVAILABLE unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.

            DISPLAY tt-mac-address.cod-unid-negoc
                    c-des-unid-negoc
                WITH FRAME f-cabec-unid-negoc.
        END.

        DISPLAY tt-mac-address.mac
                tt-mac-address.it-codigo
                tt-mac-address.cod-estabel
                tt-mac-address.sequencia
                tt-mac-address.faixa
                tt-mac-address.impresso
                tt-mac-address.usuario
                tt-mac-address.data
                tt-mac-address.re-impr
                tt-mac-address.us-ult-re
                tt-mac-address.dt-ult-re
                tt-mac-address.motiv-re
            WITH FRAME f-unid-negoc.
        DOWN WITH FRAME f-unid-negoc.
    END.

    RETURN "OK":U.

END PROCEDURE.
*/
PROCEDURE pi-classif-it-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-mac-address
        BREAK BY tt-mac-address.it-codigo:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mac: ":U + tt-mac-address.mac).

        IF tt-param.destino = 4 THEN
           RUN pi-imprime-csv.
        ELSE
        DO: 
            IF FIRST-OF(tt-mac-address.it-codigo) THEN DO:
                PAGE.
    
                FIND FIRST item
                    WHERE item.it-codigo = tt-mac-address.it-codigo NO-LOCK NO-ERROR.
        
                ASSIGN c-desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.
    
                DISPLAY tt-mac-address.it-codigo
                        c-desc-item
                    WITH FRAME f-cabec-it-codigo.
            END.
    
            DISPLAY tt-mac-address.mac
                    tt-mac-address.lote
                    tt-mac-address.cod-estabel
                    tt-mac-address.sequencia
                    tt-mac-address.faixa
                    tt-mac-address.impresso
                    tt-mac-address.usuario
                    tt-mac-address.data
                    tt-mac-address.re-impr
                    tt-mac-address.us-ult-re
                    tt-mac-address.dt-ult-re
                    tt-mac-address.motiv-re
                WITH FRAME f-it-codigo.
            DOWN WITH FRAME f-it-codigo.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN DO:
        RUN pi-seta-titulo IN h-acomp (INPUT "Finalizando Relat¢rio...":U).
        RUN pi-acompanhar IN h-acomp (INPUT "Finalizando":U).
    END.

    CASE tt-param.destino:
        WHEN 1 THEN
            ASSIGN c-destino = "Impressora":U.
        WHEN 2 THEN
            ASSIGN c-destino = "Arquivo":U.
        WHEN 3 THEN
            ASSIGN c-destino = "Terminal":U.
        OTHERWISE
            ASSIGN c-destino = "":U.
    END CASE.

    PAGE.

    DISPLAY tt-param.mac-ini
            tt-param.mac-fin
            tt-param.it-codigo-ini
            tt-param.it-codigo-fin
            tt-param.desc-classif
            tt-param.desc-param-etiq
            c-destino
            tt-param.arquivo
            tt-param.usuario
        WITH FRAME f-param.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cabec-csv:

    ASSIGN c-arquivo-csv = "escpp061_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
     
    IF tt-param.destino = 4 THEN DO:
        OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
        PUT STREAM str-excel UNFORMATTED 
            "Item;Descriá∆o;MAC;Data MAC;Hora MAC;CÇlula Nome;N£mero SÇrie;PO;SSID;Senha Wifi;Usu†rio Admin;Senha Admin" SKIP. 
    END.

END PROCEDURE.

PROCEDURE pi-imprime-csv:
    
    FIND FIRST ITEM WHERE item.it-codigo = tt-mac-address.it-codigo NO-LOCK NO-ERROR. 

    FIND FIRST num-serie WHERE num-serie.n-serie = tt-mac-address.n-serie NO-LOCK NO-ERROR.

    FIND FIRST item-ean WHERE item-ean.it-codigo = tt-mac-address.it-codigo NO-LOCK NO-ERROR. 
    
    ASSIGN c-nome-wifi = ''.

    IF AVAIL item-ean THEN DO:
        IF item-ean.operadora = 1 THEN /* CLARO */
           ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + UPPER(SUBSTRING(tt-mac-address.mac,7,6)).
        ELSE
           ASSIGN c-nome-wifi = CAPS(TRIM(item-ean.texto[5])) + '_' + LOWER(SUBSTRING(tt-mac-address.mac,9,4)).
    END.

    PUT STREAM str-excel UNFORMATTED
        tt-mac-address.it-codigo                                                    ";"
        IF AVAIL ITEM THEN ITEM.desc-item ELSE ""                                   ";"
        tt-mac-address.mac                                                          ";"
        date(tt-mac-address.data)                                                   ";"
        STRING(INTEGER(truncate(MTIME(tt-mac-address.data) / 1000, 0)), "HH:MM:SS") ";"
        IF AVAIL num-serie THEN num-serie.sigla ELSE ""                             ";"
        tt-mac-address.n-serie                                                      ";"
        tt-mac-address.num-pedido                                                   ";"
        
        c-nome-wifi                                                                 ";"
        tt-mac-address.char-1                                                       ";"
        "admin"                                                                     ";"
        tt-mac-address.char-2 SKIP.                  


END PROCEDURE.
