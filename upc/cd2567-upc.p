/***************************************************************************
Programa      : upc/upc/cd2567-upc.p
Programa base : CD2567
VersÆo        : 2.04.000 - Desenvolvimento
******************************************************************************/
{utp/ut-glob.i}

/* Definicao de parametros */    
DEF           INPUT PARAM p-ind-event                    AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-ind-object                   AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-wgh-object                   AS HANDLE        NO-UNDO.
DEF           INPUT PARAM p-wgh-frame                    AS WIDGET-HANDLE NO-UNDO.
DEF           INPUT PARAM p-cod-table                    AS CHAR          NO-UNDO.
DEF           INPUT PARAM p-row-table                    AS ROWID         NO-UNDO.
DEF                   VAR c-objeto                       AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-cd2567-cod-itiner            AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-pto-embarque          AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-cd2567-flg-integra-comex     AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-flg-integra-comex-txt AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-cd2567-instrucao-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-embarque2-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada1-txt          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada2-txt          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-liberacao-txt         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-emissao-nf-txt        AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-cd2567-instrucao             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-embarque2             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada1              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada2              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-liberacao             AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-emissao-nf            AS HANDLE        NO-UNDO.
                                                                         
DEF NEW GLOBAL SHARED VAR h-cd2567-instrucao-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-embarque2-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada1-nom          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-chegada2-nom          AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-liberacao-nom         AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd2567-emissao-nf-nom        AS HANDLE        NO-UNDO.


DEF VAR i AS i      NO-UNDO. 
DEF VAR h AS HANDLE NO-UNDO. 
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

IF  p-ind-event  = "BEFORE-INITIALIZE" 
AND p-ind-object = "CONTAINER" 
THEN DO:

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "cod-itiner",
                       OUTPUT h-cd2567-cod-itiner).
    
   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "pto-embarque",
                       OUTPUT h-cd2567-pto-embarque).

   CREATE TEXT h-cd2567-flg-integra-comex-txt
   ASSIGN 
       FRAME        = p-wgh-frame
       FORMAT       = "x(25)"
       WIDTH        = 14
       SCREEN-VALUE = "Integra COMEX"
       ROW          = h-cd2567-pto-embarque:ROW + .3
       COL          = h-cd2567-pto-embarque:COL + 44.5
       VISIBLE      = YES.

   CREATE TOGGLE-BOX h-cd2567-flg-integra-comex
   ASSIGN 
       FRAME        = p-wgh-frame
       WIDTH        = 2
       ROW          = h-cd2567-pto-embarque:ROW + .2
       COL          = h-cd2567-pto-embarque:COL + 42
       VISIBLE      = YES.

   RUN pi_busca_widget (INPUT p-wgh-frame,
                        INPUT "wMasterDetail",
                       OUTPUT h).

   h =  p-wgh-frame:WINDOW.
   h:HEIGHT = h:HEIGHT + 7.
