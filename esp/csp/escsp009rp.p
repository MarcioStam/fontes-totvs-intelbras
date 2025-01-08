/***********************************************************************
**  Programa..: ESP/CSP/ESCSP009RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: Setembro/2009 - Desenvolvimento
**  Descricao.: Ordem de produ‡Æo sem REQ ou sem ACA
**  VersÆo....: 001 21/09/2009
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/csp/escsp009tt.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod_unid_negoc AS CHARACTER
    FIELD cdn_unid_negoc AS INTEGER
    FIELD descricao      AS CHARACTER FORMAT "x(30)".

def temp-table tt-item no-undo
    field it-item   as char
    field seq-cont  as integer
    field sequencia as integer
    field it-codigo as char
    field es-codigo as char
    FIELD unid-negoc AS CHARACTER
    FIELD quant-usada AS DECIMAL FORMAT "->>>,>>>,>>9.99999"
    FIELD quant-propor AS DECIMAL FORMAT "->>>,>>>,>>9.99999"
    FIELD percentual   AS DECIMAL FORMAT "->>9.99"
    FIELD c-aux       AS CHARACTER 
    &if defined (bf_man_sfc_lc) &then
        FIELD cod-lista-compon AS CHAR
    &endif
    INDEX codigo IS UNIQUE PRIMARY it-item seq-cont
    INDEX chave1 it-item es-codigo c-aux.

def temp-table tt-item-unid no-undo
    field it-codigo as char
    FIELD unid-negoc AS CHARACTER
    FIELD quant-usada AS DECIMAL FORMAT "->>>,>>>,>>9.99999"
    FIELD quant-propor AS DECIMAL FORMAT "->>>,>>>,>>9.99999"
    FIELD percentual   AS DECIMAL FORMAT "->>9.99"
    INDEX codigo IS UNIQUE PRIMARY it-codigo unid-negoc.

def temp-table tt-agrup-item no-undo
    field it-codigo as char
    FIELD percentual   AS DECIMAL EXTENT 10 FORMAT "->>9.99"
    INDEX codigo IS UNIQUE PRIMARY it-codigo.

def temp-table tt-item-movto no-undo
    field it-codigo   as char
    FIELD tipo        AS INTEGER
    FIELD quantidade  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS UNIQUE PRIMARY it-codigo tipo.


DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER b-tt-item FOR tt-item.
DEFINE BUFFER b-tt-item-movto FOR tt-item-movto.

/****************************  Variaveis    ****************************/
DEFINE VARIABLE de-tot-usada     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-quant-usada   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-quant-requis  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-quantidade    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-quant-liquid  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE c-processo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-refer-incluida AS LOGICAL   NO-UNDO INITIAL NO.
DEFINE VARIABLE c-controle-nivel AS INTEGER   NO-UNDO.

DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-refer-es AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-refer    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-alt      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nivel    AS INTEGER     NO-UNDO.
DEFINE VARIABLE dt-data    AS DATE        NO-UNDO.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

/* ***************************  Main Block  *************************** */

FOR EACH tt-item:
    DELETE tt-item.
END.

FOR EACH tt-item-movto:
    DELETE tt-item-movto.
END.

FOR EACH tt-item-unid:
    DELETE tt-item-unid.
