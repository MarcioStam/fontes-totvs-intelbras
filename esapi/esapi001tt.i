DEFINE TEMP-TABLE ttRepApi
    FIELD nr-ord-produ    LIKE ord-prod.nr-ord-produ
    FIELD op-codigo       AS   INTEGER 
    FIELD qt-reporte      AS   INTEGER
    FIELD depos-ent       AS   CHAR
    FIELD depos-sai       AS   CHAR
    FIELD c-enche         AS   CHAR
    FIELD linha           AS   CHAR
    FIELD c-localizacao   AS   CHAR
    FIELD cEtiqueta       AS   CHAR
    FIELD c-nome-imp      AS   CHAR                              
    FIELD cNomeLayout     AS   CHAR 
    FIELD nao-imprimir    AS   LOGICAL
    FIELD procura-saldo   AS   LOGICAL
    FIELD da-data-reporte AS   DATE
    FIELD l-ver-sel       AS   LOGICAL.