//   h:WIDTH  = h:WIDTH  + 7.
   p-wgh-frame:HEIGHT = p-wgh-frame:HEIGHT + 7.

   ASSIGN
      l = "brSon1,i-cdn-pto-solic-licenciam-import,cDescPtoLI,pto-embarque,FILL-IN-2,int-1,FILL-IN-5,"
        + "pto-desembarque,FILL-IN-3,i-cdn-pto-recebimento,FILL-IN-6,pto-chegada,FILL-IN-4,"
        + "rtParent,rtToolBar,pto-despacho,FILL-IN-1".
   DO i = 1 TO NUM-ENTRIES(l):
      RUN pi_busca_widget (INPUT p-wgh-frame,
                           INPUT ENTRY(i,l),
                          OUTPUT h).
      IF ENTRY(i,l) = "brSon1" 
      THEN ASSIGN
         f     = h:FRAME
         f:ROW = f:ROW + 7.

      IF ENTRY(i,l) = "rtParent"
      THEN ASSIGN
         h:HEIGHT = h:HEIGHT + 6.5.


      IF LOOKUP(ENTRY(i,l),"pto-despacho,FILL-IN-1") > 0
      THEN DO:
         ASSIGN
            h:ROW = h:ROW + 2.
         IF ENTRY(i,l) = "pto-despacho"
         THEN ASSIGN
            h = h:SIDE-LABEL-HANDLE
            h:ROW = h:ROW + 2.
      END.
      

      IF ENTRY(i,l) = "cDescPtoLI"
      THEN ASSIGN
         h:ROW = h:ROW - 1.
      
      IF LOOKUP(ENTRY(i,l),"i-cdn-pto-solic-licenciam-import") > 0
      THEN DO:

          ASSIGN
             h:ROW = h:ROW - 1
             .

          CREATE FILL-IN h-cd2567-instrucao
          ASSIGN 
              FRAME              = p-wgh-frame
              DATA-TYPE          = "integer"
              FORMAT             = ">>>>>9"
              WIDTH              = h:WIDTH 
              HEIGHT             = 0.88
              ROW                = h:ROW + 1
              COL                = h:COL
              VISIBLE            = YES
              SENSITIVE          = NO.
          CREATE FILL-IN h-cd2567-instrucao-nom
          ASSIGN 
             FRAME              = p-wgh-frame
             DATA-TYPE          = "character"
             FORMAT             = "x(80)" 
             WIDTH              = 29.2
             HEIGHT             = 0.88
             ROW                = h:ROW + 1
             COL                = h:COL + 7
             VISIBLE            = YES
             SENSITIVE          = NO.

          
          CREATE TEXT h-cd2567-instrucao-txt
          ASSIGN 
              FRAME        = p-wgh-frame
              FORMAT       = "x(22)"
              WIDTH        = 11
              SCREEN-VALUE = "Ponto Instru‡Æo:"
              ROW          = h:ROW + 1
              COL          = h:COL - 12
              VISIBLE      = YES.

          ASSIGN
             h              = h:SIDE-LABEL-HANDLE
             h:SCREEN-VALUE = "Comercial Invoice"
             h:ROW          = h:ROW - 1.

      END.
      
      
      IF LOOKUP(ENTRY(i,l),"pto-embarque,FILL-IN-2") > 0
      THEN DO:
          ASSIGN
             h:ROW = h:ROW + 1.
          IF ENTRY(i,l) = "pto-embarque"
          THEN DO:

             ASSIGN
                h:LABEL = "Ponto Embarque 1".
             CREATE FILL-IN h-cd2567-embarque2
             ASSIGN 
                 FRAME              = p-wgh-frame
                 DATA-TYPE          = "integer"
                 FORMAT             = ">>>>>9" 
                 WIDTH              = h:WIDTH 
                 HEIGHT             = 0.88
                 ROW                = h:ROW + 1
                 COL                = h:COL
                 VISIBLE            = YES
                 SENSITIVE          = NO.
   
             CREATE FILL-IN h-cd2567-chegada1
             ASSIGN 
                 FRAME              = p-wgh-frame
                 DATA-TYPE          = "integer"
                 FORMAT             = ">>>>>9" 
                 WIDTH              = h:WIDTH 
                 HEIGHT             = 0.88
                 ROW                = h:ROW + 2
                 COL                = h:COL
                 VISIBLE            = YES
                 SENSITIVE          = NO.
   
             CREATE FILL-IN h-cd2567-chegada2
             ASSIGN 
                 FRAME              = p-wgh-frame
                 DATA-TYPE          = "integer"
                 FORMAT             = ">>>>>9" 
                 WIDTH              = h:WIDTH 
                 HEIGHT             = 0.88
                 ROW                = h:ROW + 3
                 COL                = h:COL
                 VISIBLE            = YES
                 SENSITIVE          = NO.
   
   
             CREATE FILL-IN h-cd2567-embarque2-nom
             ASSIGN 
                FRAME              = p-wgh-frame
                DATA-TYPE          = "character"
                FORMAT             = "x(80)"
                WIDTH              = 29.2
                HEIGHT             = 0.88
                ROW                = h:ROW + 1
                COL                = h:COL + 7
                VISIBLE            = YES
                SENSITIVE          = NO.
   
             CREATE FILL-IN h-cd2567-chegada1-nom
             ASSIGN 
                FRAME              = p-wgh-frame
                DATA-TYPE          = "character"
                FORMAT             = "x(80)"
                WIDTH              = 29.2
                HEIGHT             = 0.88
                ROW                = h:ROW + 2
                COL                = h:COL + 7
                VISIBLE            = YES
                SENSITIVE          = NO.
   
             CREATE FILL-IN h-cd2567-chegada2-nom
             ASSIGN 
                FRAME              = p-wgh-frame
                DATA-TYPE          = "character"
                FORMAT             = "x(80)"
                WIDTH              = 29.2
                HEIGHT             = 0.88
                ROW                = h:ROW + 3
                COL                = h:COL + 7
                VISIBLE            = YES
                SENSITIVE          = NO.
   
   
             h = h:SIDE-LABEL-HANDLE.
             h:ROW = h:ROW + 1.
             CREATE TEXT h-cd2567-embarque2-txt
             ASSIGN 
                 FRAME        = p-wgh-frame
                 FORMAT       = "x(25)"
                 WIDTH        = 14
                 SCREEN-VALUE = "Ponto Embarque 2:"
                 ROW          = h:ROW + 1
                 COL          = h:COL - 1
                 VISIBLE      = YES.
   
             CREATE TEXT h-cd2567-chegada1-txt
             ASSIGN 
                 FRAME        = p-wgh-frame
                 FORMAT       = "x(25)"
                 WIDTH        = 13
                 SCREEN-VALUE = "Ponto Chegada 1:"
                 ROW          = h:ROW + 2
                 COL          = h:COL 
                 VISIBLE      = YES.
             CREATE TEXT h-cd2567-chegada1-txt
             ASSIGN 
                 FRAME        = p-wgh-frame
                 FORMAT       = "x(25)"
                 WIDTH        = 13
                 SCREEN-VALUE = "Ponto Chegada 2:"
                 ROW          = h:ROW + 3
                 COL          = h:COL 
                 VISIBLE      = YES.
          END.
      END.

      IF LOOKUP(ENTRY(i,l),"int-1,FILL-IN-5") > 0
      THEN DO:
         ASSIGN
            h:ROW = h:ROW + 4.
         IF ENTRY(i,l) = "int-1"
         THEN ASSIGN
            h = h:SIDE-LABEL-HANDLE
            h:ROW = h:ROW + 4.
      END.

      IF LOOKUP(ENTRY(i,l),"pto-desembarque,FILL-IN-3") > 0
      THEN DO:
         ASSIGN
            h:ROW = h:ROW + 4.
         IF ENTRY(i,l) = "pto-desembarque"
         THEN DO:
            CREATE FILL-IN h-cd2567-liberacao
            ASSIGN 
               FRAME              = p-wgh-frame
               DATA-TYPE          = "integer"
               FORMAT             = ">>>>>9" 
               WIDTH              = h:WIDTH
               HEIGHT             = 0.88
               ROW                = h:ROW + 1
               COL                = h:COL
               VISIBLE            = YES
               SENSITIVE          = NO.
            CREATE FILL-IN h-cd2567-liberacao-nom
            ASSIGN 
               FRAME              = p-wgh-frame
               DATA-TYPE          = "character"
               FORMAT             = "x(80)"
               WIDTH              = 29.2
               HEIGHT             = 0.88
               ROW                = h:ROW + 1
               COL                = h:COL + 7
               VISIBLE            = YES
               SENSITIVE          = NO.

            ASSIGN
               h = h:SIDE-LABEL-HANDLE
               h:ROW = h:ROW + 4.
            CREATE TEXT h-cd2567-liberacao-txt
            ASSIGN 
                FRAME        = p-wgh-frame
                FORMAT       = "x(25)"
                WIDTH        = 7
                SCREEN-VALUE = "Libera‡Æo:"
                ROW          = h:ROW + 1
                COL          = h:COL + 8
                VISIBLE      = YES.
         END.
      END.

      IF LOOKUP(ENTRY(i,l),"i-cdn-pto-recebimento,FILL-IN-6") > 0
      THEN DO:
         ASSIGN
            h:ROW = h:ROW + 5.
         IF ENTRY(i,l) = "i-cdn-pto-recebimento"
         THEN ASSIGN
            h = h:SIDE-LABEL-HANDLE
            h:ROW = h:ROW + 5.
      END.


      IF LOOKUP(ENTRY(i,l),"pto-chegada,FILL-IN-4") > 0
      THEN DO:
         ASSIGN
            h:ROW = h:ROW + 5.
         IF ENTRY(i,l) = "pto-chegada"
         THEN DO:
            CREATE FILL-IN h-cd2567-emissao-nf
            ASSIGN 
               FRAME              = p-wgh-frame
               DATA-TYPE          = "integer"
               FORMAT             = ">>>>>9" 
               WIDTH              = h:WIDTH
               HEIGHT             = 0.88
               ROW                = h:ROW + 1
               COL                = h:COL
               VISIBLE            = YES
               SENSITIVE          = NO.
            CREATE FILL-IN h-cd2567-emissao-nf-nom
            ASSIGN 
               FRAME              = p-wgh-frame
               DATA-TYPE          = "character"
               FORMAT             = "x(80)"
               WIDTH              = 29.2
               HEIGHT             = 0.88
               ROW                = h:ROW + 1
               COL                = h:COL + 7
               VISIBLE            = YES
               SENSITIVE          = NO.

            ASSIGN
               h = h:SIDE-LABEL-HANDLE
               h:ROW = h:ROW + 5.
            CREATE TEXT h-cd2567-emissao-nf-txt
            ASSIGN 
                FRAME        = p-wgh-frame
                FORMAT       = "x(25)"
                WIDTH        = 11
                SCREEN-VALUE = "EmissÆo da NF:"
                ROW          = h:ROW + 1
                COL          = h:COL + 10
                VISIBLE      = YES.

         END.
      END.
