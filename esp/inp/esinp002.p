/*********************************************************************************
** Programa: esp/inp/esinp002.p
** Vers∆o..: 1.00
** Data....: 21/02/2011
** Autor...: Felipe Braun
** Obs.....: API de WebService para buscar as informaá‰es do FISCOSoft, e retornar
**           os dados em Temp-Tables
*********************************************************************************/

{esp/inp/esinp002.i} /* Definiá∆o das temp-table do FISCOSoft */

/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER pNCM      AS CHAR        NO-UNDO.
DEFINE INPUT  PARAMETER pPonteiro AS DECIMAL     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ncm.
DEFINE OUTPUT PARAMETER TABLE FOR tt-acordos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-list-ex.
DEFINE OUTPUT PARAMETER TABLE FOR tt-list-ex-bit.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ex-br-simples.
DEFINE OUTPUT PARAMETER TABLE FOR tt-sistemas.
DEFINE OUTPUT PARAMETER TABLE FOR tt-red-import.
DEFINE OUTPUT PARAMETER TABLE FOR tt-nve.
DEFINE OUTPUT PARAMETER TABLE FOR tt-naladi-1996.
DEFINE OUTPUT PARAMETER TABLE FOR tt-naladi-2002.
DEFINE OUTPUT PARAMETER TABLE FOR tt-naladi-2007.
DEFINE OUTPUT PARAMETER TABLE FOR tt-defesa-comercial.
DEFINE OUTPUT PARAMETER TABLE FOR tt-acordo-ptr04.
DEFINE OUTPUT PARAMETER TABLE FOR tt-icms-convenio.
DEFINE OUTPUT PARAMETER TABLE FOR tt-tra-siscomex.
DEFINE OUTPUT PARAMETER TABLE FOR tt-pis-cofins.
DEFINE OUTPUT PARAMETER TABLE FOR tt-notas-complementares.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ipi-det.

/*--- Definiá∆o das Vari†veis ---*/
define variable hWS     as handle   no-undo.
define variable hPort   as handle   no-undo.
define variable lResult as longchar no-undo.

define variable hDoc    as handle   no-undo.
define variable hRoot   as handle   no-undo.
define variable hAux1   as handle   no-undo.
define variable hAux2   as handle   no-undo.
define variable hAux3   as handle   no-undo.
define variable hAux4   as handle   no-undo.
define variable hField  as handle   no-undo.
define variable hNCM    as handle   no-undo.
define variable hDescricao  as handle   no-undo.
define variable hValue  as handle   no-undo.
define variable i       as integer  no-undo.
define variable j       as integer  no-undo.
define variable k       as integer  no-undo.
define variable m       as integer  no-undo.
define variable long-nota as LONGCHAR  no-undo.

define variable i-ncm                    as integer   no-undo.
define variable i-acordos                as integer   no-undo.
define variable i-list-ex                as integer   no-undo.
define variable i-list-ex-bit            as integer   no-undo.
define variable i-ex-br-simples          as integer   no-undo.
define variable i-sistemas               as integer   no-undo.
define variable i-red-import             as integer   no-undo.
define variable i-nve                    as integer   no-undo.
define variable i-naladi-1996            as integer   no-undo.
define variable i-naladi-2002            as integer   no-undo.
define variable i-naladi-2007            as integer   no-undo.
define variable i-defesa-comercial       as integer   no-undo.
define variable i-acordo-ptr04           as integer   no-undo.
define variable i-icms-convenio          as integer   no-undo.
define variable i-tra-siscomex           as integer   no-undo.
define variable i-pis-cofins             as integer   no-undo.
define variable i-notas-complementares   as integer   no-undo.
define variable i-ipi-det                as integer   no-undo.

define variable c-cod-status             as character no-undo.
define variable c-msg-status             as character no-undo.

define variable btt-ncm                  as handle    no-undo.
define variable btt-acordos              as handle    no-undo.
define variable btt-list-ex              as handle    no-undo.
define variable btt-list-ex-bit          as handle    no-undo.
define variable btt-ex-br-simples        as handle    no-undo.
define variable btt-sistemas             as handle    no-undo.
define variable btt-red-import           as handle    no-undo.
define variable btt-nve                  as handle    no-undo.
define variable btt-naladi-1996          as handle    no-undo.
define variable btt-naladi-2002          as handle    no-undo.
define variable btt-naladi-2007          as handle    no-undo.
define variable btt-defesa-comercial     as handle    no-undo.
define variable btt-acordo-ptr04         as handle    no-undo.
define variable btt-icms-convenio        as handle    no-undo.
define variable btt-tra-siscomex         as handle    no-undo.
define variable btt-pis-cofins           as handle    no-undo.
define variable btt-notas-complementares as handle    no-undo.
define variable btt-ipi-det              as handle    no-undo.

