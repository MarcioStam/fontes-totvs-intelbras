/***********************************************************************
**  Programa..: esp/cep/escep079rp.p
**  Autor.....: Alexandre de Freitas.Campos.Gonáalves
**  Data......: Maráo/2015 - Desenvolvimento
**  Descricao.: Saldo de todos os estoques e estabelecimentos
**  Versao....: 001 30/03/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep079rp 1.00.00.00}

/****************************  Definitions  ****************************/

{esp/cep/escep079tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-saida
    FIELD ITEM            LIKE ITEM.it-codigo
    FIELD desc-item       LIKE ITEM.desc-item 
    FIELD unidade         LIKE unid_negoc.des_unid_negoc 
    FIELD cod-estabel     LIKE saldo-estoq.cod-estabel
    FIELD custo-unit      LIKE item-estab.val-unit-mat-m[1]
    FIELD deposito        LIKE saldo-estoq.cod-depos
    FIELD local           LIKE saldo-estoq.cod-localiz 
    FIELD qtd-atual       LIKE saldo-estoq.qtidade-atu
    FIELD qtd-dispo       LIKE saldo-estoq.qtidade-atu
    FIELD qtd-bloq-wms    LIKE saldo-estoq.qtidade-atu
    FIELD lote            LIKE saldo-estoq.lote
    FIELD saldo-data        AS DECIMAL
    FIELD segmento        LIKE fam-com-item.descricao
    FIELD familia         LIKE fam-comerc.descricao
    FIELD reserva           AS DEC
    FIELD qt-disp-reserva   AS DEC.

/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
      
DEFINE VARIABLE h-acomp       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-excel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qtd-dispon    AS DEC       NO-UNDO.

DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE d-tot-disponivel  AS DEC     NO-UNDO.
DEFINE VARIABLE d-tot-saldo-calc  AS DEC     NO-UNDO.
DEFINE VARIABLE d-saldo-calculado AS DEC     NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{cdp/cd0666.i} /*tt-erro*/
/*{esp/pdp/espdp006fn.i} Comentado porque n∆o esta tratando o saldo a nivel de lote */

FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG ) :

