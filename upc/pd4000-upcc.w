/***********************************************************************
**  Programa..: UPC/PD4000-UPCC.W
**  Autor.....: Robson Jeorge Moser - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Tela criada para armazenar as informaá‰es referente ao
                c†lculo de comiss∆o do representante.
                (n£mero de parcelas, valor de serviáo instalaá∆o,
                c¢digo fornecedor do serviáo instalaá∆o e 
                desconta serviáo instalaá∆o).

**  Vers∆o....: 001 26/12/2004
**              Desenvolvimento Programa
************************************************************************/


DEF NEW GLOBAL SHARED VAR whbtAddServInst     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddServInst-new AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whPedCli            AS WIDGET-HANDLE NO-UNDO.
DEF VAR v-cod-classificador-aux LIKE ped-repre.cod-classificador.

DEF VAR cReturn         AS CHAR                         NO-UNDO.

DEFINE BUTTON BtCancela AUTO-END-KEY DEFAULT 
     LABEL "Cancela" 
     SIZE 12 BY 0.88
     BGCOLOR 8 .

DEFINE BUTTON BtOK AUTO-GO DEFAULT 
     LABEL "Salva" 
     SIZE 12 BY 0.88
     BGCOLOR 8 .

/*
DEFINE VARIABLE vl-comiss∆o AS DECIMAL FORMAT ">9":U INITIAL 0 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 0.88 NO-UNDO.
*/

DEFINE VARIABLE vl-comissao AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Comiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 0.88 NO-UNDO.

DEFINE VARIABLE vl-servico AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Serviáo Instalaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 0.88 NO-UNDO.

