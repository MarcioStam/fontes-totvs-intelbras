/* -------------------------------------------------------------------------------------------------------------
**  Programa : upc/bas_ccusto_razao-upca-1.p
**  Funcao   : UPC criada para mostrar os movimentos de estoque
**  Autor    : Anderson Silvano - Gestech
**  Data     : 12/2004
**  Altera‡Æo:
**  VersÆo   : 001
-------------------------------------------------------------------------------------------------------------- */
DEFINE BUTTON btGoToOK     LABEL "&OK"       SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON btImprimir   LABEL "&Imprimir" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON btselec      AUTO-GO IMAGE-UP FILE "image/gr-ent.bmp":U LABEL "" SIZE 4 BY 1.
DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.3 BGCOLOR 7.
DEFINE RECTANGLE rtTotal       EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.3 BGCOLOR 8.

DEFINE VARIABLE fiperiodo  AS CHAR FORMAT "99/9999" LABEL "Periodo" VIEW-AS FILL-IN SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE fitotal    AS DEC  FORMAT "->>>,>>>,>>9.9999" LABEL "Total" VIEW-AS FILL-IN SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fidescricao AS CHAR FORMAT "x(2000)" VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL SIZE 65 BY 3 NO-UNDO FONT 1.

DEF NEW GLOBAL SHARED VAR d-data-ini AS DATE FORMAT "99/99/9999".
DEF NEW GLOBAL SHARED VAR d-data-fim AS DATE FORMAT "99/99/9999".

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod_cta_ctbl AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod_ccusto   AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-conta     AS CHAR FORMAT "x(8)" NO-UNDO.
DEF VAR c-sub-conta AS CHAR FORMAT "x(8)" NO-UNDO.
DEF VAR c-periodo   AS CHAR FORMAT "x(8)" NO-UNDO.

DEF VAR d-valor      LIKE movto-estoq.valor-mat-m[1] FORMAT "->>>,>>>,>>9.9999" COLUMN-LABEL "Valor".
DEF VAR c-nome-abrev LIKE emitente.nome-emit         COLUMN-LABEL "Nome Fornec".

DEF VAR d-data           AS DATE FORMAT "99/99/9999".
DEF VAR c-conta-contabil LIKE movto-estoq.conta-contabil. 

DEF TEMP-TABLE tt-movto
    FIELD dt-trans  LIKE movto-estoq.dt-trans 
    FIELD nro-docto LIKE movto-estoq.nro-docto
    FIELD nome-emit LIKE emitente.nome-emit COLUMN-LABEL "Nome Fornec"
    FIELD descricao LIKE movto-estoq.descricao-db
    FIELD valor     LIKE movto-estoq.valor-mat-m[1] FORMAT "->>>,>>>,>>9.9999" COLUMN-LABEL "Valor".

DEFINE QUERY brmovto FOR tt-movto SCROLLING.

/* Browse definitions                                                   */

DEFINE BROWSE brmovto
  QUERY brmovto NO-LOCK DISPLAY
    tt-movto.dt-trans  
    tt-movto.nro-docto 
    tt-movto.nome-emit COLUMN-LABEL "Nome Fornec"
    tt-movto.valor     FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Valor"
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65 BY 11.25 /*15.25*/ FONT 1 EXPANDABLE.

DEFINE FRAME fnumero
        fiperiodo         AT ROW 1.20 COL 23 COLON-ALIGNED
        btselec           AT ROW 1.20 COL 34
        rtGoToFields      AT ROW 1    COL 1
        brmovto           AT ROW 2.75  COL 1
        fidescricao       AT ROW 14.12   COL 1 NO-LABEL
        rttotal           AT ROW 17.12 COL 1
        fitotal           AT ROW 17.35 COL 45
        btGoToOK          AT ROW 18.7  COL 2.14
        btImprimir        AT ROW 18.7  COL 12.14
        rtGoToButton      AT ROW 18.5  COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Faixa de Datas dos Movimentos" FONT 1.

ON  "CHOOSE":U OF btGoToOK IN FRAME fnumero DO:
    APPLY "exit":U TO FRAME fnumero.
END.

ON  "CHOOSE":U OF btImprimir IN FRAME fnumero DO:
     RUN upc/bas_ccusto_razao-upcb.w (INPUT TABLE tt-movto).
END.

ON  "CHOOSE":U OF btSelec IN FRAME fnumero DO:

    ASSIGN c-periodo  = INPUT FRAME fnumero fiperiodo
           d-data-ini = DATE(INT(SUBSTRING(c-periodo,1,2)),01,INT(SUBSTRING(c-periodo,3,4)))
           d-data-fim = DATE(INT(SUBSTRING(c-periodo,1,2)),15,INT(SUBSTRING(c-periodo,3,4))) + 30
           d-data-fim = d-data-fim - INT(DAY(d-data-fim)).

    SESSION:SET-WAIT-STATE("general").

    ASSIGN c-conta     = REPLACE(wh-cod_cta_ctbl:SCREEN-VALUE,".","")
           c-sub-conta = (wh-cod_ccusto:SCREEN-VALUE).

    RUN pi-monta-browse.
    DISP fitotal WITH FRAME fnumero.

    OPEN QUERY brmovto FOR EACH tt-movto.

    SESSION:SET-WAIT-STATE("").
END.

ON 'VALUE-CHANGED':U OF brmovto DO:

    ASSIGN fidescricao = tt-movto.descricao.

    DISP fidescricao
        WITH FRAME fnumero.
END.

PROCEDURE pi-monta-browse.

    FOR EACH tt-movto:
        DELETE tt-movto.
    END.

    ASSIGN fitotal = 0.

    FOR EACH unid_negoc NO-LOCK:

        DO d-data = d-data-ini TO d-data-fim:

            FOR EACH movto-estoq USE-INDEX data-conta /*NO-LOCK*/
                WHERE movto-estoq.dt-trans       = d-data
                AND   movto-estoq.ct-codigo      = c-conta
                AND   movto-estoq.sc-codigo      = c-sub-conta:

                CREATE tt-movto.
                ASSIGN tt-movto.dt-trans  = movto-estoq.dt-trans 
                       tt-movto.nro-docto = movto-estoq.nro-docto
                       tt-movto.valor     = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1])
                       tt-movto.descricao = movto-estoq.descricao-db.
                 
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = movto-estoq.cod-emitente:
                    ASSIGN tt-movto.nome-emit = emitente.nome-emit.
                END.

                ASSIGN fitotal = fitotal + tt-movto.valor.
            END.
        END.

        FIND FIRST tt-movto NO-LOCK NO-ERROR.
        IF AVAIL tt-movto THEN DO:
            ASSIGN fidescricao = tt-movto.descricao.
            DISP fidescricao WITH FRAME fnumero.
        END.
            
    END.

END PROCEDURE.

DISP fiperiodo
     fitotal
     fidescricao
      WITH FRAME fnumero.

ENABLE fiperiodo
       btselec
       btGoToOK
       btImprimir
       brmovto
       WITH FRAME fnumero.

WAIT-FOR "exit":U OF FRAME fnumero.
