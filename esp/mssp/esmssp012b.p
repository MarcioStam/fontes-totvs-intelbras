/************************************************************************
* Programa ..: <name>
* Data ......: 12.08.2019 20:47
* Empresa ...: LHC Informatica
* Cliente ...: ...
* Vers„o ....: 2.12.01.001
* Autor .....: Maicon Machry
*************************************************************************/
CREATE WIDGET-POOL.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE h-escrm005       AS HANDLE                 NO-UNDO.
DEFINE VARIABLE c-it-codigo      AS CHARACTER              NO-UNDO.
DEFINE VARIABLE h-esmsspapi001   AS HANDLE                 NO-UNDO.
DEFINE VARIABLE c-mensagem       AS CHARACTER              NO-UNDO.
{esp/mssp/esmssp012.i}

DEFINE INPUT  PARAMETER pTipoRequisicao    AS INTEGER     NO-UNDO. /* 1- Inclus∆o  2- Alteraá∆o */
DEFINE INPUT  PARAMETER pItemMessage       AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-item-fabric.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-versao-integr.
EMPTY TEMP-TABLE tt-erros-geral.
EMPTY TEMP-TABLE tt-item-xml.
EMPTY TEMP-TABLE tt-item.

CREATE tt-versao-integr.
ASSIGN tt-versao-integr.cod-versao-integracao = 1.

/**** fim conex∆o ****/

IF  NOT VALID-HANDLE(h-escrm005) THEN
    RUN esp/crm/escrm005.p PERSISTENT SET h-escrm005.

CREATE tt-item-xml.

ASSIGN pItemMessage = REPLACE(pItemMessage, "&", "&amp;").

IF  VALID-HANDLE(h-escrm005) THEN DO:
    RUN readXML IN h-escrm005 (INPUT  BUFFER tt-item-xml:HANDLE,
                               INPUT  pItemMessage,
                               OUTPUT TABLE tt-atributo-entrada).

    DELETE PROCEDURE h-escrm005.
    ASSIGN h-escrm005 = ?.
END.