/*------------------------------------------------------------------------------
  Purpose:  Retornar o saldo dispo°vel para alocaá∆o do item
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qtd            AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE qtd-alocada    AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE c-localizacao  AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE p-qtd-total    LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-disp     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-bloq     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE qtd-atualizada LIKE int-wms-nf-atualiz.qt-baixada NO-UNDO.

    DEFINE BUFFER bf-saldo-estoq-fnEstoque FOR saldo-estoq.

    ASSIGN c-localizacao = "".

    /*Localizaá‰es que devem ser desconsideradas*/
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006":U
          AND ponto-programa.ponto         = 2,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos:
        IF  c-localizacao = "" THEN
            ASSIGN c-localizacao = ENTRY(2,conteudo-programa.conteudo).
        ELSE
            ASSIGN c-localizacao = c-localizacao + "," + ENTRY(2,conteudo-programa.conteudo).
    END.

    FIND FIRST item-uni-estab USE-INDEX codigo NO-LOCK 
         WHERE item-uni-estab.it-codigo   = p-it-codigo
           AND item-uni-estab.cod-estabel = p-cod-estabel
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.

    IF  AVAIL item-uni-estab
    AND NOT p-saldo-central THEN DO:
        RUN esapi/esapi011.p (INPUT  p-cod-estabel,
                              INPUT  p-it-codigo,
                              INPUT  p-cod-depos,
                              INPUT  p-cod-localiz,
                              OUTPUT qtd).
    END.
    ELSE DO:

        FOR EACH bf-saldo-estoq-fnEstoque NO-LOCK
            WHERE bf-saldo-estoq-fnEstoque.cod-estabel = p-cod-estabel
              AND bf-saldo-estoq-fnEstoque.cod-depos   = p-cod-depos
              AND bf-saldo-estoq-fnEstoque.lote        = p-lote
              AND bf-saldo-estoq-fnEstoque.it-codigo   = p-it-codigo:

            /* Desconsidera as localizaá‰es cadastradas no ES0018 */
            IF  (bf-saldo-estoq-fnEstoque.cod-localiz <> "" OR c-localizacao <> "") 
            AND (LOOKUP(bf-saldo-estoq-fnEstoque.cod-localiz, c-localizacao) > 0) THEN
                NEXT.

            IF  p-cod-localiz <> "*"
            AND bf-saldo-estoq-fnEstoque.cod-localiz <> p-cod-localiz THEN
                NEXT.

            FIND FIRST int-saldo-estoq NO-LOCK
                {dbini\es322.i1 int-saldo-estoq bf-saldo-estoq-fnEstoque} NO-ERROR.

            IF  AVAIL int-saldo-estoq 
            AND int-saldo-estoq.log-bloqueado THEN NEXT.

            ASSIGN qtd         = qtd + bf-saldo-estoq-fnEstoque.qtidade-atu - bf-saldo-estoq-fnEstoque.qt-alocada - bf-saldo-estoq-fnEstoque.qt-aloc-prod - bf-saldo-estoq-fnEstoque.qt-aloc-ped
                   qtd-alocada = qtd-alocada + bf-saldo-estoq-fnEstoque.qt-alocada + bf-saldo-estoq-fnEstoque.qt-aloc-ped.
        END.

        /* Validacao MFT x WMS  */
        FIND FIRST deposito 
             WHERE deposito.cod-depos    = p-cod-depos
               AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.


        IF  AVAIL deposito
        AND NOT AVAIL item-uni-estab THEN DO: /*Central configurada nunca tem saldo no wms, ent∆o considera sempre o saldo cont†bil*/
            EMPTY TEMP-TABLE tt-erro.

            RUN esp/wmp/eswmpapi003.p (INPUT  p-cod-estabel,
                                       INPUT  p-cod-depos,
                                       INPUT  p-it-codigo,
                                       INPUT  "",
                                       OUTPUT p-qtd-total,
                                       OUTPUT p-qtd-disp,
                                       OUTPUT p-qtd-bloq,
                                       OUTPUT TABLE tt-erro).

            FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                DELETE tt-erro.
            END. /* FOR EACH tt-erro */

            /* Verifica quantidade atualizada no estoque e que ainda estah pendente de integracao com o WMS */
            ASSIGN qtd-atualizada = 0.
            FOR EACH int-wms-nf-atualiz NO-LOCK
               WHERE int-wms-nf-atualiz.cod-depos   = p-cod-depos
                 AND int-wms-nf-atualiz.it-codigo   = p-it-codigo
                 AND int-wms-nf-atualiz.cod-estabel = p-cod-estabel:

                ASSIGN qtd-atualizada = qtd-atualizada + int-wms-nf-atualiz.qt-baixada.
            END.

            /*Considera o menor entre dispon°vel estoque ou dispon°vel WMS*/
            ASSIGN qtd = IF p-qtd-disp - qtd-alocada - qtd-atualizada < qtd THEN p-qtd-disp - qtd-alocada - qtd-atualizada ELSE qtd.
        END. /* IF AVAIL deposito THEN DO: */
    END.

    IF qtd < 0 THEN
        ASSIGN qtd = 0.

    RETURN qtd.
END.

FUNCTION fn-qtd-data RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

assign d-tot-disponivel = 0
       d-tot-saldo-calc = 0.

assign d-tot-disponivel  = d-tot-disponivel + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada -
                                               saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
       d-saldo-calculado = saldo-estoq.qtidade-atu.

IF  item.tipo-con-est = 1
OR  tt-param.data-saldo = TODAY /* se for a data que vem padrío (today) nao ira lcoalizar nenhum movimento
                          neste caso o melhor indice e' por data mesmo que o controle seja por lote */
then do:

    for each movto-estoq use-index item-data where
             movto-estoq.it-codigo   = saldo-estoq.it-codigo    and
             movto-estoq.cod-refer   = saldo-estoq.cod-refer    and
             movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
             movto-estoq.cod-depos   = saldo-estoq.cod-depos    and
             movto-estoq.lote        = saldo-estoq.lote         and
             movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
             movto-estoq.esp-docto  <> 37                       and
             movto-estoq.dt-trans    > tt-param.data-saldo 
             no-lock:

        if movto-estoq.tipo-trans = 1 then
            assign d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
        else
            assign d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
    end.
end.
else do:
    
    for each movto-estoq use-index item-estab where
             movto-estoq.it-codigo   = saldo-estoq.it-codigo    and
             movto-estoq.cod-refer   = saldo-estoq.cod-refer    and
             movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
             movto-estoq.cod-depos   = saldo-estoq.cod-depos    and
             movto-estoq.lote        = saldo-estoq.lote         and
             movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
             movto-estoq.esp-docto  <> 37                       and
             movto-estoq.dt-trans    > tt-param.data-saldo 
             no-lock:

        if movto-estoq.tipo-trans = 1 then
            assign d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
        else
            assign d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
    end.
