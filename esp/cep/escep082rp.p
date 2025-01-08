{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/cep/escep082rp.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          as integer
    FIELD arquivo          as char format "x(35)"
    FIELD usuario          as char format "x(12)"
    FIELD data-exec        as date
    FIELD hora-exec        as integer
    FIELD classifica       as integer
    FIELD desc-classifica  as char format "x(40)"
    FIELD modelo-rtf       as char format "x(35)"
    FIELD l-habilitaRtf    as LOG
    FIELD r-raw            AS RAW.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita LIKE int-param-calc-crit
    FIELD l-selected AS LOGICAL   FORMAT "*/"
    FIELD ordem      AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo    AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END.


/*Leitura dos estabelecimento/planos marcados na tela*/
FOR EACH tt-digita
    WHERE tt-digita.l-selected:

    FIND FIRST int-param-calc-crit NO-LOCK
         WHERE int-param-calc-crit.cod-estabel  = tt-digita.cod-estabel
           AND int-param-calc-crit.cd-plano     = tt-digita.cd-plano
           AND int-param-calc-crit.item-inicial = tt-digita.item-inicial NO-ERROR.

    FOR EACH ITEM 
       WHERE item.it-codigo >= int-param-calc-crit.item-inicial
         AND item.it-codigo <= int-param-calc-crit.item-final NO-LOCK:
        
        FIND FIRST pl-prod NO-LOCK
             WHERE pl-prod.cd-plano = tt-digita.cd-plano NO-ERROR.
        
        /*Executa somente planos ativos*/
        IF NOT AVAIL pl-prod 
        OR pl-prod.pl-estado <> 1 THEN DO:
            NEXT.
        END.

        RUN esp/cep/escep082a.p (INPUT ROWID(ITEM),
                                 INPUT tt-digita.cod-estabel,
                                 INPUT tt-digita.cd-plano,
                                 INPUT tt-digita.item-inicial).   
                                 
    END. 
END.


