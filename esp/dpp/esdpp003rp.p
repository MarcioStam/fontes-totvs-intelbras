/***********************************************************************
**  Programa..: ESP\CCP\ESDPP003RP.P
**  Autor.....: Anderson Silvano
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: Lista de Faltas - Individual
**  Vers’o....: 001 19/01/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESDPP003 2.04.00.001}

/****************************  Definitions  ****************************/

{esp/dpp/esdpp003.i}


DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)":U
    LABEL "Usu rio Corrente"
    COLUMN-LABEL "Usu rio Corrente"
    NO-UNDO.

DEFINE STREAM str-excel.

{include/i-rpvar.i}
{esp/es0006a.i}
{esp/es0006.i}
{esp/es0018.i}

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE c-desc-item        LIKE ITEM.desc-item.
DEFINE VARIABLE c-desc-item-dp     LIKE dp-item.desc-item.
DEFINE VARIABLE i-total            AS INT.
DEFINE VARIABLE i-nivel            AS INT FORMAT "99".
DEFINE VARIABLE c-es-codigo        AS CHAR FORMAT "X(07)".   
DEFINE VARIABLE c-local-montag     LIKE estrutura.local-montag FORMAT "x(30)":U.
DEFINE VARIABLE c-local-aux LIKE estrutura.local-montag.
DEFINE VARIABLE d-quant-usada      AS DECIMAL NO-UNDO.
DEFINE VARIABLE b-local-montag     AS CHAR.

DEFINE NEW GLOBAL SHARED VAR v_cod_estab_usuar
     AS CHARACTER
     FORMAT "x(3)":U
     LABEL "Estabelecimento"
     COLUMN-LABEL "Estab" NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-saldo-rec  AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-saldo-alm   AS INTEGER NO-UNDO.
DEFINE VARIABLE c-cod-localiz AS CHAR    NO-UNDO.

FOR FIRST param-global NO-LOCK.
END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri:
 END.

ASSIGN c-sistema      = "Especificos Intelbras"
       c-titulo-relat = "Lista de Materiais"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''.

DEFINE STREAM shtml.                                                                        

DEFINE TEMP-TABLE tt-saida
    FIELD seq            AS   INTEGER 
    FIELD nivel          AS   INTEGER    FORMAT "99"
    FIELD quant-usada    LIKE dp-estrut.quant-usada FORMAT ">>>>>9.999999":U
    FIELD es-codigo      LIKE dp-estrut.es-codigo
    FIELD desc-item      LIKE item.desc-item
    FIELD local-mont     AS   CHAR
    FIELD b-local-mont   AS   CHAR
    FIELD obsoleto       AS   CHAR
    FIELD fantasma       AS   LOG    FORMAT "Sim/NÆo"
    FIELD un             AS   CHAR
    FIELD data-inicio    AS   DATE   FORMAT "99/99/9999"
    FIELD data-termino   AS   DATE   FORMAT "99/99/9999"
    FIELD it-fabric      LIKE item-fabric.it-fabric.

DEFINE TEMP-TABLE tt-aes
    FIELD nr-ae         AS INT  FORMAT ">>>>>>9" LABEL "AE"
    FIELD sequencia     AS INT  FORMAT ">>9"     LABEL "Seq"
    FIELD quantidade    AS INT  FORMAT ">>>,>>9" LABEL "QTD"
    FIELD data          LIKE ae-item.data        LABEL "Data" 
    FIELD cod-depos     AS CHAR FORMAT "X(3)"    LABEL "Dep"
    FIELD localizacao   LIKE ae-item.localizacao LABEL "Local"
    FIELD roteiro       LIKE ae-item.roteiro.

DEFINE TEMP-TABLE tt-saldo
    FIELD cod-depos     LIKE saldo-estoq.cod-depos   LABEL "Dep"
    FIELD cod-localiz   LIKE saldo-estoq.cod-localiz LABEL "Local"      FORMAT "X(8)"
    FIELD quantidade    AS DEC                       LABEL "Quantidade" FORMAT "->>>>,>>9.99".    


DEFINE VARIABLE i-seq-saida AS INTEGER     NO-UNDO.

/* **************************** Frames ********************************* */

FORM HEADER
      "INTELBRAS - Lista de Materiais" AT 20
      TODAY FORMAT "99/99/99"  AT 80
      STRING(TIME,"HH:MM:SS")  AT 105
      "Pag.:"                  AT 123
      PAGE-NUMBER FORMAT ">>>" AT 129 SKIP
      tt-param.c-it-codigo     AT 11  FORMAT "x(13)"
      c-desc-item              AT 27 
      " - Versao: "
      tt-param.i-versao        skip
      FILL("_",129) AT 03 FORMAT "x(129)"
      "|Nivel|     Qtd       | Codigo  | Descricao                                                    | Local de Montagem                |" at 02
      "|_____|_______________|_________|______________________________________________________________|__________________________________|" at 02
      WITH PAGE-TOP STREAM-IO FRAME header-frame-dp NO-BOX WIDTH 135 ROW 1.

FORM HEADER
       "INTELBRAS - Lista de Materiais" at 20
       TODAY format "99/99/99"  AT 80
       STRING(time,"HH:MM:SS")  AT 105
       "Pag.:"                  AT 123
       PAGE-NUMBER FORMAT ">>>" AT 129 SKIP
       tt-param.c-it-codigo     AT 11  FORMAT "x(13)"
       c-desc-item              AT 27  SKIP
       FILL("_",129) AT 03 FORMAT "x(129)"
       "|Nivel|     Qtd       | Codigo  | Descricao                                                    | Local de Montagem                |" at 02
       "|_____|_______________|_________|______________________________________________________________|__________________________________|" at 02
       WITH PAGE-TOP STREAM-IO FRAME header-frame-eng NO-BOX WIDTH 135 ROW 1.

