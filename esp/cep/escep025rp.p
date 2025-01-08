/***********************************************************************
**  Programa..: ESP\REP\ESCEP025RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Lista de Faltas - Individual
**  Vers∆o....: 001 07/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP025 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cep/escep025tt.i}

{utp/ut-glob.i}
{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def var c-titulo as char format "x(40)" initial "Lista de Faltas - ".
def var c-it-codigo AS CHAR NO-UNDO.
define variable novo-nivel as logical initial YES NO-UNDO.
define variable deleta     as logical initial NO NO-UNDO.
define variable soma-item  like estrutura.quant-usada NO-UNDO.
def var de-val-unit as DEC NO-UNDO.
define variable i-saldo-rec as i initial 0 NO-UNDO.
define variable i-saldo-alm as i initial 0 NO-UNDO.
define variable i-saldo-pro as i initial 0 NO-UNDO.
define variable i-saldo-ast as i initial 0 NO-UNDO.
define variable i-saldo-dec as i initial 0 NO-UNDO.
define variable i-saldo-pin as i initial 0 NO-UNDO.
define variable i-quant-usada as i initial 0 NO-UNDO.
def var de-soma as dec format "->>>,>>>,>>9" NO-UNDO.
def var de-valor as dec format "->>>,>>>,>>9.99" NO-UNDO.
def var de-total as dec format "->,>>>,>>9.99" NO-UNDO.
def var de-total-comp as dec format "->,>>>,>>9.99" NO-UNDO.
def var de-valor-alm as dec format "->>,>>>,>>>,>>9.9999" NO-UNDO.
def var de-valor-falta as dec format "->>,>>>,>>>,>>9.9999" NO-UNDO.
define variable total      as int initial 0 NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.
DEF VAR de-saldo-terc     LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEF VAR l-log-repete-est  AS LOG NO-UNDO.

DEFINE VARIABLE c-imp-dec-pin AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-sit-dif-estab AS LOGICAL NO-UNDO.
DEFINE VARIABLE i-situacao      AS INTEGER NO-UNDO.

/****************************  Temp-Tables  ****************************/
define temp-table ti-itens
    field ti-it-codigo like item.it-codigo
    field ti-quantidade like estrutura.quant-usada format ">>>,>>9.99999"
    FIELD titulo as char format "x(40)" initial "Lista de Faltas - "
    index id ti-it-codigo.

define temp-table t-estru
     field it-codigo like estrutura.it-codigo
     field quant-usada like estrutura.quant-usada format ">>>,>>9.99999"
     field cod-comprado like item.cod-comprado
     field l-lido as logical initial no
     field alternativo as char format "x(03)"
     FIELD rec-ti-itens AS ROWID 
     FIELD fantasma AS LOGICAL
     index cod-comprado;it-codigo
     is primary cod-comprado it-codigo ascending.

