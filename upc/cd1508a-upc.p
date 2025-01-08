/*****************************************************************************
**     Autor: Isac Abrahao
**      Data: 24/08/2021
*****************************************************************************/
/* definicao de parametros */

Def Input Parameter p-ind-event  AS CHAR          NO-UNDO.
Def Input Parameter p-ind-object AS CHAR          NO-UNDO.
Def Input Parameter p-wgh-object AS HANDLE        NO-UNDO.
Def Input Parameter p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
Def Input Parameter p-cod-table  AS CHAR          NO-UNDO.
Def Input Parameter p-row-table  AS ROWID         NO-UNDO.

def new global shared var wh-Text-1                    as widget-handle no-undo. 
def new global shared var wh-rect-13                   as widget-handle no-undo.
def new global shared var tx-label-0                   as widget-handle no-undo.
def new global shared var tx-label-1                   as widget-handle no-undo.
def new global shared var tx-label-2                   as widget-handle no-undo.
def new global shared var wh-perc-desc-max             as widget-handle no-undo.
def new global shared var wh-perc-acres-max            as widget-handle no-undo.
def new global shared var wh-log-permite-desc-coml     as widget-handle no-undo.
def new global shared var wh-aux                       as widget-handle no-undo.
def new global shared var wh-desc                      as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR h-frame-cd1508a       As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-rect-cd1508a        As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-observ-cd1508a      As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-lb-observ-cd1508a   As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-uf-cd1508a          As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-text-uf-cd1508a     As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-desc-cd1508a        As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-nr-tabpre-cd1508a   As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btok-ems-cd1508a    As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btsave-ems-cd1508a  As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btok-cust-cd1508a   As HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-btsave-cust-cd1508a As HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-txt-trib-cd1508a  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-trib-cd1508a      AS WIDGET-HANDLE NO-UNDO.

DEF VARIABLE l-implanta          AS LOGICAL NO-UNDO.
Def Variable wh-pesquisa         AS WIDGET-HANDLE NO-UNDO.

Def NEW GLOBAL SHARED VAR adm-broker-hdl      As HANDLE No-Undo.

Def NEW GLOBAL SHARED  Var c-objeto-cd1508a   AS CHAR      NO-UNDO.
Def NEW GLOBAL SHARED  Var c-objects          AS CHARACTER NO-UNDO.
Def NEW GLOBAL SHARED  Var i-objects          AS INTEGER   NO-UNDO.
Def NEW GLOBAL SHARED  Var h-object-cd1508a   AS HANDLE    NO-UNDO.
Def NEW GLOBAL SHARED  VAR rect-cd1508a       AS HANDLE    NO-UNDO.

