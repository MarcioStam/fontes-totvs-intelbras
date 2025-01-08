/*

Programa descontinuado em 27/04/2016 e substituido pelos programas:
esp/gko/gk0007.w
esp/gko/gk0007rp.p
 
 
*/


/*
DEF TEMP-TABLE tt-importa-movto-gko NO-UNDO
    FIELD cgc-intelbras     LIKE emitente.cgc
    FIELD cgc-transp        LIKE emitente.cgc
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD cod-estabel       LIKE estabelec.cod-estabel
    FIELD cod-nota            AS CHAR
    FIELD cod-serie           AS CHAR
    FIELD cod-ctrc            AS CHAR
    FIELD cod-fatura          AS CHAR
    FIELD cod-conta           AS CHAR
    FIELD cod-ccusto          AS CHAR
    FIELD des-conta           AS CHAR
    FIELD des-movto           AS CHAR
    FIELD val-credito         AS DEC
    FIELD val-debito          AS DEC
    FIELD dat-movto           AS DATE.

DEFINE /*SHARED*/ TEMP-TABLE tt-movimentos-SPED-ems2 NO-UNDO
    FIELD ep-codigo                       LIKE empresa.ep-codigo
    FIELD cod-estabel                     AS CHAR FORMAT "x(3)"                  LABEL "Estab"
    FIELD ano-periodo                     AS CHAR                               
    FIELD conta-contabil                  AS CHAR FORMAT "x(17)"                 LABEL "Conta Cont bil"
    FIELD ct-codigo                       AS CHAR FORMAT "x(8)"                  LABEL "Conta"
    FIELD sc-codigo                       AS CHAR FORMAT "x(8)"                  LABEL "Subconta"
    Field cod-unid-negoc                  AS CHAR FORMAT "x(3)"                  LABEL "Unid Neg¢cio" 
    FIELD data                            AS DATE FORMAT "99/99/9999"            LABEL "Data Transa‡Æo"
    FIELD valor                           AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Vl Cr‚dito"
    FIELD transacao                       AS INT
    FIELD historico                       AS CHAR FORMAT "x(150)"                LABEL "Hist¢rico" COLUMN-LABEL "Hist¢rico"
    FIELD num-arquivamento                AS CHAR FORMAT "x(16)"                 LABEL "Documento"
    FIELD cod-emitente                    AS INT  FORMAT "999999999"
    FIELD contra-partida                  AS CHAR FORMAT "x(17)"                 LABEL "Conta Cont bil"
    FIELD cod-lancto-contab               AS CHAR FORMAT "x(50)"                  
    FIELD num-bacen                       AS CHAR FORMAT "x(05)"                 LABEL "BACEN"
    FIELD COD-MODUL                       AS CHAR FORMAT "X(03)"
    INDEX tt-conta
          conta-contabil                  ASCENDING
    INDEX tt-2
          ep-codigo                       ASCENDING
          cod-estabel                     ASCENDING
          conta-contabil                  ASCENDING
    INDEX tt_id                           IS PRIMARY
          ep-codigo                       ASCENDING
          cod-estabel                     ASCENDING
          COD-MODUL                       ASCENDING
          cod-lancto-contab               ASCENDING.

DEFINE VARIABLE v-cod-linha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-arq-origem AS CHARACTER   NO-UNDO.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-movimentos-SPED-ems2.

{utp/ut-glob.i}

/*************************************************************************************************************/



/* Identificar arquivo origem do GKO para SPED */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0007"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOWIN32"
            THEN
                ASSIGN v-cod-arq-origem = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOUNIX"
            THEN
                ASSIGN v-cod-arq-origem = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.

EMPTY TEMP-TABLE tt-importa-movto-gko.

INPUT FROM VALUE(v-cod-arq-origem) CONVERT SOURCE "iso8859-1".