define buffer b-t-estru     for t-estru.
def buffer b-estrutura      for estrutura.
DEF BUFFER b-item           FOR ITEM.
def buffer bb-item          for item.
def buffer b-item-uni-estab for item-uni-estab.
def buffer b-int-item-uni-estab for int-item-uni-estab.
def buffer b-int-item       for int-item.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
def var lg-phase-out as logi   no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:

    ASSIGN c-destino = c-dir-arquivo-session + c-seg-usuario.
    //ASSIGN c-destino = REPLACE(c-destino, "~\":U, "/":U).
    if  opsys = "unix" THEN ASSIGN c-destino = REPLACE(c-destino, "~\":U, "/":U).
    OS-CREATE-DIR VALUE(c-destino).
    ASSIGN c-destino = c-destino + "/" + "escep025" + "-" + STRING(TIME) + ".csv".
    DEFINE STREAM s-relat.

    OUTPUT STREAM s-relat TO VALUE(c-destino) CONVERT TARGET "iso8859-1".
    
    RUN utp/ut-acomp.p persistent set h-acomp.  

    RUN piMontaRelat.

    find current b-int-item-uni-estab no-lock no-error.
    find current b-item-uni-estab     no-lock no-error.
    find current bb-item              no-lock no-error.
    find current b-int-item           no-lock no-error.

    RUN pi-finalizar in h-acomp.

    OUTPUT STREAM s-relat CLOSE.

    IF tt-param.destino = 3 THEN
        DOS SILENT START excel VALUE(c-destino).
    
    RETURN "OK".
END.



PROCEDURE piMontaRelat:

    DEFINE VARIABLE i-demanda AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-motivo  AS CHARACTER   NO-UNDO.


    RUN pi-inicializar in h-acomp (input "Executando").

    FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.

    FOR EACH tt-digita:
        CREATE ti-itens.
        BUFFER-COPY tt-digita TO ti-itens.
    END.

    for each ti-itens: 
        IF c-it-codigo = "" THEN
            ASSIGN c-it-codigo = ti-itens.ti-it-codigo.
        ELSE 
            ASSIGN c-it-codigo = c-it-codigo + " - " + ti-itens.ti-it-codigo.

        if  tt-param.especifico
        and not tt-param.setup
        and tt-param.phase-out
        and tt-param.acao = 2 /* Lista e Efetiva */
        then for each b-item-uni-estab no-lock
                where b-item-uni-estab.it-codigo = ti-itens.ti-it-codigo:
                 if can-find(first b-int-item-uni-estab where
                                   b-int-item-uni-estab.cod-estabel   = b-item-uni-estab.cod-estabel
                               and b-int-item-uni-estab.it-codigo     = b-item-uni-estab.it-codigo
                               and b-int-item-uni-estab.log-phase-in  = no
                               and b-int-item-uni-estab.log-phase-out = yes
                                   no-lock)
                 then next.

                 for first b-int-item-uni-estab
                     where b-int-item-uni-estab.cod-estabel = b-item-uni-estab.cod-estabel
                       and b-int-item-uni-estab.it-codigo   = b-item-uni-estab.it-codigo
                           exclusive-lock: end.

                 if not avail b-int-item-uni-estab
                 then do:
                      create b-int-item-uni-estab.
                      assign b-int-item-uni-estab.cod-estabel = b-item-uni-estab.cod-estabel
                             b-int-item-uni-estab.it-codigo   = b-item-uni-estab.it-codigo.
                 end.

                 assign b-int-item-uni-estab.log-phase-in  = no
                        b-int-item-uni-estab.log-phase-out = yes.
                 find current b-int-item-uni-estab no-lock no-error.
             end. /* for each b-item-uni-estab */

        for each estrutura
           where estrutura.it-codigo = ti-itens.ti-it-codigo
             and estrutura.data-termino > today
             and estrutura.data-inicio  <= today:
   
            find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
            FIND item-uni-estab WHERE
                 item-uni-estab.cod-estabel = tt-param.cod-estabel AND
                 item-uni-estab.it-codigo   = estrutura.es-codigo NO-LOCK NO-ERROR.

            IF AVAIL item-uni-estab THEN
                ASSIGN i-demanda = item-uni-estab.demanda.
            ELSE
                ASSIGN i-demanda = ITEM.demanda.

            IF tt-param.dependente AND i-demanda = 2 /* Independente */ THEN DO:
                NEXT.
            END.

            create t-estru.
            assign t-estru.it-codigo    = estrutura.es-codigo
                   t-estru.quant-usada  = estrutura.quant-usada *
                                           ti-itens.ti-quantidade
                   t-estru.cod-comprado = IF AVAIL item-uni-estab THEN upper(item-uni-estab.cod-comprado) ELSE upper(item.cod-comprado)
                   t-estru.fantasma     = estrutura.fantasma.

            IF tt-param.lista-alter THEN DO:
                IF CAN-FIND (FIRST alternativo
                             WHERE alternativo.it-codigo = estrutura.it-codigo
                               AND alternativo.es-codigo = estrutura.es-codigo NO-LOCK) THEN DO:

                    FOR EACH alternativo
                       WHERE alternativo.it-codigo = estrutura.it-codigo
                         AND alternativo.es-codigo = estrutura.es-codigo NO-LOCK:
                        FIND ITEM WHERE ITEM.it-codigo = alternativo.al-codigo NO-LOCK NO-ERROR.

                        FIND item-uni-estab WHERE
                             item-uni-estab.cod-estabel = tt-param.cod-estabel AND
                             item-uni-estab.it-codigo   = alternativo.al-codigo NO-LOCK NO-ERROR.

                        IF AVAIL item-uni-estab THEN
                            ASSIGN i-demanda = item-uni-estab.demanda.
                        ELSE
                            ASSIGN i-demanda = ITEM.demanda.
            
                        IF tt-param.dependente AND i-demanda = 2 /* Independente */ THEN DO:
                            NEXT.
                        END.
                            

                        create t-estru.
                        assign t-estru.it-codigo  = alternativo.al-codigo
                               t-estru.quant-usada = alternativo.quant-usada * t-estru.quant-usada
                               t-estru.cod-comprado = IF AVAIL item-uni-estab THEN upper(item-uni-estab.cod-comprado) ELSE upper(item.cod-comprado)
                               t-estru.alternativo  = "SIM"
                               t-estru.fantasma     = FALSE.
                    END.
                END.
            END.
        end.
    end. 

    assign novo-nivel = yes.
    repeat while novo-nivel:         
        assign novo-nivel = no.
        for each t-estru 
           where t-estru.l-lido = no:

            RUN pi-acompanhar in h-acomp (input "Lendo estrutura " + t-estru.it-codigo).

            assign deleta = no.

            IF NOT tt-param.fantasma OR
               (tt-param.fantasma AND t-estru.fantasma) THEN DO:

                for each estrutura
                   where estrutura.it-codigo = t-estru.it-codigo
                     and estrutura.data-termino > today
                     and estrutura.data-inicio <= today:
                
                    assign novo-nivel = yes
                           t-estru.l-lido = yes.
                   
                    find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
    
                    FIND item-uni-estab WHERE
                         item-uni-estab.cod-estabel = tt-param.cod-estabel AND
                         item-uni-estab.it-codigo   = estrutura.es-codigo NO-LOCK NO-ERROR.

                    IF AVAIL item-uni-estab THEN
                        ASSIGN i-demanda = item-uni-estab.demanda.
                    ELSE
                        ASSIGN i-demanda = ITEM.demanda.
        
                    IF tt-param.dependente AND i-demanda = 2 /* Independente */ THEN DO:
                        NEXT.
                    END.
    
                    create b-t-estru.
                    assign b-t-estru.it-codigo    = estrutura.es-codigo
                           b-t-estru.quant-usada  = estrutura.quant-usada * t-estru.quant-usada
                           b-t-estru.cod-comprado = IF AVAIL item-uni-estab THEN upper(item-uni-estab.cod-comprado) ELSE upper(item.cod-comprado)
                           b-t-estru.fantasma     = estrutura.fantasma.
                end.

            END.
               
            if deleta then
                delete t-estru.
        end.
    end.     
    
    assign soma-item = 0.
        
    PUT STREAM s-relat UNFORMATTED "Itens/Produtos:;" + c-it-codigo SKIP.

     IF tt-param.dec-pin THEN 
        ASSIGN c-imp-dec-pin = "DEC;PIN;".
     ELSE 
        ASSIGN c-imp-dec-pin = "".

    PUT STREAM s-relat UNFORMATTED "Codigo;" +       
                                   "Alt;" +       
                                   "Item;" +      
                                   "Contenedor;" +
                                   "ALM;" +       
                                   "REC;" +
                                   "PRO;" +         
                                   "AST;" +
                                    
                                   c-imp-dec-pin +
                                   
                                   "Saldo Terc;" +
                                   "Necess.;"  +    
                                   "Falta;"  +      
                                   "Valor Falta;" +
                                   "Comprador;" +
                                   "Situacao;" +
                                   "Motivo Situacao;" +
                                   "Fornecedor;" +
                                   "Nome Abrev;" 
                                   .

    IF tt-param.phase-in THEN DO:
        PUT STREAM s-relat UNFORMATTED "Consumo Medio;" +
                                       "Lote Multiplo;" +
                                       "Lote Minimo;" +
                                       "Qtde Politica;" +
                                       "Quantidade Segur;" +
                                       "Ressupr Fornec;" +
                                       "Deposito Padr;" +
                                       "Tp Despesa;".
    END.

    PUT STREAM s-relat SKIP.

    IF tt-param.setup THEN DO:
       FOR EACH t-estru BREAK BY t-estru.it-codigo:


           IF tt-param.fantasma AND t-estru.fantasma THEN
               NEXT.


           ASSIGN soma-item   = t-estru.quant-usada                      
                  de-val-unit = 0.           
           
           RUN pi-acompanhar in h-acomp (input "Imprimindo item " + t-estru.it-codigo).
           
           FIND item WHERE
                item.it-codigo = t-estru.it-codigo NO-LOCK.
           FIND item-estab NO-LOCK WHERE
                item-estab.cod-estabel = tt-param.cod-estabel AND 
                item-estab.it-codigo = item.it-codigo NO-ERROR.
           IF AVAIL item-estab THEN
               ASSIGN de-val-unit = item-estab.val-unit-mat-m[1] 
                                    + item-estab.val-unit-mob-m[1] 
                                    + item-estab.val-unit-ggf-m[1].

           ASSIGN i-saldo-rec = 0
                  i-saldo-alm = 0
                  i-saldo-pro = 0
                  i-saldo-ast = 0
                  i-saldo-dec = 0
                  i-saldo-pin = 0
                  de-saldo-terc = 0.

           FOR EACH saldo-estoq
               WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
                 and saldo-estoq.cod-depos   = "rec"          
                 AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                ASSIGN i-saldo-rec = i-saldo-rec + saldo-estoq.qtidade-atu.
           END.

           RUN esp/es0018p.r (INPUT "escep025rp",
                              INPUT 1,
                              INPUT 0,
                              INPUT "", 
                              OUTPUT TABLE tt-prog-ponto).

           find first tt-prog-ponto no-error.
           if avail tt-prog-ponto then DO:
               FOR EACH tt-prog-ponto:
                   FOR EACH saldo-estoq
                       WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel 
                         AND saldo-estoq.cod-depos   = tt-prog-ponto.conteudo
                         and saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                        ASSIGN i-saldo-pro = i-saldo-pro + saldo-estoq.qtidade-atu.
                   END.
               END.
           END.
         
           RUN pi-acompanhar in h-acomp (input "Imprimindo item " + item.it-codigo).    
    
           FOR EACH saldo-estoq                              
              WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                and saldo-estoq.cod-depos   = "alm"
                AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
               ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
           END.       

           FOR EACH saldo-estoq                              
              WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                and saldo-estoq.cod-depos   = "ene"
                AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
               ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
           END.        

           FOR EACH saldo-estoq                              
              WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                and saldo-estoq.cod-depos   = "wal"
                AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
               ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
           END.       

           FOR EACH saldo-estoq
              WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                and saldo-estoq.cod-depos   = "ast"
                AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
               ASSIGN i-saldo-ast = i-saldo-ast + saldo-estoq.qtidade-atu.
           END.

           IF tt-param.dec-pin THEN DO:
              FOR EACH saldo-estoq
                 WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                   and saldo-estoq.cod-depos   = "dec"
                   AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-dec = i-saldo-dec + saldo-estoq.qtidade-atu.
              END.
              
              FOR EACH saldo-estoq
                 WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                   and saldo-estoq.cod-depos   = "pin"
                   AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-pin = i-saldo-pin + saldo-estoq.qtidade-atu.
              END.
           END.

           FOR EACH saldo-terc NO-LOCK
              WHERE saldo-terc.cod-estabel = tt-param.cod-estabel
                AND saldo-terc.it-codigo   = item.it-codigo
                AND saldo-terc.quantidade > 0:
           
/*                IF  tt-param.l-depos-disponivel-oem THEN DO:                           */
/*                                                                                       */
/*                    IF  saldo-terc.cod-depos <> "ACA"                                  */
/*                    AND saldo-terc.cod-depos <> "EXP"                                  */
/*                    AND saldo-terc.cod-depos <> "WEX" THEN DO:                         */
/*                        FIND FIRST deposito NO-LOCK                                    */
/*                             WHERE deposito.cod-depos = saldo-terc.cod-depos NO-ERROR. */
/*                                                                                       */
/*                        IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.   */
/*                    END.                                                               */
/*                END.                                                                   */
                
                ASSIGN de-saldo-terc = de-saldo-terc + saldo-terc.quantidade.
           END.

           IF tt-param.ast THEN
              ASSIGN de-soma  = soma-item - i-saldo-alm - i-saldo-ast
                     de-valor = de-soma * de-val-unit.
           ELSE
              ASSIGN de-soma  = soma-item - i-saldo-alm 
                     de-valor = de-soma * de-val-unit.

           IF NOT tt-param.excesso and de-soma < 0 THEN 
              NEXT.   

           FIND FIRST item-fornec-estab NO-LOCK      
                WHERE item-fornec-estab.it-codigo   = t-estru.it-codigo
                  AND item-fornec-estab.cod-estabel = tt-param.cod-estabel
                  AND item-fornec-estab.ativo       = YES
                  AND item-fornec-estab.perc-compra > 0 NO-ERROR.


           RELEASE emitente.
           IF AVAIL item-fornec-estab THEN DO:
               FOR FIRST emitente FIELDS(nome-abrev)
                   WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK: END.
           END.

           ASSIGN i-situacao     = 0
                  l-sit-dif-estab = NO.

           FOR EACH item-uni-estab NO-LOCK 
               WHERE item-uni-estab.it-codigo = t-estru.it-codigo   :
               IF i-situacao = 0 THEN
                  ASSIGN i-situacao = item-uni-estab.cod-obsoleto.
               ELSE DO:
                  IF i-situacao <> item-uni-estab.cod-obsoleto THEN
                     ASSIGN l-sit-dif-estab = YES.
               END.                                  
           END.

           FIND FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = t-estru.it-codigo
                  AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.

           FIND FIRST int-item-uni-estab NO-LOCK
                WHERE int-item-uni-estab.it-codigo   = t-estru.it-codigo   
                  AND int-item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.

           ASSIGN c-motivo = "".

           IF AVAIL item-uni-estab THEN DO:
               IF NOT l-sit-dif-estab THEN DO:
                  FIND FIRST int-item NO-LOCK
                       WHERE int-item.it-codigo = t-estru.it-codigo NO-ERROR.
    
                  IF AVAIL int-item THEN DO:
                     CASE int-item.motivo-situacao:
                        WHEN 1 THEN
                           ASSIGN c-motivo = "Alteraá∆o de estrutura".
                        WHEN 2 THEN
                           ASSIGN c-motivo = "Phase out produto".
                        WHEN 3 THEN
                           ASSIGN c-motivo = "Item EOL".
                        WHEN 4 THEN
                           ASSIGN c-motivo = "Bloqueado compra".
                     END CASE.
                  END.
               END.
               ELSE DO:
                   IF AVAIL int-item-uni-estab THEN DO:
                       CASE int-item-uni-estab.int-1:
                           WHEN 1 THEN
                              ASSIGN c-motivo = "Alteraá∆o de estrutura".
                           WHEN 2 THEN
                              ASSIGN c-motivo = "Phase out produto".
                           WHEN 3 THEN
                              ASSIGN c-motivo = "Item EOL".
                           WHEN 4 THEN
                              ASSIGN c-motivo = "Bloqueado para compra".
                       END CASE.
                   END.
               END.
           END.



           IF tt-param.dec-pin THEN 
              ASSIGN c-imp-dec-pin = STRING(i-saldo-dec,">>>,>>>,>>9") + ';' + STRING(i-saldo-pin,">>>,>>>,>>9") + ';'. 
           ELSE 
              ASSIGN c-imp-dec-pin = "".

           PUT STREAM s-relat UNFORMATTED STRING(t-estru.it-codigo  , "x(7)"           )    + ";" + /*C¢digo*/
                                          STRING(t-estru.alternativo, "x(03)"          )    + ";" + /*Alt*/
                                          STRING(item.desc-item     , "x(32)"          )    + ";" + /*Item*/
                                          STRING(item.lote-multipl  , ">>>,>>9"        )    + ";" + /*Contenedor*/
                                          STRING(i-saldo-alm        , ">>>,>>>,>>9"    )    + ";" + /*ALM*/
                                          STRING(i-saldo-rec        , ">>>,>>>,>>9"    )    + ";" + /*REC*/
                                          STRING(i-saldo-pro        , ">>>,>>>,>>9"    )    + ";" + /*PRO*/
                                          STRING(i-saldo-ast        , ">>>,>>>,>>9"    )    + ";" + /*AST*/
                                          
                                          c-imp-dec-pin                                     +       /*DEC - PIN*/
                                          
                                          STRING(de-saldo-terc      , "->>>,>>>,>>9.99")    + ";" + /*Saldo Terc*/
                                          STRING(soma-item          , ">>>>,>>9.999999")    + ";" + /*Necess.*/
                                          STRING(de-soma            , "->>>,>>>,>>9"   )    + ";" + /*Falta*/
                                          STRING(de-valor           , "->>>,>>>,>>9.99")    + ";" + /*Valor Falta*/
                                          t-estru.cod-comprado                              + ";" +
                                          IF AVAIL item-uni-estab    THEN {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto} + ";" ELSE "" + ";" 
                                          c-motivo                                          + ";" +
                                          IF AVAIL item-fornec-estab THEN STRING(item-fornec-estab.cod-emitente)            + ";" ELSE "" + ";"
                                          IF AVAIL emitente          THEN emitente.nome-abrev                               + ";" ELSE "" + ";"
                                          .

           IF tt-param.phase-in THEN DO:
               FIND FIRST int-item-uni-estab NO-LOCK
                    WHERE int-item-uni-estab.cod-estabel = tt-param.cod-estabel
                      AND int-item-uni-estab.it-codigo   = t-estru.it-codigo NO-ERROR.

           /*    PUT STREAM s-relat UNFORMATTED ";". */
               PUT STREAM s-relat UNFORMATTED IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.consumo-prev  ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.lote-multipl  ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.lote-minimo   ) + ";" ELSE ";"
                                              IF AVAIL int-item-uni-estab THEN STRING(int-item-uni-estab.qtd-pol   ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.quant-segur   ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.res-for-comp  ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.deposito-pad  ) + ";" ELSE ";"
                                              IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.tp-desp-padrao) + ";" ELSE ";".
           END.

           PUT STREAM s-relat UNFORMATTED SKIP.
       END.
    END.   
    ELSE DO:        
        
       FOR EACH t-estru BREAK BY t-estru.it-codigo:

           IF tt-param.fantasma AND t-estru.fantasma THEN
               NEXT.

           ASSIGN soma-item   = soma-item + t-estru.quant-usada.

           RUN pi-acompanhar in h-acomp (input "Imprimindo item " + t-estru.it-codigo).

           IF LAST-OF(t-estru.it-codigo) THEN DO:
              FIND item WHERE
                   item.it-codigo = t-estru.it-codigo NO-LOCK NO-ERROR.
              IF tt-param.especifico THEN DO: 
                 FIND FIRST estrutura                            WHERE
                            estrutura.es-codigo = item.it-codigo AND
                            estrutura.data-inicio <= TODAY       AND
                            estrutura.data-termino > TODAY       NO-LOCK no-error.

                 FIND LAST b-estrutura WHERE 
                           b-estrutura.es-codigo = item.it-codigo AND
                           b-estrutura.data-inicio <= TODAY       AND
                           b-estrutura.data-termino > TODAY       NO-LOCK NO-ERROR.                             
                 IF RECID(estrutura) <> RECID(b-estrutura)
                 then do:
                    IF NOT CAN-FIND ( FIRST tt-digita WHERE 
                                        tt-digita.ti-it-codigo = estrutura.it-codigo)  OR
                       NOT CAN-FIND ( FIRST tt-digita WHERE 
                                        tt-digita.ti-it-codigo = b-estrutura.it-codigo)
                    THEN DO:
                        ASSIGN soma-item = 0.
                        NEXT.
                    END.
                 END.

                 ASSIGN l-log-repete-est = NO.

                 FOR EACH b-estrutura
                    WHERE b-estrutura.es-codigo     = item.it-codigo 
                      AND b-estrutura.data-inicio  <= TODAY
                      AND b-estrutura.data-termino >  TODAY       
                          NO-LOCK.

                    FIND FIRST b-item WHERE
                               b-item.it-codigo = b-estrutura.it-codigo
                               NO-LOCK NO-ERROR.

                    IF AVAIL b-item AND 
                             b-item.cod-obsoleto > 1 //Se pai estiver obsoleto pula da sequencia
                    THEN DO:
                        ASSIGN l-log-repete-est = YES.
                        LEAVE.
                    END.

                    RUN pi-valida-estrutura-dup (INPUT b-estrutura.it-codigo,
                                                 OUTPUT l-log-repete-est).
                    
                    IF l-log-repete-est = YES 
                    THEN DO:
                       LEAVE.
                    END.
                 END.

                 IF l-log-repete-est = YES 
                 THEN DO:
                    ASSIGN soma-item = 0.
                    NEXT.
                 END.

                 if  not tt-param.setup
                 and tt-param.phase-out
                 then do:
                      assign lg-phase-out = yes.

                      for each b-item-uni-estab no-lock
                         where b-item-uni-estab.it-codigo = t-estru.it-codigo:
                          if can-find(first b-int-item-uni-estab WHERE 
                                            b-int-item-uni-estab.it-codigo     = t-estru.it-codigo 
                                        and b-int-item-uni-estab.log-phase-out = yes
                                            no-lock)
                          then next.

                          assign lg-phase-out = no.
                          leave.
                      end. /* for each b-item-uni-estab */

                      if  lg-phase-out
                      and can-find(first bb-item where
                                         bb-item.it-codigo    = t-estru.it-codigo
                                     and bb-item.compr-fabric = 2
                                         no-lock)
                      then do:
                           assign soma-item = 0.
                           next.
                      end.  

                      if  lg-phase-out
                      and not can-find(first b-item-uni-estab where
                                             b-item-uni-estab.it-codigo    = t-estru.it-codigo
                                         and b-item-uni-estab.cod-obsoleto = 1
                                             no-lock)
                      and not can-find(first bb-item where
                                             bb-item.it-codigo    = t-estru.it-codigo
                                         and bb-item.cod-obsoleto = 1
                                             no-lock)
                      then do:
                           assign soma-item = 0.
                           next.
                      end.
                 end.

              END.
    
              ASSIGN i-saldo-rec   = 0
                     i-saldo-alm   = 0
                     i-saldo-pro   = 0
                     i-saldo-ast   = 0
                     i-saldo-dec   = 0
                     i-saldo-pin   = 0
                     de-saldo-terc = 0.

              FOR EACH saldo-estoq
                  WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
                    and saldo-estoq.cod-depos   = "rec"          
                    AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                   ASSIGN i-saldo-rec = i-saldo-rec + saldo-estoq.qtidade-atu.
              END.

              RUN esp/es0018p.r (INPUT "escep025rp",
                                 INPUT 1,
                                 INPUT 0,
                                 INPUT "", 
                                 OUTPUT TABLE tt-prog-ponto).

              find first tt-prog-ponto no-error.
              if avail tt-prog-ponto then DO:
                  FOR EACH tt-prog-ponto:
                      FOR EACH saldo-estoq
                          WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel 
                            AND saldo-estoq.cod-depos   = tt-prog-ponto.conteudo
                            AND saldo-estoq.it-codigo   = ITEM.it-codigo NO-LOCK:
                           ASSIGN i-saldo-pro = i-saldo-pro + saldo-estoq.qtidade-atu.
                      END.
                  END.
              END.
             
              FOR EACH saldo-estoq                           
                 where saldo-estoq.cod-estabel = tt-param.cod-estabel
                   and saldo-estoq.cod-depos   = "alm"
                   AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
              END.

              FOR EACH saldo-estoq                           
                 where saldo-estoq.cod-estabel = tt-param.cod-estabel
                   and saldo-estoq.cod-depos   = "ene"
                   AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
              END.


              FOR EACH saldo-estoq                           
                 where saldo-estoq.cod-estabel = tt-param.cod-estabel
                   and saldo-estoq.cod-depos   = "wal"
                   AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
              END.

              FOR EACH saldo-estoq                      
                 WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
                   and saldo-estoq.cod-depos   = "ast"
                   and saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                  ASSIGN i-saldo-ast = i-saldo-ast + saldo-estoq.qtidade-atu.
              END.              
              
              IF tt-param.obs THEN DO:
                 FOR EACH saldo-estoq                              
                    WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
                       and saldo-estoq.cod-depos   = "obs"
                      and saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                     ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
                 END.
              END.

              IF tt-param.dec-pin THEN DO:
                 FOR EACH saldo-estoq
                    WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                      and saldo-estoq.cod-depos   = "dec"
                      AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                     ASSIGN i-saldo-dec = i-saldo-dec + saldo-estoq.qtidade-atu.
                 END.
    
                 FOR EACH saldo-estoq
                    WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel           
                      and saldo-estoq.cod-depos   = "pin"
                      AND saldo-estoq.it-codigo   = item.it-codigo NO-LOCK:
                     ASSIGN i-saldo-pin = i-saldo-pin + saldo-estoq.qtidade-atu.
                 END.
              END.


              FOR EACH saldo-terc NO-LOCK
                 WHERE saldo-terc.cod-estabel = tt-param.cod-estabel
                   AND saldo-terc.it-codigo   = item.it-codigo
                   AND saldo-terc.quantidade > 0:
              