end.
    
  RETURN d-saldo-calculado.   /* Function return value. */

END FUNCTION.
/* include padr∆o para output de relat¢rios */
{include/i-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Saldo de items por estoque e estabelecimento"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP079"
       c-versao       = "1.00"
       c-revisao      = "001".

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "/":U THEN
    ASSIGN c-excel = c-excel + "/":U + TRIM(tt-param.usuario) + "/":U.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
                           
    END.
    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "~\":U THEN
    ASSIGN c-excel = c-excel + "~\":U + TRIM(tt-param.usuario) + "~\":U.
END.

ASSIGN c-excel = c-excel + "ESCEP079.csv":U.

PUT UNFORMATTED "Arquivo gerado em: "c-excel.
PAGE.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET SESSION:CHARSET.

IF tt-param.coluna-qtd-data = NO 
THEN PUT STREAM str-excel "ITEM;Descriá∆o;Uni.Neg;Estabelecimento;Custo-Unidade;Deposito;Localizaá∆o;Qtd-Atual;Qtd-Disponivel;Qtd Aguard. WMS;Lote;Segmento;Familia;Qtd Reservada;Qtd disp - Reserva" SKIP.
ELSE PUT STREAM str-excel "ITEM;Descriá∆o;Uni.Neg;Estabelecimento;Custo-Unidade;Deposito;Localizaá∆o;Qtd-Atual;Qtd-Disponivel;Qtd Aguard. WMS;Lote;Data Saldo;Saldo Data;Segmento;Familia;Qtd Reservada;Qtd disp - Reserva" SKIP.

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    
    EMPTY TEMP-TABLE tt-saida.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informaá‰es..."). 
    
    RUN piMontaRelat.
   
END.

PROCEDURE piMontaRelat:
    DEF VAR l-central-config AS LOG NO-UNDO.
    DEF VAR de-blq-wms       LIKE saldo-estoq.qtidade-atu NO-UNDO.
    
    FOR EACH saldo-estoq NO-LOCK
        WHERE saldo-estoq.cod-depos   >= tt-param.deposito-ini
          AND saldo-estoq.cod-depos   <= tt-param.deposito-fim
          AND saldo-estoq.it-codigo   >= tt-param.item-ini
          AND saldo-estoq.it-codigo   <= tt-param.item-fim
          AND saldo-estoq.cod-estabel >= tt-param.estabel-ini
          AND saldo-estoq.cod-estabel <= tt-param.estabel-fim
          AND saldo-estoq.cod-localiz >= tt-param.localiza-ini
          AND saldo-estoq.cod-localiz <= tt-param.localiza-fim:       

        IF saldo-estoq.qtidade-atu = 0 THEN NEXT.

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo   = saldo-estoq.it-codigo NO-ERROR.

        FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
              AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.

        FIND item-estab NO-LOCK
            WHERE item-estab.it-codigo = item-uni-estab.it-codigo
              AND item-estab.cod-estabel = item-uni-estab.cod-estabel NO-ERROR.

        FIND unid_negoc NO-LOCK
            WHERE unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc NO-ERROR.

        
        ASSIGN l-central-config = CAN-FIND(FIRST item-uni-estab USE-INDEX codigo
                                           WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                                           AND   item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
                                           AND   item-uni-estab.nr-linha    = 20).
        /*
        ASSIGN qtd-dispon = 0
               qtd-dispon = qtd-dispon + (saldo-estoq.qtidade-atu -
                                          saldo-estoq.qt-aloc-prod -
                                          saldo-estoq.qt-alocada - 
                                          saldo-estoq.qt-aloc-ped).
        */

        ASSIGN qtd-dispon = fnEstoque(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, saldo-estoq.lote, l-central-config).

        RUN pi-acompanhar IN h-acomp (INPUT "Item:" + saldo-estoq.it-codigo + " " + "Saldo: " + string (qtd-dispon)).
        
        IF tt-param.sem-filtrar-qtd = NO 
        THEN DO:
           IF qtd-dispon <= 0 THEN NEXT.
        END.
        

        /* Alocada e n∆o integrada com WMS */
        ASSIGN de-blq-wms = 0.
        FOR EACH int-wms-nf-atualiz NO-LOCK
            WHERE int-wms-nf-atualiz.it-codigo   = saldo-estoq.it-codigo  
              AND int-wms-nf-atualiz.cod-depos   = saldo-estoq.cod-depos
              and int-wms-nf-atualiz.cod-estabel = saldo-estoq.cod-estabel:
              ASSIGN de-blq-wms = de-blq-wms + int-wms-nf-atualiz.qt-baixada.
        END.
        
        CREATE tt-saida.
        ASSIGN tt-saida.ITEM          = ITEM.it-codigo  
               tt-saida.desc-item     = ITEM.desc-item        
               tt-saida.unidade       = unid_negoc.des_unid_negoc    
               tt-saida.cod-estabel   = saldo-estoq.cod-estabel    
               tt-saida.custo-unit    = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1]     
               tt-saida.deposito      = saldo-estoq.cod-depos
               tt-saida.local         = saldo-estoq.cod-localiz
               tt-saida.qtd-atual     = saldo-estoq.qtidade-atu
               tt-saida.qtd-bloq-wms  = de-blq-wms 
               tt-saida.qtd-dispo     = qtd-dispon
               tt-saida.lote          = saldo-estoq.lote
               tt-saida.saldo-data    = IF tt-param.coluna-qtd-data = YES  
                                        THEN fn-qtd-data()
                                        ELSE 0.

               FIND FIRST fam-comerc NO-LOCK
                    WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com NO-ERROR.

               IF AVAIL fam-comerc THEN
                   ASSIGN tt-saida.familia = fam-comerc.descricao.

              FIND FIRST fam-com-item NO-LOCK
                   WHERE fam-com-item.unidade  = SUBSTRING(item.fm-cod-com,1,2)
                     AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
                     AND fam-com-item.familia1 = "" NO-ERROR.
                     
              IF AVAIL fam-com-item THEN
                   ASSIGN tt-saida.segmento      = fam-com-item.descricao.

              //Busca quantidade reservada
            FOR EACH reservas-ast NO-LOCK
               WHERE reservas-ast.it-codigo   = saldo-estoq.it-codigo
                 AND reservas-ast.cod-depos   = saldo-estoq.cod-depos
                 AND reservas-ast.cod-estabel = saldo-estoq.cod-estabel
                 AND reservas-ast.dt-reserva <= TODAY:

                IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
                    ASSIGN tt-saida.reserva = tt-saida.reserva + reservas-ast.qt-reserva.
                END.
            END.

            ASSIGN tt-saida.qt-disp-reserva = qtd-dispon - tt-saida.reserva.
    
    END.
    
    RUN pi-finalizar in h-acomp.
    
