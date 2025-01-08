/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i espnfse2030-upc 2.03.00.000}  /*** 010013 ***/
/* ---------------------[ VERSAO ]-------------------- */
/******************************************************************************
**
**  Programa para mudar a numeracao da nota de serviáo de acordo com a numeracao 
**  gerada pela prefeitura
**
**  Empresa: Intelbras
**
**  Data...: 15/02/2013
**
**  Elaborado por Cenci.
**
*******************************************************************************/

DEF INPUT PARAMETER pi-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
DEF INPUT PARAMETER pi-serie       LIKE nota-fiscal.serie       NO-UNDO.
DEF INPUT PARAMETER pi-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.
DEF INPUT PARAMETER pi-nr-nota-el  LIKE nota-fiscal.nr-nota-fis NO-UNDO.
DEF INPUT PARAMETER pi-serie-el    LIKE nota-fiscal.serie       NO-UNDO.
DEF OUTPUT PARAMETER c-erro        AS CHAR                      NO-UNDO.

def var r-b-nota   as recid                                          no-undo.
def var l-conf     as logical format "Sim/Nao"                       no-undo.
def var c-serie    like nota-fiscal.serie             init ""        no-undo.
def var i-nr-nota  like nota-fiscal.nr-nota-fis       init  0        no-undo.
def var c-est      like nota-fiscal.cod-estabel                      no-undo.

def buffer b-nota for nota-fiscal.


find first param-global no-lock.

IF length(pi-nr-nota-el) < 7 THEN DO:
   IF length(pi-nr-nota-el) = 1  THEN
       ASSIGN pi-nr-nota-el = "000000" + pi-nr-nota-el.
   ELSE IF length(pi-nr-nota-el) = 2 THEN
           ASSIGN pi-nr-nota-el = "00000" + pi-nr-nota-el.
        ELSE IF length(pi-nr-nota-el) = 3 THEN
                ASSIGN pi-nr-nota-el = "0000" + pi-nr-nota-el. 
             ELSE IF length(pi-nr-nota-el) = 4 THEN
                     ASSIGN pi-nr-nota-el = "000" + pi-nr-nota-el. 
                  ELSE IF length(pi-nr-nota-el) = 5 THEN
                          ASSIGN pi-nr-nota-el = "00" + pi-nr-nota-el. 
                       ELSE 
                          ASSIGN pi-nr-nota-el = "0" + pi-nr-nota-el. 
END.

find b-nota no-lock
     where b-nota.cod-estabel = pi-cod-estabel
     and   b-nota.serie       = pi-serie      
     and   b-nota.nr-nota-fis = pi-nr-nota-fis   no-error.

if  not avail b-nota then do:
    ASSIGN c-erro =  "Nota Fiscal N∆o Encontrada.".
    RETURN "NOK".
end.
IF b-nota.dt-at-of <> ?  THEN DO:
    ASSIGN c-erro =  "Nota Fiscal Ja atualizada em OF - impossivel converter numeraá∆o".
    RETURN "NOK".

END.
IF b-nota.dt-atual-cr <> ?  THEN DO:
    ASSIGN c-erro =  "Nota Fiscal Ja atualizada em Contas a Receber - impossivel converter numeraá∆o".
    RETURN "NOK".

END.
IF b-nota.dt-cancel <> ?  THEN DO:
    ASSIGN c-erro =  "Nota Fiscal Cancelada - impossivel converter numeraá∆o".
    RETURN "NOK".

END.

IF SUBSTRING(b-nota.char-1,143,2) = "4" THEN DO:
    ASSIGN c-erro = "Nota fiscal com erro, consulte FT0916 para mais detalhes".
    RETURN "NOK".
END.

assign r-b-nota = recid(b-nota).

find first devol-cli use-index ch-nfs
     where devol-cli.cod-estabel = b-nota.cod-estabel
     and   devol-cli.serie       = b-nota.serie
     and   devol-cli.nr-nota-fis = b-nota.nr-nota-fis
     and   devol-cli.origem      = 2
     and   devol-cli.ind-atu-est = no
     no-lock no-error.

if  avail devol-cli then do:
    
    ASSIGN c-erro =  "Existem devolucoes ainda nao atualizadas nas estatisticas de faturamento.".
    RETURN "NOK".
end.

