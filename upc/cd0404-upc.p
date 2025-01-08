/***********************************************************************
**  Programa..: upc\cd0404-upc.p
**  Autor.....: Clayton Antunes
**  Data......: Setembro/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
**  Vers∆o....: 002 - 24/02/2022
**  iDBA            Estados e Produtos
************************************************************************/

{utp/ut-glob.i}

DEFINE INPUT PARAM p-ind-event  AS char          NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS char          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS handle        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS widget-handle NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS char          NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS rowid         NO-UNDO.

DEFINE VARIABLE h-object        AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo         AS HANDLE        NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL       NO-UNDO.

def var c-obj-aux as char   no-undo.
def var c-folder  as char   no-undo.
def var h-folder  as handle no-undo.
def var h-objeto  as handle no-undo.
def var i-cont    as inte   no-undo.
def var i-aux     as inte   no-undo.

def var h-cd0404-upc-b01 as handle no-undo.
def var h-cd0404-upc-b02 as handle no-undo.

DEF VAR de-row AS DECI NO-UNDO.
DEF VAR de-col AS DECI NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-ativo-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo-cd0404        AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-label-0-cd0404       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-log-ativo-verticais  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-1-cd0404       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-log-ativo-exportacao AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-ativo-b2b-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo-canais-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ativo-portal-fornec-cd0404 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-revenda-cd0404             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-flex-cd0404                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-cond-pagto-cd0404      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lbl-cod-cond-pagto-cd0404  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-descricao-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lbl-descricao-cd0404       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-cd0404                  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-cartao-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-avalia-credito-cd0404      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-avalia-credito-cd0404      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-tipo-cartao-cd0404         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tipo-cartao-cd0404         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-retangulo-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-boleto-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-carta-credito-cd0404    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-cessao-credito-cd0404   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-enviar-SDCV-cd0404      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-log-controla-fft-cd0404    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-log-ativo-uso-interno-cd0404  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-boleto-cd0404              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-imagem-cd0404          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tg-intelbras-clube-cd0404  AS WIDGET-HANDLE NO-UNDO. /* Flag do cart∆o Intelbras Clube (SupplierCard) */
DEF NEW GLOBAL SHARED VAR l-cond-cartao-cd0404          AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-avalia-credito-cd0404       AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-lAtualizaIndice-cd0404     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-cod-vencto-cd0404       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dia-mes-base-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-dia-sem-base-cd0404     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dia-mes-venc-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-dia-sem-venc-cd0404     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-dias-ante-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-dupdes-cd0404           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-per-des-pgan-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-tab-finan-cd0404        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-ind-finan-cd0404        AS WIDGET-HANDLE NO-UNDO.
def new global shared var adm-broker-hdl                as handle        no-undo.

DEFINE VARIABLE c-objeto AS   CHAR.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


/* MESSAGE "Evento " p-ind-event  SKIP     */
/*         "Objeto " p-ind-object SKIP     */
/*         "Nome   " c-objeto SKIP         */
/*         "Tabela " p-cod-table  SKIP     */
/*         "Rowid  " STRING(p-row-table)   */
/*         "Frame  " p-wgh-frame:NAME SKIP */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.  */


IF  p-ind-event  = "INITIALIZE" THEN DO:    
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:


            IF h-object:NAME = 'cod-imagem' THEN DO:
                ASSIGN wh-cod-imagem-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cod-cond-pag' THEN DO:
                ASSIGN wh-cod-cond-pagto-cd0404 = h-object.
            END.
            IF h-object:NAME = 'descricao' THEN DO:
                ASSIGN wh-descricao-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-cod-vencto' THEN DO:
                ASSIGN wh-cb-cod-vencto-cd0404 = h-object.
            END.
            IF h-object:NAME = 'dia-mes-base' THEN DO:
                ASSIGN wh-dia-mes-base-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-dia-sem-base' THEN DO:
                ASSIGN wh-cb-dia-sem-base-cd0404 = h-object.
            END.
            IF h-object:NAME = 'dia-mes-venc' THEN DO:
                ASSIGN wh-dia-mes-venc-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-dia-sem-venc ' THEN DO:
                ASSIGN wh-cb-dia-sem-venc-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-dias-ante' THEN DO:
                ASSIGN wh-nr-dias-ante-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-dupdes' THEN DO:
                ASSIGN wh-nr-dupdes-cd0404 = h-object.
            END.
            IF h-object:NAME = 'per-des-pgan' THEN DO:
                ASSIGN wh-per-des-pgan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-tab-finan' THEN DO:
                ASSIGN wh-nr-tab-finan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-ind-finan' THEN DO:
                ASSIGN wh-nr-ind-finan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'lAtualizaIndice' THEN DO:
                ASSIGN wh-lAtualizaIndice-cd0404 = h-object.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    
    
    
