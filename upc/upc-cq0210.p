/*********************************************************************************************
**********************************************************************************************/

def input param p-ind-event                                     as char          no-undo.
def input param p-ind-object                                    as char          no-undo.
def input param p-wgh-object                                    as handle        no-undo.
def input param p-wgh-frame                                     as widget-handle no-undo.
def input param p-cod-table                                     as char          no-undo.
def input param p-row-table                                    as rowid         no-undo.
                                                                
def var v-wh-fill                                               as widget-handle no-undo.
def var v-wh-objeto                                             as widget-handle no-undo.
def var v-wh-sul                                                as widget-handle no-undo.
def var v-wh-new                                                as widget-handle no-undo.
def new global shared var v-bt-resultado                        as widget-handle no-undo.
def new global shared var v-bt-retorno                          as widget-handle no-undo.
def new global shared var v-bt-rejeicao                         as widget-handle no-undo.

def new global shared var v-wh-param                            as widget-handle no-undo.

/* MESSAGE  " p-ind-event  " p-ind-event        skip   */
/*          " p-ind-object " p-ind-object       skip   */
/*          " p-wgh-object " p-wgh-object       skip   */
/*          " p-wgh-frame  " p-wgh-frame        skip   */
/*          " p-cod-table  " p-cod-table        skip   */
/*          " p-row-table  " string(p-row-table)  skip */
/*          VIEW-AS ALERT-BOX INFO BUTTONS OK.         */

/******************************************* Carregando Objetos de Tela ***************************************************/

run pi-vld-widget (input "bt-resultado",
                   output v-wh-fill).
if v-wh-fill <> ?
then do:
     assign v-bt-resultado = v-wh-fill.
end.

run pi-vld-widget (input "bt-retorno",
                   output v-wh-fill).
if v-wh-fill <> ?
then do:
     assign v-bt-retorno = v-wh-fill.
end.

run pi-vld-widget (input "bt-rejeicao",
                   output v-wh-fill).
if v-wh-fill <> ?
then do:
     assign v-bt-rejeicao = v-wh-fill.
end.

/**************************************************************************************************************************/

/* Desabilitando os botäes no CQ0210 */
IF p-ind-event = "BEFORE-DISPLAY"
   AND p-ind-object = "VIEWER"
   AND p-cod-table  = "ficha-cq"  THEN DO:

 IF VALID-HANDLE(v-bt-resultado) THEN
      ASSIGN v-bt-resultado:SENSITIVE = YES.
 IF VALID-HANDLE(v-bt-retorno) THEN
      ASSIGN v-bt-retorno:SENSITIVE = YES. 
 IF VALID-HANDLE(v-bt-rejeicao) THEN
      ASSIGN v-bt-rejeicao:SENSITIVE = YES.  
   
   FIND FIRST ficha-cq NO-LOCK
       WHERE ROWID(ficha-cq) = p-row-table NO-ERROR.

   IF AVAIL ficha-cq THEN DO:

       IF ficha-cq.origem = 2 AND ficha-cq.cod-emitente <> 0 AND ficha-cq.nat-operacao <> "" THEN DO:

           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-ERROR.

               IF AVAIL ITEM THEN DO:

                   FIND FIRST in-grup-estoq NO-LOCK
                        WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
        
                      IF AVAIL in-grup-estoq AND in-grup-estoq.log-ckd = YES THEN DO:

                           IF VALID-HANDLE(v-bt-resultado) THEN
                                ASSIGN v-bt-resultado:SENSITIVE = NO.
                           IF VALID-HANDLE(v-bt-retorno) THEN
                                ASSIGN v-bt-retorno:SENSITIVE = NO. 
                           IF VALID-HANDLE(v-bt-rejeicao) THEN
                                ASSIGN v-bt-rejeicao:SENSITIVE = NO.  
                      END.

               END.

       END.

   END.

END.

IF p-ind-event = "DISPLAY"
   AND p-ind-object = "VIEWER"
   AND p-cod-table  = "ficha-cq"  THEN DO:
   
   FIND FIRST ficha-cq NO-LOCK
       WHERE ROWID(ficha-cq) = p-row-table NO-ERROR.

   IF AVAIL ficha-cq THEN DO:

       IF ficha-cq.origem = 2 AND ficha-cq.cod-emitente <> 0 AND ficha-cq.nat-operacao <> "" THEN DO:

           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-ERROR.

               IF AVAIL ITEM THEN DO:

                   FIND FIRST in-grup-estoq NO-LOCK
                        WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
        
                      IF AVAIL in-grup-estoq AND in-grup-estoq.log-ckd = YES THEN DO:

                           IF VALID-HANDLE(v-bt-resultado) THEN
                                ASSIGN v-bt-resultado:SENSITIVE = NO.
                           IF VALID-HANDLE(v-bt-retorno) THEN
                                ASSIGN v-bt-retorno:SENSITIVE = NO. 
                           IF VALID-HANDLE(v-bt-rejeicao) THEN
                                ASSIGN v-bt-rejeicao:SENSITIVE = NO.  

                      END.

               END.

       END.

   END.

END.


Procedure pi-vld-widget:

    def input  param p-nome-objeto as char.
    def output param p-wh-objeto   as widget-handle.

    def var v-wh-group as widget-handle.
    def var v-wh-child as widget-handle.

    assign v-wh-group = p-wgh-frame:first-child. 

    bloco-encontra-objeto:         
    do while v-wh-group <> ?:
        assign v-wh-child = v-wh-group:first-child.
    
        do while v-wh-child <> ?:
/*             message v-wh-child:name view-as alert-box. */
            if  v-wh-child:name = p-nome-objeto
            then do:
                assign p-wh-objeto = v-wh-child.
                leave bloco-encontra-objeto.
            end.

            assign v-wh-child = v-wh-child:next-sibling.
        end.                                    
        assign v-wh-group = v-wh-group:next-sibling.
    end.
End procedure.

