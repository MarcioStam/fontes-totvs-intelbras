/***********************************************************************
**  Programa..: ESP\FTP\ESFTP002RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Credito Presumido ICMS
**              ConversÆo do programa es0891.p - Claudiney
**  VersÆo....: 001 15/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP002 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/ftp/esftp002tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
def temp-table tt-resumo
    FIELD cod-unidade  LIKE unid-neg-fat.cod_unid_negoc
    FIELD Sequencia    AS INT
    FIELD DesUnidade   AS CHAR FORMAT 'x(40)'
    
    field tipo           as log format "Nacional/Importado"
    field outras         as log format "Outras/Normais"
    field aliquota-icm   like it-nota-fisc.aliquota-icm
    field vl-tot-nota    like it-nota-fisc.vl-tot-item
    field vl-mercad      like it-nota-fisc.vl-merc-liq
    field vl-icms        like it-nota-fisc.vl-icms-it
    field perc-reducao   as dec
    field vl-cred-pres   as dec
    field vl-devol       as dec
    FIELD fm-codigo      LIKE item.fm-codigo
    index tt-resumo is primary fm-codigo tipo outras aliquota-icm.
/****************************  Variaveis    ****************************/
def var da-data         as date.
def var l-tipo          as log.
def var l-outras        as log.
DEFINE VARIABLE vDeValor AS DECIMAL FORMAT '->>,>>>,>>9.99'   NO-UNDO.
DEFINE VARIABLE vlogImportado   AS LOGICAL  FORMAT 'Sim/NÆo'  NO-UNDO.
DEFINE VARIABLE vlogBeneficiado AS LOGICAL  FORMAT 'Sim/NÆo'  NO-UNDO.
DEFINE VARIABLE cTipo AS CHARACTER INIT "CEN,TER,EXP" NO-UNDO.
DEF VAR vUnidNegocio LIKE unid-neg-fat.cod_unid_negoc.
DEF VAR vNomeSup     AS CHAR    NO-UNDO.
DEF VAR vPercUnid    LIKE unid-neg-fat.perc-unid-neg.



DEF VAR cont AS INT.

/****************************  Frames       ****************************/

FORM tt-resumo.tipo             column-label "Tipo"  
     tt-resumo.outras           column-label "Notas" 
     tt-resumo.aliquota-icm     column-label "% ICMS" 
     tt-resumo.vl-tot-nota      column-label "." 
     tt-resumo.vl-mercad        column-label "Vl Mercad Liquid " 
     tt-resumo.vl-icms          column-label "Valor ICMS" 
     /*tt-resumo.aliquota-icm     column-label "% ICMS" */
     tt-resumo.perc-reducao     column-label "%Reducao" 
     tt-resumo.vl-cred-pres     column-label "Credito Presum" 
     tt-resumo.vl-devol         column-label "Devolucoes" 
     vDeValor                   column-label "Cred Pres Compensar" 
     with width 150 no-attr-space frame f-corpo STREAM-IO DOWN.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Credito Presumido ICMS"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP002"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}

    IF   tt-param.TipoImpressao = 1 THEN DO:
        {include/i-rpout.i}
    END.
    ELSE DO:
        {include/i-rpout.i &pagesize="0"}
    END.

    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    IF   tt-param.TipoImpressao = 1 THEN DO:
        if tt-param.formato-excel = no then do:    
            VIEW FRAME f-cabec.
            VIEW FRAME f-rodape.
        end.

         RUN pi-inicializar in h-acomp (input "Montando Relat¢rio...").
         RUN piMontaRelat.

         RUN pi-inicializar in h-acomp (input "Imprimindo...").
         RUN piImprimeRelatRes.
    END.
    ELSE RUN piImprimeRelatDet.

    IF tt-param.ImpItens THEN
       RUN pi-itens-lei-informatica.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:

   /******* NOTAS DE FATURAMENTO ********/
   do da-data = tt-param.DtEmissaoIni to tt-param.DtEmissaoFim:
      for each nota-fiscal no-lock 
          where nota-fiscal.dt-emis-nota = da-data
            and nota-fiscal.dt-cancel = ?
            and nota-fiscal.nat-operacao >= tt-param.NatOperacaoIni
            and nota-fiscal.nat-operacao <= tt-param.NatOperacaoFim
            and nota-fiscal.estado >= tt-param.EstadoIni
            and nota-fiscal.estado <= tt-param.EstadoFim
            and nota-fiscal.cod-estabel >= tt-param.EstabIni
            and nota-fiscal.cod-estabel <= tt-param.EstabFim,
          first natur-oper
          where natur-oper.nat-operacao = nota-fiscal.nat-operacao
            and natur-oper.tipo = 2 no-lock,
          each it-nota-fisc of nota-fiscal 
               where it-nota-fisc.vl-icms-it <> 0 NO-LOCK,
          first emitente no-lock
                where emitente.cod-emitente = nota-fiscal.cod-emitente,
          first item no-lock 
                where item.it-codigo = it-nota-fisc.it-codigo
          AND (substring(ITEM.fm-codigo,6,2) = "10" OR
               substring(ITEM.fm-codigo,6,2) = "11" OR
               (substring(ITEM.fm-codigo,6,2) = "12" AND substring(ITEM.fm-codigo,1,3) = "400") OR
               substring(ITEM.fm-codigo,6,2) = "13" OR
               substring(ITEM.fm-codigo,6,2) = "14") 
          AND (substring(ITEM.fm-codigo,1,3) = "200" OR
               substring(ITEM.fm-codigo,1,3) = "400"),
          first repres no-lock 
                where repres.cod-rep = nota-fiscal.cod-rep:
          
          RUN pi-unid-neg.

          IF vUnidNegocio <> "EXP" THEN DO:
