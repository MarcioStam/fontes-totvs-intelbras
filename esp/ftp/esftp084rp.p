/*****************************************************************************
**     Programa.........: esp/acr/ESFTP084rp.p
**     Descricao .......: Relat¢rio Duplicatas
**     Versao...........: 1.00.000
**     Autor............: Cenci
**     Criado...........: 20/07/2011
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP084 2.04.00.001}

{esp/ftp/esftp084tt.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{cdp/cd0666.i}
{esinc/es0006.i}  /*** include com a procedure pi-busca-unid-negoc-item ***/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE de-val-iss-retid  AS DECIMAL   FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE de-vl-ir-adic     AS DECIMAL   FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE c-data-devol-gko  AS CHAR                               NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE l-devol-parcial AS LOGICAL   INIT NO  NO-UNDO.

def var h-acomp      as handle no-undo.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="0"}


FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Demonstrativo de Resultado"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP084"
       c-versao       = "2.04"
       c-revisao      = "001".

/******** FAZ A CARGA DOS DADOS NA TABELA TEMPORARIA *******/
run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Calculando...").
  

run pi-acompanhar in h-acomp (input "Rateando por unidade de neg¢cio ..").


run pi-inicializar in h-acomp (input "Imprimindo...").
run pi-acompanhar in h-acomp (input "Imprimindo NFS").

/*imprime cabecalho*/
PUT UNFORMATTED
    "Cliente;Nome;Estab;Serie;Titulo;Parcela;Dt.Emissao;Vencimento;Data de Entrega;Data de Devolucao GKO;Valor Original;Valor ISS Retido;IR Adicional;Previsao de Entrega;Dt.Saida;Transportador;Grupo Cobran‡a" SKIP.

