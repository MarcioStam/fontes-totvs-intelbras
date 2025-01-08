/***********************************************************************
**  Programa..: ESP\REP\ESCEP028RP.P
**  Autor.....: Rubia Ayabe de Oliveira
**  Data......: Outubro/2015
**  Descricao.: CARTEIRA POR DATA DE ENTREGA / DEPOSITO
**  VersÆo....: 001 08/10/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP028 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cep/escep028tt.i}
{esp/es0018.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-carteira
    field it-codigo  like item.it-codigo
    field cd-gr-com  AS CHARACTER FORMAT "x(3)"
    field cd-sub-com AS CHARACTER FORMAT "x(4)"
    field saldo-fisico as int
    field saldo-res-ped    as int
    field saldo-res-nota   as int
    field saldo-cart   as int
    field saldo        as int
    field estoque      as int
    field bloq         as int
    FIELD estoque-exp  AS INT
    FIELD estoque-aca  AS INT
    index grupo is primary unique cd-gr-com cd-sub-com it-codigo
    index item it-codigo.


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
DEFINE VARIABLE c-estoque AS CHARACTER   NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "CARTEIRA POR DATA DE ENTREGA/DEPOSITO"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP028"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:

    IF OPSYS = 'unix' THEN DO:
        RUN esp/es0018p.p (INPUT "spool-unix":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
            
        FIND FIRST tt-prog-ponto NO-ERROR.

        OUTPUT TO value(tt-prog-ponto.conteudo + "/" + c-seg-usuario + "/ESCEP028.csv")  PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    END.
    ELSE
        OUTPUT TO VALUE(tt-param.arquivo) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.

    run utp/ut-acomp.p persistent set h-acomp.  
    FOR EACH deposito NO-LOCK:
        IF tt-param.c-depositos MATCHES('*' + deposito.cod-depos + '*') THEN DO:
            CREATE tt-depositos.
            ASSIGN tt-depositos.cod-depos = deposito.cod-depos.
        END.
    END.

    RUN piMontaRelat.
    RUN imprime-relatorio.

    RUN pi-finalizar in h-acomp.
    OUTPUT CLOSE.
    RETURN "OK".
end.

PROCEDURE piMontaRelat:
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

/*     FOR FIRST param-estoq NO-LOCK: */
/*     END. */
/*    */
    
    FOR EACH item NO-LOCK
       WHERE item.it-codigo >= tt-param.ini-it-codigo
         AND item.it-codigo <= tt-param.fim-it-codigo:
        
        FIND FIRST fam-comerc NO-LOCK
             WHERE fam-comerc.fm-cod-com = item.fm-cod-com
               AND fam-comerc.fm-cod-com >= tt-param.ini-familia 
               AND fam-comerc.fm-cod-com <= tt-param.fim-familia NO-ERROR.

        IF item.fm-cod-com <> "" THEN DO:
            IF NOT AVAIL fam-comerc THEN
                NEXT.
        END.
   
        RUN pi-acompanhar in h-acomp (input item.it-codigo).
        
        find first item-uni-estab
              where item-uni-estab.it-codigo        = item.it-codigo
                and item-uni-estab.cod-estabel     >= tt-param.cod-estabel-ini 
                and item-uni-estab.cod-estabel     <= tt-param.cod-estabel-fim
                AND item-uni-estab.cod-unid-negoc  >= tt-param.cod-unid-negoc-ini 
                AND item-uni-estab.cod-unid-negoc  <= tt-param.cod-unid-negoc-fim
              no-lock no-error.
       
        IF NOT AVAIL item-uni-estab  THEN 
            NEXT.

        IF AVAIL fam-comerc THEN
            find first tt-carteira
                 where tt-carteira.it-codigo  = item.it-codigo
                 and   tt-carteira.cd-gr-com  = substring(fam-comerc.fm-cod-com,1,5) 
                 and   tt-carteira.cd-sub-com = substring(fam-comerc.fm-cod-com,1,7) no-lock no-error.
        ELSE 
             find first tt-carteira
                  where tt-carteira.it-codigo  = item.it-codigo no-lock no-error.

        if not avail tt-carteira then do:

            create tt-carteira.
            assign tt-carteira.it-codigo  = item.it-codigo
                   tt-carteira.cd-gr-com  = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,5) ELSE ""
                   tt-carteira.cd-sub-com = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,7) ELSE "".
                    
            FOR EACH tt-depositos EXCLUSIVE-LOCK:

                for each  saldo-estoq no-lock 
                     where saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini 
                     and   saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
                     and   saldo-estoq.cod-depos   = tt-depositos.cod-depos
                     and   saldo-estoq.it-codigo   = item.it-codigo:

                    IF saldo-estoq.cod-localiz = "cst" THEN NEXT.

                    assign tt-carteira.saldo-fisico   = tt-carteira.saldo-fisico   + saldo-estoq.qtidade-atu
                           tt-carteira.saldo-res-nota = tt-carteira.saldo-res-nota + saldo-estoq.qt-alocada.

                    IF AVAIL fam-comerc THEN
                        FIND FIRST tt-carteiraDep
                            WHERE  tt-carteiraDep.it-codigo  = item.it-codigo                      
                              AND  tt-carteiraDep.cd-gr-com  = substring(fam-comerc.fm-cod-com,1,5) 
                              AND  tt-carteiraDep.cd-sub-com = substring(fam-comerc.fm-cod-com,1,7) 
                              AND  tt-carteiraDep.cod-depos  = saldo-estoq.cod-depos NO-LOCK NO-ERROR.
                    ELSE 
                        FIND FIRST tt-carteiraDep
                            WHERE  tt-carteiraDep.it-codigo  = item.it-codigo                      
                              AND  tt-carteiraDep.cod-depos  = saldo-estoq.cod-depos NO-LOCK NO-ERROR.

                    IF NOT AVAIL tt-carteiraDep THEN DO:
                        CREATE tt-carteiraDep.
                        ASSIGN tt-carteiraDep.it-codigo   = item.it-codigo
                               tt-carteiraDep.cd-gr-com   = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,5) ELSE ""
                               tt-carteiraDep.cd-sub-com  = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,7) ELSE ""
                               tt-carteiraDep.cod-depos   = saldo-estoq.cod-depos
                               tt-carteiraDep.qtidade-atu = 0. 
                    END. /* IF NOT AVAIL tt-carteiraDep THEN DO: */
                    
                    ASSIGN tt-carteiraDep.qtidade-atu = tt-carteiraDep.qtidade-atu + saldo-estoq.qtidade-atu.

                end. /* for each  saldo-estoq no-lock */

                IF AVAIL fam-comerc THEN
                    FIND FIRST tt-carteiraDep
                        WHERE  tt-carteiraDep.it-codigo  = item.it-codigo                      
                          AND  tt-carteiraDep.cd-gr-com  = substring(fam-comerc.fm-cod-com,1,5) 
                          AND  tt-carteiraDep.cd-sub-com = substring(fam-comerc.fm-cod-com,1,7) 
                          AND  tt-carteiraDep.cod-depos  = tt-depositos.cod-depos NO-LOCK NO-ERROR.
                ELSE
                    FIND FIRST tt-carteiraDep
                        WHERE  tt-carteiraDep.it-codigo  = item.it-codigo                      
                          AND  tt-carteiraDep.cod-depos  = tt-depositos.cod-depos NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-carteiraDep THEN DO:
                    CREATE tt-carteiraDep.
                    ASSIGN tt-carteiraDep.it-codigo   = item.it-codigo
                           tt-carteiraDep.cd-gr-com   = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,5) ELSE ""
                           tt-carteiraDep.cd-sub-com  = IF AVAIL fam-comerc THEN substring(fam-comerc.fm-cod-com,1,7) ELSE ""
                           tt-carteiraDep.cod-depos   = tt-depositos.cod-depos
                           tt-carteiraDep.qtidade-atu = 0. 
                END. /* IF NOT AVAIL tt-carteiraDep THEN DO: */


            END. /* FOR EACH tt-depositos EXCLUSIVE-LOCK: */

        end. /* if not avail tt-carteira then do: */
        /*************************************************************************/
        /******** abaixo exitem 2 for each do ped-item a diferenca entre 1 e ****/
        /******** eh o ped-item.cod-sit-item, pois se usar or a leitura fica ***/
        /******** lenta */
        
        for each ped-item no-lock use-index planejamento
            where ped-item.it-codigo         = item.it-codigo
              and ped-item.cod-refer         = ""
              and ped-item.cod-sit-item     <= 2
              and ped-item.dt-entrega       >= tt-param.ini-data
              and ped-item.dt-entrega       <= tt-param.fim-data
              AND ped-item.cod-unid-negoc   >= tt-param.cod-unid-negoc-ini
              AND ped-item.cod-unid-negoc   <= tt-param.cod-unid-negoc-fim
              and (ped-item.qt-pedida - ped-item.qt-atendida) > 0,
            first ped-venda of ped-item
               where (ped-venda.cod-sit-ped <= 2 
                  or  ped-venda.cod-sit-ped  = 5)
                 AND ped-venda.cod-estabel  >=  tt-param.cod-estabel-ini 
                 AND ped-venda.cod-estabel  <=  tt-param.cod-estabel-fim no-lock, 
            first repres
               where repres.nome-abrev       = ped-venda.no-ab-reppri
               and   repres.cod-rep         >= tt-param.ini-rep
               and   repres.cod-rep         <= tt-param.fim-rep no-lock,
            first natur-oper
                  where natur-oper.nat-operacao = ped-item.nat-operacao 
                    and natur-oper.baixa-est no-lock:

            IF ped-venda.cod-priori = 44 THEN NEXT. /* Or‡amento */
     
            if ped-item.qt-log-aloca <> 0 then
               assign tt-carteira.saldo-res-ped = tt-carteira.saldo-res-ped + ped-item.qt-log-aloca.
    
            assign tt-carteira.saldo-cart = tt-carteira.saldo-cart
                                          + (ped-item.qt-pedida -
                                             ped-item.qt-atendida).
        end.
  
        for each ped-item no-lock use-index planejamento
            where ped-item.it-codigo         = item.it-codigo
              and ped-item.cod-refer         = ""
              and ped-item.cod-sit-item      = 5
              and (ped-item.qt-pedida - ped-item.qt-atendida) > 0
              and ped-item.dt-entrega       >= tt-param.ini-data
              and ped-item.dt-entrega       <= tt-param.fim-data
              AND ped-item.cod-unid-negoc   >= tt-param.cod-unid-negoc-ini
              AND ped-item.cod-unid-negoc   <= tt-param.cod-unid-negoc-fim,
            first ped-venda of ped-item
               where (ped-venda.cod-sit-ped <= 2 
                  or  ped-venda.cod-sit-ped  = 5)
                 AND ped-venda.cod-estabel  >=  tt-param.cod-estabel-ini 
                 AND ped-venda.cod-estabel  <=  tt-param.cod-estabel-fim no-lock, 
            first repres
               where repres.nome-abrev       = ped-venda.no-ab-reppri
               and   repres.cod-rep         >= tt-param.ini-rep
               and   repres.cod-rep         <= tt-param.fim-rep no-lock,
            first natur-oper
                  where natur-oper.nat-operacao = ped-item.nat-operacao 
                    and natur-oper.baixa-est no-lock:
     
            assign tt-carteira.saldo-cart = tt-carteira.saldo-cart
                                          + (ped-item.qt-pedida -
                                             ped-item.qt-atendida).
            if ped-item.qt-log-aloca <> 0 then
               assign tt-carteira.saldo-res-ped = tt-carteira.saldo-res-ped
                                                 + ped-item.qt-log-aloca.
    
        end.
    
        assign tt-carteira.saldo = tt-carteira.saldo-fisico 
                                 - tt-carteira.saldo-res-nota
                                 - tt-carteira.saldo-cart
                                 - tt-carteira.bloq
               tt-carteira.estoque = tt-carteira.saldo-fisico 
                                   - tt-carteira.saldo-res-nota.
    end. /*for each fam-comerc no-lock */

