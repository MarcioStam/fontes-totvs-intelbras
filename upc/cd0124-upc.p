/****************************************************************************
** Programa : CD0124
** Descricao: Ajustes em Cadastro de Ferramentas para Projeto MES e APS
**     Autor: Isac Abrahao
**      Data: 08/09/2021
*****************************************************************************/
/***  Parametros de recepcao da UPC **/
DEF INPUT PARAM p-ind-event      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR            NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE          NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE   NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID           NO-UNDO.
{utp/ut-glob.i}
{esp/es0018.i}
{utp/utapi019.i}
DEF VAR wh-objeto AS WIDGET-HANDLE NO-UNDO.
DEF VAR c-objeto   AS CHAR         NO-UNDO.
DEF VAR c-result   AS CHAR         NO-UNDO.
/***  identificando nome de objeto ***/
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/") ,p-wgh-object:FILE-NAME, "~/"). 

/*
 message "Evento    " p-ind-event  skip       
         "Objeto    " p-ind-object skip       
         "nome obj  " c-objeto     skip       
         "Frame     " p-wgh-frame  skip       
         "Tabela    " p-cod-table  skip       
         "ROWID     " string(p-row-table) SKIP
         view-as alert-box information. */      
DEF NEW GLOBAL SHARED VAR wh-i-un-ciclo-cd0124     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo-cd0124      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-desc-cd0124         AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-manut-cd0124      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-data-ult-manut-cd0124 AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-dispon-cd0124     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qtde-dispon-cd0124    AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-ferramen-cd0124   AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo-cd0124          AS HANDLE NO-UNDO.
/* DEF NEW GLOBAL SHARED VAR wh-txt-atualiz-cd0124    AS HANDLE NO-UNDO. */
/* DEF NEW GLOBAL SHARED VAR wh-data-atualiz-cd0124   AS HANDLE NO-UNDO. */
DEF NEW GLOBAL SHARED VAR wh-txt-nr-up-hora-cd0124 AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-up-hora-cd0124     AS HANDLE NO-UNDO.
/* DEF NEW GLOBAL SHARED VAR wh-txt-IDTooling-cd0124  AS HANDLE NO-UNDO. */
/* DEF NEW GLOBAL SHARED VAR wh-IDTooling-cd0124      AS HANDLE NO-UNDO. */
DEF NEW GLOBAL SHARED VAR wh-combo                 AS HANDLE NO-UNDO.
/******** Inicio ********/
IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "VIEWER"     THEN DO:
   IF NOT VALID-HANDLE(wh-objeto) THEN DO:
      RUN busca-handle(INPUT 'cod-ferr-prod',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).
      IF VALID-HANDLE(wh-objeto) THEN
         ASSIGN wh-cod-ferramen-cd0124 = wh-objeto:HANDLE.
      IF VALID-HANDLE(wh-cod-ferramen-cd0124) THEN
          ASSIGN wh-cod-ferramen-cd0124:LABEL = "C¢digo".
      RUN busca-handle(INPUT 'i-un-ciclo',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).
      IF VALID-HANDLE(wh-objeto) THEN DO:
         wh-i-un-ciclo-cd0124 = wh-objeto:HANDLE.
         CREATE TOGGLE-BOX wh-ativo-cd0124
         ASSIGN FRAME            = wh-i-un-ciclo-cd0124:FRAME 
               ROW               = wh-i-un-ciclo-cd0124:ROW - 3.5
               COL               = wh-i-un-ciclo-cd0124:COL + 35
               LABEL             = "Ativo"
               HEIGHT            = 0.88
               WIDTH             = 8
               VISIBLE           = YES
               SENSITIVE         = NO.  
         IF VALID-HANDLE(wh-cod-ferramen-cd0124) THEN
            wh-ativo-cd0124:MOVE-AFTER-TAB(wh-cod-ferramen-cd0124).  
         CREATE TEXT wh-txt-manut-cd0124
         ASSIGN FRAME        = wh-i-un-ciclo-cd0124:FRAME                            
                FORMAT       = "x(20)"                             
                WIDTH        = 11                                
                SCREEN-VALUE = "Data Ult.Manut:"                         
                ROW          = wh-i-un-ciclo-cd0124:ROW + 0.2                            
                COL          = wh-i-un-ciclo-cd0124:COL + wh-i-un-ciclo-cd0124:WIDTH + 4.2
                VISIBLE      = TRUE.
         CREATE FILL-IN wh-data-ult-manut-cd0124
         ASSIGN FRAME             = wh-i-un-ciclo-cd0124:FRAME    
                SIDE-LABEL-HANDLE = wh-txt-manut-cd0124        
                DATA-TYPE         = "date"                     
                FORMAT            = "99/99/9999"                   
                HEIGHT            = wh-i-un-ciclo-cd0124:HEIGHT
                WIDTH             = 12
                ROW               = wh-i-un-ciclo-cd0124:ROW                        
                COL               = wh-txt-manut-cd0124:COL + wh-txt-manut-cd0124:WIDTH + 0.3                          
                VISIBLE           = TRUE
                SENSITIVE         = NO.
         wh-data-ult-manut-cd0124:MOVE-AFTER-TAB(wh-i-un-ciclo-cd0124).  
         CREATE TEXT wh-txt-dispon-cd0124
         ASSIGN FRAME        = wh-i-un-ciclo-cd0124:FRAME                            
                FORMAT       = "x(20)"                             
                WIDTH        = 11                                
                SCREEN-VALUE = "Qtde Disponivel:"                         
                ROW          = wh-i-un-ciclo-cd0124:ROW + 0.2                            
                COL          = wh-data-ult-manut-cd0124:COL + wh-data-ult-manut-cd0124:WIDTH + 1.9
                VISIBLE      = TRUE.
         CREATE FILL-IN wh-qtde-dispon-cd0124
         ASSIGN FRAME             = wh-i-un-ciclo-cd0124:FRAME    
                SIDE-LABEL-HANDLE = wh-txt-dispon-cd0124        
                DATA-TYPE         = "integer"                     
                FORMAT            = ">>>>>>>9"                   
                HEIGHT            = wh-i-un-ciclo-cd0124:HEIGHT
                WIDTH             = 10
                ROW               = wh-i-un-ciclo-cd0124:ROW                        
                COL               = wh-txt-dispon-cd0124:COL + wh-txt-dispon-cd0124:WIDTH + 0.3                          
                VISIBLE           = TRUE
                SENSITIVE         = NO.
         wh-qtde-dispon-cd0124:MOVE-AFTER-TAB(wh-data-ult-manut-cd0124).  
      END.  
      RUN busca-handle(INPUT 'it-codigo',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).
      IF VALID-HANDLE(wh-objeto) THEN DO:
         wh-it-codigo-cd0124 = wh-objeto:HANDLE.
         wh-it-codigo-cd0124:VISIBLE   = NO.
         wh-it-codigo-cd0124:SENSITIVE = NO.
