/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upc.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: Gravacao dos dados adicionais do cliente.
               Grava: emitente.bonificacao
                      emitente.cod-suframa
               Com esta UPC, nao e necessario acessar os programas CD0705 e
               CD1510 apos o cadastro do cliente para que o mesmo possa ter
               notas faturadas.
               Utilizei o ponto UPC "criacao-Endereco-Padrao-Entrega" para 
               gravar o indicador de credito do cliente. Este evento so e
               chamado depois que o registro foi cridao (e so na criacao de 
               novo registro).
---------------------------------------------------------------------------- */


/* Parameter Definitions ****************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.


DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR l-ok       AS LOGICAL  NO-UNDO.
DEF VAR l-resp     AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR resp       AS INT     NO-UNDO .

DEF VAR h-fpage1   AS HANDLE   NO-UNDO.
DEF VAR h-frame1   AS HANDLE   NO-UNDO.
DEF VAR h-fpage2   AS HANDLE   NO-UNDO.
DEF VAR h-frame2   AS HANDLE   NO-UNDO.

DEFINE BUFFER b-emitente FOR emitente.

/* Global Variable Definitions **********************************************/
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
define new global shared var adm-broker-hdl as handle no-undo.
define new global shared var h-folder       as handle no-undo.
define new global shared var h-viewer-1     as handle no-undo.
define new global shared var h-viewer-2     as handle no-undo.

define new global shared var wgh-folder     as handle no-undo.

define new global shared var whdata-implant            as widget-handle no-undo.
define new global shared var whNomeTransp              as widget-handle no-undo.
define new global shared variable h-programa           as handle        no-undo.
define new global shared variable wgh-window           as widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button-upc-cd0704 AS WIDGET-HANDLE NO-UNDO.
/* DEFINE NEW GLOBAL SHARED VARIABLE wh-telefone-cd0704   AS WIDGET-HANDLE NO-UNDO. */
/* DEFINE NEW GLOBAL SHARED VARIABLE wh-telefone2-cd0704  AS WIDGET-HANDLE NO-UNDO. */
/* DEFINE NEW GLOBAL SHARED VARIABLE wh-telefax-cd0704   AS WIDGET-HANDLE NO-UNDO.  */
/* DEFINE NEW GLOBAL SHARED VARIABLE wh-telef-fac-cd0704  AS WIDGET-HANDLE NO-UNDO. */

define new global shared var whInsEstadual     as widget-handle no-undo.
define new global shared var whInsEstadualCob  as widget-handle no-undo.
define new global shared var whContribIcms     as widget-handle no-undo.
define new global shared var whInsEstadualAnt  as widget-handle no-undo.
define new global shared var whContribIcmsAnt  as widget-handle no-undo.

define new global shared var wh-bt-socios-cd0704 as widget-handle no-undo.
define new global shared var whCodEmitente       as widget-handle no-undo.

define new global shared var whCodRota      as widget-handle no-undo.
define new global shared var whCidadeCif    as widget-handle no-undo.
define new global shared var whCodTransp    as widget-handle no-undo.
define new global shared var whDescTransp   as widget-handle no-undo.
define new global shared var whEstado       as widget-handle no-undo.
define new global shared var whEndereco     as widget-handle no-undo.
define new global shared var whEstadoLocal  as widget-handle no-undo.
define new global shared var whCidade       as widget-handle no-undo.
define new global shared var whPais         as widget-handle no-undo.
define new global shared var whTextEstado   as widget-handle no-undo.
define new global shared var whCep          as widget-handle no-undo.
define new global shared var whBairro       as widget-handle no-undo.
define new global shared var c-transp       as character no-undo.
define new global shared var c-rota         as character no-undo.
define new global shared var c-cidade-cif   as character no-undo.
define new global shared var l-assign       as logical   no-undo.
define new global shared var l-add          as logical   no-undo.

define new global shared var wb-btCopiar-cd0704    as widget-handle no-undo.
define new global shared var wb-btModificar-cd0704 as widget-handle no-undo.
define new global shared var wb-btDeletar-cd0704   as widget-handle no-undo.
define new global shared var wb-btHistorico-cd0704 as widget-handle no-undo.
define new global shared var wb-btContato-cd0704   as widget-handle no-undo.
define new global shared var wb-PanelFrame-cd0704  as widget-handle no-undo.

define new global shared var wh-objeto  as widget-handle no-undo.

define new global shared var wh-emitente-cd0704 as widget-handle no-undo.
define new global shared var wh-cgc-cd0704      as widget-handle no-undo.

define new global shared var wh-grupo-cd0704    as widget-handle no-undo.
define new global shared var wh-cgco-cd0704     as widget-handle no-undo.
define new global shared var wh-matriz-cd0704   as widget-handle no-undo.
define new global shared var wh-natureza-cd0704 as widget-handle no-undo.

define new global shared var wh-txt-ativo-cd0704   as widget-handle no-undo.
define new global shared var wh-ativo-cd0704       as widget-handle no-undo.
define new global shared var wh-txt-atualiz-cd0704 as widget-handle no-undo.
define new global shared var wh-dt-atualiz-cd0704  as widget-handle no-undo.
define new global shared var wh-bt-ativo-cd0704    as widget-handle no-undo.
define new global shared VAR wh-ins-banc1-cd0704   as widget-handle no-undo.
define new global shared VAR wh-ins-banc2-cd0704   as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-tg-forma-tributacao-cd0704 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-forma-tributacao-cd0704    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-forma-tributacao-cd0704    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-retangulo-cd0704           AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-cep-cd0704              AS WIDGET-HANDLE NO-UNDO.

define new global shared var wh-email-cd0704 as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR c-seg-usuario   AS   CHAR                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-motivo-cd0704 AS   CHAR                  NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-upc-cd0704           AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-cdapi704 AS HANDLE                   NO-UNDO.
DEFINE VARIABLE c-rua      AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE c-nro      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-comp     AS CHARACTER FORMAT "x(80)" NO-UNDO.
/* Variable Definitions *****************************************************/
define var c-folder         as character     no-undo.
define var c-objects        as character     no-undo.
define var h-object         as handle        no-undo.
define var i-objects        as integer       no-undo.
define var l-record-1       as logical       no-undo initial no.
define var l-group-assign-1 as logical       no-undo initial no.
define var l-state-1        as logical       no-undo initial no.
define var l-record-2       as logical       no-undo initial no.
define var l-group-assign-2 as logical       no-undo initial no.
define var l-state-2        as logical       no-undo initial no.
define var h-frame          as widget-handle no-undo. 
define var c-transp         as character     no-undo.
define var c-rota           as character     no-undo.
define var c-cidade-cif     as character     no-undo.
define var l-assign         as logical       no-undo.

DEFINE VARIABLE adm-current-page AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cgc            AS CHARACTER   NO-UNDO.
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
 
assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/* MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK. */

{esp/es0018.i}

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0704-upc.p PERSISTENT SET h-upc-cd0704(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-upc-cd0704) THEN
        DELETE PROCEDURE h-upc-cd0704.

