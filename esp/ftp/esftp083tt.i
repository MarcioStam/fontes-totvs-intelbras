DEFINE TEMP-TABLE tt-resto
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD qtde      AS DEC
    INDEX tt-resto  AS PRIMARY UNIQUE it-codigo
    INDEX qtde      qtde
    .

DEFINE TEMP-TABLE tt-itens-calculo
    FIELD it-codigo  LIKE ITEM.it-codigo
    FIELD quantidade AS DEC
    FIELD saida-flow-rack AS LOGICAL
    .

DEFINE TEMP-TABLE tt-volumes
    FIELD it-codigo    LIKE volume-nf.it-codigo
    FIELD nr-volume    LIKE volume-nf.nr-volume
    FIELD qtde         LIKE volume-nf.qtde     
    FIELD sigla-emb    LIKE volume-nf.sigla-emb   
    FIELD varios-itens LIKE volume-nf.varios-itens
    FIELD peso         AS DEC
    INDEX nr-volume    nr-volume
    .

DEFINE TEMP-TABLE tt-volumes-lidos NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-excesso LIKE tt-volumes.
