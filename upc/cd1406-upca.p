/***********************************************************************
**  Programa..: UPC\CD1406-UPCA.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: Outubro/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 04/10/2005
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR gr-requisicao    AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBrowse         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtEliminar     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whFrame          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whQuery          AS WIDGET-HANDLE NO-UNDO.

DEF VAR i-cont              AS INT.
DEF VAR rw-it-requisicao    AS ROWID         NO-UNDO.

IF NOT whBtEliminar:SENSITIVE THEN DO:
    MESSAGE "N∆o Ç possivel a inclus∆o de estrutura"
        VIEW-AS ALERT-BOX error BUTTONS OK.
    RETURN NO-APPLY.
END.

ASSIGN i-cont = 0. 

FOR FIRST requisicao NO-LOCK
    WHERE ROWID(requisicao) = gr-requisicao,    
    EACH it-requisicao OF requisicao NO-LOCK:
    ASSIGN i-cont           = i-cont + 1
           rw-it-requisicao = ROWID(it-requisicao).
END.

IF i-cont = 0 THEN DO:
    MESSAGE "N∆o Ç possivel a inclus∆o de estrutura"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
END.

IF i-cont > 1 THEN DO:
    MESSAGE "Inclus∆o de estrutura cancelada. H† mais de um item cadastrado na requisiá∆o."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
END.

DEF BUFFER bf-it-requisicao FOR it-requisicao.

DEF TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo     LIKE item.it-codigo
    FIELD quantidade    LIKE estrutura.quant-usada
    FIELD un            LIKE item.un.

DEF VAR de-quantidade AS DEC.
DEF VAR i-sequencia   AS INT.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE d-quant-usada AS DECIMAL FORMAT "->>,>>9.9999999999" INITIAL 1 
     LABEL "Quantidade":R12 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64.14 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.14 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fEstrutura
     c-it-codigo AT ROW 1.75 COL 24 COLON-ALIGNED
     d-quant-usada AT ROW 2.75 COL 24 COLON-ALIGNED HELP
          "Quantidade bruta utilizada do componente"
     Btn_OK AT ROW 4.92 COL 2
     Btn_Cancel AT ROW 4.92 COL 14
     RECT-1 AT ROW 4.63 COL 1
     RECT-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Inclus∆o Estrutura"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

ON 'CHOOSE':U OF Btn_OK IN FRAME fEstrutura DO:

    EMPTY TEMP-TABLE tt-itens.

    FIND FIRST it-requisicao 
        WHERE ROWID(it-requisicao) = rw-it-requisicao NO-ERROR.
    IF AVAIL it-requisicao THEN DO:
        
        FOR EACH estrutura FIELDS(it-codigo data-inicio data-termino es-codigo quant-usada it-codigo) NO-LOCK
           WHERE estrutura.it-codigo     = it-requisicao.it-codigo
             AND estrutura.data-inicio  <= TODAY
             AND estrutura.data-termino  > TODAY:
                
                FIND ITEM NO-LOCK
                    WHERE item.it-codigo = estrutura.es-codigo.
                IF item.compr-fabr = 1 THEN DO:   
                   
                  FIND FIRST tt-itens 
                       WHERE tt-itens.it-codigo = estrutura.es-codigo NO-ERROR.
                  IF NOT AVAIL tt-itens THEN DO:
                    CREATE tt-itens.
                    ASSIGN tt-itens.it-codigo  = estrutura.es-codigo
                           tt-itens.un         = ITEM.un
                           tt-itens.quantidade = 0.
                  END.
                  ASSIGN tt-itens.quantidade = tt-itens.quantidade + (estrutura.quant-usada * INPUT FRAME fEstrutura d-quant-usada).
                END.
                ELSE DO:
                    ASSIGN de-quantidade = INPUT FRAME fEstrutura d-quant-usada.
                    RUN pi-estrutura (estrutura.es-codigo, de-quantidade).
                END.
        END.
     
        ASSIGN i-sequencia = 0.

        FOR EACH tt-itens:
            ASSIGN i-sequencia = i-sequencia + 10.

            CREATE bf-it-requisicao.
            ASSIGN bf-it-requisicao.it-codigo       = tt-itens.it-codigo 
                   bf-it-requisicao.sequencia       = i-sequencia 
                   bf-it-requisicao.qt-requisitada  = tt-itens.quantidade
                   bf-it-requisicao.qt-a-atender    = tt-itens.quantidade. 
            BUFFER-COPY it-requisicao EXCEPT it-codigo sequencia qt-requisitada qt-a-atender TO bf-it-requisicao.
        END.
        
        DELETE it-requisicao.
    END.
END.

ON 'GO':U OF FRAME fEstrutura DO:
    DEF VAR rw-requisicao AS ROWID.

    ASSIGN rw-requisicao = gr-requisicao.

    FIND FIRST requisicao NO-LOCK NO-ERROR.
    RUN pi-reposiciona-query IN whQuery (ROWID(requisicao)).

    FIND FIRST requisicao 
        WHERE ROWID(requisicao) = rw-requisicao NO-LOCK NO-ERROR.
    RUN pi-reposiciona-query IN whQuery (ROWID(requisicao)).
END.

FIND FIRST it-requisicao NO-LOCK
    WHERE ROWID(it-requisicao) = rw-it-requisicao NO-ERROR.
IF AVAIL it-requisicao THEN 
    ASSIGN c-it-codigo   = it-requisicao.it-codigo
           d-quant-usada = it-requisicao.qt-requisitada.

DISPLAY c-it-codigo d-quant-usada 
  WITH FRAME fEstrutura.
ENABLE d-quant-usada Btn_OK Btn_Cancel RECT-1 RECT-2 
  WITH FRAME fEstrutura.

WAIT-FOR "GO" OF FRAME fEstrutura.

PROCEDURE pi-estrutura:

DEF INPUT PARAM p-it-codigo     LIKE ITEM.it-codigo. 
DEF INPUT PARAM p-quantidade    AS DEC.

    FOR EACH estrutura FIELDS(it-codigo data-inicio data-termino es-codigo quant-usada it-codigo) NO-LOCK
       WHERE estrutura.it-codigo     = p-it-codigo
         AND estrutura.data-inicio  <= TODAY
         AND estrutura.data-termino  > TODAY:

            FIND ITEM NO-LOCK
                WHERE item.it-codigo = estrutura.es-codigo.
            IF ITEM.compr-fabr = 1 THEN DO:   

              FIND FIRST tt-itens 
                   WHERE tt-itens.it-codigo = estrutura.es-codigo NO-ERROR.
              IF NOT AVAIL tt-itens THEN DO:
                CREATE tt-itens.
                ASSIGN tt-itens.it-codigo  = estrutura.es-codigo
                       tt-itens.un         = ITEM.un
                       tt-itens.quantidade = 0.
              END.
              ASSIGN tt-itens.quantidade = tt-itens.quantidade + (estrutura.quant-usada * p-quantidade).
            END.
            ELSE DO:
                ASSIGN de-quantidade = (estrutura.quant-usada * p-quantidade).
                RUN pi-estrutura (estrutura.es-codigo, de-quantidade).
            END.
    END.

END PROCEDURE.