/*              FOR FIRST unid-neg-fat NO-LOCK                                    */
/*                  WHERE unid-neg-fat.cod-estabel  = nota-fiscal.cod-estabel     */
/*                  AND   unid-neg-fat.serie        = nota-fiscal.serie           */
/*                  AND   unid-neg-fat.nr-nota-fis  = nota-fiscal.nr-nota-fis     */
/*                  AND   unid-neg-fat.nr-seq-fat   = it-nota-fisc.nr-seq-fat     */
/*                  AND   unid-neg-fat.it-codigo    = it-nota-fisc.it-codigo:     */
/*                  ASSIGN vUnidNegocio = unid-neg-fat.cod_unid_negoc             */
/*                         vPercUnid    = unid-neg-fat.perc-unid-neg.             */
/*                  CASE vUnidNegocio:                                            */
/*                      WHEN "CEN" THEN ASSIGN vNomeSup = "CENTRAIS".             */
/*                      WHEN "TER" THEN ASSIGN vNomeSup = "TERMINAIS".            */
/*                      WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".           */
/*                      OTHERWISE  ASSIGN vNomeSup = unid-neg-fat.cod_unid_negoc. */
/*                  END CASE.                                                     */
/*              END.                                                              */
             ASSIGN vUnidNegocio = it-nota-fisc.cod-unid-neg
                    vPercUnid    = 100.

             CASE vUnidNegocio:
                 WHEN "CEN" THEN ASSIGN vNomeSup = "ICORP".
                 WHEN "TER" THEN ASSIGN vNomeSup = "TELECOM".
                 WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".
                 OTHERWISE  ASSIGN vNomeSup = it-nota-fisc.cod-unid-neg.
             END CASE.
          END.
            
            
          RUN piTrataLogItem.

          RUN pi-acompanhar IN h-acomp (INPUT "[Faturamento] Data - Item: " +
                                        STRING(da-data) +  " - " + ITEM.it-codigo).
          if   vlogImportado then
               assign l-tipo = no.
          else assign l-tipo = yes.

          if not nota-fiscal.emite-dup then
               assign l-outras = yes.
          else assign l-outras = no.

          find first tt-resumo  
               where tt-resumo.cod-unidade  = vUnidNegocio
               /* and   tt-resumo.Sequencia    = LOOKUP(vUnidNegocio,cTipo) */
               and   tt-resumo.aliquota-icm = it-nota-fisc.aliquota-icm
               and   tt-resumo.tipo         = l-tipo 
               and   tt-resumo.outras       = l-outras 
               AND   tt-resumo.fm-codigo    = ITEM.fm-codigo no-error.


          if not avail tt-resumo then do:
             create tt-resumo.
             assign tt-resumo.fm-codigo    = ITEM.fm-codigo
                    tt-resumo.cod-unidade  = vUnidNegocio 
                    tt-resumo.Sequencia    = LOOKUP(vUnidNegocio,cTipo)
                    tt-resumo.aliquota-icm = it-nota-fisc.aliquota-icm
                    tt-resumo.tipo         = l-tipo
                    tt-resumo.outras       = l-outras
                    tt-resumo.DesUnidade   = vNomeSup.
          end.

          assign tt-resumo.vl-tot-nota = tt-resumo.vl-tot-nota + it-nota-fisc.vl-tot-item * (vPercUnid / 100)
                 tt-resumo.vl-mercad   = tt-resumo.vl-mercad   + it-nota-fisc.vl-merc-liq  * (vPercUnid / 100)
                 tt-resumo.vl-icms     = tt-resumo.vl-icms     + it-nota-fisc.vl-icms-it   * (vPercUnid / 100).


          IF nota-fiscal.cod-estabel = "101" AND substring(ITEM.fm-codigo,6,2) = "12" THEN DO:
              if it-nota-fisc.aliquota-icm = 7 OR it-nota-fisc.aliquota-icm = 12 OR it-nota-fisc.aliquota-icm = 17 THEN
                  ASSIGN tt-resumo.perc-reducao = 3 / it-nota-fisc.aliquota-icm * 100. 
          END.
          ELSE IF nota-fiscal.cod-estabel = "102" THEN DO:
                 if it-nota-fisc.aliquota-icm = 7 then do:
                    assign tt-resumo.perc-reducao = 57.14. 
                 end.
                 else do:
                    if it-nota-fisc.aliquota-icm = 12 then do:
                       assign tt-resumo.perc-reducao = 75. 
                    end.
                    else do:
                       assign tt-resumo.perc-reducao = 83.33.
                    end.
                 end.
          END.
          ELSE DO:
              if l-tipo then do:
                 assign tt-resumo.perc-reducao = 96.5.
    
                 /* 
                 if it-nota-fisc.aliquota-icm = 7 then do:
                    assign tt-resumo.perc-reducao = 14.29.
                 end.
                 else do:
                    if it-nota-fisc.aliquota-icm = 12 then do:
                       assign tt-resumo.perc-reducao = 50.
                    end.
                    else do:
                       assign tt-resumo.perc-reducao = 64.71.
                    end.
                 end. */
              end.
              else do:
                 if it-nota-fisc.aliquota-icm = 7 then do:
                    assign tt-resumo.perc-reducao = 50. /* 42.86. valor anterior */
                 end.
                 else do:
                    if it-nota-fisc.aliquota-icm = 12 then do:
                       assign tt-resumo.perc-reducao = 70.84.  /* 66.66. valor anterior */
                    end.
                    else do:
                       assign tt-resumo.perc-reducao = 79.42. /* 76.47. valor anterior */
                    end.
                 end.
              end.
          END.
      end.
   end.

   /****** NOTAS DE DEVOLUCAO *******/
                     /*
   do da-data = tt-param.DtEmissaoIni to tt-param.DtEmissaoFim:
      for each docum-est no-lock
          where docum-est.dt-trans = da-data
          and (docum-est.nat-operacao begins "2201" /*"231"*/
           or  docum-est.nat-operacao begins "2202" /*"232"*/
           OR  docum-est.nat-operacao BEGINS "2410"
           or  docum-est.nat-operacao begins "1201" /*"131"*/
           or  docum-est.nat-operacao begins "1202" /*"132"*/
           or  docum-est.nat-operacao begins "3201" /*"321"*/)
            and docum-est.cod-estabel >= tt-param.EstabIni
            and docum-est.cod-estabel <= tt-param.EstabFim,
          each emitente no-lock
               where emitente.cod-emitente = docum-est.cod-emitente,
          each item-doc-est of docum-est no-lock
               where item-doc-est.aliquota-icm <> 0,
          first item no-lock 
                where item.it-codigo = item-doc-est.it-codigo
          AND (substring(ITEM.fm-codigo,6,2) = "10" OR
               substring(ITEM.fm-codigo,6,2) = "11" OR
               substring(ITEM.fm-codigo,6,2) = "13" OR
               substring(ITEM.fm-codigo,6,2) = "14") 
          AND (substring(ITEM.fm-codigo,1,3) = "200" OR
               substring(ITEM.fm-codigo,1,3) = "400"),
          first repres no-lock 
          where repres.cod-rep = emitente.cod-rep:



          RUN pi-acompanhar IN h-acomp (INPUT "[Devolu‡Æo] Data - Item: " +
                                        STRING(da-data) +  " - " + ITEM.it-codigo).

          RUN pi-unid-neg.
          RUN piTrataLogItem.

          if   vlogImportado then
               assign l-tipo = no.
          else assign l-tipo = yes.

          find nota-fiscal no-lock 
               where nota-fiscal.cod-estabel = tt-param.cod-estabel 
                 and nota-fiscal.serie = item-doc-est.serie-comp 
                 and nota-fiscal.nr-nota-fis = item-doc-est.nro-comp
               no-error.

          if avail nota-fiscal and nota-fiscal.emite-dup then
               assign l-outras = no.
          else assign l-outras = yes.

          find first tt-resumo  
               where tt-resumo.cod-unidade  = vUnidNegocio
               /* and   tt-resumo.Sequencia    = LOOKUP(vUnidNegocio,cTipo) */
               and   tt-resumo.aliquota-icm = item-doc-est.aliquota-icm
               and   tt-resumo.tipo         = l-tipo 
               and   tt-resumo.outras       = l-outras
               AND   tt-resumo.fm-codigo    = ITEM.fm-codigo no-error.
          
          if not avail tt-resumo then do:

              /*  
              IF l-outras = YES THEN DO:
                 cont = cont + 1.
              END.
              */


             create tt-resumo.
             assign tt-resumo.cod-unidade  = vUnidNegocio 
                    tt-resumo.Sequencia    = LOOKUP(vUnidNegocio,cTipo)
                    tt-resumo.DesUnidade   = vNomeSup

                    tt-resumo.aliquota-icm = item-doc-est.aliquota-icm
                    tt-resumo.tipo         = l-tipo
                    tt-resumo.outras = l-outras.
             if l-tipo then do:
                assign tt-resumo.perc-reducao = 96.5.
             end.
             else do:
                if item-doc-est.aliquota-icm = 7 then do:
                   assign tt-resumo.perc-reducao = 50.  /* 42.86. valor anterior */
                end.
                else do:
                   if item-doc-est.aliquota-icm = 12 then do:
                      assign tt-resumo.perc-reducao = 70.84. /* 66.66. valor anterior */
                   end.
                   else do:
                      assign tt-resumo.perc-reducao = 79.42. /* 76.47. valor anterior */
                   end.
                end.
             end.
          end.
          
          assign tt-resumo.vl-devol = tt-resumo.vl-devol + 
                                      (item-doc-est.valor-icm[1] * (tt-resumo.perc-reducao / 100) * (vPercUnid / 100)).
      end.   
   end. */