bk-integracao:
DO TRANSACTION ON ERROR UNDO bk-integracao, RETURN "NOK":U
               ON STOP  UNDO bk-integracao, RETURN "NOK":U:
    FIND FIRST tt-item-xml NO-ERROR.

    IF NOT AVAIL tt-item-xml THEN DO:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.tip-msgs = 1
               tt-mensagem.mensagem = "Arquivo XML em branco - " + pItemMessage.

        STOP.
    END.

    IF LENGTH(tt-item-xml.it-codigo) > 7 THEN DO:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.tip-msgs = 1
               tt-mensagem.mensagem = "Tamanho do c¢digo do item maior que o permitido (7 caracteres)":U.

        STOP.
    END.

    CREATE tt-item.

    IF  pTipoRequisicao = 2 /* Alteraá∆o */ THEN DO:
        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = tt-item-xml.it-codigo NO-ERROR.
        IF  NOT AVAIL item THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = "Item n∆o localizado para efetuar a alteraá∆o!".

            STOP.
        END.

        BUFFER-COPY item TO tt-item.

        /* VERIFICAR se dever† manter essa regra */
        IF  tt-item.cod-obsoleto <> 1 THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = "Item n∆o est† ativo e a integraá∆o n∆o foi realizada!" + CHR(13) +
                                          "Solicite ao grupo.pcm@intelbras.com.br para ativar o item. Ap¢s a ativaá∆o aprove o processo novamente.".

            STOP.
        END.
    END.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-item-xml.it-codigo:
    END.

    ASSIGN tt-item.ind-tipo-movto = pTipoRequisicao
           tt-item.it-codigo      = tt-item-xml.it-codigo
           tt-item.un             = tt-item-xml.un
           tt-item.desc-item      = tt-item-xml.desc-item
           tt-item.desc-inter     = tt-item-xml.desc-inter        
           tt-item.cod-estabel    = tt-item-xml.cod-estabel
           tt-item.fm-codigo      = tt-item-xml.fm-codigo
           tt-item.class-fiscal   = tt-item-xml.class-fiscal
           tt-item.narrativa      = tt-item-xml.narrativa
           tt-item.responsavel    = tt-item-xml.responsavel
           tt-item.peso-liquido   = tt-item-xml.peso-liquido
           tt-item.peso-bruto     = tt-item-xml.peso-bruto
           tt-item.comprim        = tt-item-xml.comprim
           tt-item.largura        = tt-item-xml.largura
           tt-item.altura         = tt-item-xml.altura
           tt-item.cd-folh-item   = tt-item-xml.cd-folh-item
           tt-item.ind-serv-mat   = tt-item-xml.ind-serv-mat
           tt-item.tipo-contr     = tt-item-xml.tipo-contr
           tt-item.ge-codigo      = IF AVAIL ITEM THEN item.ge-codigo ELSE tt-item-xml.ge-codigo
           tt-item.contr-qualid   = tt-item-xml.contr-qualid
           tt-item.fraciona       = tt-item-xml.fraciona
           tt-item.criticidade    = tt-item-xml.criticidade
           tt-item.fm-cod-com     = tt-item-xml.fm-cod-com
           tt-item.perc-nqa       = tt-item-xml.perc-nqa
           tt-item.cd-planejado   = "101"
           tt-item.reporte-ggf    = 2
           tt-item.aliquota-ipi   = tt-item-xml.aliquota-ipi.

    /* Trecho implementado para passar na validaá∆o da API CDAPI344,
       onde Ç verificado o relacionamento Estabelecimento X Linha de
       Produá∆o da tabela "lin-prod", lembrando que a linha alimentada
       da temp-table da tabela "item" n∆o Ç efetivada na tabela "item",
       sendo usada apenas na validaá∆o - Fabiano Sakae Ribeiro
       (Exponencial TI) */
    IF pTipoRequisicao = 2 THEN DO:
        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = tt-item.it-codigo
              AND item-uni-estab.cod-estabel = tt-item.cod-estabel NO-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN
            ASSIGN tt-item.nr-linha = item-uni-estab.nr-linha.
    END.

    FIND FIRST tt-item NO-ERROR.

    IF AVAIL tt-item THEN DO:
        IF pTipoRequisicao = 2 THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE item THEN DO:
                IF item.fm-codigo <> tt-item.fm-codigo THEN
                    ASSIGN item.fm-codigo = tt-item.fm-codigo.

                FIND CURRENT item NO-LOCK NO-ERROR.
            END.
        END.

        RUN cdp/cdapi344.p (INPUT        TABLE tt-versao-integr,
                            OUTPUT       TABLE tt-erros-geral,
                            INPUT-OUTPUT TABLE tt-item).

        IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
            FOR EACH tt-erros-geral:
                CREATE tt-mensagem.
                ASSIGN tt-mensagem.tip-msgs = 1
                       tt-mensagem.mensagem = STRING(tt-erros-geral.des-erro).
            END.
        
            STOP.
        END.

        IF  NOT CAN-FIND(FIRST tt-erros-geral) THEN DO:
            EMPTY TEMP-TABLE tt-item-aux.
        
            FIND FIRST tt-item NO-ERROR.

            IF NOT AVAIL tt-item THEN DO:
                CREATE tt-mensagem.
                ASSIGN tt-mensagem.tip-msgs = 1
                       tt-mensagem.mensagem = "N∆o encontrado item na tabela de integraá∆o.".

                STOP.
            END.
            ELSE DO:
                FIND FIRST item NO-LOCK WHERE item.it-codigo = tt-item.it-codigo NO-ERROR.
                IF  NOT AVAIL item THEN DO:
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.tip-msgs = 1
                           tt-mensagem.mensagem = "Item n∆o foi cadastrado!".

                    STOP.
                END.

                CREATE tt-item-alt.
                BUFFER-COPY tt-item EXCEPT cod-erro des-erro ind-tipo-movto TO tt-item-alt.
                BUFFER-COPY item EXCEPT it-codigo un desc-item cod-estabel fm-codigo class-fiscal narrativa 
                                        responsavel peso-liquido peso-bruto comprim largura altura cd-folh-item ind-serv-mat 
                                        tipo-contr ge-codigo contr-qualid fraciona criticidade fm-cod-com perc-nqa reporte-ggf TO tt-item-alt.
                ASSIGN tt-item-alt.ind-tipo-movto = 2.

                EMPTY TEMP-TABLE tt-erros-geral.

                RUN cdp/cdapi306.p (INPUT        TABLE tt-versao-integr,
                                    OUTPUT       TABLE tt-erros-geral,
                                    INPUT-OUTPUT TABLE tt-item-alt).

                IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
                    FOR EACH tt-erros-geral:
                        CREATE tt-mensagem.
                        ASSIGN tt-mensagem.tip-msgs = 1
                               tt-mensagem.mensagem = "cdp/cdapi306.p".
                    END.
               
                    STOP.
                END.
            END.
        END.
    END.
    ELSE DO:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.tip-msgs = 1
               tt-mensagem.mensagem = "Tabela de integraá∆o n∆o foi localizada!".

        STOP.
    END.

    IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
        FOR EACH tt-erros-geral:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = tt-erros-geral.des-erro.
        END.

        STOP.
    END.
    ELSE DO:
        FIND FIRST item
            WHERE item.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item THEN
            ASSIGN /*ITEM.aliquota-ii            = tt-item-xml.aliquota-ii*/
                   OVERLAY(ITEM.char-2, 22, 6) = STRING(tt-item-xml.aliquota-ii, "999.99":U)
                   OVERLAY(item.char-2, 31, 5) = STRING(tt-item-xml.aliquota-pis, "99.99":U)
                   OVERLAY(item.char-2, 36, 5) = STRING(tt-item-xml.aliquota-cofins, "99.99":U)
                   item.log-necessita-li       = tt-item-xml.log-necessita-li.

        FIND FIRST item-mat
            WHERE item-mat.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE item-mat THEN
            ASSIGN item-mat.val-aliq-ext-pis    = tt-item-xml.aliquota-pis
                   item-mat.val-aliq-ext-cofins = tt-item-xml.aliquota-cofins.

        FIND FIRST tt-item NO-LOCK NO-ERROR.
        IF  NOT AVAIL tt-item THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = "Tabela de integraá∆o n∆o foi localizada!".

            STOP.
        END.

        IF AVAIL ITEM THEN
            ASSIGN ITEM.peso-liquido = tt-item.peso-liquido
                   ITEM.peso-bruto   = tt-item.peso-bruto
                   ITEM.class-fiscal = tt-item.class-fiscal
                   ITEM.aliquota-ipi = tt-item.aliquota-ipi.


        IF  pTipoRequisicao = 2 /* Alteraá∆o */ THEN DO:
            FOR EACH  item-fabric EXCLUSIVE-LOCK
                WHERE item-fabric.it-codigo  = tt-item.it-codigo:
                DELETE item-fabric.
            END.
        END.

            
         /*gravar aqui char-2 e char-1*/
        IF  tt-item-xml.tipo-item <> "x" THEN DO:
            FIND FIRST item EXCLUSIVE-LOCK 
                 WHERE item.it-codigo = tt-item.it-codigo  NO-ERROR.
            IF  AVAIL item THEN DO:
                ASSIGN OVERLAY(item.char-2,212,1) = tt-item-xml.tipo-item.
                ASSIGN item.cd-planejado = "101".
                ASSIGN item.desc-inter = tt-item-xml.desc-inter.
            END.
            ELSE DO:
                CREATE tt-mensagem.
                ASSIGN tt-mensagem.tip-msgs = 1
                       tt-mensagem.mensagem = "Item cadastrado n∆o foi localizado!".

                STOP.
            END.

            FOR EACH  item-uni-estab EXCLUSIVE-LOCK
                WHERE item-uni-estab.it-codigo = tt-item.it-codigo:
                ASSIGN OVERLAY(item-uni-estab.char-1,133,1) = tt-item-xml.tipo-item.
            END.
        END.

        FIND FIRST unid-negoc
            WHERE unid-negoc.des-unid-negoc = tt-item-xml.un-neg NO-LOCK NO-ERROR.

        IF AVAILABLE unid-negoc THEN DO:

            IF AVAIL ITEM THEN
                ASSIGN ITEM.cod-unid-negoc = unid-negoc.cod-unid-negoc.

            FOR EACH item-uni-estab EXCLUSIVE-LOCK
                WHERE item-uni-estab.it-codigo = tt-item.it-codigo:
                ASSIGN item-uni-estab.cod-unid-negoc = unid-negoc.cod-unid-negoc.
            END.
        END.

        IF pTipoRequisicao = 1 /* Inclus∆o */ THEN DO:
            FOR EACH tt-item-fabric:
                FIND FIRST fabricante
                    WHERE fabricante.cod-fabric = tt-item-fabric.cod-fabric NO-LOCK NO-ERROR.

                IF NOT AVAILABLE fabricante THEN DO:
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.tip-msgs = 1
                           tt-mensagem.mensagem = "N∆o encontrado ~"Fabricante~" para o c¢digo informado (C¢digo: ":U + TRIM(STRING(tt-item-fabric.cod-fabric, ">>>,>>9":U)) + ")":U.

                    NEXT.
                END.

                FIND FIRST item-fabric
                    WHERE item-fabric.it-codigo  = tt-item.it-codigo
                      AND item-fabric.cod-fabric = tt-item-fabric.cod-fabric NO-LOCK NO-ERROR.

                IF NOT AVAILABLE item-fabric THEN DO:
                    CREATE item-fabric.
                    ASSIGN item-fabric.it-codigo  = tt-item.it-codigo
                           item-fabric.cod-fabric = tt-item-fabric.cod-fabric
                           item-fabric.it-fabric  = tt-item-fabric.it-fabric
                           item-fabric.referencia = tt-item-fabric.referencia.
                END.
            END.
        END.
        ELSE DO:
            FOR EACH tt-item-fabric:
                FIND FIRST fabricante
                    WHERE fabricante.cod-fabric = tt-item-fabric.cod-fabric NO-LOCK NO-ERROR.

                IF NOT AVAILABLE fabricante THEN DO:
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.tip-msgs = 1
                           tt-mensagem.mensagem = "N∆o encontrado ~"Fabricante~" para o c¢digo informado (C¢digo: ":U + TRIM(STRING(tt-item-fabric.cod-fabric, ">>>,>>9":U)) + ")":U.

                    NEXT.
                END.

                FIND FIRST item-fabric
                    WHERE item-fabric.it-codigo  = tt-item.it-codigo
                      AND item-fabric.cod-fabric = tt-item-fabric.cod-fabric EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAILABLE item-fabric THEN DO:
                    CREATE item-fabric.
                    ASSIGN item-fabric.it-codigo  = tt-item.it-codigo
                           item-fabric.cod-fabric = tt-item-fabric.cod-fabric.
                END.

                ASSIGN item-fabric.it-fabric  = tt-item-fabric.it-fabric
                       item-fabric.referencia = tt-item-fabric.referencia.
            END.
        END.

        IF CAN-FIND(FIRST tt-mensagem
                    WHERE tt-mensagem.tip-msgs = 1) THEN
            STOP.

        FIND FIRST int-item EXCLUSIVE-LOCK
            WHERE  int-item.it-codigo = tt-item.it-codigo NO-ERROR.
        IF  NOT AVAIL int-item THEN DO:
            CREATE int-item.
            ASSIGN int-item.it-codigo = tt-item.it-codigo.
        END.
        ASSIGN int-item.destaque        = tt-item-xml.destaq-ncm
               int-item.perc-gatt       = tt-item-xml.perc-gatt
               int-item.log-gatt        = tt-item-xml.perc-gatt <> 0
               int-item.ex-tarifario    = tt-item-xml.ex-tarifario
               int-item.nve             = tt-item-xml.nve
               int-item.seq-suframa     = tt-item-xml.seq-suframa
               int-item.log-antidumping = tt-item-xml.log-antidumping
               int-item.obs-antidumping = tt-item-xml.obs-antidumping.
        

        /* CEST - C¢digo especificador da substituiá∆o tribut†ria - Carlos Daniel - 04/03/2016*/
        RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

        ASSIGN c-mensagem = "".

        RUN piGeraRelactoCest IN h-esmsspapi001 (INPUT tt-item-xml.cest,  /* CEST */
                                                 INPUT TODAY,             /* Data inicio validade */
                                                 INPUT "*",               /* Estabelecimento */
                                                 INPUT "*",               /* UF */
                                                 INPUT "*",               /* Natureza de Operaá∆o */
                                                 INPUT "*",               /* NCM */
                                                 INPUT tt-item.it-codigo, /* Item */
                                                 INPUT 0,                 /* Emitente */
                                                 OUTPUT c-mensagem).

        IF VALID-HANDLE(h-esmsspapi001) THEN
            DELETE PROCEDURE h-esmsspapi001.

        IF RETURN-VALUE <> "OK" THEN DO:
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.tip-msgs = 1
                   tt-mensagem.mensagem = c-mensagem.
            STOP.
        END.
       
        /* Trata Caracter°stica do Item */
        RUN pi-caracteristica-item IN THIS-PROCEDURE.

        IF RETURN-VALUE = "NOK":U THEN
            STOP.
    END.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tip-msgs = 2
           tt-mensagem.mensagem = "Item: ":U + tt-item.it-codigo.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.