FORM HEADER
      "INTELBRAS - Lista de Materiais" AT 20
      TODAY format "99/99/99"  AT 80
      STRING(time,"HH:MM:SS")  AT 105
      "Pag.:"                  AT 123
      PAGE-NUMBER format ">>>" AT 129 SKIP
      tt-param.c-it-codigo     AT 11  FORMAT "X(13)"
      c-desc-item              AT 27 
      " - Versao: "
      tt-param.i-versao        skip
      FILL("_",129) AT 03 FORMAT "x(129)"
      "|Nivel|     Qtd       | Codigo  | Descricao                                                    | Localiza‡Æo                      |" at 02
      "|_____|_______________|_________|______________________________________________________________|__________________________________|" at 02
      WITH PAGE-TOP STREAM-IO FRAME header-frame-dp-estoq NO-BOX WIDTH 135 ROW 1.

FORM HEADER
       "INTELBRAS - Lista de Materiais" AT 20
       TODAY format "99/99/99"  AT 80
       STRING(time,"HH:MM:SS")  AT 105
       "Pag.:"                  AT 123
       PAGE-NUMBER format ">>>" AT 129 SKIP
       tt-param.c-it-codigo     AT 11  FORMAT "x(13)"
       c-desc-item              AT 27  SKIP
       FILL("_",129) AT 03 FORMAT "x(129)"
       "|Nivel|     Qtd       | Codigo  | Descricao                                                    | Localiza‡Æo                      |" at 02
       "|_____|_______________|_________|______________________________________________________________|__________________________________|" at 02
       WITH PAGE-TOP STREAM-IO FRAME header-frame-eng-estoq NO-BOX WIDTH 135 ROW 1.



FORM HEADER
    SPACE(04)
    "Componentes:  " AT 02 i-total
        WITH PAGE-BOTTOM STREAM-IO FRAME footer-frame WIDTH 135.
 
 FORM
      "|" AT  02 tt-saida.nivel
      "|" at  08 tt-saida.quant-usada  AT 10 
      "|" at  24 c-es-codigo           AT 26 FORMAT "x(08)"
      "|" at  34 tt-saida.desc-item    AT 36 FORMAT "x(60)"
      "|" at  97 c-local-montag        AT 99
      "|" at 132 
      WITH NO-LABELS STREAM-IO NO-BOX FRAME lista WIDTH 135.



 FORM
      "|" AT  02
      "|" AT  08
      "|" AT  24
      "|" AT  34
      "|" AT  97 c-local-montag         at 99
      "|" AT 132 
      WITH NO-LABELS STREAM-IO NO-BOX FRAME lista-local-montag WIDTH 135.
 

FORM
    "|_____|_______________|_________|______________________________________________________________|__________________________________|" at 02
    WITH NO-LABELS STREAM-IO NO-BOX FRAME linha WIDTH 135.



