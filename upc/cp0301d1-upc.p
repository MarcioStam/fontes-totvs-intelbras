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
 
DEF VAR c-objeto  AS CHAR            NO-UNDO.

{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

def var i-sequen              as int no-undo.
def var i-num-cdb             as int no-undo.
def var wh-widget             as widget-handle no-undo.
def var i-estado              as int no-undo.
DEF VAR wh-tipo               AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-cod-estabel        AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-it-codigo-cd0301d1 AS WIDGET-HANDLE NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*
MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.
  */

IF c-objeto = "v04in271.w" AND
    p-ind-event = "ASSIGN" THEN DO:
  
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).    

     RUN busca-handle (INPUT p-wgh-frame,
                       INPUT "fi-cod-estabel",
                       OUTPUT wh-cod-estabel).

     RUN busca-handle (INPUT p-wgh-frame,
                       INPUT "fi-it-codigo",
                       OUTPUT wh-it-codigo-cd0301d1).

    IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
        WHERE entry(1, tt-prog-ponto.conteudo, ";") = wh-cod-estabel:SCREEN-VALUE
        AND   ENTRY(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

        RUN busca-handle (INPUT p-wgh-frame,
                          INPUT "cb-tipo",
                          OUTPUT wh-tipo).

        IF wh-tipo:SCREEN-VALUE = "Interna" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "EmissÆo de Ordens Internas est  bloqueada para realiza‡Æo do Planejamento. Aguarde libera‡Æo.").
    
            RETURN "NOK":U.
        END.
    END.

    IF VALID-HANDLE (wh-it-codigo-cd0301d1) THEN DO:
        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = wh-it-codigo-cd0301d1:SCREEN-VALUE NO-ERROR.

        IF  AVAIL int-item
        AND int-item.motivo-situacao = 2 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Ordem de Produ‡Æo nÆo pode ser gerada. ~~ O item est  em situa‡Æo de Phase Out. Verificar junto ao PCM.|").
    
            RETURN "NOK":U.
        END.
    END.
END.


if c-objeto = "v04in271.w"
and p-ind-event = "AFTER-END-UPDATE" then do:
    /* Implementação para Nova Computadores - Out/2007 */
    /* Ap¢s implanta‡Æo da 2.06 nÆo funcionou corretamente as OPïs externas quando sÆo vincuadas ao pedido de compra no cc0300. Com essa altera‡Æo resolveu pois
       passou a levar a UNID. NEGOC da OP para a ordem de compra. Os movimentos de estoque gerados (da NF e da OP) nÆo receberam a unidade de neg¢cio, o que est 
       correto pois optamos por nÆo utilizar as fun‡äes de UNID de NEGOC. do EMS */
    FIND FIRST ord-prod WHERE ROWID(ord-prod) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ord-prod THEN DO:
        IF ord-prod.tipo >= 2 AND ord-prod.tipo <= 3 THEN do: /* Externa e Interna/Externa */
            FIND item-uni-estab WHERE
                 item-uni-estab.cod-estabel = ord-prod.cod-estabel AND
                 item-uni-estab.it-codigo   = ord-prod.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN
                ASSIGN ord-prod.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
        END.

        if ord-prod.cod-estabel = "103" then do:
            IF ord-prod.it-codigo BEGINS "194" THEN DO: /* KITïs */
                FOR EACH reservas
                   WHERE reservas.nr-ord-prod = ord-prod.nr-ord-prod EXCLUSIVE-LOCK:
                    ASSIGN reservas.cod-depos = "ind"
                           reservas.cod-localiz = "".
                END.
            END.
        END.

        /*
        if ord-prod.cod-estabel = "102" then do:
        
            wh-widget = p-wgh-frame:first-child.
            do while valid-handle(wh-widget):
                if wh-widget:type = "combo-box" and wh-widget:name = "cb-estado" then do:
                    i-estado = lookup(wh-widget:screen-value, {ininc/i01in271.i 03}).
                    leave.
                end.
                if wh-widget:type = "field-group" then
                    wh-widget = wh-widget:first-child.
                else wh-widget = wh-widget:next-sibling.
            end.        
       
            if i-estado < 7 then return "OK".
             
            for each reservas no-lock
                where reservas.nr-ord-prod = ord-prod.nr-ord-prod
                and    reservas.quant-orig > 0,
                first item fields () no-lock
                where item.it-codigo = reservas.it-codigo
                and   item.contr-qualid
                break by reservas.it-codigo:
                
                if first-of(reservas.it-codigo) then do:
                    i-num-cdb = 0.
                    for each ae-item-cdb fields () no-lock
                        where ae-item-cdb.cod-estabel = v_cod_estab_usuar
                        and   ae-item-cdb.it-codigo   = reservas.it-codigo
                        and   ae-item-cdb.nr-ord-prod = reservas.nr-ord-prod 
                        and   ae-item-cdb.tipo        = 2:
                        
                        i-num-cdb = i-num-cdb + 1.
                    end.
                    
                    if i-num-cdb < reservas.quant-atend then do:    
                        create tt-erro.
                        assign i-sequen            = i-sequen + 1 
                               tt-erro.i-sequen    = i-sequen
                               tt-erro.cd-erro     = 17006
                               tt-erro.mensagem    = substitute("Não encontrados CDBs suficientes para o item &1. " +
                                                                if reservas.quant-atend - i-num-cdb > 1 
                                                                then "Faltam &2 CDBs a serem informados no ESCPP033"
                                                                else "Falta 1 (um) CDB a ser informado no ESCPP033",  
                                                                reservas.it-codigo,
                                                                string(reservas.quant-atend - i-num-cdb)).
                        
                        next.
                    end.    
                end.                 
                
            end.    
            if can-find(first tt-erro) then do:
                run cdp/cd0666.w (input table tt-erro).
                return "NOK".
            end.
        
        end.
        */
    end.
    return "OK".    
    
    /* Fim da implementação para Nova Computadores - Out/2007 */
end.
 
 



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


