DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP047RP 2.00.00.000}

&global-define programa ESCPP047RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.

{esp/cpp/escpp047tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* A lilian executa o esrep007 para listar as horas de ggf das OPïs. */
{cdp/cdcfgmat.i}  /* Preprocessador bf_mat_conta_estab */
{cdp/cdcfgman.i}  /* Preprocessador bf_man_linha_estab */

{cpp/cpapi002.i } /* Definicao de temp-tables e variaveis restritos ao programa */
{cpp/cpapi005.i } /* Definicao de temp-tables e variaveis restritos ao programa */
{cdp/cd0666.i   } /* Definicao da temp-table geral tt-erros */

disable triggers for dump of oper-ord.
disable triggers for load of oper-ord.

def var c-linha as char.

def temp-table tt-op
    field nr-ord-prod   like ord-prod.nr-ord-prod.

DEF VAR c-periodo AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-acomp AS HANDLE NO-UNDO.

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-estabel format "x(3)" label "Estab" colon 40
    tt-param.it-codigo   FORMAT "x(16)" LABEL "Item" colon 40
    tt-param.dt-data-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.dt-data-fim format "99/99/9999" no-label
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PAR¶METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELE€ÇO * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESSÇO * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Regerar_GGF * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpcab.i}

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Lendo ":U). 

    for each ord-prod where 
             ord-prod.cod-estabel = tt-param.cod-estabel and
             ord-prod.it-codigo   = tt-param.it-codigo AND
             ord-prod.nr-ord-produ >= tt-param.nr-ord-produ-ini AND
             ord-prod.nr-ord-produ <= tt-param.nr-ord-produ-fim AND
             ord-prod.dt-inicio >= tt-param.dt-data-ini and 
             ord-prod.dt-inicio <= tt-param.dt-data-fim no-lock:

        IF ord-prod.estado <= 6 THEN NEXT.
        
        run pi-acompanhar in h-acomp (input "Lendo ordem ":U + STRING(ord-prod.nr-ord-prod)). 

        create tt-op.
        assign tt-op.nr-ord-prod = ord-prod.nr-ord-prod.
        PUT ord-prod.nr-ord-prod  skip.

    end.

    for each tt-op:
        run pi-acompanhar in h-acomp (input "Regerando GGF OP ":U + STRING(tt-op.nr-ord-prod)). 

        for each movto-ggf
           where movto-ggf.nr-ord-prod = tt-op.nr-ord-prod
             and movto-ggf.dt-trans   >= tt-param.dt-data-ini
             and movto-ggf.dt-trans   <= tt-param.dt-data-fim EXCLUSIVE-LOCK:
            delete movto-ggf.
        end.

        for each oper-ord
           where oper-ord.nr-ord-prod = tt-op.nr-ord-prod EXCLUSIVE-LOCK:
            delete oper-ord.
        end.

        RUN pi-cria-oper-ord.
        RUN pi-acerta-ggf (INPUT tt-param.dt-data-ini, INPUT tt-param.dt-data-fim, INPUT tt-op.nr-ord-prod).

    
    end.

    RUN pi-finalizar IN h-acomp.
end.

page.
    
disp c-liter-sel
     tt-param.cod-estabel
     tt-param.it-codigo
     tt-param.dt-data-ini 
     tt-param.dt-data-fim 
     c-liter-imp
     c-destino
     tt-param.arquivo   
     tt-param.usuario
     with frame f-impressao.
    
    {include/i-rpclo.i}

return "OK".