/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    
    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    EMPTY TEMP-TABLE tt-saida.

    ASSIGN i-seq-saida = 0.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").


    IF tt-param.i-estrut = 1 THEN DO:   /* Desenvolvimento de Produto */

        FIND dp-item  
            WHERE dp-item.it-codigo = tt-param.c-it-codigo NO-LOCK NO-ERROR.

        ASSIGN c-desc-item = IF AVAIL dp-item THEN dp-item.desc-item ELSE "".
    
        FOR EACH  dp-estrut NO-LOCK
            WHERE dp-estrut.item-dp         = tt-param.c-it-codigo
              AND dp-estrut.num-proces-item = tt-param.i-versao
              AND dp-estrut.data-termino    > tt-param.dt-corte
              AND dp-estrut.data-inicio    <= tt-param.dt-corte:

            FIND ITEM NO-LOCK
                WHERE item.it-codigo = dp-estrut.es-codigo NO-ERROR.

            IF AVAIL ITEM 
                THEN ASSIGN c-desc-item-dp = ITEM.desc-item.
            ELSE DO:
                FIND dp-item NO-LOCK
                    WHERE dp-item.it-codigo = dp-estrut.es-codigo NO-ERROR.
                ASSIGN c-desc-item-dp = IF AVAIL dp-item THEN dp-item.desc-item ELSE "".
            END.
     
            ASSIGN i-nivel = 1.
            
            IF tt-param.l-lista-comp = YES THEN DO:
                ASSIGN b-local-montag = " ".
                
                IF  tt-param.i-estrut = 2 THEN DO:
                    FOR EACH int-local-montag
                        WHERE int-local-montag.it-codigo = dp-estrut.item-dp
                        AND   int-local-montag.sequencia = dp-estrut.sequencia
                        AND   int-local-montag.es-codigo = dp-estrut.es-codigo NO-LOCK:
    
                        ASSIGN b-local-montag = b-local-montag + int-local-montag.local-montag  + ",". 
                    END.
                END.
                ELSE DO:

                    RUN pi-Local-Montagem (INPUT  dp-estrut.local-montag,
                                           OUTPUT b-local-montag).
                END.
            END.

            ASSIGN c-local-montag = dp-estrut.local-montag.
            
            FIND FIRST item-fabric NO-LOCK
                 WHERE item-fabric.cod-fabric = tt-param.fi-cod-fabric
                   AND item-fabric.it-codigo  = dp-estrut.es-codigo NO-ERROR.  
                
            IF dp-estrut.observacao <> "" THEN 
                ASSIGN c-local-montag = c-local-montag + " - " + dp-estrut.observacao. 

            ASSIGN i-seq-saida = i-seq-saida + 1.

            IF tt-param.tipo = 1 THEN  /* Producao */
                ASSIGN d-quant-usada = dp-estrut.quant-usada.
            ELSE  /* Estoque */
                ASSIGN d-quant-usada = dp-estrut.quant-usada * tt-param.quantidade.
            
            CREATE tt-saida.
            ASSIGN tt-saida.seq          = i-seq-saida
                   tt-saida.nivel        = i-nivel
                   tt-saida.quant-usada  = d-quant-usada
                   tt-saida.es-codigo    = dp-estrut.es-codigo
                   tt-saida.desc-item    = c-desc-item-dp
                   tt-saida.local-mont   = c-local-montag
                   tt-saida.b-local-mont = b-local-montag WHEN tt-param.l-lista-comp = YES AND tt-param.i-estrut <> 2
                   tt-saida.obsoleto     = IF AVAIL ITEM THEN CAPS({ininc/i17in172.i 04 ITEM.cod-obsoleto}) ELSE CAPS({ininc/i17in172.i 04 dp-item.cod-obsoleto})
                   tt-saida.fantasma     = dp-estrut.fantasma 
                   tt-saida.un           = IF AVAIL ITEM THEN ITEM.un ELSE dp-item.un
                   tt-saida.data-inicio  = dp-estrut.data-inicio
                   tt-saida.data-termino = dp-estrut.data-termino
                   tt-saida.it-fabric    = item-fabric.it-fabric WHEN AVAIL item-fabric.   

            RUN pi-busca-localizacao-estoque.

            ASSIGN i-total = i-total + dp-estrut.quant-usada.

            IF tt-param.i-completo = 2 OR
                (tt-param.i-completo = 3 AND
                 dp-estrut.fantasma = YES) THEN DO:
                IF dp-estrut.num-proces-compon <> 0 THEN
                    RUN piGeraEstrut (INPUT dp-estrut.es-codigo,
                                      INPUT d-quant-usada).
                ELSE
                    RUN piGeraEngEstrut (INPUT dp-estrut.es-codigo,
                                             INPUT d-quant-usada).
            END.
        END.
    END.
    ELSE DO:  /* Engenharia */

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-param.c-it-codigo NO-ERROR.
        
        ASSIGN c-desc-item = IF AVAIL ITEM THEN item.desc-item ELSE "".

        FOR EACH estrutura NO-LOCK
            WHERE estrutura.it-codigo    = tt-param.c-it-codigo         
              AND estrutura.data-inicio <= tt-param.dt-corte:

            IF NOT(tt-param.l-lista-vencidos) THEN
                IF estrutura.data-termino <= tt-param.dt-corte THEN NEXT.

            FIND ITEM NO-LOCK
                WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.

            ASSIGN i-nivel = 1.
            
            IF tt-param.l-lista-comp = YES THEN DO:
                
                ASSIGN b-local-montag = " ".

                FOR EACH int-local-montag NO-LOCK
                   WHERE int-local-montag.it-codigo = estrutura.it-codigo 
                     AND int-local-montag.sequencia = estrutura.sequencia
                     AND int-local-montag.es-codigo = estrutura.es-codigo:
                    
                    ASSIGN b-local-montag = b-local-montag + int-local-montag.local-montag  + ",". 
                
                END.
               
            END.
            
            ASSIGN c-local-montag = estrutura.local-montag.
            
            IF estrutura.observacao <> "" THEN
            ASSIGN c-local-montag = c-local-montag + " - " + estrutura.observacao.
            
            ASSIGN i-seq-saida = i-seq-saida + 1.

            FIND FIRST item-fabric NO-LOCK  /*Busca Codigo fabricante*/
                 WHERE item-fabric.cod-fabric = tt-param.fi-cod-fabric
                   AND item-fabric.it-codigo  = estrutura.es-codigo NO-ERROR.
                    
            IF tt-param.tipo = 1 THEN  /* Producao */
                ASSIGN d-quant-usada = estrutura.quant-usada.
            ELSE  /* Estoque */
                ASSIGN d-quant-usada = estrutura.quant-usada * tt-param.quantidade.

            CREATE tt-saida.
            ASSIGN tt-saida.seq            = i-seq-saida
                   tt-saida.nivel          = i-nivel
                   tt-saida.quant-usada    = d-quant-usada
                   tt-saida.es-codigo      = estrutura.es-codigo
                   tt-saida.desc-item      = item.desc-item
                   tt-saida.local-mont     = c-local-montag
                   tt-saida.b-local-mont   = b-local-montag WHEN tt-param.l-lista-comp = YES
                   tt-saida.obsoleto       = CAPS({ininc/i17in172.i 04 ITEM.cod-obsoleto})
                   tt-saida.fantasma       = estrutura.fantasma
                   tt-saida.un             = ITEM.un
                   tt-saida.data-inicio    = estrutura.data-inicio
                   tt-saida.data-termino   = estrutura.data-termino
                   tt-saida.it-fabric      = item-fabric.it-fabric WHEN AVAIL item-fabric.

            RUN pi-busca-localizacao-estoque.

            ASSIGN i-total = i-total + estrutura.quant-usada.
           
            IF tt-param.i-completo = 2 OR
                (tt-param.i-completo = 3 AND
                 estrutura.fantasma = YES) THEN
                RUN piGeraEngEstrut (INPUT estrutura.es-codigo,
                                     INPUT d-quant-usada).

        END.

    END.

    /* ImpressÆo TXT - Relat¢rio padrÆo */
    RUN piImprimeTxt.
    
    /* ImpressÆo Excel */
    IF tt-param.l-excel THEN
        RUN piImprimeExcel.

    {include/i-rpclo.i}

    /* ImpressÆo HTML */
    IF tt-param.l-gera THEN
        RUN piGeraHtml.



    run pi-finalizar in h-acomp.
    
    RETURN "OK".

end.