/*
MESSAGE p-ind-event  SKIP
        p-ind-object SKIP
        p-wgh-object SKIP
        p-wgh-frame  SKIP
        p-cod-table  SKIP
        string(p-row-table)  
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/


if p-ind-event = 'before-initialize' then
do:
    ASSIGN h-object-cd1508a = p-wgh-frame:FIRST-CHILD.
           h-object-cd1508a = h-object-cd1508a:FIRST-CHILD.
           
     DO WHILE h-object-cd1508a <> ?:
        IF h-object-cd1508a:TYPE <> 'field-group' THEN DO:
           IF h-object-cd1508a:NAME = "nr-tabpre" THEN DO:
              ASSIGN h-nr-tabpre-cd1508a = h-object-cd1508a:HANDLE.
           END. 
           
          IF h-object-cd1508a:NAME = "fpage1" THEN DO:
             ASSIGN h-frame-cd1508a = h-object-cd1508a:FIRST-CHILD.
         
             DO WHILE h-frame-cd1508a <> ?:


                IF  h-frame-cd1508a:NAME = 'Desconto' 		
				THEN do: 
                     wh-desc = h-frame-cd1508a:HANDLE. 
                END.
			 
			    IF h-frame-cd1508a:NAME = 'situacao' 
                THEN ASSIGN h-frame-cd1508a:HEIGHT = h-frame-cd1508a:HEIGHT - 0.2
                            h-frame-cd1508a:ROW = h-frame-cd1508a:ROW - 0.09.

                IF h-frame-cd1508a:NAME = 'RECT-13' 
                THEN ASSIGN h-frame-cd1508a:HEIGHT = h-frame-cd1508a:HEIGHT - 0.2
                            h-frame-cd1508a:ROW = h-frame-cd1508a:ROW - 0.19.

                IF h-frame-cd1508a:NAME = 'log-2' 
                OR h-frame-cd1508a:NAME = 'tb-exporta-desc'
                OR h-frame-cd1508a:NAME = 'log-1' 
                THEN do:
                     IF h-frame-cd1508a:NAME = 'log-2' 
                     THEN wh-aux = h-frame-cd1508a.

                     ASSIGN h-frame-cd1508a:ROW = h-frame-cd1508a:ROW + 0.14.
                END.

                IF h-frame-cd1508a:TYPE = 'LITERAL'
                THEN do:                         
                     IF h-frame-cd1508a:SCREEN-VALUE BEGINS 'situa'  
                     THEN
                     ASSIGN h-frame-cd1508a:ROW = h-frame-cd1508a:ROW - 0.1
                            h-frame-cd1508a:HEIGHT = h-frame-cd1508a:HEIGHT - 0.18
                    .
                END.

                IF h-frame-cd1508a:TYPE = 'TEXT'
                THEN do:                         
                     IF h-frame-cd1508a:SCREEN-VALUE BEGINS 'ESTAD'  
                     THEN
                     ASSIGN wh-text-1 = h-frame-cd1508a. 
                    .
                END.
			 
			 
                IF h-frame-cd1508a:TYPE <> "field-group" THEN DO:
                   IF h-frame-cd1508a:NAME = "rect-15" THEN
                      ASSIGN h-rect-cd1508a = h-frame-cd1508a:HANDLE
                             h-rect-cd1508a:HEIGHT = h-rect-cd1508a:HEIGHT - 1.5
                             h-rect-cd1508a:ROW = h-rect-cd1508a:ROW + 1.4 NO-ERROR.
         
                   IF h-frame-cd1508a:NAME = "observacoes" THEN
                      ASSIGN h-observ-cd1508a = h-frame-cd1508a:HANDLE
                             h-observ-cd1508a:HEIGHT = h-observ-cd1508a:HEIGHT - 1.5
                             h-observ-cd1508a:ROW = h-observ-cd1508a:ROW + 1.4 NO-ERROR.
         
                   IF h-frame-cd1508a:TYPE = "literal" THEN
                      IF h-frame-cd1508a:SCREEN-VALUE = "observa‡äes" THEN
                         ASSIGN h-lb-observ-cd1508a = h-frame-cd1508a:HANDLE
                                h-lb-observ-cd1508a:ROW = h-lb-observ-cd1508a:ROW + 1.4 
                                h-lb-observ-cd1508a:COL = h-lb-observ-cd1508a:COL + 27 NO-ERROR.
         
                   IF h-frame-cd1508a:NAME = "desconto" THEN DO:
                      CREATE TEXT h-text-uf-cd1508a
                      ASSIGN FRAME        = h-frame-cd1508a:FRAME
                             WIDTH        = 7
                             FORMAT       = "x(07)"
                             SCREEN-VALUE = "Estado:"
                             COL          = h-frame-cd1508a:COL - 5.5
                             ROW          = h-frame-cd1508a:ROW + 1.3
                             VISIBLE      = YES.
         
                      CREATE FILL-IN h-uf-cd1508a
                      ASSIGN FRAME     = h-frame-cd1508a:FRAME
                             SIDE-LABEL-HANDLE = h-text-uf-cd1508a:HANDLE
                             DATA-TYPE = "character"
                             FORMAT    = "x(3)"
                             HEIGHT    = 0.88
                             WIDTH     = 5
                             COL       = h-frame-cd1508a:COL
                             ROW       = h-frame-cd1508a:ROW + 1.2
                             VISIBLE   = YES
                             SENSITIVE = YES /*h-frame-cd1508a:SENSITIVE*/
                             TOOLTIP   = "Estado"
         
                      TRIGGERS:
                          ON 'mouse-select-dblclick' PERSISTENT RUN upc\cd1508a-upc.p (INPUT "uso-zoom",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
                          ON 'F5'                    PERSISTENT RUN upc\cd1508a-upc.p (INPUT "uso-zoom",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).       
                          ON 'leave'                 PERSISTENT RUN upc\cd1508a-upc.p (INPUT "leave-estado",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).
                      END.
         
                      h-uf-cd1508a:LOAD-MOUSE-POINTER("image/lupa.cur") NO-ERROR.
                      h-uf-cd1508a:MOVE-AFTER-TAB(h-frame-cd1508a) NO-ERROR.
         
                      CREATE FILL-IN h-desc-cd1508a
                      ASSIGN FRAME = h-frame-cd1508a:FRAME
                             DATA-TYPE = "character"
                             FORMAT    = "x(40)"
                             HEIGHT    = 0.88
                             WIDTH     = 25
                             COL       = h-uf-cd1508a:COL + h-uf-cd1508a:WIDTH + 0.3
                             ROW       = h-frame-cd1508a:ROW + 1.2
                             VISIBLE   = YES
                             SENSITIVE = NO.
         
                      CREATE TEXT wh-txt-trib-cd1508a
                             ASSIGN FRAME = h-frame-cd1508a:FRAME
                             FORMAT       = "x(12)"
                             WIDTH        = 8
                             SCREEN-VALUE = "Tributa‡Æo:"
                             ROW          = h-text-uf-cd1508a:ROW 
                             COL          = h-text-uf-cd1508a:COL - 19.2
                             VISIBLE      = YES.
         
                      CREATE COMBO-BOX wh-trib-cd1508a
                             ASSIGN FRAME    = h-frame-cd1508a:FRAME
                             DATA-TYPE       = "Integer"
                             FORMAT          = ">9"
                             LIST-ITEM-PAIRS = "Nenhum,1,Parcial,2,Total,3"
                             SCREEN-VALUE    = '1'
                             WIDTH           = 10
                             ROW             = h-uf-cd1508a:ROW
                             COL             = wh-txt-trib-cd1508a:COL  + wh-txt-trib-cd1508a:WIDTH + 0.2
                             VISIBLE         = YES
                             SENSITIVE       = YES.

                      wh-trib-cd1508a:MOVE-AFTER-TAB(h-uf-cd1508a) NO-ERROR.
                   END.
                                                                                                
                   ASSIGN h-frame-cd1508a = h-frame-cd1508a:NEXT-SIBLING.
                END.
                ELSE
                   ASSIGN h-frame-cd1508a = h-frame-cd1508a:FIRST-CHILD.
             END.
          END.
          
          ASSIGN h-object-cd1508a = h-object-cd1508a:NEXT-SIBLING.
        END.
        ELSE
          ASSIGN h-object-cd1508a = h-object-cd1508a:FIRST-CHILD.
     END.
	 
	 IF VALID-HANDLE(wh-text-1) 
	 THEN DO:
	      create fill-in wh-perc-desc-max                        
	          assign frame      = p-wgh-frame                    
	          data-type         = "decimal"                      
	          format            = ">>9.99"                       
	          width             = 7         
	          height            = 0.88                           
	          row               = wh-text-1:ROW + 3              
	          col               = wh-text-1:COL + 49.5        
	          visible           = yes                            
	          sensitive         = YES.                            
	                                                             
	      create text tx-label-0                                 
	          assign frame        = p-wgh-frame                  
	          format              = "x(32)"                      
	          width               = 9                           
	          height              = .75                          
	          screen-value        = "% Max Desc:"             
	          row                 = wh-text-1:ROW + 3             
	          col                 = wh-text-1:COL + 40.3      
	          visible             = yes.                         
	 END.
	 
	 IF VALID-HANDLE(wh-aux)
	 THEN DO:
	      create toggle-box wh-log-permite-desc-coml              
	          assign frame      = p-wgh-frame                     
	          width             = 2                               
	          height            = 0.88                            
	          row               = wh-aux:ROW + 2.3            
	          col               = wh-aux:COL + 2.7         
	          visible           = yes                             
	          sensitive         = YES.                             
	                                                              
	      create text tx-label-1                                  
	          assign frame        = p-wgh-frame                   
	          format              = "x(39)"                       
	          width               = 18                             
	          height              = .75                           
	          screen-value        = "Permite Desconto Coml"         
	          row                 = wh-aux:ROW + 2.3 + 0.1       
	          col                 = wh-aux:COL + 4.9       
	          visible             = yes.
	      
	 END.

     IF VALID-HANDLE(wh-desc) 
     THEN DO:
          create fill-in wh-perc-acres-max                   
              assign frame      = p-wgh-frame               
              data-type         = "decimal"                 
              format            = ">>9.99"                  
              width             = wh-desc:WIDTH             
              height            = 0.88                      
              row               = wh-desc:ROW + 3.05               
              col               = wh-desc:COL + 2.7              
              visible           = yes                       
              sensitive         = NO.                       
                                                            
          create text tx-label-2                            
              assign frame        = p-wgh-frame             
              format              = "x(32)"                 
              width               = 11                      
              height              = .75                     
              screen-value        = "Perc Max Acres:"       
              row                 = wh-desc:ROW + 3            
              col                 = wh-desc:COL - 8.8      
              visible             = yes.                    
     END.

end.

if p-ind-event = 'after-initialize' then
do:
    ASSIGN h-object-cd1508a = p-wgh-frame:FIRST-CHILD.
           h-object-cd1508a = h-object-cd1508a:FIRST-CHILD.

           IF VALID-HANDLE(wh-desc) THEN wh-desc:VISIBLE = NO.
           IF VALID-HANDLE(wh-perc-acres-max) THEN wh-perc-acres-max:SENSITIVE = YES.
           
     DO WHILE h-object-cd1508a <> ?:
           
        IF h-object-cd1508a:TYPE <> 'field-group' THEN DO:
           IF h-object-cd1508a:NAME = "btok" THEN DO:
              ASSIGN h-btok-ems-cd1508a = h-object-cd1508a:HANDLE.

              CREATE BUTTON h-btok-cust-cd1508a
              ASSIGN FRAME     = h-btok-ems-cd1508a:FRAME
                     COL       = h-btok-ems-cd1508a:COL 
                     ROW       = h-btok-ems-cd1508a:ROW
                     WIDTH     = h-btok-ems-cd1508a:WIDTH
                     HEIGHT    = h-btok-ems-cd1508a:HEIGHT
                     VISIBLE   = YES
                     LABEL     = h-btok-ems-cd1508a:LABEL
                     SENSITIVE = h-btok-ems-cd1508a:SENSITIVE
                     TOOLTIP   = "Confirma"

              TRIGGERS:
                  ON 'choose'             PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btOk-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
                  ON 'return'             PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btOk-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
                  ON 'mouse-select-click' PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btOk-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
              END TRIGGERS. 

              h-btok-ems-cd1508a:VISIBLE = NO.  
              h-btok-cust-cd1508a:MOVE-TO-TOP().
           END.

           IF h-object-cd1508a:NAME = "btsave" THEN DO:
              ASSIGN h-btsave-ems-cd1508a = h-object-cd1508a:HANDLE.

              CREATE BUTTON h-btsave-cust-cd1508a
              ASSIGN FRAME     = h-btsave-ems-cd1508a:FRAME
                     COL       = h-btsave-ems-cd1508a:COL 
                     ROW       = h-btsave-ems-cd1508a:ROW
                     WIDTH     = h-btsave-ems-cd1508a:WIDTH
                     HEIGHT    = h-btsave-ems-cd1508a:HEIGHT
                     VISIBLE   = YES
                     LABEL     = h-btsave-ems-cd1508a:LABEL
                     SENSITIVE = h-btsave-ems-cd1508a:SENSITIVE
                     TOOLTIP   = "Salva"

              TRIGGERS:
                  ON 'choose'             PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btSave-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
                  ON 'return'             PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btSave-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
                  ON 'mouse-select-click' PERSISTENT RUN upc\cd1508a-upc.p (INPUT "choose-btSave-cust",INPUT p-ind-object,INPUT p-wgh-object,INPUT p-wgh-frame,INPUT p-cod-table,INPUT p-row-table).  
              END TRIGGERS. 

              h-btsave-ems-cd1508a:VISIBLE = NO.
              h-btsave-cust-cd1508a:MOVE-TO-TOP().
           END.

           ASSIGN h-object-cd1508a = h-object-cd1508a:NEXT-SIBLING.
        END.
        ELSE
          ASSIGN h-object-cd1508a = h-object-cd1508a:FIRST-CHILD.
     END.

end.       


IF p-ind-event = "uso-zoom" THEN DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom= unzoom/z01un007.w
                       &campohandle=h-uf-cd1508a
                       &campozoom=estado
                       &campohandle2=h-desc-cd1508a
                       &campozoom2=no-estado
                       &proghandle=p-wgh-object }.
