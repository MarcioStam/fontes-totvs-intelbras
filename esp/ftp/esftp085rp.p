{include/i-prgvrs.i esftp085 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\esftp055RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2008
**  Descricao.: Relatorio Reconhecimento do Faturamento
**  VersÆo....: 001 15/07/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
    {esp/ftp/esftp085tt.i}
    
    {esp/es0006a.i}
    {esp/es0006.i}

    {upc/btb910za-upc.i}
    {esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
    {utp/utapi019.i}
    {include/tt-edit.i}

{include/i-rpvar.i}

/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */

    DEF VAR c-arq AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-first-of  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-last-of   AS LOGICAL     NO-UNDO.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF TEMP-TABLE tt-unid-neg
    FIELD cod-unid-neg AS CHAR
    FIELD valor        AS DEC
    INDEX ch_unid cod-unid-neg.

/* DEF BUFFER b-docto-frete-nf FOR docto-frete-nf. */
DEF BUFFER b-nota-fiscal FOR nota-fiscal.
DEFINE VARIABLE c-tipo-frete        AS  CHARACTER FORMAT "x(25)"   NO-UNDO.
DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
DEFINE VARIABLE deValor             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-calculo       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-informado     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-dif           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-conhecimento      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-docto        AS INTEGER  FORMAT ">9"   NO-UNDO.
DEFINE VARIABLE de-vl-calculo-tot   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-informado-tot AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-diferenca-tot    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-nota         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-percentual       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total-notas      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dt-dt-docto         AS DATE        NO-UNDO.
DEFINE VARIABLE  de-valor-179       AS DECIMAL     NO-UNDO  COLUMN-LABEL "1,79" .
/* DEFINE VARIABLE c-conta-credito     LIKE movct-tr.conta-credito NO-UNDO. */
DEFINE VARIABLE iempresa AS INTEGER     NO-UNDO.
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Reconhecimento do Faturamento"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "esftp085"
       c-versao       = "2.04"
       c-revisao      = "001".

/* form nota-fiscal.nr-nota-fis                                      */
/*      nota-fiscal.serie                                            */
/*      nota-fiscal.nat-operacao                                     */
/*      nota-fiscal.nome-ab-cli                                      */
/*      nota-fiscal.cidade                                           */
/*      nota-fiscal.estado                                           */
/*      nota-fiscal.dt-emis-nota                                     */
/*      nota-fiscal.dt-saida                                         */
/*      nota-fiscal.nome-transp                                      */
/*      nota-fiscal.emite-duplic   COLUMN-LABEL "Emi.Dup"            */
/*      c-tipo-frete               COLUMN-LABEL "Tipo Frete"         */
/*      devol-cli.nro-docto                                          */
/*      devol-cli.serie-docto                                        */
/*      tt-unid-neg.cod-unid-neg   COLUMN-LABEL "Und.Neg."           */
/*      tt-unid-neg.valor          COLUMN-LABEL "Valor Por UN."      */
/*      nota-fiscal.vl-tot-nota AT 212 COLUMN-LABEL "Vlr Total Nota" */
/*      de-valor-179            AT 230 COLUMN-LABEL "1,79%"          */
/*      c-tipo-docto    AT 240     COLUMN-LABEL "TF"                 */
/*      c-conta-credito AT 243     COLUMN-LABEL "Conta "             */
/*      dt-dt-docto     AT 263     COLUMN-LABEL "Dt.Docto"           */
/*      c-conhecimento  AT 283     COLUMN-LABEL "Conhec"             */
/*      de-vl-calculo   AT 303     COLUMN-LABEL "Vlr Calculo"        */
/*      de-vl-informado AT 323     COLUMN-LABEL "Vlr Informado"      */
/*      de-vl-dif       AT 343     COLUMN-LABEL "Diferenca"          */
/*                                                                   */
/*                                                                   */
/* WITH FRAME f-detalhe STREAM-IO WIDTH 500 64 DOWN.                 */

/* ***************************  Main Block  *************************** */
/* DEFINE VARIABLE hDBOtr098 AS HANDLE      NO-UNDO.       */
/* IF NOT VALID-HANDLE (hDBOtr098) OR                      */
/*   hDBOtr098:TYPE <> "PROCEDURE":U OR                    */
/*   hDBOtr098:FILE-NAME <> "trbo/botr098.p" THEN          */
/*   RUN VALUE("trbo/botr098.p") PERSISTENT SET hDBOtr098. */
/*                                                         */
/* RUN openQueryStatic IN hDBOtr098 ("Main":U).            */

DEF STREAM s-arq.                                                                        
do on stop undo, leave:

/*     {include/i-rpcab.i}                */
    {include/i-rpout.i &pagesize="64"}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.


   {include/i-rpclo.i}
   run pi-finalizar in h-acomp.
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */



PROCEDURE piImprimeRelat:
    DEF VAR c-arq AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.


    PUT "Nota Fis      ;   Ser ;  Nat Oper; Cliente/Fornec ;Cidade ;                   UF  ; EmissÆo ;   Sai Merc ;  Transp ;      Emi.Dup; Tipo Frete; Doc Ent ;         Ser  ; Und.Neg. ;Valor Por UN. ;       Vlr Total Nota ; 1,97% ;TF  ; Conta          ;  Dt.Docto; Conhec  ;  Vlr Calculo;    Vlr Informado ; Diferenca    ; " SKIP.

    IF tt-param.tb-parametro = YES  THEN DO:
        FOR EACH nota-fiscal USE-INDEX ch-distancia
            WHERE nota-fiscal.dt-emis-nota >= date(string(MONTH(TODAY),"99") + "/01/" + STRING(YEAR(TODAY))) 
              AND nota-fiscal.cod-estabel >= "101"
              AND nota-fiscal.nome-transp <> "retira"
              AND nota-fiscal.nome-transp <> "sedex"
              AND nota-fiscal.dt-cancel = ? NO-LOCK,
             FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel   = nota-fiscal.cod-estabel,
/*              FIRST nota-fiscal-tr NO-LOCK                                 */
/*              WHERE nota-fiscal-tr.cgc-rem  = estabelec.cgc                */
/*                AND nota-fiscal-tr.nr-nf    = int(nota-fiscal.nr-nota-fis) */
/*                AND nota-fiscal-tr.cd-serie = nota-fiscal.serie,           */
            FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
              AND natur-oper.tipo = 2
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.nome-transp
                  BY nota-fiscal.dt-emis-nota:
            RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Nota:" + string(nota-fiscal.dt-emis-nota,"99/99/9999")).
            ASSIGN l-first-of = first-of(nota-fiscal.nome-transp)
                   l-last-of  = last-of(nota-fiscal.nome-transp).


           
            RUN pi-Imprime.
        END.
    END.
    ELSE DO:
        FOR EACH nota-fiscal USE-INDEX ch-distancia
            WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-ini
              AND nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-fim
              AND nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini
              AND nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim
              AND nota-fiscal.cod-emitente >= tt-param.cod-cli-ini
              AND nota-fiscal.cod-emitente <= tt-param.cod-cli-fim
              AND nota-fiscal.dt-cancel = ? NO-LOCK,

            FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel   = nota-fiscal.cod-estabel,
/*             FIRST nota-fiscal-tr NO-LOCK                                 */
/*             WHERE nota-fiscal-tr.cgc-rem  = estabelec.cgc                */
/*               AND nota-fiscal-tr.nr-nf    = int(nota-fiscal.nr-nota-fis) */
/*               AND nota-fiscal-tr.cd-serie = nota-fiscal.serie,           */

            FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
              AND natur-oper.tipo = 2,
            FIRST transporte NO-LOCK
            WHERE transporte.nome-abrev = nota-fiscal.nome-transp
              AND transporte.cod-transp >= tt-param.cod-transp-ini
              AND transporte.cod-transp <= tt-param.cod-transp-fim
            BREAK BY nota-fiscal.cod-estabel
                  BY nota-fiscal.nome-transp
                  BY nota-fiscal.dt-emis-nota:
            RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Nota:" + string(nota-fiscal.dt-emis-nota,"99/99/9999")).
            ASSIGN l-first-of = first-of(nota-fiscal.nome-transp)
                   l-last-of  = last-of(nota-fiscal.nome-transp).
            RUN pi-Imprime.
        END.

    END.
    PUT "" SKIP
                "Totais"
                 de-vl-calculo-tot     FORMAT "->>>,>>>,>>9.99" AT 117
                 de-vl-informado-tot   FORMAT "->>>>,>>>,>>9.99"
                 de-diferenca-tot      FORMAT "->>>,>>9.99"
                 de-tot-nota           FORMAT "->>>>>>,>>>,>>9.99"
                 de-percentual         FORMAT " >>>,>>9.99" SKIP.
END PROCEDURE.
PROCEDURE pi-imprime:
    DEFINE VARIABLE c-unid-neg  AS CHARACTER   NO-UNDO.
    EMPTY TEMP-TABLE tt-unid-neg.
    FOR EACH  it-nota-fisc OF nota-fiscal NO-LOCK:
/*         assign c-unid-neg = "".                                               */
/*         find first unid-neg-item no-lock                                      */
/*              where unid-neg-item.it-codigo = item.it-codigo no-error.         */
/*         if   avail unid-neg-item then                                         */
/*              assign c-unid-neg = unid-neg-item.cod_unid_negoc.                */
/*         ELSE DO:                                                              */
/*             FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*                  WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*             if   avail unid-neg-fam-com then                                  */
/*                  assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.         */
/*             else assign c-unid-neg = "".                                      */
/*         END.                                                                  */
/*                                                                               */
/*         IF c-unid-neg = "" THEN                                               */
/*             for each unid-neg-fat no-lock                                     */
/*                 where unid-neg-fat.cod-estabel = it-nota-fisc.cod-estabel     */
/*                   and unid-neg-fat.serie       = it-nota-fisc.serie           */
/*                   and unid-neg-fat.nr-nota-fis = it-nota-fisc.nr-nota-fis     */
/*                   and unid-neg-fat.nr-seq-fat  = it-nota-fisc.nr-seq-fat      */
/*                   and unid-neg-fat.it-codigo   = it-nota-fisc.it-codigo:      */
/*                assign c-unid-neg = unid-neg-fat.cod_unid_negoc.               */
/*             end.                                                              */

       ASSIGN c-unid-neg = it-nota-fisc.cod-unid-neg.

       FIND tt-unid-neg
            WHERE tt-unid-neg.cod-unid-neg = c-unid-neg
            exclusive-LOCK NO-ERROR.
       IF NOT AVAIL tt-unid-neg THEN DO:
           CREATE tt-unid-neg.
           ASSIGN tt-unid-neg.cod-unid-neg = c-unid-neg.
       END.
       ASSIGN tt-unid-neg.valor = tt-unid-neg.valor + it-nota-fisc.vl-tot-item.
    END.
    IF l-first-of THEN DO:
        IF NOT AVAIL emitente THEN
           ASSIGN c-arq = session:temp-directory + "Transp_.txt".
        ELSE
            ASSIGN c-arq = session:temp-directory + "Transp_" + trim(nota-fiscal.cod-estabel) + "_" +  STRING(emitente.cod-emitente) + ".txt".
        OUTPUT STREAM s-arq TO value(c-arq).
        PUT STREAM s-arq  "Relacao de Notas Sem conhecimentos " SKIP
                          "Data Inicial: " TODAY - 60 SKIP(2).
        ASSIGN i-cont = 0.
    END.

    FIND FIRST devol-cli 
         WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel   
           AND devol-cli.serie       = nota-fiscal.serie         
           AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis    
         NO-LOCK NO-ERROR.

    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.09' &THEN
        FIND FIRST modalid-frete 
             WHERE modalid-frete.cod-modalid-frete = nota-fiscal.cod-modalid-frete no-lock no-error.
        IF AVAIL modalid-frete then
           ASSIGN c-tipo-frete = modalid-frete.des-modalid-frete.
        ELSE 
           ASSIGN c-tipo-frete = "".
   &ELSE
       FIND FIRST modalid-frete 
            WHERE modalid-frete.cod-modalid-frete = SUBSTR(nota-fiscal.char-2,201,8) no-lock no-error.
       IF AVAIL modalid-frete then
          ASSIGN c-tipo-frete = modalid-frete.des-modalid-frete.
       ELSE 
          ASSIGN c-tipo-frete = "".
   &ENDIF
   
/*     CASE nota-fiscal-tr.id-tipo-frete:                              */
/*             WHEN 1 THEN ASSIGN c-tipo-frete = "CIF".                */
/*             WHEN 2 THEN ASSIGN c-tipo-frete = "CIF COM REDESPACHO". */
/*             WHEN 3 THEN ASSIGN c-tipo-frete = "FOB".                */
/*             WHEN 4 THEN ASSIGN c-tipo-frete = "FOB COM REDESPACHO". */
/*     END CASE.                                                       */

    IF c-conhecimento = "" OR
       tt-param.lista-conhecimentos THEN DO:
        PUT  STREAM s-arq nota-fiscal.nr-nota-fis
             nota-fiscal.serie
             nota-fiscal.nat-operacao
             nota-fiscal.nome-ab-cli
             nota-fiscal.cidade
             nota-fiscal.estado
             nota-fiscal.dt-emis-nota
             nota-fiscal.dt-saida
             nota-fiscal.nome-transp 
             nota-fiscal.emite-duplic
             c-tipo-frete SKIP.
        

        IF AVAIL devol-cli THEN
           PUT STREAM s-arq devol-cli.nro-docto ";"
                             devol-cli.serie-docto ";".
        


        PUT nota-fiscal.nr-nota-fis          ";"
             nota-fiscal.serie               ";"
             nota-fiscal.nat-operacao        ";"
             nota-fiscal.nome-ab-cli         ";"
             nota-fiscal.cidade              ";"
             nota-fiscal.estado              ";"
             nota-fiscal.dt-emis-nota        ";"
             nota-fiscal.dt-saida            ";"
             nota-fiscal.nome-transp         ";"
             nota-fiscal.emite-duplic        ";"
             c-tipo-frete ";".
             
        IF AVAIL devol-cli THEN
           PUT devol-cli.nro-docto          ";"
                devol-cli.serie-docto        ";".
        ELSE PUT ";;".
           
        PUT ";;".

        ASSIGN i-cont = i-cont + 1.
    END.

    IF tt-param.lista-conhecimentos THEN DO:     
          ASSIGN de-valor-179 =   nota-fiscal.vl-tot-nota * 1.79 / 100 .
          PUT nota-fiscal.vl-tot-nota ";"
               de-valor-179            ";" .
          
        
          FOR EACH tt-unid-neg:
              PUT    nota-fiscal.nr-nota-fis at 1 ";" 
                     nota-fiscal.serie      "; ;;;;;;;; ;; ;"
                     tt-unid-neg.cod-unid-neg ";"
                     tt-unid-neg.valor ";;;" SKIP.
          END.
                   
    END.


    ASSIGN deValor         = 0
           de-vl-calculo   = 0
           de-vl-informado = 0
           c-conhecimento  = ""
           dt-dt-docto     = ?.


/*     FOR   EACH docto-frete-nf                                                                              */
/*          WHERE docto-frete-nf.cgc-rem = estabelec.cgc                                                      */
/*            AND docto-frete-nf.nr-nf   = INT(nota-fiscal.nr-nota-fis)                                       */
/*            AND docto-frete-nf.cd-serie = nota-fiscal.serie NO-LOCK,                                        */
/*                                                                                                            */
/*         FIRST movtrp.docto-frete NO-LOCK                                                                   */
/*         WHERE docto-frete.id-tp-docto      = docto-frete-nf.id-tp-docto                                    */
/*           AND docto-frete.cnpj-emit        = docto-frete-nf.cnpj-emit                                      */
/*           AND docto-frete.serie            = docto-frete-nf.serie                                          */
/*           AND docto-frete.nr-documento     = docto-frete-nf.nr-documento                                   */
/*           AND docto-frete.dt-emissao-docto = docto-frete-nf.dt-emissao-docto,                              */
/*                                                                                                            */
/*           EACH pre-con-nf NO-LOCK                                                                          */
/*          WHERE pre-con-nf.cgc-rem     = nota-fiscal-tr.cgc-rem                                             */
/*            AND pre-con-nf.nr-nf       = nota-fiscal-tr.nr-nf                                               */
/*            AND pre-con-nf.cd-serie-nf = nota-fiscal-tr.cd-serie,                                           */
/*                                                                                                            */
/*           EACH pre-con NO-LOCK                                                                             */
/*          WHERE pre-con.cod-estabel = pre-con-nf.cod-estabel                                                */
/*            AND pre-con.cd-serie    = pre-con-nf.cd-serie                                                   */
/*            AND pre-con.nr-calculo  = pre-con-nf.nr-calculo:                                                */
/* /*            AND pre-con.id-tipo     = docto-frete.id-tipo: */                                            */
/*                                                                                                            */
/*                                                                                                            */
/*         IF tt-param.i-tipo-docto = 9 OR                                                                    */
/*            tt-param.i-tipo-docto = docto-frete.id-tipo THEN DO:                                            */
/*             ASSIGN c-conta-credito = "".                                                                   */
/*                                                                                                            */
/*             FOR EACH movct-tr                                                                              */
/*                 WHERE movct-tr.ep-codigo    = iEmpresa                                                     */
/*                   AND movct-tr.tp-docto     = 1 /* Documento de Frete */                                   */
/*                   AND movct-tr.cod-estabel  = nota-fiscal.cod-estabel                                      */
/*                   AND movct-tr.nr-docto     = int(docto-frete.nr-documento)                                */
/*                   AND movct-tr.cnpj-emissor = docto-frete.cnpj-emit                                        */
/*                   AND movct-tr.cd-serie     = docto-frete.serie NO-LOCK :                                  */
/*                  ASSIGN c-conta-credito = movct-tr.conta-credito.                                          */
/*             END.                                                                                           */
/*                                                                                                            */
/*             ASSIGN c-conhecimento        = docto-frete.nr-documento                                        */
/*                    c-tipo-docto          = docto-frete.id-tipo.                                            */
/*                                                                                                            */
/*             RUN repositionRecord IN hDBOtr098 (rowid(pre-con)).                                            */
/*             IF  RETURN-VALUE = "OK":U THEN                                                                 */
/*                 RUN getDecField IN hDBOtr098 ('#Vl-Frete-precon', OUTPUT deValor).                         */
/*                                                                                                            */
/*             IF  c-tipo-docto  = 1 THEN                                                                     */
/*                                                                                                            */
/*                     ASSIGN de-vl-calculo = deValor.                                                        */
/*             ELSE                                                                                           */
/*                     ASSIGN de-vl-calculo = 0.                                                              */
/*             ASSIGN de-vl-informado   = docto-frete.vl-conhecimento.                                        */
/*                                                                                                            */
/*             ASSIGN de-total-notas  = 0.                                                                    */
/*                                                                                                            */
/*             FOR EACH b-docto-frete-nf                                                                      */
/*                 WHERE b-docto-frete-nf.id-tp-docto       = docto-frete.id-tp-docto                         */
/*                   AND b-docto-frete-nf.cnpj-emit         = docto-frete.cnpj-emit                           */
/*                   AND b-docto-frete-nf.serie             = docto-frete.serie                               */
/*                   AND b-docto-frete-nf.nr-documento      = docto-frete.nr-documento                        */
/*                   AND b-docto-frete-nf.dt-emissao-docto  = docto-frete.dt-emissao-docto:                   */
/*               FOR EACH b-nota-fiscal NO-LOCK                                                               */
/*                   WHERE b-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel                                */
/*                     AND b-nota-fiscal.nr-nota-fis = string(b-docto-frete-nf.nr-nf,"9999999")               */
/*                     AND b-nota-fiscal.serie       = b-docto-frete-nf.cd-serie:                             */
/*                   ASSIGN de-total-notas =  b-nota-fiscal.vl-tot-nota.                                      */
/*               END.                                                                                         */
/*             END.                                                                                           */
/*             FIND emitente                                                                                  */
/*                 WHERE emitente.cgc = docto-frete.cnpj-emit                                                 */
/*                 NO-LOCK NO-ERROR.                                                                          */
/*             IF AVAIL emitente THEN DO:                                                                     */
/*                 FIND doc-fiscal                                                                            */
/*                     WHERE doc-fiscal.cod-estabel = nota-fiscal.cod-estabel                                 */
/*                       AND doc-fiscal.serie       = movtrp.docto-frete.serie                                */
/*                       AND doc-fiscal.nr-doc-fis  = string(int(movtrp.docto-frete.nr-documento),"9999999")  */
/*                       AND doc-fiscal.cod-emitente = emitente.cod-emitente                                  */
/*                       AND doc-fiscal.nat-operacao = movtrp.docto-frete.cd-nat-oper                         */
/*                     NO-LOCK NO-ERROR.                                                                      */
/*                                                                                                            */
/*                 IF AVAIL DOc-fiscal THEN DO:                                                               */
/*                     ASSIGN dt-dt-docto = doc-fiscal.dt-docto.                                              */
/*                 END.                                                                                       */
/*                 ELSE ASSIGN dt-dt-docto = ?.                                                               */
/*             END.                                                                                           */
/*             ELSE ASSIGN dt-dt-docto = ?.                                                                   */
/*                                                                                                            */
/*             IF tt-param.lista-conhecimentos THEN DO:                                                       */
/*                                                                                                            */
/*                 PUT  nota-fiscal.nr-nota-fis          ";"                                                  */
/*                      nota-fiscal.serie               ";"                                                   */
/*                      nota-fiscal.nat-operacao        ";"                                                   */
/*                      nota-fiscal.nome-ab-cli         ";"                                                   */
/*                      nota-fiscal.cidade              ";"                                                   */
/*                      nota-fiscal.estado              ";"                                                   */
/*                      nota-fiscal.dt-emis-nota        ";"                                                   */
/*                      nota-fiscal.dt-saida            ";"                                                   */
/*                      nota-fiscal.nome-transp         ";"                                                   */
/*                      nota-fiscal.emite-duplic        ";"                                                   */
/*                      c-tipo-frete ";".                                                                     */
/*                                                                                                            */
/*                 IF AVAIL devol-cli THEN                                                                    */
/*                    PUT devol-cli.nro-docto          ";"                                                    */
/*                         devol-cli.serie-docto        ";".                                                  */
/*                 ELSE PUT ";;".                                                                             */
/*                                                                                                            */
/*                 PUT ";;".                                                                                  */
/*                                                                                                            */
/*                 ASSIGN de-valor-179 =   nota-fiscal.vl-tot-nota * 1.79 / 100 .                             */
/*                 PUT  nota-fiscal.vl-tot-nota ";"                                                           */
/*                      de-valor-179            ";"                                                           */
/*                      c-tipo-docto    AT 178       ";"                                                      */
/*                      c-conta-credito ";"                                                                   */
/*                      dt-dt-docto     ";"                                                                   */
/*                      c-conhecimento  ";"                                                                   */
/*                      de-vl-calculo   ";"                                                                   */
/*                      de-vl-informado ";"                                                                   */
/*                      de-vl-calculo - de-vl-informado ";" SKIP.                                             */
/*                                                                                                            */
/*                 ASSIGN de-vl-calculo-tot = de-vl-calculo-tot + de-vl-calculo                               */
/*                        de-vl-informado-tot = de-vl-informado-tot + de-vl-informado                         */
/*                        de-tot-nota = nota-fiscal.vl-tot-nota + de-tot-nota                                 */
/*                        de-diferenca-tot = de-diferenca-tot + de-vl-calculo - de-vl-informado               */
/*                        de-percentual = de-percentual + nota-fiscal.vl-tot-nota * 1.79 / 100.               */
/*             END.                                                                                           */
/*                                                                                                            */
/*         END.                                                                                               */
/*     END.                                                                                                   */
/*     ASSIGN de-vl-informado = de-vl-informado * nota-fiscal.vl-tot-nota / de-total-notas.                   */

    PUT "" SKIP.

 
    IF l-LAST-OF THEN DO:
        OUTPUT STREAM s-arq CLOSE.
        FIND transporte
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp
            NO-LOCK NO-ERROR.
        FIND emitente
             WHERE emitente.cgc = transporte.cgc
             NO-LOCK NO-ERROR.
        IF AVAIL emitente AND
/*            (emitente.cod-emitente = 104816 OR */
/*             emitente.cod-emitente = 22309  OR */
/*             emitente.cod-emitente = 22585  OR */
/*             emitente.cod-emitente = 115259 OR */
/*             emitente.cod-emitente = 146799 OR */
/*             emitente.cod-emitente = 22777  OR */
/*             emitente.cod-emitente = 4421) AND */
           AVAIL transporte AND
           i-cont > 0 AND
            tt-param.tb-envia-email THEN DO:
            /* INPUT transporte.e-mail + ",cristiane.fernandes@intelbras.com.br",
            */
            IF OPSYS = "win32" THEN
                OUTPUT TO esftp085_erros-comerc.LOG APPEND.
            ELSE
                OUTPUT TO /usr8/spool/esftp085_erros-comerc.LOG APPEND.

            
            ASSIGN c-email = ",cristiane.fernandes@intelbras.com.br".
            

            PUT emitente.cod-emitente " "
                emitente.nome-abrev   " "
                transporte.nome-abrev " "
                transporte.cgc
                "Email enviado para " emitente.e-mail + c-email FORMAT "x(200)"
                " Arquivo : " c-arq FORMAT "x(200)" SKIP.

            RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                              INPUT emitente.e-mail + c-email, 
                              /*
                              INPUT "anderson.cenci@intelbras.com.br",*/
                              
                              INPUT "Notas Fiscais com Conhecimentos Pendentes " + transporte.nome-abrev,
                              INPUT "Prezados, em anexo segue arquivo com notas fiscais pendentes de envio de conhecimento via EDI",
                              INPUT c-arq).
            OUTPUT CLOSE.
            FOR EACH cont-emit
                WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK:
                IF OPSYS = "win32" THEN
                    OUTPUT TO esftp085_erros-comerc.LOG APPEND.
                ELSE
                    OUTPUT TO /usr8/spool/esftp085_erros-comerc.LOG APPEND.
                PUT emitente.cod-emitente " "
                    emitente.nome-abrev   " "
                    transporte.nome-abrev " "
                    transporte.cgc
                    "Email enviado para " cont-emit.e-mail FORMAT "x(200)"
                    " Arquivo : " c-arq FORMAT "x(200)" SKIP.

                RUN piEnviaEmail (INPUT "ems@intelbras.com.br",
                                  INPUT cont-emit.e-mail, 
                                  /*
                                  INPUT "anderson.cenci@intelbras.com.br",*/
                                  
                                  INPUT "Notas Fiscais com Conhecimentos Pendentes " + transporte.nome-abrev,
                                  INPUT "Prezados, em anexo segue arquivo com notas fiscais pendentes de envio de conhecimento via EDI",
                                  INPUT c-arq).
                OUTPUT CLOSE.
            END.
        END.
    END.
        

END PROCEDURE.
    PROCEDURE piEnviaEmail :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
        DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
        DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
        DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
        DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
        DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

        DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.

        FOR EACH tt-mail:
            DELETE tt-mail.
        END.
        DEF VAR icont AS INT. 
        FOR FIRST param-global NO-LOCK:
        END.

        CREATE tt-mail.
        ASSIGN tt-mail.Remetente     = pRemetente
               tt-mail.Destinatario  = pdestino
               tt-mail.Assunto       = pAssunto
               tt-mail.Arquivo       = IF pArquivo <> "" then
                                          SEARCH(pArquivo) 
                                       ELSE
                                           "" 
               tt-mail.Mensagem      = pDescEmail.


        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

        FOR EACH tt-mail:

            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.

            ASSIGN c-lst-arq  = tt-mail.arquivo. /* + "," + "\\intel200\erp\ems204\image\logo_maxcom.jpg". */

            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = tt-mail.Destinatario     /* Destinat rio       */ 
                   tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                   tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                   tt-envio2.arq-anexo         = c-lst-arq               /* Arquivo Tempor rio */
                   tt-envio2.formato           = "TEXTO".
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */

            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
            FIND FIRST tt-erros NO-LOCK NO-ERROR.

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
            END.

        END.
        RETURN "OK":U.
    END PROCEDURE.