/*          CREATE TEXT wh-txt-IDTooling-cd0124                                                      */
/*          ASSIGN FRAME        = wh-it-codigo-cd0124:FRAME                                          */
/*                 FORMAT       = "x(12)"                                                            */
/*                 WIDTH        = 7.2                                                                */
/*                 SCREEN-VALUE = "IDTooling:"                                                       */
/*                 ROW          = wh-it-codigo-cd0124:ROW + 0.2                                      */
/*                 COL          = wh-it-codigo-cd0124:COL - 7.2                                      */
/*                 VISIBLE      = TRUE.                                                              */
/*          CREATE FILL-IN wh-IDTooling-cd0124                                                       */
/*          ASSIGN FRAME             = wh-it-codigo-cd0124:FRAME                                     */
/*                 SIDE-LABEL-HANDLE = wh-txt-IDTooling-cd0124                                       */
/*                 DATA-TYPE         = "character"                                                   */
/*                 FORMAT            = "x(30)"                                                       */
/*                 HEIGHT            = wh-it-codigo-cd0124:HEIGHT                                    */
/*                 WIDTH             = 9                                                             */
/*                 ROW               = wh-it-codigo-cd0124:ROW                                       */
/*                 COL               = wh-it-codigo-cd0124:COL                                       */
/*                 VISIBLE           = TRUE                                                          */
/*                 SENSITIVE         = NO.                                                           */
/*          CREATE TEXT wh-txt-atualiz-cd0124                                                        */
/*          ASSIGN FRAME        = wh-it-codigo-cd0124:FRAME                                          */
/*                 FORMAT       = "x(20)"                                                            */
/*                 WIDTH        = 9.8                                                                */
/*                 SCREEN-VALUE = "Dt Integr.MES:"                                                   */
/*                 ROW          = wh-txt-IDTooling-cd0124:ROW                                        */
/*                 COL          = 37.7                                                               */
/*                 VISIBLE      = TRUE.                                                              */
/*          CREATE FILL-IN wh-data-atualiz-cd0124                                                    */
/*          ASSIGN FRAME             = wh-it-codigo-cd0124:FRAME                                     */
/*                 SIDE-LABEL-HANDLE = wh-txt-atualiz-cd0124                                         */
/*                 DATA-TYPE         = "character"                                                   */
/*                 FORMAT            = 'x(30)'                                                       */
/*                 HEIGHT            = wh-IDTooling-cd0124:HEIGHT                                    */
/*                 WIDTH             = 17                                                            */
/*                 ROW               = wh-IDTooling-cd0124:ROW                                       */
/*                 COL               = wh-txt-atualiz-cd0124:COL + wh-txt-atualiz-cd0124:WIDTH + 0.8 */
/*                 VISIBLE           = TRUE                                                          */
/*                 SENSITIVE         = NO.                                                           */
         
         CREATE TEXT wh-txt-nr-up-hora-cd0124
         ASSIGN FRAME        = wh-it-codigo-cd0124:FRAME                            
                FORMAT       = "x(12)"                             
                WIDTH        = 10                           
                SCREEN-VALUE = "Num UP/Hora:"                         
                ROW          = wh-it-codigo-cd0124:row + 0.15                     
                COL          = wh-it-codigo-cd0124:COL - 10.4
                VISIBLE      = TRUE.

         CREATE FILL-IN wh-nr-up-hora-cd0124
         ASSIGN FRAME             = wh-it-codigo-cd0124:FRAME  
                SIDE-LABEL-HANDLE = wh-txt-nr-up-hora-cd0124      
                DATA-TYPE         = "decimal"  
                FORMAT            = '>,>>>,>>9.99'
                HEIGHT            = wh-it-codigo-cd0124:height
                WIDTH             = 11
                ROW               = wh-it-codigo-cd0124:row                       
                COL               = wh-it-codigo-cd0124:col
                VISIBLE           = TRUE
                SENSITIVE         = NO.

      END.  
      RUN busca-handle(INPUT 'c-it-codigo',
                       INPUT  p-wgh-frame,
                       OUTPUT wh-objeto).
      IF VALID-HANDLE(wh-objeto) THEN DO:
         wh-c-desc-cd0124  = wh-objeto:HANDLE.
         wh-c-desc-cd0124:VISIBLE   = NO.
         wh-c-desc-cd0124:SENSITIVE = NO.
      END. 

      CREATE COMBO-BOX wh-combo
      ASSIGN FRAME        = p-wgh-frame
             DATA-TYPE    = "CHARACTER"
             FORMAT       = "x(20)"
             WIDTH        = 20
             ROW          = 1.15
             COL          = 68 
             HIDDEN       = NO 
             INNER-LINES  = 10
             SENSITIVE    = YES
             VISIBLE      = YES.
             //LIST-ITEMS   = "...,Ferramenta, Dispositivo, M∆o de Obra".

      RUN esp/es0018p.p (INPUT "cd0124", /* Nome do programa */
                         INPUT 2,        /* Ponto do programa */
                         INPUT 0,
                         INPUT "",
                         OUTPUT TABLE tt-prog-ponto).
        
        wh-combo:LIST-ITEMS = "".
        wh-combo:ADD-LAST("...").
        FOR EACH tt-prog-ponto:
            wh-combo:ADD-LAST(tt-prog-ponto.conteudo).
        END. 

       
      ON VALUE-CHANGED of wh-combo persistent run upc/cd0124-upc01.p (INPUT wh-combo,
                                                                      input wh-i-un-ciclo-cd0124,
                                                                      input wh-data-ult-manut-cd0124).
     
   END.
