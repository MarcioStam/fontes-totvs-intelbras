{esp/es0018.i}
{utp/ut-glob.i}  

{esp/cpp/escpp120att.i}

DEF VAR h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-csv  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-po      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-item-po AS CHARACTER   NO-UNDO.


DEFINE VARIABLE l-claro   AS LOGICAL  INITIAL NO NO-UNDO.
DEFINE VARIABLE c-col-pat AS CHARACTER           NO-UNDO.

DEFINE BUFFER b-item FOR ITEM.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.   

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "escpp120a_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

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
END.


FOR EACH item-ean NO-LOCK 
    WHERE item-ean.it-codigo >= tt-param.cItemIni 
      AND item-ean.it-codigo <= tt-param.cItemFim:

    IF item-ean.operadora = 1 THEN /* CLARO */
         ASSIGN l-claro = YES.                    
END.

IF l-claro THEN
   ASSIGN c-col-pat = ";Pat.Claro".

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

PUT STREAM str-excel UNFORMATTED 
    "Item;Descri‡Æo;Data Imp.;Hora Imp.;C‚lula Nome;N£mero S‚rie;MAC;IMEI;PO;Item Inicial;Item PO;Desc.Item PO;SSID;Senha Wifi;Usu rio Admin;Senha Admin" c-col-pat SKIP. 

FOR EACH  int-etiqueta-5g NO-LOCK
    WHERE int-etiqueta-5g.data      >= DATETIME(tt-param.dDataIni)
      AND int-etiqueta-5g.data      <= DATETIME(MONTH(tt-param.dDataFim), DAY(tt-param.dDataFim), YEAR(tt-param.dDataFim), 23, 59, 59,999)
      AND int-etiqueta-5g.it-codigo >= tt-param.cItemIni
      AND int-etiqueta-5g.it-codigo <= tt-param.cItemFim
      AND (IF tt-param.iPedido > 0 THEN int-etiqueta-5g.num-pedido = tt-param.iPedido ELSE TRUE).

    RUN pi-acompanhar IN h-acomp(INPUT 'Data: ' + string(int-etiqueta-5g.data,"99/99/9999") ).

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = int-etiqueta-5g.it-codigo NO-ERROR.

    ASSIGN c-item-po      = ''
           c-desc-item-po = ''.

    FIND FIRST b-item NO-LOCK
         WHERE b-item.it-codigo = int-etiqueta-5g.it-codigo-po NO-ERROR.

    IF AVAIL b-item THEN
       ASSIGN c-item-po      = b-item.it-codigo
              c-desc-item-po = b-item.desc-item.

    PUT STREAM str-excel UNFORMATTED
        int-etiqueta-5g.it-codigo                                                    ";"
        IF AVAIL ITEM THEN ITEM.desc-item ELSE ""                                    ";"
        date(int-etiqueta-5g.data)                                                   ";"
        STRING(INTEGER(truncate(MTIME(int-etiqueta-5g.data) / 1000, 0)), "HH:MM:SS") ";"
        int-etiqueta-5g.celula-nome                                                  ";"
        int-etiqueta-5g.n-serie                                                      ";"
        int-etiqueta-5g.mac                                                          ";"
        int-etiqueta-5g.cod-imei                                                     ";"
        int-etiqueta-5g.num-pedido                                                   ";"
        int-etiqueta-5g.it-codigo-transf                                             ";"
        c-item-po                                                                    ";"        
        c-desc-item-po                                                               ";"
        int-etiqueta-5g.wifi-ssid                                                    ";"
        int-etiqueta-5g.senha-wifi                                                   ";"
        "admin"                                                                      ";"
        int-etiqueta-5g.senha-adm.

     IF l-claro THEN
        PUT STREAM str-excel UNFORMATTED   ";"
            int-etiqueta-5g.patrimonio.
                                                        
     PUT STREAM str-excel UNFORMATTED "" SKIP.

END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.                                    

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.