create buffer btt-ncm                  for table "tt-ncm".
create buffer btt-acordos              for table "tt-acordos".
create buffer btt-list-ex              for table "tt-list-ex".
create buffer btt-list-ex-bit          for table "tt-list-ex-bit".
create buffer btt-ex-br-simples        for table "tt-ex-br-simples".
create buffer btt-sistemas             for table "tt-sistemas".
create buffer btt-red-import           for table "tt-red-import".
create buffer btt-nve                  for table "tt-nve".
create buffer btt-naladi-1996          for table "tt-naladi-1996".
create buffer btt-naladi-2002          for table "tt-naladi-2002".
create buffer btt-naladi-2007          for table "tt-naladi-2007".
create buffer btt-defesa-comercial     for table "tt-defesa-comercial".
create buffer btt-acordo-ptr04         for table "tt-acordo-ptr04".
create buffer btt-icms-convenio        for table "tt-icms-convenio".
create buffer btt-tra-siscomex         for table "tt-tra-siscomex".
create buffer btt-pis-cofins           for table "tt-pis-cofins".
create buffer btt-notas-complementares for table "tt-notas-complementares".
create buffer btt-ipi-det              for table "tt-ipi-det".

create x-document hDoc.
create x-noderef hRoot.
create x-noderef hAux1.
create x-noderef hAux2.
create x-noderef hAux3.
create x-noderef hAux4.
create x-noderef hValue.

create server hWS.

/*--- Processamento Principal ---*/
hWS:CONNECT("-WSDL 'http://sp.systax.com.br/webservice/tec.php?wsdl'").

RUN tecPortType SET hPort ON hWS.

RUN tec IN hPort (INPUT 'intelbras',   /** Usu†rio              **/
                  INPUT '1568497289',  /** Senha             antiga 1568497289   **/
                  INPUT  pNCM,         /** NCM                  **/
                  INPUT  5,            /** Paginaá∆o            **/
                  INPUT  '',           /** Escopo               **/
                  INPUT  pPonteiro,    /** Ponteiro atualizaá∆o **/
                  OUTPUT lResult).

hDoc:LOAD("longchar", lResult, NO).
/*hDoc:SAVE("file","C:/temp/" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").*/
/*hDoc:SAVE("file","C:/temp/fiscosoft" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").*/

hDoc:GET-DOCUMENT-ELEMENT(hRoot).
DO TRANS:

    do i = 1 to hRoot:num-children:
       hRoot:get-child(hAux1, i).
    
       /** Os outros n¢s s∆o in£teis **/
       if (hAux1:name = 'status') then do:
          do j = 1 to hAux1:num-children:
             hAux1:get-child(hAux2, j).
    
             if hAux2:subtype ne 'ELEMENT' then next.
             if hAux2:num-children < 1 then next.
    
             hAux2:get-child(hValue, 1).
    
             case hAux2:name:
                when 'cod_status' THEN DO:
                    assign c-cod-status = hValue:NODE-VALUE NO-ERROR.
                    IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1) SKIP(2).
                END.
                when 'msg_status' THEN DO:
                   assign c-msg-status = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED  ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1) SKIP(2).
                END.
             end case.
          end.
       end.
    
       /** Informaá‰es da NCM **/
       if (hAux1:name = 'ncm') then do:
          btt-ncm:buffer-create().
          assign i-ncm = i-ncm + 1
                 i-acordos              = 0
                 i-list-ex              = 0
                 i-list-ex-bit          = 0
                 i-ex-br-simples        = 0
                 i-sistemas             = 0
                 i-red-import           = 0
                 i-nve                  = 0
                 i-naladi-1996          = 0
                 i-naladi-2002          = 0
                 i-naladi-2007          = 0
                 i-defesa-comercial     = 0
                 i-acordo-ptr04         = 0
                 i-icms-convenio        = 0
                 i-tra-siscomex         = 0
                 i-pis-cofins           = 0
                 i-notas-complementares = 0
                 i-ipi-det              = 0
                 hField = btt-ncm:buffer-field('sequencia_ncm')
                 hField:buffer-value = i-ncm
                 hNCM = btt-ncm:BUFFER-FIELD('codigo')
                 hDescricao = btt-ncm:buffer-field('descricao').
                 
