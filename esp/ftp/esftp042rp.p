/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp042RP 2.03.00.009}  /*** 010009 ***/
/******************************************************************************
**   Programa: esftp042rp.p
**   Data....: 28/02/08
**   Autor...: Anderson Cenci
**   Objetivo: Gera Arquivo XML para PIN
******************************************************************************/
{include/i_fnctrad.i}
{utp/ut-glob.i}
{include/tt-edit.i}
{include/pi-edit.i}

/* Definiá∆o Temp-tables para Recebimento de ParÉmetros */



/* Definiá∆o Vari†veis */
DEF VAR h-acomp          AS HANDLE    NO-UNDO.
DEF VAR c-dir-nome-arq   AS CHARACTER NO-UNDO.
DEF VAR c-barras         AS CHARACTER NO-UNDO.
DEF VAR c-lote           AS CHARACTER NO-UNDO.
DEF VAR i-count-nf       AS INTEGER   NO-UNDO.
DEF VAR num-max-notas    AS INTEGER   NO-UNDO.
DEF VAR c-lst-nome-arq   AS CHARACTER NO-UNDO.
DEF VAR c-cnpj-transp    AS CHARACTER NO-UNDO.
DEF VAR c-insc-transp    AS CHARACTER NO-UNDO.
def var c-cod-suframa    as char      no-undo.
DEF VAR c-diretorio-origem  AS CHARACTER NO-UNDO.
DEF STREAM s-exporta.
{esp/es0018.i}

/* Definiá∆o Temp-table's */
{method/dbotterr.i}                /* Definiá∆o Temp-table rowErrors */
{utp/utapi019.i}                   /* Include API CORREIO ELETRONICO */

DEFINE INPUT PARAMETER c-cod-estabel as char NO-UNDO.
DEFINE INPUT PARAMETER c-serie       as char NO-UNDO.
DEFINE INPUT PARAMETER c-nr-nota-fis as char NO-UNDO.

{esp/ftp/esftp042.i1} /* Procedures */.
def new global shared var i-num-ped-exec-rpw as int no-undo.


   ASSIGN c-barras = "~/".


ASSIGN i-count-nf = 0.

    

for FIRST nota-fiscal NO-LOCK
    WHERE nota-fiscal.cod-estabel = c-cod-estabel
      AND nota-fiscal.serie       = c-serie
      AND nota-fiscal.nr-nota-fis = c-nr-nota-fis:

    ASSIGN i-count-nf = i-count-nf + 1.

    FIND FIRST emitente NO-LOCK 
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR. 
    IF estabelec.estado = "AM" AND
       emitente.estado = "AM" THEN NEXT.
    
    ASSIGN c-lote = STRING(NEXT-VALUE(seq_lote_pin))
           c-lote = c-lote + STRING(YEAR(TODAY), "9999") 
           i-count-nf = 1.
/*     FIND FIRST NFE no-lock                                         */
/*         WHERE NFE.cod-estabel = nota-fiscal.cod-estabel            */
/*           AND NFE.serie       = nota-fiscal.serie                  */
/*           AND NFE.nr-nota-fis = nota-fiscal.nr-nota-fis  NO-ERROR. */
/*     IF AVAIL nfe THEN DO:                                          */
        RUN pi-cria-xml-nfe (INPUT nota-fiscal.nr-nota-fis, INPUT c-lote).
/*     END.                                                               */
/*     ELSE DO:                                                           */
/*         RUN pi-cria-xml (INPUT nota-fiscal.nr-nota-fis, INPUT c-lote). */
/*                                                                        */
/*         RUN pi-imprime-notas.                                          */
/*                                                                        */
/*         /* Encerra arquivo xml */                                      */
/*         PUT STREAM s-exporta UNFORMATTED                               */
/*             "</notasFiscais>" CHR(10)                                  */
/*             "</lote>"         CHR(10).                                 */
/*     END.                                                               */

    OUTPUT STREAM s-exporta CLOSE.
    RUN enviaE-mail.
END.

return 'ok'.   