IF p-ind-event  = "display" AND 
   p-ind-object = "VIEWER"     AND 
   c-objeto     = "'advwr\v27ad098.w'" THEN DO:

    FIND FIRST emitente NO-LOCK
        WHERE ROWID(emitente) = p-row-table NO-ERROR.
    IF AVAIL emitente THEN DO:

        RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        IF emitente.cod-gr-cli = 4 AND 
           NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                        WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                          AND tt-prog-ponto.ponto         = 1
                          AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
            /*caso seja grupo 4 e usuario nao esteja cadastrado no es0018 - programa cd0704-upc - s¢ deixa fazer inclusao, nao pode alterar esse registro*/
            IF VALID-HANDLE(wb-btCopiar-cd0704)     THEN ASSIGN wb-btCopiar-cd0704:SENSITIVE    = NO.
            IF VALID-HANDLE(wb-btModificar-cd0704)  THEN ASSIGN wb-btModificar-cd0704:SENSITIVE = NO.
            IF VALID-HANDLE(wb-btDeletar-cd0704)    THEN ASSIGN wb-btDeletar-cd0704:SENSITIVE   = NO.
            IF VALID-HANDLE(wb-btHistorico-cd0704)  THEN ASSIGN wb-btHistorico-cd0704:SENSITIVE = NO.
            IF VALID-HANDLE(wb-btContato-cd0704)    THEN ASSIGN wb-btContato-cd0704:SENSITIVE   = NO.
            IF VALID-HANDLE(wh-button-upc-cd0704)   THEN ASSIGN wh-button-upc-cd0704:SENSITIVE  = NO.
        END.
        ELSE DO:
            IF VALID-HANDLE(wb-btCopiar-cd0704)     THEN ASSIGN wb-btCopiar-cd0704:SENSITIVE    = YES.
            IF VALID-HANDLE(wb-btModificar-cd0704)  THEN ASSIGN wb-btModificar-cd0704:SENSITIVE = YES.
            IF VALID-HANDLE(wb-btDeletar-cd0704)    THEN ASSIGN wb-btDeletar-cd0704:SENSITIVE   = YES.
            IF VALID-HANDLE(wb-btHistorico-cd0704)  THEN ASSIGN wb-btHistorico-cd0704:SENSITIVE = YES.
            IF VALID-HANDLE(wb-btContato-cd0704)    THEN ASSIGN wb-btContato-cd0704:SENSITIVE   = YES.
            IF VALID-HANDLE(wh-button-upc-cd0704)   THEN ASSIGN wh-button-upc-cd0704:SENSITIVE  = YES.
        END.
    END.
END.

IF p-ind-object = "VIEWER"              AND 
   c-objeto     = "'advwr\v29ad098.w'"  AND 
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    
  ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
  RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "fill-in",     /*** Type ***/
                INPUT "e-mail",         /*** Name ***/
                INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                OUTPUT wh-email-cd0704).

  IF VALID-HANDLE(wh-email-cd0704) THEN DO:
      ASSIGN wh-email-cd0704:FORMAT = "x(80)"
             wh-email-cd0704:WIDTH  = 50.
  END.


/*   RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                 INPUT p-ind-Event,                                                               */
/*                 INPUT "fill-in",     /*** Type ***/                                              */
/*                 INPUT "telefone",         /*** Name ***/                                         */
/*                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                 INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                 OUTPUT wh-telefone-cd0704).                                                      */
/*                                                                                                  */
/*   IF VALID-HANDLE(wh-telefone-cd0704) THEN DO:                                                   */
/*       ASSIGN wh-telefone-cd0704:FORMAT = "(XX) XXXX-XXXX".                                       */
/*   END.                                                                                           */
/*   RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                 INPUT p-ind-Event,                                                               */
/*                 INPUT "fill-in",     /*** Type ***/                                              */
/*                 INPUT "telefone",         /*** Name ***/                                         */
/*                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                 INPUT 2,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                 OUTPUT wh-telefone2-cd0704).                                                     */
/*                                                                                                  */
/*   IF VALID-HANDLE(wh-telefone2-cd0704) THEN DO:                                                  */
/*       ASSIGN wh-telefone2-cd0704:FORMAT = "(XX) XXXX-XXXX".                                      */
/*   END.                                                                                           */
/*                                                                                                  */
/*   RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                 INPUT p-ind-Event,                                                               */
/*                 INPUT "fill-in",     /*** Type ***/                                              */
/*                 INPUT "telefax",         /*** Name ***/                                          */
/*                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                 INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                 OUTPUT wh-telefax-cd0704).                                                       */
/*                                                                                                  */
/*   IF VALID-HANDLE(wh-telefax-cd0704) THEN DO:                                                    */
/*       ASSIGN wh-telefax-cd0704:FORMAT = "(XX) XXXX-XXXX".                                        */
/*   END.                                                                                           */
/*                                                                                                  */
/*   RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                 INPUT p-ind-Event,                                                               */
/*                 INPUT "fill-in",     /*** Type ***/                                              */
/*                 INPUT "telef-fac",         /*** Name ***/                                        */
/*                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                 INPUT 2,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                 OUTPUT wh-telef-fac-cd0704).                                                     */
/*                                                                                                  */
/*   IF VALID-HANDLE(wh-telef-fac-cd0704) THEN DO:                                                  */
/*       ASSIGN wh-telef-fac-cd0704:FORMAT = "(XX) XXXX-XXXX".                                      */
/*   END.                                                                                           */

END.


/*
IF p-ind-event  = "ASSIGN"              AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v29ad098.w'"  THEN DO:
   IF wh-telefone-cd0704:SCREEN-VALUE <> "(  )     -    " THEN DO:
       IF (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,2,1) > "9") or 
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,3,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,6,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,7,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,8,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,9,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,11,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,12,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,13,1) > "9") or
          (SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telefone-cd0704:SCREEN-VALUE,14,1) > "9") THEN DO:
           MESSAGE "INFORME O TELEFONE 1 CORRETAMENTE"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
       END.
   END.
   IF wh-telefone2-cd0704:SCREEN-VALUE <> "(  )     -    " THEN DO:
       IF (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,2,1) > "9") or 
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,3,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,6,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,7,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,8,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,9,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,11,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,12,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,13,1) > "9") or
          (SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telefone2-cd0704:SCREEN-VALUE,14,1) > "9") THEN DO:
           MESSAGE "INFORME O TELEFONE 2 CORRETAMENTE"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
       END.
   END.
   IF wh-telefax-cd0704:SCREEN-VALUE <> "(  )     -    " THEN DO:
       IF (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,2,1) > "9") or 
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,3,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,6,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,7,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,8,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,9,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,11,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,12,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,13,1) > "9") or
          (SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telefax-cd0704:SCREEN-VALUE,14,1) > "9") THEN DO:
           MESSAGE "INFORME O TELEFAX 1 CORRETAMENTE"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
       END.
   END.
   IF wh-telef-fac-cd0704:SCREEN-VALUE <> "(  )     -    " THEN DO:
       IF (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,2,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,2,1) > "9") or 
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,3,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,3,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,6,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,6,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,7,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,7,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,8,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,8,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,9,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,9,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,11,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,11,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,12,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,12,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,13,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,13,1) > "9") or
          (SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,14,1) < "0" OR SUBSTRING(wh-telef-fac-cd0704:SCREEN-VALUE,14,1) > "9") THEN DO:
           MESSAGE "INFORME O TELEFAX 2 CORRETAMENTE"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
       END.
   END.

END.*/

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    create button wh-button-upc-cd0704  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.25       
           col       = 65.32       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             ON CHOOSE PERSISTENT RUN pi-cd0704a-upc IN h-upc-cd0704.
           end triggers.
  
    if wh-button-upc-cd0704:load-image("image/gr-lay.bmp") then.

    /*botao historico*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",       /*** Type ***/
                  INPUT "bt-historico", /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-btHistorico-cd0704).


    /*bota contato*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",       /*** Type ***/
                  INPUT "bt-contato", /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-btContato-cd0704).

    /*frame cadsim*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "panel-frame", /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 2,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-PanelFrame-cd0704).

    /*botao copiar*/
    run tela-upc (input wb-PanelFrame-cd0704,
                  input p-ind-event,
                  input 'button':U,
                  input 'bt-cop':U,
                  input NO,
                  INPUT 1,
                  output wb-btCopiar-cd0704).

    /*botao modificar*/
    run tela-upc (input wb-PanelFrame-cd0704,
                  input p-ind-event,
                  input 'button':U,
                  input 'bt-mod':U,
                  input NO,
                  INPUT 1,
                  output wb-btModificar-cd0704).
    /*botao deletar*/
    run tela-upc (input wb-PanelFrame-cd0704,
                  input p-ind-event,
                  input 'button':U,
                  input 'bt-del':U,
                  input NO,
                  INPUT 1,
                  output wb-btDeletar-cd0704).