END.

IF p-ind-event = "leave-estado" THEN DO:
   IF VALID-HANDLE(h-uf-cd1508a) THEN
   DO:
      FIND FIRST unid-feder WHERE unid-feder.estado = h-uf-cd1508a:SCREEN-VALUE NO-LOCK NO-ERROR.
    
      IF AVAIL unid-feder THEN
         ASSIGN h-desc-cd1508a:SCREEN-VALUE = unid-feder.no-estado NO-ERROR.
      ELSE 
         ASSIGN h-desc-cd1508a:SCREEN-VALUE = "" NO-ERROR.
   END.
END.

IF p-ind-event = "before-assign" THEN DO:
   IF VALID-HANDLE(h-nr-tabpre-cd1508a) AND 
      VALID-HANDLE(h-uf-cd1508a) THEN DO:
      IF h-uf-cd1508a:SCREEN-VALUE <> "" AND 
         NOT CAN-FIND( FIRST unid-feder
                       WHERE unid-feder.estado = h-uf-cd1508a:SCREEN-VALUE) THEN DO:
          RUN utp/ut-msgs.p (INPUT "SHOW",
                             INPUT 17006,
                             INPUT "Estado informado invalido~~").
          apply "entry" to h-uf-cd1508a.
          return "NOK":U.
      END.
   END.