/* *********************** */
PROCEDURE pi-cria-oper-ord:
    DEF VAR i-estado LIKE ord-prod.estado.

    find ord-prod where ord-prod.nr-ord-prod = tt-op.nr-ord-prod exclusive-lock no-error.
    if avail ord-prod then do:
        ASSIGN i-estado = ord-prod.estado.
        ASSIGN ord-prod.estado = 6.
        FIND ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR. 
    
        FOR EACH operacao NO-LOCK 
            WHERE operacao.it-codigo = ITEM.it-codigo
            AND   operacao.data-inicio  <= TODAY
            AND   operacao.data-termino  > TODAY:

           FIND grup-maquina OF operacao NO-LOCK NO-ERROR.
           IF NOT AVAIL grup-maquina THEN NEXT.
           FIND gm-estab  WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                            and gm-estab.cod-estabel = ord-prod.cod-estabel NO-LOCK.
           FIND centro-custo NO-LOCK 
                WHERE centro-custo.cc-codigo = gm-estab.cc-codigo.
           FIND lin-prod OF ord-prod NO-LOCK.

           CREATE tt-ope.
           ASSIGN tt-ope.nr-ord-produ    = ord-prod.nr-ord-prod
                  tt-ope.c-arquivo1      = ""
                  tt-ope.it-codigo       = operacao.it-codigo
                  tt-ope.cod-roteiro     = operacao.cod-roteiro
                  tt-ope.op-codigo       = operacao.op-codigo
                  tt-ope.descricao-oper  = operacao.descricao
                  tt-ope.tipo-oper       = operacao.tipo-oper
                  tt-ope.gm-codigo       = operacao.gm-codigo
                  tt-ope.revisao-oper    = operacao.revisao
                  tt-ope.fi-codigo       = operacao.fi-codigo
                  tt-ope.pto-controle    = operacao.pto-controle
                  tt-ope.fator-sobrep    = operacao.fator-sobrep
                  tt-ope.proporcao       = operacao.proporcao
                  tt-ope.un-med-tempo    = operacao.un-med-tempo
                  tt-ope.nr-unidades     = ord-prod.qt-ordem       /*operacao.nr-unidades*/
                  tt-ope.tempo-prepar    = operacao.tempo-prepar * tt-ope.nr-unidades   /* / tt-ope.proporcao */
                  tt-ope.tempo-homem     = operacao.tempo-homem  * tt-ope.nr-unidades  /* / tt-ope.proporcao */
                  tt-ope.tempo-maquin    = operacao.tempo-maquin * tt-ope.nr-unidades  /* / tt-ope.proporcao */
                  tt-ope.numero-homem    = operacao.numero-homem
                  tt-ope.emite-ficha     = operacao.emite-ficha
                  tt-ope.oper-cq         = operacao.oper-cq
                  tt-ope.cd-mob-dir      = operacao.cd-mob-dir
                  tt-ope.linha           = 1 .
        end.           
    
        run pi-estrutura (input ord-prod.it-codigo). 
    
        CREATE tt-ord.
        BUFFER-COPY ord-prod TO tt-ord.
        ASSIGN 
                mes-inicio    = MONTH(ord-prod.dt-inicio)
                dia-inicio    = DAY(ord-prod.dt-inicio)
                ano-inicio    = YEAR(ord-prod.dt-inicio) 
                mes-termino   = MONTH(ord-prod.dt-termino) 
                dia-termino   = DAY(ord-prod.dt-termino)   
                ano-termino   = YEAR(ord-prod.dt-termino)  
                mes-emissao   = MONTH(ord-prod.dt-emissao) 
                dia-emissao   = DAY(ord-prod.dt-emissao)   
                ano-emissao   = YEAR(ord-prod.dt-emissao).
    
        ASSIGN tt-ord.nr-ord-prod = ord-prod.nr-ord-prod.
    
        run cpp/cpapi002.p(input table tt-ord,
                           input table tt-res,
                           input table tt-ope,
                           input table tt-lixo,
                           input-output table tt-erros).
        FOR EACH tt-ord:
            DELETE tt-ord.
        END.

        FOR EACH tt-res:
            DELETE tt-res.
        END.

        FOR EACH tt-ope:
            DELETE tt-ope.
        END.
    
        find first tt-erros no-error.
        if avail tt-erros then do:
    /*    run cdp/cd0666.w(input table tt-erros).*/
    
        END.
        ASSIGN ord-prod.estado = i-estado.              
    END.
END PROCEDURE.

procedure pi-estrutura:
    def input param p-it    like item.it-codigo     no-undo.

    for each estrutura 
       where estrutura.it-codigo = p-it 
         and estrutura.fantasma  = yes
         no-lock:

        FOR EACH operacao NO-LOCK 
           where operacao.it-codigo = estrutura.es-codigo
           AND   operacao.data-inicio  >= TODAY
           AND   operacao.data-termino  < TODAY:

               FIND grup-maquina OF operacao NO-LOCK NO-ERROR.
               IF NOT AVAIL grup-maquina THEN NEXT.
               FIND gm-estab  WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                                and gm-estab.cod-estabel = ord-prod.cod-estabel NO-LOCK.
               FIND centro-custo NO-LOCK 
                    WHERE centro-custo.cc-codigo = gm-estab.cc-codigo.
               FIND lin-prod OF ord-prod NO-LOCK.



                create tt-ope.
               ASSIGN tt-ope.nr-ord-produ    = ord-prod.nr-ord-prod
                      tt-ope.c-arquivo1      = ""
                      tt-ope.it-codigo       = operacao.it-codigo
                      tt-ope.cod-roteiro     = operacao.cod-roteiro
                      tt-ope.op-codigo       = operacao.op-codigo
                      tt-ope.descricao-oper  = operacao.descricao
                      tt-ope.tipo-oper       = operacao.tipo-oper
                      tt-ope.gm-codigo       = operacao.gm-codigo
                      tt-ope.revisao-oper    = operacao.revisao
                      tt-ope.fi-codigo       = operacao.fi-codigo
                      tt-ope.pto-controle    = operacao.pto-controle
                      tt-ope.fator-sobrep    = operacao.fator-sobrep
                      tt-ope.proporcao       = operacao.proporcao
                      tt-ope.un-med-tempo    = operacao.un-med-tempo
                      tt-ope.nr-unidades     = ord-prod.qt-ordem       /*operacao.nr-unidades*/
                      tt-ope.tempo-prepar    = operacao.tempo-prepar * tt-ope.nr-unidades   /* / tt-ope.proporcao */
                      tt-ope.tempo-homem     = operacao.tempo-homem  * tt-ope.nr-unidades  /* / tt-ope.proporcao */
                      tt-ope.tempo-maquin    = operacao.tempo-maquin * tt-ope.nr-unidades  /* / tt-ope.proporcao */
                      tt-ope.numero-homem    = operacao.numero-homem
                      tt-ope.emite-ficha     = operacao.emite-ficha
                      tt-ope.oper-cq         = operacao.oper-cq
                      tt-ope.cd-mob-dir      = operacao.cd-mob-dir
                      tt-ope.linha           = 1 .
        END.

        run pi-estrutura (input estrutura.es-codigo).
    end.    
