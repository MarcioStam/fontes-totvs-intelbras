
DEFINE TEMP-TABLE tt-browse-tela NO-UNDO
    FIELD it-codigo             LIKE ITEM.it-codigo
    FIELD cod-refer             AS CHARACTER FORMAT "x(8)" LABEL "Refer"
    FIELD lote                  LIKE bc-etiqueta.lote
    FIELD qtd-item              AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U LABEL "Qtd Item"
    FIELD qtd-item-embalagem    AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U LABEL "Qtd Item Embal"
    FIELD qtd-etiqueta          AS INTEGER LABEL "Qtd Etiq"
    FIELD qtd-ult-embalagem     AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U LABEL "Qtd Item Ult Embal"
    FIELD qtd-peso-item         AS DECIMAL FORMAT ">,>>>,>>9.9999":U LABEL "Peso Item"
    FIELD layout-etiqueta       LIKE bc-etiqueta.cod-layout
    FIELD cod-ean               AS   CHAR LABEL "Cod EAN" FORMAT "X(20)"
    FIELD cod-dun               AS   CHAR LABEL "Cod DUN" FORMAT "X(20)"
    FIELD cod-depos             LIKE deposito.cod-depos
    FIELD cod-local             LIKE mgcad.localizacao.cod-localiz FORMAT "X(20)"
    FIELD id-docto              LIKE wm-docto.id-docto
    FIELD nr-ord-produ          LIKE ord-prod.nr-ord-produ
    FIELD cod-cliente           AS INTEGER  LABEL "Cod Cli"
    FIELD nome-abrev            AS CHARACTER FORMAT "x(12)" LABEL "Nome Abrev"
    FIELD cod-emb-pai           AS CHAR FORMAT "x(10)" LABEL "Emb Pai"
    FIELD cod-embalagem         AS CHARACTER FORMAT "X(10)" LABEL "Embalagem"
    FIELD cod-usuario           AS CHARACTER FORMAT "x(12)" LABEL "Usu rio"
    FIELD cod-estabel           AS CHARACTER FORMAT "X(3)"  LABEL "Estab"
    FIELD num-seq               AS INTEGER FORMAT "9999" LABEL "Seq"
    FIELD tipo-etiqueta         AS   INTEGER LABEL "Tipo Etiq"  
    FIELD desc-tipo-etiqueta    AS   CHAR FORMAT "x(16)" LABEL "Tipo Etiq"  
    FIELD dt-validade-lote      AS DATE FORMAT "99/99/9999" LABEL "Dt Valid" 
    FIELD logPai                AS LOG
    FIELD ControlaEtiqueta      AS LOG
    FIELD marca                 AS LOG INITIAL NO
    FIELD id-movto              AS DECIMAL FORMAT ">>>>>>>>>9".


DEFINE TEMP-TABLE ttSerial NO-UNDO
       FIELD de-serial AS DECIMAL.
