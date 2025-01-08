/***********************************************************************
**  Programa..: UPC\CP0301D1-UPC.P
**  Autor.....: Giovane Alves - Gestech
**  Data......: OUTUBRO/2007 - Desenvolvimento
**  Descricao.: Implementação do controle de CDB para Nova
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE r-ord-prod-cp0301-upc AS ROWID NO-UNDO.

DEF VAR c-objeto  AS CHAR            NO-UNDO.

{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE BUFFER b-ord FOR ord-prod.

DEF VAR wh-tipo AS WIDGET-HANDLE NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

          
              /*
MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.
                */ 


IF c-objeto = "v01in535.w" AND
    p-ind-event = "validate" THEN DO:
  
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).    

    FOR FIRST b-ord NO-LOCK
        WHERE ROWID(b-ord) = r-ord-prod-cp0301-upc:
    
        IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                    WHERE entry(1, tt-prog-ponto.conteudo, ";") = b-ord.cod-estabel
                    AND   ENTRY(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

            IF b-ord.tipo = 1 THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17006, 
                                   INPUT "EmissÆo de Ordens Internas est  bloqueada para realiza‡Æo do Planejamento. Aguarde libera‡Æo.").
        
                RETURN "NOK":U.
    
            END.

        END.

    END.

END.

RETURN "OK":U.






PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.

        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
            
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.

        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

        

    END.

END.


