/***********************************************************************
**  Programa..: UPC\CC0523-UPC.P
**  Autor.....: Clayton Antunes
**  Data......: novembro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 04/10/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-browse                 AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-query                  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-objeto                  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-buffer                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-it-codigo               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtdisponivel           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-situacao-portal-cd0401 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-natureza               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-folder                AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-add                     AS LOGICAL       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-emitente-cd0401        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cgc-cd0401             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-nr-passaporte-cd0401 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-grupo-cd0401           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-matriz-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-natureza-cd0401        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-ativo-cd0401       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ativo-cd0401           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-atualiz-cd0401     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-atualiz-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ativo-cd0401        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-emite-etiq-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-vencto-util-cd0401  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bairro-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cd0401              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario             AS CHARACTER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-motivo-cd0401           AS CHARACTER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-email-cd0401           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-telefone-cd0401        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-transp                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-uf                     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cgc                    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pais                   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-emitente               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-cep-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-end-cd0401             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-end-completo-cd0401    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-t-end-compl-cd0401     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-logradouro-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-numero-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-complemento-cd0401     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-logradouro-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-numero-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-complemento-cd0401     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-uf-cd0401              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cidade-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cep-cd0401             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bairro-cd0401          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whdata-implant            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-browser                 AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-idi-sit-fornec-cd0401  AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cd0401                 AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-dat-vigenc-ini-cd0401 AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dt-dat-vigenc-fim-cd0401 AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cond-pag-cd0401        AS HANDLE        NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-nome-abrev-cd0401      AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-ariba-acm-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-ariba-acm-cd0401      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ariba-an-cd0401       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-ariba-an-cd0401       AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE h-campo          AS HANDLE EXTENT 10 NO-UNDO.
DEFINE VARIABLE c-objeto         AS CHAR             NO-UNDO.
DEFINE VARIABLE h-frame          AS HANDLE           NO-UNDO.
DEFINE VARIABLE wgh-grupo        AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE h-objeto-aux     AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE colhdl           AS HANDLE           NO-UNDO.
DEFINE VARIABLE hquery           AS HANDLE           NO-UNDO.
DEFINE VARIABLE hbuffer          AS HANDLE           NO-UNDO.
DEFINE VARIABLE h-column         AS HANDLE           NO-UNDO.
DEFINE VARIABLE h-col            AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE h-data-ordem     AS HANDLE           NO-UNDO.
DEFINE VARIABLE h-nr-ordem       AS HANDLE           NO-UNDO.
DEFINE VARIABLE i-linha          AS INT              NO-UNDO.
DEFINE VARIABLE i-cont           AS INT              NO-UNDO.     
DEFINE VARIABLE achou            AS INT              NO-UNDO.     
DEFINE VARIABLE h-object         AS HANDLE           NO-UNDO.
DEFINE VARIABLE dt-entrega       AS DATE             NO-UNDO.    
DEFINE VARIABLE adm-current-page AS INTEGER          NO-UNDO.
DEFINE VARIABLE c-cgc            AS CHARACTER        NO-UNDO.
DEFINE VARIABLE adcol            AS LOG.             
DEFINE VARIABLE inss             AS CHAR.            
DEFINE VARIABLE natureza         AS CHAR.      
DEFINE VARIABLE i-teste-cgc      AS INTEGER     NO-UNDO.

 DEFINE BUFFER b-emitente FOR emitente.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
/*
 MESSAGE "Evento " p-ind-event         SKIP                    
         "Objeto " p-ind-object        SKIP                    
         "Tabela " p-cod-table         SKIP                    
         "Rowid  " STRING(p-row-table) SKIP                    
         "Objeto " c-objeto            SKIP VIEW-AS ALERT-BOX. */

{esp/es0018.i}
/***************************************************************************************************/
IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0401-upc.p PERSISTENT SET h-upc-cd0401(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).  

    ASSIGN wh-cd0401 = p-wgh-object.
END.
/***************************************************************************************************/
IF p-ind-object = "CONTAINER" AND
   c-objeto     = "folder.w"  THEN DO:
    ASSIGN wgh-folder  = p-wgh-object.
END.
/***************************************************************************************************/
IF p-ind-event = "BEFORE-INITIALIZE":U AND
   c-objeto    = "cd0401-v05.w":U      THEN DO:
    /* Cria campo e texto para centro de custo */
   CREATE TEXT tx-natureza
   ASSIGN FRAME        = p-wgh-frame
          FORMAT       = "x(15)"
          WIDTH        = 15
          SCREEN-VALUE = "Nat. Operaá∆o:"
          ROW          = 9.9
          COL          = 52
          VISIBLE      = YES.         
    
   CREATE FILL-IN wh-natureza
   ASSIGN FRAME     = p-wgh-frame
          FORMAT    = "x(8)"
          WIDTH     = 8
          HEIGHT    = 0.80
          ROW       = 9.8
          COL       = 62.6
          VISIBLE   = YES
          SENSITIVE = NO.

   IF VALID-HANDLE(wh-natureza) THEN
      wh-natureza:MOVE-AFTER-TAB-ITEM(wh-natureza).   
END.
/***************************************************************************************************/
IF p-ind-event = "INITIALIZE" THEN DO:
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD
           h-object = h-object:FIRST-CHILD.
        
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group":U THEN DO:
            CASE h-object:NAME:
                WHEN "cod-transp":U   THEN ASSIGN wh-transp   = h-object.
                WHEN "estado":U       THEN ASSIGN wh-uf       = h-object.
                WHEN "pais":U         THEN ASSIGN wh-pais     = h-object.
                WHEN "cod-emitente":U THEN ASSIGN wh-emitente = h-object.
                WHEN "cgc":U          THEN ASSIGN wh-cgc      = h-object.
            END CASE.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-uf) THEN
        ON "LEAVE":U OF wh-uf PERSISTENT RUN pi-leave-uf-pais IN h-upc-cd0401.

    IF VALID-HANDLE(wh-pais) THEN
        ON "LEAVE":U OF wh-pais PERSISTENT RUN pi-leave-uf-pais IN h-upc-cd0401.

    IF VALID-HANDLE(wh-cgc) THEN
        ON "LEAVE":U OF wh-cgc PERSISTENT RUN pi-leave-cgc IN h-upc-cd0401.

