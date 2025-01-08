&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE item
       field selecionado as character
       field r-rowid     as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESINP004 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESINP004
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp l-escolha  btVisualizar btBaixarAtu rs-atual da-ini c-ncm-ini c-ncm-fim c-ncm-rapida btBuscar br-acordos br-acordos-ptr04 br-defesa-comerc br-ex-tarif br-icms br-itens br-list-ex br-list-ex-bens br-naladi-1996 br-naladi-2002 br-naladi-2007 br-notas br-nve br-piscofins br-quotas-tarif br-sistema br-tipi br-tratam-admin bt-detalha-nota tg-posicoes rs-item c-item btBusca-item

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE dt-formato-certo-de  AS DATE        NO-UNDO.
DEFINE VARIABLE dt-formato-certo-ate AS DATE        NO-UNDO.
DEFINE VARIABLE c-selecionado        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE da-atualizacao       AS DATE        NO-UNDO.

DEF BUFFER b-fisco FOR fiscosoft-ncm.
DEF BUFFER b-fisco-2 FOR fiscosoft-ncm.

DEF VAR de-ponteiro AS DEC NO-UNDO.

DEF VAR l-primeira-atualizacao AS LOGICAL INIT YES.

/* Gravar o menor ponteiro existente*/
FIND FIRST fiscosoft-ncm  NO-LOCK NO-ERROR.

IF  AVAIL fiscosoft-ncm THEN DO:
    
    IF CAN-FIND(FIRST b-fisco
                    WHERE b-fisco.dt-baixa > fiscosoft-ncm.dt-baixa) 
    OR CAN-FIND(FIRST b-fisco-2
                    WHERE b-fisco-2.dt-baixa < fiscosoft-ncm.dt-baixa) THEN 
         ASSIGN l-primeira-atualizacao = NO.

END.

DEF TEMP-TABLE tt-alt-ncm NO-UNDO
     FIELD ncm         LIKE classif-fisc.class-fiscal
     FIELD aliq-ipi    AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD trib-ipi    AS CHAR EXTENT 2
     FIELD pis         AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD cofins      AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD pis-ext     AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD cofins-ext  AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD imposto-imp AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD majorada    AS DEC  EXTENT 2 FORMAT ">>9.99".

DEF TEMP-TABLE tt-alt-item NO-UNDO
     FIELD it-codigo    LIKE ITEM.it-codigo
     FIELD aliq-ipi     AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD trib-ipi     AS CHAR EXTENT 2 
     FIELD trib-import  AS CHAR EXTENT 2
     FIELD imposto-imp  AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD aliq-pis     AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD aliq-cofins  AS DEC  EXTENT 2 FORMAT ">>9.99"
     FIELD trib-icms    AS CHAR EXTENT 2
     FIELD necessita-li AS CHAR EXTENT 2 FORMAT "Sim/NÆo"
     FIELD destaque     AS INTEGER EXTENT 2 FORMAT "999"
     FIELD nve          AS CHAR EXTENT 2 FORMAT "x(100)"
     FIELD ex           AS CHAR EXTENT 2 FORMAT "x(08)"
     FIELD log-gatt     AS CHAR EXTENT  2 FORMAT "Sim/NÆo"
     FIELD perc-gatt    AS DEC EXTENT  2 FORMAT ">>9.99".

define temp-table tt-envio
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes.

define temp-table tt-envio2
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem1
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.

define temp-table tt-erros-1
    field cod-erro  as integer
    field desc-erro as character format "x(256)"
    field desc-arq  as character.

DEF STREAM s.  

DEF VAR CArqEmail AS CHAR NO-UNDO.

DEF VAR c-ncm-corrente AS CHAR NO-UNDO.
DEF VAR l-acao-filtrar AS LOGICAL NO-UNDO.

{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME br-Acordos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES fiscosoft-acordos fiscosoft-acordo-ptr04 ~
fiscosoft-defesa-comercial fiscosoft-ex-br-simples fiscosoft-icms-convenio ~
tt-item fiscosoft-list-ex fiscosoft-list-ex-bit fiscosoft-naladi-1996 ~
fiscosoft-naladi-2002 fiscosoft-naladi-2007 fiscosoft-notas-complementares ~
fiscosoft-nve fiscosoft-pis-cofins fiscosoft-red-import fiscosoft-sistemas ~
fiscosoft-ipi-det fiscosoft-tra-siscomex fiscosoft-ncm

/* Definitions for BROWSE br-Acordos                                    */
&Scoped-define FIELDS-IN-QUERY-br-Acordos fiscosoft-acordos.ex ~
fiscosoft-acordos.tipo-codigo fiscosoft-acordos.acordo ~
fiscosoft-acordos.anotacoes-imp fiscosoft-acordos.anotacoes-exp ~
fiscosoft-acordos.aliq fiscosoft-acordos.pp-imp fiscosoft-acordos.pp-exp ~
fiscosoft-acordos.vigencia-de fiscosoft-acordos.vigencia-ate 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-Acordos 
&Scoped-define QUERY-STRING-br-Acordos FOR EACH fiscosoft-acordos ~
      WHERE fiscosoft-acordos.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-acordos.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-Acordos OPEN QUERY br-Acordos FOR EACH fiscosoft-acordos ~
      WHERE fiscosoft-acordos.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-acordos.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-Acordos fiscosoft-acordos
&Scoped-define FIRST-TABLE-IN-QUERY-br-Acordos fiscosoft-acordos


/* Definitions for BROWSE br-acordos-ptr04                              */
&Scoped-define FIELDS-IN-QUERY-br-acordos-ptr04 ~
fiscosoft-acordo-ptr04.codigo-ncm fiscosoft-acordo-ptr04.dt-baixa ~
fiscosoft-acordo-ptr04.exceto fiscosoft-acordo-ptr04.naladi-1996 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-acordos-ptr04 
&Scoped-define QUERY-STRING-br-acordos-ptr04 FOR EACH fiscosoft-acordo-ptr04 ~
      WHERE fiscosoft-acordo-ptr04.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-acordo-ptr04.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa ~
 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-acordos-ptr04 OPEN QUERY br-acordos-ptr04 FOR EACH fiscosoft-acordo-ptr04 ~
      WHERE fiscosoft-acordo-ptr04.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-acordo-ptr04.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-acordos-ptr04 fiscosoft-acordo-ptr04
&Scoped-define FIRST-TABLE-IN-QUERY-br-acordos-ptr04 fiscosoft-acordo-ptr04


/* Definitions for BROWSE br-defesa-comerc                              */
&Scoped-define FIELDS-IN-QUERY-br-defesa-comerc ~
fiscosoft-defesa-comercial.produto fiscosoft-defesa-comercial.pais ~
fiscosoft-defesa-comercial.medida ~
fiscosoft-defesa-comercial.direito-aplicado ~
fiscosoft-defesa-comercial.vigencia-ate ~
fiscosoft-defesa-comercial.vigencia-de ~
fiscosoft-defesa-comercial.observacoes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-defesa-comerc 
&Scoped-define QUERY-STRING-br-defesa-comerc FOR EACH fiscosoft-defesa-comercial ~
      WHERE fiscosoft-defesa-comercial.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-defesa-comercial.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-defesa-comerc OPEN QUERY br-defesa-comerc FOR EACH fiscosoft-defesa-comercial ~
      WHERE fiscosoft-defesa-comercial.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-defesa-comercial.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-defesa-comerc fiscosoft-defesa-comercial
&Scoped-define FIRST-TABLE-IN-QUERY-br-defesa-comerc fiscosoft-defesa-comercial


/* Definitions for BROWSE br-ex-tarif                                   */
&Scoped-define FIELDS-IN-QUERY-br-ex-tarif fiscosoft-ex-br-simples.ex ~
fiscosoft-ex-br-simples.descricao fiscosoft-ex-br-simples.aliquota ~
fiscosoft-ex-br-simples.bkbit fiscosoft-ex-br-simples.observacoes ~
fiscosoft-ex-br-simples.vigencia-ate fiscosoft-ex-br-simples.vigencia-de 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ex-tarif 
&Scoped-define QUERY-STRING-br-ex-tarif FOR EACH fiscosoft-ex-br-simples ~
      WHERE fiscosoft-ex-br-simples.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-ex-br-simples.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-ex-tarif OPEN QUERY br-ex-tarif FOR EACH fiscosoft-ex-br-simples ~
      WHERE fiscosoft-ex-br-simples.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-ex-br-simples.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-ex-tarif fiscosoft-ex-br-simples
&Scoped-define FIRST-TABLE-IN-QUERY-br-ex-tarif fiscosoft-ex-br-simples


/* Definitions for BROWSE br-ICMS                                       */
&Scoped-define FIELDS-IN-QUERY-br-ICMS ~
fiscosoft-icms-convenio.descriminacao fiscosoft-icms-convenio.convenio ~
fiscosoft-icms-convenio.anexo fiscosoft-icms-convenio.tratamento ~
fiscosoft-icms-convenio.resumo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ICMS 
&Scoped-define QUERY-STRING-br-ICMS FOR EACH fiscosoft-icms-convenio ~
      WHERE fiscosoft-icms-convenio.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-icms-convenio.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-ICMS OPEN QUERY br-ICMS FOR EACH fiscosoft-icms-convenio ~
      WHERE fiscosoft-icms-convenio.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-icms-convenio.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-ICMS fiscosoft-icms-convenio
&Scoped-define FIRST-TABLE-IN-QUERY-br-ICMS fiscosoft-icms-convenio


/* Definitions for BROWSE br-Itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-Itens ~
fnSelecao(tt-item.selecionado) @ c-selecionado tt-item.it-codigo ~
tt-item.desc-item tt-item.aliquota-ii tt-item.ind-ipi-dife ~
IF (tt-item.cd-trib-ipi = 1) THEN ("Tributado") ELSE (            if  (tt-item.cd-trib-ipi = 2) then ("Isento") else (   IF (tt-item.cd-trib-ipi = 3) THEN ("Outros") else ("Reduzido")           )         )  format "x(10)" ~
tt-item.aliquota-ipi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-Itens 
&Scoped-define QUERY-STRING-br-Itens FOR EACH tt-item NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-Itens OPEN QUERY br-Itens FOR EACH tt-item NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-Itens tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-Itens tt-item


/* Definitions for BROWSE br-list-ex                                    */
&Scoped-define FIELDS-IN-QUERY-br-list-ex fiscosoft-list-ex.ex ~
fiscosoft-list-ex.descricao fiscosoft-list-ex.aliquota ~
fiscosoft-list-ex.observacoes fiscosoft-list-ex.indicadores ~
fiscosoft-list-ex.vigencia-ate fiscosoft-list-ex.vigencia-de 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-list-ex 
&Scoped-define QUERY-STRING-br-list-ex FOR EACH fiscosoft-list-ex ~
      WHERE fiscosoft-list-ex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-list-ex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-list-ex OPEN QUERY br-list-ex FOR EACH fiscosoft-list-ex ~
      WHERE fiscosoft-list-ex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-list-ex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-list-ex fiscosoft-list-ex
&Scoped-define FIRST-TABLE-IN-QUERY-br-list-ex fiscosoft-list-ex


/* Definitions for BROWSE br-list-ex-bens                               */
&Scoped-define FIELDS-IN-QUERY-br-list-ex-bens ~
fiscosoft-list-ex-bit.descricao fiscosoft-list-ex-bit.aliquota ~
fiscosoft-list-ex-bit.observacoes fiscosoft-list-ex-bit.indicadores ~
fiscosoft-list-ex-bit.vigencia-ate fiscosoft-list-ex-bit.vigencia-de 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-list-ex-bens 
&Scoped-define QUERY-STRING-br-list-ex-bens FOR EACH fiscosoft-list-ex-bit ~
      WHERE fiscosoft-list-ex-bit.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-list-ex-bit.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-list-ex-bens OPEN QUERY br-list-ex-bens FOR EACH fiscosoft-list-ex-bit ~
      WHERE fiscosoft-list-ex-bit.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-list-ex-bit.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-list-ex-bens fiscosoft-list-ex-bit
&Scoped-define FIRST-TABLE-IN-QUERY-br-list-ex-bens fiscosoft-list-ex-bit


/* Definitions for BROWSE br-naladi-1996                                */
&Scoped-define FIELDS-IN-QUERY-br-naladi-1996 fiscosoft-naladi-1996.codigo ~
fiscosoft-naladi-1996.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-naladi-1996 
&Scoped-define QUERY-STRING-br-naladi-1996 FOR EACH fiscosoft-naladi-1996 ~
      WHERE fiscosoft-naladi-1996.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-1996.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-naladi-1996 OPEN QUERY br-naladi-1996 FOR EACH fiscosoft-naladi-1996 ~
      WHERE fiscosoft-naladi-1996.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-1996.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-naladi-1996 fiscosoft-naladi-1996
&Scoped-define FIRST-TABLE-IN-QUERY-br-naladi-1996 fiscosoft-naladi-1996


/* Definitions for BROWSE br-naladi-2002                                */
&Scoped-define FIELDS-IN-QUERY-br-naladi-2002 fiscosoft-naladi-2002.codigo ~
fiscosoft-naladi-2002.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-naladi-2002 
&Scoped-define QUERY-STRING-br-naladi-2002 FOR EACH fiscosoft-naladi-2002 ~
      WHERE fiscosoft-naladi-2002.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-2002.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-naladi-2002 OPEN QUERY br-naladi-2002 FOR EACH fiscosoft-naladi-2002 ~
      WHERE fiscosoft-naladi-2002.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-2002.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-naladi-2002 fiscosoft-naladi-2002
&Scoped-define FIRST-TABLE-IN-QUERY-br-naladi-2002 fiscosoft-naladi-2002


/* Definitions for BROWSE br-naladi-2007                                */
&Scoped-define FIELDS-IN-QUERY-br-naladi-2007 fiscosoft-naladi-2007.codigo ~
fiscosoft-naladi-2007.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-naladi-2007 
&Scoped-define QUERY-STRING-br-naladi-2007 FOR EACH fiscosoft-naladi-2007 ~
      WHERE fiscosoft-naladi-2007.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-2007.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-naladi-2007 OPEN QUERY br-naladi-2007 FOR EACH fiscosoft-naladi-2007 ~
      WHERE fiscosoft-naladi-2007.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-naladi-2007.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-naladi-2007 fiscosoft-naladi-2007
&Scoped-define FIRST-TABLE-IN-QUERY-br-naladi-2007 fiscosoft-naladi-2007


/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas ~
fiscosoft-notas-complementares.codigo ~
fiscosoft-notas-complementares.observacao ~
fiscosoft-notas-complementares.vigencia-de ~
fiscosoft-notas-complementares.vigencia-ate ~
fiscosoft-notas-complementares.seq-ipi-det 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas 
&Scoped-define QUERY-STRING-br-notas FOR EACH fiscosoft-notas-complementares ~
      WHERE fiscosoft-notas-complementares.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-notas-complementares.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa ~
 and fiscosoft-notas-complementares.seq-ipi-det = INPUT BROWSE br-tipi fiscosoft-ipi-det.seq-ipi-det NO-LOCK ~
    BY fiscosoft-notas-complementares.codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY br-notas FOR EACH fiscosoft-notas-complementares ~
      WHERE fiscosoft-notas-complementares.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-notas-complementares.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa ~
 and fiscosoft-notas-complementares.seq-ipi-det = INPUT BROWSE br-tipi fiscosoft-ipi-det.seq-ipi-det NO-LOCK ~
    BY fiscosoft-notas-complementares.codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-notas fiscosoft-notas-complementares
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas fiscosoft-notas-complementares


/* Definitions for BROWSE br-NVE                                        */
&Scoped-define FIELDS-IN-QUERY-br-NVE fiscosoft-nve.nivel ~
fiscosoft-nve.atributo fiscosoft-nve.especificacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-NVE 
&Scoped-define QUERY-STRING-br-NVE FOR EACH fiscosoft-nve ~
      WHERE fiscosoft-nve.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-nve.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-NVE OPEN QUERY br-NVE FOR EACH fiscosoft-nve ~
      WHERE fiscosoft-nve.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-nve.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-NVE fiscosoft-nve
&Scoped-define FIRST-TABLE-IN-QUERY-br-NVE fiscosoft-nve


/* Definitions for BROWSE br-PisCofins                                  */
&Scoped-define FIELDS-IN-QUERY-br-PisCofins fiscosoft-pis-cofins.pis ~
fiscosoft-pis-cofins.cofins fiscosoft-pis-cofins.anotacao ~
fiscosoft-pis-cofins.grupo fiscosoft-pis-cofins.classificacao ~
fiscosoft-pis-cofins.principal fiscosoft-pis-cofins.vigencia-ate ~
fiscosoft-pis-cofins.vigencia-de 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-PisCofins 
&Scoped-define QUERY-STRING-br-PisCofins FOR EACH fiscosoft-pis-cofins ~
      WHERE fiscosoft-pis-cofins.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-pis-cofins.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-PisCofins OPEN QUERY br-PisCofins FOR EACH fiscosoft-pis-cofins ~
      WHERE fiscosoft-pis-cofins.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-pis-cofins.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-PisCofins fiscosoft-pis-cofins
&Scoped-define FIRST-TABLE-IN-QUERY-br-PisCofins fiscosoft-pis-cofins


/* Definitions for BROWSE br-quotas-tarif                               */
&Scoped-define FIELDS-IN-QUERY-br-quotas-tarif fiscosoft-red-import.ex ~
fiscosoft-red-import.descricao fiscosoft-red-import.aliquota ~
fiscosoft-red-import.quota fiscosoft-red-import.observacoes ~
fiscosoft-red-import.indicadores fiscosoft-red-import.vigencia-de ~
fiscosoft-red-import.vigencia-ate 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-quotas-tarif 
&Scoped-define QUERY-STRING-br-quotas-tarif FOR EACH fiscosoft-red-import ~
      WHERE fiscosoft-red-import.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-red-import.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-quotas-tarif OPEN QUERY br-quotas-tarif FOR EACH fiscosoft-red-import ~
      WHERE fiscosoft-red-import.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-red-import.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-quotas-tarif fiscosoft-red-import
&Scoped-define FIRST-TABLE-IN-QUERY-br-quotas-tarif fiscosoft-red-import


/* Definitions for BROWSE br-sistema                                    */
&Scoped-define FIELDS-IN-QUERY-br-sistema fiscosoft-sistemas.descricao ~
fiscosoft-sistemas.aliquota fiscosoft-sistemas.observacoes ~
fiscosoft-sistemas.vigencia-de fiscosoft-sistemas.vigencia-ate 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-sistema 
&Scoped-define QUERY-STRING-br-sistema FOR EACH fiscosoft-sistemas ~
      WHERE fiscosoft-sistemas.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-sistemas.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-sistema OPEN QUERY br-sistema FOR EACH fiscosoft-sistemas ~
      WHERE fiscosoft-sistemas.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-sistemas.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-sistema fiscosoft-sistemas
&Scoped-define FIRST-TABLE-IN-QUERY-br-sistema fiscosoft-sistemas


/* Definitions for BROWSE br-tipi                                       */
&Scoped-define FIELDS-IN-QUERY-br-tipi fiscosoft-ipi-det.descricao ~
fiscosoft-ipi-det.anotacoes fiscosoft-ipi-det.ex fiscosoft-ipi-det.aliquota ~
fiscosoft-ipi-det.vigencia-de fiscosoft-ipi-det.vigencia-ate ~
fiscosoft-ipi-det.seq-ipi-det 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tipi 
&Scoped-define QUERY-STRING-br-tipi FOR EACH fiscosoft-ipi-det ~
      WHERE fiscosoft-ipi-det.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-ipi-det.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tipi OPEN QUERY br-tipi FOR EACH fiscosoft-ipi-det ~
      WHERE fiscosoft-ipi-det.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-ipi-det.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tipi fiscosoft-ipi-det
&Scoped-define FIRST-TABLE-IN-QUERY-br-tipi fiscosoft-ipi-det


/* Definitions for BROWSE br-tratam-admin                               */
&Scoped-define FIELDS-IN-QUERY-br-tratam-admin fiscosoft-tra-siscomex.ncm ~
fiscosoft-tra-siscomex.orgao-anuente fiscosoft-tra-siscomex.indicadores ~
fiscosoft-tra-siscomex.tratamento fiscosoft-tra-siscomex.ex ~
fiscosoft-tra-siscomex.ex-descricao fiscosoft-tra-siscomex.fundamento-legal ~
fiscosoft-tra-siscomex.descricao-mercadoria fiscosoft-tra-siscomex.excecoes ~
fiscosoft-tra-siscomex.vigencia-ate fiscosoft-tra-siscomex.vigencia-de 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tratam-admin 
&Scoped-define QUERY-STRING-br-tratam-admin FOR EACH fiscosoft-tra-siscomex ~
      WHERE fiscosoft-tra-siscomex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-tra-siscomex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tratam-admin OPEN QUERY br-tratam-admin FOR EACH fiscosoft-tra-siscomex ~
      WHERE fiscosoft-tra-siscomex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo ~
 AND fiscosoft-tra-siscomex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tratam-admin fiscosoft-tra-siscomex
&Scoped-define FIRST-TABLE-IN-QUERY-br-tratam-admin fiscosoft-tra-siscomex


/* Definitions for BROWSE brNCM                                         */
&Scoped-define FIELDS-IN-QUERY-brNCM fiscosoft-ncm.codigo ~
fiscosoft-ncm.dt-baixa fiscosoft-ncm.descricao fiscosoft-ncm.aliquota ~
fiscosoft-ncm.ipi fiscosoft-ncm.pis fiscosoft-ncm.cofins fiscosoft-ncm.icms ~
fiscosoft-ncm.ume fiscosoft-ncm.indicadores fiscosoft-ncm.ver-excecao-tec ~
fiscosoft-ncm.ver-excecao-tipi fiscosoft-ncm.vigencia-de ~
fiscosoft-ncm.vigencia-ate 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNCM 
&Scoped-define QUERY-STRING-brNCM FOR EACH fiscosoft-ncm ~
      WHERE fiscosoft-ncm.dt-baixa >= da-atualizacao  ~
 AND fiscosoft-ncm.codigo >= input frame fpage0 c-ncm-ini  ~
 and fiscosoft-ncm.codigo <= input frame fpage0 c-ncm-fim  ~
 AND if tg-posicoes:checked then length(mgesp.fiscosoft-ncm.codigo) = 8 else yes use-index idx-ncm-data NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brNCM OPEN QUERY brNCM FOR EACH fiscosoft-ncm ~
      WHERE fiscosoft-ncm.dt-baixa >= da-atualizacao  ~
 AND fiscosoft-ncm.codigo >= input frame fpage0 c-ncm-ini  ~
 and fiscosoft-ncm.codigo <= input frame fpage0 c-ncm-fim  ~
 AND if tg-posicoes:checked then length(mgesp.fiscosoft-ncm.codigo) = 8 else yes use-index idx-ncm-data NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brNCM fiscosoft-ncm
&Scoped-define FIRST-TABLE-IN-QUERY-brNCM fiscosoft-ncm


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-br-Acordos}~
    ~{&OPEN-QUERY-br-acordos-ptr04}~
    ~{&OPEN-QUERY-br-defesa-comerc}~
    ~{&OPEN-QUERY-br-ex-tarif}~
    ~{&OPEN-QUERY-br-ICMS}~
    ~{&OPEN-QUERY-br-Itens}~
    ~{&OPEN-QUERY-br-list-ex}~
    ~{&OPEN-QUERY-br-list-ex-bens}~
    ~{&OPEN-QUERY-br-naladi-1996}~
    ~{&OPEN-QUERY-br-naladi-2002}~
    ~{&OPEN-QUERY-br-naladi-2007}~
    ~{&OPEN-QUERY-br-notas}~
    ~{&OPEN-QUERY-br-NVE}~
    ~{&OPEN-QUERY-br-PisCofins}~
    ~{&OPEN-QUERY-br-quotas-tarif}~
    ~{&OPEN-QUERY-br-sistema}~
    ~{&OPEN-QUERY-br-tipi}~
    ~{&OPEN-QUERY-br-tratam-admin}~
    ~{&OPEN-QUERY-brNCM}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
