/***********************************************************************
**  Programa..: ESP\PDP\ESPDP002RP-A.P
**  Autor.....: Clayton Antunes
**  Data......: Maio/2006 - Desenvolvimento
**  Descricao.: Impress∆o de etiquetas
**  Vers∆o....: 001 05/05/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESPDP002 3.04.00.001}

/****************************  Definitions  ****************************/
{esp/pdp/espdp002tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-saldo-item
    FIELD nome-abrev    LIKE ped-venda.nome-abrev 
    FIELD nr-pedcli     LIKE ped-venda.nr-pedcli
    FIELD nr-pedido     LIKE ped-venda.nr-pedido
    FIELD depos         AS CHAR  FORMAT "X(3)" 
    FIELD i-seq         AS INT   FORMAT ">>9"
    FIELD it-codigo     AS CHAR  FORMAT "X(11)"
    FIELD desc-item     AS CHAR  FORMAT "X(30)"
    FIELD qt-a-atender  AS INT   FORMAT '>>>9'
    FIELD cod-depos     AS DEC EXTENT 14
    FIELD reservas      AS dec
    FIELD log-bloq      AS log
    INDEX Id nr-pedido i-seq
    INDEX ITEM it-codigo.


DEF TEMP-TABLE tt-ordem-impressao
    FIELD etiq-nr-pedcli  LIKE ped-venda.nr-pedcli
    FIELD etiq-it-codigo  LIKE ped-item.it-codigo
    FIELD etiq-depos      AS CHAR  FORMAT "X(3)" 
    FIELD etiq-seq    AS CHAR  FORMAT "X(3)" 
    FIELD etiq-qtde       AS INT   FORMAT '>>>9' 
    FIELD libera          AS INT
    FIELD localizacao-alm LIKE ae-item.localizacao
    FIELD localizacao-ast LIKE ae-item.localizacao.


 
/****************************  Variaveis    ****************************/
DEF VAR l-tem AS LOGICAL.
DEF VAR tot AS INT.
DEF VAR i-cont    AS INT.
DEF VAR fi-copias AS INT.
DEF VAR c-local   AS CHAR FORMAT "X(13)".

DEF VAR i-posicao AS INT.
DEF VAR libera    AS INT.
DEF VAR deposito  AS CHAR FORMAT "X(3)".

DEF VAR etiq1-pedido LIKE ped-venda.nr-pedcli.   
DEF VAR etiq1-item   LIKE ped-item.it-codigo.
DEF VAR etiq1-dep    AS CHAR. 
DEF VAR etiq1-qtde   LIKE ped-item.qt-pedida.
DEF VAR etiq1-seq    AS CHAR.
DEF VAR etiq1-localizacao-alm LIKE ae-item.localizacao.
DEF VAR etiq1-localizacao-ast LIKE ae-item.localizacao.
DEF VAR etiq2-pedido LIKE ped-venda.nr-pedcli.   
DEF VAR etiq2-item   LIKE ped-item.it-codigo.
DEF VAR etiq2-seq    AS CHAR.
DEF VAR etiq2-dep    AS CHAR. 
DEF VAR etiq2-qtde   LIKE ped-item.qt-pedida.
DEF VAR etiq2-localizacao-alm LIKE ae-item.localizacao.
DEF VAR etiq2-localizacao-ast LIKE ae-item.localizacao.

DEF VAR etiq3-pedido LIKE ped-venda.nr-pedcli.   
DEF VAR etiq3-item   LIKE ped-item.it-codigo.
DEF VAR etiq3-seq    AS CHAR.
DEF VAR etiq3-dep    AS CHAR. 
DEF VAR etiq3-qtde   LIKE ped-item.qt-pedida.
DEF VAR etiq3-localizacao-alm LIKE ae-item.localizacao.
DEF VAR etiq3-localizacao-ast LIKE ae-item.localizacao.


ASSIGN i-posicao = 1.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      AS HANDLE NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.




/* Seleciona ordem de Dep¢sito */
DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}

RUN esp\es0018p.p (INPUT "espdp002",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
/* Fim seleá∆o ordem dep¢sito */




/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}
/*     VIEW FRAME f-cabec.  */
/*     VIEW FRAME f-rodape. */

   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   
   RUN pi-inicializar IN h-acomp (INPUT "Montando Relat¢rio...").
   
   
   RUN piMontaRelat.

   RUN piOrganizaImpressao.

   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
END.
/********************************************************************** */




