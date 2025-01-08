/***********************************************************************
**  Programa..: ESP\REP\ESREP005RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Erros das Notas Fiscais
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP006 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esrep006tt.i}
{esp/es0018.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR c-desc-grupo  AS CHAR .
DEF VAR c-segmento    AS CHAR .
DEF VAR h-acomp       AS HANDLE NO-UNDO.
DEF VAR i-nr-seq      AS INTEGER     NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa      NO-LOCK 
    WHERE empresa.ep-codigo = param-global.empresa-pri: 
END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Pis/Cofins - Devolu‡Æo"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESREP006"
       c-versao       = "2.04"
       c-revisao      = "001".

IF OPSYS = "UNIX":U THEN DO:
     EMPTY TEMP-TABLE tt-prog-ponto.
    
     RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                        INPUT 1,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).
     
     FOR FIRST tt-prog-ponto:
         ASSIGN tt-param.arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
     END. 
     
     ASSIGN tt-param.arquivo =  tt-param.arquivo + "/":U + c-seg-usuario + "/":U.
     OS-CREATE-DIR VALUE(tt-param.arquivo).
     ASSIGN tt-param.arquivo = tt-param.arquivo + "esrep006.csv".
END.

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    /*
    {include/i-rpcab.i}
    {include/i-rpout.i}
    */

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */

    OUTPUT TO VALUE(tt-param.arquivo) CONVERT TARGET SESSION:CHARSET.

    IF  tt-param.tipo = 1 THEN DO:
        RUN piMontaRelat. /* Devolu‡Æo */
    END.
    ELSE DO:
        RUN piMontaRelatOutras. /* Outras Entradas */
    END.

    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.
    /*
    {include/i-rpclo.i}
    */
    RETURN "OK".
END.