/*           DEF VAR h-query AS HANDLE NO-UNDO.          */
/*           CREATE QUERY h-query.                       */
/*           h-query:SET-BUFFERS (btt-ncm).              */
/*           h-query:QUERY-PREPARE ("for each tt-ncm").  */
/*           h-query:QUERY-OPEN.                         */
/*           h-query:GET-FIRST.                          */
/*           h-query:QUERY-CLOSE.                        */
/*           h-query:                                    */

          do j = 1 to hAux1:num-children:
             hAux1:get-child(hAux2, j).
    
             if hAux2:subtype ne 'ELEMENT' then next.
             if hAux2:num-children < 1 then next.
    
             /** <acordos> **/
             if hAux2:name = 'acordos' then do:
                btt-acordos:buffer-create().
                assign i-acordos = i-acordos + 1
                       hField = btt-acordos:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-acordos:buffer-field('sequencia')
                       hField:buffer-value = i-acordos.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-acordos:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <ipi_det> **/
             else if hAux2:name = 'ipi_det' then do:
                btt-ipi-det:buffer-create().
                assign i-ipi-det = i-ipi-det + 1
                       hField = btt-ipi-det:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-ipi-det:buffer-field('sequencia')
                       hField:buffer-value = i-ipi-det.

                ASSIGN i-notas-complementares = 0.

                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-ipi-det:buffer-field(hAux3:name) no-error.

                   /************************* NOTAS COMPLEMENTARES ***************************/
                   IF  hAux3:NAME = "notas_complementares" THEN DO:
                       btt-notas-complementares:buffer-create().                              
                       assign i-notas-complementares = i-notas-complementares + 1             
                              hField = btt-notas-complementares:buffer-field('sequencia_ncm') 
                              hField:buffer-value = i-ncm                                     
                              hField = btt-notas-complementares:buffer-field('seq_ipi_det')     
                              hField:buffer-value = i-ipi-det
                              hField = btt-notas-complementares:buffer-field('sequencia')     
                              hField:buffer-value = i-notas-complementares.                   
                                                                                               
                       do m = 1 to hAux3:num-children:                                        
                          hAux3:get-child(hAux4, m).                                          
                                                                                              
                          if hAux4:subtype ne 'ELEMENT' then next.                            
                          if hAux4:num-children < 1 then next.                                
                                                                                              
                          hAux4:get-child(hValue, 1).                                         
                                                                                              
                          hField = btt-notas-complementares:buffer-field(hAux4:name) no-error.
                          if hField = ? then next.             

                          IF  hAux4:NAME = "nota" THEN DO:
                              hValue:NODE-VALUE-TO-LONGCHAR (long-nota).
                              COPY-LOB long-nota TO hField:buffer-value.
                          END.
                          ELSE DO: 
                          
                              ASSIGN hField:buffer-value = hValue:NODE-VALUE NO-ERROR.                            
                              IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                          END.
                       end.                                                                   
                       
                   END.
                   /***************************************************************************/
                   
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).

                   /*UN pi-notas-comp.*/

                end.
             end.
             /** <list_ex> **/
             else if hAux2:name = 'list_ex' then do:
                btt-list-ex:buffer-create().
                assign i-list-ex = i-list-ex + 1
                       hField = btt-list-ex:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-list-ex:buffer-field('sequencia')
                       hField:buffer-value = i-list-ex.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-list-ex:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <list_ex_bit> **/
             else if hAux2:name = 'list_ex_bit' then do:
                btt-list-ex-bit:buffer-create().
                assign i-list-ex-bit = i-list-ex-bit + 1
                       hField = btt-list-ex-bit:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-list-ex-bit:buffer-field('sequencia')
                       hField:buffer-value = i-list-ex-bit.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-list-ex-bit:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <ex_br_simples> **/
             else if hAux2:name = 'ex_br_simples' then do:
                btt-ex-br-simples:buffer-create().
                assign i-ex-br-simples = i-ex-br-simples + 1
                       hField = btt-ex-br-simples:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-ex-br-simples:buffer-field('sequencia')
                       hField:buffer-value = i-ex-br-simples.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-ex-br-simples:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <sistemas> **/
             else if hAux2:name = 'sistemas' then do:
                btt-sistemas:buffer-create().
                assign i-sistemas = i-sistemas + 1
                       hField = btt-sistemas:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-sistemas:buffer-field('sequencia')
                       hField:buffer-value = i-sistemas.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-sistemas:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <red_import> **/
             else if hAux2:name = 'red_import' then do:
                btt-red-import:buffer-create().
                assign i-red-import = i-red-import + 1
                       hField = btt-red-import:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-red-import:buffer-field('sequencia')
                       hField:buffer-value = i-red-import.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-red-import:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <nve> **/
             else if hAux2:name = 'nve' then do:
                btt-nve:buffer-create().
                assign i-nve = i-nve + 1
                       hField = btt-nve:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-nve:buffer-field('sequencia')
                       hField:buffer-value = i-nve.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-nve:buffer-field(hAux3:name) NO-ERROR.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <naladi_1996> **/
             else if hAux2:name = 'naladi_1996' then do:
                btt-naladi-1996:buffer-create().
                assign i-naladi-1996 = i-naladi-1996 + 1
                       hField = btt-naladi-1996:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-naladi-1996:buffer-field('sequencia')
                       hField:buffer-value = i-naladi-1996.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-naladi-1996:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <naladi_2002> **/
             else if hAux2:name = 'naladi_2002' then do:
                btt-naladi-2002:buffer-create().
                assign i-naladi-2002 = i-naladi-2002 + 1
                       hField = btt-naladi-2002:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-naladi-2002:buffer-field('sequencia')
                       hField:buffer-value = i-naladi-2002.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-naladi-2002:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <naladi_2007> **/
             else if hAux2:name = 'naladi_2007' then do:
                btt-naladi-2007:buffer-create().
                assign i-naladi-2007 = i-naladi-2007 + 1
                       hField = btt-naladi-2007:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-naladi-2007:buffer-field('sequencia')
                       hField:buffer-value = i-naladi-2007.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-naladi-2007:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <defesa_comercial> **/
             else if hAux2:name = 'defesa_comercial' then do:
                btt-defesa-comercial:buffer-create().
                assign i-defesa-comercial = i-defesa-comercial + 1
                       hField = btt-defesa-comercial:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-defesa-comercial:buffer-field('sequencia')
                       hField:buffer-value = i-defesa-comercial.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-defesa-comercial:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <acordo_ptr04> **/
             else if hAux2:name = 'acordo_ptr04' then do:
                btt-acordo-ptr04:buffer-create().
                assign i-acordo-ptr04 = i-acordo-ptr04 + 1
                       hField = btt-acordo-ptr04:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-acordo-ptr04:buffer-field('sequencia')
                       hField:buffer-value = i-acordo-ptr04.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-acordo-ptr04:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <icms_convenio> **/
             else if hAux2:name = 'icms_convenio' then do:
                btt-icms-convenio:buffer-create().
                assign i-icms-convenio = i-icms-convenio + 1
                       hField = btt-icms-convenio:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-icms-convenio:buffer-field('sequencia')
                       hField:buffer-value = i-icms-convenio.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-icms-convenio:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <tra_siscomex> **/
             else if hAux2:name = 'tra_siscomex' then do:
                btt-tra-siscomex:buffer-create().
                assign i-tra-siscomex = i-tra-siscomex + 1
                       hField = btt-tra-siscomex:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-tra-siscomex:buffer-field('sequencia')
                       hField:buffer-value = i-tra-siscomex.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-tra-siscomex:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <pis_cofins> **/
             else if hAux2:name = 'pis_cofins' then do:
                btt-pis-cofins:buffer-create().
                assign i-pis-cofins = i-pis-cofins + 1
                       hField = btt-pis-cofins:buffer-field('sequencia_ncm')
                       hField:buffer-value = i-ncm
                       hField = btt-pis-cofins:buffer-field('sequencia')
                       hField:buffer-value = i-pis-cofins.
    
                do k = 1 to hAux2:num-children:
                   hAux2:get-child(hAux3, k).
       
                   if hAux3:subtype ne 'ELEMENT' then next.
                   if hAux3:num-children < 1 then next.
                   
                   hAux3:get-child(hValue, 1).
       
                   hField = btt-pis-cofins:buffer-field(hAux3:name) no-error.
                   if hField = ? then next.
                   hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                   IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
                end.
             end.
             /** <notas_complementares> **/
