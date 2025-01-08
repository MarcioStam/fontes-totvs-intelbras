/***********************************************************************
**  Programa..: ESP\REP\EScdp049RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2012 - Desenvolvimento
**  Descricao.: NF de Saida - mp563
**  Vers∆o....: 001 18/072012
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escdp049 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cdp/escdp049tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */
    
/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.
CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
DEFINE VARIABLE c-descricao LIKE ITEM.desc-item.
DEFINE VARIABLE b-narrativa AS CHAR.


DEF VAR h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Itens Faturaveis"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "Escdp049"
       c-versao       = "2.04"
       c-revisao      = "000".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i} */
/*     {include/i-rpout.i} */
    IF OPSYS = "unix" THEN
        OUTPUT TO value(c-dir-arquivo-session + trim(tt-param.usuario) +  "/escdp049.tmp").
    ELSE
        OUTPUT TO value(session:temp-directory + "escdp049.tmp").


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

/*     if tt-param.excel = no then do: */
/*        VIEW FRAME f-cabec.          */
/*        VIEW FRAME f-rodape.         */
/*     end.                            */

    RUN piMontaRelat-1.

    RUN pi-finalizar in h-acomp.
    OUTPUT CLOSE.

    
/*     MESSAGE "O Arquivo gerado encontra-se em : "  session:temp-directory + "escdp049.tmp" VIEW-AS ALERT-BOX. */

/*     {include/i-rpclo.i} */
    RETURN "OK".
END.



PROCEDURE piMontaRelat-1:
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    IF tt-param.narrativa = YES THEN
        PUT "Item;Descricao;Narrativa;NCM;Familia;Faturavel;Lei Informatica;Familia Comercial;Origem;Uni.Neg;Dt.Implant;IPI Item;IPI NCM;Sit. Obsolescencia" SKIP.

    ELSE
        PUT "ITEM;Descricao;NCM;Familia;Faturavel;Lei Informatica;Familia Comercial;Origem;Uni.Neg;Dt.Implant;IPI Item;IPI NCM;Sit. Obsolescencia" SKIP.

    FOR EACH ITEM
        WHERE ITEM.it-codigo  >= tt-param.ini-it-codigo
          AND ITEM.it-codigo  <= tt-param.fim-it-codigo
          AND ITEM.fm-codigo  >= tt-param.fm-codigo-ini
          AND ITEM.fm-codigo  <= tt-param.fm-codigo-fim
          AND ITEM.fm-cod-com >= tt-param.familia-cod-ini
          AND ITEM.fm-cod-com <= tt-param.familia-cod-fim
          AND ITEM.class-fiscal >= tt-param.classi-fiscal-ini
          AND ITEM.class-fiscal <= tt-param.classi-fiscal-fim NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Item " + ITEM.it-codigo).

        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.

        ASSIGN b-narrativa = ITEM.narrativa.
        
        IF tt-param.lei-informatica = 2 
        AND AVAIL int-portaria-movto THEN NEXT.
        ELSE
            IF tt-param.lei-informatica = 1 
            AND NOT AVAIL int-portaria-movto THEN NEXT.

        IF tt-param.faturavel = 1 AND ITEM.ind-item-fat = NO THEN NEXT.
        ELSE
            IF tt-param.faturavel = 2 AND ITEM.ind-item-fat = YES THEN NEXT.
        

        PUT ITEM.it-codigo ";".

        RUN pi-narrativa-item (INPUT "101",
                               ITEM.it-codigo,
                               OUTPUT c-descricao).

        PUT ITEM.desc-item ";".

        IF tt-param.narrativa = YES THEN
        PUT c-descricao ";".

        
        PUT ITEM.class-fiscal ";"
            ITEM.fm-codigo    ";"
            ITEM.ind-item-fat ";".
        
        IF AVAILABLE int-portaria-movto THEN
            PUT "Sim;".
        ELSE
            PUT "Nao;".
        
        FIND classif-fisc
            WHERE classif-fisc.class-fiscal = ITEM.class-fiscal
            NO-LOCK NO-ERROR.

        PUT ITEM.fm-cod-com   ";"
            ITEM.codigo-orig  ";"
            ITEM.cod-unid-neg ";"
            ITEM.data-implant ";"
            ITEM.aliquota-ipi ";".
        IF AVAIL classif-fisc THEN
            PUT classif-fisc.aliquota-ipi ";".
        ELSE
            PUT "" ";".

        PUT UNFORMATTED TRIM({ininc/i17in172.i 04 ITEM.cod-obsoleto}) SKIP.
    END.
    