PROCEDURE piMontaRelat:
    DEFINE VARIABLE de-tot-despesas AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-despesas  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE vlr-fcp         AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-ipi       LIKE item-doc-est.valor-ipi[1]     NO-UNDO.
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    PUT UNFORMATTED "Data;Estab;Ser;Docto;Nat;For;Nome;Insc.Estad;NFS;Dt.emissao NFS;NOP;Familia;Item;Descricao;Quantidade;IPI;ICMS;Base Subst. Trib.;ICMS Subst;Desp.Aces;Vl. Mercad.;Total;Mot;P;%ICMS;CST ICMS;COFINS;PIS;Cidade;UF;ISS Retido;INSS Retido;Dep;Un Neg;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Seq Item RE;Contrib ICMS;Narrativa;Seq Item FT;Cod Repre;Nome Repre;Canal Venda;DCR Item;Grupo Cliente;Ser da Nota de origem;Dup;Nr. Ped Cliente;Atendente;Segmento;Canal Venda" SKIP.

    devol_block:
    FOR EACH docum-est USE-INDEX dt-tp-estab NO-LOCK           WHERE
             docum-est.dt-trans    >= tt-param.ini-data        AND 
             docum-est.dt-trans    <= tt-param.fim-data        AND
             docum-est.cod-estabel >= tt-param.cod-ini-estabel AND
             docum-est.cod-estabel <= tt-param.cod-fim-estabel AND
             docum-est.ce-atual /*somente documento j  atualizados*/ ,
        FIRST ext-natur-oper
        WHERE ext-natur-oper.nat-operacao = docum-est.nat-operacao
        AND   ext-natur-oper.tipo         = 1 /* Devolu‡Æo */ ,
        FIRST emitente NO-LOCK WHERE
             emitente.cod-emitente = docum-est.cod-emitente,
        EACH item-doc-est OF docum-est NO-LOCK,
        FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = item-doc-est.it-codigo:
        
        RUN pi-acompanhar IN h-acomp (INPUT docum-est.nro-docto).

        ASSIGN de-tot-despesas = docum-est.despesa-nota /* docum-est.valor-frete + docum-est.valor-seguro */
               de-vl-despesas  = item-doc-est.preco-total[1] / docum-est.valor-mercad * de-tot-despesas.
        FIND FIRST familia       OF ITEM NO-LOCK.
        FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.

        IF AVAIL int-docum-est THEN
            IF int-docum-est.cod-msg-devolucao < tt-param.cod-msg-devolucao-ini
            OR int-docum-est.cod-msg-devolucao > tt-param.cod-msg-devolucao-fim THEN
                 NEXT.

        ASSIGN vlr-fcp = 0.

        RELEASE it-nota-fisc.

        IF NOT docum-est.LOG-1 THEN
            ASSIGN i-nr-seq = item-doc-est.sequencia.
        ELSE DO: /*integrado faturamento*/
            FIND FIRST it-nota-fisc NO-LOCK
                 WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
                   AND it-nota-fisc.serie       = docum-est.serie-docto
                   AND it-nota-fisc.nr-nota-fis = docum-est.nro-docto
                   AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo
                   AND it-nota-fisc.nr-seq-ped  = item-doc-est.sequencia NO-ERROR.
            IF AVAIL it-nota-fisc THEN
                ASSIGN i-nr-seq = it-nota-fisc.nr-seq-fat.
        END.
        
        FOR EACH item-nf-adc NO-LOCK
           WHERE item-nf-adc.cod-estab        = docum-est.cod-estabel
             AND item-nf-adc.cod-serie        = docum-est.serie-docto
             AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
             AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
             AND item-nf-adc.cod-natur-operac = (if item-doc-est.nat-of <> "" then item-doc-est.nat-of else item-doc-est.nat-operacao)
             AND item-nf-adc.idi-tip-dado     = 25
             AND item-nf-adc.num-seq          = i-nr-seq:
             ASSIGN vlr-fcp = vlr-fcp + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30)).
        END.

        IF  vlr-fcp = ? THEN 
            ASSIGN vlr-fcp = 0.

        FIND FIRST item-doc-est-tribut NO-LOCK 
             WHERE item-doc-est-tribut.cod-serie-docto    = item-doc-est.serie-docto 
             AND   item-doc-est-tribut.cod-num-docto      = item-doc-est.nro-docto   
             AND   item-doc-est-tribut.cdn-emitente       = item-doc-est.cod-emitente    
             AND   item-doc-est-tribut.cod-natur-operac   = item-doc-est.nat-operacao
             AND   item-doc-est-tribut.num-seq            = item-doc-est.sequencia
             AND   item-doc-est-tribut.cod-campo          = "CST"
             AND   item-doc-est-tribut.nom-trib           = "ICMS" NO-ERROR.

        IF item-doc-est.cd-trib-ipi = 3 /* Outros */ THEN
           ASSIGN de-vl-ipi = 0.
        ELSE 
           ASSIGN de-vl-ipi = item-doc-est.valor-ipi[1].

        PUT  docum-est.dt-trans                                                     FORMAT "99/99/99"         ";"
             docum-est.cod-estabel                                                  FORMAT "x(3)"             ";"
             docum-est.serie-docto                                                  FORMAT "x(03)"            ";"
             item-doc-est.nro-docto                                                                           ";"
             item-doc-est.nat-of                                                                        ";"
             item-doc-est.cod-emitente                                                                        ";"
             emitente.nome-abrev                                                                              ";"
             emitente.ins-estadual                                                  FORMAT "x(19)"            ";"
             item-doc-est.nro-comp                                                  FORMAT "9999999"          ";" 
             item-doc-est.data-comp                                                 FORMAT "99/99/99"         ";"
             item-doc-est.nat-comp                                                                            ";"
             ITEM.fm-codigo                                                                                   ";"
             item-doc-est.it-codigo                                                 FORMAT "x(7)"             ";"
             ITEM.desc-item                                                         FORMAT "x(40)"            ";"
             item-doc-est.quantidade                                                                          ";"
             de-vl-ipi                                              FORMAT ">,>>>,>>9.99"     ";"
             item-doc-est.valor-icm[1]                                              FORMAT ">,>>>,>>9.99"     ";"
             item-doc-est.base-subs[1]                                              FORMAT ">>>>>,>>>,>>9.99" ";"
             (item-doc-est.vl-subs[1] + vlr-fcp)                                    FORMAT ">,>>>,>>9.99"     ";"
             de-vl-despesas                                                         FORMAT ">>,>>>,>>9.99"    ";"
             (item-doc-est.preco-total[1] - item-doc-est.desconto[1])               FORMAT ">>,>>>,>>9.99"    ";"
             (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
              de-vl-ipi + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas) FORMAT ">>,>>>,>>9.99"    ";"
             IF AVAIL int-docum-est THEN int-docum-est.cod-msg-devolucao ELSE 0     FORMAT "999"              ";"
             SUBSTRING(familia.fm-codigo,6,2)                                       FORMAT "X(02)"            ";"
             item-doc-est.aliquota-icm                                                                        ";" 
             IF AVAIL item-doc-est-tribut THEN "'" + item-doc-est-tribut.cod-conteudo + "'" ELSE "'00'" ";".

        IF NOT SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN 
           PUT (item-doc-est.val-cofins) FORMAT ">,>>>,>>9.99" ";"
               (item-doc-est.valor-pis)  FORMAT ">,>>>,>>9.99" ";".
        ELSE
            PUT "0;0;".

        PUT emitente.cidade FORMAT "X(10)"                                                                      ";"
            emitente.estado FORMAT "X(2)"                                                                       ";" .

        IF AVAIL it-nota-fisc THEN DO:
            PUT DECIMAL(TRIM(SUBSTRING(it-nota-fisc.char-2,218,14))) FORMAT ">,>>>,>>>,>>9.99" ";"
                it-nota-fisc.vl-ir-adic                              FORMAT ">,>>>,>>>,>>9.99" ";".
        END.
        ELSE DO:
            PUT "0;0;".
        END.

        IF AVAIL movto-estoq THEN DO:
            PUT movto-estoq.cod-depos + ";".
        END.
        ELSE DO:
            PUT ";".
        END.

        PUT item.cod-unid-negoc + ";".

        FIND FIRST item-nf-adc NO-LOCK
             WHERE item-nf-adc.cod-estab        = docum-est.cod-estabel
               AND item-nf-adc.cod-serie        = docum-est.serie-docto
               AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
               AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
               AND item-nf-adc.cod-natur-operac = (if item-doc-est.nat-of <> "" then item-doc-est.nat-of else item-doc-est.nat-operacao)
               AND item-nf-adc.idi-tip-dado     = 24
               AND item-nf-adc.num-seq          = i-nr-seq NO-ERROR.

        IF AVAIL item-nf-adc THEN DO:
           PUT item-nf-adc.cod-livre-4 + ";". /*Vl ICMS FCP*/
           PUT STRING(item-nf-adc.val-livre-3) + ";". /*Vl ICMS UF Dest*/ 
           PUT STRING(item-nf-adc.val-livre-4) + ";". /*Vl ICMS UF Remet*/ 
        END.
        ELSE DO:
           PUT "0;0;0;".
        END.

        PUT UNFORMATTED item-doc-est.sequencia ";".

        IF emitente.contrib-icms THEN 
           PUT UNFORMATTED "Sim;". 
        ELSE 
           PUT UNFORMATTED "NÆo;".

        PUT UNFORMAT replace(replace(STRING(item-doc-est.narrativa),CHR(13)," "),CHR(10)," ") ";".