/*              else if hAux2:name = 'notas_complementares' then do:                        */
/*                 btt-notas-complementares:buffer-create().                                */
/*                 assign i-notas-complementares = i-notas-complementares + 1               */
/*                        hField = btt-notas-complementares:buffer-field('sequencia_ncm')   */
/*                        hField:buffer-value = i-ncm                                       */
/*                        hField = btt-notas-complementares:buffer-field('sequencia')       */
/*                        hField:buffer-value = i-notas-complementares.                     */
/*                                                                                          */
/*                 do k = 1 to hAux2:num-children:                                          */
/*                    hAux2:get-child(hAux3, k).                                            */
/*                                                                                          */
/*                    if hAux3:subtype ne 'ELEMENT' then next.                              */
/*                    if hAux3:num-children < 1 then next.                                  */
/*                                                                                          */
/*                    hAux3:get-child(hValue, 1).                                           */
/*                                                                                          */
/*                    hField = btt-notas-complementares:buffer-field(hAux3:name) no-error.  */
/*                    if hField = ? then next.                                              */
/*                    hField:buffer-value = hValue:node-value.                              */
/*                 end.                                                                     */
/*              end.                                                                        */
             /** tags do <ncm> **/
             else do:
                hAux2:get-child(hValue, 1).
       
                hField = btt-ncm:buffer-field(hAux2:name) no-error.
                if hField = ? then next.
                hField:buffer-value = hValue:NODE-VALUE NO-ERROR.
                IF  ERROR-STATUS:ERROR THEN PUT UNFORMATTED "ERRO TABELA <" hAux2:NAME ">" SKIP ERROR-STATUS:GET-NUMBER(1) SPACE(2) ERROR-STATUS:GET-MESSAGE(1).
             end.
          end.

          FIND LAST tt-ncm NO-LOCK NO-ERROR.
          IF  AVAIL tt-ncm  AND ERROR-STATUS:ERROR THEN
              PUT UNFORMATTED SKIP "NCM com erro: " tt-ncm.codigo SKIP(2).

            
       end.
    end.
