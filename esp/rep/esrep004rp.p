/***********************************************************************
**  Programa..: ESP\REP\ESREP004RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Relatorio de Titulos por Referencia
**  Vers∆o....: 001 06/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP004 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esrep004tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

DEF VAR natureza LIKE nota-fiscal.nat-operacao.

def var l-sit          as log format "Atendido/Digitado"       NO-UNDO.
def var c-descricao    as char format "X(36)"                  NO-UNDO.
DEF VAR c-class-fiscal AS CHAR FORMAT "X(8)"                   NO-UNDO.
DEF VAR c-chave-bem    AS CHAR                                 NO-UNDO.
DEF VAR i-bem          LIKE it-ped-fiscal.nr-patrimonio NO-UNDO.
DEF VAR i-seq          LIKE bem_pat.num_seq_bem_pat            NO-UNDO.
DEF VAR c-conta        LIKE int_bem_pat_nf.cod_cta_pat         NO-UNDO.

/****************************  Temp-Tables  ****************************/

DEF TEMP-TABLE tt-resumo
    FIELD nr-nota-fis  LIKE ped-fiscal.nr-nota-fis
    field nr-pedido    like ped-fiscal.nr-pedido
    FIELD dt-emissao   LIKE ped-fiscal.dt-emissao
    field cod-emitente like emitente.cod-emitente
    field nome-abrev   like emitente.nome-abrev
    FIELD cod-estabel  LIKE ped-fiscal.cod-estabel
    field solicitante  as char
    FIELD canal-vendas LIKE ped-fiscal.canal-vendas
    FIELD descricao    LIKE canal-venda.descricao
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota 
    FIELD sc-codigo    LIKE ped-fiscal.sc-codigo
    FIELD ct-codigo    LIKE ped-fiscal.ct-codigo
    FIELD nat-oper     AS CHAR
    FIELD ge-codigo    LIKE ITEM.ge-codigo
    FIELD nf-ref       AS CHAR COLUMN-LABEL "NF Referenciada".

FORM it-ped-fiscal.it-codigo format "X(07)"
     c-descricao format "X(36)" label "Descriá∆o"
     it-ped-fiscal.qtde
     it-ped-fiscal.vl-unit
     it-ped-fiscal.cod-depos
     it-ped-fiscal.un
     it-ped-fiscal.aliquota-ipi 
     preco-item.preco-venda
     /*ITEM.class-fiscal*/
     c-class-fiscal FORMAT "X(8)" 
     it-ped-fiscal.peso-liq-item
     it-ped-fiscal.peso-bru-item
     i-bem   TO 155
     i-seq   TO 163
     c-conta AT 165
     ITEM.ge-codigo AT 184
     it-ped-fiscal.nf-referenciada FORMAT "X(50)"
     with  FRAME f-detalhe WIDTH 236 64 DOWN STREAM-IO NO-BOX.

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = SUBSTITUTE("Solicitaá∆o de Notas Fiscais-&1",
                        ENTRY(tt-param.situacao + 1, "Digitado,A Liberar,A Relacionar,A Faturar,Atendido Parcialmente,Atendido,Bloqueado"))
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESREP004"
       c-versao       = "2.04"
       c-revisao      = "001".

FUNCTION fn-nat RETURNS CHARACTER
    (INPUT c-nat AS INTEGER):

    FOR FIRST natureza-ped-fiscal FIELDS(descricao)
        WHERE natureza-ped-fiscal.natureza = c-nat NO-LOCK:

        RETURN STRING(c-nat,"99") + "-" + natureza-ped-fiscal.descricao.
    END.

    RETURN "".
END FUNCTION.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p persistent set h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    IF tt-param.tipo = 1 THEN DO:
        RUN piMontaRelatRes.
    END.
    ELSE DO:
        RUN piMontaRelat.
    END.


    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.