end procedure.


PROCEDURE pi-acerta-ggf:
    DEF input parameter da-data-ini AS DATE.
    DEF input parameter da-data-fim AS DATE.
    def input parameter nr-op       like ord-prod.nr-ord-prod.

    DEF VAR i-num LIKE movto-ggf.num-id-movto-ggf.

    FIND LAST movto-ggf NO-LOCK
        WHERE movto-ggf.num-id-movto-ggf < 317798  NO-ERROR. /* primeiro numero gerado pelo EMS */
    
    IF NOT AVAIL movto-ggf THEN DO:
        FIND movto-ggf NO-LOCK 
             WHERE movto-ggf.num-id-movto-ggf = 1 NO-ERROR.
        IF NOT AVAIL movto-ggf  THEN
            ASSIGN i-num = 1.
        ELSE DO:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro = 15825
                   tt-erro.mensagem = "NÆo ‚ poss¡vel executar o programa. Solicite atualiza‡Æo para Inform tica".
            NEXT.
        END.
    END.
    ELSE ASSIGN i-num = movto-ggf.num-id-movto-ggf + 1.
    
    /* MOVIMENTA€ÇO PARA ITENS QUE POSSUEM OPERA€åES */
    
    FOR EACH movto-estoq NO-LOCK
       WHERE movto-estoq.dt-trans >= da-data-ini
         AND movto-estoq.dt-trans <= da-data-fim
        AND (movto-estoq.esp-docto = 1 /* ACA */
         OR movto-estoq.esp-docto = 8 /* EAC */   )
        AND movto-estoq.nr-ord-prod = nr-op: 
        
        FIND ITEM NO-LOCK WHERE item.it-codigo = movto-estoq.it-codigo.

        /* desconsidera itens alternativos - o tempo est  no item alternativo */
        FIND FIRST it-altern 
             WHERE it-altern.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL it-altern THEN NEXT.
        
        FIND ord-prod NO-LOCK WHERE ord-prod.nr-ord-prod =  movto-estoq.nr-ord-prod.
    
    /* REATIVAR ANTES DE EXECUTAR PRA VALER */
       FIND FIRST movto-ggf WHERE movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK NO-ERROR.
       IF AVAIL movto-ggf THEN NEXT.
      
       FIND FIRST operacao OF ITEM NO-LOCK NO-ERROR.
       IF NOT AVAIL operacao THEN NEXT.
    
       
       for each oper-ord no-lock
          where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod:
            find first operacao
                 where operacao.it-codigo = oper-ord.it-codigo
                   and operacao.op-codigo = oper-ord.op-codigo
                   no-lock no-error.
            if not avail operacao
            then next.
      
            FIND grup-maquina OF operacao NO-LOCK NO-ERROR.
            IF NOT AVAIL grup-maquina THEN NEXT.
            FIND gm-estab  WHERE gm-estab.gm-codigo = grup-maquina.gm-codigo
                             and gm-estab.cod-estabel = ord-prod.cod-estabel   NO-LOCK.
       
            FIND centro-custo NO-LOCK 
                 WHERE centro-custo.cc-codigo = gm-estab.cc-codigo.
      
            FIND lin-prod OF ord-prod NO-LOCK.
                 
            CREATE tt-movto-ggf.
            ASSIGN
                tt-movto-ggf.cc-codigo        = gm-estab.cc-codigo
                tt-movto-ggf.cd-tarefa        = 0
                tt-movto-ggf.cd-tecnico       = ""
                tt-movto-ggf.cd-turno         = ""
                tt-movto-ggf.cod-roteiro      = ""
                tt-movto-ggf.conta-cr-ggf[1]  = centro-custo.ct-codigo[1] + centro-custo.sc-codigo[1]
                tt-movto-ggf.conta-cr-ggf[2]  = centro-custo.ct-codigo[2] + centro-custo.sc-codigo[2]
                tt-movto-ggf.conta-cr-ggf[3]  = centro-custo.ct-codigo[3] + centro-custo.sc-codigo[3]
                tt-movto-ggf.conta-cr-ggf[4]  = centro-custo.ct-codigo[4] + centro-custo.sc-codigo[4]
                tt-movto-ggf.conta-cr-ggf[5]  = centro-custo.ct-codigo[5] + centro-custo.sc-codigo[5]
                tt-movto-ggf.conta-cr-ggf[6]  = centro-custo.ct-codigo[6] + centro-custo.sc-codigo[6]
                tt-movto-ggf.conta-ordem      = lin-prod.conta-ordem 
                tt-movto-ggf.crp-atual        = NO
                tt-movto-ggf.ct-cr-ggf[1]     = centro-custo.ct-codigo[1]
                tt-movto-ggf.ct-cr-ggf[2]     = centro-custo.ct-codigo[2]
                tt-movto-ggf.ct-cr-ggf[3]     = centro-custo.ct-codigo[3]
                tt-movto-ggf.ct-cr-ggf[4]     = centro-custo.ct-codigo[4]
                tt-movto-ggf.ct-cr-ggf[5]     = centro-custo.ct-codigo[5]
                tt-movto-ggf.ct-cr-ggf[6]     = centro-custo.ct-codigo[6]
                tt-movto-ggf.ct-ordem         = lin-prod.ct-ordem.
                
               
            
              ASSIGN
                tt-movto-ggf.db-cr-ok         = NO
                tt-movto-ggf.dt-retorno       = movto-estoq.dt-trans
                tt-movto-ggf.dt-trans         = movto-estoq.dt-trans
                tt-movto-ggf.gm-codigo        = grup-maquina.gm-codigo
                tt-movto-ggf.horas-report     = (oper-ord.tempo-homem * movto-estoq.quantidade / oper-ord.nr-unidades) / 60
                                                /*operacao.tempo-homem / operacao.numero-homem * movto-estoq.quantidade / 60 */
                tt-movto-ggf.it-codigo        = oper-ord.it-codigo
                tt-movto-ggf.lote             = ""
                tt-movto-ggf.matr-func        = 0
                tt-movto-ggf.narrativa        = ""
                tt-movto-ggf.nr-ord-produ     = movto-estoq.nr-ord-produ
                tt-movto-ggf.nr-reporte       = movto-estoq.nr-reporte
                tt-movto-ggf.nr-req-sum       = 0
                tt-movto-ggf.nr-up-report     = 0
                tt-movto-ggf.nro-docto        = movto-estoq.nro-docto
                tt-movto-ggf.num-ord-inv      = 0
                tt-movto-ggf.op-codigo        = operacao.op-codigo
                tt-movto-ggf.op-seq           = 0
                tt-movto-ggf.qt-pecas-boas    = movto-estoq.quantidade
                tt-movto-ggf.qt-refugo        = 0
                tt-movto-ggf.refer-contab     = ""
                .
            
              ASSIGN
                tt-movto-ggf.referencia       = ""
                tt-movto-ggf.sc-cr-ggf[1]     = centro-custo.sc-codigo[1]
                tt-movto-ggf.sc-cr-ggf[2]     = centro-custo.sc-codigo[2]
                tt-movto-ggf.sc-cr-ggf[3]     = centro-custo.sc-codigo[3]
                tt-movto-ggf.sc-cr-ggf[4]     = centro-custo.sc-codigo[4]
                tt-movto-ggf.sc-cr-ggf[5]     = centro-custo.sc-codigo[5]
                tt-movto-ggf.sc-cr-ggf[6]     = centro-custo.sc-codigo[6]
                tt-movto-ggf.sc-ordem         = lin-prod.sc-ordem
                tt-movto-ggf.serie-docto      = movto-estoq.serie-docto
                tt-movto-ggf.tempo-limp       = 0
                tt-movto-ggf.tempo-maquin     = 0
                tt-movto-ggf.tempo-prepar     = 0
                tt-movto-ggf.tempo-trans      = 0
                tt-movto-ggf.tipo-valor       = 0
                tt-movto-ggf.tp-especial      = "" 
                tt-movto-ggf.tipo-trans       = IF movto-estoq.esp-docto = 1 THEN 1 ELSE 2
                tt-movto-ggf.hr-trans         = movto-estoq.hr-trans
                tt-movto-ggf.hr-contab        = movto-estoq.hr-contab
                tt-movto-ggf.dt-contab        = movto-estoq.dt-contab
                tt-movto-ggf.contabilizado    = movto-estoq.contabilizado
                tt-movto-ggf.cd-equipto       = ""
                tt-movto-ggf.cod-estabel      = movto-estoq.cod-estabel
                tt-movto-ggf.tipo-oper        = 0
                tt-movto-ggf.qt-reportada     = movto-estoq.quantidade
                tt-movto-ggf.cod-versao-integracao = 001
                tt-movto-ggf.num-id-movto-ggf = i-num
                i-num = i-num + 1.   

            ASSIGN tt-movto-ggf.gm-codigo = operacao.gm-codigo.
        
        /*    DISP tt-movto-ggf EXCEPT
    
            rw-movto-ggf   
            cria-ext-ord   
            lg-recalc-horas
            rw-mov-orig                WITH WIDTH 300 1 COL.
         */
        END.
    END.
        
    /* MOVIMENTA€ÇO PARA ITENS QUE POSSUEM ROTEIROS */
    
    FOR each movto-estoq NO-LOCK
       WHERE movto-estoq.dt-trans >= da-data-ini
         AND movto-estoq.dt-trans <= da-data-fim
        AND (movto-estoq.esp-docto = 1 /* ACA */
         OR movto-estoq.esp-docto = 8 /* EAC */  ) 
        AND movto-estoq.nr-ord-prod = nr-op
        :
        
        
           /* desconsidera itens alternativos - o tempo est  no item alternativo */
        FIND FIRST it-altern 
             WHERE it-altern.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL it-altern THEN NEXT.
    
        FIND ord-prod NO-LOCK 
            WHERE ord-prod.nr-ord-prod =  movto-estoq.nr-ord-prod.
    
    /*    DISP ord-prod.dt-inicio.
      */
    
    /* REATIVAR ANTES DE EXECUTAR PRA VALER  */
       FIND FIRST movto-ggf WHERE movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK NO-ERROR.
       IF AVAIL movto-ggf THEN NEXT.
       
       FIND FIRST rot-item NO-LOCK OF ITEM NO-ERROR.
       IF NOT AVAIL rot-item THEN NEXT.
       FIND FIRST oper-ord 
            WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK NO-ERROR.
    
       IF NOT AVAIL oper-ord THEN DO:
           RUN pi-cria-operacao-ordem (INPUT ord-prod.nr-ord-prod, INPUT movto-estoq.dt-trans).
           
       END.
                                            
      /*  OUTPUT TO c:\temp\xx.
        FOR EACH movto-ggf WHERE movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod
             AND movto-ggf.dt-trans = movto-estoq.dt-trans 
                    AND movto-ggf.nr-reporte = movto-estoq.nr-reporte
            NO-LOCK      
            BY movto-ggf.op-codigo:
            DISP movto-ggf WITH WIDTH 300 1 COL.
        END.
        OUTPUT CLOSE.
        */

        FOR EACH ROT-ITEM NO-LOCK OF ITEM .
            FOR EACH  OPERACAO 
                WHERE OPERACAO.cod-roteiro = ROT-ITEM.cod-roteiro 
                AND   operacao.data-inicio >= TODAY
                AND   operacao.data-termino < TODAY NO-LOCK
                 BY operacao.op-codigo.
    
          /*      DISP operacao.gm-codigo.
                */
                FIND grup-maquina OF operacao NO-LOCK NO-ERROR.
                IF NOT AVAIL grup-maquina  THEN NEXT.
                FIND gm-estab  WHERE gm-estab.gm-codigo   = grup-maquina.gm-codigo
                                 and gm-estab.cod-estabel = ord-prod.cod-estabel  NO-LOCK.
           /*     DISP gm-estab.cc-codigo.
                */
                FIND centro-custo NO-LOCK 
                     WHERE centro-custo.cc-codigo = gm-estab.cc-codigo.
          /*      DISP centro-custo.ct-codigo[1] + centro-custo.sc-codigo[1] FORMAT "x(20)".
            */
                FIND lin-prod OF ord-prod NO-LOCK.
             /*   DISP lin-prod.ct-ordem.
               */
                CREATE tt-movto-ggf.
                ASSIGN
                    tt-movto-ggf.cc-codigo        = gm-estab.cc-codigo
                    tt-movto-ggf.cd-tarefa        = 0
                    tt-movto-ggf.cd-tecnico       = ""
                    tt-movto-ggf.cd-turno         = ""
                    tt-movto-ggf.cod-roteiro      = rot-item.cod-roteiro
                    tt-movto-ggf.conta-cr-ggf[1]  = centro-custo.ct-codigo[1] + centro-custo.sc-codigo[1]
                    tt-movto-ggf.conta-cr-ggf[2]  = centro-custo.ct-codigo[2] + centro-custo.sc-codigo[2]
                    tt-movto-ggf.conta-cr-ggf[3]  = centro-custo.ct-codigo[3] + centro-custo.sc-codigo[3]
                    tt-movto-ggf.conta-cr-ggf[4]  = centro-custo.ct-codigo[4] + centro-custo.sc-codigo[4]
                    tt-movto-ggf.conta-cr-ggf[5]  = centro-custo.ct-codigo[5] + centro-custo.sc-codigo[5]
                    tt-movto-ggf.conta-cr-ggf[6]  = centro-custo.ct-codigo[6] + centro-custo.sc-codigo[6]
                    tt-movto-ggf.conta-ordem      = lin-prod.conta-ordem 
                    tt-movto-ggf.crp-atual        = NO
                    tt-movto-ggf.ct-cr-ggf[1]     = centro-custo.ct-codigo[1]
                    tt-movto-ggf.ct-cr-ggf[2]     = centro-custo.ct-codigo[2]
                    tt-movto-ggf.ct-cr-ggf[3]     = centro-custo.ct-codigo[3]
                    tt-movto-ggf.ct-cr-ggf[4]     = centro-custo.ct-codigo[4]
                    tt-movto-ggf.ct-cr-ggf[5]     = centro-custo.ct-codigo[5]
                    tt-movto-ggf.ct-cr-ggf[6]     = centro-custo.ct-codigo[6]
                    tt-movto-ggf.ct-ordem         = lin-prod.ct-ordem.
                    
                   
                
                  ASSIGN
                    tt-movto-ggf.db-cr-ok         = NO
                    tt-movto-ggf.dt-retorno       = movto-estoq.dt-trans
                    tt-movto-ggf.dt-trans         = movto-estoq.dt-trans
                    tt-movto-ggf.gm-codigo        = grup-maquina.gm-codigo
                    tt-movto-ggf.horas-report     = (oper-ord.tempo-homem * movto-estoq.quantidade / oper-ord.nr-unidades) / 60
                                                    /* operacao.tempo-homem / operacao.nr-unidades * movto-estoq.quantidade / 60 */
                    tt-movto-ggf.it-codigo        = movto-estoq.it-codigo
                    tt-movto-ggf.lote             = ""
                    tt-movto-ggf.matr-func        = 0
                    tt-movto-ggf.narrativa        = ""
                    tt-movto-ggf.nr-ord-produ     = movto-estoq.nr-ord-produ
                    tt-movto-ggf.nr-reporte       = movto-estoq.nr-reporte
                    tt-movto-ggf.nr-req-sum       = 0
                    tt-movto-ggf.nr-up-report     = 0
                    tt-movto-ggf.nro-docto        = movto-estoq.nro-docto
                    tt-movto-ggf.num-ord-inv      = 0
                    tt-movto-ggf.op-codigo        = operacao.op-codigo
                    tt-movto-ggf.op-seq           = 0
                    tt-movto-ggf.qt-pecas-boas    = movto-estoq.quantidade
                    tt-movto-ggf.qt-refugo        = 0
                    tt-movto-ggf.refer-contab     = ""
                    .
                
                  ASSIGN
                    tt-movto-ggf.referencia       = ""
                    tt-movto-ggf.sc-cr-ggf[1]     = centro-custo.sc-codigo[1]
                    tt-movto-ggf.sc-cr-ggf[2]     = centro-custo.sc-codigo[2]
                    tt-movto-ggf.sc-cr-ggf[3]     = centro-custo.sc-codigo[3]
                    tt-movto-ggf.sc-cr-ggf[4]     = centro-custo.sc-codigo[4]
                    tt-movto-ggf.sc-cr-ggf[5]     = centro-custo.sc-codigo[5]
                    tt-movto-ggf.sc-cr-ggf[6]     = centro-custo.sc-codigo[6]
                    tt-movto-ggf.sc-ordem         = lin-prod.sc-ordem
                    tt-movto-ggf.serie-docto      = movto-estoq.serie-docto
                    tt-movto-ggf.tempo-limp       = 0
                    tt-movto-ggf.tempo-maquin     = 0
                    tt-movto-ggf.tempo-prepar     = 0
                    tt-movto-ggf.tempo-trans      = 0
                    tt-movto-ggf.tipo-valor       = 0
                    tt-movto-ggf.tp-especial      = "" 
                    tt-movto-ggf.tipo-trans       = IF movto-estoq.esp-docto = 1 THEN 1 ELSE 2
                    tt-movto-ggf.hr-trans         = movto-estoq.hr-trans
                    tt-movto-ggf.hr-contab        = movto-estoq.hr-contab
                    tt-movto-ggf.dt-contab        = movto-estoq.dt-contab
                    tt-movto-ggf.contabilizado    = movto-estoq.contabilizado
                    tt-movto-ggf.cd-equipto       = ""
                    tt-movto-ggf.cod-estabel      = movto-estoq.cod-estabel
                    tt-movto-ggf.tipo-oper        = 0
                    tt-movto-ggf.qt-reportada     = movto-estoq.quantidade
                    tt-movto-ggf.cod-versao-integracao = 001
                    tt-movto-ggf.num-id-movto-ggf = i-num
                    i-num = i-num + 1
                      .

                ASSIGN tt-movto-ggf.gm-codigo = operacao.gm-codigo.
            
            END.
        END.
    END.
    
    FOR EACH tt-movto-ggf BY tt-movto-ggf.op-codigo:
        DISP tt-movto-ggf EXCEPT
            rw-movto-ggf   
            cria-ext-ord   
            lg-recalc-horas
            rw-mov-orig                WITH WIDTH 132 1 COL.
    END.
    
    run cpp/cpapi005.p (input-output table tt-movto-ggf, 
                        input-output table tt-erro, 
                        input yes).
    
    FOR EACH tt-movto-ggf:
        DELETE tt-movto-ggf.
    END.

    find first tt-erro no-error.
    if avail tt-erro then do:
        /*run cdp/cd0666.w(input table tt-erro).*/
        FOR EACH tt-erro:
            DISP tt-erro.cd-erro
                 tt-erro.mensagem FORMAT "x(60)" WITH WIDTH 132.
        END.
    END.