END.


IF p-ind-event = "after-assign" THEN DO:
   IF VALID-HANDLE(h-nr-tabpre-cd1508a) THEN DO:
      FIND tb-preco WHERE tb-preco.nr-tabpre = h-nr-tabpre-cd1508a:SCREEN-VALUE NO-LOCK NO-ERROR.
    
      IF AVAIL tb-preco THEN DO:
         FIND FIRST int-tb-preco WHERE int-tb-preco.nr-tabpre = tb-preco.nr-tabpre EXCLUSIVE-LOCK NO-ERROR.
    
         IF NOT AVAIL int-tb-preco THEN DO:
            CREATE int-tb-preco.
            ASSIGN int-tb-preco.nr-tabpre = tb-preco.nr-tabpre.
         END.
    
         ASSIGN int-tb-preco.estado         = h-uf-cd1508a:SCREEN-VALUE 
                int-tb-preco.idi-tributacao = INT(wh-trib-cd1508a:SCREEN-VALUE)  NO-ERROR.
				
				
		 IF  VALID-HANDLE(wh-perc-desc-max) 		
		 AND VALID-HANDLE(wh-log-permite-desc-coml)
         AND VALID-HANDLE(wh-perc-acres-max) 		
		 THEN DO:  
		      assign int-tb-preco.perc-desc-max            = dec(wh-perc-desc-max:SCREEN-VALUE)		
		             int-tb-preco.log-permite-desc-coml    = logical(wh-log-permite-desc-coml:SCREEN-VALUE)	 
                     int-tb-preco.perc-acres-max           = dec(wh-perc-acres-max:SCREEN-VALUE)	
		          .		
		 END.
				
      END.                                                                              
   END.
