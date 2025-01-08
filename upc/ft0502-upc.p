/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa

compile \\tsclient\c\fontes\upc\cd0204-upc.p save into c:\temp\upc.
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

RUN upc/ft0502-upcnfse.p (INPUT p-ind-event,
                          INPUT p-ind-object,
                          INPUT p-wgh-object,
                          input p-wgh-frame,
                          input p-cod-table, 
                          input p-row-table). 


DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
define new global shared var wh-cod-estabel-ft0502      as widget-handle no-undo.
define new global shared var wh-serie-ft0502      as widget-handle no-undo.
define new global shared var wh-nr-nota-fis-ft0502      as widget-handle no-undo.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-ft0502-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button-ft0502       AS WIDGET-HANDLE    NO-UNDO.
DEF VAR c-objeto   AS CHAR     NO-UNDO.

/* DEFINE VARIABLE c-char AS   CHAR.                                                             */
/*                                                                                               */
/* assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/"). */
IF VALID-HANDLE(p-wgh-object) THEN
   assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").


/**************************************
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
***************************************/
IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/ft0502-upc.p PERSISTENT SET h-ft0502-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  
END.
IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-ft0502-upc) THEN
        DELETE PROCEDURE h-ft0502-upc.

if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    
    create button wh-button-ft0502  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.33
           col       = 43.32       
           visible   = yes
           sensitive = yes
           tooltip   = "Atualiza Endereáo"
           triggers:
             on CHOOSE PERSISTENT run pi-Atualiza-Endereco IN h-ft0502-upc.
           end triggers.
  if wh-button-ft0502:load-image("image/gr-lay.bmp") then.
end.
/* IF p-ind-event  = "display"              then */
/* MESSAGE p-ind-event  SKIP                     */
/*         p-ind-object     SKIP                 */
/*         c-objeto                              */
/*                                               */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.        */

IF p-ind-event  = "display"              AND 
   p-ind-object = "VIEWER"              AND
   c-objeto     = "v08di135.w"  THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cod-estabel",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-estabel-ft0502).
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "serie",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-serie-ft0502).
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "nr-nota-fis",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-nr-nota-fis-ft0502).
END.  


PROCEDURE pi-Atualiza-Endereco:
    FIND nota-fiscal
         WHERE nota-fiscal.cod-estabel = wh-cod-estabel-ft0502:SCREEN-VALUE
           AND nota-fiscal.serie       = wh-serie-ft0502:SCREEN-VALUE
           AND nota-fiscal.nr-nota-fis = wh-nr-nota-fis-ft0502:SCREEN-VALUE
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL nota-fiscal  THEN DO:
        MESSAGE "Nota Fiscal Nao Encontrada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
            NO-LOCK NO-ERROR.
        
        IF natur-oper.tipo = 3 OR
           ((nota-fiscal.idi-sit-nf-eletro = 11 OR
            nota-fiscal.idi-sit-nf-eletro = 1) and
            nota-fiscal.ind-sit-nota <= 2) THEN DO:
            FIND emitente
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                 NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:
                FIND loc-entr
                    WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                      AND loc-entr.cod-entrega = nota-fiscal.cod-entrega
                    NO-LOCK NO-ERROR.
                IF AVAIL loc-entr THEN DO:
                    ASSIGN nota-fiscal.cgc              =   loc-entr.cgc
                           nota-fiscal.ins-estadual     =   loc-entr.ins-estadual  
                           nota-fiscal.endereco         =   loc-entr.endereco      
                           nota-fiscal.bairro           =   loc-entr.bairro        
                           nota-fiscal.cidade           =   loc-entr.cidade        
                           nota-fiscal.estado           =   loc-entr.estado        
                           nota-fiscal.pais             =   loc-entr.pais          
                           nota-fiscal.cep              =   loc-entr.cep.


                    MESSAGE "Nota "  wh-cod-estabel-ft0502:SCREEN-VALUE           "/"
                                     wh-serie-ft0502:SCREEN-VALUE                 "/"
                                     wh-nr-nota-fis-ft0502:SCREEN-VALUE           SKIP
                            "Atualizada com o Endereáo " SKIP 
                            "CNPJ: " loc-entr.cgc             SKIP
                            "INSC.ESTADUAL: " loc-entr.ins-estadual    SKIP
                            "ENDERECO: " loc-entr.endereco        SKIP
                            "BAIRRO: " loc-entr.bairro          SKIP
                            "CIDADE: " loc-entr.cidade          SKIP
                            "ESTADO: " loc-entr.estado          SKIP
                            "PAIS: " loc-entr.pais            SKIP
                            "CEP: " loc-entr.cep
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                END.
                ELSE DO:
                    ASSIGN nota-fiscal.cgc              =   emitente.cgc           
                           nota-fiscal.ins-estadual     =   emitente.ins-estadual  
                           nota-fiscal.endereco         =   emitente.endereco      
                           nota-fiscal.bairro           =   emitente.bairro        
                           nota-fiscal.cidade           =   emitente.cidade        
                           nota-fiscal.estado           =   emitente.estado        
                           nota-fiscal.pais             =   emitente.pais          
                           nota-fiscal.cep              =   emitente.cep.


                    MESSAGE "Nota "  wh-cod-estabel-ft0502:SCREEN-VALUE           "/"
                                     wh-serie-ft0502:SCREEN-VALUE                 "/"
                                     wh-nr-nota-fis-ft0502:SCREEN-VALUE           SKIP
                            "Atualizada com o Endereáo " SKIP 
                            "CNPJ: " emitente.cgc             SKIP
                            "INSC.ESTADUAL: " emitente.ins-estadual    SKIP
                            "ENDERECO: " emitente.endereco        SKIP
                            "BAIRRO: " emitente.bairro          SKIP
                            "CIDADE: " emitente.cidade          SKIP
                            "ESTADO: " emitente.estado          SKIP
                            "PAIS: " emitente.pais            SKIP
                            "CEP: " emitente.cep
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                END.
            END.
        END.
        ELSE DO:
            MESSAGE "Nota fiscal " wh-cod-estabel-ft0502:SCREEN-VALUE           "/" 
                                   wh-serie-ft0502:SCREEN-VALUE                 "/" 
                                   wh-nr-nota-fis-ft0502:SCREEN-VALUE           
                " com situaá∆o que n∆o permite alteraá∆o"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
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