/*         find FIRST it-nota-fisc                                                        */
/*              where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel                  */
/*                and it-nota-fisc.serie       = item-doc-est.serie-comp                  */
/*                and it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp                    */
/*                and it-nota-fisc.nr-seq-fat  = item-doc-est.seq-comp                    */
/*                and it-nota-fisc.it-codigo   = item-doc-est.it-codigo no-lock no-error. */
/*                                                                                        */
/*         IF AVAIL it-nota-fisc THEN DO:                                                 */
            PUT UNFORMAT item-doc-est.seq-comp ";".
/*         END.         */
/*         ELSE DO:     */
/*             PUT ";". */
/*         END.         */

        FIND FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.nr-nota-fis = item-doc-est.nro-comp  
              AND nota-fiscal.serie       = item-doc-est.serie-comp
              AND nota-fiscal.cod-estabel = docum-est.cod-estabel.

        FIND FIRST ped-venda WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli 
                               AND ped-venda.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        
        FIND fam-comerc WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com NO-LOCK NO-ERROR.

        FIND FIRST fam-com-item NO-LOCK
             WHERE fam-com-item.unidade  = SUBSTRING(item.fm-cod-com,1,2)
               AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
               AND fam-com-item.familia1 = "" NO-ERROR.
           IF  AVAIL fam-com-item THEN 
              ASSIGN c-segmento = fam-com-item.descricao .

        PUT UNFORMAT nota-fiscal.cod-rep         ";"
                     nota-fiscal.no-ab-reppri    ";"
                     nota-fiscal.cod-canal-venda ";". 


        PUT UNFORMATTED ITEM.cod-dcr-item ";".
        
        //adicionando coluna Grupo de cliente
        FOR FIRST gr-cli                                          
            WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK:
            
            PUT UNFORMATTED gr-cli.descricao ";".
        END.

        //IDBA Bruno 
        PUT UNFORMAT nota-fiscal.serie                                    ";"
                     nota-fiscal.emite-duplic                             ";"
                     nota-fiscal.nr-pedcli                                ";"
                     IF AVAIL ped-venda THEN ped-venda.tp-pedido ELSE "0" ";" //Atendente
                     c-segmento                                           ";"
                     nota-fiscal.cod-canal-venda                          ";" .
        PUT SKIP.
    END.
