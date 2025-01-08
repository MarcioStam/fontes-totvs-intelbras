/******************************************************************************
*      Programa .....: EN0712-UPC.P                                           *
*      Data .........: 10 de Maio de 2022                                     *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0712                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 10/05/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "en0712-epc" 1.00.00.000}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

DEFINE VARIABLE wh-nr-homem-en0712     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-nr-homem-new-en0712 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-nr-homem-txt-en0712 AS WIDGET-HANDLE NO-UNDO.

def var c-objeto as char no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-container-en0712 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-en0712-upc NO-UNDO
    FIELD wg-frame      AS HANDLE
    FIELD wg-nr-hom     AS HANDLE
    FIELD wg-nr-hom-new AS HANDLE
    FIELD wg-container  AS HANDLE
    FIELD wg-folder     AS HANDLE
    FIELD wg-txt        AS HANDLE.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event  skip        */
/*         "P-ind-object = " p-ind-object skip        */
/*         "C-objeto     = " c-objeto     SKIP        */
/*         "P-wgh-object = " p-wgh-object skip        */
/*         "P-wgh-frame  = " p-wgh-frame  skip        */
/*         "P-cod-table  = " p-cod-table  skip        */
/*         "p-row-table  = " string(p-row-table) skip */
/*         view-as alert-box.                         */

IF  p-ind-event  = "BEFORE-INITIALIZE"
AND p-ind-object = "CONTAINER"
THEN ASSIGN wh-container-en0712 = p-wgh-object.

IF  p-ind-event = "INITIALIZE"
AND p-ind-object = "VIEWER"
AND c-objeto = "v07in263.w"
AND NOT CAN-FIND(FIRST tt-en0712-upc WHERE
                       tt-en0712-upc.wg-frame = p-wgh-frame)
THEN DO:
     run select-page in wh-container-en0712 (input 2).
     RUN pi-nr-homem.
     run select-page in wh-container-en0712 (input 1).
END.

IF  p-ind-event = "DISPLAY"
AND p-ind-object = "VIEWER"
AND c-objeto = "v07in263.w"
THEN for FIRST tt-en0712-upc 
         where tt-en0712-upc.wg-frame = p-wgh-frame:
         ASSIGN tt-en0712-upc.wg-nr-hom:HIDDEN = YES.
         tt-en0712-upc.wg-nr-hom-new:MOVE-TO-TOP().

         ASSIGN tt-en0712-upc.wg-nr-hom-new:SCREEN-VALUE = "".
         
         FOR FIRST operacao NO-LOCK
             WHERE ROWID(operacao) = p-row-table,
             FIRST int-ext-operacao USE-INDEX index2 NO-LOCK
             WHERE int-ext-operacao.num-id-operacao = operacao.num-id-operacao:
             ASSIGN tt-en0712-upc.wg-nr-hom-new:SCREEN-VALUE = STRING(int-ext-operacao.nro-homem-aps) NO-ERROR.
         END. /* FOR FIRST operacao */
     end.

IF  p-ind-event  = "DESTROY" 
AND p-ind-object = "CONTAINER" 
and c-objeto     = "en0712.w" 
THEN FOR FIRST tt-en0712-upc
         WHERE tt-en0712-upc.wg-container = p-wgh-object:
         DELETE tt-en0712-upc.
     END.

/********** PROCEDURES **********/
PROCEDURE pi-nr-homem:
    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "numero-homem",
                      OUTPUT wh-nr-homem-en0712).

    IF  VALID-HANDLE(wh-nr-homem-en0712)
    THEN DO:
         CREATE FILL-IN wh-nr-homem-new-en0712
         ASSIGN FRAME             = wh-nr-homem-en0712:FRAME
                DATA-TYPE         = "Decimal"
                FORMAT            = ">>9.9"
                WIDTH             = wh-nr-homem-en0712:width
                HEIGHT            = wh-nr-homem-en0712:HEIGHT
                ROW               = wh-nr-homem-en0712:ROW 
                COLUMN            = wh-nr-homem-en0712:COLUMN
                SENSITIVE         = no
                VISIBLE           = YES.

         create TEXT wh-nr-homem-txt-en0712
         assign frame        = wh-nr-homem-new-en0712:frame
                WIDTH        = 12.7
                HEIGHT       = 0.88
                row          = wh-nr-homem-new-en0712:row
                col          = wh-nr-homem-new-en0712:col - 13
                BGCOLOR      = ?
                VISIBLE      = YES
                SENSITIVE    = YES
                format       = "x(16)"
                screen-value = "Nro. Homens APS:".
    
         wh-nr-homem-new-en0712:MOVE-AFTER-TAB-ITEM(wh-nr-homem-en0712).
    
         CREATE tt-en0712-upc.
         ASSIGN tt-en0712-upc.wg-frame      = wh-nr-homem-en0712:FRAME
                tt-en0712-upc.wg-nr-hom     = wh-nr-homem-en0712
                tt-en0712-upc.wg-nr-hom-new = wh-nr-homem-new-en0712
                tt-en0712-upc.wg-container  = wh-container-en0712.
         FIND CURRENT tt-en0712-upc NO-ERROR.   
    END.
END PROCEDURE.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