END.

IF p-ind-event = "after-display" THEN DO:

   IF VALID-HANDLE(wh-desc) THEN wh-desc:VISIBLE = NO.
   IF VALID-HANDLE(wh-perc-acres-max) THEN wh-perc-acres-max:SENSITIVE = YES.

   FIND tb-preco WHERE rowid(tb-preco) = p-row-table NO-LOCK NO-ERROR.

   IF AVAIL tb-preco THEN DO:
      FIND FIRST int-tb-preco WHERE int-tb-preco.nr-tabpre = tb-preco.nr-tabpre EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL int-tb-preco THEN DO:
         ASSIGN h-uf-cd1508a:SCREEN-VALUE = int-tb-preco.estado NO-ERROR. 

         IF VALID-HANDLE(h-uf-cd1508a) THEN DO:
            FIND unid-feder WHERE unid-feder.estado = h-uf-cd1508a:SCREEN-VALUE NO-LOCK NO-ERROR.
        
            IF AVAIL unid-feder THEN
               ASSIGN h-desc-cd1508a:SCREEN-VALUE = unid-feder.no-estado NO-ERROR.
            ELSE 
               ASSIGN h-desc-cd1508a:SCREEN-VALUE = "" NO-ERROR.
         END.

         ASSIGN h-uf-cd1508a:SCREEN-VALUE    = int-tb-preco.estado         
                wh-trib-cd1508a:SCREEN-VALUE = STRING(int-tb-preco.idi-tributacao) NO-ERROR.
				
		 IF  VALID-HANDLE(wh-perc-desc-max) 		
		 AND VALID-HANDLE(wh-log-permite-desc-coml)  
         AND VALID-HANDLE(wh-perc-acres-max)
		 THEN DO:
		      assign wh-perc-desc-max:screen-value         = string(int-tb-preco.perc-desc-max)		
		             wh-log-permite-desc-coml:screen-value = string(int-tb-preco.log-permite-desc-coml)	
                     wh-perc-acres-max:SCREEN-VALUE        = STRING(int-tb-preco.perc-acres-max) 
		          .
		     
		 END.				
				
      END.
      ELSE DO:
         ASSIGN h-uf-cd1508a:SCREEN-VALUE    = "" 
                h-desc-cd1508a:SCREEN-VALUE  = ""  
                h-uf-cd1508a:SCREEN-VALUE    = ""
                wh-trib-cd1508a:SCREEN-VALUE = "1" NO-ERROR.
				
		 assign wh-perc-desc-max:screen-value         = string(0.00)   
                wh-perc-acres-max:SCREEN-VALUE        = STRING(0.00)
		        wh-log-permite-desc-coml:screen-value = string(no) no-error.				

      END.

   END.                                                               


