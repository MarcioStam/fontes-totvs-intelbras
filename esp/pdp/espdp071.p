/*******************************************************************************/
/* Programa espdp071 - Retornar o pre‡o m¡nimo de tabela + impostos            */
/* Data 05/11/2012                                                             */
/* Autor: Roger Marcelino Bruhn                                                */
/*******************************************************************************/

DEF INPUT PARAMETER p-estabel      AS CHAR NO-UNDO.    
DEF INPUT PARAMETER p-nome-abrev   AS CHAR NO-UNDO.
DEF INPUT PARAMETER p-nr-pedcli    AS CHAR NO-UNDO.
DEF INPUT PARAMETER p-nr-sequencia AS INTEGER NO-UNDO.
DEF INPUT PARAMETER p-it-codigo    AS CHAR NO-UNDO.
DEF INPUT PARAMETER p-qt-pedida    LIKE ped-item.qt-pedida NO-UNDO.
DEF INPUT PARAMETER p-nat-operacao AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER p-preco       AS DECIMAL DECIMALS 5 NO-UNDO.

DEFINE VARIABLE de-perc-icms     AS DECIMAL NO-UNDO.
DEFINE VARIABLE l-return         AS LOGICAL NO-UNDO.
DEFINE VARIABLE de-descto-zf     AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-per-des-icms  AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER NO-UNDO.
DEFINE VARIABLE i-round          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-arred          AS INTEGER     NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.

DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.
    
DEF VAR h-bodi317im1br AS HANDLE NO-UNDO.

ASSIGN p-preco = 0.

/* IF  NOT (p-estabel = "101" OR  p-estabel = "104") THEN */
/*     RETURN "OK".                                       */

FOR FIRST para-fat FIELDS (dec-calc-int-p dec-calc-int-f arre-calc-int-p arre-calc-int-f) NO-LOCK: END.

ASSIGN i-round = para-fat.dec-calc-int-p
       i-arred = para-fat.arre-calc-int-p.

FOR FIRST ped-venda FIELDS (nome-abrev cod-entrega)
    WHERE ped-venda.nome-abrev = p-nome-abrev
      AND ped-venda.nr-pedcli  = p-nr-pedcli NO-LOCK:

END.
find last preco-item
    where preco-item.it-codigo  = p-it-codigo
      and preco-item.cod-refer  = ""
      and preco-item.nr-tabpre  = "MINIMO"
      and preco-item.situacao   = 1
      and preco-item.quant-min <= p-qt-pedida no-lock no-error.

IF  AVAIL preco-item  THEN DO:

    FOR FIRST estabelec FIELDS (estado pais) NO-LOCK
        WHERE estabelec.cod-estabe = p-estabel: END.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.nome-abrev = ped-venda.nome-abrev: END.

    FOR FIRST loc-entr FIELD(estado)
        WHERE loc-entr.cod-entrega = ped-venda.cod-entrega 
          AND loc-entr.nome-abrev  = ped-venda.nome-abrev no-lock: END.
    
    FIND ITEM
         WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.

   IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = p-it-codigo + chr(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            assign de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  p-it-codigo,
                                                  INPUT  p-nat-operacao,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).

    END.
    
    ASSIGN g-cod-emitente-bodi317im1br = 0.
    ASSIGN g-codigo-orig-bodi317sd     = 0.



    /* Se o destino ‚ SC, entÆo utilizar sempre al¡quota 12% */

/*     IF  loc-entr.estado = "SC"  THEN */
/*         ASSIGN de-perc-icms = 12.    */

    /************************** Achar o pre‡o COM ICMS *************************/
    IF  de-perc-icms <> 0 THEN
        ASSIGN p-preco = preco-item.preco-venda / ((100 - de-perc-icms) / 100).
    ELSE
        ASSIGN p-preco = preco-item.preco-venda.

    /************** Agora Achar o pre‡o aplicando o Desconto de ICMS **********/
    FIND natur-oper
         WHERE natur-oper.nat-operacao = p-nat-operacao NO-LOCK NO-ERROR.

    IF  AVAIL natur-oper THEN    
        ASSIGN de-descto-zf = DEC(SUBSTR(natur-oper.char-2,66,5)).

    FIND cidade-zf 
        WHERE cidade-zf.cidade = loc-entr.cidade 
          AND cidade-zf.estado = loc-entr.estado NO-LOCK NO-ERROR.

    IF  loc-entr.estado <> estabelec.estado 
    AND emitente.contrib-icms
    THEN DO:

        FOR FIRST unid-feder FIELDS(est-exc perc-exc desc-icms) 
            WHERE unid-feder.pais   = estabelec.pais 
              AND unid-feder.estado = estabelec.estado NO-LOCK:

            ASSIGN de-per-des-icms = 0.

            DO  i-cont = 1 TO 12:
                IF  unid-feder.est-exc[i-cont] = loc-entr.estado THEN DO:
                    ASSIGN de-per-des-icms = unid-feder.perc-exc[i-cont + 13].
                    LEAVE.
                END.
            END.


            ASSIGN de-per-des-icms = IF  de-per-des-icms <> 0 THEN
                                         de-per-des-icms
                                     ELSE 
                                         IF  unid-feder.desc-icms <> 0 THEN
                                             unid-feder.desc-icms ELSE
                                             natur-oper.per-des-icms.
        END.
    END.
    ELSE 
        ASSIGN de-per-des-icms = natur-oper.per-des-icms.

    ASSIGN p-preco = /* IF  i-arred = 1 
                          THEN TRUNCATE(p-preco * (1 - (de-per-des-icms / 100)), i-round)
                          ELSE */    ROUND(p-preco * (1 - (de-per-des-icms / 100)), 2).             
END.

IF  VALID-HANDLE(h-bodi317im1br) THEN
    RUN destroy IN h-bodi317im1br.

RETURN "OK".