for each  devol-cli use-index ch-nfs
    where devol-cli.cod-estabel = b-nota.cod-estabel
    and   devol-cli.serie       = b-nota.serie
    and   devol-cli.nr-nota-fis = b-nota.nr-nota-fis
    and   devol-cli.origem      = 2
    exclusive-lock:
    
    ASSIGN devol-cli.serie       = pi-serie-el  
           devol-cli.nr-nota-fis = pi-nr-nota-el.
end.

for each  it-nota-fisc use-index ch-nota-item
    where it-nota-fisc.cod-estabel = b-nota.cod-estabel
    and   it-nota-fisc.serie       = b-nota.serie
    and   it-nota-fisc.nr-nota-fis = b-nota.nr-nota-fis
    exclusive-lock:
    
    /* Exclus∆o da tabela ext-nota-fisc para registro de notas antigos que antes n∆o era convertido a numeracao */
    FOR EACH  ext-it-nota-fisc
        WHERE ext-it-nota-fisc.cod-estabel  = it-nota-fisc.cod-estabel
        AND   ext-it-nota-fisc.serie        = pi-serie-el
        AND   ext-it-nota-fisc.nr-nota-fis  = pi-nr-nota-el
        AND   ext-it-nota-fisc.nr-seq-fat   = it-nota-fisc.nr-seq-fat EXCLUSIVE-LOCK:

        DELETE ext-it-nota-fisc.
    END.

    /* Inserá∆o tabela ext-it-nota-fisc e ct-trib-it-nota */
    FOR EACH ext-it-nota-fisc
        WHERE ext-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel						
        AND ext-it-nota-fisc.serie         = it-nota-fisc.serie						
        AND ext-it-nota-fisc.nr-nota-fis   = it-nota-fisc.nr-nota-fis						
        AND ext-it-nota-fisc.nr-seq-fat    = it-nota-fisc.nr-seq-fat						
        AND ext-it-nota-fisc.it-codigo     = it-nota-fisc.it-codigo EXCLUSIVE-LOCK:

        ASSIGN ext-it-nota-fisc.serie       = pi-serie-el
               ext-it-nota-fisc.nr-nota-fis = pi-nr-nota-el.
    END.

    FOR EACH ct-trib-item-nota-fisc
        WHERE ct-trib-item-nota-fisc.cod-estab     = it-nota-fisc.cod-estabel
         AND  ct-trib-item-nota-fisc.cod-serie     = it-nota-fisc.serie
         AND  ct-trib-item-nota-fisc.cod-nota-fisc = it-nota-fisc.nr-nota-fis
         AND  ct-trib-item-nota-fisc.num-seq       = it-nota-fisc.nr-seq-fat
         AND  ct-trib-item-nota-fisc.cod-item      = it-nota-fisc.it-codigo EXCLUSIVE-LOCK:

       ASSIGN ct-trib-item-nota-fisc.cod-serie     = pi-serie-el
              ct-trib-item-nota-fisc.cod-nota-fisc = pi-nr-nota-el.
    END.

    for each  fat-ser-lote use-index ch-lote
        where fat-ser-lote.cod-estabel = b-nota.cod-estabel
        and   fat-ser-lote.serie       = b-nota.serie
        and   fat-ser-lote.nr-nota-fis = b-nota.nr-nota-fis
        and   fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
        exclusive-lock:

        ASSIGN fat-ser-lote.serie       = pi-serie-el  
               fat-ser-lote.nr-nota-fis = pi-nr-nota-el.
    end.

    for each  nar-it-nota use-index ch-narrat-it
        where nar-it-nota.cod-estabel  = b-nota.cod-estabel
        and   nar-it-nota.serie        = b-nota.serie
        and   nar-it-nota.nr-nota-fis  = b-nota.nr-nota-fis
        and   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
        exclusive-lock:

        ASSIGN nar-it-nota.serie       = pi-serie-el  
               nar-it-nota.nr-nota-fis = pi-nr-nota-el.

    end.
    ASSIGN it-nota-fisc.serie       = pi-serie-el  
           it-nota-fisc.nr-nota-fis = pi-nr-nota-el.

end.