/*     IF  VALID-HANDLE(wh-lAtualizaIndice-cd0404) THEN                              */
/*         wh-lAtualizaIndice-cd0404:COLUMN = wh-lAtualizaIndice-cd0404:column + 12. */

           
    IF p-wgh-frame:NAME = "f-cad"  THEN DO:
        CREATE TEXT tx-ativo-cd0404
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(6)"
               WIDTH        = 8
               SCREEN-VALUE = "Ativo:"
               ROW          = 3.43
               COL          = 79
               VISIBLE      = YES.               
    
        CREATE FILL-IN wh-ativo-cd0404
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "logical"
               FORMAT            = "Sim/N∆o" 
               WIDTH             = 5
               HEIGHT            = 0.88
               ROW               = 3.29
               COL               = 83
               VISIBLE           = YES
               SENSITIVE         = NO
               TRIGGERS:
                    ON LEAVE PERSISTENT RUN pi-leave-ativo IN h-upc-cd0404.
               END TRIGGERS.


        FIND FIRST cond-pagto WHERE
             ROWID(cond-pagto) = p-row-table NO-ERROR.
        IF AVAIL cond-pagto THEN DO:
           FIND FIRST int-cond-pagto WHERE
                int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
           IF AVAIL int-cond-pagto THEN DO:
              IF int-cond-pagto.ativa = YES THEN DO:
                 IF VALID-HANDLE(wh-ativo-cd0404) THEN ASSIGN wh-ativo-cd0404:SCREEN-VALUE  = "Sim" .
              END.
              ELSE DO:
                 IF VALID-HANDLE(wh-ativo-cd0404) THEN ASSIGN wh-ativo-cd0404:SCREEN-VALUE  = "N∆o".
              END.

           END.
        END.
    END.

    if p-ind-object = 'container'
    then run pi-folders.
END.



IF p-ind-event = "ADD" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      ASSIGN wh-ativo-cd0404:SENSITIVE = YES
             tx-ativo-cd0404:SCREEN-VALUE = "Ativo:".
      RUN pi-leave-ativo IN h-upc-cd0404.
   END.
END.



IF p-ind-event = "ENABLE" THEN DO:
    IF p-wgh-frame:NAME = "f-main"  THEN DO:
       ASSIGN wh-ativo-cd0404:SENSITIVE         = YES.

       IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN wh-log-ativo-verticais:SENSITIVE  = YES.   
       IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN wh-log-ativo-exportacao:SENSITIVE = YES.   
    END.
END.



IF p-ind-event = "CANCEL" THEN DO:
   ASSIGN wh-ativo-cd0404:SENSITIVE = NO
          tx-ativo-cd0404:VISIBLE = YES
          wh-flex-cd0404:SENSITIVE = NO.

   IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN wh-log-ativo-verticais:SENSITIVE  = NO.  
   IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN wh-log-ativo-exportacao:SENSITIVE = NO.  

   FIND FIRST cond-pagto WHERE
        ROWID(cond-pagto) = p-row-table NO-ERROR.
   IF AVAIL cond-pagto THEN DO:
      FIND FIRST int-cond-pagto WHERE
           int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
       IF  AVAIL int-cond-pagto THEN
           wh-flex-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,8,1) = "S" THEN YES ELSE NO.
   END.
END.



IF p-ind-event = "DISPLAY" THEN DO:
   IF p-wgh-frame:NAME = "f-main"  THEN DO:
      FIND FIRST cond-pagto WHERE
           ROWID(cond-pagto) = p-row-table NO-ERROR.
      IF AVAIL cond-pagto THEN DO:
         FIND FIRST int-cond-pagto WHERE
              int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
         IF AVAIL int-cond-pagto THEN DO:

            IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN wh-log-ativo-verticais:SCREEN-VALUE   = STRING(int-cond-pagto.log-ativo-verticais) .  
            IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN wh-log-ativo-exportacao:SCREEN-VALUE  = STRING(int-cond-pagto.log-ativo-exportacao) . 

            IF int-cond-pagto.ativa = YES THEN DO:
               IF VALID-HANDLE(wh-ativo-cd0404)         THEN ASSIGN wh-ativo-cd0404:SCREEN-VALUE          = "Sim" .
            END.
            ELSE DO:
               IF VALID-HANDLE(wh-ativo-cd0404)         THEN ASSIGN wh-ativo-cd0404:SCREEN-VALUE          = "N∆o".
            END.

         END.
      END.
   END.
END.