END PROCEDURE.


PROCEDURE pi-cria-operacao-ordem:
    /* 27/06/05 COPY assignment */

    DEF INPUT PARAMETER i-ord LIKE ord-prod.nr-ord-prod.
    DEF INPUT PARAMETER da-data LIKE movto-estoq.dt-trans.

    DEF VAR i-seq AS INT.                                          

    ASSIGN i-seq = 0.

    FOR EACH ROT-ITEM NO-LOCK 
       WHERE rot-item.it-codigo = ord-prod.it-codigo.
        FOR EACH  OPERACAO no-lock
           WHERE OPERACAO.cod-roteiro = ROT-ITEM.cod-roteiro
           AND   operacao.data-inicio >= TODAY
           AND   operacao.data-termino < TODAY:
            RUN cria-operacao.
        END.
    END.
    FOR EACH operacao NO-LOCK 
       WHERE operacao.it-codigo = ord-prod.it-codigo
       AND   operacao.data-inicio >= TODAY
       AND   operacao.data-termino < TODAY:
        ASSIGN i-seq = i-seq + 1.

        DO:

        CREATE oper-ord.
      ASSIGN
        oper-ord.nr-ord-produ          = i-ord
        oper-ord.op-codigo             = operacao.op-codigo
        oper-ord.descricao             = operacao.descricao
        oper-ord.tipo-oper             = operacao.tipo-oper
        oper-ord.gm-codigo             = operacao.gm-codigo
        oper-ord.revisao               = operacao.revisao
        oper-ord.fi-codigo             = operacao.fi-codigo
        oper-ord.pto-controle          = operacao.pto-controle
        oper-ord.nr-unidades           = ord-prod.qt-ordem
        oper-ord.fator-sobrep          = operacao.fator-sobrep
        oper-ord.un-med-tempo          = operacao.un-med-tempo
        oper-ord.proporcao             = operacao.proporcao
        oper-ord.tempo-prepar          = operacao.tempo-prepar
        oper-ord.tempo-homem           = operacao.tempo-homem * ord-prod.qt-ordem
        oper-ord.tempo-maquin          = operacao.tempo-maquin * ord-prod.qt-ordem
        oper-ord.numero-homem          = operacao.numero-homem
        oper-ord.emite-ficha           = operacao.emite-ficha
        .

     /*   
          oper-ord.preco-base            = operacao.preco-base
        oper-ord.preco-ul-ent          = operacao.preco-ul-ent.
       */
      ASSIGN
      /*  oper-ord.preco-repos           = operacao.preco-repos
        oper-ord.preco-medio[1]        = operacao.preco-medio[1]
        oper-ord.preco-medio[2]        = operacao.preco-medio[2]
        oper-ord.preco-medio[3]        = operacao.preco-medio[3]
        oper-ord.data-ult-ent          = operacao.data-ult-ent
        oper-ord.data-ult-rep          = operacao.data-ult-rep
        */
        oper-ord.it-codigo             = ord-prod.it-codigo
        oper-ord.refugo-op             = operacao.refugo-op
        oper-ord.cod-roteiro           = operacao.cod-roteiro
      /*  oper-ord.op-altern             = operacao.op-altern
        */
        oper-ord.sequencia             = i-seq
        oper-ord.qt-produzida          = ord-prod.qt-produzida
        oper-ord.estado                = ord-prod.estado
        .

     /*   oper-ord.qt-refugada           = operacao.qt-refugada
        oper-ord.qt-apr-cond           = operacao.qt-apr-cond


        oper-ord.dt-reporte            = operacao.dt-reporte
        oper-ord.h-inireal             = operacao.h-inireal
        oper-ord.h-fimreal             = operacao.h-fimreal
        oper-ord.dt-inireal            = operacao.dt-inireal
        oper-ord.dt-fimreal            = operacao.dt-fimreal.
          */
      ASSIGN
      /*  oper-ord.form-hom              = operacao.form-hom
        oper-ord.form-maq              = operacao.form-maq
        oper-ord.oper-cq               = operacao.oper-cq
        oper-ord.nr-ups                = operacao.nr-ups
        oper-ord.nr-up-rep             = operacao.nr-up-rep
        oper-ord.tempo-hom-rep         = operacao.tempo-hom-rep
        oper-ord.tempo-maq-rep         = operacao.tempo-maq-rep
        oper-ord.tempo-prep-rep        = operacao.tempo-prep-rep
        oper-ord.form-prep             = operacao.form-prep
        oper-ord.nr-req-sum            = operacao.nr-req-sum
        oper-ord.nr-ord-refer          = operacao.nr-ord-refer
        */
        oper-ord.num-id-operacao       = operacao.num-id-operacao
      /*  oper-ord.cd-mob-dir            = operacao.cd-mob-dir
        oper-ord.nr-estrut             = operacao.nr-estrut
        oper-ord.char-2                = operacao.char-2
        */
        oper-ord.dec-1                 = 100
       /* 
          oper-ord.dec-2                 = operacao.dec-2
        oper-ord.int-1                 = operacao.int-1
        oper-ord.int-2                 = operacao.int-2.*/
        .

      ASSIGN
      /*  oper-ord.log-1                 = operacao.log-1
        oper-ord.log-2                 = operacao.log-2
        oper-ord.data-1                = operacao.data-1
        oper-ord.data-2                = operacao.data-2
        oper-ord.check-sum             = operacao.check-sum
        oper-ord.ind-reporte-cq        = operacao.ind-reporte-cq
        */
        oper-ord.num-operac-sfc        = i-seq

        oper-ord.log-operac-inic       = IF i-seq = 1 THEN YES ELSE NO
      /*  oper-ord.log-operac-final      = operacao.log-operac-final
        oper-ord.log-restric-operac    = operacao.log-restric-operac
        */
        oper-ord.log-restric-pert      = YES
     /*   oper-ord.val-perc-avanco       = operacao.val-perc-avanco
        oper-ord.val-priorid-int       = operacao.val-priorid-int
        oper-ord.val-priorid-ext       = operacao.val-priorid-ext
        oper-ord.dat-imc-operac        = operacao.dat-imc-operac
        oper-ord.qtd-segs-imc-operac   = operacao.qtd-segs-imc-operac
        oper-ord.dat-fmt-operac        = operacao.dat-fmt-operac
        oper-ord.qtd-segs-fmt-operac   = operacao.qtd-segs-fmt-operac
        oper-ord.qtd-aprov-sfc         = operacao.qtd-aprov-sfc
        oper-ord.qtd-retrab-sfc        = operacao.qtd-retrab-sfc.
       */
        .
      ASSIGN
     /*   oper-ord.qtd-refgda-sfc        = operacao.qtd-refgda-sfc
        oper-ord.qtd-reptda-sfc        = operacao.qtd-reptda-sfc
        oper-ord.log-fecha-operac      = operacao.log-fecha-operac
      */
        oper-ord.qtd-previs-operac     = ord-prod.qt-ordem
     /*   oper-ord.log-reporte-cp        = operacao.log-reporte-cp
        oper-ord.dat-inic-gantt        = operacao.dat-inic-gantt
        oper-ord.qtd-hora-inic-gantt   = operacao.qtd-hora-inic-gantt
        oper-ord.dat-fim-gantt         = operacao.dat-fim-gantt
        oper-ord.qtd-hora-fim-gantt    = operacao.qtd-hora-fim-gantt
        oper-ord.cod-un-operac         = operacao.cod-un-operac
        oper-ord.qtd-tempo-pos-proces  = operacao.qtd-tempo-pos-proces
        oper-ord.cod-grp-setup         = operacao.cod-grp-setup
        oper-ord.qtd-carga-batch       = operacao.qtd-carga-batch
        oper-ord.qtd-pallet-produt     = operacao.qtd-pallet-produt
        oper-ord.val-operac-item       = operacao.val-operac-item
        oper-ord.val-compon-item       = operacao.val-compon-item
        oper-ord.ind-tempo-operac      = operacao.ind-tempo-operac
        */
        oper-ord.qtd-capac-operac      = ord-prod.qt-ordem

        oper-ord.dat-liber-operac      = da-data
        .

       /* oper-ord.qtd-segs-liber-operac = operacao.qtd-segs-liber-operac.

      ASSIGN
        oper-ord.log-operac-finaliz    = operacao.log-operac-finaliz.

    */  
    END.
    END.
END PROCEDURE.