end.

/******* ROTINA PARA TRATAMENTO DA INSCRIÄ«O ESTADUAL ******/
IF p-ind-event  = "DISPLAY"             AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v23ad098.w'"  THEN DO:
   ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
   DO WHILE h-frame <> ?:
      IF h-frame:TYPE <> "field-group" THEN DO:  
         CASE h-frame:NAME:
              WHEN "cod-emitente" THEN DO:
                   ASSIGN whCodEmitente = h-frame.
              END.
         END CASE.
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE DO:
         ASSIGN h-frame = h-frame:FIRST-CHILD.
      END.
   END.
END.

IF p-ind-event  = "ASSIGN"              AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v27ad098.w'"  THEN DO:
   ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
   DO WHILE h-frame <> ?:
      IF h-frame:TYPE <> "field-group" THEN DO:  
         CASE h-frame:NAME:
              WHEN "contrib-icms" THEN DO:
                   ASSIGN whContribIcms = h-frame.
              END.
              WHEN "ins-estadual" THEN DO:
                   ASSIGN whInsEstadual = h-frame.
              END.
         END CASE.
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE DO:
         ASSIGN h-frame = h-frame:FIRST-CHILD.
      END.
   END.

   IF whInsEstadual:SCREEN-VALUE = "isento" AND 
      whContribIcms:CHECKED                 THEN DO:
      MESSAGE "Cliente n∆o possui inscriá∆o estadual e esta marcado o campo Contribuinte ICMS. Confirma?"
               UPDATE l-resp 
               VIEW-AS ALERT-BOX 
               QUESTION BUTTONS YES-NO
               TITLE "Atualizaá∆o de dados".
      IF l-resp = NO THEN DO:
         APPLY 'entry' TO whInsEstadual.  
         RETURN "NOK".
      END.
   END.

   IF whInsEstadual:SCREEN-VALUE <> "isento" AND 
      NOT whContribIcms:CHECKED              THEN DO:
      MESSAGE "Cliente possui inscriá∆o estadual e n∆o esta marcado o campo Contribuinte ICMS. Confirma?"
               UPDATE l-resp 
               VIEW-AS ALERT-BOX 
               QUESTION BUTTONS YES-NO
               TITLE "Atualizaá∆o de dados".
      IF l-resp = NO THEN DO:
         APPLY 'entry' TO whInsEstadual.  
         RETURN "NOK".
      END.
   END.
END.

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v27ad098.w'"  THEN DO:

   ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
   DO WHILE h-frame <> ?:
      IF h-frame:TYPE <> "field-group" THEN DO:  
         CASE h-frame:NAME:
              WHEN "ins-estadual" THEN DO:
                  ASSIGN whInsEstadual = h-frame.
              END.
              WHEN "ins-est-cob" THEN DO:
                  ASSIGN whInsEstadualCob = h-frame.
              END.
         END CASE.
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE DO:
         ASSIGN h-frame = h-frame:FIRST-CHILD.
      END.
   END.
   IF VALID-HANDLE(whInsEstadual) AND VALID-HANDLE(whInsEstadualCob) THEN DO:
       ON 'LEAVE':U OF whInsEstadual PERSISTENT RUN upc\cd0704-leave.p.
   END.
      
END.


/******* FIM TRATAMENTO DA INSCRIÄ«O ESTADUAL********/
IF p-ind-event = "VALIDATE" OR
   p-ind-event = "END-UPDATE" THEN DO:
    FIND FIRST emitente NO-LOCK 
         WHERE ROWID(emitente) = p-row-table NO-ERROR.
    IF AVAIL emitente AND
       emitente.natureza = 2 and
       emitente.cod-gr-cli <> 25 AND
       (emitente.cod-gr-cli < 90 OR
        emitente.cod-gr-cli > 96) THEN DO:
        RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                           INPUT 4,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   
        IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                        WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                          AND tt-prog-ponto.ponto         = 4
                          AND tt-prog-ponto.conteudo      = "YES") THEN DO:
            IF NOT CAN-FIND(FIRST emit-partic-societaria WHERE emit-partic-societaria.cod-emitente = emitente.cod-emitente) THEN DO:
                MESSAGE "Participaá∆o Societ†ria n∆o inforamda, utilize o bot∆o na pasta financeira, ou agora na tela que sera aberta"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RUN esp/cdp/escdp020.w (INPUT emitente.cod-emitente).
            END.
        END.    
    END.
END.


IF p-ind-object = "VIEWER"    AND 
   c-objeto     = "'advwr\v25ad098.w'" THEN DO:


        /* ROTINA PARA DESABILITAR O CAMPO DATA IMPLANTAÄ«O DA TELA */
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "ins-banc",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-ins-banc1-cd0704).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "ins-banc",         /*** Name ***/
                      INPUT no,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 2,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-ins-banc2-cd0704).
        RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                           INPUT 4,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   
        
        IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                        WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                          AND tt-prog-ponto.ponto         = 4
                          AND tt-prog-ponto.conteudo      = "yes") THEN DO:
            create button wh-bt-socios-cd0704  
            assign frame     = p-wgh-frame
                   width     = 5.00        
                   height    = 1.7
                   row       = wh-ins-banc2-cd0704:row - 6
                   col       = wh-ins-banc2-cd0704:COL + 50
                   visible   = yes
                   sensitive = yes
                   tooltip   = "Participaá∆o Societ†ria"
                   TRIGGERS:
                       ON CHOOSE PERSISTENT RUN pi-botao-socios IN h-upc-cd0704.
                   END TRIGGERS.


            if wh-bt-socios-cd0704:load-image("image\emshur.ico") then.
        END.
        
        

    END.
