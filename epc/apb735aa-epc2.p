DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-pagto-orig AS WIDGET-HANDLE NO-UNDO.

def new global shared var v_rec_lote_pagto
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

{esp/es0018.i}
DEF TEMP-TABLE tt-portador NO-UNDO
    FIELD portador AS CHAR 
    FIELD carteira AS CHAR.

FIND lote_pagto NO-LOCK
    WHERE RECID(lote_pagto) = v_rec_lote_pagto NO-ERROR.
IF NOT AVAIL lote_pagto 
THEN DO:
     MESSAGE "Lote de pagamento n∆o localizado!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

/************** Desconsiderar determinados portadores/carteira ****************/
DEF VAR c-lista-portador AS CHAR FORMAT "X(300)" NO-UNDO.
DEF VAR i                AS INTEGER.
DEF VAR c-carteira       AS CHAR NO-UNDO.
DEF VAR c-portador       AS CHAR NO-UNDO.
DEF VAR c-aux            AS CHAR NO-UNDO.
DEF VAR i-position       AS INTEGER NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.
EMPTY TEMP-TABLE tt-portador.

RUN esp/es0018p.p (INPUT  "esesb010a":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto.
IF  AVAIL tt-prog-ponto THEN
    ASSIGN c-lista-portador = tt-prog-ponto.conteudo.

DO  i = 1 TO NUM-ENTRIES(c-lista-portador, ";"):

    ASSIGN c-aux      = ENTRY(i, c-lista-portador, ";")
           i-position = INDEX(c-aux, "-").

    ASSIGN c-portador = ""
           c-carteira = "".

    IF  length(c-aux) > 0 THEN DO:
    
        ASSIGN c-portador = SUBSTRING(c-aux, 1, i-position - 1)
               c-carteira = SUBSTRING(c-aux, i-position + 1, LENGTH(c-aux)).

        CREATE tt-portador.
        ASSIGN tt-portador.portador = c-portador
               tt-portador.carteira = c-carteira.
    END.

END.
/********************************************************************************/

FOR EACH item_lote_liquidac_acr OF lote_pagto NO-LOCK:

    IF CAN-FIND(tt-portador
          WHERE tt-portador.portador = item_lote_liquidac_acr.cod_portador
            AND tt-portador.carteira = item_lote_liquidac_acr.cod_cart_bcia) 
    THEN DO:
         MESSAGE "Portador e carteira do t°tulo n∆o permitem Encontro de Contas: " SKIP
                 "Seq: "      STRING(item_lote_liquidac_acr.num_seq_refer) SKIP
                 "Est: "      item_lote_liquidac_acr.cod_estab             SKIP
                 "Cliente: "  STRING(item_lote_liquidac_acr.cdn_cliente)   SKIP
                 "Esp: "      item_lote_liquidac_acr.cod_espec_docto       SKIP
                 "Ser: "      item_lote_liquidac_acr.cod_ser_docto         SKIP
                 "Titulo: "   item_lote_liquidac_acr.cod_tit_acr           SKIP
                 "Parc: "     item_lote_liquidac_acr.cod_parcela           SKIP
                 "Portador: " item_lote_liquidac_acr.cod_portador          SKIP
                 "Carteira: " item_lote_liquidac_acr.cod_cart_bcia 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN.
    END.

END.

/* Localizar bot∆o do produto padr∆o e aplicar choose */
APPLY 'CHOOSE':U TO wh-bt-pagto-orig.