END.


IF p-ind-event = "choose-btOk-cust" THEN DO:
   
   IF VALID-HANDLE(h-nr-tabpre-cd1508a) AND 
      VALID-HANDLE(h-uf-cd1508a)        AND 
      VALID-HANDLE(h-btok-ems-cd1508a)  AND  
      VALID-HANDLE(h-btok-cust-cd1508a) THEN DO:
      IF h-uf-cd1508a:SCREEN-VALUE <> "" AND 
         NOT CAN-FIND( FIRST unid-feder
                       WHERE unid-feder.estado = h-uf-cd1508a:SCREEN-VALUE
                       NO-LOCK ) THEN DO:
         RUN utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 17006,
                            INPUT "Estado informado invalido~~").
         APPLY "entry" TO h-uf-cd1508a.
      END.
      ELSE
        APPLY "choose" TO h-btok-ems-cd1508a.
   END.

END.


IF p-ind-event = "choose-btSave-cust" THEN DO:

   IF VALID-HANDLE(h-nr-tabpre-cd1508a) AND 
      VALID-HANDLE(h-uf-cd1508a)        AND 
      VALID-HANDLE(h-btSave-ems-cd1508a)  AND  
      VALID-HANDLE(h-btSave-cust-cd1508a) THEN DO:
      IF h-uf-cd1508a:SCREEN-VALUE <> "" AND 
         NOT CAN-FIND( FIRST unid-feder
                       WHERE unid-feder.estado = h-uf-cd1508a:SCREEN-VALUE
                       NO-LOCK ) THEN DO:
         RUN utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 17006,
                            INPUT "Estado informado invalido~~").
         APPLY "entry" TO h-uf-cd1508a.
      END.
      ELSE
        APPLY "choose" TO h-btsave-ems-cd1508a.
   END.
END.