END.

IF p-ind-EVENT = "after-enable"    AND 
   c-objeto     = "'advwr\v25ad098.w'" THEN DO:
    RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                       INPUT 3,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   
    
    IF NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                    WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                      AND tt-prog-ponto.ponto         = 3
                      AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
        ASSIGN wh-ins-banc1-cd0704:SENSITIVE = NO
               wh-ins-banc2-cd0704:SENSITIVE = NO.
    END.
    

END.

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v27ad098.w'"  THEN DO:
    /* ROTINA PARA DESABILITAR O CAMPO DATA IMPLANTAÄ«O DA TELA */
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cgc",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cgc-cd0704).

        create rectangle wh-retangulo-cd0704
        assign frame        = wh-cgc-cd0704:FRAME
               height       = 3.8
               width        = 26.5
               row          = 9.42
               col          = 53
               visible      = yes
               sensitive    = no
               graphic-edge = yes
               edge-pixels  = 2
               filled       = no.

         CREATE TEXT tx-forma-tributacao-cd0704
         ASSIGN FRAME        = wh-cgc-cd0704:FRAME
                FORMAT       = "x(27)"
                WIDTH        = 17.5
                SCREEN-VALUE = "Forma Tributaá∆o Cliente:"
                ROW          = 9.32
                COL          = 54
                VISIBLE      = YES.         
    
         CREATE RADIO-SET wh-forma-tributacao-cd0704
         assign frame     = wh-cgc-cd0704:FRAME
                width     = 23 
                height    = 2.99
                col       = 54 
                row       = 10
                horizontal = NO
                radio-buttons = "N∆o Cumulativo,1,Cumulativo todo ou em parte,2,Simples,3,Nenhum,4,Isento,5"
                visible   = yes          
                sensitive = no.


    END.
END.
IF p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v24ad098.w'"  THEN DO:

    /* ROTINA PARA DESABILITAR O CAMPO DATA IMPLANTAÄ«O DA TELA */
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
          IF h-frame:TYPE <> "field-group" THEN DO:  
             CASE h-frame:NAME:
                  WHEN "data-implant" THEN DO:
                        ASSIGN whdata-implant = h-frame.
                  END.
             END CASE.
             ASSIGN h-frame = h-frame:NEXT-SIBLING.
          END.
          ELSE DO:
             ASSIGN h-frame = h-frame:FIRST-CHILD.
          END.
    END.
    IF VALID-HANDLE(whdata-implant) THEN
        ASSIGN whdata-implant:SENSITIVE = NO.

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        ASSIGN c-motivo-cd0704 = "".
        /*data implant*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",      /*** Type ***/
                      INPUT "data-implant", /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT whdata-implant).

        /*grupo*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cod-gr-cli",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-grupo-cd0704).

        /*matriz*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "nome-matriz",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-matriz-cd0704).

        CREATE TEXT wh-txt-atualiz-cd0704
        ASSIGN FRAME        = wh-grupo-cd0704:FRAME
               FORMAT       = "x(17)"   
               WIDTH        = 12
               SCREEN-VALUE = "Ult.Atualizaá∆o:"
               ROW          = 3.12
               COL          = 57.77
               VISIBLE      = YES.

        CREATE FILL-IN wh-dt-atualiz-cd0704
        ASSIGN FRAME             = wh-grupo-cd0704:FRAME
               DATA-TYPE         = "date"
               FORMAT            = "99/99/9999" 
               WIDTH             = whdata-implant:WIDTH
               HEIGHT            = whdata-implant:HEIGHT
               ROW               = wh-matriz-cd0704:ROW
               COL               = whdata-implant:COL
               SIDE-LABEL-HANDLE = wh-txt-atualiz-cd0704:HANDLE
               VISIBLE           = YES
               SENSITIVE         = NO.
    
        CREATE TOGGLE-BOX wh-ativo-cd0704
        ASSIGN FRAME         = wh-grupo-cd0704:FRAME
               WIDTH         = 8
               HEIGHT        = 0.88
               COL           = whdata-implant:COL
               ROW           = wh-matriz-cd0704:ROW - 1
               VISIBLE       = YES
               SENSITIVE     = NO
               SCREEN-VALUE  = "YES"
               LABEL         = "Ativo"
               HELP          = "Ativo/Inativo"
               TRIGGERS:
                   ON VALUE-CHANGED PERSISTENT RUN pi-tela-motivo IN h-upc-cd0704.
               END TRIGGERS.

        create button wh-bt-ativo-cd0704  
        assign frame     = wh-grupo-cd0704:FRAME 
               width     = 4.00        
               height    = 1
               row       = wh-matriz-cd0704:ROW - 1.05
               col       = whdata-implant:COL + 8
               visible   = yes
               sensitive = yes
               tooltip   = "Hist¢rico Ativaá∆o/Desativaá∆o"
               TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-botao-historico IN h-upc-cd0704.
               END TRIGGERS.


        if wh-bt-ativo-cd0704:load-image("image/im-livro.bmp") then.

    END.
    ELSE IF p-ind-event = "after-enable" THEN DO:
        ASSIGN wh-ativo-cd0704:SENSITIVE = TRUE.
        ASSIGN wh-forma-tributacao-cd0704:SENSITIVE = YES.

    END.
    ELSE IF p-ind-event = "after-disable" THEN DO:
        ASSIGN wh-ativo-cd0704:SENSITIVE = FALSE.
        ASSIGN wh-forma-tributacao-cd0704:SENSITIVE = NO.
    END.
    ELSE IF p-ind-event = "display" THEN DO:


        
        ASSIGN c-motivo-cd0704 = "".
        FIND FIRST emitente NO-LOCK 
             WHERE ROWID(emitente) = p-row-table NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN DO:
                ASSIGN wh-dt-atualiz-cd0704:SCREEN-VALUE = STRING(int-emitente.dt-ult-atualizacao,"99/99/9999").
                
                IF VALID-HANDLE(wh-forma-tributacao-cd0704) THEN
/*                     IF (emitente.natureza = 1 and                                                                                                   */
/*                         int-emitente.ind-forma-tributo <> 4) OR                                                                                     */
/*                        (int-emitente.ind-forma-tributo = 4 OR                                                                                       */
/*                         int-emitente.ind-forma-tributo = 0) THEN DO:                                                                                */
/*                         ASSIGN wh-forma-tributacao-cd0704:SCREEN-VALUE = "4".                                                                       */
/*                         MESSAGE "Informe a Forma de Tributacao para Venda a Partir de Manaus, qualquer duvida entre em contato com a controladoria" */
/*                             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                      */
/*                     END.                                                                                                                            */
/*                     ELSE                                                                                                                            */
                        ASSIGN wh-forma-tributacao-cd0704:SCREEN-VALUE = string(int-emitente.ind-forma-tributo).
    
                IF NOT l-add AND int-emitente.id-ativo THEN
                    ASSIGN wh-ativo-cd0704:SCREEN-VALUE = "YES".
                ELSE
                    ASSIGN wh-ativo-cd0704:SCREEN-VALUE = "NO".
    
                IF VALID-HANDLE(wh-bt-ativo-cd0704) THEN DO :
                    IF CAN-FIND(FIRST int-emitente-historico NO-LOCK
                                WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente
                                  AND int-emitente-historico.tipo         = 1) THEN DO:
                        ASSIGN wh-bt-ativo-cd0704:SENSITIVE = TRUE
                               wh-bt-ativo-cd0704:VISIBLE = TRUE.
                    END.
                    ELSE DO:
                        ASSIGN wh-bt-ativo-cd0704:SENSITIVE = FALSE
                               wh-bt-ativo-cd0704:VISIBLE = FALSE.
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN wh-dt-atualiz-cd0704:SCREEN-VALUE = ""
                       wh-bt-ativo-cd0704:SENSITIVE = FALSE
                       wh-bt-ativo-cd0704:VISIBLE   = FALSE.

                IF NOT l-add THEN
                    ASSIGN wh-ativo-cd0704:SCREEN-VALUE = "NO".
            END.           
        END.

        /*Rotina para nao sobrepor o frame corrente na hora de mostrar os dados do outro frame*/
        RUN GET-ATTRIBUTE IN wgh-folder ('Current-Page':U) NO-ERROR.
        ASSIGN adm-current-page       = INTEGER(RETURN-VALUE).
        IF adm-current-page > 1 THEN
            ASSIGN p-wgh-frame:HIDDEN = YES.
    END.
    ELSE IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
        FIND FIRST emitente NO-LOCK 
             WHERE ROWID(emitente) = p-row-table NO-ERROR.
        IF AVAIL emitente THEN DO:
    
            IF emitente.natureza <> 2 OR
               emitente.cod-gr-cli = 5 THEN DO:
                IF int(wh-forma-tributacao-cd0704:SCREEN-VALUE) <> 4 THEN DO:
                    MESSAGE "Para Pessoa Fisica ou Exportaá∆o ou grupo 5 Informe a forma de tributacao 4, qualquer duvida entre em contato com a controladoria"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK".
                END.
            END.
            ELSE DO:
               IF (int(wh-forma-tributacao-cd0704:SCREEN-VALUE) = 0 or
                   int(wh-forma-tributacao-cd0704:SCREEN-VALUE) = 4) THEN do:
                   MESSAGE "Informe a forma de tributacao para vendas de Manaus, qualquer duvida entre em contato com a controladoria"
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   RETURN "NOK".
               END.
            END.

            FIND FIRST int-emitente EXCLUSIVE-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN
                ASSIGN int-emitente.id-ativo = wh-ativo-cd0704:SCREEN-VALUE = "YES"
                       int-emitente.dt-ult-atualizacao = TODAY
                       int-emitente.ind-forma-tributo  = int(wh-forma-tributacao-cd0704:SCREEN-VALUE).

            IF c-motivo-cd0704 <> "" THEN DO:
                DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

                FIND LAST int-emitente-historico NO-LOCK
                    WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente NO-ERROR.
                IF NOT AVAIL int-emitente-historico THEN
                    ASSIGN i-seq = 1.
                ELSE 
                    ASSIGN i-seq = int-emitente-historico.sequencia + 1.

                CREATE int-emitente-historico.
                ASSIGN int-emitente-historico.cod-emitente = emitente.cod-emitente
                       int-emitente-historico.tipo         = 1
                       int-emitente-historico.sequencia    = i-seq
                       int-emitente-historico.dt-movto     = TODAY
                       int-emitente-historico.hr-movto     = STRING(TIME,"HH:MM:SS")
                       int-emitente-historico.usuario      = c-seg-usuario
                       int-emitente-historico.id-ativo     = wh-ativo-cd0704:SCREEN-VALUE = "YES"
                       int-emitente-historico.motivo       = c-motivo-cd0704.
            END.

        END.
    END.
