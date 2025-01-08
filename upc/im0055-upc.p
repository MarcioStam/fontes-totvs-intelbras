/***************************************************************************
Programa      : upc/upc/cd2567-upc.p
Programa base : CD2567
VersÆo        : 2.04.000 - Desenvolvimento
******************************************************************************/
//{utp/ut-glob.i}


/* Definicao de parametros */    
DEF           INPUT PARAM p-ind-event                    AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-ind-object                   AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-wgh-object                   AS HANDLE        NO-UNDO.
DEF           INPUT PARAM p-wgh-frame                    AS WIDGET-HANDLE NO-UNDO.
DEF           INPUT PARAM p-cod-table                    AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-row-table                    AS ROWID         NO-UNDO.
DEF                   VAR c-objeto                       AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-im0055-pto-embarque          AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-im0055-instrucao-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-embarque2-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada1-txt          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada2-txt          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-liberacao-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-emissao-nf-txt        AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-im0055-instrucao             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-embarque2             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada1              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada2              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-liberacao             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-emissao-nf            AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-im0055-instrucao-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-embarque2-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada1-nom          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-chegada2-nom          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-liberacao-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-im0055-emissao-nf-nom        AS HANDLE        NO-UNDO.

DEF VAR w AS HANDLE NO-UNDO. 
DEF VAR i AS i      NO-UNDO. 
DEF VAR h AS HANDLE NO-UNDO. 
DEF VAR j AS HANDLE NO-UNDO. 
DEF VAR f AS HANDLE NO-UNDO. 
DEF VAR l AS c      NO-UNDO. 