END.
/***************************************************************************************************/
IF p-ind-event = "DISPLAY" AND
   c-objeto    = "cd0401-v05.w":U THEN DO:

   FIND FIRST emitente NO-LOCK WHERE
        ROWID(emitente) = p-row-table NO-ERROR.
   IF AVAIL emitente THEN DO:
      ASSIGN wh-natureza:SCREEN-VALUE = emitente.nat-operacao.
   END.
END.
/***************************************************************************************************/

IF p-ind-event = "VALIDATE" AND
   c-objeto    = "cd0401-v01.w":U THEN DO:

   IF INT(wh-situacao-portal-cd0401:SCREEN-VALUE) = 1 THEN DO:
      IF wh-numero-cd0401:SCREEN-VALUE = "" THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT 17006,
                             INPUT "Numero n∆o informado. ~~ " +
                                   "Informar o numero do endereáo.").
          RETURN "NOK".
      END.
      
      IF wh-email-cd0401:SCREEN-VALUE = "" THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT 17006,
                             INPUT "Email n∆o informado. ~~ " +
                                   "Informar o email.").
          RETURN "NOK".
      END.
      
      IF wh-telefone-cd0401:SCREEN-VALUE = "" THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT 17006,
                             INPUT "Telefone n∆o informado. ~~ " +
                                   "Informar o telefone.").
          RETURN "NOK".
      END.
   END.

END.

IF p-ind-event = "VALIDATE" AND
   c-objeto    = "cd0401-v04.w":U THEN DO:
   ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
   ASSIGN h-object = h-object:FIRST-CHILD.
   DO WHILE VALID-HANDLE(h-object):
       IF h-object:TYPE <> "field-group" THEN DO:
           IF h-object:NAME = 'cod-cond-pag' THEN DO:     
              ASSIGN wh-cond-pag-cd0401 = h-object:HANDLE.
           END.

           ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
       END.
       ELSE LEAVE.
   END.
  
   IF VALID-HANDLE(wh-grupo-cd0401) THEN DO:
       IF wh-grupo-cd0401:SCREEN-VALUE = '7' /* Transportadores */ AND 
          wh-cond-pag-cd0401:SCREEN-VALUE = "0" THEN DO:
         run utp/ut-msgs.p (INPUT "show":U,
                            INPUT 17006,
                            INPUT "Condicao Pagamento deve ser informada ~~ " +
                                  "O campo Cond.Pagto deve ser preenchido para um Transportador.").
    
         RUN label-trigger IN wgh-folder (INPUT 2). 
    
         APPLY "ENTRY" TO wh-cond-pag-cd0401.
    
         RETURN "NOK".
       END.
   END.
END.

IF p-ind-event = "VALIDATE" AND
   c-objeto    = "cd0401-v05.w":U THEN DO:
   ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
   ASSIGN h-object = h-object:FIRST-CHILD.
   DO WHILE VALID-HANDLE(h-object):
       IF h-object:TYPE <> "field-group" THEN DO:
           IF h-object:NAME = 'cb-natureza' THEN DO:
              ASSIGN natureza = h-object:SCREEN-VALUE.
           END.
           IF h-object:NAME = 'c-inscr-inss' THEN DO:
               ASSIGN inss = h-object:SCREEN-VALUE.
           END.

           ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
       END.
       ELSE LEAVE.
   END.

   IF c-objeto    = "cd0401-v06.w":U THEN DO:
       ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
       ASSIGN h-object = h-object:FIRST-CHILD.
       DO WHILE VALID-HANDLE(h-object):
           IF h-object:TYPE <> "field-group" THEN DO:
               IF h-object:NAME = 'bairro' THEN DO:
                   ASSIGN wh-bairro-cd0401:SCREEN-VALUE = h-object:SCREEN-VALUE.
               END.
    
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
           END.
           ELSE LEAVE.
       END.
   END.

   IF  wh-bairro-cd0401:SCREEN-VALUE = "" THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Preencher campo Bairro. ~~ " +
                                 "O campo Bairro deve ser preenchido.").

        RUN label-trigger IN wgh-folder (INPUT 4). 

        APPLY "ENTRY" TO wh-bairro-cd0401.

        RETURN "NOK".
   END.

   IF inss     = ""              AND 
      natureza = "Pessoa F°sica" THEN DO:
      MESSAGE "Preencher o campo Inscriá∆o INSS/CEI"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN "NOK".
   END.
END.
/***************************************************************************************************/
IF p-ind-event = "AFTER-ENABLE" THEN DO:
    IF l-add = YES THEN DO:
        IF VALID-HANDLE(wh-cgc-cd0401) THEN
           ASSIGN wh-cgc-cd0401:SENSITIVE = YES.
    END.
    ELSE DO:
        IF VALID-HANDLE(wh-cgc-cd0401) THEN
           ASSIGN wh-cgc-cd0401:SENSITIVE = no.
    END.

    RUN pi-leave-uf-pais.
    RUN pi-leave-cgc.
END.
/***************************************************************************************************/
IF p-ind-event = "ADD":U THEN DO:
    IF VALID-HANDLE(wh-transp) THEN DO:
        ASSIGN wh-transp:SCREEN-VALUE = "":U.
        APPLY "LEAVE":U TO wh-transp.
        ASSIGN wh-transp:SENSITIVE = NO.
    END.
