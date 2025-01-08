/***********************************************************************
**  Programa..: upc/cd0704b-upc.p
**  Autor.....: Raphael Paini
**  Data......: 03/11/2009 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 03/11/2009
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR l-ok       AS LOGICAL  NO-UNDO.

DEFINE VARIABLE h-object AS HANDLE   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE   NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-button-upc-cd1107   AS WIDGET-HANDLE NO-UNDO.

define new global shared var wh-email-cd0704b    as widget-handle no-undo.
/* define new global shared VAR wh-telefone-cd0704b as widget-handle no-undo. */
/* define new global shared VAR wh-telefax-cd0704b  as widget-handle no-undo. */
define new global shared VAR wh-cb-area-cd0704b   as widget-handle no-undo.
define new global shared VAR wh-cb-cargo-cd0704b   as widget-handle no-undo.
define new global shared VAR wh-area-cd0704b       as widget-handle no-undo.
define new global shared VAR wh-cargo-cd0704b       as widget-handle no-undo.


DEF NEW GLOBAL SHARED VARIABLE r-row-id-item     AS ROWID NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").


/*   MESSAGE "Evento " p-ind-event  SKIP        */
/*           "Objeto " p-ind-object SKIP        */
/*           "Tabela " p-cod-table  SKIP        */
/*           "Rowid  " STRING(p-row-table) SKIP */
/*           "Objeto " c-objeto     SKIP        */
/*           VIEW-AS ALERT-BOX INFO BUTTONS OK. */



IF p-ind-object = "VIEWER"         AND
   c-objeto     = "cd0704b-v01.w"  THEN DO:

  ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
  IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
      RUN tela-upc (INPUT p-wgh-frame,
                    INPUT p-ind-Event,
                    INPUT "fill-in",     /*** Type ***/
                    INPUT "e-mail",         /*** Name ***/
                    INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                    INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                    OUTPUT wh-email-cd0704b).

      IF VALID-HANDLE(wh-email-cd0704b) THEN DO:
          ASSIGN wh-email-cd0704b:FORMAT = "x(80)"
                 wh-email-cd0704b:WIDTH  = 60.
      END.

/*                                                                                                      */
/*       RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                     INPUT p-ind-Event,                                                               */
/*                     INPUT "fill-in",     /*** Type ***/                                              */
/*                     INPUT "telefone",         /*** Name ***/                                         */
/*                     INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                     INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                     OUTPUT wh-telefone-cd0704b).                                                     */
/*                                                                                                      */
/*                                                                                                      */
/*                                                                                                      */
/*       IF VALID-HANDLE(wh-telefone-cd0704b) THEN DO:                                                  */
/*           ASSIGN wh-telefone-cd0704b:FORMAT = "(XX) XXXX-XXXX".                                      */
/*       END.                                                                                           */
/*                                                                                                      */
/*       RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                     INPUT p-ind-Event,                                                               */
/*                     INPUT "fill-in",     /*** Type ***/                                              */
/*                     INPUT "telefax",         /*** Name ***/                                          */
/*                     INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                     INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                     OUTPUT wh-telefax-cd0704b).                                                      */
/*                                                                                                      */
/*       IF VALID-HANDLE(wh-telefax-cd0704b) THEN DO:                                                   */
/*           ASSIGN wh-telefax-cd0704b:FORMAT = "(XX) XXXX-XXXX".                                       */
/*       END.                                                                                           */

      RUN tela-upc (INPUT p-wgh-frame,
                    INPUT p-ind-Event,
                    INPUT "fill-in",     /*** Type ***/
                    INPUT "area",         /*** Name ***/
                    INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                    INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                    OUTPUT wh-area-cd0704b).

      RUN tela-upc (INPUT p-wgh-frame,
                    INPUT p-ind-Event,
                    INPUT "fill-in",     /*** Type ***/
                    INPUT "cargo",         /*** Name ***/
                    INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                    INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                    OUTPUT wh-cargo-cd0704b).

    create combo-box wh-cb-area-cd0704b
    assign frame       = p-wgh-frame
           data-type   = "character"
           format      = "x(25)"
           width       = 26 
           row         = 04.94
           col         = 22 
           HIDDEN      = no
           inner-lines = 4
           sensitive   = YES
           VISIBLE     = YES
           list-item-pairs = "Administrativa,Administrativa,Assistencia Tecnica,Assistencia Tecnica,Comercial,Comercial,Comercio Exterior,Comercio Exterior,
                              Compras,Compras,Controladoria,Controladoria,Finaceira,Finaceira,Informatica,Informatica,Logistica,Logistica,Marketing,Marketing,
                              P&D,P&D,Producao,Producao,Qualidade,Qualidade,Recebimento,Recebimento,Relacionamento ao Cliente,Relacionamento ao Cliente,A Classificar,A Classificar".   

       ASSIGN wh-cb-area-cd0704b:SENSITIVE = NO.


    create combo-box wh-cb-cargo-cd0704b
    assign frame       = p-wgh-frame
           data-type   = "character"
           format      = "x(25)"
           width       = 26 
           row         = 05.94
           col         = 22 
           HIDDEN      = no
           inner-lines = 4
           sensitive   = YES
           VISIBLE     = YES
           list-item-pairs = "A Classificar,A Classificar,Administrador,Administrador,Analista,Analista,Assistente,Assistente,Atendente,Atendente,
                              Auxiliar de Producao,Auxiliar de Producao,Comprador,Comprador,Consultor,Consultor,Contador,Contador,Coordenador,Coordenador,
                              Diretor,Diretor,Engenheiro,Engenheiro,Gerente,Gerente,Presidente,Presidente,Promotor,Promotor,Proprietario / Socio,Proprietario / Socio,
                              Representante,Representante,Secretaria,Secretaria,Supervisor,Supervisor,Tecnico,Tecnico,Vendedor,Vendedor,Vice Presidente,Vice Presidente".   

       ASSIGN wh-cb-cargo-cd0704b:SENSITIVE = NO.
  END.