PROCEDURE piGeraEstrut:

    DEF INPUT PARAM p-it-codigo  LIKE ITEM.it-codigo.
    DEF INPUT PARAM p-quantidade LIKE dp-estrut.quant-usada.


    FOR LAST dp-proces-item
       WHERE dp-proces-item.item-dp = p-it-codigo NO-LOCK:

        FOR EACH dp-estrut NO-LOCK
           WHERE dp-estrut.item-dp         = p-it-codigo
             AND dp-estrut.num-proces-item = dp-proces-item.num-proces-item
             AND dp-estrut.data-termino    > tt-param.dt-corte
             AND dp-estrut.data-inicio    <= tt-param.dt-corte: 
            
            FIND ITEM NO-LOCK
                WHERE item.it-codigo = dp-estrut.es-codigo NO-ERROR.
            IF  AVAIL ITEM THEN 
                ASSIGN c-desc-item-dp = ITEM.desc-item.
            ELSE DO:
                FIND dp-item NO-LOCK
                    WHERE dp-item.it-codigo = dp-estrut.es-codigo NO-ERROR.
                ASSIGN c-desc-item-dp = IF AVAIL dp-item THEN dp-item.desc-item ELSE "".
            END.
    
            ASSIGN i-nivel = i-nivel + 1.
            
            FIND FIRST item-fabric NO-LOCK
                WHERE item-fabric.cod-fabric = tt-param.fi-cod-fabric
                  AND item-fabric.it-codigo  = dp-estrut.es-codigo no-error.

            IF tt-param.l-lista-comp = YES THEN DO:
                ASSIGN b-local-montag = " ".
                
                IF  tt-param.i-estrut = 2 THEN DO:
                    FOR EACH int-local-montag
                        WHERE int-local-montag.it-codigo = dp-estrut.item-dp
                        AND   int-local-montag.sequencia = dp-estrut.sequencia
                        AND   int-local-montag.es-codigo = dp-estrut.es-codigo NO-LOCK:
    
                        ASSIGN b-local-montag = b-local-montag + int-local-montag.local-montag  + ",". 
                    END.
                END.
                ELSE DO:

                    RUN pi-Local-Montagem (INPUT  dp-estrut.local-montag,
                                           OUTPUT b-local-montag).
                END.
            END.

/*             IF tt-param.l-lista-comp = YES THEN DO:                                                 */
/*                                                                                                     */
/*                 ASSIGN b-local-montag = "".                                                         */
/*                                                                                                     */
/*                 FOR EACH int-local-montag                                                           */
/*                     WHERE int-local-montag.it-codigo = dp-estrut.item-dp                            */
/*                     AND   int-local-montag.sequencia = dp-estrut.sequencia                          */
/*                     AND   int-local-montag.es-codigo = dp-estrut.es-codigo NO-LOCK:                 */
/*                                                                                                     */
/*                     ASSIGN b-local-montag = b-local-montag + int-local-montag.local-montag  + ",".  */
/*                 END.                                                                                */
/*             END.                                                                                    */

            ASSIGN c-local-montag = dp-estrut.local-montag. 
           
            IF dp-estrut.observacao <> ""  THEN 
                ASSIGN c-local-montag = c-local-montag + " - " + dp-estrut.observacao. 

            ASSIGN i-seq-saida = i-seq-saida + 1.
            
            CREATE tt-saida.
            ASSIGN tt-saida.seq          = i-seq-saida
                   tt-saida.nivel        = i-nivel
                   tt-saida.quant-usada  = IF tt-param.tipo = 1 /* Producao */ THEN dp-estrut.quant-usada ELSE /* Estoque */ dp-estrut.quant-usada * p-quantidade
                   tt-saida.es-codigo    = dp-estrut.es-codigo
                   tt-saida.desc-item    = c-desc-item-dp
                   tt-saida.local-mont   = c-local-montag
                   tt-saida.b-local-mont = b-local-montag WHEN tt-param.l-lista-comp = YES
                   tt-saida.obsoleto     = IF AVAIL ITEM THEN CAPS({ininc/i17in172.i 04 item.cod-obsoleto}) ELSE CAPS({ininc/i17in172.i 04 dp-item.cod-obsoleto})
                   tt-saida.fantasma     = dp-estrut.fantasma
                   tt-saida.un           = IF AVAIL ITEM THEN ITEM.un ELSE dp-item.un
                   tt-saida.data-inicio  = dp-estrut.data-inicio
                   tt-saida.data-termino = dp-estrut.data-termino
                   tt-saida.it-fabric    = item-fabric.it-fabric WHEN AVAIL item-fabric.

            RUN pi-busca-localizacao-estoque.

            IF dp-estrut.num-proces-compon <> 0 THEN DO:
                IF tt-param.i-completo = 3
                    AND dp-estrut.fantasma = NO THEN DO:
                        ASSIGN i-nivel = i-nivel - 1.
                        NEXT.
                END.

                RUN piGeraEstrut (INPUT dp-estrut.es-codigo,
                                  INPUT dp-estrut.quant-usada * p-quantidade).
            END.
            ELSE DO:
                IF tt-param.i-completo = 3
                    AND dp-estrut.fantasma = NO THEN DO: 
                        ASSIGN i-nivel = i-nivel - 1.
                        NEXT.
                END.

                RUN piGeraEngEstrut (INPUT dp-estrut.es-codigo,
                                     INPUT dp-estrut.quant-usada * p-quantidade).
            END.
            
            ASSIGN i-nivel = i-nivel - 1.

        END.
    END.
END PROCEDURE.