END.
/***************************************************************************************************/
IF p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0401-v05.w"  THEN DO:
   
    IF p-ind-event = "INITIALIZE" THEN DO:
        
        ASSIGN l-add = NO.
        /*cgc*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cgc",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cgc-cd0401).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "c-nr-passaporte",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-c-nr-passaporte-cd0401).

        /*natureza*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "combo-box",     /*** Type ***/
                      INPUT "cb-natureza",   /*** Name ***/
                      INPUT NO,              /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-natureza-cd0401).
    END.
    ELSE IF p-ind-event = "VALIDATE" THEN DO:
        
        IF  wh-natureza-cd0401:SCREEN-VALUE = "Estrangeiro" 
        AND wh-c-nr-passaporte-cd0401:SCREEN-VALUE = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ê necess†rio preencher o campo Nr Passaporte. ~~ " +
                                     "Caso n∆o tenha esta informaá∆o favor entrar em contato com o comprador respons†vel pelo Fornecedor/Cliente").
            RETURN "NOK".
        END.
        IF  wh-natureza-cd0401:SCREEN-VALUE = "Estrangeiro" THEN DO:
            ASSIGN i-teste-cgc = int(wh-cgc-cd0401:SCREEN-VALUE) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 17006,
                                  INPUT "CGC Inv†lido. ~~ " +
                                        "Campo CGC s¢ aceita numeros quando for estrangeiro").
               RETURN "NOK".
            END.
        END.
    END.
    ELSE IF p-ind-event = "AFTER-CANCEL" THEN DO:
        ASSIGN l-add = NO.
    END.
    ELSE IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
        ASSIGN l-add = NO.
    END.
    ELSE IF p-ind-event = "ADD" or wh-emitente-cd0401:SENSITIVE  = YES THEN DO:
        ASSIGN l-add = YES.
        ASSIGN /*wh-grupo-cd0401:SENSITIVE  = YES*/
               wh-matriz-cd0401:SENSITIVE = YES.
    END.
    ELSE DO:

        IF VALID-HANDLE(wh-natureza-cd0401) AND (p-ind-event = "DISPLAY" OR wh-natureza-cd0401:SCREEN-VALUE = "Pessoa Jur°dica") THEN DO:
            RUN esp/es0018p.p (INPUT "cd0401-upc", /* Nome do programa */
                               INPUT 2,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).   
            IF NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                            WHERE tt-prog-ponto.nome-programa = "cd0401-upc"   
                              AND tt-prog-ponto.ponto         = 2
                              AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
                ASSIGN /*wh-grupo-cd0401:SENSITIVE  = NO*/
                       wh-matriz-cd0401:SENSITIVE = NO.
            END.
            ELSE DO:
                IF p-ind-event <> "display" THEN
                    ASSIGN /*wh-grupo-cd0401:SENSITIVE  = yes*/
                           wh-matriz-cd0401:SENSITIVE = YES.
                ELSE
                    ASSIGN /*wh-grupo-cd0401:SENSITIVE  = no*/
                           wh-matriz-cd0401:SENSITIVE = NO.
            END.
        END.
        ELSE IF NOT VALID-HANDLE(wh-natureza-cd0401) THEN DO:
            ASSIGN wh-matriz-cd0401:SENSITIVE = NO.
        END.
        ELSE DO:
            ASSIGN /*wh-grupo-cd0401:SENSITIVE  = yes*/
                   wh-matriz-cd0401:SENSITIVE = YES.
        END.
    END.

END.
/***************************************************************************************************/
IF p-ind-event = "BEFORE-INITIALIZE" AND
   p-ind-object = "VIEWER"           AND
   c-objeto     = "cd0401-v01.w"     THEN DO:
    
  ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
  RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "fill-in",     /*** Type ***/
                INPUT "e-mail",         /*** Name ***/
                INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                OUTPUT wh-email-cd0401).

  IF VALID-HANDLE(wh-email-cd0401) THEN DO:
      ASSIGN wh-email-cd0401:FORMAT = "x(80)"
             wh-email-cd0401:WIDTH  = 50.
  END.

  RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "fill-in",      /*** Type ***/
                INPUT "c-telefone-1", /*** Name ***/
                INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                OUTPUT wh-telefone-cd0401).

END.
/***************************************************************************************************/
IF p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0401-v02.w"  THEN DO:

    IF p-ind-event = "ADD" OR p-ind-event = "INITIALIZE" THEN DO:
        /*cliente*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",      /*** Type ***/
                      INPUT "cod-emitente", /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-emitente-cd0401).
    
    
        /*cliente*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",      /*** Type ***/
                      INPUT "nome-abrev",   /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-nome-abrev-cd0401).

        CREATE TEXT tx-ariba-acm-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(18)"
               WIDTH        = 16
               SCREEN-VALUE = "C¢digo Ariba ACM:"
               ROW          = wh-emitente-cd0401:ROW + 0.2
               COL          = 45
               VISIBLE      = YES.

        CREATE TEXT tx-ariba-an-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(18)"
               WIDTH        = 16
               SCREEN-VALUE = "C¢digo Ariba AN:"
               ROW          = wh-nome-abrev-cd0401:ROW + 0.2
               COL          = tx-ariba-acm-cd0401:COL
               VISIBLE      = YES.    
    
        CREATE FILL-IN wh-ariba-acm-cd0401
        ASSIGN FRAME             = wh-emitente-cd0401:FRAME
               FORMAT            = "X(15)" 
               WIDTH             = 16
               HEIGHT            = 0.88
               ROW               = wh-emitente-cd0401:ROW
               COL               = 58
               SIDE-LABEL-HANDLE = tx-ariba-acm-cd0401
               VISIBLE           = YES
               SENSITIVE         = NO.     
    
        CREATE FILL-IN wh-ariba-an-cd0401
        ASSIGN FRAME             = wh-emitente-cd0401:FRAME
               FORMAT            = "X(15)" 
               WIDTH             = 16
               HEIGHT            = 0.88
               ROW               = wh-nome-abrev-cd0401:ROW
               COL               = wh-ariba-acm-cd0401:COL
               SIDE-LABEL-HANDLE = tx-ariba-an-cd0401
               VISIBLE           = YES
               SENSITIVE         = NO.

    END.

    IF p-ind-event = "DISPLAY" THEN DO:

        FIND FIRST emitente NO-LOCK WHERE
             ROWID(emitente) = p-row-table NO-ERROR.

        IF AVAIL emitente THEN DO:
       
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

            IF AVAIL int-emitente THEN DO:
                ASSIGN wh-ariba-an-cd0401:SCREEN-VALUE  = int-emitente.an-ariba
                       wh-ariba-acm-cd0401:SCREEN-VALUE = int-emitente.acm-ariba.
            END.
            ELSE 
                ASSIGN wh-ariba-an-cd0401:SCREEN-VALUE  = ""
                       wh-ariba-acm-cd0401:SCREEN-VALUE = "".

        END.

    END.