END.
IF VALID-HANDLE(wh-i-un-ciclo-cd0124) THEN /* antes do after-enable */
    ASSIGN wh-i-un-ciclo-cd0124:HIDDEN = NO.
IF VALID-HANDLE(wh-data-ult-manut-cd0124) THEN /* antes do after-enable */
    ASSIGN wh-data-ult-manut-cd0124:HIDDEN = NO.
IF VALID-HANDLE(wh-txt-manut-cd0124) THEN
   ASSIGN wh-txt-manut-cd0124:SCREEN-VALUE = "Data Ult.Manut:". 
IF VALID-HANDLE(wh-txt-dispon-cd0124) THEN
   ASSIGN wh-txt-dispon-cd0124:SCREEN-VALUE = "Qtde Disponivel:". 
/* IF VALID-HANDLE(wh-txt-IDTooling-cd0124) THEN                    */
/*    ASSIGN wh-txt-IDTooling-cd0124:SCREEN-VALUE = "IDTooling:".   */
/* IF VALID-HANDLE(wh-txt-atualiz-cd0124) THEN                      */
/*    ASSIGN wh-txt-atualiz-cd0124:SCREEN-VALUE = "Dt Integr.MES:". */

IF p-ind-event  = "AFTER-ENABLE" AND 
   p-ind-object = "VIEWER"       THEN DO: 
   IF VALID-HANDLE(wh-data-ult-manut-cd0124) THEN
       ASSIGN wh-data-ult-manut-cd0124:SENSITIVE = YES.
   IF VALID-HANDLE(wh-qtde-dispon-cd0124) THEN
      ASSIGN wh-qtde-dispon-cd0124:SENSITIVE = YES.  
   IF VALID-HANDLE(wh-ativo-cd0124) THEN 
      ASSIGN wh-ativo-cd0124:SENSITIVE = YES.  
   IF VALID-HANDLE(wh-combo) THEN DO:
      ASSIGN wh-combo:SENSITIVE = YES.      
      APPLY 'value-changed' TO wh-combo.
   END.