END.
/*********** FIM DESABILITAR CAMPO DATA IMPLANTAÄ«O **********/ 


/* cria folder de inf. adicionais no CD0704 */
IF p-ind-event = "INITIALIZE" AND
   p-ind-object = "CONTAINER" THEN DO:

    ASSIGN wgh-folder  = p-wgh-object.

    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).

    ASSIGN h-folder = widget-handle(c-folder) no-error.
    
    IF VALID-HANDLE(h-folder) THEN DO:
      RUN create-folder-page IN h-folder (INPUT 7, INPUT "Adicionais":U).
      RUN create-folder-label IN h-folder (INPUT 7, INPUT "Adicionais":U).

      RUN select-page IN p-wgh-object (INPUT 7).

      RUN init-object IN p-wgh-object (INPUT "upc/cd0704-upcv.w":U, /* Nome do Objeto Viewer */
                                       INPUT p-wgh-frame,
                                       INPUT "Layout = ":U,
                                       OUTPUT h-viewer-1).

      RUN set-position IN h-viewer-1 ( 7.10, 5.00).

      RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                             INPUT "CONTAINER-TARGET":U,
                                             OUTPUT c-objects).

      DO i-objects = 1 TO num-entries(c-objects):
         ASSIGN h-object = widget-handle(entry(i-objects, c-objects)).

         IF INDEX(h-object:private-data, "q05ad098") <> 0 AND  /* query principal */
            NOT l-record-1 THEN DO:
            ASSIGN l-record-1 = yes.

            RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                            INPUT "Record":U,
                                            INPUT h-viewer-1).
         END.

         IF INDEX(h-object:private-data, "cd0704-v01") <> 0 AND /* viewer principal */
            NOT l-group-assign-1 THEN DO:
            ASSIGN l-group-assign-1 = yes.

            RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                            INPUT "Group-Assign":U,
                                            INPUT h-viewer-1).
         END.

         IF INDEX(h-object:private-data, "p-cadsim") <> 0 AND /* botoes comandos */
            NOT l-state-1 THEN DO:

            ASSIGN l-state-1 = yes.

            RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                            INPUT "State":U,
                                            INPUT h-viewer-1).
         END.
      END.

      RUN dispatch IN h-viewer-1 ("initialize":U).

      RUN select-page IN p-wgh-object (INPUT 1).
   END.
END.


/* atualiza o endereco de entrega */
IF p-ind-event = "criacao-Endereco-Padrao-Entrega"
OR p-ind-event = "grava-dados-adicionais" THEN DO:

    IF NOT l-assign THEN
        ASSIGN c-transp     = whNomeTransp:SCREEN-VALUE
               c-rota       = whCodRota:SCREEN-VALUE
               c-cidade-cif = whCidadeCif:SCREEN-VALUE.
    ELSE
        ASSIGN l-assign = NO.

    FIND FIRST emitente 
        WHERE ROWID(emitente) = p-row-table 
    EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL emitente THEN DO:


        /*Tarefa 2171: grupo 26 - BNDES seja parametrizado para n∆o enviar a cart¢rio.*/
        IF emitente.cod-gr-cli = 26 THEN
            ASSIGN emitente.ins-banc = 7.

        IF p-ind-event = "criacao-Endereco-Padrao-Entrega" THEN do:
            IF emitente.cod-gr-cli = 5 THEN
               ASSIGN emitente.ind-cre-cli = 2.   /* novos clientes Embratel entra com Automatico */
            ELSE
                IF emitente.cod-gr-cli = 8 OR emitente.cod-gr-cli = 18 THEN DO:
                    ASSIGN emitente.ind-cre-cli = 1.   /* novos clientes Embratel entra com Automatico */
                END.
                ELSE
                    ASSIGN emitente.ind-cre-cli = 4.   /* novos clientes ficam com credito suspenso */
        END.
        FIND FIRST transporte 
            WHERE transporte.nome-abrev = c-transp
        NO-LOCK NO-ERROR.

        IF NOT AVAIL transporte THEN
            FIND FIRST transporte 
                WHERE transporte.cod-transp = int(c-transp)
            NO-LOCK NO-ERROR.

        ASSIGN emitente.cod-transp = transporte.cod-transp.

        /* grava rota e cidade CIF */
        FIND FIRST loc-entr
            WHERE loc-entr.nome-abrev  = emitente.nome-abrev
            AND   loc-entr.cod-entrega = "Padr∆o"
        EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL loc-entr THEN
            ASSIGN loc-entr.nome-transp = STRING(c-transp,'x(12)')
                   loc-entr.nom-cidad-cif  = STRING(c-cidade-cif,'x(25)').       
    END.