PROCEDURE pi-cria-xml-nfe:
    DEF INPUT PARAM p-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    DEF INPUT PARAM p-nr-lote     AS CHARACTER NO-UNDO.
    DEF VAR i-qtd-nf-lote AS INTEGER NO-UNDO.
    ASSIGN c-dir-nome-arq = session:temp-directory + c-barras + "LotNF" + STRING(INT(p-nr-lote), "9999999999")  + ".SIN"
           c-lst-nome-arq = c-lst-nome-arq + "," + c-dir-nome-arq.
           
    OUTPUT STREAM s-exporta TO VALUE(c-dir-nome-arq) NO-CONVERT. /* Abre arquivo texto */    

    ASSIGN i-qtd-nf-lote = 1.
    if (nota-fiscal.cod-estabel = "301" OR
        nota-fiscal.cod-estabel = "103") and
        nota-fiscal.nome-tr-red <> "" then
        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = nota-fiscal.nome-tr-red NO-ERROR.
    else
        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
 
    IF transporte.nome-abrev = "Sedex" OR
       transporte.nome-abrev = "Malote" THEN
        ASSIGN c-cnpj-transp = emitente.cgc
               c-insc-transp = emitente.ins-estadual.                                 
    ELSE
        ASSIGN c-cnpj-transp = transporte.cgc
               c-insc-transp = transporte.ins-estadual.                                 

    assign c-cod-suframa = replace(emitente.cod-suframa,".","")
           c-cod-suframa = replace(c-cod-suframa,",","")
           c-cod-suframa = replace(c-cod-suframa,"/","")           
           c-cod-suframa = replace(c-cod-suframa,"~\","")                      
           c-cod-suframa = replace(c-cod-suframa,";","")
           c-cod-suframa = replace(c-cod-suframa,"-","")           .

/*     FOR FIRST NFE EXCLUSIVE-LOCK                         */
/*         WHERE NFE.cod-estabel = nota-fiscal.cod-estabel  */
/*           AND NFE.serie       = nota-fiscal.serie        */
/*           AND NFE.nr-nota-fis = nota-fiscal.nr-nota-fis. */
/*     END.                                                 */

    PUT STREAM s-exporta UNFORMATTED
        "<?xml version='1.0' encoding='utf-8' ?>" CHR(10)
        "<lote nro='" TRIM(p-nr-lote) "' versao_sw='6.0' dtEmissao='" STRING(today, "99/99/9999") "'" CHR(10)
        "xmlns='http://www.portal.fucapi.br' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.portal.fucapi.br http://alvaraes.suframa.gov.br:7778/PMNRecEViewController/jsp/importardados/NFe.xsd'  >" CHR(10)
        "<cnpjDestinatario>"    STRING(nota-fiscal.cgc, "X(14)")   "</cnpjDestinatario>"     CHR(10)
        "<cnpjTransp>"          STRING(c-cnpj-transp,  "X(14)")               "</cnpjTransp>" CHR(10)
        "<inscSufDestinatario>" STRING(c-cod-suframa, "X(9)") "</inscSufDestinatario>" CHR(10)
        "<ufDestino>"           STRING(nota-fiscal.estado, "X(2)")             "</ufDestino>" CHR(10)
        "<ufOrigem>"            STRING(estabelec.estado, "X(2)")                "</ufOrigem>" CHR(10)
        "<qtdeNF>"              STRING(i-qtd-nf-lote)                             "</qtdeNF>" CHR(10)
        "<notasFiscais>"                                                                                    CHR(10)
        "<notaFiscal chaveAcesso='" nota-fiscal.cod-chave-aces-nf-eletro FORMAT "x(44)" "' txZero='false' >" CHR(10)
        "</notaFiscal>" CHR(10)
        "</notasFiscais>" CHR(10)
        "</lote> " CHR(10).
END PROCEDURE.

PROCEDURE pi-cria-xml:
    
    DEF INPUT PARAM p-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    DEF INPUT PARAM p-nr-lote     AS CHARACTER NO-UNDO.

    DEF VAR i-qtd-nf-lote AS INTEGER NO-UNDO.
/*
    OS-CREATE-DIR VALUE(c-dir-spool-servid-exec).
*/    
    ASSIGN c-dir-nome-arq = session:temp-directory + c-barras + "LotNF" + STRING(INT(p-nr-lote), "999999999")  + ".SIN"
           c-lst-nome-arq = c-lst-nome-arq + "," + c-dir-nome-arq.
           
       
           
    OUTPUT STREAM s-exporta TO VALUE(c-dir-nome-arq) NO-CONVERT. /* Abre arquivo texto */    

    /* Quantidade de notas existentes no arquivo XML */
    ASSIGN i-qtd-nf-lote = 1.
    if (nota-fiscal.cod-estabel = "301" or
        nota-fiscal.cod-estabel = "103") and
       nota-fiscal.nome-tr-red <> "" then
        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = nota-fiscal.nome-tr-red NO-ERROR.
    else
        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
 
    IF transporte.nome-abrev = "Sedex" OR
       transporte.nome-abrev = "Malote" THEN
        ASSIGN c-cnpj-transp = emitente.cgc
               c-insc-transp = emitente.ins-estadual.                                 
    ELSE
        ASSIGN c-cnpj-transp = transporte.cgc
               c-insc-transp = transporte.ins-estadual.                                 

    assign c-cod-suframa = replace(emitente.cod-suframa,".","")
           c-cod-suframa = replace(c-cod-suframa,",","")
           c-cod-suframa = replace(c-cod-suframa,"/","")           
           c-cod-suframa = replace(c-cod-suframa,"~\","")                      
           c-cod-suframa = replace(c-cod-suframa,";","")
           c-cod-suframa = replace(c-cod-suframa,"-","")           .

    
    PUT STREAM s-exporta UNFORMATTED
        "<?xml version='1.0' encoding='utf-8' ?>" CHR(10)
        "<lote nro='" TRIM(p-nr-lote) "' versao_sw='" "6.0" "' dtEmissao='" STRING(today, "99/99/9999")
        "' xmlns='http://www.portal.fucapi.br' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'"
        " xsi:schemaLocation='http://www.portal.fucapi.br http://alvaraes.suframa.gov.br:7778/PMNRecEViewController/jsp/importardados/NF.xsd'  >" CHR(10)
        "<cnpjDestinatario>"    STRING(nota-fiscal.cgc, "X(14)")        "</cnpjDestinatario>" CHR(10)
        "<cnpjTransp>"          STRING(c-cnpj-transp,  "X(14)")               "</cnpjTransp>" CHR(10)
        "<inscSufDestinatario>" STRING(c-cod-suframa, "X(9)") "</inscSufDestinatario>" CHR(10)
        "<ufDestino>"           STRING(nota-fiscal.estado, "X(2)")             "</ufDestino>" CHR(10)
        "<ufOrigem>"            STRING(estabelec.estado, "X(2)")                "</ufOrigem>" CHR(10)
        "<qtdeNF>"              STRING(i-qtd-nf-lote)                             "</qtdeNF>" CHR(10)
        "<notasFiscais>" CHR(10).
    
  
END PROCEDURE.

PROCEDURE pi-imprime-notas:

    DEF VAR c-tx-zero                   AS CHARACTER           NO-UNDO.
    DEF VAR i-trib-icms                 AS INTEGER             NO-UNDO.
    DEF VAR i-trib-ipi                  AS INTEGER             NO-UNDO.
    DEF VAR de-vl-base-icms             AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-icms                  AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-frete                AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-totipi                AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-outras-desp          AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-tot-itens             AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-tot-nf                AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-total-pis-por-unidade AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-taxa-pis                 AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-pis                  AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-tot-pis              AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-cofins               AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-val-tot-cofins           AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-gnre                  AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-base-icms-st          AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-icms-st               AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-vl-icms-abat             AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR i-ft-conta                  AS INTEGER             NO-UNDO.
    DEF VAR c-especie                   AS CHARACTER           NO-UNDO.
    DEF VAR c-dt-saida                  AS CHARACTER           NO-UNDO.
    DEF VAR de-vl-merc-liq              AS DECIMAL   INITIAL 0 NO-UNDO.
    DEF VAR de-diferenca                AS DECIMAL   INITIAL 0 NO-UNDO.
    
                           
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

    ASSIGN c-tx-zero  =  "false".
           c-dt-saida = IF nota-fiscal.dt-saida <> ? THEN 
                            STRING(nota-fiscal.dt-saida, "99/99/9999") 
                        ELSE "".    
    
    PUT STREAM s-exporta UNFORMATTED
        "<notaFiscal nro='" nota-fiscal.nr-nota-fis "' dtEmissao='" STRING(nota-fiscal.dt-emis-nota, "99/99/9999")"' txZero='" c-tx-zero "' incent='0' >" CHR(10)
        "<cnpjRemetente>"       STRING(estabelec.cgc, "X(14)")                                "</cnpjRemetente>" CHR(10)
        "<CFOP>"                STRING(natur-oper.cod-cfop)                                  "</CFOP>" CHR(10)
        "<modelo>"              STRING(natur-oper.cd-situacao)                                       "</modelo>" CHR(10) 
        "<serie>"               nota-fiscal.serie                                                     "</serie>" CHR(10)
        "<inscEstDestinatario>" REPLACE(REPLACE(emitente.ins-estadual, "-",""),".","")  "</inscEstDestinatario>" CHR(10)
        "<dtSaidaNF>"           c-dt-saida                                                        "</dtSaidaNF>" CHR(10)
        "<hrSaidaNF>12:00</hrSaidaNF>"                                                                           CHR(10)
        "<optDebito>"           "2"                             "</optDebito>" CHR(10) /* Transportador */
        "<ddAdicionais>ICMS ISENTO</ddAdicionais>" CHR(10).

    /* Calcula BaseCalcICMS, ValICMS, ValTotIPI, ValOutrasDesp, ValGNRE, baseCalcICMSSubTrib */
    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:

         ASSIGN de-vl-base-icms    = de-vl-base-icms    + it-nota-fisc.vl-bicms-it 
                de-vl-gnre         = de-vl-gnre         + it-nota-fisc.vl-icmsub-it
                de-vl-base-icms-st = de-vl-base-icms-st + it-nota-fisc.vl-bsubs-it 
                de-vl-icms-st      = de-vl-icms-st      + it-nota-fisc.vl-icmsub-it
                i-trib-icms        = IF it-nota-fisc.cd-trib-icm = 4 THEN 1
                                     ELSE IF it-nota-fisc.cd-trib-icm  = 1 AND
                                             it-nota-fisc.aliquota-icm = 0 THEN 3
                                          ELSE it-nota-fisc.cd-trib-icm
                i-trib-ipi         = IF it-nota-fisc.cd-trib-ipi = 4   AND 
                                        natur-oper.perc-red-ipi  = 100 THEN 3
                                     ELSE IF it-nota-fisc.cd-trib-ipi = 4 then 1
                                          ELSE it-nota-fisc.cd-trib-ipi.

/*         /* ValTotItens*/                                                              */
/*         IF  it-nota-fisc.vl-merc-liq-zfm > 0 THEN                                     */
/*              ASSIGN de-vl-tot-itens = de-vl-tot-itens + it-nota-fisc.vl-merc-liq-zfm. */
/*         ELSE                                                                          */
/*              ASSIGN de-vl-tot-itens  = de-vl-tot-itens  + it-nota-fisc.vl-tot-item.   */
        
        IF i-trib-icms = 1 THEN /* ICMS Tributado */
             ASSIGN de-vl-icms = de-vl-icms + it-nota-fisc.vl-icms-it.
         
         IF i-trib-ipi = 1 THEN /* IPI Tributado */
             ASSIGN de-vl-totipi = de-vl-totipi + it-nota-fisc.vl-ipi-it.

         ASSIGN de-val-outras-desp = de-val-outras-desp + it-nota-fisc.vl-despes-it.
    END.    

    ASSIGN de-vl-tot-itens = nota-fiscal.vl-tot-nota.

    /* ValAbatICMS */
     IF natur-oper.per-des-icms > 0 THEN   /*ICMS*/
         ASSIGN de-vl-icms-abat = ROUND((de-vl-tot-itens * natur-oper.per-des-icms / 100),2).
     
     /*ValTotNF*/
     ASSIGN de-vl-tot-nf = de-vl-tot-itens - de-vl-icms-abat.   

     ASSIGN de-diferenca =  nota-fiscal.vl-mercad - de-vl-tot-nf.  

     IF de-diferenca <> 0 THEN 
         ASSIGN de-vl-tot-nf = de-vl-tot-nf + de-diferenca.                                                     
     IF  natur-oper.per-des-icms > 0 THEN DO:  /*ICMS*/                                      
         IF de-diferenca <> 0 THEN                                                                             
             ASSIGN de-vl-icms-abat = de-vl-icms-abat - de-diferenca                                          
                    de-diferenca    = 0.                                                                       
     END.

     ASSIGN de-val-frete = de-val-frete + nota-fiscal.vl-frete.


    /* Calcula ValOutrasDesp */
    ASSIGN de-val-outras-desp = de-val-outras-desp - de-val-frete.

    /* FTConta */
    IF nota-fiscal.cidade-cif <> "" THEN
        ASSIGN i-ft-conta = 1.
    ELSE 
        ASSIGN i-ft-conta = 2.

    /* EspÇcie */
    FOR EACH nota-embal USE-INDEX ch-nota-emb
       WHERE nota-embal.cod-estabel = nota-fiscal.cod-estabel
         AND nota-embal.serie       = nota-fiscal.serie
         AND nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:
    
         FIND embalag WHERE
              embalag.sigla-emb = nota-embal.sigla-emb NO-LOCK NO-ERROR.
         IF AVAILABLE(embalag) THEN
             ASSIGN c-especie = embalag.descricao.
         ELSE c-especie = " ".
    END.
    IF c-especie = " " THEN DO:
        ASSIGN c-especie = "VOLUME".
    END.  


    PUT STREAM s-exporta UNFORMATTED
        "<valores>" CHR(10)
        "<baseCalcICMS>"  REPLACE(TRIM(STRING(de-vl-base-icms, "->>>>>>>>>>>>>>>>>9.99")),",",".")       "</baseCalcICMS>"  CHR(10)
        "<valICMS>"       REPLACE(TRIM(STRING(de-vl-icms, "->>>>>>>>>>>>>>>>>9.99")),",",".")            "</valICMS>"       CHR(10)
        "<valFT>"         REPLACE(TRIM(STRING(de-val-frete, "->>>>>>>>>>>>>>>>>9.99")),",",".")          "</valFT>"         CHR(10)
        "<valSeguro>"     REPLACE(TRIM(STRING(nota-fiscal.vl-seguro, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</valSeguro>"     CHR(10)
        "<valTotIPI>"     REPLACE(TRIM(STRING(de-vl-totipi, "->>>>>>>>>>>>>>>>>9.99")),",",".")          "</valTotIPI>"     CHR(10)
        "<valOutrasDesp>" REPLACE(TRIM(STRING(de-val-outras-desp, "->>>>>>>>>>>>>>>>>9.99")),",",".")    "</valOutrasDesp>" CHR(10)
        "<valTotItens>"   REPLACE(TRIM(STRING(de-vl-tot-nf, "->>>>>>>>>>>>>>>>>9.99")),",",".")       "</valTotItens>"   CHR(10)
        "<valTotNF>"      REPLACE(TRIM(STRING(de-vl-tot-itens, "->>>>>>>>>>>>>>>>>9.99")),",",".")          "</valTotNF>"      CHR(10)
        "<valPIS>"        REPLACE(TRIM(STRING(de-val-tot-pis, "->>>>>>>>>>>>>>>>>9.99")),",",".")        "</valPIS>"        CHR(10)
        "<valCOFINS>"     REPLACE(TRIM(STRING(de-val-tot-cofins, "->>>>>>>>>>>>>>>>>9.99")),",",".")     "</valCOFINS>"     CHR(10)
        "<valAbatICMS>"   REPLACE(TRIM(STRING(de-vl-icms-abat, "->>>>>>>>>>>>>>>>>9.99")),",",".")       "</valAbatICMS>"   CHR(10)
        "</valores>" CHR(10)
        "<transportador>" CHR(10)
        "<cnpjTransp>"    STRING(c-cnpj-transp, "X(14)")                                                    "</cnpjTransp>"    CHR(10)
        "<ftConta>"       STRING(i-ft-conta, "9")                                                           "</ftConta>"       CHR(10)
        "<placaVeic>"     REPLACE(nota-fiscal.placa, "-", "")                                               "</placaVeic>"     CHR(10)
        "<ufPlacaVeic>"   nota-fiscal.uf-placa                                                              "</ufPlacaVeic>"   CHR(10)
        "<inscEstTransp>" REPLACE(REPLACE(TRIM(STRING(c-insc-transp)),".",""),"-","")                       "</inscEstTransp>" CHR(10)
        "<qtdeVol>"       nota-fiscal.nr-volumes                                                            "</qtdeVol>"       CHR(10)
        "<especie>"       TRIM(STRING(c-especie))                                                           "</especie>"       CHR(10)
        "<marca>"         TRIM(STRING(nota-fiscal.marca-volume))                                            "</marca>"         CHR(10)
        "<numero>"        "0"                                                                               "</numero>"        CHR(10)
        "<pesoBruto>"     REPLACE(TRIM(STRING(nota-fiscal.peso-bru-tot, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</pesoBruto>"     CHR(10)
        "<pesoLiq>"       REPLACE(TRIM(STRING(nota-fiscal.peso-liq-tot, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</pesoLiq>"       CHR(10)
        "</transportador>" CHR(10)
        "<gnre>" CHR(10)
        "<valGNRE>"    REPLACE(TRIM(STRING(de-vl-gnre, "->>>>>>>>>>>>>>>>>9.99")),",",".")                                        "</valGNRE>"    CHR(10)
        "<dtVencGNRE>" "09/" STRING(MONTH(nota-fiscal.dt-emis-nota) + 1, "99") "/" STRING(YEAR(nota-fiscal.dt-emis-nota), "9999") "</dtVencGNRE>" CHR(10)
        "<perRefGNRE>" STRING(MONTH(nota-fiscal.dt-emis-nota), "99") "/" STRING(YEAR(nota-fiscal.dt-emis-nota), "9999")           "</perRefGNRE>" CHR(10)
        "</gnre>" CHR(10)
        "<refaturamento>"                      CHR(10)
        "<NFRefat>"        "</NFRefat>"        CHR(10) /* N∆o informar */
        "<dtEmissaoRefat>" "</dtEmissaoRefat>" CHR(10) /* N∆o informar */
        "<inscSufRefat>"   "</inscSufRefat>"   CHR(10) /* N∆o informar */
        "</refaturamento>"                     CHR(10)
        "<substTributaria>"                    CHR(10)
        "<baseCalcICMSSubTrib>" REPLACE(TRIM(STRING(de-vl-base-icms-st, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</baseCalcICMSSubTrib>" CHR(10)
        "<valICMSSub>"          REPLACE(TRIM(STRING(de-vl-base-icms-st, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</valICMSSub>"          CHR(10)
        "<inscEstSubTrib></inscEstSubTrib>" CHR(10) /* Brancos */
        "</substTributaria>" CHR(10).

    RUN pi-imprime-it-nota.

    PUT STREAM s-exporta UNFORMATTED
        "</notaFiscal>" CHR(10).
.

               
END PROCEDURE. 

PROCEDURE pi-imprime-it-nota:
    DEF VAR c-cod-ncm       AS CHARACTER NO-UNDO.
    DEF VAR c-desc-prod     AS CHARACTER NO-UNDO.
    DEF VAR de-val-unit     AS DECIMAL   NO-UNDO.
    DEF VAR de-qtde-it      AS DECIMAL   NO-UNDO.
    DEF VAR de-al-icms      AS DECIMAL   NO-UNDO.
    DEF VAR i-trib-icms     AS INTEGER   NO-UNDO.
    DEF VAR i-cod-trib-icms AS INTEGER   NO-UNDO.
    DEF VAR de-vl-merc-liq  AS DECIMAL   NO-UNDO.
                        
    PUT STREAM s-exporta UNFORMATTED
        "<itens>" CHR(10).

    for each it-nota-fisc of nota-fiscal no-lock,
        FIRST item NO-LOCK
          WHERE item.it-codigo = it-nota-fisc.it-codigo:
    
        ASSIGN de-qtde-it  = de-qtde-it +     IF it-nota-fisc.ind-fat-qtfam THEN 
                                                  it-nota-fisc.qt-faturada[2]
                                              ELSE it-nota-fisc.qt-faturada[1]
                                          
               de-vl-merc-liq = de-vl-merc-liq + it-nota-fisc.vl-merc-liq.
    
    

        RUN pi-retorna-desc-it (OUTPUT c-desc-prod).
 
        /* codNCM */
        IF it-nota-fisc.class-fiscal <> "" THEN 
            ASSIGN c-cod-ncm = it-nota-fisc.class-fiscal.
        ELSE
            ASSIGN c-cod-ncm = item.class-fiscal.
        
        /* ValUnit */
        ASSIGN de-val-unit = de-vl-merc-liq / de-qtde-it.
               
 
        /* sitTribut */
        RUN situacaoTribICMSDoitem (OUTPUT i-cod-trib-icms).
 
        /* alICMS */
        ASSIGN i-trib-icms  = IF it-nota-fisc.cd-trib-icm = 4 THEN 1
                              ELSE IF it-nota-fisc.cd-trib-icm  = 1 AND 
                                      it-nota-fisc.aliquota-icm = 0 THEN 3
                                   ELSE it-nota-fisc.cd-trib-icm
               de-al-icms   = IF (i-trib-icms = 2 OR i-trib-icms = 3) THEN 0
                              ELSE it-nota-fisc.aliquota-icm.
 
        run retiraAcentos (input-output c-desc-prod).
 
        PUT STREAM s-exporta UNFORMATTED
            "<item>" CHR(10)
            "<codProd>"     TRIM(it-nota-fisc.it-codigo)                                                       "</codProd> "    CHR(10)
            "<descItem>"    trim(SUBSTR(c-desc-prod,1,120))                                                    "</descItem>"    CHR(10)
            "<codNCM>"      c-cod-ncm                                                                          "</codNCM>"      CHR(10)
            "<unidMed>"     item.un                                                                            "</unidMed>"     CHR(10)
            "<valUnit>"     REPLACE(TRIM(STRING(de-val-unit, "->>>>>>>>>>>>>>>>>9.9999")),",",".")               "</valUnit>"     CHR(10)
            "<qtde>"        REPLACE(TRIM(STRING(de-qtde-it, "->>>>>>>>>>>>>>>>>9.99")),",",".")                "</qtde>"        CHR(10)
            "<valTot>"      REPLACE(TRIM(STRING(de-vl-merc-liq, "->>>>>>>>>>>>>>>>>9.99")),",",".")            "</valTot>"      CHR(10)
            "<classFiscal>" c-cod-ncm                                                                          "</classFiscal>" CHR(10)
            "<sitTribut>"   STRING(i-cod-trib-icms,"999")                                                      "</sitTribut>"   CHR(10)
            "<alICMS>"      REPLACE(TRIM(STRING(de-al-icms, "->>>>>>>>>>>>>>>>>9.99")),",",".")                "</alICMS>"      CHR(10)
            "<alIPI>"       REPLACE(TRIM(STRING(it-nota-fisc.aliquota-ipi, "->>>>>>>>>>>>>>>>>9.99")),",",".") "</alIPI>"       CHR(10)
            "<valIPI>"      REPLACE(TRIM(STRING(it-nota-fisc.vl-ipi-it, "->>>>>>>>>>>>>>>>>9.99")),",",".")    "</valIPI>"      CHR(10) 
            "</item>" CHR(10).
 
        ASSIGN de-qtde-it     = 0
               de-vl-merc-liq = 0.
    
    END.
    PUT STREAM s-exporta UNFORMATTED
        "</itens>" CHR(10).

END PROCEDURE.

procedure retiraAcentos:
    def input-output parameter c-texto as char.
    
    assign c-texto = replace(c-texto,"†","a")
           c-texto = replace(c-texto,"∆","a")
           c-texto = replace(c-texto,"É","a")       
           c-texto = replace(c-texto,"Ö","a")              
           c-texto = replace(c-texto,"Ñ","a")              
           
           c-texto = replace(c-texto,"Ç","e")
           c-texto = replace(c-texto,"à","e")       
           c-texto = replace(c-texto,"ä","e")              
           c-texto = replace(c-texto,"â","e")              
    
           c-texto = replace(c-texto,"°","i")
           c-texto = replace(c-texto,"å","i")       
           c-texto = replace(c-texto,"ç","i")              
           c-texto = replace(c-texto,"ã","i")              
           c-texto = replace(c-texto,"å","i")                     
           
           c-texto = replace(c-texto,"¢","o")
           c-texto = replace(c-texto,"‰","o")
           c-texto = replace(c-texto,"ì","o")       
           c-texto = replace(c-texto,"ï","o")              
           c-texto = replace(c-texto,"î","o")              
           
           c-texto = replace(c-texto,"£","u")
           c-texto = replace(c-texto,"ñ","u")       
           c-texto = replace(c-texto,"ó","u")              
           c-texto = replace(c-texto,"Å","u")              
           
           c-texto = replace(c-texto,"µ","A")
           c-texto = replace(c-texto,"«","A")
           c-texto = replace(c-texto,"∂","A")       
           c-texto = replace(c-texto,"∑","A")              
           c-texto = replace(c-texto,"é","A")              
           
           c-texto = replace(c-texto,"ê","E")
           c-texto = replace(c-texto,"“","E")       
           c-texto = replace(c-texto,"‘","E")              
           c-texto = replace(c-texto,"”","E")              
    
           c-texto = replace(c-texto,"÷","I")
           c-texto = replace(c-texto,"◊","I")       
           c-texto = replace(c-texto,"ﬁ","I")              
           c-texto = replace(c-texto,"ÿ","I")              
           c-texto = replace(c-texto,"◊","I")                     
           
           c-texto = replace(c-texto,"‡","O")
           c-texto = replace(c-texto,"Â","O")
           c-texto = replace(c-texto,"‚","O")       
           c-texto = replace(c-texto,"„","O")              
           c-texto = replace(c-texto,"ô","O")              
           
           c-texto = replace(c-texto,"È","U")
           c-texto = replace(c-texto,"Í","U")       
           c-texto = replace(c-texto,"Î","U")              
           c-texto = replace(c-texto,"ö","U") 
           
           c-texto = replace(c-texto,"á","c")              
           c-texto = replace(c-texto,"Ä","C")
           
           c-texto = REPLACE(c-texto,CHR(10),"")
           c-texto = REPLACE(c-texto,CHR(13),"").


end procedure.

PROCEDURE enviaE-mail:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Envio de e-mail para o usu†rio logado que gerou os arquivos XML
------------------------------------------------------------------------------*/

    DEF VAR c-email AS CHAR NO-UNDO.

    IF  TRIM(c-lst-nome-arq) <> "" THEN 
        ASSIGN c-diretorio-origem  = substr(c-lst-nome-arq,2,LENGTH(c-lst-nome-arq) - 1).
        
    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN esp/es0018p.p (INPUT "esftp042", /* Nome do programa  */
                       INPUT 3,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FIND FIRST tt-prog-ponto
         WHERE entry(1,tt-prog-ponto.conteudo,";") = string(nota-fiscal.cod-estabel) NO-LOCK NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
        ASSIGN c-email = entry(2,tt-prog-ponto.conteudo,";").
    
    IF  nota-fiscal.nr-pedcli <> "" THEN DO:   /* EXISTE PEDIDO */
         FOR FIRST ped-venda
             WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
               AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK:

             FIND atendente NO-LOCK 
                  WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
             IF  AVAIL atendente AND atendente.email <> "" THEN DO:
                 
                 IF  c-email <> "" THEN
                     ASSIGN c-email = atendente.email + ";" + c-email.
                 ELSE
                     ASSIGN c-email = atendente.email.

                 /*enviar copia do email para atendente*/
                FOR FIRST ponto-programa NO-LOCK USE-INDEX ponto
                    WHERE ponto-programa.nome-programa = "esftp042":U
                      AND ponto-programa.ponto         = 2:

                     FIND FIRST conteudo-programa
                          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                            AND  ENTRY(1, conteudo-programa.conteudo, ",":U) = string(atendente.cd-oper) NO-ERROR.
                     IF AVAIL conteudo-programa THEN DO:
                         IF c-email <> "" THEN
                             ASSIGN c-email = ENTRY(2, conteudo-programa.conteudo, ",") + ";" + c-email.
                         ELSE
                             ASSIGN c-email = ENTRY(2, conteudo-programa.conteudo, ",").
                     END.
                END.
             END.
             RUN pienvia (INPUT c-email).
         END.
    END.
    ELSE DO: /* CASO N«O EXISTA PEDIDO, verifica se Ç cliente Diferenciado */
        FIND FIRST ped-fiscal NO-LOCK 
             WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
               AND ped-fiscal.serie       = nota-fiscal.serie
               AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

        RELEASE usuar_mestre.
        IF AVAIL ped-fiscal THEN DO:
            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuar = ped-fiscal.usuario-magnus NO-ERROR.
        END.

        IF NOT CAN-FIND(FIRST cli-dif
                        WHERE cli-dif.cod-emitente = nota-fiscal.cod-emitente) THEN
            
            RUN pienvia (INPUT c-email + IF AVAIL usuar_mestre THEN ";" + usuar_mestre.cod_e_mail_local ELSE "").
        ELSE
            FOR EACH cli-dif
               WHERE cli-dif.cod-emitente = nota-fiscal.cod-emitente NO-LOCK:             
                IF  cli-dif.e-mail = "" THEN
                    RUN pienvia (INPUT c-email + IF AVAIL usuar_mestre THEN ";" + usuar_mestre.cod_e_mail_local ELSE "").
                ELSE
                    RUN pienvia (INPUT cli-dif.e-mail + IF AVAIL usuar_mestre THEN ";" + usuar_mestre.cod_e_mail_local ELSE "").
            END.
    END.

END PROCEDURE. /*- enviaE-mail -*/
              

PROCEDURE pienvia:
    DEFINE INPUT PARAMETER c-e-mail AS CHARACTER.

    DEFINE VARIABLE h-utapi019      AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-utapi019)  THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange          = param-global.log-1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.destino           = c-e-mail
           tt-envio2.assunto           = "PIN - Protocolo Ingresso Mercadoria Nacional - Geraá∆o arquivo XML"
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.importancia       = 2
           tt-envio2.log-enviada       = NO
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.arq-anexo         = c-diretorio-origem
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Os arquivos em anexo gerados, dever∆o ser enviados para a Suframa para encaminhamento do PIN (Protocolo de Ingresso da Mercadoria Nacional)." + CHR(10) + 
                                      "Ref.Nota Fiscal: " + nota-fiscal.nr-nota-fis + " Cliente: " + string(emitente.cod-emitente) + " - " + emitente.nome-emit.


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    /*IF OPSYS <> "UNIX"
    AND i-num-ped-exec-rpw = 0 THEN 
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Email enviado para: ~~ " + c-e-mail). */

    DELETE tt-mensagem.    
    DELETE tt-envio2.    
    DELETE PROCEDURE h-utapi019.
END PROCEDURE.