END.
IF p-ind-event  = "AFTER-DISABLE" AND 
   p-ind-object = "VIEWER"        THEN DO:
   IF VALID-HANDLE(wh-data-ult-manut-cd0124) THEN
      ASSIGN wh-data-ult-manut-cd0124:SENSITIVE = NO.
   IF VALID-HANDLE(wh-qtde-dispon-cd0124) THEN
      ASSIGN wh-qtde-dispon-cd0124:SENSITIVE = NO.
   IF VALID-HANDLE(wh-ativo-cd0124) THEN 
      ASSIGN wh-ativo-cd0124:SENSITIVE = NO.  
   IF VALID-HANDLE(wh-combo) THEN 
      ASSIGN wh-combo:SENSITIVE = NO.
END.
IF p-ind-event  = "ADD"     AND 
   p-ind-object = "VIEWER"  THEN DO:
   IF VALID-HANDLE(wh-ativo-cd0124) THEN 
      ASSIGN wh-ativo-cd0124:CHECKED = YES.
   IF VALID-HANDLE(wh-combo)
   THEN DO:
        ASSIGN wh-combo:SCREEN-VALUE = "...".  
        APPLY 'value-changed' TO wh-combo.
   END.
END.
IF p-ind-event  = "AFTER-VALIDATE" AND 
   p-ind-object = "VIEWER"         THEN DO:
   IF VALID-HANDLE(wh-data-ult-manut-cd0124) THEN DO:
      IF valid-handle(wh-combo)
      AND wh-combo:SCREEN-VALUE = "Ferramenta" OR wh-combo:SCREEN-VALUE = "Equipamento tipo P"
      then if wh-data-ult-manut-cd0124:screen-value = ""
           or date(wh-data-ult-manut-cd0124:screen-value) = ?
           THEN DO:
              MESSAGE 'Data Èltima Manutená∆o deve ser informada'
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              APPLY 'ENTRY' TO wh-data-ult-manut-cd0124.
              RETURN 'NOK'.
           END. 

      IF DATE(wh-data-ult-manut-cd0124:SCREEN-VALUE) > TODAY THEN DO:
         MESSAGE 'Data Ult. Manutená∆o deve ser inferior ou igual ao dia corrente'
             VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         APPLY 'ENTRY' TO wh-data-ult-manut-cd0124.
         RETURN 'NOK'.
      END.
   END.

   if  valid-handle(wh-combo)
   and (wh-combo:screen-value = ""
   or   wh-combo:screen-value = "...")
   then do:
        run utp/ut-msgs.p (input "show":U, input 17567, input "Tipo da Ferramenta deve ser informado (Ferramenta, Dispositivo ou M∆o de Obra)").
        apply 'entry' to wh-combo.
        return 'NOK'.        
   end.