END.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Utiliza‡Æo Mat‚ria-Prima Unidade"
       c-empresa      = if avail mgcad.empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESCSP009"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}

    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Imprimindo...").

    run piImprimeRelat.

    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    
    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esp/csp/escsp009rp1.p (OUTPUT TABLE tt-unid-negoc).

    RUN pi-busca-acabado.
    

    FOR EACH tt-item NO-LOCK 
       WHERE tt-item.es-codigo <> "" 
         AND tt-item.c-aux = "" BREAK BY tt-item.es-codigo:
        
        IF FIRST-OF(tt-item.es-codigo) THEN
            ASSIGN de-tot-usada = 0.
    
        ASSIGN de-tot-usada = de-tot-usada + tt-item.quant-usada.
    
        IF LAST-OF(tt-item.es-codigo) THEN DO:
            
            RUN pi-acompanhar IN h-acomp (INPUT "Requisicao Item: " + tt-item.es-codigo).
    
            ASSIGN de-quant-requis = 0.
    
            CREATE tt-item-movto.
            ASSIGN tt-item-movto.it-codigo  = tt-item.es-codigo
                   tt-item-movto.quantidade = de-tot-usada 
                   tt-item-movto.tipo       = 0 /*materia prima*/
                   de-tot-usada             = 0.
        END.
    END.
    
    FOR EACH tt-item-movto NO-LOCK 
       WHERE tt-item-movto.tipo = 1 /*acabado*/ :
    
        RUN pi-acompanhar IN h-acomp (INPUT "Calculando Item: " + tt-item-movto.it-codigo).
        FOR EACH tt-item NO-LOCK 
           WHERE tt-item.it-item    = tt-item-movto.it-codigo
             AND tt-item.es-codigo <> ""
             AND tt-item.c-aux      = "":
    
            FIND FIRST b-tt-item-movto NO-LOCK
                 WHERE b-tt-item-movto.it-codigo   = tt-item.es-codigo 
                   AND b-tt-item-movto.tipo        = 0 /*materia prima*/
                   AND b-tt-item-movto.quantidade <> 0 NO-ERROR.
            IF NOT AVAIL b-tt-item-movto THEN
                FIND FIRST b-tt-item-movto NO-LOCK
                     WHERE b-tt-item-movto.it-codigo = tt-item.es-codigo NO-ERROR.
            IF AVAIL b-tt-item-movto THEN DO:
                ASSIGN tt-item.quant-propor = b-tt-item-movto.quantidade
                       tt-item.percentual   = tt-item.quant-usada / b-tt-item-movto.quantidade * 100.
            END.
        END.
    END.
    
    FOR EACH tt-item 
       WHERE tt-item.quant-usada  <> 0 
         AND tt-item.es-codigo    <> ""
         AND tt-item.quant-propor <> 0
         AND tt-item.c-aux         = "":
    
        FIND FIRST tt-item-unid NO-LOCK
             WHERE tt-item-unid.it-codigo  = tt-item.es-codigo
               AND tt-item-unid.unid-negoc = tt-item.unid-negoc NO-ERROR.
        IF NOT AVAIL tt-item-unid THEN DO:
            CREATE tt-item-unid.
            ASSIGN tt-item-unid.it-codigo    = tt-item.es-codigo
                   tt-item-unid.unid-negoc   = tt-item.unid-negoc
                   tt-item-unid.quant-propor = tt-item.quant-propor.
        END.
        ASSIGN tt-item-unid.quant-usada  = tt-item-unid.quant-usada + tt-item.quant-usada
               tt-item-unid.percentual   = tt-item-unid.percentual + tt-item.percentual.
    
    
        FIND FIRST tt-agrup-item NO-LOCK
             WHERE tt-agrup-item.it-codigo = tt-item.es-codigo NO-ERROR.
        IF NOT AVAIL tt-agrup-item THEN DO:
            CREATE tt-agrup-item.
            ASSIGN tt-agrup-item.it-codigo = tt-item.es-codigo.
        END.
    
        FIND FIRST tt-unid-negoc NO-LOCK
             WHERE tt-unid-negoc.cod_unid_negoc = tt-item.unid-negoc NO-ERROR.
        IF AVAIL tt-unid-negoc THEN
            ASSIGN tt-agrup-item.percentual[INT(tt-unid-negoc.cdn_unid_negoc)] = tt-agrup-item.percentual[INT(tt-unid-negoc.cdn_unid_negoc)] + tt-item.percentual.
    
    /*    FIND FIRST tt-item-unid NO-LOCK
             WHERE tt-item-unid.it-codigo  = tt-item.es-codigo
               AND tt-item-unid.unid-negoc = "ZZZ" NO-ERROR.
        IF NOT AVAIL tt-item-unid THEN DO:
            CREATE tt-item-unid.
            ASSIGN tt-item-unid.it-codigo    = tt-item.es-codigo
                   tt-item-unid.unid-negoc   = "ZZZ"
                   tt-item-unid.quant-propor = tt-item.quant-propor.
        END.
        ASSIGN tt-item-unid.quant-usada  = tt-item-unid.quant-usada + tt-item.quant-usada
               tt-item-unid.percentual   = tt-item-unid.percentual + tt-item.percentual.*/
    END.
    
    PUT UNFORMATTED
        "Item;Descricao;".
     
    FOR EACH tt-unid-negoc NO-LOCK BY tt-unid-negoc.cdn_unid_negoc:
        PUT UNFORMATTED 
            tt-unid-negoc.cod_unid_negoc ";".
    END.
    PUT UNFORMATTED SKIP.
    
    FOR EACH tt-agrup-item BY tt-agrup-item.it-codigo:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-agrup-item.it-codigo NO-ERROR.
        IF AVAIL ITEM THEN
            PUT UNFORMATTED 
                tt-agrup-item.it-codigo     ";"
                ITEM.desc-item              ";" 
                tt-agrup-item.percentual[1] ";"
                tt-agrup-item.percentual[2] ";"
                tt-agrup-item.percentual[3] ";"
                tt-agrup-item.percentual[4] ";"
                tt-agrup-item.percentual[5] ";"
                tt-agrup-item.percentual[6] ";"
                tt-agrup-item.percentual[7] ";"
                tt-agrup-item.percentual[8] ";" SKIP.
    END.

    IF tt-param.l-itens-unidades THEN DO:
        /*itens*/
        PUT UNFORMATTED SKIP(02) 
            "Item;Descricao;Unid;Qt.Usada;Qt.Propor;Percentual" SKIP.

        FOR EACH tt-item-unid NO-LOCK BY tt-item-unid.it-codigo BY tt-item-unid.unid-negoc:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-item-unid.it-codigo NO-ERROR.
            IF AVAIL ITEM THEN
                PUT UNFORMATTED 
                    tt-item-unid.it-codigo    ";"
                    ITEM.desc-item            ";"
                    tt-item-unid.unid-negoc   ";"
                    tt-item-unid.quant-usada  ";"
                    tt-item-unid.quant-propor ";" 
                    tt-item-unid.percentual   ";" SKIP.
        END.
    END.
    
    IF tt-param.l-lista-estrutura THEN DO:
        /*Estrutura*/
        PUT UNFORMATTED SKIP(2)
            "Acabado;Item;Componente;Seq;Sequencia;Qt.Usada;Qt.Propor;Percentual;" SKIP.

        FOR EACH tt-item WHERE tt-item.c-aux = "" BY tt-item.it-item:
            PUT UNFORMATTED 
                tt-item.it-item      ";"
                tt-item.it-codigo    ";"
                tt-item.es-codigo    ";"
                tt-item.seq-cont     ";"
                tt-item.sequencia    ";"
                tt-item.quant-usada  ";"
                tt-item.quant-propor ";" 
                tt-item.percentual   ";" SKIP.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-busca-acabado:
    FOR EACH ITEM NO-LOCK
       WHERE (ITEM.ge-codigo = 40 OR ITEM.ge-codigo = 45)
         AND ITEM.it-codigo >= tt-param.it-codigo-ini
         AND ITEM.it-codigo <= tt-param.it-codigo-fim BY ITEM.it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ITEM.it-codigo).

        IF NOT CAN-FIND(FIRST ord-prod NO-LOCK
                        WHERE ord-prod.it-codigo   = ITEM.it-codigo
                          AND ord-prod.dt-inicio  >= tt-param.dt-emissao-ini
                          AND ord-prod.dt-termino <= tt-param.dt-emissao-fim) THEN NEXT.

        FIND FIRST unid-neg-fam-com NO-LOCK
             WHERE unid-neg-fam-com.fm-codigo = ITEM.fm-cod-com NO-ERROR.
        IF NOT AVAIL unid-neg-fam-com THEN NEXT.

        ASSIGN c-refer = ITEM.cod-refer
               i-cont  = 1.

        ASSIGN de-quant-requis = 0.

        DO dt-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.it-codigo   = ITEM.it-codigo
                 AND movto-estoq.cod-estabel = tt-param.cod-estabel
                 AND movto-estoq.dt-trans    = dt-data
                 AND movto-estoq.nr-ord-produ <> 0,
               FIRST ord-prod NO-LOCK
               WHERE ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ
                 AND ord-prod.it-codigo    = movto-estoq.it-codigo
                 AND ord-prod.tipo         = 1:
                IF movto-estoq.tipo-trans = 1 AND movto-estoq.esp-docto = 1 /*ACA*/ THEN
                    ASSIGN de-quant-requis = de-quant-requis + movto-estoq.quantidade.
                ELSE IF movto-estoq.tipo-trans = 2 AND movto-estoq.esp-docto = 8 /*EAC*/ THEN
                    ASSIGN de-quant-requis = de-quant-requis - movto-estoq.quantidade.
            END.
        END.

        IF de-quant-requis <= 0 THEN NEXT.

        find first tt-item no-lock 
             where tt-item.it-item  = item.it-codigo
               and tt-item.seq-cont = 0 no-error.
        if not avail tt-item then do:
           create tt-item.
           assign tt-item.it-item     = item.it-codigo
                  tt-item.seq-cont    = 0
                  tt-item.quant-usada = de-quant-requis
                  tt-item.unid-negoc  = unid-neg-fam-com.cod_unid_negoc.
        end.

        CREATE tt-item-movto.
        ASSIGN tt-item-movto.it-codigo  = ITEM.it-codigo
               tt-item-movto.quantidade = de-quant-requis
               tt-item-movto.tipo       = 1  /*acabado*/ .

        ASSIGN de-quantidade = de-quant-requis.

        for each estrutura of item no-lock,
             first b-item fields (it-codigo cod-estabel  tipo-con-est   desc-item   un)
             where b-item.it-codigo = estrutura.es-codigo no-lock:

            if ((estrutura.data-inicio  <= tt-param.data-corte and
                estrutura.data-termino > tt-param.data-corte) or tt-param.data-corte = ?) and estrutura.cod-lista-compon = c-processo then do:

               &IF DEFINED (bf_man_sfc_lc) &THEN 
               assign de-quant-usada =  ((estrutura.qtd-compon / estrutura.qtd-item) * (estrutura.proporcao / 100)) * de-quantidade 
                      de-quant-liquid = de-quant-usada * (1 - (estrutura.fator-perda / 100)).  
               &ELSE
               assign de-quant-usada =  de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100)
                      de-quant-liquid = de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).            
               &ENDIF

               if b-item.tipo-con-est = 4 or 
                    item.tipo-con-est = 4 then do:

                    for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo
                                                 sequencia   cod-ref-es)
                        where ref-estrut.it-codigo  = estrutura.it-codigo and  
                              ref-estrut.es-codigo  = estrutura.es-codigo and
                              ref-estrut.sequencia  = estrutura.sequencia no-lock: end.

                    if  not avail ref-estrut THEN DO:
                        assign l-refer-incluida = yes
                               c-refer-es       = ''.           
                    END.
                    else do:
                        IF item.tipo-con-est = 4 THEN DO:
                           for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo
                                                     sequencia   cod-ref-es)
                                where ref-estrut.it-codigo  = estrutura.it-codigo and  
                                      ref-estrut.cod-ref-it = c-refer and  
                                      ref-estrut.es-codigo  = estrutura.es-codigo and
                                      ref-estrut.sequencia  = estrutura.sequencia no-lock: end.
                            if available ref-estrut then
                               assign c-refer-es       = ref-estrut.cod-ref-es
                                       l-refer-incluida = yes.
                            else DO:
                               assign l-refer-incluida = no.                         
                            END.
                        END.
                        ELSE DO:
                            assign l-refer-incluida = yes
                                   c-refer-es       = ''.                                   
                        END.
                    end.
               end.
               else
                   assign l-refer-incluida = yes
                          c-refer-es       = ''.

               if c-processo <> "" then
                   assign l-refer-incluida = yes.

               if l-refer-incluida then do: 
                  if estrutura.fantasma then 
                     assign c-aux = '#'.
                  else
                     assign c-aux = ''.

                  if can-find (first alternativo 
                               where alternativo.es-codigo = estrutura.es-codigo
                                 and alternativo.it-codigo = estrutura.it-codigo
                                 and alternativo.sequencia = estrutura.sequencia no-lock) then
                     assign c-aux = c-aux +  c-alt.

                  if today >= estrutura.data-termino or today < data-inicio then
                     assign c-aux = c-aux +  '?'.

                  find first tt-item no-lock 
                       where tt-item.it-item   = item.it-codigo
                         and tt-item.seq-cont = i-cont no-error.
                  if not avail tt-item then do:
                     create tt-item.
                     assign tt-item.it-item   = item.it-codigo
                            tt-item.seq-cont = i-cont
                            tt-item.unid-negoc  = unid-neg-fam-com.cod_unid_negoc.
                  end.
                  assign tt-item.sequencia = estrutura.sequencia
                         tt-item.it-codigo = estrutura.it-codigo
                         tt-item.es-codigo = estrutura.es-codigo
                         &if defined (bf_man_sfc_lc) &then
                             tt-item.cod-lista-compon = estrutura.cod-lista-compon
                         &endif
                         tt-item.quant-usada = de-quant-usada
                         tt-item.c-aux       = c-aux. 

                  assign i-cont = i-cont + 1.

                  run pi-gera-estrutura-filho(buffer b-item, 
                                              c-refer-es, 
                                              de-quant-usada, 
                                              i-nivel,
                                              i-cont - 1).
               end.
            end.  
         end.
    END.
