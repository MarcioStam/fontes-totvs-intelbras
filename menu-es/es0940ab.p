/*--- Defini‡Æo das Tabelas Tempor rias ---*/
DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cod_estab                     AS CHAR FORMAT "x(03)"
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".



/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-dt-inicio AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-fim    AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-conta     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cc-codigo AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-dados.



/*--- Defini‡Æo Vari veis ---*/
DEFINE VARIABLE dt-data   AS DATE        NO-UNDO.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-dados.

DO  dt-data = p-dt-inicio TO p-dt-fim:
    FOR EACH  movto-estoq USE-INDEX data-saldo NO-LOCK
        WHERE movto-estoq.dt-trans  = dt-data
        AND   movto-estoq.ct-codigo = p-conta
        AND   movto-estoq.sc-codigo = p-cc-codigo:
        CREATE tt-dados.
        ASSIGN tt-dados.origem                = "CEP"
               tt-dados.cod_estab             = movto-estoq.cod-estabel
               tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"
               tt-dados.cod_emitente          = movto-estoq.cod-emitente
               tt-dados.dt_transacao          = movto-estoq.dt-trans
               tt-dados.cod_espec_docto       = STRING(movto-estoq.esp-docto)
               tt-dados.cod_ser_docto         = movto-estoq.serie
               tt-dados.cod_tit_ap            = STRING(movto-estoq.nro-docto)
               tt-dados.cod_parcela           = "0"
               tt-dados.val_aprop_ctbl        = movto-estoq.valor-mat-m[1] +
                                                movto-estoq.valor-mob-m[1] +
                                                movto-estoq.valor-ggf-m[1].

        IF  tt-dados.val_aprop_ctbl = 0 THEN DO:
            FIND FIRST item-estab NO-LOCK
                WHERE  item-estab.cod-estab = movto-estoq.cod-estabel
                AND    item-estab.it-codigo = movto-estoq.it-codigo NO-ERROR.
            IF  AVAIL  item-estab THEN
                ASSIGN tt-dados.val_aprop_ctbl = movto-estoq.quantidade * 
                                                ( item-estab.val-unit-mat-m[1]
                                                + item-estab.val-unit-mob-m[1]
                                                + item-estab.val-unit-ggf-m[1] ).
        END.

        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = movto-estoq.it-codigo NO-ERROR.
        
        IF  movto-estoq.cod-emitente <> 0 THEN DO:
            FIND FIRST emitente NO-LOCK
                WHERE  emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.
            IF  AVAIL  emitente THEN
                ASSIGN tt-dados.nome_emitente = emitente.nome-emit.
        END.
        ELSE
            ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

        FIND FIRST item-doc-est NO-LOCK
            WHERE  item-doc-est.serie-docto  = movto-estoq.serie-docto
            AND    item-doc-est.nro-docto    = movto-estoq.nro-docto
            AND    item-doc-est.cod-emitente = movto-estoq.cod-emitente
            AND    item-doc-est.nat-operacao = movto-estoq.nat-operacao
            AND    item-doc-est.sequencia    = movto-estoq.sequen-nf NO-ERROR.
        IF  AVAIL  item-doc-est THEN
            ASSIGN tt-dados.nome_emitente = tt-dados.nome_emitente + " - Narrativa: " + item-doc-est.narrativa.
    END.
END.