/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:
    EMPTY TEMP-TABLE tt-saldo-item.
    IF tt-param.nr-nota-fisc = "" THEN DO:
       FOR EACH  ped-venda USE-INDEX ch-implant  NO-LOCK 
            WHERE ped-venda.cod-estabel = tt-param.cod-estabel
            and (ped-venda.cod-sit-ped = 1 OR ped-venda.cod-sit-ped = 2) /* 1 Aberto */
            AND   ped-venda.nr-pedido   >= tt-param.nr-pedido-ini
            AND   ped-venda.nr-pedido   <= tt-param.nr-pedido-fim
            AND   ped-venda.dt-implant  >= tt-param.dt-implant-ini
            AND   ped-venda.dt-implant  <= tt-param.dt-implant-fim
            AND   ped-venda.tp-pedido   >= tt-param.tp-pedido-ini
            AND   ped-venda.tp-pedido   <= tt-param.tp-pedido-fim
            AND   ped-venda.cod-priori  >= tt-param.prioridade-ini
            AND   ped-venda.cod-priori  <= tt-param.prioridade-fim:

            RUN pi-acompanhar IN h-acomp (INPUT "Pedido.: " + ped-venda.nr-pedcli).
            /* agrupamento de itens iguais */
    
            ASSIGN i-cont = 0.
            ASSIGN l-tem = NO.
    
            FOR EACH  ped-item  OF ped-venda 
                WHERE (ped-item.qt-pedida - ped-item.qt-alocada) > 0 
                  AND ped-item.cod-sit-item < 3  NO-LOCK:
    
                FIND FIRST tt-saldo-item                                 WHERE
                           tt-saldo-item.nr-pedido = ped-venda.nr-pedido AND
                           tt-saldo-item.it-codigo = ped-item.it-codigo  NO-ERROR.
    
                IF NOT AVAIL tt-saldo-item THEN DO:
                   ASSIGN i-cont = i-cont + 1.
                   CREATE tt-saldo-item.
                END.              
                
                ASSIGN tt-saldo-item.i-seq          = i-cont
                       tt-saldo-item.nome-abrev     = ped-venda.nome-abrev
                       tt-saldo-item.nr-pedcli      = ped-venda.nr-pedcli
                       tt-saldo-item.nr-pedido      = ped-venda.nr-pedido 
                       tt-saldo-item.it-codigo      = ped-item.it-codigo
                       tt-saldo-item.qt-a-atender   = tt-saldo-item.qt-a-atender + (ped-item.qt-pedida - 
                                                                                    ped-item.qt-alocada).
    
                FOR EACH tt-prog-ponto:                
                    FOR EACH saldo-estoq NO-LOCK                               WHERE
                        saldo-estoq.it-codigo   = ped-item.it-codigo      AND
                        saldo-estoq.cod-estabel = tt-param.cod-estabel                   AND
                        saldo-estoq.cod-depos   = tt-prog-ponto.conteudo:  /*     AND
                        saldo-estoq.qtidade-atu >= tt-saldo-item.qt-a-atender: */
                        ASSIGN tot = tot + saldo-estoq.qtidade-atu.
                    END.
                    
                    IF tot > tt-saldo-item.qt-a-atender THEN DO:                      
                       ASSIGN tt-saldo-item.depos = tt-prog-ponto.conteudo. 
                       ASSIGN l-tem = YES. 
                       ASSIGN tot = 0.
                       LEAVE.
                    END.
                    ASSIGN tot = 0.
                END.
    
                /* Conteudo para impress∆o */
                
                IF tt-param.consolidado = 1 THEN DO:
                    FIND tt-ordem-impressao
                        WHERE tt-ordem-impressao.etiq-nr-pedcli = tt-saldo-item.nr-pedcli   
                          AND tt-ordem-impressao.etiq-it-codigo = tt-saldo-item.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-ordem-impressao THEN DO:
                        CREATE tt-ordem-impressao.
                    END.
                END.
                ELSE 
                    CREATE tt-ordem-impressao.

                ASSIGN etiq-nr-pedcli = tt-saldo-item.nr-pedcli   
                       etiq-it-codigo = tt-saldo-item.it-codigo
                       etiq-seq       = string(tt-saldo-item.i-seq,"ZZZZ9")
                       etiq-depos     = tt-saldo-item.depos
                       etiq-qtde      = etiq-qtde  + (ped-item.qt-pedida - ped-item.qt-alocada).
                for first saldo-estoq no-lock
                    where saldo-estoq.cod-estabel = ped-venda.cod-estabel
                    and   saldo-estoq.it-codigo  = tt-saldo-item.it-codigo
                    and   saldo-estoq.cod-depos  = "AST"
                    AND   saldo-estoq.cod-localiz <> ""
                    AND   saldo-estoq.qtidade-atu > 0
                    break by saldo-estoq.cod-localiz:
                     ASSIGN tt-ordem-impressao.localizacao-ast = saldo-estoq.cod-localiz.
                 END.
            END.
        END.
    END.
    ELSE DO:

       
        ASSIGN i-cont = 0.

        ASSIGN l-tem = NO.
        FOR EACH ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido     = tt-param.nr-pedido-ini,
            EACH nota-fiscal 
            WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
              AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli
              AND nota-fiscal.nr-nota-fis = tt-param.nr-nota-fisc NO-LOCK,
            first emitente no-lock
            where emitente.nome-abrev = ped-venda.nome-abrev,
            EACH it-nota-fisc OF nota-fiscal NO-LOCK
            BY it-nota-fisc.nr-seq-fat:

               

                FIND FIRST tt-saldo-item                                 WHERE
                           tt-saldo-item.nr-pedido = ped-venda.nr-pedido AND
                           tt-saldo-item.it-codigo = it-nota-fisc.it-codigo  NO-ERROR.
    
                IF NOT AVAIL tt-saldo-item THEN DO:
                   ASSIGN i-cont = i-cont + 1.
                   CREATE tt-saldo-item.
                END.              
                
                ASSIGN tt-saldo-item.i-seq          = i-cont
                       tt-saldo-item.nome-abrev     = ped-venda.nome-abrev
                       tt-saldo-item.nr-pedcli      = ped-venda.nr-pedcli
                       tt-saldo-item.nr-pedido      = ped-venda.nr-pedido 
                       tt-saldo-item.it-codigo      = it-nota-fisc.it-codigo
                       tt-saldo-item.qt-a-atender   = tt-saldo-item.qt-a-atender + it-nota-fisc.qt-faturada[1].


                FOR EACH tt-prog-ponto:                
                    FOR EACH saldo-estoq NO-LOCK                               WHERE
                        saldo-estoq.it-codigo   = ped-item.it-codigo      AND
                        saldo-estoq.cod-estabel = tt-param.cod-estabel                   AND
                        saldo-estoq.cod-depos   = tt-prog-ponto.conteudo:  
                        ASSIGN tot = tot + saldo-estoq.qtidade-atu.        
                    END.
                    
                    IF tot > tt-saldo-item.qt-a-atender THEN DO:                      
                       ASSIGN tt-saldo-item.depos = tt-prog-ponto.conteudo. 
                       ASSIGN l-tem = YES. 
                       ASSIGN tot = 0.
                       LEAVE.
                    END.
                    ASSIGN tot = 0.
                END.

                IF tt-param.consolidado = 1 THEN DO:
                    FIND tt-ordem-impressao
                        WHERE tt-ordem-impressao.etiq-nr-pedcli = tt-saldo-item.nr-pedcli   
                          AND tt-ordem-impressao.etiq-it-codigo = tt-saldo-item.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-ordem-impressao THEN DO:
                        CREATE tt-ordem-impressao.
                    END.
                END.
                ELSE 
                    CREATE tt-ordem-impressao.
         
                ASSIGN etiq-nr-pedcli = tt-saldo-item.nr-pedcli   
                       etiq-it-codigo = tt-saldo-item.it-codigo
                       etiq-seq       = string(tt-saldo-item.i-seq,"ZZZZ9")
                       etiq-depos     = tt-saldo-item.depos
                       etiq-qtde      = etiq-qtde  + it-nota-fisc.qt-faturada[1].
                for first saldo-estoq no-lock
                    where saldo-estoq.cod-estabel = ped-venda.cod-estabel
                    and   saldo-estoq.it-codigo  = tt-saldo-item.it-codigo
                    and   saldo-estoq.cod-depos  = "AST"
                    AND   saldo-estoq.cod-localiz <> ""
                    AND   saldo-estoq.qtidade-atu > 0
                    break by saldo-estoq.cod-localiz:
                     ASSIGN tt-ordem-impressao.localizacao-ast = saldo-estoq.cod-localiz.
                END.
        END.
    END.
