/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
/*{utp/ut-glob.i}*/

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE c-char AS   CHAR.

def new global shared VAR c-unidneg-ini-ft0803b  as character no-undo. 
def new global shared VAR c-unidneg-fim-ft0803b  as character no-undo. 

def new global shared VAR h-upc-ft0803b     as widget-handle no-undo. 

define new global shared var wb-browse-ft0803b       as widget-handle no-undo.
define new global shared var wb-detalhar-ft0803b     as widget-handle no-undo.
define new global shared var wb-selecao-ft0803b      as widget-handle no-undo.
define new global shared var wb-selecao-ft0803b-new  as widget-handle no-undo.

def new global shared var gl-tela-habilitada        as log no-undo.
def new global shared var gl-mostra-registro        as log no-undo.

def var wghQuery             as widget-handle no-undo.
def var wghBuffer            as widget-handle no-undo.

def var hColumnnr-nota       as widget-handle no-undo.
def var hColumnnr-serie      as widget-handle no-undo.
def var hColumnnr-estab      as widget-handle no-undo.

DEF VAR i-cont              AS INT.
DEF VAR i-ult-linha-elimin  AS INT.
DEF VAR l-eliminou          AS LOG.

DEF VAR r-rowid-first-receb AS ROWID NO-UNDO.

function valida-registro return logical ().

    IF CAN-FIND(FIRST unid-neg-fat NO-LOCK
                WHERE unid-neg-fat.cod-estabel    = hColumnnr-estab:buffer-value
                 AND unid-neg-fat.serie           = hColumnnr-serie:buffer-value
                 AND unid-neg-fat.nr-nota-fis     = hColumnnr-nota:BUFFER-VALUE) THEN DO:
        FIND FIRST unid-neg-fat NO-LOCK
             WHERE unid-neg-fat.cod-estabel     = hColumnnr-estab:buffer-value
               AND unid-neg-fat.serie           = hColumnnr-serie:buffer-value
               AND unid-neg-fat.nr-nota-fis     = hColumnnr-nota:BUFFER-VALUE
               AND unid-neg-fat.cod_unid_negoc >= c-unidneg-ini-ft0803b
               AND unid-neg-fat.cod_unid_negoc <= c-unidneg-fim-ft0803b NO-ERROR.
        IF AVAIL unid-neg-fat THEN DO:
            ASSIGN gl-mostra-registro = YES.
        END.
        ELSE ASSIGN gl-mostra-registro = NO.
    END.
    ELSE ASSIGN gl-mostra-registro = YES.

    return gl-mostra-registro.
    
end function.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*MESSAGE "p-ind-event " p-ind-event  skip
        "c-char   " c-char     SKIP
        "p-ind-object" p-ind-object skip
        "p-wgh-object" p-wgh-object skip
        "p-wgh-frame " p-wgh-frame  skip
        "p-cod-table " p-cod-table  skip
        "p-row-table " string(p-row-table) SKIP
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/



if  p-ind-object = "CONTAINER"  and
    p-ind-event  = "INITIALIZE" then  DO:

    assign gl-tela-habilitada = yes
           c-unidneg-ini-ft0803b = ""
           c-unidneg-fim-ft0803b = "zzz".
END.
    

if  p-ind-object = "CONTAINER" and
    p-ind-event  = "DESTROY"   then 
    assign gl-tela-habilitada = no.

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    RUN upc/ft0803b-upc.p PERSISTENT SET h-upc-ft0803b(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table). 
END.