PROCEDURE piGeraEngEstrut:

    DEFINE INPUT PARAM p-it-codigo  LIKE ITEM.it-codigo.
    DEFINE INPUT PARAM p-quantidade LIKE estrutura.quant-usada.

    FOR EACH estrutura NO-LOCK
       WHERE estrutura.it-codigo       = p-it-codigo         
         AND estrutura.data-inicio    <= tt-param.dt-corte:

        IF NOT(tt-param.l-lista-vencidos) THEN
            IF estrutura.data-termino <= tt-param.dt-corte THEN NEXT.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-nivel = i-nivel + 1.
        
        IF tt-param.l-lista-comp = YES THEN DO:

            ASSIGN b-local-montag = "".

            FOR EACH int-local-montag NO-LOCK
               WHERE int-local-montag.it-codigo = estrutura.it-codigo 
                 AND int-local-montag.sequencia = estrutura.sequencia 
                 AND int-local-montag.es-codigo = estrutura.es-codigo:
                
                ASSIGN b-local-montag = b-local-montag + int-local-montag.local-montag  + ",".
            
            END.
        END.

        ASSIGN c-local-montag = estrutura.local-montag.

        IF estrutura.observacao <> "" THEN
        ASSIGN c-local-montag = c-local-montag + " - " + estrutura.observacao.
        
        FIND FIRST item-fabric NO-LOCK
            WHERE item-fabric.cod-fabric = tt-param.fi-cod-fabric
              AND item-fabric.it-codigo  = estrutura.es-codigo NO-ERROR.
        

        ASSIGN i-seq-saida = i-seq-saida + 1.
        
        CREATE tt-saida.
        ASSIGN tt-saida.seq            = i-seq-saida
               tt-saida.nivel          = i-nivel
               tt-saida.quant-usada    = IF tt-param.tipo = 1 /* Producao */ THEN estrutura.quant-usada ELSE /* Estoque */ estrutura.quant-usada * p-quantidade
               tt-saida.es-codigo      = estrutura.es-codigo
               tt-saida.desc-item      = ITEM.desc-item
               tt-saida.local-mont     = c-local-montag
               tt-saida.b-local-mont   = b-local-montag WHEN tt-param.l-lista-comp = YES
               tt-saida.obsoleto       = CAPS({ininc/i17in172.i 04 item.cod-obsoleto})
               tt-saida.fantasma       = estrutura.fantasma
               tt-saida.un             = ITEM.un
               tt-saida.data-inicio    = estrutura.data-inicio
               tt-saida.data-termino   = estrutura.data-termino
               tt-saida.it-fabric      = item-fabric.it-fabric WHEN AVAIL item-fabric.
              

        RUN pi-busca-localizacao-estoque.

        IF tt-param.i-completo = 3
            AND estrutura.fantasma = NO THEN DO:
                ASSIGN i-nivel = i-nivel - 1.
                NEXT.
        END.

        RUN piGeraEngEstrut (INPUT estrutura.es-codigo,
                             INPUT estrutura.quant-usada * p-quantidade).

        
        ASSIGN i-nivel = i-nivel - 1.
            
    END.

END PROCEDURE.

PROCEDURE piImprimeTxt:

    FOR EACH tt-saida 
        BY tt-saida.seq:

        IF tt-param.i-estrut = 1 /* Desenvolvimento de Produto */ THEN
            IF tt-param.tipo = 1 /* Producao */ THEN
                VIEW frame header-frame-dp.
            ELSE  /* Estoque */
                VIEW frame header-frame-dp-estoq.
        ELSE    /* Engenharia */
            IF tt-param.tipo = 1 /* Producao */ THEN
                VIEW frame header-frame-eng.
            ELSE
                VIEW frame header-frame-eng-estoq.

        IF tt-saida.fantasma = YES THEN
            ASSIGN c-es-codigo = "#" + tt-saida.es-codigo.
        ELSE
            ASSIGN c-es-codigo =  tt-saida.es-codigo.

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = tt-saida.es-codigo
                   NO-LOCK NO-ERROR.

        DISP tt-saida.nivel 
             tt-saida.quant-usada 
             c-es-codigo
             tt-saida.desc-item    FORMAT "x(60)":U 
            // item.class-fiscal WHEN AVAIL ITEM
             WITH FRAME lista NO-BOX.

        ASSIGN c-local-montag = tt-saida.local-mont.
        
        IF length(c-local-montag) > 30 THEN do:

            ASSIGN c-local-aux                 = c-local-montag
                   c-local-montag                     = SUBSTR(c-local-aux, 1, 30)
                   c-local-aux                 = SUBSTR(c-local-aux, 31, LENGTH(c-local-aux))
                   /*OVERLAY(c-local-aux, 1, 30) = "":U
                   c-local-aux                 = LEFT-TRIM(c-local-aux)*/
                   .

            DISP c-local-montag WITH FRAME lista NO-BOX.
            DOWN WITH FRAME lista.

            DO WHILE LENGTH(c-local-aux) > 0:

                IF LENGTH(c-local-aux) > 30 THEN DO:
                    ASSIGN c-local-montag                     = SUBSTR(c-local-aux, 1, 30)
                           c-local-aux                 = SUBSTR(c-local-aux, 31, LENGTH(c-local-aux))
                           /*OVERLAY(c-local-aux, 1, 30) = "":U
                           c-local-aux                 = LEFT-TRIM(c-local-aux)*/
                           .
                           
                END.
                ELSE DO:
                    ASSIGN c-local-montag                     = c-local-aux
                           c-local-aux                 = "":U.
                END.

                DISP c-local-montag WITH frame lista-local-montag NO-BOX.
                DOWN WITH FRAME lista-local-montag.

            END.
        END. 
        ELSE DO: 
            DISP c-local-montag WITH FRAME lista NO-BOX.
            DOWN WITH FRAME lista.
        END. 

        IF tt-param.l-linha THEN DO:
            DISP WITH FRAME linha.
            DOWN WITH FRAME linha.
        END.

        VIEW FRAME footer-frame.

    END.

    /* Linha Final para Montar o Quadro */
    IF NOT tt-param.l-linha THEN DO:
        DISP WITH FRAME linha.
        DOWN WITH FRAME linha.
    END.
    
END PROCEDURE.