END PROCEDURE.

PROCEDURE piOrganizaImpressao:
    i-posicao = 1.
    FOR EACH tt-ordem-impressao BY tt-ordem-impressao.etiq-depos: 


        
        IF i-posicao = 1 THEN DO:
           etiq1-pedido = tt-ordem-impressao.etiq-nr-pedcli.
           etiq1-item   = tt-ordem-impressao.etiq-it-codigo.
           etiq1-seq    = tt-ordem-impressao.etiq-seq.
           etiq1-dep    = tt-ordem-impressao.etiq-depos.
           etiq1-qtde   = tt-ordem-impressao.etiq-qtde.
           etiq1-localizacao-alm = tt-ordem-impressao.localizacao-alm.
           etiq1-localizacao-ast = tt-ordem-impressao.localizacao-ast.
           ASSIGN i-posicao = 2.
        END.
        ELSE DO:
           IF i-posicao = 2 THEN DO:
              etiq2-pedido = tt-ordem-impressao.etiq-nr-pedcli.
              etiq2-item   = tt-ordem-impressao.etiq-it-codigo.
              etiq2-seq    = tt-ordem-impressao.etiq-seq.
              etiq2-dep    = tt-ordem-impressao.etiq-depos.
              etiq2-qtde   = tt-ordem-impressao.etiq-qtde.
              etiq2-localizacao-alm = tt-ordem-impressao.localizacao-alm.
              etiq2-localizacao-ast = tt-ordem-impressao.localizacao-ast.

              ASSIGN i-posicao = 3.
           END.
           ELSE DO:
              etiq3-pedido = tt-ordem-impressao.etiq-nr-pedcli.
              etiq3-item   = tt-ordem-impressao.etiq-it-codigo.
              etiq3-seq    = tt-ordem-impressao.etiq-seq.
              etiq3-dep    = tt-ordem-impressao.etiq-depos.
              etiq3-qtde   = tt-ordem-impressao.etiq-qtde.
              etiq3-localizacao-alm = tt-ordem-impressao.localizacao-alm.
              etiq3-localizacao-ast = tt-ordem-impressao.localizacao-ast.

              ASSIGN i-posicao = 1.
              libera = 3.
           END.
        END.

        IF libera = 3 THEN DO:
           RUN piImprimeEtiqueta-3. 
               etiq1-pedido = "".
               etiq2-pedido = "".
               etiq3-pedido = "".
               i-posicao = 1.
               libera = 1.
        END.

    END.

    
    IF etiq2-pedido <> "" THEN DO:
        RUN piImprimeEtiqueta-2. 
    END.
    ELSE DO:
        IF etiq1-pedido <> "" THEN DO:
            RUN piImprimeEtiqueta-1. 
        END.
    END.
