{include/i-epc200.i1}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

DEF VAR l-conf      AS   LOGICAL                NO-UNDO.
DEF VAR l-erro-x    AS   LOGICAL                NO-UNDO.
DEFINE BUFFER b-ficha-cq FOR ficha-cq.

def var i-ultimo-ae as int.

DEF NEW GLOBAL SHARED VAR vNtOrdProdu LIKE ord-prod.nr-ord-produ NO-UNDO.
DEF NEW GLOBAL SHARED VAR vNomProg    AS   CHAR                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR vRowid      AS   ROWID                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR vCodLocalizAcabado  LIKE ITEM.cod-localiz NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-tt        AS HANDLE     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cod-depos AS HANDLE     NO-UNDO.

{esp/es0018.i}

find first param-global no-lock no-error.

FOR FIRST tt-epc 
    WHERE (tt-epc.cod-event     = "atualiza-tt-rep-prod-pi-recebe-tt":U OR 
           tt-epc.cod-event     = "atualiza-tt-rep-prod-pi-reporte":U)
    AND    tt-epc.cod-parameter = "handle-tt-rep-prod":U :
    ASSIGN h-tt                 = widget-handle(tt-epc.val-parameter)
           h-cod-depos          = h-tt:BUFFER-FIELD("cod-depos").
END.

IF  pIndEvent = "Medio-Refer" THEN
DO: 
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "Medio-Refer"
        AND   tt-epc.cod-parameter = "nr-ord-produ":
        ASSIGN vNtOrdProdu = int(tt-epc.val-parameter).

        /** Vari·vel usada para AtualiÁ„o Ficha-cq **/
        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = vNtOrdProdu:
            
            if  ord-prod.cod-estabel <> "105" AND
                ord-prod.cod-estabel <> "103" AND
                ord-prod.tipo = 2 /* Externa */
            then RUN piValidaOrdemExterna.

            find item where item.it-codigo = ord-prod.it-codigo no-lock no-error.
            find lin-prod where lin-prod.cod-estabel = ord-prod.cod-estabel
                            and lin-prod.nr-linha    = ord-prod.nr-linha
                            no-lock no-error.
            
            if  ord-prod.tipo = 1 /* Interna */
            and item.ge-codigo <> 45
            and lin-prod.sum-requis <> 2 /* ordem de serviáo */
            AND ITEM.cod-unid-negoc <> "ENS"
            then RUN piValidaOperacao.
            
        END.
        
    END.

    IF l-erro-x THEN RETURN "NOK".
END.

procedure piValidaOperacao:

    def var l-operacao  as log no-undo.
    
    ASSIGN l-operacao = YES.
    
    
    FIND FIRST operacao OF item NO-LOCK NO-ERROR.
    IF NOT AVAIL operacao THEN ASSIGN l-operacao = NO.
        
    IF l-operacao = NO 
    THEN DO:
        FIND FIRST rot-item OF item NO-LOCK NO-ERROR.
        IF NOT AVAIL rot-item 
        THEN DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Item deve possuir uma operaá∆o ou roteiro cadastrado. Reporte n∆o pode ser efetuado!").
            assign l-erro-x = yes.

        END.
    END.
    else do:
        for each operacao of item no-lock:
            if  operacao.tempo-maquin <> 0
            and operacao.tempo-homem  <> 0
            then do:
                assign l-operacao = no.
            end.

            /*Validaá∆o para n∆o dar erro se tiver operaá∆o externa na decio*/
            IF  ITEM.cod-unid-negoc = "DEC" 
            AND operacao.tipo-oper = 2 /*Externa*/ THEN DO:
                 assign l-operacao = no.
            END.
        end.

        if l-operacao
        then do:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Item deve ter tempo cadastrado. Reporte n∆o pode ser efetuado!").
            assign l-erro-x = yes.
        end.
        
    end.
    ASSIGN l-operacao = YES.
    FIND FIRST oper-ord 
         WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK no-error.
    IF NOT AVAIL oper-ord 
    THEN ASSIGN l-operacao = NO.
        
    IF l-operacao = NO 
    THEN DO:
        run utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "A ORDEM " + string(ord-prod.nr-ord-prod) + " deve possuir uma operaá∆o cadastrada. Reporte n∆o pode ser efetuado! ").
        assign l-erro-x = yes.

    END.
    else do:
        
        for each oper-ord 
           where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
            no-lock:
            if  oper-ord.tempo-maquin <> 0
            and oper-ord.tempo-homem  <> 0
            then do:
                assign l-operacao = no.
            end.

            /*Validaá∆o para n∆o dar erro se tiver operaá∆o externa na decio*/
            IF  ITEM.cod-unid-negoc = "DEC" 
            AND oper-ord.tipo-oper = 2 /*Externa*/ THEN DO:
                 assign l-operacao = no.
            END.
        end.

        if l-operacao
        then do:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Item deve ter tempo cadastrado. Reporte n∆o pode ser efetuado!").
            assign l-erro-x = yes.
        end.
        
    
    end.
    
