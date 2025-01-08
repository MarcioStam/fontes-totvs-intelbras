/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 - 00/00/2002
**                  Desenvolvimento Programa

compile \\tsclient\c\fontes\upc\cd0204-upc.p save into c:\temp\upc.
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}
DEFINE TEMP-TABLE tt-ped-curva like ped-curva
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-curva-aux like ped-curva
    field r-rowid  as rowid.
DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
def var h-acomp      as handle no-undo.
DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEFINE VARIABLE i-sequencia        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-valor AS CHARACTER   NO-UNDO.
define new global shared var wh-cod-estabel-of0320p      as widget-handle no-undo.
define new global shared var wh-serie-of0320p      as widget-handle no-undo.
define new global shared var wh-nr-nota-fis-of0320p      as widget-handle no-undo.
DEFINE VARIABLE d-valor AS DECIMAL     NO-UNDO.
define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-of0320pp-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button-of0320p       AS WIDGET-HANDLE    NO-UNDO.
DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEFINE VARIABLE h-bodi148 AS HANDLE      NO-UNDO.
def var i-registros as int no-undo.
DEFINE VARIABLE l-choice AS LOGICAL     NO-UNDO.
/* DEFINE VARIABLE c-char AS   CHAR.                                                             */
/*                                                                                               */
/* assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/"). */
IF VALID-HANDLE(p-wgh-object) THEN
   assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").


/**************************************
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-objeto SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
***************************************/



IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/of0320p-upc.p PERSISTENT SET h-of0320pp-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  
END.
IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-of0320pp-upc) THEN
        DELETE PROCEDURE h-of0320pp-upc.

if  p-ind-event  = "BEFORE-INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    
    create button wh-button-of0320p  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 8.70
           col       = 75.32       
           visible   = yes
           sensitive = yes
           tooltip   = "Importa Dados"
           triggers:
             on CHOOSE PERSISTENT run pi-Importa-Dados IN h-of0320pp-upc.
           end triggers.
  if wh-button-of0320p:load-image("image/gr-lay.bmp") then.
end.


PROCEDURE pi-Importa-Dados:
     DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

     IF SEARCH("c:\temp\quadro12.csv") = ? THEN DO:
         MESSAGE "Arquivo nÆo encontrado" skip
                 "" skip
                 "Disponibilize o arquivo c:\temp\quadro12.csv no diretorio " SKIP
                 "Formato: " SKIP
             "Origem;Cod.Receita;Classe Vcto;Dta Vencto;Valor;InscEstadual;Nr.Acordo;Ano;Mes" SKIP
             "1;1449;10421;20/10/2009;409188,24;250082764;000000000000000;2009;10"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
     END.
     ELSE DO:


         MESSAGE "Voce disponibilizou o arquivo c:\temp\quadro12.csv" SKIP
                 "Com o Formato : " SKIP
             "Origem;Cod.Receita;Classe Vcto;Dta Vencto;Valor;InscEstadual;Nr.Acordo;Ano;Mes" SKIP
             "1;1449;10421;20/10/2009;409188,24;250082764;000000000000000;2009;10"

             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    TITLE "" UPDATE l-choice AS LOGICAL.
             CASE l-choice:
             WHEN TRUE THEN /* Yes */
              DO:
                run utp/ut-acomp.p persistent set h-acomp.  
                
                RUN pi-inicializar in h-acomp (input "Imprimindo...").
                INPUT FROM c:\temp\quadro12.csv.
                REPEAT:
                    IMPORT UNFORMATTED c-linha.

                    RUN pi-acompanhar in h-acomp (input "Importando"  + c-linha ).
                    ASSIGN c-valor = "3205" + STRING(int(ENTRY(8, c-linha, ";")),'9999') + STRING(int(ENTRY(9, c-linha, ";")),'99')
                           d-valor = DEC(c-valor).
    
                     ASSIGN i-sequencia = i-sequencia + 1.
                     create ped-curva.
                     assign ped-curva.codigo           = i-sequencia
                            ped-curva.vl-aberto        = d-valor
                            ped-curva.nome             = ENTRY(4, c-linha, ";")
                            ped-curva.regiao           = string(ENTRY(6, c-linha, ";"),"999.999.999")
                            ped-curva.un               = ENTRY(1, c-linha, ";")
                            ped-curva.int-1            = int(ENTRY(2, c-linha, ";"))
                            ped-curva.int-2            = int(ENTRY(3, c-linha, ";"))
                            ped-curva.vl-lucro-br      = dec(ENTRY(5, c-linha, ";"))
                            ped-curva.char-1           = ENTRY(7, c-linha, ";").
    
                 END.
                 
                 RUN pi-finalizar in h-acomp.
                 MESSAGE "Arquivo Importado - Saia desta tela " skip
                         ">>> PRESSIONANDO O BOTAO - CANCELAR - <<<" SKIP
                         "e entre novamente para visualizar as informa‡äes!"
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
              END.
             WHEN FALSE THEN /* No */
              DO:
                 MESSAGE "Processo Cancelado"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                 RETURN NO-APPLY.
              END.
             OTHERWISE /* Cancel */
                 RETURN.
             END CASE.
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