PROCEDURE piImprimeExcel:

    DEFINE VARIABLE c-excel       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.
    
    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "UNIX" THEN DO:

        RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                           INPUT 1,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

            OS-CREATE-DIR VALUE(c-excel).

            ASSIGN c-excel = c-excel + "esdpp003.csv".
            
        END.

    END.
    ELSE DO:

        RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

            OS-CREATE-DIR VALUE(c-excel).

            ASSIGN c-excel = c-excel + "esdpp003.csv".
            
        END.

    END.
    

    OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".


    ASSIGN c-desc-item = "".

    IF tt-param.i-estrut = 1 /* Desenvolvimento de Produto */ THEN DO:

        FOR FIRST dp-item
            WHERE dp-item.it-codigo = tt-param.c-it-codigo NO-LOCK:

            ASSIGN c-desc-item = dp-item.desc-item.

        END.

    END.
    ELSE DO:

        FOR FIRST ITEM
            WHERE ITEM.it-codigo = tt-param.c-it-codigo NO-LOCK:
            
            ASSIGN c-desc-item = ITEM.desc-item.
             

        END.
    
    END.

    IF tt-param.i-estrut = 1 /* Desenvolvimento de Produto */ THEN
        PUT STREAM str-excel "Lista de Materiais - Item:;" tt-param.c-it-codigo ";" c-desc-item ";Versao:;" STRING(tt-param.i-versao) ";".
    ELSE  /* Engenharia */
        PUT STREAM str-excel "Lista de Materiais - Item:;" tt-param.c-it-codigo ";" c-desc-item ";;;".

    IF tt-param.i-completo = 2 THEN
        PUT STREAM str-excel "Completo;".
    IF tt-param.i-completo = 3 THEN
        PUT STREAM str-excel "Fantasma;".
    
    PUT STREAM str-excel SKIP.
    
    IF tt-param.l-lista-comp = YES AND tt-param.fi-cod-fabric = 0 THEN 

        PUT STREAM str-excel "Nivel;QTD;Codigo;Descricao;Situacao;Fantasma;UN;Data Inicio;Data Termino;Local Montagem;;NCM" SKIP.

    IF tt-param.l-lista-comp = YES AND tt-param.fi-cod-fabric <> 0 THEN

        PUT STREAM str-excel "Nivel;QTD;Codigo;Descricao;Situacao;Fantasma;UN;Data Inicio;Data Termino;Local Montagem;PN;;NCM" SKIP.
    
    IF tt-param.l-lista-comp = NO AND tt-param.fi-cod-fabric = 0 THEN

        PUT STREAM str-excel "Nivel;QTD;Codigo;Descricao;Situacao;Fantasma;UN;Data Inicio;Data Termino;;;NCM" SKIP.

    IF tt-param.l-lista-comp = NO AND tt-param.fi-cod-fabric <> 0 THEN

        PUT STREAM str-excel "Nivel;QTD;Codigo;Descricao;Situacao;Fantasma;UN;Data Inicio;Data Termino;;PN;NCM" SKIP.
    
    FOR EACH tt-saida
        BY tt-saida.seq:
        
        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = tt-saida.es-codigo
                   NO-LOCK NO-ERROR.

        PUT STREAM str-excel tt-saida.nivel                                                 ";"
                             tt-saida.quant-usada                                           ";"
                             tt-saida.es-codigo                                             ";"
                             tt-saida.desc-item                                             ";"
                             tt-saida.obsoleto     FORMAT "x(27)":U                         ";"
                             tt-saida.fantasma                                              ";"                             
                             tt-saida.un                                                    ";"
                             tt-saida.data-inicio                                           ";"      
                             tt-saida.data-termino                                          ";"
                             tt-saida.b-local-mont FORMAT "X(3000)":U                       ";"
                             tt-saida.it-fabric                                             ";"
                             IF AVAIL ITEM 
                                THEN item.class-fiscal                                      
                                ELSE ""
                             SKIP.
    
    END.
    
    OUTPUT STREAM str-excel CLOSE.
    
    CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
    IF ERROR-STATUS:ERROR THEN 
        CREATE "Excel.Application":U chExcel.
        
    ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
    ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).

    chPlanilhaMod:Activate().

    ASSIGN chExcel:VISIBLE     = TRUE
           chExcel:WindowState = 3.
    
    RELEASE OBJECT chExcel       NO-ERROR.
    RELEASE OBJECT chArquivo     NO-ERROR.
    RELEASE OBJECT chPlanilhaMod NO-ERROR.
   
END.

PROCEDURE piGeraHtml:

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "UNIX" THEN DO:

        RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                           INPUT 1,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-arquivo = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

            OS-CREATE-DIR VALUE(c-arquivo).

            ASSIGN c-arquivo = c-arquivo + "esdpp003.html".
            
        END.

    END.
    ELSE DO:

        RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
        FOR FIRST tt-prog-ponto NO-LOCK:

            ASSIGN c-arquivo = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

            OS-CREATE-DIR VALUE(c-arquivo).

            ASSIGN c-arquivo = c-arquivo + "esdpp003.htm".
            
        END.

    END.

    ASSIGN c-tam-tab = "900".

    OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

    RUN html-inicio("Lista de Materiais").

    IF tt-param.i-estrut = 1 /* Desenvolvimento de Produto */ THEN DO:

        FOR FIRST dp-item
            WHERE dp-item.it-codigo = tt-param.c-it-codigo NO-LOCK:

            ASSIGN c-desc-item = dp-item.desc-item.

        END.

    END.
    ELSE DO:

        FOR FIRST ITEM
            WHERE ITEM.it-codigo = tt-param.c-it-codigo NO-LOCK:

            ASSIGN c-desc-item = ITEM.desc-item.

        END.

    END.

    IF tt-param.i-estrut = 1 /* Desenvolvimento de Produto */ THEN
        assign c-tit-html = "Lista de Materiais - ITEM: " + tt-param.c-it-codigo + " " + c-desc-item + "- Versao: " + STRING(tt-param.i-versao).
    ELSE  /* Producao */
        assign c-tit-html = "Lista de Materiais - ITEM: " + tt-param.c-it-codigo + " " +  c-desc-item.

    IF tt-param.i-completo = 2 THEN
        ASSIGN c-tit-html = c-tit-html + " Completo".
    IF tt-param.i-completo = 3 THEN 
        ASSIGN c-tit-html = c-tit-html + " Fantasma".

    RUN html-titulo(c-tit-html).

    RUN html-ini-tab.             
    RUN html-ini-lin-tab.           

    RUN html-cab-tab("Nivel").
    RUN html-cab-tab("F").
    RUN html-cab-tab("Quant").
    RUN html-cab-tab("Codigo").    
    RUN html-cab-tab("Descricao").    
    RUN html-cab-tab("Local").    
    
    RUN html-fim-lin-tab.          

    FOR EACH tt-saida
        BY tt-saida.seq:
        
        RUN html-ini-lin-tab.

        RUN html-con-w-tab-cor(tt-saida.nivel, "RIGHT","5%",STRING(tt-saida.nivel,"99")).
        
        IF tt-saida.fantasma THEN
            RUN html-con-w-tab-cor("#", "CENTER","2%",STRING(tt-saida.nivel,"99")).
        ELSE 
            RUN html-con-w-tab-cor("&nbsp;", "RIGHT","2%",STRING(tt-saida.nivel,"99")).
        
        RUN html-con-w-tab-cor(STRING(tt-saida.quant-usada), "RIGHT","10%",STRING(tt-saida.nivel,"99")).
        RUN html-con-w-tab-cor(tt-saida.es-codigo,"LEFT","12%",STRING(tt-saida.nivel,"99")).
        RUN html-con-w-tab-cor(tt-saida.desc-item,"LEFT","41%",STRING(tt-saida.nivel,"99")).
        RUN html-con-w-tab-cor(tt-saida.local-mont,"LEFT","30%",STRING(tt-saida.nivel,"99")).

        RUN html-fim-lin-tab.
        
    END.

    RUN html-fim-tab.
    
    RUN html-fim.    
    OUTPUT close.

    RUN esp/visualiza.p (c-arquivo).