ASSIGN 
   c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"),p-wgh-object:PRIVATE-DATA, "~/")
   c-objeto = ENTRY(NUM-ENTRIES(c-objeto, "~\"), c-objeto, "~\")
   c-objeto = REPLACE(c-objeto, "'", "").

/*
MESSAGE "EVENTO" p-ind-event  SKIP
        "OBJETO" p-ind-object SKIP
        "NOME OBJ" c-objeto   SKIP
        "FRAME" p-wgh-frame   SKIP
        "TABELA" p-cod-table  SKIP
        "ROWID" string(p-row-table) 
        VIEW-AS ALERT-BOX.
*/


IF  p-ind-event  = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" 
THEN DO:

   h                  =  p-wgh-frame:WINDOW.
//   h:HEIGHT           = h:HEIGHT + 7.
   h:WIDTH            = h:WIDTH  + 27.
//   p-wgh-frame:HEIGHT = p-wgh-frame:HEIGHT + 7.
   p-wgh-frame:WIDTH  = p-wgh-frame:WIDTH  + 30.

   w = h.

   RUN pi_busca_widget (w,
                        INPUT "wMasterDetail",
                       OUTPUT h).

   ASSIGN
      l = "fPage0,brSon1,brSon2,brSon3,cod-estabel,embarque,cod-itiner,FILL-IN-1,i-pto-despch,c-desc-pto-despch,"
        + "FILL-IN-2,FILL-IN-3,FILL-IN-4,FILL-IN-5,i-pto-chegad,c-desc-pto-chegad,i-dias-total,c-ato-concessorio,rtParent,rtToolBar,"
        + "bt-vincula-drb,bt-calc-desp-itiner,btLoad,btQueryJoins,btReportsJoins,btExit,btHelp"
      .

   DO i = 1 TO NUM-ENTRIES(l):
      /*
      RUN pi_busca_widget (INPUT p-wgh-frame,
                           INPUT ENTRY(i,l),
                          OUTPUT h).
      */                          
      RUN pi_busca_widget (INPUT w,
                           INPUT ENTRY(i,l),
                          OUTPUT h).

/*
      MESSAGE ENTRY(i,l) VALID-HANDLE(h)
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/        
      IF NOT VALID-HANDLE(h) 
      THEN NEXT.

      IF ENTRY(i,l) BEGINS "bt" 
      THEN ASSIGN
         h:COL = h:COL + 28.
      

      IF ENTRY(i,l) = "brSon1" 
      OR ENTRY(i,l) = "brSon2" 
      OR ENTRY(i,l) = "brSon3" 
      THEN ASSIGN
         f     = h:FRAME
//         f:ROW = f:ROW + 7
         .

      IF ENTRY(i,l) = "fPage2" 
//      OR ENTRY(i,l) = "brSon2" 
//      OR ENTRY(i,l) = "brSon3" 
      THEN ASSIGN
//         h:ROW = h:ROW + 7
         .

      IF LOOKUP(ENTRY(i,l),"rtParent,rtToolBar") > 0
      THEN ASSIGN
         h:WIDTH = h:WIDTH + 28
         .

      IF LOOKUP(ENTRY(i,l),"cod-estabel,embarque,cod-itiner,i-pto-despch,FILL-IN-2") > 0
      THEN DO:
         IF ENTRY(i,l) = "FILL-IN-2" 
         THEN ASSIGN
            h:LABEL    = "Ponto Embarque 1".
         ASSIGN
            h:COL = 15
            j     = h:SIDE-LABEL-HANDLE
            j:COL = 2.
      END.

      IF LOOKUP(ENTRY(i,l),"FILL-IN-1,c-desc-pto-despch,FILL-IN-3") > 0
      THEN ASSIGN
         h:COL = 22
         .

      IF LOOKUP(ENTRY(i,l),"FILL-IN-4,i-pto-chegad,i-dias-total") > 0
      THEN ASSIGN
         h:COL = 78
         j     = h:SIDE-LABEL-HANDLE
         j:COL = 55.

      IF LOOKUP(ENTRY(i,l),"FILL-IN-5,c-desc-pto-chegad") > 0
      THEN ASSIGN
         h:COL = 85.

      IF LOOKUP(ENTRY(i,l),"FILL-IN-2,FILL-IN-3") > 0
      THEN DO:
         ASSIGN
            h:ROW = 7.42.
         
         IF ENTRY(i,l) = "FILL-IN-2" 
         THEN ASSIGN
            j     = h:SIDE-LABEL-HANDLE
            j:ROW = 7.42.
      END.
      
  
      IF LOOKUP(ENTRY(i,l),"FILL-IN-4,FILL-IN-5") > 0
      THEN DO:
         ASSIGN
            h:ROW = 6.5. 
         IF ENTRY(i,l) = "FILL-IN-4" 
         THEN ASSIGN
            j     = h:SIDE-LABEL-HANDLE
            j:ROW = 6.5. 
      END.
 
      IF LOOKUP(ENTRY(i,l),"i-pto-chegad,c-desc-pto-chegad") > 0
      THEN DO:
         ASSIGN
            h:ROW = 7.42.
         IF ENTRY(i,l) = "i-pto-chegad" 
         THEN ASSIGN
            j     = h:SIDE-LABEL-HANDLE
            j:ROW = 7.42.
      END.
      
   END.
/*
   DO i = 1 TO NUM-ENTRIES(l):
      MESSAGE 
          ENTRY(i,l) 
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   END.
*/
   CREATE FILL-IN h-im0055-instrucao
   ASSIGN 
       FRAME              = p-wgh-frame
       DATA-TYPE          = "integer"
       FORMAT             = ">>>>>9"
       WIDTH              = 6.6
       HEIGHT             = 0.88
       ROW                = 6.5
       COL                = 15
       VISIBLE            = YES
       SENSITIVE          = NO.
   CREATE FILL-IN h-im0055-instrucao-nom
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)" 
      WIDTH              = 32
      HEIGHT             = 0.88
      ROW                = 6.5
      COL                = 22
      VISIBLE            = YES
      SENSITIVE          = NO.
   CREATE TEXT h-im0055-instrucao-txt
   ASSIGN 
       FRAME             = p-wgh-frame
       FORMAT            = "x(22)"
       WIDTH             = 11
       SCREEN-VALUE      = "Ponto Instru‡Æo:"
       ROW               = 6.5
       COL               = 2
       VISIBLE           = YES.


   CREATE FILL-IN h-im0055-embarque2
   ASSIGN 
       FRAME              = p-wgh-frame
       DATA-TYPE          = "integer"
       FORMAT             = ">>>>>9" 
       WIDTH              = 6.6
       HEIGHT             = 0.88
       ROW                = 8.33
       COL                = 15
       VISIBLE            = YES
       SENSITIVE          = NO.

   CREATE FILL-IN h-im0055-embarque2-nom
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)"
      WIDTH              = 32
      HEIGHT             = 0.88
      ROW                = 8.33
      COL                = 22
      VISIBLE            = YES
      SENSITIVE          = NO.

   CREATE TEXT h-im0055-embarque2-txt
   ASSIGN 
       FRAME             = p-wgh-frame
       FORMAT            = "x(25)"
       WIDTH             = 13
       SCREEN-VALUE      = "Ponto Embarque 2:"
       ROW               = 8.33
       COL               = 2
       VISIBLE           = YES.



   CREATE FILL-IN h-im0055-chegada1
   ASSIGN 
       FRAME              = p-wgh-frame
       DATA-TYPE          = "integer"
       FORMAT             = ">>>>>9" 
       WIDTH              = 6.6
       HEIGHT             = 0.88
       ROW                = 9.25
       COL                = 15
       VISIBLE            = YES
       SENSITIVE          = NO.

   CREATE FILL-IN h-im0055-chegada1-nom
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)"
      WIDTH              = 32
      HEIGHT             = 0.89
      ROW                = 9.25
      COL                = 22
      VISIBLE            = YES
      SENSITIVE          = NO.

   CREATE TEXT h-im0055-chegada1-txt
   ASSIGN 
       FRAME             = p-wgh-frame
       FORMAT            = "x(25)"
       WIDTH             = 13
       SCREEN-VALUE      = "Ponto Chegada 1:"
       ROW               = 9.25
       COL               = 2
       VISIBLE           = YES.


   CREATE FILL-IN h-im0055-chegada2
   ASSIGN 
       FRAME              = p-wgh-frame
       DATA-TYPE          = "integer"
       FORMAT             = ">>>>>9" 
       WIDTH              = 6.6
       HEIGHT             = 0.88
       ROW                = 4.67
       COL                = 78
       VISIBLE            = YES
       SENSITIVE          = NO.
   
   CREATE FILL-IN h-im0055-chegada2-nom
   ASSIGN               
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)"
      WIDTH              = 32
      HEIGHT             = 0.88
      ROW                = 4.67
      COL                = 85
      VISIBLE            = YES
      SENSITIVE          = NO.
   
   CREATE TEXT h-im0055-chegada2-txt
   ASSIGN 
       FRAME        = p-wgh-frame
       FORMAT       = "x(25)"
       WIDTH        = 13
       SCREEN-VALUE = "Ponto Chegada 2:"
       ROW          = 4.67
       COL          = 55
       VISIBLE      = YES.
   
   CREATE FILL-IN h-im0055-liberacao
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "integer"
      FORMAT             = ">>>>>9" 
      WIDTH              = 6.6
      HEIGHT             = 0.88
      ROW                = 5.58
      COL                = 78
      VISIBLE            = YES
      SENSITIVE          = NO.
   CREATE FILL-IN h-im0055-liberacao-nom
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)"
      WIDTH              = 32
      HEIGHT             = 0.88
      ROW                = 5.58
      COL                = 85
      VISIBLE            = YES
      SENSITIVE          = NO.
   CREATE TEXT h-im0055-liberacao-txt
   ASSIGN 
       FRAME             = p-wgh-frame
       FORMAT            = "x(25)"
       WIDTH             = 7
       SCREEN-VALUE      = "Libera‡Æo:"
       ROW               = 5.58
       COL               = 55
       VISIBLE           = YES.
   
   CREATE FILL-IN h-im0055-emissao-nf
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "integer"
      FORMAT             = ">>>>>9" 
      WIDTH              = 6.6
      HEIGHT             = 0.88
      ROW                = 8.33
      COL                = 78
      VISIBLE            = YES
      SENSITIVE          = NO.
   CREATE FILL-IN h-im0055-emissao-nf-nom
   ASSIGN 
      FRAME              = p-wgh-frame
      DATA-TYPE          = "character"
      FORMAT             = "x(80)"
      WIDTH              = 32
      HEIGHT             = 0.88
      ROW                = 8.33
      COL                = 85
      VISIBLE            = YES
      SENSITIVE          = NO.
   CREATE TEXT h-im0055-emissao-nf-txt
   ASSIGN 
       FRAME             = p-wgh-frame
       FORMAT            = "x(25)"
       WIDTH             = 11
       SCREEN-VALUE      = "EmissÆo da NF:"
       ROW               = 8.33
       COL               = 55
       VISIBLE           = YES.
   