END.

/* OUTPUT TO c:\temp\roger.txt.                      */
/*                                                   */
/* PUT SKIP(2) "tt-ncm" SKIP(1).                     */
/*                                                   */
/* PUT SKIP(2) "tt-acordos" SKIP(1).                 */
/* i = 0 .                                           */
/* FOR EACH tt-acordos:                              */
/*     DISP tt-acordos WITH WIDTH 590.               */
/*     PUT SKIP(1).                                  */
/*     i = i + 1.                                    */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-list-ex" SKIP(1).                 */
/* FOR EACH tt-list-ex:                              */
/*     DISP  tt-list-ex WITH 1 COLUMN.               */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-list-ex-bit" SKIP(1).             */
/* FOR EACH tt-list-ex-bit:                          */
/*     DISP  tt-list-ex-bit WITH 1 COLUMN.           */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-ex-br-simples" SKIP(1).           */
/* FOR EACH tt-ex-br-simples:                        */
/*     DISP  tt-ex-br-simples WITH 1 COLUMN.         */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-sistemas" SKIP(1).                */
/* FOR EACH tt-sistemas:                             */
/*     DISP  tt-sistemas WITH 1 COLUMN.              */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-red-import" SKIP(1).              */
/* FOR EACH tt-red-import:                           */
/*     DISP  tt-red-import WITH 1 COLUMN.            */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-nve" SKIP(1).                     */
/* FOR EACH tt-nve:                                  */
/*     DISP  tt-nve WITH 1 COLUMN.                   */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-naladi-1996" SKIP(1).             */
/* i = 0.                                            */
/* FOR EACH tt-naladi-1996:                          */
/*     DISP  tt-naladi-1996 WITH 1 COLUMN.           */
/*     PUT SKIP(1).                                  */
/*     i = i + 1.                                    */
/* END.                                              */
/*                                                   */
/* i = 0.                                            */
/* PUT SKIP(2) "tt-naladi-2002" SKIP(1).             */
/* FOR EACH tt-naladi-2002:                          */
/*     DISP  tt-naladi-2002 WITH 1 COLUMN.           */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* i = 0.                                            */
/* PUT SKIP(2) "tt-naladi-2007" SKIP(1).             */
/* FOR EACH tt-naladi-2007:                          */
/*     DISP  tt-naladi-2007 WITH 1 COLUMN.           */
/*     PUT SKIP(1).                                  */
/*     i = i + 1.                                    */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-defesa-comercial" SKIP(1).        */
/* FOR EACH tt-defesa-comercial:                     */
/*     DISP  tt-defesa-comercial WITH 1 COLUMN.      */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-acordo-ptr04" SKIP(1).            */
/* FOR EACH tt-acordo-ptr04:                         */
/*     DISP  tt-acordo-ptr04 WITH 1 COLUMN.          */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-icms-convenio" SKIP(1).           */
/* FOR EACH tt-icms-convenio:                        */
/*     DISP  tt-icms-convenio WITH 1 COLUMN.         */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-tra-siscomex" SKIP(1).            */
/* FOR EACH tt-tra-siscomex:                         */
/*     DISP  tt-tra-siscomex WITH 1 COLUMN.          */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-icms-convenio" SKIP(1).           */
/* FOR EACH tt-icms-convenio:                        */
/*     DISP  tt-icms-convenio WITH 1 COLUMN.         */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-notas-complementares" SKIP(1).    */
/* FOR EACH tt-notas-complementares:                 */
/*     DISP  tt-notas-complementares WITH 1 COLUMN.  */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* PUT SKIP(2) "tt-ipi-det" SKIP(1).                 */
/* FOR EACH tt-ipi-det:                              */
/*     DISP  tt-ipi-det WITH 1 COLUMN.               */
/*     PUT SKIP(1).                                  */
/* END.                                              */
/*                                                   */
/* OUTPUT CLOSE.                                     */