END.

PROCEDURE pi-narrativa-item:
    DEF INPUT PARAMETER  c-cod-estabel LIKE estabelec.cod-estabel.
    DEF INPUT PARAMETER  c-item        LIKE ITEM.it-codigo.
    DEF OUTPUT PARAMETER c-desc-prod  AS CHARACTER.

    DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.

    /*---------------------------------------------------------------------------------+
     | Valores poss≠veis para o campos item.ind-imp-desc - Forma de Descri?o do Item: |
     |  1 - Descri?o                                                                  |
     |  2 - Descri?o + Narrativa do Item                                              |
     |  3 - Descri?o + Narrativa do Item X Cliente                                    |
     |  4 - Descri?o + Narrativa Informada                                            |
     |  5 - Narrativa do Item                                                          |
     |  6 - Uma Linha da Narrativa do Item                                             |
     |  7 - Narrativa Informada                                                        |
     |  8 - Descri?o + 24 Caracteres da Narrativa do Item X Cliente                   |
     |  9 - Descri?o + 24 Caracteres da Narrativa Informada                           | 
     | 10 - Descri?o + 24 Caracteres da Narrativa do Item                             |
     +---------------------------------------------------------------------------------*/


    /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
              
    if item.ind-imp-desc = 1 then /* Descri?o */
        assign c-desc-prod = item.desc-item.
    
    if  item.ind-imp-desc = 2           /* Descri?o + Narrativa */
    or  item.ind-imp-desc = 5           /* Narrativa Item */
    or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
    or  item.ind-imp-desc = 10 then do: /* Descri?o + 24 Narrativa Item */
    
        if  item.ind-imp-desc = 2
        or  item.ind-imp-desc = 10 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find narrativa of item no-lock no-error.
    
        if avail narrativa then DO:
            IF INDEX(narrativa.descricao,"#MANAUS#") <> 0 THEN DO:
                RUN esp/es0204.p (INPUT c-cod-estabel,
                                  INPUT c-item,
                                  OUTPUT c-narrativa).
            END.
            ELSE
                ASSIGN c-narrativa = narrativa.descricao.

            assign c-desc-prod = c-desc-prod +
                                 if  item.ind-imp-desc = 6 then
                                     trim(entry(1,substring(c-narrativa,1,76),chr(10)))
                                 else if item.ind-imp-desc = 10 then
                                     trim(entry(1,substring(c-narrativa,1,24),chr(10)))
                                 else                        
                                     c-narrativa.

        END.
    end.
    
    if  item.ind-imp-desc = 3          /* Descri?o + Narrativa Item/Cliente */
    or  item.ind-imp-desc = 8 then do: /* Descri?o + 24 Narrativa Item/Cliente */
        find item-cli
             where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
             and   item-cli.it-codigo  = it-nota-fisc.it-codigo
             no-lock no-error.
    
        assign c-desc-prod = item.desc-item + " ".
    
        if  avail item-cli then
            assign c-desc-prod = c-desc-prod +
                                 if item.ind-imp-desc = 3 then          
                                    item-cli.narrativa
                                 else
                                    trim(entry(1,substring(item-cli.narrativa,1,24),chr(10))).
    end.
    
    if  item.ind-imp-desc = 4            /* Descri?o + Narrativa Informada */
    or  item.ind-imp-desc = 7            /* Narrativa Informada */
    or  item.ind-imp-desc = 9 then do:   /* Descri?o + 24 Narrativa Informada */
    
        if  item.ind-imp-desc = 4
        or  item.ind-imp-desc = 9 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = item.desc-item + "".
    
   
    end.

END PROCEDURE.