IF p-ind-event = "ASSIGN" THEN DO:
    /* SupplierCard - Valida se o usu†rio tem permiss∆o para alterar as Condiá‰es de Pagamento da SupplierCard */
    IF  l-cond-cartao-cd0404 OR
        l-avalia-credito-cd0404 OR
       (VALID-HANDLE(wh-tg-intelbras-clube-cd0404) AND 
        (wh-tg-intelbras-clube-cd0404:CHECKED OR wh-avalia-credito-cd0404:CHECKED)) THEN DO:
        
        ASSIGN l-erro = YES.
        FIND FIRST ponto-programa NO-LOCK
            WHERE  ponto-programa.nome-programa = "supplierCard"
            AND    ponto-programa.ponto         = 1 NO-ERROR.
        IF  AVAIL  ponto-programa THEN DO:
            IF  CAN-FIND(FIRST conteudo-programa NO-LOCK
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                         AND   conteudo-programa.conteudo     = c-seg-usuario) THEN
                ASSIGN l-erro = NO.
        END.
    
        IF  l-erro THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Usu†rio sem permiss∆o para alterar a Condiá∆o de Pagamento.~~Favor entrar em contato com o Financeiro.":U).

            IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN wh-log-ativo-verticais:SENSITIVE  = NO.  
            IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN wh-log-ativo-exportacao:SENSITIVE = NO.  
    
            RETURN "NOK".
        END.
    END.
    /* SupplierCard - FIM */

    FIND FIRST cond-pagto WHERE
         ROWID(cond-pagto) = p-row-table NO-ERROR.
    IF AVAIL cond-pagto THEN DO:
       FIND FIRST int-cond-pagto WHERE
            int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.

       IF AVAIL int-cond-pagto THEN DO:
          IF wh-ativo-cd0404:SCREEN-VALUE = "Sim" THEN
             ASSIGN int-cond-pagto.ativa = YES.
          ELSE
              ASSIGN int-cond-pagto.ativa = NO.

          IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN int-cond-pagto.log-ativo-verticais   = LOGICAL(wh-log-ativo-verticais:SCREEN-VALUE).
          IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN int-cond-pagto.log-ativo-exportacao  = LOGICAL(wh-log-ativo-exportacao:SCREEN-VALUE).
          
       END.
       ELSE DO:
           IF wh-ativo-cd0404:SCREEN-VALUE = "Sim" THEN DO:
              CREATE int-cond-pagto.
              ASSIGN int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag
                     int-cond-pagto.ativa = YES.
           END.
           ELSE DO:
              CREATE int-cond-pagto.
              ASSIGN int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag
                     int-cond-pagto.ativa = NO.
           END.

           IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN int-cond-pagto.log-ativo-verticais   = LOGICAL(wh-log-ativo-verticais:SCREEN-VALUE).  
           IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN int-cond-pagto.log-ativo-exportacao  = LOGICAL(wh-log-ativo-exportacao:SCREEN-VALUE).


       END.
    END.
    ASSIGN wh-ativo-cd0404:SENSITIVE = NO.
    IF VALID-HANDLE(wh-log-ativo-verticais)  THEN ASSIGN wh-log-ativo-verticais:SENSITIVE  = NO.  
    IF VALID-HANDLE(wh-log-ativo-exportacao) THEN ASSIGN wh-log-ativo-exportacao:SENSITIVE = NO.  

END.
                  