do  for nota-fiscal:
    find first nota-fiscal use-index ch-fatura
         where nota-fiscal.cod-estabel = b-nota.cod-estabel
         and   nota-fiscal.serie       = b-nota.serie
         and   nota-fiscal.nr-fatura   = b-nota.nr-fatura
         and   recid(nota-fiscal)     <> r-b-nota no-lock no-error.

    if  not avail nota-fiscal then do:
        for each  fat-repre use-index ch-fatrep
            where fat-repre.cod-estabel = b-nota.cod-estabel
            and   fat-repre.serie       = b-nota.serie
            and   fat-repre.nr-fatura   = b-nota.nr-fatura
            exclusive-lock:

            ASSIGN fat-repre.serie       = pi-serie-el  
                   fat-repre.nr-fatura   = pi-nr-nota-el.

        end.

        for each  fat-duplic use-index ch-fatura
            where fat-duplic.cod-estabel = b-nota.cod-estabel
            and   fat-duplic.serie       = b-nota.serie
            and   fat-duplic.nr-fatura   = b-nota.nr-fatura
            exclusive-lock:

            find first his-fat-duplic where
            his-fat-duplic.cod-estabel  = fat-duplic.cod-estabel  and
            his-fat-duplic.serie        = fat-duplic.serie        and
            his-fat-duplic.nr-fatura    = fat-duplic.nr-fatura    and
            his-fat-duplic.ind-fat-nota = fat-duplic.ind-fat-nota and
            his-fat-duplic.flag-atualiz = fat-duplic.flag-atualiz and
            his-fat-duplic.parcela      = fat-duplic.parcela no-error.
            
            if  avail his-fat-duplic then
                ASSIGN his-fat-duplic.serie       = pi-serie-el  
                       his-fat-duplic.nr-fatura   = pi-nr-nota-el.

            ASSIGN fat-duplic.serie       = pi-serie-el  
                   fat-duplic.nr-fatura   = pi-nr-nota-el.

        end.
        for EACH rateio-it-duplic fields ( )
                 WHERE rateio-it-duplic.cod-estabel =  b-nota.cod-estabel    
                   AND rateio-it-duplic.serie       =  b-nota.serie          
                   AND rateio-it-duplic.nr-fatura   =  b-nota.nr-fatura  EXCLUSIVE-LOCK:     
              ASSIGN rateio-it-duplic.nr-fatura   = pi-nr-nota-el
                     rateio-it-duplic.nr-nota-fis = pi-nr-nota-el
                     rateio-it-duplic.serie       = pi-serie-el .
        end.

    end.
end.

for each  nota-embal use-index ch-nota-emb
    where nota-embal.cod-estabel = b-nota.cod-estabel
    and   nota-embal.serie       = b-nota.serie
    and   nota-embal.nr-nota-fis = b-nota.nr-nota-fis
    exclusive-lock:

    for each  item-embal use-index ch-embal-it
        where item-embal.sigla-emb   = nota-embal.sigla-emb
        and   item-embal.cod-estabel = nota-embal.cod-estabel
        and   item-embal.serie       = nota-embal.serie
        and   item-embal.nr-nota-fis = nota-embal.nr-nota-fis
        exclusive-lock:

        ASSIGN item-embal.serie         = pi-serie-el  
               item-embal.nr-nota-fis   = pi-nr-nota-el.

    end.

    ASSIGN nota-embal.serie         = pi-serie-el  
           nota-embal.nr-nota-fis   = pi-nr-nota-el.

end.
for each unid-neg-fat where
         unid-neg-fat.cod-estabel =  b-nota.cod-estabel    AND
         unid-neg-fat.serie       =  b-nota.serie          AND
         unid-neg-fat.nr-nota-fis =  b-nota.nr-nota-fis    EXCLUSIVE-LOCK:
    ASSIGN unid-neg-fat.nr-nota-fis = pi-nr-nota-el
           unid-neg-fat.serie       = pi-serie-el.
END.

FOR EACH nf-vendor     EXCLUSIVE-LOCK  
    WHERE nf-vendor.cod-estabel = b-nota.cod-estabel
      AND nf-vendor.serie       = b-nota.serie
      AND nf-vendor.nr-nota-fis = b-nota.nr-nota-fis .
    ASSIGN nf-vendor.nr-nota-fis = pi-nr-nota-el  
           nf-vendor.serie       = pi-serie-el.   
END. 

