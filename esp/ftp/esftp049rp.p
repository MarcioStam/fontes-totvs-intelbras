/***********************************************************************
**  Programa..: ESP/FTP/ESFTP04923RP.P
**  Autor.....: Anderson Cenci
**  Descricao.: Gera‡Æo de arquivo para importa‡Æo no sistema da prefeitura de SÆo Jos‚ - SC
**  VersÆo....: 001 02/07/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP049 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/ftp/esftp049tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/

def var c-arquivo as char no-undo.
DEFINE VARIABLE c-localizado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-enquadramento AS CHARACTER   NO-UNDO.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.
DEF VAR l-erro AS LOGICAL.
DEF VAR i-cont AS INTEGER.
DEFINE VARIABLE i-cont-notas AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cnae AS CHARACTER   NO-UNDO.
DEF VAR de-total-nota AS DECIMAL.
DEFINE VARIABLE de-total-iss AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cd-trib-iss AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-aliquota AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-situacao AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-imprime  AS LOGICAL   NO-UNDO.

DEF TEMP-TABLE tt-item
    FIELD cnae          AS CHAR
    FIELD total-item    AS DEC
    FIELD aliquota-iss  AS DECIMAL
    FIELD vlr-base      AS DECIMAL
    FIELD aliquota      AS DECIMAL
    FIELD vlr-iss       AS DECIMAL.
               
DEF TEMP-TABLE tt-docto
    FIELD nro-docto  LIKE docum-est.nro-docto
    FIELD serie      LIKE nota-fiscal.serie
    FIELD tipo       AS CHARACTER
    FIELD dt-emissao AS DATE
    FIELD vlr-docto  AS DECIMAL
    FIELD vlr-base   AS DECIMAL
    FIELD vlr-iss    AS DECIMAL
    FIELD aliquota   AS DECIMAL
    FIELD cnpj       LIKE emitente.cgc.

DEF temp-table tt-emitente          
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD cnpj              LIKE emitente.cgc
    FIELD razao             LIKE emitente.nome-emit
    FIELD tipo              LIKE emitente.natureza
    FIELD ins-municipal     LIKE emitente.INs-municipal 
    FIELD tipo-logradouro   AS CHARACTER
    FIELD endereco          LIKE emitente.endereco  
    FIELD bairro            LIKE emitente.bairro    
    FIELD cidade            LIKE emitente.cidade    
    FIELD estado            LIKE emitente.estado    
    FIELD cep               LIKE emitente.cep       
    FIELD telefone          LIKE emitente.telefone. 


create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
DEFINE VARIABLE da-data AS DATE        NO-UNDO.

DEF STREAM s-stream.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Gera‡Æo de Arquivo para Prefeitura SÆo Jos‚ - SC"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP049"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

DO on stop undo, leave:   
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    IF tt-param.tp-layout = 1 THEN DO: /* Layout Antigo */
        IF tt-param.prefeitura = 1 THEN
            RUN piMontaRelat-SaoJose.
        ELSE
            IF tt-param.prefeitura = 2 THEN
               RUN piMontaRelat-SantaRitaSapucai.
            ELSE
                IF tt-param.prefeitura = 3 THEN
                    RUN piMontaRelat-SJPinhais.
    END.
    ELSE DO:  /* Layout Novo */
        IF tt-param.prefeitura = 1 THEN
            RUN piMontaRelat-SaoJoseNOVO.
        ELSE
            IF tt-param.prefeitura = 2 THEN
               RUN piMontaRelat-SantaRitaSapucai.
            ELSE
                IF tt-param.prefeitura = 3 THEN
                    RUN piMontaRelat-SJPinhais.
    END.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piMontaRelat-SaoJose:
    
    PUT "Criticas das notas de Saida " SKIP.
    FIND estabelec
         WHERE estabelec.cod-estabel = tt-param.cod-estabel-ini
         NO-LOCK NO-ERROR.
    FIND mgcad.cidade 
         WHERE mgcad.cidade.cidade = estabelec.cidade
           AND mgcad.cidade.estado = estabelec.estado
         NO-LOCK NO-ERROR.

   ASSIGN i-seq = 0
          i-cont-notas = 0.

   PUT "Criticas das notas de Entrada " SKIP.
   
   DO da-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
       for each docum-est no-lock
              where docum-est.dt-trans = da-data
              and docum-est.cod-estabel >= tt-param.cod-estabel-ini 
              and docum-est.cod-estabel <= tt-param.cod-estabel-fim
              AND docum-est.cod-observa = 4:

           RUN pi-acompanhar in h-acomp (input "Lendo Documentos de Entrada " + string(da-data)).

           IF LOOKUP(docum-est.nat-operacao,tt-param.naturezas) <> 0 THEN DO:
               FIND emitente
                    WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
                FIND mgcad.cidade 
                     WHERE mgcad.cidade.cidade = emitente.cidade
                       AND mgcad.cidade.estado = emitente.estado
                     NO-LOCK NO-ERROR.
                
                IF mgcad.cidade.cdn-munpio-ibge = 0 THEN DO:
                    PUT "Cidade sem codigo IBGE " mgcad.cidade.cidade " Estado " mgcad.cidade.estado " Nota " docum-est.nro-docto " Data " docum-est.dt-trans " serie " docum-est.serie SKIP.
                    NEXT.
                END.
               ASSIGN l-erro = NO
                      de-total-nota = 0.
               FOR each item-doc-est of docum-est NO-LOCK,
                   FIRST ITEM NO-LOCK
                   WHERE ITEM.it-codigo = item-doc-est.it-codigo:

                   IF item-doc-est.nat-operacao = "194995" THEN DO:
                       ASSIGN c-cnae = "5211799".
                   END.
                   ELSE DO:
                       IF ITEM.inform-compl = "" THEN DO:
                          ASSIGN c-cnae = "9512600".
                       END.
                       ELSE DO:
                            ASSIGN c-cnae = ITEM.inform-compl.
                       END.
                   END.

                   ASSIGN de-total-nota = de-total-nota + item-doc-est.preco-total[1]
                          de-total-iss  = de-total-iss  + item-doc-est.valor-iss[1].
                   FIND tt-item
                        WHERE tt-item.cnae = c-cnae
                        NO-ERROR.
                   IF NOT AVAIL tt-item THEN
                       CREATE tt-item.

                   ASSIGN tt-item.cnae       = STRING(ITEM.cod-servico)
                          tt-item.total-item = tt-item.total-item + item-doc-est.preco-total[1]    
                          tt-item.vlr-base   = tt-item.vlr-base  + item-doc-est.base-iss[1]       
                          tt-item.vlr-iss    = tt-item.vlr-iss   + item-doc-est.valor-iss[1]      
                          tt-item.aliquota   = item-doc-est.aliquota-iss.                           
                   IF item-doc-est.valor-iss[1] <> 0 THEN
                       IF emitente.cidade = "SAO JOSE" OR
                          emitente.estado = "SC" THEN
                          ASSIGN c-enquadramento = "S".
                       ELSE
                          ASSIGN c-enquadramento = "F".
                  ELSE
                      ASSIGN c-enquadramento = "O".


               END.
               IF CAN-FIND (FIRST tt-item) AND
                  l-erro = NO             THEN DO:

                   ASSIGN i-cont-notas = i-cont-notas + 1.
                   IF i-cont-notas > 99999999  THEN DO:
                       ASSIGN i-cont-notas = 1.
                       OUTPUT STREAM s-stream CLOSE.
                   END.
                   IF i-cont-notas = 1 THEN DO:
                       ASSIGN i-seq = i-seq + 1.
                       OUTPUT STREAM s-stream TO VALUE(trim(tt-param.diretorio) + "tomados" + STRING(i-seq,"9999") + ".txt").
                       
                       PUT STREAM s-stream "3H"
                           estabelec.cgc                 FORMAT "x(14)"
                           YEAR(tt-param.dt-emissao-ini) FORMAT "9999"
                           MONTH(tt-param.dt-emissao-ini)FORMAT "99"
                           "0" /* sequencia 6 */
                           estabelec.cgc                 FORMAT "x(14)" /* sequencia 7 C¢digo de acesso ao sistema.*/
                           "67194508915" /* sequencia 8 CNPJ ou CPF da contabilidade/Contador,*/
                           "29454" /* Cadastro municipal do declarante */
                            SKIP.
                   END.


                   PUT STREAM s-stream "3N"
                       docum-est.serie               AT 3  FORMAT "X(10)"
                       "R"                           AT 13.

                   IF docum-est.nat-operacao = "194989" OR
                      docum-est.nat-operacao = "294989" THEN
                       PUT STREAM s-stream "R".
                   ELSE
                       PUT STREAM s-stream "N".

                   PUT STREAM s-stream 
                       INT(docum-est.nro-docto)      AT 15 FORMAT "99999999999999"
                       docum-est.dt-trans            AT 29 FORMAT "99/99/9999"
                       emitente.cgc                  AT 39 FORMAT "99999999999999"
                       de-total-nota * 100           AT 53 FORMAT ">>>>>>>>>>>9,99"
                       c-enquadramento               AT 69 FORMAT "X(1)"
                       emitente.nome-emit            AT 70 FORMAT "x(150)"
                       emitente.cidade               AT 221 FORMAT "X(30)"
                       emitente.estado               AT 251 FORMAT "X(2)" SKIP.

                   FOR EACH tt-item:
                       PUT STREAM s-stream "3I"
                            tt-item.cnae              AT 3  FORMAT "9999999"
                            tt-item.vlr-base * 100    AT 10 FORMAT ">>>>>>>>>>>9,99" 
                            0                         AT 25 FORMAT ">9,9999"
                            tt-item.aliquota * 1000   AT 32 FORMAT ">9,9999"
                            tt-item.vlr-iss * 100     AT 39 FORMAT ">>>>>>>>>>>9,99" SKIP.
                       DELETE tt-item.    
                   END.
               END.
           END.
       end.
   END.

   PUT STREAM s-stream "3T"
       i-cont-notas         AT 3   FORMAT "999999999999999"
       0                    AT 18  FORMAT "999999999999999"
       0                    AT 33  FORMAT "9999999999999,99"
       0                    AT 49  FORMAT "9999999999999,99"
       0                    AT 65  FORMAT "9999999999999,99"
       0                    AT 81  FORMAT "9999999999999,99"
       i-cont-notas         AT 97  FORMAT "999999999999999"
       de-total-nota * 100  AT 112 FORMAT "9999999999999,99"
       de-total-iss * 100   AT 128 FORMAT "9999999999999,99" SKIP.

   OUTPUT STREAM s-stream CLOSE. 
   OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE piMontaRelat-SaoJoseNovo:

    FIND estabelec WHERE estabelec.cod-estabel = tt-param.cod-estabel-ini NO-LOCK NO-ERROR.

    ASSIGN i-seq = 0
           i-cont-notas = 0.