IF p-ind-object = "VIEWER"      AND 
   p-ind-event = "INITIALIZE":U AND
   c-objeto    = "v03ad039.w":U THEN DO:

    ASSIGN wh-cb-cod-vencto-cd0404  :COL = wh-cb-cod-vencto-cd0404  :COL - 7
           wh-dia-mes-base-cd0404   :COL = wh-dia-mes-base-cd0404   :COL - 7
           wh-cb-dia-sem-base-cd0404:COL = wh-cb-dia-sem-base-cd0404:COL - 7
           wh-dia-mes-venc-cd0404   :COL = wh-dia-mes-venc-cd0404   :COL - 7
           wh-cb-dia-sem-venc-cd0404:COL = wh-cb-dia-sem-venc-cd0404:COL - 7
           wh-nr-dias-ante-cd0404   :COL = wh-nr-dias-ante-cd0404   :COL - 7
           wh-nr-dupdes-cd0404      :COL = wh-nr-dupdes-cd0404      :COL - 7
           wh-per-des-pgan-cd0404   :COL = wh-per-des-pgan-cd0404   :COL - 7
           wh-nr-tab-finan-cd0404   :COL = wh-nr-tab-finan-cd0404   :COL - 7
           wh-nr-ind-finan-cd0404   :COL = wh-nr-ind-finan-cd0404   :COL - 7
           wh-cb-cod-vencto-cd0404  :SIDE-LABEL-HANDLE:COL = wh-cb-cod-vencto-cd0404  :SIDE-LABEL-HANDLE:COL - 7
           wh-dia-mes-base-cd0404   :SIDE-LABEL-HANDLE:COL = wh-dia-mes-base-cd0404   :SIDE-LABEL-HANDLE:COL - 7
           wh-cb-dia-sem-base-cd0404:SIDE-LABEL-HANDLE:COL = wh-cb-dia-sem-base-cd0404:SIDE-LABEL-HANDLE:COL - 7
           wh-dia-mes-venc-cd0404   :SIDE-LABEL-HANDLE:COL = wh-dia-mes-venc-cd0404   :SIDE-LABEL-HANDLE:COL - 7
           wh-cb-dia-sem-venc-cd0404:SIDE-LABEL-HANDLE:COL = wh-cb-dia-sem-venc-cd0404:SIDE-LABEL-HANDLE:COL - 7
           wh-nr-dias-ante-cd0404   :SIDE-LABEL-HANDLE:COL = wh-nr-dias-ante-cd0404   :SIDE-LABEL-HANDLE:COL - 7
           wh-nr-dupdes-cd0404      :SIDE-LABEL-HANDLE:COL = wh-nr-dupdes-cd0404      :SIDE-LABEL-HANDLE:COL - 7
           wh-per-des-pgan-cd0404   :SIDE-LABEL-HANDLE:COL = wh-per-des-pgan-cd0404   :SIDE-LABEL-HANDLE:COL - 7
           wh-nr-tab-finan-cd0404   :SIDE-LABEL-HANDLE:COL = wh-nr-tab-finan-cd0404   :SIDE-LABEL-HANDLE:COL - 7
           wh-nr-ind-finan-cd0404   :SIDE-LABEL-HANDLE:COL = wh-nr-ind-finan-cd0404   :SIDE-LABEL-HANDLE:COL - 7.
END.