END.
/***************************************************************************************************/
IF p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0401-v06.w"  THEN DO:

    IF VALID-HANDLE (wh-end-completo-cd0401) THEN DO:
        ASSIGN wh-end-completo-cd0401:HIDDEN = YES
               wh-t-end-compl-cd0401:HIDDEN  = YES.
    END.

    IF p-ind-event = "INITIALIZE"  THEN DO:

        ASSIGN h-object = p-wgh-frame:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-object):
            IF h-object:TYPE <> "field-group":U THEN DO:
                CASE h-object:NAME:
                    WHEN "endereco" THEN
                        ASSIGN wh-end-cd0401 = h-object.
                    WHEN "end-completo" THEN
                        ASSIGN wh-end-completo-cd0401 = h-object.
                    WHEN "t-end-compl" THEN
                        ASSIGN wh-t-end-compl-cd0401 = h-object.
                    WHEN "estado" THEN                
                        ASSIGN wh-uf-cd0401 = h-object.
                    WHEN "cidade" THEN
                        ASSIGN wh-cidade-cd0401 = h-object.                   
                    WHEN "cep" THEN
                        ASSIGN wh-cep-cd0401 = h-object.
                    WHEN "bairro" THEN
                        ASSIGN wh-bairro-cd0401 = h-object.
                END CASE.
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        IF VALID-HANDLE(wh-end-cd0401) THEN DO:
            ASSIGN wh-end-cd0401:FORMAT = "X(100)"
                   wh-end-cd0401:WIDTH  = 63.
        END.

        IF VALID-HANDLE (wh-end-completo-cd0401) THEN DO:
            ASSIGN wh-end-completo-cd0401:HEIGHT = 0.88.
        END.

        CREATE TEXT tx-logradouro-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"
               WIDTH        = 15
               SCREEN-VALUE = "Logradouro:"
               ROW          = wh-end-cd0401:ROW - 1.9
               COL          = 11.5
               VISIBLE      = YES.         

        CREATE FILL-IN wh-logradouro-cd0401
        ASSIGN FRAME             = wh-end-completo-cd0401:FRAME
               FORMAT            = "X(35)" 
               WIDTH             = 35
               HEIGHT            = 0.88
               ROW               = wh-end-cd0401:ROW - 2
               COL               = wh-end-completo-cd0401:COL
               SIDE-LABEL-HANDLE = tx-logradouro-cd0401
               VISIBLE           = YES
               SENSITIVE         = NO.

        ON "LEAVE":U OF wh-logradouro-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.
        ON "VALUE-CHANGED":U OF wh-logradouro-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.

        CREATE TEXT tx-numero-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"
               WIDTH        = 15
               SCREEN-VALUE = "Nro:"
               ROW          = wh-end-cd0401:ROW - 1.9
               COL          = 56
               VISIBLE      = YES.         

        CREATE FILL-IN wh-numero-cd0401
        ASSIGN FRAME             = wh-end-completo-cd0401:FRAME
               FORMAT            = "X(5)" 
               WIDTH             = 7
               HEIGHT            = 0.88
               ROW               = wh-end-cd0401:ROW - 2
               COL               = 59
               SIDE-LABEL-HANDLE = tx-numero-cd0401
               VISIBLE           = YES
               SENSITIVE         = NO.

        ON "LEAVE":U OF wh-numero-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.
        ON "VALUE-CHANGED":U OF wh-numero-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.

        CREATE TEXT tx-complemento-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"
               WIDTH        = 15
               SCREEN-VALUE = "Complemento:"
               ROW          = wh-end-cd0401:ROW - 0.9
               COL          = 10
               VISIBLE      = YES.         

        CREATE FILL-IN wh-complemento-cd0401
        ASSIGN FRAME             = wh-end-completo-cd0401:FRAME
               FORMAT            = "X(40)" 
               WIDTH             = wh-end-completo-cd0401:WIDTH
               HEIGHT            = 0.88
               ROW               = wh-end-cd0401:ROW - 1
               COL               = wh-end-completo-cd0401:COL
               SIDE-LABEL-HANDLE = tx-complemento-cd0401
               VISIBLE           = YES
               SENSITIVE         = NO.

        ON "LEAVE":U OF wh-complemento-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.
        ON "VALUE-CHANGED":U OF wh-complemento-cd0401 PERSISTENT RUN pi-monta-endereco IN h-upc-cd0401.

        CREATE BUTTON wh-bt-cep-cd0401
        ASSIGN FRAME     = wh-end-cd0401:FRAME
               WIDTH     = 7
               HEIGHT    = 2.25
               ROW       = wh-end-cd0401:ROW
               LABEL     = "Consulta CEP"
               COLUMN    = wh-end-cd0401:COL - 17
               SENSITIVE = NO
               VISIBLE   = YES
               TOOLTIP   = "Consulta CEP"
               HELP      = "Consulta CEP"
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/cd0401-upca.p.
               END TRIGGERS.
    
        wh-bt-cep-cd0401:LOAD-IMAGE ("image/intelbras/ico-correio.bmp":U).
        wh-bt-cep-cd0401:MOVE-TO-TOP().
    END.

    IF p-ind-event = "ADD" THEN DO:
        CREATE TEXT tx-logradouro-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(11)"
               WIDTH        = 8
               SCREEN-VALUE = "Logradouro:"
               ROW          = wh-end-cd0401:ROW - 1.9
               COL          = 11.5
               VISIBLE      = YES.    

        CREATE TEXT tx-numero-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(4)"
               WIDTH        = 3
               SCREEN-VALUE = "Nro:"
               ROW          = wh-end-cd0401:ROW - 1.9
               COL          = 56
               VISIBLE      = YES.         

        CREATE TEXT tx-complemento-cd0401
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(12)"
               WIDTH        = 10
               SCREEN-VALUE = "Complemento:"
               ROW          = wh-end-cd0401:ROW - 0.9
               COL          = 10
               VISIBLE      = YES.      

        APPLY "LEAVE" TO wh-logradouro-cd0401.

        RUN select-page IN wh-cd0401(4).
        RUN select-page IN wh-cd0401(1).
    END.
    IF p-ind-event = "ENABLE" AND VALID-HANDLE(wh-bt-cep-cd0401) THEN DO:
        
        ASSIGN wh-bt-cep-cd0401:SENSITIVE = YES
               wh-logradouro-cd0401:SENSITIVE = YES
               wh-numero-cd0401:SENSITIVE = YES
               wh-complemento-cd0401:SENSITIVE = YES.
    END.

    IF p-ind-event = "AFTER-ENABLE" AND VALID-HANDLE(wh-bt-cep-cd0401) THEN DO:
        IF wh-end-cd0401:SCREEN-VALUE = "" THEN
            ASSIGN wh-end-cd0401:SENSITIVE = NO.
        ELSE
            ASSIGN wh-end-cd0401:READ-ONLY = YES.
    END.

    IF p-ind-event = "DISABLE" AND VALID-HANDLE(wh-bt-cep-cd0401) THEN DO:
        ASSIGN wh-bt-cep-cd0401:SENSITIVE = NO
               wh-logradouro-cd0401:SENSITIVE = NO
               wh-numero-cd0401:SENSITIVE = NO
               wh-complemento-cd0401:SENSITIVE = NO.
    END.

    IF p-ind-event = "ASSIGN" THEN DO:
        FIND FIRST emitente EXCLUSIVE-LOCK WHERE
             ROWID(emitente) = p-row-table NO-ERROR.

        FIND FIRST int-emitente EXCLUSIVE-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        IF AVAIL int-emitente THEN DO:
            ASSIGN int-emitente.logradouro  = REPLACE(REPLACE(wh-logradouro-cd0401:SCREEN-VALUE,",",""),"-","")
                   int-emitente.numero      = REPLACE(REPLACE(wh-numero-cd0401:SCREEN-VALUE,",",""),"-","")
                   int-emitente.complemento = REPLACE(REPLACE(wh-complemento-cd0401:SCREEN-VALUE,",",""),"-","").

            RELEASE int-emitente NO-ERROR.
        END.
        
        IF INT(wh-situacao-portal-cd0401:SCREEN-VALUE) = 1 THEN DO:
           IF emitente.end-cob = 0 THEN DO:
              ASSIGN emitente.pais-cob     = emitente.pais
                     emitente.estado-cob   = emitente.estado
                     emitente.cidade-cob   = emitente.cidade
                     emitente.cep-cob      = emitente.cep
                     emitente.endereco-cob = emitente.endereco
                     emitente.bairro-cob   = emitente.bairro
                     emitente.cx-post-cob  = emitente.caixa-postal
                     emitente.end-cob      = emitente.cod-emitente.
           END.
        END.

        RELEASE emitente NO-ERROR.
    END.

    IF p-ind-event = "DISPLAY" THEN DO:
        
        IF VALID-HANDLE (wh-logradouro-cd0401) THEN DO:
            ASSIGN wh-end-completo-cd0401:HIDDEN = YES
                   wh-t-end-compl-cd0401:HIDDEN  = YES.
        
            FIND FIRST emitente NO-LOCK WHERE
                 ROWID(emitente) = p-row-table NO-ERROR.
    
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    
            IF AVAIL int-emitente THEN DO:
                ASSIGN wh-logradouro-cd0401:SCREEN-VALUE  = int-emitente.logradouro  
                       wh-numero-cd0401:SCREEN-VALUE      = int-emitente.numero     
                       wh-complemento-cd0401:SCREEN-VALUE = int-emitente.complemento.
            END.
            ELSE DO:
                ASSIGN wh-logradouro-cd0401:SCREEN-VALUE  = ""
                       wh-numero-cd0401:SCREEN-VALUE      = ""
                       wh-complemento-cd0401:SCREEN-VALUE = "".
            END.
        END.
    END.

    IF p-ind-event = "VALIDATE" THEN DO:
        IF  wh-cep-cd0401:SCREEN-VALUE <> ""
        AND LENGTH(wh-cep-cd0401:SCREEN-VALUE) <> 9 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Formato de CEP inv†lido. ~~ " +
                                 "O CEP deve possuir 8 digitos.").
            RETURN "NOK".
        END.

        IF  wh-logradouro-cd0401:SCREEN-VALUE  = ""
        AND wh-numero-cd0401:SCREEN-VALUE      = ""
        AND wh-complemento-cd0401:SCREEN-VALUE = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Endereáo n∆o informado. ~~ " +
                                 "Informe ao menos um dos campos de endereáo, logradouro, n£mero ou complemento.").
            RETURN "NOK".
        END.
    END.

    IF p-ind-event = "END-UPDATE" THEN DO:

        FIND FIRST emitente NO-LOCK WHERE
             ROWID(emitente) = p-row-table NO-ERROR.

        FIND FIRST loc-entr NO-LOCK
             WHERE loc-entr.nome-abrev  = emitente.nome-abrev 
               AND loc-entr.cod-entrega = "Padr∆o":U NO-ERROR.

        /*Se o endereáo da loc-entr ta igual ao da tela, foi escolhido sim na mensagem para copiar o endereáo para o local de entrega, copia tambÇm os campos especificos*/
        IF  AVAIL loc-entr
        AND loc-entr.endereco = wh-end-cd0401:SCREEN-VALUE THEN DO:
    
            FIND FIRST int-loc-entr EXCLUSIVE-LOCK
                 WHERE int-loc-entr.nome-abrev  = emitente.nome-abrev 
                   AND int-loc-entr.cod-entrega = "Padr∆o":U NO-ERROR.
    
            IF NOT AVAIL int-loc-entr THEN DO:
                CREATE int-loc-entr.
                ASSIGN int-loc-entr.nome-abrev  = emitente.nome-abrev 
                       int-loc-entr.cod-entrega = "Padr∆o":U.
            END.
    
            ASSIGN int-loc-entr.logradouro  = wh-logradouro-cd0401:SCREEN-VALUE 
                   int-loc-entr.numero      = wh-numero-cd0401:SCREEN-VALUE     
                   int-loc-entr.complemento = wh-complemento-cd0401:SCREEN-VALUE.

            FIND CURRENT int-loc-entr NO-LOCK NO-ERROR.
        END.

    END.
