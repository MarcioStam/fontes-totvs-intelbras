/******************************************************************************
*      Programa .....: EN0503B-UPC.P                                          *
*      Data .........: 20 de Maio de 2022                                     *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0503B                                     *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 20/05/2022  Mauricio      Desenvolvimento                  *
*      1.00.00.001 26/07/2022  Mauricio      Validaá∆o                        *
******************************************************************************/
{include/i-prgvrs.i "en0503b-epc" 1.00.00.001}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

DEFINE VARIABLE wh-un-ciclo-en0503b     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-qtd-cons-new-en0503b AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-it-codigo-en0503b    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-op-codigo-en0503b    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-ferramenta-en0503b   AS WIDGET-HANDLE NO-UNDO.

def var c-objeto as char no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-container-en0503b    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-cons-txt-en0503b AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-en0503b-upc NO-UNDO
    FIELD wg-frame        AS HANDLE
    FIELD wg-un-ciclo     AS HANDLE
    FIELD wg-proporcao    AS HANDLE
    FIELD wg-qtd-cons-new AS HANDLE
    FIELD wg-container    AS HANDLE.

DEF BUFFER b-ferr-prod FOR ferr-prod.

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
THEN ASSIGN wh-container-en0503b = p-wgh-object.

IF  p-ind-event = "INITIALIZE"
AND p-ind-object = "VIEWER"
AND c-objeto = "v01in255.w"
AND NOT CAN-FIND(FIRST tt-en0503b-upc WHERE
                       tt-en0503b-upc.wg-frame = p-wgh-frame)
THEN DO:
     RUN busca-handle (INPUT p-wgh-frame,
                       INPUT "un-ciclo",
                       OUTPUT wh-un-ciclo-en0503b).
    
     IF  VALID-HANDLE(wh-un-ciclo-en0503b)
     THEN DO:
          CREATE FILL-IN wh-qtd-cons-new-en0503b
          ASSIGN FRAME             = wh-un-ciclo-en0503b:FRAME
                 DATA-TYPE         = "Integer"
                 FORMAT            = ">>>>>9"
                 WIDTH             = wh-un-ciclo-en0503b:width
                 HEIGHT            = wh-un-ciclo-en0503b:HEIGHT
                 ROW               = wh-un-ciclo-en0503b:ROW
                 COLUMN            = wh-un-ciclo-en0503b:COLUMN
                 SENSITIVE         = YES
                 VISIBLE           = YES.
    
          create TEXT wh-qtd-cons-txt-en0503b
          assign frame        = wh-qtd-cons-new-en0503b:frame
                 WIDTH        = 8
                 HEIGHT       = 0.88
                 row          = wh-qtd-cons-new-en0503b:row
                 col          = wh-qtd-cons-new-en0503b:col - 8
                 BGCOLOR      = ?
                 VISIBLE      = YES
                 SENSITIVE    = YES
                 format       = "x(10)"
                 screen-value = "Qtde Cons:".
     
          wh-qtd-cons-new-en0503b:MOVE-AFTER-TAB-ITEM(wh-un-ciclo-en0503b).
     
          CREATE tt-en0503b-upc.
          ASSIGN tt-en0503b-upc.wg-frame        = wh-un-ciclo-en0503b:FRAME
                 tt-en0503b-upc.wg-un-ciclo     = wh-un-ciclo-en0503b
                 tt-en0503b-upc.wg-qtd-cons-new = wh-qtd-cons-new-en0503b
                 tt-en0503b-upc.wg-container    = wh-container-en0503b.

          RUN busca-handle (INPUT p-wgh-frame,
                            INPUT "proporcao",
                            OUTPUT tt-en0503b-upc.wg-proporcao).

          FIND CURRENT tt-en0503b-upc NO-ERROR.   
     END.
END.

IF  p-ind-object = "VIEWER"
AND c-objeto = "v01in255.w"
AND (p-ind-event = "DISPLAY"
 OR  p-ind-event = "ADD")