END PROCEDURE.




PROCEDURE piImprimeRelatRes:
    for each tt-resumo
        BREAK BY tt-resumo.Sequencia  
              BY tt-resumo.cod-unidade
              BY tt-resumo.tipo:
        RUN pi-acompanhar IN h-acomp (INPUT "Calculando: " + tt-resumo.cod-unidade).
        assign tt-resumo.vl-cred-pres = tt-resumo.vl-cred-pres +
                                        (tt-resumo.vl-icms *
                                        (tt-resumo.perc-reducao / 100)).
    end.
    if tt-param.formato-excel = yes then do:
       put "Unid.Neg                                ;Tipo     ;Notas  ;Total Nota      ;Vlr.Mercad.     ;vlr ICMS        ;Aliq  ;Perc.Red. ;VlCred.Pr ;Devolu‡Æo ;Cred Pr Comp." skip.
    end.
    
    for each tt-resumo
        BREAK BY tt-resumo.Sequencia  
              BY tt-resumo.cod-unidade
              BY tt-resumo.tipo:
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo: " + 
                                      string(tt-resumo.tipo) +
                                      string(tt-resumo.outras)).
        IF FIRST-OF(tt-resumo.cod-unidade) THEN
        DO:
            if tt-param.formato-excel = no then
                PUT "Unidade Neg¢cio.: " tt-resumo.DesUnidade SKIP(1).
            ASSIGN vDeValor = 0.
        END.
        ASSIGN vDeValor = tt-resumo.vl-cred-pres - tt-resumo.vl-devol.
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo: " + tt-resumo.cod-unidade).
        if tt-param.formato-excel = yes then do:
            put  tt-resumo.DesUnidade       ";" 
                 tt-resumo.tipo             ";"      
                 tt-resumo.outras           ";"   
                 tt-resumo.vl-tot-nota      ";"
                 tt-resumo.vl-mercad        ";"
                 tt-resumo.vl-icms          ";"
                 tt-resumo.aliquota-icm     ";"
                 tt-resumo.perc-reducao     ";"
                 tt-resumo.vl-cred-pres     ";"
                 tt-resumo.vl-devol         ";"
                 vDeValor skip.
        end.
        else do:        
            disp tt-resumo.tipo             
                 tt-resumo.outras           
                 tt-resumo.vl-tot-nota      
                 tt-resumo.vl-mercad        
                 tt-resumo.vl-icms          
                 tt-resumo.aliquota-icm     
                 tt-resumo.perc-reducao     
                 tt-resumo.vl-cred-pres     
                 tt-resumo.vl-devol         
                 vDeValor
                 with frame f-corpo.
            DOWN WITH FRAME f-corpo.
            IF LAST-OF(tt-resumo.cod-unidade) THEN
                PUT SKIP(1).
        end.
    end.
