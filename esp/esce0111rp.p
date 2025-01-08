{include/i-prgvrs.i ESCE0111RP 2.00.00.000}

{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{cdp/cd0666.i}

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
    DEFINE VARIABLE l-lote-avancado   AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-ceapi028        AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-new-tip-con-est AS INTEGER NO-UNDO.

    {cep/ceapi028.i}
&ENDIF

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
    IF CAN-FIND(funcao WHERE funcao.cd-funcao = "lote-avancado":u
                         AND funcao.ativo) THEN DO:
        
        ASSIGN l-lote-avancado = YES.

        RUN cep/ceapi028.p PERSISTENT SET h-ceapi028 (INPUT TABLE tt-fda-lote-avancad,
                                                      INPUT TABLE tt-fda-lote-histor,
                                                      INPUT 1,/*movto estoque*/
                                                      INPUT "Altera‡Æo tipo controle estoque",
                                                      OUTPUT TABLE tt-erro).
    END.
&endif

&GLOBAL-DEFINE RTF NO
&SCOPED-DEFINE pagesize 43   

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    FIELD lote             LIKE saldo-estoq.lote
    FIELD dt-vali-lote     LIKE saldo-estoq.dt-vali-lote
    FIELD dt-referencia    LIKE saldo-estoq.dt-vali-lote
    field i-tipo-exec      AS INT.

define temp-table tt-troca no-undo
    field it-codigo     like item.it-codigo
    field un            like item.un
    field descricao     as char format "x(36)"
    index id is primary unique it-codigo.

define temp-table tt-digita no-undo
    field it-codigo     like item.it-codigo
    field un            like item.un
    field descricao     as char format "x(36)"
    index id is primary unique it-codigo.

DEFINE TEMP-TABLE tt-item-old NO-UNDO
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD tipo-con-est     LIKE item.tipo-con-est
    FIELD lote             LIKE movto-estoq.lote
    FIELD cod-refer        LIKE referencia.cod-refer
    FIELD dt-vali-lote     LIKE saldo-estoq.dt-vali-lote
    INDEX id-item it-codigo.

DEFINE TEMP-TABLE tt-item-new NO-UNDO
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD tipo-con-est     LIKE item.tipo-con-est
    FIELD lote             LIKE movto-estoq.lote
    FIELD cod-refer        LIKE referencia.cod-refer
    FIELD dt-vali-lote     LIKE saldo-estoq.dt-vali-lote
    INDEX id-item it-codigo.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-item-2 NO-UNDO LIKE item USE-INDEX codigo.

DEFINE TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen   AS   INTEGER FORMAT ">>>>>>>9" COLUMN-LABEL "Seq Erro"
    FIELD cd-erro    AS   INTEGER                   COLUMN-LABEL "C¢d Erro"
    FIELD mensagem   AS   CHARACTER FORMAT "x(255)" COLUMN-LABEL "Descri‡Æo Erro"
    FIELD it-codigo  LIKE item.it-codigo
    FIELD sub-type   AS   CHARACTER FORMAT "x(12)"  COLUMN-LABEL "Tipo Erro".

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE l-alt-refer        AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE i-tipo-con-est-old AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-seq              AS INTEGER                  NO-UNDO.
DEFINE VARIABLE l-erro             AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE c-cod-refer        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE i-cont             AS INTEGER                  NO-UNDO.
DEFINE VARIABLE c-tipo-con-est1    AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-tipo-con-est2    AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE BUFFER bf2-item        FOR item.
DEFINE BUFFER b-tt-erro-aux   FOR tt-erro-aux.
DEFINE BUFFER b-reservas      FOR reservas.
DEFINE BUFFER breq-ord        FOR req-ord.
DEFINE BUFFER b-saldo-est     FOR saldo-estoq.
DEFINE BUFFER b2-saldo-est    FOR saldo-estoq.
DEFINE BUFFER b-invent        FOR inventario.
DEFINE BUFFER b2-invent       FOR inventario.
DEFINE BUFFER b-item-doc-est  FOR item-doc-est.
DEFINE BUFFER b-rat-lote      FOR rat-lote.
DEFINE BUFFER b-it-dep-fat    FOR it-dep-fat.
DEFINE BUFFER b2-it-dep-fat   FOR it-dep-fat.
DEFINE BUFFER b-fat-ser-lote  FOR fat-ser-lote.
DEFINE BUFFER b2-fat-ser-lote FOR fat-ser-lote.

FORM tt-item-old.it-codigo    AT 01                COLUMN-LABEL "C¢d.Item"
     c-tipo-con-est1          AT 18 FORMAT "x(12)" COLUMN-LABEL "Tipo Controle"
     c-tipo-con-est2          AT 35 FORMAT "x(12)" COLUMN-LABEL "Tipo Controle"
     tt-item-new.lote         AT 49 FORMAT "x(20)" COLUMN-LABEL "Lote/S‚rie/Nro S‚rie"
     tt-item-new.dt-vali-lote AT 70                COLUMN-LABEL "Val. Lote"
     WITH WIDTH 150 64 DOWN NO-BOX FRAME f-item STREAM-IO.

FORM tt-erro-aux.it-codigo AT 01 
     tt-erro-aux.i-sequen  AT 18
     tt-erro-aux.cd-erro   AT 27
     tt-erro-aux.sub-type  AT 38
     tt-erro-aux.mensagem  AT 51 FORMAT "x(110)"
     WITH WIDTH 170 64 DOWN NO-BOX FRAME f-erro STREAM-IO.

{include/i-rpout.i &STREAM="stream str-rp"}
{include/i-rpcab.i &STREAM="str-rp"}

FIND FIRST mguni.empresa NO-LOCK
     WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN  c-programa 	    = "ESCE0111RP"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = empresa.nome
	    c-sistema	    = "Estoque"
	    c-titulo-relat  = "Altera‡Æo Tipo Controle Item".

IF tt-param.destino <> 4 THEN DO:
    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

blk-item:
FOR EACH tt-digita NO-LOCK
      ON ERROR UNDO,LEAVE
      ON STOP UNDO, LEAVE:

  IF tt-param.i-tipo-exec = 1 /*Data referˆncia para frente*/ THEN DO:

    FIND FIRST bf2-item NO-LOCK
         WHERE bf2-item.it-codigo = tt-digita.it-codigo NO-ERROR.

    IF AVAIL bf2-item AND bf2-item.tipo-con-est <> 1 THEN NEXT.

    FIND FIRST item EXCLUSIVE-LOCK
         WHERE ROWID(item) = ROWID(bf2-item) NO-ERROR.

    EMPTY TEMP-TABLE tt-erro.

    RUN pi-acompanhar IN h-acomp ("Analizando item: " + item.it-codigo).

    ASSIGN l-erro = NO.

    RUN pi-atualiza-item.

    IF RETURN-VALUE <> "OK":U THEN
        ASSIGN l-erro = YES.

    RUN pi-acompanhar IN h-acomp ("Atualizando item: " + item.it-codigo).

    IF NOT l-erro THEN DO:

        FIND FIRST tt-item-old NO-LOCK
             WHERE tt-item-old.it-codigo = item.it-codigo NO-ERROR.

        IF AVAIL tt-item-old THEN DO:

            FIND FIRST tt-item-new NO-LOCK
                 WHERE tt-item-new.it-codigo = item.it-codigo NO-ERROR.

            ASSIGN c-tipo-con-est1 = {ininc/i01in122.i 04 tt-item-old.tipo-con-est}
                   c-tipo-con-est2 = {ininc/i01in122.i 04 tt-item-new.tipo-con-est}.

            DISPLAY STREAM str-rp
                    tt-item-old.it-codigo 
                    c-tipo-con-est1
                    c-tipo-con-est2
                    tt-item-new.lote          
                    tt-item-new.dt-vali-lote 
                WITH FRAME f-item.
            DOWN WITH FRAME f-item. 
        END.
    END.

  END.

  ELSE DO: /*Data referˆncia para tr s*/

      FIND FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = tt-digita.it-codigo NO-ERROR.

      IF AVAIL ITEM AND ITEM.tipo-con-est = 3 THEN DO:

          RUN pi-assign.

      END.

  END.

    IF l-erro THEN
        UNDO blk-item.
END.

IF CAN-FIND(FIRST tt-item-new) THEN
    DISPLAY STREAM str-rp SKIP.

FOR EACH tt-erro-aux:

    DISPLAY STREAM str-rp
            tt-erro-aux.it-codigo 
            tt-erro-aux.i-sequen
            tt-erro-aux.cd-erro
            tt-erro-aux.sub-type
            tt-erro-aux.mensagem
        WITH FRAME f-erro.
    DOWN WITH FRAME f-erro.
END.

{include/i-rpclo.i &STREAM="stream str-rp"}
RUN pi-finalizar IN h-acomp.

RETURN "OK":U.


PROCEDURE pi-atualiza-item:

    DEFINE BUFFER b-item FOR ITEM.
    
    DEFINE VARIABLE c-lote-histor AS CHARACTER NO-UNDO.

    FOR EACH tt-item-2:
        DELETE tt-item-2.
    END.

    CREATE tt-item-2.
    BUFFER-COPY item TO tt-item-2.
    
    /*{include/i-valid.i}*/

    ASSIGN tt-item-2.tipo-con-est = 3
           tt-item-2.alt-refer    = YES
    	   l-alt-refer            = tt-item-2.alt-refer.

    IF  tt-item-2.tipo-con-est = 3
    AND item.tipo-con-est     <> 3
    AND CAN-FIND(FIRST item-lista-compon
                 WHERE item-lista-compon.es-codigo         = item.it-codigo
                   AND item-lista-compon.log-compon-altern = YES) THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 18233, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 18233, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.

    IF item.tipo-con-est = 3 THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 3163, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 3163, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.
    
    IF tt-param.lote = "" THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 2158, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 2158, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.

    IF tt-param.dt-vali-lote = ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 15021, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 15021, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.

    IF item.politica = 5 THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 5685, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 5685, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.

    IF tt-param.dt-vali-lote < TODAY THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 26638, INPUT "").
        RUN pi-cria-tt-erro-aux (INPUT 26638, INPUT RETURN-VALUE).

        RETURN "NOK":U.
    END.

    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    
        IF CAN-FIND(FIRST item-uni-estab USE-INDEX item-uni-estab-refugo
                    WHERE ITEM-uni-estab.cod-item-refugo = item.it-codigo) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, INPUT item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST b-item USE-INDEX item-refugo
                    WHERE b-item.cod-item-refugo = item.it-codigo) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, INPUT item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST fam-uni-estab USE-INDEX fam-uni-estab-refugo
                    WHERE fam-uni-estab.cod-item-refugo = item.it-codigo) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.

        IF CAN-FIND(FIRST familia USE-INDEX familia-refugo
                    WHERE familia.cod-item-refugo = item.it-codigo) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, INPUT item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST mgind.operacao USE-INDEX operacao-refugo
                    WHERE operacao.cod-item-refugo = item.it-codigo) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST ord-prod USE-INDEX ord-produc-refugo
                    WHERE ord-prod.cod-item-refugo = item.it-codigo 
                      AND ord-prod.estado < 8) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, INPUT item.it-codigo).
            RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST oper-ord USE-INDEX oper-ord-refugo
                    WHERE oper-ord.cod-item-refugo = item.it-codigo) THEN DO:
    
            FOR EACH oper-ord USE-INDEX oper-ord-refugo NO-LOCK
               WHERE oper-ord.cod-item-refugo = item.it-codigo:
    
                IF CAN-FIND(FIRST ord-prod 
                            WHERE ord-prod.nr-ord-produ = oper-ord.nr-ord-produ
                              AND ord-prod.estado < 8) THEN DO:
    
                    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 28064, INPUT item.it-codigo).
                    RUN pi-cria-tt-erro-aux (INPUT 28064, INPUT RETURN-VALUE).
    
                    RETURN "NOK":U.
                END.
            END.
        END.
    &ENDIF
    
    IF NOT l-erro THEN DO:

        CREATE tt-item-new.
        ASSIGN tt-item-new.it-codigo    = item.it-codigo           
               tt-item-new.lote         = tt-param.lote                               
               tt-item-new.dt-vali-lote = tt-param.dt-vali-lote
               tt-item-new.cod-refer    = ""
               tt-item-new.tipo-con-est = 3.
    
        CREATE tt-item-old.
        ASSIGN tt-item-old.it-codigo    = item.it-codigo
               tt-item-old.cod-refer    = item.codigo-refer
               tt-item-old.tipo-con-est = item.tipo-con-est.
    
        ASSIGN i-tipo-con-est-old = item.tipo-con-est.

        RUN pi-acompanhar IN h-acomp ("Atualizando item: " + item.it-codigo).
    
        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
       
            IF l-lote-avancado THEN DO:
       
                FOR EACH saldo-estoq USE-INDEX item
                   WHERE saldo-estoq.it-codigo = item.it-codigo NO-LOCK:
    
                    EMPTY TEMP-TABLE tt-fda-lote-avancad.
                    EMPTY TEMP-TABLE tt-fda-lote-histor.
    
                    CREATE tt-fda-lote-avancad.
                    ASSIGN tt-fda-lote-avancad.it-codigo             = saldo-estoq.it-codigo
                           tt-fda-lote-avancad.cod-estabel           = saldo-estoq.cod-estabel
                           tt-fda-lote-avancad.nr-lote               = saldo-estoq.lote
                           tt-fda-lote-avancad.dt-validade           = saldo-estoq.dt-vali-lote
                           tt-fda-lote-avancad.i-tipo-estado-inicial = 1
                           i-new-tip-con-est                         = 3.
          
                    CREATE tt-fda-lote-histor.
                    ASSIGN tt-fda-lote-histor.dat-alter    = TODAY
                           c-lote-histor = "Altera‡Æo de tipo de controle de estoque de " + {ininc/i01in122.i 04 i-tipo-con-est-old} + 
                                           " para ":u + {ininc/i01in122.i 04 i-new-tip-con-est} + ". Item: " + saldo-estoq.it-codigo
                           tt-fda-lote-histor.hra-alter    = STRING(TIME, "hh:mm:ss").
                  
                    ASSIGN tt-fda-lote-avancad.nr-lote     = tt-param.lote
                           tt-fda-lote-avancad.dt-validade = tt-param.dt-vali-lote.
          
                    RUN pi-executar in h-ceapi028 (INPUT TABLE tt-fda-lote-avancad,
                                                   INPUT TABLE tt-fda-lote-histor,
                                                   INPUT 1,/*movto estoque*/
                                                   INPUT c-lote-histor,
                                                   OUTPUT TABLE tt-erro).
          
                    IF CAN-FIND(FIRST tt-erro) THEN DO:
    
                        RUN pi-cria-tt-erro-aux (INPUT tt-erro.cd-erro, INPUT tt-erro.mensagem).
                        RETURN "NOK":U.
                    END.
                END.
            END.
        &endif
            
        ASSIGN item.tipo-con-est = 3.

        /*WMS*/

        FIND FIRST wm-item 
             WHERE wm-item.cod-item = ITEM.it-codigo NO-ERROR.

        IF AVAIL wm-item THEN DO:

            ASSIGN wm-item.ind-tipo-contr-est = ITEM.tipo-con-est.

        END.
        
        RUN pi-assign.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-tt-erro-aux:

    DEF INPUT PARAM p-cod-erro AS INT                    NO-UNDO.
    DEF INPUT PARAM p-des-erro AS CHAR FORMAT "x(250)":U NO-UNDO.

    FIND FIRST b-tt-erro-aux
         WHERE b-tt-erro-aux.cd-erro   = p-cod-erro
           AND b-tt-erro-aux.it-codigo = item.it-codigo NO-ERROR.

    IF NOT AVAIL b-tt-erro-aux THEN DO:

        CREATE tt-erro-aux.
        ASSIGN i-seq                 = i-seq + 1
               tt-erro-aux.i-sequen  = i-seq
               tt-erro-aux.cd-erro   = p-cod-erro
               tt-erro-aux.mensagem  = p-des-erro
               tt-erro-aux.it-codigo = item.it-codigo.
        
        RUN utp/ut-msgs.p (INPUT "TYPE":U, INPUT p-cod-erro, INPUT p-des-erro).

        CASE {uninc/i01un001.i 06 RETURN-VALUE}:
            WHEN 1 THEN
                ASSIGN tt-erro-aux.sub-type = "ERROR":U
                       l-erro               = YES.
            WHEN 2 THEN
                ASSIGN tt-erro-aux.sub-type = "WARNING":U.
            WHEN 3 THEN
                ASSIGN tt-erro-aux.sub-type = "QUESTION":U.
            WHEN 4 THEN
                ASSIGN tt-erro-aux.sub-type = "INFORMATION":U.
        END CASE.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-assign :

    ASSIGN c-cod-refer = "".

    IF tt-param.i-tipo-exec = 1 THEN DO:

        {esp/esce0111-1.i tt-param.lote c-cod-refer tt-param.dt-vali-lote}
        {esp/esce0111-1.i3}
        {esp/esce0111-1.i4 c-cod-refer}

    END.

    ELSE DO:
        
        {esp/esce0111-2.i tt-param.lote c-cod-refer tt-param.dt-vali-lote}

    END.

END PROCEDURE.