/*
DEFINE VARIABLE i-cod-fornecedor-serv-inst AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢d. Fornec. Serv. Instalaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 0.88 NO-UNDO.


DEFINE VARIABLE l-desc-serv-inst AS LOGICAL INITIAL no 
     LABEL "Desconta Serv Instalaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.
*/

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame1
     /*d-parcela                  AT ROW 1.25 COL 22 COLON-ALIGNED*/
     vl-comissao            AT ROW 1.25 COL 20 COLON-ALIGNED
     vl-servico             AT ROW 2.25 COL 20 COLON-ALIGNED
     /*i-cod-fornecedor-serv-inst AT ROW 3.25 COL 22 COLON-ALIGNED
     l-desc-serv-inst           AT ROW 4.25 COL 22 COLON-ALIGNED
     */
     BtOK                       AT ROW 4 COL 2
     BtCancela                  AT ROW 4 COL 25
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
          THREE-D SCROLLABLE TITLE "Comiss∆o Revenda" FONT 1
          DEFAULT-BUTTON BtOK CANCEL-BUTTON BtCancela.

    /*
    FIND FIRST ped-repre NO-LOCK                                    WHERE
               ped-repre.nr-pedido   = int(whPedCli:SCREEN-VALUE)   AND
               ped-repre.nome-ab-rep = whbtAddServInst:SCREEN-VALUE NO-ERROR.
    IF AVAIL ped-repre THEN
        ASSIGN v-cod-classificador-aux = ped-repre.cod-classificador.
    */


    /* L¢gica para inicializaá∆o da tela */
    FIND ped-venda
         WHERE ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE)
         NO-LOCK NO-ERROR.
    FIND FIRST mgesp.int-ped-venda NO-LOCK                                WHERE
               int-ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) and
               int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
    IF AVAIL int-ped-venda THEN DO:
        vl-comissao:SCREEN-VALUE IN FRAME frame1 = string(int-ped-venda.vl-comis-distrib).
        vl-servico:SCREEN-VALUE IN FRAME frame1  = string(int-ped-venda.vl-serv-inst).
    END.
    ELSE DO:
        vl-comissao:SCREEN-VALUE IN FRAME frame1 = "".
        vl-servico:SCREEN-VALUE IN FRAME frame1  = "".
    END.
    /* L¢gica para inicializaá∆o da tela */


    /*
        FIND FIRST int-ped-repre NO-LOCK                                          WHERE
                   int-ped-repre.nr-pedido         = int-ped-venda.nr-pedido      AND
                   int-ped-repre.nome-ab-rep       = whbtAddServInst:SCREEN-VALUE AND
                   int-ped-repre.cod-classificador = v-cod-classificador-aux      NO-ERROR.
        IF AVAIL int-ped-repre THEN DO:
            ASSIGN /*d-parcela:SCREEN-VALUE IN FRAME frame1                  = string(int-ped-repre.parcela) */
                   vl-comissao:SCREEN-VALUE IN FRAME frame1           = string(int-ped-venda.vl-comis-distrib)
                   vl-servico:SCREEN-VALUE IN FRAME frame1            = string(int-ped-venda.vl-serv-inst).

                   /*i-cod-fornecedor-serv-inst:SCREEN-VALUE IN FRAME frame1 = string(int-ped-venda.cod-fornec-serv-inst)
                   l-desc-serv-inst:SCREEN-VALUE IN FRAME frame1           = string(int-ped-repre.log-desc-serv-inst).*/
        END.
        ELSE DO:
            ASSIGN /*d-parcela                                               = 0
                   l-desc-serv-inst                                        = NO */
                   vl-comissao:SCREEN-VALUE IN FRAME frame1           = string(int-ped-venda.vl-comis-distrib)
                   vl-servico:SCREEN-VALUE IN FRAME frame1            = string(int-ped-venda.vl-serv-inst).
                  /* i-cod-fornecedor-serv-inst:SCREEN-VALUE IN FRAME frame1 = string(int-ped-venda.cod-fornec-serv-inst).*/
        END.
    END.    
    */
    
    


    /* Eventos */
    ON END-ERROR OF FRAME frame1
    OR ENDKEY OF FRAME frame1 ANYWHERE DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
    END.


    ON "CHOOSE":U OF BtOK IN FRAME frame1 DO:
        DEF VAR v-cod-classificador-aux-1 LIKE ped-repre.cod-classificador.
        
        FIND FIRST ped-venda EXCLUSIVE-LOCK                         
             WHERE ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) 
               AND (ped-venda.cod-sit-ped = 3 OR ped-venda.cod-sit-ped = 6) NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            IF ped-venda.cod-sit-ped = 3 THEN
                MESSAGE "Pedido atendido totalmente" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ELSE
                MESSAGE "Pedido cancelado" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
        END.

        FIND FIRST ped-venda EXCLUSIVE-LOCK                         
             WHERE ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) NO-ERROR.

        FIND FIRST mgesp.int-ped-venda EXCLUSIVE-LOCK                         
             WHERE int-ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) 
               AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.

        IF NOT AVAIL int-ped-venda THEN DO:
            CREATE mgesp.int-ped-venda.
            ASSIGN int-ped-venda.nr-pedido         = int(whPedCli:SCREEN-VALUE) 
                   int-ped-venda.vl-comis-distrib  = dec(vl-comissao:SCREEN-VALUE)
                   int-ped-venda.vl-serv-inst      = dec(vl-servico:SCREEN-VALUE)
                   int-ped-venda.cod-estabel       = ped-venda.cod-estabel.
        END.
        ELSE DO:
            ASSIGN int-ped-venda.vl-comis-distrib  = dec(vl-comissao:SCREEN-VALUE)
                   int-ped-venda.vl-serv-inst      = dec(vl-servico:SCREEN-VALUE).
        END.
        
        RELEASE int-ped-venda.
        SESSION:SET-WAIT-STATE("general":U).
        SESSION:SET-WAIT-STATE("":U).
        IF cReturn = "nok" THEN 
            RETURN NO-APPLY.
        APPLY "GO":U TO FRAME frame1.
    END.


    /**  Maria Ester - 05/04/2004
    /* Validaá‰es para tela de Serviáo Instalaá∆o */
    IF int(i-cod-fornecedor-serv-inst:SCREEN-VALUE) <> 0 THEN DO:
       IF int(i-cod-fornecedor-serv-inst:SCREEN-VALUE) < 50000 THEN DO:
          MESSAGE "Informe um C¢digo Fornecedor Serviáo Instalaá∆o igual ou superior a 50.000!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN NO-APPLY.
       END.
    
       FIND FIRST repres NO-LOCK
           WHERE repres.cod-rep = int(i-cod-fornecedor-serv-inst:SCREEN-VALUE) NO-ERROR.
       IF NOT AVAIL repres THEN DO:
           MESSAGE "C¢digo Fornecedor Serviáo Instalaá∆o Inv†lido!" SKIP
                   "Verifique um c¢digo v†lido no cadastro de Representante." 
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN NO-APPLY.
       END.
    END.
    ****/

    /* L¢gica para atualizaá∆o das tabelas int-ped-venda e int-ped-repre */
    /*
    FIND FIRST ped-repre NO-LOCK                                    WHERE
               ped-repre.nr-pedido   = int(whPedCli:SCREEN-VALUE)   AND
               ped-repre.nome-ab-rep = whbtAddServInst:SCREEN-VALUE NO-ERROR.
    IF AVAIL ped-repre THEN
        ASSIGN v-cod-classificador-aux-1 = ped-repre.cod-classificador.
    */



    /*
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK WHERE
               int-ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) NO-ERROR.
    IF AVAIL int-ped-venda THEN DO:
        FIND FIRST int-ped-repre EXCLUSIVE-LOCK                                   WHERE
                   int-ped-repre.nr-pedido         = int-ped-venda.nr-pedido      AND
                   int-ped-repre.nome-ab-rep       = whbtAddServInst:SCREEN-VALUE AND
                   int-ped-repre.cod-classificador = v-cod-classificador-aux-1    NO-ERROR.
        IF AVAIL int-ped-repre THEN DO:
            ASSIGN int-ped-repre.parcela              = int(d-parcela:SCREEN-VALUE)
                   int-ped-venda.vl-comis-distrib         = dec(d-vlr-serv-inst:SCREEN-VALUE)
                   /*int-ped-venda.cod-fornec-serv-inst = int(i-cod-fornecedor-serv-inst:SCREEN-VALUE)*/
                   int-ped-repre.log-desc-serv-inst   = logical(l-desc-serv-inst:SCREEN-VALUE).
        END.
        ELSE DO:
            CREATE int-ped-repre.
            ASSIGN int-ped-repre.nr-pedido          = int(whPedCli:SCREEN-VALUE)
                   int-ped-repre.nome-ab-rep        = whbtAddServInst:SCREEN-VALUE
                   int-ped-repre.cod-classificador  = v-cod-classificador-aux-1
                   int-ped-repre.parcela            = int(d-parcela:SCREEN-VALUE)
                   int-ped-repre.log-desc-serv-inst = logical(l-desc-serv-inst:SCREEN-VALUE).
        END.
    END.
    */

    ENABLE vl-servico vl-comissao BtOK BtCancela WITH FRAME frame1.

    WAIT-FOR "GO":U OF FRAME frame1.