END PROCEDURE.

PROCEDURE piImprimeEtiqueta-3:
    
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ≤ o numero de Dotãs que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,20^BY3^A0N,20,Y,N^FD" "Pedido: " etiq1-pedido "^FS"        
        "^FO300,20^BY3^A0N,20,Y,N^FD" "Pedido: " etiq2-pedido "^FS" 
        "^FO560,20^BY3^A0N,20,Y,N^FD" "Pedido: " etiq3-pedido "^FS" SKIP
        "^FO45,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq1-dep "^FS"        
        "^FO300,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq2-dep "^FS" 
        "^FO560,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq3-dep "^FS" SKIP
        "^FO45,70^BY3^A0N,20,Y,N^FD" etiq1-seq  " Qtde: " etiq1-qtde  "^FS"        
        "^FO300,70^BY3^A0N,20,Y,N^FD" etiq2-seq  " Qtde: " etiq2-qtde "^FS" 
        "^FO560,70^BY3^A0N,20,Y,N^FD" etiq3-seq  " Qtde: " etiq3-qtde "^FS" SKIP.

    IF  etiq1-localizacao-ast <> "" THEN
        PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " AST: " etiq1-localizacao-ast "^FS".
    ELSE
        IF  etiq1-localizacao-ALM <> "" THEN
            PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq1-localizacao-ALM "^FS".

    IF  etiq2-localizacao-ast <> "" THEN
        PUT "^FO300,95^BY3^A0N,20,Y,N^FD" " AST: " etiq2-localizacao-ast "^FS".
    ELSE
        IF  etiq2-localizacao-ALM <> "" THEN
            PUT "^FO300,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq2-localizacao-ALM "^FS".

    IF  etiq3-localizacao-ast <> "" THEN
        PUT "^FO560,95^BY3^A0N,20,Y,N^FD" " AST: " etiq3-localizacao-ast "^FS".
    ELSE
        IF  etiq3-localizacao-ALM <> "" THEN
            PUT "^FO560,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq3-localizacao-ALM "^FS".

    PUT UNFORMATTED "^FS" SKIP.
    PUT UNFORMATTED "^FO25,120^BY2,3.0^BCN,40,N,N,N,N^FD"  etiq1-item "^FS".
    PUT UNFORMATTED "^FO25,165^A0N,20,20^FB245,1,0,C^FD" etiq1-item "^FS".
    PUT UNFORMATTED "^FO283,120^BY2,3.0^BCN,40,N,N,N,N^FD" etiq2-item "^FS".
    PUT UNFORMATTED "^FO283,165^A0N,20,20^FB245,1,0,C^FD" etiq2-item "^FS".
    PUT UNFORMATTED "^FO540,120^BY2,3.0^BCN,40,N,N,N,N^FD" etiq3-item "^FS".
    PUT UNFORMATTED "^FO540,165^A0N,20,20^FB245,1,0,C^FD" etiq3-item "^FS" SKIP.
                    
    PUT UNFORMATTED "^XZ".
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE piImprimeEtiqueta-2:
    
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ≤ o numero de Dotãs que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,20^A0N,20,Y,N^FD" "Pedido: " etiq1-pedido "^FS"        
        "^FO330,20^A0N,20,Y,N^FD" "Pedido: " etiq2-pedido "^FS" SKIP
        "^FO45,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq1-dep "^FS"
        "^FO330,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq2-dep "^FS" SKIP
        "^FO45,70^BY3^A0N,20,Y,N^FD" etiq1-seq  " Qtde: " etiq1-qtde "^FS"        
        "^FO330,70^BY3^A0N,20,Y,N^FD" etiq2-seq  " Qtde: " etiq2-qtde "^FS" SKIP.

    IF  etiq1-localizacao-ast <> "" THEN
        PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " AST: " etiq1-localizacao-ast "^FS".
    ELSE
        IF  etiq1-localizacao-ALM <> "" THEN
            PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq1-localizacao-ALM "^FS".

    IF  etiq2-localizacao-ast <> "" THEN
        PUT "^FO330,95^BY3^A0N,20,Y,N^FD" " AST: " etiq2-localizacao-ast "^FS".
    ELSE
        IF  etiq2-localizacao-ALM <> "" THEN
            PUT "^FO330,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq2-localizacao-ALM "^FS".

    PUT UNFORMATTED "^FS" SKIP.
    PUT UNFORMATTED "^FO25,120^BY2,3.0^BCN,40,N,N,N,N^FD"  etiq1-item "^FS".
    PUT UNFORMATTED "^FO25,165^A0N,20,20^FB245,1,0,C^FD" etiq1-item "^FS".
    PUT UNFORMATTED "^FO283,120^BY2,3.0^BCN,40,N,N,N,N^FD" etiq2-item "^FS".
    PUT UNFORMATTED "^FO283,165^A0N,20,20^FB245,1,0,C^FD" etiq2-item "^FS" SKIP.

    PUT UNFORMATTED "^XZ".    
    OUTPUT CLOSE.