PROCEDURE piMontaRelat:
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    

    FOR EACH ped-fiscal NO-LOCK WHERE 
             ped-fiscal.cod-estabel    >= tt-param.estabel-ini   and
             ped-fiscal.cod-estabel    <= tt-param.estabel-fim   and
             ped-fiscal.dt-emissao     >= tt-param.ini-dt-pedido AND
             ped-fiscal.dt-emissao     <= tt-param.fim-dt-pedido AND
             ped-fiscal.nat-oper       >= tt-param.ini-nat-oper  AND
             ped-fiscal.nat-oper       <= tt-param.fim-nat-oper  AND
             ped-fiscal.usuario-magnus >= tt-param.ini-usuario   AND
             ped-fiscal.usuario-magnus <= tt-param.fim-usuario   AND
             ped-fiscal.situacao        = tt-param.situacao,  
        EACH it-ped-fiscal of ped-fiscal NO-LOCK,
        FIRST emitente NO-LOCK WHERE
              emitente.cod-emitente = ped-fiscal.cod-emitente,
        FIRST transporte NO-LOCK WHERE 
              transporte.cod-transp = ped-fiscal.cod-transp,
        FIRST item NO-LOCK WHERE 
              item.it-codigo = it-ped-fiscal.it-codigo BREAK BY ped-fiscal.nr-pedido:

        FIND canal-venda NO-LOCK
            WHERE canal-venda.cod-canal-venda = ped-fiscal.canal-vendas NO-ERROR.
        
              
        RUN pi-acompanhar IN h-acomp (INPUT ped-fiscal.nr-pedido).

        FIND FIRST nota-fiscal NO-LOCK                                 WHERE
                   nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                   nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                   nota-fiscal.serie       = ped-fiscal.serie                      AND
                   nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND
                   nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN 
           FIND FIRST nota-fiscal NO-LOCK                                 WHERE 
                      nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                      nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                      nota-fiscal.serie       = ped-fiscal.serie                       AND
                      nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND 
                      nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN 
           FIND FIRST nota-fiscal NO-LOCK                                 WHERE 
                      nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                      nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                      nota-fiscal.serie       = ped-fiscal.serie                       AND
                      nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND 
                      nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.        