END.

IF p-ind-event  = "ASSIGN"  AND 
   p-ind-object = "VIEWER"  THEN DO:

   IF VALID-HANDLE(wh-data-ult-manut-cd0124) AND 
      VALID-HANDLE(wh-qtde-dispon-cd0124)    AND 
      VALID-HANDLE(wh-ativo-cd0124)          AND 
      VALID-HANDLE(wh-combo)                 THEN DO:

      FIND ferr-prod WHERE ROWID(ferr-prod) = p-row-table EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL ferr-prod THEN DO:
         ASSIGN ferr-prod.un-ciclo = INT(wh-i-un-ciclo-cd0124:SCREEN-VALUE) 
                ferr-prod.data-2   = DATE(wh-data-ult-manut-cd0124:SCREEN-VALUE) 
                ferr-prod.int-2    = INT(wh-qtde-dispon-cd0124    :SCREEN-VALUE)
                ferr-prod.log-2    = LOGICAL(wh-ativo-cd0124      :SCREEN-VALUE)
                ferr-prod.char-1   = trim(wh-combo:SCREEN-VALUE).

         run get-attribute in p-wgh-object ('adm-new-record').

         IF RETURN-VALUE = 'YES'
         THEN RUN pi-envia-mail.
         /*
         IF ferr-prod.char-1 = "Ferramenta" THEN DO:
             RUN esapi\esapi032.p (INPUT 'update',
                                   INPUT ferr-prod.cod-ferr-prod,
                                   OUTPUT c-result).
             IF SUBSTRING(c-result,1,2) = '20' THEN
                MESSAGE 'Integrado ao MES com Sucesso'
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             ELSE
                MESSAGE 'Erro na integracao ' SKIP(1)  c-result
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             IF VALID-HANDLE(wh-txt-IDTooling-cd0124) AND
                VALID-HANDLE(wh-data-atualiz-cd0124)  THEN DO:
                FIND FIRST es-api-log
                     WHERE es-api-log.id-aplicacao   = 'MES'
                       AND es-api-log.id-URI         = 'integraFerramMES'
                       AND es-api-log.id-codigo      = ferr-prod.cod-ferr-prod
                EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL es-api-log THEN
                   ASSIGN wh-IDTooling-cd0124   :SCREEN-VALUE = es-api-log.aux
                          wh-data-atualiz-cd0124:SCREEN-VALUE = ENTRY(1,STRING(es-api-log.dh-request)).
             END.
         END.
         */
      END.
      
   END.                                                                         
END.
IF p-ind-event  = "DELETE"  AND 
   p-ind-object = "VIEWER"  THEN DO:
   FOR FIRST ferr-prod 
       WHERE ROWID(ferr-prod) = p-row-table
             NO-LOCK: END.

   IF  AVAIL ferr-prod
   AND CAN-FIND(FIRST int-gm-recurso USE-INDEX index2 WHERE
                      int-gm-recurso.cod-ferr-prod = ferr-prod.cod-ferr-prod
                      NO-LOCK)
   THEN DO:
        MESSAGE 'Ferramenta est† relacionada a Grupo M†quina (escdp111), e n∆o pode ser eliminada!'
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN 'NOK'.
   END.