END PROCEDURE.



PROCEDURE piImprimeRelatDet:
          
   if tt-param.formato-excel = yes then 
       put "Nota            ;Nat.Op;Dt.Emissao;UF  ;Item   ;Qtd.Faturada ;Vlr.Total It.   ;Vlr.Mercadoria  ;Vlr.Icms It.    ;Al.ICM;vlr.IPI         ;Al.IPI;Ben;Imp;Uni;Familia ;Cl.Fiscal ;Nome Emitente" skip.
   do da-data = tt-param.DtEmissaoIni to tt-param.DtEmissaoFim:
      for each nota-fiscal no-lock 
          where nota-fiscal.dt-emis-nota = da-data
            and nota-fiscal.dt-cancel = ?
            and nota-fiscal.nat-operacao >= tt-param.NatOperacaoIni
            and nota-fiscal.nat-operacao <= tt-param.NatOperacaoFim
            and nota-fiscal.estado >= tt-param.EstadoIni
            and nota-fiscal.estado <= tt-param.EstadoFim
            and nota-fiscal.cod-estabel >= tt-param.EstabIni
            and nota-fiscal.cod-estabel <= tt-param.EstabFim,
          first natur-oper
          where natur-oper.nat-operacao = nota-fiscal.nat-operacao
            and natur-oper.tipo = 2 no-lock,
            
          each it-nota-fisc of nota-fiscal 
               where it-nota-fisc.vl-icms-it <> 0 NO-LOCK,
          first emitente no-lock
                where emitente.cod-emitente = nota-fiscal.cod-emitente,
          first item no-lock 
                where item.it-codigo = it-nota-fisc.it-codigo
          AND (substring(ITEM.fm-codigo,6,2) = "10" OR
               substring(ITEM.fm-codigo,6,2) = "11" OR
               (substring(ITEM.fm-codigo,6,2) = "12" AND substring(ITEM.fm-codigo,1,3) = "400") OR
               substring(ITEM.fm-codigo,6,2) = "13" OR
               SUBSTRING(ITEM.fm-codigo,6,2) = "14") 
          AND (substring(ITEM.fm-codigo,1,3) = "200" OR
               substring(ITEM.fm-codigo,1,3) = "400"),
          first repres no-lock 
          where repres.cod-rep = nota-fiscal.cod-rep:

          RUN pi-unid-neg.

          RUN piTrataLogItem.

          RUN pi-acompanhar IN h-acomp (INPUT "[Faturamento] Data - Item: " +
                                        STRING(da-data) +  " - " + ITEM.it-codigo).
          if tt-param.formato-excel = yes then do:
                put  nota-fiscal.nr-nota-fis ";"
                     nota-fiscal.nat-operacao ";"
                     nota-fiscal.dt-emis ";"
                     nota-fiscal.estado ";"
                     it-nota-fisc.it-codigo format "X(7)" ";"
                     it-nota-fisc.qt-faturada[1] ";"
                     it-nota-fisc.vl-tot-item ";"
                     it-nota-fisc.vl-merc-liq ";"
                     it-nota-fisc.vl-icms-it ";"
                     it-nota-fisc.aliquota-icm ";"
                     it-nota-fisc.vl-ipi-it ";"
                     it-nota-fisc.aliquota-ipi ";"
                     vlogBeneficiado          ";"
                     vlogImportado            ";"
                     vUnidNegocio ";"
                     ITEM.fm-codigo ";"
                     item.class-fiscal ";"
                     emitente.nome-emit skip.
          end.
          else do:
                disp nota-fiscal.nr-nota-fis 
                     nota-fiscal.nat-operacao 
                     nota-fiscal.dt-emis 
                     nota-fiscal.estado 
                     it-nota-fisc.it-codigo format "X(7)"
                     it-nota-fisc.qt-faturada[1]
                     it-nota-fisc.vl-tot-item 
                     it-nota-fisc.vl-merc-liq 
                     it-nota-fisc.vl-icms-it 
                     it-nota-fisc.aliquota-icm 
                     it-nota-fisc.vl-ipi-it 
                     it-nota-fisc.aliquota-ipi 
                     vlogBeneficiado          column-label "Port"
                     vlogImportado            column-label "Import"
                     vUnidNegocio
                     ITEM.fm-codigo
                     item.class-fiscal 
                     emitente.nome-emit WITH WIDTH 250 STREAM-IO.
         end.
      end.
   end.





   /****** NOTAS DE DEVOLUCAO *******/
   
   PUT " " SKIP(2)
       "Notas de devolu‡Æo " SKIP(2).
   
   do da-data = tt-param.DtEmissaoIni to tt-param.DtEmissaoFim:
      FOR EACH devol-cli FIELDS (dt-devol) NO-LOCK
           WHERE devol-cli.cod-estabel >= tt-param.EstabIni
           and   devol-cli.cod-estabel <= tt-param.EstabFim 
           AND   devol-cli.dt-devol    = da-data,
           FIRST emitente fields(cod-emitente cgc nome-abrev cod-gr-cli nome-emit) NO-LOCK
                 WHERE emitente.cod-emitente = devol-cli.cod-emitente,
           FIRST nota-fiscal FIELDS (cod-estabel serie nr-nota-fis dt-emis-nota nr-pedcli no-ab-reppri cod-rep nr-fatura vl-tot-nota nome-transp cidade-cif emite-dup estado) NO-LOCK
                 WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
                 AND   nota-fiscal.serie         = devol-cli.serie
                 AND   nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
                 AND   nota-fiscal.emite-duplic,
           FIRST natur-oper FIELDS (atual-estat) NO-LOCK
                 WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                 AND   natur-oper.atual-estat,
           EACH item-doc-est FIELDS (nat-operacao nro-docto serie-docto valor-iss vl-subs valor-icm preco-total valor-ipi seq-comp quantidade aliquota-icm aliquota-ipi) OF devol-cli NO-LOCK,
           FIRST item FIELDS (it-codigo fm-cod-com fm-codigo class-fiscal) NO-LOCK
                 WHERE item.it-codigo = devol-cli.it-codigo:
   
          RUN pi-acompanhar IN h-acomp (INPUT "[Devolu‡Æo] Data - Item: " +
                                        STRING(da-data) +  " - " + ITEM.it-codigo).

          RUN pi-unid-neg.
          RUN piTrataLogItem.

          if   vlogImportado then
               assign l-tipo = no.
          else assign l-tipo = yes.

          if nota-fiscal.emite-dup then
               assign l-outras = no.
          else assign l-outras = yes.

          RUN piTrataLogItem.

          RUN pi-acompanhar IN h-acomp (INPUT "[Faturamento] Data - Item: " +
                                        STRING(da-data) +  " - " + ITEM.it-codigo).
          if tt-param.formato-excel = yes then do:
                put  nota-fiscal.nr-nota-fis ";"
                     nota-fiscal.nat-operacao ";" 
                     nota-fiscal.dt-emis ";"
                     nota-fiscal.estado ";"
                     ITEM.it-codigo format "X(7)" ";"
                     item-doc-est.quantidade ";"
                     item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] FORMAT ">>>>,>>>,>>9.99"  ";"
                     item-doc-est.preco-total[1]  FORMAT ">>>>>,>>>,>>9.99" ";"
                     item-doc-est.valor-icm[1] FORMAT ">>>>>,>>>,>>9.99" ";"
                     item-doc-est.aliquota-icm ";"
                     item-doc-est.valor-ipi[1] FORMAT ">>>>>,>>>,>>9.99" ";"
                     item-doc-est.aliquota-ipi ";"
                     vlogBeneficiado           ";"
                     vlogImportado             ";"
                     vUnidNegocio ";"
                     ITEM.fm-codigo ";"
                     item.class-fiscal  ";"
                     emitente.nome-emit skip.
          end.
          else do:
                disp nota-fiscal.nr-nota-fis 
                     nota-fiscal.nat-operacao 
                     nota-fiscal.dt-emis 
                     nota-fiscal.estado 
                     ITEM.it-codigo format "X(7)"
                     item-doc-est.quantidade
                     item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] FORMAT ">>>>,>>>,>>9.99" LABEL "Vl Total Item"
                     item-doc-est.preco-total[1] LABEL "Vl Mercad Liq" FORMAT ">>>>>,>>>,>>9.99"
                     item-doc-est.valor-icm[1] FORMAT ">>>>>,>>>,>>9.99"
                     item-doc-est.aliquota-icm
                     item-doc-est.valor-ipi[1] FORMAT ">>>>>,>>>,>>9.99"
                     item-doc-est.aliquota-ipi 
                     vlogBeneficiado          column-label "Port"
                     vlogImportado            column-label "Import"
                     vUnidNegocio
                     ITEM.fm-codigo
                     item.class-fiscal 
                     emitente.nome-emit WITH WIDTH 250 STREAM-IO.
          end.
      END.
   end.