THEN for FIRST tt-en0503b-upc 
         where tt-en0503b-upc.wg-frame = p-wgh-frame:
         ASSIGN tt-en0503b-upc.wg-un-ciclo:HIDDEN  = YES.
         ASSIGN tt-en0503b-upc.wg-proporcao:HIDDEN = YES WHEN VALID-HANDLE(tt-en0503b-upc.wg-proporcao).
         tt-en0503b-upc.wg-qtd-cons-new:MOVE-TO-TOP().

         ASSIGN tt-en0503b-upc.wg-qtd-cons-new:SCREEN-VALUE = "".
         
         FOR FIRST op-ferram NO-LOCK
             WHERE ROWID(op-ferram) = p-row-table:
             ASSIGN tt-en0503b-upc.wg-qtd-cons-new:SCREEN-VALUE = STRING(op-ferram.int-1) NO-ERROR.
         END. /* FOR FIRST op-ferram */
     end.

IF  p-ind-event = "AFTER-VALIDATE"
AND p-ind-object = "VIEWER"
AND c-objeto = "v01in255.w"
THEN DO:
     run get-attribute in p-wgh-object ('adm-new-record').
    
     IF RETURN-VALUE = 'YES'
     THEN DO:
          RUN busca-handle (INPUT p-wgh-frame,
                            INPUT "c-codigo",
                            OUTPUT wh-it-codigo-en0503b).

          RUN busca-handle (INPUT p-wgh-frame,
                            INPUT "op-codigo",
                            OUTPUT wh-op-codigo-en0503b).

          RUN busca-handle (INPUT p-wgh-frame,
                            INPUT "fi_ferramenta",
                            OUTPUT wh-ferramenta-en0503b).

          IF  VALID-HANDLE(wh-it-codigo-en0503b)
          AND VALID-HANDLE(wh-op-codigo-en0503b)
          AND VALID-HANDLE(wh-ferramenta-en0503b)
          THEN FOR FIRST ferr-prod FIELDS(char-1) NO-LOCK
                   WHERE ferr-prod.cod-ferr-prod = wh-ferramenta-en0503b:SCREEN-VALUE:
                   if ferr-prod.char-1       = ""
                   or trim(ferr-prod.char-1) = "..."
                   then do:
                        run utp/ut-msgs.p (input "show":U, input 17567, input "Ferramenta informada n∆o possui tipo cadastrado (Ferramenta, Dispositivo ou M∆o de Obra).").
                        return "NOK".
                   end.

                   IF TRIM(ferr-prod.char-1) = "Ferramenta"
                   OR TRIM(ferr-prod.char-1) = "M∆o de Obra"
                   THEN FOR EACH operacao no-lock
                           WHERE operacao.it-codigo = wh-it-codigo-en0503b:screen-value
                             AND operacao.op-codigo = inte(wh-op-codigo-en0503b:screen-value),
                            EACH op-ferram NO-LOCK
                           WHERE op-ferram.num-id-operacao = operacao.num-id-operacao,
                           FIRST b-ferr-prod NO-LOCK
                           WHERE b-ferr-prod.cod-ferr-prod = op-ferram.ferramenta
                             AND b-ferr-prod.char-1        = ferr-prod.char-1:
                            run utp/ut-msgs.p (input "show":U, input 17567, input "J† existe Ferramenta tipo " + TRIM(ferr-prod.char-1) + " cadastrada para Operaá∆o. Elimine-a antes de inserir uma nova.").
                            return "NOK".
                        END. /* for each operacao */
               END. /* for first ferr-prod */
     END.
END.

IF  p-ind-event = "ASSIGN"
AND p-ind-object = "VIEWER"
AND c-objeto = "v01in255.w"
THEN for FIRST tt-en0503b-upc 
         where tt-en0503b-upc.wg-frame = p-wgh-frame:
         FOR FIRST op-ferram
             WHERE ROWID(op-ferram) = p-row-table
                   EXCLUSIVE-LOCK: END.

         IF AVAIL op-ferram
         THEN ASSIGN op-ferram.int-1 = INTE(tt-en0503b-upc.wg-qtd-cons-new:SCREEN-VALUE).
         FIND CURRENT op-ferram NO-LOCK NO-ERROR.
     end.

IF VALID-HANDLE(wh-qtd-cons-txt-en0503b)
THEN ASSIGN wh-qtd-cons-txt-en0503b:SCREEN-VALUE = "Qtde Cons:".

IF  p-ind-event  = "DESTROY" 
AND p-ind-object = "CONTAINER" 
and c-objeto     = "en0503b.w" 
THEN FOR FIRST tt-en0503b-upc
         WHERE tt-en0503b-upc.wg-container = p-wgh-object:
         DELETE tt-en0503b-upc.
     END.

/********** PROCEDURES **********/
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