END.

FOR EACH tt-saida NO-LOCK:
    
    IF tt-param.coluna-qtd-data = NO  
    THEN DO:
        PUT STREAM str-excel UNFORMATTED
            trim(tt-saida.ITEM)        ";"
            trim(tt-saida.desc-item)   ";"
            trim(tt-saida.unidade)     ";"
            TRIM(tt-saida.cod-estabel) ";"
            tt-saida.custo-unit        ";"
            trim(tt-saida.deposito)    ";"                  
            trim(tt-saida.local)       ";"
            tt-saida.qtd-atual         ";"
            tt-saida.qtd-dispo         ";"
            tt-saida.qtd-bloq-wms      ";"
            tt-saida.lote              ";"
            tt-saida.segmento          ";"
            tt-saida.familia           ";"
            tt-saida.reserva           ";"
            tt-saida.qt-disp-reserva   SKIP.
    END.
    ELSE DO:
        PUT STREAM str-excel UNFORMATTED
            trim(tt-saida.ITEM)        ";"
            trim(tt-saida.desc-item)   ";"
            trim(tt-saida.unidade)     ";"
            TRIM(tt-saida.cod-estabel) ";"
            tt-saida.custo-unit        ";"
            trim(tt-saida.deposito)    ";"                  
            trim(tt-saida.local)       ";"
            tt-saida.qtd-atual         ";"
            tt-saida.qtd-dispo         ";"
            tt-saida.qtd-bloq-wms      ";"
            tt-saida.lote              ";" 
            tt-param.data-saldo        ";"
            tt-saida.saldo-data        ";"
            tt-saida.segmento          ";"
            tt-saida.familia           ";"
            tt-saida.reserva           ";" 
            tt-saida.qt-disp-reserva SKIP.

    END.
    
END.

OUTPUT STREAM str-excel CLOSE.





















