{include/i-prgvrs.i ESWMAPI006 2.00.00.000}  /*** 010000 ***/
{include/i_dbvers.i}  /* versao das bases e bases instaladas */
/********************************************************************************
**  Programa: ESWMAPI006
**  Data....: AGOSTO / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API calculo da ocupa‡Æo do endere‡o de flow rack.
********************************************************************************/
{utp/ut-glob.i}                
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pCodEstabel AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCodLocal   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pIdBox      AS DECIMAL     NO-UNDO.

FIND FIRST wm-box NO-LOCK
    WHERE wm-box.cod-estabel = pCodEstabel
      AND wm-box.cod-local   = pCodLocal
      AND wm-box.id-box      = pIdbox NO-ERROR.

IF NOT AVAIL wm-box THEN

DEF BUFFER bf-box-saldo FOR wm-box-saldo.

DEF VAR de-qtd-capacidade-ua    LIKE wm-box.qtd-capacidade-ua-util  NO-UNDO.
DEF VAR de-qtd-capacidade-peso  LIKE wm-box.qtd-capacidade-peso-util NO-UNDO.
DEFINE VARIABLE i-qtd-embal     AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-qtd-saldo    AS DECIMAL     NO-UNDO.

FOR EACH bf-box-saldo
    WHERE bf-box-saldo.cod-estabel = wm-box.cod-estabel 
      AND bf-box-saldo.cod-local   = wm-box.cod-local 
      AND bf-box-saldo.id-box      = wm-box.id-box NO-LOCK,
    FIRST wm-item NO-LOCK
      WHERE wm-item.cod-item = bf-box-saldo.cod-item:

    FOR FIRST wm-item-embalagem-local NO-LOCK
         WHERE wm-item-embalagem-local.cod-estabel   = bf-box-saldo.cod-estabel
           AND wm-item-embalagem-local.cod-local     = bf-box-saldo.cod-local
           AND wm-item-embalagem-local.cod-item      = bf-box-saldo.cod-item
           AND wm-item-embalagem-local.cod-embalagem = bf-box-saldo.cod-embalagem:
    END.

    /* simula quantidade de embalagens para poder definir ocupa‡Æo, devido ao agrupamento do saldo em uma unica embalagem */
    ASSIGN de-qtd-saldo = ( bf-box-saldo.qtd-item - bf-box-saldo.qtd-item-bloq + bf-box-saldo.qtd-pendente ).

    IF AVAIL wm-item-embalagem-local THEN DO:
        ASSIGN i-qtd-embal = TRUNC(de-qtd-saldo / wm-item-embalagem-local.qtd-item-emb,0).
        IF (de-qtd-saldo MODULO wm-item-embalagem-local.qtd-item-emb) > 0 THEN
            ASSIGN i-qtd-embal = i-qtd-embal + 1.

        ASSIGN de-qtd-capacidade-ua   = de-qtd-capacidade-ua + (i-qtd-embal * wm-item-embalagem-local.qtd-volume)
               de-qtd-capacidade-peso = de-qtd-capacidade-peso
                                      + (i-qtd-embal * wm-item-embalagem-local.qtd-peso)
                                      + (( bf-box-saldo.qtd-item - bf-box-saldo.qtd-item-bloq + bf-box-saldo.qtd-pendente ) * wm-item.qtd-peso ).
    END.
    ELSE DO:
        FOR FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = bf-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local     = bf-box-saldo.cod-local
               AND wm-item-embalagem-local.cod-item      = bf-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-emb-item  = bf-box-saldo.cod-embalagem:

            ASSIGN i-qtd-embal = TRUNC(de-qtd-saldo / wm-item-embalagem-local.qtd-emb-item,0).
            IF (de-qtd-saldo MODULO wm-item-embalagem-local.qtd-emb-item) > 0 THEN
                ASSIGN i-qtd-embal = i-qtd-embal + 1.

            ASSIGN de-qtd-capacidade-ua   = de-qtd-capacidade-ua + (i-qtd-embal * wm-item-embalagem-local.qtd-volume-item)
                   de-qtd-capacidade-peso = de-qtd-capacidade-peso
                                          + (i-qtd-embal * wm-item-embalagem-local.qtd-peso-item)
                                          + (( bf-box-saldo.qtd-item - bf-box-saldo.qtd-item-bloq + bf-box-saldo.qtd-pendente ) * wm-item.qtd-peso ).
        END.
    END.
END.

FIND CURRENT wm-box EXCLUSIVE-LOCK NO-ERROR.
ASSIGN wm-box.qtd-capacidade-ua-util = de-qtd-capacidade-ua
       wm-box.qtd-capacidade-peso-util = de-qtd-capacidade-peso.
FIND CURRENT wm-box NO-LOCK NO-ERROR.

RETURN "OK".