END PROCEDURE.


PROCEDURE pi-busca-localizacao-estoque:

    IF tt-param.tipo = 2 /* Estoque */ THEN DO:

        ASSIGN tt-saida.local-mont = "".

        EMPTY TEMP-TABLE tt-aes.
        EMPTY TEMP-TABLE tt-saldo.
    
        RUN esp/cep/escep005rpc.p (INPUT v_cod_estab_usuar,
                                   INPUT tt-saida.es-codigo,     
                                   INPUT "ALM",    /* Deposito Ini */
                                   INPUT "ALM",   /* Deposito Fim */
                                   INPUT 1,      /* Tipo: Total */
                                   OUTPUT de-quantidade,  
                                   OUTPUT de-saldo,       
                                   OUTPUT de-saldo-rec, 
                                   OUTPUT i-saldo-alm,  
                                   OUTPUT c-cod-localiz,
                                   OUTPUT TABLE tt-aes,
                                   OUTPUT TABLE tt-saldo).
    
        FOR FIRST tt-aes
            BY tt-aes.data
            BY tt-aes.nr-ae
            BY tt-aes.sequencia:
    
            ASSIGN tt-saida.local-mont = tt-aes.localizacao.
    
        END.

        IF NOT AVAIL tt-aes THEN DO:
            RUN esp/cep/escep005rpc.p (INPUT v_cod_estab_usuar,
                                       INPUT tt-saida.es-codigo,     
                                       INPUT "WAL",    /* Deposito Ini */
                                       INPUT "WAL",   /* Deposito Fim */
                                       INPUT 1,      /* Tipo: Total */
                                       OUTPUT de-quantidade,  
                                       OUTPUT de-saldo,       
                                       OUTPUT de-saldo-rec, 
                                       OUTPUT i-saldo-alm,  
                                       OUTPUT c-cod-localiz,
                                       OUTPUT TABLE tt-aes,
                                       OUTPUT TABLE tt-saldo).
        
            FOR FIRST tt-aes
                BY tt-aes.data
                BY tt-aes.nr-ae
                BY tt-aes.sequencia:
        
                ASSIGN tt-saida.local-mont = tt-aes.localizacao.
        
            END.
        END.


    END.


END PROCEDURE.


/* Local Variable Definitions */
def temp-table tt-pos
    field letra    as char format "X(15)"     
    field ord      as dec
    field pos      as char format "x(15)"  
    index tt-pos is primary unique 
          letra 
          ord
    index ordem 
          letra
          pos.
                              
def temp-table tt-string
    field letra    as char
    field pos      as char
    index formato 
          letra.

def buffer b-dp-estrut for dp-estrut.
def buffer b-tt-pos    for tt-pos.

def var l-texto         as log.
def var l-conf as logical format "Sim/Nao".
def var l-tem as logical.
def var l-alterou       as log  no-undo initial no.
def var c-local         as char no-undo.
def var i-ind           as int.
def var i               as int.
def var i-ind1          as int.
def var c-letra         as char.
DEF VAR c-letra-controle AS CHAR.
def var c-parte         as char.
def var c-parte1        as char.
def var c-pos           as char.
def var c-pos-ant       as char.
def var c-pos-inc       as char.
def var c-pos-inc-tt    as char.
def var l-fechou        as log.
def var l-erro          as log.
def var c-pos-ini       as char format "x(15)".
def var c-pos-fim       as char format "x(15)".
def var c-msg           as char init "<I>Inclui   <E>Elimina   <F1>Sair".
DEFINE VARIABLE i-testa AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-local-montag-anterior AS CHARACTER   NO-UNDO.

{esp\enp\esenp001.i1}

