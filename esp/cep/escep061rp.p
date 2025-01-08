/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP061RP 2.00.00.004}
/*------------------------------------------------------------------------
    File        : ESCEP061RP.P
    Purpose     : Invent rio
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Novembro de 2011
    Notes       : <none>
----------------------------------------------------------------------*/

/* Include Definitions ---                                              */

{esp/cep/escep061.i} /* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita de uso comum aos programas ESCEP061.W e ESCEP061RP.P */
{include/i-rpvar.i}


/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-inventario NO-UNDO
    FIELD it-codigo          LIKE item-uni-estab.it-codigo
    FIELD desc-item          LIKE item.desc-item
    FIELD val-unit-item      LIKE item-estab.val-unit-mat-m[1]
    FIELD saldo-est-dep-1    AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-dep-2    AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-nfs-1    AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-nfs-2    AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-transf-1 AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-transf-2 AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-ae       AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD saldo-est-cst      AS DECIMAL  FORMAT "->,>>>,>>9.99":U
    FIELD nr-linha           AS INTEGER
    FIELD log-pai            AS LOGICAL
    INDEX chItem AS PRIMARY UNIQUE
        it-codigo.

DEFINE TEMP-TABLE tt-detalhes-ae NO-UNDO
    FIELD nr-ae        LIKE ae-item.nr-ae
    FIELD sequencia    LIKE ae-item.sequencia
    FIELD it-codigo    LIKE item-uni-estab.it-codigo
    FIELD desc-item    LIKE item.desc-item
    FIELD localizacao  LIKE ae-item.localizacao
    FIELD data         LIKE ae-item.data
    FIELD qtd-baixado  LIKE ae-item.quantidade
    FIELD qtd-pendente LIKE ae-item.quantidade
    FIELD nr-linha     AS INTEGER 
    INDEX ae-seq AS PRIMARY UNIQUE
        nr-ae
        sequencia.

DEFINE TEMP-TABLE tt-notas NO-UNDO
    FIELD it-codigo    LIKE tt-inventario.it-codigo
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel
    FIELD cod-depos    LIKE fat-ser-lote.cod-depos
    FIELD serie        LIKE nota-fiscal.serie
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    FIELD cod-cliente  LIKE emitente.cod-emitente
    FIELD nome-cliente LIKE emitente.nome-emit
    FIELD nome-transp  LIKE nota-fiscal.nome-transp
    FIELD quant        AS DECIMAL FORMAT ">>>>,>>9.9999":U
    FIELD qtd-devol    AS DECIMAL FORMAT ">>>>,>>9.9999":U
    FIELD qtd-colet    AS DECIMAL FORMAT ">>>>,>>9.9999":U
    FIELD coletada     AS LOGICAL
    FIELD nr-linha     AS INTEGER
    INDEX ITEM it-codigo.


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.


/* Global Variable Definitions ---                                      */

DEFINE NEW GLOBAL SHARED VARIABLE c-dir-spool-servid-exec AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-num-ped-exec-rpw      AS INTEGER     NO-UNDO.


/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-csv.
DEFINE STREAM str-ae.


/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Invent rio":U
       c-sistema      = "Espec¡ficos Intelbras":U.

{include/i-rpcab.i &stream="str-rp"}
{include/i-rpout.i &stream="STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

IF NOT VALID-HANDLE(h-acomp) THEN RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.
IF     VALID-HANDLE(h-acomp) THEN RUN pi-inicializar IN h-acomp (INPUT "Gerando Invent rio...":U) NO-ERROR.

RUN pi-gerar-dados IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio...":U).

RUN pi-impres-param IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &stream="STREAM str-rp"}