END.

/**/
IF  p-ind-event  = "AFTER-DISPLAY"       
AND p-ind-object = "CONTAINER"        
AND VALID-HANDLE(h-im0055-instrucao)
THEN DO:
   ASSIGN 
      h-im0055-instrucao        :SCREEN-VALUE = ""   
      h-im0055-embarque2        :SCREEN-VALUE = ""   
      h-im0055-chegada1         :SCREEN-VALUE = ""   
      h-im0055-chegada2         :SCREEN-VALUE = ""   
      h-im0055-liberacao        :SCREEN-VALUE = ""   
      h-im0055-emissao-nf       :SCREEN-VALUE = ""   
                                                     
      h-im0055-instrucao-nom    :SCREEN-VALUE = ""   
      h-im0055-embarque2-nom    :SCREEN-VALUE = ""   
      h-im0055-chegada1-nom     :SCREEN-VALUE = ""   
      h-im0055-chegada2-nom     :SCREEN-VALUE = ""   
      h-im0055-liberacao-nom    :SCREEN-VALUE = ""   
      h-im0055-emissao-nf-nom   :SCREEN-VALUE = ""   
      .

   
   FIND FIRST historico-embarque NO-LOCK
        WHERE ROWID(historico-embarque) = p-row-table
        NO-ERROR.
   FIND FIRST embarque-imp NO-LOCK 
        WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
          AND embarque-imp.embarque    = historico-embarque.embarque
        NO-ERROR.
   IF AVAIL embarque-imp
   THEN DO:
       FIND FIRST ext-embarque-imp NO-LOCK
            WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
              AND ext-embarque-imp.embarque    = embarque-imp.embarque
            NO-ERROR.
       IF AVAIL ext-embarque-imp 
       THEN ASSIGN
          h-im0055-instrucao        :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-instrucao ,">>>>>9")
          h-im0055-embarque2        :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-embarque2 ,">>>>>9")
          h-im0055-chegada1         :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-chegada1  ,">>>>>9")
          h-im0055-chegada2         :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-chegada2  ,">>>>>9")
          h-im0055-liberacao        :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-liberacao ,">>>>>9")
          h-im0055-emissao-nf       :SCREEN-VALUE = STRING(ext-embarque-imp.cdn-pto-emissao-nf,">>>>>9") 
          .

       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-instrucao:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-instrucao-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-embarque2:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-embarque2-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-chegada1:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-chegada1-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-chegada2:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-chegada2-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-liberacao:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-liberacao-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-im0055-emissao-nf:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-im0055-emissao-nf-nom    :SCREEN-VALUE = pto-contr.descricao.

       /*
       IF AVAIL ext-embarque-imp 
       THEN MESSAGE 
          ext-embarque-imp.cdn-pto-instrucao  h-im0055-instrucao       :SCREEN-VALUE h-im0055-instrucao-nom   :SCREEN-VALUE   SKIP
          ext-embarque-imp.cdn-pto-embarque2  h-im0055-embarque2       :SCREEN-VALUE h-im0055-embarque2-nom   :SCREEN-VALUE   SKIP
          ext-embarque-imp.cdn-pto-chegada1   h-im0055-chegada1        :SCREEN-VALUE h-im0055-chegada1-nom    :SCREEN-VALUE   SKIP
          ext-embarque-imp.cdn-pto-chegada2   h-im0055-chegada2        :SCREEN-VALUE h-im0055-chegada2-nom    :SCREEN-VALUE   SKIP
          ext-embarque-imp.cdn-pto-liberacao  h-im0055-liberacao       :SCREEN-VALUE h-im0055-liberacao-nom   :SCREEN-VALUE   SKIP
          ext-embarque-imp.cdn-pto-emissao-nf h-im0055-emissao-nf      :SCREEN-VALUE h-im0055-emissao-nf-nom  :SCREEN-VALUE   
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       */

   END.
   