END.

/* aqui so serve para controlar se passou primeiro pelo assign 
   desta viewer antes do assign da viewer do endereco de entrega.
   necessario em funcao de o Progress nao fazer assign nas viewers sempre na
   mesma ordem */
IF p-ind-event  = "ASSIGN" AND
   p-ind-object = "VIEWER" AND
   c-objeto     = "cd0704-upcv.w" THEN DO:
   ASSIGN l-assign     = YES
          c-transp     = whNomeTransp:SCREEN-VALUE
          c-rota       = whCodRota:SCREEN-VALUE
          c-cidade-cif = whCidadeCif:SCREEN-VALUE.
END.


IF p-ind-event  = "INITIALIZE"    AND
   p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0704-upcv.w" THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                WHEN "c-nome-transp" THEN
                    ASSIGN whNomeTransp = h-frame.
                WHEN "c-rota" THEN
                    ASSIGN whCodRota = h-frame.
                WHEN "c-cidade-cif" THEN
                    ASSIGN whCidadeCif = h-frame.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.
END.

/* rotina para retirar o campo de transportador padrao da tela */
IF  p-ind-object = "VIEWER"
AND c-objeto     = "'advwr\v24ad098.w'" THEN DO:

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
        ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
        DO WHILE h-frame <> ?:
            IF h-frame:TYPE <> "field-group" THEN DO:  
                CASE h-frame:NAME:
                    WHEN "cod-transp" THEN
                        ASSIGN whCodTransp = h-frame.
                    WHEN "c-nome-transp" THEN
                        ASSIGN whDescTransp = h-frame.
                END CASE.
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE DO:
                ASSIGN h-frame = h-frame:FIRST-CHILD.
            END.
        END. 
    END.
    ELSE
        IF p-ind-event  = "INITIALIZE" THEN
            ASSIGN whDescTransp:VISIBLE = NO
                   whCodTransp:VISIBLE  = NO.
END.

/*
OUTPUT TO 'c:\temp\valida-cliente.txt' APPEND.
PUT string(p-ind-object,'x(12)') FORMAT 'x(12)' " "
    string(p-ind-event,'x(16)')  FORMAT 'x(16)' " "
    string(c-objeto,'x(26)')     FORMAT 'x(26)' " "
    valid-handle(whEstadoLocal)  " "
    valid-handle(whEstado) SKIP.
OUTPUT CLOSE.
*/

/* rotina para criar novo fill-in sobre o campo "estado" */
IF   p-ind-object = "VIEWER" AND 
    (c-objeto     = "advwr\v28ad098.w" OR
     c-objeto     = "'advwr\v28ad098.w'") THEN DO:
    
    IF  p-ind-event = "INITIALIZE" THEN DO:
        
        ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
        ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */

        DO WHILE h-frame <> ?:
            IF h-frame:TYPE <> "field-group" THEN DO:  
                CASE h-frame:NAME:
                    WHEN "endereco" THEN
                        ASSIGN whEndereco = h-frame.
                    WHEN "estado" THEN
                        ASSIGN whEstado = h-frame.
                    WHEN "cidade" THEN
                        ASSIGN whCidade = h-frame.
                    WHEN "pais" THEN
                        ASSIGN whPais = h-frame.
                    WHEN "cep" THEN
                        ASSIGN whCep = h-frame.
                    WHEN "bairro" THEN
                        ASSIGN whBairro = h-frame.                    
                END CASE.
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE DO:
                ASSIGN h-frame = h-frame:FIRST-CHILD.
            END.
        END. 
    
        IF  VALID-HANDLE(whEstado) THEN DO:
            CREATE TEXT whTextEstado
            ASSIGN FRAME        = whEstado:FRAME
                   WIDTH        = 2.5
                   ROW          = 3.45
                   COL          = 53.35
                   SCREEN-VALUE = "UF:"
                   VISIBLE      = YES.

            CREATE FILL-IN whEstadoLocal
            ASSIGN FRAME     = whEstado:FRAME
                   WIDTH     = whEstado:WIDTH
                   HEIGHT    = whEstado:HEIGHT
                   ROW       = whEstado:ROW
                   COL       = whEstado:COL
                   SENSITIVE = NO
                   VISIBLE   = YES
                   SIDE-LABEL-HANDLE = whTextEstado:HANDLE
            TRIGGERS:
                  ON F5 PERSISTENT RUN upc/cd0704-upca.p.
                  ON MOUSE-SELECT-DBLCLICK PERSISTENT RUN upc/cd0704-upca.p.
                  ON LEAVE PERSISTENT RUN upc/cd0704-upcb.p.
            END TRIGGERS.
            whEstadoLocal:LOAD-MOUSE-POINTER('image/lupa.cur').
            whEstadoLocal:MOVE-BEFORE-TAB-ITEM(whPais).
            whEstado:VISIBLE = NO.

            /* necessario para exibir o primeiro registro, pois no display nao funciona */
            FIND FIRST emitente 
                WHERE ROWID(emitente) = p-row-table 
            NO-LOCK NO-ERROR.

            IF AVAIL emitente AND VALID-HANDLE(whEstadoLocal) THEN
                ASSIGN whEstadoLocal:SCREEN-VALUE = emitente.estado.
            END.

            CREATE BUTTON wh-bt-cep-cd0704
            ASSIGN FRAME        = whEstado:FRAME
                   WIDTH        = 7
                   HEIGHT       = 2.25
                   ROW          = whEndereco:ROW
                   LABEL        = "Consulta CEP"
                   COLUMN       = whEndereco:COL - 15
                   SENSITIVE    = NO
                   VISIBLE      = YES
                   TOOLTIP      = "Consulta CEP"
                   HELP         = "Consulta CEP"
                   TRIGGERS:
                      ON CHOOSE PERSISTENT RUN upc/cd0704-upcc.p.