END.

IF p-ind-event = "ENABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-cb-area-cd0704b:SENSITIVE = YES
          wh-cb-cargo-cd0704b:SENSITIVE = yes.
END.
IF p-ind-event = "DISABLE" AND 
   p-ind-object = "VIEWER" THEN DO:
   ASSIGN wh-cb-area-cd0704b:SENSITIVE = NO
          wh-cb-cargo-cd0704b:SENSITIVE = NO.
END.

IF p-ind-event = "DISPLAY" AND 
   p-ind-object = "VIEWER" THEN DO:
    
    ASSIGN wh-cb-area-cd0704b:SCREEN-VALUE = wh-area-cd0704b:SCREEN-VALUE
           wh-cb-cargo-cd0704b:SCREEN-VALUE = wh-cargo-cd0704b:SCREEN-VALUE.
END.


IF p-ind-event = "BEFORE-ASSIGN" AND 
   p-ind-object = "VIEWER" THEN DO:
    
   
  ASSIGN wh-area-cd0704b:SCREEN-VALUE = wh-cb-area-cd0704b:SCREEN-VALUE
         wh-cargo-cd0704b:SCREEN-VALUE = wh-cb-cargo-cd0704b:SCREEN-VALUE.
END.

IF p-ind-event  = "VALIDATE"              AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "cd0704b-v01.w"  THEN DO:


/*    IF wh-telefone-cd0704b:SCREEN-VALUE <> "(  )     -    " THEN DO:                                                                   */
/*        IF (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,2,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,3,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,6,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,7,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,8,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,9,1) > "9") or         */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,11,1) > "9") or       */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,12,1) > "9") or       */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,13,1) > "9") or       */
/*           (SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telefone-cd0704b:SCREEN-VALUE,14,1) > "9") THEN DO: */
/*            MESSAGE "INFORME O TELEFONE 1 CORRETAMENTE"                                                                                */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                     */
/*            RETURN "NOK":U.                                                                                                            */
/*        END.                                                                                                                           */
/*    END.                                                                                                                               */
/*    IF wh-telefax-cd0704b:SCREEN-VALUE <> "(  )     -    " THEN DO:                                                                    */
/*        IF (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,2,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,3,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,6,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,7,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,8,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,9,1) > "9") or           */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,11,1) > "9") or         */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,12,1) > "9") or         */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,13,1) > "9") or         */
/*           (SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telefax-cd0704b:SCREEN-VALUE,14,1) > "9") THEN DO:   */
/*            MESSAGE "INFORME O TELEFAX 1 CORRETAMENTE"                                                                                 */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                     */
/*            RETURN "NOK":U.                                                                                                            */
/*        END.                                                                                                                           */
/*    END.                                                                                                                               */

END.
PROCEDURE tela-upc:
  DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
  DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
  DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
  DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
  DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
  DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

  DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

  ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
         i-aux   = 0.

  DO WHILE VALID-HANDLE(wgh-obj):                                

      IF pApresMsg = YES THEN                                    
          MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                  "Type do Objeto" wgh-obj:TYPE SKIP             
                  "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

      IF wgh-obj:TYPE = pObjType AND
         wgh-obj:NAME = pObjName THEN DO:
          ASSIGN phObj = wgh-obj:HANDLE
                 i-aux = i-aux + 1.

          IF i-aux = pAux THEN
              LEAVE.
      END.
      IF wgh-obj:TYPE = "field-group" THEN
          ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
      ELSE
          ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
  END.
END PROCEDURE.

