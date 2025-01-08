/*****************************************************************************
**     Autor: Isac Abrahao
**      Data: 24/08/2021
*****************************************************************************/
{utp\ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

def new global shared var wh-mo-codigo                 as widget-handle no-undo. 
def new global shared var wh-descricao                 as widget-handle no-undo.
def new global shared var wh-desc-1                    as widget-handle no-undo. 
def new global shared var wh-perc-desc-max             as widget-handle no-undo.
def new global shared var wh-perc-acres-max            as widget-handle no-undo.
def new global shared var wh-log-permite-desc-coml     as widget-handle no-undo.
def new global shared var wh-log-1                     as widget-handle no-undo.
def new global shared var wh-log-tabela-base           as widget-handle no-undo.
def new global shared var tx-label-0                   as widget-handle no-undo.
def new global shared var tx-label-1                   as widget-handle no-undo.
def new global shared var tx-label-2                   as widget-handle no-undo.

/*DEFINE NEW GLOBAL SHARED VARIABLE i-num-autentic  as integer format 999999.*/
DEF NEW GLOBAL SHARED VAR wh-btParameter-cd1508  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-new-bt-param-cd1508 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-espdp046         AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-upc-cd1508           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-nr-tabela-cd1508     AS ROWID NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-uf-cd1508         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-uf-cd1508     AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-txt-trib-cd1508   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-trib-cd1508       AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-tbpre-espdp046 AS CHAR NO-UNDO.


DEF VAR h-frame AS HANDLE NO-UNDO.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

/*assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").*/
/*
MESSAGE p-ind-object SKIP
        p-ind-event  SKIP
        STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

if  p-ind-object = "CONTAINER"   THEN DO:
    IF  p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        ASSIGN c-tbpre-espdp046 = ''.

        ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-object = h-object:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-object):
            IF h-object:TYPE <> "field-group" THEN DO:
               
/*                 MESSAGE h-object:NAME SKIP h-object:TYPE      */
/*                     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */
					
			    IF  h-object:NAME = 'mo-codigo' 		
				THEN wh-mo-codigo = h-object:HANDLE. 

                IF  h-object:NAME = 'desconto' 		
				THEN wh-desc-1 = h-object:HANDLE. 
					
				IF  h-object:NAME = 'descricao' 	
				THEN wh-descricao = h-object:HANDLE. 	
				

                IF h-object:TYPE = 'literal' OR h-object:TYPE = 'fill-in' THEN DO:
                   ASSIGN h-object:COL = h-object:COL - 10.
                END.
               
                IF h-object:NAME = 'fi-situacao' THEN DO:
                   CREATE TEXT wh-txt-uf-cd1508                                 
                   ASSIGN FRAME        = h-object:FRAME                            
                          FORMAT       = "x(8)"                             
                          WIDTH        = 10                                
                          SCREEN-VALUE = "Estado:"                         
                          ROW          = h-object:ROW + .09                               
                          COL          = h-object:COL + h-object:WIDTH + 4
                          VISIBLE      = TRUE.

                   CREATE FILL-IN wh-uf-cd1508
                   ASSIGN FRAME             = h-object:FRAME                       
                          SIDE-LABEL-HANDLE = wh-txt-uf-cd1508         
                          DATA-TYPE         = "character"                     
                          FORMAT            = "x(4)"                   
                          HEIGHT            = h-object:HEIGHT                         
                          WIDTH             = 6
                          ROW               = h-object:ROW                        
                          COL               = wh-txt-uf-cd1508:COL + wh-txt-uf-cd1508:WIDTH + 5.6                          
                          VISIBLE           = TRUE
                          SENSITIVE         = NO.
                END. 


                IF h-object:NAME = 'cd-gr-preco' THEN DO:
                   CREATE TEXT wh-txt-trib-cd1508
                       ASSIGN FRAME = h-object:FRAME
                       FORMAT       = "x(12)"
                       WIDTH        = 8
                       SCREEN-VALUE = "Tributa‡Æo:"
                       ROW          = h-object:ROW + .09
                       COL          = h-object:COL + 14.5
                       VISIBLE      = YES.
    
                   CREATE COMBO-BOX wh-trib-cd1508
                       ASSIGN FRAME    = h-object:FRAME
                       DATA-TYPE       = "Integer"
                       FORMAT          = ">9"
                       LIST-ITEM-PAIRS = "Nenhum,1,Parcial,2,Total,3"
                       SCREEN-VALUE    = '1'
                       WIDTH           = 14.5
                       ROW             = h-object:ROW
                       COL             = wh-txt-trib-cd1508:COL  + wh-txt-trib-cd1508:WIDTH + 0.2
                       VISIBLE         = YES
                       SENSITIVE       = NO.
                END.
                
                CASE h-object:NAME:
                    WHEN "btParameters" THEN ASSIGN wh-btParameter-cd1508 = h-object.
                END CASE.
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        IF  VALID-HANDLE(wh-btParameter-cd1508) THEN DO:

            ASSIGN wh-btParameter-cd1508:COL = wh-btParameter-cd1508:COL - 2.

            IF  NOT VALID-HANDLE (h-upc-cd1508) THEN
                RUN upc/cd1508-upc.p PERSISTENT SET h-upc-cd1508 (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p-wgh-object,
                                                                  INPUT p-wgh-frame,
                                                                  INPUT "",
                                                                  INPUT p-row-table).

            CREATE BUTTON wh-new-bt-param-cd1508
            ASSIGN FRAME       = wh-btParameter-cd1508:FRAME
                   WIDTH       = wh-btParameter-cd1508:WIDTH
                   HEIGHT      = wh-btParameter-cd1508:HEIGHT
                   LABEL       = ""
                   ROW         = wh-btParameter-cd1508:ROW
                   COL         = wh-btParameter-cd1508:COL + 4.7
                   TOOLTIP     = "Elimina‡Æo por Faixa"
                   FLAT-BUTTON = wh-btParameter-cd1508:FLAT-BUTTON
                   VISIBLE     = wh-btParameter-cd1508:VISIBLE
                   SENSITIVE   = wh-btParameter-cd1508:SENSITIVE.
            ON "CHOOSE" OF wh-new-bt-param-cd1508 PERSISTENT RUN pi-elimina IN h-upc-cd1508.
    
            ASSIGN wh-new-bt-param-cd1508:SENSITIVE = YES
                   wh-new-bt-param-cd1508:VISIBLE   = YES.

            IF wh-new-bt-param-cd1508:LOAD-IMAGE("adeicon/rpt-u.bmp") THEN.

            CREATE BUTTON wh-bt-espdp046
            ASSIGN FRAME       = wh-btParameter-cd1508:FRAME
                   WIDTH       = 19.5
                   HEIGHT      = wh-btParameter-cd1508:HEIGHT
                   LABEL       = "Importa/Exporta TB.Pre‡o"
                   ROW         = wh-btParameter-cd1508:ROW
                   COL         = wh-new-bt-param-cd1508:COL + wh-new-bt-param-cd1508:WIDTH + 1
                   TOOLTIP     = "Importa/Exporta Tab. Pre‡o"
                   FLAT-BUTTON = wh-btParameter-cd1508:FLAT-BUTTON
                   VISIBLE     = wh-btParameter-cd1508:VISIBLE
                   SENSITIVE   = wh-btParameter-cd1508:SENSITIVE.

            ON "CHOOSE" OF wh-bt-espdp046 PERSISTENT RUN upc/cd1508-upc.p (INPUT 'chama-espdp046',     
                                                                           INPUT p-ind-object,    
                                                                           INPUT p-wgh-object,    
                                                                           INPUT p-wgh-frame,     
                                                                           INPUT p-cod-table,     
                                                                           INPUT p-row-table).  
            ASSIGN wh-bt-espdp046:SENSITIVE = YES
                   wh-bt-espdp046:VISIBLE   = YES.
        END.



    END.
	
	IF  VALID-HANDLE(wh-mo-codigo)
	AND VALID-HANDLE(wh-DESCRICAO) 
    AND VALID-HANDLE(wh-desc-1) 
	THEN DO:
	     create fill-in wh-perc-desc-max
	         assign frame      = p-wgh-frame
	         data-type         = "decimal"
	         format            = ">>9.99"
	         width             = wh-mo-codigo:WIDTH + 2
	         height            = 0.88
	         row               = wh-mo-codigo:ROW
	         col               = wh-mo-codigo:COL + 22.5
	         visible           = yes
	         sensitive         = NO.
	     
	     create text tx-label-0
	         assign frame        = p-wgh-frame
	         format              = "x(32)"
	         width               = 11
	         height              = .75
	         screen-value        = "Perc Max Desc:"
	         row                 = wh-mo-codigo:ROW
	         col                 = wh-mo-codigo:COL + 11.3
	         visible             = yes.

         create fill-in wh-perc-acres-max
	         assign frame      = p-wgh-frame
	         data-type         = "decimal"
	         format            = ">>9.99"
	         width             = wh-desc-1:WIDTH 
	         height            = 0.88
	         row               = wh-desc-1:ROW
	         col               = wh-desc-1:COL 
	         visible           = yes
	         sensitive         = NO.
	     
	     create text tx-label-2
	         assign frame        = p-wgh-frame
	         format              = "x(32)"
	         width               = 11
	         height              = .75
	         screen-value        = "Perc Max Acres:"
	         row                 = wh-desc-1:ROW
	         col                 = wh-desc-1:COL - 11.3
	         visible             = yes.
	     
	     
	     
	     create toggle-box wh-log-permite-desc-coml
	         assign frame      = p-wgh-frame
	         width             = 2
	         height            = 0.88
	         row               = wh-descricao:ROW
	         col               = wh-descricao:COL + 39.5
	         visible           = yes
	         sensitive         = NO.
	     
	     create text tx-label-1
	         assign frame        = p-wgh-frame
	         format              = "x(32)"
	         width               = 8
	         height              = .75
	         screen-value        = "Perm Desc"
	         row                 = wh-descricao:ROW + 0.1
	         col                 = wh-descricao:COL + 41.9
	         visible             = yes.
	END.	
	
END.

IF  p-ind-event = "After-display" OR p-ind-event = "After-initialize" 
OR p-ind-event = "After-control-tool-bar" 
THEN DO:

    ASSIGN g-nr-tabela-cd1508 = p-row-table.

    IF VALID-HANDLE(wh-trib-cd1508) AND 
       VALID-HANDLE(wh-uf-cd1508)   AND
       VALID-HANDLE(wh-perc-desc-max) 
	AND VALID-HANDLE(wh-log-permite-desc-coml) 
    AND VALID-HANDLE(wh-perc-acres-max)      THEN DO:

       ASSIGN wh-trib-cd1508:SCREEN-VALUE = '1'
              wh-uf-cd1508  :SCREEN-VALUE = ''.
       
       FIND tb-preco WHERE ROWID(tb-preco) = p-row-table NO-LOCK NO-ERROR.
    
       IF AVAIL tb-preco THEN DO:   
          FIND FIRST int-tb-preco WHERE int-tb-preco.nr-tabpre = tb-preco.nr-tabpre NO-LOCK NO-ERROR.
          
          IF AVAIL int-tb-preco THEN DO:
             ASSIGN wh-trib-cd1508:SCREEN-VALUE = IF int-tb-preco.idi-tributacao = 0 THEN '1' ELSE STRING(int-tb-preco.idi-tributacao)
                    wh-uf-cd1508  :SCREEN-VALUE = int-tb-preco.estado.

             assign wh-perc-desc-max:screen-value         = string(int-tb-preco.perc-desc-max)
	                wh-log-permite-desc-coml:screen-value = string(int-tb-preco.log-permite-desc-coml)
                    wh-perc-acres-max:screen-value        = string(int-tb-preco.perc-acres-max)
                  
	                 .

          END.
          ELSE
             ASSIGN wh-trib-cd1508:SCREEN-VALUE           = '1'
                    wh-uf-cd1508  :SCREEN-VALUE           = ''
                    wh-perc-desc-max:screen-value         = string(0.00)
                    wh-perc-acres-max:screen-value        = string(0.00)
	                wh-log-permite-desc-coml:screen-value = string(NO).
       END.                                  
    END.
	
	IF VALID-HANDLE(wh-log-permite-desc-coml) 
	THEN wh-log-permite-desc-coml:SENSITIVE = NO.

    /*IF VALID-HANDLE(wh-perc-acres-max)
    AND VALID-HANDLE(tx-label-2)
    THEN do:
         wh-perc-acres-max:MOVE-TO-TOP().
         tx-label-2:MOVE-TO-TOP().
    END.*/

    IF valid-handle(wh-desc-1) THEN wh-desc-1:VISIBLE = NO.
   
	
END.


IF  p-ind-event = "After-destroy-interface" THEN DO:
    DELETE PROCEDURE h-upc-cd1508.
    ASSIGN h-upc-cd1508 = ?.
END.

PROCEDURE pi-elimina:

    RUN esp/pdp/espdp046a.w.
END.

IF p-ind-event = 'chama-espdp046' THEN DO:

   ASSIGN c-tbpre-espdp046 = ''.

   FIND tb-preco WHERE ROWID(tb-preco) =  g-nr-tabela-cd1508 NO-LOCK NO-ERROR.
 
   IF AVAIL tb-preco THEN
      ASSIGN c-tbpre-espdp046 = tb-preco.nr-tabpre.

   RUN esp/pdp/espdp046.w.
END.