btBaixarAtu rs-atual da-ini c-ncm-ini c-ncm-fim tg-posicoes btVisualizar ~
c-ncm-rapida btBuscar l-escolha btMarcarTodosItens btDesmarcarTodosItens ~
btBusca-item btAtualizarInfoItens rs-item bt-detalha-nota c-item fi-cor ~
rtToolBar-2 RECT-1 RECT-2 RECT-3 IM-1 IM-2 IM-3 IM-4 IM-5 IM-6 IM-7 IM-8 ~
IM-9 IM-10 brNCM IM-11 IM-12 IM-13 IM-14 br-sistema IM-15 IM-16 ~
br-tratam-admin IM-17 RECT-4 br-quotas-tarif br-Acordos br-acordos-ptr04 ~
br-tipi br-ex-tarif br-Itens br-list-ex br-PisCofins br-NVE br-naladi-2002 ~
br-naladi-2007 br-naladi-1996 br-list-ex-bens br-notas br-ICMS ~
br-defesa-comerc 
&Scoped-Define DISPLAYED-OBJECTS rs-atual da-ini c-ncm-ini c-ncm-fim ~
tg-posicoes c-ncm-rapida l-escolha rs-item c-item fi-cor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 br-sistema br-tratam-admin br-quotas-tarif br-Acordos ~
br-acordos-ptr04 br-tipi br-ex-tarif br-Itens br-list-ex br-PisCofins ~
br-NVE br-naladi-2002 br-naladi-2007 br-naladi-1996 br-list-ex-bens ~
br-notas br-ICMS br-defesa-comerc 
&Scoped-define List-2 IM-1 IM-2 IM-3 IM-4 IM-5 IM-6 IM-7 IM-8 IM-9 IM-10 ~
IM-11 IM-12 IM-13 IM-14 IM-15 IM-16 IM-17 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataAte wWindow 
FUNCTION fnDataAte RETURNS DATE
  ( pData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataDe wWindow 
FUNCTION fnDataDe RETURNS DATE
  ( pData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSelecao wWindow 
FUNCTION fnSelecao RETURNS CHARACTER
  ( pSelecionado AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-detalha-nota 
     LABEL "Detalhar Nota" 
     SIZE 14.29 BY .92.

DEFINE BUTTON btAtualizarInfoItens 
     LABEL "Atualizar Itens" 
     SIZE 14 BY 1 TOOLTIP "Atualiza Informa‡äes dos Itens".

DEFINE BUTTON btBaixarAtu 
     LABEL "Baixar Atualiza‡äes" 
     SIZE 15 BY 1 TOOLTIP "Baixar novas atualiza‡äes do FISCOSoft".

DEFINE BUTTON btBusca-item 
     IMAGE-UP FILE "image\im-sea":U
     LABEL "Query Joins" 
     SIZE 4 BY 1
     FONT 4.

DEFINE BUTTON btBuscar 
     IMAGE-UP FILE "image/im-sea":U
     LABEL "Query Joins" 
     SIZE 4 BY 1
     FONT 4.

DEFINE BUTTON btDesmarcarTodosItens 
     LABEL "Desmarcar Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btMarcarTodosItens 
     LABEL "Marcar Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btVisualizar 
     LABEL "Visualizar" 
     SIZE 15 BY 1 TOOLTIP "Baixar novas atualiza‡äes do FISCOSoft".

DEFINE VARIABLE c-item AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .92 NO-UNDO.

DEFINE VARIABLE c-ncm-fim AS CHARACTER FORMAT "x(8)":U INITIAL "99999999" 
     LABEL "NCM Fim" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-ini AS CHARACTER FORMAT "x(8)":U 
     LABEL "NCM Inicio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-rapida AS CHARACTER FORMAT "x(8)":U 
     LABEL "Busca R pida de NCM" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .92 NO-UNDO.

DEFINE VARIABLE da-ini AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cor AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.72 BY .67
     BGCOLOR 10 FGCOLOR 10  NO-UNDO.

DEFINE IMAGE IM-1
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-10
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-11
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-12
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-13
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-14
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-15
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-16
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-17
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-2
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-3
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-4
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-5
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-6
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-7
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-8
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE IMAGE IM-9
     FILENAME "adeicon/check.bmp":U
     SIZE 2 BY .5.

DEFINE VARIABLE rs-atual AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Tudo", 1,
"éltima Atualiza‡Æo", 2,
"A Partir de:", 3
     SIZE 16.14 BY 2.04 NO-UNDO.

DEFINE VARIABLE rs-item AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por C¢digo", 1,
"Por Descri‡Æo", 2,
"Sem Filtro", 3
     SIZE 33 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 164 BY 12.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 164 BY 9.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 8.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 1.13.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 164 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-escolha AS CHARACTER INITIAL "Itens" 
     VIEW-AS SELECTION-LIST SINGLE 
     LIST-ITEMS "Itens","TIPI","Lista Ex","Lista Ex bens","Ex Tarif.","Sist integrado","Quota Tarif.","Nom Val Aduan.","NALADI_1996","NALADI_2002","NALADI_2007","Defesa Comerc.","ICMS","Acordos INT.","Acordos INT Ptr04","Tratam. Admin.","PIS/COFINS" 
     SIZE 21 BY 10.83
     FGCOLOR 1 FONT 0 NO-UNDO.

DEFINE VARIABLE tg-posicoes AS LOGICAL INITIAL no 
     LABEL "NCMs com 8 posi‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-Acordos FOR 
      fiscosoft-acordos SCROLLING.

DEFINE QUERY br-acordos-ptr04 FOR 
      fiscosoft-acordo-ptr04 SCROLLING.

DEFINE QUERY br-defesa-comerc FOR 
      fiscosoft-defesa-comercial SCROLLING.

DEFINE QUERY br-ex-tarif FOR 
      fiscosoft-ex-br-simples SCROLLING.

DEFINE QUERY br-ICMS FOR 
      fiscosoft-icms-convenio SCROLLING.

DEFINE QUERY br-Itens FOR 
      tt-item SCROLLING.

DEFINE QUERY br-list-ex FOR 
      fiscosoft-list-ex SCROLLING.

DEFINE QUERY br-list-ex-bens FOR 
      fiscosoft-list-ex-bit SCROLLING.

DEFINE QUERY br-naladi-1996 FOR 
      fiscosoft-naladi-1996 SCROLLING.

DEFINE QUERY br-naladi-2002 FOR 
      fiscosoft-naladi-2002 SCROLLING.

DEFINE QUERY br-naladi-2007 FOR 
      fiscosoft-naladi-2007 SCROLLING.

DEFINE QUERY br-notas FOR 
      fiscosoft-notas-complementares SCROLLING.

DEFINE QUERY br-NVE FOR 
      fiscosoft-nve SCROLLING.

DEFINE QUERY br-PisCofins FOR 
      fiscosoft-pis-cofins SCROLLING.

DEFINE QUERY br-quotas-tarif FOR 
      fiscosoft-red-import SCROLLING.

DEFINE QUERY br-sistema FOR 
      fiscosoft-sistemas SCROLLING.

DEFINE QUERY br-tipi FOR 
      fiscosoft-ipi-det SCROLLING.

DEFINE QUERY br-tratam-admin FOR 
      fiscosoft-tra-siscomex SCROLLING.

DEFINE QUERY brNCM FOR 
      fiscosoft-ncm SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-Acordos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-Acordos wWindow _STRUCTURED
  QUERY br-Acordos NO-LOCK DISPLAY
      fiscosoft-acordos.ex FORMAT "x(8)":U
      fiscosoft-acordos.tipo-codigo FORMAT "x(8)":U WIDTH 11.57
      fiscosoft-acordos.acordo FORMAT "x(8)":U WIDTH 13.43
      fiscosoft-acordos.anotacoes-imp FORMAT "x(120)":U WIDTH 70
      fiscosoft-acordos.anotacoes-exp FORMAT "x(120)":U WIDTH 70
      fiscosoft-acordos.aliq FORMAT "x(20)":U WIDTH 8.43
      fiscosoft-acordos.pp-imp FORMAT "x(20)":U WIDTH 9.43
      fiscosoft-acordos.pp-exp FORMAT "x(20)":U WIDTH 9.43
      fiscosoft-acordos.vigencia-de FORMAT "x(10)":U WIDTH 10.14
      fiscosoft-acordos.vigencia-ate FORMAT "x(10)":U WIDTH 10.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Acordos das NCMs" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-acordos-ptr04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-acordos-ptr04 wWindow _STRUCTURED
  QUERY br-acordos-ptr04 NO-LOCK DISPLAY
      fiscosoft-acordo-ptr04.codigo-ncm FORMAT "x(15)":U
      fiscosoft-acordo-ptr04.dt-baixa FORMAT "99/99/9999":U
      fiscosoft-acordo-ptr04.exceto FORMAT "x(100)":U WIDTH 50
      fiscosoft-acordo-ptr04.naladi-1996 FORMAT "x(8)":U WIDTH 89.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Acordos INT PTR04" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE br-defesa-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-defesa-comerc wWindow _STRUCTURED
  QUERY br-defesa-comerc NO-LOCK DISPLAY
      fiscosoft-defesa-comercial.produto FORMAT "x(100)":U WIDTH 60
      fiscosoft-defesa-comercial.pais
      fiscosoft-defesa-comercial.medida
      fiscosoft-defesa-comercial.direito-aplicado
      fiscosoft-defesa-comercial.vigencia-ate
      fiscosoft-defesa-comercial.vigencia-de WIDTH 94.57
      fiscosoft-defesa-comercial.observacoes COLUMN-LABEL "Observa‡äes" FORMAT "x(100)":U
            WIDTH 50
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Defesa Comercial" FIT-LAST-COLUMN.

DEFINE BROWSE br-ex-tarif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ex-tarif wWindow _STRUCTURED
  QUERY br-ex-tarif NO-LOCK DISPLAY
      fiscosoft-ex-br-simples.ex
      fiscosoft-ex-br-simples.descricao FORMAT "x(150)":U WIDTH 60
      fiscosoft-ex-br-simples.aliquota
      fiscosoft-ex-br-simples.bkbit FORMAT "x(50)":U
      fiscosoft-ex-br-simples.observacoes FORMAT "X(150)":U WIDTH 40
      fiscosoft-ex-br-simples.vigencia-ate FORMAT "x(10)":U WIDTH 12
      fiscosoft-ex-br-simples.vigencia-de FORMAT "x(10)":U WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "EX Tarif rio" FIT-LAST-COLUMN.

DEFINE BROWSE br-ICMS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ICMS wWindow _STRUCTURED
  QUERY br-ICMS NO-LOCK DISPLAY
      fiscosoft-icms-convenio.descriminacao FORMAT "x(50)":U WIDTH 30
      fiscosoft-icms-convenio.convenio FORMAT "X(50)":U WIDTH 20
      fiscosoft-icms-convenio.anexo FORMAT "x(50)":U WIDTH 20
      fiscosoft-icms-convenio.tratamento FORMAT "x(50)":U WIDTH 20
      fiscosoft-icms-convenio.resumo FORMAT "x(100)":U WIDTH 60
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "ICMS - Convˆnios Federais" FIT-LAST-COLUMN.

DEFINE BROWSE br-Itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-Itens wWindow _STRUCTURED
  QUERY br-Itens NO-LOCK DISPLAY
      fnSelecao(tt-item.selecionado) @ c-selecionado COLUMN-LABEL " *" FORMAT "x(3)":U
            WIDTH 3.43 COLUMN-FGCOLOR 12 COLUMN-BGCOLOR 15 COLUMN-FONT 0
            LABEL-FONT 0
      tt-item.it-codigo FORMAT "x(16)":U WIDTH 13.57
      tt-item.desc-item FORMAT "x(60)":U WIDTH 66
      tt-item.aliquota-ii COLUMN-LABEL "Al¡quota ii" WIDTH 9
      tt-item.ind-ipi-dife COLUMN-LABEL "IPI Diferenciado" FORMAT "Sim/NÆo":U
            WIDTH 12
      IF (tt-item.cd-trib-ipi = 1) THEN ("Tributado") ELSE (            if  (tt-item.cd-trib-ipi = 2) then ("Isento") else (   IF (tt-item.cd-trib-ipi = 3) THEN ("Outros") else ("Reduzido")           )         )  format "x(10)" COLUMN-LABEL "Trib IPI"
            WIDTH 10
      tt-item.aliquota-ipi FORMAT ">>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Itens das NCMs" FIT-LAST-COLUMN.

DEFINE BROWSE br-list-ex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-list-ex wWindow _STRUCTURED
  QUERY br-list-ex NO-LOCK DISPLAY
      fiscosoft-list-ex.ex FORMAT "x(8)":U
      fiscosoft-list-ex.descricao FORMAT "x(150)":U WIDTH 60
      fiscosoft-list-ex.aliquota FORMAT "x(8)":U
      fiscosoft-list-ex.observacoes FORMAT "x(200)":U WIDTH 40
      fiscosoft-list-ex.indicadores FORMAT "x(8)":U
      fiscosoft-list-ex.vigencia-ate FORMAT "x(10)":U WIDTH 12
      fiscosoft-list-ex.vigencia-de FORMAT "x(10)":U WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Lista de Exce‡Æo … TEC" FIT-LAST-COLUMN.

DEFINE BROWSE br-list-ex-bens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-list-ex-bens wWindow _STRUCTURED
  QUERY br-list-ex-bens NO-LOCK DISPLAY
      fiscosoft-list-ex-bit.descricao FORMAT "x(150)":U WIDTH 50
      fiscosoft-list-ex-bit.aliquota
      fiscosoft-list-ex-bit.observacoes FORMAT "x(150)":U WIDTH 40
      fiscosoft-list-ex-bit.indicadores
      fiscosoft-list-ex-bit.vigencia-ate FORMAT "x(10)":U WIDTH 12
      fiscosoft-list-ex-bit.vigencia-de FORMAT "x(10)":U WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Lista de Exce‡Æo de Bens de Inform tica e Telecomunica‡äes" FIT-LAST-COLUMN.

DEFINE BROWSE br-naladi-1996
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-naladi-1996 wWindow _STRUCTURED
  QUERY br-naladi-1996 NO-LOCK DISPLAY
      fiscosoft-naladi-1996.codigo FORMAT "x(20)":U WIDTH 10
      fiscosoft-naladi-1996.descricao FORMAT "x(150)":U WIDTH 127.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "NALADI 1996" FIT-LAST-COLUMN.

DEFINE BROWSE br-naladi-2002
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-naladi-2002 wWindow _STRUCTURED
  QUERY br-naladi-2002 NO-LOCK DISPLAY
      fiscosoft-naladi-2002.codigo FORMAT "x(20)":U WIDTH 10
      fiscosoft-naladi-2002.descricao FORMAT "x(150)":U WIDTH 127.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "NALADI 2002" FIT-LAST-COLUMN.

DEFINE BROWSE br-naladi-2007
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-naladi-2007 wWindow _STRUCTURED
  QUERY br-naladi-2007 NO-LOCK DISPLAY
      fiscosoft-naladi-2007.codigo FORMAT "x(20)":U WIDTH 10
      fiscosoft-naladi-2007.descricao FORMAT "x(150)":U WIDTH 127.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "NALADI 2007" FIT-LAST-COLUMN.

DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _STRUCTURED
  QUERY br-notas NO-LOCK DISPLAY
      fiscosoft-notas-complementares.codigo FORMAT "x(15)":U
      fiscosoft-notas-complementares.observacao FORMAT "x(200)":U
            WIDTH 50
      fiscosoft-notas-complementares.vigencia-de FORMAT "x(10)":U
            WIDTH 12
      fiscosoft-notas-complementares.vigencia-ate FORMAT "x(10)":U
            WIDTH 12
      fiscosoft-notas-complementares.seq-ipi-det FORMAT ">>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 4.67
         FONT 1
         TITLE "Notas Complementares" FIT-LAST-COLUMN.

DEFINE BROWSE br-NVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-NVE wWindow _STRUCTURED
  QUERY br-NVE NO-LOCK DISPLAY
      fiscosoft-nve.nivel FORMAT "x(30)":U
      fiscosoft-nve.atributo FORMAT "x(30)":U WIDTH 40.43
      fiscosoft-nve.especificacao FORMAT "x(300)":U WIDTH 140
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "NOMENCLATURA VALOR ADUANEIRO" ROW-HEIGHT-CHARS .5.

DEFINE BROWSE br-PisCofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-PisCofins wWindow _STRUCTURED
  QUERY br-PisCofins NO-LOCK DISPLAY
      fiscosoft-pis-cofins.pis
      fiscosoft-pis-cofins.cofins
      fiscosoft-pis-cofins.anotacao FORMAT "x(200)":U WIDTH 50
      fiscosoft-pis-cofins.grupo
      fiscosoft-pis-cofins.classificacao FORMAT "x(10)":U WIDTH 6
      fiscosoft-pis-cofins.principal FORMAT "x(20)":U WIDTH 10
      fiscosoft-pis-cofins.vigencia-ate
      fiscosoft-pis-cofins.vigencia-de WIDTH 86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Pis e Cofins" FIT-LAST-COLUMN.

DEFINE BROWSE br-quotas-tarif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-quotas-tarif wWindow _STRUCTURED
  QUERY br-quotas-tarif NO-LOCK DISPLAY
      fiscosoft-red-import.ex
      fiscosoft-red-import.descricao FORMAT "x(250)":U WIDTH 70
      fiscosoft-red-import.aliquota
      fiscosoft-red-import.quota
      fiscosoft-red-import.observacoes FORMAT "x(150)":U
      fiscosoft-red-import.indicadores FORMAT "x(20)":U WIDTH 10
      fiscosoft-red-import.vigencia-de FORMAT "x(15)":U WIDTH 8
      fiscosoft-red-import.vigencia-ate FORMAT "x(15)":U WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Quota Tarif ria" FIT-LAST-COLUMN.

DEFINE BROWSE br-sistema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-sistema wWindow _STRUCTURED
  QUERY br-sistema NO-LOCK DISPLAY
      fiscosoft-sistemas.descricao FORMAT "x(250)":U WIDTH 60
      fiscosoft-sistemas.aliquota
      fiscosoft-sistemas.observacoes FORMAT "x(200)":U WIDTH 40
      fiscosoft-sistemas.vigencia-de FORMAT "x(10)":U WIDTH 12
      fiscosoft-sistemas.vigencia-ate FORMAT "x(10)":U WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Sistema integrado" FIT-LAST-COLUMN.

DEFINE BROWSE br-tipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tipi wWindow _STRUCTURED
  QUERY br-tipi NO-LOCK DISPLAY
      fiscosoft-ipi-det.descricao FORMAT "x(200)":U WIDTH 60
      fiscosoft-ipi-det.anotacoes FORMAT "x(100)":U WIDTH 30
      fiscosoft-ipi-det.ex FORMAT "x(50)":U WIDTH 20
      fiscosoft-ipi-det.aliquota FORMAT "x(8)":U
      fiscosoft-ipi-det.vigencia-de FORMAT "x(10)":U WIDTH 12
      fiscosoft-ipi-det.vigencia-ate FORMAT "x(10)":U WIDTH 12
      fiscosoft-ipi-det.seq-ipi-det FORMAT ">>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 5.29
         FONT 1
         TITLE "TIPI" FIT-LAST-COLUMN.

DEFINE BROWSE br-tratam-admin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tratam-admin wWindow _STRUCTURED
  QUERY br-tratam-admin NO-LOCK DISPLAY
      fiscosoft-tra-siscomex.ncm
      fiscosoft-tra-siscomex.orgao-anuente
      fiscosoft-tra-siscomex.indicadores
      fiscosoft-tra-siscomex.tratamento FORMAT "x(50)":U WIDTH 20
      fiscosoft-tra-siscomex.ex
      fiscosoft-tra-siscomex.ex-descricao FORMAT "x(200)":U WIDTH 60
      fiscosoft-tra-siscomex.fundamento-legal FORMAT "x(50)":U
            WIDTH 20
      fiscosoft-tra-siscomex.descricao-mercadoria FORMAT "x(80)":U
            WIDTH 40
      fiscosoft-tra-siscomex.excecoes FORMAT "x(20)":U WIDTH 10
      fiscosoft-tra-siscomex.vigencia-ate
      fiscosoft-tra-siscomex.vigencia-de WIDTH 70.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 10.21
         FONT 1
         TITLE "Tratamento Adminstrativo (SISCOMEX)" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE brNCM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNCM wWindow _STRUCTURED
  QUERY brNCM NO-LOCK DISPLAY
      fiscosoft-ncm.codigo COLUMN-LABEL "NCM" FORMAT "x(15)":U
      fiscosoft-ncm.dt-baixa FORMAT "99/99/9999":U WIDTH 10.14
      fiscosoft-ncm.descricao FORMAT "x(200)":U WIDTH 57.86
      fiscosoft-ncm.aliquota COLUMN-LABEL "Aliquota ii" FORMAT "x(20)":U
            WIDTH 10.43
      fiscosoft-ncm.ipi FORMAT "x(20)":U WIDTH 10.43
      fiscosoft-ncm.pis FORMAT "x(20)":U WIDTH 10.43
      fiscosoft-ncm.cofins FORMAT "x(20)":U WIDTH 10.43
      fiscosoft-ncm.icms FORMAT "x(20)":U WIDTH 10.43
      fiscosoft-ncm.ume FORMAT "x(8)":U WIDTH 4.43
      fiscosoft-ncm.indicadores FORMAT "x(20)":U WIDTH 9.72
      fiscosoft-ncm.ver-excecao-tec FORMAT "x(50)":U WIDTH 9.43
      fiscosoft-ncm.ver-excecao-tipi FORMAT "x(50)":U WIDTH 9.43
      fiscosoft-ncm.vigencia-de FORMAT "x(10)":U
      fiscosoft-ncm.vigencia-ate FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 139 BY 7.75
         FONT 1
         TITLE "NCMs" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 148.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 152.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 156.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 160.29 HELP
          "Ajuda"
     btBaixarAtu AT ROW 1.25 COL 75 HELP
          "Baixar novas atualiza‡äes do FISCOSoft" WIDGET-ID 26
     rs-atual AT ROW 3.71 COL 5.86 NO-LABEL WIDGET-ID 42
     da-ini AT ROW 5.92 COL 6.57 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     c-ncm-ini AT ROW 7.42 COL 11.14 COLON-ALIGNED WIDGET-ID 56
     c-ncm-fim AT ROW 8.42 COL 11.14 COLON-ALIGNED WIDGET-ID 58
     tg-posicoes AT ROW 9.67 COL 4.29 WIDGET-ID 124
     btVisualizar AT ROW 10.75 COL 6.43 HELP
          "Baixar novas atualiza‡äes do FISCOSoft" WIDGET-ID 2
     c-ncm-rapida AT ROW 3.13 COL 41 COLON-ALIGNED WIDGET-ID 60
     btBuscar AT ROW 3.08 COL 55.29 HELP
          "Consultas relacionadas" WIDGET-ID 62
     l-escolha AT ROW 13.42 COL 5.72 NO-LABEL WIDGET-ID 36
     btMarcarTodosItens AT ROW 23.92 COL 28 WIDGET-ID 34
     btDesmarcarTodosItens AT ROW 23.92 COL 43 WIDGET-ID 32
     btBusca-item AT ROW 23.92 COL 138 HELP
          "Consultas relacionadas" WIDGET-ID 132
     btAtualizarInfoItens AT ROW 23.92 COL 151.14 HELP
          "Atualiza as Informa‡äes dos Itens Selecionados" WIDGET-ID 30
     rs-item AT ROW 23.96 COL 61 NO-LABEL WIDGET-ID 128
     bt-detalha-nota AT ROW 24 COL 85 WIDGET-ID 122
     c-item AT ROW 24 COL 93.43 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     fi-cor AT ROW 3.08 COL 131.86 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     brNCM AT ROW 4.25 COL 26 WIDGET-ID 200
     br-sistema AT ROW 13.46 COL 28 WIDGET-ID 1800
     br-tratam-admin AT ROW 13.46 COL 28 WIDGET-ID 2600
     br-quotas-tarif AT ROW 13.46 COL 28 WIDGET-ID 2000
     br-Acordos AT ROW 13.46 COL 28 WIDGET-ID 1200
     br-acordos-ptr04 AT ROW 13.46 COL 28 WIDGET-ID 2800
     br-tipi AT ROW 13.46 COL 28 WIDGET-ID 1400
     br-ex-tarif AT ROW 13.46 COL 28 WIDGET-ID 1900
     br-Itens AT ROW 13.46 COL 28 WIDGET-ID 300
     br-list-ex AT ROW 13.46 COL 28 WIDGET-ID 1600
     br-PisCofins AT ROW 13.46 COL 28 WIDGET-ID 2700
     br-NVE AT ROW 13.46 COL 28 WIDGET-ID 2900
     br-naladi-2002 AT ROW 13.46 COL 28 WIDGET-ID 2200
     br-naladi-2007 AT ROW 13.46 COL 28 WIDGET-ID 2300
     br-naladi-1996 AT ROW 13.46 COL 28 WIDGET-ID 1300
     br-list-ex-bens AT ROW 13.46 COL 28 WIDGET-ID 1700
     br-notas AT ROW 19 COL 28 WIDGET-ID 1500
     br-ICMS AT ROW 13.46 COL 28 WIDGET-ID 2500
     br-defesa-comerc AT ROW 13.46 COL 28 WIDGET-ID 2400
     "Registro Novo ou Alterado" VIEW-AS TEXT
          SIZE 20.57 BY .54 AT ROW 3.13 COL 142.43 WIDGET-ID 118
     "Pesquisa Atualiza‡äes" VIEW-AS TEXT
          SIZE 17.29 BY .54 AT ROW 3 COL 4.86 WIDGET-ID 48
     "   DETALHES" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 12.67 COL 2.43 WIDGET-ID 52
     rtToolBar-2 AT ROW 1 COL 1
     RECT-1 AT ROW 12.83 COL 2 WIDGET-ID 38
     RECT-2 AT ROW 2.54 COL 2 WIDGET-ID 40
     RECT-3 AT ROW 3.25 COL 3 WIDGET-ID 46
     IM-1 AT ROW 13.54 COL 3.29 WIDGET-ID 70
     IM-2 AT ROW 14.17 COL 3.29 WIDGET-ID 72
     IM-3 AT ROW 14.79 COL 3.29 WIDGET-ID 74
     IM-4 AT ROW 15.42 COL 3.29 WIDGET-ID 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 165.14 BY 24.42
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     IM-5 AT ROW 16.04 COL 3.29 WIDGET-ID 78
     IM-6 AT ROW 16.67 COL 3.29 WIDGET-ID 80
     IM-7 AT ROW 17.29 COL 3.29 WIDGET-ID 82
     IM-8 AT ROW 17.92 COL 3.29 WIDGET-ID 84
     IM-9 AT ROW 18.54 COL 3.29 WIDGET-ID 86
     IM-10 AT ROW 19.17 COL 3.29 WIDGET-ID 88
     IM-11 AT ROW 19.79 COL 3.29 WIDGET-ID 90
     IM-12 AT ROW 20.42 COL 3.29 WIDGET-ID 92
     IM-13 AT ROW 21.04 COL 3.29 WIDGET-ID 100
     IM-14 AT ROW 21.67 COL 3.29 WIDGET-ID 102
     IM-15 AT ROW 22.29 COL 3.29 WIDGET-ID 94
     IM-16 AT ROW 22.92 COL 3.29 WIDGET-ID 96
     IM-17 AT ROW 23.54 COL 3.29 WIDGET-ID 98
     RECT-4 AT ROW 2.88 COL 133 WIDGET-ID 114
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 165.14 BY 24.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-item T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field selecionado as character
          field r-rowid     as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24.46
         WIDTH              = 165.29
         MAX-HEIGHT         = 29.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 29.67
         VIRTUAL-WIDTH      = 195.14
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brNCM IM-10 fPage0 */
/* BROWSE-TAB br-sistema IM-14 fPage0 */
/* BROWSE-TAB br-tratam-admin IM-16 fPage0 */
/* BROWSE-TAB br-quotas-tarif RECT-4 fPage0 */
/* BROWSE-TAB br-Acordos br-quotas-tarif fPage0 */
/* BROWSE-TAB br-acordos-ptr04 br-Acordos fPage0 */
/* BROWSE-TAB br-tipi br-acordos-ptr04 fPage0 */
/* BROWSE-TAB br-ex-tarif br-tipi fPage0 */
/* BROWSE-TAB br-Itens br-ex-tarif fPage0 */
/* BROWSE-TAB br-list-ex br-Itens fPage0 */
/* BROWSE-TAB br-PisCofins br-list-ex fPage0 */
/* BROWSE-TAB br-NVE br-PisCofins fPage0 */
/* BROWSE-TAB br-naladi-2002 br-NVE fPage0 */
/* BROWSE-TAB br-naladi-2007 br-naladi-2002 fPage0 */
/* BROWSE-TAB br-naladi-1996 br-naladi-2007 fPage0 */
/* BROWSE-TAB br-list-ex-bens br-naladi-1996 fPage0 */
/* BROWSE-TAB br-notas br-list-ex-bens fPage0 */
/* BROWSE-TAB br-ICMS br-notas fPage0 */
/* BROWSE-TAB br-defesa-comerc br-ICMS fPage0 */
/* SETTINGS FOR BROWSE br-Acordos IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-Acordos:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-acordos-ptr04 IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-acordos-ptr04:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-defesa-comerc IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-defesa-comerc:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-ex-tarif IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-ex-tarif:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-ICMS IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-ICMS:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-Itens IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-Itens:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-list-ex IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-list-ex:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-list-ex-bens IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-list-ex-bens:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-naladi-1996 IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-naladi-1996:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-naladi-2002 IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-naladi-2002:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-naladi-2007 IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-naladi-2007:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-notas IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-notas:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-NVE IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-NVE:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

ASSIGN 
       fiscosoft-nve.especificacao:AUTO-RESIZE IN BROWSE br-NVE = TRUE.

/* SETTINGS FOR BROWSE br-PisCofins IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-PisCofins:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-quotas-tarif IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-quotas-tarif:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-sistema IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-sistema:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-tipi IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-tipi:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BROWSE br-tratam-admin IN FRAME fPage0
   1                                                                    */
ASSIGN 
       br-tratam-admin:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

ASSIGN 
       brNCM:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

ASSIGN 
       btHelp:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btQueryJoins:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btReportsJoins:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-1 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-1:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-10 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-10:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-11 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-11:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-12 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-12:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-13 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-13:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-14 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-14:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-15 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-15:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-16 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-16:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-17 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-17:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-2 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-2:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-3 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-3:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-4 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-4:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-5 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-5:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-6 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-6:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-7 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-7:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-8 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-8:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR IMAGE IM-9 IN FRAME fPage0
   2                                                                    */
ASSIGN 
       IM-9:HIDDEN IN FRAME fPage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-Acordos
/* Query rebuild information for BROWSE br-Acordos
     _TblList          = "mgesp.fiscosoft-acordos"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.fiscosoft-acordos.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND mgesp.fiscosoft-acordos.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   = mgesp.fiscosoft-acordos.ex
     _FldNameList[2]   > mgesp.fiscosoft-acordos.tipo-codigo
"fiscosoft-acordos.tipo-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.fiscosoft-acordos.acordo
"fiscosoft-acordos.acordo" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.fiscosoft-acordos.anotacoes-imp
"fiscosoft-acordos.anotacoes-imp" ? "x(120)" "character" ? ? ? ? ? ? no ? no no "70" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.fiscosoft-acordos.anotacoes-exp
"fiscosoft-acordos.anotacoes-exp" ? "x(120)" "character" ? ? ? ? ? ? no ? no no "70" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.fiscosoft-acordos.aliq
"fiscosoft-acordos.aliq" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.fiscosoft-acordos.pp-imp
"fiscosoft-acordos.pp-imp" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.fiscosoft-acordos.pp-exp
"fiscosoft-acordos.pp-exp" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > mgesp.fiscosoft-acordos.vigencia-de
"fiscosoft-acordos.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > mgesp.fiscosoft-acordos.vigencia-ate
"fiscosoft-acordos.vigencia-ate" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-Acordos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-acordos-ptr04
/* Query rebuild information for BROWSE br-acordos-ptr04
     _TblList          = "mgesp.fiscosoft-acordo-ptr04"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.fiscosoft-acordo-ptr04.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND mgesp.fiscosoft-acordo-ptr04.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa
"
     _FldNameList[1]   = mgesp.fiscosoft-acordo-ptr04.codigo-ncm
     _FldNameList[2]   = mgesp.fiscosoft-acordo-ptr04.dt-baixa
     _FldNameList[3]   > mgesp.fiscosoft-acordo-ptr04.exceto
"fiscosoft-acordo-ptr04.exceto" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.fiscosoft-acordo-ptr04.naladi-1996
"fiscosoft-acordo-ptr04.naladi-1996" ? ? "character" ? ? ? ? ? ? no ? no no "89.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-acordos-ptr04 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-defesa-comerc
/* Query rebuild information for BROWSE br-defesa-comerc
     _TblList          = "fiscosoft-defesa-comercial"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-defesa-comercial.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-defesa-comercial.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-defesa-comercial.produto" ? "x(100)" ? ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-defesa-comercial.pais" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-defesa-comercial.medida" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-defesa-comercial.direito-aplicado" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-defesa-comercial.vigencia-ate" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-defesa-comercial.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "94.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fiscosoft-defesa-comercial.observacoes" "Observa‡äes" "x(100)" ? ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-defesa-comerc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ex-tarif
/* Query rebuild information for BROWSE br-ex-tarif
     _TblList          = "fiscosoft-ex-br-simples"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-ex-br-simples.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-ex-br-simples.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-ex-br-simples.ex" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-ex-br-simples.descricao" ? "x(150)" ? ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-ex-br-simples.aliquota" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-ex-br-simples.bkbit" ? "x(50)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-ex-br-simples.observacoes" ? "X(150)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-ex-br-simples.vigencia-ate" ? "x(10)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fiscosoft-ex-br-simples.vigencia-de" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-ex-tarif */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ICMS
/* Query rebuild information for BROWSE br-ICMS
     _TblList          = "fiscosoft-icms-convenio"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-icms-convenio.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-icms-convenio.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-icms-convenio.descriminacao" ? "x(50)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-icms-convenio.convenio" ? "X(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-icms-convenio.anexo" ? "x(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-icms-convenio.tratamento" ? "x(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-icms-convenio.resumo" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-ICMS */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-Itens
/* Query rebuild information for BROWSE br-Itens
     _TblList          = "Temp-Tables.tt-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"fnSelecao(tt-item.selecionado) @ c-selecionado" " *" "x(3)" ? 15 12 0 ? ? 0 no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-item.it-codigo
"tt-item.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-item.desc-item
"tt-item.desc-item" ? ? "character" ? ? ? ? ? ? no ? no no "66" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-item.aliquota-ii" "Al¡quota ii" ? ? ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-item.ind-ipi-dife
"tt-item.ind-ipi-dife" "IPI Diferenciado" ? "logical" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"IF (tt-item.cd-trib-ipi = 1) THEN (""Tributado"") ELSE (            if  (tt-item.cd-trib-ipi = 2) then (""Isento"") else (   IF (tt-item.cd-trib-ipi = 3) THEN (""Outros"") else (""Reduzido"")           )         )  format ""x(10)""" "Trib IPI" ? ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-item.aliquota-ipi
     _Query            is OPENED
*/  /* BROWSE br-Itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-list-ex
/* Query rebuild information for BROWSE br-list-ex
     _TblList          = "mgesp.fiscosoft-list-ex"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.fiscosoft-list-ex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND mgesp.fiscosoft-list-ex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   = mgesp.fiscosoft-list-ex.ex
     _FldNameList[2]   > mgesp.fiscosoft-list-ex.descricao
"fiscosoft-list-ex.descricao" ? "x(150)" "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = mgesp.fiscosoft-list-ex.aliquota
     _FldNameList[4]   > mgesp.fiscosoft-list-ex.observacoes
"fiscosoft-list-ex.observacoes" ? "x(200)" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = mgesp.fiscosoft-list-ex.indicadores
     _FldNameList[6]   > mgesp.fiscosoft-list-ex.vigencia-ate
"fiscosoft-list-ex.vigencia-ate" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.fiscosoft-list-ex.vigencia-de
"fiscosoft-list-ex.vigencia-de" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-list-ex */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-list-ex-bens
/* Query rebuild information for BROWSE br-list-ex-bens
     _TblList          = "fiscosoft-list-ex-bit"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-list-ex-bit.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-list-ex-bit.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-list-ex-bit.descricao" ? "x(150)" ? ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-list-ex-bit.aliquota" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-list-ex-bit.observacoes" ? "x(150)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-list-ex-bit.indicadores" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-list-ex-bit.vigencia-ate" ? "x(10)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-list-ex-bit.vigencia-de" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-list-ex-bens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-naladi-1996
/* Query rebuild information for BROWSE br-naladi-1996
     _TblList          = "fiscosoft-naladi-1996"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-naladi-1996.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-naladi-1996.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-naladi-1996.codigo" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-naladi-1996.descricao" ? "x(150)" "character" ? ? ? ? ? ? no ? no no "127.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-naladi-1996 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-naladi-2002
/* Query rebuild information for BROWSE br-naladi-2002
     _TblList          = "fiscosoft-naladi-2002"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-naladi-2002.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-naladi-2002.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-naladi-2002.codigo" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-naladi-2002.descricao" ? "x(150)" "character" ? ? ? ? ? ? no ? no no "127.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-naladi-2002 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-naladi-2007
/* Query rebuild information for BROWSE br-naladi-2007
     _TblList          = "fiscosoft-naladi-2007"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-naladi-2007.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-naladi-2007.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-naladi-2007.codigo" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-naladi-2007.descricao" ? "x(150)" "character" ? ? ? ? ? ? no ? no no "127.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-naladi-2007 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _TblList          = "mgesp.fiscosoft-notas-complementares"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgesp.fiscosoft-notas-complementares.codigo|yes"
     _Where[1]         = "fiscosoft-notas-complementares.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-notas-complementares.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa
 and fiscosoft-notas-complementares.seq-ipi-det = INPUT BROWSE br-tipi fiscosoft-ipi-det.seq-ipi-det"
     _FldNameList[1]   > mgesp.fiscosoft-notas-complementares.codigo
"fiscosoft-notas-complementares.codigo" ? "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.fiscosoft-notas-complementares.observacao
"fiscosoft-notas-complementares.observacao" ? "x(200)" "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.fiscosoft-notas-complementares.vigencia-de
"fiscosoft-notas-complementares.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.fiscosoft-notas-complementares.vigencia-ate
"fiscosoft-notas-complementares.vigencia-ate" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = mgesp.fiscosoft-notas-complementares.seq-ipi-det
     _Query            is OPENED
*/  /* BROWSE br-notas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-NVE
/* Query rebuild information for BROWSE br-NVE
     _TblList          = "mgesp.fiscosoft-nve"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-nve.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-nve.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > mgesp.fiscosoft-nve.nivel
"fiscosoft-nve.nivel" ? "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.fiscosoft-nve.atributo
"fiscosoft-nve.atributo" ? ? "character" ? ? ? ? ? ? no ? no no "40.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.fiscosoft-nve.especificacao
"fiscosoft-nve.especificacao" ? "x(300)" "character" ? ? ? ? ? ? no ? no no "140" yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-NVE */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-PisCofins
/* Query rebuild information for BROWSE br-PisCofins
     _TblList          = "fiscosoft-pis-cofins"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-pis-cofins.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-pis-cofins.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-pis-cofins.pis" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-pis-cofins.cofins" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-pis-cofins.anotacao" ? "x(200)" ? ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-pis-cofins.grupo" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-pis-cofins.classificacao" ? "x(10)" ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-pis-cofins.principal" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fiscosoft-pis-cofins.vigencia-ate" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fiscosoft-pis-cofins.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-PisCofins */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-quotas-tarif
/* Query rebuild information for BROWSE br-quotas-tarif
     _TblList          = "fiscosoft-red-import"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-red-import.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-red-import.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-red-import.ex" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-red-import.descricao" ? "x(250)" ? ? ? ? ? ? ? no ? no no "70" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-red-import.aliquota" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-red-import.quota" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-red-import.observacoes" ? "x(150)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-red-import.indicadores" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fiscosoft-red-import.vigencia-de" ? "x(15)" "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fiscosoft-red-import.vigencia-ate" ? "x(15)" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-quotas-tarif */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-sistema
/* Query rebuild information for BROWSE br-sistema
     _TblList          = "fiscosoft-sistemas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-sistemas.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-sistemas.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-sistemas.descricao" ? "x(250)" ? ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-sistemas.aliquota" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-sistemas.observacoes" ? "x(200)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-sistemas.vigencia-de" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-sistemas.vigencia-ate" ? "x(10)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-sistema */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tipi
/* Query rebuild information for BROWSE br-tipi
     _TblList          = "mgesp.fiscosoft-ipi-det"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-ipi-det.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-ipi-det.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > mgesp.fiscosoft-ipi-det.descricao
"fiscosoft-ipi-det.descricao" ? "x(200)" "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.fiscosoft-ipi-det.anotacoes
"fiscosoft-ipi-det.anotacoes" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.fiscosoft-ipi-det.ex
"fiscosoft-ipi-det.ex" ? "x(50)" "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = mgesp.fiscosoft-ipi-det.aliquota
     _FldNameList[5]   > mgesp.fiscosoft-ipi-det.vigencia-de
"fiscosoft-ipi-det.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.fiscosoft-ipi-det.vigencia-ate
"fiscosoft-ipi-det.vigencia-ate" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = mgesp.fiscosoft-ipi-det.seq-ipi-det
     _Query            is OPENED
*/  /* BROWSE br-tipi */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tratam-admin
/* Query rebuild information for BROWSE br-tratam-admin
     _TblList          = "fiscosoft-tra-siscomex"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fiscosoft-tra-siscomex.codigo-ncm = INPUT BROWSE brNCM fiscosoft-ncm.codigo
 AND fiscosoft-tra-siscomex.dt-baixa = INPUT BROWSE brNCM fiscosoft-ncm.dt-baixa"
     _FldNameList[1]   > "_<CALC>"
"fiscosoft-tra-siscomex.ncm" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fiscosoft-tra-siscomex.orgao-anuente" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fiscosoft-tra-siscomex.indicadores" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fiscosoft-tra-siscomex.tratamento" ? "x(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fiscosoft-tra-siscomex.ex" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fiscosoft-tra-siscomex.ex-descricao" ? "x(200)" ? ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fiscosoft-tra-siscomex.fundamento-legal" ? "x(50)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fiscosoft-tra-siscomex.descricao-mercadoria" ? "x(80)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fiscosoft-tra-siscomex.excecoes" ? "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fiscosoft-tra-siscomex.vigencia-ate" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fiscosoft-tra-siscomex.vigencia-de" ? ? "character" ? ? ? ? ? ? no ? no no "70.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-tratam-admin */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNCM
/* Query rebuild information for BROWSE brNCM
     _TblList          = "mgesp.fiscosoft-ncm"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.fiscosoft-ncm.dt-baixa >= da-atualizacao 
 AND mgesp.fiscosoft-ncm.codigo >= input frame fpage0 c-ncm-ini 
 and mgesp.fiscosoft-ncm.codigo <= input frame fpage0 c-ncm-fim 
 AND if tg-posicoes:checked then length(mgesp.fiscosoft-ncm.codigo) = 8 else yes use-index idx-ncm-data"
     _FldNameList[1]   > mgesp.fiscosoft-ncm.codigo
"fiscosoft-ncm.codigo" "NCM" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.fiscosoft-ncm.dt-baixa
"fiscosoft-ncm.dt-baixa" ? ? "date" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.fiscosoft-ncm.descricao
"fiscosoft-ncm.descricao" ? "x(200)" "character" ? ? ? ? ? ? no ? no no "57.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.fiscosoft-ncm.aliquota
"fiscosoft-ncm.aliquota" "Aliquota ii" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.fiscosoft-ncm.ipi
"fiscosoft-ncm.ipi" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.fiscosoft-ncm.pis
"fiscosoft-ncm.pis" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.fiscosoft-ncm.cofins
"fiscosoft-ncm.cofins" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.fiscosoft-ncm.icms
"fiscosoft-ncm.icms" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > mgesp.fiscosoft-ncm.ume
"fiscosoft-ncm.ume" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > mgesp.fiscosoft-ncm.indicadores
"fiscosoft-ncm.indicadores" ? ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > mgesp.fiscosoft-ncm.ver-excecao-tec
"fiscosoft-ncm.ver-excecao-tec" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > mgesp.fiscosoft-ncm.ver-excecao-tipi
"fiscosoft-ncm.ver-excecao-tipi" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   = mgesp.fiscosoft-ncm.vigencia-de
     _FldNameList[14]   = mgesp.fiscosoft-ncm.vigencia-ate
     _Query            is OPENED
*/  /* BROWSE brNCM */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Acordos
&Scoped-define SELF-NAME br-Acordos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Acordos wWindow
ON ROW-DISPLAY OF br-Acordos IN FRAME fPage0 /* Acordos das NCMs */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-acordos-ptr04
&Scoped-define SELF-NAME br-acordos-ptr04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-acordos-ptr04 wWindow
ON ROW-DISPLAY OF br-acordos-ptr04 IN FRAME fPage0 /* Acordos INT PTR04 */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-defesa-comerc
&Scoped-define SELF-NAME br-defesa-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-defesa-comerc wWindow
ON ROW-DISPLAY OF br-defesa-comerc IN FRAME fPage0 /* Defesa Comercial */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ex-tarif
&Scoped-define SELF-NAME br-ex-tarif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ex-tarif wWindow
ON ROW-DISPLAY OF br-ex-tarif IN FRAME fPage0 /* EX Tarif rio */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ICMS
&Scoped-define SELF-NAME br-ICMS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ICMS wWindow
ON ROW-DISPLAY OF br-ICMS IN FRAME fPage0 /* ICMS - Convˆnios Federais */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Itens
&Scoped-define SELF-NAME br-Itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Itens wWindow
ON MOUSE-SELECT-DBLCLICK OF br-Itens IN FRAME fPage0 /* Itens das NCMs */
DO:

    IF  AVAIL tt-item THEN DO:
        IF  tt-item.selecionado = " * " THEN 
            ASSIGN tt-item.selecionado = ""
                   tt-item.it-codigo:FGCOLOR IN BROWSE br-itens = 0 
                   tt-item.it-codigo:FONT    IN BROWSE br-itens = 1
                   tt-item.desc-item:FGCOLOR IN BROWSE br-itens = 0
                   tt-item.desc-item:FONT    IN BROWSE br-itens = 1.
        
        ELSE
            ASSIGN tt-item.selecionado = " * "
                   tt-item.it-codigo:FGCOLOR IN BROWSE br-itens  = 12 
                   tt-item.it-codigo:FONT    IN BROWSE br-itens  = 0
                   tt-item.desc-item:FGCOLOR IN BROWSE br-itens  = 12
                   tt-item.desc-item:FONT    IN BROWSE br-itens  = 0.

        DISPLAY tt-item.selecionado @ c-selecionado
            WITH BROWSE br-Itens.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-list-ex
&Scoped-define SELF-NAME br-list-ex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-list-ex wWindow
ON ROW-DISPLAY OF br-list-ex IN FRAME fPage0 /* Lista de Exce‡Æo … TEC */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-list-ex-bens
&Scoped-define SELF-NAME br-list-ex-bens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-list-ex-bens wWindow
ON ROW-DISPLAY OF br-list-ex-bens IN FRAME fPage0 /* Lista de Exce‡Æo de Bens de Inform tica e Telecomunica‡äes */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-naladi-1996
&Scoped-define SELF-NAME br-naladi-1996
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-naladi-1996 wWindow
ON ROW-DISPLAY OF br-naladi-1996 IN FRAME fPage0 /* NALADI 1996 */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-naladi-2002
&Scoped-define SELF-NAME br-naladi-2002
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-naladi-2002 wWindow
ON ROW-DISPLAY OF br-naladi-2002 IN FRAME fPage0 /* NALADI 2002 */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-naladi-2007
&Scoped-define SELF-NAME br-naladi-2007
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-naladi-2007 wWindow
ON ROW-DISPLAY OF br-naladi-2007 IN FRAME fPage0 /* NALADI 2007 */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-notas
&Scoped-define SELF-NAME br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON ROW-DISPLAY OF br-notas IN FRAME fPage0 /* Notas Complementares */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-NVE
&Scoped-define SELF-NAME br-NVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-NVE wWindow
ON ROW-DISPLAY OF br-NVE IN FRAME fPage0 /* NOMENCLATURA VALOR ADUANEIRO */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-PisCofins
&Scoped-define SELF-NAME br-PisCofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-PisCofins wWindow
ON ROW-DISPLAY OF br-PisCofins IN FRAME fPage0 /* Pis e Cofins */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-quotas-tarif
&Scoped-define SELF-NAME br-quotas-tarif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-quotas-tarif wWindow
ON ROW-DISPLAY OF br-quotas-tarif IN FRAME fPage0 /* Quota Tarif ria */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-sistema
&Scoped-define SELF-NAME br-sistema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-sistema wWindow
ON ROW-DISPLAY OF br-sistema IN FRAME fPage0 /* Sistema integrado */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tipi
&Scoped-define SELF-NAME br-tipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tipi wWindow
ON VALUE-CHANGED OF br-tipi IN FRAME fPage0 /* TIPI */
DO:
      
    /* Notas Complementares */
    {&OPEN-QUERY-br-notas} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tratam-admin
&Scoped-define SELF-NAME br-tratam-admin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tratam-admin wWindow
ON ROW-DISPLAY OF br-tratam-admin IN FRAME fPage0 /* Tratamento Adminstrativo (SISCOMEX) */
DO:
    IF  AVAIL fiscosoft-acordos THEN DO:
        IF  fiscosoft-acordos.diferenca THEN
            ASSIGN fiscosoft-acordos.acordo:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.aliq:BGCOLOR          IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.tipo-codigo:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-imp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.pp-exp:BGCOLOR        IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-imp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.anotacoes-exp:BGCOLOR IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.ex:BGCOLOR            IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-de:BGCOLOR   IN BROWSE br-Acordos = 14
                   fiscosoft-acordos.vigencia-ate:BGCOLOR  IN BROWSE br-Acordos = 14.
                   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brNCM
&Scoped-define SELF-NAME brNCM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNCM wWindow
ON MOUSE-SELECT-DBLCLICK OF brNCM IN FRAME fPage0 /* NCMs */
DO:
/*     IF  AVAIL fiscosoft-ncm THEN DO:                          */
/*         RUN esp/inp/esinp004a.w (INPUT ROWID(fiscosoft-ncm)). */
/*     END.                                                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNCM wWindow
ON ROW-DISPLAY OF brNCM IN FRAME fPage0 /* NCMs */
DO:

  DEF VAR i-cor-fundo AS INT INIT 10 NO-UNDO. /* Verde */
  DEF VAR i-cor-letra AS INT INIT 17 NO-UNDO. /* Cinza claro*/
 
  IF  NOT AVAIL fiscosoft-ncm THEN
      RETURN "OK".

  IF  CAN-FIND (FIRST b-fisco-2 NO-LOCK
                   WHERE b-fisco-2.codigo   = fiscosoft-ncm.codigo  
                     AND b-fisco-2.dt-baixa > fiscosoft-ncm.dt-baixa ) THEN
       RETURN "OK".

   FOR FIRST b-fisco NO-LOCK
      WHERE b-fisco.codigo   = fiscosoft-ncm.codigo  
        AND b-fisco.dt-baixa < fiscosoft-ncm.dt-baixa 
        BY b-fisco.dt-baixa DESCENDING:          
      
        IF  b-fisco.descricao <> fiscosoft-ncm.descricao THEN
            ASSIGN fiscosoft-ncm.descricao:BGCOLOR        IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.aliquota <> fiscosoft-ncm.aliquota THEN
            ASSIGN fiscosoft-ncm.aliquota:BGCOLOR         IN BROWSE brNCM = i-cor-fundo. 

        IF  b-fisco.ipi <> fiscosoft-ncm.ipi THEN
            ASSIGN fiscosoft-ncm.ipi:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.pis <> fiscosoft-ncm.pis THEN
            ASSIGN fiscosoft-ncm.pis:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.cofins <> fiscosoft-ncm.cofins THEN
            ASSIGN fiscosoft-ncm.cofins:BGCOLOR           IN BROWSE brNCM = i-cor-fundo. 

        IF  b-fisco.icms <> fiscosoft-ncm.icms THEN
            ASSIGN fiscosoft-ncm.icms:BGCOLOR             IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.ume <> fiscosoft-ncm.ume THEN
            ASSIGN fiscosoft-ncm.ume:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.indicadores <> fiscosoft-ncm.indicadores THEN
            ASSIGN fiscosoft-ncm.indicadores:BGCOLOR      IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.ver-excecao-tec <> fiscosoft-ncm.ver-excecao-tec THEN
            ASSIGN fiscosoft-ncm.ver-excecao-tec:BGCOLOR  IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.ver-excecao-tipi <> fiscosoft-ncm.ver-excecao-tipi THEN
            ASSIGN fiscosoft-ncm.ver-excecao-tipi:BGCOLOR IN BROWSE brNCM = i-cor-fundo. 

        IF  b-fisco.vigencia-de <> fiscosoft-ncm.vigencia-de THEN
            ASSIGN fiscosoft-ncm.vigencia-de:BGCOLOR      IN BROWSE brNCM = i-cor-fundo.  

        IF  b-fisco.vigencia-ate <> fiscosoft-ncm.vigencia-ate THEN
            ASSIGN fiscosoft-ncm.vigencia-ate:BGCOLOR     IN BROWSE brNCM = i-cor-fundo.  

   END.


   /*  um registro NCM totalmente novo, a¡ deixa alinha toda em verde
      mas apenas se nÆo for a primeira baixa...pois traria tudo em verde */
   IF  NOT l-primeira-atualizacao
   AND NOT CAN-FIND(FIRST b-fisco
                WHERE b-fisco.dt-baixa > fiscosoft-ncm.dt-baixa)  
   AND NOT CAN-FIND(FIRST b-fisco
                WHERE b-fisco.codigo = fiscosoft-ncm.codigo
                  AND b-fisco.dt-baixa < fiscosoft-ncm.dt-baixa) 
   THEN DO:

       ASSIGN fiscosoft-ncm.dt-baixa:BGCOLOR         IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.codigo:BGCOLOR           IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.descricao:BGCOLOR        IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.aliquota:BGCOLOR         IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.ipi:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.pis:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.cofins:BGCOLOR           IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.icms:BGCOLOR             IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.ume:BGCOLOR              IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.indicadores:BGCOLOR      IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.ver-excecao-tec:BGCOLOR  IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.ver-excecao-tipi:BGCOLOR IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.vigencia-de:BGCOLOR      IN BROWSE brNCM = i-cor-fundo.
       ASSIGN fiscosoft-ncm.vigencia-ate:BGCOLOR     IN BROWSE brNCM = i-cor-fundo.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNCM wWindow
ON VALUE-CHANGED OF brNCM IN FRAME fPage0 /* NCMs */
DO:

    IF  NOT AVAIL fiscosoft-ncm THEN
        RETURN "OK".

    HIDE {&list-2}.

    /* Item */
    ASSIGN rs-item:SCREEN-VALUE IN FRAME fpage0 = "3" /*Sem Filtro*/
           c-item:SCREEN-VALUE IN FRAME fpage0 = "".
    RUN pi-carrega-itens-ncm IN THIS-PROCEDURE.
    
    IF  AVAIL tt-item THEN
        VIEW im-1.
               

    /*TIPI*/
    {&OPEN-QUERY-br-tipi}
    {&OPEN-QUERY-br-notas}
    IF  AVAIL fiscosoft-ipi-det THEN DO:
        VIEW im-2.
    END.

    /* Lista Ex */
    {&OPEN-QUERY-br-list-ex}
    IF  AVAIL fiscosoft-list-ex THEN
        VIEW im-3.

    /* Lista Ex Bens */
    {&OPEN-QUERY-br-list-ex-bens}
    IF  AVAIL fiscosoft-list-ex-bit THEN
        VIEW im-4.
    
    /* "Ex Tarif." */
    {&OPEN-QUERY-br-ex-tarif}
    IF  AVAIL fiscosoft-ex-br-simples THEN
        VIEW im-5.

    /* Sist Integrado */
    {&OPEN-QUERY-br-sistema}
    IF  AVAIL fiscosoft-sistemas THEN
        VIEW im-6.

    /* Quota Tarif. */
    {&OPEN-QUERY-br-quotas-tarif}     
    IF  AVAIL fiscosoft-red-import THEN
        VIEW im-7.

    /* Nom Val Aduan. */
    {&OPEN-QUERY-br-nve}
    IF  AVAIL fiscosoft-nve THEN
        VIEW im-8.

    /* NALADI_1996 */
    {&OPEN-QUERY-br-naladi-1996}
    IF  AVAIL fiscosoft-naladi-1996 THEN
        VIEW im-9.

    /* NALADI_2002 */
    {&OPEN-QUERY-br-naladi-2002}
    IF  AVAIL fiscosoft-naladi-2002 THEN
        VIEW im-10.
    
    /* NALADI_2007 */
    {&OPEN-QUERY-br-naladi-2007}
    IF  AVAIL fiscosoft-naladi-2007 THEN
        VIEW im-11.

    /* Defesa Comerc. */
    {&OPEN-QUERY-br-defesa-comerc}
    IF  AVAIL fiscosoft-defesa-comercial THEN
        VIEW im-12.

    /* ICMS */
    {&OPEN-QUERY-br-ICMS}  
    IF  AVAIL fiscosoft-icms-convenio THEN
        VIEW im-13.
    
    /* Acordos INT. */
    {&OPEN-QUERY-br-acordos}
    IF  AVAIL fiscosoft-acordos THEN
        VIEW im-14.
    
    /*Acordos INT Ptr04 */
    {&OPEN-QUERY-br-acordos-ptr04}
    IF  AVAIL fiscosoft-acordo-ptr04 THEN
        VIEW im-15.

    /* Tratam. Admin. */
    {&OPEN-QUERY-br-tratam-admin}
    IF  AVAIL fiscosoft-tra-siscomex THEN
        VIEW im-16.

    /* PIS/COFINS */
    {&OPEN-QUERY-br-PisCofins}
    IF  AVAIL fiscosoft-pis-cofins THEN
        VIEW im-17.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalha-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalha-nota wWindow
ON CHOOSE OF bt-detalha-nota IN FRAME fPage0 /* Detalhar Nota */
DO:
  IF  AVAIL fiscosoft-notas-complementares THEN
  RUN esp/inp/esinp004b.w (INPUT rowid(fiscosoft-notas-complementares)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizarInfoItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizarInfoItens wWindow
ON CHOOSE OF btAtualizarInfoItens IN FRAME fPage0 /* Atualizar Itens */
DO:

    IF  NOT AVAIL fiscosoft-ncm THEN
        RETURN NO-APPLY.

     IF  NOT CAN-FIND (FIRST tt-item 
                           WHERE tt-item.selecionado = " * ") THEN DO:

         RUN utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 17006,
                            INPUT "Nenhum item foi selecionado para altera‡Æo.").
         RETURN NO-APPLY.

     END.
         
    DEFINE VARIABLE h-acomp    AS HANDLE NO-UNDO.     
    DEFINE VARIABLE l-existem-items AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-primeiro AS LOGICAL INIT YES NO-UNDO.
    DEFINE VARIABLE l-altera-ncm      AS LOGICAL   NO-UNDO. 
    DEFINE VARIABLE de-aliquota-ii    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-aliquota-imp    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-aliquota-ipi    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE de-ipi            AS CHARACTER NO-UNDO.                      
    DEFINE VARIABLE l-ipi-isento      AS LOGICAL   NO-UNDO.               
    DEFINE VARIABLE l-altera-li       AS LOGICAL   NO-UNDO.                      
    DEFINE VARIABLE l-necessita-li    AS LOGICAL   NO-UNDO.                      
    DEFINE VARIABLE l-altera-destaque AS LOGICAL   NO-UNDO.                
    DEFINE VARIABLE i-destaque        AS INTEGER   NO-UNDO.                   
    DEFINE VARIABLE l-altera-nve      AS LOGICAL   NO-UNDO.                       
    DEFINE VARIABLE c-nve             AS CHARACTER NO-UNDO.                      
    DEFINE VARIABLE l-altera-ex       AS LOGICAL   NO-UNDO.                       
    DEFINE VARIABLE c-ex              AS CHARACTER NO-UNDO.                      
    DEFINE VARIABLE l-altera-gatt     AS LOGICAL   NO-UNDO.                      
    DEFINE VARIABLE l-gatt            AS LOGICAL   NO-UNDO.                      
    DEFINE VARIABLE de-gat            AS DECIMAL   NO-UNDO.                      
    DEFINE VARIABLE l-retorno         AS LOGICAL   NO-UNDO.                   

    ASSIGN de-aliquota-ii = fiscosoft-ncm.aliquota.
    
    IF  TRIM(fiscosoft-ncm.ipi) = "NT" THEN 
        ASSIGN l-ipi-isento = YES.
    ELSE
        ASSIGN l-ipi-isento = NO
               de-ipi       = TRIM(fiscosoft-ncm.ipi).

    /* Permitir que o usu rio altere os valores que vieram do fiscosot*/
    wWindow:SENSITIVE = NO.

    RUN esp/inp/esinp004c.w (INPUT ROWID(fiscosoft-ncm),   
                             OUTPUT l-altera-ncm,
                             INPUT-OUTPUT de-aliquota-ii,  
                             OUTPUT l-aliquota-imp,        
                             OUTPUT l-aliquota-ipi,        
                             INPUT tt-item.it-codigo,      
                             INPUT l-ipi-isento,           
                             INPUT-OUTPUT de-ipi,          
                             OUTPUT l-altera-li,           
                             OUTPUT l-necessita-li,        
                             OUTPUT l-altera-destaque,     
                             OUTPUT i-destaque,            
                             OUTPUT l-altera-nve,          
                             OUTPUT c-nve,                 
                             OUTPUT l-altera-ex,           
                             OUTPUT c-ex,                  
                             OUTPUT l-altera-gatt,         
                             OUTPUT l-gatt,                
                             OUTPUT de-gat,                
                             OUTPUT l-retorno).
    
    wWindow:SENSITIVE = YES.
    
    IF  NOT l-retorno THEN
        RETURN NO-APPLY.

    RUN utp/ut-msgs.p(INPUT "show":U,
                  INPUT 27100,
                  INPUT "Confirma Atualiza‡Æo das Al¡quotas da Classifica‡Æo e Itens?" + "~~" + 
                        "Este processo atualiza os seguintes valores da Classifica‡Æo Fiscal e dos itens em rela‡Æo ao valor vigente (Fiscosoft)" + CHR(13) +
                        "CLASS FISCAL: % IPI, % Imposto Importa‡Æo, PIS/COFINS, PIS/COFINS Externo, Al¡quota Majorada Cofins." + CHR(13) +
                        "ITEM: Trib/% de IPI, Trib/% Imposto Importa‡Æo (im0106), PIS/COFINS" + CHR(13) ) .

    IF  RETURN-VALUE = "no":U THEN
        RETURN NO-APPLY.
    
    RUN utp/ut-acomp.p PERSISTENT set h-acomp.
    
    IF  VALID-HANDLE(h-acomp) THEN                               
        RUN pi-inicializar IN h-acomp (INPUT "Buscando Item..").

    /*LIMPAR TEMP TEBLEs que guardam as informa‡äes de/para do log enviado por e-mail*/
    EMPTY TEMP-TABLE tt-alt-ncm.
    EMPTY TEMP-TABLE tt-alt-item.

    /******************************************** ATUALIZAR NCM E ITENS **************************************************/
    FOR EACH  tt-item NO-LOCK
        WHERE tt-item.selecionado = " * ":
        
        IF  VALID-HANDLE(h-acomp) THEN                               
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Item: " + tt-item.it-codigo + ". . .").

        RUN pi-atualizar-itens (INPUT fiscosoft-ncm.codigo,
                                INPUT tt-item.it-codigo,
                                INPUT l-altera-ncm,
                                INPUT l-aliquota-imp,
                                INPUT l-aliquota-ipi,
                                INPUT de-aliquota-ii,
                                INPUT l-ipi-isento,
                                INPUT de-ipi,
                                INPUT fiscosoft-ncm.pis,
                                INPUT fiscosoft-ncm.cofins,
                                INPUT fiscosoft-ncm.icms,
                                INPUT l-primeiro, /* para s¢ atualizar 1 £nica vez a NCM */
                                INPUT l-altera-li,
                                INPUT l-necessita-li,
                                INPUT l-altera-destaque,
                                INPUT i-destaque,
                                INPUT l-altera-nve,  
                                INPUT c-nve,
                                INPUT l-altera-ex,
                                INPUT c-ex,
                                INPUT l-altera-gatt,
                                INPUT l-gatt,
                                INPUT de-gat).

        ASSIGN l-primeiro      = NO
               l-existem-items = YES.
    END.

    /********************************** ROTINA QUE ENVIA E-AMAIL COM AS ALTERA€åES ***************************************/
    IF  CAN-FIND (FIRST tt-alt-ncm) THEN DO:

        IF  VALID-HANDLE(h-acomp) THEN                               
            RUN pi-acompanhar IN h-acomp (INPUT "Gerando e-mail de log. . .").

        ASSIGN cArqEmail = session:temp-directory + "LogAltNCM-" + tt-alt-ncm.ncm + ".csv".                
        OUTPUT STREAM s TO value(cArqEmail) CONVERT TARGET "ibm850" SOURCE "ibm850". 
                                                                                     
        RUN pi-envia-email-log.                      

        //OS-DELETE value(cArqEmail) NO-ERROR.                                         
    END.

    IF  l-existem-items THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 15825,
                           INPUT "Atualiza‡Æo Conclu¡da!~~Um e-mail com o log de altera‡äes foi enviado ao(s) destinat rio(s) parametrizado(s) no programa ESINP001.").

        APPLY "choose" TO btDesmarcarTodosItens.
        RUN pi-carrega-itens-ncm.
        
    END.
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Nenhum item foi selecionado como (*) para atualiza‡Æo").

    /***************************************************FIM**************************************************************/

    IF  VALID-HANDLE(h-acomp) THEN     
        RUN pi-finalizar IN h-acomp. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btBaixarAtu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBaixarAtu wWindow
ON CHOOSE OF btBaixarAtu IN FRAME fPage0 /* Baixar Atualiza‡äes */
DO:

    RUN esp/inp/esinp005.w.

    {&OPEN-QUERY-brNCM}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btBusca-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBusca-item wWindow
ON CHOOSE OF btBusca-item IN FRAME fPage0 /* Query Joins */
DO:
  
    ASSIGN l-acao-filtrar = YES.
    RUN pi-carrega-itens-ncm. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btBuscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBuscar wWindow
ON CHOOSE OF btBuscar IN FRAME fPage0 /* Query Joins */
DO:
   
/*     FIND FIRST classif-fisc                                                                                           */
/*         WHERE classif-fisc.class-fiscal = INPUT c-ncm-rapida NO-LOCK NO-ERROR.                                        */
/*                                                                                                                       */
/*     IF  NOT AVAIL classif-fisc THEN DO:                                                                               */
/*         run utp/ut-msgs.p (input "show", input 99999, input "NCM nÆo existe no cadastro de classifica‡äes fiscais."). */
/*     END.                                                                                                              */

    FIND LAST fiscosoft-ncm USE-INDEX idx-ponteiro_atualizacao
        WHERE fiscosoft-ncm.codigo = INPUT FRAME fpage0 c-ncm-rapida NO-LOCK NO-ERROR.

    IF  AVAIL fiscosoft-ncm THEN DO:
        REPOSITION brNcm TO ROWID ROWID(fiscosoft-ncm).
        APPLY "value-changed" TO brNcm IN FRAME fpage0.
        APPLY "row-display" TO brNcm IN FRAME fpage0.
    END.
    ELSE DO:
        run utp/ut-msgs.p (input "show", input 99999, input "NCM nÆo foi selecionada na pesquisa. Verifique os parƒmetros de sele‡Æo.").
        RETURN NO-APPLY.
    END.
    
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcarTodosItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcarTodosItens wWindow
ON CHOOSE OF btDesmarcarTodosItens IN FRAME fPage0 /* Desmarcar Todos */
DO:
    FOR EACH tt-item EXCLUSIVE-LOCK:
        ASSIGN tt-item.selecionado = ""
               tt-item.it-codigo:COLUMN-FGCOLOR IN BROWSE br-itens = 0
               tt-item.it-codigo:COLUMN-FONT    IN BROWSE br-itens = 1
               tt-item.desc-item:COLUMN-FGCOLOR IN BROWSE br-itens = 0
               tt-item.desc-item:COLUMN-FONT    IN BROWSE br-itens = 1.

    END.

    {&OPEN-QUERY-br-Itens}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarcarTodosItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcarTodosItens wWindow
ON CHOOSE OF btMarcarTodosItens IN FRAME fPage0 /* Marcar Todos */
DO:
    FOR EACH tt-item EXCLUSIVE-LOCK:
        ASSIGN tt-item.selecionado = " * "
               tt-item.it-codigo:COLUMN-FGCOLOR IN BROWSE br-itens  = 12 
               tt-item.it-codigo:COLUMN-FONT    IN BROWSE br-itens  = 0  
               tt-item.desc-item:COLUMN-FGCOLOR IN BROWSE br-itens  = 12 
               tt-item.desc-item:COLUMN-FONT    IN BROWSE br-itens  = 0.
    END.


    {&OPEN-QUERY-br-Itens}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisualizar wWindow
ON CHOOSE OF btVisualizar IN FRAME fPage0 /* Visualizar */
DO:
        
    IF  da-ini:SCREEN-VALUE = "" 
    AND INPUT FRAME fpage0 rs-atual = 3 THEN DO:
        run utp/ut-msgs.p (input "show", input 99999, input "Data inicial para pesquisa deve ser informada!").
        RETURN NO-APPLY.
    END.

    CASE INPUT FRAME fpage0 rs-atual:
        WHEN 1 THEN 
            ASSIGN  da-atualizacao = 11/30/2012.
        WHEN 2 THEN DO: 
    
            FIND FIRST fiscosoft-ncm USE-INDEX idx-data-desc
                WHERE fiscosoft-ncm.dt-baixa <= TODAY.
    
            IF  AVAIL fiscosoft-ncm THEN
                ASSIGN da-atualizacao = fiscosoft-ncm.dt-baixa.
            ELSE
                ASSIGN da-atualizacao = 11/30/2012.

        END.           
        WHEN 3 THEN 
            ASSIGN da-atualizacao = DATE(da-ini:SCREEN-VALUE IN FRAME fpage0).
     END.

    {&OPEN-QUERY-brNCM}

    APPLY "value-changed" TO brNcm.

    ASSIGN l-escolha:SCREEN-VALUE = "Itens".
       

    {&OPEN-QUERY-br-tipi}
    {&OPEN-QUERY-br-notas}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON LEAVE OF c-item IN FRAME fPage0
DO:
  
    IF  NOT CAN-FIND(fiscosoft-ncm
                        WHERE fiscosoft-ncm.codigo = INPUT FRAME fpage0 c-ncm-rapida) THEN
        ASSIGN c-ncm-rapida:SCREEN-VALUE IN FRAME fpage0 = "00000000".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ncm-rapida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ncm-rapida wWindow
ON LEAVE OF c-ncm-rapida IN FRAME fPage0 /* Busca R pida de NCM */
DO:
  
    IF  NOT CAN-FIND(LAST fiscosoft-ncm USE-INDEX idx-ponteiro_atualizacao
                        WHERE fiscosoft-ncm.codigo = INPUT FRAME fpage0 c-ncm-rapida) THEN
        ASSIGN c-ncm-rapida:SCREEN-VALUE IN FRAME fpage0 = "00000000".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-escolha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-escolha wWindow
ON VALUE-CHANGED OF l-escolha IN FRAME fPage0
DO:
  
    DO WITH FRAME fpage0:
         ASSIGN btMarcarTodosItens:VISIBLE    = no
                btDesmarcarTodosItens:VISIBLE = no
                btAtualizarInfoItens:VISIBLE  = no
                rs-item:VISIBLE               = no
                c-item:VISIBLE                = no
                btBusca-item:VISIBLE          = no
             
                bt-detalha-nota:VISIBLE       = NO.
    END.

    CASE l-escolha:SCREEN-VALUE:
        WHEN "Itens" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-itens.
            DO WITH FRAME fpage0:
                 ASSIGN btMarcarTodosItens:VISIBLE    = YES
                        btDesmarcarTodosItens:VISIBLE = YES
                        btAtualizarInfoItens:VISIBLE  = YES
                        rs-item:VISIBLE               = YES
                        c-item:VISIBLE                = YES
                        btBusca-item:VISIBLE          = YES.
            END.
    
        END.

        WHEN "TIPI" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-TIPI.
            VIEW BROWSE br-notas.
            bt-detalha-nota:VISIBLE = YES.
        END.

        WHEN "Notas Complem." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-notas.
        END.

        WHEN "Lista Ex" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-list-ex.
        END.
        WHEN "Lista Ex Bens" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-list-ex-bens.
        END.

        WHEN "Ex Tarif." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-ex-tarif.
        END.

        WHEN "Sist Integrado" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-sistema.
        END.

        WHEN "Quota Tarif." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-quotas-tarif.
        END.
        
        WHEN "Nom Val Aduan." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-NVE.
        END.

        WHEN "NALADI_1996" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-NALADI-1996.
        END.

        WHEN "NALADI_2002" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-NALADI-2002.
        END.

        WHEN "NALADI_2007" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-NALADI-2007.
        END.

        WHEN "Defesa Comerc." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-defesa-comerc.
        END.

        WHEN "ICMS" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-ICMS.
        END.
        
        WHEN "Acordos INT." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-acordos.
        END.
        
        WHEN "Acordos INT Ptr04" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-acordos-ptr04.
        END.

        WHEN "Tratam. Admin." THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-tratam-admin.
        END.

        WHEN "PIS/COFINS" THEN DO:
            HIDE BROWSE {&List-1} .
            VIEW BROWSE br-PisCofins.
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-atual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-atual wWindow
ON VALUE-CHANGED OF rs-atual IN FRAME fPage0
DO:
  
    CASE INPUT FRAME fpage0 rs-atual:
        WHEN 1 THEN 
            ASSIGN da-ini:SCREEN-VALUE = ""
                   da-ini:SENSITIVE = NO.
                   
        WHEN 2 THEN 
  
            ASSIGN da-ini:SCREEN-VALUE = ""
                   da-ini:SENSITIVE = NO.
      
        WHEN 3 THEN 
            ASSIGN da-ini:SCREEN-VALUE = "01/" + STRING(month(TODAY),"99") + "/" + STRING(YEAR(TODAY))
                   da-ini:SENSITIVE = YES.
                   
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-item wWindow
ON VALUE-CHANGED OF rs-item IN FRAME fPage0
DO:
  
    IF  INPUT FRAME fpage0 rs-item = 3 THEN DO:
    
        ASSIGN c-item:SCREEN-VALUE IN FRAME fpage0 = "".
        APPLY "choose" TO btBusca-item IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Acordos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN fi-cor:BGCOLOR IN FRAME fpage0 = 10.    

    ENABLE brNCM
           btBaixarAtu
        WITH FRAME fPage0.


    br-Itens:HIDDEN = TRUE.
    btMarcarTodosItens:VISIBLE       = FALSE.
    btDesmarcarTodosItens:VISIBLE    = FALSE.
    btAtualizarInfoItens:VISIBLE     = FALSE.

    DO WITH FRAME fPage1:
        ENABLE ALL.
    END.

    l-escolha:FONT = 0.
    
    APPLY "value-changed" TO l-escolha.

    APPLY "value-changed" TO rs-atual.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar-itens wWindow 
PROCEDURE pi-atualizar-itens :
/*------------------------------------------------------------------------------
  Purpose:     Atualizar as informa‡äes da NCM no Item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-ncm             LIKE classif-fisc.class-fiscal NO-UNDO.
    DEFINE INPUT PARAM p-item            LIKE ITEM.it-codigo            NO-UNDO.
    DEFINE INPUT PARAM l-altera-ncm      AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-altera-aliquota AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-altera-ipi      AS LOGICAL                     NO-UNDO. 
    DEFINE INPUT PARAM p-aliq-ii         AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-ipi-isento      AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-aliq-ipi        AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-aliq-pis        AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-aliq-cofins     AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-aliq-icms       AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-atualiza-ncm    AS LOGICAL                     NO-UNDO.  
    DEFINE INPUT PARAM p-altera-li       AS LOGICAL                     NO-UNDO.  
    DEFINE INPUT PARAM p-necessita-li    AS LOGICAL                     NO-UNDO.  
    DEFINE INPUT PARAM p-altera-destaque AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-destaque        AS INTEGER                     NO-UNDO.
    DEFINE INPUT PARAM p-altera-nve      AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-nve             AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-altera-ex       AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-ex              AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAM p-altera-gatt     AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-log-gatt        AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAM p-perc-gatt       AS DECIMAL                     NO-UNDO.

    DEFINE VARIABLE de-ncm-ipi AS CHARACTER NO-UNDO.
    DEFINE VARIABLE de-ncm-ii  AS CHARACTER NO-UNDO.

    DO TRANS ON ERROR UNDO, RETURN:
        
        /****************************************************************** NCM ****************************************************************/
        IF  p-atualiza-ncm THEN  DO: 
        
            FOR FIRST classif-fisc EXCLUSIVE-LOCK
                WHERE classif-fisc.class-fiscal = p-ncm:
                
                /* Cria a temp-table para guardar o "Antes" da altera‡Æo */
                RUN pi-criar-temp-table-alt-ncm (INPUT 1).

                FIND FIRST int-classif-fisc NO-LOCK 
                     WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal NO-ERROR.
    
                /*Para NCM, nunca utiliza os campos que o usu rio possa ter alterado em tela
                  Sempre utilizar o que est  no fiscosoft */
                
                IF p-altera-aliquota = YES AND AVAIL fiscosoft-ncm  THEN DO:
                    ASSIGN de-ncm-ii  = p-aliq-ii.
                END.
                
                IF p-altera-ipi = YES AND AVAIL fiscosoft-ncm THEN DO:
                    ASSIGN de-ncm-ipi = p-aliq-ipi. 
                END.

                ASSIGN de-ncm-ipi = REPLACE(de-ncm-ipi,' ','')
                       de-ncm-ii  = REPLACE(de-ncm-ii,' ','0').

                IF l-altera-ncm = YES THEN DO:
                    /** I P I **/
                    IF p-altera-ipi THEN DO:
                        IF  de-ncm-ipi = "NT" OR p-ipi-isento THEN
                            ASSIGN classif-fisc.aliquota-ipi = 0. /* ISENTO */
                        ELSE
                            ASSIGN classif-fisc.aliquota-ipi = DEC(REPLACE(de-ncm-ipi,    ".", ",")).
                    END.

                    ASSIGN classif-fisc.dec-1            = DEC(REPLACE(p-aliq-pis,    ".", ",")) /* PIS */

                           classif-fisc.dec-2            = IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento THEN
                                                               DEC(REPLACE(p-aliq-cofins, ".", ",")) - 1 /* COFINS */
                                                           ELSE
                                                               DEC(REPLACE(p-aliq-cofins, ".", ",")) /* COFINS */

                           classif-fisc.val-aliq-ext-pis = DEC(REPLACE(p-aliq-pis,    ".", ",")).   /* PIS Externo */

                    IF p-altera-aliquota = YES AND AVAIL fiscosoft-ncm  THEN DO:
                       ASSIGN OVERLAY(classif-fisc.char-1, 1, 20) = string(dec(REPLACE(de-ncm-ii, ".", ",")), ">>9.99").
                    END.

                    /* C lculo da cofins Majorada */
                    ASSIGN classif-fisc.val-aliq-ext-cofins   = classif-fisc.dec-2.  /*Externo Cofins*/

                    IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento THEN 
                        ASSIGN overlay(classif-fisc.char-1, 56,6) = string(DEC(REPLACE(p-aliq-cofins, ".", ",")), ">>9.99"). /*Majorada*/

                END.

                /* Cria a temp-table para guardar o "Antes" da altera‡Æo */
                RUN pi-criar-temp-table-alt-ncm (INPUT 2).

            END.

        END.
        /***************************************************************** Fim NCM *******************************************************************/


        /************************************************************ ATUALIZA€ÇO DE ITENS ***********************************************************/
        FOR FIRST ITEM EXCLUSIVE-LOCK
            WHERE ITEM.it-codigo = p-item:
            
            FIND FIRST int-classif-fisc NO-LOCK 
                 WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal NO-ERROR.

            /* Cria a temp-table para guardar o "Antes" da altera‡Æo */
            FIND FIRST int-item NO-LOCK
                WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.

            RUN pi-criar-temp-table-alt-item (INPUT 1).

            /** I P I **/
            IF  NOT ITEM.ind-ipi-dife THEN do: /*Segundo Rog‚rio (fiscal), nÆo atualizar nada de IPI, se for ipi diferenciado */

                IF p-altera-ipi THEN DO:
                    
                    IF  p-aliq-ipi = "NT" THEN
                        ASSIGN ITEM.aliquota-ipi = 0
                               ITEM.cd-trib-ipi = 2. /* ISENTO */
                    ELSE
                        ASSIGN ITEM.aliquota-ipi = DEC(p-aliq-ipi)
                               ITEM.cd-trib-ipi = 1. /* ISENTO */
                END.
            END.

            /**  Al¡quota de Importa‡Æo **/
            /* Imposto Importa‡Æo -> SEMPRE TRIBUTADO, mesmo que seja al¡quota zero (Rog‚rio - fiscal) */

            IF p-altera-aliquota THEN DO:
               ASSIGN OVERLAY(item.char-2,20,2) = "01".
                      OVERLAY(ITEM.char-2,22,6) = p-aliq-ii.
            END.
            
            /** PIS **/
            ASSIGN OVERLAY(ITEM.CHAR-2, 31, 5) =  STRING(DEC(REPLACE(p-aliq-pis, ".", ",")), "99.99").

            /** COFINS **/
            IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento THEN
                ASSIGN OVERLAY(ITEM.CHAR-2, 36, 5) = STRING(DEC(REPLACE(p-aliq-cofins, ".", ",")) - 1, "99.99"). /* COFINS */
            ELSE
                ASSIGN OVERLAY(ITEM.CHAR-2, 36, 5) = STRING(DEC(REPLACE(p-aliq-cofins, ".", ",")), "99.99"). /* COFINS */

            /* Verifica se o usu rio marcou que quer interferir na informa‡Æo de "LI" no cadastro de itens 
               Se sim, atualiza o campo "Necessita LI" do cd0204 */
            IF  p-altera-li THEN
                ASSIGN ITEM.log-necessita-li = p-necessita-li.

            IF  p-altera-destaque OR p-altera-nve OR p-altera-ex OR p-altera-gatt THEN
                FOR FIRST int-item EXCLUSIVE-LOCK
                    WHERE int-item.it-codigo = ITEM.it-codigo:
                END.

            /* Verifica se o usu rio marcou que quer interferir na informa‡Æo "Destaque no" cadastro de itens */ 
            IF  p-altera-destaque AND AVAIL int-item THEN 
                ASSIGN int-item.destaque = p-destaque.
            
            /* Verifica se o usu rio marcou que quer interferir na informa‡Æo "NVE" no cadastro de itens */ 
            IF  p-altera-nve AND AVAIL int-item THEN
                ASSIGN int-item.nve = p-nve.

            /* Verifica se o usu rio marcou que quer interferir na informa‡Æo "Ex Tarif rio" no cadastro de itens */
            IF  p-altera-ex AND AVAIL int-item THEN
                ASSIGN int-item.ex = p-ex.

            /* Verifica se o usu rio marcou que quer interferir na informa‡Æo "GATT" cadastro de itens */ 
            IF  p-altera-gatt AND AVAIL int-item THEN 
                ASSIGN int-item.log-gatt  = p-log-gatt
                       int-item.perc-gatt = p-perc-gatt.
            /* Cria a temp-table para guardar o "Antes" da altera‡Æo */
            RUN pi-criar-temp-table-alt-item (INPUT 2).
    
        END.
        /***************************************************************  Fim Itens  *************************************************************/

       
    END. /* Transa‡Æo */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-itens-ncm wWindow 
PROCEDURE pi-carrega-itens-ncm :
/*------------------------------------------------------------------------------
  Purpose:     Carregar os itens pertencentes a NCM
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-item.

    DEFINE VARIABLE c-codigo        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-descricao     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-aliquota-ii   AS CHARACTER   NO-UNDO.

    DEF VAR i-procura AS INTEGER NO-UNDO.
    CASE INPUT FRAME fpage0 rs-item:
        WHEN 1 THEN
            ASSIGN i-procura   = 1  /* Por Item*/
                   c-codigo    = "*" + TRIM(c-item:SCREEN-VALUE IN FRAME fpage0) + "*".
        WHEN 2 THEN
            ASSIGN i-procura   = 2 /* Por Descri‡ao */
                   c-descricao = "*" + TRIM(c-item:SCREEN-VALUE IN FRAME fpage0) + "*".
        WHEN 3 THEN
            ASSIGN i-procura   = 3. /* Sem Filtro */
    END CASE.

    FOR EACH  item NO-LOCK
        WHERE item.class-fiscal = INPUT BROWSE brNCM fiscosoft-ncm.codigo
          AND IF  i-procura = 1 THEN 
                  ITEM.it-codigo MATCHES c-codigo
              ELSE
                  IF  i-procura =  2 THEN
                      ITEM.desc-item MATCHES c-descricao
                  ELSE
                      YES:

        ASSIGN c-aliquota-ii = ''
               c-aliquota-ii = SUBSTR(ITEM.char-2,22,6)
               c-aliquota-ii = REPLACE(c-aliquota-ii,'0 ','0').

/*         IF c-aliquota-ii MATCHES ("*18*") THEN     */
/*             MESSAGE c-aliquota-ii                  */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        CREATE tt-item.
        BUFFER-COPY item TO tt-item.
        ASSIGN tt-item.r-rowid = ROWID(tt-item)
               tt-item.aliquota-ii = DEC(c-aliquota-ii).
    END.

    IF  CAN-FIND(FIRST tt-item) 
    OR l-acao-filtrar THEN DO:
        ENABLE btMarcarTodosItens
               btDesmarcarTodosItens
               btAtualizarInfoItens
               rs-item
               c-item
               btBusca-item
            WITH FRAME fPage0.
        DO WITH FRAME fpage0:
             ASSIGN btMarcarTodosItens:VISIBLE    = YES
                    btDesmarcarTodosItens:VISIBLE = YES
                    btAtualizarInfoItens:VISIBLE  = YES
                    rs-item:VISIBLE               = YES
                    c-item:VISIBLE                = YES
                    btBusca-item:VISIBLE          = YES.
        END.
    END.
    ELSE  DO:
        DISABLE btMarcarTodosItens
                btDesmarcarTodosItens
                btAtualizarInfoItens
                rs-item      
                c-item       
                btBusca-item 
            WITH FRAME fPage0.
        DO WITH FRAME fpage0:
             ASSIGN btMarcarTodosItens:VISIBLE    = NO
                    btDesmarcarTodosItens:VISIBLE = NO
                    btAtualizarInfoItens:VISIBLE  = NO
                    rs-item:VISIBLE               = NO      
                    c-item:VISIBLE                = NO       
                    btBusca-item:VISIBLE          = NO.   
        END.

    END.

    {&OPEN-QUERY-br-Itens}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-temp-table-alt-item wWindow 
PROCEDURE pi-criar-temp-table-alt-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM i-tipo AS INTEGER NO-UNDO. /* 1 - valor antigo, 2 - valor novo */

FIND FIRST tt-alt-item
    WHERE tt-alt-item.it-codigo = ITEM.it-codigo NO-ERROR.

IF  NOT AVAIL tt-alt-item THEN
    CREATE tt-alt-item.

ASSIGN tt-alt-item.it-codigo            = ITEM.it-codigo                   
       tt-alt-item.aliq-ipi    [i-tipo] = ITEM.aliquota-ipi                
       tt-alt-item.trib-ipi    [i-tipo] = {ininc/i10in172.i 04 ITEM.cd-trib-ipi} .

ASSIGN
       tt-alt-item.trib-import [i-tipo] = IF  SUBSTR(item.char-2,20,2) = "01" THEN "Tributado" 
                                             ELSE IF  SUBSTR(item.char-2,20,2) = "02" THEN "Isento" 
                                                   ELSE IF SUBSTR(item.char-2,20,2) = "03" THEN "Outros" 
                                                       ELSE IF SUBSTR(item.char-2,20,2) = "04" THEN "Reduzido" 
                                                          ELSE "NÆo Identificado" .

                                                               
ASSIGN
       tt-alt-item.imposto-imp [i-tipo] = DEC(REPLACE(SUBSTR(ITEM.char-2,22,6),'0 ','0'))
       tt-alt-item.aliq-pis    [i-tipo] = dec(SUBSTR(ITEM.CHAR-2, 31, 5))           
       tt-alt-item.aliq-cofins [i-tipo] = dec(SUBSTR(ITEM.CHAR-2, 36, 5))          
       tt-alt-item.trib-icms   [i-tipo] = {ininc/i11in172.i 04 ITEM.cd-trib-icm}   .

ASSIGN
       tt-alt-item.necessita-li[i-tipo] = IF ITEM.log-necessita-li THEN "SIM" ELSE "NÇO".

           ASSIGN
       tt-alt-item.destaque    [i-tipo] = IF AVAIL int-item THEN int-item.destaque ELSE 0.


                                                                                            ASSIGN
       tt-alt-item.nve         [i-tipo] = IF AVAIL int-item THEN int-item.nve ELSE ""      .
                                                                                       ASSIGN
       tt-alt-item.ex          [i-tipo] = IF AVAIL int-item THEN int-item.ex ELSE ""        .
                                                                                      ASSIGN
       tt-alt-item.log-gatt    [i-tipo] = IF AVAIL int-item AND int-item.log-gatt THEN "SIM" ELSE "NÇO".
                                                                                                      ASSIGN
       tt-alt-item.perc-gatt   [i-tipo] = IF AVAIL int-item THEN int-item.perc-gatt ELSE 0.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-temp-table-alt-ncm wWindow 
PROCEDURE pi-criar-temp-table-alt-ncm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM i-tipo AS INTEGER NO-UNDO. /* 1 - valor antigo, 2 - valor novo */

FIND FIRST tt-alt-ncm
    WHERE tt-alt-ncm.ncm = classif-fisc.class-fiscal NO-ERROR.

IF  NOT AVAIL tt-alt-ncm THEN
    CREATE tt-alt-ncm.

ASSIGN tt-alt-ncm.ncm                  = classif-fisc.class-fiscal
       tt-alt-ncm.aliq-ipi    [i-tipo] = classif-fisc.aliquota-ipi
       tt-alt-ncm.pis         [i-tipo] = classif-fisc.dec-1
       tt-alt-ncm.cofins      [i-tipo] = classif-fisc.dec-2
       tt-alt-ncm.pis-ext     [i-tipo] = classif-fisc.val-aliq-ext-pis
       tt-alt-ncm.cofins-ext  [i-tipo] = classif-fisc.val-aliq-ext-cofins
       tt-alt-ncm.imposto-imp [i-tipo] = dec(SUBSTR(classif-fisc.char-1, 1, 20))
       tt-alt-ncm.majorada    [i-tipo] = DEC(substr(classif-fisc.char-1, 56, 6)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email-log wWindow 
PROCEDURE pi-envia-email-log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     DEF VAR h-utapi019 AS HANDLE NO-UNDO.
    
     EMPTY TEMP-TABLE tt-envio2.
     EMPTY TEMP-TABLE tt-mensagem1.
     EMPTY TEMP-TABLE tt-erros-1.

     FIND FIRST param-global    NO-LOCK NO-ERROR.
     FIND FIRST param-fiscosoft NO-LOCK NO-ERROR.

     DEF VAR c-msg-cab    AS CHAR NO-UNDO.
     DEF VAR c-mensagem   AS CHAR NO-UNDO.
     DEF VAR c-mensagem-1 AS CHAR NO-UNDO.
     DEF VAR c-assunto    AS CHAR NO-UNDO.
     DEF VAR c-ncm        LIKE classif-fisc.class-fiscal NO-UNDO.


     FIND FIRST tt-alt-ncm NO-LOCK NO-ERROR.

     IF  NOT AVAIL tt-alt-ncm THEN
         RETURN "NOK".

     ASSIGN c-ncm = tt-alt-ncm.ncm.

     ASSIGN c-msg-cab = "<html>Prezado, " + "<BR><BR>" +                                                                         
                        "    Seguem Anexo arquivo com LOG de atualiza‡Æo de Item(ns) referentes … NCM: " + '<font color="#0000FF" size="4">' + 
                        "<b>" + string(c-ncm, "9999.99.99") + "</B>" + "<BR><BR>" + 
                        "Atenciosamente, ".

     
     /*********************** Monta a mesagem por NCM, de acordo com as altera»‡äes encontradas. ***********************/
     PUT STREAM s UNFORMATTED "NCM;;IPI;PIS;COFINS;PIS EXT;COFINS EXT;Al¡quota II;Al¡quota Majorada" SKIP.

     FOR EACH tt-alt-ncm:
         PUT STREAM s UNFORMATTED tt-alt-ncm.ncm            ";"
                                  "DE:"                     ";"
                                  tt-alt-ncm.aliq-ipi   [1] ";"
                                  tt-alt-ncm.pis        [1] ";"
                                  tt-alt-ncm.cofins     [1] ";"
                                  tt-alt-ncm.pis-ext    [1] ";"
                                  tt-alt-ncm.cofins-ext [1] ";"
                                  tt-alt-ncm.imposto-imp[1] ";"
                                  tt-alt-ncm.majorada   [1] SKIP.

         PUT STREAM s UNFORMATTED tt-alt-ncm.ncm            ";"
                                  "PARA:"                   ";"
                                  tt-alt-ncm.aliq-ipi   [2] ";"
                                  tt-alt-ncm.pis        [2] ";"
                                  tt-alt-ncm.cofins     [2] ";"
                                  tt-alt-ncm.pis-ext    [2] ";"
                                  tt-alt-ncm.cofins-ext [2] ";"
                                  tt-alt-ncm.imposto-imp[2] ";"
                                  tt-alt-ncm.majorada   [2] SKIP.
     END.

     /************************************** Mensagem com os ITENS Alterados *********************************************/

     PUT  STREAM s UNFORMATTED skip(1) "---------------------------------------------------------------------------------------------------------------------------------------------"
                               skip(1) "ITEM;;Trib IPI;IPI;Trib II; Al¡quota II; PIS; COFINS; Necessita LI; Destaque; NVE; EX Tarif rio; GATT; % GATT" SKIP.
          
     FOR EACH tt-alt-item:
         PUT STREAM s UNFORMATTED tt-alt-item.it-codigo        ";"
                                  "DE:"                        ";"
                                  tt-alt-item.trib-ipi     [1] ";"
                                  tt-alt-item.aliq-ipi     [1] ";"
                                  tt-alt-item.trib-import  [1] ";"
                                  tt-alt-item.imposto-imp  [1] ";"
                                  tt-alt-item.aliq-pis     [1] ";"
                                  tt-alt-item.aliq-cofins  [1] ";"
                                  tt-alt-item.necessita-li [1] ";"
                                  tt-alt-item.destaque     [1] ";" 
                                  tt-alt-item.nve          [1] ";"
                                  tt-alt-item.ex           [1] ";"
                                  tt-alt-item.log-gatt     [1] ";"
                                  tt-alt-item.perc-gatt    [1] ";" SKIP.

         PUT STREAM s UNFORMATTED tt-alt-item.it-codigo        ";"
                                  "PARA:"                      ";"
                                  tt-alt-item.trib-ipi     [2] ";"
                                  tt-alt-item.aliq-ipi     [2] ";"
                                  tt-alt-item.trib-import  [2] ";"
                                  tt-alt-item.imposto-imp  [2] ";"
                                  tt-alt-item.aliq-pis     [2] ";"
                                  tt-alt-item.aliq-cofins  [2] ";"
                                  tt-alt-item.necessita-li [2] ";"
                                  tt-alt-item.destaque     [2] ";" 
                                  tt-alt-item.nve          [2] ";" 
                                  tt-alt-item.ex           [2] ";"
                                  tt-alt-item.log-gatt     [2] ";"
                                  tt-alt-item.perc-gatt    [2] ";" SKIP.

     END.
     
     OUTPUT STREAM s close.

     /************************************************************** ENVIO **************************************************/
     RUN utp/utapi019.p PERSISTENT SET h-utapi019.

     ASSIGN c-assunto = "Usu rio atualizou NCM/Item(ns) via ESIN004. NCM: " + string(c-ncm, "9999.99.99").

     create tt-envio2.
     assign tt-envio2.versao-integracao = 1
            tt-envio2.servidor          = param-global.serv-mail
            tt-envio2.porta             = param-global.porta-mail
            tt-envio2.remetente         = "EMS@intelbras.com.br"
            tt-envio2.destino           = param-fiscosoft.email-atualiz-ems /* Esse campo guarda o destinat rio(s) para o qual se vai enviar o log de altera‡Æo dos itens*/
            tt-envio2.assunto           = c-assunto
            tt-envio2.arq-anexo         = cArqEmail
            tt-envio2.formato           = "HTML"
            tt-envio2.exchange          = NO.

     CREATE tt-mensagem1.
     ASSIGN tt-mensagem1.seq-mensagem = 1
            tt-mensagem1.mensagem = c-msg-cab.

     RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                    INPUT TABLE tt-mensagem1,
                                    OUTPUT TABLE tt-erros-1).

     DELETE PROCEDURE h-utapi019.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataAte wWindow 
FUNCTION fnDataAte RETURNS DATE
  ( pData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Corrigir o formato de data recebido como parƒmetro
    Notes: A data ‚ enviado em "AAAA/MM/DD" e retornada em "DD/MM/AAAA"
------------------------------------------------------------------------------*/

    IF  pData <> "" THEN
        ASSIGN dt-formato-certo-ate = DATE(INT(SUBSTRING(pData,6,2)),INT(SUBSTRING(pData,9,2)),INT(SUBSTRING(pData,1,4))).
    ELSE
        ASSIGN dt-formato-certo-ate = ?.

    RETURN dt-formato-certo-ate.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataDe wWindow 
FUNCTION fnDataDe RETURNS DATE
  ( pData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Corrigir o formato de data recebido como parƒmetro
    Notes: A data ‚ enviado em "AAAA/MM/DD" e retornada em "DD/MM/AAAA"
------------------------------------------------------------------------------*/

    IF  pData <> "" THEN
        ASSIGN dt-formato-certo-de = DATE(INT(SUBSTRING(pData,6,2)),INT(SUBSTRING(pData,9,2)),INT(SUBSTRING(pData,1,4))).
    ELSE
        ASSIGN dt-formato-certo-de = ?.

    RETURN dt-formato-certo-de.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSelecao wWindow 
FUNCTION fnSelecao RETURNS CHARACTER
  ( pSelecionado AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-selecionado = pSelecionado.

    RETURN c-selecionado.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