/*--- Procedures Internas ---*/


PROCEDURE pi-caracteristica-item:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH  comp-folh NO-LOCK
        WHERE comp-folh.cd-folha = "1":

        FIND FIRST it-carac-tec EXCLUSIVE-LOCK
            WHERE  it-carac-tec.it-codigo = tt-item.it-codigo
            AND    it-carac-tec.cd-folha  = comp-folh.cd-folha
            AND    it-carac-tec.cd-comp   = comp-folh.cd-comp NO-ERROR.
        IF  NOT AVAIL it-carac-tec THEN DO:
            CREATE it-carac-tec.
            ASSIGN it-carac-tec.it-codigo = tt-item.it-codigo 
                   it-carac-tec.cd-folha  = comp-folh.cd-folha 
                   it-carac-tec.cd-comp   = comp-folh.cd-comp.
        END.

        ASSIGN it-carac-tec.tipo-result = comp-folh.tipo-result.

        IF  comp-folh.nr-tabela <> 0 THEN DO:


            IF  pTipoRequisicao = 2 /* Alteraá∆o */ THEN DO:
                FOR EACH  it-res-carac EXCLUSIVE-LOCK
                    WHERE it-res-carac.it-codigo = tt-item.it-codigo   
                    AND   it-res-carac.cd-folha  = comp-folh.cd-folha  
                    AND   it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND   it-res-carac.nr-tabela = comp-folh.nr-tabela:
                    DELETE it-res-carac.
                END.
            END.


            /* Amostragem */
            IF  comp-folh.nr-tabela = 3 THEN DO:
                FIND FIRST it-res-carac NO-LOCK
                    WHERE  it-res-carac.it-codigo = tt-item.it-codigo
                    AND    it-res-carac.cd-folha  = comp-folh.cd-folha
                    AND    it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND    it-res-carac.nr-tabela = comp-folh.nr-tabela
                    AND    it-res-carac.sequencia = tt-item-xml.cod-amost NO-ERROR.
                IF  NOT AVAIL it-res-carac then do:
                     CREATE it-res-carac.
                     ASSIGN it-res-carac.it-codigo   = tt-item.it-codigo
                            it-res-carac.cd-folha    = comp-folh.cd-folha
                            it-res-carac.cd-comp     = comp-folh.cd-comp
                            it-res-carac.nr-tabela   = comp-folh.nr-tabela
                            it-res-carac.sequencia   = tt-item-xml.cod-amost
                            it-res-carac.tipo-result = comp-folh.tipo-result.
                END.
                ASSIGN it-carac-tec.observacao  = tt-item-xml.des-amost .
            END. 

            /* Acondicionamento */
            IF  comp-folh.nr-tabela = 4 THEN DO:
                FIND FIRST it-res-carac NO-LOCK
                    WHERE  it-res-carac.it-codigo = tt-item.it-codigo   
                    AND    it-res-carac.cd-folha  = comp-folh.cd-folha
                    AND    it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND    it-res-carac.nr-tabela = comp-folh.nr-tabela
                    AND    it-res-carac.sequencia = int(tt-item-xml.cod-acond) NO-ERROR.
                IF  NOT AVAIL it-res-carac then do:
                     CREATE it-res-carac.
                     ASSIGN it-res-carac.it-codigo   = tt-item.it-codigo
                            it-res-carac.cd-folha    = comp-folh.cd-folha
                            it-res-carac.cd-comp     = comp-folh.cd-comp
                            it-res-carac.nr-tabela   = comp-folh.nr-tabela
                            it-res-carac.sequencia   = int(tt-item-xml.cod-acond)
                            it-res-carac.tipo-result = comp-folh.tipo-result.
                END.
                ASSIGN it-carac-tec.observacao  = tt-item-xml.des-acond.
            END.
        END.

        /* Vers∆o - tipo numerico = 1 */
        IF  comp-folh.tipo-result = 1 THEN DO:
            IF  comp-folh.descricao = "versao" THEN
                ASSIGN it-carac-tec.vl-result  = INT(tt-item-xml.versao).
        END.

        /* Informacaoes adicionais - tipo texto = 3 */
        IF  comp-folh.tipo-result = 3 THEN DO:
            FIND FIRST it-msg-carac EXCLUSIVE-LOCK
                WHERE  it-msg-carac.it-codigo = tt-item.it-codigo
                AND    it-msg-carac.cd-folha  = comp-folh.cd-folha
                AND    it-msg-carac.cd-comp   = comp-folh.cd-comp NO-ERROR.
            IF  NOT AVAIL it-msg-carac THEN DO:
                CREATE it-msg-carac.
                ASSIGN it-msg-carac.it-codigo = tt-item.it-codigo
                       it-msg-carac.cd-folha  = comp-folh.cd-folha
                       it-msg-carac.cd-comp   = comp-folh.cd-comp.
            END.
            ASSIGN it-msg-carac.msg-ex     = tt-item-xml.inf-adic
                   it-carac-tec.observacao = tt-item-xml.inf-adic.
        END.

        /* Responsavel - tipo observacao = 4 */
        IF  comp-folh.tipo-result = 4 THEN DO:
            IF  comp-folh.descricao = "Responsavel" THEN
                ASSIGN it-carac-tec.observacao = tt-item.responsavel.
        END.

        /* Data Versao - tipo data = 6 */
        IF  comp-folh.tipo-result = 6 THEN DO:
            IF  comp-folh.descricao = "Data da Versao" THEN
                ASSIGN it-carac-tec.dt-result  = DATE(tt-item-xml.data-versao).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