PROCEDURE pi-Local-Montagem:
    DEF INPUT  PARAM p-LocalMontagem AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-Local-Montagem-Explodido AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-pos.
    RUN piTestaLocalMont(INPUT  p-LocalMontagem /*dp-estrut.local-montag*/ , 
                         OUTPUT l-erro).
    
    IF  l-erro THEN DO:
        ASSIGN p-Local-Montagem-Explodido = p-LocalMontagem.
        RETURN "OK".
    END.

            
    IF INDEX(p-LocalMontagem /*dp-estrut.local-montag*/ ,";") = 0 AND 
       INDEX(p-LocalMontagem /*dp-estrut.local-montag*/ ,"(") = 0 THEN DO:
       RUN piCriaSegmento(INPUT p-LocalMontagem /*dp-estrut.local-montag*/ ,
                          INPUT "",
                          INPUT "", 
                          INPUT YES).
    END.
    ELSE DO i = 1 TO NUM-ENTRIES(p-LocalMontagem /*dp-estrut.local-montag*/ ,";"):
        ASSIGN c-local = ENTRY(i,p-LocalMontagem /*dp-estrut.local-montag*/ ,";").
        IF INDEX(c-local,"(") = 0 THEN DO:
            ASSIGN c-letra = c-local
                   c-parte = "".
            RUN piCriaSegmento(INPUT c-letra,
                               INPUT "",
                               INPUT "",
                               INPUT yes).
    
        END.
        ELSE DO:
            ASSIGN c-letra = substr(c-local,1,index(c-local,"(") - 1)
                   c-parte = substr(c-local,
                                    index(c-local,"(") + 1, 
                                    index(c-local,")") - (index(c-local,"(") + 1)).
            DO i-ind = 1 TO NUM-ENTRIES(c-parte,","):
               ASSIGN c-parte1 = ENTRY(i-ind,c-parte,",") NO-ERROR.
               IF index(c-parte1,"-") <> 0 THEN DO:
                   ASSIGN c-pos-ini = ENTRY(1,c-parte1,"-")
                          c-pos-fim = ENTRY(2,c-parte1,"-").
                   IF ASC(CAPS(c-pos-ini)) >= 65 THEN DO:
                       RUN piCriaSegmento(INPUT c-letra, 
                                          INPUT c-pos-ini, 
                                          INPUT c-pos-fim, 
                                          INPUT YES).
                   END.
                   ELSE DO:
                       RUN piCriaSegmento(INPUT c-letra, 
                                          INPUT c-pos-ini, 
                                          INPUT c-pos-fim, 
                                          INPUT NO).
                   END.
               END.
               ELSE DO:
                   RUN piCriaSegmento(INPUT c-letra, 
                                      INPUT c-parte1, 
                                      INPUT c-parte1, 
                                      INPUT YES).
               END.
            END.
        END.
    END. /* ELSE DO i = 1 TO NUM-ENTRIES(dp-estrut.local-montag,";"): */
    
    FOR EACH tt-pos
        BY tt-pos.letra
        BY int(tt-pos.pos):
    
        IF  p-Local-Montagem-Explodido = "" THEN
            ASSIGN p-Local-Montagem-Explodido = tt-pos.letra + tt-pos.pos.
        ELSE
            ASSIGN p-Local-Montagem-Explodido = p-Local-Montagem-Explodido + "," + tt-pos.letra + tt-pos.pos.
    
    END.
END.

PROCEDURE piCriaSegmento:

    def input param c-letra as char no-undo.
    def input param c-ini   as char no-undo.
    def input param c-fim   as char no-undo.
    def input param l-alfa  as logical no-undo.
    def var c-carac as char    no-undo.
    def var i       as integer no-undo.
    def var ini     as int     no-undo.
    def var fim     as int     no-undo.

    if l-alfa = no then do:
       assign ini = int(c-ini)
              fim = int(c-fim).
       do i = ini to fim:
          assign c-carac  = caps(string(i)).
          find first tt-pos where tt-pos.letra = c-letra 
                              and tt-pos.pos   = trim(c-carac)
                            no-error.
          if not avail tt-pos then do:                  
             create tt-pos.
             assign tt-pos.letra   = caps(c-letra)
                    tt-pos.pos     = trim(c-carac). 
             if trim(tt-pos.pos) = "0" then 
                assign tt-pos.pos = "".
             run PiConverte(trim(c-carac), output tt-pos.ord).       
          end.          
       end.
    end.
    else do:
       if c-ini = c-fim then do:
          find first tt-pos where tt-pos.letra = c-letra 
                              and tt-pos.pos   = trim(c-ini)
                            no-error.
          if not avail tt-pos then do:                  
             create tt-pos.
             assign tt-pos.letra   = caps(c-letra)
                    tt-pos.pos     = caps(trim(c-ini)).
             if trim(tt-pos.pos) = "0" then 
                assign tt-pos.pos = "".
             run PiConverte(trim(c-ini), output tt-pos.ord).
          end.
       end.   
       else do:
          do i = asc(caps(c-ini)) to asc(caps(c-fim)):
             find first tt-pos where tt-pos.letra = c-letra
                                 and tt-pos.pos   = chr(i)
                               no-error.
             if not avail tt-pos then do:                  
                create tt-pos.
                assign tt-pos.letra   = caps(c-letra)
                       tt-pos.pos     = chr(i).
                if trim(tt-pos.pos) = "0" then 
                   assign tt-pos.pos = "".
                run PiConverte(chr(i), output tt-pos.ord).
             end.
          end.
       end.          
    end.
 END PROCEDURE.

 PROCEDURE PiConverte:

   def input param c-pos as char no-undo.
   def output param de-num as dec no-undo.

   def var c-carac as char    no-undo.
   def var c-mult  as char    no-undo.
   def var i-cont  as integer no-undo.
   def var l-alfa  as logical no-undo.
   
   def var de-mult as decimal no-undo.

   assign c-mult = "100000000000000000000000000000".
   do i-cont = 1 to length(trim(c-pos)):
      assign c-carac = c-carac 
                     + string(asc(caps(substring(c-pos,i-cont,1)))).
      if asc(caps(substring(c-pos,i-cont,1))) >= 65 then do: 
         l-alfa = yes.
      end.
   end.
   if l-alfa then do:
      assign de-mult = dec(substring(c-mult,1,((30 - length(c-carac)) + 1)))
             de-num = (dec(c-carac) * de-mult).
   end.
   else 
      assign de-num = dec(c-pos).

END PROCEDURE.



/* pi-Local-Montagem 
{esp/dpp/esdpp003rp.i}
*/