END PROCEDURE.

PROCEDURE pi-gera-estrutura-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define parameter buffer b1-item for item.
    define input parameter p-refer as char no-undo.
    define input parameter p-quantidade as decimal no-undo.
    define input parameter p-nivel as integer no-undo.
    define input parameter p-pai   as integer no-undo.
    
    define buffer b2-item for item.
    define buffer b-estrutura for estrutura.
    define var de-quant-usada like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var de-quant-liquid like estrutura.quant-liquid  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var i as integer.
    
    assign p-nivel = p-nivel + 1.
    
    if p-nivel > c-controle-nivel then
       assign c-controle-nivel = p-nivel.
    
    for each b-estrutura of b1-item no-lock:
    
        if (b-estrutura.data-inicio  <= tt-param.data-corte and
            b-estrutura.data-termino >  tt-param.data-corte) or tt-param.data-corte = ? then do:
    
            for first b2-item fields (it-codigo cod-estabel  tipo-con-est   desc-item   un)
                where b2-item.it-codigo = b-estrutura.es-codigo no-lock: end.
    
            &IF DEFINED (bf_man_sfc_lc) &THEN
            assign de-quant-usada =  ((b-estrutura.qtd-compon / b-estrutura.qtd-item) * (b-estrutura.proporcao / 100)) * p-quantidade 
                   de-quant-liquid = de-quant-usada * (1 - (b-estrutura.fator-perda / 100)).
            &ELSE
            assign de-quant-usada =  p-quantidade * b-estrutura.quant-usada *
                                    (b-estrutura.proporcao / 100)
                   de-quant-liquid = p-quantidade * b-estrutura.quant-usada *
                                    (b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).
            &ENDIF
            
            &IF DEFINED (bf_man_206b) &THEN
                IF l-usa-unid-negoc THEN DO:
                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  b2-item.cod-estabel,
                                                             INPUT  b2-item.it-codigo,
                                                             INPUT  "",
                                                             OUTPUT c-unid-retornada).
                ASSIGN c-retornado = c-unid-retornada.
            END.
            &ENDIF
            
            if b2-item.tipo-con-est = 4 or 
              b1-item.tipo-con-est = 4 then do:
    
                 for first ref-estrut fields (it-codigo   cod-ref-it  es-codigo
                                               sequencia   cod-ref-es)
                      where ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                            ref-estrut.es-codigo  = b-estrutura.es-codigo and
                            ref-estrut.sequencia  = b-estrutura.sequencia no-lock: end.
    
                 if not avail ref-estrut then
                    assign l-refer-incluida = yes
                           /*c-refer-es       = ''*/.
                 else do:
                    IF b1-item.tipo-con-est = 4 THEN DO:
                         for first ref-estrut fields (it-codigo   cod-ref-it  es-codigo
                                                       sequencia   cod-ref-es)
                              where ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                                    ref-estrut.cod-ref-it = p-refer and  
                                    ref-estrut.es-codigo  = b-estrutura.es-codigo and
                                    ref-estrut.sequencia  = b-estrutura.sequencia no-lock: end.
        
                         if available ref-estrut then
                              assign c-refer-es       = ref-estrut.cod-ref-es
                                     l-refer-incluida = yes.
                         else DO:              
                              assign l-refer-incluida = no.                    
    
                         END.
                    END.
                    ELSE DO:
                         assign /*c-refer-es       = ''*/
                                l-refer-incluida = yes.
                    END.
                 end.         
            end.
            else
                assign l-refer-incluida = yes
                       /*c-refer-es       = ''*/.
    
            if l-refer-incluida then do:
               if b-estrutura.fantasma then 
                  assign c-aux = '#'.
               else
                   assign c-aux = ''.
               if can-find (first alternativo 
                            where alternativo.es-codigo = b-estrutura.es-codigo
                              and alternativo.it-codigo = b-estrutura.it-codigo
                              and alternativo.sequencia = b-estrutura.sequencia no-lock) then
                  assign c-aux = c-aux +  c-alt.
    
               if today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
                  assign c-aux = c-aux +  '?'.  
    
               find first tt-item no-lock 
                    where tt-item.it-item   = item.it-codigo
                      and tt-item.seq-cont = i-cont no-error.
               if not avail tt-item then do:
                  create tt-item.
                  assign tt-item.seq-cont = i-cont
                         tt-item.it-item   = item.it-codigo
                         tt-item.unid-negoc = unid-neg-fam-com.cod_unid_negoc.
               end.
               assign tt-item.sequencia = b-estrutura.sequencia
                      tt-item.it-codigo = b-estrutura.it-codigo
                      tt-item.es-codigo = b-estrutura.es-codigo
                      &if defined (bf_man_sfc_lc) &then
                          tt-item.cod-lista-compon = b-estrutura.cod-lista-compon
                      &endif
                      tt-item.quant-usada = de-quant-usada
                      tt-item.c-aux       = c-aux.
    
               assign i-cont = i-cont + 1.
    
               run pi-gera-estrutura-filho(buffer b2-item, 
                                           c-refer-es, 
                                           de-quant-usada, 
                                           p-nivel,
                                           i-cont - 1).
           end.
        end.
    end.
END PROCEDURE.


/**** Fim do programa ****/