END PROCEDURE.


PROCEDURE pi-unid-neg.
/*     find first unid-neg-item no-lock                                      */
/*          where unid-neg-item.it-codigo = item.it-codigo no-error.         */
/*     if   avail unid-neg-item then                                         */
/*          assign vUnidNegocio = unid-neg-item.cod_unid_negoc.              */
/*     ELSE DO:                                                              */
/*         FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*              WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*         if   avail unid-neg-fam-com then                                  */
/*              assign vUnidNegocio = unid-neg-fam-com.cod_unid_negoc.       */
/*         else assign vUnidNegocio = "INVALIDA".                            */
/*     END.                                                                  */
    
    ASSIGN vUnidNegocio  = ITEM.cod-unid-negoc.
      
    

END PROCEDURE.

PROCEDURE piTrataLogItem.
  ASSIGN vlogImportado   =  substring(ITEM.fm-codigo,6,2) = "10" OR substring(ITEM.fm-codigo,6,2) = "11" /*ITEM.codigo-orig <> 1*/
         vlogBeneficiado = (substring(ITEM.fm-codigo,6,2) = "13").
END PROCEDURE.


PROCEDURE pi-itens-lei-informatica.
    PUT skip(5).
    PUT "RELATORIO DE ITENS BENEFICIADOS PELA LEI DE INFORMµTICA" SKIP(2).

    FOR EACH ITEM NO-LOCK
        WHERE (substring(ITEM.fm-codigo,6,2) = "10" OR
             substring(ITEM.fm-codigo,6,2) = "11" OR
               substring(ITEM.fm-codigo,6,2) = "13" OR
             SUBSTRING(ITEM.fm-codigo,6,2) = "14") 
        AND (substring(ITEM.fm-codigo,1,3) = "200" OR
             substring(ITEM.fm-codigo,1,3) = "400"):
        RUN pi-acompanhar IN h-acomp (INPUT "Relat¢rio de itens Lei de Inform tica: " +
                                      ITEM.it-codigo).
        DISP ITEM.it-codigo
             ITEM.desc-item
             ITEM.fm-codigo WITH WIDTH 300.
    END.
END PROCEDURE.