/*    IF VALID-HANDLE(wh-data-ult-manut-cd0124) AND                                  */
/*       VALID-HANDLE(wh-qtde-dispon-cd0124)    AND                                  */
/*       VALID-HANDLE(wh-ativo-cd0124)          THEN DO:                             */
/* /*       FIND ferr-prod WHERE ROWID(ferr-prod) = p-row-table NO-LOCK NO-ERROR. */ */
/*       IF AVAIL ferr-prod                                                          */
/*       AND ferr-prod.char-1 = "Ferramenta" THEN DO:                                */
/*          RUN esapi\esapi032.p (INPUT 'delete',                                    */
/*                                INPUT ferr-prod.cod-ferr-prod,                     */
/*                                OUTPUT c-result).                                  */
/*          IF SUBSTRING(c-result,1,2) = '20' THEN                                   */
/*             MESSAGE 'Deletado com Sucesso'                                        */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                         */
/*          ELSE                                                                     */
/*             MESSAGE 'Erro ao Deletar no MES ' SKIP(1) c-result                    */
/*                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.                               */
/*       END.                                                                        */
/*    END.                                                                           */
END.

IF p-ind-event  = "DISPLAY" AND 
   p-ind-object = "VIEWER"  THEN DO:
   IF VALID-HANDLE(wh-data-ult-manut-cd0124) AND 
      VALID-HANDLE(wh-qtde-dispon-cd0124)    AND 
      VALID-HANDLE(wh-ativo-cd0124)          AND 
      VALID-HANDLE(wh-combo)                 AND
      VALID-HANDLE(wh-nr-up-hora-cd0124)     THEN DO:

      ASSIGN wh-data-ult-manut-cd0124:SCREEN-VALUE = ''
             wh-qtde-dispon-cd0124   :SCREEN-VALUE = ''
             wh-ativo-cd0124         :CHECKED      = NO
             wh-combo                :SENSITIVE    = NO
             wh-combo                :SCREEN-VALUE = "...". 
/*       IF VALID-HANDLE(wh-IDTooling-cd0124)    AND         */
/*          VALID-HANDLE(wh-data-atualiz-cd0124) THEN        */
/*          ASSIGN wh-IDTooling-cd0124   :SCREEN-VALUE = ''  */
/*                 wh-data-atualiz-cd0124:SCREEN-VALUE = ''. */
      FIND ferr-prod WHERE ROWID(ferr-prod) = p-row-table NO-LOCK NO-ERROR.
      IF AVAIL ferr-prod THEN DO:
         ASSIGN wh-data-ult-manut-cd0124:SCREEN-VALUE = STRING(ferr-prod.data-2)
                wh-qtde-dispon-cd0124   :SCREEN-VALUE = STRING(ferr-prod.int-2)
                wh-ativo-cd0124         :SCREEN-VALUE = STRING(ferr-prod.log-2).

         IF ferr-prod.char-1 = "Ferramenta" THEN DO:
         
             RUN esp/es0018p.p (INPUT "cd0124", /* Nome do programa */
                             INPUT 2,           /* Ponto do programa */
                             INPUT 0,
                             INPUT "",
                             OUTPUT TABLE tt-prog-ponto).

             FOR FIRST tt-prog-ponto:
                 wh-combo:SCREEN-VALUE = tt-prog-ponto.conteudo. 
             END.        
         END.
         ELSE
            wh-combo:SCREEN-VALUE = trim(ferr-prod.char-1). 