END.

PROCEDURE piMontaRelatOutras:

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    PUT UNFORMATTED "Data;Estab;Docto;Nat;For;Nome;Insc.Estad;NFS;Dt.emissÆo NFS;NOP;Familia;Item;Descricao;Quantidade;IPI;ICMS;Base Subst. Trib.;ICMS Subst;Vl. Mercad.;Total;Mot;P;%ICMS;CST ICMS;COFINS;PIS;Cidade;UF;ISS Retido;INSS Retido;Dep;Un Neg;Cod Repre;Nome Repre;Canal Venda;Grupo Cliente" SKIP.

    oe_block:
    FOR EACH docum-est USE-INDEX dt-tp-estab NO-LOCK                               
       WHERE docum-est.dt-trans    >= tt-param.ini-data           
         AND docum-est.dt-trans    <= tt-param.fim-data 
         AND docum-est.cod-estabel >= tt-param.cod-ini-estabel 
         AND docum-est.cod-estabel <= tt-param.cod-fim-estabel, 
       FIRST ext-natur-oper
       WHERE ext-natur-oper.nat-operacao = docum-est.nat-operacao
       AND   ext-natur-oper.tipo         = 2 /* Outras Entradas */ ,
        EACH emitente NO-LOCK WHERE
             emitente.cod-emitente = docum-est.cod-emitente,
        EACH item-doc-est OF docum-est NO-LOCK,
        FIRST ITEM NO-LOCK WHERE 
              ITEM.it-codigo = item-doc-est.it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT docum-est.nro-docto).

        FIND FIRST familia       OF ITEM NO-LOCK.
        FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.

        IF AVAIL int-docum-est THEN
            IF int-docum-est.cod-msg-devolucao < tt-param.cod-msg-devolucao-ini
            OR int-docum-est.cod-msg-devolucao > tt-param.cod-msg-devolucao-fim THEN
                 NEXT.

        FIND FIRST item-doc-est-tribut NO-LOCK 
             WHERE item-doc-est-tribut.cod-serie-docto    = item-doc-est.serie-docto 
             AND   item-doc-est-tribut.cod-num-docto      = item-doc-est.nro-docto   
             AND   item-doc-est-tribut.cdn-emitente       = item-doc-est.cod-emitente    
             AND   item-doc-est-tribut.cod-natur-operac   = item-doc-est.nat-operacao
             AND   item-doc-est-tribut.num-seq            = item-doc-est.sequencia
             AND   item-doc-est-tribut.cod-campo          = "CST"
             AND   item-doc-est-tribut.nom-trib           = "ICMS" NO-ERROR.

        PUT  docum-est.dt-trans             FORMAT "99/99/99"                                           ";"
             docum-est.cod-estabel          FORMAT "x(3)"                                               ";"
             item-doc-est.nro-docto                                                                     ";"
             item-doc-est.nat-of                                                                        ";"
             item-doc-est.cod-emitente                                                                  ";"
             emitente.nome-abrev                                                                        ";"
             emitente.ins-estadual          FORMAT "x(19)"                                              ";"
             item-doc-est.nro-comp          FORMAT "9999999"                                            ";"
             item-doc-est.data-comp         FORMAT "99/99/99"                                           ";"
             item-doc-est.nat-comp                                                                      ";"
             ITEM.fm-codigo                                                                             ";"
             item-doc-est.it-codigo         FORMAT "x(7)"                                               ";"
             ITEM.desc-item                 FORMAT "x(40)"                                              ";"
             item-doc-est.quantidade                                                                    ";"
             item-doc-est.valor-ipi[1]      FORMAT ">,>>>,>>9.99"                                       ";"
             item-doc-est.valor-icm[1]      FORMAT ">,>>>,>>9.99"                                       ";"
             item-doc-est.base-subs[1]      FORMAT ">>>>>,>>>,>>9.99"                                   ";"
             item-doc-est.vl-subs[1]        FORMAT ">,>>>,>>9.99"                                       ";"
            (item-doc-est.preco-total[1] - item-doc-est.desconto[1])             FORMAT ">>,>>>,>>9.99" ";"
            (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
             item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1])                FORMAT ">>,>>>,>>9.99" ";"
             IF AVAIL int-docum-est THEN int-docum-est.cod-msg-devolucao ELSE 0  FORMAT "999"           ";"
             SUBSTRING(familia.fm-codigo,6,2)                                    FORMAT "X(02)"         ";" 
             item-doc-est.aliquota-icm                                                                  ";"
             IF AVAIL item-doc-est-tribut THEN "'" + item-doc-est-tribut.cod-conteudo + "'" ELSE "'00'"               ";".

        IF NOT SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN 
           PUT (item-doc-est.val-cofins) FORMAT ">,>>>,>>9.99"  ";"
               (item-doc-est.valor-pis)    FORMAT ">,>>>,>>9.99" ";".
        ELSE
           PUT "0;0;".

        PUT emitente.cidade FORMAT "X(10)"                                                                      ";"
            emitente.estado FORMAT "X(2)"                                                                       ";".

        FOR FIRST it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
              AND it-nota-fisc.serie       = item-doc-est.serie-comp
              AND it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp
              AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo:
            PUT DECIMAL(TRIM(SUBSTRING(it-nota-fisc.char-2,218,14))) FORMAT ">,>>>,>>>,>>9.99" ";"
                it-nota-fisc.vl-ir-adic                              FORMAT ">,>>>,>>>,>>9.99" ";".
        END.

        FOR EACH nota-fiscal
            WHERE nota-fiscal.nr-nota-fis = item-doc-est.nro-comp  
              AND nota-fiscal.serie       = item-doc-est.serie-comp
              AND nota-fiscal.cod-estabel = docum-est.cod-estabel:

              PUT UNFORMAT nota-fiscal.cod-rep ";"
                           nota-fiscal.no-ab-reppri ";"
                           nota-fiscal.cod-canal-venda ";". 

         END.
         
         //adicionando coluna Grupo de cliente
         FOR FIRST gr-cli                                          
             WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK:
                                                                   
             PUT UNFORMATTED gr-cli.descricao ";".                 
         END.                                                      

        PUT SKIP.
    END.
END.