END.
/**/
RETURN "OK".

PROCEDURE pi_busca_widget:
    DEF INPUT  PARAM p_wh_frame     AS WIDGET-HANDLE    NO-UNDO.
    DEF INPUT  PARAM p_nome_obj     AS CHARACTER        NO-UNDO.
    DEF OUTPUT PARAM p_wh_objeto    AS WIDGET-HANDLE    NO-UNDO.

    DEF VAR h_hwd                   AS WIDGET-HANDLE    NO-UNDO.
                                     
    ASSIGN 
       h_hwd       = p_wh_frame:FIRST-CHILD
       p_wh_objeto = ?.

    DO WHILE VALID-HANDLE(h_hwd):
       IF  h_hwd:TYPE <> "field-group" 
       AND h_hwd:TYPE <> "frame"       
       THEN DO:
          IF h_hwd:NAME = p_nome_obj 
          THEN DO:
             ASSIGN 
                p_wh_objeto = h_hwd.
             LEAVE.
          END. /* if h_hwd:name = p_nome_obj */
       END.
       ELSE DO:
          IF h_hwd:NAME = p_nome_obj 
          THEN DO:
              ASSIGN 
                 p_wh_objeto = h_hwd.
              LEAVE.
          END. /* if h_hwd:name = p_nome_obj */

          RUN pi_busca_widget (INPUT h_hwd,
                               INPUT p_nome_obj,
                               OUTPUT p_wh_objeto).

          IF  VALID-HANDLE(p_wh_objeto) 
          THEN RETURN.
       END. /* else if h_hwd:name = p_nome_obj */

       ASSIGN 
          h_hwd = h_hwd:NEXT-SIBLING.
    END. /* do while valid-handle(h_hwd) */
END PROCEDURE. /* pi_busca_widget */