for each nota-fiscal no-lock USE-INDEX ch-distancia
       where nota-fiscal.cod-estabel   >= tt-param.cod-estab-ini
         and nota-fiscal.cod-estabel   <= tt-param.cod-estab-fim
         and nota-fiscal.dt-emis-nota  >= tt-param.da-data-ini
         and nota-fiscal.dt-emis-nota  <= tt-param.da-data-fim
         and nota-fiscal.dt-cancela     = ?
       BY nota-fiscal.dt-emis-nota
       BY nota-fiscal.nr-nota-fis:
    
       run pi-acompanhar in h-acomp (INPUT "Faturamento. Data: " + STRING(nota-fiscal.dt-emis-nota) + "   NF: " + nota-fiscal.nr-nota-fis). 
       
       find FIRST emitente 
            where emitente.cod-emitente = nota-fiscal.cod-emitente
            no-lock no-error.
       IF NOT AVAIL emitente THEN DO:
           RUN piCriaErro(INPUT 17006,
                          INPUT "NÆo Encontrado Cliente para a Nota.: " + nota-fiscal.nr-nota-fis + ".Favor Verificar").
            NEXT. 
       END.
    
       /*validando parametros selecao*/
       IF nota-fiscal.cod-emitente < tt-param.cod-emitente-ini OR 
          nota-fiscal.cod-emitente > tt-param.cod-emitente-fim 
       THEN NEXT.

       IF nota-fiscal.cod-rep < tt-param.cod-rep-ini OR 
          nota-fiscal.cod-rep > tt-param.cod-rep-fim 
       THEN NEXT.

       IF emitente.cod-gr-cli < tt-param.cod-gr-cli-ini OR 
          emitente.cod-gr-cli > tt-param.cod-gr-cli-fim 
       THEN NEXT.

       IF emitente.cgc < tt-param.raiz-ini OR 
          emitente.cgc > tt-param.raiz-fim 
       THEN NEXT.

       FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
       IF natur-oper.atual-estat = NO 
       THEN NEXT.

       FIND int-emitente NO-LOCK
           WHERE int-emitente.cod-emitente  = nota-fiscal.cod-emitente 
             AND int-emitente.cod-gr-cob   >= tt-param.cod-gr-cob-ini
             AND int-emitente.cod-gr-cob   <= tt-param.cod-gr-cob-fim NO-ERROR.

       IF  NOT AVAIL int-emitente
       THEN NEXT.

       ASSIGN de-val-iss-retid = 0
              de-vl-ir-adic    = 0.
       FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
           ASSIGN de-val-iss-retid = de-val-iss-retid + DECIMAL(SUBSTRING(it-nota-fisc.char-2,218,14))
                  de-vl-ir-adic    = de-vl-ir-adic    + it-nota-fisc.vl-ir-adic.   
       END.

       FOR EACH  fat-duplic NO-LOCK
           WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel  
             AND fat-duplic.serie       = nota-fiscal.serie
             AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

           FIND FIRST int-nota-fiscal NO-LOCK
               WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                 AND int-nota-fiscal.serie       = nota-fiscal.serie
                 AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis  NO-ERROR.

           PUT UNFORMATTED nota-fiscal.cod-emitente ";" 
                           emitente.nome-emit       ";"
                           nota-fiscal.cod-estabel  ";"
                           nota-fiscal.serie        ";"
                           fat-duplic.nr-fatura     ";"
                           fat-duplic.parcela       ";"
                           nota-fiscal.dt-emis-nota FORMAT "99/99/9999" ";"
                           fat-duplic.dt-venciment  FORMAT "99/99/9999" ";"
                           nota-fiscal.dt-entr-cli  FORMAT "99/99/9999" ";".

           IF  AVAIL     int-nota-fiscal AND 
               SUBSTRING(int-nota-fiscal.char-1,61,10) <> '' 
           THEN DO:
               ASSIGN c-data-devol-gko = REPLACE(SUBSTRING(int-nota-fiscal.char-1,61,10),CHR(10),"")
                      c-data-devol-gko = REPLACE(c-data-devol-gko,CHR(11),"")
                      c-data-devol-gko = REPLACE(c-data-devol-gko,CHR(12),"")
                      c-data-devol-gko = REPLACE(c-data-devol-gko,CHR(13),"").
               PUT c-data-devol-gko ";".
           END.
           ELSE DO:

               ASSIGN l-devol-parcial = NO.
               FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                   FIND FIRST devol-cli NO-LOCK                              
                       WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel 
                         AND devol-cli.serie       = nota-fiscal.serie       
                         AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis 
                         AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat
                         AND devol-cli.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                   IF NOT AVAIL devol-cli THEN
                       ASSIGN l-devol-parcial = YES.
                   ELSE
                       IF devol-cli.qt-devolvida <> it-nota-fisc.qt-faturada[1] THEN
                           ASSIGN l-devol-parcial = YES.
               END.

               IF l-devol-parcial = NO THEN DO:
                   FIND FIRST devol-cli NO-LOCK
                       WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                         AND devol-cli.serie       = nota-fiscal.serie      
                         AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                   IF AVAIL devol-cli 
                   THEN
                       PUT devol-cli.dt-devol FORMAT "99/99/9999" ";".
                   ELSE
                       PUT ";".
               END. /* IF l-devol-parcial = NO THEN DO: */
               ELSE
                   PUT ";".
           END.

           

           
           PUT UNFORMATTED fat-duplic.vl-parcela   ";"
                           de-val-iss-retid        ";"
                           de-vl-ir-adic           ";" 
                           IF AVAIL int-nota-fiscal THEN trim(SUBSTRING(int-nota-fiscal.char-1,50,10)) ELSE "" ";"
                           nota-fiscal.dt-saida FORMAT "99/99/9999" ";"
                           nota-fiscal.nome-transp ";"
                           int-emitente.cod-gr-cob SKIP.
           
           ASSIGN de-val-iss-retid = 0
                  de-vl-ir-adic    = 0.
       END.
END.
run pi-finalizar in h-acomp.

RETURN "OK".