IF p-ind-object = "VIEWER"      AND 
   p-ind-event = "BEFORE-INITIALIZE":U AND
   c-objeto    = "v03ad039.w":U THEN DO:
                             
    p-wgh-frame:HEIGHT = p-wgh-frame:HEIGHT + 1.1.
    p-wgh-frame:WIDTH  = p-wgh-frame:WIDTH + 2.
    p-wgh-frame:ROW = p-wgh-frame:ROW + -0.3.

   de-row = 2.92.
   de-col = 7.
   
   create toggle-box wh-log-ativo-verticais
       assign frame      = p-wgh-frame
       width             = 2
       height            = 0.88
       row               = de-row + 1.7
       col               = de-col + 53
       visible           = yes
       sensitive         = NO.
   
   create text tx-label-0-cd0404
       assign frame        = p-wgh-frame
       format              = "x(39)"
       width               = 12
       height              = .75
       screen-value        = "Ativo Verticais"
       row                 = de-row  + 1.7
       col                 = de-col  + 55.3
       visible             = yes.
   
   
   create toggle-box wh-log-ativo-exportacao
       assign frame      = p-wgh-frame
       width             = 2
       height            = 0.88
       row               = de-row  + 2.4
       col               = de-col  + 53
       visible           = yes
       sensitive         = NO.
   
   create text tx-label-1-cd0404
       assign frame        = p-wgh-frame
       format              = "x(39)"
       width               = 12
       height              = .75
       screen-value        = "Ativo Exportacao"
       row                 = de-row  + 2.4
       col                 = de-col  + 55.3
       visible             = yes.
   
   

    CREATE TOGGLE-BOX wh-ativo-canais-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 1.3                   
           LABEL        = "Ativo PCI Distrib.":U
           HELP         = "":U
           COLUMN       = 43                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-revenda-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 16                      
           HEIGHT       = 1.00                    
           ROW          = 2.1                  
           LABEL        = "Ativo PCI Revenda":U
           HELP         = "":U
           COLUMN       = 43                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-ativo-b2b-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 2.9                   
           LABEL        = "Ativo B2B":U
           HELP         = "":U
           COLUMN       = 43                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.           

    CREATE TOGGLE-BOX wh-avalia-credito-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 3.7                    
           LABEL        = "Avalia CrÇdito":U
           HELP         = "Pedidos com esta condiá∆o ser∆o avaliados crÇdito?":U
           COLUMN       = 43                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-tg-cessao-credito-cd0404 
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 4.5                    
           LABEL        = "Cess∆o CrÇdito"        
           COLUMN       = 43                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-tg-carta-credito-cd0404
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 15
           HEIGHT       = 1.00
           ROW          = 5.3
           LABEL        = "Carta CrÇdito"
           COLUMN       = 43
           SENSITIVE    = NO
           VISIBLE      = YES.

    /* Flag do cart∆o Intelbras Clube (SupplierCard) - In°cio */
    CREATE TOGGLE-BOX wh-tg-intelbras-clube-cd0404
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-tg-intelbras-clube-cd0404":U
           WIDTH     = 22.00
           HEIGHT    =  1.00
           COLUMN    = 43
           ROW       = 6.1
           LABEL     = "Cart∆o Intelbras Clube":U
           SENSITIVE = NO
           VISIBLE   = YES.

    CREATE TOGGLE-BOX wh-flex-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 6.9                    
           LABEL        = "Flex":U
           HELP         = "":U
           COLUMN       = 48                      
           SENSITIVE    = NO                      
           VISIBLE      = YES. 


    /* Flag do cart∆o Intelbras Clube (SupplierCard) - Final */


    CREATE TOGGLE-BOX wh-tg-boleto-cd0404
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 20
           HEIGHT       = 1.00
           ROW          = 7.7
           LABEL        = "Emite Boleto Internamente"
           COLUMN       = 43
           SENSITIVE    = NO
           VISIBLE      = YES.
           
    CREATE TEXT tx-boleto-cd0404
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(26)"
            WIDTH        = 18
            SCREEN-VALUE = "(grupo clientes 06 e 08)"
            ROW          = 8.50
            COL          = 43
            VISIBLE      = YES.         

    CREATE TOGGLE-BOX wh-tg-cartao-cd0404
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 20
           HEIGHT       = 1.00
           ROW          = 10.45
           LABEL        = "Transaá∆o com Cart∆o"
           COLUMN       = 43
           SENSITIVE    = NO
           VISIBLE      = YES
           TRIGGERS:                        
               ON VALUE-CHANGED PERSISTENT RUN pi-trata-tg-cartao IN h-upc-cd0404.

           END TRIGGERS.

     CREATE TEXT tx-tipo-cartao-cd0404
     ASSIGN FRAME        = p-wgh-frame
            FORMAT       = "x(12)"
            WIDTH        = 12
            SCREEN-VALUE = "Tipo Cart∆o:"
            ROW          = 11.5
            COL          = 43
            VISIBLE      = YES.         

    CREATE RADIO-SET wh-tipo-cartao-cd0404
    assign frame     = p-wgh-frame
           width     = 11 
           height    = 0.88
           col       = 53 
           row       = 11.3
           horizontal = yes
           radio-buttons = "B2B,1,B2C,2"
           visible   = yes          
           sensitive = no.

    CREATE TOGGLE-BOX wh-ativo-portal-fornec-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 1.3                   
           LABEL        = "Ativo Portal Fornec":U
           HELP         = "":U
           COLUMN       = 60                      
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-tg-enviar-SDCV-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 2.1                    
           LABEL        = "Ativo Ariba":U
           HELP         = "Enviar esta condiá∆o de pagamento para Ariba?":U
           COLUMN       = 60                     
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-log-controla-fft-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 2.8                    
           LABEL        = "Controla FFT":U
           COLUMN       = 60                     
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    

    CREATE TOGGLE-BOX wh-log-ativo-uso-interno-cd0404
    ASSIGN FRAME        = p-wgh-frame             
           WIDTH        = 15                      
           HEIGHT       = 1.00                    
           ROW          = 3.8                    
           LABEL        = "Ativo Uso Interno":U
           COLUMN       = 60                     
           SENSITIVE    = NO                      
           VISIBLE      = YES.                    


    create rectangle wh-retangulo-cd0404
    assign frame        = p-wgh-frame
           height       = 2
           width        = 25
           row          = 10.35
           col          = 41
           visible      = yes
           sensitive    = no
           graphic-edge = yes
           edge-pixels  = 2
           filled       = no.
END.