END.
/***************************************************************************************************/
IF p-ind-event  = "before-assign" AND 
   p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0401-v02.w"  THEN DO:

    IF VALID-HANDLE(wh-natureza-cd0401) AND wh-natureza-cd0401:SCREEN-VALUE = "Pessoa Jur°dica" THEN DO:
        ASSIGN c-cgc = wh-cgc-cd0401:SCREEN-VALUE
               c-cgc = REPLACE(c-cgc,".","")
               c-cgc = REPLACE(c-cgc,"/","")
               c-cgc = REPLACE(c-cgc,"-","").

        RUN esp/es0018p.p (INPUT "cd0401-upc", /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        IF VALID-HANDLE(wh-emitente-cd0401) THEN DO:
            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE) NO-ERROR.
            IF NOT AVAIL b-emitente OR 
               CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                        WHERE tt-prog-ponto.nome-programa = "cd0401-upc"   
                          AND tt-prog-ponto.ponto         = 2
                          AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:

                FIND FIRST emitente USE-INDEX cgc NO-LOCK  
                     WHERE emitente.cgc BEGINS SUBSTRING(c-cgc,1,8)
                       AND emitente.natureza = 2 NO-ERROR.
                IF AVAIL emitente THEN DO:
                    IF /*wh-grupo-cd0401:SCREEN-VALUE <> STRING(emitente.cod-gr-cli) OR*/ wh-matriz-cd0401:SCREEN-VALUE <> emitente.nome-matriz THEN DO:
                        IF NOT CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                                        WHERE tt-prog-ponto.nome-programa = "cd0401-upc"   
                                          AND tt-prog-ponto.ponto         = 2
                                          AND tt-prog-ponto.conteudo      = c-seg-usuario) THEN DO:
                            MESSAGE "As informaá‰es abaixo foram alteradas conforme Cliente: " + STRING(emitente.cod-emitente) + "-" + emitente.nome-abrev SKIP
                                    /*"Grupo Cliente DE: " + wh-grupo-cd0401:SCREEN-VALUE  + "   PARA: " + STRING(emitente.cod-gr-cli) SKIP*/
                                    "Mome Matriz DE: " + wh-matriz-cd0401:SCREEN-VALUE + "   PARA: " + emitente.nome-matriz
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.

                            ASSIGN /*wh-grupo-cd0401:SCREEN-VALUE  = STRING(emitente.cod-gr-cli)*/
                                   wh-matriz-cd0401:SCREEN-VALUE = emitente.nome-matriz.
                        END.
                        ELSE DO:
                            MESSAGE "Vocà informou uma matriz diferente da matriz da raiz de CNPJ: " + SUBSTRING(emitente.cgc,1,8) + "- Cliente:" STRING(emitente.cod-emitente) + "-" + TRIM(emitente.nome-abrev) + "." SKIP
                                    "Matriz informada: " + wh-matriz-cd0401:SCREEN-VALUE + "   Matriz Raiz CNPJ: " + emitente.nome-matriz SKIP
                                    "Deseja manter a matriz informada para esse cliente diferente da matriz da raiz de CNPJ?"
                                VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l-mantem AS LOGICAL.

                            IF NOT l-mantem THEN DO:
                                ASSIGN /*wh-grupo-cd0401:SCREEN-VALUE  = STRING(emitente.cod-gr-cli)*/
                                       wh-matriz-cd0401:SCREEN-VALUE = emitente.nome-matriz.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.