IF VALID-HANDLE(h-acomp) THEN DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-gerar-dados:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-qtd-devol AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-qtd-coletada AS DECIMAL NO-UNDO.

    DEFINE VARIABLE c-estabs AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-depos AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dep AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
    

    EMPTY TEMP-TABLE tt-inventario.
    EMPTY TEMP-TABLE tt-detalhes-ae.


    /* Estabelecimento e Dep¢sito 1 */

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo - Estab.: ":U + tt-param.cod-estabel-1 + " - Depos.: ":U + tt-param.cod-depos-1).

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FOR EACH saldo-estoq FIELDS(qtidade-atu it-codigo cod-estabel cod-localiz) USE-INDEX estabel-dep NO-LOCK
                WHERE saldo-estoq.cod-estabel  = tt-param.cod-estabel-1
                  AND saldo-estoq.cod-depos    = tt-param.cod-depos-1
                  AND saldo-estoq.cod-localiz >= tt-param.cod-localiz-ini
                  AND saldo-estoq.cod-localiz <= tt-param.cod-localiz-fin
                  AND saldo-estoq.it-codigo    = tt-digita.it-codigo
                  AND saldo-estoq.qtidade-atu <> 0,
                FIRST item FIELDS(desc-item) NO-LOCK
                WHERE item.it-codigo = saldo-estoq.it-codigo,
                FIRST item-uni-estab FIELDS() NO-LOCK
                WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                  AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel:

                IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Localiz.: ":U + saldo-estoq.cod-localiz + " - Item: ":U + saldo-estoq.it-codigo).

                FIND FIRST tt-inventario
                    WHERE tt-inventario.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.

                IF NOT AVAILABLE tt-inventario THEN DO:
                    CREATE tt-inventario.
                    ASSIGN tt-inventario.it-codigo = saldo-estoq.it-codigo
                           tt-inventario.desc-item = item.desc-item
                           tt-inventario.nr-linha  = item-uni-estab.nr-linha
                           tt-inventario.log-pai   = TRUE.

                    FIND FIRST item-estab
                        WHERE item-estab.it-codigo   = saldo-estoq.it-codigo
                          AND item-estab.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                    ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                END.

                ASSIGN tt-inventario.saldo-est-dep-1 = tt-inventario.saldo-est-dep-1 + saldo-estoq.qtidade-atu.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH saldo-estoq FIELDS(qtidade-atu it-codigo cod-estabel cod-localiz) USE-INDEX estabel-dep NO-LOCK
            WHERE saldo-estoq.cod-estabel  = tt-param.cod-estabel-1
              AND saldo-estoq.cod-depos    = tt-param.cod-depos-1
              AND saldo-estoq.cod-localiz >= tt-param.cod-localiz-ini
              AND saldo-estoq.cod-localiz <= tt-param.cod-localiz-fin
              AND saldo-estoq.it-codigo   >= tt-param.it-codigo-ini
              AND saldo-estoq.it-codigo   <= tt-param.it-codigo-fin
              AND saldo-estoq.qtidade-atu <> 0,
            FIRST item FIELDS(desc-item) NO-LOCK
            WHERE item.it-codigo = saldo-estoq.it-codigo,
            FIRST item-uni-estab FIELDS() NO-LOCK
            WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
              AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel:

            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Localiz.: ":U + saldo-estoq.cod-localiz + " - Item: ":U + saldo-estoq.it-codigo).

            FIND FIRST tt-inventario
                WHERE tt-inventario.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE tt-inventario THEN DO:
                CREATE tt-inventario.
                ASSIGN tt-inventario.it-codigo = saldo-estoq.it-codigo
                       tt-inventario.desc-item = item.desc-item
                       tt-inventario.nr-linha  = item-uni-estab.nr-linha
                       tt-inventario.log-pai   = TRUE.

                FIND FIRST item-estab
                    WHERE item-estab.it-codigo   = saldo-estoq.it-codigo
                      AND item-estab.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
            END.

            ASSIGN tt-inventario.saldo-est-dep-1 = tt-inventario.saldo-est-dep-1 + saldo-estoq.qtidade-atu.
        END.
    END.



    /* Estabelecimento e Dep¢sito 2 */

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo - Estab.: ":U + tt-param.cod-estabel-2 + " - Depos.: ":U + tt-param.cod-depos-2).

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FOR EACH saldo-estoq FIELDS(qtidade-atu it-codigo cod-estabel cod-localiz) USE-INDEX estabel-dep NO-LOCK
                WHERE saldo-estoq.cod-estabel  = tt-param.cod-estabel-2
                  AND saldo-estoq.cod-depos    = tt-param.cod-depos-2
                  AND saldo-estoq.cod-localiz >= tt-param.cod-localiz-ini
                  AND saldo-estoq.cod-localiz <= tt-param.cod-localiz-fin
                  AND saldo-estoq.it-codigo    = tt-digita.it-codigo
                  AND saldo-estoq.qtidade-atu <> 0,
                FIRST item FIELDS(desc-item) NO-LOCK
                WHERE item.it-codigo = saldo-estoq.it-codigo,
                FIRST item-uni-estab FIELDS() NO-LOCK
                WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                  AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel:

                IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Localiz.: ":U + saldo-estoq.cod-localiz + " - Item: ":U + saldo-estoq.it-codigo).

                FIND FIRST tt-inventario
                    WHERE tt-inventario.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.

                IF NOT AVAILABLE tt-inventario THEN DO:
                    CREATE tt-inventario.
                    ASSIGN tt-inventario.it-codigo = saldo-estoq.it-codigo
                           tt-inventario.desc-item = item.desc-item
                           tt-inventario.nr-linha  = item-uni-estab.nr-linha
                           tt-inventario.log-pai   = TRUE.

                    FIND FIRST item-estab
                        WHERE item-estab.it-codigo   = saldo-estoq.it-codigo
                          AND item-estab.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                    ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                END.

                ASSIGN tt-inventario.saldo-est-dep-2 = tt-inventario.saldo-est-dep-2 + saldo-estoq.qtidade-atu.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH saldo-estoq FIELDS(qtidade-atu it-codigo cod-estabel cod-localiz) USE-INDEX estabel-dep NO-LOCK
            WHERE saldo-estoq.cod-estabel  = tt-param.cod-estabel-2
              AND saldo-estoq.cod-depos    = tt-param.cod-depos-2
              AND saldo-estoq.cod-localiz >= tt-param.cod-localiz-ini
              AND saldo-estoq.cod-localiz <= tt-param.cod-localiz-fin
              AND saldo-estoq.it-codigo   >= tt-param.it-codigo-ini
              AND saldo-estoq.it-codigo   <= tt-param.it-codigo-fin
              AND saldo-estoq.qtidade-atu <> 0,
            FIRST item FIELDS(desc-item) NO-LOCK
            WHERE item.it-codigo = saldo-estoq.it-codigo,
            FIRST item-uni-estab FIELDS() NO-LOCK
            WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
              AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel:

            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Localiz.: ":U + saldo-estoq.cod-localiz + " - Item: ":U + saldo-estoq.it-codigo).

            FIND FIRST tt-inventario
                WHERE tt-inventario.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE tt-inventario THEN DO:
                CREATE tt-inventario.
                ASSIGN tt-inventario.it-codigo = saldo-estoq.it-codigo
                       tt-inventario.desc-item = item.desc-item
                       tt-inventario.nr-linha  = item-uni-estab.nr-linha
                       tt-inventario.log-pai   = TRUE.

                FIND FIRST item-estab
                    WHERE item-estab.it-codigo   = saldo-estoq.it-codigo
                      AND item-estab.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.

                ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
            END.

            ASSIGN tt-inventario.saldo-est-dep-2 = tt-inventario.saldo-est-dep-2 + saldo-estoq.qtidade-atu.
        END.
    END.

    /**/

    /*IF CAN-FIND(FIRST tt-inventario) THEN DO:*/

        IF tt-param.cons-saldo-transf THEN DO:

            IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo Transferencia - Estab.: ":U + tt-param.cod-estabel-1).

            FOR FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = tt-param.cod-estabel-1,
                EACH saldo-terc NO-LOCK
                WHERE saldo-terc.cod-emitente  = estabelec.cod-emitente
                AND   saldo-terc.it-codigo >= tt-param.it-codigo-ini
                AND   saldo-terc.it-codigo <= tt-param.it-codigo-fin
                  AND saldo-terc.tipo-sal-terc = 3, /* transito */
                EACH componente OF saldo-terc NO-LOCK:

                IF saldo-terc.quantidade = 0 THEN NEXT.

                FIND FIRST tt-inventario
                    WHERE tt-inventario.it-codigo = saldo-terc.it-codigo NO-LOCK NO-ERROR.
    
                IF  NOT AVAILABLE tt-inventario THEN DO:

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = saldo-terc.it-codigo:
                    END.

                    FOR FIRST item-uni-estab NO-LOCK
                        WHERE item-uni-estab.it-codigo   = saldo-terc.it-codigo
                        AND   item-uni-estab.cod-estabel = estabelec.cod-estabel:
                    END.

                    CREATE tt-inventario.
                    ASSIGN tt-inventario.it-codigo = saldo-terc.it-codigo
                           tt-inventario.desc-item = item.desc-item
                           tt-inventario.nr-linha  = item-uni-estab.nr-linha
                           tt-inventario.log-pai   = TRUE.

    
                    FIND FIRST item-estab
                        WHERE  item-estab.it-codigo   = saldo-terc.it-codigo
                          AND  item-estab.cod-estabel = saldo-terc.cod-estabel NO-LOCK NO-ERROR.
    
                    ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                END.

                IF VALID-HANDLE(h-acomp) THEN 
                    RUN pi-acompanhar IN h-acomp (INPUT "Docto: ":U + saldo-terc.nro-docto + "/":U + saldo-terc.serie-docto + " - Item: ":U + tt-inventario.it-codigo).

                ASSIGN tt-inventario.saldo-est-transf-1 = tt-inventario.saldo-est-transf-1 + componente.quantidade.

            END. /* FOR FIRST estabelec NO-LOCK */

            IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 THEN DO:

                IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo Transferencia - Estab.: ":U + tt-param.cod-estabel-2).
    
                FOR FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = tt-param.cod-estabel-2,
                    EACH saldo-terc NO-LOCK
                    WHERE saldo-terc.cod-emitente  = estabelec.cod-emitente
                    AND   saldo-terc.it-codigo    >= tt-param.it-codigo-ini
                    AND   saldo-terc.it-codigo    <= tt-param.it-codigo-fin
                      AND saldo-terc.tipo-sal-terc = 3, /* transito */
                    EACH componente OF saldo-terc NO-LOCK:

                    IF saldo-terc.quantidade = 0 THEN NEXT.

                    FIND FIRST tt-inventario
                        WHERE tt-inventario.it-codigo = saldo-terc.it-codigo NO-LOCK NO-ERROR.
        
                    IF  NOT AVAILABLE tt-inventario THEN DO:
    
                        FOR FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = saldo-terc.it-codigo:
                        END.

                        FOR FIRST item-uni-estab NO-LOCK
                            WHERE item-uni-estab.it-codigo   = saldo-terc.it-codigo
                            AND   item-uni-estab.cod-estabel = estabelec.cod-estabel:
                        END.
    
                        CREATE tt-inventario.
                        ASSIGN tt-inventario.it-codigo   = saldo-terc.it-codigo
                               tt-inventario.desc-item   = item.desc-item
                               tt-inventario.nr-linha    = item-uni-estab.nr-linha
                               tt-inventario.log-pai   = TRUE.
        
                        FIND FIRST item-estab
                            WHERE  item-estab.it-codigo   = saldo-terc.it-codigo
                              AND  item-estab.cod-estabel = saldo-terc.cod-estabel NO-LOCK NO-ERROR.
        
                        ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                    END.
    
                    IF VALID-HANDLE(h-acomp) THEN 
                        RUN pi-acompanhar IN h-acomp (INPUT "Docto: ":U + saldo-terc.nro-docto + "/":U + saldo-terc.serie-docto + " - Item: ":U + tt-inventario.it-codigo).
    
                    ASSIGN tt-inventario.saldo-est-transf-2 = tt-inventario.saldo-est-transf-2 + componente.quantidade.

                END. /* FOR FIRST estabelec NO-LOCK */

            END.

        END. /* IF tt-param.cons-saldo-transf THEN DO: */

        IF tt-param.cons-saldo-ae THEN DO:

            IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo AE - Estab.: ":U + tt-param.cod-estabel-1).

            FOR EACH ae-item USE-INDEX deposito NO-LOCK
                WHERE ae-item.cod-estabel  = tt-param.cod-estabel-1
                  AND ae-item.cod-depos    = tt-param.cod-depos-1
                  AND ae-item.localizacao >= tt-param.cod-localiz-ini
                  AND ae-item.localizacao <= tt-param.cod-localiz-fin
                  AND ae-item.it-codigo   >= tt-param.it-codigo-ini
                  AND ae-item.it-codigo   <= tt-param.it-codigo-fin,
                FIRST item-uni-estab FIELDS() NO-LOCK
                WHERE item-uni-estab.it-codigo   = ae-item.it-codigo
                  AND item-uni-estab.cod-estabel = ae-item.cod-estabel:

                IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Nr AE: ":U + TRIM(STRING(ae-item.nr-ae)) + " - Item: ":U + ae-item.it-codigo).

                IF  ae-item.situacao THEN DO:
                    FIND FIRST ae-baixa
                        WHERE ae-baixa.cod-estabel = ae-item.cod-estabel
                          AND ae-baixa.nr-ae       = ae-item.nr-ae
                          AND ae-baixa.sequencia   = ae-item.sequencia NO-LOCK NO-ERROR.

                    IF  AVAILABLE ae-baixa THEN DO:

                        FIND FIRST tt-inventario
                            WHERE tt-inventario.it-codigo = ae-item.it-codigo NO-LOCK NO-ERROR.
            
                        IF  NOT AVAILABLE tt-inventario THEN DO:
        
                            FOR FIRST ITEM NO-LOCK
                                WHERE ITEM.it-codigo = ae-item.it-codigo:
                            END.
        
                            CREATE tt-inventario.
                            ASSIGN tt-inventario.it-codigo = ae-item.it-codigo
                                   tt-inventario.desc-item = item.desc-item
                                   tt-inventario.nr-linha  = item-uni-estab.nr-linha
                                   tt-inventario.log-pai   = TRUE.
            
                            FIND FIRST item-estab
                                WHERE  item-estab.it-codigo   = ae-item.it-codigo
                                  AND  item-estab.cod-estabel = ae-item.cod-estabel NO-LOCK NO-ERROR.
            
                            ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                        END.


                        ASSIGN tt-inventario.saldo-est-ae = tt-inventario.saldo-est-ae + ae-item.quantidade.

                        IF  tt-param.gerar-detalhes-ae THEN DO:
                            FIND FIRST tt-detalhes-ae
                                WHERE tt-detalhes-ae.nr-ae     = ae-item.nr-ae
                                  AND tt-detalhes-ae.sequencia = ae-item.sequencia EXCLUSIVE-LOCK NO-ERROR.

                            IF  NOT AVAILABLE tt-detalhes-ae THEN DO:
                                CREATE tt-detalhes-ae.
                                ASSIGN tt-detalhes-ae.nr-ae       = ae-item.nr-ae
                                       tt-detalhes-ae.sequencia   = ae-item.sequencia
                                       tt-detalhes-ae.it-codigo   = ae-item.it-codigo
                                       tt-detalhes-ae.desc-item   = tt-inventario.desc-item
                                       tt-detalhes-ae.localizacao = ae-baixa.localizacao
                                       tt-detalhes-ae.data        = ae-item.data
                                       tt-detalhes-ae.nr-linha    = item-uni-estab.nr-linha.
                            END. /* IF NOT AVAILABLE tt-detalhes-ae THEN DO: */

                            ASSIGN tt-detalhes-ae.qtd-baixado = tt-detalhes-ae.qtd-baixado + ae-item.quantidade.
                        END. /* IF tt-param.gerar-detalhes-ae THEN DO: */
                    END. /* IF AVAILABLE ae-baixa THEN DO: */
                END. /* IF ae-item.situacao THEN DO: */
                ELSE DO:

                    FIND FIRST tt-inventario
                        WHERE tt-inventario.it-codigo = ae-item.it-codigo NO-LOCK NO-ERROR.
        
                    IF  NOT AVAILABLE tt-inventario THEN DO:
    
                        FOR FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = ae-item.it-codigo:
                        END.
    
                        CREATE tt-inventario.
                        ASSIGN tt-inventario.it-codigo = ae-item.it-codigo
                               tt-inventario.desc-item = item.desc-item
                               tt-inventario.nr-linha  = item-uni-estab.nr-linha
                               tt-inventario.log-pai   = TRUE.
        
                        FIND FIRST item-estab
                            WHERE  item-estab.it-codigo   = ae-item.it-codigo
                              AND  item-estab.cod-estabel = ae-item.cod-estabel NO-LOCK NO-ERROR.
        
                        ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                    END.

                    ASSIGN tt-inventario.saldo-est-ae = tt-inventario.saldo-est-ae + ae-item.quantidade.

                    IF tt-param.gerar-detalhes-ae THEN DO:
                        FIND FIRST tt-detalhes-ae
                            WHERE tt-detalhes-ae.nr-ae     = ae-item.nr-ae
                              AND tt-detalhes-ae.sequencia = ae-item.sequencia EXCLUSIVE-LOCK NO-ERROR.

                        IF NOT AVAILABLE tt-detalhes-ae THEN DO:
                            CREATE tt-detalhes-ae.
                            ASSIGN tt-detalhes-ae.nr-ae       = ae-item.nr-ae
                                   tt-detalhes-ae.sequencia   = ae-item.sequencia
                                   tt-detalhes-ae.it-codigo   = ae-item.it-codigo
                                   tt-detalhes-ae.desc-item   = tt-inventario.desc-item
                                   tt-detalhes-ae.localizacao = ae-item.localizacao
                                   tt-detalhes-ae.data        = ae-item.data
                                   tt-detalhes-ae.nr-linha    = item-uni-estab.nr-linha.
                        END. /* IF NOT AVAILABLE tt-detalhes-ae THEN DO: */

                        ASSIGN tt-detalhes-ae.qtd-pendente = tt-detalhes-ae.qtd-pendente + ae-item.quantidade.
                    END. /* IF tt-param.gerar-detalhes-ae THEN DO: */
                END. /* ELSE DO: - IF ae-item.situacao THEN DO: */
            END. /* FOR EACH ae-item USE-INDEX deposito NO-LOCK */
        END. /* IF tt-param.cons-saldo-ae THEN DO: */

        IF tt-param.cons-saldo-cst THEN DO:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo - Estab.: ":U + tt-param.cod-estabel-1 + " - Localiz.: CST":U).

            FOR EACH saldo-estoq FIELDS(it-codigo cod-estabel qtidade-atu) USE-INDEX estabel-dep NO-LOCK
                WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel-1
                  AND saldo-estoq.cod-depos   = tt-param.cod-depos-1
                  AND saldo-estoq.cod-localiz = "CST":U
                  AND saldo-estoq.it-codigo   >= tt-param.it-codigo-ini
                  AND saldo-estoq.it-codigo   <= tt-param.it-codigo-fin,
                FIRST item-uni-estab FIELDS() NO-LOCK
                WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                  AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel:

                IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + saldo-estoq.it-codigo).

                FIND FIRST tt-inventario
                    WHERE tt-inventario.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
    
                IF  NOT AVAILABLE tt-inventario THEN DO:

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = saldo-estoq.it-codigo:
                    END.

                    CREATE tt-inventario.
                    ASSIGN tt-inventario.it-codigo = saldo-estoq.it-codigo
                           tt-inventario.desc-item = item.desc-item
                           tt-inventario.nr-linha  = item-uni-estab.nr-linha
                           tt-inventario.log-pai   = TRUE.
    
                    FIND FIRST item-estab
                        WHERE  item-estab.it-codigo   = saldo-estoq.it-codigo
                          AND  item-estab.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.
    
                    ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                END.


                ASSIGN tt-inventario.saldo-est-cst = tt-inventario.saldo-est-cst + saldo-estoq.qtidade-atu.
            END.
        END.

    /*
    END. /* IF CAN-FIND(FIRST tt-inventario) THEN DO: */
    */

    IF  tt-param.gerar-detalhes-ae THEN DO:
        IF  VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Buscando Baixados - Estab.: ":U + tt-param.cod-estabel-1).

        FOR EACH  ae-item USE-INDEX deposito NO-LOCK
            WHERE ae-item.cod-estabel  = tt-param.cod-estabel-1
              AND ae-item.cod-depos    = tt-param.cod-depos-1
              AND ae-item.localizacao >= tt-param.cod-localiz-ini
              AND ae-item.localizacao <= tt-param.cod-localiz-fin
              AND ae-item.it-codigo   >= tt-param.it-codigo-ini
              AND ae-item.it-codigo   <= tt-param.it-codigo-fin,
            FIRST item-uni-estab FIELDS() NO-LOCK
            WHERE item-uni-estab.it-codigo   = ae-item.it-codigo
              AND item-uni-estab.cod-estabel = ae-item.cod-estabel,
            FIRST item OF ae-item NO-LOCK:

            IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Nr AE: ":U + TRIM(STRING(ae-item.nr-ae)) + " - Item: ":U + ae-item.it-codigo).

            IF  ae-item.situacao THEN DO:
                FIND FIRST ae-baixa
                    WHERE  ae-baixa.cod-estabel = ae-item.cod-estabel
                      AND  ae-baixa.nr-ae       = ae-item.nr-ae
                      AND  ae-baixa.sequencia   = ae-item.sequencia NO-LOCK NO-ERROR.
                IF  AVAILABLE ae-baixa THEN DO:
                    IF  tt-param.gerar-detalhes-ae THEN DO:
                        FIND FIRST tt-detalhes-ae
                            WHERE  tt-detalhes-ae.nr-ae     = ae-item.nr-ae
                              AND  tt-detalhes-ae.sequencia = ae-item.sequencia EXCLUSIVE-LOCK NO-ERROR.
                        IF  NOT AVAILABLE tt-detalhes-ae THEN DO:
                            CREATE tt-detalhes-ae.
                            ASSIGN tt-detalhes-ae.nr-ae       = ae-item.nr-ae
                                   tt-detalhes-ae.sequencia   = ae-item.sequencia
                                   tt-detalhes-ae.it-codigo   = ae-item.it-codigo
                                   tt-detalhes-ae.desc-item   = item.desc-item
                                   tt-detalhes-ae.localizacao = ae-baixa.localizacao
                                   tt-detalhes-ae.data        = ae-item.data
                                   tt-detalhes-ae.qtd-baixado = tt-detalhes-ae.qtd-baixado + ae-item.quantidade
                                   tt-detalhes-ae.nr-linha    = item-uni-estab.nr-linha.

                        END. /* IF NOT AVAILABLE tt-detalhes-ae THEN DO: */
                    END. /* IF tt-param.gerar-detalhes-ae THEN DO: */
                END. /* IF AVAILABLE ae-baixa THEN DO: */
            END. /* IF ae-item.situacao THEN DO: */
        END. /* FOR EACH  ae-item */
    END. /* IF  tt-param.gerar-detalhes-ae THEN DO: */

    IF  tt-param.cons-saldo-nfs THEN DO:

        ASSIGN c-depos  = tt-param.cod-depos-1   + ";" + tt-param.cod-depos-2
               c-estabs = tt-param.cod-estabel-1 + ";" + tt-param.cod-estabel-2.

        DO i-aux = 1 TO 2:

            ASSIGN c-estab = ENTRY(i-aux, c-estabs, ";")
                   c-dep   = ENTRY(i-aux, c-depos, ";").

            IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo NFS - Estab.: ":U + c-estab).
    
            FOR EACH  nota-fiscal USE-INDEX ch-nota NO-LOCK
                WHERE nota-fiscal.cod-estabel   = c-estab
                  AND nota-fiscal.dt-emis-nota >= tt-param.dt-corte-nfs,
                FIRST int-nota-fiscal OF nota-fiscal NO-LOCK,
                FIRST natur-oper OF nota-fiscal NO-LOCK,
                EACH  it-nota-fisc OF nota-fiscal NO-LOCK
                    WHERE it-nota-fisc.it-codigo >= tt-param.it-codigo-ini
                    AND   it-nota-fisc.it-codigo <= tt-param.it-codigo-fin,
                EACH  fat-ser-lote USE-INDEX ch-lote NO-LOCK
                WHERE fat-ser-lote.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-ser-lote.serie       = nota-fiscal.serie
                  AND fat-ser-lote.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                  AND fat-ser-lote.cod-depos   = c-dep
                  AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo,
                FIRST ITEM OF it-nota-fisc NO-LOCK:
    
                IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "NFS: ":U + nota-fiscal.nr-nota-fis + "/":U + nota-fiscal.serie + " - Item: ":U + it-nota-fisc.it-codigo).
    
                /*                                                                                                                                                              
                IF it-nota-fisc.it-codigo < tt-param.it-codigo-ini
                OR it-nota-fisc.it-codigo > tt-param.it-codigo-fin THEN NEXT.
                */
    
                /*IF int-nota-fiscal.log-saida THEN NEXT.*/
    
                IF nota-fiscal.dt-cancela   <> ?    OR
                   nota-fiscal.dt-saida     <> ?    /*OR
                   nota-fiscal.dt-embarque  <> ?    OR
                   nota-fiscal.desc-cancela <> "":U OR
                   nota-fiscal.nr-pedcli     = "":U*/ THEN NEXT.
    
                /*
                IF NOT natur-oper.emite-duplic OR
                   natur-oper.imp-nota         OR
                   natur-oper.tipo <> 2        OR
                   NOT natur-oper.baixa-estoq  OR
                   natur-oper.transf           THEN NEXT.
                   */
    
                FIND FIRST tt-inventario
                    WHERE tt-inventario.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

                FOR FIRST item-uni-estab NO-LOCK
                    WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
                    AND   item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel:
                END.
    
                IF  NOT AVAILABLE tt-inventario THEN DO:
                    CREATE tt-inventario.
                    ASSIGN tt-inventario.it-codigo = it-nota-fisc.it-codigo
                           tt-inventario.desc-item = item.desc-item
                           tt-inventario.nr-linha  = item-uni-estab.nr-linha
                           tt-inventario.log-pai   = TRUE.
    
                    FIND FIRST item-estab
                        WHERE  item-estab.it-codigo   = it-nota-fisc.it-codigo
                          AND  item-estab.cod-estabel = it-nota-fisc.cod-estabel NO-LOCK NO-ERROR.
    
                    ASSIGN tt-inventario.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.
                END.
                
                /*IF i-aux = 1 OR tt-param.cod-depos-1 = tt-param.cod-depos-2 THEN*/
                IF i-aux = 1 OR tt-param.cod-estabel-1 = tt-param.cod-estabel-2 THEN
                    ASSIGN tt-inventario.saldo-est-nfs-1 = tt-inventario.saldo-est-nfs-1 + fat-ser-lote.qt-baixada[1].
                ELSE
                    ASSIGN tt-inventario.saldo-est-nfs-2 = tt-inventario.saldo-est-nfs-2 + fat-ser-lote.qt-baixada[1].
    
                FIND FIRST emitente NO-LOCK
                    WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
                FIND FIRST tt-notas
                    WHERE tt-notas.it-codigo   = it-nota-fisc.it-codigo
                      AND tt-notas.cod-estabel = nota-fiscal.cod-estabel
                      AND tt-notas.serie       = nota-fiscal.serie
                      AND tt-notas.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
                IF NOT AVAILABLE tt-notas THEN DO:
                    CREATE tt-notas.
                    ASSIGN tt-notas.it-codigo    = it-nota-fisc.it-codigo
                           tt-notas.cod-estabel  = nota-fiscal.cod-estabel
                           tt-notas.serie        = nota-fiscal.serie
                           tt-notas.nr-nota-fis  = nota-fiscal.nr-nota-fis
                           tt-notas.nat-operacao = nota-fiscal.nat-operacao
                           tt-notas.cod-cliente  = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0
                           tt-notas.nome-cliente = IF AVAIL emitente THEN emitente.nome-emit    ELSE ""
                           tt-notas.nome-transp  = nota-fiscal.nome-transp
                           tt-notas.quant        = 0
                           tt-notas.coletada     = FALSE
                           tt-notas.nr-linha     = item-uni-estab.nr-linha.
                END.
    
                ASSIGN tt-notas.quant = tt-notas.quant + fat-ser-lote.qt-baixada[1].
    
            END.

        END.
        
        /**/

        IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Invent rio - Saldo NFS - Devolu‡Æo":U).

        FOR EACH tt-notas:

            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "NFS: ":U + tt-notas.nr-nota-fis + "/":U + tt-notas.serie + " - Item: ":U + tt-notas.it-codigo + " - Est.: ":U + tt-notas.cod-estabel).

            ASSIGN de-qtd-devol = 0
                   de-qtd-coletada = 0.

            FOR EACH devol-cli USE-INDEX ch-nfs
                WHERE devol-cli.cod-estabel = tt-notas.cod-estabel
                  AND devol-cli.serie       = tt-notas.serie
                  AND devol-cli.nr-nota-fis = tt-notas.nr-nota-fis
                  AND devol-cli.it-codigo   = tt-notas.it-codigo NO-LOCK:
                ASSIGN de-qtd-devol = de-qtd-devol + devol-cli.qt-devolvida.
            END.

            ASSIGN tt-notas.qtd-devol = de-qtd-devol.

            IF de-qtd-devol = 0 THEN DO:

                FOR EACH volume-nf NO-LOCK
                    WHERE volume-nf.cod-estabel = tt-notas.cod-estabel
                    AND   volume-nf.serie       = tt-notas.serie
                    AND   volume-nf.nr-nota-fis = tt-notas.nr-nota-fis
                    AND   volume-nf.it-codigo   = tt-notas.it-codigo:
    
                    ASSIGN de-qtd-coletada = de-qtd-coletada + volume-nf.qtde-col.
    
                END.

                ASSIGN tt-notas.qtd-colet = de-qtd-coletada.

            END.

            /**/

            IF de-qtd-coletada >= tt-notas.quant THEN
                ASSIGN tt-notas.coletada = TRUE.

            FIND FIRST tt-inventario
                WHERE tt-inventario.it-codigo = tt-notas.it-codigo NO-ERROR.

            IF AVAILABLE tt-inventario THEN DO:

                IF tt-notas.cod-estabel = tt-param.cod-estabel-1 THEN DO:

                    ASSIGN tt-inventario.saldo-est-nfs-1 = tt-inventario.saldo-est-nfs-1 - de-qtd-devol.

                    IF tt-notas.coletada THEN
                        ASSIGN tt-inventario.saldo-est-nfs-1 = tt-inventario.saldo-est-nfs-1 - de-qtd-coletada.

                END.

                IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 AND
                   tt-notas.cod-estabel = tt-param.cod-estabel-2 THEN DO:
                
                    ASSIGN tt-inventario.saldo-est-nfs-2 = tt-inventario.saldo-est-nfs-2 - de-qtd-devol.

                    IF tt-notas.coletada THEN
                        ASSIGN tt-inventario.saldo-est-nfs-2 = tt-inventario.saldo-est-nfs-2 - de-qtd-coletada.

                END.

            END.
            
            IF tt-notas.quant <= de-qtd-devol THEN 
                DELETE tt-notas.
            
        END.
    END. /* IF tt-param.cons-saldo-nfs THEN DO: */

    RUN pi-trata-centrais.

    RUN pi-gerar-arq-csv IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        PUT STREAM str-rp UNFORMATTED
            "NÆo foram encontradas informa‡äes para os parƒmetros informados!":U SKIP.
    ELSE
        IF tt-param.gerar-detalhes-ae THEN
            RUN pi-gerar-arq-detalhes-ae IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gerar-arq-csv:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST tt-inventario) THEN
        RETURN "NOK":U.

    IF i-num-ped-exec-rpw <> 0 THEN
        OUTPUT STREAM str-csv TO VALUE(c-dir-spool-servid-exec + "/":U + tt-param.arquivo-csv) CONVERT TARGET "iso8859-1":U.
    ELSE
        OUTPUT STREAM str-csv TO VALUE(tt-param.arquivo-csv) CONVERT TARGET "iso8859-1":U.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Arquivo CSV...":U).

    IF CAN-FIND(FIRST tt-inventario) THEN DO:
        PUT STREAM str-csv UNFORMATTED
            "Item;Descri‡Æo;Valor Item Unit - Est.: ":U + TRIM(tt-param.cod-estabel-1) + ";Saldo Est.: ":U + TRIM(tt-param.cod-estabel-1) + " - Dep.: ":U TRIM(tt-param.cod-depos-1) + ";Saldo Est.: ":U + TRIM(tt-param.cod-estabel-2) + " - Dep.: ":U + TRIM(tt-param.cod-depos-2).

        IF tt-param.cons-saldo-nfs THEN DO:

            PUT STREAM str-csv UNFORMATTED
                ";Saldo NFS Fat - NÆo Embarcada - Est.: ":U + TRIM(tt-param.cod-estabel-1).

            IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 THEN
                PUT STREAM str-csv UNFORMATTED
                    ";Saldo NFS Fat - NÆo Embarcada - Est.: ":U + TRIM(tt-param.cod-estabel-2).

        END.

        IF tt-param.cons-saldo-transf THEN DO:

            PUT STREAM str-csv UNFORMATTED
                ";Saldo Transf - Est.: ":U + TRIM(tt-param.cod-estabel-1).

            IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 THEN
                PUT STREAM str-csv UNFORMATTED
                    ";Saldo Transf - Est.: ":U + TRIM(tt-param.cod-estabel-2).

        END.

        IF tt-param.cons-saldo-ae THEN
            PUT STREAM str-csv UNFORMATTED
                ";Saldo AE - Est.: ":U + TRIM(tt-param.cod-estabel-1).

        IF tt-param.cons-saldo-cst THEN
            PUT STREAM str-csv UNFORMATTED
                ";Saldo Est.: ":U + TRIM(tt-param.cod-estabel-1) + " - Localiz.: CST":U.

        PUT STREAM str-csv UNFORMATTED SKIP.

        FOR EACH tt-inventario:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + tt-inventario.it-codigo + " - ":U + tt-inventario.desc-item).

            PUT STREAM str-csv UNFORMATTED
                TRIM(tt-inventario.it-codigo)                                    ";":U
                TRIM(tt-inventario.desc-item)                                    ";":U
                TRIM(STRING(tt-inventario.val-unit-item, ">>>>,>>>,>>9.9999":U)) ";":U
                TRIM(STRING(tt-inventario.saldo-est-dep-1, "->,>>>,>>9.99":U))   ";":U
                TRIM(STRING(tt-inventario.saldo-est-dep-2, "->,>>>,>>9.99":U)).

            IF tt-param.cons-saldo-nfs THEN DO:

                PUT STREAM str-csv UNFORMATTED
                    ";":U TRIM(STRING(tt-inventario.saldo-est-nfs-1, "->,>>>,>>9.99":U)).

                IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 THEN
                    PUT STREAM str-csv UNFORMATTED
                        ";":U TRIM(STRING(tt-inventario.saldo-est-nfs-2, "->,>>>,>>9.99":U)).

            END.

            IF tt-param.cons-saldo-transf THEN DO:

                PUT STREAM str-csv UNFORMATTED
                    ";":U TRIM(STRING(tt-inventario.saldo-est-transf-1, "->,>>>,>>9.99":U)).

                IF tt-param.cod-estabel-1 <> tt-param.cod-estabel-2 THEN
                    PUT STREAM str-csv UNFORMATTED
                        ";":U TRIM(STRING(tt-inventario.saldo-est-transf-2, "->,>>>,>>9.99":U)).

            END.

            IF tt-param.cons-saldo-ae THEN
                PUT STREAM str-csv UNFORMATTED
                    ";":U TRIM(STRING(tt-inventario.saldo-est-ae, "->,>>>,>>9.99":U)).

            IF tt-param.cons-saldo-cst THEN
                PUT STREAM str-csv UNFORMATTED
                    ";":U TRIM(STRING(tt-inventario.saldo-est-cst, "->,>>>,>>9.99":U)).

            PUT STREAM str-csv UNFORMATTED SKIP.

            IF  tt-param.cons-saldo-nfs AND tt-param.listar-nfs THEN DO:
                IF  CAN-FIND(FIRST tt-notas NO-LOCK
                             WHERE tt-notas.it-codigo = tt-inventario.it-codigo) THEN
                    PUT STREAM str-csv UNFORMATTED
                        "C¢d Estabel;S‚rie;Nota Fiscal;Natur Oper;Cod Cliente;Nome Cliente;Nome Transp;Quantidade;Qtd Colet;Coletada" SKIP.

                FOR EACH tt-notas NO-LOCK
                    WHERE tt-notas.it-codigo = tt-inventario.it-codigo:
                    PUT STREAM str-csv UNFORMATTED
                        tt-notas.cod-estabel  ";"
                        tt-notas.serie        ";"
                        tt-notas.nr-nota-fis  ";"
                        tt-notas.nat-operacao ";"
                        tt-notas.cod-cliente  ";"
                        tt-notas.nome-cliente ";"
                        tt-notas.nome-transp  ";"
                        tt-notas.quant        ";"
                        tt-notas.qtd-colet    ";"
                        tt-notas.coletada FORMAT "Sim/NÆo" SKIP.
                END.
            END.
        END.
    END.

    OUTPUT STREAM str-csv CLOSE.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gerar-arq-detalhes-ae:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT CAN-FIND(FIRST tt-detalhes-ae) THEN
        RETURN "NOK":U.

    IF i-num-ped-exec-rpw <> 0 THEN
        OUTPUT STREAM str-ae TO VALUE(c-dir-spool-servid-exec + "/":U + tt-param.arquivo-ae) CONVERT TARGET "iso8859-1":U.
    ELSE
        OUTPUT STREAM str-ae TO VALUE(tt-param.arquivo-ae) CONVERT TARGET "iso8859-1":U.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Arquivo Detalhes AE":U).

    PUT STREAM str-ae UNFORMATTED
        "Nr AE;Seq.;Item;Descri‡Æo;Data;Localiza‡Æo Est.: ":U + TRIM(tt-param.cod-estabel-1) + ";Quant Baixado;Quant Pendente":U SKIP.

    FOR EACH tt-detalhes-ae:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + tt-detalhes-ae.it-codigo + " - Localiz.: ":U + tt-detalhes-ae.localizacao).

        PUT STREAM str-ae UNFORMATTED
            STRING(tt-detalhes-ae.nr-ae, "9999999":U)            ";":U
            STRING(tt-detalhes-ae.sequencia, "999":U)            ";":U
            TRIM(tt-detalhes-ae.it-codigo)                       ";":U
            TRIM(tt-detalhes-ae.desc-item)                       ";":U
            STRING(tt-detalhes-ae.data, "99/99/9999":U)          ";":U
            TRIM(tt-detalhes-ae.localizacao)                     ";":U
            TRIM(STRING(tt-detalhes-ae.qtd-baixado, ">>>>9":U))  ";":U
            TRIM(STRING(tt-detalhes-ae.qtd-pendente, ">>>>9":U)) SKIP.
    END.

    OUTPUT STREAM str-ae CLOSE.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-impres-param:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-estabel-1 LIKE estabelec.nome NO-UNDO.
    DEFINE VARIABLE c-deposit-1 LIKE deposito.nome  NO-UNDO.
    DEFINE VARIABLE c-estabel-2 LIKE estabelec.nome NO-UNDO.
    DEFINE VARIABLE c-deposit-2 LIKE deposito.nome  NO-UNDO.

    IF tt-param.gerar-detalhes-ae THEN DO:
        FORM "SELE€ÇO":U   AT 10 SKIP(1)
            tt-param.cod-estabel-1   COLON 30 LABEL "Estabelecimento 1":U " - ":U c-estabel-1 NO-LABEL
            tt-param.cod-depos-1     COLON 30 LABEL "Dep¢sito 1":U        " - ":U c-deposit-1 NO-LABEL
            SKIP(1)
            tt-param.cod-estabel-2   COLON 30 LABEL "Estabelecimento 2":U " - ":U c-estabel-2 NO-LABEL
            tt-param.cod-depos-2     COLON 30 LABEL "Dep¢sito 2":U        " - ":U c-deposit-2 NO-LABEL
            SKIP(1)
            tt-param.it-codigo-ini   COLON 30 "|< >|":U AT 49
            tt-param.it-codigo-fin   NO-LABEL
            tt-param.cod-localiz-ini COLON 30 "|< >|":U AT 49
            tt-param.cod-localiz-fin NO-LABEL
            SKIP(2)
            "PAR¶METRO":U AT 10 SKIP(1)
            tt-param.cons-saldo-nfs    COLON 43 LABEL "Considera Saldo NFS?":U
            tt-param.dt-corte-nfs      COLON 62 LABEL "Considerar NFS apartir de":U
            tt-param.listar-nfs        COLON 62 LABEL "Listar Notas Fiscais":U
            tt-param.cons-saldo-transf COLON 43 LABEL "Considera Saldo Transferˆncia?":U
            tt-param.cons-saldo-ae     COLON 43 LABEL "Considera Saldo AE?":U
            tt-param.gerar-detalhes-ae COLON 62 LABEL "Gerar Detalhes do AE?":U
            tt-param.cons-saldo-cst    COLON 43 LABEL "Considera Saldo CST?":U
            SKIP(2)
            "IMPRESSÇO":U AT 10 SKIP(1)
            c-destino                COLON 34 LABEL "Destino":U " - ":U tt-param.arquivo NO-LABEL
            tt-param.arquivo-csv     COLON 34 LABEL "Relat¢rio CSV":U
            tt-param.arquivo-ae      COLON 34 LABEL "Relat¢rio Detalhes AE":U
            tt-param.usuario         COLON 34 LABEL "Usu rio":U
            WITH WIDTH 132 SIDE-LABELS FRAME f-param-ae STREAM-IO.
    END.
    ELSE DO:
        FORM "SELE€ÇO":U   AT 10 SKIP(1)
            tt-param.cod-estabel-1   COLON 30 LABEL "Estabelecimento 1":U " - ":U c-estabel-1 NO-LABEL
            tt-param.cod-depos-1     COLON 30 LABEL "Dep¢sito 1":U        " - ":U c-deposit-1 NO-LABEL
            SKIP(1)
            tt-param.cod-estabel-2   COLON 30 LABEL "Estabelecimento 2":U " - ":U c-estabel-2 NO-LABEL
            tt-param.cod-depos-2     COLON 30 LABEL "Dep¢sito 2":U        " - ":U c-deposit-2 NO-LABEL
            SKIP(1)
            tt-param.it-codigo-ini   COLON 30 "|< >|":U AT 49
            tt-param.it-codigo-fin   NO-LABEL
            tt-param.cod-localiz-ini COLON 30 "|< >|":U AT 49
            tt-param.cod-localiz-fin NO-LABEL
            SKIP(2)
            "PAR¶METRO":U AT 10 SKIP(1)
            tt-param.cons-saldo-nfs    COLON 43 LABEL "Considera Saldo NFS?":U
            tt-param.dt-corte-nfs      COLON 62 LABEL "Considerar NFS apartir de":U
            tt-param.listar-nfs        COLON 62 LABEL "Listar Notas Fiscais":U
            tt-param.cons-saldo-transf COLON 43 LABEL "Considera Saldo Transferˆncia?":U
            tt-param.cons-saldo-ae     COLON 43 LABEL "Considera Saldo AE?":U
            tt-param.gerar-detalhes-ae COLON 62 LABEL "Gerar Detalhes do AE?":U
            tt-param.cons-saldo-cst    COLON 43 LABEL "Considera Saldo CST?":U
            SKIP(2)
            "IMPRESSÇO":U AT 10 SKIP(1)
            c-destino                COLON 26 LABEL "Destino":U " - ":U tt-param.arquivo NO-LABEL
            tt-param.arquivo-csv     COLON 26 LABEL "Relat¢rio CSV":U
            tt-param.usuario         COLON 26 LABEL "Usu rio":U
            WITH WIDTH 132 SIDE-LABELS FRAME f-param STREAM-IO.
    END.

    FIND FIRST estabelec
        WHERE  estabelec.cod-estabel = tt-param.cod-estabel-1 NO-LOCK NO-ERROR.

    FIND FIRST deposito
        WHERE  deposito.cod-depos = tt-param.cod-depos-1 NO-LOCK NO-ERROR.

    ASSIGN c-estabel-1 = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U
           c-deposit-1 = IF AVAILABLE deposito  THEN deposito.nome  ELSE "":U.

    FIND FIRST estabelec
        WHERE  estabelec.cod-estabel = tt-param.cod-estabel-2 NO-LOCK NO-ERROR.

    FIND FIRST deposito
        WHERE  deposito.cod-depos = tt-param.cod-depos-2 NO-LOCK NO-ERROR.

    ASSIGN c-estabel-2 = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U
           c-deposit-2 = IF AVAILABLE deposito  THEN deposito.nome  ELSE "":U.

    ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

    IF i-num-ped-exec-rpw = 0 THEN DO:
        ASSIGN tt-param.arquivo     = REPLACE(tt-param.arquivo, "/":U, "~\":U)
               tt-param.arquivo-csv = REPLACE(tt-param.arquivo-csv, "/":U, "~\":U).

        IF tt-param.gerar-detalhes-ae THEN
            ASSIGN tt-param.arquivo-ae = REPLACE(tt-param.arquivo-ae, "/":U, "~\":U).
    END.

    PAGE STREAM str-rp.

    IF tt-param.gerar-detalhes-ae THEN DO:
        DISPLAY STREAM str-rp
            tt-param.cod-estabel-1
            c-estabel-1
            tt-param.cod-depos-1
            c-deposit-1
            tt-param.cod-estabel-2
            c-estabel-2
            tt-param.cod-depos-2
            c-deposit-2
            tt-param.it-codigo-ini
            tt-param.it-codigo-fin
            tt-param.cod-localiz-ini
            tt-param.cod-localiz-fin
            tt-param.cons-saldo-nfs
            tt-param.dt-corte-nfs
            tt-param.listar-nfs
            tt-param.cons-saldo-transf
            tt-param.cons-saldo-ae
            tt-param.gerar-detalhes-ae
            tt-param.cons-saldo-cst
            c-destino
            tt-param.arquivo
            tt-param.arquivo-csv
            tt-param.arquivo-ae
            tt-param.usuario
            WITH FRAME f-param-ae.
    END.
    ELSE DO:
        DISPLAY STREAM str-rp
            tt-param.cod-estabel-1
            c-estabel-1
            tt-param.cod-depos-1
            c-deposit-1
            tt-param.cod-estabel-2
            c-estabel-2
            tt-param.cod-depos-2
            c-deposit-2
            tt-param.it-codigo-ini
            tt-param.it-codigo-fin
            tt-param.cod-localiz-ini
            tt-param.cod-localiz-fin
            tt-param.cons-saldo-nfs
            tt-param.dt-corte-nfs
            tt-param.listar-nfs
            tt-param.cons-saldo-transf
            tt-param.cons-saldo-ae
            tt-param.gerar-detalhes-ae
            tt-param.cons-saldo-cst
            c-destino
            tt-param.arquivo
            tt-param.arquivo-csv
            tt-param.usuario
            WITH FRAME f-param.
    END.

    RETURN "OK":U.

END PROCEDURE.



PROCEDURE pi-trata-centrais:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-tt-inv FOR tt-inventario.
    DEFINE BUFFER b-tt-notas FOR tt-notas.


    FOR EACH tt-inventario
        WHERE tt-inventario.nr-linha = 20
        AND   tt-inventario.log-pai:

        FOR EACH estrutura
            WHERE estrutura.it-codigo = tt-inventario.it-codigo
            AND   estrutura.data-inicio <= TODAY
            AND   estrutura.data-termino >= TODAY:

            FOR FIRST b-tt-inv
                WHERE b-tt-inv.it-codigo = estrutura.es-codigo:
            END.

            IF NOT AVAIL b-tt-inv THEN DO:

                FOR FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = estrutura.es-codigo:
                END.

                CREATE b-tt-inv.
                ASSIGN b-tt-inv.it-codigo          = ITEM.it-codigo
                       b-tt-inv.desc-item          = ITEM.desc-item
                       b-tt-inv.nr-linha           = item-uni-estab.nr-linha
                       b-tt-inv.saldo-est-dep-1    = 0 
                       b-tt-inv.saldo-est-dep-2    = 0
                       b-tt-inv.saldo-est-nfs-1    = 0
                       b-tt-inv.saldo-est-nfs-2    = 0
                       b-tt-inv.saldo-est-transf-1 = 0
                       b-tt-inv.saldo-est-transf-2 = 0
                       b-tt-inv.saldo-est-ae       = 0
                       b-tt-inv.saldo-est-cst      = 0
                       b-tt-inv.log-pai            = FALSE.

                FIND FIRST item-estab
                    WHERE  item-estab.it-codigo = b-tt-inv.it-codigo
                    AND  item-estab.cod-estabel = tt-param.cod-estabel-1 NO-LOCK NO-ERROR.

                ASSIGN b-tt-inv.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.

                FIND FIRST item-estab
                    WHERE  item-estab.it-codigo = b-tt-inv.it-codigo
                    AND  item-estab.cod-estabel = tt-param.cod-estabel-2 NO-LOCK NO-ERROR.

                ASSIGN b-tt-inv.val-unit-item = IF AVAILABLE item-estab THEN item-estab.val-unit-mat-m[1] ELSE 0.

            END.

            ASSIGN b-tt-inv.saldo-est-dep-1    = b-tt-inv.saldo-est-dep-1    + (tt-inventario.saldo-est-dep-1    * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-dep-2    = b-tt-inv.saldo-est-dep-2    + (tt-inventario.saldo-est-dep-2    * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-nfs-1    = b-tt-inv.saldo-est-nfs-1    + (tt-inventario.saldo-est-nfs-1    * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-nfs-2    = b-tt-inv.saldo-est-nfs-2    + (tt-inventario.saldo-est-nfs-2    * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-transf-1 = b-tt-inv.saldo-est-transf-1 + (tt-inventario.saldo-est-transf-1 * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-transf-2 = b-tt-inv.saldo-est-transf-2 + (tt-inventario.saldo-est-transf-2 * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-ae       = b-tt-inv.saldo-est-ae       + (tt-inventario.saldo-est-ae       * (estrutura.qtd-compon / estrutura.qtd-item))
                   b-tt-inv.saldo-est-cst      = b-tt-inv.saldo-est-cst      + (tt-inventario.saldo-est-cst      * (estrutura.qtd-compon / estrutura.qtd-item)).

            FOR EACH tt-notas
                WHERE tt-notas.it-codigo = tt-inventario.it-codigo:

                CREATE b-tt-notas.
                BUFFER-COPY tt-notas EXCEPT it-codigo TO b-tt-notas.
                ASSIGN b-tt-notas.it-codigo = b-tt-inv.it-codigo
                       b-tt-notas.quant     = tt-notas.quant     * (estrutura.qtd-compon / estrutura.qtd-item)
                       b-tt-notas.qtd-colet = tt-notas.qtd-colet * (estrutura.qtd-compon / estrutura.qtd-item).

            END.

        END. /* FOR EACH estrutura */

        FOR EACH tt-notas
            WHERE tt-notas.it-codigo = tt-inventario.it-codigo:

            DELETE tt-notas.

        END.

        DELETE tt-inventario.

    END.  /* FOR EACH tt-inventario */

    /**/






    RETURN "OK":u.


END PROCEDURE.