for each  nota-trans use-index nota
    where nota-trans.cod-estabel = b-nota.cod-estabel
    and   nota-trans.serie       = b-nota.serie
    and   nota-trans.nr-nota-fis = b-nota.nr-nota-fis
    exclusive-lock:

    ASSIGN nota-trans.serie         = pi-serie-el  
           nota-trans.nr-nota-fis   = pi-nr-nota-el.

end.                
for each  volume-nf
    where volume-nf.cod-estabel = b-nota.cod-estabel
    and   volume-nf.serie       = b-nota.serie
    and   volume-nf.nr-nota-fis = b-nota.nr-nota-fis
    exclusive-lock:

    ASSIGN volume-nf.serie         = pi-serie-el  
           volume-nf.nr-nota-fis   = pi-nr-nota-el.

end.   
do  transaction:
     do  for nota-fiscal:
        find FIRST nota-fiscal 
             WHERE recid(nota-fiscal) = r-b-nota exclusive-lock.

        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

       FIND FIRST his-nota-fiscal 
            WHERE his-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel 
            AND his-nota-fiscal.serie         = nota-fiscal.serie       
            AND his-nota-fiscal.nr-nota-fis   = nota-fiscal.nr-nota-fis no-error.

        IF  AVAIL his-nota-fiscal then
            ASSIGN his-nota-fiscal.serie         = pi-serie-el  
                   his-nota-fiscal.nr-nota-fis   = pi-nr-nota-el.


       FIND FIRST int-nota-fiscal 
            WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel 
              AND int-nota-fiscal.serie       = nota-fiscal.serie       
              AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.

        IF  AVAIL int-nota-fiscal then
            ASSIGN int-nota-fiscal.serie         = pi-serie-el  
                   int-nota-fiscal.nr-nota-fis   = pi-nr-nota-el.

        FOR EACH ret-nf-eletro
             WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
               AND ret-nf-eletro.cod-serie   = nota-fiscal.serie
               AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK:

       
                ASSIGN ret-nf-eletro.cod-serie    = pi-serie-el
                       ret-nf-eletro.nr-nota-fis  = pi-nr-nota-el.
         END.

        
        ASSIGN nota-fiscal.serie         = pi-serie-el  
               nota-fiscal.nr-nota-fis   = pi-nr-nota-el
               nota-fiscal.nr-fatura     = pi-nr-nota-el.

        FIND FIRST nota-fisc-adc
             WHERE nota-fisc-adc.cod-estab              = nota-fiscal.cod-estabel  
             AND   nota-fisc-adc.cod-serie              = nota-fiscal.serie        
             AND   nota-fisc-adc.cod-nota-fisc          = nota-fiscal.nr-nota-fis  
             AND   nota-fisc-adc.cdn-emitente           = nota-fiscal.cod-emitente 
             AND   nota-fisc-adc.cod-natur-operac       = nota-fiscal.nat-operacao 
             AND   nota-fisc-adc.idi-tip-dado           = 29
             AND   nota-fisc-adc.num-seq                = 0 EXCLUSIVE-LOCK NO-ERROR.

         IF AVAIL nota-fisc-adc THEN DO:
            ASSIGN nota-fisc-adc.cod-serie        = pi-serie-el  
                    nota-fisc-adc.cod-nota-fisc   = pi-nr-nota-el.
          END.
          ELSE DO:
                CREATE nota-fisc-adc.
                ASSIGN nota-fisc-adc.cod-estab              = nota-fiscal.cod-estabel  
                       nota-fisc-adc.cod-serie              = nota-fiscal.serie        
                       nota-fisc-adc.cod-nota-fisc          = nota-fiscal.nr-nota-fis  
                       nota-fisc-adc.cdn-emitente           = nota-fiscal.cod-emitente  
                       nota-fisc-adc.cod-natur-operac       = nota-fiscal.nat-operacao 
                       nota-fisc-adc.idi-tip-dado           = 29
                       nota-fisc-adc.cod-ser-docto-referado = nota-fiscal.serie
                       nota-fisc-adc.cod-docto-referado     = TRIM(SUBSTRING(nota-fiscal.char-1,265,16))
                       nota-fisc-adc.cod-livre-1            = STRING(estabelec.cgc, '99999999999999') + TRIM(nota-fisc-adc.cod-ser-docto-referado) + STRING(DEC(nota-fisc-adc.cod-docto-referado),"999999999").
        END.
    END.
END.

RETURN.