/*                   IF  tt-param.l-depos-disponivel-oem THEN DO:                           */
/*                                                                                          */
/*                       IF  saldo-terc.cod-depos <> "ACA"                                  */
/*                       AND saldo-terc.cod-depos <> "EXP"                                  */
/*                       AND saldo-terc.cod-depos <> "WEX" THEN DO:                         */
/*                           FIND FIRST deposito NO-LOCK                                    */
/*                                WHERE deposito.cod-depos = saldo-terc.cod-depos NO-ERROR. */
/*                                                                                          */
/*                           IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.   */
/*                       END.                                                               */
/*                   END.                                                                   */
                   
                   ASSIGN de-saldo-terc = de-saldo-terc + saldo-terc.quantidade.
              END.
    
              IF tt-param.pro THEN 
                 ASSIGN i-saldo-alm = i-saldo-alm + i-saldo-pro.   

              IF tt-param.alm = no THEN 
                 ASSIGN de-soma = soma-item.
              ELSE
                 ASSIGN de-soma = soma-item - i-saldo-alm /* - i-saldo-pro */.
                  
              ASSIGN de-valor = de-soma * de-val-unit.
    
    
              IF tt-param.ast THEN
                 ASSIGN de-soma = soma-item - i-saldo-alm - i-saldo-ast
                        de-valor = de-soma * de-val-unit.

              IF tt-param.dec-pin THEN 
                 ASSIGN c-imp-dec-pin = STRING(i-saldo-dec,">>>,>>>,>>9") + ';' + STRING(i-saldo-pin,">>>,>>>,>>9") + ';'. 
              ELSE 
                 ASSIGN c-imp-dec-pin = "".


              ASSIGN i-situacao     = 0
                     l-sit-dif-estab = NO. 

              FOR EACH item-uni-estab NO-LOCK 
                  WHERE item-uni-estab.it-codigo = t-estru.it-codigo   :
                  IF i-situacao = 0 THEN
                     ASSIGN i-situacao = item-uni-estab.cod-obsoleto.
                  ELSE DO:
                     IF i-situacao <> item-uni-estab.cod-obsoleto THEN
                        ASSIGN l-sit-dif-estab = YES.
                  END.                                  
              END.

              FIND FIRST item-uni-estab NO-LOCK
                   WHERE item-uni-estab.it-codigo   = t-estru.it-codigo   
                     AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.


              FIND FIRST int-item-uni-estab NO-LOCK
                   WHERE int-item-uni-estab.it-codigo   = t-estru.it-codigo   
                     AND int-item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.


              ASSIGN c-motivo = "".

              IF AVAIL item-uni-estab THEN DO:
                  IF NOT l-sit-dif-estab THEN DO:
                     FIND FIRST int-item NO-LOCK
                          WHERE int-item.it-codigo = t-estru.it-codigo NO-ERROR.

                     IF AVAIL int-item THEN DO:
                        CASE int-item.motivo-situacao:
                           WHEN 1 THEN
                              ASSIGN c-motivo = "Alteraá∆o de estrutura".
                           WHEN 2 THEN
                              ASSIGN c-motivo = "Phase out produto".
                           WHEN 3 THEN
                              ASSIGN c-motivo = "Item EOL".
                           WHEN 4 THEN
                              ASSIGN c-motivo = "Bloqueado compra".
                        END CASE.
                     END.
                  END.
                  ELSE DO:
                      IF AVAIL int-item-uni-estab THEN DO:
                          CASE int-item-uni-estab.int-1:
                              WHEN 1 THEN
                                 ASSIGN c-motivo = "Alteraá∆o de estrutura".
                              WHEN 2 THEN
                                 ASSIGN c-motivo = "Phase out produto".
                              WHEN 3 THEN
                                 ASSIGN c-motivo = "Item EOL".
                              WHEN 4 THEN
                                 ASSIGN c-motivo = "Bloqueado para compra".
                          END CASE.
                      END.
                  END.
              END.
    
              IF (soma-item > (i-saldo-alm ) AND tt-param.tipo = yes) OR
                 (soma-item < (i-saldo-alm ) AND tt-param.tipo = no)  OR
                 (soma-item <= (i-saldo-alm) AND tt-param.tipo = yes  AND tt-param.alm = no) THEN DO:
    
                  ASSIGN de-total      = de-total + de-valor
                         de-total-comp = de-total-comp + de-valor.
                  IF NOT tt-param.excesso and de-soma < 0 THEN 
                     NEXT.

                  FIND FIRST item-fornec-estab NO-LOCK      
                       WHERE item-fornec-estab.it-codigo   = t-estru.it-codigo
                         AND item-fornec-estab.cod-estabel = tt-param.cod-estabel
                         AND item-fornec-estab.ativo       = YES
                         AND item-fornec-estab.perc-compra > 0 NO-ERROR.

                  RELEASE emitente.
                  IF AVAIL item-fornec-estab THEN DO:
                      FOR FIRST emitente FIELDS(nome-abrev)
                          WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK: END.
                  END.

                  if  tt-param.especifico
                  and not tt-param.setup
                  and tt-param.phase-out
                  and tt-param.acao = 2 /* Lista e Efetiva */
                  then do:
                       find first bb-item 
                            where bb-item.it-codigo    = t-estru.it-codigo
                              and bb-item.compr-fabric = 1
                                  exclusive-lock no-error.

                       for each b-item-uni-estab exclusive-lock
                          where b-item-uni-estab.it-codigo = t-estru.it-codigo:
                           for first b-int-item-uni-estab
                               where b-int-item-uni-estab.cod-estabel = b-item-uni-estab.cod-estabel
                                 and b-int-item-uni-estab.it-codigo   = b-item-uni-estab.it-codigo
                                     exclusive-lock: end.

                           if not avail b-int-item-uni-estab
                           then do:
                                create b-int-item-uni-estab.
                                assign b-int-item-uni-estab.cod-estabel = b-item-uni-estab.cod-estabel
                                       b-int-item-uni-estab.it-codigo   = b-item-uni-estab.it-codigo.
                           end.

                           assign b-int-item-uni-estab.log-phase-in  = no
                                  b-int-item-uni-estab.log-phase-out = yes.
                           find current b-int-item-uni-estab no-lock no-error.

                           if  avail bb-item /* Comprado */
                           and b-item-uni-estab.cod-obsoleto = 1
                           then assign b-item-uni-estab.cod-obsoleto = 2.
                       end. /* for each b-item-uni-estab */

                       if  avail bb-item /* Comprado */
                       and bb-item.cod-obsoleto = 1
                       then do:
                            find first b-int-item
                                 where b-int-item.it-codigo = bb-item.it-codigo
                                       exclusive-lock no-error.

                            assign bb-item.cod-obsoleto = 2.

                            if avail b-int-item
                            then assign b-int-item.motivo-situacao = 2.
                       end. /* if bb-item.cod-obsoleto = 1 */
                  end. /* if  tt-param.especifico */

                  FIND FIRST item-uni-estab NO-LOCK
                       WHERE item-uni-estab.it-codigo   = t-estru.it-codigo
                         AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.

                  FIND FIRST int-item NO-LOCK
                       WHERE int-item.it-codigo = t-estru.it-codigo NO-ERROR.

                  PUT STREAM s-relat UNFORMATTED STRING(t-estru.it-codigo  , "x(7)"           )    + ";" + /*C¢digo*/
                                                 STRING(t-estru.alternativo, "x(03)"          )    + ";" + /*Alt*/
                                                 STRING(item.desc-item     , "x(32)"          )    + ";" + /*Item*/
                                                 STRING(item.lote-multipl  , ">>>,>>9"        )    + ";" + /*Contenedor*/
                                                 STRING(i-saldo-alm        , ">>>,>>>,>>9"    )    + ";" + /*ALM*/
                                                 STRING(i-saldo-rec        , ">>>,>>>,>>9"    )    + ";" + /*REC*/
                                                 STRING(i-saldo-pro        , ">>>,>>>,>>9"    )    + ";" + /*PRO*/
                                                 STRING(i-saldo-ast        , ">>>,>>>,>>9"    )    + ";" + /*AST*/

                                                 c-imp-dec-pin                                     +       /*DEC - PIN*/
                                                
                                                 STRING(de-saldo-terc      , "->>>,>>>,>>9.99")    + ";" + /*Saldo Terc*/
                                                 STRING(soma-item          , ">>>>,>>9.999999")    + ";" + /*Necess.*/
                                                 STRING(de-soma            , "->>>,>>>,>>9"   )    + ";" + /*Falta*/
                                                 STRING(de-valor           , "->>>,>>>,>>9.99")    + ";" + /*Valor Falta*/
                                                 t-estru.cod-comprado                              + ";" +
                                                 IF AVAIL item-uni-estab    THEN {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto} + ";" ELSE "" + ";"
                                                 c-motivo                                          + ";" +
                                                 IF AVAIL item-fornec-estab THEN string(item-fornec-estab.cod-emitente)            + ";" ELSE "" + ";"
                                                 IF AVAIL emitente          THEN emitente.nome-abrev                               + ";" ELSE "" + ";"
                                                 .

                  IF tt-param.phase-in THEN DO:
                      FIND FIRST int-item-uni-estab NO-LOCK
                           WHERE int-item-uni-estab.cod-estabel = tt-param.cod-estabel
                             AND int-item-uni-estab.it-codigo   = t-estru.it-codigo NO-ERROR.
        
                  /*    PUT STREAM s-relat UNFORMATTED ";". */
                      PUT STREAM s-relat UNFORMATTED IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.consumo-prev  ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.lote-multipl  ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.lote-minimo   ) + ";" ELSE ";"
                                                     IF AVAIL int-item-uni-estab THEN STRING(int-item-uni-estab.qtd-pol   ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.quant-segur   ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.res-for-comp  ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.deposito-pad  ) + ";" ELSE ";"
                                                     IF AVAIL item-uni-estab     THEN STRING(item-uni-estab.tp-desp-padrao) + ";" ELSE ";".
                  END.

                  PUT STREAM s-relat UNFORMATTED SKIP.
            
                  ASSIGN de-valor-alm = de-valor-alm + de-val-unit * i-saldo-alm de-valor-falta = de-valor-falta +
                          IF tt-param.alm THEN
                             de-val-unit * (soma-item - i-saldo-alm /* - i-saldo-pro */)
                          ELSE
                             (soma-item * de-val-unit).
              END.

              ASSIGN soma-item = 0
                     Total = Total + 1.        
             
           END.
       END.
    END.

    PUT STREAM s-relat UNFORMATTED "Valor do Alm:;"   + STRING(de-valor-alm,  "->,>>>,>>>,>>9.9999") SKIP.
    PUT STREAM s-relat UNFORMATTED "Valor Falta:;"    + STRING(de-valor-falta,"->,>>>,>>>,>>9.9999") SKIP.
END.

PROCEDURE pi-valida-estrutura-dup:
    DEFINE INPUT  PARAMETER p-it-codigo  AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-repete AS LOG  NO-UNDO.

    DEF VAR i-conta-est AS INTE NO-UNDO.

    ASSIGN i-conta-est  = 0
           p-log-repete = NO.

    FOR EACH estrutura
       WHERE estrutura.es-codigo     = p-it-codigo 
         AND estrutura.data-inicio  <= TODAY
         AND estrutura.data-termino >  TODAY       
             NO-LOCK.

        ASSIGN i-conta-est = i-conta-est + 1.

    END.

    IF i-conta-est > 1 
    THEN ASSIGN p-log-repete = YES.
    ELSE ASSIGN p-log-repete = NO.

END PROCEDURE