/*         IF l-sit AND                  */
/*            NOT AVAIL nota-fiscal THEN */
/*            NEXT.                      */
        
        IF FIRST-OF(ped-fiscal.nr-pedido) THEN DO:
           PUT "" SKIP
               "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP.
           PUT "    Pedido: " ped-fiscal.nr-pedido
               "             Estab.: " ped-fiscal.cod-estabel
               "       Cliente: " ped-fiscal.cod-emitente " - " emitente.nome-abrev SKIP

               "Dt.Emiss∆o: " ped-fiscal.dt-emissao
               "  Transportadora: " ped-fiscal.cod-transp " - " transporte.nome-abrev
               "      Canal Vendas: " ped-fiscal.canal-vendas " - " IF AVAIL canal-venda THEN canal-venda.descricao ELSE '' SKIP
                
                "     Frete: " ped-fiscal.frete "                 Volume: " ped-fiscal.nr-volumes 
                "                          Natureza: " fn-nat(ped-fiscal.nat-oper) format "X(60)"
                " CC: " ped-fiscal.sc-codigo SKIP.

                
            IF AVAIL nota-fiscal THEN
                 PUT "Nota: " ped-fiscal.nr-nota-fis
                     " Emiss∆o Nota: " nota-fiscal.dt-emis-nota
                     " Nat. Operaá∆o: " nota-fiscal.nat-operacao skip.

            PUT "Observaá∆o: " ped-fiscal.observacao[1] format "X(76)" skip .
                
           IF ped-fiscal.observacao[2] <> "" THEN
              put ped-fiscal.observacao[2] skip.
           IF ped-fiscal.observacao[3] <> "" then
              put ped-fiscal.observacao[3] skip.
           IF ped-fiscal.observacao[4] <> "" then
              put ped-fiscal.observacao[4] skip.
           IF ped-fiscal.observacao[5] <> "" then
              put ped-fiscal.observacao[5] skip.              
           IF ped-fiscal.motivo <> "" THEN 
              PUT trim(ped-fiscal.motivo) SKIP.
           IF SUBSTRING(ped-fiscal.char-1,90,40) <> "" THEN 
               PUT "Receptor: " SUBSTRING(ped-fiscal.char-1,90,40) FORMAT "x(40)" SKIP.
           IF ped-fiscal.nat-oper = 25 THEN DO:
               PUT "  Destino : ".
           
               IF SUBSTRING(ped-fiscal.char-1,88,2) = "2" THEN
                   PUT "Produá∆o" SKIP.
               ELSE IF SUBSTRING(ped-fiscal.char-1,88,2) = "3" THEN
                    PUT "Revenda" SKIP.
                   ELSE IF SUBSTRING(ped-fiscal.char-1,88,2) = "4" THEN
                        PUT "Testes"  SKIP.
                       ELSE IF SUBSTRING(ped-fiscal.char-1,88,2) = "5" THEN
                            PUT "Consumo" SKIP.
                           ELSE IF SUBSTRING(ped-fiscal.char-1,88,2) = "6" THEN
                                PUT "Ativo Imobilizado" SKIP.
           END.
           IF SUBSTRING(ped-fiscal.char-1,150,500) <> "" THEN 
               PUT "Destino: " trim(SUBSTRING(ped-fiscal.char-1,150,500)) FORMAT "X(500)" SKIP.

           PUT "------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------------ -- -------" SKIP.
           PUT "Item    Descriá∆o                                   Qtde      Vl Unit Dep Un   IPI         Preáo CIF Class Fisc   Peso Liq.    Peso Bru       Nr.Patrimìnio     Seq Conta Patr         GE NF Ref." SKIP
               "------- ------------------------------------ ----------- ------------ -------- -- ----- ------------ ---------- ----------- ----------- ------------------- ------- ------------------ -- -------" SKIP.

        END.


        IF item.tipo-contr = 4 THEN
           ASSIGN c-descricao = it-ped-fiscal.narrativa.
        ELSE 
           ASSIGN c-descricao = item.descricao-1 + item.descricao-2.
           
        DISP it-ped-fiscal.it-codigo format "X(07)"
             c-descricao format "X(36)" NO-LABELS
             it-ped-fiscal.qtde
             it-ped-fiscal.vl-unit
             it-ped-fiscal.cod-depos
             it-ped-fiscal.un
             it-ped-fiscal.aliquota-ipi with  FRAME f-detalhe NO-LABELS.
             IF ped-fiscal.nat-oper <> 25 THEN
                IF ITEM.tipo-contr = 2 THEN DO:
                    IF ITEM.it-codigo BEGINS "4" THEN DO:
                        FOR EACH preco-item NO-LOCK
                            WHERE preco-item.it-codigo = ITEM.it-codigo
                              AND preco-item.nr-tabpre = "Minimo"
                              AND preco-item.situacao = 1
                              AND preco-item.dt-inival < TODAY,
                            FIRST tb-preco NO-LOCK
                            WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre
                              AND tb-preco.situacao = 1
                              AND tb-preco.dt-inival <= TODAY
                              AND tb-preco.dt-fimval >= TODAY
                            BREAK BY preco-item.preco-venda:
                            DISP preco-item.preco-venda 
                                with  FRAME f-detalhe NO-LABELS.
                            LEAVE.
                        END.
                    END.
                END.
                 
             /*-------------------Classificaá∆o Fiscal-----------------------------------------------*/ 
             IF SUBSTRING(it-ped-fiscal.char-1,11,8) = "" THEN DO:
                 DISP ITEM.class-fiscal @ c-class-fiscal WITH FRAME f-detalhe NO-LABELS.
             END.
             ELSE DISP SUBSTRING(it-ped-fiscal.char-1,11,8) @ c-class-fiscal WITH FRAME f-detalhe NO-LABELS.
             /*--------------------Peso Liquido------------------------------------------------------*/
             IF it-ped-fiscal.peso-liq-item = 0 THEN DO:
                 DISP item.peso-liquido @ it-ped-fiscal.peso-liq-item WITH FRAME f-detalhe NO-LABELS.
             END.
             ELSE DISP it-ped-fiscal.peso-liq-item WITH FRAME f-detalhe NO-LABELS.
             /*------------------------Peso Bruto----------------------------------------------------*/
             IF it-ped-fiscal.peso-bru-item = 0 THEN DO:
                 DISP item.peso-bruto @ it-ped-fiscal.peso-bru-item WITH FRAME f-detalhe NO-LABELS.
             END.
             ELSE DISP it-ped-fiscal.peso-bru-item WITH FRAME f-detalhe NO-LABELS.
             /*--------------------------------------------------------------------------------------*/
             /* andrey DISP it-ped-fiscal.nr-patrimonio WITH FRAME f-detalhe NO-LABELS. */

             ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35).
			 
			 IF NUM-ENTRIES(c-chave-bem,";") = 3 THEN 
				 ASSIGN c-conta = ENTRY(1,c-chave-bem,";")
						i-bem   = int(ENTRY(2,c-chave-bem,";"))
						i-seq   = int(ENTRY(3,c-chave-bem,";")).

             DISP i-bem 
                  i-seq
                  c-conta 
                  item.ge-codigo 
                  it-ped-fiscal.nf-referenciada WITH FRAME f-detalhe NO-LABELS.
             
             DOWN WITH FRAME f-detalhe NO-LABELS.
                
             IF  LAST-OF(ped-fiscal.nr-pedido) THEN
                 put " " skip.
    END.