/*
      MESSAGE ENTRY(i,l) VALID-HANDLE(h)
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/          
   END.

END.

IF  p-ind-event  = "AFTER-DISPLAY"       
AND p-ind-object = "CONTAINER"        
THEN DO:
   ASSIGN 
      h-cd2567-flg-integra-comex:CHECKED      = NO
      h-cd2567-instrucao        :SCREEN-VALUE = "" 
      h-cd2567-embarque2        :SCREEN-VALUE = "" 
      h-cd2567-chegada1         :SCREEN-VALUE = "" 
      h-cd2567-chegada2         :SCREEN-VALUE = "" 
      h-cd2567-liberacao        :SCREEN-VALUE = "" 
      h-cd2567-emissao-nf       :SCREEN-VALUE = "" 
       
      h-cd2567-instrucao-nom   :SCREEN-VALUE = "" 
      h-cd2567-embarque2-nom   :SCREEN-VALUE = "" 
      h-cd2567-chegada1-nom    :SCREEN-VALUE = "" 
      h-cd2567-chegada2-nom    :SCREEN-VALUE = "" 
      h-cd2567-liberacao-nom   :SCREEN-VALUE = "" 
      h-cd2567-emissao-nf-nom  :SCREEN-VALUE = "" 
      .
   FIND FIRST itinerario NO-LOCK 
        WHERE ROWID(itinerario) = p-row-table 
        NO-ERROR.
   IF AVAIL itinerario 
   THEN DO:
       FIND FIRST int-itinerario NO-LOCK
            WHERE int-itinerario.cod-itiner = itinerario.cod-itiner
            NO-ERROR.

       IF AVAIL int-itinerario 
       THEN ASSIGN
          h-cd2567-flg-integra-comex:CHECKED      = int-itinerario.log-integra-comex
          
          h-cd2567-instrucao        :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-instrucao ,">>>>>9")
          h-cd2567-embarque2        :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-embarque2 ,">>>>>9")
          h-cd2567-chegada1         :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-chegada1  ,">>>>>9")
          h-cd2567-chegada2         :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-chegada2  ,">>>>>9")
          h-cd2567-liberacao        :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-liberacao ,">>>>>9")
          h-cd2567-emissao-nf       :SCREEN-VALUE = STRING(int-itinerario.cdn-pto-emissao-nf,">>>>>9") 
          .

       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-instrucao:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-instrucao-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-embarque2:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-embarque2-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-chegada1:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-chegada1-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-chegada2:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-chegada2-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-liberacao:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-liberacao-nom    :SCREEN-VALUE = pto-contr.descricao.
       FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = h-cd2567-emissao-nf:INPUT-VALUE
            NO-ERROR.
       IF AVAIL pto-contr
       THEN ASSIGN
          h-cd2567-emissao-nf-nom    :SCREEN-VALUE = pto-contr.descricao.

       /*
       IF AVAIL int-itinerario 
       THEN MESSAGE 
          int-itinerario.cdn-pto-instrucao  h-cd2567-instrucao       :SCREEN-VALUE h-cd2567-instrucao-nom   :SCREEN-VALUE   SKIP
          int-itinerario.cdn-pto-embarque2  h-cd2567-embarque2       :SCREEN-VALUE h-cd2567-embarque2-nom   :SCREEN-VALUE   SKIP
          int-itinerario.cdn-pto-chegada1   h-cd2567-chegada1        :SCREEN-VALUE h-cd2567-chegada1-nom    :SCREEN-VALUE   SKIP
          int-itinerario.cdn-pto-chegada2   h-cd2567-chegada2        :SCREEN-VALUE h-cd2567-chegada2-nom    :SCREEN-VALUE   SKIP
          int-itinerario.cdn-pto-liberacao  h-cd2567-liberacao       :SCREEN-VALUE h-cd2567-liberacao-nom   :SCREEN-VALUE   SKIP
          int-itinerario.cdn-pto-emissao-nf h-cd2567-emissao-nf      :SCREEN-VALUE h-cd2567-emissao-nf-nom  :SCREEN-VALUE   
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       */
   END.