REPEAT:
    IMPORT UNFORMATTED v-cod-linha.
    ASSIGN v-cod-linha = REPLACE(v-cod-linha,'"',"").

    CREATE tt-importa-movto-gko.
    ASSIGN tt-importa-movto-gko.cgc-intelbras = ENTRY(1,v-cod-linha,";")
           tt-importa-movto-gko.cgc-transp    = ENTRY(2,v-cod-linha,";")
           tt-importa-movto-gko.cod-nota      = ENTRY(3,v-cod-linha,";")
           tt-importa-movto-gko.cod-serie     = ENTRY(4,v-cod-linha,";")
           tt-importa-movto-gko.cod-ctrc      = ENTRY(5,v-cod-linha,";")
           tt-importa-movto-gko.cod-fatura    = ENTRY(6,v-cod-linha,";")
           tt-importa-movto-gko.cod-conta     = ENTRY(7,v-cod-linha,";")
           tt-importa-movto-gko.cod-ccusto    = ENTRY(8,v-cod-linha,";")
           tt-importa-movto-gko.des-conta     = ENTRY(9,v-cod-linha,";")
           tt-importa-movto-gko.val-credito   = DEC(ENTRY(10,v-cod-linha,";"))
           tt-importa-movto-gko.val-debito    = DEC(ENTRY(11,v-cod-linha,";"))
           tt-importa-movto-gko.des-movto     = ENTRY(12,v-cod-linha,";")
           tt-importa-movto-gko.dat-movto     = DATE(ENTRY(13,v-cod-linha,";")).

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cgc = tt-importa-movto-gko.cgc-intelbras NO-ERROR.

    IF  AVAIL estabelec
    THEN
        ASSIGN tt-importa-movto-gko.cod-estabel = estabelec.cod-estabel.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cgc = tt-importa-movto-gko.cgc-transp NO-ERROR.

    IF  AVAIL emitente
    THEN
         tt-importa-movto-gko.cod-emitente = emitente.cod-emitente.
END.

INPUT CLOSE.
    
FOR EACH tt-importa-movto-gko:

    CREATE tt-movimentos-SPED-ems2.
    ASSIGN tt-movimentos-SPED-ems2.ep-codigo         = i-ep-codigo-usuario
           tt-movimentos-SPED-ems2.cod-estabel       = tt-importa-movto-gko.cod-estabel
           tt-movimentos-SPED-ems2.ano-periodo       = STRING(STRING(YEAR(tt-importa-movto-gko.dat-movto), "9999") + "/" + STRING(MONTH(tt-importa-movto-gko.dat-movto), "99"))
           tt-movimentos-SPED-ems2.cod-emitente      = tt-importa-movto-gko.cod-emitente
           tt-movimentos-SPED-ems2.ct-codigo         = tt-importa-movto-gko.cod-conta
           tt-movimentos-SPED-ems2.sc-codigo         = tt-importa-movto-gko.cod-ccusto
           tt-movimentos-SPED-ems2.conta-contabil    = tt-importa-movto-gko.cod-conta + tt-importa-movto-gko.cod-ccusto
           tt-movimentos-SPED-ems2.data              = tt-importa-movto-gko.dat-movto
           tt-movimentos-SPED-ems2.valor             = IF tt-importa-movto-gko.val-credito <> 0 THEN tt-importa-movto-gko.val-credito ELSE tt-importa-movto-gko.val-debito
           tt-movimentos-SPED-ems2.transacao         = IF tt-importa-movto-gko.val-credito <> 0 THEN 2 ELSE 1
           tt-movimentos-SPED-ems2.num-arquivamento  = ""
           tt-movimentos-SPED-ems2.contra-partida    = ""
           tt-movimentos-SPED-ems2.cod-modul         = "TRP"
           tt-movimentos-SPED-ems2.cod-lancto-contab = STRING(ROWID(tt-importa-movto-gko))
           tt-movimentos-SPED-ems2.cod-unid-negoc    = ""
           tt-movimentos-SPED-ems2.historico         = tt-importa-movto-gko.des-movto + " # "
                                                     + " Nota/Ser: " + tt-importa-movto-gko.cod-nota + "/" + tt-importa-movto-gko.cod-serie + " # "
                                                     + " CTRC: "     + tt-importa-movto-gko.cod-ctrc + " # "
                                                     + " Fatura: "   + tt-importa-movto-gko.cod-fatura. 
END.


*/