IF  VALID-HANDLE(hField) THEN
    DELETE OBJECT hField.

IF  VALID-HANDLE(hValue) THEN
    DELETE OBJECT hValue.

IF  VALID-HANDLE(hAux3) THEN
    DELETE OBJECT hAux3.

IF  VALID-HANDLE(hAux2) THEN
    DELETE OBJECT hAux2.

IF  VALID-HANDLE(hAux1) THEN
    DELETE OBJECT hAux1.

IF  VALID-HANDLE(hRoot) THEN
    DELETE OBJECT hRoot.

IF  VALID-HANDLE(hDoc) THEN
    DELETE OBJECT hDoc.

IF  VALID-HANDLE(hPort) THEN
    DELETE OBJECT hPort.

IF  VALID-HANDLE(hWS) THEN DO:
    hWS:DISCONNECT().
    DELETE OBJECT hWS.
END.


/* PROCEDURE pi-notas-comp:                                                            */
/*                                                                                     */
/*                                                                                     */
/*     DEF VAR j AS INTEGER NO-UNDO.                                                   */
/*                                                                                     */
/*     DO j = 1 to hAux1:num-children:                                                 */
/*         hAux1:get-child(hAux2, j).                                                  */
/*                                                                                     */
/*         if hAux2:subtype ne 'ELEMENT' then next.                                    */
/*         if hAux2:num-children < 1 then next.                                        */
/*                                                                                     */
/*         /** <acordos> **/                                                           */
/*         if  hAux2:name = 'notas_complementares' then do:                            */
/*             btt-notas-complementares:buffer-create().                               */
/*             assign i-notas-complementares = i-notas-complementares + 1              */
/*                    hField = btt-notas-complementares:buffer-field('sequencia_ncm')  */
/*                    hField:buffer-value = i-ncm                                      */
/*                    hField = btt-notas-complementares:buffer-field('sequencia')      */
/*                    hField:buffer-value = i-notas-complementares.                    */
/*                                                                                     */
/*             do k = 1 to hAux2:num-children:                                         */
/*                hAux2:get-child(hAux3, k).                                           */
/*                                                                                     */
/*                if hAux3:subtype ne 'ELEMENT' then next.                             */
/*                if hAux3:num-children < 1 then next.                                 */
/*                                                                                     */
/*                hAux3:get-child(hValue, 1).                                          */
/*                                                                                     */
/*                hField = btt-notas-complementares:buffer-field(hAux3:name) no-error. */
/*                if hField = ? then next.                                             */
/*                hField:buffer-value = hValue:node-value.                             */
/*             end.                                                                    */
/*                                                                                     */
/*     END.                                                                            */
/*                                                                                     */
/* END.                                                                                */