END.

IF  p-ind-event  = "BEFORE-DELETE" 
AND p-ind-object = "CONTAINER" 
THEN DO:
   IF p-cod-table = "pto-itiner" 
   THEN DO:
      FIND FIRST pto-itiner NO-LOCK
           WHERE ROWID(pto-itiner) = p-row-table
           NO-ERROR.
      IF AVAIL pto-itiner
      THEN DO:
         FIND FIRST int-itinerario 
              WHERE int-itinerario.cod-itiner = pto-itiner.cod-itiner
              NO-ERROR.
         IF AVAIL int-itinerario
         THEN DO:
            IF int-itinerario.cdn-pto-instrucao  = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-instrucao  = 0.
            IF int-itinerario.cdn-pto-embarque2  = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-embarque2  = 0.
            IF int-itinerario.cdn-pto-chegada1   = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-chegada1   = 0.
            IF int-itinerario.cdn-pto-chegada2   = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-chegada2   = 0.
            IF int-itinerario.cdn-pto-liberacao  = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-liberacao  = 0.
            IF int-itinerario.cdn-pto-emissao-nf = pto-itiner.cod-pto-contr
            THEN ASSIGN
               int-itinerario.cdn-pto-emissao-nf = 0.
         END.
      END.
   END.
END.

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