/*     MESSAGE tt-param.dt-emissao-ini SKIP   */
/*             tt-param.dt-emissao-fim        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

     DO da-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
        for each docum-est no-lock
               where docum-est.dt-trans = da-data
               and docum-est.cod-estabel >= tt-param.cod-estabel-ini 
               and docum-est.cod-estabel <= tt-param.cod-estabel-fim
               AND docum-est.cod-observa = 4:

            RUN pi-acompanhar in h-acomp (input "Lendo Documentos de Entrada " + string(da-data)).

            ASSIGN l-imprime  = NO.
                   c-aliquota = ''.
 
            FIND FIRST dupli-apagar 
                 WHERE dupli-apagar.cod-emitente = docum-est.cod-emitente 
                   AND dupli-apagar.nro-docto    = docum-est.nro-docto  
                   AND dupli-apagar.serie-docto  = docum-est.serie-docto 
                   AND dupli-apagar.nat-operacao = docum-est.nat-operacao
            NO-LOCK NO-ERROR.

            IF AVAIL dupli-apagar THEN DO:
               FOR EACH dupli-imp NO-LOCK 
                   WHERE dupli-imp.cod-emitente  = dupli-apagar.cod-emitente 
                      AND dupli-imp.nat-operacao = dupli-apagar.nat-operacao 
                      AND dupli-imp.serie-docto  = dupli-apagar.serie-docto 
                      AND dupli-imp.nro-docto    = dupli-apagar.nro-docto 
                      AND dupli-imp.parcela      = dupli-apagar.parcela 
                      AND dupli-imp.cod-esp = 'CS':

                   ASSIGN c-aliquota = REPLACE(STRING(dupli-imp.aliquota,'99.99'),',',''). 
                   ASSIGN l-imprime  = YES.
               END.  
            END.

            IF NOT l-imprime THEN NEXT.

            IF INDEX(tt-param.naturezas,docum-est.nat-operacao) > 0 THEN DO:
            
               FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

               FIND mgcad.cidade WHERE mgcad.cidade.cidade = emitente.cidade
                                   AND mgcad.cidade.estado = emitente.estado
               NO-LOCK NO-ERROR.
                
               IF mgcad.cidade.int-2 = 0 THEN DO:
                   PUT "Cidade sem codigo IBGE " cidade.cidade " Estado " mgcad.cidade.estado " Nota " docum-est.nro-docto " Data " docum-est.dt-trans " serie " docum-est.serie SKIP.
                   NEXT.
               END.
               IF emitente.cidade = "SAO JOSE" OR
                  emitente.estado = "SC" THEN
                  ASSIGN c-localizado = "D".
               ELSE
                  ASSIGN c-localizado = "F".
               ASSIGN l-erro = NO
                      de-total-nota = 0.
               FOR EACH item-doc-est of docum-est NO-LOCK,
                   FIRST ITEM NO-LOCK
                   WHERE ITEM.it-codigo = item-doc-est.it-codigo:

                   ASSIGN c-situacao = "N".

                   FIND FIRST int-docum-est 
                        WHERE int-docum-est.serie-docto  = docum-est.serie-docto    
                          and int-docum-est.nro-docto    = docum-est.nro-docto      
                          and int-docum-est.cod-emitente = docum-est.cod-emitente   
                          and int-docum-est.nat-operacao = docum-est.nat-operacao
                   NO-LOCK NO-ERROR.

                   IF AVAIL int-docum-est THEN
                      ASSIGN c-cnae     = string(int-docum-est.cd-servico).

                   IF LENGTH(c-cnae) < 4 THEN DO:
                      DO WHILE(LENGTH(c-cnae) < 4):
                         ASSIGN c-cnae = '0' + c-cnae.
                      END. 
                   END.
 
                   ASSIGN de-total-nota = de-total-nota + item-doc-est.preco-total[1].

                   FIND tt-item WHERE tt-item.cnae = c-cnae NO-ERROR.

                   IF NOT AVAIL tt-item THEN
                      CREATE tt-item.
 
                   ASSIGN tt-item.cnae       = c-cnae
                          tt-item.total-item = tt-item.total-item + item-doc-est.preco-total[1].
               END.
               IF CAN-FIND (FIRST tt-item) AND
                  l-erro = NO             THEN DO:
 
                   ASSIGN i-cont-notas = i-cont-notas + 1.
                   IF i-cont-notas > 1000  THEN DO:
                       ASSIGN i-cont-notas = 1.
                       OUTPUT STREAM s-stream CLOSE.
                   END.
                   IF i-cont-notas = 1 THEN DO:

                       IF SUBSTRING(tt-param.diretorio,LENGTH(tt-param.diretorio),1) <> '\' AND SUBSTRING(tt-param.diretorio,LENGTH(tt-param.diretorio),1) <> '/' THEN
                          ASSIGN tt-param.diretorio = tt-param.diretorio + '/'. 

                       ASSIGN i-seq = i-seq + 1.
                       OUTPUT STREAM s-stream TO VALUE(trim(tt-param.diretorio) + "tomados" + STRING(i-seq,"9999") + ".txt") NO-MAP NO-CONVERT.
                       PUT STREAM s-stream "082892274000105001" SKIP.
                       PUT STREAM s-stream "1T1"
                           estabelec.cgc  AT 4 FORMAT "x(14)"
                           estabelec.nome AT 18 FORMAT "x(50)" 
                           tt-param.dt-emissao-ini AT 68 FORMAT "99999999"
                           tt-param.dt-emissao-fim AT 76 FORMAT "99999999" SKIP.
                   END.

                   
                   PUT STREAM s-stream "2"
                       emitente.cgc             AT  2 FORMAT "x(14)"
                       emitente.nome-emit       AT 16 FORMAT "x(50)"
                       "U"                      AT 66 FORMAT "x(06)"
                       docum-est.nro-docto      AT 72 FORMAT "x(9)"
                       docum-est.nro-docto      AT 81 FORMAT "x(9)"
                       docum-est.dt-trans       AT 90 FORMAT "99999999"
                       "N"
                       "R"
                       de-total-nota     * 100  AT 100 FORMAT ">>>>>>>>>>>>>>9"
                       c-localizado             AT 115 FORMAT "x(01)"
                       mgcad.cidade.int-2       AT 116 FORMAT "9999999" SKIP.
 
                   FOR EACH tt-item:
                       PUT STREAM s-stream "3"
                            tt-item.cnae FORMAT "x(7)"
                            tt-item.total-item * 100 AT 9 FORMAT ">>>>>>>>>>>>999" 
                            c-aliquota AT 31 FORMAT 'x(4)' 
                            fill(" ",9)      FORMAT 'x(9)' SKIP.
                       DELETE tt-item.             
                   END.
               END.
            END.
        end.
    END.
/*     MESSAGE 'saiu leitura datas'           */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

    OUTPUT STREAM s-stream CLOSE. 