/*          IF VALID-HANDLE(wh-txt-IDTooling-cd0124) AND                                               */
/*             VALID-HANDLE(wh-data-atualiz-cd0124)  THEN DO:                                          */
/*             FIND FIRST es-api-log                                                                   */
/*                  WHERE es-api-log.id-aplicacao   = 'MES'                                            */
/*                    AND es-api-log.id-URI         = 'integraFerramMES'                               */
/*                    AND es-api-log.id-codigo      = ferr-prod.cod-ferr-prod                          */
/*             EXCLUSIVE-LOCK NO-ERROR.                                                                */
/*             IF AVAIL es-api-log THEN                                                                */
/*                ASSIGN wh-IDTooling-cd0124   :SCREEN-VALUE = es-api-log.aux                          */
/*                       wh-data-atualiz-cd0124:SCREEN-VALUE = ENTRY(1,STRING(es-api-log.dh-request)). */
/*          END.                                                                                       */

         FIND FIRST es-ferr-prod
              WHERE es-ferr-prod.cod-ferr-prod = ferr-prod.cod-ferr-prod
                    NO-LOCK NO-ERROR.

         IF AVAIL es-ferr-prod 
         THEN ASSIGN wh-nr-up-hora-cd0124:SCREEN-VALUE = STRING(es-ferr-prod.nr-up-hora).

      END.
   END.                                                                         

END.
PROCEDURE busca-handle:
   DEF INPUT  PARAM p-nome     AS CHAR.
   DEF INPUT  PARAM p-frame    AS WIDGET-HANDLE.
   DEF OUTPUT PARAM p-object   AS WIDGET-HANDLE.
   DEF VAR h-frame             AS WIDGET-HANDLE.
   DEF VAR wh-objeto           AS WIDGET-HANDLE.
   ASSIGN h-frame = p-frame:FIRST-CHILD.
   DO WHILE VALID-HANDLE(h-frame):
      IF h-frame:TYPE <> "field-group" THEN DO:
         IF h-frame:TYPE = 'literal' AND 
            h-frame:SCREEN-VALUE = 'Unidades Ciclo' THEN DO:
            ASSIGN h-frame:SCREEN-VALUE = 'Horas Manutená∆o'.
         END. 
         IF h-frame:NAME = p-nome THEN DO:
             /*MESSAGE 'achou ' SKIP h-frame:NAME
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
             ASSIGN p-object = h-frame.
             LEAVE.
         END.
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE
          ASSIGN h-frame = h-frame:FIRST-CHILD.
   END.
END PROCEDURE.

PROCEDURE pi-envia-mail:
    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.
    DEF VAR c-emails      AS CHAR NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    RUN esp/es0018p.p (INPUT  "CD0124":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN c-emails = "".

    FOR EACH tt-prog-ponto:
        ASSIGN c-emails = c-emails + tt-prog-ponto.conteudo + ",".
    END.

    IF c-emails <> "" 
    THEN DO:
       RUN utp/utapi019.p PERSISTENT SET h-utapi019.
       
       FOR EACH tt-envio2.   DELETE tt-envio2.   END.
       FOR EACH tt-mensagem. DELETE tt-mensagem. END.
       
       CREATE tt-envio2.
       ASSIGN tt-envio2.versao-integracao = 1
              tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
              tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
              tt-envio2.destino           = c-emails                             /* Destinat†rio       */ 
              tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
              tt-envio2.assunto           = "Implantaá∆o Recurso Secund†rio " + TRIM(ferr-prod.cod-ferr-prod) /* Assunto            */
              tt-envio2.formato           = "TEXTO".
       
       FIND usuar_mestre WHERE
            usuar_mestre.cod_usuario = c-seg-usuario 
            NO-LOCK NO-ERROR.
       ASSIGN c-corpo-email = "Implantaá∆o Recurso Secund†rio: " 
                            + TRIM(ferr-prod.cod-ferr-prod)
                            + chr(13)
                            + "Tipo: "
                            + trim(ferr-prod.char-1)
                            + CHR(13)
                            + "Usuario: " 
                            + c-seg-usuario
                            + " - "
                            + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".
       
       CREATE tt-mensagem.
       ASSIGN tt-mensagem.seq-mensagem = 1
              tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */
       
       RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                      INPUT  TABLE tt-mensagem,
                                      OUTPUT TABLE tt-erros).
       
       IF VALID-HANDLE(h-utapi019) THEN
           DELETE PROCEDURE h-utapi019.
    END.

    RETURN "OK".
END.