/*                       ON LEAVE  PERSISTENT RUN pi-leave-bt-cep IN h-upc-cd0704. */
                   END TRIGGERS.

            wh-bt-cep-cd0704:LOAD-IMAGE ("image/intelbras/ico-correio.bmp":U).
            wh-bt-cep-cd0704:MOVE-TO-TOP().
    END.    

    IF p-ind-event = "ENABLE" AND VALID-HANDLE(wh-bt-cep-cd0704) THEN
        ASSIGN wh-bt-cep-cd0704:SENSITIVE = YES.

    IF p-ind-event = "DISABLE" AND VALID-HANDLE(wh-bt-cep-cd0704) THEN
        ASSIGN wh-bt-cep-cd0704:SENSITIVE = NO.    

    IF VALID-HANDLE(whEstadoLocal) THEN DO:
        IF p-ind-event = "ENABLE" THEN
            ASSIGN whEstadoLocal:SENSITIVE   = YES
                   whTextEstado:SCREEN-VALUE = "UF:".
        IF p-ind-event = "ADD" THEN
            ASSIGN whTextEstado:SCREEN-VALUE = "UF:".
        IF p-ind-event = "DISABLE" THEN
            ASSIGN whEstadoLocal:SENSITIVE   = NO
                   whTextEstado:SCREEN-VALUE = "UF:".

        IF p-ind-event = "DISPLAY" THEN DO:
            FIND FIRST emitente 
                 WHERE ROWID(emitente) = p-row-table NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN
                ASSIGN whEstadoLocal:SCREEN-VALUE = emitente.estado
                       whEstado:SCREEN-VALUE      = emitente.estado.
        END.

        IF p-ind-event = "VALIDATE" THEN DO:
            FIND FIRST emitente 
                 WHERE ROWID(emitente) = p-row-table NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:
                ASSIGN whEstado:SCREEN-VALUE = whEstadoLocal:SCREEN-VALUE.
                IF EMITENTE.ENDERECO <> whEndereco:SCREEN-VALUE THEN DO:

                    FIND FIRST INT-loc-entr
                         WHERE int-loc-entr.nome-abrev = emitente.nome-abrev
                           AND int-loc-entr.endereco-completo <> "" NO-LOCK NO-ERROR.

                    IF AVAIL INT-loc-entr THEN DO:
                            MESSAGE "                                  Endereco Modificado,                    " SKIP
                                    "" SKIP
                                    "********************** Por Favor ************************" SKIP
                                    "" SKIP
                                    " Confira o Endereco Completo no CD0705 - LOCAL DE ENTREGA"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    END.
                END.

            END.
                

            RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
            RUN pi-trata-endereco IN h-cdapi704 (INPUT  whEndereco:SCREEN-VALUE,
                                                 OUTPUT c-rua, 
                                                 OUTPUT c-nro, 
                                                 OUTPUT c-comp).
            DELETE PROCEDURE h-cdapi704.
            IF c-nro = "" THEN DO:
                MESSAGE "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente"
                    VIEW-AS ALERT-BOX.
                RETURN "NOK":U.
            END.

            IF length(trim(c-comp)) = 1 THEN DO:
                MESSAGE "Complemento do Endereco apenas com uma posiá∆o, SEFAZ exige que tenha mais de uma posiá∆o"
                    VIEW-AS ALERT-BOX.
                RETURN "NOK":U.
            END.

        END.
    END.
END.

/* viewer FISCAIS */
IF  p-ind-object = "VIEWER"
AND c-objeto     = "'advwr\v27ad098.w'" THEN DO:

    IF p-ind-event = "INITIALIZE" THEN DO:
        ASSIGN l-add = NO.

        /*cgc*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cgc",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cgc-cd0704).

        /*natureza*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "combo-box",     /*** Type ***/
                      INPUT "cb-natureza",   /*** Name ***/
                      INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-natureza-cd0704).
    END.
        
    IF p-ind-event = "ADD"  THEN DO:
        ASSIGN l-add = YES.
        ASSIGN /*wh-grupo-cd0704:SENSITIVE  = YES*/
               wh-matriz-cd0704:SENSITIVE = YES
               wh-ativo-cd0704:SCREEN-VALUE = "YES".
        IF VALID-HANDLE(wh-cgc-cd0704) THEN
           ASSIGN wh-cgc-cd0704:SENSITIVE = YES.
    END.
    ELSE DO:
        IF VALID-HANDLE(wh-cgc-cd0704) THEN
            ASSIGN wh-cgc-cd0704:SENSITIVE = NO.

        IF VALID-HANDLE(wh-natureza-cd0704) AND (p-ind-event = "DISPLAY" OR wh-natureza-cd0704:SCREEN-VALUE = "Pessoa Jur°dica") THEN DO:
            RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                               INPUT 2,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).   
            IF NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                            WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                              AND tt-prog-ponto.ponto         = 2
                              AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
                ASSIGN /*wh-grupo-cd0704:SENSITIVE  = NO*/
                       wh-matriz-cd0704:SENSITIVE = NO.
            END.
            ELSE DO:
                IF p-ind-event <> "display" THEN
                    ASSIGN /*wh-grupo-cd0704:SENSITIVE  = yes*/
                           wh-matriz-cd0704:SENSITIVE = YES.
                ELSE
                    ASSIGN /*wh-grupo-cd0704:SENSITIVE  = no*/
                           wh-matriz-cd0704:SENSITIVE = NO.
            END.

        END.
        ELSE DO:
            ASSIGN /*wh-grupo-cd0704:SENSITIVE  = yes*/
                   wh-matriz-cd0704:SENSITIVE = YES.
        END.
    END.
        

    IF p-ind-event = "AFTER-CANCEL" THEN
        ASSIGN l-add = NO.

    IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
        FIND FIRST emitente 
             WHERE ROWID(emitente) = p-row-table EXCLUSIVE-LOCK NO-ERROR.

        IF l-add THEN DO:
            ASSIGN l-add = NO.
            IF AVAIL emitente AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN
                ASSIGN emitente.ind-lib-estoque = YES. 
        END.

/*         IF AVAIL emitente THEN DO:                                               */
/*             /*Atualiza transportadora e representante conforme tabela emitente*/ */
/*             FOR EACH canal-cliente EXCLUSIVE-LOCK                                */
/*                WHERE canal-cliente.cod-emitente   = emitente.cod-emitente:       */
/*                                                                                  */
/*                 IF canal-cliente.cod-transp <> emitente.cod-transp  THEN         */
/*                     ASSIGN canal-cliente.cod-transp = emitente.cod-transp.       */
/*                                                                                  */
/*                 IF canal-cliente.cod-rep <> emitente.cod-rep  THEN               */
/*                     ASSIGN canal-cliente.cod-rep = emitente.cod-rep.             */
/*             END.                                                                 */
/*         END.                                                                     */
    END.
END.