if  p-ind-object = "BROWSER"          and
    p-ind-event  = "AFTER-OPEN-QUERY" and
    c-char       = "dibrw\b06di135.w" AND
    gl-tela-habilitada = yes      then do:

    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'button':U,
                         input 'bt-selecao':U,
                         input no,
                         output wb-selecao-ft0803b).

    CREATE BUTTON wb-selecao-ft0803b-new
    ASSIGN FRAME     = p-wgh-frame
           WIDTH     = wb-selecao-ft0803b:WIDTH
           HEIGHT    = wb-selecao-ft0803b:HEIGHT
           ROW       = wb-selecao-ft0803b:ROW 
           COL       = wb-selecao-ft0803b:COL 
           TOOLTIP   = wb-selecao-ft0803b:TOOLTIP
           LABEL     = wb-selecao-ft0803b:LABEL
           FONT      = wb-selecao-ft0803b:FONT
           VISIBLE   = wb-selecao-ft0803b:VISIBLE
           SENSITIVE = wb-selecao-ft0803b:SENSITIVE.
    ON 'choose' OF wb-selecao-ft0803b-new PERSISTENT RUN pi-choose-bt-selecao IN h-upc-ft0803b.

    IF VALID-HANDLE(wb-selecao-ft0803b-new) THEN
        assign wb-selecao-ft0803b-new:SENSITIVE   = wb-selecao-ft0803b:sensitive   
               wb-selecao-ft0803b:VISIBLE         = NO.

    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'browse':U,
                         input 'br-table':U,
                         input no,
                         output wb-browse-ft0803b).
    
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'button':U,
                         input 'bt-detalhar':U,
                         input no,
                         output wb-detalhar-ft0803b).

    assign wghQuery             = wb-browse-ft0803b:query
           wghBuffer            = wghQuery:get-buffer-handle(1)
           hColumnnr-nota       = wghBuffer:buffer-field("nr-nota-fis")
           hColumnnr-serie      = wghBuffer:buffer-field("serie")
           hColumnnr-estab      = wghBuffer:buffer-field("cod-estabel").

    if  valid-handle(wghQuery)  and
        wb-browse-ft0803b:visible = yes then do:

        wghQuery:GET-FIRST no-error.

        ASSIGN i-cont              = 0
               r-rowid-first-receb = ?.

        REPEAT WHILE NUM-RESULTS(wghQuery:NAME) > 0 
                 AND NUM-RESULTS(wghQuery:NAME) <> ?:

            IF  l-eliminou THEN
                ASSIGN i-cont = i-ult-linha-elimin.
            ELSE
                ASSIGN i-cont = i-cont + 1.

            IF i-cont = 1 THEN
                ASSIGN r-rowid-first-receb = wghBuffer:ROWID.

            IF  i-cont > num-results(wghQuery:name) THEN
                LEAVE.

            if  not valida-registro() then do:

                IF  i-cont > 11 THEN
                    wghQuery:REPOSITION-TO-ROWID(wghBuffer:ROWID) NO-ERROR.
                ELSE
                    wb-browse-ft0803b:select-row(i-cont) NO-ERROR.

                wb-browse-ft0803b:delete-selected-rows() NO-ERROR.

                /* reinicia a verificacao */
                ASSIGN i-ult-linha-elimin = i-cont
                       l-eliminou         = YES.
            end.
            ELSE DO:
                ASSIGN l-eliminou = NO.
                wghQuery:GET-NEXT NO-ERROR.
            END. 
        end.

        IF  NUM-RESULTS(wghQuery:NAME) > 0 
        AND NUM-RESULTS(wghQuery:NAME) <> ? 
        AND r-rowid-first-receb <> ? THEN
            wghQuery:REPOSITION-TO-ROWID(r-rowid-first-receb) NO-ERROR.

        if  num-results(wghQuery:name) = 0 then do:

            IF VALID-HANDLE(wb-detalhar-ft0803b) THEN
                assign wb-detalhar-ft0803b:sensitive = false.
        end.
    end.
end.

/*Selecao*/
PROCEDURE pi-choose-bt-selecao:
    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    RUN esp/ftp/esftp9001.w (INPUT-OUTPUT c-unidneg-ini-ft0803b,
                             INPUT-OUTPUT c-unidneg-fim-ft0803b,
                             OUTPUT l-ok).    

    APPLY "choose" TO wb-selecao-ft0803b.

END PROCEDURE.

PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):

        IF  pApresMsg = YES THEN
            MESSAGE
                "Nome do Objeto " wgh-obj:NAME SKIP
                "Type do Objeto " wgh-obj:TYPE skip
                "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE    =   pObjType    AND 
            wgh-obj:NAME    =   pObjName    THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF  wgh-obj:TYPE = "field-group" THEN    
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.           
END PROCEDURE.