END.


/* Relatorio resumido */
PROCEDURE piMontaRelatRes:
    DEFINE VARIABLE c-notas-ref AS CHARACTER   NO-UNDO.
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    FOR EACH ped-fiscal NO-LOCK WHERE 
             ped-fiscal.cod-estabel    >= tt-param.estabel-ini   and 
             ped-fiscal.cod-estabel    <= tt-param.estabel-fim   and 
             ped-fiscal.dt-emissao     >= tt-param.ini-dt-pedido AND
             ped-fiscal.dt-emissao     <= tt-param.fim-dt-pedido AND
             ped-fiscal.nat-oper       >= tt-param.ini-nat-oper  AND
             ped-fiscal.nat-oper       <= tt-param.fim-nat-oper  AND
             ped-fiscal.usuario-magnus >= tt-param.ini-usuario   AND
             ped-fiscal.usuario-magnus <= tt-param.fim-usuario   AND
             ped-fiscal.situacao        = tt-param.situacao,  
        EACH it-ped-fiscal of ped-fiscal NO-LOCK,
        FIRST emitente NO-LOCK WHERE
              emitente.cod-emitente = ped-fiscal.cod-emitente,
        FIRST transporte NO-LOCK WHERE 
              transporte.cod-transp = ped-fiscal.cod-transp,
        FIRST item NO-LOCK WHERE 
              item.it-codigo = it-ped-fiscal.it-codigo BREAK BY ped-fiscal.nr-pedido:

        FIND canal-venda NO-LOCK
            WHERE canal-venda.cod-canal-venda = ped-fiscal.canal-vendas NO-ERROR.

        
        RUN pi-acompanhar IN h-acomp (INPUT ped-fiscal.nr-pedido).

        FIND FIRST nota-fiscal NO-LOCK                                 WHERE
                   nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                   nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                   nota-fiscal.serie       = ped-fiscal.serie                      AND
                   nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND
                   nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN 
           FIND FIRST nota-fiscal NO-LOCK                                 WHERE 
                      nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                      nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                      nota-fiscal.serie       = ped-fiscal.serie                      AND
                      nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND 
                      nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN 
           FIND FIRST nota-fiscal NO-LOCK                                 WHERE 
                      nota-fiscal.cod-estabel = ped-fiscal.cod-estabel    AND
                      nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis    AND
                      nota-fiscal.serie       = ped-fiscal.serie                      AND
                      nota-fiscal.dt-emis-nota >= tt-param.ini-dt-emissao AND 
                      nota-fiscal.dt-emis-nota <= tt-param.fim-dt-emissao NO-ERROR.

           IF NOT AVAIL nota-fiscal THEN 
              ASSIGN natureza = "".             
           ELSE 
              ASSIGN natureza = nota-fiscal.nat-operacao.

        IF it-ped-fiscal.nf-referenciada <> "" THEN DO:
            IF c-notas-ref = "" THEN
                ASSIGN c-notas-ref = it-ped-fiscal.nf-referenciada.
            ELSE 
                ASSIGN c-notas-ref = c-notas-ref + "|" + it-ped-fiscal.nf-referenciada.
        END.

