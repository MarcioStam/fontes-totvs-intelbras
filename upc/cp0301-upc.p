/***********************************************************************
**  Programa..: UPC\CP0311-UPC.P
**  Autor.....: Maicon Correa - Sensus
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: Bloqueio/Desbloqueio de Geraá∆o de Ordem para Planejamento - escpp091
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
 
DEF VAR c-objeto  AS CHAR    NO-UNDO.
DEF VAR h-frame   AS HANDLE  NO-UNDO.
DEF VAR h-acomp   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-aux AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-desab          AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-aux            AS INTEGER   NO-UNDO.
DEFINE VARIABLE adm-current-page AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-operacao       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-result-ordem   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-result-oper    AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE r-ord-prod-cp0301-upc AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-frame-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-tela-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-01-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-02-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-03-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-04-cp0301-upc AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-05-cp0301-upc AS HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-integra-MES AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE l-bloqueia-cp0301-upc AS LOGICAL NO-UNDO.

define new global shared var wgh-folder     as handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE c-nome-prog-elimina-op AS CHAR NO-UNDO.

{esp/es0018.i}

 
assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*
MESSAGE p-ind-event SKIP
        p-ind-object SKIP
        p-wgh-object:NAME  SKIP
        c-objeto SKIP
    p-cod-table SKIP
    STRING(p-row-table) SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/    




IF p-ind-event = "DISPLAY" AND
    c-objeto = "v08in271.w" THEN DO:

    ASSIGN r-ord-prod-cp0301-upc = p-row-table
           l-bloqueia-cp0301-upc = FALSE.

    /**/
    
    IF VALID-HANDLE(h-frame-cp0301-upc) THEN DO:

        FOR FIRST ord-prod NO-LOCK
            WHERE rowid(ord-prod) = p-row-table:

            EMPTY TEMP-TABLE tt-prog-ponto.
        
            RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                               INPUT 1,          /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).    
        
            IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                        WHERE entry(1, tt-prog-ponto.conteudo, ";") = ord-prod.cod-estabel
                        AND   entry(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

                IF ord-prod.tipo = 1 THEN 
                    ASSIGN l-bloqueia-cp0301-upc = TRUE.
                ELSE 
                    ASSIGN l-bloqueia-cp0301-upc = FALSE.
                    
                RUN pi-trata-campos (INPUT "bt-elim-faixa,bt-cop,bt-mod,bt-del,bt-reservas,bt-libera,bt-bloqueia",
                                     INPUT h-frame-cp0301-upc).
        
                IF l-bloqueia-cp0301-upc THEN
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Emiss∆o de Ordens Internas est† bloqueada para realizaá∆o do Planejamento. Aguarde liberaá∆o.").
    
            END.

        END.

    END.
    
    /**/

    RUN GET-ATTRIBUTE IN h-tela-cp0301-upc ('Current-Page':U) NO-ERROR.

    IF NOT ERROR-STATUS:ERROR THEN DO:

        ASSIGN adm-current-page = INTEGER(RETURN-VALUE).
        
        RUN pi-atualiza.

    END.
 
END.


IF p-ind-event = "CHOOSE-INTEGRA-MES" THEN DO:

   FIND FIRST ord-prod WHERE rowid(ord-prod) = r-ord-prod-cp0301-upc NO-LOCK NO-ERROR.

   IF AVAIL ord-prod THEN DO:

    
         RUN esapi\esapi030.p (INPUT ord-prod.nr-ord-prod,
                               INPUT 'add',              
                               OUTPUT c-operacao,         
                               OUTPUT c-result-ordem,     
                               OUTPUT c-result-oper). 

      MESSAGE 'Integracao Ordem Prod: ' c-result-ordem SKIP(1)  
              'Integracao Operacao: '   c-result-oper
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

   END.                                               
END.


IF p-ind-event = "initialize" AND
   p-ind-object = 'container' THEN DO:

   ASSIGN h-frame-cp0301-upc = p-wgh-frame
          h-tela-cp0301-upc  = p-wgh-object.

   CREATE BUTTON wh-bt-integra-MES
   ASSIGN FRAME     =  p-wgh-frame
          COL       = 57
          ROW       = 1.17
          WIDTH     = 4.5
          HEIGHT    = 1.15
          TOOLTIP   = 'Integra OP com MES'
          SENSITIVE = TRUE
          VISIBLE   = TRUE
   TRIGGERS:
       ON CHOOSE PERSISTENT RUN upc\cp0301-upc.p (INPUT "CHOOSE-INTEGRA-MES",
                                                  INPUT p-ind-event,
                                                  INPUT p-wgh-object,
                                                  INPUT p-wgh-frame,
                                                  INPUT p-cod-table,
                                                  INPUT p-row-table).
   END TRIGGERS.          

   wh-bt-integra-MES:load-image('image\im-sfc1.bmp').

END.



IF p-ind-event = "after-change-page" AND
    p-ind-object = 'container' THEN DO:

    IF VALID-HANDLE(h-tela-cp0301-upc) THEN DO:

        RUN GET-ATTRIBUTE IN h-tela-cp0301-upc ('Current-Page':U) NO-ERROR.
        ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

        /*MESSAGE 'pagina: ' adm-current-page
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

        /**/

        RUN pi-atualiza.

    END.

END.


IF p-ind-event = "initialize" AND
    c-objeto = 'b15in271.w' THEN DO:

    ASSIGN h-folder-01-cp0301-upc = p-wgh-frame.
    
END.


IF p-ind-event = "initialize" AND
    c-objeto = 'b18in271.w' THEN DO:

    ASSIGN h-folder-02-cp0301-upc = p-wgh-frame.
    
END.


IF p-ind-event = "initialize" AND
    c-objeto = 'b19in271.w' THEN DO:

    ASSIGN h-folder-03-cp0301-upc = p-wgh-frame.
    
END.


IF p-ind-event = "initialize" AND
    c-objeto = 'cp0301-b01.w' THEN DO:

    ASSIGN h-folder-04-cp0301-upc = p-wgh-frame.
    
END.

IF p-ind-event = "DELETE" 
THEN DO:
    ASSIGN c-nome-prog-elimina-op = PROGRAM-NAME(1).
END.

/*IF p-ind-event = "initialize" AND
    c-objeto = 'cp0301-b02.w' THEN DO:

    ASSIGN h-folder-05-cp0301-upc = p-wgh-frame.
   
END.*/

 
return "OK":U.



PROCEDURE pi-atualiza:

    CASE adm-current-page:

        WHEN 1 THEN
            RUN pi-trata-campos (INPUT "bt-eliminar,bt-param,bt-form,bt-simula,bt-alt,bt-pesquisa",
                                 INPUT h-folder-01-cp0301-upc).

        WHEN 2 THEN
            RUN pi-trata-campos (INPUT "bt-eliminar,bt-copia,bt-alternat",
                                 INPUT h-folder-02-cp0301-upc).

        WHEN 3 THEN DO:

            ASSIGN c-desab = "bt-eliminar,bt-gera,bt-consiste".
    
            DO i-aux = 1 TO NUM-ENTRIES(c-desab, ","):
    
                RUN busca-handle(INPUT h-folder-03-cp0301-upc,
                                 INPUT ENTRY(i-aux, c-desab, ","),
                                 OUTPUT h-aux).
        
                IF l-bloqueia-cp0301-upc THEN DO:
                
                    ASSIGN h-aux:VISIBLE = FALSE.
    
                    ASSIGN h-aux:ROW = 2.
        
                    RUN busca-handle(INPUT h-folder-03-cp0301-upc,
                                     INPUT "br-table",
                                     OUTPUT h-aux).
        
                    h-aux:MOVE-TO-TOP().
    
                END.
                ELSE DO:
    
                    ASSIGN h-aux:VISIBLE = TRUE.
    
                    ASSIGN h-aux:ROW = 7.5.
    
                END.
    
            END.

        END.

        WHEN 4 THEN
            RUN pi-trata-campos (INPUT "bt-dividir,bt-unir,bt-encerrar,bt-reabrir",
                                 INPUT h-folder-04-cp0301-upc).


    END CASE.

END PROCEDURE.



PROCEDURE pi-trata-campos:

    DEFINE INPUT PARAMETER p-desab AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-frame AS WIDGET-HANDLE NO-UNDO.
    

    DO i-aux = 1 TO NUM-ENTRIES(p-desab, ","):
        
        RUN busca-handle(INPUT p-frame,
                         INPUT ENTRY(i-aux, p-desab, ","),
                         OUTPUT h-aux).

        IF l-bloqueia-cp0301-upc THEN
            ASSIGN h-aux:VISIBLE = FALSE.
        ELSE
            ASSIGN h-aux:VISIBLE = TRUE.

    END.
    
END PROCEDURE.
 



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