END PROCEDURE.

PROCEDURE valida-cnae:
    DEF INPUT PARAMETER c-cnae AS CHARACTER.
    DO i-cont = 1 TO 7:
       IF SUBSTRING(c-cnae,i-cont,1) <> "0" AND
          SUBSTRING(c-cnae,i-cont,1) <> "1" and
          SUBSTRING(c-cnae,i-cont,1) <> "2" and
          SUBSTRING(c-cnae,i-cont,1) <> "3" and
          SUBSTRING(c-cnae,i-cont,1) <> "4" and
          SUBSTRING(c-cnae,i-cont,1) <> "5" and
          SUBSTRING(c-cnae,i-cont,1) <> "6" and
          SUBSTRING(c-cnae,i-cont,1) <> "7" and
          SUBSTRING(c-cnae,i-cont,1) <> "8" and
          SUBSTRING(c-cnae,i-cont,1) <> "9" THEN 
          ASSIGN l-erro = YES.
    END.
    
END PROCEDURE.
function tipo-logradouro returns char (input c-endereco AS CHARACTER):
    IF INDEX(c-endereco,"RUA") <> 0           THEN return "RUA".
    ELSE IF INDEX(c-endereco,"TRAVESSA") <> 0 THEN return "TRA".
    ELSE IF INDEX(c-endereco,"rod") <> 0      THEN return "ROD".
    ELSE IF INDEX(c-endereco,"AV") <> 0       THEN return "AV".
    ELSE IF INDEX(c-endereco,"AVENIDA") <> 0  THEN return "AV".
    ELSE IF INDEX(c-endereco,"PRACA") <> 0    THEN return "PRA".
    ELSE IF INDEX(c-endereco,"r.") <> 0       THEN return "RUA".
    ELSE IF INDEX(c-endereco,"ESTR.") <> 0    THEN return "EST".
    ELSE IF INDEX(c-endereco,"QDA") <> 0      THEN return "QDA".
    ELSE IF INDEX(c-endereco,"r:") <> 0       THEN return "RUA".
    