/*         IF l-sit AND                  */
/*            NOT AVAIL nota-fiscal THEN */
/*            NEXT.                      */
               
        IF FIRST-OF(ped-fiscal.nr-pedido) THEN DO:
           CREATE tt-resumo.
           ASSIGN tt-resumo.nr-nota-fis  = ped-fiscal.nr-nota-fis 
                  tt-resumo.dt-emissao   = ped-fiscal.dt-emissao     
                  tt-resumo.nat-oper     = fn-nat(ped-fiscal.nat-oper) /* format "X(20)" column-label "Natureza" when ped-fiscal.nat-oper <> 0 */
                  tt-resumo.nr-pedido    = ped-fiscal.nr-pedido    
                  tt-resumo.cod-estabel  = ped-fiscal.cod-estabel
                  tt-resumo.sc-codigo    = ped-fiscal.sc-codigo            
                  tt-resumo.ct-codigo    = ped-fiscal.ct-codigo
                  tt-resumo.nat-operacao = natureza
                  tt-resumo.canal-vendas = ped-fiscal.canal-vendas
                  tt-resumo.cod-emitente = ped-fiscal.cod-emitente
                  tt-resumo.nome-abrev   = emitente.nome-abrev
                  tt-resumo.solicitante  = ped-fiscal.observacao[1]
                  tt-resumo.descricao    = IF AVAIL canal-venda THEN canal-venda.descricao ELSE ''
                  tt-resumo.ge-codigo    = ITEM.ge-codigo
                  tt-resumo.nf-ref       = c-notas-ref.

            ASSIGN c-notas-ref = "".
        END.
    END.


    FOR EACH tt-resumo:
        
        DISP tt-resumo.nr-nota-fis   format "X(7)" COLUMN-LABEL "NF Faturada" 
             tt-resumo.cod-estabel   FORMAT "X(03)"   COLUMN-LABEL "Est"
             tt-resumo.nr-pedido     column-label "Pedido"
             tt-resumo.dt-emissao    COLUMN-LABEL "Dt.Emiss∆o"  
             tt-resumo.cod-emitente  COLUMN-LABEL "Emitente"                            
             tt-resumo.nome-abrev    COLUMN-LABEL "Nome   "                                    
             tt-resumo.nat-oper      format "X(20)" COLUMN-LABEL "Natureza Operaá∆o" /* when avail nota-fiscal */
             tt-resumo.canal-vendas  COLUMN-LABEL "Canal"
             tt-resumo.descricao     COLUMN-LABEL "Descriá∆o"   
             tt-resumo.sc-codigo     COLUMN-LABEL "CC"                                         
             tt-resumo.ge-codigo     COLUMN-LABEL "GE"
             tt-resumo.ct-codigo     COLUMN-LABEL "Conta" 
             tt-resumo.nat-operacao  COLUMN-LABEL "Natureza"  
             tt-resumo.solicitante  format "x(50)" column-label "Solicitante"
             tt-resumo.nf-ref
             with width 250 stream-io.  /*136 frame f-cab STREAM-IO NO-BOX. */
        
    END.



END.