IF p-ind-event = "DISPLAY" AND
   c-objeto    = "v03ad039.w":U THEN DO:
      
    FIND FIRST cond-pagto WHERE
        ROWID(cond-pagto) = p-row-table NO-ERROR.
   IF AVAIL cond-pagto THEN DO:
       FIND FIRST int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
      IF AVAIL int-cond-pagto THEN DO:
          ASSIGN wh-tg-cartao-cd0404:SCREEN-VALUE             = STRING(int-cond-pagto.transacao-com-cartao).
          IF int-cond-pagto.tipo-trans-cartao = 0 THEN
              ASSIGN wh-tipo-cartao-cd0404:SCREEN-VALUE = "1".
          ELSE
              ASSIGN wh-tipo-cartao-cd0404:SCREEN-VALUE = STRING(int-cond-pagto.tipo-trans-cartao).

          ASSIGN wh-tg-boleto-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,1,1) = "S" THEN "YES" ELSE "NO"
                 wh-tg-carta-credito-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,2,1) = "S" THEN "YES" ELSE "NO"
                 wh-tg-intelbras-clube-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,4,1) = "S" THEN "YES" ELSE "NO" /* Flag do cart∆o Intelbras Clube (SupplierCard) */
                 wh-tg-cessao-credito-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,3,1) = "S" THEN "YES" ELSE "NO"
                 wh-tg-enviar-SDCV-cd0404:SCREEN-VALUE = string(int-cond-pagto.log-sdcv)
                 wh-log-controla-fft-cd0404:SCREEN-VALUE = string(int-cond-pagto.log-controla-fft)
                 wh-log-ativo-uso-interno-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,11,1) = "S" THEN "YES" ELSE "NO"
                 wh-avalia-credito-cd0404:SCREEN-VALUE = IF SUBSTRING(int-cond-pagto.char-1,5,1) = "S" THEN "YES" ELSE "NO"
                 wh-ativo-canais-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,6,1) = "S" THEN YES ELSE NO
                 wh-ativo-b2b-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,7,1) = "S" THEN YES ELSE NO
                 wh-flex-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,8,1) = "S" THEN YES ELSE NO    
                 wh-ativo-portal-fornec-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,9,1) = "S" THEN YES ELSE NO
                 wh-revenda-cd0404:CHECKED = IF SUBSTRING(int-cond-pagto.char-1,10,1) = "S" THEN YES ELSE NO     .
      END.
      ELSE DO:
          ASSIGN wh-tg-cartao-cd0404:SCREEN-VALUE   = "NO"
                 wh-tipo-cartao-cd0404:SCREEN-VALUE = "1"
                 wh-tg-boleto-cd0404:SCREEN-VALUE = "NO"
                 wh-tg-carta-credito-cd0404:SCREEN-VALUE = "NO"
                 wh-tg-intelbras-clube-cd0404:SCREEN-VALUE = "NO" /* Flag do cart∆o Intelbras Clube (SupplierCard) */
                 wh-tg-cessao-credito-cd0404:SCREEN-VALUE = "NO"
                 wh-tg-enviar-SDCV-cd0404:SCREEN-VALUE = "NO"
                 wh-log-controla-fft-cd0404:SCREEN-VALUE = "NO"
                 wh-log-ativo-uso-interno-cd0404:SCREEN-VALUE = "NO"
                 wh-avalia-credito-cd0404:SCREEN-VALUE = "NO"
                 wh-ativo-canais-cd0404:CHECKED = NO
                 wh-ativo-b2b-cd0404:CHECKED = NO
                 wh-flex-cd0404:CHECKED = NO
                 wh-ativo-portal-fornec-cd0404:CHECKED = NO
                 wh-revenda-cd0404:CHECKED = NO.
      END.
   END.

   IF  VALID-HANDLE(wh-tg-intelbras-clube-cd0404) THEN
       ASSIGN l-cond-cartao-cd0404 = wh-tg-intelbras-clube-cd0404:CHECKED.

   IF  VALID-HANDLE(wh-avalia-credito-cd0404) THEN
       ASSIGN l-avalia-credito-cd0404 = wh-avalia-credito-cd0404:CHECKED.

END.