/***************************************************************************************************/
IF p-ind-object = "VIEWER"        AND
   c-objeto     = "cd0401-v03.w"  THEN DO:

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        ASSIGN c-motivo-cd0401 = "".

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
                      INPUT "cod-gr-forn",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-grupo-cd0401).

        /*matriz*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "nome-matriz",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-matriz-cd0401).

        /*Emite etiqueta*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "toggle-box",     /*** Type ***/
                      INPUT "emite-etiq",  /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-emite-etiq-cd0401).

        /*Vencimento Igual data Fluxo*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "toggle-box",     /*** Type ***/
                      INPUT "tg-vencto-dia-nao-util",  /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-tg-vencto-util-cd0401).

        IF VALID-HANDLE(wh-emite-etiq-cd0401) AND VALID-HANDLE(wh-tg-vencto-util-cd0401) THEN DO:
            ASSIGN wh-emite-etiq-cd0401:ROW     = wh-emite-etiq-cd0401:ROW - 0.15
                   wh-emite-etiq-cd0401:COL     = wh-emite-etiq-cd0401:COL
                   wh-tg-vencto-util-cd0401:ROW = wh-emite-etiq-cd0401:ROW + 0.80
                   wh-tg-vencto-util-cd0401:COL = wh-emite-etiq-cd0401:COL.
        END.

        CREATE TEXT wh-txt-atualiz-cd0401
        ASSIGN FRAME        = wh-grupo-cd0401:FRAME
               FORMAT       = "x(17)"   
               WIDTH        = 12
               SCREEN-VALUE = "Ult.Atualizaá∆o:"
               ROW          = 6.30
               COL          = 57.77
               VISIBLE      = YES.

        CREATE FILL-IN wh-dt-atualiz-cd0401
        ASSIGN FRAME             = wh-grupo-cd0401:FRAME
               DATA-TYPE         = "date"
               FORMAT            = "99/99/9999" 
               WIDTH             = whdata-implant:WIDTH
               HEIGHT            = whdata-implant:HEIGHT
               ROW               = wh-matriz-cd0401:ROW + 3
               COL               = whdata-implant:COL
               SIDE-LABEL-HANDLE = wh-txt-atualiz-cd0401:HANDLE
               VISIBLE           = YES
               SENSITIVE         = NO.
    
                
    END.
    
    ELSE IF p-ind-event = "display" THEN DO:

        ASSIGN c-motivo-cd0401 = "".
        FIND FIRST emitente NO-LOCK
             WHERE ROWID(emitente) = p-row-table NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN DO:
                ASSIGN wh-dt-atualiz-cd0401:SCREEN-VALUE = STRING(int-emitente.dt-ult-atualizacao,"99/99/9999").
                
                IF VALID-HANDLE(wh-bt-ativo-cd0401) THEN DO :
                    IF CAN-FIND(FIRST int-emitente-historico NO-LOCK
                                WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente
                                  AND int-emitente-historico.tipo         = 2) THEN DO:
                        ASSIGN wh-bt-ativo-cd0401:SENSITIVE = TRUE
                               wh-bt-ativo-cd0401:VISIBLE = TRUE.
                    END.
                    ELSE DO:
                        ASSIGN wh-bt-ativo-cd0401:SENSITIVE = FALSE
                               wh-bt-ativo-cd0401:VISIBLE = FALSE.
                    END.
                END.
            END.
        END.
        /*Rotina para nao sobrepor o frame corrente na hora de mostrar os dados do outro frame*/
        RUN GET-ATTRIBUTE IN wgh-folder ('Current-Page':U) NO-ERROR.
        ASSIGN adm-current-page = INTEGER(RETURN-VALUE).
        IF adm-current-page > 1 THEN
            ASSIGN p-wgh-frame:HIDDEN = YES.
    END.
    ELSE IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
        FIND FIRST emitente NO-LOCK 
             WHERE ROWID(emitente) = p-row-table NO-ERROR.
        IF AVAIL emitente THEN DO:

            /*Atualizando historico ativacao/desativacao*/
            FIND FIRST int-emitente EXCLUSIVE-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF AVAIL int-emitente THEN DO:
                ASSIGN int-emitente.dt-ult-atualizacao = TODAY.
                
                RELEASE int-emitente NO-ERROR.
            END.

            
        END.
    END.