end procedure.

PROCEDURE piValidaOrdemExterna:

    DEF VAR l-linha-valida AS LOG INITIAL NO NO-UNDO.

    if  ord-prod.nr-linha <> 10 then do: 
        if ord-prod.nr-linha <> 12 then do:
            RUN utp/ut-msgs.p (input "SHOW",
                               input 27100,
                               input "Ordem nao e da linha 10/12. E um reporte de industrializacao ?" + "~~" + 
                                     "Ordem nao e da linha 10/12. E um reporte de industrializacao ?").
            ASSIGN l-conf = RETURN-VALUE = "YES".
            if l-conf then assign l-erro-x = yes.
        end.
        else do:
            RUN utp/ut-msgs.p (input "SHOW",
                               input 27100,
                               input "E um reporte de Retrabalho EXTERNO ?" + "~~" + 
                                     "E um reporte de Retrabalho EXTERNO ?").
            ASSIGN l-conf = RETURN-VALUE = "YES".
            if NOT l-conf then ASSIGN l-erro-x = YES.
        end.
    end.
    if param-global.modulo-cq then do:
        if ord-prod.nr-linha = 10 and
           /*ord-prod.cod-depos <> "rec" */ 
           h-cod-depos:BUFFER-VALUE <> "REC" AND 
           h-cod-depos:BUFFER-VALUE <> "VIR" then do:
           if ord-prod.it-codigo <> "3992969" and
              ord-prod.it-codigo <> "3992845" then do:
              RUN utp/ut-msgs.p (INPUT "show":U, 
                                 INPUT 17567, 
                                 INPUT "Linha de producao " + string(ord-prod.nr-linha) + " o deposito tem que ser rec").
              assign l-erro-x = yes.
           end.
        end.
    end.
    if (ord-prod.nr-linha = 10 or ord-prod.nr-linha = 12 )      and
        h-cod-depos:BUFFER-VALUE = "REC" AND
        /*ord-prod.cod-depos    = "rec" AND /*movto-estoq.esp-docto = 1 /*"aca"*/ and*/*/
        (vCodLocalizAcabado   <> "x"  AND vCodLocalizAcabado <> "") THEN DO:
        /*movto-estoq.cod-localiz <> "x" then do:*/
       RUN utp/ut-msgs.p (INPUT "show":U, 
                          INPUT 17567, 
                          INPUT 'Linha de producao 10 com localizacao rec a localizacao tem que ser "X" ou BRANCO.').
       assign l-erro-x = yes.
    END.

    IF h-cod-depos:BUFFER-VALUE = "REC" THEN DO:
    
        RUN esp/es0018p.p (INPUT "cpapi001", /* Nome do programa */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).    
    
        FOR EACH tt-prog-ponto:
            IF tt-prog-ponto.conteudo = STRING(ord-prod.nr-linha) THEN
               ASSIGN l-linha-valida = YES.
        END.

        IF NOT l-linha-valida THEN DO:

           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Linha de producao diferente de " + string(ord-prod.nr-linha) + " o deposito nao pode ser rec").
           ASSIGN l-erro-x = YES.
        END.
        
        /*
        if (ord-prod.nr-linha <> 10 and 
            ord-prod.nr-linha <> 12 ) and h-cod-depos:BUFFER-VALUE = "REC" /*ord-prod.cod-depos = "rec"*/ then do:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Linha de producao diferente de " + string(ord-prod.nr-linha) + " o deposito nao pode ser rec").
            assign l-erro-x = yes.
        end.*/

    END.
END.
