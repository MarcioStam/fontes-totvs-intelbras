/*****************************************************************************
** Programa..............: epc_utb006eb.p
** Descricao.............: Bloqueio alteraá∆o Matriz e CNPJ da PJ pelo EMS5
** Criado em.............: 03/06/2009
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.
                               
/* ** EPC relacionada aos programas:
Manutená∆o Pessoa Jur°dica
utb006eb - mod_pessoa_jurid_base
***/

define new global shared var wh-matriz-campo as widget-handle no-undo.
define new global shared var wh-matriz-zoom  as widget-handle no-undo.
define new global shared var wh-cnpj-campo   as widget-handle no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
DEF BUFFER b_cliente      FOR emscad.cliente.
DEF BUFFER b_emitente     FOR emitente.

case p_ind_event:
    when "ENABLE" 
    then do:

         /* ** Desabilita Matriz ***/
         RUN tela-upc (INPUT p_wgh_frame,
                       INPUT p_ind_event,
                       INPUT "fill-in",      /*** Type ***/
                       INPUT "num_pessoa_jurid_matriz",  /*** Name ***/
                       INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                       INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wh-matriz-campo).
         /*matriz-zoom*/
         RUN tela-upc (INPUT p_wgh_frame,
                       INPUT p_ind_Event,
                       INPUT "button",       /*** Type ***/
                       INPUT "bt_zoo_matriz", /*** Name ***/
                       INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                       INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wh-matriz-zoom).
         ASSIGN wh-matriz-campo:SENSITIVE = NO
                wh-matriz-zoom:SENSITIVE  = NO.

         /* ** Desabilita CNPJ ***/
         RUN tela-upc (INPUT p_wgh_frame,
                       INPUT p_ind_event,
                       INPUT "fill-in",      /*** Type ***/
                       INPUT "cod_id_feder",  /*** Name ***/
                       INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                       INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wh-cnpj-campo).
          
         ASSIGN wh-cnpj-campo:SENSITIVE = NO.

    end.

    when "VALIDATE" 
    then do:

         /* ** Bloqueia alteraá∆o de CNPJ ***/
         FIND b_pessoa_jurid NO-LOCK
              WHERE RECID(b_pessoa_jurid) = p_rec_table NO-ERROR.

         FIND FIRST b_cliente NO-LOCK
              WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
         IF AVAIL b_cliente 
         THEN DO:
              FIND b_emitente NO-LOCK
                   WHERE b_emitente.cod-emitente = b_cliente.cdn_cliente NO-ERROR.
              IF AVAIL b_emitente 
              THEN DO:
                   IF b_emitente.cgc <> b_pessoa_jurid.cod_id_feder 
                   THEN DO:
                        MESSAGE "Alteraá∆o de CNPJ n∆o permitida !" VIEW-AS ALERT-BOX.
                        RETURN "NOK".
                   END.
              END.
         END.

    END.

end case.

PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.