end function.
PROCEDURE piMontaRelat-SantaRitaSapucai:
    OUTPUT STREAM s-stream TO VALUE(trim(tt-param.diretorio) + "ExpDocs.xml").
    PUT "Criticas das notas de Saida " SKIP.
    FIND estabelec
         WHERE estabelec.cod-estabel = tt-param.cod-estabel-ini
         NO-LOCK NO-ERROR.
    DO da-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
       FOR EACH nota-fiscal NO-LOCK                WHERE 
                nota-fiscal.dt-emis-nota = da-data AND 
                nota-fiscal.dt-cancela = ?         and 
                nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini and
                nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim:               
           RUN pi-acompanhar in h-acomp (input "Lendo Documentos de Saida " + string(da-data)).
           FIND emitente
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                NO-LOCK NO-ERROR.
            IF LOOKUP(nota-fiscal.nat-operacao,tt-param.naturezas) <> 0 THEN DO:
                ASSIGN l-erro = NO
                       de-total-nota = 0.

                ASSIGN c-serie = "M1".

                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
                    FIRST natur-oper NO-LOCK
                    WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao
                      AND (natur-oper.cd-trib-iss = 1
                       OR  natur-oper.cd-trib-iss = 4):
                    
                    FIND tt-docto
                         WHERE tt-docto.nro-docto = nota-fiscal.nr-nota-fis
                           AND tt-docto.serie     = c-serie
                           AND tt-docto.tipo      = "SP"
                         NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-docto THEN DO:
                       CREATE tt-docto.
                       ASSIGN tt-docto.nro-docto = nota-fiscal.nr-nota-fis 
                              tt-docto.serie     = c-serie       
                              tt-docto.tipo      = "SP".
                    END.
                    ASSIGN tt-docto.dt-emissao = nota-fiscal.dt-emis-nota
                           tt-docto.vlr-docto  = nota-fiscal.vl-tot-nota
                           tt-docto.vlr-base   = it-nota-fisc.vl-biss-it
                           tt-docto.vlr-iss    = it-nota-fisc.vl-iss-it
                           tt-docto.aliquota   = it-nota-fisc.aliquota-ISS
                           tt-docto.cnpj       = emitente.cgc.
                    FIND tt-emitente
                         WHERE tt-emitente.cod-emitente = emitente.cod-emitente
                           NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-emitente THEN DO:
                        CREATE tt-emitente.
                        ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente.
                    END.
                    ASSIGN tt-emitente.cnpj            = emitente.cgc
                           tt-emitente.razao           = emitente.nome-emit
                           tt-emitente.tipo            = emitente.natureza  
                           tt-emitente.ins-municipal   = emitente.ins-municipal
                           tt-emitente.tipo-logradouro = tipo-logradouro(emitente.endereco)
                           tt-emitente.endereco        = emitente.endereco
                           tt-emitente.bairro          = emitente.bairro
                           tt-emitente.cidade          = emitente.cidade
                           tt-emitente.estado          = emitente.estado
                           tt-emitente.cep             = emitente.cep
                           tt-emitente.telefone[1]     = emitente.telefone[1].
                END.
            END.
       END. 
   END.
   OUTPUT CLOSE.
   PUT "Criticas das notas de Entrada " SKIP.
    
   DO da-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
       for each docum-est no-lock
              where docum-est.dt-trans = da-data
              and docum-est.cod-estabel >= tt-param.cod-estabel-ini 
              and docum-est.cod-estabel <= tt-param.cod-estabel-fim
              AND docum-est.cod-observa = 4:

           RUN pi-acompanhar in h-acomp (input "Lendo Documentos de Entrada " + string(da-data)).

           IF LOOKUP(docum-est.nat-operacao,tt-param.naturezas) <> 0 THEN DO:
               FIND emitente
                    WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
               FOR each item-doc-est of docum-est NO-LOCK,
                    FIRST natur-oper NO-LOCK
                    WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao,
                   FIRST ITEM NO-LOCK
                   WHERE ITEM.it-codigo = item-doc-est.it-codigo:
                   IF emitente.cidade <> "SANTA RITA DO SAPUCAI" THEN
                       ASSIGN c-serie = "NF".
                   ELSE
                       IF docum-est.serie-docto = "1" OR
                          docum-est.serie-docto = "2" OR
                          docum-est.serie-docto = "3" OR
                          docum-est.serie-docto = "4" OR
                          docum-est.serie-docto = "5" OR
                          docum-est.serie-docto = "6" OR
                          docum-est.serie-docto = "7" OR
                          docum-est.serie-docto = "8" OR
                          docum-est.serie-docto = "9" OR
                          docum-est.serie-docto = "10" then
                          ASSIGN c-serie = "M1".
                       ELSE
                          ASSIGN c-serie = "D1".

                   FIND tt-docto
                        WHERE tt-docto.nro-docto = docum-est.nro-docto
                          AND tt-docto.serie     = c-serie
                          AND tt-docto.tipo      = "ST"
                        NO-LOCK NO-ERROR.
                   IF NOT AVAIL tt-docto THEN DO:
                      CREATE tt-docto.
                      ASSIGN tt-docto.nro-docto = docum-est.nro-docto    
                             tt-docto.serie     = c-serie
                             tt-docto.tipo      = "ST".
                   END.
                   ASSIGN tt-docto.dt-emissao = docum-est.dt-trans                                  
                          tt-docto.vlr-docto  = tt-docto.vlr-docto + item-doc-est.preco-total[1]      
                          tt-docto.vlr-base   = tt-docto.vlr-base  + item-doc-est.base-iss[1]  
                          tt-docto.vlr-iss    = tt-docto.vlr-iss   + item-doc-est.valor-iss[1]
                          tt-docto.aliquota   = item-doc-est.aliquota-iss
                          tt-docto.cnpj       = emitente.cgc.
                   FIND tt-emitente
                        WHERE tt-emitente.cod-emitente = emitente.cod-emitente
                          NO-LOCK NO-ERROR.
                   IF NOT AVAIL tt-emitente THEN DO:
                       CREATE tt-emitente.
                       ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente.
                   END.
                   ASSIGN tt-emitente.cnpj            = emitente.cgc
                          tt-emitente.razao           = emitente.nome-emit
                          tt-emitente.tipo            = emitente.natureza  
                          tt-emitente.ins-municipal   = emitente.ins-municipal
                          tt-emitente.tipo-logradouro = tipo-logradouro(emitente.endereco)
                          tt-emitente.endereco        = emitente.endereco
                          tt-emitente.bairro          = emitente.bairro
                          tt-emitente.cidade          = emitente.cidade
                          tt-emitente.estado          = emitente.estado
                          tt-emitente.cep             = emitente.cep
                          tt-emitente.telefone[1]     = emitente.telefone[1].
               END.                   
           END.
       end.
   END.
   FOR EACH tt-emitente:
       PUT STREAM s-stream  "PE"
           tt-emitente.cnpj     AT  3 FORMAT "x(14)"
           tt-emitente.razao    AT 17 FORMAT "x(60)".
       IF tt-emitente.tipo = 1 THEN
          PUT STREAM s-stream  "F" AT 77.
       ELSE
          PUT STREAM s-stream  "J" AT 77.
       PUT STREAM s-stream  tt-emitente.ins-municipal   AT  78 FORMAT "x(15)"
                            tt-emitente.tipo-logradouro AT  93 FORMAT "x(03)"
                            tt-emitente.endereco        AT  96 FORMAT "x(40)"
                            tt-emitente.bairro          AT 171 FORMAT "x(40)"
                            tt-emitente.cidade          AT 211 FORMAT "x(60)"
                            tt-emitente.estado          AT 271 FORMAT "x(02)"
                            tt-emitente.cep             AT 273 FORMAT "x(08)"
                            tt-emitente.telefone[1]     AT 281 FORMAT "x(15)"
                            "S" SKIP.
   END.
   FOR EACH tt-docto:
       PUT STREAM s-stream tt-docto.tipo              AT  1 FORMAT "x(02)"
                           tt-docto.nro-docto         AT  3 FORMAT "x(07)"
                           tt-docto.serie             AT 10 FORMAT "x(02)"
                           tt-docto.dt-emissao        AT 12 FORMAT "99/99/9999"
                           tt-docto.vlr-docto * 100   AT 22 FORMAT "9999999999"
                           tt-docto.vlr-base  * 100   AT 32 FORMAT "9999999999"
                           tt-docto.vlr-iss   * 100   AT 42 FORMAT "9999999999"
                           tt-docto.aliquota  * 100   AT 52 FORMAT "9999"
                           tt-docto.cnpj              AT 56 FORMAT "x(14)"
                           tt-docto.vlr-iss   * 100   AT 70 FORMAT "9999999999".
       IF tt-docto.tipo = "SP" THEN
          PUT STREAM s-stream  "E" SKIP.
       ELSE
          PUT STREAM s-stream  SKIP.
   END.
   OUTPUT CLOSE.