END.
/***************************************************************************************************/
IF  p-ind-event = "VALIDATE"
AND c-objeto    = "v67ad098.w" THEN DO:
    FIND FIRST emitente NO-LOCK
         WHERE ROWID(emitente) = p-row-table NO-ERROR.

    IF AVAIL emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        /*Uma vez que possou a participar do portal n∆o volta mais para situaá∆o 1*/
        IF  AVAIL int-emitente
        AND int-emitente.ind-participa-portal-fornec > 0
        AND INT(wh-situacao-portal-cd0401:SCREEN-VALUE) = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Situaá∆o Portal de Fornecedores Inv†lida. ~~ " +
                                 "A Situaá∆o Portal de Fornecedores deve ser Participa do Portal de Fornecedores ou Descredenciado do Portal de Fornecedores .").
            RETURN "NOK".
        END.
    END.
END.
/***************************************************************************************************/
IF  p-ind-event = "INITIALIZE" 
AND c-objeto    = "v01di275.w" THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "RADIO-SET",         /*** Type ***/
                  INPUT "rs-idi-sit-fornec", /*** Name ***/
                  INPUT NO,                  /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                   /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-idi-sit-fornec-cd0401).
                  
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",         /*** Type ***/
                  INPUT "dt-dat-vigenc-ini", /*** Name ***/
                  INPUT NO,                  /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                   /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-dt-dat-vigenc-ini-cd0401).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "FILL-IN",         /*** Type ***/
                  INPUT "dt-dat-vigenc-fim", /*** Name ***/
                  INPUT NO,                  /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                   /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-dt-dat-vigenc-fim-cd0401).                                    
                  
    ON "VALUE-CHANGED":U OF wh-idi-sit-fornec-cd0401 PERSISTENT RUN pi-tela-motivo IN h-upc-cd0401.               
                                                      
    IF VALID-HANDLE (wh-idi-sit-fornec-cd0401) THEN DO:
        ASSIGN wh-idi-sit-fornec-cd0401:COL = wh-idi-sit-fornec-cd0401:COL - 19.
    END.
    
    create button wh-bt-ativo-cd0401  
    assign frame     = wh-idi-sit-fornec-cd0401:FRAME 
           width     = 4.00        
           height    = 1
           row       = wh-idi-sit-fornec-cd0401:ROW 
           col       = 3
           visible   = yes
           sensitive = yes
           tooltip   = "Hist¢rico Ativaá∆o/Desativaá∆o"
           TRIGGERS:
               ON CHOOSE PERSISTENT RUN pi-botao-historico IN h-upc-cd0401.
           END TRIGGERS.

    if wh-bt-ativo-cd0401:load-image("image/im-livro.bmp") then.

    CREATE RADIO-SET wh-situacao-portal-cd0401
        ASSIGN FRAME  = p-wgh-frame
        WIDTH         = 35
        HEIGHT        = 2.99
        COL           = 45 
        ROW           = wh-idi-sit-fornec-cd0401:ROW
        HORIZONTAL    = NO
        RADIO-BUTTONS = "N∆o Participa do Portal de Fornecedores,0,Participa do Portal de Fornecedores,1,Descredenciado do Portal de Fornecedores,2"
        VISIBLE       = YES          
        SENSITIVE     = NO.

END.
/***************************************************************************************************/
/*Usa o c-objeto de outra frame pois a aba situaá∆o nao possui eventos*/
IF  p-ind-event = "DISPLAY" 
AND c-objeto    = "v67ad098.w" THEN DO:

    IF NOT VALID-HANDLE(wh-situacao-portal-cd0401) THEN DO:
       RUN select-page IN wh-cd0401(8).
    END.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE) NO-ERROR.

    IF AVAIL int-emitente THEN DO:
        ASSIGN wh-situacao-portal-cd0401:SCREEN-VALUE = STRING(int-emitente.ind-participa-portal-fornec).
    END.
END.
/***************************************************************************************************/
/*Usa o c-objeto de outra frame pois a aba situaá∆o nao possui eventos*/
IF  p-ind-event = "after-enable" 
AND c-objeto    = "v67ad098.w" THEN DO:

    ASSIGN wh-situacao-portal-cd0401:SENSITIVE = YES.

END.
/***************************************************************************************************/ 
/*Usa o c-objeto de outra frame pois a aba situaá∆o nao possui eventos*/
IF  p-ind-event = "after-disable" 
AND c-objeto    = "v67ad098.w" THEN DO:

    ASSIGN wh-situacao-portal-cd0401:SENSITIVE = NO.

END.
/***************************************************************************************************/
/*Usa o c-objeto de outra frame pois a aba situaá∆o nao possui eventos*/
IF  p-ind-event = "ASSIGN"
AND c-objeto    = "v67ad098.w" THEN DO:

    FIND FIRST int-emitente EXCLUSIVE-LOCK
         WHERE int-emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE) NO-ERROR.

    IF NOT AVAIL int-emitente THEN DO:
        CREATE int-emitente.
        ASSIGN int-emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE).
    END.

    ASSIGN int-emitente.ind-participa-portal-fornec = INT(wh-situacao-portal-cd0401:SCREEN-VALUE).

    RELEASE int-emitente NO-ERROR.

