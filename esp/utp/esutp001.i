
DEFINE TEMP-TABLE tt-tarifador /* LIKE tarifador */ NO-UNDO
  FIELD avaliado    AS LOGICAL   FORMAT "Sim/NÆo" INITIAL TRUE LABEL "Avaliado" COLUMN-LABEL "Avaliado"
  FIELD cobrado     AS LOGICAL   FORMAT "Sim/NÆo" INITIAL TRUE LABEL "Cobrado" COLUMN-LABEL "Cobrado"
  FIELD cod_usuario AS CHAR      FORMAT "X(12)" LABEL "C¢digo" COLUMN-LABEL "C¢digo"
  FIELD data        AS DATE      FORMAT "99/99/9999" LABEL "Data" COLUMN-LABEL "Data"
  FIELD duracao     AS CHARACTER LABEL "Dura‡Æo" COLUMN-LABEL "Dura‡Æo"
  FIELD finalidade  AS LOGICAL   FORMAT "Particular/Servi‡o" INITIAL TRUE LABEL "Finalidade" COLUMN-LABEL "Finalidade"
  FIELD hora        AS CHARACTER LABEL "Hora" COLUMN-LABEL "Hora"
  FIELD localidade  AS CHARACTER FORMAT "x(40)" LABEL "Localidade" COLUMN-LABEL "Localidade"
  FIELD numero      AS CHARACTER FORMAT "x(40)" LABEL "N£mero" COLUMN-LABEL "N£mero"
  FIELD ramal       AS CHARACTER FORMAT "x(20)" LABEL "Ramal" COLUMN-LABEL "R"
  FIELD tipo        AS CHARACTER FORMAT "x(3)" LABEL "Tipo" COLUMN-LABEL "Tipo"
  FIELD uf          AS CHARACTER FORMAT "x(2)" LABEL "UF" COLUMN-LABEL "UF"
  FIELD valor       AS DECIMAL   DECIMALS 2 FORMAT ">>>,>>9.99" LABEL "Valor" COLUMN-LABEL "Valor"
  FIELD periodo-cobranca AS CHARACTER  FORMAT "x(06)" COLUMN-LABEL "Pago"
  FIELD matr_mestre      AS CHAR FORMAT "X(12)"     LABEL "Matr. Mestre" COLUMN-LABEL "Matr. Mestre"
  FIELD dt-avaliac       AS DATE    FORMAT "99/99/9999" LABEL "Dt. Avalia‡Æo" COLUMN-LABEL "Dt. Avaliac"
  FIELD r-rowid     AS ROWID
  INDEX ramal AS PRIMARY ramal data cod_usuario.


DEFINE TEMP-TABLE tt-agenda-tarifador NO-UNDO LIKE agenda-tarifador
    FIELD r-rowid     AS ROWID.