END PROCEDURE.


PROCEDURE piMontaRelat-SJPinhais:
   PUT "Criticas das notas de Entrada " SKIP.
   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
   OUTPUT STREAM s-stream TO VALUE(trim(tt-param.diretorio) + "tomados" + STRING(today,"999999") + ".txt").
   DO da-data = tt-param.dt-emissao-ini TO tt-param.dt-emissao-fim:
       for each docum-est no-lock
              where docum-est.dt-trans = da-data
              and docum-est.cod-estabel >= tt-param.cod-estabel-ini 
              and docum-est.cod-estabel <= tt-param.cod-estabel-fim:
/*               AND docum-est.cod-observa = 4: */

           RUN pi-acompanhar in h-acomp (input "Lendo Documentos de Entrada " + string(da-data)).

           IF LOOKUP(docum-est.nat-operacao,tt-param.naturezas) <> 0 THEN DO:
               FIND emitente
                    WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
                FIND mgcad.cidade 
                     WHERE mgcad.cidade.cidade = emitente.cidade
                       AND mgcad.cidade.estado = emitente.estado
                     NO-LOCK NO-ERROR.
                
                IF emitente.cidade = "SAO JOSE DOS PINHAIS" AND
                   emitente.estado = "SC" THEN
                   ASSIGN c-localizado = "S".
                ELSE
                   ASSIGN c-localizado = "N".
               ASSIGN l-erro = NO
                      de-total-nota = 0.
               FOR each item-doc-est of docum-est NO-LOCK,
                   FIRST item
                   WHERE ITEM.it-codigo = item-doc-est.it-codigo:

                   ASSIGN de-total-nota = de-total-nota + item-doc-est.preco-total[1].
                   IF item-doc-est.cd-trib-iss = 1 THEN
                       ASSIGN c-cd-trib-iss = "1".
                   ELSE IF item-doc-est.cd-trib-iss = 2 THEN
                           ASSIGN c-cd-trib-iss = "4".
                        ELSE
                            ASSIGN c-cd-trib-iss = "6".
               END.
 
               PUT STREAM s-stream "T"    
                                   int(docum-est.nro-docto)     FORMAT "9999999999"   AT 2.
               IF docum-est.serie-docto = "1" THEN
                  PUT STREAM s-stream "U"         FORMAT "x(10)"                      AT 12.
               ELSE
                  PUT STREAM s-stream docum-est.serie-docto        FORMAT "x(10)"     AT 12.

               PUT docum-est.nro-docto " "  docum-est.serie-docto  " " docum-est.cod-emitente " "  docum-est.nat-operacao  " " emitente.ins-estadual " " emitente.ins-municipal SKIP.

               PUT STREAM s-stream docum-est.dt-trans           FORMAT "99/99/9999"   AT 22
                                   c-cd-trib-iss                FORMAT "x(1)"         AT 32
                                   de-total-nota * 100          FORMAT "999999999999" AT 33 
                                   "14.02"                                            AT 45
                                   INT(emitente.natureza)       FORMAT "9"            AT 55
                                   c-localizado                 FORMAT "x(1)"         AT 56
                                   emitente.nome-emit           FORMAT "x(100)"       AT 57.

               IF emitente.ins-municipal <> "ISENTO" AND emitente.ins-municipal <> "ISENTA" THEN
                  PUT STREAM s-stream DEC(replace(replace(replace(emitente.ins-municipal,"-",""),".",""),"/","")) FORMAT "9999999999"   AT 157.
               ELSE
                  PUT STREAM s-stream  "0000000000"   AT 157.


              PUT STREAM s-stream  " "                                                                     AT 167
                                   dec(replace(replace(emitente.cgc,"-",""),".","")) FORMAT "99999999999999"             AT 169.
               IF emitente.ins-estadual = "ISENTO" or emitente.ins-estadual = "ISENTA" THEN
                  PUT STREAM S-STREAM "S"                                                                  AT 183
                                      "000000000000000"  .
               ELSE
                  PUT STREAM S-STREAM "N"                                                                  AT 183
                                      dec(replace(replace(emitente.ins-estadual,"-",""),".","")) FORMAT "999999999999999"                AT 184.
                  
               PUT STREAM s-stream replace(replace(emitente.cep,"-",""),".","")                            AT 199.

               ASSIGN c-endereco =  emitente.endereco.

               ASSIGN c-rua      = ""
                      c-nro      = ""
                      c-comp     = "".
               IF  INDEX(c-endereco,CHR(ASC("§"))) > 0 THEN /* Retirar caracter especial */
                   ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("§")),"").


               RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                                    OUTPUT c-rua, 
                                                    OUTPUT c-nro, 
                                                    OUTPUT c-comp).

               IF index(emitente.endereco,"RUA") <> 0 OR
                  index(emitente.endereco,"R ") <> 0  OR
                  index(emitente.endereco,"R.") <> 0  THEN
                  PUT STREAM s-stream "RUA"                                           AT 207.
               ELSE
                   IF index(emitente.endereco,"ROD") <> 0  THEN
                       PUT STREAM s-stream "RODOVIA"                                  AT 207.
                   ELSE
                       IF index(emitente.endereco,"AV") <> 0  OR
                          index(emitente.endereco,"AVENIDA") <> 0  THEN
                          PUT STREAM s-stream "AVENIDA"                               AT 207.
                       ELSE
                           IF index(emitente.endereco,"TRAVESSA") <> 0  OR
                              index(emitente.endereco,"TRAV.") <> 0  THEN
                              PUT STREAM s-stream "TRAVESSA"                          AT 207.
                           ELSE
                               IF index(emitente.endereco,"PRACA") <> 0  THEN
                                  PUT STREAM s-stream "PRACA"                         AT 207.
                               ELSE
                                   IF index(emitente.endereco,"ESTRADA") <> 0  THEN
                                      PUT STREAM s-stream "ESTRADA"                   AT 207.
                                   ELSE
                                       IF index(emitente.endereco,"ALAMEDA") <> 0  OR
                                          index(emitente.endereco,"AL.") <> 0  THEN
                                          PUT STREAM s-stream "TRAVESSA"              AT 207.
                                       ELSE
                                          PUT STREAM s-stream "."              AT 207.
               PUT STREAM s-stream c-rua    FORMAT "x(50)"                            AT 217
                                   c-comp   FORMAT "x(40)"                            AT 267
                                   c-nro                                              AT 307
                                   IF emitente.bairro = "" THEN "." ELSE emitente.bairro                                    AT 317
                                   emitente.estado FORMAT "x(2)"                      AT 367
                                   emitente.cidade                                    AT 369
                                   "D"                                                AT 419
                                   "N"                                                AT 420
                                   "00000"                                            AT 422 SKIP.




                      
                                   
                                   
                                   
           END.
       end.
   END.

   OUTPUT CLOSE.
   DELETE procedure h-cdapi704.

END PROCEDURE.