END PROCEDURE.

PROCEDURE piImprimeEtiqueta-1:
    
    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ≤ o numero de Dotãs que formam nr colunas da etiqueta */
        "^PQ" STRING(1, "9999") SKIP  /* Quantidade de etiquetas a imprimir */
        
        "^FO45,20^BY3^A0N,20,Y,N^FD" "Pedido: " etiq1-pedido "^FS" SKIP
        "^FO45,45^BY3^A0N,20,Y,N^FD" "Deposito: " etiq1-dep "^FS" SKIP
        "^FO45,70^BY3^A0N,20,Y,N^FD" etiq1-seq  " Qtde: " etiq1-qtde "^FS" SKIP.

    IF  etiq1-localizacao-ast <> "" THEN
        PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " AST: " etiq1-localizacao-ast "^FS".
    ELSE
        IF  etiq1-localizacao-ALM <> "" THEN
            PUT "^FO45,95^BY3^A0N,20,Y,N^FD" " ALM: " etiq1-localizacao-ALM "^FS".

    PUT UNFORMATTED "^FS" SKIP.
    PUT UNFORMATTED "^FO25,120^BY2,3.0^BCN,40,N,N,N,N^FD"  etiq1-item "^FS".
    PUT UNFORMATTED "^FO25,165^A0N,20,20^FB245,1,0,C^FD" etiq1-item "^FS".

    PUT UNFORMATTED "^XZ".    

    OUTPUT CLOSE.
END PROCEDURE.