IF p-ind-event = "ASSIGN" AND
   c-objeto    = "v03ad039.w":U THEN DO:
   FIND FIRST cond-pagto WHERE
        ROWID(cond-pagto) = p-row-table NO-ERROR.
   IF AVAIL cond-pagto THEN DO:
       FIND FIRST int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL int-cond-pagto THEN DO:
          CREATE int-cond-pagto.
          ASSIGN int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag.
      END.
      ASSIGN int-cond-pagto.transacao-com-cartao = IF wh-tg-cartao-cd0404:SCREEN-VALUE = "yes" THEN YES ELSE NO
             int-cond-pagto.tipo-trans-cartao    = IF int-cond-pagto.transacao-com-cartao THEN INT(wh-tipo-cartao-cd0404:SCREEN-VALUE) ELSE 0
             overlay(int-cond-pagto.char-1,1,1)  = IF wh-tg-boleto-cd0404:SCREEN-VALUE = "Yes" THEN "S" ELSE "N"
             overlay(int-cond-pagto.char-1,2,1)  = IF wh-tg-carta-credito-cd0404:SCREEN-VALUE = "Yes" THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,4,1)  = IF wh-tg-intelbras-clube-cd0404:SCREEN-VALUE = "Yes" THEN "S" ELSE "N" /* Flag do cart∆o Intelbras Clube (SupplierCard) */
             OVERLAY(int-cond-pagto.char-1,3,1)  = IF wh-tg-cessao-credito-cd0404:SCREEN-VALUE = "YES" THEN "S" ELSE "N"
             int-cond-pagto.log-sdcv             = IF wh-tg-enviar-SDCV-cd0404:SCREEN-VALUE = "YES" THEN YES ELSE NO
             int-cond-pagto.log-controla-fft     = IF wh-log-controla-fft-cd0404:SCREEN-VALUE = "YES" THEN YES ELSE NO
             OVERLAY(int-cond-pagto.char-1,11,1) = IF wh-log-ativo-uso-interno-cd0404:SCREEN-VALUE = "YES" THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,5,1)  = IF wh-avalia-credito-cd0404:SCREEN-VALUE = "YES" THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,6,1)  = IF wh-ativo-canais-cd0404:CHECKED THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,7,1)  = IF wh-ativo-b2b-cd0404:CHECKED THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,8,1)  = IF wh-flex-cd0404:CHECKED THEN "S" ELSE "N"    
             OVERLAY(int-cond-pagto.char-1,9,1)  = IF wh-ativo-portal-fornec-cd0404:CHECKED THEN "S" ELSE "N"
             OVERLAY(int-cond-pagto.char-1,10,1) = IF wh-revenda-cd0404:CHECKED THEN "S" ELSE "N".
   END.

END.

IF p-ind-object = "VIEWER"      AND 
   p-ind-event = "DELETE"       AND 
   c-objeto    = "v02ad039.w":U THEN DO:

   FIND FIRST cond-pagto WHERE
        ROWID(cond-pagto) = p-row-table NO-ERROR.
   IF AVAIL cond-pagto THEN DO:
      FIND FIRST int-cond-pagto 
           WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
      IF AVAIL int-cond-pagto THEN DO:
         DELETE int-cond-pagto.
      END.
   END.
END.

IF p-ind-event = "ENABLE" AND
   c-objeto    = "v03ad039.w":U THEN DO:
     ASSIGN wh-tg-cartao-cd0404:SENSITIVE = YES
            wh-tg-boleto-cd0404:SENSITIVE = YES
            wh-tg-carta-credito-cd0404:SENSITIVE = YES
            wh-tg-intelbras-clube-cd0404:SENSITIVE = YES /* Flag do cart∆o Intelbras Clube (SupplierCard) */
            wh-tg-cessao-credito-cd0404:SENSITIVE = YES
            wh-tg-enviar-SDCV-cd0404:SENSITIVE = YES
            wh-log-controla-fft-cd0404:SENSITIVE = YES
            wh-log-ativo-uso-interno-cd0404:SENSITIVE = YES
            wh-avalia-credito-cd0404:SENSITIVE = YES
            wh-ativo-canais-cd0404:SENSITIVE = YES
            wh-ativo-b2b-cd0404:SENSITIVE = YES
            wh-flex-cd0404:SENSITIVE = YES
            wh-ativo-portal-fornec-cd0404:SENSITIVE = YES
            wh-revenda-cd0404:SENSITIVE = YES.

     IF wh-tg-cartao-cd0404:SCREEN-VALUE = "yes" THEN
         ASSIGN wh-tipo-cartao-cd0404:SENSITIVE = YES.
     ELSE 
         ASSIGN wh-tipo-cartao-cd0404:SENSITIVE = NO.

END.

IF p-ind-event = "DISABLE" AND
    c-objeto    = "v03ad039.w":U THEN DO:
       ASSIGN wh-tg-cartao-cd0404:SENSITIVE = NO
              wh-tipo-cartao-cd0404:SENSITIVE = NO
              wh-tg-boleto-cd0404:SENSITIVE = NO
              wh-tg-carta-credito-cd0404:SENSITIVE = NO
              wh-tg-intelbras-clube-cd0404:SENSITIVE = NO /* Flag do cart∆o Intelbras Clube (SupplierCard) */
              wh-tg-cessao-credito-cd0404:SENSITIVE = NO
              wh-tg-enviar-SDCV-cd0404:SENSITIVE = NO
              wh-log-controla-fft-cd0404:SENSITIVE = NO
              wh-log-ativo-uso-interno-cd0404:SENSITIVE = NO
              wh-avalia-credito-cd0404:SENSITIVE = NO
              wh-ativo-canais-cd0404:SENSITIVE = NO
              wh-ativo-b2b-cd0404:SENSITIVE = NO
              wh-flex-cd0404:SENSITIVE = NO
              wh-ativo-portal-fornec-cd0404:SENSITIVE = NO
              wh-revenda-cd0404:SENSITIVE = NO.