END.
/***************************************************************************************************/
PROCEDURE pi-tela-motivo:

    if wh-idi-sit-fornec-cd0401:screen-value = '1' then 
        assign wh-dt-dat-vigenc-ini-cd0401:sensitive = no
               wh-dt-dat-vigenc-fim-cd0401:sensitive = no
               wh-dt-dat-vigenc-ini-cd0401:screen-value = ""
               wh-dt-dat-vigenc-fim-cd0401:screen-value = "".

    else 
        assign wh-dt-dat-vigenc-ini-cd0401:sensitive = yes
               wh-dt-dat-vigenc-fim-cd0401:sensitive = yes
               wh-dt-dat-vigenc-ini-cd0401:screen-value = string(today)
               wh-dt-dat-vigenc-fim-cd0401:screen-value = string(12/31/9999).
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE) NO-ERROR.
    
    IF AVAIL emitente THEN DO: 

        FIND FIRST dist-emitente NO-LOCK
           WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    
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
            IF AVAIL dist-emitente THEN
                ASSIGN wh-idi-sit-fornec-cd0401:SCREEN-VALUE = STRING(dist-emitente.idi-sit-fornec).

            APPLY "GO":U TO FRAME fMotivo.
        END.

        ENABLE fidescricao btOK btCancelar
            WITH FRAME fMotivo. 

        WAIT-FOR "GO":U OF FRAME fMotivo.
        ASSIGN c-motivo-cd0401 = fidescricao.
       
              
        IF c-motivo-cd0401 <> "" THEN DO:
            DEFINE VARIABLE i-seq AS INTEGER NO-UNDO.
    
            FIND LAST int-emitente-historico NO-LOCK
                WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF NOT AVAIL int-emitente-historico THEN
                ASSIGN i-seq = 1.
            ELSE 
                ASSIGN i-seq = int-emitente-historico.sequencia + 1.
    
            CREATE int-emitente-historico.
            ASSIGN int-emitente-historico.cod-emitente     = emitente.cod-emitente
                   int-emitente-historico.tipo             = 2
                   int-emitente-historico.sequencia        = i-seq
                   int-emitente-historico.dt-movto         = TODAY
                   int-emitente-historico.hr-movto         = STRING(TIME,"HH:MM:SS")
                   int-emitente-historico.usuario          = c-seg-usuario
                   int-emitente-historico.ind-sit-emitente = INT (wh-idi-sit-fornec-cd0401:SCREEN-VALUE)
                   int-emitente-historico.motivo           = c-motivo-cd0401.
        END.
    END. 
   
    
END PROCEDURE.
/***************************************************************************************************/
PROCEDURE pi-botao-historico:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(wh-emitente-cd0401:SCREEN-VALUE) NO-ERROR.
    IF AVAIL emitente THEN DO:
        RUN esp/cdp/escdp006.w (INPUT 2, INPUT emitente.cod-emitente).
    END.
    
END PROCEDURE.
/***************************************************************************************************/
PROCEDURE pi-leave-uf-pais:

    /*MESSAGE "pi-leave-uf-pais" VIEW-AS ALERT-BOX.*/

    FIND FIRST int-unid-feder
        WHERE int-unid-feder.pais   = wh-pais:SCREEN-VALUE
          AND int-unid-feder.estado = wh-uf:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF AVAILABLE int-unid-feder THEN DO:
        ASSIGN wh-transp:SCREEN-VALUE = STRING(int-unid-feder.cod-transp-padrao).
        APPLY "LEAVE":U TO wh-transp.
        ASSIGN wh-transp:SENSITIVE = YES.
    END.
    ELSE DO:
        FIND FIRST emitente
             WHERE emitente.cod-emitente = INTEGER(wh-emitente:SCREEN-VALUE) NO-LOCK NO-ERROR.

        IF AVAILABLE emitente THEN
            ASSIGN wh-transp:SCREEN-VALUE = STRING(emitente.cod-transp).
        ELSE
            ASSIGN wh-transp:SCREEN-VALUE = "":U.

        APPLY "LEAVE":U TO wh-transp.
        ASSIGN wh-transp:SENSITIVE = YES.
    END.
END PROCEDURE.
/***************************************************************************************************/
PROCEDURE pi-leave-cgc:
    IF  l-add THEN DO:
        ASSIGN c-cgc = wh-cgc:SCREEN-VALUE
               c-cgc = REPLACE(c-cgc,".","")
               c-cgc = REPLACE(c-cgc,"/","")
               c-cgc = REPLACE(c-cgc,"-","").
    
        FIND FIRST emitente USE-INDEX cgc NO-LOCK  
             WHERE emitente.cgc BEGINS SUBSTRING(c-cgc,1,8)
             AND   emitente.natureza = 2 NO-ERROR.
    
        IF  AVAIL emitente THEN
            ASSIGN wh-matriz-cd0401:SCREEN-VALUE = emitente.nome-matriz.
    END.
END PROCEDURE.
/***************************************************************************************************/
PROCEDURE pi-monta-endereco:
    DEFINE VARIABLE c-endereco AS CHARACTER   NO-UNDO.
    
    ASSIGN c-endereco = REPLACE(REPLACE(wh-logradouro-cd0401:SCREEN-VALUE,",",""),"-","").
    
    IF wh-numero-cd0401:SCREEN-VALUE <> "" THEN 
        ASSIGN c-endereco = c-endereco + ", " + REPLACE(REPLACE(wh-numero-cd0401:SCREEN-VALUE,",",""),"-","").
    
    IF wh-complemento-cd0401:SCREEN-VALUE <> "" THEN 
        ASSIGN c-endereco = c-endereco + " - " + REPLACE(REPLACE(wh-complemento-cd0401:SCREEN-VALUE,",",""),"-","").

    ASSIGN wh-end-cd0401:SCREEN-VALUE = c-endereco.

    IF wh-end-cd0401:SCREEN-VALUE = "" THEN
        ASSIGN wh-end-cd0401:SENSITIVE = NO.
    ELSE
        ASSIGN wh-end-cd0401:READ-ONLY = YES.

END PROCEDURE.
/***************************************************************************************************/
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

RETURN "".