IF p-ind-event  = "BEFORE-ASSIGN"              AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v23ad098.w'"  THEN DO:

    IF VALID-HANDLE(wh-natureza-cd0704) AND wh-natureza-cd0704:SCREEN-VALUE = "Pessoa Jur°dica" THEN DO:
        ASSIGN c-cgc = wh-cgc-cd0704:SCREEN-VALUE
               c-cgc = REPLACE(c-cgc,".","")
               c-cgc = REPLACE(c-cgc,"/","")
               c-cgc = REPLACE(c-cgc,"-","").

        RUN esp/es0018p.p (INPUT "cd0704-upc", /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        IF VALID-HANDLE(wh-emitente-cd0704) THEN DO:
            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.cod-emitente = INT(wh-emitente-cd0704:SCREEN-VALUE) NO-ERROR.
            IF NOT AVAIL b-emitente OR 
               CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                        WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                          AND tt-prog-ponto.ponto         = 2
                          AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:

                FIND FIRST emitente USE-INDEX cgc NO-LOCK  
                     WHERE emitente.cgc BEGINS SUBSTRING(c-cgc,1,8)
                       AND emitente.natureza = 2 NO-ERROR.
                IF AVAIL emitente THEN DO:
                    IF /*wh-grupo-cd0704:SCREEN-VALUE <> STRING(emitente.cod-gr-cli) OR*/ wh-matriz-cd0704:SCREEN-VALUE <> emitente.nome-matriz THEN DO:

                        IF NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                                        WHERE tt-prog-ponto.nome-programa = "cd0704-upc"   
                                          AND tt-prog-ponto.ponto         = 2
                                          AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
                            MESSAGE "As informaá‰es abaixo foram alteradas conforme Cliente: " + STRING(emitente.cod-emitente) + "-" + emitente.nome-abrev SKIP
                                    /*"Grupo Cliente DE: " + wh-grupo-cd0704:SCREEN-VALUE  + "   PARA: " + STRING(emitente.cod-gr-cli) SKIP*/
                                    "Mome Matriz DE: " + wh-matriz-cd0704:SCREEN-VALUE + "   PARA: " + emitente.nome-matriz
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.

                            ASSIGN /*wh-grupo-cd0704:SCREEN-VALUE  = STRING(emitente.cod-gr-cli)*/
                                   wh-matriz-cd0704:SCREEN-VALUE = emitente.nome-matriz.
                        END.
                        ELSE DO:
                            MESSAGE "Vocà informou uma matriz diferente da matriz da raiz de CNPJ: " + SUBSTRING(emitente.cgc,1,8) + "- Cliente:" STRING(emitente.cod-emitente) + "-" + TRIM(emitente.nome-abrev) + "." SKIP
                                    "Matriz informada: " + wh-matriz-cd0704:SCREEN-VALUE + "   Matriz Raiz CNPJ: " + emitente.nome-matriz SKIP
                                    "Deseja manter a matriz informada para esse cliente diferente da matriz da raiz de CNPJ?"
                                VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l-mantem AS LOGICAL.

                            IF NOT l-mantem THEN DO:
                                ASSIGN /*wh-grupo-cd0704:SCREEN-VALUE  = STRING(emitente.cod-gr-cli)*/
                                       wh-matriz-cd0704:SCREEN-VALUE = emitente.nome-matriz.
                            END.
                        END.
                    END.
                END.
            END.
        END.
        

    END.
END.

IF p-ind-event = "INITIALIZE"           AND
   p-ind-object = "VIEWER"              AND
   c-objeto     = "'advwr\v23ad098.w'"  THEN DO:
    /*cliente*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "cod-emitente", /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-emitente-cd0704).
END.

/********************** Integracao do Ems para o CRM *****************/

if p-ind-event  = "DELETE"   and
   p-ind-object = "VIEWER"   and
   p-cod-table  = "emitente" and 
   p-row-table  <> ?         and
   c-objeto     = "'advwr\v23ad098.w'"
then do:
   
   find first b-emitente no-lock where
              rowid(b-emitente) = p-row-table no-error.
   if avail b-emitente 
   then do: 
            
      RUN esp/crm/escrm001a.p (input "Emitente",
                               input "D" ,
                               input rowid(b-emitente),
                               input table tt-raw-transfer).                                    
                               
   end.     
end.

PROCEDURE pi-tela-motivo:
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0704:SCREEN-VALUE) NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:
            IF STRING(int-emitente.id-ativo) <> wh-ativo-cd0704:SCREEN-VALUE THEN DO:
                DEFINE VARIABLE fidescricao AS CHAR FORMAT "x(2000)" 
                    VIEW-AS EDITOR SCROLLBAR-VERTICAL  SIZE 65 BY 3 NO-UNDO FONT 1
                    LABEL "Motivo".

                DEFINE BUTTON btOK AUTO-GO 
                     LABEL "&OK" 
                     SIZE 10 BY 1
                     BGCOLOR 8.

                DEFINE BUTTON btCancelar
                     LABEL "&Cancelar" 
                     SIZE 10 BY 1
                     BGCOLOR 8.

                DEFINE RECTANGLE rtButton
                     EDGE-PIXELS 2 GRAPHIC-EDGE  
                     SIZE 80 BY 1.42
                     BGCOLOR 7.
        
                DEFINE FRAME fMotivo
                    fidescricao  AT ROW 1.21 COL 11.0 COLON-ALIGNED
                    btOK             AT ROW 4.63 COL 2.14
                    btCancelar       AT ROW 4.63 COL 13
                    rtButton         AT ROW 4.38 COL 1
                    SPACE(0.28)
                    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                         THREE-D SCROLLABLE TITLE "Ativaá∆o/Desativaá∆o" FONT 1
                         DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.
        
                ASSIGN fidescricao:RETURN-INSERTED IN FRAME fMotivo = TRUE.

                ON "CHOOSE":U OF btOK IN FRAME fMotivo DO:
                    ASSIGN INPUT FRAME fMotivo fidescricao.

                    IF fidescricao = "" THEN DO:
                        MESSAGE "Motivo deve ser informado!"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        APPLY "entry" TO fidescricao IN FRAME fMotivo.
                        RETURN NO-APPLY.
                    END.
                    ELSE APPLY "GO":U TO FRAME fMotivo.
                END.

                ON "CHOOSE":U OF btCancelar IN FRAME fMotivo DO:
                    IF wh-ativo-cd0704:SCREEN-VALUE = "YES" THEN
                        ASSIGN wh-ativo-cd0704:SCREEN-VALUE = "NO".
                    ELSE
                        ASSIGN wh-ativo-cd0704:SCREEN-VALUE = "YES".

                    APPLY "GO":U TO FRAME fMotivo.
                END.

                ENABLE fidescricao btOK btCancelar
                    WITH FRAME fMotivo. 
        
                WAIT-FOR "GO":U OF FRAME fMotivo.
                ASSIGN c-motivo-cd0704 = fidescricao.
            END.
            ELSE ASSIGN c-motivo-cd0704 = "".
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-botao-historico:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0704:SCREEN-VALUE) NO-ERROR.
    IF AVAIL emitente THEN DO:
        RUN esp/cdp/escdp006.w (INPUT 1, INPUT emitente.cod-emitente).
    END.
END PROCEDURE.

PROCEDURE pi-cd0704a-upc:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0704:SCREEN-VALUE) NO-ERROR.
    IF AVAIL emitente THEN DO:
        run upc/cd0704a-upc.w(INPUT  emitente.cod-emitente).
    END.
END PROCEDURE.

PROCEDURE pi-botao-socios:
        FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0704:SCREEN-VALUE) NO-ERROR.
    IF AVAIL emitente THEN DO:
       RUN esp/cdp/escdp020.w (INPUT emitente.cod-emitente).
    END.
END PROCEDURE.

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
    