END. /*PROCEDURE piMontaRelat:*/


PROCEDURE imprime-relatorio:

    RUN pi-acompanhar IN h-acomp (INPUT 'Imprimindo...').

    RUN pi-LabelDep.

    for each tt-carteira
        break by tt-carteira.cd-gr-com
              by tt-carteira.cd-sub-com
              by tt-carteira.it-codigo:

        /*****
        if first-of (tt-carteira.cd-gr-com) then do:
           
           find first fam-com-item
                where fam-com-item.fm-cod-com = tt-carteira.cd-gr-com
                no-lock no-error.

           put skip(1)"GRUPO   : "
               tt-carteira.cd-gr-com.
           if avail fam-com-item then
               put " - "
                   fam-com-item.descricao.
           
           put skip(1).
           RUN pi-LabelDep.

        end.
        *****/

        find item where
             item.it-codigo = tt-carteira.it-codigo no-lock no-error.
        if tt-carteira.saldo-cart > 0 or 
           tt-carteira.saldo-fisico > 0 or 
           tt-carteira.saldo-res-ped > 0 or
           tt-carteira.saldo-res-nota > 0 or 
           tt-carteira.saldo > 0 OR 
           tt-carteira.blo > 0 THEN DO:

            PUT UNFORMATTED tt-carteira.it-codigo                                          ';'
                ITEM.desc-item format "x(60)"                                  ';'
                tt-carteira.saldo-cart                                         ';'
                tt-carteira.saldo-fisico                                       ';'
                tt-carteira.saldo-res-ped                                      ';'
                tt-carteira.saldo-res-nota                                     ';'
                tt-carteira.saldo                                              ';'
                tt-carteira.estoque                                            ';'.

            FOR EACH tt-carteiraDep
                WHERE tt-carteiraDep.it-codigo  = tt-carteira.it-codigo   
                  AND tt-carteiraDep.cd-gr-com  = tt-carteira.cd-gr-com   
                  AND tt-carteiraDep.cd-sub-com = tt-carteira.cd-sub-com NO-LOCK
                BY tt-carteiraDep.cod-depos: 

                PUT tt-carteiraDep.qtidade-atu ';'.

            END. /* FOR EACH tt-carteiraDep */
            PUT SKIP.

        END.

    end. /*for each tt-carteira*/

 END. /*PROCEDURE imprime-relatorio:*/
         
PROCEDURE pi-LabelDep:

    DEFINE VARIABLE i-depositos AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.

    ASSIGN i-depositos = 0.
    /*IF tt-carteira.it-codigo <> '' THEN DO:*/
        PUT 'ITEM            ;DESCRICAO                                                   ;CARTEIRA ;FISICO RES ;PEDIDO RES;NOTA      ;DISPONIVEL;ESTOQUE   ;'.
            

        FOR EACH tt-depositos NO-LOCK
            BY tt-depositos.cod-depos:
            ASSIGN i-depositos = i-depositos + 1.
            PUT '      ESTOQUE ' tt-depositos.cod-depos ';'.
        END.
        PUT SKIP
            '----------------;------------------------------------------------------------;-------- ;-----------;----------;----------;----------;----------;'.
        DO i-cont = 1 TO i-depositos:
            PUT '-----------------;'.
        END.
        PUT SKIP.

    /*END. /* IF tt-carteira.it-codigo <> '' THEN DO: */*/

END PROCEDURE.