END.

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN
    RUN upc/cd0404-upc.p PERSISTENT SET h-upc-cd0404(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).  


IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-upc-cd0404) THEN
        DELETE PROCEDURE h-upc-cd0404.


PROCEDURE pi-trata-tg-cartao:

    IF wh-tg-cartao-cd0404:SCREEN-VALUE = "yes" THEN
        ASSIGN wh-tipo-cartao-cd0404:SENSITIVE = YES.
    ELSE 
        ASSIGN wh-tipo-cartao-cd0404:SENSITIVE = NO.

END PROCEDURE.

PROCEDURE pi-leave-ativo:
    IF wh-ativo-cd0404:SCREEN-VALUE <> "Sim" THEN
        ASSIGN wh-ativo-canais-cd0404:CHECKED          = NO
               wh-revenda-cd0404:CHECKED               = NO
               wh-ativo-b2b-cd0404:CHECKED             = NO
               wh-ativo-b2b-cd0404:SENSITIVE           = NO
               wh-ativo-canais-cd0404:SENSITIVE        = NO
               wh-revenda-cd0404:SENSITIVE             = NO 
               wh-ativo-portal-fornec-cd0404:CHECKED   = NO
               wh-ativo-portal-fornec-cd0404:SENSITIVE = NO.
    ELSE 
        ASSIGN wh-ativo-b2b-cd0404:SENSITIVE           = YES
               wh-ativo-canais-cd0404:SENSITIVE        = YES
               wh-revenda-cd0404:SENSITIVE             = YES 
               wh-ativo-portal-fornec-cd0404:SENSITIVE = YES.
END PROCEDURE.

procedure pi-folders:
    if not valid-handle(adm-broker-hdl)
    then return.

    run get-link-handle in adm-broker-hdl(input  p-wgh-object,
                                          input  "PAGE-SOURCE":U,
                                          output c-folder).

    assign h-folder = handle(c-folder) no-error.

    if not valid-handle(h-folder)
    then return.

    run get-attribute in h-folder(input "Folder-labels":U).

    assign i-cont = num-entries(return-value,"|") + 1.

    run create-folder-page  in h-folder(input i-cont,
                                        input "Estados":U).
    run create-folder-label in h-folder(input i-cont,
                                        input "Estados":U).

    run select-page in p-wgh-object(input i-cont).

    run init-object in p-wgh-object(input  "upc/cd0404-upc-b01.w":U,
                                    input  p-wgh-frame,
                                    input  'Initial-Lock = NO-LOCK,
                                            Hide-on-Init = no,
                                            Disable-on-Init = no,
                                            Layout = ,
                                            Create-On-Add = ?,
                                            ProgAtributo = ,
                                            ProgIncMod = upc/cd0404-upca.w,
                                            MessageNum = 0,
                                            MessageParam = ':U ,
                                    output h-cd0404-upc-b01).

    run set-position in h-cd0404-upc-b01 (7,6).

    run get-link-handle in adm-broker-hdl (input  p-wgh-object,
                                           input  "CONTAINER-TARGET":U,
                                           output c-obj-aux).

    do i-aux = 1 to num-entries(c-obj-aux):
        assign h-objeto = widget-handle(entry(i-aux, c-obj-aux)).

        if index(h-objeto:private-data, "q01ad039") <> 0
        then do:
             run add-link in adm-broker-hdl (input h-objeto,
                                             input "Record":U,
                                             input h-cd0404-upc-b01).

             leave.
        end.
    end. 

    run dispatch in h-cd0404-upc-b01 ("initialize":U).

    run create-folder-page  in h-folder(input i-cont + 1,
                                        input "Produtos":U).
    run create-folder-label in h-folder(input i-cont + 1,
                                        input "Produtos":U).

    run select-page in p-wgh-object(input i-cont + 1).

    run init-object in p-wgh-object(input  "upc/cd0404-upc-b02.w":U,
                                    input  p-wgh-frame,
                                    input  'Initial-Lock = NO-LOCK,
                                            Hide-on-Init = no,
                                            Disable-on-Init = no,
                                            Layout = ,
                                            Create-On-Add = ?,
                                            ProgAtributo = ,
                                            ProgIncMod = upc/cd0404-upcb.w,
                                            MessageNum = 0,
                                            MessageParam = ':U ,
                                    output h-cd0404-upc-b02).

    run set-position in h-cd0404-upc-b02 (7,6).

    run add-link in adm-broker-hdl (input h-objeto,
                                    input "Record":U,
                                    input h-cd0404-upc-b02).

    run dispatch in h-cd0404-upc-b02 ("initialize":U).
    
    run select-page in p-wgh-object (input 1).
end procedure. /* procedure pi-folders */

